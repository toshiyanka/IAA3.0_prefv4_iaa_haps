// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
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
// File   : hqm_pp_cq_base_seq.sv
//
// Description :
//
//-- file format: qtypecode, ppid, reord, frgnum, is_ldb_credit, is_carry_uhl, is_carry_tkn, is_multi_tkn
// -----------------------------------------------------------------------------
`ifndef HCW_PP_CQ_BASE_SEQ__SV
`define HCW_PP_CQ_BASE_SEQ__SV

import hcw_transaction_pkg::*;
import lvm_common_pkg::*;
import hqm_cfg_pkg::*;

class rand_cyclic_array extends uvm_sequence;
  randc bit [6:0]               rand_exp;
  constraint c_rand_exp {
     rand_exp       >= 0;   
     rand_exp       <= 99;   
  }
endclass


class hqm_pp_cq_base_seq extends uvm_sequence;

  `uvm_object_utils(hqm_pp_cq_base_seq) 

  `uvm_declare_p_sequencer(slu_sequencer)

  typedef enum bit {
    IS_DIR,
    IS_LDB
  } pp_cq_type_t;
    
  typedef enum {
    NOOP_CMD,
    BAT_T_CMD,
    RELS_CMD,
    COMP_CMD,
    A_COMP_CMD,
    COMP_T_CMD,
    A_COMP_T_CMD,
    NEW_CMD,
    NEW_T_CMD,
    RENQ_CMD,
    RENQ_T_CMD,
    FRAG_CMD,
    FRAG_T_CMD,
    ARM_CMD,
    ILLEGAL_CMD
  } hcw_cmd_type_t;

  typedef enum {
    NO_ILLEGAL,
    BURST_ILLEGAL,
    RAND_ILLEGAL
  } illegal_hcw_gen_mode_t;

  typedef enum {
    NORMAL_DIST,
    POISSON_DIST
  } hcw_delay_rand_type_t;

  typedef enum {
    ILLEGAL_HCW_CMD,
    ALL_0,
    ALL_1,
    ILLEGAL_PP_NUM,             // ingress drop
    ILLEGAL_PP_TYPE,            // return credit only
    ILLEGAL_QID_NUM,            // return credit only
    ILLEGAL_QID_TYPE,           // return credit only (not configured for ATM qtype)
    ILLEGAL_DEV_VF_NUM,         // ingress drop
    ILLEGAL_DIRPP_RELS,         // ingress drop
    QID_GRT_127,                // return credit only
    VAS_WRITE_PERMISSION,       // return credit only
    CVAS_WRITE_PERMISSION       // return credit only
  } illegal_hcw_type_t;

  typedef       struct {
    int                         num_hcw;
    int                         num_loop;
    int                         num_hcw_loop;
    int                         hcw_time;
    bit                         comp_flow;
    bit                         a_comp_flow;
    bit                         cq_token_return_flow;
    int                         qid;
    hcw_qtype                   qtype;
    hcw_delay_rand_type_t       hcw_delay_type;
    int                         hcw_delay_min;
    int                         hcw_delay_max;
    int                         hcw_delay_rem;
    bit                         hcw_delay_qe_only;
    bit                         inc_lock_id;
    bit [15:0]                  lock_id;
    bit                         is_nm_pf;
    bit [15:0]                  dsi;
    bit [63:0]                  tbcnt_offset;
    illegal_hcw_gen_mode_t      illegal_hcw_gen_mode;
    illegal_hcw_type_t          illegal_hcw_type_q[$];
    int                         illegal_hcw_burst_len;
    int                         illegal_hcw_prob;
    int                         illegal_token_return_prob;
    bit                         illegal_token_return_active;
    int                         illegal_token_return_burst_len;
    int                         illegal_comp_prob;
    bit                         illegal_comp_active;
    int                         illegal_comp_burst_len;
    int                         illegal_credit_prob;
    int                         legal_hcw_count;
    int                         illegal_hcw_count;
    int                         illegal_num_hcw;
    int                         cmd_count[hcw_cmd_type_t];
    int                         qpri_weight[8];
  } pp_dest_qid_t;

  string                        inst_suffix = "";       // Used to identify instance of HQM in DUT
  string                        tb_env_hier     = "*";

  rand  int                     pp_cq_num;              // Producer Port/Consumer Queue number
  rand  pp_cq_type_t            pp_cq_type;             // Producer Port/Consumer Queue type

  rand  bit                     is_nm_pf;               // Producer Port/Consumer Queue uses non-maskable PF PP

  rand  bit                     is_vf;                  // Producer Port/Consumer Queue part of Virtual Function
  rand  int                     vf_num;                 // Producer Port/Consumer Queue Virtual Function number

  rand  pp_dest_qid_t           queue_list[];           // List of target queues (generated in parallel)

        int                     cq_intr_process_delay;  // Delay between reading CQ buffer and receiving CQ interrupt  
        int                     cq_intr_process_ctrl;   // keep reading CQ buffer after receiving CQ interrupt until get cq_gen 

  rand  int                     tok_return_delay_mode;  // 0 - use token return delay queue 1 time
                                                        // 1 - recycle through token return delay queue
                                                        // 2 - wait for msix int to enable token return (do not wait for msix after first delay)
  rand  int                     comp_return_delay_mode; // 0 - use completion return delay queue 1 time
                                                        // 1 - recycle through completion return delay queue
                                                        // 2 - wait for msix int to enable completion return (do not wait for msix after first delay)

  rand  int                     a_comp_return_delay_mode; // 0 - use completion return delay queue 1 time
                                                        // 1 - recycle through completion return delay queue
                                                        // 


  rand  int                     hcw_enqueue_claddrctl_min;  // Cacheline Addr control:  1: incr; 2:fixed ; else : rnd 
  rand  int                     hcw_enqueue_claddrctl_max;  // 
  rand  int                     hcw_enqueue_cl_pad;         // When last_hcw=1 (sticky), 1: padding to form one cache-line

  rand  int                     hcw_enqueue_batch_min;  // Minimum number of HCWs to send as a batch (1-4)
  rand  int                     hcw_enqueue_batch_max;  // Maximum number of HCWs to send as a batch (1-4)

  rand  int                     hcw_enqueue_wu_min;     // Minimum WU value
  rand  int                     hcw_enqueue_wu_max;     // Maximum WU value

  rand  int                     hcw_enqueue_pad_prob_min;     // Minimum NOOP PAD prob value
  rand  int                     hcw_enqueue_pad_prob_max;     // Maximum NOOP PAD prob value

  rand  int                     hcw_enqueue_expad_prob_min;     // Minimum extra NOOP PAD prob value
  rand  int                     hcw_enqueue_expad_prob_max;     // Maximum extra NOOP PAD prob value

  rand  bit [63:0]              cq_addr;

  rand  int                     cq_depth;               // CQ depth - number of HCWs CQ buffer will hold

  rand  int                     cq_poll_interval;       // ns between checking CQ

  rand  bit [63:0]              ims_poll_addr;

  rand  int                     msi_int_num;            // if set handle specified msi interrupt (used when fewer than 32 MSI interrupts are available) and determine associated CQ interrupt

  rand  int                     queue_list_delay_min;
  rand  int                     queue_list_delay_max;

  rand  int                     new_hcw_en_delay_min;
  rand  int                     new_hcw_en_delay_max;

  rand  int                     hcw_delay_ctrl_mode;

  rand  int                     credits_used;           // number of credits used (initialized to negative the initial credit count)

  rand int                      comp_weight;
  rand int                      new_weight;

  rand int                      mon_watchdog_timeout;   // Timeout value for watchdog
  rand int                      sb_watchdog_timeout;    // Timeout value for scoreboard watchdog

  rand int                      hcw_lockid_ctrl;        // support ATM

  //----------------------- HQMV30 AO
  int cq_comp_service_state;    //--0: ready to send A_COMP; 1: wait for COMP sent out, hold on A_COMP

  rand int                      hcw_acomp_ctrl;         // suport a_comp return control

  bit                           is_vdev;                // Producer Port/Consumer Queue part of Virtual Device (SCIOV mode)
  int                           vdev_num;               // Producer Port/Consumer Queue Virtual Device number (SCIOV mode)

  int                           hcw_enqueue_batch_cnt;  // Number of HCWs remaining in batch
  semaphore                     hcw_enqueue_batch_sem;

  int                           tok_return_delay_q[$];  // Queue of token return delays - first entry is initial delay, second entry is time to allow, third delays, ...
  int                           comp_return_delay_q[$]; // Queue of completion return delays - first entry is initial delay, second entry is time to allow, third delays, ...
  int                           a_comp_return_delay_q[$]; // Queue of A_COMP completion return delays - first entry is initial delay, second entry is time to allow, third delays, ...

  bit                           tok_return_delay;       // Delay token returns if set
  bit                           comp_return_delay;      // Delay completion returns if set
  bit                           a_comp_return_delay;    // Delay A_COMP completion returns if set

  int                           credit_avail;

  int                           renq_credits_rsvd;

  int                           total_sch_count;

  int                           total_tok_return_count;
  int                           total_comp_return_count;
  int                           total_a_comp_return_count;

  hcw_transaction               pend_hcw_trans[$];
  hcw_transaction               pend_hcw_trans_comb[$];

  lvm_queue                     pend_cq_token_return;   // number of pending token returns

  int                           pend_cq_int_arm[$];     // need to do CQ interrupt arm

  lvm_queue                     pend_comp_return;       // number of pending COMP completions available to be returned
  lvm_queue                     pend_a_comp_return;     // number of pending ACOMP completions available to be returned

  semaphore                     hcw_gen_sem;

  bit                           pend_cq_int;

  int                           pf_pp_cq_num;           // PF Producer Port/Consumer Queue number

  int                           cq_index;               // Index into CQ buffer for next CQ entry (increment by 1 for each HCW)
  bit                           cq_gen;                 // Generation bit expected for next CQ entry

  static int                    active_seq_cnt = 0;     // Number of instance of this sequence active
  static bit                    active_seq_cnt_rst = 1'b_0; // -- Reset active_seq_cnt (done when FLR applied with HCW processing 'ON') 
  int                           active_gen_queue_list_cnt = 0;     // Number of gen_queue_list threads

  int                           cycle_count;            //
  event                         cycle_count_ev;         //

  bit                           do_force_seq_stop;      // Set to force sequence to stop, ignoring scoreboard state
  bit                           mon_enable;             // Enable monitor tasks while this bit is set
  int                           mon_watchdog;           // Watchdog to turn off mon_watchdog
  int                           sb_watchdog;            // Watchdog to turn off mon_watchdog
  semaphore                     mon_sem;                // Semaphore to update mon_watchdog

  mailbox                       in_hcw_delay_mbox;      // Count threads in hcw_delay()

  uvm_reg_block                 ral;
  uvm_reg_block                 hqm_pf_cfg_i; 
  slu_sm_env                    sm;

  uvm_reg_block                 hqm_system_csr_file;
  uvm_reg                       dir_cq_msix_status_reg[2];
  uvm_reg                       ldb_cq_msix_status_reg[2];
  uvm_reg                       msix_ack_reg;
  slu_ral_sai_t                 cq_msix_status_legal_read_sai;
  slu_ral_sai_t                 cq_msix_status_legal_write_sai;
  slu_ral_sai_t                 msix_ack_legal_write_sai;
  uvm_reg                       func_bar_u;
  uvm_reg                       func_bar_l;

  hqm_pp_cq_status              i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed
  hqm_cfg                       i_hqm_cfg;
  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;
  bit [63:0]                    tbcnt_base;
  int                           gen_freq;
  int                           cmd_type_sel;
  bit                           hcw_rsvd0_random = $test$plusargs("HQM_HCW_RSVD0_RANDOM");
  bit                           hcw_meas_on      = $test$plusargs("HQM_ENQ_TS");
  bit                           dis_random_sai   = $test$plusargs("HQM_DIS_RANDOM_SAI");
  int                           hcw_dsi_ctrl;
  int                           do_backdoor_read;
  int                           do_backdoor_write;
  int                           seq_sch_out_mode;

  int                           vas;

  bit [63:0]                    pp_addr;

  bit [127:0]                   hcw_q[$];

  rand int                      hqm_lsp_qid_ck_congest; 
  rand int                      hqm_lsp_qid_congest;              
  bit [1:0]                     hqm_lsp_qid_depth_prev;   
  bit                           hqm_lsp_qid_depth_init_lock; 
  int                           hqm_lsp_qid_depth_init_lock_cnt;
  int                           hqm_lsp_qid_congest_mismatch_cnt;   

  uvm_event_pool                glbl_pool;
  uvm_event                     exp_msi;

  rand_cyclic_array             randcyc_hcw_prob;
  rand_cyclic_array             randcyc_crd_prob;
  rand_cyclic_array             randcyc_comp_prob;
  rand_cyclic_array             randcyc_tok_prob;

  rand int                      hqm_stream_ctl;        //--when hqm_stream_ctl=1:  in hqm_stream_flow_state=1 stage, when there is no comp (LDB) or token(DIR) available, don't send ENQ;
                                                       //--when hqm_stream_ctl=2:  in hqm_stream_flow_state=1 stage, when there is no comp (LDB) or token(DIR) available, still send ENQ; 
  int                           hqm_stream_flow_state; //--when hqm_stream_ctl>0:  hqm_stream_flow_state=0 (NEW) until num_hcw reached; hqm_stream_flow_state=1 (RENQ_T or NEW_T) num_hcw_loop reached; hqm_stream_flow_state=2 (COMP_T or BAT_T)
  int                           trf_num_hcw;
  int                           trf_num_loop;
  int                           trf_hcw_cnt;

  //--this is to support read REMAPPED INTR from sm
  bit [63:0]                    intr_remap_addr;


  //-- Cacheline incr addr
  bit [3:0]                     pp_cacheline_addr;

  //-- pp_max_cacheline_num
  rand int                      pp_max_cacheline_num_max;    
  rand int                      pp_max_cacheline_num_min;    
 
  rand int                      pp_max_cacheline_pad_max;    
  rand int                      pp_max_cacheline_pad_min;    

  rand int                      pp_max_cacheline_shuffle_max;    
  rand int                      pp_max_cacheline_shuffle_min;    

  bit                           sciov_ignore_v;

  // default to DIR PP/CQ 0
  constraint c_pp_cq_soft {
    soft pp_cq_num      == 0;   
    soft pp_cq_type     == IS_DIR;   
  }

  constraint c_pp_cq {
    if (pp_cq_type == IS_DIR) {
      pp_cq_num >= 0;
      pp_cq_num <= 127;
    } else {
      pp_cq_num >= 0;
      pp_cq_num <= 63;
    }
  }

  constraint c_is_nm_pf_soft {
    soft is_nm_pf  == 0;   
  }

  constraint c_is_vf_soft {
    soft is_vf  == 0;   
  }

  constraint c_vf {
    solve is_vf before vf_num;

    if (is_vf) {
      vf_num >= 0;
      vf_num <= hqm_pkg::NUM_VF;
      is_nm_pf == 0;
    } else {
      vf_num == 0;
    }
  }

  constraint c_return_delay_mode_soft {
    soft tok_return_delay_mode  == 0;
    soft comp_return_delay_mode == 0;
    soft a_comp_return_delay_mode == 0;
  }

  constraint c_queue_list_size_soft {
    soft queue_list.size()   == 1;
  }

  constraint c_queue_list_size {
    queue_list.size()   >= 0;
    queue_list.size()   <= 256;
  }

  // default to single DIR QID 0
  constraint c_queue_list_soft {
    foreach (queue_list[i]) {
      soft queue_list[i].num_hcw                        == 1;
      soft queue_list[i].num_loop                       == 0;
      soft queue_list[i].num_hcw_loop                   == 0;
      soft queue_list[i].hcw_time                       == 0;
      soft queue_list[i].comp_flow                      == 1;
      soft queue_list[i].a_comp_flow                    == 1;
      soft queue_list[i].cq_token_return_flow           == 1;
      soft queue_list[i].qid                            == 0;
      soft queue_list[i].qtype                          == QDIR;
      soft queue_list[i].qpri_weight[0]                 == 1;
      soft queue_list[i].qpri_weight[1]                 == 0;
      soft queue_list[i].qpri_weight[2]                 == 0;
      soft queue_list[i].qpri_weight[3]                 == 0;
      soft queue_list[i].qpri_weight[4]                 == 0;
      soft queue_list[i].qpri_weight[5]                 == 0;
      soft queue_list[i].qpri_weight[6]                 == 0;
      soft queue_list[i].qpri_weight[7]                 == 0;
      soft queue_list[i].hcw_delay_type                 == NORMAL_DIST;
      soft queue_list[i].hcw_delay_min                  == 1;
      soft queue_list[i].hcw_delay_max                  == 1;
      soft queue_list[i].hcw_delay_rem                  == 0;
      soft queue_list[i].hcw_delay_qe_only              == 1;
      soft queue_list[i].inc_lock_id                    == 0;
      soft queue_list[i].lock_id                        == 0;
      soft queue_list[i].is_nm_pf                       == 0;
      soft queue_list[i].tbcnt_offset                   == 0;
      soft queue_list[i].illegal_hcw_burst_len          == 8;
      soft queue_list[i].illegal_hcw_gen_mode           == NO_ILLEGAL;
      soft queue_list[i].illegal_hcw_type_q.size()      == 0;
      soft queue_list[i].illegal_hcw_prob               == 100;
      soft queue_list[i].illegal_token_return_prob      == 0;
      soft queue_list[i].illegal_token_return_active    == 1'b0;
      soft queue_list[i].illegal_token_return_burst_len == 0;
      soft queue_list[i].illegal_comp_prob              == 0;
      soft queue_list[i].illegal_comp_active            == 1'b0;
      soft queue_list[i].illegal_comp_burst_len         == 0;
      soft queue_list[i].illegal_credit_prob            == 0;
      soft queue_list[i].illegal_num_hcw                == 0;
    }
  }

  constraint c_queue_list {
    foreach (queue_list[i]) {
      queue_list[i].num_hcw             >= 0;
      queue_list[i].num_loop            >= 0;
      queue_list[i].num_hcw_loop        >= 0;

      queue_list[i].hcw_time            >= 0;

      queue_list[i].qid                 >= 0;
      queue_list[i].qid                 <= 63;

      queue_list[i].hcw_delay_min       >= 0;
      queue_list[i].hcw_delay_max       >= 0;

      queue_list[i].hcw_delay_min       <= queue_list[i].hcw_delay_max;

      queue_list[i].hcw_delay_rem       == 0;

      queue_list[i].legal_hcw_count      == 0;
      queue_list[i].illegal_hcw_count    == 0;

      queue_list[i].illegal_hcw_burst_len       >= 0;

      queue_list[i].illegal_hcw_prob            >= 0;
      queue_list[i].illegal_hcw_prob            <= 100;

      queue_list[i].illegal_token_return_prob           >= 0;
      queue_list[i].illegal_token_return_prob           <= 100;

      queue_list[i].illegal_token_return_burst_len      >= 0;

      queue_list[i].illegal_comp_prob           >= 0;
      queue_list[i].illegal_comp_prob           <= 100;

      queue_list[i].illegal_comp_burst_len      >= 0;

      queue_list[i].illegal_credit_prob         >= 0;
      queue_list[i].illegal_credit_prob         <= 100;

      foreach (queue_list[i].cmd_count[t]) {
        queue_list[i].cmd_count[t]      == 0;
      }
    }
  }

  constraint c_queue_list_delay_soft {
    soft queue_list_delay_min   == 1;
    soft queue_list_delay_max   == 1;
    soft hcw_delay_ctrl_mode    == 0;
  }

  constraint c_queue_list_delay {
    queue_list_delay_min        >= 0;
    queue_list_delay_max        >= 0;
  }

  constraint c_newhcw_en_delay_soft {
    soft new_hcw_en_delay_min   == 1;
    soft new_hcw_en_delay_max   == 1;
  }

  constraint c_newhcw_en_delay_delay {
    new_hcw_en_delay_min        >= 0;
    new_hcw_en_delay_max        >= 0;
  }


  constraint c_hcw_enqueue_claddrctl_soft {
    soft hcw_enqueue_claddrctl_min == 1;   
    soft hcw_enqueue_claddrctl_max == 1;   
  }

  constraint c_hcw_enqueue_cl_pad_soft {
    soft hcw_enqueue_cl_pad == 0;
  }

  constraint c_hcw_enqueue_batch_soft {
    soft hcw_enqueue_batch_min == 1;   
    soft hcw_enqueue_batch_max == 1;   
  }

  constraint c_hcw_enqueue_batch {
    hcw_enqueue_batch_min >= 1;   
    hcw_enqueue_batch_min <= 4;   
    hcw_enqueue_batch_max >= 1;   
    hcw_enqueue_batch_max <= 4;   

    hcw_enqueue_batch_min <= hcw_enqueue_batch_max;
  }

  constraint c_hcw_enqueue_pad_prob_soft {
    soft hcw_enqueue_pad_prob_min == 0;   
    soft hcw_enqueue_pad_prob_max == 0;   
    soft hcw_enqueue_expad_prob_min == 0;   
    soft hcw_enqueue_expad_prob_max == 0;   
  }

  constraint c_hcw_enqueue_wu_soft {
    soft hcw_enqueue_wu_min == 0;   
    soft hcw_enqueue_wu_max == 0;   
  }

  constraint c_hcw_enqueue_wu {
    hcw_enqueue_wu_min >= 0;   
    hcw_enqueue_wu_min <= 3;   
    hcw_enqueue_wu_max >= 0;   
    hcw_enqueue_wu_max <= 3;   

    hcw_enqueue_wu_min <= hcw_enqueue_wu_max;
  }

  constraint c_cq_depth {
    if (pp_cq_type == IS_DIR) {
      cq_depth inside {4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096};
    } else {
      cq_depth inside {4, 8, 16, 32, 64, 128, 256, 512, 1024};
    }
  }

  constraint c_poll_interval_soft {
    soft cq_poll_interval               == 1;   
  }

  constraint c_poll_interval {
    cq_poll_interval               >= 0;   
  }

  constraint c_msi_int_num_soft {
    soft msi_int_num           == -1;
  }

  constraint c_gen_weights {
    soft comp_weight            == 1;
    soft new_weight             == 1;
  }

  constraint c_watchdog_soft {
    soft mon_watchdog_timeout   == 4000;
    soft sb_watchdog_timeout   == 10000;
  }

  constraint c_watchdog {
    soft mon_watchdog_timeout   > 0;
    soft sb_watchdog_timeout   > 0;
  }

  constraint c_lockidctrl {
    soft hcw_lockid_ctrl == 0;
    soft hcw_acomp_ctrl == -1;
  }


  constraint c_congest {
    soft hqm_lsp_qid_ck_congest == 0;
    soft hqm_lsp_qid_congest == 0;
  }

  constraint c_stream_ctl {
    soft hqm_stream_ctl == 0;
  }

  constraint c_max_cacheline_ctl {
    soft pp_max_cacheline_num_max == 1;
    soft pp_max_cacheline_num_min == 1;

    soft pp_max_cacheline_pad_max == 0;
    soft pp_max_cacheline_pad_min == 0;

    soft pp_max_cacheline_shuffle_max == 0;
    soft pp_max_cacheline_shuffle_min == 0;
  }

  //-------------------------
  //Function: new 
  //-------------------------
  function new(string name = "hqm_pp_cq_base_seq");
    uvm_object o_tmp;

    super.new(name); 

    pend_hcw_trans.delete();
    pend_hcw_trans_comb.delete();
    pend_cq_token_return        = new($psprintf("%s_cq_token_return",name));
    hcw_gen_sem                 = new(1);
    pend_comp_return            = new($psprintf("%s_comp_return",name));
    pend_a_comp_return          = new($psprintf("%s_a_comp_return",name));
    pend_cq_int                 = 0;
    hcw_enqueue_batch_cnt       = -1;
    hcw_enqueue_batch_sem       = new(1);
    cq_index                    = 0;
    cq_gen                      = 1;
    do_force_seq_stop           = 0;
    mon_enable                  = 1;
    mon_sem                     = new(1);
    in_hcw_delay_mbox           = new(0);
    credit_avail                = 0;
    renq_credits_rsvd           = 0;
    total_sch_count             = 0;
    total_tok_return_count      = 0;
    total_comp_return_count     = 0;
    total_a_comp_return_count   = 0;
    tok_return_delay            = 0;
    comp_return_delay           = 0;
    a_comp_return_delay         = 0;
    cycle_count                 = 0;
    active_gen_queue_list_cnt   = 0;
    //--congestion check qid
    hqm_lsp_qid_congest_mismatch_cnt=0;
    hqm_lsp_qid_depth_init_lock=0;
    hqm_lsp_qid_depth_init_lock_cnt=0;
    hqm_lsp_qid_depth_prev=3; //--direct test of congestion, start from 3 (depth> thres)
    randcyc_crd_prob            = new();
    randcyc_comp_prob           = new();
    randcyc_tok_prob            = new();
    randcyc_hcw_prob            = new();

    if($test$plusargs("HQM_ENQ_DSI_TS"))          hcw_dsi_ctrl=1; 
    else if($test$plusargs("HQM_ENQ_DSI_INCR"))   hcw_dsi_ctrl=2; 
    else if($test$plusargs("HQM_ENQ_DSI_DECR"))   hcw_dsi_ctrl=3; 
    else                                          hcw_dsi_ctrl=0;  

    hqm_stream_flow_state = 0;
    trf_hcw_cnt = 0;
    pp_cacheline_addr=0;
    cq_comp_service_state=0;
    sciov_ignore_v = 0;
  endfunction
  
  extern virtual task mon_watchdog_reset();
  extern virtual task mon_watchdog_dec();
  extern virtual task sb_watchdog_dec();
  extern virtual function bit sb_idle();
  extern virtual task body();
  extern virtual task body_setup();
  extern virtual task hcw_delay(int delay_clks,ref int delay_rem);
  extern virtual task sys_clk_delay(int delay_clks);
  extern virtual task update_state();
  extern virtual task cq_buffer_init();
  extern virtual task watchdog_monitor();
  extern virtual task return_delay_monitor(ref int return_delay_q[$], ref int return_delay_mode, ref int total_return_count, ref bit return_delay);
  extern virtual task cq_buffer_monitor();
  extern virtual task read_ims_poll_addr(output bit [31:0] ims_poll_data);
  extern virtual task write_ims_poll_addr(bit [31:0] ims_poll_data);
  extern virtual task gen_completions();
  extern virtual task gen_renq_frag();
  extern virtual task get_hcw_gen_type(input  int               queue_list_index,
                                       input  bit               new_hcw_en,
                                       output bit               send_hcw,
                                       output hcw_cmd_type_t    cmd_type,
                                       output int               cq_token_return,
                                       output int               is_ordered);
  extern virtual task get_illegal_hcw_gen_type(input  int                       queue_list_index,
                                               input  bit                       new_hcw_en,
                                               output bit                       send_hcw,
                                               output hcw_cmd_type_t            cmd_type,
                                               output illegal_hcw_type_t        illegal_hcw_type);
  extern virtual task gen_queue_list(int queue_list_index);
  extern virtual task finish_hcw(hcw_transaction hcw_trans,
                                 bit last_hcw);

  extern virtual task corrupt_hcw(ref          hcw_transaction hcw_trans,
                                  input        illegal_hcw_type_t illegal_hcw_type);

  extern virtual function void set_name (string  name); // [UVM MIGRATION][FIXME]  UVM does not allow renaming component.
  extern virtual function int get_illegal_token_check(int queue_list_index,
                                                      int start_num,
                                                      int num_hcw);
  extern virtual function int get_illegal_comp_check(int queue_list_index,
                                                     int start_num,
                                                     int num_hcw);

  extern virtual task get_congestion_check(hcw_transaction sched_hcw_trans);

  extern virtual task HqmAtsInvalid_task(); 
  extern virtual task HqmAtsInvalidRequest_task(); 


  function void pre_randomize;
  endfunction : pre_randomize
  
