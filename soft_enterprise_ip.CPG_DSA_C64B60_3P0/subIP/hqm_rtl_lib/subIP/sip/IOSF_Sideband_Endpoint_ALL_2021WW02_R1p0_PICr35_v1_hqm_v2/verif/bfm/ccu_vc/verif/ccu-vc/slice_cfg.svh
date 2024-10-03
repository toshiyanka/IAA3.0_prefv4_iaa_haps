//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-01 
//-----------------------------------------------------------------
// Description:
// slice_cfg class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_slice_cfg
`define INC_slice_cfg 

/**
 * TODO: Add class description
 */
class slice_cfg extends ovm_object;
   //-------------------------------------------
   // Data Members 
   //------------------------------------------
	int slice_num;
	string slice_name;
	int in_phase_with_slice_num; 
	int dcg_blk_num;
	bit set_zero_delay;
	bit enable_random_phase;
	int duty_cycle;
	bit always_running;
	int clk_src;
	ccu_types::clk_gate_e clk_status;
	ccu_types::div_ratio_e divide_ratio;
	ccu_types::def_status_e def_status;
	int half_divide_ratio;
	time req1_to_clk1;
	int clk1_to_ack1;
	int req0_to_ack0;
	int clkack_delay;
	time freq_change_delay;
	bit usync_enabled;
	bit randomize_req1_to_clk1;
	bit randomize_clk1_to_ack1;
	bit randomize_req0_to_ack0;
	bit randomize_clkack_delay;
 
   //------------------------------------------
   // Constraints 
   //------------------------------------------
  
   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   extern function new (string name = "");
  
   // APIs 

   // OVM Macros 
   `ovm_object_utils_begin (ccu_vc_pkg::slice_cfg)
      `ovm_field_int (slice_num, OVM_ALL_ON|OVM_DEC)
      `ovm_field_string (slice_name, OVM_ALL_ON)
      `ovm_field_int (clk_src,  OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (in_phase_with_slice_num, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (dcg_blk_num, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (enable_random_phase, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (duty_cycle, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (set_zero_delay, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (always_running, OVM_ALL_ON|OVM_DEC)
      `ovm_field_enum (ccu_types::clk_gate_e, clk_status, OVM_ALL_ON)
      `ovm_field_enum (ccu_types::div_ratio_e,  divide_ratio,  OVM_ALL_ON)
	  `ovm_field_enum (ccu_types::def_status_e, def_status, OVM_ALL_ON)
	  `ovm_field_int (half_divide_ratio, OVM_ALL_ON)
	  `ovm_field_real (freq_change_delay, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_real (req1_to_clk1, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (clk1_to_ack1, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (req0_to_ack0, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (clkack_delay, OVM_ALL_ON|OVM_DEC)
      `ovm_field_int (usync_enabled,  OVM_ALL_ON|OVM_HEX)
   `ovm_object_utils_end
endclass :slice_cfg

/**
 * slice_cfg Class constructor
 * @param   name  OVM name
 * @return        A new object of type slice_cfg 
 */
function slice_cfg::new (string name = "");
   // Super constructor
   super.new (name);
endfunction :new

`endif //INC_slice_cfg

