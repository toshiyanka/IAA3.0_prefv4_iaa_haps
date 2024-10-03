

class SIPRandHWSaveReqSequence extends ovm_sequence;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	PGCBAgentBaseSequence seq;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_sequence_utils_begin(SIPRandHWSaveReqSequence, PGCBAgentSequencer)
	`ovm_sequence_utils_end

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "SIPHWSaveReqSequence");
		super.new(name);
	endfunction : new

	task body();
		`ovm_do_with(seq, {seq.cmd == PowerGating::SIP_PG_REQ; seq.source inside {0,2};seq.delay == 0;})
	endtask


endclass : SIPRandHWSaveReqSequence 
	
