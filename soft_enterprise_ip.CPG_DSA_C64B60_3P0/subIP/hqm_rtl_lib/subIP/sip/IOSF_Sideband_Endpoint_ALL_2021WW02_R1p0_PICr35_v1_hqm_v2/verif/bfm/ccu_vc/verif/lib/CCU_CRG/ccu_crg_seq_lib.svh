//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 30-02-2011 
//-----------------------------------------------------------------
// Description:
// ccu_crg sequences which can be directly used by users
//------------------------------------------------------------------ 

`ifndef CCU_CRG_SEQ_LIB
`define CCU_CRG_SEQ_LIB

//////////////////////////////////////////////////////////
//This sequence ungates all clocks
//////////////////////////////////////////////////////////
class ccu_crg_ungate_all_clk_seq extends ccu_clk_ctrl_seq;

   ccu_crg_xaction xaction_i;

   extern function new(string name="");      
   extern task body();
   `ovm_sequence_utils(ccu_crg_ungate_all_clk_seq, ccu_crg_seqr)

endclass : ccu_crg_ungate_all_clk_seq

function ccu_crg_ungate_all_clk_seq::new(string name="");
  super.new(name);      
endfunction :new

task ccu_crg_ungate_all_clk_seq::body();

   string msg;

   `ovm_create(xaction_i)
   xaction_i.set_sequencer(get_sequencer());
   xaction_i.set_cfg(p_sequencer.i_cfg);
   if ( !(xaction_i.randomize() with {
         xaction_i.ccu_crg_op_i == ccu_crg::OP_CLK_UNGATE_ALL;

      })) begin
         `ovm_error(get_type_name(), "ccu_crg_xaction generation error")
         return;
      end
      `ovm_send(xaction_i)
endtask :body


//////////////////////////////////////////////////////////
//this sequence gates all clocks
//////////////////////////////////////////////////////////
class ccu_crg_gate_all_clk_seq extends ccu_clk_ctrl_seq;

   ccu_crg_xaction xaction_i;

   extern function new(string name="");      
   extern task body();
   `ovm_sequence_utils(ccu_crg_gate_all_clk_seq, ccu_crg_seqr)

endclass : ccu_crg_gate_all_clk_seq

function ccu_crg_gate_all_clk_seq::new(string name="");
  super.new(name);      
endfunction :new

task ccu_crg_gate_all_clk_seq::body();

   string msg;

   `ovm_create(xaction_i)
   xaction_i.set_sequencer(get_sequencer());
   xaction_i.set_cfg(p_sequencer.i_cfg);
   if ( !(xaction_i.randomize() with {
         xaction_i.ccu_crg_op_i == ccu_crg::OP_CLK_GATE_ALL;

      })) begin
         `ovm_error(get_type_name(), "ccu_crg_xaction generation error")
         return;
      end
      `ovm_send(xaction_i)
endtask :body

//////////////////////////////////////////////////////////
//this sequence sends OP_RST_ASSERT_ALL command to driver
//////////////////////////////////////////////////////////
class ccu_crg_assert_all_rst_seq extends ccu_rst_ctrl_seq;

   ccu_crg_xaction xaction_i;

   extern function new(string name="");      
   extern task body();
   `ovm_sequence_utils(ccu_crg_assert_all_rst_seq, ccu_crg_seqr)

endclass : ccu_crg_assert_all_rst_seq

function ccu_crg_assert_all_rst_seq::new(string name="");
  super.new(name);      
endfunction :new

task ccu_crg_assert_all_rst_seq::body();

   string msg;

   `ovm_create(xaction_i)
   xaction_i.set_sequencer(get_sequencer());
   xaction_i.set_cfg(p_sequencer.i_cfg);
   if ( !(xaction_i.randomize() with {
         xaction_i.ccu_crg_op_i == ccu_crg::OP_RST_ASSERT_ALL;

      })) begin
         `ovm_error(get_type_name(), "ccu_crg_xaction generation error")
         return;
      end
      `ovm_send(xaction_i)
endtask :body


//////////////////////////////////////////////////////////
//this sequence sends OP_RST_DEASSERT_ALL command to driver
//////////////////////////////////////////////////////////
class ccu_crg_deassert_all_rst_seq extends ccu_rst_ctrl_seq;

   ccu_crg_xaction xaction_i;

   extern function new(string name="");      
   extern task body();
   `ovm_sequence_utils(ccu_crg_deassert_all_rst_seq, ccu_crg_seqr)

endclass : ccu_crg_deassert_all_rst_seq

function ccu_crg_deassert_all_rst_seq::new(string name="");
  super.new(name);      
endfunction :new

task ccu_crg_deassert_all_rst_seq::body();

   string msg;

   `ovm_create(xaction_i)
   xaction_i.set_sequencer(get_sequencer());
   xaction_i.set_cfg(p_sequencer.i_cfg);
   if ( !(xaction_i.randomize() with {
         xaction_i.ccu_crg_op_i == ccu_crg::OP_RST_DEASSERT_ALL;

      })) begin
         `ovm_error(get_type_name(), "ccu_crg_xaction generation error")
         return;
      end
      `ovm_send(xaction_i)
endtask :body

`endif // CCU_CRG_SEQ_LIB
