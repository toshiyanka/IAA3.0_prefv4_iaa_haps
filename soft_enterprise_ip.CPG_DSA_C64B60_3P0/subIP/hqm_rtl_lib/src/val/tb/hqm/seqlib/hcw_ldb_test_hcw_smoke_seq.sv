`ifndef HCW_LDB_TEST_HCW_SMK_SEQ__SV
`define HCW_LDB_TEST_HCW_SMK_SEQ__SV

class hcw_ldb_test_hcw_smoke_seq extends hqm_base_seq;

  typedef bit [3:0] vf_num_t;
  typedef bit [5:0] pp_num_t;

  hqm_cfg                                      i_hqm_cfg;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq cfg_write_busnum_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq cfg_read_busnum_seq;

  int unsigned ldb_vf_hcw_gen[vf_num_t][pp_num_t];
  int unsigned ldb_pf_hcw_gen[pp_num_t];
  int unsigned dir_vf_hcw_gen[vf_num_t][pp_num_t];
  int unsigned dir_pf_hcw_gen[pp_num_t];

  `ovm_sequence_utils(hcw_ldb_test_hcw_smoke_seq, sla_sequencer)

  function new(string name = "hcw_ldb_test_hcw_smoke_seq");
    super.new(name);
  endfunction

//-----------------------------------
//--
//-----------------------------------
  virtual task body();

      ovm_object     o_tmp;
      sla_ral_addr_t addr;
      sla_ral_reg    reg_h;
      sla_ral_data_t rd_data;
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

      // -- Start traffic 
      //ovm_report_info(get_full_name(), $psprintf("Starting traffic task start_traffic"), OVM_LOW);
      //start_traffic(1);
      //ovm_report_info(get_full_name(), $psprintf("Done traffic task start_traffic"), OVM_LOW);

      // -- Start traffic using file mode
      ovm_report_info(get_full_name(), $psprintf("Starting traffic task start_traffic_file_mode"), OVM_LOW);
      start_traffic_file_mode();
      ovm_report_info(get_full_name(), $psprintf("Done traffic task start_traffic_file_mode"), OVM_LOW);

    
  endtask


//-----------------------------------
//--
//-----------------------------------
  virtual task start_traffic(int iteration = 0);       
      
      string           cfg_cmds[$];
      bit [63:0]       cnt;

      cfg_cmds.push_back("HCW LDB:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:20         qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:20         qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:20         qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:20         qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");

      while (cfg_cmds.size()) begin

          bit         do_cfg_seq;
          hqm_cfg_seq cfg_seq;
          string      cmd;

          cmd = cfg_cmds.pop_front();
          ovm_report_info(get_full_name(), $psprintf("Starting traffic cmd=%0s", cmd), OVM_LOW);
          i_hqm_cfg.set_cfg(cmd, do_cfg_seq);
          if (do_cfg_seq) begin
            `ovm_create(cfg_seq)
            cfg_seq.pre_body();
            start_item(cfg_seq);
            finish_item(cfg_seq);
            cfg_seq.post_body();
          end
      end

      // -- Check all the QEs have scheduled
      ovm_report_info(get_full_name(), $psprintf("poll hqm_system_cnt_8 ... "), OVM_LOW);
      poll_reg("hqm_system_cnt_8", ('d8 * iteration), "hqm_system_csr");
      ovm_report_info(get_full_name(), $psprintf("poll hqm_system_cnt_9 ... "), OVM_LOW);
      poll_reg("hqm_system_cnt_9", ('d0 * iteration), "hqm_system_csr");

/*--
      // -- PF CQ 20
      cnt = 0;
      read_reg($psprintf("cfg_cq_ldb_inflight_count[%0d]", 'd20), cnt,  "list_sel_pipe");
      for (int i = 0 ; i < cnt; i++) begin
          cfg_cmds.push_back("HCW LDB:20 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");
      end

      // -- PF CQ 21
      cnt = 0;
      read_reg($psprintf("cfg_cq_ldb_inflight_count[%0d]", 'd21), cnt,  "list_sel_pipe");
      for (int i = 0 ; i < cnt; i++) begin
          cfg_cmds.push_back("HCW LDB:21 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");
      end

      // -- VF 0 PP2 (CQ0)
      cnt = 0;
      read_reg($psprintf("cfg_cq_ldb_inflight_count[%0d]", 'd0), cnt,  "list_sel_pipe");
      for (int i = 0 ; i < cnt; i++) begin
          cfg_cmds.push_back("HCW LDB:2 vf_num=0 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
      end

      // -- VF 0 PP3 (CQ1)
      cnt = 0;
      read_reg($psprintf("cfg_cq_ldb_inflight_count[%0d]", 'd1), cnt,  "list_sel_pipe");
      for (int i = 0 ; i < cnt; i++) begin
          cfg_cmds.push_back("HCW LDB:3 vf_num=0 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
      end

      while (cfg_cmds.size()) begin
          bit         do_cfg_seq;
          hqm_cfg_seq cfg_seq;
          string      cmd;

          cmd = cfg_cmds.pop_front();
          i_hqm_cfg.set_cfg(cmd, do_cfg_seq);
          if (do_cfg_seq) begin
            `ovm_create(cfg_seq)
            cfg_seq.pre_body();
            start_item(cfg_seq);
            finish_item(cfg_seq);
            cfg_seq.post_body();
          end
      end
--*/
  endtask : start_traffic


//-----------------------------------
//--
//-----------------------------------
  virtual task start_traffic_file_mode();      
      hqm_tb_cfg_file_mode_seq i_seq;

      ovm_report_info(get_full_name(), $psprintf("start_traffic_file_mode -- Start"), OVM_LOW);
      i_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_seq");
      i_seq.set_cfg("HCW_TRAFFIC", 1'b1);
      i_seq.start(get_sequencer());
      ovm_report_info(get_full_name(), $psprintf("start_traffic_file_mode -- End"), OVM_LOW);
      
  endtask : start_traffic_file_mode


endclass : hcw_ldb_test_hcw_smoke_seq

`endif //HCW_LDB_TEST_HCW_BUSNUM_SEQ__SV
