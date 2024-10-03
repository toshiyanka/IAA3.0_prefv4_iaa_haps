// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
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
// File   : hqm_iosf_sb_interleaving_flit_seq.sv
// Author : rsshekha
//
// Description :
//
//   Sequence that will cause a base iosf seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_iosf_sb_interleaving_flit_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_iosf_sb_interleaving_flit_seq_stim_config";

  `ovm_object_utils_begin(hqm_iosf_sb_interleaving_flit_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_iosf_sb_interleaving_flit_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_iosf_sb_interleaving_flit_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_iosf_sb_interleaving_flit_seq_stim_config

class hqm_iosf_sb_interleaving_flit_seq extends hqm_sla_pcie_base_seq;
  `ovm_object_utils(hqm_iosf_sb_interleaving_flit_seq)
  Iosf::data_t     wr_data[$] = {}; 
  sla_ral_reg pf_cfg_reg, pf_mmio_reg;
  Iosf::address_t iosf_addr_cfg, iosf_addr_mem, iosf_addr_cfg_sb, iosf_addr_mem_sb; 

  rand hqm_iosf_sb_interleaving_flit_seq_stim_config        cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_iosf_sb_interleaving_flit_seq_stim_config);

  function new(string name = "hqm_iosf_sb_interleaving_flit_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name); 

    cfg = hqm_iosf_sb_interleaving_flit_seq_stim_config::type_id::create("hqm_pwr_smoke_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

  extern virtual task generate_traffic();

endclass : hqm_iosf_sb_interleaving_flit_seq

task hqm_iosf_sb_interleaving_flit_seq::generate_traffic(); 
  pf_cfg_reg  = pf_cfg_regs.CACHE_LINE_SIZE;
  iosf_addr_cfg = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_cfg_reg);
  pf_cfg_reg  = pf_cfg_regs.INT_LINE;
  iosf_addr_cfg_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_cfg_reg);
  pf_mmio_reg = hqm_system_csr_regs.AW_SMON_TIMER[0];
  iosf_addr_mem = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_mmio_reg);
  iosf_addr_mem_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_mmio_reg);
  fork 
  begin 
     for(int i = 0; i<=100; i++) begin
        //generating np cfg wr with random data and validating with cfg rd. 
        //generating p mem wr with random data and some np mem reads. since p and np have different ordering priority so not comparing the data. 
        wr_data.push_back($urandom_range(0,255));
        send_tlp( get_tlp(iosf_addr_cfg, Iosf::CfgWr0, .i_data(wr_data), .i_first_byte_en(4'b_1111)) );
        send_tlp( get_tlp(iosf_addr_cfg, Iosf::CfgRd0, .i_first_byte_en(4'b_1111)), .compare(1), .comp_val(wr_data[0]));
        send_tlp( get_tlp(iosf_addr_mem, Iosf::MWr64, .i_data(wr_data), .i_first_byte_en(4'b_1111)) );
        send_tlp( get_tlp(iosf_addr_mem, Iosf::MRd64));
        wr_data.delete(); //empty the queue
     end
  end 
  begin 
     for(int i = 0; i<=100; i++) begin
       automatic hqm_iosf_sb_cfg_rd_seq   sb_cfg_rd_seq; 
       automatic hqm_iosf_sb_cfg_wr_seq   sb_cfg_wr_seq; 
       automatic hqm_iosf_sb_mem_rd_seq   sb_mem_rd_seq; 
       automatic hqm_iosf_sb_mem_wr_seq   sb_mem_wr_seq;
       automatic Iosf::data_t wr_data_sb;
        fork
            wr_data_sb = $urandom_range(0, 255); 
           `ovm_do_with(sb_cfg_wr_seq, {addr == iosf_addr_cfg_sb;wdata == wr_data_sb;exp_cplstatus == 2'b00;exp_rsp == 1;})
           `ovm_do_with(sb_cfg_rd_seq, {addr == iosf_addr_cfg_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata ==  wr_data_sb;})
           `ovm_do_with(sb_mem_wr_seq, {addr == iosf_addr_mem_sb;wdata == wr_data_sb;})
           `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == 1;})
        join_none
     end
  end 
  join
endtask : generate_traffic 

task hqm_iosf_sb_interleaving_flit_seq::body();
  
  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_interleaving_flit_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  
 `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

 hqm_env.iosf_svc.set_crd_update_delay(10);

 `ovm_info(get_full_name(),$sformatf("\n executing steps of hqm_iosf_sb_interleaving_flit_seq \n"),OVM_LOW)
 generate_traffic();
 `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_interleaving_flit_seq ended \n"),OVM_LOW)
     
endtask : body
