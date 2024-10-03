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
`ifndef cfg_generic_test__SV
`define cfg_generic_test__SV

import IosfPkg::*;
import hqm_tb_sequences_pkg::*;
//ns: deprecated import hcw_raw_sequences_pkg::*;
import hqm_saola_pkg::*;
import sla_pkg::*;
//import hqm_core_saola_pkg::*; 
//-------------------------------------------------------------------------------------------------------
class MyTargetCplCallBack extends IosfBaseCallBack;
 `ifdef HQM_IOSF_2019_BFM
   function void execute (IosfAgtSlvTlm slvHandle, IosfTgtTxn tgtTxn);
 `else
   function void execute (IosfAgtTgtTlm slvHandle, IosfTgtTxn tgtTxn);
 `endif
    int attr_force_val, iosf_ttagl, u_pkt_cnt;
    int num_cnt_rs_change;

      ////////
      // Note: Must maimtain following order of calls for comparing
      // and writing to AP when over-riding Default CallBack
      // so the sequence will get correct response
      ////////
      if(!$value$plusargs("ATTR_FORCE_VAL=%d", attr_force_val))  attr_force_val = 0;
      if(!$value$plusargs("tag_opt=%d", iosf_ttagl)) iosf_ttagl = 0;
      if(!$value$plusargs("unsupport_pkt_cnt=%d", u_pkt_cnt)) u_pkt_cnt = 0;
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("AAA:attr_force_val=%0d, iosf_ttagl=%0d, u_pkt_cnt=%0d", attr_force_val,iosf_ttagl, u_pkt_cnt),OVM_LOW)

      // TC
      if (attr_force_val==1)
        tgtTxn.reqChId = 0;
      // RS
      if (attr_force_val==3) begin
          if ((tgtTxn.ttag >= iosf_ttagl) && (tgtTxn.ttag < (iosf_ttagl+u_pkt_cnt)) && (num_cnt_rs_change < u_pkt_cnt)) begin
              tgtTxn.root_space = 1;
              num_cnt_rs_change++;
          end
      end

      if (isSplitCplD (tgtTxn)) 
        //process the split CplD's (except for the last CplD)
        processSplitCplD (slvHandle, tgtTxn);
      else if (isLastCplD (tgtTxn)) 
        //process the last of split completions OR a single completion
        processLastCplD (slvHandle, tgtTxn);
      //process completion w/o data
      else processCpl (slvHandle, tgtTxn);
   endfunction: execute          
endclass: MyTargetCplCallBack

//-------------------------------------------------------------------------------------------------------
class cfg_generic_test extends hqm_iosf_base_test;

  `ovm_component_utils(cfg_generic_test)

   string        seq_name = "";
   MyTargetCplCallBack myTargetCplCB;

   //extern task          run     ();                // std OVM run 
  function new(string name = "cfg_generic_test", ovm_component parent = null);
    super.new(name,parent);
    $value$plusargs("IOSF_PRIM_FILE=%s",seq_name);

     if (seq_name == "") begin
      `ovm_info("IOSF_PRIM_FILE_SEQ","+IOSF_PRIM_FILE=<file name> not set",OVM_LOW)
    end else begin
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("+IOSF_PRIM_FILE=%s",seq_name),OVM_LOW)
    end

  endfunction

 function void build();
  super.build();
// disable assertion PRI_201
  // i_hqm_tb_env.iosf_pagt_cfg.setAssertionDisable ("PRI_286");
   //i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_286");
  // i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_286");

  myTargetCplCB = new();

  endfunction

  function void connect();
    super.connect();
     // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","'seq_name'");

      if (seq_name == "back2back_cfgrd_seq") begin
   i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgrd_seq");
     i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");
    end
    else
      if (seq_name == "back2back_cfgrdwr_seq1") begin
   i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgrdwr_seq1");
     i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");
      i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.registerCallBack(myTargetCplCB, '{Iosf::Cpl,Iosf::CplD});
    end
    else
     if (seq_name == "back2back_cfgwr_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","back2back_cfgwr_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");
    end 
    else
      if (seq_name == "cfg_genric_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","cfg_genric_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");
    end 

      if (seq_name == "cfg_genric_parallel_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","cfg_genric_parallel_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");

    end 
    
    if (seq_name == "cfg_rand_generic_seq") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","cfg_rand_generic_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");
    end 
 

  
         if (seq_name == "cfg_genric_seq11") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","cfg_genric_seq11");
    end 

    
      if (seq_name == "hqm_iosf_prim_cfg_rd_seq1") begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_iosf_prim_cfg_rd_seq1");
    end 


   // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_prim_pf_dump_seq");

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