endclass : hqm_pp_cq_base_seq

function void hqm_pp_cq_base_seq::set_name (string  name); // [UVM MIGRATION][FIXME]  UVM does not allow renaming component.
  super.set_name(name); // [UVM MIGRATION][FIXME]  UVM does not allow renaming component.

  pend_cq_token_return.set_name($psprintf("%s_cq_token_return",name)); // [UVM MIGRATION][FIXME]  UVM does not allow renaming component.
  pend_comp_return.set_name($psprintf("%s_comp_return",name)); // [UVM MIGRATION][FIXME]  UVM does not allow renaming component.
  pend_a_comp_return.set_name($psprintf("%s_a_comp_return",name)); // [UVM MIGRATION][FIXME]  UVM does not allow renaming component.
endfunction : set_name // [UVM MIGRATION][FIXME]  UVM does not allow renaming component.

//-------------------------
//-- support congestion direct test 
//-------------------------
task hqm_pp_cq_base_seq::get_congestion_check(hcw_transaction sched_hcw_trans);
    int vasid_idx;
    int init_avail_credit;
    int qid_depth_threshold;

    `uvm_info("PP_CQ_DEBUG",$psprintf("%s PP %0d hqm_lsp_qid_ck_congest=%0d hqm_lsp_qid_congest=%0d",pp_cq_type.name(),pp_cq_num,hqm_lsp_qid_ck_congest, hqm_lsp_qid_congest),UVM_DEBUG)
        //----------------------
        //-- congestion check direct tests	
        //----------------------
        if(hqm_lsp_qid_ck_congest==1) begin
                vasid_idx = i_hqm_cfg.get_vas(sched_hcw_trans.is_ldb, sched_hcw_trans.ppid);

                if(sched_hcw_trans.qtype == QDIR) begin
                         init_avail_credit   = i_hqm_cfg.vas_cfg[vasid_idx].credit_cnt; 
                         qid_depth_threshold = i_hqm_cfg.dir_qid_cfg[sched_hcw_trans.qid].dir_qid_depth_thresh;
                end else if(sched_hcw_trans.qtype == QUNO || sched_hcw_trans.qtype == QORD) begin
                         init_avail_credit   = i_hqm_cfg.vas_cfg[vasid_idx].credit_cnt; 
                         qid_depth_threshold = i_hqm_cfg.ldb_qid_cfg[sched_hcw_trans.qid].nalb_qid_depth_thresh;
                end else if(sched_hcw_trans.qtype == QATM) begin
                         init_avail_credit   = i_hqm_cfg.vas_cfg[vasid_idx].credit_cnt; 
                         qid_depth_threshold = i_hqm_cfg.ldb_qid_cfg[sched_hcw_trans.qid].atm_qid_depth_thresh;
                end 

            	uvm_report_info(get_full_name(), $psprintf("RECVSCHHCW_QIDDEPTHCK__qtype_%0s_tbcnt=%0d: qid_depth=%0d (qid=%0d/is_ldb=%0d/cq=%0d), check hqm_lsp_qid_congest=%0d/hqm_lsp_qid_depth_prev=%0d, current hqm_lsp_qid_depth_init_lock=%0d/hqm_lsp_qid_depth_init_lock_cnt=%0d; qid_depth_threshold=%0d init_avail_credit=%0d  ", sched_hcw_trans.qtype.name(), sched_hcw_trans.tbcnt, sched_hcw_trans.qid_depth, sched_hcw_trans.qid, sched_hcw_trans.is_ldb, sched_hcw_trans.ppid, hqm_lsp_qid_congest, hqm_lsp_qid_depth_prev, hqm_lsp_qid_depth_init_lock, hqm_lsp_qid_depth_init_lock_cnt,  qid_depth_threshold, init_avail_credit), UVM_MEDIUM);

                if(sched_hcw_trans.qid == hqm_lsp_qid_congest) begin
                     if(hqm_lsp_qid_depth_init_lock==0) begin
                         if(sched_hcw_trans.qid_depth==hqm_lsp_qid_depth_prev) begin
                             hqm_lsp_qid_depth_init_lock_cnt++;
                             if(hqm_lsp_qid_depth_init_lock_cnt > 16) hqm_lsp_qid_depth_init_lock = 1;
                         end else begin
                             hqm_lsp_qid_depth_init_lock_cnt=0;
                         end 
                     end else begin
                        if(hqm_lsp_qid_depth_prev != sched_hcw_trans.qid_depth && hqm_lsp_qid_depth_init_lock==1) begin
                           if (hqm_lsp_qid_depth_prev > sched_hcw_trans.qid_depth) begin
            	              uvm_report_info(get_full_name(), $psprintf("RECVSCHHCW_QIDDEPTHCK__qtype_%0s_tbcnt=%0d: V2:opco_field.qid_depth=%0d (qid=%0d/is_ldb=%0d/cq=%0d), has hqm_lsp_qid_congest=%0d, and hqm_lsp_qid_depth_prev=%0d > opco_field.qid_depth=%0d", sched_hcw_trans.qtype.name(), sched_hcw_trans.tbcnt, sched_hcw_trans.qid_depth, sched_hcw_trans.qid, sched_hcw_trans.is_ldb, sched_hcw_trans.ppid, hqm_lsp_qid_congest, hqm_lsp_qid_depth_prev, sched_hcw_trans.qid_depth), UVM_MEDIUM);
                           end else begin
                              hqm_lsp_qid_congest_mismatch_cnt++;
            	              uvm_report_error(get_full_name(), $psprintf("RECVSCHHCW_QIDDEPTHCK__qtype_%0s_tbcnt=%0d: V2:opco_field.qid_depth=%0d (qid=%0d/is_ldb=%0d/cq=%0d), has hqm_lsp_qid_congest=%0d, and hqm_lsp_qid_depth_prev=%0d < opco_field.qid_depth=%0d not expected, hqm_lsp_qid_congest_mismatch_cnt=%0d", sched_hcw_trans.qtype.name(), sched_hcw_trans.tbcnt, sched_hcw_trans.qid_depth, sched_hcw_trans.qid, sched_hcw_trans.is_ldb, sched_hcw_trans.ppid, hqm_lsp_qid_congest, hqm_lsp_qid_depth_prev, sched_hcw_trans.qid_depth, hqm_lsp_qid_congest_mismatch_cnt), UVM_MEDIUM);
                           end 

                           hqm_lsp_qid_depth_prev = sched_hcw_trans.qid_depth;
                        end 
                     end 
                end 
        end //--if(hqm_lsp_qid_ck_congest==1
endtask : get_congestion_check 

//-------------------------
//-- Reset monitor watchdog timer
//-------------------------
task hqm_pp_cq_base_seq::mon_watchdog_reset();
  mon_sem.get(1);

  if (do_force_seq_stop == 0) begin
    if (mon_watchdog == 0) begin
      active_seq_cnt++;
    end 

    mon_watchdog        = mon_watchdog_timeout;
  end 

  mon_sem.put(1);
endtask : mon_watchdog_reset

//-------------------------
//-- Decrement monitor watchdog timer
//-------------------------
task hqm_pp_cq_base_seq::mon_watchdog_dec();
  mon_sem.get(1);

  //--Support force
  if (i_hqm_pp_cq_status.is_force_seq_stop((pp_cq_type == IS_LDB) ? 1 : 0, pf_pp_cq_num)) begin
    do_force_seq_stop = 1;
    `uvm_info("HQM_PP_CQ_BASE_SEQ_FINISH",$psprintf("%s PP/CQ 0x%0x set do_force_seq_stop=%0d when i_hqm_pp_cq_status.is_force_seq_stop returns 1", (pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, do_force_seq_stop),UVM_LOW)
  end 

  //---------------------------------
  //---------------------------------
  if (mon_watchdog > 0) begin
      if ((mon_watchdog > 1) || (in_hcw_delay_mbox.num() == 0)) begin
         mon_watchdog--;
      end 

      if ((mon_watchdog == 0) || do_force_seq_stop) begin 
         mon_watchdog = 0;
         active_seq_cnt--;

         if ((active_seq_cnt == 0) && (sb_idle() || do_force_seq_stop )) begin 
            mon_enable                              = 0;
            pend_cq_token_return.queue_enable       = 0;
            pend_comp_return.queue_enable           = 0;
            pend_a_comp_return.queue_enable         = 0;

 
           `uvm_info("HQM_PP_CQ_BASE_SEQ_FINISH_EXPIRED_DONE",$psprintf("%s PP/CQ 0x%0x Watchdog expired, all hqm_pp_cq_base sequences done, and scoreboard idle, disabling further activity (active_seq_cnt=%0d do_force_seq_stop=%0d i_hqm_cfg.do_force_seq_finish=%0d)",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, active_seq_cnt, do_force_seq_stop, i_hqm_cfg.do_force_seq_finish),UVM_LOW)

          end else begin
           `uvm_info("HQM_PP_CQ_BASE_SEQ_FINISH_EXPIRED",$psprintf("%s PP/CQ 0x%0x Watchdog expired, waiting for all hqm_pp_cq_base sequences to complete active_seq_cnt=%0d do_force_seq_stop=%0d i_hqm_cfg.do_force_seq_finish=%0d",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, active_seq_cnt, do_force_seq_stop, i_hqm_cfg.do_force_seq_finish),UVM_LOW)
          end 
      end //
  end else begin
      //--when (mon_watchdog ==0) 
      if ( ((mon_enable == 1) && (active_seq_cnt == 0) && sb_idle()) || do_force_seq_stop) begin 

            mon_enable                              = 0;
            pend_cq_token_return.queue_enable       = 0;
            pend_comp_return.queue_enable           = 0;
            pend_a_comp_return.queue_enable         = 0;

            if (do_force_seq_stop) begin
               `uvm_info("HQM_PP_CQ_BASE_SEQ_FINISH_DONE_FORCEDONE",$psprintf("%s PP/CQ 0x%0x All hqm_pp_cq_base sequences done, do_force_seq_stop=1 forcing sequence stop (do_force_seq_finish=%0d), disabling further activity", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, i_hqm_cfg.do_force_seq_finish),UVM_LOW)
            end else begin
                `uvm_info("HQM_PP_CQ_BASE_SEQ_FINISH_DONE_SBIDLEDONE",$psprintf("%s PP/CQ 0x%0x All hqm_pp_cq_base sequences done, and scoreboard idle, disabling further activity", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
            end 
      end 
  end //if (mon_watchdog > 0)
  mon_sem.put(1);
endtask : mon_watchdog_dec

//-------------------------
//-- Decrement scoreboard watchdog timer
//-------------------------
task hqm_pp_cq_base_seq::sb_watchdog_dec();
  mon_sem.get(1);

  if (i_hcw_scoreboard != null) begin
    if (mon_enable == 0) begin
      if (i_hcw_scoreboard.hcw_scoreboard_idle() == 0) begin
        if (sb_watchdog > 0) begin
          sb_watchdog--;

          if (sb_watchdog == 0) begin
            `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x Scoreboard Watchdog expired", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
          end 
        end 
      end 
    end else begin
      sb_watchdog = sb_watchdog_timeout;
    end 
  end 

  mon_sem.put(1);
endtask : sb_watchdog_dec

//-------------------------
//-- Decrement scoreboard watchdog timer
//-------------------------
function bit hqm_pp_cq_base_seq::sb_idle();
  if (i_hcw_scoreboard != null) begin
    //`uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x sb_idle check: sb_watchdog=%0d", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,sb_watchdog),UVM_LOW)
    if (i_hcw_scoreboard.hcw_scoreboard_idle() && !i_hqm_pp_cq_status.is_seq_active("")) begin
      sb_idle = 1'b1;
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x sb_idle check: hcw_scoreboard_idle=1, sb_watchdog=%0d - get sb_idle=%0d", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,sb_watchdog,sb_idle),UVM_LOW)
    end else if (sb_watchdog > 0) begin
      sb_idle = 1'b0;
    end else begin
      sb_idle = 1'b1;
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x sb_idle check: sb_watchdog=%0d - get sb_idle=%0d", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,sb_watchdog,sb_idle),UVM_LOW)
    end 
  end else begin
    sb_idle = 1'b1;
  end 
  //`uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x sb_idle check: sb_watchdog=%0d - get sb_idle=%0d", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,sb_watchdog,sb_idle),UVM_LOW)
endfunction : sb_idle

//-------------------------
//-- body_setup
//-- file format: qtypecode, ppid, pool, is_rtncredonly, reord, frgnum, is_ldb_credit, is_carry_uhl, is_carry_tkn, is_multi_tkn
//-------------------------
task hqm_pp_cq_base_seq::body_setup();
  uvm_object  o_tmp;
  bit flr_with_hcw_process_on; 
  uvm_reg _reg_; 
  slu_ral_data_t ral_data_;

  //-----------------------------
  //-- get i_hqm_cfg
  //-----------------------------
  if (!p_sequencer.get_config_object({"i_hqm_cfg",inst_suffix}, o_tmp)) begin
    uvm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
  end 

  if (!$cast(i_hqm_cfg, o_tmp)) begin
    uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
  end    

  //-----------------------------
  //-- get hqm_pp_cq_tbcnt_base
  //-----------------------------
  if (!p_sequencer.get_config_int("hqm_pp_cq_tbcnt_base", tbcnt_base)) begin
    tbcnt_base = 0;
  end 

  uvm_report_info(get_full_name(), $psprintf("Using 0x%0x for tbcnt_base",tbcnt_base), UVM_LOW);

  //-----------------------------
  //-- get hqm_pp_cq_gen_freq
  //-----------------------------
  if (!p_sequencer.get_config_int("hqm_pp_cq_gen_freq", gen_freq)) begin
    uvm_report_fatal(get_full_name(), "Unable to find hqm_pp_cq_gen_freq");
  end 

  //-----------------------------
  //-- get i_hqm_pp_cq_status
  //-----------------------------
  if (!p_sequencer.get_config_object({"i_hqm_pp_cq_status",inst_suffix}, o_tmp)) begin
    uvm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
  end 

  if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
    uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
  end 

  //-----------------------------
  //-- determine whether SM reads are backdoor or frontdoor
  //-----------------------------
  if (!p_sequencer.get_config_int("hqm_pp_cq_backdoor_read", do_backdoor_read)) begin
    do_backdoor_read    = 1;
  end 
  if($test$plusargs("HQMSEQ_CQ_BACKDOOR_READ")) begin
    do_backdoor_read    = 1;
  end else if($test$plusargs("HQMSEQ_CQ_FRONTDOOR_READ")) begin
    do_backdoor_read    = 0;
  end 

  //-----------------------------
  //-- determine whether SM writes are backdoor or frontdoor
  //-----------------------------
  if (!p_sequencer.get_config_int("hqm_pp_cq_backdoor_write", do_backdoor_write)) begin
    do_backdoor_write    = 1;
  end 
  if($test$plusargs("HQMSEQ_CQ_BACKDOOR_WRITE")) begin
    do_backdoor_write    = 1;
  end else if($test$plusargs("HQMSEQ_CQ_FRONTDOOR_WRITE")) begin
    do_backdoor_write    = 0;
  end 

  //-----------------------------
  //-- determine whether Scheduled HCWs are being sent to scoreboard by sequences or this component
  //-- seq_sch_out_mode=0: use IOSF-P mon to pass SCHED HCW to SB
  //-- seq_sch_out_mode=1: use this sequence to pass SCHED HCW to SB
  //-----------------------------
  if (!p_sequencer.get_config_int("hqm_seq_sch_out_mode", seq_sch_out_mode)) begin
    seq_sch_out_mode  = 0;
  end 
  if($test$plusargs("HQMSEQ_SCH_OUT_MODE_0")) begin
    seq_sch_out_mode    = 1;
  end else if($test$plusargs("HQMSEQ_SCH_OUT_MODE_1")) begin
    seq_sch_out_mode    = 0;
  end 

   `uvm_info(get_full_name(),$psprintf("Starting sequence - do_backdoor_read=%0d do_backdoor_write=%0d seq_sch_out_mode=%0d", do_backdoor_read, do_backdoor_write, seq_sch_out_mode),UVM_LOW)
  //-----------------------------
  if(hqm_stream_ctl>0) begin 
     tbcnt_base[63:56] = (pp_cq_type == IS_LDB) ? 1 : 0;
     tbcnt_base[55:48] = pp_cq_num;
     tbcnt_base[47:0]  = 0;
     uvm_report_info(get_full_name(), $psprintf("Using 0x%0x for tbcnt_base revised for hqm_sream_ctl case",tbcnt_base));
  end 

  //-----------------------------
  sb_watchdog = sb_watchdog_timeout;

  pf_pp_cq_num = i_hqm_cfg.get_pf_pp(is_vf, vf_num, (pp_cq_type == IS_LDB) ? 1 : 0, pp_cq_num, 1'b1);

  vdev_num = i_hqm_cfg.get_vdev((pp_cq_type == IS_LDB) ? 1 : 0, pp_cq_num);

  is_vdev = (vdev_num < 0) ? 1'b0 : 1'b1;

  cq_depth = i_hqm_cfg.get_cq_depth((pp_cq_type == IS_LDB) ? 1 : 0, pf_pp_cq_num);

  cq_index      = (pp_cq_type == IS_LDB) ? i_hqm_pp_cq_status.ldb_pp_cq_status[pf_pp_cq_num].cq_index : i_hqm_pp_cq_status.dir_pp_cq_status[pf_pp_cq_num].cq_index;
  cq_gen        = (pp_cq_type == IS_LDB) ? i_hqm_pp_cq_status.ldb_pp_cq_status[pf_pp_cq_num].cq_gen   : i_hqm_pp_cq_status.dir_pp_cq_status[pf_pp_cq_num].cq_gen;

  if(hqm_stream_ctl>0) cmd_type_sel=2;
  else if(!$value$plusargs("cmd_type_sel=%d", cmd_type_sel)) cmd_type_sel=0;
  `uvm_info(get_full_name(),$psprintf("Start with cmd_type_sel=%0d (1 or 2: RENQ/RENQ_T supported) hqm_stream_ctl=%0d", cmd_type_sel, hqm_stream_ctl),UVM_LOW);

  vas = i_hqm_cfg.get_vasfromcq((pp_cq_type == IS_LDB) ? 1 : 0, pf_pp_cq_num);

  if (is_nm_pf) begin
    `uvm_info(get_full_name(),$psprintf("Starting sequence - NM PF %s  pp_cq_num %0d (pf_pp_cq_num %0d)",(pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, pf_pp_cq_num),UVM_LOW)
  end else if (is_vf) begin
    `uvm_info(get_full_name(),$psprintf("Starting sequence - VF %0d %s  pp_cq_num %0d (pf_pp_cq_num %0d)",vf_num,(pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, pf_pp_cq_num),UVM_LOW)
  end else if (is_vdev) begin
    `uvm_info(get_full_name(),$psprintf("Starting sequence - VDEV %0d %s  pp_cq_num %0d (pf_pp_cq_num %0d)",vdev_num,(pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, pf_pp_cq_num),UVM_LOW)
  end else begin
    `uvm_info(get_full_name(),$psprintf("Starting sequence - PF %s  pp_cq_num %0d (pf_pp_cq_num %0d)",(pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, pf_pp_cq_num),UVM_LOW)
  end 

  //-----------------------------
  //-- get i_hcw_scoreboard
  //-----------------------------
  if (!p_sequencer.get_config_object({"i_hcw_scoreboard",inst_suffix}, o_tmp)) begin
    uvm_report_info(get_full_name(), "Unable to find i_hcw_scoreboard object", UVM_LOW);
    i_hcw_scoreboard = null;
  end else begin
    if (!$cast(i_hcw_scoreboard, o_tmp)) begin
      uvm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
    end 
  end 

  `slu_assert($cast(sm,  slu_sm_env::get_ptr()),  ("Unable to get handle to SM."))
  //--08122022  `slu_assert($cast(ral, sla_ral_env::get_ptr()), ("Unable to get RAL handle"))
  `slu_assert($cast(ral, slu_ral_db::get_regmodel()), ("Unable to get handle to RAL."))

  //--08122022  func_bar_u            = ral.find_reg_by_file_name("func_bar_u", {tb_env_hier,".","hqm_pf_cfg_i"});
  //--08122022  func_bar_l            = ral.find_reg_by_file_name("func_bar_l", {tb_env_hier,".","hqm_pf_cfg_i"});
    hqm_pf_cfg_i         = ral.get_block_by_name({tb_env_hier,".hqm_pf_cfg_i"}); 
    func_bar_u           = uvm_reg::m_get_reg_by_full_name({hqm_pf_cfg_i.get_full_name(), ".func_bar_u"});             
    func_bar_l           = uvm_reg::m_get_reg_by_full_name({hqm_pf_cfg_i.get_full_name(), ".func_bar_l"});             


  if(!$value$plusargs("HQM_PF_FLR_WITH_HCW_PROCESS_ON=%d",flr_with_hcw_process_on)) flr_with_hcw_process_on=1'b_0;
 
  if (flr_with_hcw_process_on) begin
    //--08122022  _reg_     = ral.find_reg_by_file_name("pcie_cap_device_control", {tb_env_hier,".","hqm_pf_cfg_i"});
    _reg_     = uvm_reg::m_get_reg_by_full_name({hqm_pf_cfg_i.get_full_name(), ".pcie_cap_device_control"});             
    //--08122022  ral_data_ = _reg_.get_tracking_val();
    ral_data_ =  slu_ral_db::regs.get_cfg_val(_reg_); 

    `uvm_info(get_full_name(),$psprintf("Start PF FLR (0x%0x), flr_with_hcw_process_on (0x%0x), active_seq_cnt_rst (0x%0x) and active_seq_cnt (0x%0x)",ral_data_[15],flr_with_hcw_process_on,active_seq_cnt_rst,active_seq_cnt),UVM_LOW);
  end 

  if(flr_with_hcw_process_on && active_seq_cnt_rst==1'b_0 && ral_data_[15]) begin 
    active_seq_cnt=0; active_seq_cnt_rst=1'b_1 ;
    `uvm_info(get_full_name(),$psprintf("Reset active_seq_cnt as PF FLR is (0x%0x): flr_with_hcw_process_on (0x%0x), active_seq_cnt_rst (0x%0x) and active_seq_cnt (0x%0x)",ral_data_[15],flr_with_hcw_process_on,active_seq_cnt_rst,active_seq_cnt),UVM_LOW);
  end 
   
   if(hcw_acomp_ctrl>=0) cq_comp_service_state = hcw_acomp_ctrl;
  `uvm_info(get_full_name(),$psprintf("Starting sequence - %s PP/CQ 0x%0x with hcw_acomp_ctrl=%0d init cq_comp_service_state=%0d", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hcw_acomp_ctrl,  cq_comp_service_state),UVM_LOW);


endtask : body_setup

//-------------------------
//-- body
//-- file format: qtypecode, ppid, pool, is_rtncredonly, reord, frgnum, is_ldb_credit, is_carry_uhl, is_carry_tkn, is_multi_tkn
//-------------------------
task hqm_pp_cq_base_seq::body();
  uvm_object  o_tmp;
  bit flr_with_hcw_process_on; 
  uvm_reg _reg_; 
  slu_ral_data_t ral_data_;

  body_setup();

  i_hqm_pp_cq_status.set_seq_manage_credits(1);

  if (pp_cq_type == IS_LDB) begin
    if (i_hqm_pp_cq_status.ldb_pp_cq_status[pf_pp_cq_num].cq_init_done == 0) begin
      cq_buffer_init();
      i_hqm_pp_cq_status.ldb_pp_cq_status[pf_pp_cq_num].cq_init_done = 1;
     `uvm_info("PP_CQ_DEBUG",$psprintf("cq_buffer_init: Done LDB_CQ_%0d", pp_cq_num),UVM_LOW)
    end 
  end else begin
    if (i_hqm_pp_cq_status.dir_pp_cq_status[pf_pp_cq_num].cq_init_done == 0) begin
      cq_buffer_init();
      i_hqm_pp_cq_status.dir_pp_cq_status[pf_pp_cq_num].cq_init_done = 1;
     `uvm_info("PP_CQ_DEBUG",$psprintf("cq_buffer_init: Done DIR_CQ_%0d", pp_cq_num),UVM_LOW)
    end 
  end 

  fork
    begin
      pend_cq_token_return.run();
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x pend_cq_token_return.run() done",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
  join_none

  fork
    begin
      pend_comp_return.run();
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x pend_comp_return.run() done",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
  join_none

  fork
    begin
      pend_a_comp_return.run();
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x pend_a_comp_return.run() done",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
  join_none

  mon_watchdog_reset();

  fork
    begin
      watchdog_monitor();
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x watchdog_monitor done",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
    begin
      return_delay_monitor(tok_return_delay_q, tok_return_delay_mode, total_tok_return_count, tok_return_delay);
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x return_delay_monitor tok_return_delay done",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
    begin
      return_delay_monitor(comp_return_delay_q, comp_return_delay_mode, total_comp_return_count, comp_return_delay);
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x return_delay_monitor comp_return_delay done",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
    begin
      return_delay_monitor(a_comp_return_delay_q, a_comp_return_delay_mode, total_a_comp_return_count, a_comp_return_delay);
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x return_delay_monitor a_comp_return_delay done_13",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
    begin
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x cq_buffer_monitor start with cq_poll_interval=%0d",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cq_poll_interval),UVM_LOW)
      cq_buffer_monitor();
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x cq_buffer_monitor done",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
    begin
      gen_completions();
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x gen_completions done",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
    begin
      gen_renq_frag();
      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x gen_renq_frag done",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
    begin
      if($test$plusargs("HQMV30_ATS_INV_TRY")) begin 
         `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x Wait to call HqmAtsInvalidRequest_task", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
         sys_clk_delay(1500);
         `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x Call HqmAtsInvalidRequest_task", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
         HqmAtsInvalidRequest_task();
         `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x HqmAtsInvalidRequest_task done", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
      end else if($test$plusargs("HQMV30_ATS_INV_TEST")) begin
         `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x Call HqmAtsInvalid_task", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
         HqmAtsInvalid_task();
         `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x HqmAtsInvalid_task done", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
      end 
    end 
  join_none

  foreach (queue_list[i]) begin
    //----------------------
    trf_num_hcw  = queue_list[i].num_hcw;
    trf_num_loop = queue_list[i].num_hcw_loop; 
    if(queue_list[i].num_hcw_loop > 0) begin
       //--take num_hcw_loop from option
       trf_num_loop = queue_list[i].num_hcw_loop / queue_list[i].num_hcw;
    end else begin
       queue_list[i].num_hcw_loop = queue_list[i].num_hcw * queue_list[i].num_loop; 
    end 
    `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x start with num_hcw=%0d num_loop=%0d num_hcw_loop=%0d hqm_stream_ctl=%0d",
                                               (pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, trf_num_hcw, trf_num_loop, queue_list[i].num_hcw_loop, hqm_stream_ctl),UVM_LOW)

    fork
      automatic int j = i;
      begin
        gen_queue_list(j);
        `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x queue_list %d done",
                                                 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,j),UVM_LOW)
      end 
    join_none
  end 

  wait fork;

  update_state();

endtask : body

task hqm_pp_cq_base_seq::hcw_delay(int delay_clks,ref int delay_rem);
  int   start_clks;
  int   i;

  in_hcw_delay_mbox.put(delay_clks);

  start_clks = cycle_count - delay_rem;

  while (((cycle_count - start_clks) < delay_clks) && (do_force_seq_stop == 0)) begin
    sys_clk_delay(1);
  end 

  delay_rem =  (cycle_count - start_clks) - delay_clks;

  mon_watchdog_reset();

  in_hcw_delay_mbox.get(i);
endtask : hcw_delay

task hqm_pp_cq_base_seq::sys_clk_delay(int delay_clks);
  while (delay_clks > 0)
    //@(posedge i_hqm_cfg.pins.aon_clk) delay_clks -= 1;;
    @ (slu_tb_env::sys_clk_r) delay_clks -= 1;
endtask : sys_clk_delay

task hqm_pp_cq_base_seq::update_state();
  int total_enq_count;

  while (renq_credits_rsvd-- > 0) begin
    `uvm_info("PP_CQ_DEBUG",$psprintf("update_state: %0s CQ 0x%0x renq_credits_rsvd=%0d ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, renq_credits_rsvd),UVM_LOW)
    if(i_hqm_pp_cq_status.seq_manage_credits) i_hqm_pp_cq_status.put_vas_credit(vas);
  end 

  total_enq_count = 0;

  foreach (queue_list[i]) begin
    total_enq_count += queue_list[i].legal_hcw_count + queue_list[i].illegal_hcw_count;
  end 

  i_hqm_pp_cq_status.pp_cq_state_update(pp_cq_type, pf_pp_cq_num,total_enq_count, total_sch_count);

  if (pp_cq_type == IS_LDB) begin
    i_hqm_pp_cq_status.ldb_pp_cq_status[pf_pp_cq_num].cq_index  = cq_index;
    i_hqm_pp_cq_status.ldb_pp_cq_status[pf_pp_cq_num].cq_gen    = cq_gen;
  end else begin
    i_hqm_pp_cq_status.dir_pp_cq_status[pf_pp_cq_num].cq_index  = cq_index;
    i_hqm_pp_cq_status.dir_pp_cq_status[pf_pp_cq_num].cq_gen    = cq_gen;
  end 

  if (do_force_seq_stop) begin
    i_hqm_pp_cq_status.clr_force_seq_stop((pp_cq_type == IS_LDB) ? 1 : 0, pf_pp_cq_num);
  end 
endtask : update_state

task hqm_pp_cq_base_seq::cq_buffer_init();
  addr_t        addr;
  byte_t        data[$];
  bit           be[$];
  int           sparse_len;

  addr        = cq_addr;

  data.delete();
  be.delete();

  sparse_len=1;
  if( (pp_cq_type == IS_LDB)) begin
     if($test$plusargs("HQM_LDB_CQ_SINGLE_HCW_PER_CL")) sparse_len = 4;
  end else begin
     if($test$plusargs("HQM_DIR_CQ_SINGLE_HCW_PER_CL")) sparse_len = 4;
  end 

  `uvm_info("PP_CQ_DEBUG_BASIC",$psprintf("cq_buffer_init: %0s CQ 0x%0x cq_addr 0x%0x cq_depth %0d sparse_len %0d Start ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, cq_addr, cq_depth, sparse_len),UVM_LOW)

  for (int i = 0 ; i < 16 ; i++) begin
    if($test$plusargs("HQM_CQ_BUFFER_INIT_WDATA")) begin 
      data.push_back(i);
    end else begin
      data.push_back(0);
    end 

      be.push_back(1);
  end 

  ////data[15] |= 8'b01;  // set gen bit to 1

  for (int i = 0 ; i < cq_depth*sparse_len ; i++) begin
    if($test$plusargs("HQM_CQ_BUFFER_INIT_WINCRDATA")) begin 
       data.delete();
       be.delete();
       for (int k = 0 ; k < 16 ; k++) begin
          data.push_back(k+i);
          be.push_back(1);
       end 
    end 

    sm.do_write(addr,data,be,"",do_backdoor_write,"");
    addr += 16;
  end 

  if($test$plusargs("HQM_CQ_BUFFER_INIT_READ")) begin
     addr        = cq_addr;
     for (int i = 0 ; i < cq_depth ; i++) begin
       sm.do_read(addr,16,data,"",do_backdoor_read,"");

       `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("cq_buffer_init_read: %s CQ 0x%0x sm.do_read addr=0x%0x get: data[15]=0x%0x data[14]=0x%0x data[13]=0x%0x data[12]=0x%0x data[11]=0x%0x data[10]=0x%0x data[9]=0x%0x data[8]=0x%0x data[7]=0x%0x data[6]=0x%0x data[5]=0x%0x data[4]=0x%0x data[3]=0x%0x data[2]=0x%0x data[1]=0x%0x data[0]=0x%0x",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,data[15],data[14],data[13],data[12],data[11],data[10],data[9],data[8],data[7],data[6],data[5],data[4],data[3],data[2],data[1],data[0]),UVM_LOW)

       addr += 16;
     end 
  end 

  // initialize the IMS poll data field
  if (i_hqm_cfg.ims_poll_mode) 
    write_ims_poll_addr(0);

  `uvm_info("PP_CQ_DEBUG_BASIC",$psprintf("cq_buffer_init: %0s CQ 0x%0x cq_addr 0x%0x cq_depth %0d ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, cq_addr, cq_depth),UVM_LOW)
endtask : cq_buffer_init

task hqm_pp_cq_base_seq::watchdog_monitor();
  int sys_clk_cycle_count = 0;
  real new_cycle_count = 0.0;
  time  start_time;
  time  current_time;

  while (mon_enable || (active_gen_queue_list_cnt > 0 )) begin
    mon_watchdog_dec();
    sb_watchdog_dec();
    sys_clk_delay(1);
    if (sys_clk_cycle_count == 0) start_time = $time();
    sys_clk_cycle_count++;
    current_time = $time();
    new_cycle_count = ((current_time - start_time) * gen_freq) / 1000ns;
    while (new_cycle_count > cycle_count) begin
      cycle_count++;
//      `uvm_info("CYCLE_COUNT",$psprintf("PP %01d cycle_count=%0d",pp_cq_num,cycle_count),UVM_HIGH)
      ->cycle_count_ev;
    end 
  end 
  `uvm_info("PP_CQ_DEBUG_BASIC",$psprintf("watchdog_monitor: %0s CQ 0x%0x watchdog_monitor Done ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num),UVM_LOW)
endtask : watchdog_monitor

task hqm_pp_cq_base_seq::return_delay_monitor(ref int return_delay_q[$], ref int return_delay_mode, ref int total_return_count, ref bit return_delay);
  int   cur_delay;
  int   cur_q_index;
  int   init_return_count;

  cur_delay     = 0;
  cur_q_index   = 0;

  if (return_delay_q.size() == 0) begin
    return;
  end 

  if (return_delay_mode == 3) begin
    return_delay                = 0;
    init_return_count           = total_return_count;
  end else begin
    return_delay                = 1;
  end 

  cur_delay                     = return_delay_q[0];

  while (mon_enable) begin
    sys_clk_delay(1);

    if (return_delay_mode == 3) begin
      if (return_delay) begin
        bit [31:0] msix_data;
        init_return_count       = total_return_count;

        while (mon_enable && !i_hqm_pp_cq_status.msix_int_received(0)) begin
          sys_clk_delay(1);
        end 
        // added below 1ns delay to let parent calling sequences capture msix event as well
        sys_clk_delay(1);

        if (mon_enable == 1) begin
          i_hqm_pp_cq_status.wait_for_msix_int(0,msix_data);
        end 

        return_delay            = 0;
        cur_q_index++;
        if (cur_q_index >= return_delay_q.size()) begin
          return;
        end 
        cur_delay               = return_delay_q[cur_q_index];
        init_return_count       = total_return_count;
      end else begin
        if ((total_return_count - init_return_count) >= cur_delay) begin
          return_delay = 1;
        end 
      end 
    end else begin
      if (cur_delay > 0) begin
        cur_delay--;
       `uvm_info(get_full_name(),$psprintf("return_delay_monitor:: %s CQ 0x%0x - cur_delay=%0d return_delay=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cur_delay, return_delay), UVM_HIGH)
      end else begin
        case (return_delay_mode)
          0: begin
          cur_q_index++;
            return_delay    = ~return_delay;

            if (cur_q_index >= return_delay_q.size()) begin
              return_delay    = 0;
              `uvm_info(get_full_name(),$psprintf("return_delay_monitor_mode0_return_delay=0:: %s CQ 0x%0x - cur_delay=%0d return_delay=%0d)",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cur_delay, return_delay), UVM_MEDIUM)
              return;
            end else begin
              cur_delay = return_delay_q[cur_q_index];
            end 
            `uvm_info(get_full_name(),$psprintf("return_delay_monitor_mode0:: %s CQ 0x%0x - cur_delay=%0d return_delay=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cur_delay, return_delay), UVM_HIGH)
          end 
          1: begin
            cur_q_index++;
            return_delay    = ~return_delay;

            if (cur_q_index >= return_delay_q.size()) begin
              cur_q_index = 0;
              cur_delay   = return_delay_q[cur_q_index];
            end else begin
              cur_delay = return_delay_q[cur_q_index];
            end 
            `uvm_info(get_full_name(),$psprintf("return_delay_monitor_mode1:: %s CQ 0x%0x - cur_delay=%0d return_delay=%0d cur_q_index=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cur_delay, return_delay, cur_q_index), UVM_HIGH)
          end 
          2: begin
            bit [15:0] msix_data;

            if (return_delay && (cur_q_index > 0)) begin
              while (mon_enable && i_hqm_pp_cq_status.msix_int_received(0)) begin
                sys_clk_delay(1);
              end 

              if (mon_enable == 1) begin
                i_hqm_pp_cq_status.wait_for_msix_int(0,msix_data);
              end 
            end 

            cur_q_index++;
            return_delay    = ~return_delay;

            if (cur_q_index >= return_delay_q.size()) begin
                cur_q_index = 0;
                cur_delay   = return_delay_q[cur_q_index];
            end else begin
              cur_delay = return_delay_q[cur_q_index];
            end 
            `uvm_info(get_full_name(),$psprintf("return_delay_monitor_mode2:: %s CQ 0x%0x - cur_delay=%0d return_delay=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cur_delay, return_delay), UVM_HIGH)
          end 
          default: begin
            return_delay = 0;
            `uvm_error(get_full_name(),$psprintf("%s CQ 0x%0x - return_delay_monitor() unexpected return_delay_mode=%d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,return_delay_mode))
          end 
        endcase

        if(return_delay==0) begin
            `uvm_info(get_full_name(),$psprintf("return_delay_monitor_return_delay=0:: %s CQ 0x%0x - cur_delay=%0d return_delay=%0d, return_delay_mode=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cur_delay, return_delay, return_delay_mode), UVM_MEDIUM)
        end 
      end //--if (cur_delay > 0) 
    end //--if (return_delay_mode == 3) 
  end //--while (mon_enable) 
endtask : return_delay_monitor

task hqm_pp_cq_base_seq::read_ims_poll_addr(output bit [31:0] ims_poll_data);
  byte_t          data[$];

  sm.do_read(ims_poll_addr,4,data,"",do_backdoor_read,"");

  ims_poll_data[7:0]   = data[0];
  ims_poll_data[15:8]  = data[1];
  ims_poll_data[23:16] = data[2];
  ims_poll_data[31:24] = data[3];
        `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("read_ims_poll_addr: %s CQ 0x%0x ims_poll_addr 0x%0x ims_poll_data 0x%0x ",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, ims_poll_addr,ims_poll_data),UVM_HIGH)
endtask

task hqm_pp_cq_base_seq::write_ims_poll_addr(bit [31:0] ims_poll_data);
  addr_t        addr;
  byte_t        data[$];
  bit           be[$];

  data.delete();
  be.delete();
  data.push_back(ims_poll_data[7:0]);
  data.push_back(ims_poll_data[15:8]);
  data.push_back(ims_poll_data[23:16]);
  data.push_back(ims_poll_data[31:24]);
  be.push_back(1);
  be.push_back(1);
  be.push_back(1);
  be.push_back(1);

  sm.do_write(ims_poll_addr,data,be,"",do_backdoor_write,"");
        `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("write_ims_poll_addr: %s CQ 0x%0x ims_poll_addr 0x%0x ims_poll_data 0x%0x ",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, ims_poll_addr,ims_poll_data),UVM_LOW)
endtask

task hqm_pp_cq_base_seq::cq_buffer_monitor();
  addr_t      addr;
  addr_t      msix_addr;
  addr_t      ims_addr;
  byte_t      data[$];
  logic [127:0] hcw_in;
  hcw_transaction     hcw_trans_in;
  automatic   int     curr_a_comp_return_size;
  int         is_ao_cfg_v; 
  int         pf_qid;  
  int         cq_ats_resp_errinj_issued;
  int         cq_trfctrl;
  uvm_object  o_tmp;

  cq_ats_resp_errinj_issued = 0;

  //-----------------------------
  //-- get i_hcw_scoreboard
  //-----------------------------
  if(i_hcw_scoreboard == null)begin
    if (!p_sequencer.get_config_object({"i_hcw_scoreboard",inst_suffix}, o_tmp)) begin
      uvm_report_info(get_full_name(), "Unable to find i_hcw_scoreboard object", UVM_HIGH);
      i_hcw_scoreboard = null;
    end else begin
      if (!$cast(i_hcw_scoreboard, o_tmp)) begin
        uvm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
      end 
    end 
  end 

  while (mon_enable) begin
    sys_clk_delay(1);

    //-------------------------------------
    //--Support VAS RESET of this CQ
    //-------------------------------------
    if(i_hqm_cfg.hqm_proc_vasrst_comp==2) begin
       if(i_hqm_cfg.hqmproc_vasrst_dircq[pp_cq_num]==1 && pp_cq_type != IS_LDB) begin
          cq_buffer_init();
	  cq_gen=1; 
          cq_index=0;
          //i_hqm_cfg.hqm_proc_vasrst_comp=0;
          i_hqm_cfg.hqmproc_vasrst_dircq[pp_cq_num]=0;
          `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon_VASRST: %s CQ 0x%0x cq_addr 0x%0x:: reset index 0x%0x generation bit %0d, hqm_proc_vasrst_comp=%0d hqmproc_vasrst_ldbcq[%0d]=%0d hqmproc_vasrst_dircq[%0d]=%0d ",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cq_addr, cq_index, cq_gen, i_hqm_cfg.hqm_proc_vasrst_comp, pp_cq_num, i_hqm_cfg.hqmproc_vasrst_ldbcq[pp_cq_num], pp_cq_num, i_hqm_cfg.hqmproc_vasrst_dircq[pp_cq_num]),UVM_MEDIUM)
       end  
       if(i_hqm_cfg.hqmproc_vasrst_ldbcq[pp_cq_num]==1 && pp_cq_type == IS_LDB) begin
          cq_buffer_init();
          cq_index=0;
          cq_gen=1; 
          //i_hqm_cfg.hqm_proc_vasrst_comp=0;
          i_hqm_cfg.hqmproc_vasrst_ldbcq[pp_cq_num]=0;
          `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon_VASRST: %s CQ 0x%0x cq_addr 0x%0x:: reset index 0x%0x generation bit %0d, hqm_proc_vasrst_comp=%0d hqmproc_vasrst_ldbcq[%0d]=%0d hqmproc_vasrst_ldbcq[%0d]=%0d ",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cq_addr, cq_index, cq_gen, i_hqm_cfg.hqm_proc_vasrst_comp, pp_cq_num, i_hqm_cfg.hqmproc_vasrst_ldbcq[pp_cq_num], pp_cq_num, i_hqm_cfg.hqmproc_vasrst_ldbcq[pp_cq_num]),UVM_MEDIUM)
       end  
    end 

    //-------------------------------------
    //-------------------------------------
    if(pp_cq_type == IS_LDB) begin
       cq_ats_resp_errinj_issued = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_ats_resp_errinj_st; 
       cq_trfctrl                = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_trfctrl;
    end else begin
       cq_ats_resp_errinj_issued = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_ats_resp_errinj_st; 
       cq_trfctrl                = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_trfctrl;
    end 

    //if(cq_ats_resp_errinj_issued==1) begin
    //      `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon_ATSRESP_ERRINJ_Issued: %s CQ 0x%0x cq_addr 0x%0x:: current index 0x%0x mon_enable=%0d => Will break cq_buffer_monitor() ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cq_addr, cq_index, mon_enable),UVM_LOW)
    //       break;
    //end 


    //-- After VAS RESET and CQ's hpa has been reallocated, change cq_addr
    if(cq_trfctrl==3) begin
       if(pp_cq_type == IS_LDB) begin
          cq_addr = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_hpa;
       end else begin
          cq_addr = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_hpa;
       end 
        `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon_After_VASRESET: %s CQ 0x%0x change to use new hpa cq_addr 0x%0x:: current index 0x%0x mon_enable=%0d", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cq_addr, cq_index, mon_enable),UVM_HIGH)
    end 

    //-------------------------------------
    //-------------------------------------
    if (cq_poll_interval > 0) begin
    //--  non-intr process section

      addr = cq_addr + (cq_index * (i_hqm_cfg.is_single_hcw_per_cl((pp_cq_type == IS_LDB) ? 1'b1 : 1'b0) ? 64 : 16));
      data.delete();
      sm.do_read(addr,16,data,"",do_backdoor_read,"");
      if($test$plusargs("HQM_CQ_BUFFER_READ_RPT")) begin
        `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("cq_buffer_monitor: %s CQ 0x%0x sm.do_read addr=0x%0x get: data[15]=0x%0x data[14]=0x%0x data[13]=0x%0x data[12]=0x%0x data[11]=0x%0x data[10]=0x%0x data[9]=0x%0x data[8]=0x%0x data[7]=0x%0x data[6]=0x%0x data[5]=0x%0x data[4]=0x%0x data[3]=0x%0x data[2]=0x%0x data[1]=0x%0x data[0]=0x%0x",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,data[15],data[14],data[13],data[12],data[11],data[10],data[9],data[8],data[7],data[6],data[5],data[4],data[3],data[2],data[1],data[0]),UVM_LOW)
      end 

      if (data[15][0] == cq_gen) begin
        hcw_in = {data[15],data[14],data[13],data[12],data[11],data[10],data[9],data[8],data[7],data[6],data[5],data[4],data[3],data[2],data[1],data[0]};
        hcw_trans_in = new();
        hcw_trans_in.byte_unpack(.kind(1),.hcwdata(hcw_in));
        hcw_trans_in.ppid             = pp_cq_num;
        hcw_trans_in.is_vf            = is_vf;
        hcw_trans_in.vf_num           = vf_num;
        hcw_trans_in.sch_parity       = 0;
        hcw_trans_in.sch_error        = 0;
        hcw_trans_in.sch_cq_occ       = 0;
        hcw_trans_in.sch_is_ldb       = (pp_cq_type == IS_LDB) ? 1'b1 : 1'b0;
        hcw_trans_in.is_ldb           = (pp_cq_type == IS_LDB) ? 1'b1 : 1'b0;
        hcw_trans_in.sch_write_status = 0;
        hcw_trans_in.sch_addr         = cq_index;

        get_congestion_check(hcw_trans_in);

        //--seq_sch_out_mode=1  : far-end scoreboarding, send hcw_trans_in to SB SCH
        if (seq_sch_out_mode) begin
          i_hcw_scoreboard.out_item_fifo.write(hcw_trans_in);
        end 

        `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon00: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (index) 0x%0x qtype=%0d with generation bit %0d - 0x%0x",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,cq_index,hcw_in[89:88], cq_gen,hcw_in),UVM_LOW)

        cq_index++;
        total_sch_count++;


        if (pp_cq_type == IS_LDB) begin
          pend_hcw_trans.push_back(hcw_trans_in);


          //-- is_ao_cfg_v
          is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(hcw_trans_in.qid);
          `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon00_1: %s CQ 0x%0x Detected scheduled HCW qtype=%0s qid=%0d is_ao_cfg_v=%0d", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hcw_trans_in.qtype.name(), hcw_trans_in.qid, is_ao_cfg_v),UVM_LOW)


          if(hcw_trans_in.qtype == QDIR && is_ao_cfg_v)  pend_hcw_trans_comb.push_back(hcw_trans_in);

          `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon0: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (cq_addr) 0x%0x (index) 0x%0x with generation bit %0d hcw_in=0x%0x, qtype=%0s qid=0x%0x lockid=0x%0x, tbcnt=0x%0x, hcw_ldb_cq_hcw_num[%0d]=%0d hqm_proc_vasrst_comp=%0d hqmproc_vasrst_ldbcq[%0d]=%0d; pend_hcw_trans.size=%0d pend_hcw_trans_comb.size=%0d ",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, addr, cq_addr, cq_index,cq_gen, hcw_in, hcw_trans_in.qtype.name(), hcw_trans_in.qid, hcw_in[111:96], hcw_trans_in.tbcnt, pp_cq_num, i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num], i_hqm_cfg.hqm_proc_vasrst_comp, pp_cq_num, i_hqm_cfg.hqmproc_vasrst_ldbcq[pp_cq_num], pend_hcw_trans.size(), pend_hcw_trans_comb.size()),UVM_LOW)

          //--HQMV30_AO
          if (hcw_trans_in.qtype == QORD || hcw_trans_in.qtype == QDIR || (cmd_type_sel==1 && hcw_trans_in.qtype != QDIR && i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num] > 0)) begin
            renq_credits_rsvd++;
            hcw_trans_in.tbcnt = hcw_trans_in.iptr;

            pend_comp_return.push(1);
            i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num] --;
            `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon1: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (index) 0x%0x with generation bit %0d - 0x%0x, pend_comp_return.push[1]=>is_ordered, hcw_ldb_cq_hcw_num[%0d]=%0d renq_credits_rsvd=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,cq_index,cq_gen,hcw_in, pp_cq_num, i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num], renq_credits_rsvd),UVM_MEDIUM)

            //--HQMV30_AO
            if(hcw_trans_in.qtype == QDIR) begin
               if(is_ao_cfg_v) begin
                  pend_a_comp_return.push(1);
                  pend_a_comp_return.abs_size(curr_a_comp_return_size);     
                 `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon1: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (index) 0x%0x with generation bit %0d - 0x%0x, qid=0x%0x ao_qid_v=1: pend_a_comp_return.push[1]=>AO curr_a_comp_return_size=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,cq_index,cq_gen,hcw_in, hcw_trans_in.qid, curr_a_comp_return_size),UVM_MEDIUM)
               end else begin
                 `uvm_error("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon1: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (index) 0x%0x with generation bit %0d - 0x%0x, qid=0x%0x ao_qid_v=0: check ao_qid_v programming",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,cq_index,cq_gen,hcw_in, hcw_trans_in.qid))
               end 
            end 
          end else begin
            if(i_hqm_pp_cq_status.seq_manage_credits) i_hqm_pp_cq_status.put_vas_credit(vas);
            pend_comp_return.push(0);
            `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon1: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (index) 0x%0x with generation bit %0d - 0x%0x, pend_comp_return.push[0], qid=0x%0x ao_qid_v=%0d tbcnt=0x%0x",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,cq_index,cq_gen,hcw_in, pp_cq_num, hcw_trans_in.qid, is_ao_cfg_v, hcw_trans_in.tbcnt),UVM_MEDIUM)
          end 


        end else begin
          if(i_hqm_pp_cq_status.seq_manage_credits) i_hqm_pp_cq_status.put_vas_credit(vas);
        end 

        pend_cq_token_return.push(cq_index);

        if (cq_index >= cq_depth) begin
          cq_index      = 0;
          cq_gen        = ~cq_gen;
        end 

        if(!$test$plusargs("HQMPROC_CQBUF_POLLFAST"))  sys_clk_delay(cq_poll_interval);
      end else begin
        if(!$test$plusargs("HQMPROC_CQBUF_POLLFAST"))  sys_clk_delay(cq_poll_interval);
        `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon00_non: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (index) 0x%0x with generation bit %0d - data[15]=0x%0x cq_poll_interval=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,cq_index,cq_gen,data[15], cq_poll_interval),UVM_DEBUG)
      end 
    end else begin
    //-------------------------------------
    //--  intr process section
    //-------------------------------------
      int               hcw_cnt;
      int               pend_cq_token_return_size;
      bit [31:0]        ims_poll_data;
      bit [1:0]         ims_ctrl; //--move the checking to seqlib/hqm_ims_isr_seq.sv
      int               int_poll_cq_buffer;
      int               do_int_poll_cq_buffer;
      int               sm_read_msix_num;

      if (i_hqm_cfg.ims_poll_mode) begin
        read_ims_poll_addr(ims_poll_data);
        while (mon_enable && (ims_poll_data == 0)) begin
          sys_clk_delay(1);
          read_ims_poll_addr(ims_poll_data);
        end 
        `uvm_info(get_full_name(), $psprintf("TrfSchedMon00: %s CQ 0x%0x detected IMS Poll Read ims_poll_data=0x%0x while mon_enable=%0d", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num, ims_poll_data, mon_enable), UVM_HIGH)
      end else begin
        while (mon_enable && (i_hqm_pp_cq_status.cq_int_received(pp_cq_type, pf_pp_cq_num) == 0)) begin
          sys_clk_delay(1);
        end 
      end 

      if (mon_enable == 1) begin
        if (i_hqm_cfg.ims_poll_mode) begin
          write_ims_poll_addr(0);
          `uvm_info(get_full_name(), $psprintf("TrfSchedMon00: %s CQ 0x%0x After detected IMS Poll Write write_ims_poll_addr with 0", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num), UVM_MEDIUM)
        end else begin
          i_hqm_pp_cq_status.wait_for_cq_int(pp_cq_type, pf_pp_cq_num);
        end 

        `uvm_info("HQM_PP_CQ_BASE_SEQ", $psprintf("TrfSchedMon00: %s CQ 0x%0x waiting for the %0d delay", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num, cq_intr_process_delay), UVM_MEDIUM)
        repeat(cq_intr_process_delay) sys_clk_delay(1);

        pend_cq_token_return.abs_size(pend_cq_token_return_size);

        if (pend_cq_token_return_size > 0) begin
          `uvm_error("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon00: %s CQ 0x%0x Unexpected CQ interrupt (rearm still pending)",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num))
        end else begin
          //--HQMV30: with ATS supported, there are some changes in Steve's RTL, there is the case that interrupt is received before QEs are written into CQ buffers
          //--with such change, we should set int_poll_cq_buffer by default (TBD)
          //--HQMV25-- if(!$value$plusargs("HQM_PP_CQ_BASE_SEQ_INT_POLL_CQ_BUFFER=%d", int_poll_cq_buffer)) int_poll_cq_buffer = 0; //--Support SoC scenario
          if(!$value$plusargs("HQM_PP_CQ_BASE_SEQ_INT_POLL_CQ_BUFFER=%d", int_poll_cq_buffer)) int_poll_cq_buffer = 1; //--HQMV30 default is set to 1

          if(!$value$plusargs("HQM_PP_CQ_READ_MSIX_NUM=%d", sm_read_msix_num)) sm_read_msix_num = 1; //--Support SoC scenario

          do_int_poll_cq_buffer = 1;
          hcw_cnt = 0;
          addr = cq_addr + (cq_index * (i_hqm_cfg.is_single_hcw_per_cl((pp_cq_type == IS_LDB) ? 1'b1 : 1'b0) ? 64 : 16));

          if ((pp_cq_type == IS_DIR) && i_hqm_cfg.is_early_dir_int()) begin
            int_poll_cq_buffer = 1;
          end 


          while (do_int_poll_cq_buffer && mon_enable) begin
             //--read sm
             `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon00_read_cq_0: %s CQ 0x%0x at addr 0x%0x hcw_cnt=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr, hcw_cnt),UVM_LOW)
             data.delete();
             sm.do_read(addr,16,data,"",do_backdoor_read,"");
             `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon00_read_cq_1: %s CQ 0x%0x at addr 0x%0x readout data[15]=0x%0x cq_gen=%0d; hcw_cnt=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr, data[15], cq_gen, hcw_cnt),UVM_LOW)

             //------------------------------------
             while (data[15][0] == cq_gen) begin
        	hcw_in = {data[15],data[14],data[13],data[12],data[11],data[10],data[9],data[8],data[7],data[6],data[5],data[4],data[3],data[2],data[1],data[0]};
        	hcw_trans_in = new();
        	hcw_trans_in.byte_unpack(.kind(1),.hcwdata(hcw_in));
        	hcw_trans_in.ppid             = pp_cq_num;
        	hcw_trans_in.is_vf            = is_vf;
        	hcw_trans_in.vf_num           = vf_num;
        	hcw_trans_in.sch_parity       = 0;
        	hcw_trans_in.sch_error        = 0;
        	hcw_trans_in.sch_cq_occ       = 0;
        	hcw_trans_in.sch_is_ldb       = (pp_cq_type == IS_LDB) ? 1'b1 : 1'b0;
        	hcw_trans_in.is_ldb           = (pp_cq_type == IS_LDB) ? 1'b1 : 1'b0;
        	hcw_trans_in.sch_write_status = 0;
        	hcw_trans_in.sch_addr         = cq_index;

        	get_congestion_check(hcw_trans_in);

        	if (seq_sch_out_mode) begin
        	  i_hcw_scoreboard.out_item_fifo.write(hcw_trans_in);
        	end 


        	`uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon00_intrloop: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (index) 0x%0x qtype=%0d(%0s) with generation bit %0d - 0x%0x; hcw_cnt=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,cq_index, hcw_in[89:88],hcw_trans_in.qtype.name(), cq_gen,hcw_in, hcw_cnt),UVM_LOW)
        	cq_index++;
        	total_sch_count++;

        	if (pp_cq_type == IS_LDB) begin
        	  pend_hcw_trans.push_back(hcw_trans_in);


                  is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(hcw_trans_in.qid);
                 `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon00_intrloop_1: %s CQ 0x%0x Detected scheduled HCW qtype=%0s qid=%0d is_ao_cfg_v=%0d", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hcw_trans_in.qtype.name(), hcw_trans_in.qid, is_ao_cfg_v),UVM_LOW)

                  if(hcw_trans_in.qtype == QDIR && is_ao_cfg_v)  pend_hcw_trans_comb.push_back(hcw_trans_in);

                  `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon0_intrloop: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (cq_addr) 0x%0x (index) 0x%0x with generation bit %0d hcw_in=0x%0x, qtype=%0s qid=0x%0x lockid=0x%0x, tbcnt=0x%0x, hcw_ldb_cq_hcw_num[%0d]=%0d; pend_hcw_trans.size=%0d pend_hcw_trans_comb.size=%0d ",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, addr, cq_addr, cq_index,cq_gen, hcw_in, hcw_trans_in.qtype.name(), hcw_trans_in.qid, hcw_in[111:96], hcw_trans_in.tbcnt, pp_cq_num, i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num], pend_hcw_trans.size(), pend_hcw_trans_comb.size()),UVM_LOW)


        	  if (hcw_trans_in.qtype == QORD || hcw_trans_in.qtype == QDIR || (cmd_type_sel==1 && hcw_trans_in.qtype != QDIR && i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num] > 0)) begin
                    renq_credits_rsvd++;
                    hcw_trans_in.tbcnt = hcw_trans_in.iptr;

                    pend_comp_return.push(1);
                    i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num] --;
                    `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon2: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (index) 0x%0x with generation bit %0d - 0x%0x, hcw_ldb_cq_hcw_num[%0d]=%0d hcw_cnt=%0d renq_credits_rsvd=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,cq_index,cq_gen,hcw_in, pp_cq_num, i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num], hcw_cnt, renq_credits_rsvd),UVM_MEDIUM)

                     //--HQMV30_AO
                     if( hcw_trans_in.qtype == QDIR) begin
                        if(is_ao_cfg_v) begin
                           pend_a_comp_return.push(1);
                           pend_a_comp_return.abs_size(curr_a_comp_return_size);     
                           `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon2: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (index) 0x%0x with generation bit %0d - 0x%0x, qid=0x%0x ao_qid_v=1: pend_a_comp_return.push[1]=>AO curr_a_comp_return_size=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,cq_index,cq_gen,hcw_in, hcw_trans_in.qid, curr_a_comp_return_size),UVM_MEDIUM)
                        end else begin
                           `uvm_error("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon2: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (index) 0x%0x with generation bit %0d - 0x%0x, qid=0x%0x ao_qid_v=0: check ao_qid_v programming",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,cq_index,cq_gen,hcw_in, hcw_trans_in.qid))
                        end 
                     end 

        	  end else begin
                    if(i_hqm_pp_cq_status.seq_manage_credits) i_hqm_pp_cq_status.put_vas_credit(vas);
                    pend_comp_return.push(0);
                   `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon2: %s CQ 0x%0x Detected scheduled HCW at addr 0x%0x (index) 0x%0x with generation bit %0d - 0x%0x, pend_comp_return.push[0], qid=0x%0x ao_qid_v=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,addr,cq_index,cq_gen,hcw_in, pp_cq_num, hcw_trans_in.qid, is_ao_cfg_v),UVM_MEDIUM)
        	  end 
        	end else begin
        	  if(i_hqm_pp_cq_status.seq_manage_credits) i_hqm_pp_cq_status.put_vas_credit(vas);
        	end 

        	hcw_cnt++;

        	if (cq_index >= cq_depth) begin
        	  cq_index      = 0;
        	  cq_gen        = ~cq_gen;
        	end 

        	addr = cq_addr + (cq_index * (i_hqm_cfg.is_single_hcw_per_cl((pp_cq_type == IS_LDB) ? 1'b1 : 1'b0) ? 64 : 16));
        	data.delete();
        	sm.do_read(addr,16,data,"",do_backdoor_read,"");
             end //while (data[15][0] == cq_gen) begin

             // If a new HCW is not detected, poll the CQ buffer if int_poll_cq_buffer is set
            `uvm_info("HQM_PP_CQ_BASE_SEQ", $psprintf("TrfSchedMon00_read_cq_2: %0s CQ 0x%0x CQ interrupt received, if hcw_cnt=%0d (=0?) no HCW written in buffer and int_poll_cq_buffer (%0b) int is set to 1, cont read CQ when mon_enable=%0d is 1", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num, hcw_cnt, int_poll_cq_buffer, mon_enable), UVM_LOW)

             if (hcw_cnt == 0) begin
               do_int_poll_cq_buffer = int_poll_cq_buffer;
               sys_clk_delay(1);
             end else begin
               do_int_poll_cq_buffer = 0;

               if($test$plusargs("HQM_PP_CQ_READ_MSIX_ADDR")) begin
                  if($test$plusargs("HQM_PP_CQ_READ_REMAP_INTR_ADDR")) begin
                     for(int midx=1; midx<(1+sm_read_msix_num); midx++) begin
                         msix_addr = intr_remap_addr; //--this is the intr_remap_addr passing from upper level seq to HQM seq
                         sm.do_read(msix_addr,16,data,"",do_backdoor_read,"");
                        `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon00_read_cq_3_read_msix_addr: %s CQ 0x%0x at msix_addr 0x%0x readout data[0]=0x%0x; hcw_cnt=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,msix_addr, data[0], hcw_cnt),UVM_MEDIUM)
                     end     
                  end else begin
                     for(int midx=1; midx<(1+sm_read_msix_num); midx++) begin
                         msix_addr = i_hqm_cfg.msix_cfg[midx].addr; //64'h00000000_fee00000;
                         sm.do_read(msix_addr,16,data,"",do_backdoor_read,"");
                        `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon00_read_cq_3_read_msix_addr: %s CQ 0x%0x at msix_addr 0x%0x readout data[0]=0x%0x; hcw_cnt=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,msix_addr, data[0], hcw_cnt),UVM_MEDIUM)
                     end 
                  end 
               end 
               if($test$plusargs("HQM_PP_CQ_READ_IMS_ADDR")) begin
                  ims_addr = i_hqm_cfg.get_ims_addr(pp_cq_num, ((pp_cq_type == IS_LDB) ? 1 : 0)) ;
                  sm.do_read(ims_addr,16,data,"",do_backdoor_read,"");
                 `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfSchedMon00_read_cq_3_read_ims_addr: %s CQ 0x%0x at ims_addr 0x%0x readout data[0]=0x%0x; hcw_cnt=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,ims_addr, data[0], hcw_cnt),UVM_MEDIUM)
               end 

             end 
          end //while (do_int_poll_cq_buffer && mon_enable) begin



          if (hcw_cnt == 0) begin
            if(int_poll_cq_buffer==0)
            `uvm_error("HQM_PP_CQ_BASE_SEQ",$psprintf("%s CQ 0x%0x Unexpected CQ interrupt (CQ buffer empty)",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num))
            else 
            `uvm_warning("HQM_PP_CQ_BASE_SEQ",$psprintf("%s CQ 0x%0x Unexpected CQ interrupt (CQ buffer empty) when int_poll_cq_buffer=1",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num))
          end else begin
            if (hcw_cnt > 4096) begin
              pend_cq_token_return.push(1024);
              pend_cq_token_return.push(1024);
              pend_cq_token_return.push(1024);
              pend_cq_token_return.push(1024);
              pend_cq_token_return.push(hcw_cnt - 4096);
            end else if (hcw_cnt > 3072) begin
              pend_cq_token_return.push(1024);
              pend_cq_token_return.push(1024);
              pend_cq_token_return.push(1024);
              pend_cq_token_return.push(hcw_cnt - 3072);
            end else if (hcw_cnt > 2048) begin
              pend_cq_token_return.push(1024);
              pend_cq_token_return.push(1024);
              pend_cq_token_return.push(hcw_cnt - 2048);
            end else if (hcw_cnt > 1024) begin
              pend_cq_token_return.push(1024);
              pend_cq_token_return.push(hcw_cnt - 1024);
            end else begin
              pend_cq_token_return.push(hcw_cnt);
              `uvm_info("HQM_PP_CQ_BASE_SEQ", $psprintf("TrfSchedMon00_done_push_pend_cq_token_return:%0s CQ 0x%0x pend_cq_token_return.push hcw_cnt=%0d ", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num, hcw_cnt), UVM_LOW)
            end 
          end //if (hcw_cnt == 0
        end //if (pend_cq_token_return_size > 0) 

      end //if (mon_enable == 1) intr process section 

    end //if (cq_poll_interval > 0)
  end //while (mon_enable) 

