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
//    FILENAME    : mtap_wtapnw.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : mTAP
//    
//    
//    PURPOSE     : MTAP control path logic
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
module mtap_wtapnw #(
                     parameter WTAPNW_MTAP_NUMBER_OF_TAPS               = 1,
                     parameter WTAPNW_MTAP_NUMBER_OF_WTAPS              = 1,
                     parameter WTAPNW_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 = 2
                    )
                    (
                    input  logic                                                    mtap_mux_tdo,
                    input  logic                                                    mtap_selectwir,
                    input  logic [(WTAPNW_MTAP_NUMBER_OF_WTAPS - 1):0]              cn_awtap_wso,
                    input  logic [(WTAPNW_MTAP_NUMBER_OF_WTAPS - 1):0]              cltapc_wtap_sel,
                    input  logic [(WTAPNW_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0] cltapc_select,
                    input  logic [(WTAPNW_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0] cltapc_select_ovr,
                    output logic                                                    cn_fwtap_selectwir,
                    output logic [(WTAPNW_MTAP_NUMBER_OF_WTAPS - 1):0]              cn_fwtap_wsi,
                    output logic                                                    mtap_wtapnw_tdo
                    );

   // *********************************************************************
   // Localparameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   // *********************************************************************
   // Internal signals
   // *********************************************************************
   logic [(WTAPNW_MTAP_NUMBER_OF_WTAPS - 1):0] wtapnw_tdo_internal;
   logic [(WTAPNW_MTAP_NUMBER_OF_WTAPS - 1):0] wtapnw_wsi_internal;
   logic [(WTAPNW_MTAP_NUMBER_OF_WTAPS - 1):0] wtap_wsi_internal;

   // *********************************************************************
   // Generate selectwir logic
   // *********************************************************************
   assign cn_fwtap_selectwir = mtap_selectwir;

   // *********************************************************************
   // WTAP wsi Control logic
   // *********************************************************************
   generate
      if (WTAPNW_MTAP_NUMBER_OF_WTAPS > 1)
      begin
         for(genvar q = 0; q < (WTAPNW_MTAP_NUMBER_OF_WTAPS - 1); q = q + 1)
         begin
            assign wtapnw_wsi_internal[q] =
               cltapc_wtap_sel[q] &
               (&(~(cltapc_wtap_sel[(WTAPNW_MTAP_NUMBER_OF_WTAPS - 1):(q + 1)])));
         end
      end
   endgenerate

   assign wtapnw_wsi_internal[WTAPNW_MTAP_NUMBER_OF_WTAPS - 1] =
      cltapc_wtap_sel[WTAPNW_MTAP_NUMBER_OF_WTAPS - 1];
   // ---------------------------------------------------------------------
   // wsi generation on conditions of cltapc_select and cltapc_wtap_sel
   // ---------------------------------------------------------------------
   generate
      for(genvar r = 0; r < WTAPNW_MTAP_NUMBER_OF_WTAPS; r = r + 1)
      begin
         assign wtap_wsi_internal[r] = (wtapnw_wsi_internal[r] == HIGH) ? mtap_mux_tdo : HIGH;
      end
   endgenerate

   assign cn_fwtap_wsi = ((|(cltapc_select | cltapc_select_ovr) ) == HIGH) ? {WTAPNW_MTAP_NUMBER_OF_WTAPS{HIGH}} :
                              (|cltapc_wtap_sel                                               == LOW)  ? {WTAPNW_MTAP_NUMBER_OF_WTAPS{HIGH}} :
                                wtap_wsi_internal;

   // *********************************************************************
   // TDO Control logic
   // *********************************************************************
   generate
      if (WTAPNW_MTAP_NUMBER_OF_WTAPS > 1)
      begin
         for(genvar m = 0; m < (WTAPNW_MTAP_NUMBER_OF_WTAPS - 1); m = m + 1)
         begin
            assign wtapnw_tdo_internal[m] =
               cltapc_wtap_sel[m] &
               cn_awtap_wso[m] &
               (&(~(cltapc_wtap_sel[(WTAPNW_MTAP_NUMBER_OF_WTAPS - 1):(m + 1)])));
         end
      end
   endgenerate

   assign wtapnw_tdo_internal[WTAPNW_MTAP_NUMBER_OF_WTAPS - 1] =
      cltapc_wtap_sel[WTAPNW_MTAP_NUMBER_OF_WTAPS - 1] &
      cn_awtap_wso[WTAPNW_MTAP_NUMBER_OF_WTAPS - 1];
   assign mtap_wtapnw_tdo                                      = |(wtapnw_tdo_internal);

endmodule
