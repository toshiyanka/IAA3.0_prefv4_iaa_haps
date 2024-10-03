`ifndef HCW_LDB_TRAFFIC_SEQ__SV
`define HCW_LDB_TRAFFIC_SEQ__SV

class hcw_ldb_traffic_seq extends hqm_base_seq;

  `ovm_sequence_utils(hcw_ldb_traffic_seq, sla_sequencer)

  typedef bit [5:0]     pp_num_t;

  hqm_cfg               i_hqm_cfg;

  hqm_pp_cq_base_seq    pf_pp_cq_seq[`HQM_NUM_LDB_PORTS];
                  int   pf_num_hcw_gen[pp_num_t];

  function new(string name = "hcw_ldb_traffic_seq");
    super.new(name);
    get_plusargs();
  endfunction

  virtual function void get_plusargs();

      ovm_report_info(get_full_name(), $psprintf("get_plusargs -- Start"), OVM_DEBUG);
      for (int pp_num = 0; pp_num < `HQM_NUM_LDB_PORTS; pp_num++) begin
         
          // -- Get number of HCW to be generated per PP
          int num_hcw_gen;

          if ($value$plusargs({$psprintf("LDB_PP%0d_Q0_NUM_HCW", pp_num), "=%0d"}, num_hcw_gen))begin
              pf_num_hcw_gen[pp_num] = num_hcw_gen;
              ovm_report_info(get_full_name(), $psprintf("pf_num_hcw_gen[%0d]=%0d", pp_num, pf_num_hcw_gen[pp_num]), OVM_LOW);
          end

      end
      ovm_report_info(get_full_name(), $psprintf("get_plusargs -- End"),   OVM_DEBUG);

  endfunction : get_plusargs

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

      // -- PF only traffic
      for (int i = 0; i < `HQM_NUM_LDB_PORTS; i++) begin
          fork
              automatic int j = i;
              if (j <= 31) begin
                  start_pp_cq( .pp_cq_num_in(j),  .qid(j),        .qtype(QUNO), .pp_cq_seq(pf_pp_cq_seq[j]));
              end else begin
                  start_pp_cq( .pp_cq_num_in(j),  .qid((63 - j)), .qtype(QUNO), .pp_cq_seq(pf_pp_cq_seq[j]));
              end
          join_none
      end
      wait fork;
      
  endtask

  virtual task start_pp_cq(int pp_cq_num_in, int qid, hcw_qtype qtype, output hqm_pp_cq_base_seq pp_cq_seq);

    logic [63:0]    cq_addr_val;
    int             num_hcw_gen;
    string          pp_cq_prefix;
    string          qtype_str;
    bit [6:0]       pf_pp_cq_num;

    cq_addr_val = '0;
    pp_cq_prefix = "LDB";

    pf_pp_cq_num = i_hqm_cfg.get_pf_pp(1'b0, 0, 1'b1, pp_cq_num_in, 1'b1);

    cq_addr_val      = get_cq_addr_val(LDB, pf_pp_cq_num);
    cq_addr_val[5:0] = 0;

    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("LDB_PP%0d", pp_cq_num_in));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
            pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
            pp_cq_type                 == hqm_pp_cq_base_seq::IS_LDB;  // Producer Port/Consumer Queue type
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

      num_hcw_gen = pf_num_hcw_gen[pp_cq_num_in];
      pp_cq_seq.queue_list[i].num_hcw               = num_hcw_gen;
      pp_cq_seq.queue_list[i].is_nm_pf              = 1;
      pp_cq_seq.queue_list[i].qid                   = qid;
      pp_cq_seq.queue_list[i].qtype                 = qtype;
      pp_cq_seq.queue_list[i].qpri_weight[0]        = 1;
      pp_cq_seq.queue_list[i].hcw_delay_min         = 0;
      pp_cq_seq.queue_list[i].hcw_delay_max         = 40;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only     = 1'b1;
      pp_cq_seq.queue_list[i].comp_flow             = 1;
      pp_cq_seq.queue_list[i].cq_token_return_flow  = 1;
    end

    finish_item(pp_cq_seq);
  endtask

endclass : hcw_ldb_traffic_seq
`endif //HCW_LDB_TRAFFIC_SEQ__SV
