`ifndef HCW_DIR_TEST_HCW_SEQ__SV
`define HCW_DIR_TEST_HCW_SEQ__SV

class hcw_dir_test_hcw_seq extends hqm_base_seq;

  `ovm_sequence_utils(hcw_dir_test_hcw_seq, sla_sequencer)

  hqm_cfg               i_hqm_cfg;

  //PF only
  hqm_pp_cq_base_seq    pf_pp_cq_5_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_6_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_7_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_20_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_21_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_30_seq;

  //VF only
  hqm_pp_cq_base_seq    vf_0_pp_cq_2_seq;
  hqm_pp_cq_base_seq    vf_0_pp_cq_3_seq;
  hqm_pp_cq_base_seq    vf_7_pp_cq_20_seq;
  hqm_pp_cq_base_seq    vf_7_pp_cq_21_seq;
  hqm_pp_cq_base_seq    vf_2_pp_cq_2_seq;
  hqm_pp_cq_base_seq    vf_2_pp_cq_3_seq;
  hqm_pp_cq_base_seq    vf_3_pp_cq_2_seq;
  hqm_pp_cq_base_seq    vf_3_pp_cq_3_seq;
  hqm_pp_cq_base_seq    vf_4_pp_cq_2_seq;
  hqm_pp_cq_base_seq    vf_4_pp_cq_3_seq;
  hqm_pp_cq_base_seq    vf_5_pp_cq_2_seq;
  hqm_pp_cq_base_seq    vf_5_pp_cq_3_seq;
  hqm_pp_cq_base_seq    vf_10_pp_cq_20_seq;
  hqm_pp_cq_base_seq    vf_10_pp_cq_21_seq;
  hqm_pp_cq_base_seq    vf_15_pp_cq_30_seq;
  hqm_pp_cq_base_seq    vf_15_pp_cq_31_seq;

  //PF+VF
  hqm_pp_cq_base_seq    vf_1_pp_cq_0_seq;
  hqm_pp_cq_base_seq    vf_1_pp_cq_63_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_35_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_36_seq;

  hqm_pp_cq_base_seq    vf_14_pp_cq_1_seq;
  hqm_pp_cq_base_seq    vf_14_pp_cq_62_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_60_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_61_seq;

  hqm_pp_cq_base_seq    vf_6_pp_cq_2_seq;
  hqm_pp_cq_base_seq    vf_6_pp_cq_61_seq;
  hqm_pp_cq_base_seq    vf_6_pp_cq_3_seq;
  hqm_pp_cq_base_seq    vf_6_pp_cq_60_seq;

  function new(string name = "hcw_dir_test_hcw_seq");
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


          // -- PF only traffic
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d5),   .qid('d21),  .qtype(QDIR), .is_nm_pf(1'b1), .vf_num_val('d0),   .pp_cq_seq(pf_pp_cq_5_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d20),  .qid('d5),   .qtype(QDIR), .is_nm_pf(1'b1), .vf_num_val('d0),   .pp_cq_seq(pf_pp_cq_20_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d21),  .qid('d20),  .qtype(QDIR), .is_nm_pf(1'b1), .vf_num_val('d0),   .pp_cq_seq(pf_pp_cq_21_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d6),   .qid('d7),   .qtype(QDIR), .is_nm_pf(1'b1), .vf_num_val('d0),   .pp_cq_seq(pf_pp_cq_6_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d7),   .qid('d30),  .qtype(QDIR), .is_nm_pf(1'b1), .vf_num_val('d0),   .pp_cq_seq(pf_pp_cq_7_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d30),  .qid('d6),   .qtype(QDIR), .is_nm_pf(1'b1), .vf_num_val('d0),   .pp_cq_seq(pf_pp_cq_30_seq)); end   


          // -- VF only traffic
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d2),   .qid('d3),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d0),   .pp_cq_seq(vf_0_pp_cq_2_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d3),   .qid('d4),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d0),   .pp_cq_seq(vf_0_pp_cq_3_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d20),  .qid('d30),  .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d7),   .pp_cq_seq(vf_7_pp_cq_20_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d21),  .qid('d31),  .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d7),   .pp_cq_seq(vf_7_pp_cq_21_seq)); end   

          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d20),  .qid('d30),  .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d10),  .pp_cq_seq(vf_10_pp_cq_20_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d21),  .qid('d31),  .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d10),  .pp_cq_seq(vf_10_pp_cq_21_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d30),  .qid('d10),  .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d15),  .pp_cq_seq(vf_15_pp_cq_30_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d31),  .qid('d11),  .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d15),  .pp_cq_seq(vf_15_pp_cq_31_seq)); end   

          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d2),   .qid('d3),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d2),   .pp_cq_seq(vf_2_pp_cq_2_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d3),   .qid('d4),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d2),   .pp_cq_seq(vf_2_pp_cq_3_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d2),   .qid('d3),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d3),   .pp_cq_seq(vf_3_pp_cq_2_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d3),   .qid('d4),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d3),   .pp_cq_seq(vf_3_pp_cq_3_seq)); end   

          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d2),   .qid('d3),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d4),   .pp_cq_seq(vf_4_pp_cq_2_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d3),   .qid('d4),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d4),   .pp_cq_seq(vf_4_pp_cq_3_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d2),   .qid('d3),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d5),   .pp_cq_seq(vf_5_pp_cq_2_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d3),   .qid('d4),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d5),   .pp_cq_seq(vf_5_pp_cq_3_seq)); end   

          // -- PF + VF traffic
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d0),   .qid('d27),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d1),    .pp_cq_seq(vf_1_pp_cq_0_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d63),  .qid('d26),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d1),    .pp_cq_seq(vf_1_pp_cq_63_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d35),  .qid('d41),   .qtype(QDIR), .is_nm_pf(1'b1), .vf_num_val('d0),    .pp_cq_seq(pf_pp_cq_35_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d36),  .qid('d40),   .qtype(QDIR), .is_nm_pf(1'b1), .vf_num_val('d0),    .pp_cq_seq(pf_pp_cq_36_seq)); end   

          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d1),  .qid('d29),  .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d14),   .pp_cq_seq(vf_14_pp_cq_1_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d62), .qid('d28),  .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d14),   .pp_cq_seq(vf_14_pp_cq_62_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d60), .qid('d58),  .qtype(QDIR), .is_nm_pf(1'b1), .vf_num_val('d0),    .pp_cq_seq(pf_pp_cq_60_seq)); end   
          begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d61), .qid('d57),  .qtype(QDIR), .is_nm_pf(1'b1), .vf_num_val('d0),    .pp_cq_seq(pf_pp_cq_61_seq)); end  

          // -- Source VF == Destination VF
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d2),   .qid('d27),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d6),    .pp_cq_seq(vf_6_pp_cq_2_seq)); end  
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d61),  .qid('d26),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d6),    .pp_cq_seq(vf_6_pp_cq_61_seq)); end  
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d3),   .qid('d25),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d6),    .pp_cq_seq(vf_6_pp_cq_3_seq)); end  
          //begin start_pp_cq(.is_ldb(1'b0), .pp_cq_num_in('d60),  .qid('d24),   .qtype(QDIR), .is_nm_pf(1'b0), .vf_num_val('d6),    .pp_cq_seq(vf_6_pp_cq_60_seq)); end  

      join

  endtask

  virtual task start_pp_cq(bit is_ldb, int pp_cq_num_in, int qid, hcw_qtype qtype, bit is_nm_pf, int vf_num_val, output hqm_pp_cq_base_seq pp_cq_seq);

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

    //--pf_pp_cq_num = i_hqm_cfg.get_pf_pp(is_nm_pf, vf_num_val, is_ldb, pp_cq_num_in, 1'b1);
    pf_pp_cq_num = pp_cq_num_in;

    cq_addr_val      = get_cq_addr_val(e_port_type'(is_ldb), pf_pp_cq_num);
    cq_addr_val[5:0] = 0;


    ovm_report_info(get_full_name(), $psprintf("start_pp_cq -- is_nm_pf=%0d is_ldb=%0d pf_pp_cq_num=%0d qid=%0d qtype=%0s cq_addr=0x%0x", is_nm_pf, is_ldb, pf_pp_cq_num, qid, qtype.name(), cq_addr_val), OVM_LOW);
    `ovm_create(pp_cq_seq)
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_num_in));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
            pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
            pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type
            queue_list.size()          == 1;
            hcw_enqueue_batch_min      == 1;  // Minimum number of HCWs to send as a batch (1-4)
            hcw_enqueue_batch_max      == 4;  // Maximum number of HCWs to send as a batch (1-4)
            cq_addr                    == cq_addr_val;
            cq_poll_interval           == 1;
            } 
       ) begin
      `ovm_fatal("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end

    if ($test$plusargs($psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_seq.pp_cq_num))) begin
        void'($value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%s"}, qtype_str));
        qtype   = hcw_qtype_enum_utils::str2enum(qtype_str);
    end

    for (int i = 0 ; i < 1; i++) begin
      num_hcw_gen = 0;
         //$value$plusargs({$psprintf("%s_VF%0d_PP%0d_Q%0d_NUM_HCW", pp_cq_prefix, vf_num_val, pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);
         $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);

      pp_cq_seq.queue_list[i].is_nm_pf             = is_nm_pf;
      pp_cq_seq.queue_list[i].num_hcw              = num_hcw_gen;
      pp_cq_seq.queue_list[i].qid                  = qid;
      pp_cq_seq.queue_list[i].qtype                = qtype;
      pp_cq_seq.queue_list[i].qpri_weight[0]       = 1;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only    = 1'b1;
      pp_cq_seq.queue_list[i].comp_flow            = 1;
      pp_cq_seq.queue_list[i].cq_token_return_flow = 1;
      pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::NO_ILLEGAL;
      if ($test$plusargs("RANDOM_PRI")) begin
          ovm_report_info(get_full_name(), $psprintf("Randomized priority selected"), OVM_LOW);
          foreach(pp_cq_seq.queue_list[i].qpri_weight[idx]) begin
              pp_cq_seq.queue_list[i].qpri_weight[idx] = 1;
          end
      end
      if ($test$plusargs("SKEWED_PRI")) begin
          ovm_report_info(get_full_name(), $psprintf("Skewed priority selected"), OVM_LOW);
          pp_cq_seq.queue_list[i].qpri_weight[0] = 79;
          pp_cq_seq.queue_list[i].qpri_weight[1] = 3;
          pp_cq_seq.queue_list[i].qpri_weight[2] = 3;
          pp_cq_seq.queue_list[i].qpri_weight[3] = 3;
          pp_cq_seq.queue_list[i].qpri_weight[4] = 3;
          pp_cq_seq.queue_list[i].qpri_weight[5] = 3;
          pp_cq_seq.queue_list[i].qpri_weight[6] = 3;
          pp_cq_seq.queue_list[i].qpri_weight[7] = 3;
      end
    end

    finish_item(pp_cq_seq);
  endtask

endclass : hcw_dir_test_hcw_seq

`endif //HCW_DIR_TEST_HCW_SEQ__SV
