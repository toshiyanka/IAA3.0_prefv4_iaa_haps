//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// ccu_seq class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_ccu_seq
`define INC_ccu_seq 

/**
 * TODO: Add class description
 */
class ccu_seq extends ovm_sequence #(ccu_xaction);
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   rand ccu_xaction xaction;
   ccu_vc_cfg ccu_vc_cfg_i;
 
   //------------------------------------------
   // Constraints 
   //------------------------------------------
  
   //------------------------------------------
   // Methods 
   //------------------------------------------
   // APIs 

   // OVM Macros 
   `ovm_sequence_utils(ccu_seq,ccu_seqr)

/**
 * ccu_seq Class constructor
 * @param   name  OVM name
 * @return        A new object of type ccu_seq 
 */
function new (string name = "ccu_seq");
   // Super constructor
   super.new (name);
   xaction = ccu_xaction::type_id::create("ccu_xaction");
endfunction :new

virtual task body();
  ovm_object tmp;
  assert (m_sequencer.get_config_object("CCU_VC_CFG", tmp));
  assert ($cast(ccu_vc_cfg_i , tmp));
  xaction.set_cfg(ccu_vc_cfg_i);
  start_item(xaction);
  `ovm_info("CCU SEQ", {"\n", xaction.sprint()}, OVM_MEDIUM)
  finish_item(xaction); 
endtask

endclass  :ccu_seq

`endif //INC_ccu_seq

