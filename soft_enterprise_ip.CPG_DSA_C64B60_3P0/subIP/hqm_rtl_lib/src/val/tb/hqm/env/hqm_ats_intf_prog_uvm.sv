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
// File   : hqm_ats_intf_prog.sv
// Author : 
//
// Description :
// Package: hqm_ats_intf program file
//
// -----------------------------------------------------------------------------
`ifndef INTFCFGBASE
`define INTFCFGBASE uvm_object 
`endif

class hqm_ats_intf_prog extends `INTFCFGBASE implements hqm_ats_intf;
  `uvm_object_utils(hqm_ats_intf_prog)
  

  function new (string name = "");
    super.new(name); 
  endfunction


  //---
  virtual function string get_agent_name();
    string      agent_name;

    if(!$value$plusargs("HQM_ATS_AGENT_NAME=%s", agent_name)) agent_name = "s0.f0.iosfp0.to_socket";
    `uvm_info("hqm_ats_intf", $sformatf("HQM::agent_name is %0s",agent_name), UVM_LOW)
    return agent_name;
  endfunction

  //---
  //---
  virtual function val_t get_interface_bus();
    val_t interface_bus;

    interface_bus = 0; //0: IOSF; 1: iCXL
    `uvm_info("hqm_ats_intf", $sformatf("HQM::interface_bus is %0d",interface_bus), UVM_LOW)
    return interface_bus;
  endfunction

  //---
  virtual function val_t get_active();
    val_t set_val;

    set_val = 1; 
    `uvm_info("hqm_ats_intf", $sformatf("HQM::active is %0d",set_val), UVM_LOW)
    return set_val;
  endfunction
  
  //---
  virtual function val_t get_iommubdf();
    val_t set_val;

    set_val = 'hCAFE; 
    `uvm_info("hqm_ats_intf", $sformatf("HQM::iommu_bdf is 0x%0x",set_val), UVM_LOW)
    return set_val;
  endfunction

  //---
  virtual function val_t get_dis_tracker();
    val_t set_val;

    set_val = 0; 
    `uvm_info("hqm_ats_intf", $sformatf("HQM::disable_tracker is %0d",set_val), UVM_LOW)
    return set_val;
  endfunction

  //---
  virtual function val_t get_dis_checker();
    val_t set_val;

    set_val = 0; 
    `uvm_info("hqm_ats_intf", $sformatf("HQM::disable_checker is %0d",set_val), UVM_LOW)
    return set_val;
  endfunction

  //--- disable_legal_ats_check = 1;    // Disable the ATS check checking for all legal ATS reqs to be seen.
  virtual function val_t get_dis_ats_check();
    val_t set_val;

    set_val = 1; 
    `uvm_info("hqm_ats_intf", $sformatf("HQM::disable_legal_ats_check is %0d",set_val), UVM_LOW)
    return set_val;
  endfunction

  //---
  virtual function val_t get_dis_invats_check();
    val_t set_val;

    set_val = 0; 
    `uvm_info("hqm_ats_intf", $sformatf("HQM::disable_ats_inv_check is %0d",set_val), UVM_LOW)
    return set_val;
  endfunction

  //---
  virtual function val_t get_disable_tb_report_severity();
    val_t set_val;

    set_val = 0; 
    `uvm_info("hqm_ats_intf", $sformatf("HQM::set_disable_tb_report_severity_settings is %0d",set_val), UVM_LOW)
    return set_val;
  endfunction



endclass
