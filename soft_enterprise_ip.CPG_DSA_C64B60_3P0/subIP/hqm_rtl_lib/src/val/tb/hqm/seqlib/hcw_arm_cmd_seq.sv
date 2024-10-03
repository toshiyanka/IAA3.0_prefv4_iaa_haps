`ifndef HCW_ARM_CMD_SEQ__SV
`define HCW_ARM_CMD_SEQ__SV

//==========================================================//
// en_code | threshould_en | timer_enable | cq_int | cq_arm
//    1    |     yes       |    yes       | yes    |   yes 
//    1    |     yes       |    No        | yes    |   yes 
//    0    |     yes       |    yes       | No     |   yes 
//    0    |     no        |    no        | No     |   no  
//==========================================================//

class hcw_arm_cmd_seq extends hqm_base_seq;


  `ovm_sequence_utils(hcw_arm_cmd_seq, sla_sequencer)

   // hqm_cfg                                      i_hqm_cfg;
    extern function                  new                                (string name = "hcw_arm_cmd_seq");
    extern task                      body                               ();
    extern task                      dir_cq_thre_intr_check             ( bit [7:0] dqid[0:3]);
    extern task                      dir_cq_timer_intr_check            ( input bit [7:0] dqid[4:7]);
    extern task                      dir_cq_en_mode_0_check             ( bit [7:0] dqid[8:11]);
    extern task                      dir_cq_intr_dis_check              ( bit [7:0] dqid[12:15]);
    extern task                      ldb_cq_thre_intr_check             ( bit [7:0] lpp[0:3],   bit [7:0] lqid[0:3]);
    extern task                      ldb_cq_timer_intr_check            ( bit [7:0] lpp[4:7],   bit [7:0] lqid[4:7]);
    extern task                      ldb_cq_en_mode_0_check             ( bit [7:0] lpp[8:11],  bit [7:0] lqid[8:11]);
    extern task                      ldb_cq_intr_dis_check              ( bit [7:0] lpp[12:15], bit [7:0] lqid[12:15]);

    extern task                      vf_dir_cq_thre_timer_intr_check    ( bit [7:0] dqid[0:3],  bit [3:0] vf[0:3]);
    extern task                      vf_dir_cq_en_mode_0_check          ( bit [7:0] dqid[4:7],  bit [3:0] vf[4:4]);
    extern task                      vf_ldb_cq_thre_timer_intr_check    ( bit [7:0] lpp[0:3],   bit [7:0] lqid[0:3], bit [3:0] vf[0:3]);
    extern task                      vf_ldb_cq_en_mode_0_check          ( bit [7:0] lpp[4:7],   bit [7:0] lqid[4:7], bit [3:0] vf[4:4]);
    extern task                      vf_dir_ldb_cq_intr_dis_check       ( bit [7:0] dqid[12:13], bit [7:0] lqid[12:13], bit [7:0] lpp[12:13], bit [3:0] vf[5:5]);

endclass : hcw_arm_cmd_seq


function hcw_arm_cmd_seq::new(string name = "hcw_arm_cmd_seq");
  super.new(name);
endfunction

task hcw_arm_cmd_seq::body();

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
      bit [3:0]      vf[16];
      bit [31:0]     exp_synd_val;
    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);
    get_hqm_cfg();

    // -- Start traffic with the default bus number for VF and PF
    ovm_report_info(get_full_name(), $psprintf("Starting traffic on HQM "), OVM_LOW);

     // -- get the DIR/PP QID Number
     for (int i=0;i<16;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("DQID%0d",i),dqid[i])) begin
          `ovm_info(get_full_name(), $psprintf("Logical DIR PP %0d maps to physical PP %0d",i,dqid[i]),OVM_DEBUG)
        end else begin
         `ovm_error(get_full_name(), $psprintf("DQID%0d name not found in hqm_cfg",i))
        end
     end //:dir_qid_num 
     // -- get the LDB QID Number
     for (int i=0;i<16;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("LQID%0d",i),lqid[i])) begin
          `ovm_info(get_full_name(), $psprintf("Logical LDB QID %0d maps to physical QID %0d",i,lqid[i]),OVM_DEBUG)
        end else begin
         `ovm_error(get_full_name(), $psprintf("LQID%0d name not found in hqm_cfg",i))
        end
     end //:ldb qid_num 
     // -- get the LDB PP Number
     for (int i=0;i<16;i++) begin //:dir_qid num
        if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",i),lpp[i])) begin
          `ovm_info(get_full_name(), $psprintf("Logical LDB PP %0d maps to physical PP %0d",i,lpp[i]),OVM_DEBUG)
        end else begin
         `ovm_error(get_full_name(), $psprintf("LPP%0d name not found in hqm_cfg",i))
        end
     end //:ldb qid_num 
     // -- get the LDB PP Number
     if($test$plusargs("VF_ARM_PP_CHK"))begin
      for (int i=0;i<6 ;i++) begin //:dir_qid num
         if (i_hqm_cfg.get_name_val($psprintf("VF%0d",i),vf[i])) begin
           `ovm_info(get_full_name(), $psprintf("Logical VF %0d maps to physical VF %0d",i,vf[i]),OVM_DEBUG)
         end else begin
          `ovm_error(get_full_name(), $psprintf("VF%0d name not found in hqm_cfg",i))
         end
      end //:ldb qid_num 
    end  

     wait_for_clk(10);
     if($test$plusargs("ARM_DIR_PP_CHK"))begin
        dir_cq_thre_intr_check(.dqid({dqid[0],dqid[1],dqid[2],dqid[3]}));
        dir_cq_timer_intr_check(.dqid({dqid[4],dqid[5],dqid[6],dqid[7]}));
        dir_cq_en_mode_0_check(.dqid({dqid[8],dqid[9],dqid[10],dqid[11]}));
        dir_cq_intr_dis_check(.dqid({dqid[12],dqid[13],dqid[14],dqid[15]}));
     end else if($test$plusargs("ARM_LDB_PP_CHK"))begin
        ldb_cq_thre_intr_check(.lqid({lqid[0],lqid[1],lqid[2],lqid[3]}), .lpp({lpp[0],lpp[1],lpp[2],lpp[3]}));
        ldb_cq_timer_intr_check(.lqid({lqid[4],lqid[5],lqid[6],lqid[7]}), .lpp({lpp[4],lpp[5],lpp[6],lpp[7]}));
        ldb_cq_en_mode_0_check(.lqid({lqid[8],lqid[9],lqid[10],lqid[11]}), .lpp({lpp[8],lpp[9],lpp[10],lpp[11]}));
        ldb_cq_intr_dis_check(.lqid({lqid[12],lqid[13],lqid[14],lqid[15]}), .lpp({lpp[12],lpp[13],lpp[14],lpp[15]}));
     end else if($test$plusargs("VF_ARM_PP_CHK"))begin
      if($test$plusargs("VF_TIMER_THRE"))begin
        vf_dir_cq_thre_timer_intr_check(.dqid({dqid[0],dqid[1],dqid[2],dqid[3]}), .vf({vf[0],vf[1],vf[2],vf[3]}));
        vf_ldb_cq_thre_timer_intr_check(.lqid({lqid[0],lqid[1],lqid[2],lqid[3]}), .lpp({lpp[0],lpp[1],lpp[2],lpp[3]}), .vf({vf[0],vf[1],vf[2],vf[3]}));
      end
      if($test$plusargs("VF_ENCODE_0"))begin
        vf_dir_cq_en_mode_0_check(.dqid({dqid[4],dqid[5],dqid[6],dqid[7]}), .vf(vf[4:4]));
        vf_ldb_cq_en_mode_0_check(.lpp({lpp[4],lpp[5],lpp[6],lpp[7]}), .lqid({lqid[4],lqid[5],lqid[6],lqid[7]}), .vf(vf[4:4]));
      end
      if($test$plusargs("VF_THRE_TIME_DISABLE"))begin
        vf_dir_ldb_cq_intr_dis_check(.dqid({dqid[12],dqid[13]}), .lqid({lqid[12],lqid[13]}), .lpp({lpp[12],lpp[13]}), .vf(vf[5:5]));
      end
     end
  endtask: body

  task hcw_arm_cmd_seq::dir_cq_thre_intr_check( bit [7:0] dqid[0:3] );
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]     rd_val;

    `ovm_info(get_full_name(), $psprintf("dir_dqid[0]=0x%0x dir_qid[3]=0x%0x", dqid[0],dqid[3] ),OVM_DEBUG)
     ovm_report_info(get_full_name(), $psprintf(" -- dir_cq_thre_intr_check:send_traffic start"), OVM_LOW);
     send_new_pf(.pp_num(dqid[0]), .qid(dqid[0]), .rpt(15), .is_ldb(0));
     send_new_pf(.pp_num(dqid[1]), .qid(dqid[1]), .rpt(15), .is_ldb(0));
     send_new_pf(.pp_num(dqid[2]), .qid(dqid[2]), .rpt(15), .is_ldb(0));
     send_new_pf(.pp_num(dqid[3]), .qid(dqid[3]), .rpt(15), .is_ldb(0));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(dqid[0]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[1]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[2]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[3]), .exp_cnt(15), .is_ldb(0) ); 
    
     // -- check cq_occ int status reg
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("dir_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("dir_cq_31_0_occ_int_status=0x%0x,dir_cq_63_32_occ_int_status=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     // -- indexing of cq 
     if ( rd_val[dqid[0]] && rd_val[dqid[3]]) begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt generated as expected for cq0[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[0],rd_val[dqid[0]], dqid[3],rd_val[dqid[3]]),OVM_LOW)
     end
     else begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt not generated for cq0[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[0],rd_val[dqid[0]],dqid[3],rd_val[dqid[3]]))
     end
    
     // -- check no other cq intr is set TODO
     
     //-- check cq intr armed is cleared for cq dqid[0] & dqid[3] 
     read_reg("cfg_dir_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_dir_cq_intr_armed0=0x%0x, cfg_dir_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32]),OVM_DEBUG)
     if (rd_val[dqid[0]] || rd_val[dqid[3]]) begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt_arm reg not cleared for cq0[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[0],rd_val[dqid[0]],dqid[3], rd_val[dqid[3]]))
     end
     else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg is cleared as expected for cq0[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[0],rd_val[dqid[0]],dqid[3],rd_val[dqid[3]]),OVM_LOW)
     end
     
     //-- token return  
     send_bat_t_pf(.pp_num(dqid[0]), .tkn_cnt(14), .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[1]), .tkn_cnt(14), .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[2]), .tkn_cnt(14), .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[3]), .tkn_cnt(14), .is_ldb(0));
    
    //-- clear cq_occ 
     write_reg("dir_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("dir_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

      ovm_report_info(get_full_name(), $psprintf(" -- send_traffic finished"), OVM_LOW);
  endtask:dir_cq_thre_intr_check

  //-- timer interrupt on cq[4:5]
  task hcw_arm_cmd_seq::dir_cq_timer_intr_check(input  bit [7:0] dqid[4:7] );
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]     rd_val;
    `ovm_info(get_full_name(), $psprintf("dir_dqid[4]=0x%0x dir_dqid[5]=0x%0x", dqid[4],dqid[5] ),OVM_DEBUG)
    `ovm_info(get_full_name(), $psprintf("dir_dqid[6]=0x%0x dir_dqid[7]=0x%0x", dqid[6],dqid[7] ),OVM_DEBUG)
     ovm_report_info(get_full_name(), $psprintf(" -- dir_cq_timer_intr_check:send_traffic start"), OVM_DEBUG);
     send_new_pf(.pp_num(dqid[4]), .qid(dqid[4]), .rpt(1),  .is_ldb(0));
     send_new_pf(.pp_num(dqid[5]), .qid(dqid[5]), .rpt(1),  .is_ldb(0));
     send_new_pf(.pp_num(dqid[6]), .qid(dqid[6]), .rpt(15), .is_ldb(0));
     send_new_pf(.pp_num(dqid[7]), .qid(dqid[7]), .rpt(15), .is_ldb(0));
  
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(dqid[4]), .exp_cnt(1),  .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[5]), .exp_cnt(1),  .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[6]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[7]), .exp_cnt(15), .is_ldb(0) ); 
    
     //-- check timer started for dcq[4],dcq[5]
     read_reg("cfg_dir_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     rd_val[63:32] = rd_data;
     if (rd_val[dqid[4]] && rd_val[dqid[5]]) begin
        `ovm_info(get_full_name(), $psprintf("run timer started as expected for cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", dqid[4],rd_val[dqid[4]], dqid[5],rd_val[dqid[5]]),OVM_DEBUG)
     end else begin
        `ovm_error(get_full_name(), $psprintf("run timer not started for cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", dqid[4],rd_val[dqid[4]],dqid[5],rd_val[dqid[5]]))
     end
     //-- check other bits remains 0
     rd_val[dqid[4]] = ~rd_val[dqid[4]];
     rd_val[dqid[5]] = ~rd_val[dqid[5]];
     if (|rd_val[hqm_pkg::NUM_DIR_CQ-1:0]) begin
        `ovm_error(get_full_name(), $psprintf("run timer started for unexpected cq's timer_value=0x%0x", rd_val))
     end  
     read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[4]), rd_data, "credit_hist_pipe");  
     read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[5]), rd_data, "credit_hist_pipe");  

     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[4]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[5]), 'h0, "credit_hist_pipe");  
       

     // -- check cq_occ int status reg
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("dir_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("dir_cq_31_0_occ_int_status=0x%0x,dir_cq_63_32_occ_int_status=0x%0x", rd_val[31:0],rd_val[63:32]),OVM_DEBUG)
     // -- indexing of cq 
     if ( rd_val[dqid[4]] && rd_val[dqid[5]]) begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt generated as expected for cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", dqid[4],rd_val[dqid[4]], dqid[5],rd_val[dqid[5]]),OVM_DEBUG)
     end
     else begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt not generated for cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", dqid[4],rd_val[dqid[4]],dqid[5],rd_val[dqid[5]]))
     end
     //-- check other bits remains 0
     rd_val[dqid[4]] = ~rd_val[dqid[4]];
     rd_val[dqid[5]] = ~rd_val[dqid[5]];
     if (|(rd_val[hqm_pkg::NUM_DIR_CQ-1:0])) begin
        `ovm_error(get_full_name(), $psprintf("dir_cq_timer_intr_check:CQ-Interrupt generated for unexpected cq's=0x%0x", rd_val))
     end  
     
     //-- check cq intr armed is cleared for cq dqid[4] & dqid[5] 
     read_reg("cfg_dir_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_dir_cq_intr_armed0=0x%0x, cfg_dir_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)

     if (rd_val[dqid[4]] || rd_val[dqid[5]]) begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt_arm reg not cleared for cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", dqid[4],rd_val[dqid[4]],dqid[5], rd_val[dqid[5]]))
     end else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg is cleared as expected for cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", dqid[4],rd_val[dqid[4]],dqid[5],rd_val[dqid[5]]),OVM_LOW)
     end
     
     //-- token return  
     send_bat_t_pf(.pp_num(dqid[4]), .tkn_cnt(0),  .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[5]), .tkn_cnt(0),  .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[6]), .tkn_cnt(14), .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[7]), .tkn_cnt(14), .is_ldb(0));
    
     //-- check timer reset:Timers are stopped when cq_depth goes empty. On token return cq timer is reset to zero. 
     read_reg("cfg_dir_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     rd_val[63:32] = rd_data;
     if (rd_val[dqid[4]] || rd_val[dqid[5]]) begin
        `ovm_error(get_full_name(), $psprintf("run timer not reset post toekn return for cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", dqid[4],rd_val[dqid[4]],dqid[5],rd_val[dqid[5]]))
     end
    
    //-- clear cq_occ 
     write_reg("dir_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("dir_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

     ovm_report_info(get_full_name(), $psprintf(" --dir_cq_en_mode_0_check:send_traffic finished"), OVM_DEBUG);
  endtask:dir_cq_timer_intr_check

// --en_code-0, timer and threshold interrupt are enabled
// -- cq-intr armed but no msix, cq_occ_int sttaus not set

  task hcw_arm_cmd_seq::dir_cq_en_mode_0_check( bit [7:0] dqid[8:11] );
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]     rd_val;
 
     ovm_report_info(get_full_name(), $psprintf(" -- dir_cq_en_mode_0_check:send_traffic start"), OVM_DEBUG);
     send_new_pf(.pp_num(dqid[8]),  .qid(dqid[8]),  .rpt(1), .is_ldb(0));
     send_new_pf(.pp_num(dqid[9]),  .qid(dqid[9]),  .rpt(1), .is_ldb(0));
     send_new_pf(.pp_num(dqid[10]), .qid(dqid[10]), .rpt(15), .is_ldb(0));
     send_new_pf(.pp_num(dqid[11]), .qid(dqid[11]), .rpt(15), .is_ldb(0));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(dqid[8]),  .exp_cnt(1),  .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[9]),  .exp_cnt(1),  .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[10]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[11]), .exp_cnt(15), .is_ldb(0) ); 
   
     //-- check timer started for dcq[8],dcq[9]
     read_reg("cfg_dir_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     rd_val[63:32] = rd_data;

     if (rd_val[dqid[8]] && rd_val[dqid[9]]) begin
        `ovm_info(get_full_name(), $psprintf("run timer started as expected for cq8[%0d]=0x%0x and cq9[%0d]=0x%0x", dqid[8],rd_val[dqid[8]], dqid[9],rd_val[dqid[9]]),OVM_DEBUG)
     end else begin
        `ovm_error(get_full_name(), $psprintf("run timer not started for cq8[%0d]=0x%0x and cq9%0d]=0x%0x", dqid[8],rd_val[dqid[8]],dqid[9],rd_val[dqid[9]]))
     end
     //-- check other bits remains 0
     rd_val[dqid[8]] = ~rd_val[dqid[8]];
     rd_val[dqid[9]] = ~rd_val[dqid[9]];
     if(^rd_val[hqm_pkg::NUM_DIR_CQ-1:0]) begin
        `ovm_error(get_full_name(), $psprintf("dir_cq_en_mode_0_check:run timer started for unexpected cq's timer_value=0x%0x", rd_val))
     end  
  
     read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[8]), rd_data, "credit_hist_pipe");  
     read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[9]), rd_data, "credit_hist_pipe");  
     //-- Stop & Reset_timer();
     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[8]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[9]), 'h0, "credit_hist_pipe");  

     // -- check cq_occ int status reg
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("dir_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("dir_cq_31_0_occ_int_status=0x%0x,dir_cq_63_32_occ_int_status=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
      if(|rd_val[hqm_pkg::NUM_DIR_CQ-1:0]) begin
           `ovm_error(get_full_name(), $psprintf("dir_cq_en_mode_0_check:CQ-Interrupt generated for unexpected cq's rd_val=0x%0x", rd_val))
      end 
     //-- check cq intr armed is cleared for cq dqid[8-11]
     read_reg("cfg_dir_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_dir_cq_intr_armed0=0x%0x, cfg_dir_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     if (rd_val[dqid[8]]  || rd_val[dqid[9]] ||
         rd_val[dqid[10]] || rd_val[dqid[11]]) begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt_arm reg not cleared for cq8[%0d]=0x%0x, cq9[%0d]=0x%0x, cq10[%0d]=0x%0x and cq11[%0d]=0x%0x", dqid[8],rd_val[dqid[8]],dqid[9], rd_val[dqid[9]], dqid[10],rd_val[dqid[10]],dqid[11], rd_val[dqid[11]]))
     end
     else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg cleared as expected for cq8[%0d]=0x%0x, cq9[%0d]=0x%0x, cq10[%0d]=0x%0x and cq11[%0d]=0x%0x", dqid[8],rd_val[dqid[8]],dqid[9], rd_val[dqid[9]], dqid[10],rd_val[dqid[10]],dqid[11], rd_val[dqid[11]]),OVM_DEBUG)
     end
     
     //-- token return  
     send_bat_t_pf(.pp_num(dqid[8]),  .tkn_cnt(0),  .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[9]),  .tkn_cnt(0),  .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[10]), .tkn_cnt(14), .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[11]), .tkn_cnt(14), .is_ldb(0));
    
    //-- clear cq_occ 
     write_reg("dir_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("dir_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

     ovm_report_info(get_full_name(), $psprintf(" -- send_traffic finished"), OVM_DEBUG);
  endtask:dir_cq_en_mode_0_check


  // --en_code=2,timer and threshold interrupt not enabld 
  // -- cq[12:15]
  task hcw_arm_cmd_seq::dir_cq_intr_dis_check( bit [7:0] dqid[12:15] );
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]     rd_val;
 
    `ovm_info(get_full_name(), $psprintf("dir_dqid[12]=0x%0x dir_qid[13]=0x%0x", dqid[12],dqid[13] ),OVM_DEBUG)
     ovm_report_info(get_full_name(), $psprintf(" -- dir_cq_intr_dis_check:send_traffic start"), OVM_DEBUG);

     send_new_pf(.pp_num(dqid[12]), .qid(dqid[12]), .rpt(15), .is_ldb(0));
     send_new_pf(.pp_num(dqid[13]), .qid(dqid[13]), .rpt(15), .is_ldb(0));
     send_new_pf(.pp_num(dqid[14]), .qid(dqid[14]), .rpt(15), .is_ldb(0));
     send_new_pf(.pp_num(dqid[15]), .qid(dqid[15]), .rpt(15), .is_ldb(0));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(dqid[12]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[13]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[14]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[15]), .exp_cnt(15), .is_ldb(0) ); 

     // -- check cq_occ int status reg

     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("dir_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("dir_cq_31_0_occ_int_status=0x%0x,dir_cq_63_32_occ_int_status=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     // -- Non of the bit should get set 
     if (|rd_val[hqm_pkg::NUM_DIR_CQ-1:0]) begin
           `ovm_error(get_full_name(), $psprintf("dir_cq_intr_dis_check:Unexpected CQ-Interrupt generated for cq=0x%0x", rd_val))
     end
    /*  
     //-- check cq intr armed is not cleared for cq dqid[12:15] 
     read_reg("cfg_dir_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_dir_cq_intr_armed0=0x%0x, cfg_dir_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     //-- all cq bits position should remains set to 1
     if (!((rd_val[dqid[12]] & rd_val[dqid[13]]) && (rd_val[dqid[14]] & rd_val[dqid[15]]))) begin
           `ovm_error(get_full_name(), $psprintf("Unexpected CQ-Interrupt_arm reg cleared for cq12[%0d]=0x%0x and cq13[%0d]=0x%0x, cq14[%0d]=0x%0x and cq15[%0d]=0x%0x", dqid[12],rd_val[dqid[12]],dqid[13], rd_val[dqid[13]], dqid[14],rd_val[dqid[14]],dqid[15], rd_val[dqid[15]]))
     end
     else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg not cleared for cq12[%0d]=0x%0x and cq13[%0d]=0x%0x, cq14[%0d]=0x%0x and cq15[%0d]=0x%0x", dqid[12],rd_val[dqid[12]],dqid[13], rd_val[dqid[13]], dqid[14],rd_val[dqid[14]],dqid[15], rd_val[dqid[15]]),OVM_DEBUG)
     end
    */ 
     //-- token return  
     send_bat_t_pf(.pp_num(dqid[12]), .tkn_cnt(14), .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[13]), .tkn_cnt(14), .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[14]), .tkn_cnt(14), .is_ldb(0));
     send_bat_t_pf(.pp_num(dqid[15]), .tkn_cnt(14), .is_ldb(0));

    //-- clear cq_occ 
     write_reg("dir_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("dir_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
    
      ovm_report_info(get_full_name(), $psprintf(" -- dir_cq_intr_dis_check:send_traffic finished"), OVM_DEBUG);
  endtask:dir_cq_intr_dis_check

  task hcw_arm_cmd_seq::ldb_cq_thre_intr_check( bit [7:0] lpp[0:3], bit [7:0] lqid[0:3]);
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]     rd_val;
 
     ovm_report_info(get_full_name(), $psprintf(" -- ldb_cq_thre_intr_check:send_traffic start"), OVM_DEBUG);
     send_new_pf(.pp_num(lpp[0]), .qid(lqid[0]), .rpt(15), .is_ldb(1));
     send_new_pf(.pp_num(lpp[1]), .qid(lqid[1]), .rpt(15), .is_ldb(1));
     send_new_pf(.pp_num(lpp[2]), .qid(lqid[2]), .rpt(15), .is_ldb(1));
     send_new_pf(.pp_num(lpp[3]), .qid(lqid[3]), .rpt(15), .is_ldb(1));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(lpp[0]), .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[1]), .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[2]), .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[3]), .exp_cnt(15), .is_ldb(1) ); 
    
     // -- check cq_occ int status reg
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("ldb_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("ldb_cq_31_0_occ_int_status=0x%0x,ldb_cq_63_32_occ_int_status=0x%0x ", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     // -- indexing of cq 
     if ( rd_val[lpp[0]] & rd_val[lpp[3]]) begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt generated as expected for ldb cq0[%0d]=0x%0x and cq3[%0d]=0x%0x", lpp[0],rd_val[lpp[0]], lpp[3],rd_val[lpp[3]]),OVM_LOW)
     end
     else begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt not generated for ldb cq0[%0d]=0x%0x and cq3[%0d]=0x%0x", lpp[0],rd_val[lpp[0]],lpp[3],rd_val[lpp[3]]))
     end
    
     // -- check no other cq intr is set
      rd_val[lpp[0]] = ~rd_val[lpp[0]];
      rd_val[lpp[3]] = ~rd_val[lpp[3]];
      if(|rd_val[63:0]) begin
           `ovm_error(get_full_name(), $psprintf("ldb_cq_thre_intr_check:CQ-Interrupt generated for unexpected cq's rd_val=0x%0x", rd_val))
      end 
     
     //-- check cq intr armed is cleared for cq lpp[0] & lpp[3] 
     read_reg("cfg_ldb_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_ldb_cq_intr_armed0=0x%0x, cfg_ldb_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     if (rd_val[lpp[0]] || rd_val[lpp[3]]) begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt_arm reg not cleared for ldb cq0[%0d]=0x%0x and cq3[%0d]=0x%0x", lpp[0],rd_val[lpp[0]],lpp[3], rd_val[lpp[3]]))
     end
     else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg is cleared as expected for ldb cq0[%0d]=0x%0x and cq3[%0d]=0x%0x", lpp[0],rd_val[lpp[0]],lpp[3],rd_val[lpp[3]]),OVM_LOW)
     end
     
     //-- token return  
     send_comp_t_pf(.pp_num(lpp[0]), .rpt(15));
     send_comp_t_pf(.pp_num(lpp[1]), .rpt(15));
     send_comp_t_pf(.pp_num(lpp[2]), .rpt(15));
     send_comp_t_pf(.pp_num(lpp[3]), .rpt(15));
    
    //-- clear cq_occ 
     write_reg("ldb_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("ldb_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

      ovm_report_info(get_full_name(), $psprintf(" -- ldb_cq_thre_intr_check:send_traffic finished"), OVM_DEBUG);
  endtask:ldb_cq_thre_intr_check

  //-- timer interrupt on cq[4:5]
  task hcw_arm_cmd_seq::ldb_cq_timer_intr_check( bit [7:0] lpp[4:7], bit [7:0] lqid[4:7]);
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]     rd_val;
 
     ovm_report_info(get_full_name(), $psprintf(" -- ldb_cq_timer_intr_check:send_traffic start"), OVM_DEBUG);
     send_new_pf(.pp_num(lpp[4]), .qid(lqid[4]), .rpt(1),  .is_ldb(1));
     send_new_pf(.pp_num(lpp[5]), .qid(lqid[5]), .rpt(1),  .is_ldb(1));
     send_new_pf(.pp_num(lpp[6]), .qid(lqid[6]), .rpt(15), .is_ldb(1));
     send_new_pf(.pp_num(lpp[7]), .qid(lqid[7]), .rpt(15), .is_ldb(1));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(lpp[4]), .exp_cnt(1),  .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[5]), .exp_cnt(1),  .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[6]), .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[7]), .exp_cnt(15), .is_ldb(1) ); 
    
     //-- check timer started for lcq[4],lcq[5]
     read_reg("cfg_ldb_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     rd_val[63:32] = rd_data;
     if (rd_val[lpp[4]]&rd_val[lpp[5]]) begin
        `ovm_info(get_full_name(), $psprintf("run timer started as expected for ldb cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", lpp[4],rd_val[lpp[4]], lpp[5],rd_val[lpp[5]]),OVM_DEBUG)
     end else begin
        `ovm_error(get_full_name(), $psprintf("run timer not started for ldb cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", lpp[4],rd_val[lpp[4]],lpp[5],rd_val[lpp[5]]))
     end
     //-- check other bits remains 0
     rd_val[lpp[4]] = ~rd_val[lpp[4]];
     rd_val[lpp[5]] = ~rd_val[lpp[5]];
     if (|rd_val[63:0]) begin
        `ovm_error(get_full_name(), $psprintf("ldb_cq_timer_intr_check:run timer started for unexpected ldb cq's timer_value=0x%0x", rd_val))
     end  
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[4]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[5]), 'h0, "credit_hist_pipe");  
       
     // -- check cq_occ int status reg
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("ldb_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("ldb_cq_31_0_occ_int_status=0x%0x,ldb_cq_63_32_occ_int_status=0x%0x ", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     // -- indexing of cq 
     if ( rd_val[lpp[4]] & rd_val[lpp[5]]) begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt generated as expected for ldb cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", lpp[4],rd_val[lpp[4]], lpp[5],rd_val[lpp[5]]),OVM_LOW)
     end
     else begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt not generated for ldb cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", lpp[4],rd_val[lpp[4]],lpp[5],rd_val[lpp[5]]))
     end
    
     // -- check no other cq intr is set
      rd_val[lpp[4]] = ~rd_val[lpp[4]];
      rd_val[lpp[5]] = ~rd_val[lpp[5]];
      if(|rd_val[63:0]) begin
           `ovm_error(get_full_name(), $psprintf("ldb_cq_timer_intr_check:CQ-Interrupt generated for unexpected ldb cq's rd_val=0x%0x", rd_val))
      end 
     
     //-- check cq intr armed is cleared for cq lpp[4] & lpp[7] 
     read_reg("cfg_ldb_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_ldb_cq_intr_armed0=0x%0x, cfg_ldb_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     if (rd_val[lpp[4]] | rd_val[lpp[5]]) begin
           `ovm_error(get_full_name(), $psprintf("ldb_cq_timer_intr_check:CQ-Interrupt_arm reg not cleared for ldb cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", lpp[4],rd_val[lpp[4]],lpp[5], rd_val[lpp[5]]))
     end
     else begin
           `ovm_info(get_full_name(), $psprintf("ldb_cq_timer_intr_check:CQ-Interrupt_arm reg is cleared as expected for ldb cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", lpp[4],rd_val[lpp[4]],lpp[5],rd_val[lpp[5]]),OVM_LOW)
     end
     
     //-- token return  
     send_comp_t_pf(.pp_num(lpp[4]), .rpt(1));
     send_comp_t_pf(.pp_num(lpp[5]), .rpt(1));
     send_comp_t_pf(.pp_num(lpp[6]), .rpt(15));
     send_comp_t_pf(.pp_num(lpp[7]), .rpt(15));
    
    //-- clear cq_occ 
     write_reg("ldb_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("ldb_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

     ovm_report_info(get_full_name(), $psprintf(" -- ldb_cq_timer_intr_check:send_traffic finished"), OVM_DEBUG);
  endtask:ldb_cq_timer_intr_check

  // --en_code-0, timer and threshold interrupt are enabled
  // -- cq-intr armed but no msix
  task hcw_arm_cmd_seq::ldb_cq_en_mode_0_check( bit [7:0] lpp[8:11], bit [7:0] lqid[8:11]);
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]     rd_val;
 
     ovm_report_info(get_full_name(), $psprintf(" -- ldb_cq_en_mode_0_check:send_traffic start"), OVM_DEBUG);
     send_new_pf(.pp_num(lpp[8]),  .qid(lqid[8]),  .rpt(1),  .is_ldb(1));
     send_new_pf(.pp_num(lpp[9]),  .qid(lqid[9]),  .rpt(1),  .is_ldb(1));
     send_new_pf(.pp_num(lpp[10]), .qid(lqid[10]), .rpt(15), .is_ldb(1));
     send_new_pf(.pp_num(lpp[11]), .qid(lqid[11]), .rpt(15), .is_ldb(1));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(lpp[8]),  .exp_cnt(1), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[9]),  .exp_cnt(1), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[10]), .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[11]), .exp_cnt(15), .is_ldb(1) ); 
    
     //-- check timer started for lcq[8],lcq[9]
     read_reg("cfg_ldb_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     rd_val[63:32] = rd_data;
     if (rd_val[lpp[8]]&rd_val[lpp[9]]) begin
        `ovm_info(get_full_name(), $psprintf("run timer started as expected for ldb cq8[%0d]=0x%0x and cq9[%0d]=0x%0x", lpp[8],rd_val[lpp[8]], lpp[9],rd_val[lpp[9]]),OVM_DEBUG)
     end else begin
        `ovm_error(get_full_name(), $psprintf("run timer not started for ldb cq8[%0d]=0x%0x and cq9[%0d]=0x%0x", lpp[8],rd_val[lpp[8]],lpp[9],rd_val[lpp[9]]))
     end
     //-- check other bits remains 0
     rd_val[lpp[8]] = ~rd_val[lpp[8]];
     rd_val[lpp[9]] = ~rd_val[lpp[9]];
     if (|rd_val[hqm_pkg::NUM_LDB_CQ-1:0]) begin
        `ovm_error(get_full_name(), $psprintf("ldb_cq_en_mode_0_check:run timer started for unexpected ldb cq's timer_value=0x%0x", rd_val))
     end  
     //-- Stop & Reset_timer();
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[8]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[9]), 'h0, "credit_hist_pipe");  
       
     // -- check cq_occ int status reg
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("ldb_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("ldb_cq_31_0_occ_int_status=0x%0x,ldb_cq_63_32_occ_int_status=0x%0x ", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
      if(|rd_val[hqm_pkg::NUM_LDB_CQ-1:0]) begin
           `ovm_error(get_full_name(), $psprintf("ldb_cq_en_mode_0_check:CQ-Interrupt generated for unexpected cq's rd_val=0x%0x", rd_val))
      end 
     
     //-- check cq intr armed is cleared for cq lpp[8:11] 
     read_reg("cfg_ldb_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_ldb_cq_intr_armed0=0x%0x, cfg_ldb_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     if ((rd_val[lpp[8]] | rd_val[lpp[9]]) ||
         (rd_val[lpp[10]] | rd_val[lpp[11]])) begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt_arm reg not cleared for ldb cq8[%0d]=0x%0x, cq9[%0d]=0x%0x, cq10[%0d]=0x%0x and cq11[%0d]=0x%0x", lpp[8],rd_val[lpp[8]],lpp[9], rd_val[lpp[9]], lpp[10],rd_val[lpp[10]],lpp[11], rd_val[lpp[11]]))
     end
     else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg is cleared as expected for ldb cq8[%0d]=0x%0x, cq9[%0d]=0x%0x, cq10[%0d]=0x%0x and cq11[%0d]=0x%0x", lpp[8],rd_val[lpp[8]],lpp[9], rd_val[lpp[9]], lpp[10],rd_val[lpp[10]],lpp[11], rd_val[lpp[11]]),OVM_DEBUG)
     end
     
     //-- token return  
     send_comp_t_pf(.pp_num(lpp[8]),  .rpt(1));
     send_comp_t_pf(.pp_num(lpp[9]),  .rpt(1));
     send_comp_t_pf(.pp_num(lpp[10]), .rpt(15));
     send_comp_t_pf(.pp_num(lpp[11]), .rpt(15));
    
    //-- clear cq_occ 
     write_reg("ldb_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("ldb_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

     ovm_report_info(get_full_name(), $psprintf(" -- ldb_cq_en_mode_0_check:send_traffic finished"), OVM_DEBUG);
  endtask:ldb_cq_en_mode_0_check


  // --en_code=2,timer and threshold interrupt not enabld 
  // -- cq[12:15]
  task hcw_arm_cmd_seq::ldb_cq_intr_dis_check( bit [7:0] lpp[12:15], bit [7:0] lqid[12:15]);
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]     rd_val;
 
     ovm_report_info(get_full_name(), $psprintf(" -- ldb_cq_intr_dis_check:send_traffic start"), OVM_DEBUG);
     write_reg("ldb_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("ldb_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

     send_new_pf(.pp_num(lpp[12]), .qid(lqid[12]), .rpt(15), .is_ldb(1));
     send_new_pf(.pp_num(lpp[13]), .qid(lqid[13]), .rpt(15), .is_ldb(1));
     send_new_pf(.pp_num(lpp[14]), .qid(lqid[14]), .rpt(15), .is_ldb(1));
     send_new_pf(.pp_num(lpp[15]), .qid(lqid[15]), .rpt(15), .is_ldb(1));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(lpp[12]), .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[13]), .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[14]), .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[15]), .exp_cnt(15), .is_ldb(1) ); 

     // -- check cq_occ int status reg

     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("ldb_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("ldb_cq_31_0_occ_int_status=0x%0x,ldb_cq_63_32_occ_int_status=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     // -- Non of the bit should get set 
     if (|rd_val[63:0]) begin
           `ovm_error(get_full_name(), $psprintf("ldb_cq_intr_dis_check:Unexpected CQ-Interrupt generated for ldb cq's=0x%0x", rd_val))
     end
   
    // arm will not set if timer/threshold interrupt not set, so avoide following check

    /*
     //-- check cq intr armed is not cleared for cq lpp[12:15] 
     read_reg("cfg_ldb_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_ldb_cq_intr_armed0=0x%0x, cfg_ldb_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     //-- all cq bits position should remains set to 1
     if (!((rd_val[lpp[12]] & rd_val[lpp[13]]) &&
          (rd_val[lpp[14]] & rd_val[lpp[15]]))) begin
           `ovm_error(get_full_name(), $psprintf("Unexpected CQ-Interrupt_arm reg cleared for ldb cq12[%0d]=0x%0x and cq13[%0d]=0x%0x, cq14[%0d]=0x%0x and cq15[%0d]=0x%0x", lpp[12],rd_val[lpp[12]],lpp[13], rd_val[lpp[13]], lpp[14],rd_val[lpp[14]],lpp[15], rd_val[lpp[15]]))
     end
     else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg not cleared for ldb cq12[%0d]=0x%0x and cq13[%0d]=0x%0x, cq14[%0d]=0x%0x and cq15[%0d]=0x%0x", lpp[12],rd_val[lpp[12]],lpp[13], rd_val[lpp[13]], lpp[14],rd_val[lpp[14]],lpp[15], rd_val[lpp[15]]),OVM_DEBUG)
     end
     */
     //-- token return  
     send_comp_t_pf(.pp_num(lpp[12]), .rpt(15));
     send_comp_t_pf(.pp_num(lpp[13]), .rpt(15));
     send_comp_t_pf(.pp_num(lpp[14]), .rpt(15));
     send_comp_t_pf(.pp_num(lpp[15]), .rpt(15));
    
    //-- clear cq_occ 
     write_reg("ldb_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("ldb_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

      ovm_report_info(get_full_name(), $psprintf(" -- ldb_cq_intr_dis_check:send_traffic finished"), OVM_DEBUG);
  endtask:ldb_cq_intr_dis_check

  //threshold-cq[0,2], timer[1,3] 
  task hcw_arm_cmd_seq::vf_dir_cq_thre_timer_intr_check( bit [7:0] dqid[0:3], bit [3:0] vf[0:3] );
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]     rd_val;
 
    `ovm_info(get_full_name(), $psprintf("dir_dqid[0]=0x%0x dir_qid[3]=0x%0x", dqid[0],dqid[3] ),OVM_DEBUG)
     ovm_report_info(get_full_name(), $psprintf(" -- vf_dir_cq_thre_timer_intr_check:send_traffic start"), OVM_DEBUG);
     send_new(.vf_num(vf[0]), .pp_num(0), .qid(0), .rpt(15), .is_ldb(0));
     send_new(.vf_num(vf[1]), .pp_num(1), .qid(1), .rpt(14), .is_ldb(0));
     send_new(.vf_num(vf[2]), .pp_num(2), .qid(2), .rpt(15), .is_ldb(0));
     send_new(.vf_num(vf[3]), .pp_num(3), .qid(3), .rpt(14), .is_ldb(0));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(dqid[0]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[1]), .exp_cnt(14), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[2]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[3]), .exp_cnt(14), .is_ldb(0) ); 

     //-- check timer started for dcq[1],dcq[3]
     read_reg("cfg_dir_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     rd_val[63:32] = rd_data;
     if (rd_val[dqid[1]] && rd_val[dqid[3]]) begin
        `ovm_info(get_full_name(), $psprintf("run timer started as expected for dir cq1[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[1],rd_val[dqid[1]], dqid[3],rd_val[dqid[3]]),OVM_DEBUG)
     end else begin
        `ovm_error(get_full_name(), $psprintf("vf_dir_cq_thre_timer_intr_check:run timer not started for dir cq1[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[1],rd_val[dqid[1]],dqid[3],rd_val[dqid[3]]))
     end
     //-- check other bits remains 0
     rd_val[dqid[1]] = ~rd_val[dqid[1]];
     rd_val[dqid[3]] = ~rd_val[dqid[3]];
     if (|rd_val[hqm_pkg::NUM_DIR_CQ-1:0]) begin
        `ovm_error(get_full_name(), $psprintf("vf_dir_cq_thre_timer_intr_check:run timer started for unexpected cq's timer_value=0x%0x", rd_val))
     end  
     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[1]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[3]), 'h0, "credit_hist_pipe");  
   /* 
     // -- check cq_occ int status reg
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("dir_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("dir_cq_31_0_occ_int_status=0x%0x,dir_cq_63_32_occ_int_status=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     // -- indexing of cq 
     if (( rd_val[dqid[0]] & rd_val[dqid[1]]) && 
         (rd_val[dqid[2]] & rd_val[dqid[3]])) begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt generated as expected for cq0[%0d]=0x%0x and cq1[%0d]=0x%0x, cq2[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[0],rd_val[dqid[0]], dqid[1],rd_val[dqid[1]],dqid[2],rd_val[dqid[2]], dqid[3],rd_val[dqid[3]]),OVM_DEBUG)
     end else begin
           `ovm_error(get_full_name(), $psprintf("vf_dir_cq_thre_timer_intr_check:CQ-Interrupt not generated for cq0[%0d]=0x%0x and cq1[%0d]=0x%0x, cq2[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[0],rd_val[dqid[0]],dqid[1],rd_val[dqid[1]], dqid[2],rd_val[dqid[2]],dqid[3],rd_val[dqid[3]]))
     end
      */
     //-- check cq intr armed is cleared for cq dqid[0] & dqid[3] 
     read_reg("cfg_dir_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_dir_cq_intr_armed0=0x%0x, cfg_dir_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     if ((rd_val[dqid[0]] | rd_val[dqid[1]]) ||
         (rd_val[dqid[2]] | rd_val[dqid[3]])) begin
           `ovm_error(get_full_name(), $psprintf("vf_dir_cq_thre_timer_intr_check:CQ-Interrupt_arm reg not cleared for cq0[%0d]=0x%0x and cq1[%0d]=0x%0x, cq2[%0d]=0x%0x and cq3[%0d]=0x%0x", dqid[0],rd_val[dqid[0]],dqid[1], rd_val[dqid[1]], dqid[2],rd_val[dqid[2]],dqid[3], rd_val[dqid[3]]))
     end
     else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg is cleared as expected for cq[3:0]=0x%0x ", rd_val),OVM_DEBUG)
     end
     
     //-- token return #tkn_cnt(0) means 1 token  
     send_bat_t(.vf_num(vf[0]), .pp_num(0), .tkn_cnt(14), .is_ldb(0));
     send_bat_t(.vf_num(vf[1]), .pp_num(1), .tkn_cnt(13), .is_ldb(0));
     send_bat_t(.vf_num(vf[2]), .pp_num(2), .tkn_cnt(14), .is_ldb(0));
     send_bat_t(.vf_num(vf[3]), .pp_num(3), .tkn_cnt(13), .is_ldb(0));
    
    //-- clear cq_occ 
     write_reg("dir_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("dir_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

     ovm_report_info(get_full_name(), $psprintf(" -- vf_dir_cq_thre_timer_intr_check:send_traffic finished"), OVM_DEBUG);
  endtask:vf_dir_cq_thre_timer_intr_check

  // -- ldb threshold cq[1,3] timer[0,2]
  task hcw_arm_cmd_seq::vf_ldb_cq_thre_timer_intr_check( bit [7:0] lpp[0:3], bit [7:0] lqid[0:3], bit [3:0] vf[0:3]);
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]     rd_val;
 
     ovm_report_info(get_full_name(), $psprintf(" -- vf_ldb_cq_thre_timer_intr_check:send_traffic start"), OVM_DEBUG);
     send_new(.vf_num(vf[0]), .pp_num(0), .qid(0), .rpt(1), .is_ldb(1));
     send_new(.vf_num(vf[1]), .pp_num(1), .qid(1), .rpt(15), .is_ldb(1));
     send_new(.vf_num(vf[2]), .pp_num(2), .qid(2), .rpt(1), .is_ldb(1));
     send_new(.vf_num(vf[3]), .pp_num(3), .qid(3), .rpt(15), .is_ldb(1));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(lpp[0]), .exp_cnt(1), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[1]), .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[2]), .exp_cnt(1), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[3]), .exp_cnt(15), .is_ldb(1) ); 
      
     wait_for_clk(10);
     //-- check timer started for lcq[0],lcq[2]
     read_reg("cfg_ldb_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     rd_val[63:32] = rd_data;
     if (rd_val[lpp[0]]&rd_val[lpp[2]]) begin
        `ovm_info(get_full_name(), $psprintf("run timer started as expected for ldb cq0[%0d]=0x%0x and cq2[%0d]=0x%0x", lpp[0],rd_val[lpp[0]], lpp[2],rd_val[lpp[2]]),OVM_DEBUG)
     end else begin
        `ovm_error(get_full_name(), $psprintf("vf_ldb_cq_thre_timer_intr_check:run timer not started for ldb cq0[%0d]=0x%0x and cq2[%0d]=0x%0x", lpp[0],rd_val[lpp[0]],lpp[2],rd_val[lpp[2]]))
     end
     //-- check other bits remains 0
     rd_val[lpp[0]] = ~rd_val[lpp[0]];
     rd_val[lpp[2]] = ~rd_val[lpp[2]];
     if (|rd_val[63:0]) begin
        `ovm_error(get_full_name(), $psprintf("ldb_cq_timer_intr_check:run timer started for unexpected ldb cq's timer_value=0x%0x", rd_val))
     end  
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[0]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[2]), 'h0, "credit_hist_pipe");  
      
    /* 
     // -- check cq_occ int status reg
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("ldb_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("ldb_cq_31_0_occ_int_status=0x%0x,ldb_cq_63_32_occ_int_status=0x%0x ", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     // -- indexing of cq 
     if ((rd_val[lpp[0]] & rd_val[lpp[1]]) && (rd_val[lpp[2]] & rd_val[lpp[3]])) begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt generated as expected for ldb cq0[%0d]=0x%0x and cq1[%0d]=0x%0x, cq2[%0d]=0x%0x and cq3[%0d]=0x%0x", lpp[0],rd_val[lpp[0]], lpp[1],rd_val[lpp[1]], lpp[2],rd_val[lpp[2]], lpp[3],rd_val[lpp[3]]),OVM_DEBUG)
     end else begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt not generated for ldb cq[3:0]=0x%0x", rd_val))
     end
    
     // -- check no other cq intr is set
      rd_val[lpp[0]] = ~rd_val[lpp[0]];
      rd_val[lpp[1]] = ~rd_val[lpp[1]];
      rd_val[lpp[2]] = ~rd_val[lpp[2]];
      rd_val[lpp[3]] = ~rd_val[lpp[3]];
      if(|rd_val[hqm_pkg::NUM_LDB_CQ-1:0]) begin
           `ovm_error(get_full_name(), $psprintf("vf_ldb_cq_thre_timer_intr_check:CQ-Interrupt generated for unexpected cq's rd_val=0x%0x", rd_val))
      end 
    */ 
     //-- check cq intr armed is cleared for cq lpp[0:3] 
     read_reg("cfg_ldb_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_ldb_cq_intr_armed0=0x%0x, cfg_ldb_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     if ((rd_val[lpp[0]] | rd_val[lpp[1]]) || (rd_val[lpp[2]] | rd_val[lpp[3]])) begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt_arm reg not cleared for ldb cq0[%0d]=0x%0x and cq1[%0d]=0x%0x, cq2[%0d]=0x%0x and cq3[%0d]=0x%0x", lpp[0],rd_val[lpp[0]],lpp[1], rd_val[lpp[1]], lpp[2],rd_val[lpp[2]],lpp[3], rd_val[lpp[3]]))
     end
     else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg is cleared as expected for ldb cq[0:3]=0x%0x", rd_val),OVM_LOW)
     end
     
     //-- token return  
     send_comp_t(.vf_num(vf[0]), .pp_num(0), .rpt(1));
     send_comp_t(.vf_num(vf[1]), .pp_num(1), .rpt(15));
     send_comp_t(.vf_num(vf[2]), .pp_num(2), .rpt(1));
     send_comp_t(.vf_num(vf[3]), .pp_num(3), .rpt(15));
    
    //-- clear cq_occ 
     write_reg("ldb_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("ldb_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

      ovm_report_info(get_full_name(), $psprintf(" -- vf_ldb_cq_thre_timer_intr_check:send_traffic finished"), OVM_DEBUG);
  endtask:vf_ldb_cq_thre_timer_intr_check

//-- en_code=0, 
task hcw_arm_cmd_seq::vf_dir_cq_en_mode_0_check( bit [7:0] dqid[4:7], bit [3:0] vf[4:4] );
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]     rd_val;
 
     ovm_report_info(get_full_name(), $psprintf(" -- vf_dir_cq_en_mode_0_check:send_traffic start"), OVM_DEBUG);
     send_new(.vf_num(vf[4]), .pp_num(4),  .qid(4), .rpt(1),  .is_ldb(0));
     send_new(.vf_num(vf[4]), .pp_num(5),  .qid(5), .rpt(1),  .is_ldb(0));
     send_new(.vf_num(vf[4]), .pp_num(6),  .qid(6), .rpt(15), .is_ldb(0));
     send_new(.vf_num(vf[4]), .pp_num(7),  .qid(7), .rpt(15), .is_ldb(0));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(dqid[4]), .exp_cnt(1),  .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[5]), .exp_cnt(1),  .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[6]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[7]), .exp_cnt(15), .is_ldb(0) ); 
   
     //-- check timer started for dcq[8],dcq[9]
     read_reg("cfg_dir_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     rd_val[63:32] = rd_data;

     if (rd_val[dqid[4]] && rd_val[dqid[5]]) begin
        `ovm_info(get_full_name(), $psprintf("run timer started as expected for cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", dqid[4],rd_val[dqid[4]], dqid[5],rd_val[dqid[5]]),OVM_DEBUG)
     end else begin
        `ovm_error(get_full_name(), $psprintf("run timer not started for cq4[%0d]=0x%0x and cq5[%0d]=0x%0x", dqid[4],rd_val[dqid[4]],dqid[5],rd_val[dqid[5]]))
     end
     //-- check other bits remains 0
     rd_val[dqid[4]] = ~rd_val[dqid[4]];
     rd_val[dqid[5]] = ~rd_val[dqid[5]];
     if(^rd_val[hqm_pkg::NUM_DIR_CQ-1:0]) begin
        `ovm_error(get_full_name(), $psprintf("vf_dir_cq_en_mode_0_check:run timer started for unexpected cq's timer_value=0x%0x", rd_val))
     end  
  
     read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[4]), rd_data, "credit_hist_pipe");  
     read_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[5]), rd_data, "credit_hist_pipe");  
     //-- Stop & Reset_timer();
     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[4]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_dir_cq_timer_count[%0d]", dqid[5]), 'h0, "credit_hist_pipe");  

    /*
     // -- check cq_occ int status reg
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("dir_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("dir_cq_31_0_occ_int_status=0x%0x,dir_cq_63_32_occ_int_status=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
      if(|rd_val[hqm_pkg::NUM_DIR_CQ-1:0]) begin
           `ovm_error(get_full_name(), $psprintf("vf_dir_cq_en_mode_0_check:CQ-Interrupt generated for unexpected cq's rd_val=0x%0x", rd_val))
      end 
      */
     //-- check cq intr armed is cleared for cq dqid[4-11]
     read_reg("cfg_dir_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_dir_cq_intr_armed0=0x%0x, cfg_dir_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     if ((rd_val[dqid[4]] | rd_val[dqid[5]]) || (rd_val[dqid[6]] || rd_val[dqid[7]])) begin
           `ovm_error(get_full_name(), $psprintf("CQ-Interrupt_arm reg not cleared for cq4[%0d]=0x%0x, cq5[%0d]=0x%0x, cq6[%0d]=0x%0x and cq7[%0d]=0x%0x", dqid[4],rd_val[dqid[4]],dqid[5], rd_val[dqid[5]], dqid[6],rd_val[dqid[6]],dqid[7], rd_val[dqid[7]]))
     end
     else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg cleared as expected for cq4[%0d]=0x%0x, cq5[%0d]=0x%0x, cq6[%0d]=0x%0x and cq7[%0d]=0x%0x", dqid[4],rd_val[dqid[4]],dqid[5], rd_val[dqid[5]], dqid[6],rd_val[dqid[6]],dqid[7], rd_val[dqid[7]]),OVM_DEBUG)
     end
     
     //-- token return  
     send_bat_t(.vf_num(vf[4]), .pp_num(4), .tkn_cnt(0),  .is_ldb(0));
     send_bat_t(.vf_num(vf[4]), .pp_num(5), .tkn_cnt(0),  .is_ldb(0));
     send_bat_t(.vf_num(vf[4]), .pp_num(6), .tkn_cnt(14), .is_ldb(0));
     send_bat_t(.vf_num(vf[4]), .pp_num(7), .tkn_cnt(14), .is_ldb(0));
    
    //-- clear cq_occ 
     write_reg("dir_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("dir_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

     ovm_report_info(get_full_name(), $psprintf(" -- vf_dir_cq_en_mode_0_check:send_traffic finished"), OVM_DEBUG);
  endtask:vf_dir_cq_en_mode_0_check

  // --en_code-0, timer and threshold interrupt are enabled
  // -- cq-intr armed but no msix
task hcw_arm_cmd_seq::vf_ldb_cq_en_mode_0_check( bit [7:0] lpp[4:7], bit [7:0] lqid[4:7], bit [3:0] vf[4:4] );
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]     rd_val;
 
     ovm_report_info(get_full_name(), $psprintf(" -- vf_ldb_cq_en_mode_0_check:send_traffic start"), OVM_DEBUG);
     send_new(.vf_num(vf[4]), .pp_num(6),  .qid(6), .rpt(1),  .is_ldb(1));
     send_new(.vf_num(vf[4]), .pp_num(7),  .qid(7), .rpt(1),  .is_ldb(1));
     send_new(.vf_num(vf[4]), .pp_num(4),  .qid(4), .rpt(15), .is_ldb(1));
     send_new(.vf_num(vf[4]), .pp_num(5),  .qid(5), .rpt(15), .is_ldb(1));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(lpp[4]), .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[5]), .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[6]), .exp_cnt(1),  .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[7]), .exp_cnt(1),  .is_ldb(1) ); 
   
     //-- check timer started for dcq[8],dcq[9]
     read_reg("cfg_ldb_cq_intr_run_timer0",   rd_data,  "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_run_timer1",   rd_data,  "credit_hist_pipe");
     rd_val[63:32] = rd_data;

     if (rd_val[lpp[6]] & rd_val[lpp[7]]) begin
        `ovm_info(get_full_name(), $psprintf("run timer started as expected for cq6[%0d]=0x%0x and cq7[%0d]=0x%0x", lpp[4],rd_val[lpp[4]], lpp[5],rd_val[lpp[5]]),OVM_DEBUG)
     end else begin
        `ovm_error(get_full_name(), $psprintf("vf_ldb_cq_en_mode_0_check:run timer not started for cq6[%0d]=0x%0x and cq7[%0d]=0x%0x", lpp[4],rd_val[lpp[4]],lpp[5],rd_val[lpp[5]]))
     end
     //-- check other bits remains 0
     rd_val[lpp[6]] = ~rd_val[lpp[6]];
     rd_val[lpp[7]] = ~rd_val[lpp[7]];
     if(^rd_val[hqm_pkg::NUM_LDB_CQ-1:0]) begin
        `ovm_error(get_full_name(), $psprintf("vf_ldb_cq_en_mode_0_check:run timer started for unexpected cq's timer_value=0x%0x", rd_val))
     end  
  
     //-- Stop & Reset_timer();
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[6]), 'h0, "credit_hist_pipe");  
     poll_reg($psprintf("cfg_ldb_cq_timer_count[%0d]", lpp[7]), 'h0, "credit_hist_pipe");  

     /*
     // -- check cq_occ int status reg
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("ldb_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("ldb_cq_31_0_occ_int_status=0x%0x,ldb_cq_63_32_occ_int_status=0x%0xx", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
      if(|rd_val[63:0]) begin
           `ovm_error(get_full_name(), $psprintf("vf_ldb_cq_en_mode_0_check:CQ-Interrupt generated for unexpected cq's rd_val=0x%0x", rd_val))
      end 
      */
     //-- check cq intr armed is cleared for cq lpp[4-11]
     read_reg("cfg_ldb_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_ldb_cq_intr_armed0=0x%0x, cfg_ldb_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     if ((rd_val[lpp[4]] | rd_val[lpp[5]]) || (rd_val[lpp[6]] || rd_val[lpp[7]])) begin
           `ovm_error(get_full_name(), $psprintf("vf_ldb_cq_en_mode_0_check:CQ-Interrupt_arm reg not cleared for cq4[%0d]=0x%0x, cq5[%0d]=0x%0x, cq6[%0d]=0x%0x and cq7[%0d]=0x%0x", lpp[4],rd_val[lpp[4]],lpp[5], rd_val[lpp[5]], lpp[6],rd_val[lpp[6]],lpp[7], rd_val[lpp[7]]))
     end
     else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg cleared as expected for cq4[%0d]=0x%0x, cq5[%0d]=0x%0x, cq6[%0d]=0x%0x and cq7[%0d]=0x%0x", lpp[4],rd_val[lpp[4]],lpp[5], rd_val[lpp[5]], lpp[6],rd_val[lpp[6]],lpp[7], rd_val[lpp[7]]),OVM_DEBUG)
     end
     
     //-- token return  
     send_comp_t(.vf_num(vf[4]), .pp_num(6), .rpt(1));
     send_comp_t(.vf_num(vf[4]), .pp_num(7), .rpt(1));
     send_comp_t(.vf_num(vf[4]), .pp_num(4), .rpt(15));
     send_comp_t(.vf_num(vf[4]), .pp_num(5), .rpt(15));
    
    //-- clear cq_occ 
     write_reg("ldb_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("ldb_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");

     ovm_report_info(get_full_name(), $psprintf(" -- vf_ldb_cq_en_mode_0_check:send_traffic finished"), OVM_DEBUG);
  endtask:vf_ldb_cq_en_mode_0_check

  //en_code=1 and threshold and timer interrupt is disabled
  task hcw_arm_cmd_seq::vf_dir_ldb_cq_intr_dis_check( bit [7:0] dqid[12:13], bit [7:0] lqid[12:13], bit [7:0] lpp[12:13], bit [3:0] vf[5:5] );
      sla_ral_data_t rd_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]     rd_val;
 
     ovm_report_info(get_full_name(), $psprintf(" -- vf_dir_ldb_cq_intr_dis_check:send_traffic start"), OVM_DEBUG);

     send_new(.vf_num(vf[5]), .pp_num(0), .qid(0), .rpt(15), .is_ldb(0));
     send_new(.vf_num(vf[5]), .pp_num(1), .qid(1), .rpt(15), .is_ldb(0));
     send_new(.vf_num(vf[5]), .pp_num(0), .qid(0), .rpt(15), .is_ldb(1));
     send_new(.vf_num(vf[5]), .pp_num(1), .qid(1), .rpt(15), .is_ldb(1));
     execute_cfg_cmds();
     //waiting for scheduling
     poll_sch( .cq_num(dqid[12]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(dqid[13]), .exp_cnt(15), .is_ldb(0) ); 
     poll_sch( .cq_num(lpp[12]),  .exp_cnt(15), .is_ldb(1) ); 
     poll_sch( .cq_num(lpp[13]),  .exp_cnt(15), .is_ldb(1) ); 

    /*
     // -- check cq_occ int status reg
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("dir_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("dir_cq_31_0_occ_int_status=0x%0x,dir_cq_63_32_occ_int_status=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     // -- Non of the bit should get set 
     if (|rd_val[hqm_pkg::NUM_DIR_CQ-1:0]) begin
           `ovm_error(get_full_name(), $psprintf("vf_dir_ldb_cq_intr_dis_check:Unexpected CQ-Interrupt generated for cq=0x%0x", rd_val))
     end
  
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     rd_val[31:0] = rd_data;
     read_reg("ldb_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     rd_val[63:32] = rd_data;
    
    `ovm_info(get_full_name(), $psprintf("ldb_cq_31_0_occ_int_status=0x%0x,ldb_cq_63_32_occ_int_status=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     // -- Non of the bit should get set 
     if (|rd_val[hqm_pkg::NUM_LDB_CQ-1:0]) begin
           `ovm_error(get_full_name(), $psprintf("vf_dir_ldb_cq_intr_dis_check:Unexpected CQ-Interrupt generated for ldb cq's=0x%0x", rd_val))
     end

     //-- check cq intr armed is not cleared for cq dqid[12:15] 
     read_reg("cfg_dir_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_dir_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_dir_cq_intr_armed0=0x%0x, cfg_dir_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     //-- all cq bits position should remains set to 1
     if (!(rd_val[dqid[12]] && rd_val[dqid[13]])) begin
           `ovm_error(get_full_name(), $psprintf("vf_dir_ldb_cq_intr_dis_check:Unexpected CQ-Interrupt_arm reg cleared for dir cq12[%0d]=0x%0x and cq13[%0d]=0x%0x", dqid[12],rd_val[dqid[12]],dqid[13], rd_val[dqid[13]]))
     end  else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg not cleared for cq12[%0d]=0x%0x and cq13[%0d]=0x%0x", dqid[12],rd_val[dqid[12]],dqid[13], rd_val[dqid[13]]),OVM_DEBUG)
     end
    
     //-- check cq intr armed is not cleared for cq lpp[12:13] 
     read_reg("cfg_ldb_cq_intr_armed0", rd_data,   "credit_hist_pipe");
     rd_val[31:0] = rd_data;
     read_reg("cfg_ldb_cq_intr_armed1", rd_data,   "credit_hist_pipe");
     rd_val[63:32] = rd_data;
    `ovm_info(get_full_name(), $psprintf("cfg_ldb_cq_intr_armed0=0x%0x, cfg_ldb_cq_intr_armed1=0x%0x", rd_val[31:0],rd_val[63:32] ),OVM_DEBUG)
     //-- all cq bits position should remains set to 1
     if (!(rd_val[lpp[12]] && rd_val[lpp[13]])) begin 
           `ovm_error(get_full_name(), $psprintf("vf_dir_ldb_cq_intr_dis_check:Unexpected CQ-Interrupt_arm reg cleared for ldb cq12[%0d]=0x%0x and cq13[%0d]=0x%0x", lpp[12],rd_val[lpp[12]],lpp[13], rd_val[lpp[13]]))
     end else begin
           `ovm_info(get_full_name(), $psprintf("CQ-Interrupt_arm reg not cleared for ldb cq12[%0d]=0x%0x and cq13[%0d]=0x%0x", lpp[12],rd_val[lpp[12]],lpp[13], rd_val[lpp[13]]),OVM_DEBUG)
     end
     
      */
     //-- token return  
     send_bat_t(.vf_num(vf[5]), .pp_num(0), .tkn_cnt(14), .is_ldb(0));
     send_bat_t(.vf_num(vf[5]), .pp_num(1), .tkn_cnt(14), .is_ldb(0));
     //-- token and completion  return  
     send_comp_t(.vf_num(vf[5]), .pp_num(0), .rpt(15));
     send_comp_t(.vf_num(vf[5]), .pp_num(1), .rpt(15));

    //-- clear cq_occ 
     write_reg("dir_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("dir_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     write_reg("ldb_cq_31_0_occ_int_status",   '1,  "hqm_system_csr");
     write_reg("ldb_cq_63_32_occ_int_status",  '1, "hqm_system_csr");
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
    
      ovm_report_info(get_full_name(), $psprintf(" -- vf_dir_ldb_cq_intr_dis_check:send_traffic finished"), OVM_DEBUG);
  endtask:vf_dir_ldb_cq_intr_dis_check


`endif //HCW_ARM_CMD_SEQ__SV



