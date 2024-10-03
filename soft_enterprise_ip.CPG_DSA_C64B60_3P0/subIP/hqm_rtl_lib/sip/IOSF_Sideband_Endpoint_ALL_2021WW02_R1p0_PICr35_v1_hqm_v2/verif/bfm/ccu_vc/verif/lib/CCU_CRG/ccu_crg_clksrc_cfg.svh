 //-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Class for Reset configuration object
//------------------------------------------------------------------ 

`ifndef CCU_CRG_CLKSRC_CONFIG
`define CCU_CRG_CLKSRC_CONFIG

class ccu_crg_clksrc_cfg extends ovm_object;

   int            clksrc_id;
   string         clksrc_name;
   time 		  clksrc_period;

   `ovm_object_utils_begin(ccu_crg_clksrc_cfg)
      `ovm_field_int(clksrc_id, OVM_ALL_ON)
      `ovm_field_string(clksrc_name, OVM_ALL_ON)
	  `ovm_field_int(clksrc_period, OVM_ALL_ON)
  `ovm_object_utils_end

  extern function       new   (string name = "");

endclass : ccu_crg_clksrc_cfg

function ccu_crg_clksrc_cfg::new(string name = "");
   // Super constructor
   super.new(name);
endfunction :new


`endif //CCU_CRG_CLKSRC_CONFIG
