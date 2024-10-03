class SIPHWUGReqSequence extends ovm_sequence;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	PGCBAgentBaseSequence seq;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_sequence_utils_begin(SIPHWUGReqSequence, PGCBAgentSequencer)
	`ovm_sequence_utils_end

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "SIPHWUGReqSequence");
		super.new(name);
	endfunction : new

	task body();
		`ovm_do_with(seq, {seq.cmd == PowerGating::SIP_UG_REQ; seq.source == 0;seq.delay == 0;waitForComplete == 1;})
	endtask


endclass : SIPHWUGReqSequence 
	
