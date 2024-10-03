//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Sequence to clock reset commands
//------------------------------------------------------------------ 

`ifndef IP_PSMI_OOB_SEQ
`define IP_PSMI_OOB_SEQ

class psmi_oob_seq extends ovm_sequence;

   rand psmi_oob_xaction xaction;

   extern function new(string name="", ovm_sequencer_base sequencer = null,
		      ovm_sequence#(psmi_oob_xaction,psmi_oob_xaction) parent_seq = null);
   extern task body();

   // ============================================================================
   // APIs 
   // ============================================================================
   extern task send_xaction(input psmi_oob_seqr  psmi_oob_seqr_i,
                            input psmi_oob_xaction xaction
                            );

    `ovm_sequence_utils_begin (psmi_oob_seq, psmi_oob_seqr)
      
    `ovm_sequence_utils_end

endclass : psmi_oob_seq

function psmi_oob_seq::new(string name="", ovm_sequencer_base sequencer = null,
		      ovm_sequence#(psmi_oob_xaction,psmi_oob_xaction) parent_seq = null);
   super.new(name, sequencer, parent_seq);
   xaction = psmi_oob_xaction::type_id::create("xaction");
endfunction :new

task psmi_oob_seq::body();

   string msg;

   start_item(xaction);
  
   finish_item(xaction);
   
endtask :body

task psmi_oob_seq::send_xaction(input psmi_oob_seqr  psmi_oob_seqr_i,
                             input psmi_oob_xaction xaction
                             );
   
   string msg;            
   xaction.set_sequencer(psmi_oob_seqr_i);
  
   start_item(xaction);
 
   finish_item(xaction);                           

endtask: send_xaction

`endif // IP_PSMI_OOB_SEQ
