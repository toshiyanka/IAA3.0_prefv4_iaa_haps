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
// Description:
//  This sequence uses the pcie_sweep_sequence from control config domain to check pcie header registers.
//-----------------------------------------------------------------------------------------------------

`ifndef HQM_PCIE_HEADER_SWEEP_SEQ__SV
`define HQM_PCIE_HEADER_SWEEP_SEQ__SV

import control_config_domain_sequences_pkg::*;
 
class policy_ctrl_pcie_cfg_space_check_per_func_seq extends stim_policy_pkg::policy_base#(pcie_cfg_space_check_per_func_seq);
      `ovm_object_utils(policy_ctrl_pcie_cfg_space_check_per_func_seq)
      function new(string name = "policy");
         super.new(name);
         
      endfunction : new


   constraint c_ctrl {

	(it.func==0) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==1) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==2) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==3) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==4) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==5) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==6) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==7) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==8) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==9) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==10) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==11) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==12) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==13) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==14) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==15) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
	(it.func==16) -> (it.cfg.unimplemented_optional_action_for_offset_100h_extended_capability	==ERROR_UNIMPLEMENTED_OPTIONAL_REG);
        
   };

endclass 

//-------------------------------------------------------------------------------------------------------
//-- PCIe header sweep sequence
//-------------------------------------------------------------------------------------------------------
//class hqm_pcie_header_sweep_seq extends ovm_sequence;
class hqm_pcie_header_sweep_seq extends hqm_sla_pcie_base_seq;
	`ovm_sequence_utils(hqm_pcie_header_sweep_seq, sla_sequencer)

    	
	function new(string name="hqm_pcie_header_sweep_seq");
		super.new(name);
	endfunction : new

    task body();
	    pcie_sweep_sequence pcie_sweep_seq;
      policy_ctrl_pcie_cfg_space_check_per_func_seq  policy_ctrl_func= policy_ctrl_pcie_cfg_space_check_per_func_seq::type_id::create("policy_ctrl_func");
 
        `ovm_info(get_name(), "TEST START", OVM_LOW)

        pcie_sweep_seq = pcie_sweep_sequence::type_id::create("pcie_sweep_seq");
	
        //pcie_sweep_seq.policy_list.add(policy_ctrl_func);

        `ovm_rand_send(pcie_sweep_seq)

        `ovm_info(get_name(), "TEST END", OVM_LOW)
   endtask : body
	
endclass : hqm_pcie_header_sweep_seq

`endif //HQM_PCIE_HEADER_SWEEP_SEQ__SV
