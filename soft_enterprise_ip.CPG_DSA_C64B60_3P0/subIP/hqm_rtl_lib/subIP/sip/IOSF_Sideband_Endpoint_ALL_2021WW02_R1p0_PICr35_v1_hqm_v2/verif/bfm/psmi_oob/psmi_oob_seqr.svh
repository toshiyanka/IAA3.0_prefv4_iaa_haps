//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 12-08-2011 
//-----------------------------------------------------------------
// Description:
// PSMI_OOB sequencer 
//------------------------------------------------------------------ 

`ifndef IP_PSMI_OOB_SEQR
`define IP_PSMI_OOB_SEQR

class psmi_oob_seqr extends ovm_sequencer#(psmi_oob_xaction);

   psmi_oob_cfg  psmi_oob_cfg_i;

   extern function new(string name="", ovm_component parent = null);    

   `ovm_sequencer_utils (psmi_oob_seqr);

endclass : psmi_oob_seqr

function psmi_oob_seqr::new(string name="", ovm_component parent = null);
  super.new(name, parent);      
endfunction

`endif // IP_PSMI_OOB_SEQR
