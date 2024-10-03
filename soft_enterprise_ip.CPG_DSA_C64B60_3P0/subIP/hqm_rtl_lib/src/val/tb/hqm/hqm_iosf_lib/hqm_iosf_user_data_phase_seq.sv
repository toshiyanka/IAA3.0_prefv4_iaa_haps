// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
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
// File   : hqm_iosf_user_data_phase_seq.sv
// Author : rsshekha
// Description :
//
//   prochot assertion deassertion seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`ifndef HQM_IOSF_USER_DATA_SEQ_SV
`define HQM_IOSF_USER_DATA_SEQ_SV

class hqm_iosf_user_data_phase_seq extends sla_sequence_base;
  string iosf_seq;
  `ovm_sequence_utils(hqm_iosf_user_data_phase_seq, sla_sequencer)
  hqm_iosf_sb_mem_access_wo_bar_cfg_seq                     sb_mem_access_wo_bar_cfg_seq;
  hqm_iosf_sb_intermediate_reset_prep_between_np_seq        sb_intermediate_reset_prep_between_np_seq;
  hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq                   sb_b2b_cfg_wr_with_bd_read_seq;
  hqm_iosf_sb_credit_exhaust_seq                            sb_credit_exhaust_seq;
  hqm_iosf_smoke_seq                                        iosf_smoke_seq;
  hqm_iosf_credit_check_with_pf_flr_seq                     credit_check_with_pf_flr_seq;
  hqm_iosf_sb_interleaving_flit_seq                         sb_interleaving_flit_seq;
  hqm_iosf_random_ecrc_seq                                  random_ecrc_seq;
  hqm_iosf_sb_test_seq                                      sb_test_seq;
  back2back_cfgrd_seq                                       b2b_cfgrd_seq;
  back2back_memrd_seq                                       b2b_memrd_seq;
  back2back_memrd_seq1                                      b2b_memrd_seq1;
  back2back_cfgwr_seq                                       b2b_cfgwr_seq;
  back2back_posted_seq                                      b2b_posted_seq;
  back2back_posted_seq1                                     b2b_posted_seq1;
  back2back_posted_seq2                                     b2b_posted_seq2;
  back2back_posted_wrd_seq                                  b2b_posted_wrd_seq;
  cfg_genric_seq                                            cfg_generic_seq;
  cfg_genric_parallel_seq                                   cfg_generic_parallel_seq;
  np_np_seq                                                 cfgrd_memrd_seq;
  p_np_seq1                                                 memwr_cfgwr_seq;
  p_np_seq                                                  memwr_cfgrd_seq;
  mem_generic_seq1                                          prim_mem_generic_seq;
  back2back_sb_cfgwr_seq                                    b2b_sb_cfgwr_seq;
  back2back_sb_cfgrd_seq                                    b2b_sb_cfgrd_seq;
  back2back_sb_memwr_seq                                    b2b_sb_memwr_seq;
  back2back_sb_memrd_seq                                    b2b_sb_memrd_seq;
  hqm_iosf_sb_unsupported_wr_seq                            sb_unsupported_wr_seq;
  hqm_iosf_sb_unsupported_wr_seq1                           sb_unsupported_wr_seq1;
  hqm_iosf_sb_unsupported_rd_seq                            sb_unsupported_rd_seq;
  hqm_iosf_sb_boot_seq                                      sb_boot_seq;
  hqm_iosf_sb_pm_seq                                        sb_pm_seq;
  back2back_sb_unsupport_sai_wr_seq                         sb_unsupport_sai_wr_seq;
  back2back_sb_unsupport_sai_seq                            sb_unsupport_sai_rd_seq;
  hqm_iosf_sb_global_opcode_seq                             sb_global_opcode_seq;
  hqm_iosf_sb_epspec_opcode_seq                             sb_epspec_opcode_seq;
  hqm_iosf_sb_memwr_np_seq                                  sb_np_memwr_seq;
  hqm_iosf_sb_zero_sbe_seq                                  zero_sbe_seq;
  hqm_iosf_sb_cfgwr_rd_seq                                  sb_cfgwr_rd_seq;
  hqm_iosf_sb_cpl_seq                                       sb_cpl_seq;
  hqm_iosf_sb_cplD_seq                                      sb_cplD_seq;    
  hqm_iosf_sb_unsupport_memwr_seq                           sb_unsupport_memwr_seq;
  //back2back_sb_memwr32_seq                                sb_b2b_memwr32_seq;    
  hqm_iosf_sb_cfgwr_fid_seq                                 sb_cfgwr_fid_seq;
  hqm_iosf_sb_cfgrd_fid_seq                                 sb_cfgrd_fid_seq;
  hqm_iosf_sb_memrd_fid_seq                                 sb_memrd_fid_seq;
  hqm_iosf_sb_fbe_cfgrd_seq                                 sb_cfgrd_fbe_seq;
  back2back_sb_fbe_cfgwr_seq                                sb_cfgwr_fbe_seq;
  hqm_iosf_sb_fbe_memrd_seq                                 sb_memrd_fbe_seq;
  hqm_iosf_sb_fbe_memwr_seq                                 sb_memwr_fbe_seq;
  hqm_iosf_sb_sbe_cfgrd_seq                                 sb_cfgrd_sbe_seq;
  hqm_iosf_sb_sbe_cfgwr_seq                                 sb_cfgwr_sbe_seq;
  hqm_iosf_sb_sbe_memrd_seq                                 sb_memrd_sbe_seq;
  hqm_iosf_sb_sbe_memwr_seq                                 sb_memwr_sbe_seq;
  hqm_iosf_sb_sbe_memwr_np_seq                              sb_npmemwr_sbe_seq; 
  hqm_iosf_sb_fbe_memwr_np_seq                              sb_npmemwr_fbe_seq; 
  back2back_cfgrd_badDataparity_seq                         cfgrd_baddata_parity_seq;
  back2back_cfgwr_badDataparity_seq                         cfgwr_baddata_parity_seq;
  back2back_cfgwr_badtxn_seq                                cfgwr_badtxn_seq;
  back2back_posted_badDataparity_seq                        memwr_baddata_parity_seq;
  back2back_posted_badDataparity_seq1                       memwr_baddata_parity_seq1;
  back2back_memrd_badDataParity_seq                         memrd_baddata_parity_seq;
  back2back_posted_multierr_seq                             memwr_baddata_parity_qw_seq;
  back2back_cfgwr_badCmdparity_seq                          prim_cfgwr_badcmd_parity_seq;
  hqm_prim_parity_err_inj_parity_ctl_reg_chk_seq            parity_ctl_reg_chk_seq;
  back2back_cfgrd_badCmdparity_seq                          prim_cfgrd_badcmd_parity_seq;
  back2back_posted_badcmdparity_seq                         prim_memwr_badcmd_parity_seq;
  back2back_memrd_badCmdParity_seq                          prim_memrd_badcmd_parity_seq;
  hqm_iosf_sb_poison_memwr_seq                              sb_memwr_badparity_seq;
  hqm_iosf_sb_poison_memrd_seq                              sb_memrd_badparity_seq;
  hqm_iosf_sb_memwr_np_poison_seq                           sb_npmemwr_badparity_seq;
  hqm_iosf_sb_poison_cfgwr_seq                              sb_cfgwr_badparity_seq;
  hqm_iosf_sb_poison_cfgrd_seq                              sb_cfgrd_badparity_seq;        
  hqm_iosf_sb_unsupported_memwr_np_seq                      sb_unsupported_npmemwr_seq;
  hqm_iosf_sb_unsupported_memrd_seq                         sb_unsupported_memrd_seq;
  hqm_iosf_sb_memwr_np_mlf_seq                              sb_npmemwr_sbe_fbe_ff_seq;
  hqm_iosf_sb_memwr_mlf_seq                                 sb_memwr_sbe_fbe_ff_seq;
  hqm_iosf_cg_seq                                           cg_seq;
  hqm_iosf_crd_return_b2b_p_ur_seq                          crd_return_b2b_p_ur_seq;
  hqm_write_once_register_seq                               write_once_register_seq;

  hqm_tb_cfg_file_mode_seq                                  i_usr_file_mode_seq;

  function new(string name = "hqm_iosf_user_data_phase_seq");
    super.new(name);
  endfunction

  extern virtual task body();

  task wait_ns_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

