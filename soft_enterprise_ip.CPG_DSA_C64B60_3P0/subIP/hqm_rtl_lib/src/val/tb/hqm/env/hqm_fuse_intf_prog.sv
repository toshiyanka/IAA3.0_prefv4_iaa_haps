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
// File   : hqm_fuse_intf_prog.sv
// Author : 
//
// Description :
// Package: hqm_fuse_intf program file
// fuse interface types and abstract interface.
//
// -----------------------------------------------------------------------------
`ifndef INTFCFGBASE
`define INTFCFGBASE ovm_object 
`endif

class hqm_fuse_intf_prog extends `INTFCFGBASE implements hqm_fuse_intf;
  `ovm_object_utils(hqm_fuse_intf_prog)
  

  function new (string name = "");
    super.new(name); 
  endfunction


  //---
  virtual function  hqm_fuse_cfg_t get_hqm_fuse_cfg();
    hqm_fuse_cfg_t hqm_fuse_cfg_val;

    hqm_fuse_cfg_val.hqm_fuse_group = "hqm"; 

    `ovm_info("hqm_fuse_intf", $sformatf("HQM::hqm_fuse_intf.hqm_fuse_group is %0s",hqm_fuse_cfg_val.hqm_fuse_group), OVM_LOW)

    return hqm_fuse_cfg_val;
  endfunction


endclass
