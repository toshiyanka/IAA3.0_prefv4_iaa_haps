//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : asingh7
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Class for Clock configuration object
//------------------------------------------------------------------ 

`ifndef CCU_CRG_DOMAIN_CONFIG
`define CCU_CRG_DOMAIN_CONFIG

class ccu_crg_domain_cfg extends ovm_object;


   string   domain_name;
   realtime     domain_period_queue[$];
   time     domain_phase_delay;


   `ovm_object_utils_begin(ccu_crg_domain_cfg)
      `ovm_field_string(domain_name, OVM_ALL_ON)
      `ovm_field_int(domain_phase_delay, OVM_ALL_ON)
//      `ovm_field_queue_int(domain_period_queue, OVM_ALL_ON)
  `ovm_object_utils_end
  
  extern function       new   (string name = ""); 

endclass : ccu_crg_domain_cfg


function ccu_crg_domain_cfg::new(string name = "");
   // Super constructor
   super.new(name);
endfunction :new


`endif //CCU_CRG_DOMAIN_CONFIG
