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
//    FILENAME    : stap_glue.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    
//    
//    PURPOSE     : sTAP glue logic
//    DESCRIPTION :
//       This is module generate glue logic required to drive outputs.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//----------------------------------------------------------------------
module stap_glue
   #(
   parameter GLUE_STAP_ENABLE_TAP_NETWORK       = 0,
   parameter GLUE_STAP_ENABLE_WTAP_NETWORK      = 0,
   parameter GLUE_STAP_WIDTH_OF_VERCODE         = 4,
   parameter GLUE_STAP_NUMBER_OF_TAPS           = 1,
   parameter GLUE_STAP_NUMBER_OF_WTAPS          = 1,
   parameter GLUE_STAP_SIZE_OF_EACH_INSTRUCTION = 8,
   parameter GLUE_STAP_WTAP_COMMON_LOGIC        = 0,
   parameter GLUE_STAP_ENABLE_TAPC_REMOVE       = 0,
   parameter GLUE_STAP_ENABLE_LINEAR_NETWORK    = 0
   )
   (
   // ***************************************************
   // Primary JTAG ports
   // ***************************************************
   input  logic                                      ftap_tck,
   input  logic                                      ftap_tms,
   input  logic                                      ftap_trst_b,
   input  logic                                      powergoodrst_b,
   input  logic                                      ftap_tdi,
   input  logic [(GLUE_STAP_WIDTH_OF_VERCODE - 1):0] ftap_vercode,
   input  logic                                      stap_tdomux_tdoen,
   input  logic [(GLUE_STAP_NUMBER_OF_TAPS - 1):0]   sntapnw_atap_tdo_en,
   output logic [(GLUE_STAP_WIDTH_OF_VERCODE - 1):0] atap_vercode,
   output logic                                      pre_tdo,
   output logic                                      powergoodrst_trst_b,
   output logic                                      atap_tdoen,
   // ***************************************************
   // Primary JTAG ports to Slave TAPNetwork
   // ***************************************************
   output logic sntapnw_ftap_tck,
   output logic sntapnw_ftap_tms,
   output logic sntapnw_ftap_trst_b,
   output logic sntapnw_ftap_tdi,
   input  logic sntapnw_atap_tdo,
   // ***************************************************
   // Secondary JTAG ports
   // ***************************************************
   input  logic ftapsslv_tck,
   input  logic ftapsslv_tms,
   input  logic ftapsslv_trst_b,
   input  logic ftapsslv_tdi,
   output logic atapsslv_tdo,
   output logic atapsslv_tdoen,
   // ***************************************************
   // Secondary JTAG ports to Slave TAPNetwork
   // ***************************************************
   output logic                                    sntapnw_ftap_tck2,
   output logic                                    sntapnw_ftap_tms2,
   output logic                                    sntapnw_ftap_trst2_b,
   output logic                                    sntapnw_ftap_tdi2,
   input  logic                                    sntapnw_atap_tdo2,
   input  logic [(GLUE_STAP_NUMBER_OF_TAPS - 1):0] sntapnw_atap_tdo2_en,
   // ***************************************************
   // Control Signals to WTAP/WTAP Network
   // ***************************************************
   //input  logic stap_wso,
   //output logic stap_wsi,
   output logic sn_fwtap_wrck,
   // ***************************************************
   // Control Signals
   // ***************************************************
   input  logic                                          stap_mux_tdo,
   input  logic [((GLUE_STAP_NUMBER_OF_TAPS * 2) - 1):0] tapc_select,
   input  logic [(GLUE_STAP_NUMBER_OF_WTAPS - 1):0]      tapc_wtap_sel,
   input  logic                                          tapc_remove,
   input  logic                                          stap_wtapnw_tdo
   );

   // *********************************************************************
   // Local parameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic stap_muxtdo_wtapwso;
   logic stap_enable_linear_nw;

   // *********************************************************************
   // Secondary port connections
   // *********************************************************************
   sipstap_ctech_clkbf i_sipstap_ctech_clkbf_tck2 (.o_clk(sntapnw_ftap_tck2), .in_clk(ftapsslv_tck));
   //assign sntapnw_ftap_tck2     = ftapsslv_tck;
   assign sntapnw_ftap_tms2     = ftapsslv_tms;
   assign sntapnw_ftap_trst2_b   = ftapsslv_trst_b;
   assign sntapnw_ftap_tdi2     = ftapsslv_tdi;
   assign atapsslv_tdo   = sntapnw_atap_tdo2;
   assign atapsslv_tdoen = |sntapnw_atap_tdo2_en;

   // *********************************************************************
   // Control Signals common to WTAP/WTAP Network
   // *********************************************************************
   generate
      if (GLUE_STAP_WTAP_COMMON_LOGIC == 1)
      begin
         //assign sn_fwtap_wrck = ftap_tck;
         sipstap_ctech_clkbf i_sipstap_ctech_clkbf_wrck (.o_clk(sn_fwtap_wrck), .in_clk(ftap_tck));
      end
      else
      begin
         assign sn_fwtap_wrck = LOW;
      end
   endgenerate

   // *********************************************************************
   // Vercode pass thru assignments
   // *********************************************************************
   assign atap_vercode = ftap_vercode;

   // *********************************************************************
   // sntapnw_ftap_tdi, sntapnw_ftap_tck, sntapnw_ftap_tms and sntapnw_ftap_trst_b pass thru assignments
   // *********************************************************************
   generate
      if (GLUE_STAP_ENABLE_TAP_NETWORK == 1)
      begin
         assign sntapnw_ftap_tdi   = (tapc_remove == HIGH) ? ftap_tdi : stap_mux_tdo;
         //assign sntapnw_ftap_tck   = ftap_tck;
         sipstap_ctech_clkbf i_sipstap_ctech_clkbf_tapnw1 (.o_clk(sntapnw_ftap_tck), .in_clk(ftap_tck));
         assign sntapnw_ftap_tms   = ftap_tms;
         assign sntapnw_ftap_trst_b = ftap_trst_b;
      end
      else if (GLUE_STAP_ENABLE_TAPC_REMOVE == 1)
      begin
         assign sntapnw_ftap_tdi   = (tapc_remove == HIGH) ? ftap_tdi : stap_mux_tdo;
         //assign sntapnw_ftap_tck   = ftap_tck;
         sipstap_ctech_clkbf i_sipstap_ctech_clkbf_tapnw2 (.o_clk(sntapnw_ftap_tck), .in_clk(ftap_tck));
         assign sntapnw_ftap_tms   = ftap_tms;
         assign sntapnw_ftap_trst_b = ftap_trst_b;
      end
      else
      begin
         assign sntapnw_ftap_tdi   = LOW;
         assign sntapnw_ftap_tck   = LOW;
         assign sntapnw_ftap_tms   = HIGH;
         assign sntapnw_ftap_trst_b = HIGH;
      end
   endgenerate

   // *********************************************************************
   // Logic to control between mux tdo and wsi
   // *********************************************************************
   //generate
   //   if (GLUE_STAP_CONNECT_WTAP_DIRECTLY == 1)
   //   begin
   //      assign stap_wsi            = stap_mux_tdo;
   //      assign stap_muxtdo_wtapwso = stap_wso;
   //   end
   //   else
   //   begin
   //      assign stap_wsi            = HIGH;
   assign stap_muxtdo_wtapwso = stap_mux_tdo;
   //   end
   //endgenerate

   // *********************************************************************
   // Logic to control between stap_wtapnw_tdo, sntapnw_atap_tdo and stap_muxtdo_wtapwso
   // *********************************************************************
   generate
      if (GLUE_STAP_ENABLE_LINEAR_NETWORK == 1)
      begin
         assign stap_enable_linear_nw = HIGH;
      end
      else
      begin
         assign stap_enable_linear_nw = LOW;
      end
   endgenerate

   generate
      if (GLUE_STAP_ENABLE_TAP_NETWORK == 1)
      begin
         if (GLUE_STAP_ENABLE_WTAP_NETWORK == 1)
         begin
            assign pre_tdo = (tapc_remove       == HIGH)                             ? sntapnw_atap_tdo       :
                                (((|tapc_select) | stap_enable_linear_nw) == HIGH)   ? sntapnw_atap_tdo       :
                                (|tapc_wtap_sel == HIGH)                             ? stap_wtapnw_tdo : stap_muxtdo_wtapwso;
         end
         else
         begin
            assign pre_tdo = (tapc_remove       == HIGH)                             ? sntapnw_atap_tdo :
                                (((|tapc_select | stap_enable_linear_nw))  == HIGH)  ? sntapnw_atap_tdo : stap_muxtdo_wtapwso;
         end
      end
      else if (GLUE_STAP_ENABLE_WTAP_NETWORK == 1)
      begin
         assign pre_tdo = (|tapc_wtap_sel == HIGH) ? stap_wtapnw_tdo : stap_muxtdo_wtapwso;
      end
      else
      begin
         assign pre_tdo = stap_muxtdo_wtapwso;
      end
   endgenerate

   // *********************************************************************
   // Reset generation logic
   // *********************************************************************
   assign powergoodrst_trst_b = ftap_trst_b & powergoodrst_b;

   // *********************************************************************
   // TDOEN generation logic. When remove bit is asserted tapnw tdoen is
   // selected, else internal tdoen is selected.
   // *********************************************************************
   assign atap_tdoen = (tapc_remove == HIGH) ? (|sntapnw_atap_tdo_en) : stap_tdomux_tdoen;

endmodule
