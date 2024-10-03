// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2019) (2019) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_ims_isr_seq.sv
//
// Description :
//
// -----------------------------------------------------------------------------

import hqm_cfg_pkg::*;

class hqm_ims_isr_seq extends uvm_sequence;

  `uvm_object_utils(hqm_ims_isr_seq)

  slu_im_env                    im;

  uvm_reg_block                 ral;

  slu_im_isr_object             int_object;

  bit                           ims_is_ldb;
  int                           ims_int_num;
  bit [31:0]                    ims_int_data;
  bit [1:0]                     ims_ctrl; //--AI_CTRL, bit1: ims_pend; bit0: ims_mask

  hqm_pp_cq_status              i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed
  hqm_cfg                       i_hqm_cfg;

  //-------------------------
  //Function: new 
  //-------------------------
  function new(string name = "hqm_ims_isr_seq");
    super.new(name); 
  endfunction
  
  extern virtual task body();

endclass : hqm_ims_isr_seq

//-------------------------
//-- body
//-- file format: qtypecode, ppid, pool, is_rtncredonly, reord, frgnum, is_ldb_credit, is_carry_uhl, is_carry_tkn, is_multi_tkn
//-------------------------
task hqm_ims_isr_seq::body();
  uvm_object            o_tmp;
  uvm_sequencer_base    my_sequencer;
  bit [7:0]             ims_index;

  uvm_reg_block         hqm_system_csr_file;

  // -- Get IM env
  `slu_assert($cast(im,slu_im_env::get_ptr()), ("Unable to get handle to IM."))

  my_sequencer = get_sequencer();

  //--08122022  `slu_assert($cast(ral, sla_ral_env::get_ptr()), ("Unable to get RAL handle"))
  `slu_assert($cast(ral, slu_ral_db::get_regmodel()), ("Unable to get RAL handle"))

  im.get_from_test("HQM_IMS_INT", o_tmp);
  $cast(int_object, o_tmp);

  //-----------------------------
  //-- get i_hqm_cfg
  //-----------------------------
  if (!my_sequencer.get_config_object({"i_hqm_cfg",int_object.trigger_agent}, o_tmp)) begin
    uvm_report_fatal(get_full_name(), $psprintf("Unable to find i_hqm_cfg%s object",int_object.trigger_agent));
  end 

  if (!$cast(i_hqm_cfg, o_tmp)) begin
    uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
  end    

  //-----------------------------
  //-- get i_hqm_pp_cq_status
  //-----------------------------
  if (!my_sequencer.get_config_object({"i_hqm_pp_cq_status",int_object.trigger_agent}, o_tmp)) begin
    uvm_report_fatal(get_full_name(), $psprintf("Unable to find i_hqm_pp_cq_status%s object",int_object.trigger_agent));
  end 

  if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
    uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
  end 

  //-----------------------------
  //-- 
  //-----------------------------
  //`slu_assert($cast(hqm_system_csr_file,ral.find_file({"*",int_object.trigger_agent,".hqm_system_csr"})),("cast error trying to get handle to hqm_system_csr."))

  //-----------------------------
  //-- 
  //-----------------------------
  ims_is_ldb   = int_object.intr_vector[16];
  ims_int_num  = int_object.intr_vector[15:0];
  ims_int_data = int_object.intr_type;

  ims_index    = i_hqm_cfg.get_ims_idx(ims_is_ldb, ims_int_num);  //-- ims_int_num is cq_num
  `uvm_info(get_full_name(),$psprintf("%s IMS interrupt CQ %0d ISR sequence (ims_index=%0d)",ims_is_ldb ? "LDB" : "DIR", ims_int_num, ims_index),UVM_LOW)

  ims_ctrl     = i_hqm_cfg.get_ims_ctrl(ims_is_ldb, ims_int_num); //-- ims_int_num is cq_num; return ims_ctrl (bit1: ims_pend; bit 0: ims_mask)
  `uvm_info(get_full_name(),$psprintf("%s IMS interrupt CQ %0d ISR sequence (ims_index=%0d ims_ctrl=%0d)",ims_is_ldb ? "LDB" : "DIR", ims_int_num, ims_index, ims_ctrl),UVM_LOW)

  if(ims_ctrl[0]==1 && ims_ctrl[1]==0 && !$test$plusargs("HQM_IMS_ISR_BYPASS_MASK_CHECK")) 
        uvm_report_error(get_full_name(), $psprintf("%s IMS interrupt %0d ISR sequence (ims_index=%0d ims_ctrl=%0d) => IMS INT is not expected", ims_is_ldb ? "LDB" : "DIR", ims_int_num, ims_index, ims_ctrl));

  i_hqm_pp_cq_status.put_cq_int(ims_is_ldb, ims_int_num, ims_int_data);
endtask : body
