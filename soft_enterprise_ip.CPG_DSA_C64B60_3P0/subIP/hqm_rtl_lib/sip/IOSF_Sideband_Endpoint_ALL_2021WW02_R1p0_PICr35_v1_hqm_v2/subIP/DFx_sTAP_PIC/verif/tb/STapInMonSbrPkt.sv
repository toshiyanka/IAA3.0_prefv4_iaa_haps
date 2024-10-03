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
//    FILENAME    : STapInMonSbrPkt.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : Packet between the Input monitor and Scoreboard
//    DESCRIPTION : Contains the defination for all the fields that needs
//                  to be passed from the Input monitor to scoreboard.
//                  The feilds are: FSM STATE;ADDRESS;DATA;IDCODE
//                  Parallel data in and the Power Good Reset
//------------------------------------------------------------------------
`include "ovm_macros.svh"

class STapInMonSbrPkt extends ovm_transaction;

    // -----------------------------------------------------------------
    // Local Variables
    // -----------------------------------------------------------------
    bit [31:0]                          Idcode;
    bit [TOTAL_DATA_REGISTER_WIDTH-1:0] Parallel_Data_in;
    logic                               trst_b;
    // -----------------------------------------------------------------
    // Secondary JTAG ports
    // -----------------------------------------------------------------
    logic ftapsslv_tck;
    logic ftapsslv_tms;
    logic ftapsslv_trst_b;
    logic ftapsslv_tdi;
    // -----------------------------------------------------------------
    // Secondary JTAG ports to Slave TAPNetwork
    // -----------------------------------------------------------------
    logic                                          sntapnw_atap_tdo2;
    logic [(STAP_NO_OF_TAPS_IN_TAP_NETWORK - 1):0] sntapnw_atap_tdo2_en;
    // -----------------------------------------------------------------
    // locked opcode is a flag use to bypass the opcodes when this bit is high
    // -----------------------------------------------------------------
    logic                                          locked_opcode;

    // Constructor
    function new( string name = "STapInMonSbrPkt");
        super.new(name);
    endfunction : new

    // Register component with Factory
    `ovm_object_utils_begin(STapInMonSbrPkt)
        `ovm_field_int (Idcode,OVM_ALL_ON)
        `ovm_field_int (Parallel_Data_in,OVM_ALL_ON)
        `ovm_field_int (ftapsslv_tck,OVM_ALL_ON)
        `ovm_field_int (ftapsslv_tms,OVM_ALL_ON)
        `ovm_field_int (ftapsslv_trst_b,OVM_ALL_ON)
        `ovm_field_int (ftapsslv_tdi,OVM_ALL_ON)
        `ovm_field_int (sntapnw_atap_tdo2,OVM_ALL_ON)
        `ovm_field_int (sntapnw_atap_tdo2_en,OVM_ALL_ON)
        `ovm_field_int (locked_opcode,OVM_ALL_ON)
        `ovm_field_int (trst_b,OVM_ALL_ON)
    `ovm_object_utils_end

endclass : STapInMonSbrPkt
