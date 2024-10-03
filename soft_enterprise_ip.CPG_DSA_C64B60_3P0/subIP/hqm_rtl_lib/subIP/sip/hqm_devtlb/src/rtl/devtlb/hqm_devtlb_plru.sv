//=====================================================================================================================
//
// iommu_lru.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_DEVTLB_PLRU_VS
`define HQM_DEVTLB_PLRU_VS

//`include "devtlb_pkg.vh"

module hqm_devtlb_plru
#(
   parameter         logic NO_POWER_GATING= 1'b0,
   parameter         int XREQ_PORTNUM     = 1,
   parameter         int NUM_PIPE_STAGE   = 1,        // Minimum 1
   parameter         int NUM_SETS         = 16,       // Minimum 2....MUST correlate to the SET_ADDR_WIDTH
   parameter         int NUM_WAYS         = 4         // Minimum 1         
)(
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST
   PwrDnOvrd_nnnH,        // Powerdown override

   RdSetAddr_nnnH,
   RdEn_nnnH,
   RdEnSpec_nnnH,
   RdInvert_nn1H,
   RdWayVec_nn1H,
   RdWay2ndVec_nn1H,

   WrEn_nnnH,
   WrSetAddr_nnnH,
   WrHitVec_nnnH,
   WrRepVec_nnnH,

   Disable_Ways
//lintra +68099
);

//import `DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the IOMMU

