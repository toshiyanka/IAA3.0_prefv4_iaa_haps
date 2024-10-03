`ifndef HQM_DIR_TRAFFIC_WR_OPTIMIZATION_SEQ__SV
`define HQM_DIR_TRAFFIC_WR_OPTIMIZATION_SEQ__SV

class hqm_dir_traffic_wr_optimization_seq extends hqm_base_seq;

  hqm_cfg                                      i_hqm_cfg;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq cfg_write_busnum_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq cfg_read_busnum_seq;

  `ovm_sequence_utils(hqm_dir_traffic_wr_optimization_seq, sla_sequencer)

  function new(string name = "hqm_dir_traffic_wr_optimization_seq");
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

      start_traffic(1);
  endtask

  task start_traffic(int iteration);       
      
      string           cfg_cmds[$];
      bit [31:0]       read_val;
      bit [31:0]       hcw_cnt;
      int              i;
      real             coalescing_percent;
      if ($value$plusargs("NUM_HCW=%d", i))begin hcw_cnt= i; end
      else begin  assert(std::randomize(hcw_cnt) with {hcw_cnt < 64; hcw_cnt > 9 ;}); end

        ovm_report_info(get_full_name(), $psprintf("sending traffic with hcw count = %0d", hcw_cnt), OVM_LOW);
      // 4 HCW from PP[0:3] to qid[0:3] UNO
        cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=0 dsi=0x302");
        cfg_cmds.push_back("idle 40");
        cfg_cmds.push_back("HCW DIR:1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=1 dsi=0x302"); 
        cfg_cmds.push_back("idle 40");
        cfg_cmds.push_back("HCW DIR:2 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=2 dsi=0x302"); 
        cfg_cmds.push_back("idle 40");
        cfg_cmds.push_back("HCW DIR:3 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x302"); 

      // send16 HCW from PP0 to QID[4] CQ[4]
      for (int i = 0 ; i < hcw_cnt; i++) begin
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 ");
        cfg_cmds.push_back("idle 40");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 ");
        cfg_cmds.push_back("idle 40");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302");
        cfg_cmds.push_back("idle 40");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 batch=1");
        cfg_cmds.push_back("HCW LDB:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302 ");
        cfg_cmds.push_back("idle 40");
      end

      cfg_cmds.push_back("poll_sch ldb:0 0x1 1000 200");
      cfg_cmds.push_back("poll_sch ldb:1 0x1 1000 200");
      cfg_cmds.push_back("poll_sch ldb:2 0x1 1000 200");
      cfg_cmds.push_back("poll_sch ldb:3 0x1 1000 200");
      cfg_cmds.push_back($psprintf("poll_sch dir:4 %0d 1000 200", ('d16 * hcw_cnt)));

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
 
      read_reg("hqm_system_cnt_20", read_val , "hqm_system_csr");
      coalescing_percent= ((read_val*100)/(16*hcw_cnt));
      //if (read_val <= (16*hcw_cnt*0.27)) begin
      if (coalescing_percent < 27) begin
         `ovm_error(get_type_name(), $psprintf("<27 percent of coalescing coalescing_count=%0d hcw_send= %0d coalescing_percent=%0f",read_val,(16*hcw_cnt),coalescing_percent));
      end else begin
          ovm_report_info(get_full_name(), $psprintf("Expected coalescing ~27 percent coalescing_count=%0d hcw_send= %0d coalescing_percent=%0f", read_val, (16*hcw_cnt),coalescing_percent), OVM_LOW);
      end

      // token return and completion
      //cq[4] qid[4] 16xhcw_cnt token return
      for(int i=0;i<hcw_cnt;i++) begin
        cfg_cmds.push_back("HCW DIR:4 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x00F msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302");
        cfg_cmds.push_back("idle 300");
      end
      //send token and completion ldb qid[0:4] ldb cq[0:4]
      cfg_cmds.push_back("HCW LDB:0 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=0 dsi=0x302");
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back("HCW LDB:1 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=1 dsi=0x302");
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back("HCW LDB:2 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=2 dsi=0x302");
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back("HCW LDB:3 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x302");
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_vas_credit_count[:VAS0:] 0x400 0xffffffff 1000 200");

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
      wait_for_clk(100);

  endtask : start_traffic

endclass : hqm_dir_traffic_wr_optimization_seq

`endif //HQM_DIR_TRAFFIC_WR_OPTIMIZATION_SEQ__SV

