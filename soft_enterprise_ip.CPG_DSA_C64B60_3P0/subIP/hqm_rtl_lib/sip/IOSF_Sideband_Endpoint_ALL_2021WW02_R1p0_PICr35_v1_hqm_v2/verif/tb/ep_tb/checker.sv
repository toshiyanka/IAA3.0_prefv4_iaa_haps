
module lpcov_pst(cur_state);
 import UPF::*;

 input supply_net_type cur_state;
 
 parameter string PST_NAME = "";
 parameter int NUMSTATES = 0;
 parameter string STATENAMES = "";

`ifdef LPCOV_pst
 covergroup cg_pst_state @(cur_state);
   c: coverpoint cur_state {
      illegal_bins illegal = {0};
      bins s13 = {1};
      bins s01 = {2};
      bins s02 = {3};
      bins s11 = {4};	 
      bins s0  = {5};
      bins s03 = {6};
      bins s12 = {7};
      bins s1  = {8};
   }
 endgroup

 cg_pst_state pst_state;
 initial begin
 	 pst_state = new;
	// pst_state.sample();
	 $display("PST %s has %d states and they are called %s", PST_NAME, NUMSTATES, STATENAMES);	 
 end

`endif

endmodule


//=================================================================

module lpcov_pd(pd_simstate);
 import UPF::*;

 input power_state_simstate pd_simstate;
 parameter string PD_NAME = "";
   
`ifdef LPCOV_pd
 covergroup cg_pd_state;
   c: coverpoint pd_simstate {      
      bins normal = {0}; //{NORMAL};
      bins corrupt = {1}; //{CORRUPT};
      bins corrupt_on_activity = {2}; //{CORRUPT_ON_ACTIVITY};
     //bins corrupt_state_on_change = {CORRUPT_STATE_ON_CHANGE};	 
      //bins corrupt_state_on_activity  = {CORRUPT_STATE_ON_ACTIVITY};
   }
 endgroup

 cg_pd_state pd_state;
 initial begin 	
 	 pd_state = new;
	 pd_state.sample(); // To capture the initial value	 	   
 end
 always @(pd_simstate) begin
 	pd_state.sample();
	$display("Simstate of %s is now %d", PD_NAME, pd_simstate);
 end
`endif //  `ifdef LPCOV_pd
   
endmodule


//=================================================================
`ifdef LPCOV_primary_power_off
module primary_power_off(PPN);
 input PPN;

 import UPF::*;
`ifndef NOVAS_UPF_PKG
 //import SNPS_LPA_PKG::*;
`endif

 supply_net_type PPN;
 string PPN_STATE = "";
 parameter string PD_NAME = "";
 parameter string PPN_NAME = "";
 always @(PPN.state)
   begin : my_lp_checker
	PPN_STATE = PPN.state.name;
	$display("PPN %s has PPN_STATE = %s", PPN_NAME, PPN_STATE);
	//if (`lpa_id_enabled("LP_PPN_OFF"))
		//my_assert : assert (PPN_STATE !== "OFF") 
	//else
		//`lpa_log("LP_PPN_OFF", $psprintf( `lpa_msg_format("LP_PPN_OFF"), PPN_NAME,PD_NAME));
   end : my_lp_checker
endmodule

`endif


//=================================================================
`ifdef LPCOV_sw_out_off
module sw_out_off(PSW_OUT_PORT);
 input PSW_OUT_PORT;

 import UPF::*;
`ifndef NOVAS_UPF_PKG
 //import SNPS_LPA_PKG::*;
`endif

 supply_net_type PSW_OUT_PORT;
 string PSOP_STATE = "";
 //These were passed as -parameters in the bind_checker command
 parameter string PSW_NAME = "";
 parameter string PSW_OUT_PORT_NAME = "";
 always @(PSW_OUT_PORT)
   begin : my_lp_checker
        PSOP_STATE = PSW_OUT_PORT.state.name;
        $display("Switch %s has PSOP_STATE = %s", PSW_NAME, PSOP_STATE);
   end : my_lp_checker
 
 //Because strings are not allowed in coverpoints, and the state is read in 
 //as a string, must explicitly 'translate' it to an integer: iswos
 shortint iswos;
 always_comb begin
 	if (PSW_OUT_PORT.state.name == "OFF")
	     iswos = 0;
	else if (PSW_OUT_PORT.state.name == "FULL_ON")
	     iswos = 1;
	else
	     iswos = 2; // this should never occur
 end
 covergroup cg_sw_output_state @(iswos);
   c: coverpoint iswos {
      bins off = {0};
      bins full_on = {1};
      //illegal_bins whoknows = {2};
   }
 endgroup

 initial begin
 	 cg_sw_output_state sos = new;
 end


endmodule
`endif

