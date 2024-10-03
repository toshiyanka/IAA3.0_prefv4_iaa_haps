


	class ResetTest extends PowerGatingBaseTest;
		SIPPMCWakeSequence sipPMCWake;
		SIPSWPGReqSequence sipSWPGReqSeq;

		SIPHWUGReqSequence sipHWUGReqSeq;
		SIPHWSaveReqSequence sipHWSaveReqSeq;

		FabExitIdleSequence exitIdleSeq;
		FabEnterIdleSequence enterIdleSeq;

		SIPPMCWakeAllSequence sipWakeAll;

		DESIPPMCWakeAllSequence		desipWakeAll;
		DESIPPMCWakeSequence desipPMCWake;


		`ovm_component_utils(PowerGatingSaolaPkg::ResetTest)
	
		function new(string name = "ResetTest", ovm_component parent = null);
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

  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#100us;

		   //PMC wake
		    //sipPMCWake.start(sla_env.ccAgent.sequencer);
		/*	sipWakeAll.start(sla_env.ccAgent.sequencer);
			desipWakeAll.start(sla_env.ccAgent.sequencer);		
			
			exitIdleSeq.start(sla_env.pgcbAgent.sequencer);		
*/
			#70us;
			sipWakeAll.start(sla_env.ccAgent.sequencer);
			desipWakeAll.start(sla_env.ccAgent.sequencer);					
			exitIdleSeq.start(sla_env.pgcbAgent.sequencer);

			#100us;
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("ResetTest", "Test Passed!");
		endfunction

	endclass
	


		
