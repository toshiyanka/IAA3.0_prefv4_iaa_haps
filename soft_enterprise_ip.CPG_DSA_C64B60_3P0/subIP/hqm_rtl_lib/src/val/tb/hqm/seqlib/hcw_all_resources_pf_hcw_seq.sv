`ifndef HCW_ALL_RESOURCES_PF_HCW_SEQ__SV
`define HCW_ALL_RESOURCES_PF_HCW_SEQ__SV

//  


class hcw_all_resources_pf_hcw_seq extends hcw_cq_threshold_0_seq;

  `ovm_sequence_utils(hcw_all_resources_pf_hcw_seq, sla_sequencer)

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
      bit [7:0]             lqid[32];
      bit [7:0]             lpp[64];
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
      extern task           send_hcw_arm();

    function new(string name = "hcw_all_resources_pf_hcw_seq");
      super.new(name);
    endfunction

endclass: hcw_all_resources_pf_hcw_seq

    task hcw_all_resources_pf_hcw_seq::body();
      ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);
      get_hqm_cfg();
      dir_cq_cnt=hqm_pkg::NUM_DIR_CQ;
      ldb_cq_cnt=hqm_pkg::NUM_LDB_CQ;
      ldb_qid_cnt=hqm_pkg::NUM_LDB_QID;
      // -- get the DIR/PP QID Number
      for (int i=0;i<dir_cq_cnt;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("DQID%0d",i),dqid[i])) begin
          `ovm_info(get_full_name(), $psprintf("Logical DIR PP %0d maps to physical PP %0d",i,dqid[i]),OVM_DEBUG)
        end else begin
         `ovm_error(get_full_name(), $psprintf("DQID%0d name not found in hqm_cfg",i))
        end
      end //:dir_qid_num 
     // -- get the LDB QID Number
     for (int i=0;i<ldb_qid_cnt;i++) begin //:ldb_qid num
       if (i_hqm_cfg.get_name_val($psprintf("LQID%0d",i),lqid[i])) begin
         `ovm_info(get_full_name(), $psprintf("Logical LDB QID %0d maps to physical QID %0d",i,lqid[i]),OVM_DEBUG)
       end else begin
        `ovm_error(get_full_name(), $psprintf("LQID%0d name not found in hqm_cfg",i))
       end
     end //:ldb qid_num 
     // -- get the LDB PP Number
     for (int i=0;i<ldb_cq_cnt;i++) begin //:ldb_pp num
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
//1. Timer & Threshold interrupt enabled,  
//2. sends in 64 hcws with ARM cmd to arm all 64 cq
//3. read armed reg exp value should be all Fs
//4. send in 64-dir and 64-LDB hcws with 1 going to each cq expected interrupt for all cqs
//5.cfg read *_cq_intr_armed0 and *_cq_intr_armed1 expected result 0x00000000_00000000
//=======================================================//

task hcw_all_resources_pf_hcw_seq::cq_cial_check();

    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Start"), OVM_MEDIUM);

    send_hcw_arm();
    send_hcw_new(1);
    //check cq_occ and armed
    read_cq_occ(dir_cq_occ,ldb_cq_occ, dir_cq_armed,ldb_cq_armed);
    for(int i=0;i<dir_cq_cnt;i++) begin 
      check_cq_occ(.check_cq(dir_cq_occ[dqid[i]]));
      check_armed(.check_cq_armed(dir_cq_armed[dqid[i]]));
    end 
    for(int i=0;i<ldb_cq_cnt;i++) begin 
      check_cq_occ(.check_cq(ldb_cq_occ[lpp[i]]));
      check_armed(.check_cq_armed(ldb_cq_armed[lpp[i]]));
    end 
    send_hcw_new(2);
    read_cq_occ(dir_cq_occ,ldb_cq_occ, dir_cq_armed,ldb_cq_armed);
    if (dir_cq_armed||ldb_cq_armed) begin
        `ovm_error(get_full_name(), $psprintf("unexpected cq_occ generated for dir_cq_index=0x%0x and/or ldb_cq_index=0x%0x", dir_cq_occ, ldb_cq_occ))
    end
    //token return  
    for(int i=0;i<dir_cq_cnt;i++) begin 
       send_bat_t_pf( .pp_num(dqid[i]), .tkn_cnt(1), .is_ldb(0));
    end 
    for(int i=0;i<ldb_cq_cnt;i++) begin 
       send_comp_t_pf(.pp_num(lpp[i]),  .rpt(2));
    end
    wait_for_clk(100);
    //wait for token return
    fork
      for(int i=0;i<dir_cq_cnt;i++) begin 
         poll_reg($psprintf("cfg_dir_cq_depth[%0d]", dqid[i]), 'h0, "credit_hist_pipe");  
      end 
      for(int i=0;i<ldb_cq_cnt;i++) begin 
         poll_reg($psprintf("cfg_ldb_cq_depth[%0d]", lpp[i]), 'h00, "credit_hist_pipe");  
      end
    join
    wait_for_clk(10);
    ovm_report_info(get_full_name(), $psprintf("cq_cial_check:-- Complete"), OVM_MEDIUM);
endtask:cq_cial_check 


task hcw_all_resources_pf_hcw_seq::send_hcw_new(input int unsigned iteration=1);

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


task hcw_all_resources_pf_hcw_seq::send_hcw_arm();

    for(int i=0; i<dir_cq_cnt; i++) begin
        send_cmd_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(1), .is_ldb(0), .cmd(4'b0101));
        execute_cfg_cmds();
    end
    for(int i=0; i<ldb_cq_cnt; i++) begin
      if(i<32) begin
        send_cmd_pf(.pp_num(lpp[i]), .qid(lqid[i]), .rpt(1), .is_ldb(1), .cmd(4'b0101));
      end else if (i >31) begin
        send_cmd_pf(.pp_num(lpp[i]), .qid(lqid[i%32]), .rpt(1), .is_ldb(1), .cmd(4'b0101));
      end
      execute_cfg_cmds();
    end
/*
    for(int i=0; i<dir_cq_cnt; i++) begin
       dir_rd_val = dir_rd_val | (1<<dqid[i]);
    end
    for(int i=0; i<ldb_cq_cnt; i++) begin
       ldb_rd_val = ldb_rd_val | (1<<lpp[i]);
    end
   `ovm_info(get_full_name(), $psprintf("dir_rd_val=0x%0x, ldb_rd_val=0x%0x", dir_rd_val, ldb_rd_val),OVM_LOW)
*/  
    rd_data =32'hffffffff; 
    fork  
     poll_reg($psprintf("cfg_dir_cq_intr_armed0"), rd_data, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_dir_cq_intr_armed1"), rd_data, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_intr_armed0"), rd_data, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_intr_armed1"), rd_data, "credit_hist_pipe");  
    join 
    
endtask: send_hcw_arm


`endif //HCW_ALL_RESOURCES_PF_HCWSEQ__SV
