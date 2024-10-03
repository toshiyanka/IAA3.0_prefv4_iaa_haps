

class FETONMode extends ovm_sequence;

	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	CCAgentBaseSequence seq;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_sequence_utils_begin(FETONMode, CCAgentSequencer)
	`ovm_sequence_utils_end

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "FETONMode");
		super.new(name);
	endfunction : new

	task body();
		`ovm_do_with(seq, {seq.cmd == PowerGating::SET_FET_ON_MODE; seq.source == 0;})

	endtask


endclass : FETONMode 
	
