import hqm_tb_cfg_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hcw_perf_atm_test_hcw_seq extends sla_sequence_base;

  `ovm_sequence_utils(hcw_perf_atm_test_hcw_seq, sla_sequencer)

  hqm_tb_cfg            i_hqm_cfg;

  hqm_pp_cq_base_seq    ldb_pp_cq_seq[64];

  function new(string name = "hcw_perf_atm_test_hcw_seq");
    super.new(name);
  endfunction

  virtual task body();
    ovm_object  o_tmp;

    int         num_pp_cq;
    int         num_qid;

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg %s not consistent with hqm_tb_cfg type", o_tmp.sprint()));
    end

    num_pp_cq = 1;
    $value$plusargs("HQM_PERF_ATM_NUM_PP_CQ=%d", num_pp_cq);

    if ((num_pp_cq < 1) || (num_pp_cq > 64)) begin
      `ovm_fatal(get_full_name(), $psprintf("+HQM_PERF_ATM_NUM_PP_CQ=%0d is not a valid argument value (must be 1-64)",num_pp_cq));
    end

    num_qid = 1;
    $value$plusargs("HQM_PERF_ATM_NUM_QID=%d", num_qid);

    if ((num_qid < 1) || (num_qid > 64)) begin
      `ovm_fatal(get_full_name(), $psprintf("+HQM_PERF_ATM_NUM_QID=%0d is not a valid argument value (must be 1-32)",num_qid));
    end

    for (int i = 0 ; i < num_pp_cq ; i++) begin
      fork
        automatic int pp_num = i;

        start_pp_cq(pp_num,num_qid,ldb_pp_cq_seq[pp_num]);
      join_none
    end

    wait fork;

    super.body();

  endtask

  virtual task start_pp_cq(int pp_cq_num_in, int num_qid, output hqm_pp_cq_base_seq pp_cq_seq);
    sla_ral_env         ral;
    sla_ral_reg         my_reg;
    sla_ral_data_t      ral_data;
    logic [63:0]        cq_addr_val;
    int                 num_hcw_gen;
    string              pp_cq_prefix;
    string              qtype_str;
    int                 vf_num_val;
    bit [15:0]          lock_id;
    bit [15:0]          dsi;
    int                 hcw_delay_min;
    int                 hcw_delay_max;
    int                 hcw_delay_rand;
    int                 watchdog_init;

    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    hcw_delay_min       = 1;
    hcw_delay_max       = -1;
    watchdog_init   = 2500;

    cq_addr_val = '0;

    pp_cq_prefix = "LDB";

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp_cq_num_in), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[63:32] = ral_data[31:0];

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp_cq_num_in), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[31:6] = ral_data[31:6];
    ovm_report_info(get_full_name(), $psprintf("hcw_perf_atm_test_hcw_seq: is_ldb=1 pp_cq_num_in=%0d read cq_addr_u/l to get cq_addr_val=0x%0x",  pp_cq_num_in, cq_addr_val), OVM_LOW);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- the above cq_addr_val read from CQ_ADDR ral is virtual address
    //-- to get physical address: cq_addr_val=i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in);  
    //----------------------------------
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(1, pp_cq_num_in); 
        ovm_report_info(get_full_name(), $psprintf("hcw_perf_atm_test_hcw_seq: is_ldb=1 pp_cq_num_in=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)",  pp_cq_num_in, cq_addr_val), OVM_LOW);
    end  

    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_min);
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_max);

    if (hcw_delay_max < 0) begin
      hcw_delay_max = hcw_delay_min;
    end

    $value$plusargs({$psprintf("%s_PP%0d_WATCHDOG_TIMEOUT",pp_cq_prefix,pp_cq_num_in),"=%d"}, watchdog_init);

    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_num_in));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
                     pp_cq_num            == pp_cq_num_in;      // Producer Port/Consumer Queue number
                     pp_cq_type           == hqm_pp_cq_base_seq::IS_LDB;

                     queue_list.size()          == num_qid;

                     hcw_enqueue_batch_min      == 1;  // Minimum number of HCWs to send as a batch (1-4)
                     hcw_enqueue_batch_max      == 1;  // Maximum number of HCWs to send as a batch (1-4)

                     queue_list_delay_min       == hcw_delay_min;
                     queue_list_delay_max       == hcw_delay_max;

                     cq_addr                    == cq_addr_val;

                     cq_poll_interval           == 1;

                     mon_watchdog_timeout       == watchdog_init;
                   } ) begin
      `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end

    vf_num_val = -1;

    $value$plusargs({$psprintf("%s_PP%0d_VF",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, vf_num_val);

    if (vf_num_val >= 0) begin
      pp_cq_seq.is_vf   = 1;
      pp_cq_seq.vf_num  = vf_num_val;
    end

    num_hcw_gen = 1;
    $value$plusargs({$psprintf("%s_PP%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, num_hcw_gen);

    lock_id = 16'h0000;
    $value$plusargs({$psprintf("%s_PP%0d_LOCKID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, lock_id);

    dsi = 16'h0100;

    for (int i = 0 ; i < num_qid ; i++) begin
      pp_cq_seq.queue_list[i].num_hcw                   = num_hcw_gen/num_qid;
      pp_cq_seq.queue_list[i].qid                       = (pp_cq_seq.pp_cq_num + i) % num_qid;
      pp_cq_seq.queue_list[i].qtype                     = QATM;
      pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_min * num_qid;
      pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_max * num_qid;
      pp_cq_seq.queue_list[i].qpri_weight[0]            = 1;
      pp_cq_seq.queue_list[i].lock_id                   = lock_id + ((pp_cq_seq.pp_cq_num << 8) + i);
      pp_cq_seq.queue_list[i].dsi                       = dsi;
      pp_cq_seq.queue_list[i].comp_flow                 = 1;
      pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1;
      pp_cq_seq.queue_list[i].illegal_hcw_gen_mode      = hqm_pp_cq_base_seq::NO_ILLEGAL;
    end

    finish_item(pp_cq_seq);
  endtask

endclass
