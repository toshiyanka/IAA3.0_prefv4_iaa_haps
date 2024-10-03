	class DfxTest extends PowerGatingBaseTest;
		CCAgentBaseSequence seq;
		`ovm_component_utils(PowerGatingSaolaPkg::DfxTest)
	
		function new(string name = "SIPBasicTest", ovm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build();
			set_config_int("sla_env", "data_phase_mode", SLA_RANDOM_NONE );
			set_config_int("*", "count", 0);
			set_config_int("*","recording_detail", OVM_FULL);
	  		ovm_top.set_report_verbosity_level(OVM_FULL);   
			
			super.build();
		endfunction

		function void connect();
			super.connect();   
		endfunction  
  		task run();

  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#100us;

			//start test
			#2ns; //dont want to be in sync with clock
			//asset bypass and ovr at the same time for PGCB no : 1. Set delay to 0
			seq = new();
			seq.randomize() with {cmd == PowerGating::FDFX_BYPASS_ASD; source == 0; delay == 0;};
			seq.start(sla_env.ccAgent.sequencer);		
			seq.randomize() with {cmd == PowerGating::FDFX_OVR_ASD; source == 0; delay == 0;};
			seq.start(sla_env.ccAgent.sequencer);		

			//IP to fill in code here - wait for IP signals to power gate here. 

			//now deassert ovr. IP must wake up
			seq.randomize() with {cmd == PowerGating::FDFX_OVR_DSD; source == 0; delay == 10;};
			seq.start(sla_env.ccAgent.sequencer);		
			
			//IP to fill in code here - wait for IP signals to wake up here.	

			#1us;
			sla_env._vif.ip_pmc_d3[0] = 1'b1;
			sla_env._vif.ip_pmc_d0i3[0] = 1'b1;
			sla_env._vif.ip_pmc_d3[1] = 1'b1;
			#1us;
			sla_env._vif.ip_pmc_d3[0] = 1'b0;
			sla_env._vif.ip_pmc_d0i3[0] = 1'b0;
			sla_env._vif.ip_pmc_d3[1] = 1'b0;

			#10us;

							
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("SIPBasicTest", "Test Passed!");
		endfunction

	endclass

