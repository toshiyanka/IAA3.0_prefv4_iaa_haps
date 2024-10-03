`ifndef HQM_SURVIVABILITY_PATCH_SEQ_SV
`define HQM_SURVIVABILITY_PATCH_SEQ_SV

class hqm_survivability_patch_seq extends hqm_sla_pcie_base_seq;//sla_sequence_base;

    `ovm_sequence_utils(hqm_survivability_patch_seq, sla_sequencer)

    hqm_tb_hcw_cfg_seq                 i_hqm_tb_hcw_cfg_seq;
    hcw_perf_dir_ldb_test1_hcw_seq     i_hcw_perf_dir_ldb_test1_hcw_seq;
    hqm_sla_pcie_flr_sequence          flr_seq;
    hqm_sla_pcie_init_seq              pcie_init_seq;

    hqm_cfg                            cfg;
    sla_ral_env                        ral;

    sla_ral_reg                        survivability_regs[$];
    int                                interested_id[$];
    sla_ral_data_t                     survivability_field_typical_val[string];
    sla_ral_access_path_t              primary_id, access;
    int                                survivability_cfg_delay_min;
    int                                survivability_cfg_delay_max;
    int                                survi_field_num;
    int                                check_single_field;

    rand sla_ral_data_t                qed_to_cq_pipe_credit_hwm;
    rand sla_ral_data_t                egress_pipe_credit_hwm;
    rand sla_ral_data_t                rop_pipe_credit_hwm;
    rand sla_ral_data_t                lsp_tok_pipe_credit_hwm;
    rand sla_ral_data_t                lsp_ap_cmp_pipe_credit_hwm;
    rand sla_ral_data_t                outbound_hcw_pipe_credit_hwm;
    rand sla_ral_data_t                atm_pipe_credits;
    rand sla_ral_data_t                nalb_pipe_credits;
    rand sla_ral_data_t                ldb_single_op;
    rand sla_ral_data_t                lbrpl_single_out;
    rand sla_ral_data_t                lbrpl_half_bw;
    rand sla_ral_data_t                lbrpl_single_op;
    rand sla_ral_data_t                dirrpl_single_out;
    rand sla_ral_data_t                dirrpl_half_bw;
    rand sla_ral_data_t                dirrpl_single_op;
    rand sla_ral_data_t                atq_disab_multi;
    rand sla_ral_data_t                atq_single_out;
    rand sla_ral_data_t                atq_half_bw;
    rand sla_ral_data_t                atq_single_op;
    rand sla_ral_data_t                dir_disab_multi;
    rand sla_ral_data_t                dir_single_out;
    rand sla_ral_data_t                dir_half_bw;
    rand sla_ral_data_t                dir_single_op;
    rand sla_ral_data_t                inc_cmp_unit_idle;
    rand sla_ral_data_t                disab_rlist_pri;
    rand sla_ral_data_t                inc_tok_unit_idle;
    rand sla_ral_data_t                disab_atq_empty_arb;
    rand sla_ral_data_t                disable_wb_opt;
    rand sla_ral_data_t                write_single_beats;
    //-- HQMV30 removed ZERO_CL_START   rand sla_ral_data_t                zero_cl_start;
    rand sla_ral_data_t                enq_rate_limit;
    rand sla_ral_data_t                sch_rate_limit;
    //rand sla_ral_data_t                clkgate_enable;
    rand sla_ral_data_t                idle_count;
    rand sla_ral_data_t                clkgate_disabled;
    rand sla_ral_data_t                clkreq_ctl_disabled;
    //rand sla_ral_data_t                clkgate_holdoff;
    rand sla_ral_data_t                pwrgate_holdoff;
    //rand sla_ral_data_t                clkreq_off_holdoff;
    //rand sla_ral_data_t                clkreq_syncoff_holdoff;
    rand sla_ral_data_t                pwrgate_pmc_wake;
    rand sla_ral_data_t                override_clk_switch_control;
    rand sla_ral_data_t                override_pmsm_pgcb_req_b;
    rand sla_ral_data_t                override_pm_cfg_control;
    rand sla_ral_data_t                override_fet_en_b;
    rand sla_ral_data_t                ignore_pipe_busy;
    rand sla_ral_data_t                cfg_enable_unit_idle;
    rand sla_ral_data_t                cfg_pm_allow_ing_drop;
    rand sla_ral_data_t                cfg_enable_alarms;
    rand sla_ral_data_t                cfg_disable_ring_par_ck;
    rand sla_ral_data_t                aqed_chicken_onepri;
    rand sla_ral_data_t                aqed_lsp_stop_atqatm;
    rand sla_ral_data_t                fid_sim;
    rand sla_ral_data_t                fid_decrement;
    rand sla_ral_data_t                chicken_50;
    rand sla_ral_data_t                chicken_sim;
    rand sla_ral_data_t                chicken_max_enqstall;
    rand sla_ral_data_t                chicken_en_enqblockrlst;
    rand sla_ral_data_t                chicken_en_alwaysblast;
    rand sla_ral_data_t                chicken_dis_enq_afull_hp_mode;
    rand sla_ral_data_t                chicken_dis_enqstall;
    rand sla_ral_data_t                chicken_25;
    rand sla_ral_data_t                chicken_33;
    rand sla_ral_data_t                fid_enq;
    rand sla_ral_data_t                fid_push;
    rand sla_ral_data_t                aqed_chp_sch;
    rand sla_ral_data_t                aqed_ap_enq;
    rand sla_ral_data_t                ap_lsp_enq;
    rand sla_ral_data_t                nalb_qed_atq;
    rand sla_ral_data_t                nalb_lsp_enq_lb_atq;
    rand sla_ral_data_t                nalb_qed_rorply;
    rand sla_ral_data_t                nalb_lsp_enq_lb_rorply;
    rand sla_ral_data_t                nalb_qed_lb;
    rand sla_ral_data_t                nalb_lsp_enq_lb;
    rand sla_ral_data_t                credits;
    rand sla_ral_data_t                dp_dqed_rorply;
    rand sla_ral_data_t                dp_lsp_enq_dir_rorply;
    rand sla_ral_data_t                dp_dqed_dir;
    rand sla_ral_data_t                dp_lsp_enq_dir;
    rand sla_ral_data_t                pad_first_write_ldb;
    rand sla_ral_data_t                pad_first_write_dir;


  
  constraint survivability_field_vals_c {

      qed_to_cq_pipe_credit_hwm    inside{'h_1};
      egress_pipe_credit_hwm    inside{'h_1};
      rop_pipe_credit_hwm    inside{'h_1};
      lsp_tok_pipe_credit_hwm    inside{'h_1};
      lsp_ap_cmp_pipe_credit_hwm    inside{'h_1};
      outbound_hcw_pipe_credit_hwm    inside{'h_1};
      atm_pipe_credits    inside{'h_1};
      nalb_pipe_credits    inside{'h_1};
      ldb_single_op    inside{'h_1};
      lbrpl_single_out    inside{'h_1};
      lbrpl_half_bw    inside{'h_1};
      lbrpl_single_op    inside{'h_1};
      dirrpl_single_out    inside{'h_1};
      dirrpl_half_bw    inside{'h_1};
      dirrpl_single_op    inside{'h_1};
      atq_disab_multi    inside{'h_1};
      atq_single_out    inside{'h_1};
      atq_half_bw    inside{'h_1};
      atq_single_op    inside{'h_1};
      dir_disab_multi    inside{'h_1};
      dir_single_out    inside{'h_1};
      dir_half_bw    inside{'h_1};
      dir_single_op    inside{'h_1};
      inc_cmp_unit_idle    inside{'h_1};
      disab_rlist_pri    inside{'h_1};
      inc_tok_unit_idle    inside{'h_1};
      disab_atq_empty_arb    inside{'h_1};
      disable_wb_opt    inside{'h_1};
      write_single_beats    inside{'h_1};
      //-- HQMV30 removed ZERO_CL_START   zero_cl_start    inside{'h_1};
      enq_rate_limit    inside{'h_3ff};
      sch_rate_limit    inside{'h_7f};
      //clkgate_enable    inside{'h_0};
      idle_count    inside{8'h_11};//inside{'h_0};
      clkgate_disabled    inside{'h_1};
      clkreq_ctl_disabled    inside{'h_1};
      //clkgate_holdoff    inside{'h_5};
      pwrgate_holdoff    inside{'h_5};
      //clkreq_off_holdoff    inside{'h_5};
      //clkreq_syncoff_holdoff    inside{'h_5};
      pwrgate_pmc_wake    inside{'h_0};
      override_clk_switch_control    inside{'h_7};
      override_pmsm_pgcb_req_b    inside{'h_2};
      override_pm_cfg_control    inside{'h_2};
      override_fet_en_b    inside{'h_2};
      ignore_pipe_busy    inside{'h_0}; // changed value to 0 as per designer suggestion in this HSD# https://hsdes.intel.com/resource/1608322964
      cfg_enable_unit_idle    inside{'h_0};
      cfg_pm_allow_ing_drop    inside{'h_0};
      cfg_enable_alarms    inside{'h_0};
      cfg_disable_ring_par_ck    inside{'h_1};
      aqed_chicken_onepri    inside{'h_1};
      aqed_lsp_stop_atqatm    inside{'h_1};
      fid_sim    inside{'h_1};
      fid_decrement    inside{'h_1};
      chicken_50    inside{'h_1};
      chicken_sim    inside{'h_1};
      chicken_max_enqstall    inside{'h_1};
      chicken_en_enqblockrlst    inside{'h_1};
      chicken_en_alwaysblast    inside{'h_1};
      chicken_dis_enq_afull_hp_mode    inside{'h_1};
      chicken_dis_enqstall    inside{'h_1};
      chicken_25    inside{'h_1};
      chicken_33    inside{'h_1};
      fid_enq    inside{'h_1};
      fid_push    inside{'h_1};
      aqed_chp_sch    inside{'h_1};
      aqed_ap_enq    inside{'h_1};
      ap_lsp_enq    inside{'h_1};
      nalb_qed_atq    inside{'h_1};
      nalb_lsp_enq_lb_atq    inside{'h_1};
      nalb_qed_rorply    inside{'h_1};
      nalb_lsp_enq_lb_rorply    inside{'h_1};
      nalb_qed_lb    inside{'h_1};
      nalb_lsp_enq_lb    inside{'h_1};
      credits    inside{'h_1};
      dp_dqed_rorply    inside{'h_1};
      dp_lsp_enq_dir_rorply    inside{'h_1};
      dp_dqed_dir    inside{'h_1};
      dp_lsp_enq_dir    inside{'h_1};
      pad_first_write_ldb    inside{'h_1};
      pad_first_write_dir    inside{'h_1};

  }
  function new(string name = "hqm_survivability_patch_seq");
    super.new(name);
    primary_id  = iosf_sb_sla_pkg::get_src_type();
  endfunction

  extern virtual task body();
  extern virtual task monitor_traffic();
  extern         task non_common_survivability_registers();
  extern function sla_ral_access_path_t select_bg_cfg_access_path(string selected_access);

function void load_survivability_regs();
  	survivability_regs = {};
	find_n_load_reg("CFG_CONTROL_GENERAL_00",                "credit_hist_pipe");
	find_n_load_reg("CFG_CONTROL_GENERAL_01",                "credit_hist_pipe");
	find_n_load_reg("CFG_CHP_CSR_CONTROL",                   "credit_hist_pipe");
	find_n_load_reg("CFG_CONTROL_PIPELINE_CREDITS",          "list_sel_pipe");
	find_n_load_reg("CFG_CONTROL_GENERAL_0" ,                "list_sel_pipe");
	//find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[0]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[1]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[2]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[3]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[4]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[5]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[6]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[7]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[8]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[9]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[10]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[11]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[12]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[13]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[14]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[15]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[16]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[17]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[18]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[19]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[20]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[21]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[22]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[23]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[24]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[25]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[26]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[27]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[28]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[29]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[30]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[31]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[32]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[33]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[34]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[35]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[36]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[37]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[38]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[39]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[40]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[41]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[42]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[43]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[44]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[45]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[46]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[47]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[48]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[49]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[50]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[51]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[52]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[53]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[54]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[55]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[56]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[57]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[58]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[59]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[60]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[61]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[62]",     "list_sel_pipe");
    find_n_load_reg("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[63]",     "list_sel_pipe");
	find_n_load_reg("WRITE_BUFFER_CTL",                      "hqm_system_csr");
	find_n_load_reg("INGRESS_CTL",                           "hqm_system_csr");
	find_n_load_reg("EGRESS_CTL",                            "hqm_system_csr");
	find_n_load_reg("IOSFP_CGCTL",                           "hqm_sif_csr");
	find_n_load_reg("IOSFS_CGCTL",                           "hqm_sif_csr");
	find_n_load_reg("PRIM_CDC_CTL",                          "hqm_sif_csr");
	find_n_load_reg("SIDE_CDC_CTL",                          "hqm_sif_csr");
	find_n_load_reg("CFG_MASTER_CTL",                        "config_master");
	find_n_load_reg("CFG_CONTROL_GENERAL",                   "config_master");
	find_n_load_reg("CFG_CONTROL_GENERAL",                   "aqed_pipe");
	find_n_load_reg("CFG_CONTROL_GENERAL",                   "atm_pipe");
	find_n_load_reg("CFG_CONTROL_GENERAL",                   "nalb_pipe");
	//find_n_load_reg("CFG_CONTROL_GENERAL",                   "dqed_pipe");
	find_n_load_reg("CFG_CONTROL_GENERAL",                   "qed_pipe");
	find_n_load_reg("CFG_CONTROL_GENERAL",                   "direct_pipe");
	find_n_load_reg("CFG_CONTROL_PIPELINE_CREDITS",          "aqed_pipe");
	find_n_load_reg("CFG_CONTROL_PIPELINE_CREDITS",          "atm_pipe");
	find_n_load_reg("CFG_CONTROL_PIPELINE_CREDITS",          "nalb_pipe");
	//find_n_load_reg("CFG_CONTROL_PIPELINE_CREDITS",          "dqed_pipe");
	find_n_load_reg("CFG_CONTROL_PIPELINE_CREDITS",          "qed_pipe");
	find_n_load_reg("CFG_CONTROL_PIPELINE_CREDITS",          "direct_pipe");
	//find_n_load_reg(""  ,"");
    `ovm_info(get_full_name(),$psprintf("Pushed all the registers for all untis; survivability_regs.size = %d)", survivability_regs.size()),OVM_LOW)
