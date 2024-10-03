
	class RestoreTest extends PowerGatingBaseTest;
		SIPPMCWakeSequence sipPMCWake;
		SIPSWPGReqSequence sipSWPGReqSeq;
		DeSIPSWPGReqSequence sipDeSWPGReqSeq;

		SIPHWUGReqSequence sipHWUGReqSeq;
		SIPHWSaveReqSequence sipHWSaveReqSeq;
		DESIPPMCWakeSequence desipPMCWake;

		RestoreNextWake restoreNextWake;
		RestoreDsd restoreDsd;
		`ovm_component_utils(PowerGatingSaolaPkg::RestoreTest)
	
		function new(string name = "RestoreTest", ovm_component parent = null);
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
			desipPMCWake = new();
			restoreNextWake = new();
			restoreDsd = new();
			sipDeSWPGReqSeq = new();

  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#100us;

		   	restoreNextWake.start(sla_env.ccAgent.sequencer);
			
		    sipPMCWake.start(sla_env.ccAgent.sequencer);
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b1);
			desipPMCWake.start(sla_env.ccAgent.sequencer);		

		   	restoreDsd.start(sla_env.ccAgent.sequencer);			
			#1us;
			//SW PG req
		   	sipSWPGReqSeq.start(sla_env.ccAgent.sequencer);
			//@(negedge sla_env._vif.pmc_ip_pg_ack_b[1]) //1'b0);
			#1us;
		   	sipDeSWPGReqSeq.start(sla_env.ccAgent.sequencer);

		   	restoreNextWake.start(sla_env.ccAgent.sequencer);

			
			fork 
			 begin
					sipHWUGReqSeq.start(sla_env.pgcbAgent.sequencer);
				end
				begin
					wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b1);
					#30ns;
					restoreDsd.start(sla_env.ccAgent.sequencer);
				end
			join_none;
				
	

			
			#100us;
		//	wait(sla_env._vif.pmc_ip_pg_ack_b[1] == 1'b1);

			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("RestoreTest", "Test Passed!");
		endfunction

	endclass
	
