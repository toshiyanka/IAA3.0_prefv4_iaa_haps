import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hcw_perf_dir_test1_hcw_seq extends sla_sequence_base;

  `ovm_sequence_utils(hcw_perf_dir_test1_hcw_seq, sla_sequencer)

  hqm_tb_cfg            i_hqm_cfg;

  hqm_pp_cq_base_seq    dir_pp_cq_0_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_1_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_2_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_3_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_4_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_5_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_6_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_7_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_8_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_9_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_10_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_11_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_12_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_13_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_14_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_15_seq;

  function new(string name = "hcw_perf_dir_test1_hcw_seq");
    super.new(name);
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
        start_pp_cq(0,0,0,QDIR, 1,32,dir_pp_cq_0_seq);
      end
      begin
        #2ns;
        start_pp_cq(0,1,1,QDIR, 1,32,dir_pp_cq_1_seq);
      end
      begin
        #4ns;
        start_pp_cq(0,2,2,QDIR, 1,32,dir_pp_cq_2_seq);
      end
      begin
        #6ns;
        start_pp_cq(0,3,3,QDIR, 1,32,dir_pp_cq_3_seq);
      end
      begin
        #8ns;
        start_pp_cq(0,4,4,QDIR, 1,32,dir_pp_cq_4_seq);
      end
      begin
        #10ns;
        start_pp_cq(0,5,5,QDIR, 1,32,dir_pp_cq_5_seq);
      end
      begin
        #12ns;
        start_pp_cq(0,6,6,QDIR, 1,32,dir_pp_cq_6_seq);
      end
      begin
        #14ns;
        start_pp_cq(0,7,7,QDIR, 1,32,dir_pp_cq_7_seq);
      end
      begin
        #16ns;
        start_pp_cq(0,8,8,QDIR, 1,32,dir_pp_cq_8_seq);
      end
      begin
        #18ns;
        start_pp_cq(0,9,9,QDIR, 1,32,dir_pp_cq_9_seq);
      end
      begin
        #20ns;
        start_pp_cq(0,10,10,QDIR, 1,32,dir_pp_cq_10_seq);
      end
      begin
        #22ns;
        start_pp_cq(0,11,11,QDIR, 1,32,dir_pp_cq_11_seq);
      end
      begin
        #24ns;
        start_pp_cq(0,12,12,QDIR, 1,32,dir_pp_cq_12_seq);
      end
      begin
        #26ns;
        start_pp_cq(0,13,13,QDIR, 1,32,dir_pp_cq_13_seq);
      end
      begin
        #28ns;
        start_pp_cq(0,14,14,QDIR, 1,32,dir_pp_cq_14_seq);
      end
      begin
        #30ns;
        start_pp_cq(0,15,15,QDIR, 1,32,dir_pp_cq_15_seq);
      end
    join

    super.body();

  endtask

  virtual task start_pp_cq(bit is_ldb, int pp_cq_num_in, int qid, hcw_qtype qtype, int queue_list_size, int hcw_delay_in, output hqm_pp_cq_base_seq pp_cq_seq);
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

    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    

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
    ovm_report_info(get_full_name(), $psprintf("hcw_perf_dir_test1_hcw_seq: is_ldb=%0d pp_cq_num_in=%0d read cq_addr_u/l to get cq_addr_val=0x%0x", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- the above cq_addr_val read from CQ_ADDR ral is virtual address
    //-- to get physical address: cq_addr_val=i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in);  
    //----------------------------------
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in); 
        ovm_report_info(get_full_name(), $psprintf("hcw_perf_dir_test1_hcw_seq: is_ldb=%0d pp_cq_num_in=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);
    end  


    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_in);

    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_num_in));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
                     pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
                     pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

                     queue_list.size()          == queue_list_size;

                     hcw_enqueue_batch_min      == 1;  // Minimum number of HCWs to send as a batch (1-4)
                     hcw_enqueue_batch_max      == 1;  // Maximum number of HCWs to send as a batch (1-4)

                     queue_list_delay_min       == hcw_delay_in;
                     queue_list_delay_max       == hcw_delay_in;

                     cq_addr                    == cq_addr_val;

                     cq_poll_interval           == 1;
                   } ) begin
      `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end

    vf_num_val = -1;

    $value$plusargs({$psprintf("%s_PP%0d_VF",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, vf_num_val);

    if (vf_num_val >= 0) begin
      pp_cq_seq.is_vf   = 1;
      pp_cq_seq.vf_num  = vf_num_val;
    end

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
      pp_cq_seq.queue_list[i].qid                       = qid + i;
      pp_cq_seq.queue_list[i].qtype                     = qtype;
      pp_cq_seq.queue_list[i].qpri_weight[0]            = 1;
      pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
      pp_cq_seq.queue_list[i].lock_id                   = lock_id;
      pp_cq_seq.queue_list[i].dsi                       = dsi;
      pp_cq_seq.queue_list[i].comp_flow                 = 1;
      pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;
      pp_cq_seq.queue_list[i].illegal_hcw_gen_mode      = hqm_pp_cq_base_seq::NO_ILLEGAL;
    end

    finish_item(pp_cq_seq);
  endtask

endclass
