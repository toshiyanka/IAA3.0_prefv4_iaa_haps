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
`ifndef hqm_iosf_sideband_UC_test__SV
`define hqm_iosf_sideband_UC_test__SV

import IosfPkg::*;
import hqm_tb_sequences_pkg::*;
//ns: deprecated import hcw_raw_sequences_pkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_sideband_UC_test extends hqm_base_test;

  `ovm_component_utils(hqm_iosf_sideband_UC_test)
 string        seq_name = "";

  function new(string name = "hqm_iosf_sideband_UC_test", ovm_component parent = null);
    super.new(name,parent);
    $value$plusargs("IOSF_SIDE_FILE=%s",seq_name);

     if (seq_name == "") begin
      `ovm_info("IOSF_SIDE_FILE_SEQ","+IOSF_SIDE_FILE=<file name> not set",OVM_LOW)
    end else begin
      `ovm_info("IOSF_SIDE_FILE_SEQ",$psprintf("+IOSF_SIDE_FILE=%s",seq_name),OVM_LOW)
    end

  endfunction

  function void connect();
    super.connect();
    if (seq_name == "hqm_iosf_sb_cfgrd_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_sb_cfgrd_seq");
    end

    if (seq_name == "hqm_iosf_sb_unsupported_rd_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_sb_unsupported_rd_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_iosf_extra_data_phase_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
    end

   
    if (seq_name == "hqm_iosf_sb_unsupported_wr_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_sb_unsupported_wr_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_iosf_extra_data_phase_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
    end

    if (seq_name == "hqm_iosf_sb_unsupported_wr_seq1") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_sb_unsupported_wr_seq1");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_iosf_extra_data_phase_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
    end

    if (seq_name == "hqm_iosf_sb_pm_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_sb_pm_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_iosf_extra_data_phase_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
    end

    if (seq_name == "hqm_iosf_sb_boot_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_sb_boot_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_iosf_extra_data_phase_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
    end

    if (seq_name == "hqm_iosf_sb_memrd_fid_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_sb_memrd_fid_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
    end

     if (seq_name == "hqm_iosf_sb_cfgrd_fid_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_sb_cfgrd_fid_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
    end

    if (seq_name == "hqm_iosf_sb_cfgwr_fid_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_sb_cfgwr_fid_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
    end

     if (seq_name == "back2back_sb_unsupport_sai_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_sb_unsupport_sai_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_iosf_extra_data_phase_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
    end

    if (seq_name == "back2back_sb_unsupport_sai_wr_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_sb_unsupport_sai_wr_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_iosf_extra_data_phase_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
    end



     if (seq_name == "hqm_iosf_sb_global_opcode_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_sb_global_opcode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_iosf_extra_data_phase_seq");
    //i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","back2back_sb_memrd_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");

    end

    if (seq_name == "hqm_iosf_sb_global_opcode_seq1") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_sb_global_opcode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","back2back_sb_memrd_seq");
    //i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");

    end







    

     
       
     
   

 
   // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hcw_raw_file_seq");
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
