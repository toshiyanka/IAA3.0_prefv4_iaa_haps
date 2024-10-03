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
//    FILENAME    : JtagBfmSequencer.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//    
//    
//    PURPOSE     : Sequencer Component for the UVM ENV 
//    DESCRIPTION : Sequencer Component for the UVM ENV 
//----------------------------------------------------------------------

`ifndef INC_JtagBfmSequencer
 `define INC_JtagBfmSequencer 

class JtagBfmSequencer extends uvm_sequencer;

    // Register component with Factory
    `uvm_component_utils(JtagBfmSequencer)

    // Constructor
    function new(string name = "JtagBfmSequencer", uvm_component parent = null);
        super.new(name,parent);
        // -*- association seqr-seq has changed // -*- association seqr-seq has changed `uvm_update_sequence_lib_and_item(JtagBfmSeqDrvPkt);
    endfunction : new
     
endclass : JtagBfmSequencer
`endif // INC_JtagBfmSequencer 
