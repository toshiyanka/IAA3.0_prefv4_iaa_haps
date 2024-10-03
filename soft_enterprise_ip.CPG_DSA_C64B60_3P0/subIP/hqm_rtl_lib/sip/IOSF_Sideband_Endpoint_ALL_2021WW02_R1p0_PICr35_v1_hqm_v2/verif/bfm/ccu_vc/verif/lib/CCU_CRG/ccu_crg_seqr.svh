//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// ccu_crg sequence to send clock reset operation commands
//------------------------------------------------------------------ 

`ifndef CCU_CRG_SEQR
`define CCU_CRG_SEQR

class ccu_crg_seqr extends ovm_sequencer#(ccu_crg_xaction);

   ccu_crg_cfg  i_cfg;


   extern function new(string name="", ovm_component parent = null);      
   extern function void  set_cfg (ccu_crg_cfg cfg);

   `ovm_sequencer_utils (ccu_crg_pkg::ccu_crg_seqr);

endclass : ccu_crg_seqr

function ccu_crg_seqr::new(string name="", ovm_component parent = null);
  super.new(name, parent);      
endfunction :new

function void ccu_crg_seqr::set_cfg (ccu_crg_cfg cfg);
   this.i_cfg = cfg;
endfunction : set_cfg

`endif // CCU_CRG_SEQR
