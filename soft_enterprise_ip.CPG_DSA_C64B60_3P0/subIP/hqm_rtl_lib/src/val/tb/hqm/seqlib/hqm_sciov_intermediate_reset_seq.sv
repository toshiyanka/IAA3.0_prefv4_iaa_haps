
`ifndef HQM_SCIOV_INTERMEDIATE_RESET_SEQ__SV
`define HQM_SCIOV_INTERMEDIATE_RESET_SEQ__SV


import hqm_integ_seq_pkg::*;

class hqm_sciov_intermediate_reset_seq extends hqm_base_seq;

  `ovm_sequence_utils(hqm_sciov_intermediate_reset_seq, sla_sequencer)

  hqm_tb_hcw_scoreboard                 i_hcw_scoreboard;
  hqm_pp_cq_status                      i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed
  hqm_iosf_sb_checker                   sideband_checker_hqm_i;
  sla_ral_env                           ral;

  hcw_sciov_test_cfg_seq                i_hcw_sciov_test_cfg_seq;
  hcw_sciov_test_hcw_seq                i_hcw_sciov_test_hcw_seq;

  hqm_sla_pcie_flr_sequence             pf_flr_seq;
  hqm_reset_init_sequence               warm_reset_seq;
  hqm_cold_reset_sequence               cold_reset_seq;
  hqm_dwr_sequence                      dwr_seq;

  ral_pfrst_seq                         rst_hqm_cfg;
  hqm_sla_pcie_init_seq                 hqm_pcie_init;

  hqm_iosf_sb_resetPrep_seq             resetPrep_seq;
  hqm_iosf_sb_forcewake_seq             forcePwrGatePOK_seq;
  ovm_event_pool                        global_pool;
  ovm_event                             hqm_ResetPrepAck;

//  hqm_sla_pcie_reg_rst_val_chk_sequence i_pcie_reg_rst_seq;
   
  int                                   rst_wait_num;

  function new(string name = "hqm_sciov_intermediate_reset_seq");
    super.new(name);
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_ResetPrepAck = global_pool.get("hqm_ResetPrepAck");
  endfunction

  task wait_sys_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

  task pause_bg_cfg_access();
      if ($test$plusargs("HQM_BACKGROUND_CFG_GEN_SEQ")) begin
          `ovm_info(get_full_name(), $psprintf("Disabling the hqm_background_cfg_gen_seq"), OVM_LOW);
          i_hqm_pp_cq_status.pause_bg_cfg_req = 1'b1;
          wait (i_hqm_pp_cq_status.pause_bg_cfg_ack == 1'b1);
          //i_hqm_pp_cq_status.pause_bg_cfg_ack = 1'b0;
      end
  endtask

  function get_hcw_tb_scoreboard_handle();
    ovm_object o_tmp;
    //-----------------------------
    //-- get i_hcw_scoreboard
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hcw_scoreboard", o_tmp)) begin
                 ovm_report_fatal(get_full_name(), "Unable to find i_hcw_scoreboard object");
    end

    if (!$cast(i_hcw_scoreboard, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config_i_hcw_scoreboard %s associated with config %s is not same type", o_tmp.sprint(), i_hcw_scoreboard.sprint()));
    end else begin
      ovm_report_info(get_full_name(), $psprintf("i_hcw_scoreboard retrieved"), OVM_DEBUG);
    end
  endfunction
  
  function get_hqm_iosf_sb_checker_handle();
    ovm_object o_tmp;
    //-----------------------------
    //-- get sideband_checker_hqm_i
    //-----------------------------
    if (!p_sequencer.get_config_object("sideband_checker_hqm_i", o_tmp)) begin
                 ovm_report_fatal(get_full_name(), "Unable to find sideband_checker_hqm_i object");
    end

    if (!$cast(sideband_checker_hqm_i, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config_sideband_checker_hqm_i %s associated with config %s is not same type", o_tmp.sprint(), sideband_checker_hqm_i.sprint()));
    end else begin
      ovm_report_info(get_full_name(), $psprintf("sideband_checker_hqm_i retrieved"), OVM_DEBUG);
    end
  endfunction

  function get_hqm_pp_cq_status_handle();
    ovm_object o_tmp;
    //-----------------------------
    //-- get i_hqm_pp_cq_status 
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_pp_cq_status", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
    end

    if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
    end else begin
      ovm_report_info(get_full_name(), $psprintf("i_hqm_pp_cq_status retrieved"), OVM_DEBUG);
    end
  endfunction
 

  virtual task body();
      int    rst_count;
      string rst_type;
      bit reset_with_hcw_process_on; 
      sla_ral_reg _reg_; 
      sla_ral_data_t _ral_data_, rd_data;
      sla_status_t status;
      int sb_req_for_dwr=0, dont_wait_resetPrepAck=0;
      int num_rstPrep=1, num_FPGPOK=1;

      if(!$value$plusargs("HQM_SCIOV_RST_TYPE=%s",rst_type))      rst_type  = "warm";
	  if(!$value$plusargs("HQM_SCIOV_RST_COUNT=%d",rst_count))    rst_count = 1;
      if(!$value$plusargs("HQM_SCIOV_RST_WITH_HCW_PROCESS_ON=%d",reset_with_hcw_process_on)) reset_with_hcw_process_on=1'b_0;
      if(!$value$plusargs("HQM_SCIOV_RST_WAITNUM=%d",rst_wait_num)) rst_wait_num = `HQM_PF_FLR_WAIT_WITH_HCW;
      if($test$plusargs("HQM_SB_REQ_FOR_DWR")) sb_req_for_dwr=1;
      if($test$plusargs("HQM_DONT_WAIT_RESETPREPACK")) dont_wait_resetPrepAck=1;
      if ($test$plusargs("HQM_MULTIPLE_RSTPREP_FPGPOK")) begin num_rstPrep=2; num_FPGPOK=2; end
      if ($test$plusargs("HQM_NO_RSTPREP_FPGPOK")) begin num_rstPrep=0; num_FPGPOK=0; end

      // get i_hqm_pp_cq_status
      get_hqm_pp_cq_status_handle();
  
      // get_hcw_tb_scoreboard_handle 
      get_hcw_tb_scoreboard_handle();

      // get sideband_checker_hqm_i
      get_hqm_iosf_sb_checker_handle();

      `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."));
      _reg_     = ral.find_reg_by_file_name("pcie_cap_device_control", "hqm_pf_cfg_i");

      `ovm_info(get_full_name(),$psprintf("Starting hqm_sciov_intermediate_reset_seq: Number of resets #(0x%0x) with reset_with_hcw_process_on=(0x%0x), rst_wait_num=%0d, num_FPGPOK=%0d, num_rstPrep=%0d, dont_wait_resetPrepAck=%0d",rst_count,reset_with_hcw_process_on, rst_wait_num, num_FPGPOK, num_rstPrep, dont_wait_resetPrepAck),OVM_LOW);

      // HQM SCIOV configuration -- moved to config_phase
      //`ovm_do(i_hcw_sciov_test_cfg_seq); 

      // HCW traffic 
      fork
         begin 
             `ovm_do(i_hcw_sciov_test_hcw_seq); 
             `ovm_info(get_full_name(),$psprintf("calling i_hcw_sciov_test_hcw_seq"),OVM_LOW);
             reset_with_hcw_process_on = 0; 
         end
         begin 
             while(1) begin 
               wait_sys_clk(rst_wait_num); 
               if(reset_with_hcw_process_on) break; 
             end 
             `ovm_info(get_full_name(),$psprintf("Done with waiting for hcw traffic rst_wait_num=%d ", rst_wait_num),OVM_LOW);
        end
        begin
            `ovm_info(get_full_name(),$psprintf(" Start: sb_req_for_dwr=%0d", sb_req_for_dwr),OVM_LOW);
            if (sb_req_for_dwr==1) begin
                wait_sys_clk(rst_wait_num/2); 
                pause_bg_cfg_access();
                for (int i=0;i<num_rstPrep;i++) begin
                    `ovm_do(resetPrep_seq); 
                        `ovm_info(get_full_name(),$psprintf(" 000:num_FPGPOK DEBUG, i=%d, num_rstPrep=%d, dont_wait_resetPrepAck=%d", i, num_rstPrep, dont_wait_resetPrepAck),OVM_LOW);
                    fork 
                    begin
                        `ovm_info(get_full_name(),$psprintf(" AAA:num_FPGPOK DEBUG, i=%d, num_rstPrep=%d, dont_wait_resetPrepAck=%d", i, num_rstPrep, dont_wait_resetPrepAck),OVM_LOW);
                        hqm_ResetPrepAck.wait_trigger();
                        `ovm_info(get_full_name(),$psprintf(" BBB:num_FPGPOK DEBUG, i=%d, num_rstPrep=%d, dont_wait_resetPrepAck=%d", i, num_rstPrep, dont_wait_resetPrepAck),OVM_LOW);
                    end
                    begin
                        while(1) begin 
                           wait_sys_clk(200);
                           if(dont_wait_resetPrepAck) break; 
                        `ovm_info(get_full_name(),$psprintf(" CCC:num_FPGPOK DEBUG, i=%d, num_rstPrep=%d, dont_wait_resetPrepAck=%d", i, num_rstPrep, dont_wait_resetPrepAck),OVM_LOW);
                        end 
                    end
                    join_any
                    disable fork;
                end

                wait_sys_clk(rst_wait_num/5); 
                        `ovm_info(get_full_name(),$psprintf(" DDD:num_FPGPOK DEBUG,num_rstPrep=%d, dont_wait_resetPrepAck=%d", num_rstPrep, dont_wait_resetPrepAck),OVM_LOW);
                if (num_FPGPOK)
                    `ovm_do(forcePwrGatePOK_seq);
            end
            else begin
                while(1) begin 
                  wait_sys_clk(rst_wait_num); 
                  if(reset_with_hcw_process_on) break; 
                end 
            end
            `ovm_info(get_full_name(),$psprintf(" End: sb_req_for_dwr=%0d", sb_req_for_dwr),OVM_LOW);
        end
      join_any

      // Force all traffic sequences to stop
      i_hqm_pp_cq_status.force_all_seq_stop();
      wait_sys_clk(10);

      disable fork;

      if (sb_req_for_dwr==0) 
      pause_bg_cfg_access();

      i_hqm_pp_cq_status.clr_force_all_seq_stop();

      `ovm_info(get_full_name(),$psprintf(" Starting %0s Reset %0d number of times", rst_type, rst_count),OVM_LOW);
      if(rst_count > 0) begin		
        repeat(rst_count) begin
          //issue reset
          `ovm_info(get_full_name(),$psprintf("Reset Started"),OVM_LOW);
          // Use plusarg to select either cold or warm or PF FLR resets 
          //wait_sys_clk(1200);
          wait_sys_clk(50);
          case (rst_type)
              "pfFlr":   `ovm_do(pf_flr_seq)
              "cold" :   `ovm_do(cold_reset_seq)
              "warm" :   `ovm_do(warm_reset_seq)
              "dirtyWarmReset" :   `ovm_do(dwr_seq)
          endcase
          wait_sys_clk(1200); 
          `ovm_info(get_full_name(),$psprintf("Reset Ended"),OVM_LOW);

          if($test$plusargs("HAS_PCIE_INIT")) begin 
              `ovm_info(get_full_name(),$psprintf(" hqm_pcie_init start"),OVM_LOW);
              `ovm_do(hqm_pcie_init);
              `ovm_info(get_full_name(),$psprintf(" hqm_pcie_init done"),OVM_LOW);
          end else begin
              `ovm_info(get_full_name(),$psprintf("hqm_pcie_init skip"),OVM_LOW);
          end 
            wait_sys_clk(10);
        end
        `ovm_info(get_full_name(),$psprintf("Done with %0s Reset %0d number of times; Start clearing scoreboard, hqm_cfg, pp_cq_seq", rst_type, rst_count),OVM_LOW);

         `ovm_do(rst_hqm_cfg);
         i_hcw_scoreboard.hcw_scoreboard_reset();

         //foreach(sideband_checker_hqm_i.obs_ep_nfatal_msg_count[kk]) begin
         for(int kk=0; kk<(`MAX_NO_OF_VFS+1); kk++) begin
             sideband_checker_hqm_i.obs_ep_fatal_msg_count[kk]=0;
             sideband_checker_hqm_i.obs_ep_nfatal_msg_count[kk]=0;
             sideband_checker_hqm_i.obs_ep_corr_msg_count[kk]=0;
             sideband_checker_hqm_i.exp_ep_fatal_msg_count[kk]=0;
             sideband_checker_hqm_i.exp_ep_nfatal_msg_count[kk]=0;
             sideband_checker_hqm_i.exp_ep_corr_msg_count[kk]=0;
         end

         //-- check hqm_pp_cq_status.cq_int and clear it
         for(int kk=0; kk<64; kk++) begin
            if(i_hqm_pp_cq_status.cq_int_received(1, kk) == 1) begin 
             `ovm_info(get_full_name(),$psprintf("Get_hqm_pp_cq_status.cq_int[%0d] mailbox ", kk),OVM_LOW);
              wait_sys_clk(1);
              i_hqm_pp_cq_status.wait_for_cq_int(1, kk); //ldb_cq[kk]
            end
         end 
  
         _ral_data_='h_0; _ral_data_[15]=1'b_1;
         _reg_.set_tracking_val(_ral_data_);  // -- To reset active_seq_cnt in pp_cq_base_seq -- //
         `ovm_info(get_full_name(),$psprintf("Setting tracking val of 15th bit of pcie_cap_device_control in pf_cfg space to '1'. To be used by pp_cq_base_seq."),OVM_LOW);

      end

      `ovm_info(get_full_name(),$psprintf("Done with %0s Reset %0d number of times; and scoreboard, hqm_cfg, pp_cq_seq are cleared", rst_type, rst_count),OVM_LOW);
     
      if ($test$plusargs("HQM_SB_REQ_FOR_DWR")) begin
          `ovm_info(get_full_name(),$psprintf(" Starting SB requests after Dirty warm Reset:  "),OVM_LOW);
          _ral_data_ = 32'h5555_AAAA;
          ral_access_path = iosf_sb_sla_pkg::get_src_type();
          _reg_ = get_reg_handle("cache_line_size", "hqm_pf_cfg_i");
          _reg_.write(status, _ral_data_, ral_access_path, this, .sai('h3));
          _reg_.read(status, rd_data, ral_access_path, this, .sai('h3));
          `ovm_info(get_full_name(),$psprintf(" Done with SB requests after Dirty warm Reset: Check for them completing properly: write_data=%h, rd_data=%h ", _ral_data_, rd_data),OVM_LOW);
          if (rd_data[7:0] != _ral_data_[7:0])
              `ovm_error(get_full_name(),$psprintf("Access through Sideband just after Dirty Warm Reset: Write data = %h not matching read data = %h",  _ral_data_[7:0], rd_data[7:0]))
          ral_access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
      end

      `ovm_info(get_full_name(),$psprintf(" Reconfigure HQM in SCIOV mode followed by HCW traffic"),OVM_LOW);

      wait_sys_clk(20); 
      `ovm_do(hqm_pcie_init);

      if (rst_type == "warm") begin

           sla_ral_data_t rd_val_q[$];
           sla_ral_data_t rd_val;

           read_reg("aer_cap_uncorr_err_status", rd_val, "hqm_pf_cfg_i");
           if (rd_val[20])  write_fields("aer_cap_uncorr_err_status", {"UR"}, {1'b1}, "hqm_pf_cfg_i");

           read_reg("aer_cap_corr_err_status", rd_val, "hqm_pf_cfg_i");
           if (rd_val[13])  write_fields("aer_cap_corr_err_status", {"ANFES"}, {1'b1}, "hqm_pf_cfg_i");

           compare_reg("aer_cap_uncorr_err_status", 'h0, rd_val, "hqm_pf_cfg_i");
           compare_reg("aer_cap_corr_err_status", 'h0, rd_val, "hqm_pf_cfg_i");
      end

      wait_sys_clk(20);
      `ovm_do(i_hcw_sciov_test_cfg_seq); 

      if ($test$plusargs("HQM_BACKGROUND_CFG_GEN_SEQ")) begin
          `ovm_info(get_full_name(), $psprintf("Resuming hqm_background_cfg_gen_seq"), OVM_LOW);
          i_hqm_pp_cq_status.pause_bg_cfg_req = 1'b0;
      end

      wait_sys_clk(20); 
      `ovm_do(i_hcw_sciov_test_hcw_seq);

      `ovm_info(get_full_name(),$psprintf(" Done with hqm_sciov_intermediate_reset_seq"),OVM_LOW);

  endtask

endclass
`endif

