`ifndef HCW_CQ_CIAL_TIMER_RESET_CHECK_SEQ__SV
`define HCW_CQ_CIAL_TIMER_RESET_CHECK_SEQ__SV

//  


class hcw_cq_cial_timer_reset_check_seq extends hcw_cq_threshold_0_seq;

  `ovm_sequence_utils(hcw_cq_cial_timer_reset_check_seq, sla_sequencer)

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
      bit [hqm_pkg::NUM_DIR_CQ-1:0]            dir_rd_val;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]            ldb_rd_val;
      bit [10:0]            cq_depth_val;
      bit [10:0]            enq_cnt_val;
      bit [12:0]            cq_intr_depth_thrsh_val;
      bit [7:0]             tot_cq_cnt;
      bit [31:0]            dir_cq_timer_cnt[];
      bit [31:0]            ldb_cq_timer_cnt[];
      bit [31:0]            ref_dir_cq_timer_cnt[];
      bit [31:0]            ref_ldb_cq_timer_cnt[];
      int unsigned          count;
      int unsigned          iteration;
      int unsigned          int_depth_thrs;
      int unsigned          timeout_val;
      extern task           body();
      extern task           cq_cial_timer_reset_check();
      extern task           send_hcw_cmd(input int unsigned iteration =1, input bit [10:0] enq_cnt_val);
      extern task           cq_run_timer_read();
      extern task           cq_timer_count_read(input bit exp_run_cnt_rst=0 );

    function new(string name = "hcw_cq_cial_timer_reset_check_seq");
      super.new(name);
    endfunction

endclass: hcw_cq_cial_timer_reset_check_seq

    task hcw_cq_cial_timer_reset_check_seq::body();
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

      cq_depth_val = i_hqm_cfg.get_cq_depth(0,dqid[0]);
     `ovm_info(get_full_name(), $psprintf("CQ_DEPTH = %0d", cq_depth_val),OVM_LOW)
      if($value$plusargs("TOT_CQ_CNT=%d", tot_cq_cnt)) begin
        this.tot_cq_cnt = tot_cq_cnt;
      end  else begin 
        tot_cq_cnt = 8'd2; 
      end
      if($value$plusargs("TIMEOUT_VAL=%d", timeout_val)) begin
       this.timeout_val= timeout_val;
      end else begin 
        timeout_val= 10000; // 8'd12;
      end
     `ovm_info(get_full_name(), $psprintf("TOT_CQ_CNT= %0d, TIMEOUT_VAL=%0d ", tot_cq_cnt,timeout_val),OVM_LOW)
      count=0;
      wait_for_clk(10);
      cq_cial_timer_reset_check();
  endtask: body

//=======================================================//
//1. Timer interrupt enabled,  
//2. when cq_depth>0, timer started
//3. return token when run timer started 
//4. check run_timer reset
//5. enqueue HCW dont return token till timer expired
//   check cq_occ generated and armed as expected
//=======================================================//

task hcw_cq_cial_timer_reset_check_seq::cq_cial_timer_reset_check();

    ovm_report_info(get_full_name(), $psprintf("cq_cial_timer_reset_check:-- Start"), OVM_MEDIUM);

    send_hcw_cmd(.iteration(1),.enq_cnt_val(2));
    cq_run_timer_read();
    for(int i=0;i<tot_cq_cnt;i++) begin 
      `ovm_info(get_full_name(), $psprintf("i_tot_cq_cnt:=%0d", i),OVM_DEBUG)
       send_bat_t_pf( .pp_num(dqid[i]), .tkn_cnt(0), .is_ldb(0));
       send_comp_t_pf(.pp_num(lpp[i]),  .rpt(1));
    end 
    for(int i=0;i<tot_cq_cnt;i++) begin 
       poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[i]), 'h1, "credit_hist_pipe");  
       poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[i]), 'h1, "credit_hist_pipe");  
    end
    cq_timer_count_read(.exp_run_cnt_rst(0));
    //now return one token reset is expected  
    for(int i=0;i<tot_cq_cnt;i++) begin 
      `ovm_info(get_full_name(), $psprintf("i_tot_cq_cnt:=%0d", i),OVM_DEBUG)
       send_bat_t_pf( .pp_num(dqid[i]), .tkn_cnt(0), .is_ldb(0));
       send_comp_t_pf(.pp_num(lpp[i]),  .rpt(1));
    end 
    for(int i=0;i<tot_cq_cnt;i++) begin 
       poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[i]), 'h0, "credit_hist_pipe");  
       poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[i]), 'h0, "credit_hist_pipe");  
    end
    cq_timer_count_read(.exp_run_cnt_rst(1));

    ovm_report_info(get_full_name(), $psprintf("cq_cial_timer_reset_check:-- Complete"), OVM_MEDIUM);
endtask:cq_cial_timer_reset_check 


task hcw_cq_cial_timer_reset_check_seq::send_hcw_cmd(input int unsigned iteration =1, input bit [10:0] enq_cnt_val);

  ovm_report_info(get_full_name(), $psprintf("send_hcw_cmd:-- Start Iteration =%0d Enqueue_cnt_val=%0d", iteration, enq_cnt_val), OVM_MEDIUM);
  for(int i=0;i<tot_cq_cnt;i++) begin 
      if(i_hqm_cfg.is_pf_mode()) begin
        send_new_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(enq_cnt_val), .is_ldb(0));
        send_new_pf(.pp_num(lpp[i]),  .qid(lqid[i]), .rpt(enq_cnt_val), .is_ldb(1));
      end
      else if(i_hqm_cfg.is_sciov_mode()) begin
        send_cmd_pf(.pp_num(dqid[i]), .qid((hqm_pkg::NUM_DIR_CQ-tot_cq_cnt)+i), .rpt(enq_cnt_val), .is_ldb(0), .cmd(4'b1000));
        send_cmd_pf(.pp_num(lpp[i]),  .qid((hqm_pkg::NUM_LDB_QID-tot_cq_cnt)+i), .rpt(enq_cnt_val), .is_ldb(1), .cmd(4'b1000));
      end  
      else if(i_hqm_cfg.is_sriov_mode) begin 
        send_new(.vf_num(vf[0]), .pp_num(0), .qid(0), .rpt(enq_cnt_val), .is_ldb(0));
        send_new(.vf_num(vf[1]), .pp_num(1), .qid(1), .rpt(enq_cnt_val), .is_ldb(1));
      end
  end 
  execute_cfg_cmds();
  for(int i=0;i<tot_cq_cnt;i++) begin 
      poll_sch(.cq_num(dqid[i]), .exp_cnt(enq_cnt_val*(iteration)), .is_ldb(0));
      poll_sch(.cq_num(lpp[i]),  .exp_cnt(enq_cnt_val*(iteration)), .is_ldb(1));
  end 
  ovm_report_info(get_full_name(), $psprintf("send_hcw_cmd:-- completes"), OVM_MEDIUM);
endtask:send_hcw_cmd


task hcw_cq_cial_timer_reset_check_seq::cq_run_timer_read();
     ovm_report_info(get_full_name(), $psprintf("cq_run_timer_read:-- Start"), OVM_MEDIUM);
     ref_dir_cq_timer_cnt = new[tot_cq_cnt];
     ref_ldb_cq_timer_cnt = new[tot_cq_cnt];
     read_reg("cfg_dir_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     dir_rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     dir_rd_val[63:32] = rd_data;
     read_reg("cfg_ldb_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     ldb_rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     ldb_rd_val[63:32] = rd_data;
     

    for(int i=0;i<tot_cq_cnt;i++) begin 
       read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[i]), ref_dir_cq_timer_cnt[i], "credit_hist_pipe");  
       read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[i]),  ref_ldb_cq_timer_cnt[i], "credit_hist_pipe");  
    end

    for (int i=0;i<tot_cq_cnt;i++) begin 
       if(dir_rd_val[dqid[i]] && ldb_rd_val[lpp[i]]) begin
        `ovm_info(get_full_name(), $psprintf("cq_run_timer_read:run timer started as expected for dir_cq[%0d]=0x%0x & ldb_cq[%0d]=0x%0x", dqid[i],dir_rd_val[dqid[i]], lpp[i],ldb_rd_val[lpp[i]]),OVM_DEBUG)
       end else begin
        `ovm_error(get_full_name(), $psprintf("cq_run_timer_read:run timer not started for dir_cq[%0d]=0x%0x and/or ldb_cq[%0d]=0x%0x", dqid[i],dir_rd_val[dqid[i]], lpp[i],ldb_rd_val[lpp[i]]))
       end
    end
     ovm_report_info(get_full_name(), $psprintf("cq_run_timer_read:-- Complete"), OVM_MEDIUM);
endtask: cq_run_timer_read 

task hcw_cq_cial_timer_reset_check_seq::cq_timer_count_read(input bit exp_run_cnt_rst=0 );
   ovm_report_info(get_full_name(), $psprintf("cq_timer_count_read:-- Start exp_run_cnt_rst=%0b", exp_run_cnt_rst), OVM_MEDIUM);
    dir_cq_timer_cnt = new[tot_cq_cnt];
    ldb_cq_timer_cnt = new[tot_cq_cnt];
   
    for(int i=0;i<tot_cq_cnt;i++) begin 
       read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[i]), dir_cq_timer_cnt[i], "credit_hist_pipe");  
       read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[i]),  ldb_cq_timer_cnt[i], "credit_hist_pipe");  
       if (exp_run_cnt_rst==1) begin
          if((ldb_cq_timer_cnt[i]==0 && dir_cq_timer_cnt[i]==0)) begin //PASS
            `ovm_info(get_full_name(), $psprintf("cq_timer_count_read:run timer reset as expected for dir_cq[%0d]=0x%0x and ldb_cq[%0d]=0x%0x", dqid[i], dir_cq_timer_cnt[i], lpp[i],ldb_cq_timer_cnt[i]),OVM_DEBUG)
          end else begin
             `ovm_error(get_full_name(), $psprintf("cq_timer_count_read:run timer not reset post all token return for dir_cq=%0d, ref_timer=0x%0x, cur_timer=0x%0x ,ldb_cq=%0d, ref_timer=0x%0x, cur_timer=0x%0x ", dqid[i],ref_dir_cq_timer_cnt[i], dir_cq_timer_cnt[i], lpp[i],ldb_cq_timer_cnt[i],ldb_cq_timer_cnt[i]))
          end
       end //exp_run_cnt_rst=1
      //exp_run_cnt_rst=0-> cq_dpeth>0 so run counter restart again 
       else if(exp_run_cnt_rst==0) begin
          if ((ldb_cq_timer_cnt[i] <= ref_ldb_cq_timer_cnt[i] && dir_cq_timer_cnt[i]<=ref_dir_cq_timer_cnt[i])) begin //PASS
             `ovm_info(get_full_name(), $psprintf("cq_timer_count_read:run timer reset and started again as expected for dir_cq[%0d]=0x%0x and ldb_cq[%0d]=0x%0x", dqid[i], dir_cq_timer_cnt[i], lpp[i],ldb_cq_timer_cnt[i]),OVM_DEBUG)
          end 
          else begin 
             `ovm_error(get_full_name(), $psprintf("cq_timer_count_read:run timer not restart post 1 token return , cq_depth>0 and start: dir_cq=%0d, ref_timer=0x%0x, cur_timer=0x%0x ,ldb_cq=%0d, ref_timer=0x%0x, cur_timer=0x%0x ", dqid[i],ref_dir_cq_timer_cnt[i], dir_cq_timer_cnt[i], lpp[i],ldb_cq_timer_cnt[i],ldb_cq_timer_cnt[i]))
          end  
        end //(exp_run_cnt_rst==0)
        else begin //when exp_run_cnt_rst neither 0/1
          `ovm_error(get_full_name(), $psprintf("cq_timer_count_read:unexpected exp_run_cnt_rst value=%0d", exp_run_cnt_rst ))
       end
    end  //for loop

   ovm_report_info(get_full_name(), $psprintf("cq_timer_count_read:-- Complete"), OVM_MEDIUM);
endtask: cq_timer_count_read


`endif //HCW_CQ_CIAL_TIMER_RESET_CHECK_SEQ__SV
