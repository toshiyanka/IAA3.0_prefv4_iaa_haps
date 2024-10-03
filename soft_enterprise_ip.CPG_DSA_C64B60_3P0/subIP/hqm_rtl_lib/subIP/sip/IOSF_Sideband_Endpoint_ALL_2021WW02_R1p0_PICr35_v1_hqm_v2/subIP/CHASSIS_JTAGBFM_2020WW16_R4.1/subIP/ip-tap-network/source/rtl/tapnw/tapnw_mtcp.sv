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
//    FILENAME    : tapnw_mtcp.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : TAPNW Control Path Implementation
//    DESCRIPTION :
//       This module contains all the control path logic required for
//       proper functioning of TAPNW
//    PARAMETERS  :
//    MTCP_TAPNW_NUMBER_OF_STAPS
//       This parameter specifies the number of Slave TAP's in the network
//       and will normally be passed from the upper module where this module
//       gets instantiated.
//    MTCP_TAPNW_NUMBER_OF_WTAPS
//       This parameter specifies the number of Wrapper TAP's in the network
//       and will normally be passed from the upper module where this module
//       gets instantiated. This Parameter is set to 0
//    MTCP_TAPNW_POSITION_OF_TAPS
//       This parameter specifies the position of Slave TAP's & Wrapper TAP's
//       in the network. 0 indicates a Slave TAP & 1 indicates a Wrapper TAP
//       register.  This parameter will normally be passed from upper module
//       where this module gets instantiated.
//----------------------------------------------------------------------

