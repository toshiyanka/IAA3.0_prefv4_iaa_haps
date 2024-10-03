`ifndef HQM_DIR_LDB_TRAFFIC_WR_OPTIMIZATION_SEQ__SV
`define HQM_DIR_LDB_TRAFFIC_WR_OPTIMIZATION_SEQ__SV

class hqm_dir_ldb_traffic_wr_optimization_seq extends hqm_base_seq;

  semaphore cfg_cmds_sem;

  `ovm_sequence_utils(hqm_dir_ldb_traffic_wr_optimization_seq, sla_sequencer)

  function new(string name = "hqm_dir_ldb_traffic_wr_optimization_seq");
    super.new(name);
    cfg_cmds_sem = new(1);
  endfunction

  virtual task body();

      ovm_object     o_tmp;
      sla_ral_addr_t addr;
      sla_ral_reg    reg_h;
      sla_ral_data_t rd_data;

      //-- get i_hqm_cfg
      get_hqm_cfg();

      // -- get i_hqm_pp_cq_status
      get_hqm_pp_cq_status();

      for (int i = 0; i < 21; i+=4) begin
          fork
              automatic int j = i;
              start_traffic(j);
          join_none
      end
      wait fork;

  endtask

  task start_traffic(int unsigned iteration);       
      
      string           cfg_cmds[$];
      bit [31:0]       hcw_cnt;
      int              i;
      real             coalescing_percent;
      int unsigned     coalesce_cnt;
      int unsigned     sch_16B_cnt;
      int unsigned     it_inc;

      it_inc = iteration + (iteration / 4);
      if ($value$plusargs("NUM_HCW=%d", i))begin hcw_cnt= i; end
      else begin  assert(std::randomize(hcw_cnt) with {hcw_cnt < 64; hcw_cnt > 9 ;}); end

      ovm_report_info(get_full_name(), $psprintf("sending traffic with hcw count = %0d", hcw_cnt), OVM_LOW);
      // --  4 HCW from PP[0:3] to qid[0:3] UNO
      for (int i = 0 ; i < 4; i++) begin
          cfg_cmds.push_back($psprintf("HCW DIR:%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=%0d dsi=0x302", (it_inc + i), (it_inc + i)));
          cfg_cmds.push_back("idle 40");
      end

      // -- send16 HCW from PP0 to QID[4] CQ[4]
      for (int i = 0 ; i < hcw_cnt; i++) begin
          for (int j = 0; j < 4; j++) begin
              cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=%0d dsi=0x302 batch=1", (it_inc), (it_inc + 4)));
              cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=%0d dsi=0x302 batch=1", it_inc, (it_inc + 4)));
              cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=%0d dsi=0x302 batch=1", it_inc, (it_inc + 4)));
              cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=%0d dsi=0x302 ", it_inc, (it_inc + 4)));
              cfg_cmds.push_back("idle 40");
          end
      end

      // check all hcw scheduled
      // -- Check all the QEs have scheduled
      cfg_cmds.push_back($psprintf("poll_sch ldb:%0d %0d 1000 200", (it_inc + 0), 'h1));
      cfg_cmds.push_back($psprintf("poll_sch ldb:%0d %0d 1000 200", (it_inc + 1), 'h1));
      cfg_cmds.push_back($psprintf("poll_sch ldb:%0d %0d 1000 200", (it_inc + 2), 'h1));
      cfg_cmds.push_back($psprintf("poll_sch ldb:%0d %0d 1000 200", (it_inc + 3), 'h1));
      cfg_cmds.push_back($psprintf("poll_sch dir:%0d %0d 1000 200", (it_inc + 4), ('d16 * hcw_cnt)));

      execute_cfg_cmds(cfg_cmds);
      cfg_cmds = '{};

      sch_16B_cnt = i_hqm_pp_cq_status.dir_pp_cq_status[it_inc + 4].st_sch_16B_cnt;
      coalesce_cnt = ('d16 * hcw_cnt) - sch_16B_cnt;
      coalescing_percent= ((coalesce_cnt*100)/(16*hcw_cnt));
      if (coalescing_percent < 27) begin
         `ovm_error(get_type_name(), $psprintf("<27 percent of coalescing coalescing_count=%0d hcw_send= %0d coalescing_percent=%0f", coalesce_cnt, (16*hcw_cnt),coalescing_percent));
      end else begin
          ovm_report_info(get_full_name(), $psprintf("Expected coalescing ~27 percent coalescing_count=%0d hcw_send= %0d coalescing_percent=%0f", coalesce_cnt, (16*hcw_cnt),coalescing_percent), OVM_LOW);
      end

      // token return and completion
      //cq[4] qid[4] 16xhcw_cnt token return
      for(int i=0;i<hcw_cnt;i++) begin
        cfg_cmds.push_back($psprintf("HCW DIR:%0d qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x00F msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302", (it_inc + 4)));
        cfg_cmds.push_back("idle 300");
      end
      //send token and completion ldb qid[0:4] ldb cq[0:4]
      cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=0 dsi=0x302", (it_inc + 0)));
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=1 dsi=0x302", (it_inc + 1)));
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=2 dsi=0x302", (it_inc + 2)));
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x302", (it_inc + 3)));
      cfg_cmds.push_back("idle 300");

      execute_cfg_cmds(cfg_cmds);
      cfg_cmds = '{};
      wait_for_clk(100);

  endtask : start_traffic

  task execute_cfg_cmds(string cfg_cmds[$]); 

      ovm_report_info(get_full_name(), $psprintf("execute_cfg_cmds -- Start"), OVM_DEBUG);
      cfg_cmds_sem.get(1);
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
      cfg_cmds_sem.put(1);
      ovm_report_info(get_full_name(), $psprintf("execute_cfg_cmds -- End"), OVM_DEBUG);
 
  endtask : execute_cfg_cmds

endclass : hqm_dir_ldb_traffic_wr_optimization_seq

`endif //HQM_DIR_LDB_TRAFFIC_WR_OPTIMIZATION_SEQ__SV

