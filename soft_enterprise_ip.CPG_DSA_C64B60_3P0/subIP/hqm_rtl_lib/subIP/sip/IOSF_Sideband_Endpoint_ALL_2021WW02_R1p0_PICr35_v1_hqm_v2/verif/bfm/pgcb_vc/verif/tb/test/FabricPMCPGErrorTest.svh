


	class FabricPMCPGErrorTest extends PowerGatingBaseTest;

		FabExitIdleSequence exitIdleSeq;
		FabEnterIdleSequence enterIdleSeq;
		FabPMCPGReq pgReq;
		FabPMCUGReq ugReq;
		`ovm_component_utils(PowerGatingSaolaPkg::FabricPMCPGErrorTest)
	
		function new(string name = "FabricPMCPGErrorTest", ovm_component parent = null);
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
			pgReq = new();
			ugReq = new();
  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#100us;
			//start test

		    exitIdleSeq.start(sla_env.pgcbAgent.sequencer);		    
			//	wait for req and ack deassertion
			#5us;
			
			pgReq.start(sla_env.ccAgent.sequencer);		

			#2us;

			enterIdleSeq.start(sla_env.pgcbAgent.sequencer);
						
			#2us;
			ugReq.start(sla_env.ccAgent.sequencer);

			#100us;
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("FabricPMCPGErrorTest", "Test Passed!");
		endfunction

	endclass
	


		
