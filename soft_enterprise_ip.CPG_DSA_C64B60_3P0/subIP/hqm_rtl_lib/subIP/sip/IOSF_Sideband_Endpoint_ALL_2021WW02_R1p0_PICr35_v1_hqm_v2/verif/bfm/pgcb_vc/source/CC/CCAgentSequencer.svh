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

class CCAgentBCSequencer extends ovm_sequencer #(PowerGatingSeqItem) ;
	PowerGatingSeqItem x;	

	ovm_seq_item_pull_port#(PowerGatingSeqItem, PowerGatingSeqItem) seq_item_port;
	ovm_analysis_port #(PowerGatingSeqItem) ap;
	
	`ovm_component_utils(CCAgentBCSequencer)

	function new(string name, ovm_component parent);
		super.new(name,parent);
		seq_item_port = new({get_full_name(), "seq_item_port"}, this);
		ap = new({get_full_name(), "ap"}, this);
	endfunction : new

	task run();
		forever begin
			seq_item_port.get_next_item(x);
			ap.write(x);
			seq_item_port.item_done();
		end
	endtask

endclass : CCAgentBCSequencer 
class CCAgentSequencer extends ovm_sequencer #(PowerGatingSeqItem);

	`ovm_sequencer_utils(CCAgentSequencer)

	function new(string name, ovm_component parent);
		super.new(name,parent);
		`ovm_update_sequence_lib_and_item(PowerGatingSeqItem)
	endfunction : new

endclass : CCAgentSequencer 
