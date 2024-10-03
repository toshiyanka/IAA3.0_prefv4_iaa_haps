


	class FabricAgentWakeTest extends PowerGatingBaseTest;

		FabExitIdleSequence exitIdleSeq;
		FabEnterIdleSequence enterIdleSeq;
		SIPPMCWakeSequence sipPMCWake;
		DESIPPMCWakeSequence desipPMCWake;

		`ovm_component_utils(PowerGatingSaolaPkg::FabricAgentWakeTest)
	
		function new(string name = "FabricAgentWakeTest", ovm_component parent = null);
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
			exitIdleSeq = new();
			enterIdleSeq = new();
			sipPMCWake = new();
			desipPMCWake = new();
			
		//	sla_env.cc_cfg.SetAgentWakeModel();
		//	sla_env.cc_cfg_pgcb.SetAgentWakeModel();

  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#100us;
			//start test
		    exitIdleSeq.start(sla_env.pgcbAgent.sequencer);
		    
			//	wait for req and ack deassertion
			wait(sla_env._vif.pmc_fab_pg_rdy_req_b[1] == 1'b1);
			#700ns;
			enterIdleSeq.start(sla_env.pgcbAgent.sequencer);
			//Here only wait for the req to assert
			wait(sla_env._vif.pmc_fab_pg_rdy_req_b[1] == 1'b0);			
			wait(sla_env._vif.fab_pmc_pg_rdy_ack_b[1] == 1'b0);	
			// Fabric exit idle again using an agent wake
			sipPMCWake.start(sla_env.ccAgent.sequencer);
			desipPMCWake.start(sla_env.ccAgent.sequencer);		
		    
			#200ns;
			//This is just to make sure that the fabric does not keep waking and pGing
			exitIdleSeq.start(sla_env.pgcbAgent.sequencer);

  			`ovm_info(get_type_name(),"PG req asserted. PASSED!",OVM_LOW)
		
			#300us;
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("FabricAgentWakeTest", "Test Passed!");
		endfunction

	endclass
	


		
