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
// File   : hqm_iosf_credit_check_with_pf_flr_seq.sv
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

class hqm_iosf_credit_check_with_pf_flr_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_iosf_credit_check_with_pf_flr_seq_stim_config";

  `ovm_object_utils_begin(hqm_iosf_credit_check_with_pf_flr_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(flr_with_txns,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(number_of_txns,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(mask_cfg_wr,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_iosf_credit_check_with_pf_flr_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_int(flr_with_txns)
    `stimulus_config_field_int(number_of_txns)
    `stimulus_config_field_int(mask_cfg_wr)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  int unsigned                  flr_with_txns;
  int unsigned                  number_of_txns;
  int unsigned                  mask_cfg_wr;

  function new(string name = "hqm_iosf_credit_check_with_pf_flr_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_iosf_credit_check_with_pf_flr_seq_stim_config

class hqm_iosf_credit_check_with_pf_flr_seq extends hqm_sla_pcie_base_seq;
  `ovm_object_utils(hqm_iosf_credit_check_with_pf_flr_seq)
  int unsigned     mmio_wr_wgt;
  bit              trigger_mask_cfg_wr;
  Iosf::data_t     wr_data[1];
  Iosf::data_t     wr_data_sb;
  ovm_event        start_traffic;
  sla_ral_reg pf_cfg_reg, pf_mmio_reg;
  Iosf::address_t iosf_addr_cfg, iosf_addr_mem, iosf_addr_cfg_sb, iosf_addr_mem_sb; 
  hqm_iosf_sb_cfg_rd_seq                   sb_cfg_rd_seq; 
  hqm_iosf_sb_cfg_wr_seq                   sb_cfg_wr_seq; 
  hqm_iosf_sb_mem_rd_seq                   sb_mem_rd_seq; 
  hqm_iosf_sb_mem_wr_seq                   sb_mem_wr_seq;
  hqm_iosf_prim_base_seq                   prim_mem_rd_seq;
  hqm_iosf_prim_base_seq                   prim_mem_wr_seq;
  hqm_iosf_prim_base_seq                   prim_cfg_rd_seq;
  hqm_iosf_prim_base_seq                   prim_cfg_wr_seq;
  hqm_sla_pcie_flr_sequence                flr_seq;
  hqm_sla_pcie_init_seq                    pcie_init;    


  rand hqm_iosf_credit_check_with_pf_flr_seq_stim_config        cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_iosf_credit_check_with_pf_flr_seq_stim_config);

  function new(string name = "hqm_iosf_credit_check_with_pf_flr_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name); 

    cfg = hqm_iosf_credit_check_with_pf_flr_seq_stim_config::type_id::create("hqm_pwr_smoke_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
    start_traffic = new("start_traffic");
  endfunction

  extern virtual task body();

  extern virtual task start_flr(bit wait_for_comp);

  extern virtual task generate_traffic(bit wait_for_comp);

  extern virtual task update_addr();

endclass : hqm_iosf_credit_check_with_pf_flr_seq

task hqm_iosf_credit_check_with_pf_flr_seq::update_addr();
  pf_cfg_reg  = pf_cfg_regs.CACHE_LINE_SIZE;
  iosf_addr_cfg = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_cfg_reg);
  pf_cfg_reg  = pf_cfg_regs.INT_LINE;
  iosf_addr_cfg_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_cfg_reg);
  pf_mmio_reg = hqm_system_csr_regs.AW_SMON_TIMER[0];
  iosf_addr_mem = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_mmio_reg);
  iosf_addr_mem_sb = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), pf_mmio_reg);
endtask : update_addr

