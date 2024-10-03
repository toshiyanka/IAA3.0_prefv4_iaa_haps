


	class FabricBasicTest extends PowerGatingBaseTest;

		FabExitIdleSequence exitIdleSeq;
		FabEnterIdleSequence enterIdleSeq;
		FabPMCPGReq pgReq;
		FabPMCUGReq ugReq;
		`ovm_component_utils(PowerGatingSaolaPkg::FabricBasicTest)
	
		function new(string name = "FabricBasicTest", ovm_component parent = null);
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
			/*
			1.	Fabric exit idle command
			2.	Make sure req and ack deassert
			3.	Fabric enter idle
			4.	Make sure req and ack assert
			*/
    
			#100us;
		    exitIdleSeq.start(sla_env.pgcbAgent.sequencer);		
			#10us;
			enterIdleSeq.start(sla_env.pgcbAgent.sequencer);	
			#10us;
			//enter idle and exit idle 10 times
			for(int i = 0; i < 10; i++) begin
				//enter PG
				pgReq.start(sla_env.ccAgent.sequencer);
				#10us;
				//deassert pg_req_b
				ugReq.start(sla_env.ccAgent.sequencer);
				#10us;
			end
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("FabricBasicTest", "Test Passed!");
		endfunction

	endclass
	


		

