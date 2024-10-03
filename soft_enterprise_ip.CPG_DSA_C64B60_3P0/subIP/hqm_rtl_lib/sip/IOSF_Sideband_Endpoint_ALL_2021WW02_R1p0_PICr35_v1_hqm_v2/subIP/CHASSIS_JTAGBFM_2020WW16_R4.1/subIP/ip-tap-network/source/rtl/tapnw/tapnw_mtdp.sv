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
//  Module <TAPNW> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : tapnw_mtdp.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : TAPNW Data Path Implementation
//    DESCRIPTION :
//       This module contains all the data path logic required for proper
//       functioning of TAPNW
//    PARAMETERS  :
//    MTDP_TAPNW_NUMBER_OF_STAPS
//       This parameter specifies the number of Slave TAP's in the network
//       and will normally be passed from the upper module where this module
//       gets instantiated.
//    MTDP_TAPNW_NUMBER_OF_WTAPS
//       This parameter specifies the number of Wrapper TAP's in the network
//       and will normally be passed from the upper module where this module
//       gets instantiated. This Parameter is set to Zero.
//    MTDP_TAPNW_POSITION_OF_TAPS
//       This parameter specifies the position of Slave TAP's & Wrapper TAP's
//       in the network. 0 indicates a Slave TAP & 1 indicates a Wrapper TAP
//       register.  This parameter will normally be passed from upper module
//       where this module gets instantiated.
//----------------------------------------------------------------------

