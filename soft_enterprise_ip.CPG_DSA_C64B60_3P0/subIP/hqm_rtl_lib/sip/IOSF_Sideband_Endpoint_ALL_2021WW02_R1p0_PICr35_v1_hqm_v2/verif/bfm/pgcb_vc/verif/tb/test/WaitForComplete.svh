


	class WaitForComplete extends PowerGatingBaseTest;
		SIPPMCWakeAllSequence sipWakeAll;
		SIPPMCWakeSequence sipPMCWake;
		SIPSWPGReqSequence sipSWPGReqSeq;
		SIPHWUGReqSequence sipHWUGReqSeq;

		SIPHWSaveReqSequence sipHWSaveReqSeq;
		SIPRandHWSaveReqSequence randsipHWSaveReqSeq;
		SIPRandHWUGReqSequence randsipHWUGReqSeq;

		FabExitIdleSequence exitIdleSeq;
		FabEnterIdleSequence enterIdleSeq;


		DESIPPMCWakeAllSequence		desipWakeAll;
		DESIPPMCWakeSequence desipPMCWake;
		
		`ovm_component_utils(PowerGatingSaolaPkg::WaitForComplete)
	
		function new(string name = "WaitForComplete", ovm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build();
			set_config_int("sla_env", "data_phase_mode", SLA_RANDOM_NONE );
			set_config_int("*", "count", 0);
			set_config_int("*","recording_detail", OVM_FULL);
	  		ovm_top.set_report_verbosity_level(OVM_FULL);   
			
			super.build();
			set_type_override_by_type(PGCBAgentResponseSeqItem::get_type(), PGCBAgentResponseSeqItemNew1::get_type());
			set_type_override_by_type(CCAgentResponseSeqItem::get_type(), CCAgentResponseSeqItemNew::get_type());

		endfunction

		function void connect();
			super.connect();   
		endfunction  
  		task run();
			//exitIdleSeq = new();
			//enterIdleSeq = new();
			randsipHWSaveReqSeq = new();
			sipHWSaveReqSeq = new();
			sipHWUGReqSeq = new();
			sipSWPGReqSeq = new();
			sipPMCWake = new();
			sipWakeAll = new();
			randsipHWUGReqSeq = new();
			exitIdleSeq = new();
			enterIdleSeq = new();
			desipWakeAll = new();
			desipPMCWake = new();

  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#100us;
			//start test

		   //PMC wake
		    //sipPMCWake.start(sla_env.ccAgent.sequencer);
			sipWakeAll.start(sla_env.ccAgent.sequencer);
			desipWakeAll.start(sla_env.ccAgent.sequencer);		
			exitIdleSeq.start(sla_env.pgcbAgent.sequencer);
			wait(sla_env._vif.fab_pmc_idle[1] == 1'b0);
			//everytihng is awake
					
			#10us;
			//HW PG requests from SIP 1.
			sipHWSaveReqSeq.start(sla_env.pgcbAgent.sequencer);

			#10us
			//HW PG request from 0 and 2
			randsipHWSaveReqSeq.start(sla_env.pgcbAgent.sequencer);
			randsipHWSaveReqSeq.start(sla_env.pgcbAgent.sequencer);


			#140ns;
			
			//At the same time UG request from 1
			sipHWUGReqSeq.start(sla_env.pgcbAgent.sequencer);
			enterIdleSeq.start(sla_env.pgcbAgent.sequencer);

			#10us;
			//check ungate priority is working
			//HW PG requests from SIP 1.
			sipHWSaveReqSeq.start(sla_env.pgcbAgent.sequencer);

			#170ns;
			//How ungate both 0 and 2 at the same time
			randsipHWUGReqSeq.start(sla_env.pgcbAgent.sequencer);
			randsipHWUGReqSeq.start(sla_env.pgcbAgent.sequencer);
			
			#10us;
			

			#100us;
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("WaitForComplete", "Test Passed!");
		endfunction

	endclass
	


		
