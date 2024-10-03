//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2015 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr 
// Date Created : 2015-04-01 
//-----------------------------------------------------------------
// Description:
// ccu_vc_test_rand_dly class
//------------------------------------------------------------------

`ifndef INC_ccu_vc_test_rand_dly
`define INC_ccu_vc_test_rand_dly


class ccu_vc_test_rand_dly extends ccu_vc_rand_delays;

	`ovm_component_utils(ccu_vc_test_rand_dly)

   //------------------------------------------
   // Constraints 
   //------------------------------------------
	constraint req1_to_clk1_dly_c { 
		foreach (req1_to_clk1_dly[i]) {
			req1_to_clk1_dly[i] dist {
			[10 : 20] :/ 64'h7FFFFFFF_FFFFFFFF,
			[0 : 1000000000] :/ 1 }; } }

	constraint clk1_to_ack1_dly_c { 
		foreach (clk1_to_ack1_dly[i]) {
			clk1_to_ack1_dly[i] dist {
			[10 : 20] :/ 64'h7FFFFFFF_FFFFFFFF,
			[0 : 1000000000] :/ 1 }; }  }

	constraint req0_to_ack0_dly_c { 
		foreach (req0_to_ack0_dly[i]) {
			req0_to_ack0_dly[i] dist {
		   	[0 : 10] :/ 64'h7FFFFFFF_FFFFFFFF,
			[0 : 1000000000] :/ 1 }; }  }	

	constraint ack0_to_clk0_dly_c { 
		foreach (clkack_delay_dly[i]) {
			clkack_delay_dly[i] dist {
		   	[0 : 10] :/ 64'h7FFFFFFF_FFFFFFFF,
			[0 : 1000000000] :/ 1 }; }  }	


	function new(string name, ovm_component parent);
		super.new(name, parent);
	endfunction

	function void build();
		super.build();
	endfunction

 
endclass

`endif //INC_ccu_vc_test_rand_dly
