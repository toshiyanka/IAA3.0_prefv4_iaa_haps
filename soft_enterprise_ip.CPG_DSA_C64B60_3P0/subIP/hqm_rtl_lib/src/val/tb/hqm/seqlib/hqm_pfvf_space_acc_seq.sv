// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2018) (2018) Intel Corporation All Rights Reserved. 
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
// File   : hqm_pfvf_space_acc_seq.sv
//
// Description :
//
//
//Test_Step_1:: Program PF hqm_func_pf_to_vf[16] mailbox regs and hqm_msix_mem regisers (cft file)
//           :: Program VF hqm_func_vf_bar[16] for those non-shadow registers
//
//Test_Step_2:: VF_Write -- Write to ununimplemented space in VF BAR[16]  with unique data pattern  
//
//Test_Step_3:: PF_Write -- Write to ununimplemented space in PF func bar space
//
//Test_Step_4:: PF_CSR_Write -- Write to ununimplemented space in PF CSR space
//
//Test_Step_5:: VF_Read  -- Read from VF BAR[16] unimplemented space : readout zero
//
//Test_Step_6:: PF_Read  -- Read from ununimplemented space in PF func bar space: readout zero 
//
//Test_Step_7:: PF_CSR_Read  -- Read from ununimplemented space in PF CSR space: readout zero 
//
//Test_Step_8:: Read register from PF.hqm_func_pf_per_vf[16] and hqm_msix_mem[65] to get expected data (#1)
//              Read register from VF.hqm_func_vf_bar[16] to get expected data (#1)
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_pfvf_space_acc_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pfvf_space_acc_seq_stim_config";

  `ovm_object_utils_begin(hqm_pfvf_space_acc_seq_stim_config)
    `ovm_field_string(tb_env_hier,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg1,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg2,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg3,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(ral_file_name,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(has_csr_attr,                OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(has_csr_addr,                OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(has_pf_addr,                 OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(has_vf_addr,                 OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(has_pf_hcw_wr,               OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_csr_addr,                OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_rand_addr,               OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_pick_addr,               OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_unimp_addr,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_addr_incr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_addr_incr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)

    `ovm_field_int(unimp_vf0_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf1_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf2_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf3_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf4_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf5_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf6_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf7_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf8_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf9_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf10_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf11_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf12_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf13_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf14_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf15_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf0_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf1_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf2_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf3_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf4_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf5_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf6_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf7_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf8_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf9_wdata,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf10_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf11_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf12_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf13_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf14_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf15_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr0_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr1_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr2_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr3_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr4_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr5_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr6_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr7_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr8_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr9_wdata,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr10_wdata,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr0_enable,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr1_enable,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr2_enable,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr3_enable,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr4_enable,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr5_enable,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr6_enable,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr7_enable,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr8_enable,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr9_enable,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr10_enable,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf_skip_addroff0,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf_skip_addroff1,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_skip_addroff0,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_skip_addroff1,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pick_addroff0_min,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pick_addroff0_max,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pick_addroff1_min,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pick_addroff1_max,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pick_addroff2_min,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pick_addroff2_max,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pick_addroff3_min,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pick_addroff3_max,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf0_addr_l_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf1_addr_l_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf2_addr_l_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf3_addr_l_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf4_addr_l_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf5_addr_l_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf6_addr_l_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf7_addr_l_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf8_addr_l_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf9_addr_l_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf10_addr_l_min,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf11_addr_l_min,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf12_addr_l_min,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf13_addr_l_min,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf14_addr_l_min,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf15_addr_l_min,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf0_addr_l_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf1_addr_l_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf2_addr_l_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf3_addr_l_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf4_addr_l_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf5_addr_l_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf6_addr_l_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf7_addr_l_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf8_addr_l_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf9_addr_l_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf10_addr_l_max,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf11_addr_l_max,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf12_addr_l_max,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf13_addr_l_max,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf14_addr_l_max,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf15_addr_l_max,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf0_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf1_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf2_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf3_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf4_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf5_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf6_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf7_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf8_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf9_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf10_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf11_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf12_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf13_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf14_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf15_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf0_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf1_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf2_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf3_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf4_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf5_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf6_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf7_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf8_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf9_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf10_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf11_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf12_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf13_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf14_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf15_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf0_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf1_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf2_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf3_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf4_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf5_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf6_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf7_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf8_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf9_addr_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf10_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf11_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf12_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf13_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf14_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf15_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf0_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf1_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf2_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf3_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf4_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf5_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf6_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf7_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf8_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf9_addr_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf10_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf11_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf12_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf13_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf14_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf15_addr_max,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr0_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr1_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr2_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr3_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr4_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr5_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr6_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr7_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr8_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr9_addr_min,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_csr10_addr_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)

    `ovm_field_int(unimp_pf_gap0_addr_min,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_gap0_addr_max,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_gap1_addr_min,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_gap1_addr_max,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_gap2_addr_min,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_gap2_addr_max,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_gap3_addr_min,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_gap3_addr_max,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)

    `ovm_field_int(unimp_addr_wt_step,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf_addr_stoffset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)

    `ovm_field_int(unimp_vf0_addr_stoffset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf1_addr_stoffset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf2_addr_stoffset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf3_addr_stoffset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf4_addr_stoffset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf5_addr_stoffset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf6_addr_stoffset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf7_addr_stoffset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf8_addr_stoffset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf9_addr_stoffset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf10_addr_stoffset,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf11_addr_stoffset,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf12_addr_stoffset,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf13_addr_stoffset,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf14_addr_stoffset,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_vf15_addr_stoffset,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)

    `ovm_field_int(unimp_pf_gap_addr_stoffset,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)

    `ovm_field_int(unimp_pf_gap0_addr_stoffset,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_gap1_addr_stoffset,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_gap2_addr_stoffset,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(unimp_pf_gap3_addr_stoffset,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)

    `ovm_field_int(unimp_csr_gap_addr_stoffset,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)

    `ovm_field_int(hcw_space0_addr_min,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(hcw_space0_addr_max,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(hcw_space1_addr_min,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(hcw_space1_addr_max,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pfvf_space_acc_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(file_mode_plusarg1)
    `stimulus_config_field_string(file_mode_plusarg2)
    `stimulus_config_field_string(file_mode_plusarg3)
    `stimulus_config_field_string(ral_file_name)
    `stimulus_config_field_rand_int(has_csr_attr)
    `stimulus_config_field_rand_int(has_csr_addr)
    `stimulus_config_field_rand_int(has_pf_addr)
    `stimulus_config_field_rand_int(has_vf_addr)
    `stimulus_config_field_rand_int(has_pf_hcw_wr)
    `stimulus_config_field_rand_int(num_csr_addr)
    `stimulus_config_field_rand_int(num_rand_addr)
    `stimulus_config_field_rand_int(num_pick_addr)
    `stimulus_config_field_rand_int(num_unimp_addr)
    `stimulus_config_field_rand_int(unimp_addr_incr_min)
    `stimulus_config_field_rand_int(unimp_addr_incr_max)
    `stimulus_config_field_rand_int(unimp_vf_skip_addroff0)
    `stimulus_config_field_rand_int(unimp_vf_skip_addroff1)
    `stimulus_config_field_rand_int(unimp_pf_skip_addroff0)
    `stimulus_config_field_rand_int(unimp_pf_skip_addroff1)
    `stimulus_config_field_rand_int(unimp_pick_addroff0_min)
    `stimulus_config_field_rand_int(unimp_pick_addroff0_max)
    `stimulus_config_field_rand_int(unimp_pick_addroff1_min)
    `stimulus_config_field_rand_int(unimp_pick_addroff1_max)
    `stimulus_config_field_rand_int(unimp_pick_addroff2_min)
    `stimulus_config_field_rand_int(unimp_pick_addroff2_max)
    `stimulus_config_field_rand_int(unimp_pick_addroff3_min)
    `stimulus_config_field_rand_int(unimp_pick_addroff3_max)
    `stimulus_config_field_rand_int(unimp_vf0_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf1_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf2_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf3_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf4_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf5_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf6_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf7_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf8_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf9_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf10_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf11_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf12_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf13_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf14_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf15_addr_l_min)
    `stimulus_config_field_rand_int(unimp_vf0_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf1_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf2_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf3_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf4_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf5_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf6_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf7_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf8_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf9_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf10_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf11_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf12_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf13_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf14_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf15_addr_l_max)
    `stimulus_config_field_rand_int(unimp_vf0_addr_min)
    `stimulus_config_field_rand_int(unimp_vf1_addr_min)
    `stimulus_config_field_rand_int(unimp_vf2_addr_min)
    `stimulus_config_field_rand_int(unimp_vf3_addr_min)
    `stimulus_config_field_rand_int(unimp_vf4_addr_min)
    `stimulus_config_field_rand_int(unimp_vf5_addr_min)
    `stimulus_config_field_rand_int(unimp_vf6_addr_min)
    `stimulus_config_field_rand_int(unimp_vf7_addr_min)
    `stimulus_config_field_rand_int(unimp_vf8_addr_min)
    `stimulus_config_field_rand_int(unimp_vf9_addr_min)
    `stimulus_config_field_rand_int(unimp_vf10_addr_min)
    `stimulus_config_field_rand_int(unimp_vf11_addr_min)
    `stimulus_config_field_rand_int(unimp_vf12_addr_min)
    `stimulus_config_field_rand_int(unimp_vf13_addr_min)
    `stimulus_config_field_rand_int(unimp_vf14_addr_min)
    `stimulus_config_field_rand_int(unimp_vf15_addr_min)
    `stimulus_config_field_rand_int(unimp_vf0_addr_max)
    `stimulus_config_field_rand_int(unimp_vf1_addr_max)
    `stimulus_config_field_rand_int(unimp_vf2_addr_max)
    `stimulus_config_field_rand_int(unimp_vf3_addr_max)
    `stimulus_config_field_rand_int(unimp_vf4_addr_max)
    `stimulus_config_field_rand_int(unimp_vf5_addr_max)
    `stimulus_config_field_rand_int(unimp_vf6_addr_max)
    `stimulus_config_field_rand_int(unimp_vf7_addr_max)
    `stimulus_config_field_rand_int(unimp_vf8_addr_max)
    `stimulus_config_field_rand_int(unimp_vf9_addr_max)
    `stimulus_config_field_rand_int(unimp_vf10_addr_max)
    `stimulus_config_field_rand_int(unimp_vf11_addr_max)
    `stimulus_config_field_rand_int(unimp_vf12_addr_max)
    `stimulus_config_field_rand_int(unimp_vf13_addr_max)
    `stimulus_config_field_rand_int(unimp_vf14_addr_max)
    `stimulus_config_field_rand_int(unimp_vf15_addr_max)
    `stimulus_config_field_rand_int(unimp_pf0_addr_min)
    `stimulus_config_field_rand_int(unimp_pf1_addr_min)
    `stimulus_config_field_rand_int(unimp_pf2_addr_min)
    `stimulus_config_field_rand_int(unimp_pf3_addr_min)
    `stimulus_config_field_rand_int(unimp_pf4_addr_min)
    `stimulus_config_field_rand_int(unimp_pf5_addr_min)
    `stimulus_config_field_rand_int(unimp_pf6_addr_min)
    `stimulus_config_field_rand_int(unimp_pf7_addr_min)
    `stimulus_config_field_rand_int(unimp_pf8_addr_min)
    `stimulus_config_field_rand_int(unimp_pf9_addr_min)
    `stimulus_config_field_rand_int(unimp_pf10_addr_min)
    `stimulus_config_field_rand_int(unimp_pf11_addr_min)
    `stimulus_config_field_rand_int(unimp_pf12_addr_min)
    `stimulus_config_field_rand_int(unimp_pf13_addr_min)
    `stimulus_config_field_rand_int(unimp_pf14_addr_min)
    `stimulus_config_field_rand_int(unimp_pf15_addr_min)
    `stimulus_config_field_rand_int(unimp_pf0_addr_max)
    `stimulus_config_field_rand_int(unimp_pf1_addr_max)
    `stimulus_config_field_rand_int(unimp_pf2_addr_max)
    `stimulus_config_field_rand_int(unimp_pf3_addr_max)
    `stimulus_config_field_rand_int(unimp_pf4_addr_max)
    `stimulus_config_field_rand_int(unimp_pf5_addr_max)
    `stimulus_config_field_rand_int(unimp_pf6_addr_max)
    `stimulus_config_field_rand_int(unimp_pf7_addr_max)
    `stimulus_config_field_rand_int(unimp_pf8_addr_max)
    `stimulus_config_field_rand_int(unimp_pf9_addr_max)
    `stimulus_config_field_rand_int(unimp_pf10_addr_max)
    `stimulus_config_field_rand_int(unimp_pf11_addr_max)
    `stimulus_config_field_rand_int(unimp_pf12_addr_max)
    `stimulus_config_field_rand_int(unimp_pf13_addr_max)
    `stimulus_config_field_rand_int(unimp_pf14_addr_max)
    `stimulus_config_field_rand_int(unimp_pf15_addr_max)    
    `stimulus_config_field_rand_int(unimp_csr0_addr_min)
    `stimulus_config_field_rand_int(unimp_csr1_addr_min)
    `stimulus_config_field_rand_int(unimp_csr2_addr_min)
    `stimulus_config_field_rand_int(unimp_csr3_addr_min)
    `stimulus_config_field_rand_int(unimp_csr4_addr_min)
    `stimulus_config_field_rand_int(unimp_csr5_addr_min)
    `stimulus_config_field_rand_int(unimp_csr6_addr_min)
    `stimulus_config_field_rand_int(unimp_csr7_addr_min)
    `stimulus_config_field_rand_int(unimp_csr8_addr_min)
    `stimulus_config_field_rand_int(unimp_csr9_addr_min)
    `stimulus_config_field_rand_int(unimp_csr10_addr_min)
    `stimulus_config_field_rand_int(unimp_pf_gap0_addr_min)  
    `stimulus_config_field_rand_int(unimp_pf_gap0_addr_max)   
    `stimulus_config_field_rand_int(unimp_pf_gap1_addr_min)  
    `stimulus_config_field_rand_int(unimp_pf_gap1_addr_max)
    `stimulus_config_field_rand_int(unimp_pf_gap2_addr_min)  
    `stimulus_config_field_rand_int(unimp_pf_gap2_addr_max)
    `stimulus_config_field_rand_int(unimp_pf_gap3_addr_min)  
    `stimulus_config_field_rand_int(unimp_pf_gap3_addr_max)             
    `stimulus_config_field_rand_int(unimp_addr_wt_step)             
    `stimulus_config_field_rand_int(unimp_vf_addr_stoffset)             
    `stimulus_config_field_rand_int(unimp_vf0_addr_stoffset)             
    `stimulus_config_field_rand_int(unimp_vf1_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf2_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf3_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf4_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf5_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf6_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf7_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf8_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf9_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf10_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf11_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf12_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf13_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf14_addr_stoffset)
    `stimulus_config_field_rand_int(unimp_vf15_addr_stoffset)  
    `stimulus_config_field_rand_int(unimp_csr_gap_addr_stoffset)  
    `stimulus_config_field_rand_int(unimp_pf_gap_addr_stoffset)  
    `stimulus_config_field_rand_int(unimp_pf_gap0_addr_stoffset)  
    `stimulus_config_field_rand_int(unimp_pf_gap1_addr_stoffset)  
    `stimulus_config_field_rand_int(unimp_pf_gap2_addr_stoffset)  
    `stimulus_config_field_rand_int(unimp_pf_gap3_addr_stoffset)  
    `stimulus_config_field_rand_int(hcw_space0_addr_min)  
    `stimulus_config_field_rand_int(hcw_space0_addr_max)   
    `stimulus_config_field_rand_int(hcw_space1_addr_min)  
    `stimulus_config_field_rand_int(hcw_space1_addr_max)
    `stimulus_config_field_rand_int(unimp_vf0_wdata)
    `stimulus_config_field_rand_int(unimp_vf1_wdata)
    `stimulus_config_field_rand_int(unimp_vf2_wdata)
    `stimulus_config_field_rand_int(unimp_vf3_wdata)
    `stimulus_config_field_rand_int(unimp_vf4_wdata)
    `stimulus_config_field_rand_int(unimp_vf5_wdata)
    `stimulus_config_field_rand_int(unimp_vf6_wdata)
    `stimulus_config_field_rand_int(unimp_vf7_wdata)
    `stimulus_config_field_rand_int(unimp_vf8_wdata)
    `stimulus_config_field_rand_int(unimp_vf9_wdata)
    `stimulus_config_field_rand_int(unimp_vf10_wdata)
    `stimulus_config_field_rand_int(unimp_vf11_wdata)
    `stimulus_config_field_rand_int(unimp_vf12_wdata)
    `stimulus_config_field_rand_int(unimp_vf13_wdata)
    `stimulus_config_field_rand_int(unimp_vf14_wdata)
    `stimulus_config_field_rand_int(unimp_vf15_wdata)
    `stimulus_config_field_rand_int(unimp_pf0_wdata)
    `stimulus_config_field_rand_int(unimp_pf1_wdata)
    `stimulus_config_field_rand_int(unimp_pf2_wdata)
    `stimulus_config_field_rand_int(unimp_pf3_wdata)
    `stimulus_config_field_rand_int(unimp_pf4_wdata)
    `stimulus_config_field_rand_int(unimp_pf5_wdata)
    `stimulus_config_field_rand_int(unimp_pf6_wdata)
    `stimulus_config_field_rand_int(unimp_pf7_wdata)
    `stimulus_config_field_rand_int(unimp_pf8_wdata)
    `stimulus_config_field_rand_int(unimp_pf9_wdata)
    `stimulus_config_field_rand_int(unimp_pf10_wdata)
    `stimulus_config_field_rand_int(unimp_pf11_wdata)
    `stimulus_config_field_rand_int(unimp_pf12_wdata)
    `stimulus_config_field_rand_int(unimp_pf13_wdata)
    `stimulus_config_field_rand_int(unimp_pf14_wdata)
    `stimulus_config_field_rand_int(unimp_pf15_wdata)
    `stimulus_config_field_rand_int(unimp_csr0_wdata)
    `stimulus_config_field_rand_int(unimp_csr1_wdata)
    `stimulus_config_field_rand_int(unimp_csr2_wdata)
    `stimulus_config_field_rand_int(unimp_csr3_wdata)
    `stimulus_config_field_rand_int(unimp_csr4_wdata)
    `stimulus_config_field_rand_int(unimp_csr5_wdata)
    `stimulus_config_field_rand_int(unimp_csr6_wdata)
    `stimulus_config_field_rand_int(unimp_csr7_wdata)
    `stimulus_config_field_rand_int(unimp_csr8_wdata)
    `stimulus_config_field_rand_int(unimp_csr9_wdata)
    `stimulus_config_field_rand_int(unimp_csr10_wdata)
    `stimulus_config_field_rand_int(unimp_csr0_enable)
    `stimulus_config_field_rand_int(unimp_csr1_enable)
    `stimulus_config_field_rand_int(unimp_csr2_enable)
    `stimulus_config_field_rand_int(unimp_csr3_enable)
    `stimulus_config_field_rand_int(unimp_csr4_enable)
    `stimulus_config_field_rand_int(unimp_csr5_enable)
    `stimulus_config_field_rand_int(unimp_csr6_enable)
    `stimulus_config_field_rand_int(unimp_csr7_enable)
    `stimulus_config_field_rand_int(unimp_csr8_enable)
    `stimulus_config_field_rand_int(unimp_csr9_enable)
    `stimulus_config_field_rand_int(unimp_csr10_enable)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        file_mode_plusarg1 = "HQM_DATA_SEQ";
  string                        file_mode_plusarg2 = "HQM_DATA_SEQ2";
  string                        file_mode_plusarg3 = "HQM_DATA_SEQ3";
  string                        ral_file_name = "";

  rand bit [63:0]    pf_base_addr;
  rand bit [63:0]    vf_base_addr;
  rand bit [63:0]    csr_base_addr;

  rand int      has_csr_attr;   //-- 1: turn on test_hqm_ral_attr_seq
  rand int      has_csr_addr;   //-- 1: turn on csr
  rand int      has_pf_addr;    //-- 1: turn on pf (pf func, hqm_msix_mem, gaps, HCW)
  rand int      has_vf_addr;    //-- 1: turn on vf

  rand int      has_pf_hcw_wr;  //-- 1: turn on HCW space write   

  rand int      num_csr_addr;   //-- number of addresses collected by gen_unimp_addresses in CSR space
  rand int      num_rand_addr;  //-- number of addresses collected by gen_unimp_addresses in PF and VF space
  rand int      num_pick_addr;  //-- number of existing register addresses (in PF/VF) picked up for stress test

  rand int      num_unimp_addr; //--control the unimp walk through addr num (0: sample method; >0: walk-through method)

  rand int      unimp_addr_incr_min; //-- when using walk-through method, addr_incr
  rand int      unimp_addr_incr_max; 

  //-- addresses can't be accesses via PF or VF (will cause assertion if accessed)
  rand bit [15:0] unimp_vf_skip_addroff0;
  rand bit [15:0] unimp_vf_skip_addroff1;
  rand bit [15:0] unimp_pf_skip_addroff0;
  rand bit [15:0] unimp_pf_skip_addroff1;

  rand bit [15:0] unimp_pick_addroff0_min;
  rand bit [15:0] unimp_pick_addroff0_max;
  rand bit [15:0] unimp_pick_addroff1_min;
  rand bit [15:0] unimp_pick_addroff1_max;
  rand bit [15:0] unimp_pick_addroff2_min;
  rand bit [15:0] unimp_pick_addroff2_max;
  rand bit [15:0] unimp_pick_addroff3_min;
  rand bit [15:0] unimp_pick_addroff3_max;

  rand bit [31:0] unimp_vf0_addr_l_min;
  rand bit [31:0] unimp_vf1_addr_l_min;
  rand bit [31:0] unimp_vf2_addr_l_min;
  rand bit [31:0] unimp_vf3_addr_l_min;
  rand bit [31:0] unimp_vf4_addr_l_min;
  rand bit [31:0] unimp_vf5_addr_l_min;
  rand bit [31:0] unimp_vf6_addr_l_min;
  rand bit [31:0] unimp_vf7_addr_l_min;
  rand bit [31:0] unimp_vf8_addr_l_min;
  rand bit [31:0] unimp_vf9_addr_l_min;
  rand bit [31:0] unimp_vf10_addr_l_min;
  rand bit [31:0] unimp_vf11_addr_l_min;
  rand bit [31:0] unimp_vf12_addr_l_min;
  rand bit [31:0] unimp_vf13_addr_l_min;
  rand bit [31:0] unimp_vf14_addr_l_min;
  rand bit [31:0] unimp_vf15_addr_l_min;
  rand bit [31:0] unimp_vf0_addr_l_max;
  rand bit [31:0] unimp_vf1_addr_l_max;
  rand bit [31:0] unimp_vf2_addr_l_max;
  rand bit [31:0] unimp_vf3_addr_l_max;
  rand bit [31:0] unimp_vf4_addr_l_max;
  rand bit [31:0] unimp_vf5_addr_l_max;
  rand bit [31:0] unimp_vf6_addr_l_max;
  rand bit [31:0] unimp_vf7_addr_l_max;
  rand bit [31:0] unimp_vf8_addr_l_max;
  rand bit [31:0] unimp_vf9_addr_l_max;
  rand bit [31:0] unimp_vf10_addr_l_max;
  rand bit [31:0] unimp_vf11_addr_l_max;
  rand bit [31:0] unimp_vf12_addr_l_max;
  rand bit [31:0] unimp_vf13_addr_l_max;
  rand bit [31:0] unimp_vf14_addr_l_max;
  rand bit [31:0] unimp_vf15_addr_l_max;

  rand bit [31:0] unimp_vf0_addr_min;
  rand bit [31:0] unimp_vf1_addr_min;
  rand bit [31:0] unimp_vf2_addr_min;
  rand bit [31:0] unimp_vf3_addr_min;
  rand bit [31:0] unimp_vf4_addr_min;
  rand bit [31:0] unimp_vf5_addr_min;
  rand bit [31:0] unimp_vf6_addr_min;
  rand bit [31:0] unimp_vf7_addr_min;
  rand bit [31:0] unimp_vf8_addr_min;
  rand bit [31:0] unimp_vf9_addr_min;
  rand bit [31:0] unimp_vf10_addr_min;
  rand bit [31:0] unimp_vf11_addr_min;
  rand bit [31:0] unimp_vf12_addr_min;
  rand bit [31:0] unimp_vf13_addr_min;
  rand bit [31:0] unimp_vf14_addr_min;
  rand bit [31:0] unimp_vf15_addr_min;
  rand bit [31:0] unimp_vf0_addr_max;
  rand bit [31:0] unimp_vf1_addr_max;
  rand bit [31:0] unimp_vf2_addr_max;
  rand bit [31:0] unimp_vf3_addr_max;
  rand bit [31:0] unimp_vf4_addr_max;
  rand bit [31:0] unimp_vf5_addr_max;
  rand bit [31:0] unimp_vf6_addr_max;
  rand bit [31:0] unimp_vf7_addr_max;
  rand bit [31:0] unimp_vf8_addr_max;
  rand bit [31:0] unimp_vf9_addr_max;
  rand bit [31:0] unimp_vf10_addr_max;
  rand bit [31:0] unimp_vf11_addr_max;
  rand bit [31:0] unimp_vf12_addr_max;
  rand bit [31:0] unimp_vf13_addr_max;
  rand bit [31:0] unimp_vf14_addr_max;
  rand bit [31:0] unimp_vf15_addr_max;

  rand bit [31:0] unimp_pf0_addr_min;
  rand bit [31:0] unimp_pf1_addr_min;
  rand bit [31:0] unimp_pf2_addr_min;
  rand bit [31:0] unimp_pf3_addr_min;
  rand bit [31:0] unimp_pf4_addr_min;
  rand bit [31:0] unimp_pf5_addr_min;
  rand bit [31:0] unimp_pf6_addr_min;
  rand bit [31:0] unimp_pf7_addr_min;
  rand bit [31:0] unimp_pf8_addr_min;
  rand bit [31:0] unimp_pf9_addr_min;
  rand bit [31:0] unimp_pf10_addr_min;
  rand bit [31:0] unimp_pf11_addr_min;
  rand bit [31:0] unimp_pf12_addr_min;
  rand bit [31:0] unimp_pf13_addr_min;
  rand bit [31:0] unimp_pf14_addr_min;
  rand bit [31:0] unimp_pf15_addr_min;
  rand bit [31:0] unimp_pf0_addr_max;
  rand bit [31:0] unimp_pf1_addr_max;
  rand bit [31:0] unimp_pf2_addr_max;
  rand bit [31:0] unimp_pf3_addr_max;
  rand bit [31:0] unimp_pf4_addr_max;
  rand bit [31:0] unimp_pf5_addr_max;
  rand bit [31:0] unimp_pf6_addr_max;
  rand bit [31:0] unimp_pf7_addr_max;
  rand bit [31:0] unimp_pf8_addr_max;
  rand bit [31:0] unimp_pf9_addr_max;
  rand bit [31:0] unimp_pf10_addr_max;
  rand bit [31:0] unimp_pf11_addr_max;
  rand bit [31:0] unimp_pf12_addr_max;
  rand bit [31:0] unimp_pf13_addr_max;
  rand bit [31:0] unimp_pf14_addr_max;
  rand bit [31:0] unimp_pf15_addr_max;
  
  rand bit [31:0] unimp_csr0_addr_min;
  rand bit [31:0] unimp_csr1_addr_min;
  rand bit [31:0] unimp_csr2_addr_min;
  rand bit [31:0] unimp_csr3_addr_min;
  rand bit [31:0] unimp_csr4_addr_min;
  rand bit [31:0] unimp_csr5_addr_min;
  rand bit [31:0] unimp_csr6_addr_min;
  rand bit [31:0] unimp_csr7_addr_min;
  rand bit [31:0] unimp_csr8_addr_min;
  rand bit [31:0] unimp_csr9_addr_min;
  rand bit [31:0] unimp_csr10_addr_min;

  rand bit [31:0] unimp_pf_gap0_addr_min; 
  rand bit [31:0] unimp_pf_gap0_addr_max;   
  rand bit [31:0] unimp_pf_gap1_addr_min; 
  rand bit [31:0] unimp_pf_gap1_addr_max; 
  rand bit [31:0] unimp_pf_gap2_addr_min; 
  rand bit [31:0] unimp_pf_gap2_addr_max; 
  rand bit [31:0] unimp_pf_gap3_addr_min; 
  rand bit [31:0] unimp_pf_gap3_addr_max; 
        
  rand int        unimp_addr_wt_step;

  rand bit [31:0] unimp_vf_addr_stoffset;
  rand bit [31:0] unimp_vf0_addr_stoffset;
  rand bit [31:0] unimp_vf1_addr_stoffset;
  rand bit [31:0] unimp_vf2_addr_stoffset;
  rand bit [31:0] unimp_vf3_addr_stoffset;
  rand bit [31:0] unimp_vf4_addr_stoffset;
  rand bit [31:0] unimp_vf5_addr_stoffset;
  rand bit [31:0] unimp_vf6_addr_stoffset;
  rand bit [31:0] unimp_vf7_addr_stoffset;
  rand bit [31:0] unimp_vf8_addr_stoffset;
  rand bit [31:0] unimp_vf9_addr_stoffset;
  rand bit [31:0] unimp_vf10_addr_stoffset;
  rand bit [31:0] unimp_vf11_addr_stoffset;
  rand bit [31:0] unimp_vf12_addr_stoffset;
  rand bit [31:0] unimp_vf13_addr_stoffset;
  rand bit [31:0] unimp_vf14_addr_stoffset;
  rand bit [31:0] unimp_vf15_addr_stoffset;

  rand bit [31:0] unimp_csr_gap_addr_stoffset; 

  rand bit [31:0] unimp_pf_gap_addr_stoffset; 
  rand bit [31:0] unimp_pf_gap0_addr_stoffset; 
  rand bit [31:0] unimp_pf_gap1_addr_stoffset; 
  rand bit [31:0] unimp_pf_gap2_addr_stoffset; 
  rand bit [31:0] unimp_pf_gap3_addr_stoffset; 

  rand bit [31:0] hcw_space0_addr_min; 
  rand bit [31:0] hcw_space0_addr_max;   
  rand bit [31:0] hcw_space1_addr_min; 
  rand bit [31:0] hcw_space1_addr_max; 

  rand bit [31:0] unimp_vf0_wdata;
  rand bit [31:0] unimp_vf1_wdata;
  rand bit [31:0] unimp_vf2_wdata;
  rand bit [31:0] unimp_vf3_wdata;
  rand bit [31:0] unimp_vf4_wdata;
  rand bit [31:0] unimp_vf5_wdata;
  rand bit [31:0] unimp_vf6_wdata;
  rand bit [31:0] unimp_vf7_wdata;
  rand bit [31:0] unimp_vf8_wdata;
  rand bit [31:0] unimp_vf9_wdata;
  rand bit [31:0] unimp_vf10_wdata;
  rand bit [31:0] unimp_vf11_wdata;
  rand bit [31:0] unimp_vf12_wdata;
  rand bit [31:0] unimp_vf13_wdata;
  rand bit [31:0] unimp_vf14_wdata;
  rand bit [31:0] unimp_vf15_wdata;

  rand bit [31:0] unimp_pf0_wdata;
  rand bit [31:0] unimp_pf1_wdata;
  rand bit [31:0] unimp_pf2_wdata;
  rand bit [31:0] unimp_pf3_wdata;
  rand bit [31:0] unimp_pf4_wdata;
  rand bit [31:0] unimp_pf5_wdata;
  rand bit [31:0] unimp_pf6_wdata;
  rand bit [31:0] unimp_pf7_wdata;
  rand bit [31:0] unimp_pf8_wdata;
  rand bit [31:0] unimp_pf9_wdata;
  rand bit [31:0] unimp_pf10_wdata;
  rand bit [31:0] unimp_pf11_wdata;
  rand bit [31:0] unimp_pf12_wdata;
  rand bit [31:0] unimp_pf13_wdata;
  rand bit [31:0] unimp_pf14_wdata;
  rand bit [31:0] unimp_pf15_wdata;

  rand bit [31:0] unimp_csr0_wdata;
  rand bit [31:0] unimp_csr1_wdata;
  rand bit [31:0] unimp_csr2_wdata;
  rand bit [31:0] unimp_csr3_wdata;
  rand bit [31:0] unimp_csr4_wdata;
  rand bit [31:0] unimp_csr5_wdata;
  rand bit [31:0] unimp_csr6_wdata;
  rand bit [31:0] unimp_csr7_wdata;
  rand bit [31:0] unimp_csr8_wdata;
  rand bit [31:0] unimp_csr9_wdata;
  rand bit [31:0] unimp_csr10_wdata;

  rand bit [31:0] unimp_csr0_enable;
  rand bit [31:0] unimp_csr1_enable;
  rand bit [31:0] unimp_csr2_enable;
  rand bit [31:0] unimp_csr3_enable;
  rand bit [31:0] unimp_csr4_enable;
  rand bit [31:0] unimp_csr5_enable;
  rand bit [31:0] unimp_csr6_enable;
  rand bit [31:0] unimp_csr7_enable;
  rand bit [31:0] unimp_csr8_enable;
  rand bit [31:0] unimp_csr9_enable;
  rand bit [31:0] unimp_csr10_enable;

  constraint c_num_csr_addr {
    num_csr_addr       >= 0;
    soft num_csr_addr  == 0;
    soft has_csr_attr  == 0; 
    soft has_csr_addr  == 0; 
    soft has_pf_addr   == 1; 
    soft has_vf_addr   == 0; 
    soft has_pf_hcw_wr == 0;
  }

  constraint c_num_rand_addr {
    num_rand_addr       >= 0;
    soft num_rand_addr  == 20;
  }

  constraint c_num_pick_addr {
    num_pick_addr       >= 0;
    soft num_pick_addr  == 10;
  }

  constraint c_num_unimp_addr {
    num_unimp_addr       >= 0;
    soft num_unimp_addr  == 0;
  }

  constraint c_num_unimp_addr_incr {
    unimp_addr_incr_min >= 0;
    unimp_addr_incr_max >= 0;
    soft unimp_addr_incr_min == 4; //
    soft unimp_addr_incr_max == 256; //
  }

  constraint c_base_addr {
    soft pf_base_addr   ==  64'h100000000;
    soft csr_base_addr  ==  64'h200000000;
    soft vf_base_addr   == 64'h1300000000;
  }

  constraint c_skip_addroff {
    soft unimp_vf_skip_addroff0   ==  16'h1f04; //--VF space, skip PF register vf_to_pf_flr_isr (0x1f04) and vf_to_pf_isr_pend (0x1f10)
    soft unimp_vf_skip_addroff1   ==  16'h1f10; //--
    soft unimp_pf_skip_addroff0   ==  16'h2f10; //--PF space, skip VF register vf_msi_isr_pend  (0x2f10) and vf_msi_isr        (0x4000)
    soft unimp_pf_skip_addroff1   ==  16'h4000; //-- 
  }

  constraint c_pick_addroff {
    //--hqm_msix_mem offset
    soft unimp_pick_addroff0_min  ==  16'h0000; //--in both PF and VF space, pick those existing register addr offset 
    soft unimp_pick_addroff0_max  ==  16'h040c; //--
    //-- func vf_to_pf_mailbox[64]
    soft unimp_pick_addroff1_min  ==  16'h1000; //--
    soft unimp_pick_addroff1_max  ==  16'h1efc; //--
    //-- func pf_to_vf_mailbox[16]
    soft unimp_pick_addroff2_min  ==  16'h2000; //--
    soft unimp_pick_addroff2_max  ==  16'h203c; //--
    //-- hqm_func_vf_bar[*].vf_to_pf_mailbox[64] 
    soft unimp_pick_addroff3_min  ==  16'h1000; //--
    soft unimp_pick_addroff3_max  ==  16'h10fc; //--
  }

  constraint c_vf_unimp_addr_range {
    //-- unimp addr of each bar that find_gaps_in_file_by_space() can't find; lower section
    soft unimp_vf0_addr_l_min   ==  32'h00000000; //-- 
    soft unimp_vf0_addr_l_max   ==  32'h00000fff; //-- 
    soft unimp_vf1_addr_l_min   ==  32'h04000000; //-- 
    soft unimp_vf1_addr_l_max   ==  32'h04000fff; //-- 
    soft unimp_vf2_addr_l_min   ==  32'h08000000; //-- 
    soft unimp_vf2_addr_l_max   ==  32'h08000fff; //-- 
    soft unimp_vf3_addr_l_min   ==  32'h0c000000; //-- 
    soft unimp_vf3_addr_l_max   ==  32'h0c000fff; //-- 
    soft unimp_vf4_addr_l_min   ==  32'h10000000; //-- 
    soft unimp_vf4_addr_l_max   ==  32'h10000fff; //-- 
    soft unimp_vf5_addr_l_min   ==  32'h14000000; //-- 
    soft unimp_vf5_addr_l_max   ==  32'h14000fff; //-- 
    soft unimp_vf6_addr_l_min   ==  32'h18000000; //-- 
    soft unimp_vf6_addr_l_max   ==  32'h18000fff; //-- 
    soft unimp_vf7_addr_l_min   ==  32'h1c000000; //-- 
    soft unimp_vf7_addr_l_max   ==  32'h1c000fff; //-- 
    soft unimp_vf8_addr_l_min   ==  32'h20000000; //-- 
    soft unimp_vf8_addr_l_max   ==  32'h20000fff; //-- 
    soft unimp_vf9_addr_l_min   ==  32'h24000000; //-- 
    soft unimp_vf9_addr_l_max   ==  32'h24000fff; //-- 
    soft unimp_vf10_addr_l_min  ==  32'h28000000; //-- 
    soft unimp_vf10_addr_l_max  ==  32'h28000fff; //-- 
    soft unimp_vf11_addr_l_min  ==  32'h2c000000; //-- 
    soft unimp_vf11_addr_l_max  ==  32'h2c000fff; //-- 
    soft unimp_vf12_addr_l_min  ==  32'h30000000; //-- 
    soft unimp_vf12_addr_l_max  ==  32'h30000fff; //-- 
    soft unimp_vf13_addr_l_min  ==  32'h34000000; //-- 
    soft unimp_vf13_addr_l_max  ==  32'h34000fff; //-- 
    soft unimp_vf14_addr_l_min  ==  32'h38000000; //-- 
    soft unimp_vf14_addr_l_max  ==  32'h38000fff; //-- 
    soft unimp_vf15_addr_l_min  ==  32'h3c000000; //-- 
    soft unimp_vf15_addr_l_max  ==  32'h3c000fff; //-- 

    //--unimp addr of each bar that find_gaps_in_file_by_space() can't find
    soft unimp_vf0_addr_min   ==  32'h00004004; //-- 
    soft unimp_vf0_addr_max   ==  32'h03ffffff; //-- 
    soft unimp_vf1_addr_min   ==  32'h04004004; //-- 
    soft unimp_vf1_addr_max   ==  32'h07ffffff; //-- 
    soft unimp_vf2_addr_min   ==  32'h08004004; //-- 
    soft unimp_vf2_addr_max   ==  32'h0bffffff; //-- 
    soft unimp_vf3_addr_min   ==  32'h0c004004; //-- 
    soft unimp_vf3_addr_max   ==  32'h0fffffff; //-- 
    soft unimp_vf4_addr_min   ==  32'h10004004; //-- 
    soft unimp_vf4_addr_max   ==  32'h13ffffff; //-- 
    soft unimp_vf5_addr_min   ==  32'h14004004; //-- 
    soft unimp_vf5_addr_max   ==  32'h17ffffff; //-- 
    soft unimp_vf6_addr_min   ==  32'h18004004; //-- 
    soft unimp_vf6_addr_max   ==  32'h1bffffff; //-- 
    soft unimp_vf7_addr_min   ==  32'h1c004004; //-- 
    soft unimp_vf7_addr_max   ==  32'h1fffffff; //-- 
    soft unimp_vf8_addr_min   ==  32'h20004004; //-- 
    soft unimp_vf8_addr_max   ==  32'h23ffffff; //-- 
    soft unimp_vf9_addr_min   ==  32'h24004004; //-- 
    soft unimp_vf9_addr_max   ==  32'h27ffffff; //-- 
    soft unimp_vf10_addr_min  ==  32'h28004004; //-- 
    soft unimp_vf10_addr_max  ==  32'h2bffffff; //-- 
    soft unimp_vf11_addr_min  ==  32'h2c004004; //-- 
    soft unimp_vf11_addr_max  ==  32'h2fffffff; //-- 
    soft unimp_vf12_addr_min  ==  32'h30004004; //-- 
    soft unimp_vf12_addr_max  ==  32'h33ffffff; //-- 
    soft unimp_vf13_addr_min  ==  32'h34004004; //-- 
    soft unimp_vf13_addr_max  ==  32'h37ffffff; //-- 
    soft unimp_vf14_addr_min  ==  32'h38004004; //-- 
    soft unimp_vf14_addr_max  ==  32'h3bffffff; //-- 
    soft unimp_vf15_addr_min  ==  32'h3c004004; //-- 
    soft unimp_vf15_addr_max  ==  32'h3fffffff; //-- 
  }
  
  constraint c_pf_unimp_addr_range {
    //--unimp addr of each bar that find_gaps_in_file_by_space() can't find
    soft unimp_pf0_addr_min   ==  32'h00000000; //-- 
    soft unimp_pf0_addr_max   ==  32'h00000fff; //-- 
    soft unimp_pf1_addr_min   ==  32'h00010000; //-- 
    soft unimp_pf1_addr_max   ==  32'h00010fff; //-- 
    soft unimp_pf2_addr_min   ==  32'h00020000; //-- 
    soft unimp_pf2_addr_max   ==  32'h00020fff; //-- 
    soft unimp_pf3_addr_min   ==  32'h00030000; //-- 
    soft unimp_pf3_addr_max   ==  32'h00030fff; //-- 
    soft unimp_pf4_addr_min   ==  32'h00040000; //-- 
    soft unimp_pf4_addr_max   ==  32'h00040fff; //-- 
    soft unimp_pf5_addr_min   ==  32'h00050000; //-- 
    soft unimp_pf5_addr_max   ==  32'h00050fff; //-- 
    soft unimp_pf6_addr_min   ==  32'h00060000; //-- 
    soft unimp_pf6_addr_max   ==  32'h00060fff; //-- 
    soft unimp_pf7_addr_min   ==  32'h00070000; //-- 
    soft unimp_pf7_addr_max   ==  32'h00070fff; //-- 
    soft unimp_pf8_addr_min   ==  32'h00080000; //-- 
    soft unimp_pf8_addr_max   ==  32'h00080fff; //-- 
    soft unimp_pf9_addr_min   ==  32'h00090000; //-- 
    soft unimp_pf9_addr_max   ==  32'h00090fff; //-- 
    soft unimp_pf10_addr_min  ==  32'h000a0000; //-- 
    soft unimp_pf10_addr_max  ==  32'h000a0fff; //-- 
    soft unimp_pf11_addr_min  ==  32'h000b0000; //-- 
    soft unimp_pf11_addr_max  ==  32'h000b0fff; //-- 
    soft unimp_pf12_addr_min  ==  32'h000c0000; //-- 
    soft unimp_pf12_addr_max  ==  32'h000c0fff; //-- 
    soft unimp_pf13_addr_min  ==  32'h000d0000; //-- 
    soft unimp_pf13_addr_max  ==  32'h000d0fff; //-- 
    soft unimp_pf14_addr_min  ==  32'h000e0000; //-- 
    soft unimp_pf14_addr_max  ==  32'h000e0fff; //-- 
    soft unimp_pf15_addr_min  ==  32'h000f0000; //-- 
    soft unimp_pf15_addr_max  ==  32'h000f0fff; //-- 
    
    //-- PF space the gap space
    soft unimp_pf_gap0_addr_min == 32'h00100000; //-- gap between hqm_func_pf_per_vf(0x000f_ffff) and hqm_msix_mem(0x0100_0000)
    soft unimp_pf_gap0_addr_max == 32'h00ffffff;  
    soft unimp_pf_gap1_addr_min == 32'h01000410; //-- gap between hqm_msix_mem (0x0100_00410) and DIR PP (0x0200_0000)
    soft unimp_pf_gap1_addr_max == 32'h01ffffff;     

    //--HCW space in upper 32MB 0x0200_0000:0x03ff_ffff (hcw_space0_addr_min/hcw_space0_addr_max; hcw_space1_addr_min/hcw_space1_addr_max)
    soft unimp_pf_gap2_addr_min == 32'h02000000; //-- DIR PP (0x0200_0000)
    soft unimp_pf_gap2_addr_max == 32'h020fffff;   
    soft unimp_pf_gap3_addr_min == 32'h02100000; //-- LDB PP (0x0210_0000)
    soft unimp_pf_gap3_addr_max == 32'h03ffffff; //-- 32'h021fffff;             

    //-- PF_CSR
    soft unimp_csr0_addr_min   ==  32'h00000000; //-- 
    soft unimp_csr1_addr_min   ==  32'h10000000; //-- 
    soft unimp_csr2_addr_min   ==  32'h20000000; //-- 
    soft unimp_csr3_addr_min   ==  32'h30000000; //-- 
    soft unimp_csr4_addr_min   ==  32'h40000000; //-- 
    soft unimp_csr5_addr_min   ==  32'h50000000; //-- 
    soft unimp_csr6_addr_min   ==  32'h60000000; //-- 
    soft unimp_csr7_addr_min   ==  32'h70000000; //-- 
    soft unimp_csr8_addr_min   ==  32'h80000000; //-- 
    soft unimp_csr9_addr_min   ==  32'h90000000; //-- 
    soft unimp_csr10_addr_min  ==  32'ha0000000; //-- 
  }

  constraint c_unimp_addr_stoffset {
    soft unimp_addr_wt_step       ==  0; 
    soft unimp_vf_addr_stoffset   ==  4096; //--  global  for VF

    soft unimp_vf0_addr_stoffset   ==  4096; //-- 
    soft unimp_vf1_addr_stoffset   ==  4096; //-- 
    soft unimp_vf2_addr_stoffset   ==  4096; //-- 
    soft unimp_vf3_addr_stoffset   ==  4096; //-- 
    soft unimp_vf4_addr_stoffset   ==  4096; //-- 
    soft unimp_vf5_addr_stoffset   ==  4096; //-- 
    soft unimp_vf6_addr_stoffset   ==  4096; //-- 
    soft unimp_vf7_addr_stoffset   ==  4096; //-- 
    soft unimp_vf8_addr_stoffset   ==  4096; //-- 
    soft unimp_vf9_addr_stoffset   ==  4096; //-- 
    soft unimp_vf10_addr_stoffset  ==  4096; //-- 
    soft unimp_vf11_addr_stoffset  ==  4096; //-- 
    soft unimp_vf12_addr_stoffset  ==  4096; //-- 
    soft unimp_vf13_addr_stoffset  ==  4096; //-- 
    soft unimp_vf14_addr_stoffset  ==  4096; //-- 
    soft unimp_vf15_addr_stoffset  ==  4096; //-- 

    soft unimp_csr_gap_addr_stoffset  == 4096; //--  global  for CSR

    soft unimp_pf_gap_addr_stoffset  == 4096; //--  global  for PF

    soft unimp_pf_gap0_addr_stoffset == 4096; //-- gap between hqm_func_pf_per_vf(0x000f_ffff) and hqm_msix_mem(0x0100_0000)
    soft unimp_pf_gap1_addr_stoffset == 4096; //-- gap between hqm_msix_mem (0x0100_00410) and DIR PP (0x0200_0000)
    soft unimp_pf_gap2_addr_stoffset == 4096; //-- DIR PP (0x0200_0000)
    soft unimp_pf_gap3_addr_stoffset == 4096; //-- LDB PP (0x0210_0000)
  }

  constraint c_hcw_addr_space {
    //-- the whole HCW space is upper 32MB, this space: no write; only read access  (unimp_pf_gap2_addr_min/unimp_pf_gap2_addr_max; unimp_pf_gap3_addr_min/unimp_pf_gap3_addr_max)
    soft hcw_space0_addr_min   ==  32'h02000000; //-- DIR: 4096*96 
    soft hcw_space0_addr_max   ==  32'h020fffff; //32'h0205ffff; //-- 
    soft hcw_space1_addr_min   ==  32'h02100000; //-- LDB: 4096*64
    soft hcw_space1_addr_max   ==  32'h03ffffff; //32'h0213ffff; //-- 
  }


  constraint c_unimp_wdata {
    soft unimp_vf0_wdata  == 32'ha055aa00;
    soft unimp_vf1_wdata  == 32'ha155aa01;
    soft unimp_vf2_wdata  == 32'ha255aa02;
    soft unimp_vf3_wdata  == 32'ha355aa03;
    soft unimp_vf4_wdata  == 32'ha455aa04;
    soft unimp_vf5_wdata  == 32'ha555aa05;
    soft unimp_vf6_wdata  == 32'ha655aa06;
    soft unimp_vf7_wdata  == 32'ha755aa07;
    soft unimp_vf8_wdata  == 32'ha855aa08;
    soft unimp_vf9_wdata  == 32'ha955aa09;
    soft unimp_vf10_wdata  == 32'haa55aa0a;
    soft unimp_vf11_wdata  == 32'hab55aa0b;
    soft unimp_vf12_wdata  == 32'hac55aa0c;
    soft unimp_vf13_wdata  == 32'had55aa0d;
    soft unimp_vf14_wdata  == 32'hae55aa0e;
    soft unimp_vf15_wdata  == 32'haf55aa0f;

    soft unimp_pf0_wdata  == 32'hb044bb00;
    soft unimp_pf1_wdata  == 32'hb144bb01;
    soft unimp_pf2_wdata  == 32'hb244bb02;
    soft unimp_pf3_wdata  == 32'hb344bb03;
    soft unimp_pf4_wdata  == 32'hb444bb04;
    soft unimp_pf5_wdata  == 32'hb544bb05;
    soft unimp_pf6_wdata  == 32'hb644bb06;
    soft unimp_pf7_wdata  == 32'hb744bb07;
    soft unimp_pf8_wdata  == 32'hb844bb08;
    soft unimp_pf9_wdata  == 32'hb944bb09;
    soft unimp_pf10_wdata  == 32'hba44bb0a;
    soft unimp_pf11_wdata  == 32'hbb44bb0b;
    soft unimp_pf12_wdata  == 32'hbc44bb0c;
    soft unimp_pf13_wdata  == 32'hbd44bb0d;
    soft unimp_pf14_wdata  == 32'hbe44bb0e;
    soft unimp_pf15_wdata  == 32'hbf44bb0f;

    soft unimp_csr0_wdata  == 32'hc033cc00;
    soft unimp_csr1_wdata  == 32'hc133cc01;
    soft unimp_csr2_wdata  == 32'hc233cc02;
    soft unimp_csr3_wdata  == 32'hc333cc03;
    soft unimp_csr4_wdata  == 32'hc433cc04;
    soft unimp_csr5_wdata  == 32'hc533cc05;
    soft unimp_csr6_wdata  == 32'hc633cc06;
    soft unimp_csr7_wdata  == 32'hc733cc07;
    soft unimp_csr8_wdata  == 32'hc833cc08;
    soft unimp_csr9_wdata  == 32'hc933cc09;
    soft unimp_csr10_wdata  == 32'hca33cc0a;

  }

  constraint c_csr_unimp_enable {
    soft unimp_csr0_enable  == 0;
    soft unimp_csr1_enable  == 0;
    soft unimp_csr2_enable  == 0;
    soft unimp_csr3_enable  == 0;
    soft unimp_csr4_enable  == 0;
    soft unimp_csr5_enable  == 0;
    soft unimp_csr6_enable  == 0;
    soft unimp_csr7_enable  == 0;
    soft unimp_csr8_enable  == 0;
    soft unimp_csr9_enable  == 0;
    soft unimp_csr10_enable  == 0;
  }


  function new(string name = "hqm_pfvf_space_acc_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pfvf_space_acc_seq_stim_config

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class hqm_pfvf_space_acc_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_pfvf_space_acc_seq, sla_sequencer)

  rand hqm_pfvf_space_acc_seq_stim_config        cfg;

  sla_ral_env                   ral;
  hqm_ral_env                   hqm_ral;
  sla_ral_data_t                ral_data;

  string vf_file_name_list[$];
  string pf_file_name_list[$];
  string csr_file_name_list[$];
  bit                           csr_unimp_enable[11];
  sla_ral_data_t                vf_unimp_wdata[16];
  sla_ral_data_t                pf_unimp_wdata[16];
  sla_ral_data_t                csr_unimp_wdata[11];

  sla_ral_addr_t                vf_skip_addroffset_q[$];
  sla_ral_addr_t                pf_skip_addroffset_q[$];

  sla_ral_addr_t                vf_pick_addroffset_q[$];
  sla_ral_addr_t                pf_pick_addroffset_q[$];
  sla_ral_addr_t                csr_system_pick_addroffset_q[$];

  sla_ral_addr_t                vf_unimp_addr_l_min_q[$]; 
  sla_ral_addr_t                vf_unimp_addr_l_max_q[$]; 
  sla_ral_addr_t                vf_unimp_addr_min_q[$]; 
  sla_ral_addr_t                vf_unimp_addr_max_q[$];
  sla_ral_addr_t                pf_unimp_addr_min_q[$]; 
  sla_ral_addr_t                pf_unimp_addr_max_q[$];
  sla_ral_addr_t                csr_unimp_addr_min_q[$]; 
  sla_ral_addr_t                csr_unimp_addr_max_q[$];

  sla_ral_addr_t                csr_unimp_addr_min_q[$]; 
  sla_ral_addr_t                csr_unimp_addr_max_q[$];

  sla_ral_addr_t                csr_imp_addr_min_q[$]; 
  sla_ral_addr_t                csr_imp_addr_max_q[$];


  sla_ral_addr_t                vf_unimp_addr_stoffset_q[$]; 
  sla_ral_addr_t                pf_unimp_addr_stoffset_q[$]; 


  test_hqm_ral_attr_seq         i_hqm_ral_attr_seq;

  hqm_tb_cfg_file_mode_seq      i_file_mode_seq;
  hqm_tb_cfg_file_mode_seq      i_file_mode_seq2;
  hqm_tb_cfg_file_mode_seq      i_file_mode_seq3;

  string                        reg_cases;
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq          cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq          cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_msg_wr_seq        msg_write_seq;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pfvf_space_acc_seq_stim_config);

  function new(string name = "hqm_pfvf_space_acc_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name);

    cfg = hqm_pfvf_space_acc_seq_stim_config::type_id::create("hqm_pfvf_space_acc_seq_stim_config");
    apply_stim_config_overrides(0);

    vf_file_name_list[0]="hqm_func_vf_bar[0]";
    vf_file_name_list[1]="hqm_func_vf_bar[1]";
    vf_file_name_list[2]="hqm_func_vf_bar[2]";
    vf_file_name_list[3]="hqm_func_vf_bar[3]";
    vf_file_name_list[4]="hqm_func_vf_bar[4]";
    vf_file_name_list[5]="hqm_func_vf_bar[5]";
    vf_file_name_list[6]="hqm_func_vf_bar[6]";
    vf_file_name_list[7]="hqm_func_vf_bar[7]";
    vf_file_name_list[8]="hqm_func_vf_bar[8]";
    vf_file_name_list[9]="hqm_func_vf_bar[9]";
    vf_file_name_list[10]="hqm_func_vf_bar[10]";
    vf_file_name_list[11]="hqm_func_vf_bar[11]";
    vf_file_name_list[12]="hqm_func_vf_bar[12]";
    vf_file_name_list[13]="hqm_func_vf_bar[13]";
    vf_file_name_list[14]="hqm_func_vf_bar[14]";
    vf_file_name_list[15]="hqm_func_vf_bar[15]";

    pf_file_name_list[0]="hqm_func_pf_per_vf[0]";
    pf_file_name_list[1]="hqm_func_pf_per_vf[1]";
    pf_file_name_list[2]="hqm_func_pf_per_vf[2]";
    pf_file_name_list[3]="hqm_func_pf_per_vf[3]";
    pf_file_name_list[4]="hqm_func_pf_per_vf[4]";
    pf_file_name_list[5]="hqm_func_pf_per_vf[5]";
    pf_file_name_list[6]="hqm_func_pf_per_vf[6]";
    pf_file_name_list[7]="hqm_func_pf_per_vf[7]";
    pf_file_name_list[8]="hqm_func_pf_per_vf[8]";
    pf_file_name_list[9]="hqm_func_pf_per_vf[9]";
    pf_file_name_list[10]="hqm_func_pf_per_vf[10]";
    pf_file_name_list[11]="hqm_func_pf_per_vf[11]";
    pf_file_name_list[12]="hqm_func_pf_per_vf[12]";
    pf_file_name_list[13]="hqm_func_pf_per_vf[13]";
    pf_file_name_list[14]="hqm_func_pf_per_vf[14]";
    pf_file_name_list[15]="hqm_func_pf_per_vf[15]";

    csr_file_name_list[0]="hqm_sif_csr";
    csr_file_name_list[1]="hqm_system_csr";
    csr_file_name_list[2]="aqed_pipe";
    csr_file_name_list[3]="atm_pipe";
    csr_file_name_list[4]="credit_hist_pipe";
    csr_file_name_list[5]="direct_pipe";
    csr_file_name_list[6]="qed_pipe";
    csr_file_name_list[7]="nalb_pipe";
    csr_file_name_list[8]="reorder_pipe";
    csr_file_name_list[9]="list_sel_pipe";
    csr_file_name_list[10]="config_master";
  endfunction

  virtual task body();
    ovm_object          o_tmp;
    string              file_space;
    bit [63:0]          file_size;
    sla_ral_addr_t      unimp_addr_q[$];
    sla_ral_addr_t      sel_unimp_addr_q[$];
    sla_ral_addr_t      pf_unimp_addr_q[$];
    sla_ral_addr_t      vf_unimp_addr_q[$];
    sla_ral_addr_t      csr_unimp_addr_q[$];
    int                 unimp_reg_width_q[$];
    sla_ral_file        rfile;
    string              file_name;
    int                 is_vf;
    bit [15:0]          pick_addroff_val;
    bit [31:0]          wdata_tmp;
    int                 num_val;

    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal(get_full_name(), "Unable to get RAL handle");
    end    

    rfile = ral.find_file("aqed_pipe");
      
    $cast(hqm_ral,rfile.get_ral_env());
    //hqm_ral.reset_regs();

    apply_stim_config_overrides(1);

    vf_unimp_wdata[0]=cfg.unimp_vf0_wdata;
    vf_unimp_wdata[1]=cfg.unimp_vf1_wdata;
    vf_unimp_wdata[2]=cfg.unimp_vf2_wdata;
    vf_unimp_wdata[3]=cfg.unimp_vf3_wdata;
    vf_unimp_wdata[4]=cfg.unimp_vf4_wdata;
    vf_unimp_wdata[5]=cfg.unimp_vf5_wdata;
    vf_unimp_wdata[6]=cfg.unimp_vf6_wdata;
    vf_unimp_wdata[7]=cfg.unimp_vf7_wdata;
    vf_unimp_wdata[8]=cfg.unimp_vf8_wdata;
    vf_unimp_wdata[9]=cfg.unimp_vf9_wdata;
    vf_unimp_wdata[10]=cfg.unimp_vf10_wdata;
    vf_unimp_wdata[11]=cfg.unimp_vf11_wdata;
    vf_unimp_wdata[12]=cfg.unimp_vf12_wdata;
    vf_unimp_wdata[13]=cfg.unimp_vf13_wdata;
    vf_unimp_wdata[14]=cfg.unimp_vf14_wdata;
    vf_unimp_wdata[15]=cfg.unimp_vf15_wdata;

    pf_unimp_wdata[0]=cfg.unimp_pf0_wdata;
    pf_unimp_wdata[1]=cfg.unimp_pf1_wdata;
    pf_unimp_wdata[2]=cfg.unimp_pf2_wdata;
    pf_unimp_wdata[3]=cfg.unimp_pf3_wdata;
    pf_unimp_wdata[4]=cfg.unimp_pf4_wdata;
    pf_unimp_wdata[5]=cfg.unimp_pf5_wdata;
    pf_unimp_wdata[6]=cfg.unimp_pf6_wdata;
    pf_unimp_wdata[7]=cfg.unimp_pf7_wdata;
    pf_unimp_wdata[8]=cfg.unimp_pf8_wdata;
    pf_unimp_wdata[9]=cfg.unimp_pf9_wdata;
    pf_unimp_wdata[10]=cfg.unimp_pf10_wdata;
    pf_unimp_wdata[11]=cfg.unimp_pf11_wdata;
    pf_unimp_wdata[12]=cfg.unimp_pf12_wdata;
    pf_unimp_wdata[13]=cfg.unimp_pf13_wdata;
    pf_unimp_wdata[14]=cfg.unimp_pf14_wdata;
    pf_unimp_wdata[15]=cfg.unimp_pf15_wdata;

    csr_unimp_wdata[0]=cfg.unimp_csr0_wdata;
    csr_unimp_wdata[1]=cfg.unimp_csr1_wdata;
    csr_unimp_wdata[2]=cfg.unimp_csr2_wdata;
    csr_unimp_wdata[3]=cfg.unimp_csr3_wdata;
    csr_unimp_wdata[4]=cfg.unimp_csr4_wdata;
    csr_unimp_wdata[5]=cfg.unimp_csr5_wdata;
    csr_unimp_wdata[6]=cfg.unimp_csr6_wdata;
    csr_unimp_wdata[7]=cfg.unimp_csr7_wdata;
    csr_unimp_wdata[8]=cfg.unimp_csr8_wdata;
    csr_unimp_wdata[9]=cfg.unimp_csr9_wdata;
    csr_unimp_wdata[10]=cfg.unimp_csr10_wdata;

    csr_unimp_enable[0]=cfg.unimp_csr0_enable;
    csr_unimp_enable[1]=cfg.unimp_csr1_enable;
    csr_unimp_enable[2]=cfg.unimp_csr2_enable;
    csr_unimp_enable[3]=cfg.unimp_csr3_enable;
    csr_unimp_enable[4]=cfg.unimp_csr4_enable;
    csr_unimp_enable[5]=cfg.unimp_csr5_enable;
    csr_unimp_enable[6]=cfg.unimp_csr6_enable;
    csr_unimp_enable[7]=cfg.unimp_csr7_enable;
    csr_unimp_enable[8]=cfg.unimp_csr8_enable;
    csr_unimp_enable[9]=cfg.unimp_csr9_enable;
    csr_unimp_enable[10]=cfg.unimp_csr10_enable;

    vf_skip_addroffset_q.delete();
    vf_skip_addroffset_q.push_back(cfg.unimp_vf_skip_addroff0);
    vf_skip_addroffset_q.push_back(cfg.unimp_vf_skip_addroff1);

    pf_skip_addroffset_q.delete();
    pf_skip_addroffset_q.push_back(cfg.unimp_pf_skip_addroff0);
    pf_skip_addroffset_q.push_back(cfg.unimp_pf_skip_addroff1);

    vf_pick_addroffset_q.delete();
    pf_pick_addroffset_q.delete();
    csr_system_pick_addroffset_q.delete();

    for(int i=0; i<cfg.num_pick_addr; i++) begin
       pick_addroff_val=$urandom_range(cfg.unimp_pick_addroff0_max, cfg.unimp_pick_addroff0_min);
       pick_addroff_val[1:0]=0;
       vf_pick_addroffset_q.push_back(pick_addroff_val);
       pick_addroff_val=$urandom_range(cfg.unimp_pick_addroff1_max, cfg.unimp_pick_addroff1_min);
       pick_addroff_val[1:0]=0;
       vf_pick_addroffset_q.push_back(pick_addroff_val);
       pick_addroff_val=$urandom_range(cfg.unimp_pick_addroff2_max, cfg.unimp_pick_addroff2_min);
       pick_addroff_val[1:0]=0;
       vf_pick_addroffset_q.push_back(pick_addroff_val);
    end

    for(int i=0; i<cfg.num_pick_addr; i++) begin
       pick_addroff_val=$urandom_range(cfg.unimp_pick_addroff0_max, cfg.unimp_pick_addroff0_min);
       pick_addroff_val[1:0]=0;
       pf_pick_addroffset_q.push_back(pick_addroff_val);
       pick_addroff_val=$urandom_range(cfg.unimp_pick_addroff1_max, cfg.unimp_pick_addroff1_min);
       pick_addroff_val[1:0]=0;
       pf_pick_addroffset_q.push_back(pick_addroff_val);
       pick_addroff_val=$urandom_range(cfg.unimp_pick_addroff2_max, cfg.unimp_pick_addroff2_min);
       pick_addroff_val[1:0]=0;
       pf_pick_addroffset_q.push_back(pick_addroff_val);
    end
    for(int i=0; i<cfg.num_pick_addr; i++) begin
       //pick_addroff_val=$urandom_range(cfg.unimp_pick_addroff3_max, cfg.unimp_pick_addroff3_min);
       //pick_addroff_val[1:0]=0;
       if(i<64)
         pick_addroff_val= cfg.unimp_pick_addroff3_min+i*4;
       else  
         pick_addroff_val= cfg.unimp_pick_addroff2_min+i*4;

       csr_system_pick_addroffset_q.push_back(pick_addroff_val);

       //pick_addroff_val=$urandom_range(cfg.unimp_pick_addroff2_max, cfg.unimp_pick_addroff2_min);
       //pick_addroff_val[1:0]=0;
       //csr_system_pick_addroffset_q.push_back(pick_addroff_val);
    end

    foreach(csr_system_pick_addroffset_q[i])
       `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Prep:: Pick csr_system_pick_addroffset_q[%0d]=0x%0x", i, csr_system_pick_addroffset_q[i]),OVM_MEDIUM)
    foreach(pf_pick_addroffset_q[i])
       `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Prep:: Pick pf_pick_addroffset_q[%0d]=0x%0x", i, pf_pick_addroffset_q[i]),OVM_MEDIUM)
    foreach(vf_pick_addroffset_q[i])
       `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Prep:: Pick vf_pick_addroffset_q[%0d]=0x%0x", i, vf_pick_addroffset_q[i]),OVM_MEDIUM)


    vf_unimp_addr_l_min_q.delete();
    vf_unimp_addr_l_max_q.delete();
    vf_unimp_addr_min_q.delete();
    vf_unimp_addr_max_q.delete();
    pf_unimp_addr_min_q.delete();
    pf_unimp_addr_max_q.delete();
    csr_unimp_addr_min_q.delete();
    csr_unimp_addr_max_q.delete();
    csr_imp_addr_min_q.delete();
    csr_imp_addr_max_q.delete();
    vf_unimp_addr_stoffset_q.delete();
    pf_unimp_addr_stoffset_q.delete();

    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf0_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf1_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf2_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf3_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf4_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf5_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf6_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf7_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf8_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf9_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf10_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf11_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf12_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf13_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf14_addr_l_min);
    vf_unimp_addr_l_min_q.push_back(cfg.unimp_vf15_addr_l_min);

    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf0_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf1_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf2_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf3_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf4_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf5_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf6_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf7_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf8_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf9_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf10_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf11_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf12_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf13_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf14_addr_l_max);
    vf_unimp_addr_l_max_q.push_back(cfg.unimp_vf15_addr_l_max);

    vf_unimp_addr_min_q.push_back(cfg.unimp_vf0_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf1_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf2_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf3_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf4_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf5_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf6_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf7_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf8_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf9_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf10_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf11_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf12_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf13_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf14_addr_min);
    vf_unimp_addr_min_q.push_back(cfg.unimp_vf15_addr_min);

   // $value$plusargs("HQM_UNIMP_VF0_ADDR_MAX=%x", unimp_vf0_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf0_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf1_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf2_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf3_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf4_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf5_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf6_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf7_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf8_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf9_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf10_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf11_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf12_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf13_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf14_addr_max);
    vf_unimp_addr_max_q.push_back(cfg.unimp_vf15_addr_max);

    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf0_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf1_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf2_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf3_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf4_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf5_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf6_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf7_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf8_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf9_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf10_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf11_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf12_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf13_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf14_addr_stoffset);
    //vf_unimp_addr_stoffset_q.push_back(cfg.unimp_vf15_addr_stoffset);

    pf_unimp_addr_min_q.push_back(cfg.unimp_pf0_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf1_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf2_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf3_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf4_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf5_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf6_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf7_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf8_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf9_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf10_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf11_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf12_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf13_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf14_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf15_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf_gap0_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf_gap1_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf_gap2_addr_min);
    pf_unimp_addr_min_q.push_back(cfg.unimp_pf_gap3_addr_min);

    pf_unimp_addr_max_q.push_back(cfg.unimp_pf0_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf1_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf2_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf3_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf4_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf5_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf6_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf7_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf8_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf9_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf10_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf11_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf12_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf13_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf14_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf15_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf_gap0_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf_gap1_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf_gap2_addr_max);
    pf_unimp_addr_max_q.push_back(cfg.unimp_pf_gap3_addr_max);

    pf_unimp_addr_stoffset_q.push_back(cfg.unimp_pf_gap_addr_stoffset);
    pf_unimp_addr_stoffset_q.push_back(cfg.unimp_pf_gap_addr_stoffset);
    pf_unimp_addr_stoffset_q.push_back(cfg.unimp_pf_gap_addr_stoffset);
    pf_unimp_addr_stoffset_q.push_back(cfg.unimp_pf_gap_addr_stoffset);
    //pf_unimp_addr_stoffset_q.push_back(cfg.unimp_pf_gap0_addr_stoffset);
    //pf_unimp_addr_stoffset_q.push_back(cfg.unimp_pf_gap1_addr_stoffset);
    //pf_unimp_addr_stoffset_q.push_back(cfg.unimp_pf_gap2_addr_stoffset);
    //pf_unimp_addr_stoffset_q.push_back(cfg.unimp_pf_gap3_addr_stoffset);

    csr_unimp_addr_min_q.push_back(32'h00000000);
    csr_unimp_addr_max_q.push_back(32'h0fffffff);
    csr_unimp_addr_min_q.push_back(32'h10000000);
    csr_unimp_addr_max_q.push_back(32'h1fffffff);
    csr_unimp_addr_min_q.push_back(32'h20000000);
    csr_unimp_addr_max_q.push_back(32'h2fffffff);
    csr_unimp_addr_min_q.push_back(32'h30000000);
    csr_unimp_addr_max_q.push_back(32'h3fffffff);
    csr_unimp_addr_min_q.push_back(32'h40000000);
    csr_unimp_addr_max_q.push_back(32'h4fffffff);
    csr_unimp_addr_min_q.push_back(32'h50000000);
    csr_unimp_addr_max_q.push_back(32'h5fffffff);
    csr_unimp_addr_min_q.push_back(32'h60000000);
    csr_unimp_addr_max_q.push_back(32'h6fffffff);
    csr_unimp_addr_min_q.push_back(32'h70000000);
    csr_unimp_addr_max_q.push_back(32'h7fffffff);
    csr_unimp_addr_min_q.push_back(32'h80000000);
    csr_unimp_addr_max_q.push_back(32'h8fffffff);
    csr_unimp_addr_min_q.push_back(32'h90000000);
    csr_unimp_addr_max_q.push_back(32'h9fffffff);
    csr_unimp_addr_min_q.push_back(32'ha0000000);
    csr_unimp_addr_max_q.push_back(32'hafffffff);

    //--CHP freelist 2K*4B=8KB space 
    //--CFG_FREELIST_0[2048] @0x0e050000
    //--CFG_FREELIST_1[2048] @0x0e060000
    //--CFG_FREELIST_2[2048] @0x0e070000
    //--CFG_FREELIST_3[2048] @0x0e080000
    //--CFG_FREELIST_4[2048] @0x0e090000
    //--CFG_FREELIST_5[2048] @0x0e0a0000
    //--CFG_FREELIST_6[2048] @0x0e0b0000
    //--CFG_FREELIST_7[2048] @0x0e0c0000
    csr_imp_addr_min_q.push_back(32'h4e050000);
    csr_imp_addr_max_q.push_back(32'h4e051fff);
    csr_imp_addr_min_q.push_back(32'h4e060000);
    csr_imp_addr_max_q.push_back(32'h4e061fff);
    csr_imp_addr_min_q.push_back(32'h4e070000);
    csr_imp_addr_max_q.push_back(32'h4e071fff);
    csr_imp_addr_min_q.push_back(32'h4e080000);
    csr_imp_addr_max_q.push_back(32'h4e081fff);
    csr_imp_addr_min_q.push_back(32'h4e090000);
    csr_imp_addr_max_q.push_back(32'h4e091fff);
    csr_imp_addr_min_q.push_back(32'h4e0a0000);
    csr_imp_addr_max_q.push_back(32'h4e0a1fff);
    csr_imp_addr_min_q.push_back(32'h4e0b0000);
    csr_imp_addr_max_q.push_back(32'h4e0b1fff);
    csr_imp_addr_min_q.push_back(32'h4e0c0000);
    csr_imp_addr_max_q.push_back(32'h4e0c1fff);


    //--AY_RM_VF_V30
    cfg.has_vf_addr = 0;


    foreach(csr_unimp_addr_max_q[i])
       `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Prep:: setting csr_unimp_addr_min_q[%0d]=0x%2x   :: csr_unimp_addr_max_q[%0d]=0x%2x ", i, csr_unimp_addr_min_q[i], i, csr_unimp_addr_max_q[i]),OVM_LOW)
    foreach(pf_unimp_addr_max_q[i])
       `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Prep:: setting pf_unimp_addr_min_q[%0d]=0x%2x   :: pf_unimp_addr_max_q[%0d]=0x%2x ", i, pf_unimp_addr_min_q[i], i, pf_unimp_addr_max_q[i]),OVM_LOW)
    foreach(vf_unimp_addr_l_max_q[i]) begin
       `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Prep:: setting vf_unimp_addr_l_min_q[%0d]=0x%2x :: vf_unimp_addr_l_max_q[%0d]=0x%2x ", i, vf_unimp_addr_l_min_q[i], i, vf_unimp_addr_l_max_q[i]),OVM_LOW)
       `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Prep:: setting vf_unimp_addr_min_q[%0d]=0x%2x   :: vf_unimp_addr_max_q[%0d]=0x%2x ", i, vf_unimp_addr_min_q[i], i, vf_unimp_addr_max_q[i]),OVM_LOW)
    end

    `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Prep:: setting unimp_vf_addr_stoffset=0x%2x, unimp_pf_gap_addr_stoffset=0x%2x, unimp_csr_gap_addr_stoffset=0x%0x, unimp_addr_wt_step=%0d ", cfg.unimp_vf_addr_stoffset, cfg.unimp_pf_gap_addr_stoffset, cfg.unimp_csr_gap_addr_stoffset, cfg.unimp_addr_wt_step),OVM_LOW)
    `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Prep:: setting has_csr_addr=%0d has_pf_addr=%0d has_pf_hcw_wr=%0d, has_vf_addr=%0d", cfg.has_csr_addr, cfg.has_pf_addr, cfg.has_pf_hcw_wr, cfg.has_vf_addr),OVM_LOW)
    `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Prep:: setting has_csr_attr=%0d num_csr_addr=%0d, num_rand_addr=%0d, num_pick_addr=%0d, num_unimp_addr=%0d(>0:walk-through; 0: sample) ", cfg.has_csr_attr, cfg.num_csr_addr, cfg.num_rand_addr, cfg.num_pick_addr, cfg.num_unimp_addr),OVM_LOW)


    //-------------------------------
    //--Step1: Program PF func and VF func by using cft-file
    //-------------------------------
   `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step1:: Program PF/VF func and hqm_msix_mem registers via cft file %0s", cfg.file_mode_plusarg1),OVM_LOW)

    i_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq");
    i_file_mode_seq.set_cfg(cfg.file_mode_plusarg1, 1'b0);
    i_file_mode_seq.start(get_sequencer());


    //-------------------------------
    //--Step1: Program PF func and VF func by using cft-file
    //-------------------------------
    //if(cfg.has_csr_attr) begin
    if ($test$plusargs("HAS_CSR_ATTR")) begin
        `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step1:: Program CSR registers via i_hqm_ral_attr_seq"),OVM_LOW)
        `ovm_do(i_hqm_ral_attr_seq)
    end

//####AY_RM_VF_V30       //-------------------------------
//####AY_RM_VF_V30       //--Step2: Write to unimp address in VF bars
//####AY_RM_VF_V30       //-------------------------------
//####AY_RM_VF_V30      `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step2:: Write to unimplemented space in VF vf_base_addr=0x%0x, num_rand_addr=%0d num_unimp_addr=%0d", cfg.vf_base_addr, cfg.num_rand_addr, cfg.num_unimp_addr),OVM_LOW)
//####AY_RM_VF_V30       vf_unimp_addr_q.delete();
//####AY_RM_VF_V30       is_vf=1;
//####AY_RM_VF_V30       if(cfg.has_vf_addr==1) begin
//####AY_RM_VF_V30          for(int fidx=0; fidx<16; fidx++) begin
//####AY_RM_VF_V30              file_name = vf_file_name_list[fidx];
//####AY_RM_VF_V30              file_name = file_name.tolower(); //cfg.ral_file_name.tolower();
//####AY_RM_VF_V30             `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step2:: Write to unimplemented space in %0s fidx=%0d", file_name, fidx),OVM_LOW)
//####AY_RM_VF_V30   
//####AY_RM_VF_V30              collect_unimp_addresses(file_name, cfg.num_rand_addr, unimp_addr_q, unimp_reg_width_q);
//####AY_RM_VF_V30              select_unimp_addresses(is_vf, fidx, cfg.num_unimp_addr, vf_unimp_addr_stoffset_q[fidx], cfg.unimp_addr_incr_min, cfg.unimp_addr_incr_max, unimp_addr_q, sel_unimp_addr_q);	   
//####AY_RM_VF_V30    
//####AY_RM_VF_V30              foreach(sel_unimp_addr_q[i]) begin
//####AY_RM_VF_V30                wdata_tmp[31:24] =  vf_unimp_wdata[fidx][31:24];
//####AY_RM_VF_V30                wdata_tmp[23:0]  =  sel_unimp_addr_q[i][27:4];
//####AY_RM_VF_V30                do_iosf_memwr(is_vf, fidx, cfg.vf_base_addr+sel_unimp_addr_q[i], wdata_tmp); 
//####AY_RM_VF_V30                vf_unimp_addr_q.push_back(cfg.vf_base_addr+sel_unimp_addr_q[i]);
//####AY_RM_VF_V30              end 
//####AY_RM_VF_V30          end //for(fidx
//####AY_RM_VF_V30       end 
//####AY_RM_VF_V30   
//####AY_RM_VF_V30       //-------------------------------
//####AY_RM_VF_V30       //--Step3: Write to unimp address in PF func bars
//####AY_RM_VF_V30       //-------------------------------
//####AY_RM_VF_V30      `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step3:: Write to unimplemented space in PF func bar pf_base_addr=0x%0x, num_rand_addr=%0d num_unimp_addr=%0d", cfg.pf_base_addr, cfg.num_rand_addr, cfg.num_unimp_addr),OVM_LOW)
//####AY_RM_VF_V30       pf_unimp_addr_q.delete();
//####AY_RM_VF_V30       is_vf=0;
//####AY_RM_VF_V30       if(cfg.has_pf_addr==1) begin
//####AY_RM_VF_V30          for(int fidx=0; fidx<16; fidx++) begin
//####AY_RM_VF_V30              file_name = pf_file_name_list[fidx];
//####AY_RM_VF_V30              file_name = file_name.tolower(); //cfg.ral_file_name.tolower();
//####AY_RM_VF_V30             `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step3:: Write to unimplemented space in %0s fidx=%0d", file_name, fidx),OVM_LOW)
//####AY_RM_VF_V30   
//####AY_RM_VF_V30              collect_unimp_addresses(file_name, cfg.num_rand_addr, unimp_addr_q, unimp_reg_width_q);
//####AY_RM_VF_V30              //select_unimp_addresses(is_vf, fidx, cfg.num_unimp_addr, pf_unimp_addr_stoffset_q[fidx%4], cfg.unimp_addr_incr_min, cfg.unimp_addr_incr_max, unimp_addr_q, sel_unimp_addr_q);
//####AY_RM_VF_V30              //-- pf walk_through = 0; use sample
//####AY_RM_VF_V30              select_unimp_addresses(is_vf, fidx, cfg.num_unimp_addr, pf_unimp_addr_stoffset_q[0], cfg.unimp_addr_incr_min, cfg.unimp_addr_incr_max, unimp_addr_q, sel_unimp_addr_q);
//####AY_RM_VF_V30   
//####AY_RM_VF_V30              foreach(sel_unimp_addr_q[i]) begin
//####AY_RM_VF_V30                do_iosf_memwr(is_vf, fidx, cfg.pf_base_addr+sel_unimp_addr_q[i], pf_unimp_wdata[fidx]); 
//####AY_RM_VF_V30                pf_unimp_addr_q.push_back(cfg.pf_base_addr+sel_unimp_addr_q[i]);
//####AY_RM_VF_V30              end
//####AY_RM_VF_V30          end//for(fidx 
//####AY_RM_VF_V30       end

    //-------------------------------
    //--Step4: Write to unimp address in CSR space
    //-------------------------------
   `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step4:: Write to unimplemented space in cSR space csr_base_addr=0x%0x, num_csr_addr=%0d", cfg.csr_base_addr, cfg.num_csr_addr),OVM_LOW)
    csr_unimp_addr_q.delete();
    is_vf=2;
    if(cfg.has_csr_addr==1 && cfg.num_csr_addr>0) begin
       for(int fidx=0; fidx<11; fidx++) begin
          if(csr_unimp_enable[fidx]==1) begin
             file_name = csr_file_name_list[fidx];
             file_name = file_name.tolower(); //cfg.ral_file_name.tolower();
            `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step4:: 1_Write to unimplemented space in CSR.%0s fidx=%0d", file_name, fidx),OVM_LOW)

             collect_unimp_addresses(file_name, cfg.num_csr_addr, unimp_addr_q, unimp_reg_width_q);
            `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step4:: 2_Write to unimplemented space in CSR.%0s unimp_addr_q.size=%0d num_csr_addr=%0d", file_name, unimp_addr_q.size(), cfg.num_csr_addr),OVM_LOW)

             //--select_unimp_addr_q from unimp_addr_q
             sel_unimp_addr_q.delete();
             //-- csr cfg.num_unimp_addr=0 (walk_through = 0; use sample)
             //-- csr cfg.num_unimp_addr=1 (walk_through = 1; )
             select_unimp_addresses(is_vf, fidx, cfg.num_unimp_addr, cfg.unimp_csr_gap_addr_stoffset, cfg.unimp_addr_incr_min, cfg.unimp_addr_incr_max, unimp_addr_q, sel_unimp_addr_q);
             `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step4:: 3_Write to unimplemented space in CSR.%0s unimp_addr_q.size=%0d, sel_unimp_addr_q.size=%0d", file_name, unimp_addr_q.size(), sel_unimp_addr_q.size()),OVM_MEDIUM)

             //-- when use sample:
             if(cfg.num_unimp_addr==0) begin
                if(unimp_addr_q.size() > cfg.num_csr_addr) begin
                   for(int k=0; k<cfg.num_csr_addr; k++) begin
                      num_val=$urandom_range(0, (unimp_addr_q.size()-1)); 
                      if((unimp_addr_q[num_val]>=csr_unimp_addr_min_q[fidx] && unimp_addr_q[num_val] < csr_unimp_addr_max_q[fidx]) || fidx==10)  begin

                        //--one more round of filter to prevent wrong pickup of unimplemented address by RAL function
                        if(((unimp_addr_q[num_val]>=csr_imp_addr_min_q[0] && unimp_addr_q[num_val] < csr_imp_addr_max_q[0]) || 
                            (unimp_addr_q[num_val]>=csr_imp_addr_min_q[1] && unimp_addr_q[num_val] < csr_imp_addr_max_q[1]) ||
                            (unimp_addr_q[num_val]>=csr_imp_addr_min_q[2] && unimp_addr_q[num_val] < csr_imp_addr_max_q[2]) ||
                            (unimp_addr_q[num_val]>=csr_imp_addr_min_q[3] && unimp_addr_q[num_val] < csr_imp_addr_max_q[3]) ||
                            (unimp_addr_q[num_val]>=csr_imp_addr_min_q[4] && unimp_addr_q[num_val] < csr_imp_addr_max_q[4]) ||
                            (unimp_addr_q[num_val]>=csr_imp_addr_min_q[5] && unimp_addr_q[num_val] < csr_imp_addr_max_q[5]) ||
                            (unimp_addr_q[num_val]>=csr_imp_addr_min_q[6] && unimp_addr_q[num_val] < csr_imp_addr_max_q[6]) ||
                            (unimp_addr_q[num_val]>=csr_imp_addr_min_q[7] && unimp_addr_q[num_val] < csr_imp_addr_max_q[7]) 
                           ) && fidx==4) begin
                           `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step4:: 4_Write skip unimplemented space in CSR.%0s select num_val=%0d from %0d: unimp_addr=0x%0x, address inside fidx=%0d freelist range", file_name, num_val, unimp_addr_q.size(), unimp_addr_q[num_val], fidx),OVM_MEDIUM)
                            unimp_addr_q.delete(num_val);
                        end else begin
                            sel_unimp_addr_q.push_back(unimp_addr_q[num_val]);
                           `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step4:: 4_Write to unimplemented space in CSR.%0s select num_val=%0d from %0d: unimp_addr=0x%0x", file_name, num_val, unimp_addr_q.size(), unimp_addr_q[num_val]),OVM_MEDIUM)
                            unimp_addr_q.delete(num_val);
                        end
                      end else begin
                         `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step4:: 4_Write skip unimplemented space in CSR.%0s select num_val=%0d from %0d: unimp_addr=0x%0x, not in range of %0s", file_name, num_val, unimp_addr_q.size(), unimp_addr_q[num_val], file_name),OVM_MEDIUM)
                          unimp_addr_q.delete(num_val);
                      end
                   end
                end else begin
                   for(int k=0; k<unimp_addr_q.size(); k++) begin
                      sel_unimp_addr_q.push_back(unimp_addr_q[num_val]);
                   end
                end
             end//--sample
            `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step4:: 5_Access to unimplemented space in CSR.%0s sel_unimp_addr_q.size=%0d", file_name, sel_unimp_addr_q.size()),OVM_LOW)
             unimp_addr_q.delete();


             //-------------------------------
             //--Step5: Read from unimp address in CSR space
             //-------------------------------
             if(cfg.has_csr_attr==1) begin
                `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step4:: 5_Read to unimplemented space in CSR.%0s sel_unimp_addr_q.size=%0d", file_name, sel_unimp_addr_q.size()),OVM_LOW)
                foreach(sel_unimp_addr_q[i]) begin
                   do_iosf_memrd(cfg.csr_base_addr+sel_unimp_addr_q[i], 32'h0); 
                end
             end

             //--------------------
            `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step4:: 6_Write to unimplemented space in CSR.%0s sel_unimp_addr_q.size=%0d", file_name, sel_unimp_addr_q.size()),OVM_LOW)
             foreach(sel_unimp_addr_q[i]) begin
                do_iosf_memwr(is_vf, fidx, cfg.csr_base_addr+sel_unimp_addr_q[i], csr_unimp_wdata[fidx]); 
                csr_unimp_addr_q.push_back(cfg.csr_base_addr+sel_unimp_addr_q[i]);
             end
          end//if(csr_unimp_enable[fidx]==1
       end //--for(fidx)
    end//--if(cfg.num_csr_addr>0

    //-------------------------------
    //--Step5: Read from unimp address in VF bars
    //-------------------------------
   `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step5:: Read from unimplemented space in VF vf_base_addr=0x%0x vf_unimp_addr_q.size=%0d", cfg.vf_base_addr, vf_unimp_addr_q.size()),OVM_LOW)

    foreach(vf_unimp_addr_q[i]) begin
          do_iosf_memrd(vf_unimp_addr_q[i], 32'h0); 
    end
    vf_unimp_addr_q.delete();

    //-------------------------------
    //--Step6: Read from unimp address in PF bars
    //-------------------------------
   `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step6:: Read from unimplemented space in PF pf_base_addr=0x%0x pf_unimp_addr_q.size=%0d", cfg.pf_base_addr, pf_unimp_addr_q.size()),OVM_LOW)

    foreach(pf_unimp_addr_q[i]) begin
          do_iosf_memrd(pf_unimp_addr_q[i], 32'h0); 
    end
    pf_unimp_addr_q.delete();

    //-------------------------------
    //--Step7: Read from unimp address in CSR space
    //-------------------------------
   `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step7:: Read from unimplemented space in CSR csr_base_addr=0x%0x csr_unimp_addr_q.size=%0d", cfg.csr_base_addr, csr_unimp_addr_q.size()),OVM_LOW)

    foreach(csr_unimp_addr_q[i]) begin
          do_iosf_memrd(csr_unimp_addr_q[i], 32'h0); 
    end
    csr_unimp_addr_q.delete();

    //-------------------------------
    //--Step8: Program PF func and VF func by using cft-file
    //-------------------------------
   `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_Step8:: Read PF/VF func and hqm_msix_mem registers by cft file %0s", cfg.file_mode_plusarg2),OVM_LOW)
    i_file_mode_seq2 = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq2");
    i_file_mode_seq2.set_cfg(cfg.file_mode_plusarg2, 1'b0);
    i_file_mode_seq2.start(get_sequencer());
  endtask



//-----------------------------------------------------------
//-- collect_unimp_addresses(
//-----------------------------------------------------------
  virtual function bit collect_unimp_addresses(string file_name, int num_rand_addr, ref sla_ral_addr_t addr_q[$], ref int reg_width_q[$]);

     if(hqm_ral.gen_unimp_addresses(file_name, num_rand_addr, addr_q, reg_width_q) == 0) begin
        reg_cases = $psprintf("collect_unimp_addresses:: %s Unimplemented Address Test List - %0d addresses\n", file_name, addr_q.size());

        foreach (addr_q[i]) begin
          reg_cases = {reg_cases,$psprintf("  0x%08x REG_WIDTH=%0d\n",addr_q[i],reg_width_q[i])};
        end
       `ovm_info(get_full_name(),reg_cases,OVM_MEDIUM)
     end
  endfunction:collect_unimp_addresses
  
//-----------------------------------------------------------
//-----------------------------------------------------------
//-- select_unimp_addresses(
// num_unimp_addr; //--control the unimp walk through addr num; when >0 : use walk_through method; when ==0: use upper/lower sample method
// unimp_addr_incr_min;
// unimp_addr_incr_max; 
//    vf_unimp_addr_min_q
// unimp_vf0_addr_min   ==  32'h00004004; //-- 
// unimp_vf1_addr_min   ==  32'h04004004; //-- 
// unimp_vf2_addr_min   ==  32'h08004004; //-- 
// unimp_vf3_addr_min   ==  32'h0c004004; //-- 
// unimp_vf4_addr_min   ==  32'h10004004; //-- 
// unimp_vf5_addr_min   ==  32'h14004004; //-- 
// unimp_vf6_addr_min   ==  32'h18004004; //-- 
// unimp_vf7_addr_min   ==  32'h1c004004; //-- 
// unimp_vf8_addr_min   ==  32'h20004004; //-- 
// unimp_vf9_addr_min   ==  32'h24004004; //-- 
// unimp_vf10_addr_min  ==  32'h28004004; //-- 
// unimp_vf11_addr_min  ==  32'h2c004004; //-- 
// unimp_vf12_addr_min  ==  32'h30004004; //-- 
// unimp_vf13_addr_min  ==  32'h34004004; //-- 
// unimp_vf14_addr_min  ==  32'h38004004; //-- 
// unimp_vf15_addr_min  ==  32'h3c004004; //-- 
//    pf_unimp_addr_min_q
// unimp_pf_gap0_addr_min == 32'h00100000; //-- gap between hqm_func_pf_per_vf(0x000f_ffff) and hqm_msix_mem(0x0100_0000)
// unimp_pf_gap1_addr_min == 32'h01000410; //-- gap between hqm_msix_mem (0x0100_00410) and DIR PP (0x0200_0000)
// unimp_pf_gap2_addr_min == 32'h02000000; //-- DIR PP (0x0200_0000)
// unimp_pf_gap3_addr_min == 32'h02100000; //-- LDB PP (0x0210_0000)
//-----------------------------------------------------------
  virtual function bit select_unimp_addresses(int is_vf, int baridx, int num_unimp_addr, bit [31:0] unimp_addr_stoffset,  int unimp_addr_incr_min, int unimp_addr_incr_max, ref sla_ral_addr_t addr_q[$], ref sla_ral_addr_t sel_addr_q[$]);
      int skip;
      int pick_idx, pick_num;
      int unimp_addr_incr;
      sla_ral_addr_t addr_tmp, addr_tmp0, addr_tmp1, addr_tmp_min, addr_tmp_max;
      int idx_l[$];

      
      skip=0;

      sel_addr_q.delete();

      `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_0:: is_vf=%0d, bar=%0d, addr_q.size=%0d start", is_vf, baridx, addr_q.size()), OVM_MEDIUM)
      //-------------------------------------------------------------
      //-- skip unimp address can't access from VP/PF 
      //-------------------------------------------------------------
      foreach(addr_q[i]) begin
         if(is_vf==1) begin
               if(addr_q[i][12:0] == vf_skip_addroffset_q[0] || addr_q[i][12:0] == vf_skip_addroffset_q[1]) begin 
                  `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses:: is_vf=%0d, bar=%0d, skip addr=0x%0x", is_vf, baridx, addr_q[i]), OVM_MEDIUM)
               end else begin
                   sel_addr_q.push_back(addr_q[i]);   
                  `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses:: is_vf=%0d, bar=%0d, select addr=0x%0x sel_addr_q.size=%0d", is_vf, baridx, addr_q[i], sel_addr_q.size()), OVM_MEDIUM)
               end
         end else if(is_vf==0) begin
               if(addr_q[i][13:0] == pf_skip_addroffset_q[0] || addr_q[i][14:0] == pf_skip_addroffset_q[1]) begin 
                  `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses:: is_vf=%0d, bar=%0d, skip addr=0x%0x", is_vf, baridx, addr_q[i]), OVM_MEDIUM)
               end else begin
                   sel_addr_q.push_back(addr_q[i]);   
                  `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses:: is_vf=%0d, bar=%0d, select addr=0x%0x sel_addr_q.size=%0d", is_vf, baridx, addr_q[i], sel_addr_q.size()), OVM_MEDIUM)
               end
         end
      end
      `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_1:: is_vf=%0d, bar=%0d, sel_addr_q.size=%0d done", is_vf,  baridx, sel_addr_q.size()), OVM_MEDIUM)

      //-------------------------------------------------------------
      //-- pick up unimp address from VF/PF space
      //-------------------------------------------------------------
      if(num_unimp_addr == 0) begin
         //--------------------------------------------------------------------
         //-- sample unimp space       
         //--------------------------------------------------------------------
	 //-- select addr lower bits from vf_pick_addroffset_q pf_pick_addroffset_q
	 //-- select addr upper bits from the following range
	 //-- pf_unimp_addr_max_q pf_unimp_addr_min_q
	 //-- vf_unimp_addr_max_q vf_unimp_addr_min_q
         //--------------------------------------------------------------------
	 if(is_vf==1) begin
            if(vf_pick_addroffset_q.size()>0) begin
        	pick_num = vf_pick_addroffset_q.size();             
        	for(int i=0; i<pick_num; i++) begin
                    //`ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2:: is_vf=%0d, bar=%0d, vf_pick_addroffset_q[%0d]=0x%0x", is_vf, baridx, i, vf_pick_addroffset_q[i]), OVM_MEDIUM)
                    if( vf_pick_addroffset_q[i][15:0] >= 16'h1000) begin
                       addr_tmp = $urandom_range(vf_unimp_addr_max_q[baridx], vf_unimp_addr_min_q[baridx]);  
                       addr_tmp0=0;
                       addr_tmp0[14:0] = vf_pick_addroffset_q[i][14:0];
                       addr_tmp0[31:15]= addr_tmp[31:15];                 
                      //`ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2:: is_vf=%0d, bar=%0d, vf_pick_addroffset_q[%0d]=0x%0x, pick up addr=0x%0x from (vf_unimp_addr_min_q[%0d]=0x%0x :: vf_unimp_addr_max_q[%0d]=0x%0x)", is_vf, baridx, i, vf_pick_addroffset_q[i], addr_tmp0, baridx, vf_unimp_addr_min_q[baridx], baridx, vf_unimp_addr_max_q[baridx]), OVM_MEDIUM)

                       if(addr_tmp0 >= vf_unimp_addr_min_q[baridx] && addr_tmp0 < vf_unimp_addr_max_q[baridx]) begin
                	  addr_tmp0[1:0]=0;
                	  sel_addr_q.push_back(addr_tmp0);   
                	  `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick:: is_vf=%0d, bar=%0d, pick addr=0x%0x sel_addr_q.size=%0d", is_vf, baridx, addr_tmp0, sel_addr_q.size()), OVM_MEDIUM)
                       end
                    end else begin
                       //--unimp space bar0 (0x00000000 : 0x00000fff)
                       //--unimp space bar1 (0x04000000 : 0x04000fff)
                       //--unimp space bar2 (0x08000000 : 0x08000fff)
                       addr_tmp = $urandom_range(vf_unimp_addr_l_max_q[baridx], vf_unimp_addr_l_min_q[baridx]);  
                       addr_tmp0=0;
                       addr_tmp0[14:0] = vf_pick_addroffset_q[i];
                       addr_tmp0[31:15]= addr_tmp[31:15];                 
                       //`ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2:: is_vf=%0d, bar=%0d, vf_pick_addroffset_q[%0d]=0x%0x, pick up addr=0x%0x from (vf_unimp_addr_l_min_q[%0d]=0x%0x :: vf_unimp_addr_l_max_q[%0d]=0x%0x)", is_vf, baridx, i, vf_pick_addroffset_q[i], addr_tmp0, baridx, vf_unimp_addr_l_min_q[baridx], baridx, vf_unimp_addr_l_max_q[baridx]), OVM_MEDIUM)

                       if(addr_tmp0 >= vf_unimp_addr_l_min_q[baridx] && addr_tmp0 < vf_unimp_addr_l_max_q[baridx]) begin
                	  addr_tmp0[1:0]=0;
                	  sel_addr_q.push_back(addr_tmp0);   
                	  `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick:: is_vf=%0d, bar=%0d, pick addr=0x%0x sel_addr_q.size=%0d", is_vf, baridx, addr_tmp0, sel_addr_q.size()), OVM_MEDIUM)
                       end
                    end
        	end//for i
            end//
	 end else if(is_vf==0) begin
            //-- PF
            if(pf_pick_addroffset_q.size()>0) begin
        	pick_num = pf_pick_addroffset_q.size();             
        	for(int i=0; i<pick_num; i++) begin
                    //`ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2:: is_vf=%0d, bar=%0d, pf_pick_addroffset_q[%0d]=0x%0x", is_vf, baridx, i, pf_pick_addroffset_q[i]), OVM_MEDIUM)
                    if( pf_pick_addroffset_q[i][15:0] >= 16'h1000) begin
                       //-- including DIRPP/LDBPP space:  pick_idx = $urandom_range(19,16);
                       pick_idx = $urandom_range(19,16);
                       addr_tmp = $urandom_range(pf_unimp_addr_max_q[pick_idx], pf_unimp_addr_min_q[pick_idx]);  
                       addr_tmp0=0;
                       addr_tmp0[14:0] = pf_pick_addroffset_q[i];
                       addr_tmp0[31:15]= addr_tmp[31:15];                 
                      //`ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2:: is_vf=%0d, bar=%0d, pf_pick_addroffset_q[%0d]=0x%0x, pick up addr=0x%0x from (pf_unimp_addr_min_q[%0d]=0x%0x :: pf_unimp_addr_max_q[%0d]=0x%0x)", is_vf, pick_idx, i, pf_pick_addroffset_q[i], addr_tmp0, pick_idx, pf_unimp_addr_min_q[pick_idx], pick_idx, pf_unimp_addr_max_q[pick_idx]), OVM_MEDIUM)

                       if(addr_tmp0 >= pf_unimp_addr_min_q[pick_idx] && addr_tmp0 < pf_unimp_addr_max_q[pick_idx]) begin
                	  addr_tmp0[1:0]=0;
                	  sel_addr_q.push_back(addr_tmp0);   
                	  `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick:: is_vf=%0d, bar=%0d, pick addr=0x%0x sel_addr_q.size=%0d", is_vf, baridx, addr_tmp0, sel_addr_q.size()), OVM_MEDIUM)
                       end
                    end else begin
                       addr_tmp = $urandom_range(pf_unimp_addr_max_q[baridx], pf_unimp_addr_min_q[baridx]);  
                       addr_tmp0=0;
                       addr_tmp0[14:0] = pf_pick_addroffset_q[i];
                       addr_tmp0[31:15]= addr_tmp[31:15];                 
                      //`ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2:: is_vf=%0d, bar=%0d, pf_pick_addroffset_q[%0d]=0x%0x, pick up addr=0x%0x from (pf_unimp_addr_min_q[%0d]=0x%0x :: pf_unimp_addr_max_q[%0d]=0x%0x)", is_vf, baridx, i, pf_pick_addroffset_q[i], addr_tmp0, baridx, pf_unimp_addr_min_q[baridx], baridx, pf_unimp_addr_max_q[baridx]), OVM_MEDIUM)

                       if(addr_tmp0 >= pf_unimp_addr_min_q[baridx] && addr_tmp0 < pf_unimp_addr_max_q[baridx]) begin
                	  addr_tmp0[1:0]=0;
                	  sel_addr_q.push_back(addr_tmp0);   
                	 `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick:: is_vf=%0d, bar=%0d, pick addr=0x%0x sel_addr_q.size=%0d", is_vf, baridx, addr_tmp0, sel_addr_q.size()), OVM_MEDIUM)
                       end
                    end
        	end
            end//--PF
	 end else if(is_vf==2) begin

            //--CSR hqm_system_csr space: pickup problematic addresses
            if(csr_system_pick_addroffset_q.size()>0 && baridx==1) begin
        	pick_num = csr_system_pick_addroffset_q.size();             
        	for(int i=0; i<pick_num; i++) begin
                    `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2:: is_vf=%0d, id=%0d, csr_system_pick_addroffset_q[%0d]=0x%0x", is_vf, baridx, i, pf_pick_addroffset_q[i]), OVM_MEDIUM)
                       //addr_tmp = 32'h10800000; //$urandom_range(csr_unimp_addr_max_q[baridx], csr_unimp_addr_min_q[baridx]);  
                       addr_tmp = 32'h11400000; 

                       addr_tmp0=0;
                       addr_tmp0[15:0] = csr_system_pick_addroffset_q[i];
                       addr_tmp0[31:16]= addr_tmp[31:16];                 
                     `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2:: is_vf=%0d, id=%0d, csr_system_pick_addroffset_q[%0d]=0x%0x, pick up addr=0x%0x for hqm_system_csr", is_vf, baridx, i, pf_pick_addroffset_q[i], addr_tmp0), OVM_MEDIUM)

                       if(addr_tmp0 >= csr_unimp_addr_min_q[baridx] && addr_tmp0 < csr_unimp_addr_max_q[baridx]) begin
                	  addr_tmp0[1:0]=0;
                	  sel_addr_q.push_back(addr_tmp0);   
                	 `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick:: is_vf=%0d, id=%0d, pick addr=0x%0x sel_addr_q.size=%0d", is_vf, baridx, addr_tmp0, sel_addr_q.size()), OVM_MEDIUM)
                       end
        	end//--for(i
            end //--CSR
	 end//--if(is_vf
	 `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick_completed:: is_vf=%0d, bar=%0d, sel_addr_q.size=%0d done", is_vf,  baridx, sel_addr_q.size()), OVM_MEDIUM)

      end else begin
         //--------------------------------------------------------------------
         //--walk_through unimp space   unimp_addr_stoffset * cfg.unimp_addr_wt_step
         //--------------------------------------------------------------------
	 //num_unimp_addr, bit[31:0] unimp_addr_stoffset, int unimp_addr_incr_min, int unimp_addr_incr_max
	 
	 if(is_vf==1) begin
            addr_tmp0=vf_unimp_addr_min_q[baridx] + unimp_addr_stoffset * cfg.unimp_addr_wt_step;	 
	    unimp_addr_incr=0;

            for(int i=0; i<num_unimp_addr; i++) begin
                addr_tmp0=addr_tmp0+unimp_addr_incr;	

                if(addr_tmp0 >= vf_unimp_addr_min_q[baridx] && addr_tmp0 < vf_unimp_addr_max_q[baridx]) begin
                   addr_tmp0[1:0]=0;
                   sel_addr_q.push_back(addr_tmp0);   
                   `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick_vf:: is_vf=%0d, bar=%0d, unimp_addr_stoffset=0x%0x unimp_addr_wt_step=%0d, incr=%0d;  pick addr=0x%0x; i=%0d in num_unimp_addr=%0d; sel_addr_q.size=%0d", is_vf, baridx, unimp_addr_stoffset, cfg.unimp_addr_wt_step, unimp_addr_incr, addr_tmp0, i, num_unimp_addr, sel_addr_q.size()), OVM_MEDIUM)
                end			 

                unimp_addr_incr = $urandom_range(unimp_addr_incr_min, unimp_addr_incr_max); 

            end//--for	    	 
         end else if(is_vf==0) begin
            if(baridx%4==0) pick_idx = 16;   
            else if(baridx%4==1) pick_idx = 17;
            else if(baridx%4==2) pick_idx = 18;
            else                 pick_idx = 19;

	    addr_tmp0=pf_unimp_addr_min_q[pick_idx] + unimp_addr_stoffset * cfg.unimp_addr_wt_step;	 
	    unimp_addr_incr=0;
	    
            for(int i=0; i<num_unimp_addr; i++) begin
                addr_tmp0=addr_tmp0+unimp_addr_incr;	

                if(addr_tmp0 >= pf_unimp_addr_min_q[pick_idx] && addr_tmp0 < pf_unimp_addr_max_q[pick_idx]) begin
                   addr_tmp0[1:0]=0;
                   sel_addr_q.push_back(addr_tmp0);   
                   `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick_pf_func:: is_vf=%0d, pick_idx=%0d, unimp_addr_stoffset=0x%0x unimp_addr_wt_step=%0d, incr=%0d;  pick addr=0x%0x; i=%0d in num_unimp_addr=%0d; sel_addr_q.size=%0d", is_vf, pick_idx, unimp_addr_stoffset, cfg.unimp_addr_wt_step, unimp_addr_incr, addr_tmp0, i, num_unimp_addr, sel_addr_q.size()), OVM_MEDIUM)
                end			 

                unimp_addr_incr = $urandom_range(unimp_addr_incr_min, unimp_addr_incr_max); 
            end//--for	 
	 end else if(is_vf==2) begin
            //--CSR walk-through
            addr_tmp_min=csr_unimp_addr_min_q[baridx] + unimp_addr_stoffset * cfg.unimp_addr_wt_step;	 
            addr_tmp_max=csr_unimp_addr_min_q[baridx] + unimp_addr_stoffset * (cfg.unimp_addr_wt_step+1);	 

            for(int i=0; i<num_unimp_addr; i++) begin
                idx_l = addr_q.find_index with ( (item>=addr_tmp_min) && (item < addr_tmp_max) );
               `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick_csr:: is_vf=%0d, bar=%0d, unimp_addr_stoffset=0x%0x unimp_addr_wt_step=%0d, addr_tmp_min=0x%0x, addr_tmp_max=0x%0x; idx_l.size=%0d; i=%0d in num_unimp_addr=%0d; sel_addr_q.size=%0d, addr_q.size=%0d", is_vf, baridx, unimp_addr_stoffset, cfg.unimp_addr_wt_step, addr_tmp_min, addr_tmp_max, idx_l.size(), i, num_unimp_addr, sel_addr_q.size(), addr_q.size()), OVM_MEDIUM)

                if(idx_l.size()>0) begin
                   addr_tmp0 = addr_q[idx_l[0]]; 

                   if(addr_tmp0 >= csr_unimp_addr_min_q[baridx] && addr_tmp0 < csr_unimp_addr_max_q[baridx]) begin
                      if((addr_tmp0 >= 32'h4e010000 && addr_tmp0 < 32'h4e011fff  ) ||
                         (addr_tmp0 >= 32'h4e020000 && addr_tmp0 < 32'h4e021fff  ) ||
                         (addr_tmp0 >= 32'h4e030000 && addr_tmp0 < 32'h4e031fff  ) ||
                         (addr_tmp0 >= 32'h4e040000 && addr_tmp0 < 32'h4e041fff  ) ||
                         (addr_tmp0 >= 32'h4e050000 && addr_tmp0 < 32'h4e051fff  ) ||
                         (addr_tmp0 >= 32'h4e060000 && addr_tmp0 < 32'h4e061fff  ) ||
                         (addr_tmp0 >= 32'h4e070000 && addr_tmp0 < 32'h4e071fff  ) ||
                         (addr_tmp0 >= 32'h4e080000 && addr_tmp0 < 32'h4e081fff  ) ||
                         (addr_tmp0 >= 32'h4e090000 && addr_tmp0 < 32'h4e091fff  ) ||
                         (addr_tmp0 >= 32'h4e0a0000 && addr_tmp0 < 32'h4e0a1fff  )   
                        ) begin
                          //-- these are CHP register space
                          //-- CHP P0h:4E010000h 0000_0000h CFG_HIST_LIST_0 Cfg Hist List0
                          //-- CHP P0h:4E020000h 0000_0000h CFG_HIST_LIST_1 Cfg Hist List1
                          //-- CHP P0h:4E030000h 0000_0000h CFG_FREELIST_0 Cfg Freelist 0
                          //-- CHP P0h:4E040000h 0000_0000h CFG_FREELIST_1 Cfg Freelist 1
                          //-- CHP P0h:4E050000h 0000_0000h CFG_FREELIST_2 Cfg Freelist 2
                          //-- CHP P0h:4E060000h 0000_0000h CFG_FREELIST_3 Cfg Freelist 3
                          //-- CHP P0h:4E070000h 0000_0000h CFG_FREELIST_4 Cfg Freelist 4
                          //-- CHP P0h:4E080000h 0000_0000h CFG_FREELIST_5 Cfg Freelist 5
                          //-- CHP P0h:4E090000h 0000_0000h CFG_FREELIST_6 Cfg Freelist 6
                          //-- CHP P0h:4E0A0000h 0000_0000h CFG_FREELIST_7 Cfg Freelist 7
                         `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick_csr_skipaddr:: is_vf=%0d, bar=%0d, unimp_addr_stoffset=0x%0x unimp_addr_wt_step=%0d, incr=%0d;  pick addr=0x%0x; i=%0d in num_unimp_addr=%0d; curr sel_addr_q.size=%0d, addr_q.size=%0d", is_vf, baridx, unimp_addr_stoffset, cfg.unimp_addr_wt_step, unimp_addr_incr, addr_tmp0, i, num_unimp_addr, sel_addr_q.size(), addr_q.size()), OVM_MEDIUM)
                      end else begin
                         addr_tmp0[1:0]=0;
                         sel_addr_q.push_back(addr_tmp0);   
                         addr_q.delete(idx_l[0]);
                         `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick_csr_pickaddr:: is_vf=%0d, bar=%0d, unimp_addr_stoffset=0x%0x unimp_addr_wt_step=%0d, incr=%0d;  pick addr=0x%0x; i=%0d in num_unimp_addr=%0d; curr sel_addr_q.size=%0d, addr_q.size=%0d", is_vf, baridx, unimp_addr_stoffset, cfg.unimp_addr_wt_step, unimp_addr_incr, addr_tmp0, i, num_unimp_addr, sel_addr_q.size(), addr_q.size()), OVM_MEDIUM)
                      end
                   end		 
                end else begin
                   `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick_csr_breakloop:: is_vf=%0d, bar=%0d, unimp_addr_stoffset=0x%0x unimp_addr_wt_step=%0d; idx_l.size=%0d; i=%0d in num_unimp_addr=%0d; curr sel_addr_q.size=%0d, addr_q.size=%0d", is_vf, baridx, unimp_addr_stoffset, cfg.unimp_addr_wt_step, idx_l.size(),  i, num_unimp_addr, sel_addr_q.size(), addr_q.size()), OVM_MEDIUM)
                   break;
                end
            end//--for	    	 
         end 
	 `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_select_unimp_addresses_2pick_completed:: is_vf=%0d, bar=%0d, sel_addr_q.size=%0d done", is_vf,  baridx, sel_addr_q.size()), OVM_MEDIUM)
      end//if(num_unimp_addr == 0
  endfunction:select_unimp_addresses

//-----------------------------------------------------------
//-- do_iosf_memwr(
//-- Don't write to whole HCW space: upper 32MB in each VF BAR and PF::  
//--              cfg.hcw_space0_addr_min (0x0200_0000) cfg.hcw_space0_addr_max (0x020f_ffff)
//                cfg.hcw_space1_addr_min (0x0210_0000) cfg.hcw_space1_addr_max (0x03ff_ffff)
//-- 
//vf_unimp_addr_min_q[0] ~ vf_unimp_addr_min_q[15]
//cfg.vf_base_addr
//cfg.pf_base_addr
//-----------------------------------------------------------
  virtual task do_iosf_memwr(int is_vf, int baridx, sla_ral_addr_t iosf_addr_val, bit[31:0] iosf_data_val);
      int is_write;
      bit[31:0] addr_offset0, addr_offset1;
      bit[31:0] iosf_data_l[];

      iosf_data_l = new[4];
      foreach(iosf_data_l[i]) iosf_data_l[i]=iosf_data_val+i;

      is_write=0;
      addr_offset0=0;

      if(is_vf==1) begin
           addr_offset1[31:16] = vf_unimp_addr_min_q[baridx][31:16];
           addr_offset1[15:0]  = 0;
           addr_offset0 = iosf_addr_val - cfg.vf_base_addr - addr_offset1; //vf_unimp_addr_min_q[baridx];
      end else if(is_vf==0) begin
           addr_offset0 = iosf_addr_val - cfg.pf_base_addr;
      end

      `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_do_iosf_memwr:: is_vf=%0d, baridx=%0d, iosf_addr=0x%0x (addr_offset=0x%0x) iosf_wdata=0x%0x", is_vf, baridx, iosf_addr_val, addr_offset0, iosf_data_val), OVM_MEDIUM)

      if((addr_offset0>=cfg.hcw_space0_addr_min && addr_offset0<cfg.hcw_space0_addr_max) || 
         (addr_offset0>=cfg.hcw_space1_addr_min && addr_offset0<cfg.hcw_space1_addr_max)) begin
         //-- Skip writing to HCW space
         if(cfg.has_pf_hcw_wr==1) is_write=2;
         else                     is_write=0; //--
         `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_do_iosf_memwr_skip:: is_vf=%0d, baridx=%0d, iosf_addr=0x%0x (addr_offset=0x%0x) iosf_wdata=0x%0x, is_write=%0d", is_vf, baridx, iosf_addr_val, addr_offset0, iosf_data_val, is_write), OVM_MEDIUM)
      end else begin
         is_write=1;
      end  

      if(is_write==1) begin
         `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_do_iosf_memwr_MWr64:: is_vf=%0d, baridx=%0d, iosf_addr=0x%0x iosf_wdata=0x%0x", is_vf, baridx, iosf_addr_val, iosf_data_val), OVM_MEDIUM)
         `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == iosf_addr_val; iosf_data.size() == 1; iosf_data[0] == iosf_data_val[31:0];})
      end else if(is_write==2) begin
         //-- this is trying to write to HCW space with 16B, but given PPs are not programmed, 
         //-- [ovm_test_top.i_hqm_tb_env.hqm_agent_env_handle.i_hqm_iosf_prim_mon] Address(0x102099380) is an unsupported transaction on input side to HQM
          iosf_addr_val[3:0]=0;  
         `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_do_iosf_memwr_MWr64_16B:: is_vf=%0d, baridx=%0d, iosf_addr=0x%0x iosf_data.size=%0d, iosf_wdata=0x%0x", is_vf, baridx, iosf_addr_val, iosf_data_l.size(), iosf_data_val), OVM_MEDIUM)
         `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == iosf_addr_val; iosf_data.size() == 4; foreach(iosf_data_l[i]) {iosf_data[i]==iosf_data_l[i]};})

      end
  endtask:do_iosf_memwr



//-----------------------------------------------------------
//-- do_iosf_memrd(
//-----------------------------------------------------------
  virtual task do_iosf_memrd(sla_ral_addr_t iosf_addr_val, bit[31:0] iosf_rdata_exp);
       bit [31:0] iosf_data_val;
      `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == iosf_addr_val;})
       iosf_data_val = mem_read_seq.iosf_data;

       if(iosf_data_val != iosf_rdata_exp)
        `ovm_error("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_do_iosf_memrd:: iosf_addr=0x%0x iosf_rdata=0x%0x iosf_rdata_exp=0x%0x mismatched", iosf_addr_val, iosf_data_val, iosf_rdata_exp))
       else
        `ovm_info("HQM_IOSF_PFVF_ACC",$psprintf("HQM_PFVF_SEQ_do_iosf_memrd_MRd64:: iosf_addr=0x%0x iosf_rdata=0x%0x iosf_rdata_exp=0x%0x", iosf_addr_val, iosf_data_val, iosf_rdata_exp), OVM_MEDIUM)
  endtask:do_iosf_memrd

endclass : hqm_pfvf_space_acc_seq
