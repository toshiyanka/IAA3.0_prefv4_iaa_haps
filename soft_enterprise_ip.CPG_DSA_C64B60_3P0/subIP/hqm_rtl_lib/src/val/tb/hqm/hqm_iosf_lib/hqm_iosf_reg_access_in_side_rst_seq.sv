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
// File   : hqm_iosf_reg_access_in_side_rst_seq.sv
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

class hqm_iosf_reg_access_in_side_rst_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_iosf_reg_access_in_side_rst_seq_stim_config";

  `ovm_object_utils_begin(hqm_iosf_reg_access_in_side_rst_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_iosf_reg_access_in_side_rst_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_iosf_reg_access_in_side_rst_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_iosf_reg_access_in_side_rst_seq_stim_config

class hqm_iosf_reg_access_in_side_rst_seq extends hqm_sla_pcie_base_seq;
  `ovm_object_utils(hqm_iosf_reg_access_in_side_rst_seq)

  Iosf::data_t     wr_data[$] = {}, wr_data_sb[$] = {};
  sla_ral_reg pf_cfg_reg, pf_mmio_reg;
  Iosf::address_t iosf_addr_cfg, iosf_addr_mem, iosf_addr_cfg_sb, iosf_addr_mem_sb; 

  hqm_integ_pkg::HqmIntegEnv agent_env; 
  ovm_event_pool  global_pool;
  ovm_event       hqm_ip_ready;
  ovm_event       hqm_config_acks;
  ovm_event       hqm_fuse_download_req;
  sla_fuse_env    fuse_env;

  hqm_iosf_sb_cfg_rd_seq                   sb_cfg_rd_seq; 
  hqm_iosf_sb_cfg_wr_seq                   sb_cfg_wr_seq; 
  hqm_iosf_sb_mem_rd_seq                   sb_mem_rd_seq; 
  hqm_iosf_sb_mem_wr_seq                   sb_mem_wr_seq; 
  hqm_reset_unit_sequence                  powergood_deassert_seq;
  hqm_reset_unit_sequence                  reset_deassert_part1_seq;
  hqm_reset_unit_sequence                  reset_deassert_part2_seq;
  hqm_reset_unit_sequence       ip_block_fp_deassert_seq;
  hqm_reset_unit_sequence                  ip_ready_seq;
  hqm_fuse_bypass_seq                      fbp_seq;
  hqm_reset_unit_sequence                  lcp_reset_seq;

  rand hqm_iosf_reg_access_in_side_rst_seq_stim_config        cfg;

  bit [15:0]    default_early_fuses;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_iosf_reg_access_in_side_rst_seq_stim_config);

  function new(string name = "hqm_iosf_reg_access_in_side_rst_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name); 

    cfg = hqm_iosf_reg_access_in_side_rst_seq_stim_config::type_id::create("hqm_pwr_smoke_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_ip_ready = global_pool.get("hqm_ip_ready");
    hqm_config_acks = global_pool.get("hqm_config_acks");
    hqm_fuse_download_req = global_pool.get("hqm_fuse_download_req");

    default_early_fuses=0;
    if ($value$plusargs("HQM_TB_FUSE_VALUES=%h", default_early_fuses)) begin
      `ovm_info(get_full_name(),$psprintf("HQM_TB_FUSE_VALUES default value to drive early_fuses = 0x%0x", default_early_fuses),OVM_LOW)
    end
  endfunction

  extern virtual task body();

endclass : hqm_iosf_reg_access_in_side_rst_seq

task hqm_iosf_reg_access_in_side_rst_seq::body();
    bit [31:0]    cfg_master_ctl_wr_data;
    int           clk_switch_control_en=0;
    int           default_ip_block_fp;
    int           default_ip_ready;   
  
  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_reg_access_in_side_rst_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  
 `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  //CFG_MASTER_CTL             
  //RSVZ0[31:17]                            =15'h7FFF                - No Effect
  //OVERRIDE_CLK_GATE[16:16]                =1'h0;                   - DEFAULT
  //PWRGATE_PMC_WAKE[15:15]                 =1'h0;                   - DEFAULT
  //RSVZ1[14:12]                            =3'h7;                   - No Effect
  //OVERRIDE_CLK_SWITCH_CONTROL[11:9]       =3'h7;                   - Force HQM Clk to 1X frequency
  //OVERRIDE_PMSM_PGCB_REQ_B[8:7]           =2'h2;                   - No Effect
  //OVERRIDE_PM_CFG_CONTROL[6:4]            =3'h2;                   - No Effect
  //OVERRIDE_FET_EN_B[3:2]                  =2'h2;                   - No Effect
  //OVERRIDE_PMC_PGCB_ACK_B[1:0]            =2'h2;                   - No Effect

  if($test$plusargs("HQM_SURVIVABILITY_GPSB_ONLY"))
      cfg_master_ctl_wr_data = 32'hFFFE_7F2A;//32'h00000000;
  else
      cfg_master_ctl_wr_data = 32'h00000000;

  if($test$plusargs("HQM_OVERRIDE_CLK_GATE_GPSB_ONLY"))
      cfg_master_ctl_wr_data = 32'h0001_0000;

  if($test$plusargs("HQM_OVERRIDE_CLK_SWITCH_CONTROL_GPSB_ONLY"))
      clk_switch_control_en=1;

  default_ip_block_fp = 0;
  $value$plusargs("HQM_ENABLE_DELAY_FUSE_PULL=%d", default_ip_block_fp);

  default_ip_ready = 1;
  $value$plusargs("HQM_USE_IP_READY=%d", default_ip_ready);


  if (clk_switch_control_en)
      cfg_master_ctl_wr_data = 32'h0000_0A00; // Overide_clk_switch_control = 5; Force hqm_clk 1/8x

 `ovm_info(get_full_name(),$sformatf("\n executing steps of hqm_iosf_reg_access_in_side_rst_seq: cfg_master_ctl_wr_data=%0h \n", cfg_master_ctl_wr_data),OVM_LOW)

  // Deassert Powergood Reset
  `ovm_info(get_type_name(),"Start powergood_deassert_seq", OVM_LOW)
  `ovm_do_on_with(powergood_deassert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::POWER_GOOD_DEASSERT;}) 
  `ovm_info(get_type_name(),"completed powergood_deassert_seq", OVM_LOW)

  // Deassert LCP Reset
  `ovm_info(get_type_name(),"Starting hqm_lcp_reset_sequence", OVM_LOW)
  `ovm_do_on_with(lcp_reset_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::LCP_RESET;}) 
  `ovm_info(get_type_name(),"completed lcp_reset_seq", OVM_LOW)
  
  // De assert all resets except Primary reset
  `ovm_info(get_type_name(),$psprintf("Starting reset_deassert_part1_seq with early_fuses = 0x%0x", default_early_fuses),OVM_LOW)
  `ovm_do_on_with(reset_deassert_part1_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::RESET_DEASSERT_PART1; EarlyFuseIn_l==default_early_fuses; }) 
  `ovm_info(get_type_name(),"completed reset_deassert_part1_seq", OVM_LOW)

  if (default_ip_block_fp == 1 && default_ip_ready==0) begin
      `ovm_do_on_with(ip_block_fp_deassert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::IP_BLOCK_FP_DEASSERT;}); 
  end

  if(default_ip_ready==0) begin
     // Wait for IP_READY from IP
     hqm_ip_ready.wait_trigger();
     `ovm_info(get_type_name(),"Got hqm_ip_ready request", OVM_LOW)
  end else begin
     // Wait for ip_ready from HQM output port
     `ovm_do_on_with(ip_ready_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::IP_READY_RESP;}); 
     `ovm_info(get_type_name(),"Got ip_ready responsed ", OVM_LOW)
  end


  pf_cfg_reg  = pf_cfg_regs.DEVICE_COMMAND;
  iosf_addr_cfg_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_cfg_reg);

  `ovm_do_with(sb_cfg_wr_seq, {addr == iosf_addr_cfg_sb;wdata == 16'h6;exp_cplstatus == 2'b00;exp_rsp == 1;})

  `ovm_do_with(sb_cfg_rd_seq, {addr == iosf_addr_cfg_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == 32'h00000000;})

  pf_cfg_reg  = pf_cfg_regs.FUNC_BAR_U;
  iosf_addr_cfg_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_cfg_reg);

  `ovm_do_with(sb_cfg_wr_seq, {addr == iosf_addr_cfg_sb;wdata == 32'h2;exp_cplstatus == 2'b00;exp_rsp == 1;})

  `ovm_do_with(sb_cfg_rd_seq, {addr == iosf_addr_cfg_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == 32'h00000000;})

  pf_cfg_reg  = pf_cfg_regs.CSR_BAR_U;
  iosf_addr_cfg_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_cfg_reg);

  `ovm_do_with(sb_cfg_wr_seq, {addr == iosf_addr_cfg_sb;wdata == 32'h3;exp_cplstatus == 2'b00;exp_rsp == 1;})

  `ovm_do_with(sb_cfg_rd_seq, {addr == iosf_addr_cfg_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == 32'h00000000;})

  pf_mmio_reg  = master_regs.CFG_MASTER_CTL;
  iosf_addr_mem_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_mmio_reg);

  `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == 1;})

  `ovm_do_with(sb_mem_wr_seq, {addr == iosf_addr_mem_sb;wdata == cfg_master_ctl_wr_data;}) //32'h00000000;

  `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == cfg_master_ctl_wr_data;}) //32'h00000000;

  if (!clk_switch_control_en) begin
      pf_mmio_reg  = hqm_sif_csr_regs.VISA_SW_CONTROL;
      iosf_addr_mem_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_mmio_reg);

      `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == 1;})

      `ovm_do_with(sb_mem_wr_seq, {addr == iosf_addr_mem_sb;wdata == 32'hFFFF0000;})

      `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == 32'hFFFF0000;})
  end

  // Deassert Primary reset
  `ovm_do_on_with(reset_deassert_part2_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::RESET_DEASSERT_PART2;}) 
  `ovm_info(get_type_name(),"Completed reset_deassert_part2_seq", OVM_LOW)

  pf_cfg_reg  = pf_cfg_regs.DEVICE_COMMAND;
  iosf_addr_cfg_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_cfg_reg);

  `ovm_do_with(sb_cfg_wr_seq, {addr == iosf_addr_cfg_sb;wdata == 16'h6;exp_cplstatus == 2'b00;exp_rsp == 1;})

  pf_cfg_reg  = pf_cfg_regs.FUNC_BAR_U;
  iosf_addr_cfg_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_cfg_reg);

  `ovm_do_with(sb_cfg_wr_seq, {addr == iosf_addr_cfg_sb;wdata == 32'h2;exp_cplstatus == 2'b00;exp_rsp == 1;})

  pf_cfg_reg  = pf_cfg_regs.CSR_BAR_U;
  iosf_addr_cfg_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_cfg_reg);

  `ovm_do_with(sb_cfg_wr_seq, {addr == iosf_addr_cfg_sb;wdata == 32'h3;exp_cplstatus == 2'b00;exp_rsp == 1;})


  pf_mmio_reg  = master_regs.CFG_MASTER_CTL;
  iosf_addr_mem_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_mmio_reg);

  `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == 1;})

  `ovm_do_with(sb_mem_wr_seq, {addr == iosf_addr_mem_sb;wdata == cfg_master_ctl_wr_data;}) //32'h00000000;

  `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == cfg_master_ctl_wr_data;}) //32'h00000000;

  if (!clk_switch_control_en) begin
      pf_mmio_reg  = hqm_sif_csr_regs.VISA_SW_CONTROL;
      iosf_addr_mem_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_mmio_reg);

      `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == 1;})

      `ovm_do_with(sb_mem_wr_seq, {addr == iosf_addr_mem_sb;wdata == 32'hFFFF0000;})

      `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == 32'hFFFF0000;})
  end
 
  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_reg_access_in_side_rst_seq ended \n"),OVM_LOW)
     
endtask : body
