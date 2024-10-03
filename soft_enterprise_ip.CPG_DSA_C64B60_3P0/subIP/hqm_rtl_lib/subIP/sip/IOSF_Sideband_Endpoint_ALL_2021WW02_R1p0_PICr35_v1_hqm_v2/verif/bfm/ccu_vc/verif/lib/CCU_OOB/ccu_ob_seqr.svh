//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 12-08-2011 
//-----------------------------------------------------------------
// Description:
// OB sequencer 
//------------------------------------------------------------------ 

`ifndef IP_OB_SEQR
`define IP_OB_SEQR

class ccu_ob_seqr extends ovm_sequencer#(ccu_ob_xaction);

   ccu_ob_cfg  ccu_ob_cfg_i;

   extern function new(string name="", ovm_component parent = null);    

   `ovm_sequencer_utils (ccu_ob_seqr);

endclass : ccu_ob_seqr

function ccu_ob_seqr::new(string name="", ovm_component parent = null);
  super.new(name, parent);      
endfunction

`endif // IP_OB_SEQR
