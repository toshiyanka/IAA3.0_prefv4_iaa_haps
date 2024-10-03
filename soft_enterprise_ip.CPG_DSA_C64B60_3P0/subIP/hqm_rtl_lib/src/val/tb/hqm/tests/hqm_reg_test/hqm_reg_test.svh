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
//-- Test
//-----------------------------------------------------------------------------------------------------
`ifndef HQM_REG_TEST__SV
`define HQM_REG_TEST__SV

import hqm_tb_cfg_sequences_pkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_reg_test extends hqm_base_test;

  `ovm_component_utils(hqm_reg_test)
 
  int resetm = 0; //reset_mode: when nonzero, exercise reset test
  int prdp_def = 0; //post reset data phase: (1=primary,2=backdoor,3=valid backdoor)
  int recfg_p = 0; //enable reconfig phase if nonzero
  int no_recfg_p = 0; //disable reconfig phase if nonzero

  hqm_tb_hcw_eot_file_mode_seq_stim_config        cfg;

  function new(string name = "hqm_reg_test", ovm_component parent = null);
    super.new(name,parent);
    $value$plusargs({"hraisresetm","=%d"}, this.resetm); //reset_mode
    $value$plusargs({"hraisprdp_def","=%d"}, this.prdp_def); //def val test
    $value$plusargs({"hraisrecfg_p","=%d"}, this.recfg_p); //reconfig phase
    $value$plusargs({"hraisno_recfg_p","=%d"}, this.no_recfg_p); //no recfg_p
    if(no_recfg_p != 0) recfg_p = 0; //disable reconfig phase
  endfunction : new

  function void build();
    super.build();
    if(resetm != 0 || prdp_def != 0) 
     begin : resetm_nz //reset_mode(do second reset when nonzero)
       i_hqm_tb_env.add_test_phase("POST_RESET_DATA_PHASE","FLUSH_PHASE","BEFORE");
       i_hqm_tb_env.add_test_phase("RECONFIG_PHASE","POST_RESET_DATA_PHASE","BEFORE");
       i_hqm_tb_env.add_test_phase("PRE_RECONFIG_PHASE","RECONFIG_PHASE","BEFORE");
       i_hqm_tb_env.add_test_phase("HARD_RERESET_PHASE","PRE_RECONFIG_PHASE","BEFORE");
     end  : resetm_nz
  endfunction : build

  function void connect();
    super.connect();
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_opt_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","test_hqm_ral_attr_seq");

    if($test$plusargs("CHK_RAL_VIA_BACKDOOR")) begin
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","EXTRA_DATA_PHASE","hqm_backdoor_register_access_seq");
    end

    if(resetm != 0) 
     begin : connect_resetm //reset_mode(do second reset when nonzero)
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","PRE_RECONFIG_PHASE","test_hqm_ral_attr_seq"); //apply shadow reset
       if(resetm == 1)
        begin : connect_resetm_eq_1 //cold reset
          i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","HARD_RERESET_PHASE","hqm_cold_reset_sequence");
        end   : connect_resetm_eq_1
       if(resetm == 2)
        begin : connect_resetm_eq_2 //warm reset
          if($test$plusargs("HQM_NON_STD_WARM_RST_SEQ")) begin i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","HARD_RERESET_PHASE","hqm_non_standard_warm_reset_seq"); end
          else                                           begin i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","HARD_RERESET_PHASE","hqm_reset_init_sequence"); end
        end   : connect_resetm_eq_2
       if(resetm == 3)
        begin : connect_resetm_eq_3 // Do to D3 to D0
          i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","HARD_RERESET_PHASE","hqm_pwr_D0_to_D3hot_check_nsr_seq");
          //NULL RECONFIG_PHASE
        end   : connect_resetm_eq_3
       if(resetm == 4)
        begin : connect_resetm_eq_4 //flr reset
          i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","HARD_RERESET_PHASE","hqm_flr_rereset_seq");
        end   : connect_resetm_eq_4

     end   : connect_resetm

    if(recfg_p != 0) 
      begin : connect_recfg_p
          i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","RECONFIG_PHASE","hqm_tb_cfg_opt_file_mode_seq");
      end   : connect_recfg_p

    if(prdp_def != 0) 
      begin : connect_prdp
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","POST_RESET_DATA_PHASE","test_hqm_ral_attr_seq");
      end   : connect_prdp

    //-- xvm_pkg imported (03272020), move hqm_tb_hcw_eot_file_mode_seq_stim_config options to hqm_reg_test.opt 
    //cfg = hqm_tb_hcw_eot_file_mode_seq_stim_config::type_id::create("cfg");
    //cfg.randomize() with { do_eot_rd_seq == 0; do_eot_status_seq == 0; do_wait_clkreq_deassert_seq == 0; };
    //`stim_config_set(cfg,hqm_tb_hcw_eot_file_mode_seq_stim_config,hqm_tb_hcw_eot_file_mode_seq_stim_config::stim_cfg_name);

    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");
  endfunction


  //------------------
  //-- doConfig() 
  //------------------
  function void do_config();
 
  endfunction

  function void set_config();  

  endfunction

  function void set_override();
  endfunction


endclass
`endif
