// =====================================================================================================
// FileName          : JtagBfmOutMonSbrPkt.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Sat July 23 18:17:55 CDT 2010
// =====================================================================================================

// =====================================================================================================
//    PURPOSE     : Packet between the Input monitor and Scoreboard
//    DESCRIPTION : Contains the defination for all the fields that needs
//                  to be passed from the Input monitor to scoreboard.
//                  The feilds are: FSM STATE;ADDRESS;DATA;VERCODE;IDCODE
//                  Parallel data in and the Power Good Reset
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef INC_JtagBfmOutMonSbrPkt
 `define INC_JtagBfmOutMonSbrPkt 

   parameter OUTPKT_SIZE_OF_IR_REG            = 4096;
`ifndef OVM_MAX_STREAMBITS
   parameter OUTPKT_TOTAL_DATA_REGISTER_WIDTH = 4096;
   //parameter OUTPKT_SIZE_OF_IR_REG            = 4096;
`else
   parameter OUTPKT_TOTAL_DATA_REGISTER_WIDTH = `OVM_MAX_STREAMBITS;
   //parameter OUTPKT_SIZE_OF_IR_REG            = `OVM_MAX_STREAMBITS;
`endif

class JtagBfmOutMonSbrPkt extends ovm_sequence_item;

    //----------------------------------------------------------------
    // Local Variables
    //----------------------------------------------------------------
    bit [OUTPKT_TOTAL_DATA_REGISTER_WIDTH - 1:0]    ParallelDataOut      = 0;
    bit [OUTPKT_SIZE_OF_IR_REG - 1:0]               ShiftRegisterAddress = 0;
    bit [OUTPKT_TOTAL_DATA_REGISTER_WIDTH - 1 :0]   ShiftRegisterData    = 0;
    integer                                         tdo_shift_cnt;

   
    // Constructor
    function new(input string name = "JtagBfmOutMonSbrPkt");
        super.new(name);
    endfunction : new

    // Register component with Factory
    `ovm_object_utils_begin(JtagBfmOutMonSbrPkt)
    `ovm_field_int (ParallelDataOut,OVM_ALL_ON)
    `ovm_field_int (ShiftRegisterAddress,OVM_ALL_ON)
    `ovm_field_int (ShiftRegisterData,OVM_ALL_ON)
    `ovm_field_int (tdo_shift_cnt,OVM_ALL_ON)
    `ovm_object_utils_end

endclass : JtagBfmOutMonSbrPkt
`endif // INC_JtagBfmOutMonSbrPkt
