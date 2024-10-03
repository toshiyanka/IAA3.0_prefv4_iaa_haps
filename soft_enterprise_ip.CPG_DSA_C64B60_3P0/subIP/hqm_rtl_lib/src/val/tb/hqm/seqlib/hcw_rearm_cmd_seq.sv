`ifndef HCW_REARM_CMD_SEQ__SV
`define HCW_REARM_CMD_SEQ__SV

//==========================================================//
// dir_cq_threshold_pf : cq-> 0,2 
// dir_cq_timer_pf     : cq-> 1,3
// dir_cq_threshold_vf : cq-> 4,6 
// dir_cq_timer_vf     : cq-> 5,7
// ldb_cq_threshold_pf : cq-> 0,3
// ldb_cq_timer_pf     : cq-> 1,2
// ldb_cq_threshold_vf : cq-> 5,7
// ldb_cq_timer_vf     : cq-> 4,6
//==========================================================//

class hcw_rearm_cmd_seq extends hqm_base_seq;


  `ovm_sequence_utils(hcw_rearm_cmd_seq, sla_sequencer)

      ovm_object     o_tmp;
      sla_ral_addr_t addr;
      sla_ral_reg    reg_h;
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]     rd_val;
      hcw_qtype      qtype_in;
      bit            is_ldb;
      bit [7:0]      dqid[hqm_pkg::NUM_DIR_CQ];
      bit [7:0]      lqid[hqm_pkg::NUM_LDB_QID];
      bit [7:0]      lpp[hqm_pkg::NUM_LDB_CQ];
      bit [3:0]      vdev[16];
      bit [31:0]     exp_synd_val;

//    function                         new                                (string name = "hcw_rearm_cmd_seq");
    extern task                      body();
    extern task                      cq_rearm_check();

function new(string name = "hcw_rearm_cmd_seq");
  super.new(name);
endfunction


endclass : hcw_rearm_cmd_seq

task hcw_rearm_cmd_seq::body();

    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_MEDIUM);
    get_hqm_cfg();

    // -- Start traffic with the default bus number for VF and PF
    ovm_report_info(get_full_name(), $psprintf("Starting traffic on HQM "), OVM_LOW);

     // -- get the DIR/PP QID Number
     for (int i=0;i<16;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("DQID%0d",i),dqid[i])) begin
          `ovm_info(get_full_name(), $psprintf("DBGSetting -- Logical DIR PP %0d maps to physical PP %0d",i,dqid[i]),OVM_MEDIUM)
        end else begin
         `ovm_error(get_full_name(), $psprintf("DBGSetting -- DQID%0d name not found in hqm_cfg",i))
        end
     end //:dir_qid_num 
     // -- get the LDB QID Number
     for (int i=0;i<16;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("LQID%0d",i),lqid[i])) begin
          `ovm_info(get_full_name(), $psprintf("DBGSetting -- Logical LDB QID %0d maps to physical QID %0d",i,lqid[i]),OVM_MEDIUM)
        end else begin
         `ovm_error(get_full_name(), $psprintf("DBGSetting -- LQID%0d name not found in hqm_cfg",i))
        end
     end //:ldb qid_num 
     // -- get the LDB PP Number
     for (int i=0;i<16;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",i),lpp[i])) begin
          `ovm_info(get_full_name(), $psprintf("DBGSetting -- Logical LDB PP %0d maps to physical PP %0d",i,lpp[i]),OVM_MEDIUM)
        end else begin
         `ovm_error(get_full_name(), $psprintf("DBGSetting -- LPP%0d name not found in hqm_cfg",i))
        end
     end //:ldb qid_num 
     // -- get the LDB PP Number
      for (int i=0;i<1 ;i++) begin //:dir_qid num
         if (i_hqm_cfg.get_name_val($psprintf("VDEV%0d",i),vdev[i])) begin
           `ovm_info(get_full_name(), $psprintf("DBGSetting -- Logical %0d maps to physical VDEV %0d",i,vdev[i]),OVM_MEDIUM)
         end else begin
          `ovm_error(get_full_name(), $psprintf("DBGSetting -- VDEV%0d name not found in hqm_cfg",i))
         end
      end //:ldb qid_num 

     wait_for_clk(10);
     cq_rearm_check();
  endtask: body


task hcw_rearm_cmd_seq::cq_rearm_check();
      int unsigned count = 1;        
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]     dir_rd_val;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]     ldb_rd_val;
      bit [31:0]     cq_timer_cnt[];
     
      cq_timer_cnt = new[16];

     ovm_report_info(get_full_name(), $psprintf(" -- cq_rearm_check:send_traffic start"), OVM_LOW);

    //send arm command
    for (int i=0; i<16; i++) begin
     send_cmd_pf_sciov(.is_nm_pf(1), .pp_num(dqid[i]), .qid(dqid[i]), .rpt(1), .is_ldb(0), .cmd(4'b0101));
     send_cmd_pf_sciov(.is_nm_pf(1), .pp_num(lpp[i]),  .qid(lqid[i]), .rpt(1), .is_ldb(1), .cmd(4'b0101));
    end
    execute_cfg_cmds();

     read_reg("cfg_dir_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     read_reg("cfg_dir_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     read_reg("cfg_ldb_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     read_reg("cfg_ldb_cq_intr_armed1", rd_data,   "credit_hist_pipe");

     send_new_pf_sciov(.is_nm_pf(1), .pp_num(dqid[0]), .qid(dqid[0]), .rpt(16), .is_ldb(0));
     send_new_pf_sciov(.is_nm_pf(1), .pp_num(dqid[1]), .qid(dqid[1]), .rpt(1),  .is_ldb(0));
     send_new_pf_sciov(.is_nm_pf(1), .pp_num(dqid[2]), .qid(dqid[2]), .rpt(6),  .is_ldb(0));
     send_new_pf_sciov(.is_nm_pf(1), .pp_num(dqid[3]), .qid(dqid[3]), .rpt(1),  .is_ldb(0));

     send_new_pf_sciov(.is_nm_pf(0), .pp_num(dqid[4]), .qid(4), .rpt(14), .is_ldb(0));
     send_new_pf_sciov(.is_nm_pf(0), .pp_num(dqid[5]), .qid(5), .rpt(15), .is_ldb(0));
     send_new_pf_sciov(.is_nm_pf(0), .pp_num(dqid[6]), .qid(6), .rpt(28), .is_ldb(0));
     send_new_pf_sciov(.is_nm_pf(0), .pp_num(dqid[7]), .qid(7), .rpt(15), .is_ldb(0));

     send_new_pf_sciov(.is_nm_pf(1), .pp_num(lpp[0]), .qid(lqid[0]), .rpt(24), .is_ldb(1));
     send_new_pf_sciov(.is_nm_pf(1), .pp_num(lpp[1]), .qid(lqid[1]), .rpt(2),  .is_ldb(1));
     send_new_pf_sciov(.is_nm_pf(1), .pp_num(lpp[2]), .qid(lqid[2]), .rpt(2),  .is_ldb(1));
     send_new_pf_sciov(.is_nm_pf(1), .pp_num(lpp[3]), .qid(lqid[3]), .rpt(2),  .is_ldb(1));

     send_new_pf_sciov(.is_nm_pf(0), .pp_num(lpp[4]), .qid(4), .rpt(1),  .is_ldb(1));
     send_new_pf_sciov(.is_nm_pf(0), .pp_num(lpp[5]), .qid(5), .rpt(28), .is_ldb(1));
     send_new_pf_sciov(.is_nm_pf(0), .pp_num(lpp[6]), .qid(6), .rpt(1),  .is_ldb(1));
     send_new_pf_sciov(.is_nm_pf(0), .pp_num(lpp[7]), .qid(7), .rpt(14), .is_ldb(1));
     execute_cfg_cmds();
     //waiting for scheduling
    for (int i=1;i<=count; i++) begin
     poll_sch( .cq_num(dqid[0]), .exp_cnt(16*i), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[1]), .exp_cnt(1*i),  .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[2]), .exp_cnt(6*i),  .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[3]), .exp_cnt(1*i),  .is_ldb(0) ); 

     poll_sch( .cq_num(dqid[4]), .exp_cnt(14*i), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[5]), .exp_cnt(15*i), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[6]), .exp_cnt(28*i), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[7]), .exp_cnt(15*i), .is_ldb(0) ); 

     poll_sch( .cq_num(lpp[0]), .exp_cnt(24*i), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[1]), .exp_cnt(2*i),  .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[2]), .exp_cnt(2*i),  .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[3]), .exp_cnt(2*i),  .is_ldb(1) ); 

     poll_sch( .cq_num(lpp[4]), .exp_cnt(1*i),  .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[5]), .exp_cnt(28*i), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[6]), .exp_cnt(1*i),  .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[7]), .exp_cnt(14*i), .is_ldb(1) ); 
    end
     //check run timer started
     read_reg("cfg_dir_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     dir_rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     dir_rd_val[63:32] = rd_data;
     read_reg("cfg_ldb_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     ldb_rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     ldb_rd_val[63:32] = rd_data;
      
     
       
     if (&({dir_rd_val[dqid[1]],dir_rd_val[dqid[3]],dir_rd_val[dqid[5]],dir_rd_val[dqid[7]],
            ldb_rd_val[lpp[1]],ldb_rd_val[lpp[2]],ldb_rd_val[lpp[4]],ldb_rd_val[lpp[6]]
              })) begin
        `ovm_info(get_full_name(), $psprintf("cq_rearm_check:run timer started as expected for dir cq1[%0d]=0x%0x, cq3[%0d]=0x%0x", dqid[1],dir_rd_val[dqid[1]], dqid[3],dir_rd_val[dqid[3]]),OVM_MEDIUM)
        `ovm_info(get_full_name(), $psprintf("cq_rearm_check:run timer started as expected for dir cq5[%0d]=0x%0x, cq7[%0d]=0x%0x", dqid[5],dir_rd_val[dqid[5]], dqid[7],dir_rd_val[dqid[7]]),OVM_MEDIUM)
        `ovm_info(get_full_name(), $psprintf("cq_rearm_check:run timer started as expected for ldb cq1[%0d]=0x%0x, cq2[%0d]=0x%0x", lpp[1],ldb_rd_val[lpp[1]], lpp[2],ldb_rd_val[lpp[2]]),OVM_MEDIUM)
        `ovm_info(get_full_name(), $psprintf("cq_rearm_check:run timer started as expected for ldb cq4[%0d]=0x%0x, cq6[%0d]=0x%0x", lpp[4],ldb_rd_val[lpp[4]], lpp[6],ldb_rd_val[lpp[6]]),OVM_MEDIUM)
     end else begin
        `ovm_error(get_full_name(), $psprintf("cq_rearm_check:run timer not started for dir cq=0x%0x and/or ldb cq=0x%0x", dir_rd_val,ldb_rd_val))
     end 

    fork 
     //check counter value reached some intermediate value 
     while((cq_timer_cnt[0] > 'h20 || cq_timer_cnt[2] >'h40) || (cq_timer_cnt[4] >'h40 || cq_timer_cnt[6] > 'h20)) begin
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[1]), cq_timer_cnt[0], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[3]), cq_timer_cnt[2], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[5]), cq_timer_cnt[4], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[7]), cq_timer_cnt[6], "credit_hist_pipe");  
      wait_for_clk(10);
     end
     while((cq_timer_cnt[8] > 'h20 || cq_timer_cnt[10] >'h40) || (cq_timer_cnt[12] >'h20 || cq_timer_cnt[14] > 'h40)) begin
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[1]),  cq_timer_cnt[8], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[2]),  cq_timer_cnt[10], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[4]),  cq_timer_cnt[12], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[6]),  cq_timer_cnt[14], "credit_hist_pipe");  
      wait_for_clk(10);
     end
     join
    //resend arm command
    for (int i=0; i<16; i++) begin
     send_cmd_pf_sciov(.is_nm_pf(1), .pp_num(dqid[i]), .qid(dqid[i]), .rpt(1), .is_ldb(0), .cmd(4'b0101));
     send_cmd_pf_sciov(.is_nm_pf(1), .pp_num(lpp[i]),  .qid(lqid[i]), .rpt(1), .is_ldb(1), .cmd(4'b0101));
    end
    execute_cfg_cmds();

     //now check counter value is > pervious value and not reset
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[1]), cq_timer_cnt[1], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[3]), cq_timer_cnt[3], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[5]), cq_timer_cnt[5], "credit_hist_pipe");  
      read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[7]), cq_timer_cnt[7], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[1]),  cq_timer_cnt[9], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[2]),  cq_timer_cnt[11], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[4]),  cq_timer_cnt[13], "credit_hist_pipe");  
      read_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[6]),  cq_timer_cnt[15], "credit_hist_pipe");  
      
     if((cq_timer_cnt[1] <= cq_timer_cnt[0])||(cq_timer_cnt[3] <= cq_timer_cnt[2])|| 
        (cq_timer_cnt[5] <= cq_timer_cnt[4])||(cq_timer_cnt[7] <= cq_timer_cnt[6])|| 
        (cq_timer_cnt[9] <= cq_timer_cnt[8])||(cq_timer_cnt[11] <= cq_timer_cnt[10])||
        (cq_timer_cnt[13] <= cq_timer_cnt[12])||(cq_timer_cnt[15] <= cq_timer_cnt[14])) begin
       `ovm_error(get_type_name(), $psprintf("cq_rearm_check:counter reset with re-arm command for dir cq_0=0%d cq_2=%d", cq_timer_cnt[0], cq_timer_cnt[2]));
       `ovm_error(get_type_name(), $psprintf("cq_rearm_check:counter reset with re-arm command for dir cq_4=0%d cq_6=%d", cq_timer_cnt[4], cq_timer_cnt[6]));
       `ovm_error(get_type_name(), $psprintf("cq_rearm_check:counter reset with re-arm command for ldb cq_8= %d cq_10=%d", cq_timer_cnt[8], cq_timer_cnt[10]));
       `ovm_error(get_type_name(), $psprintf("cq_rearm_check:counter reset with re-arm command for ldb cq_12= %d cq_14=%d", cq_timer_cnt[12], cq_timer_cnt[14]));
     end 

    // wait for timer to set reset
    fork 
     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[1]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[3]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[5]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[7]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[1]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[2]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[4]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[6]), 'h0, "credit_hist_pipe");  
    join
     // -- check cq_occ int status reg , it should not be generated for threshold interrupt and vf[0]-MSI
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     dir_rd_val[31:0] = rd_data;
     read_reg("dir_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     dir_rd_val[63:32] = rd_data;
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     ldb_rd_val[31:0] = rd_data;
     read_reg("ldb_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     ldb_rd_val[63:32] = rd_data;
      
    `ovm_info(get_full_name(), $psprintf("cq_rearm_check:dir_cq_31_0_occ_int_status=0x%0x,dir_cq_63_32_occ_int_status=0x%0x", dir_rd_val[31:0],dir_rd_val[63:32] ),OVM_MEDIUM)
    `ovm_info(get_full_name(), $psprintf("cq_rearm_check:ldb_cq_31_0_occ_int_status=0x%0x,ldb_cq_63_32_occ_int_status=0x%0x ", ldb_rd_val[31:0],ldb_rd_val[63:32] ),OVM_MEDIUM)
     // -- indexing of cq 
     if (&({dir_rd_val[dqid[1]],dir_rd_val[dqid[3]],
            ldb_rd_val[lpp[1]],ldb_rd_val[lpp[2]]})) begin
       `ovm_info(get_full_name(), $psprintf("cq_rearm_check:CQ-Interrupt generated as expected for cq1[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[1],dir_rd_val[dqid[1]], dqid[3],dir_rd_val[dqid[3]]),OVM_LOW)
     end
     else begin
           `ovm_error(get_full_name(), $psprintf("cq_rearm_check:CQ-Interrupt not generated for cq1[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[1],dir_rd_val[dqid[1]],dqid[3],dir_rd_val[dqid[3]]))
     end
    
     // -- check no other cq intr is set 
     dir_rd_val[dqid[1]] = ~dir_rd_val[dqid[1]];
     dir_rd_val[dqid[3]] = ~dir_rd_val[dqid[3]]; 
     ldb_rd_val[lpp[1]]  = ~ldb_rd_val[lpp[1]];
     ldb_rd_val[lpp[2]]  = ~ldb_rd_val[lpp[2]];
  
     if((|dir_rd_val[hqm_pkg::NUM_DIR_CQ-1:0]) || (|ldb_rd_val[hqm_pkg::NUM_LDB_CQ-1:0])) begin
       `ovm_error(get_full_name(), $psprintf("cq_rearm_check:CQ-Interrupt generated for unexpected dir/ldb cq's dir_rd_val=0x%0x, ldb_rd_val=0x%0x", dir_rd_val, ldb_rd_val))
     end
      
     //-- check cq intr armed is cleared for cq dqid[1] & dqid[3] & lpp[1],lpp[2]
     read_reg("cfg_dir_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     dir_rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     dir_rd_val[63:32] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     ldb_rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     ldb_rd_val[63:32] = rd_data;

    `ovm_info(get_full_name(), $psprintf("cq_rearm_check:cfg_dir_cq_intr_armed0=0x%0x, cfg_dir_cq_intr_armed1=0x%0x", dir_rd_val[31:0],dir_rd_val[63:32] ),OVM_MEDIUM)

     //check armed
     if (|({dir_rd_val[dqid[1]],dir_rd_val[dqid[3]],
            dir_rd_val[dqid[5]],dir_rd_val[dqid[7]],
            ldb_rd_val[lpp[1]],ldb_rd_val[lpp[2]],
            ldb_rd_val[lpp[4]],ldb_rd_val[lpp[6]]})) begin
           `ovm_error(get_full_name(), $psprintf("cq_rearm_check:CQ-Interrupt_arm reg not cleared for cq1[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[1],dir_rd_val[dqid[1]],dqid[3], dir_rd_val[dqid[3]]))
     end
     
    //now initiate threshold interrupt
     send_new_pf_sciov(.is_nm_pf(1), .pp_num(dqid[0]), .qid(dqid[0]), .rpt(1), .is_ldb(0));
     send_new_pf_sciov(.is_nm_pf(1), .pp_num(dqid[2]), .qid(dqid[2]), .rpt(1), .is_ldb(0));
     send_new_pf_sciov(.is_nm_pf(1), .pp_num(lpp[0]),  .qid(lqid[0]), .rpt(1), .is_ldb(1));
     send_new_pf_sciov(.is_nm_pf(1), .pp_num(lpp[3]),  .qid(lqid[3]), .rpt(1), .is_ldb(1));
     send_new_pf_sciov(.is_nm_pf(0), .pp_num(dqid[4]), .qid(4), .rpt(1), .is_ldb(0));
     send_new_pf_sciov(.is_nm_pf(0), .pp_num(dqid[6]), .qid(6), .rpt(1), .is_ldb(0));
     send_new_pf_sciov(.is_nm_pf(0), .pp_num(lpp[5]), .qid(5), .rpt(1), .is_ldb(1));
     send_new_pf_sciov(.is_nm_pf(0), .pp_num(lpp[7]), .qid(7), .rpt(1), .is_ldb(1));
     execute_cfg_cmds();

    for (int i=1;i<=count; i++) begin
     poll_sch( .cq_num(dqid[0]), .exp_cnt(17*i), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[2]), .exp_cnt(7*i),  .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[4]), .exp_cnt(15*i), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[6]), .exp_cnt(29*i), .is_ldb(0) ); 
     poll_sch( .cq_num(lpp[0]),  .exp_cnt(25*i), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[3]),  .exp_cnt(3*i),  .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[5]),  .exp_cnt(29*i), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[7]),  .exp_cnt(15*i), .is_ldb(1) ); 
    end
    //now check cq-occ generated for dqid[0,2], lpp[0,3]
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     dir_rd_val[31:0] = rd_data;
     read_reg("dir_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     dir_rd_val[63:32] = rd_data;
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     ldb_rd_val[31:0] = rd_data;
     read_reg("ldb_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     ldb_rd_val[63:32] = rd_data;
      
     if (&({dir_rd_val[dqid[0]],dir_rd_val[dqid[2]],
            ldb_rd_val[lpp[0]],ldb_rd_val[lpp[3]]})) begin
       `ovm_info(get_full_name(), $psprintf("cq_rearm_check:CQ-Interrupt generated as expected for dir cq0[%0d]=0x%0x and cq2[%0d]=0x%0x", dqid[0],dir_rd_val[dqid[0]], dqid[2],dir_rd_val[dqid[2]]),OVM_MEDIUM)
     end
     else begin
           `ovm_error(get_full_name(), $psprintf("cq_rearm_check:CQ-Interrupt not generated for either of dir cq0,2 and/or ldb cq0,3 dir_rd_val=0x%0x ldb_rd_val=0x%0x", dir_rd_val,ldb_rd_val))
     end
    
     //-- check cq intr armed is cleared for cq threshold
     // dqid[0,2,4,6] & lpp[0,3,5,7]
     read_reg("cfg_dir_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     dir_rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     dir_rd_val[63:32] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     ldb_rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     ldb_rd_val[63:32] = rd_data;

    `ovm_info(get_full_name(), $psprintf("cq_rearm_check:cfg_dir_cq_intr_armed0=0x%0x, cfg_dir_cq_intr_armed1=0x%0x", dir_rd_val[31:0],dir_rd_val[63:32] ),OVM_MEDIUM)

     //check armed
     if (|({dir_rd_val[dqid[0]],dir_rd_val[dqid[2]],
            dir_rd_val[dqid[4]],dir_rd_val[dqid[6]],
            ldb_rd_val[lpp[0]],ldb_rd_val[lpp[3]],
            ldb_rd_val[lpp[5]],ldb_rd_val[lpp[7]]})) begin
           `ovm_error(get_full_name(), $psprintf("cq_rearm_check:CQ-Interrupt_arm reg not cleared for dir cq0,2,4,6=0x%0x and ldb cq0,3,5,7=0x%0x", dir_rd_val, ldb_rd_val))
     end




     //-- token return tkn_cnt is 0-based 
     send_bat_t_pf_sciov(.is_nm_pf(1), .pp_num(dqid[0]), .tkn_cnt(16), .is_ldb(0));
     send_bat_t_pf_sciov(.is_nm_pf(1), .pp_num(dqid[1]), .tkn_cnt(0),  .is_ldb(0)); 
     send_bat_t_pf_sciov(.is_nm_pf(1), .pp_num(dqid[2]), .tkn_cnt(6),  .is_ldb(0));
     send_bat_t_pf_sciov(.is_nm_pf(1), .pp_num(dqid[3]), .tkn_cnt(0),  .is_ldb(0));
     send_bat_t_pf_sciov(.is_nm_pf(0), .pp_num(dqid[4]), .tkn_cnt(14), .is_ldb(0));
     send_bat_t_pf_sciov(.is_nm_pf(0), .pp_num(dqid[5]), .tkn_cnt(14), .is_ldb(0));
     send_bat_t_pf_sciov(.is_nm_pf(0), .pp_num(dqid[6]), .tkn_cnt(28), .is_ldb(0));
     send_bat_t_pf_sciov(.is_nm_pf(0), .pp_num(dqid[7]), .tkn_cnt(14), .is_ldb(0));

     send_comp_t_pf_sciov(.is_nm_pf(1), .pp_num(lpp[0]), .rpt(25));
     send_comp_t_pf_sciov(.is_nm_pf(1), .pp_num(lpp[1]), .rpt(2));
     send_comp_t_pf_sciov(.is_nm_pf(1), .pp_num(lpp[2]), .rpt(2));
     send_comp_t_pf_sciov(.is_nm_pf(1), .pp_num(lpp[3]), .rpt(3));

     send_comp_t_pf_sciov(.is_nm_pf(0), .pp_num(lpp[4]), .rpt(1));
     send_comp_t_pf_sciov(.is_nm_pf(0), .pp_num(lpp[5]), .rpt(29));
     send_comp_t_pf_sciov(.is_nm_pf(0), .pp_num(lpp[6]), .rpt(1));
     send_comp_t_pf_sciov(.is_nm_pf(0), .pp_num(lpp[7]), .rpt(15));
    
    //-- clear cq_occ 
     write_reg("dir_cq_31_0_occ_int_status",   '1, "hqm_system_csr");
     write_reg("dir_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     write_reg("ldb_cq_31_0_occ_int_status",   '1, "hqm_system_csr");
     write_reg("ldb_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

      ovm_report_info(get_full_name(), $psprintf(" -- cq_rearm_check:send_traffic finished"), OVM_LOW);
  endtask:cq_rearm_check



`endif //HCW_REARM_CMD_SEQ__SV



