//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 12-08-2011 
//-----------------------------------------------------------------
// Description:
// Out of Band configuration objects
//------------------------------------------------------------------ 

`ifndef IP_PSMI_OOB_CONFIG
`define IP_PSMI_OOB_CONFIG

class psmi_oob_cfg extends ovm_object;

    // Flag to indicate whether the VC will work in active to passive modes
    ovm_active_passive_enum is_active;
    string intf_name;

   `ovm_object_utils_begin(psmi_oob_cfg)
      `ovm_field_enum(ovm_active_passive_enum, is_active, OVM_ALL_ON)
      `ovm_field_string(intf_name, OVM_ALL_ON)
   `ovm_object_utils_end

   extern function       new   (string name = "");  
endclass:psmi_oob_cfg

function psmi_oob_cfg::new(string name = "");
   // Super constructor
   super.new(name);
   is_active = OVM_ACTIVE;
endfunction :new

`endif //IP_PSMI_OOB_CONFIG
