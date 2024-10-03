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
// File   : hqm_base_intf_prog.sv
// Author : 
//
// Description :
// Package: hqm_base_intf program file
// rootbus/secbus/subordbus and hi/low base/limit interface types and abstract interface.
//
// -----------------------------------------------------------------------------
`ifndef INTFCFGBASE
`define INTFCFGBASE uvm_object 
`endif

class hqm_base_intf_prog extends `INTFCFGBASE implements hqm_base_intf;
  `uvm_object_utils(hqm_base_intf_prog)
  

  function new (string name = "");
    super.new(name); 
  endfunction

  virtual function string get_inst_suffix_val();
    string      inst_suffix;

    inst_suffix = "hqm"; 
    `uvm_info("hqm_base_intf", $sformatf("HQM::inst_suffix is %0s",inst_suffix), UVM_LOW)
    return inst_suffix;
  endfunction

  //---
  virtual function instid_t get_instid_val();
    instid_t instid;

    instid = 0; 
    `uvm_info("hqm_base_intf", $sformatf("HQM::instid is %0d",instid), UVM_LOW)
    return instid;
  endfunction

  //---
  virtual function rootbus_t get_rootbus_val();
    rootbus_t rootbus;

    rootbus = 0; 
    `uvm_info("hqm_base_intf", $sformatf("HQM::rootbus is %0d",rootbus), UVM_LOW)
    return rootbus;
  endfunction

  //---
  virtual function secbus_t get_secbus_val();
    secbus_t secbus;

    secbus = 1; 
    `uvm_info("hqm_base_intf", $sformatf("HQM::secbus is %0d",secbus), UVM_LOW)
    return secbus;
  endfunction
  
  //---
  virtual function subordbus_t get_subordbus_val();
    subordbus_t subordbus;

    subordbus = 1; 
    `uvm_info("hqm_base_intf", $sformatf("HQM::subordbus is %0d",subordbus), UVM_LOW)
    return subordbus;
  endfunction

  //---
  virtual function hqm_busnum_ctrl_t get_busnumctrl_val();
    hqm_busnum_ctrl_t has_busnum_ctrl;

    has_busnum_ctrl = 1; 
    `uvm_info("hqm_base_intf", $sformatf("HQM::get_busnumctrl_val has_busnum_ctrl is %0d",has_busnum_ctrl), UVM_LOW)
    return has_busnum_ctrl;
  endfunction

  virtual function hqm_busnum_ctrl_t get_ralbdfctrl_val();
    hqm_busnum_ctrl_t has_ralbdf_ctrl;

    has_ralbdf_ctrl = 1; 
    `uvm_info("hqm_base_intf", $sformatf("HQM::get_ralbdfctrl_val has_ralbdf_ctrl is %0d",has_ralbdf_ctrl), UVM_LOW)
    return has_ralbdf_ctrl;
  endfunction

  virtual function hqm_busnum_ctrl_t get_raloverridectrl_val();
    hqm_busnum_ctrl_t has_raloverride_ctrl;

    has_raloverride_ctrl = 7; 
    `uvm_info("hqm_base_intf", $sformatf("HQM::get_raloverridectrl_val has_raloverride_ctrl is %0d",has_raloverride_ctrl), UVM_LOW)
    return has_raloverride_ctrl;
  endfunction

  //---
  virtual function hqm_busnum_ctrl_t get_bdf_val();
    hqm_busnum_ctrl_t has_bdf_val;

    has_bdf_val = 16'h0100; 
    `uvm_info("hqm_base_intf", $sformatf("HQM::get_bdf_val has_bdf_val is 0x%0x",has_bdf_val), UVM_LOW)
    return has_bdf_val;
  endfunction

  //---
   virtual function string get_register_access_type();
    string      access_type;

    access_type = "backdoor"; //iosf_pri; sideband; 
    `uvm_info("hqm_base_intf", $sformatf("HQM::get_register_access_type access_type is %0s",access_type), UVM_LOW)
    return access_type;
  endfunction

  //--- FUNC PF
  virtual function  hqm_addrmap_t get_hqm_addrmap_func_pf_val();
     hqm_addrmap_t hqm_addrmap_val;

     hqm_addrmap_val.addr_hi = 64'h0000_0014_8bff_ffff;
     hqm_addrmap_val.addr_lo = 64'h0000_0014_8800_0000;

     `uvm_info("hqm_base_intf", $sformatf("HQM::FUNC PF Addr set addr_lo: %h ", hqm_addrmap_val.addr_lo), UVM_LOW)
     `uvm_info("hqm_base_intf", $sformatf("HQM::FUNC PF Addr set addr_hi: %h ", hqm_addrmap_val.addr_hi), UVM_LOW)

     return hqm_addrmap_val;
  endfunction

  //--- FUNC VF
  virtual function  hqm_addrmap_t get_hqm_addrmap_func_vf_val();
     hqm_addrmap_t hqm_addrmap_val;

     hqm_addrmap_val.addr_hi = 64'h0000_0014_ffff_ffff;
     hqm_addrmap_val.addr_lo = 64'h0000_0014_c000_0000;

     `uvm_info("hqm_base_intf", $sformatf("HQM::FUNC VF Addr set addr_lo: %h ", hqm_addrmap_val.addr_lo), UVM_LOW)
     `uvm_info("hqm_base_intf", $sformatf("HQM::FUNC VF Addr set addr_hi: %h ", hqm_addrmap_val.addr_hi), UVM_LOW)
     
     return hqm_addrmap_val;
  endfunction

  //--- CSR
  virtual function  hqm_addrmap_t get_hqm_addrmap_csr_pf_val();
     hqm_addrmap_t hqm_addrmap_val;

     hqm_addrmap_val.addr_hi = 64'h0000_0015_ffff_ffff;
     hqm_addrmap_val.addr_lo = 64'h0000_0015_0000_0000;

     `uvm_info("hqm_base_intf", $sformatf("HQM::CSR Addr set addr_lo: %h ", hqm_addrmap_val.addr_lo), UVM_LOW)
     `uvm_info("hqm_base_intf", $sformatf("HQM::CSR Addr set addr_hi: %h ", hqm_addrmap_val.addr_hi), UVM_LOW)
     
     return hqm_addrmap_val;
  endfunction

  //---
  virtual function  hqm_addrmap_t get_hqm_addrmap_dram_val();
     hqm_addrmap_t hqm_addrmap_val;

     hqm_addrmap_val.addr_hi = 64'h0000_0010_bfff_ffff;
     hqm_addrmap_val.addr_lo = 64'h0000_0001_0000_0000;

     `uvm_info("hqm_base_intf", $sformatf("HQM::DRAM Addr set addr_lo: %h ", hqm_addrmap_val.addr_lo), UVM_LOW)
     `uvm_info("hqm_base_intf", $sformatf("HQM::DRAM Addr set addr_hi: %h ", hqm_addrmap_val.addr_hi), UVM_LOW)
     
     return hqm_addrmap_val;
  endfunction

endclass
