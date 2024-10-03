`ifndef HCW_TRAFFIC_ALL_RESOURCES_SEQ__SV
`define HCW_TRAFFIC_ALL_RESOURCES_SEQ__SV

class hcw_traffic_all_resources_seq extends hqm_base_seq;

  `ovm_sequence_utils(hcw_traffic_all_resources_seq, sla_sequencer)

  typedef bit [5:0]     pp_num_t;

  hqm_cfg               i_hqm_cfg;

  hqm_pp_cq_base_seq    dir_pf_pp_cq_seq[`HQM_NUM_DIR_PORTS];
  hqm_pp_cq_base_seq    ldb_pf_pp_cq_seq[`HQM_NUM_LDB_PORTS];

  function new(string name = "hcw_traffic_all_resources_seq");
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
          // -- PF only dir traffic
          for (int i = 0; i < `HQM_NUM_DIR_PORTS; i++) begin
              fork
                  automatic int j = i;
                  start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in(j),  .qid(j), .qtype(QDIR), .pp_cq_seq(dir_pf_pp_cq_seq[j]));
              join_none
          end
          wait fork;

          // -- PF only ldb traffic
          for (int i = 0; i < `HQM_NUM_LDB_PORTS; i++) begin
              fork
                  automatic int k = i;
                  if (k <= 31) begin
                      start_pp_cq(.is_ldb(1), .pp_cq_num_in(k),  .qid(k),        .qtype(QUNO), .pp_cq_seq(ldb_pf_pp_cq_seq[k]));
                  end else begin
                      start_pp_cq(.is_ldb(1), .pp_cq_num_in(k),  .qid((63 - k)), .qtype(QUNO), .pp_cq_seq(ldb_pf_pp_cq_seq[k]));
                  end
              join_none
          end
          wait fork;
      
  endtask

  virtual task start_pp_cq(bit is_ldb, int pp_cq_num_in, int qid, hcw_qtype qtype, output hqm_pp_cq_base_seq pp_cq_seq);

    logic [63:0]    cq_addr_val;
    int             num_hcw_gen;
    string          pp_cq_prefix;
    string          qtype_str;
    bit [6:0]       pf_pp_cq_num;

    cq_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end

    pf_pp_cq_num = i_hqm_cfg.get_pf_pp(1'b0, 0, is_ldb, pp_cq_num_in, 1'b1);

    cq_addr_val      = get_cq_addr_val(e_port_type'(is_ldb), pf_pp_cq_num);
    cq_addr_val[5:0] = 0;

    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix, pp_cq_num_in));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
            pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
            pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type
            queue_list.size()          == 1;
            hcw_enqueue_batch_min      == 1;  // Minimum number of HCWs to send as a batch (1-4)
            hcw_enqueue_batch_max      == 4;  // Maximum number of HCWs to send as a batch (1-4)
            cq_addr                    == cq_addr_val;
            cq_poll_interval           == 1;
            is_vf                      == 1'b0;
            vf_num                     == 0;
            } 
       ) begin
      `ovm_fatal("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end

    for (int i = 0 ; i < 1; i++) begin
      num_hcw_gen = 0;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);

      pp_cq_seq.queue_list[i].num_hcw               = num_hcw_gen;
      pp_cq_seq.queue_list[i].qid                   = qid;
      pp_cq_seq.queue_list[i].qtype                 = qtype;
      pp_cq_seq.queue_list[i].qpri_weight[0]        = 1;
      pp_cq_seq.queue_list[i].hcw_delay_min         = 0;
      pp_cq_seq.queue_list[i].hcw_delay_max         = 40;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only     = 1'b1;
      pp_cq_seq.queue_list[i].comp_flow             = 1;
      pp_cq_seq.queue_list[i].cq_token_return_flow  = 1;
      pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::NO_ILLEGAL;
    end

    finish_item(pp_cq_seq);
  endtask

endclass : hcw_traffic_all_resources_seq

`endif //HCW_TRAFFIC_ALL_RESOURCES_SEQ__SV

