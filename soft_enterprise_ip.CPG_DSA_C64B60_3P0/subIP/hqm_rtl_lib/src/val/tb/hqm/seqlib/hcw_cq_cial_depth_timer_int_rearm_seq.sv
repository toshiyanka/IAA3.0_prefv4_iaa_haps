`ifndef HCW_CQ_CIAL_DEPTH_TIMER_INT_REARM_SEQ__SV
`define HCW_CQ_CIAL_DEPTH_TIMER_INT_REARM_SEQ__SV

//  


class hcw_cq_cial_depth_timer_int_rearm_seq extends hcw_cq_threshold_0_seq;

  `ovm_sequence_utils(hcw_cq_cial_depth_timer_int_rearm_seq, sla_sequencer)

      ovm_event_pool        glbl_pool;
      ovm_event             exp_msix;
      ovm_object            o_tmp;
      sla_ral_addr_t        addr;
      sla_ral_reg           reg_h;
      sla_ral_data_t        rd_data;
      sla_ral_data_t        rd_data_val[$];
      sla_ral_data_t        wr_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]            rd_val;
      hcw_qtype             qtype_in;
      bit                   is_ldb;
      bit [7:0]             dqid[hqm_pkg::NUM_DIR_CQ];
      bit [7:0]             lqid[hqm_pkg::NUM_LDB_QID];
      bit [7:0]             lpp[hqm_pkg::NUM_LDB_CQ];
      bit [3:0]             vf[16];
      bit [3:0]             vdev[16];
      bit [31:0]            exp_synd_val;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]            dir_cq_occ;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]            ldb_cq_occ;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]            dir_cq_armed;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]            ldb_cq_armed;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]            dir_rd_val;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]            ldb_rd_val;
      bit [10:0]            cq_depth_val;
      bit [10:0]            enq_cnt_val;
      bit [12:0]            cq_intr_depth_thrsh_val;
      bit [7:0]             dir_cq_cnt;
      bit [7:0]             ldb_cq_cnt;
      bit [7:0]             ldb_qid_cnt;
      bit [31:0]            dir_cq_timer_cnt[];
      bit [31:0]            ldb_cq_timer_cnt[];
      bit [31:0]            ref_dir_cq_timer_cnt[];
      bit [31:0]            ref_ldb_cq_timer_cnt[];
      int unsigned          count;
      int unsigned          iteration;
      int unsigned          int_depth_thrs;
      int unsigned          timeout_val;
      extern task           body();
      extern task           cq_cial_check();
      extern task           send_hcw_new(input int unsigned iteration=1);
      extern task           send_hcw_arm(bit check_armed=1);
      extern task           check_interrupt(input bit [6:0] dir_cq, input bit [6:0] ldb_cq);

    function new(string name = "hcw_cq_cial_depth_timer_int_rearm_seq");
      super.new(name);
    endfunction

endclass: hcw_cq_cial_depth_timer_int_rearm_seq

    task hcw_cq_cial_depth_timer_int_rearm_seq::body();
      ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_MEDIUM);
      get_hqm_cfg();
      dir_cq_cnt=hqm_pkg::NUM_DIR_CQ;
      ldb_cq_cnt=hqm_pkg::NUM_LDB_CQ;
      ldb_qid_cnt=hqm_pkg::NUM_LDB_QID;
      // -- get the DIR/PP QID Number
      for (int i=0;i<dir_cq_cnt;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("DQID%0d",i),dqid[i])) begin
          `ovm_info(get_full_name(), $psprintf("Logical DIR PP %0d maps to physical PP %0d",i,dqid[i]),OVM_MEDIUM)
        end else begin
         `ovm_error(get_full_name(), $psprintf("DQID%0d name not found in hqm_cfg",i))
        end
      end //:dir_qid_num 
     // -- get the LDB QID Number
     for (int i=0;i<ldb_qid_cnt;i++) begin //:ldb_qid num
       if (i_hqm_cfg.get_name_val($psprintf("LQID%0d",i),lqid[i])) begin
         `ovm_info(get_full_name(), $psprintf("Logical LDB QID %0d maps to physical QID %0d",i,lqid[i]),OVM_MEDIUM)
       end else begin
        `ovm_error(get_full_name(), $psprintf("LQID%0d name not found in hqm_cfg",i))
       end
     end //:ldb qid_num 
     // -- get the LDB PP Number
     for (int i=0;i<ldb_cq_cnt;i++) begin //:ldb_pp num
       if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",i),lpp[i])) begin
         `ovm_info(get_full_name(), $psprintf("Logical LDB PP %0d maps to physical PP %0d",i,lpp[i]),OVM_MEDIUM)
       end else begin
        `ovm_error(get_full_name(), $psprintf("LPP%0d name not found in hqm_cfg",i))
       end
     end //:ldb pp_num 
     // -- get the VDEV number 
     if(i_hqm_cfg.is_sciov_mode()) begin
     for (int i=0;i<1 ;i++) begin //:vdev num
       if (i_hqm_cfg.get_name_val($psprintf("VDEV%0d",i),vdev[i])) begin
         `ovm_info(get_full_name(), $psprintf("Logical VDEV %0d maps to physical VDEV %0d",i,vdev[i]),OVM_MEDIUM)
       end else begin
         `ovm_info(get_full_name(), $psprintf("VDEV%0d name not found in hqm_cfg",i),OVM_LOW)
       end
     end //get_vdev_num
     end //is_sciov_mode 
     // -- get the VF number  
     if(i_hqm_cfg.is_sriov_mode()) begin
     for (int i=0;i<1 ;i++) begin //get_vf num
       if (i_hqm_cfg.get_name_val($psprintf("VF%0d",i),vf[i])) begin
         `ovm_info(get_full_name(), $psprintf("Logical VF %0d maps to physical VF %0d",i,vf[i]),OVM_MEDIUM)
       end else begin
         `ovm_error(get_full_name(), $psprintf("VF%0d name not found in hqm_cfg",i))
       end
     end //get_vf
     end //sriov_mode

      cq_depth_val = i_hqm_cfg.get_cq_depth(0,dqid[0]);
     `ovm_info(get_full_name(), $psprintf("CQ_DEPTH = %0d", cq_depth_val),OVM_LOW)
      if($value$plusargs("TIMEOUT_VAL=%d", timeout_val)) begin
       this.timeout_val= timeout_val;
      end else begin 
        timeout_val= 10000; // 8'd12;
      end
     `ovm_info(get_full_name(), $psprintf("TIMEOUT_VAL=%0d ", timeout_val),OVM_LOW)
      wait_for_clk(10);
      cq_cial_check();
  endtask: body

//=======================================================//
//=======================================================//

task hcw_cq_cial_depth_timer_int_rearm_seq::cq_cial_check();

    ovm_report_info(get_full_name(), $psprintf("hcw_cq_cial_depth_timer_int_rearm_seq:-- Start"), OVM_MEDIUM);

    send_hcw_arm(1);

    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Iteration-1 Start"), OVM_MEDIUM);
    //iteration-1 1024 hcw to dqid[0], exp cq_occ and armed on dqid[0]
    //1024 hcw to lpp[0], exp cq_occ and armed on lpp[0]
    write_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[32]), {"disabled"}, {" 'h1"}, "list_sel_pipe"); 
    compare_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[32]),  {"disabled"}, {" 'h1"}, rd_data_val , "list_sel_pipe"); 
    send_new_pf(.pp_num(dqid[0]), .qid(dqid[0]), .rpt(1024), .is_ldb(0));
    send_new_pf(.pp_num(lpp[0]),  .qid(lqid[0]), .rpt(1024), .is_ldb(1));
    execute_cfg_cmds();
    fork
    poll_sch( .cq_num(dqid[0]), .exp_cnt(1024), .is_ldb(0), .delay(100), .timeout(timeout_val));
    poll_sch( .cq_num(lpp[0]),  .exp_cnt(1024), .is_ldb(1), .delay(100), .timeout(timeout_val));
    join
   
    check_interrupt(.dir_cq(dqid[0]),.ldb_cq(lpp[0]));
    fork
    send_bat_t_pf(  .pp_num(dqid[0]), .tkn_cnt(0), .is_ldb(0));
    send_comp_t_pf( .pp_num(lpp[0]),  .rpt(1));
    join
    fork
    poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[0]), 'd1023, "credit_hist_pipe");  
    poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[0]),  'd1023, "credit_hist_pipe");  
    join  


    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Iteration-2 Start"), OVM_MEDIUM);
    //iteration-2: 1-hcw to cq-63/63, 1-hcw to cq-0
    write_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[hqm_pkg::NUM_LDB_QID-1]), {"disabled"}, {" 'h1"}, "list_sel_pipe"); 
    compare_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[hqm_pkg::NUM_LDB_QID-1]),  {"disabled"}, {" 'h1"}, rd_data_val , "list_sel_pipe"); 

    send_new_pf(.pp_num(lpp[0]),   .qid(lqid[0]),  .rpt(1), .is_ldb(1));
    send_new_pf(.pp_num(lpp[hqm_pkg::NUM_LDB_CQ-1]),  .qid(lqid[hqm_pkg::NUM_LDB_QID-1]), .rpt(1), .is_ldb(1));
    send_new_pf(.pp_num(dqid[0]),  .qid(dqid[0]),  .rpt(1), .is_ldb(0));
    send_new_pf(.pp_num(dqid[hqm_pkg::NUM_DIR_CQ-1]), .qid(dqid[hqm_pkg::NUM_DIR_CQ-1]), .rpt(1), .is_ldb(0));
    execute_cfg_cmds();

    poll_sch(.cq_num(dqid[0]),  .exp_cnt(1025), .is_ldb(0));
    poll_sch(.cq_num(dqid[hqm_pkg::NUM_DIR_CQ-1]), .exp_cnt(1),    .is_ldb(0));
    poll_sch( .cq_num(lpp[0]),  .exp_cnt(1025), .is_ldb(1));
    poll_sch( .cq_num(lpp[hqm_pkg::NUM_LDB_CQ-1]), .exp_cnt(1),    .is_ldb(1));

    check_interrupt(.dir_cq(dqid[hqm_pkg::NUM_DIR_CQ-1]),.ldb_cq(lpp[hqm_pkg::NUM_LDB_CQ-1]));

    send_bat_t_pf( .pp_num(dqid[0]),  .tkn_cnt(0), .is_ldb(0));
    send_bat_t_pf( .pp_num(dqid[hqm_pkg::NUM_DIR_CQ-1]), .tkn_cnt(0), .is_ldb(0));
    send_comp_t_pf( .pp_num(lpp[0]),  .rpt(1));
    send_comp_t_pf( .pp_num(lpp[hqm_pkg::NUM_LDB_CQ-1]), .rpt(1));
    fork
    poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[0]), 'd1023, "credit_hist_pipe");  
    poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[hqm_pkg::NUM_DIR_CQ-1]), 'h0,    "credit_hist_pipe");  
    poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[0]), 'd1023, "credit_hist_pipe");  
    poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[hqm_pkg::NUM_LDB_CQ-1]), 'h0,    "credit_hist_pipe");  
    join 

    //iteration-3:send in 3 hcws: 1 going to cq 63/63, 1 going to cq 62/62, 1 going to cq 0/0, expected interrupt for cq 62/62  
    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Iteration-3 Start"), OVM_MEDIUM);

    write_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[hqm_pkg::NUM_LDB_QID-2]), {"disabled"}, {" 'h1"}, "list_sel_pipe"); 
    compare_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[hqm_pkg::NUM_LDB_QID-2]),  {"disabled"}, {" 'h1"}, rd_data_val , "list_sel_pipe"); 
    send_new_pf(.pp_num(lpp[0]),  .qid(lqid[0]),   .rpt(1), .is_ldb(1));
    send_new_pf(.pp_num(lpp[hqm_pkg::NUM_LDB_CQ-2]), .qid(lqid[hqm_pkg::NUM_LDB_QID-2]),  .rpt(1), .is_ldb(1));
    send_new_pf(.pp_num(lpp[hqm_pkg::NUM_LDB_CQ-1]), .qid(lqid[hqm_pkg::NUM_LDB_QID-1]),  .rpt(1), .is_ldb(1));

    send_new_pf(.pp_num(dqid[0]),  .qid(dqid[0]),  .rpt(1), .is_ldb(0));
    send_new_pf(.pp_num(dqid[hqm_pkg::NUM_DIR_CQ-2]), .qid(dqid[hqm_pkg::NUM_DIR_CQ-2]), .rpt(1), .is_ldb(0));
    send_new_pf(.pp_num(dqid[hqm_pkg::NUM_DIR_CQ-1]), .qid(dqid[hqm_pkg::NUM_DIR_CQ-1]), .rpt(1), .is_ldb(0));

    execute_cfg_cmds();
    fork
    poll_sch( .cq_num(lpp[0]),  .exp_cnt(1026), .is_ldb(1));
    poll_sch( .cq_num(lpp[hqm_pkg::NUM_LDB_CQ-2]), .exp_cnt(1),    .is_ldb(1));
    poll_sch( .cq_num(lpp[hqm_pkg::NUM_LDB_CQ-1]), .exp_cnt(2),    .is_ldb(1));

    poll_sch(.cq_num(dqid[0]),  .exp_cnt(1026), .is_ldb(0));
    poll_sch(.cq_num(dqid[hqm_pkg::NUM_DIR_CQ-1]), .exp_cnt(2),    .is_ldb(0));
    poll_sch(.cq_num(dqid[hqm_pkg::NUM_DIR_CQ-2]), .exp_cnt(1),    .is_ldb(0));
    join

    check_interrupt(.dir_cq(dqid[hqm_pkg::NUM_DIR_CQ-2]),.ldb_cq(lpp[hqm_pkg::NUM_LDB_CQ-2]));
    fork
    send_bat_t_pf( .pp_num(dqid[0]),  .tkn_cnt(0), .is_ldb(0));
    send_bat_t_pf( .pp_num(dqid[hqm_pkg::NUM_DIR_CQ-2]), .tkn_cnt(0), .is_ldb(0));
    send_bat_t_pf( .pp_num(dqid[hqm_pkg::NUM_DIR_CQ-1]), .tkn_cnt(0), .is_ldb(0));
    send_comp_t_pf( .pp_num(lpp[0]),  .rpt(1));
    send_comp_t_pf( .pp_num(lpp[hqm_pkg::NUM_LDB_CQ-2]),  .rpt(1));
    send_comp_t_pf( .pp_num(lpp[hqm_pkg::NUM_LDB_CQ-1]),  .rpt(1));
    join

    fork
    poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[0]),  'd1023, "credit_hist_pipe");  
    poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[hqm_pkg::NUM_DIR_CQ-2]), 'h0,    "credit_hist_pipe");  
    poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[hqm_pkg::NUM_DIR_CQ-1]), 'h0,    "credit_hist_pipe");  
    poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[0]),   'd1023, "credit_hist_pipe");  
    poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[hqm_pkg::NUM_LDB_CQ-2]),  'h0,    "credit_hist_pipe");  
    poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[hqm_pkg::NUM_LDB_CQ-1]),  'h0,    "credit_hist_pipe");  
    join
 
    //iteration-4:4-hcws:1 to cq 63/63,62/62,0/0,1/1, expected interrupt for cq 1 (
    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Iteration-4 Start"), OVM_MEDIUM);
    write_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[33]), {"disabled"}, {" 'h1"}, "list_sel_pipe"); 
    compare_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[33]),  {"disabled"}, {" 'h1"}, rd_data_val , "list_sel_pipe"); 

    send_new_pf(.pp_num(lpp[0]),  .qid(lqid[0]),   .rpt(1), .is_ldb(1));
    send_new_pf(.pp_num(lpp[1]),  .qid(lqid[1]),   .rpt(1), .is_ldb(1));
    send_new_pf(.pp_num(lpp[hqm_pkg::NUM_LDB_CQ-2]), .qid(lqid[hqm_pkg::NUM_LDB_QID-2]),  .rpt(1), .is_ldb(1));
    send_new_pf(.pp_num(lpp[hqm_pkg::NUM_LDB_CQ-1]), .qid(lqid[hqm_pkg::NUM_LDB_QID-1]),  .rpt(1), .is_ldb(1));
    send_new_pf(.pp_num(dqid[0]),  .qid(dqid[0]),  .rpt(1), .is_ldb(0));
    send_new_pf(.pp_num(dqid[hqm_pkg::NUM_DIR_CQ-1]), .qid(dqid[hqm_pkg::NUM_DIR_CQ-1]), .rpt(1), .is_ldb(0));
    send_new_pf(.pp_num(dqid[hqm_pkg::NUM_DIR_CQ-2]), .qid(dqid[hqm_pkg::NUM_DIR_CQ-2]), .rpt(1), .is_ldb(0));
    send_new_pf(.pp_num(dqid[1]),  .qid(dqid[1]),  .rpt(1), .is_ldb(0));

    execute_cfg_cmds();
    fork
    poll_sch( .cq_num(lpp[0]),  .exp_cnt(1027), .is_ldb(1));
    poll_sch( .cq_num(lpp[1]),  .exp_cnt(1),    .is_ldb(1));
    poll_sch( .cq_num(lpp[hqm_pkg::NUM_LDB_CQ-2]), .exp_cnt(2),    .is_ldb(1));
    poll_sch( .cq_num(lpp[hqm_pkg::NUM_LDB_CQ-1]), .exp_cnt(3),    .is_ldb(1));
    poll_sch(.cq_num(dqid[0]),  .exp_cnt(1027), .is_ldb(0));
    poll_sch(.cq_num(dqid[1]),  .exp_cnt(1),    .is_ldb(0));
    poll_sch(.cq_num(dqid[hqm_pkg::NUM_DIR_CQ-2]), .exp_cnt(2),    .is_ldb(0));
    poll_sch(.cq_num(dqid[hqm_pkg::NUM_DIR_CQ-1]), .exp_cnt(3),    .is_ldb(0));
    join

    check_interrupt(.dir_cq(dqid[1]),.ldb_cq(lpp[1]));
    fork
    send_bat_t_pf( .pp_num(dqid[0]),  .tkn_cnt(0), .is_ldb(0));
    send_bat_t_pf( .pp_num(dqid[1]),  .tkn_cnt(0), .is_ldb(0));
    send_bat_t_pf( .pp_num(dqid[hqm_pkg::NUM_DIR_CQ-2]), .tkn_cnt(0), .is_ldb(0));
    send_bat_t_pf( .pp_num(dqid[hqm_pkg::NUM_DIR_CQ-1]), .tkn_cnt(0), .is_ldb(0));
    send_comp_t_pf( .pp_num(lpp[0]),   .rpt(1));
    send_comp_t_pf( .pp_num(lpp[1]),   .rpt(1));
    send_comp_t_pf( .pp_num(lpp[hqm_pkg::NUM_LDB_CQ-1]),  .rpt(1));
    send_comp_t_pf( .pp_num(lpp[hqm_pkg::NUM_LDB_CQ-2]),  .rpt(1));
    join
    fork 
      poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[0]),  'd1023, "credit_hist_pipe");  
      poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[hqm_pkg::NUM_DIR_CQ-1]), 'h0,    "credit_hist_pipe");  
      poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[hqm_pkg::NUM_DIR_CQ-2]), 'h0,    "credit_hist_pipe");  
      poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[1]),  'h0,    "credit_hist_pipe");  
      poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[0]),   'd1023, "credit_hist_pipe");  
      poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[1]),   'd0,    "credit_hist_pipe");  
      poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[hqm_pkg::NUM_LDB_CQ-2]),  'h0,    "credit_hist_pipe");  
      poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[hqm_pkg::NUM_LDB_CQ-1]),  'h0,    "credit_hist_pipe");  
    join 

    //iteration-5:dir/ldb_cq_int_enb to 0, check all armed reg is cleared, also clear old occ_int
    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Iteration-5 Start"), OVM_MEDIUM);
    write_reg("dir_cq_31_0_occ_int_status",   'hffffffff,  "hqm_system_csr");
    write_reg("dir_cq_63_32_occ_int_status",  'hffffffff, "hqm_system_csr");
    write_reg("ldb_cq_31_0_occ_int_status",   'hffffffff,  "hqm_system_csr");
    write_reg("ldb_cq_63_32_occ_int_status",  'hffffffff, "hqm_system_csr");
    for (int i=0;i<dir_cq_cnt;i++) begin
      write_reg($psprintf("cfg_dir_cq_int_enb[%0d]", i), 'h0, "credit_hist_pipe");  
    end
    for (int i=0;i<ldb_cq_cnt;i++) begin
      write_reg($psprintf("cfg_ldb_cq_int_enb[%0d]", i), 'h0, "credit_hist_pipe");  
    end
      //compare_reg("cfg_dir_cq_int_enb[hqm_pkg::NUM_DIR_CQ-1]",      'h0, rd_val, "credit_hist_pipe");  
      compare_reg($psprintf("cfg_dir_cq_int_enb[%0d]", (dir_cq_cnt-1)), 'h0, rd_val, "credit_hist_pipe");
    fork
      poll_reg($psprintf("cfg_dir_cq_intr_armed0"), 'h0,  "credit_hist_pipe");  
      poll_reg($psprintf("cfg_dir_cq_intr_armed1"), 'h0,  "credit_hist_pipe");  
      poll_reg($psprintf("cfg_ldb_cq_intr_armed0"), 'h0,  "credit_hist_pipe");  
      poll_reg($psprintf("cfg_ldb_cq_intr_armed1"), 'h0,  "credit_hist_pipe");  
    join
     
    //iteration-6 ,send in many K of hcws and expected no interrupt
    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Iteration-6 Start"), OVM_MEDIUM);
    for(int i=2;i<dir_cq_cnt-2;i++) begin 
        send_new_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(16), .is_ldb(0));
    end
        execute_cfg_cmds();
    for(int i=2;i<dir_cq_cnt-2;i++) begin 
      poll_sch(.cq_num(dqid[i]), .exp_cnt(16), .is_ldb(0));
    end 
  
    //ldb traffic
    for(int i=2;i<ldb_qid_cnt-2;i++) begin 
       write_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[i+32]), {"disabled"}, {" 'h1"}, "list_sel_pipe"); 
       compare_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[i+32]),  {"disabled"}, {" 'h1"}, rd_data_val , "list_sel_pipe"); 
    end  
    for(int i=2;i<ldb_qid_cnt-2;i++) begin 
       send_new_pf(.pp_num(lpp[i]),     .qid(lqid[i]), .rpt(16), .is_ldb(1));
       execute_cfg_cmds();
       poll_sch(.cq_num(lpp[i]),  .exp_cnt(16), .is_ldb(1));
    end  

    read_cq_occ(dir_cq_occ,ldb_cq_occ, dir_cq_armed,ldb_cq_armed);

    if(dir_cq_occ==0 && ldb_cq_occ==0) begin
      ovm_report_info(get_full_name(), $psprintf("No CIAL generated as expected"), OVM_MEDIUM);
    end else begin
      `ovm_error(get_full_name(), $psprintf("Unexpected dir/ldb cq_occ generated for dir_cq_index =0x%0x or ldb_cq_index =0x%0x  ",  dir_cq_occ, ldb_cq_occ))
    end
    for(int i=2;i<dir_cq_cnt-2;i++) begin 
      send_bat_t_pf( .pp_num(dqid[i]),  .tkn_cnt(15), .is_ldb(0));
    end
    for(int i=2;i<dir_cq_cnt-2;i++) begin 
      poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[i]), 'h0, "credit_hist_pipe");  
    end
    for(int i=2;i<ldb_qid_cnt-2;i++) begin 
      send_comp_t_pf( .pp_num(lpp[i]),  .rpt(16));
    end
    for(int i=2;i<ldb_qid_cnt-2;i++) begin 
      poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[i]), 'h0, "credit_hist_pipe");  
    end
 
    //iteration-7:send in hcws with ARM cmd to arm all cq expected result '0 
    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Iteration-7 Start"), OVM_MEDIUM);
    send_hcw_arm(.check_armed(0)); 

   //iteration-8:cfg write *_cq_int_enb[0] to *_cq_int_enb[63] 1
    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Iteration-8 Start"), OVM_MEDIUM);
    for (int i=0;i<dir_cq_cnt;i++) begin
        write_reg($psprintf("cfg_dir_cq_int_enb[%0d]", i), 'h2, "credit_hist_pipe");  
    end
    for (int i=0;i<ldb_cq_cnt;i++) begin
        write_reg($psprintf("cfg_ldb_cq_int_enb[%0d]", i), 'h2, "credit_hist_pipe");  
    end
      //compare_reg("cfg_dir_cq_int_enb[hqm_pkg::NUM_DIR_CQ-1]",'h2, rd_val,"credit_hist_pipe");  
      compare_reg($psprintf("cfg_dir_cq_int_enb[%0d]", (dir_cq_cnt-1)), 'h2, rd_val, "credit_hist_pipe");
    //wr armed reg to all 1's  
      wr_data=32'hFFFFFFFF;
      write_reg($psprintf("cfg_dir_cq_intr_armed0"), wr_data,  "credit_hist_pipe");  
      write_reg($psprintf("cfg_dir_cq_intr_armed1"), wr_data,  "credit_hist_pipe");  
      write_reg($psprintf("cfg_ldb_cq_intr_armed0"), wr_data,  "credit_hist_pipe");  
      write_reg($psprintf("cfg_ldb_cq_intr_armed1"), wr_data,  "credit_hist_pipe");  

      poll_reg($psprintf("cfg_dir_cq_intr_armed0"), wr_data,  "credit_hist_pipe");  
      poll_reg($psprintf("cfg_dir_cq_intr_armed1"), wr_data,  "credit_hist_pipe");  
      poll_reg($psprintf("cfg_ldb_cq_intr_armed0"), wr_data,  "credit_hist_pipe");  
      poll_reg($psprintf("cfg_ldb_cq_intr_armed1"), wr_data,  "credit_hist_pipe");  
    
      //return all token of cq0 -1023 
      send_bat_t_pf( .pp_num(dqid[0]), .tkn_cnt(1022), .is_ldb(0));
      send_comp_t_pf( .pp_num(lpp[0]),  .rpt(1023));
      poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[0]), 'h0, "credit_hist_pipe");  
      poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[0]),  'h0, "credit_hist_pipe");  
       
    
    //iteration-9: send in 64 dir hcws 1 going to each cq expected interrupt for cq 1 to cq 63, except cq0
    //           : send in 64 dir hcws 1 going to each cq expected interrupt for cq 1 to cq 63, except cq0
    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Iteration-9 Start"), OVM_MEDIUM);
    for(int i=0;i<dir_cq_cnt;i++) begin 
        send_new_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(1), .is_ldb(0));
    end
        execute_cfg_cmds();
    for(int i=0;i<dir_cq_cnt;i++) begin 
      if(i==0) begin
        poll_sch(.cq_num(dqid[i]), .exp_cnt(1028), .is_ldb(0));
      end
      else if(i==1) begin
        poll_sch(.cq_num(dqid[i]), .exp_cnt(2), .is_ldb(0));
      end
      else if(i==hqm_pkg::NUM_DIR_CQ-2) begin
        poll_sch(.cq_num(dqid[i]), .exp_cnt(3), .is_ldb(0));
      end
      else if(i==hqm_pkg::NUM_DIR_CQ-1) begin
        poll_sch(.cq_num(dqid[i]), .exp_cnt(4), .is_ldb(0));
      end
      else begin // if(dir_cq_cnt==1) begin
        poll_sch(.cq_num(dqid[i]), .exp_cnt(17), .is_ldb(0));
      end
    end //for dir_cq_cnt
  
    read_cq_occ(dir_cq_occ,ldb_cq_occ, dir_cq_armed,ldb_cq_armed);
    if (dir_cq_occ[dqid[0]]==0 && dir_cq_armed[dqid[0]]== 'h1 ) begin
        ovm_report_info(get_full_name(), $psprintf("occ_int not generated as exp for dir_cq=0x%0x", dqid[0]), OVM_MEDIUM);
    end else begin
      `ovm_error(get_full_name(), $psprintf("Unexpected dir/ldb cq_occ generated for dir_cq_index =0x%0x or ldb_cq_index =0x%0x  ",  dir_cq_occ, ldb_cq_occ))
    end    
    
    for(int i=0;i<dir_cq_cnt;i++) begin 
      send_bat_t_pf( .pp_num(dqid[i]),  .tkn_cnt(0), .is_ldb(0));
    end
    for(int i=0;i<dir_cq_cnt;i++) begin 
      poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[i]), 'h0, "credit_hist_pipe");  
    end
    
    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Complete"), OVM_MEDIUM);
endtask:cq_cial_check 


task hcw_cq_cial_depth_timer_int_rearm_seq::send_hcw_new(input int unsigned iteration=1);

      sla_ral_data_t        rd_data_val[$];
  ovm_report_info(get_full_name(), $psprintf("send_hcw_new:-- Start"), OVM_MEDIUM);

  for(int i=0;i<dir_cq_cnt;i++) begin 
     send_new_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(1), .is_ldb(0));
  end 
  execute_cfg_cmds();

  for(int i=0;i<ldb_qid_cnt;i++) begin 
     write_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[i+32]), {"disabled"}, {" 'h1"}, "list_sel_pipe"); 
     compare_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[i+32]),  {"disabled"}, {" 'h1"}, rd_data_val , "list_sel_pipe"); 
  end  
  for(int i=0;i<ldb_qid_cnt;i++) begin 
     send_new_pf(.pp_num(lpp[i]),     .qid(lqid[i]), .rpt(1), .is_ldb(1));
     execute_cfg_cmds();
     poll_sch(.cq_num(lpp[i]),  .exp_cnt(iteration), .is_ldb(1));
  end  
  for(int i=0;i<ldb_qid_cnt;i++) begin 
     write_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[i+32]), {"disabled"}, {" 'h0"}, "list_sel_pipe"); 
     write_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[i]), {"disabled"}, {" 'h1"}, "list_sel_pipe"); 
     compare_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[i+32]),  {"disabled"}, {" 'h0"}, rd_data_val,"list_sel_pipe"); 
     compare_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[i]),  {"disabled"}, {" 'h1"}, rd_data_val ,"list_sel_pipe"); 
  end
  for(int i=0;i<ldb_qid_cnt;i++) begin 
     send_new_pf(.pp_num(lpp[32+i]),  .qid(lqid[i]), .rpt(1), .is_ldb(1));
     execute_cfg_cmds();
     poll_sch(.cq_num(lpp[i+32]),  .exp_cnt(iteration), .is_ldb(1));
  end  
  for(int i=0;i<ldb_qid_cnt;i++) begin 
     write_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[i]), {"disabled"}, {" 'h0"}, "list_sel_pipe"); 
     compare_fields($psprintf("cfg_cq_ldb_disable[%0d]",lpp[i]),  {"disabled"}, {" 'h0"}, rd_data_val ,"list_sel_pipe"); 
  end
      
  for(int i=0;i<dir_cq_cnt;i++) begin 
    poll_sch(.cq_num(dqid[i]), .exp_cnt(iteration), .is_ldb(0));
  end 
  ovm_report_info(get_full_name(), $psprintf("send_hcw_new:-- completes"), OVM_MEDIUM);
endtask:send_hcw_new


task hcw_cq_cial_depth_timer_int_rearm_seq::send_hcw_arm(bit check_armed=1);

  ovm_report_info(get_full_name(), $psprintf("send_hcw_arm:-- Start"), OVM_MEDIUM);
    for(int i=0; i<dir_cq_cnt; i++) begin
        send_cmd_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(1), .is_ldb(0), .cmd(4'b0101));
        execute_cfg_cmds();
    end
    for(int i=0; i<ldb_cq_cnt; i++) begin
      if(i<32) begin
        send_cmd_pf(.pp_num(lpp[i]), .qid(lqid[i]), .rpt(1), .is_ldb(1), .cmd(4'b0101));
        execute_cfg_cmds();
      end else if (i >31) begin
        send_cmd_pf(.pp_num(lpp[i]), .qid(lqid[i%32]), .rpt(1), .is_ldb(1), .cmd(4'b0101));
        execute_cfg_cmds();
      end
    end
    for(int i=0; i<dir_cq_cnt; i++) begin
       dir_rd_val = dir_rd_val | (1<<dqid[i]);
    end
    for(int i=0; i<ldb_cq_cnt; i++) begin
       ldb_rd_val = ldb_rd_val | (1<<lpp[i]);
    end
   `ovm_info(get_full_name(), $psprintf("dir_rd_val=0x%0x, ldb_rd_val=0x%0x", dir_rd_val, ldb_rd_val),OVM_LOW)
    
    
 if(check_armed !=0)begin 
    fork  
     poll_reg($psprintf("cfg_dir_cq_intr_armed0"), dir_rd_val[31:0],  "credit_hist_pipe");  
     poll_reg($psprintf("cfg_dir_cq_intr_armed1"), dir_rd_val[63:32], "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_intr_armed0"), ldb_rd_val[31:0],  "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_intr_armed1"), ldb_rd_val[63:32], "credit_hist_pipe");  
    join 
 end else begin
    fork  
     poll_reg($psprintf("cfg_dir_cq_intr_armed0"), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_dir_cq_intr_armed1"), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_intr_armed0"), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_intr_armed1"), 'h0, "credit_hist_pipe");  
     wait_for_clk(5000);
    join 
 end     
  
  ovm_report_info(get_full_name(), $psprintf("send_hcw_arm:-- completes"), OVM_MEDIUM);
    
