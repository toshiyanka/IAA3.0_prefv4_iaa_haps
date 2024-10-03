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
`ifndef cfg_error_test__SV
`define cfg_error_test__SV

import IosfPkg::*;
import hqm_tb_sequences_pkg::*;
//ns: deprecated import hcw_raw_sequences_pkg::*;
import hqm_saola_pkg::*;
import sla_pkg::*;
//import hqm_core_saola_pkg::*; 
//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class cfg_error_test extends hqm_iosf_base_test;

  `ovm_component_utils(cfg_error_test)

   string        seq_name = "";

   //extern task          run     ();                // std OVM run 
  function new(string name = "cfg_error_test", ovm_component parent = null);
    super.new(name,parent);
    $value$plusargs("IOSF_PRIM_FILE=%s",seq_name);

     if (seq_name == "") begin
      `ovm_info("IOSF_PRIM_FILE_SEQ","+IOSF_PRIM_FILE=<file name> not set",OVM_LOW)
    end else begin
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("+IOSF_PRIM_FILE=%s",seq_name),OVM_LOW)
    end

  endfunction

 /* function void build();
  super.build();
// disable assertion PRI_201
  // i_hqm_tb_env.iosf_pagt_cfg.setAssertionDisable ("PRI_286");
   //i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_286");
  // i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_286");
 
  endfunction */

  function void connect();
    super.connect();
     
     if (seq_name == "back2back_cfgrd_badCmdparity_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgrd_badCmdparity_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");


    end 

     if (seq_name == "back2back_cfgrd_badDataparity_seq") begin
   i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgrd_badDataparity_seq");
    end 

    if (seq_name == "back2back_cfgwr_badCmdparity_seq") begin
   i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
   i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgwr_badCmdparity_seq");
   i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");

    end 

     if (seq_name == "back2back_cfgwr_badDataparity_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgwr_badDataparity_seq");
    //i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","error_common_seq");
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
    end 

     if (seq_name == "back2back_cfgwr_poison_seq") begin
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgwr_poison_seq");
      // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","error_common_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
        end
        
        if (seq_name == "back2back_cfgwr_rd_seq") begin
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgwr_rd_seq");
      // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","error_common_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
        end 
 

  if (seq_name == "back2back_cfgrd_badCmdparity_seq1") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgrd_badCmdparity_seq1");
    end 

   if (seq_name == "hqm_tb_cfg_file_mode_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    //i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgrd_badCmdparity_seq1");
    end
    
     if (seq_name == "back2back_cfgrd_unsupported_seq") begin
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgrd_unsupported_seq");
      // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","error_common_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
        end  

      if (seq_name == "back2back_cfgwr_unsupported_seq") begin
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgwr_unsupported_seq");
      // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","error_common_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
        end    

       if (seq_name == "back2back_cfgwr_badtxn_seq") begin
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgwr_badtxn_seq");
      // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","error_common_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
        end 
      
       if (seq_name == "back2back_cfgwr_badlength_seq") begin
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgwr_badlength_seq");
      // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","error_common_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
        end
       
        if (seq_name == "back2back_cfgwr_badlength_seq11") begin
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgwr_badlength_seq11");
      // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","error_common_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
        end

       if (seq_name == "back2back_cfgwr_badlength_seq22") begin
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgwr_badlength_seq22");
      // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","error_common_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_config_file_mode_seq");
        end
 
        
        if (seq_name == "back2back_cfgwr_badlbe_seq1") begin
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgwr_badlbe_seq1");
      // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","error_common_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","iosf_eot_seq");
        end 
 
 
    //i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","error_common_seq");

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
