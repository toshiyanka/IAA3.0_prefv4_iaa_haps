`ifndef HQM_ARM_CMD_SEQ__SV
`define HQM_ARM_CMD_SEQ__SV

class hqm_arm_cmd_seq extends hqm_base_seq;

  typedef bit [3:0] vf_num_t;
  typedef bit [5:0] pp_num_t;
  bit [32:0] max_cnt_val = 'h0 ; //'h101;
  hqm_cfg                                      i_hqm_cfg;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq cfg_write_busnum_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq cfg_read_busnum_seq;

  int unsigned ldb_vf_hcw_gen[vf_num_t][pp_num_t];
  int unsigned ldb_pf_hcw_gen[pp_num_t];
  int unsigned dir_vf_hcw_gen[vf_num_t][pp_num_t];
  int unsigned dir_pf_hcw_gen[pp_num_t];

  `ovm_sequence_utils(hqm_arm_cmd_seq, sla_sequencer)

  function new(string name = "hqm_arm_cmd_seq");
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

      // -- Start traffic with the default bus number for VF and PF
      ovm_report_info(get_full_name(), $psprintf("Starting traffic on DIR PORT "), OVM_LOW);
      start_traffic(1);


  endtask


  task start_traffic(int iteration);       
      
      string           cfg_cmds[$];
      bit [31:0]       rd_val;
      bit [63:0]       cnt;
      bit [63:0]       cnt_cq[];
      cnt_cq = new[50] ;
      



      ovm_report_info(get_full_name(), $psprintf("Starting traffic on DIR PORT CQ->0,2,4,6 "), OVM_LOW);
      //##set arm command for cq4,cq5, send HCW and check timer started and poll for counter some value and send ARM command again
      //set arm command cq[0:6] even
      cfg_cmds.push_back("HCW DIR:0 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:2 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:4 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:6 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=6 dsi=0x302"); 
      cfg_cmds.push_back("idle 500");
      //send 1HCW for each QE to start timer
      cfg_cmds.push_back("HCW DIR:0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:2 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:4 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:6 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=6 dsi=0x302"); 
      cfg_cmds.push_back("idle 500");
      //wait for scheduling 
      cfg_cmds.push_back("poll_sch dir:0 0x1  10 50");
      cfg_cmds.push_back("poll_sch dir:2 0x1  10 50");
      cfg_cmds.push_back("poll_sch dir:4 0x1  10 50");
      cfg_cmds.push_back("poll_sch dir:6 0x1  10 50");
      // check timer started
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_intr_run_timer0 0x55 0xffffffff 10 500");
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
      //check counter started 
      /*
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[0]  0x20 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[2]  0x2a 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[4]  0x34 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[6]  0x3e 0xffffffff 10 300");
      */

      while((cnt_cq[0]<'h20 || cnt_cq[2]<'h2a) || (cnt_cq[4]<'h34 || cnt_cq[6] < 'h3e)) begin
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd0), cnt_cq[0], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd2), cnt_cq[2], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd4), cnt_cq[4], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd6), cnt_cq[6], "credit_hist_pipe");  
      wait_for_clk(10);
      end

      //send arm command  again
      cfg_cmds.push_back("HCW DIR:0 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:2 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:4 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:6 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=6 dsi=0x302"); 

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

      // -- Check counter value is not less than value 0x1E,and timer is not reseted
      wait_for_clk(20);
      //cnt_cq[0]=0;
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd0), cnt_cq[0],  "credit_hist_pipe");
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd2), cnt_cq[2],  "credit_hist_pipe");
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd4), cnt_cq[4],  "credit_hist_pipe");
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd6), cnt_cq[6],  "credit_hist_pipe");
      if  (cnt_cq[0] < 'h20 || cnt_cq[4] < 'h2a  
        || cnt_cq[2] < 'h34 || cnt_cq[6] < 'h3e )begin
         `ovm_error(get_type_name(), $psprintf("counter reset with re-arm command cq_0= %d cq_4=%d", cnt_cq[0], cnt_cq[3]));
      end
      // -- now wait for counter to count expected 0x81 ticks 
      fork 
       begin poll_reg("cfg_dir_cq_timer_count[0]", max_cnt_val,"credit_hist_pipe"); end
     // poll_reg("cfg_dir_cq_timer_count[0]", 'h81,"credit_hist_pipe");
       begin poll_reg("cfg_dir_cq_timer_count[2]", max_cnt_val,"credit_hist_pipe"); end
       begin poll_reg("cfg_dir_cq_timer_count[4]", max_cnt_val,"credit_hist_pipe"); end
       begin poll_reg("cfg_dir_cq_timer_count[6]", max_cnt_val,"credit_hist_pipe"); end
      join

     //check for cq occ interupt, armd for dir-cq[0,,2,4,6] & ldb-cq[1,3,5,7] 
     // -- check cq occupancy status reg, check armed reg 
      compare_reg("dir_cq_31_0_occ_int_status",  'h55, rd_val, "hqm_system_csr");
      compare_reg("dir_cq_63_32_occ_int_status", 'h0,  rd_val, "hqm_system_csr");
     // -- check cq is armed      
      compare_reg("cfg_dir_cq_intr_armed0", 'h00AAAA00,rd_val, "credit_hist_pipe");
      compare_reg("cfg_dir_cq_intr_armed1", 'h0,       rd_val, "credit_hist_pipe");

     // -- token return 
     cfg_cmds.push_back("HCW DIR:0 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x00 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
     cfg_cmds.push_back("idle 300");
     cfg_cmds.push_back("HCW DIR:2 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x00 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302");
     cfg_cmds.push_back("idle 300");
     cfg_cmds.push_back("HCW DIR:4 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x00 msgtype=0 qpri=0 qtype=dir qid=4 dsi=0x302"); 
     cfg_cmds.push_back("idle 300");
     cfg_cmds.push_back("HCW DIR:6 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x00 msgtype=0 qpri=0 qtype=dir qid=6 dsi=0x302"); 
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
      ovm_report_info(get_full_name(), $psprintf("completed traffic on DIR PORT CQ->0,2,4,6 "), OVM_LOW);
      wait_for_clk(50);
   
    //check on ldb traffic
    //send arm command  
      ovm_report_info(get_full_name(), $psprintf("Starting traffic on LDB PORT CQ->1,3,5,7 "), OVM_LOW);
    cfg_cmds.push_back("HCW LDB:1 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=1 dsi=0x302"); 
    cfg_cmds.push_back("HCW LDB:3 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x302"); 
    cfg_cmds.push_back("HCW LDB:5 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302"); 
    cfg_cmds.push_back("HCW LDB:7 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302"); 
    cfg_cmds.push_back("idle 500");
    //send 1HCW for each QE to start timer
    cfg_cmds.push_back("HCW LDB:1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=1 dsi=0x302"); 
    cfg_cmds.push_back("HCW LDB:3 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x302"); 
    cfg_cmds.push_back("HCW LDB:5 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302"); 
    cfg_cmds.push_back("HCW LDB:7 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302"); 
    cfg_cmds.push_back("idle 500");
    //wait for scheduling 
    cfg_cmds.push_back("poll_sch ldb:1 0x1 10 50"); 
    cfg_cmds.push_back("poll_sch ldb:3 0x1 10 50");
    cfg_cmds.push_back("poll_sch ldb:5 0x1 10 50");
    cfg_cmds.push_back("poll_sch ldb:7 0x1 10 50");
    //check timer and counter started 
    cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_intr_run_timer0 0xaa 0xffffffff 10 500");
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
    /*
    cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[1]  0x20 0xffffffff 10 300");
    cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[3]  0x2a 0xffffffff 10 300");
    cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[5]  0x34 0xffffffff 10 300");
    cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[7]  0x3e 0xffffffff 10 300");
    */
      while((cnt_cq[1]<'h20 || cnt_cq[3]<'h2a) || (cnt_cq[5]<'h34 || cnt_cq[7] < 'h3e)) begin
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd1), cnt_cq[1], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd3), cnt_cq[3], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd5), cnt_cq[5], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd7), cnt_cq[7], "credit_hist_pipe");  
      wait_for_clk(10);
      end
    //send arm command  again
    cfg_cmds.push_back("HCW LDB:1 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=1 dsi=0x302");
    cfg_cmds.push_back("HCW LDB:3 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x302");
    cfg_cmds.push_back("HCW LDB:5 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
    cfg_cmds.push_back("HCW LDB:7 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302");


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

      // -- Check counter value is not less than value earlier polled ,and timer is not reseted
      wait_for_clk(50);
      // check timer not reseted 
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd1), cnt_cq[1], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd3), cnt_cq[3], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd5), cnt_cq[5], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd7), cnt_cq[7], "credit_hist_pipe");  
      if  (cnt_cq[1] < 'h20 || cnt_cq[3] < 'h2a  
        || cnt_cq[5] < 'h34 || cnt_cq[7] < 'h3e)begin
         `ovm_error(get_type_name(), $psprintf("counter reset with re-arm command cq_1= %d cq_7=%d", cnt_cq[1], cnt_cq[7]));
      end
      //wait for counter to reach  max count value
      fork
      begin poll_reg("cfg_ldb_cq_timer_count[1]", max_cnt_val,"credit_hist_pipe"); end
      begin poll_reg("cfg_ldb_cq_timer_count[3]", max_cnt_val,"credit_hist_pipe"); end
      begin poll_reg("cfg_ldb_cq_timer_count[5]", max_cnt_val,"credit_hist_pipe"); end
      begin poll_reg("cfg_ldb_cq_timer_count[7]", max_cnt_val,"credit_hist_pipe"); end
      join
      //check for cq occ interupt, armd for  ldb-cq[1,3,5,7] 
      compare_reg("ldb_cq_31_0_occ_int_status", 'haa, rd_val, "hqm_system_csr");
      compare_reg("ldb_cq_63_32_occ_int_status",'h0,  rd_val, "hqm_system_csr");
      // -- check cq is armed      
      compare_reg("cfg_ldb_cq_intr_armed0", 'h00555500, rd_val, "credit_hist_pipe");
      compare_reg("cfg_ldb_cq_intr_armed1", 'h0,        rd_val, "credit_hist_pipe");

      // -- token return and completion
      cfg_cmds.push_back("HCW LDB:1 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x00  msgtype=0 qpri=0 qtype=uno qid=1 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:3 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x00  msgtype=0 qpri=0 qtype=uno qid=3 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:5 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x00  msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:7 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x00  msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302");
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
      ovm_report_info(get_full_name(), $psprintf("completed traffic on LDB PORT CQ->1,3,5,7 "), OVM_LOW);
      wait_for_clk(50);


      // DIR Traffic VF Mode DIR CQ [9-23] odd;

      // send ARM command 
      ovm_report_info(get_full_name(), $psprintf("Starting traffic on DIR PORT on VF 1,3,5,7,9,11,13,15 "), OVM_LOW);
      cfg_cmds.push_back("HCW DIR:0 vf_num=1  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:1 vf_num=3  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:2 vf_num=5  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:3 vf_num=7  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=3 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:0 vf_num=9  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:1 vf_num=11 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:2 vf_num=13 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:3 vf_num=15 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=3 dsi=0x302"); 
      
      // send HCW=NEW command
      cfg_cmds.push_back("HCW DIR:0 vf_num=1  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:1 vf_num=3  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:2 vf_num=5  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:3 vf_num=7  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=3 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:0 vf_num=9  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:1 vf_num=11 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:2 vf_num=13 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:3 vf_num=15 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=3 dsi=0x302"); 
      // wait for schedulung 
      cfg_cmds.push_back("poll_sch dir:9  0x1 10 50");
      cfg_cmds.push_back("poll_sch dir:11 0x1 10 50");
      cfg_cmds.push_back("poll_sch dir:13 0x1 10 50");
      cfg_cmds.push_back("poll_sch dir:15 0x1 10 50");
      cfg_cmds.push_back("poll_sch dir:17 0x1 10 50");
      cfg_cmds.push_back("poll_sch dir:19 0x1 10 50");
      cfg_cmds.push_back("poll_sch dir:21 0x1 10 50");
      cfg_cmds.push_back("poll_sch dir:23 0x1 10 50");
      // check timer & counter started 
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_intr_run_timer0 0xaaaa00 0xffffffff 10 500");
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
      /* 
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[9]  0x20 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[11] 0x2a 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[13] 0x34 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[15] 0x3e 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[17] 0x48 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[19] 0x52 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[21] 0x5c 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_dir_cq_timer_count[23] 0x66 0xffffffff 10 300"); */
      while( (cnt_cq[9]<'h20  || cnt_cq[11]<'h2a) || (cnt_cq[13]<'h34 || cnt_cq[15] < 'h3e) 
           || (cnt_cq[17]<'h48 || cnt_cq[19]<'h52) || (cnt_cq[21]<'h5c || cnt_cq[23] < 'h66)) begin
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd9),  cnt_cq[9],  "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd11), cnt_cq[11], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd13), cnt_cq[13], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd15), cnt_cq[15], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd17), cnt_cq[17], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd19), cnt_cq[19], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd21), cnt_cq[21], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd23), cnt_cq[23], "credit_hist_pipe");  
      wait_for_clk(10);
      end


      // re send arm commands
      cfg_cmds.push_back("HCW DIR:0 vf_num=1  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:1 vf_num=3  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:2 vf_num=5  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:3 vf_num=7  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=3 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:0 vf_num=9  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:1 vf_num=11 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:2 vf_num=13 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("HCW DIR:3 vf_num=15 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=3 dsi=0x302"); 

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

      // -- Check counter value is not less than value polled value
      wait_for_clk(50);
      //cnt_cq[0]=0;
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd9),   cnt_cq[9],  "credit_hist_pipe");
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd11),  cnt_cq[11],  "credit_hist_pipe");
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd13),  cnt_cq[13],  "credit_hist_pipe");
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd15),  cnt_cq[15],  "credit_hist_pipe");
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd17),  cnt_cq[17],  "credit_hist_pipe");
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd19),  cnt_cq[19],  "credit_hist_pipe");
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd21),  cnt_cq[21],  "credit_hist_pipe");
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", 'd23),  cnt_cq[23],  "credit_hist_pipe");
      if  (cnt_cq[9] < 'h20 || cnt_cq[11] < 'h2a  
        || cnt_cq[13] < 'h34 || cnt_cq[15] < 'h3e 
        || cnt_cq[17] < 'h48 || cnt_cq[19] < 'h52 
        || cnt_cq[21] < 'h5c || cnt_cq[23] < 'h66 )
        begin
         `ovm_error(get_type_name(), $psprintf("counter reset with re-arm command cq_0= %d cq_23=%d", cnt_cq[9], cnt_cq[23]));
      end
      // -- now wait for counter to count expected ticks 
      fork 
      begin poll_reg("cfg_dir_cq_timer_count[9]",  max_cnt_val,"credit_hist_pipe"); end 
      begin poll_reg("cfg_dir_cq_timer_count[11]", max_cnt_val,"credit_hist_pipe"); end
      begin poll_reg("cfg_dir_cq_timer_count[13]", max_cnt_val,"credit_hist_pipe"); end
      begin poll_reg("cfg_dir_cq_timer_count[15]", max_cnt_val,"credit_hist_pipe"); end
      begin poll_reg("cfg_dir_cq_timer_count[17]", max_cnt_val,"credit_hist_pipe"); end
      begin poll_reg("cfg_dir_cq_timer_count[19]", max_cnt_val,"credit_hist_pipe"); end
      begin poll_reg("cfg_dir_cq_timer_count[21]", max_cnt_val,"credit_hist_pipe"); end
      begin poll_reg("cfg_dir_cq_timer_count[23]", max_cnt_val,"credit_hist_pipe"); end
      join
      // -- check cq is armed      
      compare_reg("cfg_dir_cq_intr_armed0", 'h0, rd_val, "credit_hist_pipe");
      compare_reg("cfg_dir_cq_intr_armed1", 'h0, rd_val, "credit_hist_pipe");
       //-- return token
      cfg_cmds.push_back("HCW DIR:0 vf_num=1  qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back("HCW DIR:1 vf_num=3  qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back("HCW DIR:2 vf_num=5  qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back("HCW DIR:3 vf_num=7  qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=3 dsi=0x302"); 
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back("HCW DIR:0 vf_num=9  qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302"); 
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back("HCW DIR:1 vf_num=11 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=1 dsi=0x302"); 
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back("HCW DIR:2 vf_num=13 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=2 dsi=0x302"); 
      cfg_cmds.push_back("idle 300");
      cfg_cmds.push_back("HCW DIR:3 vf_num=15 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=dir qid=3 dsi=0x302"); 
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

      ovm_report_info(get_full_name(), $psprintf("Completed traffic on DIR PORT on VF 1,3,5,7,9,11,13,15 "), OVM_LOW);
      wait_for_clk(50);

      // LDB traffic on VF
      //arm command
      ovm_report_info(get_full_name(), $psprintf("Starting traffic on LDB PORT on VF 0,2,4,6,8,10,12,14 "), OVM_LOW);
      cfg_cmds.push_back("HCW LDB:4 vf_num=0  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:5 vf_num=2  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:6 vf_num=4  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=6 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:7 vf_num=6  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:4 vf_num=8  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:5 vf_num=10 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:6 vf_num=12 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=6 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:7 vf_num=14 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302");
      cfg_cmds.push_back("idle 100");
      //send HCW=NEW command
      cfg_cmds.push_back("HCW LDB:4 vf_num=0  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:5 vf_num=2  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:6 vf_num=4  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=6 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:7 vf_num=6  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:4 vf_num=8  qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:5 vf_num=10 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:6 vf_num=12 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=6 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:7 vf_num=14 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302");
      cfg_cmds.push_back("idle 100");
      // wait for scheduling 
      cfg_cmds.push_back("poll_sch ldb:8  0x1 10 50");
      cfg_cmds.push_back("poll_sch ldb:10 0x1 10 50");
      cfg_cmds.push_back("poll_sch ldb:12 0x1 10 50");
      cfg_cmds.push_back("poll_sch ldb:14 0x1 10 50");
      cfg_cmds.push_back("poll_sch ldb:16 0x1 10 50");
      cfg_cmds.push_back("poll_sch ldb:18 0x1 10 50");
      cfg_cmds.push_back("poll_sch ldb:20 0x1 10 50");
      cfg_cmds.push_back("poll_sch ldb:22 0x1 10 50");
      cfg_cmds.push_back("idle 100");
      // check timer and counter started 
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_intr_run_timer0 0x555500 0xffffffff 10 500");
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

      /*cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[8]   0x20 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[10]  0x2a 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[12]  0x34 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[14]  0x3e 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[16]  0x48 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[18]  0x52 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[20]  0x5c 0xffffffff 10 300");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_ldb_cq_timer_count[22]  0x66 0xffffffff 10 300"); */
      while( (cnt_cq[8]<'h20  || cnt_cq[10]<'h2a) || (cnt_cq[12]<'h34 || cnt_cq[14] < 'h3e) 
           ||(cnt_cq[16]<'h48 || cnt_cq[18]<'h52) || (cnt_cq[20]<'h5c || cnt_cq[22] < 'h66)) begin
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd8),  cnt_cq[8],  "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd10), cnt_cq[10], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd12), cnt_cq[12], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd14), cnt_cq[14], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd16), cnt_cq[16], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd18), cnt_cq[18], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd20), cnt_cq[20], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd22), cnt_cq[22], "credit_hist_pipe");  
      wait_for_clk(10);
      end


      //re send arm commands
      cfg_cmds.push_back("HCW LDB:4 vf_num=0  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:5 vf_num=2  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:6 vf_num=4  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=6 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:7 vf_num=6  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:4 vf_num=8  qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:5 vf_num=10 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:6 vf_num=12 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=6 dsi=0x302");
      cfg_cmds.push_back("HCW LDB:7 vf_num=14 qe_valid=0 qe_orsp=1 qe_uhl=0 cq_pop=1 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302");

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

      // -- Check counter value is not less than value earlier polled ,and timer is not reseted
      wait_for_clk(50);
      // check timer not reseted 
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd8),  cnt_cq[8],  "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd10), cnt_cq[10], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd12), cnt_cq[12], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd14), cnt_cq[14], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd16), cnt_cq[16], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd18), cnt_cq[18], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd20), cnt_cq[20], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", 'd22), cnt_cq[22], "credit_hist_pipe");  
      if  (cnt_cq[8] < 'h20 || cnt_cq[10] < 'h2a  
        || cnt_cq[12] < 'h34 || cnt_cq[14] < 'h3e
        || cnt_cq[16] < 'h48 || cnt_cq[18] < 'h52
        || cnt_cq[20] < 'h5c || cnt_cq[22] < 'h66)begin
         `ovm_error(get_type_name(), $psprintf("counter reset with re-arm command cq_8= %d cq_22=%d", cnt_cq[8], cnt_cq[22]));
      end
      //wait for counter to reach  max count value
      fork
       begin poll_reg("cfg_ldb_cq_timer_count[8]",  max_cnt_val,"credit_hist_pipe"); end 
       begin poll_reg("cfg_ldb_cq_timer_count[10]", max_cnt_val,"credit_hist_pipe"); end
       begin poll_reg("cfg_ldb_cq_timer_count[12]", max_cnt_val,"credit_hist_pipe"); end
       begin poll_reg("cfg_ldb_cq_timer_count[14]", max_cnt_val,"credit_hist_pipe"); end
       begin poll_reg("cfg_ldb_cq_timer_count[16]", max_cnt_val,"credit_hist_pipe"); end
       begin poll_reg("cfg_ldb_cq_timer_count[18]", max_cnt_val,"credit_hist_pipe"); end
       begin poll_reg("cfg_ldb_cq_timer_count[20]", max_cnt_val,"credit_hist_pipe"); end
       begin poll_reg("cfg_ldb_cq_timer_count[22]", max_cnt_val,"credit_hist_pipe"); end
      join
      // -- check cq is armed      
      compare_reg("cfg_ldb_cq_intr_armed0", 'h0, rd_val, "credit_hist_pipe");
      compare_reg("cfg_ldb_cq_intr_armed1", 'h0, rd_val, "credit_hist_pipe");
      // -- token return and completion
      cfg_cmds.push_back("HCW LDB:4 vf_num=0  qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
      cfg_cmds.push_back("idle 100");
      cfg_cmds.push_back("HCW LDB:5 vf_num=2  qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
      cfg_cmds.push_back("idle 100");
      cfg_cmds.push_back("HCW LDB:6 vf_num=4  qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=6 dsi=0x302");
      cfg_cmds.push_back("idle 100");
      cfg_cmds.push_back("HCW LDB:7 vf_num=6  qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302");
      cfg_cmds.push_back("idle 100");
      cfg_cmds.push_back("HCW LDB:4 vf_num=8  qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=4 dsi=0x302");
      cfg_cmds.push_back("idle 100");
      cfg_cmds.push_back("HCW LDB:5 vf_num=10 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=5 dsi=0x302");
      cfg_cmds.push_back("idle 100");
      cfg_cmds.push_back("HCW LDB:6 vf_num=12 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=6 dsi=0x302");
      cfg_cmds.push_back("idle 100");
      cfg_cmds.push_back("HCW LDB:7 vf_num=14 qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x000 msgtype=0 qpri=0 qtype=uno qid=7 dsi=0x302");
      cfg_cmds.push_back("idle 100");
      cfg_cmds.push_back("poll credit_hist_pipe.cfg_vas_credit_count[:VAS0:] 0x400 0xffffffff 1000 200");
      cfg_cmds.push_back("idle 500");
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
      ovm_report_info(get_full_name(), $psprintf("completed traffic on LDB PORT on VF 0,2,4,6,8,10,12,14 "), OVM_LOW);
      wait_for_clk(100);
      
  endtask : start_traffic

endclass : hqm_arm_cmd_seq

`endif //HQM_ARM_CMD_SEQ__SV


