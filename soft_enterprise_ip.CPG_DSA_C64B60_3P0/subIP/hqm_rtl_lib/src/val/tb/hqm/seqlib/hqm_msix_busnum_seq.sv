`ifndef HQM_MSIX_BUSNUM_SEQ__SV
`define HQM_MSIX_BUSNUM_SEQ__SV

class hqm_msix_busnum_seq extends hqm_base_seq;

  typedef bit [3:0] vf_num_t;
  typedef bit [5:0] pp_num_t;

  hqm_cfg                                      i_hqm_cfg;
  hqm_pp_cq_status                             i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq cfg_write_busnum_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq cfg_read_busnum_seq;

  int unsigned ldb_vf_hcw_gen[vf_num_t][pp_num_t];
  int unsigned ldb_pf_hcw_gen[pp_num_t];
  int unsigned dir_vf_hcw_gen[vf_num_t][pp_num_t];
  int unsigned dir_pf_hcw_gen[pp_num_t];

  `ovm_sequence_utils(hqm_msix_busnum_seq, sla_sequencer)

  function new(string name = "hqm_msix_busnum_seq");
    super.new(name);
  endfunction

  virtual task body();

      ovm_object     o_tmp;
      sla_ral_addr_t addr;
      sla_ral_reg    reg_h;
      sla_ral_data_t rd_data;

      //-----------------------------
      //-- get i_hqm_cfg
      //-----------------------------
      if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
        ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
      end

      if (!$cast(i_hqm_cfg, o_tmp)) begin
        ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
      end  

      //-----------------------------
      //-- get i_hqm_pp_cq_status
      //-----------------------------
      if (!p_sequencer.get_config_object("i_hqm_pp_cq_status", o_tmp)) begin
        ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
      end

      if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
        ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
      end

      // -- Start traffic with the default bus number for PF
      ovm_report_info(get_full_name(), $psprintf("Starting traffic with default bus number"), OVM_LOW);
      start_traffic(1);

      // -- Start traffic again; CQ writes should be with updated bus number for PF and should retain the default bus number for VF
      change_bus_num(1'b1, 0, 'h2f);
      ovm_report_info(get_full_name(), $psprintf("Starting traffic after changing PF bus number"), OVM_LOW);
      start_traffic(2);

  endtask

  task change_bus_num (bit is_pf, bit [3:0] vf_num, bit [7:0] new_bus_num);

      sla_ral_data_t rd_data;
      sla_ral_reg    reg_h;
      sla_ral_addr_t addr;
      string         reg_file;

      ovm_report_info(get_full_name(), $psprintf("change_bus_num(is_pf=%0b, vf_num=%0d, new_bus_num=0x%0x) -- Start", is_pf, vf_num, new_bus_num), OVM_DEBUG);
      reg_file = $psprintf("hqm_pf_cfg_i");
      rd_data     = get_actual_ral("DEVICE_COMMAND", reg_file);
      reg_h       = get_reg_handle("DEVICE_COMMAND", reg_file);
      addr        = ral_env.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), reg_h);
      addr[31:24] = new_bus_num;
      ovm_report_info(get_full_name(), $psprintf("Changing the bus number :: addr=0x%0x, data=0x%0x", addr, rd_data), OVM_LOW);
      `ovm_do_on_with(cfg_write_busnum_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr; iosf_data == rd_data; req_id == 16'h0;})
      wait_for_clk(100);
      ovm_report_info(get_full_name(), $psprintf("change_bus_num(is_pf=%0b, vf_num=%0d, new_bus_num=0x%0x) -- End", is_pf, vf_num, new_bus_num), OVM_DEBUG);

  endtask : change_bus_num

  task start_traffic(int iteration);       
      
      string     cfg_cmds[$];
      bit [15:0] data;

      cfg_cmds.push_back("wr list_sel_pipe.cfg_cq_dir_disable[0].disabled 0x1");
      cfg_cmds.push_back("rd list_sel_pipe.cfg_cq_dir_disable[0].disabled 0x1");
      for (int i =0; i < 'h100; i++) begin
          cfg_cmds.push_back("HCW DIR:0  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=1 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0  dsi=0x302");
      end
      cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=1 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302 ingress_drop=1");
      cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=1 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302 ingress_drop=1");
      cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=1 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302 ingress_drop=1");
      cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=1 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302 ingress_drop=1");
      cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=1 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302 ingress_drop=1");
      cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=1 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302 ingress_drop=1");
      cfg_cmds.push_back("IDLE 1000");
      execute_cfg_cmds(cfg_cmds);

      i_hqm_pp_cq_status.wait_for_msix_int(0, data);

      cfg_cmds = '{};
      cfg_cmds.push_back("rd hqm_system_csr.alarm_pf_synd0.valid 0x1");
      cfg_cmds.push_back("wr hqm_system_csr.alarm_pf_synd0.valid 0x1");
      cfg_cmds.push_back("rd hqm_system_csr.msix_ack.msix_0_ack 0x1");
      cfg_cmds.push_back("wr hqm_system_csr.msix_ack.msix_0_ack 0x1");
      cfg_cmds.push_back("rd hqm_system_csr.msix_31_0_synd.msix_0_sent 0x1");
      cfg_cmds.push_back("wr hqm_system_csr.msix_31_0_synd.msix_0_sent 0x1");
      cfg_cmds.push_back("wr list_sel_pipe.cfg_cq_dir_disable[0].disabled 0x0");
      cfg_cmds.push_back("rd list_sel_pipe.cfg_cq_dir_disable[0].disabled 0x0");
      cfg_cmds.push_back($psprintf("poll_sch dir:0 %0d", (iteration * 'h100) ) );
      cfg_cmds.push_back("IDLE 200");
      cfg_cmds.push_back("HCW DIR:0  qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0xFF msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302");
      execute_cfg_cmds(cfg_cmds);


  endtask : start_traffic

  task execute_cfg_cmds(string cfg_cmds[$]);

      ovm_report_info(get_full_name(), $psprintf("execute_cfg_cmds -- Start"), OVM_DEBUG);
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
      ovm_report_info(get_full_name(), $psprintf("execute_cfg_cmds -- End"),   OVM_DEBUG);

  endtask : execute_cfg_cmds

endclass : hqm_msix_busnum_seq

`endif //HQM_MSIX_BUSNUM_SEQ__SV
