//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 11-08-2011 
//-----------------------------------------------------------------
// Description:
// This file defines Out of Band transaction class
//------------------------------------------------------------------ 

`ifndef IP_OB_XACTION
`define IP_OB_XACTION

class ccu_ob_xaction extends ovm_sequence_item;

   //------------------------------------------
   // Data Members 
   //------------------------------------------
   rand ccu_ob::cmd_e  cmd;
   rand ccu_ob::sig_e  sig;
   rand ccu_ob::data_t data;
   rand ccu_ob::sig_type_e sig_type;
   rand int  slice_num;
   
   protected ccu_ob_cfg ccu_ob_config;
   
   constraint ccu_ob_allowable_dir_c;
   
   // ============================================================================
   // Standard functions 
   // ============================================================================
   extern function new (string name = "", 
                        ovm_sequencer_base sequencer = null,
                        ovm_sequence #(ovm_sequence_item,ovm_sequence_item) parent_seq = null
                       );
   extern function void post_randomize();
   
   // OVM Macros 
   `ovm_object_utils_begin (ccu_ob_xaction)
     `ovm_field_enum (ccu_ob::cmd_e, cmd, OVM_ALL_ON)
     `ovm_field_enum (ccu_ob::sig_e, sig, OVM_ALL_ON)
     `ovm_field_int  (data,      OVM_ALL_ON|OVM_HEX)
	 `ovm_field_int  (slice_num, OVM_ALL_ON|OVM_HEX)
   `ovm_object_utils_end
     
endclass:ccu_ob_xaction
     
/**
* ccu_ob_txn Class constructor
* @param   name     OVM component hierarchal name
* @return           A new object of type ccu_ob_agent 
*/
function ccu_ob_xaction::new (string name="",
                           ovm_sequencer_base sequencer = null,
		           ovm_sequence #(ovm_sequence_item,ovm_sequence_item) parent_seq = null
                          );
  // Super constructor
  super.new(name,sequencer,parent_seq);
endfunction :new
           
constraint ccu_ob_xaction::ccu_ob_allowable_dir_c{
    sig_type inside{
    ccu_ob::IN
    };
}

function void ccu_ob_xaction::post_randomize();
//  if (! std::randomize(data) with {data >= 0 && data < 2**(ccu_ob::sig_prop[sig].width);})
//    `ovm_error("DataRandError", "Failed to randomize data field in the ccu_ob_xaction")  
endfunction 
`endif // IP_OB_XACTION
