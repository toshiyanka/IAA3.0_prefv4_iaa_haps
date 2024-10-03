//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Sequence to send reset control commands
//------------------------------------------------------------------ 

`ifndef CCU_RST_CTRL_SEQ
`define CCU_RST_CTRL_SEQ

class ccu_rst_ctrl_seq extends ccu_crg_seq;//ovm_sequence;

   rand ccu_crg_xaction rst_xaction;

   extern function new(string name="", ovm_sequencer_base sequencer = null,
		      ovm_sequence#(ccu_crg_xaction,ccu_crg_xaction) parent_seq = null);
   extern task body();

   // ============================================================================
   // APIs 
   // ============================================================================
   extern task send_xaction(input ccu_crg_seqr  ccu_crg_seqr_i,
                            input ccu_crg_xaction rst_xaction
                            );

    `ovm_sequence_utils_begin (ccu_rst_ctrl_seq, ccu_crg_seqr)
      //`ovm_field_object(rst_xaction, OVM_ALL_ON | OVM_NOCOMPARE | OVM_NOPACK)
    `ovm_sequence_utils_end

endclass : ccu_rst_ctrl_seq


function ccu_rst_ctrl_seq::new(string name="", ovm_sequencer_base sequencer = null,
		      ovm_sequence#(ccu_crg_xaction,ccu_crg_xaction) parent_seq = null);
   super.new(name, sequencer, parent_seq);
   rst_xaction = ccu_crg_xaction::type_id::create("rst_xaction");
endfunction :new

task ccu_rst_ctrl_seq::body();

   string msg;

   `ovm_send(rst_xaction)
endtask :body

task ccu_rst_ctrl_seq::send_xaction(input ccu_crg_seqr  ccu_crg_seqr_i,
                            input ccu_crg_xaction rst_xaction
                            );
   
      string msg;
            
      rst_xaction.set_sequencer(ccu_crg_seqr_i);
      `ovm_send(rst_xaction)                             

endtask: send_xaction

`endif // ccu_rst_ctrl_SEQ
