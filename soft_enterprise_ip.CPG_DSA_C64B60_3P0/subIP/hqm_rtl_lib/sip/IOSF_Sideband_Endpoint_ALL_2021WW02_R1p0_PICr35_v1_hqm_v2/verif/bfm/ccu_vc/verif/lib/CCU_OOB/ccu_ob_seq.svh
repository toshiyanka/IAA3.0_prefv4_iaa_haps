//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Sequence to clock reset commands
//------------------------------------------------------------------ 

`ifndef IP_OB_SEQ
`define IP_OB_SEQ

class ccu_ob_seq extends ovm_sequence;

   rand ccu_ob_xaction xaction;

   extern function new(string name="", ovm_sequencer_base sequencer = null,
		      ovm_sequence#(ccu_ob_xaction,ccu_ob_xaction) parent_seq = null);
   extern task body();

   // ============================================================================
   // APIs 
   // ============================================================================
   extern task send_xaction(input ccu_ob_seqr  ccu_ob_seqr_i,
                            input ccu_ob_xaction xaction
                            );

    `ovm_sequence_utils_begin (ccu_ob_seq, ccu_ob_seqr)
      
    `ovm_sequence_utils_end

endclass : ccu_ob_seq

function ccu_ob_seq::new(string name="", ovm_sequencer_base sequencer = null,
		      ovm_sequence#(ccu_ob_xaction,ccu_ob_xaction) parent_seq = null);
   super.new(name, sequencer, parent_seq);
   xaction = ccu_ob_xaction::type_id::create("xaction");
endfunction :new

task ccu_ob_seq::body();

   string msg;

   start_item(xaction);
  
   finish_item(xaction);
   
endtask :body

task ccu_ob_seq::send_xaction(input ccu_ob_seqr  ccu_ob_seqr_i,
                             input ccu_ob_xaction xaction
                             );
   
   string msg;            
   xaction.set_sequencer(ccu_ob_seqr_i);
  
   start_item(xaction);
 
   finish_item(xaction);                           

endtask: send_xaction

`endif // IP_OB_SEQ
