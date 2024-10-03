


	class SIPAbortTest extends PowerGatingBaseTest;
		SIPPMCWakeSequence sipPMCWake;
		SIPSWPGReqSequence sipSWPGReqSeq;

		SIPHWUGReqSequence sipHWUGReqSeq;
		SIPHWSaveReqSequence sipHWSaveReqSeq;
		SIPHWRestoreReqSequence sipHWRestoreReqSeq;
		DESIPPMCWakeSequence desipPMCWake;

		`ovm_component_utils(PowerGatingSaolaPkg::SIPAbortTest)
	
		function new(string name = "SIPAbortTest", ovm_component parent = null);
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
			sipHWRestoreReqSeq = new();
			desipPMCWake = new();

  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#100us;
			//start test
			/*
			
			*/
		   //PMC wake
		    sipPMCWake.start(sla_env.ccAgent.sequencer);
			desipPMCWake.start(sla_env.ccAgent.sequencer);		
			
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b1);
			
			//SW PG req
		   /*	sipSWPGReqSeq.start(sla_env.ccAgent.sequencer);
			wait(sla_env._vif.pmc_ip_pg_ack_b[1] == 1'b0);

			//HW UG req
			sipHWUGReqSeq.start(sla_env.pgcbAgent.sequencer);
			wait(sla_env._vif.pmc_ip_pg_ack_b[1] == 1'b1);
*/
			//HW PG req
			//sipHWSaveReqSeq.start(sla_env.pgcbAgent.sequencer);
			//wait(sla_env._vif.pmc_ip_pg_ack_b[1] == 1'b0);
			//abort
			#10ns;
			sipHWRestoreReqSeq.start(sla_env.pgcbAgent.sequencer);
			
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b1);
			

			#100us;
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("SIPAbortTest", "Test Passed!");
		endfunction

	endclass
	


		
