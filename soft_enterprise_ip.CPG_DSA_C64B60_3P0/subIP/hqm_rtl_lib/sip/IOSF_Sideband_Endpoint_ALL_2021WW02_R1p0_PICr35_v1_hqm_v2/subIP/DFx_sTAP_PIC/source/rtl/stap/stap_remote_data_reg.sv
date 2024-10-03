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
//    FILENAME    : stap_remote_data_reg.sv
//    DESIGNER    : B.S.Adithya
//    PROJECT     : sTAP
//
//    PURPOSE     : sTAP DR Register Implementation
//    DESCRIPTION :
//       This module is generic JTAG register. This module accepts the data
//       from tdi and shifts according to shift enable provided by FSM.
//       This module also has parallel input and output ports. Once FSM asserts
//       update signal, parallel data is available on its module ports.
//----------------------------------------------------------------------
module stap_remote_data_reg
   (
   input logic  stap_irdecoder_drselect,
   input logic  rtdr_tap_tdo,
   input logic  stap_fsm_shift_dr,

   output logic rtdr_tap_tdo_gated,
   output logic tap_rtdr_irdec
   );

   assign rtdr_tap_tdo_gated = rtdr_tap_tdo & stap_irdecoder_drselect & stap_fsm_shift_dr;

   assign tap_rtdr_irdec   = stap_irdecoder_drselect;

endmodule
