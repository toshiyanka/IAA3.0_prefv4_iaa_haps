//-----------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
// File   : hqm_cfg.sv
// Author : Mike Betker
//
// Description :
//
// This class is derived form uvm_object and it represents the high level configuration of HQM.
//------------------------------------------------------------------------------
`ifndef HQM_CFG__SV
`define HQM_CFG__SV

import "DPI-C" context SLA_VPI_put_value =
  function void hqm_cfg_put_value(input chandle handle, input logic [176:0] value);


`include "hqm_map_block.svh"

//class hqm_cfg extends uvm_report_object;
class hqm_cfg extends uvm_component;
  `uvm_component_utils(hqm_cfg)

  //tlm port
  uvm_analysis_port   #(hcw_transaction)        hcw_gen_port;

  //--------------------------------------------------------------------------------------------------------
  //Top level constraint variables
  //--------------------------------------------------------------------------------------------------------
        string                  tb_name;
        string                  inst_suffix = "";
        string                  tb_env_hier = "*";

        hqm_iov_mode_t          hqm_iov_mode;

        bit                     ats_enabled;
        int                     do_force_seq_finish;

        int                     cq_pcq_ctrl; //--PCQ
        int                     vas_pcq_ctrl; //--PCQ

        pp_cq_cfg_t             ldb_pp_cq_cfg[hqm_pkg::NUM_LDB_PP];
        pp_cq_cfg_t             dir_pp_cq_cfg[hqm_pkg::NUM_DIR_PP];

  rand  qid_cfg_t               ldb_qid_cfg[NUM_LDB_QID];
  rand  qid_cfg_t               dir_qid_cfg[NUM_DIR_QID];
                                
  rand  int                     sn_grp_mode[4];

  rand  bit                     msix_enabled;
  rand  msi_msix_t              msix_cfg[hqm_system_pkg::HQM_SYSTEM_NUM_MSIX];
        bit                     msix_mode;

        int                     dir_cq_single_hcw_per_cl;
        int                     ldb_cq_single_hcw_per_cl;

        bit                     sequential_names;
        int                     has_dir_cq_ro;
        int                     has_ldb_cq_ro;

  rand  ims_prog_t              ims_prog_cfg[hqm_pkg::NUM_DIR_CQ+hqm_pkg::NUM_LDB_CQ];

  rand  ims_t                   dir_ims_cfg[hqm_pkg::NUM_DIR_CQ];
  rand  ims_t                   ldb_ims_cfg[hqm_pkg::NUM_LDB_CQ];
        bit                     ims_poll_mode;

  rand  vas_cfg_t               vas_cfg[hqm_pkg::NUM_VAS];  // should be DIR_VAS, but hqm_pkg.sv is wrong

  rand  vdev_cfg_t              vdev_cfg[hqm_pkg::NUM_VF];

  rand  vf_cfg_t                vf_cfg[hqm_pkg::NUM_VF];

        cialcwdt_cfg_t          cialcwdt_cfg;

        sb_exp_errors_t         sb_exp_errors;

        int                     avail_ldb_pp[$];
        int                     avail_dir_pp[$];
        int                     avail_ldb_cq[$];
        int                     avail_dir_cq[$];
        int                     avail_ldb_qid[$];
        int                     avail_dir_qid[$];
        int                     avail_msix_cq[$];
        int                     avail_vas[$];
        int                     avail_vdev[$];
        int                     avail_vf[$];

        int                     prov_ldb_pp[$];
        int                     prov_dir_pp[$];
        int                     prov_ldb_cq[$];
        int                     prov_dir_cq[$];
        int                     prov_ldb_qid[$];
        int                     prov_dir_qid[$];
        int                     prov_msix_cq[$];
        int                     prov_vas[$];
        int                     prov_vdev[$];
        int                     prov_vf[$];

        int                     names[string];

        bit [7:0]               cur_sai;

        hqm_cfg_reg_ops_t       set_cfg_val_op;
        hqm_cfg_reg_ops_t       set_cfg_val_op_write;

        bit                     backdoor_mem_update_enable;

        int                     pad_first_write_ldb;
        int                     pad_first_write_dir;
        int                     pad_write_ldb;
        int                     pad_write_dir;
        int                     early_dir_int;
        int                     pad_qe64Bmode_ldb;
        int                     pad_qe64Bmode_dir;   

        int                     vf2pf_mailbox_intr_cnt;
        int                     pf2vf_mailbox_intr_cnt;
        int                     pf2vf_mailbox_intr_num;
        bit [35:0]              vf2pf_mailbox_msg[$];
        bit [35:0]              pf2vf_mailbox_msg[$];

        int                     hqm_rst_comp;

        int                     hqm_proc_vasrst_comp;
        int                     hqmproc_vasrst_dircq[hqm_pkg::NUM_DIR_CQ];
        int                     hqmproc_vasrst_ldbcq[hqm_pkg::NUM_LDB_CQ];

        string                  hqm_module_prefix;
        string                  hqm_core_module_prefix;

        int                     tot_hqmcore_sched_num;

        bit                     no_sai_check;

        //-- misc
        bit                     test_done;
        int                     hqm_trf_cq_ctrl_st;
        int                     hqmproc_trfon;
        int                     hqmproc_trfck;
        int                     hqmproc_trfctrl;
        int                     hqmproc_trfctrl_0;
        int                     hqmproc_trfctrl_1;
        int                     hqmproc_trfctrl_2;
        int                     hqmproc_dir_trfctrl[hqm_pkg::NUM_DIR_CQ];
        int                     hqmproc_ldb_trfctrl[hqm_pkg::NUM_LDB_CQ];
        int                     hqmproc_dir_tokctrl[hqm_pkg::NUM_DIR_CQ];
        int                     hqmproc_ldb_tokctrl[hqm_pkg::NUM_LDB_CQ];
        int                     hqmproc_ldb_cmpctrl[hqm_pkg::NUM_LDB_CQ];
        int                     hqmproc_ldb_acmpctrl[hqm_pkg::NUM_LDB_CQ];
        int                     hqmproc_dir_trfnum[hqm_pkg::NUM_DIR_CQ];
        int                     hqmproc_ldb_trfnum[hqm_pkg::NUM_LDB_CQ];
        int                     hqmproc_dir_toknum[hqm_pkg::NUM_DIR_CQ];
        int                     hqmproc_ldb_toknum[hqm_pkg::NUM_LDB_CQ];
        int                     hqmproc_ldb_cmpnum[hqm_pkg::NUM_LDB_CQ];
        int                     hqmproc_trfstate;
        int                     hqmproc_lspblockwu;
        int                     hqmproc_trfston;
        int                     hqmproc_dta_srcpp_comp;  

        int                     lsp_ldb_wrr_count_base;
        int                     lsp_ldb_wrr_count_cq;

        bit[7:0]                perfck_sel;
        int                     perfck_tolerance_0;
        int                     perfck_tolerance_1;
        int                     perfck_tolerance_2;
        bit[127:0]              eot_status;
        int                     hqmproc_hcw_batch_ctrl_release;
        bit[63:0]               hqmsystem_cnt_01;
        bit[63:0]               hqmsystem_cnt_23;
        bit[63:0]               hqmsystem_cnt_45;
        bit[63:0]               hqmsystem_cnt_67;
        bit[63:0]               hqmsystem_cnt_89;
        bit[63:0]               hqmsystem_cnt_1011;
        bit[63:0]               hqmsystem_cnt_1213;
        bit[63:0]               hqmsystem_cnt_1415;
        bit[63:0]               hqmsystem_cnt_1617;
        bit[63:0]               hqmsystem_cnt_1819;
        bit[63:0]               hqmsystem_cnt_2021;
        int                     hqmproc_chp_drop_cnt;

        //-- cq_irq_mask
        int                   cq_irq_mask_unit_idle_check;

        hcw_transaction         hcw_trans;

        typedef struct {
          logic [127:0] hcw_q[$];
        } hcw_q_t;

        hcw_q_t                 hcw_queues[hqm_pkg::NUM_DIR_PP + hqm_pkg::NUM_LDB_PP];

        hqm_pp_cq_status        i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed
        real                    hqm_sys_clk_freq;


        //--AY_HQMV30_ATS
        HqmAtsPkg::HqmIommu         iommu;       // Internal IOMMU model -- iommu handle provides access to the Address Translation
                                                 // Services (ATS), Page Request Interface, and Address Invalidation features
                                                 // of the IOMMU, as per PCI-SIG specification "Address Translation Services" v1.1.
        HqmAtsPkg::HqmIommuAPI      iommu_api;

        bit [15:0]                  hqm_bdf;
        bit [2:0]                   pb_translation_type, pb_addr_width;
        bit [63:0]                  pb_addr_mask;
        int                         has_pagesize_2M; 
        HqmBusTxn                   ats_txnid_cq_queues[$];
        HqmBusTxn                   atsinvreq_txnid_cq_queues[$];

        int                         hqm_atsinvcpl_done;
        int                         hqm_alarm_issued;
        int                         hqm_alarm_count;
        int                         hqm_trf_loop;

 //------------------------------------------------------------------------------------  
 //------------------------------------------------------------------------------------  
 ////--08122022 protected      sla_ral_env             ral;
 protected      uvm_reg_block           ral;                //--HQMV30_O2U_RAL
 protected      slu_tb_env              tb_env;

 protected      uvm_reg_block           hqm_pf_cfg_i; 

 protected      uvm_reg                 func_bar_u_reg;
 protected      uvm_reg                 func_bar_l_reg;
 protected      uvm_reg_field           func_bar_l_addr_l_field;

 protected      bit                     msix_fields_valid;
 protected      uvm_reg_field           msixen_field;
 protected      uvm_reg_field           msix_mode_field;
 protected      uvm_reg_field           vec_mask_field[hqm_system_pkg::HQM_SYSTEM_NUM_MSIX];
 protected      uvm_reg_field           msg_addr_l[hqm_system_pkg::HQM_SYSTEM_NUM_MSIX];
 protected      uvm_reg_field           msg_addr_u[hqm_system_pkg::HQM_SYSTEM_NUM_MSIX];
 protected      uvm_reg_field           msg_data[hqm_system_pkg::HQM_SYSTEM_NUM_MSIX];

 protected      bit                     ims_fields_valid;
 protected      bit                     ims_prog_fields_valid;
 protected      bit                     ims_prog_fields_valid_1;
 protected      bit                     ims_prog_fields_valid_2;
 protected      bit                     ims_prog_fields_valid_3;
 protected      bit                     ims_prog_fields_valid_4;
 protected      uvm_reg_field           dir_en_code_field[hqm_pkg::NUM_DIR_CQ];
 protected      uvm_reg_field           dir_vf_field[hqm_pkg::NUM_DIR_CQ];
 protected      uvm_reg_field           dir_vector_field[hqm_pkg::NUM_DIR_CQ];
 protected      bit [7:0]               dir_ims_idx_field[hqm_pkg::NUM_DIR_CQ];
 protected      uvm_reg_field           ldb_en_code_field[hqm_pkg::NUM_LDB_CQ];
 protected      uvm_reg_field           ldb_vf_field[hqm_pkg::NUM_LDB_CQ];
 protected      uvm_reg_field           ldb_vector_field[hqm_pkg::NUM_LDB_CQ];
 protected      bit [7:0]               ldb_ims_idx_field[hqm_pkg::NUM_LDB_CQ];

 protected      uvm_reg_field           ims_prog_addr_l[hqm_pkg::NUM_DIR_CQ+hqm_pkg::NUM_LDB_CQ];
 protected      uvm_reg_field           ims_prog_addr_u[hqm_pkg::NUM_DIR_CQ+hqm_pkg::NUM_LDB_CQ];
 protected      uvm_reg_field           ims_prog_data[hqm_pkg::NUM_DIR_CQ+hqm_pkg::NUM_LDB_CQ];
 protected      uvm_reg_field           ims_prog_ctrl[hqm_pkg::NUM_DIR_CQ+hqm_pkg::NUM_LDB_CQ];
 protected      uvm_reg_field           ims_prog_ctrl_status[hqm_pkg::NUM_DIR_CQ+hqm_pkg::NUM_LDB_CQ];

 protected     hqm_cfg_register_ops      register_access_list[$];
 protected     uvm_event                 cfg_pending;
 //configuration state
 protected     cfg_state_t       cfg_state;
 //configuratoin update control
 protected     bit               update_CHP_cfg;
 protected     bit               update_LSP_cfg;
 protected     bit               update_DP_cfg;
 protected     bit               update_AP_cfg;
 protected     bit               update_NALB_cfg;
 protected     bit               update_ROP_cfg;
 protected     bit               update_MASTER_cfg;
 protected     bit               update_CFG_RING_cfg;
 protected     bit               update_DQED_cfg;
 protected     bit               update_AQED_cfg;
 protected     bit               update_QED_cfg;
 //configuration variables
 protected     bit [7:0]         qid2cqidix_table[4][16][hqm_pkg::NUM_LDB_QID];

 protected     hqm_cfg_command_parser command_parser;
 protected     string                 command_reg_file_name;
 protected     string                 command_reg_reg_name;
 protected     string                 command_reg_field_name;
 //sequence related variables
               string  ral_access_path;
               string  ral_access_path_q[$];
               string                 ral_skip_files[$];
               string                 ral_cfg_files[$];
               string                 ral_type;
 protected     bit                    is_randomized;                              
 protected     bit                    remove_duplicate = 1;
 protected     int                    cq2q_map_cnt[int];

               uvm_reg_field          cfg_64bytes_qe_ldb_cq_mode_field;
               uvm_reg_field          cfg_64bytes_qe_dir_cq_mode_field;
     
 //-------------------------  
 //Constraints
 //-------------------------  
 
 //-------------------------  
 //static constraint if any
 //-------------------------  
 //static constraint disable_type {xxx == 0;};
 protected static hqm_cfg cfg_object;
 //------------------------- 
 //-------------------------    
 //virtual interface hqm_ss_ti_if pins;

 static function hqm_cfg get();
   return cfg_object;
 endfunction   
 //------------------------- 
 // Function: new 
 // Class constructor
 //------------------------- 
  function new (string name = "hqm_cfg", uvm_component parent = null);
    super.new(name, parent);

    set_tb_scope("hqm_core");

    set_hqm_core_module_prefix("");
    set_hqm_module_prefix("");

    hqm_trf_loop = 0;

    //--global setting
    ats_enabled=0;
    if($test$plusargs("HQMV30_ATS_ENA")) begin
        ats_enabled=1;
    end 

    cq_pcq_ctrl=0;
    $value$plusargs("hqm_cq_pcq_ctrl=%d",cq_pcq_ctrl);

    vas_pcq_ctrl=0;
    $value$plusargs("hqm_vas_pcq_ctrl=%d",vas_pcq_ctrl);

   `uvm_info(get_full_name(),$psprintf("hqm_cfg_settings: ats_enabled=%0d cq_pcq_ctrl=%0d vas_pcq_ctrl=%0d", ats_enabled, cq_pcq_ctrl, vas_pcq_ctrl), UVM_LOW)
    
    
    do_force_seq_finish=0;

    if ($test$plusargs("HQM_PRIM_CLK_1_GHZ") && !$test$plusargs("HQM_PRIM_CLK_800_MHZ") && !$test$plusargs("HQM_PRIM_CLK_LOW")) begin
       hqm_sys_clk_freq = 1.0;
    end else if ($test$plusargs("HQM_PRIM_CLK_LOW") && !$test$plusargs("HQM_PRIM_CLK_800_MHZ")) begin
       hqm_sys_clk_freq = 2.50;
    end else begin
       hqm_sys_clk_freq = 1.25;   
    end 

    test_done = 0;
    hqm_trf_cq_ctrl_st = 0;
    hqmproc_trfon = 0;
    hqmproc_trfck = 0;
    hqmproc_trfctrl = 0;
    hqmproc_trfctrl_0 = 0; //-- 2: don't do bgcfg
    hqmproc_trfctrl_1 = 0;
    hqmproc_trfctrl_2 = 0; //-- 0: unit_idle check not available; 1: indicating it's valid to check unitidle
    hqmproc_trfstate = 0;
    hqmproc_trfston = 0;
    hqmproc_lspblockwu = 0;
    hqmproc_hcw_batch_ctrl_release=0;
    hqmproc_dta_srcpp_comp = 0;
    no_sai_check=1; //-- No SAI check for HCW Write (07312020 new RTL)

    foreach(hqmproc_dir_trfctrl[i]) hqmproc_dir_trfctrl[i]=1;
    foreach(hqmproc_ldb_trfctrl[i]) hqmproc_ldb_trfctrl[i]=1;
    foreach(hqmproc_dir_tokctrl[i]) hqmproc_dir_tokctrl[i]=1;
    foreach(hqmproc_ldb_tokctrl[i]) hqmproc_ldb_tokctrl[i]=1;
    foreach(hqmproc_ldb_cmpctrl[i]) hqmproc_ldb_cmpctrl[i]=1;
    foreach(hqmproc_ldb_acmpctrl[i]) hqmproc_ldb_acmpctrl[i]=1;

    foreach(hqmproc_dir_trfnum[i]) hqmproc_dir_trfnum[i]=0;
    foreach(hqmproc_ldb_trfnum[i]) hqmproc_ldb_trfnum[i]=0;
    foreach(hqmproc_dir_toknum[i]) hqmproc_dir_toknum[i]=0;
    foreach(hqmproc_ldb_toknum[i]) hqmproc_ldb_toknum[i]=0;
    foreach(hqmproc_ldb_cmpnum[i]) hqmproc_ldb_cmpnum[i]=0;

    msix_fields_valid = 0;
    ims_fields_valid = 0;
    ims_prog_fields_valid = 0;
    ims_prog_fields_valid_1 = 0;
    ims_prog_fields_valid_2 = 0;
    ims_prog_fields_valid_3 = 0;
    ims_prog_fields_valid_4 = 0;

    pad_first_write_ldb=0;
    pad_first_write_dir=0;
    pad_write_ldb=1;
    pad_write_dir=1;
    early_dir_int=0;
    pad_qe64Bmode_ldb=0;
    pad_qe64Bmode_dir=0;   
    vf2pf_mailbox_intr_cnt=0;
    pf2vf_mailbox_intr_cnt=0;
    pf2vf_mailbox_intr_num=0;
    hqm_rst_comp=0;
    hqm_proc_vasrst_comp=0;
    foreach(hqmproc_vasrst_dircq[i]) hqmproc_vasrst_dircq[i]=0;
    foreach(hqmproc_vasrst_ldbcq[i]) hqmproc_vasrst_ldbcq[i]=0;
    cialcwdt_cfg.cwdt_received_cnt=0;
    cialcwdt_cfg.cwdt_count_num=0;
    cq_irq_mask_unit_idle_check=0;
    cfg_object = this;
  endfunction : new

  virtual function void set_inst_suffix(string new_inst_suffix);
    inst_suffix = new_inst_suffix;
   `uvm_info(get_full_name(),$psprintf("set_inst_suffix inst_suffix=%s", inst_suffix), UVM_LOW)
  endfunction : set_inst_suffix

  function void set_tb_env_hier(string new_tb_env_hier);
    tb_env_hier = new_tb_env_hier;
   `uvm_info(get_full_name(),$psprintf("set_tb_env_hier tb_env_hier=%s", tb_env_hier), UVM_LOW)
  endfunction

  function string get_tb_env_hier();
    get_tb_env_hier = tb_env_hier;
   `uvm_info(get_full_name(),$psprintf("get_tb_env_hier tb_env_hier=%s", tb_env_hier), UVM_LOW)
  endfunction

  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
  virtual function void set_hqm_core_module_prefix(string module_prefix);
    this.hqm_core_module_prefix = module_prefix;
  endfunction

  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
  virtual function void set_hqm_module_prefix(string module_prefix);
    this.hqm_module_prefix = module_prefix;
  endfunction

  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
  //function connect_pins(virtual hqm_ss_ti_if pins);
  //   this.pins = pins;
  //endfunction: connect_pins;

  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
  virtual function void set_tb_scope(string tb_name);
    this.tb_name = tb_name;

    this.ral_cfg_files.delete();

    if ((tb_name == "hqm_proc") || (tb_name == "hqm")) begin
      add_ral_cfg_files("aqed_pipe");
      add_ral_cfg_files("atm_pipe");
      add_ral_cfg_files("credit_hist_pipe");
      add_ral_cfg_files("list_sel_pipe");
      add_ral_cfg_files("direct_pipe");
      add_ral_cfg_files("qed_pipe");
      add_ral_cfg_files("nalb_pipe");
      add_ral_cfg_files("reorder_pipe");
      add_ral_cfg_files("config_master");
      add_ral_cfg_files("hqm_system_csr");
      add_ral_cfg_files("hqm_msix_mem");
    end 
    
    if (tb_name == "hqm") begin
      add_ral_cfg_files("hqm_pf_cfg_i");
      add_ral_cfg_files("hqm_sif_csr");
    end 
  endfunction

  virtual function void reset_hqm_cfg();
    int                 default_hist_list_size;
    //--08122022 sla_ral_file        mfiles[$];
    //--08122022 uvm_reg         mregs[$];
    uvm_reg_block       mfiles[$];
    uvm_reg             mregs[$];

    hqm_cfg_register_ops      tmp_reg_ops;
    int                 num_to_drain; 

    `uvm_info("HQM_CFG",$psprintf("HQM%0s__reset_hqm_cfg Start",inst_suffix),UVM_LOW)
    //--AY_HQMV30_ATS
    //--global setting
    ats_enabled=0;
    if($test$plusargs("HQMV30_ATS_ENA")) begin
        ats_enabled=1;
       `uvm_info("HQM_CFG",$psprintf("HQM%0s__Get ats_enabled = %0d by +HQMV30_ATS_ENA",inst_suffix,ats_enabled),UVM_LOW)
    end 

    do_force_seq_finish=0;

    //--AY_HQMV30_ATS
    has_pagesize_2M=0;
    if(ats_enabled) pb_addr_mask = 64'hfff;
    else            pb_addr_mask = 64'h3f;
    if($test$plusargs("ATS_4KPAGE_ONLY")) begin
       has_pagesize_2M=0;
    end else begin
       $value$plusargs("HQM_PB_ADDRMASK=%h", pb_addr_mask);
       if(pb_addr_mask=='h1fffff) has_pagesize_2M=1;
    end 
    `uvm_info("HQM_CFG",$psprintf("HQM%0s__Get pb_addr_mask = 0x%0x; has_pagesize_2M=%0d",inst_suffix,pb_addr_mask, has_pagesize_2M),UVM_LOW)

    //--0: pass-through; 1: FL; 2: SL; 3: NESTED
    //-- pb_translation_type=7: rand {0,4}
    pb_translation_type=2; 
    $value$plusargs("HQM_PB_PGTT=%d", pb_translation_type); 
    `uvm_info("HQM_CFG",$psprintf("HQM%0s__Get pb_translation_type = %0d",inst_suffix,pb_translation_type),UVM_LOW)

    //-- when pb_translation_type=SL (2), AW=1 39bit; AW=2 48bit; AW=3 57bit 
    //-- pb_addr_width=0: rand {1:3}
    pb_addr_width=3; 
    $value$plusargs("HQM_PB_AW=%d", pb_addr_width);
    `uvm_info("HQM_CFG",$psprintf("HQM%0s__Get pb_addr_width = %0d",inst_suffix,pb_addr_width),UVM_LOW)

    ats_txnid_cq_queues.delete();
    atsinvreq_txnid_cq_queues.delete();


    //-----------------------------------
    lsp_ldb_wrr_count_base = -1;
    $value$plusargs("LDB_WRR_COUNT_BASE=%h", lsp_ldb_wrr_count_base);
    `uvm_info("HQM_CFG",$psprintf("HQM%0s__Get lsp_ldb_wrr_count_base = 0x%0x",inst_suffix,lsp_ldb_wrr_count_base),UVM_LOW)

    lsp_ldb_wrr_count_cq = -1;
    $value$plusargs("LDB_WRR_COUNT_CQ=%d", lsp_ldb_wrr_count_cq);
    `uvm_info("HQM_CFG",$psprintf("HQM%0s__Get lsp_ldb_wrr_count_cq = %0d",inst_suffix,lsp_ldb_wrr_count_cq),UVM_LOW)

    if ($test$plusargs("HQM_DIR_CQ_SINGLE_HCW_PER_CL")) begin
      dir_cq_single_hcw_per_cl = 2;
    end else begin
      dir_cq_single_hcw_per_cl = -1;
    end 

    if ($test$plusargs("HQM_LDB_CQ_SINGLE_HCW_PER_CL")) begin
      ldb_cq_single_hcw_per_cl = 2;
    end else begin
      ldb_cq_single_hcw_per_cl = -1;
    end 

    if ($test$plusargs("HQM_CFG_USE_SEQUENTIAL_NAMES")) begin
      sequential_names = 1;
    end else begin
      sequential_names = 0;
    end 

    if ($test$plusargs("HQM_CFG_HQMPROCTRFSTON")) begin
      hqmproc_trfston = 1;
    end else begin
      hqmproc_trfston = 0;
    end 

    //--CQ RO 
    has_dir_cq_ro=0;
    $value$plusargs("DIR_CQ_RO=%d", has_dir_cq_ro);
    `uvm_info("HQM_CFG",$psprintf("HQM%0s__Get has_dir_cq_ro = %0d",inst_suffix,has_dir_cq_ro),UVM_LOW)

    has_ldb_cq_ro=0;
    $value$plusargs("LDB_CQ_RO=%d", has_ldb_cq_ro);
    `uvm_info("HQM_CFG",$psprintf("HQM%0s__Get has_ldb_cq_ro = %0d",inst_suffix,has_ldb_cq_ro),UVM_LOW)


    `uvm_info("HQM_CFG",$psprintf("HQM%0s__hqm_cfg.reset_hqm_cfg() start", inst_suffix),UVM_MEDIUM)
    if (this.register_access_list.size > 0 && $test$plusargs("HQM_CFG_RESET_POP_REGLIST")) begin
       num_to_drain = this.register_access_list.size;
       for(int k=0; k<num_to_drain; k++) begin
          tmp_reg_ops = this.register_access_list.pop_front();
          uvm_report_info("CFG", $psprintf("HQM%0s__reset_hqm_cfg:: Pop Pending Register reg_name=%0s file_name=%0s; register_access_list.size=%0d", inst_suffix, tmp_reg_ops.reg_name, tmp_reg_ops.file_name, this.register_access_list.size), UVM_LOW);
       end 
    end 

    avail_ldb_pp.delete();
    avail_dir_pp.delete();
    avail_ldb_cq.delete();
    avail_dir_cq.delete();
    avail_ldb_qid.delete();
    avail_dir_qid.delete();
    avail_msix_cq.delete();
    avail_vas.delete();
    avail_vdev.delete();
    avail_vf.delete();

    prov_ldb_pp.delete();
    prov_dir_pp.delete();
    prov_ldb_cq.delete();
    prov_dir_cq.delete();
    prov_ldb_qid.delete();
    prov_dir_qid.delete();
    prov_msix_cq.delete();
    prov_vas.delete();
    prov_vdev.delete();
    prov_vf.delete();

    vf2pf_mailbox_msg.delete();
    pf2vf_mailbox_msg.delete();

    foreach (hcw_queues[i]) begin
      hcw_queues[i].hcw_q.delete();
    end 

    sb_exp_errors.enq_hcw_q_not_empty   = '0;

    for (int i = 0 ; i < hqm_pkg::NUM_LDB_PP ; i++) begin
      avail_ldb_pp.push_back(i);
    end 
    for (int i = 0 ; i < hqm_pkg::NUM_DIR_PP ; i++) begin
      avail_dir_pp.push_back(i);
    end 
    for (int i = 0 ; i < hqm_pkg::NUM_LDB_CQ ; i++) begin
      avail_ldb_cq.push_back(i);
    end 
    for (int i = 0 ; i < hqm_pkg::NUM_DIR_CQ ; i++) begin
      avail_dir_cq.push_back(i);
    end 
    for (int i = 0 ; i < hqm_pkg::NUM_LDB_QID ; i++) begin
      avail_ldb_qid.push_back(i);
    end 
    for (int i = 0 ; i < hqm_pkg::NUM_DIR_QID ; i++) begin
      avail_dir_qid.push_back(i);
    end 
    for (int i = 1 ; i < hqm_system_pkg::HQM_SYSTEM_NUM_MSIX ; i++) begin
      avail_msix_cq.push_back(i);
    end 
    for (int i = 0 ; i < hqm_pkg::NUM_VAS ; i++) begin
      avail_vas.push_back(i);
    end 
    for (int i = 0 ; i < hqm_pkg::NUM_VF ; i++) begin
      avail_vdev.push_back(i);
    end 
    for (int i = 0 ; i < hqm_pkg::NUM_VF ; i++) begin
      avail_vf.push_back(i);
    end 

    names.delete();

    hqm_iov_mode                                = HQM_PF_MODE;

    default_hist_list_size                      = 2048/hqm_pkg::NUM_LDB_PP;

    foreach (ldb_pp_cq_cfg[i]) begin
      ldb_pp_cq_cfg[i].cq_provisioned              = 0;
      ldb_pp_cq_cfg[i].cq_enable                   = 0;
      ldb_pp_cq_cfg[i].cq_pcq                      = 0;
      if ($test$plusargs("HQM_LDB_CQ_SINGLE_HCW_PER_CL") || $test$plusargs("ATS_4KPAGE_ONLY")) begin
        ldb_pp_cq_cfg[i].cq_depth                  = DEPTH_256;
      end else begin
        ldb_pp_cq_cfg[i].cq_depth                  = DEPTH_1024;
      end 
      ldb_pp_cq_cfg[i].cq_token_count              = 0;
      ldb_pp_cq_cfg[i].cq_totnum                   = 0;
      ldb_pp_cq_cfg[i].cq_wbcount                  = 0;
      ldb_pp_cq_cfg[i].cq_wb_pad                   = 1;
      ldb_pp_cq_cfg[i].disable_wb_opt              = 0;
      ldb_pp_cq_cfg[i].cq_count                    = 0;
      ldb_pp_cq_cfg[i].cq_gen                      = 1;
      ldb_pp_cq_cfg[i].cq_cmpck_ena                = 0;
      ldb_pp_cq_cfg[i].cq_hl_exp_mode              = 0;
      ldb_pp_cq_cfg[i].hist_list_base              = i * default_hist_list_size;
      ldb_pp_cq_cfg[i].hist_list_limit             = (i * default_hist_list_size) + default_hist_list_size - 1;
      ldb_pp_cq_cfg[i].cq_depth_intr_ena           = 0;
      ldb_pp_cq_cfg[i].cq_depth_intr_thresh        = 512;
      ldb_pp_cq_cfg[i].cq_timer_intr_ena           = 0;
      ldb_pp_cq_cfg[i].cq_timer_intr_thresh        = 0;
      ldb_pp_cq_cfg[i].cq_cwdt_intr_ena            = 0;
      ldb_pp_cq_cfg[i].cq_cwdt_intr_count          = 0;
      ldb_pp_cq_cfg[i].cq_trfctrl                  = 0;
      ldb_pp_cq_cfg[i].cq_gpa                      = 0;
      ldb_pp_cq_cfg[i].cq_hpa                      = 0;
      ldb_pp_cq_cfg[i].cq_bdf                      = 0;
      ldb_pp_cq_cfg[i].cq_ats_req_issued           = 0;
      ldb_pp_cq_cfg[i].cq_ats_resp_returned        = 0;
      ldb_pp_cq_cfg[i].cq_ats_resp_errinj          = 0;
      ldb_pp_cq_cfg[i].cq_ats_resp_errinj_st       = 0;
      ldb_pp_cq_cfg[i].cq_ats_inv_ctrl             = 0;
      ldb_pp_cq_cfg[i].cq_ats_page_rebuild         = 0;
      ldb_pp_cq_cfg[i].cq_ats_entry_delete         = 0;
      ldb_pp_cq_cfg[i].cq_txn_id                   = 'h3ffffff;
      ldb_pp_cq_cfg[i].cq_atsinvreq_txn_id         = 'h3ffffff;
      ldb_pp_cq_cfg[i].cq_atsinvreq_issued         = 0;
      ldb_pp_cq_cfg[i].cq_atsinvresp_returned      = 0;
      ldb_pp_cq_cfg[i].cq_pagesize                 = HqmAtsPkg::PAGE_SIZE_1G;
      ldb_pp_cq_cfg[i].wu_limit                    = -1;
      ldb_pp_cq_cfg[i].wu_limit_tolerance          = 40;
      ldb_pp_cq_cfg[i].cq_int_mask                 = 0;
      ldb_pp_cq_cfg[i].cq_irq_pending              = 0;
      ldb_pp_cq_cfg[i].cq_int_mask_opt             = 0;
      ldb_pp_cq_cfg[i].cq_int_mask_ena             = 0;
      ldb_pp_cq_cfg[i].cq_int_mask_run             = 0;
      ldb_pp_cq_cfg[i].cq_int_mask_wait            = 0;
      ldb_pp_cq_cfg[i].cq_int_mask_check           = 0;
      ldb_pp_cq_cfg[i].cq_int_intr_state           = 0;
      ldb_pp_cq_cfg[i].cq_irq_pending_check        = 0;
      ldb_pp_cq_cfg[i].is_pf                       = 0;
      ldb_pp_cq_cfg[i].vf                          = 0;
      ldb_pp_cq_cfg[i].vpp                         = -1;
      ldb_pp_cq_cfg[i].vdev                        = -1;
      ldb_pp_cq_cfg[i].pasid                       = 0;
      ldb_pp_cq_cfg[i].at                          = 0;
      ldb_pp_cq_cfg[i].cq_isr.en_code              = 0;
      ldb_pp_cq_cfg[i].cq_isr.vf                   = 0;
      ldb_pp_cq_cfg[i].cq_isr.vector               = 0;
      ldb_pp_cq_cfg[i].ro                          = (has_ldb_cq_ro==2)?  ($urandom_range(1,0)) : has_ldb_cq_ro;

      for (int j = 0 ; j < 8 ; j++) begin
        ldb_pp_cq_cfg[i].qidix[j].qidv          = 0;
        ldb_pp_cq_cfg[i].qidix[j].qid           = 0;
        ldb_pp_cq_cfg[i].qidix[j].pri           = 0;
      end 

      ldb_pp_cq_cfg[i].pp_provisioned              = 0;
      ldb_pp_cq_cfg[i].pp_enable                   = 0;
      ldb_pp_cq_cfg[i].cq_ldb_inflight_count       = 0;
      ldb_pp_cq_cfg[i].cq_ldb_inflight_limit       = 10;
      ldb_pp_cq_cfg[i].cq_ldb_inflight_limit_set   = 0;
      ldb_pp_cq_cfg[i].cq_ldb_inflight_thresh      = 0;
      ldb_pp_cq_cfg[i].vas                         = 0;
      ldb_pp_cq_cfg[i].exp_errors.ill_hcw_cmd      = '0;
      ldb_pp_cq_cfg[i].exp_errors.ill_hcw_cmd_dir_pp    = '0;
      ldb_pp_cq_cfg[i].exp_errors.ill_qid          = '0;
      ldb_pp_cq_cfg[i].exp_errors.ill_ldbqid       = '0;
      ldb_pp_cq_cfg[i].exp_errors.ill_pp           = '0;
      ldb_pp_cq_cfg[i].exp_errors.unexp_comp       = '0;
      ldb_pp_cq_cfg[i].exp_errors.ill_comp         = '0;
      ldb_pp_cq_cfg[i].exp_errors.remove_ord_pp    = '0;
      ldb_pp_cq_cfg[i].exp_errors.excess_frag      = '0;
      ldb_pp_cq_cfg[i].exp_errors.excess_tok       = '0;
      ldb_pp_cq_cfg[i].exp_errors.unexp_rels       = '0;
      ldb_pp_cq_cfg[i].exp_errors.unexp_rels_qid   = '0;
      ldb_pp_cq_cfg[i].exp_errors.drop             = '0;
      ldb_pp_cq_cfg[i].exp_errors.ooc              = '0;

      //--max_cacheline support
      ldb_pp_cq_cfg[i].cl_rob                      = 0;
      ldb_pp_cq_cfg[i].cl_check                    = 0;
      ldb_pp_cq_cfg[i].cl_cnt                      = 0;
      ldb_pp_cq_cfg[i].cl_max                      = 4;
      ldb_pp_cq_cfg[i].cl_addr                     = '0;

      //-- PALB
      ldb_pp_cq_cfg[i].palb_on_thrsh               = 0;
      ldb_pp_cq_cfg[i].palb_off_thrsh              = 0;
    end 

    foreach (dir_pp_cq_cfg[i]) begin
      dir_pp_cq_cfg[i].cq_provisioned              = 0;
      dir_pp_cq_cfg[i].cq_enable                   = 0;
      dir_pp_cq_cfg[i].cq_cmpck_ena                = 0;
      dir_pp_cq_cfg[i].cq_hl_exp_mode              = 0;
      dir_pp_cq_cfg[i].hist_list_base              = 0;
      dir_pp_cq_cfg[i].hist_list_limit             = 0;
      if ($test$plusargs("ATS_4KPAGE_ONLY")) begin
        dir_pp_cq_cfg[i].cq_depth                    = DEPTH_256;
      end else begin
        dir_pp_cq_cfg[i].cq_depth                    = DEPTH_1024;
      end 
      dir_pp_cq_cfg[i].cq_token_count              = 0;
      dir_pp_cq_cfg[i].cq_totnum                   = 0;
      dir_pp_cq_cfg[i].cq_wbcount                  = 0;
      dir_pp_cq_cfg[i].cq_wb_pad                   = 1;
      dir_pp_cq_cfg[i].disable_wb_opt              = 0;
      dir_pp_cq_cfg[i].cq_count                    = 0;
      dir_pp_cq_cfg[i].cq_gen                      = 1;
      dir_pp_cq_cfg[i].cq_depth_intr_ena           = 0;
      dir_pp_cq_cfg[i].cq_depth_intr_thresh        = 128;
      dir_pp_cq_cfg[i].cq_timer_intr_ena           = 0;
      dir_pp_cq_cfg[i].cq_timer_intr_thresh        = 0;
      dir_pp_cq_cfg[i].cq_cwdt_intr_ena            = 0;
      dir_pp_cq_cfg[i].cq_trfctrl                  = 0;
      dir_pp_cq_cfg[i].cq_gpa                      = 0;
      dir_pp_cq_cfg[i].cq_hpa                      = 0;
      dir_pp_cq_cfg[i].cq_bdf                      = 0;
      dir_pp_cq_cfg[i].cq_ats_req_issued           = 0;
      dir_pp_cq_cfg[i].cq_ats_resp_returned        = 0;
      dir_pp_cq_cfg[i].cq_ats_resp_errinj          = 0;
      dir_pp_cq_cfg[i].cq_ats_resp_errinj_st       = 0;
      dir_pp_cq_cfg[i].cq_ats_inv_ctrl             = 0;
      dir_pp_cq_cfg[i].cq_ats_page_rebuild         = 0;
      dir_pp_cq_cfg[i].cq_txn_id                   = 'h3ffffff;
      dir_pp_cq_cfg[i].cq_atsinvreq_txn_id         = 'h3ffffff;
      dir_pp_cq_cfg[i].cq_atsinvreq_issued         = 0;
      dir_pp_cq_cfg[i].cq_atsinvresp_returned      = 0;
      dir_pp_cq_cfg[i].cq_ats_entry_delete         = 0;
      dir_pp_cq_cfg[i].cq_pagesize                 = HqmAtsPkg::PAGE_SIZE_1G;
      dir_pp_cq_cfg[i].wu_limit                    = -1;
      dir_pp_cq_cfg[i].cq_int_mask                 = 0;
      dir_pp_cq_cfg[i].cq_irq_pending              = 0;
      dir_pp_cq_cfg[i].cq_int_mask_opt             = 0;
      dir_pp_cq_cfg[i].cq_int_mask_ena             = 0;
      dir_pp_cq_cfg[i].cq_int_mask_run             = 0;
      dir_pp_cq_cfg[i].cq_int_mask_wait            = 0;
      dir_pp_cq_cfg[i].cq_int_mask_check           = 0;
      dir_pp_cq_cfg[i].cq_int_intr_state           = 0;
      dir_pp_cq_cfg[i].cq_irq_pending_check        = 0;
      dir_pp_cq_cfg[i].is_pf                       = 0;
      dir_pp_cq_cfg[i].vf                          = 0;
      dir_pp_cq_cfg[i].vpp                         = -1;
      dir_pp_cq_cfg[i].vdev                        = -1;
      dir_pp_cq_cfg[i].pasid                       = 0;
      dir_pp_cq_cfg[i].at                          = 0;
      dir_pp_cq_cfg[i].dir_cq_fmt.keep_pf_ppid     = 0;
      dir_pp_cq_cfg[i].cq_isr.en_code              = 0;
      dir_pp_cq_cfg[i].cq_isr.vf                   = 0;
      dir_pp_cq_cfg[i].cq_isr.vector               = 0;
      dir_pp_cq_cfg[i].ro                          = (has_dir_cq_ro==2)?  ($urandom_range(1,0)) : has_dir_cq_ro;

      for (int j = 0 ; j < 8 ; j++) begin
        dir_pp_cq_cfg[i].qidix[j].qidv          = 0;
        dir_pp_cq_cfg[i].qidix[j].qid           = 0;
        dir_pp_cq_cfg[i].qidix[j].pri           = 0;
      end 

      dir_pp_cq_cfg[i].pp_provisioned              = 0;
      dir_pp_cq_cfg[i].pp_enable                   = 0;
      dir_pp_cq_cfg[i].cq_ldb_inflight_count       = 0;
      dir_pp_cq_cfg[i].cq_ldb_inflight_limit       = 10;
      dir_pp_cq_cfg[i].cq_ldb_inflight_limit_set   = 0;
      dir_pp_cq_cfg[i].vas                         = 0;
      dir_pp_cq_cfg[i].exp_errors.ill_hcw_cmd      = '0;
      dir_pp_cq_cfg[i].exp_errors.ill_hcw_cmd_dir_pp    = '0;
      dir_pp_cq_cfg[i].exp_errors.ill_qid          = '0;
      dir_pp_cq_cfg[i].exp_errors.ill_ldbqid       = '0;
      dir_pp_cq_cfg[i].exp_errors.ill_pp           = '0;
      dir_pp_cq_cfg[i].exp_errors.remove_ord_pp    = '0;
      dir_pp_cq_cfg[i].exp_errors.unexp_comp       = '0;
      dir_pp_cq_cfg[i].exp_errors.excess_frag      = '0;
      dir_pp_cq_cfg[i].exp_errors.excess_tok       = '0;
      dir_pp_cq_cfg[i].exp_errors.unexp_rels       = '0;
      dir_pp_cq_cfg[i].exp_errors.unexp_rels_qid   = '0;
      dir_pp_cq_cfg[i].exp_errors.ill_comp         = '0;
      dir_pp_cq_cfg[i].exp_errors.drop             = '0;
      dir_pp_cq_cfg[i].exp_errors.ooc              = '0;

      //--max_cacheline support
      dir_pp_cq_cfg[i].cl_rob                      = 0;
      dir_pp_cq_cfg[i].cl_check                    = 0;
      dir_pp_cq_cfg[i].cl_cnt                      = 0;
      dir_pp_cq_cfg[i].cl_max                      = 4;
      dir_pp_cq_cfg[i].cl_addr                     = '0;
    end 

    foreach (ldb_qid_cfg[i]) begin
      ldb_qid_cfg[i].provisioned                        = 0;
      ldb_qid_cfg[i].enable                             = 0;
      ldb_qid_cfg[i].qid_its                            = 0;
      ldb_qid_cfg[i].qid_ldb_inflight_count             = 0;
      ldb_qid_cfg[i].qid_ldb_inflight_limit             = 10;
      ldb_qid_cfg[i].uno_ord_enq_hcw_rpt_thresh         = 10;
      ldb_qid_cfg[i].uno_ord_inflight_limit             = 10;
      ldb_qid_cfg[i].atq_enq_hcw_rpt_thresh             = 10;
      ldb_qid_cfg[i].atq_inflight_limit                 = 10;
      ldb_qid_cfg[i].dir_enq_hcw_rpt_thresh             = 10;
      ldb_qid_cfg[i].atm_qid_depth_thresh               = 0;
      ldb_qid_cfg[i].nalb_qid_depth_thresh              = 0;
      ldb_qid_cfg[i].dir_qid_depth_thresh               = 0;
      ldb_qid_cfg[i].aqed_freelist_base                 = i * 'h10;
      ldb_qid_cfg[i].aqed_freelist_limit                = (i * 'h10) | 'hf;
      ldb_qid_cfg[i].qid_comp_code                      = 0;
      ldb_qid_cfg[i].fid_limit                          = 'h7f;
      ldb_qid_cfg[i].vqid                               = -1;
      ldb_qid_cfg[i].exp_errors.not_empty               = '0;
      ldb_qid_cfg[i].exp_errors.ord_not_empty           = '0;
      ldb_qid_cfg[i].exp_errors.remove_ord_q            = '0;
      ldb_qid_cfg[i].exp_errors.ord_out_of_order        = '0;
      ldb_qid_cfg[i].exp_errors.sch_out_of_order        = '0;
      ldb_qid_cfg[i].exp_errors.unexp_atm_comp          = '0;
      ldb_qid_cfg[i].pp                                 = '0;
      ldb_qid_cfg[i].ao_cfg_v                           = '0;
    end 

    foreach (dir_qid_cfg[i]) begin
      dir_qid_cfg[i].provisioned                        = 0;
      dir_qid_cfg[i].enable                             = 0;
      dir_qid_cfg[i].qid_its                            = 0;
      dir_qid_cfg[i].qid_ldb_inflight_count             = 0;
      dir_qid_cfg[i].qid_ldb_inflight_limit             = 10;
      dir_qid_cfg[i].uno_ord_enq_hcw_rpt_thresh         = 0;
      dir_qid_cfg[i].uno_ord_inflight_limit             = 0;
      dir_qid_cfg[i].atq_enq_hcw_rpt_thresh             = 0;
      dir_qid_cfg[i].atq_inflight_limit                 = 0;
      dir_qid_cfg[i].dir_enq_hcw_rpt_thresh             = 10;
      dir_qid_cfg[i].atm_qid_depth_thresh               = 0;
      dir_qid_cfg[i].nalb_qid_depth_thresh              = 0;
      dir_qid_cfg[i].dir_qid_depth_thresh               = 0;
      dir_qid_cfg[i].aqed_freelist_base                 = 0;
      dir_qid_cfg[i].aqed_freelist_limit                = 0;
      ldb_qid_cfg[i].qid_comp_code                      = 0;
      dir_qid_cfg[i].vqid                               = -1;
      dir_qid_cfg[i].exp_errors.not_empty               = '0;
      dir_qid_cfg[i].exp_errors.ord_not_empty           = '0;
      dir_qid_cfg[i].exp_errors.remove_ord_q            = '0;
      dir_qid_cfg[i].exp_errors.ord_out_of_order        = '0;
      dir_qid_cfg[i].exp_errors.sch_out_of_order        = '0;
      dir_qid_cfg[i].exp_errors.unexp_atm_comp          = '0;
      dir_qid_cfg[i].pp                                 = '0;
    end 

    foreach(sn_grp_mode[i]) begin
       sn_grp_mode[i]= -1;
    end 

    msix_enabled        = 1'b0;
    msix_mode           = 1'b0;
    ims_poll_mode       = 1'b0;

    foreach (msix_cfg[i]) begin
      msix_cfg[i].enable        = '0;
      msix_cfg[i].addr          = '0;
      msix_cfg[i].data          = '0;
      msix_cfg[i].is_ldb        = '0;
      msix_cfg[i].cq            = -1;
    end 

    foreach (ims_prog_cfg[i]) begin
      ims_prog_cfg[i].enable        = '0;
      ims_prog_cfg[i].addr          = '0;
      ims_prog_cfg[i].data          = '0;
      ims_prog_cfg[i].ctrl          = '0;
      ims_prog_cfg[i].is_ldb        = '0;
      ims_prog_cfg[i].cq            = -1;
    end 

    foreach (dir_ims_cfg[i]) begin
      dir_ims_cfg[i].enable        = '0;
      dir_ims_cfg[i].addr          = '0;
      dir_ims_cfg[i].data          = '0;
      dir_ims_cfg[i].ctrl          = '0;
    end 

    foreach (ldb_ims_cfg[i]) begin
      ldb_ims_cfg[i].enable        = '0;
      ldb_ims_cfg[i].addr          = '0;
      ldb_ims_cfg[i].data          = '0;
      ldb_ims_cfg[i].ctrl          = '0;
    end 

    foreach (vas_cfg[i]) begin
      vas_cfg[i].provisioned            = '0;
      vas_cfg[i].enable                 = '0;
      vas_cfg[i].ldb_qid_v              = '0;
      vas_cfg[i].dir_qid_v              = '0;
      vas_cfg[i].credit_cnt             = '0;
      vas_cfg[i].credit_num             = '0;
    end 

    foreach (vf_cfg[i]) begin
      vf_cfg[i].provisioned                     = '0;
      vf_cfg[i].enable                          = '0;

      for (int j = 0 ; j < hqm_pkg::NUM_LDB_PP ; j++) begin
        vf_cfg[i].ldb_vpp_cfg[j].provisioned    = '0;
        vf_cfg[i].ldb_vpp_cfg[j].enable         = '0;
        vf_cfg[i].ldb_vpp_cfg[j].vpp_v          = '0;
        vf_cfg[i].ldb_vpp_cfg[j].pp             = '0;
      end 
      for (int j = 0 ; j < hqm_pkg::NUM_DIR_PP ; j++) begin
        vf_cfg[i].dir_vpp_cfg[j].provisioned    = '0;
        vf_cfg[i].dir_vpp_cfg[j].enable         = '0;
        vf_cfg[i].dir_vpp_cfg[j].vpp_v          = '0;
        vf_cfg[i].dir_vpp_cfg[j].pp             = '0;
      end 
      for (int j = 0 ; j < hqm_pkg::NUM_LDB_QID ; j++) begin
        vf_cfg[i].ldb_vqid_cfg[j].provisioned   = '0;
        vf_cfg[i].ldb_vqid_cfg[j].enable        = '0;
        vf_cfg[i].ldb_vqid_cfg[j].vqid_v        = '0;
        vf_cfg[i].ldb_vqid_cfg[j].qid           = '0;
      end 
      for (int j = 0 ; j < hqm_pkg::NUM_DIR_QID ; j++) begin
        vf_cfg[i].dir_vqid_cfg[j].provisioned   = '0;
        vf_cfg[i].dir_vqid_cfg[j].enable        = '0;
        vf_cfg[i].dir_vqid_cfg[j].vqid_v        = '0;
        vf_cfg[i].dir_vqid_cfg[j].qid           = '0;
      end 
      vf_cfg[i].msi_enabled                     = '0;
      vf_cfg[i].msi_multi_msg_en                =  5;
      vf_cfg[i].msi_addr                        = '0;
      vf_cfg[i].msi_data                        = '0;
      for (int j = 0 ; j < 32 ; j++) begin
        vf_cfg[i].msi_cfg[j].enable             = '0;
        vf_cfg[i].msi_cfg[j].addr               = '0;
        vf_cfg[i].msi_cfg[j].data               = '0;
        vf_cfg[i].msi_cfg[j].is_ldb             = '0;
        vf_cfg[i].msi_cfg[j].cq                 = '0;
      end 
    end 

    foreach (vdev_cfg[i]) begin
      vdev_cfg[i].provisioned                     = '0;
      vdev_cfg[i].enable                          = '0;

      for (int cq=0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
        vdev_cfg[i].ldb_cq_xlate_qid[cq]        = -1;
      end 
      for (int qid=0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
        vdev_cfg[i].ldb_vqid_cfg[qid].provisioned       = '0;
        vdev_cfg[i].ldb_vqid_cfg[qid].enable            = '0;
        vdev_cfg[i].ldb_vqid_cfg[qid].vqid_v            = '0;
        vdev_cfg[i].ldb_vqid_cfg[qid].qid               = '0;
      end 
      for (int qid=0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
        vdev_cfg[i].dir_vqid_cfg[qid].provisioned       = '0;
        vdev_cfg[i].dir_vqid_cfg[qid].enable            = '0;
        vdev_cfg[i].dir_vqid_cfg[qid].vqid_v            = '0;
        vdev_cfg[i].dir_vqid_cfg[qid].qid               = '0;
      end 
    end 

    for (int x=0;x<hqm_pkg::NUM_LDB_QID;x++) begin
      for (int y=0;y<16;y++) begin
        for (int z=0;z<4;z++) begin
            qid2cqidix_table[z][y][x] = 0;
        end 
      end 
    end 

    cfg_64bytes_qe_ldb_cq_mode_field = null;
    cfg_64bytes_qe_dir_cq_mode_field = null;


    //--08122022 ral.get_reg_files(mfiles);

    //--08122022 foreach (mfiles[file_name]) begin
    //--08122022   if (mfiles[file_name].get_file_name() inside {ral_cfg_files}) begin
    //--08122022     mfiles[file_name].get_regs(mregs);
    //--08122022     foreach (mregs[reg_name]) begin
    //--08122022       mregs[reg_name].set_cfg_val(mregs[reg_name].get());
    //--08122022     end 
    //--08122022   end 
    //--08122022 end 

    ral.get_blocks(mfiles);

    foreach (mfiles[file_name]) begin
      if (mfiles[file_name].get_name inside {ral_cfg_files}) begin
        mfiles[file_name].get_registers(mregs);
        foreach (mregs[reg_name]) begin
          slu_ral_db::regs.set_cfg_val(mregs[reg_name], mregs[reg_name].get_mirrored_value());
        end 
      end 
    end 

    hqm_alarm_issued=0;
    hqm_alarm_count=0;
    hqm_atsinvcpl_done=0;

   `uvm_info(get_full_name(),$psprintf("HQM%0s__reset_hqm_cfg tb_env_hier=%s",inst_suffix, tb_env_hier), UVM_LOW)

    //--08122022 func_bar_u_reg                      = ral.find_reg_by_file_name("func_bar_u",{tb_env_hier,".hqm_pf_cfg_i"});
    //--08122022 func_bar_l_addr_l_field             = ral.find_field_by_name("addr_l","func_bar_l",{tb_env_hier,".hqm_pf_cfg_i"});

    hqm_pf_cfg_i             = ral.get_block_by_name({tb_env_hier,".hqm_pf_cfg_i"}); 
    func_bar_u_reg           = uvm_reg::m_get_reg_by_full_name({hqm_pf_cfg_i.get_full_name(), ".func_bar_u"}); // hqm_pf_cfg_i.get_reg_by_name("func_bar_u");            
    func_bar_l_reg           = uvm_reg::m_get_reg_by_full_name({hqm_pf_cfg_i.get_full_name(), ".func_bar_l"}); // hqm_pf_cfg_i.get_reg_by_name("func_bar_l");            
    func_bar_l_addr_l_field  = uvm_reg_field::m_get_field_by_full_name({func_bar_l_reg.get_full_name(), ".addr_l"}); 
  endfunction : reset_hqm_cfg


  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
virtual function void build_phase(uvm_phase phase); 
    string str_val;
    longint value;
    uvm_object o_tmp;

    super.build_phase(phase);
    hcw_gen_port = new("hcw_gen_port", this);
    cfg_pending = new();
    is_randomized = 0;
    if ($test$plusargs("HQM_CFG_BACKDOOR_CFG")) begin
      set_cfg_val_op = HQM_CFG_BWRITE;
      set_cfg_val_op_write = HQM_CFG_CWRITE;
    end else if ($test$plusargs("HQM_CFG_WRITE")) begin
      set_cfg_val_op = HQM_CFG_WRITE;
      set_cfg_val_op_write = HQM_CFG_WRITE;
    end else begin
      set_cfg_val_op = HQM_CFG_CWRITE;
      set_cfg_val_op_write = HQM_CFG_CWRITE;
    end 
    backdoor_mem_update_enable = $test$plusargs("HQM_CFG_BACKDOOR_MEM");
    if($test$plusargs("HQM_CFG_BACKDOOR_MEM_UNDO")) backdoor_mem_update_enable=0;
    eot_status=128'h0;
    perfck_sel=0;
    $value$plusargs("perfck_sel=%h", perfck_sel);
    perfck_tolerance_0=1000;
    $value$plusargs("perfck_tolerance_0=%d", perfck_tolerance_0);
    $value$plusargs("perfck_tolerance_1=%d", perfck_tolerance_1);
    $value$plusargs("perfck_tolerance_2=%d", perfck_tolerance_2);
    `uvm_info("HQM_CFG",$psprintf("HQM%0s__Get perfck_sel value=0x%0x  perfck_tolerance_0=%0d; backdoor_mem_update_enable=%0d tb_env_hier=%0s set_cfg_val_op=%0s set_cfg_val_op_write=%0s",inst_suffix,perfck_sel, perfck_tolerance_0,perfck_tolerance_1,perfck_tolerance_2, backdoor_mem_update_enable, tb_env_hier, set_cfg_val_op, set_cfg_val_op_write),UVM_LOW)

    cur_sai = 8'h03;

    if ($value$plusargs({"HQM_CFG_DEFAULT_SAI","=%s"}, str_val)) begin
      if (token_to_longint(str_val, value)) begin
        if ((value >= 0) && (value <= 255)) begin
          cur_sai = value;
        end else begin
          `uvm_error("HQM_CFG",$psprintf("HQM%0s__Illegal option - HQM_CFG_DEFAULT_SAI=%s",inst_suffix,str_val))
        end 
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__Illegal option - HQM_CFG_DEFAULT_SAI=%s",inst_suffix,str_val))
      end 
    end 

    `uvm_info("HQM_CFG",$psprintf("HQM%0s__Current SAI value = 0x%02x",inst_suffix,cur_sai),UVM_LOW)

    if (!uvm_config_object::get(this, "",{"i_hqm_pp_cq_status",inst_suffix}, o_tmp)) begin
      uvm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
    end 

    if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
      uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
    end 

    command_parser = new();
  endfunction : build_phase

  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);


    ////--08122022 $cast(ral, sla_ral_env::get_ptr());
    //--?? ral = slu_ral_db::get_regmodel();
    //--?? ral = uvm_reg_block::find_block({tb_env_hier,".aqed_pipe"}, slu_ral_db::get_regmodel());
    //--?? ral = uvm_reg_block::find_block({tb_env_hier});
    $cast(ral, slu_ral_db::get_regmodel()); 

    if (ral == null) begin
      uvm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    reset_hqm_cfg();

    set_cfg_end();
  endfunction

  //--------------------------------------------------------------  
  //
  //--------------------------------------------------------------  
  function void set_tb_env(slu_tb_env m_env);
     tb_env = m_env;
  endfunction
  //--------------------------------------------------------------  
  function void set_remove_duplicate(bit state);
     this.remove_duplicate = state;
  endfunction  
  //--------------------------------------------------------------  
  //
  //--------------------------------------------------------------  
 function void pre_randomize();
    super.pre_randomize();
 endfunction
 //------------------------- 
 // Function: post_randomize
 // SV function overload for randomizing this class
 //------------------------- 
 function void post_randomize();
   super.post_randomize();
   this.update_CHP_cfg = 1;
   this.update_LSP_cfg = 1;
   this.update_DP_cfg = 1;
   this.update_AP_cfg = 1;
   this.update_NALB_cfg = 1;
   this.update_ROP_cfg = 1;
   this.update_MASTER_cfg = 1;
   this.update_CFG_RING_cfg = 1;
   this.update_DQED_cfg = 1;
   this.update_AQED_cfg = 1;
   this.update_QED_cfg = 1;
   this.update_configuration();
   this.print();
 endfunction
   
  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
  virtual function void set_hqm_bdf(input bit [15:0] bdf);
    this.hqm_bdf = bdf;
  endfunction

  virtual function bit [15:0] get_hqm_bdf();
    get_hqm_bdf = this.hqm_bdf;
  endfunction

  //--------------------------------------------------------------------------------
  //--HQMV30_O2U_RAL
  //--------------------------------------------------------------------------------
  function uvm_reg_field hqm_find_field_by_name(string field_name, string reg_name, string full_file_name);
     uvm_reg_block           hqm_reg_block; 
     uvm_reg                 hqm_reg; 

       hqm_reg_block          = ral.get_block_by_name(full_file_name);                                               //--ral.get_block_by_name({tb_env_hier,".full_file_name"}); 
       hqm_reg                = uvm_reg::m_get_reg_by_full_name({hqm_reg_block.get_full_name(), ".", reg_name});     // hqm_reg_block.get_reg_by_name("reg_name");            
       hqm_find_field_by_name = uvm_reg_field::m_get_field_by_full_name({hqm_reg.get_full_name(), ".", field_name}); 
       `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG:hqm_find_field_by_name: full_file_name=%0s, reg_name=%0s, field_name=%0s => hqm_find_field_by_name=%p", inst_suffix, full_file_name, reg_name, field_name, hqm_find_field_by_name),UVM_MEDIUM)
      
  endfunction: hqm_find_field_by_name



  function uvm_reg hqm_find_reg_by_file_name(string reg_name, string full_file_name);
     uvm_reg_block           hqm_reg_block; 
     uvm_reg                 hqm_reg; 

       hqm_reg_block               = ral.get_block_by_name(full_file_name);                                               //--ral.get_block_by_name({tb_env_hier,".full_file_name"}); 
       hqm_find_reg_by_file_name   = uvm_reg::m_get_reg_by_full_name({hqm_reg_block.get_full_name(), ".", reg_name});     // hqm_reg_block.get_reg_by_name("reg_name");            
       `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG:hqm_find_reg_by_file_name: full_file_name=%0s, reg_name=%0s => hqm_find_reg_by_file_name=%p", inst_suffix, full_file_name, reg_name, hqm_find_reg_by_file_name),UVM_MEDIUM)
  endfunction: hqm_find_reg_by_file_name


 //---------------------------------------------------------------------------- 
 //-- other supporting functions 
 //----------------------------------------------------------------------------   
 extern   virtual         function   string       convert2string();
 extern   virtual         function   void         do_print(uvm_printer printer);
 extern   virtual         function   void         do_copy(uvm_object rhs);
 extern   virtual         function   bit          do_compare(uvm_object rhs, uvm_comparer comparer);
    
 extern   virtual         function   void         set_cfg_begin();
 extern   virtual         function   void         set_cfg_end(hqm_cfg_command command=null);
 extern   virtual         task                    set_cfg(input string commands, output bit do_cfg_seq);
 extern   virtual         task                    get_cfg(input string commands, output bit [31:0] value);
 extern   virtual         task                    backdoor_mem_init();
 extern   virtual         task                    write_hcw_gen_port(hcw_transaction hcw_trans);

 extern        virtual function        bit             decode_pp_addr(input logic [63:0] address,
                                                                      output int pp_num,
                                                                      output int pp_type,
                                                                      output bit is_pf,
                                                                      output int vf_num,
                                                                      output int vpp_num,
                                                                      output bit is_nm_pf);

 extern        virtual function        bit             decode_cq_addr(input logic [63:0] address,
                                                                      input int byte_length,
                                                                      output int cq_num,
                                                                      output int cq_type,
                                                                      output bit is_pf,
                                                                      output int vf_num,
                                                                      output int vcq_num,
                                                                      output int cq_index,
                                                                      output int max_cq_index);

 extern        virtual function        bit             decode_msix_cq_int_addr(input  int        msix_int_num,
                                                                               output int        cq_num,
                                                                               output int        cq_type);

 extern        virtual function        bit             decode_cq_int_addr(input  logic [63:0]   address,
                                                                          input  logic [31:0]   data,
                                                                          input  logic [15:0]   rid,
                                                                          output bit            is_ims_int,
                                                                          output int            int_vector,
                                                                          output int            cq_num,
                                                                          output int            cq_type);

 extern        virtual function        bit             decode_comp_msix_cq_int_addr(input logic [63:0]    address,
                                                                                    input logic [31:0]    data,
                                                                                    input  logic [15:0]   rid);

 extern        virtual function        bit             decode_msix_int_addr(input  logic [63:0]  address,
                                                                            input  logic [31:0]  data,
                                                                            input  logic [15:0]  rid,
                                                                            output int           msix_num);

 extern        virtual function        bit             decode_ims_poll_addr(input  logic [63:0] address,
                                                                            input  logic [31:0] data,
                                                                            input  logic [15:0] rid,
                                                                            output int          cq_num,
                                                                            output int          cq_type);

// extern        virtual function        void            check_pp_cacheline_addr(input logic [63:0] address, bit is_ldb, int pp_num);

 extern        virtual function        bit [63:0]      get_ims_poll_addr(input  int     cq_num,
                                                                         input  int     cq_type);

 extern        virtual function        bit [63:0]      get_ims_addr(input  int     cq_num,
                                                                         input  int     cq_type);

 extern        virtual function        bit             get_ims_ctrl( input int cq_type, int cq_num);

 extern        virtual function        bit             get_name_val(string name, output int val);

 extern        virtual function        bit             set_name_val(string name, int val, string name_context);

 extern        virtual function        bit             is_single_hcw_per_cl(bit is_ldb);

 extern        virtual function        bit             set_sequential_names(bit is_seq);

 extern        virtual function        logic [hqm_pkg::PP_ARCH_WIDTH-1:0]     get_pf_pp(bit is_vf,
                                                                  int vf_num,
                                                                  bit is_ldb,
                                                                  int vpp,
                                                                  bit ignore_v = 1'b0
                                                                );

 extern        virtual function        logic [hqm_pkg::QID_ARCH_WIDTH-1:0]     get_pf_qid(bit is_vf,
                                                                  int vf_vdev_num,
                                                                  bit is_ldb,
                                                                  int vqid,
                                                                  bit ignore_v = 1'b0,
                                                                  bit is_nm_pf = 1'b0
                                                                );

 extern        virtual function        logic [hqm_pkg::QID_ARCH_WIDTH-1:0]     get_sciov_qid( bit is_ldb_pp, 
                                                                      int pp,
                                                                      bit is_ldb,  //--this arg is: ldb qtype or dir qtype
                                                                      int vqid,
                                                                      bit ignore_v = 1'b0,
                                                                      bit is_nm_pf = 1'b0
                                                                    );

 extern        virtual function        int             get_vqid( int qid,
                                                                 bit is_ldb
                                                              );

 extern        virtual function        int             get_vcq( int cq,
                                                                int vf_num,
                                                                bit is_ldb,
                                                                bit ignore_v = 1'b0
                                                              );

 extern        virtual function        int             get_msi_num( int cq,
                                                                    int vf_num,
                                                                    bit is_ldb
                                                                  );

 extern        virtual function        hqm_iov_mode_t  get_iov_mode();

 extern        virtual function        bit             is_pf_mode();

 extern        virtual function        bit             is_sriov_mode();

 extern        virtual function        bit             is_sciov_mode();

 extern        virtual function        int             get_vdev(
                                                                bit is_ldb,
                                                                int pp
                                                              );

 extern        virtual function        int             get_pasid(
                                                                bit is_ldb,
                                                                int pp
                                                              );

 extern        virtual function        int             get_vas(
                                                                bit is_ldb,
                                                                int pp
                                                              );

 extern        virtual function        int             get_vasfromcq(
                                                                bit is_ldb,
                                                                int cq
                                                              );

 extern        virtual function        int             get_cq_depth(
                                                                bit is_ldb,
                                                                int cq
                                                              );

 extern        virtual function        bit             is_vpp_v(
                                                                        int vf_num,
                                                                        bit is_ldb,
                                                                        int vpp_num
                                                               );

 extern        virtual function        bit             is_vqid_v(
                                                                        int vf_num,
                                                                        bit is_ldb,
                                                                        int vqid_num
                                                               );

 extern        virtual function        bit             is_pp_v(
                                                                        bit is_ldb,
                                                                        int pp_num
                                                               );

 extern        virtual function        bit             is_sciov_pp_v(
                                                                        bit is_ldb,
                                                                        int pp
                                                               );

 extern        virtual function        bit             is_qid_v(
                                                                        bit is_ldb,
                                                                        int qid_num
                                                               );

 extern        virtual function        bit             is_sciov_vqid_v(
                                                                        bit is_ldb_pp,
                                                                        int pp,
                                                                        bit is_ldb,
                                                                        int vqid
                                                               );

 extern        virtual function        bit             is_ao_qid_v(
                                                                        int qid_num
                                                               );
 extern        virtual function        bit             is_fid_qid_v(
                                                                        int qid_num
                                                               );

 extern        virtual function        bit             is_sn_qid_v(
                                                                        int qid_num
                                                               );

 extern        virtual function        bit             is_vasqid_v(
                                                                        int vas,
                                                                        bit is_ldb,
                                                                        int qid_num
                                                               );

 extern         virtual function        void            update_msix_cfg();

 extern         virtual function        int             get_msix_vector(input logic is_compress_mode, logic [63:0] address, logic [31:0] data);

 extern         virtual function        int             get_ims_idx(input bit is_ldb, int cq_num);

 extern         virtual function        void            update_ims_cfg();

 extern         virtual function        int             get_num_msix();
 extern         virtual function        int             get_num_msi(int vf_num);
 extern         virtual function        int             get_num_dir_ims();
 extern         virtual function        int             get_num_ldb_ims();

 extern         virtual function        bit             get_ims_vector(input logic [63:0] address,
                                                                       input logic [31:0] data, 
                                                                       output logic       is_ldb,
                                                                       output int         cq_num);

 extern         virtual function        bit             is_legal_sai(input uvm_access_e   op,
                                                                     input logic [7:0]  sai8,
                                                                     input string file_name,
                                                                     input string reg_name);

 extern        virtual function        void            set_max_cacheline_num(
                                                                bit is_ldb,
                                                                int pp,
                                                                int max_cacheline_num,
                                                                int start_cl_addr 
                                                              );

 extern        virtual function        int             get_max_cacheline_num(
                                                                bit is_ldb,
                                                                int pp
                                                              );

 extern        virtual function        int             get_cl_rob(
                                                                bit is_ldb,
                                                                int pp
                                                              );

 //protected function/tasks
 extern   virtual protected function void         validate_configuration(bit end_test_if_invalid = 1);
 extern   virtual protected function void         update_configuration();
 extern   virtual protected function int          decode_option_value(int prov[$], hqm_cfg_command_options option);
 extern   virtual           function bit [63:0]   decode_gpa(hqm_cfg_command_options option,int idx,string mem_name, bit [63:0] mem_size, bit [63:0] mem_mask, string mem_region = "DRAM_HIGH");
 extern   virtual           function bit [63:0]   decode_cq_gpa(hqm_cfg_command_options option,int idx,string mem_name, bit [63:0] mem_size, bit [63:0] mem_mask, bit is_ldb, int cq);
 extern   virtual           function bit [63:0]   decode_msix_addr(hqm_cfg_command_options option,int idx, int msix, bit is_ldb, int cq);
 extern   virtual           function bit [63:0]   decode_msi_addr(hqm_cfg_command_options option,int idx, int vf);
 extern   virtual           function bit [63:0]   decode_ims_addr(hqm_cfg_command_options option,int idx, bit is_ldb, int cq_num);
 extern   virtual           function bit [63:0]   allocate_dram(string mem_name, bit [63:0] mem_size, bit [63:0] mem_mask, bit sriov_en = 1'b0, bit sciov_en = 1'b0, bit [7:0] func_num, int vdev = -1, ref int pasid = -1);
 extern   virtual           function bit [63:0]   allocate_msix_addr(string mem_name, int msix);
 extern   virtual           function bit [63:0]   allocate_msi_addr(string mem_name, bit [7:0] func_num);
 extern   virtual           function bit [63:0]   allocate_ims_addr(string mem_name, int vdev = -1);
 extern   virtual protected function bit [31:0]   get_cfg_value();
 extern   virtual protected function bit [31:0]   get_act_value();
 extern   virtual           function uvm_reg_data_t get_act_ral_val(string file_name, string reg_name, string field_name);
 extern   virtual protected function void         set_cfg_val(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, string field_name, uvm_reg_data_t value);
 extern   virtual function void         set_cfg_val_index(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, int index, string field_name, uvm_reg_data_t value);
 extern   virtual           function void         or_cfg_val(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, string field_name, uvm_reg_data_t value);
 extern   virtual           function void         and_cfg_val(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, string field_name, uvm_reg_data_t value);
 extern   virtual protected function void         set_reg_cfg_val(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, uvm_reg_data_t value);
 extern   virtual protected function bit          set_act_val(string file_name, string reg_name, string field_name, uvm_reg_data_t value);
 extern   virtual protected function bit          set_act_val_index(string file_name, string reg_name, int index, string field_name, uvm_reg_data_t value);
 extern   virtual protected function bit          or_act_val(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, string field_name, uvm_reg_data_t value);
 extern   virtual protected function bit          set_reg_val(string file_name, string reg_name, uvm_reg_data_t value);
 extern   virtual protected function bit          set_reg_val_index(string file_name, string reg_name, int index, uvm_reg_data_t value);
 extern   virtual protected function bit          set_field_val(string file_name, string reg_name, string field_name, uvm_reg_data_t value);
 extern   virtual protected function int          resolve_name(input string label_value_str,
                                                               input int    label_value,
                                                               input int    max_val);
 extern   virtual protected function int          resolve_value(input hqm_cfg_command command,
                                                                input int ldb_size,
                                                                input int dir_size,
                                                                ref   int avail_ldb[$],
                                                                ref   int avail_dir[$],
                                                                ref   int prov_ldb[$],
                                                                ref   int prov_dir[$]);

 //sequence releated
 extern   virtual protected function void         add_register_to_access_list( string file_name,
                                                                               string reg_name,
                                                                               string field_name,
                                                                               hqm_cfg_reg_ops_t ops,
                                                                               uvm_reg_data_t exp_rd_val=0,
                                                                               uvm_reg_data_t exp_rd_mask=0,
                                                                               int poll_delay=0,
                                                                               int poll_timeout=4000,
                                                                               longint offset=0,
                                                                               bit [7:0] sai);

 extern   virtual           function hqm_cfg_register_ops get_next_register_from_access_list();

 //command handlers
 //handler should be implment for each type of commands
 extern   virtual protected function hqm_command_handler_status_t       names_command_handler(ref hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       hcw_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       mem_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       qid_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       pp_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       cq_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       msix_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       ims_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       vas_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       vf_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       vdev_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       reg_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       util_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       command_decode(string commands,bit ignore_unknown = 1'b0);
     
 extern   virtual protected function hqm_command_handler_status_t       sysrst_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       runtest_command_handler(hqm_cfg_command command);
    
 extern   virtual function bit option_dec_index(string opt_in, string opt_prefix, string opt_suffix, output int opt_val);

 extern   virtual function void set_ral_access_path(string access);
 extern   virtual function void add_ral_skip_files(string file);
 extern   virtual function void add_ral_cfg_files(string file);
 extern   virtual function void set_ral_type(string ral_type);
 extern   virtual function void set_ral_env(uvm_reg_block ral_env);
 extern   virtual function uvm_reg_block get_ral_env();

 extern   virtual function int reserve_qid  (int is_ldb, int exp_qid=-1);
 extern   virtual function int reserve_cq   (int is_ldb, int exp_cq=-1);
 extern   virtual function int reserve_pp   (int is_ldb, int exp_pp=-1);
 extern   virtual function int reserve_vpp    (int is_ldb, int vf, int u_vpp  = -1, int pp  = -1);
 extern   virtual function int reserve_vcq  (int is_ldb, int vf, int u_vcq  = -1, int cq  = -1);
 extern   virtual function int reserve_vqid (int is_ldb, int vf, int u_vqid = -1, int qid = -1);
 extern   virtual function  longint        get_pp_address(int ppid, int is_ldb=0, int is_nm_pf=0, int vfid=-1);

 extern   virtual function get_avail_resources(int is_ldb, string res);
 extern   virtual function release_qid  (int is_ldb, int qid_id);
 extern   virtual function release_cq   (int is_ldb, int cq_id);
 extern   virtual function release_pp   (int is_ldb, int pp_id);

 extern   virtual function bit decode_func_pf_addr(input logic [63:0] address);
 extern   virtual function bit decode_csr_pf_addr (input logic [63:0] address);
 extern   virtual function bit decode_pf_cfg_addr (input logic [63:0] address);

 extern   virtual function bit  is_pad_first_write (bit is_ldb);
 extern   virtual function bit  is_pad_write       (bit is_ldb);
 extern   virtual function bit  is_disable_wb_opt  (bit is_ldb, int cq);
 extern   virtual function bit  is_early_dir_int   ();

 //--AY_HQMV30_ATS_SUPPORT
 extern   virtual function bit[63:0]  getFreeSpaceForPage(input bit[15:0] bdf, HqmPasid_t pasidtlp, HqmAtsPkg::PageSize_t pageSize, bit [63:0] physical_addr, bit[2:0] translationType = 2, bit[2:0] aw = 3);
 extern   virtual function bit        isAddrInInterruptRange(bit[63:0] addr);
 extern   virtual function bit[63:0]  getRandomAddr(HqmAtsPkg::PageSize_t pageSize, bit [63:0] physical_addr, bit[2:0] translationType=2,  bit[2:0] aw = 3);

 extern   virtual function bit        decode_cq_ats_request(input logic [63:0] address, //--virtual addr
                                                                      input int byte_length,
                                                                      output int cq_num,
                                                                      output int cq_type,
                                                                      output bit is_pf,
                                                                      output int vf_num,
                                                                      output int vcq_num);
 extern   virtual function bit        decode_cq_ats_response(input logic [63:0] address, //--ATS Resp CplD - translation addr with translation completion data fiels [11:0]
                                                             input logic [15:0] reqid,
                                                                      input  HqmAtsPkg::PageSize_t pagesize,
                                                                      output int cq_num,
                                                                      output int cq_type,
                                                                      output bit is_pf,
                                                                      output int vf_num,
                                                                      output int vcq_num);

 extern   virtual function bit        decode_cq_by_ats_response_txnid(input HqmTxnID_t txnid, //--ATS Resp CplD - use txnid to find out corresponding cq  
                                                                      output int cq_num,
                                                                      output int cq_type,
                                                                      output bit is_pf,
                                                                      output int vf_num,
                                                                      output int vcq_num);

 extern   virtual function            set_ats_request_txn_id(input int is_ldb, 
                                                                      input int cq_num,
                                                                      input HqmTxnID_t cq_txnid);

 extern   virtual function            update_hpa_by_ats_response(input int is_ldb, 
                                                                      input int cq_num,
                                                                      input HqmPcieCplStatus_t completion_status,
                                                                      input logic [63:0] cq_hpa_addr,
                                                                      input HqmAtsPkg::PageSize_t pagesize);

 extern   virtual function bit[63:0]  get_hpa_from_gpa(input int is_ldb, 
                                                                      input int cq_num,
                                                                      input logic [63:0] cq_virt_addr);

 extern   virtual function bit[63:0]  get_cq_hpa(input int is_ldb, input int cq_num);

 extern   virtual function            set_atsinvreq_txn_id(input int is_ldb, input int cq_num,input HqmTxnID_t cq_txnid);

 extern   virtual function bit        decode_cq_by_atsinvresp_txn_id(input HqmTxnID_t txnid, int clear_queue, output int cq_num, output int cq_type, output bit is_pf, output int vf_num, output int vcq_num);

endclass : hqm_cfg
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function void hqm_cfg::set_ral_access_path(string access);
  this.ral_access_path = access;
  uvm_report_info("CFG", $psprintf("HQM%0s__SET ACCESS PATH -> %s", inst_suffix,this.ral_access_path), UVM_MEDIUM);  
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function void hqm_cfg::add_ral_skip_files(string file);
  this.ral_skip_files.push_back(file);
  uvm_report_info("CFG", $psprintf("HQM%0s__ADD SKIP FILE -> %s", inst_suffix,file), UVM_MEDIUM);  
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function void hqm_cfg::add_ral_cfg_files(string file);
  this.ral_cfg_files.push_back(file);
  uvm_report_info("CFG", $psprintf("HQM%0s__ADD CFG FILE -> %s", inst_suffix,file), UVM_MEDIUM);  
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function void hqm_cfg::set_ral_type(string ral_type);
  this.ral_type = ral_type;
  uvm_report_info("CFG", $psprintf("HQM%0s__SET RAL_TYPE -> %s", inst_suffix,this.ral_type), UVM_MEDIUM);  
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function void hqm_cfg::set_ral_env(uvm_reg_block ral_env);
  this.ral = ral_env;
  uvm_report_info("CFG", $psprintf("HQM%0s__SET RAL ENV -> %s", inst_suffix,this.ral.get_type_name()), UVM_LOW);  
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function uvm_reg_block hqm_cfg::get_ral_env();
  get_ral_env = ral;
  uvm_report_info("CFG", $psprintf("HQM%0s__get_ral_env -> %s", inst_suffix, this.ral.get_full_name()), UVM_LOW);  
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function int hqm_cfg::resolve_value(input hqm_cfg_command command,
                                    input int ldb_size,
                                    input int dir_size,
                                    ref int avail_ldb[$],
                                    ref int avail_dir[$],
                                    ref int prov_ldb[$],
                                    ref int prov_dir[$]);

  int idx;

  if (command.label_value_str == "*") begin
    if (command.get_type() == HQM_CFG_DIR) begin
      if (avail_dir.size() > 0) begin
        if (sequential_names) begin
          idx = 0;
        end else begin
          idx = $urandom_range(avail_dir.size()-1,0);
        end 
        resolve_value = avail_dir[idx];
        avail_dir.delete(idx);
        prov_dir.push_back(resolve_value);
      end else begin
        `uvm_error("HQM_CFG",$psprintf("* not supported in this context"))
        resolve_value = -1;
      end 
    end else begin      // every command other than HQM_CFG_DIR uses avail_ldb
      if (avail_ldb.size() > 0) begin
        if (sequential_names) begin
          idx = 0;
        end else begin
          idx = $urandom_range(avail_ldb.size()-1,0);
        end 
        resolve_value = avail_ldb[idx];
        avail_ldb.delete(idx);
        prov_ldb.push_back(resolve_value);
      end else begin
        `uvm_error("HQM_CFG",$psprintf("* not supported in this context"))
        resolve_value = -1;
      end 
    end 
  end else begin
    // if not a valid integer value check if referencing defined label
    if (command.label_value < 0) begin
      if (((command.get_type() == HQM_CFG_DIR) ||
           (command.get_type() == HQM_CFG_LDB) ||
           (command.get_type() == HQM_CFG_MSIX_CQ) ||
           (command.get_type() == HQM_CFG_MSIX_ALARM) ||
           (command.get_type() == HQM_CFG_VAS) ||
           (command.get_type() == HQM_CFG_VF) ||
           (command.get_type() == HQM_CFG_VDEV) ||
           (command.get_type() == HQM_HCW_ENQ) ||
           (command.get_type() == HQM_HCWS_ENQ)) &&
          (names.exists(command.label_value_str))) begin
        resolve_value = names[command.label_value_str];
      end else begin
        resolve_value = command.label_value;  // illegal value
      end 
    end else begin
      int qi[$];

      resolve_value = command.label_value;    // integer value

      if (command.get_type() == HQM_CFG_DIR) begin
        qi = prov_dir.find_index with ( item == resolve_value);

        if (qi.size() == 0) begin
          prov_dir.push_back(resolve_value);

          qi = avail_dir.find_index with ( item == resolve_value);

          if (qi.size() > 0) begin
            avail_dir.delete(qi[0]);
          end else begin
            `uvm_error("HQM_CFG",$psprintf("HQM%0s__Inconsistent prov_dir/avail_dir lists for value %0d",inst_suffix,resolve_value))
          end 
        end 
      end else begin
        qi = prov_ldb.find_index with ( item == resolve_value);

        if (qi.size() == 0) begin
          prov_ldb.push_back(resolve_value);

          qi = avail_ldb.find_index with ( item == resolve_value);

          if (qi.size() > 0) begin
            avail_ldb.delete(qi[0]);
          end else begin
            `uvm_error("HQM_CFG",$psprintf("HQM%0s__Inconsistent prov_ldb/avail_ldb lists for value %0d",inst_suffix,resolve_value))
          end 
        end 
      end 
    end 
  end 

  if (command.get_type() == HQM_CFG_LDB) begin
    if ((resolve_value >= 0) && (resolve_value < ldb_size)) begin
      if (command.label != "") begin
        set_name_val(command.label,resolve_value,"LDB");
      end 
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__LDB value %d outside of valid range %d - %d)",inst_suffix,resolve_value,0,ldb_size-1))
      resolve_value = -1;
    end 
  end else if (command.get_type() == HQM_CFG_MSIX_CQ) begin
    if ((resolve_value >= ldb_size) && (resolve_value < dir_size)) begin
      if (command.label != "") begin
        set_name_val(command.label,resolve_value,"MSIX_CQ");
      end 
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__MSIX_CQ value %d outside of valid range %d - %d)",inst_suffix,resolve_value,ldb_size,dir_size-1))
      resolve_value = -1;
    end 
  end else if (command.get_type() == HQM_CFG_VAS) begin
    if ((resolve_value >= 0) && (resolve_value < ldb_size)) begin
      if (command.label != "") begin
        set_name_val(command.label,resolve_value,"VAS");
      end 
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__VAS value %d outside of valid range %d - %d)",inst_suffix,resolve_value,0,ldb_size-1))
      resolve_value = -1;
    end 
  end else if (command.get_type() == HQM_CFG_VF) begin
    if ((resolve_value >= 0) && (resolve_value < ldb_size)) begin
      if (command.label != "") begin
        set_name_val(command.label,resolve_value,"VF");
       `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG:command.label=%0s, resolve_value=%0d, VF",inst_suffix,command.label, resolve_value),UVM_MEDIUM)
      end 
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__VF value %d outside of valid range %d - %d)",inst_suffix,resolve_value,0,ldb_size-1))
      resolve_value = -1;
    end 
  end else if (command.get_type() == HQM_CFG_VDEV) begin
    if ((resolve_value >= 0) && (resolve_value < ldb_size)) begin
      if (command.label != "") begin
        set_name_val(command.label,resolve_value,"VDEV");
      end 
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__VDEV value %d outside of valid range %d - %d)",inst_suffix,resolve_value,0,ldb_size-1))
      resolve_value = -1;
    end 
  end else begin
    if ((resolve_value >= 0) && (resolve_value < dir_size)) begin
      if (command.label != "") begin
        set_name_val(command.label,resolve_value,"DIR");
      end 
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__directed value %d outside of valid range %d - %d)",inst_suffix,resolve_value,0,dir_size-1))
      resolve_value = -1;
    end 
  end 
endfunction

//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function int hqm_cfg::resolve_name(input string label_value_str,
                                   input int    label_value,
                                   input int    max_val);

  // if not a valid integer value check if referencing defined label
  if (label_value < 0) begin
    if (names.exists(label_value_str)) begin
      resolve_name = names[label_value_str];
    end else begin
      resolve_name = label_value;  // illegal value
    end 
  end else begin
    resolve_name = label_value;  // illegal value
  end 

  if ((resolve_name < 0) || (resolve_name > max_val)) begin
    `uvm_error("HQM_CFG",$psprintf("HQM%0s__dValue %d outside of valid range %d - %d)",inst_suffix,resolve_name,0,max_val))
    resolve_name = -1;
  end 
endfunction

//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::names_command_handler(ref hqm_cfg_command command);
    int qid;
    int idx;
    hqm_cfg_command_options option;
    string              explode_q[$];
    string              new_target;

    names_command_handler = HQM_CFG_CMD_NOT_DONE;

    explode_q.delete();

    lvm_common_pkg::explode(":",command.get_target(),explode_q);

    if (explode_q.size() > 1) begin
      new_target = "";

      foreach (explode_q[j]) begin
        if (names.exists(explode_q[j])) begin
          new_target = {new_target,$psprintf("%0d",names[explode_q[j]])};
        end else begin
          new_target = {new_target,explode_q[j]};
        end 
      end 

      command.set_target(new_target);
    end 
    
    for (int i=0;i<command.options.size;i++) begin
      explode_q.delete();

      lvm_common_pkg::explode(":",command.options[i].option.tolower(),explode_q);

      if (explode_q.size() > 1) begin
        command.options[i].option = "";

        foreach (explode_q[j]) begin
          if (names.exists(explode_q[j])) begin
            command.options[i].option = {command.options[i].option,$psprintf("%0d",names[explode_q[j]])};
          end else begin
            command.options[i].option = {command.options[i].option,explode_q[j]};
          end 
        end 
      end 

      if (command.options[i].randmization_type == STRING_TYPE) begin
        if (names.exists(command.options[i].str_value)) begin
          command.options[i].values.push_back(names[command.options[i].str_value]);
          command.options[i].randmization_type = FIXED_VAL_TYPE;
        end 
      end 
    end 
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::hcw_command_handler(hqm_cfg_command command);
  int                   ppid_val;
  int                   idx;
  bit                   iptr_set;
  sla_sm_env            sm;
  sla_sm_ag_status_t    status;
  sla_sm_ag_result      desc_mem;
  addr_t                addr;
  byte_t                data[$];
  bit                   be[$];
  hcw_transaction       to_q;
  bit [127:0]           hcw_data;
  bit [63:0]            pp_addr;
  bit                   dis_random_sai   = $test$plusargs("HQM_DIS_RANDOM_SAI");

  hcw_command_handler = HQM_CFG_CMD_NOT_DONE;

  if (command.get_type() != HQM_HCW_ENQ) begin
    return(hcw_command_handler);
  end 

  if (((command.label != "dir") && (command.label != "ldb")) || ((command.label_value < 0) && (command.label_value_str == ""))) begin
    `uvm_error("HQM_CFG HCW",$psprintf("HQM%0s__Illegal PP value",inst_suffix))
    return(hcw_command_handler);
  end 

  `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

  iptr_set = 0;

  hcw_trans = hcw_transaction::type_id::create("hcw_trans");

  hcw_trans.randomize();

  hcw_trans.rsvd0               = '0;
  hcw_trans.dsi_error           = '0;
  hcw_trans.cq_int_rearm        = '0;
  hcw_trans.no_inflcnt_dec      = '0;
  hcw_trans.dbg                 = '0;
  hcw_trans.cmp_id              = '0;
  hcw_trans.is_nm_pf            = '0;
  hcw_trans.is_vf               = '0;
  hcw_trans.vf_num              = '0;
  //hcw_trans.sai                 = cur_sai;
  hcw_trans.sai                 = dis_random_sai ? cur_sai : $urandom_range(0,255);
  hcw_trans.rtn_credit_only     = '0;
  hcw_trans.exp_rtn_credit_only = '0;
  hcw_trans.ingress_drop        = '0;
  hcw_trans.exp_ingress_drop    = '0;
  hcw_trans.ordqid              = '0;
  hcw_trans.ordpri              = '0;
  hcw_trans.ordlockid           = '0;
  hcw_trans.ordidx              = '0;
  hcw_trans.reord               = '0;
  hcw_trans.frg_cnt             = '0;
  hcw_trans.frg_last            = '0;

  if (command.label == "ldb") begin
    hcw_trans.is_ldb = 1;
    ppid_val = resolve_name(command.label_value_str,command.label_value,hqm_pkg::NUM_LDB_PP);
  end else begin
    hcw_trans.is_ldb = 0;
    ppid_val = resolve_name(command.label_value_str,command.label_value,hqm_pkg::NUM_DIR_PP);
  end 

  if (ppid_val < 0) begin
    return(hcw_command_handler);
  end 

  hcw_trans.ppid = ppid_val;
   
  for(int i=0;i<command.options.size;i++) begin
    if (command.options[i].values.size() > 0) begin
      idx = $urandom_range(0, command.options[i].values.size()-1);
    end else begin
      idx = -1;
    end 

    case (command.options[i].option.tolower())
      "sai": begin
        hcw_trans.sai = command.options[i].values[idx];
      end 
      "vf_num": begin
        if (idx >= 0) begin
          if ((command.options[i].values[idx] < 0) || (command.options[i].values[idx] >= hqm_pkg::NUM_VF)) begin   // maximum VF number is 15
            `uvm_error("HQM_CFG HCW",$psprintf("HQM%0s__Illegal vf_num value - %d", inst_suffix,command.options[i].values[idx]))
            return(hcw_command_handler);
          end else begin
            hcw_trans.is_vf = 1'b1;
            hcw_trans.vf_num = command.options[i].values[idx];
          end 
        end else begin
          ppid_val = resolve_name(command.options[i].str_value,-1,hqm_pkg::NUM_VF - 1);
          if (ppid_val >= 0) begin
            hcw_trans.is_vf = 1'b1;
            hcw_trans.vf_num = ppid_val;
          end else begin
            `uvm_error("HQM_CFG HCW",$psprintf("HQM%0s__Illegal vf_num name - %s",inst_suffix,command.options[i].str_value))
            return(hcw_command_handler);
          end 
        end 
      end 
      "is_nm_pf": begin
        hcw_trans.is_nm_pf              = command.options[i].values[idx];
      end 
      "batch": begin
        hcw_trans.hcw_batch             = command.options[i].values[idx];
      end 
      "ingress_drop": begin
        hcw_trans.ingress_drop          = command.options[i].values[idx];
      end 
      "exp_ingress_drop": begin
        hcw_trans.exp_ingress_drop      = command.options[i].values[idx];
      end 
      "rtn_credit_only": begin
        hcw_trans.rtn_credit_only       = command.options[i].values[idx];
      end 
      "exp_rtn_credit_only": begin
        hcw_trans.exp_rtn_credit_only   = command.options[i].values[idx];
      end 
      "dsi_error": begin
        hcw_trans.dsi_error = command.options[i].values[idx];
      end 
      "cq_int_rearm": begin
        hcw_trans.cq_int_rearm = command.options[i].values[idx];
      end 
      "qe_valid": begin
        hcw_trans.qe_valid = command.options[i].values[idx];
      end 
      "qe_orsp": begin
        hcw_trans.qe_orsp = command.options[i].values[idx];
      end 
      "qe_uhl": begin
        hcw_trans.qe_uhl = command.options[i].values[idx];
      end 
      "cq_pop": begin
        hcw_trans.cq_pop = command.options[i].values[idx];
      end 
      "cmd": begin
        hcw_trans.qe_valid  = command.options[i].values[idx][3];
        hcw_trans.qe_orsp   = command.options[i].values[idx][2];
        hcw_trans.qe_uhl    = command.options[i].values[idx][1];
        hcw_trans.cq_pop    = command.options[i].values[idx][0];
      end 
      "cmp_id": begin
        hcw_trans.cmp_id    = command.options[i].values[idx];
      end 
      "wu": begin
        hcw_trans.wu = command.options[i].values[idx];
      end 
      "dbg","debug": begin
        hcw_trans.dbg = command.options[i].values[idx];
      end 
      "meas": begin
        hcw_trans.meas = command.options[i].values[idx];
      end 
      "lockid": begin
        hcw_trans.lockid = command.options[i].values[idx];
      end 
      "msgtype": begin
        hcw_trans.msgtype = command.options[i].values[idx];
      end 
      "qpri": begin
        hcw_trans.qpri = command.options[i].values[idx];
      end 
      "qtype": begin
        if (command.options[i].values.size() == 0) begin
          case (command.options[i].str_value.tolower())
            "atm": hcw_trans.qtype = QATM;
            "uno": hcw_trans.qtype = QUNO;
            "ord": hcw_trans.qtype = QORD;
            "dir": hcw_trans.qtype = QDIR;
            default: begin
              `uvm_error("HQM_CFG HCW",$psprintf("HQM%0s__Illegal qtype value - %s",inst_suffix,command.options[i].str_value.tolower()))
            end 
          endcase
        end else begin
          if (!$cast(hcw_trans.qtype,command.options[i].values[idx])) begin
              `uvm_error("HQM_CFG HCW",$psprintf("HQM%0s__Illegal qtype value - 0x%08x",inst_suffix,command.options[i].values[idx]))
          end 
        end 
      end 
      "qid": begin
        if (idx >= 0) begin
          if ((command.options[i].values[idx] < 0) || (command.options[i].values[idx] > 127)) begin   // maximum QID number is 127
            `uvm_error("HQM_CFG HCW",$psprintf("HQM%0s__Illegal qid value - %d",inst_suffix,command.options[i].values[idx]))
            return(hcw_command_handler);
          end else begin
            hcw_trans.qid = command.options[i].values[idx];
          end 
        end else begin
          ppid_val = resolve_name(command.options[i].str_value,-1,128);
          if (ppid_val >= 0) begin
            hcw_trans.qid = ppid_val;
          end else begin
            `uvm_error("HQM_CFG HCW",$psprintf("HQM%0s__Illegal qid name - %s",inst_suffix,command.options[i].str_value))
            return(hcw_command_handler);
          end 
        end 

        hcw_trans.ordqid    = hcw_trans.qid;
      end 
      "dsi": begin
        hcw_trans.idsi = command.options[i].values[idx];
      end 
      "ptr": begin
        //hcw_trans.tbcnt     = command.options[i].values[idx][63:48];
        //hcw_trans.tbcntsch  = command.options[i].values[idx][47:32];
        //$cast(hcw_trans.qtypesch,command.options[i].values[idx][31:30]);
        //hcw_trans.isdir     = command.options[i].values[idx][29];
        //hcw_trans.reord     = command.options[i].values[idx][28];
        //hcw_trans.frg_cnt   = command.options[i].values[idx][27:24];
        //hcw_trans.frg_last  = command.options[i].values[idx][23];
        //hcw_trans.ordqid    = command.options[i].values[idx][22:16];
        //hcw_trans.ordidx    = command.options[i].values[idx][15:8];
        hcw_trans.iptr          = command.options[i].values[idx];
        iptr_set                = 1;
      end 
      default: begin
        `uvm_error("HQM_CFG HCW",$psprintf("HQM%0s__Unrecognized option - %s", inst_suffix,command.options[i].option.tolower))
      end 
    endcase
  end 

  if (iptr_set) begin
    hcw_trans.tbcnt     = hcw_trans.iptr;
  end else begin
    hcw_trans.tbcnt     = hcw_trans.get_transaction_id();
    hcw_trans.iptr      = hcw_trans.tbcnt;
  end 

  //----------------------------
  //-- BFM-level modifications
  //---------------------------- 
  if(hcw_trans.reord == 0)     
      hcw_trans.ordidx = hcw_trans.tbcnt;

  //---- 
  //-- determine enqattr
  //----    
  hcw_trans.enqattr = 2'h0;   
  hcw_trans.sch_is_ldb = (hcw_trans.qtype == QDIR)? 1'b0 : 1'b1;
  if(hcw_trans.qe_valid == 1 && hcw_trans.qtype != QORD ) begin
          if( hcw_trans.qtype == QDIR ) begin
                hcw_trans.enqattr = 2'h0;        
          end else begin
                hcw_trans.enqattr[1:0] = {hcw_trans.qe_orsp, hcw_trans.qe_uhl};          
          end                
  end 
  
  //----    
  //-- hcw_trans.isdir is hidden info in ptr
  //----    
  if(hcw_trans.qtype == QDIR) hcw_trans.isdir=1;
  else                   hcw_trans.isdir=0;

  hcw_trans.set_hcw_trinfo(1);           //--kind=1: do not set iptr[63:48]=tbcnt
  
  $cast(to_q, hcw_trans.clone());  
  $cast(to_q.hcw_trinfo, hcw_trans.hcw_trinfo.clone());    
    
  //-- pass hcw_item to sb
  write_hcw_gen_port(to_q);
  
  if (uvm_report_enabled(UVM_MEDIUM,UVM_INFO,"hqm_pp_cq_base_seq")) begin
      hcw_trans.print();
  end 

  hcw_data = hcw_trans.byte_pack(0);

  hcw_queues[(hcw_trans.is_ldb * hqm_pkg::NUM_DIR_PP) + hcw_trans.ppid].hcw_q.push_back(hcw_data);

  if (hcw_queues[(hcw_trans.is_ldb * hqm_pkg::NUM_DIR_PP) + hcw_trans.ppid].hcw_q.size() == 4) begin
      hcw_trans.hcw_batch = 0;
  end 

  if (hcw_trans.hcw_batch == 0) begin
      pp_addr = get_pp_address(hcw_trans.ppid,hcw_trans.is_ldb,hcw_trans.is_nm_pf, hcw_trans.is_vf ? hcw_trans.vf_num : -1);
  
      if($test$plusargs("HQM_CFG_PRIM_HCW_ENQ_SEQ")) begin
      add_register_to_access_list("hcw", "hcw", "hcw", HQM_CFG_PRIM_HCW_ENQ,
                                  .poll_delay((hcw_trans.is_ldb * hqm_pkg::NUM_DIR_PP) + hcw_trans.ppid),
                                  .offset(pp_addr),
                                  .sai(hcw_trans.sai));  

      end else begin
      add_register_to_access_list("hcw", "hcw", "hcw", HQM_CFG_HCW_ENQ,
                                  .poll_delay((hcw_trans.is_ldb * hqm_pkg::NUM_DIR_PP) + hcw_trans.ppid),
                                  .offset(pp_addr),
                                  .sai(hcw_trans.sai));  
      end 
  end 

  hcw_command_handler = HQM_CFG_CMD_DONE;
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::mem_command_handler(hqm_cfg_command command);
  sla_sm_env    sm;
  addr_t        addr;
  addr_t        length;
  byte_t        data[$];
  bit           be[$];
  bit [31:0]    tmp_data;
  longint       laddr;
  bit [31:0]    cmp_data;
  bit [31:0]    mask_data;

  mem_command_handler = HQM_CFG_CMD_NOT_DONE;

  if ((command.get_type() != HQM_MEM_READ) && (command.get_type() != HQM_MEM_WRITE)) begin
    return(mem_command_handler);
  end 

  `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

  if (lvm_common_pkg::token_to_longint(command.target,laddr) == 0) begin
    `uvm_error("HQM_CFG",$psprintf("HQM%0s__MRD/MWR illegal address - %s",inst_suffix,command.target))
    return(mem_command_handler);
  end 

  addr = laddr;

  if (command.get_type() == HQM_MEM_READ) begin
    sm.do_read_backdoor(addr,4,data,"","");

    for (int i = 0 ; i < 4 ; i++) begin
      tmp_data[(i*8) +: 8] = data[i];
    end 

    if (command.options.size() > 0) begin
      cmp_data = command.options[0].values[0];

      if (command.options.size() > 1) begin
        mask_data = command.options[1].values[0];
      end else begin
        mask_data = '1;
      end 

      if ((tmp_data & mask_data) == (cmp_data & mask_data)) begin
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__MRD 0x%x data=0x%08x matches expected data=0x%08x with mask=0x%08x",inst_suffix,addr,tmp_data,cmp_data,mask_data),UVM_LOW)
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__MRD 0x%x data=0x%08x does not match expected data=0x%08x with mask=0x%08x",inst_suffix,addr,tmp_data,cmp_data,mask_data))
      end 
    end else begin
      `uvm_info("HQM_CFG",$psprintf("HQM%0s__MRD 0x%x data=0x%08x",inst_suffix,addr,tmp_data),UVM_LOW)
    end 

    mem_command_handler = HQM_CFG_CMD_DONE_NO_CFG_SEQ;
  end else begin
    tmp_data = command.options[0].values[0];
    data.delete();
    be.delete();

    for (int i = 0 ; i < 4 ; i++) begin
      data.push_back(tmp_data[(i*8) +: 8]);
      be.push_back(1);
    end 

    if (command.options.size() > 1) begin
      for (int i = 0 ; i < command.options[1].values[0] ; i++) begin
        sm.do_write_backdoor(addr,data,be,"","");
        addr += 4;
      end 

      `uvm_info("HQM_CFG",$psprintf("HQM%0s__MWR 0x%x data=0x%08x num=0x%0x",inst_suffix,addr,tmp_data,command.options[1].values[0]),UVM_LOW)
    end else begin
      sm.do_write_backdoor(addr,data,be,"","");
      `uvm_info("HQM_CFG",$psprintf("HQM%0s__MWR 0x%x data=0x%08x",inst_suffix,addr,tmp_data),UVM_LOW)
    end 

    mem_command_handler = HQM_CFG_CMD_DONE_NO_CFG_SEQ;
  end 

endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::qid_command_handler(hqm_cfg_command command);
    int qid;
    int idx;
    hqm_cfg_command_options option;

    qid_command_handler = HQM_CFG_CMD_NOT_DONE;

    if (((command.get_type() != HQM_CFG_LDB) && (command.get_type() != HQM_CFG_DIR)) || (command.get_target() != "qid")) begin
      return(qid_command_handler);
    end 

    qid = resolve_value(command,hqm_pkg::NUM_LDB_QID,hqm_pkg::NUM_DIR_QID,avail_ldb_qid,avail_dir_qid,prov_ldb_qid,prov_dir_qid);

    if (qid < 0) return(qid_command_handler);

    if (command.get_type == HQM_CFG_LDB) begin
      ldb_qid_cfg[qid].provisioned = 1'b1;
      ldb_qid_cfg[qid].enable = 1'b1;

      for(int i=0;i<command.options.size;i++) begin
        idx = $urandom_range(0, command.options[i].values.size()-1);
        case (command.options[i].option.tolower())
          "enable"                      : ldb_qid_cfg[qid].enable                       = command.options[i].values[idx]; 
          "qid_its"                     : ldb_qid_cfg[qid].qid_its                      = command.options[i].values[idx]; 
          "fid_cfg_v"                   : ldb_qid_cfg[qid].fid_cfg_v                    = 1;
          "rlst_clamp_min"              : ldb_qid_cfg[qid].qid_rlst_clamp.min_bin       = command.options[i].values[idx]; 
          "rlst_clamp_max"              : ldb_qid_cfg[qid].qid_rlst_clamp.max_bin       = command.options[i].values[idx]; 
          "qid_ldb_inflight_limit"      : ldb_qid_cfg[qid].qid_ldb_inflight_limit       = command.options[i].values[idx]; 
          "atm_qid_depth_thresh"        : ldb_qid_cfg[qid].atm_qid_depth_thresh         = command.options[i].values[idx]; 
          "nalb_qid_depth_thresh"       : ldb_qid_cfg[qid].nalb_qid_depth_thresh        = command.options[i].values[idx]; 
          "aqed_freelist_base"          : ldb_qid_cfg[qid].aqed_freelist_base           = command.options[i].values[idx]; 
          "aqed_freelist_limit"         : ldb_qid_cfg[qid].aqed_freelist_limit          = command.options[i].values[idx]; 
          "fid_limit"                   : ldb_qid_cfg[qid].fid_limit                    = command.options[i].values[idx];
          "qid_comp_code"               : ldb_qid_cfg[qid].qid_comp_code                = command.options[i].values[idx]; 
          "ord_mode"                    : begin 
                                            ldb_qid_cfg[qid].ord_mode                   = command.options[i].values[idx]; 
                                            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ORD:ldb_qid_cfg[qid%0d].ord_mode=%0d", inst_suffix, qid, ldb_qid_cfg[qid].ord_mode), UVM_LOW);     
                                          end 
          "ord_slot"                    : begin
                                            ldb_qid_cfg[qid].ord_slot                   = command.options[i].values[idx]; 
                                            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ORD:ldb_qid_cfg[qid%0d].ord_slot=%0d", inst_suffix, qid, ldb_qid_cfg[qid].ord_slot), UVM_LOW);     
                                          end 
          "ord_grp"                     : begin 
                                            ldb_qid_cfg[qid].ord_grp                    = command.options[i].values[idx]; 
                                            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ORD:ldb_qid_cfg[qid%0d].ord_grp=%0d", inst_suffix, qid, ldb_qid_cfg[qid].ord_grp), UVM_LOW);     

                                            if(sn_grp_mode[0] < 0 && ldb_qid_cfg[qid].ord_grp==0) begin
                                               sn_grp_mode[0] = ldb_qid_cfg[qid].ord_mode;  
                                               uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ORD:sn_grp_mode[0]=%0d", inst_suffix, sn_grp_mode[0]), UVM_LOW);     
                                            end else if(sn_grp_mode[1] < 0 && ldb_qid_cfg[qid].ord_grp==1) begin
                                               sn_grp_mode[1] = ldb_qid_cfg[qid].ord_mode;  
                                               uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ORD:sn_grp_mode[1]=%0d", inst_suffix, sn_grp_mode[1]), UVM_LOW);     
                                            end 
                                          end 
          "sn_cfg_v"                    : begin 
                                            ldb_qid_cfg[qid].sn_cfg_v                   = command.options[i].values[idx]; 
                                          end 
          "ao_cfg_v"                    : ldb_qid_cfg[qid].ao_cfg_v                     = command.options[i].values[idx];
          "exp_not_empty"               : ldb_qid_cfg[qid].exp_errors.not_empty         = command.options[i].values[idx]; 
          "exp_ord_not_empty"           : ldb_qid_cfg[qid].exp_errors.ord_not_empty     = command.options[i].values[idx]; 
          "exp_remove_ord_q"            : ldb_qid_cfg[qid].exp_errors.remove_ord_q      = command.options[i].values[idx]; 
          "exp_out_of_order"            : ldb_qid_cfg[qid].exp_errors.ord_out_of_order  = command.options[i].values[idx]; 
          "exp_sch_out_of_order"        : ldb_qid_cfg[qid].exp_errors.sch_out_of_order  = command.options[i].values[idx]; 
          "exp_unexp_atm_comp"          : ldb_qid_cfg[qid].exp_errors.unexp_atm_comp    = command.options[i].values[idx]; 
          "enq_hcw_q_not_empty"         : sb_exp_errors.enq_hcw_q_not_empty	        = command.options[i].values[idx]; 
          default                       : uvm_report_error("LDB QID CFG", $psprintf("Undefined option %s", command.options[i].option));
        endcase
      end 

      //--set to sn_grp_mode[grpid]=ord_mode;
      //sn_grp_mode[ldb_qid_cfg[qid].ord_grp] < 0) begin
        ////--sn_grp_mode[ldb_qid_cfg[qid].ord_grp] = ldb_qid_cfg[qid].ord_mode;
        uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ORD:ldb_qid_cfg[qid%0d].ord_mode=%0d ldb_qid_cfg[qid%0d].ord_grp=%0d ldb_qid_cfg[qid%0d].ord_slot=%0d", inst_suffix, qid, ldb_qid_cfg[qid].ord_mode, qid, ldb_qid_cfg[qid].ord_grp, qid, ldb_qid_cfg[qid].ord_slot), UVM_LOW);     
      //end 

      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ord_qid_sn_map", qid, "mode", this.ldb_qid_cfg[qid].ord_mode); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ord_qid_sn_map", qid, "slot", this.ldb_qid_cfg[qid].ord_slot); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ord_qid_sn_map", qid, "grp",  this.ldb_qid_cfg[qid].ord_grp); 
      if(sn_grp_mode[1]>=0) begin ////--if(ldb_qid_cfg[qid].ord_grp==1) begin
         set_cfg_val(set_cfg_val_op, "reorder_pipe", "cfg_grp_sn_mode", "sn_mode_1", sn_grp_mode[1]);
         uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ORD:sn_grp_mode[1]=%0d write to reorder_pipe.cfg_grp_sn_mode.sn_mode_1=%0d", inst_suffix, sn_grp_mode[1], sn_grp_mode[1]), UVM_LOW);     
      end 
      if(sn_grp_mode[0]>=0) begin ////--if(ldb_qid_cfg[qid].ord_grp==0) begin
         set_cfg_val(set_cfg_val_op, "reorder_pipe", "cfg_grp_sn_mode", "sn_mode_0", sn_grp_mode[0]);
         uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ORD:sn_grp_mode[0]=%0d write to reorder_pipe.cfg_grp_sn_mode.sn_mode_0=%0d", inst_suffix, sn_grp_mode[0], sn_grp_mode[0]), UVM_LOW);     
      end 

//      set_cfg_val_index(set_cfg_val_op, "reorder_pipe", "cfg_qid2grpslt", qid, "slot", this.ldb_qid_cfg[qid].ord_slot); 
//      set_cfg_val_index(set_cfg_val_op, "reorder_pipe", "cfg_qid2grpslt", qid, "group",  this.ldb_qid_cfg[qid].ord_grp); 

      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_qid_aqed_active_limit", qid, "limit", 1 + ldb_qid_cfg[qid].aqed_freelist_limit - ldb_qid_cfg[qid].aqed_freelist_base); 
      set_cfg_val_index(set_cfg_val_op, "aqed_pipe",     "cfg_aqed_qid_fid_limit",    qid, "qid_fid_limit", ldb_qid_cfg[qid].fid_limit); 

      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_qid_ldb_inflight_limit", qid, "limit", ldb_qid_cfg[qid].qid_ldb_inflight_limit); 

      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_atm_qid_dpth_thrsh", qid, "thresh", ldb_qid_cfg[qid].atm_qid_depth_thresh); 
      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_nalb_qid_dpth_thrsh", qid, "thresh", ldb_qid_cfg[qid].nalb_qid_depth_thresh); 

      //--program compress_code
      set_cfg_val_index(set_cfg_val_op, "aqed_pipe",     "cfg_aqed_qid_hid_width",  qid, "compress_code", ldb_qid_cfg[qid].qid_comp_code); 

//-- These are V1_only
//      set_cfg_val_index(set_cfg_val_op, "aqed_pipe", "cfg_aqed_freelist_base", qid, "base", this.ldb_qid_cfg[qid].aqed_freelist_base); 
//      set_cfg_val_index(set_cfg_val_op, "aqed_pipe", "cfg_aqed_freelist_limit", qid, "limit", this.ldb_qid_cfg[qid].aqed_freelist_limit); 
//      if (ldb_qid_cfg[qid].fid_cfg_v) begin
//        set_cfg_val_index(set_cfg_val_op, "aqed_pipe", "cfg_aqed_freelist_limit", qid, "freelist_disable", 0);
//      end 
//      set_cfg_val_index(set_cfg_val_op, "aqed_pipe", "cfg_aqed_freelist_push_ptr", qid, "push_ptr", this.ldb_qid_cfg[qid].aqed_freelist_base); 
//      set_cfg_val_index(set_cfg_val_op, "aqed_pipe", "cfg_aqed_freelist_push_ptr", qid, "generation", 1);
//      set_cfg_val_index(set_cfg_val_op, "aqed_pipe", "cfg_aqed_freelist_pop_ptr", qid, "pop_ptr", this.ldb_qid_cfg[qid].aqed_freelist_base); 
//      set_cfg_val_index(set_cfg_val_op, "aqed_pipe", "cfg_aqed_freelist_pop_ptr", qid, "generation", 0);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_qid_v", qid, "qid_v", this.ldb_qid_cfg[qid].enable);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_qid_its", qid, "qid_its", this.ldb_qid_cfg[qid].qid_its);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_qid_cfg_v", qid, "ao_cfg_v", this.ldb_qid_cfg[qid].ao_cfg_v);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__AO_CFG_V:ldb_qid_cfg[%0d].ao_cfg_v=%0d", inst_suffix,qid,ldb_qid_cfg[qid].ao_cfg_v), UVM_LOW); 

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_qid_cfg_v", qid, "fid_cfg_v", this.ldb_qid_cfg[qid].fid_cfg_v);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__FID_CFG_V:ldb_qid_cfg[%0d].fid_cfg_v=%0d", inst_suffix,qid,ldb_qid_cfg[qid].fid_cfg_v), UVM_LOW); 

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_qid_cfg_v", qid, "sn_cfg_v", this.ldb_qid_cfg[qid].sn_cfg_v);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__SN_CFG_V:ldb_qid_cfg[%0d].sn_cfg_v=%0d", inst_suffix,qid,ldb_qid_cfg[qid].sn_cfg_v), UVM_LOW); 
    end 
    else if (command.get_type == HQM_CFG_DIR) begin
      dir_qid_cfg[qid].provisioned = 1'b1;
      dir_qid_cfg[qid].enable = 1'b1;

      for(int i=0;i<command.options.size;i++) begin
        idx = $urandom_range(0, command.options[i].values.size()-1);
        case (command.options[i].option.tolower())
          "enable"                     : dir_qid_cfg[qid].enable                     = command.options[i].values[idx]; 
          "qid_its"                    : dir_qid_cfg[qid].qid_its                    = command.options[i].values[idx]; 
          "exp_not_empty"              : dir_qid_cfg[qid].exp_errors.not_empty       = command.options[i].values[idx]; 
          "exp_ord_not_empty"          : dir_qid_cfg[qid].exp_errors.ord_not_empty   = command.options[i].values[idx]; 
          "exp_remove_ord_q"           : dir_qid_cfg[qid].exp_errors.remove_ord_q    = command.options[i].values[idx]; 
          "exp_out_of_order"           : dir_qid_cfg[qid].exp_errors.ord_out_of_order= command.options[i].values[idx]; 
          "exp_sch_out_of_order"       : dir_qid_cfg[qid].exp_errors.sch_out_of_order= command.options[i].values[idx]; 
          "exp_unexp_atm_comp"         : dir_qid_cfg[qid].exp_errors.unexp_atm_comp  = command.options[i].values[idx]; 
          "dir_qid_depth_thresh"       : dir_qid_cfg[qid].dir_qid_depth_thresh       = command.options[i].values[idx]; 
          "enq_hcw_q_not_empty"        : sb_exp_errors.enq_hcw_q_not_empty           = command.options[i].values[idx]; 
          default                      : uvm_report_error("DIR QID CFG", $psprintf("Undefined option %s", command.options[i].option));
        endcase
      end 

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_qid_v", qid, "qid_v", this.dir_qid_cfg[qid].enable);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_qid_its", qid, "qid_its", this.dir_qid_cfg[qid].qid_its);
      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe",  "cfg_dir_qid_dpth_thrsh", qid, "thresh", dir_qid_cfg[qid].dir_qid_depth_thresh); 
    end 

    qid_command_handler = HQM_CFG_CMD_DONE;
    //TO DO
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::pp_command_handler(hqm_cfg_command command);
    hqm_cfg_command_options option;
    int pp;
    int idx;

    pp_command_handler = HQM_CFG_CMD_NOT_DONE;

    if (((command.get_type() != HQM_CFG_LDB) && (command.get_type() != HQM_CFG_DIR)) || (command.get_target() != "pp")) begin
      return(pp_command_handler);
    end 

    pp = resolve_value(command,hqm_pkg::NUM_LDB_PP,hqm_pkg::NUM_DIR_PP,avail_ldb_pp,avail_dir_pp,prov_ldb_pp,prov_dir_pp);

    if (pp < 0) return(pp_command_handler);

    if (command.get_type == HQM_CFG_LDB) begin
      ldb_pp_cq_cfg[pp].pp_provisioned = 1'b1;
      if (ldb_pp_cq_cfg[pp].pp_enable == 1'b0) begin
        ldb_pp_cq_cfg[pp].pp_enable = 1'b1;
        ldb_pp_cq_cfg[pp].is_pf = 1'b1;
      end 

      for(int i=0;i<command.options.size;i++) begin
          if (command.options[i].values.size() > 0) begin
            idx = $urandom_range(0, command.options[i].values.size()-1);
          end else begin
            idx = -1;
          end 

          case (command.options[i].option.tolower())
            "enable"                    : ldb_pp_cq_cfg[pp].pp_enable              = command.options[i].values[idx]; 
            "cq_wb_pad"                 : ldb_pp_cq_cfg[pp].cq_wb_pad              = command.options[i].values[idx]; 
            "exp_ill_hcw_cmd"           : ldb_pp_cq_cfg[pp].exp_errors.ill_hcw_cmd = command.options[i].values[idx];
            "exp_ill_qid"               : ldb_pp_cq_cfg[pp].exp_errors.ill_qid     = command.options[i].values[idx];
            "exp_dis_qid"               : ldb_pp_cq_cfg[pp].exp_errors.dis_qid     = command.options[i].values[idx];
            "exp_ill_ldbqid"            : ldb_pp_cq_cfg[pp].exp_errors.ill_ldbqid  = command.options[i].values[idx];
            "exp_ill_pp"                : ldb_pp_cq_cfg[pp].exp_errors.ill_pp      = command.options[i].values[idx];
            "exp_remove_ord_pp"         : ldb_pp_cq_cfg[pp].exp_errors.remove_ord_pp = command.options[i].values[idx];
            "exp_unexp_comp"            : ldb_pp_cq_cfg[pp].exp_errors.unexp_comp  = command.options[i].values[idx];
            "exp_ill_comp"              : ldb_pp_cq_cfg[pp].exp_errors.ill_comp    = command.options[i].values[idx];
            "exp_excess_frag"           : ldb_pp_cq_cfg[pp].exp_errors.excess_frag = command.options[i].values[idx];
            "exp_replay_cnt"            : i_hqm_pp_cq_status.ldb_pp_cq_status[pp].st_replay_cnt_ena    = command.options[i].values[idx];
            "exp_excess_tok"            : begin
                                               ldb_pp_cq_cfg[pp].exp_errors.excess_tok                  = command.options[i].values[idx];
                                               i_hqm_pp_cq_status.ldb_pp_cq_status[pp].exp_excess_tok   = command.options[i].values[idx];
                                          end 
            "exp_unexp_rels"            : ldb_pp_cq_cfg[pp].exp_errors.unexp_rels  = command.options[i].values[idx];
            "exp_unexp_rels_qid"        : ldb_pp_cq_cfg[pp].exp_errors.unexp_rels_qid  = command.options[i].values[idx];
            "exp_drop"                  : ldb_pp_cq_cfg[pp].exp_errors.drop        = command.options[i].values[idx];
            "exp_ooc"                   : ldb_pp_cq_cfg[pp].exp_errors.ooc         = command.options[i].values[idx];
            "vas"                       : begin
                                             if(vas_pcq_ctrl==1) begin
                                                ldb_pp_cq_cfg[pp].vas              = 0;
                                                uvm_report_info("HQM_CFG", $psprintf("HQM%0s__PCQ:ldb_pp_cq_cfg[%0d].vas=%0d vas_pcq_ctrl=1 => force to use VAS[0] only", inst_suffix,pp, ldb_pp_cq_cfg[pp].vas), UVM_LOW);     
                                             end else if(vas_pcq_ctrl==2) begin
                                                ldb_pp_cq_cfg[pp].vas              = decode_option_value(prov_vas,command.options[i]) % 2;
                                                uvm_report_info("HQM_CFG", $psprintf("HQM%0s__PCQ:ldb_pp_cq_cfg[%0d].vas=%0d vas_pcq_ctrl=2 => force to use even", inst_suffix,pp, ldb_pp_cq_cfg[pp].vas), UVM_LOW);     
                                             end else begin
                                                ldb_pp_cq_cfg[pp].vas              = decode_option_value(prov_vas,command.options[i]);
                                             end 
                                          end 
            "max_cacheline_num"         : begin
                                             ldb_pp_cq_cfg[pp].cl_max              = command.options[i].values[idx];
                                             uvm_report_info("HQM_CFG", $psprintf("HQM%0s__CLROB:ldb_pp_cq_cfg[%0d].cl_max=%0d", inst_suffix,pp, ldb_pp_cq_cfg[pp].cl_max), UVM_LOW);     
                                          end 
            "rob"                       : begin
                                             ldb_pp_cq_cfg[pp].cl_rob              = command.options[i].values[idx];
                                             if(ldb_pp_cq_cfg[pp].cl_rob==1)       
                                                 ldb_pp_cq_cfg[pp].cl_check = 1;

                                             uvm_report_info("HQM_CFG", $psprintf("HQM%0s__CLROB:ldb_pp_cq_cfg[%0d].cl_max=%0d cl_rob=%0d cl_check=%0d", inst_suffix,pp, ldb_pp_cq_cfg[pp].cl_max, ldb_pp_cq_cfg[pp].cl_rob, ldb_pp_cq_cfg[pp].cl_check), UVM_LOW);     
                                          end 
            
            default: begin
              uvm_report_error("LDB PP CFG", $psprintf("Undefined option %s", command.options[i].option));
            end 
          endcase
       end 

       uvm_report_info("HQM_CFG", $psprintf("HQM%0s__VAS:ldb_pp_cq_cfg[%0d].vas=%0d", inst_suffix,pp, ldb_pp_cq_cfg[pp].vas), UVM_LOW);     
       //uvm_report_info("HQM_CFG", $psprintf("HQM%0s__i_hqm_pp_cq_status.ldb_pp_cq_status[%0d].st_replay_cnt_ena=%0d", inst_suffix,pp, i_hqm_pp_cq_status.ldb_pp_cq_status[pp].st_replay_cnt_ena), UVM_LOW);     

      // HQM30 ROB
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_pp_rob_v", pp, "rob_v", this.ldb_pp_cq_cfg[pp].cl_rob);

      // HQM_SYSTEM configuration for LDB PPs
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_pp_v", pp, "pp_v", this.ldb_pp_cq_cfg[pp].pp_enable);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_pp2vas", pp, "vas", this.ldb_pp_cq_cfg[pp].vas);
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ldb_cq2vas", pp, "cq2vas", this.ldb_pp_cq_cfg[pp].vas);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq2vf_pf_ro", pp, "is_pf", this.ldb_pp_cq_cfg[pp].is_pf);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq2vf_pf_ro", pp, "ro", this.ldb_pp_cq_cfg[pp].ro);
    end 
    else if (command.get_type == HQM_CFG_DIR) begin
      dir_pp_cq_cfg[pp].pp_provisioned = 1'b1;
      if (dir_pp_cq_cfg[pp].pp_enable == 1'b0) begin
        dir_pp_cq_cfg[pp].pp_enable = 1'b1;
        dir_pp_cq_cfg[pp].is_pf = 1'b1;
      end 

      for(int i=0;i<command.options.size;i++) begin
        if (command.options[i].values.size() > 0) begin
          idx = $urandom_range(0, command.options[i].values.size()-1);
        end else begin
          idx = -1;
        end 

        case (command.options[i].option.tolower())
          "enable"                      : dir_pp_cq_cfg[pp].pp_enable              = command.options[i].values[idx]; 
          "cq_wb_pad"                   : dir_pp_cq_cfg[pp].cq_wb_pad              = command.options[i].values[idx]; 
          "vas"                         : dir_pp_cq_cfg[pp].vas                    = decode_option_value(prov_vas,command.options[i]);
          "exp_ill_hcw_cmd_dir_pp"      : dir_pp_cq_cfg[pp].exp_errors.ill_hcw_cmd_dir_pp = command.options[i].values[idx];
          "exp_ill_hcw_cmd"             : dir_pp_cq_cfg[pp].exp_errors.ill_hcw_cmd = command.options[i].values[idx];
          "exp_ill_qid"                 : dir_pp_cq_cfg[pp].exp_errors.ill_qid     = command.options[i].values[idx];
          "exp_dis_qid"                 : dir_pp_cq_cfg[pp].exp_errors.dis_qid     = command.options[i].values[idx];
          "exp_ill_ldbqid"              : dir_pp_cq_cfg[pp].exp_errors.ill_ldbqid  = command.options[i].values[idx];
          "exp_ill_pp"                  : dir_pp_cq_cfg[pp].exp_errors.ill_pp      = command.options[i].values[idx];
          "exp_replay_cnt"              : i_hqm_pp_cq_status.dir_pp_cq_status[pp].st_replay_cnt_ena     = command.options[i].values[idx];
          "exp_excess_tok"              : begin
                                               dir_pp_cq_cfg[pp].exp_errors.excess_tok                  = command.options[i].values[idx];
                                               i_hqm_pp_cq_status.dir_pp_cq_status[pp].exp_excess_tok   = command.options[i].values[idx];
                                          end 
          "exp_drop"                    : dir_pp_cq_cfg[pp].exp_errors.drop        = command.options[i].values[idx];
          "exp_ooc"                     : dir_pp_cq_cfg[pp].exp_errors.ooc         = command.options[i].values[idx];
          "max_cacheline_num"           : begin
                                             dir_pp_cq_cfg[pp].cl_max              = command.options[i].values[idx];
                                             uvm_report_info("HQM_CFG", $psprintf("HQM%0s__CLROB:dir_pp_cq_cfg[%0d].cl_max=%0d", inst_suffix,pp, dir_pp_cq_cfg[pp].cl_max), UVM_LOW);     
                                          end 
          "rob"                         : begin
                                             dir_pp_cq_cfg[pp].cl_rob              = command.options[i].values[idx];
                                             if(dir_pp_cq_cfg[pp].cl_rob==1)       
                                                 dir_pp_cq_cfg[pp].cl_check = 1;

                                             uvm_report_info("HQM_CFG", $psprintf("HQM%0s__CLROB:dir_pp_cq_cfg[%0d].cl_max=%0d cl_rob=%0d cl_check=%0d", inst_suffix,pp, dir_pp_cq_cfg[pp].cl_max, dir_pp_cq_cfg[pp].cl_rob, dir_pp_cq_cfg[pp].cl_check), UVM_LOW);     
                                          end 

          default: begin
            uvm_report_error("LDB PP CFG", $psprintf("Undefined option %s", command.options[i].option));
          end 
        endcase
      end       

      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__VAS:dir_pp_cq_cfg[%0d].vas=%0d", inst_suffix,pp, dir_pp_cq_cfg[pp].vas), UVM_LOW);     
      //uvm_report_info("HQM_CFG", $psprintf("HQM%0s__i_hqm_pp_cq_status.dir_pp_cq_status[%0d].st_replay_cnt_ena=%0d", inst_suffix,pp, i_hqm_pp_cq_status.dir_pp_cq_status[pp].st_replay_cnt_ena), UVM_LOW);     

      // HQM30 ROB
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_pp_rob_v", pp, "rob_v", this.dir_pp_cq_cfg[pp].cl_rob);


      // HQM_SYSTEM configuration for DIR PPs
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_pp_v", pp, "pp_v", this.dir_pp_cq_cfg[pp].pp_enable);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_pp2vas", pp, "vas", this.dir_pp_cq_cfg[pp].vas);
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_dir_cq2vas", pp, "cq2vas", this.dir_pp_cq_cfg[pp].vas);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq2vf_pf_ro", pp, "is_pf", this.dir_pp_cq_cfg[pp].is_pf);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq2vf_pf_ro", pp, "ro", this.dir_pp_cq_cfg[pp].ro);
    end 

    pp_command_handler = HQM_CFG_CMD_DONE;
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::cq_command_handler(hqm_cfg_command command);
    int         cq;
    int         idx;
    bit [7:0]   cq2pri_v;
    bit [23:0]  cq2pri;
    int         cqdep_rnd_sel, cqdep_rnd_val;
    int         cq_pcq_ctrl_val;
    bit [63:0]  mem_size_val;

    cq_command_handler = HQM_CFG_CMD_NOT_DONE;

    if (((command.get_type() != HQM_CFG_LDB) && (command.get_type() != HQM_CFG_DIR)) || (command.get_target() != "cq")) begin
      return(cq_command_handler);
    end 

    cq = resolve_value(command,hqm_pkg::NUM_LDB_CQ,hqm_pkg::NUM_DIR_CQ,avail_ldb_cq,avail_dir_cq,prov_ldb_cq,prov_dir_cq);

    if (cq < 0) return(cq_command_handler);

    if (command.get_type == HQM_CFG_LDB) begin
      ldb_pp_cq_cfg[cq].cq_provisioned = 1'b1;
      if (ldb_pp_cq_cfg[cq].cq_enable == 1'b0) begin
        ldb_pp_cq_cfg[cq].cq_enable = 1'b1;
        ldb_pp_cq_cfg[cq].is_pf = 1'b1;

        //----------------------
        //-- PCQ rand control
        //----------------------
        if(cq>0 && cq_pcq_ctrl>0) begin
           cq_pcq_ctrl_val = (cq_pcq_ctrl==1)? 1 : $urandom_range(0, cq_pcq_ctrl-1); 

           if(ldb_pp_cq_cfg[cq-1].cq_enable==1 && cq%2==1 && cq_pcq_ctrl_val==1) begin
                ldb_pp_cq_cfg[cq].cq_pcq = 1;
                ldb_pp_cq_cfg[cq-1].cq_pcq = 1;
                uvm_report_info("HQM_CFG", $psprintf("HQM%0s__CQ_PCQ: rand program ldb_pp_cq_cfg[%0d].cq_pcq=%0d by cq_pcq_ctrl=%0d", inst_suffix, cq-1, ldb_pp_cq_cfg[cq-1].cq_pcq, cq_pcq_ctrl), UVM_LOW);
                uvm_report_info("HQM_CFG", $psprintf("HQM%0s__CQ_PCQ: rand program ldb_pp_cq_cfg[%0d].cq_pcq=%0d by cq_pcq_ctrl=%0d", inst_suffix, cq,   ldb_pp_cq_cfg[cq].cq_pcq, cq_pcq_ctrl), UVM_LOW);
           end 
        end //--CQ_PCQ rand programming
      end 

      for(int i=0;i<command.options.size;i++) begin
        if (command.options[i].values.size() > 0) begin
          idx = $urandom_range(0, command.options[i].values.size()-1);
        end else begin
          idx = -1;
        end 

        case (command.options[i].option.tolower())
          "enable"                      : ldb_pp_cq_cfg[cq].cq_enable              = command.options[i].values[idx]; 
          "pcq"                         : begin 
                                          ldb_pp_cq_cfg[cq].cq_pcq                 = command.options[i].values[idx]; 
                                             uvm_report_info("HQM_CFG", $psprintf("HQM%0s__CQ_PCQ: program ldb_pp_cq_cfg[%0d].cq_pcq=%0d", inst_suffix, cq, ldb_pp_cq_cfg[cq].cq_pcq), UVM_LOW);
                                          end 
          "cq_depth"                    : begin
                                            case (command.options[i].values[idx])
                                              4:        ldb_pp_cq_cfg[cq].cq_depth = DEPTH_4;
                                              8:        ldb_pp_cq_cfg[cq].cq_depth = DEPTH_8;
                                              16:       ldb_pp_cq_cfg[cq].cq_depth = DEPTH_16;
                                              32:       ldb_pp_cq_cfg[cq].cq_depth = DEPTH_32;
                                              64:       ldb_pp_cq_cfg[cq].cq_depth = DEPTH_64;
                                              128:      ldb_pp_cq_cfg[cq].cq_depth = DEPTH_128;
                                              256:      ldb_pp_cq_cfg[cq].cq_depth = DEPTH_256;
                                              512:      begin
                                                          if($test$plusargs("ATS_4KPAGE_ONLY"))  ldb_pp_cq_cfg[cq].cq_depth = DEPTH_256;
                                                          else                                   ldb_pp_cq_cfg[cq].cq_depth = DEPTH_512;
                                                        end 
                                              1024:     begin
                                                          if($test$plusargs("ATS_4KPAGE_ONLY"))  ldb_pp_cq_cfg[cq].cq_depth = DEPTH_256;
                                                          else                                   ldb_pp_cq_cfg[cq].cq_depth = DEPTH_1024;
                                                        end 
                                              default: begin
                                                `uvm_error("LDB CQ CFG", $psprintf("HQM%0s__Illegal cq_depth of %0d, should be 8, 16, 32, 64, 128, 256, 512, or 1024",
                                                                                   inst_suffix,command.options[i].values[idx]))
                                              end 
                                            endcase

                                            //--post program
                                            if($test$plusargs("ATS_4KPAGE_ONLY") && (ldb_cq_single_hcw_per_cl > 0) && (ldb_pp_cq_cfg[cq].cq_depth > DEPTH_64)) begin
                                                 `uvm_info("LDB CQ CFG", $psprintf("HQM%0s__LDB_CQ_DEPTH ldb_cq_single_hcw_per_cl=%0d => cq_depth of %0d reduced to DEPTH_64 when +ATS_4KPAGE_ONLY", inst_suffix, ldb_cq_single_hcw_per_cl, ldb_pp_cq_cfg[cq].cq_depth),UVM_LOW)
                                                  ldb_pp_cq_cfg[cq].cq_depth = DEPTH_64;
                                            end else if($test$plusargs("ATS_4KPAGE_ONLY") && (ldb_pp_cq_cfg[cq].cq_depth > DEPTH_256)) begin
                                                 `uvm_info("LDB CQ CFG", $psprintf("HQM%0s__LDB_CQ_DEPTH ldb_cq_single_hcw_per_cl=%0d => cq_depth of %0d reduced to DEPTH_256 when +ATS_4KPAGE_ONLY", inst_suffix, ldb_cq_single_hcw_per_cl, ldb_pp_cq_cfg[cq].cq_depth),UVM_LOW)
                                                  ldb_pp_cq_cfg[cq].cq_depth = DEPTH_256;
                                            end 
                                          end 
          "hist_list_base"              : begin
                                            if (command.options[i].values[idx] >= 2048) begin
                                              `uvm_error("LDB CQ CFG", $psprintf("HQM%0s__Illegal hist_list_base of %0d, should be 0-2047", inst_suffix,command.options[i].values[idx]))
                                            end else begin
                                              ldb_pp_cq_cfg[cq].hist_list_base         = command.options[i].values[idx];
                                            end 
                                          end 
          "hist_list_limit"             : begin
                                            if (command.options[i].values[idx] >= 2048) begin
                                              `uvm_error("LDB CQ CFG", $psprintf("HQM%0s__Illegal hist_list_limit of %0d, should be 0-2047", inst_suffix,command.options[i].values[idx]))
                                            end else begin
                                              ldb_pp_cq_cfg[cq].hist_list_limit        = command.options[i].values[idx];
                                            end 
                                          end 
          "cq_hl_exp_mode"              : ldb_pp_cq_cfg[cq].cq_hl_exp_mode         = command.options[i].values[idx];
          "cq_token_count"              : ldb_pp_cq_cfg[cq].cq_token_count         = command.options[i].values[idx];
          "cq_timer_intr_thresh"        : ldb_pp_cq_cfg[cq].cq_timer_intr_thresh   = command.options[i].values[idx];
          "cq_timer_intr_ena"           : ldb_pp_cq_cfg[cq].cq_timer_intr_ena      = command.options[i].values[idx];
          "cq_depth_intr_thresh"        : ldb_pp_cq_cfg[cq].cq_depth_intr_thresh   = command.options[i].values[idx];
          "cq_depth_intr_ena"           : ldb_pp_cq_cfg[cq].cq_depth_intr_ena      = command.options[i].values[idx];
          "cq_cwdt_intr_ena"            : ldb_pp_cq_cfg[cq].cq_cwdt_intr_ena       = command.options[i].values[idx];
          "cq_int_mask"                 : ldb_pp_cq_cfg[cq].cq_int_mask            = command.options[i].values[idx];
          "gpa"                         : begin
                                            if ($test$plusargs("HQM_CQ_DEPTH_MAX")) begin
                                              ldb_pp_cq_cfg[cq].cq_gpa                 = decode_cq_gpa(command.options[i], idx, $psprintf("HQM%s_LDB_CQ_%0d_MEM",inst_suffix,cq), ((ldb_cq_single_hcw_per_cl > 0) ? 64'h100 : 64'h40) << 1024, 64'h3f, 1'b1, cq);
                                            end else begin
                                              if(ldb_cq_single_hcw_per_cl>0) begin
                                                 mem_size_val = 64'h100 << ldb_pp_cq_cfg[cq].cq_depth;     
                                              end else begin
                                                 mem_size_val = 64'h40 << ldb_pp_cq_cfg[cq].cq_depth;
                                              end 

                                              uvm_report_info("HQM_CFG", $psprintf("HQM%0s__curr_hqm_trf_loop=%0d", inst_suffix, hqm_trf_loop), UVM_LOW);
                                              if(hqm_trf_loop==0) begin
                                                 //--regular case without ATS INV issued
                                                 //--HQMV25-- ldb_pp_cq_cfg[cq].cq_gpa                 = decode_cq_gpa(command.options[i], idx, $psprintf("HQM%s_LDB_CQ_%0d_MEM",inst_suffix,cq), ((ldb_cq_single_hcw_per_cl > 0) ? 64'h100 : 64'h40) << ldb_pp_cq_cfg[cq].cq_depth, pb_addr_mask, 1'b1, cq);
                                                 ldb_pp_cq_cfg[cq].cq_gpa                 = decode_cq_gpa(command.options[i], idx, $psprintf("HQM%s_LDB_CQ_%0d_MEM",inst_suffix,cq), mem_size_val, pb_addr_mask, 1'b1, cq);
                                              end else begin
                                                 //--after FLR with hqm_trf_loop>0, reprogram cq_addr (phy/vir)
                                                 ldb_pp_cq_cfg[cq].cq_gpa                 = decode_cq_gpa(command.options[i], idx, $psprintf("HQM%s_LDB_CQ_%0d_REALLOCMEM%0d",inst_suffix,cq,hqm_trf_loop), mem_size_val, pb_addr_mask, 1'b1, cq);
                                              end 
                                            end 
                                          end 
          "cq_ldb_inflight_limit"       : begin
                                            ldb_pp_cq_cfg[cq].cq_ldb_inflight_limit       = command.options[i].values[idx]; 
                                            ldb_pp_cq_cfg[cq].cq_ldb_inflight_limit_set   = 1'b1;
                                          end 
          "cq_ldb_inflight_thresh"      : begin
                                            ldb_pp_cq_cfg[cq].cq_ldb_inflight_thresh = command.options[i].values[idx];
                                            i_hqm_pp_cq_status.ldb_pp_cq_status[cq].st_inflight_thres      = command.options[i].values[idx];
                                          end 
          "cq_isr_en_code"              : ldb_pp_cq_cfg[cq].cq_isr.en_code         = command.options[i].values[idx];
          "cq_isr_vf"                   : ldb_pp_cq_cfg[cq].cq_isr.vf              = command.options[i].values[idx];
          "cq_isr_vector"               : ldb_pp_cq_cfg[cq].cq_isr.vector          = command.options[i].values[idx];
          "pasid"                       : ldb_pp_cq_cfg[cq].pasid                  = command.options[i].values[idx];
          "wu_limit"                    : ldb_pp_cq_cfg[cq].wu_limit               = command.options[i].values[idx];
          "wu_limit_tolerance"          : ldb_pp_cq_cfg[cq].wu_limit_tolerance     = command.options[i].values[idx];
          "lsp_ldb_wrr_count_cq"        : lsp_ldb_wrr_count_cq                     = cq;
          "single_hcw_per_cl"           : begin
                                            if (ldb_cq_single_hcw_per_cl < 0) begin
                                              ldb_cq_single_hcw_per_cl = command.options[i].values[idx];
                                            end else begin
                                              if (ldb_cq_single_hcw_per_cl < 2) begin
                                                if (ldb_cq_single_hcw_per_cl != command.options[i].values[idx]) begin
                                                  `uvm_error("LDB CQ CFG", $psprintf("HQM%0s__single_hcw_per_cl already set to %0d, trying to set to %0d", inst_suffix,ldb_cq_single_hcw_per_cl, command.options[i].values[idx]))
                                                end 
                                              end 
                                            end 
                                          end 
          "palb_on_thrsh"             : ldb_pp_cq_cfg[cq].palb_on_thrsh          = command.options[i].values[idx];
          "palb_off_thrsh"            : ldb_pp_cq_cfg[cq].palb_off_thrsh         = command.options[i].values[idx];
          "ats_resp_errinj"           : begin 
                                           ldb_pp_cq_cfg[cq].cq_ats_resp_errinj  = command.options[i].values[idx];      
                                           uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ldb_pp_cq_cfg[%0d].cq_ats_resp_errinj=%0d", inst_suffix, cq, this.ldb_pp_cq_cfg[cq].cq_ats_resp_errinj), UVM_LOW);
                                        end 
          "ats_inv_ctrl"              : begin 
                                           ldb_pp_cq_cfg[cq].cq_ats_inv_ctrl  = command.options[i].values[idx];      
                                           uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ldb_pp_cq_cfg[%0d].cq_ats_inv_ctrl=%0d", inst_suffix, cq, this.ldb_pp_cq_cfg[cq].cq_ats_inv_ctrl), UVM_LOW);
                                        end 
          "ats_entry_delete"          : begin 
                                           ldb_pp_cq_cfg[cq].cq_ats_entry_delete  = command.options[i].values[idx];      
                                           uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ldb_pp_cq_cfg[%0d].cq_ats_entry_delete=%0d", inst_suffix, cq, this.ldb_pp_cq_cfg[cq].cq_ats_entry_delete), UVM_LOW);
                                        end 



          default: begin
            bit match = 1'b0;

            for (int j = 0 ; j < 8 ; j++) begin
              if ($psprintf("qidv%0d", j) == command.options[i].option.tolower()) begin
                ldb_pp_cq_cfg[cq].qidix[j].qidv = command.options[i].values[idx];
                match = 1'b1;
                break;
              end else if ($psprintf("qidix%0d", j) == command.options[i].option.tolower()) begin
                ldb_pp_cq_cfg[cq].qidix[j].qid  = decode_option_value(prov_ldb_qid,command.options[i]);
                match = 1'b1;
                break;
              end else if ($psprintf("pri%0d", j) == command.options[i].option.tolower()) begin
                ldb_pp_cq_cfg[cq].qidix[j].pri  = command.options[i].values[idx];
                match = 1'b1;
                break;
              end 
            end 

            if (~match) begin
              uvm_report_error("LDB CQ CFG", $psprintf("HQM%0s__Undefined option %s", inst_suffix,command.options[i].option));
            end 
          end 
        endcase
      end 

      if (ldb_cq_single_hcw_per_cl > 0) begin
           set_cfg_val(set_cfg_val_op_write, "credit_hist_pipe", "cfg_chp_csr_control", "cfg_64bytes_qe_ldb_cq_mode", (ldb_cq_single_hcw_per_cl > 0) ? 1 : 0);
           if ($test$plusargs("HQM_CFG_WRITE")) begin
             set_cfg_val(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_chp_csr_control", "cfg_64bytes_qe_ldb_cq_mode", (ldb_cq_single_hcw_per_cl > 0) ? 1 : 0);
           end 
      end 

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_pasid", cq, "fmt2",  this.ldb_pp_cq_cfg[cq].pasid>>22);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_pasid", cq, "pasid", this.ldb_pp_cq_cfg[cq].pasid & 20'hfffff);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ldb_cq_pasid[%0d].fmt2=%0d pasid[19:0]=0x%0x", inst_suffix, cq, this.ldb_pp_cq_cfg[cq].pasid>>22, (this.ldb_pp_cq_cfg[cq].pasid & 20'hfffff)), UVM_LOW);


      i_hqm_pp_cq_status.set_cq_tokens(1'b1,cq,1 << (ldb_pp_cq_cfg[cq].cq_depth + 2));

      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ldb_cq_token_depth_select", cq, "token_depth_select", ldb_pp_cq_cfg[cq].cq_depth);
      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_token_depth_select", cq, "token_depth_select", ldb_pp_cq_cfg[cq].cq_depth);        

      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ldb_cq_depth", cq, "depth", ldb_pp_cq_cfg[cq].cq_token_count);
      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_token_count", cq, "token_count", ldb_pp_cq_cfg[cq].cq_token_count);

      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_disable", cq, "disabled", ~ldb_pp_cq_cfg[cq].cq_enable);
      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_disable", cq, "disabled_pcq", ~ldb_pp_cq_cfg[cq].cq_pcq);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__CQ_PCQ:ldb_pp_cq_cfg[%0d].cq_enable=%0d ldb_pp_cq_cfg[%0d].cq_pcq=%0d", inst_suffix, cq, ldb_pp_cq_cfg[cq].cq_enable, cq, ldb_pp_cq_cfg[cq].cq_pcq), UVM_LOW);

      //--odd cq, if odd cq has cq_pcq=1, reporgram it's paired even cq to have cq_pcq=1 also
      if(ldb_pp_cq_cfg[cq].cq_pcq==1 && cq%2==1 && cq>0) begin
         uvm_report_info("HQM_CFG", $psprintf("HQM%0s__CQ_PCQ: check  odd CQ ldb_pp_cq_cfg[%0d].cq_enable=%0d ldb_pp_cq_cfg[%0d].cq_pcq=%0d", inst_suffix, cq, ldb_pp_cq_cfg[cq].cq_enable, cq, ldb_pp_cq_cfg[cq].cq_pcq), UVM_LOW);
         uvm_report_info("HQM_CFG", $psprintf("HQM%0s__CQ_PCQ: check even CQ ldb_pp_cq_cfg[%0d].cq_enable=%0d ldb_pp_cq_cfg[%0d].cq_pcq=%0d", inst_suffix, cq-1, ldb_pp_cq_cfg[cq-1].cq_enable, cq-1, ldb_pp_cq_cfg[cq-1].cq_pcq), UVM_LOW);
         if(ldb_pp_cq_cfg[cq-1].cq_enable==1) begin // && ldb_pp_cq_cfg[cq-1].cq_pcq==0) begin
            ldb_pp_cq_cfg[cq-1].cq_pcq = 1;
            set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_disable", cq-1, "disabled_pcq", ~ldb_pp_cq_cfg[cq-1].cq_pcq);
            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__CQ_PCQ: reprogram when ldb_pp_cq_cfg[%0d].cq_enable=%0d to set ldb_pp_cq_cfg[%0d].cq_pcq=%0d", inst_suffix, cq-1, ldb_pp_cq_cfg[cq-1].cq_enable, cq-1, ldb_pp_cq_cfg[cq-1].cq_pcq), UVM_LOW);
         end 
      end 

      if (ldb_pp_cq_cfg[cq].wu_limit >= 0) begin
        if (ldb_pp_cq_cfg[cq].wu_limit <= hqm_pkg::NUM_CREDITS) begin
          set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_wu_limit", cq, "v", 1);
          set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_wu_limit", cq, "limit", ldb_pp_cq_cfg[cq].wu_limit);
        end else begin
          `uvm_error(get_full_name(),$psprintf("HQM%0s__wu_limit=%0d exceeds maximum value of value of %0d",inst_suffix,ldb_pp_cq_cfg[cq].wu_limit,hqm_pkg::NUM_CREDITS))
        end 
      end 

      //--04072022: HQMV30 extended histlist
      //--Whenever TB set the cfg_hist_list_base, cfg_hist_list_limit, cfg_hist_list_pop_ptr and cfg_hist_list_push_ptr, it should do the same for the new registers. Both set of registers have to be programmed to the same value 
      //--cfg_hist_list_a_base
      //--cfg_hist_list_a_limit
      //--cfg_hist_list_a_pop_ptr
      //--cfg_hist_list_a_push_ptr
       
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_mode", cq, "hl_exp_mode", ldb_pp_cq_cfg[cq].cq_hl_exp_mode); 

      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_base", cq, "base", ldb_pp_cq_cfg[cq].hist_list_base); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_a_base", cq, "base", ldb_pp_cq_cfg[cq].hist_list_base); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_limit", cq, "limit", ldb_pp_cq_cfg[cq].hist_list_limit); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_a_limit", cq, "limit", ldb_pp_cq_cfg[cq].hist_list_limit); 

      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_push_ptr", cq, "push_ptr", ldb_pp_cq_cfg[cq].hist_list_base); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_a_push_ptr", cq, "push_ptr", ldb_pp_cq_cfg[cq].hist_list_base); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_push_ptr", cq, "generation", 0); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_a_push_ptr", cq, "generation", 0); 

      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_pop_ptr", cq, "pop_ptr", ldb_pp_cq_cfg[cq].hist_list_base); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_a_pop_ptr", cq, "pop_ptr", ldb_pp_cq_cfg[cq].hist_list_base); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_pop_ptr", cq, "generation", 0); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_a_pop_ptr", cq, "generation", 0); 

      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ldb_cq_int_depth_thrsh", cq, "depth_threshold", ldb_pp_cq_cfg[cq].cq_depth_intr_thresh); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ldb_cq_int_enb", cq, "en_depth", ldb_pp_cq_cfg[cq].cq_depth_intr_ena); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ldb_cq_int_enb", cq, "en_tim", ldb_pp_cq_cfg[cq].cq_timer_intr_ena); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ldb_cq_timer_threshold", cq, "thrsh_13_1", ldb_pp_cq_cfg[cq].cq_timer_intr_thresh[13:1]); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ldb_cq_wd_enb", cq, "wd_enable", ldb_pp_cq_cfg[cq].cq_cwdt_intr_ena); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ldb_cq_int_mask", cq, "INT_MASK", {31'h0, ldb_pp_cq_cfg[cq].cq_int_mask}); 

      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ldb_cq_on_off_threshold", cq, "ON_THRSH", ldb_pp_cq_cfg[cq].palb_on_thrsh); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_ldb_cq_on_off_threshold", cq, "OFF_THRSH", ldb_pp_cq_cfg[cq].palb_off_thrsh); 

      cq2pri_v = 0;
      cq2pri = 0;

      for (int qidix = 0 ; qidix < 8 ; qidix++) begin
        if (ldb_pp_cq_cfg[cq].qidix[qidix].qidv) begin
          cq2pri_v[qidix] = 1'b1;
          cq2pri[qidix*3 +: 3] = ldb_pp_cq_cfg[cq].qidix[qidix].pri;
        end 
      end 

      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq2priov", cq, "v", cq2pri_v);
      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq2priov", cq, "prio", cq2pri);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__LDB_CQQID:list_sel_pipe.cfg_cq2priov[%0d].cq2pri_v=0x%0x", inst_suffix,cq, cq2pri_v), UVM_LOW);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__LDB_CQQID:list_sel_pipe.cfg_cq2priov[%0d].cq2pri=0x%0x", inst_suffix,cq, cq2pri), UVM_LOW);

      if(lsp_ldb_wrr_count_base>0) begin
        set_cfg_val(set_cfg_val_op_write, "list_sel_pipe", "cfg_lsp_csr_control", "LDB_WRR_COUNT_BASE", lsp_ldb_wrr_count_base);
        uvm_report_info("HQM_CFG", $psprintf("HQM%0s__LDB_WRR:list_sel_pipe.cfg_lsp_csr_control.LDB_WRR_COUNT_BASE=0x%0x", inst_suffix,lsp_ldb_wrr_count_base), UVM_LOW);
      end 
 
      if(lsp_ldb_wrr_count_cq>0) begin
        if(lsp_ldb_wrr_count_cq==64) lsp_ldb_wrr_count_cq= $urandom_range(0,3);
        set_cfg_val(set_cfg_val_op_write, "list_sel_pipe", "cfg_control_sched_slot_count", "ENAB", 1'b1);
        set_cfg_val(set_cfg_val_op_write, "list_sel_pipe", "cfg_control_sched_slot_count", "CQ", lsp_ldb_wrr_count_cq);
        uvm_report_info("HQM_CFG", $psprintf("HQM%0s__LDB_WRR:list_sel_pipe.cfg_control_sched_slot_count.CQ=0x%0x", inst_suffix,lsp_ldb_wrr_count_cq), UVM_LOW);
      end 

      for (int qidix = 0 ; qidix < 8 ; qidix++) begin
        string field_name;
        string reg_name;

        if (ldb_pp_cq_cfg[cq].qidix[qidix].qidv) begin
          field_name = $psprintf("qid_p%0d",qidix[2:0]);

          if (qidix < 4) begin
            reg_name = "cfg_cq2qid0";
          end else begin
            reg_name = "cfg_cq2qid1";
          end 

          set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", reg_name, cq, field_name, ldb_pp_cq_cfg[cq].qidix[qidix].qid);
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__LDB_CQQID:ldb_pp_cq_cfg[%0d].qidix[%0d].qid=0x%0x", inst_suffix,cq,qidix,ldb_pp_cq_cfg[cq].qidix[qidix].qid), UVM_LOW);
        end 
      end 

      for (int qidix = 0 ; qidix < 8 ; qidix++) begin
        if (ldb_pp_cq_cfg[cq].qidix[qidix].qidv) begin
          string reg_name, reg_name2;

          if(cq/4 > 9) begin
            reg_name  = $psprintf("cfg_qid_ldb_qid2cqidix_%0d[%0d]",cq/4,ldb_pp_cq_cfg[cq].qidix[qidix].qid);
            reg_name2 = $psprintf("cfg_qid_ldb_qid2cqidix2_%0d[%0d]",cq/4,ldb_pp_cq_cfg[cq].qidix[qidix].qid);
          end else begin
            reg_name  = $psprintf("cfg_qid_ldb_qid2cqidix_0%0d[%0d]",cq/4,ldb_pp_cq_cfg[cq].qidix[qidix].qid);
            reg_name2 = $psprintf("cfg_qid_ldb_qid2cqidix2_0%0d[%0d]",cq/4,ldb_pp_cq_cfg[cq].qidix[qidix].qid);
          end 

          case (cq[1:0])
            2'h0: begin
              if (backdoor_mem_update_enable) begin
                or_cfg_val(HQM_CFG_BWRITE, "atm_pipe",      reg_name,  "cq_p0", 1 << qidix); 
                or_cfg_val(HQM_CFG_BWRITE, "list_sel_pipe", reg_name,  "cq_p0", 1 << qidix); 
                or_cfg_val(HQM_CFG_BWRITE, "list_sel_pipe", reg_name2, "cq_p0", 1 << qidix); 
              end else begin
                or_cfg_val(set_cfg_val_op, "atm_pipe",      reg_name,  "cq_p0", 1 << qidix); 
                or_cfg_val(set_cfg_val_op, "list_sel_pipe", reg_name,  "cq_p0", 1 << qidix); 
                or_cfg_val(set_cfg_val_op, "list_sel_pipe", reg_name2, "cq_p0", 1 << qidix); 
              end 
            end 
            2'h1: begin
              if (backdoor_mem_update_enable) begin
                or_cfg_val(HQM_CFG_BWRITE, "atm_pipe",      reg_name,  "cq_p1", 1 << qidix); 
                or_cfg_val(HQM_CFG_BWRITE, "list_sel_pipe", reg_name,  "cq_p1", 1 << qidix); 
                or_cfg_val(HQM_CFG_BWRITE, "list_sel_pipe", reg_name2, "cq_p1", 1 << qidix); 
              end else begin
                or_cfg_val(set_cfg_val_op, "atm_pipe",      reg_name,  "cq_p1", 1 << qidix); 
                or_cfg_val(set_cfg_val_op, "list_sel_pipe", reg_name,  "cq_p1", 1 << qidix); 
                or_cfg_val(set_cfg_val_op, "list_sel_pipe", reg_name2, "cq_p1", 1 << qidix); 
              end 
            end 
            2'h2: begin
              if (backdoor_mem_update_enable) begin
                or_cfg_val(HQM_CFG_BWRITE, "atm_pipe",      reg_name,  "cq_p2", 1 << qidix); 
                or_cfg_val(HQM_CFG_BWRITE, "list_sel_pipe", reg_name,  "cq_p2", 1 << qidix); 
                or_cfg_val(HQM_CFG_BWRITE, "list_sel_pipe", reg_name2, "cq_p2", 1 << qidix); 
              end else begin
                or_cfg_val(set_cfg_val_op, "atm_pipe",      reg_name,  "cq_p2", 1 << qidix); 
                or_cfg_val(set_cfg_val_op, "list_sel_pipe", reg_name,  "cq_p2", 1 << qidix); 
                or_cfg_val(set_cfg_val_op, "list_sel_pipe", reg_name2, "cq_p2", 1 << qidix); 
              end 
            end 
            2'h3: begin
              if (backdoor_mem_update_enable) begin
                or_cfg_val(HQM_CFG_BWRITE, "atm_pipe",      reg_name,  "cq_p3", 1 << qidix); 
                or_cfg_val(HQM_CFG_BWRITE, "list_sel_pipe", reg_name,  "cq_p3", 1 << qidix); 
                or_cfg_val(HQM_CFG_BWRITE, "list_sel_pipe", reg_name2, "cq_p3", 1 << qidix); 
              end else begin
                or_cfg_val(set_cfg_val_op, "atm_pipe",      reg_name,  "cq_p3", 1 << qidix); 
                or_cfg_val(set_cfg_val_op, "list_sel_pipe", reg_name,  "cq_p3", 1 << qidix); 
                or_cfg_val(set_cfg_val_op, "list_sel_pipe", reg_name2, "cq_p3", 1 << qidix); 
              end 
            end 
          endcase
        end 
      end 

      if (ldb_pp_cq_cfg[cq].cq_ldb_inflight_limit_set) begin
        set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_inflight_limit", cq, "limit", ldb_pp_cq_cfg[cq].cq_ldb_inflight_limit); 
      end else begin
         if ($test$plusargs("HQM_LSP_CQ_INFLIGHT_EXTENDED") && !$test$plusargs("HQM_SKIP_CQ_INFLIGHT_EXTENDED")) begin
             ldb_pp_cq_cfg[cq].cq_hl_exp_mode = 1; 
             set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_hist_list_mode", cq, "hl_exp_mode", ldb_pp_cq_cfg[cq].cq_hl_exp_mode); 

             set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_inflight_limit", cq, "limit", (((ldb_pp_cq_cfg[cq].hist_list_limit - ldb_pp_cq_cfg[cq].hist_list_base) + 1) * 2)); 
             i_hqm_pp_cq_status.ldb_pp_cq_status[cq].st_inflight_limit =  ((ldb_pp_cq_cfg[cq].hist_list_limit - ldb_pp_cq_cfg[cq].hist_list_base) + 1) * 2;
         end else begin
             if(ldb_pp_cq_cfg[cq].cq_hl_exp_mode) begin
                set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_inflight_limit", cq, "limit", (((ldb_pp_cq_cfg[cq].hist_list_limit - ldb_pp_cq_cfg[cq].hist_list_base) + 1) * 2)); 
                i_hqm_pp_cq_status.ldb_pp_cq_status[cq].st_inflight_limit =  ((ldb_pp_cq_cfg[cq].hist_list_limit - ldb_pp_cq_cfg[cq].hist_list_base) + 1) * 2;
             end else begin
                set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_inflight_limit", cq, "limit", (ldb_pp_cq_cfg[cq].hist_list_limit - ldb_pp_cq_cfg[cq].hist_list_base) + 1); 
                i_hqm_pp_cq_status.ldb_pp_cq_status[cq].st_inflight_limit =  (ldb_pp_cq_cfg[cq].hist_list_limit - ldb_pp_cq_cfg[cq].hist_list_base) + 1;
             end 
         end 
      end 

      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ldb_pp_cq_cfg[%0d].cq_hl_exp_mode=%0d - limit=0x%0x base=0x%0x - cfg_cq_ldb_inflight_limit=0x%0x ", inst_suffix, cq, this.ldb_pp_cq_cfg[cq].cq_hl_exp_mode, this.ldb_pp_cq_cfg[cq].hist_list_limit, this.ldb_pp_cq_cfg[cq].hist_list_base, i_hqm_pp_cq_status.ldb_pp_cq_status[cq].st_inflight_limit), UVM_LOW);

      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_ldb_inflight_threshold", cq, "thresh", ldb_pp_cq_cfg[cq].cq_ldb_inflight_thresh); 
      uvm_report_info("HQM_CFG", $psprintf("HQMDBG%0s__LDB:ldb_pp_cq_cfg[%0d].cq_gpa=0x%0x  cq_ldb_inflight_thresh=%0d", inst_suffix,cq, ldb_pp_cq_cfg[cq].cq_gpa, ldb_pp_cq_cfg[cq].cq_ldb_inflight_thresh), UVM_LOW);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_addr_l", cq, "addr_l", this.ldb_pp_cq_cfg[cq].cq_gpa[31:6]); 
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_addr_u", cq, "addr_u", this.ldb_pp_cq_cfg[cq].cq_gpa[63:32]); 

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq2vf_pf_ro", cq, "is_pf", this.ldb_pp_cq_cfg[cq].is_pf);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq2vf_pf_ro", cq, "ro", this.ldb_pp_cq_cfg[cq].ro);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", cq, "en_code", this.ldb_pp_cq_cfg[cq].cq_isr.en_code);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", cq, "vf", this.ldb_pp_cq_cfg[cq].cq_isr.vf);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", cq, "vector", this.ldb_pp_cq_cfg[cq].cq_isr.vector);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__ldb_pp_cq_cfg[%0d].cq_isr.en_code=%0d cq_isr.vf=%0d cq_isr.vector=%0d", inst_suffix, cq, this.ldb_pp_cq_cfg[cq].cq_isr.en_code, this.ldb_pp_cq_cfg[cq].cq_isr.vf, this.ldb_pp_cq_cfg[cq].cq_isr.vector), UVM_LOW);

    end 
    else if (command.get_type == HQM_CFG_DIR) begin
      dir_pp_cq_cfg[cq].cq_provisioned = 1'b1;
      if (dir_pp_cq_cfg[cq].cq_enable == 1'b0) begin
        dir_pp_cq_cfg[cq].cq_enable = 1'b1;
        dir_pp_cq_cfg[cq].is_pf = 1'b1;
      end 

      for(int i=0;i<command.options.size;i++) begin
        if (command.options[i].values.size() > 0) begin
          idx = $urandom_range(0, command.options[i].values.size()-1);
        end else begin
          idx = -1;
        end 

        case (command.options[i].option.tolower())
          "enable"                      : dir_pp_cq_cfg[cq].cq_enable              = command.options[i].values[idx]; 
          "disable_wb_opt"              : dir_pp_cq_cfg[cq].disable_wb_opt         = command.options[i].values[idx];
          "cq_depth"                    : begin
                                            case (command.options[i].values[idx])
                                              4:        dir_pp_cq_cfg[cq].cq_depth = DEPTH_4;
                                              8:        dir_pp_cq_cfg[cq].cq_depth = DEPTH_8;
                                              16:       dir_pp_cq_cfg[cq].cq_depth = DEPTH_16;
                                              32:       dir_pp_cq_cfg[cq].cq_depth = DEPTH_32;
                                              64:       dir_pp_cq_cfg[cq].cq_depth = DEPTH_64;
                                              128:      dir_pp_cq_cfg[cq].cq_depth = DEPTH_128;
                                              256:      dir_pp_cq_cfg[cq].cq_depth = DEPTH_256;
                                              512:      begin
                                                          if($test$plusargs("ATS_4KPAGE_ONLY"))  dir_pp_cq_cfg[cq].cq_depth = DEPTH_256;
                                                          else                                   dir_pp_cq_cfg[cq].cq_depth = DEPTH_512;
                                                        end 
                                              1024:     begin
                                                          if($test$plusargs("ATS_4KPAGE_ONLY"))  dir_pp_cq_cfg[cq].cq_depth = DEPTH_256;
                                                          else                                   dir_pp_cq_cfg[cq].cq_depth = DEPTH_1024;
                                                        end 

                                              2048:     begin
                                                        if($test$plusargs("ATS_4KPAGE_ONLY")) begin
                                                          dir_pp_cq_cfg[cq].cq_depth = DEPTH_256;                       
                                                        end else begin
                                                          if (dir_cq_single_hcw_per_cl > 0) begin
                                                            if ($test$plusargs("HQM_SATURATE_CQ_DEPTH_OK")) begin
                                                              dir_pp_cq_cfg[cq].cq_depth = DEPTH_1024;
                                                              `uvm_info("DIR CQ CFG", $psprintf("HQM%0s__Single HCW per cache line enabled cq_depth of %0d reduced to 1024", inst_suffix,command.options[i].values[idx]),UVM_LOW)
                                                            end else begin
                                                              `uvm_error("DIR CQ CFG", $psprintf("HQM%0s__Single HCW per cache line illegal cq_depth of %0d, should be 8, 16, 32, 64, 128, 256, 512 or 1024",
                                                                                                 inst_suffix,command.options[i].values[idx]))
                                                            end 
                                                          end else begin
                                                            dir_pp_cq_cfg[cq].cq_depth = DEPTH_2048;
                                                          end 
                                                        end 
                                                        end 
                                              4096:     begin
                                                        if($test$plusargs("ATS_4KPAGE_ONLY")) begin
                                                          dir_pp_cq_cfg[cq].cq_depth = DEPTH_256;                       
                                                        end else begin
                                                          if (dir_cq_single_hcw_per_cl > 0) begin
                                                            if ($test$plusargs("HQM_SATURATE_CQ_DEPTH_OK")) begin
                                                              dir_pp_cq_cfg[cq].cq_depth = DEPTH_1024;
                                                              `uvm_info("DIR CQ CFG", $psprintf("HQM%0s__Single HCW per cache line enabled cq_depth of %0d reduced to 1024", inst_suffix,command.options[i].values[idx]),UVM_LOW)
                                                            end else begin
                                                              `uvm_error("DIR CQ CFG", $psprintf("HQM%0s__Single HCW per cache line illegal cq_depth of %0d, should be 8, 16, 32, 64, 128, 256, 512 or 1024",
                                                                                                 inst_suffix,command.options[i].values[idx]))
                                                            end 
                                                          end else begin
                                                            dir_pp_cq_cfg[cq].cq_depth = DEPTH_4096;
                                                          end 
                                                        end 
                                                        end 
                                              default: begin
                                                `uvm_error("DIR CQ CFG", $psprintf("HQM%0s__Illegal cq_depth of %0d, should be 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096",
                                                                                   inst_suffix,command.options[i].values[idx]))
                                              end 
                                            endcase

                                            //--post program
                                            if($test$plusargs("ATS_4KPAGE_ONLY") && (dir_cq_single_hcw_per_cl > 0) && (dir_pp_cq_cfg[cq].cq_depth > DEPTH_64)) begin
                                                 `uvm_info("DIR CQ CFG", $psprintf("HQM%0s__DIR_CQ_DEPTH dir_cq_single_hcw_per_cl=%0d => cq_depth of %0d reduced to DEPTH_64 when +ATS_4KPAGE_ONLY", inst_suffix, dir_cq_single_hcw_per_cl, dir_pp_cq_cfg[cq].cq_depth),UVM_LOW)
                                                  dir_pp_cq_cfg[cq].cq_depth = DEPTH_64;
                                            end else if($test$plusargs("ATS_4KPAGE_ONLY") && (dir_pp_cq_cfg[cq].cq_depth > DEPTH_256)) begin
                                                 `uvm_info("DIR CQ CFG", $psprintf("HQM%0s__DIR_CQ_DEPTH dir_cq_single_hcw_per_cl=%0d => cq_depth of %0d reduced to DEPTH_256 when +ATS_4KPAGE_ONLY", inst_suffix, dir_cq_single_hcw_per_cl, dir_pp_cq_cfg[cq].cq_depth),UVM_LOW)
                                                  dir_pp_cq_cfg[cq].cq_depth = DEPTH_256;
                                            end 

                                          end 
          "cq_token_count"              : dir_pp_cq_cfg[cq].cq_token_count         = command.options[i].values[idx];
          "cq_timer_intr_thresh"        : dir_pp_cq_cfg[cq].cq_timer_intr_thresh   = command.options[i].values[idx];
          "cq_timer_intr_ena"           : dir_pp_cq_cfg[cq].cq_timer_intr_ena      = command.options[i].values[idx];
          "cq_depth_intr_thresh"        : dir_pp_cq_cfg[cq].cq_depth_intr_thresh   = command.options[i].values[idx];
          "cq_depth_intr_ena"           : dir_pp_cq_cfg[cq].cq_depth_intr_ena      = command.options[i].values[idx];
          "cq_cwdt_intr_ena"            : dir_pp_cq_cfg[cq].cq_cwdt_intr_ena       = command.options[i].values[idx];
          "cq_int_mask"                 : dir_pp_cq_cfg[cq].cq_int_mask            = command.options[i].values[idx];
          "gpa"                         : begin
                                            if ($test$plusargs("HQM_CQ_DEPTH_MAX")) begin
                                              dir_pp_cq_cfg[cq].cq_gpa                 = decode_cq_gpa(command.options[i],idx,$psprintf("HQM%s_DIR_CQ_%0d_MEM",inst_suffix,cq),((dir_cq_single_hcw_per_cl > 0) ? 64'h100 : 64'h40) << 1024,64'h3f, 1'b0, cq);
                                            end else begin
                                              if(dir_cq_single_hcw_per_cl>0) begin
                                                 mem_size_val = 64'h100 << dir_pp_cq_cfg[cq].cq_depth;     
                                              end else begin
                                                 mem_size_val = 64'h40 << dir_pp_cq_cfg[cq].cq_depth;
                                              end 

                                              uvm_report_info("HQM_CFG", $psprintf("HQM%0s__curr_hqm_trf_loop=%0d", inst_suffix, hqm_trf_loop), UVM_LOW);
                                              if(hqm_trf_loop==0) begin
                                                 //--regular case without ATS INV issued
                                                 //--HQMV25-- dir_pp_cq_cfg[cq].cq_gpa                 = decode_cq_gpa(command.options[i],idx,$psprintf("HQM%s_DIR_CQ_%0d_MEM",inst_suffix,cq),((dir_cq_single_hcw_per_cl > 0) ? 64'h100 : 64'h40) << dir_pp_cq_cfg[cq].cq_depth,pb_addr_mask, 1'b0, cq);
                                                 dir_pp_cq_cfg[cq].cq_gpa                 = decode_cq_gpa(command.options[i], idx, $psprintf("HQM%s_DIR_CQ_%0d_MEM",inst_suffix,cq), mem_size_val, pb_addr_mask, 1'b0, cq);
                                              end else begin
                                                 //--after FLR with hqm_trf_loop>0, reprogram cq_addr (phy/vir)
                                                 dir_pp_cq_cfg[cq].cq_gpa                 = decode_cq_gpa(command.options[i], idx, $psprintf("HQM%s_DIR_CQ_%0d_REALLOCMEM%0d",inst_suffix,cq,hqm_trf_loop), mem_size_val, pb_addr_mask, 1'b0, cq);
                                              end 
                                            end 
                                          end 
          "is_keep_pf_ppid"             : dir_pp_cq_cfg[cq].dir_cq_fmt.keep_pf_ppid = command.options[i].values[idx];
          "cq_isr_en_code"              : dir_pp_cq_cfg[cq].cq_isr.en_code         = command.options[i].values[idx];
          "cq_isr_vf"                   : dir_pp_cq_cfg[cq].cq_isr.vf              = command.options[i].values[idx];
          "cq_isr_vector"               : dir_pp_cq_cfg[cq].cq_isr.vector          = command.options[i].values[idx];
          "pasid"                       : dir_pp_cq_cfg[cq].pasid                  = command.options[i].values[idx];
          "single_hcw_per_cl"           : begin
                                            if (dir_cq_single_hcw_per_cl < 0) begin
                                              dir_cq_single_hcw_per_cl = command.options[i].values[idx];
                                            end else begin
                                              if (dir_cq_single_hcw_per_cl < 2) begin
                                                if (dir_cq_single_hcw_per_cl != command.options[i].values[idx]) begin
                                                  `uvm_error("DIR CQ CFG", $psprintf("HQM%0s__single_hcw_per_cl already set to %0d, trying to set to %0d", inst_suffix,dir_cq_single_hcw_per_cl, command.options[i].values[idx]))
                                                end 
                                              end 
                                            end 
                                          end 
          "ats_resp_errinj"            : begin 
                                           dir_pp_cq_cfg[cq].cq_ats_resp_errinj  = command.options[i].values[idx];      
                                           uvm_report_info("HQM_CFG", $psprintf("HQM%0s__dir_pp_cq_cfg[%0d].cq_ats_resp_errinj=%0d", inst_suffix, cq, this.dir_pp_cq_cfg[cq].cq_ats_resp_errinj), UVM_LOW);
                                         end 
          "ats_inv_ctrl"              : begin 
                                           dir_pp_cq_cfg[cq].cq_ats_inv_ctrl  = command.options[i].values[idx];      
                                           uvm_report_info("HQM_CFG", $psprintf("HQM%0s__dir_pp_cq_cfg[%0d].cq_ats_inv_ctrl=%0d", inst_suffix, cq, this.dir_pp_cq_cfg[cq].cq_ats_inv_ctrl), UVM_LOW);
                                        end 
          "ats_entry_delete"          : begin 
                                           dir_pp_cq_cfg[cq].cq_ats_entry_delete  = command.options[i].values[idx];      
                                           uvm_report_info("HQM_CFG", $psprintf("HQM%0s__dir_pp_cq_cfg[%0d].cq_ats_entry_delete=%0d", inst_suffix, cq, this.dir_pp_cq_cfg[cq].cq_ats_entry_delete), UVM_LOW);
                                        end 

          default: begin
            uvm_report_error("DIR CQ CFG", $psprintf("HQM%0s__Undefined option %s", inst_suffix,command.options[i].option));
          end 
        endcase
      end       

      if (dir_cq_single_hcw_per_cl > 0) begin
          set_cfg_val(set_cfg_val_op_write, "credit_hist_pipe", "cfg_chp_csr_control", "cfg_64bytes_qe_dir_cq_mode", (dir_cq_single_hcw_per_cl > 0) ? 1 : 0);
          if ($test$plusargs("HQM_CFG_WRITE")) begin
             set_cfg_val(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_chp_csr_control", "cfg_64bytes_qe_dir_cq_mode", (dir_cq_single_hcw_per_cl > 0) ? 1 : 0);
          end 
      end 
      uvm_report_info("HQM_CFG", $psprintf("HQMDBG%0s__DIR:dir_pp_cq_cfg[%0d].cq_gpa=0x%0x", inst_suffix,cq, dir_pp_cq_cfg[cq].cq_gpa), UVM_LOW);     

      i_hqm_pp_cq_status.set_cq_tokens(1'b0,cq,1 << (dir_pp_cq_cfg[cq].cq_depth + 2));

      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_dir_token_depth_select_dsi", cq, "disable_wb_opt", this.dir_pp_cq_cfg[cq].disable_wb_opt);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_pasid", cq, "fmt2",  this.dir_pp_cq_cfg[cq].pasid>>22);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_pasid", cq, "pasid", this.dir_pp_cq_cfg[cq].pasid & 20'hfffff);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__dir_cq_pasid[%0d].fmt2=%0d pasid[19:0]=0x%0x", inst_suffix, cq, this.dir_pp_cq_cfg[cq].pasid>>22, (this.dir_pp_cq_cfg[cq].pasid & 20'hfffff)), UVM_LOW);

      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_dir_cq_token_depth_select", cq, "token_depth_select", dir_pp_cq_cfg[cq].cq_depth);
      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_dir_token_depth_select_dsi", cq, "token_depth_select", dir_pp_cq_cfg[cq].cq_depth);

      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_dir_cq_depth", cq, "depth", dir_pp_cq_cfg[cq].cq_token_count);
      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_dir_token_count", cq, "count", dir_pp_cq_cfg[cq].cq_token_count);

      if (dir_cq_single_hcw_per_cl > 0) begin
        set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_dir_token_depth_select_dsi", cq, "disable_wb_opt", (dir_cq_single_hcw_per_cl > 0) ? 1 : 0);
      end 
      set_cfg_val_index(set_cfg_val_op, "list_sel_pipe", "cfg_cq_dir_disable", cq, "disabled", ~dir_pp_cq_cfg[cq].cq_enable);

      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_dir_cq_int_depth_thrsh", cq, "depth_threshold", dir_pp_cq_cfg[cq].cq_depth_intr_thresh); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_dir_cq_int_enb", cq, "en_depth", dir_pp_cq_cfg[cq].cq_depth_intr_ena); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_dir_cq_int_enb", cq, "en_tim", dir_pp_cq_cfg[cq].cq_timer_intr_ena); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_dir_cq_timer_threshold", cq, "thrsh_13_1", dir_pp_cq_cfg[cq].cq_timer_intr_thresh[13:1]); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_dir_cq_wd_enb", cq, "wd_enable", dir_pp_cq_cfg[cq].cq_cwdt_intr_ena); 
      set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_dir_cq_int_mask", cq, "INT_MASK", {31'h0, dir_pp_cq_cfg[cq].cq_int_mask}); 

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_addr_l", cq, "addr_l", this.dir_pp_cq_cfg[cq].cq_gpa[31:6]); 
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_addr_u", cq, "addr_u", this.dir_pp_cq_cfg[cq].cq_gpa[63:32]); 

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq2vf_pf_ro", cq, "is_pf", this.dir_pp_cq_cfg[cq].is_pf);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq2vf_pf_ro", cq, "ro", this.dir_pp_cq_cfg[cq].ro);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", cq, "en_code", this.dir_pp_cq_cfg[cq].cq_isr.en_code);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", cq, "vf", this.dir_pp_cq_cfg[cq].cq_isr.vf);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", cq, "vector", this.dir_pp_cq_cfg[cq].cq_isr.vector);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__dir_pp_cq_cfg[%0d].cq_isr.en_code=%0d cq_isr.vf=%0d cq_isr.vector=%0d", inst_suffix, cq, this.dir_pp_cq_cfg[cq].cq_isr.en_code, this.dir_pp_cq_cfg[cq].cq_isr.vf, this.dir_pp_cq_cfg[cq].cq_isr.vector), UVM_LOW);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_fmt", cq, "keep_pf_ppid", this.dir_pp_cq_cfg[cq].dir_cq_fmt.keep_pf_ppid);
    end 

    cq_command_handler = HQM_CFG_CMD_DONE;
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::msix_command_handler(hqm_cfg_command command);
    int         msix_num;
    int         idx;

    msix_command_handler = HQM_CFG_CMD_NOT_DONE;

    if ((command.get_type() != HQM_CFG_MSIX_CQ) && (command.get_type() != HQM_CFG_MSIX_ALARM)) begin
      return(msix_command_handler);
    end 

    if (command.get_type() == HQM_CFG_MSIX_CQ) begin
      msix_num = resolve_value(command,1,hqm_system_pkg::HQM_SYSTEM_NUM_MSIX,avail_msix_cq,avail_msix_cq,prov_msix_cq,prov_msix_cq);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX CFG: MSIX msix_num=%0d ", inst_suffix,msix_num), UVM_LOW);     

      if ((msix_num < 1) || (msix_num >= hqm_system_pkg::HQM_SYSTEM_NUM_MSIX)) return(msix_command_handler);

      msix_cfg[msix_num].enable         = 1'b1;

      for(int i=0;i<command.options.size;i++) begin
        if (command.options[i].values.size() > 0) begin
          idx = $urandom_range(0, command.options[i].values.size()-1);
        end else begin
          idx = -1;
        end 

        case (command.options[i].option.tolower())
          "enable"                      : msix_cfg[msix_num].enable     = command.options[i].values[idx]; 
          "addr"                        : begin
                                              msix_cfg[msix_num].addr       = decode_msix_addr(command.options[i],idx,msix_num,msix_cfg[msix_num].is_ldb,msix_cfg[msix_num].cq);
                                              uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX CFG: MSIX msix_num=%0d addr=0x%0x", inst_suffix,msix_num, msix_cfg[msix_num].addr), UVM_LOW);     
                                          end 
          "data"                        : begin
                                              msix_cfg[msix_num].data       = command.options[i].values[idx]; 
                                              uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX CFG: MSIX msix_num=%0d data=0x%0x", inst_suffix,msix_num, msix_cfg[msix_num].data), UVM_LOW);     
                                          end 

          "is_ldb"                      : msix_cfg[msix_num].is_ldb     = command.options[i].values[idx]; 
          "mode"                        : begin
                                            if (msix_num == 1) begin
                                              msix_mode                 = command.options[i].values[idx]; 
                                              uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX CFG: MSIX msix_num=%d msix_mode=%0d", inst_suffix,msix_num, msix_mode), UVM_LOW);     
                                            end 
                                          end 
          "cq"                          : begin
                                            if (command.options[i].values[idx] >= 0) begin
                                              msix_cfg[msix_num].cq         = command.options[i].values[idx]; 
                                            end else begin
                                              uvm_report_error("MSIX CFG", $psprintf("HQM%0s__MSIX cq=%d is less than 0", inst_suffix,command.options[i].values[idx]));
                                            end 
                                          end 
          default: begin
            uvm_report_error("MSIX CFG", $psprintf("HQM%0s__Undefined option %s", inst_suffix,command.options[i].option));
          end 
        endcase
      end 

      msix_enabled    = 1'b1;

      if (!$test$plusargs("has_hqm_proc_tb")) begin
        set_cfg_val(set_cfg_val_op_write, "hqm_pf_cfg_i", "msix_cap_control", "msixen", msix_enabled);
      end 

      set_cfg_val_index(set_cfg_val_op, "hqm_msix_mem", "vector_ctrl", msix_num, "vec_mask", ~msix_cfg[msix_num].enable);
      set_cfg_val_index(set_cfg_val_op, "hqm_msix_mem", "msg_addr_l", msix_num, "msg_addr_l", msix_cfg[msix_num].addr[31:2]);
      set_cfg_val_index(set_cfg_val_op, "hqm_msix_mem", "msg_addr_u", msix_num, "msg_addr_u", msix_cfg[msix_num].addr[63:32]);
      set_cfg_val_index(set_cfg_val_op, "hqm_msix_mem", "msg_data", msix_num, "msg_data", msix_cfg[msix_num].data);

      if (msix_num == 1) begin
        set_cfg_val(set_cfg_val_op, "hqm_system_csr", "msix_mode", "mode", msix_mode);
        uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX CFG: hqm_system_csr.msix_mode.mode=%d", inst_suffix,msix_mode), UVM_LOW);     
      end 

      if (msix_cfg[msix_num].cq >= 0) begin
        if (msix_cfg[msix_num].is_ldb) begin
          if ((msix_cfg[msix_num].cq >= 0) && (msix_cfg[msix_num].cq < hqm_pkg::NUM_LDB_PP)) begin
            ldb_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.en_code     = 2'b10;
            ldb_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.vf          = '0;
            ldb_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.vector      = msix_num - 1;

            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", msix_cfg[msix_num].cq, "en_code", this.ldb_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.en_code);
            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", msix_cfg[msix_num].cq, "vf", this.ldb_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.vf);
            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", msix_cfg[msix_num].cq, "vector", this.ldb_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.vector);
            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX CFG: hqm_system_csr.ldb_cq_isr[msix_num%0d]", inst_suffix,msix_num), UVM_LOW);     
          end else begin
            uvm_report_error("MSIX CFG", $psprintf("HQM%0s__Illegal MSIX %d LDB CQ %d", inst_suffix,msix_num, msix_cfg[msix_num].cq));
          end 
        end else begin
          if ((msix_cfg[msix_num].cq >= 0) && (msix_cfg[msix_num].cq < hqm_pkg::NUM_DIR_PP)) begin
            dir_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.en_code     = 2'b10;
            dir_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.vf          = '0;
            dir_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.vector      = msix_num - 1;

            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", msix_cfg[msix_num].cq, "en_code", this.dir_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.en_code);
            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", msix_cfg[msix_num].cq, "vf", this.dir_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.vf);
            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", msix_cfg[msix_num].cq, "vector", this.dir_pp_cq_cfg[msix_cfg[msix_num].cq].cq_isr.vector);
            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX CFG: hqm_system_csr.dir_cq_isr[msix_num%0d]", inst_suffix,msix_num), UVM_LOW);     
          end else begin
            uvm_report_error("MSIX CFG", $psprintf("HQM%0s__Illegal MSIX %d DIR CQ %d", inst_suffix,msix_num, msix_cfg[msix_num].cq));
          end 
        end 
      end 
    end else if (command.get_type() == HQM_CFG_MSIX_ALARM) begin
      msix_num = command.label_value;

      if (msix_num != 0) begin
        uvm_report_error("MSIX ALARM", $psprintf("HQM%0s__Illegal MSIX number - %0d", inst_suffix,msix_num));
        return(msix_command_handler);
      end 

      msix_cfg[msix_num].enable         = 1'b1;

      for(int i=0;i<command.options.size;i++) begin
        if (command.options[i].values.size() > 0) begin
          idx = $urandom_range(0, command.options[i].values.size()-1);
        end else begin
          idx = -1;
        end 

        case (command.options[i].option.tolower())
          "enable"                      : msix_cfg[msix_num].enable     = command.options[i].values[idx]; 
          "addr"                        : msix_cfg[msix_num].addr       = command.options[i].values[idx] & 64'hffff_ffff_ffff_fffc; 
          "data"                        : msix_cfg[msix_num].data       = command.options[i].values[idx]; 
          default: begin
            uvm_report_error("MSIX ALARM", $psprintf("HQM%0s__Undefined option %s", inst_suffix,command.options[i].option));
          end 
        endcase
      end 

      msix_enabled    = 1'b1;

      if (!$test$plusargs("has_hqm_proc_tb")) begin
        set_cfg_val(set_cfg_val_op_write, "hqm_pf_cfg_i", "msix_cap_control", "msixen", msix_enabled);
      end 

      set_cfg_val_index(set_cfg_val_op, "hqm_msix_mem", "vector_ctrl", msix_num, "vec_mask", ~msix_cfg[msix_num].enable);
      set_cfg_val_index(set_cfg_val_op, "hqm_msix_mem", "msg_addr_l", msix_num, "msg_addr_l", msix_cfg[msix_num].addr[31:2]);
      set_cfg_val_index(set_cfg_val_op, "hqm_msix_mem", "msg_addr_u", msix_num, "msg_addr_u", msix_cfg[msix_num].addr[63:32]);
      set_cfg_val_index(set_cfg_val_op, "hqm_msix_mem", "msg_data", msix_num, "msg_data", msix_cfg[msix_num].data);

    end 

    msix_command_handler = HQM_CFG_CMD_DONE;
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::ims_command_handler(hqm_cfg_command command);
    int         cq_num;
    int         idx;
    bit [7:0]   ims_index;

    ims_command_handler = HQM_CFG_CMD_NOT_DONE;

    if (((command.get_type() != HQM_CFG_LDB) && (command.get_type() != HQM_CFG_DIR)) || (command.get_target() != "ims")) begin
      return(ims_command_handler);
    end 

    if (command.get_type() == HQM_CFG_DIR) begin
      cq_num = resolve_name(command.label_value_str,command.label_value,hqm_pkg::NUM_DIR_CQ);

      if ((cq_num < 0) || (cq_num >= hqm_pkg::NUM_DIR_CQ)) return(ims_command_handler);

      dir_ims_cfg[cq_num].enable         = 1'b1;
      dir_ims_cfg[cq_num].ims_idx        = cq_num; //--03192021 default, unless set by "ims_idx" command

      for(int i=0;i<command.options.size;i++) begin
        if (command.options[i].values.size() > 0) begin
          idx = $urandom_range(0, command.options[i].values.size()-1);
        end else begin
          idx = -1;
        end 

        case (command.options[i].option.tolower())
          "enable"                      : dir_ims_cfg[cq_num].enable     = command.options[i].values[idx]; 
          "addr"                        : dir_ims_cfg[cq_num].addr       = decode_ims_addr(command.options[i],idx,1'b0,cq_num);
          "data"                        : dir_ims_cfg[cq_num].data       = command.options[i].values[idx]; 
          "ctrl"                        : dir_ims_cfg[cq_num].ctrl       = command.options[i].values[idx]; 
          "ims_idx"                     : dir_ims_cfg[cq_num].ims_idx    = command.options[i].values[idx]; 
          "poll_mode"                   : begin
                                            ims_poll_mode            = command.options[i].values[idx]; 
                                            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS CFG: DIR IMS num=%0d ims_poll_mode=%0d", inst_suffix,cq_num, ims_poll_mode), UVM_LOW);     
                                          end 
          default: begin
            uvm_report_error("DIR IMS CFG", $psprintf("HQM%0s__Undefined option %s", inst_suffix,command.options[i].option));
          end 
        endcase
      end 

      dir_pp_cq_cfg[cq_num].cq_isr.en_code     = (dir_ims_cfg[cq_num].enable) ? 2'b11 : 2'b00;

      //--03192021
      //if (!ims_poll_mode) begin
      //  dir_pp_cq_cfg[cq_num].cq_isr.vf          = '0;
      //  dir_pp_cq_cfg[cq_num].cq_isr.vector      = '0;
      //end 
      dir_pp_cq_cfg[cq_num].cq_isr.vf            = dir_ims_cfg[cq_num].ims_idx[7:6];
      dir_pp_cq_cfg[cq_num].cq_isr.vector        = dir_ims_cfg[cq_num].ims_idx[5:0];
      ims_index                                  = dir_ims_cfg[cq_num].ims_idx;

      if (ims_poll_mode) begin
        if (is_sriov_mode()) begin
          if (dir_pp_cq_cfg[cq_num].is_pf) begin
            dir_ims_cfg[cq_num].data[31:27] = 5'h10;
          end else begin
            dir_ims_cfg[cq_num].data[31:27] = dir_pp_cq_cfg[cq_num].vf;
          end 
        end else if (is_sciov_mode()) begin
          //--AY_HQMV30_ATS -- dir_pp_cq_cfg[cq_num].pasid[22] = 1'b1; //--AY:: When setting to use ims_poll_mode, the first time programming of pasid should program fmt2=1 to make sure page-builder setup uses correct pasid_enable 
          if(dir_pp_cq_cfg[cq_num].pasid>>22 != 1) begin
             `uvm_error("HQM_CFG", $psprintf("HQM%0s__SCIOV_IMS_POLL_MODE:: dir_ims_cfg[%0d].data[31:12]=0x%0x; dir_cq_pasid[%0d].fmt2=%0d (is not set to 1, programming issue to fix) pasid[19:0]=0x%0x", inst_suffix, cq_num, dir_ims_cfg[cq_num].data[31:12], cq_num, this.dir_pp_cq_cfg[cq_num].pasid>>22, (this.dir_pp_cq_cfg[cq_num].pasid & 20'hfffff)));
          end 
          set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_pasid", cq_num, "fmt2",  dir_pp_cq_cfg[cq_num].pasid>>22); //1);
          set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_pasid", cq_num, "pasid", dir_pp_cq_cfg[cq_num].pasid & 20'hfffff);
          dir_ims_cfg[cq_num].data[31:12] = dir_pp_cq_cfg[cq_num].pasid[19:0];
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__SCIOV_IMS_POLL_MODE:: dir_ims_cfg[%0d].data[31:12]=0x%0x; dir_cq_pasid[%0d].fmt2=%0d pasid[19:0]=0x%0x", inst_suffix, cq_num, dir_ims_cfg[cq_num].data[31:12], cq_num, this.dir_pp_cq_cfg[cq_num].pasid>>22, (this.dir_pp_cq_cfg[cq_num].pasid & 20'hfffff)), UVM_LOW);
        end else begin
          dir_ims_cfg[cq_num].data[31:27] = 5'h10;
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS_POLL_MODE:: dir_ims_cfg[%0d].data[31:27]=0x%0x", inst_suffix,cq_num, dir_ims_cfg[cq_num].data[31:27]), UVM_MEDIUM);     
        end 
      end 

      ims_prog_cfg[ims_index].enable = 1;
      ims_prog_cfg[ims_index].is_ldb = 0;
      ims_prog_cfg[ims_index].cq     = cq_num;
      ims_prog_cfg[ims_index].addr   = dir_ims_cfg[cq_num].addr;
      ims_prog_cfg[ims_index].data   = dir_ims_cfg[cq_num].data;
      ims_prog_cfg[ims_index].ctrl   = dir_ims_cfg[cq_num].ctrl;

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", cq_num, "en_code", this.dir_pp_cq_cfg[cq_num].cq_isr.en_code);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", cq_num, "vf", this.dir_pp_cq_cfg[cq_num].cq_isr.vf);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", cq_num, "vector", this.dir_pp_cq_cfg[cq_num].cq_isr.vector);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ai_addr_l", ims_index, "ims_addr_l", dir_ims_cfg[cq_num].addr[31:2]);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ai_addr_u", ims_index, "ims_addr_u", dir_ims_cfg[cq_num].addr[63:32]);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ai_data", ims_index, "ims_data", dir_ims_cfg[cq_num].data);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ai_ctrl", ims_index, "ims_mask", dir_ims_cfg[cq_num].ctrl[0]);

      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS:: dir_ims_cfg[%0d].en_code=%0d ims_idx=%0d; ai_ctrl=0x%0x ai_addr=0x%0x ai_data=0x%0x", inst_suffix,cq_num, this.dir_pp_cq_cfg[cq_num].cq_isr.en_code, dir_ims_cfg[cq_num].ims_idx, dir_ims_cfg[cq_num].ctrl, dir_ims_cfg[cq_num].addr, dir_ims_cfg[cq_num].data), UVM_MEDIUM);     
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS_PROG:: ims_prog_cfg[%0d].is_ldb=0 cq=%0d addr=0x%0x data=0x%0x", inst_suffix, ims_index, cq_num, ims_prog_cfg[ims_index].addr, ims_prog_cfg[ims_index].data), UVM_MEDIUM);     

    end else if (command.get_type() == HQM_CFG_LDB) begin
      cq_num = resolve_name(command.label_value_str,command.label_value,hqm_pkg::NUM_LDB_CQ);

      if ((cq_num < 0) || (cq_num >= hqm_pkg::NUM_LDB_CQ)) return(ims_command_handler);

      ldb_ims_cfg[cq_num].enable         = 1'b1;
      ldb_ims_cfg[cq_num].ims_idx        = hqm_pkg::NUM_DIR_CQ + cq_num; //--03192021 default, unless set by "ims_idx" command

      for(int i=0;i<command.options.size;i++) begin
        if (command.options[i].values.size() > 0) begin
          idx = $urandom_range(0, command.options[i].values.size()-1);
        end else begin
          idx = -1;
        end 

        case (command.options[i].option.tolower())
          "enable"                      : ldb_ims_cfg[cq_num].enable     = command.options[i].values[idx]; 
          "addr"                        : ldb_ims_cfg[cq_num].addr       = decode_ims_addr(command.options[i],idx,1'b1,cq_num);
          "data"                        : ldb_ims_cfg[cq_num].data       = command.options[i].values[idx]; 
          "ctrl"                        : ldb_ims_cfg[cq_num].ctrl       = command.options[i].values[idx]; 
          "ims_idx"                     : ldb_ims_cfg[cq_num].ims_idx    = command.options[i].values[idx]; 
          "poll_mode"                   : begin
                                            ims_poll_mode            = command.options[i].values[idx]; 
                                            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS CFG: LDB IMS num=%0d ims_poll_mode=%0d", inst_suffix,cq_num, ims_poll_mode), UVM_LOW);     
                                          end 
          default: begin
            uvm_report_error("LDB IMS CFG", $psprintf("HQM%0s__Undefined option %s", inst_suffix,command.options[i].option));
          end 
        endcase
      end 

      ldb_pp_cq_cfg[cq_num].cq_isr.en_code     = (ldb_ims_cfg[cq_num].enable) ? 2'b11 : 2'b00;

      if (ims_poll_mode) begin
        if (is_sriov_mode()) begin
          if (ldb_pp_cq_cfg[cq_num].is_pf) begin
            ldb_ims_cfg[cq_num].data[31:27] = 5'h10;
            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__SRIOV_is_pf_IMS_POLL_MODE:: ldb_ims_cfg[%0d].addr=0x%0x data[31:27]=0x%0x", inst_suffix,cq_num, ldb_ims_cfg[cq_num].addr, ldb_ims_cfg[cq_num].data[31:27]), UVM_MEDIUM);
          end else begin
            ldb_ims_cfg[cq_num].data[31:27] = ldb_pp_cq_cfg[cq_num].vf;
            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__SRIOV_IMS_POLL_MODE:: ldb_ims_cfg[%0d].addr=0x%0x data[31:27]=0x%0x", inst_suffix,cq_num, ldb_ims_cfg[cq_num].addr, ldb_ims_cfg[cq_num].data[31:27]), UVM_MEDIUM);
          end 
        end else if (is_sciov_mode()) begin
          //--AY_HQMV30_ATS -- ldb_pp_cq_cfg[cq_num].pasid[22] = 1'b1; //--AY:: When setting to use ims_poll_mode, the first time programming of pasid should program fmt2=1 to make sure page-builder setup uses correct pasid_enable 
          if(ldb_pp_cq_cfg[cq_num].pasid>>22 != 1) begin
             `uvm_error("HQM_CFG", $psprintf("HQM%0s__SCIOV_IMS_POLL_MODE:: ldb_ims_cfg[%0d].data[31:12]=0x%0x; ldb_cq_pasid[%0d].fmt2=%0d (is not set to 1, programming issue to fix) pasid[19:0]=0x%0x", inst_suffix, cq_num, ldb_ims_cfg[cq_num].data[31:12], cq_num, this.ldb_pp_cq_cfg[cq_num].pasid>>22, (this.ldb_pp_cq_cfg[cq_num].pasid & 20'hfffff)));
          end 
          set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_pasid", cq_num, "fmt2",  ldb_pp_cq_cfg[cq_num].pasid>>22); //1
          set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_pasid", cq_num, "pasid", ldb_pp_cq_cfg[cq_num].pasid & 20'hfffff);
          ldb_ims_cfg[cq_num].data[31:12] = ldb_pp_cq_cfg[cq_num].pasid[19:0];
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__SCIOV_IMS_POLL_MODE:: ldb_ims_cfg[%0d].data[31:12]=0x%0x; ldb_cq_pasid[%0d].fmt2=%0d pasid[19:0]=0x%0x", inst_suffix, cq_num, ldb_ims_cfg[cq_num].data[31:12], cq_num, this.ldb_pp_cq_cfg[cq_num].pasid>>22, (this.ldb_pp_cq_cfg[cq_num].pasid & 20'hfffff)), UVM_LOW);
        end else begin
          ldb_ims_cfg[cq_num].data[31:27] = 5'h10;
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__PF_IMS_POLL_MODE:: ldb_ims_cfg[%0d].addr=0x%0x data[31:27]=0x%0x", inst_suffix,cq_num, ldb_ims_cfg[cq_num].addr, ldb_ims_cfg[cq_num].data[31:27]), UVM_MEDIUM);     
        end 
      end 
        //--03192021
        //else begin
        //ldb_pp_cq_cfg[cq_num].cq_isr.vf          = '0;
        //ldb_pp_cq_cfg[cq_num].cq_isr.vector      = '0;
      //end 
      ldb_pp_cq_cfg[cq_num].cq_isr.vf            = ldb_ims_cfg[cq_num].ims_idx[7:6];
      ldb_pp_cq_cfg[cq_num].cq_isr.vector        = ldb_ims_cfg[cq_num].ims_idx[5:0];
      ims_index                                  = ldb_ims_cfg[cq_num].ims_idx;

      ims_prog_cfg[ims_index].enable = 1;
      ims_prog_cfg[ims_index].is_ldb = 1;
      ims_prog_cfg[ims_index].cq     = cq_num;
      ims_prog_cfg[ims_index].addr   = ldb_ims_cfg[cq_num].addr;
      ims_prog_cfg[ims_index].data   = ldb_ims_cfg[cq_num].data;
      ims_prog_cfg[ims_index].ctrl   = ldb_ims_cfg[cq_num].ctrl;


      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", cq_num, "en_code", this.ldb_pp_cq_cfg[cq_num].cq_isr.en_code);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", cq_num, "vf", this.ldb_pp_cq_cfg[cq_num].cq_isr.vf);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", cq_num, "vector", this.ldb_pp_cq_cfg[cq_num].cq_isr.vector);

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ai_addr_l", ims_index, "ims_addr_l", ldb_ims_cfg[cq_num].addr[31:2]);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ai_addr_u", ims_index, "ims_addr_u", ldb_ims_cfg[cq_num].addr[63:32]);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ai_data", ims_index, "ims_data", ldb_ims_cfg[cq_num].data);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ai_ctrl", ims_index, "ims_mask", ldb_ims_cfg[cq_num].ctrl[0]);
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS:: ldb_ims_cfg[%0d].en_code=%0d ims_idx=%0d; ai_ctrl=0x%0x ai_addr=0x%0x ai_data=0x%0x", inst_suffix,cq_num, ldb_pp_cq_cfg[cq_num].cq_isr.en_code, ldb_ims_cfg[cq_num].ims_idx, ldb_ims_cfg[cq_num].ctrl, ldb_ims_cfg[cq_num].addr, ldb_ims_cfg[cq_num].data), UVM_MEDIUM);     
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS_PROG:: ims_prog_cfg[%0d].is_ldb=1 cq=%0d addr=0x%0x data=0x%0x", inst_suffix, ims_index, cq_num, ims_prog_cfg[ims_index].addr, ims_prog_cfg[ims_index].data), UVM_MEDIUM);     
    end 

    set_cfg_val(set_cfg_val_op, "hqm_system_csr", "msix_mode", "ims_polling", ims_poll_mode);

    ims_command_handler = HQM_CFG_CMD_DONE;
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::vas_command_handler(hqm_cfg_command command);
    int vas;
    int qid;
    bit [63:0] addr64;
    int idx;
    hqm_cfg_command_options option;

    vas_command_handler = HQM_CFG_CMD_NOT_DONE;

    if (command.get_type() != HQM_CFG_VAS) begin
      return(vas_command_handler);
    end 

    vas = resolve_value(command,hqm_pkg::NUM_VAS,hqm_pkg::NUM_VAS,avail_vas,avail_vas,prov_vas,prov_vas);       // should be NUM_VAS, error in hqm_pkg.sv

    if (vas < 0) return(vas_command_handler);

    vas_cfg[vas].provisioned = 1'b1;
    vas_cfg[vas].enable = 1'b1;

    for(int i=0;i<command.options.size;i++) begin
      idx = $urandom_range(0, command.options[i].values.size()-1);
      case (command.options[i].option.tolower())
        "enable"                        : vas_cfg[vas].enable                   = command.options[i].values[idx]; 
        "credit_cnt"                    : vas_cfg[vas].credit_cnt               = command.options[i].values[idx]; 
         default: begin
           bit match = 1'b0;

           if ($sscanf(command.options[i].option.tolower(),"ldb_qidv%d",qid) > 0) begin
             if ((qid >= 0) && (qid < hqm_pkg::NUM_LDB_QID)) begin
               if(vas_pcq_ctrl==1) begin
                  vas_cfg[0].ldb_qid_v[qid] = command.options[i].values[idx];
               end else if(vas_pcq_ctrl==2) begin
                  vas_cfg[vas%2].ldb_qid_v[qid] = command.options[i].values[idx];
               end else begin
                  vas_cfg[vas].ldb_qid_v[qid] = command.options[i].values[idx];
               end 
               match = 1'b1;
             end 
           end else if ($sscanf(command.options[i].option.tolower(),"dir_qidv%d",qid) > 0) begin
             if ((qid >= 0) && (qid < hqm_pkg::NUM_DIR_QID)) begin
               vas_cfg[vas].dir_qid_v[qid] = command.options[i].values[idx];
               match = 1'b1;
             end 
           end 

           if (~match) begin
             uvm_report_error("VAS CFG", $psprintf("HQM%0s__Undefined option %s", inst_suffix,command.options[i].option));
           end 
         end 
      endcase
    end 

    set_cfg_val_index(set_cfg_val_op, "credit_hist_pipe", "cfg_vas_credit_count", vas, "count", this.vas_cfg[vas].credit_cnt);

    i_hqm_pp_cq_status.set_vas_credits(vas,this.vas_cfg[vas].credit_cnt);

    for (qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
       if(vas_pcq_ctrl==1) begin
          set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_vasqid_v", (vas * hqm_pkg::NUM_LDB_QID) + qid, "vasqid_v", this.vas_cfg[0].ldb_qid_v[qid]);
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__VAS:vas_cfg[%0d].ldb_qid_v[%0d]=0x%0x (vas_pcq_ctrl=1 => force to use VAS[0] only)", inst_suffix,vas, qid, this.vas_cfg[0].ldb_qid_v[qid]), UVM_LOW);     
       end else if(vas_pcq_ctrl==2) begin
          set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_vasqid_v", (vas * hqm_pkg::NUM_LDB_QID) + qid, "vasqid_v", this.vas_cfg[vas%2].ldb_qid_v[qid]);
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__VAS:vas_cfg[%0d].ldb_qid_v[%0d]=0x%0x (vas_pcq_ctrl=2 => force to use even VAS only)", inst_suffix,vas, qid, this.vas_cfg[vas%2].ldb_qid_v[qid]), UVM_LOW);     
       end else begin
          set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_vasqid_v", (vas * hqm_pkg::NUM_LDB_QID) + qid, "vasqid_v", this.vas_cfg[vas].ldb_qid_v[qid]);
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__VAS:vas_cfg[%0d].ldb_qid_v[%0d]=0x%0x", inst_suffix,vas, qid, this.vas_cfg[vas].ldb_qid_v[qid]), UVM_LOW);     
       end 
    end 

    for (qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_vasqid_v", (vas * hqm_pkg::NUM_DIR_QID) + qid, "vasqid_v", this.vas_cfg[vas].dir_qid_v[qid]);
       uvm_report_info("HQM_CFG", $psprintf("HQM%0s__VAS:vas_cfg[%0d].dir_qid_v[%0d]=0x%0x", inst_suffix,vas, qid, this.vas_cfg[vas].dir_qid_v[qid]), UVM_LOW);     
    end 

    vas_command_handler = HQM_CFG_CMD_DONE;
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit hqm_cfg::option_dec_index(string opt_in, string opt_prefix, string opt_suffix, output int opt_val);
  int opt_index;

  option_dec_index = 1'b0;
  opt_val = -1;

  if ($sscanf(opt_in.tolower(),{opt_prefix,"%d"},opt_index) > 0) begin
    if (opt_in.tolower() == {opt_prefix.tolower(),$psprintf("%0d",opt_index),opt_suffix.tolower()}) begin
      opt_val = opt_index;
      option_dec_index = 1'b1;
    end 
  end 
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::vf_command_handler(hqm_cfg_command command);
    int vf;
    int vpp;
    int pp;
    int cq;
    int vcq;
    int vqid;
    int qid;
    int msi;
    int idx;
    hqm_cfg_command_options option;

    vf_command_handler = HQM_CFG_CMD_NOT_DONE;

    if (command.get_type() != HQM_CFG_VF) begin
      return(vf_command_handler);
    end 

    vf = resolve_value(command,hqm_pkg::NUM_VF,hqm_pkg::NUM_VF,avail_vf,avail_vf,prov_vf,prov_vf);

    if (vf < 0) return(vf_command_handler);

    vf_cfg[vf].provisioned = 1'b1;
    vf_cfg[vf].enable = 1'b1;
   `uvm_info("HQM_CFG",$psprintf("HQM%0s__vf_cfg[%0d] enabled",inst_suffix,vf),UVM_MEDIUM)

    if (hqm_iov_mode != HQM_SCIOV_MODE) begin
      hqm_iov_mode = HQM_SRIOV_MODE;
      `uvm_info(get_full_name(), $psprintf("HQM%0s__Entering SRIOV mode",inst_suffix),UVM_LOW)
    end else begin
      `uvm_error(get_full_name(),$psprintf("HQM%0s__Using SC-IOV mode, VF 0x%0x not provisioned", inst_suffix,vf));
      return(vf_command_handler);
    end 

    for(int i=0;i<command.options.size;i++) begin
      idx = $urandom_range(0, command.options[i].values.size()-1);
      case (command.options[i].option.tolower())
        "enable"                      : vf_cfg[vf].enable               = command.options[i].values[idx]; 
        "msi_enable"                  : vf_cfg[vf].msi_enabled          = command.options[i].values[idx]; 
        "msi_multi_msg_en"            : vf_cfg[vf].msi_multi_msg_en     = command.options[i].values[idx]; 
        "msi_addr"                    : vf_cfg[vf].msi_addr             = decode_msi_addr(command.options[i],idx,vf);
        "msi_data"                    : vf_cfg[vf].msi_data             = command.options[i].values[idx]; 
         default: begin
           bit match = 1'b0;

           if (option_dec_index(command.options[i].option, "ldb_vpp", "_pp",vpp) == 1) begin
             if ((vpp >= 0) && (vpp < hqm_pkg::NUM_LDB_PP)) begin
               pp = command.options[i].values[idx];

               if ((pp >= 0) && (pp < hqm_pkg::NUM_LDB_PP)) begin
                 vf_cfg[vf].ldb_vpp_cfg[vpp].provisioned        = 1;
                 vf_cfg[vf].ldb_vpp_cfg[vpp].enable             = 1;
                 vf_cfg[vf].ldb_vpp_cfg[vpp].vpp_v              = 1;
                 vf_cfg[vf].ldb_vpp_cfg[vpp].pp                 = pp;
                 ldb_pp_cq_cfg[pp].is_pf                        = 1'b0;
                 ldb_pp_cq_cfg[pp].vf                           = vf;
                 ldb_pp_cq_cfg[pp].vpp                          = vpp;
                 match = 1'b1;
                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__vf_cfg[%0d].ldb_vpp_cfg[%0d].pp=0x%0x", inst_suffix,vf, vpp, pp),UVM_MEDIUM)
               end 
             end 
           end 
           if (option_dec_index(command.options[i].option, "dir_vpp", "_pp",vpp) == 1) begin
             if ((vpp >= 0) && (vpp < hqm_pkg::NUM_DIR_PP)) begin
               pp = command.options[i].values[idx];

               if ((pp >= 0) && (pp < hqm_pkg::NUM_DIR_PP)) begin
                 vf_cfg[vf].dir_vpp_cfg[vpp].provisioned        = 1;
                 vf_cfg[vf].dir_vpp_cfg[vpp].enable             = 1;
                 vf_cfg[vf].dir_vpp_cfg[vpp].vpp_v              = 1;
                 vf_cfg[vf].dir_vpp_cfg[vpp].pp                 = pp;

                 dir_pp_cq_cfg[pp].is_pf                        = 1'b0;
                 dir_pp_cq_cfg[pp].vf                           = vf;
                 dir_pp_cq_cfg[pp].vpp                          = vpp;

                 if (vf_cfg[vf].dir_vqid_cfg[vpp].provisioned) begin
                   if (vf_cfg[vf].dir_vqid_cfg[vpp].qid != pp) begin
                     `uvm_error(get_full_name(),$psprintf("HQM%0s__VF 0x%0x provisioned DIR VQID 0x%0x physical QID 0x%0x does not equal specified VPP 0x%0x PP 0x%0x - this could cause unexpected errors",
                                                            inst_suffix,
                                                            vf,
                                                            vpp,
                                                            vf_cfg[vf].dir_vqid_cfg[vpp].qid,
                                                            vpp,
                                                            pp))
                   end 
                 end 

                 vf_cfg[vf].dir_vqid_cfg[vpp].provisioned       = 1;
                 vf_cfg[vf].dir_vqid_cfg[vpp].enable            = 1;
                 vf_cfg[vf].dir_vqid_cfg[vpp].vqid_v            = 1;
                 vf_cfg[vf].dir_vqid_cfg[vpp].qid               = pp;
                 dir_qid_cfg[pp].vqid                           = vpp;

                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_VF_vf_cfg[%0d].dir_vqid_cfg[%0d].qid=0x%0x vqid=0x%0x", inst_suffix,vf, vpp, pp, vpp),UVM_MEDIUM)
                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_dir_qid_cfg[%0d].vqid=0x%0x ", inst_suffix, pp, vpp),UVM_MEDIUM)
                 match = 1'b1;
               end 
             end 
           end 
           if (option_dec_index(command.options[i].option, "ldb_vqid", "_qid",vqid) == 1) begin
             if ((vqid >= 0) && (vqid < hqm_pkg::NUM_LDB_QID)) begin
               qid = command.options[i].values[idx];

               if ((qid >= 0) && (qid < hqm_pkg::NUM_LDB_QID)) begin
                 vf_cfg[vf].ldb_vqid_cfg[vqid].provisioned      = 1;
                 vf_cfg[vf].ldb_vqid_cfg[vqid].enable           = 1;
                 vf_cfg[vf].ldb_vqid_cfg[vqid].vqid_v           = 1;
                 vf_cfg[vf].ldb_vqid_cfg[vqid].qid              = qid;
                 ldb_qid_cfg[qid].vqid                          = vqid;
                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_VF_vf_cfg[%0d].ldb_vqid_cfg[%0d].qid=0x%0x vqid=0x%0x", inst_suffix,vf, vqid, qid, vqid),UVM_MEDIUM)
                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_ldb_qid_cfg[%0d].vqid=0x%0x ", inst_suffix, qid, vqid),UVM_MEDIUM)
                 match = 1'b1;
               end 
             end 
           end 
           if (option_dec_index(command.options[i].option, "dir_vqid", "_qid",vqid) == 1) begin
             if ((vqid >= 0) && (vqid < hqm_pkg::NUM_DIR_QID)) begin
               qid = command.options[i].values[idx];

               if ((qid >= 0) && (qid < hqm_pkg::NUM_DIR_QID)) begin
                 if (vf_cfg[vf].dir_vpp_cfg[vqid].provisioned) begin
						

                    if (vf_cfg[vf].dir_vpp_cfg[vqid].pp != qid) begin

                          if($test$plusargs("DISABLE_TXN"))begin
                            `uvm_info("DISABLE_TXN",$psprintf("HQM%0s__VF 0x%0x provisioned DIR VPP 0x%0x physical PP 0x%0x does not equal specified VQID 0x%0x QID 0x%0x - this could cause unexpected errors",
                                                            inst_suffix, 
                                                            vf,
                                                            vqid,
                                                            vf_cfg[vf].dir_vpp_cfg[vqid].pp,
                                                            vqid,
                                                            qid),UVM_LOW)                                                                                                     
                                      end 
                                          else begin
                     `uvm_error(get_full_name(),$psprintf("HQM%0s__VF 0x%0x provisioned DIR VPP 0x%0x physical PP 0x%0x does not equal specified VQID 0x%0x QID 0x%0x - this could cause unexpected errors",
                                                            inst_suffix, 
                                                            vf,
                                                            vqid,
                                                            vf_cfg[vf].dir_vpp_cfg[vqid].pp,
                                                            vqid,
                                                            qid))
                                     end 
					     end 
              

                 end 

                 vf_cfg[vf].dir_vpp_cfg[vqid].provisioned       = 1;
                 vf_cfg[vf].dir_vpp_cfg[vqid].enable            = 1;
                 vf_cfg[vf].dir_vpp_cfg[vqid].vpp_v             = 1;
                 // -- vf_cfg[vf].dir_vpp_cfg[vqid].pp                = qid;

                 dir_pp_cq_cfg[qid].is_pf                       = 1'b0;
                 dir_pp_cq_cfg[qid].vf                          = vf;
                 // -- dir_pp_cq_cfg[qid].vpp                         = vqid;

                 vf_cfg[vf].dir_vqid_cfg[vqid].provisioned      = 1;
                 vf_cfg[vf].dir_vqid_cfg[vqid].enable           = 1;
                 vf_cfg[vf].dir_vqid_cfg[vqid].vqid_v           = 1;
                 vf_cfg[vf].dir_vqid_cfg[vqid].qid              = qid;
                 dir_qid_cfg[qid].vqid                          = vqid;
                 match = 1'b1;
               end 
             end 
           end 

           if (option_dec_index(command.options[i].option, "ldb_vpp", "_v",vpp) == 1) begin
             if ((vpp >= 0) && (vpp < hqm_pkg::NUM_LDB_PP)) begin
               bit vpp_v;

               vpp_v = command.options[i].values[idx];

               vf_cfg[vf].ldb_vpp_cfg[vpp].vpp_v              = vpp_v;
               match = 1'b1;
             end 
           end 
           if (option_dec_index(command.options[i].option, "dir_vpp", "_v",vpp) == 1) begin
             if ((vpp >= 0) && (vpp < hqm_pkg::NUM_DIR_PP)) begin
               bit vpp_v;

               vpp_v = command.options[i].values[idx];

               vf_cfg[vf].dir_vpp_cfg[vpp].vpp_v              = vpp_v;
               match = 1'b1;
             end 
           end 
           if (option_dec_index(command.options[i].option, "ldb_vqid", "_v",vqid) == 1) begin
             if ((vqid >= 0) && (vqid < hqm_pkg::NUM_LDB_QID)) begin
               bit vqid_v;

               vqid_v = command.options[i].values[idx];

               vf_cfg[vf].ldb_vqid_cfg[vqid].vqid_v = vqid_v;
               match = 1'b1;
             end 
           end 
           if (option_dec_index(command.options[i].option, "dir_vqid", "_v",vqid) == 1) begin
             if ((vqid >= 0) && (vqid < hqm_pkg::NUM_DIR_QID)) begin
               bit vqid_v;

               vqid_v = command.options[i].values[idx];

               vf_cfg[vf].dir_vqid_cfg[vqid].vqid_v = vqid_v;
               match = 1'b1;
             end 
           end 

           if (option_dec_index(command.options[i].option, "msi", "_dir_vcq",msi) == 1) begin
             if ((msi >= 0) && (msi < 31)) begin
               vcq = command.options[i].values[idx];

               if ((vcq >= 0) && (vcq < hqm_pkg::NUM_DIR_CQ)) begin
                 vf_cfg[vf].msi_enabled                 = 1;
                 vf_cfg[vf].msi_cfg[msi].enable         = 1;
                 vf_cfg[vf].msi_cfg[msi].is_ldb         = 0;
                 vf_cfg[vf].msi_cfg[msi].cq             = get_pf_pp(.is_vf(1), .vf_num(vf), .is_ldb(0), .vpp(vcq));

                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_vf_cfg[%0d].msi_cfg[%0d].cq=%0d (DIR) ", inst_suffix, vf, msi, vf_cfg[vf].msi_cfg[msi].cq),UVM_MEDIUM)
                 match = 1'b1;
               end 
             end 
           end 

           if (option_dec_index(command.options[i].option, "msi", "_ldb_vcq",msi) == 1) begin
             if ((msi >= 0) && (msi < 31)) begin
               vcq = command.options[i].values[idx];

               if ((vcq >= 0) && (vcq < hqm_pkg::NUM_LDB_CQ)) begin
                 vf_cfg[vf].msi_enabled                 = 1;
                 vf_cfg[vf].msi_cfg[msi].enable         = 1;
                 vf_cfg[vf].msi_cfg[msi].is_ldb         = 1;
                 vf_cfg[vf].msi_cfg[msi].cq             = get_pf_pp(.is_vf(1), .vf_num(vf), .is_ldb(1), .vpp(vcq));

                 match = 1'b1;
                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_vf_cfg[%0d].msi_cfg[%0d].cq=%0d (LDB) ", inst_suffix, vf, msi, vf_cfg[vf].msi_cfg[msi].cq),UVM_MEDIUM)
               end 
             end 
           end 

           if (option_dec_index(command.options[i].option, "msi", "_enable",msi) == 1) begin
             if ((msi >= 0) && (msi < 31)) begin
               vf_cfg[vf].msi_cfg[msi].enable   = command.options[i].values[idx];

               match = 1'b1;
             end 
           end 

           if (~match) begin
             uvm_report_error("VAS CFG", $psprintf("HQM%0s__Undefined option %s", inst_suffix,command.options[i].option));
           end 
         end 
      endcase
    end 
    //----------------------
    for (vpp = 0 ; vpp < hqm_pkg::NUM_LDB_PP ; vpp++) begin
      pp = vf_cfg[vf].ldb_vpp_cfg[vpp].pp;
      `uvm_info("HQM_CFG",$psprintf("HQM%0s__DBG:hqm_system_csr.vf_ldb_vpp_v[%0d].vpp_v=0x%0x (vf=%0d, vpp=%0d, pp=%0d)",inst_suffix, ((vf * hqm_pkg::NUM_LDB_PP) + vpp), this.vf_cfg[vf].ldb_vpp_cfg[vpp].vpp_v, vf, vpp, pp),UVM_MEDIUM)

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_ldb_vpp_v", (vf * hqm_pkg::NUM_LDB_PP) + vpp, "vpp_v", this.vf_cfg[vf].ldb_vpp_cfg[vpp].vpp_v);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_ldb_vpp2pp", (vf * hqm_pkg::NUM_LDB_PP) + vpp, "pp", pp);
      if (this.vf_cfg[vf].ldb_vpp_cfg[vpp].vpp_v) begin
        set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq2vf_pf_ro", pp, "is_pf", this.ldb_pp_cq_cfg[pp].is_pf);
        set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq2vf_pf_ro", pp, "ro", this.ldb_pp_cq_cfg[pp].ro);
        set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq2vf_pf_ro", pp, "vf", this.ldb_pp_cq_cfg[pp].vf);
      end 
    end 

    for (vpp = 0 ; vpp < hqm_pkg::NUM_DIR_PP ; vpp++) begin
      pp = vf_cfg[vf].dir_vpp_cfg[vpp].pp;
      `uvm_info("HQM_CFG",$psprintf("HQM%0s__DBG:hqm_system_csr.vf_dir_vpp_v[%0d].vpp_v=0x%0x (vf=%0d, vpp=%0d, pp=%0d)", inst_suffix,((vf * hqm_pkg::NUM_DIR_PP) + vpp), this.vf_cfg[vf].dir_vpp_cfg[vpp].vpp_v, vf, vpp, pp),UVM_MEDIUM)

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_dir_vpp_v", (vf * hqm_pkg::NUM_DIR_PP) + vpp, "vpp_v", this.vf_cfg[vf].dir_vpp_cfg[vpp].vpp_v);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_dir_vpp2pp", (vf * hqm_pkg::NUM_DIR_PP) + vpp, "pp", pp);
      if (this.vf_cfg[vf].dir_vpp_cfg[vpp].vpp_v) begin
        set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq2vf_pf_ro", pp, "is_pf", this.dir_pp_cq_cfg[pp].is_pf);
        set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq2vf_pf_ro", pp, "ro", this.dir_pp_cq_cfg[pp].ro);
        set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq2vf_pf_ro", pp, "vf", this.dir_pp_cq_cfg[pp].vf);
      end 
    end 

    //----------------------
    for (vqid = 0 ; vqid < hqm_pkg::NUM_LDB_QID ; vqid++) begin
      qid = vf_cfg[vf].ldb_vqid_cfg[vqid].qid;
      `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_hqm_system_csr.vf_ldb_vqid2qid[%0d].qid=%0d (vf=%0d, vqid=%0d, qid=%0d)", inst_suffix, ((vf * hqm_pkg::NUM_LDB_QID) + vqid), qid, vf, vqid, qid),UVM_MEDIUM)

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_ldb_vqid_v", (vf * hqm_pkg::NUM_LDB_QID) + vqid, "vqid_v", this.vf_cfg[vf].ldb_vqid_cfg[vqid].vqid_v);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_ldb_vqid2qid", (vf * hqm_pkg::NUM_LDB_QID) + vqid, "qid", qid);
      if (this.vf_cfg[vf].ldb_vqid_cfg[vqid].vqid_v) begin
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_hqm_system_csr.ldb_qid2vqid[%0d].vqid=%0d (vf=%0d, vqid=%0d, qid=%0d); ldb_qid_cfg[qid=%0d].vqid=%0d", inst_suffix, qid, vqid, vf, vqid, qid, qid, ldb_qid_cfg[qid].vqid),UVM_MEDIUM)
        set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_qid2vqid", qid, "vqid", vqid);
      end 
    end 

    for (vqid = 0 ; vqid < hqm_pkg::NUM_DIR_QID ; vqid++) begin
      qid = vf_cfg[vf].dir_vqid_cfg[vqid].qid;
      `uvm_info("HQM_CFG",$psprintf("HQM%0s__DBG:hqm_system_csr.vf_dir_vqid_v[%0d].vqid_v=0x%0x (vf=%0d, vqid=%0d, qid=%0d)", inst_suffix,((vf * hqm_pkg::NUM_DIR_QID) + vqid), this.vf_cfg[vf].dir_vqid_cfg[vqid].vqid_v, vf, vqid, qid),UVM_MEDIUM)

      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_dir_vqid_v", (vf * hqm_pkg::NUM_DIR_QID) + vqid, "vqid_v", this.vf_cfg[vf].dir_vqid_cfg[vqid].vqid_v);
      set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_dir_vqid2qid", (vf * hqm_pkg::NUM_DIR_QID) + vqid, "qid", qid);
    end 

    if (vf_cfg[vf].msi_enabled) begin
      set_cfg_val(set_cfg_val_op_write, $psprintf("hqm_vf_cfg_i[%0d]",vf), "msi_cap_msg_control", "msi_en", vf_cfg[vf].msi_enabled);
      set_cfg_val(set_cfg_val_op_write, $psprintf("hqm_vf_cfg_i[%0d]",vf), "msi_cap_msg_control", "multi_msg_en", vf_cfg[vf].msi_multi_msg_en);
      set_cfg_val(set_cfg_val_op, $psprintf("hqm_vf_cfg_i[%0d]",vf), "msi_cap_addr_l", "addr", vf_cfg[vf].msi_addr[31:2]);
      set_cfg_val(set_cfg_val_op, $psprintf("hqm_vf_cfg_i[%0d]",vf), "msi_cap_addr_u", "addr", vf_cfg[vf].msi_addr[63:32]);
      set_cfg_val(set_cfg_val_op, $psprintf("hqm_vf_cfg_i[%0d]",vf), "msi_cap_msg_data", "data", vf_cfg[vf].msi_data);
    end 

    for (msi = 0 ; msi < 32 ; msi++) begin
      if (vf_cfg[vf].msi_cfg[msi].enable) begin
        and_cfg_val(set_cfg_val_op, $psprintf("hqm_vf_cfg_i[%0d]",vf), "msi_cap_msg_mask", "msg_mask", ~(1 << msi));
      end 

      if ((msi < 31) && (vf_cfg[vf].msi_cfg[msi].enable)) begin
        if (vf_cfg[vf].msi_cfg[msi].is_ldb) begin
          if ((vf_cfg[vf].msi_cfg[msi].cq >= 0) && (vf_cfg[vf].msi_cfg[msi].cq < hqm_pkg::NUM_LDB_CQ)) begin
            ldb_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.en_code     = 2'b01;
            ldb_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.vf          = vf;
            ldb_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.vector      = msi;

            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", vf_cfg[vf].msi_cfg[msi].cq, "en_code", this.ldb_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.en_code);
            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", vf_cfg[vf].msi_cfg[msi].cq, "vf",      this.ldb_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.vf);
            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq_isr", vf_cfg[vf].msi_cfg[msi].cq, "vector",  this.ldb_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.vector);
          end else begin
            uvm_report_error("MSIX CFG", $psprintf("HQM%0s__Illegal MSI %d LDB CQ %d", inst_suffix,msi, vf_cfg[vf].msi_cfg[msi].cq));
          end 
        end else begin
          if ((vf_cfg[vf].msi_cfg[msi].cq >= 0) && (vf_cfg[vf].msi_cfg[msi].cq < hqm_pkg::NUM_DIR_PP)) begin
            dir_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.en_code     = 2'b01;
            dir_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.vf          = vf;
            dir_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.vector      = msi;

            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", vf_cfg[vf].msi_cfg[msi].cq, "en_code", this.dir_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.en_code);
            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", vf_cfg[vf].msi_cfg[msi].cq, "vf",      this.dir_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.vf);
            set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "dir_cq_isr", vf_cfg[vf].msi_cfg[msi].cq, "vector",  this.dir_pp_cq_cfg[vf_cfg[vf].msi_cfg[msi].cq].cq_isr.vector);
          end else begin
            uvm_report_error("MSIX CFG", $psprintf("HQM%0s__Illegal MSI %d DIR CQ %d", inst_suffix,msi, vf_cfg[vf].msi_cfg[msi].cq));
          end 
        end 
      end 
    end 

    vf_command_handler = HQM_CFG_CMD_DONE;
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::vdev_command_handler(hqm_cfg_command command);
    int vdev;
    int pp;
    int cq;
    int vqid;
    int qid;
    int msi;
    int idx;
    hqm_cfg_command_options option;

    vdev_command_handler = HQM_CFG_CMD_NOT_DONE;

    if (command.get_type() != HQM_CFG_VDEV) begin
      return(vdev_command_handler);
    end 

    vdev = resolve_value(command,hqm_pkg::NUM_VF,hqm_pkg::NUM_VF,avail_vdev,avail_vdev,prov_vdev,prov_vdev);

    if (vdev < 0) return(vdev_command_handler);

    if (hqm_iov_mode != HQM_SRIOV_MODE) begin
      if (hqm_iov_mode != HQM_SCIOV_MODE) begin
        hqm_iov_mode = HQM_SCIOV_MODE;
        set_cfg_val(set_cfg_val_op, "hqm_pf_cfg_i", "pasid_control", "pasid_enable" ,1);
       `uvm_info(get_full_name(), $psprintf("HQM%0s__Entering SCIOV mode",inst_suffix),UVM_LOW)
      end 
    end else begin
      `uvm_error(get_full_name(),$psprintf("HQM%0s__Using SR-IOV mode, VDEV 0x%0x not provisioned", inst_suffix,vdev));
      return(vdev_command_handler);
    end 

    vdev_cfg[vdev].provisioned = 1'b1;
    vdev_cfg[vdev].enable = 1'b1;

    for(int i=0;i<command.options.size;i++) begin
      idx = $urandom_range(0, command.options[i].values.size()-1);
      case (command.options[i].option.tolower())
        "enable"                      : vdev_cfg[vdev].enable               = command.options[i].values[idx]; 
         default: begin
           bit match = 1'b0;

           if (option_dec_index(command.options[i].option, "ldb_pp", "_v",pp) == 1) begin
             if ((pp >= 0) && (pp < hqm_pkg::NUM_LDB_PP)) begin
               bit pp_v;

               pp_v = command.options[i].values[idx];

               if (ldb_pp_cq_cfg[pp].vdev >= 0) begin
                 `uvm_error(get_full_name(),$psprintf("HQM%0s__LDB PP 0x%0x has already been provisioned for VDEV %0d",
                                                      inst_suffix,
                                                      pp,
                                                      ldb_pp_cq_cfg[pp].vdev))
               end else if (ldb_pp_cq_cfg[pp].pp_provisioned == 0) begin
                 `uvm_error(get_full_name(),$psprintf("HQM%0s__LDB PP 0x%0x has not been provisioned, and cannot be assigned to VDEV %0d",
                                                      inst_suffix,
                                                      pp,
                                                      vdev))
               end else begin
                 ldb_pp_cq_cfg[pp].pp_enable                  = pp_v;
                 ldb_pp_cq_cfg[pp].is_pf                      = 1'b1;
                 ldb_pp_cq_cfg[pp].vdev                       = vdev;
                 if (vdev_cfg[vdev].ldb_cq_xlate_qid[pp] < 0) begin
                   vdev_cfg[vdev].ldb_cq_xlate_qid[pp]        = 1;
                   set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq2vf_pf_ro", pp, "is_pf", vdev_cfg[vdev].ldb_cq_xlate_qid[pp] ? 0 : 1);
                 end 
                 match = 1'b1;
                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_hqm_system_csr.vf_ldb_vpp_v[%0d].vpp_v=0x%0x (hqm_system_csr.hqm_ldb_pp2vdev ldb_pp_cq_cfg[pp=%0d].vdev=%0d)",inst_suffix, ((vdev * hqm_pkg::NUM_LDB_PP) + pp), ldb_pp_cq_cfg[pp].pp_enable, pp, this.ldb_pp_cq_cfg[pp].vdev),UVM_MEDIUM)
                 set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_ldb_vpp_v", (vdev * hqm_pkg::NUM_LDB_PP) + pp, "vpp_v", ldb_pp_cq_cfg[pp].pp_enable);
                 set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_ldb_vpp2pp", (vdev * hqm_pkg::NUM_LDB_PP) + pp, "pp", pp);
                 set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "hqm_ldb_pp2vdev", pp, "vdev", this.ldb_pp_cq_cfg[pp].vdev);
               end 
             end 
           end 
           if (option_dec_index(command.options[i].option, "dir_pp", "_v",pp) == 1) begin
             if ((pp >= 0) && (pp < hqm_pkg::NUM_DIR_PP)) begin
               bit pp_v;

               pp_v = command.options[i].values[idx];

               if (dir_pp_cq_cfg[pp].vdev >= 0) begin
                 `uvm_error(get_full_name(),$psprintf("HQM%0s__DIR PP 0x%0x has already been provisioned for VDEV %0d",
                                                      inst_suffix,
                                                      pp,
                                                      dir_pp_cq_cfg[pp].vdev))
               end else if (dir_pp_cq_cfg[pp].pp_provisioned == 0) begin
                 `uvm_error(get_full_name(),$psprintf("HQM%0s__DIR PP 0x%0x has not been provisioned, and cannot be assigned to VDEV %0d",
                                                      inst_suffix,
                                                      pp,
                                                      vdev))
               end else begin
                 dir_pp_cq_cfg[pp].pp_enable                  = pp_v;
                 dir_pp_cq_cfg[pp].is_pf                      = 1'b1;
                 dir_pp_cq_cfg[pp].vdev                       = vdev;
                 match = 1'b1;
                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_hqm_system_csr.vf_dir_vpp_v[%0d].vpp_v=0x%0x (hqm_system_csr.hqm_dir_pp2vdev dir_pp_cq_cfg[pp=%0d].vdev=%0d)",inst_suffix, ((vdev * hqm_pkg::NUM_DIR_PP) + pp), dir_pp_cq_cfg[pp].pp_enable, pp, this.dir_pp_cq_cfg[pp].vdev),UVM_MEDIUM)
                 set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_dir_vpp_v", (vdev * hqm_pkg::NUM_DIR_PP) + pp, "vpp_v", dir_pp_cq_cfg[pp].pp_enable);
                 set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_dir_vpp2pp", (vdev * hqm_pkg::NUM_DIR_PP) + pp, "pp", pp);
                 set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "hqm_dir_pp2vdev", pp, "vdev", dir_pp_cq_cfg[pp].vdev);
               end 
             end 
           end 
           if (option_dec_index(command.options[i].option, "ldb_xlate_qid_cq", "",pp) == 1) begin
             if ((pp >= 0) && (pp < hqm_pkg::NUM_LDB_PP)) begin
               bit xlate_en;

               xlate_en = command.options[i].values[idx];

               if ((pp >= 0) && (pp < hqm_pkg::NUM_LDB_PP)) begin
                 if (ldb_pp_cq_cfg[pp].vdev < 0) begin
                   `uvm_error(get_full_name(),$psprintf("HQM%0s__LDB PP 0x%0x has not been provisioned for VDEV %0d",
                                                        inst_suffix,
                                                        pp,
                                                        ldb_pp_cq_cfg[pp].vdev))
                 end else if (ldb_pp_cq_cfg[pp].pp_provisioned == 0) begin
                   `uvm_error(get_full_name(),$psprintf("HQM%0s__LDB PP 0x%0x has not been provisioned, cannot set ldb_xlate_qid_cq for VDEV %0d",
                                                        inst_suffix,
                                                        pp,
                                                        vdev))
                 end else begin
                   vdev_cfg[vdev].ldb_cq_xlate_qid[pp]        = xlate_en;
                   match = 1'b1;
                   set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_cq2vf_pf_ro", pp, "is_pf", vdev_cfg[vdev].ldb_cq_xlate_qid[pp] ? 0 : 1);
                 end 
               end 
             end 
           end 
           if (option_dec_index(command.options[i].option, "ldb_vqid", "_qid",vqid) == 1) begin
             if ((vqid >= 0) && (vqid < hqm_pkg::NUM_LDB_QID)) begin
               qid = command.options[i].values[idx];

               if ((qid >= 0) && (qid < hqm_pkg::NUM_LDB_QID)) begin
                 vdev_cfg[vdev].ldb_vqid_cfg[vqid].provisioned      = 1;
                 vdev_cfg[vdev].ldb_vqid_cfg[vqid].enable           = 1;
                 vdev_cfg[vdev].ldb_vqid_cfg[vqid].vqid_v           = 1;
                 vdev_cfg[vdev].ldb_vqid_cfg[vqid].qid              = qid;
                 ldb_qid_cfg[qid].vqid                              = vqid;
                 match = 1'b1;
                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_hqm_system_csr.vf_ldb_vqid_v[%0d].vqid_v=0x%0x (qid=%0d, vqid=%0d, vdev=%0d) (vdev_cfg[%0d].ldb_vqid_cfg[%0d].qid=%0d)", inst_suffix, ((vdev * hqm_pkg::NUM_LDB_QID) + vqid), this.vdev_cfg[vdev].ldb_vqid_cfg[vqid].vqid_v, qid, vqid, vdev, vdev, vqid, qid), UVM_MEDIUM)
                 set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_ldb_vqid_v", (vdev * hqm_pkg::NUM_LDB_QID) + vqid, "vqid_v", this.vdev_cfg[vdev].ldb_vqid_cfg[vqid].vqid_v);
                 set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_ldb_vqid2qid", (vdev * hqm_pkg::NUM_LDB_QID) + vqid, "qid", qid);
                 set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "ldb_qid2vqid", qid, "vqid", vqid);
                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_hqm_system_csr.ldb_qid2vqid[%0d].vqid=%0d (vdev=%0d, vqid=%0d, qid=%0d); ldb_qid_cfg[qid=%0d].vqid=%0d", inst_suffix, qid, vqid, vdev, vqid, qid, qid, ldb_qid_cfg[qid].vqid),UVM_MEDIUM)
               end 
             end 
           end 
           if (option_dec_index(command.options[i].option, "dir_vqid", "_qid",vqid) == 1) begin
             if ((vqid >= 0) && (vqid < hqm_pkg::NUM_DIR_QID)) begin
               qid = command.options[i].values[idx];

               if ((qid >= 0) && (qid < hqm_pkg::NUM_DIR_QID)) begin
                 vdev_cfg[vdev].dir_vqid_cfg[vqid].provisioned      = 1;
                 vdev_cfg[vdev].dir_vqid_cfg[vqid].enable           = 1;
                 vdev_cfg[vdev].dir_vqid_cfg[vqid].vqid_v           = 1;
                 vdev_cfg[vdev].dir_vqid_cfg[vqid].qid              = qid;
                 dir_qid_cfg[qid].vqid                              = vqid;
                 match = 1'b1;
                 `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_hqm_system_csr.vf_dir_vqid_v[%0d].vqid_v=0x%0x (qid=%0d, vqid=%0d, vdev=%0d) (vdev_cfg[%0d].dir_vqid_cfg[%0d].qid=%0d) (dir_vqid<n>_qid programming)", inst_suffix, ((vdev * hqm_pkg::NUM_DIR_QID) + vqid), this.vdev_cfg[vdev].dir_vqid_cfg[vqid].vqid_v, qid, vqid, vdev, vdev, vqid, qid), UVM_MEDIUM)
                 set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_dir_vqid_v", (vdev * hqm_pkg::NUM_DIR_QID) + vqid, "vqid_v", this.vdev_cfg[vdev].dir_vqid_cfg[vqid].vqid_v);
                 set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_dir_vqid2qid", (vdev * hqm_pkg::NUM_DIR_QID) + vqid, "qid", qid);
               end 
             end 
           end 
           if (option_dec_index(command.options[i].option, "ldb_vqid", "_v",vqid) == 1) begin
             if ((vqid >= 0) && (vqid < hqm_pkg::NUM_LDB_QID)) begin
               bit vqid_v;

               vqid_v = command.options[i].values[idx];

               vdev_cfg[vdev].ldb_vqid_cfg[vqid].vqid_v = vqid_v;
               set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_ldb_vqid_v", (vdev * hqm_pkg::NUM_LDB_QID) + vqid, "vqid_v", this.vdev_cfg[vdev].ldb_vqid_cfg[vqid].vqid_v);
               match = 1'b1;
             end 
           end 
           if (option_dec_index(command.options[i].option, "dir_vqid", "_v",vqid) == 1) begin
             if ((vqid >= 0) && (vqid < hqm_pkg::NUM_DIR_QID)) begin
               bit vqid_v;

               vqid_v = command.options[i].values[idx];

               vdev_cfg[vdev].dir_vqid_cfg[vqid].vqid_v = vqid_v;
               match = 1'b1;
               set_cfg_val_index(set_cfg_val_op, "hqm_system_csr", "vf_dir_vqid_v", (vdev * hqm_pkg::NUM_DIR_QID) + vqid, "vqid_v", this.vdev_cfg[vdev].dir_vqid_cfg[vqid].vqid_v);
             end 
           end 

           if (~match) begin
             uvm_report_error("VAS CFG", $psprintf("HQM%0s__Undefined option %s", inst_suffix,command.options[i].option));
           end 
         end 
      endcase
    end 

    vdev_command_handler = HQM_CFG_CMD_DONE;
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::reg_command_handler(hqm_cfg_command command);
    string              token;
    string              register;
    longint             offset;
    int                 offset_present;
    uvm_reg_data_t      exp_rd_val;
    uvm_reg_data_t      exp_rd_mask;
    int                 poll_delay;
    int                 poll_timeout;
    string              explode_q[$];

    reg_command_handler = HQM_CFG_CMD_NOT_DONE;
   
    if ((command.get_type() != HQM_CFG_WR_REG) &&
        (command.get_type() != HQM_CFG_BWR_REG) &&
        (command.get_type() != HQM_CFG_CWR_REG) &&
        (command.get_type() != HQM_CFG_WRE_REG) &&
        (command.get_type() != HQM_CFG_OWR_REG) &&
        (command.get_type() != HQM_CFG_OWRE_REG) &&
        (command.get_type() != HQM_CFG_RD_REG) &&
        (command.get_type() != HQM_CFG_BRD_REG) &&
        (command.get_type() != HQM_CFG_RDE_REG) &&
        (command.get_type() != HQM_CFG_ORD_REG) &&
        (command.get_type() != HQM_CFG_ORDE_REG) &&
        (command.get_type() != HQM_CFG_POLL_REG)) begin
          return(reg_command_handler);
    end 

    register   = command.get_target();
    lvm_common_pkg::explode(".",register,explode_q,3);

    if (explode_q.size() == 3) begin
      command_reg_file_name  = explode_q[0];
      command_reg_reg_name   = explode_q[1];
      command_reg_field_name = explode_q[2];
    end else if (explode_q.size() == 2) begin
      command_reg_file_name  = explode_q[0];
      command_reg_reg_name   = explode_q[1];
      command_reg_field_name = "";
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__Incomplete register specification - %s",inst_suffix,register))
      return(reg_command_handler);
    end 

    offset            = 0;
    offset_present    = 0;

    if ((command.get_type() == HQM_CFG_OWR_REG) ||
        (command.get_type() == HQM_CFG_OWRE_REG) ||
        (command.get_type() == HQM_CFG_ORD_REG) ||
        (command.get_type() == HQM_CFG_ORDE_REG)) begin
      if (command.options.size() > 0) begin
        offset            = command.options[0].values[0];
        offset_present    = 1;
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__Offset Read or Write (%s) requires an offset value",inst_suffix,register))
      end 
    end 

    if ((command.get_type() == HQM_CFG_WR_REG) || (command.get_type() == HQM_CFG_CWR_REG)) begin
      if (command.options.size() > 0) begin
        if (command_reg_field_name != "") begin
          set_cfg_val((command.get_type() == HQM_CFG_CWR_REG) ? HQM_CFG_CWRITE : HQM_CFG_WRITE,
                      command_reg_file_name,
                      command_reg_reg_name,
                      command_reg_field_name,
                      command.options[0].values[0]);
        end else begin
          set_reg_cfg_val((command.get_type() == HQM_CFG_CWR_REG) ? HQM_CFG_CWRITE : HQM_CFG_WRITE,
                          command_reg_file_name,
                          command_reg_reg_name,
                          command.options[0].values[0]);
        end 
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__Write (%s) requires a write data value",inst_suffix,register))
        return(reg_command_handler);
      end 

      reg_command_handler = HQM_CFG_CMD_DONE;
    end else if (command.get_type() == HQM_CFG_BWR_REG) begin
      if (command.options.size() > 0) begin
        if (command_reg_field_name != "") begin
          set_cfg_val(HQM_CFG_BWRITE,
                      command_reg_file_name,
                      command_reg_reg_name,
                      command_reg_field_name,
                      command.options[0].values[0]);
        end else begin
          set_reg_cfg_val(HQM_CFG_BWRITE,
                          command_reg_file_name,
                          command_reg_reg_name,
                          command.options[0].values[0]);
        end 
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__Write (%s) requires a write data value",inst_suffix,register))
        return(reg_command_handler);
      end 

      reg_command_handler = HQM_CFG_CMD_DONE;
    end else if ((command.get_type() == HQM_CFG_OWR_REG) || (command.get_type() == HQM_CFG_OWRE_REG)) begin
      if (command.options.size() > 1) begin
        if (command_reg_field_name != "") begin
          `uvm_error("HQM_CFG",$psprintf("HQM%0s__Offset Write (%s) does not support fields",inst_suffix,register))
        end else begin
          add_register_to_access_list( command_reg_file_name,
                                       command_reg_reg_name,
                                       "",
                                       (command.get_type() == HQM_CFG_OWRE_REG) ? HQM_CFG_OWRITE_ERR : HQM_CFG_OWRITE,
                                       .exp_rd_val(command.options[1].values[0]),
                                       .offset(offset),
                                       .sai(cur_sai)
                                     );
        end 
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__Offset Write (%s) requires a write data value",inst_suffix,register))
        return(reg_command_handler);
      end 

      reg_command_handler = HQM_CFG_CMD_DONE;
    end else if (command.get_type() == HQM_CFG_WRE_REG) begin
      if (command.options.size() > 0) begin
        if (command_reg_field_name == "") begin
          uvm_reg   my_reg   = hqm_find_reg_by_file_name(command_reg_reg_name, {tb_env_hier, ".", command_reg_file_name});
          if (my_reg == null) begin
             uvm_report_error("RAL CFG SET", $psprintf("HQM%0s__Unable to find %s.%s", inst_suffix,command_reg_file_name, command_reg_reg_name));
          end else begin
             uvm_report_info("RAL CFG SET", $psprintf("HQM%0s__Write Error 0x%0h to %s.%s", inst_suffix,command.options[0].values[0], inst_suffix,command_reg_file_name, command_reg_reg_name), UVM_DEBUG);
             this.add_register_to_access_list(command_reg_file_name, command_reg_reg_name, "", HQM_CFG_WRITE_ERR, .exp_rd_val(command.options[0].values[0]), .sai(cur_sai));  
          end 
        end else begin
          `uvm_error("HQM_CFG",$psprintf("HQM%0s__Write Error (%s) not supported with a field specified",inst_suffix,command_reg_reg_name))
          return(reg_command_handler);
        end 
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__Write Error (%s) requires a write data value",inst_suffix,command_reg_reg_name))
        return(reg_command_handler);
      end 

      reg_command_handler = HQM_CFG_CMD_DONE;
    end else begin
      case(command.options.size - offset_present) 
      0 :
          begin
             exp_rd_val         = 0;
             exp_rd_mask        = 0;
             poll_delay         = 1;
             poll_timeout       = 4000;
          end 
      1 :  
        begin
             exp_rd_val         = command.options[offset_present+0].values[0];
             exp_rd_mask        = '1;
             poll_delay         = 1;
             poll_timeout       = 4000;
          end      
      2 :
        begin
             exp_rd_val         = command.options[offset_present+0].values[0];
             exp_rd_mask        = command.options[offset_present+1].values[0];
             poll_delay         = 1;
             poll_timeout       = 4000;
         end      
      3 :
        begin
             exp_rd_val         = command.options[offset_present+0].values[0];
             exp_rd_mask        = command.options[offset_present+1].values[0];
             poll_delay         = command.options[offset_present+2].values[0];
             poll_timeout       = 4000;
         end      
      default :
        begin
             exp_rd_val         = command.options[offset_present+0].values[0];
             exp_rd_mask        = command.options[offset_present+1].values[0];
             poll_delay         = command.options[offset_present+2].values[0];
             poll_timeout       = command.options[offset_present+3].values[0];
         end      
      endcase 

      reg_command_handler = HQM_CFG_CMD_DONE;

      if (command.get_type() == HQM_CFG_BRD_REG) begin
        add_register_to_access_list(command_reg_file_name, command_reg_reg_name, command_reg_field_name, HQM_CFG_BREAD, exp_rd_val, exp_rd_mask, poll_delay, poll_timeout, .sai(cur_sai));  
      end else if (command.get_type() == HQM_CFG_RD_REG) begin
        add_register_to_access_list(command_reg_file_name, command_reg_reg_name, command_reg_field_name, HQM_CFG_READ, exp_rd_val, exp_rd_mask, poll_delay, poll_timeout, .sai(cur_sai));  
      end else if (command.get_type() == HQM_CFG_RDE_REG) begin
        add_register_to_access_list(command_reg_file_name, command_reg_reg_name, command_reg_field_name, HQM_CFG_READ_ERR, exp_rd_val, exp_rd_mask, poll_delay, poll_timeout, .sai(cur_sai));  
      end else if (command.get_type() == HQM_CFG_ORD_REG) begin
        add_register_to_access_list( command_reg_file_name,
                                     command_reg_reg_name,
                                     "",
                                     HQM_CFG_OREAD,
                                     exp_rd_val,
                                     exp_rd_mask,
                                     .offset(offset),
                                     .sai(cur_sai)
                                   );
      end else if (command.get_type() == HQM_CFG_ORDE_REG) begin
        add_register_to_access_list( command_reg_file_name,
                                     command_reg_reg_name,
                                     "",
                                     HQM_CFG_OREAD_ERR,
                                     exp_rd_val,
                                     exp_rd_mask,
                                     .offset(offset),
                                     .sai(cur_sai)
                                   );
      end else begin
        add_register_to_access_list(command_reg_file_name, command_reg_reg_name, command_reg_field_name, HQM_CFG_POLL, exp_rd_val, exp_rd_mask, poll_delay, poll_timeout, .sai(cur_sai));  
      end 
    end 
    //TO DO add generic read sequence
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::util_command_handler(hqm_cfg_command command);
    bit [63:0]              mem_size;
    bit [63:0]              mem_mask;
    bit [63:0]              gpa;

    util_command_handler = HQM_CFG_CMD_DONE;

    if (command.get_type() == HQM_CFG_IDLE_REG)  begin
      if (command.options.size() > 0) begin
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__Adding IDLE %d ns command to list",inst_suffix,command.options[0].values[0]),UVM_MEDIUM)

        add_register_to_access_list("idle", "idle", "idle", HQM_CFG_IDLE, 0, 0, command.options[0].values[0], .sai(cur_sai));  
      end 
    end else if (command.get_type() == HQM_MSIX_ALARM_WAIT)  begin
      if (command.options.size() > 0) begin
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__Adding MSIX_ALARM_WAIT (timeout %0d ns) command to list",inst_suffix,command.options[0].values[0]),UVM_MEDIUM)

        add_register_to_access_list("msix_alarm_wait", "msix_alarm_wait", "msix_alarm_wait", HQM_CFG_MSIX_ALARM_WAIT, 0, 0, command.options[0].values[0], .sai(cur_sai));  
      end 
    end else if (command.get_type() == HQM_CFG_POLL_SCH_REG)  begin
        if (command.options.size() > 0) begin

            int port_num;
            int poll_timeout;
            int poll_delay;
            int max_num_ports;

            `uvm_info("HQM_CFG", $psprintf("HQM%0s__Adding POLL_SCH to list",inst_suffix), UVM_MEDIUM)

            poll_delay   = 1;
            poll_timeout = 4000;
            if (command.label=="dir") max_num_ports = hqm_pkg::NUM_DIR_PP;
            else if (command.label=="ldb") max_num_ports = hqm_pkg::NUM_LDB_PP;
                

            port_num = resolve_name(command.label_value_str, command.label_value, max_num_ports);
            case(command.options.size()) 
                2 : begin
                        poll_timeout = command.options[1].values[0];
                    end 
                3 : begin
                        poll_timeout = command.options[1].values[0];
                        poll_delay   = command.options[2].values[0];
                    end 
            endcase
            `uvm_info("HQM_CFG", $psprintf("HQM%0s__Adding POLL_SCH %0s %0d %0d %0d %0d to list", inst_suffix,command.label, port_num, command.options[0].values[0], poll_delay, poll_timeout), UVM_MEDIUM)
            add_register_to_access_list("poll_sch", "poll_sch", command.label, HQM_CFG_POLL_SCH, port_num, command.options[0].values[0], poll_delay, poll_timeout, .sai(cur_sai));
        end 
    end else if (command.get_type() == HQM_REG_RESET)  begin
      bit       do_hqm_cfg_reg_reset;
      bit       do_ral_reg_reset;

      do_hqm_cfg_reg_reset      = 0;
      do_ral_reg_reset          = 0;

      if (command.options.size() > 0) begin
        for (int i=0;i<command.options.size;i++) begin
         `uvm_info("HQM_CFG",$psprintf("HQM%0s__get reg_reset option_%0d - %s", inst_suffix, i, command.options[i].option),UVM_MEDIUM)

          case (command.options[i].option.tolower()) // == "hqm_cfg")
            "hqm_cfg": begin
              do_hqm_cfg_reg_reset = 1;
              `uvm_info("HQM_CFG",$psprintf("HQM%0s__get reg_reset hqm_cfg", inst_suffix),UVM_MEDIUM)
            end 
            "ral": begin
              do_ral_reg_reset = 1;
              `uvm_info("HQM_CFG",$psprintf("HQM%0s__get reg_reset ral", inst_suffix),UVM_MEDIUM)
            end 
            default: begin
              `uvm_error("HQM_CFG",$psprintf("HQM%0s__REG_RESET command illegal option - %s",inst_suffix,command.options[i].option))
            end 
          endcase
        end 
      end else begin
        do_hqm_cfg_reg_reset = 1;
        do_ral_reg_reset = 1;
      end 

      if (do_hqm_cfg_reg_reset) begin
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__Calling hqm_cfg.reset_hqm_cfg", inst_suffix),UVM_MEDIUM)
        reset_hqm_cfg();
      end 

      if (do_ral_reg_reset) begin
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__Calling ral.reset",inst_suffix),UVM_MEDIUM)
        ral.reset();
      end 
    end else if (command.get_type() == HQM_CFG_ACCESS_PATH)  begin
      if (command.options.size() > 0) begin
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__Setting RAL access path - %s",inst_suffix,command.options[0].option),UVM_LOW)

        case (command.options[0].option.tolower())
          "primary":  set_ral_access_path("iosf_pri");
          "sideband": set_ral_access_path("iosf_sb");
          default:    begin
            `uvm_error("HQM_CFG",$psprintf("HQM%0s__Setting RAL access path : invalid path specified - %s",inst_suffix,command.options[0].option))
          end 
        endcase
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__Setting RAL access path - no option specified",inst_suffix))
      end 
    end else if (command.get_type() == HQM_CFG_PUSH_ACCESS_PATH)  begin
      if (command.options.size() > 0) begin
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__Pushing RAL access path - %s (was %s)",inst_suffix,command.options[0].option, ral_access_path),UVM_LOW)

        case (command.options[0].option.tolower())
          "primary":
            begin
              ral_access_path_q.push_back(ral_access_path);
              set_ral_access_path("iosf_pri");
            end 
          "sideband":
            begin
              ral_access_path_q.push_back(ral_access_path);
              set_ral_access_path("iosf_sb");
            end 
          default:    begin
            `uvm_error("HQM_CFG",$psprintf("HQM%0s__Pushing RAL access path : invalid path specified - %s",inst_suffix,command.options[0].option))
          end 
        endcase
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__Pushing RAL access path - no option specified",inst_suffix))
      end 
    end else if (command.get_type() == HQM_CFG_POP_ACCESS_PATH)  begin
      if (ral_access_path_q.size() > 0) begin
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__Popping RAL access path %s (was %s)",inst_suffix,ral_access_path_q[0], ral_access_path),UVM_LOW)
        set_ral_access_path(ral_access_path_q.pop_front());
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__Popping RAL access path - queue empty, using current value - %s",inst_suffix,ral_access_path))
      end 
    end else if (command.get_type() == HQM_CFG_FUNC_PF_REG)  begin
      if (command.options.size() > 0) begin
        if (command.options[0].option.tolower() == "gpa") begin
          mem_size = 64'h0000_0000_0400_0000;
          mem_mask = mem_size - 1;
          gpa = decode_gpa(command.options[0],-1,$psprintf("HQM%s_FUNC_PF_MEM",inst_suffix),mem_size,mem_mask,"s0_mmioh");

          set_cfg_val(set_cfg_val_op, "hqm_pf_cfg_i", "func_bar_u", "addr" ,   gpa[63:32]);
          set_cfg_val(set_cfg_val_op, "hqm_pf_cfg_i", "func_bar_l", "addr_l" , gpa[31:26]);

          `uvm_info("HQM_CFG",$psprintf("HQM%0s__Setting FUNC_PF_BAR to 0x%016x",inst_suffix,gpa),UVM_MEDIUM)
        end else begin
          `uvm_error("HQM_CFG",$psprintf("HQM%0s__CSR_BAR command illegal option - %s",inst_suffix,command.options[0].option))
        end 
      end 
    end else if (command.get_type() == HQM_CFG_CSR_BAR_REG)  begin
      if (command.options.size() > 0) begin
        if (command.options[0].option.tolower() == "gpa") begin
          mem_size = 64'h0000_0001_0000_0000;
          mem_mask = mem_size - 1;
          gpa = decode_gpa(command.options[0],-1,$psprintf("HQM%s_CSR_BAR_MEM",inst_suffix),mem_size,mem_mask,"s0_mmioh");

          set_cfg_val(set_cfg_val_op, "hqm_pf_cfg_i", "csr_bar_u", "addr" ,   gpa[63:32]);

          `uvm_info("HQM_CFG",$psprintf("HQM%0s__Setting CSR_BAR to 0x%016x",inst_suffix,gpa),UVM_MEDIUM)
        end else begin
          `uvm_error("HQM_CFG",$psprintf("HQM%0s__CSR_BAR command illegal option - %s",inst_suffix,command.options[0].option))
        end 
      end 
    end else if (command.get_type() == HQM_CFG_TEST_DONE_REG)  begin
      if (command.options.size() > 0) begin
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__Adding TEST_DONE %0d ns command to list",inst_suffix,command.options[0].values[0]),UVM_MEDIUM)

        add_register_to_access_list("test_done", "test_done", "test_done", HQM_CFG_TEST_DONE, 0, 0, command.options[0].values[0], .sai(cur_sai));  
      end 
    end else if (command.get_type() == HQM_CFG_BEGIN)  begin
      `uvm_info("HQM_CFG",$psprintf("HQM%0s__Configuration sequence begin",inst_suffix),UVM_LOW)
      set_cfg_begin();
    end else if (command.get_type() == HQM_CFG_END) begin
      `uvm_info("HQM_CFG",$psprintf("HQM%0s__Configuration sequence end ",inst_suffix),UVM_LOW)
      set_cfg_end(command);
    end else if (command.get_type() == HQM_ASSERT) begin
      chandle handle;
      uvm_reg_data_t value;
      int value_int;

      handle = SLA_VPI_get_handle_by_name(command.get_target(),0);

      SLA_VPI_get_value(handle,value);
      value_int=value&32'hffffffff;

      if (value_int == command.options[0].values[0]) begin
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__ASSERT %s 0x%0x check passed",inst_suffix,command.get_target(),command.options[0].values[0]),UVM_NONE)
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__ASSERT %s 0x%0x check failed, value=0x%0x",inst_suffix,command.get_target(),command.options[0].values[0],value_int))
      end 
    end else if (command.get_type() == HQM_FORCE) begin
      chandle handle;

      handle = SLA_VPI_get_handle_by_name(command.get_target(),0);

      SLA_VPI_force_value(handle,command.options[0].values[0]);
    end else if (command.get_type() == HQM_RELEASE) begin
      chandle handle;
      logic [31:0] cvalue = '0;

      handle = SLA_VPI_get_handle_by_name(command.get_target(),0);

      SLA_VPI_release_value(handle,cvalue);
    end else if (command.get_type() == HQM_SAI) begin
      if ((command.options[0].values[0] >= 0) && (command.options[0].values[0] <= 255)) begin
        cur_sai = command.options[0].values[0];
        `uvm_info("HQM_CFG",$psprintf("HQM%0s__Setting Current SAI to 0x%02x",inst_suffix,cur_sai),UVM_LOW)
      end else begin
        `uvm_error("HQM_CFG",$psprintf("HQM%0s__Illegal SAI command",inst_suffix))
      end 
    end else if (command.get_type() == HQM_SYSRST)  begin
        util_command_handler = sysrst_command_handler(command);
    end else if (command.get_type() == HQM_RUNTEST) begin
        util_command_handler = runtest_command_handler(command);
    end else if (command.get_type() == HQM_PAD_FIRST_WRITE_LDB) begin
        if (command.options.size() > 0) begin
            pad_first_write_ldb = command.options[0].values[0];
            set_cfg_val(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_chp_csr_control", "pad_first_write_ldb" , command.options[0].values[0]);
        end else begin
            `uvm_error("HQM_CFG", $psprintf("HQM%0s__No value provided with hqm_pad_first_write_ldb",inst_suffix))
        end 
    end else if (command.get_type() == HQM_PAD_FIRST_WRITE_DIR) begin
        if (command.options.size() > 0) begin
            pad_first_write_dir = command.options[0].values[0];
            set_cfg_val(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_chp_csr_control", "pad_first_write_dir" , command.options[0].values[0]);
        end else begin
            `uvm_error("HQM_CFG", $psprintf("HQM%0s__No value provided with hqm_pad_first_write_dir",inst_suffix))
        end 
    end else if (command.get_type() == HQM_PAD_WRITE_LDB) begin
        if (command.options.size() > 0) begin
            pad_write_ldb = command.options[0].values[0];
            set_cfg_val(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_chp_csr_control", "pad_write_ldb" , command.options[0].values[0]);
        end else begin
            `uvm_error("HQM_CFG", $psprintf("HQM%0s__No value provided with hqm_pad_write_ldb",inst_suffix))
        end 
    end else if (command.get_type() == HQM_PAD_WRITE_DIR) begin
        if (command.options.size() > 0) begin
            pad_write_dir = command.options[0].values[0];
            set_cfg_val(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_chp_csr_control", "pad_write_dir" , command.options[0].values[0]);
        end else begin
            `uvm_error("HQM_CFG", $psprintf("HQM%0s__No value provided with hqm_pad_write_dir",inst_suffix))
        end 
    end else if (command.get_type() == HQM_EARLY_DIR_INT) begin
        if (command.options.size() > 0) begin
            early_dir_int = command.options[0].values[0];
            set_cfg_val(HQM_CFG_CWRITE, "hqm_system_csr", "write_buffer_ctl", "early_dir_int", early_dir_int);
        end else begin
            `uvm_error("HQM_CFG", $psprintf("HQM%0s__No value provided with hqm_early_dir_int",inst_suffix));
        end 
    end else begin
      util_command_handler = HQM_CFG_CMD_NOT_DONE;
    end 
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::command_decode(string commands,bit ignore_unknown = 1'b0);
   hqm_cfg_command command;
   int status;
  
   commands = commands.tolower();
   ltrim_string(commands);
   rtrim_string(commands);

   if (commands.len() == 0) begin
     command_decode = HQM_CFG_CMD_DONE_NO_CFG_SEQ;
     return(command_decode);
   end 

   if (commands[0] == "#") begin
     command_decode = HQM_CFG_CMD_DONE_NO_CFG_SEQ;
     return(command_decode);
   end 

   command_decode = HQM_CFG_CMD_NOT_DONE;

   status = command_parser.get_command(commands, command);
   if(status) begin
     if (status < 50) begin
       uvm_report_info("CFG", $psprintf("HQM%0s__Processing command -> %s", inst_suffix,commands), UVM_LOW);     
       names_command_handler(command);
       command_decode = qid_command_handler(command);  
       if (command_decode == HQM_CFG_CMD_NOT_DONE) command_decode = pp_command_handler(command);
       if (command_decode == HQM_CFG_CMD_NOT_DONE) command_decode = cq_command_handler(command);
       if (command_decode == HQM_CFG_CMD_NOT_DONE) command_decode = vas_command_handler(command);
       if (command_decode == HQM_CFG_CMD_NOT_DONE) command_decode = vf_command_handler(command);
       if (command_decode == HQM_CFG_CMD_NOT_DONE) command_decode = vdev_command_handler(command);
       if (command_decode == HQM_CFG_CMD_NOT_DONE) command_decode = hcw_command_handler(command);
       if (command_decode == HQM_CFG_CMD_NOT_DONE) command_decode = msix_command_handler(command);
       if (command_decode == HQM_CFG_CMD_NOT_DONE) command_decode = ims_command_handler(command);
       if (command_decode == HQM_CFG_CMD_NOT_DONE) command_decode = mem_command_handler(command);
       if (command_decode == HQM_CFG_CMD_NOT_DONE) command_decode = reg_command_handler(command);
       if (command_decode == HQM_CFG_CMD_NOT_DONE) command_decode = util_command_handler(command);
     end   
     else begin
       uvm_report_info("CFG", $psprintf("HQM%0s__Skipping command -> %s", inst_suffix,commands), UVM_LOW);     
       command_decode = HQM_CFG_CMD_DONE_NO_CFG_SEQ;
     end 
   end 

   if (!ignore_unknown && (command_decode == HQM_CFG_CMD_NOT_DONE)) begin
     uvm_report_error("CFG", $psprintf("HQM%0s__Unknown command -> %s", inst_suffix,commands));
   end 

endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function int hqm_cfg::decode_option_value(int prov[$], hqm_cfg_command_options option);
  if ((option.values.size() == 0) && (option.str_value == "") && (option.randmization_type == NONE)) begin
    `uvm_error("HQM_CFG",$psprintf("HQM%0s__Option %s value not set when expected",inst_suffix,option.option))
    decode_option_value = -1;
  end else if (option.str_value != "") begin
    if (names.exists(option.str_value)) begin
      decode_option_value = names[option.str_value];
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__Option %s value string %s not defined",inst_suffix,option.option,option.str_value))
    end 
  end else if (option.randmization_type == WILD_CARD_TYPE) begin
    decode_option_value = prov[$urandom_range(prov.size()-1,0)];
  end else begin
    decode_option_value = option.values[$urandom_range(0, option.values.size()-1)];
  end 
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit [63:0] hqm_cfg::allocate_dram(string mem_name, bit [63:0] mem_size, bit [63:0] mem_mask, bit sriov_en = 1'b0, bit sciov_en = 1'b0, bit [7:0] func_num, int vdev = -1, ref int pasid = -1);
  sla_sm_env               sm;
  sla_sm_ag_status_t       status;
  sla_sm_ag_result         gpa_mem;

  `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

  status = sm.ag.allocate_mem(gpa_mem, "DRAM_HIGH", mem_size, mem_name, mem_mask);

  allocate_dram = gpa_mem.addr;
      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__allocate_dram:: mem_name=%0s mem_size=0x%0x mem_mask=0x%0x; allocate_dram=0x%0x",inst_suffix, mem_name, mem_size, mem_mask, allocate_dram),UVM_LOW)
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit [63:0] hqm_cfg::allocate_msix_addr(string mem_name, int msix);
  sla_sm_env               sm;
  sla_sm_ag_status_t       status;
  sla_sm_ag_result         gpa_mem;

  `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

  status = sm.ag.allocate_mem(gpa_mem, "DRAM_HIGH", 64'h4, mem_name, 64'h3);

  allocate_msix_addr = gpa_mem.addr;
      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__allocate_msix_addr:: mem_name=%0s allocate_msix_addr=0x%0x",inst_suffix, mem_name, allocate_msix_addr),UVM_LOW)
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit [63:0] hqm_cfg::allocate_msi_addr(string mem_name, bit [7:0] func_num);
  sla_sm_env               sm;
  sla_sm_ag_status_t       status;
  sla_sm_ag_result         gpa_mem;

  `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

  status = sm.ag.allocate_mem(gpa_mem, "DRAM_HIGH", 32 * 64'h4, mem_name, (32 * 64'h4) - 1);

  allocate_msi_addr = gpa_mem.addr;
      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__allocate_msi_addr:: mem_name=%0s allocate_msi_addr=0x%0x",inst_suffix, mem_name, allocate_msi_addr),UVM_LOW)
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit [63:0] hqm_cfg::allocate_ims_addr(string mem_name, int vdev = -1);
  sla_sm_env               sm;
  sla_sm_ag_status_t       status;
  sla_sm_ag_result         gpa_mem;

  `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

  status = sm.ag.allocate_mem(gpa_mem, "DRAM_HIGH", 64'h4, mem_name, 64'h3);

  allocate_ims_addr = gpa_mem.addr;
      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__allocate_ims_addr:: mem_name=%0s allocate_ims_addr=0x%0x",inst_suffix, mem_name, allocate_ims_addr),UVM_LOW)
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit [63:0] hqm_cfg::decode_gpa(hqm_cfg_command_options option,int idx,string mem_name, bit [63:0] mem_size, bit [63:0] mem_mask, string mem_region = "DRAM_HIGH");
  if (idx < 0) begin
    if (option.str_value == "sm") begin
      sla_sm_env               sm;
      sla_sm_ag_status_t       status;
      sla_sm_ag_result         gpa_mem;

      `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

      status = sm.ag.allocate_mem(gpa_mem, mem_region, mem_size, mem_name, mem_mask);

      decode_gpa = gpa_mem.addr;
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__Option %s value string %s not a valid setting",inst_suffix,option.option,option.str_value))
    end 
  end else begin
    decode_gpa = option.values[0];
  end 
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit [63:0] hqm_cfg::decode_msix_addr(hqm_cfg_command_options option,int idx, int msix, bit is_ldb, int cq);
  if (idx < 0 || $test$plusargs("HQM_PP_CQ_READ_MSIX_ADDR")) begin
    if (option.str_value == "sm" || $test$plusargs("HQM_PP_CQ_READ_MSIX_ADDR")) begin
      sla_sm_env               sm;
      sla_sm_ag_status_t       status;
      sla_sm_ag_result         gpa_mem;

      `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX%0d: call allocate_msix_addr for is_ldb %0d cq %0d", inst_suffix, msix, is_ldb, cq), UVM_LOW);     
      decode_msix_addr = allocate_msix_addr($psprintf("HQM%s_MSIX%d_ADDR",inst_suffix,msix), msix);
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__Option %s value string %s not a valid setting",inst_suffix,option.option,option.str_value))
    end 
  end else begin
    decode_msix_addr = option.values[0] & 64'hffffffff_fffffffc;
  end 
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit [63:0] hqm_cfg::decode_msi_addr(hqm_cfg_command_options option,int idx, int vf);
  if (idx < 0) begin
    if (option.str_value == "sm") begin
      sla_sm_env               sm;
      sla_sm_ag_status_t       status;
      sla_sm_ag_result         gpa_mem;

      `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

      decode_msi_addr = allocate_msi_addr($psprintf("HQM%s_VF%d_MSI_ADDR",inst_suffix,vf), vf + 1);
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__Option %s value string %s not a valid setting",inst_suffix,option.option,option.str_value))
    end 
  end else begin
    decode_msi_addr = option.values[0];
  end 
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit [63:0] hqm_cfg::decode_ims_addr(hqm_cfg_command_options option,int idx, bit is_ldb, int cq_num);
  if (idx < 0) begin
    if (option.str_value == "sm") begin
      sla_sm_env               sm;
      sla_sm_ag_status_t       status;
      sla_sm_ag_result         gpa_mem;
      int                      pasid;

      `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

      pasid = get_pasid(is_ldb,cq_num);

      if (ims_poll_mode) begin
        decode_ims_addr = allocate_dram($psprintf("HQM%s_%s_CQ%0d_IMS_ADDR",inst_suffix,is_ldb ? "LDB" : "DIR",cq_num),
                                        64,
                                        'h3f,
                                        (hqm_iov_mode == HQM_SRIOV_MODE) ? 1'b1 : 1'b0,
                                        (hqm_iov_mode == HQM_SCIOV_MODE) ? 1'b1 : 1'b0,
                                        is_ldb ? (ldb_pp_cq_cfg[cq_num].is_pf ? 0 : (ldb_pp_cq_cfg[cq_num].vf + 1)) : (dir_pp_cq_cfg[cq_num].is_pf ? 0 : (dir_pp_cq_cfg[cq_num].vf + 1)),
                                        get_vdev(is_ldb,cq_num),
                                        pasid
                                       );

        if (pasid != get_pasid(is_ldb,cq_num)) begin
          if (is_ldb) begin
            ldb_pp_cq_cfg[cq_num].pasid = pasid;
          end else begin
            dir_pp_cq_cfg[cq_num].pasid = pasid;
          end 
        end 
      end else begin
        decode_ims_addr = allocate_ims_addr($psprintf("HQM%s_%s_CQ%0d_IMS_ADDR",inst_suffix,is_ldb ? "LDB" : "DIR",cq_num),get_vdev(is_ldb,cq_num));
      end 
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__Option %s value string %s not a valid setting",inst_suffix,option.option,option.str_value))
    end 
  end else begin
    decode_ims_addr = option.values[0];
  end 
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit [63:0] hqm_cfg::decode_cq_gpa(hqm_cfg_command_options option,int idx,string mem_name, bit [63:0] mem_size, bit [63:0] mem_mask, bit is_ldb, int cq);
  if (idx < 0) begin
    if (option.str_value == "sm") begin
      sla_sm_env               sm;
      sla_sm_ag_status_t       status;
      sla_sm_ag_result         gpa_mem;
      int                      pasid;
      HqmPasid_t               page_pasidtlp;
      HqmAtsPkg::PageSize_t    page_size;
      bit [63:0]               page_logical_addr;     //--virtual address
      bit [63:0]               page_translation_addr; //--physical address
      logic                    page_untranslated_access_only=0;
      logic                    page_privileged_mode_access=0;
      logic                    page_execute_permitted=0;
      logic                    page_global_mapping=0;
      logic                    page_non_snooped_access=1;
      logic                    page_write_permission=1;
      logic                    page_read_permission=1;
      logic                    page_overwrite_en=0;
      logic                    page_check_en=1;
      int                      ret_code;


      `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

      pasid = get_pasid(is_ldb,cq);

      //--HQMV30_ATS to allocate a page physical address, address has to be aligned to 4K, 2M, 1G (no 1G case)
      if(ats_enabled==1) begin
         if(is_ldb) begin
             `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_gpa_S0:: is_ldb=%0d cq=%0d ldb_cq_single_hcw_per_cl=%0d ldb_pp_cq_cfg[%0d].cq_depth=%0d; mem_name=%0s mem_size=0x%0x mem_mask=0x%0x", inst_suffix, is_ldb, cq, ldb_cq_single_hcw_per_cl, cq, ldb_pp_cq_cfg[cq].cq_depth, mem_name, mem_size, mem_mask),UVM_MEDIUM)
         end else begin
             `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_gpa_S0:: is_ldb=%0d cq=%0d dir_cq_single_hcw_per_cl=%0d dir_pp_cq_cfg[%0d].cq_depth=%0d; mem_name=%0s mem_size=0x%0x mem_mask=0x%0x", inst_suffix, is_ldb, cq, dir_cq_single_hcw_per_cl, cq, dir_pp_cq_cfg[cq].cq_depth, mem_name, mem_size, mem_mask),UVM_MEDIUM)
         end 

         if($test$plusargs("ATS_4KPAGE_ONLY")) begin
            if(mem_size>'h1000) begin
              `uvm_fatal(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_gpa_S1:: is_ldb=%0d cq=%0d; mem_name=%0s mem_size=0x%0x NOT 4KPAGE when +ATS_4KPAGE_ONLY ",inst_suffix, is_ldb, cq, mem_name, mem_size))
            end 
            mem_mask='hfff;     //--4K page
         end else begin
            if(mem_size > 'h1000 || has_pagesize_2M==1) mem_mask='h1f_ffff; //--2M page
            else                                        mem_mask='hfff;     //--4K page
         end 
      end 
 
      //--allocate physical address
      decode_cq_gpa = allocate_dram(mem_name, 
                                     mem_size,
                                     mem_mask,
                                     (hqm_iov_mode == HQM_SRIOV_MODE) ? 1'b1 : 1'b0,
                                     (hqm_iov_mode == HQM_SCIOV_MODE) ? 1'b1 : 1'b0,
                                     is_ldb ? (ldb_pp_cq_cfg[cq].is_pf ? 0 : (ldb_pp_cq_cfg[cq].vf + 1)) : (dir_pp_cq_cfg[cq].is_pf ? 0 : (dir_pp_cq_cfg[cq].vf + 1)),
                                     get_vdev(is_ldb,cq),
                                     pasid
                                     );

      if (pasid != get_pasid(is_ldb,cq)) begin
        if (is_ldb) begin
          ldb_pp_cq_cfg[cq].pasid = pasid;
        end else begin
          dir_pp_cq_cfg[cq].pasid = pasid;
        end 
      end 

      //-- cq_hpa (physical address) 
      if (is_ldb) begin
         ldb_pp_cq_cfg[cq].cq_hpa = decode_cq_gpa;
         ldb_pp_cq_cfg[cq].cq_bdf = hqm_bdf;
         if(mem_size > 'h1000 || has_pagesize_2M==1)
           ldb_pp_cq_cfg[cq].cq_pagesize = HqmAtsPkg::PAGE_SIZE_2M;
         else 
           ldb_pp_cq_cfg[cq].cq_pagesize = HqmAtsPkg::PAGE_SIZE_4K;
      end else begin
         dir_pp_cq_cfg[cq].cq_hpa = decode_cq_gpa;
         dir_pp_cq_cfg[cq].cq_bdf = hqm_bdf;
         if(mem_size > 'h1000 || has_pagesize_2M==1)
           dir_pp_cq_cfg[cq].cq_pagesize = HqmAtsPkg::PAGE_SIZE_2M;
         else
           dir_pp_cq_cfg[cq].cq_pagesize = HqmAtsPkg::PAGE_SIZE_4K;
      end 

      //-- page_pasidtlp
      page_pasidtlp.pasid_en = pasid>>22;
      page_pasidtlp.priv_mode_requested = pasid[21];
      page_pasidtlp.exe_requested = pasid[20];
  
      page_pasidtlp.pasid = pasid[19:0];
      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_gpa_S1:: is_ldb=%0d cq=%0d; mem_name=%0s mem_size=0x%0x mem_mask=0x%0x -> allocated physical decode_cq_gpa=0x%0x pasid=0x%0x",inst_suffix, is_ldb, cq, mem_name, mem_size, mem_mask, decode_cq_gpa, pasid),UVM_LOW)

      //--AY_HQMV30_ATS_SUPPORT
      //-- for most of test without pasid, the iommu.m_map[bdf][pasid] entry is setup once, and the page_size has to be consistent
      //-- even though the mem_size changes based on cq_depth programming, to deal with the case when pasid is not used, it has to set page_size to the same for all CQs (without pasid programmed) 
      if(mem_size > 'h1000 || has_pagesize_2M==1 || ats_enabled==0)
         page_size = HqmAtsPkg::PAGE_SIZE_2M;
      else 
         page_size = HqmAtsPkg::PAGE_SIZE_4K;

      //-- get a free randomized virtual address based on bdf, pasid, size
      if(pb_addr_width==0) pb_addr_width=$urandom_range(1,3);
      if(pb_translation_type==7) pb_translation_type=$urandom_range(0,4);
      page_logical_addr = getFreeSpaceForPage(hqm_bdf, page_pasidtlp, page_size, decode_cq_gpa, pb_translation_type, pb_addr_width); //--, bit[2:0] translationType = 2, bit[2:0] aw = 3);

      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_gpa_S2:: is_ldb=%0d cq=%0d; decode_cq_gpa=0x%0x (physical addr) => virtual::page_logical_addr=0x%0x with hqm_bdf=0x%0x pasid=0x%0x page_size=%0s pb_translation_type=%0d pb_addr_width=%0d",inst_suffix, is_ldb, cq, decode_cq_gpa, page_logical_addr, hqm_bdf, page_pasidtlp.pasid, page_size.name(), pb_translation_type, pb_addr_width),UVM_LOW)
      
      //-- call iommu.write_address_translation to build m_map[BDF][PASIDStr].m_mem[logical_addr] <= HqmIommuEntry (HqmIommuEntry.translation_addr; and other translation attributes)
       ret_code = iommu.write_address_translation( .bdf(hqm_bdf),       // BDF
                                                    .pasidtlp(page_pasidtlp),
                                                    .logical_address(page_logical_addr), //--virtual addr
                                                    .la_pagesize(page_size),
                                                    .translation_address(decode_cq_gpa), 
                                                    .pa_pagesize(HqmAtsPkg::PageSize_t'(page_size)),
                                                    .untranslated_access_only(page_untranslated_access_only), 
                                                    .privileged_mode_access(page_privileged_mode_access), 
                                                    .execute_permitted(page_execute_permitted),
                                                    .global_mapping(page_global_mapping), 
                                                    .non_snooped_access(page_non_snooped_access),
                                                    .write_permission(page_write_permission), 
                                                    .read_permission(page_read_permission),
                                                    .entry_overwrite_en(page_overwrite_en),  // entry_overwrite: this switch (when 0) disables overwriting an existing entry
                                                    .entry_check_en(page_check_en) );        // entry_check_en : this switch (when 1) checks that the translation entry does not have don't-care X values

      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_gpa_S3:: is_ldb=%0d cq=%0d; decode_cq_gpa=0x%0x page_logical_addr=0x%0x with hqm_bdf=0x%0x pasid=0x%0x page_size=%0s => iommu.write_address_translation ret_code=%0d",inst_suffix, is_ldb, cq, decode_cq_gpa, page_logical_addr, hqm_bdf, page_pasidtlp.pasid, page_size.name(), ret_code),UVM_LOW)

      //--AY_HQMV30_ATS:  once RTL is intergated, change to have: cq_gpa=page_logical_addr; (virtual address)
      //--AY_HQMV30_ATS   decode_cq_gpa = page_logical_addr;    
      if(ats_enabled==1) begin
        decode_cq_gpa = page_logical_addr;   
      end 

      //--print out settings of cq_gpa(virtual) cq_hpa(physical)
      if(is_ldb) begin
          ldb_pp_cq_cfg[cq].cq_gpa = decode_cq_gpa;
         `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_gpa_S4:: LDBCQ_HPA_GPA_Settings - return 0x%0x with settings ldb_pp_cq_cfg[%0d].cq_gpa=0x%0x ldb_pp_cq_cfg[%0d].cq_hpa=0x%0x cq_bdf=0x%0x cq_pasid=0x%0x cq_pagesize=%0s",inst_suffix, decode_cq_gpa, cq, ldb_pp_cq_cfg[cq].cq_gpa, cq, ldb_pp_cq_cfg[cq].cq_hpa, ldb_pp_cq_cfg[cq].cq_bdf, ldb_pp_cq_cfg[cq].pasid, ldb_pp_cq_cfg[cq].cq_pagesize.name()),UVM_LOW)
      end else begin
          dir_pp_cq_cfg[cq].cq_gpa = decode_cq_gpa;
         `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_gpa_S4:: DIRCQ_HPA_GPA_Settings - return 0x%0x with settings dir_pp_cq_cfg[%0d].cq_gpa=0x%0x dir_pp_cq_cfg[%0d].cq_hpa=0x%0x cq_bdf=0x%0x cq_pasid=0x%0x cq_pagesize=%0s",inst_suffix, decode_cq_gpa, cq, dir_pp_cq_cfg[cq].cq_gpa, cq, dir_pp_cq_cfg[cq].cq_hpa, dir_pp_cq_cfg[cq].cq_bdf, dir_pp_cq_cfg[cq].pasid, dir_pp_cq_cfg[cq].cq_pagesize.name()),UVM_LOW)
      end 
    end else begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__Option %s value string %s not a valid setting",inst_suffix,option.option,option.str_value))
    end 
  end else begin
    decode_cq_gpa = option.values[0];
  end 
endfunction


//----------------------------------------------------------------------------
//-- AY_HQMV30_ATS_SUPPORT
//-- getFreeSpaceForPage
//-- when translationType=0, take it as pass-through mode (with size masked)
//----------------------------------------------------------------------------
function bit[63:0] hqm_cfg::getFreeSpaceForPage(input bit[15:0] bdf, HqmPasid_t pasidtlp, HqmAtsPkg::PageSize_t pageSize, bit [63:0] physical_addr, bit[2:0] translationType = 2, bit[2:0] aw = 3);
    bit[63:0] addr;
    bit gpa_good = 0;
    bit has_addr_exists;
    bit has_addr_intrrange;

    addr = getRandomAddr(pageSize, physical_addr, translationType, aw);
   
    if(translationType!=3'b000) begin
       while (~gpa_good) begin
          has_addr_exists    = iommu.translation_exists(bdf, pasidtlp, addr);
          has_addr_intrrange = isAddrInInterruptRange(addr);
         `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__getFreeSpaceForPage:: bdf=0x%0x pasid=0x%0x try rand_virt_addr=0x%0x -> has_addr_exists=%0d has_addr_intrrange=%0d",inst_suffix, bdf, pasidtlp.pasid, addr, has_addr_exists, has_addr_intrrange),UVM_MEDIUM)

          if (has_addr_exists || has_addr_intrrange) begin
             addr = getRandomAddr(pageSize, translationType, aw);
          end else begin
             gpa_good = 1;
            `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__getFreeSpaceForPage:: bdf=0x%0x pasid=0x%0x get virt_addr=0x%0x -> has_addr_exists=%0d has_addr_intrrange=%0d",inst_suffix, bdf, pasidtlp.pasid, addr, has_addr_exists, has_addr_intrrange),UVM_LOW)
          end 
       end 
    end 

    /*-- When ide_t is added, revisit::
    if (bdf.ide_t==1 && ($test$plusargs("TDXIO_SSL7_FAULT")))begin
      $display("Kranthi : Injecting SSl.7 fault");
      addr[51] = 1;
      addr[47] = 1;
       return addr;
    end 
    else if (bdf.ide_t==1 && (aw == 3'b011)) begin
       $display("Kranthi : Inside ENTRY_AW_5LVL : Overriding the addr for SSL.7 Fault");
       addr[51] =0;
       addr[47] =0;
       return addr;
    end else if (bdf.ide_t==1 && (aw != 3'b011))begin
       $display("Kranthi : Inside ENTRY_AW_4LVL : Overriding the addr for SSL.7 Fault");
       addr[51] =0;
       addr[47] =0;
       return addr;
    end else begin
       return addr;
    end 
    --*/

    return addr;
endfunction

//----------------------------------------------------------------------------
//-- AY_HQMV30_ATS_SUPPORT
//-- isAddrInInterruptRange 
//----------------------------------------------------------------------------
function bit hqm_cfg::isAddrInInterruptRange(bit[63:0] addr);
    isAddrInInterruptRange = (addr[31:20] == 12'hFEE);
endfunction

//        PASIDTABLE_ENTRY_PGTT_RSVD0   = 3'b000,
//        PASIDTABLE_ENTRY_PGTT_FL_ONLY = 3'b001,
//        PASIDTABLE_ENTRY_PGTT_SL_ONLY = 3'b010,
//        PASIDTABLE_ENTRY_PGTT_NESTED  = 3'b011,
//        PASIDTABLE_ENTRY_PGTT_PT      = 3'b100,
//        PASIDTABLE_ENTRY_PGTT_RSVD1   = 3'b101,
//        PASIDTABLE_ENTRY_PGTT_RSVD2   = 3'b110,
//        PASIDTABLE_ENTRY_PGTT_RSVD3   = 3'b111

//        ENTRY_AW_RSVD0 = 3'b000, => use this mode as pass-through
//        ENTRY_AW_3LVL  = 3'b001, // 39-bit AGAW
//        ENTRY_AW_4LVL  = 3'b010, // 48-bit AGAW
//        ENTRY_AW_5LVL  = 3'b011, // 57-bit AGAW
//                         3'b100 : 
//                         

//----------------------------------------------------------------------------
//-- AY_HQMV30_ATS_SUPPORT
//-- getRandomAddr 
//----------------------------------------------------------------------------
function bit[63:0]  hqm_cfg::getRandomAddr(HqmAtsPkg::PageSize_t pageSize, bit [63:0] physical_addr, bit[2:0] translationType=2,  bit[2:0] aw = 3);
    bit[63:0]  randAddr = {$urandom(), $urandom()};
    bit[63:0]  paddedAddr;

    case (translationType) 
        3'b000          : paddedAddr = physical_addr;               //--pass-through
        3'b001, 3'b011  : paddedAddr = randAddr[HQM_IOMMU_LAW-1:0]; //[56:0]
        3'b010          :  begin
                                    case(aw)
                                       3'b011  : paddedAddr =  (HQM_IOMMU_GAW < 57) ? randAddr[HQM_IOMMU_GAW-1:0] : randAddr[56:0];  //[56:0]
                                       3'b010  : paddedAddr =  (HQM_IOMMU_GAW < 48) ? randAddr[HQM_IOMMU_GAW-1:0] : randAddr[47:0];
                                       3'b001  : paddedAddr =  (HQM_IOMMU_GAW < 39) ? randAddr[HQM_IOMMU_GAW-1:0] : randAddr[38:0];
                                       default : paddedAddr = randAddr[HQM_IOMMU_GAW-1:0] ;
                                    endcase 
                           end 
        3'b100          : paddedAddr = randAddr[HQM_IOMMU_HAW-1:0]; //[51:0]
    endcase 


    case (pageSize)
        PAGE_SIZE_4K : getRandomAddr = {paddedAddr[63:12],12'h0};
        PAGE_SIZE_2M : getRandomAddr = {paddedAddr[63:21],21'h0};
        PAGE_SIZE_1M : getRandomAddr = {paddedAddr[63:30],30'h0};
    endcase    
   `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__getRandomAddr:: pageSize=%0s physical_addr=0x%0x translationType=%0d aw=%0d randAddr=0x%0x paddedAddr=0x%0x -> get getRandomAddr=0x%0x ",inst_suffix, pageSize.name(), physical_addr, translationType, aw, randAddr, paddedAddr, getRandomAddr),UVM_MEDIUM)
endfunction


//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function void hqm_cfg::update_configuration();
    string file_name;
    string reg_name;
    //======================================================================
    //CHP
    //======================================================================
    if (update_CHP_cfg) begin
      update_CHP_cfg = 0;
      file_name = "credit_hist_pipe";
    end 
    //======================================================================
    //LSP ---> LIST_SEL_PIPE
    //======================================================================
    if (update_LSP_cfg) begin
      update_LSP_cfg = 0;
      file_name = "list_sel_pipe";
      foreach(this.ldb_pp_cq_cfg[i]) begin
          for (int kk=0; kk<8; kk++) begin
             reg_name = $psprintf("cfg_cq2priov[%0d]", i);
             this.set_cfg_val(set_cfg_val_op, file_name, reg_name, "prio",  ldb_pp_cq_cfg[i].qidix[kk].pri);
             this.set_cfg_val(set_cfg_val_op, file_name, reg_name, "v",     ldb_pp_cq_cfg[i].qidix[kk].qidv);
          end 
      end 
      
      foreach (this.ldb_pp_cq_cfg[i]) begin  
         reg_name = $psprintf("cfg_cq2qid1[%0d]", i);
         this.set_cfg_val(set_cfg_val_op, file_name, reg_name, "qid", {this.ldb_pp_cq_cfg[i].qidix[7].qid[6:0], 
                                                       this.ldb_pp_cq_cfg[i].qidix[6].qid[6:0],
                                                       this.ldb_pp_cq_cfg[i].qidix[5].qid[6:0],
                                                       this.ldb_pp_cq_cfg[i].qidix[4].qid[6:0]});
      end 
      
	  foreach(this.ldb_pp_cq_cfg[i]) begin  
         reg_name = $psprintf("cfg_cq2qid0[%0d]", i);
         this.set_cfg_val(set_cfg_val_op, file_name, reg_name, "qid", {this.ldb_pp_cq_cfg[i].qidix[3].qid[6:0], 
                                                       this.ldb_pp_cq_cfg[i].qidix[2].qid[6:0],
                                                       this.ldb_pp_cq_cfg[i].qidix[1].qid[6:0],
                                                       this.ldb_pp_cq_cfg[i].qidix[0].qid[6:0]});           
      
      
      
        
      end 
        
      for (int x=0;x<hqm_pkg::NUM_LDB_QID;x++) begin
        for (int y=0;y<16;y++) begin
          for (int z=0;z<4;z++) begin
              if(y > 9) begin
                 reg_name = $psprintf("cfg_qid_ldb_qid2cqidix_%0d[%0d]", y, x*4+z);
              end else begin
                 reg_name = $psprintf("cfg_qid_ldb_qid2cqidix_0%0d[%0d]", y, x*4+z);
              end 
              this.set_cfg_val(set_cfg_val_op, file_name, reg_name, "qidixv", qid2cqidix_table[z][y][x]);
          end 
        end 
      end 

	end  
    //======================================================================
    //DP
    //======================================================================
    if (update_DP_cfg) begin
      update_DP_cfg = 0;
      file_name = "direct_pipe";
    end 
    //======================================================================
    //AP
    //======================================================================
    if (update_AP_cfg) begin
      update_AP_cfg = 0;
      file_name = "atm_pipe";
    end 
    //======================================================================
    //NALB
    //======================================================================
    if (update_NALB_cfg) begin
      update_NALB_cfg = 0;
      file_name = "nalb_pipe";
    end 
    //======================================================================
    //ROP
    //======================================================================
    if (update_ROP_cfg) begin
      update_ROP_cfg = 0;
      file_name = "reorder_pipe";
    end 
    //======================================================================
    //MASTER
    //======================================================================
    if (update_MASTER_cfg) begin
      update_MASTER_cfg = 0;
      file_name = "master";
    end 
    //======================================================================
    //CFG_RING
    //======================================================================
    if (update_CFG_RING_cfg) begin
      update_CFG_RING_cfg = 0;
      file_name = "cfg_ring_bcast";
    end 
    //======================================================================
    //AQED
    //======================================================================
    if (update_AQED_cfg) begin
      update_AQED_cfg = 0;
      file_name = "aqed_pipe";
    end 
    //======================================================================
    //QED
    //======================================================================
    if (update_QED_cfg) begin
      update_QED_cfg = 0;
      file_name = "qed_pipe";
    end 
endfunction
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function void hqm_cfg::set_reg_cfg_val(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, uvm_reg_data_t value);
                                                    
    uvm_reg   my_reg   = hqm_find_reg_by_file_name(reg_name, {tb_env_hier, ".", file_name});
   if (my_reg == null) begin
      uvm_report_error("RAL CFG SET", $psprintf("HQM%0s__%0s__Unable to find %s.%s", inst_suffix, tb_env_hier, file_name, reg_name));
   end 
   else begin
      uvm_report_info("DEBUG_HQM_CFG RAL CFG SET", $psprintf("HQM%0s__%0s__Setting 0x%0h to %s.%s", inst_suffix, tb_env_hier, value, file_name, reg_name), UVM_MEDIUM);
      //--08122022 my_reg.set_cfg_val(value); //-- set_cfg_val(<reg>,<cfg_val>,<kind = "SLU_CFG_VAL">)
      slu_ral_db::regs.set_cfg_val(my_reg, value);
      this.add_register_to_access_list(file_name, reg_name, "", ops, .sai(cur_sai));  
   end 
  
endfunction  
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function void hqm_cfg::set_cfg_val_index(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, int index, string field_name, uvm_reg_data_t value);
   if(tb_name == "hqm_core") begin
      uvm_report_info("RAL CFG SET", $psprintf("HQM%0s__HQMCORETBSkip_Register_opts:%0s to %0s:%0s[%0d]:%0s=0x%0h", inst_suffix,ops.name(), file_name, reg_name, index, field_name, value), UVM_DEBUG);

   end else begin
      uvm_report_info("RAL CFG SET", $psprintf("HQM%0s__Programming_Access_opts=%0s to %0s:%0s[%0d]:%0s=0x%0h", inst_suffix, ops.name(), file_name, reg_name, index, field_name, value), UVM_MEDIUM);
      reg_name = $psprintf("%s[%0d]",reg_name,index);
      set_cfg_val(ops, file_name, reg_name, field_name, value);
   end 
endfunction  
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function void hqm_cfg::set_cfg_val(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, string field_name, uvm_reg_data_t value);

  uvm_reg_field my_field = hqm_find_field_by_name(field_name, reg_name, {tb_env_hier, ".", file_name});

  uvm_report_info("DEBUG_HQM_CFG RAL CFG SET", $psprintf("HQM%0s__%0s__Find %s.%s.%s", inst_suffix, tb_env_hier, file_name, reg_name, field_name), UVM_MEDIUM);

   if (my_field == null) begin
      uvm_report_error("RAL CFG SET", $psprintf("HQM%0s__Unable to find %s.%s.%s", inst_suffix,file_name, reg_name, field_name));
   end 
   else begin
      uvm_report_info("DEBUG_HQM_CFG RAL CFG SET", $psprintf("HQM%0s__%0s__Setting 0x%0h to %s.%s.%s", inst_suffix, tb_env_hier, value, file_name, reg_name, field_name), UVM_MEDIUM);
      //--08122022 my_field.set_cfg_val(value);
      slu_ral_db::fields.set_cfg_val(my_field, value);
      this.add_register_to_access_list(file_name, reg_name, "", ops, .sai(cur_sai));  
   end 
  
endfunction  
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function void hqm_cfg::or_cfg_val(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, string field_name, uvm_reg_data_t value);

  uvm_reg_field my_field = hqm_find_field_by_name(field_name, reg_name, {tb_env_hier, ".", file_name});
   if (my_field == null) begin
      uvm_report_error("RAL CFG SET", $psprintf("HQM%0s__Unable to find %s.%s.%s", inst_suffix,file_name, reg_name, field_name));
   end 
   else begin
      uvm_reg_data_t cur_value;

      uvm_report_info("RAL CFG SET", $psprintf("HQM%0s__ORing 0x%0h to %s.%s.%s", inst_suffix,value, file_name, reg_name, field_name), UVM_MEDIUM);
      value = value | my_field.get();
      //--08122022 my_field.set_cfg_val(value);
      slu_ral_db::fields.set_cfg_val(my_field, value);
      this.add_register_to_access_list(file_name, reg_name, "", ops, .sai(cur_sai));  
   end 
  
endfunction  
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function void hqm_cfg::and_cfg_val(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, string field_name, uvm_reg_data_t value);

  uvm_reg_field my_field = hqm_find_field_by_name(field_name, reg_name, {tb_env_hier, ".", file_name});
   if (my_field == null) begin
      uvm_report_error("RAL CFG SET", $psprintf("HQM%0s__Unable to find %s.%s.%s", inst_suffix,file_name, reg_name, field_name));
   end 
   else begin
      uvm_reg_data_t cur_value;

      uvm_report_info("RAL CFG SET", $psprintf("HQM%0s__ANDing 0x%0h to %s.%s.%s", inst_suffix,value, file_name, reg_name, field_name), UVM_MEDIUM);
      value = value & my_field.get();
      //--08122022 my_field.set_cfg_val(value);
      slu_ral_db::fields.set_cfg_val(my_field, value);
      this.add_register_to_access_list(file_name, reg_name, "", ops, .sai(cur_sai));  
   end 
  
endfunction  
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function bit hqm_cfg::set_reg_val_index(string file_name, string reg_name, int index, uvm_reg_data_t value);

   reg_name = $psprintf("%s[%0d]",reg_name,index);
   set_reg_val_index = set_reg_val(file_name, reg_name, value);
  
endfunction  
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function bit hqm_cfg::set_reg_val(string file_name, string reg_name, uvm_reg_data_t value);
  uvm_reg   my_reg   = hqm_find_reg_by_file_name(reg_name, {tb_env_hier, ".", file_name});
                                                    
   if (my_reg == null) begin
      uvm_report_error("RAL CFG SET", $psprintf("HQM%0s__Unable to find %s.%s", inst_suffix,file_name, reg_name));
      return 0;
   end 
   else begin
      uvm_reg_data_t cur_value;

      uvm_report_info("DEBUG_HQM_CFG RAL CFG SET", $psprintf("HQM%0s__%0s__Setting 0x%0h to %s.%s actual value", inst_suffix, tb_env_hier, value, file_name, reg_name), UVM_MEDIUM);
      cur_value = my_reg.get();

      if (value == cur_value) begin
        return 0;
      end 

      //--08122022  my_reg.update(value,"backdoor");
      my_reg.update(value);
   end 
  
   return 1;
endfunction  
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function bit hqm_cfg::set_field_val(string file_name, string reg_name, string field_name, uvm_reg_data_t value);
  uvm_reg_field my_field = hqm_find_field_by_name(field_name, reg_name, {tb_env_hier, ".", file_name});

   if (my_field == null) begin
     uvm_report_error(get_full_name(), $psprintf("HQM%0s__Unable to find %s.%s.%s", inst_suffix,file_name, reg_name, field_name));
     return 0;
   end else begin
     uvm_reg_data_t cur_value;

     uvm_report_info("DEBUG_HQM_CFG RAL CFG SET", $psprintf("HQM%0s__%0s__Setting 0x%0h to %s.%s actual value", inst_suffix, tb_env_hier, value, file_name, reg_name), UVM_MEDIUM);

     cur_value = my_field.get();

     if (value == cur_value) begin
       return 0;
     end 

     //--08122022  my_field.update(value,"backdoor");
     my_field.predict(value);
   end 
  
   return 1;
endfunction  
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function bit hqm_cfg::set_act_val_index(string file_name, string reg_name, int index, string field_name, uvm_reg_data_t value);

   reg_name = $psprintf("%s[%0d]",reg_name,index);
   set_act_val_index = set_act_val(file_name, reg_name, field_name, value);
  
endfunction  
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function bit hqm_cfg::set_act_val(string file_name, string reg_name, string field_name, uvm_reg_data_t value);
  uvm_reg_field my_field = hqm_find_field_by_name(field_name, reg_name, {tb_env_hier, ".", file_name});

   if (my_field == null) begin
      uvm_report_error("RAL CFG SET", $psprintf("HQM%0s__Unable to find %s.%s.%s", inst_suffix,file_name, reg_name, field_name));
      return 0;
   end 
   else begin
      uvm_reg_data_t cur_value;

      uvm_report_info("RAL CFG SET", $psprintf("HQM%0s__Setting 0x%0h to %s.%s.%s actual value", inst_suffix,value, file_name, reg_name, field_name), UVM_MEDIUM);

      cur_value = my_field.get_mirrored_value();

      if (value == cur_value) begin
        return 0;
      end 

      //--08122022  my_field.set_actual(value);
      slu_ral_db::fields.set_cfg_val(my_field, value);
   end 
  
   return 1;
endfunction  
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function bit hqm_cfg::or_act_val(hqm_cfg_reg_ops_t ops, string file_name, string reg_name, string field_name, uvm_reg_data_t value);
  uvm_reg_field my_field = hqm_find_field_by_name(field_name, reg_name, {tb_env_hier, ".", file_name});

   if (my_field == null) begin
      uvm_report_error("RAL CFG SET", $psprintf("HQM%0s__Unable to find %s.%s.%s", inst_suffix,file_name, reg_name, field_name));
      return 0;
   end 
   else begin
      uvm_reg_data_t cur_value;

      uvm_report_info("RAL CFG SET", $psprintf("HQM%0s__ORing 0x%0h to %s.%s.%s actual value", inst_suffix,value, file_name, reg_name, field_name), UVM_MEDIUM);
      cur_value = my_field.get();
      value = value | cur_value;

      if (value == cur_value) begin
        return 0;
      end 

      //--08122022  my_field.update(value,"backdoor");
      my_field.predict(value);
   end 
  
   return 1;
endfunction  
//-------------------------------------------------------------
//
//-------------------------------------------------------------
function void hqm_cfg::add_register_to_access_list( string file_name,
                                                    string reg_name,
                                                    string field_name,
                                                    hqm_cfg_reg_ops_t ops, 
                                                    uvm_reg_data_t exp_rd_val=0, 
                                                    uvm_reg_data_t exp_rd_mask=0, 
                                                    int  poll_delay=0,
                                                    int  poll_timeout=4000,
                                                    longint offset=0,
                                                    bit [7:0] sai);
    hqm_cfg_register_ops regs;
    int   idx;

    if (remove_duplicate) begin
      int qi[$];

      qi = register_access_list.find_index with ( (item.file_name == file_name) && (item.reg_name == reg_name) && (item.ops == HQM_CFG_WRITE));

      if (qi.size() > 0) return;
    end 

    regs                = hqm_cfg_register_ops::type_id::create("regs");
    regs.file_name      = file_name;
    regs.reg_name       = reg_name;
    regs.field_name     = field_name;
    regs.ops            = ops;
    regs.exp_rd_val     = exp_rd_val;
    regs.exp_rd_mask    = exp_rd_mask;
    regs.poll_delay     = poll_delay;    
    regs.poll_timeout   = poll_timeout;    
    regs.offset         = offset;    
    regs.sai            = sai;    

    `uvm_info("HQM_CFG",$psprintf("HQM%0s__add_register_to_access_list(file_name=%s,reg_name=%s,field_name=%s,ops=%s,offset=0x%0x,sai=0x%02x",inst_suffix,regs.file_name,regs.reg_name,regs.field_name,regs.ops.name(),regs.offset,regs.sai),UVM_MEDIUM)

    this.register_access_list.push_back(regs);
    uvm_report_info("CFG", $psprintf("HQM%0s__Pending Register Ops -> %0d", inst_suffix,this.register_access_list.size), UVM_MEDIUM);
endfunction

//-------------------------------------------------------------
//
//-------------------------------------------------------------
function hqm_cfg_register_ops hqm_cfg::get_next_register_from_access_list();
    if (this.register_access_list.size > 0) begin
       uvm_report_info("CFG", $psprintf("HQM%0s__Pending Register Ops -> %0d", inst_suffix,this.register_access_list.size), UVM_MEDIUM);
       return this.register_access_list.pop_front();
    end 
    else begin
       return null;
    end 
endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit [31:0]   hqm_cfg::get_cfg_value();
    uvm_reg_field   my_field;
    uvm_reg     my_reg;
     
    if (this.command_reg_field_name == "") begin 
      my_reg = hqm_find_reg_by_file_name(this.command_reg_reg_name, {tb_env_hier, ".", this.command_reg_file_name});
        if (my_reg == null) begin
           uvm_report_error("RAL CFG GET", $psprintf("HQM%0s__Unable to find %s.%s", inst_suffix,this.command_reg_file_name, this.command_reg_reg_name));
           return 0;
        end 
        else begin
          return my_reg.get();
        end 
    end 
    else begin
      my_field = hqm_find_field_by_name(this.command_reg_field_name, this.command_reg_reg_name, {tb_env_hier, ".", this.command_reg_file_name});
        if (my_field == null) begin
           uvm_report_error("RAL CFG GET", $psprintf("HQM%0s__Unable to find %s.%s.%s", inst_suffix,this.command_reg_file_name, this.command_reg_reg_name, this.command_reg_field_name));
           return 0;
        end 
        else begin
          return my_field.get();
        end 
    end 

endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function bit [31:0]   hqm_cfg::get_act_value();
    uvm_reg_field   my_field;
    uvm_reg     my_reg;
     
    if (this.command_reg_field_name == "") begin 
      my_reg = hqm_find_reg_by_file_name(this.command_reg_reg_name, {tb_env_hier, ".", this.command_reg_file_name});
        if (my_reg == null) begin
           uvm_report_error("RAL CFG GET", $psprintf("HQM%0s__Unable to find %s.%s", inst_suffix,this.command_reg_file_name, this.command_reg_reg_name));
           return 0;
        end 
        else begin
          return my_reg.get_mirrored_value();
        end 
    end 
    else begin
      my_field = hqm_find_field_by_name(this.command_reg_field_name, this.command_reg_reg_name, {tb_env_hier, ".", this.command_reg_file_name});
        if (my_field == null) begin
           uvm_report_error("RAL CFG GET", $psprintf("HQM%0s__Unable to find %s.%s.%s", inst_suffix,this.command_reg_file_name, this.command_reg_reg_name, this.command_reg_field_name));
           return 0;
        end 
        else begin
          return my_field.get_mirrored_value();
        end 
    end 

endfunction
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function uvm_reg_data_t hqm_cfg::get_act_ral_val(string file_name, string reg_name, string field_name);
    uvm_reg_field   my_field;
    uvm_reg     my_reg;
     
    if (field_name == "") begin 
      my_reg = hqm_find_reg_by_file_name(reg_name, {tb_env_hier, ".", file_name});
        if (my_reg == null) begin
           uvm_report_error("RAL CFG GET", $psprintf("HQM%0s__Unable to find %s.%s", inst_suffix,file_name, reg_name));
           return 0;
        end 
        else begin
          uvm_report_info("DEBUG_HQM_CFG", $psprintf("HQM%0s__get_act_ral_val_  %s.%s.%s actual value 0x%0x, tb_env_hier=%0s", inst_suffix, file_name, reg_name, field_name, my_reg.get_mirrored_value(), tb_env_hier), UVM_MEDIUM);
          return my_reg.get_mirrored_value();
        end 
    end 
    else begin
      my_field = hqm_find_field_by_name(field_name, reg_name, {tb_env_hier, ".", file_name});
        if (my_field == null) begin
           uvm_report_error("RAL CFG GET", $psprintf("HQM%0s__Unable to find %s.%s.%s", inst_suffix,file_name, reg_name, field_name));
           return 0;
        end 
        else begin
          uvm_report_info("DEBUG_HQM_CFG", $psprintf("HQM%0s__get_act_ral_val  %s.%s.%s actual value 0x%0x, tb_env_hier=%0s", inst_suffix, file_name, reg_name, field_name, my_field.get_mirrored_value(), tb_env_hier), UVM_MEDIUM);
          return my_field.get_mirrored_value();
        end 
    end 

endfunction
//----------------------------------------------------------------------------
//-	Set the state of the cfg object to begin accepting sequences of configuration values
//----------------------------------------------------------------------------
function void hqm_cfg::set_cfg_begin();
    this.cfg_state = SEQ;
endfunction
//----------------------------------------------------------------------------
//-	Set the state of cfg object to end of accepting sequence of configuration values
//-	When the function is call it should trigger sequences to preform full configurations
//----------------------------------------------------------------------------
function void hqm_cfg::set_cfg_end(hqm_cfg_command command=null);
    this.cfg_state = NON_SEQ;
endfunction
//----------------------------------------------------------------------------
//-	Write HCW to hcw_gen_port for a generated HCW
//----------------------------------------------------------------------------
task hqm_cfg::write_hcw_gen_port(hcw_transaction hcw_trans);
  hcw_gen_port.write(hcw_trans);
endtask
//----------------------------------------------------------------------------
//-	Sets configuration variable or register.
//-	This should be task accept the Commands proposed and also takes register name and value to and set it through the RAL
//-	This task is blocking if configuration STATE is set to NON_SEQ or CFG_IN_PROGRESS
//-	This task is non-blocking if configuration STATE is set to SEQ
//----------------------------------------------------------------------------
task hqm_cfg::set_cfg(input string commands, output bit do_cfg_seq);
  hqm_command_handler_status_t       command_status;

    //decode command to set configuration or register value
    command_status = command_decode(commands);

    //update configuration or register vaule if in SEQ state
    if ((this.cfg_state == SEQ) || (command_status != HQM_CFG_CMD_DONE)) begin
        do_cfg_seq = 1'b0;
    end 
    //perform configuration immediately otherwise
    else begin
        do_cfg_seq = 1'b1;
        update_configuration();
        validate_configuration();
    end 
endtask
//----------------------------------------------------------------------------
//-	Return the current configuration value or register value 
//-	This task is blocking if configuration is CFG_IN_PROGRESS and NON_SEQ
//-	This task is non-blocking if configuration is set to SEQ
//-	If do_read bit is set to 1 and configuration state is NON_SEQ actual cfg read should be perform to retrieve register value if register value is requested
//----------------------------------------------------------------------------
task hqm_cfg::get_cfg(input string commands, output bit [31:0] value);
  hqm_cfg_command command;
  int status;
  
  commands = commands.tolower();
  ltrim_string(commands);
  rtrim_string(commands);

  if (commands.len() == 0) begin
    return;
  end 

  if (commands[0] == "#") begin
    return;
  end 

  status = command_parser.get_command(commands, command);

  if(status) begin
    if (command.get_type == HQM_CFG_RD_REG) begin
        value = get_cfg_value();
    end 
    else begin
        value = 0;
    end 
  end 
endtask
//----------------------------------------------------------------------------
//-	backdoor_mem_init - initialize memory structures using backdoor access
//----------------------------------------------------------------------------
task hqm_cfg::backdoor_mem_init();
  string                prefix_chp;
  string                mem_prefix_chp_srw;
  string                mem_prefix_nalb_srw;
  string                mem_prefix_dir_srw;
  string                mem_prefix_qed_srw;
  uvm_reg_data_t        clk_cnt;
  uvm_reg_data_t        old_clk_val;
  uvm_reg_data_t        clk_val, proc_reset_done;

  /*
  if (hqm_core_module_prefix != "") begin
    `uvm_info("HQM_CFG","Initializing Memory structures",UVM_HIGH);

    prefix_chp          = "par_hqm_credit_hist_pipe.i_hqm_credit_hist_pipe.i_hqm_credit_hist_pipe_core";
    mem_prefix_chp_srw  = "par_hqm_credit_hist_pipe.i_hqm_credit_hist_pipe.i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_srw_top.i_hqm_credit_hist_pipe_srw";
    mem_prefix_nalb_srw = "par_hqm_nalb_pipe.i_hqm_nalb_pipe.i_hqm_nalb_pipe_core.i_hqm_nalb_pipe_srw_top.i_hqm_nalb_pipe_srw";
    mem_prefix_dir_srw  = "par_hqm_dir_pipe.i_hqm_dir_pipe.i_hqm_dir_pipe_core.i_hqm_dir_pipe_srw_top.i_hqm_dir_pipe_srw";
    mem_prefix_qed_srw  = "par_hqm_qed_pipe.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_qed_pipe_srw_top.i_hqm_qed_pipe_srw";

    proc_reset_done = 0;
    while (!proc_reset_done) begin
      proc_reset_done = sla_vpi_get_value_by_name($psprintf("%s.hqm_proc_reset_done",
                                          hqm_core_module_prefix
                                         ));
      #0.1ns;
    end 

    for (bit [31:0] qed_freelist_addr = 0 ; qed_freelist_addr < 32'h2000 ; qed_freelist_addr++) begin
      if (qed_freelist_addr[12]) begin
        sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_qed_freelist.i_sram_b1.hqm_ip7413srhsshp4096x20m8c1.hqm_ip7413srhsshp4096x20m8c1_bmod.hqm_ip7413srhsshp4096x20m8c1_array.array[%0d]",
                                            hqm_core_module_prefix,
                                            mem_prefix_chp_srw,
                                            qed_freelist_addr - 32'h1000
                                           ),{nu_ecc_pkg::nu_ecc_d14_e6_gen(qed_freelist_addr[13:0]),qed_freelist_addr[13:0]});
      end else begin
        sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_qed_freelist.i_sram_b0.hqm_ip7413srhsshp4096x20m8c1.hqm_ip7413srhsshp4096x20m8c1_bmod.hqm_ip7413srhsshp4096x20m8c1_array.array[%0d]",
                                            hqm_core_module_prefix,
                                            mem_prefix_chp_srw,
                                            qed_freelist_addr
                                           ),{nu_ecc_pkg::nu_ecc_d14_e6_gen(qed_freelist_addr[13:0]),qed_freelist_addr[13:0]});
      end 
    end 

    for (bit [31:0] dqed_freelist_addr = 0 ; dqed_freelist_addr < 32'h1000 ; dqed_freelist_addr++) begin
      sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_dqed_freelist.i_sram.hqm_ip7413srhsshp4096x19m8c1.hqm_ip7413srhsshp4096x19m8c1_bmod.hqm_ip7413srhsshp4096x19m8c1_array.array[%0d]",
                                          hqm_core_module_prefix,
                                          mem_prefix_chp_srw,
                                          dqed_freelist_addr
                                         ), {nu_ecc_pkg::nu_ecc_d13_e6_gen(dqed_freelist_addr[12:0]),dqed_freelist_addr[12:0]});
    end 

    for (bit [31:0] nalb_nxt_hp_addr = 0 ; nalb_nxt_hp_addr < 32'h2000 ; nalb_nxt_hp_addr++) begin
      if (nalb_nxt_hp_addr[12]) begin
        sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_nalb_nxthp.i_sram_b1.hqm_ip7413srhsshp4096x20m8c1.hqm_ip7413srhsshp4096x20m8c1_bmod.hqm_ip7413srhsshp4096x20m8c1_array.array[%0d]",
                                            hqm_core_module_prefix,
                                            mem_prefix_nalb_srw,
                                            nalb_nxt_hp_addr - 32'h1000
                                           ), {nu_ecc_pkg::nu_ecc_d14_e6_gen(14'h0),14'h0});
      end else begin
        sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_nalb_nxthp.i_sram_b0.hqm_ip7413srhsshp4096x20m8c1.hqm_ip7413srhsshp4096x20m8c1_bmod.hqm_ip7413srhsshp4096x20m8c1_array.array[%0d]",
                                            hqm_core_module_prefix,
                                            mem_prefix_nalb_srw,
                                            nalb_nxt_hp_addr
                                           ), {nu_ecc_pkg::nu_ecc_d14_e6_gen(14'h0),14'h0});
      end 
    end 

    for (bit [31:0] dp_nxt_hp_addr = 0 ; dp_nxt_hp_addr < 32'h1000 ; dp_nxt_hp_addr++) begin
      sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_dir_nxthp.i_sram.hqm_ip7413srhsshp4096x19m8c1.hqm_ip7413srhsshp4096x19m8c1_bmod.hqm_ip7413srhsshp4096x19m8c1_array.array[%0d]",
                                          hqm_core_module_prefix,
                                          mem_prefix_dir_srw,
                                          dp_nxt_hp_addr
                                         ), {nu_ecc_pkg::nu_ecc_d13_e6_gen(13'h0),13'h0});
    end 

    for (bit [31:0] qed_addr = 0 ; qed_addr < 32'h1000 ; qed_addr++) begin
      bit [126:0] wdata;

      wdata = {nu_ecc_pkg::nu_ecc_d56_e7_gen(56'h0),nu_ecc_pkg::nu_ecc_d56_e7_gen(56'h0),56'h0,56'h0};

      sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_qed_e.i_sram_b0.hqm_ip7413srhsshp4096x42m8c1.hqm_ip7413srhsshp4096x42m8c1_bmod.hqm_ip7413srhsshp4096x42m8c1_array.array[%0d]",
                                          hqm_core_module_prefix,
                                          mem_prefix_qed_srw,
                                          qed_addr
                                         ), wdata[41:0]);
      sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_qed_e.i_sram_b1.hqm_ip7413srhsshp4096x42m8c1.hqm_ip7413srhsshp4096x42m8c1_bmod.hqm_ip7413srhsshp4096x42m8c1_array.array[%0d]",
                                          hqm_core_module_prefix,
                                          mem_prefix_qed_srw,
                                          qed_addr
                                         ), wdata[83:42]);
      sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_qed_e.i_sram_b2.hqm_ip7413srhsshp4096x42m8c1.hqm_ip7413srhsshp4096x42m8c1_bmod.hqm_ip7413srhsshp4096x42m8c1_array.array[%0d]",
                                          hqm_core_module_prefix,
                                          mem_prefix_qed_srw,
                                          qed_addr
                                         ), wdata[125:84]);

      sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_qed_o.i_sram_b0.hqm_ip7413srhsshp4096x42m8c1.hqm_ip7413srhsshp4096x42m8c1_bmod.hqm_ip7413srhsshp4096x42m8c1_array.array[%0d]",
                                          hqm_core_module_prefix,
                                          mem_prefix_qed_srw,
                                          qed_addr
                                         ), wdata[41:0]);
      sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_qed_o.i_sram_b1.hqm_ip7413srhsshp4096x42m8c1.hqm_ip7413srhsshp4096x42m8c1_bmod.hqm_ip7413srhsshp4096x42m8c1_array.array[%0d]",
                                          hqm_core_module_prefix,
                                          mem_prefix_qed_srw,
                                          qed_addr
                                         ), wdata[83:42]);
      sla_vpi_put_value_by_name($psprintf("%s.%s.i_sr_qed_o.i_sram_b2.hqm_ip7413srhsshp4096x42m8c1.hqm_ip7413srhsshp4096x42m8c1_bmod.hqm_ip7413srhsshp4096x42m8c1_array.array[%0d]",
                                          hqm_core_module_prefix,
                                          mem_prefix_qed_srw,
                                          qed_addr
                                         ), wdata[125:84]);

    end 

    sla_vpi_force_value_by_name($psprintf("%s.%s.i_mf_qed_freelist.size_nxt",
                                          hqm_core_module_prefix,
                                          prefix_chp
                                         ), 14'h2000);

    sla_vpi_force_value_by_name($psprintf("%s.%s.i_mf_qed_freelist.wp_nxt",
                                          hqm_core_module_prefix,
                                          prefix_chp
                                         ), 14'h0000);

    clk_cnt = 0;
    old_clk_val = 1;

    while (clk_cnt < 2) begin
      clk_val = sla_vpi_get_value_by_name($psprintf("%s.%s.i_mf_qed_freelist.clk",
                                          hqm_core_module_prefix,
                                          prefix_chp
                                         ));

      if ((old_clk_val == 0) && (clk_val == 1)) clk_cnt++;

      old_clk_val = clk_val;
      #0.1ns;
    end 

    sla_vpi_release_value_by_name($psprintf("%s.%s.i_mf_qed_freelist.size_nxt",
                                            hqm_core_module_prefix,
                                            prefix_chp
                                           ), 14'h2000);

    sla_vpi_release_value_by_name($psprintf("%s.%s.i_mf_qed_freelist.wp_nxt",
                                            hqm_core_module_prefix,
                                            prefix_chp
                                           ), 14'h0000); 

  end 
  */
endtask
//----------------------------------------------------------------------------
//-	This function should be call after set_cfg_done is call to validate all configuration set is valid when configuration state is set to SEQ
//-	This function should be call when set_cfg is call to validate configuration request is valid when configuration state is set to NON_SEQ
//-	If invalid configuration is detected,  error should be reported and simulations should be terminated if end_test_if_invalid == 1
//----------------------------------------------------------------------------
function void hqm_cfg::validate_configuration(bit end_test_if_invalid = 1);
endfunction

//----------------------------------------------------------------------------
//-- decode_pp_addr
//--   - return pp_num and pp_type if address is a valid producer port address
//--   - return value of 1 if valid producer port address, 0 otherwise
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_pp_addr(input logic [63:0] address,output int pp_num,output int pp_type,output bit is_pf, output int vf_num, output int vpp_num, output bit is_nm_pf);
  logic [63:26] func_pf_bar;

  // default values (not a pp address)
  pp_num        = -1;
  pp_type       = -1;
  is_pf         = 1'b0;
  vf_num        = -1;
  vpp_num       = -1;
  is_nm_pf      = 1'b0;

  func_pf_bar[63:32] = func_bar_u_reg.get_mirrored_value();
  func_pf_bar[31:26] = func_bar_l_addr_l_field.get_mirrored_value();

  uvm_report_info("DEBUG_HQM_CFG", $psprintf("HQM%0s__decode_pp_addr: addr=0x%0x func_pf_bar=0x%0x cacheline_addr=0x%0x", inst_suffix, address, func_pf_bar, address[9:6]), UVM_MEDIUM);

  if (address[63:26] == func_pf_bar[63:26]) begin
    `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_pp_addr:: addr=0x%0x func_pf_bar=0x%0x, address[25:22]=0x%0x is_nm_pf(bit21)=%0d is_pf(bit20)=%0d pp_num(19:12)=0x%0x",inst_suffix, address, {func_pf_bar[63:26], 26'h0}, address[25:22], address[21], address[20], address[19:12]),UVM_LOW)

    if ( address[25:22] == 4'h8) begin
      pp_num    = {24'h0, address[19:12]};
      pp_type   = address[20];
      is_pf     = 1'b1;
      is_nm_pf  = address[21];
      if (pp_type) begin
        if (pp_num >= hqm_pkg::NUM_LDB_PP) begin
          pp_num    = -1;
          pp_type   = -1;
        end 
      end else begin
        if (pp_num >= hqm_pkg::NUM_DIR_PP) begin
          pp_num    = -1;
          pp_type   = -1;
        end 
      end 
    end else begin
      pp_num    = -1;
      pp_type   = -1;
      is_pf     = 1'b1;
    end 
  end 

  if (pp_num < 0) begin
    return (0);
  end else begin
    return (1);
  end 
endfunction

//----------------------------------------------------------------------------
//-- check_pp_cacheline_addr
//----------------------------------------------------------------------------
//function void hqm_cfg::check_pp_cacheline_addr(input logic [63:0] address, bit is_ldb, int pp_num);
//  bit [3:0] curr_cl_addr;
//
//  curr_cl_addr=address[9:6];
//
//  if(is_ldb) begin
//     uvm_report_info("DEBUG_HQM_CFG", $psprintf("HQM%0s__check_pp_cacheline_addr: is_ldb=%0d pp_num=%0d addr=0x%0x cacheline_addr=%0d cl_check=%0d cl_cnt=%0d cl_max=%0d", inst_suffix, is_ldb, pp_num, address, curr_cl_addr, ldb_pp_cq_cfg[pp_num].cl_check, ldb_pp_cq_cfg[pp_num].cl_cnt, ldb_pp_cq_cfg[pp_num].cl_max), UVM_MEDIUM);
//     if(ldb_pp_cq_cfg[pp_num].cl_check) begin
//        if((curr_cl_addr % ldb_pp_cq_cfg[pp_num].cl_max) != ldb_pp_cq_cfg[pp_num].cl_cnt) begin
//          `uvm_error("DEBUG_HQM_CFG",$psprintf("HQM%0s__check_pp_cacheline_addr: is_ldb=%0d pp_num=%0d addr=0x%0x cacheline_addr=0x%0x expect cl_cnt=0x%0x", inst_suffix, is_ldb, pp_num, address, curr_cl_addr, ldb_pp_cq_cfg[pp_num].cl_cnt))
//        end else begin
//          uvm_report_info("DEBUG_HQM_CFG", $psprintf("HQM%0s__check_pp_cacheline_addr: is_ldb=%0d pp_num=%0d addr=0x%0x cacheline_addr=0x%0x match expected cl_cnt", inst_suffix, is_ldb, pp_num, address, curr_cl_addr), UVM_MEDIUM);
//        end 
//        if(ldb_pp_cq_cfg[pp_num].cl_cnt==(ldb_pp_cq_cfg[pp_num].cl_max-1)) begin
//           ldb_pp_cq_cfg[pp_num].cl_cnt=0;
//        end else begin
//           ldb_pp_cq_cfg[pp_num].cl_cnt++;
//        end  
//     end 
//  end else begin
//     uvm_report_info("DEBUG_HQM_CFG", $psprintf("HQM%0s__check_pp_cacheline_addr: is_ldb=%0d pp_num=%0d addr=0x%0x cacheline_addr=%0d cl_check=%0d cl_cnt=%0d cl_max=%0d", inst_suffix, is_ldb, pp_num, address, curr_cl_addr, dir_pp_cq_cfg[pp_num].cl_check, dir_pp_cq_cfg[pp_num].cl_cnt, dir_pp_cq_cfg[pp_num].cl_max), UVM_MEDIUM);
//     if(dir_pp_cq_cfg[pp_num].cl_check) begin
//        if((curr_cl_addr % dir_pp_cq_cfg[pp_num].cl_max) != dir_pp_cq_cfg[pp_num].cl_cnt) begin
//          `uvm_error("DEBUG_HQM_CFG",$psprintf("HQM%0s__check_pp_cacheline_addr: is_ldb=%0d pp_num=%0d addr=0x%0x cacheline_addr=0x%0x expect cl_cnt=0x%0x", inst_suffix, is_ldb, pp_num, address, curr_cl_addr, dir_pp_cq_cfg[pp_num].cl_cnt))
//        end else begin
//          uvm_report_info("DEBUG_HQM_CFG", $psprintf("HQM%0s__check_pp_cacheline_addr: is_ldb=%0d pp_num=%0d addr=0x%0x cacheline_addr=0x%0x match expected cl_cnt", inst_suffix, is_ldb, pp_num, address, curr_cl_addr), UVM_MEDIUM);
//        end 
//        if(dir_pp_cq_cfg[pp_num].cl_cnt==(dir_pp_cq_cfg[pp_num].cl_max-1)) begin
//           dir_pp_cq_cfg[pp_num].cl_cnt=0;
//        end else begin
//           dir_pp_cq_cfg[pp_num].cl_cnt++;
//        end  
//     end 
//  end 
//endfunction

//----------------------------------------------------------------------------
//-- decode_cq_addr
//--   - return cq_num and cq_type if address is a valid consumer queue address
//--   - return value of 1 if valid consumer queue address, 0 otherwise
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_cq_addr(input logic [63:0] address,input int byte_length,output int cq_num,output int cq_type,output bit is_pf, output int vf_num, output int vcq_num, output int cq_index, output int max_cq_index);
  int           cq;
  int           cq64;
  int           vdev;
  bit [63:4]    cq_buffer_upper_limit;

  // default values (not a pp address)
  cq_num        = -1;
  cq_type       = -1;
  is_pf         = 1'b0;
  vf_num        = -1;
  vcq_num       = -1;
  cq_index      = -1;

  // Must be aligned to a 16 byte boundary
  //if (address[3:0] != 4'h0) begin
  //-- hqm_proc Posted Interface address[1:0] are used to indicate CQ[1:0]
  if (address[3:2] != 2'h0) begin
    return(0);
  end 

  if(ats_enabled==1) begin
      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_addr:: start with addr=0x%0x byte_length=%0d with ats_enabled==1",inst_suffix, address, byte_length),UVM_LOW)
      foreach (dir_pp_cq_cfg[cq]) begin
        cq64 = is_single_hcw_per_cl(1'b0) ? 4 : 1;
    
        cq_buffer_upper_limit = dir_pp_cq_cfg[cq].cq_hpa[63:4] + (cq64 << (dir_pp_cq_cfg[cq].cq_depth + 2));
    
        // If the CQ buffer depth would cause cq_buffer_upper_limit to wrap, then truncate
        // The RTL will drop any scheduled QEs that would be at addresses that wrap.
        if (cq_buffer_upper_limit < dir_pp_cq_cfg[cq].cq_hpa[63:4]) begin
          cq_buffer_upper_limit = 60'hffffffff_fffffff;
        end else begin
          cq_buffer_upper_limit--;  // adjust for comparison below
        end 
    
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_addr:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_hpa=0x%0x cq_enable=%0d; cq64=%0d cq_buffer_upper_limit=0x%0x",inst_suffix, cq, cq, dir_pp_cq_cfg[cq].cq_hpa, dir_pp_cq_cfg[cq].cq_enable, cq64, cq_buffer_upper_limit),UVM_LOW)
    
        if (dir_pp_cq_cfg[cq].cq_enable && (address[63:4] >= {dir_pp_cq_cfg[cq].cq_hpa[63:6],2'b00}) &&
            ((address[63:4] + ((byte_length+15)/16) - 1) <= cq_buffer_upper_limit)) begin
          cq_num = cq;
          cq_type = 1'b0;
          is_pf     = dir_pp_cq_cfg[cq].is_pf;
          vf_num    = dir_pp_cq_cfg[cq].vf;
          cq_index  = (address[63:4] - {dir_pp_cq_cfg[cq].cq_hpa[63:6],2'b00}) / cq64;
          max_cq_index = (1 << (dir_pp_cq_cfg[cq].cq_depth + 2)) - 1;
          if (!is_pf) begin
            for (int i = 0 ; i < hqm_pkg::NUM_DIR_PP ; i++) begin
              if ((vf_cfg[vf_num].dir_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].dir_vpp_cfg[i].vpp_v) begin
                vcq_num = i;
                return(1);
              end 
            end 
    
            if (vcq_num < 0) begin
              return(0);
            end 
          end 
    
          `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_addr:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_hpa=0x%0x; decode output: cq=%0d cq_index=%0d is_pf=%0d vf_num=%0d vcq_num=%0d max_cq_index=%0d",inst_suffix, cq, cq, dir_pp_cq_cfg[cq].cq_hpa, cq_num, cq_index, is_pf, vf_num, vcq_num, max_cq_index),UVM_LOW)
          return(1);
        end 
      end 
    
      foreach (ldb_pp_cq_cfg[cq]) begin
        cq64 = is_single_hcw_per_cl(1'b1) ? 4 : 1;
    
        cq_buffer_upper_limit = ldb_pp_cq_cfg[cq].cq_hpa[63:4] + (cq64 << (ldb_pp_cq_cfg[cq].cq_depth + 2));
    
        // If the CQ buffer depth would cause cq_buffer_upper_limit to wrap, then truncate
        // The RTL will drop any scheduled QEs that would be at addresses that wrap.
        if (cq_buffer_upper_limit < ldb_pp_cq_cfg[cq].cq_hpa[63:4]) begin
          cq_buffer_upper_limit = 60'hffffffff_fffffff;
        end else begin
          cq_buffer_upper_limit--;  // adjust for comparison below
        end 
    
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_addr:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_hpa=0x%0x cq_enable=%0d; cq64=%0d cq_buffer_upper_limit=0x%0x",inst_suffix, cq, cq, ldb_pp_cq_cfg[cq].cq_hpa, ldb_pp_cq_cfg[cq].cq_enable, cq64, cq_buffer_upper_limit),UVM_LOW)
    
        if (ldb_pp_cq_cfg[cq].cq_enable &&
            (address[63:4] >= {ldb_pp_cq_cfg[cq].cq_hpa[63:6],2'b00}) &&
            ((address[63:4] + ((byte_length+15)/16) - 1) <= cq_buffer_upper_limit)) begin
          cq_num = cq;
          cq_type = 1'b1;
          is_pf     = ldb_pp_cq_cfg[cq].is_pf;
          vf_num    = ldb_pp_cq_cfg[cq].vf;
          cq_index  = (address[63:4] - {ldb_pp_cq_cfg[cq].cq_hpa[63:6],2'b00}) / cq64;
          max_cq_index = (1 << (ldb_pp_cq_cfg[cq].cq_depth + 2)) - 1;
          if (!is_pf) begin
            for (int i = 0 ; i < hqm_pkg::NUM_LDB_PP ; i++) begin
              if ((vf_cfg[vf_num].ldb_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].ldb_vpp_cfg[i].vpp_v) begin
                vcq_num = i;
                return(1);
              end 
            end 
    
            if (vcq_num < 0) begin
              return(0);
            end 
          end 
    
          `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_addr:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_hpa=0x%0x; decode output: cq=%0d cq_index=%0d is_pf=%0d vf_num=%0d vcq_num=%0d max_cq_index=%0d",inst_suffix, cq, cq, ldb_pp_cq_cfg[cq].cq_hpa, cq_num, cq_index, is_pf, vf_num, vcq_num, max_cq_index),UVM_LOW)
          return(1);
        end 
      end 


  end else begin
      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_addr:: start with addr=0x%0x byte_length=%0d",inst_suffix, address, byte_length),UVM_LOW)
      foreach (dir_pp_cq_cfg[cq]) begin
        cq64 = is_single_hcw_per_cl(1'b0) ? 4 : 1;
    
        cq_buffer_upper_limit = dir_pp_cq_cfg[cq].cq_gpa[63:4] + (cq64 << (dir_pp_cq_cfg[cq].cq_depth + 2));
    
        // If the CQ buffer depth would cause cq_buffer_upper_limit to wrap, then truncate
        // The RTL will drop any scheduled QEs that would be at addresses that wrap.
        if (cq_buffer_upper_limit < dir_pp_cq_cfg[cq].cq_gpa[63:4]) begin
          cq_buffer_upper_limit = 60'hffffffff_fffffff;
        end else begin
          cq_buffer_upper_limit--;  // adjust for comparison below
        end 
    
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_addr:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_gpa=0x%0x cq_enable=%0d; cq64=%0d cq_buffer_upper_limit=0x%0x",inst_suffix, cq, cq, dir_pp_cq_cfg[cq].cq_gpa, dir_pp_cq_cfg[cq].cq_enable, cq64, cq_buffer_upper_limit),UVM_LOW)
    
        if (dir_pp_cq_cfg[cq].cq_enable && (address[63:4] >= {dir_pp_cq_cfg[cq].cq_gpa[63:6],2'b00}) &&
            ((address[63:4] + ((byte_length+15)/16) - 1) <= cq_buffer_upper_limit)) begin
          cq_num = cq;
          cq_type = 1'b0;
          is_pf     = dir_pp_cq_cfg[cq].is_pf;
          vf_num    = dir_pp_cq_cfg[cq].vf;
          cq_index  = (address[63:4] - {dir_pp_cq_cfg[cq].cq_gpa[63:6],2'b00}) / cq64;
          max_cq_index = (1 << (dir_pp_cq_cfg[cq].cq_depth + 2)) - 1;
          if (!is_pf) begin
            for (int i = 0 ; i < hqm_pkg::NUM_DIR_PP ; i++) begin
              if ((vf_cfg[vf_num].dir_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].dir_vpp_cfg[i].vpp_v) begin
                vcq_num = i;
                return(1);
              end 
            end 
    
            if (vcq_num < 0) begin
              return(0);
            end 
          end 
    
          `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_addr:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_gpa=0x%0x; decode output: cq=%0d cq_index=%0d is_pf=%0d vf_num=%0d vcq_num=%0d max_cq_index=%0d",inst_suffix, cq, cq, dir_pp_cq_cfg[cq].cq_gpa, cq_num, cq_index, is_pf, vf_num, vcq_num, max_cq_index),UVM_LOW)
          return(1);
        end 
      end 
    
      foreach (ldb_pp_cq_cfg[cq]) begin
        cq64 = is_single_hcw_per_cl(1'b1) ? 4 : 1;
    
        cq_buffer_upper_limit = ldb_pp_cq_cfg[cq].cq_gpa[63:4] + (cq64 << (ldb_pp_cq_cfg[cq].cq_depth + 2));
    
        // If the CQ buffer depth would cause cq_buffer_upper_limit to wrap, then truncate
        // The RTL will drop any scheduled QEs that would be at addresses that wrap.
        if (cq_buffer_upper_limit < ldb_pp_cq_cfg[cq].cq_gpa[63:4]) begin
          cq_buffer_upper_limit = 60'hffffffff_fffffff;
        end else begin
          cq_buffer_upper_limit--;  // adjust for comparison below
        end 
    
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_addr:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_gpa=0x%0x cq_enable=%0d; cq64=%0d cq_buffer_upper_limit=0x%0x",inst_suffix, cq, cq, ldb_pp_cq_cfg[cq].cq_gpa, ldb_pp_cq_cfg[cq].cq_enable, cq64, cq_buffer_upper_limit),UVM_LOW)
    
        if (ldb_pp_cq_cfg[cq].cq_enable &&
            (address[63:4] >= {ldb_pp_cq_cfg[cq].cq_gpa[63:6],2'b00}) &&
            ((address[63:4] + ((byte_length+15)/16) - 1) <= cq_buffer_upper_limit)) begin
          cq_num = cq;
          cq_type = 1'b1;
          is_pf     = ldb_pp_cq_cfg[cq].is_pf;
          vf_num    = ldb_pp_cq_cfg[cq].vf;
          cq_index  = (address[63:4] - {ldb_pp_cq_cfg[cq].cq_gpa[63:6],2'b00}) / cq64;
          max_cq_index = (1 << (ldb_pp_cq_cfg[cq].cq_depth + 2)) - 1;
          if (!is_pf) begin
            for (int i = 0 ; i < hqm_pkg::NUM_LDB_PP ; i++) begin
              if ((vf_cfg[vf_num].ldb_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].ldb_vpp_cfg[i].vpp_v) begin
                vcq_num = i;
                return(1);
              end 
            end 
    
            if (vcq_num < 0) begin
              return(0);
            end 
          end 
    
          `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_addr:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_gpa=0x%0x; decode output: cq=%0d cq_index=%0d is_pf=%0d vf_num=%0d vcq_num=%0d max_cq_index=%0d",inst_suffix, cq, cq, ldb_pp_cq_cfg[cq].cq_gpa, cq_num, cq_index, is_pf, vf_num, vcq_num, max_cq_index),UVM_LOW)
          return(1);
        end 
      end 
  end // if(ats_enabled==1) 
  return(0);
endfunction:decode_cq_addr





//----------------------------------------------------------------------------
//-- decode_cq_ats_request
//--   - return cq_num and cq_type if ATS request address is a valid virtual address programmed to cq_gpa
//--   - return value of 1 if valid consumer queue address, 0 otherwise
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_cq_ats_request(input logic [63:0] address,input int byte_length,output int cq_num,output int cq_type,output bit is_pf, output int vf_num, output int vcq_num);
  int           cq;
  int           vdev;

  // default values (not a pp address)
  cq_num        = -1;
  cq_type       = -1;
  is_pf         = 1'b0;
  vf_num        = -1;
  vcq_num       = -1;

  //-- AY_HQMV30_AT: check address[11:0]?   
  if (address[3:2] != 2'h0) begin
    return(0);
  end 

  `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_ats_request:: start with addr=0x%0x byte_length=%0d",inst_suffix, address, byte_length),UVM_LOW)

  foreach (dir_pp_cq_cfg[cq]) begin
    `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_ats_request:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_gpa=0x%0x cq_pagesize=%0s cq_enable=%0d; dir_pp_cq_cfg[%0d].cq_hpa=0x%0x",inst_suffix, cq, cq, dir_pp_cq_cfg[cq].cq_gpa, dir_pp_cq_cfg[cq].cq_pagesize.name(), dir_pp_cq_cfg[cq].cq_enable, cq, dir_pp_cq_cfg[cq].cq_hpa),UVM_LOW)
    if (dir_pp_cq_cfg[cq].cq_enable && ( ((address[63:12] == dir_pp_cq_cfg[cq].cq_gpa[63:12]) && dir_pp_cq_cfg[cq].cq_pagesize==HqmAtsPkg::PAGE_SIZE_4K) || ((address[63:21] == dir_pp_cq_cfg[cq].cq_gpa[63:21]) && dir_pp_cq_cfg[cq].cq_pagesize==HqmAtsPkg::PAGE_SIZE_2M) )  ) begin
       
      cq_num = cq;
      cq_type = 1'b0;
      is_pf     = dir_pp_cq_cfg[cq].is_pf;
      vf_num    = dir_pp_cq_cfg[cq].vf;
      if (!is_pf) begin
        for (int i = 0 ; i < hqm_pkg::NUM_DIR_PP ; i++) begin
          if ((vf_cfg[vf_num].dir_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].dir_vpp_cfg[i].vpp_v) begin
            vcq_num = i;
            return(1);
          end 
        end 

        if (vcq_num < 0) begin
          return(0);
        end 
      end 

      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_ats_request:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_gpa=0x%0x cq_pagesize=%0s; decode output: cq=%0d is_pf=%0d vf_num=%0d vcq_num=%0d",inst_suffix, cq, cq, dir_pp_cq_cfg[cq].cq_gpa, dir_pp_cq_cfg[cq].cq_pagesize.name(), cq_num, is_pf, vf_num, vcq_num),UVM_LOW)
      return(1);
    end 
  end 

  foreach (ldb_pp_cq_cfg[cq]) begin
    `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_ats_request:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_gpa=0x%0x cq_pagesize=%0s cq_enable=%0d; ldb_pp_cq_cfg[%0d].cq_hpa=0x%0x",inst_suffix, cq, cq, ldb_pp_cq_cfg[cq].cq_gpa, ldb_pp_cq_cfg[cq].cq_pagesize.name(), ldb_pp_cq_cfg[cq].cq_enable, cq, ldb_pp_cq_cfg[cq].cq_hpa),UVM_LOW)

    if (ldb_pp_cq_cfg[cq].cq_enable && ( ((address[63:12] == ldb_pp_cq_cfg[cq].cq_gpa[63:12]) && ldb_pp_cq_cfg[cq].cq_pagesize==HqmAtsPkg::PAGE_SIZE_4K) || ((address[63:21] == ldb_pp_cq_cfg[cq].cq_gpa[63:21]) && ldb_pp_cq_cfg[cq].cq_pagesize==HqmAtsPkg::PAGE_SIZE_2M) )  ) begin
      cq_num = cq;
      cq_type = 1'b1;
      is_pf     = ldb_pp_cq_cfg[cq].is_pf;
      vf_num    = ldb_pp_cq_cfg[cq].vf;
      if (!is_pf) begin
        for (int i = 0 ; i < hqm_pkg::NUM_LDB_PP ; i++) begin
          if ((vf_cfg[vf_num].ldb_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].ldb_vpp_cfg[i].vpp_v) begin
            vcq_num = i;
            return(1);
          end 
        end 

        if (vcq_num < 0) begin
          return(0);
        end 
      end 

      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_ats_request:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_gpa=0x%0x cq_pagesize=%0s; decode output: cq=%0d is_pf=%0d vf_num=%0d vcq_num=%0d ",inst_suffix, cq, cq, ldb_pp_cq_cfg[cq].cq_gpa, ldb_pp_cq_cfg[cq].cq_pagesize.name(), cq_num, is_pf, vf_num, vcq_num),UVM_LOW)
      return(1);
    end 
  end 

  return(0);
endfunction:decode_cq_ats_request



//----------------------------------------------------------------------------
//-- decode_cq_ats_response
//--   - return cq_num and cq_type if ATS responde address is a valid physical address setup in iommu (programmed and update to cq_hpa)
//--   - return value of 1 if valid consumer queue address, 0 otherwise
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_cq_ats_response(input logic [63:0] address, input logic [15:0] reqid, input HqmAtsPkg::PageSize_t pagesize, output int cq_num,output int cq_type,output bit is_pf, output int vf_num, output int vcq_num);
  int           cq;
  int           vdev;

  // default values (not a pp address)
  cq_num        = -1;
  cq_type       = -1;
  is_pf         = 1'b0;
  vf_num        = -1;
  vcq_num       = -1;


  `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_ats_response:: start with ATS Responded translation_addr=0x%0x pagesize=%0d", inst_suffix, address, pagesize.name()),UVM_LOW)

  foreach (dir_pp_cq_cfg[cq]) begin
    `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_ats_response:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_gpa=0x%0x cq_enable=%0d; dir_pp_cq_cfg[%0d].cq_hpa=0x%0x",inst_suffix, cq, cq, dir_pp_cq_cfg[cq].cq_gpa, dir_pp_cq_cfg[cq].cq_enable, cq, dir_pp_cq_cfg[cq].cq_hpa),UVM_LOW)

    if (dir_pp_cq_cfg[cq].cq_enable && ( (address[63:12] == dir_pp_cq_cfg[cq].cq_hpa[63:12] && pagesize==HqmAtsPkg::PAGE_SIZE_4K) || (address[63:21] == dir_pp_cq_cfg[cq].cq_hpa[63:21] && pagesize==HqmAtsPkg::PAGE_SIZE_2M) || (address[63:29] == dir_pp_cq_cfg[cq].cq_hpa[63:29] && pagesize==HqmAtsPkg::PAGE_SIZE_1G) )) begin
      cq_num = cq;
      cq_type = 1'b0;
      is_pf     = dir_pp_cq_cfg[cq].is_pf;
      vf_num    = dir_pp_cq_cfg[cq].vf;
      if (!is_pf) begin
        for (int i = 0 ; i < hqm_pkg::NUM_DIR_PP ; i++) begin
          if ((vf_cfg[vf_num].dir_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].dir_vpp_cfg[i].vpp_v) begin
            vcq_num = i;
            return(1);
          end 
        end 

        if (vcq_num < 0) begin
          return(0);
        end 
      end 

      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_ats_response:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_hpa=0x%0x; decode output: cq=%0d is_pf=%0d vf_num=%0d vcq_num=%0d",inst_suffix, cq, cq, dir_pp_cq_cfg[cq].cq_hpa, cq_num, is_pf, vf_num, vcq_num),UVM_LOW)
      return(1);
    end 
  end 

  foreach (ldb_pp_cq_cfg[cq]) begin
    `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_ats_response:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_gpa=0x%0x cq_enable=%0d; ldb_pp_cq_cfg[%0d].cq_hpa=0x%0x",inst_suffix, cq, cq, ldb_pp_cq_cfg[cq].cq_gpa, ldb_pp_cq_cfg[cq].cq_enable, cq, ldb_pp_cq_cfg[cq].cq_hpa),UVM_LOW)

    if (ldb_pp_cq_cfg[cq].cq_enable && ( (address[63:12] == ldb_pp_cq_cfg[cq].cq_hpa[63:12] && pagesize==HqmAtsPkg::PAGE_SIZE_4K) || (address[63:21] == ldb_pp_cq_cfg[cq].cq_hpa[63:21] && pagesize==HqmAtsPkg::PAGE_SIZE_2M) || (address[63:29] == ldb_pp_cq_cfg[cq].cq_hpa[63:29] && pagesize==HqmAtsPkg::PAGE_SIZE_1G) )) begin
      cq_num = cq;
      cq_type = 1'b1;
      is_pf     = ldb_pp_cq_cfg[cq].is_pf;
      vf_num    = ldb_pp_cq_cfg[cq].vf;
      if (!is_pf) begin
        for (int i = 0 ; i < hqm_pkg::NUM_LDB_PP ; i++) begin
          if ((vf_cfg[vf_num].ldb_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].ldb_vpp_cfg[i].vpp_v) begin
            vcq_num = i;
            return(1);
          end 
        end 

        if (vcq_num < 0) begin
          return(0);
        end 
      end 

      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_ats_response:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_hpa=0x%0x; decode output: cq=%0d is_pf=%0d vf_num=%0d vcq_num=%0d ",inst_suffix, cq, cq, ldb_pp_cq_cfg[cq].cq_hpa, cq_num, is_pf, vf_num, vcq_num),UVM_LOW)
      return(1);
    end 
  end 

  return(0);
endfunction:decode_cq_ats_response

//------------------------------------------------------------------------
//-- mark cq_ats_req_issued=1 upon ATS request
//------------------------------------------------------------------------
function  hqm_cfg::set_ats_request_txn_id(input int is_ldb, input int cq_num,input HqmTxnID_t cq_txnid);
    HqmBusTxn       atsreq_hqmbustxn;

    atsreq_hqmbustxn = HqmBusTxn::type_id::create("atsreq_hqmbustxn");
    atsreq_hqmbustxn.randomize();
    atsreq_hqmbustxn.is_ldb = is_ldb;
    atsreq_hqmbustxn.cq_num = cq_num;
    atsreq_hqmbustxn.txn_id = cq_txnid;
    ats_txnid_cq_queues.push_back(atsreq_hqmbustxn);
      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__set_ats_request_txn_id:: is_ldb=%0d cq_num=%0d cq_txnid=0x%0x => atsreq_hqmbustxn.is_ldb=%0d atsreq_hqmbustxn.cq_num=%0d atsreq_hqmbustxn.txn_id=0x%0d added to ats_txnid_cq_queues.size=%0d ",inst_suffix, is_ldb, cq_num, cq_txnid, atsreq_hqmbustxn.is_ldb, atsreq_hqmbustxn.cq_num, atsreq_hqmbustxn.txn_id, ats_txnid_cq_queues.size()),UVM_LOW)


    if(is_ldb) begin
        ldb_pp_cq_cfg[cq_num].cq_txn_id = cq_txnid;
        ldb_pp_cq_cfg[cq_num].cq_ats_req_issued ++;
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__set_ats_request_txn_id:: ldb_pp_cq_cfg[%0d].cq_txn_id=0x%0x cq_ats_req_issued=%0d cq_ats_resp_returned=%0d ",inst_suffix, cq_num, ldb_pp_cq_cfg[cq_num].cq_txn_id, ldb_pp_cq_cfg[cq_num].cq_ats_req_issued, ldb_pp_cq_cfg[cq_num].cq_ats_resp_returned),UVM_LOW)
    end else begin
        dir_pp_cq_cfg[cq_num].cq_txn_id = cq_txnid;
        dir_pp_cq_cfg[cq_num].cq_ats_req_issued ++;
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__set_ats_request_txn_id:: dir_pp_cq_cfg[%0d].cq_txn_id=0x%0x cq_ats_req_issued=%0d cq_ats_resp_returned=%0d ",inst_suffix, cq_num, dir_pp_cq_cfg[cq_num].cq_txn_id, dir_pp_cq_cfg[cq_num].cq_ats_req_issued, dir_pp_cq_cfg[cq_num].cq_ats_resp_returned),UVM_LOW)
    end 
endfunction:set_ats_request_txn_id

//----------------------------------------------------------------------------
//-- decode_cq_by_ats_response_txnid
//--   - return cq_num and cq_type if ATS responde txnid can be found from ldb_pp_cq_cfg[].cq_txn_id or dir_pp_cq_cfg[].cq_txn_id
//--   - return value of 1 if valid consumer queue address, 0 otherwise
//--
//--  each dir_pp_cq_cfg[cq] and ldb_pp_cq_cfg[cq] keeps tracking the status of if ATS request issued and ATS response returned 
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_cq_by_ats_response_txnid(input HqmTxnID_t txnid, output int cq_num, output int cq_type, output bit is_pf, output int vf_num, output int vcq_num);
  int           cq;
  int           vdev;
  int           idx_l[$];
  HqmBusTxn       atsresp_hqmbustxn;

  // default values (not a pp address)
  cq_num        = -1;
  cq_type       = -1;
  is_pf         = 1'b0;
  vf_num        = -1;
  vcq_num       = -1;


  `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_ats_response_txnid:: start with ATS Responded translation_txnid=0x%0x ats_txnid_cq_queues.size=%0d", inst_suffix, txnid, ats_txnid_cq_queues.size()),UVM_LOW)
  idx_l = ats_txnid_cq_queues.find_first_index with (item.txn_id == txnid);

  if (idx_l.size() == 0) begin
     `uvm_error(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_ats_response_txnid:: not found translation_txnid=0x%0x from ats_txnid_cq_queues.size=%0d", inst_suffix, txnid, ats_txnid_cq_queues.size()))
      return(0);
  end else begin
      atsresp_hqmbustxn = ats_txnid_cq_queues[idx_l[0]];

      cq_type = atsresp_hqmbustxn.is_ldb;
      cq_num  = atsresp_hqmbustxn.cq_num;
     `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_ats_response_txnid:: found translation_txnid=0x%0x from %0d of ats_txnid_cq_queues.size=%0d => cq_type=%0d cq_num=%0d", inst_suffix, txnid, idx_l[0], ats_txnid_cq_queues.size(), cq_type, cq_num), UVM_LOW)
      if(cq_type) begin
         is_pf     = ldb_pp_cq_cfg[cq_num].is_pf;
         vf_num    = ldb_pp_cq_cfg[cq_num].vf;
         if (!is_pf) begin
            for (int i = 0 ; i < hqm_pkg::NUM_LDB_PP ; i++) begin
               if ((vf_cfg[vf_num].ldb_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].ldb_vpp_cfg[i].vpp_v) begin
                 vcq_num = i;
                 //return(1);
               end 
            end 

            if (vcq_num < 0) begin
                ats_txnid_cq_queues.delete(idx_l[0]);
                return(0);
            end 
         end //--if(!is_pf

         ldb_pp_cq_cfg[cq_num].cq_ats_resp_returned ++; 
         `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_ats_response_txnid:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_txn_id=0x%0x cq_ats_req_issued=%0d cq_ats_resp_returned=%0d; decode output: cq=%0d is_pf=%0d vf_num=%0d vcq_num=%0d ",inst_suffix, cq_num, cq_num, ldb_pp_cq_cfg[cq_num].cq_txn_id, ldb_pp_cq_cfg[cq_num].cq_ats_req_issued, ldb_pp_cq_cfg[cq_num].cq_ats_resp_returned, cq_num, is_pf, vf_num, vcq_num),UVM_LOW)

      end else begin
         is_pf     = dir_pp_cq_cfg[cq_num].is_pf;
         vf_num    = dir_pp_cq_cfg[cq_num].vf;
         if (!is_pf) begin
            for (int i = 0 ; i < hqm_pkg::NUM_DIR_PP ; i++) begin
              if ((vf_cfg[vf_num].dir_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].dir_vpp_cfg[i].vpp_v) begin
                 vcq_num = i;
                 //return(1);
              end 
            end 

            if (vcq_num < 0) begin
                ats_txnid_cq_queues.delete(idx_l[0]);
                return(0);
            end 
         end //if (!is_pf

         dir_pp_cq_cfg[cq_num].cq_ats_resp_returned ++; 
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_ats_response_txnid:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_txn_id=0x%0x cq_ats_req_issued=%0d cq_ats_resp_returned=%0d; decode output: cq=%0d is_pf=%0d vf_num=%0d vcq_num=%0d",inst_suffix, cq_num, cq_num, dir_pp_cq_cfg[cq_num].cq_txn_id, dir_pp_cq_cfg[cq_num].cq_ats_req_issued, dir_pp_cq_cfg[cq_num].cq_ats_resp_returned, cq_num, is_pf, vf_num, vcq_num),UVM_LOW)

      end //--if(cq_type)

      //--remove 
      ats_txnid_cq_queues.delete(idx_l[0]);
      return(1);
  end //if (idx_l.size() == 0) 

 /*---- 
  foreach (dir_pp_cq_cfg[cq]) begin
    `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_ats_response_txnid:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_txn_id=0x%0x; cq_gpa=0x%0x cq_hpa=0x%0x cq_enable=%0d cq_ats_req_issued=%0d cq_ats_resp_returned=%0d",inst_suffix, cq, cq, dir_pp_cq_cfg[cq].cq_txn_id, dir_pp_cq_cfg[cq].cq_gpa, dir_pp_cq_cfg[cq].cq_hpa, dir_pp_cq_cfg[cq].cq_enable, dir_pp_cq_cfg[cq].cq_ats_req_issued, dir_pp_cq_cfg[cq].cq_ats_resp_returned),UVM_HIGH)

    //if (dir_pp_cq_cfg[cq].cq_enable && txnid == dir_pp_cq_cfg[cq].cq_txn_id && dir_pp_cq_cfg[cq].cq_ats_req_issued==1 && dir_pp_cq_cfg[cq].cq_ats_resp_returned==0) begin
    if (dir_pp_cq_cfg[cq].cq_enable && txnid == dir_pp_cq_cfg[cq].cq_txn_id && dir_pp_cq_cfg[cq].cq_ats_req_issued > dir_pp_cq_cfg[cq].cq_ats_resp_returned) begin
      cq_num = cq;
      cq_type = 1'b0;
      is_pf     = dir_pp_cq_cfg[cq].is_pf;
      vf_num    = dir_pp_cq_cfg[cq].vf;
      if (!is_pf) begin
        for (int i = 0 ; i < hqm_pkg::NUM_DIR_PP ; i++) begin
          if ((vf_cfg[vf_num].dir_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].dir_vpp_cfg[i].vpp_v) begin
            vcq_num = i;
            return(1);
          end 
        end 

        if (vcq_num < 0) begin
          return(0);
        end 
      end 

      dir_pp_cq_cfg[cq].cq_ats_resp_returned ++; 
      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_ats_response_txnid:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_txn_id=0x%0x cq_ats_req_issued=%0d cq_ats_resp_returned=%0d; decode output: cq=%0d is_pf=%0d vf_num=%0d vcq_num=%0d",inst_suffix, cq, cq, dir_pp_cq_cfg[cq].cq_txn_id, dir_pp_cq_cfg[cq].cq_ats_req_issued, dir_pp_cq_cfg[cq].cq_ats_resp_returned, cq_num, is_pf, vf_num, vcq_num),UVM_LOW)
      return(1);
    end 
  end 

  foreach (ldb_pp_cq_cfg[cq]) begin
    `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_ats_response_txnid:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_txn_id=0x%0x; cq_gpa=0x%0x cq_hpa=0x%0x cq_enable=%0d cq_ats_req_issued=%0d cq_ats_resp_returned=%0d",inst_suffix, cq, cq, ldb_pp_cq_cfg[cq].cq_txn_id, ldb_pp_cq_cfg[cq].cq_gpa, ldb_pp_cq_cfg[cq].cq_hpa, ldb_pp_cq_cfg[cq].cq_enable, ldb_pp_cq_cfg[cq].cq_ats_req_issued, ldb_pp_cq_cfg[cq].cq_ats_resp_returned),UVM_HIGH)

    //if (ldb_pp_cq_cfg[cq].cq_enable && txnid == ldb_pp_cq_cfg[cq].cq_txn_id && ldb_pp_cq_cfg[cq].cq_ats_req_issued==1 && ldb_pp_cq_cfg[cq].cq_ats_resp_returned==0) begin
    if (ldb_pp_cq_cfg[cq].cq_enable && txnid == ldb_pp_cq_cfg[cq].cq_txn_id && (ldb_pp_cq_cfg[cq].cq_ats_req_issued > ldb_pp_cq_cfg[cq].cq_ats_resp_returned)) begin
      cq_num = cq;
      cq_type = 1'b1;
      is_pf     = ldb_pp_cq_cfg[cq].is_pf;
      vf_num    = ldb_pp_cq_cfg[cq].vf;
      if (!is_pf) begin
        for (int i = 0 ; i < hqm_pkg::NUM_LDB_PP ; i++) begin
          if ((vf_cfg[vf_num].ldb_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].ldb_vpp_cfg[i].vpp_v) begin
            vcq_num = i;
            return(1);
          end 
        end 

        if (vcq_num < 0) begin
          return(0);
        end 
      end 

      ldb_pp_cq_cfg[cq].cq_ats_resp_returned ++; 
      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_ats_response_txnid:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_txn_id=0x%0x cq_ats_req_issued=%0d cq_ats_resp_returned=%0d; decode output: cq=%0d is_pf=%0d vf_num=%0d vcq_num=%0d ",inst_suffix, cq, cq, ldb_pp_cq_cfg[cq].cq_txn_id, ldb_pp_cq_cfg[cq].cq_ats_req_issued, ldb_pp_cq_cfg[cq].cq_ats_resp_returned, cq_num, is_pf, vf_num, vcq_num),UVM_LOW)
      return(1);
    end 
  end 
 ---*/ 


endfunction:decode_cq_by_ats_response_txnid






//------------------------------------------------------------------------
function hqm_cfg::update_hpa_by_ats_response(input int is_ldb, input int cq_num, input HqmPcieCplStatus_t completion_status, input logic [63:0] cq_hpa_addr, input HqmAtsPkg::PageSize_t pagesize);
    if(is_ldb) begin
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__update_hpa_by_ats_response:: LDBCQ_HPA_GPA_Settings_Prev - ldb_pp_cq_cfg[%0d].cq_hpa=0x%0x cq_ats_resp_status=%0s cq_pagesize=%0s; ldb_pp_cq_cfg[%0d].cq_gpa=0x%0x",inst_suffix, cq_num, ldb_pp_cq_cfg[cq_num].cq_hpa, ldb_pp_cq_cfg[cq_num].cq_ats_resp_status.name(), ldb_pp_cq_cfg[cq_num].cq_pagesize.name(), cq_num, ldb_pp_cq_cfg[cq_num].cq_gpa),UVM_LOW)
        ldb_pp_cq_cfg[cq_num].cq_hpa = cq_hpa_addr;
        ldb_pp_cq_cfg[cq_num].cq_pagesize = pagesize;
        ldb_pp_cq_cfg[cq_num].cq_ats_resp_status = completion_status;
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__update_hpa_by_ats_response:: LDBCQ_HPA_GPA_Update - ldb_pp_cq_cfg[%0d].cq_hpa=0x%0x cq_ats_resp_status=%0s cq_pagesize=%0s; ldb_pp_cq_cfg[%0d].cq_gpa=0x%0x",inst_suffix, cq_num, ldb_pp_cq_cfg[cq_num].cq_hpa, ldb_pp_cq_cfg[cq_num].cq_ats_resp_status.name(), ldb_pp_cq_cfg[cq_num].cq_pagesize.name(), cq_num, ldb_pp_cq_cfg[cq_num].cq_gpa),UVM_LOW)
    end else begin
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__update_hpa_by_ats_response:: DIRCQ_HPA_GPA_Settings_Prev - dir_pp_cq_cfg[%0d].cq_hpa=0x%0x cq_ats_resp_status=%0s cq_pagesize=%0s; dir_pp_cq_cfg[%0d].cq_gpa=0x%0x",inst_suffix, cq_num, dir_pp_cq_cfg[cq_num].cq_hpa, dir_pp_cq_cfg[cq_num].cq_ats_resp_status.name(), dir_pp_cq_cfg[cq_num].cq_pagesize.name(), cq_num, dir_pp_cq_cfg[cq_num].cq_gpa),UVM_LOW)
        dir_pp_cq_cfg[cq_num].cq_hpa = cq_hpa_addr;
        dir_pp_cq_cfg[cq_num].cq_pagesize = pagesize;
        dir_pp_cq_cfg[cq_num].cq_ats_resp_status = completion_status;
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__update_hpa_by_ats_response:: DIRCQ_HPA_GPA_Update - dir_pp_cq_cfg[%0d].cq_hpa=0x%0x cq_ats_resp_status=%0s cq_pagesize=%0s; dir_pp_cq_cfg[%0d].cq_gpa=0x%0x",inst_suffix, cq_num, dir_pp_cq_cfg[cq_num].cq_hpa, dir_pp_cq_cfg[cq_num].cq_ats_resp_status.name(), dir_pp_cq_cfg[cq_num].cq_pagesize.name(), cq_num, dir_pp_cq_cfg[cq_num].cq_gpa),UVM_LOW)
    end 
endfunction:update_hpa_by_ats_response

//------------------------------------------------------------------------
function bit[63:0] hqm_cfg::get_cq_hpa(input int is_ldb, input int cq_num);
   if(is_ldb) begin
     get_cq_hpa = ldb_pp_cq_cfg[cq_num].cq_hpa;
    `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__get_cq_hpa:: get ldb_pp_cq_cfg[%0d].cq_hpa=0x%0x with cq_pagesize=%0s ldb_pp_cq_cfg[%0d].cq_gpa=0x%0x",inst_suffix, cq_num, ldb_pp_cq_cfg[cq_num].cq_hpa, ldb_pp_cq_cfg[cq_num].cq_pagesize.name(), cq_num, ldb_pp_cq_cfg[cq_num].cq_gpa),UVM_LOW)
   end else begin
     get_cq_hpa = dir_pp_cq_cfg[cq_num].cq_hpa;
    `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__get_cq_hpa:: get dir_pp_cq_cfg[%0d].cq_hpa=0x%0x with cq_pagesize=%0s dir_pp_cq_cfg[%0d].cq_gpa=0x%0x",inst_suffix, cq_num, dir_pp_cq_cfg[cq_num].cq_hpa, dir_pp_cq_cfg[cq_num].cq_pagesize.name(), cq_num, dir_pp_cq_cfg[cq_num].cq_gpa),UVM_LOW)
   end 
endfunction:get_cq_hpa

//------------------------------------------------------------------------
//-- TBA: Enhance to support virtual_addr -> physical address 
//------------------------------------------------------------------------
function bit[63:0] hqm_cfg::get_hpa_from_gpa(input int is_ldb, input int cq_num, input logic [63:0] cq_virt_addr);
   if(is_ldb) begin
     get_hpa_from_gpa = ldb_pp_cq_cfg[cq_num].cq_hpa;
    `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__get_hpa_from_gpa:: cq_virt_addr=0x%0x, get ldb_pp_cq_cfg[%0d].cq_hpa=0x%0x cq_pagesize=%0s; ldb_pp_cq_cfg[%0d].cq_gpa=0x%0x",inst_suffix, cq_virt_addr, cq_num, ldb_pp_cq_cfg[cq_num].cq_hpa, ldb_pp_cq_cfg[cq_num].cq_pagesize.name(), cq_num, ldb_pp_cq_cfg[cq_num].cq_gpa),UVM_LOW)
   end else begin
     get_hpa_from_gpa = dir_pp_cq_cfg[cq_num].cq_hpa;
    `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__get_hpa_from_gpa:: cq_virt_addr=0x%0x, get dir_pp_cq_cfg[%0d].cq_hpa=0x%0x cq_pagesize=%0s; dir_pp_cq_cfg[%0d].cq_gpa=0x%0x",inst_suffix, cq_virt_addr, cq_num, dir_pp_cq_cfg[cq_num].cq_hpa, dir_pp_cq_cfg[cq_num].cq_pagesize.name(), cq_num, dir_pp_cq_cfg[cq_num].cq_gpa),UVM_LOW)
   end 
endfunction:get_hpa_from_gpa






//------------------------------------------------------------------------ ATS_INV_REQ
//------------------------------------------------------------------------
//-- mark cq_ats_req_issued=1 upon ATS INV_REQ 
//------------------------------------------------------------------------
function  hqm_cfg::set_atsinvreq_txn_id(input int is_ldb, input int cq_num,input HqmTxnID_t cq_txnid);
    HqmBusTxn       atsinvreq_hqmbustxn;

    atsinvreq_hqmbustxn = HqmBusTxn::type_id::create("atsinvreq_hqmbustxn");
    atsinvreq_hqmbustxn.randomize();
    atsinvreq_hqmbustxn.is_ldb = is_ldb;
    atsinvreq_hqmbustxn.cq_num = cq_num;
    atsinvreq_hqmbustxn.txn_id = cq_txnid;
    atsinvreq_txnid_cq_queues.push_back(atsinvreq_hqmbustxn);

      `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__set_atsinvreq_txn_id:: is_ldb=%0d cq_num=%0d cq_txnid=0x%0x ITAG=0x%0x => atsinvreq_hqmbustxn.is_ldb=%0d atsinvreq_hqmbustxn.cq_num=%0d atsinvreq_hqmbustxn.txn_id=0x%0d added to atsinvreq_txnid_cq_queues.size=%0d ",inst_suffix, is_ldb, cq_num, cq_txnid, cq_txnid[20:16], atsinvreq_hqmbustxn.is_ldb, atsinvreq_hqmbustxn.cq_num, atsinvreq_hqmbustxn.txn_id, atsinvreq_txnid_cq_queues.size()),UVM_LOW)

    if(is_ldb) begin
        ldb_pp_cq_cfg[cq_num].cq_atsinvreq_txn_id = cq_txnid; //ITAG
        ldb_pp_cq_cfg[cq_num].cq_atsinvreq_issued ++;
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__set_atsinvreq_txn_id:: ldb_pp_cq_cfg[%0d].cq_atsinvreq_txn_id=0x%0x cq_atsinvreq_issued=%0d cq_atsinvresp_returned=%0d ",inst_suffix, cq_num, ldb_pp_cq_cfg[cq_num].cq_atsinvreq_txn_id, ldb_pp_cq_cfg[cq_num].cq_atsinvreq_issued, ldb_pp_cq_cfg[cq_num].cq_atsinvresp_returned),UVM_LOW)
    end else begin
        dir_pp_cq_cfg[cq_num].cq_atsinvreq_txn_id = cq_txnid; //ITAG
        dir_pp_cq_cfg[cq_num].cq_atsinvreq_issued ++;
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__set_atsinvreq_txn_id:: dir_pp_cq_cfg[%0d].cq_atsinvreq_txn_id=0x%0x cq_atsinvreq_issued=%0d cq_atsinvresp_returned=%0d ",inst_suffix, cq_num, dir_pp_cq_cfg[cq_num].cq_atsinvreq_txn_id, dir_pp_cq_cfg[cq_num].cq_atsinvreq_issued, dir_pp_cq_cfg[cq_num].cq_atsinvresp_returned),UVM_LOW)
    end 
endfunction:set_atsinvreq_txn_id



//---------------------------------------------------------------------------- ATS_INV_RESP
//----------------------------------------------------------------------------
//-- decode_cq_by_atsinvresp_txn_id
//--   - return cq_num and cq_type if ATS INV_RESP txnid can be found from ldb_pp_cq_cfg[].cq_atsinvreq_txn_id or dir_pp_cq_cfg[].cq_atsinvreq_txn_id
//--   - return value of 1 if valid consumer queue address, 0 otherwise
//--
//--  each dir_pp_cq_cfg[cq] and ldb_pp_cq_cfg[cq] keeps tracking the status of if ATS INV_REQ issued and ATS INV_RESP returned 
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_cq_by_atsinvresp_txn_id(input HqmTxnID_t txnid, int clear_queue, output int cq_num, output int cq_type, output bit is_pf, output int vf_num, output int vcq_num);
  int           cq;
  int           vdev;
  int           idx_l[$];
  HqmBusTxn     atsinvresp_hqmbustxn;

  // default values (not a pp address)
  cq_num        = -1;
  cq_type       = -1;
  is_pf         = 1'b0;
  vf_num        = -1;
  vcq_num       = -1;


  `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_atsinvresp_txn_id:: start with ATS INV_RESP txnid=0x%0x ITAG=0x%0x clear_queue=%0d atsinvreq_txnid_cq_queues.size=%0d", inst_suffix, txnid, txnid[20:16], clear_queue, atsinvreq_txnid_cq_queues.size()),UVM_LOW)
  idx_l = atsinvreq_txnid_cq_queues.find_first_index with (item.txn_id == txnid);

  if (idx_l.size() == 0) begin
     `uvm_error(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_atsinvresp_txn_id:: not found ATS INV_RESP txnid=0x%0x ITAG=0x%0x from atsinvreq_txnid_cq_queues.size=%0d", inst_suffix, txnid, txnid[20:16], atsinvreq_txnid_cq_queues.size()))
      return(0);
  end else begin
      atsinvresp_hqmbustxn = atsinvreq_txnid_cq_queues[idx_l[0]];

      cq_type = atsinvresp_hqmbustxn.is_ldb;
      cq_num  = atsinvresp_hqmbustxn.cq_num;
     `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_atsinvresp_txn_id:: found ATS INV_RESP txnid=0x%0x ITAG=0x%0x from %0d of atsinvreq_txnid_cq_queues.size=%0d => cq_type=%0d cq_num=%0d", inst_suffix, txnid, txnid[20:16], idx_l[0], atsinvreq_txnid_cq_queues.size(), cq_type, cq_num), UVM_LOW)

      if(cq_type) begin
         is_pf     = ldb_pp_cq_cfg[cq_num].is_pf;
         vf_num    = ldb_pp_cq_cfg[cq_num].vf;
         if (!is_pf) begin
            for (int i = 0 ; i < hqm_pkg::NUM_LDB_PP ; i++) begin
               if ((vf_cfg[vf_num].ldb_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].ldb_vpp_cfg[i].vpp_v) begin
                 vcq_num = i;
                 //return(1);
               end 
            end 

            if (vcq_num < 0) begin
                atsinvreq_txnid_cq_queues.delete(idx_l[0]);
                return(0);
            end 
         end //--if(!is_pf

         ldb_pp_cq_cfg[cq_num].cq_atsinvresp_returned ++; 
         `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_atsinvresp_txn_id:: ldb_cq=%0d ldb_pp_cq_cfg[%0d].cq_atsinvreq_txn_id=0x%0x cq_atsinvreq_issued=%0d cq_atsinvresp_returned=%0d; decode output: cq=%0d is_pf=%0d vf_num=%0d vcq_num=%0d ",inst_suffix, cq_num, cq_num, ldb_pp_cq_cfg[cq_num].cq_atsinvreq_txn_id, ldb_pp_cq_cfg[cq_num].cq_atsinvreq_issued, ldb_pp_cq_cfg[cq_num].cq_atsinvresp_returned, cq_num, is_pf, vf_num, vcq_num),UVM_LOW)

      end else begin
         is_pf     = dir_pp_cq_cfg[cq_num].is_pf;
         vf_num    = dir_pp_cq_cfg[cq_num].vf;
         if (!is_pf) begin
            for (int i = 0 ; i < hqm_pkg::NUM_DIR_PP ; i++) begin
              if ((vf_cfg[vf_num].dir_vpp_cfg[i].pp == cq_num) && vf_cfg[vf_num].dir_vpp_cfg[i].vpp_v) begin
                 vcq_num = i;
                 //return(1);
              end 
            end 

            if (vcq_num < 0) begin
                atsinvreq_txnid_cq_queues.delete(idx_l[0]);
                return(0);
            end 
         end //if (!is_pf

         dir_pp_cq_cfg[cq_num].cq_atsinvresp_returned ++; 
        `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_atsinvresp_txn_id:: dir_cq=%0d dir_pp_cq_cfg[%0d].cq_atsinvreq_txn_id=0x%0x cq_atsinvreq_issued=%0d cq_atsinvresp_returned=%0d; decode output: cq=%0d is_pf=%0d vf_num=%0d vcq_num=%0d",inst_suffix, cq_num, cq_num, dir_pp_cq_cfg[cq_num].cq_atsinvreq_txn_id, dir_pp_cq_cfg[cq_num].cq_atsinvreq_issued, dir_pp_cq_cfg[cq_num].cq_atsinvresp_returned, cq_num, is_pf, vf_num, vcq_num),UVM_LOW)

      end //--if(cq_type)

      //--remove?? RTL has multiple INV_CPL (8 TC) 
      if(clear_queue==1) begin 
        atsinvreq_txnid_cq_queues.delete(idx_l[0]);
        hqm_atsinvcpl_done = 1;
       `uvm_info(get_full_name(), $psprintf("HQMDBG%0s__decode_cq_by_atsinvresp_txn_id:: Done clear_queue=%0d atsinvreq_txnid_cq_queues.size=%0d - mark hqm_atsinvcpl_done=%0d", inst_suffix, clear_queue, atsinvreq_txnid_cq_queues.size(), hqm_atsinvcpl_done),UVM_LOW)
      end 

      return(1);
  end //if (idx_l.size() == 0) 

endfunction:decode_cq_by_atsinvresp_txn_id



//------------------------------------------------------------------------
//------------------------------------------------------------------------
function void hqm_cfg::update_msix_cfg();
  uvm_reg    my_reg;
  uvm_reg_field  my_field;
  uvm_reg_data_t ral_data; 

  if (!msix_fields_valid) begin
    `uvm_info(get_full_name(), $psprintf("HQM%0s__getting msix fields",inst_suffix),UVM_LOW)
    msix_fields_valid   = 1'b1;

    msixen_field        = hqm_find_field_by_name( "msixen", "msix_cap_control", {tb_env_hier, ".", "hqm_pf_cfg_i"} );
    msix_mode_field     = hqm_find_field_by_name( "mode", "msix_mode", {tb_env_hier, ".", "hqm_system_csr"} );

    foreach (msix_cfg[i]) begin
      vec_mask_field[i] = hqm_find_field_by_name( "vec_mask", $psprintf("vector_ctrl[%0d]",i), {tb_env_hier, ".", "hqm_msix_mem"} );
      msg_addr_l[i]     = hqm_find_field_by_name( "msg_addr_l", $psprintf("msg_addr_l[%0d]",i), {tb_env_hier, ".", "hqm_msix_mem"} );
      msg_addr_u[i]     = hqm_find_field_by_name( "msg_addr_u", $psprintf("msg_addr_u[%0d]",i), {tb_env_hier, ".", "hqm_msix_mem"} );
      msg_data[i]       = hqm_find_field_by_name( "msg_data", $psprintf("msg_data[%0d]",i), {tb_env_hier, ".", "hqm_msix_mem"} );
    end 
  end 

  ral_data      = msixen_field.get();
  msix_enabled  = ral_data;

  ral_data      = msix_mode_field.get();
  msix_mode     = ral_data;

  foreach (msix_cfg[i]) begin
    ral_data                    = vec_mask_field[i].get();
    msix_cfg[i].enable          = ~ral_data[0];

    ral_data                    = msg_addr_l[i].get();
    msix_cfg[i].addr[31:2]      = ral_data;

    ral_data                    = msg_addr_u[i].get();
    msix_cfg[i].addr[63:32]     = ral_data;

    ral_data                    = msg_data[i].get();
    msix_cfg[i].data            = ral_data;
  end 
endfunction : update_msix_cfg


//--03192021 
function void hqm_cfg::update_ims_cfg();
  uvm_reg    my_reg;
  uvm_reg_field  my_field;
  uvm_reg_data_t ral_data, ral_data1; 
  uvm_reg_field  vf_val;
  uvm_reg_field  vector_val;
  bit [7:0]      ims_val;

  if (!ims_fields_valid) begin
    `uvm_info(get_full_name(), $psprintf("HQM%0s__update_ims_cfg::getting ism fields",inst_suffix),UVM_MEDIUM)
    ims_fields_valid   = 1'b1;

    foreach (dir_ims_cfg[i]) begin
      dir_en_code_field[i]      = hqm_find_field_by_name( "en_code", $psprintf("dir_cq_isr[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );

      dir_vf_field[i]           = hqm_find_field_by_name( "vf", $psprintf("dir_cq_isr[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );

      dir_vector_field[i]       = hqm_find_field_by_name( "vector", $psprintf("dir_cq_isr[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );
    end 

    foreach (ldb_ims_cfg[i]) begin
      ldb_en_code_field[i]      = hqm_find_field_by_name( "en_code", $psprintf("ldb_cq_isr[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );

      ldb_vf_field[i]           = hqm_find_field_by_name( "vf", $psprintf("ldb_cq_isr[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );

      ldb_vector_field[i]       = hqm_find_field_by_name( "vector", $psprintf("ldb_cq_isr[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );
    end 

    foreach (ims_prog_cfg[i]) begin
      ims_prog_addr_l[i]       = hqm_find_field_by_name( "ims_addr_l", $psprintf("ai_addr_l[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );
      ims_prog_addr_u[i]       = hqm_find_field_by_name( "ims_addr_u", $psprintf("ai_addr_u[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );
      ims_prog_data[i]         = hqm_find_field_by_name( "ims_data", $psprintf("ai_data[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );
      ims_prog_ctrl[i]         = hqm_find_field_by_name( "ims_mask", $psprintf("ai_ctrl[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );
    end 
  end 

  //---------------
  if (!ims_prog_fields_valid) begin
    `uvm_info(get_full_name(), $psprintf("HQM%0s__update_ims_cfg_2::ims_prog_cfg getting ism fields",inst_suffix),UVM_HIGH)
     ims_prog_fields_valid   = 1'b1;
     foreach (ims_prog_cfg[i]) begin
       ral_data                    = ims_prog_addr_l[i].get();
       ims_prog_cfg[i].addr[31:0]  = ral_data << 2;

       ral_data                    = ims_prog_addr_u[i].get();
       ims_prog_cfg[i].addr[63:32] = ral_data;

       ral_data                    = ims_prog_data[i].get();
       ims_prog_cfg[i].data        = ral_data;

       ral_data                    = ims_prog_ctrl[i].get();
       ims_prog_cfg[i].ctrl        = ral_data;

       //--temp for debug
/*---
       if(i<96) begin
          ral_data                    = dir_vf_field[i].get();
          ral_data1                   = dir_vector_field[i].get();
          ims_val                     = {ral_data[1:0], ral_data1[5:0]};
       end else begin
          ral_data                    = ldb_vf_field[i-96].get();
          ral_data1                   = ldb_vector_field[i-96].get();
          ims_val                     = {ral_data[1:0], ral_data1[5:0]};
       end 
---*/
       `uvm_info(get_full_name(), $psprintf("HQM%0s__update_ims_cfg_2::ims_prog_cfg[%0d].addr=0x%0x data=0x%0x ctrl=0x%0x (ral_data1=%0d ral_data=%0d => ims_temp_idx=%0d)",inst_suffix, i, ims_prog_cfg[i].addr, ims_prog_cfg[i].data, ims_prog_cfg[i].ctrl, ral_data1, ral_data, ims_val),UVM_HIGH)
     end 
  end 

  //---------------
  if (!ims_prog_fields_valid_2) begin
    `uvm_info(get_full_name(), $psprintf("HQM%0s__update_ims_cfg_3::dir_ims_cfg report",inst_suffix),UVM_LOW)
     ims_prog_fields_valid_2   = 1'b1;
     foreach (dir_ims_cfg[i]) begin
       ral_data                    = dir_en_code_field[i].get();
       dir_ims_cfg[i].enable       = (ral_data == 3) ? 1'b1 : 1'b0;
   
       ral_data                    = dir_vf_field[i].get();
       ral_data1                   = dir_vector_field[i].get();
       dir_ims_idx_field[i][7:0]   = {ral_data[1:0], ral_data1[5:0]};
       dir_ims_cfg[i].ims_idx      = dir_ims_idx_field[i];
        
       dir_ims_cfg[i].addr         = ims_prog_cfg[dir_ims_cfg[i].ims_idx].addr;
       dir_ims_cfg[i].data         = ims_prog_cfg[dir_ims_cfg[i].ims_idx].data;
       dir_ims_cfg[i].ctrl         = ims_prog_cfg[dir_ims_cfg[i].ims_idx].ctrl;

       if(dir_ims_cfg[i].enable) begin 
           ims_prog_cfg[dir_ims_cfg[i].ims_idx].enable = dir_ims_cfg[i].enable;
           ims_prog_cfg[dir_ims_cfg[i].ims_idx].is_ldb = 0;
           ims_prog_cfg[dir_ims_cfg[i].ims_idx].cq     = i;
        end 
        `uvm_info(get_full_name(), $psprintf("HQM%0s__update_ims_cfg_3::dir_ims_cfg[%0d].enable=%0d ims_idx=%0d addr=0x%0x data=0x%0x ctrl=0x%0x; ims_prog_cfg[%0d].enable=%0d cq=%0d",inst_suffix, i, dir_ims_cfg[i].enable, dir_ims_cfg[i].ims_idx, dir_ims_cfg[i].addr, dir_ims_cfg[i].data, dir_ims_cfg[i].ctrl, dir_ims_cfg[i].ims_idx, ims_prog_cfg[dir_ims_cfg[i].ims_idx].enable, ims_prog_cfg[dir_ims_cfg[i].ims_idx].cq),UVM_HIGH)
     end 
  end 

  //---------------
  if (!ims_prog_fields_valid_3) begin
    `uvm_info(get_full_name(), $psprintf("HQM%0s__update_ims_cfg_3::ldb_ims_cfg report",inst_suffix),UVM_LOW)
     ims_prog_fields_valid_3   = 1'b1;
     foreach (ldb_ims_cfg[i]) begin
       ral_data                    = ldb_en_code_field[i].get();
       ldb_ims_cfg[i].enable       = (ral_data == 3) ? 1'b1 : 1'b0;
   
       ral_data                    = ldb_vf_field[i].get();
       ral_data1                   = ldb_vector_field[i].get();
       ldb_ims_idx_field[i][7:0]   = {ral_data[1:0], ral_data1[5:0]};
       ldb_ims_cfg[i].ims_idx      = ldb_ims_idx_field[i];
   
       ldb_ims_cfg[i].addr         = ims_prog_cfg[ldb_ims_cfg[i].ims_idx].addr;
       ldb_ims_cfg[i].data         = ims_prog_cfg[ldb_ims_cfg[i].ims_idx].data;
       ldb_ims_cfg[i].ctrl         = ims_prog_cfg[ldb_ims_cfg[i].ims_idx].ctrl;

       if(ldb_ims_cfg[i].enable) begin 
          ims_prog_cfg[ldb_ims_cfg[i].ims_idx].enable = ldb_ims_cfg[i].enable;
          ims_prog_cfg[ldb_ims_cfg[i].ims_idx].is_ldb = 1;
          ims_prog_cfg[ldb_ims_cfg[i].ims_idx].cq     = i;
       end 
       `uvm_info(get_full_name(), $psprintf("HQM%0s__update_ims_cfg_3::ldb_ims_cfg[%0d].enable=%0d ims_idx=%0d addr=0x%0x data=0x%0x ctrl=0x%0x; ims_prog_cfg[%0d].enable=%0d cq=%0d",inst_suffix, i, ldb_ims_cfg[i].enable, ldb_ims_cfg[i].ims_idx, ldb_ims_cfg[i].addr, ldb_ims_cfg[i].data, ldb_ims_cfg[i].ctrl, ldb_ims_cfg[i].ims_idx, ims_prog_cfg[ldb_ims_cfg[i].ims_idx].enable, ims_prog_cfg[ldb_ims_cfg[i].ims_idx].cq),UVM_HIGH)
     end 
  end 


  //---------------
  if (!ims_prog_fields_valid_4) begin
     ims_prog_fields_valid_4   = 1'b1;
    `uvm_info(get_full_name(), $psprintf("HQM%0s__update_ims_cfg_4::ims_prog_cfg report",inst_suffix),UVM_LOW)
     foreach (ims_prog_cfg[i]) begin
      `uvm_info(get_full_name(), $psprintf("HQM%0s__update_ims_cfg_4::ims_prog_cfg[%0d].addr=0x%0x data=0x%0x ctrl=0x%0x => enable=%0d is_ldb=%0d cq=%0d",inst_suffix, i, ims_prog_cfg[i].addr, ims_prog_cfg[i].data, ims_prog_cfg[i].ctrl, ims_prog_cfg[i].enable, ims_prog_cfg[i].is_ldb, ims_prog_cfg[i].cq),UVM_HIGH)
     end 
  end 

endfunction : update_ims_cfg

//------------------------------------
function int  hqm_cfg::get_ims_idx(input bit is_ldb, int cq_num);

   foreach(ims_prog_cfg[i]) begin
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS_get_ims_idx: is_ldb=%0d cq=%0d", inst_suffix, is_ldb, cq_num), UVM_HIGH);     
      if(ims_prog_cfg[i].enable==1 && ims_prog_cfg[i].is_ldb == is_ldb && ims_prog_cfg[i].cq == cq_num) begin
           uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS_get_ims_idx: is_ldb=%0d cq=%0d; get ims_idx=%0d", inst_suffix, is_ldb, cq_num, i), UVM_MEDIUM);     
           return(i);
      end 
   end 
   return(-1);
endfunction: get_ims_idx


//------------------------------------
function int hqm_cfg::get_msix_vector(input logic is_compress_mode, logic [63:0] address, logic [31:0] data);
  if (!$test$plusargs("has_hqm_proc_tb"))   update_msix_cfg();

  uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX_get_msix_vector_Start: msix_enabled=%0d addr=0x%0x data=0x%0x is_compress_mode=%0d", inst_suffix, msix_enabled, address, data, is_compress_mode), UVM_MEDIUM);     
  if (msix_enabled) begin
    foreach (msix_cfg[i]) begin
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX_get_msix_vector: addr=0x%0x data=0x%0x is_compress_mode=%0d, (msix_cfg[%0d].enable=%0d/addr=0x%0x/data=0x%0x", inst_suffix, address, data, is_compress_mode, i, msix_cfg[i].enable, msix_cfg[i].addr, msix_cfg[i].data), UVM_MEDIUM);     
         //--use both addr and data to find the msix_num
         if (msix_cfg[i].enable && (msix_cfg[i].addr == address)  && (msix_cfg[i].data == data)) begin
           uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX_get_msix_vector: get msix_num=%0d; addr=0x%0x, (msix_cfg[%0d].enable=%0d/addr=0x%0x/data=0x%0x", inst_suffix,i, address, i, msix_cfg[i].enable, msix_cfg[i].addr, msix_cfg[i].data), UVM_MEDIUM);     
           return(i);
         end 
    end 
  end 

  return(-1);
endfunction : get_msix_vector

function bit hqm_cfg::get_ims_vector(input logic [63:0] address,
                                     input logic [31:0] data,
                                     output logic       is_ldb,
                                     output int         cq_num);

  uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS_get_ims_vector: input addr=0x%0x data=0x%0x ims_poll_mode=%0d", inst_suffix, address, data, ims_poll_mode), UVM_HIGH);     
  if(!$test$plusargs("HQMPROC_IMS_BYPASS_UPDATE"))
   update_ims_cfg();

  if (ims_poll_mode) return(0);

  foreach (dir_ims_cfg[i]) begin
    uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS_get_ims_vector: input addr=0x%0x data=0x%0x; dir_ims_cfg[%0d].addr=0x%0x data=0x%0x ims_idx=%0d", inst_suffix, address, data, i, dir_ims_cfg[i].addr, dir_ims_cfg[i].data, dir_ims_cfg[i].ims_idx), UVM_HIGH);  
    if (dir_ims_cfg[i].enable && (address == dir_ims_cfg[i].addr) && (data == dir_ims_cfg[i].data)) begin
      is_ldb = 1'b0;
      cq_num = i;
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS_get_ims_vector: addr=0x%0x data=0x%0x, get is_ldb=0 cq=%0d", inst_suffix, address, data, cq_num), UVM_MEDIUM);     
      return(1);
    end 
  end 

  foreach (ldb_ims_cfg[i]) begin
    uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS_get_ims_vector: input addr=0x%0x data=0x%0x; ldb_ims_cfg[%0d].addr=0x%0x data=0x%0x ims_idx=%0d", inst_suffix, address, data, i, ldb_ims_cfg[i].addr, ldb_ims_cfg[i].data, ldb_ims_cfg[i].ims_idx), UVM_HIGH);  
    if (ldb_ims_cfg[i].enable && (address == ldb_ims_cfg[i].addr) && (data == ldb_ims_cfg[i].data)) begin
      is_ldb = 1'b1;
      cq_num = i;
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS_get_ims_vector: addr=0x%0x data=0x%0x, get is_ldb=1 cq=%0d", inst_suffix, address, data, cq_num), UVM_MEDIUM);     
      return(1);
    end 
  end 

  return(0);
endfunction

function int hqm_cfg::get_num_msix();
  return(hqm_system_pkg::HQM_SYSTEM_NUM_MSIX);
endfunction

function int hqm_cfg::get_num_msi(int vf_num);
  return (32);
endfunction

function int hqm_cfg::get_num_dir_ims();
  return (hqm_pkg::NUM_DIR_CQ);
endfunction

function int hqm_cfg::get_num_ldb_ims();
  return (hqm_pkg::NUM_LDB_CQ);
endfunction


//----------------------------------------------------------------------------
//-- decode_msix_cq_int_addr
//--   - return cq_num and cq_type if address is a valid CQ interrupt address
//--   - return value of 1 if valid CQ interrupt address, 0 otherwise
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_msix_cq_int_addr(input  int        msix_int_num,
                                         output int            cq_num,
                                         output int            cq_type);
  uvm_reg    my_reg;
  uvm_reg_field  my_field;
  uvm_reg_data_t ral_data; 

  // default values
  cq_num                = -1;
  cq_type               = -1;

  if (msix_int_num >= 1) begin
      for (int i = 0 ; i < hqm_pkg::NUM_LDB_CQ ; i++) begin
        my_field      = hqm_find_field_by_name( "vector", $psprintf("ldb_cq_isr[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );
        ral_data      = my_field.get();
        if (ral_data == (msix_int_num - 1)) begin
          my_field      = hqm_find_field_by_name( "en_code", $psprintf("ldb_cq_isr[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );
          ral_data      = my_field.get();

          if (ral_data == 2) begin
            cq_num      = i;
            cq_type     = 1;
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__decode_msix_cq_int_addr: LDB cq_num=%0d msix_int_num=%0d", inst_suffix,cq_num, msix_int_num), UVM_MEDIUM);     
            return(1);
          end 
        end 
      end 
      for (int i = 0 ; i < hqm_pkg::NUM_DIR_CQ ; i++) begin
        my_field      = hqm_find_field_by_name( "vector", $psprintf("dir_cq_isr[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );
        ral_data      = my_field.get();
        if (ral_data == (msix_int_num - 1)) begin
          my_field      = hqm_find_field_by_name( "en_code", $psprintf("dir_cq_isr[%0d]",i), {tb_env_hier, ".", "hqm_system_csr"} );
          ral_data      = my_field.get();

          if (ral_data == 2) begin
            cq_num      = i;
            cq_type     = 0;
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__decode_msix_cq_int_addr: DIR cq_num=%0d msix_int_num=%0d", inst_suffix,cq_num, msix_int_num), UVM_MEDIUM);     
            return(1);
          end 
        end 
      end 

    uvm_report_info("HQM_CFG", $psprintf("HQM%0s__decode_msix_cq_int_addr: no CQ associated with msix_int_num=%0d", inst_suffix,msix_int_num), UVM_MEDIUM);     
    return(0);
  end 

  uvm_report_info("HQM_CFG", $psprintf("HQM%0s__decode_msix_cq_int_addr: msix_int_num=%0d not valid for a CQ interrupt", inst_suffix,msix_int_num), UVM_MEDIUM);     
  return(0);
endfunction

//----------------------------------------------------------------------------
//-- decode_cq_int_addr
//--   - return cq_num and cq_type if address is a valid CQ interrupt address
//--   - return value of 1 if valid CQ interrupt address, 0 otherwise
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_cq_int_addr(input  logic [63:0]   address,
                                         input  logic [31:0]   data,
                                         input  logic [15:0]   rid,
                                         output bit            is_ims_int,
                                         output int            int_vector,
                                         output int            cq_num,
                                         output int            cq_type); 
  int           msix_vector_num;
  bit [7:0]     func_base;
  uvm_reg    my_reg;
  uvm_reg_field  my_field;
  uvm_reg_data_t ral_data; 

  uvm_config_int::get(this, "","hqm_func_base_strap",func_base);
  uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX_decode_cq_int_addr_S1: addr=0x%0x/data=0x%0x/rid=0x%0x, msix_mode=%0d, func_base=0x%0x",  inst_suffix,address, data, rid, msix_mode, func_base), UVM_MEDIUM);     

  // default values (not a pp address)
  is_ims_int            = 0;
  int_vector            = -1;
  cq_num                = -1;
  cq_type               = -1;

  if ((rid[7:0] == func_base) && !msix_mode) begin
    int_vector       = get_msix_vector(0, address, data);
    uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX_decode_cq_int_addr_S2: addr=0x%0x/data=0x%0x/rid=0x%0x, msix_mode=%0d, func_base=0x%0x, int_vector=%0d",  inst_suffix,address, data, rid, msix_mode, func_base, int_vector), UVM_MEDIUM);     

    if (int_vector >= 1) begin
      if (decode_msix_cq_int_addr(int_vector,cq_num,cq_type)) begin
        return(1);
      end 
    end 
  end 

  if ((rid[7:0] == func_base) && !ims_poll_mode) begin
    if (get_ims_vector(address,data,cq_type,cq_num)) begin
      is_ims_int = 1'b1;
      int_vector = cq_num;
      uvm_report_info("HQM_CFG", $psprintf("HQM%0s__IMS_decode_cq_int_addr: addr=0x%0x/data=0x%0x/rid=0x%0x, func_base=0x%0x, int_vector=%0d",  inst_suffix,address, data, rid, func_base, int_vector), UVM_MEDIUM);     
      return(1);
    end 
  end 

  return(0);
endfunction

//----------------------------------------------------------------------------
//-- decode_msix_int_addr
//--   - return cq_num and cq_type if address is a valid CQ interrupt address
//--   - return value of 1 if valid CQ interrupt address, 0 otherwise
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_msix_int_addr(input  logic [63:0]   address,
                                           input  logic [31:0]   data,
                                           input  logic [15:0]   rid,
                                           output int            msix_num); 
  int           msix_vector_num;
  bit [7:0]     func_base;

  uvm_config_int::get(this, "","hqm_func_base_strap",func_base);

  msix_num              = -1;

  if (rid[7:0] == func_base) begin
    uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX_decode_msix_int_addr_S1: addr=0x%0x/data=0x%0x/rid=0x%0x, msix_mode=%0d, func_base=0x%0x",  inst_suffix,address, data, rid, msix_mode, func_base), UVM_MEDIUM);     
    msix_num    = get_msix_vector(0, address, data);
    uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX_decode_msix_int_addr_S1: get msix_num=%0d",  inst_suffix, msix_num), UVM_MEDIUM);     

    if (msix_num >= 0) begin
      if(msix_num==0) begin
         hqm_alarm_issued=1;
         hqm_alarm_count++;
         uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX_decode_msix_int_addr_S2: get msix_num=%0d hqm_alarm_issued=%0d hqm_alarm_count=%0d",  inst_suffix, msix_num, hqm_alarm_issued, hqm_alarm_count), UVM_MEDIUM);     

         foreach(dir_pp_cq_cfg[idx]) begin
            if(dir_pp_cq_cfg[idx].cq_ats_inv_ctrl==2) begin
               hqmproc_dir_trfctrl[idx] = 0;
               uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX_decode_msix_int_addr_S3: upon Alarm, when dir_pp_cq_cfg[%0d].cq_ats_inv_ctrl=2 => reset hqmproc_dir_trfctrl[%0d]=0 to stop enq traffic in VASRESET test",  inst_suffix, idx, idx), UVM_MEDIUM);     
            end 
         end 
         foreach(ldb_pp_cq_cfg[idx]) begin
            if(ldb_pp_cq_cfg[idx].cq_ats_inv_ctrl==2) begin
               hqmproc_ldb_trfctrl[idx] = 0;
               uvm_report_info("HQM_CFG", $psprintf("HQM%0s__MSIX_decode_msix_int_addr_S3: upon Alarm, when ldb_pp_cq_cfg[%0d].cq_ats_inv_ctrl=2 => reset hqmproc_ldb_trfctrl[%0d]=0 to stop enq traffic in VASRESET test",  inst_suffix, idx, idx), UVM_MEDIUM);     
            end 
         end 
      end 
      return(1);
    end 
  end 

  return(0);
endfunction


//----------------------------------------------------------------------------
//-- get_ims_ctrl
//--   - return dir/ldb_ims_cfg[cq].ctrl  (1 bit, 0: unmasked; 1: masked)
//----------------------------------------------------------------------------
function bit  hqm_cfg::get_ims_ctrl( input int cq_type, int cq_num);
    bit [7:0] ims_index;
    uvm_reg    my_reg;
    uvm_reg_field  ai_ctrl_mask, ai_ctrl_pend;
    uvm_reg_data_t ral_data, ral_data1; 

    ims_index = get_ims_idx(cq_type, cq_num);

    if(ims_index >= 0) begin
       ai_ctrl_mask   = hqm_find_field_by_name( "ims_mask", $psprintf("ai_ctrl[%0d]",ims_index), {tb_env_hier, ".", "hqm_system_csr"} );
       ai_ctrl_pend   = hqm_find_field_by_name( "ims_pend", $psprintf("ai_ctrl[%0d]",ims_index), {tb_env_hier, ".", "hqm_system_csr"} );
       ral_data       = ai_ctrl_mask.get();
       ral_data1      = ai_ctrl_pend.get();
       uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_ims_ctrl: is_ldb %0d cq_num %0d  get ims_index %0d; get ai_ctrl field: ims_mask=0x%0x ims_pend=0x%0x ",  inst_suffix, cq_type, cq_num, ims_index, ral_data, ral_data1 ), UVM_LOW);     

       //---------------
       if (cq_type == 0) begin // DIR
         foreach (dir_ims_cfg[i]) begin
           if (dir_ims_cfg[i].enable && (i == cq_num)) begin
             dir_ims_cfg[i].ctrl[1:0] = {ral_data1[0], ral_data[0]}; 
             uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_ims_ctrl: DIR cq_num %0d ims_ctrl %0b ",  inst_suffix,i, dir_ims_cfg[i].ctrl[1:0]), UVM_MEDIUM);     
             return(dir_ims_cfg[i].ctrl[1:0]);
           end 
         end 
       end else begin
         foreach (ldb_ims_cfg[i]) begin
           if (ldb_ims_cfg[i].enable && (i == cq_num)) begin
             ldb_ims_cfg[i].ctrl[1:0] = {ral_data1[0], ral_data[0]}; 
             uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_ims_ctrl: LDB cq_num %0d ims_ctrl %0b ",  inst_suffix,i, ldb_ims_cfg[i].ctrl[1:0]), UVM_MEDIUM);     
             return(ldb_ims_cfg[i].ctrl[1:0]);
           end 
         end 
       end 

     end else begin
         uvm_report_error("HQM_CFG", $psprintf("HQM%0s__get_ims_ctrl: is_ldb %0d cq_num %0d does not get ims_index %0d ",  inst_suffix, cq_type, cq_num, ims_index ), UVM_LOW);     
     end 
endfunction

//----------------------------------------------------------------------------
//-- get_ims_poll_addr
//--   - return cq_num and cq_type if address is a valid CQ interrupt address
//--   - return value of 1 if valid CQ interrupt address, 0 otherwise
//----------------------------------------------------------------------------
function bit [63:0] hqm_cfg::get_ims_poll_addr( input  int     cq_num,
                                                 input  int     cq_type);
  if (ims_poll_mode) begin
    if (cq_type == 0) begin // DIR
      foreach (dir_ims_cfg[i]) begin
        if (dir_ims_cfg[i].enable && (i == cq_num)) begin
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_ims_poll_addr: DIR cq_num %0d get_ims_poll_addr 0x%0x ",  inst_suffix,i, dir_ims_cfg[i].addr), UVM_MEDIUM);     
          return(dir_ims_cfg[i].addr);
        end 
      end 
    end else begin
      foreach (ldb_ims_cfg[i]) begin
        if (ldb_ims_cfg[i].enable && (i == cq_num)) begin
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_ims_poll_addr: LDB cq_num %0d get_ims_poll_addr 0x%0x ",  inst_suffix,i, ldb_ims_cfg[i].addr), UVM_MEDIUM);     
          return(ldb_ims_cfg[i].addr);
        end 
      end 
    end 
  end 

  return(0);
endfunction

//----------------------------------------------------------------------------
//-- get_ims_addr
//--   - return cq_num and cq_type if address is a valid CQ interrupt address
//--   - return value of 1 if valid CQ interrupt address, 0 otherwise
//----------------------------------------------------------------------------
function bit [63:0] hqm_cfg::get_ims_addr( input  int     cq_num,
                                           input  int     cq_type);
  if (ims_poll_mode==0) begin
    if (cq_type == 0) begin // DIR
      foreach (dir_ims_cfg[i]) begin
        if (dir_ims_cfg[i].enable && (i == cq_num)) begin
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_ims_addr: DIR cq_num %0d get_ims_addr 0x%0x ",  inst_suffix,i, dir_ims_cfg[i].addr), UVM_MEDIUM);     
          return(dir_ims_cfg[i].addr);
        end 
      end 
    end else begin
      foreach (ldb_ims_cfg[i]) begin
        if (ldb_ims_cfg[i].enable && (i == cq_num)) begin
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_ims_addr: LDB cq_num %0d get_ims_addr 0x%0x ",  inst_suffix,i, ldb_ims_cfg[i].addr), UVM_MEDIUM);     
          return(ldb_ims_cfg[i].addr);
        end 
      end 
    end 
  end 

  return(0);
endfunction
function bit hqm_cfg::decode_ims_poll_addr(input  logic [63:0]   address,
                                            input  logic [31:0]   data,
                                            input  logic [15:0]   rid,
                                            output int            cq_num,
                                            output int            cq_type); 
  bit [7:0]     func_base;
  bit [7:0]     exp_rid;

  uvm_config_int::get(this, "","hqm_func_base_strap",func_base);

  cq_num        = -1;
  cq_type       = -1;

  if (ims_poll_mode) begin
    foreach (dir_ims_cfg[i]) begin
      if (dir_ims_cfg[i].enable && (dir_ims_cfg[i].addr == address)) begin
        if (rid[7:0] == func_base) begin
          cq_num      = i;
          cq_type     = 0;
          i_hqm_pp_cq_status.dir_int_count[i] ++; 
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__decode_ims_poll_addr: addr=0x%0x data=0x%0x rid=0x%0x :: DIR dir_int_count[%0d]=%0d ", inst_suffix,address, data, rid, i, i_hqm_pp_cq_status.dir_int_count[i]), UVM_MEDIUM);     
          return(1);
        end 

        if (hqm_iov_mode == HQM_SRIOV_MODE) begin
          exp_rid = {4'h0,dir_ims_cfg[i].data[30:27]} + 8'h1;
          if (rid[7:0] == exp_rid) begin
            cq_num      = i;
            cq_type     = 0;
            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__decode_ims_poll_addr: HQM_SRIOV_MODE exp_rid=0x%0x rid=0x%0x :: dir_ims_cfg[%0d].data=0x%0x", inst_suffix,exp_rid, rid, i, dir_ims_cfg[i].data), UVM_MEDIUM);     
            return(1);
          end 
        end 
      end 
    end 

    foreach (ldb_ims_cfg[i]) begin
      if (ldb_ims_cfg[i].enable && (ldb_ims_cfg[i].addr == address)) begin
        if (rid[7:0] == func_base) begin
          cq_num      = i;
          cq_type     = 1;
          i_hqm_pp_cq_status.ldb_int_count[i] ++; 
          uvm_report_info("HQM_CFG", $psprintf("HQM%0s__decode_ims_poll_addr: addr=0x%0x data=0x%0x rid=0x%0x :: LDB ldb_int_count[%0d]=%0d ", inst_suffix,address, data, rid, i, i_hqm_pp_cq_status.ldb_int_count[i]), UVM_MEDIUM);     
          return(1);
        end 

        if (hqm_iov_mode == HQM_SRIOV_MODE) begin
          exp_rid = {4'h0,ldb_ims_cfg[i].data[30:27]} + 8'h1;
          if (rid[7:0] == exp_rid) begin
            cq_num      = i;
            cq_type     = 1;
            uvm_report_info("HQM_CFG", $psprintf("HQM%0s__decode_ims_poll_addr: HQM_SRIOV_MODE exp_rid=0x%0x rid=0x%0x :: ldb_ims_cfg[%0d].data=0x%0x", inst_suffix,exp_rid, rid, i, ldb_ims_cfg[i].data), UVM_MEDIUM);     
            return(1);
          end 
        end 
      end 
    end 
  end 

  return(0);
endfunction

//----------------------------------------------------------------------------
//-- decode_comp_msix_cq_int_addr
//--   - return value of 1 if valid Compressed CQ interrupt address, 0 otherwise
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_comp_msix_cq_int_addr(input logic [63:0]    address, input logic [31:0] data, input  logic [15:0]   rid); 
  int           msi_vector_num;
  int           msix_vector_num;
  bit [7:0]     func_base;

  uvm_config_int::get(this, "","hqm_func_base_strap",func_base);
  uvm_report_info("HQM_CFG", $psprintf("HQM%0s__decode_comp_msix_cq_int_addr_1: addr=0x%0x, data=0x%0x, rid=0x%0x, msix_mode=%0d/func_base=0x%0x", inst_suffix, address, data, rid, msix_mode, func_base), UVM_MEDIUM);     

  if (rid[7:0] == func_base) begin
    msix_vector_num       = get_msix_vector(1, address, data);
    uvm_report_info("HQM_CFG", $psprintf("HQM%0s__decode_comp_msix_cq_int_addr_2: addr=0x%0x, data=0x%0x, rid=0x%0x, msix_mode=%0d/msix_vector_num=%0d", inst_suffix, address, data, rid, msix_mode, msix_vector_num), UVM_MEDIUM);     

    if ((msix_vector_num == 1) && msix_mode) begin
       uvm_report_info("HQM_CFG", $psprintf("HQM%0s__decode_comp_msix_cq_int_addr_rtn1: addr=0x%0x, data=0x%0x, rid=0x%0x, msix_mode=%0d/msix_vector_num=%0d", inst_suffix,address, data, rid, msix_mode, msix_vector_num), UVM_MEDIUM);     
      return(1);
    end 
  end 

  return(0);
endfunction



function bit hqm_cfg::is_single_hcw_per_cl(bit is_ldb);
  if (is_ldb) begin
    if (cfg_64bytes_qe_ldb_cq_mode_field == null) begin
      cfg_64bytes_qe_ldb_cq_mode_field = hqm_find_field_by_name("cfg_64bytes_qe_ldb_cq_mode","cfg_chp_csr_control", {tb_env_hier, ".", "credit_hist_pipe"});
      if (cfg_64bytes_qe_ldb_cq_mode_field == null) begin
        uvm_report_error("RAL CFG GET", $psprintf("HQM%0s__Unable to find credit_hist_pipe.cfg_chp_csr_control.cfg_64bytes_qe_ldb_cq_mode", inst_suffix));
        return 0;
      end 
    end 

    is_single_hcw_per_cl = cfg_64bytes_qe_ldb_cq_mode_field.get_mirrored_value();
  end else begin
    if (cfg_64bytes_qe_dir_cq_mode_field == null) begin
      cfg_64bytes_qe_dir_cq_mode_field = hqm_find_field_by_name("cfg_64bytes_qe_dir_cq_mode","cfg_chp_csr_control", {tb_env_hier, ".", "credit_hist_pipe"});
      if (cfg_64bytes_qe_dir_cq_mode_field == null) begin
        uvm_report_error("RAL CFG GET", $psprintf("HQM%0s__Unable to find credit_hist_pipe.cfg_chp_csr_control.cfg_64bytes_qe_dir_cq_mode", inst_suffix));
        return 0;
      end 
    end 
     
    is_single_hcw_per_cl = cfg_64bytes_qe_dir_cq_mode_field.get_mirrored_value();
  end 
endfunction

function bit hqm_cfg::set_sequential_names(bit is_seq);
  sequential_names = is_seq;
endfunction

function bit hqm_cfg::is_vpp_v(
                                int vf_num,
                                bit is_ldb,
                                int vpp_num
                              );
  if ((vf_num < 0) || (vf_num >= hqm_pkg::NUM_VF)) begin
    return (0);
  end 

  if (is_ldb) begin
    if ((vpp_num < 0) || (vpp_num >= hqm_pkg::NUM_LDB_PP)) begin
      return (0);
    end else begin
      return (vf_cfg[vf_num].ldb_vpp_cfg[vpp_num].vpp_v);
    end 
  end else begin
    if ((vpp_num < 0) || (vpp_num >= hqm_pkg::NUM_DIR_PP)) begin
      return (0);
    end else begin
      return (vf_cfg[vf_num].dir_vpp_cfg[vpp_num].vpp_v);
    end 
  end 
endfunction

function bit hqm_cfg::is_vqid_v(
                                 int vf_num,
                                 bit is_ldb,
                                 int vqid_num
                               );
  if (is_ldb) begin
    if ((vqid_num < 0) || (vqid_num >= hqm_pkg::NUM_LDB_QID) || (vf_num < 0) || (vf_num >= hqm_pkg::NUM_VF)) begin
      return (0);
    end else begin
      return (vf_cfg[vf_num].ldb_vqid_cfg[vqid_num].vqid_v);
    end 
  end else begin
    if ((vqid_num < 0) || (vqid_num >= hqm_pkg::NUM_DIR_QID) || (vf_num < 0) || (vf_num >= hqm_pkg::NUM_VF)) begin
      return (0);
    end else begin
      return (vf_cfg[vf_num].dir_vqid_cfg[vqid_num].vqid_v);
    end 
  end 
endfunction

function bit hqm_cfg::is_pp_v(
                               bit is_ldb,
                               int pp_num
                             );
  if (is_ldb) begin
    if ((pp_num < 0) || (pp_num >= hqm_pkg::NUM_LDB_PP)) begin
      return (0);
    end else begin
      return (ldb_pp_cq_cfg[pp_num].pp_enable);
    end 
  end else begin
    if ((pp_num < 0) || (pp_num >= hqm_pkg::NUM_DIR_PP)) begin
      return (0);
    end else begin
      return (dir_pp_cq_cfg[pp_num].pp_enable);
    end 
  end 
endfunction


function bit hqm_cfg::is_sciov_pp_v(
                               bit is_ldb,
                               int pp
                             );
  int vdev;

  vdev = get_vdev(is_ldb,pp);

  if (is_ldb) begin
    if ((vdev < 0) || (pp < 0) || (pp >= hqm_pkg::NUM_LDB_PP)) begin
      return (0);
    end else begin
      return (ldb_pp_cq_cfg[pp].pp_enable);
    end 
  end else begin
    if ((vdev < 0) || (pp < 0) || (pp >= hqm_pkg::NUM_DIR_PP)) begin
      return (0);
    end else begin
      return (dir_pp_cq_cfg[pp].pp_enable);
    end 
  end 
endfunction


function bit hqm_cfg::is_qid_v(
                                bit is_ldb,
                                int qid_num
                              );
  if (is_ldb) begin
    if ((qid_num < 0) || (qid_num >= hqm_pkg::NUM_LDB_QID)) begin
      return (0);
    end 
    return (ldb_qid_cfg[qid_num].enable);
  end else begin
    if ((qid_num < 0) || (qid_num >= hqm_pkg::NUM_DIR_QID)) begin
      return (0);
    end 
    return (dir_qid_cfg[qid_num].enable);
  end 
endfunction


function bit hqm_cfg::is_sciov_vqid_v(
                                bit is_ldb_pp,
                                int pp,
                                bit is_ldb,
                                int vqid
                              );
  int vdev;

  vdev = get_vdev(is_ldb_pp,pp);
  `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_is_sciov_vqid_v: is_ldb_pp=%0d is_ldb=%0d(qtype), pp=%0d, get:: vdev=%0d with vdev_cfg[%0d].ldb_vqid_cfg[%0d].vqid_v=%0d qid=%0d", inst_suffix, is_ldb_pp, is_ldb, pp, vdev, vdev, vqid, vdev_cfg[vdev].ldb_vqid_cfg[vqid].vqid_v, vdev_cfg[vdev].ldb_vqid_cfg[vqid].qid ),UVM_MEDIUM)
  `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_is_sciov_vqid_v: is_ldb_pp=%0d is_ldb=%0d(qtype), pp=%0d, get:: vdev=%0d with vdev_cfg[%0d].dir_vqid_cfg[%0d].vqid_v=%0d qid=%0d", inst_suffix, is_ldb_pp, is_ldb, pp, vdev, vdev, vqid, vdev_cfg[vdev].dir_vqid_cfg[vqid].vqid_v, vdev_cfg[vdev].dir_vqid_cfg[vqid].qid ),UVM_MEDIUM)

  if (is_ldb) begin
    if ((vdev < 0) || (vqid < 0) || (vqid >= hqm_pkg::NUM_LDB_QID)) begin
      return (0);
    end 
   `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_is_sciov_vqid_v: vdev_cfg[%0d].ldb_vqid_cfg[%0d].vqid_v=%0d qid=%0d", inst_suffix, vdev, vqid, vdev_cfg[vdev].ldb_vqid_cfg[vqid].vqid_v, vdev_cfg[vdev].ldb_vqid_cfg[vqid].qid ),UVM_MEDIUM)
    return (vdev_cfg[vdev].ldb_vqid_cfg[vqid].vqid_v);
  end else begin
    if ((vdev < 0) || (vqid < 0) || (vqid >= hqm_pkg::NUM_DIR_QID)) begin
      `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_is_sciov_vqid_v: is_ldb=%0d, pp=%0d, vqid=%0d, vdev=%0d:: return 0  ", inst_suffix, is_ldb, pp, vqid, vdev),UVM_MEDIUM)
      return (0);
    end 
      `uvm_info("HQM_CFG",$psprintf("HQM%0s__DEBUG_is_sciov_vqid_v: vdev_cfg[%0d].dir_vqid_cfg[%0d].vqid_v=%0d qid=%0d ", inst_suffix, vdev, vqid, vdev_cfg[vdev].dir_vqid_cfg[vqid].vqid_v, vdev_cfg[vdev].dir_vqid_cfg[vqid].qid),UVM_MEDIUM)
    return (vdev_cfg[vdev].dir_vqid_cfg[vqid].vqid_v);
  end 
endfunction

function bit hqm_cfg::is_ao_qid_v(
                                int qid_num
                              );
  if ((qid_num < 0) || (qid_num >= hqm_pkg::NUM_LDB_QID)) begin
    return (0);
  end 

  return (ldb_qid_cfg[qid_num].ao_cfg_v);
endfunction

function bit hqm_cfg::is_fid_qid_v(
                                int qid_num
                              );
  if ((qid_num < 0) || (qid_num >= hqm_pkg::NUM_LDB_QID)) begin
    return (0);
  end 

  return (ldb_qid_cfg[qid_num].fid_cfg_v);
endfunction

function bit hqm_cfg::is_sn_qid_v(
                                int qid_num
                              );
  if ((qid_num < 0) || (qid_num >= hqm_pkg::NUM_LDB_QID)) begin
    return (0);
  end 

  return (ldb_qid_cfg[qid_num].sn_cfg_v);
endfunction


function bit hqm_cfg::is_vasqid_v(
                                   int vas,
                                   bit is_ldb,
                                   int qid_num
                                 );
  if (is_ldb) begin
    if ((qid_num < 0) || (qid_num >= hqm_pkg::NUM_LDB_QID) || (vas < 0) || (vas >= hqm_pkg::NUM_VAS)) begin
      return (0);
    end 
    return (vas_cfg[vas].ldb_qid_v[qid_num]);
  end else begin
    if ((qid_num < 0) || (qid_num >= hqm_pkg::NUM_DIR_QID) || (vas < 0) || (vas >= hqm_pkg::NUM_VAS)) begin
      return (0);
    end 
    return (vas_cfg[vas].dir_qid_v[qid_num]);
  end 
endfunction

//-- get_sciov_qid 
function logic [hqm_pkg::QID_ARCH_WIDTH-1:0] hqm_cfg::get_sciov_qid(bit is_ldb_pp, int pp, bit is_ldb, int vqid, bit ignore_v, bit is_nm_pf);
  int vdev;

  if (is_ldb) begin
    if ((vqid < 0) || (vqid >= hqm_pkg::NUM_LDB_QID) || (pp < 0) || (pp >= hqm_pkg::NUM_LDB_PP)) begin
      return (0);
    end 
  end else begin
    if ((vqid < 0) || (vqid >= hqm_pkg::NUM_DIR_QID) || (pp < 0) || (pp >= hqm_pkg::NUM_DIR_PP)) begin
      return (0);
    end 
  end 

  uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_sciov_qid: is_ldb_pp=%0d pp=%0d, is_ldb=%0d(qtype is_ldb) vqid=%0d ignore_v=%0d, is_nm_pf=%0d hqm_iov_mode=%0s", inst_suffix, is_ldb_pp, pp, is_ldb, vqid, ignore_v, is_nm_pf, hqm_iov_mode), UVM_HIGH);     

  if (hqm_iov_mode == HQM_SCIOV_MODE) begin
    if (is_nm_pf) begin
      get_sciov_qid = vqid;
    end else begin
      if (is_ldb) begin
        //vdev = get_vdev(is_ldb,pp);
        vdev = get_vdev(is_ldb_pp,pp);

        if ((vdev < 0) || (vdev >= hqm_pkg::NUM_VF)) begin
          `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VDEV %0d not a valid VDEV",inst_suffix,vdev))
        end else begin
          if (vdev_cfg[vdev].ldb_vqid_cfg[vqid].vqid_v || ignore_v) begin
            get_sciov_qid = vdev_cfg[vdev].ldb_vqid_cfg[vqid].qid;
          end else begin
            `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VDEV 0x%0x LDB VQID 0x%0x not a valid VQID",inst_suffix,vdev,vqid))
          end 
        end 
      end else begin
        //vdev = get_vdev(is_ldb,pp);
        vdev = get_vdev(is_ldb_pp,pp);

        if ((vdev < 0) || (vdev >= hqm_pkg::NUM_VF)) begin
          `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VDEV 0x%0x not a valid VDEV",inst_suffix,vdev))
        end else begin
          if (vdev_cfg[vdev].dir_vqid_cfg[vqid].vqid_v || ignore_v) begin
            get_sciov_qid = vdev_cfg[vdev].dir_vqid_cfg[vqid].qid;
          end else begin
            `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VDEV 0x%0x DIR VPP 0x%0x not a valid VQID",inst_suffix,vdev,vqid))
          end 
        end 
      end 
    end 
  end else begin
    `uvm_error(get_full_name(),$psprintf("HQM%0s__Not in SCIOV mode",inst_suffix))
    get_sciov_qid = vqid;
  end 
endfunction : get_sciov_qid


//-- get_pf_qid (support SRIOV)
function logic [hqm_pkg::QID_ARCH_WIDTH-1:0] hqm_cfg::get_pf_qid(bit is_vf, int vf_vdev_num, bit is_ldb, int vqid, bit ignore_v, bit is_nm_pf);
  if (is_ldb) begin
    if ((vqid < 0) || (vqid >= hqm_pkg::NUM_LDB_QID) || (is_vf && (vf_vdev_num < 0) || (vf_vdev_num >= hqm_pkg::NUM_VF))) begin
      return (0);
    end 
  end else begin
    if ((vqid < 0) || (vqid >= hqm_pkg::NUM_DIR_QID) || (is_vf && (vf_vdev_num < 0) || (vf_vdev_num >= hqm_pkg::NUM_VF))) begin
      return (0);
    end 
  end 

  if (hqm_iov_mode == HQM_SCIOV_MODE) begin
    if (is_nm_pf) begin
      get_pf_qid = vqid;
    end else begin
      if (is_ldb) begin
        if ((vf_vdev_num < 0) || (vf_vdev_num >= hqm_pkg::NUM_VF)) begin
          `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VDEV %0d not a valid VDEV",inst_suffix,vf_vdev_num))
        end else begin
          if (vdev_cfg[vf_vdev_num].ldb_vqid_cfg[vqid].vqid_v || ignore_v) begin
            get_pf_qid = vdev_cfg[vf_vdev_num].ldb_vqid_cfg[vqid].qid;
            if(vdev_cfg[vf_vdev_num].ldb_vqid_cfg[vqid].vqid_v==0 && ignore_v)
              `uvm_warning("HCW_SCOREBOARD",$psprintf("HQM%0s__VDEV 0x%0x LDB VQID 0x%0x not a valid VQID (ignore_v=1)",inst_suffix,vf_vdev_num,vqid))
          end else begin
            `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VDEV 0x%0x LDB VQID 0x%0x not a valid VQID",inst_suffix,vf_vdev_num,vqid))
          end 
        end 
      end else begin
        if ((vf_vdev_num < 0) || (vf_vdev_num >= hqm_pkg::NUM_VF)) begin
          `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VDEV 0x%0x not a valid VDEV",inst_suffix,vf_vdev_num))
        end else begin
          if (vdev_cfg[vf_vdev_num].dir_vqid_cfg[vqid].vqid_v || ignore_v) begin
            get_pf_qid = vdev_cfg[vf_vdev_num].dir_vqid_cfg[vqid].qid;
          end else begin
            `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VDEV 0x%0x DIR VPP 0x%0x not a valid VPP",inst_suffix,vf_vdev_num,vqid))
          end 
        end 
      end 
    end 
    uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_pf_qid_SCIOV: is_vf=%0d, vf_vdev_num=%0d, is_ldb=%0d vqid=%0d is_nm_pf=%0d ignore_v=%0s, get_pf_qid=%0x", inst_suffix, is_vf, vf_vdev_num, is_ldb, vqid, is_nm_pf, ignore_v, get_pf_qid), UVM_MEDIUM);     

  end else if (is_vf) begin
    if (is_ldb) begin
      if (vf_cfg[vf_vdev_num].ldb_vqid_cfg[vqid].vqid_v || ignore_v) begin
        get_pf_qid = vf_cfg[vf_vdev_num].ldb_vqid_cfg[vqid].qid;
      end else begin
        `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VF 0x%0x LDB VQID 0x%0x not a valid VQID",inst_suffix,vf_vdev_num,vqid))
      end 
    end else begin
      if (vf_cfg[vf_vdev_num].dir_vqid_cfg[vqid].vqid_v || ignore_v) begin
        get_pf_qid = vf_cfg[vf_vdev_num].dir_vqid_cfg[vqid].qid;
      end else begin
        `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VF 0x%0x DIR VQID 0x%0x not a valid VQID",inst_suffix,vf_vdev_num,vqid))
      end 
    end 
    uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_pf_qid_VF: is_vf=%0d, vf_vdev_num=%0d, is_ldb=%0d vqid=%0d is_nm_pf=%0d, get_pf_qid=%0x", inst_suffix, is_vf, vf_vdev_num, is_ldb, vqid, is_nm_pf, get_pf_qid), UVM_MEDIUM);     

  end else begin
    get_pf_qid = vqid;
    uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_pf_qid_PF: is_vf=%0d, vf_vdev_num=%0d, is_ldb=%0d vqid=%0d is_nm_pf=%0d, get_pf_qid=%0x", inst_suffix, is_vf, vf_vdev_num, is_ldb, vqid, is_nm_pf, get_pf_qid), UVM_MEDIUM);     
  end 
endfunction : get_pf_qid

function int hqm_cfg::get_vqid( int qid,
                       bit is_ldb
                     );
  int vqid;

  if (is_ldb) begin
    get_vqid = ldb_qid_cfg[qid].vqid;
  end else begin
    get_vqid = dir_qid_cfg[qid].vqid;
  end 
endfunction

function int hqm_cfg::get_vcq(int cq, int vf_num, bit is_ldb, bit ignore_v);
  int vcq;

  if (is_ldb) begin
    for (vcq = 0 ; vcq < hqm_pkg::NUM_LDB_CQ ; vcq++) begin
      if (cq == vf_cfg[vf_num].ldb_vpp_cfg[vcq].pp)
        if (vf_cfg[vf_num].ldb_vpp_cfg[vcq].vpp_v || ignore_v) begin
          return (vcq);
      end 
    end 
  end else begin
    for (vcq = 0 ; vcq < hqm_pkg::NUM_DIR_CQ ; vcq++) begin
      if (cq == vf_cfg[vf_num].dir_vpp_cfg[vcq].pp)
        if (vf_cfg[vf_num].dir_vpp_cfg[vcq].vpp_v || ignore_v) begin
          return (vcq);
      end 
    end 
  end 

  `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VF 0x%0x %s CQ 0x%0x not a valid VCQ",inst_suffix,vf_num,is_ldb ? "LDB" : "DIR",cq))
endfunction : get_vcq

function int hqm_cfg::get_msi_num( int cq,
                                   int vf_num,
                                   bit is_ldb
                                 );
  get_msi_num = -1;

  if ((vf_num < 0) || (vf_num >= hqm_pkg::NUM_VF)) begin
    `uvm_error(get_full_name(),$psprintf("HQM%0s__Illegal VF 0x%0x",inst_suffix,vf_num))
    return (-1);
  end 

  if (is_ldb) begin
    if ((cq >= 0) && (cq < hqm_pkg::NUM_LDB_CQ)) begin
      foreach (vf_cfg[vf_num].msi_cfg[i]) begin
        if (vf_cfg[vf_num].msi_cfg[i].enable && vf_cfg[vf_num].msi_cfg[i].is_ldb && (vf_cfg[vf_num].msi_cfg[i].cq == cq)) begin
          return(i);
        end 
      end 
    end else begin
      `uvm_error(get_full_name(),$psprintf("HQM%0s__VF 0x%0x %s CQ 0x%0x not a valid CQ",inst_suffix,vf_num,is_ldb ? "LDB" : "DIR",cq))
      return (-1);
    end 
  end else begin
    if ((cq >= 0) && (cq < hqm_pkg::NUM_DIR_CQ)) begin
      foreach (vf_cfg[vf_num].msi_cfg[i]) begin
        if (vf_cfg[vf_num].msi_cfg[i].enable && (!vf_cfg[vf_num].msi_cfg[i].is_ldb) && (vf_cfg[vf_num].msi_cfg[i].cq == cq)) begin
          return(i);
        end 
      end 
    end else begin
      `uvm_error(get_full_name(),$psprintf("HQM%0s__VF 0x%0x %s CQ 0x%0x not a valid CQ",inst_suffix,vf_num,is_ldb ? "LDB" : "DIR",cq))
      return (-1);
    end 
  end 

  `uvm_error(get_full_name(),$psprintf("HQM%0s__VF 0x%0x %s CQ 0x%0x does not have a valid MSI number",inst_suffix,vf_num,is_ldb ? "LDB" : "DIR",cq))
endfunction : get_msi_num

function bit hqm_cfg::is_legal_sai(input uvm_access_e   op,
                                   input logic [7:0]    sai8,
                                   input string         file_name,
                                   input string         reg_name);
  uvm_reg           my_reg;
  logic [7:0]           sai6;
  uvm_reg_data_t        ctrl_reg_val;
   
  sai6 = rtlgen_pkg_v12::f_sai_sb_to_cr(sai8);

  my_reg = hqm_find_reg_by_file_name(reg_name, {tb_env_hier, ".", file_name});

  if (my_reg == null) begin
    uvm_report_error(get_full_name(), $psprintf("HQM%0s__Unable to find %s.%s", inst_suffix,file_name, reg_name));
    return 0;
  end else begin
    if (op == RAL_WRITE) begin
      //--08122022  is_legal_sai = my_reg.get_write_policy(sai6, ctrl_reg_val); //slu_ral_db::regs.check_sai_access(<reg>, this_sai, UVM_WRITE)
      is_legal_sai = slu_ral_db::regs.check_sai_access(my_reg, sai6, UVM_WRITE);
      `uvm_info("HQM_CFG",$psprintf("HQM%0s__is_legal_sai: file_name=%0s reg_name=%0s; sai6=0x%0x ctrl_reg_val=0x%0x, is_legal_sai=%0d, no_sai_check=%0d (1: No SAI check for HCW write)", inst_suffix,file_name, reg_name, sai6, ctrl_reg_val, is_legal_sai, no_sai_check),UVM_LOW)
    end else begin
      //--08122022  is_legal_sai = my_reg.get_read_policy(sai6, ctrl_reg_val);
      is_legal_sai = slu_ral_db::regs.check_sai_access(my_reg, sai6, UVM_READ);
    end 
  end 
endfunction : is_legal_sai

function bit hqm_cfg::get_name_val(string name, output int val);
  name = name.tolower();

  if (names.exists(name)) begin
    val = names[name];
    `uvm_info(get_full_name(),$psprintf("HQM%0s__get_name_val %s get value %0d", inst_suffix,name,val),UVM_MEDIUM)
    return (1);
  end else begin
    val = -1;
    return (0);
  end 
endfunction : get_name_val

function bit hqm_cfg::set_name_val(string name, int val, string name_context);
  name = name.tolower();

  if (names.exists(name)) begin
    if (names[name] != val) begin
      `uvm_error("HQM_CFG",$psprintf("HQM%0s__%s Label %s already exists and values not the same (%0d != %0d)",inst_suffix,name_context,name,names[name],val))
      return (0);
    end 
  end else begin
    `uvm_info(get_full_name(),$psprintf("HQM%0s__%s Label %s set to value %0d",inst_suffix,name_context,name,val),UVM_MEDIUM)
    names[name] = val;
  end 

  return (1);
endfunction : set_name_val

function logic [hqm_pkg::PP_ARCH_WIDTH-1:0] hqm_cfg::get_pf_pp(bit is_vf, int vf_num, bit is_ldb, int vpp, bit ignore_v);
  int vdev;

  if (is_vf) begin
    if (is_ldb) begin
      if (vf_cfg[vf_num].ldb_vpp_cfg[vpp].vpp_v || ignore_v) begin
        get_pf_pp = vf_cfg[vf_num].ldb_vpp_cfg[vpp].pp;
      end else begin
        `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VF 0x%0x LDB VPP 0x%0x not a valid VPP",inst_suffix,vf_num,vpp))
      end 
    end else begin
      if (vf_cfg[vf_num].dir_vpp_cfg[vpp].vpp_v || ignore_v) begin
        get_pf_pp = vf_cfg[vf_num].dir_vpp_cfg[vpp].pp;
      end else begin
        `uvm_error("HCW_SCOREBOARD",$psprintf("HQM%0s__VF 0x%0x DIR VPP 0x%0x not a valid VPP",inst_suffix,vf_num,vpp))
      end 
    end 
  end else begin
    get_pf_pp = vpp;
  end 
endfunction : get_pf_pp
	  
function hqm_iov_mode_t  hqm_cfg::get_iov_mode();
  return(hqm_iov_mode);
endfunction

function bit hqm_cfg::is_pf_mode();
  return ((hqm_iov_mode == HQM_PF_MODE) ? 1'b1 : 1'b0);
endfunction

function bit hqm_cfg::is_sciov_mode();
  return ((hqm_iov_mode == HQM_SCIOV_MODE) ? 1'b1 : 1'b0);
endfunction

function bit hqm_cfg::is_sriov_mode();
  return 1'b0;
endfunction

function int hqm_cfg::get_vdev(
                       bit is_ldb,
                       int pp
                     );
  `uvm_info("HQM_CFG",$psprintf("HQM%0s__get_vdev: is_ldb=%0d, pp=%0d, hqm_iov_mode=%0s", inst_suffix, is_ldb, pp, hqm_iov_mode),UVM_HIGH)
  `uvm_info("HQM_CFG",$psprintf("HQM%0s__get_vdev: ldb_pp_cq_cfg[%0d].vdev=%0d", inst_suffix, pp, ldb_pp_cq_cfg[pp].vdev),UVM_HIGH)
  `uvm_info("HQM_CFG",$psprintf("HQM%0s__get_vdev: dir_pp_cq_cfg[%0d].vdev=%0d", inst_suffix, pp, dir_pp_cq_cfg[pp].vdev),UVM_HIGH)
  if (hqm_iov_mode == HQM_SCIOV_MODE) begin
    if (is_ldb) begin
      return(ldb_pp_cq_cfg[pp].vdev);
    end else begin
      return(dir_pp_cq_cfg[pp].vdev);
    end 
  end else begin
    return(-1);
  end 
endfunction

function int hqm_cfg::get_pasid(
                        bit is_ldb,
                        int pp
                      );
  if (is_ldb) begin
    return(ldb_pp_cq_cfg[pp].pasid);
  end else begin
    return(dir_pp_cq_cfg[pp].pasid);
  end 
endfunction

function int hqm_cfg::get_vas(
                               bit is_ldb,
                               int pp
                             );
  if (is_ldb) begin
    return(ldb_pp_cq_cfg[pp].vas);
  end else begin
    return(dir_pp_cq_cfg[pp].vas);
  end 
endfunction : get_vas
	  	 
function int hqm_cfg::get_vasfromcq(
                               bit is_ldb,
                               int cq
                             );
  if (is_ldb) begin
    return(ldb_pp_cq_cfg[cq].vas);
  end else begin
    return(dir_pp_cq_cfg[cq].vas);
  end 
endfunction : get_vasfromcq

function int hqm_cfg::get_cq_depth(
                               bit is_ldb,
                               int cq
                             );
  if (is_ldb) begin
    return(4 * (1 << ldb_pp_cq_cfg[cq].cq_depth));
  end else begin
    return(4 * (1 << dir_pp_cq_cfg[cq].cq_depth));
  end 
endfunction : get_cq_depth

//----------------------------------------------------------------------------
//-- convert2string
//----------------------------------------------------------------------------
function string hqm_cfg::convert2string();
  string        tmp_str;

  tmp_str = "";

    foreach (dir_pp_cq_cfg[i]) begin
      tmp_str = {tmp_str,$psprintf("Directed CQ 0x%02x\n",i)};
      tmp_str = {tmp_str,$psprintf("  hist_list base=0x%04x limit=0x%05x\n",
                                   dir_pp_cq_cfg[i].hist_list_base,
                                   dir_pp_cq_cfg[i].hist_list_limit)};
      tmp_str = {tmp_str,$psprintf("  cq_depth=%s intr_thresh=0x%04x\n",
                                   dir_pp_cq_cfg[i].cq_depth.name(),
                                   dir_pp_cq_cfg[i].cq_depth_intr_thresh)};

      for (int j = 0 ; j < 8 ; j++) begin
        tmp_str = {tmp_str,$psprintf("  qidix %d qidv=%d qid=0x%02x pri=%d\n",
                                     j,
                                     dir_pp_cq_cfg[i].qidix[j].qidv,
                                     dir_pp_cq_cfg[i].qidix[j].qid,
                                     dir_pp_cq_cfg[i].qidix[j].pri)};
      end 
    end 

    foreach (ldb_pp_cq_cfg[i]) begin
      tmp_str = {tmp_str,$psprintf("Load Balanced CQ 0x%02x\n",i)};
      tmp_str = {tmp_str,$psprintf("  hist_list base=0x%04x limit=0x%05x\n",
                                   ldb_pp_cq_cfg[i].hist_list_base,
                                   ldb_pp_cq_cfg[i].hist_list_limit)};
      tmp_str = {tmp_str,$psprintf("  cq_depth=%s intr_thresh=0x%04x\n",
                                   ldb_pp_cq_cfg[i].cq_depth.name(),
                                   ldb_pp_cq_cfg[i].cq_depth_intr_thresh)};

      for (int j = 0 ; j < 8 ; j++) begin
        tmp_str = {tmp_str,$psprintf("  qidix %d qidv=%d qid=0x%02x pri=%d\n",
                                     j,
                                     ldb_pp_cq_cfg[i].qidix[j].qidv,
                                     ldb_pp_cq_cfg[i].qidix[j].qid,
                                     ldb_pp_cq_cfg[i].qidix[j].pri)};
      end 
    end 

    foreach (ldb_qid_cfg[i]) begin
      tmp_str = {tmp_str,$psprintf("Load Balanced QID 0x%02x\n",i)};
      tmp_str = {tmp_str,$psprintf("  uno_ord enq_hcw_rpt_thresh=0x%04x inflight_limit=0x%04x\n",
                                   ldb_qid_cfg[i].uno_ord_enq_hcw_rpt_thresh,
                                   ldb_qid_cfg[i].uno_ord_inflight_limit)};
      tmp_str = {tmp_str,$psprintf("  atq enq_hcw_rpt_thresh=0x%04x inflight_limit=0x%04x\n",
                                   ldb_qid_cfg[i].atq_enq_hcw_rpt_thresh,
                                   ldb_qid_cfg[i].atq_inflight_limit)};
      tmp_str = {tmp_str,$psprintf("  dir enq_hcw_rpt_thresh=0x%04x\n",
                                   ldb_qid_cfg[i].dir_enq_hcw_rpt_thresh)};
      tmp_str = {tmp_str,$psprintf("  aqed freelist base=0x%04x limit=0x%04x\n",
                                   ldb_qid_cfg[i].aqed_freelist_base,
                                   ldb_qid_cfg[i].aqed_freelist_limit)};
    end 

    foreach (dir_qid_cfg[i]) begin
      tmp_str = {tmp_str,$psprintf("Directed QID 0x%02x\n",i)};
      tmp_str = {tmp_str,$psprintf("  uno_ord enq_hcw_rpt_thresh=0x%04x inflight_limit=0x%04x\n",
                                   dir_qid_cfg[i].uno_ord_enq_hcw_rpt_thresh,
                                   dir_qid_cfg[i].uno_ord_inflight_limit)};
      tmp_str = {tmp_str,$psprintf("  atq enq_hcw_rpt_thresh=0x%04x inflight_limit=0x%04x\n",
                                   dir_qid_cfg[i].atq_enq_hcw_rpt_thresh,
                                   dir_qid_cfg[i].atq_inflight_limit)};
      tmp_str = {tmp_str,$psprintf("  dir enq_hcw_rpt_thresh=0x%04x\n",
                                   dir_qid_cfg[i].dir_enq_hcw_rpt_thresh)};
      tmp_str = {tmp_str,$psprintf("  aqed freelist base=0x%04x limit=0x%04x\n",
                                   dir_qid_cfg[i].aqed_freelist_base,
                                   dir_qid_cfg[i].aqed_freelist_limit)};
    end 

    return tmp_str;
  
endfunction : convert2string

//----------------------------------------------------------------------------
//-- do_print
//----------------------------------------------------------------------------
function void hqm_cfg::do_print(uvm_printer printer);
  super.do_print(printer);

  if (printer.knobs.sprint == 0) begin
    $display(convert2string());
  end else begin
    printer.m_string = convert2string();
  end 
endfunction

//----------------------------------------------------------------------------
//-- do_copy
//----------------------------------------------------------------------------
function void hqm_cfg::do_copy(uvm_object rhs);
    hqm_cfg rhs_;
    
    if (!$cast(rhs_, rhs)) begin
       uvm_report_error(get_full_name(), $psprintf("HQM%0s__input is not a hqm_cfg",inst_suffix));
    end 

    super.do_copy(this);

    foreach (dir_pp_cq_cfg[i]) begin
      dir_pp_cq_cfg[i] = rhs_.dir_pp_cq_cfg[i];
    end 

    foreach (ldb_pp_cq_cfg[i]) begin
      ldb_pp_cq_cfg[i] = rhs_.ldb_pp_cq_cfg[i];
    end 

    foreach (ldb_qid_cfg[i]) begin
      ldb_qid_cfg[i] = rhs_.ldb_qid_cfg[i];
    end 

    foreach (dir_qid_cfg[i]) begin
      dir_qid_cfg[i] = rhs_.dir_qid_cfg[i];
    end 

endfunction

  
 
//----------------------------------------------------------------------------
//-- do_compare
//----------------------------------------------------------------------------
function   bit    hqm_cfg::do_compare(uvm_object rhs, uvm_comparer comparer);

    hqm_cfg that;

    if (!$cast(that, rhs)) begin
      return 0;
    end 

endfunction
	    
//----------------------------------------------------------------------------
//-- 
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::sysrst_command_handler(hqm_cfg_command command);
    sysrst_command_handler = HQM_CFG_CMD_NOT_DONE;

endfunction

//----------------------------------------------------------------------------
//-- 
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_cfg::runtest_command_handler(hqm_cfg_command command);
    runtest_command_handler = HQM_CFG_CMD_NOT_DONE;

endfunction
	
function int hqm_cfg::reserve_pp(int is_ldb, int exp_pp=-1);
    if(is_ldb == 0)begin
        if (avail_dir_pp.size() > 0) begin
            if(exp_pp == -1)begin
                int idx = $urandom_range(avail_dir_pp.size()-1,0);
                reserve_pp = avail_dir_pp[idx];
                avail_dir_pp.delete(idx);
            end else begin
                int idx[$] = avail_dir_pp.find_index with (item == exp_pp);
                if(idx.size > 0)begin
                    reserve_pp = avail_dir_pp[(idx[0])];
                    avail_dir_pp.delete(idx[0]);
                end else
//                    reserve_pp = -1;
                    reserve_pp = exp_pp;
            end 
        end else
            reserve_pp = -1;
    end else begin
        if (avail_ldb_pp.size() > 0) begin
            if(exp_pp == -1)begin
                int idx = $urandom_range(avail_ldb_pp.size()-1,0);
                reserve_pp = avail_ldb_pp[idx];
                avail_ldb_pp.delete(idx);
            end else begin
                int idx[$] = avail_ldb_pp.find_index with (item == exp_pp);
                if(idx.size > 0)begin
                    reserve_pp = avail_ldb_pp[(idx[0])];
                    avail_ldb_pp.delete(idx[0]);
                end else
//                    reserve_pp = -1;
                    reserve_pp = exp_pp;
            end 
        end else
            reserve_pp = -1;
    end 
endfunction: reserve_pp;

function hqm_cfg::release_pp(int is_ldb, int pp_id);
    if(is_ldb == 0)
        avail_dir_pp.push_back(pp_id);
    else
        avail_ldb_pp.push_back(pp_id);
endfunction: release_pp;

function int hqm_cfg::reserve_cq(int is_ldb, int exp_cq=-1);
    if(is_ldb == 0)begin
        if (avail_dir_cq.size() > 0) begin
            if(exp_cq == -1)begin
                int idx = $urandom_range(avail_dir_cq.size()-1,0);
                reserve_cq = avail_dir_cq[idx];
                avail_dir_cq.delete(idx);
            end else begin
                int idx[$] = avail_dir_cq.find_index with (item == exp_cq);
                if(idx.size > 0)begin
                    reserve_cq = avail_dir_cq[(idx[0])];
                    avail_dir_cq.delete(idx[0]);
                end else
//                    reserve_cq = -1;
                    reserve_cq = exp_cq;
            end 
        end else
            reserve_cq = -1;
    end else begin
        if (avail_ldb_cq.size() > 0) begin
            if(exp_cq == -1)begin
                int idx = $urandom_range(avail_ldb_cq.size()-1,0);
                reserve_cq = avail_ldb_cq[idx];
                cq2q_map_cnt[reserve_cq] = (cq2q_map_cnt.exists(reserve_cq)) ? (cq2q_map_cnt[reserve_cq] + 1) : 1;
                if(cq2q_map_cnt[reserve_cq] >= 8)
                    avail_ldb_cq.delete(idx);
            end else begin
                int idx[$] = avail_ldb_cq.find_index with (item == exp_cq);
                if(idx.size > 0)begin
                    reserve_cq = avail_ldb_cq[(idx[0])];
                    cq2q_map_cnt[reserve_cq] = (cq2q_map_cnt.exists(reserve_cq)) ? (cq2q_map_cnt[reserve_cq] + 1) : 1;
                    if(cq2q_map_cnt[reserve_cq] >= 8)
                        avail_ldb_cq.delete(idx[0]);
                end else
//                    reserve_cq = -1;
                    reserve_cq = exp_cq;
            end 
        end else
            reserve_cq = -1;
    end 
endfunction: reserve_cq;

function hqm_cfg::release_cq(int is_ldb, int cq_id);
    if(is_ldb == 0)
        avail_dir_cq.push_back(cq_id);
    else
        avail_ldb_cq.push_back(cq_id);
endfunction: release_cq;

function int hqm_cfg::reserve_qid(int is_ldb, int exp_qid=-1);
    if(is_ldb == 0)begin
        if (avail_dir_qid.size() > 0) begin
            if(exp_qid == -1)begin
                int idx = $urandom_range(avail_dir_qid.size()-1,0);
                reserve_qid = avail_dir_qid[idx];
                avail_dir_qid.delete(idx);
            end else begin
                int idx[$] = avail_dir_qid.find_index with (item == exp_qid);
                if(idx.size > 0)begin
                    reserve_qid = avail_dir_qid[(idx[0])];
                    avail_dir_qid.delete(idx[0]);
                end else
//                    reserve_qid = -1;
                    reserve_qid = exp_qid;
            end 
        end else
            reserve_qid = -1;
    end else begin
        if (avail_ldb_qid.size() > 0) begin
            if(exp_qid == -1)begin
                int idx = $urandom_range(avail_ldb_qid.size()-1,0);
                reserve_qid = avail_ldb_qid[idx];
                avail_ldb_qid.delete(idx);
            end else begin
                int idx[$] = avail_ldb_qid.find_index with (item == exp_qid);
                if(idx.size > 0)begin
                    reserve_qid = avail_ldb_qid[(idx[0])];
                    avail_ldb_qid.delete(idx[0]);
                end else
//                    reserve_qid = -1;
                    reserve_qid = exp_qid;
            end 
        end else
            reserve_qid = -1;
    end 
endfunction: reserve_qid;

function hqm_cfg::release_qid(int is_ldb, int qid_id);
    if(is_ldb == 0)
        avail_dir_qid.push_back(qid_id);
    else
        avail_ldb_qid.push_back(qid_id);
endfunction: release_qid;

function hqm_cfg::get_avail_resources(int is_ldb, string res);
    case(res)
        "pp": begin
            get_avail_resources = (is_ldb)? avail_ldb_pp.size(): avail_dir_pp.size();
        end 
        "cq": begin
            get_avail_resources = (is_ldb)? avail_ldb_cq.size(): avail_dir_cq.size();
        end 
        "qid": begin
            get_avail_resources = (is_ldb)? avail_ldb_qid.size(): avail_dir_qid.size();
        end 
        "vdev": begin
            get_avail_resources = avail_vdev.size();
        end 
        default: begin
            `uvm_error("HQM_CFG",$psprintf("HQM%0s__Invalid resource release call", inst_suffix));
        end 
    endcase
endfunction:get_avail_resources;

function int hqm_cfg::reserve_vpp(int is_ldb, int vf, int u_vpp = -1, int pp = -1);
    int i, sel_vpp, vpp[$];
    if(is_ldb == 0)begin
        if(u_vpp == -1) begin 
            for(int i = 0 ; i < hqm_pkg::NUM_DIR_PP; i++) begin
                if(vf_cfg[vf].dir_vpp_cfg[i].vpp_v == 0)
                    vpp.push_back(i);
            end 
        end else
            vpp[0] = u_vpp;

        i = $urandom_range((vpp.size() -1));
        sel_vpp = vpp[i];
        if(vf_cfg[vf].dir_vpp_cfg[sel_vpp].vpp_v == 1)
			`uvm_warning(get_name(),$psprintf("HQM%0s__For DIR POOL VF <%0d> VPP <%0d> is already allocated", inst_suffix,vf, sel_vpp));
        vf_cfg[vf].dir_vpp_cfg[sel_vpp].provisioned = 1;
        vf_cfg[vf].dir_vpp_cfg[sel_vpp].enable  = 1;
        vf_cfg[vf].dir_vpp_cfg[sel_vpp].vpp_v   = 1;
        vf_cfg[vf].dir_vpp_cfg[sel_vpp].pp      = pp;
    end else begin
        if(u_vpp == -1) begin 
            for(int i = 0 ; i < hqm_pkg::NUM_LDB_PP; i++) begin
                if(vf_cfg[vf].ldb_vpp_cfg[i].vpp_v == 0)
                    vpp.push_back(i);
            end 
        end else
            vpp[0] = u_vpp;

        i = $urandom_range((vpp.size() -1));
        sel_vpp = vpp[i];
        if(vf_cfg[vf].ldb_vpp_cfg[sel_vpp].vpp_v == 1)
			`uvm_warning(get_name(),$psprintf("For LDB POOL VF <%0d> VPP <%0d> is already allocated", inst_suffix,vf, sel_vpp));
        vf_cfg[vf].ldb_vpp_cfg[sel_vpp].provisioned = 1;
        vf_cfg[vf].ldb_vpp_cfg[sel_vpp].enable  = 1;
        vf_cfg[vf].ldb_vpp_cfg[sel_vpp].vpp_v   = 1;
        vf_cfg[vf].ldb_vpp_cfg[sel_vpp].pp      = pp;
    end 
    return sel_vpp;

endfunction: reserve_vpp;

function int hqm_cfg::reserve_vcq(int is_ldb, int vf, int u_vcq = -1, int cq = -1);
    int i, sel_vcq, vcq[$];
    if(is_ldb == 0)begin
        sel_vcq = cq;
    end else begin
        if(u_vcq == -1) begin 
            for(int i = 0 ; i < hqm_pkg::NUM_LDB_QID; i++) begin
              vcq.push_back(i);
            end 
        end else
            vcq[0] = u_vcq;

        i = $urandom_range((vcq.size() -1));
        sel_vcq = vcq[i];
    end 
    return sel_vcq;
endfunction: reserve_vcq;

 function int hqm_cfg::reserve_vqid(int is_ldb, int vf, int u_vqid = -1, int qid = -1);
    int i, sel_vqid, vqid[$];
    if(is_ldb == 0)begin
        if(u_vqid == -1) begin 
            for(int i = 0 ; i < hqm_pkg::NUM_DIR_QID ; i++) begin
                if(vf_cfg[vf].dir_vqid_cfg[i].vqid_v == 0)
                    vqid.push_back(i);
            end 
        end else
            vqid[0] = u_vqid;

        i = $urandom_range((vqid.size() -1));
        sel_vqid = vqid[i];
        if(vf_cfg[vf].dir_vqid_cfg[sel_vqid].vqid_v == 1)
			`uvm_error(get_name(),$psprintf("For DIR POOL VF <%0d> VQID <%0d> is already allocated", inst_suffix,vf, sel_vqid));
        vf_cfg[vf].dir_vqid_cfg[sel_vqid].provisioned = 1;
        vf_cfg[vf].dir_vqid_cfg[sel_vqid].enable = 1;
        vf_cfg[vf].dir_vqid_cfg[sel_vqid].vqid_v = 1; 
        vf_cfg[vf].dir_vqid_cfg[sel_vqid].qid    = qid;
    end else begin
        if(u_vqid == -1) begin 
            for(int i = 0 ; i < hqm_pkg::NUM_LDB_QID ; i++) begin
                if(vf_cfg[vf].ldb_vqid_cfg[i].vqid_v == 0)
                    vqid.push_back(i);
            end 
        end else
            vqid[0] = u_vqid;

        i = $urandom_range((vqid.size() -1));
        sel_vqid = vqid[i];
        if(vf_cfg[vf].ldb_vqid_cfg[sel_vqid].vqid_v == 1)
			`uvm_error(get_name(),$psprintf("HQM%0s__For LDB POOL VF <%0d> VQID <%0d> is already allocated", inst_suffix,vf, sel_vqid));
        vf_cfg[vf].ldb_vqid_cfg[sel_vqid].provisioned = 1;
        vf_cfg[vf].ldb_vqid_cfg[sel_vqid].enable  = 1;
        vf_cfg[vf].ldb_vqid_cfg[sel_vqid].vqid_v  = 1;
        vf_cfg[vf].ldb_vqid_cfg[sel_vqid].qid     = qid;
    end 
    return sel_vqid;
 endfunction: reserve_vqid;

//----------------------------------------------------------------------------
// Allocates PP address or returns set PP address value
// In PF mode if uaddr_val is -1 it will randomize the PP address.
// In PF mode if uaddr_val is  0 it will return the PP address.
// In PF mode is uaddr_val is any other value, it will try to allocate that
// address space in system memory
// When VF is enabled, (non negative vfid val)
// This function will always return the allocated PP's address in give VFs bar space
//----------------------------------------------------------------------------
 function  longint hqm_cfg::get_pp_address(int ppid, int is_ldb=0, int is_nm_pf=0, int vfid=-1);
    longint addr = 64'h0000_0000_0000_0000;
    uvm_reg     my_reg;
    uvm_reg_data_t  ral_data;
    hqm_cfg_command_options opt = new();
    int idx;

    ral_data    = func_bar_u_reg.get();
    addr[63:32] = ral_data[31:0];
    ral_data    = func_bar_l_addr_l_field.get();
    addr[31:26] = ral_data[5:0];
    addr[19:12] = ppid;
    addr[20]    = is_ldb;
    addr[21]    = is_nm_pf;
    addr += 64'h0000_0000_0200_0000;

    return addr;
 endfunction: get_pp_address;

//----------------------------------------------------------------------------
//-- decode_func_pf_addr
//--   - return value of 1 if address lies in func_pf_bar space
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_func_pf_addr(input logic [63:0] address);

  bit [63:0] func_pf_bar;

  decode_func_pf_addr = 1'b0;

  func_pf_bar[63:32] = func_bar_u_reg.get_mirrored_value();
  func_pf_bar[31:26] = func_bar_l_addr_l_field.get_mirrored_value();

  uvm_report_info("DEBUG_HQM_CFG", $psprintf("HQM%0s__tb_env_hier=%s__decode_func_pf_addr: addr=0x%0x func_pf_bar=0x%0x", inst_suffix, tb_env_hier, address, func_pf_bar), UVM_MEDIUM);
  if ( (address >= func_pf_bar) && ( address < (func_pf_bar + 64'h400_0000) ) ) begin
      decode_func_pf_addr = 1'b1;
  end 

endfunction : decode_func_pf_addr

//----------------------------------------------------------------------------
//-- decode_csr_pf_addr
//--   - return value of 1 if address lies in csr_pf_bar space
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_csr_pf_addr(input logic [63:0] address);

  bit [63:0] csr_pf_bar;

  decode_csr_pf_addr = 1'b0;

  csr_pf_bar[63:32] = get_act_ral_val("hqm_pf_cfg_i", "csr_bar_u", "");

  uvm_report_info("DEBUG_HQM_CFG", $psprintf("HQM%0s__tb_env_hier=%s__decode_csr_pf_addr: addr=0x%0x csr_pf_bar=0x%0x", inst_suffix, tb_env_hier, address, csr_pf_bar), UVM_MEDIUM);
  if ( (address >= csr_pf_bar) && ( address < (csr_pf_bar + 64'h1_0000_0000) ) ) begin
      decode_csr_pf_addr = 1'b1;
  end 

endfunction : decode_csr_pf_addr


//----------------------------------------------------------------------------
//-- decode_pf_cfg_addr
//--   - return value of 1 if address lies in pf cfg space
//----------------------------------------------------------------------------
function bit hqm_cfg::decode_pf_cfg_addr(input logic [63:0] address);

  decode_pf_cfg_addr = 1'b0;

  if ( (address[23:0] >= 'h0) && (address[23:0] < 64'h1000 ) ) begin
      decode_pf_cfg_addr = 1'b1;
  end 

endfunction : decode_pf_cfg_addr

function bit hqm_cfg::is_pad_first_write (bit is_ldb);

    is_pad_first_write = 1'b0;
    if (is_ldb) begin
        is_pad_first_write = pad_first_write_ldb;
    end else begin
        is_pad_first_write = pad_first_write_dir;
    end 

endfunction : is_pad_first_write

function bit hqm_cfg::is_pad_write (bit is_ldb);

    is_pad_write = 1'b0;
    if (is_ldb) begin
        is_pad_write = pad_write_ldb;
    end else begin
        is_pad_write = pad_write_dir;
    end 

endfunction : is_pad_write

function bit hqm_cfg::is_early_dir_int();
    is_early_dir_int = early_dir_int;
endfunction : is_early_dir_int

function bit hqm_cfg::is_disable_wb_opt(bit is_ldb, int cq);

    if (is_ldb) begin
        `uvm_error(get_full_name(), $psprintf("HQM%0s__is_ldb(%0b) bit set to 1, not a legal value for disable_wb_opt", inst_suffix,is_ldb))
        is_disable_wb_opt = 1'b0;
    end else begin
        if ( !( (cq >=0 ) && (cq <= hqm_pkg::NUM_DIR_CQ) ) ) begin
            `uvm_error(get_full_name(), $psprintf("HQM%0s__Not a legal DIR CQ (0x%0x) value", inst_suffix,cq))
            is_disable_wb_opt = 1'b0;
        end else begin
            is_disable_wb_opt = dir_pp_cq_cfg[cq].disable_wb_opt;
        end 
    end 

endfunction : is_disable_wb_opt

//--support max_cacheline_num 
function void hqm_cfg::set_max_cacheline_num(bit is_ldb,  int pp, int max_cacheline_num, int start_cl_addr);
    if(is_ldb) begin
       if(pp <= hqm_pkg::NUM_LDB_CQ) begin 
         //--max_cacheline support
         ldb_pp_cq_cfg[pp].cl_check                    = (max_cacheline_num>1)? 1 : 0;
         ldb_pp_cq_cfg[pp].cl_cnt                      = start_cl_addr; //0;
         ldb_pp_cq_cfg[pp].cl_max                      = max_cacheline_num;
         ldb_pp_cq_cfg[pp].cl_addr                     = start_cl_addr; //0;
         uvm_report_info("HQM_CFG", $psprintf("HQM%0s__set_max_cacheline_num:ldb_pp_cq_cfg[%0d].cl_max=%0d cl_check=%0d", inst_suffix,pp, ldb_pp_cq_cfg[pp].cl_max, ldb_pp_cq_cfg[pp].cl_check), UVM_LOW);     
       end else begin
          `uvm_error(get_full_name(), $psprintf("HQM%0s__set_max_cacheline_num: Not a legal LDB PP (0x%0x) value", inst_suffix,pp))
       end 
    end else begin
       if(pp <= hqm_pkg::NUM_DIR_CQ) begin 
         //--max_cacheline support
         dir_pp_cq_cfg[pp].cl_check                    = (max_cacheline_num>1)? 1 : 0;
         dir_pp_cq_cfg[pp].cl_cnt                      = start_cl_addr; //0;
         dir_pp_cq_cfg[pp].cl_max                      = max_cacheline_num;
         dir_pp_cq_cfg[pp].cl_addr                     = start_cl_addr; //0;
         uvm_report_info("HQM_CFG", $psprintf("HQM%0s__set_max_cacheline_num:dir_pp_cq_cfg[%0d].cl_max=%0d cl_check=%0d", inst_suffix,pp, dir_pp_cq_cfg[pp].cl_max, dir_pp_cq_cfg[pp].cl_check), UVM_LOW);     
       end else begin
          `uvm_error(get_full_name(), $psprintf("HQM%0s__set_max_cacheline_num: Not a legal DIR PP (0x%0x) value", inst_suffix,pp))
       end 
    end 
endfunction : set_max_cacheline_num

//--support max_cacheline_num 
function int hqm_cfg::get_max_cacheline_num(bit is_ldb,  int pp);
    if(is_ldb) begin
       if(pp <= hqm_pkg::NUM_LDB_CQ) begin 
         get_max_cacheline_num = ldb_pp_cq_cfg[pp].cl_max;
         uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_max_cacheline_num:ldb_pp_cq_cfg[%0d].cl_max=%0d cl_check=%0d", inst_suffix,pp, ldb_pp_cq_cfg[pp].cl_max, ldb_pp_cq_cfg[pp].cl_check), UVM_LOW);     
       end else begin
          `uvm_error(get_full_name(), $psprintf("HQM%0s__get_max_cacheline_num: Not a legal LDB PP (0x%0x) value", inst_suffix,pp))
       end 
    end else begin
       if(pp <= hqm_pkg::NUM_DIR_CQ) begin 
         get_max_cacheline_num = dir_pp_cq_cfg[pp].cl_max;
         uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_max_cacheline_num:dir_pp_cq_cfg[%0d].cl_max=%0d cl_check=%0d", inst_suffix,pp, dir_pp_cq_cfg[pp].cl_max, dir_pp_cq_cfg[pp].cl_check), UVM_LOW);     
       end else begin
          `uvm_error(get_full_name(), $psprintf("HQM%0s__get_max_cacheline_num: Not a legal DIR PP (0x%0x) value", inst_suffix,pp))
       end 
    end 
endfunction : get_max_cacheline_num

//--support cl_rob 
function int hqm_cfg::get_cl_rob(bit is_ldb,  int pp);
    if(is_ldb) begin
       if(pp <= hqm_pkg::NUM_LDB_CQ) begin 
         get_cl_rob = ldb_pp_cq_cfg[pp].cl_rob;
         uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_cl_rob:ldb_pp_cq_cfg[%0d].cl_rob=%0d cl_check=%0d", inst_suffix,pp, ldb_pp_cq_cfg[pp].cl_rob, ldb_pp_cq_cfg[pp].cl_check), UVM_LOW);     
       end else begin
          `uvm_error(get_full_name(), $psprintf("HQM%0s__get_cl_rob: Not a legal LDB PP (0x%0x) value", inst_suffix,pp))
       end 
    end else begin
       if(pp <= hqm_pkg::NUM_DIR_CQ) begin 
         get_cl_rob = dir_pp_cq_cfg[pp].cl_rob;
         uvm_report_info("HQM_CFG", $psprintf("HQM%0s__get_cl_rob:dir_pp_cq_cfg[%0d].cl_rob=%0d cl_check=%0d", inst_suffix,pp, dir_pp_cq_cfg[pp].cl_rob, dir_pp_cq_cfg[pp].cl_check), UVM_LOW);     
       end else begin
          `uvm_error(get_full_name(), $psprintf("HQM%0s__get_cl_rob: Not a legal DIR PP (0x%0x) value", inst_suffix,pp))
       end 
    end 
endfunction : get_cl_rob


`endif

