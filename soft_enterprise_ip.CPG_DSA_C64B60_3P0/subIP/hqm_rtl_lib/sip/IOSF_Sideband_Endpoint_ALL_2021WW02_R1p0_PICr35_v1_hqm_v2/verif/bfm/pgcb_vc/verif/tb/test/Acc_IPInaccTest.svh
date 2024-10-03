
	class Acc_IPInaccTest extends PowerGatingBaseTest;
		SIPPMCWakeAllSequence sipWakeAll;
		SIPPMCWakeSequence sipPMCWake;
		DESIPPMCWakeAllSequence		desipWakeAll;
		SIPSWPGReqSequence sipSWPGReqSeq;
		SIPHWUGReqSequence sipHWUGReqSeq;

		SIPHWSaveReqSequence sipHWSaveReqSeq;
		SIPRandHWSaveReqSequence randsipHWSaveReqSeq;
		SIPRandHWUGReqSequence randsipHWUGReqSeq;

		FabExitIdleSequence exitIdleSeq;
		FabEnterIdleSequence enterIdleSeq;

		IPInaccessibleSequence ipInAcc;
		`ovm_component_utils(PowerGatingSaolaPkg::Acc_IPInaccTest)
	
		function new(string name = "Acc_IPInaccTest", ovm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build();
			set_config_int("sla_env", "data_phase_mode", SLA_RANDOM_NONE );
			set_config_int("*", "count", 0);
			set_config_int("*","recording_detail", OVM_FULL);
	  		ovm_top.set_report_verbosity_level(OVM_FULL);   
			
			super.build();
		//	set_type_override_by_type(PGCBAgentResponseSeqItem::get_type(), PGCBAgentResponseSeqItemNew1::get_type());
		//	set_type_override_by_type(CCAgentResponseSeqItem::get_type(), CCAgentResponseSeqItemNew::get_type());

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
			desipWakeAll = new();
			randsipHWUGReqSeq = new();
			exitIdleSeq = new();
			enterIdleSeq = new();

			ipInAcc = new();
  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#100us;
			//start test

		   //PMC wake
		    //sipPMCWake.start(sla_env.ccAgent.sequencer);
			sipWakeAll.start(sla_env.ccAgent.sequencer);
			desipWakeAll.start(sla_env.ccAgent.sequencer);
		
			//IP Acc
			sipHWSaveReqSeq.start(sla_env.pgcbAgent.sequencer);

			#10us;
			ipInAcc.start(sla_env.pgcbAgent.sequencer);
			
			#30us;

			sipWakeAll.start(sla_env.ccAgent.sequencer);
			desipWakeAll.start(sla_env.ccAgent.sequencer);


			#100us;
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("Acc_IPInaccTest", "Test Passed!");
		endfunction

	endclass
	


		
