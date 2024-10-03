// =====================================================================================================
// FileName          : JtagBfmInMonSbrPkt.sv
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

`ifndef INC_JtagBfmInMonSbrPkt
 `define INC_JtagBfmInMonSbrPkt 

   parameter MONPKT_SIZE_OF_IR_REG            = 4096;
`ifndef OVM_MAX_STREAMBITS
   parameter MONPKT_TOTAL_DATA_REGISTER_WIDTH = 4096;
   //parameter MONPKT_SIZE_OF_IR_REG            = 4096;
`else
   parameter MONPKT_TOTAL_DATA_REGISTER_WIDTH = `OVM_MAX_STREAMBITS;
   //parameter MONPKT_SIZE_OF_IR_REG            = `OVM_MAX_STREAMBITS;
`endif

class JtagBfmInMonSbrPkt extends ovm_sequence_item;

    //----------------------
    // Local Variables
    //----------------------
    bit [3:0]                                    FsmState             = 4'h0;
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
    `ovm_object_utils_begin(JtagBfmInMonSbrPkt)
    `ovm_field_int (FsmState,OVM_ALL_ON)
    `ovm_field_int (ShiftRegisterAddress,OVM_ALL_ON)
    `ovm_field_int (ShiftRegisterData,OVM_ALL_ON)
    `ovm_field_int (Vercode,OVM_ALL_ON)
    `ovm_field_int (Idcode,OVM_ALL_ON)
    `ovm_field_int (Parallel_Data_in,OVM_ALL_ON)
    `ovm_field_int (Power_Gud_Reset,OVM_ALL_ON)
    `ovm_field_int (tdi_shift_cnt,OVM_ALL_ON)
    `ovm_object_utils_end

endclass : JtagBfmInMonSbrPkt
`endif // INC_JtagBfmInMonSbrPkt