endfunction

function void find_n_load_reg(string reg_name, string reg_file_name);
  sla_ral_reg my_reg_;
  my_reg_ = ral.find_reg_by_file_name(reg_name, reg_file_name);
  if (my_reg_==null) begin `ovm_error(get_full_name(),$psprintf("Couldn't find reg (%s) in reg_file (%s). So not loading !!",reg_name,reg_file_name)) end
  else	begin
	`ovm_info(get_full_name(),$psprintf("Found reg (%s) in reg_file (%s). Loaded in survivability_regs Q !",reg_name,reg_file_name),OVM_LOW);
  	survivability_regs.push_back(my_reg_);     
  end
endfunction

function void load_survivability_field_typical_val();
    int field_cnt=0;

    survivability_field_typical_val["qed_to_cq_pipe_credit_hwm"] = qed_to_cq_pipe_credit_hwm;
    survivability_field_typical_val["egress_pipe_credit_hwm"] = egress_pipe_credit_hwm;
    survivability_field_typical_val["rop_pipe_credit_hwm"] = rop_pipe_credit_hwm;
    survivability_field_typical_val["lsp_tok_pipe_credit_hwm"] = lsp_tok_pipe_credit_hwm;
    survivability_field_typical_val["lsp_ap_cmp_pipe_credit_hwm"] = lsp_ap_cmp_pipe_credit_hwm;
    survivability_field_typical_val["outbound_hcw_pipe_credit_hwm"] = outbound_hcw_pipe_credit_hwm;
    survivability_field_typical_val["atm_pipe_credits"] = atm_pipe_credits;
    survivability_field_typical_val["nalb_pipe_credits"] = nalb_pipe_credits;
    survivability_field_typical_val["ldb_single_op"] = ldb_single_op;
    survivability_field_typical_val["lbrpl_single_out"] = lbrpl_single_out;
    survivability_field_typical_val["lbrpl_half_bw"] = lbrpl_half_bw;
    survivability_field_typical_val["lbrpl_single_op"] = lbrpl_single_op;
    survivability_field_typical_val["dirrpl_single_out"] = dirrpl_single_out;
    survivability_field_typical_val["dirrpl_half_bw"] = dirrpl_half_bw;
    survivability_field_typical_val["dirrpl_single_op"] = dirrpl_single_op;
    survivability_field_typical_val["atq_disab_multi"] = atq_disab_multi;
    survivability_field_typical_val["atq_single_out"] = atq_single_out;
    survivability_field_typical_val["atq_half_bw"] = atq_half_bw;
    survivability_field_typical_val["atq_single_op"] = atq_single_op;
    survivability_field_typical_val["dir_disab_multi"] = dir_disab_multi;
    survivability_field_typical_val["dir_single_out"] = dir_single_out;
    survivability_field_typical_val["dir_half_bw"] = dir_half_bw;
    survivability_field_typical_val["dir_single_op"] = dir_single_op;
    survivability_field_typical_val["inc_cmp_unit_idle"] = inc_cmp_unit_idle;
    survivability_field_typical_val["disab_rlist_pri"] = disab_rlist_pri;
    survivability_field_typical_val["inc_tok_unit_idle"] = inc_tok_unit_idle;
    survivability_field_typical_val["disab_atq_empty_arb"] = disab_atq_empty_arb;
    survivability_field_typical_val["disable_wb_opt"] = disable_wb_opt;
    //survivability_field_typical_val["sch_rate_limit_write_buffer_ctl"] = sch_rate_limit_write_buffer_ctl;
    survivability_field_typical_val["write_single_beats"] = write_single_beats;
    //-- HQMV30 removed ZERO_CL_START   survivability_field_typical_val["zero_cl_start"] = zero_cl_start;
    survivability_field_typical_val["enq_rate_limit"] = enq_rate_limit;
    survivability_field_typical_val["sch_rate_limit"] = sch_rate_limit;
    //survivability_field_typical_val["clkgate_enable"] = clkgate_enable;
    survivability_field_typical_val["idle_count"] = idle_count;
    survivability_field_typical_val["clkgate_disabled"] = clkgate_disabled;
    survivability_field_typical_val["clkreq_ctl_disabled"] = clkreq_ctl_disabled;
    //survivability_field_typical_val["clkgate_holdoff"] = clkgate_holdoff;
    survivability_field_typical_val["pwrgate_holdoff"] = pwrgate_holdoff;
    //survivability_field_typical_val["clkreq_off_holdoff"] = clkreq_off_holdoff;
    //survivability_field_typical_val["clkreq_syncoff_holdoff"] = clkreq_syncoff_holdoff;
    survivability_field_typical_val["pwrgate_pmc_wake"] = pwrgate_pmc_wake;
    survivability_field_typical_val["override_clk_switch_control"] = override_clk_switch_control;
    survivability_field_typical_val["override_pmsm_pgcb_req_b"] = override_pmsm_pgcb_req_b;
    survivability_field_typical_val["override_pm_cfg_control"] = override_pm_cfg_control;
    survivability_field_typical_val["override_fet_en_b"] = override_fet_en_b;
    survivability_field_typical_val["ignore_pipe_busy"] = ignore_pipe_busy;
    survivability_field_typical_val["cfg_enable_unit_idle"] = cfg_enable_unit_idle;
    survivability_field_typical_val["cfg_pm_allow_ing_drop"] = cfg_pm_allow_ing_drop;
    survivability_field_typical_val["cfg_enable_alarms"] = cfg_enable_alarms;
    survivability_field_typical_val["cfg_disable_ring_par_ck"] = cfg_disable_ring_par_ck;
    survivability_field_typical_val["aqed_chicken_onepri"] = aqed_chicken_onepri;
    survivability_field_typical_val["aqed_lsp_stop_atqatm"] = aqed_lsp_stop_atqatm;
    survivability_field_typical_val["fid_sim"] = fid_sim;
    survivability_field_typical_val["fid_decrement"] = fid_decrement;
    survivability_field_typical_val["chicken_50"] = chicken_50;
    survivability_field_typical_val["chicken_sim"] = chicken_sim;
    survivability_field_typical_val["chicken_max_enqstall"] = chicken_max_enqstall;
    survivability_field_typical_val["chicken_en_enqblockrlst"] = chicken_en_enqblockrlst;
    survivability_field_typical_val["chicken_en_alwaysblast"] = chicken_en_alwaysblast;
    survivability_field_typical_val["chicken_dis_enq_afull_hp_mode"] = chicken_dis_enq_afull_hp_mode;
    survivability_field_typical_val["chicken_dis_enqstall"] = chicken_dis_enqstall;
    survivability_field_typical_val["chicken_25"] = chicken_25;
    survivability_field_typical_val["chicken_33"] = chicken_33;
    survivability_field_typical_val["fid_enq"] = fid_enq;
    survivability_field_typical_val["fid_push"] = fid_push;
    survivability_field_typical_val["aqed_chp_sch"] = aqed_chp_sch;
    survivability_field_typical_val["aqed_ap_enq"] = aqed_ap_enq;
    survivability_field_typical_val["ap_lsp_enq"] = ap_lsp_enq;
    survivability_field_typical_val["nalb_qed_atq"] = nalb_qed_atq;
    survivability_field_typical_val["nalb_lsp_enq_lb_atq"] = nalb_lsp_enq_lb_atq;
    survivability_field_typical_val["nalb_qed_rorply"] = nalb_qed_rorply;
    survivability_field_typical_val["nalb_lsp_enq_lb_rorply"] = nalb_lsp_enq_lb_rorply;
    survivability_field_typical_val["nalb_qed_lb"] = nalb_qed_lb;
    survivability_field_typical_val["nalb_lsp_enq_lb"] = nalb_lsp_enq_lb;
    survivability_field_typical_val["lcredits"] = credits;
    survivability_field_typical_val["dcredits"] = credits;
    survivability_field_typical_val["dp_dqed_rorply"] = dp_dqed_rorply;
    survivability_field_typical_val["dp_lsp_enq_dir_rorply"] = dp_lsp_enq_dir_rorply;
    survivability_field_typical_val["dp_dqed_dir"] = dp_dqed_dir;
    survivability_field_typical_val["dp_lsp_enq_dir"] = dp_lsp_enq_dir;
    survivability_field_typical_val["pad_first_write_ldb"] = pad_first_write_ldb;
    survivability_field_typical_val["pad_first_write_dir"] = pad_first_write_dir;

    `ovm_info(get_full_name(),$psprintf("Pushed all the fields & write values; survivability_field_typical_val.size = %d)", survivability_field_typical_val.size()),OVM_LOW)

    foreach (survivability_field_typical_val[a]) begin
        field_cnt++;
      `ovm_info(get_full_name(),$psprintf("ABCD: survivability field (%s), field_cnt = %d ",a, field_cnt),OVM_LOW)
   end

