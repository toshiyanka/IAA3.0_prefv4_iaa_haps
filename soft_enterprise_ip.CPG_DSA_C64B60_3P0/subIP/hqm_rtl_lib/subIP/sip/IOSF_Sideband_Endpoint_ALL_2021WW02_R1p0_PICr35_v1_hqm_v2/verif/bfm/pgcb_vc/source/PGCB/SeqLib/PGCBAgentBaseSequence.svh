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
  Description     : Base sequence for PGCBAgent Agent
  
This is the base sequence for the PGCBAgent Agent from which all other 
sequences should be derived. The constraints herein should contain only those
necessary to ensure legality. No distributions. The expectations on the user are
such that the MUST extend this class to provide distributions to get "typical"/
"normal" behavior. On top of this PGCBAgent Base Sequence will be a "default"
sequence that contains a few basic distributions used by the Agent primarily for
self testing purposes, though the user is welcome to extend from the default
sequence if they so desire. Without any user intervention, the default sequence
will be what is generated if the sequencer's count is non-zero (-1, or > 0).

================================================================================
*/
class PGCBAgentBaseSequence extends ovm_sequence #(PGCBAgentSeqItem);
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	//time startTime;
	rand PowerGating::Event_e cmd;
	rand PowerGating::SIPType sipType;
	rand int source;
	rand int delay;
	rand bit waitForComplete;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================

	`ovm_sequence_utils_begin(PGCBAgentBaseSequence, PGCBAgentSequencer)
        `ovm_field_enum(PowerGating::Event_e, cmd, OVM_ALL_ON)		
        `ovm_field_enum(PowerGating::SIPType, sipType, OVM_ALL_ON)	
		`ovm_field_int(source , OVM_ALL_ON)
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
	function new(string name = "PGCBAgentBaseSequence");
		super.new(name);
	endfunction : new

	//=========================================================================
	// PUBLIC TASKS
	//=========================================================================

	/**************************************************************************
	*  @brief Body task, where constraints on sequence item is applied.
	**************************************************************************/
	virtual task body();
		`ovm_do_with(req, {req.cmd == local::cmd; req.sipType == local::sipType; req.source == local::source;req.delay == local::delay;})
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
		{
		PowerGating::SIP_PG_REQ,
		PowerGating::SIP_UG_REQ,		
		PowerGating::FAB_IDLE,
		PowerGating::FAB_IDLE_EXIT,
		PowerGating::SIP_INACC_PG,
		PowerGating::SIDE_POK_ASD,
		PowerGating::SIDE_POK_DSD,
		PowerGating::VNN_REQ_ASD,
		PowerGating::VNN_REQ_DSD,
		PowerGating::PRIM_POK_ASD,
		PowerGating::PRIM_POK_DSD
		
		};
	}
	constraint source_c {
		source >= 0; source < 128;
		}


endclass : PGCBAgentBaseSequence 
	
