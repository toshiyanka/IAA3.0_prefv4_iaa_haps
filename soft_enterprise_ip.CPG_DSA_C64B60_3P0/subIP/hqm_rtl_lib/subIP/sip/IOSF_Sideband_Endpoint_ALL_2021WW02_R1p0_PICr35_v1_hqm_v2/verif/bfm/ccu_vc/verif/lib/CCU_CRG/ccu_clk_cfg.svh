//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Class for Clock configuration object
//------------------------------------------------------------------ 

`ifndef CCU_CRG_CLK_CONFIG
`define CCU_CRG_CLK_CONFIG

class ccu_crg_clk_cfg extends ovm_object;

   int      clk_id;
   string   clk_name;
   time     clk_period;
   string   clk_domain;
   time     clk_phase_delay_en;
   bit      clk_auto;
   int 		dcg_blk_num;
   int 		in_phase_with;
   int      clk_duty_cycle;
   ccu_crg::ccu_crg_gate_e  clk_gating;  


   //Clock jitter variables
   ccu_crg::ccu_crg_jitter_e   jitter;
   int      jitter_start;
   int      jitter_length;
   int      clk_counter;
   bit      positive_jitter;
   real     jitter_amount;

   `ovm_object_utils_begin(ccu_crg_clk_cfg)
      `ovm_field_int(clk_id, OVM_ALL_ON)
      `ovm_field_string(clk_name, OVM_ALL_ON)
      `ovm_field_int(clk_period, OVM_ALL_ON)
      `ovm_field_string(clk_domain, OVM_ALL_ON)
      `ovm_field_int(clk_phase_delay_en, OVM_ALL_ON)
      `ovm_field_int(clk_auto, OVM_ALL_ON)
	  `ovm_field_int(dcg_blk_num, OVM_ALL_ON)
	  `ovm_field_int(in_phase_with, OVM_ALL_ON)
      `ovm_field_int(clk_duty_cycle, OVM_ALL_ON)
      `ovm_field_enum(ccu_crg::ccu_crg_gate_e, clk_gating, OVM_ALL_ON)
      `ovm_field_enum(ccu_crg::ccu_crg_jitter_e, jitter, OVM_ALL_ON)
  `ovm_object_utils_end

  extern function       new   (string name = ""); 

endclass : ccu_crg_clk_cfg

function ccu_crg_clk_cfg::new(string name = "");
   // Super constructor
   super.new(name);
endfunction :new


`endif //CCU_CRG_CLK_CONFIG
