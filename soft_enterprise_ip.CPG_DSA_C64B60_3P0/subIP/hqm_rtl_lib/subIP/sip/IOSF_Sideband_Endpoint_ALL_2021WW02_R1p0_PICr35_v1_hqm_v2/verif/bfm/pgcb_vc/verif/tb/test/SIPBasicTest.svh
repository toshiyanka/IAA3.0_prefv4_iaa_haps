


	class SIPBasicTest extends PowerGatingBaseTest;
		SIPPMCWakeSequence sipPMCWake;
		SIPSWPGReqSequence sipSWPGReqSeq;
		DeSIPSWPGReqSequence sipDeSWPGReqSeq;

		SIPHWUGReqSequence sipHWUGReqSeq;
		SIPHWSaveReqSequence sipHWSaveReqSeq;
		DESIPPMCWakeSequence desipPMCWake;


		`ovm_component_utils(PowerGatingSaolaPkg::SIPBasicTest)
	
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
			//exitIdleSeq = new();
			//enterIdleSeq = new();
			sipHWUGReqSeq = new();
			sipHWSaveReqSeq = new();
			sipSWPGReqSeq = new();
			sipPMCWake = new();
			desipPMCWake = new();
			sipDeSWPGReqSeq = new();

  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#200us;
			//start test
			/*
1.	Wake up the SIP using PMC wake
2.	Make sure req and ack deassert
3.	Assert SW PG request
4.	Make sure req and ack assert
7.	Assert HW UG req
8.	Make sure req and ack assert
9.	Assert HW PG req
10.	Make sure req and ack deassert			
			*/
		   //PMC wake
		    sipPMCWake.start(sla_env.ccAgent.sequencer);
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b1);
			desipPMCWake.start(sla_env.ccAgent.sequencer);		
			
			//SW PG req
		   	sipSWPGReqSeq.start(sla_env.ccAgent.sequencer);
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b0);
		   	sipDeSWPGReqSeq.start(sla_env.ccAgent.sequencer);

			//HW UG req
			sipHWUGReqSeq.start(sla_env.pgcbAgent.sequencer);
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b1);

			//HW PG req
			sipHWSaveReqSeq.start(sla_env.pgcbAgent.sequencer);
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b0);
		    
			sipPMCWake.start(sla_env.ccAgent.sequencer);
	
                        
			
			wait(sla_env._vif.pmc_ip_pg_ack_b[0] == 1'b1);					
			
			#100us;
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("SIPBasicTest", "Test Passed!");
		endfunction

	endclass
	


		
