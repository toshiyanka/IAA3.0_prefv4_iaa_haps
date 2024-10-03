// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_pwr_extra_data_phase_seq.sv
// Author : rsshekha
// Description :
//
//   prochot assertion deassertion seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`ifndef HQM_PWR_EXTRA_DATA_SEQ_SV
`define HQM_PWR_EXTRA_DATA_SEQ_SV

class hqm_pwr_extra_data_phase_seq extends sla_sequence_base;

  `ovm_sequence_utils(hqm_pwr_extra_data_phase_seq, sla_sequencer)

  // -- Pointer to hqm_tb_env, in order to obtain handle to pins -- //
  hqm_tb_env      hqm_env;
  virtual hqm_misc_if  pins;


  string pwr_seq;
  hqm_pwr_D0_to_D3hot_to_D0_seq D0_to_D3hot_to_D0;
  hqm_pwr_D0_to_D3hot_check_nsr_seq check_nsr_seq;
  hqm_pwr_warm_reset_in_Dstate_seq  warm_reset_in_Dstate;
  hqm_pwr_D0_transitions_seq flr_in_D0act;
  hqm_pwr_smoke_seq smoke_seq;
  hqm_pwr_lcp_shift_check_seq lcp_shift_check_seq;
  hqm_pwr_long_seq pwr_long_seq;
  hqm_pwr_fuse_test_seq fuse_seq;
  hqm_pwr_fuse_pull_test_seq fuse_pull_seq;
  hqm_pwr_mra_trim_in_D3hot_seq  mra_trim_in_D3hot_seq;
  hqm_pwr_pmcsr_disable_test_seq pmcsr_disable_test_seq;
  hqm_pwr_pmcsr_disable_flr_D3hot_seq pmcsr_disable_flr_D3hot_seq;
  hqm_pwr_iosf_transactions_in_D3hot_seq iosf_transactions_in_D3hot_seq;
  hqm_pwr_pwrgate_req_in_D3hot_seq pwrgate_req_in_D3hot_seq;
  hqm_pwr_override_pm_cfg_control_seq override_pm_cfg_control_seq;
  hqm_hw_reset_force_pwr_seq          hw_reset_force_pwr_seq;   
  hqm_hw_reset_force_pwr_seq2         hw_reset_force_pwr_seq2;   
  
  hqm_tb_cfg_file_mode_seq i_cfg_file_mode_seq;
  hqm_tb_cfg_file_mode_seq i_hcw_file_mode_seq;
  hcw_perf_dir_ldb_test1_hcw_seq hcw_traffic_seq;

  function new(string name = "hqm_pwr_extra_data_phase_seq");
    super.new(name);

    // -- Obtain handles to hqm_tb_env and correspondingly to hqm_misc_if -- //

    `sla_assert( $cast(hqm_env,   sla_utils::get_comp_by_name("i_hqm_tb_env")), (("Could not find i_hqm_tb_env\n")));
    if(hqm_env   == null) `ovm_error(get_full_name(),$psprintf("i_hqm_tb_env ptr is null")) else 
                          `ovm_info(get_full_name(),$psprintf("i_hqm_tb_env ptr is not null"),OVM_LOW) 

    `sla_assert( $cast(pins, hqm_env.pins),                               (("Could not find hqm_misc_if pointer \n")));
    if(pins      == null) `ovm_error(get_full_name(),$psprintf("hqm_misc_if ptr is null"))    else
                          `ovm_info(get_full_name(),$psprintf("hqm_misc_if ptr is not null"),OVM_LOW)   

  endfunction

  extern virtual task body();

endclass

