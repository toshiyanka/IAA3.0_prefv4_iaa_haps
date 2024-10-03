


	class ConcurrentTest extends PowerGatingBaseTest;
		SIPPMCWakeSequence sipPMCWake;
		SIPSWPGReqSequence sipSWPGReqSeq;
		DeSIPSWPGReqSequence sipDeSWPGReqSeq;
		
		SIPHWUGReqSequence sipHWUGReqSeq;
		SIPHWSaveReqSequence sipHWSaveReqSeq;

		FabExitIdleSequence exitIdleSeq;
		FabEnterIdleSequence enterIdleSeq;

		SIPPMCWakeAllSequence sipWakeAll;

		DESIPPMCWakeAllSequence		desipWakeAll;
		DESIPPMCWakeSequence desipPMCWake;
		`ovm_component_utils(PowerGatingSaolaPkg::ConcurrentTest)
	
		function new(string name = "ConcurrentTest", ovm_component parent = null);
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
			//exitIdleSeq = new();
			//enterIdleSeq = new();
			sipHWUGReqSeq = new();
			sipHWSaveReqSeq = new();
			sipSWPGReqSeq = new();
			sipPMCWake = new();
			exitIdleSeq = new();
			enterIdleSeq = new();
			sipWakeAll = new();
			desipWakeAll = new();
			desipPMCWake = new();
			sipDeSWPGReqSeq = new();
  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#200us;
			//start test
			/*
		
			*/
		   //PMC wake
		    sipPMCWake.start(sla_env.ccAgent.sequencer);
			desipPMCWake.start(sla_env.ccAgent.sequencer);		
			exitIdleSeq.start(sla_env.pgcbAgent.sequencer);		


			#1us;
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b1);
			
			//SW PG req
		   	sipSWPGReqSeq.start(sla_env.ccAgent.sequencer);
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b0);
			sipDeSWPGReqSeq.start(sla_env.ccAgent.sequencer);

			enterIdleSeq.start(sla_env.pgcbAgent.sequencer);
			
			#1us;
			//HW UG req
			sipHWUGReqSeq.start(sla_env.pgcbAgent.sequencer);
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b1);


			#1us;
			//exit idel
			exitIdleSeq.start(sla_env.pgcbAgent.sequencer);
		

			//HW PG req
			sipHWSaveReqSeq.start(sla_env.pgcbAgent.sequencer);
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b0);

			sipWakeAll.start(sla_env.ccAgent.sequencer);
			desipWakeAll.start(sla_env.ccAgent.sequencer);			

			#100us;
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("ConcurrentTest", "Test Passed!");
		endfunction

	endclass
	


		
