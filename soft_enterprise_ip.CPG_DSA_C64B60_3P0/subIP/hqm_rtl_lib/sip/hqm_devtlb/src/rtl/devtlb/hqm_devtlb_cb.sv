//======================================================================================================================
//
// iommu_cb.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 9/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
// This block implements the IOMMU Credit Buffer which buffers and credits new requests.
//
//======================================================================================================================

`ifndef HQM_DEVTLB_CB_VS
`define HQM_DEVTLB_CB_VS

`include "hqm_devtlb_pkg.vh"

// Sub-module includes
//
`include "hqm_devtlb_cbfifo.sv"

module hqm_devtlb_cb (
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST
   PwrDnOvrd_nnnH,
   DeftrStallCBFifo,

   req_valid,
   req_prior_match,
   IodtlbReq_1nnH,
   credit_return,

   CbPipeV_100H,
   CbReq_100H,
   CbGnt_100H
//lintra +68099
);

import `HQM_DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the IOMMU
`include "hqm_devtlb_pkgparams.vh"

   parameter int MAX_GUEST_ADDRESS_WIDTH        = 64;
   parameter int REQ_PAYLOAD_MSB                = 63;
   parameter int DEVTLB_PORT_ID                 = 0;
   parameter int CB_DEPTH                       = 16;
   parameter type T_REQ                         = logic; //t_devtlb_request;
   
   // Interface to IOMMU top level
   //
   `HQM_DEVTLB_COMMON_PORTDEC
   `HQM_DEVTLB_FSCAN_PORTDEC
   input  logic                             PwrDnOvrd_nnnH;         // Powerdown override
   input  logic                             DeftrStallCBFifo;
   
   input  logic                             req_valid;              // Request valid from primary inputs
   input  logic                             req_prior_match;           //1= priority match
   input  T_REQ                             IodtlbReq_1nnH;
   output logic                             credit_return;        // Credit return

   // Interface to TLB arbiter
   //
   output logic                             CbPipeV_100H;         // Credit buffer request to TLB arbiter
   output T_REQ                             CbReq_100H;
   input  logic                             CbGnt_100H;           // Grant from TLB arbiter
   
//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================

// Signals for clock generation
//
logic                            IodtlbReqVal_1n1H;      // Staged request valid from primary input
T_REQ                            IodtlbReq_1n1H;         // Staged request from primary inputs

T_REQ                            ff_CbReq_100H;       // unmodified request data from fifos

logic                            FifoGnt_100H;


//======================================================================================================================
//                                                     Clocking
//======================================================================================================================

//======================================================================================================================
//                                              Credit buffer top level
//======================================================================================================================
//generate
//   if (DEVTLB_PORT_ID == 0) begin: PORT_0
//      assign FifoGnt_100H = CbLoGnt_100H | InvEnd_nnnH;
//   end else begin: PORT_NZ
//      assign FifoGnt_100H = CbLoGnt_100H;
//   end
//endgenerate 
assign FifoGnt_100H = CbGnt_100H;
always_comb begin
   IodtlbReqVal_1n1H = req_valid && req_prior_match;
   IodtlbReq_1n1H    = IodtlbReq_1nnH;
end


//======================================================================================================================
//                                               Credit buffer slices
//======================================================================================================================
// CODEREVIEW WAYNE: will the number of slices always be fixed to two?  You are distinguishing all this code with "lo" and "hi".
//                   Instead, you could use a vector 1:0.  Then you could instead use a GENFOR loop to instantiate all instances
//                   based on the size of the slice vector.  If you wanted to manually distinguish them when creating the I/O signals
//                   you could always use [LO] and [HI] defines to refer to each end explicitly.  You can more easily keep all
//                   instances in sync by using vectors everywhere.  This may allow optimization of other creation/usage as well.
//

// Credit buffer module for low priority requests
//

generate
   if (CB_DEPTH == -1)  begin: NO_CB_FIFO
      //$fatal(2, "CB_DEPTH must be >=1");
      assign credit_return        = FifoGnt_100H;
      assign CbPipeV_100H         = IodtlbReqVal_1n1H;
      assign ff_CbReq_100H        = IodtlbReq_1n1H;
   end
   else begin: CB_FIFO
      hqm_devtlb_cbfifo #(.NO_POWER_GATING(NO_POWER_GATING),
                    .T_REQ(T_REQ),
                    .FIFO_DEPTH(CB_DEPTH)
      ) devtlb_cb_slice (
            `HQM_DEVTLB_COMMON_PORTCON
            `HQM_DEVTLB_FSCAN_PORTCON
            .PwrDnOvrd_nnnH      (PwrDnOvrd_nnnH),
            .DeftrStallCBFifo    (DeftrStallCBFifo),
            .ReqVal_1n1H         (IodtlbReqVal_1n1H),
            .Req_1n1H            (IodtlbReq_1n1H),
            .CreditReturn_1nnH   (credit_return),
            .FifoPipeV_100H      (CbPipeV_100H),
            .FifoReq_100H        (ff_CbReq_100H),
            .FifoGnt_100H        (FifoGnt_100H)
      );
   end
endgenerate

generate

   if (REQ_PAYLOAD_MSB > MAX_GUEST_ADDRESS_WIDTH)  begin: GPA39
      always_comb begin
         CbReq_100H  = ff_CbReq_100H;

         if (f_IOMMU_Opcode_is_DMA(ff_CbReq_100H.Opcode) & ~ff_CbReq_100H.PasidV)
            CbReq_100H.Address[REQ_PAYLOAD_MSB:MAX_GUEST_ADDRESS_WIDTH]  =  '0;

      end
   end else begin: GPA48
      always_comb begin
         CbReq_100H  = ff_CbReq_100H;
      end
   end
   
endgenerate

`ifndef HQM_DEVTLB_SVA_OFF

// Assertion for request valid in freeze mode
//
//`DEVTLB_ASSERTS_NEVER(IOMMU_Cb_reqvalid_freeze,
//    devtlb_freeze & req_valid, clk, reset_INST,
//   `DEVTLB_ERR_MSG("Request cannot be valid while in freeze mode."));

`endif

`ifdef HQM_DEVTLB_COVER_EN

//`DEVTLB_COVERS(IOMMU_CB_Def_stall_cb_fifo, DefStallFifo_nnnH, clk, reset_INST, `DEVTLB_COVER_MSG("Defeature stalls CB FIFO."));

`endif
endmodule

`endif // IOMMU_CB_VS
