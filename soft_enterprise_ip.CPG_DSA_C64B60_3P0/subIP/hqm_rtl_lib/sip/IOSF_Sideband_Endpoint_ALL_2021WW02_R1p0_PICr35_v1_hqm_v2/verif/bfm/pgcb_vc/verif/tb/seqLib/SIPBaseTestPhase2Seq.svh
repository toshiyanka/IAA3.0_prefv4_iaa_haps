class SIPBaseTestPhase2Seq extends ovm_sequence;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	CCAgentBaseSequence seq;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_sequence_utils_begin(SIPPMCWakeSequence, CCAgentSequencer)
	`ovm_sequence_utils_end

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "SIPPMCWakeSequence");
		super.new(name);
	endfunction : new

	task body();
	   `ovm_create(seq);
		seq.sourceName = "KVM";
		`ovm_rand_send_with(seq, {cmd == PowerGating::PMC_SIP_WAKE;waitForComplete == 1;})

		/* user would have to now create the seq, set the name and then do an `ovm_rand_send.
		To avaoid that, i am providing the user with a static method called getSIPPGCBIndex that they can call 
		*/
		`ovm_do_with(seq, {source == PowerGatingConfig::getSIPPGCBIndex("SUS");cmd == PowerGating::PMC_SIP_WAKE;waitForComplete == 1;})
	endtask


endclass : SIPBaseTestPhase2Seq 
