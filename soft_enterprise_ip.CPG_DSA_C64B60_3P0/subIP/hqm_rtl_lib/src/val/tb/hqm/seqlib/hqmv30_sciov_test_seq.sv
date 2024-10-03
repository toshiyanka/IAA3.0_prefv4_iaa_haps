//------------------------------------------------------------------------------
//-- SCIOV test
//------------------------------------------------------------------------------
`ifndef HQMV30_SCIOV__TEST__SEQ
`define HQMV30_SCIOV__TEST__SEQ

class hqmv30_sciov_test_seq  extends hqm_base_seq;

    `ovm_object_utils(hqmv30_sciov_test_seq)

    hqm_cfg               i_hqm_cfg;
    hqm_tb_hcw_scoreboard i_hcw_scoreboard;
    hqm_pp_cq_status      i_hqm_pp_cq_status;

    hqm_integ_seq_pkg::hcw_sciov_test_hqm_cfg_seq                   hcw_sciov_cfg_seq;
    hqm_integ_seq_pkg::hcw_sciov_test_hcw2_seq                      hcw_sciov_traffic_seq;
    rand hqm_integ_seq_pkg::hcw_sciov_test_hqm_cfg_seq_stim_config  hcw_sciov_cfg_stim_cfg;
    rand hqm_integ_seq_pkg::hcw_sciov_test_hcw2_seq_stim_config     hcw_sciov_traffic_stim_cfg;
    hqm_integ_seq_pkg::hqm_cfg_reset_seq                            hqm_cfg_reset_seq;   

    hqm_tb_cfg_file_mode_seq                                        i_file_mode_pre_seq;
    hqm_tb_cfg_file_mode_seq                                        i_file_mode_seq;

    string       inst_suffix=""; 
    string       tb_env_hier="*";

    bit[31:0]    hqm_cq_page_space;
    bit[63:0]    decode_cq_hpa_base; 

    bit          ldb_pasid_priv_mode, dir_pasid_priv_mode;
    bit          ldb_pasid_exe_req, dir_pasid_exe_req;
    bit          ldb_pasid_ena, dir_pasid_ena;
    bit[22:0]    ldb_pasid_rnd_min, ldb_pasid_rnd_max;
    bit[22:0]    dir_pasid_rnd_min, dir_pasid_rnd_max;
  

    int          dir_page_size;
    int          ldb_page_size;

    int          dir_page_num;
    int          ldb_page_num;

    int          number_of_iterations, number_of_check_status;
    int          flrwait_num0, flrwait_num1, flrwait_num2;


    // -----------------------------------------------------
    // Constructor
    // -----------------------------------------------------
    function new (string name = "hqmv30_sciov_test_seq");
        super.new(name);
        hcw_sciov_cfg_stim_cfg     = hqm_integ_seq_pkg::hcw_sciov_test_hqm_cfg_seq_stim_config::type_id::create("hcw_sciov_test_hqm_cfg_seq_stim_config");
        hcw_sciov_traffic_stim_cfg = hqm_integ_seq_pkg::hcw_sciov_test_hcw2_seq_stim_config::type_id::create("hcw_sciov_test_hcw2_seq_stim_config");

        number_of_iterations = 1;
        $value$plusargs("HQMTEST_PF_TRF_ROUND=%0d", number_of_iterations); 

        number_of_check_status = 10;
        $value$plusargs("HQMTEST_PCIE_STATUS_CK_NUM=%0d", number_of_check_status); 

        flrwait_num0 = 5;
        $value$plusargs("HQMTEST_FLR_WAIT_NUM_0=%0d", flrwait_num0); 

        flrwait_num1 = 20;
        $value$plusargs("HQMTEST_FLR_WAIT_NUM_1=%0d", flrwait_num1); 

        flrwait_num2 = 70;
        $value$plusargs("HQMTEST_FLR_WAIT_NUM_2=%0d", flrwait_num2); 
  
        `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt number_of_iterations=%0d number_of_check_status=%0d flrwait_num0=%0d flrwait_num1=%0d flrwait_num2=%0d",number_of_iterations, number_of_check_status, flrwait_num0, flrwait_num1, flrwait_num2),OVM_LOW);

        hqm_cq_page_space = 32'h200000;
        if($value$plusargs("HQM_CQ_PAGE_SPACE=0x%x", hqm_cq_page_space))
           `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt HQM_CQ_PAGE_SPACE=0x%0x",hqm_cq_page_space),OVM_LOW);

        dir_pasid_ena=0;
        if($value$plusargs("HQMTEST_DIR_PASID_ENA=%d", dir_pasid_ena))
           `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt HQMTEST_DIR_PASID_ENA=%0d",dir_pasid_ena),OVM_LOW);

        ldb_pasid_ena=0;
        if($value$plusargs("HQMTEST_LDB_PASID_ENA=%d", ldb_pasid_ena))
           `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt HQMTEST_LDB_PASID_ENA=%0d",ldb_pasid_ena),OVM_LOW);

        //-- when dir_pasid_rnd_min=0 and dir_pasid_rnd_max=0, use HQM's pasid_q 
        dir_pasid_rnd_min=0;
        if($value$plusargs("HQMTEST_DIR_PASID_MIN=%h", dir_pasid_rnd_min))
           `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt HQMTEST_DIR_PASID_MIN=0x%0x",dir_pasid_rnd_min),OVM_LOW);

        dir_pasid_rnd_max=0;
        if($value$plusargs("HQMTEST_DIR_PASID_MAX=%h", dir_pasid_rnd_max))
           `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt HQMTEST_DIR_PASID_MAX=0x%0x",dir_pasid_rnd_max),OVM_LOW);

        //-- when ldb_pasid_rnd_min=0 and ldb_pasid_rnd_max=0, use HQM's pasid_q 
        ldb_pasid_rnd_min=0;
        if($value$plusargs("HQMTEST_LDB_PASID_MIN=%h", ldb_pasid_rnd_min))
           `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt HQMTEST_LDB_PASID_MIN=0x%0x",ldb_pasid_rnd_min),OVM_LOW);

        ldb_pasid_rnd_max=0;
        if($value$plusargs("HQMTEST_LDB_PASID_MAX=%h", ldb_pasid_rnd_max))
           `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt HQMTEST_LDB_PASID_MAX=0x%0x",ldb_pasid_rnd_max),OVM_LOW);

        //-- page size control
        dir_page_size=1;
        if($value$plusargs("HQMTEST_DIR_PAGESIZE=%d", dir_page_size))
           `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt HQMTEST_DIR_PAGESIZE=0x%0x",dir_page_size),OVM_LOW);

        ldb_page_size=1;
        if($value$plusargs("HQMTEST_LDB_PAGESIZE=%d", ldb_page_size))
           `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt HQMTEST_LDB_PAGESIZE=0x%0x",ldb_page_size),OVM_LOW);

        `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: Setting dir_page_size=%0d ldb_page_size=%0d", dir_page_size, ldb_page_size), OVM_NONE);

        //-- page number control
        dir_page_num=1;
        if($value$plusargs("HQMTEST_DIR_PAGENUM=%d", dir_page_num))
           `ovm_info(get_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt HQMTEST_DIR_PAGENUM=0x%0x",dir_page_num),OVM_LOW);

        ldb_page_num = 1;
        if($value$plusargs("HQMTEST_LDB_PAGENUM=%d", ldb_page_num))
          `ovm_info(get_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Opt HQMTEST_LDB_PAGENUM=0x%0x",ldb_page_num),OVM_LOW);

       `ovm_info(get_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: Setting dir_page_num=%0d ldb_page_num=%0d", dir_page_num, ldb_page_num), OVM_NONE);

    endfunction : new

  
// -----------------------------------------------------
// body
// -----------------------------------------------------
virtual task body();
    ovm_object   o_tmp;
    bit          has_pb_run;
    int          flrwait_num_val;
    bit[22:0]    ldb_pasid_val,dir_pasid_val;
    bit[22:0]    ldb_pasid_val_tmp,dir_pasid_val_tmp;
      
    bit [22:0] pasid_val;
    bit [31:0] mem_size_val;
    bit [63:0] cq_addr_gpa_val;
    bit [63:0] cq_addr_hpa_val;
    int        ldbcq_per_page;
    int        dircq_per_page;
    int        ldbcq_idx;
    int        dircq_idx;


    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hqm_cfg",inst_suffix}, o_tmp)) begin
       ovm_report_info(get_full_name(), "HQMV30_SCIOV_TEST__SEQ: Unable to find i_hqm_cfg object", OVM_LOW);
       i_hqm_cfg = null;
    end else begin
       if (!$cast(i_hqm_cfg, o_tmp)) begin
         ovm_report_fatal(get_full_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
       end
    end

    
    //-----------------------------
    //-- get i_hcw_scoreboard
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hcw_scoreboard",inst_suffix}, o_tmp)) begin
       ovm_report_info(get_full_name(), "HQMV30_SCIOV_TEST__SEQ: Unable to find i_hcw_scoreboard object", OVM_LOW);
       i_hcw_scoreboard = null;
    end else begin
       if (!$cast(i_hcw_scoreboard, o_tmp)) begin
         ovm_report_fatal(get_full_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
       end
    end

    //-----------------------------
    // -- get i_hqm_pp_cq_status
    //-----------------------------
    if ( p_sequencer.get_config_object({"i_hqm_pp_cq_status",inst_suffix}, o_tmp) ) begin
        if ( ! ($cast(i_hqm_pp_cq_status, o_tmp)) ) begin
            ovm_report_fatal(get_full_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: Object passed through i_hqm_pp_cq_status not compatible with class type hqm_pp_cq_status"));
        end 
    end else begin
        ovm_report_info(get_full_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: No i_hqm_pp_cq_status set through set_config_object"));
        i_hqm_pp_cq_status = null;
    end

    //-----------------------------

    `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: HQM SIOV Test Sequence Started: inst_suffix=%0s tb_env_hier=%0s hqm_cq_page_space=0x%0x; dir_pasid_ena=%0d ldb_pasid_ena=%0d; dir_page_size=%0d ldb_page_size=%0d", inst_suffix, tb_env_hier, hqm_cq_page_space, dir_pasid_ena, ldb_pasid_ena, dir_page_size, ldb_page_size), OVM_NONE);

    //--------------------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------------------
    for(int iteration_cnt=0;iteration_cnt < number_of_iterations; iteration_cnt++) begin
       `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ_S0: HQM SIOV Test Sequence start with iteration_cnt=%0d", iteration_cnt), OVM_LOW);
        //----------------------------------------------
        //-- FLR only
        //----------------------------------------------
        if($test$plusargs("HQMTEST_FLR_ENA") && iteration_cnt==1) begin
          if($test$plusargs("HQMTEST_FLR_TEST_0") ) begin
              //----------------------------------------------
              //----------------------------------------------
              //------------------ FLR first
              repeat(flrwait_num0) #100ns;
             `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST__SEQ_F0.2_1: FLR_3 Start to issue FLR - iteration_cnt=%0d after flrwait_num0=%0d ", iteration_cnt, flrwait_num0), OVM_NONE)
              setup_hqm_flr(1, number_of_check_status);

             `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST__SEQ_F0.2_2: FLR_3 Wait FLR - iteration_cnt=%0d flrwait_num1=%0d ", iteration_cnt, flrwait_num1), OVM_NONE)
              repeat(flrwait_num1) #100ns;

              //------------------ ATS_INV second
              if($test$plusargs("HQMTEST_ATS_INV")) begin
                 if($test$plusargs("HQMTEST_D0D3_ATS_INV")) begin
                    `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST__SEQ_F0.2_3: FLR_3 PM->D3  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
                     hqm_pmcsr_ps_cfg(3, flrwait_num0);
                 end

                `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST__SEQ_F0.2_4: FLR_3 Issue ats_invalidation_task  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
                 ats_invalidation_task();

                 if($test$plusargs("HQMTEST_D3D0_ATS_INV")) begin
                    `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST__SEQ_F0.2_5: FLR_3 PM->D0  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
                     hqm_pmcsr_ps_cfg(0, flrwait_num0);
                 end
                 repeat(flrwait_num1) #100ns;
              end else begin
                 `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST__SEQ_F0.2_Skip: FLR_3 Skip ats_invalidation_task  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
              end//if($test$plusargs("HQMTEST_ATS_INV"))

          end else if($test$plusargs("HQMTEST_FLR_TEST_1") ) begin
              //----------------------------------------------
              //----------------------------------------------
              fork
              begin
                 //------------------ ATS_INV fork
                 if($test$plusargs("HQMTEST_ATS_INV")) begin
                    flrwait_num_val = $urandom_range(flrwait_num0, flrwait_num2);
                   `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.1_ATSINV: FLR_3_fork_1.0 wait %0d to send ats_invalidation_task  - iteration_cnt=%0d", flrwait_num_val*100, iteration_cnt), OVM_NONE)
                    repeat(flrwait_num_val) #100ns;

                   `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.1_ATSINV: FLR_3_fork_1.1 Issue ats_invalidation_task  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
                    ats_invalidation_task();

                    repeat(flrwait_num1) #100ns;
                   `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.1_ATSINV: FLR_3_fork_1.done ATSINV - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
                 end else begin
                    `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.1_Skip: FLR_3_fork Skip ats_invalidation_task  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
                 end//if($test$plusargs("HQMTEST_ATS_INV"))
              end

              begin
                 //------------------ FLR_fork
                 if($test$plusargs("HQMTEST_D0D3_ATS_INV")) begin
                    `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.1_FLR: FLR_3_fork_2.0 PM->D3  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
                     hqm_pmcsr_ps_cfg(3, flrwait_num0);
                 end

                 flrwait_num_val = $urandom_range(0, flrwait_num0);
                 repeat(flrwait_num_val) #10ns;
                `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.1_FLR: FLR_3_fork_2.1 Start to issue FLR - iteration_cnt=%0d after wait %0d ", iteration_cnt, flrwait_num_val*10), OVM_NONE)
                 setup_hqm_flr(1, number_of_check_status);

                 if($test$plusargs("HQMTEST_D3D0_ATS_INV")) begin
                    `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.1_FLR: FLR_3_fork_2.2 PM->D0  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
                     hqm_pmcsr_ps_cfg(0, flrwait_num0);
                 end

                `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.1_FLR: FLR_3_fork_2.2 Wait FLR - iteration_cnt=%0d flrwait_num1=%0d ", iteration_cnt, flrwait_num1), OVM_NONE)
                 repeat(flrwait_num1) #100ns;
                `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.1_FLR: FLR_3_fork_2.done  FLR - iteration_cnt=%0d", iteration_cnt), OVM_NONE)
              end
              join

          end else begin
              //----------------------------------------------
              //----------------------------------------------
              //------------------ ATS_INV first
              if($test$plusargs("HQMTEST_ATS_INV")) begin
                 if($test$plusargs("HQMTEST_D0D3_ATS_INV")) begin
                    `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.0_1: FLR_3_T0 PM->D3  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
                     hqm_pmcsr_ps_cfg(3, flrwait_num0);
                 end

                `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.0_2: FLR_3_T0 Issue ats_invalidation_task  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
                 ats_invalidation_task();

                 if($test$plusargs("HQMTEST_D3D0_ATS_INV")) begin
                    `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.0_3: FLR_3_T0 PM->D0  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
                     hqm_pmcsr_ps_cfg(0, flrwait_num0);
                 end
                 repeat(flrwait_num1) #100ns;
              end else begin
                 `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.0_Skip: FLR_3_T0 Skip ats_invalidation_task  - iteration_cnt=%0d ", iteration_cnt), OVM_NONE)
              end//if($test$plusargs("HQMTEST_ATS_INV"))

              //------------------ FLR second 
              //repeat(flrwait_num0) #100ns;
             `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.0_4: FLR_3_T0 Start to issue FLR - iteration_cnt=%0d after flrwait_num0=%0d ", iteration_cnt, flrwait_num0), OVM_NONE)
              setup_hqm_flr(1, number_of_check_status);

             `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST_F.0_5: FLR_3_T0 Wait FLR - iteration_cnt=%0d flrwait_num1=%0d ", iteration_cnt, flrwait_num1), OVM_NONE)
              //repeat(flrwait_num1) #100ns;

          end//if($test$plusargs("HQMTEST_FLR_TEST0")


          if($test$plusargs("HQMTEST_CFG_RESET")) begin
             `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST__SEQ_F0.3: FLR_3 Issue hqm_cfg_reset_seq - iteration_cnt=%0d", iteration_cnt), OVM_NONE)
             `ovm_create(hqm_cfg_reset_seq)
              hqm_cfg_reset_seq.inst_suffix = inst_suffix;
             `ovm_rand_send(hqm_cfg_reset_seq)   
          end else begin
             `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST__SEQ_F0.3: FLR_4 Skip hqm_cfg_reset_seq - iteration_cnt=%0d", iteration_cnt), OVM_NONE)
          end


          i_hqm_cfg.hqm_trf_loop++;
          `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST__SEQ_F0.4: FLR_5 hqm_cfg.hqm_trf_loop - iteration_cnt=%0d hqm_cfg.hqm_trf_loop=%0d", iteration_cnt, i_hqm_cfg.hqm_trf_loop), OVM_NONE)
        end//--FLR 

        //----------------------------------------------
        // config hqm PF/CSR bar and etc 
        //----------------------------------------------
        `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ_S1: HQM SIOV config_hqm Sarted"), OVM_LOW);
        config_hqm();

        //----------------------------------------------
        // stim cfg 
        //----------------------------------------------
         //Setting the stim config instance suffix and hier
         hcw_sciov_traffic_stim_cfg.inst_suffix = inst_suffix;
         hcw_sciov_traffic_stim_cfg.tb_env_hier = tb_env_hier;

         //Randomizing stim configs
         hcw_sciov_cfg_stim_cfg.randomize();
         hcw_sciov_traffic_stim_cfg.randomize();

         //loading default values 
         load_default_stim_cfg_variables();
         //loading test overide values 
         load_test_overide_stim_cfg_variables();
        

         //----------------------------------------------
         // HCW SCIOV config sequence 
         //----------------------------------------------
         `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ_S2: HQM SIOV HCW Config Sequence Sarted"), OVM_LOW);
 
         `ovm_create(hcw_sciov_cfg_seq)
          hcw_sciov_cfg_seq.inst_suffix = inst_suffix;
          hcw_sciov_cfg_seq.cfg.rand_mode(0); //disabling the ip sequence stim config randomization. Cluster stim config overriden 
          hcw_sciov_cfg_seq.cfg = hcw_sciov_cfg_stim_cfg;
         `ovm_rand_send_with(hcw_sciov_cfg_seq, {cfg==hcw_sciov_cfg_stim_cfg;})
         `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ_S2.1: HQM SIOV HCW Config Sequence ended"), OVM_LOW);
        


          if($test$plusargs("HQMTEST_CQADDR_REALLOC")) begin
              //----------------------------------------------
              // HCW SCIOV traffic sequence 
              //----------------------------------------------
              //-- allocate_dram to get a CQ address 
              decode_cq_hpa_base=allocate_dram("HQM_CQ_MEM_ALL", hqm_cq_page_space, hqm_cq_page_space-1); //'h3f // alignment_mask=length-1,
              `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ_S2.2: HQM SIOV Get GPA Addr Sarted with hqm_cq_page_space=0x%0x: decode_cq_hpa_base=0x%0x", hqm_cq_page_space, decode_cq_hpa_base), OVM_LOW);


              //-------------------------
              //-- support cq_address 
              //-------------------------
              if(hcw_sciov_cfg_stim_cfg.num_dir_pp>0) begin
        	  for (int idx = 0 ; idx < hcw_sciov_cfg_stim_cfg.num_dir_pp; idx++) begin
        	    dir_pasid_val = hcw_sciov_cfg_stim_cfg.dir_pasid_q[idx];
        	    `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ_S2.3: HQM SIOV PASID: hcw_sciov_cfg_stim_cfg.dir_pasid_q[%0d] dir_pasid_val=0x%0x", idx, dir_pasid_val), OVM_LOW);

                    dir_pasid_ena       = dir_pasid_val[22]; //--anyan_tmp_08202021 
        	    dir_pasid_priv_mode = dir_pasid_val[21];
        	    dir_pasid_exe_req   = dir_pasid_val[20];

        	    //--has_pb_run
        	    if($test$plusargs("LEGACY_MODE") && $test$plusargs("IOMMU_CTX_TT_PT") && $test$plusargs("IOMMU_CTX_GENONCE")) begin
                	  if(idx==0) has_pb_run = 1;
                	  else       has_pb_run = 0; 
        	    end else begin
                	  has_pb_run = 1; 
        	    end

        	    `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: HQM SIOV Get hcw_sciov_traffic_stim_cfg.dir_cq_hpa_addr_q[%0d]=0x%0x dir_cq_addr_q[%0d]=0x%0x, dir_pasid_val=0x%0x, dir_page_size=%0d", idx, hcw_sciov_traffic_stim_cfg.dir_cq_hpa_addr_q[idx], idx, hcw_sciov_traffic_stim_cfg.dir_cq_addr_q[idx], dir_pasid_val, dir_page_size), OVM_LOW);
        	  end
              end

              if(hcw_sciov_cfg_stim_cfg.num_ldb_pp>0) begin
        	  for (int idx = 0 ; idx < hcw_sciov_cfg_stim_cfg.num_ldb_pp; idx++) begin
        	    ldb_pasid_val = hcw_sciov_cfg_stim_cfg.ldb_pasid_q[idx];
        	   `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: HQM SIOV PASID: hcw_sciov_cfg_stim_cfg.ldb_pasid_q[%0d] ldb_pasid_val=0x%0x", idx, ldb_pasid_val), OVM_LOW);

                    ldb_pasid_ena       = ldb_pasid_val[22]; //--anyan_tmp_08202021 
        	    ldb_pasid_priv_mode = ldb_pasid_val[21];
        	    ldb_pasid_exe_req   = ldb_pasid_val[20];

        	    //--has_pb_run
        	    if($test$plusargs("LEGACY_MODE") && $test$plusargs("IOMMU_CTX_TT_PT") && $test$plusargs("IOMMU_CTX_GENONCE")) begin
                	  has_pb_run = 0;
        	    end else begin
                	  has_pb_run = 1; 
        	    end

        	    `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: HQM SIOV Get hcw_sciov_traffic_stim_cfg.ldb_cq_hpa_addr_q[%0d]=0x%0x ldb_cq_addr_q[%0d]=0x%0x, ldb_pasid_val=0x%0x, ldb_page_size=%0d", idx, hcw_sciov_traffic_stim_cfg.ldb_cq_hpa_addr_q[idx], idx, hcw_sciov_traffic_stim_cfg.ldb_cq_addr_q[idx], ldb_pasid_val, ldb_page_size), OVM_LOW);
        	  end
              end
          end //if($test$plusargs("HQMTEST_CQADDR_REALLOC")) 


            //----------------------------------------------
            // Programming hqm_cfg cq_gpa/cq_hpa/cq_pasgesize/pasid  
            // Programming CQ_ADDR, PASID register
            //----------------------------------------------
            //----------------------------------------------
         `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ3: HQM SIOV HCW Before Traffic Sequence Started iteration_cnt=%0d", iteration_cnt), OVM_NONE);
             if(hcw_sciov_traffic_stim_cfg.ldb_cq_base_addr_ctl==1) begin
                //----------
                //--LDB CQs
                //----------
                pasid_val = $urandom_range('h400000,'h4fffff);
                if(ldb_page_size==1)      mem_size_val = 'h20_0000;   //2Mpage
                else if(ldb_page_size==2) mem_size_val = 'h4000_0000; //1Gpage
                else                      mem_size_val = 'h1000;      //4Kpage

                ldbcq_per_page = hcw_sciov_cfg_stim_cfg.num_ldb_pp / ldb_page_num;

                `ovm_info(get_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ3.1: HQM SIOV LDBCQS Call decode_vas_gpa with ldb_page_num=%0d mem_size=0x%0x pasid=0x%0x, ldbcq_per_page=%0d", ldb_page_num, mem_size_val, pasid_val, ldbcq_per_page), OVM_LOW);
                for(int pnum=0; pnum<ldb_page_num; pnum++) begin 
                    i_hqm_cfg.decode_vas_gpa(.mem_name($psprintf("HQM%s_LDBCQS_%0d_PGALLOCMEM", i_hqm_cfg.inst_suffix, pnum*(iteration_cnt+1))),
                                         .mem_size(mem_size_val),
                                         .mem_mask(mem_size_val-1),
                                         .vas(pnum),
                                         .pasid(pasid_val),
                                         .vas_addr_gpa(cq_addr_gpa_val),
                                         .vas_addr_hpa(cq_addr_hpa_val));
                   `ovm_info(get_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ3.2: HQM SIOV LDBCQS Page%0d decode_vas_gpa with mem_size=0x%0x pasid=0x%0x returned virtual addr cq_addr_gpa_val=0x%0x and physical addr cq_addr_hpa_val=0x%0x", pnum, mem_size_val, pasid_val, cq_addr_gpa_val, cq_addr_hpa_val), OVM_LOW);

                   if(hcw_sciov_cfg_stim_cfg.num_ldb_pp>0) begin
                       //for(int idx=0; idx<hcw_sciov_cfg_stim_cfg.num_ldb_pp; idx++) begin
                       for(int idx=0; idx<ldbcq_per_page; idx++) begin
                          ldbcq_idx = pnum * ldbcq_per_page + idx;
                          hcw_sciov_traffic_stim_cfg.ldb_cq_addr_q[ldbcq_idx]     = cq_addr_gpa_val + 'h1000 * idx;
                          hcw_sciov_traffic_stim_cfg.ldb_cq_hpa_addr_q[ldbcq_idx] = cq_addr_hpa_val + 'h1000 * idx;
                          hcw_sciov_traffic_stim_cfg.ldb_cq_pagesize_q[ldbcq_idx] = ldb_page_size; //1: 2M 
                          hcw_sciov_traffic_stim_cfg.ldb_cq_pasid_q[ldbcq_idx]    = pasid_val;
                         `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ3.3: HQM SIOV LDBCQS Traffic setting: hcw_sciov_traffic_stim_cfg.ldb_cq_hpa_addr_q[%0d]=0x%0x ldb_cq_addr_q[%0d]=0x%0x", ldbcq_idx, hcw_sciov_traffic_stim_cfg.ldb_cq_hpa_addr_q[ldbcq_idx], ldbcq_idx, hcw_sciov_traffic_stim_cfg.ldb_cq_addr_q[ldbcq_idx]), OVM_NONE);

                          if(idx==0) begin
                             hcw_sciov_traffic_stim_cfg.ldb_cq_base_addr       = cq_addr_gpa_val;
                             hcw_sciov_traffic_stim_cfg.ldb_cq_hpa_base_addr   = cq_addr_hpa_val;
                             hcw_sciov_traffic_stim_cfg.ldb_cq_space           = 'h1000;
                          end
                       end
                   end
                end//--for(pnum
             end//if(hcw_sciov_traffic_stim_cfg.ldb_cq_base_addr_ctl) 

             if(hcw_sciov_traffic_stim_cfg.dir_cq_base_addr_ctl==1) begin
                //----------
                //--DIR CQs
                //----------
                pasid_val = $urandom_range('h400000,'h4fffff);
                if(dir_page_size==1)      mem_size_val = 'h20_0000;   //2Mpage
                else if(dir_page_size==2) mem_size_val = 'h4000_0000; //1Gpage
                else                      mem_size_val = 'h1000;      //4Kpage

                dircq_per_page = hcw_sciov_cfg_stim_cfg.num_dir_pp / dir_page_num;
                `ovm_info(get_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ3.4: HQM SIOV DIRCQS Call decode_vas_gpa with dir_page_num=%0d mem_size=0x%0x pasid=0x%0x, dircq_per_page=%0d", dir_page_num, mem_size_val, pasid_val, dircq_per_page), OVM_LOW);

                for(int pnum=0; pnum<dir_page_num; pnum++) begin 
                    i_hqm_cfg.decode_vas_gpa(.mem_name($psprintf("HQM%s_DIRCQS_%0d_PGALLOCMEM", i_hqm_cfg.inst_suffix, (pnum+ldb_page_num)*(iteration_cnt+1))),
                                         .mem_size(mem_size_val),
                                         .mem_mask(mem_size_val-1),
                                         .vas(pnum+ldb_page_num),
                                         .pasid(pasid_val),
                                         .vas_addr_gpa(cq_addr_gpa_val),
                                         .vas_addr_hpa(cq_addr_hpa_val));
                   `ovm_info(get_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ3.4: HQM SIOV DIRCQS Page%0d decode_vas_gpa with mem_size=0x%0x pasid=0x%0x returned virtual addr cq_addr_gpa_val=0x%0x and physical addr cq_addr_hpa_val=0x%0x", pnum, mem_size_val, pasid_val, cq_addr_gpa_val, cq_addr_hpa_val), OVM_LOW);

                
                   if(hcw_sciov_cfg_stim_cfg.num_dir_pp>0) begin
                       //for(int idx=0; idx<hcw_sciov_cfg_stim_cfg.num_dir_pp; idx++) begin
                       for(int idx=0; idx<dircq_per_page; idx++) begin
                          dircq_idx = pnum * dircq_per_page + idx;

                          hcw_sciov_traffic_stim_cfg.dir_cq_addr_q[dircq_idx]     = cq_addr_gpa_val + 'h1000 * idx;
                          hcw_sciov_traffic_stim_cfg.dir_cq_hpa_addr_q[dircq_idx] = cq_addr_hpa_val + 'h1000 * idx;
                          hcw_sciov_traffic_stim_cfg.dir_cq_pagesize_q[dircq_idx] = dir_page_size; //1: 2M 
                          hcw_sciov_traffic_stim_cfg.dir_cq_pasid_q[dircq_idx]    = pasid_val;
                         `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ3.5: HQM SIOV DIRCQS Page%0d Traffic setting: hcw_sciov_traffic_stim_cfg.dir_cq_hpa_addr_q[%0d]=0x%0x dir_cq_addr_q[%0d]=0x%0x", pnum, dircq_idx, hcw_sciov_traffic_stim_cfg.dir_cq_hpa_addr_q[dircq_idx], dircq_idx, hcw_sciov_traffic_stim_cfg.dir_cq_addr_q[dircq_idx]), OVM_NONE);

                          if(idx==0) begin
                             hcw_sciov_traffic_stim_cfg.dir_cq_base_addr       = cq_addr_gpa_val;
                             hcw_sciov_traffic_stim_cfg.dir_cq_hpa_base_addr   = cq_addr_hpa_val;
                             hcw_sciov_traffic_stim_cfg.dir_cq_space           = 'h1000;
                          end
                       end
                    end
                end//--for(pnum)
             end//if(hcw_sciov_traffic_stim_cfg.dir_cq_base_addr_ctl) 
    

         //----------------------------------------------
         // HCW SCIOV TRaffic sequence 
         //----------------------------------------------
         //-------------------------
         `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ_S4: HQM SIOV HCW Traffic Sequence Sarted"), OVM_LOW);
         `ovm_create(hcw_sciov_traffic_seq)
          hcw_sciov_traffic_seq.cfg.rand_mode(0);
          hcw_sciov_traffic_seq.cfg = hcw_sciov_traffic_stim_cfg;
         `ovm_rand_send_with(hcw_sciov_traffic_seq, {cfg==hcw_sciov_traffic_stim_cfg;})
         `ovm_info(get_type_name(), $sformatf("HQMV30_SCIOV_TEST__SEQ_S4: Finished executing hcw_sciov_traffic_seq"), OVM_NONE)

         `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ_S5: HQM SIOV Test Sequence Ended with iteration_cnt=%0d", iteration_cnt), OVM_LOW);
        
    end //for(int iteration_cnt=0;iteration_cnt < number_of_iterations; iteration_cnt++) 

    //-------------------------

   `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: HQM SIOV Test Sequence Ended"), OVM_LOW);

    endtask : body


  //---------------------------------------------------------------
  //---------------------------------------------------------------
  //---------------------------------------------------------------
  //---------------------------------------------------------------


  //---------------------------------------------------------------
  //---------------------------------------------------------------
  function bit [63:0] allocate_dram(string mem_name, bit [63:0] mem_size, bit [63:0] mem_mask);
     sla_sm_env               sm;
     sla_sm_ag_status_t       status;
     sla_sm_ag_result         gpa_mem;

     `sla_assert($cast(sm,sla_sm_env::get_ptr()), ("HQMV30_SCIOV_TEST__SEQ: Unable to get handle to SM."))
      status = sm.ag.allocate_mem(gpa_mem, "DRAM_HIGH", mem_size, mem_name, mem_mask);

      allocate_dram = gpa_mem.addr;
      `ovm_info(get_full_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ:allocate_dram:: mem_name=%0s mem_size=0x%0x mem_mask=0x%0x; allocate_dram=0x%0x", mem_name, mem_size, mem_mask, allocate_dram),OVM_LOW)
  endfunction

  //---------------------------------------------------------------
  //---------------------------------------------------------------
  // -----------------------------------------------------
  // Configure the HQM
  // -----------------------------------------------------
  virtual task config_hqm();
        hqm_integ_seq_pkg::hqm_sm_pf_cfg_seq              hqm_hcw_pf_init_cfg_seq;
        hqm_integ_seq_pkg::hqm_wait_for_reset_done_seq    hqm_hcw_pf_init_wait_seq;

       
        if (!($test$plusargs("HQMTEST_DIS_SMPF_CFG"))) begin
            `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: config_hqm Starting sm_pf_cfg_seq"), OVM_NONE);

            `ovm_create(hqm_hcw_pf_init_cfg_seq)
              hqm_hcw_pf_init_cfg_seq.inst_suffix = inst_suffix;  
            `ovm_rand_send(hqm_hcw_pf_init_cfg_seq)

            `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: config_hqm Starting wait_for_reset_done_seq"), OVM_NONE);
            `ovm_create(hqm_hcw_pf_init_wait_seq)
              hqm_hcw_pf_init_wait_seq.inst_suffix = inst_suffix;  
            `ovm_rand_send(hqm_hcw_pf_init_wait_seq)

            `ovm_info(get_type_name(), $psprintf("HQMV30_SCIOV_TEST__SEQ: config_hqm Ended"), OVM_NONE);
        end
  endtask

  // -----------------------------------------------------
  // load_default_stim_cfg_variables
  // -----------------------------------------------------
  //This function loads the default values in stim confib object. This function is crated to have unique traffic configuration for non-HQM test writers, where intent is HQM traffic is expected
  function load_default_stim_cfg_variables();
        int cq_depth_sel;
        int dir_qtype_sel;
       
        //skip the function if test override switch is enabled
        if($test$plusargs("HQM_STIM_OVRD_ENABLE")) begin
           if($test$plusargs("HQM_NUM_PP_MAX")) begin
              hcw_sciov_cfg_stim_cfg.num_ldb_pp     = $urandom_range(1,32); 
              hcw_sciov_cfg_stim_cfg.num_dir_pp     = $urandom_range(1,32);
           end else begin
              hcw_sciov_cfg_stim_cfg.num_ldb_pp     = $urandom_range(1,3); 
              hcw_sciov_cfg_stim_cfg.num_dir_pp     = $urandom_range(1,3);
           end

           //hcw_sciov_cfg_stim_cfg.num_vdev       = 'd1;
           hcw_sciov_cfg_stim_cfg.enable_ims     = $urandom_range(0,1);
           hcw_sciov_cfg_stim_cfg.enable_ims_poll= 'b0;

           if($test$plusargs("HQM_DIR_CQ_SINGLE_HCW_PER_CL")) cq_depth_sel = $urandom_range(1,6);  
           else                                               cq_depth_sel = $urandom_range(1,8);
           case(cq_depth_sel)
              1: hcw_sciov_cfg_stim_cfg.dir_cq_depth       = 'd8;
              2: hcw_sciov_cfg_stim_cfg.dir_cq_depth       = 'd16;
              3: hcw_sciov_cfg_stim_cfg.dir_cq_depth       = 'd32;
              4: hcw_sciov_cfg_stim_cfg.dir_cq_depth       = 'd64;
              5: hcw_sciov_cfg_stim_cfg.dir_cq_depth       = 'd128;
              6: hcw_sciov_cfg_stim_cfg.dir_cq_depth       = 'd256;
              7: hcw_sciov_cfg_stim_cfg.dir_cq_depth       = 'd512;
              8: hcw_sciov_cfg_stim_cfg.dir_cq_depth       = 'd1024;
           endcase

           if($test$plusargs("HQM_LDB_CQ_SINGLE_HCW_PER_CL")) cq_depth_sel = $urandom_range(1,6);  
           else                                               cq_depth_sel = $urandom_range(1,8);
           case(cq_depth_sel)
              1: hcw_sciov_cfg_stim_cfg.ldb_cq_depth       = 'd8;
              2: hcw_sciov_cfg_stim_cfg.ldb_cq_depth       = 'd16;
              3: hcw_sciov_cfg_stim_cfg.ldb_cq_depth       = 'd32;
              4: hcw_sciov_cfg_stim_cfg.ldb_cq_depth       = 'd64;
              5: hcw_sciov_cfg_stim_cfg.ldb_cq_depth       = 'd128;
              6: hcw_sciov_cfg_stim_cfg.ldb_cq_depth       = 'd256;
              7: hcw_sciov_cfg_stim_cfg.ldb_cq_depth       = 'd512;
              8: hcw_sciov_cfg_stim_cfg.ldb_cq_depth       = 'd1024;
           endcase

           hcw_sciov_traffic_stim_cfg.dir_cq_space      = 16'h4000;//--16K space for a CQ
           hcw_sciov_traffic_stim_cfg.ldb_cq_space      = 16'h4000;//--16K space for a CQ

           hcw_sciov_traffic_stim_cfg.dir_batch_min     = 'd1;   
           hcw_sciov_traffic_stim_cfg.dir_batch_max     = 'd4;   
           hcw_sciov_traffic_stim_cfg.ldb_batch_min     = 'd1;   
           hcw_sciov_traffic_stim_cfg.ldb_batch_max     = 'd4;   

          hcw_sciov_traffic_stim_cfg.dir_num_hcw         = $urandom_range('d32, 'd64);
          hcw_sciov_traffic_stim_cfg.ldb_num_hcw         = $urandom_range('d32, 'd64);

          dir_qtype_sel = $urandom_range('d0, 'd1);
          //--due to vde, can't do atm unless programmed correctly //hcw_sciov_traffic_stim_cfg.dir_qtype           = (dir_qtype_sel==0)? 'd0 : 'd3;
          hcw_sciov_traffic_stim_cfg.ldb_qtype           = $urandom_range('d0, 'd1);

        end else begin
          //Loading default values to variables, short run mode form opt file. This configuration is used for non-HQM tests where intention is to run HQM PF traffic.
          hcw_sciov_cfg_stim_cfg.enable_ims              = 'd0;
          hcw_sciov_cfg_stim_cfg.enable_ims_poll         = 'd0;
          hcw_sciov_cfg_stim_cfg.num_dir_pp              = 'd1;
          hcw_sciov_cfg_stim_cfg.num_ldb_pp              = 'd0;
          hcw_sciov_cfg_stim_cfg.num_vdev                = 'd1;
          hcw_sciov_cfg_stim_cfg.dir_cq_depth            = 'd64;
          hcw_sciov_cfg_stim_cfg.ldb_cq_depth            = 'd64;
          hcw_sciov_cfg_stim_cfg.dir_cq_depth_int_thresh = 'd1;
          hcw_sciov_cfg_stim_cfg.ldb_cq_depth_int_thresh = 'd1;
          hcw_sciov_cfg_stim_cfg.dir_pasid_min           = 'd0;
          hcw_sciov_cfg_stim_cfg.dir_pasid_max           = 'd0;
          hcw_sciov_cfg_stim_cfg.ldb_pasid_min           = 'd0;
          hcw_sciov_cfg_stim_cfg.ldb_pasid_max           = 'd0;
          hcw_sciov_cfg_stim_cfg.dir_cq_base_addr_ctl    = 'd0;
          hcw_sciov_cfg_stim_cfg.ldb_cq_base_addr_ctl    = 'd0;

          hcw_sciov_traffic_stim_cfg.dir_num_hcw         = 'd64;
          hcw_sciov_traffic_stim_cfg.dir_hcw_delay_min   = 'd31;
          hcw_sciov_traffic_stim_cfg.dir_hcw_delay_max   = 'd63;
          hcw_sciov_traffic_stim_cfg.dir_batch_min       = 'd4;   
          hcw_sciov_traffic_stim_cfg.dir_batch_max       = 'd4;   
          hcw_sciov_traffic_stim_cfg.dir_cq_space        = 16'h1000;
          hcw_sciov_traffic_stim_cfg.ldb_num_hcw         = 'd64;
          hcw_sciov_traffic_stim_cfg.ldb_hcw_delay_min   = 'd4;
          hcw_sciov_traffic_stim_cfg.ldb_hcw_delay_max   = 'd20;
          hcw_sciov_traffic_stim_cfg.ldb_batch_min       = 'd4;   
          hcw_sciov_traffic_stim_cfg.ldb_batch_max       = 'd4;   
          hcw_sciov_traffic_stim_cfg.ldb_cq_space        = 16'h8000;
          hcw_sciov_traffic_stim_cfg.dir_cq_base_addr_ctl  = 'd0;
          hcw_sciov_traffic_stim_cfg.ldb_cq_base_addr_ctl  = 'd0;
        end
  endfunction

  // -----------------------------------------------------
  // load_test_overide_stim_cfg_variables
  // -----------------------------------------------------
  //This function loads the test overide variables. HQM needs to run the test with different port sizes/interrupt enable/disaable and etc.
  function load_test_overide_stim_cfg_variables();
        bit has_intr_pb_run;
        bit [15:0] cq_intr_handle, cq_intr_subhandle;
        
        if($value$plusargs("HQM_ENABLE_IMS=%d", hcw_sciov_cfg_stim_cfg.enable_ims))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_ENABLE_IMS=%0d",hcw_sciov_cfg_stim_cfg.enable_ims),OVM_LOW);
        if($value$plusargs("HQM_NUM_DIR_PP=%d", hcw_sciov_cfg_stim_cfg.num_dir_pp))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_NUM_DIR_PP=%0d",hcw_sciov_cfg_stim_cfg.num_dir_pp),OVM_LOW);
        if($value$plusargs("HQM_NUM_LDB_PP=%d", hcw_sciov_cfg_stim_cfg.num_ldb_pp))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_NUM_LDB_PP=%0d",hcw_sciov_cfg_stim_cfg.num_ldb_pp),OVM_LOW);

        if($value$plusargs("HQM_NUM_VDEV=%d", hcw_sciov_cfg_stim_cfg.num_vdev))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_NUM_VDEV=%0d",hcw_sciov_cfg_stim_cfg.num_vdev),OVM_LOW);


        if($value$plusargs("HQM_DIR_CQ_DEPTH=%d", hcw_sciov_cfg_stim_cfg.dir_cq_depth))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_CQ_DEPTH=%0d",hcw_sciov_cfg_stim_cfg.dir_cq_depth),OVM_LOW);
        if($value$plusargs("HQM_DIR_CQ_DEPTH_INT_THRESH=%d", hcw_sciov_cfg_stim_cfg.dir_cq_depth_int_thresh))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_CQ_DEPTH_INT_THRESH=%0d",hcw_sciov_cfg_stim_cfg.dir_cq_depth_int_thresh),OVM_LOW);

        if($value$plusargs("HQM_LDB_CQ_DEPTH=%d", hcw_sciov_cfg_stim_cfg.ldb_cq_depth))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_CQ_DEPTH=%0d",hcw_sciov_cfg_stim_cfg.ldb_cq_depth),OVM_LOW);
        if($value$plusargs("HQM_LDB_CQ_DEPTH_INT_THRESH=%d", hcw_sciov_cfg_stim_cfg.dir_cq_depth_int_thresh))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_CQ_DEPTH_INT_THRESH=%0d",hcw_sciov_cfg_stim_cfg.dir_cq_depth_int_thresh),OVM_LOW);

        if($value$plusargs("HQM_DIR_CQ_ADDR_CTRL=%d", hcw_sciov_cfg_stim_cfg.dir_cq_base_addr_ctl))
         `ovm_info(get_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_CQ_ADDR_CTRL=%0d (reprogram cq_addr/pasid)",hcw_sciov_cfg_stim_cfg.dir_cq_base_addr_ctl),OVM_LOW);
        if($value$plusargs("HQM_LDB_CQ_ADDR_CTRL=%d", hcw_sciov_cfg_stim_cfg.ldb_cq_base_addr_ctl))
         `ovm_info(get_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_CQ_ADDR_CTRL=%0d (reprogram cq_addr/pasid)",hcw_sciov_cfg_stim_cfg.ldb_cq_base_addr_ctl),OVM_LOW);

        hcw_sciov_traffic_stim_cfg.dir_cq_base_addr_ctl = hcw_sciov_cfg_stim_cfg.dir_cq_base_addr_ctl; 
        hcw_sciov_traffic_stim_cfg.ldb_cq_base_addr_ctl = hcw_sciov_cfg_stim_cfg.ldb_cq_base_addr_ctl; 

        if($value$plusargs("HQM_DIR_IMS_BASE_ADDR=%h", hcw_sciov_cfg_stim_cfg.dir_ims_base_addr))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_IMS_BASE_ADDR=%0d",hcw_sciov_cfg_stim_cfg.dir_ims_base_addr),OVM_LOW);
        if($value$plusargs("HQM_LDB_IMS_BASE_ADDR=%h", hcw_sciov_cfg_stim_cfg.ldb_ims_base_addr))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_IMS_BASE_ADDR=%0d",hcw_sciov_cfg_stim_cfg.ldb_ims_base_addr),OVM_LOW);



        //--------------------------------------
        //-- use dir_pasid_rnd_min/max and ldb_pasid_rnd_min/max for PASID settings
        //--------------------------------------
        if(hcw_sciov_cfg_stim_cfg.num_dir_pp>0) begin
           for(int kk=0; kk<hcw_sciov_cfg_stim_cfg.num_dir_pp; kk++) begin
              if($value$plusargs({$psprintf("DIR_PP%0d_PASID_VAL",kk),"=%h"}, hcw_sciov_cfg_stim_cfg.dir_pasid_q[kk])) begin   
                `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide DIR_PP%0d_PASID_VAL=0x%0x", kk, hcw_sciov_cfg_stim_cfg.dir_pasid_q[kk]),OVM_LOW);
              end else begin
                 if(dir_pasid_rnd_min>0 & dir_pasid_rnd_max>0) begin
                      hcw_sciov_cfg_stim_cfg.dir_pasid_q[kk] = $urandom_range(dir_pasid_rnd_min, dir_pasid_rnd_max);
                      `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide DIR_PP%0d_PASID_VAL=0x%0x by rnd range (dir_pasid_rnd_min=0x%0x dir_pasid_rnd_max=0x%0x)", kk, hcw_sciov_cfg_stim_cfg.dir_pasid_q[kk], dir_pasid_rnd_min, dir_pasid_rnd_max),OVM_LOW);
                 end
              end
           end
        end

        if(hcw_sciov_cfg_stim_cfg.num_ldb_pp>0) begin
           for(int kk=0; kk<hcw_sciov_cfg_stim_cfg.num_ldb_pp; kk++) begin
              if($value$plusargs({$psprintf("LDB_PP%0d_PASID_VAL",kk),"=%h"}, hcw_sciov_cfg_stim_cfg.ldb_pasid_q[kk])) begin   
                `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide LDB_PP%0d_PASID_VAL=0x%0x", kk, hcw_sciov_cfg_stim_cfg.ldb_pasid_q[kk]),OVM_LOW);
              end else begin
                 if(ldb_pasid_rnd_min>0 & ldb_pasid_rnd_max>0) begin
                      hcw_sciov_cfg_stim_cfg.ldb_pasid_q[kk] = $urandom_range(ldb_pasid_rnd_min, ldb_pasid_rnd_max);
                      `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide LDB_PP%0d_PASID_VAL=0x%0x by rnd range (ldb_pasid_rnd_min=0x%0x ldb_pasid_rnd_max=0x%0x)", kk, hcw_sciov_cfg_stim_cfg.ldb_pasid_q[kk], ldb_pasid_rnd_min, ldb_pasid_rnd_max),OVM_LOW);
                 end
              end
           end
        end

        if($value$plusargs("HQM_DIR_NUM_HCW=%d", hcw_sciov_traffic_stim_cfg.dir_num_hcw))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_NUM_HCW=%0d",hcw_sciov_traffic_stim_cfg.dir_num_hcw),OVM_LOW);
        if($value$plusargs("HQM_DIR_HCW_DLY_MIN=%d", hcw_sciov_traffic_stim_cfg.dir_hcw_delay_min))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_HCW_DLY_MIN=%0d",hcw_sciov_traffic_stim_cfg.dir_hcw_delay_min),OVM_LOW);
        if($value$plusargs("HQM_DIR_HCW_DLY_MAX=%d", hcw_sciov_traffic_stim_cfg.dir_hcw_delay_max))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_HCW_DLY_MAX=%0d",hcw_sciov_traffic_stim_cfg.dir_hcw_delay_max),OVM_LOW);
        if($value$plusargs("HQM_DIR_BATCH_MIN=%d", hcw_sciov_traffic_stim_cfg.dir_batch_min))
         `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_BATCH_MIN=%0d",hcw_sciov_traffic_stim_cfg.dir_batch_min),OVM_LOW);
        if($value$plusargs("HQM_DIR_BATCH_MAX=%d", hcw_sciov_traffic_stim_cfg.dir_batch_max))
         `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_BATCH_MAX=%0d",hcw_sciov_traffic_stim_cfg.dir_batch_max),OVM_LOW);
        if($value$plusargs("HQM_DIR_HCW_TIME=%0d", hcw_sciov_traffic_stim_cfg.dir_hcw_time))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_HCW_TIME=%0d",hcw_sciov_traffic_stim_cfg.dir_hcw_time),OVM_LOW);
        if($value$plusargs("HQM_DIR_CQ_SPACE=%x", hcw_sciov_traffic_stim_cfg.dir_cq_space))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_CQ_SPACE=%0d",hcw_sciov_traffic_stim_cfg.dir_cq_space),OVM_LOW);
        if($value$plusargs("HQM_DIR_QTYPE=%d", hcw_sciov_traffic_stim_cfg.dir_qtype))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_QTYPE=%0d",hcw_sciov_traffic_stim_cfg.dir_qtype),OVM_LOW);
        if($value$plusargs("HQM_DIR_CQ_QTYPE=%s", hcw_sciov_traffic_stim_cfg.dir_qtype))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_DIR_CQ_QTYPE=%0s",hcw_sciov_traffic_stim_cfg.dir_qtype.name()),OVM_LOW);


        if($value$plusargs("HQM_LDB_NUM_HCW=%d", hcw_sciov_traffic_stim_cfg.ldb_num_hcw))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_NUM_HCW=%0d",hcw_sciov_traffic_stim_cfg.ldb_num_hcw),OVM_LOW);
        if($value$plusargs("HQM_LDB_HCW_DLY_MIN=%d", hcw_sciov_traffic_stim_cfg.ldb_hcw_delay_min))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_HCW_DLY_MIN=%0d",hcw_sciov_traffic_stim_cfg.ldb_hcw_delay_min),OVM_LOW);
        if($value$plusargs("HQM_LDB_HCW_DLY_MAX=%d", hcw_sciov_traffic_stim_cfg.ldb_hcw_delay_max))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_HCW_DLY_MAX=%0d",hcw_sciov_traffic_stim_cfg.ldb_hcw_delay_max),OVM_LOW);
        if($value$plusargs("HQM_LDB_HCW_TIME=%0d", hcw_sciov_traffic_stim_cfg.ldb_hcw_time))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_HCW_TIME=%0d",hcw_sciov_traffic_stim_cfg.ldb_hcw_time),OVM_LOW);
        if($value$plusargs("HQM_LDB_BATCH_MIN=%d", hcw_sciov_traffic_stim_cfg.ldb_batch_min))
         `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_BATCH_MIN=%0d",hcw_sciov_traffic_stim_cfg.ldb_batch_min),OVM_LOW);
        if($value$plusargs("HQM_LDB_BATCH_MAX=%d", hcw_sciov_traffic_stim_cfg.ldb_batch_max))
         `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_BATCH_MAX=%0d",hcw_sciov_traffic_stim_cfg.ldb_batch_max),OVM_LOW);
        if($value$plusargs("HQM_LDB_CQ_SPACE=%x", hcw_sciov_traffic_stim_cfg.ldb_cq_space))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_CQ_SPACE=%0d",hcw_sciov_traffic_stim_cfg.ldb_cq_space),OVM_LOW);
        if($value$plusargs("HQM_LDB_QTYPE=%d", hcw_sciov_traffic_stim_cfg.ldb_qtype))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_QTYPE=%0d",hcw_sciov_traffic_stim_cfg.ldb_qtype),OVM_LOW);
        if($value$plusargs("HQM_LDB_CQ_QTYPE=%s", hcw_sciov_traffic_stim_cfg.ldb_qtype))
         `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:Test STIM overide HQM_LDB_CQ_QTYPE=%0s",hcw_sciov_traffic_stim_cfg.ldb_qtype.name()),OVM_LOW);


        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM Traffic configuration"), OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_ENABLE_IMS=%0d; enable_ims_poll=%0d", hcw_sciov_cfg_stim_cfg.enable_ims, hcw_sciov_cfg_stim_cfg.enable_ims_poll),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_NUM_DIR_PP=%0d",              hcw_sciov_cfg_stim_cfg.num_dir_pp),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_NUM_LDB_PP=%0d",              hcw_sciov_cfg_stim_cfg.num_ldb_pp),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_NUM_VDEV=%0d",                hcw_sciov_cfg_stim_cfg.num_vdev),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_CQ_DEPTH=%0d",            hcw_sciov_cfg_stim_cfg.dir_cq_depth),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_CQ_DEPTH_INT_THRESH=%0d", hcw_sciov_cfg_stim_cfg.dir_cq_depth_int_thresh),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_CQ_DEPTH=%0d",            hcw_sciov_cfg_stim_cfg.ldb_cq_depth),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_CQ_DEPTH_INT_THRESH=%0d", hcw_sciov_cfg_stim_cfg.ldb_cq_depth_int_thresh),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_IMS_BASE_ADDR=0x%0x",     hcw_sciov_cfg_stim_cfg.dir_ims_base_addr),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_IMS_BASE_ADDR=0x%0x",     hcw_sciov_cfg_stim_cfg.ldb_ims_base_addr),OVM_LOW);

        //== hcw_sciov_cfg_stim_cfg.dir_pasid_min/max  hcw_sciov_cfg_stim_cfg.ldb_pasid_min/max will not be used
        //`ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_PASID_MIN=0x%0x",         hcw_sciov_cfg_stim_cfg.dir_pasid_min),OVM_LOW);
        //`ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_PASID_MAX=0x%0x",         hcw_sciov_cfg_stim_cfg.dir_pasid_max),OVM_LOW);
        //`ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_PASID_MIN=0x%0x",         hcw_sciov_cfg_stim_cfg.ldb_pasid_min),OVM_LOW);
        //`ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_PASID_MAX=0x%0x",         hcw_sciov_cfg_stim_cfg.ldb_pasid_max),OVM_LOW);

        if(hcw_sciov_cfg_stim_cfg.num_dir_pp>0) begin
           for(int kk=0; kk<hcw_sciov_cfg_stim_cfg.num_dir_pp; kk++) begin
                `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_PASID_Q[%0d]=0x%0x", kk, hcw_sciov_cfg_stim_cfg.dir_pasid_q[kk]),OVM_LOW);
           end
        end

        if(hcw_sciov_cfg_stim_cfg.num_ldb_pp>0) begin
           for(int kk=0; kk<hcw_sciov_cfg_stim_cfg.num_ldb_pp; kk++) begin
                `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_PASID_Q[%0d]=0x%0x", kk, hcw_sciov_cfg_stim_cfg.ldb_pasid_q[kk]),OVM_LOW);
           end
        end


        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_NUM_HCW=%0d",     hcw_sciov_traffic_stim_cfg.dir_num_hcw),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_HCW_DLY_MIN=%0d", hcw_sciov_traffic_stim_cfg.dir_hcw_delay_min),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_HCW_DLY_MAX=%0d", hcw_sciov_traffic_stim_cfg.dir_hcw_delay_max),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_BATCH_MIN=%0d",   hcw_sciov_traffic_stim_cfg.dir_batch_min),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_BATCH_MAX=%0d",   hcw_sciov_traffic_stim_cfg.dir_batch_max),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_HCW_TIME=%0d",    hcw_sciov_traffic_stim_cfg.dir_hcw_time),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_CQ_SPACE=0x%0x",  hcw_sciov_traffic_stim_cfg.dir_cq_space),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_CQ_QTYPE=%0s",    hcw_sciov_traffic_stim_cfg.dir_qtype.name()),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_QTYPE=%0d",       hcw_sciov_traffic_stim_cfg.dir_qtype),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_DIR_CQ_ADDR_CTRL=%0d",hcw_sciov_traffic_stim_cfg.dir_cq_base_addr_ctl),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_NUM_HCW=%0d",     hcw_sciov_traffic_stim_cfg.ldb_num_hcw),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_HCW_DLY_MIN=%0d", hcw_sciov_traffic_stim_cfg.ldb_hcw_delay_min),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_HCW_DLY_MAX=%0d", hcw_sciov_traffic_stim_cfg.ldb_hcw_delay_max),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_BATCH_MIN=%0d",   hcw_sciov_traffic_stim_cfg.ldb_batch_min),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_BATCH_MAX=%0d",   hcw_sciov_traffic_stim_cfg.ldb_batch_max),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_HCW_TIME=%0d",    hcw_sciov_traffic_stim_cfg.ldb_hcw_time),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_CQ_SPACE=0x%0x",  hcw_sciov_traffic_stim_cfg.ldb_cq_space),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_CQ_QTYPE=%0s",    hcw_sciov_traffic_stim_cfg.ldb_qtype.name()),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_QTYPE=%0d",       hcw_sciov_traffic_stim_cfg.ldb_qtype),OVM_LOW);
        `ovm_info(get_type_name(),$psprintf(" HQMV30_SCIOV_TEST__SEQ:HQM_LDB_CQ_ADDR_CTRL=%0d",hcw_sciov_traffic_stim_cfg.ldb_cq_base_addr_ctl),OVM_LOW);
  endfunction



//---------------------------------------------------------------
//---------------------------------------------------------------
task ats_invalidation_task();

   if($test$plusargs("HQMTEST_ATSINV_DELETE_ENTRY")) begin
      `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:ats_invalidation_task:: Start to issue HqmAts_deletetlb()"),OVM_MEDIUM)
      HqmAts_deletetlb();
   end

   if($test$plusargs("HQMTEST_ATSINV_GLOBAL")) begin
         HqmAtsInvalidRequest_task(0, 0, 1);
   end else begin

      for(int i=0; i<hcw_sciov_cfg_stim_cfg.num_dir_pp; i++) begin
         `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:ats_invalidation_task:: Start to issue ATS INV for DIRCQ[%0d]", i),OVM_MEDIUM)
         HqmAtsInvalidRequest_task(0, i, 0);
      end

      for(int i=0; i<hcw_sciov_cfg_stim_cfg.num_ldb_pp; i++) begin
         `ovm_info(get_type_name(),$psprintf("HQMV30_SCIOV_TEST__SEQ:ats_invalidation_task:: Start to issue ATS INV for LDBCQ[%0d]", i),OVM_MEDIUM)
         HqmAtsInvalidRequest_task(1, i, 0);
      end
   end 

endtask:ats_invalidation_task


endclass : hqmv30_sciov_test_seq

`endif 
