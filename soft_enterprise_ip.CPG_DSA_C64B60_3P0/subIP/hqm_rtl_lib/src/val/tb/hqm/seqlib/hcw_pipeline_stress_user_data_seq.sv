// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2018) (2018) Intel Corporation All Rights Reserved. 
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
// File   : hcw_pipeline_stress_user_data_seq.sv
//
// Description :
//
//   Sequence that supports clock control tests with optional warm reset.
//
//   Variables within stim_config class
//     * do_warm_reset - do a warm reset (default is 0)
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hcw_pipeline_stress_user_data_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_pipeline_stress_user_data_seq_stim_config";

  `ovm_object_utils_begin(hcw_pipeline_stress_user_data_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg1, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg2, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(start_index, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(length, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hcw_pipeline_stress_user_data_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(file_mode_plusarg1)
    `stimulus_config_field_string(file_mode_plusarg2)
    `stimulus_config_field_rand_int(start_index)
    `stimulus_config_field_rand_int(length)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        file_mode_plusarg1 = "HQM_DATA_SEQ";
  string                        file_mode_plusarg2 = "HQM_DATA_SEQ2";

  rand  int                     start_index;
  rand  int                     length;

  constraint c_index {
         start_index >= 0;
         start_index <= 'h7fff;
         length >= 0;
         length <= 'h7fff;
         start_index + length <= 'h00008000;
  }

  function new(string name = "hcw_pipeline_stress_user_data_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_pipeline_stress_user_data_seq_stim_config

class hcw_pipeline_stress_user_data_seq extends sla_sequence_base;
  `ovm_sequence_utils(hcw_pipeline_stress_user_data_seq, sla_sequencer)

  rand hcw_pipeline_stress_user_data_seq_stim_config        cfg;

  sla_ral_env                   ral;
  sla_ral_data_t                ral_data;
  sla_ral_reg                   ingress_ctl;
  sla_ral_reg                   func_bar_u_reg;
  sla_ral_reg                   func_bar_l_reg;

  int                           pf_dirpp_dirqid_weight['h8000][5];
  int                           pf_dirpp_ldbqid_weight['h8000][5];
  int                           pf_ldbpp_dirqid_weight['h8000][5];
  int                           pf_ldbpp_ldbqid_weight['h8000][5];
  int                           vf_dirpp_dirqid_weight['h8000][5];
  int                           vf_dirpp_ldbqid_weight['h8000][5];
  int                           vf_ldbpp_dirqid_weight['h8000][5];
  int                           vf_ldbpp_ldbqid_weight['h8000][5];

  typedef struct {
    bit [7:0]   sai_6bit_to_8bit[$];
  } sai_queue_t;

  sla_ral_data_t 	rd_legal_sais[$];
  sla_ral_data_t 	wr_legal_sais[$];
  sai_queue_t           sai_queues[64];

  hqm_cfg                       i_hqm_cfg;
  hqm_pp_cq_status              i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed
  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;

  hqm_tb_cfg_file_mode_seq      i_file_mode_seq;
  hqm_tb_cfg_file_mode_seq      i_post_pf_flr_file_mode_seq;
  hqm_tb_cfg_file_mode_seq      i_file_mode_seq2;

  bit [7:0]     legal_sai;
  bit [7:0]     legal_sai8;

  int           dir_hcw_token_cnt[64];
  int           ldb_hcw_token_cnt[64];

  semaphore     burst_sem;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_pipeline_stress_user_data_seq_stim_config);

  function new(string name = "hcw_pipeline_stress_user_data_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name);

    for (bit [8:0] sai8 = 0 ; sai8 < 9'h100 ; sai8++) begin
      if (sai8[0] == 1'b1) begin
        sai_queues[{3'b000,sai8[3:1]}].sai_6bit_to_8bit.push_back(sai8);
      end else if ((sai8[7:1] > 7'b0000111) && (sai8[7:1] < 7'b0111111)) begin
        sai_queues[sai8[6:1]].sai_6bit_to_8bit.push_back(sai8);
      end else begin
        sai_queues[6'b111111].sai_6bit_to_8bit.push_back(sai8);
      end
    end

    for (int burst_num = 0 ; burst_num < 32'h7fff ; burst_num++) begin
      for (int req_num = 0 ; req_num < 5 ; req_num++) begin
        pf_dirpp_dirqid_weight[burst_num][req_num] = (((burst_num >> (3 * req_num)) & 'h7) == 0) ? 1 : 0;
        pf_dirpp_ldbqid_weight[burst_num][req_num] = (((burst_num >> (3 * req_num)) & 'h7) == 1) ? 1 : 0;
        pf_ldbpp_dirqid_weight[burst_num][req_num] = (((burst_num >> (3 * req_num)) & 'h7) == 2) ? 1 : 0;
        pf_ldbpp_ldbqid_weight[burst_num][req_num] = (((burst_num >> (3 * req_num)) & 'h7) == 3) ? 1 : 0;
        vf_dirpp_dirqid_weight[burst_num][req_num] = (((burst_num >> (3 * req_num)) & 'h7) == 4) ? 1 : 0;
        vf_dirpp_ldbqid_weight[burst_num][req_num] = (((burst_num >> (3 * req_num)) & 'h7) == 5) ? 1 : 0;
        vf_ldbpp_dirqid_weight[burst_num][req_num] = (((burst_num >> (3 * req_num)) & 'h7) == 6) ? 1 : 0;
        vf_ldbpp_ldbqid_weight[burst_num][req_num] = (((burst_num >> (3 * req_num)) & 'h7) == 7) ? 1 : 0;
      end
    end

    burst_sem   = new(0);

    foreach (dir_hcw_token_cnt[i]) dir_hcw_token_cnt[i] = 0;
    foreach (ldb_hcw_token_cnt[i]) ldb_hcw_token_cnt[i] = 0;

    cfg = hcw_pipeline_stress_user_data_seq_stim_config::type_id::create("hcw_pipeline_stress_user_data_seq_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  function bit [7:0] get_8bit_sai(sla_ral_sai_t sai6);
    sai6 = sai6 & 6'h3f;
    return (sai_queues[sai6].sai_6bit_to_8bit[$urandom_range(sai_queues[sai6].sai_6bit_to_8bit.size()-1,0)]);
  endfunction

  virtual task body();
    ovm_object o_tmp;
    byte_t      rd_data[$];
    addr_t      rd_addr;


    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal(get_full_name(), "Unable to get RAL handle");
    end    

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
    end    

    //-----------------------------
    //-- get i_hqm_pp_cq_status
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_pp_cq_status", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
    end

    if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
    end

    if (!p_sequencer.get_config_object("i_hcw_scoreboard", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hcw_scoreboard object");
    end

    if (!$cast(i_hcw_scoreboard, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
    end

    apply_stim_config_overrides(1);

    populate_regs();

    i_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq");
    i_file_mode_seq.set_cfg(cfg.file_mode_plusarg1, 1'b0);
    i_file_mode_seq.start(get_sequencer());

    for (int i = cfg.start_index ; i < (cfg.start_index + cfg.length) ; i++) begin
      issue_burst(i);
    end

    foreach (dir_hcw_token_cnt[i]) begin
      if (dir_hcw_token_cnt[i] > 0) begin
        do_dir_hcw_token_ret(i);
      end
    end

    foreach (ldb_hcw_token_cnt[i]) begin
      while (ldb_hcw_token_cnt[i] > 0) begin
        do_ldb_hcw_comp_token_ret(i);
      end
    end

    #100ns;

    i_hqm_pp_cq_status.pp_cq_state_update(.is_ldb(1'b0), .pp_cq(0), .new_enq_cnt(0), .new_sch_cnt(0));

    i_file_mode_seq2 = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq2");
    i_file_mode_seq2.set_cfg(cfg.file_mode_plusarg2, 1'b0);
    i_file_mode_seq2.start(get_sequencer());
  endtask

  virtual task issue_burst(int burst_num);
    sla_status_t        status;
    int                 req_num;
    int                 pf_dirpp_dirqid_weight_int;
    int                 pf_dirpp_ldbqid_weight_int;
    int                 pf_ldbpp_dirqid_weight_int;
    int                 pf_ldbpp_ldbqid_weight_int;
    int                 vf_dirpp_dirqid_weight_int;
    int                 vf_dirpp_ldbqid_weight_int;
    int                 vf_ldbpp_dirqid_weight_int;
    int                 vf_ldbpp_ldbqid_weight_int;

    req_num = 0;

    pf_dirpp_dirqid_weight_int  = pf_dirpp_dirqid_weight[burst_num][req_num];
    pf_dirpp_ldbqid_weight_int  = pf_dirpp_ldbqid_weight[burst_num][req_num];
    pf_ldbpp_dirqid_weight_int  = pf_ldbpp_dirqid_weight[burst_num][req_num];
    pf_ldbpp_ldbqid_weight_int  = pf_ldbpp_ldbqid_weight[burst_num][req_num];
    vf_dirpp_dirqid_weight_int  = vf_dirpp_dirqid_weight[burst_num][req_num];
    vf_dirpp_ldbqid_weight_int  = vf_dirpp_ldbqid_weight[burst_num][req_num];
    vf_ldbpp_dirqid_weight_int  = vf_ldbpp_dirqid_weight[burst_num][req_num];
    vf_ldbpp_ldbqid_weight_int  = vf_ldbpp_ldbqid_weight[burst_num][req_num];

    randsequence (burst)
      burst     : enq_mask request request request request request enq_unmask post_request;
      request   : req_type inc_req_num;
      req_type  : pf_dirpp_dirqid       := pf_dirpp_dirqid_weight_int |
                  pf_dirpp_ldbqid       := pf_dirpp_ldbqid_weight_int |
                  pf_ldbpp_dirqid       := pf_ldbpp_dirqid_weight_int |
                  pf_ldbpp_ldbqid       := pf_ldbpp_ldbqid_weight_int |
                  vf_dirpp_dirqid       := vf_dirpp_dirqid_weight_int |
                  vf_dirpp_ldbqid       := vf_dirpp_ldbqid_weight_int |
                  vf_ldbpp_dirqid       := vf_ldbpp_dirqid_weight_int |
                  vf_ldbpp_ldbqid       := vf_ldbpp_ldbqid_weight_int ;

      inc_req_num:      { 
                          req_num++;

                          pf_dirpp_dirqid_weight_int  = pf_dirpp_dirqid_weight[burst_num][req_num];
                          pf_dirpp_ldbqid_weight_int  = pf_dirpp_ldbqid_weight[burst_num][req_num];
                          pf_ldbpp_dirqid_weight_int  = pf_ldbpp_dirqid_weight[burst_num][req_num];
                          pf_ldbpp_ldbqid_weight_int  = pf_ldbpp_ldbqid_weight[burst_num][req_num];
                          vf_dirpp_dirqid_weight_int  = vf_dirpp_dirqid_weight[burst_num][req_num];
                          vf_dirpp_ldbqid_weight_int  = vf_dirpp_ldbqid_weight[burst_num][req_num];
                          vf_ldbpp_dirqid_weight_int  = vf_ldbpp_dirqid_weight[burst_num][req_num];
                          vf_ldbpp_ldbqid_weight_int  = vf_ldbpp_ldbqid_weight[burst_num][req_num];
                        };
      enq_mask:         { ingress_ctl.write(status, 'h11, sla_iosf_pri_reg_lib_pkg::get_src_type(), .sai(legal_sai)); #50ns; };
      enq_unmask:       { #2.5ns; ingress_ctl.write(status, 'h10, sla_iosf_pri_reg_lib_pkg::get_src_type(), .sai(legal_sai)); };
      post_request:     { do_post_request(); #0.1ns; };
      pf_dirpp_dirqid:  { do_hcw(.req_num(req_num), .is_vf(0),.vf_num(0), .vas(0), .is_ldb(0),.pp(60),.qtype(QDIR),.qid(60));  #0.1ns; };
      pf_dirpp_ldbqid:  { do_hcw(.req_num(req_num), .is_vf(0),.vf_num(0), .vas(1), .is_ldb(0),.pp(61),.qtype(QUNO),.qid(0));   #0.1ns; };
      pf_ldbpp_dirqid:  { do_hcw(.req_num(req_num), .is_vf(0),.vf_num(0), .vas(1), .is_ldb(1),.pp(4), .qtype(QDIR),.qid(61));  #0.1ns; };
      pf_ldbpp_ldbqid:  { do_hcw(.req_num(req_num), .is_vf(0),.vf_num(0), .vas(2), .is_ldb(1),.pp(5), .qtype(QUNO),.qid(1));   #0.1ns; };
      vf_dirpp_dirqid:  { do_hcw(.req_num(req_num), .is_vf(1),.vf_num(0), .vas(29),.is_ldb(0),.pp(62),.qtype(QDIR),.qid(62));  #0.1ns; };
      vf_dirpp_ldbqid:  { do_hcw(.req_num(req_num), .is_vf(1),.vf_num(10),.vas(30),.is_ldb(0),.pp(63),.qtype(QUNO),.qid(2));   #0.1ns; };
      vf_ldbpp_dirqid:  { do_hcw(.req_num(req_num), .is_vf(1),.vf_num(10),.vas(30),.is_ldb(1),.pp(6), .qtype(QDIR),.qid(63));  #0.1ns; };
      vf_ldbpp_ldbqid:  { do_hcw(.req_num(req_num), .is_vf(1),.vf_num(15),.vas(31),.is_ldb(1),.pp(7), .qtype(QUNO),.qid(3));   #0.1ns; };
    endsequence

    do_idle();

    foreach (dir_hcw_token_cnt[i]) begin
      if (dir_hcw_token_cnt[i] > 100) begin
        do_dir_hcw_token_ret(i);
      end
    end

    foreach (ldb_hcw_token_cnt[i]) begin
      while (ldb_hcw_token_cnt[i] > 0) begin
        do_ldb_hcw_comp_token_ret(i);
      end
    end
  endtask

  virtual task do_post_request();
  endtask

  task do_dir_hcw_token_ret(int cq);
    if (cq >= 62) begin
      do_hcw(.qe_valid(1'b0), .tok_ret_cnt(dir_hcw_token_cnt[cq]), .is_vf(1'b1), .vf_num((cq == 62) ? 0 : 10), .is_ldb(0), .pp(cq));
    end else begin
      do_hcw(.qe_valid(1'b0), .tok_ret_cnt(dir_hcw_token_cnt[cq]), .is_vf(1'b0),                               .is_ldb(0), .pp(cq));
    end

    dir_hcw_token_cnt[cq] = 0;
  endtask

  task do_ldb_hcw_comp_token_ret(int cq);
    if (cq >= 6) begin
      do_hcw(.qe_valid(1'b0), .tok_ret_cnt(1), .do_comp(1), .is_vf(1'b1), .vf_num((cq == 6) ? 10 : 15), .is_ldb(1), .pp(cq));
    end else begin
      do_hcw(.qe_valid(1'b0), .tok_ret_cnt(1), .do_comp(1), .is_vf(1'b0),                               .is_ldb(1), .pp(cq));
    end

    ldb_hcw_token_cnt[cq]--;
  endtask

  virtual task do_hcw(int req_num = 0, bit qe_valid = 1, int tok_ret_cnt = 0, bit do_comp = 1'b0, bit is_vf = 1'b0, int vf_num = 0, int vas = 0, bit is_ldb = 1'b0, int pp = 0, hcw_qtype qtype = QDIR, int qid = 0);
    hcw_transaction     hcw_trans;
    bit [127:0]         hcw_data_bits;
    bit [63:0]          pp_addr;
    hqm_hcw_enq_seq     hcw_enq_seq;
    sla_ral_data_t      ral_data;
    bit                 is_nm_pf;

    if(is_vf==0) is_nm_pf=1;
    else         is_nm_pf=0;   
    `ovm_info(get_full_name(),$psprintf("DO_HCW - qe_valid=%0d tok_ret_cnt=%0d do_comp=%0d is_vf=%0d (will be forced to is_vf=0) is_nm_pf=%0d vf_num=%0d vas=%0d is_ldb=%0d pp=%0d qtype=%0d qid=%0d",
                                       qe_valid,tok_ret_cnt,do_comp,is_vf, is_nm_pf, vf_num,vas,is_ldb,pp,qtype,qid),OVM_LOW)

    is_vf=0;

    hcw_trans = hcw_transaction::type_id::create("hcw_trans");

    hcw_trans.randomize();

    hcw_trans.rsvd0                     = '0;
    hcw_trans.dsi_error                 = '0;
    hcw_trans.no_inflcnt_dec            = '0;
    hcw_trans.dbg                       = '0;
    hcw_trans.cmp_id                    = '0;
    hcw_trans.is_nm_pf                  = is_nm_pf;
    hcw_trans.is_vf                     = is_vf;
    hcw_trans.vf_num                    = vf_num;
    hcw_trans.sai                       = legal_sai8;
    hcw_trans.rtn_credit_only           = '0;
    hcw_trans.exp_rtn_credit_only       = '0;
    hcw_trans.ingress_drop              = '0;
    hcw_trans.exp_ingress_drop          = '0;
    hcw_trans.meas                      = '0;
    hcw_trans.ordqid                    = '0;
    hcw_trans.ordpri                    = '0;
    hcw_trans.ordlockid                 = '0;
    hcw_trans.ordidx                    = '0;
    hcw_trans.reord                     = '0;
    hcw_trans.frg_cnt                   = '0;
    hcw_trans.frg_last                  = '0;

    hcw_trans.qe_valid                  = qe_valid;
    hcw_trans.qe_orsp                   = 0;
    hcw_trans.qe_uhl                    = do_comp;
    hcw_trans.cq_pop                    = (tok_ret_cnt > 0) ? 1 : 0;
    hcw_trans.is_ldb                    = is_ldb;
    hcw_trans.ppid                      = pp;
    hcw_trans.qtype                     = qtype;
    hcw_trans.qid                       = qid;
    hcw_trans.qpri                      = 0;
    hcw_trans.lockid                    = tok_ret_cnt - 1;
    hcw_trans.msgtype                   = 0;
    hcw_trans.idsi                      = 0;
     
    hcw_trans.hcw_batch                 = 0;

    hcw_trans.tbcnt                     = hcw_trans.get_transaction_id();

    hcw_trans.iptr                      = hcw_trans.tbcnt;

    if (hcw_trans.reord == 0)
      hcw_trans.ordidx = hcw_trans.tbcnt;

    //---- 
    //-- determine enqattr
    //----    
    hcw_trans.enqattr = 2'h0;   
    hcw_trans.sch_is_ldb = (hcw_trans.qtype == QDIR)? 1'b0 : 1'b1;
    if (hcw_trans.qe_valid == 1 && hcw_trans.qtype != QORD ) begin
      if (hcw_trans.qtype == QDIR ) begin
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
    
    //-- pass hcw_item to sb
    i_hqm_cfg.write_hcw_gen_port(hcw_trans);
    
    hcw_trans.hcw_batch         = 1'b0;

    hcw_data_bits = hcw_trans.byte_pack(0);
    
    pp_addr = 64'h0000_0000_0200_0000;
    
    ral_data = func_bar_u_reg.get_actual();
    
    pp_addr[63:32] = ral_data[31:0];
    
    ral_data = func_bar_l_reg.get_actual();
    
    pp_addr[31:26] = ral_data[31:26];
    
    pp_addr[19:12] = hcw_trans.ppid;
    pp_addr[20]    = hcw_trans.is_ldb;
    pp_addr[21]    = hcw_trans.is_nm_pf;
    pp_addr[9:6]   = 4'h0;

    if (qe_valid) begin
      i_hqm_pp_cq_status.wait_for_vas_credit(vas);

      if (qtype == QDIR) begin
        dir_hcw_token_cnt[qid]++;
      end else begin
        ldb_hcw_token_cnt[qid + 4]++;
      end
    end

    `ovm_info(get_type_name(),"Sending HCW transaction",OVM_LOW);
    `ovm_info(get_full_name(),$psprintf("Sending HCW - qe_valid=%0d tok_ret_cnt=%0d do_comp=%0d is_vf=%0d is_nm_pf=%0d vf_num=%0d vas=%0d is_ldb=%0d pp=%0d qtype=%0d qid=%0d - pp_addr=0x%0x",
                                       qe_valid,tok_ret_cnt,do_comp,is_vf, is_nm_pf, vf_num,vas,is_ldb,pp,qtype,qid, pp_addr),OVM_LOW)
    hcw_trans.print();

    `ovm_create(hcw_enq_seq)
  
    `ovm_rand_send_with(hcw_enq_seq, { 
                                         pp_enq_addr == pp_addr;
                                         sai == hcw_trans.sai;
                                         hcw_enq_q.size == 1;
                                         hcw_enq_q[0] == hcw_data_bits;
                                     })
  endtask

  virtual task do_idle();
    #10ns;

    while (!i_hcw_scoreboard.hcw_scoreboard_idle()) begin
      #5ns;
    end
  endtask

  virtual task populate_regs();
    func_bar_u_reg = ral.find_reg_by_file_name("func_bar_u", "hqm_pf_cfg_i");
    func_bar_l_reg = ral.find_reg_by_file_name("func_bar_l", "hqm_pf_cfg_i");
    ingress_ctl = ral.find_reg_by_file_name("ingress_ctl", "hqm_system_csr");

    legal_sai  = ingress_ctl.pick_legal_sai_value(RAL_WRITE);
    legal_sai8 = get_8bit_sai(legal_sai);
  endtask

endclass : hcw_pipeline_stress_user_data_seq