task hqm_pwr_extra_data_phase_seq::body();
    int  trigger_count[10], trigger_count_t[10];

   `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_extra_data_phase_seq started \n"),OVM_LOW)

   if (!$value$plusargs("HQM_PWR_SEQ=%s",pwr_seq)) pwr_seq = "HQM_D0_TO_D3HOT_TO_D0_SEQ";

   `ovm_info(get_full_name(),$sformatf("selected pwr_seq=%s",pwr_seq),OVM_LOW)

   fork 
   begin
   case (pwr_seq)
       "HQM_D0_TO_D3HOT_TO_D0_SEQ": begin `ovm_do(D0_to_D3hot_to_D0); end
       "HQM_WARM_RESET_IN_D3HOT_SEQ": begin `ovm_do_with(warm_reset_in_Dstate, {warm_reset_in_Dstate.cfg.Dstate==`HQM_D3STATE;}); end
       "HQM_WARM_RESET_IN_D0ACT_SEQ": begin `ovm_do_with(warm_reset_in_Dstate, {warm_reset_in_Dstate.cfg.Dstate==`HQM_D0STATE;}); end
       "HQM_FLR_IN_D0ACT_SEQ": begin `ovm_do(flr_in_D0act); end
       "HQM_SMOKE_SEQ": begin `ovm_do(smoke_seq); end
       "HQM_LCP_SHIFT_CHECK_SEQ": begin `ovm_do(lcp_shift_check_seq); end
       "HQM_PWR_LONG_SEQ": begin `ovm_do(pwr_long_seq); end
       "HQM_NSR_SEQ": begin `ovm_do(check_nsr_seq); end
       "HQM_PWR_FUSE_SEQ": begin `ovm_do(fuse_seq); end
       "HQM_PWR_FUSE_PULL_SEQ": begin `ovm_do(fuse_pull_seq); end
       "HQM_PWR_MRA_TRIM_IN_D3HOT_SEQ": begin `ovm_do(mra_trim_in_D3hot_seq); end
       "HQM_PWR_PMCSR_DISABLE_TEST_SEQ": begin `ovm_do(pmcsr_disable_test_seq); end
       "HQM_PWR_PMCSR_DISABLE_FLR_D3HOT_SEQ": begin `ovm_do(pmcsr_disable_flr_D3hot_seq); end
       "HQM_PWR_IOSF_TRANSACTIONS_IN_D3HOT_SEQ": begin `ovm_do(iosf_transactions_in_D3hot_seq); end
       "HQM_PWR_PWRGATE_REQ_IN_D3HOT_SEQ": begin `ovm_do(pwrgate_req_in_D3hot_seq); end
       "HQM_PWR_OVERRIDE_PM_CFG_CONTROL_SEQ": begin `ovm_do(override_pm_cfg_control_seq); end
       "HQM_HW_RESET_FORCE_PWR_SEQ": begin `ovm_do(hw_reset_force_pwr_seq); end
       "HQM_HW_RESET_FORCE_PWR_SEQ_2": begin `ovm_do(hw_reset_force_pwr_seq2); end

   endcase

    if (!($test$plusargs("HQM_SKIP_HCW_TRAFFIC"))) begin
          `ovm_info(get_full_name(),$sformatf("\n calling i_cfg_file_mode_seq after pwr extra data phase\n"),OVM_LOW)
          i_cfg_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_cfg_file_mode_seq");
       if ($test$plusargs("HQM_PWR_CFG_CFT") && !$test$plusargs("HQM_SKIP_POST_CFT")) begin   
          `ovm_info(get_full_name(),$sformatf("\n picking HQM_PWR_CFG_CFT\n"),OVM_LOW)
          i_cfg_file_mode_seq.set_cfg("HQM_PWR_CFG_CFT", 1'b1);
       end 
       else begin 
          `ovm_info(get_full_name(),$sformatf("\n picking HQM_SEQ_CFG\n"),OVM_LOW)
          i_cfg_file_mode_seq.set_cfg("HQM_SEQ_CFG", 1'b1);
       end 
          i_cfg_file_mode_seq.start(get_sequencer());
       `ovm_info(get_full_name(),$sformatf("\n configuration ended \n"),OVM_LOW)
 
       if ($test$plusargs("HQM_PWR_HCW_CFT") && !$test$plusargs("HQM_SKIP_POST_CFT")) begin   
          `ovm_info(get_full_name(),$sformatf("\n Generating hcw traffic after pwr extra data phase using cft \n"),OVM_LOW)
          i_hcw_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hcw_file_mode_seq");
          i_hcw_file_mode_seq.set_cfg("HQM_PWR_HCW_CFT", 1'b0);
          i_hcw_file_mode_seq.start(get_sequencer());
       end 
       else begin 
          `ovm_info(get_full_name(),$sformatf("\n Generating hcw traffic after pwr extra data phase using seq \n"),OVM_LOW)
           `ovm_do (hcw_traffic_seq)
       end 
    end 

  end//--fork_begin_end
 
  //----------------------
  begin
        forever begin
            @(posedge pins.hqm_triggers[0]);
            trigger_count[0]++;
        end
  end
  begin
        forever begin
            @(posedge pins.hqm_triggers[1]);
            trigger_count[1]++;
        end
  end
  begin
        forever begin
            @(posedge pins.hqm_triggers[2]);
            trigger_count[2]++;
        end
  end
  begin
        forever begin
            @(posedge pins.hqm_triggers[3]);
            trigger_count[3]++;
        end
  end
  begin
        forever begin
            @(posedge pins.hqm_triggers[4]);
            trigger_count[4]++;
        end
  end
  begin
        forever begin 
            //--bit5=1 always
            if(pins.hqm_triggers[5]==1'b1) trigger_count[5]++;
            @(posedge pins.hqm_triggers[5]);
            trigger_count[5]++;
        end
  end
  begin
        forever begin
            //--bit6=1 always
            if(pins.hqm_triggers[6]==1'b1) trigger_count[6]++;
            @(posedge pins.hqm_triggers[6]);
            trigger_count[6]++;
        end
  end
  begin
        forever begin
            @(posedge pins.hqm_triggers[7]);
            trigger_count[7]++;
        end
  end
  begin
        forever begin
            @(posedge pins.hqm_triggers[8]);
            trigger_count[8]++;
        end
  end
  begin
        forever begin
            @(posedge pins.hqm_triggers[9]);
            trigger_count[9]++;
        end
  end
  join_any

  //--support trigger tests +has_rtdr_reg2_cfg_trigger
  for (int i=0;i<7;i++) begin
        if (trigger_count[i]==0) begin  
             if($test$plusargs("HQM_RTDR_TRIGGER_PW0_TEST") && i!=1 && i<6) //--TRIG_PM0[1]:ogcb_fet_en_b_pre 
               `ovm_error(get_full_name(),$psprintf("trigger_count[%0d] is %0d. should have triggered according to configuration  ", i, trigger_count[i]))
             if($test$plusargs("HQM_RTDR_TRIGGER_PW1_TEST") && i!=1 && i<7) //--TRIG_PM1[1]:prochot  
               `ovm_error(get_full_name(),$psprintf("trigger_count[%0d] is %0d. should have triggered according to configuration  ", i, trigger_count[i]))
        end
        `ovm_info(get_full_name(),$sformatf("\n trigger_count[%0d]=%0d\n", i, trigger_count[i]),OVM_LOW)
   end

    `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_extra_data_phase_seq ended \n"),OVM_LOW)

endtask

`endif 
