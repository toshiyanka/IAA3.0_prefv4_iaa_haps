//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2020 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2020WW22_PICr33
//
//  Module <mTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : mtap_remote_data_reg.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : CLTAPc
//    
//    
//    PURPOSE     : CLTAPc  remote DR Register Implementation
//    DESCRIPTION :
//       This module is for remote JTAG register. This module provides control signals
//       for data registers which are placed outside the CLTAPc module.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//----------------------------------------------------------------------
module mtap_remote_data_reg
   #(
   parameter DATA_MTAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR_BIT  = 2'b00
   )
   (
   input logic atappris_tck, //kbbhagwa cdc fix
   input logic mtap_fsm_capture_dr_nxt, //kbbhagwa cdc fix
   input logic mtap_fsm_update_dr_nxt, //kbbhagwa cdc fix
// kbbhagwa cdc fix https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904622
   
   input  logic     atappris_tdi,
   input  logic     powergoodrst_b,
   input  logic     mtap_irdecoder_drselect,
   input  logic     mtap_fsm_capture_dr,
   input  logic     mtap_fsm_shift_dr,
   //input  logic     mtap_fsm_shift_dr_neg, //kbbhagwa hsd2904953
   input  logic     mtap_fsm_update_dr,
   output logic     mtap_drreg_drout,
   input  logic     rtdr_tap_ip_clk_i,
   input  logic     rtdr_tap_tdo,
   output logic     tap_rtdr_tdi,
   output logic     tap_rtdr_capture,
   output logic     tap_rtdr_shift,
   output logic     tap_rtdr_update,
   output logic     tap_rtdr_irdec
   );

   // *********************************************************************
   // Localparameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   // *********************************************************************
   // Internal signals
   // *********************************************************************
     //kbbhagwa cdc fix 
   logic syncr_capture_ff1 ;
   logic syncr_update_ff1 ;
   logic syncr_update ;
   logic syncr_capture ;

   logic tap_rtdr_capture_int_ff1;
   logic tap_rtdr_capture_int_ff2;
   logic tap_rtdr_update_int_ff1;
   logic tap_rtdr_update_int_ff2;

  //kbbhagwa cdc fix 

   logic rtdr_tap_tdo_int;
   logic tap_rtdr_capture_int;
   logic tap_rtdr_update_int;
   logic tap_rtdr_irdec_int;

   // *********************************************************************
   // Route the serial output from remote data register to atap_tdo through drreg_out.
   // *********************************************************************
   assign rtdr_tap_tdo_int = rtdr_tap_tdo & mtap_irdecoder_drselect & mtap_fsm_shift_dr;
   assign mtap_drreg_drout = rtdr_tap_tdo_int;

   // *********************************************************************
   // Route the fatp_tdi to remote data register input. This tdi will be active only when specific IRReg is selected
   // *********************************************************************
//   assign tap_rtdr_tdi     = atappris_tdi & mtap_fsm_shift_dr & mtap_irdecoder_drselect;
//kbbhagwa https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904953 
// posedge negedge signal mergers to be avoided
//   assign tap_rtdr_tdi     = atappris_tdi & mtap_fsm_shift_dr_neg & mtap_irdecoder_drselect;
//kbbhagwa , we donot require mtap_fsm_shift_dr_neg, as the expectation
//is that the implementation would any ways use the shift to enable
//the shifting of tdi
   assign tap_rtdr_tdi     = atappris_tdi & mtap_irdecoder_drselect;


   // *********************************************************************
   // Generate capture, shift, update  and IRdeocde signals for each remote test data register
   // *********************************************************************
// kbbhagwa cdc fix   assign tap_rtdr_capture_int = (mtap_fsm_capture_dr & mtap_irdecoder_drselect ) ;
   assign tap_rtdr_shift       = (mtap_fsm_shift_dr   & mtap_irdecoder_drselect ) ;
