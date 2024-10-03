`ifndef HCW_LDB_TEST_HCW_SEQ__SV
`define HCW_LDB_TEST_HCW_SEQ__SV

class hcw_ldb_test_hcw_seq extends hqm_base_seq;

  `ovm_sequence_utils(hcw_ldb_test_hcw_seq, sla_sequencer)

  hqm_cfg               i_hqm_cfg;

  hqm_pp_cq_base_seq    pf_pp_cq_20_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_21_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_30_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_31_seq;

  hqm_pp_cq_base_seq    vf_0_pp_cq_2_seq;
  hqm_pp_cq_base_seq    vf_0_pp_cq_3_seq;
  hqm_pp_cq_base_seq    vf_7_pp_cq_20_seq;
  hqm_pp_cq_base_seq    vf_7_pp_cq_21_seq;
  hqm_pp_cq_base_seq    vf_10_pp_cq_20_seq;
  hqm_pp_cq_base_seq    vf_10_pp_cq_21_seq;
  hqm_pp_cq_base_seq    vf_15_pp_cq_30_seq;
  hqm_pp_cq_base_seq    vf_15_pp_cq_31_seq;

  hqm_pp_cq_base_seq    vf_1_pp_cq_0_seq;
  hqm_pp_cq_base_seq    vf_1_pp_cq_63_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_24_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_25_seq;

  hqm_pp_cq_base_seq    vf_14_pp_cq_1_seq;
  hqm_pp_cq_base_seq    vf_14_pp_cq_62_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_4_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_5_seq;

  hqm_pp_cq_base_seq    vf_6_pp_cq_2_seq;
  hqm_pp_cq_base_seq    vf_6_pp_cq_61_seq;
  hqm_pp_cq_base_seq    vf_6_pp_cq_3_seq;
  hqm_pp_cq_base_seq    vf_6_pp_cq_60_seq;

  hqm_pp_cq_base_seq    pf_pp_cq_14_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_15_seq;

  hqm_pp_cq_base_seq    pf_pp_cq_12_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_13_seq;

  hqm_pp_cq_base_seq    pf_pp_cq_8_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_9_seq;

  hqm_pp_cq_base_seq    pf_pp_cq_16_seq;
  hqm_pp_cq_base_seq    pf_pp_cq_17_seq;

  function new(string name = "hcw_ldb_test_hcw_seq");
    super.new(name);
  endfunction

  virtual task body();

      ovm_object o_tmp;
    sla_ral_data_t rd_val;

      //-----------------------------
      //-- get i_hqm_cfg
      //-----------------------------
      if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
        ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
      end

      if (!$cast(i_hqm_cfg, o_tmp)) begin
        ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
      end   
      
      // under ATM guard     disable CQs;
      if ( $test$plusargs("CHECK_QPRI_LATENCY") ) begin
          for (int i=0;i<64;i++) begin
              write_reg($psprintf("cfg_cq_ldb_disable[%0d]",i),   1,         "list_sel_pipe");
              compare_reg($psprintf("cfg_cq_ldb_disable[%0d]",i), 1, rd_val, "list_sel_pipe");
          end
      end   

      fork

          // -- PF only traffic

          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d20),  .qid('d5),   .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0),   .pp_cq_seq(pf_pp_cq_20_seq)); end   
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d21),  .qid('d6),   .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0),   .pp_cq_seq(pf_pp_cq_21_seq)); end   
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d30),  .qid('d7),   .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0),   .pp_cq_seq(pf_pp_cq_30_seq)); end   
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d31),  .qid('d8),   .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0),   .pp_cq_seq(pf_pp_cq_31_seq)); end   

          // -- VF only traffic
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d2),   .qid('d3),   .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d0),   .pp_cq_seq(vf_0_pp_cq_2_seq)); end   
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d3),   .qid('d4),   .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d0),   .pp_cq_seq(vf_0_pp_cq_3_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d20),  .qid('d30),  .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d7),   .pp_cq_seq(vf_7_pp_cq_20_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d21),  .qid('d31),  .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d7),   .pp_cq_seq(vf_7_pp_cq_21_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d20),  .qid('d30),  .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d10),  .pp_cq_seq(vf_10_pp_cq_20_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d21),  .qid('d31),  .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d10),  .pp_cq_seq(vf_10_pp_cq_21_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d30),  .qid('d10),  .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d15),  .pp_cq_seq(vf_15_pp_cq_30_seq)); end   
          //begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d31),  .qid('d11),  .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d15),  .pp_cq_seq(vf_15_pp_cq_31_seq)); end   

          // -- PF + VF traffic
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d0),   .qid('d31),   .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d1),    .pp_cq_seq(vf_1_pp_cq_0_seq)); end   
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d63),  .qid('d30),   .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d1),    .pp_cq_seq(vf_1_pp_cq_63_seq)); end   
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d24),  .qid('d28),   .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0),    .pp_cq_seq(pf_pp_cq_24_seq)); end   
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d25),  .qid('d29),   .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0),    .pp_cq_seq(pf_pp_cq_25_seq)); end   

          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d1),  .qid('d29),  .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d14),    .pp_cq_seq(vf_14_pp_cq_1_seq)); end  //pp[1] vqid[29] qid[27] => cq[22] or cq[23]  
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d62), .qid('d28),  .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d14),   .pp_cq_seq(vf_14_pp_cq_62_seq)); end  //pp[62] vqid[28] : qid[26] => cq[22] or cq[23]
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d4),  .qid('d4),   .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0),    .pp_cq_seq(pf_pp_cq_4_seq)); end   
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d5),  .qid('d9),   .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0),    .pp_cq_seq(pf_pp_cq_5_seq)); end  

          // -- Source VF == Destination VF
          //begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d2),   .qid('d27),   .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d6),    .pp_cq_seq(vf_6_pp_cq_2_seq)); end  
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d61),  .qid('d26),   .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d6),    .pp_cq_seq(vf_6_pp_cq_61_seq)); end //pp[61] vqid[26] : qid[13] => cq[6] or cq[7] 
          //begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d3),   .qid('d25),   .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d6),    .pp_cq_seq(vf_6_pp_cq_3_seq)); end  
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d60),  .qid('d24),   .qtype(QUNO), .is_nm_pf(1'b0), .vf_num_val('d6),    .pp_cq_seq(vf_6_pp_cq_60_seq)); end //pp[60] vqid[24] : qid[24] => cq[18] or cq[19] 

          // --Other traffic
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d14), .qid('d18), .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0), .pp_cq_seq(pf_pp_cq_14_seq)); end
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d15), .qid('d19), .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0), .pp_cq_seq(pf_pp_cq_15_seq)); end

          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d12), .qid('d16), .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0), .pp_cq_seq(pf_pp_cq_12_seq)); end
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d13), .qid('d17), .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0), .pp_cq_seq(pf_pp_cq_13_seq)); end

          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d8), .qid('d14), .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0), .pp_cq_seq(pf_pp_cq_8_seq)); end
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d9), .qid('d15), .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0), .pp_cq_seq(pf_pp_cq_9_seq)); end

          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d16), .qid('d22), .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0), .pp_cq_seq(pf_pp_cq_16_seq)); end
          begin start_pp_cq(.is_ldb(1'b1), .pp_cq_num_in('d17), .qid('d23), .qtype(QUNO), .is_nm_pf(1'b1), .vf_num_val('d0), .pp_cq_seq(pf_pp_cq_17_seq)); end
      begin
          // under ATM guard     wait_for_system_cnt_0 = 16k & enable CQs;
          if ( $test$plusargs("CHECK_QPRI_LATENCY") ) begin
              poll_reg("hqm_system_cnt_0", 32'h4000, "hqm_system_csr");
              for (int i=0;i<64;i++) begin
                  write_reg($psprintf("cfg_cq_ldb_disable[%0d]",i),   0,         "list_sel_pipe");
                  compare_reg($psprintf("cfg_cq_ldb_disable[%0d]",i), 0, rd_val, "list_sel_pipe");
              end
          end   
      end

      join

  endtask

  virtual task start_pp_cq(bit is_ldb, int pp_cq_num_in, int qid, hcw_qtype qtype, bit is_nm_pf, int vf_num_val, output hqm_pp_cq_base_seq pp_cq_seq);

    logic [63:0]    cq_addr_val;
    int             num_hcw_gen;
    string          pp_cq_prefix;
    string          qtype_str;
    bit [6:0]       pf_pp_cq_num;
    sla_ral_data_t  val;
    bit             is_nm_pf_val;
    int             lcl_cq_poll;
    int             msi_num;

    cq_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end

    //pf_pp_cq_num = i_hqm_cfg.get_pf_pp(is_nm_pf, vf_num_val, is_ldb, pp_cq_num_in, 1'b1);
    pf_pp_cq_num = pp_cq_num_in; 

    cq_addr_val      = get_cq_addr_val(e_port_type'(is_ldb), pf_pp_cq_num);
    cq_addr_val[5:0] = 0;

    for (int i = 0 ; i < 64; i++) begin
       if (is_nm_pf==0) begin
          $value$plusargs({$psprintf("%s_VF%0d_PP%0d_NM_PF", pp_cq_prefix, vf_num_val, pp_cq_num_in),"=%d"}, is_nm_pf_val);
       end else begin
          $value$plusargs({$psprintf("%s_PP%0d_NM_PF",pp_cq_prefix, pp_cq_num_in),"=%d"}, is_nm_pf_val);
       end
    end
    ovm_report_info(get_full_name(), $psprintf("start_pp_cq -- is_nm_pf=%0d is_ldb=%0d pf_pp_cq_num=%0d qid=%0d qtype=%0s cq_addr=0x%0x", is_nm_pf, is_ldb, pf_pp_cq_num, qid, qtype.name(), cq_addr_val), OVM_LOW);
 
    `ovm_create(pp_cq_seq)
    if (is_nm_pf_val && is_nm_pf==0) begin
        ovm_report_info(get_full_name(), $psprintf("Switching off the c_vf constraint to test for error scenarios"), OVM_LOW);
        pp_cq_seq.c_vf.constraint_mode(0);
    end
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_num_in));
    start_item(pp_cq_seq);

    // -- Set cq_poll
    lcl_cq_poll = 1;
    if (is_nm_pf==0) begin
          if ($test$plusargs($psprintf("%s_VF%0d_PP%0d_CQ_POLL", pp_cq_prefix, vf_num_val, pp_cq_num_in))) begin
              
              $value$plusargs({$psprintf("%s_VF%0d_PP%0d_CQ_POLL", pp_cq_prefix, vf_num_val, pp_cq_num_in), "=%0d"}, lcl_cq_poll);
              ovm_report_info(get_full_name(), $psprintf("%s_VF%0d_PP%0d_CQ_POLL=%d",  pp_cq_prefix, vf_num_val, pp_cq_num_in, lcl_cq_poll), OVM_LOW);
          end
    end else begin
          if ($test$plusargs($psprintf("%s_PP%0d_CQ_POLL", pp_cq_prefix, pp_cq_num_in))) begin
              
              $value$plusargs({$psprintf("%s_PP%0d_CQ_POLL", pp_cq_prefix, pp_cq_num_in), "=%d"}, lcl_cq_poll);
              ovm_report_info(get_full_name(), $psprintf("%s_PP%0d_CQ_POLL=%d",  pp_cq_prefix, pp_cq_num_in, lcl_cq_poll), OVM_LOW);
          end
    end

    //if ( (lcl_cq_poll == 0) && is_nm_pf )begin
    //    msi_num = i_hqm_cfg.get_msi_num(pf_pp_cq_num, vf_num_val, is_ldb);
    //    ovm_report_info(get_full_name(), $psprintf("msi_num=%0d(pp_cq_num=0x%0x(pf_pp_cq_num=0x%0x), vf_num=0x%0x, is_ldb=%0b)", msi_num, pp_cq_num_in, pf_pp_cq_num, vf_num_val, is_ldb), OVM_LOW);
    //end

    if (!pp_cq_seq.randomize() with {
            pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
            pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type
            queue_list.size()          == 1;
            hcw_enqueue_batch_min      == 1;  // Minimum number of HCWs to send as a batch (1-4)
            hcw_enqueue_batch_max      == 4;  // Maximum number of HCWs to send as a batch (1-4)
            cq_addr                    == cq_addr_val;
            cq_poll_interval           == lcl_cq_poll;
            is_nm_pf                   == is_nm_pf;
            //msi_int_num                == msi_num;
            } 
       ) begin
      `ovm_fatal("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end

    if (is_nm_pf==0) begin
        if ($test$plusargs($psprintf("%s_VF%0d_PP%0d_QTYPE", pp_cq_prefix, vf_num_val, pp_cq_seq.pp_cq_num))) begin
            void'($value$plusargs({$psprintf("%s_VF%0d_PP%0d_QTYPE", pp_cq_prefix, vf_num_val, pp_cq_seq.pp_cq_num),"=%s"}, qtype_str));
            qtype   = hcw_qtype_enum_utils::str2enum(qtype_str);
        end
    end else begin
        if ($test$plusargs($psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_seq.pp_cq_num))) begin
            void'($value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%s"}, qtype_str));
            qtype   = hcw_qtype_enum_utils::str2enum(qtype_str);
        end
    end

    // -- comp_return_delay
    if (is_nm_pf==0) begin

        int comp_return_delay;

        if ($value$plusargs({$psprintf("%s_VF%0d_PP%0d_COMP_RETURN_DELAY", pp_cq_prefix, vf_num_val, pp_cq_seq.pp_cq_num), "=%d"}, comp_return_delay)) begin
            pp_cq_seq.comp_return_delay_q.push_back(comp_return_delay);
            ovm_report_info(get_full_name(), $psprintf("%s_VF%0d_PP%0d_COMP_RETURN_DELAY=%0d", pp_cq_prefix, vf_num_val, pp_cq_seq.pp_cq_num, comp_return_delay), OVM_LOW);
        end 
    end else begin

        int comp_return_delay;

        if ($value$plusargs({$psprintf("%s_PP%0d_COMP_RETURN_DELAY", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, comp_return_delay)) begin
            pp_cq_seq.comp_return_delay_q.push_back(comp_return_delay);
            ovm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, comp_return_delay), OVM_LOW);
        end
    end

    for (int i = 0 ; i < 1; i++) begin
      num_hcw_gen = 0;
      if (is_nm_pf==0) begin
         $value$plusargs({$psprintf("%s_VF%0d_PP%0d_Q%0d_NUM_HCW", pp_cq_prefix, vf_num_val, pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);
      end else begin
         $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);
      end

      ovm_report_info(get_full_name(), $psprintf("start_pp_cq -- issue traffic to is_nm_pf=%0d (is_nm_pf_val=%0d) is_ldb=%0d pf_pp_cq_num=%0d qid=%0d qtype=%0s num_hcw_gen=%0d", is_nm_pf, is_ldb, is_nm_pf_val, pf_pp_cq_num, qid, qtype.name(), num_hcw_gen), OVM_LOW);

      pp_cq_seq.queue_list[i].num_hcw              = num_hcw_gen;
      pp_cq_seq.queue_list[i].qid                  = qid;
      pp_cq_seq.queue_list[i].qtype                = qtype;
      pp_cq_seq.queue_list[i].qpri_weight[0]       = 1;
      pp_cq_seq.queue_list[i].hcw_delay_min        = 0;
      pp_cq_seq.queue_list[i].hcw_delay_max        = 0;
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
      // -- Set is_nm_pf
      pp_cq_seq.queue_list[i].is_nm_pf = is_nm_pf || is_nm_pf_val;

      // -- Set lock_id
      if (is_nm_pf==0) begin
         $value$plusargs({$psprintf("%s_VF%0d_PP%0d_Q%0d_LOCK_ID", pp_cq_prefix, vf_num_val, pp_cq_seq.pp_cq_num,i),"=%0x"}, pp_cq_seq.queue_list[i].lock_id);
         ovm_report_info(get_full_name(), $psprintf("%s_VF%0d_PP%0d_Q%0d_LOCK_ID=0x%0x", pp_cq_prefix, vf_num_val, pp_cq_seq.pp_cq_num, i, pp_cq_seq.queue_list[i].lock_id), OVM_LOW);
      end else begin
         $value$plusargs({$psprintf("%s_PP%0d_Q%0d_LOCK_ID",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%0x"}, pp_cq_seq.queue_list[i].lock_id);
         ovm_report_info(get_full_name(), $psprintf("%s_PP%0d_Q%0d_LOCK_ID=0x%0x", pp_cq_prefix, pp_cq_seq.pp_cq_num, i, pp_cq_seq.queue_list[i].lock_id), OVM_LOW);
      end
      // -- Set inc_lock_id
      if (is_nm_pf) begin
         $value$plusargs({$psprintf("%s_VF%0d_PP%0d_Q%0d_INC_LOCK_ID", pp_cq_prefix, vf_num_val, pp_cq_seq.pp_cq_num,i),"=%0x"}, pp_cq_seq.queue_list[i].inc_lock_id);
         ovm_report_info(get_full_name(), $psprintf("%s_VF%0d_PP%0d_Q%0d_INC_LOCK_ID=0x%0x", pp_cq_prefix, vf_num_val, pp_cq_seq.pp_cq_num, i, pp_cq_seq.queue_list[i].inc_lock_id), OVM_LOW);
      end else begin
         $value$plusargs({$psprintf("%s_PP%0d_Q%0d_INC_LOCK_ID",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%0x"}, pp_cq_seq.queue_list[i].inc_lock_id);
         ovm_report_info(get_full_name(), $psprintf("%s_PP%0d_Q%0d_INC_LOCK_ID=0x%0x", pp_cq_prefix, pp_cq_seq.pp_cq_num, i, pp_cq_seq.queue_list[i].inc_lock_id), OVM_LOW);
      end
    end
    pp_cq_seq.mon_watchdog_timeout = 12000;
    pp_cq_seq.sb_watchdog_timeout  = 20000;
    finish_item(pp_cq_seq);
  endtask

endclass : hcw_ldb_test_hcw_seq

`endif //HCW_LDB_TEST_HCW_SEQ__SV
