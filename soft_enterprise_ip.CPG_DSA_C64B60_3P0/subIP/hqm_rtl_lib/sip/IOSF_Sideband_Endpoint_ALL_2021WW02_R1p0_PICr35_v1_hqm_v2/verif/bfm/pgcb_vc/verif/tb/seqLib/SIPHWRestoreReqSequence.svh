

class SIPHWRestoreReqSequence extends ovm_sequence;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	PGCBAgentBaseSequence seq;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_sequence_utils_begin(SIPHWRestoreReqSequence, PGCBAgentSequencer)
	`ovm_sequence_utils_end

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "SIPHWRestoreReqSequence");
		super.new(name);
	endfunction : new

	task body();
		`ovm_do_with(seq, {seq.cmd == PowerGating::SIP_SAVE_ABORT_REQ; seq.source == 0;seq.delay == 3;})
	endtask


endclass : SIPHWRestoreReqSequence 
	
