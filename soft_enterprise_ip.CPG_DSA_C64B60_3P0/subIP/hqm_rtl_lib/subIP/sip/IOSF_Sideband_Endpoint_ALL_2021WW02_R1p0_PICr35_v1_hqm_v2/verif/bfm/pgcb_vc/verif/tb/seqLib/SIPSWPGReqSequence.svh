

class SIPSWPGReqSequence extends ovm_sequence;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	CCAgentBaseSequence seq;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_sequence_utils_begin(SIPSWPGReqSequence, CCAgentSequencer)
	`ovm_sequence_utils_end

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "SIPSWPGReqSequence");
		super.new(name);
	endfunction : new

	task body();
		`ovm_do_with(seq, {seq.cmd == PowerGating::SW_PG_REQ; seq.source == 1;seq.delay == 3;})

	endtask


endclass : SIPSWPGReqSequence 
	
