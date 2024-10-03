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
//    FILENAME    : JtagBfmInMonSbrPkt.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//    
//    
//    PURPOSE     : Packet between the Input monitor and Scoreboard
//    DESCRIPTION : Contains the defination for all the fields that needs
//                  to be passed from the Input monitor to scoreboard.
//                  The feilds are: FSM STATE;ADDRESS;DATA;VERCODE;IDCODE
//                  Parallel data in and the Power Good Reset
//------------------------------------------------------------------------

`ifndef INC_JtagBfmInMonSbrPkt
 `define INC_JtagBfmInMonSbrPkt 

   parameter MONPKT_SIZE_OF_IR_REG            = 4096;
`ifndef UVM_MAX_STREAMBITS
   parameter MONPKT_TOTAL_DATA_REGISTER_WIDTH = 4096;
   //parameter MONPKT_SIZE_OF_IR_REG            = 4096;
`else
   parameter MONPKT_TOTAL_DATA_REGISTER_WIDTH = `UVM_MAX_STREAMBITS;
   //parameter MONPKT_SIZE_OF_IR_REG            = `UVM_MAX_STREAMBITS;
`endif

class JtagBfmInMonSbrPkt extends uvm_sequence_item;

    //----------------------
    // Local Variables
    //----------------------
    fsm_state_test                               FsmState;
    bit [MONPKT_SIZE_OF_IR_REG-1:0]              ShiftRegisterAddress = 0;
    bit [MONPKT_TOTAL_DATA_REGISTER_WIDTH-1:0]   ShiftRegisterData    = 0;
    bit [3:0]                                    Vercode;
    bit [31:0]                                   Idcode;
    bit [MONPKT_TOTAL_DATA_REGISTER_WIDTH-1:0]   Parallel_Data_in;
    bit                                          Power_Gud_Reset;
    integer                                      tdi_shift_cnt;
    
    // Constructor
    function new( string name = "JtagBfmInMonSbrPkt");
        super.new(name);
    endfunction : new
    
    // Register component with Factory
    `uvm_object_utils_begin(JtagBfmInMonSbrPkt)
    `uvm_field_enum (fsm_state_test,FsmState,UVM_ALL_ON)
    `uvm_field_int (ShiftRegisterAddress,UVM_ALL_ON)
    `uvm_field_int (ShiftRegisterData,UVM_ALL_ON)
    `uvm_field_int (Vercode,UVM_ALL_ON)
    `uvm_field_int (Idcode,UVM_ALL_ON)
    `uvm_field_int (Parallel_Data_in,UVM_ALL_ON)
    `uvm_field_int (Power_Gud_Reset,UVM_ALL_ON)
    `uvm_field_int (tdi_shift_cnt,UVM_ALL_ON)
    `uvm_object_utils_end

endclass : JtagBfmInMonSbrPkt
`endif // INC_JtagBfmInMonSbrPkt
