//======================================================================================================================
//
// devtlb_fifo.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 9/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
// This block implements one DEVTLB FIFO which buffers and credits new requests.
//
//======================================================================================================================

`ifndef HQM_DEVTLB_CBFIFO_VS
`define HQM_DEVTLB_CBFIFO_VS

`include "hqm_devtlb_pkg.vh"

module hqm_devtlb_cbfifo (
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST
   PwrDnOvrd_nnnH,
   DeftrStallCBFifo,
   
   ReqVal_1n1H,
   Req_1n1H,
   CreditReturn_1nnH,

   FifoPipeV_100H,
   FifoReq_100H,
   FifoGnt_100H
//lintra +68099
);

import `HQM_DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the DEVTLB

parameter logic NO_POWER_GATING = 1'b0;
parameter int FIFO_DEPTH = 1;
parameter type T_REQ = logic;

// Add one to allow a FIFO_DEPTH that is a power of 2
// need to count 0....N, not just 0...N-1.
//
localparam COUNTER_WIDTH = `HQM_DEVTLB_LOG2(FIFO_DEPTH);  //TODO hm: removed the "+1" , check again??


//======================================================================================================================
//                                           Interface signal declarations
//======================================================================================================================
   // Interface to DEVTLB top level
   //
   `HQM_DEVTLB_COMMON_PORTDEC
   `HQM_DEVTLB_FSCAN_PORTDEC
   input  logic           PwrDnOvrd_nnnH;       // Powerdown override
   input  logic           DeftrStallCBFifo;
   input  logic           ReqVal_1n1H;          // Request valid from primary inputs
   input  T_REQ           Req_1n1H;
   output logic           CreditReturn_1nnH;    // Credit return

   // Interface to TLB arbiter
   //
   output logic           FifoPipeV_100H;         // request to pipeline
   output T_REQ           FifoReq_100H;
   input  logic           FifoGnt_100H;           // Grant from TLB arbiter


//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================

// Signals for clock generation
//
logic                         ClkFifoH;                              // Clock gated for FIFO
logic                         fEn_ClkFifoAllocH [FIFO_DEPTH-1:0];    // Clock gated for allocation into FIFO
logic                         ClkFifoAllocH     [FIFO_DEPTH-1:0];    // Clock gated for allocation into FIFO
                                                                 

logic                         FifoLpEn_1nnH;                         // Enable for main gated clock
                                                                 
// Signals for crediting                                         
//                                                               
logic [COUNTER_WIDTH:0]     Credits_1nnH;                          // Credit counter
logic [COUNTER_WIDTH:0]     CreditsNew_1nnH;                       //

// Signals for data path
//
T_REQ                         Fifo_1nnH         [FIFO_DEPTH-1:0];    // Main storage

logic [COUNTER_WIDTH-1:0]     FifoHead_1nnH;                         // Head pointer
logic [COUNTER_WIDTH-1:0]     FifoHeadNew_1nnH;                      // 

logic [COUNTER_WIDTH-1:0]     FifoTail_1nnH;                         // Tail pointer
logic [COUNTER_WIDTH-1:0]     FifoTailNew_1nnH;                      // 

logic                         FifoEmpty_1nnH, FifoAvail_1nnH;        // Fifo is empty 
logic                         FifoFull_1nnH;                         // Fifo is full
logic                         FifoAlloc_1n1H;                        // allocation
logic                         FifoDealloc_100H;                      // deallocation


genvar g_fifoentry;

//======================================================================================================================
//                                                     Clocking
//======================================================================================================================

logic ClkFifoRcb_H;
`HQM_DEVTLB_MAKE_RCB_PH1(ClkFifoRcb_H, clk, FifoLpEn_1nnH, PwrDnOvrd_nnnH)

