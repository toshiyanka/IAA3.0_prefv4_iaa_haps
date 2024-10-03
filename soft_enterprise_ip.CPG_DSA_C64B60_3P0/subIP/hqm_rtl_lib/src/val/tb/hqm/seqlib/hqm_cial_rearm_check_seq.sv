`ifndef HQM_CIAL_REARM_CHECK_SEQ__SV
`define HQM_CIAL_REARM_CHECK_SEQ__SV

// This test validates that rearming via Cfg {ldb,dir} Cq Intr Armed* has correct behavior.
// test MUST not use the enqueue rearm mechanism (cmd=0101). All CIAL interrupts are rearmed by CFG write


class hqm_cial_rearm_check_seq extends hcw_cq_threshold_0_seq;

  `ovm_sequence_utils(hqm_cial_rearm_check_seq, sla_sequencer)

      ovm_event_pool        glbl_pool;
      ovm_event             exp_msix;
      ovm_object            o_tmp;
      sla_ral_addr_t        addr;
      sla_ral_reg           reg_h;
      sla_ral_data_t        rd_data;
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
      bit [10:0]            cq_depth_val;
      bit [12:0]            cq_intr_depth_thrsh_val;
      bit [7:0]             tot_cq_cnt;
      int unsigned          count;
      int unsigned          rpt_cnt,iteration;
      int unsigned          int_depth_thrs;
      int unsigned          timeout_val;
      extern task           body();
      extern task           cq_cial_int_rearm_check();
      extern task           send_hcw_no_cq_occ_int_exp(input int unsigned cur_iteration_cnt);

    function new(string name = "hqm_cial_rearm_check_seq");
      super.new(name);
    endfunction

endclass: hqm_cial_rearm_check_seq

    task hqm_cial_rearm_check_seq::body();
      ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);
      get_hqm_cfg();
      // -- get the DIR/PP QID Number
      for (int i=0;i<12;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("DQID%0d",i),dqid[i])) begin
          `ovm_info(get_full_name(), $psprintf("Logical DIR PP %0d maps to physical PP %0d",i,dqid[i]),OVM_DEBUG)
        end else begin
         `ovm_error(get_full_name(), $psprintf("DQID%0d name not found in hqm_cfg",i))
        end
      end //:dir_qid_num 
     // -- get the LDB QID Number
     for (int i=0;i<12;i++) begin //:ldb_qid num
       if (i_hqm_cfg.get_name_val($psprintf("LQID%0d",i),lqid[i])) begin
         `ovm_info(get_full_name(), $psprintf("Logical LDB QID %0d maps to physical QID %0d",i,lqid[i]),OVM_DEBUG)
       end else begin
        `ovm_error(get_full_name(), $psprintf("LQID%0d name not found in hqm_cfg",i))
       end
     end //:ldb qid_num 
     // -- get the LDB PP Number
     for (int i=0;i<12;i++) begin //:ldb_pp num
       if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",i),lpp[i])) begin
         `ovm_info(get_full_name(), $psprintf("Logical LDB PP %0d maps to physical PP %0d",i,lpp[i]),OVM_DEBUG)
       end else begin
        `ovm_error(get_full_name(), $psprintf("LPP%0d name not found in hqm_cfg",i))
       end
     end //:ldb pp_num 
     // -- get the VDEV number 
     if(i_hqm_cfg.is_sciov_mode()) begin
     for (int i=0;i<1 ;i++) begin //:vdev num
       if (i_hqm_cfg.get_name_val($psprintf("VDEV%0d",i),vdev[i])) begin
         `ovm_info(get_full_name(), $psprintf("Logical VDEV %0d maps to physical VDEV %0d",i,vdev[i]),OVM_DEBUG)
       end else begin
         `ovm_info(get_full_name(), $psprintf("VDEV%0d name not found in hqm_cfg",i),OVM_LOW)
       end
     end //get_vdev_num
     end //is_sciov_mode 
     // -- get the VF number  
     if(i_hqm_cfg.is_sriov_mode()) begin
     for (int i=0;i<1 ;i++) begin //get_vf num
       if (i_hqm_cfg.get_name_val($psprintf("VF%0d",i),vf[i])) begin
         `ovm_info(get_full_name(), $psprintf("Logical VF %0d maps to physical VF %0d",i,vf[i]),OVM_DEBUG)
       end else begin
         `ovm_error(get_full_name(), $psprintf("VF%0d name not found in hqm_cfg",i))
       end
     end //get_vf
     end //sriov_mode

     //get cq depth for token return loop
      cq_depth_val = i_hqm_cfg.get_cq_depth(0,dqid[0]);
     `ovm_info(get_full_name(), $psprintf("CQ_DEPTH = %0d", cq_depth_val),OVM_LOW)
      if($value$plusargs("TOT_CQ_CNT=%d", tot_cq_cnt)) begin
        this.tot_cq_cnt = tot_cq_cnt;
      end  else begin 
        tot_cq_cnt = 8'd12; 
      end
      if($value$plusargs("TIMEOUT_VAL=%d", timeout_val)) begin
       this.timeout_val= timeout_val;
      end else begin 
        timeout_val= 10000; // 8'd12;
      end
     `ovm_info(get_full_name(), $psprintf("TOT_CQ_CNT= %0d, TIMEOUT_VAL=%0d ", tot_cq_cnt,timeout_val),OVM_LOW)
      count=0;
      rpt_cnt=0;
      wait_for_clk(10);
      cq_cial_int_rearm_check();
      wait_for_clk(100);
  endtask: body

//=======================================================//
//1. Send threshold QE into HQM,observe they are scheduled
//   and cause an occupancy interrupt. 
//2. Pop all items out of CQ.
//3. Rearm CQ Via CFG write.
//4. repeat #1 to #3 for 16 times
//=============================================//

task hqm_cial_rearm_check_seq::cq_cial_int_rearm_check();
  for (iteration=1; iteration<=16;iteration++) begin
    //#1 enq,poll_sch & cq_occ check
    for (int i=0;i<tot_cq_cnt;i++) begin 
      if(i_hqm_cfg.is_pf_mode()) begin
        send_new_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(cq_depth_val), .is_ldb(0));
        send_new_pf(.pp_num(lpp[i]),  .qid(lqid[i]), .rpt(cq_depth_val), .is_ldb(1));
      end
      else if(i_hqm_cfg.is_sciov_mode()) begin
        send_cmd_pf(.pp_num(dqid[i]), .qid((hqm_pkg::NUM_DIR_CQ-tot_cq_cnt)+i), .rpt(cq_depth_val), .is_ldb(0), .cmd(4'b1000));
        send_cmd_pf(.pp_num(lpp[i]),  .qid((hqm_pkg::NUM_LDB_QID-tot_cq_cnt)+i), .rpt(cq_depth_val), .is_ldb(1), .cmd(4'b1000));
      end  
      else if(i_hqm_cfg.is_sriov_mode) begin 
        send_new(.vf_num(vf[0]), .pp_num(0), .qid(0), .rpt(cq_depth_val), .is_ldb(0));
        send_new(.vf_num(vf[1]), .pp_num(1), .qid(1), .rpt(cq_depth_val), .is_ldb(1));
      end
    end 
    execute_cfg_cmds();
    for (int i=0;i<tot_cq_cnt;i++) begin 
        poll_sch(.cq_num(dqid[i]), .exp_cnt(cq_depth_val*(iteration+rpt_cnt)), .is_ldb(0), .delay(10), .timeout(timeout_val)); 
        poll_sch(.cq_num(lpp[i]),  .exp_cnt(cq_depth_val*(iteration+rpt_cnt)), .is_ldb(1), .delay(10), .timeout(timeout_val)); 
    end 
    //check for occ interrupt & return token/comp
    //-for (int i=0;i<cq_depth_val;i++) begin 
       read_cq_occ(dir_cq_occ,ldb_cq_occ, dir_cq_armed,ldb_cq_armed);
       for (int i=0;i<tot_cq_cnt;i++) begin 
          check_cq_occ(.check_cq(dir_cq_occ[dqid[i]]));
          check_cq_occ(.check_cq(ldb_cq_occ[lpp[i]]));
          check_armed(.check_cq_armed(dir_cq_armed[dqid[i]]));
          check_armed(.check_cq_armed(ldb_cq_armed[lpp[i]]));
       end 
    //-end     
    //#2 token return
    for(int i=0;i<tot_cq_cnt;i++) begin 
      `ovm_info(get_full_name(), $psprintf("i_tot_cq_cnt:=%0d", i),OVM_DEBUG)
       send_bat_t_pf( .pp_num(dqid[i]), .tkn_cnt(cq_depth_val-1), .is_ldb(0));
       send_comp_t_pf(.pp_num(lpp[i]),  .rpt(cq_depth_val));
    end 
    clear_cq_occ();  //TODO should we clear or not 
    //#2-send hcw and check no_cq_occ received
    if($test$plusargs("check_with_no_cq_occ_int")) begin
      send_hcw_no_cq_occ_int_exp(iteration);
    end
    //#3 configure armed reg 
     write_reg("cfg_dir_cq_intr_armed0", '1,        "credit_hist_pipe");
     write_reg("cfg_dir_cq_intr_armed1", '1,        "credit_hist_pipe");
     write_reg("cfg_ldb_cq_intr_armed0", '1,        "credit_hist_pipe");
     write_reg("cfg_ldb_cq_intr_armed1", '1,        "credit_hist_pipe");
     read_reg("cfg_ldb_cq_intr_armed1",  rd_data,   "credit_hist_pipe");
  end // iteration

endtask:cq_cial_int_rearm_check 


// send hcw-? poll_sch-> check no_cq_occ int
task hqm_cial_rearm_check_seq::send_hcw_no_cq_occ_int_exp(input int unsigned cur_iteration_cnt);

      `ovm_info(get_full_name(), $psprintf("send_hcw_no_cq_occ_int_exp:i_iteration_cnt:=%0d --Start", cur_iteration_cnt),OVM_LOW)
    for (int i=0;i<tot_cq_cnt;i++) begin 
      if(i_hqm_cfg.is_pf_mode()) begin
        send_new_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(cq_depth_val), .is_ldb(0));
        send_new_pf(.pp_num(lpp[i]),  .qid(lqid[i]), .rpt(cq_depth_val), .is_ldb(1));
      end
      else if(i_hqm_cfg.is_sciov_mode()) begin
        send_cmd_pf(.pp_num(dqid[i]), .qid((hqm_pkg::NUM_DIR_CQ-tot_cq_cnt)+i), .rpt(cq_depth_val), .is_ldb(0), .cmd(4'b1000));
        send_cmd_pf(.pp_num(lpp[i]),  .qid((hqm_pkg::NUM_LDB_QID-tot_cq_cnt)+i), .rpt(cq_depth_val), .is_ldb(1), .cmd(4'b1000));
      end  
      else if(i_hqm_cfg.is_sriov_mode) begin 
        send_new(.vf_num(vf[0]), .pp_num(0), .qid(0), .rpt(cq_depth_val), .is_ldb(0));
        send_new(.vf_num(vf[1]), .pp_num(1), .qid(1), .rpt(cq_depth_val), .is_ldb(1));
      end
    end //for tot_cq_cnt
    execute_cfg_cmds();
    for (int i=0;i<tot_cq_cnt;i++) begin 
        poll_sch(.cq_num(dqid[i]), .exp_cnt(cq_depth_val*2*cur_iteration_cnt), .is_ldb(0), .delay(10), .timeout(timeout_val)); 
        poll_sch(.cq_num(lpp[i]),  .exp_cnt(cq_depth_val*2*cur_iteration_cnt), .is_ldb(1), .delay(10), .timeout(timeout_val)); 
    end //for 
    //check for occ interrupt & return token/comp
    read_cq_occ(dir_cq_occ,ldb_cq_occ, dir_cq_armed,ldb_cq_armed);
    if ((|dir_cq_occ) || (|ldb_cq_occ)) begin //no-bit should be set
       `ovm_error(get_full_name(), $psprintf("send_hcw_no_cq_occ_int_exp:Unexpected CQ-Interrupt generated for dir_cq=0x%0x or ldb_cq", dir_cq_occ, ldb_cq_occ))
    end else begin
      `ovm_info(get_full_name(), $psprintf("send_hcw_no_cq_occ_int_exp:CQ-OCC_INT not generated as expected for dir_cq=0x%0x and ldb_cq=0x%0x",dir_cq_occ, ldb_cq_occ),OVM_DEBUG)
    end

    write_reg("cfg_dir_cq_intr_armed0", '1,        "credit_hist_pipe");
    write_reg("cfg_dir_cq_intr_armed1", '1,        "credit_hist_pipe");
    write_reg("cfg_ldb_cq_intr_armed0", '1,        "credit_hist_pipe");
    write_reg("cfg_ldb_cq_intr_armed1", '1,        "credit_hist_pipe");
    read_reg("cfg_ldb_cq_intr_armed1",  rd_data,   "credit_hist_pipe");
   `ovm_info(get_full_name(), $psprintf("send_hcw_no_cq_occ_int_exp: cfg-arm set"),OVM_DEBUG)
    read_cq_occ(dir_cq_occ,ldb_cq_occ, dir_cq_armed,ldb_cq_armed);
    for (int i=0;i<tot_cq_cnt;i++) begin 
      check_cq_occ(.check_cq(dir_cq_occ[dqid[i]]));
      check_cq_occ(.check_cq(ldb_cq_occ[lpp[i]]));
      check_armed(.check_cq_armed(dir_cq_armed[dqid[i]]));
      check_armed(.check_cq_armed(ldb_cq_armed[lpp[i]]));
    end 
    //token return
    for(int i=0;i<tot_cq_cnt;i++) begin 
      `ovm_info(get_full_name(), $psprintf("send_hcw_no_cq_occ_int_exp:i_tot_cq_cnt:=%0d", i),OVM_DEBUG)
       send_bat_t_pf( .pp_num(dqid[i]), .tkn_cnt(cq_depth_val-1), .is_ldb(0));
       send_comp_t_pf(.pp_num(lpp[i]),  .rpt(cq_depth_val));
    end 

    rpt_cnt++;
endtask:send_hcw_no_cq_occ_int_exp




`endif //HQM_CIAL_REARM_CHECK_SEQ__SV
