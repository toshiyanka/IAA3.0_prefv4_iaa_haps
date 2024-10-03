

//-------------------------
// hqmproc_vasreset_task_main()
//------------------------- 
virtual task hqmproc_vasreset_task_main();
  sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];
  int  vasrst_wait_min, vasrst_wait_max, vasrst_wait;
  int  vas_min, vas_max;
  int  ldbqid_min, ldbqid_max, dirqid_min, dirqid_max;
  int  ldbpp_min, ldbpp_max, dirpp_min, dirpp_max;
  int  ldbcq_min, ldbcq_max, dircq_min, dircq_max;
  bit [63:0] new_cq_addr_gpa, new_cq_addr_hpa;

  int  has_ldbpp_other, ldbpp_other;
  hqm_cfg_command_options  cmd_option = new();
  cmd_option.str_value = "sm";

    has_ldbpp_other=0;
    if($test$plusargs("has_scen2_vasrst_0")) begin 
      ldbpp_other=8;
      has_ldbpp_other=1;
    end else if($test$plusargs("has_scen2_vasrst_1")) begin 
      ldbpp_other=9;
      has_ldbpp_other=1;
    end
 
    vasrst_wait_min=0;
    $value$plusargs("hqmproc_vasrst_vasrst_wait_min=%d", vasrst_wait_min);
    vasrst_wait_max=0;
    $value$plusargs("hqmproc_vasrst_vasrst_wait_max=%d", vasrst_wait_max);
    vasrst_wait = $urandom_range(vasrst_wait_min, vasrst_wait_max);


    vas_min=0;
    $value$plusargs("hqmproc_vasrst_vas_min=%d", vas_min);
    vas_max=0;
    $value$plusargs("hqmproc_vasrst_vas_max=%d", vas_max);

    ldbqid_min=0;
    $value$plusargs("hqmproc_vasrst_ldbqid_min=%d", ldbqid_min);
    ldbqid_max=0;
    $value$plusargs("hqmproc_vasrst_ldbqid_max=%d", ldbqid_max);
    dirqid_min=0;
    $value$plusargs("hqmproc_vasrst_dirqid_min=%d", dirqid_min);
    dirqid_max=0;
    $value$plusargs("hqmproc_vasrst_dirqid_max=%d", dirqid_max);

    ldbpp_min=0;
    $value$plusargs("hqmproc_vasrst_ldbpp_min=%d", ldbpp_min);
    ldbpp_max=0;
    $value$plusargs("hqmproc_vasrst_ldbpp_max=%d", ldbpp_max);
    dirpp_min=0;
    $value$plusargs("hqmproc_vasrst_dirpp_min=%d", dirpp_min);
    dirpp_max=0;
    $value$plusargs("hqmproc_vasrst_dirpp_max=%d", dirpp_max);


    ldbcq_min=0;
    $value$plusargs("hqmproc_vasrst_ldbcq_min=%d", ldbcq_min);
    ldbcq_max=0;
    $value$plusargs("hqmproc_vasrst_ldbcq_max=%d", ldbcq_max);
    dircq_min=0;
    $value$plusargs("hqmproc_vasrst_dircq_min=%d", dircq_min);
    dircq_max=0;
    $value$plusargs("hqmproc_vasrst_dircq_max=%d", dircq_max);


    ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main setting: vas_min=%0d, vas_max=%0d",  vas_min, vas_max), OVM_MEDIUM);
    ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main setting: ldbqid_min=%0d, ldbqid_max=%0d, dirqid_min=%0d, dirqid_max=%0d", ldbqid_min, ldbqid_max, dirqid_min, dirqid_max), OVM_MEDIUM);
    ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main setting: ldbpp_min=%0d, ldbpp_max=%0d, has_ldbpp_other=%0d ldbpp_other=%0d, dirpp_min=%0d, dirpp_max=%0d", ldbpp_min, ldbpp_max, has_ldbpp_other, ldbpp_other, dirpp_min, dirpp_max), OVM_MEDIUM);
    ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main setting: ldbcq_min=%0d, ldbcq_max=%0d, dircq_min=%0d, dircq_max=%0d", ldbcq_min, ldbcq_max, dircq_min, dircq_max), OVM_MEDIUM);



     //-----------------------------------------------------------------------
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S1.1: TB disable trf hqmproc_ldb_trfctrl=0 to stop traffics"), OVM_MEDIUM);
     for(int i=ldbpp_min; i<ldbpp_max; i++) begin
        i_hqm_cfg.hqmproc_ldb_trfctrl[i]=0;
     end
     if(has_ldbpp_other) i_hqm_cfg.hqmproc_ldb_trfctrl[ldbpp_other]=0;

     for(int i=dirpp_min; i<dirpp_max; i++) begin
        i_hqm_cfg.hqmproc_dir_trfctrl[i]=0;
     end
     vasrst_wait = $urandom_range(vasrst_wait_min, vasrst_wait_max);
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S1.2: wait %0d", vasrst_wait), OVM_MEDIUM);
     wait_idle(vasrst_wait);

     //-----------------------------------------------------------------------
     //-- poll before disable CQs
     //if($test$plusargs("has_vasrst_counter_poll")) begin 
     if(!$test$plusargs("HQM_ATS_ERRINJ_SKIP_LSPCNT_POLL")) begin
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S1.3: cfgcheck_lsp_counter_task_poll with poll wait"), OVM_MEDIUM);
        cfgcheck_lsp_counter_task_poll(1, ldbcq_min,  ldbcq_max,  ldbqid_min,  ldbqid_max,  dirqid_min,  dirqid_max); 
     end else begin
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S1.3: cfgcheck_lsp_counter_task_poll without poll wait +HQM_ATS_ERRINJ_SKIP_LSPCNT_POLL"), OVM_MEDIUM);
        cfgcheck_lsp_counter_task_poll(0, ldbcq_min,  ldbcq_max,  ldbqid_min,  ldbqid_max,  dirqid_min,  dirqid_max); 
     end
     //end

     //-----------------------------------------------------------------------
     //ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S2: recfg_hqm_system_pp_task_0 disable pp"), OVM_MEDIUM);
     //recfg_hqm_system_pp_task_0(0, has_ldbpp_other, ldbpp_other, ldbpp_min, ldbpp_max, dirpp_min, dirpp_max); 
     //ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S3: recfg_hqm_system_qid_task_0 disable qid"), OVM_MEDIUM);
     //recfg_hqm_system_qid_task_0(0, ldbqid_min, ldbqid_max, dirqid_min, dirqid_max); 

     wait_idle(100);
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S2: cfg_cq_disable_task"), OVM_MEDIUM);
     for(int i=ldbcq_min; i<ldbcq_max; i++) begin
         cfg_cq_disable_task(1, i, 1); 
     end 
     for(int i=dirpp_min; i<dirpp_max; i++) begin
         cfg_cq_disable_task(0, i, 1); 
     end 




     //-----------------------------------------------------------------------
     //ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S5: recfg_hqm_system_pp_task_0 enable pp"), OVM_MEDIUM);
     //recfg_hqm_system_pp_task_0(1, has_ldbpp_other, ldbpp_other, ldbpp_min, ldbpp_max, dirpp_min, dirpp_max); 
     //ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6: recfg_hqm_system_qid_task_0 enable qid"), OVM_MEDIUM);
     //recfg_hqm_system_qid_task_0(1, ldbqid_min, ldbqid_max, dirqid_min, dirqid_max); 


     //ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S3: return all completions and tokens set has_trfenq_enable=2"), OVM_MEDIUM);
     //for(int i=ldbpp_min; i<ldbpp_max; i++) begin
     //   i_hqm_cfg.hqmproc_ldb_trfctrl[i]=2;
     //end
     //if(has_ldbpp_other) i_hqm_cfg.hqmproc_ldb_trfctrl[ldbpp_other]=2;
     //for(int i=dirpp_min; i<dirpp_max; i++) begin
     //   i_hqm_cfg.hqmproc_dir_trfctrl[i]=2;
     //end

     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S3.1: cfgcheck_lsp_counter_task_poll.first"), OVM_MEDIUM);
     cfgcheck_lsp_counter_task_poll(0, ldbcq_min,  ldbcq_max,  ldbqid_min,  ldbqid_max,  dirqid_min,  dirqid_max); 

     wait_idle(500);
     vasrst_wait = $urandom_range(vasrst_wait_min, vasrst_wait_max);
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S3.2: wait %0d for returns issued by hqm_pp_cq_hqmproc_seq", vasrst_wait), OVM_MEDIUM);
     wait_idle(vasrst_wait);
     //-- completion returns 
     //-- token returns
     //-- SB clear

     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S3.13 cfgcheck_lsp_counter_task_poll.2nd"), OVM_MEDIUM);
     cfgcheck_lsp_counter_task_poll(0, ldbcq_min,  ldbcq_max,  ldbqid_min,  ldbqid_max,  dirqid_min,  dirqid_max); 

     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S4.1: cfgpoll_lsp_dirqid_counter_task_0"), OVM_MEDIUM);
     cfgpoll_lsp_dirqid_counter_task_0(dirqid_min, dirqid_max); 

     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S4.2: cfgpoll_lsp_ldbqid_counter_task_0"), OVM_MEDIUM);
     cfgpoll_lsp_ldbqid_counter_task_0(ldbqid_min, ldbqid_max); 

     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S4.3: cfgpoll_lsp_ldbcq_counter_task_0"), OVM_MEDIUM);
     cfgpoll_lsp_ldbcq_counter_task_0(ldbcq_min, ldbcq_max); 


     //----------------------------------------------------------------------- HQMV30_ATS =>  to re-build pages
     if($test$plusargs("HQMV30_ATS_INV_TEST")) begin
        
        read_reg("MSTR_LL_CTL", rd_val, "hqm_sif_csr");	
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S5.0: hqm_sif_csr.MSTR_LL_CTL.rd=0x%0x", rd_val), OVM_MEDIUM);


        for(int i=ldbcq_min; i<ldbcq_max; i++) begin
           wr_val=0;
           wr_val[7:0] = 64 + i;
           write_fields($psprintf("MSTR_LL_CTL"), '{"PTR"}, '{wr_val[7:0]}, "hqm_sif_csr"); 
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.0: LDBCQ[%0d] - ldb_pp_cq_cfg[%0d].cq_ats_inv_ctrl=%0d  (ATS INV responded): Programming MSTR_LL_CTL.PTR=0x%0x ", i, i, i_hqm_cfg.ldb_pp_cq_cfg[i].cq_ats_inv_ctrl, wr_val[7:0]), OVM_MEDIUM);

           //--rebuild pages
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.1: LDBCQ[%0d] - call hqm_cfg.decode_cq_gpa ", i), OVM_MEDIUM);
           new_cq_addr_gpa = i_hqm_cfg.decode_cq_gpa(cmd_option, -1, $psprintf("HQM%s_LDB_CQ_%0d_REALLOCMEM",i_hqm_cfg.inst_suffix,i), ((i_hqm_cfg.ldb_cq_single_hcw_per_cl > 0) ? 64'h100 : 64'h40) << i_hqm_cfg.ldb_pp_cq_cfg[i].cq_depth, i_hqm_cfg.pb_addr_mask, 1'b1, i);
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.2: LDBCQ[%0d] - rebuild LDBCQ[%0d] page and get new_cq_addr_gpa=0x%0x - call recfg_cqaddr_task_0() to reprogram CQ_ADDR_U/L", i, i, new_cq_addr_gpa), OVM_MEDIUM);
           recfg_cqaddr_task_0(1, i, new_cq_addr_gpa); 

           //--remove error injection
           i_hqm_cfg.ldb_pp_cq_cfg[i].cq_ats_resp_errinj=0;  
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.3: LDBCQ[%0d] - remove ATS Resp ERRINJ - i_hqm_cfg.ldb_pp_cq_cfg[%0d].cq_ats_resp_errinj=%0d ", i, i, i_hqm_cfg.ldb_pp_cq_cfg[i].cq_ats_resp_errinj), OVM_MEDIUM);

           //--rerun_cq_buffer_init with new_cq_addr_hpa
           new_cq_addr_hpa = i_hqm_cfg.get_cq_hpa(1, i); 
           rerun_cq_buffer_init(1, i, new_cq_addr_hpa);
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.4: LDBCQ[%0d] - Rerun cq_buffer_init - i_hqm_cfg.ldb_pp_cq_cfg[%0d].cq_hpa=x0%0x new_cq_addr_hpa=0x%0x", i, i, i_hqm_cfg.ldb_pp_cq_cfg[i].cq_hpa, new_cq_addr_hpa), OVM_MEDIUM);


           //-- toggle clr_hpa_err
           write_fields($psprintf("MSTR_LL_CTL"), '{"CLR_HPA_ERR"}, '{1'b1}, "hqm_sif_csr"); 
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.5: LDBCQ[%0d] - Programming MSTR_LL_CTL.CLR_HPA_ERR=1", i), OVM_MEDIUM);
           write_fields($psprintf("MSTR_LL_CTL"), '{"CLR_HPA_ERR"}, '{1'b0}, "hqm_sif_csr"); 
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.6: LDBCQ[%0d] - Programming MSTR_LL_CTL.CLR_HPA_ERR=0", i), OVM_MEDIUM);
        end

        for(int i=dirpp_min; i<dirpp_max; i++) begin
           wr_val=0;
           wr_val[7:0] = i;
           write_fields($psprintf("MSTR_LL_CTL"), '{"PTR"}, '{wr_val[7:0]}, "hqm_sif_csr"); 
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.0: DIRCQ[%0d] - dir_pp_cq_cfg[%0d].cq_ats_inv_ctrl=%0d  (ATS INV responded): Programming MSTR_LL_CTL.PTR=0x%0x ", i, i, i_hqm_cfg.dir_pp_cq_cfg[i].cq_ats_inv_ctrl, wr_val[7:0]), OVM_MEDIUM);

           //--rebuild pages
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.1: DIRCQ[%0d] - call hqm_cfg.decode_cq_gpa ", i), OVM_MEDIUM);
           new_cq_addr_gpa = i_hqm_cfg.decode_cq_gpa(cmd_option, -1, $psprintf("HQM%s_DIR_CQ_%0d_REALLOCMEM",i_hqm_cfg.inst_suffix,i), ((i_hqm_cfg.dir_cq_single_hcw_per_cl > 0) ? 64'h100 : 64'h40) << i_hqm_cfg.dir_pp_cq_cfg[i].cq_depth, i_hqm_cfg.pb_addr_mask, 1'b1, i);
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.2: DIRCQ[%0d] - rebuild DIRCQ[%0d] page and get new_cq_addr_gpa=0x%0x - call recfg_cqaddr_task_0() to reprogram CQ_ADDR_U/L", i, i, new_cq_addr_gpa), OVM_MEDIUM);
           recfg_cqaddr_task_0(1, i, new_cq_addr_gpa); 

           //--remove error injection
           i_hqm_cfg.dir_pp_cq_cfg[i].cq_ats_resp_errinj=0;  
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.3: DIRCQ[%0d] - remove ATS Resp ERRINJ - i_hqm_cfg.dir_pp_cq_cfg[%0d].cq_ats_resp_errinj=%0d ", i, i, i_hqm_cfg.dir_pp_cq_cfg[i].cq_ats_resp_errinj), OVM_MEDIUM);

           //--rerun_cq_buffer_init with new_cq_addr_hpa
           new_cq_addr_hpa = i_hqm_cfg.get_cq_hpa(0, i); 
           rerun_cq_buffer_init(0, i, new_cq_addr_hpa);
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.4: DIRCQ[%0d] - Rerun cq_buffer_init - i_hqm_cfg.dir_pp_cq_cfg[%0d].cq_hpa=x0%0x new_cq_addr_hpa=0x%0x", i, i, i_hqm_cfg.dir_pp_cq_cfg[i].cq_hpa, new_cq_addr_hpa), OVM_MEDIUM);

           //-- toggle clr_hpa_err
           write_fields($psprintf("MSTR_LL_CTL"), '{"CLR_HPA_ERR"}, '{1'b1}, "hqm_sif_csr"); 
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.5: DIRCQ[%0d] - Programming MSTR_LL_CTL.CLR_HPA_ERR=1", i), OVM_MEDIUM);
           write_fields($psprintf("MSTR_LL_CTL"), '{"CLR_HPA_ERR"}, '{1'b0}, "hqm_sif_csr"); 
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S6.6: DIRCQ[%0d] - Programming MSTR_LL_CTL.CLR_HPA_ERR=0", i), OVM_MEDIUM);
        end
     end //--if($test$plusargs("HQMV30_ATS_INV_TEST")) 

     //-----------------------------------------------------------------------
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S9.1: recfg_lsp_ldbqid_counter_clear_task_0"), OVM_MEDIUM);
     recfg_lsp_ldbqid_counter_clear_task_0(ldbqid_min, ldbqid_max); 
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S9.2: recfg_lsp_ldbcq_counter_clear_task_0"), OVM_MEDIUM);
     recfg_lsp_ldbcq_counter_clear_task_0(ldbcq_min, ldbcq_max);
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S9.3: recfg_lsp_dirqid_counter_clear_task_0"), OVM_MEDIUM);
     recfg_lsp_dirqid_counter_clear_task_0(dirqid_min, dirqid_max); 


     //-----------------------------------------------------------------------
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S10: wait"), OVM_MEDIUM);
     wait_idle(1000);
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S11: reconfigure...."), OVM_MEDIUM);
     recfg_hqm_system_after_vas_reset(vas_min, vas_max, dirpp_min, dirpp_max, dirqid_min, dirqid_max, ldbqid_min, ldbqid_max, ldbpp_min, ldbpp_max, ldbcq_min, ldbcq_max, has_ldbpp_other, ldbpp_other);



     //-----------------------------------------------------------------------
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S12: cfg_cq_disable_task ENABLE CQ"), OVM_MEDIUM);
     for(int i=ldbcq_min; i<ldbcq_max; i++) begin
         cfg_cq_disable_task(1, i, 0); 
     end 
     for(int i=dirpp_min; i<dirpp_max; i++) begin
         cfg_cq_disable_task(0, i, 0); 
     end 


     //-----------------------------------------------------------------------
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S13: resume traffic set has_trfenq_enable=3...."), OVM_MEDIUM);
     for(int i=ldbpp_min; i<ldbpp_max; i++) begin
        foreach(i_hcw_scoreboard.hcw_uno_ldb_qid_q[pp]) begin
             if(pp==(i+128)) begin
               for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
                  for (int qpri = 0 ; qpri < 8 ; qpri++) begin
                     i_hcw_scoreboard.hcw_uno_ldb_qid_q[pp][qid][qpri].hcw_q.delete();
                     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S13: i_hcw_scoreboard.hcw_uno_ldb_qid_q[%0d][%0d[%0d].hcw_q.delete", pp, qid, qpri), OVM_MEDIUM);
                  end
               end
             end
        end
        foreach(i_hcw_scoreboard.hcw_atm_ldb_qid_q[pp]) begin
             if(pp==(i+128)) begin
               for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
                  for (int qpri = 0 ; qpri < 8 ; qpri++) begin
                     i_hcw_scoreboard.hcw_atm_ldb_qid_q[pp][qid][qpri].hcw_q.delete();
                     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S13: i_hcw_scoreboard.hcw_atm_ldb_qid_q[%0d][%0d[%0d].hcw_q.delete", pp, qid, qpri), OVM_MEDIUM);
                  end
               end
             end
        end

        i_hqm_cfg.hqmproc_ldb_trfctrl[i]=3;
        i_hqm_cfg.ldb_pp_cq_cfg[i].cq_trfctrl = 3;
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S13: resume traffic set hqmproc_ldb_trfctrl[%0d]=3 and ldb_pp_cq_cfg[%0d].cq_trfctrl=3 to resum ENQ traffic of LDBPP %0d", i, i, i), OVM_MEDIUM);
     end
     if(has_ldbpp_other) i_hqm_cfg.hqmproc_ldb_trfctrl[ldbpp_other]=3;
     for(int i=dirpp_min; i<dirpp_max; i++) begin
        i_hqm_cfg.hqmproc_dir_trfctrl[i]=3;
        i_hqm_cfg.dir_pp_cq_cfg[i].cq_trfctrl = 3;
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_TASK_hqmproc_vasreset_task_main_S13: resume traffic set hqmproc_dir_trfctrl[%0d]=3 and dir_pp_cq_cfg[%0d].cq_trfctrl=3 to resum ENQ traffic of DIRPP %0d", i, i, i), OVM_MEDIUM);
     end

endtask: hqmproc_vasreset_task_main



//---------------------------------------------------------------------------------------------------------
//--
//---------------------------------------------------------------------------------------------------------
//---------------------------------
//-- rerun_cq_buffer_init
//---------------------------------
virtual task rerun_cq_buffer_init(int is_ldb, int cq_num, bit[63:0] cq_addr_hpa);
  sla_sm_env    sm;
  addr_t        addr;
  byte_t        data[$];
  bit           be[$];
  int           sparse_len;
  int           cq_depth;
  int           do_backdoor_write;


  `sla_assert($cast(sm,  sla_sm_env::get_ptr()),  ("Unable to get handle to SM."))
  data.delete();
  be.delete();

  do_backdoor_write = 1;
  sparse_len        = 1;
  cq_depth          = i_hqm_cfg.get_cq_depth(is_ldb, cq_num);
  addr              = cq_addr_hpa; //i_hqm_cfg.get_cq_hpa(is_ldb, pf_pp_cq_num);


  if(is_ldb==1) begin
     if($test$plusargs("HQM_LDB_CQ_SINGLE_HCW_PER_CL")) sparse_len = 4;
  end else begin
     if($test$plusargs("HQM_DIR_CQ_SINGLE_HCW_PER_CL")) sparse_len = 4;
  end

  `ovm_info(get_type_name(),$psprintf("HQMPROC_VASRST_rerun_cq_buffer_init: is_ldb %0d CQ 0x%0x cq_addr 0x%0x cq_depth %0d sparse_len %0d Start ", is_ldb, cq_num, cq_addr_hpa, cq_depth, sparse_len),OVM_LOW)

  for (int i = 0 ; i < 16 ; i++) begin
      data.push_back(0);
      be.push_back(1);
  end

  for (int i = 0 ; i < cq_depth*sparse_len ; i++) begin
    sm.do_write(addr,data,be,"",do_backdoor_write,"");
    addr += 16;
  end
  `ovm_info(get_type_name(),$psprintf("HQMPROC_VASRST_rerun_cq_buffer_init: is_ldb %0d CQ 0x%0x cq_addr 0x%0x cq_depth %0d sparse_len %0d Done ", is_ldb, cq_num, cq_addr_hpa, cq_depth, sparse_len),OVM_LOW)

endtask


//---------------------------------
//-- recfg_cqaddr_task_0
//---------------------------------
virtual task recfg_cqaddr_task_0(int is_ldb, int cq_num, bit[63:0] cq_addr_gpa); 
     sla_ral_data_t        rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];                
     bit [63:0]            old_cq_addr_gpa, new_cq_addr_gpa;         

     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_cqaddr_task_0_S0: is_ldb=%0d cq_num=%0d new cq_addr_gpa=0x%0x ", is_ldb, cq_num, cq_addr_gpa), OVM_MEDIUM);

     if(is_ldb) begin
         read_reg($psprintf("LDB_CQ_ADDR_U[%0d]",cq_num), rd_val, "hqm_system_csr");
         old_cq_addr_gpa[63:32]=rd_val;
         read_reg($psprintf("LDB_CQ_ADDR_L[%0d]",cq_num), rd_val1, "hqm_system_csr");
         old_cq_addr_gpa[31:0]=rd_val1;
         ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_cqaddr_task_0_S1: Read is_ldb=%0d cq_num=%0d old_cq_addr_gpa=0x%0x ", is_ldb, cq_num, old_cq_addr_gpa), OVM_MEDIUM);

         wr_val=cq_addr_gpa[63:32];
         write_reg($psprintf("LDB_CQ_ADDR_U[%0d]",cq_num), wr_val, "hqm_system_csr");
         wr_val1=cq_addr_gpa[31:0];
         write_reg($psprintf("LDB_CQ_ADDR_L[%0d]",cq_num), wr_val1, "hqm_system_csr");
         ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_cqaddr_task_0_S2: Write to is_ldb=%0d cq_num=%0d with cq_addr_gpa=0x%0x ", is_ldb, cq_num, cq_addr_gpa), OVM_MEDIUM);

         read_reg($psprintf("LDB_CQ_ADDR_U[%0d]",cq_num), rd_val, "hqm_system_csr");
         new_cq_addr_gpa[63:32]=rd_val;
         read_reg($psprintf("LDB_CQ_ADDR_L[%0d]",cq_num), rd_val1, "hqm_system_csr");
         new_cq_addr_gpa[31:0]=rd_val1;
         ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_cqaddr_task_0_S3: Read is_ldb=%0d cq_num=%0d new_cq_addr_gpa=0x%0x ", is_ldb, cq_num, new_cq_addr_gpa), OVM_MEDIUM);
     end else begin
         read_reg($psprintf("DIR_CQ_ADDR_U[%0d]",cq_num), rd_val, "hqm_system_csr");
         old_cq_addr_gpa[63:32]=rd_val;
         read_reg($psprintf("DIR_CQ_ADDR_L[%0d]",cq_num), rd_val1, "hqm_system_csr");
         old_cq_addr_gpa[31:0]=rd_val1;
         ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_cqaddr_task_0_S1: Read is_ldb=%0d cq_num=%0d old_cq_addr_gpa=0x%0x ", is_ldb, cq_num, old_cq_addr_gpa), OVM_MEDIUM);

         wr_val=cq_addr_gpa[63:32];
         write_reg($psprintf("DIR_CQ_ADDR_U[%0d]",cq_num), wr_val, "hqm_system_csr");
         wr_val1=cq_addr_gpa[31:0];
         write_reg($psprintf("DIR_CQ_ADDR_L[%0d]",cq_num), wr_val1, "hqm_system_csr");
         ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_cqaddr_task_0_S2: Write to is_ldb=%0d cq_num=%0d with cq_addr_gpa=0x%0x ", is_ldb, cq_num, cq_addr_gpa), OVM_MEDIUM);

         read_reg($psprintf("DIR_CQ_ADDR_U[%0d]",cq_num), rd_val, "hqm_system_csr");
         new_cq_addr_gpa[63:32]=rd_val;
         read_reg($psprintf("DIR_CQ_ADDR_L[%0d]",cq_num), rd_val1, "hqm_system_csr");
         new_cq_addr_gpa[31:0]=rd_val1;
         ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_cqaddr_task_0_S3: Read is_ldb=%0d cq_num=%0d new_cq_addr_gpa=0x%0x ", is_ldb, cq_num, new_cq_addr_gpa), OVM_MEDIUM);
     end

endtask: recfg_cqaddr_task_0



//---------------------------------
//-- recfg_hqm_system_pp_task_0
//---------------------------------
virtual task recfg_hqm_system_pp_task_0(int is_enable, int has_ldbpp_other, int ldbpp_other,  int ldbpp_min, int ldbpp_max, int dirpp_min, int dirpp_max); 
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];                

     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_pp_task_0: has_ldbpp_other=%0d ldbpp_other=%0d ldbpp_min=%0d ldbpp_max=%0d dirpp_min=%0d dirpp_max=%0d", has_ldbpp_other, ldbpp_other, ldbpp_min, ldbpp_max, dirpp_min, dirpp_max), OVM_MEDIUM);

     if(has_ldbpp_other) begin
        read_reg($psprintf("LDB_PP_V[%0d]",ldbpp_other), rd_val, "hqm_system_csr");
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_pp_task_0: hqm_system_csr.LDB_PP_V[%0d].rd=0x%0x ", ldbpp_other, rd_val), OVM_MEDIUM);
        wr_val=is_enable;	
        write_reg($psprintf("LDB_PP_V[%0d]",ldbpp_other), wr_val, "hqm_system_csr");
        read_reg($psprintf("LDB_PP_V[%0d]",ldbpp_other), rd_val, "hqm_system_csr");	
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_pp_task_0: hqm_system_csr.LDB_PP_V[%0d].recfg.rd=0x%0x ", ldbpp_other, rd_val), OVM_MEDIUM);
     end

     for(int i=ldbpp_min; i<ldbpp_max; i++) begin
        read_reg($psprintf("LDB_PP_V[%0d]",i), rd_val, "hqm_system_csr");
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_pp_task_0: hqm_system_csr.LDB_PP_V[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
        wr_val=is_enable;	
        write_reg($psprintf("LDB_PP_V[%0d]",i), wr_val, "hqm_system_csr");
        read_reg($psprintf("LDB_PP_V[%0d]",i), rd_val, "hqm_system_csr");	
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_pp_task_0: hqm_system_csr.LDB_PP_V[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
	
     end
     
     for(int i=dirpp_min; i<dirpp_max; i++) begin
        read_reg($psprintf("DIR_PP_V[%0d]",i), rd_val, "hqm_system_csr");
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_pp_task_0: hqm_system_csr.DIR_PP_V[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
        wr_val=is_enable;	
        write_reg($psprintf("DIR_PP_V[%0d]",i), wr_val, "hqm_system_csr");
        read_reg($psprintf("DIR_PP_V[%0d]",i), rd_val, "hqm_system_csr");	
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_pp_task_0: hqm_system_csr.DIR_PP_V[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
	
     end     
endtask: recfg_hqm_system_pp_task_0


//---------------------------------
//-- recfg_hqm_system_qid_task_0
//---------------------------------
virtual task recfg_hqm_system_qid_task_0(int is_enable, int ldbqid_min, int ldbqid_max, int dirqid_min, int dirqid_max); 
     sla_ral_data_t                rd_val, rd_val1, wr_val, wr_val1, wr_val_q[$];                
     
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_qid_task_0: ldbqid_min=%0d ldbqid_max=%0d dirqid_min=%0d dirqid_max=%0d", ldbqid_min, ldbqid_max, dirqid_min, dirqid_max), OVM_MEDIUM);

     for(int i=ldbqid_min; i<ldbqid_max; i++) begin
        read_reg($psprintf("LDB_QID_V[%0d]",i), rd_val, "hqm_system_csr");
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_qid_task_0: hqm_system_csr.LDB_QID_V[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
        wr_val=is_enable;	
        write_reg($psprintf("LDB_QID_V[%0d]",i), wr_val, "hqm_system_csr");
        read_reg($psprintf("LDB_QID_V[%0d]",i), rd_val, "hqm_system_csr");	
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_qid_task_0: hqm_system_csr.LDB_QID_V[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
	
     end
     
     for(int i=dirqid_min; i<dirqid_max; i++) begin
        read_reg($psprintf("DIR_QID_V[%0d]",i), rd_val, "hqm_system_csr");
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_qid_task_0: hqm_system_csr.DIR_QID_V[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
        wr_val=is_enable;	
        write_reg($psprintf("DIR_QID_V[%0d]",i), wr_val, "hqm_system_csr");
        read_reg($psprintf("DIR_QID_V[%0d]",i), rd_val, "hqm_system_csr");	
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_qid_task_0: hqm_system_csr.DIR_QID_V[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
	
     end     
   
endtask: recfg_hqm_system_qid_task_0


//---------------------------------
//-- cfgcheck_lsp_counter_task_poll
//---------------------------------
virtual task cfgcheck_lsp_counter_task_poll(int poll_wait, int ldbcq_min, int ldbcq_max, int ldbqid_min, int ldbqid_max, int dirqid_min, int dirqid_max); 
     sla_ral_data_t                rd_val, rd_val1, rd_val2, wr_val, wr_val1, wr_val_q[$];              
     int hqm_active_not_done;
 
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgcheck_lsp_counter_task_poll: poll_wait=%0d ldbcq_min=%0d ldbcq_max=%0d ldbqid_min=%0d ldbqid_max=%0d dirqid_min=%0d dirqid_max=%0d ", poll_wait, ldbcq_min, ldbcq_max, ldbqid_min, ldbqid_max, dirqid_min, dirqid_max), OVM_MEDIUM);

     if(poll_wait==1) begin
       hqm_active_not_done = 1;

       while(hqm_active_not_done) begin
         wait_idle (1000) ;		        
         cfgcheck_lsp_counter_task_0(ldbcq_min, ldbcq_max, ldbqid_min, ldbqid_max, dirqid_min, dirqid_max, hqm_active_not_done);

         ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgcheck_lsp_counter_task_poll: poll_wait=%0d hqm_active_not_done=%0d; ldbcq_min=%0d ldbcq_max=%0d ldbqid_min=%0d ldbqid_max=%0d dirqid_min=%0d dirqid_max=%0d ", poll_wait, hqm_active_not_done, ldbcq_min, ldbcq_max, ldbqid_min, ldbqid_max, dirqid_min, dirqid_max), OVM_MEDIUM);

       end
     end else begin
       cfgcheck_lsp_counter_task_0(ldbcq_min, ldbcq_max, ldbqid_min, ldbqid_max, dirqid_min, dirqid_max, hqm_active_not_done);
     end
endtask:cfgcheck_lsp_counter_task_poll 



virtual task cfgcheck_lsp_counter_task_0(input int ldbcq_min, int ldbcq_max, int ldbqid_min, int ldbqid_max, int dirqid_min, int dirqid_max, output int active_not_done); 
     sla_ral_data_t                rd_val, rd_val1, rd_val2, wr_val, wr_val1, wr_val_q[$];              
     int cq_ldb_inflight_not_done;
     int qid_active_not_done;
     int dir_enq_not_done; 
     int inflight_num;
 
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgcheck_lsp_counter_task_0_S1: ldbcq_min=%0d ldbcq_max=%0d ldbqid_min=%0d ldbqid_max=%0d dirqid_min=%0d dirqid_max=%0d ", ldbcq_min, ldbcq_max, ldbqid_min, ldbqid_max, dirqid_min, dirqid_max), OVM_MEDIUM);
      cq_ldb_inflight_not_done = 0;
      qid_active_not_done = 0;
      dir_enq_not_done = 0;
    
        for(int i=ldbcq_min; i<(ldbcq_max); i++) begin
          read_reg($psprintf("CFG_CQ_LDB_INFLIGHT_COUNT[%0d]",i), rd_val, "list_sel_pipe");
          inflight_num=rd_val;
          ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgcheck_lsp_counter_task_0_S2:  CFG_CQ_LDB_INFLIGHT_COUNT[%0d].rd_val=0x%0x inflight_num=%0d", i, rd_val, inflight_num), OVM_MEDIUM);
          if(rd_val!=0) begin
             if($test$plusargs("has_vasrst_rtntrf")) begin 
                ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgcheck_lsp_counter_task_0_S3: ldbcq=%0d inflight_num=%0d - call start_return_traffic", i, inflight_num), OVM_MEDIUM);
                start_return_traffic(1, i, inflight_num, inflight_num);
                ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgcheck_lsp_counter_task_0_S4: ldbcq=%0d inflight_num=%0d - done start_return_traffic, break this loop with cq_ldb_inflight_not_done=1", i, inflight_num), OVM_MEDIUM);
             end
             cq_ldb_inflight_not_done=1;
             break;
          end
        end

        for(int i=ldbqid_min; i<(ldbqid_max); i++) begin
           read_reg($psprintf("CFG_QID_LDB_ENQUEUE_COUNT[%0d]",i), rd_val, "list_sel_pipe");
           read_reg($psprintf("CFG_QID_AQED_ACTIVE_COUNT[%0d]",i), rd_val1, "list_sel_pipe");
           read_reg($psprintf("CFG_QID_ATM_ACTIVE[%0d]",i), rd_val2, "list_sel_pipe");
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgcheck_lsp_counter_task_0_S10: CFG_QID_LDB_ENQUEUE_COUNT[%0d].rd_val=0x%0x CFG_QID_AQED_ACTIVE_COUNT[%0d].rd_val=0x%0x CFG_QID_ATM_ACTIVE[%0d].rd_val=0x%0x", i, rd_val, i, rd_val1, i, rd_val2 ), OVM_MEDIUM);
           if(rd_val!=0 || rd_val1!=0 || rd_val2!=0 ) begin
             qid_active_not_done=1;
             break;
           end
        end

        for(int i=dirqid_min; i<(dirqid_max); i++) begin
           read_reg($psprintf("CFG_QID_DIR_ENQUEUE_COUNT[%0d]",i), rd_val, "list_sel_pipe");
           inflight_num=rd_val;
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgcheck_lsp_counter_task_0_S20: CFG_QID_DIR_ENQUEUE_COUNT[%0d].rd_val=0x%0x inflight_num=%0d", i, rd_val, inflight_num), OVM_MEDIUM);
           if(rd_val!=0) begin
              if($test$plusargs("has_vasrst_rtntrf")) begin 
                 ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgcheck_lsp_counter_task_0_S21: dircq=%0d inflight_num=%0d - call start_return_traffic", i, inflight_num), OVM_MEDIUM);
                 start_return_traffic(1, i, inflight_num, 0);
                 ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgcheck_lsp_counter_task_0_S22: dircq=%0d inflight_num=%0d - done start_return_traffic, break this loop with dir_enq_not_done=1", i, inflight_num), OVM_MEDIUM);
              end

              dir_enq_not_done=1;
              break;
           end
        end
    
        if(cq_ldb_inflight_not_done || qid_active_not_done || dir_enq_not_done) begin
           active_not_done = 1;
           ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgcheck_lsp_counter_task_0_SDone: cq_ldb_inflight_not_done=%0d qid_active_not_done=%0d dir_enq_not_done=%0d => active_not_done=1",cq_ldb_inflight_not_done,qid_active_not_done, dir_enq_not_done ), OVM_MEDIUM);
        end
endtask:cfgcheck_lsp_counter_task_0 

//---------------------------------
//-- cfgpoll_lsp_ldbcq_counter_task_0
//---------------------------------
virtual task cfgpoll_lsp_ldbcq_counter_task_0(int ldbcq_min, int ldbcq_max ); 
     int     cfgpoll_timeout_num;                        
     int     has_done;
     
     cfgpoll_timeout_num=100;
     $value$plusargs("hqmproc_cfgpoll_lspcnt_timeout_num=%d", cfgpoll_timeout_num);
 
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbcq_counter_task_0: ldbcq_min=%0d ldbcq_max=%0d cfgpoll_timeout_num=%0d", ldbcq_min, ldbcq_max,cfgpoll_timeout_num ), OVM_MEDIUM);


         for(int i=ldbcq_min; i<ldbcq_max; i++) begin
            cfgpoll_lsp_ldbcq_counter_task_1(i, cfgpoll_timeout_num, has_done);
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbcq_counter_task_0_ldbcq=%0d has_done=%0d ldbcq_min=%0d ldbcq_max=%0d", i, has_done, ldbcq_min, ldbcq_max), OVM_MEDIUM);
         end
         ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbcq_counter_task_0_has_done=%0d: ldbcq_min=%0d ldbcq_max=%0d", has_done, ldbcq_min, ldbcq_max), OVM_MEDIUM);

endtask:cfgpoll_lsp_ldbcq_counter_task_0 

//-- cfgpoll_lsp_ldbcq_counter_task_1
virtual task cfgpoll_lsp_ldbcq_counter_task_1(int ldbcq_idx, int timeout_num, output int has_done); 
     sla_ral_data_t                rd_val, rd_val1, rd_val2, wr_val, wr_val1, wr_val_q[$];              
     int     cfgpoll_timeout_cnt;                        
   
     has_done=0;
     cfgpoll_timeout_cnt=0;
     rd_val=0;
     
     read_reg($psprintf("CFG_CQ_LDB_INFLIGHT_COUNT[%0d]",ldbcq_idx), rd_val, "list_sel_pipe");
     if(rd_val==0) has_done=1;
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbcq_counter_task_1: start to poll ldbcq=%0d CFG_CQ_LDB_INFLIGHT_COUNT[%0d].rd_val=0x%0x", ldbcq_idx, ldbcq_idx, rd_val), OVM_MEDIUM);
     while(rd_val>0) begin
         wait_idle (100) ;		        

         read_reg($psprintf("CFG_CQ_LDB_INFLIGHT_COUNT[%0d]",ldbcq_idx), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbcq_counter_task_1: ldbcq=%0d rd_val=0x%0x cfgpoll_timeout_cnt=%0d has_done=%0d", ldbcq_idx, rd_val, cfgpoll_timeout_cnt, has_done ), OVM_MEDIUM);

         if(rd_val==0) begin
            has_done=1;
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbcq_counter_task_1_done_break: ldbcq=%0d cfgpoll_timeout_cnt=%0d has_done=%0d", ldbcq_idx, cfgpoll_timeout_cnt, has_done ), OVM_MEDIUM);
            break;
         end 

         cfgpoll_timeout_cnt++;
         if(cfgpoll_timeout_cnt>timeout_num) begin
              ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbcq_counter_task_1_timeout_break: ldbcq=%0d cfgpoll_timeout_cnt=%0d reach timeout_num=%0d", ldbcq_idx, cfgpoll_timeout_cnt, timeout_num ), OVM_MEDIUM);
              break;
         end

     end//--while
endtask: cfgpoll_lsp_ldbcq_counter_task_1


//---------------------------------
//-- cfgpoll_lsp_ldbqid_counter_task_0
//---------------------------------
virtual task cfgpoll_lsp_ldbqid_counter_task_0(int ldbqid_min, int ldbqid_max); 
     int     cfgpoll_timeout_num;                        
     int     has_done;
     
     cfgpoll_timeout_num=100;
     $value$plusargs("hqmproc_cfgpoll_lspcnt_timeout_num=%d", cfgpoll_timeout_num);
 
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbqid_counter_task_0: ldbqid_min=%0d ldbqid_max=%0d cfgpoll_timeout_num=%0d", ldbqid_min, ldbqid_max,cfgpoll_timeout_num ), OVM_MEDIUM);


         for(int i=ldbqid_min; i<ldbqid_max; i++) begin
            cfgpoll_lsp_ldbqid_counter_task_1(i, cfgpoll_timeout_num, has_done);
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbqid_counter_task_0_ldbqid=%0d has_done=%0d ldbqid_min=%0d ldbqid_max=%0d", i, has_done, ldbqid_min, ldbqid_max), OVM_MEDIUM);
         end
         ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbqid_counter_task_0_has_done=%0d: ldbqid_min=%0d ldbqid_max=%0d", has_done, ldbqid_min, ldbqid_max), OVM_MEDIUM);

endtask:cfgpoll_lsp_ldbqid_counter_task_0 

//-- cfgpoll_lsp_ldbqid_counter_task_1
virtual task cfgpoll_lsp_ldbqid_counter_task_1(int ldbqid_idx, int timeout_num, output int has_done); 
     sla_ral_data_t                rd_val, rd_val1, rd_val2, wr_val, wr_val1, wr_val_q[$];              
     int     cfgpoll_timeout_cnt;                        
   
     has_done=0;
     cfgpoll_timeout_cnt=0;
     rd_val=0;
     rd_val1=0;
     rd_val2=0;
     read_reg($psprintf("CFG_QID_LDB_ENQUEUE_COUNT[%0d]",ldbqid_idx), rd_val, "list_sel_pipe");
     read_reg($psprintf("CFG_QID_AQED_ACTIVE_COUNT[%0d]",ldbqid_idx), rd_val1, "list_sel_pipe");
     read_reg($psprintf("CFG_QID_ATM_ACTIVE[%0d]",ldbqid_idx), rd_val2, "list_sel_pipe");
     if(rd_val==0 && rd_val1==0 && rd_val2==0) has_done=1;
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbqid_counter_task_1: start to poll ldbcq=%0d CFG_QID_LDB_ENQUEUE_COUNT[%0d].rd_val=0x%0x CFG_QID_AQED_ACTIVE_COUNT[%0d].rd_val=0x%0x CFG_QID_ATM_ACTIVE[%0d].rd_val=0x%0x", ldbqid_idx, ldbqid_idx, rd_val, ldbqid_idx, rd_val1, ldbqid_idx, rd_val2 ), OVM_MEDIUM);
     
     while(rd_val>0 || rd_val1>0 || rd_val2>0) begin
         wait_idle (100) ;		        

         read_reg($psprintf("CFG_QID_LDB_ENQUEUE_COUNT[%0d]",ldbqid_idx), rd_val, "list_sel_pipe");
         read_reg($psprintf("CFG_QID_AQED_ACTIVE_COUNT[%0d]",ldbqid_idx), rd_val1, "list_sel_pipe");
         read_reg($psprintf("CFG_QID_ATM_ACTIVE[%0d]",ldbqid_idx), rd_val2, "list_sel_pipe");

         if(rd_val==0 && rd_val1==0 && rd_val2==0) begin
            has_done=1;
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbqid_counter_task_1_done_break: ldbqid=%0d cfgpoll_timeout_cnt=%0d has_done=%0d", ldbqid_idx, cfgpoll_timeout_cnt, has_done ), OVM_MEDIUM);
            break;
         end 

         cfgpoll_timeout_cnt++;
         if(cfgpoll_timeout_cnt>timeout_num) begin
              ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbqid_counter_task_1_timeout_break: ldbqid=%0d cfgpoll_timeout_cnt=%0d reach timeout_num=%0d", ldbqid_idx, cfgpoll_timeout_cnt, timeout_num ), OVM_MEDIUM);
              break;
         end

     end//--while
endtask: cfgpoll_lsp_ldbqid_counter_task_1


//---------------------------------
//-- cfgpoll_lsp_dirqid_counter_task_0
//---------------------------------
virtual task cfgpoll_lsp_dirqid_counter_task_0(int dirqid_min, int dirqid_max); 
     int     cfgpoll_timeout_num;                        
     int     has_done;
     
     cfgpoll_timeout_num=100;
     $value$plusargs("hqmproc_cfgpoll_lspcnt_timeout_num=%d", cfgpoll_timeout_num);
 
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_dirqid_counter_task_0: dirqid_min=%0d dirqid_max=%0d cfgpoll_timeout_num=%0d", dirqid_min, dirqid_max,cfgpoll_timeout_num ), OVM_MEDIUM);


         for(int i=dirqid_min; i<dirqid_max; i++) begin
            cfgpoll_lsp_dirqid_counter_task_1(i, cfgpoll_timeout_num, has_done);
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_dirqid_counter_task_0_dirqid=%0d has_done=%0d dirqid_min=%0d dirqid_max=%0d", i, has_done, dirqid_min, dirqid_max), OVM_MEDIUM);
         end
         ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_dirqid_counter_task_0_has_done=%0d: dirqid_min=%0d dirqid_max=%0d", has_done, dirqid_min, dirqid_max), OVM_MEDIUM);

endtask:cfgpoll_lsp_dirqid_counter_task_0 

//-- cfgpoll_lsp_dirqid_counter_task_1
virtual task cfgpoll_lsp_dirqid_counter_task_1(int dirqid_idx, int timeout_num, output int has_done); 
     sla_ral_data_t                rd_val, rd_val1, rd_val2, wr_val, wr_val1, wr_val_q[$];              
     int     cfgpoll_timeout_cnt;                        
   
     has_done=0;
     cfgpoll_timeout_cnt=0;
     rd_val=0;
     rd_val1=0;
     rd_val2=0;
     
     read_reg($psprintf("CFG_QID_DIR_ENQUEUE_COUNT[%0d]",dirqid_idx), rd_val, "list_sel_pipe");
     if(rd_val==0) has_done=1;
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_dirqid_counter_task_1: start to poll dirqid=%0d CFG_QID_DIR_ENQUEUE_COUNT[%0d].rd_val=0x%0x", dirqid_idx, dirqid_idx, rd_val), OVM_MEDIUM);

     while(rd_val>0) begin
         wait_idle (100) ;		        

         read_reg($psprintf("CFG_QID_DIR_ENQUEUE_COUNT[%0d]",dirqid_idx), rd_val, "list_sel_pipe");

         if(rd_val==0) begin
            has_done=1;
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_dirqid_counter_task_1_done_break: dirqid=%0d cfgpoll_timeout_cnt=%0d has_done=%0d", dirqid_idx, cfgpoll_timeout_cnt, has_done ), OVM_MEDIUM);
            break;
         end 

         cfgpoll_timeout_cnt++;
         if(cfgpoll_timeout_cnt>timeout_num) begin
              ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_dirqid_counter_task_1_timeout_break: dirqid=%0d cfgpoll_timeout_cnt=%0d reach timeout_num=%0d", dirqid_idx, cfgpoll_timeout_cnt, timeout_num ), OVM_MEDIUM);
              break;
         end

     end//--while
endtask: cfgpoll_lsp_dirqid_counter_task_1



//---------------------------------
//-- recfg_lsp_ldbqid_counter_clear_task_0
//---------------------------------
virtual task recfg_lsp_ldbqid_counter_clear_task_0(int ldbqid_min, int ldbqid_max); 
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];              
     
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_lsp_ldbqid_counter_clear_task_0: ldbqid_min=%0d ldbqid_max=%0d start", ldbqid_min, ldbqid_max), OVM_MEDIUM);


     for(int i=ldbqid_min; i<ldbqid_max; i++) begin
        read_reg($psprintf("CFG_QID_ATM_TOT_ENQ_CNTL[%0d]",i), rd_val, "list_sel_pipe");
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_qid_task_0: list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTL[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
        wr_val=0;	
        write_reg($psprintf("CFG_QID_ATM_TOT_ENQ_CNTL[%0d]",i), wr_val, "list_sel_pipe");
        read_reg($psprintf("CFG_QID_ATM_TOT_ENQ_CNTL[%0d]",i), rd_val, "list_sel_pipe");	
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_qid_task_0: list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTL[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

        read_reg($psprintf("CFG_QID_NALDB_TOT_ENQ_CNTL[%0d]",i), rd_val, "list_sel_pipe");
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_qid_task_0: list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTL[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
        wr_val=0;	
        write_reg($psprintf("CFG_QID_NALDB_TOT_ENQ_CNTL[%0d]",i), wr_val, "list_sel_pipe");
        read_reg($psprintf("CFG_QID_NALDB_TOT_ENQ_CNTL[%0d]",i), rd_val, "list_sel_pipe");	
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_qid_task_0: list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTL[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
     end
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_lsp_ldbqid_counter_clear_task_0: ldbqid_min=%0d ldbqid_max=%0d done",ldbqid_min, ldbqid_max), OVM_MEDIUM);

endtask:recfg_lsp_ldbqid_counter_clear_task_0 


//---------------------------------
//-- recfg_lsp_ldbcq_counter_clear_task_0
//---------------------------------
virtual task recfg_lsp_ldbcq_counter_clear_task_0(int ldbcq_min, int ldbcq_max); 
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];              
     
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_lsp_ldbcq_counter_clear_task_0: ldbcq_min=%0d ldbcq_max=%0d start", ldbcq_min, ldbcq_max), OVM_MEDIUM);


     for(int i=ldbcq_min; i<ldbcq_max; i++) begin
        read_reg($psprintf("CFG_CQ_LDB_TOT_SCH_CNTL[%0d]",i), rd_val, "list_sel_pipe");
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_ldbcq_task_0: list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTL[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
        wr_val=0;	
        write_reg($psprintf("CFG_CQ_LDB_TOT_SCH_CNTL[%0d]",i), wr_val, "list_sel_pipe");
        read_reg($psprintf("CFG_CQ_LDB_TOT_SCH_CNTL[%0d]",i), rd_val, "list_sel_pipe");	
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_pp_task_0: list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTL[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
     end
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_ldbcq_counter_task_0: ldbcq_min=%0d ldbcq_max=%0d done",ldbcq_min, ldbcq_max), OVM_MEDIUM);

endtask:recfg_lsp_ldbcq_counter_clear_task_0 


//---------------------------------
//-- recfg_lsp_dirqid_counter_clear_task_0
//---------------------------------
virtual task recfg_lsp_dirqid_counter_clear_task_0(int dirqid_min, int dirqid_max); 
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];              
     
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_lsp_dirqid_counter_clear_task_0: dirqid_min=%0d dirqid_max=%0d start", dirqid_min, dirqid_max), OVM_MEDIUM);


     for(int i=dirqid_min; i<dirqid_max; i++) begin
        read_reg($psprintf("CFG_QID_DIR_TOT_ENQ_CNTL[%0d]",i), rd_val, "list_sel_pipe");
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_dirqid_task_0: list_sel_pipe.CFG_QID_DIR_TOT_ENQ_CNTL[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
        wr_val=0;	
        write_reg($psprintf("CFG_QID_DIR_TOT_ENQ_CNTL[%0d]",i), wr_val, "list_sel_pipe");
        read_reg($psprintf("CFG_QID_DIR_TOT_ENQ_CNTL[%0d]",i), rd_val, "list_sel_pipe");	
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_pp_task_0: list_sel_pipe.CFG_QID_DIR_TOT_ENQ_CNTL[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
     end
     ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_cfgpoll_lsp_dirqid_counter_task_0: dirqid_min=%0d dirqid_max=%0d done",dirqid_min, dirqid_max), OVM_MEDIUM);

endtask:recfg_lsp_dirqid_counter_clear_task_0 



//---------------------------------
//-- recfg_hqm_system_after_vas_reset
//---------------------------------
virtual task recfg_hqm_system_after_vas_reset(int vas_min, int vas_max, int dirpp_min, int dirpp_max, int dirqid_min, int dirqid_max, int ldbqid_min, int ldbqid_max, int ldbpp_min, int ldbpp_max, int ldbcq_min, int ldbcq_max, int has_ldbpp_other, int ldbpp_other );
     sla_ral_data_t                rd_val, wr_val, wr_val1, wr_val_q[$];              
     bit cq_generation;
     int vas_recfg_cnt;
 
     cq_generation=0;
     $value$plusargs("hqmproc_vasrstrecfg_cq_gen=%d", cq_generation);
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset: cq_generation=%0d",  cq_generation), OVM_MEDIUM);
     vas_recfg_cnt=4096;
     $value$plusargs("hqmproc_vascredit_recfg_cnt=%d", vas_recfg_cnt);
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset: vas_recfg_cnt=%0d",  vas_recfg_cnt), OVM_MEDIUM);


    if($test$plusargs("has_vasrst_reprogram")) begin 

       //-----------------------------------------------------------------------
        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S0:  traffic set hqm_proc_vasrst_comp=1 and relative hqmproc_vasrst_ldbcq/hqmproc_vasrst_dircq=1...."), OVM_MEDIUM);
        i_hqm_cfg.hqm_proc_vasrst_comp=1;

        for(int i=ldbpp_min; i<ldbpp_max; i++) begin
          i_hqm_cfg.hqmproc_vasrst_ldbcq[i]=1;
        end
        if(has_ldbpp_other) i_hqm_cfg.hqmproc_vasrst_ldbcq[ldbpp_other]=1;
        for(int i=dirpp_min; i<dirpp_max; i++) begin
          i_hqm_cfg.hqmproc_vasrst_dircq[i]=1;
        end

        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S1: vas_min=%0d vas_max=%0d start to reprogram VAS credit_cnt", vas_min, vas_max), OVM_MEDIUM);
        for(int i=vas_min; i<vas_max; i++) begin
            read_reg($psprintf("CFG_VAS_CREDIT_COUNT[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S1: credit_hist_pipe.CFG_VAS_CREDIT_COUNT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            if($test$plusargs("hqmproc_vascredit_recfg_cnt")) begin
               i_hqm_cfg.vas_cfg[i].credit_cnt=vas_recfg_cnt; 
            end
            //--TB
            i_hqm_cfg.i_hqm_pp_cq_status.set_vas_credits(i, i_hqm_cfg.vas_cfg[i].credit_cnt);
            //--RTL
            wr_val=i_hqm_cfg.vas_cfg[i].credit_cnt;	
            //--1014_fix wr_val=rd_val; //-- LSP could have QE in ENQ, consider such case, reassign rd_val to CFG_VAS_CREDIT_COUNT[];	

            write_reg($psprintf("CFG_VAS_CREDIT_COUNT[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_VAS_CREDIT_COUNT[%0d]",i), rd_val, "credit_hist_pipe");	
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S1: credit_hist_pipe.CFG_VAS_CREDIT_COUNT[%0d].recfg.rd=0x%0x vas_recfg_cnt=%0d", i, rd_val, vas_recfg_cnt), OVM_MEDIUM);
        end //for(int i=vas_min; i<vas_max

        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S2: ldbqid_min=%0d ldbqid_max=%0d start to reprogram QID", ldbqid_min, ldbqid_max), OVM_MEDIUM);
        for(int i=ldbqid_min; i<ldbqid_max; i++) begin
            //--LSP.CFG_QID_AQED_ACTIVE_LIMIT
            read_reg($psprintf("CFG_QID_AQED_ACTIVE_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S2: list_sel_pipe.CFG_QID_AQED_ACTIVE_LIMIT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_QID_AQED_ACTIVE_LIMIT[%0d]",i), '{"LIMIT"}, '{i_hqm_cfg.ldb_qid_cfg[i].aqed_freelist_limit - i_hqm_cfg.ldb_qid_cfg[i].aqed_freelist_base + 1},  "list_sel_pipe");  
            read_reg($psprintf("CFG_QID_AQED_ACTIVE_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S2: list_sel_pipe.CFG_QID_AQED_ACTIVE_LIMIT[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--LSP.CFG_QID_LDB_INFLIGHT_LIMIT
            read_reg($psprintf("CFG_QID_LDB_INFLIGHT_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S2: list_sel_pipe.CFG_QID_LDB_INFLIGHT_LIMIT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_QID_LDB_INFLIGHT_LIMIT[%0d]",i), '{"LIMIT"}, '{i_hqm_cfg.ldb_qid_cfg[i].qid_ldb_inflight_limit},  "list_sel_pipe");  
            read_reg($psprintf("CFG_QID_LDB_INFLIGHT_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S2: list_sel_pipe.CFG_QID_LDB_INFLIGHT_LIMIT[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--CHP.CFG_ORD_QID_SN_MAP
            read_reg($psprintf("CFG_ORD_QID_SN_MAP[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S2: credit_hist_pipe.CFG_ORD_QID_SN_MAP[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);

        end


        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: ldbcq_min=%0d ldbcq_max=%0d start to reprogram CQ", ldbcq_min, ldbcq_max), OVM_MEDIUM);
        for(int i=ldbcq_min; i<ldbcq_max; i++) begin
            //--cq_depth
            read_reg($psprintf("CFG_CQ_LDB_TOKEN_DEPTH_SELECT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: list_sel_pipe.CFG_CQ_LDB_TOKEN_DEPTH_SELECT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_CQ_LDB_TOKEN_DEPTH_SELECT[%0d]",i), '{"TOKEN_DEPTH_SELECT"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].cq_depth},  "list_sel_pipe");  
            read_reg($psprintf("CFG_CQ_LDB_TOKEN_DEPTH_SELECT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: list_sel_pipe.CFG_CQ_LDB_TOKEN_DEPTH_SELECT[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            read_reg($psprintf("CFG_LDB_CQ_TOKEN_DEPTH_SELECT[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_LDB_CQ_TOKEN_DEPTH_SELECT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_LDB_CQ_TOKEN_DEPTH_SELECT[%0d]",i), '{"TOKEN_DEPTH_SELECT"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].cq_depth},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_LDB_CQ_TOKEN_DEPTH_SELECT[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_LDB_CQ_TOKEN_DEPTH_SELECT[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--i_hqm_pp_cq_status.set_cq_tokens
            i_hqm_cfg.i_hqm_pp_cq_status.set_cq_tokens(1'b1, i, 1 << (i_hqm_cfg.ldb_pp_cq_cfg[i].cq_depth + 2));


            //--clear credit_hist_pipe.CFG_LDB_CQ_DEPTH[]
            read_reg($psprintf("CFG_LDB_CQ_DEPTH[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_LDB_CQ_DEPTH[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_LDB_CQ_DEPTH[%0d]",i), '{"DEPTH"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].cq_token_count},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_LDB_CQ_DEPTH[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_LDB_CQ_DEPTH[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--clear credit_hist_pipe.CFG_LDB_CQ_WPTR[]
            read_reg($psprintf("CFG_LDB_CQ_WPTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_LDB_CQ_WPTR[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            wr_val=0;
	    write_reg($psprintf("CFG_LDB_CQ_WPTR[%0d]",i), wr_val, "credit_hist_pipe");
	    read_reg($psprintf("CFG_LDB_CQ_WPTR[%0d]",i), rd_val, "credit_hist_pipe");
	    ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_LDB_CQ_WPTR[%0d].recfgclear.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--clear list_sel_pipe.CFG_CQ_LDB_TOKEN_COUNT[]
            read_reg($psprintf("CFG_CQ_LDB_TOKEN_COUNT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: list_sel_pipe.CFG_CQ_LDB_TOKEN_COUNT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            wr_val=0;
	    write_reg($psprintf("CFG_CQ_LDB_TOKEN_COUNT[%0d]",i), wr_val, "list_sel_pipe");
	    read_reg($psprintf("CFG_CQ_LDB_TOKEN_COUNT[%0d]",i), rd_val, "list_sel_pipe");
	    ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: list_sel_pipe.CFG_CQ_LDB_TOKEN_COUNT[%0d].recfgclear.rd=0x%0x ", i, rd_val), OVM_MEDIUM);


            //---------------------------
            //-- recfg HIST_LIST
            //---------------------------
            //-- CFG_HIST_LIST_BASE
            read_reg($psprintf("CFG_HIST_LIST_BASE[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_BASE[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_HIST_LIST_BASE[%0d]",i), '{"BASE"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_HIST_LIST_BASE[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_BASE[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--A CFG_HIST_LIST_A_BASE
            read_reg($psprintf("CFG_HIST_LIST_A_BASE[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_A_BASE[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_HIST_LIST_A_BASE[%0d]",i), '{"BASE"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_HIST_LIST_A_BASE[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_A_BASE[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);


            //-- CFG_HIST_LIST_LIMIT
            read_reg($psprintf("CFG_HIST_LIST_LIMIT[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_LIMIT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_HIST_LIST_LIMIT[%0d]",i), '{"LIMIT"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_limit},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_HIST_LIST_LIMIT[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_LIMIT[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--A CFG_HIST_LIST_A_LIMIT
            read_reg($psprintf("CFG_HIST_LIST_A_LIMIT[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_A_LIMIT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_HIST_LIST_A_LIMIT[%0d]",i), '{"LIMIT"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_limit},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_HIST_LIST_A_LIMIT[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_A_LIMIT[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--CFG_HIST_LIST_POP_PTR
            read_reg($psprintf("CFG_HIST_LIST_POP_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_POP_PTR[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
           
            write_fields($psprintf("CFG_HIST_LIST_POP_PTR[%0d]",i), '{"POP_PTR"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base},  "credit_hist_pipe");  
            write_fields($psprintf("CFG_HIST_LIST_POP_PTR[%0d]",i), '{"GENERATION"}, '{cq_generation},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_HIST_LIST_POP_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_POP_PTR[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            wr_val=0;
            wr_val[13]=cq_generation; //--
            wr_val[12:0]=i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base;
	    write_reg($psprintf("CFG_HIST_LIST_POP_PTR[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_HIST_LIST_POP_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_POP_PTR[%0d].recfg2.rd=0x%0x wr_val=0x%0x i_hqm_cfg.ldb_pp_cq_cfg[%0d].hist_list_base=0x%0x ", i, rd_val, wr_val, i, i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base), OVM_MEDIUM);

            //--CFG_HIST_LIST_A_POP_PTR
            read_reg($psprintf("CFG_HIST_LIST_A_POP_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_A_POP_PTR[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
           
            write_fields($psprintf("CFG_HIST_LIST_A_POP_PTR[%0d]",i), '{"POP_PTR"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base},  "credit_hist_pipe");  
            write_fields($psprintf("CFG_HIST_LIST_A_POP_PTR[%0d]",i), '{"GENERATION"}, '{cq_generation},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_HIST_LIST_A_POP_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_A_POP_PTR[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            wr_val=0;
            wr_val[13]=cq_generation; //--
            wr_val[12:0]=i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base;
	    write_reg($psprintf("CFG_HIST_LIST_A_POP_PTR[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_HIST_LIST_A_POP_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_A_POP_PTR[%0d].recfg2.rd=0x%0x wr_val=0x%0x i_hqm_cfg.ldb_pp_cq_cfg[%0d].hist_list_base=0x%0x ", i, rd_val, wr_val, i, i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base), OVM_MEDIUM);


            //--CFG_HIST_LIST_PUSH_PTR
            read_reg($psprintf("CFG_HIST_LIST_PUSH_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_PUSH_PTR[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_HIST_LIST_PUSH_PTR[%0d]",i), '{"PUSH_PTR"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base},  "credit_hist_pipe");  
            write_fields($psprintf("CFG_HIST_LIST_PUSH_PTR[%0d]",i), '{"GENERATION"}, '{cq_generation},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_HIST_LIST_PUSH_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_PUSH_PTR[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            wr_val=0;
            wr_val[13]=cq_generation; //--
            wr_val[12:0]=i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base;
	    write_reg($psprintf("CFG_HIST_LIST_PUSH_PTR[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_HIST_LIST_PUSH_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_PUSH_PTR[%0d].recfg2.rd=0x%0x wr_val=0x%0x i_hqm_cfg.ldb_pp_cq_cfg[%0d].hist_list_base=0x%0x ", i, rd_val, wr_val, i, i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base), OVM_MEDIUM);

            //--CFG_HIST_LIST_A_PUSH_PTR
            read_reg($psprintf("CFG_HIST_LIST_A_PUSH_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_A_PUSH_PTR[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_HIST_LIST_A_PUSH_PTR[%0d]",i), '{"PUSH_PTR"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base},  "credit_hist_pipe");  
            write_fields($psprintf("CFG_HIST_LIST_A_PUSH_PTR[%0d]",i), '{"GENERATION"}, '{cq_generation},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_HIST_LIST_A_PUSH_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_A_PUSH_PTR[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            wr_val=0;
            wr_val[13]=cq_generation; //--
            wr_val[12:0]=i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base;
	    write_reg($psprintf("CFG_HIST_LIST_A_PUSH_PTR[%0d]",i), wr_val, "credit_hist_pipe");
            read_reg($psprintf("CFG_HIST_LIST_A_PUSH_PTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: credit_hist_pipe.CFG_HIST_LIST_A_PUSH_PTR[%0d].recfg2.rd=0x%0x wr_val=0x%0x i_hqm_cfg.ldb_pp_cq_cfg[%0d].hist_list_base=0x%0x ", i, rd_val, wr_val, i, i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base), OVM_MEDIUM);




            //--lsp CFG_CQ_LDB_INFLIGHT_LIMIT
            read_reg($psprintf("CFG_CQ_LDB_INFLIGHT_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: list_sel_pipe.CFG_CQ_LDB_INFLIGHT_LIMIT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_CQ_LDB_INFLIGHT_LIMIT[%0d]",i), '{"LIMIT"}, '{i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_limit - i_hqm_cfg.ldb_pp_cq_cfg[i].hist_list_base + 1},  "list_sel_pipe");  
            read_reg($psprintf("CFG_CQ_LDB_INFLIGHT_LIMIT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S3: list_sel_pipe.CFG_CQ_LDB_INFLIGHT_LIMIT[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--
        end


        ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S4: dirpp_min=%0d dirpp_max=%0d start to reprogram CQ", dirpp_min, dirpp_max), OVM_MEDIUM);
        for(int i=dirpp_min; i<dirpp_max; i++) begin
            //--cq_depth
            read_reg($psprintf("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S4: list_sel_pipe.CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[%0d]",i), '{"TOKEN_DEPTH_SELECT"}, '{i_hqm_cfg.dir_pp_cq_cfg[i].cq_depth},  "list_sel_pipe");  
            read_reg($psprintf("CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S4: list_sel_pipe.CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            read_reg($psprintf("CFG_DIR_CQ_TOKEN_DEPTH_SELECT[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S4: credit_hist_pipe.CFG_DIR_CQ_TOKEN_DEPTH_SELECT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_DIR_CQ_TOKEN_DEPTH_SELECT[%0d]",i), '{"TOKEN_DEPTH_SELECT"}, '{i_hqm_cfg.dir_pp_cq_cfg[i].cq_depth},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_DIR_CQ_TOKEN_DEPTH_SELECT[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S4: credit_hist_pipe.CFG_DIR_CQ_TOKEN_DEPTH_SELECT[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--i_hqm_pp_cq_status.set_cq_tokens
            i_hqm_cfg.i_hqm_pp_cq_status.set_cq_tokens(1'b0, i, 1 << (i_hqm_cfg.dir_pp_cq_cfg[i].cq_depth + 2));

            //--clear credit_hist_pipe.CFG_DIR_CQ_DEPTH[]
            read_reg($psprintf("CFG_DIR_CQ_DEPTH[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S4: credit_hist_pipe.CFG_DIR_CQ_DEPTH[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            write_fields($psprintf("CFG_DIR_CQ_DEPTH[%0d]",i), '{"DEPTH"}, '{i_hqm_cfg.dir_pp_cq_cfg[i].cq_token_count},  "credit_hist_pipe");  
            read_reg($psprintf("CFG_DIR_CQ_DEPTH[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S4: credit_hist_pipe.CFG_DIR_CQ_DEPTH[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--clear credit_hist_pipe.CFG_DIR_CQ_WPTR[]
            read_reg($psprintf("CFG_DIR_CQ_WPTR[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S4: credit_hist_pipe.CFG_DIR_CQ_WPTR[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            wr_val=0;
	    write_reg($psprintf("CFG_DIR_CQ_WPTR[%0d]",i), wr_val, "credit_hist_pipe");
	    read_reg($psprintf("CFG_DIR_CQ_WPTR[%0d]",i), rd_val, "credit_hist_pipe");
	    ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S4: credit_hist_pipe.CFG_DIR_CQ_WPTR[%0d].recfgclear.rd=0x%0x ", i, rd_val), OVM_MEDIUM);

            //--clear list_sel_pipe.CFG_CQ_DIR_TOKEN_COUNT[]
            read_reg($psprintf("CFG_CQ_DIR_TOKEN_COUNT[%0d]",i), rd_val, "list_sel_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S4: list_sel_pipe.CFG_CQ_DIR_TOKEN_COUNT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            wr_val=0;
	    write_reg($psprintf("CFG_CQ_DIR_TOKEN_COUNT[%0d]",i), wr_val, "list_sel_pipe");
	    read_reg($psprintf("CFG_CQ_DIR_TOKEN_COUNT[%0d]",i), rd_val, "list_sel_pipe");
	    ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset_S4: list_sel_pipe.CFG_CQ_DIR_TOKEN_COUNT[%0d].recfgclear.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
        end

    end else begin
       ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset: vas_min=%0d vas_max=%0d skip reprogram", vas_min, vas_max), OVM_MEDIUM);
        for(int i=vas_min; i<vas_max; i++) begin
            read_reg($psprintf("CFG_VAS_CREDIT_COUNT[%0d]",i), rd_val, "credit_hist_pipe");
            ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset: credit_hist_pipe.CFG_VAS_CREDIT_COUNT[%0d].rd=0x%0x ", i, rd_val), OVM_MEDIUM);
            //--TB
            //i_hqm_cfg.i_hqm_pp_cq_status.set_vas_credits(i, i_hqm_cfg.vas_cfg[i].credit_cnt);
            //--RTL
            //wr_val=i_hqm_cfg.vas_cfg[i].credit_cnt;	
            //write_reg($psprintf("CFG_VAS_CREDIT_COUNT[%0d]",i), wr_val, "credit_hist_pipe");
            //read_reg($psprintf("CFG_VAS_CREDIT_COUNT[%0d]",i), rd_val, "credit_hist_pipe");	
            //ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_recfg_hqm_system_after_vas_reset: credit_hist_pipe.CFG_VAS_CREDIT_COUNT[%0d].recfg.rd=0x%0x ", i, rd_val), OVM_MEDIUM);
         end//for
    end//--if
endtask:recfg_hqm_system_after_vas_reset


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
virtual task start_return_traffic(int is_ldb, int cq_num, int tok_num, int comp_num);       
      
`ifdef IP_TYP_TE
      string           hcw_rtn_string;
      string           cfg_cmds[$];
      bit [63:0]       cnt;

      ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_start_return_traffic: Start is_ldb=%0d cq_num=%0d tok_num=%0d comp_num=%0d ", is_ldb, cq_num, tok_num, comp_num), OVM_MEDIUM);
      if(is_ldb) begin
         if(tok_num>0) begin
            hcw_rtn_string = $psprintf("HCW LDB:%0d qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x00%h msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x321", cq_num, tok_num-1);
            cfg_cmds.push_back(hcw_rtn_string);
            `ovm_info(get_name(), $psprintf("HQMPROC_VASRST_start_return_traffic:  HCW RTN TOK string:%s", hcw_rtn_string), OVM_NONE);
         end
         for(int i=0; i<comp_num; i++) begin
            hcw_rtn_string = $psprintf("HCW LDB:%0d qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=0 meas=0 lockid=0 msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x123", cq_num);
            cfg_cmds.push_back(hcw_rtn_string);
            `ovm_info(get_name(), $psprintf("HQMPROC_VASRST_start_return_traffic:  HCW RTN COMP string:%s", hcw_rtn_string), OVM_NONE);
         end
      end else begin
         if(tok_num>0) begin
            hcw_rtn_string = $psprintf("HCW DIR:%0d qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x00%h msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x321", cq_num, tok_num-1);
            cfg_cmds.push_back(hcw_rtn_string);
            `ovm_info(get_name(), $psprintf("HQMPROC_VASRST_start_return_traffic:  HCW RTN TOK string:%s", hcw_rtn_string), OVM_NONE);
         end
      end

      ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_start_return_traffic: to send cfg_cmds.size=%0d ", cfg_cmds.size()), OVM_MEDIUM);
      while (cfg_cmds.size()) begin
          bit         do_cfg_seq;
          hqm_cfg_seq cfg_seq;
          string      cmd;

          cmd = cfg_cmds.pop_front();
          i_hqm_cfg.set_cfg(cmd, do_cfg_seq);
          if (do_cfg_seq) begin
            `ovm_create(cfg_seq)
            cfg_seq.pre_body();
            start_item(cfg_seq);
            finish_item(cfg_seq);
            cfg_seq.post_body();
          end
      end
      ovm_report_info(get_type_name(),$psprintf("HQMPROC_VASRST_start_return_traffic: Done is_ldb=%0d cq_num=%0d tok_num=%0d comp_num=%0d ", is_ldb, cq_num, tok_num, comp_num), OVM_MEDIUM);

`endif
endtask : start_return_traffic

