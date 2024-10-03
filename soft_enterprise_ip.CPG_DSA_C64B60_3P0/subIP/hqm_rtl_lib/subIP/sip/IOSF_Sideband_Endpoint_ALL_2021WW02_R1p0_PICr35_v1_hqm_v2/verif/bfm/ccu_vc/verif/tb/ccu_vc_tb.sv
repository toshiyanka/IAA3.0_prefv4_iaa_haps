//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2011 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// ccu_vc_tb interface definition
//------------------------------------------------------------------

module myrtl #(parameter int NUM_SLICES=7) (
  input bit [NUM_SLICES-1:0] clk,
  input bit [NUM_SLICES-1:0] clkack,
  output bit [NUM_SLICES-1:0] clkreq,
  output bit [NUM_SLICES-1:0] global_rst_b,
  input bit [NUM_SLICES-1:0] usync);
  
  bit clk6_delay;
  time rise_time[NUM_SLICES-1:0];
  time fall_time[NUM_SLICES-1:0];
  time clk_freq[NUM_SLICES-1:0];
 
  initial
  begin 
    clkreq = {'0,1'b1};
	global_rst_b = {'1,1'b0,1'b0,1'b0};
	clk6_delay = 1'b1;
	//#1ps;
	//clkreq[0] = 1'b1;
	#4ns;
	clkreq[1] = 1'b1;
	#1ns;
	clkreq = '1;
	#2ns;
	global_rst_b = '1;
  end
  
  initial 
  begin
	#20ns;
	clk6_delay = 1'b0;
	#20ns;
	global_rst_b[6] = 1'b0;
	global_rst_b[0] = 1'b0;
	#60ns;
	global_rst_b[6] = 1'b1;
	global_rst_b[0] = 1'b1;
	global_rst_b[1] = 1'b0;
	#10ns;
	global_rst_b[2] = 1'b0;
	#40ns;
	global_rst_b[1] = 1'b1;
	global_rst_b[2] = 1'b1;
  end
  
  initial
  begin
    @(posedge clk[0]) rise_time[0] = $time;
    @(negedge clk[0]) fall_time[0] = $time;
    clk_freq[0] = fall_time[0]-rise_time[0];
    forever
    begin
      int delay = $urandom_range(200);
      forever
      begin
        #(delay*clk_freq[0]);
		//clkreq[0] = ~clkreq[0];
      end
    end
  end
  initial
  begin
    @(posedge clk[1]) rise_time[1] = $time;
    @(negedge clk[1]) fall_time[1] = $time;
    clk_freq[1] = fall_time[1]-rise_time[1];
    forever
    begin
      int delay = $urandom_range(400);
      forever
      begin
        #(delay*clk_freq[1]);
		if(clkack[1]) clkreq[1] = 0;
		else if(!clkack[1]) wait(!global_rst_b[1]) clkreq[1] = 1;
		if(clkack[4]) clkreq[4] = 0;
		else if(!clkack[4]) clkreq[4] = 1;
      end
    end
  end
  initial
  begin
    @(posedge clk[2]) rise_time[2] = $time;
    @(negedge clk[2]) fall_time[2] = $time;
    clk_freq[2] = fall_time[2]-rise_time[2];
    forever
    begin
      int delay = $urandom_range(600);
      forever
      begin
        #(delay*clk_freq[2]);
        if(clkack[2]) clkreq[2] = 0;
		else if(!clkack[2]) clkreq[2] = 1;
		if(clkack[5]) clkreq[5] = 0;
		else if(!clkack[5]) clkreq[5] = 1;
      end
    end
  end
  initial
  begin
    @(posedge clk[3]) rise_time[3] = $time;
    @(negedge clk[3]) fall_time[3] = $time;
    clk_freq[3] = fall_time[3]-rise_time[3];
    forever
    begin
      int delay = $urandom_range(300);
      forever
      begin
        #(delay*clk_freq[3]);
        //clkreq[3] = !clkreq[3];
      end
    end
  end
  initial
  begin
    @(posedge clk[6]) rise_time[6] = $time;
    @(negedge clk[6]) fall_time[6] = $time;
    clk_freq[6] = fall_time[6]-rise_time[6];
    forever
    begin
      int delay = $urandom_range(40);
      forever
      begin
        #(delay*clk_freq[6]*1ns);
		if(clkack[6]) clkreq[6] = 0;
		else if(!clkack[6] && clk6_delay) clkreq[6] = 1;
      end
    end
  end

endmodule

/**
 * Top Level TB for ccu_vc 
 */
module ccu_vc_tb;
   //------------------------------------------
   // Imports/Includes 
   //------------------------------------------

   //------------------------------------------
   // FSDB Dumping 
   //------------------------------------------
  `include "std_ace_util.vic"
   initial dump_fsdb();

   //------------------------------------------
   // Signals 
   //------------------------------------------
   localparam NUM_SLICES = 7;
   localparam NUM_SLICES2 = 4; 
   // TODO: Add signals here

   //------------------------------------------
   // Clock/Reset 
   //------------------------------------------
	
   // Generate Clocks
   //ccu_vc_clkgen u_clkgen();

   // Link to Saola
   //sla_clkrst_intf i_sla_clkrst_intf(u_clkgen.clk, u_clkgen.reset);

   //------------------------------------------
   // Interfaces Instantiation 
   //------------------------------------------
   ccu_intf #(NUM_SLICES) ccu_if_1();
   ccu_intf #(NUM_SLICES2) ccu_if_2();
   // TODO: To be added

   //------------------------------------------
   // TI Instantiation 
   //------------------------------------------
   ccu_vc_ti #(NUM_SLICES,1,"*ovm_ccu_vc_env.ccu_vc_1") ccu_ti_1 (ccu_if_1);
   //ccu_vc_ti #(NUM_SLICES2,0,"*ovm_ccu_vc_env.ccu_vc_2") ccu_ti_2 (ccu_if_2);	
   ccu_vc_ti #(NUM_SLICES2,0,"*ovm_ccu_vc_env.ccu_vc_2",'{default:120ps},'{default:20},'{default:30}) ccu_ti_2 (ccu_if_2);
   assign ccu_if_1.pwell_pok = '1;
   assign ccu_if_2.pwell_pok = '1;
//   assign ccu_if_2.global_rst_b = '1;

   //------------------------------------------
   // assertoff example
   //------------------------------------------
   	initial begin
   		$assertoff(2,ccu_ti_2);
		ccu_if_2.clkreq = '0;
		#5ns;
		ccu_if_2.clkreq = '1;
		#5ns;
		ccu_if_2.clkack = '1;
		#10ns;
		ccu_if_2.clkack = '0;
	end

   //------------------------------------------
   // Test Instantiation 
   //------------------------------------------
   ccu_vc_test_mod u_ccu_vc_test_mod();

   //------------------------------------------
   // DUT 
   //------------------------------------------
   //ccu_vc u_ccu_vc ();
   myrtl #(NUM_SLICES) rtl (ccu_if_1.clk, ccu_if_1.clkack, ccu_if_1.clkreq, ccu_if_1.global_rst_b, ccu_if_1.usync);

endmodule: ccu_vc_tb

