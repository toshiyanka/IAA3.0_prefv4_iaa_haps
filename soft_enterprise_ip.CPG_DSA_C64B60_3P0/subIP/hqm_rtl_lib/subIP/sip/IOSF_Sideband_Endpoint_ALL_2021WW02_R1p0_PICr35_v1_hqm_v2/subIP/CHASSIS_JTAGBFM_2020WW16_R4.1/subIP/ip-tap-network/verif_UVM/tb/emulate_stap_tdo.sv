//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2016 Intel Corporation All Rights Reserved.
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
//  %header_collateral%
//
//  Source organization:
//  %header_organization%
//
//  Support Information:
//  %header_support%
//
//  Revision:
//  %header_tag%
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved
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

module emulate_stap_tdo#(
                         parameter TB_REMOTE_TDR_ENABLE     = 1,
                         parameter TB_NO_OF_REMOTE_TDR      = 3,
                         parameter TB_NO_OF_REMOTE_TDR_NZ   = 3,
                         parameter TB_RTDR_IS_BUSSED_NZ     = 1,
                         parameter TB_SIZE_OF_REMOTE_TDR    = 32
                         )(
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


   output [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]           rtdr_tap_tdo;
   input [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]              tap_rtdr_tdi;
   input [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]              tap_rtdr_capture;
   input [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]              tap_rtdr_shift;
   input [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]              tap_rtdr_update;
   input                                             tap_rtdr_selectir;
   input                                             tap_rtdr_powergood;
   input [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]            tap_rtdr_prog_rst_b;

   input [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]            tap_rtdr_irdec;
   input                                             tap_rtdr_tck;
   input                                             tap_rtdr_rti;

   /*************************************************/
   /* Logic for Remote TDR                          */
   /* This implementation is for RTDR on TCK domain */
   /*************************************************/
   localparam TB_SIZE_OF_REMOTE_TDR_NZ = (TB_REMOTE_TDR_ENABLE == 0) ? 2 : TB_SIZE_OF_REMOTE_TDR;

   reg [(TB_SIZE_OF_REMOTE_TDR_NZ - 1):0] rtdr_shift_reg2, rtdr_shadow_reg2;
   reg [(TB_NO_OF_REMOTE_TDR_NZ - 1):0]   rtdr_tap_tdo;
   logic [(TB_SIZE_OF_REMOTE_TDR_NZ-1):0]  rtdr_lb[5:0];

   //-----------------------------------------
   // Main Logic for RTDR
   //-----------------------------------------
   generate
      if (TB_REMOTE_TDR_ENABLE == 1)
      begin:generate_rtdr_asyc
         if (TB_RTDR_IS_BUSSED_NZ == 0)
         begin
            for (genvar y = 0; y <= (TB_NO_OF_REMOTE_TDR_NZ - 1); y++)
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
            for (genvar z = 0; z <= (TB_NO_OF_REMOTE_TDR_NZ - 1); z++)
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

//   generate
//      if (TB_REMOTE_TDR_ENABLE == 1)
//      begin:generate_rtdr
//         if (TB_RTDR_IS_BUSSED_NZ == 1)
//         begin
//            always_ff @(posedge tap_rtdr_tck or negedge tap_rtdr_prog_rst_b[2])
//            begin
//               if (!tap_rtdr_prog_rst_b[2])
//               begin
//                  rtdr_shift_reg2  <= {(TB_SIZE_OF_REMOTE_TDR_NZ){1'b0}};
//                  rtdr_shadow_reg2 <= {(TB_SIZE_OF_REMOTE_TDR_NZ){1'b0}};
//               end
//               else if (tap_rtdr_irdec[2] & tap_rtdr_capture[0])
//               begin
//                  rtdr_shift_reg2 <= rtdr_shadow_reg2;
//               end
//               else if (tap_rtdr_irdec[2] & tap_rtdr_shift[0])
//               begin
//                  rtdr_shift_reg2 <= {tap_rtdr_tdi[0],rtdr_shift_reg2[(TB_SIZE_OF_REMOTE_TDR_NZ - 1):1]};
//               end
//               else if (tap_rtdr_irdec[2] & tap_rtdr_update[0])
//               begin
//                  rtdr_shadow_reg2 <= rtdr_shift_reg2;
//               end
//            end
//
//            assign rtdr_tap_tdo[2] = rtdr_shift_reg2[0];
//         end
//         else
//         begin
//            always_ff @(posedge tap_rtdr_tck or negedge tap_rtdr_prog_rst_b[2])
//            begin
//               if (!tap_rtdr_prog_rst_b[2])
//               begin
//                  rtdr_shift_reg2  <= {(TB_SIZE_OF_REMOTE_TDR_NZ){1'b0}};
//                  rtdr_shadow_reg2 <= {(TB_SIZE_OF_REMOTE_TDR_NZ){1'b0}};
//               end
//               else if (tap_rtdr_irdec[2] & tap_rtdr_capture[2])
//               begin
//                  rtdr_shift_reg2 <= rtdr_shadow_reg2;
//               end
//               else if (tap_rtdr_irdec[2] & tap_rtdr_shift[2])
//               begin
//                  rtdr_shift_reg2 <= {tap_rtdr_tdi[2],rtdr_shift_reg2[(TB_SIZE_OF_REMOTE_TDR_NZ - 1):1]};
//               end
//               else if (tap_rtdr_irdec[2] & tap_rtdr_update[2])
//               begin
//                  rtdr_shadow_reg2 <= rtdr_shift_reg2;
//               end
//            end
//
//            assign rtdr_tap_tdo[2] = rtdr_shift_reg2[0];
//         end
//      end:generate_rtdr
//   endgenerate

endmodule
