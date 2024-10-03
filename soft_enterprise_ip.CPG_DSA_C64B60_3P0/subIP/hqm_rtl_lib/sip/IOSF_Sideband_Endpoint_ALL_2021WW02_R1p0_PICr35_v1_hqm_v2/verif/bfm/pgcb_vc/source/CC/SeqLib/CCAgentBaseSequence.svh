/*
================================================================================
  Copyright (c) 2011 Intel Corporation, all rights reserved.

  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY COPYRIGHT LAWS AND IS 
  CONSIDERED A TRADE SECRET BELONGING TO THE INTEL CORPORATION.
================================================================================

  Author          : Alamelu Ramaswamy
  Email           : 
  Phone           : 916-377-2848
  Date            : July 18th, 2012

================================================================================
  Description     : Base sequence for CCAgent Agent
  
This is the base sequence for the CCAgent Agent from which all other 
sequences should be derived. The constraints herein should contain only those
necessary to ensure legality. No distributions. The expectations on the user are
such that the MUST extend this class to provide distributions to get "typical"/
"normal" behavior. On top of this CCAgent Base Sequence will be a "default"
sequence that contains a few basic distributions used by the Agent primarily for
self testing purposes, though the user is welcome to extend from the default
sequence if they so desire. Without any user intervention, the default sequence
will be what is generated if the sequencer's count is non-zero (-1, or > 0).

================================================================================
*/
class CCAgentBaseSequence extends ovm_sequence #(CCAgentSeqItem);
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	//time startTime;
	rand PowerGating::Event_e cmd;
	rand int source;
	string sourceName;
	rand int delay;
	rand bit waitForComplete;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================

	`ovm_sequence_utils_begin(CCAgentBaseSequence, CCAgentSequencer)
        `ovm_field_enum(PowerGating::Event_e, cmd, OVM_ALL_ON)		
		`ovm_field_int(source , OVM_ALL_ON)
		`ovm_field_string(sourceName , OVM_ALL_ON)
		`ovm_field_int(delay , OVM_ALL_ON)
		`ovm_field_int(waitForComplete, OVM_ALL_ON)
	`ovm_sequence_utils_end
	//=========================================================================
	// PROTECTED VARIABLES
	//=========================================================================

	//=========================================================================
	// PRIVATE VARIABLES
	//=========================================================================
	
	//=========================================================================
	// CONSTRAINTS (across all types)
	//=========================================================================
	//=========================================================================
	// CONSTRAINTS (across all types)
	//=========================================================================


	//=========================================================================
	// PUBLIC FUNCTIONS
	//=========================================================================

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "CCAgentBaseSequence");
		super.new(name);
	endfunction : new

	//=========================================================================
	// PUBLIC TASKS
	//=========================================================================

	/**************************************************************************
	*  @brief Body task, where constraints on sequence item is applied.
	**************************************************************************/
	virtual task body();
		`ovm_create(req);
		req.sourceName =  sourceName;
		`ovm_rand_send_with(req, {
			req.cmd == local::cmd; 
			req.source == local::source;
			req.delay == local::delay;})
		
		/*`ovm_do_with(req, {
			req.cmd == local::cmd; 
			req.source == local::source;
			req.delay == local::delay;})
			*/
		if(waitForComplete) begin
			`ovm_info(get_full_name(), {"sequence waiting for complete : ",req.toString()}, OVM_FULL)
			req.waitForComplete();
		end
			`ovm_info(get_full_name(), {"sequence COMPLETE : ",req.toString()}, OVM_FULL)


	endtask : body

	//=========================================================================
	// PROTECTED FUNCTIONS
	//=========================================================================

	//=========================================================================
	// PROTECTED TASKS
	//=========================================================================

	//=========================================================================
	// PRIVATE FUNCTIONS
	//=========================================================================

	//=========================================================================
	// PRIVATE TASKS
	//=========================================================================


	constraint delay_c {
		delay >= 0; delay < 20;
	}

	constraint cmd_c {
		cmd inside 
		{PowerGating::SW_PG_REQ, 
		PowerGating::DEASSERT_SW_PG_REQ,	
		PowerGating::PMC_SIP_WAKE,
		PowerGating::VNN_ACK_DSD,
		PowerGating::VNN_ACK_ASD,
		PowerGating::VNN_REQ_DSD,
		PowerGating::VNN_REQ_ASD,
		PowerGating::PMC_SIP_WAKE,
		PowerGating::FAB_PG_REQ,
		PowerGating::FAB_UG_REQ,
		PowerGating::PMC_SIP_WAKE_ALL,
		PowerGating::SET_FET_ON_MODE,
		PowerGating::RESET_FET_ON_MODE,
		PowerGating::DEASSERT_PMC_SIP_WAKE,
		PowerGating::DEASSERT_PMC_SIP_WAKE_ALL,
		PowerGating::SIP_RESTORE_NEXT_WAKE,
		PowerGating::DEASSERT_SIP_RESTORE,
		PowerGating::SIP_RESTORE,
		PowerGating::FDFX_BYPASS_ASD,
		PowerGating::FDFX_BYPASS_DSD,
		PowerGating::FDFX_OVR_ASD,
		PowerGating::FDFX_OVR_DSD,
		PowerGating::SIDE_RST_DSD,
		PowerGating::SIDE_RST_ASD,
		PowerGating::PRIM_RST_DSD,
		PowerGating::PRIM_RST_ASD			
		};
	}
	constraint source_c {
		source >= 0; source < 128;
		}


endclass : CCAgentBaseSequence	
