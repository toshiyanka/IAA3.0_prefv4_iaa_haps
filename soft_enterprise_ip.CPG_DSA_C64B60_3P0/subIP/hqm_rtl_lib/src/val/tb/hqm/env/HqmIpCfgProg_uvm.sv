
// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2016) Intel Corporation All Rights Reserved.
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
// File   : HqmIpCfgProg.sv
// Author : 
//
// Description :
//
// -----------------------------------------------------------------------------
`ifndef __HqmIpCfgProg__
`define __HqmIpCfgProg__

 

class HqmIpCfgProg extends HqmIpCfgMap;
  `uvm_object_utils(HqmIpCfgProg)
    

  //---
  function new(string name = "HqmIpCfgProg");
     super.new(name);
     program_cfg(); 
  endfunction: new

  //---
  function void program_cfg(); 
     
    `uvm_info(get_full_name(), $psprintf("HqmIpCfgProg::program_cfg() start"), UVM_LOW)
    init(); 
    program_hqm_base_cfg();
    program_hqm_fuse_cfg();
    program_hqm_iosf_cfg(); 
    program_hqm_local_iosf_cfg(); 
    program_hqm_ats_cfg(); 
    `uvm_info(get_full_name(), $psprintf("HqmIpCfgProg::program_cfg() done"), UVM_LOW)
  endfunction:program_cfg     
   
  //---
  virtual function void init();   
    hqm_base_intf_cfg = hqm_base_intf_prog::type_id::create("hqm_base_intf_prog");
    hqm_fuse_intf_cfg = hqm_fuse_intf_prog::type_id::create("hqm_fuse_intf_prog");
    hqm_iosf_intf_cfg = hqm_iosf_intf_prog::type_id::create("hqm_iosf_intf_prog");
    hqm_ats_intf_cfg  = hqm_ats_intf_prog::type_id::create("hqm_ats_intf_prog");

    `uvm_info(get_full_name(), $psprintf("HqmIpCfgProg::init() create intf_cfg"), UVM_LOW)
  endfunction: init  
   
  //---
  //---
  function set_fab_ism_rand_delay();
      Iosf::iosf_fab_ism_t fab_ism;
      int                  maxismdelay;

      fab_ism = fab_ism.first();
      `uvm_info(get_full_name(), $psprintf("set_fab_ism_rand_delay -- Start"), UVM_HIGH)
      do begin

          if ( !(std::randomize(maxismdelay) with { maxismdelay dist { 10 := 1, 20 := 1, 50 :=1 }; } ) )  begin
              `uvm_fatal(get_full_name(), $psprintf("Randomization failed"))
          end else begin
              iosf_pvc_cfg.maxISMDelay[fab_ism] = maxismdelay;
              `uvm_info(get_full_name(), $psprintf("maxISMDelay[%0s]=%0d", fab_ism.name(), iosf_pvc_cfg.maxISMDelay[fab_ism]), UVM_MEDIUM)
          end 
          fab_ism = fab_ism.next();
      end while (fab_ism != fab_ism.last());

      if ($value$plusargs("HQM_IOSF_PRIM_MAXISMDLY=%d", maxismdelay)) begin
          foreach (iosf_pvc_cfg.maxISMDelay[i]) begin 
             iosf_pvc_cfg.maxISMDelay[i] = maxismdelay;
             `uvm_info(get_full_name(), $psprintf("maxISMDelay[%0s]=%0d", i.name(), iosf_pvc_cfg.maxISMDelay[fab_ism]), UVM_MEDIUM)
          end 
      end  

      fab_ism = fab_ism.first();
      do begin
         if ($value$plusargs($psprintf("HQM_IOSF_PRIM_%0s_MAXISMDLY=%0s", fab_ism.name(), "%0d"), iosf_pvc_cfg.maxISMDelay[fab_ism])) begin
             `uvm_info(get_full_name(), $psprintf("maxISMDelay[%0s]=%0d", fab_ism.name(), iosf_pvc_cfg.maxISMDelay[fab_ism]), UVM_MEDIUM)
         end 
         fab_ism = fab_ism.next(); 
      end while (fab_ism != fab_ism.last());
      `uvm_info(get_full_name(), $psprintf("set_fab_ism_rand_delay -- End"),   UVM_HIGH)

  endfunction : set_fab_ism_rand_delay
   
  virtual function void program_hqm_local_iosf_cfg(); 
      if ($test$plusargs("HQM_IOSF_PRIM_FBRC_EN_RANDIDLENAK"))begin
         iosf_pvc_cfg.randIdleNak = 1;
      end 

      if ($test$plusargs("HQM_IOSF_PRIM_FBRC_DIS_RANDISMDELAY"))begin
         iosf_pvc_cfg.randISMDelay = 0;
      end 
      if (($test$plusargs("HQM_EN_PRIM_ISM_DLY_TASK")) && !($test$plusargs("HQM_DIS_PRIM_ISM_DLY_OVERRIDE"))) begin 
          set_fab_ism_rand_delay();
      end     

      if($test$plusargs("DATA_PARITY_CHECK")) begin 
        iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_286");
        iosf_pagt_dut_cfg.setAssertionDisable ("PRI_286");
        iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_286");
        iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_286");
      end 
   
      if($test$plusargs("HQM_COMMAND_PARITY_CHECK")) begin 
        iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_075");
        iosf_pagt_dut_cfg.setAssertionDisable ("PRI_075");
        iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_075");
        iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_075");
      end 
   
      if($test$plusargs("CONFIG_LENGTH_CHECK")) begin 
        iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_025");
        iosf_pagt_dut_cfg.setAssertionDisable ("PRI_025");
        iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_025");
        iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_025");
      end 
   
      if($test$plusargs("BAD_IMPS_CHECK")) begin 
        iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_078");
        iosf_pagt_dut_cfg.setAssertionDisable ("PRI_078");
        iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_078");
        iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_078");
      end 
   
      if($test$plusargs("BAD_IMPS_CHECK1")) begin 
        iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_226");
        iosf_pagt_dut_cfg.setAssertionDisable ("PRI_226");
        iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_226");
        iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_226");
      end 
   
      if($test$plusargs("BAD_LBE_CHECK")) begin 
        iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_201");
        iosf_pagt_dut_cfg.setAssertionDisable ("PRI_201");
        iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_201");
        iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_201");
      end 
   
      if($test$plusargs("LOCK")) begin 
        iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_040");
        iosf_pagt_dut_cfg.setAssertionDisable ("PRI_040");
        iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_040");
        iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_040");
      end 
   
      
      if($test$plusargs("SPURIOUS_COMPLETION")) begin 
        iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_199");
        iosf_pagt_dut_cfg.setAssertionDisable ("PRI_199");
        iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_199");
        iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_199");
      end 
   
      if($test$plusargs("ATOMIC_ERROR")) begin 
        iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_141");
        iosf_pagt_dut_cfg.setAssertionDisable ("PRI_141");
        iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_141");
        iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_141");
      end 
   
      if($test$plusargs("MATCH_REQUEST_BC")) begin 
        iosf_pagt_upnode_cfg.setAssertionDisable ("MatchRe-questBC");
        iosf_pagt_dut_cfg.setAssertionDisable ("MatchRe-questBC");
        iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("MatchRe-questBC");
        iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("MatchRe-questBC");
        iosf_pagt_upnode_cfg.setAssertionDisable ("MatchRequestBC");
        iosf_pagt_dut_cfg.setAssertionDisable ("MatchRequestBC");
        iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("MatchRequestBC");
        iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("MatchRequestBC");
      end 
        
      if($test$plusargs("DISABLE_DATAX_CHECK")) begin 
        iosf_pvc_cfg.iosfAgtCfg[0].Disable_DataX_Check=1;
        iosf_pvc_cfg.iosfAgtCfg[1].Disable_DataX_Check=1;
      end 
    endfunction : program_hqm_local_iosf_cfg

endclass:HqmIpCfgProg 

`endif