localparam  int SET_ADDR_WIDTH      = `HQM_DEVTLB_LOG2(NUM_SETS);      

//============================================================================
// I/O Declarations
//============================================================================

   `HQM_DEVTLB_COMMON_PORTDEC
   `HQM_DEVTLB_FSCAN_PORTDEC
   input    logic                               PwrDnOvrd_nnnH;        // Powerdown override

   //==================================================================================================================
   //
   // Primary interface to/from hosting unit
   //
   //==================================================================================================================

   // Read Interface
   //
   input    logic    [SET_ADDR_WIDTH-1:0]       RdSetAddr_nnnH;
   input    logic                               RdEn_nnnH;
   input    logic                               RdEnSpec_nnnH; // Used to fire clocks
   input    logic                               RdInvert_nn1H; // Invert bit0 for B2B Write selection
   output   logic    [NUM_WAYS-1:0]             RdWayVec_nn1H;
   output   logic    [NUM_WAYS-1:0]             RdWay2ndVec_nn1H; // 2nd LRU

   // Write Interface
   //
   input    logic    [XREQ_PORTNUM-1:0]                           WrEn_nnnH;
   input    logic    [XREQ_PORTNUM-1:0][SET_ADDR_WIDTH-1:0]       WrSetAddr_nnnH;
   input    logic    [XREQ_PORTNUM-1:0][NUM_WAYS-1:0]             WrHitVec_nnnH;
   input    logic    [XREQ_PORTNUM-1:0][NUM_WAYS-1:0]             WrRepVec_nnnH;

   input    logic    [1:0]                      Disable_Ways;

//============================================================================
// Internal Declarations
//============================================================================

   // Local Read Controls
   //
   logic       [SET_ADDR_WIDTH-1:0]             RdSetAddr_nn1H;

   // Clock Nodes
   //
   logic       [XREQ_PORTNUM-1:0][NUM_SETS-1:0]                   fEn_ClkWrLRU_nn1H;   // LCB for write operations
   logic                             [NUM_SETS-1:0]                   ClkWrLRU_nn1H;       // LCB for write operations
   logic                             [NUM_SETS-1:0]                   fEn_ClkWrLRUInt_nn1H;// LCB for write operations
   logic                                        ClkWrRcb_nnnH;
   logic                                        ClkWrRcbEn_nnnH;     // enable for RCB 

   logic                                        ClkRd_nn1H;

   logic       [NUM_PIPE_STAGE-1:0]             StgRdEn_nnnH;
   logic       [NUM_WAYS-2:0]                   IntRdData_nnnH [NUM_PIPE_STAGE:1];
   logic       [NUM_WAYS-2:0]                   RdData_nn1H;
   logic       [NUM_WAYS-2:0]                   Rd2ndData_nn1H;


   // Array Declaration
   //
   logic       [NUM_SETS-1:0][NUM_WAYS-2:0]     Array_nnnH;          // Array Storage Nodes

   logic       [XREQ_PORTNUM-1:0][NUM_SETS-1:0][NUM_WAYS-2:0]     WrMask_nnnH;
   logic       [XREQ_PORTNUM-1:0][NUM_SETS-1:0][NUM_WAYS-2:0]     WrData_nnnH;
   logic                         [NUM_SETS-1:0][NUM_WAYS-2:0]     WrMaskInt_nnnH;
   logic                         [NUM_SETS-1:0][NUM_WAYS-2:0]     WrDataInt_nnnH;

//   logic                                        ClkWrFree_H;
   logic                                        ClkWr_nn1H;
   logic       [XREQ_PORTNUM-1:0]                                 WrEn_nn1H;
   logic       [XREQ_PORTNUM-1:0][NUM_WAYS-1:0]                   WrVec_nnnH;

   genvar g_set;
   genvar g_bit;

//============================================================================
// Array Read
//============================================================================
   logic ClkRdRcb_H;
   `HQM_DEVTLB_MAKE_RCB_PH1(ClkRdRcb_H, clk,        RdEnSpec_nnnH | (|StgRdEn_nnnH), PwrDnOvrd_nnnH)

   `HQM_DEVTLB_MAKE_LCB_PWR(ClkRd_nn1H, ClkRdRcb_H, RdEnSpec_nnnH, PwrDnOvrd_nnnH)

   // Stage read set address and read array
   //
   `HQM_DEVTLB_MSFF    (RdSetAddr_nn1H, RdSetAddr_nnnH, ClkRd_nn1H)

   always_comb begin
      IntRdData_nnnH[1]     = (NUM_SETS > 1) ? Array_nnnH[RdSetAddr_nn1H] : Array_nnnH[0]; // lintra s-0241 SetAddr stop at 332

      // For B2B Writes to the same set, invert the LRU selection to choose another way 
      // Not applied if Disable_Ways defeature is used
      //
      if (RdInvert_nn1H)         IntRdData_nnnH[1][0] = ~IntRdData_nnnH[1][0];

      // If ways are defeatured, force the LRU RdData to point to the desired ways
      //
      // Half-Disabled: The selected bit controls the high/low half LRU steering
      if (Disable_Ways == 2'b10) IntRdData_nnnH[1][0] = 1'b0;

      // Quarder-Disabled: The selected bit controls the high/low half selection within the upper half of the LRU steering
      //
      if (Disable_Ways == 2'b01) IntRdData_nnnH[1][(NUM_WAYS >=4) ? NUM_WAYS/2 : 0] = 1'b0;
   end



generate
   genvar g_stage;

   if (NUM_PIPE_STAGE>1)  begin : Extra_Latency
         logic       [NUM_PIPE_STAGE:2]                           ClkStgRd_nnnH;

         logic ClkStagedRd_H;

         `HQM_DEVTLB_MAKE_LCB_PWR(ClkStagedRd_H, ClkRdRcb_H, 1'b1, PwrDnOvrd_nnnH)

         assign StgRdEn_nnnH[0] =   RdEn_nnnH;

         for(g_stage = 1; g_stage < NUM_PIPE_STAGE; g_stage++) begin: For_stage 
            `HQM_DEVTLB_MSFF(StgRdEn_nnnH[g_stage],  StgRdEn_nnnH[g_stage-1],   ClkStagedRd_H)

            `HQM_DEVTLB_MAKE_LCB_PWR(ClkStgRd_nnnH[g_stage+1], ClkRdRcb_H, StgRdEn_nnnH[g_stage], PwrDnOvrd_nnnH)

            `HQM_DEVTLB_MSFF(IntRdData_nnnH[g_stage+1], IntRdData_nnnH[g_stage], ClkStgRd_nnnH[g_stage+1])
         end
   end else begin : Latency1
      assign StgRdEn_nnnH = '0;
   end

   assign   RdData_nn1H =  IntRdData_nnnH[NUM_PIPE_STAGE];

endgenerate

   always_comb begin
        Rd2ndData_nn1H = RdData_nn1H;
        Rd2ndData_nn1H[0] = ~RdData_nn1H[0];
    end

generate
   if (NUM_WAYS == 2) begin: NUM_WAYS_RD_2
         assign   RdWayVec_nn1H  = f_LRU_2_WayVec_2Ways(RdData_nn1H);
         assign   RdWay2ndVec_nn1H  = f_LRU_2_WayVec_2Ways(Rd2ndData_nn1H);
   end

   if (NUM_WAYS == 4) begin: NUM_WAYS_RD_4
         assign   RdWayVec_nn1H  = f_LRU_2_WayVec_4Ways(RdData_nn1H);
         assign   RdWay2ndVec_nn1H  = f_LRU_2_WayVec_4Ways(Rd2ndData_nn1H);
   end

   if (NUM_WAYS == 8) begin: NUM_WAYS_RD_8
         assign   RdWayVec_nn1H  = f_LRU_2_WayVec_8Ways(RdData_nn1H);
         assign   RdWay2ndVec_nn1H  = f_LRU_2_WayVec_8Ways(Rd2ndData_nn1H);
   end

   if (NUM_WAYS == 16) begin: NUM_WAYS_RD_16
         assign   RdWayVec_nn1H  = f_LRU_2_WayVec_16Ways(RdData_nn1H);
         assign   RdWay2ndVec_nn1H  = f_LRU_2_WayVec_16Ways(Rd2ndData_nn1H);
   end

   if (NUM_WAYS == 32) begin: NUM_WAYS_RD_32
         assign   RdWayVec_nn1H  = f_LRU_2_WayVec_32Ways(RdData_nn1H);
         assign   RdWay2ndVec_nn1H  = f_LRU_2_WayVec_32Ways(Rd2ndData_nn1H);
   end

   if (NUM_WAYS == 64) begin: NUM_WAYS_RD_64
         assign   RdWayVec_nn1H  = f_LRU_2_WayVec_64Ways(RdData_nn1H);
         assign   RdWay2ndVec_nn1H  = f_LRU_2_WayVec_64Ways(Rd2ndData_nn1H);
   end

   if (NUM_WAYS == 128) begin: NUM_WAYS_RD_128
         assign   RdWayVec_nn1H  = f_LRU_2_WayVec_128Ways(RdData_nn1H);
         assign   RdWay2ndVec_nn1H  = f_LRU_2_WayVec_128Ways(Rd2ndData_nn1H);
   end
endgenerate

//============================================================================
// Array Write
//============================================================================

assign ClkWrRcbEn_nnnH = (|WrEn_nnnH) || (|WrEn_nn1H);

`HQM_DEVTLB_MAKE_RCB_PH1(ClkWrRcb_nnnH,  clk,           ClkWrRcbEn_nnnH, PwrDnOvrd_nnnH)
`HQM_DEVTLB_MAKE_LCB_PWR(ClkWr_nn1H,     clk,           ClkWrRcbEn_nnnH, PwrDnOvrd_nnnH)

always_comb begin
   for (int p = 0; p < XREQ_PORTNUM;p++) begin
        priority casez (1'b1) 
            (&WrRepVec_nnnH[p])      : WrVec_nnnH[p] = '1;  // Reset/Inval
            (~|WrHitVec_nnnH[p])     : WrVec_nnnH[p] = WrRepVec_nnnH[p];    // Miss & Replace
            (|WrHitVec_nnnH[p])      : WrVec_nnnH[p] = WrHitVec_nnnH[p];    // Hit
            default                  : WrVec_nnnH[p] = '0;  //TODO Assert error
        endcase
    end
end


generate
   for (genvar port_id = 0; port_id < XREQ_PORTNUM; port_id++) begin: TLB_NUM_PORTS      
      `HQM_DEVTLB_MSFF(WrEn_nn1H[port_id],       WrEn_nnnH[port_id],        ClkWr_nn1H)
   end
endgenerate


// Generate entry specific write clock
//
generate
   for (genvar g_id = 0; g_id < XREQ_PORTNUM;g_id++) begin: EnClkWr_TLB_PORTS      
      for (g_set = 0;  g_set < NUM_SETS; g_set++) begin  : EnClkWr_Set_Lp

         // Enable only when set address is a match or there is only 1 set
         //
         assign fEn_ClkWrLRU_nn1H[g_id][g_set] = WrEn_nnnH[g_id] & ((WrSetAddr_nnnH[g_id] == g_set) || (NUM_SETS == 1));

      end
   end
endgenerate

// Roll the port id specific WrMask and WrData into one intermediate signal
//
always_comb begin
   fEn_ClkWrLRUInt_nn1H = '0;
   for (int g_id = 0; g_id < XREQ_PORTNUM; g_id++) begin: Roll_NUM_PORTS
      fEn_ClkWrLRUInt_nn1H |= fEn_ClkWrLRU_nn1H[g_id];
   end
end

// Generate entry specific write clock
//
generate
//   for (genvar g_id = 0; g_id < XREQ_PORTNUM;g_id++) begin: ClkWr_TLB_PORTS      
      for (g_set = 0;  g_set < NUM_SETS; g_set++) begin  : ClkWr_Set_Lp

         if (NO_POWER_GATING) begin : CLOCK_GATE_OVERRIDE
                                    // when no power gating is on modify state write to eliminate functional
                                    // clock gates...NO_POWER_GATING turns the PWR clock gate into a buffer
                                    // Flops driven by this clock need to be changed into enable flops
                                    // to support this change
               `HQM_DEVTLB_MAKE_LCB_PWR(ClkWrLRU_nn1H[g_set], ClkWrRcb_nnnH, 1'b1, 1'b1)
         end else begin : CLOCK_GATE_NORMAL
               `HQM_DEVTLB_MAKE_LCB_FUNC(ClkWrLRU_nn1H[g_set], clk, fEn_ClkWrLRUInt_nn1H[g_set])
         end
      end
//   end
endgenerate

generate
   for (genvar g_id = 0; g_id < XREQ_PORTNUM;g_id++) begin: Wr_TLB_PORTS      
   if (NUM_WAYS == 2) begin: NUM_WAYS_WR_2
      always_comb begin
            WrMask_nnnH[g_id] = '0;
            WrData_nnnH[g_id] = '0;
            WrMask_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '1: f_WayVec_2_LRUWrMask_2Ways(WrVec_nnnH[g_id]);
            WrData_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '0: f_WayVec_2_LRUWrData_2Ways(WrVec_nnnH[g_id]);
      end
   end

   if (NUM_WAYS == 4) begin: NUM_WAYS_WR_4
      always_comb begin
            WrMask_nnnH[g_id] = '0;
            WrData_nnnH[g_id] = '0;
            WrMask_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '1: f_WayVec_2_LRUWrMask_4Ways(WrVec_nnnH[g_id]);
            WrData_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '0: f_WayVec_2_LRUWrData_4Ways(WrVec_nnnH[g_id]);
      end
   end

   if (NUM_WAYS == 8) begin: NUM_WAYS_WR_8
      always_comb begin
            WrMask_nnnH[g_id] = '0;
            WrData_nnnH[g_id] = '0;
            WrMask_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '1: f_WayVec_2_LRUWrMask_8Ways(WrVec_nnnH[g_id]); // lintra s-0241 SetAddr stop at 332
            WrData_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '0: f_WayVec_2_LRUWrData_8Ways(WrVec_nnnH[g_id]); // lintra s-0241 SetAddr stop at 332
      end
   end

   if (NUM_WAYS == 16) begin: NUM_WAYS_WR_16
      always_comb begin
            WrMask_nnnH[g_id] = '0;
            WrData_nnnH[g_id] = '0;
            WrMask_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '1: f_WayVec_2_LRUWrMask_16Ways(WrVec_nnnH[g_id]); // lintra s-0241 SetAddr stop at 332
            WrData_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '0: f_WayVec_2_LRUWrData_16Ways(WrVec_nnnH[g_id]); // lintra s-0241 SetAddr stop at 332
      end
   end

   if (NUM_WAYS == 32) begin: NUM_WAYS_WR_32
      always_comb begin
            WrMask_nnnH[g_id] = '0;
            WrData_nnnH[g_id] = '0;
            WrMask_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '1: f_WayVec_2_LRUWrMask_32Ways(WrVec_nnnH[g_id]); // lintra s-0241 SetAddr stop at 332
            WrData_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '0: f_WayVec_2_LRUWrData_32Ways(WrVec_nnnH[g_id]); // lintra s-0241 SetAddr stop at 332
      end
   end

   if (NUM_WAYS == 64) begin: NUM_WAYS_WR_64
      always_comb begin
            WrMask_nnnH[g_id] = '0;
            WrData_nnnH[g_id] = '0;
            WrMask_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '1: f_WayVec_2_LRUWrMask_64Ways(WrVec_nnnH[g_id]);// lintra s-0241 SetAddr stop at 332
            WrData_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '0: f_WayVec_2_LRUWrData_64Ways(WrVec_nnnH[g_id]);// lintra s-0241 SetAddr stop at 332
      end
   end

   if (NUM_WAYS == 128) begin: NUM_WAYS_WR_128
      always_comb begin
            WrMask_nnnH[g_id] = '0;
            WrData_nnnH[g_id] = '0;
            WrMask_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '1: f_WayVec_2_LRUWrMask_128Ways(WrVec_nnnH[g_id]);// lintra s-0241 SetAddr stop at 332
            WrData_nnnH[g_id][WrSetAddr_nnnH[g_id]] = (&WrVec_nnnH[g_id])? '0: f_WayVec_2_LRUWrData_128Ways(WrVec_nnnH[g_id]);// lintra s-0241 SetAddr stop at 332
      end
   end
   end // Wr_TLB_PORTS
endgenerate

// Roll the port id specific WrMask and WrData into one intermediate signal
//
always_comb begin
   WrMaskInt_nnnH       = '0;
   WrDataInt_nnnH       = '0;
   for (int g_id = 0; g_id < XREQ_PORTNUM; g_id++) begin: Roll_NUM_PORTS
      WrMaskInt_nnnH       |= WrMask_nnnH[g_id];
      WrDataInt_nnnH       |= WrData_nnnH[g_id];
   end
end

// Generate entry specfic clocks based on write set address and write bit vector if a write is indicated
//
generate
   for (g_set = 0;  g_set < NUM_SETS; g_set++) begin  : Array_Set_Lp
      for (g_bit = 0;  g_bit < NUM_WAYS-1; g_bit++) begin  : Array_Bit_Lp
         // Write selected array entry(ies) with entry specific clock
         //
         if (NO_POWER_GATING) begin : EN_MSFF_W_FREE_CLOCK
                                  // when no power gating is on, modify state write to eliminate several
                                  // functional clock gates...use enables instead
            `HQM_DEVTLB_EN_MSFF(Array_nnnH[g_set][g_bit], WrDataInt_nnnH[g_set][g_bit], ClkWrLRU_nn1H[g_set], fEn_ClkWrLRUInt_nn1H[g_set] & WrMaskInt_nnnH[g_set][g_bit])
         end else begin : MSFF_W_CLOCK_GATE
            `HQM_DEVTLB_EN_MSFF(Array_nnnH[g_set][g_bit], WrDataInt_nnnH[g_set][g_bit], ClkWrLRU_nn1H[g_set], WrMaskInt_nnnH[g_set][g_bit])
         end
      end
   end
endgenerate


//============================================================================
// LRU 2 WayVec Functions
//============================================================================

// Parent LRU-to-Replacement Vector
//
// These functions use elemental functions built from the bottom up from a 2 way LRU.
// It could probably be parameterized into a recursive form.
//
function automatic logic [1:0] f_LRU_2_WayVec_2Ways;
   input [0:0] LRUOut;

   unique casez (LRUOut[0])
      1'b0     : f_LRU_2_WayVec_2Ways  = 2'b01;
      default  : f_LRU_2_WayVec_2Ways  = 2'b10;
   endcase
endfunction

function automatic logic [3:0] f_LRU_2_WayVec_4Ways;
   input [2:0] LRUOut;

   unique casez (LRUOut[0])
      1'b0     : f_LRU_2_WayVec_4Ways  = {2'b0,f_LRU_2_WayVec_2Ways(LRUOut[1])};
      default  : f_LRU_2_WayVec_4Ways  = {f_LRU_2_WayVec_2Ways(LRUOut[2]),2'b0};
   endcase
endfunction

function automatic logic [7:0] f_LRU_2_WayVec_8Ways;
   input [6:0] LRUOut;

   unique casez (LRUOut[0])
      1'b0     : f_LRU_2_WayVec_8Ways  = {4'b0,f_LRU_2_WayVec_4Ways(LRUOut[3:1])};
      default  : f_LRU_2_WayVec_8Ways  = {f_LRU_2_WayVec_4Ways(LRUOut[6:4]),4'b0};
   endcase
endfunction

function automatic logic [15:0] f_LRU_2_WayVec_16Ways;
   input [14:0] LRUOut;

   unique casez (LRUOut[0])
      1'b0     : f_LRU_2_WayVec_16Ways  = {8'b0,f_LRU_2_WayVec_8Ways(LRUOut[7:1])};
      default  : f_LRU_2_WayVec_16Ways  = {f_LRU_2_WayVec_8Ways(LRUOut[14:8]),8'b0};
   endcase
endfunction

function automatic logic [31:0] f_LRU_2_WayVec_32Ways;
   input [30:0] LRUOut;

   unique casez (LRUOut[0])
      1'b0     : f_LRU_2_WayVec_32Ways  = {16'b0,f_LRU_2_WayVec_16Ways(LRUOut[15:1])};
      default  : f_LRU_2_WayVec_32Ways  = {f_LRU_2_WayVec_16Ways(LRUOut[30:16]),16'b0};
   endcase
endfunction

function automatic logic [63:0] f_LRU_2_WayVec_64Ways;
   input [62:0] LRUOut;

   unique casez (LRUOut[0])
      1'b0     : f_LRU_2_WayVec_64Ways  = {32'b0,f_LRU_2_WayVec_32Ways(LRUOut[31:1])};
      default  : f_LRU_2_WayVec_64Ways  = {f_LRU_2_WayVec_32Ways(LRUOut[62:32]),32'b0};
   endcase
endfunction

function automatic logic [127:0] f_LRU_2_WayVec_128Ways;
   input [126:0] LRUOut;

   unique casez (LRUOut[0])
      1'b0     : f_LRU_2_WayVec_128Ways  = {64'b0,f_LRU_2_WayVec_64Ways(LRUOut[63:1])};
      default  : f_LRU_2_WayVec_128Ways  = {f_LRU_2_WayVec_64Ways(LRUOut[126:64]),64'b0};
   endcase
endfunction



//============================================================================
// WayVec 2 LRU Write Functions
//============================================================================

function automatic logic [0:0] f_WayVec_2_LRUWrMask_2Ways;
   input [1:0] WayVec;

   unique casez (WayVec[1:0])
      2'b01   : f_WayVec_2_LRUWrMask_2Ways = 1'b1;
      2'b10   : f_WayVec_2_LRUWrMask_2Ways = 1'b1;
      default : f_WayVec_2_LRUWrMask_2Ways = '0;
   endcase
endfunction

function automatic logic [2:0] f_WayVec_2_LRUWrMask_4Ways;
   input [3:0] WayVec;

   unique casez ({(|WayVec[3:2]),(|WayVec[1:0])})
      2'b01    : f_WayVec_2_LRUWrMask_4Ways = {1'b0,f_WayVec_2_LRUWrMask_2Ways(WayVec[1:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrMask_4Ways = {f_WayVec_2_LRUWrMask_2Ways(WayVec[3:2]),1'b0,1'b1};
      default  : f_WayVec_2_LRUWrMask_4Ways = '0;
   endcase

endfunction

function automatic logic [6:0] f_WayVec_2_LRUWrMask_8Ways;
   input [7:0] WayVec;

   f_WayVec_2_LRUWrMask_8Ways = '0;

   unique casez ({(|WayVec[7:4]),(|WayVec[3:0])})
      2'b01    : f_WayVec_2_LRUWrMask_8Ways = {3'b0,f_WayVec_2_LRUWrMask_4Ways(WayVec[3:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrMask_8Ways = {f_WayVec_2_LRUWrMask_4Ways(WayVec[7:4]),3'b0,1'b1};
      default  : f_WayVec_2_LRUWrMask_8Ways = '0;
   endcase

endfunction

function automatic logic [14:0] f_WayVec_2_LRUWrMask_16Ways;
   input [15:0] WayVec;

   f_WayVec_2_LRUWrMask_16Ways = '0;

   unique casez ({(|WayVec[15:8]),(|WayVec[7:0])})
      2'b01    : f_WayVec_2_LRUWrMask_16Ways = {7'b0,f_WayVec_2_LRUWrMask_8Ways(WayVec[7:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrMask_16Ways = {f_WayVec_2_LRUWrMask_8Ways(WayVec[15:8]),7'b0,1'b1};
      default  : f_WayVec_2_LRUWrMask_16Ways = '0;
   endcase

endfunction


function automatic logic [30:0] f_WayVec_2_LRUWrMask_32Ways;
   input [31:0] WayVec;

   f_WayVec_2_LRUWrMask_32Ways = '0;

   unique casez ({(|WayVec[31:16]),(|WayVec[15:0])})
      2'b01    : f_WayVec_2_LRUWrMask_32Ways = {15'b0,f_WayVec_2_LRUWrMask_16Ways(WayVec[15:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrMask_32Ways = {f_WayVec_2_LRUWrMask_16Ways(WayVec[31:16]),15'b0,1'b1};
      default  : f_WayVec_2_LRUWrMask_32Ways = '0;
   endcase

endfunction


function automatic logic [62:0] f_WayVec_2_LRUWrMask_64Ways;
   input [63:0] WayVec;

   f_WayVec_2_LRUWrMask_64Ways = '0;

   unique casez ({(|WayVec[63:32]),(|WayVec[31:0])})
      2'b01    : f_WayVec_2_LRUWrMask_64Ways = {31'b0,f_WayVec_2_LRUWrMask_32Ways(WayVec[31:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrMask_64Ways = {f_WayVec_2_LRUWrMask_32Ways(WayVec[63:32]),31'b0,1'b1};
      default  : f_WayVec_2_LRUWrMask_64Ways = '0;
   endcase

endfunction


function automatic logic [126:0] f_WayVec_2_LRUWrMask_128Ways;
   input [127:0] WayVec;

   f_WayVec_2_LRUWrMask_128Ways = '0;

   unique casez ({(|WayVec[127:64]),(|WayVec[63:0])})
      2'b01    : f_WayVec_2_LRUWrMask_128Ways = {63'b0,f_WayVec_2_LRUWrMask_64Ways(WayVec[63:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrMask_128Ways = {f_WayVec_2_LRUWrMask_64Ways(WayVec[127:64]),63'b0,1'b1};
      default  : f_WayVec_2_LRUWrMask_128Ways = '0;
   endcase

endfunction





function automatic logic [0:0] f_WayVec_2_LRUWrData_2Ways;
   input [1:0] WayVec;

   unique casez (WayVec[1:0])
      2'b01   : f_WayVec_2_LRUWrData_2Ways = 1'b1;
      2'b10   : f_WayVec_2_LRUWrData_2Ways = 1'b0;
      default : f_WayVec_2_LRUWrData_2Ways = '0;
   endcase
endfunction

function automatic logic [2:0] f_WayVec_2_LRUWrData_4Ways;
   input [3:0] WayVec;

   unique casez ({(|WayVec[3:2]),(|WayVec[1:0])})
      2'b01    : f_WayVec_2_LRUWrData_4Ways = {1'b0,f_WayVec_2_LRUWrData_2Ways(WayVec[1:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrData_4Ways = {f_WayVec_2_LRUWrData_2Ways(WayVec[3:2]),1'b0,1'b0};
      default  : f_WayVec_2_LRUWrData_4Ways = '0;
   endcase

endfunction

function automatic logic [6:0] f_WayVec_2_LRUWrData_8Ways;
   input [7:0] WayVec;

   f_WayVec_2_LRUWrData_8Ways = '0;

   unique casez ({(|WayVec[7:4]),(|WayVec[3:0])})
      2'b01    : f_WayVec_2_LRUWrData_8Ways = {3'b0,f_WayVec_2_LRUWrData_4Ways(WayVec[3:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrData_8Ways = {f_WayVec_2_LRUWrData_4Ways(WayVec[7:4]),3'b0,1'b0};
      default  : f_WayVec_2_LRUWrData_8Ways = '0;
   endcase

endfunction

function automatic logic [14:0] f_WayVec_2_LRUWrData_16Ways;
   input [15:0] WayVec;

   f_WayVec_2_LRUWrData_16Ways = '0;

   unique casez ({(|WayVec[15:8]),(|WayVec[7:0])})
      2'b01    : f_WayVec_2_LRUWrData_16Ways = {7'b0,f_WayVec_2_LRUWrData_8Ways(WayVec[7:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrData_16Ways = {f_WayVec_2_LRUWrData_8Ways(WayVec[15:8]),7'b0,1'b0};
      default  : f_WayVec_2_LRUWrData_16Ways = '0;
   endcase

endfunction

function automatic logic [30:0] f_WayVec_2_LRUWrData_32Ways;
   input [31:0] WayVec;

   f_WayVec_2_LRUWrData_32Ways = '0;

   unique casez ({(|WayVec[31:16]),(|WayVec[15:0])})
      2'b01    : f_WayVec_2_LRUWrData_32Ways = {15'b0,f_WayVec_2_LRUWrData_16Ways(WayVec[15:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrData_32Ways = {f_WayVec_2_LRUWrData_16Ways(WayVec[31:16]),15'b0,1'b0};
      default  : f_WayVec_2_LRUWrData_32Ways = '0;
   endcase

endfunction

function automatic logic [62:0] f_WayVec_2_LRUWrData_64Ways;
   input [63:0] WayVec;

   f_WayVec_2_LRUWrData_64Ways = '0;

   unique casez ({(|WayVec[63:32]),(|WayVec[31:0])})
      2'b01    : f_WayVec_2_LRUWrData_64Ways = {31'b0,f_WayVec_2_LRUWrData_32Ways(WayVec[31:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrData_64Ways = {f_WayVec_2_LRUWrData_32Ways(WayVec[63:32]),31'b0,1'b0};
      default  : f_WayVec_2_LRUWrData_64Ways = '0;
   endcase

endfunction

function automatic logic [126:0] f_WayVec_2_LRUWrData_128Ways;
   input [127:0] WayVec;

   f_WayVec_2_LRUWrData_128Ways = '0;

   unique casez ({(|WayVec[127:64]),(|WayVec[63:0])})
      2'b01    : f_WayVec_2_LRUWrData_128Ways = {63'b0,f_WayVec_2_LRUWrData_64Ways(WayVec[63:0]),1'b1};
      2'b10    : f_WayVec_2_LRUWrData_128Ways = {f_WayVec_2_LRUWrData_64Ways(WayVec[127:64]),63'b0,1'b0};
      default  : f_WayVec_2_LRUWrData_128Ways = '0;
   endcase

endfunction

//============================================================================
// GLOBALS ASSERTIONS
//============================================================================

`ifndef HQM_DEVTLB_SVA_OFF
generate
   
   `HQM_DEVTLB_ASSERTS_MUST(IOMMU_Array_Ways_out_of_LRU_Range,
               (NUM_WAYS == 2)
             | (NUM_WAYS == 4)
             | (NUM_WAYS == 8)
             | (NUM_WAYS == 16)
             | (NUM_WAYS == 32)
             | (NUM_WAYS == 64)
             | (NUM_WAYS == 128)
            , posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Number of ways not supported by LRU: %s", NUM_WAYS));

      
      `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_Array_RdEn_Implies_SpecRdEn, RdEn_nnnH, RdEnSpec_nnnH,
         posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Set address to access is out of bounds of array."));
   
      if (NUM_SETS > 1) begin: SET_ADDR_BOUNDS
         `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_LRU_RdSetAddr_in_bounds,
            RdEn_nnnH, `HQM_DEVTLB_ZX(RdSetAddr_nnnH,32) < NUM_SETS, posedge clk, reset_INST,
         `HQM_DEVTLB_ERR_MSG("Set address to access is out of bounds of array."));
      end
   
      `ifdef XPROP
         `HQM_DEVTLB_ASSERTS_NEVER(IOMMU_ISKNOWN_XPROP_LRUWrEn, $isunknown(WrEn_nnnH), posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value of signal is unknown."));
      `endif
   
endgenerate   
`endif

endmodule

`endif // IOMMU_LRU_VS

