`ifndef HQM_STARVATION_AVOIDANCE_SEQ__SV
`define HQM_STARVATION_AVOIDANCE_SEQ__SV

class hqm_starvation_avoidance_seq extends hqm_base_seq;

  `ovm_sequence_utils(hqm_starvation_avoidance_seq, sla_sequencer)

  hqm_pp_cq_base_seq    ldb_pp_cq_seq[8];
  int                   rand_qpri_en;

  function new(string name = "hqm_starvation_avoidance_seq");
    super.new(name);
  endfunction

  virtual task body();

      ovm_object o_tmp;

      sla_ral_data_t read_data;
      int num_hcw;
      int arb_weight_atm_nalb_qid_1;
      int arb_weight_ldb_qid_1;
      int arb_weight_atm_nalb_qid_0;
      int arb_weight_ldb_qid_0;

      $value$plusargs({$psprintf("NUM_HCW"),"=%d"}, num_hcw);
      $value$plusargs("ARB_WEIGHT_ATM_NALB_QID_0=%h", arb_weight_atm_nalb_qid_0);
      $value$plusargs("ARB_WEIGHT_LDB_QID_0=%h", arb_weight_ldb_qid_0);
      $value$plusargs("ARB_WEIGHT_ATM_NALB_QID_1=%h", arb_weight_atm_nalb_qid_1);
      $value$plusargs("ARB_WEIGHT_LDB_QID_1=%h", arb_weight_ldb_qid_1);
      $value$plusargs("RAND_QPRI_EN=%h", rand_qpri_en);

      `ovm_info(get_full_name(), $psprintf("starvation avoidance:num_hcw=0x%0h, arb_weight_atm_nalb_qid_0=0x%0h, arb_weight_ldb_qid_0=0x%0h, arb_weight_atm_nalb_qid_1=0x%0h, arb_weight_ldb_qid_1=0x%0h, rand_qpri_en=%0d",  num_hcw, arb_weight_atm_nalb_qid_0, arb_weight_ldb_qid_0, arb_weight_atm_nalb_qid_1, arb_weight_ldb_qid_1, rand_qpri_en),OVM_LOW)

      write_reg("cfg_arb_weight_atm_nalb_qid_0",  arb_weight_atm_nalb_qid_0, "list_sel_pipe");
      write_reg("cfg_arb_weight_ldb_qid_0",       arb_weight_ldb_qid_0,      "list_sel_pipe");
      write_reg("cfg_arb_weight_atm_nalb_qid_1",  arb_weight_atm_nalb_qid_1, "list_sel_pipe");
      write_reg("cfg_arb_weight_ldb_qid_1",       arb_weight_ldb_qid_1,      "list_sel_pipe");

      read_reg("cfg_ldb_cq_depth[0]",               read_data,   "credit_hist_pipe");
      read_reg("cfg_ldb_cq_token_depth_select[0]",  read_data,   "credit_hist_pipe"); // cq_depth= 4*2^n; -- n = register token_depth_select value
      read_reg("cfg_cq_ldb_token_depth_select[0]",  read_data,   "list_sel_pipe");

      write_reg("cfg_cq_ldb_disable[0]", 1, "list_sel_pipe");
      read_reg("cfg_cq_ldb_disable[0]", read_data, "list_sel_pipe");
      get_hqm_cfg();

      fork
          start_pp_cq(.is_ldb(1),.log_pp_cq_num(0), .qid(0), .qtype(QUNO), .queue_list_size(8), .hcw_delay_min(32),.pp_cq_seq(ldb_pp_cq_seq[0]));
      join_none

      for (int i = 0; i < 8; i++) begin
          poll_reg($psprintf("cfg_qid_ldb_enqueue_count[%0d]", i), num_hcw, "list_sel_pipe");
      end
      write_reg("cfg_cq_ldb_disable[0]", 0, "list_sel_pipe");
      read_reg("cfg_cq_ldb_disable[0]", read_data, "list_sel_pipe");

  endtask

  virtual task start_pp_cq(bit is_ldb, int log_pp_cq_num, int qid, hcw_qtype qtype, int queue_list_size, int hcw_delay_min, output hqm_pp_cq_base_seq pp_cq_seq);
    sla_ral_env         ral;
    sla_ral_reg         my_reg;
    sla_ral_field       my_field;
    sla_ral_data_t      ral_data;
    bit [63:0]         cq_addr_val;
    int                 num_hcw_gen;
    string              pp_cq_prefix;
    string              qtype_str;
    int                 vf_num_val;
    bit [15:0]          lock_id;
    bit [15:0]          dsi;
    int                 batch_min;
    int                 batch_max;
    bit                 msix_mode;
    int                 cq_poll_int;
    int                 phy_pp_cq_num;
    int                 msi_num;
    int                 hcw_delay_max;
    int                 qid_opt;
    int                 qpri_w;
    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    phy_pp_cq_num = log_pp_cq_num;

   

    cq_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,phy_pp_cq_num), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[63:32] = ral_data[31:0];

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,phy_pp_cq_num), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[31:6] = ral_data[31:6];
    ovm_report_info(get_full_name(), $psprintf("hqm_starvation_avoidance_seq: is_ldb=%0d phy_pp_cq_num=%0d read cq_addr_u/l to get cq_addr_val=0x%0x", is_ldb, phy_pp_cq_num, cq_addr_val), OVM_LOW);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- get_cq_addr_val is virtual address
    //-- cq_physical_addr_val=get_cq_hpa(is_ldb, cq);
    //----------------------------------
    get_hqm_cfg();
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, phy_pp_cq_num); 
        ovm_report_info(get_full_name(), $psprintf("hqm_starvation_avoidance_seq: is_ldb=%0d phy_pp_cq_num=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)", is_ldb, phy_pp_cq_num, cq_addr_val), OVM_LOW);
    end


    batch_min = 1;
    batch_max = 1;

    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY_MIN",pp_cq_prefix,log_pp_cq_num),"=%d"}, hcw_delay_min);
    hcw_delay_max = hcw_delay_min;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY_MAX",pp_cq_prefix,log_pp_cq_num),"=%d"}, hcw_delay_max);
    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MIN",pp_cq_prefix,log_pp_cq_num),"=%d"}, batch_min);
    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MAX",pp_cq_prefix,log_pp_cq_num),"=%d"}, batch_max);

    cq_poll_int = 0;
    $value$plusargs({$psprintf("%s_PP%0d_CQ_POLL",pp_cq_prefix,log_pp_cq_num),"=%d"}, cq_poll_int);

    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,log_pp_cq_num));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
      pp_cq_num                  == ( phy_pp_cq_num);      // Producer Port/Consumer Queue number
      pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

      queue_list.size()          == queue_list_size;

      hcw_enqueue_batch_min      == batch_min;  // Minimum number of HCWs to send as a batch (1-4)
      hcw_enqueue_batch_max      == batch_max;  // Maximum number of HCWs to send as a batch (1-4)

      queue_list_delay_min       == hcw_delay_min;
      queue_list_delay_max       == hcw_delay_max;

      cq_addr                    == cq_addr_val;

      cq_poll_interval           == cq_poll_int;
    } ) begin
      `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end
    pp_cq_seq.mon_watchdog_timeout = (10000);


    $value$plusargs({$psprintf("%s_PP%0d_QID",pp_cq_prefix,log_pp_cq_num),"=%d"}, qid);

    

   
    lock_id = 16'h4001;
    $value$plusargs({$psprintf("%s_PP%0d_LOCKID",pp_cq_prefix,log_pp_cq_num),"=%d"}, lock_id);

    dsi = 16'h0100;
    $value$plusargs({$psprintf("%s_PP%0d_DSI",pp_cq_prefix,log_pp_cq_num),"=%d"}, dsi);

    case (qtype_str)
      "qdir": qtype = QDIR;
      "quno": qtype = QUNO;
      "qatm": qtype = QATM;
      "qord": qtype = QORD;
    endcase

    for (int i = 0 ; i < queue_list_size ; i++) begin
      num_hcw_gen = 1;
      qpri_w = (rand_qpri_en==2) ? 0 : ((rand_qpri_en==1)?  i : ((i/2)*2));
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,log_pp_cq_num,i),"=%d"}, num_hcw_gen);

      pp_cq_seq.queue_list[i].num_hcw                   = num_hcw_gen;
      pp_cq_seq.queue_list[i].qid                       = qid + i;
      pp_cq_seq.queue_list[i].qtype                     = qtype;
      pp_cq_seq.queue_list[i].qpri_weight[qpri_w]       = 1;
      pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_min * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_max * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
      pp_cq_seq.queue_list[i].lock_id                   = lock_id;
      pp_cq_seq.queue_list[i].dsi                       = dsi;
      pp_cq_seq.queue_list[i].comp_flow                 = 1;
      pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;
      pp_cq_seq.queue_list[i].illegal_hcw_gen_mode      = hqm_pp_cq_base_seq::NO_ILLEGAL;
    end

    finish_item(pp_cq_seq);
  endtask

 
endclass : hqm_starvation_avoidance_seq

`endif //HQM_STARVATION_AVOIDANCE_SEQ__SV


