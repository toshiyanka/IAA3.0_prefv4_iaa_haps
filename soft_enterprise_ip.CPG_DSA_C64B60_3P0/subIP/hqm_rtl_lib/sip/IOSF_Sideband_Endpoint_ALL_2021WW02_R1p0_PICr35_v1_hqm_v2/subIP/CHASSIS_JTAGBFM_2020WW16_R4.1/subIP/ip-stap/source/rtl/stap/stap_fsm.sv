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
//    FILENAME    : stap_fsm.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    
//    
//    PURPOSE     : sTAP FSM Logic
//    DESCRIPTION :
//       This module implements fsm for IEEE 1149.1 standard.
//       For more details please refer IEEE 1149.1 standard.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    TLRS
//       This is encoding value for state TLRS
//
//    RUTI
//       This is encoding value for state RUTI
//
//    SDRS
//       This is encoding value for state SDRS
//
//    CADR
//       This is encoding value for state CADR
//
//    SHDR
//       This is encoding value for state SHDR
//
//    E1DR
//       This is encoding value for state E1DR
//
//    PADR
//       This is encoding value for state PADR
//
//    E2DR
//       This is encoding value for state E2DR
//
//    UPDR
//       This is encoding value for state UPDR
//
//    SIRS
//       This is encoding value for state SIRS
//
//    CAIR
//       This is encoding value for state CAIR
//
//    SHIR
//       This is encoding value for state SHIR
//
//    E1IR
//       This is encoding value for state E1IR
//
//    PAIR
//       This is encoding value for state PAIR
//
//    E2IR
//       This is encoding value for state E2IR
//
//    UPIR
//       This is encoding value for state UPIR
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//
//    FOUR_BIT_UNKNOWN_VALUE
//       This is 4 bit X value to and is declared just to avoid lint warnings
//
//    FOUR_BIT_LOW_VALUE
//       This is 4 bit 0 value to and is declared just to avoid lint warnings
//
//    TWO
//       This is number 2 to and is declared just to avoid lint warnings
//
//----------------------------------------------------------------------
module stap_fsm
   #(
   parameter FSM_STAP_ENABLE_TAP_NETWORK                 = 0,
   parameter FSM_STAP_WTAP_COMMON_LOGIC                  = 0,
   parameter FSM_STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS  = 0
   )
   (
   input  logic ftap_tms,
   input  logic ftap_tck,
   input  logic powergoodrst_trst_b,
   input  logic tapc_remove,
   output logic stap_fsm_tlrs,
   output logic stap_fsm_rti,
   output logic stap_fsm_e1dr,
   output logic stap_fsm_e2dr,
   output logic stap_selectwir,
   output logic stap_selectwir_neg, //kbbhagwa posedge negedge signal merge

   output logic sn_fwtap_capturewr,
   output logic sn_fwtap_shiftwr,
   output logic sn_fwtap_updatewr,
   output logic sn_fwtap_rti,
   output logic sn_fwtap_wrst_b,
   output logic stap_fsm_capture_ir,
   output logic stap_fsm_shift_ir,
   output logic stap_fsm_shift_ir_neg,//kbbhagwa posedge negedge signal merge

   output logic stap_fsm_update_ir,
   output logic stap_fsm_capture_dr,
   output logic stap_fsm_capture_dr_nxt, //kbbhagwa cdc fix
   output logic stap_fsm_shift_dr,
   //output logic stap_fsm_shift_dr_neg, //kbbhagwa hsd2904953 posneg
   output logic stap_fsm_update_dr_nxt, //kbbhagwa cdc fix
   output logic stap_fsm_update_dr
   );

   // *********************************************************************
   // Local parameters
   // *********************************************************************
   // FSM State decoding
   // ---------------------------------------------------------------------
   localparam TLRS = 16'h0001;
   localparam RUTI = 16'h0002;
   localparam SDRS = 16'h0004;
   localparam CADR = 16'h0008;
   localparam SHDR = 16'h0010;
   localparam E1DR = 16'h0020;
   localparam PADR = 16'h0040;
   localparam E2DR = 16'h0080;
   localparam UPDR = 16'h0100;
   localparam SIRS = 16'h0200;
   localparam CAIR = 16'h0400;
   localparam SHIR = 16'h0800;
   localparam E1IR = 16'h1000;
   localparam PAIR = 16'h2000;
   localparam E2IR = 16'h4000;
   localparam UPIR = 16'h8000;


   localparam HIGH                      = 1'b1;
   localparam LOW                       = 1'b0;
   localparam FOUR_BIT_UNKNOWN_VALUE    = 4'hX;
   localparam FOUR_BIT_LOW_VALUE        = 4'h0;
   localparam SIXTEEN_BIT_UNKNOWN_VALUE = 16'hX;
   localparam ZERO                      = 0;
   localparam ONE                       = 1;
   localparam TWO                       = 2;
   localparam THREE                     = 3;
   localparam FOUR                      = 4;
   localparam FIVE                      = 5;
   localparam SIX                       = 6;
   localparam SEVEN                     = 7;
   localparam EIGHT                     = 8;
   localparam NINE                      = 9;
   localparam TEN                       = 10;
   localparam ELEVEN                    = 11;
   localparam TWELVE                    = 12;
   localparam THIRTEEN                  = 13;
   localparam FOURTEEN                  = 14;
   localparam FIFTEEN                   = 15;

   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic [15:0] state_ps;
   logic [15:0] state_ns;
   logic [3:0] tms_bit;
    
   logic arc_tlrs_ruti;
   logic arc_ruti_sdrs;
   logic arc_sdrs_cadr;
   logic arc_cadr_shdr;
   logic arc_shdr_e1dr;
   logic arc_e1dr_padr;
   logic arc_padr_e2dr;
   logic arc_e2dr_updr;
   logic arc_e1dr_updr;
   logic arc_e2dr_shdr;
   logic arc_cadr_e1dr;
   logic arc_updr_sdrs;
   logic arc_updr_ruti;
   logic arc_sdrs_sirs;
   logic arc_sirs_cair;
   logic arc_cair_shir;
   logic arc_shir_e1ir;
   logic arc_e1ir_pair;
   logic arc_pair_e2ir;
   logic arc_e2ir_upir;
   logic arc_e1ir_upir;
   logic arc_e2ir_shir;
   logic arc_cair_e1ir;
   logic arc_upir_sdrs;
   logic arc_upir_ruti;
   logic arc_sirs_tlrs;

   logic tlrs_present_state;
   logic ruti_present_state;
   logic sdrs_present_state;
   logic cadr_present_state;

   logic cadr_next_state; // kbbhagwa cdc fix

   logic shdr_present_state;
   logic e1dr_present_state;
   logic padr_present_state;
   logic e2dr_present_state;
   logic updr_present_state;

   logic updr_next_state; //kbbhagwa cdc fix
   logic sirs_present_state;
   logic cair_present_state;
   logic shir_present_state;
   logic e1ir_present_state;
   logic pair_present_state;
   logic e2ir_present_state;
   logic upir_present_state;

   logic tlrs_next_state;
   logic sirs_next_state;

   logic [1:0] sdrs_cadr_or_sirs;
   logic [1:0] sirs_cair_or_tlrs;
   logic [1:0] cadr_shdr_or_e1dr;
   logic [1:0] e1dr_padr_or_updr;
   logic [1:0] e2dr_shdr_or_updr;
   logic [1:0] updr_ruti_or_sdrs;

   logic [1:0] cair_shir_or_e1ir;
   logic [1:0] e1ir_pair_or_upir;
   logic [1:0] e2ir_shir_or_upir;
   logic [1:0] upir_ruti_or_sdrs;

   logic soft_reset;
   logic ftap_tms_internal;

   logic stap_capturewr_int;
   logic stap_shiftwr_int;

   // *********************************************************************
   // Present state assignments
   // *********************************************************************
   // assign tlrs_present_state = (state_ps == TLRS);
   // assign ruti_present_state = (state_ps == RUTI);
   // assign sdrs_present_state = (state_ps == SDRS);
   // assign cadr_present_state = (state_ps == CADR);
   // assign shdr_present_state = (state_ps == SHDR);
   // assign e1dr_present_state = (state_ps == E1DR);
   // assign padr_present_state = (state_ps == PADR);
   // assign e2dr_present_state = (state_ps == E2DR);
   // assign updr_present_state = (state_ps == UPDR);
   // assign sirs_present_state = (state_ps == SIRS);
   // assign cair_present_state = (state_ps == CAIR);
   // assign shir_present_state = (state_ps == SHIR);
   // assign e1ir_present_state = (state_ps == E1IR);
   // assign pair_present_state = (state_ps == PAIR);
   // assign e2ir_present_state = (state_ps == E2IR);
   // assign upir_present_state = (state_ps == UPIR);



   assign tlrs_present_state = (state_ps[ZERO]     == HIGH); // TLRS);
   assign ruti_present_state = (state_ps[ONE]      == HIGH); // RUTI);
   assign sdrs_present_state = (state_ps[TWO]      == HIGH); // SDRS);
   assign cadr_present_state = (state_ps[THREE]    == HIGH); // CADR);
   assign cadr_next_state    = (state_ns[THREE]    == HIGH); // CADR next);kbbhagwa cdc fix

   assign shdr_present_state = (state_ps[FOUR]     == HIGH); // SHDR);
   assign e1dr_present_state = (state_ps[FIVE]     == HIGH); // E1DR);
   assign padr_present_state = (state_ps[SIX]      == HIGH); // PADR);
   assign e2dr_present_state = (state_ps[SEVEN]    == HIGH); // E2DR);
   assign updr_present_state = (state_ps[EIGHT]    == HIGH); // UPDR);

   assign updr_next_state = (state_ns[EIGHT]    == HIGH); // UPDR); kbbhagwa cdc fix

   assign sirs_present_state = (state_ps[NINE]     == HIGH); // SIRS);
   assign cair_present_state = (state_ps[TEN]      == HIGH); // CAIR);
   assign shir_present_state = (state_ps[ELEVEN]   == HIGH); // SHIR);
   assign e1ir_present_state = (state_ps[TWELVE]   == HIGH); // E1IR);
   assign pair_present_state = (state_ps[THIRTEEN] == HIGH); // PAIR);
   assign e2ir_present_state = (state_ps[FOURTEEN] == HIGH); // E2IR);
   assign upir_present_state = (state_ps[FIFTEEN]  == HIGH); // UPIR);

   assign tlrs_next_state = (state_ns == TLRS);
   assign sirs_next_state = (state_ns == SIRS);

   // *********************************************************************
   // FSM signal declarations. E.g. sdrs_cadr_or_sirs - is the decision
   // making register between "switch from SDRS to CADR" or "switch from
   // SDRS to SIRS"
   // *********************************************************************
   assign sdrs_cadr_or_sirs[1:0] = {arc_sdrs_cadr, arc_sdrs_sirs};
   assign sirs_cair_or_tlrs[1:0] = {arc_sirs_cair, arc_sirs_tlrs};
   assign cadr_shdr_or_e1dr[1:0] = {arc_cadr_shdr, arc_cadr_e1dr};
   assign e1dr_padr_or_updr[1:0] = {arc_e1dr_padr, arc_e1dr_updr};
   assign e2dr_shdr_or_updr[1:0] = {arc_e2dr_shdr, arc_e2dr_updr};
   assign updr_ruti_or_sdrs[1:0] = {arc_updr_ruti, arc_updr_sdrs};
   assign cair_shir_or_e1ir[1:0] = {arc_cair_shir, arc_cair_e1ir};
   assign e1ir_pair_or_upir[1:0] = {arc_e1ir_pair, arc_e1ir_upir};
   assign e2ir_shir_or_upir[1:0] = {arc_e2ir_shir, arc_e2ir_upir};
   assign upir_ruti_or_sdrs[1:0] = {arc_upir_ruti, arc_upir_sdrs};

   // *********************************************************************
   // Implementation of next state logic.
   // *********************************************************************
   always_comb
   begin
      case (state_ps)
      TLRS:
      begin
         case (arc_tlrs_ruti)
         HIGH:
         begin
            state_ns = RUTI;
         end
         LOW:
         begin
            state_ns = TLRS;
         end
         default:
         begin
            state_ns = TLRS;
         end
         endcase
      end
      RUTI:
      begin
         case (arc_ruti_sdrs)
         HIGH:
         begin
            state_ns = SDRS;
         end
         LOW:
         begin
            state_ns = RUTI;
         end
         default:
         begin
            state_ns = RUTI;
         end
         endcase
      end
      SDRS:
      begin
         case (sdrs_cadr_or_sirs)
         2'b01:
         begin
            state_ns = SIRS;
         end
         2'b10:
         begin
            state_ns = CADR;
         end
         default:
         begin
            state_ns = SDRS;
         end
         endcase
      end
      SIRS:
      begin
         case (sirs_cair_or_tlrs)
         2'b01:
         begin
            state_ns = TLRS;
         end
         2'b10:
         begin
            state_ns = CAIR;
         end
         default:
         begin
            state_ns = SIRS;
         end
         endcase
      end
      CADR:
      begin
         case (cadr_shdr_or_e1dr)
         2'b01:
         begin
            state_ns = E1DR;
         end
         2'b10:
         begin
            state_ns = SHDR;
         end
         default:
         begin
            state_ns = CADR;
         end
         endcase
      end
      SHDR:
      begin
         case (arc_shdr_e1dr)
         HIGH:
         begin
            state_ns = E1DR;
         end
         LOW:
         begin
            state_ns = SHDR;
         end
         default:
         begin
            state_ns = SHDR;
         end
         endcase
      end
      E1DR:
      begin
         case (e1dr_padr_or_updr)
         2'b01:
         begin
            state_ns = UPDR;
         end
         2'b10:
         begin
            state_ns = PADR;
         end
         default:
         begin
            state_ns = E1DR;
         end
         endcase
      end
      PADR:
      begin
         case (arc_padr_e2dr)
         HIGH:
         begin
            state_ns = E2DR;
         end
         LOW:
         begin
            state_ns = PADR;
         end
         default:
         begin
            state_ns = PADR;
         end
         endcase
      end
      E2DR:
      begin
         case (e2dr_shdr_or_updr)
         2'b01:
         begin
            state_ns = UPDR;
         end
         2'b10:
         begin
            state_ns = SHDR;
         end
         default:
         begin
            state_ns = E2DR;
         end
         endcase
      end
      UPDR:
      begin
         case (updr_ruti_or_sdrs)
         2'b01:
         begin
            state_ns = SDRS;
         end
         2'b10:
         begin
            state_ns = RUTI;
         end
         default:
         begin
            state_ns = UPDR;
         end
         endcase
      end
      CAIR:
      begin
         case (cair_shir_or_e1ir)
         2'b01:
         begin
            state_ns = E1IR;
         end
         2'b10:
         begin
            state_ns = SHIR;
         end
         default:
         begin
            state_ns = CAIR;
         end
         endcase
      end
      SHIR:
      begin
         case (arc_shir_e1ir)
         HIGH:
         begin
            state_ns = E1IR;
         end
         LOW:
         begin
            state_ns = SHIR;
         end
         default:
         begin
            state_ns = SHIR;
         end
         endcase
      end
      E1IR:
      begin
         case (e1ir_pair_or_upir)
         2'b01:
         begin
            state_ns = UPIR;
         end
         2'b10:
         begin
            state_ns = PAIR;
         end
         default:
         begin
            state_ns = E1IR;
         end
         endcase
      end
      PAIR:
      begin
         case (arc_pair_e2ir)
         HIGH:
         begin
            state_ns = E2IR;
         end
         LOW:
         begin
            state_ns = PAIR;
         end
         default
         begin
            state_ns = PAIR;
         end
         endcase
      end
      E2IR:
      begin
         case (e2ir_shir_or_upir)
         2'b01:
         begin
            state_ns = UPIR;
         end
         2'b10:
         begin
            state_ns = SHIR;
         end
         default
         begin
            state_ns = E2IR;
         end
         endcase
      end
      UPIR:
      begin
         case (upir_ruti_or_sdrs)
         2'b01:
         begin
            state_ns = SDRS;
         end
         2'b10:
         begin
            state_ns = RUTI;
         end
         default:
         begin
            state_ns = UPIR;
         end
         endcase
      end
      default:
      begin
         state_ns = SIXTEEN_BIT_UNKNOWN_VALUE;
      end
      endcase
   end

   // *********************************************************************
   // Remove bit-TMS Logic
   // *********************************************************************
   assign ftap_tms_internal = (tapc_remove == HIGH) ? HIGH : ftap_tms;

   // FSM arc assignment
   // *********************************************************************
   assign arc_tlrs_ruti = ~ftap_tms_internal & tlrs_present_state;
   assign arc_ruti_sdrs =  ftap_tms_internal & ruti_present_state;
   assign arc_sdrs_cadr = ~ftap_tms_internal & sdrs_present_state;
   assign arc_cadr_shdr = ~ftap_tms_internal & cadr_present_state;
   assign arc_shdr_e1dr =  ftap_tms_internal & shdr_present_state;
   assign arc_e1dr_padr = ~ftap_tms_internal & e1dr_present_state;
   assign arc_padr_e2dr =  ftap_tms_internal & padr_present_state;
   assign arc_e2dr_updr =  ftap_tms_internal & e2dr_present_state;
   assign arc_e1dr_updr =  ftap_tms_internal & e1dr_present_state;
   assign arc_e2dr_shdr = ~ftap_tms_internal & e2dr_present_state;
   assign arc_cadr_e1dr =  ftap_tms_internal & cadr_present_state;
   assign arc_updr_sdrs =  ftap_tms_internal & updr_present_state;
   assign arc_updr_ruti = ~ftap_tms_internal & updr_present_state;
   assign arc_sdrs_sirs =  ftap_tms_internal & sdrs_present_state;
   assign arc_sirs_cair = ~ftap_tms_internal & sirs_present_state;
   assign arc_cair_shir = ~ftap_tms_internal & cair_present_state;
   assign arc_shir_e1ir =  ftap_tms_internal & shir_present_state;
   assign arc_e1ir_pair = ~ftap_tms_internal & e1ir_present_state;
   assign arc_pair_e2ir =  ftap_tms_internal & pair_present_state;
   assign arc_e2ir_upir =  ftap_tms_internal & e2ir_present_state;
   assign arc_e1ir_upir =  ftap_tms_internal & e1ir_present_state;
   assign arc_e2ir_shir = ~ftap_tms_internal & e2ir_present_state;
   assign arc_cair_e1ir =  ftap_tms_internal & cair_present_state;
   assign arc_upir_sdrs =  ftap_tms_internal & upir_present_state;
   assign arc_upir_ruti = ~ftap_tms_internal & upir_present_state;
   assign arc_sirs_tlrs =  ftap_tms_internal & sirs_present_state;

   // *********************************************************************
   // Five consecutive TMS=1 causes soft reset
   // *********************************************************************
   always_ff @(posedge ftap_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         tms_bit <= FOUR_BIT_LOW_VALUE;
      end
      else if (stap_fsm_tlrs)
      begin
         tms_bit <= FOUR_BIT_LOW_VALUE;
      end
      else
      begin
         tms_bit <= {tms_bit[TWO:0], ftap_tms_internal};
      end
   end

   assign soft_reset = (&tms_bit) & ftap_tms_internal;

   // *********************************************************************
   // Present state logic
   // *********************************************************************
   always_ff @(posedge ftap_tck or negedge powergoodrst_trst_b)
   begin
      if (!powergoodrst_trst_b)
      begin
         state_ps <= TLRS;
      end
      else if (soft_reset)
      begin
         state_ps <= TLRS;
      end
      else
      begin
         state_ps <= state_ns;
      end
   end

   // *********************************************************************
   // output port assignment - based on the FSM states
   // *********************************************************************
   assign stap_fsm_tlrs       = tlrs_present_state;
   assign stap_fsm_rti        = ruti_present_state;
   assign stap_fsm_e1dr       = e1dr_present_state;
   assign stap_fsm_e2dr       = e2dr_present_state;
   assign stap_fsm_capture_ir = cair_present_state;
   assign stap_fsm_shift_ir   = shir_present_state;
   assign stap_fsm_update_ir  = upir_present_state;
   assign stap_fsm_capture_dr = cadr_present_state;

   assign stap_fsm_capture_dr_nxt = cadr_next_state; //kbbhagwa cdc fix
   //kbbhagwa cdc fix , removing combo before double flop
   //https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904622

   assign stap_fsm_shift_dr   = shdr_present_state;
   assign stap_fsm_update_dr  = updr_present_state;
   assign stap_fsm_update_dr_nxt  = updr_next_state; //kbbhagwa cdc fix


//kbbhagwa
//kbbhagwa https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904720
//kbbhagwa posedge negedge signal merge
// When we drive any output it should be aligned to only a single clock edge.
//As per 1149.1 specification, the input to the TAP is driven from DTS on
//negedge. The TAP fsm works on posedge signal. The TAP fsm hence samples
//inputs from DTS on posedge. While driving output back to DTS from TAP ip we 
// need to drive it on negedge. 
//Internally there fore when we have combinatorial logic consisting of both
//posedge and negedge signals, we must ensure we drive the final signal aligned
//to negedge.

         always_ff @(negedge ftap_tck or negedge powergoodrst_trst_b)
            if (!powergoodrst_trst_b)
             begin
               stap_fsm_shift_ir_neg    <= LOW;
               //stap_fsm_shift_dr_neg    <= LOW;
               //kbbhagwa hsd2904953 posneg rtdr
             end
             else 
             begin
               stap_fsm_shift_ir_neg    <= stap_fsm_shift_ir;
               //stap_fsm_shift_dr_neg    <= stap_fsm_shift_dr;
             end

//kbbhagwa




   // *********************************************************************
   // Generation of scan IR (selectwir) signal
   // *********************************************************************
   generate
      if ((FSM_STAP_ENABLE_TAP_NETWORK == 1) || (FSM_STAP_WTAP_COMMON_LOGIC == 1) || (FSM_STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS == 1))
      begin
//kbbhagwa posedge negedge signal merge 
        always_ff @(negedge  ftap_tck or negedge powergoodrst_trst_b)
          if (!powergoodrst_trst_b)
            stap_selectwir_neg    <= LOW;
          else 
            stap_selectwir_neg    <= stap_selectwir;
      
         always_ff @(posedge ftap_tck or negedge powergoodrst_trst_b)
         begin
            if (!powergoodrst_trst_b)
            begin
               stap_selectwir    <= LOW;
            end
            else
            begin
               if (tlrs_present_state)
               begin
                  stap_selectwir <= LOW;
               end
               else if (tlrs_next_state)
               begin
                  stap_selectwir <= LOW;
               end
/* kbbhagwa wir-non-coincident
item d of 1500 spec on page 65:
d) Changes on the SelectWIR signal shall not occur coincident with Shift, Capture, Transfer, or Update operations
https://vthsd.intel.com/hsd/seg_softip/default.aspx#bug/default.aspx?bug_id=2904725
               else if (upir_present_state)
               begin
                  stap_selectwir <= LOW;
               end
*/ 
               else if ( ruti_present_state | cadr_next_state) 
                  stap_selectwir <= LOW;
               //kbbhagwa
               else if (sirs_next_state)
               begin
                  stap_selectwir <= HIGH;
               end
               else
               begin
                  stap_selectwir <= stap_selectwir;
               end
            end
         end
      end
      else
      begin
         assign stap_selectwir = LOW;
         assign stap_selectwir_neg = LOW; //kbbhagwa posedge negedge signal merge
      end
   endgenerate

   // *********************************************************************
   // code for Glue Logic requirement of stap_selectwir
   // *********************************************************************
   generate
      if (FSM_STAP_WTAP_COMMON_LOGIC == 1)
      begin
         // ---------------------------------------------------------------
         // Generation of sn_fwtap_rti, sn_fwtap_capturewr, sn_fwtap_shiftwr and sn_fwtap_updatewr
         // ---------------------------------------------------------------
         assign sn_fwtap_rti           =  ruti_present_state;
         assign stap_capturewr_int     = (cair_present_state | cadr_present_state);
         assign stap_shiftwr_int       = (shir_present_state | shdr_present_state);
         assign sn_fwtap_updatewr      = (upir_present_state | updr_present_state);
         // *********************************************************************
         // output reset signal generation
         // *********************************************************************
         assign sn_fwtap_wrst_b    = ~stap_fsm_tlrs;
         // *********************************************************************
         // added negedge floping for capturewr and shiftwr. In accordance with 
         //   1500 and SoC TAP HAS rev088_rc3
         // *********************************************************************
         always_ff @(negedge ftap_tck or negedge powergoodrst_trst_b)
         begin
            if (!powergoodrst_trst_b)
            begin
               sn_fwtap_capturewr <= LOW;
               sn_fwtap_shiftwr   <= LOW;
            end
            else if (soft_reset)
            begin
               sn_fwtap_capturewr <= LOW;
               sn_fwtap_shiftwr   <= LOW;
            end
            else
            begin
               sn_fwtap_capturewr <= stap_capturewr_int;
               sn_fwtap_shiftwr   <= stap_shiftwr_int;
            end
         end
      end
      else
      begin
         assign sn_fwtap_rti       = LOW;
         assign sn_fwtap_capturewr = LOW;
         assign sn_fwtap_shiftwr   = LOW;
         assign sn_fwtap_updatewr  = LOW;
         assign sn_fwtap_wrst_b    = HIGH; 
      end
   endgenerate

   // ====================================================================
   // synopsys translate_off
   // ====================================================================
   
   typedef enum logic [15:0] {
      tlrs = 16'h0001,
      ruti = 16'h0002,
      sdrs = 16'h0004,
      cadr = 16'h0008,
      shdr = 16'h0010,
      e1dr = 16'h0020,
      padr = 16'h0040,
      e2dr = 16'h0080,
      updr = 16'h0100,
      sirs = 16'h0200,
      cair = 16'h0400,
      shir = 16'h0800,
      e1ir = 16'h1000,
      pair = 16'h2000,
      e2ir = 16'h4000,
      upir = 16'h8000} fsm_states;

   fsm_states present_state;
   fsm_states next_state;

   always_comb
   begin
      present_state = state_str(state_ps);
      next_state    = state_str(state_ns);
   end

   function fsm_states state_str(logic [15:0] state);
      begin
         fsm_states str;
         case (state)
            TLRS: begin str = tlrs; end
            RUTI: begin str = ruti; end
            SDRS: begin str = sdrs; end
            CADR: begin str = cadr; end
            SHDR: begin str = shdr; end
            E1DR: begin str = e1dr; end
            PADR: begin str = padr; end
            E2DR: begin str = e2dr; end
            UPDR: begin str = updr; end
            SIRS: begin str = sirs; end
            CAIR: begin str = cair; end
            SHIR: begin str = shir; end
            E1IR: begin str = e1ir; end
            PAIR: begin str = pair; end
            E2IR: begin str = e2ir; end
            UPIR: begin str = upir; end
         endcase
         return str;
      end
   endfunction
   // =================================================================
   // synopsys translate_on
   // ====================================================================

   // Assertions and coverage
//kbbhagwa   `include "stap_fsm_include.sv"
//https://vthsd.intel.com/hsd/seg_softip/ar/default.aspx?ar_id=240053
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
 `include "stap_fsm_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif


endmodule
