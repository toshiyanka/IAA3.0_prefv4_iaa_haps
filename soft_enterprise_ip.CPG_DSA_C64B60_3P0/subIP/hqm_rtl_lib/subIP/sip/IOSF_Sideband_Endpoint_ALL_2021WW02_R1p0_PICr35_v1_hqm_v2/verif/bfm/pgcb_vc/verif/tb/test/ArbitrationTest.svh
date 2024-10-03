class PGCBAgentResponseSeqItemNew1 extends PGCBAgentResponseSeqItem;


	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_object_utils_begin(PGCBAgentResponseSeqItemNew1)
		//`ovm_field_int(delay , OVM_ALL_ON)
	`ovm_object_utils_end
	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name="PGCBAgentXaction");
		super.new(name);
	endfunction : new

	/*constraint delay_c {
		delay == 5;
	}
	*/
	constraint delay_ug_req_c {
		delay_ug_req == 5;
	}
	constraint delay_pg_req_c {
		delay_pg_req == 20;
	}
	//Setting noRespnse to 1. So the respnder will not send any responses.
	constraint noResponse_c {
		noResponse == 0; 
	}

endclass: PGCBAgentResponseSeqItemNew1


class CCAgentResponseSeqItemNew extends CCAgentResponseSeqItem;


	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_object_utils_begin(CCAgentResponseSeqItemNew)
	`ovm_object_utils_end
	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name="PGCBAgentXaction");
		super.new(name);
	endfunction : new
	constraint noResponse_c { 
		noResponse == 0; 
	}

	constraint delay_pg_ack_c { 
		delay_pg_ack >= 0; delay_pg_ack < 6;
		}
	constraint delay_restore_ack_c {
		delay_restore_ack dist{
		[3:6] 		:= 99};
		//TODO: update this
		//[7:2000] 	:= 1};
		//[7:100] 	:= 1};

		}	

	constraint delay_ug_ack_c { 
		delay_ug_ack == 25;
		}
	
	constraint delay_fab_ug_req_c { 
		delay_fab_ug_req == 200;
		}
	constraint delay_fet_en_c { 
		delay_fet_en == 5; 
		}	
	constraint delay_fet_dis_c { 
		delay_fet_dis == 5; 
		}	

endclass: CCAgentResponseSeqItemNew


	class ArbitrationTest extends PowerGatingBaseTest;
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
		`ovm_component_utils(PowerGatingSaolaPkg::ArbitrationTest)
	
		function new(string name = "ArbitrationTest", ovm_component parent = null);
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
			desipWakeAll = new();
			randsipHWUGReqSeq = new();
			exitIdleSeq = new();
			enterIdleSeq = new();
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
			ovm_report_info("ArbitrationTest", "Test Passed!");
		endfunction

	endclass
	


		
