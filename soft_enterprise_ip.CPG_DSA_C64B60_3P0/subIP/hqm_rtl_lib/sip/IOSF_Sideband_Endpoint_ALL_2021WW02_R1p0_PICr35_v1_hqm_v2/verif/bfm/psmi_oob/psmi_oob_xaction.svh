//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 11-08-2011 
//-----------------------------------------------------------------
// Description:
// This file defines Out of Band transaction class
//------------------------------------------------------------------ 

`ifndef IP_PSMI_OOB_XACTION
`define IP_PSMI_OOB_XACTION

class psmi_oob_xaction extends ovm_sequence_item;

   //------------------------------------------
   // Data Members 
   //------------------------------------------
   rand psmi_oob::cmd_e  cmd;
   rand psmi_oob::sig_e  sig;
   rand psmi_oob::data_t data;
   rand psmi_oob::sig_type_e sig_type;   

   protected psmi_oob_cfg psmi_oob_config;
   
   constraint psmi_oob_allowable_dir_c;
   
   // ============================================================================
   // Standard functions 
   // ============================================================================
   extern function new (string name = "", 
                        ovm_sequencer_base sequencer = null,
                        ovm_sequence #(ovm_sequence_item,ovm_sequence_item) parent_seq = null
                       );

   // OVM Macros 
   `ovm_object_utils_begin (psmi_oob_xaction)
     `ovm_field_enum (psmi_oob::cmd_e, cmd, OVM_ALL_ON)
     `ovm_field_enum (psmi_oob::sig_e, sig, OVM_ALL_ON)
     `ovm_field_int  (data,      OVM_ALL_ON|OVM_HEX)
   `ovm_object_utils_end
     
endclass:psmi_oob_xaction
     
/**
* psmi_oob_txn Class constructor
* @param   name     OVM component hierarchal name
* @return           A new object of type psmi_oob_agent 
*/
function psmi_oob_xaction::new (string name="",
                           ovm_sequencer_base sequencer = null,
		           ovm_sequence #(ovm_sequence_item,ovm_sequence_item) parent_seq = null
                          );
  // Super constructor
  super.new(name,sequencer,parent_seq);
endfunction :new
           
constraint psmi_oob_xaction::psmi_oob_allowable_dir_c{
    sig_type inside{
    psmi_oob::IN
    };
}                              

`endif // IP_PSMI_OOB_XACTION
