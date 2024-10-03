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
// File   : hqm_pp_cq_hqmproc_seq.sv
//
// Description :
//
//-- file format: qtypecode, ppid, reord, frgnum, is_ldb_credit, is_carry_uhl, is_carry_tkn, is_multi_tkn
// -----------------------------------------------------------------------------
`ifndef HCW_PP_CQ_HQMPROC_SEQ__SV
`define HCW_PP_CQ_HQMPROC_SEQ__SV

import hcw_transaction_pkg::*;
import lvm_common_pkg::*;
import hqm_cfg_pkg::*;

class hqm_pp_cq_hqmproc_seq extends hqm_pp_cq_base_seq;

  `uvm_object_utils(hqm_pp_cq_hqmproc_seq) 

  `uvm_declare_p_sequencer(slu_sequencer)

  rand  int                     hqmproc_trf_delay_min;

  //-- trf pattern control
  rand  int                     hqmproc_trfctrl_sel_mode; //--4: comp higher priority to send ;  1 and 2: send renq/renq_t as possible; 3: rand; 5: renq always; 6: renq_t always

  //-- trf flow control (support force_seq_stop)
  rand  int                     hqmproc_trfflow_ctrl_mode;
  
  //-- watchdog_mon control
  rand  int                     hqmproc_watchdogctrl_sel_mode;

     
  //-- cq_buffer access control
  rand  int                     hqmproc_cqbufctrl_sel_mode;
  rand  int                     hqmproc_cqbufinit_sel_mode;


  rand  int                     hqmproc_dta_ctrl;
  rand  int                     hqmproc_dta_srcpp;
  rand  int                     hqmproc_dta_wpp_idlenum;
        int                     hqmproc_dta_wpp_idlecnt;
        int                     hqmproc_dta_num_hcw;

  //-- return mode control
  rand  int                     hqmproc_rtntokctrl_sel_mode; //1: hold number of tokens; 2: hold tok and rlease tok repeatly; 3:: support interactive cial.cq_depth 4:: reach to hqmproc_rtntokctrl_holdnum, then change to mode=0; 5: reach to hqmproc_rtntokctrl_holdnum, return bat_t, loop;
  rand  int                     hqmproc_rtntokctrl_holdnum;
  rand  int                     hqmproc_rtntokctrl_threshold;
  rand  int                     hqmproc_rtntokctrl_rtnnum;

  rand  int                     hqmproc_rtncmpctrl_sel_mode;
  rand  int                     hqmproc_rtncmpctrl_holdnum;
        int                     hqmproc_rtncmpctrl_holdnum_save;
  rand  int                     hqmproc_rtncmpctrl_rtnnum;
  rand  int                     hqmproc_rtncmpctrl_threshold;

  rand  int                     hqmproc_rtn_a_cmpctrl_sel_mode; //-- when hqmproc_rtn_a_cmpctrl_state>0, use a_comp return controls
  rand  int                     hqmproc_rtn_a_cmpctrl_holdnum;
  rand  int                     hqmproc_rtn_a_cmpctrl_rtnnum;

  rand  int                     hqmproc_rtntokctrl_holdnum_waitnum;
        int                     hqmproc_rtntokctrl_holdnum_waitcnt;
        int                     hqmproc_rtntokctrl_holdnum_check;
  rand  int                     hqmproc_rtntokctrl_checknum;
  rand  int                     hqmproc_rtntokctrl_keepnum_min;
  rand  int                     hqmproc_rtntokctrl_keepnum_max;
        int                     hqmproc_rtntokctrl_keepnum; 
  rand  int                     hqmproc_rtntokctrl_rtnnum_min;
  rand  int                     hqmproc_rtntokctrl_rtnnum_max;
        int                     hqmproc_rtntokctrl_rtnnum_val; 

  rand  int                     hqmproc_rtncmpctrl_holdnum_waitnum;
        int                     hqmproc_rtncmpctrl_holdnum_waitcnt;
        int                     hqmproc_rtncmpctrl_holdnum_check;
  rand  int                     hqmproc_rtncmpctrl_checknum;

  rand  int                     hqmproc_rtn_a_cmpctrl_holdnum_waitnum;
        int                     hqmproc_rtn_a_cmpctrl_holdnum_waitcnt;
        int                     hqmproc_rtn_a_cmpctrl_holdnum_check;
  rand  int                     hqmproc_rtn_a_cmpctrl_checknum;


  //-- enqueue trf control (go-nogo)
  rand  int                     hqmproc_enqctrl_sel_mode; //-- 3: streaming-style trf (scenario2) 
  rand  int                     hqmproc_enqctrl_newnum;
  rand  int                     hqmproc_enqctrl_fragnum;
  rand  int                     hqmproc_enqctrl_enqnum;
  rand  int                     hqmproc_enqctrl_enqnum_1;
  rand  int                     hqmproc_enqctrl_hold_waitnum;
        int                     hqmproc_enqctrl_hold_waitcnt;
        int                     hqmproc_enqctrl_st;  //0: go; 1: hold; 2: wait idle (support unit idle tests)
        int                     hqmproc_enqrtnctrl_st;    //-- 0: enq; 1: rtn;
  
  rand  int                     hqmproc_cq_dep_chk_adj; //-- when hqmproc_enqctrl_sel_mode=4 (control ENQ so not to see cial.occ) , hqmproc_cq_dep_chk_adj is the adj   

  //--enq HCW controls
  rand  int                     hqmproc_qid_sel_mode;
  rand  int                     hqmproc_qid_gen_prob;
  rand  int                     hqmproc_qid_min; 
  rand  int                     hqmproc_qid_max; 
  
  rand  int                     hqmproc_qtype_sel_mode;   
  rand  int                     hqmproc_qtype_dir; 
  rand  int                     hqmproc_qtype_ldb;   
  rand  int                     hqmproc_qtype_ldb_min;  
  rand  int                     hqmproc_qtype_ldb_max;
     
  rand  int                     hqmproc_qpri_sel_mode;
  rand  int                     hqmproc_qpri_min; 
  rand  int                     hqmproc_qpri_max;   

  rand  int                     hqmproc_lockid_sel_mode;     

  //--FRAG HCW controls 
  rand  int                     hqmproc_frag_ctrl;
  rand  int                     hqmproc_frag_replay_ctrl;
  rand  int                     hqmproc_frag_num_min;
  rand  int                     hqmproc_frag_num_max;
        int                     pend_hcw_trans_idx;
        int                     pend_hcw_trans_comb_idx;


  rand  int                     hqmproc_frag_t_ctrl;

  //--Non-FRAG for general LDB/DIR 
  rand  int                     hqmproc_strenq_num_min;
  rand  int                     hqmproc_strenq_num_max;
        int                     strenq_num;
        int                     strenq_cnt;
        bit                     strenq_last;

  //-- Release flow controls
  rand  int                     hqmproc_nodec_fragnum;
  rand  hcw_qtype               hqmproc_rel_qtype;
  rand  int                     hqmproc_rel_qid;
        int                     hqmproc_rel_hcw_count[2048];
 
  rand  int                     hqmproc_stream_ctrl; //--1: support streamming scenario 1 ; 2: support streamming scenario 1 with strenq_num flavor
  rand  int                     hqmproc_rels_ctrl;   //--support RENQ_TND + RELS in streaming style seq
        int                     hqmproc_stream_flowctrl;   //--streamming trfflowctrl :  0: NEW; 1: (LDB RENQ/RENQ_T ; DIR NEW_T); 2: (LDB COMP/COMP_T; DIR BAT_T)


  //-- when hqmproc_frag_new_ctrl>0: qtype!=QORD, issue FRAG/FRAG_T instead of NEW/NEW_T
  rand  int                     hqmproc_frag_new_ctrl; 
  rand  int                     hqmproc_frag_new_prob; 

  //--renq HCW controls 
  int                           renq_qid;
  hcw_qtype                     renq_qtype;
  bit [2:0]                     renq_qpri;
  bit [15:0]                    renq_lockid;

  rand  int                     hqmproc_renq_qid_sel_mode;
  rand  int                     hqmproc_renq_qid_min; 
  rand  int                     hqmproc_renq_qid_max; 
  
  rand  int                     hqmproc_renq_qtype_sel_mode;   
  rand  int                     hqmproc_renq_qtype_dir; 
  rand  int                     hqmproc_renq_qtype_ldb;   
  rand  int                     hqmproc_renq_qtype_ldb_min;  
  rand  int                     hqmproc_renq_qtype_ldb_max;
     
  rand  int                     hqmproc_renq_qpri_sel_mode;
  rand  int                     hqmproc_renq_qpri_min; 
  rand  int                     hqmproc_renq_qpri_max;   

  rand  int                     hqmproc_renq_lockid_sel_mode;   

  //-- contorls and counters  
  int                           hqmproc_rtntokctrl_loopnum;
  int                           hqmproc_rtntokctrl_loopcnt;
  int                           hqmproc_rtntokctrl_cnt;
  int                           hqmproc_rtncmpctrl_loopnum;
  int                           hqmproc_rtncmpctrl_loopcnt;
  int                           hqmproc_rtncmpctrl_cnt;
  int                           hqmproc_rtn_a_cmpctrl_loopnum;
  int                           hqmproc_rtn_a_cmpctrl_loopcnt;
  int                           hqmproc_rtn_a_cmpctrl_cnt;

  int                           total_genenq_count;
  int                           total_atm_genenq_count;
  int                           total_uno_genenq_count;

  //-- support wu direct tests
  int                           curr_sch_num;
  int                           has_ldb_sch_cnt_check;


  //-- support ingress error inj (excess toke, excess completions)
  rand int                      hqmproc_ingerrinj_ingress_drop;

  rand int                      hqmproc_ingerrinj_excess_tok_rand;
  rand int                      hqmproc_ingerrinj_excess_tok_ctrl;
  rand int                      hqmproc_ingerrinj_excess_tok_rate;
  rand int                      hqmproc_ingerrinj_excess_tok_num;

  rand int                      hqmproc_ingerrinj_excess_cmp_rand;
  rand int                      hqmproc_ingerrinj_excess_cmp_ctrl;
  rand int                      hqmproc_ingerrinj_excess_cmp_rate;
  rand int                      hqmproc_ingerrinj_excess_cmp_num;

  rand int                      hqmproc_ingerrinj_excess_a_cmp_rand;
  rand int                      hqmproc_ingerrinj_excess_a_cmp_ctrl;
  rand int                      hqmproc_ingerrinj_excess_a_cmp_rate;
  rand int                      hqmproc_ingerrinj_excess_a_cmp_num;

  rand int                      hqmproc_ingerrinj_cmpid_rand;
  rand int                      hqmproc_ingerrinj_cmpid_ctrl;
  rand int                      hqmproc_ingerrinj_cmpid_rate;
  rand int                      hqmproc_ingerrinj_cmpid_num;

  rand int                      hqmproc_ingerrinj_cmpdirpp_rand;
  rand int                      hqmproc_ingerrinj_cmpdirpp_ctrl;
  rand int                      hqmproc_ingerrinj_cmpdirpp_rate;

  rand int                      hqmproc_ingerrinj_qidill_rand;
  rand int                      hqmproc_ingerrinj_qidill_ctrl;
  rand int                      hqmproc_ingerrinj_qidill_rate;
  rand int                      hqmproc_ingerrinj_qidill_min;
  rand int                      hqmproc_ingerrinj_qidill_max;

  rand int                      hqmproc_ingerrinj_ppill_rand;
  rand int                      hqmproc_ingerrinj_ppill_ctrl;
  rand int                      hqmproc_ingerrinj_ppill_rate;
  rand int                      hqmproc_ingerrinj_ppill_min;
  rand int                      hqmproc_ingerrinj_ppill_max;

  //-- support ingress error inj (ooc case) (cover NEW/NEW_T/FRAG/FRAG_T/RENQ/RENQ_T)
  rand int                      hqmproc_ingerrinj_ooc_rand;
  rand int                      hqmproc_ingerrinj_ooc_ctrl;
  rand int                      hqmproc_ingerrinj_ooc_rate;

  //-- support meas/idsi ts tests
  rand int                      hqmproc_meas_enable;
  rand int                      hqmproc_meas_rand;
  rand int                      hqmproc_idsi_ctrl;

  //-- trfgen sequence activity watchdog
  int                           hqmproc_trfgen_watchdog_cnt;
  rand int                      hqmproc_trfgen_watchdog_ena;
  rand int                      hqmproc_trfgen_watchdog_num;
  int                           hqmproc_trfgen_stop; //-- when hqmproc_trfgen_watchdog_cnt > hqmproc_trfgen_watchdog_num  

  //-- watchdog_enqtrf seq control trying to do force_seq_stop
  rand  int                     hqmproc_trfidle_enable;
  rand int                      hqmproc_trfidle_num;

  //-- control passing from hqm_cfg
  int        has_trfenq_enable; //0: disable enq; 1: regular enq based on other control; 2: in vasreset to send token/completions; 3: vasreset done, back to normal
  int        has_tokrtn_enable;
  int        has_cmprtn_enable;
  int        has_acmprtn_enable;


  //-- token/rearm cq_intr services response wait 
  rand int                      hqmproc_cq_intr_resp_waitnum_min; 
  rand int                      hqmproc_cq_intr_resp_waitnum_max; 
       int                      hqmproc_cq_intr_resp_waitnum; 

  //-- token/rearm cq_intr services controls 
  rand  int                     hqmproc_cq_intr_thres_num; //--num in ldb_pp_cq_status[pp_cq].cq_int.num() before serving with token return and rearm followed by


  rand  bit [7:0]               hqmproc_cq_rearm_ctrl;     //-- bit0:  0: when cq_intr_service_state=1 or 2, next to rand select rearm (cq_intr_service_state=>4); 1: when cq_intr received, issue rearm asap by setting (cq_intr_service_state=>3)
                                                           //-- bit1:  0: when cq_intr_service_state=0, next toreturn any number of tokens, then issue rearm (cq_intr_service_state=>1);   1: return all tokens and then issue rearm (cq_intr_service_state=>2)
                                                           //-- bit2:  0: when cq_intr_service_state=2, next to return token with enq is allowed; 1: when cq_intr_service_state=2, next is to return tokens not enq
                                                           //-- bit4:  0: no-cq_intr_timer considered in the loop; 1: expect to see cq_intr_occ loop and then cq_intr_timer loop (cq_intr_occ_tim_state)
                                                           //-- bit5:  0: normal; 1: control ENQ, send cq_intr_enq_num (=hqmproc_rtntokctrl_holdnum ) when cq_intr_service_state=0
                                                           //-- bit6:  0: normal; 1: once get cq_intr (expected to get cq.timer intr), wait for cwdt
                                                           //-- bit7:  1: rearm routine running by default

  int cq_intr_received_num;

  rand int                     hqmproc_cq_cwdt_ctrl;       //-- 1: after cq.intr received, wait cwdt alarm before return token and rearm; 0: regular
  
  bit [31:0] ims_poll_data;

  //-- cq_intr_service_state;
  //--0: not function;;  
  //--1: received cq.intr and there are tokens to return, return token with enq/renq or comp_t, bat_t; => 3 or 4; (after return any number of tokens, issue rearm)
  //--2: received cq.intr and there are tokens to return, only when tokens are all returned, next cmd should be COMP_T or BAT_T to return all tokens => 3 or 4;  (only when all tokens are returned, issue rearm)
  //--3: rearm required asap, highest priority;; 
  //--4: rearm rand;; 
  //-- after issue ARM comd, set back to 0
  int cq_intr_service_state;


  //-- when cq_intr_service_state=2 (return all tokens, either by bat_t/comp_t or by multiple new_t/renq_t) when control of  hqmproc_cq_rearm_ctrl[2]=0
  //-- control the number of token returned before rearm
  int cq_intr_rtntok_num; 

  //-- when 1: showes cq_intr_service_state=2 state there are enq_t/renq_t, so if it's going to do bat_t/comp_t, return one token only 
  int has_enq_rtn_mixed;                                   

  //-- when cq_intr_service_state=0, send  cq_intr_enq_num ENQ HCWs, 
  int cq_intr_enq_num; 

  int cq_intr_occ_tim_state; //-- 0: cq_intr_occ loop; 1: cq_intr_timer loop

  //-- when cq_irq_mask is on, wait 
  rand int                      hqmproc_cqirq_mask_ena; 
  rand int                      hqmproc_cqirq_mask_waitnum_min; 
  rand int                      hqmproc_cqirq_mask_waitnum_max; 
       int                      hqmproc_cqirq_mask_waitnum; 
       int                      hqmproc_cqirq_mask_waitcnt; 

  //-- cq_intr_service_cqirq_rearm_hold when 1: rearm is on-hold
  int   cq_intr_service_cqirq_rearm_hold; 

  //--  cqirq_mask_issue_state 
  //--  1: rearm , 
  //--  2: check intr; once get intr, rearm; clear to 0
  int   cqirq_mask_issue_state;

  //-- it's about to send enq, but it's running out of credit at this moment
  int   enq_out_of_credit;

  //-- ord replay/seqnum support when hqmproc_enqctrl_sel_mode=10 (runs FRAG only)
  int   is_adj_renq_on; 

  int   dta_comp_return_count;

  bit   dis_random_sai   = $test$plusargs("HQM_DIS_RANDOM_SAI");

  //----------------------- HQMV30 AO
  //int cq_comp_service_state; //--0: ready to send A_COMP; 1: wait for COMP sent out, hold on A_COMP
  int saved_is_ordered;
 
  //--A_COMP+COMP or COMP+A_COMP sequence order controls 
  rand  int                     hqmproc_acomp_ctrl;

  //-------------------------
  //default constraint 
  //------------------------- 
  constraint hqmproc_enq_sel_soft {
    soft hqmproc_acomp_ctrl             == 0;
    soft hqmproc_trfgen_watchdog_ena    == 0;
    soft hqmproc_trfgen_watchdog_num    == 200000;

    soft hqmproc_trfctrl_sel_mode    == 0;   
    soft hqmproc_trfflow_ctrl_mode   == 0;   
    soft hqmproc_watchdogctrl_sel_mode  == 1;

    soft hqmproc_trfidle_enable == 0; 
    soft hqmproc_trfidle_num == 1000;

    soft hqmproc_cqbufctrl_sel_mode  == 1;
    soft hqmproc_cqbufinit_sel_mode  == 1;
    soft hqmproc_rtntokctrl_sel_mode == 0;
    soft hqmproc_rtntokctrl_holdnum  == 16;
    soft hqmproc_rtntokctrl_rtnnum   == 16;
    soft hqmproc_rtntokctrl_holdnum_waitnum == 0;
    soft hqmproc_rtntokctrl_threshold == 0;

    soft hqmproc_rtncmpctrl_sel_mode == 0;
    soft hqmproc_rtncmpctrl_holdnum  == 16;
    soft hqmproc_rtncmpctrl_rtnnum   == 16;
    soft hqmproc_rtncmpctrl_holdnum_waitnum == 0;
    soft hqmproc_rtncmpctrl_threshold == 0;

    soft hqmproc_rtn_a_cmpctrl_sel_mode == 0;
    soft hqmproc_rtn_a_cmpctrl_holdnum  == 16;
    soft hqmproc_rtn_a_cmpctrl_rtnnum   == 16;
    soft hqmproc_rtn_a_cmpctrl_holdnum_waitnum == 0;

    soft hqmproc_cq_intr_thres_num     == 1;
    soft hqmproc_cq_rearm_ctrl         == 0;

    soft hqmproc_enqctrl_sel_mode     == 0; 
    soft hqmproc_enqctrl_newnum       == 0;
    soft hqmproc_enqctrl_fragnum      == 0;
    soft hqmproc_enqctrl_enqnum       == 0;
    soft hqmproc_enqctrl_enqnum_1     == 0;
    soft hqmproc_enqctrl_hold_waitnum == 0;

    soft hqmproc_cq_dep_chk_adj       == 0; 

    soft hqmproc_qid_sel_mode      == 0;   
    soft hqmproc_qid_gen_prob      == 95;   
    soft hqmproc_qid_min           == 0;  
    soft hqmproc_qid_max           == 0;     

    soft hqmproc_qtype_sel_mode    == 0; 
    soft hqmproc_qtype_dir         == 0; 
    soft hqmproc_qtype_ldb         == 0;   
    soft hqmproc_qtype_ldb_min     == 0;  
    soft hqmproc_qtype_ldb_max     == 0;
  
    soft hqmproc_qpri_sel_mode     == 0;
    soft hqmproc_qpri_min          == 0; 
    soft hqmproc_qpri_max          == 0;   

    soft hqmproc_lockid_sel_mode   == 0;     

    soft hqmproc_frag_num_min      == 0;
    soft hqmproc_frag_num_max      == 0;
    soft hqmproc_frag_ctrl         == 0;
    soft hqmproc_frag_replay_ctrl  == 0;
    soft hqmproc_frag_t_ctrl       == 1;
    
    soft hqmproc_stream_ctrl       == 0;
    soft hqmproc_strenq_num_min    == 0;
    soft hqmproc_strenq_num_max    == 0;
    soft hqmproc_rels_ctrl         == 0;

    soft hqmproc_renq_qid_sel_mode      == 0;   
    soft hqmproc_renq_qid_min           == 0;  
    soft hqmproc_renq_qid_max           == 0;     

    soft hqmproc_renq_qtype_sel_mode    == 0; 
    soft hqmproc_renq_qtype_dir         == 0; 
    soft hqmproc_renq_qtype_ldb         == 0;   
    soft hqmproc_renq_qtype_ldb_min     == 0;  
    soft hqmproc_renq_qtype_ldb_max     == 0;
  
    soft hqmproc_renq_qpri_sel_mode     == 0;
    soft hqmproc_renq_qpri_min          == 0; 
    soft hqmproc_renq_qpri_max          == 0;   

    soft hqmproc_renq_lockid_sel_mode   == 0;   

    soft hqmproc_ingerrinj_ingress_drop == 0;

    soft hqmproc_ingerrinj_excess_tok_rand == 0;
    soft hqmproc_ingerrinj_excess_tok_ctrl == 0;
    soft hqmproc_ingerrinj_excess_tok_rate == 50;
    soft hqmproc_ingerrinj_excess_tok_num  == 0;

    soft hqmproc_ingerrinj_excess_cmp_rand == 0;
    soft hqmproc_ingerrinj_excess_cmp_ctrl == 0;
    soft hqmproc_ingerrinj_excess_cmp_rate == 50;
    soft hqmproc_ingerrinj_excess_cmp_num  == 0;
   
    soft hqmproc_ingerrinj_excess_a_cmp_rand == 0;
    soft hqmproc_ingerrinj_excess_a_cmp_ctrl == 0;
    soft hqmproc_ingerrinj_excess_a_cmp_rate == 50;
    soft hqmproc_ingerrinj_excess_a_cmp_num  == 0;

    soft hqmproc_ingerrinj_cmpid_rand == 0;
    soft hqmproc_ingerrinj_cmpid_ctrl == 0;
    soft hqmproc_ingerrinj_cmpid_rate == 50;
    soft hqmproc_ingerrinj_cmpid_num  == 1;

    soft hqmproc_ingerrinj_cmpdirpp_rand == 0;
    soft hqmproc_ingerrinj_cmpdirpp_ctrl == 0;
    soft hqmproc_ingerrinj_cmpdirpp_rate == 50;

    soft hqmproc_ingerrinj_qidill_rand == 0;
    soft hqmproc_ingerrinj_qidill_ctrl == 0;
    soft hqmproc_ingerrinj_qidill_rate == 50;
    soft hqmproc_ingerrinj_qidill_min  == 8;
    soft hqmproc_ingerrinj_qidill_max  == 31;

    soft hqmproc_ingerrinj_ppill_rand == 0;
    soft hqmproc_ingerrinj_ppill_ctrl == 0;
    soft hqmproc_ingerrinj_ppill_rate == 50;
    soft hqmproc_ingerrinj_ppill_min  == 8;
    soft hqmproc_ingerrinj_ppill_max  == 31;

    soft hqmproc_ingerrinj_ooc_rand == 0;
    soft hqmproc_ingerrinj_ooc_ctrl == 0;
    soft hqmproc_ingerrinj_ooc_rate == 50;

    soft hqmproc_meas_enable == 0;
    soft  hqmproc_meas_rand  == 0;
    soft  hqmproc_idsi_ctrl  == 0;

    soft hqmproc_cqirq_mask_ena == 0;
    
    soft hqmproc_dta_ctrl == 1;
    soft hqmproc_dta_srcpp == 0;
    soft hqmproc_dta_wpp_idlenum == 3000;
  }

  //-------------------------
  //Function: new 
  //-------------------------
  function new(string name = "hqm_pp_cq_hqmproc_seq");
    uvm_object o_tmp;

    super.new(name); 
    hqmproc_trfgen_watchdog_cnt = 0;
    hqmproc_trfgen_stop = 0;
    total_genenq_count = 0; 
    total_atm_genenq_count = 0; 
    total_uno_genenq_count = 0; 
    dta_comp_return_count=0;
    hqmproc_rtntokctrl_loopnum=0;
    hqmproc_rtntokctrl_loopcnt=0;
    hqmproc_rtntokctrl_cnt=0;
    hqmproc_rtncmpctrl_loopnum=0;
    hqmproc_rtncmpctrl_loopcnt=0;
    hqmproc_rtncmpctrl_cnt=0;
    hqmproc_rtntokctrl_holdnum_check=0;
    hqmproc_rtntokctrl_holdnum_waitcnt=0;
    hqmproc_rtncmpctrl_holdnum_check=0;
    hqmproc_rtncmpctrl_holdnum_waitcnt=0;

    hqmproc_rtn_a_cmpctrl_loopnum=0;
    hqmproc_rtn_a_cmpctrl_loopcnt=0;
    hqmproc_rtn_a_cmpctrl_cnt=0;
    hqmproc_rtn_a_cmpctrl_holdnum_check=0;
    hqmproc_rtn_a_cmpctrl_holdnum_waitcnt=0;

    curr_sch_num=0;
    has_ldb_sch_cnt_check=0;
    pend_hcw_trans_idx=0;
    pend_hcw_trans_comb_idx=0;
    strenq_cnt=0;
    strenq_last=0;
    hqmproc_stream_flowctrl=0;
    hqmproc_enqctrl_hold_waitcnt=0;
    hqmproc_enqctrl_st=0;  //0: go; 1: hold; 2: wait idle
    hqmproc_enqrtnctrl_st=0;
    enq_out_of_credit=0;
    foreach(hqmproc_rel_hcw_count[i]) hqmproc_rel_hcw_count[i]=0;
    
    cq_intr_received_num=0;
    cq_intr_service_state=0;
    cq_intr_rtntok_num=65535;
    cq_intr_enq_num=65535;
    cq_intr_occ_tim_state=0;
    hqmproc_cqirq_mask_waitcnt=0;
    cq_intr_service_cqirq_rearm_hold=0;
    cqirq_mask_issue_state=0;
    is_adj_renq_on=0; 
    hqmproc_dta_wpp_idlecnt=0;

    cq_comp_service_state=0;

    //--congestion check qid
    //hqm_lsp_qid_congest_mismatch_cnt=0;
    //hqm_lsp_qid_depth_init_lock=0;
    //hqm_lsp_qid_depth_init_lock_cnt=0;
    //hqm_lsp_qid_depth_prev=3; //--direct test of congestion, start from 3 (depth> thres)
  endfunction
  
  extern virtual task hqmproc_gen_queue_list(int queue_list_index);
  extern virtual task hqmproc_get_hcw_gen_type(input  int               queue_list_index,
                                       input  bit               new_hcw_en,
                                       input  hcw_qtype         enqhcw_qtype,    
                                       input  int               enqhcw_qid,    
                                       input  hcw_qtype         renq_qtype,    
                                       input  int               renq_qid,    
                                       input  int               pend_hcw_trans_queue_index,
                                       output bit               send_hcw,
                                       output hcw_cmd_type_t    cmd_type,
                                       output hcw_qtype         enqhcw_qtype_use,    
                                       output int               enqhcw_qid_use,    
                                       output int               cq_token_return,
                                       output int               is_ordered, 
                                       output int               is_reorded,
                                       output int               curr_frag_num,  
                                       output int               curr_frag_cnt,  
                                       output int               curr_frag_last  
                                      );

  extern virtual task body();
  extern virtual task body_setup();
  extern virtual task hqmproc_trfidle_count_run();
  extern virtual task hqmproc_cq_intr_run();
  extern virtual task hqmproc_intr_poll_run(input int loop_num, output int cq_intr_recv);
  extern virtual task hqmproc_intr_check_task(output int cq_intr_recv);


  extern virtual function get_hqmproc_qid   (input int qid_sel_mode,    int qid_in, int genenq_count,                                  output int qid_gen);
  extern virtual function get_hqmproc_qpri  (input int qpri_sel_mode,   int genenq_count,                                              output bit[2:0] qpri_gen);
  extern virtual function get_hqmproc_qtype (input int qtype_sel_mode,  hcw_qtype qtype_in,    int qid_in,   int genenq_count,         output hcw_qtype qtype_gen);
  extern virtual function get_hqmproc_lockid(input int lockid_sel_mode, bit [15:0] lock_id_in, int genenq_count, hcw_qtype qtype_curr, output bit[15:0] lockid_gen);

  extern virtual function get_hqmproc_renq_qid   (input int qid_sel_mode,    int qid_in, int genenq_count, 			       output int qid_gen);
  extern virtual function get_hqmproc_renq_qpri  (input int qpri_sel_mode,   int genenq_count,  				       output bit[2:0] qpri_gen);
  extern virtual function get_hqmproc_renq_qtype (input int qtype_sel_mode,  hcw_qtype qtype_in, int qid_in, int genenq_count,	       output hcw_qtype qtype_gen);
  extern virtual function get_hqmproc_renq_lockid(input int lockid_sel_mode, bit [15:0] lock_id_in, int genenq_count, hcw_qtype qtype_curr, output bit[15:0] lockid_gen);


  //-------------------------
  //------------------------- 
endclass : hqm_pp_cq_hqmproc_seq


 


//-------------------------
//-- body_setup
//-- file format: qtypecode, ppid, pool, is_rtncredonly, reord, frgnum, is_ldb_credit, is_carry_uhl, is_carry_tkn, is_multi_tkn
//-------------------------
task hqm_pp_cq_hqmproc_seq::body_setup();
  super.body_setup();

  strenq_num = $urandom_range(hqmproc_strenq_num_max,hqmproc_strenq_num_min);
  `uvm_info(get_full_name(),$psprintf("%s PP/CQ 0x%0x Start with hqmproc_frag_ctrl=%0d hqmproc_frag_t_ctrl=%0d cq_gen=%0d", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_frag_ctrl,  hqmproc_frag_t_ctrl, cq_gen),UVM_LOW);
  `uvm_info(get_full_name(),$psprintf("%s PP/CQ 0x%0x Start with hqmproc_stream_ctrl=%0d hqmproc_rels_ctrl=%0d hqmproc_stream_flowctrl=%0d ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_stream_ctrl,hqmproc_rels_ctrl, hqmproc_stream_flowctrl),UVM_LOW);
  `uvm_info(get_full_name(),$psprintf("%s PP/CQ 0x%0x Start with queue_list.hcw_delay_max=%0d hcw_delay_min=%0d hcw_delay_ctrl_mode=%0d ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, queue_list[0].hcw_delay_max, queue_list[0].hcw_delay_min, hcw_delay_ctrl_mode),UVM_LOW);
  `uvm_info(get_full_name(),$psprintf("%s PP/CQ 0x%0x Start with queue_list_delay_max=%0d queue_list_delay_min=%0d hcw_delay_ctrl_mode=%0d", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, queue_list_delay_max, queue_list_delay_min, hcw_delay_ctrl_mode),UVM_LOW);
   if(hqmproc_acomp_ctrl>0) cq_comp_service_state = hqmproc_acomp_ctrl;
  `uvm_info(get_full_name(),$psprintf("%s PP/CQ 0x%0x Start with hqmproc_acomp_ctrl=%0d init cq_comp_service_state=%0d", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_acomp_ctrl,  cq_comp_service_state),UVM_LOW);


  hqmproc_rtncmpctrl_holdnum_save = hqmproc_rtncmpctrl_holdnum;

  if (pp_cq_type == IS_LDB) begin
    if (i_hqm_pp_cq_status.ldb_pp_cq_status[pf_pp_cq_num].cq_init_done == 0 && hqmproc_cqbufinit_sel_mode == 1) begin
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ",$psprintf("%s PP/CQ 0x%0x cq_buffer_init Start ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
      cq_buffer_init();
    end else begin
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ",$psprintf("%s PP/CQ 0x%0x cq_buffer_init Bypassed ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
  end else begin
    if (i_hqm_pp_cq_status.dir_pp_cq_status[pf_pp_cq_num].cq_init_done == 0 && hqmproc_cqbufinit_sel_mode == 1) begin
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ",$psprintf("%s PP/CQ 0x%0x cq_buffer_init Start ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
      cq_buffer_init();
    end else begin
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ",$psprintf("%s PP/CQ 0x%0x cq_buffer_init Bypassed ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
  end 
endtask : body_setup

//-------------------------
//-- body
//-- file format: qtypecode, ppid, pool, is_rtncredonly, reord, frgnum, is_ldb_credit, is_carry_uhl, is_carry_tkn, is_multi_tkn
//-------------------------
task hqm_pp_cq_hqmproc_seq::body();
   int inv_ctrl;

   hqmproc_dta_num_hcw=queue_list[0].num_hcw;
  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW",$psprintf("HQMPROC_SEQ: Starting sequence - PF %s  pp_cq_num %0d (pf_pp_cq_num %0d) : num_hcw %0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, pf_pp_cq_num, hqmproc_dta_num_hcw),UVM_LOW)
  
  body_setup();

  fork
    begin
      pend_cq_token_return.run();
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW",$psprintf("%s PP/CQ 0x%0x pend_cq_token_return.run() done_00",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
  join_none

  fork
    begin
      pend_comp_return.run();
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW",$psprintf("%s PP/CQ 0x%0x pend_comp_return.run() done_01",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
  join_none

  fork
    begin
      pend_a_comp_return.run();
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW",$psprintf("%s PP/CQ 0x%0x pend_a_comp_return.run() done_02", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 
  join_none
  
  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW",$psprintf("%s PP/CQ 0x%0x call mon_watchdog_reset() ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
  mon_watchdog_reset();

  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW",$psprintf("HQMPROC_SEQ: %s PP/CQ 0x%0x Start fork ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
  fork
    begin
      if(hqmproc_watchdogctrl_sel_mode==0) begin
        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x watchdog_monitor Bypassed  done_10", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
      end else begin
         watchdog_monitor();
        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x watchdog_monitor done_10", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
      end 
    end 

    begin
      return_delay_monitor(tok_return_delay_q, tok_return_delay_mode, total_tok_return_count, tok_return_delay);
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x return_delay_monitor tok_return_delay done_11", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 

    begin
      return_delay_monitor(comp_return_delay_q, comp_return_delay_mode, total_comp_return_count, comp_return_delay);
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x return_delay_monitor comp_return_delay done_12", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 

    begin
      return_delay_monitor(a_comp_return_delay_q, a_comp_return_delay_mode, total_a_comp_return_count, a_comp_return_delay);
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x return_delay_monitor a_comp_return_delay done_13", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 

    begin
      if(hqmproc_cqbufctrl_sel_mode==0) begin
         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x bypassed done_14", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
      end else begin
         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x cq_buffer_monitor Start",  (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
         cq_buffer_monitor();
         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x cq_buffer_monitor done_14", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
      end 
    end 

    begin
      if(hqmproc_cqirq_mask_ena==1) begin
         hqmproc_cq_intr_run();
         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x hqmproc_cq_intr_run done_15", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
      end else begin
         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x hqmproc_cq_intr_run bypassed done_15", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
      end 
    end 

    begin
      gen_completions();
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x gen_completions done_16", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 

    begin
      gen_renq_frag();
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x gen_renq_frag done_17", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
    end 

    begin
      if(hqmproc_trfidle_enable==1) begin
          while(1) begin
             sys_clk_delay(100);
             hqmproc_trfidle_count_run();

             if(i_hqm_pp_cq_status.get_trfidle_cnt(pp_cq_type,pp_cq_num) > hqmproc_trfidle_num) begin
                 `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x watchdog_enqtrf reach hqmproc_trfidle_num %0d, call force_seq_stop ", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_trfidle_num),UVM_LOW)
                 i_hqm_pp_cq_status.force_seq_stop(pp_cq_type,pp_cq_num); 
                 break;
             end 
          end 
          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x watchdog_enqtrf done_18", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
      end 
    end 

    begin
      if($test$plusargs("HQMV30_ATS_INV_TEST")) begin 
         if(pp_cq_type == IS_LDB) begin 
            inv_ctrl=i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_ats_inv_ctrl;  
         end else begin
            inv_ctrl=i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_ats_inv_ctrl;  
         end 
         if(inv_ctrl==1) begin
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x Call HqmAtsInvalid_task", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
            HqmAtsInvalid_task();
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x HqmAtsInvalid_task done_19", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
         end else begin
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x Skip HqmAtsInvalid_task done_19", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_LOW)
         end 
      end 
    end 
  join_none

  foreach (queue_list[i]) begin
    fork
      automatic int j = i;
      begin
        hqmproc_gen_queue_list(j);
        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("%s PP/CQ 0x%0x queue_list %d done_20", (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,j),UVM_LOW)
      end 
    join_none
  end 

  wait fork;

  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("HQMPROC_SEQ: Done wait fork - PF %s  pp_cq_num %0d (pf_pp_cq_num %0d) - renq_credits_rsvd=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, pf_pp_cq_num, renq_credits_rsvd),UVM_LOW)
  update_state();

  //--------------------------------------------------------------------------------------------------------------------------------
  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_FLOW2",$psprintf("HQMPROC_SEQ: Done sequence - PF %s  pp_cq_num %0d (pf_pp_cq_num %0d)",(pp_cq_type == IS_LDB) ? "LDB" : "DIR", pp_cq_num, pf_pp_cq_num),UVM_LOW)
endtask : body

//=========================================
//-- hqmproc_trfidle_count_run
//=========================================
task hqm_pp_cq_hqmproc_seq::hqmproc_trfidle_count_run();
    if(pp_cq_type == IS_LDB) begin
        i_hqm_pp_cq_status.st_trfidle_cnt(1,pp_cq_num); 
    end else begin
        i_hqm_pp_cq_status.st_trfidle_cnt(0,pp_cq_num); 
    end 
endtask: hqmproc_trfidle_count_run

//=========================================
//-- hqmproc_gen_queue_list
//-- Based on gen_queue_list
//=========================================
task hqm_pp_cq_hqmproc_seq::hqmproc_gen_queue_list(int queue_list_index);
  automatic   hcw_transaction         hcw_trans;
  automatic   hcw_cmd_type_t          cmd_type;
  automatic   illegal_hcw_type_t      illegal_hcw_type;
  automatic   int                     cq_token_return;
  automatic   bit                     send_hcw;
  automatic   int                     pend_cq_token_return_size;
  automatic   int                     pend_comp_return_size;
  automatic   int                     pend_a_comp_return_size;
  automatic   int                     is_ordered;
  automatic   int                     is_reorded;
  automatic   int                     curr_frag_num;
  automatic   int                     curr_frag_cnt;
  automatic   int                     curr_frag_last;
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
  
  bit [7:0]  pp_port;     //bit7: is_ldb
  hcw_qtype  qtype_genval;
  int        qid_genval;
  bit [2:0]  qpri_genval;
  bit [15:0] lockid_genval;
  hcw_qtype  hcw_qtype_use; 
  int        hcw_qid_use;
  bit [2:0]  hcw_qpri_use;
  bit [15:0] hcw_lockid_use;
  bit [63:0] hcw_tbcnt_use;
  bit        hcw_nodec;  
  int        send_hcw_loop;
  bit        has_meas_on;
  int        has_rels_on;
  int        has_unexp_rels_on;

  int        has_excess_comp_inj;
  int        has_excess_a_comp_inj;
  int        has_ingerrinj_cmpid;
  int        has_ingerrinj_cmpdirpp;
  int        has_ingerrinj_qidill;
  int        has_ingerrinj_ppill;
  int        prev_cmp_id;
  int        curr_vas;
  bit        curr_pp_ldb;
  hcw_cmd_type_t          saved_cmd_type;
  int        is_ppid_valid;
  int        has_ingerrinj_isolate1;
  int        is_ao_cfg_v;
  int        cq_ats_resp_errinj_issued;


  active_gen_queue_list_cnt++;
  new_hcw_en_delay = $urandom_range(new_hcw_en_delay_max,new_hcw_en_delay_min);
  queue_list_delay = $urandom_range(queue_list_delay_max,queue_list_delay_min);

  illegal_hcw_burst_start_num = $urandom_range(queue_list[queue_list_index].num_hcw,0);
  illegal_hcw_burst_count     = (queue_list[queue_list_index].illegal_hcw_gen_mode == BURST_ILLEGAL) ? queue_list[queue_list_index].illegal_hcw_burst_len : 0;
  illegal_hcw_burst_active    = 1'b0;
  hcw_nodec                   = 1'b0;
  has_rels_on                 = 0;
  has_unexp_rels_on           = 0;
  send_hcw_loop               = 1; 
  has_meas_on                 = 0;
  has_ingerrinj_cmpid         = 0;
  has_ingerrinj_cmpdirpp      = 0;
  has_ingerrinj_qidill        = 0;
  has_ingerrinj_ppill         = 0;
  has_ingerrinj_isolate1      = 0;
  cq_ats_resp_errinj_issued   = 0;

  //--hqmproc_rtntokctrl_sel_mode=2: hold tok and rlease tok repeatly
  if(hqmproc_rtntokctrl_sel_mode==2) begin
    if((queue_list[queue_list_index].num_hcw / (hqmproc_rtntokctrl_holdnum+hqmproc_rtntokctrl_rtnnum)) > 2)
       hqmproc_rtntokctrl_loopnum = (queue_list[queue_list_index].num_hcw / (hqmproc_rtntokctrl_holdnum+hqmproc_rtntokctrl_rtnnum)) - 2;
    else
       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen0: %s PP %0d index=%0d num_hcw=%0d hqmproc_rtntokctrl_holdnum=%0d hqmproc_tokcmpctrl_rtnnum=%0d less than 2, Check cft",pp_cq_type.name(),pp_cq_num,queue_list_index,queue_list[queue_list_index].num_hcw, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_rtnnum),UVM_MEDIUM)
  end 

  //--hqmproc_rtncmpctrl_sel_mode=2: hold cmp and rlease tok repeatly
  if(hqmproc_rtncmpctrl_sel_mode==2) begin
    if((queue_list[queue_list_index].num_hcw / (hqmproc_rtncmpctrl_holdnum+hqmproc_rtncmpctrl_rtnnum)) > 2) 
        hqmproc_rtncmpctrl_loopnum = (queue_list[queue_list_index].num_hcw / (hqmproc_rtncmpctrl_holdnum+hqmproc_rtncmpctrl_rtnnum)) - 2;
    else
       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen0: %s PP %0d index=%0d num_hcw=%0d hqmproc_rtncmpctrl_holdnum=%0d hqmproc_rtncmpctrl_rtnnum=%0d less than 2, Check cft",pp_cq_type.name(),pp_cq_num,queue_list_index,queue_list[queue_list_index].num_hcw, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_rtnnum),UVM_MEDIUM)
  end 

  hqmproc_cqirq_mask_waitnum = $urandom_range(hqmproc_cqirq_mask_waitnum_min, hqmproc_cqirq_mask_waitnum_max); 

  while (mon_enable) begin
    if (pp_cq_type == IS_LDB) begin
      has_trfenq_enable = i_hqm_cfg.hqmproc_ldb_trfctrl[pp_cq_num];
    end else begin
      has_trfenq_enable = i_hqm_cfg.hqmproc_dir_trfctrl[pp_cq_num];
    end 

    //-------------------------------------
    //-------------------------------------
    if(pp_cq_type == IS_LDB) begin
       cq_ats_resp_errinj_issued = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_ats_resp_errinj_st; 
    end else begin
       cq_ats_resp_errinj_issued = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_ats_resp_errinj_st; 
    end 

    if(cq_ats_resp_errinj_issued==1 && i_hqm_cfg.ats_enabled==1) begin
        //if(has_trfenq_enable==0) begin
         // `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfGen0_ATSRESP_ERRINJ_Issued: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d: current num_hcw=%0d mon_enable=%0d has_trfenq_enable=%0d => Will pause Enq generation in hqmproc_get_hcw_gen_type()", pp_cq_type.name(), pp_cq_num, hqmproc_enqctrl_sel_mode, queue_list_index,queue_list[queue_list_index].num_hcw, mon_enable, has_trfenq_enable),UVM_LOW)
        //end else begin
        //  `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfGen0_ATSRESP_ERRINJ_Issued: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d: current num_hcw=%0d mon_enable=%0d has_trfenq_enable=%0d => Will Resume Enq generation in hqmproc_get_hcw_gen_type()", pp_cq_type.name(), pp_cq_num, hqmproc_enqctrl_sel_mode, queue_list_index,queue_list[queue_list_index].num_hcw, mon_enable, has_trfenq_enable),UVM_LOW)
        //end 
        //end else begin
        //  `uvm_info("HQM_PP_CQ_BASE_SEQ",$psprintf("TrfGen0_ATSRESP_ERRINJ_Issued: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d: current num_hcw=%0d mon_enable=%0d has_trfenq_enable=%0d => Will continue gen_queue_list()", pp_cq_type.name(), pp_cq_num, hqmproc_enqctrl_sel_mode, queue_list_index,queue_list[queue_list_index].num_hcw, mon_enable, has_trfenq_enable),UVM_LOW)
        //   continue;

           ////i_hqm_cfg.do_force_seq_finish=1;
           ////break;
        //end 
    end 

    //-------------------------------------
    //-------------------------------------
    new_hcw_en = cycle_count > (new_hcw_en_delay + (queue_list_index * queue_list_delay));

    pend_cq_token_return.abs_size(pend_cq_token_return_size);         // get absolute size
    pend_comp_return.abs_size(pend_comp_return_size);                 // get absolute size
    pend_a_comp_return.abs_size(pend_a_comp_return_size);             // get absolute size

    
    hcw_nodec          = 1'b0;
    send_hcw_loop      = 1; 

    if(hqmproc_trfflow_ctrl_mode==1 && hqmproc_cqbufctrl_sel_mode==0) begin
        if(queue_list[queue_list_index].num_hcw == 0) begin
              i_hqm_pp_cq_status.force_seq_stop(pp_cq_type,pp_cq_num); 
              `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGenLoopForce_seq_Stop: %s PP %0d index=%0d num_hcw=%0d active_gen_queue_list_cnt=%0d active_seq_cnt=%0d mon_enable=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,queue_list[queue_list_index].num_hcw, active_gen_queue_list_cnt, active_seq_cnt, mon_enable),UVM_MEDIUM)
        end 
    end 

    ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGenLoopStart: %s PP %0d index=%0d num_hcw=%0d/comp_flow=%0d/cq_token_return_flow=%0d, total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d illegal_hcw_burst_count=%0d pend_cq_token_return=%0d pend_cq_int_arm=%0d pend_comp_return=%0d, hqmproc_trfctrl_sel_mode=%0d/rtntok_mode=%0d/rtncmp_mode=%0d, hqmproc_qid_sel_mode=%0d hqmproc_qtype_sel_mode=%0d hqmproc_qpri_sel_mode=%0d hqmproc_lockid_sel_mode=%0d cq_addr=0x%0x;; frag_num=%0d frag_cnt=%0d frag_last=%0d; active_gen_queue_list_cnt=%0d active_seq_cnt=%0d mon_enable=%0d hqmproc_trfflow_ctrl_mode=%0d hqmproc_cqbufctrl_sel_mode=%0d",
        ///pp_cq_type.name(),pp_cq_num,queue_list_index,queue_list[queue_list_index].num_hcw,queue_list[queue_list_index].comp_flow,queue_list[queue_list_index].comp_flow, total_genenq_count,total_tok_return_count,total_comp_return_count, illegal_hcw_burst_count,pend_cq_token_return_size,pend_cq_int_arm.size(),pend_comp_return_size, hqmproc_trfctrl_sel_mode, hqmproc_rtntokctrl_sel_mode, hqmproc_rtncmpctrl_sel_mode, hqmproc_qid_sel_mode,hqmproc_qtype_sel_mode,hqmproc_qpri_sel_mode,hqmproc_lockid_sel_mode, cq_addr, frag_num, frag_cnt, frag_last, active_gen_queue_list_cnt, active_seq_cnt, mon_enable, hqmproc_trfflow_ctrl_mode, hqmproc_cqbufctrl_sel_mode),UVM_MEDIUM)


    if ((queue_list[queue_list_index].num_hcw > 0) || (illegal_hcw_burst_count > 0) || (pend_cq_token_return_size > 0 && queue_list[queue_list_index].cq_token_return_flow) || (pend_cq_int_arm.size() > 0) || ((pend_comp_return_size > 0 || pend_a_comp_return_size > 0) && queue_list[queue_list_index].comp_flow)) begin
      mon_watchdog_reset();

      if (!illegal_hcw_burst_active && (illegal_hcw_burst_count > 0)) begin
        if (illegal_hcw_burst_start_num == queue_list[queue_list_index].num_hcw) begin
          illegal_hcw_burst_active = 1'b1;
        end 
      end 

      if (illegal_hcw_burst_active && (illegal_hcw_burst_count == 0)) begin
        illegal_hcw_burst_active = 1'b0;
      end 

      //--------
      //-- based on sel_mode, pre-select qid/qtype/lockid/pri 
      //----------------------------------------------------------------
      //-- hqmproc select qid/qpri/qtype/lockid
      get_hqmproc_qid(hqmproc_qid_sel_mode,      queue_list[queue_list_index].qid,     total_genenq_count, qid_genval);
      //--clamping, need to revisit for error inj support
      if(queue_list[queue_list_index].qtype==QDIR) begin
         if(qid_genval>63) qid_genval=$urandom_range(63,0);
      end else begin
         if(qid_genval>31) qid_genval=qid_genval[4:0];
      end 

      get_hqmproc_qpri(hqmproc_qpri_sel_mode,    total_genenq_count, qpri_genval);
      get_hqmproc_qtype(hqmproc_qtype_sel_mode,  queue_list[queue_list_index].qtype,   qid_genval, total_genenq_count, qtype_genval);
      get_hqmproc_lockid(hqmproc_lockid_sel_mode,queue_list[queue_list_index].lock_id, total_atm_genenq_count, qtype_genval, lockid_genval);
	
      if($test$plusargs("HQM_DIRPP_QDIR")) begin 
        if (pp_cq_type == IS_DIR) begin
          qtype_genval = QDIR;
          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen0: %s PP %0d index=%0d override qtype_genval = QDIR ",pp_cq_type.name(),pp_cq_num,queue_list_index),UVM_MEDIUM)
        end 
      end 

      ////`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen0: %s PP %0d index=%0d num_hcw=%0d total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d illegal_hcw_burst_count=%0d pend_cq_token_return=%0d pend_cq_int_arm=%0d pend_comp_return=%0d cq_intr_rtntok_num=%0d cq_intr_enq_num=%0d, hqmproc_trfctrl_sel_mode=%0d/rtntok_mode=%0d/rtncmp_mode=%0d, hqmproc_qid_sel_mode=%0d qid_genval=0x%0x, hqmproc_qtype_sel_mode=%0d qtype_genval=%0s, hqmproc_qpri_sel_mode=%0d qpri_genval=%0d, hqmproc_lockid_sel_mode=%0d lockid_genval=0x%0x",pp_cq_type.name(),pp_cq_num,queue_list_index,queue_list[queue_list_index].num_hcw,total_genenq_count,total_tok_return_count,total_comp_return_count, illegal_hcw_burst_count,pend_cq_token_return_size,pend_cq_int_arm.size(),pend_comp_return_size, cq_intr_rtntok_num, cq_intr_enq_num, hqmproc_trfctrl_sel_mode, hqmproc_rtntokctrl_sel_mode, hqmproc_rtncmpctrl_sel_mode, hqmproc_qid_sel_mode, qid_genval, hqmproc_qtype_sel_mode, qtype_genval.name(), hqmproc_qpri_sel_mode, qpri_genval, hqmproc_lockid_sel_mode, lockid_genval),UVM_MEDIUM)

      if ( illegal_hcw_burst_active ||
           ( (queue_list[queue_list_index].illegal_num_hcw > 0) &&
             (queue_list[queue_list_index].illegal_hcw_gen_mode == RAND_ILLEGAL) &&
             ($urandom_range(99,0) < queue_list[queue_list_index].illegal_hcw_prob)
           )
         ) begin
        get_illegal_hcw_gen_type(queue_list_index,
                                 new_hcw_en,
                                 //qtype_genval,
                                 //qid_genval,
                                 send_hcw,
                                 cmd_type,
                                 illegal_hcw_type);

        if (send_hcw & illegal_hcw_burst_active) begin
          illegal_hcw_burst_count--;
        end 

        is_ordered = 0;
        is_reorded = 0;

        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_illegalHCW: %s PP %0d index=%0d send_hcw=%0d cmd_type=%s illegal_num_hcw=%0d num_hcw=%0d cq_token_return=%0d is_ordered=%0d is_reorded=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,send_hcw,cmd_type.name(),queue_list[queue_list_index].illegal_num_hcw, queue_list[queue_list_index].num_hcw, cq_token_return,is_ordered,is_reorded),UVM_MEDIUM)

      end else begin
         //--------------------------
         //-- 1/ Before Call hqmproc_get_hcw_gen_type, find which SCHED HCW in pend_hcw_trans to run replay flow 
         //--------------------------
         if(pend_hcw_trans.size()>0) begin
            if(hqmproc_frag_replay_ctrl==1) begin
              pend_hcw_trans_idx = $urandom_range(0, (pend_hcw_trans.size()-1)); 
            end else begin
              pend_hcw_trans_idx = 0; 
            end 

            `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_HCWD0: %s PP %0d index=%0d pend_hcw_trans.size=%0d pend_hcw_trans_idx=%0d frg_first=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_hcw_trans.size(), pend_hcw_trans_idx, pend_hcw_trans[pend_hcw_trans_idx].frg_first),UVM_MEDIUM)

            if(pend_hcw_trans[pend_hcw_trans_idx].frg_first==0) begin
                pend_hcw_trans[pend_hcw_trans_idx].frg_cnt  = 0;
                pend_hcw_trans[pend_hcw_trans_idx].frg_last = 0;
                pend_hcw_trans[pend_hcw_trans_idx].frg_first= 1;
                pend_hcw_trans[pend_hcw_trans_idx].frg_num  = $urandom_range(hqmproc_frag_num_max,hqmproc_frag_num_min);
            end 

            //-- support VASRESET -  has_trfenq_enable>1, frag_num correction
            if(has_trfenq_enable>1 && pend_hcw_trans[pend_hcw_trans_idx].frg_num>16) begin
                pend_hcw_trans[pend_hcw_trans_idx].frg_num = $urandom_range(1, 16);
            end 

            `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_HCWD1: %s PP %0d index=%0d pend_hcw_trans.size=%0d pend_hcw_trans_idx=%0d frg_first=%0d frg_cnt=%0d frg_num=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_hcw_trans.size(), pend_hcw_trans_idx, pend_hcw_trans[pend_hcw_trans_idx].frg_first, pend_hcw_trans[pend_hcw_trans_idx].frg_cnt, pend_hcw_trans[pend_hcw_trans_idx].frg_num),UVM_MEDIUM)

            //--------------
            //-- support 2ndPass comp order, always return comp based on pend_hcw_trans order
            //--------------
            if(hqmproc_frag_replay_ctrl==1) begin
               if(pend_hcw_trans[0].frg_first==1 && pend_hcw_trans_idx!=0) begin
                  if(pend_hcw_trans[0].frg_cnt == (pend_hcw_trans[0].frg_num - 1)) begin
                      pend_hcw_trans_idx = 0; 
                      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_HCWD2_return2first: %s PP %0d index=%0d pend_hcw_trans.size=%0d pend_hcw_trans_idx=%0d frg_first=%0d frg_cnt=%0d frg_num=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_hcw_trans.size(), pend_hcw_trans_idx, pend_hcw_trans[pend_hcw_trans_idx].frg_first, pend_hcw_trans[pend_hcw_trans_idx].frg_cnt, pend_hcw_trans[pend_hcw_trans_idx].frg_num),UVM_MEDIUM)
                  end 
               end 
            end 

         end else begin
            pend_hcw_trans_idx = -1;
         end //--if(pend_hcw_trans.size()>0

         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_HCWStart: %s PP %0d index=%0d pend_hcw_trans.size=%0d pend_hcw_trans_idx=%0d; pend_hcw_trans_comb.size=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_hcw_trans.size(), pend_hcw_trans_idx, pend_hcw_trans_comb.size() ),UVM_MEDIUM)

         //--------------------------
         //-- 2/ Call hqmproc_get_hcw_gen_type 
         //--------------------------
         hqmproc_get_hcw_gen_type(queue_list_index, new_hcw_en, qtype_genval, qid_genval, renq_qtype, renq_qid, pend_hcw_trans_idx, send_hcw, cmd_type, hcw_qtype_use, hcw_qid_use, cq_token_return, is_ordered, is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last);

         //--------------------------
         //-- 3/ After hqmproc_get_hcw_gen_type, update frg info in pend_hcw_trans queue
         //--------------------------
         if(pend_hcw_trans_idx>=0) begin
            pend_hcw_trans[pend_hcw_trans_idx].frg_cnt  = curr_frag_cnt;
            pend_hcw_trans[pend_hcw_trans_idx].frg_last = curr_frag_last;
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfGen1_HCWDone: %s PP %0d index=%0d; pend_hcw_trans_idx=%0d curr_frag_first=%0d curr_frag_cnt=%0d curr_frag_num=%0d curr_frag_last=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index,pend_hcw_trans_idx, pend_hcw_trans[pend_hcw_trans_idx].frg_first, pend_hcw_trans[pend_hcw_trans_idx].frg_cnt, pend_hcw_trans[pend_hcw_trans_idx].frg_num, pend_hcw_trans[pend_hcw_trans_idx].frg_last),UVM_MEDIUM)
          end 

         //--------------------------
         //--DTA flow controls
         //--------------------------
         if(hqmproc_dta_ctrl) begin
               if(pp_cq_num != hqmproc_dta_srcpp) begin
                   //-- other workers
                   if(i_hqm_cfg.hqmproc_dta_srcpp_comp == 1 && total_genenq_count>0 && total_tok_return_count>0 && total_comp_return_count>0) begin
                       if(send_hcw==0)begin
                          hqmproc_dta_wpp_idlecnt++;

                          if(hqmproc_dta_wpp_idlecnt > hqmproc_dta_wpp_idlenum) begin
                              //--worker pp stop enq
                              while(queue_list[queue_list_index].num_hcw>0) queue_list[queue_list_index].num_hcw--;

                              hqmproc_enqctrl_sel_mode=0;
                              hqmproc_rtntokctrl_sel_mode=0; 
                              hqmproc_rtncmpctrl_sel_mode=0;
                          end 
                       end else begin
                          hqmproc_dta_wpp_idlecnt=0;
                       end 
                   end 
               end 
         end 


        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1: %s PP %0d index=%0d send_hcw=%0d cmd_type=%s; cq_comp_service_state=%0d; illegal_num_hcw=%0d num_hcw=%0d cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; qid_genval=0x%0x enqhcw_qi=0x%0x  qtype_genval=%0s enqhcw_qtype_use=%0s; strenq_num=%0d strenq_cnt=%0d; cq_intr_service_state=%0d pend_cq_int_arm.size=%0d cq_intr_rtntok_num=%0d cq_intr_enq_num=%0d; total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d; has_trfenq_enable=%0d; total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d; hqmproc_dta_srcpp_comp=%0d hqmproc_dta_wpp_idlecnt=%0d/hqmproc_dta_wpp_idlenum=%0d hqmproc_enqctrl_sel_mode=%0d/hqmproc_rtntokctrl_sel_mode=%0d/hqmproc_rtncmpctrl_sel_mode=%0d",
                     pp_cq_type.name(),pp_cq_num,queue_list_index,send_hcw,cmd_type.name(),cq_comp_service_state, queue_list[queue_list_index].illegal_num_hcw, queue_list[queue_list_index].num_hcw, cq_token_return,is_ordered,is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last, qid_genval, hcw_qid_use, qtype_genval.name(), hcw_qtype_use.name(), strenq_num, strenq_cnt, cq_intr_service_state, pend_cq_int_arm.size(), cq_intr_rtntok_num, cq_intr_enq_num, total_genenq_count, total_tok_return_count, total_comp_return_count, has_trfenq_enable, total_genenq_count, total_tok_return_count, total_comp_return_count, i_hqm_cfg.hqmproc_dta_srcpp_comp, hqmproc_dta_wpp_idlecnt, hqmproc_dta_wpp_idlenum, hqmproc_enqctrl_sel_mode, hqmproc_rtntokctrl_sel_mode, hqmproc_rtncmpctrl_sel_mode),UVM_MEDIUM)

         //-------------------------------------------------------------------------------------
         //-------------------------------------------------------------------------------------
         //--------------------------
         //-- When has_trfenq_enable=2 
         //-- (VASRESET in progress, sending token/completion)
         //--------------------------
         if(has_trfenq_enable==2 && send_hcw==0) begin
             send_hcw=1;
             if (pp_cq_type == IS_LDB) begin
                cmd_type=COMP_T_CMD;
             end else begin
                cmd_type=BAT_T_CMD;
             end 
             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_has_trfenq_enable=2_forceexcessreturns: %s PP %0d index=%0d send_hcw=%0d cmd_type=%s  illegal_num_hcw=%0d num_hcw=%0d cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; qid_genval=0x%0x enqhcw_qi=0x%0x  qtype_genval=%0s enqhcw_qtype_use=%0s  total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d; has_trfenq_enable=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,send_hcw,cmd_type.name(),queue_list[queue_list_index].illegal_num_hcw, queue_list[queue_list_index].num_hcw, cq_token_return,is_ordered,is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last, qid_genval, hcw_qid_use, qtype_genval.name(), hcw_qtype_use.name(), total_genenq_count, total_tok_return_count, total_comp_return_count, has_trfenq_enable),UVM_MEDIUM)
         end 

         //-------------------------------
         //-- this is to support multiple pp/cq RELEASE seq
         //-------------------------------
         if(hqmproc_frag_ctrl==16 || hqmproc_frag_ctrl==17) begin
             if(cmd_type==FRAG_CMD) cmd_type=NEW_CMD;
             else if(cmd_type==FRAG_T_CMD) cmd_type=NEW_T_CMD;

             if(is_reorded==1) is_reorded=0;

             if(hqmproc_frag_ctrl==16 && (cmd_type==RENQ_CMD || cmd_type==RENQ_T_CMD)) begin 
                 hcw_nodec = 1'b1;           
                 i_hqm_pp_cq_status.enq_nodec_count[hqmproc_rel_qid]++;  
             end else begin
                 hcw_nodec = 1'b0;
             end 
             if(hqmproc_frag_ctrl==17 && (cmd_type==RENQ_CMD || cmd_type==RENQ_T_CMD)) begin
                 hqmproc_rel_hcw_count[lockid_genval[10:0]] = hqmproc_rel_hcw_count[lockid_genval[10:0]] + 1;

                 if(hqmproc_rel_hcw_count[lockid_genval[10:0]]%(hqmproc_nodec_fragnum)==0 && i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].exp_errors.unexp_rels==0)  begin
                    send_hcw_loop=2;
                    has_rels_on=1;
                    has_unexp_rels_on=0;   
                 end else if(hqmproc_rel_hcw_count[lockid_genval[10:0]]%(hqmproc_nodec_fragnum)==0 && i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].exp_errors.unexp_rels==1) begin
                    send_hcw_loop=$urandom_range(2,3);
                    has_rels_on=1;
                    has_unexp_rels_on=1;   
                 end else begin
                    send_hcw_loop=1;  
                    has_rels_on=0;
                    has_unexp_rels_on=0;   
                 end 
             end 
            `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_RELS_Flow1: %s PP %0d index=%0d send_hcw=%0d cmd_type=%s cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; qid_genval=0x%0x enqhcw_qid=0x%0x  qtype_genval=%0s enqhcw_qtype_use=%0s hcw_nodec=%0d send_hcw_loop=%0d enq_nodec_count[%0d]=%0d hqmproc_rel_hcw_count[0x%0x]=%0d  hqmproc_nodec_fragnum=%0d;; has_rels_on=%0d has_unexp_rels_on=%0d ;; total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,send_hcw,cmd_type.name(),cq_token_return,is_ordered,is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last, qid_genval, hcw_qid_use, qtype_genval.name(), hcw_qtype_use.name(), hcw_nodec, send_hcw_loop, hqmproc_rel_qid, i_hqm_pp_cq_status.enq_nodec_count[hqmproc_rel_qid], lockid_genval[10:0], hqmproc_rel_hcw_count[lockid_genval[10:0]],  hqmproc_nodec_fragnum, has_rels_on, has_unexp_rels_on, total_genenq_count, total_tok_return_count, total_comp_return_count),UVM_MEDIUM)
         end //--if(hqmproc_frag_ctrl==16

         //-------------------------------------------------------------------------------------
         //-------------------------------------------------------------------------------------
         //-------------------------------
         //-- this is to support RENQ_TND and RELEASE in streaming seq
         //-------------------------------
         if(hqmproc_rels_ctrl==1 && (cmd_type==RENQ_CMD || cmd_type==RENQ_T_CMD)) begin
             if(i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].exp_errors.unexp_rels==0)  send_hcw_loop=2;
             else if(i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].exp_errors.unexp_rels==1)  send_hcw_loop=$urandom_range(2,3);
             has_rels_on=1;

             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_RELS_Flow2: %s PP %0d index=%0d send_hcw=%0d cmd_type=%s cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; qid_genval=0x%0x enqhcw_qid=0x%0x  qtype_genval=%0s enqhcw_qtype_use=%0s hcw_nodec=%0d send_hcw_loop=%0d enq_nodec_count[%0d]=%0d hqmproc_rel_hcw_count[0x%0x]=%0d  hqmproc_nodec_fragnum=%0d has_rels_on=%0d;;total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,send_hcw,cmd_type.name(),cq_token_return,is_ordered,is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last, qid_genval, hcw_qid_use, qtype_genval.name(), hcw_qtype_use.name(), hcw_nodec, send_hcw_loop, hqmproc_rel_qid, i_hqm_pp_cq_status.enq_nodec_count[hqmproc_rel_qid], lockid_genval[10:0], hqmproc_rel_hcw_count[lockid_genval[10:0]],  hqmproc_nodec_fragnum, has_rels_on, total_genenq_count, total_tok_return_count, total_comp_return_count),UVM_MEDIUM)
         end //--if(hqmproc_rels_ctrl==1

         //-------------------------------------------------------------------------------------
         //-------------------------------------------------------------------------------------
         //-------------------------------------------------------------------------------------
         //-------------------------------------------------------------------------------------
         //-------------------------------
         //-- EXCESS_TOK this is to support excess token return 
         //-- hqmproc_ingerrinj_excess_tok_ctrl=1 (inject excess token in 2nd BAT_T cmd, and issue once)
         //-- hqmproc_ingerrinj_excess_tok_ctrl=2 (inject excess token in the same BAT_T cmd, and issue once)
         //--
         //-- hqmproc_ingerrinj_excess_tok_ctrl=3 (inject excess token in 2nd BAT_T cmd, and issue multiple times, rand based one _rate)
         //-- hqmproc_ingerrinj_excess_tok_ctrl=4 (inject excess token in the same BAT_T cmd, and issue multiple times, rand based one _rate)
         //--
         //-- hqmproc_ingerrinj_excess_tok_ctrl=5 (inject excess token after issuing a NEW_T or RENQ_T or FRAG_T or COMP_T, and issue multiple times, rand based one _rate)
         //-- hqmproc_ingerrinj_excess_tok_ctrl=6 (inject excess token in NEW or RENQ or FRAG or COMP, and issue multiple times, rand based one _rate)
         //-------------------------------
         if(hqmproc_ingerrinj_excess_tok_rand==1) begin
            hqmproc_ingerrinj_excess_tok_ctrl = $urandom_range(3,4);
         end else if(hqmproc_ingerrinj_excess_tok_rand==2) begin
            hqmproc_ingerrinj_excess_tok_ctrl = $urandom_range(5,6);
         end else if(hqmproc_ingerrinj_excess_tok_rand==3) begin
            hqmproc_ingerrinj_excess_tok_ctrl = $urandom_range(3,6);
         end 

         if((hqmproc_ingerrinj_excess_tok_ctrl==1 && cmd_type==BAT_T_CMD ) ||
            (hqmproc_ingerrinj_excess_tok_ctrl==3 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_tok_rate) && (cmd_type==BAT_T_CMD || cmd_type==COMP_T_CMD) ) ||
            (hqmproc_ingerrinj_excess_tok_ctrl==5 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_tok_rate) && (cmd_type==COMP_T_CMD || cmd_type==NEW_T_CMD || cmd_type==RENQ_T_CMD || cmd_type==FRAG_T_CMD) )
           ) begin 
              if(has_rels_on) send_hcw_loop=3;
              else            send_hcw_loop=2;
             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_EXCESS_TOK: %s PP %0d index=%0d hqmproc_ingerrinj_excess_tok_rand=%0d hqmproc_ingerrinj_excess_tok_ctrl=%0d hqmproc_ingerrinj_excess_tok_rate=%0d (inject excess token with 2nd BAT_T cmd) send_hcw=%0d cmd_type=%s cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; send_hcw_loop=%0d;; total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_ingerrinj_excess_tok_rand, hqmproc_ingerrinj_excess_tok_ctrl, hqmproc_ingerrinj_excess_tok_rate, send_hcw,cmd_type.name(),cq_token_return,is_ordered,is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last, send_hcw_loop, total_genenq_count, total_tok_return_count, total_comp_return_count),UVM_MEDIUM)
         end 

         //-------------------------------
         //-- EXCESS_CMP this is to support excess comp return 
         //-- hqmproc_ingerrinj_excess_cmp_ctrl=3 (inject excess completion in 2nd COMP cmd after sending COMP/COMP_T, and issue multiple times, rand based one _rate)
         //--
         //-- hqmproc_ingerrinj_excess_cmp_ctrl=5 (inject excess completion after sending a RENQ or RENQ_T, and issue multiple times, rand based one _rate)
         //-- hqmproc_ingerrinj_excess_cmp_ctrl=6 (inject excess completion when sending NEW or BAT_T, and issue multiple times, rand based one _rate)
         //-------------------------------
         if(hqmproc_ingerrinj_excess_cmp_rand==1) begin
            hqmproc_ingerrinj_excess_cmp_ctrl = $urandom_range(3,4);
         end else if(hqmproc_ingerrinj_excess_cmp_rand==2) begin
            hqmproc_ingerrinj_excess_cmp_ctrl = $urandom_range(5,6);
         end else if(hqmproc_ingerrinj_excess_cmp_rand==3) begin
            hqmproc_ingerrinj_excess_cmp_ctrl = $urandom_range(3,6);
         end 

         has_ingerrinj_isolate1 = 0;
         saved_cmd_type=cmd_type;

         //--excess_cmp
         if((hqmproc_ingerrinj_excess_cmp_ctrl == 3  && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate) && (cmd_type==COMP_T_CMD || cmd_type==COMP_CMD) ) ||
            (hqmproc_ingerrinj_excess_cmp_ctrl == 5  && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate) && (cmd_type==RENQ_T_CMD || cmd_type==RENQ_CMD) ) || 
            (hqmproc_ingerrinj_excess_cmp_ctrl == 10 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate) && (cmd_type==COMP_T_CMD || cmd_type==COMP_CMD) ) ||
            (hqmproc_ingerrinj_excess_cmp_ctrl == 11 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate) && (cmd_type==COMP_T_CMD || cmd_type==COMP_CMD) ) ||
            (hqmproc_ingerrinj_excess_cmp_ctrl == 12 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate) && (cmd_type==COMP_T_CMD || cmd_type==COMP_CMD) ) ||
            (hqmproc_ingerrinj_excess_cmp_ctrl == 13 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate) && (cmd_type==COMP_T_CMD || cmd_type==COMP_CMD) ) 
           ) begin
              if(has_rels_on) send_hcw_loop=hqmproc_ingerrinj_excess_cmp_num+1;
              else            send_hcw_loop=hqmproc_ingerrinj_excess_cmp_num;
             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_EXCESS_CMP: %s PP %0d index=%0d hqmproc_ingerrinj_excess_cmp_rand=%0d hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_cmp_rate=%0d (inject excess comp with 2nd COMP cmd) send_hcw=%0d cmd_type=%s cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; strenq_cnt=%0d strenq_num=%0d;; send_hcw_loop=%0d;; total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_ingerrinj_excess_cmp_rand, hqmproc_ingerrinj_excess_cmp_rate, hqmproc_ingerrinj_excess_cmp_ctrl, send_hcw,cmd_type.name(),cq_token_return,is_ordered,is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last, strenq_cnt, strenq_num, send_hcw_loop, total_genenq_count, total_tok_return_count, total_comp_return_count),UVM_MEDIUM)
         end 
	 
         if((hqmproc_ingerrinj_excess_cmp_ctrl == 18 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate) && (cmd_type==RENQ_T_CMD || cmd_type==RENQ_CMD) && hqmproc_stream_ctrl==2 && (strenq_cnt==strenq_num)) || 
            (hqmproc_ingerrinj_excess_cmp_ctrl == 19 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate) && (cmd_type==RENQ_T_CMD || cmd_type==RENQ_CMD) && hqmproc_stream_ctrl==2 && (strenq_cnt==strenq_num))  
           ) begin
              has_ingerrinj_isolate1 = 1;
              if(has_rels_on) send_hcw_loop=hqmproc_ingerrinj_excess_cmp_num+1;
              else            send_hcw_loop=hqmproc_ingerrinj_excess_cmp_num;
             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_EXCESS_CMP_ISO1: %s PP %0d index=%0d hqmproc_ingerrinj_excess_cmp_rand=%0d hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_cmp_rate=%0d (inject excess comp with 2nd COMP cmd) send_hcw=%0d cmd_type=%s cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; strenq_cnt=%0d strenq_num=%0d;; send_hcw_loop=%0d;; total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_ingerrinj_excess_cmp_rand, hqmproc_ingerrinj_excess_cmp_rate, hqmproc_ingerrinj_excess_cmp_ctrl, send_hcw,cmd_type.name(),cq_token_return,is_ordered,is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last, strenq_cnt, strenq_num, send_hcw_loop, total_genenq_count, total_tok_return_count, total_comp_return_count),UVM_MEDIUM)
         end 
	 
         
         //--excess_a_cmp
         if((hqmproc_ingerrinj_excess_a_cmp_ctrl == 1  && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_a_cmp_rate) && cmd_type==A_COMP_CMD ) ||
            (hqmproc_ingerrinj_excess_a_cmp_ctrl == 2  && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_a_cmp_rate) && cmd_type==A_COMP_T_CMD ) || 
            (hqmproc_ingerrinj_excess_a_cmp_ctrl == 3  && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_a_cmp_rate) && (cmd_type==A_COMP_T_CMD || cmd_type==A_COMP_CMD) )  
           ) begin
              send_hcw_loop=hqmproc_ingerrinj_excess_a_cmp_num;
             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_EXCESS_A_CMP: %s PP %0d index=%0d hqmproc_ingerrinj_excess_a_cmp_rand=%0d hqmproc_ingerrinj_excess_a_cmp_ctrl=%0d hqmproc_ingerrinj_excess_a_cmp_rate=%0d (inject excess A_COMP) send_hcw=%0d cmd_type=%s cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; strenq_cnt=%0d strenq_num=%0d;; send_hcw_loop=%0d;; total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d total_a_comp_return_count=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_ingerrinj_excess_a_cmp_rand, hqmproc_ingerrinj_excess_a_cmp_rate, hqmproc_ingerrinj_excess_a_cmp_ctrl, send_hcw,cmd_type.name(),cq_token_return,is_ordered,is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last, strenq_cnt, strenq_num, send_hcw_loop, total_genenq_count, total_tok_return_count, total_comp_return_count, total_a_comp_return_count),UVM_MEDIUM)
         end 
	 


         //--ORDFLOW FRAG/FRAG_T case
         if(((hqmproc_ingerrinj_excess_cmp_ctrl == 18 || hqmproc_ingerrinj_excess_cmp_ctrl == 19) && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate) && (cmd_type==FRAG_T_CMD || cmd_type==FRAG_CMD) && (curr_frag_cnt==curr_frag_num)) || 
            ((hqmproc_ingerrinj_excess_cmp_ctrl == 18 || hqmproc_ingerrinj_excess_cmp_ctrl == 19) && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate) && (cmd_type==RENQ_T_CMD || cmd_type==RENQ_CMD) && (curr_frag_cnt==curr_frag_num) && hqmproc_stream_ctrl!=2) 
           ) begin
              has_ingerrinj_isolate1 = 1;
              send_hcw_loop=hqmproc_ingerrinj_excess_cmp_num;
             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_EXCESS_CMP_FRAGISO1: %s PP %0d index=%0d hqmproc_ingerrinj_excess_cmp_rand=%0d hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_cmp_rate=%0d (inject excess comp with 2nd COMP cmd) send_hcw=%0d cmd_type=%s cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; strenq_cnt=%0d strenq_num=%0d;; send_hcw_loop=%0d;; total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_ingerrinj_excess_cmp_rand, hqmproc_ingerrinj_excess_cmp_rate, hqmproc_ingerrinj_excess_cmp_ctrl, send_hcw,cmd_type.name(),cq_token_return,is_ordered,is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last, strenq_cnt, strenq_num, send_hcw_loop, total_genenq_count, total_tok_return_count, total_comp_return_count),UVM_MEDIUM)
         end 

         //-------------------------------	 
         //-- CMPID_ERRINJ this is to support cmp_id error injection. 
         //-------------------------------
         if(hqmproc_ingerrinj_cmpid_rand==1) hqmproc_ingerrinj_cmpid_ctrl = $urandom_range(1, 2);
         if(hqmproc_ingerrinj_cmpid_ctrl == 1 && ($urandom_range(99,0) < hqmproc_ingerrinj_cmpid_rate) && (cmd_type==RENQ_T_CMD || cmd_type==RENQ_CMD) ) begin
              send_hcw_loop=2;
              has_ingerrinj_cmpid = 1;
         end else if(hqmproc_ingerrinj_cmpid_ctrl == 2 && ($urandom_range(99,0) < hqmproc_ingerrinj_cmpid_rate) && (cmd_type==COMP_CMD || cmd_type==COMP_T_CMD) ) begin
              send_hcw_loop=2;
              has_ingerrinj_cmpid = 1;
         end 	 
         if(has_ingerrinj_cmpid==1) begin
             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_ERRINJ_CMPID: %s PP %0d index=%0d hqmproc_ingerrinj_excess_cmp_rand=%0d hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_cmp_rate=%0d (inject cmp_id to 1st HCW and send a comp as 2nd HCW) send_hcw=%0d cmd_type=%s cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; send_hcw_loop=%0d;; total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_ingerrinj_excess_cmp_rand, hqmproc_ingerrinj_excess_cmp_rate, hqmproc_ingerrinj_excess_cmp_ctrl, send_hcw,cmd_type.name(),cq_token_return,is_ordered,is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last, send_hcw_loop, total_genenq_count, total_tok_return_count, total_comp_return_count),UVM_MEDIUM)
         end 

         //-------------------------------	 
         //-- COMP sending from dirPP: whole HCW is dropped 
         //-------------------------------
         if(hqmproc_ingerrinj_cmpdirpp_rand==1) hqmproc_ingerrinj_cmpdirpp_ctrl = $urandom_range(1, 2);
         if(hqmproc_ingerrinj_cmpdirpp_ctrl == 1 && ($urandom_range(99,0) < hqmproc_ingerrinj_cmpdirpp_rate) && (cmd_type==RENQ_T_CMD || cmd_type==RENQ_CMD) ) begin
              send_hcw_loop=2;
              has_ingerrinj_cmpdirpp = 1;
         end else if(hqmproc_ingerrinj_cmpdirpp_ctrl == 2 && ($urandom_range(99,0) < hqmproc_ingerrinj_cmpdirpp_rate) && (cmd_type==COMP_CMD || cmd_type==COMP_T_CMD) ) begin
              send_hcw_loop=2;
              has_ingerrinj_cmpdirpp = 1;
         end else begin
              has_ingerrinj_cmpdirpp = 0;
         end	 
         if(has_ingerrinj_cmpdirpp==1) begin
             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen1_ERRINJ_CMPDIRPP: %s PP %0d index=%0d hqmproc_ingerrinj_excess_cmp_rand=%0d hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_cmp_rate=%0d (inject err to 1st HCW and send 2nd good HCW) send_hcw=%0d cmd_type=%s cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; send_hcw_loop=%0d;; total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_ingerrinj_excess_cmp_rand, hqmproc_ingerrinj_excess_cmp_rate, hqmproc_ingerrinj_excess_cmp_ctrl, send_hcw,cmd_type.name(),cq_token_return,is_ordered,is_reorded, curr_frag_num, curr_frag_cnt, curr_frag_last, send_hcw_loop, total_genenq_count, total_tok_return_count, total_comp_return_count),UVM_MEDIUM)
         end 
      end 


      //-----------------------------------------------------------------------------------------------------------------------------------------
      //-----------------------------------------------------------------------------------------------------------------------------------------
      //-----------------------------------------------------------------------------------------------------------------------------------------
      //-----------------------------------------------------------------------------------------------------------------------------------------
      if (send_hcw) begin
         for(int idx=0; idx<send_hcw_loop; idx++) begin   

            `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBU_TrfGen",$psprintf("TrfGen1_Loop%0d_In_%0d: %s PP 0x%0x cmd_type=%0s (saved_cmd_type=%0s)HCW Generation pend_hcw_trans.size=%0d; hqmproc_rels_ctrl=%0d hqmproc_ingerrinj_ingress_drop=%0d hqmproc_ingerrinj_excess_tok_ctrl=%0d hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_a_cmp_ctrl=%0d has_ingerrinj_isolate1=%0d;; strenq_cnt=%0d strenq_num=%0d", idx, send_hcw_loop, (pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cmd_type.name(), saved_cmd_type.name(), pend_hcw_trans.size(),  hqmproc_rels_ctrl, hqmproc_ingerrinj_ingress_drop,  hqmproc_ingerrinj_excess_tok_ctrl, hqmproc_ingerrinj_excess_cmp_ctrl, hqmproc_ingerrinj_excess_a_cmp_ctrl, has_ingerrinj_isolate1, strenq_cnt, strenq_num) ,UVM_MEDIUM)

            if(has_ingerrinj_isolate1==1) begin
                //-------------------------------------
                //-- isolation1 errinj case when issue last RENQ/RENQ_T in the streaming
                //-- COMP   + RENQ/RENQ_T + RELS
                //-- COMP_T + RENQ/RENQ_T + RELS
                //-- *send RELS  (if rels is on)
                //-------------------------------------
                if(hqmproc_rels_ctrl==1) begin
                    if(idx==0) begin
                      cmd_type  = (hqmproc_ingerrinj_excess_cmp_ctrl==18)? COMP_CMD : COMP_T_CMD;	    

                    end else if(idx==1) begin
                      cmd_type  = saved_cmd_type;
                      hcw_nodec = 1'b1;           
                      i_hqm_pp_cq_status.enq_nodec_count[hqmproc_rel_qid]++;  
                    end else begin
                      hcw_nodec = 1'b0;           
                      cmd_type=RELS_CMD;	    
                    end 
                end else begin
                    if(idx>=0 && idx<(send_hcw_loop-1)) begin
                      cmd_type  = (hqmproc_ingerrinj_excess_cmp_ctrl==18)? COMP_CMD : COMP_T_CMD;	    
                    end else if(idx==(send_hcw_loop-1)) begin
                      cmd_type  = saved_cmd_type;
                    end 
                end 
            end else begin
                //-------------------------------------
                //-- regular case and non-isolation1 errinj case
                //-------------------------------------
                //-- support RELS_CMD, hcw_nodec
                if(hqmproc_rels_ctrl==1 ) begin
                   if((cmd_type==RENQ_CMD || cmd_type==RENQ_T_CMD) && idx==0) begin
                      hcw_nodec = 1'b1;           
                      i_hqm_pp_cq_status.enq_nodec_count[hqmproc_rel_qid]++;  
                   end else begin
                      hcw_nodec = 1'b0;           
                   end 
                end //--if(hqmproc_rels_ctrl==1

                //-- support RELS_CMD, the 2nd cmd in the loop
                if(has_unexp_rels_on==1 && idx>0) begin 
                     cmd_type=RELS_CMD;	    
                end else if(has_rels_on==1 && idx==1) begin
                     cmd_type=RELS_CMD;	    
                end 
            end 
	    	    	    
            ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBU_TrfGen",$psprintf("DEBUGGEN_1: %s PP 0x%0x cmd_type=%0s HCW Generation pend_hcw_trans.size=%0d, idx=%0d/send_hcw_loop=%0d has_rels_on=%0d has_unexp_rels_on=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cmd_type.name(), pend_hcw_trans.size(), idx, send_hcw_loop, has_rels_on, has_unexp_rels_on) ,UVM_MEDIUM)

            //--excess_token hqmproc_ingerrinj_excess_tok_ctrl=3 or 5 : the 2nd cmd in the loop
            if((hqmproc_ingerrinj_excess_tok_ctrl==3 || hqmproc_ingerrinj_excess_tok_ctrl==5) && idx>0) begin
                if(has_rels_on==1) begin
                  if(idx>1) cmd_type=BAT_T_CMD;
                end else begin 
                  cmd_type=BAT_T_CMD;
                end 
            end 

            //--excess_completion and/or token hqmproc_ingerrinj_excess_cmp_ctrl=10/11/12/13 
            //-- 10: COMP_CMD + COMP_T_CMD/COMP_CMD
            //-- 11: COMP_T_CMD + COMP_T_CMD/COMP_CMD
            //-- 12: COMP_CMD + COMP_T_CMD + COMP_T_CMD/COMP_CMD
            //-- 13: COMP_T_CMD + COMP_T_CMD + COMP_T_CMD/COMP_CMD
            if((hqmproc_ingerrinj_excess_cmp_ctrl>=10 && hqmproc_ingerrinj_excess_cmp_ctrl<17) && (saved_cmd_type == COMP_CMD || saved_cmd_type == COMP_T_CMD)) begin
                 if(hqmproc_ingerrinj_excess_cmp_ctrl==10) begin
                    if(idx==0) cmd_type = COMP_CMD;
                    else       cmd_type = saved_cmd_type; 
                 end else if(hqmproc_ingerrinj_excess_cmp_ctrl==11) begin
                    if(idx==0) cmd_type = COMP_T_CMD;
                    else       cmd_type = saved_cmd_type; 
                 end else if(hqmproc_ingerrinj_excess_cmp_ctrl==12) begin
                    if(idx==0)      cmd_type = COMP_CMD;
                    else if(idx==1) cmd_type = COMP_T_CMD;
                    else            cmd_type = saved_cmd_type; 
                 end else if(hqmproc_ingerrinj_excess_cmp_ctrl==13) begin
                    if(idx==0)      cmd_type = COMP_T_CMD;
                    else if(idx==1) cmd_type = COMP_T_CMD;
                    else            cmd_type = saved_cmd_type; 
                 end 
            end 

           
            //--excess_completion hqmproc_ingerrinj_excess_cmp_ctrl=3 or 5 : the 2nd cmd in the loop
            if((hqmproc_ingerrinj_excess_cmp_ctrl==3 || hqmproc_ingerrinj_excess_cmp_ctrl==5) && idx>0) begin
                if(has_rels_on==1) begin
                  if(idx>1) cmd_type=COMP_CMD;
                end else begin 
                  cmd_type=COMP_CMD;
                end 
            end 
           
            //--cmp_id errinj : the 2nd cmd in the loop
            if(hqmproc_ingerrinj_cmpid_ctrl>0 && has_ingerrinj_cmpid==1 && idx>0) begin
                cmd_type=COMP_CMD;
            end 
           
            //--cmp sending from dirPP errinj :1st one send from dirPP with any from renq/renq_t/comp/comp_t, this will be dropped. (using COMP_CMD to cheat)
            //--                              :2nd cmd is to redo a good HCW renq/renq_t/comp/comp_t  
            if(hqmproc_ingerrinj_cmpdirpp_ctrl>0 && has_ingerrinj_cmpdirpp==1) begin
                if(idx==0) begin
                   saved_cmd_type=cmd_type;
                   cmd_type=COMP_CMD; 
                end else begin
                   cmd_type=saved_cmd_type; 
                end 
            end 
           
            ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBU_TrfGen",$psprintf("DEBUGGEN_2: %s PP 0x%0x cmd_type=%0s (saved_cmd_type=%0s) HCW Generation pend_hcw_trans.size=%0d, idx=%0d/send_hcw_loop=%0d has_rels_on=%0d hqmproc_ingerrinj_excess_tok_ctrl=%0d hqmproc_ingerrinj_excess_cmp_ctrl=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cmd_type.name(), saved_cmd_type.name(), pend_hcw_trans.size(), idx, send_hcw_loop, has_rels_on, hqmproc_ingerrinj_excess_tok_ctrl, hqmproc_ingerrinj_excess_cmp_ctrl) ,UVM_MEDIUM)

            //-------------------------------------------------------------------------------------
            //-------------------------------------------------------------------------------------
            //--------------------------
            //-- create hcw_trans
            //--------------------------

            `uvm_create(hcw_trans)

            hcw_trans.randomize();
            hcw_trans.rsvd0               = hcw_rsvd0_random ? $urandom_range(0,7) : '0;
            hcw_trans.dsi_error           = '0;
            hcw_trans.no_inflcnt_dec      = hcw_nodec; //'0;
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
            hcw_trans.is_ord              = '0;
            hcw_trans.ordqid              = '0;
            hcw_trans.ordpri              = '0;
            hcw_trans.ordlockid           = '0;
            hcw_trans.ordidx              = '0;
            hcw_trans.reord               = '0;
            hcw_trans.frg_cnt             = '0;
            hcw_trans.frg_last            = '0;
            hcw_trans.is_ldb              = pp_cq_type == IS_LDB;
            hcw_trans.ppid                = pp_cq_num;
            hcw_trans.meas                = 0;
            hcw_trans.randomize(wu) with {
                                            wu >= hcw_enqueue_wu_min;
                                            wu <= hcw_enqueue_wu_max;
                                	 };
            hcw_trans.msgtype             = 0;

            //-- hqmproc select qid/qpri/qtype/lockid
            hcw_trans.qtype               = hcw_qtype_use; //qtype_genval;  
            hcw_trans.qid                 = hcw_qid_use;   //qid_genval;    
            hcw_trans.lockid              = lockid_genval; 

            is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(hcw_trans.qid); 
            if(is_ao_cfg_v && hqmproc_qpri_sel_mode==10) begin
               if(hcw_trans.qtype == QORD) hcw_trans.qpri = 7;	
               else hcw_trans.qpri = qpri_genval;
            end else if(hqmproc_qpri_sel_mode==0)  begin		
               hcw_trans.randomize(qpri) with {qpri dist {0 := queue_list[queue_list_index].qpri_weight[0], 
                                                       1 := queue_list[queue_list_index].qpri_weight[1], 
                                                       2 := queue_list[queue_list_index].qpri_weight[2], 
                                                       3 := queue_list[queue_list_index].qpri_weight[3], 
                                                       4 := queue_list[queue_list_index].qpri_weight[4], 
                                                       5 := queue_list[queue_list_index].qpri_weight[5], 
                                                       6 := queue_list[queue_list_index].qpri_weight[6], 
                                                       7 := queue_list[queue_list_index].qpri_weight[7]};
                                              }; 
            end else begin
               hcw_trans.qpri = qpri_genval;						  
            end	


            hcw_trans.is_nm_pf            = queue_list[queue_list_index].is_nm_pf;

            if (hcw_trans.qtype != QATM) begin
              pp_port=0;
              pp_port[7]   = hcw_trans.is_ldb;
              pp_port[6:0] = hcw_trans.ppid;
              //-- for QORD: use lockid[7:0] to carry original {is_ldb, ppid} info
              if(hcw_trans.qtype == QORD)   hcw_trans.lockid   = {1'b1, 7'b0, pp_port};
              else                          hcw_trans.lockid   = $urandom_range(32'hffffffff,32'h0);
              //--for debug usage  hcw_trans.lockid            = total_uno_genenq_count; //$urandom_range(32'hffffffff,32'h0);
            end 

            //-- tbcnt set here
            hcw_trans.tbcnt               = hcw_trans.get_transaction_id() + tbcnt_base + queue_list[queue_list_index].tbcnt_offset;
            hcw_tbcnt_use = hcw_trans.tbcnt;

            if(queue_list[queue_list_index].inc_lock_id) begin
              queue_list[queue_list_index].lock_id++;
            end 

            do_hcw_delay = ~queue_list[queue_list_index].hcw_delay_qe_only;

            //--meas part of control
            if(hqmproc_meas_rand)  has_meas_on = $urandom_range(0,3);
            else                   has_meas_on = 1;    
            if(hqmproc_meas_enable==1 && has_meas_on==1) begin
                hcw_trans.meas                = 1;

                if(hqmproc_idsi_ctrl==1)      hcw_trans.idsi = $realtime/1ns; 
                else if(hqmproc_idsi_ctrl==2) hcw_trans.idsi = hcw_tbcnt_use; 
                else if(hqmproc_idsi_ctrl==3) hcw_trans.idsi = 16'hffff - hcw_tbcnt_use; 
                else                          hcw_trans.idsi = 0;   
            end else begin
                //--	
                hcw_trans.idsi                = queue_list[queue_list_index].dsi;
                if (hcw_trans.qtype != QDIR) begin
                   hcw_trans.idsi             = $urandom_range(32'hffffffff,32'h0);
                end 
            end 

            ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBU_TrfGen",$psprintf("DEBUGGEN_3: %s PP 0x%0x cmd_type=%0s HCW Generation pend_hcw_trans.size=%0d, idx=%0d/send_hcw_loop=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, cmd_type.name(), pend_hcw_trans.size(), idx, send_hcw_loop) ,UVM_MEDIUM)

            //-------------------------------------------------------------------------------------
            //-------------------------------------------------------------------------------------
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

                if(has_trfenq_enable==2) begin
                   //--excess token when doing vasreset returns  BAT_T cmd
        	   hcw_trans.lockid   = hqmproc_ingerrinj_excess_tok_num - 1;
        	   total_tok_return_count += hqmproc_ingerrinj_excess_tok_num;

        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("BAT_T HCW returning 0x%0x excess tokens to %s CQ 0x%0x, when has_trfenq_enable=%0d",hqmproc_ingerrinj_excess_tok_num,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, has_trfenq_enable), UVM_MEDIUM)


                end if((hqmproc_ingerrinj_excess_tok_ctrl==1 || hqmproc_ingerrinj_excess_tok_ctrl==3 || hqmproc_ingerrinj_excess_tok_ctrl==5) && idx>0) begin
                   //--excess token in 2nd BAT_T cmd
        	   hcw_trans.lockid   = hqmproc_ingerrinj_excess_tok_num - 1;
        	   total_tok_return_count += hqmproc_ingerrinj_excess_tok_num;

                   if(hqmproc_ingerrinj_excess_tok_ctrl==1)  hqmproc_ingerrinj_excess_tok_ctrl=0; //--inject excess token once
        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("BAT_T HCW returning 0x%0x excess tokens to %s CQ 0x%0x, hqmproc_ingerrinj_excess_tok_ctrl=%0d hqmproc_ingerrinj_excess_tok_rate=%0d",hqmproc_ingerrinj_excess_tok_num,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_tok_ctrl, hqmproc_ingerrinj_excess_tok_rate), UVM_MEDIUM)


                end else if(hqmproc_ingerrinj_excess_tok_ctrl==2 || (hqmproc_ingerrinj_excess_tok_ctrl==4 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_tok_rate))) begin
                   //--excess token in one cmd
        	   hcw_trans.lockid   = cq_token_return - 1 + hqmproc_ingerrinj_excess_tok_num;
        	   total_tok_return_count += cq_token_return + hqmproc_ingerrinj_excess_tok_num;
                   if(hqmproc_ingerrinj_excess_tok_ctrl==1)  hqmproc_ingerrinj_excess_tok_ctrl=0; //--inject excess token once

        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("BAT_T HCW returning 0x%0x excess tokens to %s CQ 0x%0x, hqmproc_ingerrinj_excess_tok_ctrl=%0d hqmproc_ingerrinj_excess_tok_rate=%0d ",(cq_token_return+hqmproc_ingerrinj_excess_tok_num),(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_tok_ctrl, hqmproc_ingerrinj_excess_tok_rate),UVM_MEDIUM)
                end else begin  
                   //--regular
        	   hcw_trans.lockid   = cq_token_return - 1;
        	   total_tok_return_count += cq_token_return;
        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("BAT_T HCW returning 0x%0x tokens to %s CQ 0x%0x",cq_token_return,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_MEDIUM)
                end //--excess token   

                if(hqmproc_ingerrinj_excess_cmp_ctrl==4 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate)) begin
                   //--excess completion in one cmd
        	   hcw_trans.qe_uhl      = 1; 
        	   total_comp_return_count++;
        	   dta_comp_return_count++;
        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("BAT_T HCW returning excess completion to %s CQ 0x%0x, hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_cmp_rate=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_cmp_ctrl, hqmproc_ingerrinj_excess_cmp_rate), UVM_MEDIUM)
                end //--excess completion

              end //--BAT_T_CMD

              RELS_CMD:       begin
        	hcw_trans.qe_valid    = 0;
        	hcw_trans.qe_orsp     = 1;
        	hcw_trans.qe_uhl      = 0;
        	hcw_trans.cq_pop      = 0;
                hcw_trans.qtype       = hqmproc_rel_qtype;   
                hcw_trans.qid         = hqmproc_rel_qid;    	 
                i_hqm_pp_cq_status.enq_nodec_count[hqmproc_rel_qid]--;  
        	do_hcw_delay          = 1'b1;

        	if (queue_list[queue_list_index].hcw_time > 0) begin
        	  if (cycle_count >= queue_list[queue_list_index].hcw_time) begin
                    queue_list[queue_list_index].num_hcw = 0;
        	  end 
        	end else begin
        	  queue_list[queue_list_index].num_hcw--;
        	end 

        	`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("%s PP 0x%0x RELEASE HCW to QID 0x%0x QTYPE %s (tbcnt=0x%0x)",
                                                	 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                	 pp_cq_num,
                                                	 hcw_trans.qid,
                                                	 hcw_trans.qtype.name(),
                                                	 hcw_trans.tbcnt
                                                	) ,UVM_MEDIUM)		
              end //--RELS_CMD

              COMP_CMD, A_COMP_CMD:       begin
                //--has_excess_comp_inj
                if((hqmproc_ingerrinj_excess_cmp_ctrl==3 || hqmproc_ingerrinj_excess_cmp_ctrl==5  || (hqmproc_ingerrinj_excess_cmp_ctrl>=10 && hqmproc_ingerrinj_excess_cmp_ctrl<20)) && idx>0) begin
                   //--excess completion in 2nd cmd
                   has_excess_comp_inj=1;
        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("COMP HCW returning excess completion to %s CQ 0x%0x in a 2nd COMP, hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_cmp_rate=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_cmp_ctrl, hqmproc_ingerrinj_excess_cmp_rate), UVM_MEDIUM)

                end else if(has_ingerrinj_isolate1==1 && (hqmproc_ingerrinj_excess_cmp_ctrl>=18 && hqmproc_ingerrinj_excess_cmp_ctrl<20) && (saved_cmd_type==FRAG_CMD || saved_cmd_type==FRAG_T_CMD)) begin
                   //-- completion in 1st cmd of COMP, followed by FRAG/FRAG_T
                   has_excess_comp_inj=1;
        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("COMP HCW returning completion to %s CQ 0x%0x, hqmproc_ingerrinj_excess_cmp_ctrl=%0d has_ingerrinj_isolate1=%0d saved_cmd_type=%0s",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_cmp_ctrl, has_ingerrinj_isolate1, saved_cmd_type.name()), UVM_MEDIUM)

                end else if(hqmproc_ingerrinj_cmpid_ctrl>0 && has_ingerrinj_cmpid==1 && idx>0) begin
                   //-- for cmp_id errinj case, the 1st one (renq/renq_t/comp/comp_t) has inccredt cmp_id and so the completion is dropped by RTL; the 2nd one cmp_id is correct that RTL will take; 
                   has_excess_comp_inj=1;
                   has_ingerrinj_cmpid=0; //--clear has_ingerrinj_cmpid ctrl
                end else if(hqmproc_ingerrinj_cmpdirpp_ctrl>0 && has_ingerrinj_cmpdirpp==1) begin
                   //-- comp from dirpp, the 1st one (renq/renq_t/comp/comp_t) sending from dirPP, HCW is dropped by RTL; the 2nd one cmp_id is correct that RTL will take; 
                   if(idx==0) has_excess_comp_inj=1;
                   else       has_excess_comp_inj=0;   

                   if(idx>0)  has_ingerrinj_cmpdirpp=0; //--clear has_ingerrinj_cmpdirpp ctrl
                end else begin
                   has_excess_comp_inj=0;
                end 

                //--has_excess_a_comp_inj
                if((hqmproc_ingerrinj_excess_a_cmp_ctrl>0) && idx>0) begin
                   //--excess A_COMP completion in 2nd cmd
                   has_excess_a_comp_inj=1;
        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("COMP HCW returning excess A_COMP completion to %s CQ 0x%0x in a 2nd COMP, hqmproc_ingerrinj_excess_a_cmp_ctrl=%0d hqmproc_ingerrinj_excess_a_cmp_rate=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_a_cmp_ctrl, hqmproc_ingerrinj_excess_a_cmp_rate), UVM_MEDIUM)

                end 

                //--deal with COMP_CMD
                if(cmd_type==COMP_CMD) begin
                   if(has_excess_comp_inj==0 && has_trfenq_enable!=2) begin
        	      ////--HQMV25 hcw_trans_in          = pend_hcw_trans.pop_front();

                      //--HQMV30_AO or Regular case
                      hcw_trans_in          = pend_hcw_trans.pop_front();

                      if(is_ordered==1 || cmd_type_sel==1) begin 
            	         hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
                         hcw_trans.is_ord      = '1;
            	      end 
                      if(is_reorded==1) begin 
            	         hcw_trans.tbcnt     = hcw_tbcnt_use; //hcw_trans_in.tbcnt;
            	         hcw_trans.ordidx    = hcw_trans_in.tbcnt;  //ordqid is original 1st pass's tbcnt
            	         hcw_trans.ordqid    = hcw_trans_in.qid;    //ordqid is original 1st pass's qid
            	         hcw_trans.ordpri    = hcw_trans_in.qpri;   //ordqid is original 1st pass's qpri
            	         hcw_trans.ordlockid = hcw_trans_in.lockid; //ordqid is original 1st pass's lockid
            	         hcw_trans.reordidx  = hcw_tbcnt_use;       //reordidx is current tbcnt
            	         hcw_trans.reord     = 1;
            	         hcw_trans.frg_cnt   = curr_frag_cnt; 
            	         hcw_trans.frg_num   = curr_frag_num;
            	         hcw_trans.frg_last  = curr_frag_last;
            	      end 
    
                      hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
                      prev_cmp_id           = hcw_trans_in.cmp_id;
                   end else begin
                      hcw_trans.cmp_id      = prev_cmp_id;
                      hcw_trans.ingress_drop = hqmproc_ingerrinj_ingress_drop;
                   end //-- if(has_excess_comp_inj==0) 
                end //if(cmd_type==COMP_CMD)

                //--deal with A_COMP_CMD
                if(cmd_type==A_COMP_CMD) begin
                   if(has_excess_a_comp_inj==0 && has_trfenq_enable!=2) begin
                      //--HQMV30_AO 
                      hcw_trans_in          = pend_hcw_trans_comb.pop_front();
                  
                      if(is_ordered==1 || cmd_type_sel==1) begin 
            	         hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
                         hcw_trans.is_ord      = '1;
            	      end 
                      if(is_reorded==1) begin 
            	         hcw_trans.tbcnt     = hcw_tbcnt_use; //hcw_trans_in.tbcnt;
            	         hcw_trans.ordidx    = hcw_trans_in.tbcnt;  //ordqid is original 1st pass's tbcnt
            	         hcw_trans.ordqid    = hcw_trans_in.qid;    //ordqid is original 1st pass's qid
            	         hcw_trans.ordpri    = hcw_trans_in.qpri;   //ordqid is original 1st pass's qpri
            	         hcw_trans.ordlockid = hcw_trans_in.lockid; //ordqid is original 1st pass's lockid
            	         hcw_trans.reordidx  = hcw_tbcnt_use;       //reordidx is current tbcnt
            	         hcw_trans.reord     = 1;
            	         hcw_trans.frg_cnt   = curr_frag_cnt; 
            	         hcw_trans.frg_num   = curr_frag_num;
            	         hcw_trans.frg_last  = curr_frag_last;
            	      end 
    
                      hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
                      prev_cmp_id           = hcw_trans_in.cmp_id;
                   end else begin
                      hcw_trans.cmp_id      = prev_cmp_id;
                      hcw_trans.ingress_drop = hqmproc_ingerrinj_ingress_drop;
                   end //--if(has_excess_a_comp_inj==0 && has_trfenq_enable!=2) 
                end //if(cmd_type==A_COMP_CMD) 

                //-----------------
                if(cmd_type == COMP_CMD) begin
              	  hcw_trans.qe_valid    = 0;
            	  hcw_trans.qe_orsp     = 0;
                  hcw_trans.qe_uhl      = 1;
            	  total_comp_return_count++;
                  dta_comp_return_count++;
                end else begin
              	  hcw_trans.qe_valid    = 0;
            	  hcw_trans.qe_orsp     = 1; //--A_COMP_CMD
                  hcw_trans.qe_uhl      = 1;
            	  total_a_comp_return_count++;
                end 

                hcw_trans.cq_pop      = get_illegal_token_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);
            	if (hcw_trans.cq_pop) begin
            	      hcw_trans.lockid    = 0;
                      if(cmd_type == COMP_CMD)
            	        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("COMP_T HCW returning 1 token and a completion for %s PP 0x%0x",cq_token_return,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_MEDIUM)
                      else
            	        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("A_COMP_T HCW returning 1 token and a completion for %s PP 0x%0x",cq_token_return,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_MEDIUM)
            	end else begin
                    if(cmd_type == COMP_CMD)
            	     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("COMP HCW returning completion for %s PP 0x%0x",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_MEDIUM)
                    else
            	     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("A_COMP HCW returning completion for %s PP 0x%0x",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_MEDIUM)
            	end 
              end //--COMP_CMD


              COMP_T_CMD, A_COMP_T_CMD:     begin
                //--has_excess_comp_inj
                if((hqmproc_ingerrinj_excess_cmp_ctrl==3 || hqmproc_ingerrinj_excess_cmp_ctrl==5  || (hqmproc_ingerrinj_excess_cmp_ctrl>=10 && hqmproc_ingerrinj_excess_cmp_ctrl<17)) && idx>0) begin
                   //--excess completion in 2nd cmd
                   has_excess_comp_inj=1;
        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("COMP_T HCW returning excess completion to %s CQ 0x%0x in a 2nd COMP, hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_cmp_rate=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_cmp_ctrl, hqmproc_ingerrinj_excess_cmp_rate), UVM_MEDIUM)


                end else if(has_ingerrinj_isolate1==1 && (hqmproc_ingerrinj_excess_cmp_ctrl>=18 && hqmproc_ingerrinj_excess_cmp_ctrl<20) && (saved_cmd_type==FRAG_CMD || saved_cmd_type==FRAG_T_CMD)) begin
                   //-- completion in 1st cmd of COMP_T, followed by FRAG/FRAG_T
                   has_excess_comp_inj=1;
        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("COMP_T HCW returning completion to %s CQ 0x%0x, hqmproc_ingerrinj_excess_cmp_ctrl=%0d has_ingerrinj_isolate1=%0d saved_cmd_type=%0s",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_cmp_ctrl, has_ingerrinj_isolate1, saved_cmd_type.name()), UVM_MEDIUM)
                end else begin
                   has_excess_comp_inj=0;
                end 


                //--has_excess_a_comp_inj
                if((hqmproc_ingerrinj_excess_a_cmp_ctrl>0) && idx>0) begin
                   //--excess A_COMP completion in 2nd cmd
                   has_excess_a_comp_inj=1;
        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("A_COMP_T HCW returning excess A_COMP completion to %s CQ 0x%0x in a 2nd A_COMP, hqmproc_ingerrinj_excess_a_cmp_ctrl=%0d hqmproc_ingerrinj_excess_a_cmp_rate=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_a_cmp_ctrl, hqmproc_ingerrinj_excess_a_cmp_rate), UVM_MEDIUM)

                end 

                //--deal with COMP_T_CMD
                if(cmd_type==COMP_T_CMD) begin
                  if(has_excess_comp_inj==0 && has_trfenq_enable!=2) begin
        	   ////--HQMV25 hcw_trans_in          = pend_hcw_trans.pop_front();

                    //--HQMV30_AO "A_COMP_T+COMP_T"  or Regular case
                    hcw_trans_in          = pend_hcw_trans.pop_front();

                    if(is_ordered==1 || cmd_type_sel==1) begin 
            	       hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
                       hcw_trans.is_ord      = '1;
            	    end 
            	    if(is_reorded==1) begin 
            	       hcw_trans.tbcnt     = hcw_tbcnt_use; //hcw_trans_in.tbcnt;
            	       hcw_trans.ordidx    = hcw_trans_in.tbcnt;  //ordqid is original 1st pass's tbcnt
            	       hcw_trans.ordqid    = hcw_trans_in.qid;    //ordqid is original 1st pass's qid
            	       hcw_trans.ordpri    = hcw_trans_in.qpri;   //ordqid is original 1st pass's qpri
            	       hcw_trans.ordlockid = hcw_trans_in.lockid; //ordqid is original 1st pass's lockid
            	       hcw_trans.reordidx  = hcw_tbcnt_use;       //reordidx is current tbcnt
            	       hcw_trans.reord     = 1;
            	       hcw_trans.frg_cnt   = curr_frag_cnt; 
            	       hcw_trans.frg_num   = curr_frag_num;
            	       hcw_trans.frg_last  = curr_frag_last;
            	    end 
    
                    hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
            	    hcw_trans.qe_valid    = 0;
            	    hcw_trans.qe_orsp     = 0;
            	    hcw_trans.qe_uhl      = 1;
            	    total_comp_return_count++;
            	    dta_comp_return_count++;
                    hcw_trans.cq_pop      = 1;
    
                    if(hqmproc_ingerrinj_excess_tok_ctrl==4 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_tok_rate)) begin
            	        hcw_trans.lockid   = cq_token_return - 1 + hqmproc_ingerrinj_excess_tok_num;
            	        total_tok_return_count += cq_token_return + hqmproc_ingerrinj_excess_tok_num;
            	       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("COMP_T HCW returning 0x%0x excess tokens and a completion to %s CQ/PP 0x%0x, hqmproc_ingerrinj_excess_tok_ctrl=%0d hqmproc_ingerrinj_excess_tok_num=%0d", (cq_token_return+hqmproc_ingerrinj_excess_tok_num),(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_tok_ctrl, hqmproc_ingerrinj_excess_tok_rate),UVM_MEDIUM)
    
                    end else begin
                        hcw_trans.lockid      = cq_token_return - 1;
            	        total_tok_return_count += cq_token_return;
            	       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("COMP_T HCW returning 0x%0x tokens and a completion to %s CQ/PP 0x%0x",cq_token_return,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_MEDIUM)
                    end //
                end else begin
            	    hcw_trans.cmp_id      = 0;
        	    hcw_trans.qe_valid    = 0;
        	    hcw_trans.qe_orsp     = 0;
                    hcw_trans.qe_uhl      = 1;
                    hcw_trans.ingress_drop = hqmproc_ingerrinj_ingress_drop;
                    total_comp_return_count++;
                    dta_comp_return_count++;
        	    hcw_trans.cq_pop      = 1;
         	    hcw_trans.lockid      =  + hqmproc_ingerrinj_excess_tok_num;
            	    total_tok_return_count += hqmproc_ingerrinj_excess_tok_num;
            	    `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("COMP_T HCW returning 0x%0x excess tokens and a completion to %s CQ/PP 0x%0x, when has_trfenq_enable=%0d  hqmproc_ingerrinj_excess_tok_num=%0d hqmproc_ingerrinj_ingress_drop=%0d", (hqmproc_ingerrinj_excess_tok_num),(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,has_trfenq_enable,hqmproc_ingerrinj_excess_tok_num, hqmproc_ingerrinj_ingress_drop),UVM_MEDIUM)

                  end //if(has_excess_comp_inj==0 && has_trfenq_enable!=2) 
                end //if(cmd_type==COMP_T_CMD) 


                //--deal with A_COMP_T_CMD
                if(cmd_type==A_COMP_T_CMD) begin
                  if(has_excess_a_comp_inj==0 && has_trfenq_enable!=2) begin
                    hcw_trans_in          = pend_hcw_trans_comb.pop_front();

                    if(is_ordered==1 || cmd_type_sel==1) begin 
            	       hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
                       hcw_trans.is_ord      = '1;
            	    end 
            	    if(is_reorded==1) begin 
            	       hcw_trans.tbcnt     = hcw_tbcnt_use; //hcw_trans_in.tbcnt;
            	       hcw_trans.ordidx    = hcw_trans_in.tbcnt;  //ordqid is original 1st pass's tbcnt
            	       hcw_trans.ordqid    = hcw_trans_in.qid;    //ordqid is original 1st pass's qid
            	       hcw_trans.ordpri    = hcw_trans_in.qpri;   //ordqid is original 1st pass's qpri
            	       hcw_trans.ordlockid = hcw_trans_in.lockid; //ordqid is original 1st pass's lockid
            	       hcw_trans.reordidx  = hcw_tbcnt_use;       //reordidx is current tbcnt
            	       hcw_trans.reord     = 1;
            	       hcw_trans.frg_cnt   = curr_frag_cnt; 
            	       hcw_trans.frg_num   = curr_frag_num;
            	       hcw_trans.frg_last  = curr_frag_last;
            	    end 
    
                    hcw_trans.cmp_id      = hcw_trans_in.cmp_id;

            	    hcw_trans.qe_valid    = 0;
            	    hcw_trans.qe_orsp     = 1; //--A_COMP_T_CMD
            	    hcw_trans.qe_uhl      = 1;
            	    total_a_comp_return_count++;
            	    hcw_trans.cq_pop      = 1;
    
                    if(hqmproc_ingerrinj_excess_tok_ctrl==4 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_tok_rate)) begin
            	        hcw_trans.lockid   = cq_token_return - 1 + hqmproc_ingerrinj_excess_tok_num;
            	        total_tok_return_count += cq_token_return + hqmproc_ingerrinj_excess_tok_num;
                       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("A_COMP_T HCW returning 0x%0x excess tokens and A_COMP completion to %s CQ/PP 0x%0x, hqmproc_ingerrinj_excess_tok_ctrl=%0d hqmproc_ingerrinj_excess_tok_num=%0d", (cq_token_return+hqmproc_ingerrinj_excess_tok_num),(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_tok_ctrl, hqmproc_ingerrinj_excess_tok_rate),UVM_MEDIUM)
    
                    end else begin
                        hcw_trans.lockid      = cq_token_return - 1;
            	        total_tok_return_count += cq_token_return;
            	       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("A_COMP_T HCW returning 0x%0x tokens and a completion to %s CQ/PP 0x%0x",cq_token_return,(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num),UVM_MEDIUM)
                    end //
                end else begin
            	    hcw_trans.cmp_id      = 0;
        	    hcw_trans.qe_valid    = 0;
        	    hcw_trans.qe_orsp     = 1;
                    hcw_trans.qe_uhl      = 1;
                    hcw_trans.ingress_drop = hqmproc_ingerrinj_ingress_drop;
                    total_a_comp_return_count++;
        	    hcw_trans.cq_pop      = 1;
         	    hcw_trans.lockid      =  + hqmproc_ingerrinj_excess_tok_num;
            	    total_tok_return_count += hqmproc_ingerrinj_excess_tok_num;
            	    `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("A_COMP_T HCW returning 0x%0x excess tokens and A_COMP completion to %s CQ/PP 0x%0x, when has_trfenq_enable=%0d  hqmproc_ingerrinj_excess_tok_num=%0d hqmproc_ingerrinj_ingress_drop=%0d", (hqmproc_ingerrinj_excess_tok_num),(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num,has_trfenq_enable,hqmproc_ingerrinj_excess_tok_num, hqmproc_ingerrinj_ingress_drop),UVM_MEDIUM)
                  end //if(has_excess_a_comp_inj==0 && has_trfenq_enable!=2)
                end //if(cmd_type==A_COMP_T_CMD)

              end //--COMP_T_CMD

              NEW_CMD:        begin
        	hcw_trans.qe_valid    = 1;
        	hcw_trans.qe_orsp     = (hqmproc_frag_new_ctrl>0 && ($urandom_range(99,0)<hqmproc_frag_new_prob) && (pp_cq_type == IS_LDB))? 1 : 0;
        	hcw_trans.qe_uhl      = get_illegal_comp_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);
        	hcw_trans.cq_pop      = get_illegal_token_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);
        	total_genenq_count++;
        	if(hcw_trans.qtype==QATM) total_atm_genenq_count++;
        	if(hcw_trans.qtype==QUNO) total_uno_genenq_count++;
                cq_intr_enq_num --;
        	do_hcw_delay          = 1'b1;

        	if (queue_list[queue_list_index].hcw_time > 0) begin
        	  if (cycle_count >= queue_list[queue_list_index].hcw_time) begin
                    queue_list[queue_list_index].num_hcw = 0;
        	  end 
        	end else begin
        	  queue_list[queue_list_index].num_hcw--;
        	end 

        	`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("%s PP 0x%0x NEW HCW to QID 0x%0x QTYPE %s (tbcnt=0x%0x) wu=%0d",
                                                	 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                	 pp_cq_num,
                                                	 hcw_trans.qid,
                                                	 hcw_trans.qtype.name(),
                                                	 hcw_trans.tbcnt,
                                                	 hcw_trans.wu
                                                	) ,UVM_MEDIUM)
              end 
              NEW_T_CMD:      begin
        	hcw_trans.qe_valid    = 1;
        	hcw_trans.qe_orsp     = (hqmproc_frag_new_ctrl>0 && ($urandom_range(99,0)<hqmproc_frag_new_prob) && (pp_cq_type == IS_LDB))? 1 : 0;
        	hcw_trans.qe_uhl      = get_illegal_comp_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);
        	hcw_trans.cq_pop      = 1;
        	total_tok_return_count++;
        	total_genenq_count++;
        	if(hcw_trans.qtype==QATM) total_atm_genenq_count++;
        	if(hcw_trans.qtype==QUNO) total_uno_genenq_count++;
                cq_intr_enq_num --;

        	do_hcw_delay          = 1'b1;

        	if (queue_list[queue_list_index].hcw_time > 0) begin
        	  if (cycle_count >= queue_list[queue_list_index].hcw_time) begin
                    queue_list[queue_list_index].num_hcw = 0;
        	  end 
        	end else begin
        	  queue_list[queue_list_index].num_hcw--;
        	end 


        	`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("%s PP 0x%0x NEW HCW to QID 0x%0x QTYPE %s (tbcnt=0x%0x) wu=%0d, returning 1 token to %s CQ 0x%0x",
                                                	 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                	 pp_cq_num,
                                                	 hcw_trans.qid,
                                                	 hcw_trans.qtype.name(),
                                                	 hcw_trans.tbcnt,
                                                	 hcw_trans.wu,
                                                	 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                	 pp_cq_num
                                                	) ,UVM_MEDIUM)
              end 
              RENQ_CMD:       begin

                if(has_ingerrinj_isolate1==1 && (hqmproc_ingerrinj_excess_cmp_ctrl>=18 && hqmproc_ingerrinj_excess_cmp_ctrl<20) && idx>0) begin
                   //--excess completion in 2nd cmd of RENQ
                   has_excess_comp_inj=1;
        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("RENQ HCW returning excess completion to %s CQ 0x%0x in a 2nd RENQ cmd, hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_cmp_rate=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_cmp_ctrl, hqmproc_ingerrinj_excess_cmp_rate), UVM_MEDIUM)
                end else begin
                   has_excess_comp_inj=0;
                end 

                if(has_excess_comp_inj==0) begin
        	    ////--HQMV25 hcw_trans_in          = pend_hcw_trans.pop_front();

                    hcw_trans_in          = pend_hcw_trans.pop_front();

        	    if(is_ordered==1 || cmd_type_sel==1) begin 
        	      hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
                      hcw_trans.is_ord      = '1;
                    end 
        	    if(is_reorded==1) begin 
        	       hcw_trans.tbcnt     = hcw_tbcnt_use; //hcw_trans_in.tbcnt;
        	       hcw_trans.ordidx    = hcw_trans_in.tbcnt;  //ordqid is original 1st pass's tbcnt
        	       hcw_trans.ordqid    = hcw_trans_in.qid;    //ordqid is original 1st pass's qid
        	       hcw_trans.ordpri    = hcw_trans_in.qpri;   //ordqid is original 1st pass's qpri
        	       hcw_trans.ordlockid = hcw_trans_in.lockid; //ordqid is original 1st pass's lockid
        	       hcw_trans.reordidx  = hcw_tbcnt_use;       //reordidx is current tbcnt
        	       hcw_trans.reord     = 1;
        	       hcw_trans.frg_cnt   = curr_frag_cnt; 
        	       hcw_trans.frg_num   = curr_frag_num;
        	       hcw_trans.frg_last  = curr_frag_last;
        	       if(hcw_trans.frg_cnt>16) hcw_trans.ingress_drop=1;
        	       hcw_trans.ingress_comp_nodrop=1;  
                    end 
         	    hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
                end else begin
            	    hcw_trans.cmp_id      = 0;
                end 

        	hcw_trans.qe_valid    = 1;
        	hcw_trans.qe_orsp     = 0;
        	hcw_trans.qe_uhl      = 1;
        	total_comp_return_count++;
                dta_comp_return_count++;
        	total_genenq_count++;
        	if(hcw_trans.qtype==QATM) total_atm_genenq_count++;
        	if(hcw_trans.qtype==QUNO) total_uno_genenq_count++;
                cq_intr_enq_num --;
        	hcw_trans.cq_pop      = get_illegal_token_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);
        	do_hcw_delay          = 1'b1;

        	if (queue_list[queue_list_index].hcw_time > 0) begin
        	  if (cycle_count >= queue_list[queue_list_index].hcw_time) begin
                    queue_list[queue_list_index].num_hcw = 0;
        	  end 
        	end else begin
        	  queue_list[queue_list_index].num_hcw--;
        	end 

        	`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("%s PP 0x%0x RENQ HCW to QID 0x%0x QTYPE %s (is_ordered=%0d tbcnt=0x%0x) wu=%0d",
                                                	 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                	 pp_cq_num,
                                                	 hcw_trans.qid,
                                                	 hcw_trans.qtype.name(),
                                                	 is_ordered,
                                                	 hcw_trans.tbcnt,
                                                	 hcw_trans.wu
                                                	) ,UVM_MEDIUM)
              end 
              RENQ_T_CMD:     begin

               `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBU_TrfGen",$psprintf("%s PP 0x%0x RENQ_T HCW Generation pend_hcw_trans.size=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, pend_hcw_trans.size()) ,UVM_MEDIUM)

                if(has_ingerrinj_isolate1==1 && (hqmproc_ingerrinj_excess_cmp_ctrl>=18 && hqmproc_ingerrinj_excess_cmp_ctrl<20) && idx>0) begin
                   //--excess completion in 2nd cmd of RENQ
                   has_excess_comp_inj=1;
        	   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("RENQ_T HCW returning excess completion to %s CQ 0x%0x in a 2nd RENQ_T cmd, hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_cmp_rate=%0d",(pp_cq_type == IS_LDB) ? "LDB" : "DIR",pp_cq_num, hqmproc_ingerrinj_excess_cmp_ctrl, hqmproc_ingerrinj_excess_cmp_rate), UVM_MEDIUM)
                end else begin
                   has_excess_comp_inj=0;
                end 

                if(has_excess_comp_inj==0) begin
        	   ////--HQMV25 hcw_trans_in          = pend_hcw_trans.pop_front();

                   //--HQMV30_AO
                   hcw_trans_in          = pend_hcw_trans.pop_front();

        	   if(is_ordered==1 || cmd_type_sel==1) begin 
        	     hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
                     hcw_trans.is_ord      = '1;
        	   end 
        	   if(is_reorded==1) begin 
        	     hcw_trans.tbcnt     = hcw_tbcnt_use; //hcw_trans_in.tbcnt;
        	     hcw_trans.ordidx    = hcw_trans_in.tbcnt;  //ordqid is original 1st pass's tbcnt
        	     hcw_trans.ordqid    = hcw_trans_in.qid;    //ordqid is original 1st pass's qid
        	     hcw_trans.ordpri    = hcw_trans_in.qpri;   //ordqid is original 1st pass's qpri
        	     hcw_trans.ordlockid = hcw_trans_in.lockid; //ordqid is original 1st pass's lockid
        	     hcw_trans.reordidx  = hcw_tbcnt_use;       //reordidx is current tbcnt
        	     hcw_trans.reord     = 1;
        	     hcw_trans.frg_cnt   = curr_frag_cnt; 
        	     hcw_trans.frg_num   = curr_frag_num;
        	     hcw_trans.frg_last  = curr_frag_last;
        	     if(hcw_trans.frg_cnt>16) hcw_trans.ingress_drop=1;
        	     hcw_trans.ingress_comp_nodrop=1;  
        	   end 
        	   hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
                end else begin
        	   hcw_trans.cmp_id      = 0;
                end 

        	hcw_trans.qe_valid    = 1;
        	hcw_trans.qe_orsp     = 0;
        	hcw_trans.qe_uhl      = 1;
        	total_comp_return_count++;
		dta_comp_return_count++;
        	hcw_trans.cq_pop      = 1;
        	total_tok_return_count++;
        	total_genenq_count++;
        	if(hcw_trans.qtype==QATM) total_atm_genenq_count++;
        	if(hcw_trans.qtype==QUNO) total_uno_genenq_count++;
                cq_intr_enq_num --;
        	do_hcw_delay          = 1'b1;

        	if (queue_list[queue_list_index].hcw_time > 0) begin
        	  if (cycle_count >= queue_list[queue_list_index].hcw_time) begin
                    queue_list[queue_list_index].num_hcw = 0;
        	  end 
        	end else begin
        	  queue_list[queue_list_index].num_hcw--;
        	end 

        	`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBU_TrfGen",$psprintf("%s PP 0x%0x RENQ_T HCW to QID 0x%0x QTYPE %s (is_ordered=%0d tbcnt=0x%0x) wu=%0d, returning 1 token and 1 completion to %s CQ 0x%0x",
                                                	 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                	 pp_cq_num,
                                                	 hcw_trans.qid,
                                                	 hcw_trans.qtype.name(),
                                                	 is_ordered,   
                                                	 hcw_trans.tbcnt,
                                                	 hcw_trans.wu,
                                                	 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                	 pp_cq_num
                                                	) ,UVM_MEDIUM)
              end 

              FRAG_CMD:       begin
        	//hcw_trans_in          = pend_hcw_trans.pop_front();
                 hcw_trans_in          = pend_hcw_trans[pend_hcw_trans_idx];

        	if(is_ordered==1 || cmd_type_sel==1) begin 
        	  hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
                  hcw_trans.is_ord      = '1;
        	end 
        	if(is_reorded==1) begin 
        	  hcw_trans.tbcnt     = hcw_tbcnt_use; //hcw_trans_in.tbcnt;
        	  hcw_trans.ordidx    = hcw_trans_in.tbcnt;  //ordqid is original 1st pass's tbcnt
        	  hcw_trans.ordqid    = hcw_trans_in.qid;    //ordqid is original 1st pass's qid
        	  hcw_trans.ordpri    = hcw_trans_in.qpri;   //ordqid is original 1st pass's qpri
        	  hcw_trans.ordlockid = hcw_trans_in.lockid; //ordqid is original 1st pass's lockid
        	  hcw_trans.reordidx  = hcw_tbcnt_use;       //reordidx is current tbcnt
        	  hcw_trans.reord     = 1;
        	  hcw_trans.frg_cnt   = curr_frag_cnt; 
        	  hcw_trans.frg_num   = curr_frag_num;
        	  hcw_trans.frg_last  = curr_frag_last;
        	  if(hcw_trans.frg_cnt>16) hcw_trans.ingress_drop=1;
        	end 
        	hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
        	hcw_trans.qe_valid    = 1;
        	hcw_trans.qe_orsp     = 1;
        	hcw_trans.qe_uhl      = 0; 
        	total_genenq_count++;
        	if(hcw_trans.qtype==QATM) total_atm_genenq_count++;
        	if(hcw_trans.qtype==QUNO) total_uno_genenq_count++;
                cq_intr_enq_num --;
        	hcw_trans.cq_pop      = get_illegal_token_check(queue_list_index,illegal_hcw_burst_start_num,queue_list[queue_list_index].num_hcw);
        	do_hcw_delay          = 1'b1;

        	if (queue_list[queue_list_index].hcw_time > 0) begin
        	  if (cycle_count >= queue_list[queue_list_index].hcw_time) begin
                    queue_list[queue_list_index].num_hcw = 0;
        	  end 
        	end else begin
        	  queue_list[queue_list_index].num_hcw--;
        	end 

        	`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("%s PP 0x%0x FRAG HCW to QID 0x%0x QTYPE %s (is_ordered=%0d tbcnt=0x%0x) (is_reorded=%0d ordidx=0x%0x ordqid=0x%0x) pend_hcw_trans.size=%0d wu=%0d ingress_drop=%0d",
                                                	 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                	 pp_cq_num,
                                                	 hcw_trans.qid,
                                                	 hcw_trans.qtype.name(),
                                                	 is_ordered,
                                                	 hcw_trans.tbcnt,
                                                	 is_reorded,   
                                                	 hcw_trans.ordidx,
                                                	 hcw_trans.ordqid,
                                                         pend_hcw_trans.size(),
                                                	 hcw_trans.wu,
                                                	 hcw_trans.ingress_drop   
                                                	) ,UVM_MEDIUM)
              end 
              FRAG_T_CMD:     begin
        	//hcw_trans_in          = pend_hcw_trans.pop_front();
        	hcw_trans_in          = pend_hcw_trans[0];

        	if(is_ordered==1 || cmd_type_sel==1) begin 
        	  hcw_trans.tbcnt       = hcw_trans_in.tbcnt;
                  hcw_trans.is_ord      = '1;
        	end 
        	if(is_reorded==1) begin 
        	  hcw_trans.tbcnt     = hcw_tbcnt_use; //hcw_trans_in.tbcnt;
        	  hcw_trans.ordidx    = hcw_trans_in.tbcnt;  //ordqid is original 1st pass's tbcnt
        	  hcw_trans.ordqid    = hcw_trans_in.qid;    //ordqid is original 1st pass's qid
        	  hcw_trans.ordpri    = hcw_trans_in.qpri;   //ordqid is original 1st pass's qpri
        	  hcw_trans.ordlockid = hcw_trans_in.lockid; //ordqid is original 1st pass's lockid
        	  hcw_trans.reordidx  = hcw_tbcnt_use;       //reordidx is current tbcnt
        	  hcw_trans.reord     = 1;
        	  hcw_trans.frg_cnt   = curr_frag_cnt; 
        	  hcw_trans.frg_num   = curr_frag_num;
        	  hcw_trans.frg_last  = curr_frag_last;
        	  if(hcw_trans.frg_cnt>16) hcw_trans.ingress_drop=1;
        	end 
        	hcw_trans.cmp_id      = hcw_trans_in.cmp_id;
        	hcw_trans.qe_valid    = 1;
        	hcw_trans.qe_orsp     = 1;
        	hcw_trans.qe_uhl      = 0; 
        	hcw_trans.cq_pop      = 1;
        	total_tok_return_count++;
        	total_genenq_count++;
        	if(hcw_trans.qtype==QATM) total_atm_genenq_count++;
        	if(hcw_trans.qtype==QUNO) total_uno_genenq_count++;
                cq_intr_enq_num --;
        	do_hcw_delay          = 1'b1;

        	if (queue_list[queue_list_index].hcw_time > 0) begin
        	  if (cycle_count >= queue_list[queue_list_index].hcw_time) begin
                    queue_list[queue_list_index].num_hcw = 0;
        	  end 
        	end else begin
        	  queue_list[queue_list_index].num_hcw--;
        	end 

        	`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("%s PP 0x%0x FRAG_T HCW to QID 0x%0x QTYPE %s (is_ordered=%0d tbcnt=0x%0x) (is_reorded=%0d ordidx=0x%0x ordqid=0x%0x)  pend_hcw_trans.size=%0d wu=%0d ingress_drop=%0d, returning 1 token and 1 completion to %s CQ 0x%0x",
                                                	 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                	 pp_cq_num,
                                                	 hcw_trans.qid,
                                                	 hcw_trans.qtype.name(),
                                                	 is_ordered,   
                                                	 hcw_trans.tbcnt,
                                                	 is_reorded,   
                                                	 hcw_trans.ordidx,
                                                	 hcw_trans.ordqid,
                                                         pend_hcw_trans.size(),
                                                	 hcw_trans.wu,
                                                	 hcw_trans.ingress_drop,    
                                                	 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                	 pp_cq_num
                                                	) ,UVM_MEDIUM)
              end 

              ARM_CMD:       begin
        	hcw_trans.qe_valid    = 0;
        	hcw_trans.qe_orsp     = 1;
        	hcw_trans.qe_uhl      = 0;
        	hcw_trans.cq_pop      = 1;

                //--support cial_occ_tim interleved  (when hqmproc_cq_rearm_ctrl=0x37)
                if(cq_intr_enq_num==0 && cq_intr_rtntok_num==0)    cq_intr_enq_num = hqmproc_rtntokctrl_holdnum; 
              end 

              ILLEGAL_CMD:      begin
        	hcw_trans.qe_valid    = 1;
        	hcw_trans.qe_orsp     = 0;
        	hcw_trans.qe_uhl      = 0;
        	hcw_trans.cq_pop      = 0;

        	if (queue_list[queue_list_index].illegal_hcw_gen_mode == RAND_ILLEGAL) begin
        	      //queue_list[queue_list_index].num_hcw--;
        	      queue_list[queue_list_index].illegal_num_hcw--;
        	end 

        	if (illegal_hcw_burst_active) begin
        	  do_hcw_delay    = 1'b0;
        	end else begin
        	  do_hcw_delay    = 1'b1;
        	end 

        	corrupt_hcw(hcw_trans,illegal_hcw_type);
                is_ppid_valid = i_hqm_cfg.is_pp_v(hcw_trans.is_ldb,hcw_trans.ppid);

        	`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("Corrupted Illegal HCW - %s PP 0x%0x ILLEGAL HCW to is_nm_pf %0d is_ldb %0d PPID 0x%0x QID 0x%0x QTYPE %s (tbcnt=0x%0x) is_ppid_valid=%0d illegal_hcw_type=%0s illegal_num_hcw=%0d num_hcw=%0d",
                                                	 (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                                	 pp_cq_num,
                                                	 hcw_trans.is_nm_pf,
                                                	 hcw_trans.is_ldb,
                                                	 hcw_trans.ppid,
                                                	 hcw_trans.qid,
                                                	 hcw_trans.qtype.name(),
                                                	 hcw_trans.tbcnt,
                                                         is_ppid_valid,
                                                         illegal_hcw_type,
                                                         queue_list[queue_list_index].illegal_num_hcw,
                                                         queue_list[queue_list_index].num_hcw  
                                                	) ,UVM_MEDIUM)
              end 
            endcase

            queue_list[queue_list_index].cmd_count[cmd_type]++;

            hcw_trans.iptr        = hcw_trans.tbcnt;

            if (hcw_trans.qe_valid) begin
              if (cmd_type == ILLEGAL_CMD) begin
        	queue_list[queue_list_index].illegal_hcw_count++;
              end else begin
        	queue_list[queue_list_index].legal_hcw_count++;
              end 
            end 

            //  if(dta_comp_return_count==65) dta_comp_return_count=1;
            if(hqmproc_rtntokctrl_sel_mode==7) begin
              if(hcw_trans.qe_uhl)      dta_comp_return_count=1; 
              else if(hcw_trans.cq_pop) dta_comp_return_count=0;
            end else begin
              if(dta_comp_return_count==(hqmproc_rtntokctrl_threshold+2)) dta_comp_return_count=1;
            end 

            //--DTA flow controls
            if(hqmproc_dta_ctrl) begin
               if(pp_cq_num == hqmproc_dta_srcpp) begin
                   if(hqmproc_dta_num_hcw == total_genenq_count) begin
                       i_hqm_cfg.hqmproc_dta_srcpp_comp = 1;
                   end 
               end 
            end 

            `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen2: %s PP %0d num_hcw=%0d tbcnt=0x%0x is_ldb=%0d ppid=0x%0x is_nm_pf=%0d is_ao_cfg_v=%0d qid=0x%0x qtype=%0s qpri=%0d is_ordered=%0d lockid=0x%0x cmd=%0s (v=%0d/o=%0d/u=%0d/t=%0d); meas=%0d idsi=0x%0x cmp_id=0x%0x; pend_hcw_trans.size=%0d, pend_hcw_trans_comb.size=%0d;idx=%0d send_hcw_loop=%0d; cq_intr_service_state=%0d pend_cq_int_arm.size=%0d cq_intr_rtntok_num=%0d cq_intr_enq_num=%0d; cq_intr_service_cqirq_rearm_hold=%0d; total_genenq_count=%0d total_tok_return_count=%0d dta_comp_return_count=%0d total_comp_return_count=%0d total_a_comp_return_count=%0d hqmproc_rtntokctrl_threshold=%0d; has_trfenq_enable=%0d; hqmproc_dta_srcpp_comp=%0d hqmproc_dta_wpp_idlecnt=%0d/hqmproc_dta_wpp_idlenum=%0d hqmproc_enqctrl_sel_mode=%0d/hqmproc_rtntokctrl_sel_mode=%0d/hqmproc_rtncmpctrl_sel_mode=%0d - hcw_trans.ingress_drop=%0d", 
                      pp_cq_type.name(),pp_cq_num,queue_list[queue_list_index].num_hcw, hcw_trans.tbcnt, hcw_trans.is_ldb, hcw_trans.ppid, hcw_trans.is_nm_pf, is_ao_cfg_v, hcw_trans.qid, hcw_trans.qtype.name(), hcw_trans.qpri, is_ordered, hcw_trans.lockid, cmd_type.name(), hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.meas, hcw_trans.idsi, hcw_trans.cmp_id, pend_hcw_trans.size(), pend_hcw_trans_comb.size(), idx, send_hcw_loop, cq_intr_service_state, pend_cq_int_arm.size(), cq_intr_rtntok_num, cq_intr_enq_num, cq_intr_service_cqirq_rearm_hold, total_genenq_count, total_tok_return_count, dta_comp_return_count, total_comp_return_count, total_a_comp_return_count, hqmproc_rtntokctrl_threshold, has_trfenq_enable, i_hqm_cfg.hqmproc_dta_srcpp_comp, hqmproc_dta_wpp_idlecnt, hqmproc_dta_wpp_idlenum, hqmproc_enqctrl_sel_mode, hqmproc_rtntokctrl_sel_mode, hqmproc_rtncmpctrl_sel_mode, hcw_trans.ingress_drop),UVM_MEDIUM)

            //-------------------------------------------------------
            //-------------------------------------------------------
            //-- ingress error injection handling (post-processing)
            //-------------------------------------------------------
            //-------------------------------------------------------
            //-----------------------
            //-- excess tok 
            if(hqmproc_ingerrinj_excess_tok_ctrl==6 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_tok_rate) && (cmd_type==NEW_CMD || cmd_type==RENQ_CMD || cmd_type==FRAG_CMD || cmd_type==COMP_CMD)) begin
        	hcw_trans.cq_pop      = 1;

                if(cmd_type==COMP_CMD) begin
        	   hcw_trans.lockid   = hqmproc_ingerrinj_excess_tok_num - 1;
        	   total_tok_return_count += hqmproc_ingerrinj_excess_tok_num;
                end else begin
                   total_tok_return_count ++;
                end 
               `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen2_EXCESS_TOK: %s PP %0d num_hcw=%0d tbcnt=0x%0x qid=0x%0x qtype=%0s is_ordered=%0d lockid=0x%0x cmd=(v=%0d/o=%0d/u=%0d/t=%0d); meas=%0d idsi=0x%0x, hqmproc_ingerrinj_excess_tok_ctrl=%0d hqmproc_ingerrinj_excess_tok_rate=%0d",pp_cq_type.name(),pp_cq_num,queue_list[queue_list_index].num_hcw, hcw_trans.tbcnt, hcw_trans.qid, hcw_trans.qtype.name(), is_ordered, hcw_trans.lockid, hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.meas, hcw_trans.idsi,hqmproc_ingerrinj_excess_tok_ctrl, hqmproc_ingerrinj_excess_tok_rate ),UVM_MEDIUM)
            end 
 
            //-----------------------
            //-- excess comp
            if(hqmproc_ingerrinj_excess_cmp_ctrl == 6 && ($urandom_range(99,0) < hqmproc_ingerrinj_excess_cmp_rate) && (cmd_type==NEW_CMD || cmd_type==BAT_T_CMD) ) begin
        	hcw_trans.qe_uhl      = 1;
        	total_comp_return_count++;

               `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen2_EXCESS_CMP: %s PP %0d num_hcw=%0d tbcnt=0x%0x qid=0x%0x qtype=%0s is_ordered=%0d lockid=0x%0x cmd=(v=%0d/o=%0d/u=%0d/t=%0d); meas=%0d idsi=0x%0x, hqmproc_ingerrinj_excess_cmp_ctrl=%0d hqmproc_ingerrinj_excess_cmp_rate=%0d",pp_cq_type.name(),pp_cq_num,queue_list[queue_list_index].num_hcw, hcw_trans.tbcnt, hcw_trans.qid, hcw_trans.qtype.name(), is_ordered, hcw_trans.lockid, hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.meas, hcw_trans.idsi,hqmproc_ingerrinj_excess_cmp_ctrl, hqmproc_ingerrinj_excess_cmp_rate ),UVM_MEDIUM)
            end 

            //-----------------------
            //-- when it's doing cmp_id error injection
            if(hqmproc_ingerrinj_cmpid_ctrl>0 && has_ingerrinj_cmpid==1 && idx==0 ) begin
                prev_cmp_id           = hcw_trans_in.cmp_id;
        	hcw_trans.cmp_id      = hcw_trans.cmp_id - hqmproc_ingerrinj_cmpid_num;
               `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen2_CMPID_INJ_cmd_type=%s: %s PP %0d num_hcw=%0d tbcnt=0x%0x qid=0x%0x qtype=%0s is_ordered=%0d lockid=0x%0x cmd=(v=%0d/o=%0d/u=%0d/t=%0d); meas=%0d idsi=0x%0x, hqmproc_ingerrinj_cmpid_ctrl=%0d hqmproc_ingerrinj_cmpid_rate=%0d cmp_id=0x%0x prev_cmp_id=0x%0x", cmd_type.name(), pp_cq_type.name(),pp_cq_num,queue_list[queue_list_index].num_hcw, hcw_trans.tbcnt, hcw_trans.qid, hcw_trans.qtype.name(), is_ordered, hcw_trans.lockid, hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.meas, hcw_trans.idsi,hqmproc_ingerrinj_cmpid_ctrl, hqmproc_ingerrinj_cmpid_rate, hcw_trans.cmp_id, prev_cmp_id),UVM_MEDIUM)
            end 

            //-----------------------
            //-- when it's sending comp/comp_t/renq/renq_t from dirpp
            if(hqmproc_ingerrinj_cmpdirpp_ctrl>0 && has_ingerrinj_cmpdirpp==1 && idx==0 && send_hcw_loop==2) begin
                prev_cmp_id           = 'hf; //-- should be: hcw_trans_in.cmp_id;
                //--made up:
                hcw_trans.is_ldb      = 0;
                hcw_trans.qe_valid    = $urandom_range(0,1);
                hcw_trans.cq_pop      = $urandom_range(0,1);
               `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen2_CMPDIRPP_INJ_cmd_type=%s (saved_cmd_type=%0s): %s PP %0d num_hcw=%0d tbcnt=0x%0x qid=0x%0x qtype=%0s is_ordered=%0d lockid=0x%0x cmd=(v=%0d/o=%0d/u=%0d/t=%0d); meas=%0d idsi=0x%0x, hqmproc_ingerrinj_cmpdirpp_ctrl=%0d hqmproc_ingerrinj_cmpdirpp_rate=%0d cmp_id=0x%0x prev_cmp_id=0x%0x is_ldb=%0d", cmd_type.name(), saved_cmd_type.name(), pp_cq_type.name(),pp_cq_num,queue_list[queue_list_index].num_hcw, hcw_trans.tbcnt, hcw_trans.qid, hcw_trans.qtype.name(), is_ordered, hcw_trans.lockid, hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.meas, hcw_trans.idsi,hqmproc_ingerrinj_cmpdirpp_ctrl, hqmproc_ingerrinj_cmpdirpp_rate, hcw_trans.cmp_id, prev_cmp_id, hcw_trans.is_ldb),UVM_MEDIUM)
            end 

            //-----------------------
            //-- illegal QID
            curr_pp_ldb = (pp_cq_type == IS_LDB)? 1 : 0;
            curr_vas = i_hqm_cfg.get_vasfromcq(curr_pp_ldb, pp_cq_num); 


            if(hqmproc_ingerrinj_qidill_rand==1) hqmproc_ingerrinj_qidill_ctrl = $urandom_range(1, 5);
            if(hqmproc_ingerrinj_qidill_ctrl>0 && ($urandom_range(99,0) < hqmproc_ingerrinj_qidill_rate)) begin
                //--illegal QID (>=96; >=64)
                if(hqmproc_ingerrinj_qidill_ctrl==1) begin
                   if(pp_cq_type == IS_LDB) hcw_trans.qid = $urandom_range(32,127);
                   else                     hcw_trans.qid = $urandom_range(96,127);
                   has_ingerrinj_qidill = 1;   
                end 

                //--illegal QID not programmed in VAS
                if(hqmproc_ingerrinj_qidill_ctrl==2) begin //-- && !i_hqm_cfg.is_vasqid_v(curr_vas,(hcw_trans.qtype != QDIR),hcw_trans.qid)) begin
                   hcw_trans.qid = $urandom_range(hqmproc_ingerrinj_qidill_min,hqmproc_ingerrinj_qidill_max);
                   has_ingerrinj_qidill = 1;   
                end 

                //--illegal QID not programmed as atm 
                if(hqmproc_ingerrinj_qidill_ctrl==3) begin //-- && hcw_trans.qtype != QATM ) begin
                   hcw_trans.qid = $urandom_range(hqmproc_ingerrinj_qidill_min,hqmproc_ingerrinj_qidill_max);
                   hcw_trans.qtype = QATM;  
                   has_ingerrinj_qidill = 1;   
                end 

                //--illegal QID not programmed in uno 
                if(hqmproc_ingerrinj_qidill_ctrl==4) begin // && hcw_trans.qtype != QUNO) begin
                   hcw_trans.qid = $urandom_range(hqmproc_ingerrinj_qidill_min,hqmproc_ingerrinj_qidill_max);
                   hcw_trans.qtype = QUNO;  
                   has_ingerrinj_qidill = 1;   
                end 

                //--illegal QID not programmed in ord 
                if(hqmproc_ingerrinj_qidill_ctrl==5) begin // && hcw_trans.qtype != QORD) begin
                   hcw_trans.qid = $urandom_range(hqmproc_ingerrinj_qidill_min,hqmproc_ingerrinj_qidill_max);
                   hcw_trans.qtype = QORD;  
                   has_ingerrinj_qidill = 1;   
                end 

                if(has_ingerrinj_qidill==1) begin
                    if(hcw_trans.qe_valid==1 || (hcw_trans.qe_valid==0 && hcw_trans.cq_pop==1 && hcw_trans.lockid>0) ) begin
                        //--when doing return (BAT_T or COMP_T, if return more than one token, don't inject such err)
                       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen2_ILL_QID_INJ0_cmd_type=%s: %s PP %0d num_hcw=%0d tbcnt=0x%0x qid=0x%0x qtype=%0s is_ordered=%0d lockid=0x%0x cmd=(v=%0d/o=%0d/u=%0d/t=%0d); meas=%0d idsi=0x%0x, hqmproc_ingerrinj_qidill_ctrl=%0d hqmproc_ingerrinj_qidill_rate=%0d ", cmd_type.name(), pp_cq_type.name(),pp_cq_num,queue_list[queue_list_index].num_hcw, hcw_trans.tbcnt, hcw_trans.qid, hcw_trans.qtype.name(), is_ordered, hcw_trans.lockid, hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.meas, hcw_trans.idsi,hqmproc_ingerrinj_qidill_ctrl, hqmproc_ingerrinj_qidill_rate),UVM_MEDIUM)
                        
                    end else begin
                       hcw_trans.qe_valid = 1; //--generate an illgal qid ENQ HCW, RTL drops QE, keeps tok and comp   
                       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen2_ILL_QID_INJ1_cmd_type=%s: %s PP %0d num_hcw=%0d tbcnt=0x%0x qid=0x%0x qtype=%0s is_ordered=%0d lockid=0x%0x cmd=(v=%0d/o=%0d/u=%0d/t=%0d); meas=%0d idsi=0x%0x, hqmproc_ingerrinj_qidill_ctrl=%0d hqmproc_ingerrinj_qidill_rate=%0d ", cmd_type.name(), pp_cq_type.name(),pp_cq_num,queue_list[queue_list_index].num_hcw, hcw_trans.tbcnt, hcw_trans.qid, hcw_trans.qtype.name(), is_ordered, hcw_trans.lockid, hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.meas, hcw_trans.idsi,hqmproc_ingerrinj_qidill_ctrl, hqmproc_ingerrinj_qidill_rate),UVM_MEDIUM)
                    end 
                end 
            end 

            //-----------------------
            //-- illegal PP
            curr_pp_ldb = (pp_cq_type == IS_LDB)? 1 : 0;
            curr_vas = i_hqm_cfg.get_vasfromcq(curr_pp_ldb, pp_cq_num); 

            has_ingerrinj_ppill = 0;   

            if(hqmproc_ingerrinj_ppill_rand==1) hqmproc_ingerrinj_ppill_ctrl = $urandom_range(8, 1);
            if(hqmproc_ingerrinj_ppill_ctrl>0 && ($urandom_range(99,0) < hqmproc_ingerrinj_ppill_rate)) begin
                //--illegal PP not programmed in VAS (whole drop)
                if(hqmproc_ingerrinj_ppill_ctrl==1) begin
                   hcw_trans.ppid = $urandom_range(hqmproc_ingerrinj_ppill_min,hqmproc_ingerrinj_ppill_max); 
                   has_ingerrinj_ppill = 1;   
                end else if(hqmproc_ingerrinj_ppill_ctrl==2 && hcw_trans.qe_valid==1 ) begin
                   hcw_trans.ppid = $urandom_range(hqmproc_ingerrinj_ppill_min,hqmproc_ingerrinj_ppill_max); 
                   has_ingerrinj_ppill = 1; 
                end else if(hqmproc_ingerrinj_ppill_ctrl==3 && hcw_trans.qe_valid==1 && hcw_trans.qe_uhl==0 && hcw_trans.cq_pop==0 ) begin
                   hcw_trans.ppid = $urandom_range(hqmproc_ingerrinj_ppill_min,hqmproc_ingerrinj_ppill_max); 
                   has_ingerrinj_ppill = 1; 
                end else if(hqmproc_ingerrinj_ppill_ctrl==4 && hcw_trans.qe_valid==1 && hcw_trans.qe_orsp==1 ) begin
                   hcw_trans.ppid = $urandom_range(hqmproc_ingerrinj_ppill_min,hqmproc_ingerrinj_ppill_max); 
                   has_ingerrinj_ppill = 1; 
                end else if(hqmproc_ingerrinj_ppill_ctrl==5 && hcw_trans.qe_valid==1 && hcw_trans.qe_orsp==1 && hcw_trans.cq_pop==0 ) begin
                   hcw_trans.ppid = $urandom_range(hqmproc_ingerrinj_ppill_min,hqmproc_ingerrinj_ppill_max); 
                   has_ingerrinj_ppill = 1; 
                end else if(hqmproc_ingerrinj_ppill_ctrl==6 && hcw_trans.qe_uhl==0 ) begin
                   hcw_trans.ppid = $urandom_range(hqmproc_ingerrinj_ppill_min,hqmproc_ingerrinj_ppill_max); 
                   has_ingerrinj_ppill = 1; 
                end else if(hqmproc_ingerrinj_ppill_ctrl==7 && hcw_trans.cq_pop==0 ) begin
                   hcw_trans.ppid = $urandom_range(hqmproc_ingerrinj_ppill_min,hqmproc_ingerrinj_ppill_max); 
                   has_ingerrinj_ppill = 1; 
                end else if(hqmproc_ingerrinj_ppill_ctrl==8 && hcw_trans.qe_uhl==0 && hcw_trans.cq_pop==0 ) begin //--this one won't break TB(iosf mon upon token update)
                   hcw_trans.ppid = $urandom_range(hqmproc_ingerrinj_ppill_min,hqmproc_ingerrinj_ppill_max); 
                   has_ingerrinj_ppill = 1; 
                end 
               if(has_ingerrinj_ppill==1) begin
                       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen2_ILL_PP_INJ_cmd_type=%s: %s PP %0d num_hcw=%0d tbcnt=0x%0x qid=0x%0x qtype=%0s is_ordered=%0d lockid=0x%0x cmd=(v=%0d/o=%0d/u=%0d/t=%0d); meas=%0d idsi=0x%0x, hqmproc_ingerrinj_ppill_ctrl=%0d hqmproc_ingerrinj_ppill_rate=%0d change to: hcw_trans.ppid=%0d", cmd_type.name(), pp_cq_type.name(),pp_cq_num,queue_list[queue_list_index].num_hcw, hcw_trans.tbcnt, hcw_trans.qid, hcw_trans.qtype.name(), is_ordered, hcw_trans.lockid, hcw_trans.qe_valid, hcw_trans.qe_orsp, hcw_trans.qe_uhl, hcw_trans.cq_pop, hcw_trans.meas, hcw_trans.idsi,hqmproc_ingerrinj_ppill_ctrl, hqmproc_ingerrinj_ppill_rate, hcw_trans.ppid),UVM_MEDIUM)
                end 
            end 

            //-------------------------------------------------------
            //-- send HCW
            //-------------------------------------------------------
            if (queue_list[queue_list_index].num_hcw == 0) begin
              finish_hcw(hcw_trans,1'b1);
            end else if(enq_out_of_credit && $test$plusargs("HQM_RELAXED_BATCH_MODE")) begin
              finish_hcw(hcw_trans,1'b1);
            end else begin
              finish_hcw(hcw_trans,1'b0);
            end 


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
                 hcw_delay($urandom_range(queue_list[queue_list_index].hcw_delay_max,queue_list[queue_list_index].hcw_delay_min),tmp_hcw_delay_rem);
              end 

              queue_list[queue_list_index].hcw_delay_rem = tmp_hcw_delay_rem;
            end 


         end //--for(int idx=0;  	    
      end else begin
        sys_clk_delay(1);
      end //if (send_hcw

      //`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("TrfGen3: %s PP %0d index=%0d num_hcw=%0d total_genenq_count=%0d illegal_hcw_burst_count=%0d pend_cq_token_return=%0d pend_cq_int_arm=%0d pend_comp_return=%0d, hqmproc_trfctrl_sel_mode=%0d/rtntok_mode=%0d/rtncmp_mode=%0d, hqmproc_qid_sel_mode=%0d qid_genval=0x%0x/hcw_qid_use=0x%0x, hqmproc_qtype_sel_mode=%0d qtype_genval=%0s/hcw_qtype_use=%0s, hqmproc_qpri_sel_mode=%0d qpri_genval=%0d, hqmproc_lockid_sel_mode=%0d lockid_genval=0x%0x;;;; send_hcw=%0d cmd_type=%s cq_token_return=%0d is_ordered=%0d, qid_use=0x%0x qtype_use=%0s total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,queue_list[queue_list_index].num_hcw,total_genenq_count,illegal_hcw_burst_count,pend_cq_token_return_size,pend_cq_int_arm.size(),pend_comp_return_size, hqmproc_trfctrl_sel_mode, hqmproc_rtntokctrl_sel_mode, hqmproc_rtncmpctrl_sel_mode, hqmproc_qid_sel_mode, qid_genval, hcw_qid_use, hqmproc_qtype_sel_mode, qtype_genval.name(), hcw_qtype_use.name(), hqmproc_qpri_sel_mode, qpri_genval, hqmproc_lockid_sel_mode, lockid_genval, send_hcw,cmd_type.name(),cq_token_return,is_ordered, hcw_qid_use, hcw_qtype_use.name(),, total_genenq_count, total_tok_return_count, total_comp_return_count),UVM_MEDIUM)

    end else begin
      sys_clk_delay(1);
    end 
  end //-- while (mon_enable

  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGenReport",$psprintf("%s PP 0x%0x Queue Index %0d generated %0d legal HCW  %0d illegal HCW",
                                           (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                           pp_cq_num,
                                           queue_list_index,
                                           queue_list[queue_list_index].legal_hcw_count,
                                           queue_list[queue_list_index].illegal_hcw_count),UVM_MEDIUM)

  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGenReport",$psprintf("%s PP 0x%0x Queue Index %0d generated %0d legal HCW, total_genenq_count=%0d total_tok_return_count=%0d total_comp_return_count=%0d total_a_comp_return_count=%0d",
                                           (pp_cq_type == IS_LDB) ? "LDB" : "DIR",
                                           pp_cq_num,
                                           queue_list_index,
                                           queue_list[queue_list_index].legal_hcw_count,
                                           total_genenq_count, total_tok_return_count, total_comp_return_count, total_a_comp_return_count),UVM_MEDIUM)

  foreach (queue_list[queue_list_index].cmd_count[t]) begin
    `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfGen",$psprintf("    Command %s count=%0d",t.name(),queue_list[queue_list_index].cmd_count[t]),UVM_MEDIUM)
  end 

  active_gen_queue_list_cnt--;
endtask : hqmproc_gen_queue_list

//=========================================
//-- hqmproc_get_hcw_gen_type
//-- Based on get_hcw_gen_type 
//=========================================
task hqm_pp_cq_hqmproc_seq::hqmproc_get_hcw_gen_type(input  int            queue_list_index,
                                          input  bit            new_hcw_en,
                                          input  hcw_qtype      enqhcw_qtype,    
                                          input  int            enqhcw_qid,    
                                          input  hcw_qtype      renq_qtype,    
                                          input  int            renq_qid,    
                                          input  int            pend_hcw_trans_queue_index,
                                          output bit            send_hcw,
                                          output hcw_cmd_type_t cmd_type,
                                          output hcw_qtype      enqhcw_qtype_use,    
                                          output int            enqhcw_qid_use,    
                                          output int            cq_token_return,
                                          output int            is_ordered,
                                          output int            is_reorded,
                                          output int            curr_frag_num,
                                          output int            curr_frag_cnt,
                                          output int            curr_frag_last
                                         );
  bit hcw_ready;
  automatic int pend_cq_token_return_size;
  automatic int pend_comp_return_size;
  automatic int pend_a_comp_return_size;
  int ret_val;
  bit sel_enq, sel_tok, sel_arm, sel_cmp,sel_a_cmp;
  bit sel_renq;
  int get_ordered;
  bit sel_frag;
  bit is_last_reord;
  bit is_last_comp;
  bit is_ternimate_comp;
  int use_lastfrag_renq, use_frag;
  int vas;
  bit is_src_pp_ldb;
  bit out_of_credit;
  int hqmproc_rtntokctrl_rtnnum_on;
  int hqmproc_rtntokctrl_holdnum_val;
  int cq_depth_mon;
  int available_credit_num;
  int curr_pend_cq_token_return_size;
  int curr_pend_comp_return_size;
  int save_pend_comp_return_size;
  int curr_enq_num;
  int cq_thresh_val;
  bit cqirq_mask_on;  //-- cq_int_mask[cq].INT_MASK bit
  int cqirq_mask_check;//-- after cq_int_mask[cq] is reprogrammed, set this bit 1 to allow seq check if intr is generated (not expect intr)
  bit cqirq_mask_on_bit;
  int cqirq_mask_issue_rearm;
  int cqirq_mask_opt; //1: cfg flow is doing mask/unmask reprogramming
  int cqirq_mask_ena; //1: enable cfg flow to do cqirq mask reprogram;  0: disable
  int cqirq_mask_run; //1: cqirq mask reprogram is done; 0: cqirq mask reprogram is ongoing
                      //1: cq_int_mask[cq] is reprogrammed, cfgflow set this bit to 1 to allow rearm ; 0: after rearm is done, clear this bit

  int cq_intr_recved;
  int temp_frag_cnt, temp_frag_num, temp_frag_last;
  hcw_transaction    temp_hcw_trans_in;

  hcw_gen_sem.get(1);

  cqirq_mask_issue_rearm      = 0;
  cq_intr_received_num        = 0;
  send_hcw                    = 0;
  cq_token_return             = 0;
  is_ordered                  = 0;
  enqhcw_qtype_use            = enqhcw_qtype;
  enqhcw_qid_use              = enqhcw_qid;
  hqmproc_rtntokctrl_rtnnum_on   = 0; //control number of token returned when doing BAT_T/COMP_T, default is off
  hqmproc_rtntokctrl_holdnum_val = (cq_intr_occ_tim_state==0)? hqmproc_rtntokctrl_holdnum : 1;//cq_intr_occ_tim_state=0, cq_intr_occ loop, use hqmproc_rtntokctrl_holdnum; 
                                                                                              //cq_intr_occ_tim_state=1, cq_intr_timer loop, holdnumber is 1 (one token)
  if(pp_cq_type == IS_LDB) 
     cq_thresh_val = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_depth_intr_thresh;
  else
     cq_thresh_val = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_depth_intr_thresh;

  
  if(pp_cq_type == IS_LDB) begin
     cqirq_mask_on  = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask;
     cqirq_mask_check = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask_check;
     cqirq_mask_opt = hqmproc_cqirq_mask_ena? i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask_opt : 0; 
     cqirq_mask_ena = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask_ena; 
     cqirq_mask_run = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask_run; 
  end else begin
     cqirq_mask_on  = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask;
     cqirq_mask_check = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask_check;
     cqirq_mask_opt = hqmproc_cqirq_mask_ena? i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask_opt : 0; 
     cqirq_mask_ena = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask_ena; 
     cqirq_mask_run = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask_run; 
  end 
             
  if(cq_intr_occ_tim_state==0) begin
     //cq_intr_occ_tim_state=0, cq_intr_occ loop, use hqmproc_rtntokctrl_holdnum; 
     hqmproc_rtntokctrl_holdnum_val = hqmproc_rtntokctrl_holdnum;

     if(hqmproc_cq_rearm_ctrl[6]==1) begin
          if(total_tok_return_count <  (total_genenq_count - hqmproc_rtntokctrl_holdnum)) begin 
              hqmproc_rtntokctrl_holdnum_val = hqmproc_rtntokctrl_holdnum;  
          end else begin
              hqmproc_rtntokctrl_holdnum_val = hqmproc_rtntokctrl_holdnum - 1;  
          end 
     end 
  end else begin
     //cq_intr_occ_tim_state=1, cq_intr_timer loop, holdnumber is 1 (one token)
     hqmproc_rtntokctrl_holdnum_val = 1; 
  end 

  if(hqmproc_cq_rearm_ctrl[6]==1) begin 
      if(total_tok_return_count <  (total_genenq_count - (hqmproc_rtntokctrl_holdnum*hqmproc_cq_intr_resp_waitnum_min))) begin 
          hqmproc_cq_intr_resp_waitnum = hqmproc_cq_intr_resp_waitnum_min;  
      end else begin
          hqmproc_cq_intr_resp_waitnum = hqmproc_cq_intr_resp_waitnum_max;  
      end 
  end else begin
      hqmproc_cq_intr_resp_waitnum = $urandom_range(hqmproc_cq_intr_resp_waitnum_min, hqmproc_cq_intr_resp_waitnum_max); 
  end 

  if (pp_cq_type == IS_LDB) begin
      is_src_pp_ldb = 1'b1;
      has_trfenq_enable = i_hqm_cfg.hqmproc_ldb_trfctrl[pp_cq_num];
      has_tokrtn_enable = i_hqm_cfg.hqmproc_ldb_tokctrl[pp_cq_num];
      has_cmprtn_enable = i_hqm_cfg.hqmproc_ldb_cmpctrl[pp_cq_num];
      has_acmprtn_enable = i_hqm_cfg.hqmproc_ldb_acmpctrl[pp_cq_num];
  end else begin
      is_src_pp_ldb = 1'b0;
      has_trfenq_enable = i_hqm_cfg.hqmproc_dir_trfctrl[pp_cq_num];
      has_tokrtn_enable = i_hqm_cfg.hqmproc_dir_tokctrl[pp_cq_num];
      has_cmprtn_enable = 0;
      has_acmprtn_enable = 0;
  end 

  vas = i_hqm_cfg.get_vasfromcq(is_src_pp_ldb, pf_pp_cq_num);
 /// `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen00: %s PP %0d index=%0d credit available=%0d(VAS=0x%0x), has_trfenq_enable=%0d has_tokrtn_enable=%0d has_cmprtn_enable=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,i_hqm_pp_cq_status.vas_credit_avail(vas), vas, has_trfenq_enable, has_tokrtn_enable, has_cmprtn_enable),UVM_MEDIUM)

  pend_comp_return.abs_size(pend_comp_return_size);
  pend_a_comp_return.abs_size(pend_a_comp_return_size);
  pend_cq_token_return.abs_size(pend_cq_token_return_size);

  //--hqmproc_rtntokctrl_keepnum
  hqmproc_rtntokctrl_keepnum =  $urandom_range(hqmproc_rtntokctrl_keepnum_max,hqmproc_rtntokctrl_keepnum_min); 
  if(total_tok_return_count >= (total_genenq_count-8)) hqmproc_rtntokctrl_keepnum=0;

  //--hqmproc_rtntokctrl_keepnum to support cq_intr_occ_timer
  if(hqmproc_cq_rearm_ctrl[4]==1) begin
      hqmproc_rtntokctrl_keepnum = (cq_intr_occ_tim_state==0)? 1 : $urandom_range(hqmproc_rtntokctrl_keepnum_max,hqmproc_rtntokctrl_keepnum_min); 
  end 

  //--hqmproc_rtntokctrl_rtnnum_val and hqmproc_rtntokctrl_rtnnum_on
  hqmproc_rtntokctrl_rtnnum_val =  $urandom_range(hqmproc_rtntokctrl_rtnnum_max,hqmproc_rtntokctrl_rtnnum_min); //--number of token return controlled by this, if 0: no control
  if(hqmproc_rtntokctrl_rtnnum_val==0) hqmproc_rtntokctrl_rtnnum_on=0;
  else                                 hqmproc_rtntokctrl_rtnnum_on=1;

  //--hqmproc_rtntokctrl_rtnnum_on to support cq_intr_occ_timer
  if(hqmproc_cq_rearm_ctrl[4]==1 && cq_intr_occ_tim_state==1) begin
      hqmproc_rtntokctrl_rtnnum_on  = 1; 
      hqmproc_rtntokctrl_rtnnum_val = 1;
  end 
 
 `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0: %s PP %0d index=%0d new_hcw_en=%0d enqhcw_qtype=%0s enqhcw_qid=0x%0x pend_cq_token_return=%0d pend_cq_int_arm=%0d pend_comp_return=%0d pend_a_comp_return=%0d cq_comp_service_state=%0d hqmproc_trfctrl_sel_mode=%0d, hqmproc_rtntokctrl_sel_mode=%0d/holdnum=%0d/rtnnum=%0d/loop=%0d/cnt=%0d;hqmproc_rtntokctrl_keepnum=%0d cq_poll_interval=%0d; hqmproc_rtncmpctrl_sel_mode=%0d/holdnum=%0d/rtnnum=%0d/loop=%0d/cnt=%0d; total_comp_return_count=%0d total_a_comp_return_count=%0d; hqmproc_stream_flowctrl=%0d; cq_intr_service_state=%0d pend_cq_int_arm.size=%0d; cqirq_mask_on=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,new_hcw_en, enqhcw_qtype.name(), enqhcw_qid, pend_cq_token_return_size,pend_cq_int_arm.size(),pend_comp_return_size, pend_a_comp_return_size, cq_comp_service_state, hqmproc_trfctrl_sel_mode, hqmproc_rtntokctrl_sel_mode, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_rtnnum, hqmproc_rtntokctrl_loopnum, hqmproc_rtntokctrl_cnt,hqmproc_rtntokctrl_keepnum, cq_poll_interval, hqmproc_rtncmpctrl_sel_mode, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_rtnnum, hqmproc_rtncmpctrl_loopnum, hqmproc_rtncmpctrl_loopcnt, total_comp_return_count, total_a_comp_return_count, hqmproc_stream_flowctrl, cq_intr_service_state, pend_cq_int_arm.size(), cqirq_mask_on),UVM_MEDIUM)

  //--------------------------
  //-- hcw_ready  
    if (i_hqm_pp_cq_status.vas_credit_avail(vas) > 0 && has_trfenq_enable > 0) begin
      hcw_ready = 1;
    end else begin
      if ($urandom_range(99,0) < queue_list[queue_list_index].illegal_credit_prob && has_trfenq_enable > 0) begin
        hcw_ready     = 1;
        out_of_credit = 1;
      end else begin
        hcw_ready = 0;
      end 
    end 

  //--------------------------
  //-- check A_COMP: pend_acomp_return_size control => control A_COMP return
  //--------------------------
  if(has_acmprtn_enable>0) begin
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1ACOMPRTN_Start: %s PP %0d index=%0d - current pend_a_comp_return_size=%0d a_comp_return_delay=%0d; hqmproc_rtn_a_cmpctrl_sel_mode=%0d hqmproc_acomp_ctrl=%0d; pend_comp_return_size=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index, pend_a_comp_return_size, a_comp_return_delay, hqmproc_rtn_a_cmpctrl_sel_mode, hqmproc_acomp_ctrl, pend_comp_return_size),UVM_MEDIUM)

       if(hqmproc_rtn_a_cmpctrl_sel_mode==1) begin
           pend_a_comp_return.abs_size(pend_a_comp_return_size);
           if(pend_a_comp_return_size >= hqmproc_rtn_a_cmpctrl_holdnum) begin
    
             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1ACOMPRTN_mode1_holddone: %s PP %0d index=%0d - pend_a_comp_return_size=%0d reach hqmproc_rtn_a_cmpctrl_holdnum=%0d, hqmproc_rtn_a_cmpctrl_holdnum_waitcnt=%0d hqmproc_rtn_a_cmpctrl_holdnum_waitnum=%0d, change to return a_comp",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_a_comp_return_size, hqmproc_rtn_a_cmpctrl_holdnum, hqmproc_rtn_a_cmpctrl_holdnum_waitcnt, hqmproc_rtn_a_cmpctrl_holdnum_waitnum),UVM_MEDIUM)
              //--
              if(hqmproc_rtn_a_cmpctrl_holdnum_waitcnt>=hqmproc_rtn_a_cmpctrl_holdnum_waitnum) begin
                 hqmproc_rtn_a_cmpctrl_sel_mode=0; 
                 hqmproc_rtn_a_cmpctrl_loopcnt ++;
                 pend_a_comp_return_size = 0;     
              end else begin    
                 hqmproc_rtn_a_cmpctrl_holdnum_waitcnt++;
                 pend_a_comp_return_size = 0;     
              end 
              `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1ACOMPRTN_mode1_holddone: %s PP %0d index=%0d - pend_a_comp_return_size=%0d reach hqmproc_rtn_a_cmpctrl_holdnum=%0d, hqmproc_rtn_a_cmpctrl_holdnum_waitcnt=%0d hqmproc_rtn_a_cmpctrl_holdnum_waitnum=%0d, hqmproc_rtn_a_cmpctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_a_comp_return_size, hqmproc_rtn_a_cmpctrl_holdnum, hqmproc_rtn_a_cmpctrl_holdnum_waitcnt, hqmproc_rtn_a_cmpctrl_holdnum_waitnum, hqmproc_rtn_a_cmpctrl_sel_mode),UVM_MEDIUM)
           end else begin
              pend_a_comp_return_size = 0;     
           end //if(pend_a_comp_return_size >= hqmproc_rtn_a_cmpctrl_holdnum) 
          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1ACOMPRTN_mode1_Use: %s PP %0d index=%0d - pend_a_comp_return_size=%0d hqmproc_rtn_a_cmpctrl_holdnum=%0d, hqmproc_rtn_a_cmpctrl_holdnum_waitcnt=%0d hqmproc_rtn_a_cmpctrl_holdnum_waitnum=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_a_comp_return_size, hqmproc_rtn_a_cmpctrl_holdnum, hqmproc_rtn_a_cmpctrl_holdnum_waitcnt, hqmproc_rtn_a_cmpctrl_holdnum_waitnum),UVM_MEDIUM)

       end else begin
           //--default controls of a_comp
           //if (queue_list[queue_list_index].a_comp_flow && !a_comp_return_delay) begin
           if (!a_comp_return_delay) begin
               pend_a_comp_return.size(pend_a_comp_return_size);
              `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1ACOMPRTN_Return: %s PP %0d index=%0d - current pend_a_comp_return_size=%0d a_comp_return_delay=%0d; pend_comp_return_size=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index, pend_a_comp_return_size, a_comp_return_delay, pend_comp_return_size),UVM_MEDIUM)
           end else begin
               pend_a_comp_return_size = 0;
           end 
          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1ACOMPRTN_Use: %s PP %0d index=%0d - current pend_a_comp_return_size=%0d total_a_comp_return_count=%0d a_comp_return_delay=%0d queue_list[%0d].a_comp_flow=%0d; pend_comp_return_size=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index, pend_a_comp_return_size, total_a_comp_return_count, a_comp_return_delay, queue_list_index, queue_list[queue_list_index].a_comp_flow, pend_comp_return_size),UVM_MEDIUM)
       end //if(hqmproc_rtn_a_cmpctrl_sel_mode==1) 
  end else begin
       pend_a_comp_return_size = 0;
  end //if(has_acmprtn_enable>0)



  //--------------------------
  //-- check comp: pend_comp_return_size control => control comp return
  //-- hqmproc_rtncmpctrl_sel_mode  
  //-- hqmproc_rtncmpctrl_holdnum  
  //--    when (hqmproc_rtncmpctrl_holdnum_waitcnt < hqmproc_rtncmpctrl_holdnum_waitnum)  hqmproc_rtncmpctrl_holdnum_waitcnt++, keep holding
  //--    when (hqmproc_rtncmpctrl_holdnum_waitcnt >= hqmproc_rtncmpctrl_holdnum_waitnum) hqmproc_rtncmpctrl_loopcnt++;  hqmproc_rtncmpctrl_holdnum_check=1; keep holding but change hqmproc_rtncmpctrl_sel_mode to 0
  //--------------------------
  if(has_cmprtn_enable > 0) begin 
      if(hqmproc_rtncmpctrl_sel_mode==1 || hqmproc_rtncmpctrl_sel_mode==2) begin
         pend_comp_return.size(pend_comp_return_size);
         if(pend_comp_return_size >= hqmproc_rtncmpctrl_holdnum) begin
    
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_holddone: %s PP %0d index=%0d pend_comp_return_size=%0d reach hqmproc_rtncmpctrl_holdnum=%0d, hqmproc_rtncmpctrl_holdnum_waitcnt=%0d hqmproc_rtncmpctrl_holdnum_waitnut=%0d, change to return comp hqmproc_rtncmpctrl_sel_mode=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_holdnum_waitcnt, hqmproc_rtncmpctrl_holdnum_waitnum, hqmproc_rtncmpctrl_sel_mode, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
            //--support number of sched hcw check
            if(hqmproc_rtncmpctrl_holdnum_waitcnt>=hqmproc_rtncmpctrl_holdnum_waitnum) begin
               hqmproc_rtncmpctrl_sel_mode=0; 
               hqmproc_rtncmpctrl_loopcnt ++;
               if(hqmproc_rtncmpctrl_holdnum_waitnum>0) hqmproc_rtncmpctrl_holdnum_check=1;
               pend_comp_return_size = 0;     
               i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_inflight_thres_ena=1;
            end else if(hqmproc_rtncmpctrl_holdnum_waitcnt>= (hqmproc_rtncmpctrl_holdnum_waitnum - 10)) begin
               i_hqm_cfg.hqmproc_trfctrl_2=1; //--indicator: check unitidle
               hqmproc_rtncmpctrl_holdnum_waitcnt++;
               pend_comp_return_size = 0;     
            end else begin    
               hqmproc_rtncmpctrl_holdnum_waitcnt++;
               pend_comp_return_size = 0;     
            end 
    
         end else begin
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_hold: %s PP %0d index=%0d pend_comp_return_size=%0d but not reach hqmproc_rtncmpctrl_holdnum=%0d, not to return comp hqmproc_rtncmpctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_sel_mode),UVM_MEDIUM)
           pend_comp_return_size = 0;     
         end              

      end else if(hqmproc_rtncmpctrl_sel_mode==3) begin
         //--support ord seqnum capacity test
         pend_comp_return.size(pend_comp_return_size);
         if(pend_comp_return_size >= hqmproc_rtncmpctrl_holdnum) begin
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1RTNCOMP_holddone: %s PP %0d index=%0d pend_comp_return_size=%0d reach hqmproc_rtncmpctrl_holdnum=%0d, hqmproc_rtncmpctrl_holdnum_waitcnt=%0d hqmproc_rtncmpctrl_holdnum_waitnut=%0d, change to return comp hqmproc_rtncmpctrl_sel_mode=%0d =>0; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_holdnum_waitcnt, hqmproc_rtncmpctrl_holdnum_waitnum, hqmproc_rtncmpctrl_sel_mode, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
            hqmproc_rtncmpctrl_sel_mode = 0; 
                
         end else begin
           //`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_hold: %s PP %0d index=%0d pend_comp_return_size=%0d but not reach hqmproc_rtncmpctrl_holdnum=%0d, not to return comp hqmproc_rtncmpctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_sel_mode),UVM_MEDIUM)
           pend_comp_return_size = 0;     
         end       
      end else if(hqmproc_rtncmpctrl_sel_mode==5) begin
         //--support scen7 test0 test1 
         pend_comp_return.size(pend_comp_return_size);

         if(pend_comp_return_size >= hqmproc_rtncmpctrl_holdnum) begin
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1RTNCOMP_releasecomp: %s PP %0d index=%0d pend_comp_return_size=%0d reach hqmproc_rtncmpctrl_holdnum=%0d, hqmproc_rtncmpctrl_holdnum_waitcnt=%0d hqmproc_rtncmpctrl_holdnum_waitnut=%0d, hqmproc_rtncmpctrl_sel_mode=%0d; pend_cq_token_return_size=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_holdnum_waitcnt, hqmproc_rtncmpctrl_holdnum_waitnum, hqmproc_rtncmpctrl_sel_mode, pend_cq_token_return_size, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
         end else begin
           //`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_hold: %s PP %0d index=%0d pend_comp_return_size=%0d but not reach hqmproc_rtncmpctrl_holdnum=%0d, not to return comp hqmproc_rtncmpctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_sel_mode),UVM_MEDIUM)
           pend_comp_return_size = 0;     
         end 

      end else if(hqmproc_rtncmpctrl_sel_mode==6) begin
         //--support scen7 test2 
         pend_comp_return.size(pend_comp_return_size);

         if(pend_comp_return_size >= hqmproc_rtncmpctrl_holdnum) begin
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1RTNCOMP_releasecomp: %s PP %0d index=%0d pend_comp_return_size=%0d reach hqmproc_rtncmpctrl_holdnum=%0d, hqmproc_rtncmpctrl_holdnum_waitcnt=%0d hqmproc_rtncmpctrl_holdnum_waitnut=%0d, hqmproc_rtncmpctrl_sel_mode=%0d; pend_cq_token_return_size=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_holdnum_waitcnt, hqmproc_rtncmpctrl_holdnum_waitnum, hqmproc_rtncmpctrl_sel_mode, pend_cq_token_return_size, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)

            hqmproc_rtncmpctrl_holdnum = 1;
         end else begin
           ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_holdcomp: %s PP %0d index=%0d pend_comp_return_size=%0d but not reach hqmproc_rtncmpctrl_holdnum=%0d, not to return comp hqmproc_rtncmpctrl_sel_mode=%0d, pend_cq_token_return_size=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_sel_mode, pend_cq_token_return_size),UVM_MEDIUM)
           pend_comp_return_size = 0;     
         end 


      end else if(hqmproc_rtncmpctrl_sel_mode==7) begin
         //--support inflight_thresh 
         pend_comp_return.size(pend_comp_return_size);

         if(pend_comp_return_size >= hqmproc_rtncmpctrl_holdnum) begin
    
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_holddone: %s PP %0d index=%0d pend_comp_return_size=%0d reach hqmproc_rtncmpctrl_holdnum=%0d, hqmproc_rtncmpctrl_holdnum_waitcnt=%0d hqmproc_rtncmpctrl_holdnum_waitnut=%0d, change to return comp hqmproc_rtncmpctrl_sel_mode=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_holdnum_waitcnt, hqmproc_rtncmpctrl_holdnum_waitnum, hqmproc_rtncmpctrl_sel_mode, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
            //--support number of sched hcw check
            if(hqmproc_rtncmpctrl_holdnum_waitcnt>=hqmproc_rtncmpctrl_holdnum_waitnum) begin
               hqmproc_rtncmpctrl_loopcnt ++;
               if(hqmproc_rtncmpctrl_holdnum_waitnum>0) hqmproc_rtncmpctrl_holdnum_check=1;
               `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_holdrelease: %s PP %0d index=%0d pend_comp_return_size=%0d reach hqmproc_rtncmpctrl_holdnum=%0d, hqmproc_rtncmpctrl_holdnum_waitcnt=%0d hqmproc_rtncmpctrl_holdnum_waitnut=%0d, change to return comp hqmproc_rtncmpctrl_sel_mode=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_holdnum_waitcnt, hqmproc_rtncmpctrl_holdnum_waitnum, hqmproc_rtncmpctrl_sel_mode, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)

               hqmproc_rtncmpctrl_holdnum = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_ldb_inflight_thresh - 1;
            end else begin    
               hqmproc_rtncmpctrl_holdnum_waitcnt++;
               pend_comp_return_size = 0;     
            end 
         end else begin
           ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_holdcomp: %s PP %0d index=%0d pend_comp_return_size=%0d but not reach hqmproc_rtncmpctrl_holdnum=%0d, not to return comp hqmproc_rtncmpctrl_sel_mode=%0d, pend_cq_token_return_size=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_sel_mode, pend_cq_token_return_size),UVM_MEDIUM)
           pend_comp_return_size = 0;     
         end 

      end else begin
         //if (queue_list[queue_list_index].comp_flow && !comp_return_delay) begin
         if (!comp_return_delay) begin
           pend_comp_return.size(pend_comp_return_size);
    
           //--when hqmproc_rtncmpctrl_holdnum_check=1
           if(hqmproc_rtncmpctrl_holdnum_check==1 && hqmproc_rtncmpctrl_loopnum == 0) begin
               if(pend_comp_return_size > hqmproc_rtncmpctrl_checknum) begin
                  //-- this shows sched hcw number is greater than expected number (hqmproc_rtncmpctrl_checknum)
                  `uvm_error("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_comp_return: %s PP %0d index=%0d pend_comp_return_size=%0d exceed expected hqmproc_rtncmpctrl_checknum=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size,hqmproc_rtncmpctrl_checknum ))
               end 
               hqmproc_rtncmpctrl_holdnum_check=2;  
           end 
    
           //--loop controls hqmproc_rtncmpctrl_rtnnum
           if(hqmproc_rtncmpctrl_loopcnt < hqmproc_rtncmpctrl_loopnum && (total_comp_return_count > hqmproc_rtncmpctrl_loopcnt*hqmproc_rtncmpctrl_rtnnum)) begin
              hqmproc_rtncmpctrl_sel_mode=1; 
              `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_willhold_comp_return_delay=%0d: %s PP %0d index=%0d pend_comp_return_size=%0d total_comp_return_count=%0d reach hqmproc_rtncmpctrl_loopcnt=%0d * hqmproc_rtncmpctrl_rtnnum=%0d, change to return comp hqmproc_rtncmpctrl_sel_mode=%0d (hqmproc_rtncmpctrl_loopcnt=%0d/hqmproc_rtncmpctrl_loopnum=%0d)",comp_return_delay,pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, total_comp_return_count, hqmproc_rtncmpctrl_loopcnt, hqmproc_rtncmpctrl_rtnnum, hqmproc_rtncmpctrl_sel_mode, hqmproc_rtncmpctrl_loopcnt, hqmproc_rtncmpctrl_loopnum),UVM_MEDIUM)
           end 
    
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_comp_return_delay=%0d: %s PP %0d index=%0d pend_comp_return_size=%0d, total_comp_return_count=%0d, hqmproc_rtncmpctrl_holdnum=%0d, hqmproc_rtncmpctrl_rtnnum=%0d, comp hqmproc_rtncmpctrl_sel_mode=%0d (hqmproc_rtncmpctrl_loopcnt=%0d/hqmproc_rtncmpctrl_loopnum=%0d)",comp_return_delay,pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, total_comp_return_count, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_rtnnum, hqmproc_rtncmpctrl_sel_mode, hqmproc_rtncmpctrl_loopcnt, hqmproc_rtncmpctrl_loopnum),UVM_MEDIUM)
         end else begin
           pend_comp_return_size = 0;
           //`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNCOMP_NOT_comp_flow=%0d, comp_return_delay=%0d: %s PP %0d index=%0d pend_comp_return_size=%0d reach hqmproc_rtncmpctrl_holdnum=%0d, change to return comp hqmproc_rtncmpctrl_sel_mode=%0d",queue_list[queue_list_index].comp_flow, comp_return_delay,pp_cq_type.name(),pp_cq_num,queue_list_index, pend_comp_return_size, hqmproc_rtncmpctrl_holdnum, hqmproc_rtncmpctrl_sel_mode),UVM_MEDIUM)
         end 
      end     
  end else begin
       pend_comp_return_size = 0;
  end //-- if(has_cmprtn_enable > 0 
  
  //--------------------------
  //-- check token
  //--hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_rtnnum, hqmproc_rtntokctrl_loopnum, hqmproc_rtntokctrl_loopcnt, hqmproc_rtntokctrl_cnt,
  //--------------------------
  if(has_tokrtn_enable > 0) begin 
      if(hqmproc_rtntokctrl_sel_mode==1 || hqmproc_rtntokctrl_sel_mode==2) begin
         pend_cq_token_return.size(pend_cq_token_return_size);
         if(pend_cq_token_return_size >= hqmproc_rtntokctrl_holdnum) begin
    
            `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK_holddone: %s PP %0d index=%0d pend_cq_token_return=%0d reach hqmproc_rtntokctrl_holdnum=%0d, hqmproc_rtntokctrl_holdnum_waitcnt=%0d hqmproc_rtntokctrl_holdnum_waitnum=%0d, change to return tokens hqmproc_rtntokctrl_sel_mode=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_holdnum_waitcnt, hqmproc_rtntokctrl_holdnum_waitnum, hqmproc_rtntokctrl_sel_mode, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
    
            //--support number of sched hcw check
            if(hqmproc_rtntokctrl_holdnum_waitcnt>=hqmproc_rtntokctrl_holdnum_waitnum) begin
               hqmproc_rtntokctrl_sel_mode=0; 
               hqmproc_rtntokctrl_loopcnt ++;
               if(hqmproc_rtntokctrl_holdnum_waitnum>0) hqmproc_rtntokctrl_holdnum_check=1;
               pend_cq_token_return_size = 0;     
            end else if(hqmproc_rtntokctrl_holdnum_waitcnt>= (hqmproc_rtntokctrl_holdnum_waitnum - 10)) begin
               i_hqm_cfg.hqmproc_trfctrl_2=1; //--indicator: check unitidle
               hqmproc_rtntokctrl_holdnum_waitcnt++;
               pend_cq_token_return_size = 0;     
            end else begin    
               hqmproc_rtntokctrl_holdnum_waitcnt++;
               pend_cq_token_return_size = 0;     
            end 
    
         end else begin
          ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK_hold: %s PP %0d index=%0d pend_cq_token_return=%0d but not reach hqmproc_rtntokctrl_holdnum=%0d, not to return tokens hqmproc_rtntokctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_sel_mode),UVM_MEDIUM)
           pend_cq_token_return_size = 0;     
         end  

      end else if(hqmproc_rtntokctrl_sel_mode==3 && hqmproc_cq_rearm_ctrl[7]==0) begin
         //-------------------------------------------
         //-- cial cq_depth interactive mode
         //-- when hqmproc_rtntokctrl_sel_mode==3:
         //-- when token is available (pend_cq_token_return_size >= hqmproc_rtntokctrl_holdnum_val)
         //-- if cq_intr is not available, don't return token
         //-- if cq_intr is available, return token (cq_intr_service_state=1)
         //-------------------------------------------
         pend_cq_token_return.size(pend_cq_token_return_size);

         //`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__START: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cqirq_mask_on=%0d; cq_intr_received_num=%0d;; cq_intr_service_state=%0d cq_intr_rtntok_num=%0d, hqmproc_cqirq_mask_waitcnt=%0d hqmproc_cqirq_mask_waitnum=%0d ",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cqirq_mask_on, cq_intr_received_num, cq_intr_service_state, cq_intr_rtntok_num, hqmproc_cqirq_mask_waitcnt, hqmproc_cqirq_mask_waitnum), UVM_MEDIUM)

         if(cq_intr_service_state==0) begin 
             has_enq_rtn_mixed = 0;

             if(pp_cq_type == IS_LDB) i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_irq_pending_check = 0;
             else                     i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_irq_pending_check = 0;
  
             if(pend_cq_token_return_size >= hqmproc_rtntokctrl_holdnum_val ) begin
                if(cqirq_mask_on==0) begin       
                    //------------------------
                    //-- CQIRQ is unmasked
                    //------------------------
                    if(i_hqm_cfg.ims_poll_mode) begin
                       read_ims_poll_addr(ims_poll_data);
                       if(ims_poll_data == 0) begin
                            cq_intr_received_num = 0;
                       end else begin
                            cq_intr_received_num = 1;               
                	   `uvm_info(get_full_name(), $psprintf("%s CQ 0x%0x detected IMS Poll Write ims_poll_data=0x%0x", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num, ims_poll_data), UVM_MEDIUM)
                       end 
                    end else begin
                       cq_intr_received_num = i_hqm_pp_cq_status.cq_int_received(((pp_cq_type == IS_LDB) ? 1 : 0), pp_cq_num);
                    end 

                    if(cq_intr_received_num >= hqmproc_cq_intr_thres_num) begin // && cq_intr_service_state==0
                	if(i_hqm_cfg.ims_poll_mode) begin
                            write_ims_poll_addr(0);
                	end else begin
                            i_hqm_pp_cq_status.wait_for_cq_int(((pp_cq_type == IS_LDB) ? 1 : 0), pp_cq_num);
                	end 

                	if(hqmproc_cq_rearm_ctrl[6]==1 && hqmproc_cq_intr_resp_waitnum > 1000 && hqmproc_cq_cwdt_ctrl == 1) begin 
                            while(i_hqm_cfg.cialcwdt_cfg.cwdt_received_cnt <= i_hqm_cfg.cialcwdt_cfg.cwdt_count_num) begin

                               sys_clk_delay(hqmproc_cq_intr_resp_waitnum);
                               `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__CIALINTR_ST0_S2_wait: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cq_int_received=%0d hqmproc_cq_intr_thres_num=%0d;; cq_intr_service_state=%0d cq_intr_rtntok_num=%0d, hqmproc_cq_intr_resp_waitnum=%0d, mon_cwdt_received_cnt=%0d seq_cwdt_count_num=%0d ",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, hqmproc_cq_intr_thres_num, cq_intr_service_state, cq_intr_rtntok_num, hqmproc_cq_intr_resp_waitnum, i_hqm_cfg.cialcwdt_cfg.cwdt_received_cnt, i_hqm_cfg.cialcwdt_cfg.cwdt_count_num),UVM_MEDIUM)
                            end 
                            i_hqm_cfg.cialcwdt_cfg.cwdt_count_num++;
                	end else if(hqmproc_cq_rearm_ctrl[6]==1 && hqmproc_cq_cwdt_ctrl == 0) begin 
                            sys_clk_delay(hqmproc_cq_intr_resp_waitnum);

                            `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__CIALINTR_ST0_S2_wait: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cq_int_received=%0d hqmproc_cq_intr_thres_num=%0d;; cq_intr_service_state=%0d cq_intr_rtntok_num=%0d, hqmproc_cq_intr_resp_waitnum=%0d, mon_cwdt_received_cnt=%0d seq_cwdt_count_num=%0d ",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, hqmproc_cq_intr_thres_num, cq_intr_service_state, cq_intr_rtntok_num, hqmproc_cq_intr_resp_waitnum, i_hqm_cfg.cialcwdt_cfg.cwdt_received_cnt, i_hqm_cfg.cialcwdt_cfg.cwdt_count_num),UVM_MEDIUM)
                	end 

                        if(pp_cq_type == IS_LDB) begin 
                            i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_irq_pending_check = 1;
                        end else begin
                            i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_irq_pending_check = 1;
                        end 

                	if(hqmproc_cq_rearm_ctrl[1]==0) begin
                            cq_intr_service_state = 1; //--next is to return token, it can run with new_t/renq_t to retrun one token, or run with bat_t, comp_t to return pend_cq_token_return_size tokens; then rearm  
                	end else if(hqmproc_cq_rearm_ctrl[1]==1) begin
                            cq_intr_service_state = 2; //--next is to return token, it run with bat_t, comp_t to return pend_cq_token_return_size tokens; when all tokens are returned, issue rearm; 
                            cq_intr_rtntok_num = pend_cq_token_return_size; //--load current number of tokens to return under cq_intr_service_state=2
                	end 
                       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__CIALINTR_ST0_S2_return_token: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cq_int_received=%0d hqmproc_cq_intr_thres_num=%0d;; cq_intr_service_state=%0d cq_intr_rtntok_num=%0d, mon_cwdt_received_cnt=%0d seq_cwdt_count_num=%0d cqirq_mask_on=%0d cqirq_mask_check=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, hqmproc_cq_intr_thres_num, cq_intr_service_state, cq_intr_rtntok_num, i_hqm_cfg.cialcwdt_cfg.cwdt_received_cnt, i_hqm_cfg.cialcwdt_cfg.cwdt_count_num, cqirq_mask_on, cqirq_mask_check),UVM_MEDIUM)

                    end else begin
                       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__CIALINTR_ST0_S1_dont_return_token_wait_cqint: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cq_int_received=%0d hqmproc_cq_intr_thres_num=%0d cqirq_mask_on=%0d cqirq_mask_check=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, hqmproc_cq_intr_thres_num, cqirq_mask_on, cqirq_mask_check),UVM_MEDIUM)
                       pend_cq_token_return_size = 0;     
                    end 
		    
                end else begin
                    //------------------------
                    //-- CQIRQ is masked
                    //------------------------
                    if(hqmproc_cqirq_mask_waitcnt < hqmproc_cqirq_mask_waitnum) begin
                        hqmproc_cqirq_mask_waitcnt++;
                        i_hqm_cfg.cq_irq_mask_unit_idle_check = 1;

                        if (pp_cq_type == IS_LDB) i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask_wait = 1;
                        else                      i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask_wait = 1;

                       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__WAITIDLE: %s PP %0d index=%0d pend_cq_token_return=%0d set to 0 to hold token; hqmproc_rtntokctrl_holdnum_val=%0d; cq_intr_received_num=%0d;; cq_intr_service_state=%0d cq_intr_rtntok_num=%0d, hqmproc_cqirq_mask_waitcnt=%0d hqmproc_cqirq_mask_waitnum=%0d; hqm_cfg.cq_irq_mask_unit_idle_check=1 ",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, cq_intr_service_state, cq_intr_rtntok_num, hqmproc_cqirq_mask_waitcnt, hqmproc_cqirq_mask_waitnum),UVM_MEDIUM)

                        //-- not to return token
                        pend_cq_token_return_size = 0;     

                    end else begin
                        //-- when cqirq_mask_on=1, no cq irq occurred, verify there is no ims received		
                        i_hqm_cfg.cq_irq_mask_unit_idle_check = 0;

                        if (pp_cq_type == IS_LDB) i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask_wait = 0;
                        else                      i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask_wait = 0;

                        if(i_hqm_cfg.ims_poll_mode) begin
                           read_ims_poll_addr(ims_poll_data);
                           if(ims_poll_data == 0) begin
                               cq_intr_received_num = 0;
                           end else begin
                               cq_intr_received_num = 1;               
                	      `uvm_info(get_full_name(), $psprintf("%s CQ 0x%0x detected IMS Poll Write ims_poll_data=0x%0x (not expected when irq_mask_on=1)", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num, ims_poll_data), UVM_MEDIUM)
                           end 
                        end else begin
                           cq_intr_received_num = i_hqm_pp_cq_status.cq_int_received(((pp_cq_type == IS_LDB) ? 1 : 0), pp_cq_num);
                        end 

                        //-- check  when cqirq_mask_on=1, no cq irq occurred, verify there is no ims received
                        if(cq_intr_received_num>0 && cqirq_mask_check==1) begin
                           if($test$plusargs("HQM_CQINTMASK_CK_RELAX")) 
                            `uvm_warning("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__WAITNOCIALINTR_ST0_S2_return_token_cqirq_mask_on_cqirqcheck1: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cq_intr_received_num=%0d not expected! cq_intr_service_state=%0d cq_intr_rtntok_num=%0d, hqmproc_cqirq_mask_waitcnt=%0d hqmproc_cqirq_mask_waitnum=%0d ",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, cq_intr_service_state, cq_intr_rtntok_num, hqmproc_cqirq_mask_waitcnt, hqmproc_cqirq_mask_waitnum))
                           else
                            `uvm_error("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__WAITNOCIALINTR_ST0_S2_return_token_cqirq_mask_on_cqirqcheck1: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cq_intr_received_num=%0d not expected! cq_intr_service_state=%0d cq_intr_rtntok_num=%0d, hqmproc_cqirq_mask_waitcnt=%0d hqmproc_cqirq_mask_waitnum=%0d ",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, cq_intr_service_state, cq_intr_rtntok_num, hqmproc_cqirq_mask_waitcnt, hqmproc_cqirq_mask_waitnum))
                        end else begin
                          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__WAITNOCIALINTR_ST0_S2_return_token_cqirq_mask_on_cqirqcheck1: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cq_intr_received_num=%0d;; cq_intr_service_state=%0d cq_intr_rtntok_num=%0d, hqmproc_cqirq_mask_waitcnt=%0d hqmproc_cqirq_mask_waitnum=%0d ",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, cq_intr_service_state, cq_intr_rtntok_num, hqmproc_cqirq_mask_waitcnt, hqmproc_cqirq_mask_waitnum),UVM_MEDIUM)
                	end 

                        //-- tell cfg flow to check pending bit
                        if(pp_cq_type == IS_LDB) begin 
                            i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_irq_pending_check = 1;
                        end else begin
                            i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_irq_pending_check = 1;
                        end 

                        //-- clear cnt
                        hqmproc_cqirq_mask_waitcnt = 0;

                        //-- cq_intr_service_state control
                	if(hqmproc_cq_rearm_ctrl[1]==0) begin
                            cq_intr_service_state = 1; //--next is to return token, it can run with new_t/renq_t to retrun one token, or run with bat_t, comp_t to return pend_cq_token_return_size tokens; then rearm  
                	end else if(hqmproc_cq_rearm_ctrl[1]==1) begin
                            cq_intr_service_state = 2; //--next is to return token, it run with bat_t, comp_t to return pend_cq_token_return_size tokens; when all tokens are returned, issue rearm; 
                            cq_intr_rtntok_num = pend_cq_token_return_size; //--load current number of tokens to return under cq_intr_service_state=2
                	end 
                    end //-- if(hqmproc_cqirq_mask_waitcnt < hqmproc_cqirq_mask_waitnum
                end //-- if(cqirq_mask_on==0				    
             end else begin
                //-- not collecting enough tokens, report for debug
                if(i_hqm_cfg.ims_poll_mode) begin
                   read_ims_poll_addr(ims_poll_data);
                end else begin
                   cq_intr_received_num = i_hqm_pp_cq_status.cq_int_received(((pp_cq_type == IS_LDB) ? 1 : 0), pp_cq_num);
                end 
                `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__CIALINTR_0_ST0_dont_return_token_wait_token_available: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cq_int_received=%0d ims_poll_data=0x%0x hqmproc_cq_intr_thres_num=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, ims_poll_data, hqmproc_cq_intr_thres_num),UVM_MEDIUM)
                 pend_cq_token_return_size = 0;     
             end //--if(pend_cq_token_return_size >= hqmproc_rtntokctrl_holdnum_val ) 
         end else if(cq_intr_service_state == 1 || cq_intr_service_state == 2) begin
                if(i_hqm_cfg.ims_poll_mode) begin
                   read_ims_poll_addr(ims_poll_data);
                end else begin
                   cq_intr_received_num = i_hqm_pp_cq_status.cq_int_received(((pp_cq_type == IS_LDB) ? 1 : 0), pp_cq_num);
                end 

               `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__CIALINTR_ST1/2_return_token: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cq_int_received=%0d ims_poll_data=0x%0x hqmproc_cq_intr_thres_num=%0d;; cq_intr_service_state=%0d cq_intr_rtntok_num=%0d has_enq_rtn_mixed=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, ims_poll_data, hqmproc_cq_intr_thres_num, cq_intr_service_state, cq_intr_rtntok_num, has_enq_rtn_mixed),UVM_MEDIUM)

                //--cq_intr_service_state=2 case, there could be the case with new_t/renq_t + bat_t/comp_t in the group of N(N=cq_depth) return
                //-- in such case, it's possible that bat_t/comp_t returns more than N tokens in this round of return
                //-- eliminate multiple token return when it's a mixed case
                if(cq_intr_service_state==2 && has_enq_rtn_mixed==1 && pend_cq_token_return_size>1) begin
                   pend_cq_token_return_size = 1; 
                   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__CIALINTR_ST1/2_return_token:restrict_token_return_to_1: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cq_int_received=%0d ims_poll_data=0x%0x hqmproc_cq_intr_thres_num=%0d;; cq_intr_service_state=%0d cq_intr_rtntok_num=%0d has_enq_rtn_mixed=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, ims_poll_data, hqmproc_cq_intr_thres_num, cq_intr_service_state, cq_intr_rtntok_num, has_enq_rtn_mixed),UVM_MEDIUM)
                end 


         end else begin
             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__CIALINTR_ST3/4_dont_return_token: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cq_int_received=%0d hqmproc_cq_intr_thres_num=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cq_intr_received_num, hqmproc_cq_intr_thres_num),UVM_MEDIUM)
             pend_cq_token_return_size = 0; 
         end 

         //`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__END: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum_val=%0d; cqirq_mask_on=%0d; cq_intr_received_num=%0d;; cq_intr_service_state=%0d cq_intr_rtntok_num=%0d, hqmproc_cqirq_mask_waitcnt=%0d hqmproc_cqirq_mask_waitnum=%0d; ",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum_val, cqirq_mask_on, cq_intr_received_num, cq_intr_service_state, cq_intr_rtntok_num, hqmproc_cqirq_mask_waitcnt, hqmproc_cqirq_mask_waitnum), UVM_MEDIUM)

      end else if(hqmproc_rtntokctrl_sel_mode==4) begin
         //--support ord seqnum capacity test
         pend_cq_token_return.size(pend_cq_token_return_size);
         if(pend_cq_token_return_size >= hqmproc_rtntokctrl_holdnum) begin
    
            `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1RTNTOK_holddone: %s PP %0d index=%0d pend_cq_token_return=%0d reach hqmproc_rtntokctrl_holdnum=%0d, hqmproc_rtntokctrl_holdnum_waitcnt=%0d hqmproc_rtntokctrl_holdnum_waitnum=%0d, change to return tokens hqmproc_rtntokctrl_sel_mode=%0d => 0; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_holdnum_waitcnt, hqmproc_rtntokctrl_holdnum_waitnum, hqmproc_rtntokctrl_sel_mode, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
             hqmproc_rtntokctrl_sel_mode = 0;
 
         end else begin
          ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK_hold: %s PP %0d index=%0d pend_cq_token_return=%0d but not reach hqmproc_rtntokctrl_holdnum=%0d, not to return tokens hqmproc_rtntokctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_sel_mode),UVM_MEDIUM)
           pend_cq_token_return_size = 0;     
         end 

      end else if(hqmproc_rtntokctrl_sel_mode==5) begin
         //-- scen7: Test0, Test1
         //-- when pend_cq_token_return_size reach hqmproc_rtntokctrl_holdnum: return BAT_T; otherwise, hold tokens
         pend_cq_token_return.size(pend_cq_token_return_size);

         if(pend_cq_token_return_size >= hqmproc_rtntokctrl_holdnum && total_comp_return_count > hqmproc_rtntokctrl_threshold) begin
            `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1RTNTOK_releasetok: %s PP %0d index=%0d pend_cq_token_return=%0d reach hqmproc_rtntokctrl_holdnum=%0d, hqmproc_rtntokctrl_threshold=%0d, hqmproc_rtntokctrl_sel_mode=%0d; pend_comp_return_size=%0d total_comp_return_count=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_threshold, hqmproc_rtntokctrl_sel_mode, pend_comp_return_size, total_comp_return_count, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
 
         end else begin
           if(hqmproc_trfgen_watchdog_cnt > hqmproc_trfgen_watchdog_num && hqmproc_trfgen_watchdog_ena==2) begin
               hqmproc_rtntokctrl_sel_mode=0;
              `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1RTNTOK_timeout: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum=%0d, hqmproc_rtntokctrl_threshold=%0d, hqmproc_trfgen_watchdog_cnt=%0d hqmproc_trfgen_watchdog_num=%0d; change to hqmproc_rtntokctrl_sel_mode=%0d; pend_comp_return_size=%0d total_comp_return_count=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_threshold, hqmproc_trfgen_watchdog_cnt, hqmproc_trfgen_watchdog_num, hqmproc_rtntokctrl_sel_mode, pend_comp_return_size, total_comp_return_count, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
           end else begin
             ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK_hold: %s PP %0d index=%0d pend_cq_token_return=%0d but not reach hqmproc_rtntokctrl_holdnum=%0d, not to return tokens hqmproc_rtntokctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_sel_mode),UVM_MEDIUM)
              pend_cq_token_return_size = 0;   
           end  
         end 

      end else if(hqmproc_rtntokctrl_sel_mode==6) begin
         //-- scen7:  (mode=6); 
         //-- when pend_cq_token_return_size reach hqmproc_rtntokctrl_holdnum and dta_comp_return_count(1:64) > hqmproc_rtntokctrl_threshold: return BAT_T; otherwise, hold tokens
         //-- when sending token, set pend_comp_return_size=0 
         pend_cq_token_return.size(pend_cq_token_return_size);

         if(pend_cq_token_return_size >= hqmproc_rtntokctrl_holdnum && dta_comp_return_count > hqmproc_rtntokctrl_threshold) begin
            `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1RTNTOK_releasetok: %s PP %0d index=%0d pend_cq_token_return=%0d reach hqmproc_rtntokctrl_holdnum=%0d, hqmproc_rtntokctrl_threshold=%0d, hqmproc_rtntokctrl_sel_mode=%0d; pend_comp_return_size=%0d dta_comp_return_count=%0d total_comp_return_count=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_threshold, hqmproc_rtntokctrl_sel_mode, pend_comp_return_size, dta_comp_return_count, total_comp_return_count, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
  
             pend_comp_return_size=0;
             hqmproc_rtncmpctrl_holdnum = hqmproc_rtncmpctrl_holdnum_save;
           
         end else begin
            ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1RTNTOK_holdtoken: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum=%0d, hqmproc_rtntokctrl_threshold=%0d, hqmproc_rtntokctrl_sel_mode=%0d; pend_comp_return_size=%0d dta_comp_return_count=%0d total_comp_return_count=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_threshold, hqmproc_rtntokctrl_sel_mode, pend_comp_return_size, dta_comp_return_count, total_comp_return_count, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
             pend_cq_token_return_size = 0;     
         end 

      end else if(hqmproc_rtntokctrl_sel_mode==7) begin
         //-- scen7:  (mode=7); 
         //-- when pend_cq_token_return_size reach hqmproc_rtntokctrl_holdnum and dta_comp_return_count(0:1) > hqmproc_rtntokctrl_threshold: return BAT_T; otherwise, hold tokens
         //-- when sending token, set pend_comp_return_size=0 
         pend_cq_token_return.size(pend_cq_token_return_size);

         if(pend_cq_token_return_size >= hqmproc_rtntokctrl_holdnum && dta_comp_return_count[0] > hqmproc_rtntokctrl_threshold) begin
             pend_cq_token_return_size = 1;

            `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1RTNTOK_releasetok: %s PP %0d index=%0d pend_cq_token_return=%0d reach hqmproc_rtntokctrl_holdnum=%0d, hqmproc_rtntokctrl_threshold=%0d, hqmproc_rtntokctrl_sel_mode=%0d; pend_comp_return_size=%0d dta_comp_return_count=%0d total_comp_return_count=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_threshold, hqmproc_rtntokctrl_sel_mode, pend_comp_return_size, dta_comp_return_count, total_comp_return_count, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
  
             pend_comp_return_size=0;
             hqmproc_rtncmpctrl_holdnum = hqmproc_rtncmpctrl_holdnum_save;
           
         end else begin
            ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1RTNTOK_holdtoken: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum=%0d, hqmproc_rtntokctrl_threshold=%0d, hqmproc_rtntokctrl_sel_mode=%0d; pend_comp_return_size=%0d dta_comp_return_count=%0d total_comp_return_count=%0d; i_hqm_cfg.hqmproc_trfctrl_2=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_threshold, hqmproc_rtntokctrl_sel_mode, pend_comp_return_size, dta_comp_return_count, total_comp_return_count, i_hqm_cfg.hqmproc_trfctrl_2),UVM_MEDIUM)
             pend_cq_token_return_size = 0;     
         end 

      end else begin
         if (queue_list[queue_list_index].cq_token_return_flow && !tok_return_delay) begin
           pend_cq_token_return.size(pend_cq_token_return_size);
    
           //--when hqmproc_rtntokctrl_holdnum_check=1
           if(hqmproc_rtntokctrl_holdnum_check==1) begin
               if(pend_cq_token_return_size > hqmproc_rtntokctrl_checknum) begin
                  //-- this shows sched hcw number is greater than expected number (hqmproc_rtntokctrl_checknum)
                  `uvm_error("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK_tok_return: %s PP %0d index=%0d pend_cq_token_return_size=%0d exceed expected hqmproc_rtntokctrl_checknum=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size,hqmproc_rtntokctrl_checknum ))
               end 
               hqmproc_rtntokctrl_holdnum_check=2;  
           end 
    
           //--loop controls hqmproc_rtntokctrl_rtnnum
           if(hqmproc_rtntokctrl_loopcnt < hqmproc_rtntokctrl_loopnum && (total_tok_return_count > hqmproc_rtntokctrl_loopcnt*hqmproc_rtntokctrl_rtnnum)) begin
              hqmproc_rtntokctrl_sel_mode=1; 
              `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK_willhold_tok_return_delay=%0d: %s PP %0d index=%0d pend_cq_token_return=%0d total_tok_return_count=%0d reach hqmproc_rtntokctrl_loopcnt=%0d * hqmproc_rtntokctrl_rtnnum=%0d, change to return comp hqmproc_rtntokctrl_sel_mode=%0d (hqmproc_rtntokctrl_loopcnt=%0d/hqmproc_rtntokctrl_loopnum=%0d)",comp_return_delay,pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return, total_tok_return_count, hqmproc_rtntokctrl_loopcnt, hqmproc_rtntokctrl_rtnnum, hqmproc_rtntokctrl_sel_mode, hqmproc_rtntokctrl_loopcnt, hqmproc_rtntokctrl_loopnum),UVM_MEDIUM)
           end 
    
           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK_tok_return_delay=%0d: %s PP %0d index=%0d pend_cq_token_return=%0d total_tok_return_count=%0d, hqmproc_rtntokctrl_holdnum=%0d, hqmproc_rtntokctrl_rtnnum=%0d, tok hqmproc_rtntokctrl_sel_mode=%0d hqmproc_rtntokctrl_holdnum_check=%0d (hqmproc_rtntokctrl_loopcnt=%0d/hqmproc_rtntokctrl_loopnum=%0d)",tok_return_delay,pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, total_tok_return_count, hqmproc_rtntokctrl_holdnum,hqmproc_rtntokctrl_rtnnum, hqmproc_rtntokctrl_sel_mode, hqmproc_rtntokctrl_holdnum_check, hqmproc_rtntokctrl_loopcnt,hqmproc_rtntokctrl_loopnum),UVM_MEDIUM)
    
         end else begin
           pend_cq_token_return_size = 0;
           ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK_NOT_tok_return_delay=%0d: %s PP %0d index=%0d pend_cq_token_return=%0d reach hqmproc_rtntokctrl_holdnum=%0d, change to return tokens hqmproc_rtntokctrl_sel_mode=%0d",tok_return_delay, pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_sel_mode),UVM_MEDIUM)
         end 
      end 
  end else begin
       pend_cq_token_return_size = 0;

  end //--if(has_tokrtn_enable > 0)  

  

   //--------------------------
   //-- cq_intr and rearm support
   //--------------------------
   if(hqmproc_cq_rearm_ctrl[7]==1) begin
         //-------------------------------------------
         //-- cial cq_depth interactive mode (rnd)
         //-- when token is available (pend_cq_token_return_size >= hqmproc_rtntokctrl_holdnum)
         //-- if cq_intr is available, return token (cq_intr_service_state=1)
         //-------------------------------------------
         if(pend_cq_token_return_size >= hqmproc_rtntokctrl_holdnum ) begin
            if(i_hqm_cfg.ims_poll_mode) begin
               read_ims_poll_addr(ims_poll_data);
               if(ims_poll_data == 0) begin
                    cq_intr_received_num = 0;
               end else begin
                    cq_intr_received_num = 1;               
                   `uvm_info(get_full_name(), $psprintf("%s CQ 0x%0x detected IMS Poll Write ims_poll_data=0x%0x", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num, ims_poll_data), UVM_MEDIUM)
               end 
            end else begin
               cq_intr_received_num = i_hqm_pp_cq_status.cq_int_received(((pp_cq_type == IS_LDB) ? 1 : 0), pp_cq_num);
            end 

            if(cq_intr_received_num >= hqmproc_cq_intr_thres_num && cq_intr_service_state==0) begin
                if(i_hqm_cfg.ims_poll_mode) begin
                    write_ims_poll_addr(0);
                end else begin
                    i_hqm_pp_cq_status.wait_for_cq_int(((pp_cq_type == IS_LDB) ? 1 : 0), pp_cq_num);
                end 

                if(hqmproc_cq_rearm_ctrl[1]==0)
                    cq_intr_service_state = 1; //--next is to return token, it can run with new_t/renq_t to retrun one token, or run with bat_t, comp_t to return pend_cq_token_return_size tokens; then rearm  
                else if(hqmproc_cq_rearm_ctrl[1]==1) begin
                    cq_intr_service_state = 2; //--next is to return token, it can run with new_t/renq_t to retrun one token, or run with bat_t, comp_t to return pend_cq_token_return_size tokens; when all tokens are returned, issue rearm; 
                    cq_intr_rtntok_num = pend_cq_token_return_size;
                end 
               `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK__CIALINTR_2rnd: %s PP %0d index=%0d pend_cq_token_return=%0d hqmproc_rtntokctrl_holdnum=%0d; cq_int_received=%0d hqmproc_cq_intr_thres_num=%0d;; cq_intr_service_state=%0d, cq_intr_rtntok_num=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, cq_intr_received_num, hqmproc_cq_intr_thres_num, cq_intr_service_state, cq_intr_rtntok_num),UVM_MEDIUM)
            end 
         end 

   end //--hqmproc_cq_rearm_ctrl[7]==1

   //--------------------------
   //--decide sel_enq
   //-- 
   if(hqmproc_enqctrl_sel_mode==1) begin
      //-- in this mode, send ENQ HCWs until reach to  hqmproc_enqctrl_enqnum 
      //-- then stop sending more ENQ, wait (idle) until token pend_cq_token_return_size>=hqmproc_rtntokctrl_holdnum and it's about to return token
      //--
      //-- hqmproc_enqctrl_st:: 0: go; 1: nogo; 2: cont
      case (hqmproc_enqctrl_st)
           0: begin
                 if(total_genenq_count<hqmproc_enqctrl_enqnum) begin
                    if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0)) sel_enq = 1;
                    else sel_enq = 0;

                 end else if(total_genenq_count==hqmproc_enqctrl_enqnum) begin
                    hqmproc_enqctrl_st=1;
                    sel_enq = 0;
                 end 
              end 
           1: begin
                 if(pend_cq_token_return_size>0) begin
                    if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0)) sel_enq = 1;
                    else sel_enq = 0;

                    hqmproc_enqctrl_st=2;
                 end 
              end 
           2: begin
                    if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0)) sel_enq = 1;
                    else sel_enq = 0;
              end 
      endcase
     
       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1ENQ_change_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqctrl_st=%0d total_genenq_count=%0d hqmproc_enqctrl_enqnum=%0d pend_cq_token_return=%0d pend_comp_return_size=%0d ",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_st, total_genenq_count, hqmproc_enqctrl_enqnum, pend_cq_token_return_size,pend_comp_return_size ),UVM_MEDIUM)

   end else if(hqmproc_enqctrl_sel_mode==2) begin
      //-- in this mode, when doing hqmproc_rtntokctrl_sel_mode=2 or hqmproc_rtncmpctrl_sel_mode=2 (init)
      //-- sequence is to hold comp/tok for N, and burst N to return
      //-- 1/ ENQ when there is no comp/tok to return
      //-- 2/ burst compl/token , don't send enq

      if(hqmproc_rtncmpctrl_loopnum > 0 && hqmproc_rtncmpctrl_loopcnt < hqmproc_rtncmpctrl_loopnum && pend_comp_return_size > 0) begin
           sel_enq = 0;

          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1ENQ_change_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d total_genenq_count=%0d total_comp_return_count=%0d pend_cq_token_return=%0d pend_comp_return_size=%0d, hqmproc_rtncmpctrl_loopcnt=%0d/hqmproc_rtncmpctrl_loopnum=%0d ",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_sel_mode, total_genenq_count, total_comp_return_count, pend_cq_token_return_size,pend_comp_return_size, hqmproc_rtncmpctrl_loopcnt, hqmproc_rtncmpctrl_loopnum ),UVM_MEDIUM)
      end else if(hqmproc_rtntokctrl_loopnum > 0 && hqmproc_rtntokctrl_loopcnt < hqmproc_rtntokctrl_loopnum && pend_cq_token_return_size > 0) begin
           sel_enq = 0;

          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1ENQ_change_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d total_genenq_count=%0d total_tok_return_count=%0d pend_cq_token_return=%0d pend_comp_return_size=%0d, hqmproc_rtntokctrl_loopcnt=%0d/hqmproc_rtntokctrl_loopnum=%0d ",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_sel_mode, total_genenq_count, total_tok_return_count, pend_cq_token_return_size,pend_comp_return_size, hqmproc_rtntokctrl_loopcnt, hqmproc_rtntokctrl_loopnum ),UVM_MEDIUM)
      end 
    
   end else if(hqmproc_frag_ctrl==16 || hqmproc_frag_ctrl==17 || (hqmproc_stream_flowctrl==1 && has_trfenq_enable==1) || (hqmproc_enqctrl_sel_mode==3 && has_trfenq_enable==1 && hqmproc_trfgen_stop==0) ) begin
      //-- support streaming scenario and support RENQ_TND and RELS multiple threads scenario
      //-- LDBPP wait until there is HCW in sched, pend_comp_return_size>0   
      //-- DIRPP wait until there is HCW in sched, pend_cq_token_return_size>0
      //--
      //-- or set hqmproc_enqctrl_sel_mode=3 to do streaming-style trffic scenario 2 case
      //--
      if (pp_cq_type == IS_LDB) begin
          if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) & (pend_comp_return_size > 0)) sel_enq = 1;
          else sel_enq = 0;
      end else begin
          if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) & (pend_cq_token_return_size > 0)) sel_enq = 1;
          else sel_enq = 0;
      end 

   end else if(hqmproc_enqctrl_sel_mode==4) begin
      //-- in this mode, control CQ[] occupancy, so that CQ[] occupancy will never excess cq_threshold, this is to test unexpected CIAL.cq_occ
      //-- ((available_credit_num - curr_pend_cq_token_return_size) > hqmproc_cq_dep_chk_adj) => send ENQ  

      if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0)) begin
         pend_cq_token_return.size(curr_pend_cq_token_return_size);
         available_credit_num = i_hqm_pp_cq_status.vas_credit_avail(vas);

         if((available_credit_num - curr_pend_cq_token_return_size) > hqmproc_cq_dep_chk_adj ) begin  
           sel_enq = 1;
         end else begin
           sel_enq = 0;
         end 
          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1ENQ_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d total_genenq_count=%0d total_tok_return_count=%0d available_credit_num=%0d curr_pend_cq_token_return=%0d pend_comp_return_size=%0d, hqmproc_rtntokctrl_loopcnt=%0d/hqmproc_rtntokctrl_loopnum=%0d; cq_depth_intr_thresh=%0d, hqmproc_cq_dep_chk_adj=%0d ",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_sel_mode, total_genenq_count, total_tok_return_count, available_credit_num, curr_pend_cq_token_return_size,pend_comp_return_size, hqmproc_rtntokctrl_loopcnt, hqmproc_rtntokctrl_loopnum,  i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_depth_intr_thresh, hqmproc_cq_dep_chk_adj ),UVM_MEDIUM)
      end else begin 
           sel_enq = 0;
      end 
   end else if(hqmproc_enqctrl_sel_mode==5) begin
      //-- in this mode, send ENQ HCWs until reach to cq_thresh_val 
      //-- then stop sending more ENQ, wait (idle) until token pend_cq_token_return_size=cq_thresh_val and it's about to return token
      //--
      //-- hqmproc_enqrtnctrl_st:: 0: enq; 1: rtn ;  
      case (hqmproc_enqrtnctrl_st)
           0: begin
                 pend_cq_token_return_size = 0;
                 if((total_genenq_count%cq_thresh_val) < (cq_thresh_val)) begin
                    if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0)) sel_enq = 1;
                    else sel_enq = 0;

                 end 

                 if((total_genenq_count%cq_thresh_val) == (cq_thresh_val-1)) begin
                    hqmproc_enqrtnctrl_st=1;
                 end 
              end 
           1: begin
                 sel_enq = 0;
                 pend_cq_token_return_size = 0;

                 pend_cq_token_return.size(curr_pend_cq_token_return_size);

                 if(curr_pend_cq_token_return_size == cq_thresh_val) begin
                     pend_cq_token_return_size = curr_pend_cq_token_return_size;
                     hqmproc_enqrtnctrl_st=0;
                 end 
              end 
      endcase
     
       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1ENQ_change_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqrtnctrl_st=%0d total_genenq_count=%0d cq_thresh_val=%0d total_genenq_count(mod)cq_thresh_val=%0d; curr_pend_cq_token_return_size=%0d pend_cq_token_return=%0d pend_comp_return_size=%0d ",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqrtnctrl_st, total_genenq_count, cq_thresh_val, (total_genenq_count%cq_thresh_val), curr_pend_cq_token_return_size, pend_cq_token_return_size, pend_comp_return_size ),UVM_MEDIUM)
      
   end else if(hqmproc_enqctrl_sel_mode==10 || hqmproc_enqctrl_sel_mode==12 ) begin
       //--support ord seqnum capacity test_try_newer_flow_2ndP: 2nd P newer flow
       //-- hqmproc_enqctrl_sel_mode==10: wait for SCHED (hqmproc_enqctrl_enqnum) HCWs  before start FRAG (no NEW thereafter)
       //-- hqmproc_enqctrl_sel_mode==12: wait for SCHED (hqmproc_enqctrl_enqnum) HCWs  before start FRAG; after sending out (hqmproc_enqctrl_fragnum) FRAGs, stop sending FRAGs, it can send NEW
       if(hqmproc_enqctrl_sel_mode==10) is_adj_renq_on = 1;

       pend_cq_token_return.size(curr_pend_cq_token_return_size);
       pend_comp_return.size(curr_pend_comp_return_size);

       if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) && (i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt >=hqmproc_enqctrl_enqnum )) begin
           sel_enq = 1;
           pend_cq_token_return.size(pend_cq_token_return_size);
           pend_comp_return.size(pend_comp_return_size);
           hqmproc_rtncmpctrl_sel_mode = 0;  //-- don't hold completions
       end else begin
           sel_enq = 0;
       end 

       //-- hqmproc_enqctrl_sel_mode==12
       if(hqmproc_enqctrl_sel_mode==12 && total_genenq_count >= hqmproc_enqctrl_fragnum) begin
           hqmproc_frag_ctrl=0;
       end 

       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1ENQ_change_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d total_genenq_count=%0d hqmproc_enqctrl_enqnum=%0d ldb_pp_cq_status[%0d].st_sch_cnt=%0d; hqmproc_enqctrl_fragnum=%0d, hqmproc_frag_ctrl=%0d; curr_pend_cq_token_return_size=%0d curr_pend_comp_return_size=%0d; pend_cq_token_return=%0d pend_comp_return_size=%0d hqmproc_rtncmpctrl_sel_mode=%0d",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_sel_mode, total_genenq_count, hqmproc_enqctrl_enqnum, pp_cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt, hqmproc_enqctrl_fragnum, hqmproc_frag_ctrl, curr_pend_cq_token_return_size, curr_pend_comp_return_size, pend_cq_token_return_size, pend_comp_return_size, hqmproc_rtncmpctrl_sel_mode ),UVM_MEDIUM)
 

   end else if(hqmproc_enqctrl_sel_mode==11) begin
       //--support ord seqnum capacity test_try_older_flow_2ndP: 2nd P older flow
       //-- hqmproc_enqctrl_sel_mode==11: wait for SCHED (hqmproc_enqctrl_enqnum) HCWs and total enq of (i_hqm_pp_cq_status.replay_oldersn_enq_cnt >= hqmproc_enqctrl_enqnum_1) before start FRAG

       pend_cq_token_return.size(curr_pend_cq_token_return_size);
       pend_comp_return.size(curr_pend_comp_return_size);
       if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) && (i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt >=hqmproc_enqctrl_enqnum) && (i_hqm_pp_cq_status.replay_oldersn_enq_cnt >= hqmproc_enqctrl_enqnum_1)) begin
           sel_enq = 1;
           pend_cq_token_return.size(pend_cq_token_return_size);
           pend_comp_return.size(pend_comp_return_size);

       end else begin
           sel_enq = 0;

           if(hcw_ready==0 && new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) && (i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt >=hqmproc_enqctrl_enqnum) && (i_hqm_pp_cq_status.replay_oldersn_enq_cnt < hqmproc_enqctrl_enqnum_1)) begin
              //-- OOC occurred when it's waiting for 2nd flow, don't send comp
              pend_comp_return_size = 0; //--withhold completions before finish all 2nd Pass FRAG

             `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1ENQ_change_sel_enq=%0d_OOC: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d hcw_ready=%0d total_genenq_count=%0d hqmproc_enqctrl_enqnum=%0d hqmproc_enqctrl_enqnum_1=%0d ldb_pp_cq_status[%0d].st_sch_cnt=%0d; curr_pend_cq_token_return_size=%0d curr_pend_comp_return_size=%0d; pend_cq_token_return=%0d pend_comp_return_size=%0d ",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_sel_mode, hcw_ready, total_genenq_count, hqmproc_enqctrl_enqnum, hqmproc_enqctrl_enqnum_1, pp_cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt, curr_pend_cq_token_return_size, curr_pend_comp_return_size, pend_cq_token_return_size, pend_comp_return_size ),UVM_MEDIUM)
           end 
       end 

       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1ENQ_change_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d hcw_ready=%0d total_genenq_count=%0d hqmproc_enqctrl_enqnum=%0d hqmproc_enqctrl_enqnum_1=%0d ldb_pp_cq_status[%0d].st_sch_cnt=%0d; curr_pend_cq_token_return_size=%0d curr_pend_comp_return_size=%0d; pend_cq_token_return=%0d pend_comp_return_size=%0d ",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_sel_mode, hcw_ready, total_genenq_count, hqmproc_enqctrl_enqnum, hqmproc_enqctrl_enqnum_1, pp_cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt, curr_pend_cq_token_return_size, curr_pend_comp_return_size, pend_cq_token_return_size, pend_comp_return_size ),UVM_MEDIUM)

   end else if(hqmproc_enqctrl_sel_mode==13) begin
       //--support ord seqnum capacity test_try_1stP : send out all NEW for 1st PASS
       //-- hqmproc_enqctrl_sel_mode==13 : 1/ send (hqmproc_enqctrl_newnum) NEW; 2/ change to hqmproc_enqctrl_sel_mode==11: wait for SCHED (hqmproc_enqctrl_enqnum) HCWs and total enq of (i_hqm_pp_cq_status.replay_oldersn_enq_cnt >= hqmproc_enqctrl_enqnum_1) before start FRAG

       pend_cq_token_return.size(curr_pend_cq_token_return_size);
       pend_comp_return.size(curr_pend_comp_return_size);

       pend_cq_token_return_size=0;
       pend_comp_return_size=0;
    
       if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) && (total_genenq_count < hqmproc_enqctrl_newnum)) begin
           sel_enq = 1;
           if(total_genenq_count == (hqmproc_enqctrl_newnum-1)) begin 
              hqmproc_enqctrl_sel_mode=11;
           end 
       end else begin
           sel_enq = 0;
       end 
       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1ENQ_change_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d total_genenq_count=%0d hqmproc_enqctrl_newnum=%0d hqmproc_enqctrl_enqnum=%0d hqmproc_enqctrl_enqnum_1=%0d ldb_pp_cq_status[%0d].st_sch_cnt=%0d; curr_pend_cq_token_return_size=%0d curr_pend_comp_return_size=%0d; pend_cq_token_return=%0d pend_comp_return_size=%0d ",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_sel_mode, total_genenq_count, hqmproc_enqctrl_newnum, hqmproc_enqctrl_enqnum, hqmproc_enqctrl_enqnum_1, pp_cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt, curr_pend_cq_token_return_size, curr_pend_comp_return_size, pend_cq_token_return_size, pend_comp_return_size ),UVM_MEDIUM)

   end else if(hqmproc_enqctrl_sel_mode==14) begin
       //--support ord seqnum capacity test_try_1stP : send out all NEW for 1st PASS
       //-- hqmproc_enqctrl_sel_mode==14 : 1/ send (hqmproc_enqctrl_newnum) NEW; 2/ change to hqmproc_enqctrl_sel_mode==10: wait for SCHED (hqmproc_enqctrl_enqnum) HCWs  before start FRAG

       pend_cq_token_return.size(curr_pend_cq_token_return_size);
       pend_comp_return.size(curr_pend_comp_return_size);

       pend_cq_token_return_size=0;
       pend_comp_return_size=0;
    
       if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) && (total_genenq_count < hqmproc_enqctrl_newnum)) begin
           sel_enq = 1;
           if(total_genenq_count == (hqmproc_enqctrl_newnum-1)) begin 
              hqmproc_enqctrl_sel_mode=10;
           end 
       end else begin
           sel_enq = 0;
       end 
       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1ENQ_change_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d total_genenq_count=%0d hqmproc_enqctrl_newnum=%0d hqmproc_enqctrl_enqnum=%0d hqmproc_enqctrl_enqnum_1=%0d ldb_pp_cq_status[%0d].st_sch_cnt=%0d; curr_pend_cq_token_return_size=%0d curr_pend_comp_return_size=%0d; pend_cq_token_return=%0d pend_comp_return_size=%0d ",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_sel_mode, total_genenq_count, hqmproc_enqctrl_newnum, hqmproc_enqctrl_enqnum, hqmproc_enqctrl_enqnum_1, pp_cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt, curr_pend_cq_token_return_size, curr_pend_comp_return_size, pend_cq_token_return_size, pend_comp_return_size ),UVM_MEDIUM)


   //---------------------------------------------
   //--  hqmproc_enqctrl_sel_mode==16 => 17 => 18 sequence
   //---------------------------------------------
   end else if(hqmproc_enqctrl_sel_mode==16) begin
       //--support ord seqnum capacity test_try_1stP : send out all NEW for 1st PASS
       //-- hqmproc_enqctrl_sel_mode==16 : 1/ send (hqmproc_enqctrl_newnum) NEW; 2/ change to hqmproc_enqctrl_sel_mode==17: wait for SCHED (hqmproc_enqctrl_enqnum) HCWs and total enq of (i_hqm_pp_cq_status.replay_oldersn_enq_cnt >= hqmproc_enqctrl_enqnum_1) before start FRAG

       pend_cq_token_return.size(curr_pend_cq_token_return_size);
       pend_comp_return.size(curr_pend_comp_return_size);

       pend_cq_token_return_size=0;
       pend_comp_return_size=0;
    
       if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) && (total_genenq_count < hqmproc_enqctrl_newnum)) begin
           sel_enq = 1;
           if(total_genenq_count == (hqmproc_enqctrl_newnum-1)) begin 
              hqmproc_enqctrl_sel_mode=17;
           end 
       end else begin
           sel_enq = 0;
       end 
       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1ENQ_change_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d total_genenq_count=%0d hqmproc_enqctrl_newnum=%0d hqmproc_enqctrl_enqnum=%0d hqmproc_enqctrl_enqnum_1=%0d ldb_pp_cq_status[%0d].st_sch_cnt=%0d; curr_pend_cq_token_return_size=%0d curr_pend_comp_return_size=%0d; pend_cq_token_return=%0d pend_comp_return_size=%0d ",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_sel_mode, total_genenq_count, hqmproc_enqctrl_newnum, hqmproc_enqctrl_enqnum, hqmproc_enqctrl_enqnum_1, pp_cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt, curr_pend_cq_token_return_size, curr_pend_comp_return_size, pend_cq_token_return_size, pend_comp_return_size ),UVM_MEDIUM)

   end else if(hqmproc_enqctrl_sel_mode==17) begin
       //--support ord seqnum capacity test_try_newer_flow_2ndP: 2nd P newer flow
       //-- hqmproc_enqctrl_sel_mode==17: wait for SCHED (hqmproc_enqctrl_enqnum) HCWs  before start FRAG (no NEW thereafter)
       //--                               withhold completion, only sending out FRAG
       is_adj_renq_on = 1;

       pend_cq_token_return.size(curr_pend_cq_token_return_size);
       pend_comp_return.size(curr_pend_comp_return_size);

       if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) && (i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt >=hqmproc_enqctrl_enqnum )) begin
           sel_enq = 1;
           pend_cq_token_return.size(pend_cq_token_return_size);
           pend_comp_return.size(save_pend_comp_return_size);
           pend_comp_return_size = 0;
       end else begin
           sel_enq = 0;
       end 

       if(total_genenq_count >= (hqmproc_enqctrl_newnum + hqmproc_enqctrl_fragnum)) begin
           hqmproc_frag_ctrl=0;
           hqmproc_enqctrl_sel_mode=18;
           pend_comp_return.size(save_pend_comp_return_size);
           pend_comp_return_size = 0;
       end 

       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1ENQ_change_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d total_genenq_count=%0d hqmproc_enqctrl_enqnum=%0d ldb_pp_cq_status[%0d].st_sch_cnt=%0d; hqmproc_enqctrl_newnum=%0d hqmproc_enqctrl_fragnum=%0d, hqmproc_frag_ctrl=%0d; curr_pend_cq_token_return_size=%0d curr_pend_comp_return_size=%0d; pend_cq_token_return=%0d pend_comp_return_size=%0d save_pend_comp_return_size=%0d",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_sel_mode, total_genenq_count, hqmproc_enqctrl_enqnum, pp_cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt, hqmproc_enqctrl_newnum, hqmproc_enqctrl_fragnum, hqmproc_frag_ctrl, curr_pend_cq_token_return_size, curr_pend_comp_return_size, pend_cq_token_return_size, pend_comp_return_size, save_pend_comp_return_size ),UVM_MEDIUM)
 
   end else if(hqmproc_enqctrl_sel_mode==18) begin
       //--support ord seqnum capacity test_try_newer_flow_2ndP: 2nd P newer flow
       //-- hqmproc_enqctrl_sel_mode==18: withhold completion, wait for total enq of (i_hqm_pp_cq_status.replay_oldersn_enq_cnt >= hqmproc_enqctrl_enqnum_1) before start comp (the last)
       is_adj_renq_on = 1;
       hqmproc_frag_ctrl=0;

       pend_cq_token_return.size(curr_pend_cq_token_return_size);
       pend_comp_return.size(curr_pend_comp_return_size);

       if(i_hqm_pp_cq_status.replay_oldersn_enq_cnt >= hqmproc_enqctrl_enqnum_1) begin
           pend_cq_token_return.size(pend_cq_token_return_size);
           pend_comp_return.size(pend_comp_return_size);
       end else begin
           pend_comp_return_size = 0;
           save_pend_comp_return_size = 0;
       end 


       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("DBGTrfCmdGen0.1ENQ_change_sel_enq=%0d: %s PP %0d index=%0d hqmproc_enqctrl_sel_mode=%0d total_genenq_count=%0d hqmproc_enqctrl_enqnum=%0d ldb_pp_cq_status[%0d].st_sch_cnt=%0d; hqmproc_enqctrl_fragnum=%0d, hqmproc_frag_ctrl=%0d; curr_pend_cq_token_return_size=%0d curr_pend_comp_return_size=%0d; pend_cq_token_return=%0d pend_comp_return_size=%0d save_pend_comp_return_size=%0d",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, hqmproc_enqctrl_sel_mode, total_genenq_count, hqmproc_enqctrl_enqnum, pp_cq_num, i_hqm_pp_cq_status.ldb_pp_cq_status[pp_cq_num].st_sch_cnt, hqmproc_enqctrl_fragnum, hqmproc_frag_ctrl, curr_pend_cq_token_return_size, curr_pend_comp_return_size, pend_cq_token_return_size, pend_comp_return_size, save_pend_comp_return_size ),UVM_MEDIUM)
 

   end else begin         
      if(hqmproc_cq_rearm_ctrl[5] == 0) begin
         //-- regular 
         if(hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) && cq_intr_service_state != 3) begin
            if(hqmproc_stream_flowctrl==2)                                       sel_enq = 0; //--streaming trfflowctrl, when hqmproc_stream_flowctrl=2, expecting to send out LDB:comp/comp_tb; DIR BAT_T
            else if(hqmproc_cq_rearm_ctrl[2] == 1 && cq_intr_service_state == 2) sel_enq = 0; //--when cq_intr_service_state=2(next to return all tokens, and hqmproc_cq_rearm_ctrl[2]=1, don't send enq, return token is highest priority 
            else                                                                 sel_enq = 1;
         end else begin 
           sel_enq = 0;
         end 
      end else begin
         //-- cial.occ+cial.tim loop  cq_intr_occ_tim_state
         if(cq_intr_service_state == 0) begin

             if(cq_intr_enq_num==65535 && cq_intr_rtntok_num==65535) cq_intr_enq_num = hqmproc_rtntokctrl_holdnum; 

             if(cq_intr_enq_num>0 && hcw_ready & new_hcw_en & (queue_list[queue_list_index].num_hcw > 0)) begin
                sel_enq = 1;
             end else begin
                sel_enq = 0;
             end  
         end else begin
             //--when cq_intr_service_state=1 or 2, expect: next to return all tokens, don't send enq, return token is highest priority 
             //--when cq_intr_service_state=3 or 4, expect: next to send arm
             sel_enq = 0;
         end 
      end 
   end 

   //--------------------------------------------------------------------------------------------------------
   //--------------------------------------------------------------------------------------------------------
   //--------------------------------------------------------------------------------------------------------
   //--------------------------
   //--------------------------
   //--decide enq_out_of_credit
   //--check if it's enq_out_of_credit: trying to send an enq, but out_of_credit
   enq_out_of_credit = 0; 
   if(sel_enq==0) begin
     if(new_hcw_en & (queue_list[queue_list_index].num_hcw > 0) && hcw_ready==0) enq_out_of_credit = 1;
   end 


   //--this is to support bat_t or comp_t with tok*n return once cumulated tokens can be released 
   if(hqmproc_rtntokctrl_holdnum_check==2 && $urandom_range(1,0) == 1) begin
     if(sel_enq) sel_enq=0;
     hqmproc_rtntokctrl_holdnum_check=3;
       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen0.1RTNTOK_change_sel_enq=%0d: %s PP %0d index=%0d pend_cq_token_return=%0d reach hqmproc_rtntokctrl_holdnum=%0d, change to return tokens hqmproc_rtntokctrl_sel_mode=%0d hqmproc_rtntokctrl_holdnum_check=%0d",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index, pend_cq_token_return_size, hqmproc_rtntokctrl_holdnum, hqmproc_rtntokctrl_sel_mode, hqmproc_rtntokctrl_holdnum_check),UVM_MEDIUM)
   end 

   //--------------------------
   //--decide sel_renq
   //-- 
   if(hqmproc_cq_rearm_ctrl[5] == 0) begin
       //-- regular 
       if(hcw_ready & (queue_list[queue_list_index].num_hcw > 0) && cq_intr_service_state != 3) begin
          if(hqmproc_cq_rearm_ctrl[2] == 1 && cq_intr_service_state == 2) sel_renq = 0; //--when cq_intr_service_state=2(next to return all tokens, and hqmproc_cq_rearm_ctrl[2]=1, don't send enq, return token is highest priority 

          else                                                            sel_renq = 1;
       end else begin
          sel_renq = 0;
       end 
   end else begin
         //-- cial.occ+cial.tim loop  cq_intr_occ_tim_state
         if(cq_intr_service_state == 0) begin
             if(cq_intr_enq_num>0 && hcw_ready & (queue_list[queue_list_index].num_hcw > 0)) begin
                sel_renq = 1;
             end else begin
                sel_renq = 0;
             end  
         end else begin
             sel_renq = 0;
         end 
   end 
 
   //--------------------------
   //--decide sel_tok (hqmproc_rtntokctrl_keepnum default is 0)
   //-- 
   if(pend_cq_token_return_size > hqmproc_rtntokctrl_keepnum && cq_intr_service_state != 3) sel_tok = 1;
   else                                                                                     sel_tok = 0;

   //--------------------------
   //--decide sel_arm
   //-- 
   if((cq_poll_interval == 0) && queue_list[queue_list_index].cq_token_return_flow && (pend_cq_int_arm.size() > 0)) begin
      sel_arm = 1;
   end else if(cq_poll_interval > 0 && (cq_intr_service_state == 3 || cq_intr_service_state == 4) && (pend_cq_int_arm.size() > 0)) begin
      if(hqmproc_enqctrl_sel_mode==5 && sel_enq==1)  sel_arm = 0;   //--hqmproc_enqctrl_sel_mode=5 case(NOCIAL, but running w/ agitation, there are cial intr), when sel_enq=1, postpone sel_arm, issue enq first
      else                                           sel_arm = 1;
   end else begin
      sel_arm = 0;
   end 

   //--------------------------
   //--decide sel_cmp
   //-- 
   if(pend_comp_return_size > 0 && cq_intr_service_state != 3)     sel_cmp = 1;
   else                                                            sel_cmp = 0;

   //--------------------------
   //--decide sel_a_cmp
   //-- hqmproc_acomp_ctrl=0: A_COMP+COMP order control by cq_comp_service_state
   //-- hqmproc_acomp_ctrl=1: COMP+A_COMP order control by cq_comp_service_state
   //-- hqmproc_acomp_ctrl=2: use a_comp_return_delay and hqmproc_rtn_a_cmpctrl_sel_mode 
   //-- hqmproc_acomp_ctrl=3: use a_comp_return_delay and hqmproc_rtn_a_cmpctrl_sel_mode ==> add another round of rand 
   //--------------------------
   if(hqmproc_acomp_ctrl<2) begin 
      if(pend_a_comp_return_size > 0 && cq_comp_service_state==0 && cq_intr_service_state != 3)     sel_a_cmp = 1;
      else                                                                                          sel_a_cmp = 0;     
   end else begin
      if(pend_a_comp_return_size > 0 && cq_intr_service_state != 3)     sel_a_cmp = 1;
      else                                                              sel_a_cmp = 0;     

      if(hqmproc_acomp_ctrl>=3 && $urandom_range(hqmproc_acomp_ctrl,0) != 1 && sel_a_cmp == 1) begin
          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_A_COMP_BLOCK_hqmproc_acomp_ctrl=%0d: %s PP %0d index=%0d force sel_a_cmp=0 when ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)); is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d; ",hqmproc_acomp_ctrl, pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
           sel_a_cmp = 0;
      end 
   end 

   //--------------------------
   //-- Support FRAG sel_frag
   //--------------------------
   if(pend_comp_return_size > 0) begin
       if(hqmproc_frag_ctrl==16 || hqmproc_frag_ctrl==17) get_ordered = 1;
       else                      get_ordered = pend_comp_return.data_q[0];
   end else if(save_pend_comp_return_size > 0 && hqmproc_enqctrl_sel_mode==17) begin
       get_ordered = 1; 
   end else begin
       get_ordered = 0;
   end 

   is_last_reord=0;
   is_last_comp =0;
   is_ternimate_comp = 0;   //-- when num_hcw=0, but there are reord in the middle of running, terminate reord seq by returning comp/comp_t
   is_reorded=0;         
   use_frag = 0;
   use_lastfrag_renq = 0;
   if(hqmproc_frag_ctrl==1 || hqmproc_frag_ctrl==9)      use_lastfrag_renq = 0;
   else if(hqmproc_frag_ctrl==2|| hqmproc_frag_ctrl==10 || hqmproc_frag_ctrl==16 || hqmproc_frag_ctrl==17) use_lastfrag_renq = 1;
   else if(hqmproc_frag_ctrl==3|| hqmproc_frag_ctrl==11) use_lastfrag_renq = $urandom_range(1,0);

   temp_frag_cnt=0;
   temp_frag_num=0;
   temp_frag_last=0;
   if(pend_hcw_trans_queue_index>=0) begin
           temp_hcw_trans_in = pend_hcw_trans[pend_hcw_trans_queue_index];
           temp_frag_cnt     = temp_hcw_trans_in.frg_cnt;
           temp_frag_num     = temp_hcw_trans_in.frg_num;
           temp_frag_last    = temp_hcw_trans_in.frg_last;
          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_temp_frag: %s PP %0d index=%0d; pend_hcw_trans_queue_index=%0d temp_frag_cnt=%0d temp_frag_num=%0d temp_frag_last=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index,pend_hcw_trans_queue_index, temp_frag_cnt, temp_frag_num, temp_frag_last),UVM_MEDIUM)
   end 

   //if (hqmproc_frag_ctrl>0 && frag_num >= frag_cnt && frag_last==0) begin
   if (hqmproc_frag_ctrl>0 && temp_frag_num >= temp_frag_cnt && temp_frag_last==0) begin
       if(hcw_ready & (queue_list[queue_list_index].num_hcw > 0)) begin
          use_frag = 1;
       end else begin
          use_frag = 0;
          is_ternimate_comp = 1;
       end 
   end 

   if(hqmproc_frag_ctrl>0 && get_ordered && (temp_frag_num-1)==temp_frag_cnt && temp_frag_last==0 && use_lastfrag_renq)  is_last_reord=1; //-- this is the last HCW in REORD seq, this is RENQ/RENQ_T, 
   if(hqmproc_frag_ctrl>0 && get_ordered && temp_frag_num==temp_frag_cnt && temp_frag_last==0)  is_last_comp=1;                           //-- this is the last HCW in REORD seq, this is COMP/COMP_T, 

   if(hqmproc_frag_ctrl>0 && get_ordered && use_frag && hqmproc_enqctrl_sel_mode!=13) begin
      sel_frag=1; 
   end else begin
      sel_frag=0;
   end 

   //-- when cq_intr_service_state=2 state, return token loop has new_t/renq_t, flag such case
   if(sel_enq==1 && sel_tok==1) has_enq_rtn_mixed=1;

   `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1: %s PP %0d index=%0d; hcw_ready=%0d new_hcw_en=%0d num_hcw=%0d; cq_intr_service_state=%0d pend_cq_int_arm.size=%0d; pend_cq_token_return=%0d cq_intr_rtntok_num=%0d has_enq_rtn_mixed=%0d cq_intr_enq_num=%0d pend_cq_int_arm=%0d;  pend_comp_return=%0d pend_a_comp_return=%0d cq_comp_service_state=%0d;  cq_poll_interval=%0d out_of_credit=%0d illegal_credit_prob=%0d; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_a_cmp=%0d;sel_frag=%0d;)) sel_renq=%0d, get_ordered=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d use_lastfrag_renq=%0d use_frag=%0d, is_last_reord=%0d is_last_comp=%0d, is_ternimate_comp=%0d; hqmproc_trfctrl_sel_mode=%0d, hqmproc_enqctrl_sel_mode=%0d hqmproc_trfgen_stop=%0d has_trfenq_enable=%0d; hqmproc_stream_flowctrl=%0d strenq_cnt=%0d strenq_num=%0d; cq_intr_occ_tim_state=%0d hqmproc_rtntokctrl_keepnum=%0d; hqmproc_rtntokctrl_rtnnum_on=%0d; cq_intr_service_cqirq_rearm_hold=%0d cqirq_mask_ena=%0d cqirq_mask_run=%0d cqirq_mask_opt=%0d pend_hcw_trans_queue_index=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,hcw_ready,new_hcw_en,queue_list[queue_list_index].num_hcw, cq_intr_service_state, pend_cq_int_arm.size(), pend_cq_token_return_size, cq_intr_rtntok_num, has_enq_rtn_mixed, cq_intr_enq_num, pend_cq_int_arm.size(),pend_comp_return_size, pend_a_comp_return_size, cq_comp_service_state, cq_poll_interval, out_of_credit, queue_list[queue_list_index].illegal_credit_prob, sel_enq, sel_tok, sel_arm, sel_cmp, sel_a_cmp, sel_frag, sel_renq, get_ordered, temp_frag_num, temp_frag_cnt, temp_frag_last, use_lastfrag_renq, use_frag, is_last_reord, is_last_comp, is_ternimate_comp, hqmproc_trfctrl_sel_mode, hqmproc_enqctrl_sel_mode, hqmproc_trfgen_stop, has_trfenq_enable, hqmproc_stream_flowctrl, strenq_cnt, strenq_num, cq_intr_occ_tim_state, hqmproc_rtntokctrl_keepnum, hqmproc_rtntokctrl_rtnnum_on, cq_intr_service_cqirq_rearm_hold, cqirq_mask_ena, cqirq_mask_run, cqirq_mask_opt, pend_hcw_trans_queue_index),UVM_MEDIUM)

  if(hqmproc_frag_ctrl==9 || hqmproc_frag_ctrl==10 || hqmproc_frag_ctrl==11) begin
     //--trying to interleave frag and new
     if(sel_enq==1 && sel_cmp==1 && sel_frag==1 && $urandom_range(1,0) == 1) begin
          sel_frag=0;
          sel_cmp=0;  //--note: 
          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_interleave_NEW_and_FRAG: %s PP %0d index=%0d hcw_ready=%0d new_hcw_en=%0d pend_cq_token_return=%0d pend_cq_int_arm=%0d pend_comp_return=%0d cq_poll_interval=%0d out_of_credit=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) sel_renq=%0d, get_ordered=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d use_lastfrag_renq=%0d use_frag=%0d, is_last_reord=%0d is_last_comp=%0d, is_ternimate_comp=%0d, hqmproc_trfctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,hcw_ready,new_hcw_en,pend_cq_token_return_size,pend_cq_int_arm.size(),pend_comp_return_size, cq_poll_interval, out_of_credit, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, sel_renq, get_ordered, temp_frag_num, temp_frag_cnt, temp_frag_last, use_lastfrag_renq, use_frag, is_last_reord, is_last_comp, is_ternimate_comp, hqmproc_trfctrl_sel_mode),UVM_MEDIUM)
     end 
  end 

  
  //--------------------------
  //-- Support WU Direct test
  //--------------------------
  if(has_ldb_sch_cnt_check==0 && sel_cmp==1) begin
     i_hqm_pp_cq_status.get_curr_ldbcq_sch_num(pp_cq_num, curr_sch_num);
     has_ldb_sch_cnt_check=1;
     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_WU_SCH_CNT_CK: %s PP %0d index=%0d (selenq=%0d_tok=%0d_arm=%0d_cmp=%0d) curr_sch_num=%0d has_ldb_sch_cnt_check=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, curr_sch_num, has_ldb_sch_cnt_check),UVM_MEDIUM)
  end 
 
   
  //---------------------------------------------------
  //-- Generate HCW cmd 
  //---------------------------------------------------      
   if(hqmproc_acomp_ctrl >0 && sel_a_cmp==1)begin
        send_hcw            = 1;
        cmd_type            = A_COMP_CMD;
        pend_a_comp_return.pop(is_ordered);
        cq_comp_service_state = 1;
        is_reorded          = saved_is_ordered;     

        //saved_is_ordered    = is_reorded;
       
        curr_frag_num  = temp_frag_num;
        curr_frag_cnt  = temp_frag_cnt;
        curr_frag_last = temp_frag_last;

        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_A_COMP_CMDSEND_hqmproc_acomp_ctrl=%0d: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d; curr_frag_num=%0d curr_frag_cnt=%0d curr_frag_last=%0d",hqmproc_acomp_ctrl, pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state,curr_frag_num, curr_frag_cnt, curr_frag_last),UVM_MEDIUM)

   end else begin
      case ({sel_enq,sel_tok,sel_arm,sel_cmp,sel_frag})
           5'b00000: begin
    	       cmd_type                = NOOP_CMD;
    
               //-- cq_intr_service_cqirq_rearm_hold when 1: rearm is on-hold
               //--deal with cq_int_mask / unmask interactive flow, 
               //--it does: 1/ENQ N ;  (cq_intr_service_state=0)
               //--         2/return N tokens;  (cq_intr_service_state=2)
               //--           when sending tokens, don't change cq_intr_service_state=3, instead, it does the following interactive opt with cfg 
               //--           if(cq_intr_mask_ena=0) cq_inter_mask_ena=1 to allow cfg flow run
               //--           wait for cq_intr_mask_run=1, which means cfg re-programming is done
               //--                                        then change cq_intr_service_state=3 and put pend_cq_int_arm.push_front(1);
               if(pp_cq_type == IS_LDB) begin
                  cqirq_mask_opt = hqmproc_cqirq_mask_ena? i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask_opt : 0; 
                  cqirq_mask_ena = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask_ena; 
                  cqirq_mask_run = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask_run; 
                  cqirq_mask_on_bit = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask;                 
               end else begin
                  cqirq_mask_opt = hqmproc_cqirq_mask_ena? i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask_opt : 0; 
                  cqirq_mask_ena = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask_ena; 
                  cqirq_mask_run = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask_run; 
                  cqirq_mask_on_bit = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask;                 
               end 
    
               if(hqmproc_cqirq_mask_ena==1 && cq_intr_service_cqirq_rearm_hold==1) begin
                    cqirq_mask_issue_rearm = 0;
                    cq_intr_recved = 0; 
    
                    //-- set cq_int_mask_ena=1
                    if(cqirq_mask_ena==0) begin
                        if (pp_cq_type == IS_LDB) i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask_ena = 1;
                        else                      i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask_ena = 1;
                    end 
    
                    if(cqirq_mask_run == 1 || cqirq_mask_opt == 0) begin
                        cqirq_mask_issue_rearm = 1;                 
                    end else if(cqirq_mask_run == 2) begin
                        hqmproc_intr_check_task(cq_intr_recved); 
                        if(cq_intr_recved)  cqirq_mask_issue_rearm = 1; 
                    end 
    
                    //`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_NOOP_cq_intr_service_cqirq_rearm_hold_1: %s PP %0d index=%0d cqirq_mask_on_bit=%0d cqirq_mask_ena=%0d cqirq_mask_run=%0d cqirq_mask_opt=%0d:: cq_intr_recved=%0d cqirq_mask_issue_rearm=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cqirq_mask_on_bit, cqirq_mask_ena, cqirq_mask_run, cqirq_mask_opt, cq_intr_recved, cqirq_mask_issue_rearm),UVM_MEDIUM)
    
                    if(cqirq_mask_issue_rearm) begin
                       //--rearm required 
                       if(cq_token_return>0 && cq_intr_service_state==1) begin
                          cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                          pend_cq_int_arm.push_front(1);
                          cq_intr_service_cqirq_rearm_hold = 0;
                       end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                          cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                          pend_cq_int_arm.push_front(1);
                          cq_intr_service_cqirq_rearm_hold = 0;
                       end 
    
                       //-- clear cq_int_mask_run
                       if (pp_cq_type == IS_LDB) begin //pp_cq_num
                           i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_mask_run = 0 ;                 
                       end else begin
                           i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_mask_run = 0 ;                 
                       end            
                      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_NOOP_cq_intr_service_cqirq_rearm_hold_0: %s PP %0d index=%0d cq_intr_service_state=%0d rearm ready;  cqirq_mask_on_bit=%0d cqirq_mask_ena=%0d cqirq_mask_run=%0d cqirq_mask_opt=%0d:: cq_intr_recved=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cq_intr_service_state, cqirq_mask_on_bit, cqirq_mask_ena, cqirq_mask_run, cqirq_mask_opt, cq_intr_recved),UVM_MEDIUM)
                    end 
               end //--if(hqmproc_cqirq_mask_ena=
           end //-- 5'b00000
           
           5'b10011: begin  
               //--is_last_comp=1 terminate reord
               if(is_last_comp) begin
                  if(sel_a_cmp==1) begin
            	     send_hcw            = 1;
            	     cmd_type            = A_COMP_CMD;
                     pend_a_comp_return.pop(is_ordered);
                     cq_comp_service_state = 1;
            	     is_reorded          = 1;     
                    `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                  end else begin
            	     //--terminate it with COMP_CMD	   
                     send_hcw            = 1;
                     cmd_type            = COMP_CMD;
                     pend_comp_return.pop(is_ordered);
                     cq_comp_service_state = 0;
                     is_reorded          = 1;         
                     temp_frag_last=1;//--force 
                     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_Terminated_by_COMP: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), force frag_last=1, frag_cnt=frag_num ",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag),UVM_MEDIUM)
                 end 
            	 	   
               end else begin	   	             
                  //--FRAG when there is credit       
                  if (hcw_ready) begin
                     if(is_last_reord) begin
                        if(sel_a_cmp==1) begin
                           send_hcw            = 1;
                           is_reorded          = 1;         
                           cmd_type            = A_COMP_CMD;
                           pend_a_comp_return.pop(is_ordered);  
                           cq_comp_service_state = 1;
                           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
    
                        end else begin
            	           if (out_of_credit == 1'b0) begin 
            	              i_hqm_pp_cq_status.wait_for_vas_credit(vas);
            	           end 
    
            	           get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, renq_qid, total_genenq_count, enqhcw_qid_use); 
            	           get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, renq_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      

                           send_hcw            = 1;
                           is_reorded          = 1;         
                           cmd_type            = RENQ_CMD;
                           pend_comp_return.pop(is_ordered);  
                           cq_comp_service_state = 0;
    
                           temp_frag_cnt++;
                           temp_frag_last=1;
                           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_Terminated_by_RENQ: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), frag_num=%0d frag_cnt=%0d frag_last=%0d, enqhcw_qid=0x%0x enqhcw_qtype=%0s ",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, temp_frag_num, temp_frag_cnt, temp_frag_last, enqhcw_qid, enqhcw_qtype.name()),UVM_MEDIUM)
                        end 
    		 
                     end else begin 
            	        if (out_of_credit == 1'b0) begin 
            	            i_hqm_pp_cq_status.wait_for_vas_credit(vas);
            	        end 
    
            	        get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, renq_qid, total_genenq_count, enqhcw_qid_use); 
            	        get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, renq_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      


                        send_hcw            = 1;
                        is_reorded          = 1;         
                        cmd_type            = FRAG_CMD;
    
                        temp_frag_cnt++;
                        temp_frag_last=0;
                        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_FRAG: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), frag_num=%0d frag_cnt=%0d frag_last=%0d, enqhcw_qid=0x%0x enqhcw_qtype=%0s ",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, temp_frag_num, temp_frag_cnt, temp_frag_last, enqhcw_qid, enqhcw_qtype.name()),UVM_MEDIUM)
                     end //--if(is_last_reord		   
                  end else begin
                     //--When there is no credit for FRAG, simply terminate it with COMP_CMD	   
                     if(sel_a_cmp==1) begin
                        send_hcw            = 1;
                        cmd_type            = A_COMP_CMD;
                        pend_a_comp_return.pop(is_ordered);
                        cq_comp_service_state = 1;
                        is_reorded          = 1;         
                       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d; currently no credit, terminate the flow)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                     end else begin
                        send_hcw            = 1;
                        cmd_type            = COMP_CMD;
                        pend_comp_return.pop(is_ordered);
                        cq_comp_service_state = 0;
                        is_reorded          = 1;         
                        temp_frag_last=1;//--force 
                        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_FRAG_Terminated_by_COMP_OOC: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), force frag_last=1, frag_cnt=frag_num ",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag),UVM_MEDIUM)
                        temp_frag_cnt=temp_frag_num; //--force	     
                     end 
                  end 
               end 	      
           end  //-- 5'b10011     

           5'b11011: begin  
               //--is_last_comp=1 terminate reord
               if(is_last_comp) begin
                  //--terminate it with COMP_T_CMD	
                  if(sel_a_cmp==1) begin
                     send_hcw            = 1;
            	     cmd_type            = A_COMP_T_CMD;
            	     is_reorded          = 1;         
            	     pend_a_comp_return.pop(is_ordered);
                     cq_comp_service_state = 1;
                    `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                  end else begin
                     send_hcw            = 1;
            	     cmd_type            = COMP_T_CMD;
            	     is_reorded          = 1;         
            	     temp_frag_last=1; 		 
            	     pend_comp_return.pop(is_ordered);
                     cq_comp_service_state = 0;
                  end     
    
            	  if (cq_poll_interval > 0) begin
            	      cq_token_return     = 0;
            	      while ((pend_cq_token_return_size > hqmproc_rtntokctrl_keepnum) && (cq_token_return < 1024)) begin
                          cq_token_return++;
                          pend_cq_token_return.pop(ret_val);
                          pend_cq_token_return.size(pend_cq_token_return_size);
                          cq_intr_rtntok_num --;
                          if(hqmproc_rtntokctrl_rtnnum_on==1 && cq_token_return == hqmproc_rtntokctrl_rtnnum_val) begin
                             break;
                          end 
                          if(cq_intr_service_state==2 && has_enq_rtn_mixed==1) begin
                             break;
                          end 
            	      end 
    
                      //--rearm required
                      if(cq_token_return>0 && cq_intr_service_state==1) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
                      end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
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
    		  
                  if(sel_a_cmp==1) begin
                  end else begin
                     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_Terminated_by_COMP_T: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), force frag_last=1, frag_cnt=frag_num; cq_token_return=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, cq_token_return),UVM_MEDIUM)
                  end 

               end else begin
               //if(is_last_comp==0
                   //--FRAG_T when there is credit       
                   if (hcw_ready) begin
                     if(is_last_reord) begin
                        if(sel_a_cmp==1) begin
            	           send_hcw            = 1;
            	           is_reorded          = 1;     
                           cmd_type            = A_COMP_CMD;
            	           pend_a_comp_return.pop(is_ordered);		    
                           cq_comp_service_state = 1;
                          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                        end else begin
            	           if (out_of_credit == 1'b0) begin 
            	              i_hqm_pp_cq_status.wait_for_vas_credit(vas);
            	           end 
    
            	           get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, renq_qid, total_genenq_count, enqhcw_qid_use); 
            	           get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, renq_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use); 

            	           send_hcw            = 1;
            	           is_reorded          = 1;     
           		   if (cq_poll_interval > 0) begin
                    	      cmd_type                  = RENQ_T_CMD;
                      	      cq_token_return           = 1;
                    	      pend_cq_token_return.pop(ret_val);
                              pend_cq_token_return.size(pend_cq_token_return_size);
                              cq_intr_rtntok_num --;
    
                              //--rearm required 
                              if(cq_token_return>0 && cq_intr_service_state==1) begin
                                 cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                                 pend_cq_int_arm.push_front(1);
                              end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                                 cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                                 pend_cq_int_arm.push_front(1);
                              end 
           		   end else begin
                    	      cmd_type         = RENQ_CMD;
           		   end 
        
            	           pend_comp_return.pop(is_ordered);		    
                           cq_comp_service_state = 0;
    		     
            	           temp_frag_cnt++;
            	           temp_frag_last=1;
            	          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_Terminated_by_RENQ_T: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), frag_num=%0d frag_cnt=%0d frag_last=%0d, enqhcw_qid=0x%0x enqhcw_qtype=%0s ",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, temp_frag_num, temp_frag_cnt, temp_frag_last, enqhcw_qid, enqhcw_qtype.name()),UVM_MEDIUM)
                        end //--if(sel_a_cmp==1) begin
    		 
                     end else begin 	       
                       //--is_last_reord=0
            	         if (out_of_credit == 1'b0) begin 
            	              i_hqm_pp_cq_status.wait_for_vas_credit(vas);
            	         end 
    
            	         get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, renq_qid, total_genenq_count, enqhcw_qid_use); 
            	         get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, renq_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use); 

            	         send_hcw            = 1;
            	         is_reorded          = 1;         
    
           		 if (cq_poll_interval > 0 && hqmproc_frag_t_ctrl==1) begin
                    	    cmd_type                  = FRAG_T_CMD;
                    	    cq_token_return           = 1;
                            pend_cq_token_return.pop(ret_val);
                            pend_cq_token_return.size(pend_cq_token_return_size);
                            cq_intr_rtntok_num --;
    
                            //--rearm required 
                            if(cq_token_return>0 && cq_intr_service_state==1) begin
                               cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                               pend_cq_int_arm.push_front(1);
                            end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                               cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                               pend_cq_int_arm.push_front(1);
                            end 
           		 end else begin
                    	    cmd_type         = FRAG_CMD;
           		 end 
            	         temp_frag_cnt++;
            	         temp_frag_last=0;
            	        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_FRAG_T: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), frag_num=%0d frag_cnt=%0d frag_last=%0d, enqhcw_qid=0x%0x enqhcw_qtype=%0s, cq_token_return=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, temp_frag_num, temp_frag_cnt, temp_frag_last, enqhcw_qid, enqhcw_qtype.name(), cq_token_return),UVM_MEDIUM)
                     end //--if(is_last_reord) 
    
                   end else begin
            	      //--When there is no credit for FRAG, simply terminate it with COMP_T_CMD	   
                      if(sel_a_cmp==1) begin
            	         send_hcw            = 1;
            	         cmd_type            = A_COMP_T_CMD;
            	         pend_a_comp_return.pop(is_ordered);
                         cq_comp_service_state = 1;
            	         is_reorded          = 1; 
                      end else begin
            	         send_hcw            = 1;
            	         cmd_type            = COMP_T_CMD;
            	         pend_comp_return.pop(is_ordered);
                         cq_comp_service_state = 0;
            	         temp_frag_cnt=temp_frag_num; //--force	     
            	         is_reorded          = 1;         
            	         temp_frag_last=1;//--force 
                      end 
    
            	      if (cq_poll_interval > 0) begin
            	            cq_token_return     = 0;
            	            while ((pend_cq_token_return_size > hqmproc_rtntokctrl_keepnum) && (cq_token_return < 1024)) begin
                               cq_token_return++;
                               pend_cq_token_return.pop(ret_val);
                               pend_cq_token_return.size(pend_cq_token_return_size);
                               cq_intr_rtntok_num --;
                               if(hqmproc_rtntokctrl_rtnnum_on==1 && cq_token_return == hqmproc_rtntokctrl_rtnnum_val) begin
                                  break;
                               end 
                               if(cq_intr_service_state==2 && has_enq_rtn_mixed==1) begin
                                  break;
                               end 
            	            end //--while
                            //--rearm required 
                            if(cq_token_return>0 && cq_intr_service_state==1) begin
                               cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                               pend_cq_int_arm.push_front(1);
                            end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                               cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                               pend_cq_int_arm.push_front(1);
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
    
                      if(sel_a_cmp==1) 
                         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d; cq_token_return=%0d; currently no credit, terminate the flow)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, cq_token_return, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                      else
            	         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_FRAG_Terminated_by_COMP_OOC: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) cq_token_return=%0d, force frag_last=1, frag_cnt=frag_num ",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, cq_token_return),UVM_MEDIUM)
                   end //if (hcw_ready) 
               end //--if(is_last_comp) 
           end //-- 5'b11011       
           
    
    
           5'b10001: begin               
                  //--FRAG when there is credit       
                  if (hcw_ready) begin
   
                     if(is_last_reord) begin
                        if(sel_a_cmp==1) begin
            	           send_hcw            = 1;
            	           is_reorded          = 1;         
            	           cmd_type            = A_COMP_CMD;
            	           pend_a_comp_return.pop(is_ordered);  
                           cq_comp_service_state = 1;
                          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                        end else begin
            	           if (out_of_credit == 1'b0) begin 
            	              i_hqm_pp_cq_status.wait_for_vas_credit(vas);
            	           end 
    
            	           get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, renq_qid, total_genenq_count, enqhcw_qid_use); 
            	           get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, renq_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      
 
            	           send_hcw            = 1;
            	           is_reorded          = 1;         
            	           cmd_type            = RENQ_CMD;
            	           pend_comp_return.pop(is_ordered);  
                           cq_comp_service_state = 0;
    
            	           temp_frag_cnt++;
            	           temp_frag_last=1;
            	          `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_Terminated_by_RENQ: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), frag_num=%0d frag_cnt=%0d frag_last=%0d, enqhcw_qid=0x%0x enqhcw_qtype=%0s ",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, temp_frag_num, temp_frag_cnt, temp_frag_last, enqhcw_qid, enqhcw_qtype.name()),UVM_MEDIUM)
                        end 
    		 
                     end else begin 
            	        if (out_of_credit == 1'b0) begin 
            	           i_hqm_pp_cq_status.wait_for_vas_credit(vas);
            	        end 
    
            	        get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, renq_qid, total_genenq_count, enqhcw_qid_use); 
            	        get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, renq_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      
 
                        send_hcw            = 1;
                        is_reorded          = 1;         
                        cmd_type            = FRAG_CMD;  
    
                        temp_frag_cnt++;
                        temp_frag_last=0;
                        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_FRAG: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), frag_num=%0d frag_cnt=%0d frag_last=%0d, enqhcw_qid=0x%0x enqhcw_qtype=%0s ",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, temp_frag_num, temp_frag_cnt, temp_frag_last, enqhcw_qid, enqhcw_qtype.name()),UVM_MEDIUM)
                     end 		   
                  end else begin
            	     //--When there is no credit for FRAG, simply terminate it with COMP_CMD	   
                     if(sel_a_cmp==1) begin
                        send_hcw            = 1;
                        cmd_type            = A_COMP_CMD;
                        pend_a_comp_return.pop(is_ordered);
                        cq_comp_service_state = 1;
                        is_reorded          = 1;         
                       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                     end else begin
                        send_hcw            = 1;
                        cmd_type            = COMP_CMD;
                        pend_comp_return.pop(is_ordered);
                        cq_comp_service_state = 0;
                        is_reorded          = 1;         
                        temp_frag_last=1;//--force 
                        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_FRAG_Terminated_by_COMP_OOC: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), force frag_last=1, frag_cnt=frag_num ",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag),UVM_MEDIUM)
                        temp_frag_cnt=temp_frag_num; //--force
                     end	     
                  end      
           end //-- 5'b10001
      
           5'b11001: begin 
                   //--FRAG_T when there is credit       
                   if (hcw_ready) begin 
                      if(is_last_reord) begin
                         if(sel_a_cmp==1) begin
            	            send_hcw            = 1;
            	            is_reorded          = 1;     
                            cmd_type            = A_COMP_CMD;
            	            pend_a_comp_return.pop(is_ordered);		    
                            cq_comp_service_state = 1;
                           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                         end else begin
                            if (out_of_credit == 1'b0) begin 
            	               i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                            end 
    
                            get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, renq_qid, total_genenq_count, enqhcw_qid_use); 
                            get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, renq_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      
    

            	            send_hcw            = 1;
            	            is_reorded          = 1;     
           		    if (cq_poll_interval > 0) begin
                    	       cmd_type                  = RENQ_T_CMD;
                      	       cq_token_return           = 1;
                      	       pend_cq_token_return.pop(ret_val);
                               pend_cq_token_return.size(pend_cq_token_return_size);
                               cq_intr_rtntok_num --;
    
                              //--rearm required 
                              if(cq_token_return>0 && cq_intr_service_state==1) begin
                                 cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                                 pend_cq_int_arm.push_front(1);
                              end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                                 cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                                 pend_cq_int_arm.push_front(1);
                              end 
    
           		    end else begin
                    	        cmd_type         = RENQ_CMD;
           		    end 
        
            	            pend_comp_return.pop(is_ordered);		    
                            cq_comp_service_state = 0;
    		     
            	            temp_frag_cnt++;
            	            temp_frag_last=1;
            	           `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_Terminated_by_RENQ_T: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), frag_num=%0d frag_cnt=%0d frag_last=%0d, enqhcw_qid=0x%0x enqhcw_qtype=%0s ",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, temp_frag_num, temp_frag_cnt, temp_frag_last, enqhcw_qid, enqhcw_qtype.name()),UVM_MEDIUM)
                         end //if(sel_a_cmp==1) begin
                      end else begin 	   
                          //--is_last_reord==0--//
                          if (out_of_credit == 1'b0) begin 
            	               i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                          end 
    
                          get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, renq_qid, total_genenq_count, enqhcw_qid_use); 
                          get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, renq_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      
    
    
            	          send_hcw            = 1;
            	          is_reorded          = 1;         
    
           		  if (cq_poll_interval > 0 && hqmproc_frag_t_ctrl==1) begin
                             cmd_type                  = FRAG_T_CMD;
                             cq_token_return           = 1;
                             pend_cq_token_return.pop(ret_val);
                             pend_cq_token_return.size(pend_cq_token_return_size);
                             cq_intr_rtntok_num --;
    
                             //--rearm required 
                             if(cq_token_return>0 && cq_intr_service_state==1) begin
                                cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                                pend_cq_int_arm.push_front(1);
                             end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                                cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                                pend_cq_int_arm.push_front(1);
                             end 
           		  end else begin    
                    	     cmd_type         = FRAG_CMD;
           		  end 
    
            	          temp_frag_cnt++;
            	          temp_frag_last=0;
            	         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_FRAG_T: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), frag_num=%0d frag_cnt=%0d frag_last=%0d, enqhcw_qid=0x%0x enqhcw_qtype=%0s, cq_token_return=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, temp_frag_num, temp_frag_cnt, temp_frag_last, enqhcw_qid, enqhcw_qtype.name(), cq_token_return),UVM_MEDIUM)
                      end //--if(is_last_reord) 
                   end else begin
                      // (hcw_ready==0)  
            	      //--When there is no credit for FRAG, simply terminate it with COMP_T_CMD	   
                      if(sel_a_cmp==1) begin
            	          send_hcw            = 1;
            	          cmd_type            = A_COMP_T_CMD;
            	          pend_a_comp_return.pop(is_ordered);
                          cq_comp_service_state = 1;
            	          is_reorded          = 1;         
                      end else begin
            	          send_hcw            = 1;
            	          cmd_type            = COMP_T_CMD;
            	          pend_comp_return.pop(is_ordered);
                          cq_comp_service_state = 0;
            	          is_reorded          = 1;         
            	          temp_frag_cnt=temp_frag_num; //--force	     
            	          temp_frag_last=1;//--force 
                      end 
    
            	      if (cq_poll_interval > 0) begin
            	          cq_token_return     = 0;
            	          while ((pend_cq_token_return_size > hqmproc_rtntokctrl_keepnum) && (cq_token_return < 1024)) begin
                              cq_token_return++;
                              pend_cq_token_return.pop(ret_val);
                              pend_cq_token_return.size(pend_cq_token_return_size);
                              cq_intr_rtntok_num --;
                              if(hqmproc_rtntokctrl_rtnnum_on==1 && cq_token_return == hqmproc_rtntokctrl_rtnnum_val) begin
                                 break;
                              end 
                              if(cq_intr_service_state==2 && has_enq_rtn_mixed==1) begin
                                 break;
                              end 
            	          end //--while
                          //--rearm required 
                          if(cq_token_return>0 && cq_intr_service_state==1) begin
                              cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                              pend_cq_int_arm.push_front(1);
                          end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                              cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                              pend_cq_int_arm.push_front(1);
                          end 
            	      end else begin
            	          pend_cq_token_return.pop(ret_val);
            	          cq_token_return     = ret_val;
    
            	          // only issue CQ interrupt ARM command if all tokens have been returned
            	          pend_cq_token_return.abs_size(pend_cq_token_return_size);
            	          if (pend_cq_token_return_size == 0) begin
                              pend_cq_int_arm.push_front(1);
            	          end 
            	      end //--if (cq_poll_interval > 0)
    
                      if(sel_a_cmp==1) 
                         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d; cq_token_return=%0d; currently no credit, terminate the flow)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, cq_token_return, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                      else 
                         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_REORD_FRAG_Terminated_by_COMP_OOC: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) cq_token_return=%0d, force frag_last=1, frag_cnt=frag_num ",pp_cq_type.name(),pp_cq_num,queue_list_index, sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, cq_token_return),UVM_MEDIUM)
                   end //--if (hcw_ready)  
                      
           end //-- 5'b11001       
                  
           5'b00010: begin
    	        is_ordered = pend_comp_return.data_q[0];
    
    	        if (is_ordered) begin
                   if(sel_a_cmp==1) begin
                      send_hcw            = 1;
                      cmd_type            = A_COMP_CMD;
                      pend_a_comp_return.pop(is_ordered);
                      cq_comp_service_state = 1;
                     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                   end else begin
                      if (hcw_ready && sel_renq && $urandom_range(1,0) == 0) begin
                         send_hcw            = 1;
                         cmd_type            = RENQ_CMD;
                         pend_comp_return.pop(is_ordered);
                         cq_comp_service_state = 0;
    
                         get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, enqhcw_qid, total_genenq_count, enqhcw_qid_use); 
                         get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, enqhcw_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      
    
                         if (out_of_credit == 1'b0) begin 
              	            i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                         end 
                      end else begin
                         if(is_ternimate_comp) begin
             	            is_reorded=1;         
            	            temp_frag_last=1;  //-- terminate reord
                         end 
                         send_hcw            = 1;
                         cmd_type            = COMP_CMD;
                         pend_comp_return.pop(is_ordered);
                         cq_comp_service_state = 0;
                      end 
                   end //--if(sel_a_cmp==1
    	        end else if(hqmproc_trfctrl_sel_mode!=6) begin
                   send_hcw              = 1;
                   cmd_type              = COMP_CMD;
                   pend_comp_return.pop(is_ordered);
                   cq_comp_service_state = 0;
    	        end  //--if (is_ordered)
           end //-- 5'b00010
    
    
           5'b00100,5'b01100: begin  
    	        send_hcw                = 1;
    	        cmd_type                = ARM_CMD;
    	        pend_cq_int_arm.pop_front();
                cq_intr_service_state   = 0; 
                if(hqmproc_cq_rearm_ctrl[4]==1 && cq_intr_occ_tim_state==0) cq_intr_occ_tim_state = 1;
                else                                                        cq_intr_occ_tim_state = 0;
           end 
    
    
           5'b00110,5'b01110: begin  
    	        if (hqmproc_trfctrl_sel_mode==4) begin
                   send_hcw            = 1;
                   pend_comp_return.pop(is_ordered);
                   cq_comp_service_state = 0;
                   cmd_type            = COMP_CMD;
    	        end else if (($urandom_range(1,0) == 0 && hqmproc_trfctrl_sel_mode!=6)  || hqmproc_trfctrl_sel_mode==3) begin
                   is_ordered = pend_comp_return.data_q[0];
    
                   if (is_ordered) begin
                      if(sel_a_cmp==1) begin
                         send_hcw            = 1;
                         pend_a_comp_return.pop(is_ordered);
                         cq_comp_service_state = 1;
                         cmd_type            = A_COMP_CMD;
                        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                      end else begin 
                         if (hcw_ready && sel_renq && $urandom_range(1,0) == 0) begin
                            send_hcw            = 1;
                            pend_comp_return.pop(is_ordered);
                            cq_comp_service_state = 0;
                            cmd_type            = RENQ_CMD;
    
                            get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, enqhcw_qid, total_genenq_count, enqhcw_qid_use); 
                            get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, enqhcw_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      
    
                            if (out_of_credit == 1'b0) begin 
            	                i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                            end 
                         end else if(sel_renq == 0 || $urandom_range(1,0) == 1) begin
                            send_hcw            = 1;
                            pend_comp_return.pop(is_ordered);
                            cq_comp_service_state = 0;
                            cmd_type            = COMP_CMD;
                            if(is_ternimate_comp) begin
              	                is_reorded=1;         
            	                temp_frag_last=1;  //-- terminate reord
                            end 
                         end else begin
                            is_ordered          = 0;
                            send_hcw            = 1;
                            cmd_type            = ARM_CMD;
                            pend_cq_int_arm.pop_front();
                            cq_intr_service_state   = 0; 
                            if(hqmproc_cq_rearm_ctrl[4]==1 && cq_intr_occ_tim_state==0) cq_intr_occ_tim_state = 1;
                            else                                                        cq_intr_occ_tim_state = 0;
                         end 
                      end //if(sel_a_cmp==1) 
                   end else begin
                      send_hcw              = 1;
                      cmd_type              = COMP_CMD;
                      pend_comp_return.pop(is_ordered);
                      cq_comp_service_state = 0;
                   end //--if (is_ordered) 
    	        end else begin
                   send_hcw                = 1;
                   cmd_type                = ARM_CMD;
                   pend_cq_int_arm.pop_front();
                   cq_intr_service_state   = 0; 
                   if(hqmproc_cq_rearm_ctrl[4]==1 && cq_intr_occ_tim_state==0) cq_intr_occ_tim_state = 1;
                   else                                                        cq_intr_occ_tim_state = 0;
    	        end //--if (hqmproc_trfctrl_sel_mode==4)
           end //-- 5'b00110,5'b01110

           5'b01000: begin
             if(hqmproc_trfctrl_sel_mode!=6) begin
    	          send_hcw                = 1;
    	          cmd_type                = BAT_T_CMD;
    
    	          if (cq_poll_interval > 0) begin
                     cq_token_return         = 0;
                     while ((pend_cq_token_return_size > hqmproc_rtntokctrl_keepnum) && (cq_token_return < 1024)) begin
                         cq_token_return++;
                         pend_cq_token_return.pop(ret_val);
                         if(cq_intr_service_state==2 && has_enq_rtn_mixed==1) begin
                             //-- when doing cial interactive flow, if has_enq_rtn_mixed=1, ENQ with token returen is used in the return (all N tokens) loop, in BAT_T cmd, return only one token at a time also
                         end else if(hqmproc_rtntokctrl_sel_mode==7) begin
                             //-- only return one token in this mode (scen7, tdt=1 case)
                         end else begin
                             pend_cq_token_return.size(pend_cq_token_return_size);
                         end 
                         cq_intr_rtntok_num --;
    
                         //--when i_hqm_cfg.hqmproc_ldb_tokctrl[] / i_hqm_cfg.hqmproc_dir_tokctrl[] mode is 2, interactive on/off controlled by hcw_enqtrd_tests_hcw_seq.sv
                         if (pp_cq_type == IS_LDB) begin
                             if(i_hqm_cfg.hqmproc_ldb_tokctrl[pp_cq_num]==2 && pend_cq_token_return_size>=i_hqm_cfg.hqmproc_ldb_toknum[pp_cq_num]) i_hqm_cfg.hqmproc_ldb_tokctrl[pp_cq_num]=0;
                         end else begin
                             if(i_hqm_cfg.hqmproc_dir_tokctrl[pp_cq_num]==2 && pend_cq_token_return_size>=i_hqm_cfg.hqmproc_dir_toknum[pp_cq_num]) i_hqm_cfg.hqmproc_dir_tokctrl[pp_cq_num]=0;
                         end    
                         if(hqmproc_rtntokctrl_rtnnum_on==1 && cq_token_return == hqmproc_rtntokctrl_rtnnum_val) begin
                            break;
                         end 
                         if(cq_intr_service_state==2 && has_enq_rtn_mixed==1) begin
                            break;
                         end 
                         if(hqmproc_rtntokctrl_sel_mode==7) begin
                           //-- only return one token in this mode (scen7, tdt=1 case)
                            break;
                         end 
                     end //--while
    
                     if(cqirq_mask_opt==0) begin
                        cq_intr_service_cqirq_rearm_hold = 0; 
                        //--rearm required 
                        if(cq_token_return>0 && cq_intr_service_state==1) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
                        end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
                        end 
                     end else begin
                        cq_intr_service_cqirq_rearm_hold = 1; 
                     end 
    	          end else begin
                     pend_cq_token_return.pop(ret_val);
                     cq_token_return         = ret_val;
    
                     // only issue CQ interrupt ARM command if all tokens have been returned
                      pend_cq_token_return.abs_size(pend_cq_token_return_size);
                     if (pend_cq_token_return_size == 0) begin
                            pend_cq_int_arm.push_front(1);
                     end 
    	          end //-- if (cq_poll_interval > 0) 
             end //if(hqmproc_trfctrl_sel_mode!=6) 
           end //-- 5'b01000


           5'b01010: begin
             if(hqmproc_trfctrl_sel_mode!=6) begin
    	        is_ordered = pend_comp_return.data_q[0];
    
    	        if (is_ordered) begin
                   if(sel_a_cmp==1) begin
            	      send_hcw            = 1;
            	      pend_a_comp_return.pop(is_ordered);
                      cq_comp_service_state = 1;
            	      cmd_type              = A_COMP_CMD;
                     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
    
                   end else begin
                      if (hcw_ready && sel_renq && $urandom_range(1,0) == 0) begin 
            	          send_hcw            = 1;
            	          pend_comp_return.pop(is_ordered);
                          cq_comp_service_state = 0;
    
            	          if (cq_poll_interval > 0) begin
            	            cmd_type		      = RENQ_T_CMD;
            	            cq_token_return	      = 1;
            	            pend_cq_token_return.pop(ret_val);
                            pend_cq_token_return.size(pend_cq_token_return_size);
                            cq_intr_rtntok_num --;
    
                         	//--rearm required 
                         	if(cq_token_return>0 && cq_intr_service_state==1) begin
                         	  cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                         	  pend_cq_int_arm.push_front(1);
                         	end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                         	  cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                         	  pend_cq_int_arm.push_front(1);
                         	end 
            	          end else begin
            	             cmd_type		     = RENQ_CMD;
            	          end 
    
            	          get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, enqhcw_qid, total_genenq_count, enqhcw_qid_use); 
            	          get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, enqhcw_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      
    
            	          if (out_of_credit == 1'b0) begin 
                               i_hqm_pp_cq_status.wait_for_vas_credit(vas);
            	          end 
                      end else begin 
            	          send_hcw              = 1;
            	          cmd_type              = COMP_T_CMD;
            	          pend_comp_return.pop(is_ordered);
                          cq_comp_service_state = 0;
                          if(is_ternimate_comp) begin
              	             is_reorded=1;         
            	             temp_frag_last=1;  //-- terminate reord
                          end 
    
            	          if (cq_poll_interval > 0) begin
            	              cq_token_return     = 0;
            	              while ((pend_cq_token_return_size > hqmproc_rtntokctrl_keepnum) && (cq_token_return < 1024)) begin
            	                 cq_token_return++;
            	                 pend_cq_token_return.pop(ret_val);
            	                 pend_cq_token_return.size(pend_cq_token_return_size);
                                 cq_intr_rtntok_num --;
                                 if(hqmproc_rtntokctrl_rtnnum_on==1 && cq_token_return == hqmproc_rtntokctrl_rtnnum_val) begin
                                    break;
                                 end 
                                 if(cq_intr_service_state==2 && has_enq_rtn_mixed==1) begin
                                    break;
                                 end 
            	             end //--while
                             //--rearm required 
                             if(cq_token_return>0 && cq_intr_service_state==1) begin
                                  cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                                  pend_cq_int_arm.push_front(1);
                             end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                                 cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                                 pend_cq_int_arm.push_front(1);
                             end 
            	          end else begin
            	             pend_cq_token_return.pop(ret_val);
            	             cq_token_return     = ret_val;
    
            	             // only issue CQ interrupt ARM command if all tokens have been returned
            	             pend_cq_token_return.abs_size(pend_cq_token_return_size);
            	             if (pend_cq_token_return_size == 0) begin
            	                pend_cq_int_arm.push_front(1);
            	             end 
            	          end //--if (cq_poll_interval > 0) 
                      end //if (hcw_ready && sel_renq && $urandom_range(1,0) == 0)  
                   end //--if(sel_a_cmp==1) 
    
             
    	        end else begin
                    //-- is_ordered = 0
                    send_hcw              = 1;
                    cmd_type              = COMP_T_CMD;
                    pend_comp_return.pop(is_ordered);
                    cq_comp_service_state = 0;
    
                    if (cq_poll_interval > 0) begin
                       cq_token_return     = 0;
                       while ((pend_cq_token_return_size > hqmproc_rtntokctrl_keepnum) && (cq_token_return < 1024)) begin
                          cq_token_return++;
                          pend_cq_token_return.pop(ret_val);
                          pend_cq_token_return.size(pend_cq_token_return_size);
                          cq_intr_rtntok_num --;
                          if(hqmproc_rtntokctrl_rtnnum_on==1 && cq_token_return == hqmproc_rtntokctrl_rtnnum_val) begin
                             break;
                          end 
                          if(cq_intr_service_state==2 && has_enq_rtn_mixed==1) begin
                             break;
                          end 
                       end //--while 
    
                       if(cqirq_mask_opt==0) begin
                          cq_intr_service_cqirq_rearm_hold = 0; 
                          //--rearm required 
                          if(cq_token_return>0 && cq_intr_service_state==1) begin
                             cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                             pend_cq_int_arm.push_front(1);
                          end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                             cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                             pend_cq_int_arm.push_front(1);
                          end 
                       end else begin
                          cq_intr_service_cqirq_rearm_hold = 1; 
                       end //--if(cqirq_mask_opt==0) 
    
                    end else begin
                       pend_cq_token_return.pop(ret_val);
                       cq_token_return     = ret_val;
    
                       // only issue CQ interrupt ARM command if all tokens have been returned
                       pend_cq_token_return.abs_size(pend_cq_token_return_size);
                       if (pend_cq_token_return_size == 0) begin
                           pend_cq_int_arm.push_front(1);
                       end 
                    end //--if (cq_poll_interval > 0) 
    	        end //if (is_ordered) 
             end //--if(hqmproc_trfctrl_sel_mode!=6) 
           end //-- 5'b01010
    
    
           5'b10000: begin
               if(hqmproc_trfctrl_sel_mode!=6) begin 
    	          send_hcw                = 1;
               	  cmd_type                = NEW_CMD;
    
    	          if (out_of_credit == 1'b0) begin
                    i_hqm_pp_cq_status.wait_for_vas_credit(vas);
    	          end 
               end //--if(hqmproc_trfctrl_sel_mode!=6) 
           end //-- 5'b10000
    
    
           5'b10010: begin 
             if(hqmproc_trfctrl_sel_mode!=6) begin 
    	        if(hqmproc_trfctrl_sel_mode==1 || hqmproc_trfctrl_sel_mode==2  || hqmproc_trfctrl_sel_mode==5 || hqmproc_enqctrl_sel_mode==5) begin
                   if(sel_a_cmp==1) begin
            	      send_hcw              = 1;
            	      cmd_type              = A_COMP_CMD;
                      pend_a_comp_return.pop(is_ordered);	     
                      cq_comp_service_state = 1;
                     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state),UVM_MEDIUM)
                   end else begin
                      send_hcw              = 1;
                      cmd_type              = RENQ_CMD;
                      pend_comp_return.pop(is_ordered);	     
                      cq_comp_service_state = 0;
    
                      get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, enqhcw_qid, total_genenq_count, enqhcw_qid_use); 
                      get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, enqhcw_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      
    
            	      if (out_of_credit == 1'b0) begin
                          i_hqm_pp_cq_status.wait_for_vas_credit(vas);
            	      end 
                   end 
    	        end else begin          
    	           if(hqmproc_trfctrl_sel_mode==4) begin
                       if(sel_a_cmp==1) begin
            	          send_hcw              = 1;
            	          cmd_type              = A_COMP_CMD;
            	          pend_a_comp_return.pop(is_ordered);
                          cq_comp_service_state = 1;
                         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d hqmproc_trfctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state, hqmproc_trfctrl_sel_mode),UVM_MEDIUM)
                       end else begin
                          send_hcw              = 1;
                          cmd_type              = COMP_CMD;
                          pend_comp_return.pop(is_ordered);
                          cq_comp_service_state = 0;
                       end 
    
    	           end else if(($urandom_range(1,0))==0 || hqmproc_trfctrl_sel_mode==3) begin
                       is_ordered = pend_comp_return.data_q[0];
    
            	       if (is_ordered) begin
                          if(sel_a_cmp==1) begin
            	             send_hcw            = 1;
            	             cmd_type            = A_COMP_CMD;
            	             pend_a_comp_return.pop(is_ordered);
                             cq_comp_service_state = 1;
                          end else begin
            	             if (hcw_ready) begin
            	                send_hcw            = 1;
            	                cmd_type            = RENQ_CMD;
            	                pend_comp_return.pop(is_ordered);
                                cq_comp_service_state = 0;
    
                                get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, enqhcw_qid, total_genenq_count, enqhcw_qid_use); 
                                get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, enqhcw_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      
    
            	                if (out_of_credit == 1'b0) begin 
                    	           i_hqm_pp_cq_status.wait_for_vas_credit(vas);
            	                end 
            	            end //--if (hcw_ready
                          end //--if(sel_a_cmp==1) 
            	       end else begin
            	          send_hcw              = 1;
            	          cmd_type              = COMP_CMD;
            	          pend_comp_return.pop(is_ordered);
                          cq_comp_service_state = 0;
            	       end //--if (is_ordered) 
    	           end else begin
            	       send_hcw              = 1;
            	       cmd_type              = NEW_CMD;
    
            	       if (out_of_credit == 1'b0) begin
                          i_hqm_pp_cq_status.wait_for_vas_credit(vas);
            	       end 
    	           end //--if(hqmproc_trfctrl_sel_mode==4) 
    	        end //--if(hqmproc_trfctrl_sel_mode==1 || hqmproc_trfctrl_sel_mode==2  || hqmproc_trfctrl_sel_mode==5 || hqmproc_enqctrl_sel_mode==5) 
             end //--if(hqmproc_trfctrl_sel_mode!=6) 
           end //-- 5'b10010
    
    
           5'b10100,5'b11100: begin
    	       if ($urandom_range(1,0) == 0 && hqmproc_trfctrl_sel_mode!=6) begin
                   send_hcw                = 1;
                   cmd_type                = NEW_CMD;
    
                   if (out_of_credit == 1'b0) begin
            	      i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                   end 
               end else begin
                   send_hcw              = 1;
                   cmd_type              = ARM_CMD;
                   pend_cq_int_arm.pop_front();
                   cq_intr_service_state = 0; 
                   if(hqmproc_cq_rearm_ctrl[4]==1 && cq_intr_occ_tim_state==0) cq_intr_occ_tim_state = 1;
                   else                                                        cq_intr_occ_tim_state = 0;
    	       end 
           end 
    
    
           5'b10110,5'b11110: begin
             if(hqmproc_trfctrl_sel_mode==4) begin
                 if(sel_a_cmp==1) begin
            	  send_hcw            = 1;
            	  cmd_type            = A_COMP_CMD;
            	  pend_a_comp_return.pop(is_ordered);
                      cq_comp_service_state = 1;
                 end else begin
            	  send_hcw            = 1;
            	  cmd_type            = COMP_CMD;
            	  pend_comp_return.pop(is_ordered);
                      cq_comp_service_state = 0;
                 end 
             end else if(hqmproc_trfctrl_sel_mode!=6) begin
       	        case ($urandom_range(2,0))
                  0: begin
                    if(sel_a_cmp==1) begin
               	          send_hcw		 = 1;
               	          cmd_type		 = A_COMP_CMD;
               	          pend_a_comp_return.pop(is_ordered);
                          cq_comp_service_state = 1;
                         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)) is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d hqmproc_trfctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, is_ordered, is_reorded, cq_comp_service_state, hqmproc_trfctrl_sel_mode),UVM_MEDIUM)
                    end else begin
                       if(hqmproc_trfctrl_sel_mode==1 || hqmproc_trfctrl_sel_mode==2) begin
               	          send_hcw		 = 1;
               	          cmd_type		 = RENQ_CMD;
               	          pend_comp_return.pop(is_ordered);
                          cq_comp_service_state = 0;
                          get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, enqhcw_qid, total_genenq_count, enqhcw_qid_use); 
                	  get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, enqhcw_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      
               	          if (out_of_credit == 1'b0) begin
                             i_hqm_pp_cq_status.wait_for_vas_credit(vas);
               	          end	     
                       end else begin	  	
               	          is_ordered = pend_comp_return.data_q[0];
       
               	          if (is_ordered) begin
               	             if (hcw_ready) begin
               	                send_hcw            = 1;
               	                cmd_type            = RENQ_CMD;
               	                pend_comp_return.pop(is_ordered);
                                cq_comp_service_state = 0;
       
                                get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, enqhcw_qid, total_genenq_count, enqhcw_qid_use); 
                                get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, enqhcw_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);  
       
               	                if (out_of_credit == 1'b0) begin 
                       	           i_hqm_pp_cq_status.wait_for_vas_credit(vas);
               	                end 
               	             end //--if (hcw_ready
               	          end else begin
               	             send_hcw            = 1;
               	             cmd_type            = COMP_CMD;
               	             pend_comp_return.pop(is_ordered);
                             cq_comp_service_state = 0;
               	          end //--if (is_ordered
                       end //--if(hqmproc_trfctrl_sel_mode==1 || hqmproc_trfctrl_sel_mode==2) 
                    end //--if(sel_a_cmp==1) 
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
                    cq_intr_service_state = 0; 
                    if(hqmproc_cq_rearm_ctrl[4]==1 && cq_intr_occ_tim_state==0) cq_intr_occ_tim_state = 1;
                    else                                                        cq_intr_occ_tim_state = 0;
                  end 
       	        endcase //--case ($urandom_range(2,0))
             end 
           end //-- 5'b10110,5'b11110
    
    
    
           5'b11000: begin  
             if(hqmproc_trfctrl_sel_mode!=6) begin 
    	         if (cq_poll_interval > 0 || ((hqmproc_stream_flowctrl==1 || hqmproc_enqctrl_sel_mode==3) && pp_cq_type == IS_DIR)) begin
                     send_hcw                = 1;
                     cmd_type                = NEW_T_CMD;
                     cq_token_return         = 1;
                     pend_cq_token_return.pop(ret_val);
                     pend_cq_token_return.size(pend_cq_token_return_size);
                     cq_intr_rtntok_num --;
    
                     if(cq_poll_interval > 0) begin
                        //--rearm required
                        if(cq_token_return>0 && cq_intr_service_state==1) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
                        end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
                        end 
                     end 
    
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
    	         end //--if (cq_poll_interval > 0 || ((hqmproc_stream_flowctrl==1 || hqmproc_enqctrl_sel_mode==3) && pp_cq_type == IS_DIR)) 
             end //--if(hqmproc_trfctrl_sel_mode!=6)  
           end //-- 5'b11000
    
    
    
           5'b11010: begin
    	      int sel_val;    
              int sel_rnd;    
    
              std::randomize(sel_val) with {sel_val dist { 0 := comp_weight, 1 := new_weight }; };
              sel_rnd = $urandom_range((comp_weight+new_weight),0);
    
              if(cmd_type_sel>0) sel_val=0;
    
              if(hqmproc_trfctrl_sel_mode==4) begin
                 if(sel_a_cmp==1) begin
              	    send_hcw              = 1;
            	    cmd_type              = A_COMP_T_CMD;
            	    pend_a_comp_return.pop(is_ordered);
                    cq_comp_service_state = 1;
                 end else begin
              	    send_hcw              = 1;
            	    cmd_type              = COMP_T_CMD;
            	    pend_comp_return.pop(is_ordered);
                    cq_comp_service_state = 0;
                 end //--if(sel_a_cmp==1) 
    
                 if (cq_poll_interval > 0) begin
            	    cq_token_return     = 0;
            	    while ((pend_cq_token_return_size > hqmproc_rtntokctrl_keepnum) && (cq_token_return < 1024)) begin
                          cq_token_return++;
                          pend_cq_token_return.pop(ret_val);
                          pend_cq_token_return.size(pend_cq_token_return_size);
                          cq_intr_rtntok_num --;
                          if(hqmproc_rtntokctrl_rtnnum_on==1 && cq_token_return == hqmproc_rtntokctrl_rtnnum_val) begin
                             break;
                          end 
                          if(cq_intr_service_state==2 && has_enq_rtn_mixed==1) begin
                             break;
                          end 
            	    end //--while
                        
                        //--rearm required
                        if(cq_token_return>0 && cq_intr_service_state==1) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
                        end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
                        end 
    
                 end else begin
            	    pend_cq_token_return.pop(ret_val);
            	    cq_token_return     = ret_val;
    
            	    // only issue CQ interrupt ARM command if all tokens have been returned
            	    pend_cq_token_return.abs_size(pend_cq_token_return_size);
            	    if (pend_cq_token_return_size == 0) begin
                          pend_cq_int_arm.push_front(1);
            	    end 
                 end //--if (cq_poll_interval > 0) 
                 if(sel_a_cmp) 
                         `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)),cq_token_return=%0d is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d hqmproc_trfctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, cq_token_return,is_ordered, is_reorded, cq_comp_service_state, hqmproc_trfctrl_sel_mode),UVM_MEDIUM)
    
              end else if(hqmproc_trfctrl_sel_mode==1 || hqmproc_trfctrl_sel_mode==6 || hqmproc_enqctrl_sel_mode==3 || hqmproc_stream_flowctrl==1 || sel_rnd==2) begin
                 if(sel_a_cmp) begin
           	     send_hcw              = 1;      
                     cmd_type	      = A_COMP_CMD;
                     pend_a_comp_return.pop(is_ordered);		       
                     cq_comp_service_state = 1;
                    `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)),cq_token_return=%0d is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d hqmproc_trfctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, cq_token_return,is_ordered, is_reorded, cq_comp_service_state, hqmproc_trfctrl_sel_mode),UVM_MEDIUM)
                 end else begin 
           	     send_hcw            = 1;      
                     if (hqmproc_trfctrl_sel_mode!=5 && (cq_poll_interval > 0 || hqmproc_stream_flowctrl==1 || hqmproc_enqctrl_sel_mode==3 || hqmproc_trfctrl_sel_mode==6)) begin
                        cmd_type		      = RENQ_T_CMD;
                        cq_token_return	      = 1;
                        pend_cq_token_return.pop(ret_val);
                        pend_cq_token_return.abs_size(pend_cq_token_return_size);
                        cq_intr_rtntok_num --;
    
                        //--rearm required 
                        if(cq_poll_interval > 0 && cq_token_return>0 && cq_intr_service_state==1) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
                        end else if(cq_poll_interval > 0 && ((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
                        end 
                     end else begin
                         cmd_type		      = RENQ_CMD;
                     end 
    
                     pend_comp_return.pop(is_ordered);		       
                     cq_comp_service_state = 0;
    
                     get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, enqhcw_qid, total_genenq_count, enqhcw_qid_use); 
                     get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, enqhcw_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);  
    
                     if (out_of_credit == 1'b0) begin
              	        i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                      end			    
                 end //--if(sel_a_cmp) 
    	      end else begin      
    	          //case (sel_val)
    	          case (sel_rnd)
                  0: begin
                     is_ordered = pend_comp_return.data_q[0];
    
                     if(sel_a_cmp) begin
            	        send_hcw            = 1;
                        cmd_type            = A_COMP_CMD;
            	        pend_a_comp_return.pop(is_ordered);
                        cq_comp_service_state = 1;
                       `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen1_A_COMP: %s PP %0d index=%0d cmd_type=%0s; ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)),cq_token_return=%0d is_ordered=%0d is_reorded=%0d cq_comp_service_state=%0d hqmproc_trfctrl_sel_mode=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index, cmd_type.name(), sel_enq, sel_tok, sel_arm, sel_cmp, sel_frag, cq_token_return,is_ordered, is_reorded, cq_comp_service_state, hqmproc_trfctrl_sel_mode),UVM_MEDIUM)
    
                     end else begin
            	        if (is_ordered) begin
            	           if (hcw_ready) begin
            	               send_hcw            = 1;
            	               pend_comp_return.pop(is_ordered);
                               cq_comp_service_state = 0;
    
            	               if (cq_poll_interval > 0) begin
                                      cmd_type  		= RENQ_T_CMD;
                                      cq_token_return		= 1;
                                      pend_cq_token_return.pop(ret_val);
                                      pend_cq_token_return.abs_size(pend_cq_token_return_size);
                                      cq_intr_rtntok_num --;
    
                                      //--rearm required 
                                      if(cq_token_return>0 && cq_intr_service_state==1) begin
                                	 cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                                	 pend_cq_int_arm.push_front(1);
                                      end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                                	 cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                                	 pend_cq_int_arm.push_front(1);
                                      end 
            	               end else begin
                                     cmd_type		       = RENQ_CMD;
            	               end 
    
                               get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, enqhcw_qid, total_genenq_count, enqhcw_qid_use); 
                               get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, enqhcw_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use); 
    
            	               if (out_of_credit == 1'b0) begin 
                    	         i_hqm_pp_cq_status.wait_for_vas_credit(vas);
            	               end 
            	           end //--if (hcw_ready) 		    
            	        end else begin
            	           send_hcw              = 1;
            	           cmd_type              = COMP_T_CMD;
            	           pend_comp_return.pop(is_ordered);
                           cq_comp_service_state = 0;
    		     	      
            	     	   if (cq_poll_interval > 0) begin
            	     	       cq_token_return     = 0;
            	     	       while ((pend_cq_token_return_size > hqmproc_rtntokctrl_keepnum) && (cq_token_return < 1024)) begin
                     	   	      cq_token_return++;
                     	   	      pend_cq_token_return.pop(ret_val);
                     	   	      pend_cq_token_return.size(pend_cq_token_return_size);
                     	   	      cq_intr_rtntok_num --;
                     	   	      if(hqmproc_rtntokctrl_rtnnum_on==1 && cq_token_return == hqmproc_rtntokctrl_rtnnum_val) begin
                     	   		break;
                     	   	      end 
                     	   	     if(cq_intr_service_state==2 && has_enq_rtn_mixed==1) begin
                     	   		 break;
                     	   	     end 
            	     	      end //--while
                     	      //--rearm required
                     	      if(cq_token_return>0 && cq_intr_service_state==1) begin
                     	   	     cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                     	   	     pend_cq_int_arm.push_front(1);
                     	      end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                     	   	     cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                     	   	     pend_cq_int_arm.push_front(1);
                     	      end 
            	     	   end else begin
            	     	      pend_cq_token_return.pop(ret_val);
            	     	      cq_token_return	  = ret_val;
    		     	   
            	     	      // only issue CQ interrupt ARM command if all tokens have been returned
            	     	      pend_cq_token_return.abs_size(pend_cq_token_return_size);
            	     	      if (pend_cq_token_return_size == 0) begin
                     	   	    pend_cq_int_arm.push_front(1);
            	     	      end 
            	     	   end //--if (cq_poll_interval > 0) 
            	        end //--if (is_ordered)                      
                     end //--if(sel_a_cmp)		    
                  end //--0: begin


                  1: begin
            	     send_hcw              = 1;
    
            	     if (cq_poll_interval > 0) begin
            	        cmd_type              = NEW_T_CMD;
            	        cq_token_return       = 1;
            	        pend_cq_token_return.pop(ret_val);
                        pend_cq_token_return.size(pend_cq_token_return_size);
                        cq_intr_rtntok_num --;
    
                        //--rearm required
                        if(cq_token_return>0 && cq_intr_service_state==1) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
                        end else if(((hqmproc_cq_rearm_ctrl[4] == 0 && cq_intr_rtntok_num == 0) || (hqmproc_cq_rearm_ctrl[4] == 1)) && cq_intr_service_state==2) begin
                           cq_intr_service_state = (hqmproc_cq_rearm_ctrl[0]==1)? 3 : 4;
                           pend_cq_int_arm.push_front(1);
                        end 
    
                     end else begin
            	        cmd_type              = NEW_CMD;
                     end 
    
                     if (out_of_credit == 1'b0) begin
                          i_hqm_pp_cq_status.wait_for_vas_credit(vas);
                     end 
                  end 
    	          endcase //--case (sel_rnd)
              end //--if(hqmproc_trfctrl_sel_mode==4) 
           end //-- 5'b11010

      endcase //-- case ({sel_enq,sel_tok,sel_arm,sel_cmp,sel_frag}) 
    
      saved_is_ordered    = is_reorded;
       
      curr_frag_num  = temp_frag_num;
      curr_frag_cnt  = temp_frag_cnt;
      curr_frag_last = temp_frag_last;
   end //--if(hqmproc_acomp_ctrl==1 && sel_a_cmp==1)


   //------------------------------------------
   //--this is to support scenario of streamming, first HCW is NEW and thereafter, all RENQ_T *(n-1) + COMP_T at last
   //------------------------------------------
   if(hqmproc_frag_ctrl==0 && hqmproc_stream_ctrl==1 && sel_enq==1) begin
      //--streaming control for non-frag cases
      hqmproc_stream_flowctrl=1;

   end else if(hqmproc_frag_ctrl==0 && hqmproc_stream_ctrl==2) begin
      //--streaming control for non-frag cases to support strenq_num of RENQ/RENQ_T and end up with COMP/COMP_T; support DIR strenq_num of NEW_T and end up with BAT_T
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen2.STRENQ.1: %s PP %0d index=%0d cmd_type=%s sel_enq=%0d sel_cmp=%0d sel_tok=%0d pend_comp_return_size=%0d pend_cq_token_return=%0d hqmproc_stream_ctrl=%0d; get hqmproc_stream_flowctrl=%0d, strenq_num=%0d strenq_cnt=%0d strenq_last=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index,cmd_type.name(),sel_enq,sel_cmp,sel_tok, pend_comp_return_size, pend_cq_token_return_size,hqmproc_stream_ctrl, hqmproc_stream_flowctrl, strenq_num, strenq_cnt, strenq_last),UVM_MEDIUM)

      if(pp_cq_type.name() == IS_LDB) begin
          case ({hqmproc_stream_flowctrl[1:0],sel_enq,sel_cmp})
              4'b0010: begin
                  hqmproc_stream_flowctrl=1;             
              end 
              4'b0111: begin
                  strenq_cnt++;
                  if(strenq_cnt<strenq_num) begin
                     strenq_last=0;
                     hqmproc_stream_flowctrl=1;             
                  end else begin
                     hqmproc_stream_flowctrl=2;             
                     strenq_last=1;
                     //strenq_cnt=0;
                  end 
              end 
              4'b1001: begin
                  hqmproc_stream_flowctrl=0;             
                  strenq_last=0;
                  strenq_cnt=0;
                  strenq_num = $urandom_range(hqmproc_strenq_num_max,hqmproc_strenq_num_min);
              end 
          endcase
      end else begin
          case ({hqmproc_stream_flowctrl[1:0],sel_enq,sel_tok})
              4'b0010: begin
                  hqmproc_stream_flowctrl=1;             
              end 
              4'b0111: begin
                  strenq_cnt++;
                  if(strenq_cnt<strenq_num) begin
                     strenq_last=0;
                     hqmproc_stream_flowctrl=1;             
                  end else begin
                     hqmproc_stream_flowctrl=2;             
                     strenq_last=1;
                     //strenq_cnt=0;
                  end 
              end 
              4'b1001: begin
                  hqmproc_stream_flowctrl=0;             
                  strenq_last=0;
                  strenq_cnt=0;
                  strenq_num = $urandom_range(hqmproc_strenq_num_max,hqmproc_strenq_num_min);
              end 
          endcase
      end 
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen2.STRENQ.2: %s PP %0d index=%0d cmd_type=%s sel_enq=%0d sel_cmp=%0d sel_tok=%0d pend_comp_return_size=%0d pend_cq_token_return=%0d hqmproc_stream_ctrl=%0d; get hqmproc_stream_flowctrl=%0d, strenq_num=%0d strenq_cnt=%0d strenq_last=%0d", pp_cq_type.name(),pp_cq_num,queue_list_index,cmd_type.name(),sel_enq,sel_cmp,sel_tok, pend_comp_return_size, pend_cq_token_return_size,hqmproc_stream_ctrl, hqmproc_stream_flowctrl, strenq_num, strenq_cnt, strenq_last),UVM_MEDIUM)


   end else if(hqmproc_frag_ctrl>0 && hqmproc_stream_ctrl==1) begin
      //--streaming control for fragment cases :(NEW + FRAG*n + RENQ_T/RENQ or COMP_T/COMP ) * flows
      if(cmd_type==NEW_CMD || cmd_type==NEW_T_CMD)                                                           hqmproc_stream_flowctrl=1;
      else if(cmd_type==COMP_T_CMD || cmd_type==COMP_CMD || cmd_type==RENQ_T_CMD || cmd_type==RENQ_CMD)      hqmproc_stream_flowctrl=0;
      ///`uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen2.ENQ=%0d: %s PP %0d index=%0d cmd_type=%s sel_enq=%0d frag_last=%0d sel_frag=%0d pend_cq_token_return=%0d pend_comp_return_size=%0d hqmproc_stream_ctrl=%0d hqmproc_stream_flowctrl=%0d",sel_enq, pp_cq_type.name(),pp_cq_num,queue_list_index,cmd_type.name(),sel_enq,sel_frag,temp_frag_last,pend_cq_token_return_size, pend_comp_return_size, hqmproc_stream_ctrl, hqmproc_stream_flowctrl),UVM_MEDIUM)
   end 

   //----------------------
   //-- this is to support scenario of streaming (scenario2), when num_hcw=0, change hqmproc_enqctrl_sel_mode from 3 to 0
   //----------------------
   if(hqmproc_enqctrl_sel_mode==3) begin
      if(queue_list[queue_list_index].num_hcw==0) hqmproc_enqctrl_sel_mode=0; 

      //--deal with ooc case in scenario 2 streaming trf (no more sched hcws, #tok/#comp less than #num_hcw) --//
      if(pp_cq_type == IS_LDB && i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].exp_errors.ooc==1) begin
          if(hqmproc_trfgen_watchdog_cnt > hqmproc_trfgen_watchdog_num) hqmproc_trfgen_stop=1;      
      end else if(pp_cq_type == IS_DIR && i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].exp_errors.ooc==1) begin
          if(hqmproc_trfgen_watchdog_cnt > hqmproc_trfgen_watchdog_num) hqmproc_trfgen_stop=1;      
      end 
   end  

   //----------------------
   //-- hqmproc_trfgen_watchdog_cnt 
   //-- hqmproc_trfgen_stop
   //----------------------
   if(send_hcw==1) begin
      hqmproc_trfgen_watchdog_cnt = 0;
   end else begin
      hqmproc_trfgen_watchdog_cnt++;

      if(hqmproc_trfgen_watchdog_cnt > hqmproc_trfgen_watchdog_num && hqmproc_trfgen_watchdog_ena==1) begin
         hqmproc_trfgen_stop=1; 

         if(pp_cq_type == IS_LDB) begin
            i_hqm_pp_cq_status.force_seq_stop(1, pp_cq_num); 
         end else begin
            i_hqm_pp_cq_status.force_seq_stop(0, pp_cq_num); 
         end 

        `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen2Stop: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), Getting cmd_type=%s send_hcw=%0d cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; qtype=%0s/qtype_use=%0s qid=0x%0x/qid_use=0x%0x; hqmproc_stream_flowctrl=%0d hqmproc_enqctrl_sel_mode=%0d hqmproc_stream_ctrl=%0d hqmproc_rels_ctrl=%0d; hqmproc_trfgen_watchdog_cnt=%0d hqmproc_trfgen_watchdog_num=%0d hqmproc_trfgen_stop=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,sel_enq,sel_tok,sel_arm,sel_cmp, sel_frag,cmd_type.name(),send_hcw, cq_token_return, is_ordered, is_reorded, temp_frag_num, temp_frag_cnt, temp_frag_last, enqhcw_qtype.name(), enqhcw_qtype_use.name(), enqhcw_qid, enqhcw_qid_use,  hqmproc_stream_flowctrl, hqmproc_enqctrl_sel_mode,hqmproc_stream_ctrl, hqmproc_rels_ctrl, hqmproc_trfgen_watchdog_cnt, hqmproc_trfgen_watchdog_num, hqmproc_trfgen_stop),UVM_MEDIUM)

      end 
   end 

   //--support ord seqnum capacity test_try_newer_flow_2ndP: 2nd P newer flow
   //-- hqmproc_enqctrl_sel_mode==10: wait for SCHED (hqmproc_enqctrl_enqnum) HCWs  before start FRAG (no NEW thereafter)
   //--support hqmproc_enqctrl_sel_mode==10 case, in this mode, only send FRAG.qType traffic. There are cases of OOC that causes FRAG replay has been terminated. Use FRAG.qType to close 2nd pass, and NEW.qType=FRAG.qType
   if(hqmproc_enqctrl_sel_mode==10 && is_adj_renq_on==1) begin
        	 get_hqmproc_renq_qid(hqmproc_renq_qid_sel_mode, renq_qid, total_genenq_count, enqhcw_qid_use); 
        	 get_hqmproc_renq_qtype(hqmproc_renq_qtype_sel_mode, renq_qtype, enqhcw_qid_use, total_genenq_count, enqhcw_qtype_use);      
   end 

  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG_TrfCmdGen",$psprintf("TrfCmdGen2: %s PP %0d index=%0d ((selenq=%0d;sel_tok=%0d;sel_arm=%0d;sel_cmp=%0d;sel_frag=%0d;)), Getting cmd_type=%s send_hcw=%0d cq_token_return=%0d is_ordered=%0d is_reorded=%0d frag_num=%0d frag_cnt=%0d frag_last=%0d;; qtype=%0s/qtype_use=%0s qid=0x%0x/qid_use=0x%0x; is_adj_renq_on=%0d; hcw_ready=%0d enq_out_of_credit=%0d; hqmproc_stream_flowctrl=%0d hqmproc_enqctrl_sel_mode=%0d hqmproc_stream_ctrl=%0d hqmproc_rels_ctrl=%0d; hqmproc_trfgen_watchdog_cnt=%0d hqmproc_trfgen_watchdog_num=%0d hqmproc_trfgen_stop=%0d; cq_intr_service_state=%0d pend_cq_int_arm.size=%0d cq_intr_rtntok_num=%0d cq_intr_enq_num=%0d; cq_intr_occ_tim_state=%0d hqmproc_rtntokctrl_keepnum=%0d, cq_intr_service_cqirq_rearm_hold=%0d cqirq_mask_ena=%0d cqirq_mask_run=%0d cqirq_mask_opt=%0d",pp_cq_type.name(),pp_cq_num,queue_list_index,sel_enq,sel_tok,sel_arm,sel_cmp, sel_frag,cmd_type.name(),send_hcw, cq_token_return, is_ordered, is_reorded, temp_frag_num, temp_frag_cnt, temp_frag_last, enqhcw_qtype.name(), enqhcw_qtype_use.name(), enqhcw_qid, enqhcw_qid_use, is_adj_renq_on, hcw_ready, enq_out_of_credit, hqmproc_stream_flowctrl,hqmproc_enqctrl_sel_mode, hqmproc_stream_ctrl, hqmproc_rels_ctrl, hqmproc_trfgen_watchdog_cnt, hqmproc_trfgen_watchdog_num, hqmproc_trfgen_stop, cq_intr_service_state, pend_cq_int_arm.size(), cq_intr_rtntok_num, cq_intr_enq_num, cq_intr_occ_tim_state, hqmproc_rtntokctrl_keepnum, cq_intr_service_cqirq_rearm_hold, cqirq_mask_ena, cqirq_mask_run, cqirq_mask_opt),UVM_MEDIUM)

  hcw_gen_sem.put(1);
endtask : hqmproc_get_hcw_gen_type

 
//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------


//-----------------------------------------
//-- get_hqmproc_qid 
//-----------------------------------------
function hqm_pp_cq_hqmproc_seq::get_hqmproc_qid   (input int qid_sel_mode, int qid_in, int genenq_count, output int qid_gen);
   int qid_offset_tmp;
   
   qid_offset_tmp = 0;
   
   case(qid_sel_mode)
      0: begin
             qid_gen = qid_in;    
         end 

      1: begin
             qid_offset_tmp = genenq_count%2;      
             qid_gen = qid_offset_tmp;    
         end	 
      2: begin
             qid_offset_tmp = genenq_count%3;      
             qid_gen = qid_offset_tmp;    
         end 
      3: begin
             qid_offset_tmp = genenq_count%4;      
             qid_gen = qid_offset_tmp;    
         end 
      4: begin
             qid_offset_tmp = genenq_count%8;      
             qid_gen = qid_offset_tmp;    
         end	 
      5: begin
             qid_offset_tmp = genenq_count%16;      
             qid_gen = qid_offset_tmp;    
         end 
      6: begin
             qid_offset_tmp = genenq_count%32;      
             qid_gen = qid_offset_tmp;    
         end 	 


      8: begin
             qid_offset_tmp = genenq_count%2;	   
             qid_gen = qid_in + qid_offset_tmp;    
         end	 
      9: begin
             qid_offset_tmp = genenq_count%3;      
             qid_gen = qid_in + qid_offset_tmp;    
         end 
      10: begin
             qid_offset_tmp = genenq_count%4;      
             qid_gen = qid_in + qid_offset_tmp;    
         end 
      11: begin
             qid_offset_tmp = genenq_count%8;      
             qid_gen = qid_in + qid_offset_tmp;    
         end	 
      12: begin
             qid_offset_tmp = genenq_count%16;      
             qid_gen = qid_in + qid_offset_tmp;    
         end 
      13: begin
             qid_offset_tmp = genenq_count%32;      
             qid_gen = qid_in + qid_offset_tmp;    
         end 	 
 
      14: begin
             qid_gen =  genenq_count;  
         end	 
      15: begin
             qid_gen =  $urandom_range(hqmproc_qid_max, hqmproc_qid_min);  
         end	 	 	 
      16: begin
             if(($urandom_range(99,0)) < hqmproc_qid_gen_prob) qid_gen = qid_in ;
             else                                              qid_gen = $urandom_range(hqmproc_qid_max, hqmproc_qid_min);  
         end	 	 	 
      default: begin
             qid_gen = qid_in;      
         end	 
   endcase
   
  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("get_hqmproc_qid_qid_sel_mode=%0d qid_in=0x%0x qid_gen=0x%0x hqmproc_qid_gen_prob=%0d genenq_count=%0d qid_offset_tmp=%0d", qid_sel_mode, qid_in, qid_gen, hqmproc_qid_gen_prob, genenq_count, qid_offset_tmp),UVM_MEDIUM)
endfunction: get_hqmproc_qid

//-----------------------------------------
//-- get_hqmproc_qpri 
//-----------------------------------------
function hqm_pp_cq_hqmproc_seq::get_hqmproc_qpri  (input int qpri_sel_mode, int genenq_count, output bit[2:0] qpri_gen);
   case(qpri_sel_mode)
      0: begin
             qpri_gen = 0;      
         end 
      1: begin
             qpri_gen = genenq_count/2;      
         end	 
      2: begin
             qpri_gen = genenq_count%2;      
         end 
      3: begin
             qpri_gen = genenq_count/4;      
         end	 
      4: begin
             qpri_gen = genenq_count%4;      
         end 
      5: begin
             qpri_gen = genenq_count/8;      
         end	 
      6: begin
             qpri_gen = genenq_count%8;      
         end 
      7: begin
             qpri_gen = genenq_count;  
         end 
      8: begin
             qpri_gen = genenq_count[2:0] + 7;  
         end 
      9: begin
             qpri_gen =  $urandom_range(0, 7);  
         end	 	 	 	 	 	 
      default: begin
             qpri_gen = 0;       
         end	 
   endcase
endfunction: get_hqmproc_qpri

//-----------------------------------------
//-- get_hqmproc_qtype 
//-- qtype_sel_mode
//--  1: dir/uno
//--  2: dir/atm
//--  3: uno/atm
//--  4: dir/uno/atm
//--  5: dir/ord/atm
//--  6: uno/ord/atm
//--  7: uno/ord/atm/dir (all)
//--  8: ord/uno
//--  9: ord/dir
//-- 10: ord/atm
//-- 12: atm
//-- 13: uno
//-- 14: ord
//-- 15: dir
//-- 16: ord/atm
//-- hqmproc_qtype_dir 
//-- hqmproc_qtype_ldb   
//-- hqmproc_qtype_ldb_min
//-- hqmproc_qtype_ldb_max
//-----------------------------------------
function hqm_pp_cq_hqmproc_seq::get_hqmproc_qtype (input int qtype_sel_mode, hcw_qtype qtype_in, int qid_in, int genenq_count, output hcw_qtype qtype_gen);
   int tmpval;
   bit is_fid_qid_v, is_sn_qid_v, is_ao_cfg_v;

   is_fid_qid_v = i_hqm_cfg.is_fid_qid_v(qid_in);
   is_sn_qid_v  = i_hqm_cfg.is_sn_qid_v(qid_in);
   is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(qid_in);

   if(qtype_sel_mode==0) begin 
      qtype_gen = qtype_in; 
   end else if(qtype_sel_mode==1) begin
      qtype_gen = (genenq_count[0])? QUNO : QDIR;
   end else if(qtype_sel_mode==2) begin
      qtype_gen = (genenq_count[0])? QATM : QDIR;   
   end else if(qtype_sel_mode==3) begin
      qtype_gen = (genenq_count[0])? QUNO : QATM;      

   end else if(qtype_sel_mode==4) begin   
      tmpval =  $urandom_range(0, 2); 
      if(tmpval==0)      qtype_gen = QATM;
      else if(tmpval==1) qtype_gen = QUNO; 
      else if(tmpval==2) qtype_gen = QDIR;                   	          

   end else if(qtype_sel_mode==5) begin   
      tmpval =  $urandom_range(0, 2); 
      if(tmpval==0)      qtype_gen = QATM;
      else if(tmpval==1) qtype_gen = QORD; 
      else if(tmpval==2) qtype_gen = QDIR;                   	          

   end else if(qtype_sel_mode==6) begin   
      tmpval =  $urandom_range(0, 2); 
      if(tmpval==0)      qtype_gen = QATM;
      else if(tmpval==1) qtype_gen = QUNO; 
      else if(tmpval==2) qtype_gen = QORD;                   	          

   end else if(qtype_sel_mode==7) begin   
      tmpval =  $urandom_range(0, 3); 
      if(tmpval==0)      qtype_gen = QATM;
      else if(tmpval==1) qtype_gen = QUNO; 
      else if(tmpval==2) qtype_gen = QORD;                   	          
      else if(tmpval==3) qtype_gen = QDIR;                   	          

   end else if(qtype_sel_mode==8) begin
      qtype_gen = (genenq_count[0])? QORD : QUNO;
   end else if(qtype_sel_mode==9) begin
      qtype_gen = (genenq_count[0])? QORD : QDIR;   
   end else if(qtype_sel_mode==10) begin
      qtype_gen = (genenq_count[0])? QORD : QATM;      

   end else if(qtype_sel_mode==12) begin
      qtype_gen = QATM;      
   end else if(qtype_sel_mode==13) begin
      qtype_gen = QUNO;      
   end else if(qtype_sel_mode==14) begin
      qtype_gen = QORD;      
   end else if(qtype_sel_mode==15) begin
      qtype_gen = QDIR;      
   end else if(qtype_sel_mode==16) begin
      tmpval =  $urandom_range(0, 1); 
      if(tmpval==0)      qtype_gen = QATM;
      else if(tmpval==1) qtype_gen = QORD;   

   //--------------------------------------------------
   end else if(qtype_sel_mode==20) begin
      //--pick ATM(COMB) or ATM whenever programming is allowed
      if(is_ao_cfg_v==1 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         qtype_gen = QATM;
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         qtype_gen = QORD;  
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==0 && is_fid_qid_v==1) begin
         qtype_gen = QATM;
      end else begin
         qtype_gen = QUNO;
      end 
     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("get_hqmproc_qtype_sel_mode=%0d qtype_in=%0s qtype_gen=%0s with qid_in=0x%0x (is_ao_cfg_v=%0d is_fid_qid_v=%0d is_sn_qid_v=%0d)", qtype_sel_mode, qtype_in.name(), qtype_gen.name(), qid_in, is_ao_cfg_v, is_fid_qid_v, is_sn_qid_v),UVM_MEDIUM)

   end else if(qtype_sel_mode==21) begin
      //--pick ORD whenever programming is allowed (no COMB case)
      if(is_ao_cfg_v==1 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         qtype_gen = QORD;
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         qtype_gen = QORD;  
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==0 && is_fid_qid_v==1) begin
         qtype_gen = QATM;
      end else begin
         qtype_gen = QUNO;
      end 
     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("get_hqmproc_qtype_sel_mode=%0d qtype_in=%0s qtype_gen=%0s with qid_in=0x%0x (is_ao_cfg_v=%0d is_fid_qid_v=%0d is_sn_qid_v=%0d)", qtype_sel_mode, qtype_in.name(), qtype_gen.name(), qid_in, is_ao_cfg_v, is_fid_qid_v, is_sn_qid_v),UVM_MEDIUM)

   end else if(qtype_sel_mode==22) begin
      //--pick ORD whenever programming is allowed (no COMB case)
      if(is_ao_cfg_v==1 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         tmpval =  $urandom_range(0, 1);
         if(tmpval==0)      qtype_gen = QATM;
         else if(tmpval==1) qtype_gen = QORD;  
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         tmpval =  $urandom_range(0, 1);
         if(tmpval==0)      qtype_gen = QATM;
         else if(tmpval==1) qtype_gen = QORD;  
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==0 && is_fid_qid_v==1) begin
         tmpval =  $urandom_range(0, 1);
         if(tmpval==0)      qtype_gen = QATM;
         else if(tmpval==1) qtype_gen = QUNO;  
      end else begin
         tmpval =  $urandom_range(0, 1);
         if(tmpval==0)      qtype_gen = QDIR;
         else if(tmpval==1) qtype_gen = QUNO;  
      end 
     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("get_hqmproc_qtype_sel_mode=%0d qtype_in=%0s qtype_gen=%0s with qid_in=0x%0x (is_ao_cfg_v=%0d is_fid_qid_v=%0d is_sn_qid_v=%0d)", qtype_sel_mode, qtype_in.name(), qtype_gen.name(), qid_in, is_ao_cfg_v, is_fid_qid_v, is_sn_qid_v),UVM_MEDIUM)


   //--------------------------------------------------
   end else begin 
      qtype_gen = qtype_in;	 
   end		 
  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("get_hqmproc_qtype_sel_mode=%0d qtype_in=%0s qtype_gen=%0s genenq_count=%0d", qtype_sel_mode, qtype_in.name(), qtype_gen.name(), genenq_count),UVM_MEDIUM)

   //--fix qtype based on qid
   if(hqmproc_ingerrinj_qidill_ctrl==6 && ($urandom_range(99,0) < hqmproc_ingerrinj_qidill_rate)) begin
      `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("DBGget_hqmproc_qtype_sel_mode=%0d qtype_in=%0s qid_in=%0d getting qtype_gen=%0s genenq_count=%0d hqmproc_ingerrinj_qidill_ctrl=%0d", qtype_sel_mode, qtype_in.name(), qid_in, qtype_gen.name(), genenq_count, hqmproc_ingerrinj_qidill_ctrl),UVM_MEDIUM)

   end else begin
      if(qtype_gen==QUNO && i_hqm_cfg.is_sn_qid_v(qid_in)==1) begin
         qtype_gen = QORD;
      end else if(qtype_gen==QORD && i_hqm_cfg.is_sn_qid_v(qid_in)==0) begin
         qtype_gen = QUNO;
      end 
   end 
  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("DBGget_hqmproc_qtype_sel_mode=%0d qtype_in=%0s qid_in=%0d getting qtype_gen=%0s genenq_count=%0d", qtype_sel_mode, qtype_in.name(), qid_in, qtype_gen.name(), genenq_count),UVM_MEDIUM)
endfunction: get_hqmproc_qtype 


//-----------------------------------------
//-- get_hqmproc_lockid 
//-----------------------------------------
function hqm_pp_cq_hqmproc_seq::get_hqmproc_lockid(input int lockid_sel_mode, bit [15:0] lock_id_in, int genenq_count, hcw_qtype qtype_curr, output bit[15:0] lockid_gen);
     lockid_gen = lock_id_in;

     if(qtype_curr == QATM) begin
       if(lockid_sel_mode==1) begin
         lockid_gen = genenq_count; 
       end else if(lockid_sel_mode==2) begin
         lockid_gen = 16'hffff - genenq_count; 
       end else if(lockid_sel_mode==3) begin
         lockid_gen = genenq_count[1:0]; 
       end else if(lockid_sel_mode==4) begin
         lockid_gen = genenq_count[2:0]; 
       end else if(lockid_sel_mode==5) begin
         lockid_gen = genenq_count[3:0]; 
       end else if(lockid_sel_mode==6) begin
         lockid_gen = genenq_count[4:0]; 
       end else if(lockid_sel_mode==7) begin
         lockid_gen = genenq_count[5:0]; 
       end else if(lockid_sel_mode==8) begin
         lockid_gen = 16'hffff - genenq_count[1:0]; 
       end else if(lockid_sel_mode==9) begin
         lockid_gen = 16'hffff - genenq_count[2:0]; 
       end else if(lockid_sel_mode==10) begin
         lockid_gen = 16'hffff - genenq_count[3:0]; 
       end else if(lockid_sel_mode==11) begin
         lockid_gen = 16'hffff - genenq_count[4:0]; 
       end else if(lockid_sel_mode==12) begin
         lockid_gen = 16'hffff - genenq_count[5:0]; 

       end else if(lockid_sel_mode==17) begin
         lockid_gen = genenq_count[6:0]; 
       end else if(lockid_sel_mode==18) begin
         lockid_gen = genenq_count[7:0]; 
       end 
     end 
endfunction: get_hqmproc_lockid


//-----------------------------------------
//-----------------------------------------
//-----------------------------------------
//-- get_hqmproc_renq_qid 
//-----------------------------------------
function hqm_pp_cq_hqmproc_seq::get_hqmproc_renq_qid   (input int qid_sel_mode, int qid_in, int genenq_count, output int qid_gen);
   int qid_offset_tmp;
   
   qid_offset_tmp = 0;
   
   case(qid_sel_mode)
      0: begin
             qid_gen = qid_in;    
         end 

      1: begin
             qid_gen = qid_in + 1;       
         end	 
      2: begin
             qid_offset_tmp = genenq_count%2;      
             qid_gen = qid_offset_tmp;    
         end 
      3: begin
             qid_offset_tmp = genenq_count%4;      
             qid_gen = qid_offset_tmp;    
         end 
      4: begin
             qid_offset_tmp = genenq_count%8;      
             qid_gen = qid_offset_tmp;    
         end	 
      5: begin
             qid_offset_tmp = genenq_count%16;      
             qid_gen = qid_offset_tmp;    
         end 
      6: begin
             qid_offset_tmp = genenq_count%32;      
             qid_gen = qid_offset_tmp;    
         end  
      8: begin
             qid_offset_tmp = genenq_count%2;	   
             qid_gen = qid_in + qid_offset_tmp;    
         end	 
      9: begin
             qid_offset_tmp = genenq_count%3;      
             qid_gen = qid_in + qid_offset_tmp;    
         end 
      10: begin
             qid_offset_tmp = genenq_count%4;      
             qid_gen = qid_in + qid_offset_tmp;    
         end 
      11: begin
             qid_offset_tmp = genenq_count%8;      
             qid_gen = qid_in + qid_offset_tmp;    
         end	 
      12: begin
             qid_offset_tmp = genenq_count%16;      
             qid_gen = qid_in + qid_offset_tmp;    
         end 
      13: begin
             qid_offset_tmp = genenq_count%32;      
             qid_gen = qid_in + qid_offset_tmp;    
         end 	 
 
      14: begin
             qid_gen =  genenq_count;  
         end	 
      15: begin
             qid_gen =  $urandom_range(hqmproc_qid_max, hqmproc_qid_min);  
         end	 	 	 
      default: begin
             qid_gen = qid_in;      
         end	 
   endcase
   
  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("get_hqmproc_renq_qid_sel_mode=%0d qid_in=0x%0x qid_gen=0x%0x genenq_count=%0d qid_offset_tmp=%0d", qid_sel_mode, qid_in, qid_gen, genenq_count, qid_offset_tmp),UVM_MEDIUM)
endfunction: get_hqmproc_renq_qid

//-----------------------------------------
//-- get_hqmproc_renq_qpri 
//-----------------------------------------
function hqm_pp_cq_hqmproc_seq::get_hqmproc_renq_qpri  (input int qpri_sel_mode, int genenq_count, output bit[2:0] qpri_gen);
   case(qpri_sel_mode)
      0: begin
             qpri_gen = 0;      
         end 
      1: begin
             qpri_gen = genenq_count/2;      
         end	 
      2: begin
             qpri_gen = genenq_count%2;      
         end 
      3: begin
             qpri_gen = genenq_count/4;      
         end	 
      4: begin
             qpri_gen = genenq_count%4;      
         end 
      5: begin
             qpri_gen = genenq_count/8;      
         end	 
      6: begin
             qpri_gen = genenq_count%8;      
         end 
      7: begin
             qpri_gen = genenq_count;  
         end 
      8: begin
             qpri_gen = genenq_count[2:0] + 7;  
         end 
      9: begin
             qpri_gen =  $urandom_range(0, 7);  
         end	 	 	 	 	 	 
      default: begin
             qpri_gen = 0;       
         end	 
   endcase
endfunction: get_hqmproc_renq_qpri

//-----------------------------------------
//-- get_hqmproc_renq_qtype 
//-- qtype_sel_mode
//--  1: dir/uno
//--  2: dir/atm
//--  3: uno/atm
//--  4: dir/uno/atm
//--  5: 
//-- 12: atm
//-- 13: uno
//-- 14: ord
//-- 15: dir
//-- hqmproc_renq_qtype_dir 
//-- hqmproc_renq_qtype_ldb   
//-- hqmproc_renq_qtype_ldb_min
//-- hqmproc_renq_qtype_ldb_max
//-----------------------------------------
function hqm_pp_cq_hqmproc_seq::get_hqmproc_renq_qtype (input int qtype_sel_mode, hcw_qtype qtype_in,  int qid_in, int genenq_count, output hcw_qtype qtype_gen);
   int tmpval;
   bit is_fid_qid_v, is_sn_qid_v, is_ao_cfg_v;

   is_fid_qid_v = i_hqm_cfg.is_fid_qid_v(qid_in);
   is_sn_qid_v  = i_hqm_cfg.is_sn_qid_v(qid_in);
   is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(qid_in);

   
   if(qtype_sel_mode==0) begin 
      qtype_gen = qtype_in; 
   end else if(qtype_sel_mode==1) begin
      qtype_gen = (genenq_count[0])? QUNO : QDIR;
      if(is_ao_cfg_v==1 || is_sn_qid_v==1) qtype_gen = QDIR;

   end else if(qtype_sel_mode==2) begin
      qtype_gen = (genenq_count[0])? QATM : QDIR; 
      if(is_ao_cfg_v==1) qtype_gen = QDIR; //--to avoid COMB in 2nd pass
  
   end else if(qtype_sel_mode==3) begin
      qtype_gen = (genenq_count[0])? QUNO : QATM;      
      if(is_ao_cfg_v==1) qtype_gen = QDIR; //--to avoid COMB in 2nd pass

   end else if(qtype_sel_mode==4) begin   
      tmpval =  $urandom_range(0, 2); 
      if(tmpval==0)      qtype_gen = QATM;
      else if(tmpval==1) qtype_gen = QUNO; 
      else if(tmpval==2) qtype_gen = QDIR; 
                  	          
      if(is_ao_cfg_v==1) qtype_gen = (genenq_count[0])? QUNO : QDIR; //--to avoid COMB in 2nd pass

   end else if(qtype_sel_mode==12) begin
      qtype_gen = QATM;      
   end else if(qtype_sel_mode==13) begin
      qtype_gen = QUNO;      
   end else if(qtype_sel_mode==14) begin
      qtype_gen = QORD;      
   end else if(qtype_sel_mode==15) begin
      qtype_gen = QDIR;      


   //--------------------------------------------------
   end else if(qtype_sel_mode==20) begin
      //--
      if(is_ao_cfg_v==1 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         qtype_gen = QDIR;
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         qtype_gen = QDIR;  
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==0 && is_fid_qid_v==1) begin
         qtype_gen = QATM;
      end else begin
         qtype_gen = QUNO;
      end 
     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("get_hqmproc_renq_qtype_sel_mode=%0d qtype_in=%0s qtype_gen=%0s with qid_in=0x%0x (is_ao_cfg_v=%0d is_fid_qid_v=%0d is_sn_qid_v=%0d)", qtype_sel_mode, qtype_in.name(), qtype_gen.name(), qid_in, is_ao_cfg_v, is_fid_qid_v, is_sn_qid_v),UVM_MEDIUM)

   end else if(qtype_sel_mode==21) begin
      //--
      if(is_ao_cfg_v==1 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         qtype_gen = QDIR;
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         qtype_gen = QDIR;  
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==0 && is_fid_qid_v==1) begin
         qtype_gen = QUNO;
      end else begin
         qtype_gen = QUNO;
      end 
     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("get_hqmproc_renq_qtype_sel_mode=%0d qtype_in=%0s qtype_gen=%0s with qid_in=0x%0x (is_ao_cfg_v=%0d is_fid_qid_v=%0d is_sn_qid_v=%0d)", qtype_sel_mode, qtype_in.name(), qtype_gen.name(), qid_in, is_ao_cfg_v, is_fid_qid_v, is_sn_qid_v),UVM_MEDIUM)

   end else if(qtype_sel_mode==22) begin
      //--
      if(is_ao_cfg_v==1 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         qtype_gen = QDIR;
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==1 && is_fid_qid_v==1) begin
         tmpval =  $urandom_range(0, 1);
         if(tmpval==0)      qtype_gen = QATM;
         else if(tmpval==1) qtype_gen = QDIR;  
      end else if(is_ao_cfg_v==0 && is_sn_qid_v==0 && is_fid_qid_v==1) begin
         tmpval =  $urandom_range(0, 1);
         if(tmpval==0)      qtype_gen = QATM;
         else if(tmpval==1) qtype_gen = QUNO;  
      end else begin
         tmpval =  $urandom_range(0, 1);
         if(tmpval==0)      qtype_gen = QDIR;
         else if(tmpval==1) qtype_gen = QUNO;  
      end 
     `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("get_hqmproc_renq_qtype_sel_mode=%0d qtype_in=%0s qtype_gen=%0s with qid_in=0x%0x (is_ao_cfg_v=%0d is_fid_qid_v=%0d is_sn_qid_v=%0d)", qtype_sel_mode, qtype_in.name(), qtype_gen.name(), qid_in, is_ao_cfg_v, is_fid_qid_v, is_sn_qid_v),UVM_MEDIUM)

   //--------------------------------------------------
   end else begin 
      qtype_gen = qtype_in;	 
   end		 
  `uvm_info("HQM_PP_CQ_HQMPROC_SEQ_DEBUG",$psprintf("get_hqmproc_renq_qtype_sel_mode=%0d qtype_in=%0s qid_in=0x%0x qtype_gen=%0s genenq_count=%0d", qtype_sel_mode, qtype_in.name(), qid_in, qtype_gen.name(), genenq_count),UVM_MEDIUM)
endfunction: get_hqmproc_renq_qtype 


//-----------------------------------------
//-- get_hqmproc_renq_lockid 
//-----------------------------------------
function hqm_pp_cq_hqmproc_seq::get_hqmproc_renq_lockid(input int lockid_sel_mode, bit [15:0] lock_id_in, int genenq_count, hcw_qtype qtype_curr, output bit[15:0] lockid_gen);
     lockid_gen = lock_id_in;
endfunction: get_hqmproc_renq_lockid

//=========================================
//-- hqmproc_cq_intr_run
//=========================================
task hqm_pp_cq_hqmproc_seq::hqmproc_cq_intr_run(); 
   int cqirq_intr_state;
   int cqirq_intr_recved;

  while (mon_enable) begin
     sys_clk_delay(1);

     cqirq_intr_recved = 0;
     if(pp_cq_type == IS_LDB) begin
        cqirq_intr_state = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_intr_state;
     end else begin
        cqirq_intr_state = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_intr_state;
     end 

     if(cqirq_intr_state==1) begin

        `uvm_info(get_full_name(), $psprintf("hqmproc_cq_intr_run: %s CQ 0x%0x cqirq_intr_state=%0d call hqmproc_intr_check_task", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num, cqirq_intr_state), UVM_MEDIUM)
        hqmproc_intr_check_task(cqirq_intr_recved);

        if(cqirq_intr_recved==1) begin
            if(pp_cq_type == IS_LDB) begin
               i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num].cq_int_intr_state=0;
            end else begin
               i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num].cq_int_intr_state=0;
            end 
            `uvm_info(get_full_name(), $psprintf("hqmproc_cq_intr_run: %s CQ 0x%0x cqirq_intr_state=0 cqirq_intr_recved=1", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num), UVM_MEDIUM)
        end    
     end 
  end 
endtask:hqmproc_cq_intr_run
  
//=========================================
//-- hqmproc_intr_poll_run
//=========================================
task hqm_pp_cq_hqmproc_seq::hqmproc_intr_poll_run(input int loop_num, output int cq_intr_recv);
   int wait_num;

   wait_num = 100;
   for(int i=0; i<loop_num; i++) begin
      hqmproc_intr_check_task(cq_intr_recv); 
      if(cq_intr_recv) begin
        `uvm_info(get_full_name(), $psprintf("hqmproc_intr_poll_run: %s CQ 0x%0x intr detected ", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num), UVM_MEDIUM)
         break;
      end else begin
         sys_clk_delay(wait_num);
      end 
   end 
endtask: hqmproc_intr_poll_run

                    
//=========================================
//-- hqmproc_intr_check_task
//=========================================
task hqm_pp_cq_hqmproc_seq::hqmproc_intr_check_task(output int cq_intr_recv);
   int cq_intr_recv_num;
   bit [31:0] ims_poll_d;

    if(i_hqm_cfg.ims_poll_mode) begin
         read_ims_poll_addr(ims_poll_d);
         if(ims_poll_d == 0) begin
            cq_intr_recv_num = 0;
         end else begin
            cq_intr_recv_num = 1;               
           `uvm_info(get_full_name(), $psprintf("hqmproc_intr_check_task: %s CQ 0x%0x detected IMS Poll Write ims_poll_data=0x%0x", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num, ims_poll_d), UVM_MEDIUM)
         end 
    end else begin
         cq_intr_recv_num = i_hqm_pp_cq_status.cq_int_received(((pp_cq_type == IS_LDB) ? 1 : 0), pp_cq_num);
         `uvm_info(get_full_name(), $psprintf("hqmproc_intr_check_task: %s CQ 0x%0x detected MSIX", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num), UVM_MEDIUM)
    end 

    cq_intr_recv = 0;
    if(cq_intr_recv_num > 0) begin
       cq_intr_recv = 1;
       //`uvm_info(get_full_name(), $psprintf("hqmproc_intr_check_task: %s CQ 0x%0x intr detected ", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num), UVM_MEDIUM)
       if(i_hqm_cfg.ims_poll_mode) begin
          write_ims_poll_addr(0);
       end else begin
          i_hqm_pp_cq_status.wait_for_cq_int(((pp_cq_type == IS_LDB) ? 1 : 0), pp_cq_num);
       end 
       `uvm_info(get_full_name(), $psprintf("hqmproc_intr_check_task: %s CQ 0x%0x intr cleared ", (pp_cq_type == IS_LDB)? "LDB" : "DIR", pp_cq_num), UVM_MEDIUM)
    end 
endtask: hqmproc_intr_check_task


`endif
