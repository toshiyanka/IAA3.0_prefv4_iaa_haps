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
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap_remote_data_reg.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    
//    
//    PURPOSE     : sTAP DR Register Implementation
//    DESCRIPTION :
//       This module is generic JTAG register. This module accepts the data
//       from tdi and shifts according to shift enable provided by FSM.
//       This module also has parallel input and output ports. Once FSM asserts
//       update signal, parallel data is available on its module ports.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//----------------------------------------------------------------------
module stap_remote_data_reg
   #(
   parameter DATA_STAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR_BIT  = 2'b00
   )
   (
   input  logic     ftap_tdi,
   input  logic     ftap_tck, //kbbhagwa cdc fix
   input  logic     powergoodrst_b,
   input  logic     stap_irdecoder_drselect,
   input  logic     stap_fsm_capture_dr,

   input  logic     stap_fsm_capture_dr_nxt, //kbbhagwa cdc fix 
// kbbhagwa cdc fix https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904622

   input  logic     stap_fsm_shift_dr,
   //input  logic     stap_fsm_shift_dr_neg, //kbbhagwa hsd 2904953 posneg
   input  logic     stap_fsm_update_dr,
   input  logic     stap_fsm_update_dr_nxt, //kbbhagwa cdc fix 
// kbbhagwa cdc fix https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904622

   output logic     stap_drreg_drout,
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
   logic rtdr_update ;
   logic rtdr_capture ;


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
   assign rtdr_tap_tdo_int = rtdr_tap_tdo & stap_irdecoder_drselect & stap_fsm_shift_dr;
   assign stap_drreg_drout = rtdr_tap_tdo_int;

   // *********************************************************************
   // Route the fatp_tdi to remote data register input. This tdi will be active only when specific IRReg is selected
   // *********************************************************************


//   assign tap_rtdr_tdi = ftap_tdi & stap_fsm_shift_dr & stap_irdecoder_drselect;
//kbbhagwa https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904953 
// posedge negedge signal mergers to be avoided
//   assign tap_rtdr_tdi = ftap_tdi & stap_fsm_shift_dr_neg & stap_irdecoder_drselect;
   assign tap_rtdr_tdi = ftap_tdi  & stap_irdecoder_drselect;


   // *********************************************************************
   // Generate capture, shift, update  and IRdeocde signals for each remote test data register
   // *********************************************************************
   //assign tap_rtdr_capture    = (stap_fsm_capture_dr | stap_fsm_capture_ir) & stap_irdecoder_drselect;
   //assign tap_rtdr_shift      = (stap_fsm_shift_dr   | stap_fsm_shift_ir)   & stap_irdecoder_drselect;
   //assign tap_rtdr_update     = (stap_fsm_update_dr  | stap_fsm_update_ir)  & stap_irdecoder_drselect; //FIXME may need flopping at -ve edge


   assign tap_rtdr_shift        = (stap_fsm_shift_dr   & stap_irdecoder_drselect ) ;
   assign tap_rtdr_irdec_int    = stap_irdecoder_drselect; 

   // *********************************************************************
   // Generate synchronizer logic based on parameter value
   // *********************************************************************
   generate
   if (DATA_STAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR_BIT == 1)
      begin
         sipstap_ctech_doublesync i_sipstap_ctech_doublesync_rtdr_cap
            (
            .din     (tap_rtdr_capture_int),
            .clr_b   (powergoodrst_b),
            .clk     (rtdr_tap_ip_clk_i),
//            .qout    (tap_rtdr_capture) //kbbhagwa cdc fix
            .qout    (syncr_capture)
            );
         sipstap_ctech_doublesync i_sipstap_ctech_doublesync_rtdr_upd
            (
            .din     (tap_rtdr_update_int),
            .clr_b   (powergoodrst_b),
            .clk     (rtdr_tap_ip_clk_i),
//            .qout    (tap_rtdr_update) //kbbhagw cdc fix
            .qout    (syncr_update)
            );
         sipstap_ctech_doublesync i_sipstap_ctech_doublesync_rtdr_ird
            (
            .din     (tap_rtdr_irdec_int),
            .clr_b   (powergoodrst_b),
            .clk     (rtdr_tap_ip_clk_i),
            .qout    (tap_rtdr_irdec)
            );
//kbbhagwa cdc fix
//assign tap_rtdr_capture_int  = (stap_fsm_capture_dr & stap_irdecoder_drselect ) ;
//kbbhagwa cdc fix : https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904622
// pulse stretcher for 1:1 case
   always_ff @(posedge ftap_tck or negedge powergoodrst_b)
         if ( ~ powergoodrst_b )
         begin
          tap_rtdr_capture_int_ff1 <= 1'b0;
          tap_rtdr_capture_int_ff2 <= 1'b0;
         end
         else 
         begin //pulse extender for 2 clock wide stretch for cdc
          tap_rtdr_capture_int_ff1 <= (stap_fsm_capture_dr_nxt & stap_irdecoder_drselect );
          tap_rtdr_capture_int_ff2 <= tap_rtdr_capture_int_ff1 | (stap_fsm_capture_dr_nxt & stap_irdecoder_drselect );
         end
   assign tap_rtdr_capture_int  =  tap_rtdr_capture_int_ff2;

//   assign tap_rtdr_update_int   = (stap_fsm_update_dr  & stap_irdecoder_drselect ) ; //FIXME may need flopping at -ve edge
   always_ff @(posedge ftap_tck or negedge powergoodrst_b)
         if ( ~ powergoodrst_b )
         begin
           tap_rtdr_update_int_ff1 <= 1'b0;
           tap_rtdr_update_int_ff2 <= 1'b0;
         end
         else 
         begin
           tap_rtdr_update_int_ff1 <= (stap_fsm_update_dr_nxt & stap_irdecoder_drselect );
           tap_rtdr_update_int_ff2 <= tap_rtdr_update_int_ff1 | (stap_fsm_update_dr_nxt & stap_irdecoder_drselect );
         end
   assign tap_rtdr_update_int  =  tap_rtdr_update_int_ff2;

   always_ff @(posedge rtdr_tap_ip_clk_i or negedge powergoodrst_b)
         if ( ~ powergoodrst_b )
            begin
              syncr_capture_ff1 <= 1'b0;
              syncr_update_ff1 <= 1'b0;
            end
         else
            begin
               syncr_capture_ff1 <= syncr_capture ;
               syncr_update_ff1 <= syncr_update ;
            end

  assign  tap_rtdr_update  = syncr_update & ~ syncr_update_ff1 ;
  assign  tap_rtdr_capture = syncr_capture & ~ syncr_capture_ff1 ;

// kbbhagwa cdc fix 
      end
      else
      begin
          logic  rtdr_tap_ip_clk_i_NC ;
          logic  powergoodrst_b_NC ;
          assign rtdr_tap_ip_clk_i_NC = rtdr_tap_ip_clk_i;
          assign powergoodrst_b_NC    = powergoodrst_b;
//          assign tap_rtdr_capture     = tap_rtdr_capture_int;
          assign tap_rtdr_capture     = stap_fsm_capture_dr & stap_irdecoder_drselect; //kbbhagwa cdc fix
//          assign tap_rtdr_update      = tap_rtdr_update_int;
          assign tap_rtdr_update      = (stap_fsm_update_dr  & stap_irdecoder_drselect ) ; //kbbhagwa cdc fix
          assign tap_rtdr_irdec       = tap_rtdr_irdec_int;
      end
   endgenerate

endmodule
