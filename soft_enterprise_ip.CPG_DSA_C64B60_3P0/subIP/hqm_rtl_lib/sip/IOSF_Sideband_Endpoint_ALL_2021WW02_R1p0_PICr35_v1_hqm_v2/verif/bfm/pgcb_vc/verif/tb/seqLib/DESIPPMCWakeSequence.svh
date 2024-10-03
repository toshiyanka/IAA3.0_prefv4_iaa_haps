

class DESIPPMCWakeSequence extends ovm_sequence;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	CCAgentBaseSequence seq;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_sequence_utils_begin(DESIPPMCWakeSequence, CCAgentSequencer)
	`ovm_sequence_utils_end

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "DESIPPMCWakeSequence");
		super.new(name);
	endfunction : new

	task body();
		`ovm_do_with(seq, {seq.cmd == PowerGating::DEASSERT_PMC_SIP_WAKE; seq.source == 0;seq.delay == 3;})
	endtask


endclass : DESIPPMCWakeSequence 
	
