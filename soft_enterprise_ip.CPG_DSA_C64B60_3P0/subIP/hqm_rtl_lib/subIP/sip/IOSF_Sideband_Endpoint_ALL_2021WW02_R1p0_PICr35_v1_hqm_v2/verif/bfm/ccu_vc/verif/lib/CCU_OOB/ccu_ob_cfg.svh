//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 12-08-2011 
//-----------------------------------------------------------------
// Description:
// Out of Band configuration objects
//------------------------------------------------------------------ 

`ifndef IP_OB_CONFIG
`define IP_OB_CONFIG

class ccu_ob_cfg extends ovm_object;

    // Flag to indicate whether the VC will work in active to passive modes
    ovm_active_passive_enum is_active;
	bit[ccu_ob::MAX_OB_SIZE:0] clkack_def_val;
	
   `ovm_object_utils_begin(ccu_ob_cfg)
      `ovm_field_enum(ovm_active_passive_enum, is_active, OVM_ALL_ON)
	  `ovm_field_int(clkack_def_val, OVM_ALL_ON|OVM_DEC)
   `ovm_object_utils_end

   extern function       new   (string name = "");  
   extern function void set_def_val(int slice_num, bit def_val);
endclass:ccu_ob_cfg

function ccu_ob_cfg::new(string name = "");
   // Super constructor
   super.new(name);
   is_active = OVM_ACTIVE;
endfunction :new

function void ccu_ob_cfg::set_def_val(int slice_num, bit def_val);
	foreach (ccu_ob::sig_prop[sig]) begin
		if(sig == ccu_ob::clkack) begin
			clkack_def_val[slice_num] = def_val;
			`ovm_info("CCU_OB_CFG",$psprintf("prop = %-x",clkack_def_val),OVM_MEDIUM)
		end
	end
endfunction : set_def_val

`endif //IP_OB_CONFIG
