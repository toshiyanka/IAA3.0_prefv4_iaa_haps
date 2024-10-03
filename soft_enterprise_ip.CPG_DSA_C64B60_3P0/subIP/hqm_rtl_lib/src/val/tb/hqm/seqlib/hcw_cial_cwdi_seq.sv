`ifndef HCW_CIAL_CWDI_SEQ__SV
`define HCW_CIAL_CWDI_SEQ__SV

//  


class hcw_cial_cwdi_seq extends hcw_cq_threshold_0_seq;

  `ovm_sequence_utils(hcw_cial_cwdi_seq, sla_sequencer)

      ovm_event_pool        glbl_pool;
      ovm_event             exp_msix_0;
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
      bit [31:0]            data;
      extern task           body();
      extern task           cq_cial_cwdi_check();
      extern task           send_hcw_cmd(input int unsigned iteration =1);
      extern task           check_cq_occ_int();
      extern task           cwdi_config_and_checks(bit is_ldb);

    function new(string name = "hcw_cial_cwdi_seq");
      super.new(name);
      glbl_pool  = ovm_event_pool::get_global_pool();
      exp_msix_0 = glbl_pool.get("hqm_exp_ep_msix_0");
    endfunction

endclass: hcw_cial_cwdi_seq

    task hcw_cial_cwdi_seq::body();
      ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);
      get_hqm_cfg();
     get_hqm_pp_cq_status();
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
        tot_cq_cnt = 8'd12; 
      end
      if($value$plusargs("TIMEOUT_VAL=%d", timeout_val)) begin
       this.timeout_val= timeout_val;
      end else begin 
        timeout_val= 10000; // 8'd12;
      end
     `ovm_info(get_full_name(), $psprintf("TOT_CQ_CNT= %0d, TIMEOUT_VAL=%0d ", tot_cq_cnt,timeout_val),OVM_LOW)
      count=0;
      wait_for_clk(10);
      cq_cial_cwdi_check();
  endtask: body

//=======================================================//
//1. Send NEW cmd to DIR/LDB PP , wait for scheduling
//2. Check cq_occ and armed cleared, MSIX Received
//3. return token for all cq's except for 1 cq
//4. wait for watchdog int cq-wdi and MSIX
//5. return token
//=======================================================//

task hcw_cial_cwdi_seq::cq_cial_cwdi_check();

    ovm_report_info(get_full_name(), $psprintf("cq_cial_cwdi_check:-- Start"), OVM_MEDIUM);

    send_hcw_cmd(.iteration(1));
    check_cq_occ_int();
    ovm_report_info(get_full_name(), $psprintf("Wait for MSIX0:-- Start "), OVM_MEDIUM);
    i_hqm_pp_cq_status.wait_for_msix_int(0, data); // MISx entry index
    exp_msix_0.trigger();
    ovm_report_info(get_full_name(), $psprintf("Wait for MSIX0:-- Complete"), OVM_MEDIUM);
    //check watchdog int generated for all CQ's   
    cwdi_config_and_checks(.is_ldb(1));
    cwdi_config_and_checks(.is_ldb(0));
    compare_reg("alarm_hw_synd", 'hC000_0800, rd_val, "hqm_system_csr");
    write_reg("alarm_hw_synd", 'hC000_0800, "hqm_system_csr");
    compare_reg("alarm_hw_synd", 'h0000_0800, rd_val, "hqm_system_csr");
    //Token and completion return 
    for(int j=0;j<tot_cq_cnt;j++) begin 
       send_bat_t_pf(.pp_num(dqid[j]), .tkn_cnt(cq_depth_val-1), .is_ldb(0));
       send_comp_t_pf(.pp_num(lpp[j]), .rpt(cq_depth_val));
    end
endtask:cq_cial_cwdi_check 



task hcw_cial_cwdi_seq::send_hcw_cmd(input int unsigned iteration =1);

  ovm_report_info(get_full_name(), $psprintf("send_hcw_cmd:-- Start Iteration =%0d", iteration), OVM_MEDIUM);
  for(int i=0;i<tot_cq_cnt;i++) begin 
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
  for(int i=0;i<tot_cq_cnt;i++) begin 
      poll_sch(.cq_num(dqid[i]), .exp_cnt(cq_depth_val*(iteration)), .is_ldb(0));
      poll_sch(.cq_num(lpp[i]),  .exp_cnt(cq_depth_val*(iteration)), .is_ldb(1));
  end 
  ovm_report_info(get_full_name(), $psprintf("send_hcw_cmd:-- completes"), OVM_MEDIUM);
endtask:send_hcw_cmd


task hcw_cial_cwdi_seq::check_cq_occ_int();

  ovm_report_info(get_full_name(), $psprintf("check_cq_occ_int:-- Start"), OVM_MEDIUM);
   read_cq_occ(dir_cq_occ,ldb_cq_occ, dir_cq_armed,ldb_cq_armed);
   for (int i=0;i<tot_cq_cnt;i++) begin 
      check_cq_occ(.check_cq(dir_cq_occ[dqid[i]]));
      check_cq_occ(.check_cq(ldb_cq_occ[lpp[i]]));
      check_armed(.check_cq_armed(dir_cq_armed[dqid[i]]));
      check_armed(.check_cq_armed(ldb_cq_armed[lpp[i]]));
   end 
  ovm_report_info(get_full_name(), $psprintf("check_cq_occ_int:-- Completes"), OVM_MEDIUM);
       
endtask: check_cq_occ_int 

task hcw_cial_cwdi_seq::cwdi_config_and_checks(bit is_ldb);

    bit [hqm_pkg::NUM_DIR_CQ-1:0]     exp_reg_val = 'h0;
    string         pp_cq_prefix;
    
  ovm_report_info(get_full_name(), $psprintf("cwdi_config_and_checks:-- Start"), OVM_MEDIUM);
   
    for(int i=0;i<tot_cq_cnt;i++) begin 
     if (is_ldb) begin exp_reg_val =  exp_reg_val | (64'h1 << lpp[i]);  end
     else        begin exp_reg_val =  exp_reg_val | (64'h1 << dqid[i]); end
    end
    ovm_report_info(get_full_name(), $psprintf("cwdi_config_and_checks:-- is_ldb=%0b exp_reg_val=0x%0x",is_ldb, exp_reg_val), OVM_MEDIUM);

    if (is_ldb)
        pp_cq_prefix = "LDB";
    else
        pp_cq_prefix = "DIR";

    poll_reg($psprintf("cfg_%0s_wdto_0", pp_cq_prefix), exp_reg_val[31:0], "credit_hist_pipe");
    poll_reg($psprintf("cfg_%0s_wdto_1", pp_cq_prefix), exp_reg_val[63:32], "credit_hist_pipe");

    write_reg($psprintf("cfg_%0s_wdto_0", pp_cq_prefix), exp_reg_val[31:0], "credit_hist_pipe");
    write_reg($psprintf("cfg_%0s_wdto_1", pp_cq_prefix), exp_reg_val[63:32], "credit_hist_pipe");
    compare_reg($psprintf("cfg_%0s_wdto_0", pp_cq_prefix), 0, rd_val, "credit_hist_pipe");
    compare_reg($psprintf("cfg_%0s_wdto_1", pp_cq_prefix), 0, rd_val, "credit_hist_pipe");
    ovm_report_info(get_full_name(), $psprintf("cwdi_config_and_checks:-- Completes"), OVM_MEDIUM);
endtask: cwdi_config_and_checks

`endif //HCW_CIAL_CWDI_SEQ__SV