always_comb begin: Fifo_Clocks

   // The FIFO is gated if there is no new request or if the FIFO is empty.
   //
   FifoLpEn_1nnH = ReqVal_1n1H | FifoAvail_1nnH | (~(Credits_1nnH=='0)) | CreditReturn_1nnH | reset;

end: Fifo_Clocks

   `HQM_DEVTLB_MAKE_LCB_PWR(ClkFifoH,       ClkFifoRcb_H, FifoLpEn_1nnH,  PwrDnOvrd_nnnH)

generate
   for (g_fifoentry = 0; g_fifoentry < FIFO_DEPTH; g_fifoentry++) begin  : Fifo_Entry_Clock

      assign fEn_ClkFifoAllocH[g_fifoentry] = (ReqVal_1n1H & (FifoTail_1nnH == g_fifoentry) & ~FifoFull_1nnH) | reset;

      if (NO_POWER_GATING) begin : CLOCK_GATE_OVERRIDE
                                 // when no power gating is on modify fifo write to eliminate functional
                                 // clock gates...NO_POWER_GATING turns the PWR clock gate into a buffer
                                 // Flops driven by this clock need to be changed into enable flops
                                 // to support this change
         `HQM_DEVTLB_MAKE_LCB_PWR (ClkFifoAllocH[g_fifoentry], ClkFifoRcb_H, 1'b1, 1'b1)
      end else begin : CLOCK_GATE_NORMAL
         `HQM_DEVTLB_MAKE_LCB_FUNC(ClkFifoAllocH[g_fifoentry], ClkFifoRcb_H, fEn_ClkFifoAllocH[g_fifoentry])
      end
   end
endgenerate


//======================================================================================================================
//                                                   Credit logic
//======================================================================================================================

always_comb begin: Credits

   // Compute next value of credit counter. The credit counter resets to zero with assumption that external logic resets
   // to state where it is holding max credits.
   //
   // Increment credits when a new request is received and allocates into the credit buffer. Decrement and return credit
   // when a request from the credit buffer wins into the TLB arbiter and deallocates.
   //
   
   // Detect empty condition.
   //
   FifoFull_1nnH     = (Credits_1nnH == FIFO_DEPTH);
   
   FifoAlloc_1n1H    = ReqVal_1n1H & ~FifoFull_1nnH;
   FifoDealloc_100H  = FifoGnt_100H;

   unique casez ({FifoAlloc_1n1H,FifoDealloc_100H})
      2'b01    : CreditsNew_1nnH = Credits_1nnH - `HQM_DEVTLB_ZX(1'b1,COUNTER_WIDTH+1);
      2'b10    : CreditsNew_1nnH = Credits_1nnH + `HQM_DEVTLB_ZX(1'b1,COUNTER_WIDTH+1);
      default  : CreditsNew_1nnH = Credits_1nnH;
   endcase

end: Credits

`HQM_DEVTLB_RST_MSFF(CreditReturn_1nnH, FifoDealloc_100H, ClkFifoH, reset)
`HQM_DEVTLB_RST_MSFF(Credits_1nnH, CreditsNew_1nnH, ClkFifoH, reset)
`HQM_DEVTLB_RST_MSFF(FifoAvail_1nnH, ((~DeftrStallCBFifo) && ~(CreditsNew_1nnH=='0)), ClkFifoH, reset)

// Stage credit return to isolate from req/gnt logic
//
//`DEVTLB_RST_MSFF(CreditReturn_1nnH, FifoDealloc_100H, ClkFifoH, reset)


//======================================================================================================================
//                                                FIFO
//======================================================================================================================

always_comb begin: Fifo

   // Compute next head and tail pointers.
   //
   FifoHeadNew_1nnH = (FifoHead_1nnH == (FIFO_DEPTH - 1)) ? '0 : (FifoHead_1nnH + `HQM_DEVTLB_ZX(1'b1,$bits(FifoHead_1nnH)));
   FifoTailNew_1nnH = (FifoTail_1nnH == (FIFO_DEPTH - 1)) ? '0 : (FifoTail_1nnH + `HQM_DEVTLB_ZX(1'b1,$bits(FifoTail_1nnH)));

   // Dispath new request to TLB arbiter from head of FIFO.
   //
   FifoPipeV_100H = FifoAvail_1nnH;
   FifoEmpty_1nnH = ~FifoAvail_1nnH; 
   FifoReq_100H   = Fifo_1nnH[FifoHead_1nnH];

end: Fifo

`HQM_DEVTLB_EN_RST_MSFF(FifoHead_1nnH, FifoHeadNew_1nnH, ClkFifoH, FifoDealloc_100H, reset)
`HQM_DEVTLB_EN_RST_MSFF(FifoTail_1nnH, FifoTailNew_1nnH, ClkFifoH, FifoAlloc_1n1H,   reset)

generate
   for (g_fifoentry = 0; g_fifoentry < FIFO_DEPTH; g_fifoentry++) begin  : Fifo_Entry

      if (NO_POWER_GATING) begin : EN_MSFF_W_FREE_CLOCK
                                // when no power gating is on modify LRU write to eliminate functional
                                // clock gates...NO_POWER_GATING turns the PWR clock gate into a buffer
         `HQM_DEVTLB_EN_RST_MSFF(Fifo_1nnH[g_fifoentry], Req_1n1H, ClkFifoAllocH[g_fifoentry], fEn_ClkFifoAllocH[g_fifoentry], reset)
      end else begin : MSFF_W_CLOCK_GATE
         `HQM_DEVTLB_RST_MSFF   (Fifo_1nnH[g_fifoentry], Req_1n1H, ClkFifoAllocH[g_fifoentry], reset)
      end
   end
endgenerate

//======================================================================================================================
//                                                Assertions
//======================================================================================================================

`ifndef HQM_DEVTLB_SVA_OFF

`HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_Fifo_Credit_Count_Range,
   Credits_1nnH > FIFO_DEPTH, posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("DEVTLB credit count is greater than the FIFO depth."));

/* FPV don't like negedge clk triggering on this assertion
Jason: This has to do with how FPV generates input stimulus for a design with latches.  Having latches requires that the clock be defined as “clk -both_edges”.   This clk definition then allows FPV to change the input pin values at both edges.   So when the xreq queue has filled, FPV will leave xreq_valid asserted until the negedge of clk, and then deassert it.   But since the assertion is checking on both edges, that causes the assertion to fire a half-clock before it needs to.
*/
`HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_Fifo_XREQNOCRDT,
   FifoFull_1nnH & ReqVal_1n1H, posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("XREQ is dropped due to Out of Credit. Check XREQ credit"));

`HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_Fifo_Overflow,
   FifoFull_1nnH & FifoAlloc_1n1H & ~FifoDealloc_100H, posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("DEVTLB FIFO overflow."));

`HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_Fifo_Underflow,
   FifoEmpty_1nnH & FifoDealloc_100H & ~FifoAlloc_1n1H, posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("DEVTLB FIFO underflow."));

`HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(DEVTLB_Fifo_DeftrStallCBFifo_Defeature_Stalls_Fifo, 
   DeftrStallCBFifo, 1,
   ~FifoPipeV_100H, posedge clk, reset_INST, 
`HQM_DEVTLB_ERR_MSG("DeftrStallCBFifo defeature did not stall fifo."));

`endif

endmodule

`endif // DEVTLB_CBFIFO_VS
