// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
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
// File   : pp_cq_model_seq.sv
//
// Description :
//
// -----------------------------------------------------------------------------
`ifndef PP_CQ_MODEL_SEQ__SV
`define PP_CQ_MODEL_SEQ__SV

import hcw_sequences_pkg::*;
import hqm_tb_cfg_pkg::*;

class pp_cq_model_seq extends hqm_pp_cq_base_seq;

  `ovm_sequence_utils(pp_cq_model_seq, sla_sequencer)
  rand int vpp;
  int is_enabled;
  string name;

  function new(string name = "pp_cq_model_seq");
    super.new(name);
    this.name = name;
    is_enabled = 1;
  endfunction: new;

  task body();
  ovm_object  o_tmp;

`ovm_info("pp_cq_model_seq", $psprintf("For <%s>: cq_addr <0x%016x>", this.name, cq_addr), OVM_LOW)

  //-----------------------------
  //-- get i_hqm_pp_cq_status
  //-----------------------------
  if(is_enabled)begin
     if (!p_sequencer.get_config_object("i_hqm_pp_cq_status", o_tmp)) begin
       ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
     end

     if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
       ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
     end

     fork
       pend_cq_token_return.run();
     join_none

     fork
       pend_comp_return.run();
     join_none

     `sla_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

     cq_buffer_init();

     fork
       return_delay_monitor(tok_return_delay_q, tok_return_delay_mode, total_tok_return_count, tok_return_delay);
       return_delay_monitor(comp_return_delay_q, comp_return_delay_mode, total_comp_return_count, comp_return_delay);
       cq_buffer_monitor();
       gen_completions();
       gen_renq_frag();
     join_none
    
     foreach (queue_list[i]) begin
       fork
         automatic int j = i;
         gen_queue_list(j);
       join_none
     end

  end

  endtask: body;

endclass: pp_cq_model_seq
`endif
