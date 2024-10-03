//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
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
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap_wtapnw.sv
//    DESIGNER    : B.S.Adithya
//    PROJECT     : sTAP
//
//    PURPOSE     : sTAP Control Path Logic
//    DESCRIPTION :
//       WTAP network control logic.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//----------------------------------------------------------------------
module stap_wtapnw
   #(
   parameter WTAPNW_STAP_NUMBER_OF_TAPS               = 1,
   parameter WTAPNW_STAP_NUMBER_OF_WTAPS              = 1,
   parameter WTAPNW_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 = 2
   )
   (
   input  logic                                                    stap_mux_tdo,
   input  logic                                                    stap_selectwir,
   input  logic [(WTAPNW_STAP_NUMBER_OF_WTAPS - 1):0]              sn_awtap_wso,
   input  logic [(WTAPNW_STAP_NUMBER_OF_WTAPS - 1):0]              tapc_wtap_sel,
   input  logic [(WTAPNW_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0] tapc_select,
   output logic                                                    sn_fwtap_selectwir,
   output logic [(WTAPNW_STAP_NUMBER_OF_WTAPS - 1):0]              sn_fwtap_wsi,
   output logic                                                    stap_wtapnw_tdo
   );

   // *********************************************************************
   // Localparameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic [(WTAPNW_STAP_NUMBER_OF_WTAPS - 1):0] wtapnw_tdo_internal;
   logic [(WTAPNW_STAP_NUMBER_OF_WTAPS - 1):0] wtapnw_wsi_internal;
   logic [(WTAPNW_STAP_NUMBER_OF_WTAPS - 1):0] wtap_wsi_internal;

   // *********************************************************************
   // Generate selectwir logic
   // *********************************************************************
   assign sn_fwtap_selectwir = stap_selectwir;

   // *********************************************************************
   // WTAP wsi Control logic
   // *********************************************************************
   generate
      if (WTAPNW_STAP_NUMBER_OF_WTAPS > 1)
      begin:generate_wtap_internal_wsi
         for(genvar l = 0; l < (WTAPNW_STAP_NUMBER_OF_WTAPS - 1); l = l + 1)
         begin:generate_wtap_internal_wsi_1
            assign wtapnw_wsi_internal[l] = tapc_wtap_sel[l] &
                                            (&(~(tapc_wtap_sel[(WTAPNW_STAP_NUMBER_OF_WTAPS - 1):(l + 1)])));
         end
      end
   endgenerate

   assign wtapnw_wsi_internal[WTAPNW_STAP_NUMBER_OF_WTAPS - 1] = tapc_wtap_sel[WTAPNW_STAP_NUMBER_OF_WTAPS - 1];
   // ---------------------------------------------------------------------
   // wsi generation on conditions of tapc_select and tapc_wtap_sel
   // ---------------------------------------------------------------------
   generate
      for(genvar m = 0; m < WTAPNW_STAP_NUMBER_OF_WTAPS; m = m + 1)
      begin:generate_wtap_wsi_ctrl
         assign wtap_wsi_internal[m] = (wtapnw_wsi_internal[m] == HIGH) ? stap_mux_tdo : HIGH;
      end
   endgenerate

   assign sn_fwtap_wsi = ((|tapc_select) == HIGH) ? {WTAPNW_STAP_NUMBER_OF_WTAPS{HIGH}} :
                         (|tapc_wtap_sel == LOW) ? {WTAPNW_STAP_NUMBER_OF_WTAPS{HIGH}} : wtap_wsi_internal;

   // *********************************************************************
   // TDO Control logic
   // *********************************************************************
   generate
      if (WTAPNW_STAP_NUMBER_OF_WTAPS > 1)
      begin:generate_wtap_tdo
         for(genvar n = 0; n < (WTAPNW_STAP_NUMBER_OF_WTAPS - 1); n = n + 1)
         begin:generate_wtap_tdo_1
            assign wtapnw_tdo_internal[n] = tapc_wtap_sel[n] & sn_awtap_wso[n] &
                                            (&(~(tapc_wtap_sel[(WTAPNW_STAP_NUMBER_OF_WTAPS - 1):(n + 1)])));
         end
      end
   endgenerate

   assign wtapnw_tdo_internal[(WTAPNW_STAP_NUMBER_OF_WTAPS - 1)] = tapc_wtap_sel[(WTAPNW_STAP_NUMBER_OF_WTAPS - 1)] &
                                                                   sn_awtap_wso[(WTAPNW_STAP_NUMBER_OF_WTAPS - 1)];
   assign stap_wtapnw_tdo                                        = |(wtapnw_tdo_internal);

endmodule
