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


`ifndef HQM_TLP_FBE_LBE_SEQ__SV
`define HQM_TLP_FBE_LBE_SEQ__SV

//------------------------------------------------------------------------------
// File        : hqm_tlp_fbe_lbe_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence sends CfgRd0/CfgWr0/MWr/MRd with fbe and lbe variations.
//               Control parameters as below,
//               - mode  -> cfgrd 
//                       -> cfgwr 
//                       -> mwr 
//                       -> mrd 
//------------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_tlp_fbe_lbe_stim_config extends ovm_object;

  static string stim_cfg_name = "hqm_tlp_fbe_lbe_stim_config";
 
  rand hqm_fbe_lbe_stim_t   mode                     ;  

  `ovm_object_utils_begin(hqm_tlp_fbe_lbe_stim_config)
    `ovm_field_enum(hqm_fbe_lbe_stim_t        , mode, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_tlp_fbe_lbe_stim_config)
    `stimulus_config_field_rand_enum(hqm_fbe_lbe_stim_t, mode )
  `stimulus_config_object_utils_end
 
  constraint hqm_fbe_lbe_stim_c     { soft mode == cfgrd; }

  function new(string name = "hqm_tlp_fbe_lbe_stim_config");
    super.new(name); 
  endfunction

endclass : hqm_tlp_fbe_lbe_stim_config

import IosfPkg::*;
import iosfsbm_fbrc::*;
import iosfsbm_agent::*;

//-------------------------------------------------------------------------------------------------------
class hqm_tlp_fbe_lbe_seq extends hqm_sla_pcie_base_seq;

  `ovm_sequence_utils(hqm_tlp_fbe_lbe_seq, sla_sequencer)

  sla_ral_reg pf_cfg_reg, pf_mmio_reg;

  rand hqm_tlp_fbe_lbe_stim_config    cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_tlp_fbe_lbe_stim_config);

  extern                function        new(string name = "hqm_tlp_fbe_lbe_seq");
  extern virtual        task            body();
  extern virtual        task            issue_cfgrd_with_be();
  extern virtual        task            issue_cfgwr_with_be();
  extern virtual        task            issue_mwr_with_be();
  extern virtual        task            issue_mrd_with_be();

endclass : hqm_tlp_fbe_lbe_seq

function hqm_tlp_fbe_lbe_seq::new(string name = "hqm_tlp_fbe_lbe_seq");
  super.new(name);
  cfg = hqm_tlp_fbe_lbe_stim_config::type_id::create("hqm_tlp_fbe_lbe_stim_config"); 
  apply_stim_config_overrides(0);  // 0 means apply overrides for non-rand variables before seq.randomize() is called
endfunction

//------------------
//-- body
//------------------
task hqm_tlp_fbe_lbe_seq::body();

  apply_stim_config_overrides(1); // (1) below means apply overrides for random variables after seq.randomize() is called

  `ovm_info(get_full_name(), $psprintf("hqm_tlp_fbe_lbe_stim_config provided mode as %s", cfg.mode.name()), OVM_LOW);

  pf_cfg_reg  = pf_cfg_regs.FUNC_BAR_U;
  pf_mmio_reg = hqm_system_csr_regs.AW_SMON_TIMER[0];

  case(cfg.mode)
      cfgrd: issue_cfgrd_with_be();
      cfgwr: issue_cfgwr_with_be();
      mwr  : issue_mwr_with_be();
      mrd  : issue_mrd_with_be();
  endcase

endtask : body  

