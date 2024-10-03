

class DESIPPMCWakeAllSequence extends ovm_sequence;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	CCAgentBaseSequence seq;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_sequence_utils_begin(DESIPPMCWakeAllSequence, CCAgentSequencer)
	`ovm_sequence_utils_end

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "DESIPPMCWakeAllSequence");
		super.new(name);
	endfunction : new

	task body();
		`ovm_do_with(seq, {seq.cmd == PowerGating::DEASSERT_PMC_SIP_WAKE_ALL; seq.delay == 3; seq.waitForComplete == 1;})
	endtask


endclass : DESIPPMCWakeAllSequence 
	