module  tapnw_mtdp 
      #(
         // *********************************************************************
         // Parameters
         // *********************************************************************
         parameter MTDP_TAPNW_NUMBER_OF_STAPS           = 1,
         parameter MTDP_TAPNW_NUMBER_OF_WTAPS           = 0,
         parameter MTDP_TAPNW_IOSOLATETAP_GATETCK       = 1,
         parameter MTDP_TAPNW_PARK_TCK_AT               = 8'b0000_0000, 
         parameter MTDP_TAPNW_HIER_HYBRID               = 0, 
         parameter MTDP_TAPNW_NO_OF_STAPS_IN_SUBNW      = 1, 
         parameter [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] MTDP_TAPNW_POSITION_OF_TAPS = 1'b0,

         // *********************************************************************
         // Local Parameters
         // *********************************************************************
         parameter MTDP_TAPNW_NO_OF_STAPS = (MTDP_TAPNW_NUMBER_OF_STAPS == 0) ? 1 : MTDP_TAPNW_NUMBER_OF_STAPS,
         parameter MTDP_TAPNW_NO_OF_WTAPS = (MTDP_TAPNW_NUMBER_OF_WTAPS == 0) ? 1 : MTDP_TAPNW_NUMBER_OF_WTAPS
      )
      (
         // *********************************************************************
         // Port Declarations
         // *********************************************************************
         //CLTAPC INTERFACE
         input  logic itdi,
         output logic otdo,
         output logic otdo_en,

         //SECONDARY PORT
         input  logic itdi2,
         output logic otdo2,
         output logic otdo2_en,

         //STAP INTERFACE
         output logic [(MTDP_TAPNW_NO_OF_STAPS - 1):0] ostap_tdi,
         input  logic [(MTDP_TAPNW_NO_OF_STAPS - 1):0] istap_tdo,
         input  logic [(MTDP_TAPNW_NO_OF_STAPS - 1):0] istap_tdo_en,

         //MTCP INTERFACE
         input logic [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] ienabletap,
         input logic [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] isec_sel_reg,
         input logic [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] ienabletdo,

         //HYBRID INTERFACE
         input logic [(MTDP_TAPNW_NO_OF_STAPS_IN_SUBNW - 1):0] ntapnw_ftap_secsel, 
         input logic ntapnw_sslv_tdo2, 
         input logic ntapnw_sslv_tdo2_en


      );
   // *********************************************************************
   // Local Parameters
   // *********************************************************************
   localparam SIXTEEN                   = 16;
   localparam HIGH                      = 1'b1;
   localparam LOW                       = 1'b0;
   localparam ONE_BIT_UNKNOWN_VALUE     = 1'bx;

   // *********************************************************************
   // Wires & Regs
   // *********************************************************************
   logic [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] tdi_current;
   logic [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] tdo_next;
   logic [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] tdo_final;
   logic [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] tdo2_final;
   logic [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] otdo_en_internal;
   logic [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] otdo2_en_internal;
   logic [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] isec_sel_reg_internal;
   logic [(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1):0] ienabletap_NC;
   logic                                                                   otdo2_en_prehybrid;


   //**********************************************************************
   //Making Sure secondary select register bits that corresponds to WTAP is
   //equal to 0
   //***********************************************************************
   generate
      for (genvar i = 0; i < (MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS); i++)
      begin : lbl_secondary_select_reg
         if (MTDP_TAPNW_POSITION_OF_TAPS[i] == LOW) // if Stap , assign the corresponding bit of secondary select bit 
         begin
            assign isec_sel_reg_internal[i] = isec_sel_reg[i];
         end
      end
   endgenerate

   //**********************************************************************
   //Addition of mux logic for hierarchical HYBRID mode. If ntapnw_ftap_secsel is 1 the
   // the data from child subnetwork takes precedence over current mux logic.
   //***********************************************************************

   generate
      if (MTDP_TAPNW_HIER_HYBRID  == 1)
      begin : lbl_tdo2_final
         logic  ntapnw_ftap_secsel_mxsel;
         assign ntapnw_ftap_secsel_mxsel = |ntapnw_ftap_secsel;

         always_comb
         begin
            case ({isec_sel_reg_internal[0],ntapnw_ftap_secsel_mxsel })
               2'b00:
               begin
                  tdo2_final[0] = itdi2;
                  otdo2_en      = otdo2_en_prehybrid;
               end
               2'b01:
               begin
                  tdo2_final[0] = ntapnw_sslv_tdo2;
                  otdo2_en      = ntapnw_sslv_tdo2_en;
               end
               2'b10:
               begin
                  tdo2_final[0] = tdo_next[0];
                  otdo2_en      = otdo2_en_prehybrid;
               end
               2'b11:
               begin
                  tdo2_final[0] = ntapnw_sslv_tdo2;
                  otdo2_en      = ntapnw_sslv_tdo2_en;
               end
               default:
               begin
                  tdo2_final[0] = ONE_BIT_UNKNOWN_VALUE;
                  otdo2_en      = ONE_BIT_UNKNOWN_VALUE;
               end
            endcase
         end
      end
      else
      begin
         logic  [(MTDP_TAPNW_NO_OF_STAPS_IN_SUBNW - 1):0] ntapnw_ftap_secsel_NC;
         logic                                            ntapnw_sslv_tdo2_NC; 
         logic                                            ntapnw_sslv_tdo2_en_NC;

         assign ntapnw_ftap_secsel_NC  = ntapnw_ftap_secsel;
         assign ntapnw_sslv_tdo2_NC    = ntapnw_sslv_tdo2;
         assign ntapnw_sslv_tdo2_en_NC = ntapnw_sslv_tdo2_en;

         assign tdo2_final[0]          = isec_sel_reg_internal[0] ? tdo_next[0]           : itdi2;
         assign otdo2_en               = otdo2_en_prehybrid;
      end
   endgenerate

   // End of HYBRID Mode Logic

   // *********************************************************************
   // First TAP in the network gets the TDI from CLTAPC.
   // *********************************************************************

   assign tdi_current[0]  =  isec_sel_reg_internal[0] ? itdi2                 : itdi;
   assign tdo_final[0]    =  isec_sel_reg_internal[0] ? itdi                  : tdo_next[0];
   //assign tdo2_final[0]   =  isec_sel_reg_internal[0] ? tdo_next[0]           : itdi2;

   // **********************************************************************
   // Generate TDI & TDO for each sTAP and depending
   // on how many are in network.
   // **********************************************************************

   generate for(genvar m = 0; m < (MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS); m++)
      begin : lbl_ostap_tdi
         if (MTDP_TAPNW_POSITION_OF_TAPS[m] == 0)   // if STAP
         begin
            //-----Mux at the output of each STAP
            assign tdo_next[m] = ienabletdo[m] ? istap_tdo[m] : tdi_current[m];
                if (MTDP_TAPNW_IOSOLATETAP_GATETCK == HIGH) // Option2 new from HAS
                begin
                   assign ostap_tdi[m]     = tdi_current[m];
                   assign ienabletap_NC[m] = ienabletap[m];
                end
                else  // Option1 original from HAS
                begin
                   //-----Input of the STAP qualifying with enabletap--------------------
                   assign ostap_tdi[m] = ienabletap[m] ? tdi_current[m] : HIGH ;
                end
         end
      end
   endgenerate

   generate
      if ((MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS) > 1)
      begin : lbl_tdi_curr_tdo_final_tdo2
         for(genvar n = 1; n < (MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS); n++)
         begin
            assign tdi_current[n]   =  isec_sel_reg_internal[n] ? tdo2_final[(n - 1)] : tdo_final[(n - 1)];
            assign tdo_final[n]     =  isec_sel_reg_internal[n] ? tdo_final[(n - 1)]  : tdo_next[n];
            assign tdo2_final[n]    =  isec_sel_reg_internal[n] ? tdo_next[n]         : tdo2_final[(n - 1)];
         end
      end
   endgenerate

   // *********************************************************************
   // Last sTAP in the network sends its TDO to CLTAPC.
   // *********************************************************************

   assign otdo        = tdo_final[(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1)];
   assign otdo2       = tdo2_final[(MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS - 1)];


   // *********************************************************************
   // Tdoen generation for the secondary port
   // Qualify each stap ntapnw_atap_tdo_en signal with secondary select bit and then OR them
   // *********************************************************************

   generate 
   
   for(genvar k = 0; k < (MTDP_TAPNW_NUMBER_OF_STAPS + MTDP_TAPNW_NUMBER_OF_WTAPS); k++)
      begin : lbl_otdo2_en
         if (MTDP_TAPNW_POSITION_OF_TAPS[k] == 0) //if Stap
         begin
            assign otdo2_en_internal[k] = (isec_sel_reg_internal[k] & istap_tdo_en[k]);
            assign otdo_en_internal[k]  = (~(isec_sel_reg_internal[k]) & istap_tdo_en[k]);
         end
      end
   endgenerate

   assign otdo2_en_prehybrid = | otdo2_en_internal;
   assign otdo_en            = | otdo_en_internal;

endmodule
