//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2019 Intel Corporation All Rights Reserved.
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
//  Collateral Description:
//  dteg-stap
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_sTAP_2020WW05_RTL1P0_PIC6_V1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : emulate_stap_tdo.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : To emulated the tdo connection of stap to different
//                  tdos in the respective orders explained below:
//                      1) scan tdo when scan is enabled
//                      2) tapnw tdo when tapnw is enabled
//                      3) wtapnw tdo when wtapnw is enabled
//                      4) wtap tdo when a single wtap is enabled
//                      5) stap tdo when none of the above mentioned
//                         are enabled
//    DESCRIPTION : Instantiates and connects the Program block and the
//                  DUT and the Clock Gen module
//----------------------------------------------------------------------
`include "tb_param.inc"

module emulate_stap_tdo(
                        ftap_tck,
                        fdfx_powergood,
                        ftap_trst_b,
                        atap_secsel,
                        atap_enabletdo,
                        atap_enabletap,
                        atap_wtapnw_selectwir,
                        stap_fbscan_runbist_en,
                        stap_fbscan_shiftdr,
                        ftap_tdi,
                        stap_abscan_tdo,
                        sntapnw_ftap_tdi,
                        sntapnw_atap_tdo,
                        sntapnw_ftap_tdi2,
                        sntapnw_atap_tdo2,
                        atap_wtapnw_wsi,
                        sn_awtap_wso,

                        rtdr_tap_tdo,
                        tap_rtdr_tdi,
                        tap_rtdr_capture,
                        tap_rtdr_shift,
                        tap_rtdr_update,
                        tap_rtdr_selectir,
                        tap_rtdr_powergood,
                        tap_rtdr_prog_rst_b,

                        tap_rtdr_irdec,
                        tap_rtdr_tck,
                        tap_rtdr_rti
                       );

   //-------------------------------------------------------------------
   // Input/Output Declarations
   //-------------------------------------------------------------------
   input                                             ftap_tck;
   input                                             ftap_trst_b;
   input                                             fdfx_powergood;
   input [(STAP_NO_OF_TAPS_IN_TAP_NETWORK - 1):0]    atap_secsel;
   input [(STAP_NO_OF_TAPS_IN_TAP_NETWORK - 1):0]    atap_enabletdo;
   input [(STAP_NO_OF_TAPS_IN_TAP_NETWORK - 1):0]    atap_enabletap;
   input                                             atap_wtapnw_selectwir;
   input                                             stap_fbscan_runbist_en;
   input                                             stap_fbscan_shiftdr;
   input                                             ftap_tdi;
   output                                            stap_abscan_tdo;
   input                                             sntapnw_ftap_tdi;
   output                                            sntapnw_atap_tdo;
   input                                             sntapnw_ftap_tdi2;
   output                                            sntapnw_atap_tdo2;
   input [(STAP_NO_OF_WTAPS_IN_WTAP_NETWORK - 1):0]  atap_wtapnw_wsi;
   output [(STAP_NO_OF_WTAPS_IN_WTAP_NETWORK - 1):0] sn_awtap_wso;

   output [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]           rtdr_tap_tdo;
   input [(TB_RTDR_IS_BUSSED_NZ - 1):0]              tap_rtdr_tdi;
   input [(TB_RTDR_IS_BUSSED_NZ - 1):0]              tap_rtdr_capture;
   input [(TB_RTDR_IS_BUSSED_NZ - 1):0]              tap_rtdr_shift;
   input [(TB_RTDR_IS_BUSSED_NZ - 1):0]              tap_rtdr_update;
   input                                             tap_rtdr_selectir;
   input                                             tap_rtdr_powergood;
   input [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]            tap_rtdr_prog_rst_b;

   input [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]            tap_rtdr_irdec;
   input                                             tap_rtdr_tck;
   input                                             tap_rtdr_rti;

   // *********************************************************************
   // Registers
   // *********************************************************************
   reg [(LENGTH_OF_BSCAN_CHAIN - 1):0]            scan_reg;
   reg                                            stap_abscan_tdo;
   reg                                            sntapnw_atap_tdo;
   reg                                            sntapnw_atap_tdo2;
   reg [(STAP_NO_OF_WTAPS_IN_WTAP_NETWORK - 1):0] sn_awtap_wso;
   reg                                            runbist_reg;
   wire                                           ftap_tdi_delayed;
   wire                                           pre_fbscan_tdo;

   assign #1 ftap_tdi_delayed = ftap_tdi;

   always_comb
   begin
     stap_abscan_tdo = pre_fbscan_tdo;
     if ((STAP_EN_TAP_NETWORK == 1) & (atap_enabletap != 0))
     begin
        sntapnw_atap_tdo  = sntapnw_ftap_tdi;
        sntapnw_atap_tdo2 = sntapnw_ftap_tdi2;
        sn_awtap_wso      = $random;
     end
     else
     begin
        if (STAP_EN_WTAP_NETWORK == 1)
           begin
           sntapnw_atap_tdo  = $random;
           sntapnw_atap_tdo2 = $random;
           sn_awtap_wso      = atap_wtapnw_wsi;
        end
        else
        begin
           sntapnw_atap_tdo  = $random;
           sntapnw_atap_tdo2 = $random;
           sn_awtap_wso      = $random;
        end
     end
   end

   always_ff @(posedge ftap_tck or ftap_trst_b or fdfx_powergood)
   begin
      if ((ftap_trst_b == 1'b0) | (fdfx_powergood == 1'b0))
      begin
         scan_reg <= 3'h0;
      end
      if (stap_fbscan_shiftdr == 1'b1)
      begin
         scan_reg[(LENGTH_OF_BSCAN_CHAIN - 2):0] <= scan_reg[(LENGTH_OF_BSCAN_CHAIN - 1):(LENGTH_OF_BSCAN_CHAIN - 2)];
         scan_reg[(LENGTH_OF_BSCAN_CHAIN - 1)]   <= ftap_tdi_delayed;
      end
   end

   always_ff @(posedge ftap_tck or ftap_trst_b or fdfx_powergood)
   begin
      if ((ftap_trst_b == 1'b0) | (fdfx_powergood == 1'b0))
      begin
         runbist_reg <= 1'b0;
      end
      if (stap_fbscan_runbist_en == 1'b1)
      begin
         runbist_reg <= ftap_tdi_delayed;
      end
   end

   assign pre_fbscan_tdo = (stap_fbscan_runbist_en == 1'b1) ? runbist_reg : scan_reg[0];

   /*************************************************/
   /* Logic for Remote TDR                          */
   /* This implementation is for RTDR on TCK domain */
   /*************************************************/
   localparam TB_SIZE_OF_REMOTE_TDR_NZ = (TB_REMOTE_TDR_ENABLE == 0) ? 2 : TB_SIZE_OF_REMOTE_TDR;

   reg [(TB_SIZE_OF_REMOTE_TDR_NZ - 1):0] rtdr_shift_reg2, rtdr_shadow_reg2;
   reg [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]   rtdr_tap_tdo;
   logic [(TB_SIZE_OF_REMOTE_TDR_NZ-1):0]  rtdr_lb[1:0];

   //-----------------------------------------
   // Main Logic for RTDR
   //-----------------------------------------
   generate
      if (TB_REMOTE_TDR_ENABLE == 1)
      begin:generate_rtdr_asyc
         if (TB_RTDR_IS_BUSSED_NZ == 1)
         begin
            for (genvar y = 0; y < (TB_NO_OF_REMOTE_TDR_NZ - 1); y++)
            begin
               stap_rtdr_ref #(
                               .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           ((TB_SIZE_OF_REMOTE_TDR_NZ)),
                               .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({(TB_SIZE_OF_REMOTE_TDR_NZ){1'b0}})
                              )
               i_stap_data_reg (
                                .sync_reset              (1'b0),
                                .ftap_tck                (tap_rtdr_tck),
                                .ftap_tdi                (tap_rtdr_tdi[0]),
                                .reset_b                 (tap_rtdr_prog_rst_b[y]),
                                .stap_irdecoder_drselect (tap_rtdr_irdec[y]),
                                .stap_fsm_capture_dr     (tap_rtdr_capture[0]),
                                .stap_fsm_shift_dr       (tap_rtdr_shift[0]),
                                .stap_fsm_update_dr      (tap_rtdr_update[0]),
                                .tdr_data_in             (rtdr_lb[y]),
                                .data_reg_tdo            (rtdr_tap_tdo[y]),
                                .tdr_data_out            (rtdr_lb[y])
                               );
            end
         end
         else
         begin
            for (genvar z = 0; z < (TB_NO_OF_REMOTE_TDR_NZ - 1); z++)
            begin
               stap_rtdr_ref #(
                               .DATA_REG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           ((TB_SIZE_OF_REMOTE_TDR_NZ)),
                               .DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       ({(TB_SIZE_OF_REMOTE_TDR_NZ){1'b0}})
                              )
               i_stap_data_reg (
                                .sync_reset              (1'b0),
                                .ftap_tck                (tap_rtdr_tck),
                                .ftap_tdi                (tap_rtdr_tdi[z]),
                                .reset_b                 (tap_rtdr_prog_rst_b[z]),
                                .stap_irdecoder_drselect (tap_rtdr_irdec[z]),
                                .stap_fsm_capture_dr     (tap_rtdr_capture[z]),
                                .stap_fsm_shift_dr       (tap_rtdr_shift[z]),
                                .stap_fsm_update_dr      (tap_rtdr_update[z]),
                                .tdr_data_in             (rtdr_lb[z]),
                                .data_reg_tdo            (rtdr_tap_tdo[z]),
                                .tdr_data_out            (rtdr_lb[z])
                               );
            end
         end
      end:generate_rtdr_asyc
   endgenerate

   generate
      if (TB_REMOTE_TDR_ENABLE == 1)
      begin:generate_rtdr
         if (TB_RTDR_IS_BUSSED_NZ == 1)
         begin
            always_ff @(posedge tap_rtdr_tck or negedge tap_rtdr_prog_rst_b[2])
            begin
               if (!tap_rtdr_prog_rst_b[2])
               begin
                  rtdr_shift_reg2  <= {(TB_SIZE_OF_REMOTE_TDR_NZ){1'b0}};
                  rtdr_shadow_reg2 <= {(TB_SIZE_OF_REMOTE_TDR_NZ){1'b0}};
               end
               else if (tap_rtdr_irdec[2] & tap_rtdr_capture[0])
               begin
                  rtdr_shift_reg2 <= rtdr_shadow_reg2;
               end
               else if (tap_rtdr_irdec[2] & tap_rtdr_shift[0])
               begin
                  rtdr_shift_reg2 <= {tap_rtdr_tdi[0],rtdr_shift_reg2[(TB_SIZE_OF_REMOTE_TDR_NZ - 1):1]};
               end
               else if (tap_rtdr_irdec[2] & tap_rtdr_update[0])
               begin
                  rtdr_shadow_reg2 <= rtdr_shift_reg2;
               end
            end

            assign rtdr_tap_tdo[2] = rtdr_shift_reg2[0];
         end
         else
         begin
            always_ff @(posedge tap_rtdr_tck or negedge tap_rtdr_prog_rst_b[2])
            begin
               if (!tap_rtdr_prog_rst_b[2])
               begin
                  rtdr_shift_reg2  <= {(TB_SIZE_OF_REMOTE_TDR_NZ){1'b0}};
                  rtdr_shadow_reg2 <= {(TB_SIZE_OF_REMOTE_TDR_NZ){1'b0}};
               end
               else if (tap_rtdr_irdec[2] & tap_rtdr_capture[2])
               begin
                  rtdr_shift_reg2 <= rtdr_shadow_reg2;
               end
               else if (tap_rtdr_irdec[2] & tap_rtdr_shift[2])
               begin
                  rtdr_shift_reg2 <= {tap_rtdr_tdi[2],rtdr_shift_reg2[(TB_SIZE_OF_REMOTE_TDR_NZ - 1):1]};
               end
               else if (tap_rtdr_irdec[2] & tap_rtdr_update[2])
               begin
                  rtdr_shadow_reg2 <= rtdr_shift_reg2;
               end
            end

            assign rtdr_tap_tdo[2] = rtdr_shift_reg2[0];
         end
      end:generate_rtdr
   endgenerate

endmodule
