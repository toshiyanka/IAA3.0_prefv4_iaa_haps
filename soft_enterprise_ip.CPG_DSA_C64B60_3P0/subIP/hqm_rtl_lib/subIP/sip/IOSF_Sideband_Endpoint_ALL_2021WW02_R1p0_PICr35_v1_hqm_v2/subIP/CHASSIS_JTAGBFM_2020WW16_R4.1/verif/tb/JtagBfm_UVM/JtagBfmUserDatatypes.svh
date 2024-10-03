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
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : JtagBfmUserDatatypesPkg.svh
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//    
//    
//    PURPOSE     : Enum types
//    DESCRIPTION : Enumerated types for TAP FSM 
//----------------------------------------------------------------------

`ifndef INC_JtagBfmUserDatatypesPkg
 `define INC_JtagBfmUserDatatypesPkg


package JtagBfmUserDatatypesPkg;

    typedef enum bit[3:0] {    
                TLRS = 4'b0000,  // Test Logic Reset State
                RUTI = 4'b1000,  // Run test Idle State
                SDRS = 4'b0001,  // Select DR Scan State
                CADR = 4'b0010,  // Capture DR State
                SHDR = 4'b0011,  // Shift DR State
                E1DR = 4'b0100,  // Exit1 DR State
                PADR = 4'b0101,  // Pause DR State
                E2DR = 4'b0110,  // Exit2 DR State
                UPDR = 4'b0111,  // Update DR State
                SIRS = 4'b1001,  // Select IR Scan State
                CAIR = 4'b1010,  // Capture IR State
                SHIR = 4'b1011,  // Shift IR State
                E1IR = 4'b1100,  // Exit1 IR State
                PAIR = 4'b1101,  // Pause IR State
                E2IR = 4'b1110,  // Exit2 IR State
                UPIR = 4'b1111   // Update IR State
              } fsm_state_test;
endpackage

`endif // INC_JtagBfmPkg

