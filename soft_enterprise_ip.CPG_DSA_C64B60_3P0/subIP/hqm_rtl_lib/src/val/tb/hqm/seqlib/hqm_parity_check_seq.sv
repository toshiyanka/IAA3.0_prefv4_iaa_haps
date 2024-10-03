`ifndef HQM_PARITY_CHECK_SEQ__SV
`define HQM_PARITY_CHECK_SEQ__SV

//  


class hqm_parity_check_seq extends hqm_base_seq;

  `ovm_sequence_utils(hqm_parity_check_seq, sla_sequencer)

      ovm_event_pool        glbl_pool;
      ovm_event             exp_msix_0;
      ovm_object            o_tmp;
      sla_ral_addr_t        addr;
      sla_ral_reg           reg_h;
      hcw_qtype             qtype_in;
      bit                   is_ldb;
      bit [7:0]             dqid[hqm_pkg::NUM_DIR_CQ];
      bit [7:0]             lqid[hqm_pkg::NUM_LDB_QID];
      bit [7:0]             lpp[hqm_pkg::NUM_LDB_CQ];
      bit [3:0]             vf[16];
      bit [3:0]             vdev[16];
      bit [31:0]            exp_synd_val;
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

      //parity specific variable start 
      string                inj_parity_type;
      string                inj_par_sub_type;
      string                field_name_q[1];
      bit [31:0]            alarm_hw_synd;
      bit [31:0]            egress_lut_err;
      bit [31:0]            alarm_err;
      bit [31:0]            ti_preq_drop;   
      sla_ral_data_t        wr_data_q[1];
      sla_ral_data_t        rd_data_q[1];
      bit                    is_dir;
      sla_ral_data_t         rd_data;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]            rd_val;
      bit [hqm_pkg::NUM_DIR_CQ-1:0]            dir_cq_occ;
      bit [hqm_pkg::NUM_LDB_CQ-1:0]            ldb_cq_occ;
      
      extern task           body();
      extern task           parity_check();
      extern task           send_hcw_cmd(input bit exp_drop = 1'b0, input int num_hcw = 1'd1);
      extern task           wait_for_msix0();
      extern task           check_synd();
      extern task           clear_synd();
      extern task           tok_and_cmp_return(input bit exp_drop = 1'b0, input int num_hcw = 1'd1);
      extern task           default_synd_assignment();
      extern task           check_cq_occ();
      
      extern task           hqm_parity_inj();
      //parity specific variable done
      extern task           check_cq_occ_int();
      extern task           cwdi_config_and_checks(bit is_ldb);

    function new(string name = "hqm_parity_check_seq");
      super.new(name);
      glbl_pool  = ovm_event_pool::get_global_pool();
      exp_msix_0 = glbl_pool.get("hqm_exp_ep_msix_0");
    endfunction

endclass: hqm_parity_check_seq

    task hqm_parity_check_seq::body();
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

      //parity changes start
      if (!$value$plusargs("HQM_PARITY_INJ_TYPE=%s", inj_parity_type)) begin
         inj_parity_type = "INJ_PAR_ERR_SCH_DATA";
      end
      if (!$value$plusargs("HQM_PAR_SUB_TYPE=%s", inj_par_sub_type)) begin
         //inj_par_sub_type = "INJ_PAR_ERR_SCH_DATA";
         inj_par_sub_type = "";
        `ovm_info(get_full_name(), $psprintf("inj_par_sub_type = %0s ", inj_par_sub_type),OVM_MEDIUM)
      end
      default_synd_assignment();
      wr_data_q[0] = 1'b1;
      field_name_q[0] = inj_parity_type;
      write_fields("parity_ctl",    field_name_q, wr_data_q, "hqm_system_csr");
      compare_fields("parity_ctl",  field_name_q, wr_data_q, rd_data_q, "hqm_system_csr");
      if (inj_par_sub_type != "") begin
       field_name_q[0] = inj_par_sub_type;
       write_fields("parity_ctl",    field_name_q, wr_data_q, "hqm_system_csr");
       compare_fields("parity_ctl",  field_name_q, wr_data_q, rd_data_q, "hqm_system_csr");
      end
      is_dir = $urandom_range(0,1);
     `ovm_info(get_full_name(), $psprintf("is_dir= %0b ", is_dir),OVM_MEDIUM)
      parity_check();
      //parity changes done

  endtask: body


task hqm_parity_check_seq::parity_check();

  case (inj_parity_type)
    "INJ_PAR_ERR_SCH_DATA" : begin
                               send_hcw_cmd(); //no drop exp
                               wait_for_msix0();
                               check_synd();
                               tok_and_cmp_return();     
                               clear_synd();
                             end 

    "INJ_PAR_ERR_SCH_REQ" : begin
                               send_hcw_cmd(.exp_drop(1)); //egress drop exp
                               wait_for_msix0();
                               check_synd();
                               tok_and_cmp_return(.exp_drop(1));     
                               clear_synd();
                             end 

    "INJ_PAR_ERR_SCH_OUT" : begin
                               send_hcw_cmd(.exp_drop(1)); 
                               wait_for_msix0();
                               check_synd();
                               tok_and_cmp_return(.exp_drop(1));     
                               clear_synd();
                             end 

    "INJ_RES_ERR_SCH_REQ" : begin
                               send_hcw_cmd(.exp_drop(1)); //egress drop exp
                               wait_for_msix0();
                               check_synd();
                               tok_and_cmp_return(.exp_drop(1));     
                               clear_synd();
                             end 

    "INJ_PAR_ERR_SCH_PL" : begin
                               send_hcw_cmd(.exp_drop(1)); //egress drop exp
                               wait_for_msix0();
                               check_synd();
                               tok_and_cmp_return(.exp_drop(1));     
                               clear_synd();
                             end 

    "INJ_PAR_ERR_SCH" : begin
                               send_hcw_cmd(.exp_drop(1)); //egress drop exp
                               wait_for_msix0();
                               check_synd();
                               tok_and_cmp_return(.exp_drop(1));     
                               clear_synd();
                             end 

    "INJ_RES_ERR_SCH" : begin
                               send_hcw_cmd(.exp_drop(1)); //egress drop exp
                               wait_for_msix0();
                               check_synd();
                               tok_and_cmp_return(.exp_drop(1));     
                               clear_synd();
                             end 


    "INJ_PAR_ERR_SCH_INT" : begin
                               send_hcw_cmd(.num_hcw(2)); //cq_depth_thresh=1
                               wait_for_msix0();
                               //also check cq_interrupt not triggered                 
                               check_cq_occ();
                               check_synd();
                               tok_and_cmp_return(.num_hcw(2));     
                               clear_synd();
                             end 

   "EGRESS_PAR_OFF" : begin //Disable parity checking on ingress memories
                           case (inj_par_sub_type)
                            "INJ_PAR_ERR_SCH_DATA",
                            "INJ_PAR_ERR_SCH_REQ" : begin
                                                       send_hcw_cmd(); //no drop exp
                                                       check_synd();
                                                       tok_and_cmp_return();     
                                                     end 
                           endcase
                     end  
   "EGRESS_RES_OFF" : begin //Disable residue checking in egress logic
                           case (inj_par_sub_type)
                            "INJ_RES_ERR_SCH_REQ" : begin
                                                  send_hcw_cmd(); //No drop expected
                                                  check_synd();
                                                  tok_and_cmp_return();     
                                                end 
                           endcase   
                     end   
   "EGRESS_INT_PAR_OFF" : begin //Disable parity checking on egress interrupt pipeline data
                           case (inj_par_sub_type)
                            "INJ_PAR_ERR_SCH_INT" : begin
                                                  send_hcw_cmd(); //egress drop exp
                                                  check_synd();
                                                  tok_and_cmp_return();     
                                                end 
                           endcase   
                     end   
   "WBUF_PAR_OFF"  : begin //Disable parity checking on write buffer sch_out FIFO
                           case (inj_par_sub_type)
                            "INJ_PAR_ERR_SCH_OUT", 
                            "INJ_PAR_ERR_SCH" : begin
                                                  send_hcw_cmd(); //No drop exp
                                                  check_synd();
                                                  tok_and_cmp_return();     
                                                end 
                           endcase   
                     end   //WBUF_PAR_OFF
   "WBUF_RES_OFF"  : begin //Disable residue checking in write buffer logicparity checking on ingress memories
                           case (inj_par_sub_type)
                            "INJ_RES_ERR_SCH" : begin
                                                  send_hcw_cmd(); //egress drop exp
                                                  check_synd();
                                                  tok_and_cmp_return();     
                                                end 
                           endcase   
                     end  //WBUF_RES_OFF

  endcase
 
endtask: parity_check

task hqm_parity_check_seq::send_hcw_cmd(input bit exp_drop =1'b0, input int num_hcw = 1'd1 );

  ovm_report_info(get_full_name(), $psprintf("send_hcw_cmd:-- Start Exp_Drop =%0b", exp_drop), OVM_MEDIUM);
  if(i_hqm_cfg.is_pf_mode()) begin
    if (is_dir) begin
      send_new_pf(.pp_num(dqid[0]), .qid(dqid[0]), .rpt(num_hcw), .is_ldb(0), .ingress_drop(exp_drop));
    end else begin
      if (exp_drop==0) begin
        send_new_pf(.pp_num(lpp[0]),  .qid(lqid[0]), .rpt(num_hcw), .is_ldb(1), .ingress_drop(exp_drop));
      end else begin
        send_new_pf(.pp_num(lpp[1]),  .qid(lqid[1]), .rpt(num_hcw), .is_ldb(1), .ingress_drop(exp_drop));
      end
    end
  end
  else if(i_hqm_cfg.is_sciov_mode()) begin
    send_cmd_pf(.pp_num(lpp[0]),  .qid(hqm_pkg::NUM_LDB_QID-tot_cq_cnt), .rpt(cq_depth_val), .is_ldb(1), .cmd(4'b1000));
    send_cmd_pf(.pp_num(dqid[0]), .qid(hqm_pkg::NUM_DIR_CQ-tot_cq_cnt), .rpt(cq_depth_val), .is_ldb(0), .cmd(4'b1000));
  end  
  else if(i_hqm_cfg.is_sriov_mode) begin 
    send_new(.vf_num(vf[1]), .pp_num(1), .qid(1), .rpt(cq_depth_val), .is_ldb(1));
    send_new(.vf_num(vf[0]), .pp_num(0), .qid(0), .rpt(cq_depth_val), .is_ldb(0));
  end
  execute_cfg_cmds();
  if(exp_drop !==1) begin
    if (is_dir) begin
      poll_sch(.cq_num(dqid[0]), .exp_cnt(num_hcw), .is_ldb(0));
    end else begin
      poll_sch(.cq_num(lpp[0]),  .exp_cnt(num_hcw), .is_ldb(1));
    end
  end
  else begin //exp_drop=1
    poll_reg($psprintf("hqm_system_cnt_0"), 'h1,  "hqm_system_csr");  //enqueue HCWs i/p
  end
  ovm_report_info(get_full_name(), $psprintf("send_hcw_cmd:-- completes"), OVM_MEDIUM);
endtask:send_hcw_cmd



task hqm_parity_check_seq::wait_for_msix0();
    ovm_report_info(get_full_name(), $psprintf("Wait for MSIX0:-- Start "), OVM_MEDIUM);
    i_hqm_pp_cq_status.wait_for_msix_int(0, data); // MISx entry index
    exp_msix_0.trigger();
    ovm_report_info(get_full_name(), $psprintf("Wait for MSIX0:-- Complete"), OVM_MEDIUM);
endtask: wait_for_msix0

task hqm_parity_check_seq::check_synd();
    ovm_report_info(get_full_name(), $psprintf("check_synd:-- Start "), OVM_MEDIUM);
    compare_reg("alarm_hw_synd",   alarm_hw_synd,  rd_data_q[0], "hqm_system_csr");
    compare_reg("egress_lut_err",  egress_lut_err, rd_data_q[0], "hqm_system_csr");
    compare_reg("alarm_err",       alarm_err,      rd_data_q[0], "hqm_system_csr");
    compare_reg("hqm_iosf_cnt_10", ti_preq_drop,   rd_data_q[0], "hqm_sif_csr");
 

    ovm_report_info(get_full_name(), $psprintf("check_synd:-- Complete"), OVM_MEDIUM);
endtask: check_synd

task hqm_parity_check_seq::clear_synd();
    ovm_report_info(get_full_name(), $psprintf("clear_synd:-- Start "), OVM_MEDIUM);
    write_fields("alarm_hw_synd", {"valid"},      {1}, "hqm_system_csr");
    write_fields("msix_ack",      {"MSIX_0_ACK"}, {1}, "hqm_system_csr");

    write_reg("egress_lut_err",   '1, "hqm_system_csr"); 
    write_reg("alarm_err",        '1, "hqm_system_csr"); 

    compare_reg("alarm_err", '0, rd_data_q[0], "hqm_system_csr");
    ovm_report_info(get_full_name(), $psprintf("clear_synd:-- Complete"), OVM_MEDIUM);
endtask: clear_synd

task hqm_parity_check_seq::default_synd_assignment(); 
    ovm_report_info(get_full_name(), $psprintf("default_synd_assignment:-- Start INJ_PARITY_TYPE =%0s", inj_parity_type), OVM_MEDIUM);
    case (inj_parity_type)
      "INJ_PAR_ERR_SCH_DATA" : begin           // {valid,more,src,unit,aid,  cls,          rtype,synd}
                                 alarm_hw_synd  = {1'b1,1'b0,4'b0,4'b1,6'h0a,2'h2,3'b0,1'b1,2'b0,8'b0}; //{32'h804a8400};
                                 egress_lut_err = {17'h0,4'b0,1'b1,10'h0};  //SCH_DATA_PERR
                                 alarm_err      = {20'h0,9'h0,1'b1,2'h0};   //EGRESS_PERR 
                               end

      "INJ_PAR_ERR_SCH_REQ" : begin            // {valid,more,src,unit,aid,  cls,          rtype,synd} 
                                 alarm_hw_synd  = {1'b1,1'b0,4'b0,4'b1,6'h0a,2'h2,3'b0,1'b1,2'b0,8'b0}; //{32'h804a8400};
                                 egress_lut_err = {17'h0,3'b0,1'b1,11'h0}; //SCH_REQ_PERR 
                                 alarm_err      = {20'h0,9'h0,1'b1,2'h0};  //EGRESS_PERR 
                              end

      "INJ_PAR_ERR_SCH_OUT" : begin            // {valid,more,src,unit,aid,  cls,          rtype,synd}
                                 alarm_hw_synd  = {1'b1,1'b0,4'b0,4'b1,6'h11,2'h2,3'b0,1'b1,2'b0,8'h4}; 
                                 //egress_lut_err = {17'h0,4'b0,1'b1,10'h0}; No lut err exp
                                 alarm_err      = {20'h0,2'h0,1'h1,9'h0};  //SCH_WB_PERR
                              end

      "INJ_RES_ERR_SCH_REQ" : begin 
                                 alarm_hw_synd  = {32'h804a8400}; //no err description found in interrupt.xlsx
                                 egress_lut_err = {17'h0,2'h0,1'h1,12'h0}; //SCH_REQ_RERR
                                 alarm_err      = {20'h0,9'h0,1'h1,2'h0};  //EGRESS_PERR
                              end


      "INJ_PAR_ERR_SCH_PL" : begin 
                                alarm_hw_synd  = {32'h804a8400}; //TODO no err description found in interrupt.xlsx
                                egress_lut_err = {17'h0,1'h0,1'b1,13'h0}; //SCH_REQ_PL_PERR
                                alarm_err      = {20'h0,9'h0,1'h1,2'h0};  //EGRESS_PERR
                              end


      "INJ_PAR_ERR_SCH" : begin            // {valid,more,src,unit,aid,  cls,          rtype,synd}
                             alarm_hw_synd  = {1'b1,1'b0,4'b0,4'b1,6'h11,2'h2,3'b0,1'b1,2'b0,8'h2}; 
                             alarm_err      = {20'h0,2'h0,1'h1,9'h0};  
                             ti_preq_drop   = {32'h1};  
                                
                          end



      "INJ_RES_ERR_SCH" : begin             // {valid,more,src,unit,aid,  cls,          rtype,synd}
                              alarm_hw_synd  = {1'b1,1'b0,4'b0,4'b1,6'h11,2'h2,3'b0,1'b1,2'b0,8'h1}; 
                              egress_lut_err = {17'h0,4'b0,1'b0,10'h0}; //No egress error expected
                              alarm_err      = {20'h0,2'h0,1'b1,9'h0};  //SCH_WB_PERR Set
                              ti_preq_drop   = {32'h1};  
                          end


      "INJ_PAR_ERR_SCH_INT" : begin 
                                 alarm_hw_synd  = {32'h804a8400}; //not sure about this reg TODO
                                 egress_lut_err = {17'h0,1'h1,14'h0}; //
                                 alarm_err      = {20'h0,9'h0,1'h1,2'h0}; //EGRESS_PERR) 
                              end
      "EGRESS_PAR_OFF" : begin 
                                 alarm_hw_synd  = {32'h00000000}; 
                                 egress_lut_err = {17'h0,1'h0,14'h0}; 
                                 alarm_err      = {20'h0,1'h0,1'h0,10'h0}; 
                              end
    endcase
    ovm_report_info(get_full_name(), $psprintf("default_synd_assignment:--Complete alarm_hw_synd =0x%0x,egress_lut_err=0x%0x,alarm_err=0x%0x ",alarm_hw_synd,egress_lut_err, alarm_err ), OVM_MEDIUM);

endtask: default_synd_assignment

task hqm_parity_check_seq::tok_and_cmp_return(input bit exp_drop = 1'b0, input int num_hcw = 1'd1 ); 
    if (is_dir) begin
       send_bat_t_pf(.pp_num(dqid[0]), .tkn_cnt(num_hcw-1), .is_ldb(0));
    end else begin
      if (exp_drop==0) begin
         send_comp_t_pf(.pp_num(lpp[0]), .rpt(num_hcw));
      end else begin
         send_comp_t_pf(.pp_num(lpp[1]), .rpt(num_hcw));
      end
    end
endtask : tok_and_cmp_return 

task hqm_parity_check_seq::check_cq_occ(); 
    //check only in case of cq_occ interrupt is generated and int not expected
     read_reg("dir_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     dir_cq_occ[31:0] = rd_data;
     read_reg("dir_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     dir_cq_occ[63:32]= rd_data;
     read_reg("ldb_cq_31_0_occ_int_status",   rd_data,  "hqm_system_csr");
     ldb_cq_occ[31:0] = rd_data;
     read_reg("ldb_cq_63_32_occ_int_status",  rd_data, "hqm_system_csr");
     ldb_cq_occ[63:32] = rd_data;
     if(|(dir_cq_occ) !=0 || |(ldb_cq_occ) !=0)begin
       `ovm_error(get_full_name(), $psprintf("check_cq_occ:Unexpected CQ-Interrupt generated for dir_cq = 0x%0x or ldb_cq = 0x%0x ",dir_cq_occ, ldb_cq_occ))
     end 
endtask : check_cq_occ    
`endif //HQM_PARITY_CHECK_SEQ__SV

