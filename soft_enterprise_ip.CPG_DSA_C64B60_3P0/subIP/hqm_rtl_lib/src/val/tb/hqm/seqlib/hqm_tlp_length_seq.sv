//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
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
`ifndef HQM_TLP_LENGTH_SEQ__SV
`define HQM_TLP_LENGTH_SEQ__SV

import IosfPkg::*;
import iosfsbm_fbrc::*;
import iosfsbm_agent::*;

//------------------------------------------------------------------------------
// File        : hqm_tlp_length_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence sends MWr/MRd TLPs with diff lengths to HQM.
//               Control parameters as below,
//               - mode  -> UR   - ur_p_only, ur_np_only, ur_p_np, ur_np_p 
//                       -> MTLP - mtlp_mps_128B, mtlp_mps_256B, mtlp_mps_512B 
//------------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_tlp_length_stim_config extends ovm_object;

  static string stim_cfg_name = "hqm_tlp_length_stim_config";
 
  rand hqm_len_stim_t   mode                     ;  

  `ovm_object_utils_begin(hqm_tlp_length_stim_config)
    `ovm_field_enum(hqm_len_stim_t        , mode, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_tlp_length_stim_config)
    `stimulus_config_field_rand_enum(hqm_len_stim_t, mode )
  `stimulus_config_object_utils_end
 
  constraint hqm_lem_stim_c     { soft mode == ur_np_only; }

  function new(string name = "hqm_tlp_length_stim_config");
    super.new(name); 
  endfunction

endclass : hqm_tlp_length_stim_config


