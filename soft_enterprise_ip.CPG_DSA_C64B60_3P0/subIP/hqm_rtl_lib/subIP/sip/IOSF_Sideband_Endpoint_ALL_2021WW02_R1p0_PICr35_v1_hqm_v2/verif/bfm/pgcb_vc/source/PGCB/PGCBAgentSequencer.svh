/*
================================================================================
  Copyright (c) 2011 Intel Corporation, all rights reserved.

  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY COPYRIGHT LAWS AND IS 
  CONSIDERED A TRADE SECRET BELONGING TO THE INTEL CORPORATION.
================================================================================

  Author          : 
  Email           : 
  Phone           : 
  Date            : 

================================================================================
  Description     : One line description of this class
  
Write your wordy description here.
================================================================================
*/

class PGCBAgentSequencer extends ovm_sequencer #(PowerGatingSeqItem);

	`ovm_sequencer_utils(PGCBAgentSequencer)

	function new(string name, ovm_component parent);
		super.new(name,parent);
		`ovm_update_sequence_lib_and_item(PowerGatingSeqItem)
	endfunction : new

endclass : PGCBAgentSequencer 
