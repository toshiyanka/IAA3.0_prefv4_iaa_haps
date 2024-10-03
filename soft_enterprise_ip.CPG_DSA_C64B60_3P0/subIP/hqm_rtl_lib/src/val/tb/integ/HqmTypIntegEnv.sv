//-----------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
// File   : HqmTypIntegEnv.sv
// Author : Carl Angstadt
//
// Description :
//
//   Typ IntegEnv for the HQM Agent
//------------------------------------------------------------------------------

import hqm_tb_cfg_pkg::*;
import hcw_transaction_pkg::*;
import hcw_pkg::*;
import HqmAtsPkg::*;
import hqm_cfg_pkg::*;

`include "sla_macros.svh"


class HqmTypIntegEnv extends HqmMidIntegEnv;
  `ovm_component_utils(HqmTypIntegEnv)

  function new(string name = "HqmTypIntegEnv", ovm_component parent = null);
    super.new(name, parent);
  endfunction: new

  virtual function void build();
    super.build(); 
  endfunction : build

endclass: HqmTypIntegEnv