task hqm_iosf_credit_check_with_pf_flr_seq::generate_traffic(bit wait_for_comp = 0); 
  `ovm_info(get_full_name(),$sformatf("\n task generate_traffic started with wait_for_comp %0d \n", wait_for_comp),OVM_LOW)
  fork 
  begin 
    `ovm_info(get_full_name(),$sformatf("\n prim thread generate_traffic started with wait_for_comp %0d \n", wait_for_comp),OVM_LOW)
     for(int i = 0; i<=cfg.number_of_txns; i++) begin
        wr_data[0] = $urandom_range(0,255);
        if (cfg.flr_with_txns) begin 
          if (!trigger_mask_cfg_wr) begin
            `ovm_do_with(prim_cfg_wr_seq, {iosf_addr_l == iosf_addr_cfg; cmd == Iosf::CfgWr0; iosf_data_l.size() == wr_data.size(); foreach(wr_data[i]) {iosf_data_l[i] == wr_data[i]}; iosf_wait_for_completion_l == wait_for_comp;})
          end
          `ovm_do_with(prim_cfg_rd_seq, {iosf_addr_l == iosf_addr_cfg; cmd == Iosf::CfgRd0; iosf_wait_for_completion_l == wait_for_comp;})
          `ovm_do_with(prim_mem_wr_seq, {iosf_addr_l == iosf_addr_mem; cmd == Iosf::MWr64; iosf_data_l.size() == wr_data.size(); foreach(wr_data[i]) {iosf_data_l[i] == wr_data[i]};})
          `ovm_do_with(prim_mem_rd_seq, {iosf_addr_l == iosf_addr_mem; cmd == Iosf::MRd64; iosf_wait_for_completion_l == wait_for_comp;})
        end
        else begin 
          send_tlp( get_tlp(iosf_addr_cfg, Iosf::CfgWr0, .i_data(wr_data), .i_first_byte_en(4'b_1111)) );
          send_tlp( get_tlp(iosf_addr_cfg, Iosf::CfgRd0, .i_first_byte_en(4'b_1111)), .compare(1), .comp_val(wr_data[0]));
          send_tlp( get_tlp(iosf_addr_mem, Iosf::MWr64, .i_data(wr_data), .i_first_byte_en(4'b_1111)) );
          send_tlp( get_tlp(iosf_addr_mem, Iosf::MRd64));
        end
     end
     `ovm_info(get_full_name(),$sformatf("\n prim thread generate_traffic ended with wait_for_comp %0d \n", wait_for_comp),OVM_LOW)
  end 
  begin 
    `ovm_info(get_full_name(),$sformatf("\n sb thread generate_traffic started with wait_for_comp %0d \n", wait_for_comp),OVM_LOW)
     for(int i = 0; i<=cfg.number_of_txns; i++) begin
        wr_data_sb = $urandom_range(0,255);
        `ovm_do_with(sb_cfg_wr_seq, {addr == iosf_addr_cfg_sb;wdata == wr_data_sb;exp_cplstatus == 2'b00;exp_rsp == wait_for_comp;})
        `ovm_do_with(sb_cfg_rd_seq, {addr == iosf_addr_cfg_sb;exp_cplstatus == 2'b00;exp_rsp == wait_for_comp;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata ==  wr_data_sb;})
        if (cfg.flr_with_txns) begin 
          repeat (mmio_wr_wgt/10) begin `ovm_do_with(sb_mem_wr_seq, {addr == iosf_addr_mem_sb;wdata == wr_data_sb;}) end
          repeat (10 - (mmio_wr_wgt/10)) begin `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == wait_for_comp;}) end
        end
        else begin 
          `ovm_do_with(sb_mem_wr_seq, {addr == iosf_addr_mem_sb;wdata == wr_data_sb[0];})
          `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == 1;})
        end
     end
     `ovm_info(get_full_name(),$sformatf("\n sb thread generate_traffic ended with wait_for_comp %0d \n", wait_for_comp),OVM_LOW)
  end 
  join
  `ovm_info(get_full_name(),$sformatf("\n task generate_traffic ended with wait_for_comp %0d \n", wait_for_comp),OVM_LOW)
endtask : generate_traffic

task hqm_iosf_credit_check_with_pf_flr_seq::start_flr(bit wait_for_comp = 1'b0);
  `ovm_info(get_full_name(),$sformatf("task start_flr started"),OVM_LOW)
	//Disable Bus Master, INTX and Mem Txn enable bit 
	pf_cfg_regs.DEVICE_COMMAND.write(status,{1'b_1,10'h_0},primary_id,this,.sai(legal_sai));

	//Disable MSI in order to avoid any unattended INT later
	pf_cfg_regs.MSIX_CAP_CONTROL.write(status,16'h_0000,primary_id,this,.sai(legal_sai));
  `ovm_info(get_full_name(),$sformatf("task start_flr ended"),OVM_LOW)

  pf_cfg_reg  = pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL;
  iosf_addr_cfg = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_cfg_reg);
  wr_data[0] = 16'h8000;
  `ovm_do_with(prim_cfg_wr_seq, {iosf_addr_l == iosf_addr_cfg; cmd == Iosf::CfgWr0; iosf_data_l.size() == wr_data.size(); foreach(wr_data[i]) {iosf_data_l[i] == wr_data[i]}; iosf_wait_for_completion_l == wait_for_comp;})
endtask : start_flr

task hqm_iosf_credit_check_with_pf_flr_seq::body();
  
  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_credit_check_with_pf_flr_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  
 `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

 update_addr();  

 generate_traffic(.wait_for_comp(1'b1));

 if (cfg.flr_with_txns) begin
   if (!$value$plusargs("MMIO_WR_WGHT=%0d", mmio_wr_wgt)) begin
       mmio_wr_wgt = 50;
   end
   fork   
     begin 
       start_flr(.wait_for_comp(1'b0));
       if (cfg.mask_cfg_wr) begin 
         trigger_mask_cfg_wr = 1'b1;
       end  
       start_traffic.trigger();
     end
     begin
       start_traffic.wait_trigger();  
       generate_traffic(.wait_for_comp(1'b0)); 
     end
     begin 
       #1000us; //waiting for flr  and transactions to end
       if (cfg.mask_cfg_wr) begin 
         trigger_mask_cfg_wr = 1'b0;
       end  
     end 
   join
   // Disable final check since the second np req after flr will be dropped by hqm
	 hqm_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[0].Disable_Final_Checks=1'b_1;
	 hqm_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[1].Disable_Final_Checks=1'b_1;

   `ifdef HQM_IOSF_2019_BFM
   hqm_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtSlvTlm.expTgtTxnQ.q.delete();
   `else
      hqm_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtTgtTlm.expTgtTxnQ.q.delete();
   `endif

   hqm_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_198");
   hqm_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_198");
   hqm_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_198");
   hqm_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_198");
 end
 else begin
  `ovm_do(flr_seq)
   update_addr();  
   generate_traffic(.wait_for_comp(1));
 end
 `ovm_do_with(pcie_init, {pcie_init.cfg.skip_pmcsr_disable==1;})
 `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_credit_check_with_pf_flr_seq ended \n"),OVM_LOW)
     
endtask : body
