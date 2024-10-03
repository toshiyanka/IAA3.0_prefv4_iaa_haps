//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2019 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
//-- Test
//-----------------------------------------------------------------------------------------------------

import hqm_cfg_pkg::*;
import hqm_tb_cfg_pkg::*;

class hqm_int_mon extends uvm_component;

  `uvm_component_utils(hqm_int_mon)

  string        inst_suffix = "";

  uvm_reg_block ral;

  slu_im_env    im;

  hqm_tb_cfg    i_hqm_cfg;

  function new(string name = "hqm_int_mon", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void set_inst_suffix(string new_inst_suffix);
    inst_suffix = new_inst_suffix;
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    // -- Get RAL env
    //--08122022  `slu_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
    `slu_assert($cast(ral, slu_ral_db::get_regmodel()), ("Unable to get handle to RAL."))

    // -- Get IM env
    `slu_assert($cast(im,slu_im_env::get_ptr()), ("Unable to get handle to IM."))
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
virtual function void connect_phase(uvm_phase phase); 
    uvm_object o_tmp;

    super.connect_phase(phase);

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!uvm_config_object::get(this, "",{"i_hqm_cfg",inst_suffix}, o_tmp)) begin
      uvm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end 

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      uvm_report_fatal(get_full_name(), $psprintf("cast type not hqm_tb_cfg"));
    end 

  endfunction

  virtual task run_phase (uvm_phase phase);
    `uvm_error(get_full_name(), "hqm_int_mon class must be extended to support desired interrupt monitoring interface")
  endtask

  virtual task interrupt(bit [15:0] rid, int int_num, bit [31:0] int_data);
    `uvm_error(get_full_name(), "hqm_int_mon class must be extended to support desired interrupt monitoring interface")
  endtask

endclass
