//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// ccu_xaction class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_ccu_xaction
`define INC_ccu_xaction 

/**
 * TODO: Add class description
 */
class ccu_xaction extends ovm_sequence_item;
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   rand int slice_num;
   rand int clk_src;
   rand ccu_types::cmd_e cmd;
   rand ccu_types::div_ratio_e div_ratio;
   rand int half_div_ratio;
   rand int freq_change_delay;
   rand int req1_to_clk1;
   rand int clk1_to_ack1;
   rand int req0_to_ack0;
   rand int clkack_delay;
   int in_phase_with_slice_num;
   ccu_vc_cfg cfg;
   int num_slices;
 
   //------------------------------------------
   // Constraints 
   //------------------------------------------
   extern constraint slice_num_c; 
   extern constraint clk_src_c; 
   extern constraint half_div_ratio_c;
   extern constraint div_ratio_c;
   extern constraint freq_change_delay_c;
   extern constraint req1_to_clk1_c;
   extern constraint clk1_to_ack1_c;
   extern constraint req0_to_ack0_c;
   extern constraint clkack_delay_c;
   extern constraint divratio_c;
   extern constraint half_divratio_c;
   extern constraint clksrc_c;  

   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   extern function new (string name = "");
  
   // APIs 
   extern function void set_cfg (ccu_vc_cfg c);

   // OVM Macros 
   `ovm_object_utils_begin (ccu_vc_pkg::ccu_xaction)
      `ovm_field_int (slice_num, OVM_ALL_ON|OVM_DEC)
      `ovm_field_int (clk_src, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (in_phase_with_slice_num, OVM_ALL_ON|OVM_DEC)
      `ovm_field_enum (ccu_types::cmd_e, cmd, OVM_ALL_ON)
      `ovm_field_enum (ccu_types::div_ratio_e, div_ratio, OVM_ALL_ON)
	  `ovm_field_int (half_div_ratio, OVM_ALL_ON)
	  `ovm_field_int (clk1_to_ack1, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (req0_to_ack0, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (freq_change_delay, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (req1_to_clk1, OVM_ALL_ON|OVM_DEC)
	  `ovm_field_int (clkack_delay, OVM_ALL_ON|OVM_DEC)
   `ovm_object_utils_end
endclass :ccu_xaction

/**
 * ccu_xaction Class constructor
 * @param   name  OVM name
 * @return        A new object of type ccu_xaction 
 */
function ccu_xaction::new (string name = "");
   // Super constructor
   super.new (name);
endfunction :new

function void ccu_xaction::set_cfg (ccu_vc_cfg c);
  cfg = c;
  num_slices = cfg.get_num_slices();
endfunction

constraint ccu_xaction::slice_num_c { slice_num inside {[0:num_slices-1]};}
constraint ccu_xaction::clk_src_c { clk_src inside {[0:47]};}
constraint ccu_xaction::half_div_ratio_c { half_div_ratio inside {0,1};}
constraint ccu_xaction::div_ratio_c { div_ratio > 0;}

constraint ccu_xaction::clkack_delay_c { 
						clkack_delay dist {
						[8 : 50] :/ 64'h7FFFFFFF_FFFFFFFF,
						[0 : 1000000000] :/ 1 };
			}
			
constraint ccu_xaction::req1_to_clk1_c { 
						req1_to_clk1 dist {
						[0 : 30] :/ 64'h7FFFFFFF_FFFFFFFF,
						[0 : 1000000000] :/ 1 };
			}
			
constraint ccu_xaction::req0_to_ack0_c { 
						req0_to_ack0 dist {
						[0 : 10] :/ 64'h7FFFFFFF_FFFFFFFF,
					  	[0 : 1000000000] :/ 1 };
			}
			
constraint ccu_xaction::clk1_to_ack1_c { 
						clk1_to_ack1 dist {
						[0 : 10] :/ 64'h7FFFFFFF_FFFFFFFF,
						[0 : 1000000000] :/ 1 };
			}

constraint ccu_xaction::freq_change_delay_c { 
						freq_change_delay dist {
						[60 : 80] :/ 64'h7FFFFFFF_FFFFFFFF,
						[0 : 1000000000] :/ 1 };
			}
	
constraint ccu_xaction::divratio_c{

	foreach(cfg.slices[i]){
		foreach(cfg.slices[j]) {
			((cfg.slices[j].dcg_blk_num == cfg.slices[i].dcg_blk_num) && cfg.slices[j].dcg_blk_num!= 1024) 
				-> (cfg.slices[j].divide_ratio == cfg.slices[i].divide_ratio);
		}
	}
}

constraint ccu_xaction::half_divratio_c{

	foreach(cfg.slices[i]) {
		foreach(cfg.slices[j]) {
			((cfg.slices[j].dcg_blk_num == cfg.slices[i].dcg_blk_num) && cfg.slices[j].dcg_blk_num!= 1024)
				-> (cfg.slices[j].half_divide_ratio == cfg.slices[i].half_divide_ratio);
		}
	}
}

constraint ccu_xaction::clksrc_c{

	foreach(cfg.slices[i]) {
		foreach(cfg.slices[j]) {
			((cfg.slices[j].dcg_blk_num == cfg.slices[i].dcg_blk_num) && cfg.slices[j].dcg_blk_num!= 1024)
				-> (cfg.slices[j].clk_src == cfg.slices[i].clk_src);
		}
	}
}


`endif //INC_ccu_xaction
