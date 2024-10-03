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
//  dteg-jtag_bfm
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  CHASSIS_JTAGBFM_2020WW16_R4.1
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
//    FILENAME    : JtagBfmOutMonSbrPkt.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//    
//    
//    PURPOSE     : Packet between the Output monitor and Scoreboard
//    DESCRIPTION : Contains the defination for all the fields that needs
//                  to be passed from the Output monitor to scoreboard.
//                  The feilds are: Parallel Data Out
//                                  TDO Data Register
//                                  TDO Address Register
//----------------------------------------------------------------------

`ifndef INC_JtagBfmOutMonSbrPkt
 `define INC_JtagBfmOutMonSbrPkt 

   parameter OUTPKT_SIZE_OF_IR_REG            = 4096;
`ifndef UVM_MAX_STREAMBITS
   parameter OUTPKT_TOTAL_DATA_REGISTER_WIDTH = 4096;
   //parameter OUTPKT_SIZE_OF_IR_REG            = 4096;
`else
   parameter OUTPKT_TOTAL_DATA_REGISTER_WIDTH = `UVM_MAX_STREAMBITS;
   //parameter OUTPKT_SIZE_OF_IR_REG            = `UVM_MAX_STREAMBITS;
`endif

class JtagBfmOutMonSbrPkt extends uvm_sequence_item;

    //----------------------------------------------------------------
    // Local Variables
    //----------------------------------------------------------------
    fsm_state_test                                  FsmState;
    bit [OUTPKT_TOTAL_DATA_REGISTER_WIDTH - 1:0]    ParallelDataOut      = 0;
    bit [OUTPKT_SIZE_OF_IR_REG - 1:0]               ShiftRegisterAddress = 0;
    bit [OUTPKT_TOTAL_DATA_REGISTER_WIDTH - 1 :0]   ShiftRegisterData    = 0;
    integer                                         tdo_shift_cnt;

   
    // Constructor
    function new(input string name = "JtagBfmOutMonSbrPkt");
        super.new(name);
    endfunction : new

    // Register component with Factory
    `uvm_object_utils_begin(JtagBfmOutMonSbrPkt)
    `uvm_field_enum (fsm_state_test,FsmState,UVM_ALL_ON)
    `uvm_field_int (ParallelDataOut,UVM_ALL_ON)
    `uvm_field_int (ShiftRegisterAddress,UVM_ALL_ON)
    `uvm_field_int (ShiftRegisterData,UVM_ALL_ON)
    `uvm_field_int (tdo_shift_cnt,UVM_ALL_ON)
    `uvm_object_utils_end

endclass : JtagBfmOutMonSbrPkt
`endif // INC_JtagBfmOutMonSbrPkt
