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
// File   : hqm_iosf_intf_prog.sv
// Author : 
//
// Description :
// Package: hqm_iosf_intf program file
// iosf prim agt interface types and abstract interface.
//
// -----------------------------------------------------------------------------
`ifndef INTFCFGBASE
`define INTFCFGBASE uvm_object 
`endif

class hqm_iosf_intf_prog extends `INTFCFGBASE implements hqm_iosf_intf;
  `uvm_object_utils(hqm_iosf_intf_prog)
  

  function new (string name = "");
    super.new(name); 
  endfunction

  //---
  virtual function  hqm_iosf_pvc_cfg_t get_hqm_iosf_pvc_cfg();
    hqm_iosf_pvc_cfg_t hqm_iosf_pvc_cfg_val;

    hqm_iosf_pvc_cfg_val.intfName = "hqm_tb_top.hqm_test_island.hqm_global_ti.iosf_fabric_VC";
    hqm_iosf_pvc_cfg_val.outoforder_compl = ($test$plusargs("HQM_PVC_OOO_COMPL"));
    hqm_iosf_pvc_cfg_val.ten_bit_tag_en   = ~($test$plusargs("HQM_TEN_BIT_TAG_DISABLE"));
    hqm_iosf_pvc_cfg_val.auto_tag_gen_dis = ($test$plusargs("HQM_PVC_AUTO_TAG_GEN_DIS"));

    `uvm_info("hqm_iosf_intf", $sformatf("HQM::hqm_iosf_intf.intfName is %s",hqm_iosf_pvc_cfg_val.intfName), UVM_LOW)
    `uvm_info("hqm_iosf_intf", $sformatf("HQM::hqm_iosf_intf.outoforder_compl %0d",hqm_iosf_pvc_cfg_val.outoforder_compl), UVM_LOW)
    `uvm_info("hqm_iosf_intf", $sformatf("HQM::hqm_iosf_intf.ten_bit_tag_en   %0d",  hqm_iosf_pvc_cfg_val.ten_bit_tag_en), UVM_LOW)
    `uvm_info("hqm_iosf_intf", $sformatf("HQM::hqm_iosf_intf.auto_tag_gen_dis %0d",hqm_iosf_pvc_cfg_val.auto_tag_gen_dis), UVM_LOW)

    return hqm_iosf_pvc_cfg_val;
  endfunction

endclass
