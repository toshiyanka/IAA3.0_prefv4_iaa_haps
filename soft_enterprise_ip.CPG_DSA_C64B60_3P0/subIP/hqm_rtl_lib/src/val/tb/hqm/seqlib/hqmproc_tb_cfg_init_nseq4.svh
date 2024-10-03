//-- ###########################################################################################################################
//-- These Tasks Are derived from HQMV2 hqm_proc TB
//-- These Tasks Are used in hcw_enqtrf_test_hcw_seq
//-- ###########################################################################################################################


//-------------------------
// wait_idle
//------------------------- 
virtual task wait_idle(int wait_cycles);
      for(int i=0; i<wait_cycles; i++) #1ns;
endtask:wait_idle  

//-------------------------
// cfg_config_master_prochot_disable
//------------------------- 
virtual task cfg_config_master_prochot_disable(bit prochot_disable);
  sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];

        read_reg("cfg_control_general", rd_val , "config_master");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_config_master_prochot_disable: config_master.cfg_control_general.rd.default=0x%0x", rd_val), OVM_LOW); 
        if(prochot_disable==1) 
           write_fields($psprintf("cfg_control_general"), '{"CFG_PROCHOT_DISABLE"}, '{'b1}, "config_master");

        read_reg("cfg_control_general", rd_val , "config_master");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_config_master_prochot_disabled: config_master.cfg_control_general.rd.prochotdisabled=0x%0x, prochot_disable=%0d", rd_val, prochot_disable), OVM_LOW); 
endtask

//-------------------------
// cfg_hqm_system_ctrl_task
//------------------------- 
virtual task cfg_hqm_system_ctrl_task();
  sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
  bit [6:0]  hqm_system_egress_schratelimit;
  bit        hqm_system_egress_schwb;  
  bit        hqm_system_egress_w1beat;  
  bit [9:0]  hqm_system_ingress_enqratelimit;
  bit        hqm_system_ingress_enqzeroclstart;
  bit        hqm_system_ingress_holdhcw_w, hqm_system_ingress_single_step_enq, hqm_system_ingress_single_step_hcw_w, hqm_system_ingress_enable_debug;

  bit [8:0]  hqm_system_enq_fifo_wm; //--9'd254 default
  bit [7:0]  hqm_system_sch_out_fifo_wm; //--8'd127 default
  int        fifo_hwm_val;
  int        ldb_cq2tc_maprnd;
  int        ldb_cq2tc_map0;
  int        ldb_cq2tc_map1;
  int        ldb_cq2tc_map2;
  int        ldb_cq2tc_map3;
  int        dir_cq2tc_maprnd;
  int        dir_cq2tc_map0;
  int        dir_cq2tc_map1;
  int        dir_cq2tc_map2;
  int        dir_cq2tc_map3;
  int        int_cq2tc_map;
  int        int_cq2tc_maprnd;

    ldb_cq2tc_maprnd=1; 
    $value$plusargs("hqmproc_ldb_cq2tc_maprnd=%h", ldb_cq2tc_maprnd);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: ldb_cq2tc_maprnd=0x%0x ", ldb_cq2tc_maprnd), OVM_LOW);

    if(ldb_cq2tc_maprnd) ldb_cq2tc_map0=$urandom_range(0,15);
    else ldb_cq2tc_map0=0; 
    $value$plusargs("hqmproc_ldb_cq2tc_map0=%h", ldb_cq2tc_map0);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: ldb_cq2tc_map0=0x%0x ", ldb_cq2tc_map0), OVM_LOW);

    if(ldb_cq2tc_maprnd) ldb_cq2tc_map1=$urandom_range(0,15);
    else ldb_cq2tc_map1=0; 
    $value$plusargs("hqmproc_ldb_cq2tc_map1=%h", ldb_cq2tc_map1);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: ldb_cq2tc_map1=0x%0x ", ldb_cq2tc_map1), OVM_LOW);
 
    if(ldb_cq2tc_maprnd) ldb_cq2tc_map2=$urandom_range(0,15);
    else ldb_cq2tc_map2=0; 
    $value$plusargs("hqmproc_ldb_cq2tc_map2=%h", ldb_cq2tc_map2);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: ldb_cq2tc_map2=0x%0x ", ldb_cq2tc_map2), OVM_LOW);
 
    if(ldb_cq2tc_maprnd) ldb_cq2tc_map3=$urandom_range(0,15);
    else ldb_cq2tc_map3=0; 
    $value$plusargs("hqmproc_ldb_cq2tc_map3=%h", ldb_cq2tc_map3);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: ldb_cq2tc_map3=0x%0x ", ldb_cq2tc_map3), OVM_LOW);
 
    dir_cq2tc_maprnd=1; 
    $value$plusargs("hqmproc_dir_cq2tc_maprnd=%h", dir_cq2tc_maprnd);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: dir_cq2tc_maprnd=0x%0x ", dir_cq2tc_maprnd), OVM_LOW);

    if(dir_cq2tc_maprnd) dir_cq2tc_map0=$urandom_range(0,15);
    else dir_cq2tc_map0=0; 
    $value$plusargs("hqmproc_dir_cq2tc_map0=%h", dir_cq2tc_map0);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: dir_cq2tc_map0=0x%0x ", dir_cq2tc_map0), OVM_LOW);

    if(dir_cq2tc_maprnd) dir_cq2tc_map1=$urandom_range(0,15);
    else dir_cq2tc_map1=0; 
    $value$plusargs("hqmproc_dir_cq2tc_map1=%h", dir_cq2tc_map1);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: dir_cq2tc_map1=0x%0x ", dir_cq2tc_map1), OVM_LOW);
 
    if(dir_cq2tc_maprnd) dir_cq2tc_map2=$urandom_range(0,15);
    else dir_cq2tc_map2=0; 
    $value$plusargs("hqmproc_dir_cq2tc_map2=%h", dir_cq2tc_map2);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: dir_cq2tc_map2=0x%0x ", dir_cq2tc_map2), OVM_LOW);
 
    if(dir_cq2tc_maprnd) dir_cq2tc_map3=$urandom_range(0,15);
    else dir_cq2tc_map3=0; 
    $value$plusargs("hqmproc_dir_cq2tc_map3=%h", dir_cq2tc_map3);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: dir_cq2tc_map3=0x%0x ", dir_cq2tc_map3), OVM_LOW);
 
    int_cq2tc_maprnd=1; 
    $value$plusargs("hqmproc_int_cq2tc_maprnd=%h", int_cq2tc_maprnd);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: int_cq2tc_maprnd=0x%0x ", int_cq2tc_maprnd), OVM_LOW);

    if(int_cq2tc_maprnd) int_cq2tc_map=$urandom_range(0,15);
    else int_cq2tc_map=0; 
    $value$plusargs("hqmproc_int_cq2tc_map=%h", int_cq2tc_map);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: int_cq2tc_map=0x%0x ", int_cq2tc_map), OVM_LOW);



    hqm_system_ingress_enqzeroclstart=0; 
    $value$plusargs("hqmproc_sys_ingress_enqzeroclstart=%h", hqm_system_ingress_enqzeroclstart);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: hqm_system_ingress_enqzeroclstart=0x%0x ", hqm_system_ingress_enqzeroclstart), OVM_LOW);
 
    hqm_system_enq_fifo_wm=0; 
    $value$plusargs("hqmproc_sys_enq_fifo_wm=%d", hqm_system_enq_fifo_wm);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: hqm_system_enq_fifo_wm=%d (255: rnd) ", hqm_system_enq_fifo_wm), OVM_LOW);
    if(hqm_system_enq_fifo_wm==255) hqm_system_enq_fifo_wm = $urandom_range(1,254);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: hqm_system_enq_fifo_wm=%d (cfgval) ", hqm_system_enq_fifo_wm), OVM_LOW);
 
    //hqm_system_sch_out_fifo_wm[7:0]; //--8'd127 default
    hqm_system_sch_out_fifo_wm=0; 
    $value$plusargs("hqmproc_sys_sch_out_fifo_wm=%d", hqm_system_sch_out_fifo_wm);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: hqm_system_sch_out_fifo_wm=%d (255: rnd) ", hqm_system_sch_out_fifo_wm), OVM_LOW);
    if(hqm_system_sch_out_fifo_wm==255) hqm_system_sch_out_fifo_wm = $urandom_range(1,127);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: hqm_system_sch_out_fifo_wm=%d (cfgval) ", hqm_system_sch_out_fifo_wm), OVM_LOW);
 
     //--HOLD_HCW_W
    hqm_system_ingress_holdhcw_w=0; 
    $value$plusargs("hqmproc_sys_ingress_holdhcw_w=%h", hqm_system_ingress_holdhcw_w);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: hqm_system_ingress_holdhcw_w=0x%0x ", hqm_system_ingress_holdhcw_w), OVM_LOW);
 
     //--SINGLE_STEP_ENQ
     hqm_system_ingress_single_step_enq=0;
    $value$plusargs("hqmproc_sys_ingress_single_step_enq=%h", hqm_system_ingress_single_step_enq);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: hqm_system_ingress_single_step_enq=0x%0x ", hqm_system_ingress_single_step_enq), OVM_LOW);
 
     //--SINGLE_STEP_HCW_W 
     hqm_system_ingress_single_step_hcw_w=0;
    $value$plusargs("hqmproc_sys_ingress_single_step_hcw_w=%h", hqm_system_ingress_single_step_hcw_w);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: hqm_system_ingress_single_step_hcw_w=0x%0x ", hqm_system_ingress_single_step_hcw_w), OVM_LOW);
 
     //--ENABLE_DEBUG  
     hqm_system_ingress_enable_debug=0;
    $value$plusargs("hqmproc_sys_ingress_enable_debug=%h", hqm_system_ingress_enable_debug);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task setting: hqm_system_ingress_enable_debug=0x%0x ", hqm_system_ingress_enable_debug), OVM_LOW);
 


     //------------------------------------------------------
     //------------------------------------------------------
     //--
     if($test$plusargs("hqmsys_msix_passthrough")) begin
            read_reg("MSIX_PASSTHROUGH", rd_val , "hqm_system_csr");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.MSIX_PASSTHROUGH.init.rd=0x%0x", rd_val), OVM_LOW); 

            wr_val=32'h01;
            write_reg("MSIX_PASSTHROUGH", wr_val , "hqm_system_csr");

            read_reg("MSIX_PASSTHROUGH", rd_val , "hqm_system_csr");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.MSIX_PASSTHROUGH.rd=0x%0x", rd_val), OVM_LOW); 
     end
     //------------------------------------------------------
     //------------------------------------------------------
     //--LDB_CQ2TC_MAP
        
        read_reg("ldb_cq2tc_map", rd_val, "hqm_sif_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_sif_csr.ldb_cq2tc_map.init.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("ldb_cq2tc_map"), '{"LDB0_TC"}, '{ldb_cq2tc_map0}, "hqm_sif_csr");
        write_fields($psprintf("ldb_cq2tc_map"), '{"LDB1_TC"}, '{ldb_cq2tc_map1}, "hqm_sif_csr");
        write_fields($psprintf("ldb_cq2tc_map"), '{"LDB2_TC"}, '{ldb_cq2tc_map2}, "hqm_sif_csr");
        write_fields($psprintf("ldb_cq2tc_map"), '{"LDB3_TC"}, '{ldb_cq2tc_map3}, "hqm_sif_csr");

        read_reg("ldb_cq2tc_map", rd_val, "hqm_sif_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_sif_csr.ldb_cq2tc_map.rd=0x%0x", rd_val), OVM_LOW); 
          if (rd_val != wr_val) begin
                //ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_sif_csr.ldb_cq2tc_map.rd=0x%0x wr=0x%0x mismatched", rd_val, wr_val), OVM_LOW);
          end 

     //--DIR_CQ2TC_MAP
        read_reg("dir_cq2tc_map", rd_val, "hqm_sif_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_sif_csr.dir_cq2tc_map.init.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("dir_cq2tc_map"), '{"DIR0_TC"}, '{dir_cq2tc_map0}, "hqm_sif_csr");
        write_fields($psprintf("dir_cq2tc_map"), '{"DIR1_TC"}, '{dir_cq2tc_map1}, "hqm_sif_csr");
        write_fields($psprintf("dir_cq2tc_map"), '{"DIR2_TC"}, '{dir_cq2tc_map2}, "hqm_sif_csr");
        write_fields($psprintf("dir_cq2tc_map"), '{"DIR3_TC"}, '{dir_cq2tc_map3}, "hqm_sif_csr");

        read_reg("dir_cq2tc_map", rd_val, "hqm_sif_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_sif_csr.dir_cq2tc_map.rd=0x%0x", rd_val), OVM_LOW); 
          if (rd_val != wr_val) begin
                //ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_sif_csr.dir_cq2tc_map.rd=0x%0x wr=0x%0x mismatched", rd_val, wr_val), OVM_LOW);
          end 

     //--INT_CQ2TC_MAP
        read_reg("int2tc_map", rd_val, "hqm_sif_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_sif_csr.int_cq2tc_map.init.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("int2tc_map"), '{"INT_TC"}, '{int_cq2tc_map}, "hqm_sif_csr");
        read_reg("int2tc_map", rd_val, "hqm_sif_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_sif_csr.int_cq2tc_map.rd=0x%0x", rd_val), OVM_LOW); 
          if (rd_val != wr_val) begin
                //ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_sif_csr.int_cq2tc_map.rd=0x%0x wr=0x%0x mismatched", rd_val, wr_val), OVM_LOW);
          end 


     //------------------------------------------------------
     //------------------------------------------------------
     //-- HQMV30 removed ZERO_CL_START
     //------------------------------------------------------
     if(hqm_system_ingress_enqzeroclstart!=0) begin
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_CTL.init.rd=0x%0x", rd_val), OVM_LOW); 
        //-- HQMV30 removed ZERO_CL_START   write_fields($psprintf("INGRESS_CTL"), '{"ZERO_CL_START"}, '{hqm_system_ingress_enqzeroclstart}, "hqm_system_csr");
        //-- HQMV30 removed ZERO_CL_START   read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        //-- HQMV30 removed ZERO_CL_START   ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_CTL.rd=0x%0x", rd_val), OVM_LOW); 
     end //-

     if(hqm_system_enq_fifo_wm!=0) begin
        read_reg("HCW_ENQ_FIFO_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.HCW_ENQ_FIFO_CTL.init.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("HCW_ENQ_FIFO_CTL"), '{"HIGH_WM"}, '{hqm_system_enq_fifo_wm}, "hqm_system_csr");
        read_reg("HCW_ENQ_FIFO_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.HCW_ENQ_FIFO_CTL.rd=0x%0x", rd_val), OVM_LOW); 
     end //-

     if(hqm_system_sch_out_fifo_wm!=0) begin
        read_reg("SCH_OUT_FIFO_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.SCH_OUT_FIFO_CTL.init.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("SCH_OUT_FIFO_CTL"), '{"HIGH_WM"}, '{hqm_system_sch_out_fifo_wm}, "hqm_system_csr");
        read_reg("SCH_OUT_FIFO_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.SCH_OUT_FIFO_CTL.rd=0x%0x", rd_val), OVM_LOW); 
     end //-

     //--HOLD_HCW_W
     if(hqm_system_ingress_holdhcw_w!=0) begin
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_CTL.init.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("INGRESS_CTL"), '{"HOLD_HCW_W"}, '{hqm_system_ingress_holdhcw_w}, "hqm_system_csr");
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_CTL.rd=0x%0x HOLD_HCW_W_bit1=1", rd_val), OVM_LOW); 
     end //-

     //--SINGLE_STEP_ENQ
     if(hqm_system_ingress_single_step_enq!=0) begin
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_CTL.init.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("INGRESS_CTL"), '{"SINGLE_STEP_ENQ"}, '{hqm_system_ingress_single_step_enq}, "hqm_system_csr");
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_CTL.rd=0x%0x SINGLE_STEP_ENQ_bit2=1", rd_val), OVM_LOW); 
     end //-

     //--SINGLE_STEP_HCW_W 
     if(hqm_system_ingress_single_step_hcw_w!=0) begin
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_CTL.init.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("INGRESS_CTL"), '{"SINGLE_STEP_HCW_W"}, '{hqm_system_ingress_single_step_hcw_w}, "hqm_system_csr");
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_CTL.rd=0x%0x SINGLE_STEP_HCW_W_bit3=1", rd_val), OVM_LOW); 
     end //-

     //--ENABLE_DEBUG  
     if(hqm_system_ingress_enable_debug!=0) begin
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_CTL.init.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("INGRESS_CTL"), '{"ENABLE_DEBUG"}, '{hqm_system_ingress_enable_debug}, "hqm_system_csr");
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_CTL.rd=0x%0x ENABLE_DEBUG_bit4=1", rd_val), OVM_LOW); 
     end //-

     //------------------------------------------------------
     //------------------------------------------------------
     //--
     read_reg("INGRESS_ALARM_ENABLE", rd_val , "hqm_system_csr");
     ovm_report_info("HQMPROC_TB_CFG_NSEQ4",$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_ALARM_ENABLE.init.rd_val = 0x%08x",  rd_val), OVM_LOW);

     //-- enable ingress_alarm
     //"illegal_ldb_qid"; "Enable illegal load balanced qid cfg alarm (sn or fid inconsistency) on ingress HCWs";    ILLEGAL_LDB_QID_CFG [5:5] = 1'h0;
     //"disabled_qid";    "Enable disabled qid resource alarm (disabled qid, or disabled vasqid) on ingress HCWs";   DISABLED_QID        [4:4] = 1'h0;
     //"illegal_qid";     "Enable illegal qid alarm on ingress HCWs";                                                ILLEGAL_QID         [3:3] = 1'h0;
     //"disabled_pp";     "Enable disabled pp alarm on ingress HCWs";                                                DISABLED_PP         [2:2] = 1'h0; ::: this is changed to be ILLEGAL_PASID
     //"illegal_pp";      "Enable illegal pp alarm on ingress HCWs";                                                 ILLEGAL_PP          [1:1] = 1'h0;
     //"illegal_hcw";     "Enable illegal HCW alarm (illegal command or qid greater than 127) on ingress HCWs";      ILLEGAL_HCW         [0:0] = 1'h0;

     if($test$plusargs("hqmsys_ingalenable")) begin
            wr_val=32'h3f;
            write_reg("INGRESS_ALARM_ENABLE", wr_val , "hqm_system_csr");
     end else begin
        if($test$plusargs("hqmsys_ingalena_illegal_hcw")) begin
            write_fields($psprintf("INGRESS_ALARM_ENABLE"), '{"ILLEGAL_HCW"}, '{'h1}, "hqm_system_csr");
            //--bit0: Enable illegal HCW alarm (illegal command or qid greater than 63(dir) or 31(ldb)) on ingress HCWs
        end
        if($test$plusargs("hqmsys_ingalena_illegal_pp")) begin
            write_fields($psprintf("INGRESS_ALARM_ENABLE"), '{"ILLEGAL_PP"}, '{'h1}, "hqm_system_csr");
            //--bit1 Enable illegal pp or pasid alarm on ingress HCWs
        end
        if($test$plusargs("hqmsys_ingalena_dis_pp")) begin
            write_fields($psprintf("INGRESS_ALARM_ENABLE"), '{"ILLEGAL_PASID"}, '{'h1}, "hqm_system_csr");
            //--bit2 Enable illegal pasid alarm on ingress HCWs
        end
        if($test$plusargs("hqmsys_ingalena_illegal_qid")) begin
            write_fields($psprintf("INGRESS_ALARM_ENABLE"), '{"ILLEGAL_QID"}, '{'h1}, "hqm_system_csr");
            //--bit3 Enable illegal qid alarm on ingress HCWs
        end
        if($test$plusargs("hqmsys_ingalena_dis_qid")) begin
            write_fields($psprintf("INGRESS_ALARM_ENABLE"), '{"DISABLED_QID"}, '{'h1}, "hqm_system_csr");
            //--bit4  Enable disabled qid resource alarm (disabled qid, or disabled vasqid) on ingress HCWs
        end
        if($test$plusargs("hqmsys_ingalena_illegal_ldbqid")) begin
            write_fields($psprintf("INGRESS_ALARM_ENABLE"), '{"ILLEGAL_LDB_QID_CFG"}, '{'h1}, "hqm_system_csr");
            //--bit5  Enable illegal load balanced qid cfg alarm (sn or fid inconsistency) on ingress HCWs
        end
     end

     //--
     read_reg("INGRESS_ALARM_ENABLE", rd_val , "hqm_system_csr");
     ovm_report_info("HQMPROC_TB_CFG_NSEQ4",$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_ctrl_task: hqm_system_csr.INGRESS_ALARM_ENABLE.rd_val = 0x%08x",  rd_val), OVM_LOW);


     //----------------------------------------- temp
/*----
     for(int i=0; i<2; i++) begin
            //--LSP.CFG_QID_AQED_ACTIVE_LIMIT
            read_reg($psprintf("CFG_QID_AQED_ACTIVE_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_cfg_hqm_system_after_vas_reset_S2: list_sel_pipe.CFG_QID_AQED_ACTIVE_LIMIT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_QID_AQED_ACTIVE_LIMIT[%0d]",i), '{"LIMIT"}, '{i_hqm_cfg.ldb_qid_cfg[i].aqed_freelist_limit - i_hqm_cfg.ldb_qid_cfg[i].aqed_freelist_base + 1},  "list_sel_pipe");  
            read_reg($psprintf("CFG_QID_AQED_ACTIVE_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_cfg_hqm_system_after_vas_reset_S2: list_sel_pipe.CFG_QID_AQED_ACTIVE_LIMIT[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            read_reg($psprintf("CFG_LDB_CQ_DEPTH[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_cfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_LDB_CQ_DEPTH[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_LDB_CQ_DEPTH[%0d]",i), '{"DEPTH"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].cq_token_count},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_LDB_CQ_DEPTH[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_cfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_LDB_CQ_DEPTH[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

     end
----*/

endtask:cfg_hqm_system_ctrl_task  

//-------------------------
//-- HQMV30 ROB: general support
// cfg_hqm_system_robcfg_task
//------------------------- 
virtual task cfg_hqm_system_robcfg_task(int rob_ctrl);
  sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
  bit                           rob_v;
  
  
  ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_robcfg_task: start with rob_ctrl=%0d", rob_ctrl), OVM_LOW); 

  for(int i=0; i<hqm_pkg::NUM_LDB_PP; i++) begin
      if(rob_ctrl==0)      rob_v=0;
      else if(rob_ctrl==1) rob_v=1;
      else                 rob_v=$urandom_range(0,1);

      //--write
      write_fields($psprintf("LDB_PP_ROB_V[%0d]",i), '{"ROB_V"}, '{rob_v}, "hqm_system_csr");
      i_hqm_cfg.ldb_pp_cq_cfg[i].cl_rob=rob_v;

      //--read
      read_reg($psprintf("LDB_PP_ROB_V[%0d]",i), rd_val, "hqm_system_csr");
      if(rd_val[0]!=rob_v)
        ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_robcfg_task: hqm_system_csr.LDB_PP_ROB_V[%0d].rd=0x%0x rob_v=%0d mismatched", i, rd_val, rob_v), OVM_LOW); 
      else 
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_robcfg_task: hqm_system_csr.LDB_PP_ROB_V[%0d].rd=0x%0x rob_v=%0d: hqm_cfg.ldb_pp_cq_cfg[%0d].cl_rob=%0d rob_v=%0d", i, rd_val, rob_v, i, i_hqm_cfg.ldb_pp_cq_cfg[i].cl_rob, rob_v), OVM_LOW); 
  end


  for(int i=0; i<hqm_pkg::NUM_DIR_PP; i++) begin
      if(rob_ctrl==0)      rob_v=0;
      else if(rob_ctrl==1) rob_v=1;
      else                 rob_v=$urandom_range(0,1);

      //--write
      write_fields($psprintf("DIR_PP_ROB_V[%0d]",i), '{"ROB_V"}, '{rob_v}, "hqm_system_csr");
      i_hqm_cfg.dir_pp_cq_cfg[i].cl_rob=rob_v;

      //--read
      read_reg($psprintf("DIR_PP_ROB_V[%0d]",i), rd_val, "hqm_system_csr");
      if(rd_val[0]!=rob_v)
        ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_robcfg_task: hqm_system_csr.DIR_PP_ROB_V[%0d].rd=0x%0x rob_v=%0d mismatched", i, rd_val, rob_v), OVM_LOW); 
      else 
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_robcfg_task: hqm_system_csr.DIR_PP_ROB_V[%0d].rd=0x%0x rob_v=%0d: hqm_cfg.ldb_pp_cq_cfg[%0d].cl_rob=%0d rob_v=%0d", i, rd_val, rob_v, i, i_hqm_cfg.ldb_pp_cq_cfg[i].cl_rob, rob_v), OVM_LOW); 
  end
endtask:cfg_hqm_system_robcfg_task 



//-------------------------
//-- HQMV30 AO: general support
// cfg_hqm_system_aocfg_task
//------------------------- 
virtual task cfg_hqm_system_aocfg_task(int ao_cfg_ctrl);
  sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
  bit                           ao_cfg_v;
  bit                           is_fid_qid_v, is_sn_qid_v, is_ao_cfg_v;
  
  
  ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_aocfg_task: start with ao_cfg_ctrl=%0d", ao_cfg_ctrl), OVM_LOW); 

  for(int i=0; i<hqm_pkg::NUM_LDB_QID; i++) begin
      if(ao_cfg_ctrl==0)      ao_cfg_v=0;
      else if(ao_cfg_ctrl==1) ao_cfg_v=1;
      else if(ao_cfg_ctrl==2) ao_cfg_v=$urandom_range(0,1);

      is_fid_qid_v = i_hqm_cfg.is_fid_qid_v(i);
      is_sn_qid_v  = i_hqm_cfg.is_sn_qid_v(i);
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_aocfg_task_1: QID=%0d is_sn_qid_v=%0d is_fid_qid_v=%0d, ao_cfg_v=%0d", i, is_sn_qid_v, is_fid_qid_v, ao_cfg_v), OVM_LOW); 

      //--
      if(is_fid_qid_v && is_sn_qid_v) begin  
          //--write
          ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_aocfg_task_2: QID=%0d is_sn_qid_v=%0d is_fid_qid_v=%0d - program ao_cfg_v=%0d", i, is_sn_qid_v, is_fid_qid_v, ao_cfg_v), OVM_LOW); 
          write_fields($psprintf("LDB_QID_CFG_V[%0d]",i), '{"AO_CFG_V"}, '{ao_cfg_v}, "hqm_system_csr");
          i_hqm_cfg.ldb_qid_cfg[i].ao_cfg_v=ao_cfg_v;

          //--read
          read_reg($psprintf("LDB_QID_CFG_V[%0d]",i), rd_val, "hqm_system_csr");
          if(rd_val[2:0]!={ao_cfg_v,is_fid_qid_v,is_sn_qid_v})
               ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_aocfg_task_3: hqm_system_csr.LDB_QID_CFG_V[%0d].rd=0x%0x: {ao_cfg_v,is_fid_qid_v,is_sn_qid_v}=0x%0x mismatched", i, rd_val, {ao_cfg_v,is_fid_qid_v,is_sn_qid_v}), OVM_LOW); 
          else 
               ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_aocfg_task_3: hqm_system_csr.LDB_QID_CFG_V[%0d].rd=0x%0x: hqm_cfg.ldb_qid_cfg[%0d].ao_cfg_v=%0d, {ao_cfg_v,is_fid_qid_v,is_sn_qid_v}=0x%0x", i, rd_val, i, i_hqm_cfg.ldb_qid_cfg[i].ao_cfg_v, {ao_cfg_v,is_fid_qid_v,is_sn_qid_v}), OVM_LOW); 
      end


      is_fid_qid_v = i_hqm_cfg.is_fid_qid_v(i);
      is_sn_qid_v  = i_hqm_cfg.is_sn_qid_v(i);
      is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(i);
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_aocfg_task_4: QID=%0d is_sn_qid_v=%0d is_fid_qid_v=%0d is_ao_cfg_v=%0d", i, is_sn_qid_v, is_fid_qid_v, is_ao_cfg_v), OVM_LOW); 
  end
  ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_aocfg_task: done with ao_cfg_ctrl=%0d ao_cfg_v=%0d", ao_cfg_ctrl, ao_cfg_v), OVM_LOW); 

endtask:cfg_hqm_system_aocfg_task 





//-------------------------
// cfg_chp_vas_credit_reprog_task(); 
//------------------------- 
virtual task cfg_chp_vas_credit_reprog_task(int total_credit_num);
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
     int vas_num;
     int vas_credit;

     wr_val=0;
     vas_num=0;

     foreach(i_hqm_cfg.vas_cfg[i]) begin
        if(i_hqm_cfg.vas_cfg[i].enable) vas_num++;
     end

     vas_credit=total_credit_num/vas_num;
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_vas_credit_reprog_task: total_credit_num=%0d vas_num=%0d => vas_credit=%0d", total_credit_num, vas_num, vas_credit), OVM_LOW);

     foreach(i_hqm_cfg.vas_cfg[i]) begin

        read_reg($psprintf("CFG_VAS_CREDIT_COUNT[%0d]",i), rd_val, "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_vas_credit_reprog_task: CFG_VAS_CREDIT_COUNT[%0d].init_program.rd=%0d; hqm_cfg.vas_cfg[%0d].enable=%0d, hqm_cfg.vas_cfg[%0d].credit_cnt=%0d", i, rd_val, i, i_hqm_cfg.vas_cfg[i].enable, i, i_hqm_cfg.vas_cfg[i].credit_cnt), OVM_LOW);
         
        if(i_hqm_cfg.vas_cfg[i].enable) begin
           write_fields($psprintf("CFG_VAS_CREDIT_COUNT[%0d]",i), '{"COUNT"}, '{vas_credit}, "credit_hist_pipe");
           i_hqm_cfg.vas_cfg[i].credit_cnt = vas_credit;  
           i_hqm_cfg.i_hqm_pp_cq_status.set_vas_credits(i, i_hqm_cfg.vas_cfg[i].credit_cnt);

           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_vas_credit_reprog_task: CFG_VAS_CREDIT_COUNT[%0d].reprogram.wr=%0d; hqm_cfg.vas_cfg[%0d].credit_cnt=%0d", i, vas_credit, i, i_hqm_cfg.vas_cfg[i].credit_cnt), OVM_LOW);
        end 
        read_reg($psprintf("CFG_VAS_CREDIT_COUNT[%0d]",i), rd_val, "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_vas_credit_reprog_task: CFG_VAS_CREDIT_COUNT[%0d].reprogram.rd=%0d", i, rd_val), OVM_LOW);
     end

endtask:cfg_chp_vas_credit_reprog_task


//-------------------------
// cfg_hqm_system_qidits_task
//------------------------- 
virtual task cfg_hqm_system_qidits_task();
  sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];

  for(int i=0; i<hqm_pkg::NUM_LDB_QID; i++) begin
      write_fields($psprintf("LDB_QID_ITS[%0d]",i), '{"QID_ITS"}, '{'b1}, "hqm_system_csr");
      read_reg($psprintf("LDB_QID_ITS[%0d]",i), rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_qidits_task: hqm_system_csr.LDB_QID_ITS[%0d].rd=0x%0x", i, rd_val), OVM_LOW); 
  end
  for(int i=0; i<hqm_pkg::NUM_DIR_CQ; i++) begin
      write_fields($psprintf("DIR_QID_ITS[%0d]",i), '{"QID_ITS"}, '{'b1}, "hqm_system_csr");
      read_reg($psprintf("DIR_QID_ITS[%0d]",i), rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_qidits_task: hqm_system_csr.DIR_QID_ITS[%0d].rd=0x%0x", i, rd_val), OVM_LOW); 
  end
endtask:cfg_hqm_system_qidits_task  

//-------------------------
// cfg_hqm_system_pasid_task
//------------------------- 
virtual task cfg_hqm_system_pasid_task();
  sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];

  for(int i=0; i<hqm_pkg::NUM_LDB_CQ; i++) begin
      read_reg($psprintf("LDB_CQ_PASID[%0d]",i), rd_val, "hqm_system_csr");
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_pasid_task: hqm_system_csr.LDB_CQ_PASID[%0d].rd.init=0x%0x", i, rd_val), OVM_LOW); 
      write_fields($psprintf("LDB_CQ_PASID[%0d]",i), '{"FMT2"}, '{'b1}, "hqm_system_csr");
      read_reg($psprintf("LDB_CQ_PASID[%0d]",i), rd_val, "hqm_system_csr");
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_pasid_task: hqm_system_csr.LDB_CQ_PASID[%0d].rd=0x%0x", i, rd_val), OVM_LOW); 
  end
  for(int i=0; i<hqm_pkg::NUM_DIR_CQ; i++) begin
      read_reg($psprintf("DIR_CQ_PASID[%0d]",i), rd_val, "hqm_system_csr");
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_pasid_task: hqm_system_csr.DIR_CQ_PASID[%0d].rd.init=0x%0x", i, rd_val), OVM_LOW); 
      write_fields($psprintf("DIR_CQ_PASID[%0d]",i), '{"FMT2"}, '{'b1}, "hqm_system_csr");
      read_reg($psprintf("DIR_CQ_PASID[%0d]",i), rd_val, "hqm_system_csr");
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_hqm_system_pasid_task: hqm_system_csr.DIR_CQ_PASID[%0d].rd=0x%0x", i, rd_val), OVM_LOW); 
  end
endtask:cfg_hqm_system_pasid_task  

//-------------------------
// cfg_cq_disable_task: disable_in=1 => DISABLE
//------------------------- 
virtual task cfg_cq_disable_task(bit is_ldb_in, int cq_num_in, bit disable_in);
    string pp_cq_prefix;
    sla_ral_data_t                rd_val, wr_val;
    
 
    if (is_ldb_in) begin
      pp_cq_prefix = "LDB";
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_cq_disable_task: is_ldb=%0d cq_num=%0d with i_hqm_cfg.ldb_pp_cq_cfg[%0d].cq_pcq=%0d ", is_ldb_in, cq_num_in, cq_num_in, i_hqm_cfg.ldb_pp_cq_cfg[cq_num_in].cq_pcq), OVM_LOW);
    end else begin
      pp_cq_prefix = "DIR";
    end

    //-------------
    read_reg($psprintf("cfg_cq_%0s_disable[%0d]", pp_cq_prefix, cq_num_in), rd_val, "list_sel_pipe");
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_cq_disable_task: is_ldb=%0d cq_num=%0d curr rd_val=0x%0x ", is_ldb_in, cq_num_in, rd_val), OVM_LOW);

    //-------------
    wr_val=rd_val;
    wr_val[0]=disable_in;
    if (is_ldb_in) begin
      wr_val[1]= ~i_hqm_cfg.ldb_pp_cq_cfg[cq_num_in].cq_pcq;
    end 
    write_reg($psprintf("cfg_cq_%0s_disable[%0d]", pp_cq_prefix, cq_num_in), wr_val, "list_sel_pipe");
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_cq_disable_task: configure is_ldb=%0d cq_num=%0d wr_val=0x%0x disable=%0d ", is_ldb_in, cq_num_in, wr_val, disable_in), OVM_LOW);
endtask:cfg_cq_disable_task  

  
//-------------------------
// cfg_chp_cmpsnck_enable_task(); 
//------------------------- 
virtual task cfg_chp_cmpsnck_enable_task(bit cmpsnck_enable, int cqnum);
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
 
     wr_val=0;
     wr_val[0]=cmpsnck_enable;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cmpsnck_enable_task: credit_hist_pipe.CFG_CMP_SN_CHK_ENBL[%0d] setting cmpsnck_enable=%0d", cqnum, cmpsnck_enable), OVM_LOW);
     //foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin
          write_reg($psprintf("CFG_CMP_SN_CHK_ENBL[%0d]",cqnum), wr_val, "credit_hist_pipe");
          read_reg($psprintf("CFG_CMP_SN_CHK_ENBL[%0d]",cqnum), rd_val, "credit_hist_pipe");
          if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cmpsnck_enable_task: credit_hist_pipe.CFG_CMP_SN_CHK_ENBL[%0d].hqmcfgwr=0x%0x bgcfgrd=0x%0x mismatched", cqnum, wr_val, rd_val), OVM_LOW);
          end 
     //end
endtask:cfg_chp_cmpsnck_enable_task


//-------------------------
// cfg_chp_armallcq_task(); 
//------------------------- 
virtual task cfg_chp_armallcq_task();
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
 
    read_reg("CFG_LDB_CQ_INTR_ARMED0", rd_val , "credit_hist_pipe");
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_armallcq_task: credit_hist_pipe.CFG_LDB_CQ_INTR_ARMED0.init.rd=0x%0x ",rd_val), OVM_LOW);
    read_reg("CFG_LDB_CQ_INTR_ARMED1", rd_val , "credit_hist_pipe");
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_armallcq_task: credit_hist_pipe.CFG_LDB_CQ_INTR_ARMED1.init.rd=0x%0x ",rd_val), OVM_LOW);
    read_reg("CFG_DIR_CQ_INTR_ARMED0", rd_val , "credit_hist_pipe");
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_armallcq_task: credit_hist_pipe.CFG_DIR_CQ_INTR_ARMED0.init.rd=0x%0x ",rd_val), OVM_LOW);
    read_reg("CFG_DIR_CQ_INTR_ARMED1", rd_val , "credit_hist_pipe");
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_armallcq_task: credit_hist_pipe.CFG_DIR_CQ_INTR_ARMED1.init.rd=0x%0x ",rd_val), OVM_LOW);

    wr_val=32'hffff_ffff;
    write_reg("CFG_LDB_CQ_INTR_ARMED0", wr_val , "credit_hist_pipe");
    write_reg("CFG_LDB_CQ_INTR_ARMED1", wr_val , "credit_hist_pipe");
    write_reg("CFG_DIR_CQ_INTR_ARMED0", wr_val , "credit_hist_pipe");
    write_reg("CFG_DIR_CQ_INTR_ARMED1", wr_val , "credit_hist_pipe");

    read_reg("CFG_LDB_CQ_INTR_ARMED0", rd_val , "credit_hist_pipe");
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_armallcq_task: credit_hist_pipe.CFG_LDB_CQ_INTR_ARMED0.rd=0x%0x ",rd_val), OVM_LOW);
    read_reg("CFG_LDB_CQ_INTR_ARMED1", rd_val , "credit_hist_pipe");
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_armallcq_task: credit_hist_pipe.CFG_LDB_CQ_INTR_ARMED1.rd=0x%0x ",rd_val), OVM_LOW);

    read_reg("CFG_DIR_CQ_INTR_ARMED0", rd_val , "credit_hist_pipe");
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_armallcq_task: credit_hist_pipe.CFG_DIR_CQ_INTR_ARMED0.rd=0x%0x ",rd_val), OVM_LOW);
    read_reg("CFG_DIR_CQ_INTR_ARMED1", rd_val , "credit_hist_pipe");
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_armallcq_task: credit_hist_pipe.CFG_DIR_CQ_INTR_ARMED1.rd=0x%0x ",rd_val), OVM_LOW);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_armallcq_task: done "), OVM_LOW);
endtask:cfg_chp_armallcq_task  

//-------------------------
// cfg_chp_cqirq_mask_task(); 
// 1/ set cq_int_mask_check=0 once enter the cfg flow
// 2/ set cq_int_mask_check=1 after all cfg completed
//---TBD 3/
// 3/ when set mask, set hqm_cfg.CQ.cq_int_mask=1 after write: let pp_cq_hqm_proc_seq switch to mask_on flow
//    but when set unmask, set hqm_cfg.CQ.cq_int_mask=0 afer read,
//------------------------- 
virtual task cfg_chp_cqirq_mask_task(bit is_ldb, int cq_num, bit cq_int_mask); 
    sla_ral_data_t                rd_val_pending, rd_val, rd_val_unitidle, wr_val, wr_val1, wr_val_q[$], rd_val_addr_l0, rd_val_addr_l1, rd_val_addr_u0, rd_val_addr_u1, rd_val_data_0, rd_val_data_1;
    int                           mask2unmask_intr_poll;
    bit [7:0]                     ims_idx_val;

    mask2unmask_intr_poll = 0;

    ims_idx_val = i_hqm_cfg.get_ims_idx(is_ldb, cq_num);

    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S0 setting: is_ldb=%0d will-reprogram-CQ[%0d].cq_int_mask=%0d ims_idx=%0d", is_ldb, cq_num, cq_int_mask, ims_idx_val), OVM_LOW);

    if(ims_idx_val>=0) begin 
       if(is_ldb) begin
           i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask_check = 0;       
   
           //--S1 read pending bit, if pending=1, set cq_int_mask_run = 2 (will poll intr before rearm); otherwise, cq_int_mask_run = 1 (will issue rearm)
           read_reg($psprintf("AI_CTRL[%0d]",ims_idx_val), rd_val, "hqm_system_csr");
           rd_val_pending[0] = rd_val[1];

           //--check unit_idle
           read_reg("CFG_DIAGNOSTIC_IDLE_STATUS", rd_val , "config_master");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S1: config_master.CFG_DIAGNOSTIC_IDLE_STATUS.rd=0x%0x", rd_val), OVM_LOW); 
   
           //-- if pending=1, set cq_int_mask_run = 2 (will poll intr before rearm); otherwise, cq_int_mask_run = 1 (will issue rearm)
           if(rd_val_pending[0]==1 && cq_int_mask==0 && i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask==1 && i_hqm_cfg.hqmproc_trfctrl!=2) begin
              mask2unmask_intr_poll = 1;  
           end
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S1: check pending bit: hqm_system_csr.AI_CTRL[%0d].rd=0x%0x; mask2unmask_intr_poll=%0d; cq_int_mask_run=%0d (1: can issue rearm; 2: poll intr before rearm), is_ldb=%0d cq=%0d", ims_idx_val, rd_val_pending, mask2unmask_intr_poll, i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask_run, is_ldb, cq_num), OVM_LOW);
   
           //----------------------------------------
           //--S2 re-program AI_CTRL for mask/unmask 
           read_reg($psprintf("AI_CTRL[%0d]",ims_idx_val), rd_val, "hqm_system_csr");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S2.1: hqm_system_csr.AI_CTRL[%0d].rd=0x%0x is_ldb=%0d cq=%0d", ims_idx_val, rd_val, is_ldb, cq_num), OVM_LOW);
           wr_val=rd_val;
           wr_val[0]=cq_int_mask;      
           write_reg($psprintf("AI_CTRL[%0d]",ims_idx_val), wr_val, "hqm_system_csr");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S2.2: hqm_system_csr.AI_CTRL[%0d].wr=0x%0x is_ldb=%0d cq=%0d", ims_idx_val, wr_val, is_ldb, cq_num), OVM_LOW);
                      
           //----------------------------------------
           //--S3: check intr
           if(mask2unmask_intr_poll && i_hqm_cfg.hqmproc_trfctrl!=2) begin
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S3: LDBCQ[%0d] mask -> unmask cq_int_intr_state=1", cq_num), OVM_LOW);
                i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_intr_state = 1;
                while(i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_intr_state == 1) begin
                     wait_idle(1);
                end
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S3: LDBCQ[%0d] mask -> unmask INTR_RECV pending intr ", cq_num), OVM_LOW);
           end
           
           //----------------------------------------
           //--S4 readbck check
           read_reg($psprintf("AI_CTRL[%0d]",ims_idx_val), rd_val, "hqm_system_csr");
           if(rd_val[0]!=wr_val[0]) 
              ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S4: hqm_system_csr.AI_CTRL[%0d].rd.new=0x%0x wr_val=0x%0x cq_int_mask=%0d ", ims_idx_val, rd_val, wr_val, cq_int_mask), OVM_LOW);
           else
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S4: hqm_system_csr.AI_CTRL[%0d].rd.new=0x%0x cq_int_mask=%0d ", ims_idx_val, rd_val, cq_int_mask), OVM_LOW);
   
           //----------------------------------------
           //--S5 if pending=0, set cq_int_mask_run = 1 (will poll intr before rearm); otherwise, cq_int_mask_run = 1 (will issue rearm)
           i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask_run = 1;       
   
           //-- use this part of code when seeing issue when changing from mask-state to unmask-state
           //--this part is added when changing from mask-state to unmask-state, in trf-seq, to avoid the case that it's in wait state but reprogram changes cq_int_mask:  
           if(cq_int_mask==0 && $test$plusargs("HQMPROC_IMS_REPROG")) begin
               //-- current state is mask-state, it's about to change to unmask-state, when trfseq is in cq_int_mask_wait=1, don't change i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask
               while(i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask_wait == 1) begin
                     wait_idle(50);
                     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S5_cq_int_mask_wait=1: hqm_cfg.ldb_pp_cq_cfg[%0d].cq_int_mask=%0d, cq_int_mask_run=%0d(1: can issue rearm; 2: poll intr before rearm)", cq_num, i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask, i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask_run), OVM_LOW);
               end
   
               i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask = cq_int_mask;   //--update hqm_cfg after reprogram all done
           end else begin
              i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask = cq_int_mask;   //--update hqm_cfg after reprogram all done
           end
   
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S5_reprog: hqm_cfg.ldb_pp_cq_cfg[%0d].cq_int_mask=%0d, cq_int_mask_run=%0d(1: can issue rearm; 2: poll intr before rearm)", cq_num, i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask, i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask_run), OVM_LOW);
           i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask_check = 1;       
   
   
           //----------------------------------------
           //--S6.0: before reprogram MASK, read IMS registgers
           if($test$plusargs("HQMPROC_IMS_REPROG")) begin
              read_reg($psprintf("AI_ADDR_L[%0d]",ims_idx_val), rd_val, "hqm_system_csr");
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S6.0: hqm_system_csr.AI_ADDR_L[%0d].rd=0x%0x; i_hqm_cfg.ldb_ims_cfg[%0d].addr[31:0]=0x%0x", ims_idx_val, rd_val, cq_num, i_hqm_cfg.ldb_ims_cfg[cq_num].addr[31:0]), OVM_LOW);
              read_reg($psprintf("AI_ADDR_U[%0d]",ims_idx_val), rd_val, "hqm_system_csr");
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S6.0: hqm_system_csr.AI_ADDR_R[%0d].rd=0x%0x; i_hqm_cfg.ldb_ims_cfg[%0d].addr[63:32]=0x%0x ", ims_idx_val, rd_val, cq_num, i_hqm_cfg.ldb_ims_cfg[cq_num].addr[63:32]), OVM_LOW);
              read_reg($psprintf("AI_DATA[%0d]",ims_idx_val), rd_val, "hqm_system_csr");
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S6.0: hqm_system_csr.AI_DATA[%0d].rd=0x%0x; i_hqm_cfg.ldb_ims_cfg[%0d].data=0x%0x ", ims_idx_val, rd_val, cq_num, i_hqm_cfg.ldb_ims_cfg[cq_num].data), OVM_LOW);
           end
   
           //--S2.01 
           if($test$plusargs("HQMPROC_IMS_REPROG") && cq_int_mask==1 && cq_num==1) begin 
                read_reg($psprintf("AI_ADDR_L[%0d]",hqm_pkg::NUM_DIR_CQ), rd_val_addr_l0, "hqm_system_csr");
                read_reg($psprintf("AI_ADDR_U[%0d]",hqm_pkg::NUM_DIR_CQ), rd_val_addr_u0, "hqm_system_csr");
                read_reg($psprintf("AI_DATA[%0d]",hqm_pkg::NUM_DIR_CQ), rd_val_data_0, "hqm_system_csr");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S6.1_rd: hqm_system_csr.AI_ADDR_L[96]=0x%0x, AI_ADDR_U[96]=0x%0x, AI_DATA[96].rd=0x%0x; will re-program with ldb_ims_cfg[1].addr=0x%0x/data=0x%0x ", rd_val_addr_l0, rd_val_addr_u0, rd_val_data_0, i_hqm_cfg.ldb_ims_cfg[1].addr[31:0], i_hqm_cfg.ldb_ims_cfg[1].data[31:0]), OVM_LOW);
   
                write_fields($psprintf("AI_ADDR_L[%0d]", hqm_pkg::NUM_DIR_CQ), '{"IMS_ADDR_L"}, '{i_hqm_cfg.ldb_ims_cfg[1].addr[31:2]}, "hqm_system_csr");
                write_fields($psprintf("AI_ADDR_U[%0d]", hqm_pkg::NUM_DIR_CQ), '{"IMS_ADDR_U"}, '{i_hqm_cfg.ldb_ims_cfg[1].addr[63:32]}, "hqm_system_csr");
                write_fields($psprintf("AI_DATA[%0d]", hqm_pkg::NUM_DIR_CQ), '{"IMS_DATA"}, '{i_hqm_cfg.ldb_ims_cfg[1].data[31:0]}, "hqm_system_csr");
   
                read_reg($psprintf("AI_ADDR_L[%0d]",hqm_pkg::NUM_DIR_CQ), rd_val_addr_l0, "hqm_system_csr");
                read_reg($psprintf("AI_ADDR_U[%0d]",hqm_pkg::NUM_DIR_CQ), rd_val_addr_u0, "hqm_system_csr");
                read_reg($psprintf("AI_DATA[%0d]",hqm_pkg::NUM_DIR_CQ), rd_val_data_0, "hqm_system_csr");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S6.1_afterrewrite.rd: hqm_system_csr.AI_ADDR_L[0]=0x%0x, AI_ADDR_U[0]=0x%0x, AI_DATA[0].rd=0x%0x; current ldb_ims_cfg[1].addr=0x%0x/data=0x%0x", rd_val_addr_l0, rd_val_addr_u0, rd_val_data_0, i_hqm_cfg.ldb_ims_cfg[1].addr[31:0], i_hqm_cfg.ldb_ims_cfg[1].data[31:0]), OVM_LOW);
                
   
                //--
                read_reg($psprintf("AI_ADDR_L[%0d]",hqm_pkg::NUM_DIR_CQ+1), rd_val_addr_l1, "hqm_system_csr");
                read_reg($psprintf("AI_ADDR_U[%0d]",hqm_pkg::NUM_DIR_CQ+1), rd_val_addr_u1, "hqm_system_csr");
                read_reg($psprintf("AI_DATA[%0d]",hqm_pkg::NUM_DIR_CQ+1), rd_val_data_1, "hqm_system_csr");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S6.2_rd: hqm_system_csr.AI_ADDR_L[97]=0x%0x, AI_ADDR_U[97]=0x%0x, AI_DATA[97].rd=0x%0x; will re-program with ldb_ims_cfg[0].addr=0x%0x/data=0x%0x", rd_val_addr_l1, rd_val_addr_u1, rd_val_data_1, i_hqm_cfg.ldb_ims_cfg[0].addr[31:0], i_hqm_cfg.ldb_ims_cfg[0].data[31:0]), OVM_LOW);
   
                write_fields($psprintf("AI_ADDR_L[%0d]", hqm_pkg::NUM_DIR_CQ+1), '{"IMS_ADDR_L"}, '{i_hqm_cfg.ldb_ims_cfg[0].addr[31:2]}, "hqm_system_csr");
                write_fields($psprintf("AI_ADDR_U[%0d]", hqm_pkg::NUM_DIR_CQ+1), '{"IMS_ADDR_U"}, '{i_hqm_cfg.ldb_ims_cfg[0].addr[63:32]}, "hqm_system_csr");
                write_fields($psprintf("AI_DATA[%0d]", hqm_pkg::NUM_DIR_CQ+1), '{"IMS_DATA"}, '{i_hqm_cfg.ldb_ims_cfg[0].data[31:0]}, "hqm_system_csr");
   
                read_reg($psprintf("AI_ADDR_L[%0d]",hqm_pkg::NUM_DIR_CQ+1), rd_val_addr_l1, "hqm_system_csr");
                read_reg($psprintf("AI_ADDR_U[%0d]",hqm_pkg::NUM_DIR_CQ+1), rd_val_addr_u1, "hqm_system_csr");
                read_reg($psprintf("AI_DATA[%0d]",hqm_pkg::NUM_DIR_CQ+1), rd_val_data_1, "hqm_system_csr");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S6.2_rewrite.rd: hqm_system_csr.AI_ADDR_L[97]=0x%0x, AI_ADDR_U[97]=0x%0x, AI_DATA[97].rd=0x%0x; current ldb_ims_cfg[0].addr=0x%0x/data=0x%0x", rd_val_addr_l1, rd_val_addr_u1, rd_val_data_1, i_hqm_cfg.ldb_ims_cfg[0].addr[31:0], i_hqm_cfg.ldb_ims_cfg[0].data[31:0]), OVM_LOW);
   
   
                i_hqm_cfg.ldb_ims_cfg[0].addr[31:2]  = rd_val_addr_l0[31:2]; 
                i_hqm_cfg.ldb_ims_cfg[0].addr[63:32] = rd_val_addr_u0; 
                i_hqm_cfg.ldb_ims_cfg[0].data[31:0]  = rd_val_data_0;
                i_hqm_cfg.ldb_ims_cfg[1].addr[31:2]  = rd_val_addr_l1[31:2]; 
                i_hqm_cfg.ldb_ims_cfg[1].addr[63:32] = rd_val_addr_u1; 
                i_hqm_cfg.ldb_ims_cfg[1].data[31:0]  = rd_val_data_1;

                i_hqm_cfg.ims_prog_cfg[hqm_pkg::NUM_DIR_CQ].addr[31:2]  = rd_val_addr_l0[31:2]; 
                i_hqm_cfg.ims_prog_cfg[hqm_pkg::NUM_DIR_CQ].addr[63:32] = rd_val_addr_u0; 
                i_hqm_cfg.ims_prog_cfg[hqm_pkg::NUM_DIR_CQ].data[31:0]  = rd_val_data_0;
                i_hqm_cfg.ims_prog_cfg[hqm_pkg::NUM_DIR_CQ+1].addr[31:2]  = rd_val_addr_l1[31:2]; 
                i_hqm_cfg.ims_prog_cfg[hqm_pkg::NUM_DIR_CQ+1].addr[63:32] = rd_val_addr_u1; 
                i_hqm_cfg.ims_prog_cfg[hqm_pkg::NUM_DIR_CQ+1].data[31:0]  = rd_val_data_1;
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S6.3: Setting ldb_ims_cfg[0].addr=0x%0x/data=0x%0x ldb_ims_cfg[1].addr=0x%0x/data=0x%0x", i_hqm_cfg.ldb_ims_cfg[0].addr[31:0], i_hqm_cfg.ldb_ims_cfg[0].data[31:0], i_hqm_cfg.ldb_ims_cfg[1].addr[31:0], i_hqm_cfg.ldb_ims_cfg[1].data[31:0]), OVM_LOW);
           end//
   
       end else begin
           i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask_check = 0;       
   
           //--S1 read pending bit, 
           read_reg($psprintf("AI_CTRL[%0d]",ims_idx_val), rd_val, "hqm_system_csr");
           rd_val_pending[0] = rd_val[1];
   
           //--check unit_idle
           read_reg("CFG_DIAGNOSTIC_IDLE_STATUS", rd_val , "config_master");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S1: config_master.CFG_DIAGNOSTIC_IDLE_STATUS.rd=0x%0x", rd_val), OVM_LOW); 
   
           //-- if pending=1, set cq_int_mask_run = 2 (will poll intr before rearm); otherwise, cq_int_mask_run = 1 (will issue rearm)
           if(rd_val_pending[0]==1 && cq_int_mask==0 && i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask==1 && i_hqm_cfg.hqmproc_trfctrl!=2) begin
              mask2unmask_intr_poll = 1;  
           end
   
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S1: check pending bit: hqm_system_csr.AI_CTRL[%0d].rd=0x%0x; mask2unmask_intr_poll=%0d; cq_int_mask_run=%0d (1: can issue rearm; 2: poll intr before rearm)", ims_idx_val, rd_val_pending, mask2unmask_intr_poll, i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask_run), OVM_LOW);
   
   
           //--S2 re-program AI_CTRL for mask/unmask 
           read_reg($psprintf("AI_CTRL[%0d]",ims_idx_val), rd_val, "hqm_system_csr");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S2.1: hqm_system_csr.AI_CTRL[%0d].rd=0x%0x is_ldb=%0d cq=%0d", ims_idx_val, rd_val, is_ldb, cq_num), OVM_LOW);
           wr_val=rd_val;
           wr_val[0]=cq_int_mask;      
           write_reg($psprintf("AI_CTRL[%0d]",ims_idx_val), wr_val, "hqm_system_csr");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S2.2: hqm_system_csr.AI_CTRL[%0d].wr=0x%0x is_ldb=%0d cq=%0d ", ims_idx_val, wr_val, is_ldb, cq_num), OVM_LOW);
   
           //--S3: check intr
           if(mask2unmask_intr_poll && i_hqm_cfg.hqmproc_trfctrl!=2) begin
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S3: DIRCQ[%0d] mask -> unmask cq_int_intr_state=1", cq_num), OVM_LOW);
                i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_intr_state = 1;
                while(i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_intr_state == 1) begin
                     wait_idle(1);
                end
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S3: DIRCQ[%0d] mask -> unmask INTR_RECV pending intr ", cq_num), OVM_LOW);
           end
   
           //--S4 readbck check
           read_reg($psprintf("AI_CTRL[%0d]",ims_idx_val), rd_val, "hqm_system_csr");
           if(rd_val[0]!=wr_val[0]) 
              ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S4: hqm_system_csr.AI_CTRL[%0d].rd.new=0x%0x wr_val=0x%0x cq_int_mask=%0d is_ldb=%0d cq=%0d ", ims_idx_val, rd_val, wr_val, cq_int_mask, is_ldb, cq_num), OVM_LOW);
           else
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S4: hqm_system_csr.AI_CTRL[%0d].rd.new=0x%0x cq_int_mask=%0d is_ldb=%0d cq=%0d ", ims_idx_val, rd_val, cq_int_mask, is_ldb, cq_num), OVM_LOW);
    
           //--S5: if pending=1, set cq_int_mask_run = 2 (will poll intr before rearm); otherwise, cq_int_mask_run = 1 (will issue rearm)
           i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask_run = 1;       
   
           i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask = cq_int_mask;   //--update hqm_cfg after reprogram all done
   
           //-- use this part of code when seeing issue when changing from mask-state to unmask-state
           //--this part is added when changing from mask-state to unmask-state, in trf-seq, to avoid the case that it's in wait state but reprogram changes cq_int_mask:  
           //if(cq_int_mask==0 && $test$plusargs("HQMPROC_IMS_REPROG")) begin
           //    //-- current state is mask-state, it's about to change to unmask-state, when trfseq is in cq_int_mask_wait=1, don't change i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask
           //    while(i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask_wait == 1) begin
           //          wait_idle(50);
           //          ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S5_cq_int_mask_wait=1: hqm_cfg.dir_pp_cq_cfg[%0d].cq_int_mask=%0d, cq_int_mask_run=%0d(1: can issue rearm; 2: poll intr before rearm)", cq_num, i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask, i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask_run), OVM_LOW);
           //    end
   
           //    i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask = cq_int_mask;   //--update hqm_cfg after reprogram all done
           //end else begin
           //   i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask = cq_int_mask;   //--update hqm_cfg after reprogram all done
           //end
   
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_S5_reprog: hqm_cfg.dir_pp_cq_cfg[%0d].cq_int_mask=%0d, cq_int_mask_run=%0d(1: can issue rearm; 2: poll intr before rearm)", cq_num, i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask, i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask_run), OVM_LOW);
           i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask_check = 1;       
       end
   
    end else begin
        //-- ims_idx_val <0 
        ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_done: done is_ldb=%0d CQ[%0d].cq_int_mask=%0d ims_idx_val=%0d", is_ldb, cq_num, cq_int_mask, ims_idx_val), OVM_LOW);
    end// if(ims_idx_val>=0) begin 

    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_task_done: done is_ldb=%0d CQ[%0d].cq_int_mask=%0d  ims_idx=%0d ", is_ldb, cq_num, cq_int_mask, ims_idx_val), OVM_LOW);
 
endtask:cfg_chp_cqirq_mask_task  


//-------------------------
// cfg_chp_cqirq_pending_check_task(); 
//------------------------- 
virtual task cfg_chp_cqirq_pending_check_task(bit is_ldb, int cq_num, bit cq_int_mask); 
    sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
    bit [7:0]                     ims_idx_val;

    ims_idx_val = i_hqm_cfg.get_ims_idx(is_ldb, cq_num);
    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_check_task: is_ldb=%0d CQ[%0d].cq_int_mask=%0d check cq_irq_pending of ims_idx_val=%0d  ", is_ldb, cq_num, cq_int_mask, ims_idx_val), OVM_LOW);

   if(ims_idx_val>=0) begin
       if(is_ldb) begin
          read_reg($psprintf("AI_CTRL[%0d]",ims_idx_val), rd_val, "hqm_system_csr");
          ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_check_task: hqm_system_csr.AI_CTRL[%0d].rd=0x%0x ", ims_idx_val, rd_val), OVM_LOW);

          if(rd_val[1] != cq_int_mask) 
             ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_check_task: hqm_system_csr.AI_CTRL[%0d].rd=0x%0x cq_int_mask=0x%0x doesn't match, ldb_pp_cq_cfg[%0d].cq_int_mask=%0d ", ims_idx_val, rd_val, cq_int_mask, cq_num, i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask), OVM_LOW);
          else
             ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_check_task: hqm_system_csr.AI_CTRL[%0d].rd=0x%0x cq_int_mask=0x%0x expected, ldb_pp_cq_cfg[%0d].cq_int_mask=%0d ", ims_idx_val, rd_val, cq_int_mask, cq_num, i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_int_mask), OVM_LOW);

       end else begin
          read_reg($psprintf("AI_CTRL[%0d]",ims_idx_val), rd_val, "hqm_system_csr");
          ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_check_task: hqm_system_csr.AI_CTRL[%0d].rd=0x%0x ", cq_num, rd_val), OVM_LOW);

          if(rd_val[1] != cq_int_mask) 
             ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_check_task: hqm_system_csr.AI_CTRL[%0d].rd=0x%0x cq_int_mask=0x%0x doesn't match, dir_pp_cq_cfg[%0d].cq_int_mask=%0d ", ims_idx_val, rd_val, cq_int_mask, cq_num, i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask), OVM_LOW);
          else
             ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_check_task: hqm_system_csr.AI_CTRL[%0d].rd=0x%0x cq_int_mask=0x%0x expected, dir_pp_cq_cfg[%0d].cq_int_mask=%0d ", ims_idx_val, rd_val, cq_int_mask, cq_num, i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_int_mask), OVM_LOW);

       end
    end else begin
        //-- ims_idx_val <0 
        ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_check_task: is_ldb=%0d CQ[%0d].cq_int_mask=%0d ims_idx_val=%0d<0", is_ldb, cq_num, cq_int_mask, ims_idx_val), OVM_LOW);
    end

    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_check_task: done is_ldb=%0d CQ[%0d].cq_int_mask=%0d ims_idx_val=%0d", is_ldb, cq_num, cq_int_mask, ims_idx_val), OVM_LOW);
 
endtask:cfg_chp_cqirq_pending_check_task  



//-------------------------
// -- cqirq_mask_unmask sequential flow : program/reprogram mask one by one
// -- cfg_chp_cqirq_mask_unmask_task (); 
// -- when cq_int_interactive is 1, wait for  cq_int_mask_ena=1 before reprogramming
//------------------------- 
virtual task cfg_chp_cqirq_mask_unmask_task(int loop, int is_ldb, int cq_int_mask, int cq_int_interactive, int wait_num, int cq_num_min, int cq_num_max);
    sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
    int                           cq_num;

    for(int rloop=0; rloop<loop; rloop++) begin
       for(int i=cq_num_min; i<cq_num_max; i++) begin
          ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_unmask_task_S0_loop%0d: is_ldb=%0d CQ[%0d] re-program to cq_int_mask=%0d, wait_num=%0d cq_int_interactive=%0d", loop, is_ldb, i, cq_int_mask, wait_num, cq_int_interactive), OVM_LOW);
   
          if(cq_int_interactive && i_hqm_cfg.hqmproc_trfctrl!=2) begin
              //-- S1: wait for cq_int_mask_ena=1 (pp_cq_hqmproc_seq: before sending cmd=ARM, set cq_int_mask_ena=1)
              wait_idle(wait_num);
              if(is_ldb) begin
                 //-- turn on cq_int_mask_opt
                 i_hqm_cfg.ldb_pp_cq_cfg[i].cq_int_mask_opt = 1;
                 i_hqm_cfg.ldb_pp_cq_cfg[i].cq_int_mask_run = 0;

                 ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_unmask_task_S1_loop%0d: is_ldb=%0d CQ[%0d].cq_int_mask=%0d wait cq_int_mask_ena=1 to re-program to: cq_int_mask=%0d", loop, is_ldb, i, i_hqm_cfg.ldb_pp_cq_cfg[i].cq_int_mask, cq_int_mask), OVM_LOW);
                 while(i_hqm_cfg.ldb_pp_cq_cfg[i].cq_int_mask_ena == 0 && i_hqm_cfg.hqmproc_trfctrl!=2) wait_idle(10);
              end else begin
                 //-- turn on cq_int_mask_opt
                 i_hqm_cfg.dir_pp_cq_cfg[i].cq_int_mask_opt = 1;
                 i_hqm_cfg.dir_pp_cq_cfg[i].cq_int_mask_run = 0;

                 ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_unmask_task_S1_loop%0d: is_ldb=%0d CQ[%0d].cq_int_mask=%0d wait cq_int_mask_ena=1 to re-program to: cq_int_mask=%0d", loop, is_ldb, i, i_hqm_cfg.dir_pp_cq_cfg[i].cq_int_mask, cq_int_mask), OVM_LOW);
                 while(i_hqm_cfg.dir_pp_cq_cfg[i].cq_int_mask_ena == 0 && i_hqm_cfg.hqmproc_trfctrl!=2) wait_idle(10);
              end
                
              //-- S2: reprogram 
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_unmask_task_S2_loop%0d: is_ldb=%0d CQ[%0d] re-program to cq_int_mask=%0d", loop, is_ldb, i, cq_int_mask), OVM_LOW);
              cfg_chp_cqirq_mask_task(is_ldb, i, cq_int_mask);          


              //-- S3: clear cq_int_mask_ena
              wait_idle(wait_num);
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_unmask_task_S3_loop%0d: is_ldb=%0d CQ[%0d].cq_int_mask=%0d clear cq_int_mask_ena=0", loop, is_ldb, i, cq_int_mask), OVM_LOW);
              if(is_ldb) begin
                 i_hqm_cfg.ldb_pp_cq_cfg[i].cq_int_mask_ena = 0;
              end else begin
                 i_hqm_cfg.dir_pp_cq_cfg[i].cq_int_mask_ena = 0;
              end

              //wait_idle(wait_num);
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_mask_unmask_task_S4_loop%0d: is_ldb=%0d CQ[%0d].cq_int_mask=%0d clear cq_int_mask_opt=0", loop, is_ldb, i, cq_int_mask), OVM_LOW);
              if(is_ldb) begin
                 i_hqm_cfg.ldb_pp_cq_cfg[i].cq_int_mask_opt = 0;
              end else begin
                 i_hqm_cfg.dir_pp_cq_cfg[i].cq_int_mask_opt = 0;
              end
          end else if(i_hqm_cfg.hqmproc_trfctrl!=2)begin
              cfg_chp_cqirq_mask_task(is_ldb, i, cq_int_mask);          
          end        
       end
    end //for(int rloop
endtask:cfg_chp_cqirq_mask_unmask_task 

//-------------------------
// cfg_chp_cqirq_pending_task (); 
//------------------------- 
virtual task cfg_chp_cqirq_pending_task(int is_ldb, int cq_num_min, int cq_num_max);
    sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
    int                           cq_num;
    bit                           cq_int_mask_val;

              
       for(int i=cq_num_min; i<cq_num_max; i++) begin
          if(is_ldb) begin
             ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_task_S1: is_ldb=%0d CQ[%0d].cq_int_mask=%0d wait for hqm_cfg.ldb_pp_cq_cfg[%0d].cq_irq_pending_check=1", is_ldb, i, i_hqm_cfg.ldb_pp_cq_cfg[i].cq_int_mask, i), OVM_LOW);
             while(i_hqm_cfg.ldb_pp_cq_cfg[i].cq_irq_pending_check == 0 && i_hqm_cfg.hqmproc_trfctrl!=2) wait_idle(10);
             cq_int_mask_val = i_hqm_cfg.ldb_pp_cq_cfg[i].cq_int_mask;
          end else begin
             ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_task_S1: is_ldb=%0d CQ[%0d].cq_int_mask=%0d wait for hqm_cfg.dir_pp_cq_cfg[%0d].cq_irq_pending_check=1", is_ldb, i, i_hqm_cfg.dir_pp_cq_cfg[i].cq_int_mask, i), OVM_LOW);
             while(i_hqm_cfg.dir_pp_cq_cfg[i].cq_irq_pending_check == 0 && i_hqm_cfg.hqmproc_trfctrl!=2) wait_idle(10);
             cq_int_mask_val = i_hqm_cfg.dir_pp_cq_cfg[i].cq_int_mask;
          end

          //-- S4: check pending bit 
          if(i_hqm_cfg.hqmproc_trfctrl!=2) begin
             ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_task_S2: is_ldb=%0d CQ[%0d].cq_int_mask=%0d now cq_irq_pending_check=1, check cq_irq_pending cq_int_mask_val=%0d", is_ldb, i, cq_int_mask_val, cq_int_mask_val), OVM_LOW);
             cfg_chp_cqirq_pending_check_task(is_ldb, i, cq_int_mask_val);          
          end

          if(is_ldb) begin
             i_hqm_cfg.ldb_pp_cq_cfg[i].cq_irq_pending_check = 0;
          end else begin
             i_hqm_cfg.dir_pp_cq_cfg[i].cq_irq_pending_check = 0;
          end
          ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqirq_pending_task_S3: is_ldb=%0d CQ[%0d].cq_int_mask=%0d set hqm_cfg.ldb_pp_cq_cfg[%0d].cq_irq_pending_check=0 done; hqm_cfg.hqmproc_trfctrl=%0d(2: all trf stopped)", is_ldb, i, cq_int_mask_val, i, i_hqm_cfg.hqmproc_trfctrl), OVM_MEDIUM);


       end
endtask:cfg_chp_cqirq_pending_task 

//-------------------------
// cfg_chp_cqtimer_cwdt_task(); 
//------------------------- 
virtual task cfg_chp_cqtimer_cwdt_task();
  sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
  int                           dir_cq_timer_on;
  int                           dir_cq_timer_intrv;
  int                           ldb_cq_timer_on;
  int                           ldb_cq_timer_intrv;

  int                           dir_cwdt_disable0, dir_cwdt_disable1, dir_cwdt_disable2;
  int                           dir_cwdt_enb;
  int                           dir_cwdt_intrv;
  int                           dir_cwdt_thresh;
  int                           ldb_cwdt_disable0, ldb_cwdt_disable1;
  int                           ldb_cwdt_enb;
  int                           ldb_cwdt_intrv;
  int                           ldb_cwdt_thresh;
 
      dir_cq_timer_on    = 0;
      $value$plusargs("hqmproc_dir_cq_timer_on=%d", dir_cq_timer_on);
      dir_cq_timer_intrv = 0;
      $value$plusargs("hqmproc_dir_cq_timer_intrv=%d", dir_cq_timer_intrv);
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task setting_chp_timer_cfg: dir_cq_timer_on=%0d/intrv=%0d ", dir_cq_timer_on, dir_cq_timer_intrv), OVM_LOW);

      ldb_cq_timer_on    = 0;
      $value$plusargs("hqmproc_ldb_cq_timer_on=%d", ldb_cq_timer_on);
      ldb_cq_timer_intrv = 0;
      $value$plusargs("hqmproc_ldb_cq_timer_intrv=%d", ldb_cq_timer_intrv);
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task setting_chp_timer_cfg: ldb_cq_timer_on=%0d/intrv=%0d ", ldb_cq_timer_on, ldb_cq_timer_intrv), OVM_LOW);


      dir_cwdt_disable0 = 0;
      $value$plusargs("hqmproc_dir_cwdt_disable_0=%h", dir_cwdt_disable0);
      dir_cwdt_disable1 = 0;
      $value$plusargs("hqmproc_dir_cwdt_disable_1=%h", dir_cwdt_disable1);
      dir_cwdt_disable2 = 0;
      $value$plusargs("hqmproc_dir_cwdt_disable_2=%h", dir_cwdt_disable2);
      dir_cwdt_enb   = 0;
      $value$plusargs("hqmproc_dir_cwdt_enb=%d", dir_cwdt_enb);
      dir_cwdt_intrv   = 0;
      $value$plusargs("hqmproc_dir_cwdt_intrv=%d", dir_cwdt_intrv);
      dir_cwdt_thresh  = 0;
      $value$plusargs("hqmproc_dir_cwdt_thresh=%d", dir_cwdt_thresh);
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task setting_chp_cwdt_cfg:  dir_cwdt_disable0=0x%0x/dir_cwdt_disable1=0x%0x/dir_cwdt_disable2=0x%0x/enb=%0d/intrv=%0d/thresh=%0d",
                       dir_cwdt_disable0, dir_cwdt_disable1, dir_cwdt_disable2, dir_cwdt_enb, dir_cwdt_intrv, dir_cwdt_thresh), OVM_LOW);

      ldb_cwdt_disable0 = 0;
      $value$plusargs("hqmproc_ldb_cwdt_disable_0=%h", ldb_cwdt_disable0);
      ldb_cwdt_disable1 = 0;
      $value$plusargs("hqmproc_ldb_cwdt_disable_1=%h", ldb_cwdt_disable1);
      ldb_cwdt_enb   = 0;
      $value$plusargs("hqmproc_ldb_cwdt_enb=%d", ldb_cwdt_enb);
      ldb_cwdt_intrv   = 0;
      $value$plusargs("hqmproc_ldb_cwdt_intrv=%d", ldb_cwdt_intrv);
      ldb_cwdt_thresh  = 0;
      $value$plusargs("hqmproc_ldb_cwdt_thresh=%d", ldb_cwdt_thresh);
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task setting_chp_cwdt_cfg:  ldb_cwdt_disable0=0x%0x/ldb_cwdt_disable1=0x%0x/enb=%0d/intrv=%0d/thresh=%0d",
                       ldb_cwdt_disable0, ldb_cwdt_disable1, ldb_cwdt_enb, ldb_cwdt_intrv, ldb_cwdt_thresh), OVM_LOW);

     i_hqm_cfg.cialcwdt_cfg.ldb_cq_timer_on     = ldb_cq_timer_on;
     i_hqm_cfg.cialcwdt_cfg.ldb_cq_timer_intrv  = ldb_cq_timer_intrv;
     i_hqm_cfg.cialcwdt_cfg.dir_cq_timer_on     = dir_cq_timer_on;
     i_hqm_cfg.cialcwdt_cfg.dir_cq_timer_intrv  = dir_cq_timer_intrv;

//     i_hqm_cfg.cialcwdt_cfg.dir_cwdt_disable[95:64] = dir_cwdt_disable2;
     i_hqm_cfg.cialcwdt_cfg.dir_cwdt_disable[63:32] = dir_cwdt_disable1;
     i_hqm_cfg.cialcwdt_cfg.dir_cwdt_disable[31:0]  = dir_cwdt_disable0;
     i_hqm_cfg.cialcwdt_cfg.dir_cwdt_enb            = dir_cwdt_enb;
     i_hqm_cfg.cialcwdt_cfg.dir_cwdt_intrv          = dir_cwdt_intrv;
     i_hqm_cfg.cialcwdt_cfg.dir_cwdt_thresh         = dir_cwdt_thresh;

     i_hqm_cfg.cialcwdt_cfg.ldb_cwdt_disable[63:32] = ldb_cwdt_disable1;
     i_hqm_cfg.cialcwdt_cfg.ldb_cwdt_disable[31:0]  = ldb_cwdt_disable0;
     i_hqm_cfg.cialcwdt_cfg.ldb_cwdt_enb            = ldb_cwdt_enb;
     i_hqm_cfg.cialcwdt_cfg.ldb_cwdt_intrv          = ldb_cwdt_intrv;
     i_hqm_cfg.cialcwdt_cfg.ldb_cwdt_thresh         = ldb_cwdt_thresh;

     //-- CIAL.timer
     wr_val=0;
     wr_val[8]   =  i_hqm_cfg.cialcwdt_cfg.ldb_cq_timer_on;
     wr_val[7:0] =  i_hqm_cfg.cialcwdt_cfg.ldb_cq_timer_intrv;
     write_reg("CFG_LDB_CQ_TIMER_CTL", wr_val, "credit_hist_pipe");
     read_reg("CFG_LDB_CQ_TIMER_CTL", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_LDB_CQ_TIMER_CTL.rd=0x%0x ",rd_val), OVM_LOW);
 
    
     wr_val=0;
     wr_val[8]   =  i_hqm_cfg.cialcwdt_cfg.dir_cq_timer_on;
     wr_val[7:0] =  i_hqm_cfg.cialcwdt_cfg.dir_cq_timer_intrv;
     write_reg("CFG_DIR_CQ_TIMER_CTL", wr_val, "credit_hist_pipe");
     read_reg("CFG_DIR_CQ_TIMER_CTL", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_DIR_CQ_TIMER_CTL.rd=0x%0x ",rd_val), OVM_LOW);

     //-- CWDT
     //-- cwdt ldb
     wr_val=0;
     wr_val=i_hqm_cfg.cialcwdt_cfg.ldb_cwdt_disable[31:0];
     read_reg("CFG_LDB_WD_DISABLE0", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_LDB_WD_DISABLE0.rd.init=0x%0x ",rd_val), OVM_LOW);
     write_reg("CFG_LDB_WD_DISABLE0", wr_val, "credit_hist_pipe");
     read_reg("CFG_LDB_WD_DISABLE0", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_LDB_WD_DISABLE0.rd=0x%0x wr_val=0x%0x", rd_val, wr_val), OVM_LOW);

     wr_val=0;
     wr_val=i_hqm_cfg.cialcwdt_cfg.ldb_cwdt_disable[63:32];
     write_reg("CFG_LDB_WD_DISABLE1", wr_val, "credit_hist_pipe");
     read_reg("CFG_LDB_WD_DISABLE1", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_LDB_WD_DISABLE1.rd=0x%0x ",rd_val), OVM_LOW);

     wr_val=0;
     wr_val[28]   =  i_hqm_cfg.cialcwdt_cfg.ldb_cwdt_enb ;
     wr_val[27:0] =  i_hqm_cfg.cialcwdt_cfg.ldb_cwdt_intrv;
     write_reg("CFG_LDB_WD_ENB_INTERVAL", wr_val, "credit_hist_pipe");
     read_reg("CFG_LDB_WD_ENB_INTERVAL", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_LDB_WD_ENB_INTERVAL.rd=0x%0x ",rd_val), OVM_LOW);

     wr_val=0;
     wr_val[7:0] =  i_hqm_cfg.cialcwdt_cfg.ldb_cwdt_thresh;
     write_reg("CFG_LDB_WD_THRESHOLD", wr_val, "credit_hist_pipe");
     read_reg("CFG_LDB_WD_THRESHOLD", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_LDB_WD_THRESHOLD.rd=0x%0x ",rd_val), OVM_LOW);

     //-- cwdt dir
     wr_val=0;
     wr_val=i_hqm_cfg.cialcwdt_cfg.dir_cwdt_disable[31:0];
     write_reg("CFG_DIR_WD_DISABLE0", wr_val, "credit_hist_pipe");
     read_reg("CFG_DIR_WD_DISABLE0", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_DIR_WD_DISABLE0.rd=0x%0x ",rd_val), OVM_LOW);

     wr_val=0;
     wr_val=i_hqm_cfg.cialcwdt_cfg.dir_cwdt_disable[63:32];
     write_reg("CFG_DIR_WD_DISABLE1", wr_val, "credit_hist_pipe");
     read_reg("CFG_DIR_WD_DISABLE1", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_DIR_WD_DISABLE1.rd=0x%0x ",rd_val), OVM_LOW);

//     wr_val=0;
//     wr_val=i_hqm_cfg.cialcwdt_cfg.dir_cwdt_disable[95:64];
//     write_reg("CFG_DIR_WD_DISABLE2", wr_val, "credit_hist_pipe");
//     read_reg("CFG_DIR_WD_DISABLE2", rd_val , "credit_hist_pipe");
//     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_DIR_WD_DISABLE2.rd=0x%0x ",rd_val), OVM_LOW);


     wr_val=0;
     wr_val[28]   =  i_hqm_cfg.cialcwdt_cfg.dir_cwdt_enb ;
     wr_val[27:0] =  i_hqm_cfg.cialcwdt_cfg.dir_cwdt_intrv;
     write_reg("CFG_DIR_WD_ENB_INTERVAL", wr_val, "credit_hist_pipe");
     read_reg("CFG_DIR_WD_ENB_INTERVAL", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_DIR_WD_ENB_INTERVAL.rd=0x%0x ",rd_val), OVM_LOW);

     wr_val=0;
     wr_val[7:0] =  i_hqm_cfg.cialcwdt_cfg.dir_cwdt_thresh;
     write_reg("CFG_DIR_WD_THRESHOLD", wr_val, "credit_hist_pipe");
     read_reg("CFG_DIR_WD_THRESHOLD", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_cqtimer_cwdt_task: credit_hist_pipe.CFG_DIR_WD_THRESHOLD.rd=0x%0x ",rd_val), OVM_LOW);


endtask:cfg_chp_cqtimer_cwdt_task  

//-------------------------------------
//-------------------------------------
//-- LSP configure_lsp_perfctrl_task
//-------------------------------------
//-------------------------------------
task configure_lsp_cq_pcq_task(int cq_pcq_ctrl);
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
     int cq_pcq_enable;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_cq_pcq_task: start configure_lsp_cq_pcq_task"), OVM_LOW);

     foreach(i_hqm_cfg.ldb_pp_cq_cfg[i]) begin
         if(i_hqm_cfg.ldb_pp_cq_cfg[i].cq_enable && i>0) begin
            if(i%2==1 && i_hqm_cfg.ldb_pp_cq_cfg[i-1].cq_enable==1) begin
                cq_pcq_enable = (cq_pcq_ctrl==1)? 1 : $urandom_range(0, cq_pcq_ctrl-1); 

                if(cq_pcq_enable==1) begin
                    //--odd CQ
                    read_reg($psprintf("CFG_CQ_LDB_DISABLE[%0d]",i), rd_val, "list_sel_pipe");
                    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_cq_pcq_task: odd CQ program - CFG_CQ_LDB_DISABLE[%0d].initrd=0x%0x", i, rd_val), OVM_LOW);

                    write_fields($psprintf("CFG_CQ_LDB_DISABLE[%0d]",i), '{"ENABLED_PCQ"}, '{'b1}, "list_sel_pipe"); //bit1: ENABLED_PCQ (1: enable); bit0: DISABLED_CQ (0: enable)
                    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_cq_pcq_task: odd CQ program - CFG_CQ_LDB_DISABLE[%0d].ENABLED_PCQ=1 (Enable PCQ)", i), OVM_LOW);

                    read_reg($psprintf("CFG_CQ_LDB_DISABLE[%0d]",i), rd_val, "list_sel_pipe");
                    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_cq_pcq_task: odd CQ program - CFG_CQ_LDB_DISABLE[%0d].rd=0x%0x", i, rd_val), OVM_LOW);
                    if(rd_val[1]==1 && rd_val[0]==0) begin
                       i_hqm_cfg.ldb_pp_cq_cfg[i].cq_pcq = 1;
                       ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_cq_pcq_task: odd CQ program - ldb_pp_cq_cfg[%0d].cq_enable=%0d ldb_pp_cq_cfg[%0d].cq_pcq=%0d", i, i_hqm_cfg.ldb_pp_cq_cfg[i].cq_enable, i, i_hqm_cfg.ldb_pp_cq_cfg[i].cq_pcq), OVM_LOW);
                    end 

                    //--even CQ
                    read_reg($psprintf("CFG_CQ_LDB_DISABLE[%0d]",i-1), rd_val, "list_sel_pipe");
                    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_cq_pcq_task: even CQ reprogram - CFG_CQ_LDB_DISABLE[%0d].initrd=0x%0x", i-1, rd_val), OVM_LOW);

                    write_fields($psprintf("CFG_CQ_LDB_DISABLE[%0d]",i-1), '{"ENABLED_PCQ"}, '{'b1}, "list_sel_pipe");
                    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_cq_pcq_task: even CQ reprogram - CFG_CQ_LDB_DISABLE[%0d].ENABLED_PCQ=1 (Enable PCQ)", i-1), OVM_LOW);

                    read_reg($psprintf("CFG_CQ_LDB_DISABLE[%0d]",i-1), rd_val, "list_sel_pipe");
                    ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_cq_pcq_task: even CQ reprogram - CFG_CQ_LDB_DISABLE[%0d].rd=0x%0x", i-1, rd_val), OVM_LOW);
                    if(rd_val[1]==1 && rd_val[0]==0) begin
                       i_hqm_cfg.ldb_pp_cq_cfg[i-1].cq_pcq = 1;
                       ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_cq_pcq_task: even CQ reprogram - ldb_pp_cq_cfg[%0d].cq_enable=%0d ldb_pp_cq_cfg[%0d].cq_pcq=%0d", i-1, i_hqm_cfg.ldb_pp_cq_cfg[i-1].cq_enable, i-1, i_hqm_cfg.ldb_pp_cq_cfg[i-1].cq_pcq), OVM_LOW);
                    end 

                end //--if(cq_pcq_enable==1
            end //--odd cq
         end//--cq_enable
     end
endtask:configure_lsp_cq_pcq_task

//-------------------------------------
//-------------------------------------
//-- LSP configure_lsp_perfctrl_task
//-------------------------------------
//-------------------------------------
task configure_lsp_perfctrl_task();
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];

      read_reg("CFG_LDB_SCHED_PERF_CONTROL", rd_val , "list_sel_pipe");
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_perfctrl_task: start default list_sel_pipe.CFG_LDB_SCHED_PERF_CONTROL.rd=%0d", rd_val), OVM_LOW);
      write_fields($psprintf("CFG_LDB_SCHED_PERF_CONTROL"), '{"ENAB"}, '{'b1}, "list_sel_pipe");
      read_reg("CFG_LDB_SCHED_PERF_CONTROL", rd_val , "list_sel_pipe");
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_perfctrl_task: done list_sel_pipe.CFG_LDB_SCHED_PERF_CONTROL.rd=%0d", rd_val), OVM_LOW);
endtask:configure_lsp_perfctrl_task 

task configure_lsp_perfctrl_clr_task();
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];

      read_reg("CFG_LDB_SCHED_PERF_CONTROL", rd_val , "list_sel_pipe");
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_perfctrl_task: start default list_sel_pipe.CFG_LDB_SCHED_PERF_CONTROL.rd=%0d", rd_val), OVM_LOW);
      write_fields($psprintf("CFG_LDB_SCHED_PERF_CONTROL"), '{"CLR"}, '{'b1}, "list_sel_pipe");
      read_reg("CFG_LDB_SCHED_PERF_CONTROL", rd_val , "list_sel_pipe");
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_perfctrl_task: done list_sel_pipe.CFG_LDB_SCHED_PERF_CONTROL.rd=%0d", rd_val), OVM_LOW);
endtask:configure_lsp_perfctrl_clr_task 


//-------------------------------------
//-------------------------------------
//-- LSP  configure_lsp_qidthreshold_task
//-------------------------------------
//-------------------------------------
task configure_lsp_qidthreshold_task();
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
     int                           qid_max_val, qid_ctrl, thres_val;    
     int                           hqm_lsp_qid_depth_thresh_qidmin, hqm_lsp_qid_depth_thresh_qidmax;

     hqm_lsp_qid_depth_thresh_qidmin = 0;
     $value$plusargs("hqm_lsp_qid_depth_thresh_qidmin=%d", hqm_lsp_qid_depth_thresh_qidmin);
     hqm_lsp_qid_depth_thresh_qidmax = 0;
     $value$plusargs("hqm_lsp_qid_depth_thresh_qidmax=%d", hqm_lsp_qid_depth_thresh_qidmax);
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_setting_qid_thresh_cfg: hqm_lsp_qid_depth_thresh_qidmin=%0d/max=%0d ", hqm_lsp_qid_depth_thresh_qidmin, hqm_lsp_qid_depth_thresh_qidmax), OVM_LOW);


     
    if($test$plusargs("hqm_lsp_atm_qid_depthres") || $test$plusargs("hqm_lsp_ldb_qid_depthres")  || $test$plusargs("hqm_lsp_dir_qid_depthres")) begin
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task: start "), OVM_LOW);
        if($test$plusargs("hqm_lsp_atm_qid_depthres")) begin
           for(int i=hqm_lsp_qid_depth_thresh_qidmin; i<hqm_lsp_qid_depth_thresh_qidmax; i++) begin
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task: ldb_qid_cfg[%0d].atm_qid_depth_thresh=%0d ", i, i_hqm_cfg.ldb_qid_cfg[i].atm_qid_depth_thresh), OVM_LOW);
            wr_val=0;
            wr_val = i_hqm_cfg.ldb_qid_cfg[i].atm_qid_depth_thresh;
            if(wr_val!=0) begin
                write_reg($psprintf("cfg_atm_qid_dpth_thrsh[%0d]",i), wr_val, "list_sel_pipe");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFGLSP_SEQ0: lsp_regs.CFG_ATM_QID_DPTH_THRSH[%0d]=0x%0x", i, wr_val), OVM_LOW);    
            end
           end//for
        end 


        if($test$plusargs("hqm_lsp_nalb_qid_depthres")) begin
           for(int i=hqm_lsp_qid_depth_thresh_qidmin; i<hqm_lsp_qid_depth_thresh_qidmax; i++) begin
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task: ldb_qid_cfg[%0d].nalb_qid_depth_thresh=%0d ", i, i_hqm_cfg.ldb_qid_cfg[i].nalb_qid_depth_thresh), OVM_LOW);
            wr_val=0;
            wr_val = i_hqm_cfg.ldb_qid_cfg[i].nalb_qid_depth_thresh;
            if(wr_val!=0) begin
                write_reg($psprintf("cfg_nalb_qid_dpth_thrsh[%0d]",i), wr_val, "list_sel_pipe");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFGLSP_SEQ0: lsp_regs.CFG_NALB_QID_DPTH_THRSH[%0d]=0x%0x", i, wr_val), OVM_LOW);    
            end
           end//for
        end 


        if($test$plusargs("hqm_lsp_dir_qid_depthres")) begin
           for(int i=hqm_lsp_qid_depth_thresh_qidmin; i<hqm_lsp_qid_depth_thresh_qidmax; i++) begin
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task: dir_qid_cfg[%0d].dir_qid_depth_thresh=%0d ", i, i_hqm_cfg.dir_qid_cfg[i].dir_qid_depth_thresh), OVM_LOW);
            wr_val=0;
            wr_val = i_hqm_cfg.dir_qid_cfg[i].dir_qid_depth_thresh;
            if(wr_val!=0) begin
                write_reg($psprintf("cfg_dir_qid_dpth_thrsh[%0d]",i), wr_val, "list_sel_pipe");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFGLSP_SEQ0: lsp_regs.CFG_DIR_QID_DPTH_THRSH[%0d]=0x%0x", i, wr_val), OVM_LOW);    
            end
           end//for
        end 
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task: completed "), OVM_LOW);

    end else if($test$plusargs("hqm_lsp_qid_depthres_rnd")) begin
        //-- this is a rnd control of LSP qid_depthres
	qid_ctrl    = $urandom_range(0, 3);
        if(hqm_lsp_qid_depth_thresh_qidmax==0) 	qid_max_val = $urandom_range(hqm_lsp_qid_depth_thresh_qidmax, 31);
        else                                    qid_max_val = hqm_lsp_qid_depth_thresh_qidmax;
		
		
        if(qid_ctrl==1) begin
           for(int i=hqm_lsp_qid_depth_thresh_qidmin; i<qid_max_val; i++) begin	   
              i_hqm_cfg.ldb_qid_cfg[i].atm_qid_depth_thresh = $urandom_range(128, 8192);	   
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: ldb_qid_cfg[%0d].atm_qid_depth_thresh=%0d ", i, i_hqm_cfg.ldb_qid_cfg[i].atm_qid_depth_thresh), OVM_LOW);
              wr_val=0;
              wr_val = i_hqm_cfg.ldb_qid_cfg[i].atm_qid_depth_thresh;
              if(wr_val!=0) begin
                  write_reg($psprintf("cfg_atm_qid_dpth_thrsh[%0d]",i), wr_val, "list_sel_pipe");
                  ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: lsp_regs.CFG_ATM_QID_DPTH_THRSH[%0d]=0x%0x", i, wr_val), OVM_LOW);    
              end
           end//for	
	
        end else if(qid_ctrl==2) begin 	
           for(int i=hqm_lsp_qid_depth_thresh_qidmin; i<qid_max_val; i++) begin	   
              i_hqm_cfg.ldb_qid_cfg[i].nalb_qid_depth_thresh = $urandom_range(128, 8192);	   
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: ldb_qid_cfg[%0d].nalb_qid_depth_thresh=%0d ", i, i_hqm_cfg.ldb_qid_cfg[i].nalb_qid_depth_thresh), OVM_LOW);
              wr_val=0;
              wr_val = i_hqm_cfg.ldb_qid_cfg[i].nalb_qid_depth_thresh;
              if(wr_val!=0) begin
                  write_reg($psprintf("cfg_nalb_qid_dpth_thrsh[%0d]",i), wr_val, "list_sel_pipe");
                  ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: lsp_regs.CFG_NALB_QID_DPTH_THRSH[%0d]=0x%0x", i, wr_val), OVM_LOW);    
              end
           end//for		
        end else if(qid_ctrl==3) begin 
           for(int i=hqm_lsp_qid_depth_thresh_qidmin; i<qid_max_val; i++) begin	   
              i_hqm_cfg.dir_qid_cfg[i].dir_qid_depth_thresh = $urandom_range(64, 4096);	   
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: dir_qid_cfg[%0d].dir_qid_depth_thresh=%0d ", i, i_hqm_cfg.dir_qid_cfg[i].dir_qid_depth_thresh), OVM_LOW);
              wr_val=0;
              wr_val = i_hqm_cfg.dir_qid_cfg[i].dir_qid_depth_thresh;
              if(wr_val!=0) begin
                  write_reg($psprintf("cfg_dir_qid_dpth_thrsh[%0d]",i), wr_val, "list_sel_pipe");
                  ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: lsp_regs.CFG_DIR_QID_DPTH_THRSH[%0d]=0x%0x", i, wr_val), OVM_LOW);    
              end
           end//for	
        end else begin
	
           if(hqm_lsp_qid_depth_thresh_qidmax==0)  qid_max_val = $urandom_range(hqm_lsp_qid_depth_thresh_qidmax, 31);
           else                                    qid_max_val = hqm_lsp_qid_depth_thresh_qidmax;	
           for(int i=hqm_lsp_qid_depth_thresh_qidmin; i<qid_max_val; i++) begin	   
              i_hqm_cfg.ldb_qid_cfg[i].atm_qid_depth_thresh = $urandom_range(128, 8192);	   
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: ldb_qid_cfg[%0d].atm_qid_depth_thresh=%0d ", i, i_hqm_cfg.ldb_qid_cfg[i].atm_qid_depth_thresh), OVM_LOW);
              wr_val=0;
              wr_val = i_hqm_cfg.ldb_qid_cfg[i].atm_qid_depth_thresh;
              if(wr_val!=0) begin
                  write_reg($psprintf("cfg_atm_qid_dpth_thrsh[%0d]",i), wr_val, "list_sel_pipe");
                  ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: lsp_regs.CFG_ATM_QID_DPTH_THRSH[%0d]=0x%0x", i, wr_val), OVM_LOW);    
              end
           end//for
	   	
           if(hqm_lsp_qid_depth_thresh_qidmax==0)  qid_max_val = $urandom_range(hqm_lsp_qid_depth_thresh_qidmax, 31);
           else                                    qid_max_val = hqm_lsp_qid_depth_thresh_qidmax;	
	   
           for(int i=hqm_lsp_qid_depth_thresh_qidmin; i<qid_max_val; i++) begin	   
              i_hqm_cfg.ldb_qid_cfg[i].nalb_qid_depth_thresh = $urandom_range(128, 8192);	   
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: ldb_qid_cfg[%0d].nalb_qid_depth_thresh=%0d ", i, i_hqm_cfg.ldb_qid_cfg[i].nalb_qid_depth_thresh), OVM_LOW);
              wr_val=0;
              wr_val = i_hqm_cfg.ldb_qid_cfg[i].nalb_qid_depth_thresh;
              if(wr_val!=0) begin
                  write_reg($psprintf("cfg_nalb_qid_dpth_thrsh[%0d]",i), wr_val, "list_sel_pipe");
                  ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: lsp_regs.CFG_NALB_QID_DPTH_THRSH[%0d]=0x%0x", i, wr_val), OVM_LOW);    
              end
           end//for
	   
           if(hqm_lsp_qid_depth_thresh_qidmax==0)  qid_max_val = $urandom_range(hqm_lsp_qid_depth_thresh_qidmax, 31);
           else                                    qid_max_val = hqm_lsp_qid_depth_thresh_qidmax;	
	   	   
           for(int i=hqm_lsp_qid_depth_thresh_qidmin; i<qid_max_val; i++) begin	   
              i_hqm_cfg.dir_qid_cfg[i].dir_qid_depth_thresh = $urandom_range(64, 4096);	   
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: dir_qid_cfg[%0d].dir_qid_depth_thresh=%0d ", i, i_hqm_cfg.dir_qid_cfg[i].dir_qid_depth_thresh), OVM_LOW);
              wr_val=0;
              wr_val = i_hqm_cfg.dir_qid_cfg[i].dir_qid_depth_thresh;
              if(wr_val!=0) begin
                  write_reg($psprintf("cfg_dir_qid_dpth_thrsh[%0d]",i), wr_val, "list_sel_pipe");
                  ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_qidthreshold_task_rnd: lsp_regs.CFG_DIR_QID_DPTH_THRSH[%0d]=0x%0x", i, wr_val), OVM_LOW);    
              end
           end//for	   
        end		    
    end 
endtask: configure_lsp_qidthreshold_task

//-------------------------------------
//-------------------------------------
//-- LSP configure_lsp_totinflight_task
//-------------------------------------
//-------------------------------------
task configure_lsp_totinflight_task(int tot_inflight);
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];


      read_reg("CFG_CQ_LDB_TOT_INFLIGHT_LIMIT", rd_val , "list_sel_pipe");
      wr_val[11:0]=tot_inflight; //--2048 is the limit
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_totinflight_task: start default list_sel_pipe.CFG_CQ_LDB_TOT_INFLIGHT_LIMIT.rd=%0d, will set to tot_inflight", rd_val, tot_inflight), OVM_LOW);
      write_reg("CFG_CQ_LDB_TOT_INFLIGHT_LIMIT", wr_val, "list_sel_pipe");
      read_reg("CFG_CQ_LDB_TOT_INFLIGHT_LIMIT", rd_val , "list_sel_pipe");
      if(rd_val!=wr_val)
        ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_totinflight_task: done list_sel_pipe.CFG_CQ_LDB_TOT_INFLIGHT_LIMIT.rd=%0d wr=%0d", rd_val, wr_val), OVM_LOW);
      else
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_totinflight_task: done list_sel_pipe.CFG_CQ_LDB_TOT_INFLIGHT_LIMIT.rd=%0d wr=%0d", rd_val, wr_val), OVM_LOW);
endtask:configure_lsp_totinflight_task 

//-------------------------------------
//-------------------------------------
//-- LSP  configure_lsp_cos_task
//-------------------------------------
//-------------------------------------
task configure_lsp_cos_task(input bit [31:0] hqm_lsp_range_cos_0_val, bit [31:0] hqm_lsp_range_cos_1_val,bit [31:0] hqm_lsp_range_cos_2_val, bit [31:0] hqm_lsp_range_cos_3_val, bit [31:0] hqm_lsp_credit_sat_cos_0_val, bit [31:0] hqm_lsp_credit_sat_cos_1_val, bit [31:0] hqm_lsp_credit_sat_cos_2_val, bit [31:0] hqm_lsp_credit_sat_cos_3_val );
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
  
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4 setting_COS_0: hqm_lsp_range_cos_0_val=0x%0x hqm_lsp_credit_sat_cos_0_val=0x%0x ", hqm_lsp_range_cos_0_val,hqm_lsp_credit_sat_cos_0_val), OVM_LOW);
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4 setting_COS_1: hqm_lsp_range_cos_1_val=0x%0x hqm_lsp_credit_sat_cos_1_val=0x%0x ", hqm_lsp_range_cos_1_val,hqm_lsp_credit_sat_cos_1_val), OVM_LOW);
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4 setting_COS_2: hqm_lsp_range_cos_2_val=0x%0x hqm_lsp_credit_sat_cos_2_val=0x%0x ", hqm_lsp_range_cos_2_val,hqm_lsp_credit_sat_cos_2_val), OVM_LOW);
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4 setting_COS_3: hqm_lsp_range_cos_3_val=0x%0x hqm_lsp_credit_sat_cos_3_val=0x%0x ", hqm_lsp_range_cos_3_val,hqm_lsp_credit_sat_cos_3_val), OVM_LOW);
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_cos_task: start "), OVM_LOW);

        //== CFG_SHDW_RANGE_COS0
        if($test$plusargs("hqm_lsp_range_cos_0_val") || $test$plusargs("hqm_lspcos_cfg")) begin
            wr_val = hqm_lsp_range_cos_0_val;
            write_reg("CFG_SHDW_RANGE_COS0", wr_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS0=0x%0x", wr_val), OVM_LOW);    
            read_reg("CFG_SHDW_RANGE_COS0", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS0.rd_val=0x%0x (wr=0x%0x)", rd_val, wr_val), OVM_LOW);    
            if(rd_val != wr_val) 
               ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS0.rd_val=0x%0x (wr=0x%0x) don't match", rd_val, wr_val), OVM_LOW);    
        end else begin 
            read_reg("CFG_SHDW_RANGE_COS0", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS0.rd_val=0x%0x (default)", rd_val), OVM_LOW);    
        end
        
        //== CFG_CREDIT_SAT_COS0
        if($test$plusargs("hqm_lsp_credit_sat_cos_0_val") || $test$plusargs("hqm_lspcos_cfg")) begin
            wr_val = hqm_lsp_credit_sat_cos_0_val;
            write_reg("CFG_CREDIT_SAT_COS0", wr_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS0=0x%0x", wr_val), OVM_LOW);    
            read_reg("CFG_CREDIT_SAT_COS0", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS0.rd_val=0x%0x (wr=0x%0x)", rd_val, wr_val), OVM_LOW);    
            if(rd_val != wr_val) 
               ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS0.rd_val=0x%0x (wr=0x%0x) don't match", rd_val, wr_val), OVM_LOW); 
        end else begin 
            read_reg("CFG_CREDIT_SAT_COS0", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS0.rd_val=0x%0x (default)", rd_val), OVM_LOW);    
        end


        //== CFG_SHDW_RANGE_COS1
        if($test$plusargs("hqm_lsp_range_cos_1_val") || $test$plusargs("hqm_lspcos_cfg")) begin
            wr_val = hqm_lsp_range_cos_1_val;
            write_reg("CFG_SHDW_RANGE_COS1", wr_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS1=0x%0x", wr_val), OVM_LOW);    
            read_reg("CFG_SHDW_RANGE_COS1", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS1.rd_val=0x%0x (wr=0x%0x)", rd_val, wr_val), OVM_LOW);    
            if(rd_val != wr_val) 
               ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS1.rd_val=0x%0x (wr=0x%0x) don't match", rd_val, wr_val), OVM_LOW);    
        end else begin 
            read_reg("CFG_SHDW_RANGE_COS1", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS1.rd_val=0x%0x (default)", rd_val), OVM_LOW);    
        end
        
        //== CFG_CREDIT_SAT_COS1
        if($test$plusargs("hqm_lsp_credit_sat_cos_1_val") || $test$plusargs("hqm_lspcos_cfg")) begin
            wr_val = hqm_lsp_credit_sat_cos_1_val;
            write_reg("CFG_CREDIT_SAT_COS1", wr_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS1=0x%0x", wr_val), OVM_LOW);    
            read_reg("CFG_CREDIT_SAT_COS1", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS1.rd_val=0x%0x (wr=0x%0x)", rd_val, wr_val), OVM_LOW);    
            if(rd_val != wr_val) 
               ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS1.rd_val=0x%0x (wr=0x%0x) don't match", rd_val, wr_val), OVM_LOW);    
        end else begin 
            read_reg("CFG_CREDIT_SAT_COS1", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS1.rd_val=0x%0x (default)", rd_val), OVM_LOW);    
        end


        //== CFG_SHDW_RANGE_COS2
        if($test$plusargs("hqm_lsp_range_cos_2_val") || $test$plusargs("hqm_lspcos_cfg")) begin
            wr_val = hqm_lsp_range_cos_2_val;
            write_reg("CFG_SHDW_RANGE_COS2", wr_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS2=0x%0x", wr_val), OVM_LOW);    
            read_reg("CFG_SHDW_RANGE_COS2", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS2.rd_val=0x%0x (wr=0x%0x)", rd_val, wr_val), OVM_LOW);    
            if(rd_val != wr_val) 
               ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS2.rd_val=0x%0x (wr=0x%0x) don't match", rd_val, wr_val), OVM_LOW);    
        end else begin 
            read_reg("CFG_SHDW_RANGE_COS2", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS2.rd_val=0x%0x (default)", rd_val), OVM_LOW);    
        end
        
        //== CFG_CREDIT_SAT_COS2
        if($test$plusargs("hqm_lsp_credit_sat_cos_2_val") || $test$plusargs("hqm_lspcos_cfg")) begin
            wr_val = hqm_lsp_credit_sat_cos_2_val;
            write_reg("CFG_CREDIT_SAT_COS2", wr_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS2=0x%0x", wr_val), OVM_LOW);    
            read_reg("CFG_CREDIT_SAT_COS2", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS2.rd_val=0x%0x (wr=0x%0x)", rd_val, wr_val), OVM_LOW);    
            if(rd_val != wr_val) 
               ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS2.rd_val=0x%0x (wr=0x%0x) don't match", rd_val, wr_val), OVM_LOW);    
        end else begin 
            read_reg("CFG_CREDIT_SAT_COS2", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS2.rd_val=0x%0x (default)", rd_val), OVM_LOW);    
        end

        //== CFG_SHDW_RANGE_COS3
        if($test$plusargs("hqm_lsp_range_cos_3_val") || $test$plusargs("hqm_lspcos_cfg")) begin
            wr_val = hqm_lsp_range_cos_3_val;
            write_reg("CFG_SHDW_RANGE_COS3", wr_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS3=0x%0x", wr_val), OVM_LOW);    
            read_reg("CFG_SHDW_RANGE_COS3", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS3.rd_val=0x%0x (wr=0x%0x)", rd_val, wr_val), OVM_LOW);    
            if(rd_val != wr_val) 
               ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS3.rd_val=0x%0x (wr=0x%0x) don't match", rd_val, wr_val), OVM_LOW);    
        end else begin 
            read_reg("CFG_SHDW_RANGE_COS3", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_RANGE_COS3.rd_val=0x%0x (default)", rd_val), OVM_LOW);    
        end
        
        //== CFG_CREDIT_SAT_COS3
        if($test$plusargs("hqm_lsp_credit_sat_cos_3_val") || $test$plusargs("hqm_lspcos_cfg")) begin
            wr_val = hqm_lsp_credit_sat_cos_3_val;
            write_reg("CFG_CREDIT_SAT_COS3", wr_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS3=0x%0x", wr_val), OVM_LOW);    
            read_reg("CFG_CREDIT_SAT_COS3", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS3.rd_val=0x%0x (wr=0x%0x)", rd_val, wr_val), OVM_LOW);    
            if(rd_val != wr_val) 
               ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS3.rd_val=0x%0x (wr=0x%0x) don't match", rd_val, wr_val), OVM_LOW);    
        end else begin 
            read_reg("CFG_CREDIT_SAT_COS3", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_CREDIT_SAT_COS3.rd_val=0x%0x (default)", rd_val), OVM_LOW);    
        end

        if($test$plusargs("hqm_lsp_range_cos_0_val") || $test$plusargs("hqm_lsp_range_cos_1_val") || $test$plusargs("hqm_lsp_range_cos_2_val") || $test$plusargs("hqm_lsp_range_cos_3_val") || $test$plusargs("hqm_lspcos_cfg")) begin
            write_fields($psprintf("CFG_SHDW_CTRL"), '{"TRANSFER"}, '{'b1}, "list_sel_pipe");
            //list_sel_pipe_regs.CFG_SHDW_CTRL.write_fields(status, {"TRANSFER"},   {'b1}, primary_id, this); 
            read_reg("CFG_SHDW_CTRL", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_CFGLSP_SEQ0_COS: list_sel_pipe.CFG_SHDW_CTRL.rd_val=0x%0x", rd_val), OVM_LOW);    
        end

        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_lsp_cos_task: completed "), OVM_LOW);
endtask: configure_lsp_cos_task



//---------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
//--                 surv used in HQMV2 hqm_proc TB
//---------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------
//-- hqmproc_configure_surv_sel_task
//-- when hqmproc_surv_enable=1
//-------------------------------------
virtual task hqmproc_configure_surv_sel_task();
     sla_ral_data_t rd_val, wr_val;
     int sel_rnd;
     int hqmproc_surv_ctrl_sel;
     int hqmproc_surv_csw_ctrl_sel;
     int hqmproc_surv_pipeline_credit_sel;
     int hqmproc_surv_lsp_control_general0_sel;
     int hqmproc_surv_hqm_system_ctrl_sel;
     int hqmproc_surv_disable_wb;
     int hqmproc_surv_fifo_hwm_ctrl_sel;
     int lsp_pipeline_credit_sel;
     int hqmproc_surv_rop_sel;
     int hqmproc_surv_hid_sel;
     int hqmproc_surv_chp_sel;
     int hqmproc_surv_qed_sel;
     int hqmproc_cqirq_mask_enable, hqmproc_cqirq_unmask_enable;

     hqmproc_cqirq_unmask_enable=0;
     $value$plusargs("hqmproc_cqirq_unmask_enable=%d",hqmproc_cqirq_unmask_enable);
     hqmproc_cqirq_mask_enable=0;
     $value$plusargs("hqmproc_cqirq_mask_enable=%d",hqmproc_cqirq_mask_enable);

     hqmproc_surv_ctrl_sel = 0;
     $value$plusargs("hqmproc_surv_ctrl_sel=%d", hqmproc_surv_ctrl_sel);
     
     hqmproc_surv_csw_ctrl_sel = 0;
     $value$plusargs("hqmproc_surv_csw_ctrl_sel=%d", hqmproc_surv_csw_ctrl_sel);

     hqmproc_surv_pipeline_credit_sel = 0;
     $value$plusargs("hqmproc_surv_pipeline_credit_sel=%d", hqmproc_surv_pipeline_credit_sel);

     hqmproc_surv_lsp_control_general0_sel = 0;
     $value$plusargs("hqmproc_surv_lsp_control_general0_sel=%d", hqmproc_surv_lsp_control_general0_sel);

     hqmproc_surv_hqm_system_ctrl_sel = 0;
     $value$plusargs("hqmproc_surv_hqm_system_ctrl_sel=%d", hqmproc_surv_hqm_system_ctrl_sel);

     hqmproc_surv_fifo_hwm_ctrl_sel = 0;
     $value$plusargs("hqmproc_surv_fifo_hwm_ctrl_sel=%d", hqmproc_surv_fifo_hwm_ctrl_sel);

     hqmproc_surv_disable_wb = 0;
     $value$plusargs("hqmproc_surv_disable_wb=%d", hqmproc_surv_disable_wb);

     hqmproc_surv_rop_sel = 100;
     $value$plusargs("hqmproc_surv_rop_sel=%d", hqmproc_surv_rop_sel);

     hqmproc_surv_hid_sel = 100;
     $value$plusargs("hqmproc_surv_hid_sel=%d", hqmproc_surv_hid_sel);

     hqmproc_surv_chp_sel = 100;
     $value$plusargs("hqmproc_surv_chp_sel=%d", hqmproc_surv_chp_sel);


     if(hqmproc_surv_ctrl_sel==100) begin
        sel_rnd = $urandom_range(1,10);
     end else if(hqmproc_surv_ctrl_sel==101) begin
        sel_rnd = $urandom_range(1,9);
     end else begin
        sel_rnd = hqmproc_surv_ctrl_sel;
     end
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_configure_surv_sel_task: Start hqmproc_surv_ctrl_sel=%0d, sel_rnd=%0d; hqmproc_surv_csw_ctrl_sel=%0d  hqmproc_surv_pipeline_credit_sel=%0d hqmproc_surv_lsp_control_general0_sel=%0d hqmproc_surv_hqm_system_ctrl_sel=%0d hqmproc_surv_fifo_hwm_ctrl_sel=%0d hqmproc_surv_disable_wb=%0d hqmproc_surv_rop_sel=%0d hqmproc_surv_hid_sel=%0d; hqmproc_cqirq_mask_enable=%0d hqmproc_cqirq_unmask_enable=%0d", hqmproc_surv_ctrl_sel, sel_rnd, hqmproc_surv_csw_ctrl_sel, hqmproc_surv_pipeline_credit_sel, hqmproc_surv_lsp_control_general0_sel, hqmproc_surv_hqm_system_ctrl_sel, hqmproc_surv_fifo_hwm_ctrl_sel, hqmproc_surv_disable_wb, hqmproc_surv_rop_sel, hqmproc_surv_hid_sel, hqmproc_cqirq_mask_enable, hqmproc_cqirq_unmask_enable), OVM_LOW);

     hqmproc_surv_ctrl_sel = sel_rnd;

     if(sel_rnd==1) begin
         configure_surv_delayclkoff_task();
     end
     if(sel_rnd==2) begin
         configure_surv_csw_task(hqmproc_surv_csw_ctrl_sel);
     end
     if(sel_rnd==3) begin
         configure_surv_pipeline_credit_task(hqmproc_surv_pipeline_credit_sel);
     end
     if(sel_rnd==4) begin
         configure_surv_lsp_control_general0_task(hqmproc_surv_lsp_control_general0_sel);
     end
     if(sel_rnd==5) begin
         configure_surv_hqm_system_ctrl(hqmproc_surv_hqm_system_ctrl_sel);
     end
     //if(sel_rnd==6) beginhqmproc_surv_fifo_hwm_ctrl_sel
     //    configure_surv_lsp_disable_wb(hqmproc_surv_disable_wb);
     //end
     if(sel_rnd==6) begin
         configure_surv_fifo_hwm_task(hqmproc_surv_fifo_hwm_ctrl_sel);
     end

     if(sel_rnd==7) begin
         if(hqmproc_surv_chp_sel==100) hqmproc_surv_chp_sel = $urandom_range(0,3); //(0,10);
         if(hqmproc_cqirq_mask_enable || hqmproc_cqirq_unmask_enable) hqmproc_surv_chp_sel = $urandom_range(0,1);
         configure_surv_chp_task(hqmproc_surv_chp_sel); 
     end

     if(sel_rnd==8) begin
         hqmproc_surv_qed_sel = $urandom_range(0,1);
         configure_surv_qed_task(hqmproc_surv_qed_sel); 
     end

     if(sel_rnd==9) begin
         if(hqmproc_surv_hid_sel==100) hqmproc_surv_hid_sel = $urandom_range(1,7);
         configure_surv_aqed_task(hqmproc_surv_hid_sel); 
     end

     if(sel_rnd==10) begin
         if(hqmproc_surv_rop_sel==100) hqmproc_surv_rop_sel = $urandom_range(0,17);
         configure_surv_rop_task(hqmproc_surv_rop_sel); 
     end

    
     //-- combo not work
     if(sel_rnd==11) begin
         configure_surv_lsp_control_general0_task(0);
         configure_surv_pipeline_credit_task(19); //8); //--LSP.CFG_CONTROL_PIPELINE_CREDITS   "ATM_PIPE_CREDITS" "NALB_PIPE_CREDITS"  
         configure_surv_lsp_disable_wb(1); 
     end
     if(sel_rnd==12) begin
         configure_surv_csw_task(0);
         configure_surv_lsp_control_general0_task(0);
         configure_surv_pipeline_credit_task(19); //8); //--LSP.CFG_CONTROL_PIPELINE_CREDITS   "ATM_PIPE_CREDITS" "NALB_PIPE_CREDITS"  
         configure_surv_lsp_disable_wb(1); 
     end

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_configure_surv_sel_task: Done hqmproc_surv_ctrl_sel=%0d, sel_rnd=%0d; hqmproc_surv_csw_ctrl_sel=%0d  hqmproc_surv_pipeline_credit_sel=%0d hqmproc_surv_lsp_control_general0_sel=%0d hqmproc_surv_hqm_system_ctrl_sel=%0d hqmproc_surv_disable_wb=%0d", hqmproc_surv_ctrl_sel, sel_rnd, hqmproc_surv_csw_ctrl_sel, hqmproc_surv_pipeline_credit_sel, hqmproc_surv_lsp_control_general0_sel, hqmproc_surv_hqm_system_ctrl_sel, hqmproc_surv_disable_wb), OVM_LOW);
endtask: hqmproc_configure_surv_sel_task


//-------------------------------------
//-- Init_Cfg_Surv:  configure_surv_delayclkoff_task
//-- when has_surv_delayclkoff_enable=1
//-------------------------------------
virtual task configure_surv_delayclkoff_task();
     sla_ral_data_t rd_val, wr_val;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task: Start "), OVM_LOW);

     write_fields($psprintf("CFG_PATCH_CONTROL"), '{"DELAY_CLOCKOFF"}, '{'b0}, "aqed_pipe");
     read_reg("CFG_PATCH_CONTROL", rd_val, "aqed_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task:aqed_pipe.CFG_PATCH_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 

     write_fields($psprintf("CFG_PATCH_CONTROL"), '{"DELAY_CLOCKOFF"}, '{'b0}, "credit_hist_pipe");
     read_reg("CFG_PATCH_CONTROL", rd_val, "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task:credit_hist_pipe.CFG_PATCH_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 

     write_fields($psprintf("CFG_PATCH_CONTROL"), '{"DELAY_CLOCKOFF"}, '{'b0}, "direct_pipe");
     read_reg("CFG_PATCH_CONTROL", rd_val, "direct_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task:direct_pipe.CFG_PATCH_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 

     write_fields($psprintf("CFG_PATCH_CONTROL"), '{"DELAY_CLOCKOFF"}, '{'b0}, "atm_pipe");
     read_reg("CFG_PATCH_CONTROL", rd_val, "atm_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task:atm_pipe.CFG_PATCH_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 

     write_fields($psprintf("CFG_PATCH_CONTROL"), '{"DELAY_CLOCKOFF"}, '{'b0}, "nalb_pipe");
     read_reg("CFG_PATCH_CONTROL", rd_val, "nalb_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task:nalb_pipe.CFG_PATCH_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 

     write_fields($psprintf("CFG_PATCH_CONTROL"), '{"DELAY_CLOCKOFF"}, '{'b0}, "qed_pipe");
     read_reg("CFG_PATCH_CONTROL", rd_val, "qed_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task:qed_pipe.CFG_PATCH_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 

     write_fields($psprintf("CFG_PATCH_CONTROL"), '{"DELAY_CLOCKOFF"}, '{'b0}, "reorder_pipe");
     read_reg("CFG_PATCH_CONTROL", rd_val, "reorder_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task:reorder_pipe.CFG_PATCH_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 

     write_fields($psprintf("CFG_PATCH_CONTROL"), '{"DELAY_CLOCKOFF"}, '{'b0}, "list_sel_pipe");
     read_reg("CFG_PATCH_CONTROL", rd_val, "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task:list_sel_pipe.CFG_PATCH_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 

     write_fields($psprintf("CFG_PATCH_CONTROL"), '{"DELAY_CLOCKOFF"}, '{'b0}, "hqm_system_csr");
     read_reg("CFG_PATCH_CONTROL", rd_val, "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task:hqm_system_csr.CFG_PATCH_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 

     write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CFG_IDLE_DLY"}, '{'b1}, "config_master");
     read_reg("CFG_CONTROL_GENERAL", rd_val, "config_master");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task:config_master.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 


     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_delayclkoff_task: Done "), OVM_LOW);
endtask: configure_surv_delayclkoff_task

//-------------------------------------
//-- configure_surv_csw_task
//-- when has_surv_csw_enable=1
//-- csw_ctrl_sel [1:5], 0: for all
//--
//--
//-- aqed_pipe
//-- credit_hist_pipe
//-- direct_pipe
//-- atm_pipe
//-- nalb_pipe
//-- qed_pipe
//-- reorder_pipe
//-- list_sel_pipe
//-- hqm_system_csr
//-- config_master
//-------------------------------------
virtual task configure_surv_csw_task(int csw_ctrl_sel);
     sla_ral_data_t rd_val, wr_val;
     int rnd_sel;
    
     if(csw_ctrl_sel==100) rnd_sel=$urandom_range(0,24);
     else                  rnd_sel=csw_ctrl_sel;
     csw_ctrl_sel=rnd_sel;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: Start csw_ctrl_sel=%0d", csw_ctrl_sel), OVM_LOW);

     if(csw_ctrl_sel==0 || csw_ctrl_sel==1) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_SIM"}, '{'b1}, "aqed_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "aqed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: aqed_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(csw_ctrl_sel==0 || csw_ctrl_sel==2) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_SIM"}, '{'b1}, "atm_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "atm_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: atm_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(csw_ctrl_sel==0 || csw_ctrl_sel==3) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_SIM"}, '{'b1}, "direct_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "direct_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: direct_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(csw_ctrl_sel==0 || csw_ctrl_sel==4) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_SIM"}, '{'b1}, "qed_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "qed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: qed_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(csw_ctrl_sel==0 || csw_ctrl_sel==5) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_SIM"}, '{'b1}, "nalb_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "nalb_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: nalb_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end 
    
     if(csw_ctrl_sel==0 || csw_ctrl_sel==6) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_STRICT"}, '{'b1}, "qed_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val , "qed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: qed_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     //--aqed_pipe.cfg_control_general other controls
     if(csw_ctrl_sel==7) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_50"}, '{'b1}, "aqed_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "aqed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: aqed_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     if(csw_ctrl_sel==8) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"FID_DECREMENT"}, '{'b1}, "aqed_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "aqed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: aqed_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     if(csw_ctrl_sel==9) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"FID_SIM"}, '{'b1}, "aqed_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "aqed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: aqed_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     if(csw_ctrl_sel==10) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"AQED_CHICKEN_ONEPRI"}, '{'b1}, "aqed_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "aqed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: aqed_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     if(csw_ctrl_sel==11) begin
        wr_val[13:0]=$urandom_range(14'h17ef,14'h100);
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"AQED_LSP_STOP_ATQATM"}, '{wr_val[13:0]}, "aqed_pipe");//AQED_LSP_STOP_ATQATM [21:8] = 14'h17ef; "Aqed Lsp Stop Atqatm"; desc = " throttle lsp atq->Atm transfer when total fid_cnt is above threhold";
        read_reg("CFG_CONTROL_GENERAL", rd_val, "aqed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: aqed_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     //--atm_pipe.cfg_control_general other controls
     if(csw_ctrl_sel==12) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_50"}, '{'b1}, "atm_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "atm_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: atm_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     if(csw_ctrl_sel==13) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_33"}, '{'b1}, "atm_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "atm_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: atm_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     if(csw_ctrl_sel==14) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_25"}, '{'b1}, "atm_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "atm_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: atm_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     if(csw_ctrl_sel==15) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_DIS_ENQSTALL"}, '{'b1}, "atm_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "atm_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: atm_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     if(csw_ctrl_sel==16) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_DIS_ENQ_AFULL_HP_MODE"}, '{'b1}, "atm_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "atm_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: atm_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     if(csw_ctrl_sel==17) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_EN_ALWAYSBLAST"}, '{'b1}, "atm_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "atm_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: atm_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     if(csw_ctrl_sel==18) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_EN_ENQBLOCKRLST"}, '{'b1}, "atm_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "atm_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: atm_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     if(csw_ctrl_sel==19) begin
        wr_val[2:0]=$urandom_range(1,7);
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_MAX_ENQSTALL"}, '{wr_val[2:0]}, "atm_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "atm_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: atm_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end


     //--dp 
     if(csw_ctrl_sel==20) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_50"}, '{'b1}, "direct_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "direct_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: direct_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     //--nalb
     if(csw_ctrl_sel==21) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_50"}, '{'b1}, "nalb_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val, "nalb_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: nalb_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 

     end

     //--lsp
     if(csw_ctrl_sel==22) begin
        wr_val[4:0]=$urandom_range(1,12); //--"AQED Dequeue Hight Priority Watermark.  When the depth of the AQED dequeue FIFO reaches this limit, dequeues are given strict priority over CQ completions.  Must not be set larger than 12"
        write_fields($psprintf("CFG_CONTROL_GENERAL_1"), '{"AQED_DEQ_HIPRI_WM"}, '{wr_val[4:0]}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: list_sel_pipe.CFG_CONTROL_GENERAL_1.rd=0x%0x", rd_val), OVM_LOW); 
 
     end

     if(csw_ctrl_sel==23) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_1"), '{"DIS_WU_RES_CHK"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: list_sel_pipe.CFG_CONTROL_GENERAL_1.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(csw_ctrl_sel==24) begin
        wr_val[4:0]=$urandom_range(1,12); //--"QED Dequeue Hight Priority Watermark.  When the depth of the QED dequeue FIFO reaches this limit, dequeues are given strict priority over CQ completions.  Must not be set larger than 12";
        write_fields($psprintf("CFG_CONTROL_GENERAL_1"), '{"QED_DEQ_HIPRI_WM"}, '{wr_val[4:0]}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: list_sel_pipe.CFG_CONTROL_GENERAL_1.rd=0x%0x", rd_val), OVM_LOW); 
     end


     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_csw_task: Done "), OVM_LOW);
endtask: configure_surv_csw_task

//-------------------------------------
//-- configure_surv_pipeline_credit_task
//-- when has_surv_pipeline_credit_enable=1
//-- pipeline_credit_sel [1:5], 0: for all
//--
//--
//-- aqed_pipe
//-- credit_hist_pipe
//-- direct_pipe
//-- atm_pipe
//-- nalb_pipe
//-- qed_pipe
//-- reorder_pipe
//-- list_sel_pipe
//-- hqm_system_csr
//-- config_master
//-------------------------------------
virtual task configure_surv_pipeline_credit_task(int pipeline_credit_sel);
     sla_ral_data_t rd_val, wr_val;
     int rnd_sel;
    
     if(pipeline_credit_sel==100) rnd_sel=$urandom_range(1,21);
     else                         rnd_sel=pipeline_credit_sel;
     pipeline_credit_sel=rnd_sel;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: Start pipeline_credit_sel=%0d", pipeline_credit_sel), OVM_LOW);
     read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "aqed_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: aqed_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd.init=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "atm_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: atm_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd.init=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "direct_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: direct_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd.init=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "qed_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: qed_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd.init=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "nalb_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: nalb_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd.init=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: list_sel_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd.init=0x%0x", rd_val), OVM_LOW); 


     //-------------
     if(pipeline_credit_sel==0 || pipeline_credit_sel==1) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"AQED_AP_ENQ"}, '{'b1}, "aqed_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "aqed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: aqed_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 
     if(pipeline_credit_sel==0 || pipeline_credit_sel==2) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"AQED_CHP_SCH"}, '{'b1}, "aqed_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "aqed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: aqed_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 
     if(pipeline_credit_sel==0 || pipeline_credit_sel==3) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"FID_PUSH"}, '{'b1}, "aqed_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "aqed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: aqed_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 
     if(pipeline_credit_sel==0 || pipeline_credit_sel==4) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"FID_ENQ"}, '{'b1}, "aqed_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "aqed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: aqed_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end


     //-------------
     if(pipeline_credit_sel==0 || pipeline_credit_sel==5) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"AP_LSP_ENQ"}, '{'b1}, "atm_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "atm_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: atm_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 


     //-------------
     if(pipeline_credit_sel==0 || pipeline_credit_sel==6) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"DP_LSP_ENQ_DIR"}, '{'b1}, "direct_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "direct_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: direct_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(pipeline_credit_sel==0 || pipeline_credit_sel==7) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"DP_DQED_DIR"}, '{'b1}, "direct_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "direct_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: direct_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 
     if(pipeline_credit_sel==0 || pipeline_credit_sel==8) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"DP_LSP_ENQ_DIR_RORPLY"}, '{'b1}, "direct_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "direct_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: direct_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 
     if(pipeline_credit_sel==0 || pipeline_credit_sel==9) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"DP_DQED_RORPLY"}, '{'b1}, "direct_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "direct_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: direct_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 


     //-------------
     if(pipeline_credit_sel==0 || pipeline_credit_sel==10) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"DCREDITS"}, '{'b1}, "qed_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "qed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: qed_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(pipeline_credit_sel==0 || pipeline_credit_sel==11) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"LCREDITS"}, '{'b1}, "qed_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "qed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: qed_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     //-------------
     if(pipeline_credit_sel==0 || pipeline_credit_sel==12) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"NALB_LSP_ENQ_LB"}, '{'b1}, "nalb_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "nalb_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: nalb_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 
    
     if(pipeline_credit_sel==0 || pipeline_credit_sel==13) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"NALB_QED_LB"}, '{'b1}, "nalb_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "nalb_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: nalb_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 
     if(pipeline_credit_sel==0 || pipeline_credit_sel==14) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"NALB_LSP_ENQ_LB_RORPLY"}, '{'b1}, "nalb_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "nalb_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: nalb_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 
     if(pipeline_credit_sel==0 || pipeline_credit_sel==15) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"NALB_QED_RORPLY"}, '{'b1}, "nalb_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "nalb_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: nalb_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 
     if(pipeline_credit_sel==0 || pipeline_credit_sel==16) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"NALB_LSP_ENQ_LB_ATQ"}, '{'b1}, "nalb_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "nalb_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: nalb_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 
     if(pipeline_credit_sel==0 || pipeline_credit_sel==17) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"NALB_QED_ATQ"}, '{'b1}, "nalb_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "nalb_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: nalb_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     //-------------
     if(pipeline_credit_sel==0 || pipeline_credit_sel==18) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"ATM_PIPE_CREDITS"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: list_sel_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(pipeline_credit_sel==0 || pipeline_credit_sel==19) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"NALB_PIPE_CREDITS"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: list_sel_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(pipeline_credit_sel==20) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"AQED_DEQ_PIPE_CREDITS"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: list_sel_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(pipeline_credit_sel==21) begin
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"ATM_PIPE_CREDITS"}, '{'b1}, "list_sel_pipe");
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"NALB_PIPE_CREDITS"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: list_sel_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 


     if(pipeline_credit_sel==22) begin
        //-- this setting of QED_DEQ_PIPE_CREDITS=1 , not work with hqmproc int flow
        write_fields($psprintf("CFG_CONTROL_PIPELINE_CREDITS"), '{"QED_DEQ_PIPE_CREDITS"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: list_sel_pipe.CFG_CONTROL_PIPELINE_CREDITS.rd=0x%0x", rd_val), OVM_LOW); 
     end 


     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_pipeline_credit_task: Done "), OVM_LOW);
endtask: configure_surv_pipeline_credit_task

//-------------------------------------
//-- configure_surv_lsp_disable_wb
//-- when has_surv_lsp_disable_wb=1
//-- 
//--
//-- list_sel_pipe
//-------------------------------------
virtual task configure_surv_lsp_disable_wb(bit disable_wb);
     sla_ral_data_t rd_val, wr_val;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_disable_wb: Start disable=%0d", disable_wb), OVM_LOW);
     for(int i=0; i<4; i++) begin 
       if(disable_wb)
          write_fields($psprintf("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[%0d]",i), '{"DISABLE_WB_OPT"}, '{'b1}, "list_sel_pipe");
       else
          write_fields($psprintf("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[%0d]",i), '{"DISABLE_WB_OPT"}, '{'b0}, "list_sel_pipe");

        read_reg($psprintf("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[%0d]",i), rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_disable_wb: list_sel_pipe.CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[%0d].rd=0x%0x", i, rd_val), OVM_LOW); 
     end
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_disable_wb: Done disable=%0d", disable_wb), OVM_LOW);

endtask: configure_surv_lsp_disable_wb 







//-------------------------------------
//-- configure_surv_lsp_control_general0_task
//-- when has_surv_lsp_control_general0_enable=1
//-- pipeline_credit_sel [1:24], 0: for all
//-- 23:
//-- 24:
//-- list_sel_pipe
//-- 30: config  ENAB_IF_THRESH[4:4]
//-------------------------------------
virtual task configure_surv_lsp_control_general0_task(int lsp_control_general0_sel);
     sla_ral_data_t rd_val, wr_val;
     int rnd_sel;
     bit [1:0] rnd_qe_weight;
    
     rnd_qe_weight=$urandom_range(0,3); 
     if(lsp_control_general0_sel==100) rnd_sel=$urandom_range(0,26);
     else                              rnd_sel=lsp_control_general0_sel;
     lsp_control_general0_sel=rnd_sel;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: Start lsp_control_general0_sel=%0d", lsp_control_general0_sel), OVM_LOW);

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==1) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"LDB_CE_TOG_ARB"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==2) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"ATM_SINGLE_CMP"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==3) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"ATM_SINGLE_SCH"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task:list_sel_pipe .CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==4) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"LDB_DISAB_MULTI"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==5) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"LDB_HALF_BW"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==6) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"LDB_SINGLE_OP"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==7) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"LBRPL_SINGLE_OUT"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==8) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"LBRPL_HALF_BW"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==9) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"LBRPL_SINGLE_OP"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==10) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DIRRPL_SINGLE_OUT"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==11) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DIRRPL_HALF_BW"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==12) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DIRRPL_SINGLE_OP"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==13) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"ATQ_DISAB_MULTI"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==14) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"ATQ_SINGLE_OUT"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==15) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"ATQ_HALF_BW"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==16) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"ATQ_SINGLE_OP"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==17) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DIR_DISAB_MULTI"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==18) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DIR_SINGLE_OUT"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==19) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DIR_HALF_BW"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==20) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DIR_SINGLE_OP"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==21) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DISAB_RLIST_PRI"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==0 || lsp_control_general0_sel==22) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DISAB_ATQ_EMPTY_ARB"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 


     if(lsp_control_general0_sel==23) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"LBRPL_SINGLE_OUT"}, '{'b1}, "list_sel_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"LBRPL_SINGLE_OP"}, '{'b1}, "list_sel_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DIRRPL_SINGLE_OUT"}, '{'b1}, "list_sel_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DIRRPL_SINGLE_OP"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==24) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"LBRPL_SINGLE_OP"}, '{'b1}, "list_sel_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"DIRRPL_SINGLE_OP"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end 


     if(lsp_control_general0_sel==25) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_1"), '{"QE_WT_BLK"}, '{'b1}, "list_sel_pipe");
        i_hqm_cfg.hqmproc_lspblockwu = 1;
        read_reg("CFG_CONTROL_GENERAL_1", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_1.rd.QE_WT_BLK.3=0x%0x, i_hqm_cfg.hqmproc_lspblockwu=%0d", rd_val, i_hqm_cfg.hqmproc_lspblockwu), OVM_LOW); 
     end 

     if(lsp_control_general0_sel==26) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_1"), '{"QE_WT_FRC"}, '{rnd_qe_weight}, "list_sel_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_1"), '{"QE_WT_FRCV"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_1", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_1.rd.QE_WT_FRCV.2:0=0x%0x, rnd_qe_weight=%0d", rd_val, rnd_qe_weight), OVM_LOW); 
     end 

     //-- support ldb_inflight_threshold 
     if(lsp_control_general0_sel==30) begin
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x bit4", rd_val), OVM_LOW); 
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"ENAB_IF_THRESH"}, '{'b1}, "list_sel_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val, "list_sel_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: list_sel_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x bit4", rd_val), OVM_LOW); 
     end 

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_lsp_control_general0_task: Done "), OVM_LOW);
endtask: configure_surv_lsp_control_general0_task


//-------------------------------------
//-- configure_surv_hqm_system_ctrl
//-- when has_surv_hqm_system_ctrl_enable=1
//-- 
//--
//-- hqm_system_csr
//-------------------------------------
virtual task configure_surv_hqm_system_ctrl(int hqm_system_ctrl_sel);
  sla_ral_data_t rd_val, wr_val;
  int fifo_sel;

  bit [6:0]  hqm_system_egress_schratelimit;
  bit        hqm_system_egress_schwb;  
  bit        hqm_system_egress_w1beat;  
  bit [9:0]  hqm_system_ingress_enqratelimit;
  bit        hqm_system_ingress_enqzeroclstart;
  bit [8:0]  hqm_system_enq_fifo_wm; //--9'd254 default
  bit [7:0]  hqm_system_sch_out_fifo_wm; //--8'd127 default
  int        fifo_hwm_val;

  int rnd_sel;
    
     if(hqm_system_ctrl_sel==100) rnd_sel=$urandom_range(0,7);
     else                         rnd_sel=hqm_system_ctrl_sel;
     hqm_system_ctrl_sel=rnd_sel;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: Start hqm_system_ctrl_sel=%0d", hqm_system_ctrl_sel), OVM_LOW);

     if(hqm_system_ctrl_sel==1) begin
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.INGRESS_CTL.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("INGRESS_CTL"), '{"ENQ_RATE_LIMIT"}, '{'h3ff}, "hqm_system_csr");
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.INGRESS_CTL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(hqm_system_ctrl_sel==2) begin
        read_reg("EGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.EGRESS_CTL.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("EGRESS_CTL"), '{"SCH_RATE_LIMIT"}, '{'h7f}, "hqm_system_csr");
        read_reg("EGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.EGRESS_CTL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(hqm_system_ctrl_sel==3) begin
        read_reg("WRITE_BUFFER_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.WRITE_BUFFER_CTL.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("WRITE_BUFFER_CTL"), '{"SCH_RATE_LIMIT"}, '{'b1}, "hqm_system_csr");
        read_reg("WRITE_BUFFER_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.WRITE_BUFFER_CTL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(hqm_system_ctrl_sel==4) begin
        read_reg("WRITE_BUFFER_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.WRITE_BUFFER_CTL.rd=0x%0x", rd_val), OVM_LOW); 
        write_fields($psprintf("WRITE_BUFFER_CTL"), '{"WRITE_SINGLE_BEATS"}, '{'b1}, "hqm_system_csr");
        read_reg("WRITE_BUFFER_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.WRITE_BUFFER_CTL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(hqm_system_ctrl_sel==5) begin
        read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.INGRESS_CTL.rd=0x%0x", rd_val), OVM_LOW); 
        //-- HQMV30 removed ZERO_CL_START   write_fields($psprintf("INGRESS_CTL"), '{"ZERO_CL_START"}, '{'b1}, "hqm_system_csr");
        //-- HQMV30 removed ZERO_CL_START   read_reg("INGRESS_CTL", rd_val, "hqm_system_csr");
        //-- HQMV30 removed ZERO_CL_START   ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.INGRESS_CTL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(hqm_system_ctrl_sel==6) begin
        read_reg("HCW_ENQ_FIFO_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.HCW_ENQ_FIFO_CTL.init.rd=0x%0x", rd_val), OVM_LOW); 
        hqm_system_enq_fifo_wm = $urandom_range(1,255); //init 254
        write_fields($psprintf("HCW_ENQ_FIFO_CTL"), '{"HIGH_WM"}, '{hqm_system_enq_fifo_wm}, "hqm_system_csr");
        read_reg("HCW_ENQ_FIFO_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.HCW_ENQ_FIFO_CTL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(hqm_system_ctrl_sel==7) begin
        read_reg("SCH_OUT_FIFO_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.SCH_OUT_FIFO_CTL.init.rd=0x%0x", rd_val), OVM_LOW); 
        hqm_system_sch_out_fifo_wm = $urandom_range(1,128); // init 127
        write_fields($psprintf("SCH_OUT_FIFO_CTL"), '{"HIGH_WM"}, '{hqm_system_sch_out_fifo_wm}, "hqm_system_csr");
        read_reg("SCH_OUT_FIFO_CTL", rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: hqm_system_csr.SCH_OUT_FIFO_CTL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_hqm_system_ctrl: Done hqm_system_ctrl_sel=%0d", hqm_system_ctrl_sel), OVM_LOW);

endtask: configure_surv_hqm_system_ctrl 



//-------------------------------------
//-- configure_surv_fifo_hwm_task
//-- when has_surv_fifo_hwm_ctrl_enable=1
//--  
//-- fifo_hwm_ctrl_sel [1:5]; 0 for all
//-- 
//-------------------------------------
virtual task configure_surv_fifo_hwm_task(int fifo_hwm_ctrl_sel);
  sla_ral_data_t rd_val, wr_val;
  int fifo_sel;
  int        fifo_hwm_val;
  int rnd_sel;
    
     if(fifo_hwm_ctrl_sel==100)   rnd_sel=$urandom_range(0,5);
     else                         rnd_sel=fifo_hwm_ctrl_sel;
     fifo_hwm_ctrl_sel=rnd_sel;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: Start fifo_hwm_ctrl_sel=%0d", fifo_hwm_ctrl_sel), OVM_LOW);

     if(fifo_hwm_ctrl_sel==0 || fifo_hwm_ctrl_sel==1) begin


        //---------------------------- 	   
        //-- FIFOs in direct_pipe
        //---------------------------- 	   
        fifo_sel = $urandom_range(1,7); 	  
        
        if(fifo_sel==1) begin 
           read_reg("CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
           //CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF.FIFO_HWM->reset = 8'h0d ;
           fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "direct_pipe");
           read_reg("CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   

        if(fifo_sel==2) begin 
           read_reg("CFG_FIFO_WMSTAT_DP_DQED_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_DP_DQED_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
	  //CFG_FIFO_WMSTAT_DP_DQED_IF.FIFO_HWM->reset = 8'h1d ;
           fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_DP_DQED_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "direct_pipe");
           read_reg("CFG_FIFO_WMSTAT_DP_DQED_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_DP_DQED_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   

        if(fifo_sel==3) begin 
           read_reg("CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF.FIFO_HWM->reset = 8'h0d ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "direct_pipe");
           read_reg("CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   

        if(fifo_sel==4) begin 
           read_reg("CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]); //init: 4, depth=4
           write_fields($psprintf("CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "direct_pipe");
           read_reg("CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 

        if(fifo_sel==5) begin 
           read_reg("CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]); //init: 4 depth=4
           write_fields($psprintf("CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "direct_pipe");
           read_reg("CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 

        if(fifo_sel==6) begin 
           read_reg("CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]); //init: 4 depth=4
           write_fields($psprintf("CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "direct_pipe");
           read_reg("CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 

        if(fifo_sel==7) begin 
           read_reg("CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]); //init: 4 depth=4
           write_fields($psprintf("CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "direct_pipe");
           read_reg("CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF", rd_val, "direct_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: direct_pipe.CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 

     end //--if(fifo_hwm_ctrl_sel==1 direct_pipe


     if(fifo_hwm_ctrl_sel==0 || fifo_hwm_ctrl_sel==2) begin
        //---------------------------- 	   
        //-- FIFOs in nalb_pipe
        //---------------------------- 	   
        fifo_sel = $urandom_range(1,8); 	  
        
        if(fifo_sel==1) begin 
           read_reg("CFG_FIFO_WMSTAT_NALB_QED_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_NALB_QED_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_NALB_QED_IF.FIFO_HWM->reset = 8'h1d ;
          fifo_hwm_val = rd_val[7:0]; // 
           write_fields($psprintf("CFG_FIFO_WMSTAT_NALB_QED_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "nalb_pipe");
           read_reg("CFG_FIFO_WMSTAT_NALB_QED_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_NALB_QED_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   

        if(fifo_sel==2) begin 
           read_reg("CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF.FIFO_HWM->reset = 8'h1d ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "nalb_pipe");
           read_reg("CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  

        if(fifo_sel==3) begin 
           read_reg("CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF.FIFO_HWM->reset = 8'h1d ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "nalb_pipe");
           read_reg("CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  

        if(fifo_sel==4) begin 
           read_reg("CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF.FIFO_HWM->reset = 8'h1d ;
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]);//(1,29); //depth=32
           write_fields($psprintf("CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "nalb_pipe");
           read_reg("CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  

        if(fifo_sel==5) begin 
           read_reg("CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]);//(1,4); //depth=
           write_fields($psprintf("CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "nalb_pipe");
           read_reg("CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  

        if(fifo_sel==6) begin 
           read_reg("CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]);//(1,4);
           write_fields($psprintf("CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "nalb_pipe");
           read_reg("CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  

        if(fifo_sel==7) begin 
           read_reg("CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]);//(1,4);
           write_fields($psprintf("CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "nalb_pipe");
           read_reg("CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  

        if(fifo_sel==8) begin 
           read_reg("CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]);//(1,4);
           write_fields($psprintf("CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "nalb_pipe");
           read_reg("CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF", rd_val, "nalb_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: nalb_pipe.CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  
     end //-- if(fifo_hwm_ctrl_sel==2) 


     if(fifo_hwm_ctrl_sel==0 || fifo_hwm_ctrl_sel==3) begin
        //---------------------------- 	   
        //-- FIFOs in aqed_pipe 
        //---------------------------- 	   
        fifo_sel = $urandom_range(1,7); 	  
        
        if(fifo_sel==1) begin 
           read_reg("CFG_FIFO_WMSTAT_FREELIST_RETURN", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_FREELIST_RETURN.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_FREELIST_RETURN.FIFO_HWM->reset = 8'h10 ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_FREELIST_RETURN"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "aqed_pipe");
           read_reg("CFG_FIFO_WMSTAT_FREELIST_RETURN", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_FREELIST_RETURN.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   

        if(fifo_sel==2) begin 
           read_reg("CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF.FIFO_HWM->reset = 8'h10 ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "aqed_pipe");
           read_reg("CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 

        if(fifo_sel==3) begin 
           read_reg("CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF.FIFO_HWM->reset = 8'h10 ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "aqed_pipe");
           read_reg("CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 

        if(fifo_sel==4) begin 
           read_reg("CFG_FIFO_WMSTAT_AP_AQED_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_AP_AQED_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_AP_AQED_IF.FIFO_HWM->reset = 8'h10 ;
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]);//(1,16);;
           write_fields($psprintf("CFG_FIFO_WMSTAT_AP_AQED_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "aqed_pipe");
           read_reg("CFG_FIFO_WMSTAT_AP_AQED_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_AP_AQED_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 

        if(fifo_sel==5) begin 
           read_reg("CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]);//(1,16);
           write_fields($psprintf("CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "aqed_pipe");
           read_reg("CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 

        if(fifo_sel==6) begin 
           read_reg("CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]);//(1,8);
           write_fields($psprintf("CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "aqed_pipe");
           read_reg("CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 

        if(fifo_sel==7) begin 
           read_reg("CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]);//(1,4);
           write_fields($psprintf("CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "aqed_pipe");
           read_reg("CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF", rd_val, "aqed_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: aqed_pipe.CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 
     end //-- if(fifo_hwm_ctrl_sel==3) 


     if(fifo_hwm_ctrl_sel==0 || fifo_hwm_ctrl_sel==4) begin
        //---------------------------- 	   
        //-- FIFOs in atm_pipe 
        //---------------------------- 	   
        fifo_sel = $urandom_range(1,2); 	  
        
        if(fifo_sel==1) begin 
           read_reg("CFG_FIFO_WMSTAT_AP_AQED_IF", rd_val, "atm_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: atm_pipe.CFG_FIFO_WMSTAT_AP_AQED_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_AP_AQED_IF.FIFO_HWM->reset = 8'h10 ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_AP_AQED_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "atm_pipe");
           read_reg("CFG_FIFO_WMSTAT_AP_AQED_IF", rd_val, "atm_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: atm_pipe.CFG_FIFO_WMSTAT_AP_AQED_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   

        if(fifo_sel==2) begin 
           read_reg("CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF", rd_val, "atm_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: atm_pipe.CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF.FIFO_HWM->reset = 8'h0f ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "atm_pipe");
           read_reg("CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF", rd_val, "atm_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: atm_pipe.CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 

        if(fifo_sel==3) begin 
           read_reg("CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF", rd_val, "atm_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: atm_pipe.CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]);//(1,24);
           write_fields($psprintf("CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "atm_pipe");
           read_reg("CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF", rd_val, "atm_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: atm_pipe.CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF.rd=0x%0x", rd_val), OVM_LOW); 
        end //-- 

     end //-- if(fifo_hwm_ctrl_sel==4) 


     if(fifo_hwm_ctrl_sel==0 || fifo_hwm_ctrl_sel==4) begin
        //---------------------------- 	   
        //-- FIFOs in reorder_pipe 
        //---------------------------- 	   
        fifo_sel = $urandom_range(1,6); 	  
        
        if(fifo_sel==1) begin 
           read_reg("CFG_FIFO_WMSTAT_CHP_ROP_HCW", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_CHP_ROP_HCW.init.rd=0x%0x", rd_val), OVM_LOW); 
          fifo_hwm_val = $urandom_range(1,rd_val[7:0]); //(1,4)
           write_fields($psprintf("CFG_FIFO_WMSTAT_CHP_ROP_HCW"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "reorder_pipe");
           read_reg("CFG_FIFO_WMSTAT_CHP_ROP_HCW", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_CHP_ROP_HCW.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   

        if(fifo_sel==2) begin 
           read_reg("CFG_FIFO_WMSTAT_DIR_RPLY_REQ", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_DIR_RPLY_REQ.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_DIR_RPLY_REQ.FIFO_HWM->reset = 8'h06 ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_DIR_RPLY_REQ"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "reorder_pipe");
           read_reg("CFG_FIFO_WMSTAT_DIR_RPLY_REQ", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_DIR_RPLY_REQ.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   

        if(fifo_sel==3) begin 
           read_reg("CFG_FIFO_WMSTAT_LDB_RPLY_REQ", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_LDB_RPLY_REQ.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_LDB_RPLY_REQ.FIFO_HWM->reset = 8'h06 ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_LDB_RPLY_REQ"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "reorder_pipe");
           read_reg("CFG_FIFO_WMSTAT_LDB_RPLY_REQ", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_LDB_RPLY_REQ.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   

        if(fifo_sel==4) begin 
           read_reg("CFG_FIFO_WMSTAT_LSP_REORDERCMP", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_LSP_REORDERCMP.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_LSP_REORDERCMP.FIFO_HWM->reset = 8'h04 ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_LSP_REORDERCMP"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "reorder_pipe");
           read_reg("CFG_FIFO_WMSTAT_LSP_REORDERCMP", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_LSP_REORDERCMP.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   

        if(fifo_sel==5) begin 
           read_reg("CFG_FIFO_WMSTAT_SN_COMPLETE", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_SN_COMPLETE.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_SN_COMPLETE.FIFO_HWM->reset = 8'h04 ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_SN_COMPLETE"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "reorder_pipe");
           read_reg("CFG_FIFO_WMSTAT_SN_COMPLETE", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_SN_COMPLETE.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   

        if(fifo_sel==6) begin 
           read_reg("CFG_FIFO_WMSTAT_SN_ORDERED", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_SN_ORDERED.init.rd=0x%0x", rd_val), OVM_LOW); 
          //CFG_FIFO_WMSTAT_SN_ORDERED.FIFO_HWM->reset = 8'h18 ;
          fifo_hwm_val = rd_val[7:0];
           write_fields($psprintf("CFG_FIFO_WMSTAT_SN_ORDERED"), '{"FIFO_HWM"}, '{fifo_hwm_val}, "reorder_pipe");
           read_reg("CFG_FIFO_WMSTAT_SN_ORDERED", rd_val, "reorder_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_fifo_hwm_task: reorder_pipe.CFG_FIFO_WMSTAT_SN_ORDERED.rd=0x%0x", rd_val), OVM_LOW); 
        end //--  	   
     end //-- if(fifo_hwm_ctrl_sel==5) 

endtask: configure_surv_fifo_hwm_task 

//-------------------------------------
//-- configure_surv_rop_task      
//-- 
//-- 
//--
//-- 
//-------------------------------------
virtual task configure_surv_rop_task(int rop_surv_ctrl);
     sla_ral_data_t rd_val, wr_val;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task: Start rop_surv_ctrl=%0d", rop_surv_ctrl), OVM_LOW);
     if(rop_surv_ctrl==0) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"UNIT_SINGLE_STEP_MODE"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"UNIT_SINGLE_STEP_MODE"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"UNIT_SINGLE_STEP_MODE"}, '{'h1}, "reorder_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==1) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"RR_EN"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"RR_EN"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_0"), '{"RR_EN"}, '{'h1}, "reorder_pipe");
        read_reg("CFG_CONTROL_GENERAL_0", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_CONTROL_GENERAL_0.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==2) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"SB_ECC_CAP_EN"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"SB_ECC_CAP_EN"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"SB_ECC_CAP_EN"}, '{'h1}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==3) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"VAS_RESET_DISABLE"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"VAS_RESET_DISABLE"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"VAS_RESET_DISABLE"}, '{'h1}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==4) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE13"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE13"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE13"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==5) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE12"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE12"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE12"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==6) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE11"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE11"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE11"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==7) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE10"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE10"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE10"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==8) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE9"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE9"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE9"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==9) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE8"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE8"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE8"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==10) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE7"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE7"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE7"}, '{'h1}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==11) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE6"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE6"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE6"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==12) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE5"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE5"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE5"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==13) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE4"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE4"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE4"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==14) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE3"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE3"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE3"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==15) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE2"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE2"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE2"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==16) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE1"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE1"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE1"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(rop_surv_ctrl==17) begin
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE0"}, '{'h0}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE0"}, '{'h1}, "reorder_pipe");
        write_fields($psprintf("CFG_ROP_CSR_CONTROL"), '{"ENABLE0"}, '{'h0}, "reorder_pipe");
        read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task:reorder_pipe.CFG_ROP_CSR_CONTROL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_rop_task: Done rop_surv_ctrl=%0d", rop_surv_ctrl), OVM_LOW);

endtask: configure_surv_rop_task 


//-------------------------------------
//-- configure_surv_aqed_task      
//-- COMPRESS_CODE
//-- 
//--
//-- 
//-------------------------------------
virtual task configure_surv_aqed_task(int aqed_surv_ctrl);
     sla_ral_data_t rd_val, wr_val;

     wr_val=0;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_aqed_task: Start aqed_surv_ctrl=%0d (=8: rnd)", aqed_surv_ctrl), OVM_LOW);

     for(int i=0; i<32; i++) begin
        if(aqed_surv_ctrl==8) wr_val[2:0]=$urandom_range(3'h0,3'h7);

        write_fields($psprintf("CFG_AQED_QID_HID_WIDTH[%0d]",i), '{"COMPRESS_CODE"}, '{wr_val[2:0]}, "aqed_pipe");
        //write_reg($psprintf("CFG_AQED_QID_HID_WIDTH[%0d]",i), aqed_surv_ctrl, "aqed_pipe");
        read_reg($psprintf("CFG_AQED_QID_HID_WIDTH[%0d]",i), rd_val, "aqed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_aqed_task:aqed_pipe.CFG_AQED_QID_HID_WIDTH[%0d].rd=0x%0x", i, rd_val), OVM_LOW); 
     end

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_aqed_task: Done aqed_surv_ctrl=%0d", aqed_surv_ctrl), OVM_LOW);

endtask: configure_surv_aqed_task 


//-------------------------------------
//-- configure_surv_chp_task      
//-- 
//-- 
//--
//-- 
//-------------------------------------
virtual task configure_surv_chp_task(int chp_surv_ctrl);
     sla_ral_data_t rd_val, wr_val;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task: Start chp_surv_ctrl=%0d", chp_surv_ctrl), OVM_LOW);
     if(chp_surv_ctrl==0) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_01"), '{"CHP_BLK_DUAL_ISSUE"}, '{'h1}, "credit_hist_pipe");
        read_reg("CFG_CONTROL_GENERAL_01", rd_val , "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task:credit_hist_pipe.CFG_CONTROL_GENERAL_01.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(chp_surv_ctrl==1) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL_01"), '{"INCLUDE_CWDI_TIMER_IDLE_EN"}, '{'h1}, "credit_hist_pipe");
        read_reg("CFG_CONTROL_GENERAL_01", rd_val , "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task:credit_hist_pipe.CFG_CONTROL_GENERAL_01.rd=0x%0x", rd_val), OVM_LOW); 
     end

     //--CHP HWM rnd
     if(chp_surv_ctrl==2) begin
        wr_val=0;
        wr_val[4:0]=$urandom_range(5'h1,5'h10);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"OUTBOUND_HCW_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");

        wr_val[4:0]=$urandom_range(5'h1,5'h10);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"OUTBOUND_HCW_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");

        wr_val[4:0]=$urandom_range(5'h1,5'h10);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"LSP_AP_CMP_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");

        wr_val[4:0]=$urandom_range(5'h1,5'h10);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"LSP_TOK_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");

        wr_val[4:0]=$urandom_range(5'h1,5'h10);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"ROP_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");

        wr_val[3:0]=$urandom_range(4'h1,4'h8);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"EGRESS_PIPE_CREDIT_HWM"}, '{wr_val[3:0]}, "credit_hist_pipe");

        wr_val[3:0]=$urandom_range(4'h1,4'h8);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"QED_TO_CQ_PIPE_CREDIT_HWM"}, '{wr_val[3:0]}, "credit_hist_pipe");

        wr_val[2:0]=$urandom_range(3'h1,3'h4);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"EGRESS_LSP_TOKEN_PIPE_CREDIT"}, '{wr_val[2:0]}, "credit_hist_pipe");

        read_reg("CFG_CONTROL_GENERAL_00", rd_val , "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task:credit_hist_pipe.CFG_CONTROL_GENERAL_00.rd=0x%0x", rd_val), OVM_LOW); 
     end

     //--CHP HWM=1 
     if(chp_surv_ctrl==3) begin
        wr_val=1;
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"OUTBOUND_HCW_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"OUTBOUND_HCW_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"LSP_AP_CMP_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"LSP_TOK_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"ROP_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"EGRESS_PIPE_CREDIT_HWM"}, '{wr_val[3:0]}, "credit_hist_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"QED_TO_CQ_PIPE_CREDIT_HWM"}, '{wr_val[3:0]}, "credit_hist_pipe");
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"EGRESS_LSP_TOKEN_PIPE_CREDIT"}, '{wr_val[2:0]}, "credit_hist_pipe");
        read_reg("CFG_CONTROL_GENERAL_00", rd_val , "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task:credit_hist_pipe.CFG_CONTROL_GENERAL_00.rd=0x%0x", rd_val), OVM_LOW); 
     end

     //--
     if(chp_surv_ctrl==4) begin
        wr_val=0;
        wr_val[4:0]=$urandom_range(5'h1,5'h10);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"OUTBOUND_HCW_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");
        read_reg("CFG_CONTROL_GENERAL_00", rd_val , "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task:credit_hist_pipe.CFG_CONTROL_GENERAL_00.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(chp_surv_ctrl==5) begin
        wr_val[4:0]=$urandom_range(5'h1,5'h10);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"LSP_AP_CMP_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");
        read_reg("CFG_CONTROL_GENERAL_00", rd_val , "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task:credit_hist_pipe.CFG_CONTROL_GENERAL_00.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(chp_surv_ctrl==6) begin
        wr_val[4:0]=$urandom_range(5'h1,5'h10);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"LSP_TOK_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");
        read_reg("CFG_CONTROL_GENERAL_00", rd_val , "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task:credit_hist_pipe.CFG_CONTROL_GENERAL_00.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(chp_surv_ctrl==7) begin
        wr_val[4:0]=$urandom_range(5'h8,5'h10);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"ROP_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");
        read_reg("CFG_CONTROL_GENERAL_00", rd_val , "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task:credit_hist_pipe.CFG_CONTROL_GENERAL_00.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(chp_surv_ctrl==8) begin
        wr_val[4:0]=$urandom_range(4'h1,4'h8);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"EGRESS_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");
        read_reg("CFG_CONTROL_GENERAL_00", rd_val , "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task:credit_hist_pipe.CFG_CONTROL_GENERAL_00.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(chp_surv_ctrl==9) begin
        wr_val[4:0]=$urandom_range(4'h1,4'h8);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"QED_TO_CQ_PIPE_CREDIT_HWM"}, '{wr_val}, "credit_hist_pipe");
        read_reg("CFG_CONTROL_GENERAL_00", rd_val , "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task:credit_hist_pipe.CFG_CONTROL_GENERAL_00.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(chp_surv_ctrl==10) begin
        wr_val[4:0]=$urandom_range(3'h1,3'h4);
        write_fields($psprintf("CFG_CONTROL_GENERAL_00"), '{"EGRESS_LSP_TOKEN_PIPE_CREDIT"}, '{wr_val}, "credit_hist_pipe");
        read_reg("CFG_CONTROL_GENERAL_00", rd_val , "credit_hist_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task:credit_hist_pipe.CFG_CONTROL_GENERAL_00.rd=0x%0x", rd_val), OVM_LOW); 
     end


     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_chp_task: Done chp_surv_ctrl=%0d", chp_surv_ctrl), OVM_LOW);

endtask: configure_surv_chp_task 

//-------------------------------------
//-- configure_surv_qed_task      
//-- 
//-- 
//--
//-- 
//-------------------------------------
virtual task configure_surv_qed_task(int chp_surv_ctrl);
     sla_ral_data_t rd_val, wr_val;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_qed_task: Start chp_surv_ctrl=%0d", chp_surv_ctrl), OVM_LOW);
     if(chp_surv_ctrl==0) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_SIM"}, '{'h1}, "qed_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val , "qed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_qed_task:qed_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if(chp_surv_ctrl==1) begin
        write_fields($psprintf("CFG_CONTROL_GENERAL"), '{"CHICKEN_STRICT"}, '{'h1}, "qed_pipe");
        read_reg("CFG_CONTROL_GENERAL", rd_val , "qed_pipe");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_qed_task:qed_pipe.CFG_CONTROL_GENERAL.rd=0x%0x", rd_val), OVM_LOW); 
     end

    
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_surv_qed_task: Done chp_surv_ctrl=%0d", chp_surv_ctrl), OVM_LOW);

endtask: configure_surv_qed_task 


//---------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
//--                 hw errinj used in HQMV2 hqm_proc TB
//---------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------
//-- CHP error inj issue 
//-------------------------------------
virtual task configure_hwerrinj_task(int err_inj);

     sla_ral_data_t rd_val, wr_val;
     bit                    wr_bit_val;
     int                    err_inj_loop;
     int                    chp_err_write;

     chp_err_write=0;
     err_inj_loop = err_inj;
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task: Start err_inj_loop=%0d", err_inj_loop), OVM_LOW);
     //-----------------------------
     //--sys ERROR INJ
     //-----------------------------
     if($test$plusargs("has_sys_enqsbe_all")) begin 
         //hqm_system_regs.SYS_ALARM_SB_ECC_INT_ENABLE  default is on
         //hqm_system_regs.ECC_CTL.write_fields(status, {"INJ_SB_ECC_WBUF_W1_MS", "INJ_SB_ECC_WBUF_W1_LS", "INJ_SB_ECC_WBUF_W0_MS", "INJ_SB_ECC_WBUF_W0_LS", "INJ_SB_ECC_HCW_ENQ_MS", "INJ_SB_ECC_HCW_ENQ_LS", "INJ_SB_ECC_CFG", "WRITE_BAD_SB_ECC"}, {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}, primary_id, this); 
         //--AY_RM_V30: INJ_SB_ECC_CFG removed from ecc_ctl
         write_fields($psprintf("ecc_ctl"), '{"INJ_SB_ECC_WBUF_W1_MS", "INJ_SB_ECC_WBUF_W1_LS", "INJ_SB_ECC_WBUF_W0_MS", "INJ_SB_ECC_WBUF_W0_LS", "INJ_SB_ECC_HCW_ENQ_MS", "INJ_SB_ECC_HCW_ENQ_LS", "WRITE_BAD_SB_ECC"}, '{1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}, "hqm_system_csr");

         read_reg("ecc_ctl", rd_val , "hqm_system_csr");
         ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:hqm_system_regs.ECC_CTL.rd=0x%0x", rd_val), OVM_LOW); 
     end
     
        
     //-----------------------------
     //--CHP ERROR INJ
     //-----------------------------
     //-- sbe error inj enable
     wr_val=0;     
     if($test$plusargs("has_chp_enqsbe_inj0") && $test$plusargs("has_chp_enqsbe_inj1")) begin
               //--enq MBE inj  
               wr_val[1:0]=$urandom_range(1,3);
               wr_val[3:2]=wr_val[1:0]; 
               chp_err_write=1;
     end else if($test$plusargs("has_chp_enqsbe_inj0") && !$test$plusargs("has_chp_enqsbe_inj1")) begin
               //--enq SBE inj  
               wr_val[1:0]=$urandom_range(1,3); 
               chp_err_write=1;
     end else if(!$test$plusargs("has_chp_enqsbe_inj0") && $test$plusargs("has_chp_enqsbe_inj1")) begin
               //--enq SBE inj  
               wr_val[3:2]=$urandom_range(1,3); 
               chp_err_write=1;
     end

     if($test$plusargs("has_chp_schsbe_inj0") && $test$plusargs("has_chp_schsbe_inj1")) begin
               //--sch MBE inj 
               wr_val[5:4]=$urandom_range(1,3);
               wr_val[7:6]=wr_val[5:4]; 
               chp_err_write=1;
     end else if($test$plusargs("has_chp_schsbe_inj0") && !$test$plusargs("has_chp_schsbe_inj1")) begin
               //--sch SBE inj 
               wr_val[5:4]=$urandom_range(1,3); 
               chp_err_write=1;
     end else if(!$test$plusargs("has_chp_schsbe_inj0") && $test$plusargs("has_chp_schsbe_inj1")) begin
               //--sch SBE inj 
               wr_val[7:6]=$urandom_range(1,3); 
               chp_err_write=1;
     end

     //--parity error inj enable
     if($test$plusargs("has_chp_egrhcw_parerr_inj")) begin
               //--parity error inj from chp to sys  
               wr_val[9:8]=$urandom_range(1,3);  
               chp_err_write=1;
     end
     if($test$plusargs("has_chp_egrusr_parerr_inj")) begin
               //--parity error inj    
               wr_val[11:10]=$urandom_range(1,3);  
               chp_err_write=1;
     end
     if($test$plusargs("has_chp_inghcw_parerr_inj")) begin
               //--parity error inj  
               wr_val[13:12]=$urandom_range(1,3);  
               chp_err_write=1;
     end
     if($test$plusargs("has_chp_ingusr_parerr_inj")) begin
               //--parity error inj  
               wr_val[15:14]=$urandom_range(1,3);  
               chp_err_write=1;
     end          


     //-- parity error inj to DQED flid
     if($test$plusargs("has_chp_dqed_parerr_inj") || $test$plusargs("has_chp_qeddqed_parerr_rndinj")) begin
               //--parity error inj from chp to sys  
               wr_val[16]= err_inj_loop[0]; // $urandom_range(1,0);  
               chp_err_write=1;
     end
     if($test$plusargs("has_chp_qed_parerr_inj")  || $test$plusargs("has_chp_qeddqed_parerr_rndinj")) begin
               //--parity error inj from chp to sys  
               wr_val[17]= ~err_inj_loop[0]; //$urandom_range(1,0);  
               chp_err_write=1;
     end
     //-- parity error inj to outgoing flid chp-> rop-> qed->lsp->chp
     if($test$plusargs("has_chp_enqflid_parerr_inj")) begin
               //--parity error inj from chp to sys  
               wr_val[18]= err_inj_loop[0];  //$urandom_range(1,0);  
               chp_err_write=1;
     end

     // "INGRESS_ERROR_INJECTION_H1", "INGRESS_ERROR_INJECTION_L1", "INGRESS_ERROR_INJECTION_H0", "INGRESS_ERROR_INJECTION_L0", "EGRESS_ERROR_INJECTION_H1", "EGRESS_ERROR_INJECTION_L1", "EGRESS_ERROR_INJECTION_H0", "EGRESS_ERROR_INJECTION_L0", "SCHPIPE_ERROR_INJECTION_H1", "SCHPIPE_ERROR_INJECTION_L1", "SCHPIPE_ERROR_INJECTION_H0", "SCHPIPE_ERROR_INJECTION_L0", "ENQPIPE_ERROR_INJECTION_H1", "ENQPIPE_ERROR_INJECTION_L1", "ENQPIPE_ERROR_INJECTION_H0", "ENQPIPE_ERROR_INJECTION_L0"
     //chp_regs.CFG_CONTROL_GENERAL_02.write_fields(status, {"INGRESS_ERROR_INJECTION_H1", "INGRESS_ERROR_INJECTION_L1", "INGRESS_ERROR_INJECTION_H0", "INGRESS_ERROR_INJECTION_L0", "EGRESS_ERROR_INJECTION_H1", "EGRESS_ERROR_INJECTION_L1", "EGRESS_ERROR_INJECTION_H0", "EGRESS_ERROR_INJECTION_L0", "SCHPIPE_ERROR_INJECTION_H1", "SCHPIPE_ERROR_INJECTION_L1", "SCHPIPE_ERROR_INJECTION_H0", "SCHPIPE_ERROR_INJECTION_L0", "ENQPIPE_ERROR_INJECTION_H1", "ENQPIPE_ERROR_INJECTION_L1", "ENQPIPE_ERROR_INJECTION_H0", "ENQPIPE_ERROR_INJECTION_L0"}, {wr_val[15:0]}, primary_id, this); 
     //chp_regs.CFG_CONTROL_GENERAL_02.write(status, wr_val, primary_id, this);

//--07262019 Te's newly added error inj
//+hqm_credit_hist_pipe.cfg_control_general_02.egress_wbo_error_injection_3                0x4c000034 0x00000000   bits[22:22] default=0x00000000                  RW 
//+hqm_credit_hist_pipe.cfg_control_general_02.egress_wbo_error_injection_2                0x4c000034 0x00000000   bits[21:21] default=0x00000000                  RW 
//+hqm_credit_hist_pipe.cfg_control_general_02.egress_wbo_error_injection_1                0x4c000034 0x00000000   bits[20:20] default=0x00000000                  RW 
//+hqm_credit_hist_pipe.cfg_control_general_02.egress_wbo_error_injection_0                0x4c000034 0x00000000   bits[19:19] default=0x00000000                  RW
     if($test$plusargs("has_chp_egr_wbo_errinj_0")) begin
               wr_val[19]=err_inj_loop[0];  //$urandom_range(1,0);  
               chp_err_write=1;
     end

     if($test$plusargs("has_chp_egr_wbo_errinj_1")) begin
               wr_val[20]=err_inj_loop[0];  //$urandom_range(1,0);  
               chp_err_write=1;
     end

     if($test$plusargs("has_chp_egr_wbo_errinj_2")) begin
               wr_val[21]=err_inj_loop[0];  //$urandom_range(1,0);  
               chp_err_write=1;
     end

     if($test$plusargs("has_chp_egr_wbo_errinj_3")) begin
               wr_val[22]=err_inj_loop[0];  //$urandom_range(1,0);  
               chp_err_write=1;
     end


     //--------------------------------------------------------------------------------
     if(chp_err_write) begin
         write_reg("CFG_CONTROL_GENERAL_02", wr_val, "credit_hist_pipe");
         ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:credit_hist_pipe.CFG_CONTROL_GENERAL_02.wr=0x%0x", wr_val), OVM_LOW); 

         read_reg("CFG_CONTROL_GENERAL_02", rd_val, "credit_hist_pipe");
         ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:credit_hist_pipe.CFG_CONTROL_GENERAL_02.rd=0x%0x", rd_val), OVM_LOW); 
         if(rd_val != wr_val && !$test$plusargs("bypass_chp_general_regck"))
            ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:credit_hist_pipe.CFG_CONTROL_GENERAL_02.rd=0x%0x wr=0x%0x", rd_val, wr_val), OVM_LOW); 
     end

     //--------------------------------------------------------------------------------
     //--------------------------------------------------------------------------------
     if($test$plusargs("has_qed_parerr_inj")) begin
          //--parity error inj to qed flid  
          wr_val=err_inj_loop[0];  //$urandom_range(0,1);  
          if(wr_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"NALB_QED"}, '{1'b1}, "qed_pipe"); //--this register is not functioned
            read_reg("CFG_ERROR_INJECT", rd_val, "qed_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:qed_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          end 
     end
     //read_reg("CFG_ERROR_INJECT", rd_val, "qed_pipe");
     //ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:qed_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 

     //--------------------------------------------------------------------------------
     //--------------------------------------------------------------------------------
     if($test$plusargs("has_nalb_parerr_inj_1")) begin
          //--parity error inj to qed flid  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"LSP_NALB_0"}, '{wr_bit_val}, "nalb_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "nalb_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:nalb_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_nalb_parerr_inj_0")) begin
          //--parity error inj to qed flid  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"ROP_NALB_0"}, '{wr_bit_val}, "nalb_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "nalb_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:nalb_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end


     //--------------------------------------------------------------------------------
     //--------------------------------------------------------------------------------
     if($test$plusargs("has_dp_parerr_inj_1")) begin
          //--parity error inj to dq 
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1); 
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end  
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"LSP_DP_0"}, '{wr_bit_val}, "direct_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "direct_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:direct_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_dp_parerr_inj_0")) begin
          //--parity error inj to dq 
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"ROP_DP_0"}, '{wr_bit_val}, "direct_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "direct_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:direct_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end


     //--------------------------------------------------------------------------------
     //--------------------------------------------------------------------------------
     if($test$plusargs("has_atm_parerr_inj_2")) begin
          //--parity error inj to atm_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"CHP_AP"}, '{wr_bit_val}, "atm_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "atm_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:atm_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end


     if($test$plusargs("has_atm_parerr_inj_1")) begin
          //--parity error inj to atm_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"FID2QIDI"}, '{wr_bit_val}, "atm_pipe"); //"This PARITY error injection does not propagate and hence no detection. treat this as NOOP";
            read_reg("CFG_ERROR_INJECT", rd_val, "atm_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:atm_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end


     if($test$plusargs("has_atm_parerr_inj_0")) begin
          //--parity error inj to atm_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"AQED_AP"}, '{wr_bit_val}, "atm_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "atm_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:atm_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end


     //--------------------------------------------------------------------------------
     //--------------------------------------------------------------------------------
     if($test$plusargs("has_lsp_parerr_inj_14")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"LDB_TOK_CNT_UFLOW"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_lsp_parerr_inj_13")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"DIR_TOK_CNT_UFLOW"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_lsp_parerr_inj_12")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"DP_RPL_PERR"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_lsp_parerr_inj_11")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"LDB_RPL_PERR"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_lsp_parerr_inj_10")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"ATQ_PERR"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_lsp_parerr_inj_9")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"LDB_FLAG_PERR"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_lsp_parerr_inj_8")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"LDB_QID_PERR"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_lsp_parerr_inj_7")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"DP_QID_PERR"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_lsp_parerr_inj_6")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
          //if(wr_bit_val==0) begin
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"LDB_TOK_FIFO_UFLOW"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_lsp_parerr_inj_5")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"DIR_INP_PERR"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if($test$plusargs("has_lsp_parerr_inj_4")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"CQ2QID_PERR"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if($test$plusargs("has_lsp_parerr_inj_3")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"QID2CQIDIX_PERR"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if($test$plusargs("has_lsp_parerr_inj_2")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"DIR_TOK_LIM_PERR"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if($test$plusargs("has_lsp_parerr_inj_1")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"ATQ_AQED_LIM_PERR"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
     end

     if($test$plusargs("has_lsp_parerr_inj_0")) begin
          //--parity error inj to list_sel_pipe  
          wr_bit_val=$test$plusargs("has_hw_parerrinj_aon") ? err_inj : $urandom_range(0,1);  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"LDB_CQ_IF_CNT_UFLOW"}, '{wr_bit_val}, "list_sel_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "list_sel_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:list_sel_pipe.CFG_ERROR_INJECT.rd=0x%0x", rd_val), OVM_LOW); 
     end


     //--------------------------------------------------------------------------------
     //--------------------------------------------------------------------------------
     if($test$plusargs("has_aqed_parerr_inj_0")) begin
          //--parity error inj to aqed flid  
          //wr_val=$urandom_range(0,1);  
          //if(wr_val==0) begin
            //aqed_regs.CFG_ERROR_INJECT.write_fields(status, {"FLID"},   {'b1}, primary_id, this); 
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"FLID_0"}, '{wr_bit_val}, "aqed_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "aqed_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:aqed_pipe.CFG_ERROR_INJECT.rd=0x%0x FLID_0 wr_bit_val=%0d", rd_val, wr_bit_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_aqed_parerr_inj_1")) begin
          //--parity error inj to aqed flid  
          //wr_val=$urandom_range(0,1);  
          //if(wr_val==0) begin
            //aqed_regs.CFG_ERROR_INJECT.write_fields(status, {"FLID"},   {'b1}, primary_id, this); 
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"FLID_1"}, '{wr_bit_val}, "aqed_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "aqed_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:aqed_pipe.CFG_ERROR_INJECT.rd=0x%0x FLID_1 wr_bit_val=%0d", rd_val, wr_bit_val), OVM_LOW); 
          //end 
     end

     if($test$plusargs("has_aqed_parerr_inj_2")) begin
          //--parity error inj to aqed flid  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"AP_AQED_0"}, '{wr_bit_val}, "aqed_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "aqed_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:aqed_pipe.CFG_ERROR_INJECT.rd=0x%0x AP_AQED_0 wr_bit_val=%0d", rd_val, wr_bit_val), OVM_LOW); 
     end

     if($test$plusargs("has_aqed_parerr_inj_3")) begin
          //--parity error inj to aqed flid  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"QED_AQED_0"}, '{wr_bit_val}, "aqed_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "aqed_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:aqed_pipe.CFG_ERROR_INJECT.rd=0x%0x QED_AQED_0 wr_bit_val=%0d", rd_val, wr_bit_val), OVM_LOW); 

     end

     if($test$plusargs("has_aqed_parerr_inj_4")) begin
          //--parity error inj to aqed flid  
          if($test$plusargs("has_hw_parerrinj_aon")) begin
              wr_bit_val = 1;
          end else if($test$plusargs("has_hw_parerrinj_onoff")) begin
              wr_bit_val = err_inj;
          end else begin
              wr_bit_val = err_inj_loop[0];  //$urandom_range(0,1);
          end 
            write_fields($psprintf("CFG_ERROR_INJECT"), '{"AP_AQED_1"}, '{wr_bit_val}, "aqed_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val, "aqed_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_configure_hwerrinj_task:aqed_pipe.CFG_ERROR_INJECT.rd=0x%0x AP_AQED_1 wr_bit_val=%0d", rd_val, wr_bit_val), OVM_LOW); 

     end


endtask : configure_hwerrinj_task

//---------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
//--                 bgcfg rd/wr used in HQMV2 hqm_proc TB
//---------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------
//-- rnd select bgcfg tasks
//------------------ +hqmproc_bgcfg_grp_sel=<n> can specify which group of registers to access
//------------------ +hqmproc_bgcfg_sel=<n>     can specify which task to issue
//-------------------------------------
virtual task backgroundcfg_access_sel_task();
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     int                           task_sel, task_grp_sel, bgsel, idx_min, idx_max, idx_len, idx_limit;

     task_grp_sel=0;     
     $value$plusargs("hqmproc_bgcfg_grp_sel=%d", task_grp_sel);

     if(task_grp_sel==1) begin
       //--focus on chp and rop
       task_sel = $urandom_range (0,9); 
       if(task_sel==8)      task_sel=20; //--rop
       else if(task_sel==9) task_sel=21; //--rop
     end else if(task_grp_sel==2) begin
       //--focus on lsp
       task_sel = $urandom_range (12,19); 
     end else if(task_grp_sel==3) begin
       //--focus on other hqm_core module
       task_sel = $urandom_range (8,11); 
     end else if(task_grp_sel==4) begin
       //--focus on non-ram registers in hqm_core
       task_sel = $urandom_range (22,29); 
     end else if(task_grp_sel==5) begin
       //--focus on other hqm_system
       task_sel = $urandom_range (30,36); 

     end else begin
       //------------------ rnd
        task_sel = $urandom_range (0,38); 
       //------------------ +hqmproc_bgcfg_sel=<n> can specify which task to issue
         $value$plusargs("hqmproc_bgcfg_sel=%d", task_sel);
     end 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_sel_task: Start task_grp_sel=%0d task_sel=%0d ", task_grp_sel, task_sel), OVM_LOW);     

     if(task_sel==0) begin
        backgroundcfg_access_task_0();
     end else if(task_sel==1) begin
        backgroundcfg_access_task_1();
     end else if(task_sel==2) begin
        backgroundcfg_access_task_2();
     end else if(task_sel==3) begin
        backgroundcfg_access_task_3();
     end else if(task_sel==4) begin
        backgroundcfg_access_task_4();
     end else if(task_sel==5 && $test$plusargs("has_freelist_access")) begin
        backgroundcfg_access_task_5();
     end else if(task_sel==6) begin
        backgroundcfg_access_task_6();
     end else if(task_sel==7) begin
        backgroundcfg_access_task_7();
     end else if(task_sel==8) begin
        backgroundcfg_access_task_8();
     end else if(task_sel==9) begin
        backgroundcfg_access_task_9();
     end else if(task_sel==10 && $test$plusargs("has_freelist_access")) begin
        backgroundcfg_access_task_10();
     end else if(task_sel==11) begin
        backgroundcfg_access_task_11();
     end else if(task_sel==12) begin
        backgroundcfg_access_task_12();
     end else if(task_sel==13) begin
        backgroundcfg_access_task_13();
     end else if(task_sel==14) begin
        backgroundcfg_access_task_14();
     end else if(task_sel==15) begin
        backgroundcfg_access_task_15();
     end else if(task_sel==16) begin
        backgroundcfg_access_task_16();
     end else if(task_sel==17) begin
        backgroundcfg_access_task_17();
     end else if(task_sel==18) begin
        backgroundcfg_access_task_18();
     end else if(task_sel==19) begin
        backgroundcfg_access_task_19();
     end else if(task_sel==20) begin
        backgroundcfg_access_task_20();
     end else if(task_sel==21) begin
        backgroundcfg_access_task_21();
     end else if(task_sel==22) begin
        backgroundcfg_access_task_22();
     end else if(task_sel==23) begin
        backgroundcfg_access_task_23();
     end else if(task_sel==24) begin
        backgroundcfg_access_task_24();
     end else if(task_sel==25) begin
        backgroundcfg_access_task_25();
     end else if(task_sel==26) begin
        backgroundcfg_access_task_26();
     end else if(task_sel==27) begin
        backgroundcfg_access_task_27();
     end else if(task_sel==28) begin
        backgroundcfg_access_task_28();
     end else if(task_sel==29) begin
        backgroundcfg_access_task_29();
     end else if(task_sel==30) begin
        backgroundcfg_access_task_30();
     end else if(task_sel==31) begin
        backgroundcfg_access_task_31();
     end else if(task_sel==32) begin
        backgroundcfg_access_task_32();
     end else if(task_sel==33) begin
        backgroundcfg_access_task_33();
     end else if(task_sel==34) begin
        backgroundcfg_access_task_34();
     end else if(task_sel==35) begin
        backgroundcfg_access_task_35();
     end else if(task_sel==36) begin
        backgroundcfg_access_task_36();
     end else if(task_sel==37) begin
        backgroundcfg_access_task_37();
     end else if(task_sel==38) begin
        backgroundcfg_access_task_38();
     end else if(task_sel==39) begin
        backgroundcfg_access_task_39();
     end
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_sel_task: Done task_grp_sel=%0d task_sel=%0d ", task_grp_sel, task_sel), OVM_LOW);     
endtask: backgroundcfg_access_sel_task


//-------------------------------------
//-- backgroundcfg_access_task_0 
//-- chp_regs.CFG_ORD_QID_SN_MAP[32]
//-- chp_regs.CFG_ORD_QID_SN[32]
//-- chp_regs.CFG_CMP_SN_CHK_ENBL[64]
//-------------------------------------
virtual task backgroundcfg_access_task_0();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;

     bgsel = $urandom_range (0,2); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel==2) idx_limit = 64;
     else         idx_limit = 32;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;   

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_0: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            wr_val=0;	       
            wr_val[2:0]  = i_hqm_cfg.ldb_qid_cfg[i].ord_mode;  
            wr_val[7:3]  = i_hqm_cfg.ldb_qid_cfg[i].ord_slot;
            wr_val[8]    = i_hqm_cfg.ldb_qid_cfg[i].ord_grp[0];	 
            read_reg($psprintf("CFG_ORD_QID_SN_MAP[%0d]",i), rd_val, "credit_hist_pipe");
            write_reg($psprintf("CFG_ORD_QID_SN_MAP[%0d]",i), wr_val, "credit_hist_pipe");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_0: credit_hist_pipe.CFG_ORD_QID_SN_MAP[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x ", i, wr_val, rd_val), OVM_MEDIUM);
            read_reg($psprintf("CFG_ORD_QID_SN_MAP[%0d]",i), rd_val, "credit_hist_pipe");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_0: credit_hist_pipe.CFG_ORD_QID_SN_MAP[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x ", i, wr_val, rd_val), OVM_MEDIUM);
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_0: credit_hist_pipe.CFG_ORD_QID_SN_MAP[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_ORD_QID_SN[%0d]",i), rd_val, "credit_hist_pipe");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_0: credit_hist_pipe.CFG_ORD_QID_SN[%0d].bgcfgrd=0x%0x ", i, rd_val), OVM_MEDIUM);
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            wr_val=0;	       
            wr_val[0]  = i_hqm_cfg.ldb_pp_cq_cfg[i].cq_cmpck_ena;  
            write_reg($psprintf("CFG_CMP_SN_CHK_ENBL[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_CMP_SN_CHK_ENBL[%0d]",i), rd_val, "credit_hist_pipe");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_0: credit_hist_pipe.CFG_CMP_SN_CHK_ENBL[%0d].hqmcfgwr=0x%0x bgcfgrd=0x%0x ", i, wr_val, rd_val), OVM_MEDIUM);
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_0: credit_hist_pipe.CFG_CMP_SN_CHK_ENBL[%0d].hqmcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

     end//--for 

     //--additional WD register access
     for(int i=0; i<8; i++) begin
         read_reg("CFG_DIR_WD_ENB_INTERVAL", rd_val , "credit_hist_pipe");
         read_reg("CFG_LDB_WD_ENB_INTERVAL", rd_val , "credit_hist_pipe");
     end

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_0: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_0

//-------------------------------------
//-- backgroundcfg_access_task_1
//-- credit_hist_pipe.CFG_HIST_LIST_PUSH_PTR[64]   not support background write
//-- credit_hist_pipe.CFG_HIST_LIST_POP_PTR[64]  not support background write
//-- credit_hist_pipe.CFG_HIST_LIST_BASE[64]   not support background write  
//-- credit_hist_pipe.CFG_HIST_LIST_LIMIT[64]  not support background write  
//-- credit_hist_pipe.CFG_CHP_FRAG_COUNT[64]
//-------------------------------------
virtual task backgroundcfg_access_task_1();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;

     bgsel = $urandom_range (0,4);

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 64;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len);
     idx_max = idx_min + idx_len;
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_1: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin
            wr_val=0;
            wr_val = {1'b0, i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base[12:0]};
            read_reg($psprintf("CFG_HIST_LIST_PUSH_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_HIST_LIST_A_PUSH_PTR[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin
            read_reg($psprintf("CFG_HIST_LIST_POP_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_HIST_LIST_A_POP_PTR[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_HIST_LIST_BASE[%0d]",i), rd_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_HIST_LIST_A_BASE[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_HIST_LIST_LIMIT[%0d]",i), rd_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_HIST_LIST_A_LIMIT[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin
            read_reg($psprintf("CFG_CHP_FRAG_COUNT[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

     end//--for
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_1: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_1

//-------------------------------------
//-- backgroundcfg_access_task_2 
//-- credit_hist_pipe.CFG_DIR_CQ_DEPTH[96]
//-- credit_hist_pipe.CFG_DIR_CQ_WPTR[96]
//-- credit_hist_pipe.CFG_LDB_CQ_DEPTH[64]
//-- credit_hist_pipe.CFG_LDB_CQ_WPTR[64]
//-------------------------------------
virtual task backgroundcfg_access_task_2();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0,5); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel<3)  idx_limit = hqm_pkg::NUM_DIR_CQ;
     else         idx_limit = hqm_pkg::NUM_LDB_CQ;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_2: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_DIR_CQ_DEPTH[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_DIR_CQ_WPTR[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_LDB_CQ_DEPTH[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("CFG_LDB_CQ_WPTR[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
         end//--
     end//--for 


     //--additional WD register access
     for(int i=0; i<8; i++) begin
         read_reg("CFG_DIR_WD_ENB_INTERVAL", rd_val , "credit_hist_pipe");
         read_reg("CFG_LDB_WD_ENB_INTERVAL", rd_val , "credit_hist_pipe");
     end

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_2: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_2



//-------------------------------------
//-- backgroundcfg_access_task_3 
//-- credit_hist_pipe.CFG_DIR_CQ_TOKEN_DEPTH_SELECT[96]  not support background write  01242017
//-- credit_hist_pipe.CFG_LDB_CQ_TOKEN_DEPTH_SELECT[64]  not support background write  01242017
//-------------------------------------
virtual task backgroundcfg_access_task_3();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0,1); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel==0) idx_limit = hqm_pkg::NUM_DIR_CQ;
     else         idx_limit = hqm_pkg::NUM_LDB_CQ;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;  
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_3: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_DIR_CQ_TOKEN_DEPTH_SELECT[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_LDB_CQ_TOKEN_DEPTH_SELECT[%0d]",i), rd_val, "credit_hist_pipe");
         end//--
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_3: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_3



//-------------------------------------
//-- backgroundcfg_access_task_4 
//-- credit_hist_pipe.CFG_VAS_CREDIT_COUNT[32]  not support background write  
//-- credit_hist_pipe.CFG_DIR_CQ2VAS[96]  not support background write  
//-- credit_hist_pipe.CFG_LDB_CQ2VAS[64]  not support background write  
//-------------------------------------
virtual task backgroundcfg_access_task_4();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0,2); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel==0)      idx_limit = hqm_pkg::NUM_LDB_QID;
     else if(bgsel==1) idx_limit = hqm_pkg::NUM_DIR_CQ;
     else              idx_limit = hqm_pkg::NUM_LDB_CQ;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;  
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_4: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_VAS_CREDIT_COUNT[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_DIR_CQ2VAS[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_LDB_CQ2VAS[%0d]",i), rd_val, "credit_hist_pipe");
         end//--
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_4: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_4

//-------------------------------------
//-- backgroundcfg_access_task_5 
//-- credit_hist_pipe     
//-- credit_hist_pipe.CFG_HIST_LIST_0[2048]    
//-- credit_hist_pipe.CFG_HIST_LIST_1[2048]    
//-- credit_hist_pipe.CFG_FREELIST_0[2048]    
//-- credit_hist_pipe.CFG_FREELIST_1[2048]    
//-- credit_hist_pipe.CFG_FREELIST_2[2048]    
//-- credit_hist_pipe.CFG_FREELIST_3[2048]    
//-- credit_hist_pipe.CFG_FREELIST_4[2048]    
//-- credit_hist_pipe.CFG_FREELIST_5[2048]    
//-- credit_hist_pipe.CFG_FREELIST_6[2048]    
//-- credit_hist_pipe.CFG_FREELIST_7[2048]    
//-------------------------------------
virtual task backgroundcfg_access_task_5();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0,9); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 2048;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;  
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_5: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_HIST_LIST_0[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_HIST_LIST_1[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_FREELIST_0[%0d]",i), rd_val, "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_FREELIST_1[%0d]",i), rd_val, "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("CFG_FREELIST_2[%0d]",i), rd_val, "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("CFG_FREELIST_3[%0d]",i), rd_val, "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==6) begin  
            read_reg($psprintf("CFG_FREELIST_4[%0d]",i), rd_val, "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==7) begin  
            read_reg($psprintf("CFG_FREELIST_5[%0d]",i), rd_val, "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==8) begin  
            read_reg($psprintf("CFG_FREELIST_6[%0d]",i), rd_val, "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==9) begin  
            read_reg($psprintf("CFG_FREELIST_7[%0d]",i), rd_val, "credit_hist_pipe");
         end//--
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_5: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_5

//-------------------------------------
//-- backgroundcfg_access_task_6 
//-- credit_hist_pipe.CFG_DIR_CQ_TIMER_THRESHOLD[96]     
//-- credit_hist_pipe.CFG_DIR_CQ_WD_ENB[96]              
//-- credit_hist_pipe.CFG_DIR_CQ_TIMER_COUNT[96]              
//-- credit_hist_pipe.CFG_LDB_CQ_TIMER_THRESHOLD[64]     
//-- credit_hist_pipe.CFG_LDB_CQ_WD_ENB[64]             
//-- credit_hist_pipe.CFG_LDB_CQ_TIMER_COUNT[64]             
//-------------------------------------
virtual task backgroundcfg_access_task_6();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0,5); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel<3) idx_limit = hqm_pkg::NUM_DIR_CQ;
     else        idx_limit = hqm_pkg::NUM_LDB_CQ;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;   
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_6: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_DIR_CQ_TIMER_THRESHOLD[%0d]",i), rd_val, "credit_hist_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_DIR_CQ_TIMER_THRESHOLD[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_DIR_CQ_TIMER_THRESHOLD[%0d]",i), rd_val, "credit_hist_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_6: credit_hist_pipe.CFG_DIR_CQ_TIMER_THRESHOLD[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_DIR_CQ_WD_ENB[%0d]",i), rd_val, "credit_hist_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_DIR_CQ_WD_ENB[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_DIR_CQ_WD_ENB[%0d]",i), rd_val, "credit_hist_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_6: credit_hist_pipe.CFG_DIR_CQ_WD_ENB[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_DIR_CQ_TIMER_COUNT[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_LDB_CQ_TIMER_THRESHOLD[%0d]",i), rd_val, "credit_hist_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_LDB_CQ_TIMER_THRESHOLD[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_LDB_CQ_TIMER_THRESHOLD[%0d]",i), rd_val, "credit_hist_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_6: credit_hist_pipe.CFG_LDB_CQ_TIMER_THRESHOLD[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("CFG_LDB_CQ_WD_ENB[%0d]",i), rd_val, "credit_hist_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_LDB_CQ_WD_ENB[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_LDB_CQ_WD_ENB[%0d]",i), rd_val, "credit_hist_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_6: credit_hist_pipe.CFG_LDB_CQ_WD_ENB[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("CFG_LDB_CQ_TIMER_COUNT[%0d]",i), rd_val, "credit_hist_pipe");
         end//--

     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_6: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_6

//-------------------------------------
//-- backgroundcfg_access_task_7 
//-- credit_hist_pipe.CFG_DIR_CQ_INT_DEPTH_THRSH[96]     
//-- credit_hist_pipe.CFG_DIR_CQ_INT_ENB[96]              
//-- credit_hist_pipe.CFG_LDB_CQ_INT_DEPTH_THRSH[64]     
//-- credit_hist_pipe.CFG_LDB_CQ_INT_ENB[64]             
//-------------------------------------
virtual task backgroundcfg_access_task_7();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0,3); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel==0||bgsel==1) idx_limit = hqm_pkg::NUM_DIR_CQ;
     else                   idx_limit = hqm_pkg::NUM_LDB_CQ;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;   
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_7: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_DIR_CQ_INT_DEPTH_THRSH[%0d]",i), rd_val, "credit_hist_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_DIR_CQ_INT_DEPTH_THRSH[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_DIR_CQ_INT_DEPTH_THRSH[%0d]",i), rd_val, "credit_hist_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_7: credit_hist_pipe.CFG_DIR_CQ_INT_DEPTH_THRSH[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_DIR_CQ_INT_ENB[%0d]",i), rd_val, "credit_hist_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_DIR_CQ_INT_ENB[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_DIR_CQ_INT_ENB[%0d]",i), rd_val, "credit_hist_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_7: credit_hist_pipe.CFG_DIR_CQ_INT_ENB[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_LDB_CQ_INT_DEPTH_THRSH[%0d]",i), rd_val, "credit_hist_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_LDB_CQ_INT_DEPTH_THRSH[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_LDB_CQ_INT_DEPTH_THRSH[%0d]",i), rd_val, "credit_hist_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_7: credit_hist_pipe.CFG_LDB_CQ_INT_DEPTH_THRSH[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_LDB_CQ_INT_ENB[%0d]",i), rd_val, "credit_hist_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_LDB_CQ_INT_ENB[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_LDB_CQ_INT_ENB[%0d]",i), rd_val, "credit_hist_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_7: credit_hist_pipe.CFG_LDB_CQ_INT_ENB[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_7: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_7




//-------------------------------------
//-- backgroundcfg_access_task_8 
//-- aqed_pipe
//-- aqed_pipe.CFG_AQED_QID_HID_WIDTH[32]
//-- aqed_pipe.CFG_AQED_QID_FID_LIMIT[32]
//-------------------------------------
virtual task backgroundcfg_access_task_8();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 32;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     bgsel = $urandom_range (0, 1); 
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_8: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_AQED_QID_FID_LIMIT[%0d]",i), rd_val, "aqed_pipe");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_8: aqed_pipe.CFG_AQED_QID_FID_LIMIT[%0d].bgcfgrd=0x%0x", i, rd_val), OVM_MEDIUM);
            wr_val = rd_val;
            write_reg($psprintf("CFG_AQED_QID_FID_LIMIT[%0d]",i), wr_val, "aqed_pipe");
            read_reg($psprintf("CFG_AQED_QID_FID_LIMIT[%0d]",i), rd_val, "aqed_pipe");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_8: aqed_pipe.CFG_AQED_QID_FID_LIMIT[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x", i, wr_val, rd_val), OVM_MEDIUM);
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_8: aqed_pipe.CFG_AQED_QID_FID_LIMIT[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_AQED_QID_HID_WIDTH[%0d]",i), rd_val, "aqed_pipe");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_8: aqed_pipe.CFG_AQED_QID_HID_WIDTH[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x", i, wr_val, rd_val), OVM_MEDIUM);
            wr_val = rd_val;
            write_reg($psprintf("CFG_AQED_QID_HID_WIDTH[%0d]",i), wr_val, "aqed_pipe");
            read_reg($psprintf("CFG_AQED_QID_HID_WIDTH[%0d]",i), rd_val, "aqed_pipe");
                ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_8: aqed_pipe.CFG_AQED_QID_HID_WIDTH[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x", i, wr_val, rd_val), OVM_MEDIUM);
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_8: aqed_pipe.CFG_AQED_QID_HID_WIDTH[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_8: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_8


//-------------------------------------
//-- backgroundcfg_access_task_9 
//-- aqed_pipe
//-- aqed_pipe.CFG_AQED_WRD0[2048]
//-- aqed_pipe.CFG_AQED_WRD1[2048]
//-- aqed_pipe.CFG_AQED_WRD2[2048]
//-- aqed_pipe.CFG_AQED_WRD3[2048]
//-- aqed_pipe.CFG_AQED_BCAM[2048]
//-------------------------------------
virtual task backgroundcfg_access_task_9();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0,5); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 2048;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;   
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_9: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_AQED_WRD0[%0d]",i), rd_val, "aqed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_AQED_WRD1[%0d]",i), rd_val, "aqed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_AQED_WRD2[%0d]",i), rd_val, "aqed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_AQED_WRD3[%0d]",i), rd_val, "aqed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("CFG_AQED_BCAM[%0d]",i), rd_val, "aqed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("CFG_AQED_WRD0[%0d]",i), rd_val, "aqed_pipe");
            read_reg($psprintf("CFG_AQED_WRD1[%0d]",i), rd_val, "aqed_pipe");
            read_reg($psprintf("CFG_AQED_WRD2[%0d]",i), rd_val, "aqed_pipe");
            read_reg($psprintf("CFG_AQED_WRD3[%0d]",i), rd_val, "aqed_pipe");
         end//--
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_9: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_9

//-------------------------------------
//-- backgroundcfg_access_task_10 
//-- qed_pipe
//-- qed_pipe.CFG_QED0_WRD0[2048]
//-- qed_pipe.CFG_QED0_WRD1[2048]
//-- qed_pipe.CFG_QED0_WRD2[2048]
//-- qed_pipe.CFG_QED0_WRD3[2048]
//-- qed_pipe.CFG_QED1_WRD0[2048]
//-- qed_pipe.CFG_QED1_WRD1[2048]
//-- qed_pipe.CFG_QED1_WRD2[2048]
//-- qed_pipe.CFG_QED1_WRD3[2048]
//-- qed_pipe.CFG_QED2_WRD0[2048]
//-- qed_pipe.CFG_QED2_WRD1[2048]
//-- qed_pipe.CFG_QED2_WRD2[2048]
//-- qed_pipe.CFG_QED2_WRD3[2048]
//-- qed_pipe.CFG_QED3_WRD0[2048]
//-- qed_pipe.CFG_QED3_WRD1[2048]
//-- qed_pipe.CFG_QED3_WRD2[2048]
//-- qed_pipe.CFG_QED3_WRD3[2048]
//-- qed_pipe.CFG_QED4_WRD0[2048]
//-- qed_pipe.CFG_QED4_WRD1[2048]
//-- qed_pipe.CFG_QED4_WRD2[2048]
//-- qed_pipe.CFG_QED4_WRD3[2048]
//-- qed_pipe.CFG_QED5_WRD0[2048]
//-- qed_pipe.CFG_QED5_WRD1[2048]
//-- qed_pipe.CFG_QED5_WRD2[2048]
//-- qed_pipe.CFG_QED5_WRD3[2048]
//-- qed_pipe.CFG_QED6_WRD0[2048]
//-- qed_pipe.CFG_QED6_WRD1[2048]
//-- qed_pipe.CFG_QED6_WRD2[2048]
//-- qed_pipe.CFG_QED6_WRD3[2048]
//-- qed_pipe.CFG_QED7_WRD0[2048]
//-- qed_pipe.CFG_QED7_WRD1[2048]
//-- qed_pipe.CFG_QED7_WRD2[2048]
//-- qed_pipe.CFG_QED7_WRD3[2048]
//-------------------------------------
virtual task backgroundcfg_access_task_10();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;

     bgsel = $urandom_range (0, 7); 
     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 2048;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_10: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_QED0_WRD0[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED0_WRD1[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED0_WRD2[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED0_WRD3[%0d]",i), rd_val, "qed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_QED1_WRD0[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED1_WRD1[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED1_WRD2[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED1_WRD3[%0d]",i), rd_val, "qed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_QED2_WRD0[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED2_WRD1[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED2_WRD2[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED2_WRD3[%0d]",i), rd_val, "qed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_QED3_WRD0[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED3_WRD1[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED3_WRD2[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED3_WRD3[%0d]",i), rd_val, "qed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("CFG_QED4_WRD0[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED4_WRD1[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED4_WRD2[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED4_WRD3[%0d]",i), rd_val, "qed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("CFG_QED5_WRD0[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED5_WRD1[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED5_WRD2[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED5_WRD3[%0d]",i), rd_val, "qed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==6) begin  
            read_reg($psprintf("CFG_QED6_WRD0[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED6_WRD1[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED6_WRD2[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED6_WRD3[%0d]",i), rd_val, "qed_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==7) begin  
            read_reg($psprintf("CFG_QED7_WRD0[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED7_WRD1[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED7_WRD2[%0d]",i), rd_val, "qed_pipe");
            read_reg($psprintf("CFG_QED7_WRD3[%0d]",i), rd_val, "qed_pipe");
         end//--

     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_10: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_10



//-------------------------------------
//-- backgroundcfg_access_task_11 
//-- atm_pipe
//-- atm_pipe.CFG_LDB_QID_RDYLST_CLAMP[32]
//-- atm_pipe.CFG_QID_LDB_QID2CQIDIX_00[32]  -- atm_pipe.CFG_QID_LDB_QID2CQIDIX_15[32]
//-------------------------------------
virtual task backgroundcfg_access_task_11();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
     int                           idxm_min, idxm_max, idxm_len, idxm_limit;
   
     bgsel = $urandom_range (0, 8); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 32;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_11: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_LDB_QID_RDYLST_CLAMP[%0d]",i), rd_val, "atm_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_LDB_QID_RDYLST_CLAMP[%0d]",i), wr_val, "atm_pipe");
            read_reg($psprintf("CFG_LDB_QID_RDYLST_CLAMP[%0d]",i), rd_val, "atm_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_11: atm_pipe.CFG_LDB_QID_RDYLST_CLAMP[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel>0) begin  
            idxm_min=$urandom_range(0, 12); 
            idxm_max=idxm_min + 4;
            for(int j=idxm_min; j<idxm_max; j++) begin
               if(j<10) begin
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_0%0d[%0d]",j,i), rd_val, "atm_pipe");
                  wr_val = rd_val;
                  write_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_0%0d[%0d]",j,i), wr_val, "atm_pipe");
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_0%0d[%0d]",j,i), rd_val, "atm_pipe");
                  if (rd_val != wr_val) begin
                      ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_11: atm_pipe.CFG_QID_LDB_QID2CQIDIX_0%0d[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", j, i, wr_val, rd_val), OVM_MEDIUM);
                  end 
               end else begin
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_%0d[%0d]",j,i), rd_val, "atm_pipe");
                  wr_val = rd_val;
                  write_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_%0d[%0d]",j,i), wr_val, "atm_pipe");
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_%0d[%0d]",j,i), rd_val, "atm_pipe");
                  if (rd_val != wr_val) begin
                      ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_11: atm_pipe.CFG_QID_LDB_QID2CQIDIX_%0d[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", j, i, wr_val, rd_val), OVM_MEDIUM);
                  end 
               end
            end
         end//--
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_11: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_11




//-------------------------------------
//-- backgroundcfg_access_task_12 
//-- list_sel_pipe
//-- list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_00[32]  -- list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_15[32]
//-- list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_00[32] -- list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_15[32]
//-------------------------------------
virtual task backgroundcfg_access_task_12();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
     int                           idxm_min, idxm_max, idxm_len, idxm_limit;
   
     bgsel = $urandom_range (0, 15); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 32;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_12: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel>=0 && bgsel<8) begin  
            idxm_min=$urandom_range(0, 12); 
            idxm_max=idxm_min + 4;
            for(int j=idxm_min; j<idxm_max; j++) begin
               if(j<10) begin
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_0%0d[%0d]",j,i), rd_val, "list_sel_pipe");
                  wr_val = rd_val;
                  write_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_0%0d[%0d]",j,i), wr_val, "list_sel_pipe");
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_0%0d[%0d]",j,i), rd_val, "list_sel_pipe");
                  if (rd_val != wr_val) begin
                      ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_12: list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_0%0d[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", j, i, wr_val, rd_val), OVM_MEDIUM);
                  end 
               end else begin
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_%0d[%0d]",j,i), rd_val, "list_sel_pipe");
                  wr_val = rd_val;
                  write_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_%0d[%0d]",j,i), wr_val, "list_sel_pipe");
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX_%0d[%0d]",j,i), rd_val, "list_sel_pipe");
                  if (rd_val != wr_val) begin
                      ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_12: list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_%0d[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", j, i, wr_val, rd_val), OVM_MEDIUM);
                  end 
               end
            end
         end//--
         
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel>8) begin  
            idxm_min=$urandom_range(0, 12); 
            idxm_max=idxm_min + 4;
            for(int j=idxm_min; j<idxm_max; j++) begin
               if(j<10) begin
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX2_0%0d[%0d]",j,i), rd_val, "list_sel_pipe");
                  wr_val = rd_val;
                  write_reg($psprintf("CFG_QID_LDB_QID2CQIDIX2_0%0d[%0d]",j,i), wr_val, "list_sel_pipe");
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX2_0%0d[%0d]",j,i), rd_val, "list_sel_pipe");
                  if (rd_val != wr_val) begin
                      ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_12: list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_0%0d[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", j, i, wr_val, rd_val), OVM_MEDIUM);
                  end 
               end else begin
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX2_%0d[%0d]",j,i), rd_val, "list_sel_pipe");
                  wr_val = rd_val;
                  write_reg($psprintf("CFG_QID_LDB_QID2CQIDIX2_%0d[%0d]",j,i), wr_val, "list_sel_pipe");
                  read_reg($psprintf("CFG_QID_LDB_QID2CQIDIX2_%0d[%0d]",j,i), rd_val, "list_sel_pipe");
                  if (rd_val != wr_val) begin
                      ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_12: list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_%0d[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", j, i, wr_val, rd_val), OVM_MEDIUM);
                  end 
               end
            end
         end//--

     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_12: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_12


//-------------------------------------
//-- backgroundcfg_access_task_13 
//-- list_sel_pipe
//-- list_sel_pipe.CFG_DIR_QID_DPTH_THRSH[96]
//-- list_sel_pipe.CFG_ATM_QID_DPTH_THRSH[32]
//-- list_sel_pipe.CFG_NALB_QID_DPTH_THRSH[32]
//-- list_sel_pipe.CFG_QID_ATM_ACTIVE[32]
//-------------------------------------
virtual task backgroundcfg_access_task_13();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 3); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel==0) idx_limit = hqm_pkg::NUM_DIR_CQ;
     else         idx_limit = hqm_pkg::NUM_LDB_QID; 
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_13: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_DIR_QID_DPTH_THRSH[%0d]",i), rd_val, "list_sel_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_ATM_QID_DPTH_THRSH[%0d]",i), rd_val, "list_sel_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_NALB_QID_DPTH_THRSH[%0d]",i), rd_val, "list_sel_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_QID_ATM_ACTIVE[%0d]",i), rd_val, "list_sel_pipe");
         end//--

     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_13: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_13

//-------------------------------------
//-- backgroundcfg_access_task_14 
//-- list_sel_pipe whole list:
//-- list_sel_pipe.CFG_CQ2QID0[64]
//-- list_sel_pipe.CFG_CQ2QID1[64]
//-- list_sel_pipe.CFG_CQ2PRIOV[64]

//-- list_sel_pipe.CFG_QID_AQED_ACTIVE_LIMIT[32]
//-- list_sel_pipe.CFG_QID_AQED_ACTIVE_COUNT[32]
//-- list_sel_pipe.CFG_QID_LDB_REPLAY_COUNT[32]
//-- list_sel_pipe.CFG_QID_LDB_ENQUEUE_COUNT[32]
//-- list_sel_pipe.CFG_QID_LDB_INFLIGHT_LIMIT[32]
//-- list_sel_pipe.CFG_QID_LDB_INFLIGHT_COUNT[32]
//-- list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTL[32]
//-- list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTH[32]
//-- list_sel_pipe.CFG_QID_ATQ_ENQUEUE_COUNT[32]
//-- list_sel_pipe.CFG_QID_NALDB_MAX_DEPTH[32]
//-- list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTL[32]
//-- list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTH[32]
//-- list_sel_pipe.CFG_QID_ATM_ACTIVE[32]
//-- list_sel_pipe.CFG_ATM_QID_DPTH_THRSH[32]
//-- list_sel_pipe.CFG_NALB_QID_DPTH_THRSH[32]
//-- list_sel_pipe.CFG_QID_DIR_REPLAY_COUNT[32]


//-- list_sel_pipe.CFG_CQ_LDB_INFLIGHT_LIMIT[64]
//-- list_sel_pipe.CFG_CQ_LDB_INFLIGHT_COUNT[64]
//-- list_sel_pipe.CFG_CQ_LDB_TOKEN_DEPTH_SELECT[64]
//-- list_sel_pipe.CFG_CQ_LDB_TOKEN_COUNT[64]
//-- list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTL[64]
//-- list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTH[64]
//-- list_sel_pipe.CFG_CQ_LDB_DISABLE[64]
//-- list_sel_pipe.CFG_CQ_LDB_WU_COUNT[64]
//-- list_sel_pipe.CFG_CQ_LDB_WU_LIMIT[64]

//-- list_sel_pipe.CFG_QID_DIR_MAX_DEPTH[96]
//-- list_sel_pipe.CFG_QID_DIR_TOT_ENQ_CNTL[96]
//-- list_sel_pipe.CFG_QID_DIR_TOT_ENQ_CNTH[96]
//-- list_sel_pipe.CFG_QID_DIR_ENQUEUE_COUNT[96]
//-- list_sel_pipe.CFG_DIR_QID_DPTH_THRSH[96]
//-- list_sel_pipe.CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[96]
//-- list_sel_pipe.CFG_CQ_DIR_TOKEN_COUNT[96]
//-- list_sel_pipe.CFG_CQ_DIR_TOT_SCH_CNTL[96]
//-- list_sel_pipe.CFG_CQ_DIR_TOT_SCH_CNTH[96]
//-- list_sel_pipe.CFG_CQ_DIR_DISABLE[96]
//-------------------------------------
virtual task backgroundcfg_access_task_14();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 9); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = hqm_pkg::NUM_DIR_CQ;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_14: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_QID_DIR_MAX_DEPTH[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_QID_DIR_TOT_ENQ_CNTL[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_QID_DIR_TOT_ENQ_CNTH[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_QID_DIR_ENQUEUE_COUNT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("CFG_DIR_QID_DPTH_THRSH[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==6) begin  
            read_reg($psprintf("CFG_CQ_DIR_TOKEN_COUNT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==7) begin  
            read_reg($psprintf("CFG_CQ_DIR_TOT_SCH_CNTL[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==8) begin  
            read_reg($psprintf("CFG_CQ_DIR_TOT_SCH_CNTH[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==9) begin  
            read_reg($psprintf("CFG_CQ_DIR_DISABLE[%0d]",i), rd_val, "list_sel_pipe");
         end//--

     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_14: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_14




//-------------------------------------
//-- backgroundcfg_access_task_15 
//-- list_sel_pipe
//-- list_sel_pipe.CFG_CQ_LDB_INFLIGHT_LIMIT[64]
//-- list_sel_pipe.CFG_CQ_LDB_INFLIGHT_COUNT[64]
//-- list_sel_pipe.CFG_CQ_LDB_TOKEN_DEPTH_SELECT[64]
//-- list_sel_pipe.CFG_CQ_LDB_TOKEN_COUNT[64]
//-- list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTL[64]
//-- list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTH[64]
//-- list_sel_pipe.CFG_CQ_LDB_DISABLE[64]
//-- list_sel_pipe.CFG_CQ_LDB_WU_COUNT[64]
//-- list_sel_pipe.CFG_CQ_LDB_WU_LIMIT[64]
//-------------------------------------
virtual task backgroundcfg_access_task_15();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 9); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = hqm_pkg::NUM_LDB_CQ;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_15: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_CQ_LDB_INFLIGHT_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_CQ_LDB_INFLIGHT_COUNT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_CQ_LDB_TOKEN_DEPTH_SELECT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_CQ_LDB_TOKEN_COUNT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("CFG_CQ_LDB_TOT_SCH_CNTL[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("CFG_CQ_LDB_TOT_SCH_CNTH[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==6) begin  
            read_reg($psprintf("CFG_CQ_LDB_DISABLE[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==7) begin  
            read_reg($psprintf("CFG_CQ_LDB_WU_COUNT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==8) begin  
            read_reg($psprintf("CFG_CQ_LDB_WU_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==9) begin  
            read_reg($psprintf("CFG_CQ_LDB_INFLIGHT_THRESHOLD[%0d]",i), rd_val, "list_sel_pipe");
         end//--
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_15: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_15



//-------------------------------------
//-- backgroundcfg_access_task_16 
//-- list_sel_pipe
//-- list_sel_pipe.CFG_QID_AQED_ACTIVE_LIMIT[32]
//-- list_sel_pipe.CFG_QID_AQED_ACTIVE_COUNT[32]
//-- list_sel_pipe.CFG_QID_LDB_REPLAY_COUNT[32]
//-- list_sel_pipe.CFG_QID_LDB_ENQUEUE_COUNT[32]
//-- list_sel_pipe.CFG_QID_LDB_INFLIGHT_LIMIT[32]
//-- list_sel_pipe.CFG_QID_LDB_INFLIGHT_COUNT[32]
//-- list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTL[32]
//-- list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTH[32]
//-------------------------------------
virtual task backgroundcfg_access_task_16();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 7); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = hqm_pkg::NUM_LDB_QID;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_16: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_QID_AQED_ACTIVE_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_QID_AQED_ACTIVE_COUNT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_QID_LDB_REPLAY_COUNT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_QID_LDB_ENQUEUE_COUNT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("CFG_QID_LDB_INFLIGHT_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("CFG_QID_LDB_INFLIGHT_COUNT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==6) begin  
            read_reg($psprintf("CFG_QID_ATM_TOT_ENQ_CNTL[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==7) begin  
            read_reg($psprintf("CFG_QID_ATM_TOT_ENQ_CNTH[%0d]",i), rd_val, "list_sel_pipe");
         end//--
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_16: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_16



//-------------------------------------
//-- backgroundcfg_access_task_17 
//-- list_sel_pipe
//-- list_sel_pipe.CFG_QID_ATQ_ENQUEUE_COUNT[32]
//-- list_sel_pipe.CFG_QID_NALDB_MAX_DEPTH[32]
//-- list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTL[32]
//-- list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTH[32]
//-- list_sel_pipe.CFG_QID_ATM_ACTIVE[32]
//-- list_sel_pipe.CFG_ATM_QID_DPTH_THRSH[32]
//-- list_sel_pipe.CFG_NALB_QID_DPTH_THRSH[32]
//-- list_sel_pipe.CFG_QID_DIR_REPLAY_COUNT[32]
//-------------------------------------
virtual task backgroundcfg_access_task_17();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 7); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = hqm_pkg::NUM_LDB_QID;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_17: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_QID_ATQ_ENQUEUE_COUNT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_QID_NALDB_MAX_DEPTH[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_QID_NALDB_TOT_ENQ_CNTL[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_QID_NALDB_TOT_ENQ_CNTH[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("CFG_QID_ATM_ACTIVE[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("CFG_ATM_QID_DPTH_THRSH[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==6) begin  
            read_reg($psprintf("CFG_NALB_QID_DPTH_THRSH[%0d]",i), rd_val, "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==7) begin  
            read_reg($psprintf("CFG_QID_DIR_REPLAY_COUNT[%0d]",i), rd_val, "list_sel_pipe");
         end//--
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_17: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_17


//-------------------------------------
//-- backgroundcfg_access_task_18 
//-- list_sel_pipe
//-- list_sel_pipe.CFG_CQ2QID0[64]
//-- list_sel_pipe.CFG_CQ2QID1[64]
//-- list_sel_pipe.CFG_CQ2PRIOV[64]
//-------------------------------------
virtual task backgroundcfg_access_task_18();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 2); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = hqm_pkg::NUM_LDB_CQ;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_18: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_CQ2QID0[%0d]",i), rd_val, "list_sel_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_CQ2QID0[%0d]",i), wr_val, "list_sel_pipe");
            read_reg($psprintf("CFG_CQ2QID0[%0d]",i), rd_val, "list_sel_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_18: list_sel_pipe.CFG_CQ2QID0[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end 
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_CQ2QID1[%0d]",i), rd_val, "list_sel_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_CQ2QID1[%0d]",i), wr_val, "list_sel_pipe");
            read_reg($psprintf("CFG_CQ2QID1[%0d]",i), rd_val, "list_sel_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_18: list_sel_pipe.CFG_CQ2QID1[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_CQ2PRIOV[%0d]",i), rd_val, "list_sel_pipe");
            wr_val = rd_val;
            write_reg($psprintf("CFG_CQ2PRIOV[%0d]",i), wr_val, "list_sel_pipe");
            read_reg($psprintf("CFG_CQ2PRIOV[%0d]",i), rd_val, "list_sel_pipe");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_18: list_sel_pipe.CFG_CQ2PRIOV[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end

         end//--
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_18: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_18


//-------------------------------------
//-- backgroundcfg_access_task_19 
//-- reorder_pipe
//-- reorder_pipe.CFG_GRP_SN_MODE
//-- reorder_pipe.CFG_GRP_0_SLOT_SHIFT[16]
//-- reorder_pipe.CFG_GRP_1_SLOT_SHIFT[16]
//-------------------------------------
virtual task backgroundcfg_access_task_19();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 1); 
     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 16;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_19: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);

     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_GRP_0_SLOT_SHIFT[%0d]",i), rd_val, "reorder_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_GRP_1_SLOT_SHIFT[%0d]",i), rd_val, "reorder_pipe");
         end//--

         read_reg("CFG_GRP_SN_MODE", rd_val , "reorder_pipe");
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_19: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_19


//-------------------------------------
//-- backgroundcfg_access_task_20 
//-- reorder_pipe
//-- reorder_pipe.CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0[32]
//-- reorder_pipe.CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1[32]
//-------------------------------------
virtual task backgroundcfg_access_task_20();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           grprndsel, bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     grprndsel=1;
     $value$plusargs("hqmproc_bgcfg_grprnd_sel=%d", grprndsel);

     if(grprndsel==1) begin
       bgsel = $urandom_range (0, 1); 
       idx_len = 8;
       $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
       idx_limit = 32;
       $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
       idx_min = $urandom_range (0, idx_limit-idx_len); 
       idx_max = idx_min + idx_len;  
     end else begin
       bgsel = $urandom_range (0, 1); 
       $value$plusargs("hqmproc_bgcfg_grp_sel=%d", idx_len);
       idx_min = 0;
       $value$plusargs("hqmproc_bgcfg_grp_min=%d", idx_min);
       idx_max = 32;
       $value$plusargs("hqmproc_bgcfg_grp_max=%d", idx_max);
     end	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_20: Start grprndsel=%0d bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", grprndsel, bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0[%0d]",i), rd_val, "reorder_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_20_0: CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0[%0d].rd=0x%0x", i, rd_val), OVM_MEDIUM);
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1[%0d]",i), rd_val, "reorder_pipe");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_20_1: CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1[%0d].rd=0x%0x", i, rd_val), OVM_MEDIUM);
         end//--

         //read_reg("CFG_GRP_SN_MODE", rd_val , "reorder_pipe");
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_20: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_20


//-------------------------------------
//-- backgroundcfg_access_task_21 
//-- reorder_pipe
//-- reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[2048]
//-- reorder_pipe.CFG_REORDER_STATE_NALB_HP[2048]
//-- reorder_pipe.CFG_REORDER_STATE_NALB_TP[2048]
//-- reorder_pipe.CFG_REORDER_STATE_CNT[2048]
//-- reorder_pipe.CFG_REORDER_STATE_DIR_HP[2048]
//-- reorder_pipe.CFG_REORDER_STATE_DIR_TP[2048]
//-------------------------------------
virtual task backgroundcfg_access_task_21();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 5); 
     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 2048;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);
  
     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_21: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("CFG_REORDER_STATE_QID_QIDIX_CQ[%0d]",i), rd_val, "reorder_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("CFG_REORDER_STATE_NALB_HP[%0d]",i), rd_val, "reorder_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("CFG_REORDER_STATE_NALB_TP[%0d]",i), rd_val, "reorder_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("CFG_REORDER_STATE_DIR_HP[%0d]",i), rd_val, "reorder_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("CFG_REORDER_STATE_DIR_TP[%0d]",i), rd_val, "reorder_pipe");
         end//--

         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("CFG_REORDER_STATE_CNT[%0d]",i), rd_val, "reorder_pipe");
         end//--

         read_reg("CFG_GRP_SN_MODE", rd_val , "reorder_pipe");
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_21: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_21





//-------------------------------------
//-- backgroundcfg_access_task_22  non-ram registers
//-- credit_hist_pipe
//-- credit_hist_pipe.
//-- credit_hist_pipe.CFG_CHP_SMON_COMPARE0                         
//-- credit_hist_pipe.CFG_CHP_SMON_COMPARE1                         
//-- credit_hist_pipe.CFG_CHP_SMON_CONFIGURATION0                   
//-- credit_hist_pipe.CFG_CHP_SMON_CONFIGURATION1                   
//-- credit_hist_pipe.CFG_CHP_SMON_ACTIVITYCOUNTER0                 
//-- credit_hist_pipe.CFG_CHP_SMON_ACTIVITYCOUNTER1                 
//-- credit_hist_pipe.CFG_CHP_SMON_MAXIMUM_TIMER                    
//-- credit_hist_pipe.CFG_CHP_SMON_TIMER                            
//-- credit_hist_pipe.CFG_CONTROL_DIAGNOSTIC_00                     
//-- credit_hist_pipe.CFG_CONTROL_DIAGNOSTIC_01                     
//-- credit_hist_pipe.CFG_CONTROL_DIAGNOSTIC_02                     
//-- credit_hist_pipe.CFG_CONTROL_GENERAL_00                        
//-- credit_hist_pipe.CFG_CONTROL_GENERAL_01                        
//-- credit_hist_pipe.CFG_CONTROL_GENERAL_02                        
//-- credit_hist_pipe.CFG_DB_FIFO_STATUS_0                          
//-- credit_hist_pipe.CFG_DB_FIFO_STATUS_1                          
//-- credit_hist_pipe.CFG_DB_FIFO_STATUS_2                          
//-- credit_hist_pipe.CFG_DB_FIFO_STATUS_3                          
//-- credit_hist_pipe.CFG_DIAGNOSTIC_AW_STATUS_0                    
//-- credit_hist_pipe.CFG_HW_AGITATE_CONTROL                        
//-- credit_hist_pipe.CFG_HW_AGITATE_SELECT                         
//-- credit_hist_pipe.CFG_PIPE_HEALTH_HOLD                          
//-- credit_hist_pipe.CFG_PIPE_HEALTH_VALID                         
//-- credit_hist_pipe.CFG_SYNDROME_01                               
//-- credit_hist_pipe.CFG_UNIT_IDLE                                 
//-- credit_hist_pipe.CFG_UNIT_TIMEOUT                              
//-- credit_hist_pipe.CFG_PATCH_CONTROL                             
//-- credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_L                   
//-- credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_H                   
//-- credit_hist_pipe.CFG_CHP_CSR_CONTROL                           
//-- credit_hist_pipe.CFG_COUNTER_CHP_ERROR_DROP_L                  
//-- credit_hist_pipe.CFG_COUNTER_CHP_ERROR_DROP_H                  
//-- credit_hist_pipe.CFG_CHP_CNT_DIR_HCW_ENQ_L                     
//-- credit_hist_pipe.CFG_CHP_CNT_DIR_HCW_ENQ_H                     
//-- credit_hist_pipe.CFG_CHP_CNT_LDB_HCW_ENQ_L                     
//-- credit_hist_pipe.CFG_CHP_CNT_LDB_HCW_ENQ_H                     
//-- credit_hist_pipe.CFG_CHP_CNT_FRAG_REPLAYED_L                   
//-- credit_hist_pipe.CFG_CHP_CNT_FRAG_REPLAYED_H                   
//-- credit_hist_pipe.CFG_CHP_CNT_DIR_QE_SCH_L                      
//-- credit_hist_pipe.CFG_CHP_CNT_DIR_QE_SCH_H                      
//-- credit_hist_pipe.CFG_CHP_CNT_LDB_QE_SCH_L                      
//-- credit_hist_pipe.CFG_CHP_CNT_LDB_QE_SCH_H                      
//-- credit_hist_pipe.CFG_CHP_CNT_ATM_QE_SCH_L                      
//-- credit_hist_pipe.CFG_CHP_CNT_ATM_QE_SCH_H                      
//-- credit_hist_pipe.CFG_CHP_CNT_ATQ_TO_ATM_L                      
//-- credit_hist_pipe.CFG_CHP_CNT_ATQ_TO_ATM_H                      
//-- credit_hist_pipe.CFG_DIR_CQ_INTR_ARMED0                        
//-- credit_hist_pipe.CFG_DIR_CQ_INTR_ARMED1                        
//-- credit_hist_pipe.CFG_DIR_CQ_INTR_EXPIRED0                      
//-- credit_hist_pipe.CFG_DIR_CQ_INTR_EXPIRED1                      
//-- credit_hist_pipe.CFG_DIR_CQ_INTR_IRQ0                          
//-- credit_hist_pipe.CFG_DIR_CQ_INTR_IRQ1                          
//-- credit_hist_pipe.CFG_DIR_CQ_INTR_RUN_TIMER0                    
//-- credit_hist_pipe.CFG_DIR_CQ_INTR_RUN_TIMER1                    
//-- credit_hist_pipe.CFG_DIR_CQ_INTR_URGENT0                       
//-- credit_hist_pipe.CFG_DIR_CQ_INTR_URGENT1                       
//-- credit_hist_pipe.CFG_DIR_CQ_TIMER_CTL                          
//-- credit_hist_pipe.CFG_DIR_WDTO_0                                
//-- credit_hist_pipe.CFG_DIR_WDTO_1                                
//-- credit_hist_pipe.CFG_DIR_WDRT_0                                
//-- credit_hist_pipe.CFG_DIR_WDRT_1                                
//-- credit_hist_pipe.CFG_DIR_WD_DISABLE0                           
//-- credit_hist_pipe.CFG_DIR_WD_DISABLE1                           
//-- credit_hist_pipe.CFG_DIR_WD_ENB_INTERVAL                       
//-- credit_hist_pipe.CFG_DIR_WD_IRQ0                               
//-- credit_hist_pipe.CFG_DIR_WD_IRQ1                               
//-- credit_hist_pipe.CFG_DIR_WD_THRESHOLD                          
//-- credit_hist_pipe.CFG_LDB_CQ_INTR_ARMED0                        
//-- credit_hist_pipe.CFG_LDB_CQ_INTR_ARMED1                        
//-- credit_hist_pipe.CFG_LDB_CQ_INTR_EXPIRED0                      
//-- credit_hist_pipe.CFG_LDB_CQ_INTR_EXPIRED1                      
//-- credit_hist_pipe.CFG_LDB_CQ_INTR_IRQ0                          
//-- credit_hist_pipe.CFG_LDB_CQ_INTR_IRQ1                          
//-- credit_hist_pipe.CFG_LDB_CQ_INTR_RUN_TIMER0                    
//-- credit_hist_pipe.CFG_LDB_CQ_INTR_RUN_TIMER1                    
//-- credit_hist_pipe.CFG_LDB_CQ_INTR_URGENT0                       
//-- credit_hist_pipe.CFG_LDB_CQ_INTR_URGENT1                       
//-- credit_hist_pipe.CFG_LDB_CQ_TIMER_CTL                          
//-- credit_hist_pipe.CFG_LDB_WDTO_0                                
//-- credit_hist_pipe.CFG_LDB_WDTO_1                                
//-- credit_hist_pipe.CFG_LDB_WDRT_0                                
//-- credit_hist_pipe.CFG_LDB_WDRT_1                                
//-- credit_hist_pipe.CFG_LDB_WD_DISABLE0                           
//-- credit_hist_pipe.CFG_LDB_WD_DISABLE1                           
//-- credit_hist_pipe.CFG_LDB_WD_ENB_INTERVAL                       
//-- credit_hist_pipe.CFG_LDB_WD_IRQ0                               
//-- credit_hist_pipe.CFG_LDB_WD_IRQ1                               
//-- credit_hist_pipe.CFG_LDB_WD_THRESHOLD                          
//-- credit_hist_pipe.CFG_RETN_ZERO                                 
//-- credit_hist_pipe.CFG_SYNDROME_00                               
//-- credit_hist_pipe.CFG_UNIT_VERSION                              
//-------------------------------------
virtual task backgroundcfg_access_task_22();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 9); 
     idx_len = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_22: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg("CFG_CHP_SMON_COMPARE0", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_SMON_COMPARE1", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_SMON_CONFIGURATION0", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_SMON_CONFIGURATION1", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_SMON_ACTIVITYCOUNTER0", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_SMON_ACTIVITYCOUNTER1", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_SMON_MAXIMUM_TIMER", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_SMON_TIMER", rd_val , "credit_hist_pipe");
            read_reg("CFG_CONTROL_DIAGNOSTIC_00", rd_val , "credit_hist_pipe");
            read_reg("CFG_CONTROL_DIAGNOSTIC_01", rd_val , "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg("CFG_CONTROL_DIAGNOSTIC_02", rd_val , "credit_hist_pipe");
            read_reg("CFG_CONTROL_GENERAL_00", rd_val , "credit_hist_pipe");
            read_reg("CFG_CONTROL_GENERAL_01", rd_val , "credit_hist_pipe");
            read_reg("CFG_CONTROL_GENERAL_02", rd_val , "credit_hist_pipe");
            read_reg("CFG_DB_FIFO_STATUS_0", rd_val , "credit_hist_pipe");
            read_reg("CFG_DB_FIFO_STATUS_1", rd_val , "credit_hist_pipe");
            read_reg("CFG_DB_FIFO_STATUS_2", rd_val , "credit_hist_pipe");
            read_reg("CFG_DB_FIFO_STATUS_3", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS_0", rd_val , "credit_hist_pipe");
            read_reg("CFG_HW_AGITATE_CONTROL", rd_val , "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg("CFG_HW_AGITATE_SELECT", rd_val , "credit_hist_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD", rd_val , "credit_hist_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID", rd_val , "credit_hist_pipe");
            read_reg("CFG_SYNDROME_01", rd_val , "credit_hist_pipe");
            read_reg("CFG_UNIT_IDLE", rd_val , "credit_hist_pipe");
            read_reg("CFG_UNIT_TIMEOUT", rd_val , "credit_hist_pipe");
            read_reg("CFG_PATCH_CONTROL", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CORRECTIBLE_COUNT_L", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CORRECTIBLE_COUNT_H", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CSR_CONTROL", rd_val , "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg("CFG_COUNTER_CHP_ERROR_DROP_L", rd_val , "credit_hist_pipe");
            read_reg("CFG_COUNTER_CHP_ERROR_DROP_H", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_DIR_HCW_ENQ_L", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_DIR_HCW_ENQ_H", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_LDB_HCW_ENQ_L", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_LDB_HCW_ENQ_H", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_FRAG_REPLAYED_L", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_FRAG_REPLAYED_H", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_DIR_QE_SCH_L", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_DIR_QE_SCH_H", rd_val , "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg("CFG_CHP_CNT_LDB_QE_SCH_L", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_LDB_QE_SCH_H", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_ATM_QE_SCH_L", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_ATM_QE_SCH_H", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_ATQ_TO_ATM_L", rd_val , "credit_hist_pipe");
            read_reg("CFG_CHP_CNT_ATQ_TO_ATM_H", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_CQ_INTR_ARMED0", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_CQ_INTR_ARMED1", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_CQ_INTR_EXPIRED0", rd_val , "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg("CFG_DIR_CQ_INTR_EXPIRED1", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_CQ_INTR_IRQ0", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_CQ_INTR_IRQ1", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_CQ_INTR_RUN_TIMER0", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_CQ_INTR_RUN_TIMER1", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_CQ_INTR_URGENT0", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_CQ_INTR_URGENT1", rd_val , "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==6) begin  
            read_reg("CFG_DIR_CQ_TIMER_CTL", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_WDTO_0", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_WDTO_1", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_WDRT_0", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_WDRT_1", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_WD_DISABLE0", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_WD_DISABLE1", rd_val , "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==7) begin  
            read_reg("CFG_DIR_WD_ENB_INTERVAL", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_WD_IRQ0", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_WD_IRQ1", rd_val , "credit_hist_pipe");
            read_reg("CFG_DIR_WD_THRESHOLD", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_CQ_INTR_ARMED0", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_CQ_INTR_ARMED1", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_CQ_INTR_EXPIRED0", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_CQ_INTR_EXPIRED1", rd_val , "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==8) begin  
            read_reg("CFG_LDB_CQ_INTR_IRQ0", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_CQ_INTR_IRQ1", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_CQ_INTR_RUN_TIMER0", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_CQ_INTR_RUN_TIMER1", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_CQ_INTR_URGENT0", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_CQ_INTR_URGENT1", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_CQ_TIMER_CTL", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_WDTO_0", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_WDTO_1", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_WDRT_0", rd_val , "credit_hist_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==9) begin  
            read_reg("CFG_LDB_WDRT_1", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_WD_DISABLE0", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_WD_DISABLE1", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_WD_ENB_INTERVAL", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_WD_IRQ0", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_WD_IRQ1", rd_val , "credit_hist_pipe");
            read_reg("CFG_LDB_WD_THRESHOLD", rd_val , "credit_hist_pipe");
            read_reg("CFG_RETN_ZERO", rd_val , "credit_hist_pipe");
            read_reg("CFG_SYNDROME_00", rd_val , "credit_hist_pipe");
            read_reg("CFG_UNIT_VERSION", rd_val , "credit_hist_pipe");
         end//--
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_22: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_22




//-------------------------------------
//-- backgroundcfg_access_task_23  non-ram registers
//-- list_sel_pipe
//-------------------------------------
virtual task backgroundcfg_access_task_23();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 11); 
     idx_len = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_23: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg("CFG_CONTROL_GENERAL_0", rd_val , "list_sel_pipe");
            read_reg("CFG_CONTROL_GENERAL_1", rd_val , "list_sel_pipe");
            read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val , "list_sel_pipe");
            //read_reg("CFG_COUNTER_ENQ_ATQ", rd_val , "list_sel_pipe");
            //read_reg("CFG_COUNTER_ENQ_DIR", rd_val , "list_sel_pipe");
            //read_reg("CFG_COUNTER_ENQ_DIR_RPLY", rd_val , "list_sel_pipe");
            //read_reg("CFG_COUNTER_ENQ_LDB_RPLY", rd_val , "list_sel_pipe");
            //read_reg("CFG_COUNTER_ENQ_UNOORD", rd_val , "list_sel_pipe");
            //read_reg("CFG_COUNTER_SCH_ATQ", rd_val , "list_sel_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS", rd_val , "list_sel_pipe");
            read_reg("CFG_DIAGNOSTIC_STATUS_0", rd_val , "list_sel_pipe");             
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg("CFG_ERROR_INJECT", rd_val , "list_sel_pipe");
            read_reg("CFG_HW_AGITATE_CONTROL", rd_val , "list_sel_pipe");
            read_reg("CFG_HW_AGITATE_SELECT", rd_val , "list_sel_pipe");
            read_reg("CFG_INTERFACE_STATUS", rd_val , "list_sel_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD_00", rd_val , "list_sel_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD_01", rd_val , "list_sel_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID_00", rd_val , "list_sel_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID_01", rd_val , "list_sel_pipe");
            read_reg("CFG_SMON0_COMPARE0", rd_val , "list_sel_pipe");
            read_reg("CFG_SMON0_COMPARE1", rd_val , "list_sel_pipe");
            read_reg("CFG_SMON0_CONFIGURATION0", rd_val , "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg("CFG_SMON0_CONFIGURATION1", rd_val , "list_sel_pipe");
            read_reg("CFG_SMON0_ACTIVITYCOUNTER0", rd_val , "list_sel_pipe");
            read_reg("CFG_SMON0_ACTIVITYCOUNTER1", rd_val , "list_sel_pipe");
            read_reg("CFG_SMON0_MAXIMUM_TIMER", rd_val , "list_sel_pipe");
            read_reg("CFG_SMON0_TIMER", rd_val , "list_sel_pipe");
            read_reg("CFG_SYNDROME_HW", rd_val , "list_sel_pipe");
            read_reg("CFG_UNIT_IDLE", rd_val , "list_sel_pipe");
            read_reg("CFG_UNIT_TIMEOUT", rd_val , "list_sel_pipe");
            read_reg("CFG_PATCH_CONTROL", rd_val , "list_sel_pipe");
            read_reg("CFG_AQED_TOT_ENQUEUE_COUNT", rd_val , "list_sel_pipe");
            read_reg("CFG_AQED_TOT_ENQUEUE_LIMIT", rd_val , "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
             read_reg("CFG_ARB_WEIGHT_ATM_NALB_QID_0", rd_val , "list_sel_pipe");
            read_reg("CFG_ARB_WEIGHT_ATM_NALB_QID_1", rd_val , "list_sel_pipe");
            read_reg("CFG_ARB_WEIGHT_LDB_ISSUE_0", rd_val , "list_sel_pipe");
            read_reg("CFG_ARB_WEIGHT_LDB_QID_0", rd_val , "list_sel_pipe");
            read_reg("CFG_ARB_WEIGHT_LDB_QID_1", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_TOT_INFLIGHT_COUNT", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_TOT_INFLIGHT_LIMIT", rd_val , "list_sel_pipe");
            read_reg("CFG_FID_INFLIGHT_LIMIT", rd_val , "list_sel_pipe");
            read_reg("CFG_FID_INFLIGHT_COUNT", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_CONTROL", rd_val , "list_sel_pipe");
            read_reg("CFG_LSP_CSR_CONTROL", rd_val , "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg("CFG_LSP_PERF_DIR_SCH_COUNT_L", rd_val , "list_sel_pipe");
            read_reg("CFG_LSP_PERF_DIR_SCH_COUNT_H", rd_val , "list_sel_pipe");
            read_reg("CFG_LSP_PERF_LDB_SCH_COUNT_L", rd_val , "list_sel_pipe");
            read_reg("CFG_LSP_PERF_LDB_SCH_COUNT_H", rd_val , "list_sel_pipe");
            read_reg("CFG_SYNDROME_SW", rd_val , "list_sel_pipe");
            read_reg("CFG_UNIT_VERSION", rd_val , "list_sel_pipe");
            read_reg("CFG_COS_CTRL", rd_val , "list_sel_pipe");
            read_reg("CFG_CREDIT_SAT_COS0", rd_val , "list_sel_pipe");
            read_reg("CFG_CREDIT_SAT_COS1", rd_val , "list_sel_pipe");
            read_reg("CFG_CREDIT_SAT_COS2", rd_val , "list_sel_pipe");
            read_reg("CFG_CREDIT_SAT_COS3", rd_val , "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg("CFG_CREDIT_CNT_COS0", rd_val , "list_sel_pipe");
            read_reg("CFG_CREDIT_CNT_COS1", rd_val , "list_sel_pipe");
            read_reg("CFG_CREDIT_CNT_COS2", rd_val , "list_sel_pipe");
            read_reg("CFG_CREDIT_CNT_COS3", rd_val , "list_sel_pipe");
            read_reg("CFG_SHDW_CTRL", rd_val , "list_sel_pipe");
            read_reg("CFG_SHDW_RANGE_COS0", rd_val , "list_sel_pipe");
            read_reg("CFG_SHDW_RANGE_COS1", rd_val , "list_sel_pipe");
            read_reg("CFG_SHDW_RANGE_COS2", rd_val , "list_sel_pipe");
            read_reg("CFG_SHDW_RANGE_COS3", rd_val , "list_sel_pipe");
            read_reg("CFG_SCH_RDY_L", rd_val , "list_sel_pipe");
            read_reg("CFG_SCH_RDY_H", rd_val , "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==6) begin  
            read_reg("CFG_SCHD_COS0_L", rd_val , "list_sel_pipe");
            read_reg("CFG_SCHD_COS0_H", rd_val , "list_sel_pipe");
            read_reg("CFG_SCHD_COS1_L", rd_val , "list_sel_pipe");
            read_reg("CFG_SCHD_COS1_H", rd_val , "list_sel_pipe");
            read_reg("CFG_SCHD_COS2_L", rd_val , "list_sel_pipe");
            read_reg("CFG_SCHD_COS2_H", rd_val , "list_sel_pipe");
            read_reg("CFG_SCHD_COS3_L", rd_val , "list_sel_pipe");
            read_reg("CFG_SCHD_COS3_H", rd_val , "list_sel_pipe");
            read_reg("CFG_RDY_COS0_L", rd_val , "list_sel_pipe");
            read_reg("CFG_RDY_COS0_H", rd_val , "list_sel_pipe");
            read_reg("CFG_RDY_COS1_L", rd_val , "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==7) begin  
            read_reg("CFG_RDY_COS1_H", rd_val , "list_sel_pipe");
            read_reg("CFG_RDY_COS2_L", rd_val , "list_sel_pipe");
            read_reg("CFG_RDY_COS2_H", rd_val , "list_sel_pipe");
            read_reg("CFG_RDY_COS3_L", rd_val , "list_sel_pipe");
            read_reg("CFG_RDY_COS3_H", rd_val , "list_sel_pipe");
            read_reg("CFG_RND_LOSS_COS0_L", rd_val , "list_sel_pipe");
            read_reg("CFG_RND_LOSS_COS0_H", rd_val , "list_sel_pipe");
            read_reg("CFG_RND_LOSS_COS1_L", rd_val , "list_sel_pipe");
            read_reg("CFG_RND_LOSS_COS1_H", rd_val , "list_sel_pipe");
            read_reg("CFG_RND_LOSS_COS2_L", rd_val , "list_sel_pipe");
            read_reg("CFG_RND_LOSS_COS2_H", rd_val , "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==8) begin  
            read_reg("CFG_RND_LOSS_COS3_L", rd_val , "list_sel_pipe");
            read_reg("CFG_RND_LOSS_COS3_H", rd_val , "list_sel_pipe");
            read_reg("CFG_CNT_WIN_COS0_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CNT_WIN_COS0_H", rd_val , "list_sel_pipe");
            read_reg("CFG_CNT_WIN_COS1_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CNT_WIN_COS1_H", rd_val , "list_sel_pipe");
            read_reg("CFG_CNT_WIN_COS2_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CNT_WIN_COS2_H", rd_val , "list_sel_pipe");
            read_reg("CFG_CNT_WIN_COS3_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CNT_WIN_COS3_H", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_0_L", rd_val , "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==9) begin  
            read_reg("CFG_LDB_SCHED_PERF_0_H", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_1_L", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_1_H", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_2_L", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_2_H", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_3_L", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_3_H", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_4_L", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_4_H", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_5_L", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_5_H", rd_val , "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==10) begin  
            read_reg("CFG_LDB_SCHED_PERF_6_L", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_6_H", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_7_L", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_7_H", rd_val , "list_sel_pipe");
            read_reg("CFG_LDB_SCHED_PERF_CONTROL", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H", rd_val , "list_sel_pipe");
         end//--
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==11) begin  
             read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L", rd_val , "list_sel_pipe");
            read_reg("CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H", rd_val , "list_sel_pipe");
            read_reg("CFG_CONTROL_SCHED_SLOT_COUNT", rd_val , "list_sel_pipe");
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_23: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_23


//-------------------------------------
//-- backgroundcfg_access_task_24  non-ram registers
//-- atm_pipe
//--   atm_pipe.CFG_CONTROL_ARB_WEIGHTS_READY_BIN 
//--   atm_pipe.CFG_CONTROL_ARB_WEIGHTS_SCHED_BIN
//
//-------------------------------------
virtual task backgroundcfg_access_task_24();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 3); 
     idx_len = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_24: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg("CFG_CONTROL_GENERAL", rd_val , "atm_pipe");
            read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val , "atm_pipe");
            read_reg("CFG_DETECT_FEATURE_OPERATION_00", rd_val , "atm_pipe");
            read_reg("CFG_DETECT_FEATURE_OPERATION_01", rd_val , "atm_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS", rd_val , "atm_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS_01", rd_val , "atm_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS_02", rd_val , "atm_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS_03", rd_val , "atm_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val , "atm_pipe");
            read_reg("CFG_FIFO_WMSTAT_AP_AQED_IF", rd_val , "atm_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg("CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF", rd_val , "atm_pipe");
            read_reg("CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF", rd_val , "atm_pipe");
            read_reg("CFG_HW_AGITATE_CONTROL", rd_val , "atm_pipe");
            read_reg("CFG_HW_AGITATE_SELECT", rd_val , "atm_pipe");
            read_reg("CFG_INTERFACE_STATUS", rd_val , "atm_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD_00", rd_val , "atm_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID_00", rd_val , "atm_pipe");
            read_reg("CFG_SMON_ACTIVITYCOUNTER0", rd_val , "atm_pipe");
            read_reg("CFG_SMON_ACTIVITYCOUNTER1", rd_val , "atm_pipe");
            read_reg("CFG_SMON_COMPARE0", rd_val , "atm_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg("CFG_SMON_COMPARE1", rd_val , "atm_pipe");
            read_reg("CFG_SMON_CONFIGURATION0", rd_val , "atm_pipe");
            read_reg("CFG_SMON_CONFIGURATION1", rd_val , "atm_pipe");
            read_reg("CFG_SMON_MAXIMUM_TIMER", rd_val , "atm_pipe");
            read_reg("CFG_SMON_TIMER", rd_val , "atm_pipe");
            read_reg("CFG_SYNDROME_00", rd_val , "atm_pipe");
            read_reg("CFG_SYNDROME_01", rd_val , "atm_pipe");
            read_reg("CFG_UNIT_IDLE", rd_val , "atm_pipe");
            read_reg("CFG_UNIT_TIMEOUT", rd_val , "atm_pipe");
            read_reg("CFG_PATCH_CONTROL", rd_val , "atm_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg("CFG_AP_CSR_CONTROL", rd_val , "atm_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_READY_BIN", rd_val , "atm_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_SCHED_BIN", rd_val , "atm_pipe");
            read_reg("CFG_UNIT_VERSION", rd_val , "atm_pipe");
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_24: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_24


//-------------------------------------
//-- backgroundcfg_access_task_25  non-ram registers
//-- aqed_pipe 
//-------------------------------------
virtual task backgroundcfg_access_task_25();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 3); 
     idx_len = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_25: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg("CFG_CONTROL_GENERAL", rd_val , "aqed_pipe");
            read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val , "aqed_pipe");
            read_reg("CFG_DETECT_FEATURE_OPERATION_00", rd_val , "aqed_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS", rd_val , "aqed_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS_01", rd_val , "aqed_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS_02", rd_val , "aqed_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val , "aqed_pipe");
            read_reg("CFG_FIFO_WMSTAT_AP_AQED_IF", rd_val , "aqed_pipe");
            read_reg("CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF", rd_val , "aqed_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg("CFG_FIFO_WMSTAT_FREELIST_RETURN", rd_val , "aqed_pipe");
            read_reg("CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF", rd_val , "aqed_pipe");
            read_reg("CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF", rd_val , "aqed_pipe");
            read_reg("CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF", rd_val , "aqed_pipe");
            read_reg("CFG_HW_AGITATE_CONTROL", rd_val , "aqed_pipe");
            read_reg("CFG_HW_AGITATE_SELECT", rd_val , "aqed_pipe");
            read_reg("CFG_INTERFACE_STATUS", rd_val , "aqed_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD", rd_val , "aqed_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID", rd_val , "aqed_pipe");
            read_reg("CFG_SMON_ACTIVITYCOUNTER0", rd_val , "aqed_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg("CFG_SMON_ACTIVITYCOUNTER1", rd_val , "aqed_pipe");
            read_reg("CFG_SMON_COMPARE0", rd_val , "aqed_pipe");
            read_reg("CFG_SMON_COMPARE1", rd_val , "aqed_pipe");
            read_reg("CFG_SMON_CONFIGURATION0", rd_val , "aqed_pipe");
            read_reg("CFG_SMON_CONFIGURATION1", rd_val , "aqed_pipe");
            read_reg("CFG_SMON_MAXIMUM_TIMER", rd_val , "aqed_pipe");
            read_reg("CFG_SMON_TIMER", rd_val , "aqed_pipe");
            read_reg("CFG_SYNDROME_00", rd_val , "aqed_pipe");
            read_reg("CFG_SYNDROME_01", rd_val , "aqed_pipe");
            read_reg("CFG_UNIT_IDLE", rd_val , "aqed_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg("CFG_UNIT_TIMEOUT", rd_val , "aqed_pipe");
            read_reg("CFG_PATCH_CONTROL", rd_val , "aqed_pipe");
            read_reg("CFG_AQED_CSR_CONTROL", rd_val , "aqed_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_0", rd_val , "aqed_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_1", rd_val , "aqed_pipe");
            read_reg("CFG_UNIT_VERSION", rd_val , "aqed_pipe");         
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_25: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_25


//-------------------------------------
//-- backgroundcfg_access_task_26  non-ram registers
//--  direct_pipe
//-------------------------------------
virtual task backgroundcfg_access_task_26();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 3); 
     idx_len = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_26: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin 
            read_reg("CFG_CONTROL_GENERAL", rd_val , "direct_pipe");
            read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val , "direct_pipe");
            read_reg("CFG_DETECT_FEATURE_OPERATION_00", rd_val , "direct_pipe");
            read_reg("CFG_DETECT_FEATURE_OPERATION_01", rd_val , "direct_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS", rd_val , "direct_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS_01", rd_val , "direct_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS_02", rd_val , "direct_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val , "direct_pipe");
            read_reg("CFG_FIFO_WMSTAT_DP_DQED_IF", rd_val , "direct_pipe");
            read_reg("CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF", rd_val , "direct_pipe"); 
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg("CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF", rd_val , "direct_pipe");
            read_reg("CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF", rd_val , "direct_pipe");
            read_reg("CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF", rd_val , "direct_pipe");
            read_reg("CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF", rd_val , "direct_pipe");
            read_reg("CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF", rd_val , "direct_pipe");
            read_reg("CFG_HW_AGITATE_CONTROL", rd_val , "direct_pipe");
            read_reg("CFG_HW_AGITATE_SELECT", rd_val , "direct_pipe");
            read_reg("CFG_INTERFACE_STATUS", rd_val , "direct_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD_00", rd_val , "direct_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID_00", rd_val , "direct_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg("CFG_SMON_ACTIVITYCOUNTER0", rd_val , "direct_pipe");
            read_reg("CFG_SMON_ACTIVITYCOUNTER1", rd_val , "direct_pipe");
            read_reg("CFG_SMON_COMPARE0", rd_val , "direct_pipe");
            read_reg("CFG_SMON_COMPARE1", rd_val , "direct_pipe");
            read_reg("CFG_SMON_CONFIGURATION0", rd_val , "direct_pipe");
            read_reg("CFG_SMON_CONFIGURATION1", rd_val , "direct_pipe");
            read_reg("CFG_SMON_MAXIMUM_TIMER", rd_val , "direct_pipe");
            read_reg("CFG_SMON_TIMER", rd_val , "direct_pipe");
            read_reg("CFG_SYNDROME_00", rd_val , "direct_pipe");
            read_reg("CFG_SYNDROME_01", rd_val , "direct_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin 
            read_reg("CFG_UNIT_IDLE", rd_val , "direct_pipe");
            read_reg("CFG_UNIT_TIMEOUT", rd_val , "direct_pipe");
            read_reg("CFG_PATCH_CONTROL", rd_val , "direct_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0", rd_val , "direct_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1", rd_val , "direct_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0", rd_val , "direct_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1", rd_val , "direct_pipe");
            read_reg("CFG_DIR_CSR_CONTROL", rd_val , "direct_pipe");
            read_reg("CFG_UNIT_VERSION", rd_val , "direct_pipe");
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_26: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_26


//-------------------------------------
//-- backgroundcfg_access_task_27  non-ram registers
//-- nalb_pipe 
//-------------------------------------
virtual task backgroundcfg_access_task_27();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 3); 
     idx_len = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_27: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg("CFG_CONTROL_GENERAL", rd_val , "nalb_pipe");
            read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val , "nalb_pipe");
            read_reg("CFG_DETECT_FEATURE_OPERATION_00", rd_val , "nalb_pipe");
            read_reg("CFG_DETECT_FEATURE_OPERATION_01", rd_val , "nalb_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS", rd_val , "nalb_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS_01", rd_val , "nalb_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS_02", rd_val , "nalb_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val , "nalb_pipe");
            read_reg("CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF", rd_val , "nalb_pipe");
            read_reg("CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF", rd_val , "nalb_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg("CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF", rd_val , "nalb_pipe");
            read_reg("CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF", rd_val , "nalb_pipe");
            read_reg("CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF", rd_val , "nalb_pipe");
            read_reg("CFG_FIFO_WMSTAT_NALB_QED_IF", rd_val , "nalb_pipe");
            read_reg("CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF", rd_val , "nalb_pipe");
            read_reg("CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF", rd_val , "nalb_pipe");
            read_reg("CFG_HW_AGITATE_CONTROL", rd_val , "nalb_pipe");
            read_reg("CFG_HW_AGITATE_SELECT", rd_val , "nalb_pipe");
            read_reg("CFG_INTERFACE_STATUS", rd_val , "nalb_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD_00", rd_val , "nalb_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg("CFG_PIPE_HEALTH_HOLD_01", rd_val , "nalb_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID_00", rd_val , "nalb_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID_01", rd_val , "nalb_pipe");
            read_reg("CFG_SMON_ACTIVITYCOUNTER0", rd_val , "nalb_pipe");
            read_reg("CFG_SMON_ACTIVITYCOUNTER1", rd_val , "nalb_pipe");
            read_reg("CFG_SMON_COMPARE0", rd_val , "nalb_pipe");
            read_reg("CFG_SMON_COMPARE1", rd_val , "nalb_pipe");
            read_reg("CFG_SMON_CONFIGURATION0", rd_val , "nalb_pipe");
            read_reg("CFG_SMON_CONFIGURATION1", rd_val , "nalb_pipe");
            read_reg("CFG_SMON_MAXIMUM_TIMER", rd_val , "nalb_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg("CFG_SMON_TIMER", rd_val , "nalb_pipe");
            read_reg("CFG_SYNDROME_00", rd_val , "nalb_pipe");
            read_reg("CFG_SYNDROME_01", rd_val , "nalb_pipe");
            read_reg("CFG_UNIT_IDLE", rd_val , "nalb_pipe");
            read_reg("CFG_UNIT_TIMEOUT", rd_val , "nalb_pipe");
            read_reg("CFG_PATCH_CONTROL", rd_val , "nalb_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_0", rd_val , "nalb_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_1", rd_val , "nalb_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_0", rd_val , "nalb_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_1", rd_val , "nalb_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0", rd_val , "nalb_pipe");
            read_reg("CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1", rd_val , "nalb_pipe");
            read_reg("CFG_NALB_CSR_CONTROL", rd_val , "nalb_pipe");
            read_reg("CFG_UNIT_VERSION", rd_val , "nalb_pipe");
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_27: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_27

//-------------------------------------
//-- backgroundcfg_access_task_28  non-ram registers
//-- qed_pipe 
//-------------------------------------
virtual task backgroundcfg_access_task_28();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 3); 
     idx_len = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_28: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg("CFG_CONTROL_GENERAL", rd_val , "qed_pipe");
            read_reg("CFG_CONTROL_PIPELINE_CREDITS", rd_val , "qed_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS", rd_val , "qed_pipe");
            read_reg("CFG_ERROR_INJECT", rd_val , "qed_pipe");
            read_reg("CFG_HW_AGITATE_CONTROL", rd_val , "qed_pipe");
            read_reg("CFG_HW_AGITATE_SELECT", rd_val , "qed_pipe");
            read_reg("CFG_INTERFACE_STATUS", rd_val , "qed_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD", rd_val , "qed_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID", rd_val , "qed_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg("CFG_SMON_ACTIVITYCOUNTER0", rd_val , "qed_pipe");
            read_reg("CFG_SMON_ACTIVITYCOUNTER1", rd_val , "qed_pipe");
            read_reg("CFG_SMON_COMPARE0", rd_val , "qed_pipe");
            read_reg("CFG_SMON_COMPARE1", rd_val , "qed_pipe");
            read_reg("CFG_SMON_CONFIGURATION0", rd_val , "qed_pipe");
            read_reg("CFG_SMON_CONFIGURATION1", rd_val , "qed_pipe");
            read_reg("CFG_SMON_MAXIMUM_TIMER", rd_val , "qed_pipe");
            read_reg("CFG_SMON_TIMER", rd_val , "qed_pipe");
            read_reg("CFG_SYNDROME_00", rd_val , "qed_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg("CFG_UNIT_IDLE", rd_val , "qed_pipe");
            read_reg("CFG_UNIT_TIMEOUT", rd_val , "qed_pipe");
            read_reg("CFG_PATCH_CONTROL", rd_val , "qed_pipe");
            read_reg("CFG_QED_CSR_CONTROL", rd_val , "qed_pipe");
            read_reg("CFG_UNIT_VERSION", rd_val , "qed_pipe");
            read_reg("CFG_2RDY1ISS_L", rd_val , "qed_pipe");
            read_reg("CFG_2RDY1ISS_H", rd_val , "qed_pipe");
            read_reg("CFG_2RDY2ISS_L", rd_val , "qed_pipe");
            read_reg("CFG_2RDY2ISS_H", rd_val , "qed_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg("CFG_3RDY1ISS_L", rd_val , "qed_pipe");
            read_reg("CFG_3RDY1ISS_H", rd_val , "qed_pipe");
            read_reg("CFG_3RDY2ISS_L", rd_val , "qed_pipe");
            read_reg("CFG_3RDY2ISS_H", rd_val , "qed_pipe");
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_28: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_28

//-------------------------------------
//-- backgroundcfg_access_task_29  non-ram registers
//--  reorder_pipe
//-------------------------------------
virtual task backgroundcfg_access_task_29();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 3); 
     idx_len = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_29: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg("CFG_CONTROL_GENERAL_0", rd_val , "reorder_pipe");
            read_reg("CFG_DIAGNOSTIC_AW_STATUS", rd_val , "reorder_pipe");
            read_reg("CFG_FIFO_WMSTAT_CHP_ROP_HCW", rd_val , "reorder_pipe");
            read_reg("CFG_FIFO_WMSTAT_DIR_RPLY_REQ", rd_val , "reorder_pipe");
            read_reg("CFG_FIFO_WMSTAT_LDB_RPLY_REQ", rd_val , "reorder_pipe");
            read_reg("CFG_FIFO_WMSTAT_LSP_REORDERCMP", rd_val , "reorder_pipe");
            read_reg("CFG_FIFO_WMSTAT_SN_COMPLETE", rd_val , "reorder_pipe");
            read_reg("CFG_FIFO_WMSTAT_SN_ORDERED", rd_val , "reorder_pipe");
            read_reg("CFG_FRAG_INTEGRITY_COUNT", rd_val , "reorder_pipe");
            read_reg("CFG_HW_AGITATE_CONTROL", rd_val , "reorder_pipe");           
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg("CFG_HW_AGITATE_SELECT", rd_val , "reorder_pipe");
            read_reg("CFG_INTERFACE_STATUS", rd_val , "reorder_pipe");
            read_reg("CFG_SMON_ACTIVITYCOUNTER0", rd_val , "reorder_pipe");
            read_reg("CFG_SMON_ACTIVITYCOUNTER1", rd_val , "reorder_pipe");
            read_reg("CFG_SMON_COMPARE0", rd_val , "reorder_pipe");
            read_reg("CFG_SMON_COMPARE1", rd_val , "reorder_pipe");
            read_reg("CFG_SMON_CONFIGURATION0", rd_val , "reorder_pipe");
            read_reg("CFG_SMON_CONFIGURATION1", rd_val , "reorder_pipe");
            read_reg("CFG_SMON_MAXIMUM_TIMER", rd_val , "reorder_pipe");
            read_reg("CFG_SMON_TIMER", rd_val , "reorder_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg("CFG_PIPE_HEALTH_HOLD_GRP0", rd_val , "reorder_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD_GRP1", rd_val , "reorder_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD_ROP_DP", rd_val , "reorder_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP", rd_val , "reorder_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD_ROP_NALB", rd_val , "reorder_pipe");
            read_reg("CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED", rd_val , "reorder_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID_GRP0", rd_val , "reorder_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID_GRP1", rd_val , "reorder_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID_ROP_DP", rd_val , "reorder_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP", rd_val , "reorder_pipe");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg("CFG_PIPE_HEALTH_VALID_ROP_NALB", rd_val , "reorder_pipe");
            read_reg("CFG_PIPE_HEALTH_VALID_ROP_QED_DQED", rd_val , "reorder_pipe");
            read_reg("CFG_SERIALIZER_STATUS", rd_val , "reorder_pipe");
            read_reg("CFG_SYNDROME_00", rd_val , "reorder_pipe");
            read_reg("CFG_SYNDROME_01", rd_val , "reorder_pipe");
            read_reg("CFG_UNIT_IDLE", rd_val , "reorder_pipe");
            read_reg("CFG_UNIT_TIMEOUT", rd_val , "reorder_pipe");
            read_reg("CFG_PATCH_CONTROL", rd_val , "reorder_pipe");
            read_reg("CFG_GRP_SN_MODE", rd_val , "reorder_pipe");
            read_reg("CFG_ROP_CSR_CONTROL", rd_val , "reorder_pipe");
            read_reg("CFG_UNIT_VERSION", rd_val , "reorder_pipe");
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_29: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_29



//-------------------------------------
//-- backgroundcfg_access_task_30  
//-- hqm_system_csr 
//-------------------------------------
virtual task backgroundcfg_access_task_30();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 5); 
     idx_len = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_30: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg("INGRESS_ALARM_ENABLE", rd_val , "hqm_system_csr");
            read_reg("ALARM_LUT_PERR", rd_val , "hqm_system_csr");
            read_reg("EGRESS_LUT_ERR", rd_val , "hqm_system_csr");
            read_reg("INGRESS_LUT_ERR", rd_val , "hqm_system_csr");
            read_reg("ALARM_ERR", rd_val , "hqm_system_csr");
            read_reg("ALARM_MB_ECC_ERR", rd_val , "hqm_system_csr");
            read_reg("ALARM_SB_ECC_ERR", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_CTL", rd_val , "hqm_system_csr");
            read_reg("MSIX_ACK", rd_val , "hqm_system_csr");
            read_reg("MSIX_PASSTHROUGH", rd_val , "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg("MSIX_MODE", rd_val , "hqm_system_csr");
            read_reg("MSIX_31_0_SYND", rd_val , "hqm_system_csr");
            read_reg("MSIX_63_32_SYND", rd_val , "hqm_system_csr");
            read_reg("MSIX_64_SYND", rd_val , "hqm_system_csr");
            read_reg("MSIX_PBA_31_0_CLEAR", rd_val , "hqm_system_csr");
            read_reg("MSIX_PBA_63_32_CLEAR", rd_val , "hqm_system_csr");
            read_reg("MSIX_PBA_64_CLEAR", rd_val , "hqm_system_csr");
            read_reg("DIR_CQ_31_0_OCC_INT_STATUS", rd_val , "hqm_system_csr");
            read_reg("DIR_CQ_63_32_OCC_INT_STATUS", rd_val , "hqm_system_csr");
//            read_reg("DIR_CQ_95_64_OCC_INT_STATUS", rd_val , "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg("LDB_CQ_31_0_OCC_INT_STATUS", rd_val , "hqm_system_csr");
            read_reg("LDB_CQ_63_32_OCC_INT_STATUS", rd_val , "hqm_system_csr");
           //-- read_reg("DIR_CQ_OPT_CLR", rd_val , "hqm_system_csr");
            read_reg("ALARM_HW_SYND", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_0", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_1", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_2", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_3", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_4", rd_val , "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg("HQM_SYSTEM_CNT_5", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_6", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_7", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_8", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_9", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_10", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_11", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_12", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_13", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_14", rd_val , "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg("HQM_SYSTEM_CNT_15", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_16", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_17", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_18", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_19", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_20", rd_val , "hqm_system_csr");
            read_reg("HQM_SYSTEM_CNT_21", rd_val , "hqm_system_csr");
            read_reg("SBE_CNT_0", rd_val , "hqm_system_csr");
            read_reg("SBE_CNT_1", rd_val , "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg("HCW_ENQ_FIFO_STATUS", rd_val , "hqm_system_csr");
            read_reg("HCW_SCH_FIFO_STATUS", rd_val , "hqm_system_csr");
            read_reg("SCH_OUT_FIFO_STATUS", rd_val , "hqm_system_csr");
            read_reg("CFG_RX_FIFO_STATUS", rd_val , "hqm_system_csr");
            read_reg("CWDI_RX_FIFO_STATUS", rd_val , "hqm_system_csr");
            read_reg("HQM_ALARM_RX_FIFO_STATUS", rd_val , "hqm_system_csr");
            read_reg("SIF_ALARM_FIFO_STATUS", rd_val , "hqm_system_csr");
            //read_reg("CFG_SYS_PERF_SMON", rd_val , "hqm_system_csr");
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_30: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_30

//-------------------------------------
//-- backgroundcfg_access_task_31  
//-- hqm_system_csr 
//-------------------------------------
virtual task backgroundcfg_access_task_31();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 5); 
     idx_len = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_31: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg("WB_SCH_OUT_AFULL_AGITATE_CONTROL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("IG_HCW_ENQ_AFULL_AGITATE_CONTROL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("IG_HCW_ENQ_W_DB_AGITATE_CONTROL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("EG_HCW_SCHED_DB_AGITATE_CONTROL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("AL_CWD_ALARM_DB_AGITATE_CONTROL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("AL_SIF_ALARM_AFULL_AGITATE_CONTROL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("AL_HQM_ALARM_DB_AGITATE_CONTROL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("ECC_CTL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("PARITY_CTL", rd_val , "hqm_system_csr");   // FEATURE
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg("WRITE_BUFFER_CTL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("ALARM_CTL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("CFG_PATCH_CONTROL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("INGRESS_CTL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("EGRESS_CTL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("SYS_IDLE_STATUS", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("SYS_ALARM_INT_ENABLE", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("SYS_ALARM_MB_ECC_INT_ENABLE", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("SYS_ALARM_SB_ECC_INT_ENABLE", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("HCW_ENQ_FIFO_CTL", rd_val , "hqm_system_csr");   // FEATURE
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg("SCH_OUT_FIFO_CTL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("SIF_ALARM_FIFO_CTL", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("ALARM_DB_STATUS", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("INGRESS_DB_STATUS", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("EGRESS_DB_STATUS", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("ALARM_STATUS", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("INGRESS_STATUS", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("EGRESS_STATUS", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("WBUF_STATUS", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("WBUF_STATUS2", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("WBUF_DEBUG", rd_val , "hqm_system_csr");   // FEATURE
            read_reg("HCW_REQ_DEBUG", rd_val , "hqm_system_csr");   // FEATURE 
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg("ALARM_PF_SYND0", rd_val , "hqm_system_csr");    
            read_reg("ALARM_PF_SYND1", rd_val , "hqm_system_csr");    
            read_reg("ALARM_PF_SYND2", rd_val , "hqm_system_csr");    
            read_reg("PERF_SMON_CONFIGURATION0", rd_val , "hqm_system_csr");    
            read_reg("PERF_SMON_CONFIGURATION1", rd_val , "hqm_system_csr");    
            read_reg("PERF_SMON_COMPARE0", rd_val , "hqm_system_csr");    
            read_reg("PERF_SMON_COMPARE1", rd_val , "hqm_system_csr");    
            read_reg("PERF_SMON_ACTIVITYCOUNTER0", rd_val , "hqm_system_csr");    
            read_reg("PERF_SMON_ACTIVITYCOUNTER1", rd_val , "hqm_system_csr");    
            read_reg("PERF_SMON_TIMER", rd_val , "hqm_system_csr");    
            read_reg("PERF_SMON_MAXIMUM_TIMER", rd_val , "hqm_system_csr");    
            read_reg("PERF_SMON_COMP_MASK0", rd_val , "hqm_system_csr");    
            read_reg("PERF_SMON_COMP_MASK1", rd_val , "hqm_system_csr");    
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg("AW_SMON_CONFIGURATION0[0]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_CONFIGURATION1[0]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_COMPARE0[0]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_COMPARE1[0]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_ACTIVITYCOUNTER0[0]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_ACTIVITYCOUNTER1[0]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_TIMER[0]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_MAXIMUM_TIMER[0]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_COMP_MASK0[0]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_COMP_MASK1[0]", rd_val , "hqm_system_csr");    

            read_reg("AW_SMON_CONFIGURATION0[1]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_CONFIGURATION1[1]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_COMPARE0[1]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_COMPARE1[1]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_ACTIVITYCOUNTER0[1]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_ACTIVITYCOUNTER1[1]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_TIMER[1]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_MAXIMUM_TIMER[1]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_COMP_MASK0[1]", rd_val , "hqm_system_csr");    
            read_reg("AW_SMON_COMP_MASK1[1]", rd_val , "hqm_system_csr");    
         end//--	
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_31: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_31

//-------------------------------------
//-- backgroundcfg_access_task_32  
//-- hqm_system_csr 
//-- hqm_system_csr.ALARM_VF_SYND0[16] 
//-- hqm_system_csr.ALARM_VF_SYND1[16] 
//-- hqm_system_csr.ALARM_VF_SYND2[16]  
//-- hqm_system_csr.DIR_VASQID_V[2048] 
//-- hqm_system_csr.LDB_VASQID_V[1024] 
//-------------------------------------
virtual task backgroundcfg_access_task_32();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 4); 

     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel==4)             idx_limit = 1024;
     else if(bgsel==3)        idx_limit = 2048;
     else                     idx_limit = 16;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_32: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("ALARM_VF_SYND0[%0d]",i), rd_val, "hqm_system_csr");
	    wr_val = $urandom_range (0, 32'h7fff_ffff); //--Valid(bit31) has to be 0
            write_reg($psprintf("ALARM_VF_SYND0[%0d]",i), wr_val, "hqm_system_csr");
            read_reg($psprintf("ALARM_VF_SYND0[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("ALARM_VF_SYND1[%0d]",i), rd_val, "hqm_system_csr");
	    wr_val = $urandom_range (0, 32'h7fff_ffff); //--Valid(bit31) has to be 0
            write_reg($psprintf("ALARM_VF_SYND1[%0d]",i), wr_val, "hqm_system_csr");
            read_reg($psprintf("ALARM_VF_SYND1[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("ALARM_VF_SYND2[%0d]",i), rd_val, "hqm_system_csr");
	    wr_val = $urandom_range (0, 32'h7fff_ffff); //--Valid(bit31) has to be 0
            write_reg($psprintf("ALARM_VF_SYND2[%0d]",i), wr_val, "hqm_system_csr");
            read_reg($psprintf("ALARM_VF_SYND2[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("DIR_VASQID_V[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("LDB_VASQID_V[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_32: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_32


//-------------------------------------
//-- backgroundcfg_access_task_33  
//-- hqm_system_csr 
//-- hqm_system_csr.DIR_CQ2VF_PF_RO[96] 
//-- hqm_system_csr.DIR_CQ_ADDR_L[96] 
//-- hqm_system_csr.DIR_CQ_ADDR_U[96] 
//-- hqm_system_csr.AI_ADDR_L[128] 
//-- hqm_system_csr.AI_ADDR_U[128] 
//-- hqm_system_csr.AI_DATA[128] 
//-- hqm_system_csr.AI_CTRL[128] 
//-- hqm_system_csr.DIR_CQ_FMT[96] 
//-- hqm_system_csr.DIR_CQ_ISR[96] 
//-- hqm_system_csr.DIR_CQ_PASID[96] 
//-- hqm_system_csr.DIR_PP_V[96] 
//-- hqm_system_csr.DIR_PP2VAS[96] 
//-- hqm_system_csr.HQM_DIR_PP2VDEV[96] 
//-- hqm_system_csr.WB_DIR_CQ_STATE[96] 
//-- hqm_system_csr.DIR_QID_ITS[96] 
//-------------------------------------
virtual task backgroundcfg_access_task_33();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 14); 
     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel<4)  idx_limit = hqm_pkg::NUM_DIR_CQ + hqm_pkg::NUM_LDB_CQ;
     else         idx_limit = hqm_pkg::NUM_DIR_CQ;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_33: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("AI_ADDR_L[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("AI_ADDR_L[%0d]",i), rd_val, "hqm_system_csr");
         end//--	
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("AI_DATA[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         //-- 03182021 IMS structure fix: added AI_CTRL
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("AI_CTRL[%0d]",i), rd_val, "hqm_system_csr");
         end//--	

         //-----------------
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("DIR_CQ2VF_PF_RO[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("DIR_CQ_ADDR_L[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==6) begin  
            read_reg($psprintf("DIR_CQ_ADDR_U[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         	 


         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==7) begin  
            read_reg($psprintf("DIR_CQ_FMT[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==8) begin  
            read_reg($psprintf("DIR_CQ_ISR[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==9) begin  
            read_reg($psprintf("DIR_CQ_PASID[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==10) begin  
            read_reg($psprintf("DIR_PP2VAS[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==11) begin  
            read_reg($psprintf("DIR_PP_V[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==12) begin  
            read_reg($psprintf("HQM_DIR_PP2VDEV[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==13) begin  
            read_reg($psprintf("WB_DIR_CQ_STATE[%0d]",i), rd_val, "hqm_system_csr");
         end//--	
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==14) begin  
            read_reg($psprintf("DIR_QID_ITS[%0d]",i), rd_val, "hqm_system_csr");
         end//--	
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_33: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_33

//-------------------------------------
//-- backgroundcfg_access_task_34  
//-- hqm_system_csr 
//-- hqm_system_csr.LDB_QID_V[32]    
//-- hqm_system_csr.LDB_QID_ITS[32]  
//-- hqm_system_csr.LDB_QID_CFG_V[32] 
//-- hqm_system_csr.LDB_QID2VQID[32] 
//-------------------------------------
virtual task backgroundcfg_access_task_34();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 3); 
     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 32;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_34: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("LDB_QID_V[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("LDB_QID_ITS[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("LDB_QID_CFG_V[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("LDB_QID2VQID[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_34: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_34


//-------------------------------------
//-- backgroundcfg_access_task_35  
//-- hqm_system_csr 
//-- hqm_system_csr.LDB_CQ_ADDR_L[64]    
//-- hqm_system_csr.LDB_CQ_ADDR_U[64]   
//-- hqm_system_csr.LDB_PP2VAS[64]       
//-- hqm_system_csr.HQM_LDB_PP2VDEV[64]  
//-- hqm_system_csr.LDB_PP_V[64]         
//-- hqm_system_csr.LDB_CQ2VF_PF_RO[64]  
//-- hqm_system_csr.LDB_CQ_ISR[64]       
//-- hqm_system_csr.LDB_CQ_PASID[64]     
//-- hqm_system_csr.AI_ADDR_L[128] 
//-- hqm_system_csr.AI_ADDR_U[128] 
//-- hqm_system_csr.AI_DATA[128]   
//-- hqm_system_csr.AI_CTRL[128]   
//-- hqm_system_csr.WB_LDB_CQ_STATE[64]   
//-------------------------------------
virtual task backgroundcfg_access_task_35();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 12); 
     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel<4) idx_limit = 128;
     else        idx_limit = 64;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_35: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("AI_ADDR_L[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("AI_ADDR_U[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("AI_DATA[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 

         //-- 03182021 IMS structure fix: added AI_CTRL
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("AI_CTRL[%0d]",i), rd_val, "hqm_system_csr");
         end//--

         //--------------------------------------
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("LDB_CQ_ADDR_L[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("LDB_CQ_ADDR_U[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==6) begin  
            read_reg($psprintf("LDB_PP2VAS[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==7) begin  
            read_reg($psprintf("HQM_LDB_PP2VDEV[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==8) begin  
            read_reg($psprintf("LDB_PP_V[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==9) begin  
            read_reg($psprintf("LDB_CQ2VF_PF_RO[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==10) begin  
            read_reg($psprintf("LDB_CQ_ISR[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==11) begin  
            read_reg($psprintf("LDB_CQ_PASID[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==12) begin  
            read_reg($psprintf("WB_LDB_CQ_STATE[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_35: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_35


//-------------------------------------
//-- backgroundcfg_access_task_36  
//-- hqm_system_csr 
//-- hqm_system_csr.VF_LDB_VQID2QID[512] 
//-- hqm_system_csr.VF_LDB_VQID_V[512]  
//-- hqm_system_csr.VF_DIR_VQID2QID[1024]
//-- hqm_system_csr.VF_DIR_VQID_V[1024]  
//-- hqm_system_csr.VF_LDB_VPP2PP[1024]  
//-- hqm_system_csr.VF_LDB_VPP_V[1024]   
//-- hqm_system_csr.VF_DIR_VPP2PP[1024]  
//-- hqm_system_csr.VF_DIR_VPP_V[1024]   
//-------------------------------------
virtual task backgroundcfg_access_task_36();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 7); 
     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel<2)             idx_limit = 512;
     else                    idx_limit = 1024;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_36: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("VF_LDB_VQID2QID[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("VF_LDB_VQID_V[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("VF_DIR_VQID2QID[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("VF_DIR_VQID_V[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  
            read_reg($psprintf("VF_LDB_VPP2PP[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==5) begin  
            read_reg($psprintf("VF_LDB_VPP_V[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==6) begin  
            read_reg($psprintf("VF_DIR_VPP2PP[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==7) begin  
            read_reg($psprintf("VF_DIR_VPP_V[%0d]",i), rd_val, "hqm_system_csr");
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_36: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_36


//-------------------------------------
//-- backgroundcfg_access_task_37  
//-- hqm_msix_mem 
//-- hqm_msix_mem.MSG_ADDR_L[64]  
//-- hqm_msix_mem.MSG_ADDR_U[64]  
//-- hqm_msix_mem.MSG_DATA[64]  
//-- hqm_msix_mem.VECTOR_CTRL[64]  
//-------------------------------------
virtual task backgroundcfg_access_task_37();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 3); 
     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 64;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_37: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
       if($test$plusargs("hqmproc_bgcfg_msix_wrrdbg") && i_hqm_cfg.msix_cfg[i].enable==0) begin	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("MSG_ADDR_L[%0d]",i), rd_val, "hqm_msix_mem");
            wr_val =  $urandom_range (0, 32'hffff_ffff); 
            write_reg($psprintf("MSG_ADDR_L[%0d]",i), wr_val, "hqm_msix_mem");
            read_reg($psprintf("MSG_ADDR_L[%0d]",i), rd_val, "hqm_msix_mem");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_37: hqm_msix_mem.MSG_ADDR_L[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("MSG_ADDR_U[%0d]",i), rd_val, "hqm_msix_mem");
            wr_val =  $urandom_range (0, 32'hffff_ffff); 
            write_reg($psprintf("MSG_ADDR_U[%0d]",i), wr_val, "hqm_msix_mem");
            read_reg($psprintf("MSG_ADDR_U[%0d]",i), rd_val, "hqm_msix_mem");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_37: hqm_msix_mem.MSG_ADDR_U[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end

         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("MSG_DATA[%0d]",i), rd_val, "hqm_msix_mem");
            wr_val =  $urandom_range (0, 32'hffff_ffff); 
            write_reg($psprintf("MSG_DATA[%0d]",i), wr_val, "hqm_msix_mem");
            read_reg($psprintf("MSG_DATA[%0d]",i), rd_val, "hqm_msix_mem");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_37: hqm_msix_mem.MSG_DATA[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end

         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("VECTOR_CTRL[%0d]",i), rd_val, "hqm_msix_mem");
            wr_val =  $urandom_range (0, 32'hffff_ffff); 
            write_reg($psprintf("VECTOR_CTRL[%0d]",i), wr_val, "hqm_msix_mem");
            read_reg($psprintf("VECTOR_CTRL[%0d]",i), rd_val, "hqm_msix_mem");
            if (rd_val != wr_val) begin
                ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_37: hqm_msix_mem.VECTOR_CTRL[%0d].bgcfgwr=0x%0x bgcfgrd=0x%0x mismatched", i, wr_val, rd_val), OVM_MEDIUM);
            end
         end//--	
       end else begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("MSG_ADDR_L[%0d]",i), rd_val, "hqm_msix_mem");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("MSG_ADDR_U[%0d]",i), rd_val, "hqm_msix_mem");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  
            read_reg($psprintf("MSG_DATA[%0d]",i), rd_val, "hqm_msix_mem");
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  
            read_reg($psprintf("VECTOR_CTRL[%0d]",i), rd_val, "hqm_msix_mem");
         end//--	 
       end
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_37: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_37




//-------------------------------------
//-- backgroundcfg_access_task_38  
//-- hqm_system_csr 
//-- hqm_system_csr.WB_DIR_CQ_STATE[96] 
//-- hqm_system_csr.WB_LDB_CQ_STATE[64]   
//-------------------------------------
virtual task backgroundcfg_access_task_38();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 1); 
     idx_len = 16;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel==0) idx_limit = hqm_pkg::NUM_DIR_CQ;
     else         idx_limit = hqm_pkg::NUM_LDB_CQ;

     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_38: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=0; i<16; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("WB_DIR_CQ_STATE[%0d]",i), rd_val, "hqm_system_csr");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_38: hqm_system_csr.WB_DIR_CQ_STATE[%0d].bgcfgrd=0x%0x ", i, rd_val), OVM_MEDIUM);
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("WB_LDB_CQ_STATE[%0d]",i), rd_val, "hqm_system_csr");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_38: hqm_system_csr.WB_LDB_CQ_STATE[%0d].bgcfgrd=0x%0x ", i, rd_val), OVM_MEDIUM);
         end//--	 
     end//--for 

     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  
            read_reg($psprintf("WB_DIR_CQ_STATE[%0d]",i), rd_val, "hqm_system_csr");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_38: hqm_system_csr.WB_DIR_CQ_STATE[%0d].bgcfgrd=0x%0x ", i, rd_val), OVM_MEDIUM);
         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  
            read_reg($psprintf("WB_LDB_CQ_STATE[%0d]",i), rd_val, "hqm_system_csr");
            ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_38: hqm_system_csr.WB_LDB_CQ_STATE[%0d].bgcfgrd=0x%0x ", i, rd_val), OVM_MEDIUM);
         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_38: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_38

//-------------------------------------
//-- backgroundcfg_access_task_39  
//-- hqm_system_csr 
//-- hqm_system_csr.  
//-------------------------------------
virtual task backgroundcfg_access_task_39();
     sla_status_t                  status;
     sla_ral_access_path_t         primary_id="apb_sequencer", access;

     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 3); 
     idx_len = 8;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     if(bgsel==0) idx_limit = 64;
     if(bgsel==1) idx_limit = 16;
     if(bgsel==2) idx_limit = 64;
     if(bgsel==3) idx_limit = 16;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_39: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_39: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_39



//-------------------------------------
//-- backgroundcfg_access_task_40  
//-- hqm_system_csr 
//-- hqm_system_csr.  
//-------------------------------------
virtual task backgroundcfg_access_task_40();
     int qididx;
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];       			
     intr_transaction              wditem;
     int                           cqid_tmp;
     int                           bgsel, idx_min, idx_max, idx_len, idx_limit;
   
     bgsel = $urandom_range (0, 4); 
     idx_len = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_len=%d", idx_len);
     idx_limit = 1;
     $value$plusargs("hqmproc_bgcfg_memacc_limit=%d", idx_limit);

     idx_min = $urandom_range (0, idx_limit-idx_len); 
     idx_max = idx_min + idx_len;      	

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_40: Start bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
     //-----------------------------
     //--
     //-----------------------------
     for(int i=idx_min; i<idx_max; i++) begin
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==0) begin  

         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==1) begin  

         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==2) begin  

         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==3) begin  

         end//--	 
         if((i_hqm_cfg.hqmproc_trfctrl == 1 && i_hqm_cfg.hqmproc_trfctrl_0 != 2) && bgsel==4) begin  

         end//--	 
     end//--for 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_backgroundcfg_access_task_40: Done bgsel=%0d idx_min=%0d idx_max=%0d idx_len=%0d idx_limit=%0d", bgsel, idx_min, idx_max, idx_len, idx_limit), OVM_MEDIUM);
endtask : backgroundcfg_access_task_40





//---------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
//--                 EOT Check Tasks used in HQMV2 hqm_proc TB
//---------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-- traffic_unit_idle_check_task
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
task traffic_unit_idle_check_task(int has_wait, int unitidle_poll_cnt, int has_expect_idle, int has_report);
     while(i_hqm_cfg.hqmproc_trfctrl_2 == 0 && has_wait==1) begin  
              wait_idle (10) ;		        
     end

     if ($test$plusargs("HQM_BYPASS_UNIT_IDLE_CHECK") || $test$plusargs("HQM_BACKGROUND_CFG_GEN_SEQ") || $test$plusargs("hqmproc_bgcfg_enable")) begin
         has_report = 0; //--turn off report when there are bgcfg
     end

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_traffic_unit_idle_check_task: hqmproc_trfctrl_2=%0d; Start with unitidle_poll_cnt=%0d has_expect_idle=%0d has_report=%0d", i_hqm_cfg.hqmproc_trfctrl_2, unitidle_poll_cnt, has_expect_idle, has_report), OVM_LOW);

     wait_unit_idle_task(unitidle_poll_cnt, has_expect_idle, has_report); 

endtask: traffic_unit_idle_check_task


//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-- wait_unit_idle_task
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
task wait_unit_idle_task(int unitidle_poll_cnt, int has_expect_idle, int has_report);
  int unitidel_state;
  int tbeotck_timeout_cnt;

     tbeotck_timeout_cnt=0;
     i_hqm_cfg.hqmproc_trfctrl_0 = 2; //--disable bgcfg access when it's doing unit idle check
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_wait_unit_idle_task: Start unitidle_poll_cnt=%0d has_expect_idle=%0d has_report=%0d, set i_hqm_cfg.hqmproc_trfctrl_0=2 to disable bgcfg access", unitidle_poll_cnt, has_expect_idle, has_report), OVM_LOW);
     check_unit_idle_task(has_expect_idle, 0, unitidel_state); 

     while (unitidel_state != has_expect_idle) begin
              wait_idle (100) ;		        
              check_unit_idle_task(has_expect_idle, 0, unitidel_state); 	//--has_report=0 when polling
              tbeotck_timeout_cnt ++;
	      
              if(tbeotck_timeout_cnt>unitidle_poll_cnt) begin
                  if(has_report) begin 
                     ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_wait_unit_idle_task: timeout with unit_idle unitidel_state=%0d, has_expect_idle=%0d, tbeotck_timeout_cnt=%0d exceed unitidle_poll_cnt=%0d",unitidel_state,has_expect_idle,tbeotck_timeout_cnt, unitidle_poll_cnt), OVM_LOW);
                  end else begin
                     ovm_report_warning(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_wait_unit_idle_task: timeout with unit_idle unitidel_state=%0d, has_expect_idle=%0d, tbeotck_timeout_cnt=%0d exceed unitidle_poll_cnt=%0d",unitidel_state,has_expect_idle,tbeotck_timeout_cnt, unitidle_poll_cnt), OVM_LOW);
                  end
                  break;	         
              end 	      	      	      
     end	
     check_unit_idle_task(has_expect_idle, has_report, unitidel_state); 	
     i_hqm_cfg.hqmproc_trfctrl_0 = 0; //--enable bgcfg access when it's doing unit idle check
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_wait_unit_idle_task: Done unitidel_state=%0d, reset i_hqm_cfg.hqmproc_trfctrl_0=0 to allow bgcfg access", unitidel_state), OVM_LOW);
endtask: wait_unit_idle_task

//-------------------------------------------------------------------------
//-- cqirq_mask_wait_unit_idle_task
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
task cqirq_mask_wait_unit_idle_task(int unitidle_poll_cnt, int has_expect_idle, int has_report);
  int unitidel_state;
  int tb_timeout_cnt;
     tb_timeout_cnt=0; 
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cqirq_mask_wait_unit_idle_task: Start unitidle_poll_cnt=%0d has_expect_idle=%0d has_report=%0d", unitidle_poll_cnt, has_expect_idle, has_report), OVM_LOW);
     check_unit_idle_task(has_expect_idle, 0, unitidel_state); 

     while (unitidel_state != has_expect_idle) begin
              wait_idle (100) ;		        
              check_unit_idle_task(has_expect_idle, 0, unitidel_state); 	//--has_report=0 when polling
              tb_timeout_cnt ++;
	      
              if(tb_timeout_cnt>unitidle_poll_cnt) begin
                  if(has_report) begin 
                     ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cqirq_mask_wait_unit_idle_task: timeout with unit_idle unitidel_state=%0d, has_expect_idle=%0d, tb_timeout_cnt=%0d exceed unitidle_poll_cnt=%0d",unitidel_state,has_expect_idle,tb_timeout_cnt, unitidle_poll_cnt), OVM_LOW);
                  end else begin
                     ovm_report_warning(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cqirq_mask_wait_unit_idle_task: timeout with unit_idle unitidel_state=%0d, has_expect_idle=%0d, tb_timeout_cnt=%0d exceed unitidle_poll_cnt=%0d",unitidel_state,has_expect_idle,tb_timeout_cnt, unitidle_poll_cnt), OVM_LOW);
                  end
                  break;	         
              end 	      	      	      
     end	
     check_unit_idle_task(has_expect_idle, has_report, unitidel_state); 	
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cqirq_mask_wait_unit_idle_task: Done unitidel_state=%0d, reset i_hqm_cfg.hqmproc_trfctrl_0=0 to allow bgcfg access", unitidel_state), OVM_LOW);
endtask: cqirq_mask_wait_unit_idle_task


//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-- check_unit_idle_task
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
task check_unit_idle_task(bit expidle, int has_report, output bit idlestate);

       sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];

/*-- 
        list_sel_pipe_regs.CFG_UNIT_IDLE.read(status, rd_val, primary_id, this);
        ovm_report_info(get_full_name(),$psprintf("HQMCORE_EOT_SEQ000_Check_unitidle: Read list_sel_pipe_regs.CFG_UNIT_IDLE = 0x%08x", rd_val), OVM_LOW);
        dp_regs.CFG_UNIT_IDLE.read(status, rd_val, primary_id, this);
        ovm_report_info(get_full_name(),$psprintf("HQMCORE_EOT_SEQ000_Check_unitidle: Read dp_regs.CFG_UNIT_IDLE = 0x%08x", rd_val), OVM_LOW);
        dqed_regs.CFG_UNIT_IDLE.read(status, rd_val, primary_id, this);
        ovm_report_info(get_full_name(),$psprintf("HQMCORE_EOT_SEQ000_Check_unitidle: Read dqed_regs.CFG_UNIT_IDLE = 0x%08x", rd_val), OVM_LOW);
        qed_regs.CFG_UNIT_IDLE.read(status, rd_val, primary_id, this);
        ovm_report_info(get_full_name(),$psprintf("HQMCORE_EOT_SEQ000_Check_unitidle: Read qed_regs.CFG_UNIT_IDLE = 0x%08x", rd_val), OVM_LOW);
        nalb_regs.CFG_UNIT_IDLE.read(status, rd_val, primary_id, this);
        ovm_report_info(get_full_name(),$psprintf("HQMCORE_EOT_SEQ000_Check_unitidle: Read nalb_regs.CFG_UNIT_IDLE = 0x%08x", rd_val), OVM_LOW);
        atm_pipe_regs.CFG_UNIT_IDLE.read(status, rd_val, primary_id, this);
        ovm_report_info(get_full_name(),$psprintf("HQMCORE_EOT_SEQ000_Check_unitidle: Read atm_pipe_regs.CFG_UNIT_IDLE = 0x%08x", rd_val), OVM_LOW);
        aqed_regs.CFG_UNIT_IDLE.read(status, rd_val, primary_id, this);
        ovm_report_info(get_full_name(),$psprintf("HQMCORE_EOT_SEQ000_Check_unitidle: Read aqed_regs.CFG_UNIT_IDLE = 0x%08x", rd_val), OVM_LOW);
        rop_regs.CFG_UNIT_IDLE.read(status, rd_val, primary_id, this);
        ovm_report_info(get_full_name(),$psprintf("HQMCORE_EOT_SEQ000_Check_unitidle: Read rop_regs.CFG_UNIT_IDLE = 0x%08x", rd_val), OVM_LOW);
        chp_regs.CFG_UNIT_IDLE.read(status, rd_val, primary_id, this);
        ovm_report_info(get_full_name(),$psprintf("HQMCORE_EOT_SEQ000_Check_unitidle: Read chp_regs.CFG_UNIT_IDLE = 0x%08x", rd_val), OVM_LOW);

--*/
// SYS_UNIT_IDLE[19:19]
// AQED_UNIT_IDLE[18:18]
// DQED_UNIT_IDLE[17:17]
// QED_UNIT_IDLE[16:16]
// DP_UNIT_IDLE[15:15]
// AP_UNIT_IDLE[14:14]
// NALB_UNIT_IDLE[13:13]
// LSP_UNIT_IDLE[12:12]
// ROP_UNIT_IDLE[11:11]
// CHP_UNIT_IDLE[10:10]
// SYS_PIPEIDLE[9:9]
// AQED_PIPEIDLE[8:8]
// DQED_PIPEIDLE[7:7]
// QED_PIPEIDLE[6:6]
// DP_PIPEIDLE[5:5]
// AP_PIPEIDLE[4:4]
// NALB_PIPEIDLE[3:3]
// LSP_PIPEIDLE[2:2]
// ROP_PIPEIDLE[1:1]
// CHP_PIPEIDLE[0:0]

      read_reg("CFG_DIAGNOSTIC_IDLE_STATUS", rd_val , "config_master");
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_Check_unitidle_expidle=%0d(0:expect active; 1: expect idle): config_master.CFG_DIAGNOSTIC_IDLE_STATUS.rd=0x%0x", expidle, rd_val), OVM_LOW); 


      if(expidle==0) begin
         if(rd_val[19:0] == 20'hfffff) begin
            if(has_report) begin
               ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_Check_unitidle_expidle=%0d(0:expect active; 1: expect idle): config_master.CFG_DIAGNOSTIC_IDLE_STATUS.rd=0x%0x", expidle, rd_val), OVM_LOW); 
            end else begin
               ovm_report_warning(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_Check_unitidle_expidle=%0d(0:expect active; 1: expect idle): config_master.CFG_DIAGNOSTIC_IDLE_STATUS.rd=0x%0x", expidle, rd_val), OVM_LOW); 
            end
         end
      end else begin
          if(rd_val[19:0] != 20'hfffff) begin
            if(has_report) begin
               ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_Check_unitidle_expactive=%0d(0:expect active; 1: expect idle): config_master.CFG_DIAGNOSTIC_IDLE_STATUS.rd=0x%0x", expidle, rd_val), OVM_LOW); 
            end else begin
               ovm_report_warning(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_Check_unitidle_expactive=%0d(0:expect active; 1: expect idle): config_master.CFG_DIAGNOSTIC_IDLE_STATUS.rd=0x%0x", expidle, rd_val), OVM_LOW); 
            end
          end
      end

      if(rd_val[19:0] == 20'hfffff)
           idlestate = 1;
      else
           idlestate = 0;
      ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_Check_unitidle_expidle=%0d(0:expect active; 1: expect idle): get idlestate=%0d", expidle, idlestate), OVM_LOW);

endtask: check_unit_idle_task

//-------------------------------------
//-- EOT WB STAT register check 
//-- hqm_system_csr.WB_DIR_CQ_STATE[96] 
//-- hqm_system_csr.WB_LDB_CQ_STATE[64]   
//-------------------------------------
virtual task hqmproc_eot_check_task_wb_state();
     sla_ral_data_t rd_val, wr_val, rd_val1;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_wb_state: Start "), OVM_LOW);
     //-----------------------------
     //--system   
     //-----------------------------
     for(int i=0; i<hqm_pkg::NUM_DIR_CQ; i++) begin
        read_reg($psprintf("WB_DIR_CQ_STATE[%0d]",i), rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_wb_state: hqm_system_csr.WB_DIR_CQ_STATE[%0d].rd=0x%0x ", i, rd_val), OVM_LOW);
        if(rd_val[4]==1) begin
               write_fields($psprintf("WB_DIR_CQ_STATE[%0d]",i), '{"CQ_OPT_CLR"}, '{'b1}, "hqm_system_csr");
               read_reg($psprintf("WB_DIR_CQ_STATE[%0d]",i), rd_val, "hqm_system_csr");
               if(rd_val[4]==1) 
                  ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_wb_state: hqm_system_csr.WB_DIR_CQ_STATE[%0d].rdafterclear=0x%0x ", i, rd_val), OVM_LOW);
        end
     end//--for 

     for(int i=0; i<hqm_pkg::NUM_LDB_CQ; i++) begin
        read_reg($psprintf("WB_LDB_CQ_STATE[%0d]",i), rd_val, "hqm_system_csr");
        ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_wb_state: hqm_system_csr.WB_LDB_CQ_STATE[%0d].rd=0x%0x ", i, rd_val), OVM_LOW);
        if(rd_val[4]==1) begin
               write_fields($psprintf("WB_LDB_CQ_STATE[%0d]",i), '{"CQ_OPT_CLR"}, '{'b1}, "hqm_system_csr");
               read_reg($psprintf("WB_LDB_CQ_STATE[%0d]",i), rd_val, "hqm_system_csr");
               if(rd_val[4]==1) 
                  ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_wb_state: hqm_system_csr.WB_LDB_CQ_STATE[%0d].rdafterclear=0x%0x ", i, rd_val), OVM_LOW);
        end
     end//--for 

endtask: hqmproc_eot_check_task_wb_state 

//-------------------------------------
//-- EOT counter/status register check 
//-------------------------------------
virtual task hqmproc_eot_check_task_CHP_histlist();
     sla_ral_data_t rd_val, wr_val, rd_val1;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_hqmproc_eot_check_task_CHP_histlist: Start "), OVM_LOW);
     //-----------------------------
     //--chp  CFG_HIST_LIST_0[2048]/CFG_HIST_LIST_1[2048]
     //-----------------------------
     if($test$plusargs("HQMPROC_EOT_HIST_CHECK")) begin 
        for(int i=0; i<2048; i++) begin
           read_reg($psprintf("CFG_HIST_LIST_0[%0d]",i), rd_val, "credit_hist_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_vas_credit_reprog_task: CFG_HIST_LIST_0[%0d].eot.rd=0x%0x; ", i, rd_val), OVM_LOW);

           read_reg($psprintf("CFG_HIST_LIST_1[%0d]",i), rd_val, "credit_hist_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_vas_credit_reprog_task: CFG_HIST_LIST_1[%0d].eot.rd=0x%0x; ", i, rd_val), OVM_LOW);
        end
     end
 
     if($test$plusargs("HQMPROC_EOT_HIST_A_CHECK")) begin 
        for(int i=0; i<2048; i++) begin
           read_reg($psprintf("CFG_HIST_LIST_A_0[%0d]",i), rd_val, "credit_hist_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_vas_credit_reprog_task: CFG_HIST_LIST_A_0[%0d].eot.rd=0x%0x; ", i, rd_val), OVM_LOW);

           read_reg($psprintf("CFG_HIST_LIST_A_1[%0d]",i), rd_val, "credit_hist_pipe");
           ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_cfg_chp_vas_credit_reprog_task: CFG_HIST_LIST_A_1[%0d].eot.rd=0x%0x; ", i, rd_val), OVM_LOW);
        end
     end
endtask: hqmproc_eot_check_task_CHP_histlist 

//-------------------------------------
//-- EOT counter/status register check 
//-------------------------------------
virtual task hqmproc_eot_check_task_CHP_INTR_IRQ_Poll();
     sla_ral_data_t rd_val, wr_val, rd_val1;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_CHP_CQ_IRQ_Pending_check: Start "), OVM_LOW);
     foreach(i_hqm_cfg.ims_prog_cfg[i]) begin
         read_reg($psprintf("AI_CTRL[%0d]",i), rd_val, "hqm_system_csr");
         if(rd_val!=0)
            ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_csr.AI_CTRL[%0d].rd=0x%0x, expecting 0", i, rd_val), OVM_LOW); 
     end

     read_reg("IMS_PEND_CLEAR", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_csr.IMS_PEND_CLEAR.rd=0x%0x", rd_val), OVM_LOW); 


     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_CHP_INTR_IRQ_Poll: Start "), OVM_LOW);
     //-----------------------------
     //--chp INTR_IRQ 
     //-----------------------------
     read_reg("CFG_DIR_CQ_INTR_IRQ0", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_DIR_CQ_INTR_IRQ0.rd=0x%0x", rd_val), OVM_LOW); 
     if(rd_val!=0) begin 
          ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_DIR_CQ_INTR_IRQ0.rd=0x%0x, expecting 0", rd_val), OVM_LOW); 
     end

     read_reg("CFG_DIR_CQ_INTR_IRQ1", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_DIR_CQ_INTR_IRQ1.rd=0x%0x", rd_val), OVM_LOW); 
     if(rd_val!=0) begin 
          ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_DIR_CQ_INTR_IRQ1.rd=0x%0x, expecting 0", rd_val), OVM_LOW); 
     end

     read_reg("CFG_LDB_CQ_INTR_IRQ0", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_LDB_CQ_INTR_IRQ0.rd=0x%0x", rd_val), OVM_LOW); 
     if(rd_val!=0) begin 
          ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_LDB_CQ_INTR_IRQ0.rd=0x%0x, expecting 0", rd_val), OVM_LOW); 
     end

     read_reg("CFG_LDB_CQ_INTR_IRQ1", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_LDB_CQ_INTR_IRQ1.rd=0x%0x", rd_val), OVM_LOW); 
     if(rd_val!=0) begin 
          ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_LDB_CQ_INTR_IRQ1.rd=0x%0x, expecting 0", rd_val), OVM_LOW); 
     end

endtask: hqmproc_eot_check_task_CHP_INTR_IRQ_Poll 



//-------------------------------------
//-- EOT counter/status register check: CHP counters 
//-------------------------------------
virtual task hqmproc_eot_check_task_Misc_Count_Poll();
     sla_ral_data_t rd_val, wr_val, rd_val1;
     sla_ral_data_t dp_rd_val,  wr_val1, wr_val_q[$];   
     bit [31:0]     chp_correctible_count_0, chp_correctible_count_1;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_hqmproc_eot_check_task_Misc_Count_Poll: Start "), OVM_LOW);
     //-----------------------------
     //--SMON_TIMER  
     //-----------------------------
     read_reg("CFG_SMON_TIMER", rd_val , "direct_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:direct_pipe.CFG_SMON_TIMER.rd=0x%0x", rd_val), OVM_LOW); 
     dp_rd_val = rd_val;

     read_reg("CFG_SMON_TIMER", rd_val , "reorder_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:reorder_pipe.CFG_SMON_TIMER.rd=0x%0x", rd_val), OVM_LOW); 

     read_reg("CFG_SMON_TIMER", rd_val , "nalb_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:nalb_pipe.CFG_SMON_TIMER.rd=0x%0x", rd_val), OVM_LOW); 

     read_reg("CFG_SMON_TIMER", rd_val , "atm_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:atm_pipe.CFG_SMON_TIMER.rd=0x%0x", rd_val), OVM_LOW); 

     read_reg("CFG_SMON_TIMER", rd_val , "aqed_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:aqed_pipe.CFG_SMON_TIMER.rd=0x%0x", rd_val), OVM_LOW); 


     read_reg("CFG_SMON_TIMER", rd_val , "qed_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:qed_pipe.CFG_SMON_TIMER.rd=0x%0x", rd_val), OVM_LOW); 

     //-----------------------------
     //--LSP CFG_SCHD_COS  
     //-----------------------------
     read_reg("CFG_SCHD_COS0_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_SCHD_COS0_L.rd=0x%0x", rd_val), OVM_LOW); 

     read_reg("CFG_SCHD_COS1_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_SCHD_COS1_L.rd=0x%0x", rd_val), OVM_LOW); 

     read_reg("CFG_SCHD_COS2_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_SCHD_COS2_L.rd=0x%0x", rd_val), OVM_LOW); 

     read_reg("CFG_SCHD_COS3_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_SCHD_COS3_L.rd=0x%0x", rd_val), OVM_LOW); 

     //-----------------------------
     //--CHP (SEB)  
     //-----------------------------
     read_reg("CFG_CHP_CORRECTIBLE_COUNT_L", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_L.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_CHP_CORRECTIBLE_COUNT_H", rd_val1 , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_H.rd=0x%0x", rd_val1), OVM_LOW); 

     if($test$plusargs("has_chp_enqsbe_inj0") || $test$plusargs("has_chp_enqsbe_inj1")) begin 
         if($test$plusargs("has_chp_enqsbe_inj0") && $test$plusargs("has_chp_enqsbe_inj1") && rd_val > 0 ) begin
             ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_L.rd=0x%0x credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_H.rd=0x%0x, expecting correctible_cnt=0 in ENQ MBE case", rd_val, rd_val1), OVM_LOW); 
         end else if($test$plusargs("has_chp_enqsbe_inj0") && !$test$plusargs("has_chp_enqsbe_inj1") && rd_val==0) begin
             ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_L.rd=0x%0x credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_H.rd=0x%0x, expecting correctible_cnt>0 in ENQ SBE case +has_chp_enqsbe_inj0", rd_val, rd_val1), OVM_LOW); 
         end else if(!$test$plusargs("has_chp_enqsbe_inj0") && $test$plusargs("has_chp_enqsbe_inj1") && rd_val==0) begin
             ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_L.rd=0x%0x credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_H.rd=0x%0x, expecting correctible_cnt>0 in ENQ SBE case +has_chp_enqsbe_inj1", rd_val, rd_val1), OVM_LOW); 
         end
     end


     if($test$plusargs("has_chp_schsbe_inj0") || $test$plusargs("has_chp_schsbe_inj1")) begin 
         if($test$plusargs("has_chp_schsbe_inj0") && $test$plusargs("has_chp_schsbe_inj1") && rd_val > 0 ) begin
             ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_L.rd=0x%0x credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_H.rd=0x%0x, expecting correctible_cnt=0 in SCH MBE case", rd_val, rd_val1), OVM_LOW); 
         end else if($test$plusargs("has_chp_schsbe_inj0") && !$test$plusargs("has_chp_schsbe_inj1") && rd_val==0) begin
             ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_L.rd=0x%0x credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_H.rd=0x%0x, expecting correctible_cnt>0 in SCH SBE case +has_chp_schsbe_inj0", rd_val, rd_val1), OVM_LOW); 
         end else if(!$test$plusargs("has_chp_schsbe_inj0") && $test$plusargs("has_chp_schsbe_inj1") && rd_val==0) begin
             ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_L.rd=0x%0x credit_hist_pipe.CFG_CHP_CORRECTIBLE_COUNT_H.rd=0x%0x, expecting correctible_cnt>0 in SCH SBE case +has_chp_schsbe_inj1", rd_val, rd_val1), OVM_LOW); 
         end
 
     end

    //------------------------    
    //-- CFG_SMON_TIMER to check if ungate clk works                          
    //------------------------  
    //+hqm_proc_force_ungatedck
     read_reg("CFG_SMON_TIMER", rd_val , "direct_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:direct_pipe.CFG_SMON_TIMER.rd=0x%0x", rd_val), OVM_LOW); 
     if($test$plusargs("hqm_proc_force_ungatedck")) begin
           if(rd_val > dp_rd_val)
              ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task: dp_regs.CFG_SMON_TIMER = %0d > dp_rd_val=%0d",  rd_val, dp_rd_val), OVM_LOW);
           else
              ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task: dp_regs.CFG_SMON_TIMER = %0d > dp_rd_val=%0d",  rd_val, dp_rd_val), OVM_LOW);
     end

endtask: hqmproc_eot_check_task_Misc_Count_Poll 



//-------------------------------------
//-- EOT counter/status register check 
//-------------------------------------
virtual task hqmproc_eot_check_task_count();

     sla_ral_data_t rd_val, wr_val, rd_val1;

     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task_count: Start "), OVM_LOW);
     //-----------------------------
     //--lsp cnt
     //-----------------------------
     read_reg("CFG_LSP_PERF_DIR_SCH_COUNT_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LSP_PERF_DIR_SCH_COUNT_L.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LSP_PERF_DIR_SCH_COUNT_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LSP_PERF_LDB_SCH_COUNT_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LSP_PERF_LDB_SCH_COUNT_L.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LSP_PERF_LDB_SCH_COUNT_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_0_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_0_L.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_0_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_1_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_1_L.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_1_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_2_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_2_L.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_2_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_3_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_3_L.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_3_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_4_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_4_L.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_4_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_5_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_5_L.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_5_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_6_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_6_L.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_6_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_7_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_7_L.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_7_H", rd_val , "list_sel_pipe");

     //-----------------------------
     //--chp cnt
     //-----------------------------
     read_reg("cfg_counter_chp_error_drop_l", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.cfg_counter_chp_error_drop_l.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("cfg_counter_chp_error_drop_h", rd_val , "credit_hist_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.cfg_counter_chp_error_drop_h.rd=0x%0x", rd_val1), OVM_LOW); 
     if($test$plusargs("has_chp_ingusr_parerr_inj")) begin 
       if(rd_val==0 && rd_val1==0) begin
          ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:credit_hist_pipe.cfg_counter_chp_error_drop_l.rd=0x%0x credit_hist_pipe.cfg_counter_chp_error_drop_h.rd=0x%0x, expecting HCW drop ", rd_val, rd_val1), OVM_LOW); 
       end
     end

     //-----------------------------
     //-- AQED feature register checking
     //-----------------------------
     read_reg("cfg_detect_feature_operation_00", rd_val , "aqed_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:aqed_pipe.cfg_detect_feature_operation_00.rd=0x%0x", rd_val), OVM_LOW); 
     if($test$plusargs("has_aqed_bcam_full_ck") && !$test$plusargs("hqmproc_bgcfg_enable") && !$test$plusargs("HQM_BACKGROUND_CFG_GEN_SEQ")&& !$test$plusargs("HQM_DISABLE_AGITIATE_ASSERT")) begin  
        if(rd_val[2]==0)
          ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:aqed_pipe.cfg_detect_feature_operation_00.rd=0x%0x , expect BCAM_FULL0[2:2]=1 (etect bcam is full, all 2k flows are active) ", rd_val), OVM_LOW); 
     end 

     if($test$plusargs("has_aqed_bcam_not_full_ck")) begin 
        if(rd_val[2]==1)
          ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:aqed_pipe.cfg_detect_feature_operation_00.rd=0x%0x , expect BCAM_FULL0[2:2]=0 (etect bcam is full, all 2k flows are active) ", rd_val), OVM_LOW); 
     end 


     //-----------------------------
     //--sys cnt
     //-----------------------------
     //-- Enqueued HCW Input Counter : Number of enqueued HCWs ingress received from SIF
     read_reg("hqm_system_cnt_0", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_0.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("hqm_system_cnt_1", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_1.rd=0x%0x", rd_val), OVM_LOW); 

     //--Enqueued HCW Output Counter : Number of enqueued HCWs ingress sent to hqm_core
     read_reg("hqm_system_cnt_2", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_2.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("hqm_system_cnt_3", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_3.rd=0x%0x", rd_val), OVM_LOW); 

     //--Enqueued HCW Drop Counter : Number of enqueued HCWs ingress dropped due to error
     //--drop counter
     read_reg("hqm_system_cnt_4", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_4.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("hqm_system_cnt_5", rd_val1 , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_5.rd=0x%0x", rd_val1), OVM_LOW); 
     //-- has_chp_egrusr_parerr_inj test: system reports alarm_err and egress_lut_err, doesn't count drop
     //if($test$plusargs("has_chp_egrusr_parerr_inj")) begin 
     //  if(rd_val==0 && rd_val1==0) begin
     //     ovm_report_error(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_4.rd=0x%0x hqm_system_cnt_5.rd=0x%0x, expecting HCW drop ", rd_val, rd_val1), OVM_LOW); 
     //  end
     //end


     //-- Scheduled HCW Input Counter : Number of scheduled HCWs egress received from hqm_core
     read_reg("hqm_system_cnt_6", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_6.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("hqm_system_cnt_7", rd_val1 , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_7.rd=0x%0x", rd_val1), OVM_LOW); 


     //-- Scheduled HCW Write Buffer Output Counter : Number of scheduled HCWs egress sent to the write buffer
     read_reg("hqm_system_cnt_8", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_8.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("hqm_system_cnt_9", rd_val1 , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_9.rd=0x%0x", rd_val1), OVM_LOW); 


     //-- Write Buffer Write Data Output Counter : Number of posted write data words the write buffer sent to SIF
     read_reg("hqm_system_cnt_10", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_10.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("hqm_system_cnt_11", rd_val1 , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_11.rd=0x%0x", rd_val1), OVM_LOW); 

     //-- MSI Counter : Number of AI/MSI interrupt writes
     read_reg("hqm_system_cnt_12", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_12.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("hqm_system_cnt_13", rd_val1 , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_13.rd=0x%0x", rd_val1), OVM_LOW); 

     //-- MSI-X Counter: 
     read_reg("hqm_system_cnt_14", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_14.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("hqm_system_cnt_15", rd_val1 , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_15.rd=0x%0x", rd_val1), OVM_LOW); 

     //-- Write Buffer Write Request Output Counter : Number of posted write requests the write buffer sent to SIF
     read_reg("hqm_system_cnt_16", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_16.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("hqm_system_cnt_17", rd_val1 , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_17.rd=0x%0x", rd_val1), OVM_LOW); 

     //-- Write Buffer Request Drop Counter: Number of posted writes the write buffer dropped
     read_reg("hqm_system_cnt_18", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_18.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("hqm_system_cnt_19", rd_val1 , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_19.rd=0x%0x", rd_val1), OVM_LOW); 

     //-- Write Buffer Coalesced Write Counter : Number of scheduled HCWs the write buffer coalesced 
     read_reg("hqm_system_cnt_20", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_20.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("hqm_system_cnt_21", rd_val1 , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.hqm_system_cnt_21.rd=0x%0x", rd_val1), OVM_LOW); 

     //--
     read_reg("SBE_CNT_0", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.SBE_CNT_0.rd=0x%0x", rd_val), OVM_LOW); 
     read_reg("SBE_CNT_1", rd_val , "hqm_system_csr");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:hqm_system_regs.SBE_CNT_1.rd=0x%0x", rd_val), OVM_LOW); 

     //-----------------------------
     //--lsp cnt
     //-----------------------------
     //-- lsp perfctrl clr=1
     configure_lsp_perfctrl_clr_task();

     //--counters should be clr
     read_reg("CFG_LSP_PERF_DIR_SCH_COUNT_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LSP_PERF_DIR_SCH_COUNT_L.rd.clred=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LSP_PERF_DIR_SCH_COUNT_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LSP_PERF_LDB_SCH_COUNT_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LSP_PERF_LDB_SCH_COUNT_L.rd.clred=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LSP_PERF_LDB_SCH_COUNT_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_0_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_0_L.rd.clred=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_0_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_1_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_1_L.rd.clred=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_1_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_2_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_2_L.rd.clred=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_2_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_3_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_3_L.rd.clred=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_3_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_4_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_4_L.rd.clred=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_4_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_5_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_5_L.rd.clred=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_5_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_6_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_6_L.rd.clred=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_6_H", rd_val , "list_sel_pipe");
     read_reg("CFG_LDB_SCHED_PERF_7_L", rd_val , "list_sel_pipe");
     ovm_report_info(get_full_name(),$psprintf("HQMPROC_CFG_NSEQ4_hqmproc_eot_check_task:list_sel_pipe.CFG_LDB_SCHED_PERF_7_L.rd.clred=0x%0x", rd_val), OVM_LOW); 
     read_reg("CFG_LDB_SCHED_PERF_7_H", rd_val , "list_sel_pipe");

endtask : hqmproc_eot_check_task_count
