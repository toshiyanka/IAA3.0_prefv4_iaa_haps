//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
//-- Register Test: hqm_eot_rd_seq
//-- hqm_eot_rd_seq   
//-----------------------------------------------------------------------------------------------------

import hqm_pkg::*;
import hcw_pkg::*;
import hqm_cfg_pkg::*;

`include "stim_config_macros.svh"

class hqm_eot_rd_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_eot_rd_seq_stim_config";

  `ovm_object_utils_begin(hqm_eot_rd_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_initial_frontdoor_accesses, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_chp_syndrome_chk, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_atm_syndrome_chk, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_cq_depth_chk,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_cq_histlist_chk,  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_vas_credit_chk,   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(force_frontdoor,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_eot_rd_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_int(do_initial_frontdoor_accesses)
    `stimulus_config_field_int(do_chp_syndrome_chk)
    `stimulus_config_field_int(do_atm_syndrome_chk)
    `stimulus_config_field_int(do_cq_depth_chk)
    `stimulus_config_field_int(do_cq_histlist_chk)
    `stimulus_config_field_int(do_vas_credit_chk)
    `stimulus_config_field_int(force_frontdoor)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  bit                           do_initial_frontdoor_accesses   = 1'b0;
  bit                           do_chp_syndrome_chk     = 1'b1;
  bit                           do_atm_syndrome_chk     = 1'b1;
  bit                           do_cq_depth_chk         = 1'b1;
  bit                           do_cq_histlist_chk      = 1'b1;
  bit                           do_vas_credit_chk       = 1'b1;
  bit                           force_frontdoor         = 1'b0;

  function new(string name = "hqm_eot_rd_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_eot_rd_seq_stim_config

class hqm_eot_rd_seq extends ovm_sequence;

  `ovm_sequence_utils(hqm_eot_rd_seq, sla_sequencer)

  string        inst_suffix = "";

  //-- hqm_cfg
  hqm_cfg                       i_hqm_cfg;

  hqm_pp_cq_status              i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed

  int                           vas_credit_count[hqm_pkg::NUM_VAS];

  rand hqm_eot_rd_seq_stim_config       cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_eot_rd_seq_stim_config);

  //----------------------------------------------
  //-- new()
  //----------------------------------------------  
  function new(string name = "hqm_eot_rd_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_eot_rd_seq_stim_config::type_id::create("hqm_eot_rd_seq_stim_config");

    for (int i = 0 ; i < hqm_pkg::NUM_VAS ; i++) begin
      vas_credit_count[i] = 0;
    end

    apply_stim_config_overrides(0);
  endfunction

  //----------------------------------------------
  //-- body()
  //----------------------------------------------  
  virtual task body();
    int   credit_rand_val;
    int   poll_status;
    ovm_object o_tmp;
    sla_ral_data_t      idle_status;
       	
    apply_stim_config_overrides(1);

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hqm_cfg",inst_suffix}, o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg %s not consistent with hqm_cfg type", o_tmp.sprint()));
    end

    //-----------------------------
    //-- get i_hqm_pp_cq_status
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hqm_pp_cq_status",inst_suffix}, o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
    end

    if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
    end

    //------------------------------------------------------------------------------------------------    
    //== EOT Register Reads
    //------------------------------------------------------------------------------------------------   
    ovm_report_info("HQM_TBEOTSTATUS_SEQ000",$psprintf("HQM_TBEOT_SEQ000_Start: inst_suffix=%0s - check cfg_diagnostic_idle_status", inst_suffix), OVM_MEDIUM);
    read_reg("config_master.cfg_diagnostic_idle_status",idle_status);

    while ((idle_status & 'h000fffff) != 'h000fffff) begin
      read_reg("config_master.cfg_diagnostic_idle_status",idle_status);
    end

    if (cfg.do_initial_frontdoor_accesses) begin
      initial_frontdoor_accesses();
      ovm_report_info("HQM_TBEOTSTATUS_SEQ000",$psprintf("HQM_TBEOT_SEQ000_Step0a: completed initial_frontdoor_accesses"), OVM_MEDIUM);
    end
	
    //-------- SYS:	
    SYS_Poll_task();  
    ovm_report_info("HQM_TBEOTSTATUS_SEQ000",$psprintf("HQM_TBEOT_SEQ000_Step0: completed SYS_Poll_task"), OVM_MEDIUM);
	      
    //-------- CHP:	
    //--CHP_histlist_task();
    //--ovm_report_info("HQM_TBEOTSTATUS_SEQ000",$psprintf("HQM_TBEOT_SEQ000_Step1: completed CHP_histlist_task"), OVM_MEDIUM);

    CHP_Count_Poll_task();  
    ovm_report_info("HQM_TBEOTSTATUS_SEQ000",$psprintf("HQM_TBEOT_SEQ000_Step1: completed CHP_Count_Poll_task"), OVM_MEDIUM);
	      
    CHP_DropCount_Poll_task(); 
    ovm_report_info("HQM_TBEOTSTATUS_SEQ000",$psprintf("HQM_TBEOT_SEQ000_Step2: completed CHP_DropCount_Poll_task"), OVM_MEDIUM);

    CHP_CQDepth_Poll_task();
    ovm_report_info("HQM_TBEOTSTATUS_SEQ000",$psprintf("HQM_TBEOT_SEQ000_Step3: completed CHP_CQDepth_Poll_task"), OVM_MEDIUM);

    CHP_histlist_pushpopptr_Poll_task();   		
    ovm_report_info("HQM_TBEOTSTATUS_SEQ000",$psprintf("HQM_TBEOT_SEQ000_Step4: completed CHP_histlist_pushpopptr_Poll_task"), OVM_MEDIUM);  

    CHP_CreditCount_PP_task(); 
    ovm_report_info("HQM_TBEOTSTATUS_SEQ000",$psprintf("HQM_TBEOT_SEQ000_Step5: completed CHP_CreditCount_PP_task"), OVM_MEDIUM);
	
    //-------- LSP:	
    LSP_Count_Poll_task();  
    ovm_report_info("HQM_TBEOTSTATUS_SEQ000",$psprintf("HQM_TBEOT_SEQ000_Step6: completed LSP_Count_Poll_task"), OVM_MEDIUM);

    ovm_report_info("HQM_TBEOTSTATUS_SEQ000",$psprintf("HQM_TBEOT_SEQ000_Stepn: completed "), OVM_MEDIUM);

    set_test_done(100);
  endtask : body
   
  task set_test_done(int test_done_delay = 1); 
    bit         do_cfg_seq;
    bit [31:0]  cfg_val;
    hqm_cfg_seq cfg_seq;

    i_hqm_cfg.set_cfg($psprintf("TEST_DONE %d",test_done_delay),do_cfg_seq);

    if (do_cfg_seq) begin
      `ovm_create(cfg_seq)
      cfg_seq.inst_suffix = inst_suffix;
      cfg_seq.pre_body();
      start_item(cfg_seq);
      finish_item(cfg_seq);
      cfg_seq.post_body();
    end
  endtask : set_test_done

  task write_reg(string reg_hier = "",input sla_ral_data_t wr_val, input bit backdoor = 1'b0); 
    bit         do_cfg_seq;
    bit [31:0]  cfg_val;
    hqm_cfg_seq cfg_seq;

    i_hqm_cfg.set_cfg({(backdoor && !cfg.force_frontdoor) ? "bwr " : "wr ",reg_hier,$psprintf(" 0x%08x",wr_val)},do_cfg_seq);

    if (do_cfg_seq) begin
      `ovm_create(cfg_seq)
      cfg_seq.inst_suffix = inst_suffix;
      cfg_seq.pre_body();
      start_item(cfg_seq);
      finish_item(cfg_seq);
      cfg_seq.post_body();
    end
  endtask : write_reg

  task read_reg(string reg_hier = "",output sla_ral_data_t rd_val, input bit backdoor = 1'b0); 
    bit         do_cfg_seq;
    bit [31:0]  cfg_val;
    hqm_cfg_seq cfg_seq;

    i_hqm_cfg.set_cfg({(backdoor && !cfg.force_frontdoor) ? "brd " : "rd ",reg_hier},do_cfg_seq);

    if (do_cfg_seq) begin
      `ovm_create(cfg_seq)
      cfg_seq.inst_suffix = inst_suffix;
      cfg_seq.pre_body();
      start_item(cfg_seq);
      finish_item(cfg_seq);
      cfg_seq.post_body();
      rd_val = cfg_seq.last_rd_val;
    end else begin
      i_hqm_cfg.get_cfg({"rd ",reg_hier},cfg_val);
      rd_val = cfg_val;
    end
  endtask : read_reg

  task read_reg_index(string reg_hier = "",int index, output sla_ral_data_t rd_val, input bit backdoor = 1'b0); 
    bit         do_cfg_seq;
    bit [31:0]  cfg_val;
    hqm_cfg_seq cfg_seq;

    i_hqm_cfg.set_cfg($psprintf((backdoor && !cfg.force_frontdoor) ? "brd %s[%0d]" : "rd %s[%0d]",reg_hier,index),do_cfg_seq);

    if (do_cfg_seq) begin
      `ovm_create(cfg_seq)
      cfg_seq.inst_suffix = inst_suffix;
      cfg_seq.pre_body();
      start_item(cfg_seq);
      finish_item(cfg_seq);
      cfg_seq.post_body();
      rd_val = cfg_seq.last_rd_val;
    end else begin
      i_hqm_cfg.get_cfg($psprintf("rd %s[%0d]",reg_hier,index),cfg_val);
      rd_val = cfg_val;
    end
  endtask : read_reg_index

  task get_reg_index(string reg_hier = "",int index, output sla_ral_data_t rd_val);
    bit [31:0]  cfg_val;

    i_hqm_cfg.get_cfg($psprintf("rd %s[%0d]",reg_hier,index),cfg_val);
    rd_val = cfg_val;
  endtask : get_reg_index

  //-------------------------------------------------
  //-- Task: initial_frontdoor_accesses
  //-------------------------------------------------  
  task initial_frontdoor_accesses(); 
    sla_ral_data_t                wr_val;

    wr_val = '0;

    write_reg("aqed_pipe.cfg_unit_version",wr_val, 1'b0); 
    write_reg("atm_pipe.cfg_unit_version",wr_val, 1'b0); 
    write_reg("credit_hist_pipe.cfg_unit_version",wr_val, 1'b0); 
    write_reg("direct_pipe.cfg_unit_version",wr_val, 1'b0); 
    write_reg("list_sel_pipe.cfg_unit_version",wr_val, 1'b0); 
    write_reg("nalb_pipe.cfg_unit_version",wr_val, 1'b0); 
    write_reg("reorder_pipe.cfg_unit_version",wr_val, 1'b0); 
    write_reg("qed_pipe.cfg_unit_version",wr_val, 1'b0); 
    write_reg("hqm_system_csr.cfg_unit_version",wr_val, 1'b0); 

  endtask:initial_frontdoor_accesses

  //-------------------------------------------------
  //-- Task: SYS_Poll_task
  //-------------------------------------------------  
  task SYS_Poll_task(); 
    sla_ral_data_t                rd_val;
    sla_ral_data_t                rd_val_tmp;

    //------------------------   
    //-- hqm_system_csr.WB_DIR_CQ_STATE[96] 
    //-- hqm_system_csr.WB_LDB_CQ_STATE[64]   
    //------------------------   
    for (int i = 0 ; i < hqm_pkg::NUM_DIR_CQ ; i++) begin
      read_reg_index("hqm_system_csr.wb_dir_cq_state",i,rd_val,1'b1);
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: hqm_system_csr.wb_dir_cq_state[%0d] = 0x%08x", i, rd_val), OVM_LOW) 
    end  
	 
    for (int i = 0 ; i < hqm_pkg::NUM_LDB_CQ ; i++) begin
      read_reg_index("hqm_system_csr.wb_ldb_cq_state",i,rd_val,1'b1);
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: hqm_system_csr.wb_ldb_cq_state[%0d] = 0x%08x", i, rd_val), OVM_LOW) 
    end  
  endtask:SYS_Poll_task

  //-------------------------------------------------
  //-- Task: CHP_CQDepth_Poll_task
  //-------------------------------------------------  
  task CHP_CQDepth_Poll_task(); 
    sla_ral_data_t                rd_val;
    sla_ral_data_t                rd_val_tmp;

    //------------------------   
    //== credit_hist_pipe.cfg_dir_cq_depth[128]  
    //== credit_hist_pipe.cfg_ldb_cq_depth[64] 
    //------------------------ 	
	 
    for (int i = 0 ; i < hqm_pkg::NUM_DIR_CQ ; i++) begin
      read_reg_index("credit_hist_pipe.cfg_dir_cq_depth",i,rd_val,1'b1);

      if (cfg.do_cq_depth_chk && rd_val != i_hqm_cfg.dir_pp_cq_cfg[i].cq_token_count) begin
        `ovm_error("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.cfg_dir_cq_depth[%0d] = 0x%08x, dir_pp_cq_cfg[%0d].cq_token_count=%0d", i, rd_val, i, i_hqm_cfg.dir_pp_cq_cfg[i].cq_token_count)) 
      end
    end  
	 
    for (int i = 0 ; i < hqm_pkg::NUM_LDB_CQ ; i++) begin
      read_reg_index("credit_hist_pipe.cfg_ldb_cq_depth",i,rd_val,1'b1);

      if (cfg.do_cq_depth_chk && rd_val != i_hqm_cfg.ldb_pp_cq_cfg[i].cq_token_count) begin
        `ovm_error("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.cfg_ldb_cq_depth[%0d] = 0x%08x, ldb_pp_cq_cfg[%0d].cq_token_count=%0d", i, rd_val, i, i_hqm_cfg.ldb_pp_cq_cfg[i].cq_token_count)) 
      end
    end  
  endtask:CHP_CQDepth_Poll_task
   
  //-------------------------------------------------
  //-- Task: CHP_CreditCount_PP_task
  //-------------------------------------------------    
  task CHP_CreditCount_PP_task(); 
    sla_ral_data_t      rd_val;

    for (int i = 0 ; i < hqm_pkg::NUM_VAS ; i++) begin
      read_reg_index("credit_hist_pipe.cfg_vas_credit_count",i,rd_val,1'b1);
      vas_credit_count[i] = rd_val;

      if ($test$plusargs("HQM_EOT_RD_SEQ_ENABLE_CREDIT_CHECK") && !$test$plusargs("HQM_EOT_RD_SEQ_BYPASS_CREDIT_CHECK")) begin  
        if((i==0 && $test$plusargs("HQM_EOT_RD_SEQ_BYPASS_CREDIT_CHECK_VAS0")) || 
           (i==1 && $test$plusargs("HQM_EOT_RD_SEQ_BYPASS_CREDIT_CHECK_VAS1")) ||
           (i==2 && $test$plusargs("HQM_EOT_RD_SEQ_BYPASS_CREDIT_CHECK_VAS2")) ||
           ( $test$plusargs("HQM_EOT_RD_SEQ_BYPASS_CREDIT_CHECK"))	   	
          ) begin
           if (vas_credit_count[i] != i_hqm_pp_cq_status.vas_credit_avail(i)) begin
             `ovm_warning(get_full_name(),$psprintf("VAS 0x%0x credits mismatch - HW=%0d TB=%0d",
                                        	  i,
                                        	  vas_credit_count[i],
                                        	  i_hqm_pp_cq_status.vas_credit_avail(i)
                                        	 ))
           end

           if (vas_credit_count[i] != i_hqm_cfg.vas_cfg[i].credit_cnt) begin
             `ovm_warning(get_full_name(),$psprintf("VAS 0x%0x credits lost - HW=%0d Initial=%0d",
                                        	  i,
                                        	  vas_credit_count[i],
                                        	  i_hqm_cfg.vas_cfg[i].credit_cnt
                                        	 ))
           end

        end else begin 
           if (vas_credit_count[i] != i_hqm_pp_cq_status.vas_credit_avail(i)) begin
             `ovm_error(get_full_name(),$psprintf("VAS 0x%0x credits mismatch - HW=%0d TB=%0d",
                                        	  i,
                                        	  vas_credit_count[i],
                                        	  i_hqm_pp_cq_status.vas_credit_avail(i)
                                        	 ))
           end

           if (vas_credit_count[i] != i_hqm_cfg.vas_cfg[i].credit_cnt) begin
             `ovm_error(get_full_name(),$psprintf("VAS 0x%0x credits lost - HW=%0d Initial=%0d",
                                        	  i,
                                        	  vas_credit_count[i],
                                        	  i_hqm_cfg.vas_cfg[i].credit_cnt
                                        	 ))
           end
        end	
      end
    end  
  endtask:CHP_CreditCount_PP_task	 
	    
  //-------------------------------------------------
  //-- Task: CHP_histlist_pushpopptr_Poll_task
  //-------------------------------------------------    
  task CHP_histlist_pushpopptr_Poll_task(); 
    sla_ral_data_t                rd_val, rd_val1;

    //------------------------   
    //==  credit_hist_pipe.cfg_hist_list_push_ptr[64]  
    //==  credit_hist_pipe.cfg_hist_list_pop_ptr[64] 
    //==  
    //==  expect  cfg_hist_list_push_ptr[i]= cfg_hist_list_pop_ptr[i]=> hist_list is empty in EOT	
    //------------------------	
    for (int i = 0 ; i < hqm_pkg::NUM_LDB_CQ ; i++) begin
      read_reg_index("credit_hist_pipe.cfg_hist_list_push_ptr",i,rd_val,1'b1);
	     
      read_reg_index("credit_hist_pipe.cfg_hist_list_pop_ptr",i,rd_val1,1'b1);

      if (cfg.do_cq_histlist_chk && rd_val != rd_val1) begin
        `ovm_error("HQM_CFGCHP_SEQ0",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.cfg_hist_list_push_ptr/cfg_hist_list_pop_ptr[%0d]: push_ptr (0x%08x) does not match pop_ptr (0x%08x), CHP his_list is not empty", i, rd_val, rd_val1))
      end     	         
    end  
  endtask:CHP_histlist_pushpopptr_Poll_task   

  //-------------------------------------------------
  //-- Task: CHP_histlist_task
  //-------------------------------------------------    
  task CHP_histlist_task(); 
    sla_ral_data_t                rd_val, rd_val1;

    //------------------------   
    //==  credit_hist_pipe.CFG_HIST_LIST_0[2048]  
    //==  credit_hist_pipe.CFG_HIST_LIST_1[2048]  
    //==  
    //------------------------	
    for (int i = 0 ; i < 2048 ; i++) begin
      read_reg_index("credit_hist_pipe.CFG_HIST_LIST_0",i,rd_val,1'b0);
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.CFG_HIST_LIST_0.rd=0x%0x", rd_val), OVM_LOW)
	     
      read_reg_index("credit_hist_pipe.CFG_HIST_LIST_1",i,rd_val1,1'b0);
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.CFG_HIST_LIST_0.rd=0x%0x", rd_val1), OVM_LOW)

      //if (cfg.do_cq_histlist_chk && rd_val != rd_val1) begin
      //  `ovm_error("HQM_CFGCHP_SEQ0",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.cfg_hist_list_push_ptr/cfg_hist_list_pop_ptr[%0d]: push_ptr (0x%08x) does not match pop_ptr (0x%08x), CHP his_list is not empty", i, rd_val, rd_val1))
      //end     	         
    end  
  endtask:CHP_histlist_task   

  //-------------------------------------------------
  //-- Task: CHP_Count_Poll_task
  //-------------------------------------------------    
  task CHP_Count_Poll_task(); 
    sla_ral_data_t      rd_val;

    read_reg("credit_hist_pipe.cfg_counter_chp_error_drop_l",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.CFG_COUNTER_CHP_ERROR_DROP_L = %0d", rd_val), OVM_LOW)
   
    read_reg("credit_hist_pipe.cfg_counter_chp_error_drop_h",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.CFG_COUNTER_CHP_ERROR_DROP_H = %0d", rd_val), OVM_LOW)
   
    //--syndrome
    read_reg("credit_hist_pipe.cfg_syndrome_00.syndvalid",rd_val);
    if (cfg.do_chp_syndrome_chk && rd_val) begin
      `ovm_error("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.cfg_syndrome_00.syndvalid = %0d", rd_val))

      read_reg("credit_hist_pipe.cfg_syndrome_00",rd_val);
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.cfg_syndrome_00 = %0d", rd_val), OVM_LOW)
    end else begin
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.cfg_syndrome_00.syndvalid = %0d", rd_val), OVM_LOW)
    end
 
    //--syndrome
    read_reg("credit_hist_pipe.cfg_syndrome_01.syndvalid",rd_val);
    if (cfg.do_chp_syndrome_chk && rd_val) begin
      `ovm_error("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.cfg_syndrome_01.syndvalid = %0d", rd_val))

      read_reg("credit_hist_pipe.cfg_syndrome_01",rd_val);
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.cfg_syndrome_01 = %0d", rd_val), OVM_LOW)
    end else begin
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: credit_hist_pipe.cfg_syndrome_01.syndvalid = %0d", rd_val), OVM_LOW)
    end
 
    //--syndrome
    read_reg("atm_pipe.cfg_syndrome_00.syndvalid",rd_val);
    if (cfg.do_atm_syndrome_chk && rd_val) begin
      `ovm_error("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: atm_pipe.cfg_syndrome_00.syndvalid = %0d", rd_val))

      read_reg("atm_pipe.cfg_syndrome_00",rd_val);
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: atm_pipe.cfg_syndrome_00 = %0d", rd_val), OVM_LOW)
    end else begin
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: atm_pipe.cfg_syndrome_00.syndvalid = %0d", rd_val), OVM_LOW)
    end
 
    //--syndrome
    read_reg("atm_pipe.cfg_syndrome_01.syndvalid",rd_val);
    if (cfg.do_atm_syndrome_chk && rd_val) begin
      `ovm_error("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: atm_pipe.cfg_syndrome_01.syndvalid = %0d", rd_val))

      read_reg("atm_pipe.cfg_syndrome_01",rd_val);
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: atm_pipe.cfg_syndrome_01 = %0d", rd_val), OVM_LOW)
    end else begin
      `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: atm_pipe.cfg_syndrome_01.syndvalid = %0d", rd_val), OVM_LOW)
    end
 
  endtask:CHP_Count_Poll_task
   
  //-------------------------------------------------
  //-- Task: CHP_DropCount_Poll_task
  //-------------------------------------------------    
  task CHP_DropCount_Poll_task(); 
    sla_ral_data_t                rd_val;

    //-- AQED feature register checking
    read_reg("aqed_pipe.cfg_detect_feature_operation_00",rd_val);
    `ovm_info("HQMCORE_EOTSTATUS_SEQ000",$psprintf("HQMCORE_EOTSTATUS_SEQ000: aqed_regs.CFG_DETECT_FEATURE_OPERATION_00 = 0x%0x", rd_val), OVM_LOW)

  endtask:CHP_DropCount_Poll_task


  //-------------------------------------------------
  //-- Task: LSP_Count_Poll_task
  //-------------------------------------------------    
  task LSP_Count_Poll_task(); 
    sla_ral_data_t      rd_val;

    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_0_l",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_0_l = %0d", rd_val), OVM_LOW)
    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_0_h",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_0_h = %0d", rd_val), OVM_LOW)

    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_1_l",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_1_l = %0d", rd_val), OVM_LOW)
    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_1_h",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_1_h = %0d", rd_val), OVM_LOW)

    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_2_l",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_2_l = %0d", rd_val), OVM_LOW)
    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_2_h",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_2_h = %0d", rd_val), OVM_LOW)

    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_3_l",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_3_l = %0d", rd_val), OVM_LOW)
    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_3_h",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_3_h = %0d", rd_val), OVM_LOW)

    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_4_l",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_4_l = %0d", rd_val), OVM_LOW)
    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_4_h",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_4_h = %0d", rd_val), OVM_LOW)

    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_5_l",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_5_l = %0d", rd_val), OVM_LOW)
    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_5_h",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_5_h = %0d", rd_val), OVM_LOW)

    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_6_l",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_6_l = %0d", rd_val), OVM_LOW)
    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_6_h",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_6_h = %0d", rd_val), OVM_LOW)

    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_7_l",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_7_l = %0d", rd_val), OVM_LOW)
    read_reg("list_sel_pipe.cfg_cq_ldb_sched_slot_count_7_h",rd_val);
    `ovm_info("HQM_EOTSTATUS_SEQ000",$psprintf("HQM_EOTSTATUS_SEQ000: list_sel_pipe.cfg_cq_ldb_sched_slot_count_7_h = %0d", rd_val), OVM_LOW)
   
   
  endtask:LSP_Count_Poll_task

endclass : hqm_eot_rd_seq