endfunction

task apply_patch();
  sla_status_t   status; 
  sla_ral_field  my_field;
  sla_ral_data_t wr_val=0, rd_val=0;
  sla_ral_data_t rd_val_list[$];
  string	  survivability_reg_field="";
  bit found_reg=1'b_0;
  string      loc_survivability_reg_field="";
  int         num_fields_updated=0;
  int         num_fields_to_check=0;
  int         curr_survi_field_num=0;
  
  if(!$value$plusargs("SURVIVABILITY_NUM_FIELDS_TO_CHECK=%0d",num_fields_to_check)) num_fields_to_check=survivability_regs.size();

  foreach (survivability_field_typical_val[k]) begin
      found_reg=1'b_0;
      loc_survivability_reg_field = k;
      survivability_reg_field = loc_survivability_reg_field.toupper();
      wr_val = survivability_field_typical_val[k];
      curr_survi_field_num++;

      `ovm_info(get_full_name(),$psprintf("Would run HQM_SURVIVABILITY PATCH for field (%s) with val 0x%0x; survivability_regs.size = %d",survivability_reg_field,wr_val, survivability_regs.size()),OVM_LOW)

      foreach(survivability_regs[i])	begin
        `ovm_info(get_full_name(),$psprintf("Finding field (%s) in reg (%s)",survivability_reg_field,survivability_regs[i].get_name()),OVM_DEBUG)
        my_field = survivability_regs[i].find_field(survivability_reg_field);
        if(my_field == null )	begin end
        else begin
          // this register patched during boot phase
          if (survivability_regs[i].get_name()=="CFG_MASTER_CTL") begin
              found_reg=1'b_1;
              my_field.set_tracking_val(survivability_field_typical_val[k]);
              continue;
          end
          if (!check_single_field || (check_single_field && (curr_survi_field_num == survi_field_num))) begin
              if ((survivability_regs[i].get_name()=="WRITE_BUFFER_CTL") && (survivability_reg_field=="SCH_RATE_LIMIT")) 
                  wr_val = 'h_1;
              else begin
                  wr_val = survivability_field_typical_val[k];
                  my_field.set_tracking_val(wr_val);
              end

              survivability_regs[i].write_fields(status,{survivability_reg_field},{wr_val},primary_id,.sai(SRVR_HOSTIA_UCODE_SAI));
              `ovm_info(get_full_name(),$psprintf("Running HQM_SURVIVABILITY PATCH for field (%s) in reg (%s) and val (0x%0x) and tracking_val (0x%0x), curr_survi_field_num = %d",survivability_reg_field,survivability_regs[i].get_name(),wr_val,my_field.get_tracking_val(), curr_survi_field_num),OVM_LOW)
              survivability_regs[i].readx_fields(status,{survivability_reg_field},{wr_val},rd_val_list,primary_id,.sai(SRVR_HOSTIA_UCODE_SAI));
          end
          found_reg=1'b_1;
        end
      end

      if(found_reg==1'b_0)	begin
         `ovm_error(get_full_name(),$psprintf("Could not find HQM_SURVIVABILITY field (%s) in any reg",survivability_reg_field))
      end

      num_fields_updated++;
      if (num_fields_updated >= num_fields_to_check) begin
          `ovm_info(get_full_name(),$psprintf("All Expected number of fields are patched, so coming out of task:num_fields_to_check=%0d, num_fields_updated=%0d, Total Number of fields=%0d", num_fields_to_check, num_fields_updated, survivability_regs.size()),OVM_LOW)
          break;
      end

  end
endtask

endclass

task hqm_survivability_patch_seq::body();
  ovm_object o;
  string      bg_cfg_access_path="";

  if(!$value$plusargs("SURVI_FIELD_NUM=%d", survi_field_num)) begin check_single_field=0; survi_field_num = 0; end
  if (survi_field_num) check_single_field = 1;
  $cast(ral, sla_ral_env::get_ptr());
  if (ral == null) begin
    ovm_report_fatal("CFG", "Unable to get RAL handle");
  end    

  //get cfg object
  if (cfg == null) begin
    cfg = hqm_cfg::get();
    if (cfg == null) begin
      ovm_report_fatal(get_full_name(), $psprintf("Unable to get CFG object"));
    end
  end

  if(!$value$plusargs("HQM_SURVIVABILITY_ACCESS=%s",bg_cfg_access_path)) bg_cfg_access_path="sideband";
  primary_id=select_bg_cfg_access_path(bg_cfg_access_path);
 
  load_survivability_regs();
  load_survivability_field_typical_val();

  //init_hqm();
  `ovm_do(pcie_init_seq);

  apply_patch();

  if ($test$plusargs("CHECK_NON_COMMON_REGISTERS")) begin
      ovm_report_info(get_full_name(), $psprintf("Configure non-common survivability registers"), OVM_LOW);
      non_common_survivability_registers();
  end

