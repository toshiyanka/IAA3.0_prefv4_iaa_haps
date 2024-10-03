`ifndef HCW_CQ_THRESHOLD_0_SEQ__SV
`define HCW_CQ_THRESHOLD_0_SEQ__SV

//==========================================================//
// dir_cq_threshold_pf    : cq-> dqid 0-11
// dir_cq_threshold_vdev  : cq-> dqid 0-11 
// ldb_cq_threshold_pf    : cq-> lpp 0-11
// ldb_cq_threshold_vdev  : cq-> lpp 0-11 
//==========================================================//

class hcw_cq_threshold_0_seq extends hqm_base_seq;


  `ovm_sequence_utils(hcw_cq_threshold_0_seq, sla_sequencer)

      ovm_event_pool        glbl_pool;
      ovm_event exp_msix;
      ovm_object     o_tmp;
      sla_ral_addr_t addr;
      sla_ral_reg    reg_h;
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]     rd_val;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]     dir_rd_val;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]     ldb_rd_val;
      hcw_qtype      qtype_in;
      bit            is_ldb;
      bit            cq_occ_exp;
      bit [7:0]      dqid[hqm_pkg::NUM_DIR_CQ];
      bit [7:0]      lqid[hqm_pkg::NUM_LDB_QID];
      bit [7:0]      lpp[hqm_pkg::NUM_LDB_CQ];
      bit [3:0]      vf[16];
      bit [3:0]      vdev[16];
      bit [31:0]     exp_synd_val;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]            dir_cq_occ;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]            ldb_cq_occ;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]            dir_cq_armed;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]            ldb_cq_armed;
      bit [10:0]     cq_depth_val;
      bit [12:0]     cq_intr_depth_thrsh_val;
      bit [7:0]      tot_cq_cnt;
      bit [7:0]      qid_adjusted_val;
      int unsigned   count;
      int unsigned  int_depth_thrs;
      int unsigned  timeout_val;
//    function                         new                                (string name = "hcw_cq_threshold_0_seq");
    extern task                      body();
    extern task                      cq_depth_override();
    extern task                      cq_int_depth_thrsh_override();
    extern task                      cq_threshold_0_check(int unsigned iteration =1 );
    extern task                      read_cq_occ(output bit [hqm_pkg::NUM_DIR_CQ-1:0] dir_cq_occ,output bit [hqm_pkg::NUM_LDB_CQ-1:0] ldb_cq_occ, output bit [hqm_pkg::NUM_DIR_CQ-1:0] dir_cq_armed ,output bit [hqm_pkg::NUM_LDB_CQ-1:0] ldb_cq_armed);
    extern task                      check_cq_occ(bit [7:0] check_cq );
    extern task                      check_armed(bit  [7:0] check_cq_armed );
    extern task                      clear_cq_occ();
    extern task                      trigger_msix();
    extern task                      send_arm_cmd(input bit cq_occ_exp=0);

function new(string name = "hcw_cq_threshold_0_seq");
  super.new(name);
    glbl_pool  = ovm_event_pool::get_global_pool();
    for (int vec=1;vec<25;vec++) begin
     exp_msix = glbl_pool.get($psprintf("hqm_exp_ep_msix_%d",vec));
    end
endfunction

endclass : hcw_cq_threshold_0_seq

task hcw_cq_threshold_0_seq::body();

    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);
    get_hqm_cfg();

    // -- Start traffic with the default bus number for VF and PF
    ovm_report_info(get_full_name(), $psprintf("Starting traffic on HQM "), OVM_LOW);

     // -- get the DIR/PP QID Number
     for (int i=0;i<12;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("DQID%0d",i),dqid[i])) begin
          `ovm_info(get_full_name(), $psprintf("Logical DIR PP %0d maps to physical PP %0d",i,dqid[i]),OVM_DEBUG)
        end else begin
         `ovm_error(get_full_name(), $psprintf("DQID%0d name not found in hqm_cfg",i))
        end
     end //:dir_qid_num 

     // -- get the LDB QID Number
     for (int i=0;i<12;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("LQID%0d",i),lqid[i])) begin
          `ovm_info(get_full_name(), $psprintf("Logical LDB QID %0d maps to physical QID %0d",i,lqid[i]),OVM_DEBUG)
        end else begin
         `ovm_error(get_full_name(), $psprintf("LQID%0d name not found in hqm_cfg",i))
        end
     end //:ldb qid_num 

     // -- get the LDB PP Number
     for (int i=0;i<12;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",i),lpp[i])) begin
          `ovm_info(get_full_name(), $psprintf("Logical LDB PP %0d maps to physical PP %0d",i,lpp[i]),OVM_DEBUG)
        end else begin
         `ovm_error(get_full_name(), $psprintf("LPP%0d name not found in hqm_cfg",i))
        end
     end //:ldb qid_num 

     // -- get the VDEV number 
     if(i_hqm_cfg.is_sciov_mode()) begin
      for (int i=0;i<1 ;i++) begin //:dir_qid num
         if (i_hqm_cfg.get_name_val($psprintf("VDEV%0d",i),vdev[i])) begin
           `ovm_info(get_full_name(), $psprintf("Logical VDEV %0d maps to physical VDEV %0d",i,vdev[i]),OVM_DEBUG)
         end else begin
          `ovm_info(get_full_name(), $psprintf("VDEV%0d name not found in hqm_cfg",i),OVM_LOW)
         end
      end 
     end //is_sciov_mode 

     // -- get the VF number  
     if(i_hqm_cfg.is_sriov_mode()) begin
      for (int i=0;i<1 ;i++) begin //:dir_qid num
         if (i_hqm_cfg.get_name_val($psprintf("VF%0d",i),vf[i])) begin
           `ovm_info(get_full_name(), $psprintf("Logical VF %0d maps to physical VF %0d",i,vf[i]),OVM_DEBUG)
         end else begin
          `ovm_error(get_full_name(), $psprintf("VF%0d name not found in hqm_cfg",i))
         end
      end //for
    end //sriov_mode

      //get cq depth for token return loop
      cq_depth_val = i_hqm_cfg.get_cq_depth(0,dqid[0]);
      //get cq_int_depth val
      read_reg($psprintf("cfg_dir_cq_int_depth_thrsh[%0d]", dqid[0]), rd_data, "credit_hist_pipe");  
      int_depth_thrs= rd_data;
      `ovm_info(get_full_name(), $psprintf("CQ_DEPTH = %0d cq_int_depth_thrsh = %0d", cq_depth_val, int_depth_thrs),OVM_LOW)
      
      if($value$plusargs("TOT_CQ_CNT=%d", tot_cq_cnt)) begin
        this.tot_cq_cnt = tot_cq_cnt;
      end  else begin 
        tot_cq_cnt = 8'd12; 
      end

      //--this is to support backward compatible with HQMV25 which has 96 DIR DIR, and it's hardcoded with 84 when calling send_cmd_pf(.qid(84) ) for dir;  and hardcoded with 20 when calling  send_cmd_pf(.qid(20)) for ldb
      qid_adjusted_val= 8'd12;
      $value$plusargs("TOT_QID_ADJ=%d", qid_adjusted_val);

      if($value$plusargs("TIMEOUT_VAL=%d", timeout_val)) begin
       this.timeout_val= timeout_val;
      end else begin 
        timeout_val= 10000; // 8'd12;
      end
      `ovm_info(get_full_name(), $psprintf("TOT_CQ_CNT= %0d, TOT_QID_ADJ=%0d, TIMEOUT_VAL=%0d ", tot_cq_cnt,qid_adjusted_val,timeout_val),OVM_LOW)
      count=0;
      trigger_msix();
      wait_for_clk(10);
      cq_threshold_0_check();
      wait_for_clk(100);
  endtask: body


//==============================================
// cq_depth=8/16
// cq_threshold=0
//==============================================

task hcw_cq_threshold_0_seq::cq_threshold_0_check(int unsigned iteration = 1);

      ovm_report_info(get_full_name(), $psprintf(" -- cq_threshold_0_check:send_traffic start"), OVM_LOW);

      send_arm_cmd(.cq_occ_exp(0));

//-- Iteration count 
  for (int j=1;j<=iteration;j++) begin
    for (int i=0;i<tot_cq_cnt;i++) begin 
      if(i_hqm_cfg.is_pf_mode()) begin
        send_new_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(cq_depth_val), .is_ldb(0));
        send_new_pf(.pp_num(lpp[i]),  .qid(lqid[i]), .rpt(cq_depth_val), .is_ldb(1));
      end
      else if(i_hqm_cfg.is_sciov_mode()) begin
        ovm_report_info(get_full_name(), $psprintf("cq_threshold_0_check -- send_cmd_pf: i=%0d dir_pp=%0d vqid=%0d dqid[%0d]=%0d cq_depth_val=%0d", i, dqid[i], ((hqm_pkg::NUM_DIR_CQ-qid_adjusted_val)+i), i, dqid[i], cq_depth_val), OVM_DEBUG);
        send_cmd_pf(.pp_num(dqid[i]), .qid((hqm_pkg::NUM_DIR_CQ-qid_adjusted_val)+i), .rpt(cq_depth_val), .is_ldb(0), .cmd(4'b1000));
        //send_cmd_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(cq_depth_val), .is_ldb(0), .cmd(4'b1000));

        ovm_report_info(get_full_name(), $psprintf("cq_threshold_0_check -- send_cmd_pf: i=%0d ldb_pp=%0d vqid=%0d lqid[%0d]=%0d cq_depth_val=%0d", i, lpp[i], ((hqm_pkg::NUM_LDB_QID-qid_adjusted_val)+i), i, lqid[i], cq_depth_val), OVM_DEBUG);
        send_cmd_pf(.pp_num(lpp[i]),  .qid((hqm_pkg::NUM_LDB_QID-qid_adjusted_val)+i), .rpt(cq_depth_val), .is_ldb(1), .cmd(4'b1000));
        //send_cmd_pf(.pp_num(lpp[i]),  .qid(lqid[i]), .rpt(cq_depth_val), .is_ldb(1), .cmd(4'b1000));
      end  
      else if(i_hqm_cfg.is_sriov_mode) begin end
    end 

    execute_cfg_cmds();

    //wait for scheduling 
    for (int i=0;i<tot_cq_cnt;i++) begin 
     ovm_report_info(get_full_name(), $psprintf("cq_threshold_0_check -- poll_sch_dir: i=%0d dir_cq=%0d exp_cnt=%0d", i, dqid[i], cq_depth_val*j), OVM_DEBUG);
     poll_sch( .cq_num(dqid[i]), .exp_cnt(cq_depth_val*j), .is_ldb(0), .delay(100), .timeout(timeout_val)); 

     ovm_report_info(get_full_name(), $psprintf("cq_threshold_0_check -- poll_sch_ldb: i=%0d ldb_cq=%0d exp_cnt=%0d", i, lpp[i], cq_depth_val*j), OVM_DEBUG);
     poll_sch( .cq_num(lpp[i]),  .exp_cnt(cq_depth_val*j), .is_ldb(1), .delay(100), .timeout(timeout_val)); 
    end 

    //check for occ interrupt
    for (int i=0;i<cq_depth_val;i++) begin 
      `ovm_info(get_full_name(), $psprintf("i_cq_depth_val:=%0d", i),OVM_LOW)
        
       if ((i < (cq_depth_val-int_depth_thrs))) begin
         read_cq_occ(dir_cq_occ,ldb_cq_occ, dir_cq_armed,ldb_cq_armed);
         for (int i=0;i<tot_cq_cnt;i++) begin 
            check_cq_occ(.check_cq(dir_cq_occ[dqid[i]]));
            check_cq_occ(.check_cq(ldb_cq_occ[lpp[i]]));
            check_armed(.check_cq_armed(dir_cq_armed[dqid[i]]));
            check_armed(.check_cq_armed(ldb_cq_armed[lpp[i]]));
         end 
         clear_cq_occ();  
       end //interrupt depth >0
       //return-only 1 token
       for(int j=0;j<tot_cq_cnt;j++) begin 
         `ovm_info(get_full_name(), $psprintf("j_tot_cq_cnt:=%0d", j),OVM_LOW)
         send_bat_t_pf(.pp_num(dqid[j]), .tkn_cnt(0), .is_ldb(0));
         send_comp_t_pf(.pp_num(lpp[j]), .rpt(1));
       end 
       //send arm command again      
       if ((i < (cq_depth_val-int_depth_thrs-1))) begin
          send_arm_cmd(.cq_occ_exp(1));
       end else begin
          send_arm_cmd(.cq_occ_exp(0));
       end
       wait_for_clk(10);
    end //for cq_depth_val
    clear_cq_occ();  
  end //for-iteration
      ovm_report_info(get_full_name(), $psprintf(" -- cq_threshold_0_check:send_traffic finished"), OVM_LOW);
endtask:cq_threshold_0_check

// -- check cq_occ int status reg 
 task hcw_cq_threshold_0_seq::read_cq_occ(output bit [hqm_pkg::NUM_DIR_CQ-1:0] dir_cq_occ, output bit [hqm_pkg::NUM_LDB_CQ-1:0] ldb_cq_occ, output bit [hqm_pkg::NUM_DIR_CQ-1:0] dir_cq_armed, output bit [hqm_pkg::NUM_LDB_CQ-1:0] ldb_cq_armed);
      ovm_report_info(get_full_name(), $psprintf(" -- read_cq_occ: Start"), OVM_LOW);
  
  if(i_hqm_cfg.is_pf_mode()) begin
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     dir_cq_occ[31:0] = rd_data;
     read_reg("dir_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     dir_cq_occ[63:32]= rd_data;
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     ldb_cq_occ[31:0] = rd_data;
     read_reg("ldb_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     ldb_cq_occ[63:32] = rd_data;
  end //read only for pf mode
    //read arm register
     read_reg("cfg_dir_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     dir_cq_armed[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     dir_cq_armed[63:32] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     ldb_cq_armed[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     ldb_cq_armed[63:32] = rd_data;
      ovm_report_info(get_full_name(), $psprintf(" -- read_cq_occ: finished"), OVM_LOW);
 endtask:read_cq_occ 

 task hcw_cq_threshold_0_seq::check_cq_occ(bit [7:0] check_cq );
  if(i_hqm_cfg.is_pf_mode()) begin
     // -- indexing of cq 
     if (check_cq)begin 
       `ovm_info(get_full_name(), $psprintf("check_cq_occ:CQ-Interrupt generated as expected for check_cq=0x%0x", check_cq),OVM_DEBUG)
     end else begin
       `ovm_error(get_full_name(), $psprintf("check_cq_occ:CQ-Interrupt not generated check_cq=0x%0x",check_cq))
     end
  end //check only for pf mode
 endtask: check_cq_occ
  
 task hcw_cq_threshold_0_seq::check_armed(bit [7:0] check_cq_armed );
     // -- indexing of cq 
     if ((check_cq_armed))begin 
           `ovm_error(get_full_name(), $psprintf("check_armed:CQ-Interrupt_arm reg not cleared cq=0x%0x", check_cq_armed))
     end else begin
           `ovm_info(get_full_name(), $psprintf("check_armed:CQ-Interrupt armed as expected for cq=0x%0x", check_cq_armed),OVM_DEBUG)
     end

 endtask: check_armed


task hcw_cq_threshold_0_seq::clear_cq_occ();
      
    `ovm_info(get_full_name(), $psprintf("clear_cq_occ:count=%0d start", count),OVM_DEBUG)
     write_reg("dir_cq_31_0_occ_int_status",   '1, "hqm_system_csr");
     write_reg("dir_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     write_reg("ldb_cq_31_0_occ_int_status",   '1, "hqm_system_csr");
     write_reg("ldb_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     count++;
    `ovm_info(get_full_name(), $psprintf("clear_cq_occ:finished"),OVM_DEBUG)

endtask: clear_cq_occ

task hcw_cq_threshold_0_seq::cq_depth_override();
 sla_ral_data_t rd_data;
  bit [3:0] cq_depth_in;
    `ovm_info(get_full_name(), $psprintf("cq_depth_override:Start"),OVM_DEBUG)

for (int i=0;i<tot_cq_cnt ;i++) begin
    if(cq_depth_val=='d8) cq_depth_in = 1;
    else if(cq_depth_val=='d16) cq_depth_in = 2;
    else cq_depth_in = 1; //depth=8

    cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_dir_cq_token_depth_select[%0d] %0d ",dqid[i], cq_depth_in));
    cfg_cmds.push_back($psprintf("wr list_sel_pipe.cfg_cq_dir_token_depth_select_dsi[%0d] %0d ",dqid[i], cq_depth_in));
    cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_ldb_cq_token_depth_select[%0d] %0d ",lpp[i], cq_depth_in));
    cfg_cmds.push_back($psprintf("wr list_sel_pipe.cfg_cq_ldb_token_depth_select[%0d] %0d ", lpp[i], cq_depth_in));
    execute_cfg_cmds();
end
for (int i=0;i<tot_cq_cnt ;i++) begin
    cfg_cmds.push_back($psprintf("rd credit_hist_pipe.cfg_dir_cq_token_depth_select[%0d] %0d ",dqid[i], cq_depth_in));
    cfg_cmds.push_back($psprintf("rd list_sel_pipe.cfg_cq_dir_token_depth_select_dsi[%0d] %0d ",dqid[i], cq_depth_in));
    cfg_cmds.push_back($psprintf("rd credit_hist_pipe.cfg_ldb_cq_token_depth_select[%0d] %0d ",lpp[i], cq_depth_in));
    cfg_cmds.push_back($psprintf("rd list_sel_pipe.cfg_cq_ldb_token_depth_select[%0d] %0d ", lpp[i], cq_depth_in));
    execute_cfg_cmds();
end
    `ovm_info(get_full_name(), $psprintf("cq_depth_override:finished"),OVM_DEBUG)

endtask: cq_depth_override 

task hcw_cq_threshold_0_seq::cq_int_depth_thrsh_override();
  sla_ral_data_t rd_data;
 `ovm_info(get_full_name(), $psprintf("cq_int_depth_thrsh_override:Start"),OVM_DEBUG)

  for (int i=0;i<tot_cq_cnt ;i++) begin
    cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[%0d] %0d ",dqid[i], cq_intr_depth_thrsh_val));
    cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_ldb_cq_int_depth_thrsh[%0d] %0d ",lpp[i],  cq_intr_depth_thrsh_val));
    execute_cfg_cmds();
  end
  for (int i=0;i<tot_cq_cnt ;i++) begin
    cfg_cmds.push_back($psprintf("rd credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[%0d] %0d ",dqid[i], cq_intr_depth_thrsh_val));
    cfg_cmds.push_back($psprintf("rd credit_hist_pipe.cfg_ldb_cq_int_depth_thrsh[%0d] %0d ",lpp[i],  cq_intr_depth_thrsh_val));
  end

endtask


task hcw_cq_threshold_0_seq::send_arm_cmd (input bit cq_occ_exp=0);
      `ovm_info(get_full_name(), $psprintf("send_arm_cmd:-- Start CQ_OCC_EXP=%0b", cq_occ_exp),OVM_LOW)
       dir_rd_val ='h0;
       ldb_rd_val ='h0;
       //send arm command 
       for (int i=0; i<tot_cq_cnt; i++) begin
         `ovm_info(get_full_name(), $psprintf("send_arm_cmd:i_token_tot_cq_cnt:=%0d dir_pp=%0d", i, dqid[i]),OVM_DEBUG)
         send_cmd_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(1), .is_ldb(0), .cmd(4'b0101));
         `ovm_info(get_full_name(), $psprintf("send_arm_cmd:i_token_tot_cq_cnt:=%0d ldb_pp=%0d", i, lpp[i]),OVM_DEBUG)
         send_cmd_pf(.pp_num(lpp[i]),  .qid(lqid[i]), .rpt(1), .is_ldb(1), .cmd(4'b0101));
         execute_cfg_cmds();
       end

    if(cq_occ_exp) begin
        if(i_hqm_cfg.is_pf_mode())begin
          `ovm_info(get_full_name(), $psprintf("Check cq_occ_injected"),OVM_DEBUG)
           for(int i=0; i<tot_cq_cnt; i++) begin
              dir_rd_val = dir_rd_val | (1<<dqid[i]);
              ldb_rd_val = ldb_rd_val | (1<<lpp[i]);
             `ovm_info(get_full_name(), $psprintf("dir_rd_val=0x%0x, ldb_rd_val=0x%0x", dir_rd_val, ldb_rd_val),OVM_LOW)
           end 
           fork  
            poll_reg($psprintf("dir_cq_31_0_occ_int_status"), dir_rd_val[31:0],  "hqm_system_csr");  
            poll_reg($psprintf("dir_cq_63_32_occ_int_status"), dir_rd_val[63:32], "hqm_system_csr");  
            poll_reg($psprintf("ldb_cq_31_0_occ_int_status"), ldb_rd_val[31:0],  "hqm_system_csr");  
            poll_reg($psprintf("ldb_cq_63_32_occ_int_status"), ldb_rd_val[63:32], "hqm_system_csr");  
           join 
        end
        else begin //non PF mode or sriov or iov mode
          wait_for_clk(3000);
        end    
    end //cq_occ_exp
      
      wait_for_clk(100);
         `ovm_info(get_full_name(), $psprintf("send_arm_cmd:-- Complete"),OVM_LOW)
endtask: send_arm_cmd



task hcw_cq_threshold_0_seq::trigger_msix();
 `ovm_info(get_full_name(), $psprintf("trigger_msix:Starts"),OVM_LOW)
  for (int i=0; i< (cq_depth_val-int_depth_thrs); i++) begin
    exp_msix.trigger();
  end
 `ovm_info(get_full_name(), $psprintf("trigger_msix:complets") ,OVM_LOW)

endtask
`endif //HCW_CQ_THRESHOLD_0_SEQ__SV



