


	class AssertionFailTest extends PowerGatingBaseTest;

		FabExitIdleSequence exitIdleSeq;
		FabEnterIdleSequence enterIdleSeq;

		`ovm_component_utils(PowerGatingSaolaPkg::AssertionFailTest)
	
		function new(string name = "AssertionFailTest", ovm_component parent = null);
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
			2.	Make sure req and ack deassert
			3.	Fabric enter idle
			4.	Make sure req and ack assert
			*/
			sla_env._vif.fab_pmc_pg_rdy_ack_b[1] = 1'b0;
			sla_env._vif.fab_pmc_pg_rdy_nack_b[1] = 1'b0;

			#20ns
			sla_env._vif.fab_pmc_pg_rdy_ack_b[1] = 1'b1;
			sla_env._vif.fab_pmc_pg_rdy_nack_b[1] = 1'b1;


			#20ns;
			sla_env._vif.fab_pmc_pg_rdy_ack_b[1] = 1'b1;

			#20ns;
			sla_env._vif.pmc_fab_pg_rdy_req_b[1] = 1'b1;
			
			#20ns;
			sla_env._vif.fab_pmc_pg_rdy_ack_b[1] = 1'b0;

			#20ns;
			sla_env._vif.pmc_fab_pg_rdy_req_b[1] = 1'b0;


			#100us;
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("AssertionFailTest", "Test Passed!");
		endfunction

	endclass
	


		