endtask : cq_buffer_monitor

task hqm_pp_cq_base_seq::gen_completions();
endtask : gen_completions

task hqm_pp_cq_base_seq::gen_renq_frag();
endtask : gen_renq_frag

task hqm_pp_cq_base_seq::get_hcw_gen_type(input  int            queue_list_index,
                                          input  bit            new_hcw_en,
                                          output bit            send_hcw,
                                          output hcw_cmd_type_t cmd_type,
                                          output int            cq_token_return,
                                          output int            is_ordered);
  bit hcw_ready;
  int pend_cq_token_return_size;
  int pend_comp_return_size;
  int pend_a_comp_return_size;
  int ret_val;
  bit sel_enq, sel_tok, sel_arm, sel_cmp, sel_a_cmp;
  bit out_of_credit;
  bit is_ao_cfg_v;
  int pf_pp;
  int pf_qid;

  hcw_gen_sem.get(1);

  send_hcw                    = 0;
  cq_token_return             = 0;
  is_ordered                  = 0;

  `uvm_info("PP_CQ_DEBUG",$psprintf("%s PP %0d index=%0d credit available=%0d(VAS=0x%0x)",pp_cq_type.name(),pp_cq_num,queue_list_index,i_hqm_pp_cq_status.vas_credit_avail(vas), vas),UVM_DEBUG)

  if (i_hqm_pp_cq_status.vas_credit_avail(vas) > 0) begin
    hcw_ready = 1;
  end else begin
    randcyc_crd_prob.randomize();
    if (randcyc_crd_prob.rand_exp < queue_list[queue_list_index].illegal_credit_prob) begin
      hcw_ready     = 1;
      out_of_credit = 1;
    end else begin
      hcw_ready = 0;
    end 
  end 

  if (queue_list[queue_list_index].comp_flow && !comp_return_delay) begin
    pend_comp_return.size(pend_comp_return_size);
  end else begin
    pend_comp_return_size = 0;
  end 

  if (queue_list[queue_list_index].comp_flow && !a_comp_return_delay) begin
    pend_a_comp_return.size(pend_a_comp_return_size);
  end else begin
    pend_a_comp_return_size = 0;
  end 

  if (queue_list[queue_list_index].cq_token_return_flow && !tok_return_delay) begin
    pend_cq_token_return.size(pend_cq_token_return_size);
  end else begin
    pend_cq_token_return_size = 0;
  end 

  if(hqm_stream_ctl==0) begin
     if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0)) sel_enq = 1;
     else sel_enq = 0;

     if(pend_cq_token_return_size > 0) sel_tok = 1;
     else                              sel_tok = 0;

     //--------------------------
     //--decide sel_cmp
     //-- hcw_acomp_ctrl=0: A_COMP+COMP order control by cq_comp_service_state (0: send sel_a_cmp; 1: send sel_cmp)
     //--------------------------
     if(hcw_acomp_ctrl==0 && $test$plusargs("HQM_ACOMP_COMP_RTNORDER") ) begin
        if(pend_comp_return_size > 0)     sel_cmp = 1;
        else                              sel_cmp = 0;

        if(cq_comp_service_state==0 && sel_cmp==1) begin
             `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfCmdGen1_COMP_HOLD: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;)) when sel_cmp=1 cq_comp_service_state=0 => force sel_cmp=0 ", pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp),UVM_MEDIUM)
              sel_cmp = 0;
        end 
     end else begin
        //-- default case hcw_acomp_ctrl = -1
        if(pend_comp_return_size > 0)     sel_cmp = 1;
        else                              sel_cmp = 0;
     end 

     //--------------------------
     //--decide sel_a_cmp
     //-- hcw_acomp_ctrl=0: A_COMP+COMP order control by cq_comp_service_state
     //-- hcw_acomp_ctrl=1: COMP+A_COMP order control by cq_comp_service_state
     //-- hcw_acomp_ctrl=2: ==> add another round of rand 
     //--------------------------
     //---- control of sel_a_cmp
     if(hcw_acomp_ctrl==0) begin
         if(pend_a_comp_return_size > 0 && cq_comp_service_state==0 )     sel_a_cmp = 1;
         else                                                             sel_a_cmp = 0;   
     end else begin
         if(pend_a_comp_return_size > 0)   sel_a_cmp = 1;
         else                              sel_a_cmp = 0;
         if(hcw_acomp_ctrl>0 && $urandom_range(hcw_acomp_ctrl,0) != 1 && sel_a_cmp==1) begin
             `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfCmdGen1_A_COMP_HOLD: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;)) when sel_a_cmp=1 => force sel_a_cmp=0 ", pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp),UVM_MEDIUM)
              sel_a_cmp = 0;
         end 
     end 

     //----
     if((cq_poll_interval == 0) && queue_list[queue_list_index].cq_token_return_flow && (pend_cq_int_arm.size() > 0)) sel_arm = 1;
     else                              sel_arm = 0;
  end else if(hqm_stream_ctl > 0) begin
     //-------------------------------
     //-- this is to support streaming traffic flow for performance test at GNRIO/GRR
     //-------------------------------
     `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfCmdGen1: %s PP %0d index=%0d hcw_ready=%0d new_hcw_en=%0d num_hcw=%0d num_hcw_loop=%0d pend_cq_token_return=%0d pend_a_comp_return=%0d pend_a_comp_return=%0d pend_cq_int_arm=%0d pend_comp_return=%0d out_of_credit=%0d (hqm_stream_flow_state=%0d)",pp_cq_type.name(),pp_cq_num,queue_list_index,hcw_ready,new_hcw_en, queue_list[queue_list_index].num_hcw, queue_list[queue_list_index].num_hcw_loop, pend_cq_token_return_size,pend_cq_int_arm.size(),pend_comp_return_size, pend_a_comp_return_size, pend_a_comp_return_size, out_of_credit, hqm_stream_flow_state),UVM_MEDIUM)

     if(hqm_stream_flow_state==0) begin
        if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0)) sel_enq = 1;
        else sel_enq = 0;

        sel_tok = 0;
        sel_cmp = 0;
        sel_arm = 0;
     end else if(hqm_stream_flow_state==1) begin
        if(hqm_stream_ctl==2) begin
           if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0)) sel_enq = 1;
           else sel_enq = 0;
        end else if(hqm_stream_ctl==1) begin
           //--when there is no comp (LDB) or token(DIR) available, don't send ENQ
           if(pp_cq_type == IS_LDB) begin
              if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) & (pend_comp_return_size > 0))     sel_enq = 1;
              else sel_enq = 0;
           end else begin
              if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) & (pend_cq_token_return_size > 0)) sel_enq = 1;
              else sel_enq = 0;
           end 
        end 

        if(pend_cq_token_return_size > 0 && sel_enq==1) sel_tok = 1;
        else                                            sel_tok = 0;

        if(pend_comp_return_size > 0 && sel_enq==1)     sel_cmp = 1;
        else                                            sel_cmp = 0;

        if(pend_a_comp_return_size > 0)   sel_a_cmp = 1;
        else                              sel_a_cmp = 0;

        sel_arm = 0;
     end else if(hqm_stream_flow_state==2) begin

        if(pend_cq_token_return_size > 0 ) sel_tok = 1;
        else                               sel_tok = 0;

        if(pend_comp_return_size > 0 )     sel_cmp = 1;
        else                               sel_cmp = 0;

        if(pend_a_comp_return_size > 0)    sel_a_cmp = 1;
        else                               sel_a_cmp = 0;

        sel_enq = 0;
        sel_arm = 0;
     end 
  end //--if(hqm_stream_ctl==0

  //-- is_ao_cfg_v
  if(queue_list[queue_list_index].qtype != QDIR) begin
     if(i_hqm_cfg.get_iov_mode() == HQM_PF_MODE) begin 
         is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(queue_list[queue_list_index].qid); 
        `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfCmdGen1.1: %s PP %0d index=%0d qid=%0d is_ao_cfg_v=%0d", pp_cq_type.name(), pp_cq_num, queue_list_index, queue_list[queue_list_index].qid, is_ao_cfg_v),UVM_MEDIUM)
     end else begin
         pf_qid      = i_hqm_cfg.get_sciov_qid((pp_cq_type == IS_LDB), pp_cq_num, (queue_list[queue_list_index].qtype != QDIR), queue_list[queue_list_index].qid, sciov_ignore_v, is_nm_pf);
         is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(pf_qid); 
        `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfCmdGen1.1: %s PP %0d index=%0d qtype=%0s vqid=%0d is_nm_pf=%0d => pf_qid=%0d is_ao_cfg_v=%0d", pp_cq_type.name(), pp_cq_num, queue_list_index, queue_list[queue_list_index].qtype.name(), queue_list[queue_list_index].qid, is_nm_pf, pf_qid, is_ao_cfg_v),UVM_MEDIUM)
     end 
  end else begin
     is_ao_cfg_v = 0;
  end 


  `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfCmdGen2 %s PP %0d index=%0d hcw_ready=%0d new_hcw_en=%0d num_hcw=%0d num_hcw_loop=%0d pend_cq_token_return=%0d pend_cq_int_arm=%0d pend_comp_return=%0d pend_a_comp_return=%0d cq_comp_service_state=%0d out_of_credit=%0d - selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_a_cmp=%0d; - qtype=%0s qid=%0d is_ao_cfg_v=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,hcw_ready,new_hcw_en,queue_list[queue_list_index].num_hcw, queue_list[queue_list_index].num_hcw_loop,pend_cq_token_return_size,pend_cq_int_arm.size(),pend_comp_return_size, pend_a_comp_return_size, cq_comp_service_state, out_of_credit, sel_enq, sel_tok, sel_arm, sel_cmp, sel_a_cmp, queue_list[queue_list_index].qtype.name(), queue_list[queue_list_index].qid, is_ao_cfg_v),UVM_MEDIUM)

  if(sel_a_cmp==1) begin
  //---------------------------------------------------
  //-- HQMV30 AO A_COMP support
  //---------------------------------------------------
        send_hcw            = 1;
        cmd_type            = A_COMP_CMD;
        pend_a_comp_return.pop(is_ordered);
        cq_comp_service_state = 1;
       `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfCmdGen2_A_COMP_SEND: %s PP %0d index=%0d cmd_type=%0s ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;)) is_ordered=%0d cq_comp_service_state=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, is_ordered, cq_comp_service_state),UVM_MEDIUM)

  end else begin
  //---------------------------------------------------
  //-- HQMV25 cases
  //---------------------------------------------------
 `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfCmdGen2_REGULAR: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;)) is_ordered=%0d; pend_cq_token_return=%0d pend_cq_int_arm=%0d pend_comp_return=%0d pend_a_comp_return=%0d is_ao_cfg_v=%0d cq_comp_service_state=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, is_ordered, pend_cq_token_return_size,pend_cq_int_arm.size(),pend_comp_return_size, pend_a_comp_return_size, is_ao_cfg_v, cq_comp_service_state),UVM_MEDIUM)

  case ({sel_enq,sel_tok,sel_arm,sel_cmp})
    4'b0000: begin
      cmd_type                = NOOP_CMD;
    end 
    4'b0001: begin
      is_ordered = pend_comp_return.data_q[0];

      if (is_ordered && is_ao_cfg_v==0) begin
        if ((queue_list[queue_list_index].qtype != QDIR) || hcw_ready) begin
          send_hcw            = 1;
          cmd_type            = RENQ_CMD;
          pend_comp_return.pop(is_ordered);
          cq_comp_service_state = 0;

          if (out_of_credit == 1'b0) begin 
            if (queue_list[queue_list_index].qtype == QDIR) begin
              i_hqm_pp_cq_status.wait_for_vas_credit(vas);
              renq_credits_rsvd--;
              i_hqm_pp_cq_status.put_vas_credit(vas);
            end else begin
              renq_credits_rsvd--;
            end 
          end 
        end else begin
          cmd_type            = NOOP_CMD;
          is_ordered          = 0;
        end 
      end else begin
        send_hcw              = 1;
        cmd_type              = COMP_CMD;
        pend_comp_return.pop(is_ordered);
        cq_comp_service_state = 0;
      end  
    end 
    4'b0010,4'b0110: begin  
      send_hcw                = 1;
      cmd_type                = ARM_CMD;
      pend_cq_int_arm.pop_front();
    end 
    4'b0011,4'b0111: begin  
      if ($urandom_range(1,0) == 0) begin
        is_ordered = pend_comp_return.data_q[0];

        if (is_ordered && is_ao_cfg_v==0) begin
          if ((queue_list[queue_list_index].qtype != QDIR) || hcw_ready) begin
            send_hcw            = 1;
            pend_comp_return.pop(is_ordered);
            cq_comp_service_state = 0;

            cmd_type                  = RENQ_CMD;

            if ( out_of_credit == 1'b0) begin
              if (queue_list[queue_list_index].qtype == QDIR) begin
                i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                renq_credits_rsvd--;
                i_hqm_pp_cq_status.put_vas_credit(vas);
              end else begin
                renq_credits_rsvd--;
              end 
            end 
          end else begin
            is_ordered          = 0;
            send_hcw            = 1;
            cmd_type            = ARM_CMD;
            pend_cq_int_arm.pop_front();
          end 
        end else begin
          send_hcw              = 1;
          cmd_type              = COMP_CMD;
          pend_comp_return.pop(is_ordered);
          cq_comp_service_state = 0;
        end 
      end else begin
        send_hcw                = 1;
        cmd_type                = ARM_CMD;
        pend_cq_int_arm.pop_front();
      end 
    end 
    4'b0100: begin
      send_hcw                = 1;
      cmd_type                = BAT_T_CMD;

      if (cq_poll_interval > 0) begin
        cq_token_return         = 0;
        while ((pend_cq_token_return_size > 0) && (cq_token_return < 1024)) begin
          cq_token_return++;
          pend_cq_token_return.pop(ret_val);
          pend_cq_token_return.size(pend_cq_token_return_size);
        end 
      end else begin
        pend_cq_token_return.pop(ret_val);
        cq_token_return         = ret_val;

        // only issue CQ interrupt ARM command if all tokens have been returned
        pend_cq_token_return.abs_size(pend_cq_token_return_size);
        if (pend_cq_token_return_size == 0) begin
          pend_cq_int_arm.push_front(1);
        end 
      end 
    end 
    4'b0101: begin
      is_ordered = pend_comp_return.data_q[0];

      if (is_ordered && is_ao_cfg_v==0) begin
        if ((queue_list[queue_list_index].qtype != QDIR) || hcw_ready) begin
          send_hcw            = 1;
          pend_comp_return.pop(is_ordered);
          cq_comp_service_state = 0;

          if (cq_poll_interval > 0) begin
            cmd_type                  = RENQ_T_CMD;
            cq_token_return           = 1;
            pend_cq_token_return.pop(ret_val);
          end else begin
            cmd_type                  = RENQ_CMD;
          end 

          if (out_of_credit == 1'b0) begin
            if (queue_list[queue_list_index].qtype == QDIR) begin
              i_hqm_pp_cq_status.wait_for_vas_credit(vas);
              renq_credits_rsvd--;
              i_hqm_pp_cq_status.put_vas_credit(vas);
            end else begin
              renq_credits_rsvd--;
            end 
          end 
        end else begin
          cmd_type            = NOOP_CMD;
          is_ordered          = 0;
        end 
      end else begin
        send_hcw              = 1;
        cmd_type              = COMP_T_CMD;
        pend_comp_return.pop(is_ordered);
        cq_comp_service_state = 0;

        if (cq_poll_interval > 0) begin
          cq_token_return     = 0;
          while ((pend_cq_token_return_size > 0) && (cq_token_return < 1024)) begin
            cq_token_return++;
            pend_cq_token_return.pop(ret_val);
            pend_cq_token_return.size(pend_cq_token_return_size);
          end 
        end else begin
          pend_cq_token_return.pop(ret_val);
          cq_token_return     = ret_val;

          // only issue CQ interrupt ARM command if all tokens have been returned
          pend_cq_token_return.abs_size(pend_cq_token_return_size);
          if (pend_cq_token_return_size == 0) begin
            pend_cq_int_arm.push_front(1);
          end 
        end 
      end 
    end 
    4'b1000: begin
      send_hcw                = 1;
      cmd_type                = NEW_CMD;

      if (out_of_credit == 1'b0) begin
        i_hqm_pp_cq_status.wait_for_vas_credit(vas);
      end 
    end 
    4'b1001: begin
      case ($urandom_range(1,0))
        0: begin
          is_ordered = pend_comp_return.data_q[0];

          if (is_ordered) begin
            if ((queue_list[queue_list_index].qtype != QDIR) || hcw_ready) begin
              send_hcw            = 1;
              cmd_type            = RENQ_CMD;
              pend_comp_return.pop(is_ordered);
              cq_comp_service_state = 0;

              if (out_of_credit == 1'b0) begin
                if (queue_list[queue_list_index].qtype == QDIR) begin
                  i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                  renq_credits_rsvd--;
                  i_hqm_pp_cq_status.put_vas_credit(vas);
                end else begin
                  renq_credits_rsvd--;
                end 
              end 
            end 
          end else begin
            send_hcw              = 1;
            cmd_type              = COMP_CMD;
            pend_comp_return.pop(is_ordered);
            cq_comp_service_state = 0;
          end 
        end 
        1: begin
          send_hcw              = 1;
          cmd_type              = NEW_CMD;

          if (out_of_credit == 1'b0) begin
            i_hqm_pp_cq_status.wait_for_vas_credit(vas);
          end 
        end 
      endcase
    end 
    4'b1010,4'b1110: begin
      if ($urandom_range(1,0) == 0) begin
        send_hcw                = 1;
        cmd_type                = NEW_CMD;

        if (out_of_credit == 1'b0) begin
          i_hqm_pp_cq_status.wait_for_vas_credit(vas);
        end 
      end else begin
        send_hcw                = 1;
        cmd_type                = ARM_CMD;
        pend_cq_int_arm.pop_front();
      end 
    end 
    4'b1011,4'b1111: begin
      case ($urandom_range(2,0))
        0: begin
          is_ordered = pend_comp_return.data_q[0];

          if (is_ordered) begin
            if ((queue_list[queue_list_index].qtype != QDIR) || hcw_ready) begin
              send_hcw            = 1;
              cmd_type            = RENQ_CMD;
              pend_comp_return.pop(is_ordered);
              cq_comp_service_state = 0;

              if (out_of_credit == 1'b0) begin
                if (queue_list[queue_list_index].qtype == QDIR) begin
                  i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                  renq_credits_rsvd--;
                  i_hqm_pp_cq_status.put_vas_credit(vas);
                end else begin
                  renq_credits_rsvd--;
                end 
              end 
            end 
          end else begin
            send_hcw            = 1;
            cmd_type            = COMP_CMD;
            pend_comp_return.pop(is_ordered);
              cq_comp_service_state = 0;
          end 
        end 
        1: begin
          send_hcw              = 1;
          cmd_type              = NEW_CMD;

          if (out_of_credit == 1'b0) begin
            i_hqm_pp_cq_status.wait_for_vas_credit(vas);
          end 
        end 
        2: begin
          send_hcw              = 1;
          cmd_type              = ARM_CMD;
          pend_cq_int_arm.pop_front();
        end 
      endcase
    end 
    4'b1100: begin  
      if (cq_poll_interval > 0) begin
        send_hcw                = 1;
        cmd_type                = NEW_T_CMD;
        cq_token_return         = 1;
        pend_cq_token_return.pop(ret_val);

        if (out_of_credit == 1'b0) begin
          i_hqm_pp_cq_status.wait_for_vas_credit(vas);
        end 
      end else begin
        if ($urandom_range(1,0) == 0) begin
          send_hcw              = 1;
          cmd_type              = NEW_CMD;

          if (out_of_credit == 1'b0) begin
            i_hqm_pp_cq_status.wait_for_vas_credit(vas);
          end 
        end else begin
          send_hcw                = 1;
          cmd_type                = BAT_T_CMD;
          pend_cq_token_return.pop(ret_val);
          cq_token_return         = ret_val;

          // only issue CQ interrupt ARM command if all tokens have been returned
          pend_cq_token_return.abs_size(pend_cq_token_return_size);
          if (pend_cq_token_return_size == 0) begin
            pend_cq_int_arm.push_front(1);
          end 
        end 
      end   
    end 
    4'b1101: begin
      int sel_val;    
 
      std::randomize(sel_val) with {sel_val dist { 0 := comp_weight, 1 := new_weight }; };

      if(cmd_type_sel>0) sel_val=0;
      if(hqm_stream_ctl > 0) sel_val=0;
 
      case (sel_val)
        0: begin
          is_ordered = pend_comp_return.data_q[0];

          if (is_ordered || (hqm_stream_ctl>0 && hqm_stream_flow_state==1)) begin
            if ((queue_list[queue_list_index].qtype != QDIR) || hcw_ready) begin
              send_hcw            = 1;
              pend_comp_return.pop(is_ordered);
              cq_comp_service_state = 0;

              if (cq_poll_interval > 0) begin
                cmd_type                  = RENQ_T_CMD;
                cq_token_return           = 1;
                pend_cq_token_return.pop(ret_val);
              end else begin
                cmd_type                  = RENQ_CMD;
              end 

              if (out_of_credit == 1'b0) begin
                if (queue_list[queue_list_index].qtype == QDIR) begin
                  i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                  renq_credits_rsvd--;
                  i_hqm_pp_cq_status.put_vas_credit(vas);
                end else if(hqm_stream_ctl>0 && hqm_stream_flow_state==1) begin
                  i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                end else begin
                  renq_credits_rsvd--;
                end 
              end 
            end 
          end else begin
            send_hcw              = 1;
            cmd_type              = COMP_T_CMD;
            pend_comp_return.pop(is_ordered);
            cq_comp_service_state = 0;

            if (cq_poll_interval > 0) begin
              cq_token_return     = 0;
              while ((pend_cq_token_return_size > 0) && (cq_token_return < 1024)) begin
                cq_token_return++;
                pend_cq_token_return.pop(ret_val);
                pend_cq_token_return.size(pend_cq_token_return_size);
              end 
            end else begin
              pend_cq_token_return.pop(ret_val);
              cq_token_return     = ret_val;

              // only issue CQ interrupt ARM command if all tokens have been returned
              pend_cq_token_return.abs_size(pend_cq_token_return_size);
              if (pend_cq_token_return_size == 0) begin
                pend_cq_int_arm.push_front(1);
              end 
            end 
          end 
        end 
        1: begin
          send_hcw              = 1;

          if (cq_poll_interval > 0) begin
            cmd_type              = NEW_T_CMD;
            cq_token_return       = 1;
            pend_cq_token_return.pop(ret_val);
          end else begin
            cmd_type              = NEW_CMD;
          end 

          if (out_of_credit == 1'b0) begin
            i_hqm_pp_cq_status.wait_for_vas_credit(vas);
          end 
        end 
      endcase 
    end 
  endcase
  end //if(sel_a_cmp==1) 

   pend_cq_token_return.size(pend_cq_token_return_size);
   pend_comp_return.size(pend_comp_return_size);
   pend_a_comp_return.size(pend_a_comp_return_size);
  `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfCmdGen3: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;)) is_ordered=%0d is_ao_cfg_v=%0d; num_hcw=%0d num_hcw_loop=%0d pend_cq_token_return=%0d pend_comp_return=%0d pend_a_comp_return=%0d, cq_comp_service_state=%0d, hqm_stream_flow_state=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, is_ordered, is_ao_cfg_v, queue_list[queue_list_index].num_hcw, queue_list[queue_list_index].num_hcw_loop, pend_cq_token_return_size, pend_comp_return_size, pend_a_comp_return_size, cq_comp_service_state, hqm_stream_flow_state),UVM_MEDIUM)

  hcw_gen_sem.put(1);