task hqm_tlp_fbe_lbe_seq::issue_cfgrd_with_be();
  Iosf::address_t iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_cfg_reg);
  // --------------------------------------------------- //
  // -- Generate 
  // --------------------------------------------------- //
  send_tlp( get_tlp(iosf_addr, Iosf::CfgWr0, .i_data({~pf_cfg_reg.get_reset_val()}), .i_first_byte_en(4'b_1111)) );
  for(int i = 4'h_0; i<=4'h_f; i++) begin // -- CfgRd0 requests with (fbe==4'h_f) only are allowed for HQM -- //
    bit [31:0] be_mask = 32'h_ffff_ffff;
     send_tlp( get_tlp(iosf_addr, Iosf::CfgRd0, .i_first_byte_en(i)), .compare(1), .comp_val(be_mask & ~pf_cfg_reg.get_reset_val()) ); 
  end

endtask : issue_cfgrd_with_be

task hqm_tlp_fbe_lbe_seq::issue_cfgwr_with_be();
  Iosf::address_t iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_cfg_reg);
  // --------------------------------------------------- //
  // -- Generate 
  // --------------------------------------------------- //
  for(int i = 0; i<=4'h_f; i++) begin
    bit [31:0] be_mask = 'h_0;
     if(i[0]) begin be_mask[7:0]   = 8'h_ff; end
     if(i[1]) begin be_mask[15:8]  = 8'h_ff; end
     if(i[2]) begin be_mask[23:16] = 8'h_ff; end
     if(i[3]) begin be_mask[31:24] = 8'h_ff; end
    send_tlp( get_tlp(iosf_addr, Iosf::CfgWr0, .i_data({pf_cfg_reg.get_reset_val()} ), .i_first_byte_en(4'b_1111)) );
    send_tlp( get_tlp(iosf_addr, Iosf::CfgRd0, .i_first_byte_en(4'b_1111)), .compare(1), .comp_val(pf_cfg_reg.get_reset_val()) ); 
    send_tlp( get_tlp(iosf_addr, Iosf::CfgWr0, .i_data({~pf_cfg_reg.get_reset_val()}), .i_first_byte_en(i)) );
    send_tlp( get_tlp(iosf_addr, Iosf::CfgRd0, .i_first_byte_en(4'b_1111)), .compare(1), .comp_val(be_mask & ~pf_cfg_reg.get_reset_val()) ); 
  end

endtask : issue_cfgwr_with_be

task hqm_tlp_fbe_lbe_seq::issue_mwr_with_be();
  Iosf::address_t iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_mmio_reg);
  // ----------------------------------------------------------------------------------- //
  // -- As per HQM Iosf Access Handling sheet, MWr with (fbe != f) is dropped !
  // -- https://sharepoint.ger.ith.intel.com/sites/HQM/HQM%20Classified/MAS/HQM%20IOSF%20Access%20Handling.xlsx 
  // ----------------------------------------------------------------------------------- //
  for(int i = 0; i<=4'h_f; i++) begin
    send_tlp( get_tlp(iosf_addr, Iosf::MWr64, .i_data({~pf_mmio_reg.get_reset_val()}), .i_first_byte_en(i)) );
    if(i==4'h_f) begin send_tlp( get_tlp(iosf_addr, Iosf::MRd64), .compare(1), .comp_val(~pf_mmio_reg.get_reset_val())); end
    else         begin send_tlp( get_tlp(iosf_addr, Iosf::MRd64), .compare(1), .comp_val(pf_mmio_reg.get_reset_val()) ); end
  end
  for(int i = 0; i<=4'h_f; i++) begin
    send_tlp( get_tlp(iosf_addr, Iosf::MWr64, .i_data({pf_mmio_reg.get_reset_val()}), .i_first_byte_en(i)) );
    if(i==4'h_f) begin send_tlp( get_tlp(iosf_addr, Iosf::MRd64), .compare(1), .comp_val(pf_mmio_reg.get_reset_val()) ); end
    else         begin send_tlp( get_tlp(iosf_addr, Iosf::MRd64), .compare(1), .comp_val(~pf_mmio_reg.get_reset_val())); end
  end

endtask : issue_mwr_with_be

task hqm_tlp_fbe_lbe_seq::issue_mrd_with_be();
  Iosf::address_t iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_mmio_reg);
  // ----------------------------------------------------------------------------------- //
  // -- As per HQM Iosf Access Handling sheet, MRd with (fbe != f) is UR
  // -- https://sharepoint.ger.ith.intel.com/sites/HQM/HQM%20Classified/MAS/HQM%20IOSF%20Access%20Handling.xlsx 
  // ----------------------------------------------------------------------------------- //
  for(int i = 0; i<=4'h_f; i++) begin
     send_tlp( get_tlp(iosf_addr, Iosf::MRd64, .i_first_byte_en(i)), .ur(i!=4'h_f) );
  end
endtask : issue_mrd_with_be

`endif
