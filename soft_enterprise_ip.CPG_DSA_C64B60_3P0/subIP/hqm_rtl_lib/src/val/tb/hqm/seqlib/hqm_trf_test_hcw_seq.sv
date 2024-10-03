import hqm_tb_cfg_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hqm_trf_test_hcw_seq extends sla_sequence_base;

  `ovm_sequence_utils(hqm_trf_test_hcw_seq, sla_sequencer)

  hqm_tb_cfg            i_hqm_cfg;

  hqm_pp_cq_base_seq    ldb_pp_cq_0_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_1_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_2_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_3_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_4_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_5_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_6_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_7_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_8_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_9_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_10_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_11_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_12_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_13_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_14_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_15_seq;

  int trfldbpp_enable[16];
  int trfdirpp_enable[16];
  int trffrag_num;

  hqm_background_cfg_file_mode_seq      bg_cfg_seq;

  function new(string name = "hqm_trf_test_hcw_seq");
    super.new(name);

    trffrag_num=2;
    $value$plusargs("trf_frag_num=%0d",  trffrag_num);
    `ovm_info("HCW_PP_CQ_TRF_CFG",$psprintf("Get trffrag_num=%0d", trffrag_num),OVM_LOW)

    for(int i=0; i<16; i++) begin
      trfldbpp_enable[i] = 0;
      trfdirpp_enable[i] = 0;
    end

    $value$plusargs("trfldbpp0_enable=%0d",  trfldbpp_enable[0]);
    $value$plusargs("trfldbpp1_enable=%0d",  trfldbpp_enable[1]);
    $value$plusargs("trfldbpp2_enable=%0d",  trfldbpp_enable[2]);
    $value$plusargs("trfldbpp3_enable=%0d",  trfldbpp_enable[3]);
    $value$plusargs("trfldbpp4_enable=%0d",  trfldbpp_enable[4]);
    $value$plusargs("trfldbpp5_enable=%0d",  trfldbpp_enable[5]);
    $value$plusargs("trfldbpp6_enable=%0d",  trfldbpp_enable[6]);
    $value$plusargs("trfldbpp7_enable=%0d",  trfldbpp_enable[7]);
    $value$plusargs("trfldbpp8_enable=%0d",  trfldbpp_enable[8]);
    $value$plusargs("trfldbpp9_enable=%0d",  trfldbpp_enable[9]);
    $value$plusargs("trfldbpp10_enable=%0d", trfldbpp_enable[10]);
    $value$plusargs("trfldbpp11_enable=%0d", trfldbpp_enable[11]);
    $value$plusargs("trfldbpp12_enable=%0d", trfldbpp_enable[12]);  
    $value$plusargs("trfldbpp13_enable=%0d", trfldbpp_enable[13]);
    $value$plusargs("trfldbpp14_enable=%0d", trfldbpp_enable[14]);
    $value$plusargs("trfldbpp15_enable=%0d", trfldbpp_enable[15]);                                                          

    for(int i=0; i<16; i++) `ovm_info("HCW_PP_CQ_TRF_CFG",$psprintf("Get trfldbpp_enable[%0d]=%0d",i, trfldbpp_enable[i]),OVM_LOW)

  endfunction

  virtual task body();
    ovm_object  o_tmp;

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg %s not consistent with hqm_tb_cfg type", o_tmp.sprint()));
    end

    fork
      begin
        `ovm_do(bg_cfg_seq)
      end
      begin
        #1ns;
        if(trfldbpp_enable[0] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .dir_credit_count_in(0), .ldb_credit_count_in(4), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_0_seq));
      end
      begin
        #5ns;
        if(trfldbpp_enable[1] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(1), .is_vf(1), .vf_num(1), .qid(1), .qtype(QUNO), .renq_qid(1), .renq_qtype(QUNO), .dir_credit_count_in(0), .ldb_credit_count_in(4), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_1_seq));
      end
      begin
        #9ns;
        if(trfldbpp_enable[2] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(2), .qtype(QATM), .renq_qid(2), .renq_qtype(QUNO), .dir_credit_count_in(0), .ldb_credit_count_in(4), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_2_seq));
      end
      begin
        #13ns;
        if(trfldbpp_enable[3] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(3), .is_vf(1), .vf_num(3), .qid(3), .qtype(QATM), .renq_qid(3), .renq_qtype(QUNO), .dir_credit_count_in(0), .ldb_credit_count_in(4), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_3_seq));
      end
      begin
        #17ns;
        if(trfldbpp_enable[4] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(4), .qtype(QORD), .renq_qid(4), .renq_qtype(QATM), .dir_credit_count_in(0), .ldb_credit_count_in(4), .queue_list_size(trffrag_num), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_4_seq));
      end
      begin
        #21ns;
        if(trfldbpp_enable[5] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(5), .is_vf(1), .vf_num(5), .qid(5), .qtype(QORD), .renq_qid(5), .renq_qtype(QATM), .dir_credit_count_in(0), .ldb_credit_count_in(4), .queue_list_size(trffrag_num), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_5_seq));
      end
      begin
        #25ns;
        if(trfldbpp_enable[6] == 1) start_pp_cq(.is_ldb(0), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(6), .qtype(QDIR), .renq_qid(6), .renq_qtype(QUNO), .dir_credit_count_in(4), .ldb_credit_count_in(0), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_6_seq));
      end
      begin
        #29ns;
        if(trfldbpp_enable[7] == 1) start_pp_cq(.is_ldb(0), .pp_cq_num_in(7), .is_vf(1), .vf_num(9), .qid(7), .qtype(QDIR), .renq_qid(7), .renq_qtype(QUNO), .dir_credit_count_in(4), .ldb_credit_count_in(0), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_7_seq));
      end
      begin
        #33ns;
        if(trfldbpp_enable[8] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(8), .is_vf(0), .vf_num(0), .qid(72), .qtype(QDIR), .renq_qid(8), .renq_qtype(QUNO), .dir_credit_count_in(4), .ldb_credit_count_in(0), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_8_seq));
      end
      begin
        #37ns;
        if(trfldbpp_enable[9] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(9), .is_vf(1), .vf_num(7), .qid(73), .qtype(QDIR), .renq_qid(9), .renq_qtype(QUNO), .dir_credit_count_in(4), .ldb_credit_count_in(0), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_9_seq));
      end
      begin
        #41ns;
        if(trfldbpp_enable[10] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(10), .is_vf(1), .vf_num(0), .qid(122), .qtype(QDIR), .renq_qid(9), .renq_qtype(QUNO), .dir_credit_count_in(4), .ldb_credit_count_in(0), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_9_seq));
      end  
      begin
        #45ns;
        if(trfldbpp_enable[11] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(11), .is_vf(1), .vf_num(0), .qid(123), .qtype(QDIR), .renq_qid(9), .renq_qtype(QUNO), .dir_credit_count_in(4), .ldb_credit_count_in(0), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_9_seq));
      end 
      begin
        #49ns;
        if(trfldbpp_enable[12] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(12), .is_vf(1), .vf_num(0), .qid(124), .qtype(QDIR), .renq_qid(9), .renq_qtype(QUNO), .dir_credit_count_in(4), .ldb_credit_count_in(0), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_9_seq));
      end 
      begin
        #53ns;
        if(trfldbpp_enable[13] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(13), .is_vf(1), .vf_num(0), .qid(125), .qtype(QDIR), .renq_qid(9), .renq_qtype(QUNO), .dir_credit_count_in(4), .ldb_credit_count_in(0), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_9_seq));
      end 
      begin
        #57ns;
        if(trfldbpp_enable[14] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(14), .is_vf(0), .vf_num(0), .qid(126), .qtype(QDIR), .renq_qid(9), .renq_qtype(QUNO), .dir_credit_count_in(4), .ldb_credit_count_in(0), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_9_seq));
      end 
      begin
        #61ns;
        if(trfldbpp_enable[15] == 1) start_pp_cq(.is_ldb(1), .pp_cq_num_in(15), .is_vf(1), .vf_num(7), .qid(127), .qtype(QDIR), .renq_qid(9), .renq_qtype(QUNO), .dir_credit_count_in(4), .ldb_credit_count_in(0), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_9_seq));
      end                                   
    join

    super.body();

  endtask

  virtual task start_pp_cq(bit is_ldb, int pp_cq_num_in, bit is_vf, int vf_num, int qid, hcw_qtype qtype, int renq_qid, hcw_qtype renq_qtype, int dir_credit_count_in, int ldb_credit_count_in, int queue_list_size, int hcw_delay_in, output hqm_pp_cq_base_seq pp_cq_seq);
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
    int                 cq_poll_int;

    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    `ovm_info("START_PP_CQ",$psprintf("Starting PP/CQ processing: %s PP/CQ 0x%0x is_vf=%d vf_num=0x%0x qid=0x%0x qtype=%s dir_credit_count=0x%0x ldb_credit_count=0x%0x queue_list_size=%d hcw_delay=%d",is_ldb?"LDB":"DIR",pp_cq_num_in,is_vf,vf_num,qid,qtype.name(),dir_credit_count_in,ldb_credit_count_in,queue_list_size,hcw_delay_in),OVM_LOW)

    cq_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp_cq_num_in), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[63:32] = ral_data[31:0];

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp_cq_num_in), "hqm_system_csr");
    ral_data = my_reg.get_actual();

    cq_addr_val[31:6] = ral_data[31:6];
    ovm_report_info(get_full_name(), $psprintf("hqm_trf_test_hcw_seq: is_ldb=%0d pp_cq_num_in=%0d read cq_addr_u/l to get cq_addr_val=0x%0x", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- the above cq_addr_val read from CQ_ADDR ral is virtual address
    //-- to get physical address: cq_addr_val=i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in);  
    //----------------------------------
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in); 
        ovm_report_info(get_full_name(), $psprintf("hqm_trf_test_hcw_seq: is_ldb=%0d pp_cq_num_in=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);
    end  


    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_in);
    $value$plusargs({$psprintf("%s_PP%0d_DIR_CREDIT",pp_cq_prefix,pp_cq_num_in),"=%d"}, dir_credit_count_in);
    $value$plusargs({$psprintf("%s_PP%0d_LDB_CREDIT",pp_cq_prefix,pp_cq_num_in),"=%d"}, ldb_credit_count_in);


    cq_poll_int = 1;
    $value$plusargs({$psprintf("%s_PP%0d_CQ_POLL",pp_cq_prefix,pp_cq_num_in),"=%d"}, cq_poll_int);

    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_num_in));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
                     pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
                     pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

                     cq_depth                   == 1024;

                     queue_list.size()          == queue_list_size;

                     hcw_enqueue_batch_min      == 1;  // Minimum number of HCWs to send as a batch (1-4)
                     hcw_enqueue_batch_max      == 1;  // Maximum number of HCWs to send as a batch (1-4)

                     queue_list_delay_min       == hcw_delay_in;
                     queue_list_delay_max       == hcw_delay_in;

                     cq_addr                    == cq_addr_val;

                     cq_poll_interval           == cq_poll_int;
                   } ) begin
      `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end

    if ($value$plusargs({$psprintf("%s_PP%0d_VF",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, vf_num)) begin
      if (vf_num >= 0) begin
        is_vf   = 1;
      end else begin
        is_vf   = 0;
      end
    end

    pp_cq_seq.is_vf   = is_vf;
    pp_cq_seq.vf_num  = vf_num;

    $value$plusargs({$psprintf("%s_PP%0d_QID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, qid);

    qtype_str = qtype.name();
    $value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%s"}, qtype_str);
    qtype_str = qtype_str.tolower();

    lock_id = 16'h4001;
    $value$plusargs({$psprintf("%s_PP%0d_LOCKID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, lock_id);

    dsi = 16'h0100;
    $value$plusargs({$psprintf("%s_PP%0d_DSI",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, dsi);

    case (qtype_str)
      "qdir": qtype = QDIR;
      "quno": qtype = QUNO;
      "qatm": qtype = QATM;
      "qord": qtype = QORD;
    endcase

    for (int i = 0 ; i < queue_list_size ; i++) begin
      num_hcw_gen = 1;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);

      pp_cq_seq.queue_list[i].num_hcw                   = num_hcw_gen;

      if (qtype == QORD) begin
        pp_cq_seq.queue_list[i].qid                       = (i == 0) ? qid : renq_qid;
        pp_cq_seq.queue_list[i].qtype                     = (i == 0) ? qtype : renq_qtype;
        pp_cq_seq.queue_list[i].comp_flow                 = (i == 0) ? 0 : 1;
        pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;
      end else begin
        pp_cq_seq.queue_list[i].qid                       = qid + i;
        pp_cq_seq.queue_list[i].qtype                     = qtype;
        pp_cq_seq.queue_list[i].comp_flow                 = 1;
        pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;
      end

      pp_cq_seq.queue_list[i].qpri_weight[0]            = 1;
      pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
      pp_cq_seq.queue_list[i].lock_id                   = lock_id;
      pp_cq_seq.queue_list[i].dsi                       = dsi;
      pp_cq_seq.queue_list[i].illegal_hcw_gen_mode      = hqm_pp_cq_base_seq::NO_ILLEGAL;


      ovm_report_info(get_type_name(),$psprintf("start_pp_cq_generate__pp_cq_seq.queue_list[%0d]: num_hcw_gen=%0d/pp_cq_num_in=%0d/qtype=%0s/qid=%0d/lockid=0x%0x/delay=%0d", i, num_hcw_gen, pp_cq_num_in, pp_cq_seq.queue_list[i].qtype.name(), pp_cq_seq.queue_list[i].qid, lock_id, hcw_delay_in ),  OVM_LOW);

    end

    finish_item(pp_cq_seq);
  endtask

endclass
