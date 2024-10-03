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
//    FILENAME    : JtagBfmCfg.svh
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//    
//    
//    PURPOSE     : Sequences for the ENV 
//    DESCRIPTION : This class serves as a configuration decriptor.
//                  Env set up can be adjusted using the variables
//                  
//------------------------------------------------------------------------
//------------------------------------------------------------------------

`ifndef INC_JtagBfmCfg
 `define INC_JtagBfmCfg 

class JtagBfmCfg extends uvm_object;

    // Control properties

     int quit_count                    = 20;
     int set_verbosity                 = UVM_DEBUG;
     int enable_clk_gating             = 1;
     int park_clk_at                   = 0;
     int sample_tdo_on_negedge         = 1; //Non IEEE compliance mode, used only for TAP's not on the boundary of SoC.
     int RESET_DELAY                   = 10000;
     int jtag_bfm_tracker_en           = 1;
     int jtag_bfm_runtime_tracker_en   = 1;
     int primary_tracker     = 0;
     int secondary_tracker   = 0;
     //int tertiary_tracker    = 0;
     bit [((NUMBER_OF_TERTIARY_PORTS>0)? NUMBER_OF_TERTIARY_PORTS-1:0):0] tertiary_tracker = '0;
     bit rtdr_is_bussed = 0;
     bit use_rtdr_interface = 0;
     bit config_trstb_value_en = 0;
     bit config_trstb_value = 0;

     string tracker_name               = "JTAG";
     uvm_active_passive_enum is_active = UVM_ACTIVE;
   
   // UVM Macros 
   `uvm_object_utils_begin(JtagBfmCfg)
      `uvm_field_int(quit_count,                    20)
      `uvm_field_int(set_verbosity,                 UVM_DEBUG)
      `uvm_field_int(enable_clk_gating,             UVM_FLAGS_ON)
      `uvm_field_int(park_clk_at,                   UVM_FLAGS_ON)
      `uvm_field_int(sample_tdo_on_negedge,         UVM_FLAGS_ON)
      `uvm_field_int(RESET_DELAY,                   UVM_FLAGS_ON)
      `uvm_field_int(primary_tracker,               UVM_FLAGS_ON)
      `uvm_field_int(secondary_tracker,             UVM_FLAGS_ON)
      `uvm_field_int(tertiary_tracker,              UVM_FLAGS_ON)
      `uvm_field_int(jtag_bfm_tracker_en,           UVM_FLAGS_ON)
      `uvm_field_int(jtag_bfm_runtime_tracker_en,   UVM_FLAGS_ON)
      `uvm_field_string(tracker_name,               UVM_FLAGS_ON)
      `uvm_field_int(rtdr_is_bussed,                UVM_FLAGS_ON)
      `uvm_field_int(use_rtdr_interface,            UVM_FLAGS_ON)
      `uvm_field_int(config_trstb_value_en,         UVM_FLAGS_ON)
      `uvm_field_int(config_trstb_value,            UVM_FLAGS_ON)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
   `uvm_object_utils_end
      
   // Standard UVM Methods 
   extern function new (string name = "JtagBfmCfg");

endclass: JtagBfmCfg


//-----------------------------
//Jtagbfm_cfg Class constructor
//-----------------------------
function JtagBfmCfg::new (string name = "JtagBfmCfg");
   super.new (name);
endfunction :new
`endif // INC_JtagBfmCfg
   