class hqm_tlp_length_seq extends hqm_sla_pcie_base_seq;

  `ovm_sequence_utils(hqm_tlp_length_seq, sla_sequencer)

  sla_ral_reg                        rd_reg;
  rand hqm_tlp_length_stim_config    cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_tlp_length_stim_config);

  extern                function        new(string name = "hqm_tlp_length_seq");
  extern virtual        task            body();
  extern virtual        task            issue_np_all_lengths();
  extern virtual        task            issue_p_all_lengths();
  extern virtual        task            issue_np_p(bit np_first);
  extern virtual        task            issue_mtlp();

endclass : hqm_tlp_length_seq

function hqm_tlp_length_seq::new(string name = "hqm_tlp_length_seq");
  super.new(name);
  cfg = hqm_tlp_length_stim_config::type_id::create("hqm_tlp_length_stim_config"); 
  apply_stim_config_overrides(0);  // 0 means apply overrides for non-rand variables before seq.randomize() is called

endfunction

//------------------
//-- body
//------------------
task hqm_tlp_length_seq::body();

  apply_stim_config_overrides(1); // (1) below means apply overrides for random variables after seq.randomize() is called

  rd_reg               = hqm_system_csr_regs.AW_SMON_TIMER[0];
  `ovm_info(get_full_name(), $psprintf("hqm_tlp_length_stim_config provided mode as %s", cfg.mode.name()), OVM_LOW);

  case(cfg.mode)
    ur_np_only      : issue_np_all_lengths(); 
    ur_p_only       : issue_p_all_lengths();
    ur_np_p         : issue_np_p(1'b_1);
    ur_p_np         : issue_np_p(1'b_0);
    mtlp_mps_128B,  
    mtlp_mps_256B,  
    mtlp_mps_512B   : issue_mtlp();
    default         : `ovm_error(get_full_name(), $psprintf("Incorrect hqm_len_stim_t provided !!"))
  endcase

endtask : body  

task hqm_tlp_length_seq::issue_np_all_lengths();
  IosfPkg::IosfTxn tlp;
  bit              exp_ur;
  bit [3:0]        lbe;

  Iosf::address_t iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), rd_reg);
  
  // -------------------------------------------------- //
  // -- Run a loop to traverse all TLP length values -- //
  // -------------------------------------------------- //
  for(int i=0; i<`PCIE_MAX_TLP_LENGTH; i++) begin
    exp_ur = (i==1) ? 1'b_0 : 1'b_1 ; // -- UR if (length != 1)                   -- //
    lbe    = (i==1) ? 4'h_0 : 4'h_f ; // -- LBE should be non-zero for length > 1 -- //
    send_mrd(iosf_addr, i, lbe, exp_ur);
  end

endtask : issue_np_all_lengths

task hqm_tlp_length_seq::issue_p_all_lengths();
  IosfPkg::IosfTxn tlp;
  bit              exp_ur;
  bit [3:0]        lbe;
  int              hqm_iosf_mps_length; 
  sla_ral_data_t   reg_data;

  Iosf::address_t iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), rd_reg);
  reg_data                  = get_reg_value("pcie_cap_device_control", "hqm_pf_cfg_i"); 
  hqm_iosf_mps_length       = get_mps_dw(reg_data[7:5]);
  
  // -------------------------------------------------- //
  // -- Run a loop to traverse all TLP length values -- //
  // -------------------------------------------------- //
  for(int i=1;( i<=hqm_iosf_mps_length && i<`PCIE_MAX_TLP_LENGTH ); i++) begin
    exp_ur = (i==1) ? 1'b_0 : 1'b_1 ; // -- UR if (length != 1)                   -- //
    lbe    = (i==1) ? 4'h_0 : 4'h_f ; // -- LBE should be non-zero for length > 1 -- //
    // ---------------------------------------------------------------------------------------- //
    // -- As per IOSF Spec 1.2; Section 2.2.5.2.1; 
    // -- Rule 14 -> System software must ensure that no IOSF agent can ever be targeted with
    // -- a transaction that exceeds its IMPS.
    // ---------------------------------------------------------------------------------------- //
    send_mwr(iosf_addr, i, lbe); 
  end

endtask : issue_p_all_lengths

task hqm_tlp_length_seq::issue_np_p(bit np_first);
  IosfPkg::IosfTxn tlp;
  bit              exp_ur;
  bit [3:0]        lbe;
  int              hqm_iosf_mps_length; 
  sla_ral_data_t   reg_data;
  int              np_len, p_len;

  Iosf::address_t iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), rd_reg);
  reg_data                  = get_reg_value("pcie_cap_device_control", "hqm_pf_cfg_i"); 
  hqm_iosf_mps_length       = get_mps_dw(reg_data[7:5]);
  
  `ovm_info(get_full_name(), $psprintf("Starting issue_np_p with np_first(0x%0x)",np_first), OVM_LOW)
  // --------------------------------------------------- //
  // -- Generate a random length not supported by HQM -- //
  // --------------------------------------------------- //
    np_len = $urandom_range(2,`PCIE_MAX_TLP_LENGTH); if(np_len==`PCIE_MAX_TLP_LENGTH) np_len=0;

    if(np_first) send_mrd(iosf_addr, np_len, 4'h_f, 1'b_1); 

    p_len = $urandom_range(2,hqm_iosf_mps_length);

    send_mwr(iosf_addr, p_len, 4'h_f);

    if(!np_first) send_mrd(iosf_addr, np_len, 4'h_f, 1'b_1); 

    send_tlp(get_tlp(iosf_addr, Iosf::MRd64), .compare(1), .comp_val(rd_reg.get_reset_val()));

endtask : issue_np_p

task hqm_tlp_length_seq::issue_mtlp();
  IosfPkg::IosfTxn tlp;
  int              hqm_iosf_mps_length; 
  sla_ral_data_t   reg_data;

  Iosf::address_t iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), rd_reg);
  reg_data                  = get_reg_value("pcie_cap_device_control", "hqm_pf_cfg_i"); 
  hqm_iosf_mps_length       = get_mps_dw(reg_data[7:5]);
  
  // --------------------------------------------------- //
  // -- Generate MTLP based on MPS programmed
  // --------------------------------------------------- //
    send_mwr(iosf_addr, (hqm_iosf_mps_length+1), 4'h_f);

endtask : issue_mtlp

`endif
