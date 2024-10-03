`ifndef HQM_FABRIC_INITIATED_CLKGATING_SEQ__SV
`define HQM_FABRIC_INITIATED_CLKGATING_SEQ__SV


class hqm_fabric_initiated_clkgating_seq extends hqm_base_seq;

  hqm_cfg                                      i_hqm_cfg;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq cfg_write_busnum_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq cfg_read_busnum_seq;

  `ovm_sequence_utils(hqm_fabric_initiated_clkgating_seq, sla_sequencer)

  function new(string name = "hqm_fabric_initiated_clkgating_seq");
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

      ovm_report_info(get_full_name(), $psprintf("Starting test fabric_initiated clock gating"), OVM_LOW);
      start_traffic(1);
  endtask

//--seq1 send hcw and token calculate reg start and finish time
  task start_traffic(int iteration);       
      realtime start_time, finish_time,ref_time, ref_time_1, ref_time_2;
      ovm_report_info(get_full_name(), $psprintf("Starting hcw traffic with no clkreq/clkack deassertion"), OVM_LOW);
      ref_time_check(ref_time);
      start_time=ref_time;
      send_hcw(1);
      token_return();
      ref_time_check(ref_time);
      finish_time=ref_time;
      ref_time_1=finish_time-start_time;
      ovm_report_info(get_full_name(), $psprintf("Completed hcw traffic with no clkreq/clkack deassertion total_time=%0d",ref_time_1), OVM_LOW);
      //-- seq2:   
      wait_for_clk(50);
      ovm_report_info(get_full_name(), $psprintf("Starting hcw traffic with clkreq/clkack deassertion"), OVM_LOW);
      ref_time_check(ref_time);
      start_time=ref_time;
      send_hcw(2);
      //poll for prim_clkreg low and prim_clk low
      check_idle();  
      token_return();
      ref_time_check(ref_time);
      finish_time=ref_time;
      ref_time_2=finish_time-start_time;
      ovm_report_info(get_full_name(), $psprintf("Completed hcw traffic with clkreq/clkack deassertion total_time=%0d",ref_time_2), OVM_LOW);
      if ( (ref_time_2-ref_time_1) < 150 ) begin
         `ovm_error(get_type_name(), $psprintf(" Unexpected less completion time with delay=%0d ", (ref_time_2-ref_time_1)));
      end else begin
         ovm_report_info(get_full_name(), $psprintf("Expected completion time with delay =%0d",(ref_time_2-ref_time_1)), OVM_LOW); 
      end
  endtask : start_traffic

