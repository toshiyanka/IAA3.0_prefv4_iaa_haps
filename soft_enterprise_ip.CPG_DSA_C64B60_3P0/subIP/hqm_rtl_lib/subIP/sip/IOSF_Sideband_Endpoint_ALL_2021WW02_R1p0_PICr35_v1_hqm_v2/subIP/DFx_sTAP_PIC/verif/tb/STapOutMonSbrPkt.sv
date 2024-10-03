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
//    FILENAME    : STapOutMonSbrPkt.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : Packet between the Output monitor and Scoreboard
//    DESCRIPTION : Contains the defination for all the fields that needs
//                  to be passed from the Output monitor to scoreboard.
//                  The feilds are: Parallel Data Out
//                                  TDO Data Register
//                                  TDO Address Register
//----------------------------------------------------------------------

class STapOutMonSbrPkt extends ovm_transaction;

    // -----------------------------------------------------------------
    // Local Variables
    // -----------------------------------------------------------------
    bit   [(TOTAL_DATA_REGISTER_WIDTH - 1):0]     ParallelDataOut = 0;
    // -----------------------------------------------------------------
    // Secondary JTAG ports
    // -----------------------------------------------------------------
    logic                                         atapsslv_tdo;
    logic                                         atapsslv_tdoen;
    // -----------------------------------------------------------------
    // Secondary JTAG ports to Slave TAPNetwork
    // -----------------------------------------------------------------
    logic                                         sntapnw_ftap_tck2;
    logic                                         sntapnw_ftap_tms2;
    logic                                         sntapnw_ftap_trst2_b;
    logic                                         sntapnw_ftap_tdi2;

    // Constructor
    function new(input string name = "STapOutMonSbrPkt");
        super.new(name);
    endfunction : new

    // Register component with Factory
    `ovm_object_utils_begin(STapOutMonSbrPkt)
    `ovm_field_int (ParallelDataOut,OVM_ALL_ON)
    `ovm_field_int (atapsslv_tdo,OVM_ALL_ON)
    `ovm_field_int (atapsslv_tdoen,OVM_ALL_ON)
    `ovm_field_int (sntapnw_ftap_tck2,OVM_ALL_ON)
    `ovm_field_int (sntapnw_ftap_tms2,OVM_ALL_ON)
    `ovm_field_int (sntapnw_ftap_trst2_b,OVM_ALL_ON)
    `ovm_field_int (sntapnw_ftap_tdi2,OVM_ALL_ON)
    `ovm_object_utils_end

endclass : STapOutMonSbrPkt
