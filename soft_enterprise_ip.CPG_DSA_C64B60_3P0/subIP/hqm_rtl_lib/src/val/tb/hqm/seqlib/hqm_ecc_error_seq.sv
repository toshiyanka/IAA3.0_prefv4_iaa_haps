`ifndef HQM_ECC_ERROR_SEQ__SV
`define HQM_ECC_ERROR_SEQ__SV

//==========================================================//
//hqm_sb_ecc_cfg   : cq-> dqid 0-3
//==========================================================//

class hqm_ecc_error_seq extends hqm_base_seq;

  `ovm_sequence_utils(hqm_ecc_error_seq, sla_sequencer)

  int unsigned     iterations;
  bit [7:0]        tot_cq_cnt;
  bit [7:0]        dqid[4];
  bit [7:0]        lqid[4];
  bit [7:0]        lpp[4];
  bit [7:0]        cq;
  bit [3:0]        vf;
  bit [3:0]        vdev;
  string           traffic_type;
  string           return_type;
  string           error_type;
  string           err_sub_type;
  string           en_field_name = "";
  bit [31:0]       alarm_sb_ecc_err;
  bit [31:0]       alarm_mb_ecc_err;
  bit [31:0]       alarm_hw_synd;
  bit [31:0]       sbe_cnt_0 = 32'h_11;
  bit [31:0]       sbe_cnt_0_bias = 32'h_0;
  bit [31:0]       iteration_bias = 2;
  string           reg_name;
  string           field_name_q[1];
  int unsigned     num;
  int unsigned     wait_num;
  string           ecc_type;
  bit              ingressdrop;
  bit              cyclic_ecc_inj = $test$plusargs("HQM_CYCLIC_ECC_INJ");
  sla_ral_data_t   wr_data_q[1];
  sla_ral_data_t   rd_data_q[1];

  extern task      body();
  extern task      send_hcw_traffic(string hcw_type, int rpt_cnt);
  extern task      basic_sbecc_sequence();
  extern task      basic_mbecc_sequence();
  extern task      wr_bad_sbecc_sequence();
  extern task      ecc_chk_enable(bit en);
  extern task      enable_ecc_err();
  extern task      disable_ecc_err();
  extern task      clear_msix();

  function new(string name = "hqm_ecc_error_seq");
    super.new(name);
  endfunction

endclass : hqm_ecc_error_seq

task hqm_ecc_error_seq::body();
  
  ovm_report_info(get_full_name(), $psprintf("Starting sequence hqm_ecc_error_seq"), OVM_LOW);

  get_hqm_cfg();

  // This total cq count should match with the cfg cft cq count
  tot_cq_cnt = 8'd4; // default value
  ingressdrop = 1'b0; // default value

  // -- get the VF number  
  if(i_hqm_cfg.is_sriov_mode()) begin
    if (i_hqm_cfg.get_name_val("VF0",vf)) begin
      `ovm_info(get_full_name(), $psprintf("Logical VF0 maps to physical VF %0d",vf),OVM_MEDIUM)
    end else begin
     `ovm_error(get_full_name(), $psprintf("VF0 name not found in hqm_cfg"))
    end
  end //sriov_mode

  // -- get the DIR/PP QID Number
  for (int i=0;i<tot_cq_cnt;i++) begin //:dir_qid num
     if (i_hqm_cfg.get_name_val($psprintf("DQID%0d",i),dqid[i])) begin
       `ovm_info(get_full_name(), $psprintf("Logical DIR PP %0d maps to physical PP %0d",i,dqid[i]),OVM_MEDIUM)
     end else begin
      `ovm_error(get_full_name(), $psprintf("DQID%0d name not found in hqm_cfg",i))
     end
  end //:dir_qid_num

  // -- get the LDB QID Number
  for (int i=0;i<tot_cq_cnt;i++) begin //:dir_qid num
     if (i_hqm_cfg.get_name_val($psprintf("LQID%0d",i),lqid[i])) begin
       `ovm_info(get_full_name(), $psprintf("Logical LDB QID %0d maps to physical QID %0d",i,lqid[i]),OVM_MEDIUM)
     end else begin
      `ovm_error(get_full_name(), $psprintf("LQID%0d name not found in hqm_cfg",i))
     end
  end //:ldb qid_num

  // -- get the LDB PP Number
  for (int i=0;i<tot_cq_cnt;i++) begin //:dir_qid num
     if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",i),lpp[i])) begin
       `ovm_info(get_full_name(), $psprintf("Logical LDB PP %0d maps to physical PP %0d",i,lpp[i]),OVM_MEDIUM)
     end else begin
      `ovm_error(get_full_name(), $psprintf("LPP%0d name not found in hqm_cfg",i))
     end
  end //:ldb qid_num 

  // -- get the VDEV number 
  if(i_hqm_cfg.is_sciov_mode()) begin
   for (int i=0;i<1 ;i++) begin //:dir_qid num
      if (i_hqm_cfg.get_name_val("VDEV0",vdev)) begin
        `ovm_info(get_full_name(), $psprintf("Logical VDEV0 maps to physical VDEV %0d",vdev),OVM_MEDIUM)
      end else begin
       `ovm_error(get_full_name(), $psprintf("VDEV0 name not found in hqm_cfg"))
      end
   end 
  end //is_sciov_mode 

  // Type of traffic, return token or comp, cq number for sbecc error reporting
  if ($test$plusargs("LDB_TRAFFIC")) begin
      traffic_type = "LDB";
      return_type  = "LDB_COMP_RETURN";
      cq           = lpp[0]; 
      ovm_report_info(get_full_name(), $psprintf("hqm_ecc_error_seq: sbecc ldb.cq=0x%0x", cq), OVM_LOW);
  end
  else begin
      traffic_type = "DIR";
      return_type  = "DIR_TOKEN_RETURN";
      cq           = dqid[0]; 
      ovm_report_info(get_full_name(), $psprintf("hqm_ecc_error_seq: sbecc dir.cq=0x%0x", cq), OVM_LOW);
  end
  
  if (!$value$plusargs("HQM_SBECC_ERROR_TYPE=%s", error_type)) begin
      error_type = "INJ_SB_ECC_WBUF_W0_LS";
  end 

  if (!$value$plusargs("HQM_SBECC_ERROR_SUB_TYPE=%s", err_sub_type)) begin
      err_sub_type = "VPP2PP";
  end 

  if (!$value$plusargs("TRAFFIC_WAIT_IDLE=%d", wait_num)) begin
      wait_num = 300;
  end 
  ovm_report_info(get_full_name(), $psprintf("hqm_ecc_error_seq: error_type=%0s wait_num=%0d", error_type, wait_num), OVM_LOW);


  // Error injection type
  ERROR_TYPE : case (error_type)
    "INJ_SB_ECC_WBUF_W0_LS" : begin 
                                alarm_sb_ecc_err = 32'h1;
                                alarm_hw_synd = {24'h804045, cq};
                                ecc_type = "SB";
                                en_field_name = "SCH_WB_ECC_ENABLE";
                              end
    "INJ_SB_ECC_WBUF_W0_MS" : begin 
                                alarm_sb_ecc_err = 32'h2;
                                alarm_hw_synd = {24'h804145, cq};
                                ecc_type = "SB";
                                en_field_name = "SCH_WB_ECC_ENABLE";
                              end
    "INJ_SB_ECC_WBUF_W1_LS" : begin 
                                alarm_sb_ecc_err = 32'h4;
                                alarm_hw_synd = {24'h804245, cq};
                                ecc_type = "SB";
                                en_field_name = "SCH_WB_ECC_ENABLE";
                              end
    "INJ_SB_ECC_WBUF_W1_MS" : begin 
                                alarm_sb_ecc_err = 32'h8;
                                alarm_hw_synd = {24'h804345, cq};
                                ecc_type = "SB";
                                en_field_name = "SCH_WB_ECC_ENABLE";
                              end
    "INJ_SB_ECC_HCW_ENQ_LS" : begin
                                if (i_hqm_cfg.is_sriov_mode) begin
                                    cq = 0; //VPP0
                                end
                                alarm_sb_ecc_err = 32'h100;
                                alarm_hw_synd = {24'h804845, cq}; // vpp0,pp
                                ecc_type = "SB";
                                en_field_name = "HCW_ENQ_ECC_ENABLE";
                              end
    "INJ_SB_ECC_HCW_ENQ_MS" : begin 
                                if (i_hqm_cfg.is_sriov_mode) begin
                                    cq = 0; //VPP0
                                end
                                alarm_sb_ecc_err = 32'h200;
                                alarm_hw_synd = {24'h804945, cq}; // vpp0,pp
                                ecc_type = "SB";
                                en_field_name = "HCW_ENQ_ECC_ENABLE";
                              end
    "INJ_SB_ECC_CFG"        : begin 
                                alarm_sb_ecc_err = 32'h010;
                                alarm_hw_synd = {24'h804444, 8'h00};
                                ecc_type = "SB";
                                en_field_name = "CSR_ECC_ENABLE";
                              end
    "WRITE_BAD_SB_ECC"      : begin
                                ERR_SUB_TYPE : case (err_sub_type)
                                  "VPP2PP" : begin
                                               alarm_sb_ecc_err = 32'h020;
                                               $sformat(reg_name,"vf_dir_vpp2pp[%0d]",(vf*hqm_pkg::NUM_DIR_CQ));
                                               num = vf*hqm_pkg::NUM_DIR_CQ;
                                               alarm_hw_synd = {24'hC04544, num[7:0]};
                                             end  
                                  "VQID2QID_DIR" : begin
                                               alarm_sb_ecc_err = 32'h040;
                                               $sformat(reg_name,"vf_dir_vqid2qid[%0d]",(vf*hqm_pkg::NUM_DIR_CQ));
                                               num = vf*hqm_pkg::NUM_DIR_CQ;
                                               alarm_hw_synd = {24'hC04644, num[7:0]};
                                             end  
                                  "VQID2QID_LDB" : begin
                                               alarm_sb_ecc_err = 32'h080;
                                               $sformat(reg_name,"vf_ldb_vqid2qid[%0d]",(vf*32));
                                               num = vf*32;
                                               alarm_hw_synd = {24'hC04744, num[7:0]};
                                               cq = lqid[0];
                                             end  
                                endcase
                                ecc_type = "SB";
                                en_field_name = "LUT_ECC_ENABLE";
                              end
    "INJ_MB_ECC_WBUF_W0_LS" : begin 
                                alarm_mb_ecc_err = 32'h1;
                                alarm_hw_synd = {24'h804085, cq};
                                ecc_type = "MB";
                              end
    "INJ_MB_ECC_WBUF_W0_MS" : begin 
                                alarm_mb_ecc_err = 32'h2;
                                alarm_hw_synd = {24'h804185, cq};
                                ecc_type = "MB";
                                //ingressdrop = 1'b1;
                              end
    "INJ_MB_ECC_WBUF_W1_LS" : begin 
                                alarm_mb_ecc_err = 32'h4;
                                alarm_hw_synd = {24'h804285, cq};
                                ecc_type = "MB";
                              end
    "INJ_MB_ECC_WBUF_W1_MS" : begin 
                                alarm_mb_ecc_err = 32'h8;
                                alarm_hw_synd = {24'h804385, cq};
                                ecc_type = "MB";
                                //ingressdrop = 1'b1;
                              end
    "INJ_MB_ECC_HCW_ENQ_LS" : begin 
                                if (i_hqm_cfg.is_sriov_mode) begin
                                    cq = 0; //VPP0
                                end
                                alarm_mb_ecc_err = 32'h0;
                                alarm_hw_synd = (traffic_type == "LDB") ? {24'h806CA5, cq} : {24'h806C85, cq};
                                ecc_type = "MB";
                                ingressdrop = 1'b1;
                              end
    "INJ_MB_ECC_HCW_ENQ_MS" : begin 
                                if (i_hqm_cfg.is_sriov_mode) begin
                                    cq = 0; //VPP0
                                end
                                alarm_mb_ecc_err = 32'h0;
                                alarm_hw_synd = (traffic_type == "LDB") ? {24'h806CA5, cq} : {24'h806C85, cq};
                                ecc_type = "MB";
                                ingressdrop = 1'b1;
                              end
    "INJ_MB_ECC_CFG"        : begin 
                                alarm_mb_ecc_err = 32'h010;
                                alarm_hw_synd = {24'h804484, 8'h82}; // 8'h82 = LUT addr (confirm?)
                                ecc_type = "MB";
                              end
  endcase 
  
  ovm_report_info(get_full_name(), $psprintf("hqm_ecc_error_seq: error_type %0s, ecc_type %0s, traffic_type %0s, return_type %0s, cq %0d, alarm_hw_synd 0x%0x", error_type, ecc_type, traffic_type, return_type, cq, alarm_hw_synd), OVM_MEDIUM);

  if (ecc_type == "SB") begin
     if (error_type == "WRITE_BAD_SB_ECC") begin 
       wr_bad_sbecc_sequence();
     end
     else begin 
       basic_sbecc_sequence();
     end
  end
  else begin
     basic_mbecc_sequence(); 
  end 

  ovm_report_info(get_full_name(), $psprintf("hqm_ecc_error_seq: cyclic_ecc_inj->(%0d). Will start another iteration of ECC injection!", cyclic_ecc_inj), OVM_LOW);

  if(cyclic_ecc_inj) begin 

        cyclic_ecc_inj = 0;

        sbe_cnt_0      = 32'h_12; 
        sbe_cnt_0_bias = 32'h_10; 

        if (ecc_type == "SB") begin
           if (error_type == "WRITE_BAD_SB_ECC") begin 
             wr_bad_sbecc_sequence();
           end
           else begin 
             basic_sbecc_sequence();
           end
        end
        else begin
           basic_mbecc_sequence(); 
        end 

        // -- cyclic_ecc_inj = 1;

        // -- if (ecc_type == "SB") begin
        // --    if (error_type == "WRITE_BAD_SB_ECC") begin 
        // --      wr_bad_sbecc_sequence();
        // --    end
        // --    else begin 
        // --      basic_sbecc_sequence();
        // --    end
        // -- end
        // -- else begin
        // --    basic_mbecc_sequence(); 
        // -- end 

  end

  ovm_report_info(get_full_name(), $psprintf("Sequence hqm_ecc_error_seq ended"), OVM_LOW);

endtask: body

//==============================================
// send_hcw_traffic 
//==============================================
task hqm_ecc_error_seq::send_hcw_traffic(string hcw_type = "DIR", int rpt_cnt = 4);
  ovm_report_info(get_full_name(), $psprintf("Sending HCW traffic hcw_type=%0s", hcw_type), OVM_MEDIUM);
  HCW_TYPE : case (hcw_type)
    "DIR" : begin
      for (int i=0;i<tot_cq_cnt;i++) begin //:dir_qid num
        if (i_hqm_cfg.is_pf_mode) begin   
          send_new_pf(.pp_num(dqid[i]), .qid(dqid[i]), .rpt(rpt_cnt), .ingress_drop(ingressdrop), .is_ldb(0));
        end
        else if (i_hqm_cfg.is_sriov_mode) begin
          send_new(.pp_num(i), .vf_num(vf), .qid(i), .rpt(rpt_cnt), .ingress_drop(ingressdrop), .is_ldb(0));
        end
        else if (i_hqm_cfg.is_sciov_mode) begin
          send_cmd_pf(.pp_num(dqid[i]), .qid(i), .rpt(rpt_cnt), .ingress_drop(ingressdrop), .is_ldb(0), .cmd(4'b1000));
        end

        if(i==0) begin
          cfg_cmds.push_back("idle 1000");
          // poll_sch(.cq_num(dqid[i]), .exp_cnt(1), .is_ldb(0), .delay(1), .timeout(wait_num));
        end 
        
      end
      execute_cfg_cmds;
      if (!ingressdrop) begin 
        for (int i=0;i<tot_cq_cnt;i++) begin //:dir_qid num
          poll_sch( .cq_num(dqid[i]), .exp_cnt(iterations*rpt_cnt), .is_ldb(0));
        end 
      end 
    end
    "DIR_TOKEN_RETURN" : begin
      for (int i=0;i<tot_cq_cnt;i++) begin //:dir_qid num
        if ((i_hqm_cfg.is_pf_mode) || (i_hqm_cfg.is_sciov_mode)) begin   
          send_bat_t_pf(.pp_num(dqid[i]), .rpt(1), .tkn_cnt((iterations*rpt_cnt)-1), .is_ldb(0));
        end
        else if (i_hqm_cfg.is_sriov_mode) begin
          send_bat_t(.pp_num(i), .vf_num(vf), .rpt(1), .tkn_cnt((iterations*rpt_cnt)-1), .is_ldb(0));
        end
      end
      if(~cyclic_ecc_inj) iterations = 0;
    end 
    "LDB" : begin
      for (int i=0;i<tot_cq_cnt;i++) begin //:dir_qid num
        if (i_hqm_cfg.is_pf_mode) begin   
          send_new_pf(.pp_num(lpp[i]), .qid(lqid[i]), .rpt(rpt_cnt), .ingress_drop(ingressdrop), .is_ldb(1));
        end
        else if (i_hqm_cfg.is_sriov_mode) begin
          send_new(.pp_num(i), .vf_num(vf), .qid(i), .rpt(rpt_cnt), .ingress_drop(ingressdrop), .is_ldb(1));
        end
        else if (i_hqm_cfg.is_sciov_mode) begin
          send_cmd_pf(.pp_num(lpp[i]), .qid(i), .rpt(rpt_cnt), .ingress_drop(ingressdrop), .is_ldb(1), .cmd(4'b1000));
        end
        if(i==0) begin
          cfg_cmds.push_back("idle 1000");
          //poll_sch(.cq_num(lpp[i]), .exp_cnt(1), .is_ldb(1), .delay(1), .timeout(wait_num));
        end
      end
      execute_cfg_cmds;
      if (!ingressdrop) begin 
        for (int i=0;i<tot_cq_cnt;i++) begin //:dir_qid num
          bit [31:0] poll_cnt = ( sbe_cnt_0_bias == 32'h_10 ) ?  (iterations + iteration_bias )*rpt_cnt : iterations*rpt_cnt;
          poll_sch( .cq_num(lpp[i]), .exp_cnt(poll_cnt), .is_ldb(1));
        end 
      end 
    end
    "LDB_COMP_RETURN" : begin
      for (int i=0;i<tot_cq_cnt;i++) begin //:dir_qid num
        if ((i_hqm_cfg.is_pf_mode) || (i_hqm_cfg.is_sciov_mode)) begin   
          send_comp_t_pf(.pp_num(lpp[i]), .rpt(iterations*rpt_cnt));
        end
        else if (i_hqm_cfg.is_sriov_mode) begin
          send_comp_t(.pp_num(i), .vf_num(vf), .rpt(iterations*rpt_cnt));
        end
      end
      iterations = 0;
    end 
  endcase 
  ovm_report_info(get_full_name(), $psprintf("Completed sending HCW traffic hcw_type=%0s", hcw_type), OVM_MEDIUM);
endtask: send_hcw_traffic

task hqm_ecc_error_seq::enable_ecc_err();

  if (ecc_type == "SB") begin  
     // enable single bit ecc
     wr_data_q[0] = 32'hFFFFFFFF;
     write_reg("sys_alarm_sb_ecc_int_enable",  wr_data_q[0], "hqm_system_csr");
     compare_reg("sys_alarm_sb_ecc_int_enable",   wr_data_q[0], rd_data_q[0],  "hqm_system_csr");
  end

  // enable injection of single bit ecc error on write buffer word0 ls
  wr_data_q[0] = 'd1;
  field_name_q[0] = error_type;

  write_fields("ecc_ctl",  field_name_q, {0}, "hqm_system_csr");
  compare_fields("ecc_ctl",  field_name_q, {0}, rd_data_q, "hqm_system_csr");

  write_fields("ecc_ctl",  field_name_q, wr_data_q, "hqm_system_csr");
  compare_fields("ecc_ctl",  field_name_q, wr_data_q, rd_data_q, "hqm_system_csr");

  if(en_field_name != "") begin
      write_fields("ecc_ctl",    {en_field_name}, cyclic_ecc_inj ? {0} : {1}, "hqm_system_csr");
      compare_fields("ecc_ctl",  {en_field_name}, cyclic_ecc_inj ? {0} : {1}, rd_data_q, "hqm_system_csr");
  end

endtask : enable_ecc_err

task hqm_ecc_error_seq::disable_ecc_err();

  // disable injection of single bit ecc error on write buffer word0 ls
  field_name_q[0] = error_type;
  wr_data_q[0] = 'd0;
  write_fields("ecc_ctl",  field_name_q, wr_data_q, "hqm_system_csr");
  compare_fields("ecc_ctl",  field_name_q, wr_data_q, rd_data_q, "hqm_system_csr");

endtask : disable_ecc_err

task hqm_ecc_error_seq::basic_sbecc_sequence();

  ovm_report_info(get_full_name(), $psprintf("basic_sbecc_sequence_S0: enable_ecc_err iterations=%0d, cyclic_ecc_inj=%0d",  iterations, cyclic_ecc_inj), OVM_MEDIUM);
  enable_ecc_err();

  if (error_type == "INJ_SB_ECC_CFG") begin
    read_reg("pf_to_vf_mailbox[1]", rd_data_q[0], "hqm_func_pf_per_vf[1]");
  end

  // Send DIR hcw traffic
  iterations++;
  ovm_report_info(get_full_name(), $psprintf("basic_sbecc_sequence_S1: send_hcw_traffic iterations=%0d",  iterations), OVM_MEDIUM);
  send_hcw_traffic(.hcw_type(traffic_type));

  // wait for msix alarm
  if(~cyclic_ecc_inj) cfg_cmds.push_back("msix_alarm_wait 1000");
  if(~cyclic_ecc_inj) execute_cfg_cmds;
  if(~cyclic_ecc_inj) ovm_report_info(get_full_name(), $psprintf("basic_sbecc_sequence_S2: Msix alarm received"), OVM_MEDIUM);

  // check syndrome and alarm registers for single bit ecc error
  compare_reg("sbe_cnt_0"       , cyclic_ecc_inj ? 0 : 32'h1, rd_data_q[0], "hqm_system_csr");
  ovm_report_info(get_full_name(), $psprintf("basic_sbecc_sequence_S3:  check sbe_cnt_0.rd=0x%0x", rd_data_q[0]), OVM_MEDIUM);
  compare_reg("sbe_cnt_1"       , cyclic_ecc_inj ? 0 : 32'h0, rd_data_q[0], "hqm_system_csr");
  ovm_report_info(get_full_name(), $psprintf("basic_sbecc_sequence_S3:  check sbe_cnt_1.rd=0x%0x", rd_data_q[0]), OVM_MEDIUM);
  compare_reg("alarm_sb_ecc_err", cyclic_ecc_inj ? 0 : alarm_sb_ecc_err, rd_data_q[0], "hqm_system_csr");
  ovm_report_info(get_full_name(), $psprintf("basic_sbecc_sequence_S3:  check alarm_sb_ecc_err.rd=0x%0x", rd_data_q[0]), OVM_MEDIUM);
  
  if (error_type == "INJ_SB_ECC_CFG") begin
    read_reg("alarm_hw_synd", rd_data_q[0], "hqm_system_csr");
    alarm_hw_synd[7:0] = rd_data_q[0][7:0];// address of lut
    ovm_report_info(get_full_name(), $psprintf("basic_sbecc_sequence_S3:  check alarm_hw_synd.rd=0x%0x", rd_data_q[0]), OVM_MEDIUM);
  end

  compare_reg("alarm_hw_synd", cyclic_ecc_inj ? 0 : alarm_hw_synd, rd_data_q[0], "hqm_system_csr");
    ovm_report_info(get_full_name(), $psprintf("basic_sbecc_sequence_S3:  check alarm_hw_synd.rd=0x%0x, exp alarm_hw_synd=0x%0x", rd_data_q[0], alarm_hw_synd), OVM_MEDIUM);

  // clear the syndrome and alarm registers
  if(~cyclic_ecc_inj) write_reg("alarm_hw_synd",  32'h80000000, "hqm_system_csr");

  if(~cyclic_ecc_inj) write_reg("alarm_sb_ecc_err",  alarm_sb_ecc_err, "hqm_system_csr");
  compare_reg("alarm_sb_ecc_err", 32'h0, rd_data_q[0], "hqm_system_csr");

  if(~cyclic_ecc_inj) clear_msix();

  wait_for_clk(1000);


  //--
  ovm_report_info(get_full_name(), $psprintf("basic_sbecc_sequence_S5: disable_ecc_err iterations=%0d, cyclic_ecc_inj=%0d",  iterations, cyclic_ecc_inj), OVM_MEDIUM);
  disable_ecc_err(); 

  if (error_type == "INJ_SB_ECC_CFG") begin
    read_reg("pf_to_vf_mailbox[1]", rd_data_q[0], "hqm_func_pf_per_vf[1]");
  end

  // Send DIR hcw traffic
  iterations++;
  ovm_report_info(get_full_name(), $psprintf("basic_sbecc_sequence_S6: send_hcw_traffic iterations=%0d",  iterations), OVM_MEDIUM);
  send_hcw_traffic(.hcw_type(traffic_type));

  // check syndrome and alarm registers for single bit ecc error
  compare_reg("sbe_cnt_0", cyclic_ecc_inj ? 0 : 32'h1, rd_data_q[0], "hqm_system_csr");
  compare_reg("sbe_cnt_1", 32'h0, rd_data_q[0], "hqm_system_csr");
  compare_reg("alarm_sb_ecc_err", 32'h0, rd_data_q[0], "hqm_system_csr");

  if(~cyclic_ecc_inj) alarm_hw_synd = alarm_hw_synd & 32'h7FFF_FFFF;
  compare_reg("alarm_hw_synd", cyclic_ecc_inj ? 0 : alarm_hw_synd, rd_data_q[0], "hqm_system_csr");

  // Return tokens
  if(~cyclic_ecc_inj || (return_type=="LDB_COMP_RETURN")) send_hcw_traffic(.hcw_type(return_type));
endtask : basic_sbecc_sequence

task hqm_ecc_error_seq::wr_bad_sbecc_sequence();

  enable_ecc_err();

  wr_data_q[0] = cq;
  ovm_report_info(get_full_name(), $psprintf("reg_name %0s", reg_name), OVM_MEDIUM);
  write_reg(reg_name,  wr_data_q[0], "hqm_system_csr");
  compare_reg(reg_name, wr_data_q[0], rd_data_q[0], "hqm_system_csr");

  // wait for msix alarm
  if(~cyclic_ecc_inj) cfg_cmds.push_back("msix_alarm_wait 5000");
  if(~cyclic_ecc_inj) execute_cfg_cmds;

  if(~cyclic_ecc_inj) clear_msix();

  iteration_bias = 1;

  // Send DIR hcw traffic
  iterations++;
  send_hcw_traffic(.hcw_type(traffic_type));

  // wait for msix alarm
  if(~cyclic_ecc_inj) cfg_cmds.push_back("msix_alarm_wait 5000");
  if(~cyclic_ecc_inj) execute_cfg_cmds;

  if(~cyclic_ecc_inj) clear_msix();

  // check syndrome and alarm registers for single bit ecc error
  compare_reg("sbe_cnt_0"       , cyclic_ecc_inj ? 'h_0 : sbe_cnt_0, rd_data_q[0], "hqm_system_csr");
  compare_reg("sbe_cnt_1"       , cyclic_ecc_inj ? 'h_0 : 32'h0 , rd_data_q[0], "hqm_system_csr");
  compare_reg("alarm_sb_ecc_err", cyclic_ecc_inj ? 'h_0 : alarm_sb_ecc_err, rd_data_q[0], "hqm_system_csr");
  compare_reg("alarm_hw_synd"   , cyclic_ecc_inj ? 'h_0 : alarm_hw_synd, rd_data_q[0], "hqm_system_csr");

  // clear the syndrome and alarm registers
  if(~cyclic_ecc_inj)  write_reg("alarm_hw_synd",  32'h80000000, "hqm_system_csr");
  if(~cyclic_ecc_inj)  write_reg("alarm_sb_ecc_err",  alarm_sb_ecc_err, "hqm_system_csr");
  compare_reg("alarm_sb_ecc_err", 32'h0, rd_data_q[0], "hqm_system_csr");

  // Return tokens
  if(~cyclic_ecc_inj || (return_type=="LDB_COMP_RETURN")) send_hcw_traffic(.hcw_type(return_type));

  // wait for msix alarm
  if(~cyclic_ecc_inj) cfg_cmds.push_back("msix_alarm_wait 5000");
  if(~cyclic_ecc_inj) execute_cfg_cmds;

  if(~cyclic_ecc_inj) clear_msix();

  /* https://hsdes.intel.com/appstore/article/#/1608106454 
  // disable injection of single bit ecc error on write buffer word0 ls
  field_name_q[0] = error_type;
  wr_data_q[0] = 'd0;
  write_fields("ecc_ctl",  field_name_q, wr_data_q, "hqm_system_csr");
  compare_fields("ecc_ctl",  field_name_q, wr_data_q, rd_data_q, "hqm_system_csr");

  wr_data_q[0] = dqid[0];
  ovm_report_info(get_full_name(), $psprintf("reg_name %0s", reg_name), OVM_MEDIUM);
  write_reg(reg_name,  wr_data_q[0], "hqm_system_csr");
  compare_reg(reg_name, wr_data_q[0], rd_data_q[0], "hqm_system_csr");
  */

  // check syndrome and alarm registers for single bit ecc error
  if (return_type == "DIR_TOKEN_RETURN") begin 
    sbe_cnt_0 += 'h_4;
    compare_reg("sbe_cnt_0", cyclic_ecc_inj ? 'h_0 : sbe_cnt_0, rd_data_q[0], "hqm_system_csr");
    compare_reg("sbe_cnt_1", 32'h0, rd_data_q[0], "hqm_system_csr");
  end
  else begin
    sbe_cnt_0 += 'h_10; // -- Because LDB traffic includes pop -> Equivalent to lut_read -- //
    compare_reg("sbe_cnt_0", cyclic_ecc_inj ? 'h_0 : sbe_cnt_0, rd_data_q[0], "hqm_system_csr");
    compare_reg("sbe_cnt_1", 32'h0, rd_data_q[0], "hqm_system_csr");
  end
  compare_reg("alarm_sb_ecc_err", cyclic_ecc_inj ? 'h_0 : alarm_sb_ecc_err, rd_data_q[0], "hqm_system_csr");

  if(~cyclic_ecc_inj)  alarm_hw_synd[7:0] = 8'h00; //vpp0
  compare_reg("alarm_hw_synd", cyclic_ecc_inj ? 'h_0 : alarm_hw_synd, rd_data_q[0], "hqm_system_csr");

  // clear the syndrome and alarm registers
  if(~cyclic_ecc_inj) write_reg("alarm_hw_synd",  32'h80000000, "hqm_system_csr");
  if(~cyclic_ecc_inj) write_reg("alarm_sb_ecc_err",  alarm_sb_ecc_err, "hqm_system_csr");
  compare_reg("alarm_sb_ecc_err", 32'h0, rd_data_q[0], "hqm_system_csr");
endtask : wr_bad_sbecc_sequence

task hqm_ecc_error_seq::basic_mbecc_sequence();
  hqm_tb_hcw_scoreboard sb_h;
  ovm_object tmp_h;


  enable_ecc_err();

  tot_cq_cnt = 1;

  if (error_type == "INJ_MB_ECC_CFG") begin
    read_reg("pf_to_vf_mailbox[1]", rd_data_q[0], "hqm_func_pf_per_vf[1]");
  end

  if (!ingressdrop) begin 
    iterations++;
  end
  send_hcw_traffic(.hcw_type(traffic_type), .rpt_cnt(1));

  // wait for msix alarm
  cfg_cmds.push_back("msix_alarm_wait 1000");
  execute_cfg_cmds;
  ovm_report_info(get_full_name(), $psprintf("Msix alarm received"), OVM_MEDIUM);

  compare_reg("alarm_mb_ecc_err", alarm_mb_ecc_err, rd_data_q[0], "hqm_system_csr");
  compare_reg("alarm_hw_synd", alarm_hw_synd, rd_data_q[0], "hqm_system_csr");

  // clear the syndrome and alarm registers
  write_reg("alarm_hw_synd",  32'h80000000, "hqm_system_csr");

  write_reg("alarm_mb_ecc_err",  alarm_mb_ecc_err, "hqm_system_csr");
  compare_reg("alarm_mb_ecc_err", 32'h0, rd_data_q[0], "hqm_system_csr");

  clear_msix();

  wait_for_clk(1000);

  // Return tokens
  if (!ingressdrop) begin 
    send_hcw_traffic(.hcw_type(return_type), .rpt_cnt(1));
  end

  if (!p_sequencer.get_config_object("i_hcw_scoreboard", tmp_h)) begin
               ovm_report_fatal(get_full_name(), "Unable to find scoreboard object");
  end
  
  if (!$cast(sb_h, tmp_h)) begin
    ovm_report_fatal(get_full_name(), $psprintf("casting failed"));
  end

  sb_h.hcw_scoreboard_reset();

  /*disable_ecc_err();

  if (error_type == "INJ_MB_ECC_CFG") begin
    read_reg("pf_to_vf_mailbox[1]", rd_data_q[0], "hqm_func_pf_per_vf[1]");
  end

  if (ingressdrop) begin 
    ingressdrop = 1'b0;
  end

  iterations++; 
  send_hcw_traffic(.hcw_type(traffic_type), .rpt_cnt(1));

  compare_reg("alarm_mb_ecc_err", 32'h0, rd_data_q[0], "hqm_system_csr");

  alarm_hw_synd = alarm_hw_synd & 32'h7FFF_FFFF;
  compare_reg("alarm_hw_synd", alarm_hw_synd, rd_data_q[0], "hqm_system_csr");

  // Return tokens
  send_hcw_traffic(.hcw_type(return_type), .rpt_cnt(1));*/
endtask : basic_mbecc_sequence

task hqm_ecc_error_seq::clear_msix();
  // clear msix
  field_name_q[0] = "MSIX_0_ACK";
  wr_data_q[0] = 'd1;
  write_fields("msix_ack",  field_name_q, wr_data_q, "hqm_system_csr");
  wr_data_q[0] = 'd0;
  compare_fields("msix_ack",  field_name_q, wr_data_q, rd_data_q, "hqm_system_csr");
endtask : clear_msix
`endif //HQM_ECC_ERROR_SEQ__SV
