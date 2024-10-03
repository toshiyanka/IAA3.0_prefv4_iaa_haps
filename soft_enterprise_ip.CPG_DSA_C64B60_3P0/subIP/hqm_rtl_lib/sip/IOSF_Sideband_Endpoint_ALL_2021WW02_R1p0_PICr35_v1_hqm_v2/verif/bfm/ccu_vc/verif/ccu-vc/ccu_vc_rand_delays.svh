//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2015 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr 
// Date Created : 2015-04-01 
//-----------------------------------------------------------------
// Description:
// ccu_vc_rand_delays class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_ccu_vc_rand_delays
`define INC_ccu_vc_rand_delays 

/**
 * Class provides constrained randomization capability to the user
 */
class ccu_vc_rand_delays extends ovm_component;
   //-------------------------------------------
   // Data Members 
   //------------------------------------------
	rand time req1_to_clk1_dly[MAX_NUM_SLICES];
	rand int clk1_to_ack1_dly[MAX_NUM_SLICES];
	rand int req0_to_ack0_dly[MAX_NUM_SLICES];
	rand int clkack_delay_dly[MAX_NUM_SLICES];
 
   //------------------------------------------
   // Constraints 
   //------------------------------------------
	constraint req1_to_clk1_dly_c { 
		foreach (req1_to_clk1_dly[i]) {
			req1_to_clk1_dly[i] dist {
			[1 : 1000] :/ 64'h7FFFFFFF_FFFFFFFF,
			[0 : 1000000000] :/ 1 }; } }

	constraint clk1_to_ack1_dly_c { 
		foreach (clk1_to_ack1_dly[i]) {
			clk1_to_ack1_dly[i] dist {
			[2 : 20] :/ 64'h7FFFFFFF_FFFFFFFF,
			[0 : 1000000000] :/ 1 }; }  }

	constraint req0_to_ack0_dly_c { 
		foreach (req0_to_ack0_dly[i]) {
			req0_to_ack0_dly[i] dist {
		   	[2 : 20] :/ 64'h7FFFFFFF_FFFFFFFF,
			[0 : 1000000000] :/ 1 }; }  }	

	constraint ack0_to_clk0_dly_c { 
		foreach (clkack_delay_dly[i]) {
			clkack_delay_dly[i] dist {
		   	[8 : 50] :/ 64'h7FFFFFFF_FFFFFFFF,
			[0 : 1000000000] :/ 1 }; }  }	

  
   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   extern function new (string name = "", ovm_component parent = null);
   extern function void build();
  
   // APIs 

   // OVM Macros 
   `ovm_component_utils(ccu_vc_pkg::ccu_vc_rand_delays)

endclass :ccu_vc_rand_delays

/**
 * Class constructor
 * @param   name  OVM name
 * @return        A new object of type ccu_vc_rand_delays 
 */
function ccu_vc_rand_delays::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/**
 * Class builder
 */

function void ccu_vc_rand_delays::build();
	// Super builder
	super.build();
endfunction: build

`endif //INC_ccu_vc_rand_delays