endclass

task hqm_iosf_user_data_phase_seq::body();
   bit has_trf_on;

   has_trf_on=0;
   $value$plusargs("HQM_IOSF_USR_TRF=%d", has_trf_on);


   if (!$value$plusargs("HQM_IOSF_SEQ=%s",iosf_seq)) iosf_seq = "HQM_IOSF_SMOKE_SEQ";
   `ovm_info(get_full_name(),$sformatf(" Picked seq %s to run in user data phase", iosf_seq),OVM_LOW)
   case (iosf_seq)
       "HQM_IOSF_SB_TEST_SEQ":                                 `ovm_do(sb_test_seq)
       "HQM_IOSF_SB_MEM_ACCESS_WO_BAR_CFG_SEQ":                `ovm_do(sb_mem_access_wo_bar_cfg_seq)
       "HQM_IOSF_SB_INTERMEDIATE_RESET_PREP_BETWEEN_NP_SEQ":   `ovm_do(sb_intermediate_reset_prep_between_np_seq)
       "HQM_IOSF_SB_B2B_CFG_WR_WITH_BD_READ_SEQ":              `ovm_do(sb_b2b_cfg_wr_with_bd_read_seq)
       "HQM_IOSF_SB_CREDIT_EXHAUST_SEQ":                       `ovm_do(sb_credit_exhaust_seq)
       "HQM_IOSF_SMOKE_SEQ":                                   `ovm_do(iosf_smoke_seq) 
       "HQM_IOSF_CREDIT_CHECK_FLR_SEQ":                        `ovm_do(credit_check_with_pf_flr_seq) 
       "HQM_IOSF_SB_INTERLEAVING_SEQ":                         `ovm_do(sb_interleaving_flit_seq) 
       "HQM_IOSF_RANDOM_ECRC_SEQ":                             `ovm_do(random_ecrc_seq) 
       "HQM_IOSF_PRIM_BACK2BACK_CFGRD_SEQ":                    `ovm_do(b2b_cfgrd_seq)
       "HQM_IOSF_PRIM_BACK2BACK_CFGWR_SEQ":                    `ovm_do(b2b_cfgwr_seq)
       "HQM_IOSF_PRIM_BACK2BACK_MEMRD_SEQ":                    `ovm_do(b2b_memrd_seq)
       "HQM_IOSF_PRIM_BACK2BACK_MEMRD_SEQ1":                   `ovm_do(b2b_memrd_seq1)
       "HQM_IOSF_PRIM_BACK2BACK_POSTED_WRD_SEQ":               `ovm_do(b2b_posted_wrd_seq)
       "HQM_IOSF_PRIM_CFGRD_MEMRD":                            `ovm_do(cfgrd_memrd_seq)
       "HQM_IOSF_PRIM_MEMWR_CFGWR":                            `ovm_do(memwr_cfgwr_seq)
       "HQM_IOSF_PRIM_MEMWR_CFGRD":                            `ovm_do(memwr_cfgrd_seq)
       "HQM_IOSF_PRIM_MEM_GENERIC_SEQ":                        `ovm_do(prim_mem_generic_seq)
       "HQM_IOSF_PRIM_CFG_GENERIC_SEQ":                        `ovm_do(cfg_generic_seq)
       "HQM_IOSF_PRIM_CFG_GENERIC_PARALLEL_SEQ":               `ovm_do(cfg_generic_parallel_seq)
       "HQM_IOSF_PRIM_BACK2BACK_POSTED_SEQ":                   `ovm_do(b2b_posted_seq)
       //"HQM_IOSF_PRIM_BACK2BACK_POSTED_SEQ1":                `ovm_do(b2b_posted_seq1)
       "HQM_IOSF_PRIM_BACK2BACK_POSTED_SEQ2":                  `ovm_do(b2b_posted_seq2)
       "HQM_IOSF_SB_BACK2BACK_CFGWR_SEQ":                      `ovm_do(b2b_sb_cfgwr_seq)
       "HQM_IOSF_SB_BACK2BACK_CFGRD_SEQ":                      `ovm_do(b2b_sb_cfgrd_seq)
       "HQM_IOSF_SB_BACK2BACK_MEMWR_SEQ":                      `ovm_do(b2b_sb_memwr_seq)
       "HQM_IOSF_SB_BACK2BACK_MEMRD_SEQ":                      `ovm_do(b2b_sb_memrd_seq)
       "HQM_IOSF_SB_UNSUPPORTED_WR_SEQ":                       `ovm_do(sb_unsupported_wr_seq)
       "HQM_IOSF_SB_UNSUPPORTED_WR_SEQ1":                      `ovm_do(sb_unsupported_wr_seq1)
       "HQM_IOSF_SB_UNSUPPORTED_RD_SEQ":                       `ovm_do(sb_unsupported_rd_seq)
       "HQM_IOSF_SB_BOOT_SEQ":                                 `ovm_do(sb_boot_seq)
       "HQM_IOSF_SB_PM_SEQ":                                   `ovm_do(sb_pm_seq)
       "HQM_IOSF_SB_UNSUPPORT_SAI_WR_SEQ":                     `ovm_do(sb_unsupport_sai_wr_seq)
       "HQM_IOSF_SB_UNSUPPORT_SAI_RD_SEQ":                     `ovm_do(sb_unsupport_sai_rd_seq)
       "HQM_IOSF_SB_GLOBAL_OPCODE":                            `ovm_do(sb_global_opcode_seq)
       "HQM_IOSF_SB_EPSPEC_OPCODE":                            `ovm_do(sb_epspec_opcode_seq)
       "HQM_IOSF_SB_NP_MEMWR":                                 `ovm_do(sb_np_memwr_seq)
       "HQM_IOSF_ZERO_SBE":                                    `ovm_do(zero_sbe_seq)
       "HQM_IOSF_SB_CFGWR_RD":                                 `ovm_do(sb_cfgwr_rd_seq)
       "HQM_IOSF_SB_CPL_SEQ":                                  `ovm_do(sb_cpl_seq)
       "HQM_IOSF_SB_CPLD_SEQ":                                 `ovm_do(sb_cplD_seq)
       "HQM_IOSF_SB_UNSUPPORT_MEMWR":                          `ovm_do(sb_unsupport_memwr_seq) 
       //"HQM_IOSF_SB_B2B_MEMWR32_SEQ":                        `ovm_do(sb_b2b_memwr32_seq) 
       "HQM_IOSF_SB_CFGWR_FID_SEQ":                            `ovm_do(sb_cfgwr_fid_seq) 
       "HQM_IOSF_SB_CFGRD_FID_SEQ":                            `ovm_do(sb_cfgrd_fid_seq) 
       "HQM_IOSF_SB_MEMRD_FID_SEQ":                            `ovm_do(sb_memrd_fid_seq) 
       "HQM_IOSF_SB_CFGRD_FBE_SEQ":                            `ovm_do(sb_cfgrd_fbe_seq) 
       "HQM_IOSF_SB_CFGWR_FBE_SEQ":                            `ovm_do(sb_cfgwr_fbe_seq) 
       "HQM_IOSF_SB_MEMRD_FBE_SEQ":                            `ovm_do(sb_memrd_fbe_seq) 
       "HQM_IOSF_SB_MEMWR_FBE_SEQ":                            `ovm_do(sb_memwr_fbe_seq) 
       "HQM_IOSF_SB_CFGRD_SBE_SEQ":                            `ovm_do(sb_cfgrd_sbe_seq) 
       "HQM_IOSF_SB_CFGWR_SBE_SEQ":                            `ovm_do(sb_cfgwr_sbe_seq) 
       "HQM_IOSF_SB_MEMRD_SBE_SEQ":                            `ovm_do(sb_memrd_sbe_seq) 
       "HQM_IOSF_SB_MEMWR_SBE_SEQ":                            `ovm_do(sb_memwr_sbe_seq) 
       "HQM_IOSF_SB_NPMEMWR_FBE_SEQ":                          `ovm_do(sb_npmemwr_fbe_seq) 
       "HQM_IOSF_SB_NPMEMWR_SBE_SEQ":                          `ovm_do(sb_npmemwr_sbe_seq) 
       "HQM_IOSF_CFGRD_BADDATA_PARITY_SEQ":                    `ovm_do(cfgrd_baddata_parity_seq) 
       "HQM_IOSF_CFGWR_BADDATA_PARITY_SEQ":                    `ovm_do(cfgwr_baddata_parity_seq) 
       "HQM_IOSF_CFGWR_BAD_TXN_SEQ":                           `ovm_do(cfgwr_badtxn_seq) 
       "HQM_IOSF_MEMWR_BAD_DATA_PARITY_SEQ1":                  `ovm_do(memwr_baddata_parity_seq) 
       "HQM_IOSF_MEMWR_BAD_DATA_PARITY_SEQ2":                  `ovm_do(memwr_baddata_parity_seq1) 
       "HQM_IOSF_MEMRD_BAD_DATA_PARITY_SEQ":                   `ovm_do(memrd_baddata_parity_seq) 
       "HQM_IOSF_MEMWR_BADDATA_PARITY_QW_SEQ":                 `ovm_do(memwr_baddata_parity_qw_seq) 
       "HQM_IOSF_PRIM_CFGWR_BADCMD_PARITY_SEQ":                `ovm_do(prim_cfgwr_badcmd_parity_seq) 

       "HQM_IOSF_PRIM_PARITY_CTL_REG_CHK_SEQ":                `ovm_do(parity_ctl_reg_chk_seq) 
       "HQM_IOSF_PRIM_CFGRD_BADCMD_PARITY_SEQ":                `ovm_do(prim_cfgrd_badcmd_parity_seq) 
       "HQM_IOSF_PRIM_MEMWR_BADCMD_PARITY_SEQ":                `ovm_do(prim_memwr_badcmd_parity_seq) 
       "HQM_IOSF_PRIM_MEMRD_BADCMD_PARITY_SEQ":                `ovm_do(prim_memrd_badcmd_parity_seq) 
       "HQM_IOSF_SB_MEMWR_BAD_PARITY_SEQ":                     `ovm_do(sb_memwr_badparity_seq) 
       "HQM_IOSF_SB_MEMRD_BAD_PARITY_SEQ":                     `ovm_do(sb_memrd_badparity_seq) 
       "HQM_IOSF_SB_NPMEMWR_BAD_PARITY_SEQ":                   `ovm_do(sb_npmemwr_badparity_seq) 
       "HQM_IOSF_SB_CFGWR_BAD_PARITY_SEQ":                     `ovm_do(sb_cfgwr_badparity_seq) 
       "HQM_IOSF_SB_CFGRD_BAD_PARITY_SEQ":                     `ovm_do(sb_cfgrd_badparity_seq) 
       "HQM_IOSF_SB_NPMEMWR_UNSUPPORTED_SEQ":                  `ovm_do(sb_unsupported_npmemwr_seq) 
       "HQM_IOSF_SB_MEMRD_UNSUPPORTED_SEQ":                    `ovm_do(sb_unsupported_memrd_seq) 
       "HQM_IOSF_SB_NPMEMWR_SBE_FBE_FF_SEQ":                   `ovm_do(sb_npmemwr_sbe_fbe_ff_seq) 
       "HQM_IOSF_SB_MEMWR_SBE_FBE_FF_SEQ":                     `ovm_do(sb_memwr_sbe_fbe_ff_seq) 
       "HQM_IOSF_CG_SEQ":                                      `ovm_do(cg_seq)
       "HQM_IOSF_CRD_RETURN_B2B_P_UR_SEQ":                     `ovm_do(crd_return_b2b_p_ur_seq)
       "HQM_WRITE_ONCE_REGISTER_SEQ":                          `ovm_do(write_once_register_seq)
   endcase     
    `ovm_info(get_full_name(),$sformatf(" hqm_iosf_user_data_phase_seq ended "),OVM_LOW)

   if(has_trf_on) begin
    wait_ns_clk(1000);
    `ovm_info(get_full_name(),$sformatf(" hqm_iosf_user_data_phase_seq.i_usr_file_mode_seq start "),OVM_LOW)
    i_usr_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hqm_tb_cfg_user_data_file_mode_seq");
    i_usr_file_mode_seq.set_cfg("HQM_SEQ_CFG_USER_DATA", 1'b0);
    i_usr_file_mode_seq.start(get_sequencer());
    `ovm_info(get_full_name(),$sformatf(" hqm_iosf_user_data_phase_seq.i_usr_file_mode_seq ended "),OVM_LOW)
   end

endtask


`endif 