endtask: send_hcw_arm

task hcw_cq_cial_depth_timer_int_rearm_seq::check_interrupt(input bit [6:0] dir_cq, input bit [6:0] ldb_cq); 
      ovm_report_info(get_full_name(), $psprintf("check_interrupt: Start dir_cq=0x%0x ldb_cq=ex%0x",dir_cq, ldb_cq), OVM_MEDIUM);
    
 read_cq_occ(dir_cq_occ,ldb_cq_occ, dir_cq_armed,ldb_cq_armed);
    if(dir_cq_occ[dir_cq]!=1 && dir_cq_armed[dir_cq] !=0 ) begin
      `ovm_error(get_full_name(), $psprintf("dir cq_occ not generated for dir_cq[%0d]=0x%0x or cq not armed for dir_cq[%0d]=0x%0x  ", dir_cq, dir_cq_occ[dir_cq], dir_cq, dir_cq_armed[dir_cq]))
    end  
    else begin
      ovm_report_info(get_full_name(), $psprintf("Received expected cq_occ and armed"), OVM_MEDIUM);
    end

    if(ldb_cq_occ[ldb_cq]!=1 && ldb_cq_armed[ldb_cq] !=0 ) begin
      `ovm_error(get_full_name(), $psprintf("ldb cq_occ not generated for ldb_cq[%0d]=0x%0x or cq not armed for ldb_cq[%0d]=0x%0x  ", ldb_cq, ldb_cq_occ[ldb_cq], ldb_cq, ldb_cq_armed[ldb_cq]))
    end  
    else begin
      ovm_report_info(get_full_name(), $psprintf("Received expected cq_occ and armed"), OVM_MEDIUM);
    end
      ovm_report_info(get_full_name(), $psprintf("check_interrupt: Complete"), OVM_MEDIUM);


endtask: check_interrupt
`endif //HCW_CQ_CIAL_DEPTH_TIMER_INT_REARM_SEQ__SV
