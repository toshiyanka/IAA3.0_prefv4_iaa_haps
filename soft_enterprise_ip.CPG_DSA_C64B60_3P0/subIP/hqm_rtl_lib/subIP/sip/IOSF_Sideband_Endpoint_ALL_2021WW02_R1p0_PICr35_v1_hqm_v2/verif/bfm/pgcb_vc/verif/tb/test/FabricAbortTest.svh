


	class FabricAbortTest extends PowerGatingBaseTest;

		FabExitIdleSequence exitIdleSeq;
		FabEnterIdleSequence enterIdleSeq;

		`ovm_component_utils(PowerGatingSaolaPkg::FabricAbortTest)
	
		function new(string name = "FabricAbortTest", ovm_component parent = null);
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
  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#100us;
			//start test
			/*
1.	Fabric exit idle command
2.	Make sure req and ack assert
3.	Fabric enter idle
4.	Make sure req asserts
5.	Fabric exit idle again before ack
6.	Make sure the NACK asserts
7.	Here make fabric enter idle again
8.	Make sure the req deassert first and only then asserts again.


			*/
		    exitIdleSeq.start(sla_env.pgcbAgent.sequencer);
		    
			//	wait for req and ack deassertion
			wait(sla_env._vif.pmc_fab_pg_rdy_req_b[1] == 1'b1);
			#700ns;
			enterIdleSeq.start(sla_env.pgcbAgent.sequencer);
			//Here only wait for the req to assert
			wait(sla_env._vif.pmc_fab_pg_rdy_req_b[1] == 1'b0);			
			// Fabric exit idle again before ack
		    exitIdleSeq.start(sla_env.pgcbAgent.sequencer);

			wait(sla_env._vif.fab_pmc_idle[1] == 1'b0);	


			//wait for nack
			wait(sla_env._vif.fab_pmc_pg_rdy_nack_b[1] == 1'b0);				
			#1us;

			//get into idle and get out before expiry of hysteresis
			enterIdleSeq.start(sla_env.pgcbAgent.sequencer);
			#20ns;
			exitIdleSeq.start(sla_env.pgcbAgent.sequencer);
			
			#2us;
			//nothing should happen
			//how to check this




			// Here make fabric enter idle again			
	/*		enterIdleSeq.start(sla_env.pgcbAgent.sequencer);
			//Make sure the req deassert first and only then asserts again.
			wait(sla_env._vif.pmc_fab_pg_rdy_req_b[1] == 1'b1);
  			`ovm_info(get_type_name(),"PG req deasserted. Now waitong for assertion",OVM_LOW)

			wait(sla_env._vif.pmc_fab_pg_rdy_req_b[1] == 1'b0);	
  			`ovm_info(get_type_name(),"PG req asserted. PASSED!",OVM_LOW)
	*/	
			#100us;
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("FabricAbortTest", "Test Passed!");
		endfunction

	endclass
	


		