// kbbhagwa cdc fix  assign tap_rtdr_update_int  = (mtap_fsm_update_dr  & mtap_irdecoder_drselect ) ; //FIXME may need flopping at -ve edge
   assign tap_rtdr_irdec_int   = mtap_irdecoder_drselect; 

   // *********************************************************************
   // Generate synchronizer logic based on parameter value
   // *********************************************************************
   generate
    if (DATA_MTAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR_BIT == 1) //gen begin
      begin
         sipcltapc_ctech_doublesync i_sipcltapc_ctech_doublesync_rtdr_cap
            (
            .din     (tap_rtdr_capture_int),
            .clr_b   (powergoodrst_b),
            .clk     (rtdr_tap_ip_clk_i),
//            .qout    (tap_rtdr_capture)
            .qout    (syncr_capture) //kbbhagwa cdc fix
            );
         sipcltapc_ctech_doublesync i_sipcltapc_ctech_doublesync_rtdr_upd
            (
            .din     (tap_rtdr_update_int),
            .clr_b   (powergoodrst_b),
            .clk     (rtdr_tap_ip_clk_i),
//            .qout    (tap_rtdr_update)
            .qout    (syncr_update) // kbbhagwa cdc fix 
            );
         sipcltapc_ctech_doublesync i_sipcltapc_ctech_doublesync_rtdr_ird
            (
            .din     (tap_rtdr_irdec_int),
            .clr_b   (powergoodrst_b),
            .clk     (rtdr_tap_ip_clk_i),
            .qout    (tap_rtdr_irdec)
            );

//kbbhagwa cdc fix
//assign tap_rtdr_capture_int  = (mtap_fsm_capture_dr & mtap_irdecoder_drselect ) ;
//kbbhagwa cdc fix : https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904622
   always_ff @(posedge atappris_tck or negedge powergoodrst_b)
         if ( ~ powergoodrst_b )
         begin
          tap_rtdr_capture_int_ff1 <= 1'b0;
          tap_rtdr_capture_int_ff2 <= 1'b0;
         end
         else 
         begin //pulse extender for 2 clock wide stretch for cdc
          tap_rtdr_capture_int_ff1 <= (mtap_fsm_capture_dr_nxt & mtap_irdecoder_drselect );
          tap_rtdr_capture_int_ff2 <= tap_rtdr_capture_int_ff1 | (mtap_fsm_capture_dr_nxt & mtap_irdecoder_drselect );
         end
   assign tap_rtdr_capture_int  =  tap_rtdr_capture_int_ff2;

//   assign tap_rtdr_update_int   = (mtap_fsm_update_dr  & mtap_irdecoder_drselect ) ; //FIXME may need flopping at -ve edge
   always_ff @(posedge atappris_tck or negedge powergoodrst_b)
         if ( ~ powergoodrst_b )
         begin
           tap_rtdr_update_int_ff1 <= 1'b0;
           tap_rtdr_update_int_ff2 <= 1'b0;
         end
         else 
         begin
           tap_rtdr_update_int_ff1 <= (mtap_fsm_update_dr_nxt & mtap_irdecoder_drselect );
           tap_rtdr_update_int_ff2 <= tap_rtdr_update_int_ff1 | (mtap_fsm_update_dr_nxt & mtap_irdecoder_drselect );
         end
   assign tap_rtdr_update_int  =  tap_rtdr_update_int_ff2;

   always_ff @(posedge rtdr_tap_ip_clk_i or negedge powergoodrst_b)
         if ( ~ powergoodrst_b )
            begin
               syncr_capture_ff1 <= 1'b0 ;
               syncr_update_ff1 <= 1'b0 ;
            end
         else
            begin
               syncr_capture_ff1 <= syncr_capture ;
               syncr_update_ff1 <= syncr_update ;
            end

  assign  tap_rtdr_update  = syncr_update & ~ syncr_update_ff1 ;
  assign  tap_rtdr_capture = syncr_capture & ~ syncr_capture_ff1 ;

// kbbhagwa cdc fix 
      end //gen begin 
      else
      begin
          logic  rtdr_tap_ip_clk_i_NC ;
          logic  powergoodrst_b_NC ;
          assign rtdr_tap_ip_clk_i_NC = rtdr_tap_ip_clk_i;
          assign powergoodrst_b_NC    = powergoodrst_b;
//          assign tap_rtdr_capture     = tap_rtdr_capture_int; //kbbhagwa cdc fix
          assign tap_rtdr_capture     = mtap_fsm_capture_dr & mtap_irdecoder_drselect;

//          assign tap_rtdr_update      = tap_rtdr_update_int; //kbbhagwa cdc fix
          assign tap_rtdr_update      = (mtap_fsm_update_dr  & mtap_irdecoder_drselect ) ;
          assign tap_rtdr_irdec       = tap_rtdr_irdec_int;
      end
   endgenerate

endmodule