//-- send traffic on dir_cq_pf[0,2] dir_cq_vf[9,11]; ldb_cq_pf[1,3] ldb_cq_vf[8,10]
  task send_hcw(int iteration);
      string           cfg_cmds[$];
      ovm_report_info(get_full_name(), $psprintf("Starting traffic on DIR PORT CQ->0,2,9,11"), OVM_LOW);
      ovm_report_info(get_full_name(), $psprintf("Starting traffic on LDB PORT CQ->1,3,8,10"), OVM_LOW);
      //send 1HCW for each QE to start timer
      cfg_cmds.push_back("HCW DIR:0 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("idle 200");
      cfg_cmds.push_back("HCW DIR:2 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("idle 200");
      cfg_cmds.push_back("HCW LDB:1 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=1 dsi=0x302"); 
      cfg_cmds.push_back("idle 200");
      cfg_cmds.push_back("HCW LDB:3 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x302"); 
      cfg_cmds.push_back("idle 200");

      ////cfg_cmds.push_back("HCW DIR:0 vf_num=1  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:9 is_nm_pf=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("idle 200");

      ////cfg_cmds.push_back("HCW DIR:1 vf_num=3  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:11 is_nm_pf=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
      cfg_cmds.push_back("idle 200");

      ////cfg_cmds.push_back("HCW LDB:4 vf_num=0  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:8 is_nm_pf=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
      cfg_cmds.push_back("idle 200");
      ////cfg_cmds.push_back("HCW LDB:5 vf_num=2  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:10 is_nm_pf=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
      cfg_cmds.push_back("idle 200");

      // -- wait for scheduling
      cfg_cmds.push_back($psprintf("poll_sch dir:0  %0d 1000 200", ('h1 * iteration)));
      cfg_cmds.push_back($psprintf("poll_sch dir:2  %0d 1000 200", ('h1 * iteration)));
      cfg_cmds.push_back($psprintf("poll_sch ldb:1  %0d 1000 200", ('h1 * iteration)));
      cfg_cmds.push_back($psprintf("poll_sch ldb:3  %0d 1000 200", ('h1 * iteration)));
      cfg_cmds.push_back($psprintf("poll_sch dir:9  %0d 1000 200", ('h1 * iteration)));
      cfg_cmds.push_back($psprintf("poll_sch dir:11 %0d 1000 200", ('h1 * iteration)));
      cfg_cmds.push_back($psprintf("poll_sch ldb:8  %0d 1000 200", ('h1 * iteration)));
      cfg_cmds.push_back($psprintf("poll_sch ldb:10 %0d 1000 200", ('h1 * iteration)));

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
      ovm_report_info(get_full_name(), $psprintf("Completed traffic on DIR and LDB Ports "), OVM_LOW);
  endtask: send_hcw

  task token_return();
     string           cfg_cmds[$];

     //--PF PP
     cfg_cmds.push_back("HCW DIR:0 is_nm_pf=1 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x00 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
     cfg_cmds.push_back("idle 300");
     cfg_cmds.push_back("HCW DIR:2 is_nm_pf=1 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x00 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302");
     cfg_cmds.push_back("idle 300");
     // -- token return and completion
     cfg_cmds.push_back("HCW LDB:1 is_nm_pf=1 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x00  msgtype=0 qpri=0 qtype=uno qid=1 dsi=0x302");
     cfg_cmds.push_back("idle 300");
     cfg_cmds.push_back("HCW LDB:3 is_nm_pf=1 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x00  msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x302");
     cfg_cmds.push_back("idle 300");

     //--SCIOV PP
      //-- return token
     ////cfg_cmds.push_back("HCW DIR:0 vf_num=1  qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
     cfg_cmds.push_back("HCW DIR:9 is_nm_pf=0 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
     cfg_cmds.push_back("idle 300");

     ////cfg_cmds.push_back("HCW DIR:1 vf_num=3  qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
     cfg_cmds.push_back("HCW DIR:11 is_nm_pf=0 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
     cfg_cmds.push_back("idle 300");

     // -- token return and completion
     ////cfg_cmds.push_back("HCW LDB:4 vf_num=0  qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
     cfg_cmds.push_back("HCW LDB:8 is_nm_pf=0 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
     cfg_cmds.push_back("idle 100");

     ////cfg_cmds.push_back("HCW LDB:5 vf_num=2  qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
     cfg_cmds.push_back("HCW LDB:10 is_nm_pf=0 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
     cfg_cmds.push_back("idle 100");
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
      ovm_report_info(get_full_name(), $psprintf("completed token and completion"), OVM_LOW);
  endtask: token_return

 task ref_time_check( output realtime ref_time);
    ref_time =$realtime;
 endtask: ref_time_check

task check_idle();
    hqm_reset_unit_sequence      i_wait_prim_clkreq_deassert_seq;
    hqm_reset_unit_sequence      i_wait_prim_clkack_deassert_seq;
   `ovm_do_on_with(i_wait_prim_clkreq_deassert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_CLKREQ_DEASSERT;});
   `ovm_do_on_with(i_wait_prim_clkack_deassert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_CLKACK_DEASSERT;});
    //wait_for 150 clock
    wait_for_clk(150);
endtask: check_idle



endclass : hqm_fabric_initiated_clkgating_seq

`endif //HQM_FABRIC_INITIATED_CLKGATING_SEQ__SV