endtask : get_hcw_gen_type

task hqm_pp_cq_base_seq::get_illegal_hcw_gen_type(input  int                    queue_list_index,
                                                  input  bit                    new_hcw_en,
                                                  output bit                    send_hcw,
                                                  output hcw_cmd_type_t         cmd_type,
                                                  output illegal_hcw_type_t     illegal_hcw_type);
  bit hcw_ready;
  int illegal_hcw_type_index;

  hcw_gen_sem.get(1);

  send_hcw                    = 0;

  `uvm_info("PP_CQ_DEBUG",$psprintf("%s PP %0d index=%0d credit available=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,i_hqm_pp_cq_status.vas_credit_avail(vas)),UVM_MEDIUM)

  if (i_hqm_pp_cq_status.vas_credit_avail(vas) > 0) begin
    hcw_ready = new_hcw_en;
  end else begin
    hcw_ready = 0;
  end 

  illegal_hcw_type_index    = $urandom_range(queue_list[queue_list_index].illegal_hcw_type_q.size()-1,0);

  illegal_hcw_type          = queue_list[queue_list_index].illegal_hcw_type_q[illegal_hcw_type_index];

  send_hcw                  = 0;

  cmd_type                  = ILLEGAL_CMD;

  `uvm_info("PP_CQ_DEBUG",$psprintf("ILLEGAL HCW to be generated - %s PP %0d index=%0d hcw_ready=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,hcw_ready),UVM_MEDIUM)

  case (illegal_hcw_type)
    ILLEGAL_HCW_CMD: begin
      send_hcw = 1;
    end 
    ALL_0: begin
      if (hcw_ready) begin
        send_hcw = 1;
        i_hqm_pp_cq_status.wait_for_vas_credit(vas);
      end 
    end 
    ALL_1: begin
      if (hcw_ready) begin
        send_hcw = 1;
        i_hqm_pp_cq_status.wait_for_vas_credit(vas);
      end 
    end 
    ILLEGAL_PP_NUM: begin
      send_hcw = 1;
    end 
    ILLEGAL_PP_TYPE: begin
      send_hcw = 1;
    end 
    ILLEGAL_QID_NUM: begin
      if (queue_list[queue_list_index].qtype == QDIR) begin
        if (hcw_ready) begin
          send_hcw = 1;
          i_hqm_pp_cq_status.wait_for_vas_credit(vas);
        end 
      end else begin
        if (hcw_ready) begin
          send_hcw = 1;
          i_hqm_pp_cq_status.wait_for_vas_credit(vas);
        end 
      end 
    end 
    ILLEGAL_QID_TYPE: begin
      case (queue_list[queue_list_index].qtype)       // QID type will be flipped, so do correct credit check
        QDIR,QUNO,QORD: begin
          if (hcw_ready) begin
            send_hcw = 1;
            i_hqm_pp_cq_status.wait_for_vas_credit(vas);
          end 
        end 
        QATM: begin
          if (hcw_ready) begin
            send_hcw = 1;
            i_hqm_pp_cq_status.wait_for_vas_credit(vas);
          end 
        end 
      endcase
    end 
    ILLEGAL_DIRPP_RELS: begin
      send_hcw = 1;
    end 
    ILLEGAL_DEV_VF_NUM: begin
      if (is_vf) begin
        send_hcw = 1;
      end else begin
        if (queue_list[queue_list_index].qtype == QDIR) begin
          if (hcw_ready) begin
            send_hcw = 1;
            i_hqm_pp_cq_status.wait_for_vas_credit(vas);
          end 
        end else begin
          if (hcw_ready) begin
            send_hcw = 1;
            i_hqm_pp_cq_status.wait_for_vas_credit(vas);
          end 
        end 
      end 
    end 
    QID_GRT_127: begin
      if (queue_list[queue_list_index].qtype == QDIR) begin
        if (hcw_ready) begin
          send_hcw = 1;
          i_hqm_pp_cq_status.wait_for_vas_credit(vas);
        end 
      end else begin
        if (hcw_ready) begin
          send_hcw = 1;
          i_hqm_pp_cq_status.wait_for_vas_credit(vas);
        end 
      end 
    end 
    VAS_WRITE_PERMISSION: begin
      if (queue_list[queue_list_index].qtype == QDIR) begin
        if (hcw_ready) begin
          send_hcw = 1;
          i_hqm_pp_cq_status.wait_for_vas_credit(vas);
        end 
      end else begin
        if (hcw_ready) begin
          send_hcw = 1;
          i_hqm_pp_cq_status.wait_for_vas_credit(vas);
        end 
      end 
    end 
  endcase

  `uvm_info("PP_CQ_DEBUG",$psprintf("Send Illegal HCW - %s PP %0d index=%0d illegal_hcw_type=%s",pp_cq_type.name(),pp_cq_num,queue_list_index,illegal_hcw_type.name()),UVM_MEDIUM)
  hcw_gen_sem.put(1);
endtask : get_illegal_hcw_gen_type

function int hqm_pp_cq_base_seq::get_illegal_token_check(int queue_list_index,
                                                     int start_num,
                                                     int num_hcw);
  if (queue_list[queue_list_index].illegal_token_return_prob > 0) begin
    randcyc_tok_prob.randomize();
    if (randcyc_tok_prob.rand_exp < queue_list[queue_list_index].illegal_token_return_prob) begin
      return(1);
    end 
  end else begin
    if (queue_list[queue_list_index].illegal_token_return_burst_len > 0) begin
      if (queue_list[queue_list_index].illegal_token_return_active) begin
        queue_list[queue_list_index].illegal_token_return_burst_len--;
      end else if (num_hcw >= start_num) begin
        queue_list[queue_list_index].illegal_token_return_active = 1'b1;
        queue_list[queue_list_index].illegal_token_return_burst_len--;
      end 

      return(1);
    end else begin
      queue_list[queue_list_index].illegal_token_return_active = 1'b0;
    end 
  end 

  return(0);
endfunction : get_illegal_token_check

function int hqm_pp_cq_base_seq::get_illegal_comp_check(int queue_list_index,
                                                    int start_num,
                                                    int num_hcw);
  if (queue_list[queue_list_index].illegal_comp_prob > 0) begin
    randcyc_comp_prob.randomize();
    if (randcyc_comp_prob.rand_exp < queue_list[queue_list_index].illegal_comp_prob) begin
      return(1);
    end 
  end else begin
    if (queue_list[queue_list_index].illegal_comp_burst_len > 0) begin
      if (queue_list[queue_list_index].illegal_comp_active) begin
        queue_list[queue_list_index].illegal_comp_burst_len--;
      end else if (num_hcw >= start_num) begin
        queue_list[queue_list_index].illegal_comp_active = 1'b1;
        queue_list[queue_list_index].illegal_comp_burst_len--;
      end 

      return(1);
    end else begin
      queue_list[queue_list_index].illegal_comp_active = 1'b0;
    end 
  end 

  return(0);
endfunction : get_illegal_comp_check


//------------------------------------------------
//-- gen_queue_list
//------------------------------------------------
task hqm_pp_cq_base_seq::gen_queue_list(int queue_list_index);
  automatic   hcw_transaction         hcw_trans;
  automatic   hcw_transaction         hcw_trans_noop;
  automatic   hcw_cmd_type_t          cmd_type;
  automatic   illegal_hcw_type_t      illegal_hcw_type;
  automatic   int                     cq_token_return;
  automatic   bit                     send_hcw;
  automatic   int                     pend_cq_token_return_size;
  automatic   int                     pend_comp_return_size;
  automatic   int                     pend_a_comp_return_size;
  automatic   int                     is_ordered;
  automatic   bit                     do_hcw_delay;
  automatic   int                     queue_list_delay;
  automatic   int                     new_hcw_en_delay;
  automatic   bit                     new_hcw_en;
  automatic   slu_sm_ag_status_t      status;
  automatic   addr_t                  addr;
  automatic   byte_t                  data[$];
  automatic   bit                     be[$];
  automatic   bit                     illegal_hcw_burst_active;
  automatic   int                     illegal_hcw_burst_count;
  automatic   int                     illegal_hcw_burst_start_num;    // generate burst after this many HCWs
  automatic   hcw_transaction         hcw_trans_in;
  automatic   int                     dist_seed;
  int                                 trf_loop_num;
  hcw_transaction                     hcw_ex_noop;
  int                                 cq_ats_resp_errinj_issued;

  dist_seed = $urandom_range(32'h7fffffff,0);

  active_gen_queue_list_cnt++;

  queue_list_delay = $urandom_range(queue_list_delay_max,queue_list_delay_min);
  new_hcw_en_delay = $urandom_range(new_hcw_en_delay_max,new_hcw_en_delay_min);

  illegal_hcw_burst_start_num = $urandom_range(queue_list[queue_list_index].num_hcw,0);
  illegal_hcw_burst_count     = (queue_list[queue_list_index].illegal_hcw_gen_mode == BURST_ILLEGAL) ? queue_list[queue_list_index].illegal_hcw_burst_len : 0;
  illegal_hcw_burst_active    = 1'b0;

  while (mon_enable) begin

    new_hcw_en = cycle_count > (new_hcw_en_delay + (queue_list_index * queue_list_delay));

    pend_cq_token_return.abs_size(pend_cq_token_return_size);         // get absolute size
    pend_comp_return.abs_size(pend_comp_return_size);                 // get absolute size
    pend_a_comp_return.abs_size(pend_a_comp_return_size);             // get absolute size

    if ((queue_list[queue_list_index].num_hcw > 0) || (illegal_hcw_burst_count > 0) || (pend_cq_token_return_size > 0) || (pend_cq_int_arm.size() > 0) || (pend_comp_return_size > 0) || (pend_a_comp_return_size > 0)) begin
      mon_watchdog_reset();

      if (!illegal_hcw_burst_active && (illegal_hcw_burst_count > 0)) begin
        if (illegal_hcw_burst_start_num == queue_list[queue_list_index].num_hcw) begin
          illegal_hcw_burst_active = 1'b1;
        end 
      end 

      if (illegal_hcw_burst_active && (illegal_hcw_burst_count == 0)) begin
        illegal_hcw_burst_active = 1'b0;
      end 

      `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfGen1: %s PP %0d index=%0d num_hcw=%0d num_hcw_loop=%0d illegal_hcw_burst_count=%0d pend_cq_token_return=%0d pend_cq_int_arm=%0d pend_comp_return=%0d pend_a_comp_return=%0d (hqm_stream_flow_state=%0d), tbcnt_base=0x%0x tbcnt_offset=0x%0x",pp_cq_type.name(),pp_cq_num,queue_list_index,queue_list[queue_list_index].num_hcw, queue_list[queue_list_index].num_hcw_loop, illegal_hcw_burst_count,pend_cq_token_return_size,pend_cq_int_arm.size(),pend_comp_return_size, pend_a_comp_return_size, hqm_stream_flow_state, tbcnt_base, queue_list[queue_list_index].tbcnt_offset),UVM_MEDIUM)

      randcyc_hcw_prob.randomize();
      if ( illegal_hcw_burst_active ||
           ( (queue_list[queue_list_index].num_hcw > 0) &&
             (queue_list[queue_list_index].illegal_hcw_gen_mode == RAND_ILLEGAL) &&
             (randcyc_hcw_prob.rand_exp  < queue_list[queue_list_index].illegal_hcw_prob)
           )
         ) begin
        get_illegal_hcw_gen_type(queue_list_index,
                                 new_hcw_en,
                                 send_hcw,
                                 cmd_type,
                                 illegal_hcw_type);

        if (send_hcw & illegal_hcw_burst_active) begin
          illegal_hcw_burst_count--;
        end 

        is_ordered = 0;

        `uvm_info("PP_CQ_DEBUG",$psprintf("%s PP %0d index=%0d send_hcw=%0d cmd_type=%s cq_token_return=%0d is_ordered=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,send_hcw,cmd_type.name(),cq_token_return,is_ordered),UVM_MEDIUM)
      end else begin
        get_hcw_gen_type(queue_list_index,new_hcw_en,send_hcw,cmd_type,cq_token_return,is_ordered);

        `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfGen2: %s PP %0d index=%0d send_hcw=%0d cmd_type=%s num_hcw=%0d num_hcw_loop=%0d pend_cq_token_return=%0d pend_comp_return=%0d pend_a_comp_return=%0d cq_token_return=%0d is_ordered=%0d legal_hcw_count=%0d (hqm_stream_flow_state=%0d)",pp_cq_type.name(),pp_cq_num,queue_list_index,send_hcw,cmd_type.name(), queue_list[queue_list_index].num_hcw, queue_list[queue_list_index].num_hcw_loop, pend_cq_token_return_size,pend_comp_return_size, pend_a_comp_return_size, cq_token_return,is_ordered, queue_list[queue_list_index].legal_hcw_count, hqm_stream_flow_state),UVM_MEDIUM)
      end 

      //-------------------------
      if (send_hcw) begin

        `uvm_create(hcw_trans);

        //---------------------------
        hcw_trans.randomize();
        hcw_trans.rsvd0               = hcw_rsvd0_random ? $urandom_range(0,7) : '0;
        hcw_trans.dsi_error           = '0;
        hcw_trans.no_inflcnt_dec      = '0;
        hcw_trans.dbg                 = '0;
        hcw_trans.cmp_id              = '0;
        hcw_trans.is_nm_pf            = is_nm_pf;
        hcw_trans.is_vf               = is_vf;
        hcw_trans.vf_num              = vf_num;
        //hcw_trans.sai                 = 8'h03;
        hcw_trans.sai                 = dis_random_sai ?'h03: $urandom_range(0,255);
        hcw_trans.rtn_credit_only     = '0;
        hcw_trans.exp_rtn_credit_only = '0;
        hcw_trans.ingress_drop        = '0;
        hcw_trans.exp_ingress_drop    = '0;
        hcw_trans.ingress_comp_nodrop = '0;
        hcw_trans.is_ord              = is_ordered;
        hcw_trans.ordqid              = '0;
        hcw_trans.ordpri              = '0;
        hcw_trans.ordlockid           = '0;
        hcw_trans.ordidx              = '0;
        hcw_trans.reord               = '0;
        hcw_trans.frg_cnt             = '0;
        hcw_trans.frg_last            = '0;
        hcw_trans.is_ldb              = pp_cq_type == IS_LDB;
        hcw_trans.ppid                = pp_cq_num;
        hcw_trans.dsi_error           = 0;
        hcw_trans.meas                = hcw_meas_on? 1 : 0;
        hcw_trans.randomize(wu) with {
                                        wu >= hcw_enqueue_wu_min;
                                        wu <= hcw_enqueue_wu_max;
                                     };
        hcw_trans.msgtype             = 0;
        hcw_trans.randomize(qpri) with {qpri dist {0 := queue_list[queue_list_index].qpri_weight[0], 
                                                   1 := queue_list[queue_list_index].qpri_weight[1], 
                                                   2 := queue_list[queue_list_index].qpri_weight[2], 
                                                   3 := queue_list[queue_list_index].qpri_weight[3], 
                                                   4 := queue_list[queue_list_index].qpri_weight[4], 
                                                   5 := queue_list[queue_list_index].qpri_weight[5], 
                                                   6 := queue_list[queue_list_index].qpri_weight[6], 
                                                   7 := queue_list[queue_list_index].qpri_weight[7]};
                                       }; 
        hcw_trans.qtype               = queue_list[queue_list_index].qtype;
        hcw_trans.qid                 = queue_list[queue_list_index].qid;
        hcw_trans.idsi                = queue_list[queue_list_index].dsi;

        if (hcw_trans.qtype != QDIR) begin
          hcw_trans.idsi              = $urandom_range(32'hffffffff,32'h0);
        end 


        if(hcw_lockid_ctrl==1) begin
          hcw_trans.lockid              = queue_list[queue_list_index].lock_id + queue_list[queue_list_index].legal_hcw_count;
        end else if(hcw_lockid_ctrl==2) begin
          hcw_trans.lockid              = queue_list[queue_list_index].lock_id + queue_list[queue_list_index].legal_hcw_count[3:0];
        end else begin
          hcw_trans.lockid              = queue_list[queue_list_index].lock_id;
        end 
        hcw_trans.is_nm_pf            = queue_list[queue_list_index].is_nm_pf;

        if (hcw_trans.qtype != QATM) begin
          //hcw_trans.lockid            = $urandom_range(32'hffffffff,32'h0);
          //-- for QORD: use lockid[7:0] to carry original {is_ldb, ppid} info => used in scoreboard when checking ordering on 2ndP: check_reord_queue()
          if(hcw_trans.qtype == QORD)   hcw_trans.lockid   = {1'b1, 7'b0, hcw_trans.is_ldb, hcw_trans.ppid[6:0]};
          else                          hcw_trans.lockid   = $urandom_range(32'hffffffff,32'h0);
        end 

        //---------------------------
        if(hqm_stream_ctl==0) begin
             hcw_trans.tbcnt               = hcw_trans.get_transaction_id() + tbcnt_base + queue_list[queue_list_index].tbcnt_offset;

             `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfGen3.0: %s PP %0d index=%0d send_hcw=%0d cmd_type=%s num_hcw=%0d pend_cq_token_return=%0d pend_comp_return=%0d pend_a_comp_return=%0d; tbcnt=0x%0x tbcnt_base=0x%0x tbcnt_offset=0x%0x trf_hcw_cnt=%0d, is_ordered=%0d",pp_cq_type.name(), pp_cq_num, queue_list_index, send_hcw, cmd_type.name(), queue_list[queue_list_index].num_hcw, pend_cq_token_return_size, pend_comp_return_size, pend_a_comp_return_size, hcw_trans.tbcnt, tbcnt_base, queue_list[queue_list_index].tbcnt_offset,trf_hcw_cnt, is_ordered),UVM_MEDIUM)

        end else begin
             if(hqm_stream_flow_state==0)      trf_loop_num=0; 
             else if(hqm_stream_flow_state==1) trf_loop_num=(trf_hcw_cnt) / trf_num_hcw;
             else if(hqm_stream_flow_state==2) trf_loop_num=255;

             //-- tbcnt[63:56]=ldb 
             //-- tbcnt[55:48]=pp_cq_num
             //-- tbcnt[47:32]=loop num
             //-- tbcnt[31:0] =trf_hcw_cnt (incr)
             hcw_trans.tbcnt               = trf_hcw_cnt + tbcnt_base + queue_list[queue_list_index].tbcnt_offset;
             hcw_trans.tbcnt[47:32]        = trf_loop_num;             
             `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfGen3.0: %s PP %0d index=%0d send_hcw=%0d cmd_type=%s num_hcw=%0d num_hcw_loop=%0d trf_loop_num=%0d pend_cq_token_return=%0d pend_comp_return=%0d pend_a_comp_return=%0d tbcnt=0x%0x trf_hcw_cnt=%0d (hqm_stream_flow_state=%0d)",pp_cq_type.name(), pp_cq_num, queue_list_index, send_hcw, cmd_type.name(), queue_list[queue_list_index].num_hcw, queue_list[queue_list_index].num_hcw_loop, trf_loop_num, pend_cq_token_return_size,pend_comp_return_size, pend_a_comp_return_size, hcw_trans.tbcnt, trf_hcw_cnt, hqm_stream_flow_state),UVM_MEDIUM)

        end 

        //---------------------------
        //--hcw_trans.idsi
        if(hcw_dsi_ctrl==1)      hcw_trans.idsi = $realtime/1ns;
        else if(hcw_dsi_ctrl==2) hcw_trans.idsi = hcw_trans.tbcnt;
        else if(hcw_dsi_ctrl==3) hcw_trans.idsi = 16'hffff - hcw_trans.tbcnt;

        if(queue_list[queue_list_index].inc_lock_id) begin
          queue_list[queue_list_index].lock_id++;
        end 

        do_hcw_delay = ~queue_list[queue_list_index].hcw_delay_qe_only;

        //---------------------------
        case (cmd_type)
          NOOP_CMD:       begin
            hcw_trans.qe_valid    = 0;
            hcw_trans.qe_orsp     = 0;
            hcw_trans.qe_uhl      = 0;
            hcw_trans.cq_pop      = 0;
          end 
          BAT_T_CMD:      begin
            hcw_trans.qe_valid    = 0;
            hcw_trans.qe_orsp     = 0;
            hcw_trans.qe_uhl      = get_illegal_comp_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);
            hcw_trans.cq_pop      = 1;
            hcw_trans.lockid      = cq_token_return - 1;
            total_tok_return_count += cq_token_return;
            `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("BAT_T HCW returning 0x%0x tokens to %s CQ 0x%0x",cq_token_return,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_MEDIUM)
          end 
          RELS_CMD:       begin
            hcw_trans.qe_valid    = 0;
            hcw_trans.qe_orsp     = 1;
            hcw_trans.qe_uhl      = 0;
            hcw_trans.cq_pop      = 0;
          end 
          COMP_CMD, A_COMP_CMD:       begin
            ////--HQMV25 hcw_trans_in          = pend_hcw_trans.pop_front();
            ////--HQMV25 hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
            ////--HQMV25 hcw_trans.qe_valid    = 0;
            ////--HQMV25 hcw_trans.qe_orsp     = 0;
            ////--HQMV25 hcw_trans.qe_uhl      = 1;


            //--HQMV30_AO or Regular case
            if(cmd_type==COMP_CMD) begin
                hcw_trans_in          = pend_hcw_trans.pop_front();
                hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
                hcw_trans.qe_valid    = 0;
                hcw_trans.qe_orsp     = 0;
                hcw_trans.qe_uhl      = 1;
            end else begin  
                hcw_trans_in          = pend_hcw_trans_comb.pop_front();
                hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
                hcw_trans.qe_valid    = 0;
                hcw_trans.qe_orsp     = 1;
                hcw_trans.qe_uhl      = 1;
            end 


            if(is_ordered==0) begin //if(hcw_trans_in.tbcnt === 64'hxxxxxxxxxxxxxxxx) begin
               `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%0s HCW returning 0x%0x tokens and a completion to %s CQ/PP 0x%0x hcw_trans_in.tbcnt=0x%0x cmp_id=%0d => use hcw_trans.tbcnt=0x%0x",cmd_type.name(), cq_token_return,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",  pp_cq_num, hcw_trans_in.tbcnt,hcw_trans_in.cmp_id, hcw_trans.tbcnt),UVM_MEDIUM)
            end else begin
               if(cmd_type_sel==0) begin
                   hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
               end 
            end 

            total_comp_return_count++;
            hcw_trans.cq_pop      = get_illegal_token_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);
            if (hcw_trans.cq_pop) begin
              hcw_trans.lockid    = 0;
              `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%0s with token HCW returning 1 token and a completion for %s PP 0x%0x",cmd_type.name(), (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_MEDIUM)
            end else begin
              `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%0s HCW returning completion for %s PP 0x%0x tbcnt=0x%0x", cmd_type.name(),(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hcw_trans.tbcnt),UVM_MEDIUM)
            end 
          end 
          COMP_T_CMD, A_COMP_T_CMD:     begin
            ////--HQMV25 hcw_trans_in          = pend_hcw_trans.pop_front();

            ////--HQMV25 hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
            ////--HQMV25 hcw_trans.qe_valid    = 0;
            ////--HQMV25 hcw_trans.qe_orsp     = 0;
            ////--HQMV25 hcw_trans.qe_uhl      = 1;

            //--HQMV30_AO or Regular case
            if(cmd_type==COMP_T_CMD) begin
                hcw_trans_in          = pend_hcw_trans.pop_front();
                hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
                hcw_trans.qe_valid    = 0;
                hcw_trans.qe_orsp     = 0;
                hcw_trans.qe_uhl      = 1;
            end else begin  
                hcw_trans_in          = pend_hcw_trans_comb.pop_front();
                hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
                hcw_trans.qe_valid    = 0;
                hcw_trans.qe_orsp     = 1;
                hcw_trans.qe_uhl      = 1;
            end 
          
            
            if(is_ordered==0) begin //hcw_trans_in.tbcnt === 64'hxxxxxxxxxxxxxxxx) begin
               `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%0s HCW returning 0x%0x tokens and a completion to %s CQ/PP 0x%0x hcw_trans_in.tbcnt=0x%0x cmp_id=%0d => use hcw_trans.tbcnt=0x%0x",cmd_type.name(), cq_token_return,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",  pp_cq_num, hcw_trans_in.tbcnt,hcw_trans_in.cmp_id, hcw_trans.tbcnt),UVM_MEDIUM)
            end else begin
               if(cmd_type_sel==0) begin
                  hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
                 `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%0s HCW returning 0x%0x tokens and a completion to %s CQ/PP 0x%0x tbcnt=0x%0x cmp_id=%0d",cmd_type.name(), cq_token_return,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",  pp_cq_num, hcw_trans_in.tbcnt,hcw_trans_in.cmp_id),UVM_MEDIUM)
               end 
            end 



            total_comp_return_count++;
            hcw_trans.cq_pop      = 1;
            hcw_trans.lockid      = cq_token_return - 1;
            total_tok_return_count += cq_token_return;
            `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%0s HCW returning 0x%0x tokens and a completion to %s CQ/PP 0x%0x tbcnt=0x%0x",cmd_type.name(), cq_token_return,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",  pp_cq_num, hcw_trans.tbcnt),UVM_MEDIUM)
          end 
          NEW_CMD:        begin
            hcw_trans.qe_valid    = 1;
            hcw_trans.qe_orsp     = 0;
            hcw_trans.qe_uhl      = get_illegal_comp_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);
            hcw_trans.cq_pop      = get_illegal_token_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);

            do_hcw_delay          = 1'b1;

            if (queue_list[queue_list_index].hcw_time > 0) begin
              if (cycle_count >= queue_list[queue_list_index].hcw_time) begin
                queue_list[queue_list_index].num_hcw = 0;
              end 
            end else begin
              queue_list[queue_list_index].num_hcw--;
            end 

            `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP 0x%0x NEW HCW to QID 0x%0x QTYPE %s (tbcnt=0x%0x)",
                                                     (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                     pp_cq_num,
                                                     hcw_trans.qid,
                                                     hcw_trans.qtype.name(),
                                                     hcw_trans.tbcnt
                                                    ) ,UVM_MEDIUM)
          end 
          NEW_T_CMD:      begin
            hcw_trans.qe_valid    = 1;
            hcw_trans.qe_orsp     = 0;
            hcw_trans.qe_uhl      = get_illegal_comp_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);
            hcw_trans.cq_pop      = 1;
            total_tok_return_count++;

            do_hcw_delay          = 1'b1;

            if (queue_list[queue_list_index].hcw_time > 0) begin
              if (cycle_count >= queue_list[queue_list_index].hcw_time) begin
                queue_list[queue_list_index].num_hcw = 0;
              end 
            end else begin
              queue_list[queue_list_index].num_hcw--;
            end 


            `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP 0x%0x NEW HCW to QID 0x%0x QTYPE %s (tbcnt=0x%0x), returning 1 token to %s CQ 0x%0x",
                                                     (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                     pp_cq_num,
                                                     hcw_trans.qid,
                                                     hcw_trans.qtype.name(),
                                                     hcw_trans.tbcnt,
                                                     (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                     pp_cq_num
                                                    ) ,UVM_MEDIUM)
          end 
          RENQ_CMD:       begin
            hcw_trans_in          = pend_hcw_trans.pop_front();

            if(cmd_type_sel==0) begin
                hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
            end 
            hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
            hcw_trans.qe_valid    = 1;
            hcw_trans.qe_orsp     = 0;
            hcw_trans.qe_uhl      = 1;
            total_comp_return_count++;
            hcw_trans.cq_pop      = get_illegal_token_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);
            do_hcw_delay          = 1'b1;

            //--
            if(cmd_type_sel==3) begin
              queue_list[queue_list_index].num_hcw--;
            end 

            `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP 0x%0x RENQ HCW to QID 0x%0x QTYPE %s (tbcnt=0x%0x)",
                                                     (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                     pp_cq_num,
                                                     hcw_trans.qid,
                                                     hcw_trans.qtype.name(),
                                                     hcw_trans.tbcnt
                                                    ) ,UVM_MEDIUM)
          end 
          RENQ_T_CMD:     begin
            hcw_trans_in          = pend_hcw_trans.pop_front();

            if(cmd_type_sel==0) begin 
               hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
            end 
            hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
            hcw_trans.qe_valid    = 1;
            hcw_trans.qe_orsp     = 0;
            hcw_trans.qe_uhl      = 1;
            total_comp_return_count++;
            hcw_trans.cq_pop      = 1;
            total_tok_return_count++;
            do_hcw_delay          = 1'b1;
            
            //--hqm_stream_ctl
            if((hqm_stream_ctl>0 && hqm_stream_flow_state==1) || (cmd_type_sel==3)) begin
              queue_list[queue_list_index].num_hcw--;
            end 

            `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP 0x%0x RENQ HCW to QID 0x%0x QTYPE %s (tbcnt=0x%0x), returning 1 token to %s CQ 0x%0x",
                                                     (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                     pp_cq_num,
                                                     hcw_trans.qid,
                                                     hcw_trans.qtype.name(),
                                                     hcw_trans.tbcnt,
                                                     (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                     pp_cq_num
                                                    ) ,UVM_MEDIUM)
          end 
          ARM_CMD:       begin
            hcw_trans.qe_valid    = 0;
            hcw_trans.qe_orsp     = 1;
            hcw_trans.qe_uhl      = 0;
            hcw_trans.cq_pop      = 1;
          end 
          ILLEGAL_CMD:      begin
            hcw_trans.qe_valid    = 1;
            hcw_trans.qe_orsp     = 0;
            hcw_trans.qe_uhl      = 0;
            hcw_trans.cq_pop      = 0;

            if (queue_list[queue_list_index].illegal_hcw_gen_mode == RAND_ILLEGAL) begin
              queue_list[queue_list_index].num_hcw--;
            end 

            if (illegal_hcw_burst_active) begin
              do_hcw_delay    = 1'b0;
            end else begin
              do_hcw_delay    = 1'b1;
            end 

            corrupt_hcw(hcw_trans,illegal_hcw_type);

            `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("Illegal HCW - %s PP 0x%0x NEW HCW to QID 0x%0x QTYPE %s (tbcnt=0x%0x)",
                                                     (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                     pp_cq_num,
                                                     hcw_trans.qid,
                                                     hcw_trans.qtype.name(),
                                                     hcw_trans.tbcnt
                                                    ) ,UVM_MEDIUM)
          end 
        endcase

        //---------------------------
        queue_list[queue_list_index].cmd_count[cmd_type]++;

        hcw_trans.iptr        = hcw_trans.tbcnt;

        if (hcw_trans.qe_valid) begin
          if (cmd_type == ILLEGAL_CMD) begin
            queue_list[queue_list_index].illegal_hcw_count++;
          end else begin
            queue_list[queue_list_index].legal_hcw_count++;
          end 
        end 

        //---------------------------
        if(hqm_stream_ctl > 0) begin
          //-------------------------------
          //-- this is to support streaming traffic flow for performance test at GNRIO/GRR
          //-- hqm_stream_flow_state update
          //-------------------------------
          if(hqm_stream_flow_state==0) begin
            if(queue_list[queue_list_index].num_hcw==0) begin
               hqm_stream_flow_state=1;   
               queue_list[queue_list_index].num_hcw = queue_list[queue_list_index].num_hcw_loop;
            end 
          end else if(hqm_stream_flow_state==1) begin
            if(queue_list[queue_list_index].num_hcw==0) begin
               hqm_stream_flow_state=2;   
            end 
          end 
        end 

        //---------------------------
        //-- HQMV25:  if (queue_list[queue_list_index].num_hcw == 0) begin
        if (queue_list[queue_list_index].num_hcw <= 0) begin
          finish_hcw(hcw_trans,1'b1);
        end else begin
          finish_hcw(hcw_trans,1'b0);

          //--extra_noop_pattern
          if( ($urandom_range(hcw_enqueue_expad_prob_max, hcw_enqueue_expad_prob_min))  > ($urandom_range(99,0)) ) begin
               $cast(hcw_ex_noop, hcw_trans.clone());  
               hcw_ex_noop.qe_valid = 0;
               hcw_ex_noop.qe_orsp  = 0;
               hcw_ex_noop.qe_uhl   = 0;
               hcw_ex_noop.cq_pop   = 0;

              if(($test$plusargs("HQM_ENQ_DIR_EX_NOOP_PAD") && hcw_trans.qe_valid && hcw_trans.qtype == QDIR) ||
                 ($test$plusargs("HQM_ENQ_BATT_EX_NOOP_PAD") && (hcw_trans.qe_valid==0 && hcw_trans.qe_orsp==0 && hcw_trans.qe_uhl==0 && hcw_trans.cq_pop==1))  || 
                 ($test$plusargs("HQM_ENQ_RAND_EX_NOOP_PAD"))   
                ) begin 
                  finish_hcw(hcw_ex_noop,1'b0);

                  if($test$plusargs("HQM_ENQ_EX_NOOP_PAD_2")) begin
                     finish_hcw(hcw_ex_noop,1'b0);
                  end 
                  if($test$plusargs("HQM_ENQ_EX_NOOP_PAD_3")) begin
                     finish_hcw(hcw_ex_noop,1'b0);
                  end 
              end //--

              //-- HCW opt=NOOP, the other bits are all 1
              if($test$plusargs("HQM_ENQ_INJ_NOOP_HCW")) begin
                   $cast(hcw_ex_noop, hcw_trans.clone());  
                   hcw_ex_noop.qe_valid = 0;
                   hcw_ex_noop.qe_orsp  = 0;
                   hcw_ex_noop.qe_uhl   = 0;
                   hcw_ex_noop.cq_pop   = 0;
                   hcw_ex_noop.rsvd0[2:0]   = 'h7;
                   hcw_ex_noop.dsi_error    = 'h1;
                   hcw_ex_noop.cmp_id[3:0]  = 'hf;
                   hcw_ex_noop.no_inflcnt_dec  = 'h1;
                   hcw_ex_noop.wu           = 'h3;
                   hcw_ex_noop.meas         = 'h1;
                   hcw_ex_noop.lockid       = 'hffff;
                   hcw_ex_noop.msgtype[2:0] = 'h7;
                   hcw_ex_noop.qpri[2:0]    = 'h7;
                   hcw_ex_noop.qtype[1:0]   = 'h3;
                   hcw_ex_noop.qid[7:0]     = 'hff;
                   hcw_ex_noop.idsi[15:0]   = 'hffff;
                   hcw_ex_noop.iptr[63:0]   = 'hffffffffffffffff;

                  `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x Inject NOOP HCW1 with all bits 1", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
                   finish_hcw(hcw_ex_noop,1'b0);

                  if($test$plusargs("HQM_ENQ_INJ_NOOP_HCW_2")) begin
                    `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x Inject NOOP HCW2 with all bits 1", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
                     finish_hcw(hcw_ex_noop,1'b0);
                  end 
                  if($test$plusargs("HQM_ENQ_INJ_NOOP_HCW_3")) begin
                    `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP/CQ 0x%0x Inject NOOP HCW3 with all bits 1", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
                     finish_hcw(hcw_ex_noop,1'b0);
                  end 
              end //-- HQM_ENQ_EX_NOOP_HCW
          end //--extra_noop_pattern
        end //--finish_hcw

        //---------------------------
        if (do_hcw_delay) begin
          int   tmp_hcw_delay_rem;

          tmp_hcw_delay_rem = queue_list[queue_list_index].hcw_delay_rem;
          if(hcw_delay_ctrl_mode > 0) begin
             //-- burst of trf in a simple method
             if(hcw_delay_ctrl_mode == 1 && queue_list[queue_list_index].legal_hcw_count%8 != 7) begin
                  hcw_delay($urandom_range(queue_list[queue_list_index].hcw_delay_min,queue_list[queue_list_index].hcw_delay_min),tmp_hcw_delay_rem);
             end else if(hcw_delay_ctrl_mode == 2 && queue_list[queue_list_index].legal_hcw_count%16 != 15) begin
                  hcw_delay($urandom_range(queue_list[queue_list_index].hcw_delay_min,queue_list[queue_list_index].hcw_delay_min),tmp_hcw_delay_rem);
             end else if(hcw_delay_ctrl_mode == 3 && queue_list[queue_list_index].legal_hcw_count%32 != 31) begin
                  hcw_delay($urandom_range(queue_list[queue_list_index].hcw_delay_min,queue_list[queue_list_index].hcw_delay_min),tmp_hcw_delay_rem);
             end else if(hcw_delay_ctrl_mode == 4 && queue_list[queue_list_index].legal_hcw_count%64 != 63) begin
                  hcw_delay($urandom_range(queue_list[queue_list_index].hcw_delay_min,queue_list[queue_list_index].hcw_delay_min),tmp_hcw_delay_rem);
             end else begin
                  hcw_delay($urandom_range(queue_list[queue_list_index].hcw_delay_max,queue_list[queue_list_index].hcw_delay_max),tmp_hcw_delay_rem);
             end 
          end else begin
            case (queue_list[queue_list_index].hcw_delay_type)
              NORMAL_DIST: begin
                hcw_delay($urandom_range(queue_list[queue_list_index].hcw_delay_max,queue_list[queue_list_index].hcw_delay_min),tmp_hcw_delay_rem);
              end 
              POISSON_DIST: begin
                hcw_delay($dist_poisson(dist_seed,(queue_list[queue_list_index].hcw_delay_max + queue_list[queue_list_index].hcw_delay_min)/2),tmp_hcw_delay_rem);
              end 
            endcase
          end 
          queue_list[queue_list_index].hcw_delay_rem = tmp_hcw_delay_rem;
        end //--if (do_hcw_delay)


        //---------------------------
         trf_hcw_cnt++;   
        `uvm_info("PP_CQ_DEBUGTRFGEN",$psprintf("TrfGen3: %s PP %0d index=%0d send_hcw=%0d cmd_type=%s num_hcw=%0d num_hcw_loop=%0d pend_cq_token_return=%0d pend_comp_return=%0d pend_a_comp_return=%0d (hqm_stream_flow_state=%0d)",pp_cq_type.name(), pp_cq_num, queue_list_index, send_hcw, cmd_type.name(), queue_list[queue_list_index].num_hcw, queue_list[queue_list_index].num_hcw_loop, pend_cq_token_return_size, pend_comp_return_size, pend_a_comp_return_size, hqm_stream_flow_state),UVM_MEDIUM)
      end else begin
        sys_clk_delay(1);
      end //--if (send_hcw
    end else begin
      sys_clk_delay(1);
    end 
  end 

  `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("%s PP 0x%0x Queue Index %0d generated %0d legal HCW  %0d illegal HCW",
                                           (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                           pp_cq_num,
                                           queue_list_index,
                                           queue_list[queue_list_index].legal_hcw_count,
                                           queue_list[queue_list_index].illegal_hcw_count),UVM_LOW)

  foreach (queue_list[queue_list_index].cmd_count[t]) begin
    `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("    Command %s count=%0d",t.name(),queue_list[queue_list_index].cmd_count[t]),UVM_LOW)
  end 

  active_gen_queue_list_cnt--;
endtask : gen_queue_list

task hqm_pp_cq_base_seq::finish_hcw(hcw_transaction hcw_trans,
                                    bit last_hcw);

  hcw_transaction       to_q;
  bit [127:0]           hcw_data;
  hqm_hcw_enq_seq       hcw_enq_seq;
  int                   num_hcw;
  bit [3:0]             cache_line_rndaddr; //--support 0-15 cache line aperture
  int                   is_noop_pad, noop_pad_cnt, noop_qtype_sel;
  int                   hcw_enqueue_claddrctl; 
  int                   batch_num;
  int                   remain_num;
  int                   pp_max_cacheline_num;
  int                   pp_max_cacheline_pad;
  int                   pp_max_cacheline_shuffle;
  int                   is_rob_enabled;
  
  pp_max_cacheline_num = $urandom_range(pp_max_cacheline_num_max,pp_max_cacheline_num_min);
  pp_max_cacheline_pad = $urandom_range(pp_max_cacheline_pad_max,pp_max_cacheline_pad_min);
  pp_max_cacheline_shuffle = $urandom_range(pp_max_cacheline_shuffle_max,pp_max_cacheline_shuffle_min);

  batch_num = $urandom_range(hcw_enqueue_batch_max,hcw_enqueue_batch_min);

  //
  // BFM-level modifications
  //
  if (hcw_trans.reord == 0)
    hcw_trans.ordidx = hcw_trans.tbcnt;

  //---- 
  //-- determine enqattr
  //----    
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
  
  $cast(to_q, hcw_trans.clone());  
  to_q.qe_valid = 0;
  to_q.qe_orsp  = 0;
  to_q.qe_uhl   = 0;
  to_q.cq_pop   = 0;
  noop_qtype_sel= $urandom_range(0,3);
  case(noop_qtype_sel) 
     0: to_q.qtype    = QATM;
     1: to_q.qtype    = QUNO;
     2: to_q.qtype    = QORD;
     3: to_q.qtype    = QDIR;
  endcase
    
  //-- pass hcw_item to sb
  i_hqm_cfg.write_hcw_gen_port(hcw_trans);
    `uvm_info("PP_CQ_DEBUGTRFGENSEND",$psprintf("finish_hcw_pass_to_SB - %s PP %0d : v=%0d o=%0d u=%0d t=%0d qtype=%0s qid=0x%0x lockid=0x%0x tbcnt=0x%0x cmp_id=%0d is_ord=%0d", pp_cq_type.name(),pp_cq_num, hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.qtype.name(), hcw_trans.qid, hcw_trans.lockid, hcw_trans.tbcnt, hcw_trans.cmp_id, hcw_trans.is_ord),UVM_MEDIUM)
  
  if (uvm_report_enabled(UVM_MEDIUM,UVM_INFO,"hqm_pp_cq_base_seq")) begin
      hcw_trans.print();
  end 

  hcw_enqueue_batch_sem.get(1);

  //----------------------------------------------
  //-- hcw_enqueue_batch_cnt
  //-- hcw_trans.hcw_batch
  //----------------------------------------------
  if (last_hcw) begin
    hcw_trans.hcw_batch         = 1'b0;
    hcw_enqueue_batch_cnt       = -1;
  end else begin
    if (hcw_enqueue_batch_cnt < 0) begin
      hcw_enqueue_batch_cnt = $urandom_range(hcw_enqueue_batch_max,hcw_enqueue_batch_min);
    end 

    hcw_enqueue_batch_cnt--;
    is_noop_pad=0;

    if( ($urandom_range(hcw_enqueue_pad_prob_max, hcw_enqueue_pad_prob_min))  > ($urandom_range(99,0)) ) begin
       if( ($test$plusargs("HQM_ENQ_DIR_NOOP_PAD")  && hcw_trans.qe_valid && hcw_trans.qtype == QDIR) ||
           ($test$plusargs("HQM_ENQ_BATT_NOOP_PAD") && (hcw_trans.qe_valid==0 && hcw_trans.qe_orsp==0 && hcw_trans.qe_uhl==0 && hcw_trans.cq_pop==1))  || 
           ($test$plusargs("HQM_ENQ_NOOP_NOOP_PAD") && (hcw_trans.qe_valid==0 && hcw_trans.qe_orsp==0 && hcw_trans.qe_uhl==0 && hcw_trans.cq_pop==0))  || 
           ($test$plusargs("HQM_ENQ_RAND_NOOP_PAD"))   
         ) begin 
          is_noop_pad=1;
          noop_pad_cnt = hcw_enqueue_batch_cnt;
       end 
    end 

    `uvm_info("PP_CQ_DEBUGTRFGENSEND",$psprintf("finish_hcw_S1 - %s PP %0d : hcw_enqueue_batch_cnt=%0d is_noop_pad=%0d noop_pad_cnt=%0d hcw_enqueue_pad_prob_min=%0d/max=%0d; v=%0d o=%0d u=%0d t=%0d qtype=%0s qid=0x%0x lockid=0x%0x tbcnt=0x%0x", pp_cq_type.name(),pp_cq_num, hcw_enqueue_batch_cnt, is_noop_pad,noop_pad_cnt, hcw_enqueue_pad_prob_min, hcw_enqueue_pad_prob_max, hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.qtype.name(), hcw_trans.qid, hcw_trans.lockid, hcw_trans.tbcnt),UVM_MEDIUM)

     if(is_noop_pad==1) begin
        hcw_trans.hcw_batch         = 1'b0;
        hcw_enqueue_batch_cnt       = -1;
     end else begin
        if (hcw_enqueue_batch_cnt == 0) begin
           hcw_trans.hcw_batch         = 1'b0;
           hcw_enqueue_batch_cnt       = -1;
        end else begin
           hcw_trans.hcw_batch         = 1'b1;
        end 
     end 
  end //--if (last_hcw)

  //----------------------------------------------
  //-- hcw_q[]
  //-- cache_line_rndaddr
  //----------------------------------------------
  hcw_data = hcw_trans.byte_pack(0);
  
  hcw_q.push_back(hcw_data);

  //-- cache_line_rndaddr
  //-- hcw_enqueue_claddrctl : 1: incr; 2: fixed; else: rnd
  hcw_enqueue_claddrctl = $urandom_range(hcw_enqueue_claddrctl_min, hcw_enqueue_claddrctl_max);
  is_rob_enabled = i_hqm_cfg.get_cl_rob(((pp_cq_type == IS_LDB) ? 1 : 0), pp_cq_num);

  if($test$plusargs("HQM_ENQ_CACHELINE_INCR") || hcw_enqueue_claddrctl==1) begin
    if(is_rob_enabled) begin
       //--03242022/03252022 meeting: cacheline address: LOWer part and higher part
       if(pp_max_cacheline_num<=4) begin
         cache_line_rndaddr[3:2] = 0; 
         cache_line_rndaddr[1:0] = pp_cacheline_addr[1:0]; 
       end else if(pp_max_cacheline_num<=8) begin 
         cache_line_rndaddr[3]   = 0; 
         cache_line_rndaddr[2:0] = pp_cacheline_addr[2:0]; 
       end else if(pp_max_cacheline_num<=16) begin
         cache_line_rndaddr[3:0] = pp_cacheline_addr[3:0]; 
       end else begin
         cache_line_rndaddr[3:0] = pp_cacheline_addr; 
       end 
    end else begin

       //--03222022 meeting: talked about rob_v=0 cases in HQMV30
       //-- when rob_v=0, based on application, the cacheline address is fixed when it's enq; when it's bat_t only in a cache-line, we can run with rand cacheline addressed
       //-- TB solution, when last_hcw=0: cacheline has enq, so use fixed address;
       //--              when last_hcw=1: current solution is to have cacheline address incr (if running with ORD or ATM_ORD, it should be a fixed cacheline addr +HQM_ENQ_CACHELINE_ROBV0)
       if(last_hcw==0 || $test$plusargs("HQM_ENQ_CACHELINE_ROBV0")) begin
          cache_line_rndaddr = pp_cq_num;
          //if (pp_cq_type == IS_DIR) 
          //   cache_line_rndaddr[3]= 0;
          //else 
          //   cache_line_rndaddr[3]= 1;
       end else begin
          cache_line_rndaddr[3:0] = pp_cacheline_addr;
       end 
    end 
  end else begin 
     if(!$test$plusargs("HQM_ENQ_SKIP_CACHELINE_RND")) begin
       //--normal cases
       cache_line_rndaddr = $urandom_range(4'h0,4'hf);
     end else begin 
        //--trying to separate pp_cq_num by cache_line_rndaddr (SoC test support)
        cache_line_rndaddr = pp_cq_num;
        if (pp_cq_type == IS_DIR) 
           cache_line_rndaddr[3]= 0;
        else 
           cache_line_rndaddr[3]= 1;
     end 
  end 
 
  if(is_noop_pad) begin
     for(int k=0; k<noop_pad_cnt; k++) begin
           hcw_data = to_q.byte_pack(0);
           hcw_q.push_back(hcw_data);
           i_hqm_cfg.write_hcw_gen_port(to_q);
          `uvm_info("PP_CQ_DEBUGTRFGENSEND",$psprintf("finish_hcw_S1_Padding - %s PP %0d : k=%0d noop_pad_cnt=%0d hcw_q.size=%0d to_q.qtype=%0s hcw_data=0x%0x", pp_cq_type.name(),pp_cq_num, k, noop_pad_cnt, hcw_q.size(), to_q.qtype.name(),hcw_data),UVM_MEDIUM)
     end 
  end //if(is_noop_pad

  //----------------------------------------------
  //-- when it's last_hcw=1, if hcw_enqueue_cl_pad=1 => padding to make it a cache-line
  //-- +HQM_ENQ_CACHELINE_PAD : padding to make one cache-line regardless last_hcw=0 or 1
  //----------------------------------------------
  if($test$plusargs("HQM_ENQ_CACHELINE_PAD") || (hcw_enqueue_cl_pad && last_hcw)) begin
     remain_num = batch_num - hcw_q.size();

    `uvm_info("PP_CQ_DEBUGTRFGENSEND",$psprintf("finish_hcw_S1_Padding_Start - %s PP %0d : hcw_q.size=%0d batch_num=%0d remain_num=%0d last_hcw=%0d", pp_cq_type.name(),pp_cq_num, hcw_q.size(), batch_num, remain_num, last_hcw),UVM_MEDIUM)
     for(int k=0; k<remain_num; k++) begin
           hcw_data = to_q.byte_pack(0);
           hcw_q.push_back(hcw_data);
           i_hqm_cfg.write_hcw_gen_port(to_q);
          `uvm_info("PP_CQ_DEBUGTRFGENSEND",$psprintf("finish_hcw_S1_Padding - %s PP %0d : k=%0d hcw_q.size=%0d to_q.qtype=%0s hcw_data=0x%0x", pp_cq_type.name(),pp_cq_num, k, hcw_q.size(), to_q.qtype.name(),hcw_data),UVM_MEDIUM)
     end 
    `uvm_info("PP_CQ_DEBUGTRFGENSEND",$psprintf("finish_hcw_S1_Padding_End - %s PP %0d : hcw_q.size=%0d batch_num=%0d remain_num=%0d last_hcw=%0d", pp_cq_type.name(),pp_cq_num, hcw_q.size(), batch_num, remain_num, last_hcw),UVM_MEDIUM)
  end //if(hcw_enqueue_cl_pad

  //----------------------------------------------
  //-- when hcw_trans.hcw_batch == 0, send out all hcw_q
  //----------------------------------------------
  if (hcw_trans.hcw_batch == 0) begin
      num_hcw = hcw_q.size();
    
      if (hcw_trans.is_vf) begin
         `uvm_error("PP_CQ_DEBUGTRFGENSEND",$psprintf("finish_hcw_S2 - %s PP %0d : hcw_trans.is_vf=1 is not supported!!! ", pp_cq_type.name(),pp_cq_num))

      end else begin
          slu_ral_data_t    ral_data;
      
          pp_addr = 64'h0000_0000_0200_0000;
      
          ral_data = func_bar_u.get_mirrored_value();
      
          pp_addr[63:32] = ral_data[31:0];
      
          ral_data = func_bar_l.get_mirrored_value();
      
          pp_addr[31:26] = ral_data[31:26];
      end 
    
      pp_addr[19:12] = hcw_trans.ppid;
      pp_addr[20]    = hcw_trans.is_ldb;
      pp_addr[21]    = hcw_trans.is_nm_pf;
      pp_addr[9:6]   = cache_line_rndaddr; //--support 0-15 cache lines aperture
    
      //-- hcw_enq_seq
      `uvm_create(hcw_enq_seq)
    
     `uvm_info("PP_CQ_DEBUGTRFGENSEND",$psprintf("finish_hcw_S HCW to be generated - %s PP %0d num_hcw=%0d : v=%0d o=%0d u=%0d t=%0d qtype=%0s qid=0x%0x lockid=0x%0x tbcnt=0x%0x; pp_addr[63:0]=0x%0x pp_addr[31:26]=0x%0x, pp_addr[22:0]=0x%0x, pp_addr[9:6]=cache_line_rndaddr=0x%0x; is_nm_pf=%0d, last_hcw=%0d;; ingress_drop=%0d;; pp_max_cacheline_num=%0d pp_max_cacheline_pad=%0d pp_max_cacheline_shuffle=%0d", pp_cq_type.name(),pp_cq_num,num_hcw, hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.qtype.name(), hcw_trans.qid, hcw_trans.lockid, hcw_trans.tbcnt, pp_addr[63:0], pp_addr[31:26], pp_addr[22:0], pp_addr[9:6], pp_addr[21], last_hcw, hcw_trans.ingress_drop, pp_max_cacheline_num, pp_max_cacheline_pad, pp_max_cacheline_shuffle),UVM_MEDIUM)
    
      `uvm_rand_send_with(hcw_enq_seq, { 
                                           hqm_max_cacheline_num    == pp_max_cacheline_num;
                                           hqm_txn_maxcacheline_pad == pp_max_cacheline_pad;
                                           hqm_cacheline_shuffle    == pp_max_cacheline_shuffle;

                                           is_last_hcw == last_hcw;//(hcw_trans.qe_valid==0 && last_hcw); //-- last_hcw=1 is a sticky indicator once it's reached to all ENQ done; after that, all returns (bat_t,comp_t, comp) have is_last_hcw=1 all the way to seq completion.  
                                           is_ldb == (pp_cq_type == IS_LDB) ? 1 : 0;
                                           pp_id  == pp_cq_num;
                                           pp_enq_addr == pp_addr;
                                           sai == hcw_trans.sai;
                                           hcw_enq_q.size == num_hcw;
                                           foreach (hcw_enq_q[i]) hcw_enq_q[i] == hcw_q[i];
                                       })
    
      hcw_q.delete();
      pp_cacheline_addr++;
  end else begin
     `uvm_info("PP_CQ_DEBUG",$psprintf("finish_hcw HCW batch=1 - %s PP %0d num_hcw=%0d : v=%0d o=%0d u=%0d t=%0d qtype=%0s qid=0x%0x lockid=0x%0x tbcnt=0x%0x with hcw_enqueue_batch_cnt=%0d last_hcw=%0d ingress_drop=%0d", pp_cq_type.name(),pp_cq_num,num_hcw, hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.qtype.name(), hcw_trans.qid, hcw_trans.lockid, hcw_trans.tbcnt, hcw_enqueue_batch_cnt, last_hcw, hcw_trans.ingress_drop),UVM_MEDIUM)
  end 

  hcw_enqueue_batch_sem.put(1);
endtask

task hqm_pp_cq_base_seq::corrupt_hcw(ref hcw_transaction hcw_trans,
                                 input illegal_hcw_type_t illegal_hcw_type);
 `uvm_info("PP_CQ_DEBUG",$psprintf("corrupt_hcw ILLEGAL HCW to be generated - %s PP %0d illegal_hcw_type=%0s",pp_cq_type.name(),pp_cq_num,illegal_hcw_type.name()),UVM_MEDIUM)

  case (illegal_hcw_type)
    ILLEGAL_HCW_CMD: begin
      bit [3:0] bad_cmd;

      //--HQMV25--// std::randomize (bad_cmd) with { bad_cmd inside { 6, 7, 14, 15 }; };
      std::randomize (bad_cmd) with { bad_cmd inside { 14, 15 }; };  //--HQMV30_AO: A_COMP=6/A_COMP_T=7

      hcw_trans.qe_valid      = bad_cmd[3];
      hcw_trans.qe_orsp       = bad_cmd[2];
      hcw_trans.qe_uhl        = bad_cmd[1];
      hcw_trans.cq_pop        = bad_cmd[0];
    end 
    ALL_0: begin
      hcw_trans.rsvd0                 = '0;
      hcw_trans.dsi_error             = '0;
      hcw_trans.cmp_id                = '0;
      hcw_trans.no_inflcnt_dec        = '0;
      hcw_trans.dbg                   = '0;
      hcw_trans.meas                  = '0;
      hcw_trans.lockid                = '0;
      hcw_trans.msgtype               = '0;
      hcw_trans.qpri                  = '0;
      hcw_trans.qtype                 = QATM;
      hcw_trans.qid                   = '0;
      hcw_trans.idsi                  = '0;
      hcw_trans.iptr                  = '0;
    end 
    ALL_1: begin
      hcw_trans.rsvd0                 = '1;
      hcw_trans.dsi_error             = '1;
      hcw_trans.cmp_id                = '1;
      hcw_trans.no_inflcnt_dec        = '1;
      hcw_trans.dbg                   = '1;
      hcw_trans.meas                  = '1;
      hcw_trans.lockid                = '1;
      hcw_trans.msgtype               = '1;
      hcw_trans.qpri                  = '1;
      hcw_trans.qtype                 = QDIR;
      hcw_trans.qid                   = '1;
      hcw_trans.idsi                  = '1;
      hcw_trans.iptr                  = '1;
    end 
    ILLEGAL_PP_NUM: begin
      hcw_trans.ppid          = 63;
    end 
    ILLEGAL_PP_TYPE: begin
      hcw_trans.is_ldb        ^= 1'b1;
    end 
    ILLEGAL_QID_NUM: begin
      hcw_trans.qid           = hcw_trans.qid ^ 8'h03;
    end 
    ILLEGAL_QID_TYPE: begin
      $cast(hcw_trans.qtype,hcw_trans.qtype ^ 2'h3);
    end 
    ILLEGAL_DEV_VF_NUM: begin
      hcw_trans.vf_num        += 1;
    end 
    QID_GRT_127: begin
        if (hcw_trans.qtype == 3) begin // -- DIR traffic
            hcw_trans.qid = $urandom_range(255, hqm_pkg::NUM_DIR_QID);
        end else begin
            hcw_trans.qid = $urandom_range(255, hqm_pkg::NUM_LDB_QID);
        end 
    end 
    VAS_WRITE_PERMISSION: begin
      hcw_trans.qid           = hcw_trans.qid + 8'h20;
    end 
    ILLEGAL_DIRPP_RELS: begin
      hcw_trans.is_ldb        = 0;
      hcw_trans.qe_valid      = 0;
      hcw_trans.qe_orsp       = 1;
      hcw_trans.qe_uhl        = 0;
      hcw_trans.cq_pop        = 0;
    end 

  endcase
endtask : corrupt_hcw


//--------------------------------
//-- AY_HQMV30_ATS
//--------------------------------
task hqm_pp_cq_base_seq::HqmAtsInvalid_task();
    int inv_ctrl;

    if(pp_cq_type == IS_LDB) begin 
       inv_ctrl=i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_ats_inv_ctrl;  
    end else begin
       inv_ctrl=i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_ats_inv_ctrl;  
    end 

   `uvm_info("PP_CQ_DEBUG_BASIC",$psprintf("HqmAtsInvalid_task:: Start HqmAtsInvalid_task - %s PP %0d inv_ctrl=%0d i_hqm_cfg.hqm_alarm_issued=%0d hqm_alarm_count=%0d (wait to issue HqmAtsInvalidRequest_task", pp_cq_type.name(), pp_cq_num, inv_ctrl, i_hqm_cfg.hqm_alarm_issued, i_hqm_cfg.hqm_alarm_count),UVM_MEDIUM)

    //while(inv_ctrl==1 || inv_ctrl==2) begin
    while(i_hqm_cfg.hqm_alarm_issued==0) begin

       sys_clk_delay(100);

      if(pp_cq_type == IS_LDB) begin 
         inv_ctrl=i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_ats_inv_ctrl;  
      end else begin
         inv_ctrl=i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_ats_inv_ctrl;  
      end 
    end 

    sys_clk_delay(300);
   `uvm_info("PP_CQ_DEBUG_BASIC",$psprintf("HqmAtsInvalid_task:: call HqmAtsInvalidRequest_task - %s PP %0d inv_ctrl=%0d i_hqm_cfg.hqm_alarm_issued=%0d hqm_alarm_count=%0d ", pp_cq_type.name(), pp_cq_num, inv_ctrl, i_hqm_cfg.hqm_alarm_issued, i_hqm_cfg.hqm_alarm_count),UVM_MEDIUM)
    HqmAtsInvalidRequest_task();
   `uvm_info("PP_CQ_DEBUG_BASIC",$psprintf("HqmAtsInvalid_task:: HqmAtsInvalidRequest_task done - %s PP %0d inv_ctrl=%0d i_hqm_cfg.hqm_alarm_issued=%0d hqm_alarm_count=%0d ", pp_cq_type.name(), pp_cq_num, inv_ctrl, i_hqm_cfg.hqm_alarm_issued, i_hqm_cfg.hqm_alarm_count),UVM_MEDIUM)
 
endtask:HqmAtsInvalid_task


task hqm_pp_cq_base_seq::HqmAtsInvalidRequest_task();
    bit [15:0] hqmbdf_val;
    bit        pasid_ena;
    bit [19:0] pasid_val;
    bit [63:0] logic_addr;
    HqmAtsPkg::RangeSize_t  pagesize;
    HqmPasid_t              page_pasidtlp;
    bit        global_inv, enable_dpe_err, enable_ep_err;
    bit [4:0]  itag;
    int        has_delete_iommu_entry, delete_iommu_entry;
    bit timeout_detector = 0;
    bit rc;

    global_inv=0; 
    enable_dpe_err=0;
    enable_ep_err=0;
   
    if(pp_cq_type == IS_LDB) begin
       hqmbdf_val = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_bdf;
       pasid_ena  = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].pasid[22];
       pasid_val  = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].pasid[19:0];
       page_pasidtlp.pasid_en            = pasid_ena;
       page_pasidtlp.priv_mode_requested = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].pasid[21];
       page_pasidtlp.exe_requested       = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].pasid[20];
       page_pasidtlp.pasid               = pasid_val;
       logic_addr = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_gpa;
       delete_iommu_entry = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_ats_entry_delete;
       pagesize   = HqmAtsPkg::RANGE_4K;
    end else begin
       hqmbdf_val = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_bdf;
       pasid_ena  = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].pasid[22];
       pasid_val  = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].pasid[19:0];
       page_pasidtlp.pasid_en            = pasid_ena;
       page_pasidtlp.priv_mode_requested = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].pasid[21];
       page_pasidtlp.exe_requested       = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].pasid[20];
       page_pasidtlp.pasid               = pasid_val;
       logic_addr = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_gpa;
       delete_iommu_entry = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_ats_entry_delete;
       pagesize   = HqmAtsPkg::RANGE_4K;
    end 

    if(delete_iommu_entry || $test$plusargs("HQMV30_ATSINV_DELETE_ENTRY")) has_delete_iommu_entry=1;
    else                                                                   has_delete_iommu_entry=0; 

   `uvm_info("PP_CQ_DEBUG_BASIC",$psprintf("HqmAtsInvalidRequest_task:: Invalidation Request be generated - %s PP %0d virtual_addr=0x%0x pasid_ena=%0d pasid=0x%0x pagesize=%0s itag=%0d global_inv=%0d has_delete_iommu_entry=%0d", pp_cq_type.name(), pp_cq_num, logic_addr, pasid_ena, pasid_val, pagesize.name(), itag, global_inv, has_delete_iommu_entry),UVM_MEDIUM)

   //---------------------------
    if(has_delete_iommu_entry==1) begin
       rc = i_hqm_cfg.iommu_api.delete_address_translation(.bdf(hqmbdf_val),
                                                      .pasidtlp(page_pasidtlp),
                                                      .logical_address(logic_addr));
      `uvm_info("PP_CQ_DEBUG_BASIC",$psprintf("HqmAtsInvalidRequest_task:: delete_address_translation Sent  - %s PP %0d  itag=0x%0x; virtual_addr=0x%0x pasid_ena=%0d pasid=0x%0x pagesize=%0s rc=%0d", pp_cq_type.name(), pp_cq_num, itag, logic_addr, pasid_ena, pasid_val, pagesize.name(), rc),UVM_MEDIUM)
    end //--


   //---------------------------
    i_hqm_cfg.iommu_api.send_ireq( 
                             .ireq_itag             ( itag ),   // task returns tag of INV REQ that is sent
                             .ireq_requester_id     (hqmbdf_val ),
                             .ireq_destination_id   (0 ),
                             .ireq_pasid_valid      (pasid_ena),
                             .ireq_pasid            (pasid_val),
                             .ireq_la_address       (logic_addr ),
                             .ireq_range            (pagesize),
                             .ireq_global_invalidate(global_inv));
   `uvm_info("PP_CQ_DEBUG_BASIC",$psprintf("HqmAtsInvalidRequest_task:: Invalidation Request Sent  - %s PP %0d returned itag=0x%0x; virtual_addr=0x%0x pasid_ena=%0d pasid=0x%0x pagesize=%0s", pp_cq_type.name(), pp_cq_num, itag, logic_addr, pasid_ena, pasid_val, pagesize.name()),UVM_MEDIUM)

   //---------------------------
      if($test$plusargs("HQMV30_ATS_INV_RESP_WAIT")) begin 
            fork
                i_hqm_cfg.iommu_api.wait_irsp( .itag ( itag ) );
                begin
                    #10us;
                    timeout_detector = 1;
                end 
            join_any
            disable fork;
            if (timeout_detector) begin // timeout did trigger
                `uvm_error("PP_CQ_DEBUG_BASIC",$psprintf("HqmAtsInvalidRequest_task:: Invalidation message time out - %s PP %0d virtual_addr=0x%0x pasid_ena=%0d pasid=0x%0x pagesize=%0s", pp_cq_type.name(), pp_cq_num, logic_addr, pasid_ena, pasid_val, pagesize.name()))
            end else begin
                `uvm_info("PP_CQ_DEBUG_BASIC",$psprintf("HqmAtsInvalidRequest_task:: Invalidation message successful - %s PP %0d virtual_addr=0x%0x pasid_ena=%0d pasid=0x%0x pagesize=%0s", pp_cq_type.name(), pp_cq_num, logic_addr, pasid_ena, pasid_val, pagesize.name()),UVM_MEDIUM)
            end 
      end //if($test$plusargs("HQMV30_ATS_INV_RESP_WAIT"))  


   //---------------------------
      sys_clk_delay(100);

      if(pp_cq_type == IS_LDB) begin 
         i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_ats_inv_ctrl = 4;  
      end else begin
         i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_ats_inv_ctrl = 4;  
      end 
   `uvm_info("PP_CQ_DEBUG_BASIC",$psprintf("HqmAtsInvalidRequest_task:: Invalidation Request Sent  - %s PP %0d - set cq_ats_inv_ctrl=4 => VASRESET task; itag=0x%0x virtual_addr=0x%0x pasid_ena=%0d pasid=0x%0x pagesize=%0s", pp_cq_type.name(), pp_cq_num, itag, logic_addr, pasid_ena, pasid_val, pagesize.name()),UVM_MEDIUM)
endtask: HqmAtsInvalidRequest_task


`endif
