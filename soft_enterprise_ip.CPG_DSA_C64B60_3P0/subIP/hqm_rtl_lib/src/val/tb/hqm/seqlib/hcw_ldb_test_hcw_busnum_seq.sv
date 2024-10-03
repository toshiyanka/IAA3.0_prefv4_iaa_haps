`ifndef HCW_LDB_TEST_HCW_BUSNUM_SEQ__SV
`define HCW_LDB_TEST_HCW_BUSNUM_SEQ__SV

class hcw_ldb_test_hcw_busnum_seq extends hqm_base_seq;

  typedef bit [3:0] vf_num_t;
  typedef bit [5:0] pp_num_t;

  hqm_cfg                                      i_hqm_cfg;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq cfg_write_busnum_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq cfg_read_busnum_seq;

  int unsigned ldb_vf_hcw_gen[vf_num_t][pp_num_t];
  int unsigned ldb_pf_hcw_gen[pp_num_t];
  int unsigned dir_vf_hcw_gen[vf_num_t][pp_num_t];
  int unsigned dir_pf_hcw_gen[pp_num_t];

  `ovm_sequence_utils(hcw_ldb_test_hcw_busnum_seq, sla_sequencer)

  function new(string name = "hcw_ldb_test_hcw_busnum_seq");
    super.new(name);
  endfunction

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

      // -- Start traffic with the default bus number for VF and PF
      ovm_report_info(get_full_name(), $psprintf("Starting traffic with default bus number"), OVM_LOW);
      start_traffic(1);

      // -- Start traffic again; CQ writes should be with updated bus number for PF and should retain the default bus number for VF
      change_bus_num(1'b1, 0, 'h2f);
      ovm_report_info(get_full_name(), $psprintf("Starting traffic after changing PF bus number"), OVM_LOW);
      start_traffic(2);

      // -- Change the bus number for VF; CQ writes from both VF and PF should be with updated bus number
      //change_bus_num(1'b0, 0, 'h1f);
      //ovm_report_info(get_full_name(), $psprintf("Starting traffic after changing VF's bus number"), OVM_LOW);
      //start_traffic(3);

      // -- Change the bus number for PF back to 0; CQ writes from PF should have 0 as their bus number and CQ writes from VF should have the last updated bus number
      //change_bus_num(1'b1, 0, 'h0);
      //ovm_report_info(get_full_name(), $psprintf("Starting traffic after changing PF's bus number to 0"), OVM_LOW);
      //start_traffic(4);

      // -- Check the credit count for all the PPs provisioned
      compare_reg("cfg_vas_credit_count[0]", 'd128,  rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[1]", 'd128,  rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[2]", 'd128,  rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[3]", 'd128,  rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[4]", 'd0,    rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[5]", 'd128,  rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[6]", 'd128,  rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[7]", 'd128,  rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[8]", 'd128,  rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[9]", 'd128,  rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[10]", 'd128, rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[11]", 'd128, rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[12]", 'd128, rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[13]", 'd128, rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[14]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[15]", 'd128, rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[16]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[17]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[18]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[19]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[20]", 'd128, rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[21]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[22]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[23]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[24]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[25]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[26]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[27]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[28]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[29]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[30]", 'd0,   rd_val, "credit_hist_pipe");
      compare_reg("cfg_vas_credit_count[31]", 'd128, rd_val, "credit_hist_pipe");

  endtask

  virtual task change_bus_num (bit is_pf, bit [3:0] vf_num, bit [7:0] new_bus_num);

      sla_ral_data_t rd_data;
      sla_ral_reg    reg_h;
      sla_ral_addr_t addr;
      string         reg_file;

      ovm_report_info(get_full_name(), $psprintf("change_bus_num(is_pf=%0b, vf_num=%0d, new_bus_num=0x%0x) -- Start", is_pf, vf_num, new_bus_num), OVM_DEBUG);
      reg_file    = $psprintf("hqm_pf_cfg_i");
      rd_data     = get_actual_ral("DEVICE_COMMAND", reg_file);
      reg_h       = get_reg_handle("DEVICE_COMMAND", reg_file);
      addr        = ral_env.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), reg_h);
      addr[31:24] = new_bus_num;
      ovm_report_info(get_full_name(), $psprintf("Changing the bus number :: addr=0x%0x, data=0x%0x", addr, rd_data), OVM_LOW);
      `ovm_do_on_with(cfg_write_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr; iosf_data == rd_data; req_id == 16'h0;})
      wait_for_clk(100);
      ovm_report_info(get_full_name(), $psprintf("change_bus_num(is_pf=%0b, vf_num=%0d, new_bus_num=0x%0x) -- End", is_pf, vf_num, new_bus_num), OVM_DEBUG);

  endtask : change_bus_num

  virtual task start_traffic(int iteration = 0);       
      
      string           cfg_cmds[$];
      bit [63:0]       cnt;

      cfg_cmds.push_back("HCW LDB:2   is_nm_pf=0  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:2   is_nm_pf=0  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:2   is_nm_pf=0  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:2   is_nm_pf=0  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:20  is_nm_pf=1  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:20  is_nm_pf=1  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:20  is_nm_pf=1  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");
      cfg_cmds.push_back("HCW LDB:20  is_nm_pf=1  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x110 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");

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

      // -- Check all the QEs have scheduled
      poll_reg("hqm_system_cnt_8", ('d8 * iteration), "hqm_system_csr");
      poll_reg("hqm_system_cnt_9", ('d0 * iteration), "hqm_system_csr");

      // -- PF CQ 20
      cnt = 0;
      read_reg($psprintf("cfg_cq_ldb_inflight_count[%0d]", 'd20), cnt,  "list_sel_pipe");
      for (int i = 0 ; i < cnt; i++) begin
          cfg_cmds.push_back("HCW LDB:20 is_nm_pf=1  qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");
      end

      // -- PF CQ 21
      cnt = 0;
      read_reg($psprintf("cfg_cq_ldb_inflight_count[%0d]", 'd21), cnt,  "list_sel_pipe");
      for (int i = 0 ; i < cnt; i++) begin
          cfg_cmds.push_back("HCW LDB:21 is_nm_pf=1  qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x30");
      end

      // -- VF 0 PP2 (CQ0)
      cnt = 0;
      read_reg($psprintf("cfg_cq_ldb_inflight_count[%0d]", 'd0), cnt,  "list_sel_pipe");
      for (int i = 0 ; i < cnt; i++) begin
          cfg_cmds.push_back("HCW LDB:0 is_nm_pf=0 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
      end

      // -- VF 0 PP3 (CQ1)
      cnt = 0;
      read_reg($psprintf("cfg_cq_ldb_inflight_count[%0d]", 'd1), cnt,  "list_sel_pipe");
      for (int i = 0 ; i < cnt; i++) begin
          cfg_cmds.push_back("HCW LDB:1 is_nm_pf=0 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x30");
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

  endtask : start_traffic

endclass : hcw_ldb_test_hcw_busnum_seq

`endif //HCW_LDB_TEST_HCW_BUSNUM_SEQ__SV
