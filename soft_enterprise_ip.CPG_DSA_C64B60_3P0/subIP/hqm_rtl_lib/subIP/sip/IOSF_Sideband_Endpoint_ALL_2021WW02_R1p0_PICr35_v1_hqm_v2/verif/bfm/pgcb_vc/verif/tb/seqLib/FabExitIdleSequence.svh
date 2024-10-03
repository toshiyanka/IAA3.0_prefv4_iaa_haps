class FabExitIdleSequence extends ovm_sequence;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	PGCBAgentBaseSequence seq;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_sequence_utils_begin(FabExitIdleSequence, PGCBAgentSequencer)
	`ovm_sequence_utils_end

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "FabExitIdleSequence");
		super.new(name);
	endfunction : new

	task body();
		`ovm_do_with(seq, {seq.cmd == PowerGating::FAB_IDLE_EXIT; seq.source == 1;seq.delay == 0;})
	endtask


endclass : FabExitIdleSequence 
	