endtask

function sla_ral_access_path_t hqm_survivability_patch_seq::select_bg_cfg_access_path(string selected_access);
  case(selected_access)
        "primary" : select_bg_cfg_access_path=sla_iosf_pri_reg_lib_pkg::get_src_type();
        "sideband": select_bg_cfg_access_path=iosf_sb_sla_pkg::get_src_type();
        "random"  : select_bg_cfg_access_path=($urandom_range(0,1) ? sla_iosf_pri_reg_lib_pkg::get_src_type():iosf_sb_sla_pkg::get_src_type());
        default	  : select_bg_cfg_access_path=sla_iosf_pri_reg_lib_pkg::get_src_type();
  endcase
endfunction

task hqm_survivability_patch_seq::monitor_traffic();
  ;
endtask

task hqm_survivability_patch_seq::non_common_survivability_registers();

  sla_status_t   status; 
  sla_ral_field  my_field;
  sla_ral_reg    reg_h;
  sla_ral_data_t wr_val=0, rd_val=0;
  sla_ral_data_t rd_val_list[$];

  reg_h = ral.find_reg_by_file_name("cfg_arb_weight_atm_nalb_qid_0", "list_sel_pipe");
  reg_h.write_fields(status, {"PRI0_WEIGHT", "PRI1_WEIGHT", "PRI2_WEIGHT", "PRI3_WEIGHT"}, {'hf8, 'hf9, 'hfa, 'hfb}, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));
  reg_h.readx_fields(status, {"PRI0_WEIGHT", "PRI1_WEIGHT", "PRI2_WEIGHT", "PRI3_WEIGHT"}, {'hf8, 'hf9, 'hfa, 'hfb}, rd_val_list, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));
  
  // -- reg_h = ral.find_reg_by_file_name("cfg_arb_weight_atm_nalb_qid_1", "list_sel_pipe");
  // -- reg_h.write_fields(status, {"pri4_weight", "pri5_weight", "pri6_weight", "pri7_weight"}, {'hfc, 'hfd, 'hfe, 'hff}, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));
  // -- reg_h.readx_fields(status, {"pri4_weight", "pri5_weight", "pri6_weight", "pri7_weight"}, {'hfc, 'hfd, 'hfe, 'hff}, rd_val_list, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));
  
  reg_h = ral.find_reg_by_file_name("cfg_arb_weight_ldb_qid_0", "list_sel_pipe");
  reg_h.write_fields(status, {"PRI0_WEIGHT", "PRI1_WEIGHT", "PRI2_WEIGHT", "PRI3_WEIGHT"}, {'hf8, 'hf9, 'hfa, 'hfb}, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));
  reg_h.readx_fields(status, {"PRI0_WEIGHT", "PRI1_WEIGHT", "PRI2_WEIGHT", "PRI3_WEIGHT"}, {'hf8, 'hf9, 'hfa, 'hfb}, rd_val_list, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));
  
  // -- reg_h = ral.find_reg_by_file_name("cfg_arb_weight_ldb_qid_1", "list_sel_pipe");
  // -- reg_h.write_fields(status, {"pri4_weight", "pri5_weight", "pri6_weight", "pri7_weight"}, {'hfc, 'hfd, 'hfe, 'hff}, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));
  // -- reg_h.readx_fields(status, {"pri4_weight", "pri5_weight", "pri6_weight", "pri7_weight"}, {'hfc, 'hfd, 'hfe, 'hff}, rd_val_list, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));
  
endtask : non_common_survivability_registers

`endif //HQM_SURVIVABILITY_PATCH_SEQ_SV
