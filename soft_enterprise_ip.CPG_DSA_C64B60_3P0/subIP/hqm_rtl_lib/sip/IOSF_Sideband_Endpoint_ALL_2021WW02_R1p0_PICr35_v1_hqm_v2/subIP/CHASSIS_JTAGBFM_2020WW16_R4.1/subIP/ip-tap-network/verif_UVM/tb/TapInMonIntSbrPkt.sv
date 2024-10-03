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
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : TapInMonIntSbrPkt.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : Packet between the Input monitor and Scoreboard
//    DESCRIPTION : Contains the defination for all the fields that needs
//                  to be passed from the Input monitor to scoreboard.
//                  The feilds are: SEC_SEL;ENABLE_TDO;ENABLE_TAP;VERCODE;IDCODE
//------------------------------------------------------------------------

`include "uvm_macros.svh"
class TapInMonIntSbrPkt extends uvm_transaction;

    //----------------------
    // Local Variables
    //----------------------
    bit [(NO_OF_TAP)-1:0]    sec_sel    = 0;
    bit [(NO_OF_TAP)-1:0]    enable_tdo = 0;
    bit [(NO_OF_TAP)-1:0]    enable_tap = 0;
    bit [31:0]                slvidcode [];
    bit [3:0]                 vercode;

     // Constructor
    function new( string name = "TapInMonIntSbrPkt");
        super.new(name);
        slvidcode = new[NO_OF_TAP];
    endfunction : new
    
    // Register component with Factory
    `uvm_object_utils_begin(TapInMonIntSbrPkt)
    `uvm_field_int (sec_sel,UVM_ALL_ON)
    `uvm_field_int (enable_tdo,UVM_ALL_ON)
    `uvm_field_int (enable_tap,UVM_ALL_ON)
    `uvm_field_int (vercode,UVM_ALL_ON)
    `uvm_field_array_int (slvidcode,UVM_ALL_ON)
    `uvm_object_utils_end

endclass : TapInMonIntSbrPkt
