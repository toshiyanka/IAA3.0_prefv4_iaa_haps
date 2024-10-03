
/*
================================================================================
  Copyright (c) 2011 Intel Corporation, all rights reserved.

  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY COPYRIGHT LAWS AND IS 
  CONSIDERED A TRADE SECRET BELONGING TO THE INTEL CORPORATION.
================================================================================

  Author          : Dustin Bingham
  Email           : Dustin.T.Bingham@intel.com
  Phone           : 916-377-7998
  Date            : Dec 5th, 2011

================================================================================
  Description     : Default sequence for CCAgent Agent.
  
This is the default sequence for the CCAgent Agent's Sequencer. This sequence
contains the necessary distribution constraints to hit a fairly large spectrum
of "realistic" values. 

================================================================================
*/
class CCAgentDefaultSequence extends ovm_sequence;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	CCAgentBaseSequence seq;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_sequence_utils_begin(CCAgentDefaultSequence, CCAgentSequencer)
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

	/*********************************************************************
	 * Constraint for the default distribution of delay
	 *********************************************************************/


	//=========================================================================
	// PUBLIC FUNCTIONS
	//=========================================================================

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "CCAgentDefaultSequence");
		super.new(name);
	endfunction : new

	//=========================================================================
	// PUBLIC TASKS
	//=========================================================================

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
	task body();
		//`ovm_do_with(seq, {seq.cmd == PowerGating::SW_REQ_PG;})
		`ovm_do(seq)
		
				

		
	endtask


endclass : CCAgentDefaultSequence 
	
