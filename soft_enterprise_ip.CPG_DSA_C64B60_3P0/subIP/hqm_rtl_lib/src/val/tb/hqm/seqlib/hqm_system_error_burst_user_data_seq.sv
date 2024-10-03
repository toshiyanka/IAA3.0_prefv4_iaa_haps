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
// File   : hqm_system_error_burst_user_data_seq.sv
//
// Description :
//
//   Sequence that supports clock control tests with optional warm reset.
//
//   Variables within stim_config class
//     * do_warm_reset - do a warm reset (default is 0)
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_system_error_burst_user_data_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_system_error_burst_user_data_seq_stim_config";

  `ovm_object_utils_begin(hqm_system_error_burst_user_data_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(access_path,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg1, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg2, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(post_pf_flr_file_mode_plusarg, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_bursts, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ignore_read_mismatch, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(sai_check_on_hcw_write, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(min_burst_size, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(max_burst_size, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(min_batch_size, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(max_batch_size, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_cfgwr_weight, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_cfgrd_weight, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_memwr_weight, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_memwr_ur_weight, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_memwr_dpe_weight, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_memwr_mtlp_weight, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_memrd_weight, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_memrd_ur_weight, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_hcw_weight, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_hcw_err_weight, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pf_flr_weight, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(flr_wait_time, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_system_error_burst_user_data_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(file_mode_plusarg1)
    `stimulus_config_field_string(file_mode_plusarg2)
    `stimulus_config_field_string(post_pf_flr_file_mode_plusarg)
    `stimulus_config_field_rand_int(num_bursts)
    `stimulus_config_field_rand_int(ignore_read_mismatch)
    `stimulus_config_field_rand_int(sai_check_on_hcw_write)
    `stimulus_config_field_rand_int(min_burst_size)
    `stimulus_config_field_rand_int(max_burst_size)
    `stimulus_config_field_rand_int(min_batch_size)
    `stimulus_config_field_rand_int(max_batch_size)
    `stimulus_config_field_rand_int(pf_cfgwr_weight)
    `stimulus_config_field_rand_int(pf_cfgrd_weight)
    `stimulus_config_field_rand_int(pf_memwr_weight)
    `stimulus_config_field_rand_int(pf_memwr_ur_weight)
    `stimulus_config_field_rand_int(pf_memwr_dpe_weight)
    `stimulus_config_field_rand_int(pf_memwr_mtlp_weight)
    `stimulus_config_field_rand_int(pf_memrd_weight)
    `stimulus_config_field_rand_int(pf_memrd_ur_weight)
    `stimulus_config_field_rand_int(pf_hcw_weight)
    `stimulus_config_field_rand_int(pf_hcw_err_weight)
    `stimulus_config_field_rand_int(pf_flr_weight)
    `stimulus_config_field_rand_int(flr_wait_time)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        access_path     = sla_iosf_pri_reg_lib_pkg::get_src_type();
  string                        file_mode_plusarg1 = "HQM_DATA_SEQ";
  string                        file_mode_plusarg2 = "HQM_DATA_SEQ2";
  string                        post_pf_flr_file_mode_plusarg = "HQM_DATA_POST_PF_FLR_SEQ";

  rand  int                     num_bursts;
  rand  bit                     ignore_read_mismatch;
  rand  bit                     sai_check_on_hcw_write;
  rand  int                     min_burst_size;
  rand  int                     max_burst_size;
  rand  int                     min_batch_size;
  rand  int                     max_batch_size;
  rand  int unsigned            pf_cfgwr_weight;
  rand  int unsigned            pf_cfgrd_weight;
  rand  int unsigned            pf_memwr_weight;
  rand  int unsigned            pf_memwr_ur_weight;
  rand  int unsigned            pf_memwr_dpe_weight;
  rand  int unsigned            pf_memwr_mtlp_weight;
  rand  int unsigned            pf_memrd_weight;
  rand  int unsigned            pf_memrd_ur_weight;
  rand  int unsigned            pf_hcw_weight;
  rand  int unsigned            pf_hcw_err_weight;
  rand  int unsigned            pf_flr_weight;
  rand  int unsigned            flr_wait_time;

  constraint c_defaults {
    soft ignore_read_mismatch   == 0;

    //--HSD: https://hsdes.intel.com/appstore/article/#/22011196254
    //-- No SAI check for HCW Write
    soft sai_check_on_hcw_write == 0;
  };

  constraint c_num_bursts {
    num_bursts          >= 1;
    soft num_bursts     <= 100;
  };

  constraint c_flr_wait_time {
    flr_wait_time            >= 1000;
    soft flr_wait_time       == 1000;
  };

  constraint c_req_weights {
    solve ignore_read_mismatch before pf_hcw_weight, pf_hcw_err_weight, pf_flr_weight;

    pf_cfgwr_weight +
    pf_cfgrd_weight +
    pf_memwr_weight +
    pf_memwr_ur_weight +
    pf_memwr_dpe_weight +
    pf_memwr_mtlp_weight +
    pf_memrd_weight +
    pf_memrd_ur_weight +
    pf_hcw_weight   +
    pf_hcw_err_weight   +
    pf_flr_weight       >= 1;

    pf_cfgwr_weight     inside { [0:100] };
    pf_cfgrd_weight     inside { [0:100] };
    pf_memwr_weight     inside { [0:100] };
    pf_memwr_ur_weight inside { [0:100] };
    pf_memwr_dpe_weight inside { [0:100] };
    pf_memwr_mtlp_weight inside { [0:100] };
    pf_memrd_weight     inside { [0:100] };
    pf_memrd_ur_weight inside { [0:100] };
    pf_hcw_weight       inside { [0:100] };
    pf_hcw_err_weight   inside { [0:100] };
    pf_flr_weight       inside { [0:1] };

    ignore_read_mismatch == 1'b1 -> pf_hcw_weight   == 0;
    ignore_read_mismatch == 1'b1 -> pf_hcw_err_weight   == 0;
    ignore_read_mismatch == 1'b1 -> pf_flr_weight   == 0;
  }

  constraint c_burst_size {
         min_burst_size >= 1;
    soft min_burst_size <= 4;
         max_burst_size >= 1;
    soft max_burst_size <= 4;
         max_burst_size >= min_burst_size;
  }

  constraint c_batch_size {
    min_batch_size      >= 1;
    min_batch_size      <= 4;
    max_batch_size      >= 1;
    max_batch_size      <= 4;
    max_batch_size      >= min_batch_size;
  }

  function new(string name = "hqm_system_error_burst_user_data_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_system_error_burst_user_data_seq_stim_config

class hqm_system_error_burst_user_data_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_system_error_burst_user_data_seq, sla_sequencer)

  rand hqm_system_error_burst_user_data_seq_stim_config        cfg;

  sla_ral_env                   ral;
  sla_ral_data_t                ral_data;

  typedef struct packed {
    bit [2:0]   fmt;            // Byte 0
    bit [4:0]   tlp_type;       // Byte 0
    bit         tag9;           // Byte 1
    bit [2:0]   tc;             // Byte 1
    bit         tag8;           // Byte 1
    bit         attr2;          // Byte 1
    bit         ln;             // Byte 1
    bit         th;             // Byte 1
    bit         td;             // Byte 2
    bit         ep;             // Byte 2
    bit [1:0]   attr;           // Byte 2
    bit [1:0]   at;             // Byte 2
    bit [1:0]   length_u;       // Byte 2
    bit [7:0]   length_l;       // Byte 3
  } header_wrd0;

  typedef struct packed {
    bit [7:0]   rid_u;
    bit [7:0]   rid_l;
    bit [7:0]   tag;
    bit [3:0]   lastbe;
    bit [3:0]   firstbe;
  } header_wrd1;

  typedef struct packed {
    bit [7:0]   addr3;
    bit [7:0]   addr2;
    bit [7:0]   addr1;
    bit [7:0]   addr0;
  } header_wrd23;

  typedef enum int {
    UR          = 20,
    MTLP        = 18,
    PTLPR       = 12,
    EC          = 16,
    PF_FLR      = 0
  } err_type_t;

  typedef struct {
    header_wrd0         w0;
    header_wrd1         w1;
    header_wrd23        w2;
    header_wrd23        w3;
    err_type_t      err_type;
  } err_t;

  typedef struct {
    err_t       err_q[$];
  } err_q_t;

  err_q_t       pf_err_q;

  typedef struct {
    bit [7:0]   sai_6bit_to_8bit[$];
  } sai_queue_t;

  sla_ral_data_t 	rd_legal_sais[$];
  sla_ral_data_t 	wr_legal_sais[$];
  sai_queue_t           sai_queues[64];

  hqm_cfg                       i_hqm_cfg;
  hqm_iosf_prim_mon             i_hqm_iosf_prim_mon;
  hqm_pp_cq_status              i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed
  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;

  hqm_tb_cfg_file_mode_seq      i_file_mode_seq;
  hqm_tb_cfg_file_mode_seq      i_post_pf_flr_file_mode_seq;
  hqm_tb_cfg_file_mode_seq      i_file_mode_seq2;

  typedef struct {
    bit         allow_random_wr;
    sla_ral_reg my_reg;
  } reg_entry_t;

  reg_entry_t   pf_cfg_regs[$];
  reg_entry_t   pf_mem_regs[$];

  sla_ral_reg   func_bar_u_reg;
  sla_ral_reg   func_bar_l_reg;

  sla_ral_reg   pf_pcie_cap_device_control_reg;

  sla_ral_reg   pf_aer_cap_uncorr_err_status;

  sla_ral_reg   pf_aer_cap_control;

  sla_ral_reg   pf_aer_cap_header_log[4];

  int           wait_for_completion;

  real          pf_flr_time;

  int           pf_hcw_weight;
  int           pf_hcw_err_weight;
  int           pf_flr_weight;

  int           pf_hcw_token_cnt;

  int           pf_cfgwr_cnt;
  int           pf_cfgrd_cnt;
  int           pf_memwr_cnt;
  int           pf_memwr_ur_cnt;
  int           pf_memwr_dpe_cnt;
  int           pf_memwr_mtlp_cnt;
  int           pf_memrd_ur_cnt;
  int           pf_memrd_cnt;
  int           pf_hcw_cnt;
  int           pf_flr_cnt;

  semaphore     regs_sem;
  semaphore     burst_sem;

  string pf_mem_regs_change_list[] = {
  };

  string pf_mem_regs_no_change_list[] = {
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[0]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[10]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[11]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[12]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[13]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[14]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[15]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[16]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[1]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[2]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[3]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[4]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[5]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[6]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[7]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[8]",
    "credit_hist_pipe.cfg_dir_cq_int_depth_thrsh[9]",
    "hqm_system_csr.dir_cq2vf_pf_ro[0]",
    "hqm_system_csr.dir_cq2vf_pf_ro[10]",
    "hqm_system_csr.dir_cq2vf_pf_ro[11]",
    "hqm_system_csr.dir_cq2vf_pf_ro[12]",
    "hqm_system_csr.dir_cq2vf_pf_ro[13]",
    "hqm_system_csr.dir_cq2vf_pf_ro[14]",
    "hqm_system_csr.dir_cq2vf_pf_ro[15]",
    "hqm_system_csr.dir_cq2vf_pf_ro[16]",
    "hqm_system_csr.dir_cq2vf_pf_ro[2]",
    "hqm_system_csr.dir_cq2vf_pf_ro[3]",
    "hqm_system_csr.dir_cq2vf_pf_ro[4]",
    "hqm_system_csr.dir_cq2vf_pf_ro[5]",
    "hqm_system_csr.dir_cq2vf_pf_ro[6]",
    "hqm_system_csr.dir_cq2vf_pf_ro[7]",
    "hqm_system_csr.dir_cq2vf_pf_ro[8]",
    "hqm_system_csr.dir_cq2vf_pf_ro[9]",
    "hqm_system_csr.dir_cq_addr_l[0]",
    "hqm_system_csr.dir_cq_addr_l[10]",
    "hqm_system_csr.dir_cq_addr_l[11]",
    "hqm_system_csr.dir_cq_addr_l[12]",
    "hqm_system_csr.dir_cq_addr_l[13]",
    "hqm_system_csr.dir_cq_addr_l[14]",
    "hqm_system_csr.dir_cq_addr_l[15]",
    "hqm_system_csr.dir_cq_addr_l[16]",
    "hqm_system_csr.dir_cq_addr_l[1]",
    "hqm_system_csr.dir_cq_addr_l[2]",
    "hqm_system_csr.dir_cq_addr_l[3]",
    "hqm_system_csr.dir_cq_addr_l[4]",
    "hqm_system_csr.dir_cq_addr_l[5]",
    "hqm_system_csr.dir_cq_addr_l[6]",
    "hqm_system_csr.dir_cq_addr_l[7]",
    "hqm_system_csr.dir_cq_addr_l[8]",
    "hqm_system_csr.dir_cq_addr_l[9]",
    "hqm_system_csr.dir_cq_addr_u[0]",
    "hqm_system_csr.dir_cq_addr_u[10]",
    "hqm_system_csr.dir_cq_addr_u[11]",
    "hqm_system_csr.dir_cq_addr_u[12]",
    "hqm_system_csr.dir_cq_addr_u[13]",
    "hqm_system_csr.dir_cq_addr_u[14]",
    "hqm_system_csr.dir_cq_addr_u[15]",
    "hqm_system_csr.dir_cq_addr_u[16]",
    "hqm_system_csr.dir_cq_addr_u[1]",
    "hqm_system_csr.dir_cq_addr_u[2]",
    "hqm_system_csr.dir_cq_addr_u[3]",
    "hqm_system_csr.dir_cq_addr_u[4]",
    "hqm_system_csr.dir_cq_addr_u[5]",
    "hqm_system_csr.dir_cq_addr_u[6]",
    "hqm_system_csr.dir_cq_addr_u[7]",
    "hqm_system_csr.dir_cq_addr_u[8]",
    "hqm_system_csr.dir_cq_addr_u[9]",
    "hqm_system_csr.dir_pp_v[0]",
    "hqm_system_csr.dir_pp_v[10]",
    "hqm_system_csr.dir_pp_v[11]",
    "hqm_system_csr.dir_pp_v[12]",
    "hqm_system_csr.dir_pp_v[13]",
    "hqm_system_csr.dir_pp_v[14]",
    "hqm_system_csr.dir_pp_v[15]",
    "hqm_system_csr.dir_pp_v[16]",
    "hqm_system_csr.dir_pp_v[1]",
    "hqm_system_csr.dir_pp_v[2]",
    "hqm_system_csr.dir_pp_v[3]",
    "hqm_system_csr.dir_pp_v[4]",
    "hqm_system_csr.dir_pp_v[5]",
    "hqm_system_csr.dir_pp_v[6]",
    "hqm_system_csr.dir_pp_v[7]",
    "hqm_system_csr.dir_pp_v[8]",
    "hqm_system_csr.dir_pp_v[9]",
    "hqm_system_csr.dir_qid_v[0]",
    "hqm_system_csr.dir_qid_v[10]",
    "hqm_system_csr.dir_qid_v[11]",
    "hqm_system_csr.dir_qid_v[12]",
    "hqm_system_csr.dir_qid_v[13]",
    "hqm_system_csr.dir_qid_v[14]",
    "hqm_system_csr.dir_qid_v[15]",
    "hqm_system_csr.dir_qid_v[16]",
    "hqm_system_csr.dir_qid_v[1]",
    "hqm_system_csr.dir_qid_v[2]",
    "hqm_system_csr.dir_qid_v[3]",
    "hqm_system_csr.dir_qid_v[4]",
    "hqm_system_csr.dir_qid_v[5]",
    "hqm_system_csr.dir_qid_v[6]",
    "hqm_system_csr.dir_qid_v[7]",
    "hqm_system_csr.dir_qid_v[8]",
    "hqm_system_csr.dir_qid_v[9]",
    "hqm_system_csr.dir_vasqid_v[0]",
    "hqm_system_csr.dir_vasqid_v[10]",
    "hqm_system_csr.dir_vasqid_v[11]",
    "hqm_system_csr.dir_vasqid_v[12]",
    "hqm_system_csr.dir_vasqid_v[13]",
    "hqm_system_csr.dir_vasqid_v[14]",
    "hqm_system_csr.dir_vasqid_v[15]",
    "hqm_system_csr.dir_vasqid_v[16]",
    "hqm_system_csr.dir_vasqid_v[1]",
    "hqm_system_csr.dir_vasqid_v[2]",
    "hqm_system_csr.dir_vasqid_v[3]",
    "hqm_system_csr.dir_vasqid_v[4]",
    "hqm_system_csr.dir_vasqid_v[5]",
    "hqm_system_csr.dir_vasqid_v[6]",
    "hqm_system_csr.dir_vasqid_v[7]",
    "hqm_system_csr.dir_vasqid_v[8]",
    "hqm_system_csr.dir_vasqid_v[9]",
    "hqm_system_csr.vf_dir_vpp2pp[1033]",
    "hqm_system_csr.vf_dir_vpp2pp[1162]",
    "hqm_system_csr.vf_dir_vpp2pp[1291]",
    "hqm_system_csr.vf_dir_vpp2pp[130]",
    "hqm_system_csr.vf_dir_vpp2pp[1420]",
    "hqm_system_csr.vf_dir_vpp2pp[1549]",
    "hqm_system_csr.vf_dir_vpp2pp[1678]",
    "hqm_system_csr.vf_dir_vpp2pp[1807]",
    "hqm_system_csr.vf_dir_vpp2pp[1936]",
    "hqm_system_csr.vf_dir_vpp2pp[1]",
    "hqm_system_csr.vf_dir_vpp2pp[259]",
    "hqm_system_csr.vf_dir_vpp2pp[388]",
    "hqm_system_csr.vf_dir_vpp2pp[517]",
    "hqm_system_csr.vf_dir_vpp2pp[646]",
    "hqm_system_csr.vf_dir_vpp2pp[775]",
    "hqm_system_csr.vf_dir_vpp2pp[904]",
    "hqm_system_csr.vf_dir_vpp_v[1033]",
    "hqm_system_csr.vf_dir_vpp_v[1162]",
    "hqm_system_csr.vf_dir_vpp_v[1291]",
    "hqm_system_csr.vf_dir_vpp_v[130]",
    "hqm_system_csr.vf_dir_vpp_v[1420]",
    "hqm_system_csr.vf_dir_vpp_v[1549]",
    "hqm_system_csr.vf_dir_vpp_v[1678]",
    "hqm_system_csr.vf_dir_vpp_v[1807]",
    "hqm_system_csr.vf_dir_vpp_v[1936]",
    "hqm_system_csr.vf_dir_vpp_v[1]",
    "hqm_system_csr.vf_dir_vpp_v[259]",
    "hqm_system_csr.vf_dir_vpp_v[388]",
    "hqm_system_csr.vf_dir_vpp_v[517]",
    "hqm_system_csr.vf_dir_vpp_v[646]",
    "hqm_system_csr.vf_dir_vpp_v[775]",
    "hqm_system_csr.vf_dir_vpp_v[904]",
    "hqm_system_csr.vf_dir_vqid2qid[1033]",
    "hqm_system_csr.vf_dir_vqid2qid[1162]",
    "hqm_system_csr.vf_dir_vqid2qid[1291]",
    "hqm_system_csr.vf_dir_vqid2qid[130]",
    "hqm_system_csr.vf_dir_vqid2qid[1420]",
    "hqm_system_csr.vf_dir_vqid2qid[1549]",
    "hqm_system_csr.vf_dir_vqid2qid[1678]",
    "hqm_system_csr.vf_dir_vqid2qid[1807]",
    "hqm_system_csr.vf_dir_vqid2qid[1936]",
    "hqm_system_csr.vf_dir_vqid2qid[1]",
    "hqm_system_csr.vf_dir_vqid2qid[259]",
    "hqm_system_csr.vf_dir_vqid2qid[388]",
    "hqm_system_csr.vf_dir_vqid2qid[517]",
    "hqm_system_csr.vf_dir_vqid2qid[646]",
    "hqm_system_csr.vf_dir_vqid2qid[775]",
    "hqm_system_csr.vf_dir_vqid2qid[904]",
    "hqm_system_csr.vf_dir_vqid_v[1033]",
    "hqm_system_csr.vf_dir_vqid_v[1162]",
    "hqm_system_csr.vf_dir_vqid_v[1291]",
    "hqm_system_csr.vf_dir_vqid_v[130]",
    "hqm_system_csr.vf_dir_vqid_v[1420]",
    "hqm_system_csr.vf_dir_vqid_v[1549]",
    "hqm_system_csr.vf_dir_vqid_v[1678]",
    "hqm_system_csr.vf_dir_vqid_v[1807]",
    "hqm_system_csr.vf_dir_vqid_v[1936]",
    "hqm_system_csr.vf_dir_vqid_v[1]",
    "hqm_system_csr.vf_dir_vqid_v[259]",
    "hqm_system_csr.vf_dir_vqid_v[388]",
    "hqm_system_csr.vf_dir_vqid_v[517]",
    "hqm_system_csr.vf_dir_vqid_v[646]",
    "hqm_system_csr.vf_dir_vqid_v[775]",
    "hqm_system_csr.vf_dir_vqid_v[904]",
    "list_sel_pipe.cfg_cq_dir_disable[0]",
    "list_sel_pipe.cfg_cq_dir_disable[10]",
    "list_sel_pipe.cfg_cq_dir_disable[11]",
    "list_sel_pipe.cfg_cq_dir_disable[12]",
    "list_sel_pipe.cfg_cq_dir_disable[13]",
    "list_sel_pipe.cfg_cq_dir_disable[14]",
    "list_sel_pipe.cfg_cq_dir_disable[15]",
    "list_sel_pipe.cfg_cq_dir_disable[16]",
    "list_sel_pipe.cfg_cq_dir_disable[1]",
    "list_sel_pipe.cfg_cq_dir_disable[2]",
    "list_sel_pipe.cfg_cq_dir_disable[3]",
    "list_sel_pipe.cfg_cq_dir_disable[4]",
    "list_sel_pipe.cfg_cq_dir_disable[5]",
    "list_sel_pipe.cfg_cq_dir_disable[6]",
    "list_sel_pipe.cfg_cq_dir_disable[7]",
    "list_sel_pipe.cfg_cq_dir_disable[8]",
    "list_sel_pipe.cfg_cq_dir_disable[9]"
  };

  string pf_cfg_regs_change_list[] = {
    "hqm_pf_cfg_i.int_line"
  };

  string pf_cfg_regs_no_change_list[] = {
    "hqm_pf_cfg_i.csr_bar_l",
    "hqm_pf_cfg_i.csr_bar_u",
    "hqm_pf_cfg_i.device_command",
    "hqm_pf_cfg_i.func_bar_l",
    "hqm_pf_cfg_i.func_bar_u"
  };

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_system_error_burst_user_data_seq_stim_config);

  function new(string name = "hqm_system_error_burst_user_data_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name);

    for (bit [8:0] sai8 = 0 ; sai8 < 9'h100 ; sai8++) begin
      if (sai8[0] == 1'b1) begin
        sai_queues[{3'b000,sai8[3:1]}].sai_6bit_to_8bit.push_back(sai8);
      end else if ((sai8[7:1] > 7'b0000111) && (sai8[7:1] < 7'b0111111)) begin
        sai_queues[sai8[6:1]].sai_6bit_to_8bit.push_back(sai8);
      end else begin
        sai_queues[6'b111111].sai_6bit_to_8bit.push_back(sai8);
      end
    end

    regs_sem            = new(1);
    burst_sem           = new(0);

    pf_hcw_token_cnt = 0;

    wait_for_completion = 1;

    pf_cfgwr_cnt        = 0;
    pf_cfgrd_cnt        = 0;
    pf_memwr_cnt        = 0;
    pf_memwr_ur_cnt    = 0;
    pf_memwr_dpe_cnt    = 0;
    pf_memwr_mtlp_cnt    = 0;
    pf_memrd_cnt        = 0;
    pf_memrd_ur_cnt    = 0;
    pf_hcw_cnt          = 0;
    pf_flr_cnt          = 0;

    cfg = hqm_system_error_burst_user_data_seq_stim_config::type_id::create("hqm_system_error_burst_user_data_seq_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  function bit [7:0] get_8bit_sai(sla_ral_sai_t sai6);
    sai6 = sai6 & 6'h3f;
    return (sai_queues[sai6].sai_6bit_to_8bit[$urandom_range(sai_queues[sai6].sai_6bit_to_8bit.size()-1,0)]);
  endfunction

  virtual task body();
    ovm_object o_tmp;
    byte_t      rd_data[$];
    addr_t      rd_addr;
    bit         prim_bursts_done;

    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal(get_full_name(), "Unable to get RAL handle");
    end    

    if (!p_sequencer.get_config_object("i_hqm_iosf_prim_mon", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_iosf_prim_mon object");
    end

    if (!$cast(i_hqm_iosf_prim_mon, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_iosf_prim_mon not compatible with type of i_hqm_iosf_prim_mon"));
    end

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
    end    

    //-----------------------------
    //-- get i_hqm_pp_cq_status
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_pp_cq_status", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
    end

    if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
    end

    if (!p_sequencer.get_config_object("i_hcw_scoreboard", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hcw_scoreboard object");
    end

    if (!$cast(i_hcw_scoreboard, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
    end

    apply_stim_config_overrides(1);

    populate_regs();

    i_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq");
    i_file_mode_seq.set_cfg(cfg.file_mode_plusarg1, 1'b0);
    i_file_mode_seq.start(get_sequencer());

    prim_bursts_done = 1'b0;

    fork
      begin
        for (int i = 0 ; i < cfg.num_bursts ; i++) begin
          issue_burst();
        end

        prim_bursts_done = 1'b1;
      end
    join

    if (pf_hcw_token_cnt > 0) begin
      do_pf_hcw_token_ret();
    end

    `ovm_info(get_type_name(),"HCW transaction sent",OVM_LOW);
    #200ns;

    i_hqm_pp_cq_status.pp_cq_state_update(.is_ldb(1'b0), .pp_cq(0), .new_enq_cnt(0), .new_sch_cnt(0));

    i_file_mode_seq2 = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq2");
    i_file_mode_seq2.set_cfg(cfg.file_mode_plusarg2, 1'b0);
    i_file_mode_seq2.start(get_sequencer());

    `ovm_info(get_full_name(),$psprintf({"\nHQM_SYSTEM_BURST IOSF Primary  PF Counts - cfgwr=%04d cfgrd=%04d memwr=%04d memrd=%04d memwrur=%04d memwrdpe=%04d memwrmtlp=%04d memrdur=%04d hcw=%04d flr=%04d"},
                                        pf_cfgwr_cnt,pf_cfgrd_cnt,pf_memwr_cnt,pf_memrd_cnt,pf_memwr_ur_cnt,pf_memwr_dpe_cnt,pf_memwr_mtlp_cnt,pf_memrd_ur_cnt,pf_hcw_cnt,pf_flr_cnt),OVM_LOW)
  endtask

  virtual task issue_burst();
    int                 burst_size;
    err_t               err_hdr_info;
    sla_sm_ag_status_t  status;
    sla_ral_sai_t       legal_wr_sai;

    int pf_cfgwr_weight         = cfg.pf_cfgwr_weight;
    int pf_cfgrd_weight         = cfg.pf_cfgrd_weight;
    int pf_memwr_weight         = cfg.pf_memwr_weight;
    int pf_memwr_ur_weight      = cfg.pf_memwr_ur_weight;
    int pf_memwr_dpe_weight     = cfg.pf_memwr_dpe_weight;
    int pf_memwr_mtlp_weight    = cfg.pf_memwr_mtlp_weight;
    int pf_memrd_weight         = cfg.pf_memrd_weight;
    int pf_memrd_ur_weight      = cfg.pf_memrd_ur_weight;

    int start_pf_memwr_mtlp_cnt = pf_memwr_mtlp_cnt;

    pf_hcw_weight       = cfg.pf_hcw_weight;
    pf_hcw_err_weight   = cfg.pf_hcw_err_weight;
    pf_flr_weight       = (pf_flr_cnt > 0) ? 0 : cfg.pf_flr_weight;

    pf_err_q.err_q.delete();

    burst_size = $urandom_range(cfg.max_burst_size, cfg.min_burst_size);

    $display("Burst size %d",burst_size);

    randsequence (burst)
      burst     : repeat (burst_size) request post_request;
      request   : pf_cfgwr      := pf_cfgwr_weight |
                  pf_cfgrd      := pf_cfgrd_weight |
                  pf_memwr      := pf_memwr_weight |
                  pf_memwr_ur  := pf_memwr_ur_weight |
                  pf_memwr_dpe  := pf_memwr_dpe_weight |
                  pf_memwr_mtlp  := pf_memwr_mtlp_weight |
                  pf_memrd      := pf_memrd_weight |
                  pf_memrd_ur  := pf_memrd_ur_weight |
                  pf_hcw        := pf_hcw_weight   |
                  pf_hcw_err    := pf_hcw_err_weight   |
                  pf_flr        := pf_flr_weight ;

      post_request:     { do_post_request(); #0.1ns; };
      pf_cfgwr:         { do_pf_cfgwr(); #0.1ns; };
      pf_cfgrd:         { do_pf_cfgrd(); #0.1ns; };
      pf_memwr:         { do_pf_memwr(); #0.1ns; };
      pf_memwr_ur:      { do_pf_memwr_ur(); #0.1ns; };
      pf_memwr_dpe:      { do_pf_memwr_dpe(); #0.1ns; };
      pf_memwr_mtlp:      { do_pf_memwr_mtlp(); #0.1ns; };
      pf_memrd:         { do_pf_memrd(); #0.1ns; };
      pf_memrd_ur:      { do_pf_memrd_ur(); #0.1ns; };
      pf_hcw:           { do_pf_hcw();   #0.1ns; };
      pf_hcw_err:       { do_pf_hcw(.with_error(1'b1));   #0.1ns; };
      pf_flr:           { pf_flr_weight = 0;
                          pf_cfgwr_weight = 0;
                          pf_cfgrd_weight = 0;
                          pf_memrd_weight = 0;
                          pf_memrd_ur_weight = 0;
                          pf_memwr_ur_weight = 0;
                          pf_memwr_dpe_weight = 0;
                          pf_memwr_mtlp_weight = 0;
                          do_pf_flr();   #0.1ns; };
    endsequence

    do_idle(burst_size,16 * (pf_memwr_mtlp_cnt - start_pf_memwr_mtlp_cnt));

    if (pf_flr_time == 0) begin
      check_pf_errors();
    end

    if (pf_hcw_token_cnt > 100) begin
      do_pf_hcw_token_ret();
    end

    while (pf_flr_time > 0) begin
      #5ns;

      if ((pf_flr_time + cfg.flr_wait_time) <= ($realtime()/1ns)) begin
        pf_flr_time             = 0;
        wait_for_completion     = 1;

        i_post_pf_flr_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_post_pf_flr_file_mode_seq");
        i_post_pf_flr_file_mode_seq.set_cfg(cfg.post_pf_flr_file_mode_plusarg, 1'b0);
        i_post_pf_flr_file_mode_seq.start(get_sequencer());

        check_pf_errors();
      end
    end

    legal_wr_sai = pf_aer_cap_control.pick_legal_sai_value(RAL_WRITE);

  endtask

  virtual task get_reg(input reg_entry_t regs[$], output reg_entry_t reg_out);
    int regs_by_vf[$];
    int reg_index;

    regs_by_vf.delete();

    regs_sem.get(1);

    regs_by_vf = regs.find_index with ( item.my_reg != null );

    if (regs_by_vf.size() > 0) begin
      reg_index = $urandom_range(regs_by_vf.size() - 1, 0);

      reg_out = regs[regs_by_vf[reg_index]];
    end else begin
      reg_out.allow_random_wr = 0;
      reg_out.my_reg = null;
    end

    regs_sem.put(1);
  endtask

  virtual task do_post_request();
    if (i_hqm_pp_cq_status.vas_credit_avail(0) == 0) begin
      pf_hcw_weight = 0;
    end
  endtask

  virtual task check_pf_errors();
    err_t               err_info;
    err_t               first_err_info;
    sla_ral_sai_t       legal_rd_sai;
    sla_ral_sai_t       legal_wr_sai;
    sla_ral_data_t      exp_aer_cap_uncorr_err_status;
    sla_ral_data_t      aer_cap_uncorr_err_status;
    sla_ral_data_t      bd_aer_cap_uncorr_err_status;
    sla_ral_data_t      aer_cap_control_data;
    sla_ral_data_t      aer_cap_header_log_data[4];
    sla_status_t        status;

    legal_rd_sai = pf_aer_cap_control.pick_legal_sai_value(RAL_READ);
    legal_wr_sai = pf_aer_cap_control.pick_legal_sai_value(RAL_WRITE);

    pf_aer_cap_uncorr_err_status.read(status,aer_cap_uncorr_err_status,cfg.access_path,this,.sai(legal_rd_sai));
    pf_aer_cap_uncorr_err_status.read_backdoor(status,bd_aer_cap_uncorr_err_status,this);

    // handle latency of setting status bits relative to end of burst
    if (aer_cap_uncorr_err_status != bd_aer_cap_uncorr_err_status) begin
      pf_aer_cap_uncorr_err_status.read(status,aer_cap_uncorr_err_status,cfg.access_path,this,.sai(legal_rd_sai));
    end

    pf_aer_cap_control.read_backdoor(status,aer_cap_control_data,this);

    for (int i = 0 ; i < 4 ; i++) begin
      pf_aer_cap_header_log[i].read_backdoor(status,aer_cap_header_log_data[i],this);
    end

    if (pf_err_q.err_q.size() > 0) begin
      exp_aer_cap_uncorr_err_status = 0;

      first_err_info = pf_err_q.err_q[0];

      while (pf_err_q.err_q.size() > 0) begin
        err_info = pf_err_q.err_q.pop_front();

        exp_aer_cap_uncorr_err_status[err_info.err_type] = 1'b1;

        `ovm_info(get_full_name(), $psprintf("Injected PF ucs = 0x%0x  aer_cap_control = 0x%08x  hdr_log_0 = 0x%08x  hdr_log_1 = 0x%08x  hdr_log_2 = 0x%08x  hdr_log_3 = 0x%08x",
                                             1 << err_info.err_type,err_info.err_type,err_info.w0,err_info.w1,err_info.w2,err_info.w3), OVM_LOW)
      end

      `ovm_info(get_full_name(), $psprintf("Observed PF ucs = 0x%08x  aer_cap_control = 0x%08x hdr_log_0 = 0x%08x  hdr_log_1 = 0x%08x  hdr_log_2 = 0x%08x  hdr_log_3 = 0x%08x",
                                           aer_cap_uncorr_err_status, aer_cap_control_data,aer_cap_header_log_data[0],aer_cap_header_log_data[1],aer_cap_header_log_data[2],aer_cap_header_log_data[3]), OVM_LOW)

      if (aer_cap_uncorr_err_status != exp_aer_cap_uncorr_err_status) begin
        `ovm_error(get_type_name(),$psprintf("Expected PF AER_CAP_UNCORR_ERR_STATUS to be 0x%08x, observed 0x%08x",exp_aer_cap_uncorr_err_status,aer_cap_uncorr_err_status))
      end

      if (aer_cap_control_data[4:0] != first_err_info.err_type) begin
        `ovm_error(get_type_name(),$psprintf("Expected first error pointer to be %0d in PF AER_CAP_CONTROL register, observed %0d",first_err_info.err_type,aer_cap_control_data,aer_cap_control_data[4:0]))
      end

      if ((aer_cap_header_log_data[0] != first_err_info.w0) ||
          (aer_cap_header_log_data[1] != first_err_info.w1) ||
          (aer_cap_header_log_data[2] != first_err_info.w2) ||
          (aer_cap_header_log_data[3] != first_err_info.w3)) begin
        `ovm_error(get_type_name(),$psprintf("PF expected AER_CAP_HEADER_LOG does not match observed value\n    expected - 0x%08x_%08x_%08x_%08x\n    observed - 0x%08x_%08x_%08x_%08x",
                                             first_err_info.w3,first_err_info.w2,first_err_info.w1,first_err_info.w0,
                                             aer_cap_header_log_data[3],aer_cap_header_log_data[2],aer_cap_header_log_data[1],aer_cap_header_log_data[0]))
      end

      pf_aer_cap_uncorr_err_status.write(status, aer_cap_uncorr_err_status, cfg.access_path, this, .sai(legal_wr_sai));
    end else begin
      if (aer_cap_uncorr_err_status != 0) begin
        `ovm_error(get_type_name(),$psprintf("Expected PF AER_CAP_UNCORR_ERR_STATUS to be 0x00000000, observed 0x%08x",aer_cap_uncorr_err_status))

        pf_aer_cap_uncorr_err_status.write(status, aer_cap_uncorr_err_status, cfg.access_path, this, .sai(legal_wr_sai));
      end

      if (aer_cap_control_data[4:0] != 0) begin
        `ovm_error(get_type_name(),$psprintf("Expected first error pointer to be 0 in PF AER_CAP_CONTROL register, observed %0d",aer_cap_control_data,aer_cap_control_data[4:0]))
      end
    end
  endtask

  virtual task do_pf_cfgwr();
    reg_entry_t         reg_entry;
    sla_ral_reg         my_reg;
    Iosf::address_t     addr;
    sla_ral_data_t      ral_data;
    bit [7:0]           sai8;
    hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_wr_seq        cfg_write_seq;
    int                 my_reg_size;

    pf_cfgwr_cnt++;

    fork
      begin
        get_reg(pf_cfg_regs,reg_entry);
        my_reg = reg_entry.my_reg;
        addr = ral.get_addr_val(cfg.access_path,my_reg);
        my_reg_size = my_reg.get_size();
        if (reg_entry.allow_random_wr) begin
          ral_data = $urandom_range(32'hffffffff,32'h00000000);
        end else begin
          ral_data = my_reg.get();
        end

        sai8 = get_8bit_sai(my_reg.pick_legal_sai_value(RAL_WRITE));

        `ovm_info(get_type_name(),$psprintf("IOSF Primary CFG Write to %s.%s (address=0x%0x) data 0x%0x",my_reg.get_file_name(),my_reg.get_name(),addr,ral_data),OVM_LOW)
        my_reg.predict(ral_data);
        `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(cfg.access_path), {iosf_addr == addr; reg_size == my_reg_size; iosf_data == ral_data[31:0]; iosf_sai == sai8; iosf_wait_for_completion == wait_for_completion;})
        if (wait_for_completion) begin
          if (cfg_write_seq.iosf_cpl_status != 3'b000) begin
            `ovm_error(get_type_name(),$psprintf("Unexpected error completion (%d) for IOSF Primary CFG Write to %s (address=0x%0x)",cfg_write_seq.iosf_cpl_status,my_reg.get_name(),addr))
          end
        end

        burst_sem.put(1);
      end
    join_none
  endtask

  virtual task do_pf_cfgrd();
    reg_entry_t         reg_entry;
    sla_ral_reg         my_reg;
    Iosf::address_t     addr;
    sla_ral_data_t      ral_data;
    sla_ral_data_t      exp_ral_data;
    bit [7:0]           sai8;
    hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_rd_seq        cfg_read_seq;
    int                 my_reg_size;

    pf_cfgrd_cnt++;

    fork
      begin
        get_reg(pf_cfg_regs,reg_entry);
        my_reg = reg_entry.my_reg;
        my_reg = reg_entry.my_reg;
        addr = ral.get_addr_val(cfg.access_path,my_reg);
        my_reg_size = my_reg.get_size();

        sai8 = get_8bit_sai(my_reg.pick_legal_sai_value(RAL_READ));

        exp_ral_data = my_reg.get();
        `ovm_info(get_type_name(),$psprintf("Issue IOSF Primary CFG Read to %s.%s (address=0x%0x), expect data=0x%0x",my_reg.get_file_name(),my_reg.get_name(),addr,exp_ral_data),OVM_LOW)
        `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(cfg.access_path), {iosf_addr == addr; reg_size == my_reg_size; iosf_sai == sai8; iosf_wait_for_completion == wait_for_completion;})
        if (wait_for_completion && !cfg.ignore_read_mismatch) begin
          if (cfg_read_seq.iosf_cpl_status != 3'b000) begin
            `ovm_error(get_type_name(),$psprintf("Unexpected error completion (%d) for IOSF Primary CFG Read to %s (address=0x%0x)",cfg_read_seq.iosf_cpl_status,my_reg.get_name(),addr))
          end else begin
            ral_data = cfg_read_seq.iosf_data >> (addr[1:0] * 8);
            for (int i = my_reg.get_size() ; i < $bits(ral_data) ; i++) ral_data[i] = 1'b0;
            `ovm_info(get_type_name(),$psprintf("IOSF Primary CFG Read to %s.%s (address=0x%0x) data 0x%0x",my_reg.get_file_name(),my_reg.get_name(),addr,ral_data),OVM_LOW)
            if (ral_data !== exp_ral_data) begin
              `ovm_error(get_type_name(),$psprintf("IOSF Primary CFG Read to %s (address=0x%0x) expected data=0x%0x received data=0x%0x",my_reg.get_name(),addr,exp_ral_data,ral_data))
            end
          end
        end

        burst_sem.put(1);
      end
    join_none
  endtask

  virtual task do_pf_memwr();
    reg_entry_t         reg_entry;
    sla_ral_reg         my_reg;
    Iosf::address_t     addr;
    sla_ral_data_t      ral_data;
    bit [7:0]           sai8;
    bit [3:0]           first_byte_en;
    hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

    pf_memwr_cnt++;

    fork
      begin
        get_reg(pf_mem_regs,reg_entry);
        my_reg = reg_entry.my_reg;
        addr = ral.get_addr_val(cfg.access_path,my_reg);
        if (reg_entry.allow_random_wr) begin
          ral_data = $urandom_range(32'hffffffff,32'h00000000);
        end else begin
          ral_data = my_reg.get();
        end

        sai8 = get_8bit_sai(my_reg.pick_legal_sai_value(RAL_WRITE));

        `ovm_info(get_type_name(),$psprintf("IOSF Primary MEM Write to %s.%s (address=0x%0x) data 0x%0x",my_reg.get_file_name(),my_reg.get_name(),addr,ral_data),OVM_LOW)
        my_reg.predict(ral_data);
        `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(cfg.access_path), {iosf_addr == addr; iosf_data.size() == 1; iosf_data[0] == ral_data[31:0]; iosf_sai == sai8;})

        burst_sem.put(1);
      end
    join_none
  endtask

  virtual function err_t gen_err_hdr_info( err_type_t err_type,
                                           Iosf::address_t addr,
                                           int iosf_length = 1,
                                           bit [3:0] first_byte_en = 4'b1111,
                                           bit [3:0] last_byte_en = 4'b0000,
                                           bit [2:0] fmt,
                                           bit [4:0] tlp_type,
                                           bit ep = 1'b0);
    err_t       err_hdr_info;

    err_hdr_info.err_type           = err_type;

    err_hdr_info.w0                 = 0;
    err_hdr_info.w0.tlp_type        = tlp_type;
    err_hdr_info.w0.tag9            = 1'b0;
    err_hdr_info.w0.tc              = 3'b000;
    err_hdr_info.w0.tag8            = 1'b0;
    err_hdr_info.w0.attr2           = 1'b0;
    err_hdr_info.w0.ln              = 1'b0;
    err_hdr_info.w0.th              = 1'b0;
    err_hdr_info.w0.td              = 1'b0;
    err_hdr_info.w0.ep              = ep;
    err_hdr_info.w0.attr            = 2'b00;
    err_hdr_info.w0.at              = 2'b00;
    err_hdr_info.w0.length_u        = iosf_length[9:8];
    err_hdr_info.w0.length_l        = iosf_length[7:0];

    err_hdr_info.w0.fmt           = fmt;

    err_hdr_info.w1                 = 0;
    err_hdr_info.w1.rid_u           = 8'h00;
    err_hdr_info.w1.rid_l           = 8'h00;
    err_hdr_info.w1.tag             = 8'h00;
    err_hdr_info.w1.firstbe         = first_byte_en;
    err_hdr_info.w1.lastbe          = last_byte_en;

    if (addr >= 64'h1_00000000) begin
      err_hdr_info.w2.addr0         = addr[39:32];
      err_hdr_info.w2.addr1         = addr[47:40];
      err_hdr_info.w2.addr2         = addr[55:48];
      err_hdr_info.w2.addr3         = addr[63:56];
      err_hdr_info.w3.addr0         = {addr[7:2],2'b00};
      err_hdr_info.w3.addr1         = addr[15:8];
      err_hdr_info.w3.addr2         = addr[23:16];
      err_hdr_info.w3.addr3         = addr[31:24];
    end else begin
      err_hdr_info.w2.addr0         = {addr[7:2],2'b00};
      err_hdr_info.w2.addr1         = addr[15:8];
      err_hdr_info.w2.addr2         = addr[23:16];
      err_hdr_info.w2.addr3         = addr[31:24];
      err_hdr_info.w3.addr0         = 0;
      err_hdr_info.w3.addr1         = 0;
      err_hdr_info.w3.addr2         = 0;
      err_hdr_info.w3.addr3         = 0;
    end

    return (err_hdr_info);
  endfunction

  virtual task do_pf_memwr_ur();
    reg_entry_t         reg_entry;
    sla_ral_reg         my_reg;
    Iosf::address_t     addr;
    sla_ral_data_t      ral_data;
    bit [7:0]           sai8;
    bit [3:0]           first_byte_en;
    hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;
    err_t               err_hdr_info;
    int                 pf_err_q_index;

    pf_memwr_ur_cnt++;

    fork
      begin
        get_reg(pf_mem_regs,reg_entry);
        my_reg = reg_entry.my_reg;
        addr = ral.get_addr_val(cfg.access_path,my_reg);
        if (reg_entry.allow_random_wr) begin
          ral_data = $urandom_range(32'hffffffff,32'h00000000);
        end else begin
          ral_data = my_reg.get();
        end

        sai8 = get_8bit_sai(my_reg.pick_legal_sai_value(RAL_WRITE));

        first_byte_en = $urandom_range(14,0);
        `ovm_info(get_type_name(),$psprintf("IOSF Primary MEM Write with error to %s.%s (address=0x%0x) data 0x%0x",my_reg.get_file_name(),my_reg.get_name(),addr,ral_data),OVM_LOW)

        err_hdr_info = gen_err_hdr_info(.err_type(UR),
                                        .addr(addr),
                                        .iosf_length(1),
                                        .first_byte_en(first_byte_en),
                                        .fmt((addr >= 64'h1_00000000) ? 3'b011 : 3'b010),
                                        .tlp_type(5'b00000),
                                        .ep(1'b0)
                                      );

        pf_err_q.err_q.push_back(err_hdr_info);

        pf_err_q_index = pf_err_q.err_q.size() - 1;

        `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(cfg.access_path), {iosf_addr == addr; iosf_data.size() == 1; iosf_data[0] == ral_data[31:0]; iosf_first_be == first_byte_en; iosf_sai == sai8;})

        pf_err_q.err_q[pf_err_q_index].w1.rid_u       = mem_write_seq.iosfTxn.reqID[15:8];
        pf_err_q.err_q[pf_err_q_index].w1.rid_l       = mem_write_seq.iosfTxn.reqID[7:0];
        pf_err_q.err_q[pf_err_q_index].w1.tag         = mem_write_seq.iosfTxn.tag[7:0];
        pf_err_q.err_q[pf_err_q_index].w0.tag9        = 1'b0;
        pf_err_q.err_q[pf_err_q_index].w0.tag8        = 1'b0;

        burst_sem.put(1);
      end
    join_none
  endtask

  virtual task do_pf_memwr_dpe();
    reg_entry_t         reg_entry;
    sla_ral_reg         my_reg;
    Iosf::address_t     addr;
    sla_ral_data_t      ral_data;
    bit [7:0]           sai8;
    bit [3:0]           first_byte_en;
    hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;
    err_t               err_hdr_info;
    int                 pf_err_q_index;

    pf_memwr_dpe_cnt++;

    fork
      begin
        get_reg(pf_mem_regs,reg_entry);
        my_reg = reg_entry.my_reg;
        addr = ral.get_addr_val(cfg.access_path,my_reg);
        if (reg_entry.allow_random_wr) begin
          ral_data = $urandom_range(32'hffffffff,32'h00000000);
        end else begin
          ral_data = my_reg.get();
        end

        sai8 = get_8bit_sai(my_reg.pick_legal_sai_value(RAL_WRITE));

        `ovm_info(get_type_name(),$psprintf("IOSF Primary MEM Write with EP bit set to %s.%s (address=0x%0x) data 0x%0x",my_reg.get_file_name(),my_reg.get_name(),addr,ral_data),OVM_LOW)

        err_hdr_info = gen_err_hdr_info(.err_type(PTLPR),
                                        .addr(addr),
                                        .iosf_length(1),
                                        .first_byte_en(4'b1111),
                                        .fmt((addr >= 64'h1_00000000) ? 3'b011 : 3'b010),
                                        .tlp_type(5'b00000),
                                        .ep(1'b1)
                                      );

        pf_err_q.err_q.push_back(err_hdr_info);

        pf_err_q_index = pf_err_q.err_q.size() - 1;

        `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(cfg.access_path), {iosf_addr == addr; iosf_data.size() == 1; iosf_data[0] == ral_data[31:0]; iosf_EP == 1; iosf_sai == sai8;})

        pf_err_q.err_q[pf_err_q_index].w1.rid_u       = mem_write_seq.iosfTxn.reqID[15:8];
        pf_err_q.err_q[pf_err_q_index].w1.rid_l       = mem_write_seq.iosfTxn.reqID[7:0];
        pf_err_q.err_q[pf_err_q_index].w1.tag         = mem_write_seq.iosfTxn.tag[7:0];
        pf_err_q.err_q[pf_err_q_index].w0.tag9        = 1'b0;
        pf_err_q.err_q[pf_err_q_index].w0.tag8        = 1'b0;

        burst_sem.put(1);
      end
    join_none
  endtask

  virtual task do_pf_memwr_mtlp();
    reg_entry_t         reg_entry;
    sla_ral_reg         my_reg;
    Iosf::address_t     addr;
    sla_ral_data_t      ral_data;
    bit [7:0]           sai8;
    bit [3:0]           first_byte_en;
    hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;
    err_t               err_hdr_info;
    int                 pf_err_q_index;

    pf_memwr_mtlp_cnt++;

    fork
      begin
        get_reg(pf_mem_regs,reg_entry);
        my_reg = reg_entry.my_reg;
        addr = ral.get_addr_val(cfg.access_path,my_reg);
        ral_data = $urandom_range(32'hffffffff,32'h00000000);

        sai8 = get_8bit_sai(my_reg.pick_legal_sai_value(RAL_WRITE));

        `ovm_info(get_type_name(),$psprintf("IOSF Primary MEM Write (malformed packet - length > 128) %s.%s (address=0x%0x) data 0x%0x",my_reg.get_file_name(),my_reg.get_name(),addr,ral_data),OVM_LOW)

        err_hdr_info = gen_err_hdr_info(.err_type(MTLP),
                                        .addr(addr),
                                        .iosf_length(129),
                                        .first_byte_en(4'b1111),
                                        .last_byte_en(4'b1111),
                                        .fmt((addr >= 64'h1_00000000) ? 3'b011 : 3'b010),
                                        .tlp_type(5'b00000),
                                        .ep(1'b0)
                                      );

        pf_err_q.err_q.push_back(err_hdr_info);

        pf_err_q_index = pf_err_q.err_q.size() - 1;

        `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(cfg.access_path), {iosf_addr == addr; iosf_data.size() == 129; iosf_data[0] == ral_data[31:0]; iosf_EP == 0; iosf_sai == sai8;})

        pf_err_q.err_q[pf_err_q_index].w1.rid_u       = mem_write_seq.iosfTxn.reqID[15:8];
        pf_err_q.err_q[pf_err_q_index].w1.rid_l       = mem_write_seq.iosfTxn.reqID[7:0];
        pf_err_q.err_q[pf_err_q_index].w1.tag         = mem_write_seq.iosfTxn.tag[7:0];
        pf_err_q.err_q[pf_err_q_index].w0.tag9        = 1'b0;
        pf_err_q.err_q[pf_err_q_index].w0.tag8        = 1'b0;

        burst_sem.put(1);
      end
    join_none
  endtask

  virtual task do_pf_memrd();
    reg_entry_t         reg_entry;
    sla_ral_reg         my_reg;
    Iosf::address_t     addr;
    sla_ral_data_t      ral_data;
    sla_ral_data_t      exp_ral_data;
    bit [7:0]           sai8;
    int                 iosf_length_in;
    hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;

    pf_memrd_cnt++;

    fork
      begin
        get_reg(pf_mem_regs,reg_entry);
        my_reg = reg_entry.my_reg;
        addr = ral.get_addr_val(cfg.access_path,my_reg);

        sai8 = get_8bit_sai(my_reg.pick_legal_sai_value(RAL_READ));

        exp_ral_data = my_reg.get();
        `ovm_info(get_type_name(),$psprintf("Issue IOSF Primary MEM Read to %s.%s (address=0x%0x), expect data=0x%0x",my_reg.get_file_name(),my_reg.get_name(),addr,exp_ral_data),OVM_LOW)
        `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(cfg.access_path), {iosf_addr == addr; iosf_sai == sai8; iosf_wait_for_completion == wait_for_completion;})

        if (wait_for_completion && !cfg.ignore_read_mismatch) begin
          if (mem_read_seq.iosf_cpl_status != 3'b000) begin
            `ovm_error(get_type_name(),$psprintf("Unexpected error completion (%d) for IOSF Primary Memory Read to %s (address=0x%0x)",mem_read_seq.iosf_cpl_status,my_reg.get_name(),addr))
          end else begin
            ral_data = mem_read_seq.iosf_data;
            `ovm_info(get_type_name(),$psprintf("IOSF Primary MEM Read to %s.%s (address=0x%0x) data 0x%0x",my_reg.get_file_name(),my_reg.get_name(),addr,ral_data),OVM_LOW)
            if (ral_data !== exp_ral_data) begin
              `ovm_error(get_type_name(),$psprintf("IOSF Primary MEM Read to %s (address=0x%0x) expected data=0x%0x received data=0x%0x",my_reg.get_name(),addr,exp_ral_data,ral_data))
            end
          end
        end

        burst_sem.put(1);
      end
    join_none
  endtask

  virtual task do_pf_memrd_ur();
    reg_entry_t         reg_entry;
    sla_ral_reg         my_reg;
    Iosf::address_t     addr;
    sla_ral_data_t      ral_data;
    sla_ral_data_t      exp_ral_data;
    bit [7:0]           sai8;
    int                 iosf_length_in;
    hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
    err_t               err_hdr_info;
    int                 pf_err_q_index;

    pf_memrd_ur_cnt++;

    fork
      begin
        get_reg(pf_mem_regs,reg_entry);
        my_reg = reg_entry.my_reg;
        addr = ral.get_addr_val(cfg.access_path,my_reg);

        sai8 = get_8bit_sai(my_reg.pick_legal_sai_value(RAL_READ));

        exp_ral_data = my_reg.get();
        `ovm_info(get_type_name(),$psprintf("Issue IOSF Primary MEM Read to %s.%s (address=0x%0x), expect data=0x%0x",my_reg.get_file_name(),my_reg.get_name(),addr,exp_ral_data),OVM_LOW)
        if (addr[11:0] == 12'hffc) begin
          iosf_length_in = 0;
        end else if (addr[11:0] > 12'he00) begin
          iosf_length_in = $urandom_range((1024 - addr[11:2]),2);
        end else begin
          iosf_length_in = $urandom_range(128,2);
        end

        err_hdr_info = gen_err_hdr_info(.err_type(UR),
                                        .addr(addr),
                                        .iosf_length(iosf_length_in),
                                        .first_byte_en((iosf_length_in > 0) ? 4'b1111 : 4'b0000),
                                        .last_byte_en((iosf_length_in > 1) ? 4'b1111 : 4'b0000),
                                        .fmt((addr >= 64'h1_00000000) ? 3'b001 : 3'b000),
                                        .tlp_type(5'b00000),
                                        .ep(1'b0)
                                      );

        pf_err_q.err_q.push_back(err_hdr_info);

        pf_err_q_index = pf_err_q.err_q.size() - 1;

        `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(cfg.access_path), {iosf_addr == addr; iosf_length == iosf_length_in; iosf_sai == sai8; iosf_exp_error == 1'b1; iosf_wait_for_completion == wait_for_completion;})

        pf_err_q.err_q[pf_err_q_index].w1.rid_u       = mem_read_seq.iosfTxn.reqID[15:8];
        pf_err_q.err_q[pf_err_q_index].w1.rid_l       = mem_read_seq.iosfTxn.reqID[7:0];
        pf_err_q.err_q[pf_err_q_index].w1.tag         = mem_read_seq.iosfTxn.tag[7:0];
        pf_err_q.err_q[pf_err_q_index].w0.tag9        = mem_read_seq.iosfTxn.tag[9];
        pf_err_q.err_q[pf_err_q_index].w0.tag8        = mem_read_seq.iosfTxn.tag[8];

        if (wait_for_completion && !cfg.ignore_read_mismatch) begin
          if (mem_read_seq.iosf_cpl_status != 3'b001) begin
            `ovm_error(get_type_name(),$psprintf("Expected UR(1), received completion %d for IOSF Primary Memory Read to %s (address=0x%0x)",mem_read_seq.iosf_cpl_status,my_reg.get_name(),addr))
          end else begin
            ral_data = mem_read_seq.iosf_data;
            `ovm_info(get_type_name(),$psprintf("IOSF Primary MEM Read to %s.%s (address=0x%0x, length=0x%0x) received expected UR completion",my_reg.get_file_name(),my_reg.get_name(),addr,iosf_length_in),OVM_LOW)
          end
        end

        burst_sem.put(1);
      end
    join_none
  endtask

  virtual task do_pf_flr();
    Iosf::address_t     addr;
    sla_ral_data_t      ral_data;
    bit [7:0]           sai8;
    hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_wr_seq        cfg_write_seq;
    int                 my_reg_size;

    pf_flr_cnt++;
    pf_flr_time = $realtime()/1ns;

    wait_for_completion = 0;

    pf_hcw_token_cnt = 0;

    fork
      begin
        addr = ral.get_addr_val(cfg.access_path,pf_pcie_cap_device_control_reg);
        my_reg_size = pf_pcie_cap_device_control_reg.get_size();
        ral_data = 32'h00008000;

        sai8 = get_8bit_sai(pf_pcie_cap_device_control_reg.pick_legal_sai_value(RAL_WRITE));

        `ovm_info(get_type_name(),$psprintf("PF FLR - IOSF Primary CFG Write to %s.%s (address=0x%0x) data 0x%0x",
                                            pf_pcie_cap_device_control_reg.get_file_name(),
                                            pf_pcie_cap_device_control_reg.get_name(),
                                            addr,
                                            ral_data),OVM_LOW)
        `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(cfg.access_path), {iosf_addr == addr; reg_size == my_reg_size; iosf_data == ral_data[31:0]; iosf_sai == sai8;})
        if (cfg_write_seq.iosf_cpl_status != 3'b000) begin
          `ovm_error(get_type_name(),$psprintf("Unexpected error completion (%d) for IOSF Primary CFG Write to %s (address=0x%0x)",
                                               cfg_write_seq.iosf_cpl_status,
                                               pf_pcie_cap_device_control_reg.get_name(),
                                               addr))
        end

        i_hcw_scoreboard.hcw_scoreboard_reset();
        ral.reset_regs();
        i_hqm_iosf_prim_mon.cq_gen_reset();

        burst_sem.put(1);
      end
    join_none
  endtask

  virtual task do_pf_hcw(bit with_error = 1'b0);
    int batch_size;
    bit [7:0]           sai8;

    batch_size = $urandom_range(cfg.max_batch_size,cfg.min_batch_size);

    pf_hcw_cnt++;

    sai8 = get_8bit_sai(with_error ? pf_mem_regs[0].my_reg.pick_illegal_sai_value(RAL_WRITE) : pf_mem_regs[0].my_reg.pick_legal_sai_value(RAL_WRITE));

    for (int i = 1 ; i <= batch_size ; i++) begin
      //--
      if(!cfg.sai_check_on_hcw_write) with_error=0;
      do_hcw(.ingress_drop(with_error),.sai8(sai8),.hcw_batch((i == batch_size) ? 1'b0 : 1'b1));
      if ((with_error == 1'b0) && (pf_flr_time == 0)) begin
        pf_hcw_token_cnt++;
      end
    end

    burst_sem.put(1);
  endtask

  task do_pf_hcw_token_ret();
    bit [7:0]           sai8;

    sai8 = get_8bit_sai(pf_mem_regs[0].my_reg.pick_legal_sai_value(RAL_WRITE));

    do_hcw(.sai8(sai8),.qe_valid(1'b0), .tok_ret_cnt(pf_hcw_token_cnt));
    pf_hcw_token_cnt = 0;
  endtask

  virtual task do_hcw(bit ingress_drop = 1'b0, bit [7:0] sai8, bit qe_valid = 1, int tok_ret_cnt = 0, bit hcw_batch = 0);
    hcw_transaction     hcw_trans;
    bit [127:0]         hcw_data_bits;
    bit [63:0]          pp_addr;
    hqm_hcw_enq_seq     hcw_enq_seq;
    sla_ral_data_t      ral_data;

    hcw_trans = hcw_transaction::type_id::create("hcw_trans");

    hcw_trans.randomize();

    hcw_trans.rsvd0                     = '0;
    hcw_trans.dsi_error                 = '0;
    hcw_trans.cq_int_rearm              = '0;
    hcw_trans.no_inflcnt_dec            = '0;
    hcw_trans.dbg                       = '0;
    hcw_trans.cmp_id                    = '0;
    hcw_trans.is_vf                     = '0;
    hcw_trans.vf_num                    = '0;
    hcw_trans.sai                       = sai8;
    hcw_trans.rtn_credit_only           = '0;
    hcw_trans.exp_rtn_credit_only       = '0;
    hcw_trans.ingress_drop              = ingress_drop;
    hcw_trans.exp_ingress_drop          = ingress_drop;
    hcw_trans.meas                      = '0;
    hcw_trans.ordqid                    = '0;
    hcw_trans.ordpri                    = '0;
    hcw_trans.ordlockid                 = '0;
    hcw_trans.ordidx                    = '0;
    hcw_trans.reord                     = '0;
    hcw_trans.frg_cnt                   = '0;
    hcw_trans.frg_last                  = '0;

    hcw_trans.qe_valid                  = qe_valid;
    hcw_trans.qe_orsp                   = 0;
    hcw_trans.qe_uhl                    = 0;
    hcw_trans.cq_pop                    = (tok_ret_cnt > 0) ? 1 : 0;
    hcw_trans.is_ldb                    = 0;
    hcw_trans.ppid                      = 0;
    hcw_trans.qtype                     = QDIR;
    hcw_trans.qid                       = 0;
    hcw_trans.qpri                      = 0;
    hcw_trans.lockid                    = tok_ret_cnt - 1;
    hcw_trans.msgtype                   = 0;
    hcw_trans.idsi                      = 0;
     
    hcw_trans.hcw_batch                 = hcw_batch;

    hcw_trans.tbcnt                     = hcw_trans.get_transaction_id();

    hcw_trans.iptr                      = hcw_trans.tbcnt;

    if (hcw_trans.reord == 0)
      hcw_trans.ordidx = hcw_trans.tbcnt;

    hcw_trans.enqattr = 2'h0;   
    hcw_trans.sch_is_ldb = (hcw_trans.qtype == QDIR)? 1'b0 : 1'b1;
    if (hcw_trans.qe_valid == 1 && hcw_trans.qtype != QORD ) begin
      if (hcw_trans.qtype == QDIR ) begin
        hcw_trans.enqattr = 2'h0;      
      end else begin
        hcw_trans.enqattr[1:0] = {hcw_trans.qe_orsp, hcw_trans.qe_uhl};        
      end                      
    end
    
    //----    
    //-- hcw_trans.isdir is hidden info in ptr
    //----    
    if(hcw_trans.qtype == QDIR) hcw_trans.isdir=1;
    else                   hcw_trans.isdir=0;
    
    hcw_trans.set_hcw_trinfo(1);           //--kind=1: do not set iptr[63:48]=tbcnt
    
    //-- pass hcw_item to sb
    i_hqm_cfg.write_hcw_gen_port(hcw_trans);
    
    hcw_trans.hcw_batch         = 1'b0;

    hcw_data_bits = hcw_trans.byte_pack(0);
    
    pp_addr = 64'h0000_0000_0200_0000;
    
    ral_data = func_bar_u_reg.get_actual();
    
    pp_addr[63:32] = ral_data[31:0];
    
    ral_data = func_bar_l_reg.get_actual();
    
    pp_addr[31:26] = ral_data[31:26];
  
    pp_addr[19:12] = hcw_trans.ppid;
    pp_addr[20]    = hcw_trans.is_ldb;
    pp_addr[21]    = hcw_trans.is_nm_pf;
    pp_addr[9:6]   = 4'h0;
  
    `ovm_info(get_full_name(), $psprintf("HCW hcw.sai(0x%0x), ingress_drop(%0d) with cfg.sai_check_on_hcw_write(%0d)", hcw_trans.sai, ingress_drop, cfg.sai_check_on_hcw_write), OVM_LOW);

    if (qe_valid && !ingress_drop) begin
      i_hqm_pp_cq_status.wait_for_vas_credit(0);
    end

    `ovm_info(get_type_name(),"Sending HCW transaction",OVM_LOW);
    hcw_trans.print();

    `ovm_create(hcw_enq_seq)
  
    `ovm_rand_send_with(hcw_enq_seq, { 
                                         pp_enq_addr == pp_addr;
                                         sai == hcw_trans.sai;
                                         hcw_enq_q.size == 1;
                                         hcw_enq_q[0] == hcw_data_bits;
                                     })
      
  endtask

  virtual task do_idle(int burst_size, int addl_delay = 0);
    int delay_ns = (burst_size + addl_delay) * 1.25;

    burst_sem.get(burst_size);
    #150ns;

    for (int i = 0 ; i < delay_ns ; i++) begin
      #1ns;
    end

    while (!i_hcw_scoreboard.hcw_scoreboard_idle()) begin
      #5ns;
    end
  endtask

  virtual function void add_reg(string reg_name, int file_index = -1, int reg_index = -1, bit allow_random_wr, ref reg_entry_t regs[$]);
    reg_entry_t       reg_entry;
    sla_ral_reg       my_reg;
    string            explode_q[$];
    string            expanded_file_name;
    string            expanded_reg_name;

    explode_q.delete();
    lvm_common_pkg::explode(".",reg_name,explode_q,2);

    if (file_index >= 0) begin
      expanded_file_name = $psprintf("%s[%0d]",explode_q[0],file_index);
    end else begin
      expanded_file_name = explode_q[0];
    end

    if (reg_index >= 0) begin
      expanded_reg_name = $psprintf("%s[%0d]",explode_q[1],reg_index);
    end else begin
      expanded_reg_name = explode_q[1];
    end

    my_reg   = ral.find_reg_by_file_name(expanded_reg_name, expanded_file_name);

    if (my_reg != null) begin
      reg_entry.my_reg = my_reg;
      reg_entry.allow_random_wr = allow_random_wr;
      regs.push_back(reg_entry);
    end
  endfunction

  virtual task populate_regs();
    // pf_cfg_regs

    foreach (pf_cfg_regs_change_list[i]) begin
      add_reg(.reg_name(pf_cfg_regs_change_list[i]), .allow_random_wr(1), .regs(pf_cfg_regs));
    end

    foreach (pf_cfg_regs_no_change_list[i]) begin
      add_reg(.reg_name(pf_cfg_regs_no_change_list[i]), .allow_random_wr(0), .regs(pf_cfg_regs));
    end

    func_bar_u_reg = ral.find_reg_by_file_name("func_bar_u", "hqm_pf_cfg_i");
    func_bar_l_reg = ral.find_reg_by_file_name("func_bar_l", "hqm_pf_cfg_i");
    pf_pcie_cap_device_control_reg = ral.find_reg_by_file_name("pcie_cap_device_control", "hqm_pf_cfg_i");
    pf_aer_cap_control = ral.find_reg_by_file_name("aer_cap_control", "hqm_pf_cfg_i");
    pf_aer_cap_uncorr_err_status = ral.find_reg_by_file_name("aer_cap_uncorr_err_status", "hqm_pf_cfg_i");
    for (int i = 0 ; i < 4 ; i++) begin
      pf_aer_cap_header_log[i] = ral.find_reg_by_file_name($psprintf("aer_cap_header_log_%0d",i), "hqm_pf_cfg_i");
    end

    // pf_mem_regs

    foreach (pf_mem_regs_change_list[i]) begin
      add_reg(.reg_name(pf_mem_regs_change_list[i]), .allow_random_wr(1'b1), .regs(pf_mem_regs));
    end

    foreach (pf_mem_regs_no_change_list[i]) begin
      add_reg(.reg_name(pf_mem_regs_no_change_list[i]), .allow_random_wr(1'b0), .regs(pf_mem_regs));
    end

    add_reg(.reg_name("hqm_msix_mem.msg_addr_l"), .reg_index($urandom_range(71,8)), .allow_random_wr(1'b1), .regs(pf_mem_regs));

    add_reg(.reg_name("hqm_system_csr.aw_smon_compare0"), .reg_index($urandom_range(1,0)), .allow_random_wr(1'b1), .regs(pf_mem_regs));

    add_reg(.reg_name($psprintf("hqm_system_csr.perf_smon_compare%0d",$urandom_range(1,0))), .allow_random_wr(1'b1), .regs(pf_mem_regs));

    add_reg(.reg_name($psprintf("list_sel_pipe.cfg_smon_compare%0d",$urandom_range(1,0))), .allow_random_wr(1'b1), .regs(pf_mem_regs));

  endtask

endclass : hqm_system_error_burst_user_data_seq