module tapnw_mtcp 
      #(
         // *********************************************************************
         // Parameters
         // *********************************************************************
         parameter MTCP_TAPNW_NUMBER_OF_STAPS           = 1,
         parameter MTCP_TAPNW_NUMBER_OF_WTAPS           = 0,
         parameter MTCP_TAPNW_IOSOLATETAP_GATETCK       = 1,
         parameter MTCP_TAPNW_PARK_TCK_AT               = 8'b0000_0000, 
         parameter MTCP_TAPNW_HIER_HYBRID               = 0, 
         parameter MTCP_TAPNW_NO_OF_STAPS_IN_SUBNW      = 1, 
         parameter [(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS - 1):0] MTCP_TAPNW_POSITION_OF_TAPS = 1'b0,

         // *********************************************************************
         // Local Parameters
         // *********************************************************************
         parameter MTCP_TAPNW_NO_OF_STAPS = (MTCP_TAPNW_NUMBER_OF_STAPS == 0) ? 1 : MTCP_TAPNW_NUMBER_OF_STAPS,
         parameter MTCP_TAPNW_NO_OF_WTAPS = (MTCP_TAPNW_NUMBER_OF_WTAPS == 0) ? 1 : MTCP_TAPNW_NUMBER_OF_WTAPS

       )
      (
         // *********************************************************************
         // Port Declarations
         // *********************************************************************
         //CLTAPC INTERFACE
         input logic                                                                   itck,
         input logic                                                                   itms,
         input logic                                                                   itrst_b,
         input logic [(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS - 1):0] isec_sel,
         input logic [(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS - 1):0] ienabletap,
         input logic [(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS - 1):0] ienbtdo,
         input logic                                                                   powergoodrst_b,

         //SECONDARY PORT
         input logic itck2,
         input logic itms2,
         input logic itrst_b2,

         //STAP INTERFACE
         output logic [(MTCP_TAPNW_NO_OF_STAPS - 1):0] ostap_tck,
         output logic [(MTCP_TAPNW_NO_OF_STAPS - 1):0] ostap_tms,
         output logic [(MTCP_TAPNW_NO_OF_STAPS - 1):0] ostap_trst_b,

         //MTDP INTERFACE
         output logic [(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS - 1):0] osec_sel_reg,
         output logic [(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS - 1):0] oenabletdo,
         output logic [(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS - 1):0] oenabletap,

         //VERCODE
         input  logic [3:0]  ftapnw_ftap_vercodei,
         output logic [3:0]  ftapnw_ftap_vercodeo,

         //PRIMARY PORT -- passthrough signals for ptapnw_ftap_tck, ptapnw_ftap_tms and ptapnw_ftap_trst_b
         output  logic    otck,
         output  logic    otms,
         output  logic    otrst_b,

         //SECONDARY JTAG PORT -- passthrough signals for ptapnw_ftap_tck2, ptapnw_ftap_tms2 and ptapnw_ftap_trst2_b
         output  logic    otck2,
         output  logic    otms2,
         output  logic    otrst_b2,

         //Sub Tap Control logic
         input   logic [(MTCP_TAPNW_NO_OF_STAPS - 1):0] atapnw_atap_subtapactvi,
         output  logic                                  atapnw_atap_subtapactvo
      );

   // *********************************************************************
   // local parameters
   // *********************************************************************
   localparam HIGH    = 1'b1;
   localparam LOW     = 1'b0;
   localparam FOUR    = 4;
   localparam THREE   = 3;
   localparam TWO     = 2;
   localparam SIXTEEN = 16;

   // *********************************************************************
   // Wires & Regs
   // *********************************************************************
   logic [(MTCP_TAPNW_NO_OF_STAPS - 1):0]                                  primsec_muxd_tms;
   logic [(MTCP_TAPNW_NO_OF_STAPS - 1):0]                                  primsec_muxd_tck;
   logic [(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS - 1):0] int_sec_sel_reg;
   logic [(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS - 1):0] int_enabletap_reg;
   logic [(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS - 1):0] isec_sel_clear;
   logic [(MTCP_TAPNW_NO_OF_STAPS - 1):0]                                  mtcp_park_tck_at_loc;

   // *********************************************************************
   // Generate logic for Secondary Select Enable TAP & Enable TDO for each sTAP.
   // *********************************************************************
   assign isec_sel_clear = ~isec_sel;

    generate for(genvar n = 0; n < (MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS); n = (n + 1))
     begin : lbl_osec_sel_reg
      always_ff @(negedge itck or posedge isec_sel_clear[n])
       begin
          if (isec_sel_clear[n] == HIGH)
             osec_sel_reg[n] <= LOW;
          else
             osec_sel_reg[n] <= isec_sel[n];
       end
    end
   endgenerate

   assign int_sec_sel_reg = osec_sel_reg;

   // *********************************************************************
   //Flop  enable tap on negedge of TCK
   // *********************************************************************
   always_ff @(negedge itck or negedge powergoodrst_b)
    begin
          if (powergoodrst_b == LOW )
             oenabletap <= {(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS){LOW}};
          else
             oenabletap <= ienabletap;
    end

    assign int_enabletap_reg = oenabletap;
   // *********************************************************************
   // Flop for generating the select for muxes between primary and secondary
   // clock (ptapnw_ftap_tck and itck2) ,reset (itrst_b and itrst_b2) and mode slect (ptapnw_ftap_tms and itms2)
   // *********************************************************************

    assign mtcp_park_tck_at_loc = MTCP_TAPNW_PARK_TCK_AT;

    generate for(genvar m = 0; m < (MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS); m = (m + 1))
       begin : lbl_siptapnwctech_mx22_clk
          if (MTCP_TAPNW_POSITION_OF_TAPS[m] == LOW) // If Stap
          begin
             //always_comb
             begin
                //ostap_trst_b[m]     = int_sec_sel_reg[m] ? itrst_b2 : itrst_b;
                siptapnwctech_mx22_clk i_siptapnwctech_mx22_clk_trst_ps (.d1(itrst_b2), .d2(itrst_b), .s(int_sec_sel_reg[m]), .o(ostap_trst_b[m]));

                //primsec_muxd_tck[m] = int_sec_sel_reg[m] ? itck2    : itck;
                siptapnwctech_mx22_clk i_siptapnwctech_mx22_clk_tck_ps (.d1(itck2), .d2(itck), .s(int_sec_sel_reg[m]), .o(primsec_muxd_tck[m]));

                assign primsec_muxd_tms[m] = int_sec_sel_reg[m] ? itms2    : itms;

                if (MTCP_TAPNW_IOSOLATETAP_GATETCK == HIGH) // Option2 new from HAS// This is alwasy 1 now.
                begin
                   assign ostap_tms[m] = primsec_muxd_tms[m];

                   //Qualifying Primary or Secondary TCK with Enable tap
                   // ostap_tck[m] = primsec_muxd_tck[m] & int_enabletap_reg[m] ;
                   //ostap_tck[m] = int_enabletap_reg[m] ? primsec_muxd_tck[m] : mtcp_park_tck_at_loc[m] ;
                   siptapnwctech_mx22_clk i_siptapnwctech_mx22_clk_clk_sta (.d1(primsec_muxd_tck[m]), .d2(mtcp_park_tck_at_loc[m]), .s(int_enabletap_reg[m]), .o(ostap_tck[m]));
                end
                else  // Option1 original from HAS // This will never be executed, kept only for legacy purpose.
                begin
                   //Qualifying Primary or Secondary TMS signal with Enable tap
                   assign ostap_tms[m] = int_enabletap_reg[m] ?  primsec_muxd_tms[m] : HIGH; 

                   assign ostap_tck[m] = primsec_muxd_tck[m];
                end
             end
          end
       end
    endgenerate



   // *********************************************************************
   // Assigning Unused output ports to 0 when number of STAPS is 0  
   // ********************************************************************* 
   generate
    if (MTCP_TAPNW_NUMBER_OF_STAPS == 0)
       begin : lbl_ostap
         always_comb
          begin
            ostap_trst_b[0] = LOW;
            ostap_tck[0]    = LOW;
            ostap_tms[0]    = LOW;
          end
       end
   endgenerate

   // *********************************************************************
   //Control Logic for Vercode for STAPS and WTAPS
   // *********************************************************************
   //   genvar i;
   //   generate for (i = 0; i < (MTCP_TAPNW_NUMBER_OF_WTAPS + MTCP_TAPNW_NUMBER_OF_STAPS); i++)
   //      begin
   //         assign ftapnw_ftap_vercodeo[(FOUR * i)]           = ftapnw_ftap_vercodei[0];
   //         assign ftapnw_ftap_vercodeo[((FOUR * i) + 1)]     = ftapnw_ftap_vercodei[1];
   //         assign ftapnw_ftap_vercodeo[((FOUR * i) + TWO)]   = ftapnw_ftap_vercodei[TWO];
   //         assign ftapnw_ftap_vercodeo[((FOUR * i) + THREE)] = ftapnw_ftap_vercodei[THREE];
   //      end
   //   endgenerate

   // *********************************************************************
   // The Above control logic changed to A feed through  
   // *********************************************************************
   
       assign ftapnw_ftap_vercodeo = ftapnw_ftap_vercodei ;      

   // *********************************************************************
   // Flop the ENABLETDO going to each sTAP.
   // Changed it to negedge after Mike W discussion.
   // *********************************************************************
   always_ff @(negedge itck or negedge powergoodrst_b)
   begin
      if (powergoodrst_b == LOW)
         oenabletdo <= {(MTCP_TAPNW_NUMBER_OF_STAPS + MTCP_TAPNW_NUMBER_OF_WTAPS){LOW}};
      else
         oenabletdo <= ienbtdo;
   end

   // *********************************************************************
   // subtap active logic. Or all the inputs from Child sTAPs and pass it on Father sTAP/CLTAPC
   // *********************************************************************

   assign atapnw_atap_subtapactvo  = | atapnw_atap_subtapactvi;

   // *********************************************************************
   // Passthrough of primary and Secondary ptapnw_ftap_tck, ptapnw_ftap_tms  and trst ports
   // *********************************************************************
   assign otck                   =  itck;
   assign otms                   =  itms;
   assign otrst_b                =  itrst_b;

   assign otck2                  =  itck2;
   assign otms2                  =  itms2;
   assign otrst_b2               =  itrst_b2;


endmodule
