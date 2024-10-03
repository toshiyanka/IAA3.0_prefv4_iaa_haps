//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-01 
//-----------------------------------------------------------------
// Description:
// clksrc_cfg class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_clksrc_cfg
`define INC_clksrc_cfg 

/**
 * TODO: Add class description
 */
class clksrc_cfg extends ovm_object;
   //------------------------------------------
   // Data Members 
   //------------------------------------------
	int clk_num;
	string clk_name;
    rand time period;
 
   //------------------------------------------
   // Constraints 
   //------------------------------------------
   constraint period_c {period inside {[20 :50]};}; // 18KHz to 5GHz
   //constraint period_c {period inside {[200 :5000000]};}; // 18KHz to 5GHz
   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   extern function new (string name = "");
  
   // APIs 

   // OVM Macros 
   `ovm_object_utils_begin (ccu_vc_pkg::clksrc_cfg)
      `ovm_field_int (clk_num, OVM_ALL_ON|OVM_DEC)
      `ovm_field_string (clk_name, OVM_ALL_ON)
      `ovm_field_real(period,  OVM_ALL_ON|OVM_DEC)
   `ovm_object_utils_end
endclass :clksrc_cfg

/**
 * clksrc_cfg Class constructor
 * @param   name  OVM name
 * @return        A new object of type clksrc_cfg 
 */
function clksrc_cfg::new (string name = "");
   // Super constructor
   super.new (name);
endfunction :new

`endif //INC_clksrc_cfg

