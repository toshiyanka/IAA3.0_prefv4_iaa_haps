//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Sequence to clock reset commands
//------------------------------------------------------------------ 

`ifndef CCU_CRG_SEQ
`define CCU_CRG_SEQ

class ccu_crg_seq extends ovm_sequence;

   rand ccu_crg_xaction xaction;

   extern function new(string name="", ovm_sequencer_base sequencer = null,
		      ovm_sequence#(ccu_crg_xaction,ccu_crg_xaction) parent_seq = null);
   extern task body();

   // ============================================================================
   // APIs 
   // ============================================================================
   extern task send_xaction(input ccu_crg_seqr  ccu_crg_seqr_i,
                            input ccu_crg_xaction xaction
                            );

    `ovm_sequence_utils_begin (ccu_crg_seq, ccu_crg_seqr)
      //`ovm_field_object(xaction, OVM_ALL_ON | OVM_NOCOMPARE | OVM_NOPACK)
    `ovm_sequence_utils_end

endclass : ccu_crg_seq


function ccu_crg_seq::new(string name="", ovm_sequencer_base sequencer = null,
		      ovm_sequence#(ccu_crg_xaction,ccu_crg_xaction) parent_seq = null);
   super.new(name, sequencer, parent_seq);
   xaction = ccu_crg_xaction::type_id::create("xaction");
endfunction :new

task ccu_crg_seq::body();

   string msg;

   `ovm_send(xaction)
endtask :body

task ccu_crg_seq::send_xaction(input ccu_crg_seqr  ccu_crg_seqr_i,
                            input ccu_crg_xaction xaction
                            );
   
      string msg;
            
      xaction.set_sequencer(ccu_crg_seqr_i);
      `ovm_send(xaction)                             

endtask: send_xaction

`endif // CCU_CRG_SEQ
