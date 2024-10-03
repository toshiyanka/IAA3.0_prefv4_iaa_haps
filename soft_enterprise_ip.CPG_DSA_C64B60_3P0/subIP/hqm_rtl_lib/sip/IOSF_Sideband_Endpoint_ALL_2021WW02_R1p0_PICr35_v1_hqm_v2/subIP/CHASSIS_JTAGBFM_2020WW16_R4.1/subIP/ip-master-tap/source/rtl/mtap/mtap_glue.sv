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
//    FILENAME    : mtap_glue.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : mTAP
//    
//    
//    PURPOSE     : MTAP glue logic
//    DESCRIPTION :
//       This is module generate glue logic required to drive outputs.
//    BUGS/ISSUES/ECN FIXES:
//       HSD2901763 - 03MAY2010
//       TDO Enable is not generated when mtap is removed (CLTAPC REMOVE = 1) 
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//----------------------------------------------------------------------
module mtap_glue #( parameter GLUE_MTAP_ENABLE_TAP_NETWORK       = 0,
                    parameter GLUE_MTAP_ENABLE_WTAP_NETWORK      = 0,
                    parameter GLUE_MTAP_WIDTH_OF_VERCODE         = 4,
                    parameter GLUE_MTAP_NUMBER_OF_TAPS           = 1,
                    parameter GLUE_MTAP_NUMBER_OF_WTAPS          = 1,
                    parameter GLUE_MTAP_SIZE_OF_EACH_INSTRUCTION = 8, 
                    parameter GLUE_MTAP_WTAP_COMMON_LOGIC        = 0,
                    parameter GLUE_MTAP_ENABLE_CLTAPC_REMOVE     = 0,
                    parameter GLUE_MTAP_ENABLE_LINEAR_NETWORK    = 0
                  )
                  (
                  // *********************************************************************
                  // Primary JTAG ports
                  // *********************************************************************
                  input  logic                                      atappris_tck,
                  input  logic                                      atappris_tms,
                  input  logic                                      atappris_trst_b,
                  input  logic                                      powergoodrst_b,
                  input  logic                                      atappris_tdi,
                  input  logic [(GLUE_MTAP_WIDTH_OF_VERCODE - 1):0] ftap_vercode,
                  input  logic                                      mtap_tdomux_tdoen,
                  input  logic [(GLUE_MTAP_NUMBER_OF_TAPS -1) :0]   cntapnw_atap_tdo_en,
                  output logic [(GLUE_MTAP_WIDTH_OF_VERCODE - 1):0] atap_vercode,
                  output logic                                      pre_tdo,
                  output logic                                      powergoodrst_trst_b,
                  output logic                                      ftappris_tdoen,
                  // *********************************************************************
                  // Primary JTAG ports to Slave TAPNetwork
                  // *********************************************************************
                  output logic cntapnw_ftap_tck,
                  output logic cntapnw_ftap_tms,
                  output logic cntapnw_ftap_trst_b,
                  output logic cntapnw_ftap_tdi,
                  input  logic cntapnw_atap_tdo,
                  // *********************************************************************
                  // Secondary JTAG ports
                  // *********************************************************************
                  input  logic atapsecs_tck,
                  input  logic atapsecs_tms,
                  input  logic atapsecs_trst_b,
                  input  logic atapsecs_tdi,
                  output logic ftapsecs_tdo,
                  output logic ftapsecs_tdoen,
                  // *********************************************************************
                  // Secondary JTAG ports to Slave TAPNetwork
                  // *********************************************************************
                  output logic                                     cntapnw_ftap_tck2,
                  output logic                                     cntapnw_ftap_tms2,
                  output logic                                     cntapnw_ftap_trst2_b,
                  output logic                                     cntapnw_ftap_tdi2,
                  input  logic                                     cntapnw_atap_tdo2,
                  input  logic [(GLUE_MTAP_NUMBER_OF_TAPS - 1):0]  cntapnw_atap_tdo2_en,
                  // *********************************************************************
                  // Control Signals to WTAP/WTAP Network
                  // *********************************************************************
                  // input  logic mtap_wso,
                  // output logic mtap_wsi,
                  output logic cn_fwtap_wrck,
                  // *********************************************************************
                  // Register outputs
                  // *********************************************************************
                 input logic                                          mtap_mux_tdo,
                 input logic [((GLUE_MTAP_NUMBER_OF_TAPS * 2) - 1):0] cltapc_select,
                 input logic [((GLUE_MTAP_NUMBER_OF_TAPS * 2) - 1):0] cltapc_select_ovr,
                 input logic [(GLUE_MTAP_NUMBER_OF_WTAPS - 1):0]      cltapc_wtap_sel,
                 input logic                                          cltapc_remove,
                 input logic                                          mtap_wtapnw_tdo
                 );

   // *********************************************************************
   // Local parameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   // *********************************************************************
   // Internal signal
   // *********************************************************************
   logic mtap_muxtdo_wtapwso;
   logic enable_linear_nw;

   // *********************************************************************
   // Secondary port connections
   // *********************************************************************
   sipcltapc_ctech_clkbf i_sipcltapc_ctech_clkbf_tck2 (.o_clk(cntapnw_ftap_tck2), .in_clk(atapsecs_tck));
   //assign cntapnw_ftap_tck2     = atapsecs_tck;
   assign cntapnw_ftap_tms2     = atapsecs_tms;
   assign cntapnw_ftap_trst2_b  = atapsecs_trst_b;
   assign cntapnw_ftap_tdi2     = atapsecs_tdi;
   assign ftapsecs_tdo          = cntapnw_atap_tdo2;
   assign ftapsecs_tdoen        = | cntapnw_atap_tdo2_en;

   // *********************************************************************
   // Control Signals common to WTAP/WTAP Network
   // *********************************************************************
   generate
      if (GLUE_MTAP_WTAP_COMMON_LOGIC == 1)
      begin
         //assign cn_fwtap_wrck = atappris_tck;
         sipcltapc_ctech_clkbf i_sipcltapc_ctech_clkbf_wrck (.o_clk(cn_fwtap_wrck), .in_clk(atappris_tck));
      end
      else
      begin
         assign cn_fwtap_wrck = LOW;
      end
   endgenerate

   // *********************************************************************
   // Vercode pass thru assignments
   // *********************************************************************
   assign atap_vercode = ftap_vercode;

   // *********************************************************************
   // cntapnw_ftap_tdi, cntapnw_ftap_tck, cntapnw_ftap_tms and cntapnw_ftap_trst_b pass thru assignments
   // *********************************************************************
   generate
      if (GLUE_MTAP_ENABLE_TAP_NETWORK == 1)
      begin
         assign cntapnw_ftap_tdi    = (cltapc_remove == HIGH) ? atappris_tdi : mtap_mux_tdo;
         //assign cntapnw_ftap_tck    = atappris_tck;
         sipcltapc_ctech_clkbf i_sipcltapc_ctech_clkbf_tck1 (.o_clk(cntapnw_ftap_tck), .in_clk(atappris_tck));
         assign cntapnw_ftap_tms    = atappris_tms;
         assign cntapnw_ftap_trst_b = atappris_trst_b;
      end
      else if (GLUE_MTAP_ENABLE_CLTAPC_REMOVE == 1)
      begin
         assign cntapnw_ftap_tdi    = (cltapc_remove == HIGH) ? atappris_tdi : mtap_mux_tdo;
         //assign cntapnw_ftap_tck    = atappris_tck;
         sipcltapc_ctech_clkbf i_sipcltapc_ctech_clkbf_tck2 (.o_clk(cntapnw_ftap_tck), .in_clk(atappris_tck));
         assign cntapnw_ftap_tms    = atappris_tms;
         assign cntapnw_ftap_trst_b = atappris_trst_b;
      end
      else
      begin
         assign cntapnw_ftap_tdi    = LOW;
         assign cntapnw_ftap_tck    = LOW;
         assign cntapnw_ftap_tms    = HIGH;
         assign cntapnw_ftap_trst_b = HIGH;
      end
   endgenerate

   // *********************************************************************
   // Logic to control between mux tdo and wsi
   // *********************************************************************
   // generate
   //    if (GLUE_MTAP_CONNECT_WTAP_DIRECTLY == 1)
   //    begin
   //       assign mtap_wsi            = mtap_mux_tdo;
   //       assign mtap_muxtdo_wtapwso = mtap_wso;
   //    end
   //    else
   //    begin
   //       assign mtap_wsi            = HIGH;
   assign mtap_muxtdo_wtapwso = mtap_mux_tdo;
   //    end
   // endgenerate

   // *********************************************************************
   // Logic to control between mtap_wtapnw_tdo, cntapnw_atap_tdo and mtap_muxtdo_wtapwso
   // *********************************************************************
   generate
      if (GLUE_MTAP_ENABLE_LINEAR_NETWORK == 1)
      begin
         assign enable_linear_nw = HIGH;
      end
      else
      begin
         assign enable_linear_nw = LOW;
      end
   endgenerate

   generate
      if (GLUE_MTAP_ENABLE_TAP_NETWORK == 1)
      begin
         if (GLUE_MTAP_ENABLE_WTAP_NETWORK == 1)
         begin
            assign pre_tdo = (cltapc_remove    == HIGH)                                             ? cntapnw_atap_tdo :
                             (((|(cltapc_select | cltapc_select_ovr )) | enable_linear_nw) == HIGH) ? cntapnw_atap_tdo :
                             (|cltapc_wtap_sel == HIGH)                                             ? mtap_wtapnw_tdo  : mtap_muxtdo_wtapwso;
         end
         else
         begin
            assign pre_tdo = (cltapc_remove                                                 == HIGH) ? cntapnw_atap_tdo :
                             (((|(cltapc_select | cltapc_select_ovr ) ) | enable_linear_nw) == HIGH) ? cntapnw_atap_tdo : mtap_muxtdo_wtapwso;
         end
      end
      else if (GLUE_MTAP_ENABLE_WTAP_NETWORK == 1)
      begin
         assign pre_tdo = (|cltapc_wtap_sel == HIGH) ? mtap_wtapnw_tdo : mtap_muxtdo_wtapwso;
      end
      else
      begin
         assign pre_tdo = mtap_muxtdo_wtapwso;
      end
   endgenerate

   // *********************************************************************
   // Reset generation logic
   // *********************************************************************
   assign powergoodrst_trst_b = atappris_trst_b & powergoodrst_b;

   // *********************************************************************
   // TDOEN generation logic. When remove bit is asserted tapnw tdoen is
   // selected, else internal tdoen is selected.
   // *********************************************************************
   assign ftappris_tdoen = (cltapc_remove == HIGH) ? (|cntapnw_atap_tdo_en) : mtap_tdomux_tdoen;

endmodule
