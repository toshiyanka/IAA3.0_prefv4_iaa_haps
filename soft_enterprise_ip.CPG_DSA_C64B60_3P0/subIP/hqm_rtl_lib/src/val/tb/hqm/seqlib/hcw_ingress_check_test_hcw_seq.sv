import hqm_tb_cfg_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hcw_ingress_check_test_hcw_seq extends hqm_base_seq;

  `ovm_sequence_utils(hcw_ingress_check_test_hcw_seq, sla_sequencer)
  hqm_cfg               i_hqm_cfg;

  hqm_pp_cq_base_seq    ldb_pp_cq_0_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_1_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_2_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_3_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_4_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_5_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_6_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_7_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_8_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_9_seq;

  hqm_background_cfg_file_mode_seq      bg_cfg_seq;

  function new(string name = "hcw_ingress_check_test_hcw_seq");
    super.new(name);
  endfunction

  virtual task body();

    ovm_object o_tmp;

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
    end   

    fork
      begin
        #1ns;
        start_pp_cq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_0_seq));
      end
      begin
        #5ns;
        start_pp_cq(.is_ldb(1), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(1), .qtype(QUNO), .renq_qid(1), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_1_seq));
      end
      begin
        #9ns;
        start_pp_cq(.is_ldb(1), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(2), .qtype(QATM), .renq_qid(2), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_2_seq));
      end
      begin
        #13ns;
        start_pp_cq(.is_ldb(1), .pp_cq_num_in(3), .is_vf(0), .vf_num(0), .qid(3), .qtype(QATM), .renq_qid(3), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_3_seq));
      end
      begin
        #17ns;
        start_pp_cq(.is_ldb(1), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(4), .qtype(QORD), .renq_qid(4), .renq_qtype(QATM), .queue_list_size(2), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_4_seq));
      end
      begin
        #21ns;
        start_pp_cq(.is_ldb(1), .pp_cq_num_in(5), .is_vf(0), .vf_num(0), .qid(5), .qtype(QORD), .renq_qid(5), .renq_qtype(QATM), .queue_list_size(2), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_5_seq));
      end
      begin
        #25ns;
        start_pp_cq(.is_ldb(0), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(6), .qtype(QDIR), .renq_qid(6), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(dir_pp_cq_6_seq));
      end
      begin
        #29ns;
        start_pp_cq(.is_ldb(0), .pp_cq_num_in(7), .is_vf(0), .vf_num(0), .qid(7), .qtype(QDIR), .renq_qid(7), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(dir_pp_cq_7_seq));
      end
     begin
       #33ns;
        start_pp_cq(.is_ldb(1), .pp_cq_num_in(8), .is_vf(0), .vf_num(0), .qid(8), .qtype(QUNO), .renq_qid(8), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_8_seq));
     end
     begin
       #37ns;
       start_pp_cq(.is_ldb(1), .pp_cq_num_in(9), .is_vf(0), .vf_num(0), .qid(9), .qtype(QUNO), .renq_qid(9), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .pp_cq_seq(ldb_pp_cq_9_seq));
     end
    join

    super.body();

  endtask

  virtual task start_pp_cq(bit is_ldb, int pp_cq_num_in, bit is_vf, int vf_num, int qid, hcw_qtype qtype, int renq_qid, hcw_qtype renq_qtype,  int queue_list_size, int hcw_delay_in, output hqm_pp_cq_base_seq pp_cq_seq);
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
    int                 illegal_hcw_prob;
    int                 illegal_hcw_burst_len;
    hqm_pp_cq_base_seq::illegal_hcw_gen_mode_t      illegal_hcw_gen_mode;
    hqm_pp_cq_base_seq::illegal_hcw_type_t          illegal_hcw_type;
    string                      illegal_hcw_type_str;
    bit [6:0]       pf_pp_cq_num;


    `ovm_info("START_PP_CQ",$psprintf("Starting PP/CQ processing: %s PP/CQ 0x%0x is_vf=%d vf_num=0x%0x qid=0x%0x qtype=%s queue_list_size=%d hcw_delay=%d",is_ldb?"LDB":"DIR",pp_cq_num_in,is_vf,vf_num,qid,qtype.name(),queue_list_size,hcw_delay_in),OVM_LOW)

    cq_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end

    pf_pp_cq_num = i_hqm_cfg.get_pf_pp(is_vf, vf_num, is_ldb, pp_cq_num_in, 1'b1);
    cq_addr_val      = get_cq_addr_val(e_port_type'(is_ldb), pf_pp_cq_num);
    cq_addr_val[5:0] = 0;

    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_in);

    illegal_hcw_prob = 0;
    $value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_PROB",pp_cq_prefix,pp_cq_num_in),"=%d"}, illegal_hcw_prob);

    illegal_hcw_burst_len = 0;
    $value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_BURST_LEN",pp_cq_prefix,pp_cq_num_in),"=%d"}, illegal_hcw_burst_len);

    $value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_HCW_TYPE",pp_cq_prefix,pp_cq_num_in),"=%s"}, illegal_hcw_type_str);
    illegal_hcw_type_str = illegal_hcw_type_str.tolower();

    case (illegal_hcw_type_str)
      "illegal_hcw_cmd":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_HCW_CMD;
      "all_0":                  illegal_hcw_type = hqm_pp_cq_base_seq::ALL_0;
      "all_1":                  illegal_hcw_type = hqm_pp_cq_base_seq::ALL_1;
      "illegal_pp_num":         illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_PP_NUM;
      "illegal_pp_type":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_PP_TYPE;
      "illegal_qid_num":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_QID_NUM;
      "illegal_qid_type":       illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_QID_TYPE;
      "illegal_dev_vf_num":     illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_DEV_VF_NUM;
      "qid_grt_127":            illegal_hcw_type = hqm_pp_cq_base_seq::QID_GRT_127;
      "vas_write_permission":   illegal_hcw_type = hqm_pp_cq_base_seq::VAS_WRITE_PERMISSION;
    endcase

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
   // $value$plusargs({$psprintf("%s_PP%0d_DSI",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, dsi);

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
      pp_cq_seq.queue_list[i].illegal_hcw_burst_len     = (i == 0) ? illegal_hcw_burst_len : 0;
      pp_cq_seq.queue_list[i].illegal_hcw_prob          = (i == 0) ? illegal_hcw_prob : 0;
      if (pp_cq_seq.queue_list[i].illegal_hcw_prob > 0) begin
        pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::RAND_ILLEGAL;
      end else if (pp_cq_seq.queue_list[i].illegal_hcw_burst_len > 0) begin
        pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::BURST_ILLEGAL;
      end else begin
        pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::NO_ILLEGAL;
      end

      pp_cq_seq.queue_list[i].illegal_hcw_type_q.push_back(illegal_hcw_type);
    end

    finish_item(pp_cq_seq);
  endtask

endclass
