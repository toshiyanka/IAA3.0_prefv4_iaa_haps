//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//-----------------------------------------------------------------------------------------------------
// hqm_core_pkg
//
//-----------------------------------------------------------------------------------------------------

// unit short hand names
// s    : hqm_system
// chp  : hqm_credit_hist_pipe
// rop  : hqm_reorder_pipe
// lsp  : hqm_list_sel_pipe
// nalb : hqm_nalb_pipe
// ap   : hqm_atm_pipe
// dp   : hqm_dir_pipe
// qed  : hqm_qed
// aqed : hqm_aqed
// dqed : hqm_dqed

package hqm_core_pkg ;
        import hqm_AW_pkg::*, hqm_pkg::*;

// hist_list_info
typedef union packed {
  logic [(12)-1:0] sn;
  logic [(12)-1:0] fid;
} sn_fid_t;

localparam BITS_SN_FID_T = $bits(sn_fid_t);

typedef struct packed {
logic                                    error ;
logic                                    cq_is_ldb ;
logic [ ( 7 ) - 1 : 0 ]                  cq ;
hqm_pkg::cq_hcw_t                        hcw ;
logic [ ( 16 ) - 1 : 0 ]                 hcw_ecc ;
hqm_pkg::hqm_core_flags_t                flags ;
logic [ ( 4 ) - 1 : 0 ]                  cmp_id ;
} outbound_hcw_fifo_t ;




typedef struct packed {
  logic [(1)-1:0] parity;
  hqm_pkg::qtype_t qtype;
  logic [(3)-1:0] qpri;
  logic [(6)-1:0] qid;
  logic qidix_msb;
  logic [(3)-1:0] qidix;
  logic [(3)-1:0] reord_mode;
  logic [(5)-1:0] reord_slot;
  sn_fid_t sn_fid;
} hist_list_info_t;

localparam BITS_HIST_LIST_INFO_T = $bits(hist_list_info_t);

typedef struct packed {
  logic [(7)-1:0] qid;
  logic [(12)-1:0] fid;
  logic [(16)-1:0] hid;
  logic fid_parity;
  logic hid_parity;
} lsp_aqed_cmp_t;

localparam BITS_LSP_AQED_CMP_T = $bits(lsp_aqed_cmp_t);


typedef struct packed {
  logic [7:0] ecc;
  logic [1:0] qe_wt;
  logic [15:0] hid;
  logic [3:0] cmp_id;
  hist_list_info_t hist_list_info;  
} hist_list_mf_t;

localparam BITS_HIST_LIST_MF_T = $bits(hist_list_mf_t);

// dp_frag_list_info
typedef struct packed {
  logic [(14)-1:0] hptr;
  logic [(14)-1:0] tptr;
  logic [(5)-1:0] cnt;
  logic [(1)-1:0] hptr_parity;
  logic [(1)-1:0] tptr_parity;
  logic [(2)-1:0] cnt_residue;
} dp_frag_list_info_t;

localparam BITS_DP_FRAG_LIST_INFO_T = $bits(dp_frag_list_info_t);

// lb_frag_list_info
typedef struct packed {
  logic [(14)-1:0] hptr;
  logic [(14)-1:0] tptr;
  logic [(5)-1:0] cnt;
  logic [(1)-1:0] hptr_parity;
  logic [(1)-1:0] tptr_parity;
  logic [(2)-1:0] cnt_residue;
} nalb_frag_list_info_t;

localparam BITS_NALB_FRAG_LIST_INFO_T = $bits(nalb_frag_list_info_t);

// chp_rop_hcw         : HCW to enqueue and hist_list response info
//        command==1   : enqueue new HCW 
//        command==2   : enqueue replay HCW
typedef enum logic [(2)-1:0] {
  CHP_ROP_ENQ_ILL0='h0,
  CHP_ROP_ENQ_NEW_HCW='h1,
  CHP_ROP_ENQ_REPLAY_HCW='h2,
  CHP_ROP_ENQ_ILL3='h3
} enum_cmd_rop_hcw_enq_t;

localparam BITS_ENUM_CMD_ROP_HCW_ENQ_T = $bits(enum_cmd_rop_hcw_enq_t);

typedef struct packed {
  logic       pp_parity;
  logic       parity;
  logic       cq_hcw_no_dec;
  enum_cmd_rop_hcw_enq_t cmd;
  logic [(15)-1:0] flid;
  logic [(1)-1:0] flid_parity;
  hist_list_info_t hist_list_info;
  logic hcw_cmd_parity ;
  hqm_pkg::hcw_cmd_t hcw_cmd;
  hqm_pkg::cq_hcw_t cq_hcw;
  logic [(16)-1:0] cq_hcw_ecc;
} chp_rop_hcw_t;

localparam BITS_CHP_ROP_HCW_T = $bits(chp_rop_hcw_t);

// chp_ap_cmp          : complete load balanced response
typedef struct packed {
  logic [(8)-1:0] pp;
  logic [(1)-1:0] parity;
  hist_list_info_t hist_list_info;
} chp_ap_cmp_t;

localparam BITS_CHP_AP_CMP_T = $bits(chp_ap_cmp_t);

// chp_lsp_cmp         : complete load balanced response
typedef struct packed {
  logic [1:0]     user;
  logic [(8)-1:0] pp;
  logic [(7)-1:0] qid;
  logic [(2)-1:0] qe_wt;
  logic [(1)-1:0] parity;       // On pp, qid and qe_wt
  hist_list_info_t hist_list_info;
  logic [(1)-1:0] hid_parity;
  logic [(16)-1:0] hid;
} chp_lsp_cmp_t;

localparam BITS_CHP_LSP_CMP_T = $bits(chp_lsp_cmp_t);


















// qed_lsp_deq         : load balanced dequeue
typedef struct packed {
  logic [(1)-1:0] parity;
  logic [(6)-1:0] cq;
  logic [(2)-1:0] qe_wt;
} qed_lsp_deq_t;

localparam BITS_QED_LSP_DEQ_T = $bits(qed_lsp_deq_t);

// aqed_lsp_deq         : load balanced dequeue
typedef struct packed {
  logic [(1)-1:0] parity;
  logic [(6)-1:0] cq;
  logic [(2)-1:0] qe_wt;
} aqed_lsp_deq_t;

localparam BITS_AQED_LSP_DEQ_T = $bits(aqed_lsp_deq_t);







// chp_lsp_token       : return tokens
typedef struct packed {
hqm_pkg::hcw_cmd_dec_t                   cmd ;
  logic [(8)-1:0] cq;
  logic [(1)-1:0] is_ldb;
  logic [(1)-1:0] parity;
  logic [(13)-1:0] count;
  logic [(2)-1:0] count_residue;
} chp_lsp_token_t;

localparam BITS_CHP_LSP_TOKEN_T = $bits(chp_lsp_token_t);









// rop_lsp_reordercmp  : send completion resonse when reordered list is complete and enqueued
typedef struct packed {
  logic           user;
  logic [(8)-1:0] cq;
  logic [(7)-1:0] qid;
  logic [(1)-1:0] parity;       // On cq and qid
} rop_lsp_reordercmp_t;

localparam BITS_ROP_LSP_REORDERCMP_T = $bits(rop_lsp_reordercmp_t);

typedef struct packed {
  logic [21:0] reserved;
  logic        vld;
  logic        ldb;
  logic [7:0]  cq;
} wd_pending_t;

localparam BITS_WD_PENDING_T = $bits(wd_pending_t);

// rop_dp_enq          : enqueue HCW to directed linked list storage
//        command==1   : enqueue new HCW 
//        command==2   : enqueue reorder HCW
//        command==3   : enqueue reorder frag_list 
//        command==4   : noop
typedef enum logic [(3)-1:0] { 
  ROP_DP_ENQ_ILL0='h0,
  ROP_DP_ENQ_DIR_ENQ_NEW_HCW='h1,
  ROP_DP_ENQ_DIR_ENQ_REORDER_HCW='h2,
  ROP_DP_ENQ_DIR_ENQ_REORDER_LIST='h3,
  ROP_DP_ENQ_DIR_ENQ_NEW_HCW_NOOP='h4,
  ROP_DP_ENQ_ILL5='h5,
  ROP_DP_ENQ_ILL6='h6,
  ROP_DP_ENQ_ILL7='h7
} enum_cmd_rop_dp_enq_t;

localparam BITS_ENUM_CMD_ROP_DP_ENQ_T = $bits(enum_cmd_rop_dp_enq_t);

typedef struct packed {
  enum_cmd_rop_dp_enq_t cmd;
  logic [(8)-1:0] cq;
  logic [(15)-1:0] flid;
  logic [(1)-1:0] flid_parity;
  hist_list_info_t hist_list_info;
  dp_frag_list_info_t frag_list_info;
} rop_dp_enq_t;

localparam BITS_ROP_DP_ENQ_T = $bits(rop_dp_enq_t);

// rop_nalb_enq        : enqueue HCW to load balanced linked list storage
//        command==1   : enqueue HCW 
//        command==2   : enqueue reorder HCW
//        command==3   : enqueue reorder frag_list 
//        command==4   : noop
typedef enum logic [(3)-1:0] { 
  ROP_NALB_ENQ_ILL0='h0,
  ROP_NALB_ENQ_LB_ENQ_NEW_HCW='h1,
  ROP_NALB_ENQ_LB_ENQ_REORDER_HCW='h2,
  ROP_NALB_ENQ_LB_ENQ_REORDER_LIST='h3,
  ROP_NALB_ENQ_LB_ENQ_NEW_HCW_NOOP='h4,
  ROP_NALB_ENQ_ILL5='h5,
  ROP_NALB_ENQ_ILL6='h6,
  ROP_NALB_ENQ_ILL7='h7
} enum_cmd_rop_nalb_enq_t;

localparam BITS_ENUM_CMD_ROP_NALB_ENQ_T = $bits(enum_cmd_rop_nalb_enq_t);

typedef struct packed {
  enum_cmd_rop_nalb_enq_t cmd;
  logic [(8)-1:0] cq;
  logic [(15)-1:0] flid;
  logic [(1)-1:0] flid_parity;
  hist_list_info_t hist_list_info;
  nalb_frag_list_info_t frag_list_info;
} rop_nalb_enq_t;

localparam BITS_ROP_NALB_ENQ_T = $bits(rop_nalb_enq_t);

// rop_qed_dqed_enq    : enqueue HCW to data storage (dir or ldb)
//        command==1   : enqueue directed HCW - dqed
//        command==2   : enqueue load balanced HCW- qed
//        command==3   : noop
typedef enum logic [(2)-1:0] {
  ROP_QED_DQED_ENQ_DIR_NOOP='h0,
  ROP_QED_DQED_ENQ_DIR='h1,
  ROP_QED_DQED_ENQ_LB='h2,
  ROP_QED_DQED_ENQ_LB_NOOP='h3
} enum_cmd_rop_qed_dqed_enq_t;

localparam BITS_ENUM_CMD_ROP_QED_DQED_ENQ_T = $bits(enum_cmd_rop_qed_dqed_enq_t);

typedef struct packed {
  enum_cmd_rop_qed_dqed_enq_t cmd;
  logic [(15)-1:0] flid;
  logic [(1)-1:0] flid_parity;
  hqm_pkg::cq_hcw_t cq_hcw;
  logic [(16)-1:0] cq_hcw_ecc;
} rop_qed_dqed_enq_t;

localparam BITS_ROP_QED_DQED_ENQ_T = $bits(rop_qed_dqed_enq_t);

// lsp_nalb_sch_unoord : schedule unordered/ordered task
typedef struct packed {
  logic [(8)-1:0] cq;
  logic [(7)-1:0] qid;
  logic [(3)-1:0] qidix;
  logic [(1)-1:0] parity;       // On cq and qid
  hqm_core_flags_t hqm_core_flags;
} lsp_nalb_sch_unoord_t;

localparam BITS_LSP_NALB_SCH_UNOORD_T = $bits(lsp_nalb_sch_unoord_t);

// lsp_dp_sch_dir      : schedule dir task
typedef struct packed {
  logic [(8)-1:0] cq;
  logic [(7)-1:0] qid;
  logic [(3)-1:0] qidix;
  logic [(1)-1:0] parity;
  hqm_core_flags_t hqm_core_flags;
} lsp_dp_sch_dir_t;

localparam BITS_LSP_DP_SCH_DIR_T = $bits(lsp_dp_sch_dir_t);

// lsp_ap_sch_atm      : schedule atomic task
typedef struct packed {
  logic [(8)-1:0] cq;
  logic [(7)-1:0] qid;
  logic [(3)-1:0] qidix;
  logic [(1)-1:0] parity;       // On cq, qid and qidix
  hqm_core_flags_t hqm_core_flags;
} lsp_ap_sch_atm_t;

localparam BITS_LSP_AP_SCH_ATM_T = $bits(lsp_ap_sch_atm_t);

typedef enum logic [(2)-1:0] {
  LSP_AP_ATM_CMP='h0,
  LSP_AP_ATM_SCH_RLST='h1,
  LSP_AP_ATM_SCH_SLST='h2,
  LSP_AP_ATM_ILLEGAL='h3
} enum_cmd_lsp_ap_atm_t;

localparam BITS_ENUM_CMD_LSP_AP_ATM_T = $bits(enum_cmd_lsp_ap_atm_t);

typedef struct packed {
  logic pcm;
  enum_cmd_lsp_ap_atm_t cmd ;
  logic [(8)-1:0] cq;
  logic [(3)-1:0] qpri;
  logic [(7)-1:0] qid;
  logic qidix_msb;
  logic [(3)-1:0] qidix;
  logic [(1)-1:0] parity;
  logic [(12)-1:0] fid;
  logic [(16)-1:0] hid;
  logic [(1)-1:0] hid_parity;
  logic [(1)-1:0] fid_parity;
  hqm_core_flags_t hqm_core_flags;
} lsp_ap_atm_t;

localparam BITS_LSP_AP_ATM_T = $bits(lsp_ap_atm_t);




// lsp_nalb_sch_rorply : schedule ldb qe for replay
typedef struct packed {
  logic [(7)-1:0] qid;
  logic [(1)-1:0] parity;
} lsp_nalb_sch_rorply_t;

localparam BITS_LSP_NALB_SCH_RORPLY_T = $bits(lsp_nalb_sch_rorply_t);

// lsp_dp_sch_rorply   : schedule dir for replay
typedef struct packed {
  logic [(7)-1:0] qid;
  logic [(1)-1:0] parity;
} lsp_dp_sch_rorply_t;

localparam BITS_LSP_DP_SCH_RORPLY_T = $bits(lsp_dp_sch_rorply_t);

// lsp_nalb_sch_atq    : move task from atq to atm
typedef struct packed {
  logic [(7)-1:0] qid;
  logic [(1)-1:0] parity;
} lsp_nalb_sch_atq_t;

localparam BITS_LSP_NALB_SCH_ATQ_T = $bits(lsp_nalb_sch_atq_t);

typedef struct packed {
  logic [(7)-1:0] qid;
  hqm_pkg::qtype_t qtype;
  logic [(1)-1:0] parity;       // On qid and qtype
} nalb_lsp_enq_lb_t;

localparam BITS_NALB_LSP_ENQ_LB_T = $bits(nalb_lsp_enq_lb_t);

typedef struct packed {
  logic [(7)-1:0] qid;
  hqm_pkg::qtype_t qtype;
  logic [(1)-1:0] parity;       // On qid and qtype
  logic [(15)-1:0] frag_cnt;
  logic [(2)-1:0] frag_residue;
} nalb_lsp_enq_rorply_t;

localparam BITS_NALB_LSP_ENQ_RORPLY_T = $bits(nalb_lsp_enq_rorply_t);

// nalb_qed            : issue pop/read commands to QED
//        command==1   : read qe and move {qe_type, qe_qid, qe_lockid } to chp
//        command==2   : pop qe and move to cq
//        command==3   : pop qe and move to to aqed
typedef enum logic [(2)-1:0] {
  NALB_QED_ILL0='h0,
  NALB_QED_READ='h1,
  NALB_QED_POP='h2,
  NALB_QED_TRANSFER='h3
} enum_cmd_nalb_qed_t;

localparam BITS_ENUM_CMD_NALB_QED_T = $bits(enum_cmd_nalb_qed_t);

typedef struct packed {
  enum_cmd_nalb_qed_t cmd;
  logic [(8)-1:0] cq;
  logic [(7)-1:0] qid;
  logic [(3)-1:0] qidix;
  logic [(1)-1:0] parity;       // On cq, qid and qidix
  logic [(15)-1:0] flid;
  logic [(1)-1:0] flid_parity;
  hqm_core_flags_t hqm_core_flags;
} nalb_qed_t;

localparam BITS_NALB_QED_T = $bits(nalb_qed_t);

// dp_lsp_enq_dir          : DIR HCW enqueud
typedef struct packed {
  logic [(7)-1:0] qid;
  logic [(1)-1:0] parity;
} dp_lsp_enq_dir_t;

localparam BITS_DP_LSP_ENQ_DIR_T = $bits(dp_lsp_enq_dir_t);

// dp_lsp_enq_rorply          : DIR reorder replay  is enqueued
typedef struct packed {
  logic [(7)-1:0] qid;
  logic [(1)-1:0] parity;
  logic [(13)-1:0] frag_cnt;
  logic [(2)-1:0] frag_residue;
} dp_lsp_enq_rorply_t;

localparam BITS_DP_LSP_ENQ_RORPLY_T = $bits(dp_lsp_enq_rorply_t);

// dp_dqed             : issue pop/read commands to dQED
//        command==1   : read qe and move {qe_type, qe_qid, qe_lockid } to chp
//        command==2   : pop qe and move to cq
typedef enum logic [(2)-1:0] {
  DP_DQED_ILL0='h0,
  DP_DQED_READ='h1,
  DP_DQED_POP='h2,
  DP_DQED_ILL3='h3
} enum_cmd_dp_dqed_t;

localparam BITS_ENUM_CMD_DP_DQED_T = $bits(enum_cmd_dp_dqed_t);

typedef struct packed {
  enum_cmd_dp_dqed_t cmd;
  logic [(8)-1:0] cq;
  logic [(7)-1:0] qid;
  logic [(3)-1:0] qidix;
  logic [(1)-1:0] parity;       // On cq, qid and qidix
  logic [(15)-1:0] flid;
  logic [(1)-1:0] flid_parity;
  hqm_core_flags_t hqm_core_flags;
} dp_dqed_t;

localparam BITS_DP_DQED_T = $bits(dp_dqed_t);

// ap_aqed             : pop qe and move to cq
typedef struct packed {
  logic [(2)-1:0] cmd;
  logic [(8)-1:0] cq;
  logic [(7)-1:0] qid;
  logic [(3)-1:0] qidix;
  logic [(1)-1:0] parity;       // On cq, qid and qidix
  logic [(12)-1:0] flid;
  logic [(1)-1:0] flid_parity;
  hqm_core_flags_t hqm_core_flags;
  logic [(1)-1:0] pcm;
  logic [(2)-1:0] bin;
} ap_aqed_t;

typedef struct packed {
  logic [ (10)-1:0] spare;
  logic flid_parity;
  logic [(15)-1:0] flid;
} qed_chp_sch_flid_ret_t;

localparam BITS_AP_AQED_T = $bits(ap_aqed_t);

// qed_chp_sch         : qed transmits HCW to credit_hist for processing
//        command==1   : sched qe to cq
//        command==2   : replay qe
//        command==3   : move atq to atm (return credit)
typedef enum logic [(2)-1:0] {
  QED_CHP_SCH_ILL0='h0,
  QED_CHP_SCH_SCHED='h1,
  QED_CHP_SCH_REPLAY='h2,
  QED_CHP_SCH_TRANSFER='h3
} enum_cmd_qed_chp_sch_t;

localparam BITS_ENUM_CMD_QED_CHP_SCH_T = $bits(enum_cmd_qed_chp_sch_t);

typedef struct packed {
  enum_cmd_qed_chp_sch_t cmd;
  logic [(8)-1:0] cq;
  logic [(3)-1:0] qidix;
  logic [(1)-1:0] parity;
  logic [(15)-1:0] flid;
  logic [(1)-1:0] flid_parity;
  hqm_core_flags_t hqm_core_flags;
  hqm_pkg::cq_hcw_t cq_hcw;
  logic [(16)-1:0] cq_hcw_ecc;
} qed_chp_sch_t;

localparam BITS_QED_CHP_SCH_T = $bits(qed_chp_sch_t);

// qed_aqed_enq        : atq to atm transfer
typedef struct packed {
  hqm_pkg::cq_hcw_t cq_hcw;
  logic [(16)-1:0] cq_hcw_ecc;
} qed_aqed_enq_t;

localparam BITS_QED_AQED_ENQ_T = $bits(qed_aqed_enq_t);
typedef struct packed {
  logic [(16)-1:0] newlockid;
  hqm_pkg::cq_hcw_t cq_hcw;
  logic [(16)-1:0] cq_hcw_ecc;
} fifo_qed_aqed_enq_t;

localparam BITS_FIFO_QED_AQED_ENQ_T = $bits(fifo_qed_aqed_enq_t);


// dqed_chp_sch        : dqed transmits HCW to credit_hist for processing
//        command==1   : sched qe to cq
//        command==2   : replay qe
typedef enum logic [(2)-1:0] {
  DQED_CHP_SCH_ILL0='h0,
  DQED_CHP_SCH_SCHED='h1,
  DQED_CHP_SCH_REPLAY='h2,
  DQED_CHP_SCH_ILL3='h3
} enum_cmd_dqed_chp_sch_t;

localparam BITS_ENUM_CMD_DQED_CHP_SCH_T = $bits(enum_cmd_dqed_chp_sch_t);

typedef struct packed {
  enum_cmd_dqed_chp_sch_t cmd;
  logic [(8)-1:0] cq;
  logic [(1)-1:0] parity;
  logic [(15)-1:0] flid;
  logic [(1)-1:0] flid_parity;
  hqm_core_flags_t hqm_core_flags;
  hqm_pkg::cq_hcw_t cq_hcw;
  logic [(16)-1:0] cq_hcw_ecc;
} dqed_chp_sch_t;

localparam BITS_DQED_CHP_SCH_T = $bits(dqed_chp_sch_t);

// aqed_ap_enq         : atomic ap task is enqueued
typedef struct packed {
  logic [(7)-1:0] qid;
  logic [(3)-1:0] qpri;
  logic [(1)-1:0] parity;       // On qid and qpri
  logic [(12)-1:0] flid;
  logic [(1)-1:0] flid_parity;
} aqed_ap_enq_t;

localparam BITS_AQED_AP_ENQ_T = $bits(aqed_ap_enq_t);

// aqed_chp_sch        : aqed transmits HCW to credit_hist for processing
typedef struct packed {
  logic [(8)-1:0] cq;
  logic [(7)-1:0] qid;
  logic [(3)-1:0] qidix;
  logic [(1)-1:0] parity;
  logic [(12)-1:0] fid;
  logic [(1)-1:0] fid_parity;
  hqm_core_flags_t hqm_core_flags;
  hqm_pkg::cq_hcw_t cq_hcw;
  logic [(16)-1:0] cq_hcw_ecc;

} aqed_chp_sch_t;

localparam BITS_AQED_CHP_SCH_T = $bits(aqed_chp_sch_t);

// aqed_lsp_sch        : aqed transmits HCW to lsp to update AQEDCNT after freelist is updated
typedef struct packed {
  logic [(8)-1:0] cq;
  logic [(7)-1:0] qid;
  logic [(3)-1:0] qidix;
  logic [(1)-1:0] parity;
  logic [(15)-1:0] flid;
  logic [(1)-1:0] flid_parity;
} aqed_lsp_sch_t;

localparam BITS_AQED_LSP_SCH_T = $bits(aqed_lsp_sch_t);

// ap_lsp_enq          : atomic ap task is enqueued
typedef struct packed {
  logic [(7)-1:0] qid;
  logic [(1)-1:0] parity;
} ap_lsp_enq_t;

localparam BITS_AP_LSP_ENQ_T = $bits(ap_lsp_enq_t);


//-----------------------------------------------------------------------------------------------------
// HQM_CORE paramters

parameter HQM_CHP_DIR_VAS_CRD_CNT_MEM_DEPTH = 4*1024;
parameter HQM_CHP_LDB_VAS_CRD_CNT_MEM_DEPTH = 4*1024;

parameter HQM_NUM_PRI = 8 ;
parameter HQM_QID_PER_CQ = 8 ;
parameter HQM_NUM_DIR_QID = NUM_DIR_QID ;
parameter HQM_NUM_DIR_CQ = NUM_DIR_CQ;
parameter HQM_NUM_LB_QID = 32 ;
parameter HQM_NUM_LB_CQ = NUM_LDB_CQ ;
parameter HQM_NUM_LB_PCQ = NUM_LDB_CQ >> 1 ;
parameter HQM_NUM_CQ = HQM_NUM_DIR_CQ+HQM_NUM_LB_CQ;
parameter HQM_NUM_PP = HQM_NUM_DIR_CQ+HQM_NUM_LB_CQ;

parameter HQM_DQED_DEPTH = 8*1024 ;
parameter HQM_CHP_DQED_DEPTH = 8*1024 ; // this is fixed at 8K to keep fields fixed in the design

parameter HQM_QED_DEPTH = 32*1024;
parameter HQM_CHP_QED_DEPTH = 32*1024; // This is fixed at 32K to keep fields fixed in the design

parameter HQM_AQED_DEPTH = 2*1024 ;

// collage-pragma translate_off

parameter HQM_DQED_DEPTHB2 = (AW_logb2(HQM_DQED_DEPTH-1)+1);
parameter HQM_QED_DEPTHB2 = (AW_logb2(HQM_QED_DEPTH-1)+1);
parameter HQM_AQED_DEPTHB2 = (AW_logb2(HQM_AQED_DEPTH-1)+1);
parameter HQM_NUM_PRIB2 = (AW_logb2(HQM_NUM_PRI-1)+1);
parameter HQM_QIDIX = (AW_logb2(HQM_QID_PER_CQ-1)+1);
parameter HQM_NUM_DIR_QIDB2 = (AW_logb2(HQM_NUM_DIR_QID-1)+1);
parameter HQM_NUM_DIR_CQB2 = (AW_logb2(HQM_NUM_DIR_CQ-1)+1);
parameter HQM_NUM_LB_QIDB2 = (AW_logb2(HQM_NUM_LB_QID-1)+1);
parameter HQM_NUM_LB_CQB2 = (AW_logb2(HQM_NUM_LB_CQ-1)+1);
parameter HQM_NUM_LB_PCQB2 = (AW_logb2(HQM_NUM_LB_PCQ-1)+1);
parameter HQM_NUM_CQB2 = (AW_logb2(HQM_NUM_CQ-1)+1);

// collage-pragma translate_on

parameter HQM_RESET_STATUS_DEFAULT = 32'h00000001;
parameter HQM_UNIT_TIMEOUT_DEFAULT = 32'h8000ffff;

//-----------------------------------------------------------------------------------------------------
// CHP paramters

parameter HQM_CHP_NUM_DQED_VAS = NUM_VAS;
parameter HQM_CHP_NUM_QED_VAS = NUM_VAS;

parameter HQM_CHP_QED_TO_CQ_FIFO_DEPTH = 8;

parameter HQM_CHP_ROP_HCW_FIFO_DEPTH = 16;

parameter HQM_CHP_LSP_TOK_FIFO_DEPTH = 16;

parameter HQM_CHP_LSP_AP_CMP_FIFO_DEPTH = 16;

parameter HQM_CHP_OUTBOUND_HCW_FIFO_DEPTH = 16;

parameter HQM_CHP_INBOUND_SMON_WIDTH = 24;
parameter HQM_CHP_OUTBOUND_SMON_WIDTH = 24;
parameter HQM_CHP_SMON_WIDTH = 32;
parameter HQM_CHP_PERF_SMON_WIDTH = 6;
parameter HQM_CHP_MEAS_SMON_WIDTH = 8;

parameter HQM_CHP_DIR_CQ_DEPTH_WIDTH = 11;
parameter HQM_CHP_DIR_CQ_WP_WIDTH = 11;

parameter HQM_CHP_LDB_CQ_DEPTH_WIDTH = 11;
parameter HQM_CHP_LDB_CQ_WP_WIDTH = 11;

parameter HQM_CHP_CQ_DEPTH_WIDTH = 11; 
parameter HQM_CHP_CQ_WP_WIDTH = 11;


parameter HQM_CHP_PP_PUSH_PTR_MEM_DEPTH = NUM_DIR_PP+NUM_LDB_PP;
parameter HQM_CHP_LDB_PP_PUSH_PTR_WIDTH = 16;
parameter HQM_CHP_DIR_PP_PUSH_PTR_WIDTH = 16;

parameter HQM_CHP_HIST_LIST_DEPTH = 5*1024;
parameter HQM_CHP_HIST_LIST0_DATA_WIDTH = 16; //$bits(hist_list_info_t.qidix) + $bits(hist_list_info_t.qpri) +$bits(hist_list_info_t.qtype) +$bits(hist_list_info_t.reord_slot) +$bits(hist_list_info_t.reord_mode);
parameter HQM_CHP_HIST_LIST1_DATA_WIDTH = 20; //$bits(hist_list_info_t.qid) + $bits(hist_list_info_t.sn_fid);

// collage-pragma translate_off

parameter HQM_CHP_DQED_VAS_WIDTH = (AW_logb2(HQM_CHP_NUM_DQED_VAS-1)+1);
parameter HQM_CHP_QED_VAS_WIDTH = (AW_logb2(HQM_CHP_NUM_QED_VAS-1)+1);
parameter HQM_CHP_DQED_DEPTH_WIDTH = (AW_logb2(HQM_CHP_DQED_DEPTH-1)+1);

parameter HQM_CHP_NUM_VAS=32;

parameter HQM_CHP_QED_DEPTH_WIDTH = (AW_logb2(HQM_CHP_QED_DEPTH-1)+1);
parameter HQM_CHP_VAS_CRD_CNT_MEM_DEPTH_WIDTH = (AW_logb2(HQM_CHP_NUM_VAS-1)+1);

parameter HQM_CHP_QED_TO_CQ_FIFO_DEPTH_WIDTH = (AW_logb2(HQM_CHP_QED_TO_CQ_FIFO_DEPTH-1)+1);
parameter HQM_CHP_QED_TO_CQ_FIFO_WMWIDTH = (AW_logb2(HQM_CHP_QED_TO_CQ_FIFO_DEPTH+1)+1);
parameter HQM_CHP_QED_TO_CQ_PIPE_CREDIT_STATUS_WIDTH = HQM_CHP_QED_TO_CQ_FIFO_WMWIDTH + 1 + 1 + 1 + 1 ;
parameter HQM_CHP_ROP_HCW_FIFO_DEPTH_WIDTH = (AW_logb2(HQM_CHP_ROP_HCW_FIFO_DEPTH-1)+1);
parameter HQM_CHP_ROP_HCW_FIFO_WMWIDTH = (AW_logb2(HQM_CHP_ROP_HCW_FIFO_DEPTH+1)+1);
parameter HQM_CHP_ROP_PIPE_CREDIT_STATUS_WIDTH = HQM_CHP_ROP_HCW_FIFO_WMWIDTH + 1 + 1 + 1 + 1 ;
parameter HQM_CHP_LSP_TOK_FIFO_DEPTH_WIDTH = (AW_logb2(HQM_CHP_LSP_TOK_FIFO_DEPTH-1)+1);
parameter HQM_CHP_LSP_TOK_FIFO_WMWIDTH = (AW_logb2(HQM_CHP_LSP_TOK_FIFO_DEPTH+1)+1);
parameter HQM_CHP_LSP_TOK_PIPE_CREDIT_STATUS_WIDTH = HQM_CHP_LSP_TOK_FIFO_WMWIDTH + 1 + 1 + 1 + 1 ;
parameter HQM_CHP_LSP_AP_CMP_FIFO_DEPTH_WIDTH = (AW_logb2(HQM_CHP_LSP_AP_CMP_FIFO_DEPTH-1)+1);
parameter HQM_CHP_LSP_AP_CMP_FIFO_WMWIDTH = (AW_logb2(HQM_CHP_LSP_AP_CMP_FIFO_DEPTH+1)+1);
parameter HQM_CHP_LSP_AP_CMP_PIPE_CREDIT_STATUS_WIDTH = HQM_CHP_LSP_AP_CMP_FIFO_WMWIDTH + 1 + 1 + 1 + 1 ;
parameter HQM_CHP_HIST_LIST_DEPTH_WIDTH = (AW_logb2(HQM_CHP_HIST_LIST_DEPTH-1)+1);
parameter HQM_CHP_HIST_LIST_PTR_MEM_ADDR_WIDTH = (AW_logb2(HQM_NUM_LB_CQ-1)+1);
parameter HQM_CHP_HIST_LIST_MINMAX_MEM_ADDR_WIDTH = (AW_logb2(HQM_NUM_LB_CQ-1)+1);
parameter HQM_CHP_OUTBOUND_HCW_FIFO_DEPTH_WIDTH = (AW_logb2(HQM_CHP_OUTBOUND_HCW_FIFO_DEPTH-1)+1);
parameter HQM_CHP_OUTBOUND_HCW_FIFO_WMWIDTH = (AW_logb2(HQM_CHP_OUTBOUND_HCW_FIFO_DEPTH+1)+1);
parameter HQM_CHP_OUTBOUND_HCW_PIPE_CREDIT_STATUS_WIDTH = HQM_CHP_OUTBOUND_HCW_FIFO_WMWIDTH + 1 + 1 + 1 + 1 ;

parameter HQM_NUM_SN_GRP = 2;
parameter HQM_NUM_SN_GRP_WIDTH = (AW_logb2(HQM_NUM_SN_GRP-1)+1);



// collage-pragma translate_on

parameter HQM_CHP_ENQ_ARB_REQ0_WEIGHT = 8'h25;  //  37
parameter HQM_CHP_ENQ_ARB_REQ1_WEIGHT = 8'h4a;  //  74 
parameter HQM_CHP_ENQ_ARB_REQ2_WEIGHT = 8'h6f;  // 111 
parameter HQM_CHP_ENQ_ARB_REQ3_WEIGHT = 8'h94;  // 148 
parameter HQM_CHP_ENQ_ARB_REQ4_WEIGHT = 8'hb9;  // 185
parameter HQM_CHP_ENQ_ARB_REQ5_WEIGHT = 8'hde;  // 222 
parameter HQM_CHP_ENQ_ARB_REQ6_WEIGHT = 8'hff;  // 255 
parameter HQM_CHP_ENQ_ARB_REQ7_WEIGHT = 8'h00;  //   0 

typedef struct packed {
  //logic        hcw_comp;
  //logic [12:0] cq_comp_depth;
  logic [10:0] cq_depth;
  logic        hcw_enq;
  logic [7:0]  hcw_cq;
} cq_wd_info_t;

localparam BITS_CQ_WD_INFO_T = $bits(cq_wd_info_t);

// struct used by hqm_chp_int.sv
typedef struct packed {
  logic        en_tim;
  logic        en_depth;
} cfg_int_en_t;

localparam BITS_CFG_INT_EN_T = $bits(cfg_int_en_t);

// support for 2 groups, 16 slots, 8 modes
//
// mode 0   32 qids   64sn per qid
// mode 1   16 qids  128sn per qid
// mode 2    8 qids  256sn per qid
// mode 3    4 qids  512sn per qid
// mode 4    2 qids 1024sn per qid
// mode 5  reserved
// mode 6  reserved
// mode 7  reserved

typedef enum logic [2:0] {
   QIDS_32_SN_64  = 3'b000,
   QIDS_16_SN_128 = 3'b001,
   QIDS_8_SN_256  = 3'b010,
   QIDS_4_SN_512  = 3'b011,
   QIDS_2_SN_1024 = 3'b100,
   RESV5          = 3'b101,
   RESV6          = 3'b110,
   RESV7          = 3'b111
} chp_qid_sn_map_mode_dec_t;

localparam BITS_CHP_QID_SN_MAP_MODE_DEC_T = $bits(chp_qid_sn_map_mode_dec_t);

typedef struct packed {
   logic [1:0] group;
   logic [4:0] slot;
   chp_qid_sn_map_mode_dec_t mode;
} chp_qid_sn_map_field_t;

typedef struct packed {
   logic spare ;
   logic  parity;
   chp_qid_sn_map_field_t map;
} chp_ord_qid_sn_map_t;

localparam BITS_CHP_QID_SN_MAP_FIELD_T = $bits(chp_qid_sn_map_field_t);

typedef struct packed {
   logic [1:0] residue;
   logic [9:0] sn;
} chp_ord_qid_sn_t;

localparam BITS_CHP_ORD_QID_SN_T = $bits(chp_ord_qid_sn_t);

typedef struct packed {
   logic [11:0] qid2fid_map;
   logic [11:0] qid2fid_mask;
   logic [3:0]  hash_size;
} chp_ldb_qid2fid_t;

localparam BITS_CHP_LDB_QID2FID_T = $bits(chp_ldb_qid2fid_t);

typedef enum logic [7:0] {
   HCW_SRC_ID_UNKNOWN    = 8'b0000_0000,
   DIR_PP_HCW            = 8'b0000_0001,
   LDB_PP_HCW	         = 8'b0000_0010,
   DIR_REPLAY            = 8'b0000_0100,
   LDB_REPLAY            = 8'b0000_1000,
   DQED_TO_CQ            = 8'b0001_0000,
   QED_TO_CQ             = 8'b0010_0000,
   ATQ2ATM               = 8'b0100_0000,
   AQED_TO_CQ            = 8'b1000_0000
} chp_hcw_src_id_dec_t;

localparam BITS_CHP_HCW_SRC_ID_DEC_T = $bits(chp_hcw_src_id_dec_t);

typedef struct packed {
  logic								cq_is_ldb ;
  logic								flid_parity ;
  logic [ 14 : 0 ]						flid ;
  logic [ 15 : 0 ]						cq_hcw_ecc ;
  cq_hcw_t							cq_hcw ;
} chp_hcw_replay_data_t ;

typedef struct packed {
  logic [ 15 : 0 ]						cq_hcw_ecc ;
  cq_hcw_t							cq_hcw ;
} chp_pp_data_t ;

typedef struct packed {
  logic								hcw_enq_user_parity_error_drop ;
  logic								out_of_credit ;
  logic								no_dec ;
  logic [ 3 : 0 ]						cmp_id ;
  logic								ao_v ;
  logic								qe_is_ldb ;
  logic								pp_is_ldb ;
  logic								pp_parity ;
  logic [ 7 : 0 ]						pp ;
  logic								qid_parity ;
  logic [ 7 : 0 ]						qid ;
  logic [ 4 : 0 ]						vas ;
  logic 							hcw_cmd_parity ;
  hcw_cmd_dec_t							hcw_cmd ;
} chp_pp_info_t ;

typedef struct packed {
   //ppeline control
   logic                                                        atmsch ;  //identify the command as atm schedule
   logic                                                        ignore_cq_depth ;//flushed HCW

   //send to egress
   logic [ 15 : 0 ]						cq_hcw_ecc ;
   cq_hcw_t							cq_hcw ;
   hqm_core_flags_t						hqm_core_flags ;
   logic [ 3 : 0 ]						cmp_id ;
   logic [ 7 : 0 ]						cq ;
   logic							error ;

   // histlist control
   logic                                                        hist_list_v ;
   hist_list_mf_t                                               hist_list_data ;

} sch_chp_state_t ;

typedef struct packed {
   logic 							hcw_enq_user_parity_error_drop ;
   logic 							excess_frag_drop ;
   logic							cmp_id_error ;
   logic							cmp_id_check ;
   logic [ 3 : 0 ]						cmp_id ;
   logic [ 1 : 0 ]						tokens_residue ;
   logic [ 15 : 0 ]						tokens ;
   logic 							hid_parity ;
   logic							freelist_error_mb ;
   logic							freelist_uf ;
   logic							hist_list_residue_error ;
   logic							hist_list_uf ;
   hist_list_mf_t    						hist_list ;
   logic							to_rop_replay ;
   logic							to_rop_nop ; // decode of NOOP. this goes to rop unconditionally
   logic							to_rop_frag ; // decode of FRAG,FRAG_T 
   logic							to_rop_enq ; // decode of NEW,NEW_T,RENQ,RENQ_T,FRAG,FRAG_T. these go to rop if vas credit check is ok and there's no freelist error
   logic							to_rop_cmp ; // decode of COMP,COMP_T. these go to rop only if the hist_list qtype is ORDERED
   logic							to_lsp_tok ; // decode of BAT_T,COMP_T,NEW_T,RENQ_T,FRAG_T. these go to lsp for token return
   logic							to_lsp_cmp ; // decode of COMP,COMP_T,RENQ,RENQ_T. these go to lsp for completion 
   logic							cial_arm ; // decode of ARM. this only goes to CIAL
   logic							to_lsp_release ; // decode of RELEASE. this only goes to lsp
   logic 							out_of_credit ;
   logic							no_dec ;
   logic							qe_is_ldb ;
   logic [ 7 : 0 ]						vas ;
   logic 							pp_parity ;
   logic [ 7 : 0 ]						pp ;
   logic 							qid_parity ;
   logic [ 7 : 0 ]						qid ;
   logic 							flid_parity ;
   logic [ 14 : 0 ] 						flid ;
   chp_hcw_src_id_dec_t						hcw_src_id ;
   logic							hcw_cmd_parity ;
   hcw_cmd_t							hcw_cmd ;
   logic [ 15 : 0 ]						cq_hcw_ecc ;
   cq_hcw_t							cq_hcw ;
} enq_chp_state_t ;

// collage-pragma translate_off

typedef struct packed {
   logic 						parity ;
   logic [ HQM_CHP_DQED_DEPTH_WIDTH : 0 ] 		limit ;			// 16K dir freelist
} chp_dir_vas_credit_limit_t ;

parameter HQM_CHP_DIR_VAS_CRD_LIMIT_MEM_WIDTH = $bits ( chp_dir_vas_credit_limit_t ) ;

typedef struct packed {
   logic [ 1 : 0 ] 					residue ;
   logic [ 14 : 0	]	count ;			// 32K ldb freelist // adjust to new 8K credit
} chp_credit_count_t;

typedef struct packed {
   qed_chp_sch_t    qed_chp_sch_data;
   logic [4:0]               slot;
   chp_qid_sn_map_mode_dec_t mode;
   logic [11:0]      sn;   
} chp_qed_to_cq_t;

typedef struct packed {
   logic [1:0] pop_ptr_residue ;
   logic pop_ptr_gen ;
   logic [HQM_CHP_HIST_LIST_DEPTH_WIDTH-1:0] pop_ptr;
   logic [1:0] push_ptr_residue ;
   logic push_ptr_gen ;
   logic [HQM_CHP_HIST_LIST_DEPTH_WIDTH-1:0] push_ptr;
} chp_hist_list_ptr_mem_t;

typedef struct packed {
   logic [1:0] max_addr_residue ;
   logic [HQM_CHP_HIST_LIST_DEPTH_WIDTH-1:0] max_addr;
   logic [1:0] min_addr_residue ;
   logic [HQM_CHP_HIST_LIST_DEPTH_WIDTH-1:0] min_addr;
} chp_hist_list_minmax_mem_t;

typedef struct packed {
   logic [1:0] pop_ptr_residue ;
   logic pop_ptr_gen ;
   logic [HQM_CHP_DQED_DEPTH_WIDTH-1:0] pop_ptr;
   logic [1:0] push_ptr_residue ;
   logic push_ptr_gen ;
   logic [HQM_CHP_DQED_DEPTH_WIDTH-1:0] push_ptr;
} chp_dqed_freelist_ptr_mem_t;

typedef struct packed {
   logic [1:0] max_addr_residue ;
   logic [HQM_CHP_DQED_DEPTH_WIDTH-1:0] max_addr;
   logic [1:0] min_addr_residue ;
   logic [HQM_CHP_DQED_DEPTH_WIDTH-1:0] min_addr;
} chp_dqed_freelist_minmax_mem_t;

typedef struct packed {
   logic        flid_parity; 
   logic [13:0] flid;
} chp_flid_t;

typedef struct packed {
   logic [1:0] pop_ptr_residue ;
   logic pop_ptr_gen ;
   logic [13:0] pop_ptr;
   logic [1:0] push_ptr_residue ;
   logic push_ptr_gen ;
   logic [13:0] push_ptr;
} chp_qed_freelist_ptr_mem_t;

typedef struct packed {
   logic [1:0] max_addr_residue ;
   logic [13:0] max_addr;
   logic [1:0] min_addr_residue ;
   logic [13:0] min_addr;
} chp_qed_freelist_minmax_mem_t;

typedef struct packed {
   logic [4:0] flid_ecc; 
   logic [10:0] flid; 
} chp_freelist_t;

typedef struct packed {
   logic [1:0] residue;
   logic [HQM_CHP_DIR_CQ_WP_WIDTH-1:0] wp;
} chp_dir_cq_wp_t;

typedef struct packed {
   logic [1:0] residue;
   logic [HQM_CHP_DIR_CQ_DEPTH_WIDTH-1:0] depth;
} chp_dir_cq_depth_t;

typedef struct packed {
   logic [1:0] residue;
   logic [HQM_CHP_LDB_CQ_WP_WIDTH-1:0] wp;
} chp_ldb_cq_wp_t;

typedef struct packed {
   logic [1:0] residue;
   logic [HQM_CHP_LDB_CQ_DEPTH_WIDTH-1:0] depth;
} chp_ldb_cq_depth_t;

typedef struct packed {
   logic spare ;
   logic parity;
   logic [3:0] depth_select;
} chp_cq_token_depth_select_t;

typedef struct packed {
  logic [1:0] qe_wt ;
  logic [1:0] user;
  logic [7:0] pp;
  logic pp_parity;
  logic [6:0] qid;
  logic qid_parity;
  hist_list_info_t hist_list_info;
  logic hid_parity;
  logic [15:0] hid;
} fifo_chp_lsp_ap_cmp_t;

typedef struct packed {
  logic enable ;
  logic [ 15 : 0 ] period ;
} cfg_palb_control_t ;

typedef struct packed {
  logic [1 : 0 ] parity ;
  logic [ 14 : 0 ] off_thrsh ;
  logic [ 14 : 0 ] on_thrsh ;
} ldb_cq_on_off_threshold_t;

parameter HQM_CHP_DQED_FREELIST_PTR_MEM_WIDTH = $bits (chp_dqed_freelist_ptr_mem_t);
parameter HQM_CHP_DQED_FREELIST_MINMAX_MEM_WIDTH = $bits (chp_dqed_freelist_minmax_mem_t);
parameter HQM_CHP_QED_FREELIST_PTR_MEM_WIDTH = $bits (chp_qed_freelist_ptr_mem_t);
parameter HQM_CHP_QED_FREELIST_MINMAX_MEM_WIDTH = $bits (chp_qed_freelist_minmax_mem_t);

// collage-pragma translate_on

//-----------------------------------------------------------------------------------------------------
// ROP Params

typedef struct packed {
   logic            parity;
   logic [2:0]      qpri;
   logic [6 : 0]    cq; 
   dp_frag_list_info_t frag_list_info;
   logic [6 : 0]    qid;
   logic [2 : 0]    qidix;
   logic qidix_msb;
} dp_rply_data_t;

localparam BITS_DP_RPLY_DATA_T = $bits(dp_rply_data_t);
  
typedef struct packed {
   logic            parity;
   logic [2:0]      qpri;
   logic [6 : 0]    cq;
   nalb_frag_list_info_t frag_list_info;
   logic [6 : 0]    qid;
   logic [2 : 0]    qidix;
   logic qidix_msb;
} nalb_rply_data_t;

localparam BITS_NALB_RPLY_DATA_T = $bits(nalb_rply_data_t);

parameter HQM_ROP_CHP_ROP_HCW_FIFO_DEPTH            = 4 ;
parameter HQM_ROP_DIR_RPLY_REQ_FIFO_DEPTH           = 8;
parameter HQM_ROP_LDB_RPLY_REQ_FIFO_DEPTH           = 8;
parameter HQM_ROP_SN_COMPLETE_FIFO_DEPTH            = 4;
parameter HQM_ROP_SN_ORDERED_FIFO_DEPTH             = 32;
parameter HQM_ROP_LSP_REORDERCMP_FIFO_DEPTH         = 8;

// collage-pragma translate_off

parameter HQM_ROP_CHP_ROP_HCW_FIFO_DEPTHB2          = AW_logb2 ( HQM_ROP_CHP_ROP_HCW_FIFO_DEPTH -1 ) + 1;
parameter HQM_ROP_CHP_ROP_HCW_FIFO_DEPTHWIDTH       = AW_logb2 ( HQM_ROP_CHP_ROP_HCW_FIFO_DEPTH +1 ) + 1;
parameter HQM_ROP_CHP_ROP_HCW_FIFO_WMWIDTH          = AW_logb2 ( HQM_ROP_CHP_ROP_HCW_FIFO_DEPTH +2 ) + 1;
parameter HQM_ROP_DIR_RPLY_REQ_FIFO_DEPTHB2         = AW_logb2 ( HQM_ROP_DIR_RPLY_REQ_FIFO_DEPTH -1 ) + 1;
parameter HQM_ROP_DIR_RPLY_REQ_FIFO_DEPTHWIDTH      = AW_logb2 ( HQM_ROP_DIR_RPLY_REQ_FIFO_DEPTH +1 ) + 1;
parameter HQM_ROP_DIR_RPLY_REQ_FIFO_WMWIDTH         = AW_logb2 ( HQM_ROP_DIR_RPLY_REQ_FIFO_DEPTH +2 ) + 1;
parameter HQM_ROP_LDB_RPLY_REQ_FIFO_DEPTHB2         = AW_logb2 ( HQM_ROP_LDB_RPLY_REQ_FIFO_DEPTH -1 ) + 1;
parameter HQM_ROP_LDB_RPLY_REQ_FIFO_DEPTHWIDTH      = AW_logb2 ( HQM_ROP_LDB_RPLY_REQ_FIFO_DEPTH +1 ) + 1;
parameter HQM_ROP_LDB_RPLY_REQ_FIFO_WMWIDTH         = AW_logb2 ( HQM_ROP_LDB_RPLY_REQ_FIFO_DEPTH +2 ) + 1;
parameter HQM_ROP_SN_COMPLETE_FIFO_DEPTHB2          = AW_logb2 ( HQM_ROP_SN_COMPLETE_FIFO_DEPTH -1 ) + 1;
parameter HQM_ROP_SN_COMPLETE_FIFO_DEPTHWIDTH       = AW_logb2 ( HQM_ROP_SN_COMPLETE_FIFO_DEPTH +1 ) + 1;
parameter HQM_ROP_SN_COMPLETE_FIFO_WMWIDTH          = AW_logb2 ( HQM_ROP_SN_COMPLETE_FIFO_DEPTH +2 ) + 1;
parameter HQM_ROP_SN_ORDERED_FIFO_DEPTHB2           = AW_logb2 ( HQM_ROP_SN_ORDERED_FIFO_DEPTH -1 ) + 1;
parameter HQM_ROP_SN_ORDERED_FIFO_DEPTHWIDTH        = AW_logb2 ( HQM_ROP_SN_ORDERED_FIFO_DEPTH +1 ) + 1;
parameter HQM_ROP_SN_ORDERED_FIFO_WMWIDTH           = AW_logb2 ( HQM_ROP_SN_ORDERED_FIFO_DEPTH +2 ) + 1;
parameter HQM_ROP_LSP_REORDERCMP_FIFO_DEPTHB2       = AW_logb2 ( HQM_ROP_LSP_REORDERCMP_FIFO_DEPTH -1 ) + 1;
parameter HQM_ROP_LSP_REORDERCMP_FIFO_DEPTHWIDTH    = AW_logb2 ( HQM_ROP_LSP_REORDERCMP_FIFO_DEPTH +1 ) + 1;
parameter HQM_ROP_LSP_REORDERCMP_FIFO_WMWIDTH       = AW_logb2 ( HQM_ROP_LSP_REORDERCMP_FIFO_DEPTH +2 ) + 1;

// collage-pragma translate_on

typedef struct packed {
chp_rop_hcw_t      chp_rop_hcw;
logic              flid_parity_err;
logic              hcw_ecc_mb_err;
} errors_plus_chp_rop_hcw_t;

localparam BITS_ERRORS_PLUS_CHP_ROP_HCW_T = $bits(errors_plus_chp_rop_hcw_t);

typedef struct packed {
  logic [11:0]   sn;
  logic [2:0]    grp_mode;
  logic [4:0]    grp_slt;
} sn_complete_t;

localparam BITS_SN_COMPLETE_T = $bits(sn_complete_t);


typedef struct packed {
logic             hcw_v;
logic             is_ldb;
logic [13:0]      threshold ;
logic [7:0]       cq ;
logic [12:0]      depth ;
hqm_pkg::hcw_cmd_dec_t cmd ;
} cq_int_info_t ;


typedef struct packed {
hqm_pkg::hcw_sched_w_req_t tx_data ;
cq_int_info_t              cial_data ;
} fifo_chp_sys_tx_fifo_mem_data_t ;


localparam BITS_CQ_INT_INFO_T = $bits(cq_int_info_t);

typedef struct packed {
   logic parity;
   logic [11:0]    threshold;
} cfg_ldb_cq_intcfg_t;

typedef struct packed {
   logic parity;
   logic [13:0]    threshold;
} cfg_dir_cq_intcfg_t;

typedef struct packed {
   logic parity;
   logic [11:0]    threshold;
} cfg_cq_intcfg_t;

localparam BITS_CFG_CQ_INTCFG_T = $bits(cfg_cq_intcfg_t);

//-----------------------------------------------------------------------------------------------------
// LSP structs, parameters

parameter       HQM_LSP_MAX_DIR_ENQ_COUNT_WIDTH         = 15 ;  // Should be changed to AW_logb2 ( NUM_CREDITS ) + 1
parameter       HQM_LSP_MAX_LB_ENQ_COUNT_WIDTH          = 15 ;  // Should be changed to AW_logb2 ( NUM_CREDITS ) + 1

parameter       HQM_LSP_DIRENQ_ENQ_CNT_WIDTH            = HQM_LSP_MAX_DIR_ENQ_COUNT_WIDTH ;     // Max DIR credits = 16K (V25)
parameter       HQM_LSP_DIRENQ_DPTH_THRSH_WIDTH         = HQM_LSP_MAX_DIR_ENQ_COUNT_WIDTH ;     // Max DIR credits = 16K (V25)
parameter       HQM_LSP_DIRENQ_TOK_CNT_WIDTH            = 11 ;
parameter       HQM_LSP_DIRENQ_TOK_LIM_SEL_WIDTH        = 4 ;
parameter       HQM_LSP_LB_ATM_ENQ_CNT_WIDTH            = 12 ;
parameter       HQM_LSP_LB_QID_ENQ_CNT_WIDTH            = HQM_LSP_MAX_LB_ENQ_COUNT_WIDTH ;      // Max LB credits = 16K (V25)
parameter       HQM_LSP_LB_QID_DPTH_THRSH_WIDTH         = HQM_LSP_MAX_LB_ENQ_COUNT_WIDTH ;      // Max LB credits = 16K (V25
parameter       HQM_LSP_LB_QID_IF_CNT_WIDTH             = 12 ;  // Max LB per-qid inflight = 2K, limited by max SN per QID
parameter       HQM_LSP_LB_QID_IF_LIM_WIDTH             = 12 ;  // Max LB per-qid inflight = 2K, limited by max SN per QID
parameter       HQM_LSP_LB_CQ_TOK_CNT_WIDTH             = 11 ;
parameter       HQM_LSP_LB_CQ_TOK_LIM_SEL_WIDTH         = 4 ;
parameter       HQM_LSP_LB_CQ_IF_CNT_WIDTH              = 12 + 1 ;  // Max LB per-cq inflight = 2x2K, limited by hist list depth
parameter       HQM_LSP_LB_CQ_IF_LIM_WIDTH              = 12 + 1 ;  // Max LB per-cq inflight = 2x2K, limited by hist list depth
parameter       HQM_LSP_LB_CQ_IF_THR_WIDTH              = 12 + 1 ;  // Max useful value = max if_lim + 1 = 2K+1
parameter       HQM_LSP_ATQ_ENQ_CNT_WIDTH               = HQM_LSP_MAX_LB_ENQ_COUNT_WIDTH ;      // Max LB credits = 16K (V25)
parameter       HQM_LSP_ATQ_ATM_ACTIVE_WIDTH            = HQM_LSP_MAX_LB_ENQ_COUNT_WIDTH ;      // Max LB credits = 16K (V25)
parameter       HQM_LSP_ATQ_QID_DPTH_THRSH_WIDTH        = HQM_LSP_MAX_LB_ENQ_COUNT_WIDTH ;      // Max LB credits = 16K (V25)
parameter       HQM_LSP_ATQ_AQED_ACT_CNT_WIDTH          = 12 ;  // AQED depth (max "atomic credits" per QID) = 2K
parameter       HQM_LSP_ATQ_AQED_ACT_LIM_WIDTH          = 12 ;  // AQED depth (max "atomic credits" per QID) = 2K
parameter       HQM_LSP_DIRRPL_ENQ_CNT_WIDTH            = HQM_LSP_MAX_DIR_ENQ_COUNT_WIDTH ;     // Max DIR credits = 16K (V25)
parameter       HQM_LSP_LBRPL_ENQ_CNT_WIDTH             = HQM_LSP_MAX_LB_ENQ_COUNT_WIDTH ;      // Max LB credits = 16K (V25)
parameter       HQM_LSP_ARCH_CNT_WIDTH                  = 64 ;
parameter       HQM_LSP_ATQ_FID_IF_CNT_WIDTH            = 12 ;
parameter       HQM_LSP_LBWU_CQ_WU_CNT_WIDTH            = 17 ;  // sign plus 16 bits of count (including extra bit for pipe latency)
parameter       HQM_LSP_LBWU_CQ_WU_LIM_WIDTH            = 15 ;  // limit only; does not include the valid bit


typedef struct packed {
  logic  hold ;
  logic  en ;
} lsp_pipe_ctrl_t ;

typedef enum logic [1:0] {
   HQM_LSP_LBWU_CMD_DEQ          = 2'h0
 , HQM_LSP_LBWU_CMD_CMP          = 2'h1
 , HQM_LSP_LBWU_CMD_CFG          = 2'h2
 , HQM_LSP_LBWU_CMD_ERR          = 2'h3
} hqm_lsp_lbwu_cmd_t ;

typedef struct packed {
  logic [1:0]                           cmd ;
  logic [1:0]                           qe_wt ;
  logic                                 parity;
} lbwu_ctrl_pipe_t ;

typedef struct packed {
  logic                                 user ;
  logic [6:0]                           cq ;
  logic [5:0]                           qid ;
  logic [1:0]                           qe_wt ;
  logic                                 parity ;        // On cq, qid and qe_wt
  logic [2:0]                           qpri ;
  logic                                 qidix_msb ;
  logic [2:0]                           qidix ;
  logic                                 cmp_p ;
  logic [11:0]                          fid ;
  logic                                 fid_p ;
  logic [15:0]                          hid ;
  logic                                 hid_p ;
} lsp_atm_cmp_t;

localparam BITS_LSP_ATM_CMP_T = $bits(lsp_atm_cmp_t);

typedef struct packed {
  logic [1:0]                           spare ;
  logic [1:0]                           user ;
  logic [7:0]                           cq ;
  logic [6:0]                           qid ;
  logic                                 cq_qid_p ;
} lsp_uno_atm_cmp_t;

localparam BITS_LSP_UNO_ATM_CMP_T = $bits(lsp_uno_atm_cmp_t);

typedef struct packed {
  logic [7:0]                           cq ;
  logic [6:0]                           qid ;
  logic [1:0]                           qe_wt ;
  logic                                 parity ;        // On cq, qid and qe_wt
} lsp_nalb_cmp_t;

localparam BITS_LSP_NALB_CMP_T = $bits(lsp_nalb_cmp_t);

typedef struct packed {
  logic [7:0]   cq;
  logic         is_ldb;
  logic         parity;
  logic [12:0]  count;
  logic [1:0]   count_residue;
} lsp_ldb_token_rtn_t;

localparam BITS_LSP_LDB_TOKEN_RTN_T = $bits(lsp_ldb_token_rtn_t);


parameter       HQM_LSP_LBWU_CFG_CTRL_WUCNT_WR          = 2'h0 ;
parameter       HQM_LSP_LBWU_CFG_CTRL_WUCNT_RD          = 2'h1 ;
parameter       HQM_LSP_LBWU_CFG_CTRL_WULIM_WR          = 2'h2 ;
parameter       HQM_LSP_LBWU_CFG_CTRL_WULIM_RD          = 2'h3 ;

parameter       HQM_LSP_LBWU_CFGSM_IDLE                 = 4'h1 ;
parameter       HQM_LSP_LBWU_CFGSM_VLD                  = 4'h2 ;
parameter       HQM_LSP_LBWU_CFGSM_WT_RDATA             = 4'h4 ;

parameter       HQM_LSP_LBWU_CFGSM_ACK                  = 4'h8 ;

parameter       HQM_LSP_ARCH_NUM_FID                    = 4096 ;
parameter       HQM_LSP_ARCH_NUM_LB_QID                 = 128 ;
parameter       HQM_LSP_ARCH_NUM_LB_CQ                  = 64 ;
parameter       HQM_LSP_ARCH_NUM_LB_PCQ                 = ( HQM_LSP_ARCH_NUM_LB_CQ >> 1 ) ;
parameter       HQM_LSP_ARCH_NUM_DIR_QID                = 128 ;
parameter       HQM_LSP_ARCH_NUM_DIR_CQ                 = 128 ;
parameter       HQM_LSP_NUM_LB_CQQIDIX                  = HQM_QID_PER_CQ * HQM_NUM_LB_CQ ;

parameter       HQM_LSP_LDB_TOKEN_RTN_FIFO_DEPTH        = 8 ;
parameter       HQM_LSP_LDB_TOKEN_RTN_FIFO_DWIDTH       = $bits ( lsp_ldb_token_rtn_t ) ;

parameter       HQM_LSP_UNO_ATM_CMP_FIFO_DEPTH          = 8 ;
parameter       HQM_LSP_UNO_ATM_CMP_FIFO_DWIDTH         = $bits ( lsp_uno_atm_cmp_t ) ;

parameter       HQM_LSP_NALB_CMP_FIFO_DEPTH             = 8 ;
parameter       HQM_LSP_NALB_CMP_FIFO_DWIDTH            = $bits ( lsp_nalb_cmp_t ) ;

parameter       HQM_LSP_ATM_CMP_FIFO_DEPTH              = 8 ;
parameter       HQM_LSP_ATM_CMP_FIFO_DWIDTH             = $bits ( lsp_atm_cmp_t ) ;

parameter       HQM_LSP_ROP_ORD_CMP_FIFO_DEPTH          = 8 ;
parameter       HQM_LSP_ROP_ORD_CMP_FIFO_DWIDTH         = $bits ( rop_lsp_reordercmp_t ) ;

parameter       HQM_LSP_ENQ_NALB_FIFO_DEPTH             = 4 ;
parameter       HQM_LSP_ENQ_NALB_FIFO_DWIDTH            = $bits ( nalb_lsp_enq_lb_t ) ;

parameter       HQM_LSP_NALB_SEL_NALB_FIFO_DEPTH        = 16 ;
parameter       HQM_LSP_NALB_SEL_NALB_FIFO_DWIDTH       = $bits ( lsp_nalb_sch_unoord_t ) ;

// collage-pragma translate_off

parameter       HQM_LSP_LDB_TOKEN_RTN_FIFO_AWIDTH       = AW_logb2 ( HQM_LSP_LDB_TOKEN_RTN_FIFO_DEPTH - 1 ) + 1 ;
parameter       HQM_LSP_LDB_TOKEN_RTN_FIFO_DEPTHWIDTH   = AW_logb2 ( HQM_LSP_LDB_TOKEN_RTN_FIFO_DEPTH ) + 1 ;
parameter       HQM_LSP_LDB_TOKEN_RTN_FIFO_WMWIDTH      = AW_logb2 ( HQM_LSP_LDB_TOKEN_RTN_FIFO_DEPTH + 1 ) + 1 ;
parameter       HQM_LSP_UNO_ATM_CMP_FIFO_AWIDTH         = AW_logb2 ( HQM_LSP_UNO_ATM_CMP_FIFO_DEPTH - 1 ) + 1 ;
parameter       HQM_LSP_UNO_ATM_CMP_FIFO_DEPTHWIDTH     = AW_logb2 ( HQM_LSP_UNO_ATM_CMP_FIFO_DEPTH ) + 1 ;
parameter       HQM_LSP_UNO_ATM_CMP_FIFO_WMWIDTH        = AW_logb2 ( HQM_LSP_UNO_ATM_CMP_FIFO_DEPTH + 1 ) + 1 ;
parameter       HQM_LSP_NALB_CMP_FIFO_AWIDTH            = AW_logb2 ( HQM_LSP_NALB_CMP_FIFO_DEPTH - 1 ) + 1 ;
parameter       HQM_LSP_NALB_CMP_FIFO_DEPTHWIDTH        = AW_logb2 ( HQM_LSP_NALB_CMP_FIFO_DEPTH ) + 1 ;
parameter       HQM_LSP_NALB_CMP_FIFO_WMWIDTH           = AW_logb2 ( HQM_LSP_NALB_CMP_FIFO_DEPTH + 1 ) + 1 ;
parameter       HQM_LSP_ATM_CMP_FIFO_AWIDTH             = AW_logb2 ( HQM_LSP_ATM_CMP_FIFO_DEPTH - 1 ) + 1 ;
parameter       HQM_LSP_ATM_CMP_FIFO_DEPTHWIDTH         = AW_logb2 ( HQM_LSP_ATM_CMP_FIFO_DEPTH ) + 1 ;
parameter       HQM_LSP_ATM_CMP_FIFO_WMWIDTH            = AW_logb2 ( HQM_LSP_ATM_CMP_FIFO_DEPTH + 1 ) + 1 ;
parameter       HQM_LSP_ROP_ORD_CMP_FIFO_AWIDTH         = AW_logb2 ( HQM_LSP_ROP_ORD_CMP_FIFO_DEPTH - 1 ) + 1 ;
parameter       HQM_LSP_ROP_ORD_CMP_FIFO_DEPTHWIDTH     = AW_logb2 ( HQM_LSP_ROP_ORD_CMP_FIFO_DEPTH ) + 1 ;
parameter       HQM_LSP_ROP_ORD_CMP_FIFO_WMWIDTH        = AW_logb2 ( HQM_LSP_ROP_ORD_CMP_FIFO_DEPTH + 1 ) + 1 ;
parameter       HQM_LSP_ENQ_NALB_FIFO_AWIDTH            = AW_logb2 ( HQM_LSP_ENQ_NALB_FIFO_DEPTH - 1 ) + 1 ;
parameter       HQM_LSP_ENQ_NALB_FIFO_DEPTHWIDTH        = AW_logb2 ( HQM_LSP_ENQ_NALB_FIFO_DEPTH ) + 1 ;
parameter       HQM_LSP_ENQ_NALB_FIFO_WMWIDTH           = AW_logb2 ( HQM_LSP_ENQ_NALB_FIFO_DEPTH + 1 ) + 1 ;
parameter       HQM_LSP_NALB_SEL_NALB_FIFO_AWIDTH       = AW_logb2 ( HQM_LSP_NALB_SEL_NALB_FIFO_DEPTH - 1 ) + 1 ;
parameter       HQM_LSP_NALB_SEL_NALB_FIFO_DEPTHWIDTH   = AW_logb2 ( HQM_LSP_NALB_SEL_NALB_FIFO_DEPTH ) + 1 ;
parameter       HQM_LSP_NALB_SEL_NALB_FIFO_WMWIDTH      = AW_logb2 ( HQM_LSP_NALB_SEL_NALB_FIFO_DEPTH + 1 ) + 1 ;
parameter       HQM_LSP_ARCH_NUM_FIDB2                  = AW_logb2 ( HQM_LSP_ARCH_NUM_FID -1 ) + 1 ;
parameter       HQM_LSP_ARCH_NUM_LB_QIDB2               = AW_logb2 ( HQM_LSP_ARCH_NUM_LB_QID - 1 ) + 1 ;
parameter       HQM_LSP_ARCH_NUM_LB_CQB2                = AW_logb2 ( HQM_LSP_ARCH_NUM_LB_CQ - 1 ) + 1 ;
parameter       HQM_LSP_ARCH_NUM_LB_PCQB2               = AW_logb2 ( HQM_LSP_ARCH_NUM_LB_PCQ - 1 ) + 1 ;
parameter       HQM_LSP_ARCH_NUM_DIR_QIDB2              = AW_logb2 ( HQM_LSP_ARCH_NUM_DIR_QID - 1 ) + 1 ;
parameter       HQM_LSP_ARCH_NUM_DIR_CQB2               = AW_logb2 ( HQM_LSP_ARCH_NUM_DIR_CQ - 1 ) + 1 ;
parameter       HQM_LSP_NUM_LB_CQQIDIXB2                = AW_logb2 ( HQM_LSP_NUM_LB_CQQIDIX -1 ) + 1 ;


// collage-pragma translate_on

// Random
parameter       HQM_LSP_LB_QID_CMP_INPUT_ARB_WEIGHT_REQ0        = 8'h7f ;
parameter       HQM_LSP_LB_QID_CMP_INPUT_ARB_WEIGHT_REQ1        = 8'hff ;
// Random
parameter       HQM_LSP_LB_CQ_CMP_INPUT_ARB_WEIGHT_REQ0         = 8'h7f ;
parameter       HQM_LSP_LB_CQ_CMP_INPUT_ARB_WEIGHT_REQ1         = 8'hff ;

// Strict
parameter       HQM_LSP_ATM_NALB_WEIGHT_REQ0            = 8'h00 ;
parameter       HQM_LSP_ATM_NALB_WEIGHT_REQ1            = 8'h00 ;
parameter       HQM_LSP_ATM_NALB_WEIGHT_REQ2            = 8'h00 ;
parameter       HQM_LSP_ATM_NALB_WEIGHT_REQ3            = 8'h00 ;
parameter       HQM_LSP_ATM_NALB_WEIGHT_REQ4            = 8'h00 ;
parameter       HQM_LSP_ATM_NALB_WEIGHT_REQ5            = 8'h00 ;
parameter       HQM_LSP_ATM_NALB_WEIGHT_REQ6            = 8'h00 ;
parameter       HQM_LSP_ATM_NALB_WEIGHT_REQ7            = 8'h00 ;

// Strict
parameter       HQM_LSP_LDB_WEIGHT_REQ0                 = 8'h00 ;
parameter       HQM_LSP_LDB_WEIGHT_REQ1                 = 8'h00 ;
parameter       HQM_LSP_LDB_WEIGHT_REQ2                 = 8'h00 ;
parameter       HQM_LSP_LDB_WEIGHT_REQ3                 = 8'h00 ;
parameter       HQM_LSP_LDB_WEIGHT_REQ4                 = 8'h00 ;
parameter       HQM_LSP_LDB_WEIGHT_REQ5                 = 8'h00 ;
parameter       HQM_LSP_LDB_WEIGHT_REQ6                 = 8'h00 ;
parameter       HQM_LSP_LDB_WEIGHT_REQ7                 = 8'h00 ;

// Random
parameter       HQM_LSP_DIRENQ_ARB_WEIGHT_REQ0          = 8'h7f ;
parameter       HQM_LSP_DIRENQ_ARB_WEIGHT_REQ1          = 8'hff ;

// Random
parameter       HQM_LSP_LBRPL_INPUT_ARB_WEIGHT_REQ0     = 8'h7f ;
parameter       HQM_LSP_LBRPL_INPUT_ARB_WEIGHT_REQ1     = 8'hff ;

// Random
parameter       HQM_LSP_DIRRPL_INPUT_ARB_WEIGHT_REQ0    = 8'h7f ;
parameter       HQM_LSP_DIRRPL_INPUT_ARB_WEIGHT_REQ1    = 8'hff ;

// Evenly distributed ranges for all 4 cos
parameter       HQM_LSP_CFG_RANGE_COS0_DEFAULT          = 9'h040 ;
parameter       HQM_LSP_CFG_RANGE_COS1_DEFAULT          = 9'h040 ;
parameter       HQM_LSP_CFG_RANGE_COS2_DEFAULT          = 9'h040 ;
parameter       HQM_LSP_CFG_RANGE_COS3_DEFAULT          = 9'h040 ;

parameter       HQM_LSP_CFG_CREDIT_SAT_COS0_DEFAULT     = 16'h0100 ;
parameter       HQM_LSP_CFG_CREDIT_SAT_COS1_DEFAULT     = 16'h0100 ;
parameter       HQM_LSP_CFG_CREDIT_SAT_COS2_DEFAULT     = 16'h0100 ;
parameter       HQM_LSP_CFG_CREDIT_SAT_COS3_DEFAULT     = 16'h0100 ;

parameter       HQM_LSP_CFG_CONTROL_GENERAL_0_DEFAULT           = 32'h00000000 ;
parameter       HQM_LSP_CFG_CONTROL_GENERAL_1_DEFAULT           = 32'h0000c0c0 ;        // aqed_lsp_deq hwm=12, qed_lsp_deq hqm=12
parameter       HQM_LSP_CFG_COS_CTRL_DEFAULT                    = 32'h00040001 ;        // enab=0, max=0x100, min=0x001
parameter       HQM_LSP_CFG_LDB_SCHED_CONTROL_DEFAULT           = 32'h00000000 ;
parameter       HQM_LSP_CFG_LSP_CSR_CONTROL_DEFAULT             = 32'h30000000 ;        // count_base=3
parameter       HQM_LSP_CFG_CONTROL_SCHED_SLOT_COUNT_DEFAULT    = 32'h00000000 ;        // [0] = enable, [1] = clear
parameter       HQM_LSP_CFG_LDB_SCHED_PERF_CONTROL_DEFAULT      = 32'h00000000 ;        // [0] = enable, [1] = clear
parameter       HQM_LSP_CFG_LSP_PERF_SCH_COUNT_CONTROL_DEFAULT  = 32'h00000001 ;        // [0] = enable, [1] = clear
parameter       HQM_LSP_CFG_SHDW_CTRL_DEFAULT                   = 32'h00000000 ;

parameter       HQM_LSP_NALB_PIPE_CREDITS               = 8'h08 ;               // p1 through p8
parameter       HQM_LSP_ATM_PIPE_CREDITS                = 8'h0c ;               // p1 through p4, plus 8 atm_pipe (includes 2 for internal DB in AP)
parameter       HQM_LSP_QED_DEQ_PIPE_CREDITS            = 8'h18 ;               // Depth of qed_deq FIFO
parameter       HQM_LSP_AQED_DEQ_PIPE_CREDITS           = 8'h18 ;               // Depth of aqed_deq FIFO

parameter       HQM_LSP_AQED_TOT_ENQ_LIMIT_DEFAULT              = 32'h00000800 ;
parameter       HQM_LSP_LDB_TOT_INFLIGHT_LIMIT_DEFAULT          = 32'h00000800 ;        // Must be <= history list size
parameter       HQM_LSP_ATQ_FID_INFLIGHT_LIMIT_DEFAULT          = 32'h00000800 ;        // Must be <= BCAM size


typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_DIRENQ_ENQ_CNT_WIDTH-1:0] cnt ;
} lsp_direnq_enq_cnt_t;

localparam BITS_LSP_DIRENQ_ENQ_CNT_T = $bits(lsp_direnq_enq_cnt_t);

typedef struct packed {
  logic  thrsh_p ;
  logic  [HQM_LSP_DIRENQ_DPTH_THRSH_WIDTH-1:0] thrsh ;
} lsp_direnq_dpth_thrsh_t;

localparam BITS_LSP_DIRENQ_DPTH_THRSH_T = $bits(lsp_direnq_dpth_thrsh_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_DIRENQ_TOK_CNT_WIDTH-1:0] cnt ;
} lsp_direnq_tok_cnt_t;

localparam BITS_LSP_DIRENQ_TOK_CNT_T = $bits(lsp_direnq_tok_cnt_t);

typedef struct packed {
  logic         lim_p ;
  logic  [1:0]  spare ;
  logic         disab_opt ;
  logic  [HQM_LSP_DIRENQ_TOK_LIM_SEL_WIDTH-1:0] lim_sel ;
} lsp_direnq_tok_lim_t;

localparam BITS_LSP_DIRENQ_TOK_LIM_T = $bits(lsp_direnq_tok_lim_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_LB_ATM_ENQ_CNT_WIDTH-1:0] cnt ;
} lsp_lb_atm_enq_cnt_t;

localparam BITS_LSP_LB_ATM_ENQ_CNT_T = $bits(lsp_lb_atm_enq_cnt_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_LB_QID_ENQ_CNT_WIDTH-1:0] cnt ;
} lsp_lb_qid_enq_cnt_t;

localparam BITS_LSP_LB_QID_ENQ_CNT_T = $bits(lsp_lb_qid_enq_cnt_t);

typedef struct packed {
  logic         thrsh_p ;   
  logic  [HQM_LSP_LB_QID_DPTH_THRSH_WIDTH-1:0] thrsh ;
} lsp_lb_qid_dpth_thrsh_t;

localparam BITS_LSP_LB_QID_DPTH_THRSH_T = $bits(lsp_lb_qid_dpth_thrsh_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_LB_QID_IF_CNT_WIDTH-1:0] cnt ;
} lsp_lb_qid_if_cnt_t;

localparam BITS_LSP_LB_QID_IF_CNT_T = $bits(lsp_lb_qid_if_cnt_t);

typedef struct packed {
  logic         lim_p ;   
  logic  [HQM_LSP_LB_QID_IF_LIM_WIDTH-1:0] lim ;
} lsp_lb_qid_if_lim_t;

localparam BITS_LSP_LB_QID_IF_LIM_T = $bits(lsp_lb_qid_if_lim_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_LB_CQ_TOK_CNT_WIDTH-1:0] cnt ;
} lsp_lb_cq_tok_cnt_t;

localparam BITS_LSP_LB_CQ_TOK_CNT_T = $bits(lsp_lb_cq_tok_cnt_t);

typedef struct packed {
  logic         lim_p ;
  logic  [HQM_LSP_LB_CQ_TOK_LIM_SEL_WIDTH-1:0] lim_sel ;
} lsp_lb_cq_tok_lim_t;

localparam BITS_LSP_LB_CQ_TOK_LIM_T = $bits(lsp_lb_cq_tok_lim_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_LB_CQ_IF_CNT_WIDTH-1:0] cnt ;
} lsp_lb_cq_if_cnt_t;

localparam BITS_LSP_LB_CQ_IF_CNT_T = $bits(lsp_lb_cq_if_cnt_t);

typedef struct packed {
  logic         lim_p ;   
  logic  [HQM_LSP_LB_CQ_IF_LIM_WIDTH-1:0] lim ;
} lsp_lb_cq_if_lim_t;

localparam BITS_LSP_LB_CQ_IF_LIM_T = $bits(lsp_lb_cq_if_lim_t);

typedef struct packed {
  logic         thr_p ;   
  logic  [HQM_LSP_LB_CQ_IF_THR_WIDTH-1:0] thr ;
} lsp_lb_cq_if_thr_t;

localparam BITS_LSP_LB_CQ_IF_THR_T = $bits(lsp_lb_cq_if_thr_t);

typedef struct packed {
  logic         p ;   
  logic [7:0]   v_8 ;           // Valid bits for each of the 8 indices
  logic [23:0]  pri_8 ;         // 3-bit priority for each of the 8 indices
} lsp_cfg_cq2priov_t;

localparam BITS_LSP_CFG_CQ2PRIOV_T = $bits(lsp_cfg_cq2priov_t);

typedef struct packed {
  logic         p ;   
  logic [27:0]  qid_4 ;         // 7-bit qid for 4 of the indices
} lsp_cfg_cq2qid_t;

localparam BITS_LSP_CFG_CQ2QID_T = $bits(lsp_cfg_cq2qid_t);

typedef struct packed {
  logic [15:0]  parity ;
  logic [511:0] qidixv ;        // 8-bit valid vector for 64 CQs
} lsp_cfg_qid2cqidix_t;

localparam BITS_LSP_CFG_QID2CQIDIX_T = $bits(lsp_cfg_qid2cqidix_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_ATQ_ENQ_CNT_WIDTH-1:0] cnt ;
} lsp_atq_enq_cnt_t;

localparam BITS_LSP_ATQ_ENQ_CNT_T = $bits(lsp_atq_enq_cnt_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_ATQ_ATM_ACTIVE_WIDTH-1:0] cnt ;
} lsp_atq_atm_active_t;

localparam BITS_LSP_ATQ_ATM_ACTIVE_T = $bits(lsp_atq_atm_active_t);

typedef struct packed {
  logic         thrsh_p ;   
  logic  [HQM_LSP_ATQ_QID_DPTH_THRSH_WIDTH-1:0] thrsh ;
} lsp_atq_qid_dpth_thrsh_t;

localparam BITS_LSP_ATQ_QID_DPTH_THRSH_T = $bits(lsp_atq_qid_dpth_thrsh_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_ATQ_AQED_ACT_CNT_WIDTH-1:0] cnt ;
} lsp_atq_aqed_act_cnt_t;

localparam BITS_LSP_ATQ_AQED_ACT_CNT_T = $bits(lsp_atq_aqed_act_cnt_t);

typedef struct packed {
  logic         lim_p ;
  logic  [HQM_LSP_ATQ_AQED_ACT_LIM_WIDTH-1:0] lim ;
} lsp_atq_aqed_act_lim_t;

localparam BITS_LSP_ATQ_AQED_ACT_LIM_T = $bits(lsp_atq_aqed_act_lim_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_ATQ_FID_IF_CNT_WIDTH-1:0] cnt ;
} lsp_atq_fid_if_cnt_t;

localparam BITS_LSP_ATQ_FID_IF_CNT_T = $bits(lsp_atq_fid_if_cnt_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_DIRRPL_ENQ_CNT_WIDTH-1:0] cnt ;
} lsp_dirrpl_enq_cnt_t;

localparam BITS_LSP_DIRRPL_ENQ_CNT_T = $bits(lsp_dirrpl_enq_cnt_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_LBRPL_ENQ_CNT_WIDTH-1:0] cnt ;
} lsp_lbrpl_enq_cnt_t;

localparam BITS_LSP_LBRPL_ENQ_CNT_T = $bits(lsp_lbrpl_enq_cnt_t);

typedef struct packed {
  logic  [1:0]  cnt_res ;
  logic  [HQM_LSP_ARCH_CNT_WIDTH-1:0] cnt ;
} lsp_arch_cnt_t;

localparam BITS_LSP_ARCH_CNT_T = $bits(lsp_arch_cnt_t);

//-----------------------------------------------------------------------------------------------------
// DQED params
parameter HQM_DQED_IN_ODD_ARB_WEIGHT_REQ1 = 8'hff ; //DEQUEUE - dqed_chp_sch
parameter HQM_DQED_IN_ODD_ARB_WEIGHT_REQ0 = 8'h7f ; //ENQUEUE - rop_qed_dqed_enq
parameter HQM_DQED_IN_EVEN_ARB_WEIGHT_REQ1 = 8'hff ; //DEQUEUE - dqed_chp_sch
parameter HQM_DQED_IN_EVEN_ARB_WEIGHT_REQ0 = 8'h7f ; //ENQUEUE - rop_qed_dqed_enq

parameter HQM_DQED_HPNXT_ARB_WEIGHT_REQ1 = 8'hff ; //ODD pipe
parameter HQM_DQED_HPNXT_ARB_WEIGHT_REQ0 = 8'h7f ; //EVEN pipe

//-----------------------------------------------------------------------------------------------------
// QED params
parameter HQM_QED_IN_ODD_ARB_WEIGHT_REQ1 = 8'hff ; //DEQUEUE - dqed_chp_sch 
parameter HQM_QED_IN_ODD_ARB_WEIGHT_REQ0 = 8'h7f ; //ENQUEUE - rop_qed_dqed_enq
parameter HQM_QED_IN_EVEN_ARB_WEIGHT_REQ1 = 8'hff ; //DEQUEUE - dqed_chp_sch
parameter HQM_QED_IN_EVEN_ARB_WEIGHT_REQ0 = 8'h7f ; //ENQUEUE - rop_qed_dqed_enq

parameter HQM_QED_HPNXT_ARB_WEIGHT_REQ1 = 8'hff ; //ODD pipe
parameter HQM_QED_HPNXT_ARB_WEIGHT_REQ0 = 8'h7f ; //EVEN pipe

//-----------------------------------------------------------------------------------------------------
// AQED params
parameter HQM_AQED_IN_ARB_WEIGHT_REQ1 = 8'hff ; //DEQUEUE - ap_aqed
parameter HQM_AQED_IN_ARB_WEIGHT_REQ0 = 8'h7f ; //ENQUEUE - qed_aqed_enq

parameter HQM_AQED_TQPRI_ARB_WEIGHT_REQ7 = 8'h00 ; //TQPRI selection
parameter HQM_AQED_TQPRI_ARB_WEIGHT_REQ6 = 8'h00 ; //TQPRI selection
parameter HQM_AQED_TQPRI_ARB_WEIGHT_REQ5 = 8'h00 ; //TQPRI selection
parameter HQM_AQED_TQPRI_ARB_WEIGHT_REQ4 = 8'h00 ; //TQPRI selection
parameter HQM_AQED_TQPRI_ARB_WEIGHT_REQ3 = 8'hfe ; //TQPRI selection
parameter HQM_AQED_TQPRI_ARB_WEIGHT_REQ2 = 8'hfc ; //TQPRI selection
parameter HQM_AQED_TQPRI_ARB_WEIGHT_REQ1 = 8'hfa ; //TQPRI selection
parameter HQM_AQED_TQPRI_ARB_WEIGHT_REQ0 = 8'hf8 ; //TQPRI selection

//-----------------------------------------------------------------------------------------------------
// DP params
parameter HQM_DP_IN_DIR_ARB_WEIGHT_REQ1 = 8'hff ; //DEQUEUE - lsp_dp_sch_dir
parameter HQM_DP_IN_DIR_ARB_WEIGHT_REQ0 = 8'h7f ; //ENQUEUE - rop_dp_enq

parameter HQM_DP_IN_RO_ARB_WEIGHT_REQ2 = 8'hff ; //DEQUEUE replay - lsp_dp_sch_rorply
parameter HQM_DP_IN_RO_ARB_WEIGHT_REQ1 = 8'haa ; //ENQUEUE replay - rop_dp_enq_rorply
parameter HQM_DP_IN_RO_ARB_WEIGHT_REQ0 = 8'h55 ; //ENQUEUE rofrag - rop_dp_enq_ro

parameter HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ7 = 8'h00 ; //TQPRI selection
parameter HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ6 = 8'h00 ; //TQPRI selection
parameter HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ5 = 8'h00 ; //TQPRI selection
parameter HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ4 = 8'h00 ; //TQPRI selection
parameter HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ3 = 8'hfe ; //TQPRI selection
parameter HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ2 = 8'hfc ; //TQPRI selection
parameter HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ1 = 8'hfa ; //TQPRI selection
parameter HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ0 = 8'hf8 ; //TQPRI selection

parameter HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ7 = 8'h00 ; //TQPRI selection
parameter HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ6 = 8'h00 ; //TQPRI selection
parameter HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ5 = 8'h00 ; //TQPRI selection
parameter HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ4 = 8'h00 ; //TQPRI selection
parameter HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ3 = 8'hfe ; //TQPRI selection
parameter HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ2 = 8'hfc ; //TQPRI selection
parameter HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ1 = 8'hfa ; //TQPRI selection
parameter HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ0 = 8'hf8 ; //TQPRI selection

//-----------------------------------------------------------------------------------------------------
// NALB params

parameter HQM_NALB_IN_NALB_ARB_WEIGHT_REQ1 = 8'hff ; //DEQUEUE - lsp_nalb_sch
parameter HQM_NALB_IN_NALB_ARB_WEIGHT_REQ0 = 8'h7f ; //ENQUEUE - rop_nalb_enq_nalb

parameter HQM_NALB_IN_ATQ_ARB_WEIGHT_REQ1 = 8'hff ; //DEQUEUE - lsp_nalb_sch_atq
parameter HQM_NALB_IN_ATQ_ARB_WEIGHT_REQ0 = 8'h7f ; //ENQUEUE - rop_nalb_enq_nalb

parameter HQM_NALB_IN_RO_ARB_WEIGHT_REQ2 = 8'hff ; //DEQUEUE replay - lsp_nalb_sch_rorply
parameter HQM_NALB_IN_RO_ARB_WEIGHT_REQ1 = 8'haa ; //ENQUEUE replay - rop_nalb_enq_rorply
parameter HQM_NALB_IN_RO_ARB_WEIGHT_REQ0 = 8'h55 ; //ENQUEUE rofrag - rop_nalb_enq_ro

parameter HQM_NALB_NALB_TQPRI_ARB_WEIGHT_REQ7 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_NALB_TQPRI_ARB_WEIGHT_REQ6 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_NALB_TQPRI_ARB_WEIGHT_REQ5 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_NALB_TQPRI_ARB_WEIGHT_REQ4 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_NALB_TQPRI_ARB_WEIGHT_REQ3 = 8'hfe ; //TQPRI selection
parameter HQM_NALB_NALB_TQPRI_ARB_WEIGHT_REQ2 = 8'hfc ; //TQPRI selection
parameter HQM_NALB_NALB_TQPRI_ARB_WEIGHT_REQ1 = 8'hfa ; //TQPRI selection
parameter HQM_NALB_NALB_TQPRI_ARB_WEIGHT_REQ0 = 8'hf8 ; //TQPRI selection

parameter HQM_NALB_ATQ_TQPRI_ARB_WEIGHT_REQ7 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_ATQ_TQPRI_ARB_WEIGHT_REQ6 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_ATQ_TQPRI_ARB_WEIGHT_REQ5 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_ATQ_TQPRI_ARB_WEIGHT_REQ4 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_ATQ_TQPRI_ARB_WEIGHT_REQ3 = 8'hfe ; //TQPRI selection
parameter HQM_NALB_ATQ_TQPRI_ARB_WEIGHT_REQ2 = 8'hfc ; //TQPRI selection
parameter HQM_NALB_ATQ_TQPRI_ARB_WEIGHT_REQ1 = 8'hfa ; //TQPRI selection
parameter HQM_NALB_ATQ_TQPRI_ARB_WEIGHT_REQ0 = 8'hf8 ; //TQPRI selection

parameter HQM_NALB_REPLAY_TQPRI_ARB_WEIGHT_REQ7 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_REPLAY_TQPRI_ARB_WEIGHT_REQ6 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_REPLAY_TQPRI_ARB_WEIGHT_REQ5 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_REPLAY_TQPRI_ARB_WEIGHT_REQ4 = 8'h00 ; //TQPRI selection
parameter HQM_NALB_REPLAY_TQPRI_ARB_WEIGHT_REQ3 = 8'hfe ; //TQPRI selection
parameter HQM_NALB_REPLAY_TQPRI_ARB_WEIGHT_REQ2 = 8'hfc ; //TQPRI selection
parameter HQM_NALB_REPLAY_TQPRI_ARB_WEIGHT_REQ1 = 8'hfa ; //TQPRI selection
parameter HQM_NALB_REPLAY_TQPRI_ARB_WEIGHT_REQ0 = 8'hf8 ; //TQPRI selection


//-----------------------------------------------------------------------------------------------------
// AP params
parameter HQM_AP_IN_ARB_WEIGHT_REQ2 = 8'hff ; //COMPLETE - chp_ap_cmp
parameter HQM_AP_IN_ARB_WEIGHT_REQ1 = 8'haa ; //SCHEDULE - lsp_ap_sch_atm
parameter HQM_AP_IN_ARB_WEIGHT_REQ0 = 8'h55 ; //ENQUEUE - aqed_ap_enq

parameter HQM_AP_READY_TQPRI_ARB_WEIGHT_REQ3 = 8'hff ; //TQPRI selection
parameter HQM_AP_READY_TQPRI_ARB_WEIGHT_REQ2 = 8'hfe ; //TQPRI selection
parameter HQM_AP_READY_TQPRI_ARB_WEIGHT_REQ1 = 8'hfd ; //TQPRI selection
parameter HQM_AP_READY_TQPRI_ARB_WEIGHT_REQ0 = 8'hfc ; //TQPRI selection

parameter HQM_AP_SCHED_TQPRI_ARB_WEIGHT_REQ3 = 8'hff ; //TQPRI selection
parameter HQM_AP_SCHED_TQPRI_ARB_WEIGHT_REQ2 = 8'hfe ; //TQPRI selection
parameter HQM_AP_SCHED_TQPRI_ARB_WEIGHT_REQ1 = 8'hfd ; //TQPRI selection
parameter HQM_AP_SCHED_TQPRI_ARB_WEIGHT_REQ0 = 8'hfc ; //TQPRI selection







//-----------------------------------------------------------------------------------------------------
// Alarm Params
parameter HQM_CHP_ALARM_NUM_UNC                = 1 ;
parameter HQM_CHP_ALARM_NUM_COR                = 1 ;
parameter HQM_CHP_ALARM_NUM_INF                = 9 ;

parameter HQM_ROP_ALARM_NUM_UNC                = 1 ;
parameter HQM_ROP_ALARM_NUM_COR                = 1 ; 
parameter HQM_ROP_ALARM_NUM_INF                = 1 ;

parameter HQM_LSP_ALARM_NUM_UNC                = 1 ;
parameter HQM_LSP_ALARM_NUM_COR                = 1 ;
parameter HQM_LSP_ALARM_NUM_INF                = 16;

parameter HQM_NALB_ALARM_NUM_UNC               = 1 ;
parameter HQM_NALB_ALARM_NUM_COR               = 1 ;
parameter HQM_NALB_ALARM_NUM_INF               = 1 ;

parameter HQM_DP_ALARM_NUM_UNC                 = 1 ;
parameter HQM_DP_ALARM_NUM_COR                 = 1 ;
parameter HQM_DP_ALARM_NUM_INF                 = 1 ;

parameter HQM_AP_ALARM_NUM_UNC                 = 1 ;
parameter HQM_AP_ALARM_NUM_COR                 = 1 ;
parameter HQM_AP_ALARM_NUM_INF                 = 1 ;

parameter HQM_QED_ALARM_NUM_UNC                = 1 ;
parameter HQM_QED_ALARM_NUM_COR                = 1 ;
parameter HQM_QED_ALARM_NUM_INF                = 1 ;

parameter HQM_DQED_ALARM_NUM_UNC               = 1 ;
parameter HQM_DQED_ALARM_NUM_COR               = 1 ;
parameter HQM_DQED_ALARM_NUM_INF               = 1 ;

parameter HQM_AQED_ALARM_NUM_UNC               = 1 ;
parameter HQM_AQED_ALARM_NUM_COR               = 1 ;
parameter HQM_AQED_ALARM_NUM_INF               = 1 ;

parameter HQM_SYS_ALARM_NUM_UNC                = 1 ;
parameter HQM_SYS_ALARM_NUM_COR                = 1 ;
parameter HQM_SYS_ALARM_NUM_INF                = 12 ;

parameter HQM_MSTR_ALARM_NUM_UNC                = 1 ;
parameter HQM_MSTR_ALARM_NUM_COR                = 1 ;
parameter HQM_MSTR_ALARM_NUM_INF                = 8 ;

parameter HQM_CHP_ALARM_00_RSVD                      = 0 ;
parameter HQM_CHP_ALARM_01_RSVD                      = 1 ;
parameter HQM_CHP_ALARM_02_RSVD                      = 2 ;
parameter HQM_CHP_ALARM_03_RSVD                      = 3 ;
parameter HQM_CHP_ALARM_04_RSVD                      = 4 ;
parameter HQM_CHP_ALARM_05_RSVD                      = 5 ;
parameter HQM_CHP_ALARM_06_RSVD                      = 6 ;
parameter HQM_CHP_ALARM_07_RSVD                      = 7 ;
parameter HQM_CHP_ALARM_08_RSVD                      = 8 ;
parameter HQM_CHP_ALARM_09_RSVD                      = 9 ;
parameter HQM_CHP_ALARM_10_RSVD                      = 10 ;
parameter HQM_CHP_ALARM_11_RSVD                      = 11 ;
parameter HQM_CHP_ALARM_12_RSVD                      = 12 ;
parameter HQM_CHP_ALARM_13_RSVD                      = 13 ;
parameter HQM_CHP_ALARM_14_RSVD                      = 14 ;
parameter HQM_CHP_ALARM_15_RSVD                      = 15 ;
parameter HQM_CHP_ALARM_16_RSVD                      = 16 ;
parameter HQM_CHP_ALARM_17_RSVD                      = 17 ;
parameter HQM_CHP_ALARM_18_RSVD                      = 18 ;
parameter HQM_CHP_ALARM_19_RSVD                      = 19 ;
parameter HQM_CHP_ALARM_20_RSVD                      = 20 ;
parameter HQM_CHP_ALARM_21_RSVD                      = 21 ;
parameter HQM_CHP_ALARM_22_RSVD                      = 22 ;
parameter HQM_CHP_ALARM_23_RSVD                      = 23 ;
parameter HQM_CHP_ALARM_24_RSVD                      = 24 ;
parameter HQM_CHP_ALARM_25_RSVD                      = 25 ;
parameter HQM_CHP_ALARM_26_RSVD                      = 26 ;
parameter HQM_CHP_ALARM_27_RSVD                      = 27 ;
parameter HQM_CHP_ALARM_28_RSVD                      = 28 ;
parameter HQM_CHP_ALARM_29_RSVD                      = 29 ;
parameter HQM_CHP_ALARM_30_RSVD                      = 30 ;
parameter HQM_CHP_ALARM_31_RSVD                      = 31 ;
parameter HQM_CHP_ALARM_32_RSVD                      = 32 ;
parameter HQM_CHP_ALARM_33_RSVD                      = 33 ;
parameter HQM_CHP_ALARM_34_RSVD                      = 34 ;
parameter HQM_CHP_ALARM_35_RSVD                      = 35 ;
parameter HQM_CHP_ALARM_36_RSVD                      = 36 ;
parameter HQM_CHP_ALARM_37_RSVD                      = 37 ;
parameter HQM_CHP_ALARM_38_RSVD                      = 38 ;
parameter HQM_CHP_ALARM_39_RSVD                      = 39 ;
parameter HQM_CHP_ALARM_40_RSVD                      = 40 ;
parameter HQM_CHP_ALARM_41_RSVD                      = 41 ;
parameter HQM_CHP_ALARM_42_RSVD                      = 42 ;
parameter HQM_CHP_ALARM_43_RSVD                      = 43 ;
parameter HQM_CHP_ALARM_44_RSVD                      = 44 ;
parameter HQM_CHP_ALARM_45_RSVD                      = 45 ;
parameter HQM_CHP_ALARM_46_RSVD                      = 46 ;
parameter HQM_CHP_ALARM_47_RSVD                      = 47 ;
parameter HQM_CHP_ALARM_48_RSVD                      = 48 ;
parameter HQM_CHP_ALARM_49_RSVD                      = 49 ;
parameter HQM_CHP_ALARM_50_RSVD                      = 50 ;
parameter HQM_CHP_ALARM_51_RSVD                      = 51 ;
parameter HQM_CHP_ALARM_52_RSVD                      = 52 ;
parameter HQM_CHP_ALARM_53_RSVD                      = 53 ;
parameter HQM_CHP_ALARM_54_RSVD                      = 54 ;
parameter HQM_CHP_ALARM_55_RSVD                      = 55 ;
parameter HQM_CHP_ALARM_56_RSVD                      = 56 ;
parameter HQM_CHP_ALARM_57_RSVD                      = 57 ;
parameter HQM_CHP_ALARM_58_RSVD                      = 58 ;
parameter HQM_CHP_ALARM_59_RSVD                      = 59 ;
parameter HQM_CHP_ALARM_60_RSVD                      = 60 ;
parameter HQM_CHP_ALARM_61_RSVD                      = 61 ;
parameter HQM_CHP_ALARM_62_RSVD                      = 62 ;
parameter HQM_CHP_ALARM_63_RSVD                      = 63 ;

parameter HQM_LSP_ALARM_00_RSVD                      = 0 ;
parameter HQM_LSP_ALARM_01_RSVD                      = 1 ;
parameter HQM_LSP_ALARM_02_RSVD                      = 2 ;
parameter HQM_LSP_ALARM_03_RSVD                      = 3 ;
parameter HQM_LSP_ALARM_04_RSVD                      = 4 ;
parameter HQM_LSP_ALARM_05_RSVD                      = 5 ;
parameter HQM_LSP_ALARM_06_RSVD                      = 6 ;
parameter HQM_LSP_ALARM_07_RSVD                      = 7 ;
parameter HQM_LSP_ALARM_08_RSVD                      = 8 ;
parameter HQM_LSP_ALARM_09_RSVD                      = 9 ;
parameter HQM_LSP_ALARM_10_RSVD                      = 10 ;
parameter HQM_LSP_ALARM_11_RSVD                      = 11 ;
parameter HQM_LSP_ALARM_12_RSVD                      = 12 ;
parameter HQM_LSP_ALARM_13_RSVD                      = 13 ;
parameter HQM_LSP_ALARM_14_RSVD                      = 14 ;
parameter HQM_LSP_ALARM_15_RSVD                      = 15 ;
parameter HQM_LSP_ALARM_16_RSVD                      = 16 ;
parameter HQM_LSP_ALARM_17_RSVD                      = 17 ;
parameter HQM_LSP_ALARM_18_RSVD                      = 18 ;
parameter HQM_LSP_ALARM_19_RSVD                      = 19 ;
parameter HQM_LSP_ALARM_20_RSVD                      = 20 ;
parameter HQM_LSP_ALARM_21_RSVD                      = 21 ;
parameter HQM_LSP_ALARM_22_RSVD                      = 22 ;
parameter HQM_LSP_ALARM_23_RSVD                      = 23 ;
parameter HQM_LSP_ALARM_24_RSVD                      = 24 ;
parameter HQM_LSP_ALARM_25_RSVD                      = 25 ;
parameter HQM_LSP_ALARM_26_RSVD                      = 26 ;
parameter HQM_LSP_ALARM_27_RSVD                      = 27 ;
parameter HQM_LSP_ALARM_28_RSVD                      = 28 ;
parameter HQM_LSP_ALARM_29_RSVD                      = 29 ;
parameter HQM_LSP_ALARM_30_RSVD                      = 30 ;
parameter HQM_LSP_ALARM_31_RSVD                      = 31 ;
parameter HQM_LSP_ALARM_32_RSVD                      = 32 ;
parameter HQM_LSP_ALARM_33_RSVD                      = 33 ;
parameter HQM_LSP_ALARM_34_RSVD                      = 34 ;
parameter HQM_LSP_ALARM_35_RSVD                      = 35 ;
parameter HQM_LSP_ALARM_36_RSVD                      = 36 ;
parameter HQM_LSP_ALARM_37_RSVD                      = 37 ;
parameter HQM_LSP_ALARM_38_RSVD                      = 38 ;
parameter HQM_LSP_ALARM_39_RSVD                      = 39 ;
parameter HQM_LSP_ALARM_40_RSVD                      = 40 ;
parameter HQM_LSP_ALARM_41_RSVD                      = 41 ;
parameter HQM_LSP_ALARM_42_RSVD                      = 42 ;
parameter HQM_LSP_ALARM_43_RSVD                      = 43 ;
parameter HQM_LSP_ALARM_44_RSVD                      = 44 ;
parameter HQM_LSP_ALARM_45_RSVD                      = 45 ;
parameter HQM_LSP_ALARM_46_RSVD                      = 46 ;
parameter HQM_LSP_ALARM_47_RSVD                      = 47 ;
parameter HQM_LSP_ALARM_48_RSVD                      = 48 ;
parameter HQM_LSP_ALARM_49_RSVD                      = 49 ;
parameter HQM_LSP_ALARM_50_RSVD                      = 50 ;
parameter HQM_LSP_ALARM_51_RSVD                      = 51 ;
parameter HQM_LSP_ALARM_52_RSVD                      = 52 ;
parameter HQM_LSP_ALARM_53_RSVD                      = 53 ;
parameter HQM_LSP_ALARM_54_RSVD                      = 54 ;
parameter HQM_LSP_ALARM_55_RSVD                      = 55 ;
parameter HQM_LSP_ALARM_56_RSVD                      = 56 ;
parameter HQM_LSP_ALARM_57_RSVD                      = 57 ;
parameter HQM_LSP_ALARM_58_RSVD                      = 58 ;
parameter HQM_LSP_ALARM_59_RSVD                      = 59 ;
parameter HQM_LSP_ALARM_60_RSVD                      = 60 ;
parameter HQM_LSP_ALARM_61_RSVD                      = 61 ;
parameter HQM_LSP_ALARM_62_RSVD                      = 62 ;
parameter HQM_LSP_ALARM_63_RSVD                      = 63 ;

parameter HQM_NALB_ALARM_00_RSVD                      = 0 ;
parameter HQM_NALB_ALARM_01_RSVD                      = 1 ;
parameter HQM_NALB_ALARM_02_RSVD                      = 2 ;
parameter HQM_NALB_ALARM_03_RSVD                      = 3 ;
parameter HQM_NALB_ALARM_04_RSVD                      = 4 ;
parameter HQM_NALB_ALARM_05_RSVD                      = 5 ;
parameter HQM_NALB_ALARM_06_RSVD                      = 6 ;
parameter HQM_NALB_ALARM_07_RSVD                      = 7 ;
parameter HQM_NALB_ALARM_08_RSVD                      = 8 ;
parameter HQM_NALB_ALARM_09_RSVD                      = 9 ;
parameter HQM_NALB_ALARM_10_RSVD                      = 10 ;
parameter HQM_NALB_ALARM_11_RSVD                      = 11 ;
parameter HQM_NALB_ALARM_12_RSVD                      = 12 ;
parameter HQM_NALB_ALARM_13_RSVD                      = 13 ;
parameter HQM_NALB_ALARM_14_RSVD                      = 14 ;
parameter HQM_NALB_ALARM_15_RSVD                      = 15 ;
parameter HQM_NALB_ALARM_16_RSVD                      = 16 ;
parameter HQM_NALB_ALARM_17_RSVD                      = 17 ;
parameter HQM_NALB_ALARM_18_RSVD                      = 18 ;
parameter HQM_NALB_ALARM_19_RSVD                      = 19 ;
parameter HQM_NALB_ALARM_20_RSVD                      = 20 ;
parameter HQM_NALB_ALARM_21_RSVD                      = 21 ;
parameter HQM_NALB_ALARM_22_RSVD                      = 22 ;
parameter HQM_NALB_ALARM_23_RSVD                      = 23 ;
parameter HQM_NALB_ALARM_24_RSVD                      = 24 ;
parameter HQM_NALB_ALARM_25_RSVD                      = 25 ;
parameter HQM_NALB_ALARM_26_RSVD                      = 26 ;
parameter HQM_NALB_ALARM_27_RSVD                      = 27 ;
parameter HQM_NALB_ALARM_28_RSVD                      = 28 ;
parameter HQM_NALB_ALARM_29_RSVD                      = 29 ;
parameter HQM_NALB_ALARM_30_RSVD                      = 30 ;
parameter HQM_NALB_ALARM_31_RSVD                      = 31 ;
parameter HQM_NALB_ALARM_32_RSVD                      = 32 ;
parameter HQM_NALB_ALARM_33_RSVD                      = 33 ;
parameter HQM_NALB_ALARM_34_RSVD                      = 34 ;
parameter HQM_NALB_ALARM_35_RSVD                      = 35 ;
parameter HQM_NALB_ALARM_36_RSVD                      = 36 ;
parameter HQM_NALB_ALARM_37_RSVD                      = 37 ;
parameter HQM_NALB_ALARM_38_RSVD                      = 38 ;
parameter HQM_NALB_ALARM_39_RSVD                      = 39 ;
parameter HQM_NALB_ALARM_40_RSVD                      = 40 ;
parameter HQM_NALB_ALARM_41_RSVD                      = 41 ;
parameter HQM_NALB_ALARM_42_RSVD                      = 42 ;
parameter HQM_NALB_ALARM_43_RSVD                      = 43 ;
parameter HQM_NALB_ALARM_44_RSVD                      = 44 ;
parameter HQM_NALB_ALARM_45_RSVD                      = 45 ;
parameter HQM_NALB_ALARM_46_RSVD                      = 46 ;
parameter HQM_NALB_ALARM_47_RSVD                      = 47 ;
parameter HQM_NALB_ALARM_48_RSVD                      = 48 ;
parameter HQM_NALB_ALARM_49_RSVD                      = 49 ;
parameter HQM_NALB_ALARM_50_RSVD                      = 50 ;
parameter HQM_NALB_ALARM_51_RSVD                      = 51 ;
parameter HQM_NALB_ALARM_52_RSVD                      = 52 ;
parameter HQM_NALB_ALARM_53_RSVD                      = 53 ;
parameter HQM_NALB_ALARM_54_RSVD                      = 54 ;
parameter HQM_NALB_ALARM_55_RSVD                      = 55 ;
parameter HQM_NALB_ALARM_56_RSVD                      = 56 ;
parameter HQM_NALB_ALARM_57_RSVD                      = 57 ;
parameter HQM_NALB_ALARM_58_RSVD                      = 58 ;
parameter HQM_NALB_ALARM_59_RSVD                      = 59 ;
parameter HQM_NALB_ALARM_60_RSVD                      = 60 ;
parameter HQM_NALB_ALARM_61_RSVD                      = 61 ;
parameter HQM_NALB_ALARM_62_RSVD                      = 62 ;
parameter HQM_NALB_ALARM_63_RSVD                      = 63 ;

parameter HQM_DP_ALARM_00_RSVD                      = 0 ;
parameter HQM_DP_ALARM_01_RSVD                      = 1 ;
parameter HQM_DP_ALARM_02_RSVD                      = 2 ;
parameter HQM_DP_ALARM_03_RSVD                      = 3 ;
parameter HQM_DP_ALARM_04_RSVD                      = 4 ;
parameter HQM_DP_ALARM_05_RSVD                      = 5 ;
parameter HQM_DP_ALARM_06_RSVD                      = 6 ;
parameter HQM_DP_ALARM_07_RSVD                      = 7 ;
parameter HQM_DP_ALARM_08_RSVD                      = 8 ;
parameter HQM_DP_ALARM_09_RSVD                      = 9 ;
parameter HQM_DP_ALARM_10_RSVD                      = 10 ;
parameter HQM_DP_ALARM_11_RSVD                      = 11 ;
parameter HQM_DP_ALARM_12_RSVD                      = 12 ;
parameter HQM_DP_ALARM_13_RSVD                      = 13 ;
parameter HQM_DP_ALARM_14_RSVD                      = 14 ;
parameter HQM_DP_ALARM_15_RSVD                      = 15 ;
parameter HQM_DP_ALARM_16_RSVD                      = 16 ;
parameter HQM_DP_ALARM_17_RSVD                      = 17 ;
parameter HQM_DP_ALARM_18_RSVD                      = 18 ;
parameter HQM_DP_ALARM_19_RSVD                      = 19 ;
parameter HQM_DP_ALARM_20_RSVD                      = 20 ;
parameter HQM_DP_ALARM_21_RSVD                      = 21 ;
parameter HQM_DP_ALARM_22_RSVD                      = 22 ;
parameter HQM_DP_ALARM_23_RSVD                      = 23 ;
parameter HQM_DP_ALARM_24_RSVD                      = 24 ;
parameter HQM_DP_ALARM_25_RSVD                      = 25 ;
parameter HQM_DP_ALARM_26_RSVD                      = 26 ;
parameter HQM_DP_ALARM_27_RSVD                      = 27 ;
parameter HQM_DP_ALARM_28_RSVD                      = 28 ;
parameter HQM_DP_ALARM_29_RSVD                      = 29 ;
parameter HQM_DP_ALARM_30_RSVD                      = 30 ;
parameter HQM_DP_ALARM_31_RSVD                      = 31 ;
parameter HQM_DP_ALARM_32_RSVD                      = 32 ;
parameter HQM_DP_ALARM_33_RSVD                      = 33 ;
parameter HQM_DP_ALARM_34_RSVD                      = 34 ;
parameter HQM_DP_ALARM_35_RSVD                      = 35 ;
parameter HQM_DP_ALARM_36_RSVD                      = 36 ;
parameter HQM_DP_ALARM_37_RSVD                      = 37 ;
parameter HQM_DP_ALARM_38_RSVD                      = 38 ;
parameter HQM_DP_ALARM_39_RSVD                      = 39 ;
parameter HQM_DP_ALARM_40_RSVD                      = 40 ;
parameter HQM_DP_ALARM_41_RSVD                      = 41 ;
parameter HQM_DP_ALARM_42_RSVD                      = 42 ;
parameter HQM_DP_ALARM_43_RSVD                      = 43 ;
parameter HQM_DP_ALARM_44_RSVD                      = 44 ;
parameter HQM_DP_ALARM_45_RSVD                      = 45 ;
parameter HQM_DP_ALARM_46_RSVD                      = 46 ;
parameter HQM_DP_ALARM_47_RSVD                      = 47 ;
parameter HQM_DP_ALARM_48_RSVD                      = 48 ;
parameter HQM_DP_ALARM_49_RSVD                      = 49 ;
parameter HQM_DP_ALARM_50_RSVD                      = 50 ;
parameter HQM_DP_ALARM_51_RSVD                      = 51 ;
parameter HQM_DP_ALARM_52_RSVD                      = 52 ;
parameter HQM_DP_ALARM_53_RSVD                      = 53 ;
parameter HQM_DP_ALARM_54_RSVD                      = 54 ;
parameter HQM_DP_ALARM_55_RSVD                      = 55 ;
parameter HQM_DP_ALARM_56_RSVD                      = 56 ;
parameter HQM_DP_ALARM_57_RSVD                      = 57 ;
parameter HQM_DP_ALARM_58_RSVD                      = 58 ;
parameter HQM_DP_ALARM_59_RSVD                      = 59 ;
parameter HQM_DP_ALARM_60_RSVD                      = 60 ;
parameter HQM_DP_ALARM_61_RSVD                      = 61 ;
parameter HQM_DP_ALARM_62_RSVD                      = 62 ;
parameter HQM_DP_ALARM_63_RSVD                      = 63 ;

parameter HQM_AP_ALARM_00_RSVD                      = 0 ;
parameter HQM_AP_ALARM_01_RSVD                      = 1 ;
parameter HQM_AP_ALARM_02_RSVD                      = 2 ;
parameter HQM_AP_ALARM_03_RSVD                      = 3 ;
parameter HQM_AP_ALARM_04_RSVD                      = 4 ;
parameter HQM_AP_ALARM_05_RSVD                      = 5 ;
parameter HQM_AP_ALARM_06_RSVD                      = 6 ;
parameter HQM_AP_ALARM_07_RSVD                      = 7 ;
parameter HQM_AP_ALARM_08_RSVD                      = 8 ;
parameter HQM_AP_ALARM_09_RSVD                      = 9 ;
parameter HQM_AP_ALARM_10_RSVD                      = 10 ;
parameter HQM_AP_ALARM_11_RSVD                      = 11 ;
parameter HQM_AP_ALARM_12_RSVD                      = 12 ;
parameter HQM_AP_ALARM_13_RSVD                      = 13 ;
parameter HQM_AP_ALARM_14_RSVD                      = 14 ;
parameter HQM_AP_ALARM_15_RSVD                      = 15 ;
parameter HQM_AP_ALARM_16_RSVD                      = 16 ;
parameter HQM_AP_ALARM_17_RSVD                      = 17 ;
parameter HQM_AP_ALARM_18_RSVD                      = 18 ;
parameter HQM_AP_ALARM_19_RSVD                      = 19 ;
parameter HQM_AP_ALARM_20_RSVD                      = 20 ;
parameter HQM_AP_ALARM_21_RSVD                      = 21 ;
parameter HQM_AP_ALARM_22_RSVD                      = 22 ;
parameter HQM_AP_ALARM_23_RSVD                      = 23 ;
parameter HQM_AP_ALARM_24_RSVD                      = 24 ;
parameter HQM_AP_ALARM_25_RSVD                      = 25 ;
parameter HQM_AP_ALARM_26_RSVD                      = 26 ;
parameter HQM_AP_ALARM_27_RSVD                      = 27 ;
parameter HQM_AP_ALARM_28_RSVD                      = 28 ;
parameter HQM_AP_ALARM_29_RSVD                      = 29 ;
parameter HQM_AP_ALARM_30_RSVD                      = 30 ;
parameter HQM_AP_ALARM_31_RSVD                      = 31 ;
parameter HQM_AP_ALARM_32_RSVD                      = 32 ;
parameter HQM_AP_ALARM_33_RSVD                      = 33 ;
parameter HQM_AP_ALARM_34_RSVD                      = 34 ;
parameter HQM_AP_ALARM_35_RSVD                      = 35 ;
parameter HQM_AP_ALARM_36_RSVD                      = 36 ;
parameter HQM_AP_ALARM_37_RSVD                      = 37 ;
parameter HQM_AP_ALARM_38_RSVD                      = 38 ;
parameter HQM_AP_ALARM_39_RSVD                      = 39 ;
parameter HQM_AP_ALARM_40_RSVD                      = 40 ;
parameter HQM_AP_ALARM_41_RSVD                      = 41 ;
parameter HQM_AP_ALARM_42_RSVD                      = 42 ;
parameter HQM_AP_ALARM_43_RSVD                      = 43 ;
parameter HQM_AP_ALARM_44_RSVD                      = 44 ;
parameter HQM_AP_ALARM_45_RSVD                      = 45 ;
parameter HQM_AP_ALARM_46_RSVD                      = 46 ;
parameter HQM_AP_ALARM_47_RSVD                      = 47 ;
parameter HQM_AP_ALARM_48_RSVD                      = 48 ;
parameter HQM_AP_ALARM_49_RSVD                      = 49 ;
parameter HQM_AP_ALARM_50_RSVD                      = 50 ;
parameter HQM_AP_ALARM_51_RSVD                      = 51 ;
parameter HQM_AP_ALARM_52_RSVD                      = 52 ;
parameter HQM_AP_ALARM_53_RSVD                      = 53 ;
parameter HQM_AP_ALARM_54_RSVD                      = 54 ;
parameter HQM_AP_ALARM_55_RSVD                      = 55 ;
parameter HQM_AP_ALARM_56_RSVD                      = 56 ;
parameter HQM_AP_ALARM_57_RSVD                      = 57 ;
parameter HQM_AP_ALARM_58_RSVD                      = 58 ;
parameter HQM_AP_ALARM_59_RSVD                      = 59 ;
parameter HQM_AP_ALARM_60_RSVD                      = 60 ;
parameter HQM_AP_ALARM_61_RSVD                      = 61 ;
parameter HQM_AP_ALARM_62_RSVD                      = 62 ;
parameter HQM_AP_ALARM_63_RSVD                      = 63 ;

parameter HQM_QED_ALARM_00_RSVD                      = 0 ;
parameter HQM_QED_ALARM_01_RSVD                      = 1 ;
parameter HQM_QED_ALARM_02_RSVD                      = 2 ;
parameter HQM_QED_ALARM_03_RSVD                      = 3 ;
parameter HQM_QED_ALARM_04_RSVD                      = 4 ;
parameter HQM_QED_ALARM_05_RSVD                      = 5 ;
parameter HQM_QED_ALARM_06_RSVD                      = 6 ;
parameter HQM_QED_ALARM_07_RSVD                      = 7 ;
parameter HQM_QED_ALARM_08_RSVD                      = 8 ;
parameter HQM_QED_ALARM_09_RSVD                      = 9 ;
parameter HQM_QED_ALARM_10_RSVD                      = 10 ;
parameter HQM_QED_ALARM_11_RSVD                      = 11 ;
parameter HQM_QED_ALARM_12_RSVD                      = 12 ;
parameter HQM_QED_ALARM_13_RSVD                      = 13 ;
parameter HQM_QED_ALARM_14_RSVD                      = 14 ;
parameter HQM_QED_ALARM_15_RSVD                      = 15 ;
parameter HQM_QED_ALARM_16_RSVD                      = 16 ;
parameter HQM_QED_ALARM_17_RSVD                      = 17 ;
parameter HQM_QED_ALARM_18_RSVD                      = 18 ;
parameter HQM_QED_ALARM_19_RSVD                      = 19 ;
parameter HQM_QED_ALARM_20_RSVD                      = 20 ;
parameter HQM_QED_ALARM_21_RSVD                      = 21 ;
parameter HQM_QED_ALARM_22_RSVD                      = 22 ;
parameter HQM_QED_ALARM_23_RSVD                      = 23 ;
parameter HQM_QED_ALARM_24_RSVD                      = 24 ;
parameter HQM_QED_ALARM_25_RSVD                      = 25 ;
parameter HQM_QED_ALARM_26_RSVD                      = 26 ;
parameter HQM_QED_ALARM_27_RSVD                      = 27 ;
parameter HQM_QED_ALARM_28_RSVD                      = 28 ;
parameter HQM_QED_ALARM_29_RSVD                      = 29 ;
parameter HQM_QED_ALARM_30_RSVD                      = 30 ;
parameter HQM_QED_ALARM_31_RSVD                      = 31 ;
parameter HQM_QED_ALARM_32_RSVD                      = 32 ;
parameter HQM_QED_ALARM_33_RSVD                      = 33 ;
parameter HQM_QED_ALARM_34_RSVD                      = 34 ;
parameter HQM_QED_ALARM_35_RSVD                      = 35 ;
parameter HQM_QED_ALARM_36_RSVD                      = 36 ;
parameter HQM_QED_ALARM_37_RSVD                      = 37 ;
parameter HQM_QED_ALARM_38_RSVD                      = 38 ;
parameter HQM_QED_ALARM_39_RSVD                      = 39 ;
parameter HQM_QED_ALARM_40_RSVD                      = 40 ;
parameter HQM_QED_ALARM_41_RSVD                      = 41 ;
parameter HQM_QED_ALARM_42_RSVD                      = 42 ;
parameter HQM_QED_ALARM_43_RSVD                      = 43 ;
parameter HQM_QED_ALARM_44_RSVD                      = 44 ;
parameter HQM_QED_ALARM_45_RSVD                      = 45 ;
parameter HQM_QED_ALARM_46_RSVD                      = 46 ;
parameter HQM_QED_ALARM_47_RSVD                      = 47 ;
parameter HQM_QED_ALARM_48_RSVD                      = 48 ;
parameter HQM_QED_ALARM_49_RSVD                      = 49 ;
parameter HQM_QED_ALARM_50_RSVD                      = 50 ;
parameter HQM_QED_ALARM_51_RSVD                      = 51 ;
parameter HQM_QED_ALARM_52_RSVD                      = 52 ;
parameter HQM_QED_ALARM_53_RSVD                      = 53 ;
parameter HQM_QED_ALARM_54_RSVD                      = 54 ;
parameter HQM_QED_ALARM_55_RSVD                      = 55 ;
parameter HQM_QED_ALARM_56_RSVD                      = 56 ;
parameter HQM_QED_ALARM_57_RSVD                      = 57 ;
parameter HQM_QED_ALARM_58_RSVD                      = 58 ;
parameter HQM_QED_ALARM_59_RSVD                      = 59 ;
parameter HQM_QED_ALARM_60_RSVD                      = 60 ;
parameter HQM_QED_ALARM_61_RSVD                      = 61 ;
parameter HQM_QED_ALARM_62_RSVD                      = 62 ;
parameter HQM_QED_ALARM_63_RSVD                      = 63 ;

parameter HQM_DQED_ALARM_00_RSVD                      = 0 ;
parameter HQM_DQED_ALARM_01_RSVD                      = 1 ;
parameter HQM_DQED_ALARM_02_RSVD                      = 2 ;
parameter HQM_DQED_ALARM_03_RSVD                      = 3 ;
parameter HQM_DQED_ALARM_04_RSVD                      = 4 ;
parameter HQM_DQED_ALARM_05_RSVD                      = 5 ;
parameter HQM_DQED_ALARM_06_RSVD                      = 6 ;
parameter HQM_DQED_ALARM_07_RSVD                      = 7 ;
parameter HQM_DQED_ALARM_08_RSVD                      = 8 ;
parameter HQM_DQED_ALARM_09_RSVD                      = 9 ;
parameter HQM_DQED_ALARM_10_RSVD                      = 10 ;
parameter HQM_DQED_ALARM_11_RSVD                      = 11 ;
parameter HQM_DQED_ALARM_12_RSVD                      = 12 ;
parameter HQM_DQED_ALARM_13_RSVD                      = 13 ;
parameter HQM_DQED_ALARM_14_RSVD                      = 14 ;
parameter HQM_DQED_ALARM_15_RSVD                      = 15 ;
parameter HQM_DQED_ALARM_16_RSVD                      = 16 ;
parameter HQM_DQED_ALARM_17_RSVD                      = 17 ;
parameter HQM_DQED_ALARM_18_RSVD                      = 18 ;
parameter HQM_DQED_ALARM_19_RSVD                      = 19 ;
parameter HQM_DQED_ALARM_20_RSVD                      = 20 ;
parameter HQM_DQED_ALARM_21_RSVD                      = 21 ;
parameter HQM_DQED_ALARM_22_RSVD                      = 22 ;
parameter HQM_DQED_ALARM_23_RSVD                      = 23 ;
parameter HQM_DQED_ALARM_24_RSVD                      = 24 ;
parameter HQM_DQED_ALARM_25_RSVD                      = 25 ;
parameter HQM_DQED_ALARM_26_RSVD                      = 26 ;
parameter HQM_DQED_ALARM_27_RSVD                      = 27 ;
parameter HQM_DQED_ALARM_28_RSVD                      = 28 ;
parameter HQM_DQED_ALARM_29_RSVD                      = 29 ;
parameter HQM_DQED_ALARM_30_RSVD                      = 30 ;
parameter HQM_DQED_ALARM_31_RSVD                      = 31 ;
parameter HQM_DQED_ALARM_32_RSVD                      = 32 ;
parameter HQM_DQED_ALARM_33_RSVD                      = 33 ;
parameter HQM_DQED_ALARM_34_RSVD                      = 34 ;
parameter HQM_DQED_ALARM_35_RSVD                      = 35 ;
parameter HQM_DQED_ALARM_36_RSVD                      = 36 ;
parameter HQM_DQED_ALARM_37_RSVD                      = 37 ;
parameter HQM_DQED_ALARM_38_RSVD                      = 38 ;
parameter HQM_DQED_ALARM_39_RSVD                      = 39 ;
parameter HQM_DQED_ALARM_40_RSVD                      = 40 ;
parameter HQM_DQED_ALARM_41_RSVD                      = 41 ;
parameter HQM_DQED_ALARM_42_RSVD                      = 42 ;
parameter HQM_DQED_ALARM_43_RSVD                      = 43 ;
parameter HQM_DQED_ALARM_44_RSVD                      = 44 ;
parameter HQM_DQED_ALARM_45_RSVD                      = 45 ;
parameter HQM_DQED_ALARM_46_RSVD                      = 46 ;
parameter HQM_DQED_ALARM_47_RSVD                      = 47 ;
parameter HQM_DQED_ALARM_48_RSVD                      = 48 ;
parameter HQM_DQED_ALARM_49_RSVD                      = 49 ;
parameter HQM_DQED_ALARM_50_RSVD                      = 50 ;
parameter HQM_DQED_ALARM_51_RSVD                      = 51 ;
parameter HQM_DQED_ALARM_52_RSVD                      = 52 ;
parameter HQM_DQED_ALARM_53_RSVD                      = 53 ;
parameter HQM_DQED_ALARM_54_RSVD                      = 54 ;
parameter HQM_DQED_ALARM_55_RSVD                      = 55 ;
parameter HQM_DQED_ALARM_56_RSVD                      = 56 ;
parameter HQM_DQED_ALARM_57_RSVD                      = 57 ;
parameter HQM_DQED_ALARM_58_RSVD                      = 58 ;
parameter HQM_DQED_ALARM_59_RSVD                      = 59 ;
parameter HQM_DQED_ALARM_60_RSVD                      = 60 ;
parameter HQM_DQED_ALARM_61_RSVD                      = 61 ;
parameter HQM_DQED_ALARM_62_RSVD                      = 62 ;
parameter HQM_DQED_ALARM_63_RSVD                      = 63 ;

parameter HQM_AQED_ALARM_00_RSVD                      = 0 ;
parameter HQM_AQED_ALARM_01_RSVD                      = 1 ;
parameter HQM_AQED_ALARM_02_RSVD                      = 2 ;
parameter HQM_AQED_ALARM_03_RSVD                      = 3 ;
parameter HQM_AQED_ALARM_04_RSVD                      = 4 ;
parameter HQM_AQED_ALARM_05_RSVD                      = 5 ;
parameter HQM_AQED_ALARM_06_RSVD                      = 6 ;
parameter HQM_AQED_ALARM_07_RSVD                      = 7 ;
parameter HQM_AQED_ALARM_08_RSVD                      = 8 ;
parameter HQM_AQED_ALARM_09_RSVD                      = 9 ;
parameter HQM_AQED_ALARM_10_RSVD                      = 10 ;
parameter HQM_AQED_ALARM_11_RSVD                      = 11 ;
parameter HQM_AQED_ALARM_12_RSVD                      = 12 ;
parameter HQM_AQED_ALARM_13_RSVD                      = 13 ;
parameter HQM_AQED_ALARM_14_RSVD                      = 14 ;
parameter HQM_AQED_ALARM_15_RSVD                      = 15 ;
parameter HQM_AQED_ALARM_16_RSVD                      = 16 ;
parameter HQM_AQED_ALARM_17_RSVD                      = 17 ;
parameter HQM_AQED_ALARM_18_RSVD                      = 18 ;
parameter HQM_AQED_ALARM_19_RSVD                      = 19 ;
parameter HQM_AQED_ALARM_20_RSVD                      = 20 ;
parameter HQM_AQED_ALARM_21_RSVD                      = 21 ;
parameter HQM_AQED_ALARM_22_RSVD                      = 22 ;
parameter HQM_AQED_ALARM_23_RSVD                      = 23 ;
parameter HQM_AQED_ALARM_24_RSVD                      = 24 ;
parameter HQM_AQED_ALARM_25_RSVD                      = 25 ;
parameter HQM_AQED_ALARM_26_RSVD                      = 26 ;
parameter HQM_AQED_ALARM_27_RSVD                      = 27 ;
parameter HQM_AQED_ALARM_28_RSVD                      = 28 ;
parameter HQM_AQED_ALARM_29_RSVD                      = 29 ;
parameter HQM_AQED_ALARM_30_RSVD                      = 30 ;
parameter HQM_AQED_ALARM_31_RSVD                      = 31 ;
parameter HQM_AQED_ALARM_32_RSVD                      = 32 ;
parameter HQM_AQED_ALARM_33_RSVD                      = 33 ;
parameter HQM_AQED_ALARM_34_RSVD                      = 34 ;
parameter HQM_AQED_ALARM_35_RSVD                      = 35 ;
parameter HQM_AQED_ALARM_36_RSVD                      = 36 ;
parameter HQM_AQED_ALARM_37_RSVD                      = 37 ;
parameter HQM_AQED_ALARM_38_RSVD                      = 38 ;
parameter HQM_AQED_ALARM_39_RSVD                      = 39 ;
parameter HQM_AQED_ALARM_40_RSVD                      = 40 ;
parameter HQM_AQED_ALARM_41_RSVD                      = 41 ;
parameter HQM_AQED_ALARM_42_RSVD                      = 42 ;
parameter HQM_AQED_ALARM_43_RSVD                      = 43 ;
parameter HQM_AQED_ALARM_44_RSVD                      = 44 ;
parameter HQM_AQED_ALARM_45_RSVD                      = 45 ;
parameter HQM_AQED_ALARM_46_RSVD                      = 46 ;
parameter HQM_AQED_ALARM_47_RSVD                      = 47 ;
parameter HQM_AQED_ALARM_48_RSVD                      = 48 ;
parameter HQM_AQED_ALARM_49_RSVD                      = 49 ;
parameter HQM_AQED_ALARM_50_RSVD                      = 50 ;
parameter HQM_AQED_ALARM_51_RSVD                      = 51 ;
parameter HQM_AQED_ALARM_52_RSVD                      = 52 ;
parameter HQM_AQED_ALARM_53_RSVD                      = 53 ;
parameter HQM_AQED_ALARM_54_RSVD                      = 54 ;
parameter HQM_AQED_ALARM_55_RSVD                      = 55 ;
parameter HQM_AQED_ALARM_56_RSVD                      = 56 ;
parameter HQM_AQED_ALARM_57_RSVD                      = 57 ;
parameter HQM_AQED_ALARM_58_RSVD                      = 58 ;
parameter HQM_AQED_ALARM_59_RSVD                      = 59 ;
parameter HQM_AQED_ALARM_60_RSVD                      = 60 ;
parameter HQM_AQED_ALARM_61_RSVD                      = 61 ;
parameter HQM_AQED_ALARM_62_RSVD                      = 62 ;
parameter HQM_AQED_ALARM_63_RSVD                      = 63 ;

parameter HQM_MSTR_ALARM_ERR_TIMEOUT                  = 0 ;
parameter HQM_MSTR_ALARM_ERR_CFG_REQRSP_UNSOL         = 1 ;
parameter HQM_MSTR_ALARM_ERR_CFG_PROTOCOL             = 2 ;
parameter HQM_MSTR_ALARM_ERR_SLV_PAR                  = 3 ;
parameter HQM_MSTR_ALARM_ERR_DECODE_PAR               = 4 ;
parameter HQM_MSTR_ALARM_ERR_RESERVED5                = 5 ;
parameter HQM_MSTR_ALARM_ERR_RESERVED6                = 6 ;
parameter HQM_MSTR_ALARM_ERR_RESERVED7                = 7 ;

//-----------------------------------------------------------------------------------------------------
// Config Master Params
//  hqm_pm_flr_unit:
parameter HQM_FLRSM_MAXCNT  = 32 ;

typedef enum logic [ 6 : 0 ] {
   HQM_FLRSM_INACTIVE            = 7'b0000001
 , HQM_FLRSM_PREP_ON             = 7'b0000010
 , HQM_FLRSM_CLK_EN_OFF          = 7'b0000100
 , HQM_FLRSM_PWRGOOD_RST_ACTIVE  = 7'b0001000
 , HQM_FLRSM_ACTIVE              = 7'b0010000
 , HQM_FLRSM_CLK_EN_ON           = 7'b0100000
 , HQM_FLRSM_PREP_OFF            = 7'b1000000
} flrsm_t;

typedef struct packed {
logic [ ( 4 ) -1 : 0 ] uid ;
logic [ ( 3 ) -1 : 0 ] err_enc ;
logic [ ( 4 ) -1 : 0 ] node ;
logic [ ( 16 ) -1 : 0 ] target ;
logic [ ( 4 ) -1 : 0 ]  offset_lsn;
} mstr_syndrome_t ;

parameter HQM_MSTR_CFG_HQM_CDC_CONTROL_DEFAULT         = 32'h00004444 ;
parameter HQM_MSTR_CFG_HQM_PGCB_CONTROL_DEFAULT        = 32'h2AAAAAAA ;
parameter HQM_MSTR_CFG_HQM_PGCB_CDC_LOCK_DEFAULT       = 32'h00000000 ;
parameter HQM_MSTR_CFG_PM_STATUS_DEFAULT               = 32'h00000000 ;
parameter HQM_MSTR_CFG_IOMMU_BYPASS_DEFAULT            = 32'h00000000 ;
parameter HQM_MSTR_CFG_HQM_CLK_SWITCH_OVERRIDE_DEFAULT = 32'h00000000 ;
parameter HQM_MSTR_CFG_PM_OVERRIDE_DEFAULT             = 32'h00000000 ;
parameter HQM_MSTR_CFG_PM_PMCSR_DISABLE_DEFAULT        = 32'h00000001 ;

parameter HQM_MSTR_CFG_CONTROL_GENERAL_DEFAULT         = 32'h70000080 ;
//-----------------------------------------------------------------------------------------------------
// Config Params
// UNIT_ID is used to identify broadcast responses (aggregated within cfg master)
// NUM_TGTS determines the number of 32b entries in UNIT_TGT_MAP & MSK
// TGT_MAP is a set of all addresses within that particular unit
//
// Fo rthe address mappings, specify in terms of 32b word addresses (which come on APB intf):
// Each TGT_MAP word should be set to specify the address range supported by the associated target.
// Each TGT_MSK word should be set to specify the bits in the corresponding TGT_MAP word that should be
// considered in the address decode.

parameter HQM_CORE_CFG_NUM_UNITS                = 9;
parameter HQM_PROC_CFG_NUM_UNITS                = 10;   //Includes SYS fo ridle and reset done reporting purposes
parameter HQM_CORE_CFG_TIMEOUT_WIDTH            = 20;
parameter HQM_CORE_CFG_TIMEOUT_VALUE            =  20'hfffff ; //2000; 

typedef struct packed {
  logic  [HQM_PROC_CFG_NUM_UNITS-1:0] hqm_reset_done;
} hqm_mstr_reset_done_t;

localparam BITS_HQM_MSTR_RESET_DONE_T = $bits(hqm_mstr_reset_done_t);

typedef struct packed {
  logic  [HQM_PROC_CFG_NUM_UNITS-1:0] vf_reset_done;
} hqm_mstr_vf_reset_done_t;

localparam BITS_HQM_MSTR_VF_RESET_DONE_T = $bits(hqm_mstr_vf_reset_done_t);

typedef struct packed {
  logic  [HQM_PROC_CFG_NUM_UNITS-1:0] unit_idle;
} hqm_mstr_unit_idle_t; 

localparam BITS_HQM_MSTR_UNIT_IDLE_T = $bits(hqm_mstr_unit_idle_t);

typedef struct packed {
  logic  [HQM_PROC_CFG_NUM_UNITS-1:0] unit_pipeidle;
} hqm_mstr_unit_pipeidle_t; 

localparam BITS_HQM_MSTR_UNIT_PIPEIDLE_T = $bits(hqm_mstr_unit_pipeidle_t);

typedef struct packed {
  logic  [HQM_PROC_CFG_NUM_UNITS-1:0] lcb_enable ;
} hqm_mstr_lcb_enable_t;

localparam BITS_HQM_MSTR_LCB_ENABLE_T = $bits(hqm_mstr_lcb_enable_t);

typedef struct  packed {
logic        ENABLE;
logic [14:0] SPARE;
logic [15:0] THRESHOLD;
} cfg_unit_timeout_t;

typedef struct  packed {
logic [7:0]  VERSION;
logic [23:0] SPARE;
} cfg_unit_version_t;

typedef struct packed {
  logic            enable;
  logic            hold;
} pipe_ctl_t;

typedef struct packed {
  logic              v;
  rop_qed_dqed_enq_t data;
} qed_dqed_enq_pipe_t;

typedef struct packed {
  logic              v;
  rop_nalb_enq_t     data;
} nalb_enq_pipe_t;

typedef struct packed {
  logic              v;
  rop_dp_enq_t       data;
} dp_enq_pipe_t;

typedef enum logic [1:0] {
  HCW_FRAG_UNDFINEDE0 = 2'h0
 ,REORD_FRAG_LB         = 2'h1
 ,REORD_FRAG_DIR        = 2'h2
 ,HCW_FRAG_UNDEFINED1 = 2'h3
} frag_type_t;

typedef enum logic [2:0] {
  REORD_UNUSED0    = 3'h0
 ,REORD_READ_CLEAR = 3'h1 // on completion read the ram contents and clear the reorder state
 ,REORD_FRAG       = 3'h2 // update frag state 
 ,REORD_COMP       = 3'h3
 ,REORD_FRAG_COMP  = 3'h4 // update frag state
} frag_op_t;

typedef struct packed {
frag_op_t          frag_op;
frag_type_t        frag_type;
logic [6:0]        qid; // this is here so that we can idetify the vf for vf-reset when error occurs
logic [14:0]       flid; // hp only when cnt==0, otherwise ignore
logic              flid_parity;
} frag_data_t;

typedef struct packed {
  logic              v;
  frag_data_t        data;
} reord_frag_t;

typedef struct packed {
    logic [1:0]   lb_residue;
    logic [1:0]   dir_residue;
    logic [4:0]   lb_cnt;
    logic [4:0]   dir_cnt;
} cnt_residue_t;

typedef struct packed {
logic       user; // this is hcw debug[3] bit going to lsp
logic [2:0] qpri;
logic [6:0] qid;
logic [2:0] qidix;
//logic       is_ldb ;    // Only needed if multi frag not supported
//logic       nz_count ;  // Only needed if multi frag not supported
logic qidix_msb;
logic [5:0] cq;
} reord_st_data_t;

typedef struct packed {
logic           parity; // parity only over the reord_state_data_t
logic           reord_st_valid;
reord_st_data_t reord_st;
} reord_st_t;

typedef struct  packed {
logic        dp_sn_v;
logic [10:0] dp_sn;
logic        nalb_sn_v;
logic [10:0] nalb_sn;
} sn_hazard_t;

typedef struct  packed {
logic [14:0] RSVD0;                         // [31:17]
logic        OVERRIDE_CLK_GATE;             // 16
logic        PWRGATE_PMC_WAKE;              // 15
logic [2:0]  RSVD1;                         // 14:12
logic [2:0]  OVERRIDE_CLK_SWITCH_CONTROL;   // 11:9
logic [1:0]  OVERRIDE_PMSM_PGCB_REQ_B;      // 8:7
logic [2:0]  OVERRIDE_PM_CFG_CONTROL;       // 6:4
logic [1:0]  OVERRIDE_FET_EN_B;             // 3:2
logic [1:0]  OVERRIDE_PMC_PGCB_ACK_B;       // 1:0
} master_ctl_reg_t;

typedef struct  packed {
logic [2:0]  OVERRIDE_CLK_SWITCH_CONTROL;   // 1:0
} master_ctl_clk_switch_t;

localparam BITS_HQM_MASTER_CTL_CLK_SWITCH_T = $bits(master_ctl_clk_switch_t);


typedef struct  packed {
logic        PWRGATE_PMC_WAKE;              // 4
logic [1:0]  OVERRIDE_FET_EN_B;             // 3:2
logic [1:0]  OVERRIDE_PMC_PGCB_ACK_B;       // 1:0
} master_ctl_pgcb_t;

// HQM_MASTER CFG STATUS 
typedef struct  packed {
logic       HQM_PROC_RESET_DONE; // [31:31]
logic [12:0]              RSVD0; // [30:18]
logic [6:0]         FLRSM_STATE; // [17:11]
logic           PF_RESET_ACTIVE; // 10
logic         SYS_PF_RESET_DONE; // 9
logic        AQED_PF_RESET_DONE; // 8
logic        DQED_PF_RESET_DONE; // 7
logic         QED_PF_RESET_DONE; // 6
logic          DP_PF_RESET_DONE; // 5
logic          AP_PF_RESET_DONE; // 4
logic        NALB_PF_RESET_DONE; // 3
logic         LSP_PF_RESET_DONE; // 2
logic         ROP_PF_RESET_DONE; // 1
logic         CHP_PF_RESET_DONE; // 0
} mstr_cfg_reset_status_reg_t;

typedef struct  packed {
logic           PF_RESET_ACTIVE;
logic         SYS_PF_RESET_DONE;
logic        AQED_PF_RESET_DONE;
logic        DQED_PF_RESET_DONE;
logic         QED_PF_RESET_DONE;
logic          DP_PF_RESET_DONE;
logic          AP_PF_RESET_DONE;
logic        NALB_PF_RESET_DONE;
logic         LSP_PF_RESET_DONE;
logic         ROP_PF_RESET_DONE;
logic         CHP_PF_RESET_DONE;
} mstr_proc_reset_status_t;

typedef struct  packed {
logic          HQM_FUNC_IDLE;         // 31
logic [1:0]    RSVD1;                 // [30:29]
logic          MSTR_PROC_IDLE_MASKED; // 28
logic          MSTR_PROC_IDLE;        // 27
logic          MSTR_FLR_CLKREQ_B;     // 26
logic          MSTR_CFG_MSTR_IDLE;    // 25
logic          MSTR_CFG_RING_IDLE;    // 24
logic [3:0]    RSVD0;                 // [23:20]
logic          SYS_UNIT_IDLE;         // 19
logic         AQED_UNIT_IDLE;         // 18
logic         DQED_UNIT_IDLE;         // 17
logic          QED_UNIT_IDLE;         // 16
logic           DP_UNIT_IDLE;         // 15
logic           AP_UNIT_IDLE;         // 14
logic         NALB_UNIT_IDLE;         // 13
logic          LSP_UNIT_IDLE;         // 12
logic          ROP_UNIT_IDLE;         // 11
logic          CHP_UNIT_IDLE;         // 10
logic          SYS_UNIT_PIPEIDLE;     // 9
logic         AQED_UNIT_PIPEIDLE;     // 8
logic         DQED_UNIT_PIPEIDLE;     // 7
logic          QED_UNIT_PIPEIDLE;     // 6
logic           DP_UNIT_PIPEIDLE;     // 5
logic           AP_UNIT_PIPEIDLE;     // 4
logic         NALB_UNIT_PIPEIDLE;     // 3
logic          LSP_UNIT_PIPEIDLE;     // 2
logic          ROP_UNIT_PIPEIDLE;     // 1
logic          CHP_UNIT_PIPEIDLE;     // 0
} mstr_cfg_idle_status_reg_t;  

typedef struct  packed {
logic          SYS_UNIT_IDLE;
logic         AQED_UNIT_IDLE;
logic         DQED_UNIT_IDLE;
logic          QED_UNIT_IDLE;
logic           DP_UNIT_IDLE;
logic           AP_UNIT_IDLE;
logic         NALB_UNIT_IDLE;
logic          LSP_UNIT_IDLE;
logic          ROP_UNIT_IDLE;
logic          CHP_UNIT_IDLE;
logic          SYS_UNIT_PIPEIDLE;
logic         AQED_UNIT_PIPEIDLE;
logic         DQED_UNIT_PIPEIDLE;
logic          QED_UNIT_PIPEIDLE;
logic           DP_UNIT_PIPEIDLE;
logic           AP_UNIT_PIPEIDLE;
logic         NALB_UNIT_PIPEIDLE;
logic          LSP_UNIT_PIPEIDLE;
logic          ROP_UNIT_PIPEIDLE;
logic          CHP_UNIT_PIPEIDLE;
} mstr_proc_idle_status_t;

typedef struct  packed {
logic [21:0]           RSVD0;
logic         SYS_LCB_ENABLE;
logic        AQED_LCB_ENABLE;
logic        DQED_LCB_ENABLE;
logic         QED_LCB_ENABLE;
logic          DP_LCB_ENABLE;
logic          AP_LCB_ENABLE;
logic        NALB_LCB_ENABLE;
logic         LSP_LCB_ENABLE;
logic         ROP_LCB_ENABLE;
logic         CHP_LCB_ENABLE;
} mstr_cfg_lcb_status_reg_t;

typedef struct  packed {
logic  SYS_LCB_ENABLE;
logic AQED_LCB_ENABLE;
logic DQED_LCB_ENABLE;
logic  QED_LCB_ENABLE;
logic   DP_LCB_ENABLE;
logic   AP_LCB_ENABLE;
logic NALB_LCB_ENABLE;
logic  LSP_LCB_ENABLE;
logic  ROP_LCB_ENABLE;
logic  CHP_LCB_ENABLE;
} mstr_proc_lcb_status_t;


typedef struct  packed {
logic [3:0]   CONSTANT;            // 31:28
logic [3:0]   PGCB_CLK;            // 27:24
logic [3:0]   HQM_CDC_CLK;         // 23:20
logic [3:0]   HQM_INP_GATED_CLK;   // 19:16
logic [3:0]   FLR_TRIGGERED;       // 15:12
logic [3:0]   RSVD0;               // 11:8
logic [3:0]   HQM_FLR_PREP;        // 7:4
logic [3:0]   HQM_GATED_RST_B;     // 3:0
} mstr_heartbeat_status_reg_t;


typedef struct  packed {
logic         CFG_TIMEOUT_ENABLE;
logic [14:0]  RSVD;
logic [15:0]  CFG_TIMEOUT_THRESHOLD;
} cfg_mstr_internal_timeout_t;

// HQM_MASTER STATIC CFG BUS
typedef struct  packed {
logic [12:0] RSVD;
logic        PWRGATE_DISABLED;
logic        CLKGATE_DISABLED;
logic        CLKREQ_CTL_DISABLED;
logic [3:0]  CLKGATE_HOLDOFF;
logic [3:0]  PWRGATE_HOLDOFF;          
logic [3:0]  CLKREQ_OFF_HOLDOFF;          
logic [3:0]  CLKREQ_SYNCOFF_HOLDOFF;
} cfg_hqm_cdc_ctl_t;

typedef struct  packed {
logic       RSVD;
logic       SLEEP_EN;
logic [1:0] SLEEP_INACTIV;
logic [1:0] TDEISOLATE;
logic [1:0] TPOKUP;
logic [1:0] TINACCRSTUP;
logic [1:0] TACCRSTUP;
logic [1:0] TLATCHEN;
logic [1:0] TPOKDOWN;
logic [1:0] TLATCHDIS;
logic [1:0] TSLEEPACT;
logic [1:0] TISOLATE;
logic [1:0] TRSTDOWN;
logic [1:0] TCLKSONACK_SRST;
logic [1:0] TCLKSOFFACK_SRST;
logic [1:0] TCLKSONACK_CP;
logic [1:0] TRSTUP2FRCCLKS;
} cfg_hqm_pgcb_ctl_t; 

typedef struct  packed {
logic [30:0] RSVD;
logic        OVERRIDE;
} cfg_pm_override_t;

typedef struct  packed {
logic [30:0] RSVD;
logic        DISABLE;
} cfg_pm_pmcsr_disable_t;

typedef struct  packed {
logic [30:0] RSVD;
logic        DISABLE;
} cfg_clk_cnt_disable_t;

typedef struct  packed {
logic [7:0]   PMSM;
logic [6:0]   reserved4; 
logic         hqm_in_d3;
logic         pm_fsm_d3tod0_ok;
logic         pm_fsm_d0tod3_ok;
logic         reserved3;       // reserved/spare
logic         reserved2;
logic         FUSE_PROC_DISABLE;
logic         FUSE_FORCE_ON;
logic         reserved1;      // reserved/spare
logic         reserved0;      // reserved/spare
logic         pgcb_fet_en_b;
logic         pmc_pgcb_fet_en_b;
logic         pmc_pgcb_pg_ack_b;
logic         pgcb_pmc_pg_req_b;
logic         PMSM_PGCB_REQ_B;
logic         PGCB_HQM_PG_RDY_ACK_B;
logic         PGCB_HQM_IDLE;
logic         PROCHOT;
}  cfg_pm_status_t ;

// COMMON REGISTER BIT ASSIGNMENTS
parameter HQM_CFG_UNIT_IDLE_PIPEIDLE = 0 ;
parameter HQM_CFG_UNIT_IDLE_UNITIDLE = 1 ;
parameter HQM_CFG_UNIT_IDLE_CFGBUSY = 2 ;
parameter HQM_CFG_UNIT_IDLE_CFGACTIVE = 3 ;
parameter HQM_CFG_UNIT_IDLE_CFGREADY = 4 ;

parameter HQM_CFG_RST_STAT_PFACTIVE = 0 ;
parameter HQM_CFG_RST_STAT_VFACTIVE = 1 ;
parameter HQM_CFG_RST_STAT_VFDONE = 2 ;
parameter HQM_CFG_RST_STAT_PFDONE = 3 ;
parameter HQM_CFG_RST_STAT_PFMAX = 4*1024 ;

parameter HQM_MSTR_CFG_SYS_RESET_VF_START_TGT         = 16'hffff ;  
//---------------------------------------------------------------------------------------------------------
// The following must be kept in-sync with the INFO spreadsheet
// BEGIN HQM_INFO_CFG
parameter HQM_AQED_CFG_UNIT_NUM_TGTS = 43 ; 
parameter HQM_AP_CFG_UNIT_NUM_TGTS = 51 ; 
parameter HQM_MSTR_CFG_UNIT_NUM_TGTS = 28 ; 
parameter HQM_CHP_CFG_UNIT_NUM_TGTS = 141 ; 
parameter HQM_DP_CFG_UNIT_NUM_TGTS = 39 ; 
parameter HQM_LSP_CFG_UNIT_NUM_TGTS = 197 ; 
parameter HQM_NALB_CFG_UNIT_NUM_TGTS = 44 ; 
parameter HQM_QED_CFG_UNIT_NUM_TGTS = 63 ; 
parameter HQM_ROP_CFG_UNIT_NUM_TGTS = 51 ; 
parameter MAX_CFG_UNIT_NUM_TGTS = 197 ; 



parameter HQM_AQED_TARGET_CFG_AQED_QID_HID_WIDTH = 42 ; 
parameter HQM_AQED_TARGET_CFG_AQED_QID_FID_LIMIT = 41 ; 
parameter HQM_AQED_TARGET_CFG_UNIT_VERSION = 40 ; 
parameter HQM_AQED_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_1 = 39 ; 
parameter HQM_AQED_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_0 = 38 ; 
parameter HQM_AQED_TARGET_CFG_AQED_CSR_CONTROL = 37 ; 
parameter HQM_AQED_TARGET_CFG_PATCH_CONTROL = 36 ; 
parameter HQM_AQED_TARGET_CFG_UNIT_TIMEOUT = 35 ; 
parameter HQM_AQED_TARGET_CFG_UNIT_IDLE = 34 ; 
parameter HQM_AQED_TARGET_CFG_SYNDROME_01 = 33 ; 
parameter HQM_AQED_TARGET_CFG_SYNDROME_00 = 32 ; 
parameter HQM_AQED_TARGET_CFG_SMON_TIMER = 31 ; 
parameter HQM_AQED_TARGET_CFG_SMON_MAXIMUM_TIMER = 30 ; 
parameter HQM_AQED_TARGET_CFG_SMON_CONFIGURATION1 = 29 ; 
parameter HQM_AQED_TARGET_CFG_SMON_CONFIGURATION0 = 28 ; 
parameter HQM_AQED_TARGET_CFG_SMON_COMPARE1 = 27 ; 
parameter HQM_AQED_TARGET_CFG_SMON_COMPARE0 = 26 ; 
parameter HQM_AQED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 = 25 ; 
parameter HQM_AQED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 = 24 ; 
parameter HQM_AQED_TARGET_CFG_PIPE_HEALTH_VALID = 23 ; 
parameter HQM_AQED_TARGET_CFG_PIPE_HEALTH_HOLD = 22 ; 
parameter HQM_AQED_TARGET_CFG_INTERFACE_STATUS = 21 ; 
parameter HQM_AQED_TARGET_CFG_HW_AGITATE_SELECT = 20 ; 
parameter HQM_AQED_TARGET_CFG_HW_AGITATE_CONTROL = 19 ; 
parameter HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF = 18 ; 
parameter HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF = 17 ; 
parameter HQM_AQED_TARGET_CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF = 16 ; 
parameter HQM_AQED_TARGET_CFG_FIFO_WMSTAT_FREELIST_RETURN = 15 ; 
parameter HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF = 14 ; 
parameter HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF = 13 ; 
parameter HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF = 12 ; 
parameter HQM_AQED_TARGET_CFG_ERROR_INJECT = 11 ; 
parameter HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 = 10 ; 
parameter HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 = 9 ; 
parameter HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS = 8 ; 
parameter HQM_AQED_TARGET_CFG_DETECT_FEATURE_OPERATION_00 = 7 ; 
parameter HQM_AQED_TARGET_CFG_CONTROL_PIPELINE_CREDITS = 6 ; 
parameter HQM_AQED_TARGET_CFG_CONTROL_GENERAL = 5 ; 
parameter HQM_AQED_TARGET_CFG_AQED_WRD3 = 4 ; 
parameter HQM_AQED_TARGET_CFG_AQED_WRD2 = 3 ; 
parameter HQM_AQED_TARGET_CFG_AQED_WRD1 = 2 ; 
parameter HQM_AQED_TARGET_CFG_AQED_WRD0 = 1 ; 
parameter HQM_AQED_TARGET_CFG_AQED_BCAM = 0 ; 
 
parameter HQM_AQED_CFG_UNIT_TGT_MAP = {
   16'h0080 //42 hqm_aqed_pipe VIR_MAP 0x020080000 HQM_OS_W cfg_aqed_qid_hid_width RW
 , 16'h0000 //41 hqm_aqed_pipe VIR_MAP 0x020000000 HQM_OS_W cfg_aqed_qid_fid_limit RW
 , 16'h4003 //40 hqm_aqed_pipe REG_MAP 0x02400000c HQM_OS_W cfg_unit_version RO
 , 16'h4002 //39 hqm_aqed_pipe REG_MAP 0x024000008 HQM_OS_W cfg_control_arb_weights_tqpri_atm_1 RO/V
 , 16'h4001 //38 hqm_aqed_pipe REG_MAP 0x024000004 HQM_OS_W cfg_control_arb_weights_tqpri_atm_0 RW
 , 16'h4000 //37 hqm_aqed_pipe REG_MAP 0x024000000 HQM_OS_W cfg_aqed_csr_control RW
 , 16'hC01F //36 hqm_aqed_pipe REG_MAP 0x02c00007c HQM_FEATURE_W cfg_patch_control RW
 , 16'hC01E //35 hqm_aqed_pipe REG_MAP 0x02c000078 HQM_FEATURE_W cfg_unit_timeout RW
 , 16'hC01D //34 hqm_aqed_pipe REG_MAP 0x02c000074 HQM_FEATURE_W cfg_unit_idle RO/V
 , 16'hC01C //33 hqm_aqed_pipe REG_MAP 0x02c000070 HQM_FEATURE_W cfg_syndrome_01 RW/1C/V
 , 16'hC01B //32 hqm_aqed_pipe REG_MAP 0x02c00006c HQM_FEATURE_W cfg_syndrome_00 RW/1C/V
 , 16'hC01A //31 hqm_aqed_pipe REG_MAP 0x02c000068 HQM_FEATURE_W cfg_smon_timer RW/V
 , 16'hC019 //30 hqm_aqed_pipe REG_MAP 0x02c000064 HQM_FEATURE_W cfg_smon_maximum_timer RW/V
 , 16'hC018 //29 hqm_aqed_pipe REG_MAP 0x02c000060 HQM_FEATURE_W cfg_smon_configuration1 RW
 , 16'hC017 //28 hqm_aqed_pipe REG_MAP 0x02c00005c HQM_FEATURE_W cfg_smon_configuration0 RW
 , 16'hC016 //27 hqm_aqed_pipe REG_MAP 0x02c000058 HQM_FEATURE_W cfg_smon_compare1 RW/V
 , 16'hC015 //26 hqm_aqed_pipe REG_MAP 0x02c000054 HQM_FEATURE_W cfg_smon_compare0 RW/V
 , 16'hC014 //25 hqm_aqed_pipe REG_MAP 0x02c000050 HQM_FEATURE_W cfg_smon_activitycounter1 RW/V
 , 16'hC013 //24 hqm_aqed_pipe REG_MAP 0x02c00004c HQM_FEATURE_W cfg_smon_activitycounter0 RW/V
 , 16'hC012 //23 hqm_aqed_pipe REG_MAP 0x02c000048 HQM_FEATURE_W cfg_pipe_health_valid RO/V
 , 16'hC011 //22 hqm_aqed_pipe REG_MAP 0x02c000044 HQM_FEATURE_W cfg_pipe_health_hold RO/V
 , 16'hC010 //21 hqm_aqed_pipe REG_MAP 0x02c000040 HQM_FEATURE_W cfg_interface_status RO/V
 , 16'hC00F //20 hqm_aqed_pipe REG_MAP 0x02c00003c HQM_FEATURE_W cfg_hw_agitate_select RW
 , 16'hC00E //19 hqm_aqed_pipe REG_MAP 0x02c000038 HQM_FEATURE_W cfg_hw_agitate_control RW
 , 16'hC00D //18 hqm_aqed_pipe REG_MAP 0x02c000034 HQM_FEATURE_W cfg_fifo_wmstat_qed_aqed_enq_if RW/V
 , 16'hC00C //17 hqm_aqed_pipe REG_MAP 0x02c000030 HQM_FEATURE_W cfg_fifo_wmstat_qed_aqed_enq_fid_if RW/V
 , 16'hC00B //16 hqm_aqed_pipe REG_MAP 0x02c00002c HQM_FEATURE_W cfg_fifo_wmstat_lsp_aqed_cmp_fid_if RW/V
 , 16'hC00A //15 hqm_aqed_pipe REG_MAP 0x02c000028 HQM_FEATURE_W cfg_fifo_wmstat_freelist_return RW/V
 , 16'hC009 //14 hqm_aqed_pipe REG_MAP 0x02c000024 HQM_FEATURE_W cfg_fifo_wmstat_aqed_chp_sch_if RW/V
 , 16'hC008 //13 hqm_aqed_pipe REG_MAP 0x02c000020 HQM_FEATURE_W cfg_fifo_wmstat_aqed_ap_enq_if RW/V
 , 16'hC007 //12 hqm_aqed_pipe REG_MAP 0x02c00001c HQM_FEATURE_W cfg_fifo_wmstat_ap_aqed_if RW/V
 , 16'hC006 //11 hqm_aqed_pipe REG_MAP 0x02c000018 HQM_FEATURE_W cfg_error_inject RW
 , 16'hC005 //10 hqm_aqed_pipe REG_MAP 0x02c000014 HQM_FEATURE_W cfg_diagnostic_aw_status_02 RO/V
 , 16'hC004 //9 hqm_aqed_pipe REG_MAP 0x02c000010 HQM_FEATURE_W cfg_diagnostic_aw_status_01 RO/V
 , 16'hC003 //8 hqm_aqed_pipe REG_MAP 0x02c00000c HQM_FEATURE_W cfg_diagnostic_aw_status RO/V
 , 16'hC002 //7 hqm_aqed_pipe REG_MAP 0x02c000008 HQM_FEATURE_W cfg_detect_feature_operation_00 RW/V
 , 16'hC001 //6 hqm_aqed_pipe REG_MAP 0x02c000004 HQM_FEATURE_W cfg_control_pipeline_credits RW
 , 16'hC000 //5 hqm_aqed_pipe REG_MAP 0x02c000000 HQM_FEATURE_W cfg_control_general RW
 , 16'hE040 //4 hqm_aqed_pipe MEM_MAP 0x02e040000 HQM_FEATURE_W cfg_aqed_wrd3 RO/V
 , 16'hE030 //3 hqm_aqed_pipe MEM_MAP 0x02e030000 HQM_FEATURE_W cfg_aqed_wrd2 RO/V
 , 16'hE020 //2 hqm_aqed_pipe MEM_MAP 0x02e020000 HQM_FEATURE_W cfg_aqed_wrd1 RO/V
 , 16'hE010 //1 hqm_aqed_pipe MEM_MAP 0x02e010000 HQM_FEATURE_W cfg_aqed_wrd0 RO/V
 , 16'hE000 //0 hqm_aqed_pipe MEM_MAP 0x02e000000 HQM_FEATURE_W cfg_aqed_bcam RO/V
 }; 
 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 = 50 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 = 49 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 = 48 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 = 47 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 = 46 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 = 45 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 = 44 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 = 43 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 = 42 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 = 41 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 = 40 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 = 39 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 = 38 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 = 37 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 = 36 ; 
parameter HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 = 35 ; 
parameter HQM_AP_TARGET_CFG_LDB_QID_RDYLST_CLAMP = 34 ; 
parameter HQM_AP_TARGET_CFG_UNIT_VERSION = 33 ; 
parameter HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_SCHED_BIN = 32 ; 
parameter HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_READY_BIN = 31 ; 
parameter HQM_AP_TARGET_CFG_AP_CSR_CONTROL = 30 ; 
parameter HQM_AP_TARGET_CFG_PATCH_CONTROL = 29 ; 
parameter HQM_AP_TARGET_CFG_UNIT_TIMEOUT = 28 ; 
parameter HQM_AP_TARGET_CFG_UNIT_IDLE = 27 ; 
parameter HQM_AP_TARGET_CFG_SYNDROME_01 = 26 ; 
parameter HQM_AP_TARGET_CFG_SYNDROME_00 = 25 ; 
parameter HQM_AP_TARGET_CFG_SMON_TIMER = 24 ; 
parameter HQM_AP_TARGET_CFG_SMON_MAXIMUM_TIMER = 23 ; 
parameter HQM_AP_TARGET_CFG_SMON_CONFIGURATION1 = 22 ; 
parameter HQM_AP_TARGET_CFG_SMON_CONFIGURATION0 = 21 ; 
parameter HQM_AP_TARGET_CFG_SMON_COMPARE1 = 20 ; 
parameter HQM_AP_TARGET_CFG_SMON_COMPARE0 = 19 ; 
parameter HQM_AP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 = 18 ; 
parameter HQM_AP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 = 17 ; 
parameter HQM_AP_TARGET_CFG_PIPE_HEALTH_VALID_00 = 16 ; 
parameter HQM_AP_TARGET_CFG_PIPE_HEALTH_HOLD_00 = 15 ; 
parameter HQM_AP_TARGET_CFG_INTERFACE_STATUS = 14 ; 
parameter HQM_AP_TARGET_CFG_HW_AGITATE_SELECT = 13 ; 
parameter HQM_AP_TARGET_CFG_HW_AGITATE_CONTROL = 12 ; 
parameter HQM_AP_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF = 11 ; 
parameter HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF = 10 ; 
parameter HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF = 9 ; 
parameter HQM_AP_TARGET_CFG_ERROR_INJECT = 8 ; 
parameter HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_03 = 7 ; 
parameter HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 = 6 ; 
parameter HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 = 5 ; 
parameter HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS = 4 ; 
parameter HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 = 3 ; 
parameter HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 = 2 ; 
parameter HQM_AP_TARGET_CFG_CONTROL_PIPELINE_CREDITS = 1 ; 
parameter HQM_AP_TARGET_CFG_CONTROL_GENERAL = 0 ; 
 
parameter HQM_AP_CFG_UNIT_TGT_MAP = {
   16'h0800 //50 hqm_atomic_pipe VIR_MAP 0x030800000 HQM_OS_W cfg_qid_ldb_qid2cqidix_15 RW
 , 16'h0780 //49 hqm_atomic_pipe VIR_MAP 0x030780000 HQM_OS_W cfg_qid_ldb_qid2cqidix_14 RW
 , 16'h0700 //48 hqm_atomic_pipe VIR_MAP 0x030700000 HQM_OS_W cfg_qid_ldb_qid2cqidix_13 RW
 , 16'h0680 //47 hqm_atomic_pipe VIR_MAP 0x030680000 HQM_OS_W cfg_qid_ldb_qid2cqidix_12 RW
 , 16'h0600 //46 hqm_atomic_pipe VIR_MAP 0x030600000 HQM_OS_W cfg_qid_ldb_qid2cqidix_11 RW
 , 16'h0580 //45 hqm_atomic_pipe VIR_MAP 0x030580000 HQM_OS_W cfg_qid_ldb_qid2cqidix_10 RW
 , 16'h0500 //44 hqm_atomic_pipe VIR_MAP 0x030500000 HQM_OS_W cfg_qid_ldb_qid2cqidix_09 RW
 , 16'h0480 //43 hqm_atomic_pipe VIR_MAP 0x030480000 HQM_OS_W cfg_qid_ldb_qid2cqidix_08 RW
 , 16'h0400 //42 hqm_atomic_pipe VIR_MAP 0x030400000 HQM_OS_W cfg_qid_ldb_qid2cqidix_07 RW
 , 16'h0380 //41 hqm_atomic_pipe VIR_MAP 0x030380000 HQM_OS_W cfg_qid_ldb_qid2cqidix_06 RW
 , 16'h0300 //40 hqm_atomic_pipe VIR_MAP 0x030300000 HQM_OS_W cfg_qid_ldb_qid2cqidix_05 RW
 , 16'h0280 //39 hqm_atomic_pipe VIR_MAP 0x030280000 HQM_OS_W cfg_qid_ldb_qid2cqidix_04 RW
 , 16'h0200 //38 hqm_atomic_pipe VIR_MAP 0x030200000 HQM_OS_W cfg_qid_ldb_qid2cqidix_03 RW
 , 16'h0180 //37 hqm_atomic_pipe VIR_MAP 0x030180000 HQM_OS_W cfg_qid_ldb_qid2cqidix_02 RW
 , 16'h0100 //36 hqm_atomic_pipe VIR_MAP 0x030100000 HQM_OS_W cfg_qid_ldb_qid2cqidix_01 RW
 , 16'h0080 //35 hqm_atomic_pipe VIR_MAP 0x030080000 HQM_OS_W cfg_qid_ldb_qid2cqidix_00 RW
 , 16'h0000 //34 hqm_atomic_pipe VIR_MAP 0x030000000 HQM_OS_W cfg_ldb_qid_rdylst_clamp RW
 , 16'h4003 //33 hqm_atomic_pipe REG_MAP 0x03400000c HQM_OS_W cfg_unit_version RO
 , 16'h4002 //32 hqm_atomic_pipe REG_MAP 0x034000008 HQM_OS_W cfg_control_arb_weights_sched_bin RW
 , 16'h4001 //31 hqm_atomic_pipe REG_MAP 0x034000004 HQM_OS_W cfg_control_arb_weights_ready_bin RW
 , 16'h4000 //30 hqm_atomic_pipe REG_MAP 0x034000000 HQM_OS_W cfg_ap_csr_control RW
 , 16'hC01D //29 hqm_atomic_pipe REG_MAP 0x03c000074 HQM_FEATURE_W cfg_patch_control RW
 , 16'hC01C //28 hqm_atomic_pipe REG_MAP 0x03c000070 HQM_FEATURE_W cfg_unit_timeout RW
 , 16'hC01B //27 hqm_atomic_pipe REG_MAP 0x03c00006c HQM_FEATURE_W cfg_unit_idle RO/V
 , 16'hC01A //26 hqm_atomic_pipe REG_MAP 0x03c000068 HQM_FEATURE_W cfg_syndrome_01 RW/1C/V
 , 16'hC019 //25 hqm_atomic_pipe REG_MAP 0x03c000064 HQM_FEATURE_W cfg_syndrome_00 RW/1C/V
 , 16'hC018 //24 hqm_atomic_pipe REG_MAP 0x03c000060 HQM_FEATURE_W cfg_smon_timer RW/V
 , 16'hC017 //23 hqm_atomic_pipe REG_MAP 0x03c00005c HQM_FEATURE_W cfg_smon_maximum_timer RW/V
 , 16'hC016 //22 hqm_atomic_pipe REG_MAP 0x03c000058 HQM_FEATURE_W cfg_smon_configuration1 RW
 , 16'hC015 //21 hqm_atomic_pipe REG_MAP 0x03c000054 HQM_FEATURE_W cfg_smon_configuration0 RW
 , 16'hC014 //20 hqm_atomic_pipe REG_MAP 0x03c000050 HQM_FEATURE_W cfg_smon_compare1 RW/V
 , 16'hC013 //19 hqm_atomic_pipe REG_MAP 0x03c00004c HQM_FEATURE_W cfg_smon_compare0 RW/V
 , 16'hC012 //18 hqm_atomic_pipe REG_MAP 0x03c000048 HQM_FEATURE_W cfg_smon_activitycounter1 RW/V
 , 16'hC011 //17 hqm_atomic_pipe REG_MAP 0x03c000044 HQM_FEATURE_W cfg_smon_activitycounter0 RW/V
 , 16'hC010 //16 hqm_atomic_pipe REG_MAP 0x03c000040 HQM_FEATURE_W cfg_pipe_health_valid_00 RO/V
 , 16'hC00F //15 hqm_atomic_pipe REG_MAP 0x03c00003c HQM_FEATURE_W cfg_pipe_health_hold_00 RO/V
 , 16'hC00E //14 hqm_atomic_pipe REG_MAP 0x03c000038 HQM_FEATURE_W cfg_interface_status RO/V
 , 16'hC00D //13 hqm_atomic_pipe REG_MAP 0x03c000034 HQM_FEATURE_W cfg_hw_agitate_select RW
 , 16'hC00C //12 hqm_atomic_pipe REG_MAP 0x03c000030 HQM_FEATURE_W cfg_hw_agitate_control RW
 , 16'hC00B //11 hqm_atomic_pipe REG_MAP 0x03c00002c HQM_FEATURE_W cfg_fifo_wmstat_aqed_ap_enq_if RW/V
 , 16'hC00A //10 hqm_atomic_pipe REG_MAP 0x03c000028 HQM_FEATURE_W cfg_fifo_wmstat_ap_lsp_enq_if RW/V
 , 16'hC009 //9 hqm_atomic_pipe REG_MAP 0x03c000024 HQM_FEATURE_W cfg_fifo_wmstat_ap_aqed_if RW/V
 , 16'hC008 //8 hqm_atomic_pipe REG_MAP 0x03c000020 HQM_FEATURE_W cfg_error_inject RW
 , 16'hC007 //7 hqm_atomic_pipe REG_MAP 0x03c00001c HQM_FEATURE_W cfg_diagnostic_aw_status_03 RO/V
 , 16'hC006 //6 hqm_atomic_pipe REG_MAP 0x03c000018 HQM_FEATURE_W cfg_diagnostic_aw_status_02 RO/V
 , 16'hC005 //5 hqm_atomic_pipe REG_MAP 0x03c000014 HQM_FEATURE_W cfg_diagnostic_aw_status_01 RO/V
 , 16'hC004 //4 hqm_atomic_pipe REG_MAP 0x03c000010 HQM_FEATURE_W cfg_diagnostic_aw_status RO/V
 , 16'hC003 //3 hqm_atomic_pipe REG_MAP 0x03c00000c HQM_FEATURE_W cfg_detect_feature_operation_01 RW/V
 , 16'hC002 //2 hqm_atomic_pipe REG_MAP 0x03c000008 HQM_FEATURE_W cfg_detect_feature_operation_00 RW/V
 , 16'hC001 //1 hqm_atomic_pipe REG_MAP 0x03c000004 HQM_FEATURE_W cfg_control_pipeline_credits RW
 , 16'hC000 //0 hqm_atomic_pipe REG_MAP 0x03c000000 HQM_FEATURE_W cfg_control_general RW
 }; 
 
parameter HQM_MSTR_TARGET_CFG_UNIT_VERSION = 27 ; 
parameter HQM_MSTR_TARGET_CFG_TS_CONTROL = 26 ; 
parameter HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE = 25 ; 
parameter HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_H = 24 ; 
parameter HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_L = 23 ; 
parameter HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_H = 22 ; 
parameter HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_L = 21 ; 
parameter HQM_MSTR_TARGET_CFG_PROCHOT_CNT_H = 20 ; 
parameter HQM_MSTR_TARGET_CFG_PROCHOT_CNT_L = 19 ; 
parameter HQM_MSTR_TARGET_CFG_PROC_ON_CNT_H = 18 ; 
parameter HQM_MSTR_TARGET_CFG_PROC_ON_CNT_L = 17 ; 
parameter HQM_MSTR_TARGET_CFG_CLK_ON_CNT_H = 16 ; 
parameter HQM_MSTR_TARGET_CFG_CLK_ON_CNT_L = 15 ; 
parameter HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE = 14 ; 
parameter HQM_MSTR_TARGET_CFG_PM_STATUS = 13 ; 
parameter HQM_MSTR_TARGET_CFG_FLR_COUNT_H = 12 ; 
parameter HQM_MSTR_TARGET_CFG_FLR_COUNT_L = 11 ; 
parameter HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT = 10 ; 
parameter HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS = 9 ; 
parameter HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS = 8 ; 
parameter HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME = 7 ; 
parameter HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 = 6 ; 
parameter HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS = 5 ; 
parameter HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT = 4 ; 
parameter HQM_MSTR_TARGET_CFG_CONTROL_GENERAL = 3 ; 
parameter HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL = 2 ; 
parameter HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL = 1 ; 
parameter HQM_MSTR_TARGET_CFG_PM_OVERRIDE = 0 ; 
 
parameter HQM_MSTR_CFG_UNIT_TGT_MAP = {
   16'h4013 //27 hqm_config_master REG_MAP 0x0a400004c HQM_OS_W cfg_unit_version RO
 , 16'h4012 //26 hqm_config_master REG_MAP 0x0a4000048 HQM_OS_W cfg_ts_control RW
 , 16'h4011 //25 hqm_config_master REG_MAP 0x0a4000044 HQM_OS_W cfg_clk_cnt_disable RW
 , 16'h4010 //24 hqm_config_master REG_MAP 0x0a4000040 HQM_OS_W cfg_d3tod0_event_cnt_h RO/V
 , 16'h400F //23 hqm_config_master REG_MAP 0x0a400003c HQM_OS_W cfg_d3tod0_event_cnt_l RO/V
 , 16'h400E //22 hqm_config_master REG_MAP 0x0a4000038 HQM_OS_W cfg_prochot_event_cnt_h RO/V
 , 16'h400D //21 hqm_config_master REG_MAP 0x0a4000034 HQM_OS_W cfg_prochot_event_cnt_l RO/V
 , 16'h400C //20 hqm_config_master REG_MAP 0x0a4000030 HQM_OS_W cfg_prochot_cnt_h RO/V
 , 16'h400B //19 hqm_config_master REG_MAP 0x0a400002c HQM_OS_W cfg_prochot_cnt_l RO/V
 , 16'h400A //18 hqm_config_master REG_MAP 0x0a4000028 HQM_OS_W cfg_proc_on_cnt_h RO/V
 , 16'h4009 //17 hqm_config_master REG_MAP 0x0a4000024 HQM_OS_W cfg_proc_on_cnt_l RO/V
 , 16'h4008 //16 hqm_config_master REG_MAP 0x0a4000020 HQM_OS_W cfg_clk_on_cnt_h RO/V
 , 16'h4007 //15 hqm_config_master REG_MAP 0x0a400001c HQM_OS_W cfg_clk_on_cnt_l RO/V
 , 16'h4006 //14 hqm_config_master REG_MAP 0x0a4000018 HQM_OS_W cfg_pm_pmcsr_disable RW/0C/V
 , 16'h4005 //13 hqm_config_master REG_MAP 0x0a4000014 HQM_OS_W cfg_pm_status RO/V
 , 16'h4004 //12 hqm_config_master REG_MAP 0x0a4000010 HQM_OS_W cfg_flr_count_h RO/V
 , 16'h4003 //11 hqm_config_master REG_MAP 0x0a400000c HQM_OS_W cfg_flr_count_l RO/V
 , 16'h4002 //10 hqm_config_master REG_MAP 0x0a4000008 HQM_OS_W cfg_diagnostic_heartbeat RO/V
 , 16'h4001 //9 hqm_config_master REG_MAP 0x0a4000004 HQM_OS_W cfg_diagnostic_idle_status RO/V
 , 16'h4000 //8 hqm_config_master REG_MAP 0x0a4000000 HQM_OS_W cfg_diagnostic_reset_status RO/V
 , 16'hC008 //7 hqm_config_master REG_MAP 0x0ac000020 HQM_FEATURE_W cfg_diagnostic_syndrome RW/1C/V
 , 16'hC007 //6 hqm_config_master REG_MAP 0x0ac00001c HQM_FEATURE_W cfg_diagnostic_status_1 RW/1C/V
 , 16'hC006 //5 hqm_config_master REG_MAP 0x0ac000018 HQM_FEATURE_W cfg_diagnostic_proc_lcb_status RO/V
 , 16'hC005 //4 hqm_config_master REG_MAP 0x0ac000014 HQM_FEATURE_W cfg_mstr_internal_timeout RW
 , 16'hC004 //3 hqm_config_master REG_MAP 0x0ac000010 HQM_FEATURE_W cfg_control_general RW
 , 16'hC003 //2 hqm_config_master REG_MAP 0x0ac00000c HQM_FEATURE_W cfg_hqm_cdc_control RW
 , 16'hC002 //1 hqm_config_master REG_MAP 0x0ac000008 HQM_FEATURE_W cfg_hqm_pgcb_control RW
 , 16'hC001 //0 hqm_config_master REG_MAP 0x0ac000004 HQM_FEATURE_W cfg_pm_override RW
 }; 
 
parameter HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT = 140 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ2VAS = 139 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_WPTR = 138 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB = 137 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT = 136 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD = 135 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_COUNT = 134 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB = 133 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH = 132 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH = 131 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING = 130 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK = 129 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR = 128 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR = 127 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT = 126 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE = 125 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR = 124 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR = 123 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT = 122 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_BASE = 121 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_MODE = 120 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD = 119 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ2VAS = 118 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_WPTR = 117 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB = 116 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT = 115 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD = 114 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_COUNT = 113 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB = 112 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH = 111 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH = 110 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING = 109 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK = 108 ; 
parameter HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL = 107 ; 
parameter HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP = 106 ; 
parameter HQM_CHP_TARGET_CFG_ORD_QID_SN = 105 ; 
parameter HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT = 104 ; 
parameter HQM_CHP_TARGET_CFG_UNIT_VERSION = 103 ; 
parameter HQM_CHP_TARGET_CFG_SYNDROME_00 = 102 ; 
parameter HQM_CHP_TARGET_CFG_RETN_ZERO = 101 ; 
parameter HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD = 100 ; 
parameter HQM_CHP_TARGET_CFG_LDB_WD_IRQ1 = 99 ; 
parameter HQM_CHP_TARGET_CFG_LDB_WD_IRQ0 = 98 ; 
parameter HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL = 97 ; 
parameter HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 = 96 ; 
parameter HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 = 95 ; 
parameter HQM_CHP_TARGET_CFG_LDB_WDRT_1 = 94 ; 
parameter HQM_CHP_TARGET_CFG_LDB_WDRT_0 = 93 ; 
parameter HQM_CHP_TARGET_CFG_LDB_WDTO_1 = 92 ; 
parameter HQM_CHP_TARGET_CFG_LDB_WDTO_0 = 91 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL = 90 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1 = 89 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0 = 88 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1 = 87 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0 = 86 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1 = 85 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0 = 84 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1 = 83 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0 = 82 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 = 81 ; 
parameter HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 = 80 ; 
parameter HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD = 79 ; 
parameter HQM_CHP_TARGET_CFG_DIR_WD_IRQ1 = 78 ; 
parameter HQM_CHP_TARGET_CFG_DIR_WD_IRQ0 = 77 ; 
parameter HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL = 76 ; 
parameter HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 = 75 ; 
parameter HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 = 74 ; 
parameter HQM_CHP_TARGET_CFG_DIR_WDRT_1 = 73 ; 
parameter HQM_CHP_TARGET_CFG_DIR_WDRT_0 = 72 ; 
parameter HQM_CHP_TARGET_CFG_DIR_WDTO_1 = 71 ; 
parameter HQM_CHP_TARGET_CFG_DIR_WDTO_0 = 70 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL = 69 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1 = 68 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0 = 67 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1 = 66 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0 = 65 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1 = 64 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0 = 63 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1 = 62 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0 = 61 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 = 60 ; 
parameter HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 = 59 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_H = 58 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_L = 57 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_H = 56 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_L = 55 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_H = 54 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_L = 53 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_H = 52 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_L = 51 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_H = 50 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_L = 49 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_H = 48 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_L = 47 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_H = 46 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_L = 45 ; 
parameter HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_H = 44 ; 
parameter HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_L = 43 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL = 42 ; 
parameter HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL = 41 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_H = 40 ; 
parameter HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_L = 39 ; 
parameter HQM_CHP_TARGET_CFG_PATCH_CONTROL = 38 ; 
parameter HQM_CHP_TARGET_CFG_UNIT_TIMEOUT = 37 ; 
parameter HQM_CHP_TARGET_CFG_UNIT_IDLE = 36 ; 
parameter HQM_CHP_TARGET_CFG_SYNDROME_01 = 35 ; 
parameter HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID = 34 ; 
parameter HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD = 33 ; 
parameter HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT = 32 ; 
parameter HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL = 31 ; 
parameter HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0 = 30 ; 
parameter HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3 = 29 ; 
parameter HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2 = 28 ; 
parameter HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1 = 27 ; 
parameter HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0 = 26 ; 
parameter HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 = 25 ; 
parameter HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 = 24 ; 
parameter HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 = 23 ; 
parameter HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02 = 22 ; 
parameter HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01 = 21 ; 
parameter HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00 = 20 ; 
parameter HQM_CHP_TARGET_CFG_CHP_SMON_TIMER = 19 ; 
parameter HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER = 18 ; 
parameter HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 = 17 ; 
parameter HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 = 16 ; 
parameter HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 = 15 ; 
parameter HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 = 14 ; 
parameter HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 = 13 ; 
parameter HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 = 12 ; 
parameter HQM_CHP_TARGET_CFG_FREELIST_7 = 11 ; 
parameter HQM_CHP_TARGET_CFG_FREELIST_6 = 10 ; 
parameter HQM_CHP_TARGET_CFG_FREELIST_5 = 9 ; 
parameter HQM_CHP_TARGET_CFG_FREELIST_4 = 8 ; 
parameter HQM_CHP_TARGET_CFG_FREELIST_3 = 7 ; 
parameter HQM_CHP_TARGET_CFG_FREELIST_2 = 6 ; 
parameter HQM_CHP_TARGET_CFG_FREELIST_1 = 5 ; 
parameter HQM_CHP_TARGET_CFG_FREELIST_0 = 4 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_A_1 = 3 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_A_0 = 2 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_1 = 1 ; 
parameter HQM_CHP_TARGET_CFG_HIST_LIST_0 = 0 ; 
 
parameter HQM_CHP_CFG_UNIT_TGT_MAP = {
   16'h1200 //140 hqm_credit_hist_pipe VIR_MAP 0x041200000 HQM_OS_W cfg_chp_frag_count RO/V
 , 16'h1180 //139 hqm_credit_hist_pipe VIR_MAP 0x041180000 HQM_OS_W cfg_ldb_cq2vas RW
 , 16'h1100 //138 hqm_credit_hist_pipe VIR_MAP 0x041100000 HQM_OS_W cfg_ldb_cq_wptr RW/V
 , 16'h1080 //137 hqm_credit_hist_pipe VIR_MAP 0x041080000 HQM_OS_W cfg_ldb_cq_wd_enb RW
 , 16'h1000 //136 hqm_credit_hist_pipe VIR_MAP 0x041000000 HQM_OS_W cfg_ldb_cq_token_depth_select RW
 , 16'h0F80 //135 hqm_credit_hist_pipe VIR_MAP 0x040f80000 HQM_OS_W cfg_ldb_cq_timer_threshold RW
 , 16'h0F00 //134 hqm_credit_hist_pipe VIR_MAP 0x040f00000 HQM_OS_W cfg_ldb_cq_timer_count RO/V
 , 16'h0E80 //133 hqm_credit_hist_pipe VIR_MAP 0x040e80000 HQM_OS_W cfg_ldb_cq_int_enb RW
 , 16'h0E00 //132 hqm_credit_hist_pipe VIR_MAP 0x040e00000 HQM_OS_W cfg_ldb_cq_int_depth_thrsh RW
 , 16'h0D80 //131 hqm_credit_hist_pipe VIR_MAP 0x040d80000 HQM_OS_W cfg_ldb_cq_depth RW/V
 , 16'h0D00 //130 hqm_credit_hist_pipe VIR_MAP 0x040d00000 HQM_OS_W cfg_ldb_cq_irq_pending RO
 , 16'h0C80 //129 hqm_credit_hist_pipe VIR_MAP 0x040c80000 HQM_OS_W cfg_ldb_cq_int_mask RW
 , 16'h0C00 //128 hqm_credit_hist_pipe VIR_MAP 0x040c00000 HQM_OS_W cfg_hist_list_a_push_ptr RW/V
 , 16'h0B80 //127 hqm_credit_hist_pipe VIR_MAP 0x040b80000 HQM_OS_W cfg_hist_list_a_pop_ptr RW/V
 , 16'h0B00 //126 hqm_credit_hist_pipe VIR_MAP 0x040b00000 HQM_OS_W cfg_hist_list_a_limit RW
 , 16'h0A80 //125 hqm_credit_hist_pipe VIR_MAP 0x040a80000 HQM_OS_W cfg_hist_list_a_base RW
 , 16'h0A00 //124 hqm_credit_hist_pipe VIR_MAP 0x040a00000 HQM_OS_W cfg_hist_list_push_ptr RW/V
 , 16'h0980 //123 hqm_credit_hist_pipe VIR_MAP 0x040980000 HQM_OS_W cfg_hist_list_pop_ptr RW/V
 , 16'h0900 //122 hqm_credit_hist_pipe VIR_MAP 0x040900000 HQM_OS_W cfg_hist_list_limit RW
 , 16'h0880 //121 hqm_credit_hist_pipe VIR_MAP 0x040880000 HQM_OS_W cfg_hist_list_base RW
 , 16'h0800 //120 hqm_credit_hist_pipe VIR_MAP 0x040800000 HQM_OS_W cfg_hist_list_mode RW
 , 16'h0780 //119 hqm_credit_hist_pipe VIR_MAP 0x040780000 HQM_OS_W cfg_ldb_cq_on_off_threshold RW
 , 16'h0700 //118 hqm_credit_hist_pipe VIR_MAP 0x040700000 HQM_OS_W cfg_dir_cq2vas RW
 , 16'h0680 //117 hqm_credit_hist_pipe VIR_MAP 0x040680000 HQM_OS_W cfg_dir_cq_wptr RW/V
 , 16'h0600 //116 hqm_credit_hist_pipe VIR_MAP 0x040600000 HQM_OS_W cfg_dir_cq_wd_enb RW
 , 16'h0580 //115 hqm_credit_hist_pipe VIR_MAP 0x040580000 HQM_OS_W cfg_dir_cq_token_depth_select RW
 , 16'h0500 //114 hqm_credit_hist_pipe VIR_MAP 0x040500000 HQM_OS_W cfg_dir_cq_timer_threshold RW
 , 16'h0480 //113 hqm_credit_hist_pipe VIR_MAP 0x040480000 HQM_OS_W cfg_dir_cq_timer_count RO/V
 , 16'h0400 //112 hqm_credit_hist_pipe VIR_MAP 0x040400000 HQM_OS_W cfg_dir_cq_int_enb RW
 , 16'h0380 //111 hqm_credit_hist_pipe VIR_MAP 0x040380000 HQM_OS_W cfg_dir_cq_int_depth_thrsh RW
 , 16'h0300 //110 hqm_credit_hist_pipe VIR_MAP 0x040300000 HQM_OS_W cfg_dir_cq_depth RW/V
 , 16'h0280 //109 hqm_credit_hist_pipe VIR_MAP 0x040280000 HQM_OS_W cfg_dir_cq_irq_pending RO
 , 16'h0200 //108 hqm_credit_hist_pipe VIR_MAP 0x040200000 HQM_OS_W cfg_dir_cq_int_mask RW
 , 16'h0180 //107 hqm_credit_hist_pipe VIR_MAP 0x040180000 HQM_OS_W cfg_cmp_sn_chk_enbl RW
 , 16'h0100 //106 hqm_credit_hist_pipe VIR_MAP 0x040100000 HQM_OS_W cfg_ord_qid_sn_map RW
 , 16'h0080 //105 hqm_credit_hist_pipe VIR_MAP 0x040080000 HQM_OS_W cfg_ord_qid_sn RW/V
 , 16'h0000 //104 hqm_credit_hist_pipe VIR_MAP 0x040000000 HQM_OS_W cfg_vas_credit_count RW/V
 , 16'h4040 //103 hqm_credit_hist_pipe REG_MAP 0x044000100 HQM_OS_W cfg_unit_version RO
 , 16'h403F //102 hqm_credit_hist_pipe REG_MAP 0x0440000fc HQM_OS_W cfg_syndrome_00 RW/1C/V
 , 16'h403E //101 hqm_credit_hist_pipe REG_MAP 0x0440000f8 HQM_OS_W cfg_retn_zero RO
 , 16'h403D //100 hqm_credit_hist_pipe REG_MAP 0x0440000f4 HQM_OS_W cfg_ldb_wd_threshold RW
 , 16'h403C //99 hqm_credit_hist_pipe REG_MAP 0x0440000f0 HQM_OS_W cfg_ldb_wd_irq1 RO/V
 , 16'h403B //98 hqm_credit_hist_pipe REG_MAP 0x0440000ec HQM_OS_W cfg_ldb_wd_irq0 RO/V
 , 16'h403A //97 hqm_credit_hist_pipe REG_MAP 0x0440000e8 HQM_OS_W cfg_ldb_wd_enb_interval RW
 , 16'h4039 //96 hqm_credit_hist_pipe REG_MAP 0x0440000e4 HQM_OS_W cfg_ldb_wd_disable1 RW/1C/V
 , 16'h4038 //95 hqm_credit_hist_pipe REG_MAP 0x0440000e0 HQM_OS_W cfg_ldb_wd_disable0 RW/1C/V
 , 16'h4037 //94 hqm_credit_hist_pipe REG_MAP 0x0440000dc HQM_OS_W cfg_ldb_wdrt_1 RO/V
 , 16'h4036 //93 hqm_credit_hist_pipe REG_MAP 0x0440000d8 HQM_OS_W cfg_ldb_wdrt_0 RO/V
 , 16'h4035 //92 hqm_credit_hist_pipe REG_MAP 0x0440000d4 HQM_OS_W cfg_ldb_wdto_1 RW/1C/V
 , 16'h4034 //91 hqm_credit_hist_pipe REG_MAP 0x0440000d0 HQM_OS_W cfg_ldb_wdto_0 RW/1C/V
 , 16'h4033 //90 hqm_credit_hist_pipe REG_MAP 0x0440000cc HQM_OS_W cfg_ldb_cq_timer_ctl RW
 , 16'h4032 //89 hqm_credit_hist_pipe REG_MAP 0x0440000c8 HQM_OS_W cfg_ldb_cq_intr_urgent1 RO/V
 , 16'h4031 //88 hqm_credit_hist_pipe REG_MAP 0x0440000c4 HQM_OS_W cfg_ldb_cq_intr_urgent0 RO/V
 , 16'h4030 //87 hqm_credit_hist_pipe REG_MAP 0x0440000c0 HQM_OS_W cfg_ldb_cq_intr_run_timer1 RO/V
 , 16'h402F //86 hqm_credit_hist_pipe REG_MAP 0x0440000bc HQM_OS_W cfg_ldb_cq_intr_run_timer0 RO/V
 , 16'h402E //85 hqm_credit_hist_pipe REG_MAP 0x0440000b8 HQM_OS_W cfg_ldb_cq_intr_irq1 RO/V
 , 16'h402D //84 hqm_credit_hist_pipe REG_MAP 0x0440000b4 HQM_OS_W cfg_ldb_cq_intr_irq0 RO/V
 , 16'h402C //83 hqm_credit_hist_pipe REG_MAP 0x0440000b0 HQM_OS_W cfg_ldb_cq_intr_expired1 RO/V
 , 16'h402B //82 hqm_credit_hist_pipe REG_MAP 0x0440000ac HQM_OS_W cfg_ldb_cq_intr_expired0 RO/V
 , 16'h402A //81 hqm_credit_hist_pipe REG_MAP 0x0440000a8 HQM_OS_W cfg_ldb_cq_intr_armed1 RW/1S/V
 , 16'h4029 //80 hqm_credit_hist_pipe REG_MAP 0x0440000a4 HQM_OS_W cfg_ldb_cq_intr_armed0 RW/1S/V
 , 16'h4028 //79 hqm_credit_hist_pipe REG_MAP 0x0440000a0 HQM_OS_W cfg_dir_wd_threshold RW
 , 16'h4027 //78 hqm_credit_hist_pipe REG_MAP 0x04400009c HQM_OS_W cfg_dir_wd_irq1 RO/V
 , 16'h4026 //77 hqm_credit_hist_pipe REG_MAP 0x044000098 HQM_OS_W cfg_dir_wd_irq0 RO/V
 , 16'h4025 //76 hqm_credit_hist_pipe REG_MAP 0x044000094 HQM_OS_W cfg_dir_wd_enb_interval RW
 , 16'h4024 //75 hqm_credit_hist_pipe REG_MAP 0x044000090 HQM_OS_W cfg_dir_wd_disable1 RW/1C/V
 , 16'h4023 //74 hqm_credit_hist_pipe REG_MAP 0x04400008c HQM_OS_W cfg_dir_wd_disable0 RW/1C/V
 , 16'h4022 //73 hqm_credit_hist_pipe REG_MAP 0x044000088 HQM_OS_W cfg_dir_wdrt_1 RO/V
 , 16'h4021 //72 hqm_credit_hist_pipe REG_MAP 0x044000084 HQM_OS_W cfg_dir_wdrt_0 RO/V
 , 16'h4020 //71 hqm_credit_hist_pipe REG_MAP 0x044000080 HQM_OS_W cfg_dir_wdto_1 RW/1C/V
 , 16'h401F //70 hqm_credit_hist_pipe REG_MAP 0x04400007c HQM_OS_W cfg_dir_wdto_0 RW/1C/V
 , 16'h401E //69 hqm_credit_hist_pipe REG_MAP 0x044000078 HQM_OS_W cfg_dir_cq_timer_ctl RW
 , 16'h401D //68 hqm_credit_hist_pipe REG_MAP 0x044000074 HQM_OS_W cfg_dir_cq_intr_urgent1 RO/V
 , 16'h401C //67 hqm_credit_hist_pipe REG_MAP 0x044000070 HQM_OS_W cfg_dir_cq_intr_urgent0 RO/V
 , 16'h401B //66 hqm_credit_hist_pipe REG_MAP 0x04400006c HQM_OS_W cfg_dir_cq_intr_run_timer1 RO/V
 , 16'h401A //65 hqm_credit_hist_pipe REG_MAP 0x044000068 HQM_OS_W cfg_dir_cq_intr_run_timer0 RO/V
 , 16'h4019 //64 hqm_credit_hist_pipe REG_MAP 0x044000064 HQM_OS_W cfg_dir_cq_intr_irq1 RO/V
 , 16'h4018 //63 hqm_credit_hist_pipe REG_MAP 0x044000060 HQM_OS_W cfg_dir_cq_intr_irq0 RO/V
 , 16'h4017 //62 hqm_credit_hist_pipe REG_MAP 0x04400005c HQM_OS_W cfg_dir_cq_intr_expired1 RO/V
 , 16'h4016 //61 hqm_credit_hist_pipe REG_MAP 0x044000058 HQM_OS_W cfg_dir_cq_intr_expired0 RO/V
 , 16'h4015 //60 hqm_credit_hist_pipe REG_MAP 0x044000054 HQM_OS_W cfg_dir_cq_intr_armed1 RW/1S/V
 , 16'h4014 //59 hqm_credit_hist_pipe REG_MAP 0x044000050 HQM_OS_W cfg_dir_cq_intr_armed0 RW/1S/V
 , 16'h4013 //58 hqm_credit_hist_pipe REG_MAP 0x04400004c HQM_OS_W cfg_chp_cnt_atq_to_atm_h RO/V
 , 16'h4012 //57 hqm_credit_hist_pipe REG_MAP 0x044000048 HQM_OS_W cfg_chp_cnt_atq_to_atm_l RO/V
 , 16'h4011 //56 hqm_credit_hist_pipe REG_MAP 0x044000044 HQM_OS_W cfg_chp_cnt_atm_qe_sch_h RO/V
 , 16'h4010 //55 hqm_credit_hist_pipe REG_MAP 0x044000040 HQM_OS_W cfg_chp_cnt_atm_qe_sch_l RO/V
 , 16'h400F //54 hqm_credit_hist_pipe REG_MAP 0x04400003c HQM_OS_W cfg_chp_cnt_ldb_qe_sch_h RO/V
 , 16'h400E //53 hqm_credit_hist_pipe REG_MAP 0x044000038 HQM_OS_W cfg_chp_cnt_ldb_qe_sch_l RO/V
 , 16'h400D //52 hqm_credit_hist_pipe REG_MAP 0x044000034 HQM_OS_W cfg_chp_cnt_dir_qe_sch_h RO/V
 , 16'h400C //51 hqm_credit_hist_pipe REG_MAP 0x044000030 HQM_OS_W cfg_chp_cnt_dir_qe_sch_l RO/V
 , 16'h400B //50 hqm_credit_hist_pipe REG_MAP 0x04400002c HQM_OS_W cfg_chp_cnt_frag_replayed_h RO/V
 , 16'h400A //49 hqm_credit_hist_pipe REG_MAP 0x044000028 HQM_OS_W cfg_chp_cnt_frag_replayed_l RO/V
 , 16'h4009 //48 hqm_credit_hist_pipe REG_MAP 0x044000024 HQM_OS_W cfg_chp_cnt_ldb_hcw_enq_h RO/V
 , 16'h4008 //47 hqm_credit_hist_pipe REG_MAP 0x044000020 HQM_OS_W cfg_chp_cnt_ldb_hcw_enq_l RO/V
 , 16'h4007 //46 hqm_credit_hist_pipe REG_MAP 0x04400001c HQM_OS_W cfg_chp_cnt_dir_hcw_enq_h RO/V
 , 16'h4006 //45 hqm_credit_hist_pipe REG_MAP 0x044000018 HQM_OS_W cfg_chp_cnt_dir_hcw_enq_l RO/V
 , 16'h4005 //44 hqm_credit_hist_pipe REG_MAP 0x044000014 HQM_OS_W cfg_counter_chp_error_drop_h RO/V
 , 16'h4004 //43 hqm_credit_hist_pipe REG_MAP 0x044000010 HQM_OS_W cfg_counter_chp_error_drop_l RO/V
 , 16'h4003 //42 hqm_credit_hist_pipe REG_MAP 0x04400000c HQM_OS_W cfg_chp_csr_control RW
 , 16'h4002 //41 hqm_credit_hist_pipe REG_MAP 0x044000008 HQM_OS_W cfg_chp_palb_control RW
 , 16'h4001 //40 hqm_credit_hist_pipe REG_MAP 0x044000004 HQM_OS_W cfg_chp_correctible_count_h RO/V
 , 16'h4000 //39 hqm_credit_hist_pipe REG_MAP 0x044000000 HQM_OS_W cfg_chp_correctible_count_l RO/V
 , 16'hC01A //38 hqm_credit_hist_pipe REG_MAP 0x04c000068 HQM_FEATURE_W cfg_patch_control RW
 , 16'hC019 //37 hqm_credit_hist_pipe REG_MAP 0x04c000064 HQM_FEATURE_W cfg_unit_timeout RW
 , 16'hC018 //36 hqm_credit_hist_pipe REG_MAP 0x04c000060 HQM_FEATURE_W cfg_unit_idle RO/V
 , 16'hC017 //35 hqm_credit_hist_pipe REG_MAP 0x04c00005c HQM_FEATURE_W cfg_syndrome_01 RW/1C/V
 , 16'hC016 //34 hqm_credit_hist_pipe REG_MAP 0x04c000058 HQM_FEATURE_W cfg_pipe_health_valid RO/V
 , 16'hC015 //33 hqm_credit_hist_pipe REG_MAP 0x04c000054 HQM_FEATURE_W cfg_pipe_health_hold RO/V
 , 16'hC014 //32 hqm_credit_hist_pipe REG_MAP 0x04c000050 HQM_FEATURE_W cfg_hw_agitate_select RW
 , 16'hC013 //31 hqm_credit_hist_pipe REG_MAP 0x04c00004c HQM_FEATURE_W cfg_hw_agitate_control RW
 , 16'hC012 //30 hqm_credit_hist_pipe REG_MAP 0x04c000048 HQM_FEATURE_W cfg_diagnostic_aw_status_0 RO/V
 , 16'hC011 //29 hqm_credit_hist_pipe REG_MAP 0x04c000044 HQM_FEATURE_W cfg_db_fifo_status_3 RO/V
 , 16'hC010 //28 hqm_credit_hist_pipe REG_MAP 0x04c000040 HQM_FEATURE_W cfg_db_fifo_status_2 RO/V
 , 16'hC00F //27 hqm_credit_hist_pipe REG_MAP 0x04c00003c HQM_FEATURE_W cfg_db_fifo_status_1 RO/V
 , 16'hC00E //26 hqm_credit_hist_pipe REG_MAP 0x04c000038 HQM_FEATURE_W cfg_db_fifo_status_0 RO/V
 , 16'hC00D //25 hqm_credit_hist_pipe REG_MAP 0x04c000034 HQM_FEATURE_W cfg_control_general_02 RW
 , 16'hC00C //24 hqm_credit_hist_pipe REG_MAP 0x04c000030 HQM_FEATURE_W cfg_control_general_01 RW
 , 16'hC00B //23 hqm_credit_hist_pipe REG_MAP 0x04c00002c HQM_FEATURE_W cfg_control_general_00 RW
 , 16'hC00A //22 hqm_credit_hist_pipe REG_MAP 0x04c000028 HQM_FEATURE_W cfg_control_diagnostic_02 RO/V
 , 16'hC009 //21 hqm_credit_hist_pipe REG_MAP 0x04c000024 HQM_FEATURE_W cfg_control_diagnostic_01 RO/V
 , 16'hC008 //20 hqm_credit_hist_pipe REG_MAP 0x04c000020 HQM_FEATURE_W cfg_control_diagnostic_00 RO/V
 , 16'hC007 //19 hqm_credit_hist_pipe REG_MAP 0x04c00001c HQM_FEATURE_W cfg_chp_smon_timer RW/V
 , 16'hC006 //18 hqm_credit_hist_pipe REG_MAP 0x04c000018 HQM_FEATURE_W cfg_chp_smon_maximum_timer RW/V
 , 16'hC005 //17 hqm_credit_hist_pipe REG_MAP 0x04c000014 HQM_FEATURE_W cfg_chp_smon_activitycounter1 RW/V
 , 16'hC004 //16 hqm_credit_hist_pipe REG_MAP 0x04c000010 HQM_FEATURE_W cfg_chp_smon_activitycounter0 RW/V
 , 16'hC003 //15 hqm_credit_hist_pipe REG_MAP 0x04c00000c HQM_FEATURE_W cfg_chp_smon_configuration1 RW
 , 16'hC002 //14 hqm_credit_hist_pipe REG_MAP 0x04c000008 HQM_FEATURE_W cfg_chp_smon_configuration0 RW
 , 16'hC001 //13 hqm_credit_hist_pipe REG_MAP 0x04c000004 HQM_FEATURE_W cfg_chp_smon_compare1 RW/V
 , 16'hC000 //12 hqm_credit_hist_pipe REG_MAP 0x04c000000 HQM_FEATURE_W cfg_chp_smon_compare0 RW/V
 , 16'hE0C0 //11 hqm_credit_hist_pipe MEM_MAP 0x04e0c0000 HQM_FEATURE_W cfg_freelist_7 RO/V
 , 16'hE0B0 //10 hqm_credit_hist_pipe MEM_MAP 0x04e0b0000 HQM_FEATURE_W cfg_freelist_6 RO/V
 , 16'hE0A0 //9 hqm_credit_hist_pipe MEM_MAP 0x04e0a0000 HQM_FEATURE_W cfg_freelist_5 RO/V
 , 16'hE090 //8 hqm_credit_hist_pipe MEM_MAP 0x04e090000 HQM_FEATURE_W cfg_freelist_4 RO/V
 , 16'hE080 //7 hqm_credit_hist_pipe MEM_MAP 0x04e080000 HQM_FEATURE_W cfg_freelist_3 RO/V
 , 16'hE070 //6 hqm_credit_hist_pipe MEM_MAP 0x04e070000 HQM_FEATURE_W cfg_freelist_2 RO/V
 , 16'hE060 //5 hqm_credit_hist_pipe MEM_MAP 0x04e060000 HQM_FEATURE_W cfg_freelist_1 RO/V
 , 16'hE050 //4 hqm_credit_hist_pipe MEM_MAP 0x04e050000 HQM_FEATURE_W cfg_freelist_0 RO/V
 , 16'hE040 //3 hqm_credit_hist_pipe MEM_MAP 0x04e040000 HQM_FEATURE_W cfg_hist_list_a_1 RO/V
 , 16'hE030 //2 hqm_credit_hist_pipe MEM_MAP 0x04e030000 HQM_FEATURE_W cfg_hist_list_a_0 RO/V
 , 16'hE020 //1 hqm_credit_hist_pipe MEM_MAP 0x04e020000 HQM_FEATURE_W cfg_hist_list_1 RO/V
 , 16'hE010 //0 hqm_credit_hist_pipe MEM_MAP 0x04e010000 HQM_FEATURE_W cfg_hist_list_0 RO/V
 }; 
 
parameter HQM_DP_TARGET_CFG_UNIT_VERSION = 38 ; 
parameter HQM_DP_TARGET_CFG_DIR_CSR_CONTROL = 37 ; 
parameter HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 = 36 ; 
parameter HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 = 35 ; 
parameter HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1 = 34 ; 
parameter HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 = 33 ; 
parameter HQM_DP_TARGET_CFG_PATCH_CONTROL = 32 ; 
parameter HQM_DP_TARGET_CFG_UNIT_TIMEOUT = 31 ; 
parameter HQM_DP_TARGET_CFG_UNIT_IDLE = 30 ; 
parameter HQM_DP_TARGET_CFG_SYNDROME_01 = 29 ; 
parameter HQM_DP_TARGET_CFG_SYNDROME_00 = 28 ; 
parameter HQM_DP_TARGET_CFG_SMON_TIMER = 27 ; 
parameter HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER = 26 ; 
parameter HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 = 25 ; 
parameter HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 = 24 ; 
parameter HQM_DP_TARGET_CFG_SMON_COMPARE1 = 23 ; 
parameter HQM_DP_TARGET_CFG_SMON_COMPARE0 = 22 ; 
parameter HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 = 21 ; 
parameter HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 = 20 ; 
parameter HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00 = 19 ; 
parameter HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00 = 18 ; 
parameter HQM_DP_TARGET_CFG_INTERFACE_STATUS = 17 ; 
parameter HQM_DP_TARGET_CFG_HW_AGITATE_SELECT = 16 ; 
parameter HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL = 15 ; 
parameter HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF = 14 ; 
parameter HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF = 13 ; 
parameter HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF = 12 ; 
parameter HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF = 11 ; 
parameter HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF = 10 ; 
parameter HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF = 9 ; 
parameter HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF = 8 ; 
parameter HQM_DP_TARGET_CFG_ERROR_INJECT = 7 ; 
parameter HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 = 6 ; 
parameter HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 = 5 ; 
parameter HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS = 4 ; 
parameter HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 = 3 ; 
parameter HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 = 2 ; 
parameter HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS = 1 ; 
parameter HQM_DP_TARGET_CFG_CONTROL_GENERAL = 0 ; 
 
parameter HQM_DP_CFG_UNIT_TGT_MAP = {
   16'h4005 //38 hqm_direct_pipe REG_MAP 0x054000014 HQM_OS_W cfg_unit_version RO
 , 16'h4004 //37 hqm_direct_pipe REG_MAP 0x054000010 HQM_OS_W cfg_dir_csr_control RW
 , 16'h4003 //36 hqm_direct_pipe REG_MAP 0x05400000c HQM_OS_W cfg_control_arb_weights_tqpri_replay_1 RO/V
 , 16'h4002 //35 hqm_direct_pipe REG_MAP 0x054000008 HQM_OS_W cfg_control_arb_weights_tqpri_replay_0 RW
 , 16'h4001 //34 hqm_direct_pipe REG_MAP 0x054000004 HQM_OS_W cfg_control_arb_weights_tqpri_dir_1 RO/V
 , 16'h4000 //33 hqm_direct_pipe REG_MAP 0x054000000 HQM_OS_W cfg_control_arb_weights_tqpri_dir_0 RW
 , 16'hC020 //32 hqm_direct_pipe REG_MAP 0x05c000080 HQM_FEATURE_W cfg_patch_control RW
 , 16'hC01F //31 hqm_direct_pipe REG_MAP 0x05c00007c HQM_FEATURE_W cfg_unit_timeout RW
 , 16'hC01E //30 hqm_direct_pipe REG_MAP 0x05c000078 HQM_FEATURE_W cfg_unit_idle RO/V
 , 16'hC01D //29 hqm_direct_pipe REG_MAP 0x05c000074 HQM_FEATURE_W cfg_syndrome_01 RW/1C/V
 , 16'hC01C //28 hqm_direct_pipe REG_MAP 0x05c000070 HQM_FEATURE_W cfg_syndrome_00 RW/1C/V
 , 16'hC01B //27 hqm_direct_pipe REG_MAP 0x05c00006c HQM_FEATURE_W cfg_smon_timer RW/V
 , 16'hC01A //26 hqm_direct_pipe REG_MAP 0x05c000068 HQM_FEATURE_W cfg_smon_maximum_timer RW/V
 , 16'hC019 //25 hqm_direct_pipe REG_MAP 0x05c000064 HQM_FEATURE_W cfg_smon_configuration1 RW
 , 16'hC018 //24 hqm_direct_pipe REG_MAP 0x05c000060 HQM_FEATURE_W cfg_smon_configuration0 RW
 , 16'hC017 //23 hqm_direct_pipe REG_MAP 0x05c00005c HQM_FEATURE_W cfg_smon_compare1 RW/V
 , 16'hC016 //22 hqm_direct_pipe REG_MAP 0x05c000058 HQM_FEATURE_W cfg_smon_compare0 RW/V
 , 16'hC015 //21 hqm_direct_pipe REG_MAP 0x05c000054 HQM_FEATURE_W cfg_smon_activitycounter1 RW/V
 , 16'hC014 //20 hqm_direct_pipe REG_MAP 0x05c000050 HQM_FEATURE_W cfg_smon_activitycounter0 RW/V
 , 16'hC013 //19 hqm_direct_pipe REG_MAP 0x05c00004c HQM_FEATURE_W cfg_pipe_health_valid_00 RO/V
 , 16'hC012 //18 hqm_direct_pipe REG_MAP 0x05c000048 HQM_FEATURE_W cfg_pipe_health_hold_00 RO/V
 , 16'hC011 //17 hqm_direct_pipe REG_MAP 0x05c000044 HQM_FEATURE_W cfg_interface_status RO/V
 , 16'hC010 //16 hqm_direct_pipe REG_MAP 0x05c000040 HQM_FEATURE_W cfg_hw_agitate_select RW
 , 16'hC00F //15 hqm_direct_pipe REG_MAP 0x05c00003c HQM_FEATURE_W cfg_hw_agitate_control RW
 , 16'hC00E //14 hqm_direct_pipe REG_MAP 0x05c000038 HQM_FEATURE_W cfg_fifo_wmstat_rop_dp_enq_ro_if RW/V
 , 16'hC00D //13 hqm_direct_pipe REG_MAP 0x05c000034 HQM_FEATURE_W cfg_fifo_wmstat_rop_dp_enq_dir_if RW/V
 , 16'hC00C //12 hqm_direct_pipe REG_MAP 0x05c000030 HQM_FEATURE_W cfg_fifo_wmstat_lsp_dp_sch_rorply_if RW/V
 , 16'hC00B //11 hqm_direct_pipe REG_MAP 0x05c00002c HQM_FEATURE_W cfg_fifo_wmstat_lsp_dp_sch_dir_if RW/V
 , 16'hC00A //10 hqm_direct_pipe REG_MAP 0x05c000028 HQM_FEATURE_W cfg_fifo_wmstat_dp_lsp_enq_rorply_if RW/V
 , 16'hC009 //9 hqm_direct_pipe REG_MAP 0x05c000024 HQM_FEATURE_W cfg_fifo_wmstat_dp_lsp_enq_dir_if RW/V
 , 16'hC008 //8 hqm_direct_pipe REG_MAP 0x05c000020 HQM_FEATURE_W cfg_fifo_wmstat_dp_dqed_if RW/V
 , 16'hC007 //7 hqm_direct_pipe REG_MAP 0x05c00001c HQM_FEATURE_W cfg_error_inject RW
 , 16'hC006 //6 hqm_direct_pipe REG_MAP 0x05c000018 HQM_FEATURE_W cfg_diagnostic_aw_status_02 RO/V
 , 16'hC005 //5 hqm_direct_pipe REG_MAP 0x05c000014 HQM_FEATURE_W cfg_diagnostic_aw_status_01 RO/V
 , 16'hC004 //4 hqm_direct_pipe REG_MAP 0x05c000010 HQM_FEATURE_W cfg_diagnostic_aw_status RO/V
 , 16'hC003 //3 hqm_direct_pipe REG_MAP 0x05c00000c HQM_FEATURE_W cfg_detect_feature_operation_01 RW/V
 , 16'hC002 //2 hqm_direct_pipe REG_MAP 0x05c000008 HQM_FEATURE_W cfg_detect_feature_operation_00 RW/V
 , 16'hC001 //1 hqm_direct_pipe REG_MAP 0x05c000004 HQM_FEATURE_W cfg_control_pipeline_credits RW
 , 16'hC000 //0 hqm_direct_pipe REG_MAP 0x05c000000 HQM_FEATURE_W cfg_control_general RW
 }; 
 
parameter HQM_LSP_TARGET_CFG_QID_ATM_ACTIVE = 196 ; 
parameter HQM_LSP_TARGET_CFG_NALB_QID_DPTH_THRSH = 195 ; 
parameter HQM_LSP_TARGET_CFG_ATM_QID_DPTH_THRSH = 194 ; 
parameter HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTH = 193 ; 
parameter HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTL = 192 ; 
parameter HQM_LSP_TARGET_CFG_QID_NALDB_MAX_DEPTH = 191 ; 
parameter HQM_LSP_TARGET_CFG_QID_DIR_REPLAY_COUNT = 190 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_REPLAY_COUNT = 189 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_15 = 188 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_14 = 187 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_13 = 186 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_12 = 185 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_11 = 184 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_10 = 183 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_09 = 182 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_08 = 181 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_07 = 180 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_06 = 179 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_05 = 178 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_04 = 177 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_03 = 176 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_02 = 175 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_01 = 174 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_00 = 173 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 = 172 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 = 171 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 = 170 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 = 169 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 = 168 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 = 167 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 = 166 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 = 165 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 = 164 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 = 163 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 = 162 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 = 161 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 = 160 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 = 159 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 = 158 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 = 157 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_LIMIT = 156 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_COUNT = 155 ; 
parameter HQM_LSP_TARGET_CFG_QID_LDB_ENQUEUE_COUNT = 154 ; 
parameter HQM_LSP_TARGET_CFG_QID_ATQ_ENQUEUE_COUNT = 153 ; 
parameter HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTH = 152 ; 
parameter HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTL = 151 ; 
parameter HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_LIMIT = 150 ; 
parameter HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_COUNT = 149 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_WU_LIMIT = 148 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_WU_COUNT = 147 ; 
parameter HQM_LSP_TARGET_CFG_DIR_QID_DPTH_THRSH = 146 ; 
parameter HQM_LSP_TARGET_CFG_QID_DIR_ENQUEUE_COUNT = 145 ; 
parameter HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTH = 144 ; 
parameter HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTL = 143 ; 
parameter HQM_LSP_TARGET_CFG_QID_DIR_MAX_DEPTH = 142 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTH = 141 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTL = 140 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_DEPTH_SELECT = 139 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_COUNT = 138 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_THRESHOLD = 137 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_LIMIT = 136 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_COUNT = 135 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_DISABLE = 134 ; 
parameter HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTH = 133 ; 
parameter HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTL = 132 ; 
parameter HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI = 131 ; 
parameter HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_COUNT = 130 ; 
parameter HQM_LSP_TARGET_CFG_CQ_DIR_DISABLE = 129 ; 
parameter HQM_LSP_TARGET_CFG_CQ2QID1 = 128 ; 
parameter HQM_LSP_TARGET_CFG_CQ2QID0 = 127 ; 
parameter HQM_LSP_TARGET_CFG_CQ2PRIOV = 126 ; 
parameter HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT = 125 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H = 124 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L = 123 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H = 122 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L = 121 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H = 120 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L = 119 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H = 118 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L = 117 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H = 116 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L = 115 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H = 114 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L = 113 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H = 112 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L = 111 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H = 110 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L = 109 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL = 108 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_H = 107 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_L = 106 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_H = 105 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_L = 104 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_H = 103 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_L = 102 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_H = 101 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_L = 100 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_H = 99 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_L = 98 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_H = 97 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_L = 96 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_H = 95 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_L = 94 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_H = 93 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_L = 92 ; 
parameter HQM_LSP_TARGET_CFG_CNT_WIN_COS3_H = 91 ; 
parameter HQM_LSP_TARGET_CFG_CNT_WIN_COS3_L = 90 ; 
parameter HQM_LSP_TARGET_CFG_CNT_WIN_COS2_H = 89 ; 
parameter HQM_LSP_TARGET_CFG_CNT_WIN_COS2_L = 88 ; 
parameter HQM_LSP_TARGET_CFG_CNT_WIN_COS1_H = 87 ; 
parameter HQM_LSP_TARGET_CFG_CNT_WIN_COS1_L = 86 ; 
parameter HQM_LSP_TARGET_CFG_CNT_WIN_COS0_H = 85 ; 
parameter HQM_LSP_TARGET_CFG_CNT_WIN_COS0_L = 84 ; 
parameter HQM_LSP_TARGET_CFG_RND_LOSS_COS3_H = 83 ; 
parameter HQM_LSP_TARGET_CFG_RND_LOSS_COS3_L = 82 ; 
parameter HQM_LSP_TARGET_CFG_RND_LOSS_COS2_H = 81 ; 
parameter HQM_LSP_TARGET_CFG_RND_LOSS_COS2_L = 80 ; 
parameter HQM_LSP_TARGET_CFG_RND_LOSS_COS1_H = 79 ; 
parameter HQM_LSP_TARGET_CFG_RND_LOSS_COS1_L = 78 ; 
parameter HQM_LSP_TARGET_CFG_RND_LOSS_COS0_H = 77 ; 
parameter HQM_LSP_TARGET_CFG_RND_LOSS_COS0_L = 76 ; 
parameter HQM_LSP_TARGET_CFG_RDY_COS3_H = 75 ; 
parameter HQM_LSP_TARGET_CFG_RDY_COS3_L = 74 ; 
parameter HQM_LSP_TARGET_CFG_RDY_COS2_H = 73 ; 
parameter HQM_LSP_TARGET_CFG_RDY_COS2_L = 72 ; 
parameter HQM_LSP_TARGET_CFG_RDY_COS1_H = 71 ; 
parameter HQM_LSP_TARGET_CFG_RDY_COS1_L = 70 ; 
parameter HQM_LSP_TARGET_CFG_RDY_COS0_H = 69 ; 
parameter HQM_LSP_TARGET_CFG_RDY_COS0_L = 68 ; 
parameter HQM_LSP_TARGET_CFG_SCHD_COS3_H = 67 ; 
parameter HQM_LSP_TARGET_CFG_SCHD_COS3_L = 66 ; 
parameter HQM_LSP_TARGET_CFG_SCHD_COS2_H = 65 ; 
parameter HQM_LSP_TARGET_CFG_SCHD_COS2_L = 64 ; 
parameter HQM_LSP_TARGET_CFG_SCHD_COS1_H = 63 ; 
parameter HQM_LSP_TARGET_CFG_SCHD_COS1_L = 62 ; 
parameter HQM_LSP_TARGET_CFG_SCHD_COS0_H = 61 ; 
parameter HQM_LSP_TARGET_CFG_SCHD_COS0_L = 60 ; 
parameter HQM_LSP_TARGET_CFG_SCH_RDY_H = 59 ; 
parameter HQM_LSP_TARGET_CFG_SCH_RDY_L = 58 ; 
parameter HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 = 57 ; 
parameter HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 = 56 ; 
parameter HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 = 55 ; 
parameter HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 = 54 ; 
parameter HQM_LSP_TARGET_CFG_SHDW_CTRL = 53 ; 
parameter HQM_LSP_TARGET_CFG_CREDIT_CNT_COS3 = 52 ; 
parameter HQM_LSP_TARGET_CFG_CREDIT_CNT_COS2 = 51 ; 
parameter HQM_LSP_TARGET_CFG_CREDIT_CNT_COS1 = 50 ; 
parameter HQM_LSP_TARGET_CFG_CREDIT_CNT_COS0 = 49 ; 
parameter HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 = 48 ; 
parameter HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 = 47 ; 
parameter HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 = 46 ; 
parameter HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 = 45 ; 
parameter HQM_LSP_TARGET_CFG_COS_CTRL = 44 ; 
parameter HQM_LSP_TARGET_CFG_UNIT_VERSION = 43 ; 
parameter HQM_LSP_TARGET_CFG_SYNDROME_SW = 42 ; 
parameter HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_H = 41 ; 
parameter HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_L = 40 ; 
parameter HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_H = 39 ; 
parameter HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_L = 38 ; 
parameter HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL = 37 ; 
parameter HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL = 36 ; 
parameter HQM_LSP_TARGET_CFG_FID_INFLIGHT_COUNT = 35 ; 
parameter HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT = 34 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT = 33 ; 
parameter HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_COUNT = 32 ; 
parameter HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 = 31 ; 
parameter HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 = 30 ; 
parameter HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 = 29 ; 
parameter HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 = 28 ; 
parameter HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 = 27 ; 
parameter HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT = 26 ; 
parameter HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_COUNT = 25 ; 
parameter HQM_LSP_TARGET_CFG_PATCH_CONTROL = 24 ; 
parameter HQM_LSP_TARGET_CFG_UNIT_TIMEOUT = 23 ; 
parameter HQM_LSP_TARGET_CFG_UNIT_IDLE = 22 ; 
parameter HQM_LSP_TARGET_CFG_SYNDROME_HW = 21 ; 
parameter HQM_LSP_TARGET_CFG_SMON0_TIMER = 20 ; 
parameter HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER = 19 ; 
parameter HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 = 18 ; 
parameter HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 = 17 ; 
parameter HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 = 16 ; 
parameter HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 = 15 ; 
parameter HQM_LSP_TARGET_CFG_SMON0_COMPARE1 = 14 ; 
parameter HQM_LSP_TARGET_CFG_SMON0_COMPARE0 = 13 ; 
parameter HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_01 = 12 ; 
parameter HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_00 = 11 ; 
parameter HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_01 = 10 ; 
parameter HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_00 = 9 ; 
parameter HQM_LSP_TARGET_CFG_INTERFACE_STATUS = 8 ; 
parameter HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT = 7 ; 
parameter HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL = 6 ; 
parameter HQM_LSP_TARGET_CFG_ERROR_INJECT = 5 ; 
parameter HQM_LSP_TARGET_CFG_DIAGNOSTIC_STATUS_0 = 4 ; 
parameter HQM_LSP_TARGET_CFG_DIAGNOSTIC_AW_STATUS = 3 ; 
parameter HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS = 2 ; 
parameter HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 = 1 ; 
parameter HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 = 0 ; 
 
parameter HQM_LSP_CFG_UNIT_TGT_MAP = {
   16'h2300 //196 hqm_list_sel_pipe VIR_MAP 0x092300000 HQM_OS_W cfg_qid_atm_active RO/V
 , 16'h2280 //195 hqm_list_sel_pipe VIR_MAP 0x092280000 HQM_OS_W cfg_nalb_qid_dpth_thrsh RW
 , 16'h2200 //194 hqm_list_sel_pipe VIR_MAP 0x092200000 HQM_OS_W cfg_atm_qid_dpth_thrsh RW
 , 16'h2180 //193 hqm_list_sel_pipe VIR_MAP 0x092180000 HQM_OS_W cfg_qid_naldb_tot_enq_cnth RW/C
 , 16'h2100 //192 hqm_list_sel_pipe VIR_MAP 0x092100000 HQM_OS_W cfg_qid_naldb_tot_enq_cntl RW/C
 , 16'h2080 //191 hqm_list_sel_pipe VIR_MAP 0x092080000 HQM_OS_W cfg_qid_naldb_max_depth RW/C
 , 16'h2000 //190 hqm_list_sel_pipe VIR_MAP 0x092000000 HQM_OS_W cfg_qid_dir_replay_count RO/V
 , 16'h1F80 //189 hqm_list_sel_pipe VIR_MAP 0x091f80000 HQM_OS_W cfg_qid_ldb_replay_count RO/V
 , 16'h1F00 //188 hqm_list_sel_pipe VIR_MAP 0x091f00000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_15 RW
 , 16'h1E80 //187 hqm_list_sel_pipe VIR_MAP 0x091e80000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_14 RW
 , 16'h1E00 //186 hqm_list_sel_pipe VIR_MAP 0x091e00000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_13 RW
 , 16'h1D80 //185 hqm_list_sel_pipe VIR_MAP 0x091d80000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_12 RW
 , 16'h1D00 //184 hqm_list_sel_pipe VIR_MAP 0x091d00000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_11 RW
 , 16'h1C80 //183 hqm_list_sel_pipe VIR_MAP 0x091c80000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_10 RW
 , 16'h1C00 //182 hqm_list_sel_pipe VIR_MAP 0x091c00000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_09 RW
 , 16'h1B80 //181 hqm_list_sel_pipe VIR_MAP 0x091b80000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_08 RW
 , 16'h1B00 //180 hqm_list_sel_pipe VIR_MAP 0x091b00000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_07 RW
 , 16'h1A80 //179 hqm_list_sel_pipe VIR_MAP 0x091a80000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_06 RW
 , 16'h1A00 //178 hqm_list_sel_pipe VIR_MAP 0x091a00000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_05 RW
 , 16'h1980 //177 hqm_list_sel_pipe VIR_MAP 0x091980000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_04 RW
 , 16'h1900 //176 hqm_list_sel_pipe VIR_MAP 0x091900000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_03 RW
 , 16'h1880 //175 hqm_list_sel_pipe VIR_MAP 0x091880000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_02 RW
 , 16'h1800 //174 hqm_list_sel_pipe VIR_MAP 0x091800000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_01 RW
 , 16'h1780 //173 hqm_list_sel_pipe VIR_MAP 0x091780000 HQM_OS_W cfg_qid_ldb_qid2cqidix2_00 RW
 , 16'h1700 //172 hqm_list_sel_pipe VIR_MAP 0x091700000 HQM_OS_W cfg_qid_ldb_qid2cqidix_15 RW
 , 16'h1680 //171 hqm_list_sel_pipe VIR_MAP 0x091680000 HQM_OS_W cfg_qid_ldb_qid2cqidix_14 RW
 , 16'h1600 //170 hqm_list_sel_pipe VIR_MAP 0x091600000 HQM_OS_W cfg_qid_ldb_qid2cqidix_13 RW
 , 16'h1580 //169 hqm_list_sel_pipe VIR_MAP 0x091580000 HQM_OS_W cfg_qid_ldb_qid2cqidix_12 RW
 , 16'h1500 //168 hqm_list_sel_pipe VIR_MAP 0x091500000 HQM_OS_W cfg_qid_ldb_qid2cqidix_11 RW
 , 16'h1480 //167 hqm_list_sel_pipe VIR_MAP 0x091480000 HQM_OS_W cfg_qid_ldb_qid2cqidix_10 RW
 , 16'h1400 //166 hqm_list_sel_pipe VIR_MAP 0x091400000 HQM_OS_W cfg_qid_ldb_qid2cqidix_09 RW
 , 16'h1380 //165 hqm_list_sel_pipe VIR_MAP 0x091380000 HQM_OS_W cfg_qid_ldb_qid2cqidix_08 RW
 , 16'h1300 //164 hqm_list_sel_pipe VIR_MAP 0x091300000 HQM_OS_W cfg_qid_ldb_qid2cqidix_07 RW
 , 16'h1280 //163 hqm_list_sel_pipe VIR_MAP 0x091280000 HQM_OS_W cfg_qid_ldb_qid2cqidix_06 RW
 , 16'h1200 //162 hqm_list_sel_pipe VIR_MAP 0x091200000 HQM_OS_W cfg_qid_ldb_qid2cqidix_05 RW
 , 16'h1180 //161 hqm_list_sel_pipe VIR_MAP 0x091180000 HQM_OS_W cfg_qid_ldb_qid2cqidix_04 RW
 , 16'h1100 //160 hqm_list_sel_pipe VIR_MAP 0x091100000 HQM_OS_W cfg_qid_ldb_qid2cqidix_03 RW
 , 16'h1080 //159 hqm_list_sel_pipe VIR_MAP 0x091080000 HQM_OS_W cfg_qid_ldb_qid2cqidix_02 RW
 , 16'h1000 //158 hqm_list_sel_pipe VIR_MAP 0x091000000 HQM_OS_W cfg_qid_ldb_qid2cqidix_01 RW
 , 16'h0F80 //157 hqm_list_sel_pipe VIR_MAP 0x090f80000 HQM_OS_W cfg_qid_ldb_qid2cqidix_00 RW
 , 16'h0F00 //156 hqm_list_sel_pipe VIR_MAP 0x090f00000 HQM_OS_W cfg_qid_ldb_inflight_limit RW
 , 16'h0E80 //155 hqm_list_sel_pipe VIR_MAP 0x090e80000 HQM_OS_W cfg_qid_ldb_inflight_count RW/V
 , 16'h0E00 //154 hqm_list_sel_pipe VIR_MAP 0x090e00000 HQM_OS_W cfg_qid_ldb_enqueue_count RO/V
 , 16'h0D80 //153 hqm_list_sel_pipe VIR_MAP 0x090d80000 HQM_OS_W cfg_qid_atq_enqueue_count RO/V
 , 16'h0D00 //152 hqm_list_sel_pipe VIR_MAP 0x090d00000 HQM_OS_W cfg_qid_atm_tot_enq_cnth RW/C
 , 16'h0C80 //151 hqm_list_sel_pipe VIR_MAP 0x090c80000 HQM_OS_W cfg_qid_atm_tot_enq_cntl RW/C
 , 16'h0C00 //150 hqm_list_sel_pipe VIR_MAP 0x090c00000 HQM_OS_W cfg_qid_aqed_active_limit RW
 , 16'h0B80 //149 hqm_list_sel_pipe VIR_MAP 0x090b80000 HQM_OS_W cfg_qid_aqed_active_count RO/V
 , 16'h0B00 //148 hqm_list_sel_pipe VIR_MAP 0x090b00000 HQM_OS_W cfg_cq_ldb_wu_limit RW
 , 16'h0A80 //147 hqm_list_sel_pipe VIR_MAP 0x090a80000 HQM_OS_W cfg_cq_ldb_wu_count RW/V
 , 16'h0A00 //146 hqm_list_sel_pipe VIR_MAP 0x090a00000 HQM_OS_W cfg_dir_qid_dpth_thrsh RW
 , 16'h0980 //145 hqm_list_sel_pipe VIR_MAP 0x090980000 HQM_OS_W cfg_qid_dir_enqueue_count RO/V
 , 16'h0900 //144 hqm_list_sel_pipe VIR_MAP 0x090900000 HQM_OS_W cfg_qid_dir_tot_enq_cnth RW/C
 , 16'h0880 //143 hqm_list_sel_pipe VIR_MAP 0x090880000 HQM_OS_W cfg_qid_dir_tot_enq_cntl RW/C
 , 16'h0800 //142 hqm_list_sel_pipe VIR_MAP 0x090800000 HQM_OS_W cfg_qid_dir_max_depth RW/C
 , 16'h0780 //141 hqm_list_sel_pipe VIR_MAP 0x090780000 HQM_OS_W cfg_cq_ldb_tot_sch_cnth RW/C
 , 16'h0700 //140 hqm_list_sel_pipe VIR_MAP 0x090700000 HQM_OS_W cfg_cq_ldb_tot_sch_cntl RW/C
 , 16'h0680 //139 hqm_list_sel_pipe VIR_MAP 0x090680000 HQM_OS_W cfg_cq_ldb_token_depth_select RW
 , 16'h0600 //138 hqm_list_sel_pipe VIR_MAP 0x090600000 HQM_OS_W cfg_cq_ldb_token_count RW/V
 , 16'h0580 //137 hqm_list_sel_pipe VIR_MAP 0x090580000 HQM_OS_W cfg_cq_ldb_inflight_threshold RW
 , 16'h0500 //136 hqm_list_sel_pipe VIR_MAP 0x090500000 HQM_OS_W cfg_cq_ldb_inflight_limit RW
 , 16'h0480 //135 hqm_list_sel_pipe VIR_MAP 0x090480000 HQM_OS_W cfg_cq_ldb_inflight_count RW/V
 , 16'h0400 //134 hqm_list_sel_pipe VIR_MAP 0x090400000 HQM_OS_W cfg_cq_ldb_disable RW
 , 16'h0380 //133 hqm_list_sel_pipe VIR_MAP 0x090380000 HQM_OS_W cfg_cq_dir_tot_sch_cnth RW/C
 , 16'h0300 //132 hqm_list_sel_pipe VIR_MAP 0x090300000 HQM_OS_W cfg_cq_dir_tot_sch_cntl RW/C
 , 16'h0280 //131 hqm_list_sel_pipe VIR_MAP 0x090280000 HQM_OS_W cfg_cq_dir_token_depth_select_dsi RW
 , 16'h0200 //130 hqm_list_sel_pipe VIR_MAP 0x090200000 HQM_OS_W cfg_cq_dir_token_count RW/V
 , 16'h0180 //129 hqm_list_sel_pipe VIR_MAP 0x090180000 HQM_OS_W cfg_cq_dir_disable RW
 , 16'h0100 //128 hqm_list_sel_pipe VIR_MAP 0x090100000 HQM_OS_W cfg_cq2qid1 RW
 , 16'h0080 //127 hqm_list_sel_pipe VIR_MAP 0x090080000 HQM_OS_W cfg_cq2qid0 RW
 , 16'h0000 //126 hqm_list_sel_pipe VIR_MAP 0x090000000 HQM_OS_W cfg_cq2priov RW
 , 16'h4800 //125 hqm_list_sel_pipe REG_MAP 0x094002000 HQM_OS_W cfg_control_sched_slot_count RW
 , 16'h440F //124 hqm_list_sel_pipe REG_MAP 0x09400103c HQM_OS_W cfg_cq_ldb_sched_slot_count_7_h RO/V
 , 16'h440E //123 hqm_list_sel_pipe REG_MAP 0x094001038 HQM_OS_W cfg_cq_ldb_sched_slot_count_7_l RO/V
 , 16'h440D //122 hqm_list_sel_pipe REG_MAP 0x094001034 HQM_OS_W cfg_cq_ldb_sched_slot_count_6_h RO/V
 , 16'h440C //121 hqm_list_sel_pipe REG_MAP 0x094001030 HQM_OS_W cfg_cq_ldb_sched_slot_count_6_l RO/V
 , 16'h440B //120 hqm_list_sel_pipe REG_MAP 0x09400102c HQM_OS_W cfg_cq_ldb_sched_slot_count_5_h RO/V
 , 16'h440A //119 hqm_list_sel_pipe REG_MAP 0x094001028 HQM_OS_W cfg_cq_ldb_sched_slot_count_5_l RO/V
 , 16'h4409 //118 hqm_list_sel_pipe REG_MAP 0x094001024 HQM_OS_W cfg_cq_ldb_sched_slot_count_4_h RO/V
 , 16'h4408 //117 hqm_list_sel_pipe REG_MAP 0x094001020 HQM_OS_W cfg_cq_ldb_sched_slot_count_4_l RO/V
 , 16'h4407 //116 hqm_list_sel_pipe REG_MAP 0x09400101c HQM_OS_W cfg_cq_ldb_sched_slot_count_3_h RO/V
 , 16'h4406 //115 hqm_list_sel_pipe REG_MAP 0x094001018 HQM_OS_W cfg_cq_ldb_sched_slot_count_3_l RO/V
 , 16'h4405 //114 hqm_list_sel_pipe REG_MAP 0x094001014 HQM_OS_W cfg_cq_ldb_sched_slot_count_2_h RO/V
 , 16'h4404 //113 hqm_list_sel_pipe REG_MAP 0x094001010 HQM_OS_W cfg_cq_ldb_sched_slot_count_2_l RO/V
 , 16'h4403 //112 hqm_list_sel_pipe REG_MAP 0x09400100c HQM_OS_W cfg_cq_ldb_sched_slot_count_1_h RO/V
 , 16'h4402 //111 hqm_list_sel_pipe REG_MAP 0x094001008 HQM_OS_W cfg_cq_ldb_sched_slot_count_1_l RO/V
 , 16'h4401 //110 hqm_list_sel_pipe REG_MAP 0x094001004 HQM_OS_W cfg_cq_ldb_sched_slot_count_0_h RO/V
 , 16'h4400 //109 hqm_list_sel_pipe REG_MAP 0x094001000 HQM_OS_W cfg_cq_ldb_sched_slot_count_0_l RO/V
 , 16'h4053 //108 hqm_list_sel_pipe REG_MAP 0x09400014c HQM_OS_W cfg_ldb_sched_perf_control RW
 , 16'h4052 //107 hqm_list_sel_pipe REG_MAP 0x094000148 HQM_OS_W cfg_ldb_sched_perf_7_h RO/V
 , 16'h4051 //106 hqm_list_sel_pipe REG_MAP 0x094000144 HQM_OS_W cfg_ldb_sched_perf_7_l RO/V
 , 16'h4050 //105 hqm_list_sel_pipe REG_MAP 0x094000140 HQM_OS_W cfg_ldb_sched_perf_6_h RO/V
 , 16'h404F //104 hqm_list_sel_pipe REG_MAP 0x09400013c HQM_OS_W cfg_ldb_sched_perf_6_l RO/V
 , 16'h404E //103 hqm_list_sel_pipe REG_MAP 0x094000138 HQM_OS_W cfg_ldb_sched_perf_5_h RO/V
 , 16'h404D //102 hqm_list_sel_pipe REG_MAP 0x094000134 HQM_OS_W cfg_ldb_sched_perf_5_l RO/V
 , 16'h404C //101 hqm_list_sel_pipe REG_MAP 0x094000130 HQM_OS_W cfg_ldb_sched_perf_4_h RO/V
 , 16'h404B //100 hqm_list_sel_pipe REG_MAP 0x09400012c HQM_OS_W cfg_ldb_sched_perf_4_l RO/V
 , 16'h404A //99 hqm_list_sel_pipe REG_MAP 0x094000128 HQM_OS_W cfg_ldb_sched_perf_3_h RO/V
 , 16'h4049 //98 hqm_list_sel_pipe REG_MAP 0x094000124 HQM_OS_W cfg_ldb_sched_perf_3_l RO/V
 , 16'h4048 //97 hqm_list_sel_pipe REG_MAP 0x094000120 HQM_OS_W cfg_ldb_sched_perf_2_h RO/V
 , 16'h4047 //96 hqm_list_sel_pipe REG_MAP 0x09400011c HQM_OS_W cfg_ldb_sched_perf_2_l RO/V
 , 16'h4046 //95 hqm_list_sel_pipe REG_MAP 0x094000118 HQM_OS_W cfg_ldb_sched_perf_1_h RO/V
 , 16'h4045 //94 hqm_list_sel_pipe REG_MAP 0x094000114 HQM_OS_W cfg_ldb_sched_perf_1_l RO/V
 , 16'h4044 //93 hqm_list_sel_pipe REG_MAP 0x094000110 HQM_OS_W cfg_ldb_sched_perf_0_h RO/V
 , 16'h4043 //92 hqm_list_sel_pipe REG_MAP 0x09400010c HQM_OS_W cfg_ldb_sched_perf_0_l RO/V
 , 16'h4042 //91 hqm_list_sel_pipe REG_MAP 0x094000108 HQM_OS_W cfg_cnt_win_cos3_h RO/V
 , 16'h4041 //90 hqm_list_sel_pipe REG_MAP 0x094000104 HQM_OS_W cfg_cnt_win_cos3_l RO/V
 , 16'h4040 //89 hqm_list_sel_pipe REG_MAP 0x094000100 HQM_OS_W cfg_cnt_win_cos2_h RO/V
 , 16'h403F //88 hqm_list_sel_pipe REG_MAP 0x0940000fc HQM_OS_W cfg_cnt_win_cos2_l RO/V
 , 16'h403E //87 hqm_list_sel_pipe REG_MAP 0x0940000f8 HQM_OS_W cfg_cnt_win_cos1_h RO/V
 , 16'h403D //86 hqm_list_sel_pipe REG_MAP 0x0940000f4 HQM_OS_W cfg_cnt_win_cos1_l RO/V
 , 16'h403C //85 hqm_list_sel_pipe REG_MAP 0x0940000f0 HQM_OS_W cfg_cnt_win_cos0_h RO/V
 , 16'h403B //84 hqm_list_sel_pipe REG_MAP 0x0940000ec HQM_OS_W cfg_cnt_win_cos0_l RO/V
 , 16'h403A //83 hqm_list_sel_pipe REG_MAP 0x0940000e8 HQM_OS_W cfg_rnd_loss_cos3_h RO/V
 , 16'h4039 //82 hqm_list_sel_pipe REG_MAP 0x0940000e4 HQM_OS_W cfg_rnd_loss_cos3_l RO/V
 , 16'h4038 //81 hqm_list_sel_pipe REG_MAP 0x0940000e0 HQM_OS_W cfg_rnd_loss_cos2_h RO/V
 , 16'h4037 //80 hqm_list_sel_pipe REG_MAP 0x0940000dc HQM_OS_W cfg_rnd_loss_cos2_l RO/V
 , 16'h4036 //79 hqm_list_sel_pipe REG_MAP 0x0940000d8 HQM_OS_W cfg_rnd_loss_cos1_h RO/V
 , 16'h4035 //78 hqm_list_sel_pipe REG_MAP 0x0940000d4 HQM_OS_W cfg_rnd_loss_cos1_l RO/V
 , 16'h4034 //77 hqm_list_sel_pipe REG_MAP 0x0940000d0 HQM_OS_W cfg_rnd_loss_cos0_h RO/V
 , 16'h4033 //76 hqm_list_sel_pipe REG_MAP 0x0940000cc HQM_OS_W cfg_rnd_loss_cos0_l RO/V
 , 16'h4032 //75 hqm_list_sel_pipe REG_MAP 0x0940000c8 HQM_OS_W cfg_rdy_cos3_h RO/V
 , 16'h4031 //74 hqm_list_sel_pipe REG_MAP 0x0940000c4 HQM_OS_W cfg_rdy_cos3_l RO/V
 , 16'h4030 //73 hqm_list_sel_pipe REG_MAP 0x0940000c0 HQM_OS_W cfg_rdy_cos2_h RO/V
 , 16'h402F //72 hqm_list_sel_pipe REG_MAP 0x0940000bc HQM_OS_W cfg_rdy_cos2_l RO/V
 , 16'h402E //71 hqm_list_sel_pipe REG_MAP 0x0940000b8 HQM_OS_W cfg_rdy_cos1_h RO/V
 , 16'h402D //70 hqm_list_sel_pipe REG_MAP 0x0940000b4 HQM_OS_W cfg_rdy_cos1_l RO/V
 , 16'h402C //69 hqm_list_sel_pipe REG_MAP 0x0940000b0 HQM_OS_W cfg_rdy_cos0_h RO/V
 , 16'h402B //68 hqm_list_sel_pipe REG_MAP 0x0940000ac HQM_OS_W cfg_rdy_cos0_l RO/V
 , 16'h402A //67 hqm_list_sel_pipe REG_MAP 0x0940000a8 HQM_OS_W cfg_schd_cos3_h RO/V
 , 16'h4029 //66 hqm_list_sel_pipe REG_MAP 0x0940000a4 HQM_OS_W cfg_schd_cos3_l RO/V
 , 16'h4028 //65 hqm_list_sel_pipe REG_MAP 0x0940000a0 HQM_OS_W cfg_schd_cos2_h RO/V
 , 16'h4027 //64 hqm_list_sel_pipe REG_MAP 0x09400009c HQM_OS_W cfg_schd_cos2_l RO/V
 , 16'h4026 //63 hqm_list_sel_pipe REG_MAP 0x094000098 HQM_OS_W cfg_schd_cos1_h RO/V
 , 16'h4025 //62 hqm_list_sel_pipe REG_MAP 0x094000094 HQM_OS_W cfg_schd_cos1_l RO/V
 , 16'h4024 //61 hqm_list_sel_pipe REG_MAP 0x094000090 HQM_OS_W cfg_schd_cos0_h RO/V
 , 16'h4023 //60 hqm_list_sel_pipe REG_MAP 0x09400008c HQM_OS_W cfg_schd_cos0_l RO/V
 , 16'h4022 //59 hqm_list_sel_pipe REG_MAP 0x094000088 HQM_OS_W cfg_sch_rdy_h RO/V
 , 16'h4021 //58 hqm_list_sel_pipe REG_MAP 0x094000084 HQM_OS_W cfg_sch_rdy_l RO/V
 , 16'h4020 //57 hqm_list_sel_pipe REG_MAP 0x094000080 HQM_OS_W cfg_shdw_range_cos3 RW
 , 16'h401F //56 hqm_list_sel_pipe REG_MAP 0x09400007c HQM_OS_W cfg_shdw_range_cos2 RW
 , 16'h401E //55 hqm_list_sel_pipe REG_MAP 0x094000078 HQM_OS_W cfg_shdw_range_cos1 RW
 , 16'h401D //54 hqm_list_sel_pipe REG_MAP 0x094000074 HQM_OS_W cfg_shdw_range_cos0 RW
 , 16'h401C //53 hqm_list_sel_pipe REG_MAP 0x094000070 HQM_OS_W cfg_shdw_ctrl RW/1S/V
 , 16'h401B //52 hqm_list_sel_pipe REG_MAP 0x09400006c HQM_OS_W cfg_credit_cnt_cos3 RO/V
 , 16'h401A //51 hqm_list_sel_pipe REG_MAP 0x094000068 HQM_OS_W cfg_credit_cnt_cos2 RO/V
 , 16'h4019 //50 hqm_list_sel_pipe REG_MAP 0x094000064 HQM_OS_W cfg_credit_cnt_cos1 RO/V
 , 16'h4018 //49 hqm_list_sel_pipe REG_MAP 0x094000060 HQM_OS_W cfg_credit_cnt_cos0 RO/V
 , 16'h4017 //48 hqm_list_sel_pipe REG_MAP 0x09400005c HQM_OS_W cfg_credit_sat_cos3 RW/V
 , 16'h4016 //47 hqm_list_sel_pipe REG_MAP 0x094000058 HQM_OS_W cfg_credit_sat_cos2 RW/V
 , 16'h4015 //46 hqm_list_sel_pipe REG_MAP 0x094000054 HQM_OS_W cfg_credit_sat_cos1 RW/V
 , 16'h4014 //45 hqm_list_sel_pipe REG_MAP 0x094000050 HQM_OS_W cfg_credit_sat_cos0 RW/V
 , 16'h4013 //44 hqm_list_sel_pipe REG_MAP 0x09400004c HQM_OS_W cfg_cos_ctrl RW
 , 16'h4012 //43 hqm_list_sel_pipe REG_MAP 0x094000048 HQM_OS_W cfg_unit_version RO
 , 16'h4011 //42 hqm_list_sel_pipe REG_MAP 0x094000044 HQM_OS_W cfg_syndrome_sw RW/1C/V
 , 16'h4010 //41 hqm_list_sel_pipe REG_MAP 0x094000040 HQM_OS_W cfg_lsp_perf_ldb_sch_count_h RO/V
 , 16'h400F //40 hqm_list_sel_pipe REG_MAP 0x09400003c HQM_OS_W cfg_lsp_perf_ldb_sch_count_l RO/V
 , 16'h400E //39 hqm_list_sel_pipe REG_MAP 0x094000038 HQM_OS_W cfg_lsp_perf_dir_sch_count_h RO/V
 , 16'h400D //38 hqm_list_sel_pipe REG_MAP 0x094000034 HQM_OS_W cfg_lsp_perf_dir_sch_count_l RO/V
 , 16'h400C //37 hqm_list_sel_pipe REG_MAP 0x094000030 HQM_OS_W cfg_lsp_csr_control RW
 , 16'h400B //36 hqm_list_sel_pipe REG_MAP 0x09400002c HQM_OS_W cfg_ldb_sched_control RW/V
 , 16'h400A //35 hqm_list_sel_pipe REG_MAP 0x094000028 HQM_OS_W cfg_fid_inflight_count RO/V
 , 16'h4009 //34 hqm_list_sel_pipe REG_MAP 0x094000024 HQM_OS_W cfg_fid_inflight_limit RW
 , 16'h4008 //33 hqm_list_sel_pipe REG_MAP 0x094000020 HQM_OS_W cfg_cq_ldb_tot_inflight_limit RW
 , 16'h4007 //32 hqm_list_sel_pipe REG_MAP 0x09400001c HQM_OS_W cfg_cq_ldb_tot_inflight_count RO/V
 , 16'h4006 //31 hqm_list_sel_pipe REG_MAP 0x094000018 HQM_OS_W cfg_arb_weight_ldb_qid_1 RW
 , 16'h4005 //30 hqm_list_sel_pipe REG_MAP 0x094000014 HQM_OS_W cfg_arb_weight_ldb_qid_0 RW
 , 16'h4004 //29 hqm_list_sel_pipe REG_MAP 0x094000010 HQM_OS_W cfg_arb_weight_ldb_issue_0 RW
 , 16'h4003 //28 hqm_list_sel_pipe REG_MAP 0x09400000c HQM_OS_W cfg_arb_weight_atm_nalb_qid_1 RW
 , 16'h4002 //27 hqm_list_sel_pipe REG_MAP 0x094000008 HQM_OS_W cfg_arb_weight_atm_nalb_qid_0 RW
 , 16'h4001 //26 hqm_list_sel_pipe REG_MAP 0x094000004 HQM_OS_W cfg_aqed_tot_enqueue_limit RW
 , 16'h4000 //25 hqm_list_sel_pipe REG_MAP 0x094000000 HQM_OS_W cfg_aqed_tot_enqueue_count RO/V
 , 16'hC018 //24 hqm_list_sel_pipe REG_MAP 0x09c000060 HQM_FEATURE_W cfg_patch_control RW
 , 16'hC017 //23 hqm_list_sel_pipe REG_MAP 0x09c00005c HQM_FEATURE_W cfg_unit_timeout RW
 , 16'hC016 //22 hqm_list_sel_pipe REG_MAP 0x09c000058 HQM_FEATURE_W cfg_unit_idle RO/V
 , 16'hC015 //21 hqm_list_sel_pipe REG_MAP 0x09c000054 HQM_FEATURE_W cfg_syndrome_hw RW/1C/V
 , 16'hC014 //20 hqm_list_sel_pipe REG_MAP 0x09c000050 HQM_FEATURE_W cfg_smon0_timer RW/V
 , 16'hC013 //19 hqm_list_sel_pipe REG_MAP 0x09c00004c HQM_FEATURE_W cfg_smon0_maximum_timer RW/V
 , 16'hC012 //18 hqm_list_sel_pipe REG_MAP 0x09c000048 HQM_FEATURE_W cfg_smon0_activitycounter1 RW/V
 , 16'hC011 //17 hqm_list_sel_pipe REG_MAP 0x09c000044 HQM_FEATURE_W cfg_smon0_activitycounter0 RW/V
 , 16'hC010 //16 hqm_list_sel_pipe REG_MAP 0x09c000040 HQM_FEATURE_W cfg_smon0_configuration1 RW
 , 16'hC00F //15 hqm_list_sel_pipe REG_MAP 0x09c00003c HQM_FEATURE_W cfg_smon0_configuration0 RW
 , 16'hC00E //14 hqm_list_sel_pipe REG_MAP 0x09c000038 HQM_FEATURE_W cfg_smon0_compare1 RW/V
 , 16'hC00D //13 hqm_list_sel_pipe REG_MAP 0x09c000034 HQM_FEATURE_W cfg_smon0_compare0 RW/V
 , 16'hC00C //12 hqm_list_sel_pipe REG_MAP 0x09c000030 HQM_FEATURE_W cfg_pipe_health_valid_01 RO/V
 , 16'hC00B //11 hqm_list_sel_pipe REG_MAP 0x09c00002c HQM_FEATURE_W cfg_pipe_health_valid_00 RO/V
 , 16'hC00A //10 hqm_list_sel_pipe REG_MAP 0x09c000028 HQM_FEATURE_W cfg_pipe_health_hold_01 RO/V
 , 16'hC009 //9 hqm_list_sel_pipe REG_MAP 0x09c000024 HQM_FEATURE_W cfg_pipe_health_hold_00 RO/V
 , 16'hC008 //8 hqm_list_sel_pipe REG_MAP 0x09c000020 HQM_FEATURE_W cfg_interface_status RO/V
 , 16'hC007 //7 hqm_list_sel_pipe REG_MAP 0x09c00001c HQM_FEATURE_W cfg_hw_agitate_select RW
 , 16'hC006 //6 hqm_list_sel_pipe REG_MAP 0x09c000018 HQM_FEATURE_W cfg_hw_agitate_control RW
 , 16'hC005 //5 hqm_list_sel_pipe REG_MAP 0x09c000014 HQM_FEATURE_W cfg_error_inject RW
 , 16'hC004 //4 hqm_list_sel_pipe REG_MAP 0x09c000010 HQM_FEATURE_W cfg_diagnostic_status_0 RO/V
 , 16'hC003 //3 hqm_list_sel_pipe REG_MAP 0x09c00000c HQM_FEATURE_W cfg_diagnostic_aw_status RO/V
 , 16'hC002 //2 hqm_list_sel_pipe REG_MAP 0x09c000008 HQM_FEATURE_W cfg_control_pipeline_credits RW
 , 16'hC001 //1 hqm_list_sel_pipe REG_MAP 0x09c000004 HQM_FEATURE_W cfg_control_general_1 RW
 , 16'hC000 //0 hqm_list_sel_pipe REG_MAP 0x09c000000 HQM_FEATURE_W cfg_control_general_0 RW
 }; 
 
parameter HQM_NALB_TARGET_CFG_UNIT_VERSION = 43 ; 
parameter HQM_NALB_TARGET_CFG_NALB_CSR_CONTROL = 42 ; 
parameter HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 = 41 ; 
parameter HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 = 40 ; 
parameter HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_1 = 39 ; 
parameter HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_0 = 38 ; 
parameter HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_1 = 37 ; 
parameter HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_0 = 36 ; 
parameter HQM_NALB_TARGET_CFG_PATCH_CONTROL = 35 ; 
parameter HQM_NALB_TARGET_CFG_UNIT_TIMEOUT = 34 ; 
parameter HQM_NALB_TARGET_CFG_UNIT_IDLE = 33 ; 
parameter HQM_NALB_TARGET_CFG_SYNDROME_01 = 32 ; 
parameter HQM_NALB_TARGET_CFG_SYNDROME_00 = 31 ; 
parameter HQM_NALB_TARGET_CFG_SMON_TIMER = 30 ; 
parameter HQM_NALB_TARGET_CFG_SMON_MAXIMUM_TIMER = 29 ; 
parameter HQM_NALB_TARGET_CFG_SMON_CONFIGURATION1 = 28 ; 
parameter HQM_NALB_TARGET_CFG_SMON_CONFIGURATION0 = 27 ; 
parameter HQM_NALB_TARGET_CFG_SMON_COMPARE1 = 26 ; 
parameter HQM_NALB_TARGET_CFG_SMON_COMPARE0 = 25 ; 
parameter HQM_NALB_TARGET_CFG_SMON_ACTIVITYCOUNTER1 = 24 ; 
parameter HQM_NALB_TARGET_CFG_SMON_ACTIVITYCOUNTER0 = 23 ; 
parameter HQM_NALB_TARGET_CFG_PIPE_HEALTH_VALID_01 = 22 ; 
parameter HQM_NALB_TARGET_CFG_PIPE_HEALTH_VALID_00 = 21 ; 
parameter HQM_NALB_TARGET_CFG_PIPE_HEALTH_HOLD_01 = 20 ; 
parameter HQM_NALB_TARGET_CFG_PIPE_HEALTH_HOLD_00 = 19 ; 
parameter HQM_NALB_TARGET_CFG_INTERFACE_STATUS = 18 ; 
parameter HQM_NALB_TARGET_CFG_HW_AGITATE_SELECT = 17 ; 
parameter HQM_NALB_TARGET_CFG_HW_AGITATE_CONTROL = 16 ; 
parameter HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF = 15 ; 
parameter HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF = 14 ; 
parameter HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_QED_IF = 13 ; 
parameter HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF = 12 ; 
parameter HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF = 11 ; 
parameter HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF = 10 ; 
parameter HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF = 9 ; 
parameter HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF = 8 ; 
parameter HQM_NALB_TARGET_CFG_ERROR_INJECT = 7 ; 
parameter HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 = 6 ; 
parameter HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 = 5 ; 
parameter HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS = 4 ; 
parameter HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_01 = 3 ; 
parameter HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_00 = 2 ; 
parameter HQM_NALB_TARGET_CFG_CONTROL_PIPELINE_CREDITS = 1 ; 
parameter HQM_NALB_TARGET_CFG_CONTROL_GENERAL = 0 ; 
 
parameter HQM_NALB_CFG_UNIT_TGT_MAP = {
   16'h4007 //43 hqm_nalb_pipe REG_MAP 0x07400001c HQM_OS_W cfg_unit_version RO
 , 16'h4006 //42 hqm_nalb_pipe REG_MAP 0x074000018 HQM_OS_W cfg_nalb_csr_control RW
 , 16'h4005 //41 hqm_nalb_pipe REG_MAP 0x074000014 HQM_OS_W cfg_control_arb_weights_tqpri_replay_1 RO/V
 , 16'h4004 //40 hqm_nalb_pipe REG_MAP 0x074000010 HQM_OS_W cfg_control_arb_weights_tqpri_replay_0 RW
 , 16'h4003 //39 hqm_nalb_pipe REG_MAP 0x07400000c HQM_OS_W cfg_control_arb_weights_tqpri_nalb_1 RO/V
 , 16'h4002 //38 hqm_nalb_pipe REG_MAP 0x074000008 HQM_OS_W cfg_control_arb_weights_tqpri_nalb_0 RW
 , 16'h4001 //37 hqm_nalb_pipe REG_MAP 0x074000004 HQM_OS_W cfg_control_arb_weights_tqpri_atq_1 RO/V
 , 16'h4000 //36 hqm_nalb_pipe REG_MAP 0x074000000 HQM_OS_W cfg_control_arb_weights_tqpri_atq_0 RW
 , 16'hC023 //35 hqm_nalb_pipe REG_MAP 0x07c00008c HQM_FEATURE_W cfg_patch_control RW
 , 16'hC022 //34 hqm_nalb_pipe REG_MAP 0x07c000088 HQM_FEATURE_W cfg_unit_timeout RW
 , 16'hC021 //33 hqm_nalb_pipe REG_MAP 0x07c000084 HQM_FEATURE_W cfg_unit_idle RO/V
 , 16'hC020 //32 hqm_nalb_pipe REG_MAP 0x07c000080 HQM_FEATURE_W cfg_syndrome_01 RW/1C/V
 , 16'hC01F //31 hqm_nalb_pipe REG_MAP 0x07c00007c HQM_FEATURE_W cfg_syndrome_00 RW/1C/V
 , 16'hC01E //30 hqm_nalb_pipe REG_MAP 0x07c000078 HQM_FEATURE_W cfg_smon_timer RW/V
 , 16'hC01D //29 hqm_nalb_pipe REG_MAP 0x07c000074 HQM_FEATURE_W cfg_smon_maximum_timer RW/V
 , 16'hC01C //28 hqm_nalb_pipe REG_MAP 0x07c000070 HQM_FEATURE_W cfg_smon_configuration1 RW
 , 16'hC01B //27 hqm_nalb_pipe REG_MAP 0x07c00006c HQM_FEATURE_W cfg_smon_configuration0 RW
 , 16'hC01A //26 hqm_nalb_pipe REG_MAP 0x07c000068 HQM_FEATURE_W cfg_smon_compare1 RW/V
 , 16'hC019 //25 hqm_nalb_pipe REG_MAP 0x07c000064 HQM_FEATURE_W cfg_smon_compare0 RW/V
 , 16'hC018 //24 hqm_nalb_pipe REG_MAP 0x07c000060 HQM_FEATURE_W cfg_smon_activitycounter1 RW/V
 , 16'hC017 //23 hqm_nalb_pipe REG_MAP 0x07c00005c HQM_FEATURE_W cfg_smon_activitycounter0 RW/V
 , 16'hC016 //22 hqm_nalb_pipe REG_MAP 0x07c000058 HQM_FEATURE_W cfg_pipe_health_valid_01 RO/V
 , 16'hC015 //21 hqm_nalb_pipe REG_MAP 0x07c000054 HQM_FEATURE_W cfg_pipe_health_valid_00 RO/V
 , 16'hC014 //20 hqm_nalb_pipe REG_MAP 0x07c000050 HQM_FEATURE_W cfg_pipe_health_hold_01 RO/V
 , 16'hC013 //19 hqm_nalb_pipe REG_MAP 0x07c00004c HQM_FEATURE_W cfg_pipe_health_hold_00 RO/V
 , 16'hC012 //18 hqm_nalb_pipe REG_MAP 0x07c000048 HQM_FEATURE_W cfg_interface_status RO/V
 , 16'hC011 //17 hqm_nalb_pipe REG_MAP 0x07c000044 HQM_FEATURE_W cfg_hw_agitate_select RW
 , 16'hC010 //16 hqm_nalb_pipe REG_MAP 0x07c000040 HQM_FEATURE_W cfg_hw_agitate_control RW
 , 16'hC00F //15 hqm_nalb_pipe REG_MAP 0x07c00003c HQM_FEATURE_W cfg_fifo_wmstat_rop_nalb_enq_uno_ord_if RW/V
 , 16'hC00E //14 hqm_nalb_pipe REG_MAP 0x07c000038 HQM_FEATURE_W cfg_fifo_wmstat_rop_nalb_enq_ro_if RW/V
 , 16'hC00D //13 hqm_nalb_pipe REG_MAP 0x07c000034 HQM_FEATURE_W cfg_fifo_wmstat_nalb_qed_if RW/V
 , 16'hC00C //12 hqm_nalb_pipe REG_MAP 0x07c000030 HQM_FEATURE_W cfg_fifo_wmstat_nalb_lsp_enq_rorply_if RW/V
 , 16'hC00B //11 hqm_nalb_pipe REG_MAP 0x07c00002c HQM_FEATURE_W cfg_fifo_wmstat_nalb_lsp_enq_dir_if RW/V
 , 16'hC00A //10 hqm_nalb_pipe REG_MAP 0x07c000028 HQM_FEATURE_W cfg_fifo_wmstat_lsp_nalb_sch_rorply_if RW/V
 , 16'hC009 //9 hqm_nalb_pipe REG_MAP 0x07c000024 HQM_FEATURE_W cfg_fifo_wmstat_lsp_nalb_sch_if RW/V
 , 16'hC008 //8 hqm_nalb_pipe REG_MAP 0x07c000020 HQM_FEATURE_W cfg_fifo_wmstat_lsp_nalb_sch_atq_if RW/V
 , 16'hC007 //7 hqm_nalb_pipe REG_MAP 0x07c00001c HQM_FEATURE_W cfg_error_inject RW
 , 16'hC006 //6 hqm_nalb_pipe REG_MAP 0x07c000018 HQM_FEATURE_W cfg_diagnostic_aw_status_02 RO/V
 , 16'hC005 //5 hqm_nalb_pipe REG_MAP 0x07c000014 HQM_FEATURE_W cfg_diagnostic_aw_status_01 RO/V
 , 16'hC004 //4 hqm_nalb_pipe REG_MAP 0x07c000010 HQM_FEATURE_W cfg_diagnostic_aw_status RO/V
 , 16'hC003 //3 hqm_nalb_pipe REG_MAP 0x07c00000c HQM_FEATURE_W cfg_detect_feature_operation_01 RW/V
 , 16'hC002 //2 hqm_nalb_pipe REG_MAP 0x07c000008 HQM_FEATURE_W cfg_detect_feature_operation_00 RW/V
 , 16'hC001 //1 hqm_nalb_pipe REG_MAP 0x07c000004 HQM_FEATURE_W cfg_control_pipeline_credits RW
 , 16'hC000 //0 hqm_nalb_pipe REG_MAP 0x07c000000 HQM_FEATURE_W cfg_control_general RW
 }; 
 
parameter HQM_QED_TARGET_CFG_3RDY2ISS_H = 62 ; 
parameter HQM_QED_TARGET_CFG_3RDY2ISS_L = 61 ; 
parameter HQM_QED_TARGET_CFG_3RDY1ISS_H = 60 ; 
parameter HQM_QED_TARGET_CFG_3RDY1ISS_L = 59 ; 
parameter HQM_QED_TARGET_CFG_2RDY2ISS_H = 58 ; 
parameter HQM_QED_TARGET_CFG_2RDY2ISS_L = 57 ; 
parameter HQM_QED_TARGET_CFG_2RDY1ISS_H = 56 ; 
parameter HQM_QED_TARGET_CFG_2RDY1ISS_L = 55 ; 
parameter HQM_QED_TARGET_CFG_UNIT_VERSION = 54 ; 
parameter HQM_QED_TARGET_CFG_QED_CSR_CONTROL = 53 ; 
parameter HQM_QED_TARGET_CFG_PATCH_CONTROL = 52 ; 
parameter HQM_QED_TARGET_CFG_UNIT_TIMEOUT = 51 ; 
parameter HQM_QED_TARGET_CFG_UNIT_IDLE = 50 ; 
parameter HQM_QED_TARGET_CFG_SYNDROME_00 = 49 ; 
parameter HQM_QED_TARGET_CFG_SMON_TIMER = 48 ; 
parameter HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER = 47 ; 
parameter HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 = 46 ; 
parameter HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 = 45 ; 
parameter HQM_QED_TARGET_CFG_SMON_COMPARE1 = 44 ; 
parameter HQM_QED_TARGET_CFG_SMON_COMPARE0 = 43 ; 
parameter HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 = 42 ; 
parameter HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 = 41 ; 
parameter HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID = 40 ; 
parameter HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD = 39 ; 
parameter HQM_QED_TARGET_CFG_INTERFACE_STATUS = 38 ; 
parameter HQM_QED_TARGET_CFG_HW_AGITATE_SELECT = 37 ; 
parameter HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL = 36 ; 
parameter HQM_QED_TARGET_CFG_ERROR_INJECT = 35 ; 
parameter HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS = 34 ; 
parameter HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS = 33 ; 
parameter HQM_QED_TARGET_CFG_CONTROL_GENERAL = 32 ; 
parameter HQM_QED_TARGET_CFG_QED7_WRD3 = 31 ; 
parameter HQM_QED_TARGET_CFG_QED7_WRD2 = 30 ; 
parameter HQM_QED_TARGET_CFG_QED7_WRD1 = 29 ; 
parameter HQM_QED_TARGET_CFG_QED7_WRD0 = 28 ; 
parameter HQM_QED_TARGET_CFG_QED6_WRD3 = 27 ; 
parameter HQM_QED_TARGET_CFG_QED6_WRD2 = 26 ; 
parameter HQM_QED_TARGET_CFG_QED6_WRD1 = 25 ; 
parameter HQM_QED_TARGET_CFG_QED6_WRD0 = 24 ; 
parameter HQM_QED_TARGET_CFG_QED5_WRD3 = 23 ; 
parameter HQM_QED_TARGET_CFG_QED5_WRD2 = 22 ; 
parameter HQM_QED_TARGET_CFG_QED5_WRD1 = 21 ; 
parameter HQM_QED_TARGET_CFG_QED5_WRD0 = 20 ; 
parameter HQM_QED_TARGET_CFG_QED4_WRD3 = 19 ; 
parameter HQM_QED_TARGET_CFG_QED4_WRD2 = 18 ; 
parameter HQM_QED_TARGET_CFG_QED4_WRD1 = 17 ; 
parameter HQM_QED_TARGET_CFG_QED4_WRD0 = 16 ; 
parameter HQM_QED_TARGET_CFG_QED3_WRD3 = 15 ; 
parameter HQM_QED_TARGET_CFG_QED3_WRD2 = 14 ; 
parameter HQM_QED_TARGET_CFG_QED3_WRD1 = 13 ; 
parameter HQM_QED_TARGET_CFG_QED3_WRD0 = 12 ; 
parameter HQM_QED_TARGET_CFG_QED2_WRD3 = 11 ; 
parameter HQM_QED_TARGET_CFG_QED2_WRD2 = 10 ; 
parameter HQM_QED_TARGET_CFG_QED2_WRD1 = 9 ; 
parameter HQM_QED_TARGET_CFG_QED2_WRD0 = 8 ; 
parameter HQM_QED_TARGET_CFG_QED1_WRD3 = 7 ; 
parameter HQM_QED_TARGET_CFG_QED1_WRD2 = 6 ; 
parameter HQM_QED_TARGET_CFG_QED1_WRD1 = 5 ; 
parameter HQM_QED_TARGET_CFG_QED1_WRD0 = 4 ; 
parameter HQM_QED_TARGET_CFG_QED0_WRD3 = 3 ; 
parameter HQM_QED_TARGET_CFG_QED0_WRD2 = 2 ; 
parameter HQM_QED_TARGET_CFG_QED0_WRD1 = 1 ; 
parameter HQM_QED_TARGET_CFG_QED0_WRD0 = 0 ; 
 
parameter HQM_QED_CFG_UNIT_TGT_MAP = {
   16'h4009 //62 hqm_qed_pipe REG_MAP 0x064000024 HQM_OS_W cfg_3rdy2iss_h RO/V
 , 16'h4008 //61 hqm_qed_pipe REG_MAP 0x064000020 HQM_OS_W cfg_3rdy2iss_l RO/V
 , 16'h4007 //60 hqm_qed_pipe REG_MAP 0x06400001c HQM_OS_W cfg_3rdy1iss_h RO/V
 , 16'h4006 //59 hqm_qed_pipe REG_MAP 0x064000018 HQM_OS_W cfg_3rdy1iss_l RO/V
 , 16'h4005 //58 hqm_qed_pipe REG_MAP 0x064000014 HQM_OS_W cfg_2rdy2iss_h RO/V
 , 16'h4004 //57 hqm_qed_pipe REG_MAP 0x064000010 HQM_OS_W cfg_2rdy2iss_l RO/V
 , 16'h4003 //56 hqm_qed_pipe REG_MAP 0x06400000c HQM_OS_W cfg_2rdy1iss_h RO/V
 , 16'h4002 //55 hqm_qed_pipe REG_MAP 0x064000008 HQM_OS_W cfg_2rdy1iss_l RO/V
 , 16'h4001 //54 hqm_qed_pipe REG_MAP 0x064000004 HQM_OS_W cfg_unit_version RO/V
 , 16'h4000 //53 hqm_qed_pipe REG_MAP 0x064000000 HQM_OS_W cfg_qed_csr_control RW
 , 16'hC014 //52 hqm_qed_pipe REG_MAP 0x06c000050 HQM_FEATURE_W cfg_patch_control RW
 , 16'hC013 //51 hqm_qed_pipe REG_MAP 0x06c00004c HQM_FEATURE_W cfg_unit_timeout RW
 , 16'hC012 //50 hqm_qed_pipe REG_MAP 0x06c000048 HQM_FEATURE_W cfg_unit_idle RO/V
 , 16'hC011 //49 hqm_qed_pipe REG_MAP 0x06c000044 HQM_FEATURE_W cfg_syndrome_00 RW/1C/V
 , 16'hC010 //48 hqm_qed_pipe REG_MAP 0x06c000040 HQM_FEATURE_W cfg_smon_timer RW/V
 , 16'hC00F //47 hqm_qed_pipe REG_MAP 0x06c00003c HQM_FEATURE_W cfg_smon_maximum_timer RW/V
 , 16'hC00E //46 hqm_qed_pipe REG_MAP 0x06c000038 HQM_FEATURE_W cfg_smon_configuration1 RW
 , 16'hC00D //45 hqm_qed_pipe REG_MAP 0x06c000034 HQM_FEATURE_W cfg_smon_configuration0 RW
 , 16'hC00C //44 hqm_qed_pipe REG_MAP 0x06c000030 HQM_FEATURE_W cfg_smon_compare1 RW/V
 , 16'hC00B //43 hqm_qed_pipe REG_MAP 0x06c00002c HQM_FEATURE_W cfg_smon_compare0 RW/V
 , 16'hC00A //42 hqm_qed_pipe REG_MAP 0x06c000028 HQM_FEATURE_W cfg_smon_activitycounter1 RW/V
 , 16'hC009 //41 hqm_qed_pipe REG_MAP 0x06c000024 HQM_FEATURE_W cfg_smon_activitycounter0 RW/V
 , 16'hC008 //40 hqm_qed_pipe REG_MAP 0x06c000020 HQM_FEATURE_W cfg_pipe_health_valid RO/V
 , 16'hC007 //39 hqm_qed_pipe REG_MAP 0x06c00001c HQM_FEATURE_W cfg_pipe_health_hold RO/V
 , 16'hC006 //38 hqm_qed_pipe REG_MAP 0x06c000018 HQM_FEATURE_W cfg_interface_status RO/V
 , 16'hC005 //37 hqm_qed_pipe REG_MAP 0x06c000014 HQM_FEATURE_W cfg_hw_agitate_select RW
 , 16'hC004 //36 hqm_qed_pipe REG_MAP 0x06c000010 HQM_FEATURE_W cfg_hw_agitate_control RW
 , 16'hC003 //35 hqm_qed_pipe REG_MAP 0x06c00000c HQM_FEATURE_W cfg_error_inject RW
 , 16'hC002 //34 hqm_qed_pipe REG_MAP 0x06c000008 HQM_FEATURE_W cfg_diagnostic_aw_status RO/V
 , 16'hC001 //33 hqm_qed_pipe REG_MAP 0x06c000004 HQM_FEATURE_W cfg_control_pipeline_credits RW
 , 16'hC000 //32 hqm_qed_pipe REG_MAP 0x06c000000 HQM_FEATURE_W cfg_control_general RW
 , 16'hE1F0 //31 hqm_qed_pipe MEM_MAP 0x06e1f0000 HQM_FEATURE_W cfg_qed7_wrd3 RO/V
 , 16'hE1E0 //30 hqm_qed_pipe MEM_MAP 0x06e1e0000 HQM_FEATURE_W cfg_qed7_wrd2 RO/V
 , 16'hE1D0 //29 hqm_qed_pipe MEM_MAP 0x06e1d0000 HQM_FEATURE_W cfg_qed7_wrd1 RO/V
 , 16'hE1C0 //28 hqm_qed_pipe MEM_MAP 0x06e1c0000 HQM_FEATURE_W cfg_qed7_wrd0 RO/V
 , 16'hE1B0 //27 hqm_qed_pipe MEM_MAP 0x06e1b0000 HQM_FEATURE_W cfg_qed6_wrd3 RO/V
 , 16'hE1A0 //26 hqm_qed_pipe MEM_MAP 0x06e1a0000 HQM_FEATURE_W cfg_qed6_wrd2 RO/V
 , 16'hE190 //25 hqm_qed_pipe MEM_MAP 0x06e190000 HQM_FEATURE_W cfg_qed6_wrd1 RO/V
 , 16'hE180 //24 hqm_qed_pipe MEM_MAP 0x06e180000 HQM_FEATURE_W cfg_qed6_wrd0 RO/V
 , 16'hE170 //23 hqm_qed_pipe MEM_MAP 0x06e170000 HQM_FEATURE_W cfg_qed5_wrd3 RO/V
 , 16'hE160 //22 hqm_qed_pipe MEM_MAP 0x06e160000 HQM_FEATURE_W cfg_qed5_wrd2 RO/V
 , 16'hE150 //21 hqm_qed_pipe MEM_MAP 0x06e150000 HQM_FEATURE_W cfg_qed5_wrd1 RO/V
 , 16'hE140 //20 hqm_qed_pipe MEM_MAP 0x06e140000 HQM_FEATURE_W cfg_qed5_wrd0 RO/V
 , 16'hE130 //19 hqm_qed_pipe MEM_MAP 0x06e130000 HQM_FEATURE_W cfg_qed4_wrd3 RO/V
 , 16'hE120 //18 hqm_qed_pipe MEM_MAP 0x06e120000 HQM_FEATURE_W cfg_qed4_wrd2 RO/V
 , 16'hE110 //17 hqm_qed_pipe MEM_MAP 0x06e110000 HQM_FEATURE_W cfg_qed4_wrd1 RO/V
 , 16'hE100 //16 hqm_qed_pipe MEM_MAP 0x06e100000 HQM_FEATURE_W cfg_qed4_wrd0 RO/V
 , 16'hE0F0 //15 hqm_qed_pipe MEM_MAP 0x06e0f0000 HQM_FEATURE_W cfg_qed3_wrd3 RO/V
 , 16'hE0E0 //14 hqm_qed_pipe MEM_MAP 0x06e0e0000 HQM_FEATURE_W cfg_qed3_wrd2 RO/V
 , 16'hE0D0 //13 hqm_qed_pipe MEM_MAP 0x06e0d0000 HQM_FEATURE_W cfg_qed3_wrd1 RO/V
 , 16'hE0C0 //12 hqm_qed_pipe MEM_MAP 0x06e0c0000 HQM_FEATURE_W cfg_qed3_wrd0 RO/V
 , 16'hE0B0 //11 hqm_qed_pipe MEM_MAP 0x06e0b0000 HQM_FEATURE_W cfg_qed2_wrd3 RO/V
 , 16'hE0A0 //10 hqm_qed_pipe MEM_MAP 0x06e0a0000 HQM_FEATURE_W cfg_qed2_wrd2 RO/V
 , 16'hE090 //9 hqm_qed_pipe MEM_MAP 0x06e090000 HQM_FEATURE_W cfg_qed2_wrd1 RO/V
 , 16'hE080 //8 hqm_qed_pipe MEM_MAP 0x06e080000 HQM_FEATURE_W cfg_qed2_wrd0 RO/V
 , 16'hE070 //7 hqm_qed_pipe MEM_MAP 0x06e070000 HQM_FEATURE_W cfg_qed1_wrd3 RO/V
 , 16'hE060 //6 hqm_qed_pipe MEM_MAP 0x06e060000 HQM_FEATURE_W cfg_qed1_wrd2 RO/V
 , 16'hE050 //5 hqm_qed_pipe MEM_MAP 0x06e050000 HQM_FEATURE_W cfg_qed1_wrd1 RO/V
 , 16'hE040 //4 hqm_qed_pipe MEM_MAP 0x06e040000 HQM_FEATURE_W cfg_qed1_wrd0 RO/V
 , 16'hE030 //3 hqm_qed_pipe MEM_MAP 0x06e030000 HQM_FEATURE_W cfg_qed0_wrd3 RO/V
 , 16'hE020 //2 hqm_qed_pipe MEM_MAP 0x06e020000 HQM_FEATURE_W cfg_qed0_wrd2 RO/V
 , 16'hE010 //1 hqm_qed_pipe MEM_MAP 0x06e010000 HQM_FEATURE_W cfg_qed0_wrd1 RO/V
 , 16'hE000 //0 hqm_qed_pipe MEM_MAP 0x06e000000 HQM_FEATURE_W cfg_qed0_wrd0 RO/V
 }; 
 
parameter HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT = 50 ; 
parameter HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT = 49 ; 
parameter HQM_ROP_TARGET_CFG_UNIT_VERSION = 48 ; 
parameter HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL = 47 ; 
parameter HQM_ROP_TARGET_CFG_GRP_SN_MODE = 46 ; 
parameter HQM_ROP_TARGET_CFG_PATCH_CONTROL = 45 ; 
parameter HQM_ROP_TARGET_CFG_UNIT_TIMEOUT = 44 ; 
parameter HQM_ROP_TARGET_CFG_UNIT_IDLE = 43 ; 
parameter HQM_ROP_TARGET_CFG_SYNDROME_01 = 42 ; 
parameter HQM_ROP_TARGET_CFG_SYNDROME_00 = 41 ; 
parameter HQM_ROP_TARGET_CFG_SERIALIZER_STATUS = 40 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED = 39 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB = 38 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP = 37 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP = 36 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1 = 35 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0 = 34 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED = 33 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB = 32 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP = 31 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP = 30 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1 = 29 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0 = 28 ; 
parameter HQM_ROP_TARGET_CFG_SMON_TIMER = 27 ; 
parameter HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER = 26 ; 
parameter HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 = 25 ; 
parameter HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 = 24 ; 
parameter HQM_ROP_TARGET_CFG_SMON_COMPARE1 = 23 ; 
parameter HQM_ROP_TARGET_CFG_SMON_COMPARE0 = 22 ; 
parameter HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 = 21 ; 
parameter HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 = 20 ; 
parameter HQM_ROP_TARGET_CFG_INTERFACE_STATUS = 19 ; 
parameter HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT = 18 ; 
parameter HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL = 17 ; 
parameter HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT = 16 ; 
parameter HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED = 15 ; 
parameter HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE = 14 ; 
parameter HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP = 13 ; 
parameter HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ = 12 ; 
parameter HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ = 11 ; 
parameter HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW = 10 ; 
parameter HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS = 9 ; 
parameter HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 = 8 ; 
parameter HQM_ROP_TARGET_CFG_REORDER_STATE_CNT = 7 ; 
parameter HQM_ROP_TARGET_CFG_REORDER_STATE_QID_QIDIX_CQ = 6 ; 
parameter HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_TP = 5 ; 
parameter HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_HP = 4 ; 
parameter HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_TP = 3 ; 
parameter HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_HP = 2 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1 = 1 ; 
parameter HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0 = 0 ; 
 
parameter HQM_ROP_CFG_UNIT_TGT_MAP = {
   16'h6010 //50 hqm_reorder_pipe MEM_MAP 0x086010000 HQM_OS_W cfg_grp_1_slot_shift RW/V
 , 16'h6000 //49 hqm_reorder_pipe MEM_MAP 0x086000000 HQM_OS_W cfg_grp_0_slot_shift RW/V
 , 16'h4002 //48 hqm_reorder_pipe REG_MAP 0x084000008 HQM_OS_W cfg_unit_version RO
 , 16'h4001 //47 hqm_reorder_pipe REG_MAP 0x084000004 HQM_OS_W cfg_rop_csr_control RW
 , 16'h4000 //46 hqm_reorder_pipe REG_MAP 0x084000000 HQM_OS_W cfg_grp_sn_mode RW
 , 16'hC025 //45 hqm_reorder_pipe REG_MAP 0x08c000094 HQM_FEATURE_W cfg_patch_control RW
 , 16'hC024 //44 hqm_reorder_pipe REG_MAP 0x08c000090 HQM_FEATURE_W cfg_unit_timeout RW
 , 16'hC023 //43 hqm_reorder_pipe REG_MAP 0x08c00008c HQM_FEATURE_W cfg_unit_idle RO/V
 , 16'hC022 //42 hqm_reorder_pipe REG_MAP 0x08c000088 HQM_FEATURE_W cfg_syndrome_01 RW/1C/V
 , 16'hC021 //41 hqm_reorder_pipe REG_MAP 0x08c000084 HQM_FEATURE_W cfg_syndrome_00 RW/1C/V
 , 16'hC020 //40 hqm_reorder_pipe REG_MAP 0x08c000080 HQM_FEATURE_W cfg_serializer_status RO/V
 , 16'hC01F //39 hqm_reorder_pipe REG_MAP 0x08c00007c HQM_FEATURE_W cfg_pipe_health_valid_rop_qed_dqed RO/V
 , 16'hC01E //38 hqm_reorder_pipe REG_MAP 0x08c000078 HQM_FEATURE_W cfg_pipe_health_valid_rop_nalb RO/V
 , 16'hC01D //37 hqm_reorder_pipe REG_MAP 0x08c000074 HQM_FEATURE_W cfg_pipe_health_valid_rop_lsp_reordcomp RO/V
 , 16'hC01C //36 hqm_reorder_pipe REG_MAP 0x08c000070 HQM_FEATURE_W cfg_pipe_health_valid_rop_dp RO/V
 , 16'hC01B //35 hqm_reorder_pipe REG_MAP 0x08c00006c HQM_FEATURE_W cfg_pipe_health_valid_grp1 RO/V
 , 16'hC01A //34 hqm_reorder_pipe REG_MAP 0x08c000068 HQM_FEATURE_W cfg_pipe_health_valid_grp0 RO/V
 , 16'hC019 //33 hqm_reorder_pipe REG_MAP 0x08c000064 HQM_FEATURE_W cfg_pipe_health_hold_rop_qed_dqed RO/V
 , 16'hC018 //32 hqm_reorder_pipe REG_MAP 0x08c000060 HQM_FEATURE_W cfg_pipe_health_hold_rop_nalb RO/V
 , 16'hC017 //31 hqm_reorder_pipe REG_MAP 0x08c00005c HQM_FEATURE_W cfg_pipe_health_hold_rop_lsp_reordcomp RO/V
 , 16'hC016 //30 hqm_reorder_pipe REG_MAP 0x08c000058 HQM_FEATURE_W cfg_pipe_health_hold_rop_dp RO/V
 , 16'hC015 //29 hqm_reorder_pipe REG_MAP 0x08c000054 HQM_FEATURE_W cfg_pipe_health_hold_grp1 RO/V
 , 16'hC014 //28 hqm_reorder_pipe REG_MAP 0x08c000050 HQM_FEATURE_W cfg_pipe_health_hold_grp0 RO/V
 , 16'hC013 //27 hqm_reorder_pipe REG_MAP 0x08c00004c HQM_FEATURE_W cfg_smon_timer RW/V
 , 16'hC012 //26 hqm_reorder_pipe REG_MAP 0x08c000048 HQM_FEATURE_W cfg_smon_maximum_timer RW/V
 , 16'hC011 //25 hqm_reorder_pipe REG_MAP 0x08c000044 HQM_FEATURE_W cfg_smon_configuration1 RW
 , 16'hC010 //24 hqm_reorder_pipe REG_MAP 0x08c000040 HQM_FEATURE_W cfg_smon_configuration0 RW
 , 16'hC00F //23 hqm_reorder_pipe REG_MAP 0x08c00003c HQM_FEATURE_W cfg_smon_compare1 RW/V
 , 16'hC00E //22 hqm_reorder_pipe REG_MAP 0x08c000038 HQM_FEATURE_W cfg_smon_compare0 RW/V
 , 16'hC00D //21 hqm_reorder_pipe REG_MAP 0x08c000034 HQM_FEATURE_W cfg_smon_activitycounter1 RW/V
 , 16'hC00C //20 hqm_reorder_pipe REG_MAP 0x08c000030 HQM_FEATURE_W cfg_smon_activitycounter0 RW/V
 , 16'hC00B //19 hqm_reorder_pipe REG_MAP 0x08c00002c HQM_FEATURE_W cfg_interface_status RO/V
 , 16'hC00A //18 hqm_reorder_pipe REG_MAP 0x08c000028 HQM_FEATURE_W cfg_hw_agitate_select RW
 , 16'hC009 //17 hqm_reorder_pipe REG_MAP 0x08c000024 HQM_FEATURE_W cfg_hw_agitate_control RW
 , 16'hC008 //16 hqm_reorder_pipe REG_MAP 0x08c000020 HQM_FEATURE_W cfg_frag_integrity_count RO/V
 , 16'hC007 //15 hqm_reorder_pipe REG_MAP 0x08c00001c HQM_FEATURE_W cfg_fifo_wmstat_sn_ordered RW/V
 , 16'hC006 //14 hqm_reorder_pipe REG_MAP 0x08c000018 HQM_FEATURE_W cfg_fifo_wmstat_sn_complete RW/V
 , 16'hC005 //13 hqm_reorder_pipe REG_MAP 0x08c000014 HQM_FEATURE_W cfg_fifo_wmstat_lsp_reordercmp RW/V
 , 16'hC004 //12 hqm_reorder_pipe REG_MAP 0x08c000010 HQM_FEATURE_W cfg_fifo_wmstat_ldb_rply_req RW/V
 , 16'hC003 //11 hqm_reorder_pipe REG_MAP 0x08c00000c HQM_FEATURE_W cfg_fifo_wmstat_dir_rply_req RW/V
 , 16'hC002 //10 hqm_reorder_pipe REG_MAP 0x08c000008 HQM_FEATURE_W cfg_fifo_wmstat_chp_rop_hcw RW/V
 , 16'hC001 //9 hqm_reorder_pipe REG_MAP 0x08c000004 HQM_FEATURE_W cfg_diagnostic_aw_status RO/V
 , 16'hC000 //8 hqm_reorder_pipe REG_MAP 0x08c000000 HQM_FEATURE_W cfg_control_general_0 RW
 , 16'hE070 //7 hqm_reorder_pipe MEM_MAP 0x08e070000 HQM_FEATURE_W cfg_reorder_state_cnt RO/V
 , 16'hE060 //6 hqm_reorder_pipe MEM_MAP 0x08e060000 HQM_FEATURE_W cfg_reorder_state_qid_qidix_cq RO/V
 , 16'hE050 //5 hqm_reorder_pipe MEM_MAP 0x08e050000 HQM_FEATURE_W cfg_reorder_state_dir_tp RO/V
 , 16'hE040 //4 hqm_reorder_pipe MEM_MAP 0x08e040000 HQM_FEATURE_W cfg_reorder_state_dir_hp RO/V
 , 16'hE030 //3 hqm_reorder_pipe MEM_MAP 0x08e030000 HQM_FEATURE_W cfg_reorder_state_nalb_tp RO/V
 , 16'hE020 //2 hqm_reorder_pipe MEM_MAP 0x08e020000 HQM_FEATURE_W cfg_reorder_state_nalb_hp RO/V
 , 16'hE010 //1 hqm_reorder_pipe MEM_MAP 0x08e010000 HQM_FEATURE_W cfg_pipe_health_seqnum_state_grp1 RO/V
 , 16'hE000 //0 hqm_reorder_pipe MEM_MAP 0x08e000000 HQM_FEATURE_W cfg_pipe_health_seqnum_state_grp0 RO/V
 }; 
 
function automatic hqm_cfg_allowed;
  input logic [( 4 )-1:0] node_id; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_write; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_read; 
  input cfg_req_t cfg_req; 
  begin 

    hqm_cfg_allowed = 1'b0; 
    case ( node_id ) 
  HQM_AQED_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_read[                            HQM_AQED_TARGET_CFG_AQED_BCAM ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_write[                    HQM_AQED_TARGET_CFG_AQED_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_read[                     HQM_AQED_TARGET_CFG_AQED_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_write[                  HQM_AQED_TARGET_CFG_AQED_QID_FID_LIMIT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                   HQM_AQED_TARGET_CFG_AQED_QID_FID_LIMIT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                  HQM_AQED_TARGET_CFG_AQED_QID_HID_WIDTH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                   HQM_AQED_TARGET_CFG_AQED_QID_HID_WIDTH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                            HQM_AQED_TARGET_CFG_AQED_WRD0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                            HQM_AQED_TARGET_CFG_AQED_WRD1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                            HQM_AQED_TARGET_CFG_AQED_WRD2 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                            HQM_AQED_TARGET_CFG_AQED_WRD3 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_write[     HQM_AQED_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_0 ] ) ) 
       | ( ( cfg_req_read[      HQM_AQED_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_0 ] ) ) 
       | ( ( cfg_req_read[      HQM_AQED_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_1 ] ) ) 
       | ( ( cfg_req_write[                     HQM_AQED_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_read[                      HQM_AQED_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_write[            HQM_AQED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_read[             HQM_AQED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_write[         HQM_AQED_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_read[          HQM_AQED_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_read[                 HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_read[              HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] ) ) 
       | ( ( cfg_req_read[              HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] ) ) 
       | ( ( cfg_req_write[                        HQM_AQED_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_read[                         HQM_AQED_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_write[              HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF ] ) ) 
       | ( ( cfg_req_read[               HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF ] ) ) 
       | ( ( cfg_req_write[          HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF ] ) ) 
       | ( ( cfg_req_read[           HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF ] ) ) 
       | ( ( cfg_req_write[         HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF ] ) ) 
       | ( ( cfg_req_read[          HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF ] ) ) 
       | ( ( cfg_req_write[         HQM_AQED_TARGET_CFG_FIFO_WMSTAT_FREELIST_RETURN ] ) ) 
       | ( ( cfg_req_read[          HQM_AQED_TARGET_CFG_FIFO_WMSTAT_FREELIST_RETURN ] ) ) 
       | ( ( cfg_req_write[     HQM_AQED_TARGET_CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF ] ) ) 
       | ( ( cfg_req_read[      HQM_AQED_TARGET_CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF ] ) ) 
       | ( ( cfg_req_write[     HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF ] ) ) 
       | ( ( cfg_req_read[      HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF ] ) ) 
       | ( ( cfg_req_write[         HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF ] ) ) 
       | ( ( cfg_req_read[          HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF ] ) ) 
       | ( ( cfg_req_write[                  HQM_AQED_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_read[                   HQM_AQED_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_write[                   HQM_AQED_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                    HQM_AQED_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                     HQM_AQED_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_write[                       HQM_AQED_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                        HQM_AQED_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                     HQM_AQED_TARGET_CFG_PIPE_HEALTH_HOLD ] ) ) 
       | ( ( cfg_req_read[                    HQM_AQED_TARGET_CFG_PIPE_HEALTH_VALID ] ) ) 
       | ( ( cfg_req_write[               HQM_AQED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_read[                HQM_AQED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_write[               HQM_AQED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_read[                HQM_AQED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_write[                       HQM_AQED_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_read[                        HQM_AQED_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_write[                       HQM_AQED_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_read[                        HQM_AQED_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_write[                 HQM_AQED_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_read[                  HQM_AQED_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_write[                 HQM_AQED_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_read[                  HQM_AQED_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_write[                  HQM_AQED_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_read[                   HQM_AQED_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_write[                          HQM_AQED_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_read[                           HQM_AQED_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_write[                         HQM_AQED_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_read[                          HQM_AQED_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_write[                         HQM_AQED_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                          HQM_AQED_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                            HQM_AQED_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_write[                        HQM_AQED_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                         HQM_AQED_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                         HQM_AQED_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_allowed = 1'b1; 
       end 
     end 
  HQM_AP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_write[                        HQM_AP_TARGET_CFG_AP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_read[                         HQM_AP_TARGET_CFG_AP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_write[         HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_READY_BIN ] ) ) 
       | ( ( cfg_req_read[          HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_READY_BIN ] ) ) 
       | ( ( cfg_req_write[         HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_SCHED_BIN ] ) ) 
       | ( ( cfg_req_read[          HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_SCHED_BIN ] ) ) 
       | ( ( cfg_req_write[                       HQM_AP_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_read[                        HQM_AP_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_write[              HQM_AP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_read[               HQM_AP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_write[           HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_read[            HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_write[           HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] ) ) 
       | ( ( cfg_req_read[            HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] ) ) 
       | ( ( cfg_req_read[                   HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_read[                HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] ) ) 
       | ( ( cfg_req_read[                HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] ) ) 
       | ( ( cfg_req_read[                HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_03 ] ) ) 
       | ( ( cfg_req_write[                          HQM_AP_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_read[                           HQM_AP_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_write[                HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF ] ) ) 
       | ( ( cfg_req_read[                 HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF ] ) ) 
       | ( ( cfg_req_write[             HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF ] ) ) 
       | ( ( cfg_req_read[              HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF ] ) ) 
       | ( ( cfg_req_write[            HQM_AP_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF ] ) ) 
       | ( ( cfg_req_read[             HQM_AP_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF ] ) ) 
       | ( ( cfg_req_write[                    HQM_AP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_read[                     HQM_AP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_write[                     HQM_AP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                      HQM_AP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                       HQM_AP_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_write[                  HQM_AP_TARGET_CFG_LDB_QID_RDYLST_CLAMP ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                   HQM_AP_TARGET_CFG_LDB_QID_RDYLST_CLAMP ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                         HQM_AP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                          HQM_AP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                    HQM_AP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] ) ) 
       | ( ( cfg_req_read[                   HQM_AP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] ) ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_write[                 HQM_AP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_read[                  HQM_AP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_write[                         HQM_AP_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_read[                          HQM_AP_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_write[                         HQM_AP_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_read[                          HQM_AP_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_write[                   HQM_AP_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_read[                    HQM_AP_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_write[                   HQM_AP_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_read[                    HQM_AP_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_write[                    HQM_AP_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_read[                     HQM_AP_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_write[                            HQM_AP_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_read[                             HQM_AP_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_write[                           HQM_AP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_read[                            HQM_AP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_write[                           HQM_AP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                            HQM_AP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                              HQM_AP_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_write[                          HQM_AP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                           HQM_AP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                           HQM_AP_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_allowed = 1'b1; 
       end 
     end 
  HQM_MSTR_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_write[                     HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE ] ) ) 
       | ( ( cfg_req_read[                      HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE ] ) ) 
       | ( ( cfg_req_read[                         HQM_MSTR_TARGET_CFG_CLK_ON_CNT_H ] ) ) 
       | ( ( cfg_req_read[                         HQM_MSTR_TARGET_CFG_CLK_ON_CNT_L ] ) ) 
       | ( ( cfg_req_write[                     HQM_MSTR_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_read[                      HQM_MSTR_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_read[                   HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_H ] ) ) 
       | ( ( cfg_req_read[                   HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_L ] ) ) 
       | ( ( cfg_req_read[                 HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT ] ) ) 
       | ( ( cfg_req_read[               HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS ] ) ) 
       | ( ( cfg_req_read[           HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS ] ) ) 
       | ( ( cfg_req_read[              HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS ] ) ) 
       | ( ( cfg_req_write[                 HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 ] ) ) 
       | ( ( cfg_req_read[                  HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 ] ) ) 
       | ( ( cfg_req_write[                 HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME ] ) ) 
       | ( ( cfg_req_read[                  HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME ] ) ) 
       | ( ( cfg_req_read[                          HQM_MSTR_TARGET_CFG_FLR_COUNT_H ] ) ) 
       | ( ( cfg_req_read[                          HQM_MSTR_TARGET_CFG_FLR_COUNT_L ] ) ) 
       | ( ( cfg_req_write[                     HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL ] ) ) 
       | ( ( cfg_req_read[                      HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL ] ) ) 
       | ( ( cfg_req_write[                    HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL ] ) ) 
       | ( ( cfg_req_read[                     HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL ] ) ) 
       | ( ( cfg_req_write[               HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT ] ) ) 
       | ( ( cfg_req_write[                         HQM_MSTR_TARGET_CFG_PM_OVERRIDE ] ) ) 
       | ( ( cfg_req_read[                          HQM_MSTR_TARGET_CFG_PM_OVERRIDE ] ) ) 
       | ( ( cfg_req_write[                    HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE ] ) ) 
       | ( ( cfg_req_read[                     HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE ] ) ) 
       | ( ( cfg_req_read[                            HQM_MSTR_TARGET_CFG_PM_STATUS ] ) ) 
       | ( ( cfg_req_read[                        HQM_MSTR_TARGET_CFG_PROCHOT_CNT_H ] ) ) 
       | ( ( cfg_req_read[                        HQM_MSTR_TARGET_CFG_PROCHOT_CNT_L ] ) ) 
       | ( ( cfg_req_read[                  HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_H ] ) ) 
       | ( ( cfg_req_read[                  HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_L ] ) ) 
       | ( ( cfg_req_read[                        HQM_MSTR_TARGET_CFG_PROC_ON_CNT_H ] ) ) 
       | ( ( cfg_req_read[                        HQM_MSTR_TARGET_CFG_PROC_ON_CNT_L ] ) ) 
       | ( ( cfg_req_write[                          HQM_MSTR_TARGET_CFG_TS_CONTROL ] ) ) 
       | ( ( cfg_req_read[                           HQM_MSTR_TARGET_CFG_TS_CONTROL ] ) ) 
       | ( ( cfg_req_read[                         HQM_MSTR_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_allowed = 1'b1; 
       end 
     end 
  HQM_CHP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_H ] ) ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_L ] ) ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_H ] ) ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_L ] ) ) 
       | ( ( cfg_req_read[                 HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_H ] ) ) 
       | ( ( cfg_req_read[                 HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_L ] ) ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_H ] ) ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_L ] ) ) 
       | ( ( cfg_req_read[               HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_H ] ) ) 
       | ( ( cfg_req_read[               HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_L ] ) ) 
       | ( ( cfg_req_read[                 HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_H ] ) ) 
       | ( ( cfg_req_read[                 HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_L ] ) ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_H ] ) ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_L ] ) ) 
       | ( ( cfg_req_read[               HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_H ] ) ) 
       | ( ( cfg_req_read[               HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_L ] ) ) 
       | ( ( cfg_req_write[                      HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_read[                       HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_read[                        HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                     HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL ] ) ) 
       | ( ( cfg_req_write[            HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_read[             HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_write[            HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_read[             HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_write[                    HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_read[                     HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_write[                    HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_read[                     HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_write[              HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_read[               HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_write[              HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_read[               HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_write[               HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_read[                HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_write[                       HQM_CHP_TARGET_CFG_CHP_SMON_TIMER ] ) ) 
       | ( ( cfg_req_read[                        HQM_CHP_TARGET_CFG_CHP_SMON_TIMER ] ) ) 
       | ( ( cfg_req_write[                      HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                       HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                 HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00 ] ) ) 
       | ( ( cfg_req_read[                 HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01 ] ) ) 
       | ( ( cfg_req_read[                 HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02 ] ) ) 
       | ( ( cfg_req_write[                   HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 ] ) ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 ] ) ) 
       | ( ( cfg_req_write[                   HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 ] ) ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 ] ) ) 
       | ( ( cfg_req_write[                   HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 ] ) ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 ] ) ) 
       | ( ( cfg_req_read[              HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_H ] ) ) 
       | ( ( cfg_req_read[              HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_L ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0 ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1 ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2 ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3 ] ) ) 
       | ( ( cfg_req_read[                HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0 ] ) ) 
       | ( ( cfg_req_write[                           HQM_CHP_TARGET_CFG_DIR_CQ2VAS ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_DIR_CQ2VAS ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                         HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                          HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                   HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 ] ) ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 ] ) ) 
       | ( ( cfg_req_write[                   HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 ] ) ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 ] ) ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0 ] ) ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1 ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0 ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1 ] ) ) 
       | ( ( cfg_req_read[                HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0 ] ) ) 
       | ( ( cfg_req_read[                HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1 ] ) ) 
       | ( ( cfg_req_read[                   HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0 ] ) ) 
       | ( ( cfg_req_read[                   HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1 ] ) ) 
       | ( ( cfg_req_write[               HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                       HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                        HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                      HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                       HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                     HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL ] ) ) 
       | ( ( cfg_req_write[               HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[            HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[             HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                        HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                         HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                          HQM_CHP_TARGET_CFG_DIR_CQ_WPTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                           HQM_CHP_TARGET_CFG_DIR_CQ_WPTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_DIR_WDRT_0 ] ) ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_DIR_WDRT_1 ] ) ) 
       | ( ( cfg_req_write[                           HQM_CHP_TARGET_CFG_DIR_WDTO_0 ] ) ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_DIR_WDTO_0 ] ) ) 
       | ( ( cfg_req_write[                           HQM_CHP_TARGET_CFG_DIR_WDTO_1 ] ) ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_DIR_WDTO_1 ] ) ) 
       | ( ( cfg_req_write[                      HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 ] ) ) 
       | ( ( cfg_req_read[                       HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 ] ) ) 
       | ( ( cfg_req_write[                      HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 ] ) ) 
       | ( ( cfg_req_read[                       HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 ] ) ) 
       | ( ( cfg_req_write[                  HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL ] ) ) 
       | ( ( cfg_req_read[                   HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL ] ) ) 
       | ( ( cfg_req_read[                           HQM_CHP_TARGET_CFG_DIR_WD_IRQ0 ] ) ) 
       | ( ( cfg_req_read[                           HQM_CHP_TARGET_CFG_DIR_WD_IRQ1 ] ) ) 
       | ( ( cfg_req_write[                     HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD ] ) ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_FREELIST_0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_FREELIST_1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_FREELIST_2 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_FREELIST_3 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_FREELIST_4 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_FREELIST_5 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_FREELIST_6 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_FREELIST_7 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                           HQM_CHP_TARGET_CFG_HIST_LIST_0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                           HQM_CHP_TARGET_CFG_HIST_LIST_1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                         HQM_CHP_TARGET_CFG_HIST_LIST_A_0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                         HQM_CHP_TARGET_CFG_HIST_LIST_A_1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_write[                     HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                    HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                     HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                  HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                   HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                 HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                       HQM_CHP_TARGET_CFG_HIST_LIST_BASE ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                        HQM_CHP_TARGET_CFG_HIST_LIST_BASE ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                      HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                       HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                       HQM_CHP_TARGET_CFG_HIST_LIST_MODE ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                        HQM_CHP_TARGET_CFG_HIST_LIST_MODE ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                    HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                     HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                   HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                   HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_write[                    HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                     HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_write[                           HQM_CHP_TARGET_CFG_LDB_CQ2VAS ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_LDB_CQ2VAS ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                         HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                          HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                   HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 ] ) ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 ] ) ) 
       | ( ( cfg_req_write[                   HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 ] ) ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 ] ) ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0 ] ) ) 
       | ( ( cfg_req_read[                  HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1 ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0 ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1 ] ) ) 
       | ( ( cfg_req_read[                HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0 ] ) ) 
       | ( ( cfg_req_read[                HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1 ] ) ) 
       | ( ( cfg_req_read[                   HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0 ] ) ) 
       | ( ( cfg_req_read[                   HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1 ] ) ) 
       | ( ( cfg_req_write[               HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                       HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                        HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                      HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                       HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[              HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[               HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                    HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                     HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL ] ) ) 
       | ( ( cfg_req_write[               HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[            HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[             HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                        HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                         HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                          HQM_CHP_TARGET_CFG_LDB_CQ_WPTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                           HQM_CHP_TARGET_CFG_LDB_CQ_WPTR ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_LDB_WDRT_0 ] ) ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_LDB_WDRT_1 ] ) ) 
       | ( ( cfg_req_write[                           HQM_CHP_TARGET_CFG_LDB_WDTO_0 ] ) ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_LDB_WDTO_0 ] ) ) 
       | ( ( cfg_req_write[                           HQM_CHP_TARGET_CFG_LDB_WDTO_1 ] ) ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_LDB_WDTO_1 ] ) ) 
       | ( ( cfg_req_write[                      HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 ] ) ) 
       | ( ( cfg_req_read[                       HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 ] ) ) 
       | ( ( cfg_req_write[                      HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 ] ) ) 
       | ( ( cfg_req_read[                       HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 ] ) ) 
       | ( ( cfg_req_write[                  HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL ] ) ) 
       | ( ( cfg_req_read[                   HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL ] ) ) 
       | ( ( cfg_req_read[                           HQM_CHP_TARGET_CFG_LDB_WD_IRQ0 ] ) ) 
       | ( ( cfg_req_read[                           HQM_CHP_TARGET_CFG_LDB_WD_IRQ1 ] ) ) 
       | ( ( cfg_req_write[                     HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD ] ) ) 
       | ( ( cfg_req_write[                           HQM_CHP_TARGET_CFG_ORD_QID_SN ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                            HQM_CHP_TARGET_CFG_ORD_QID_SN ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                       HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                        HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                        HQM_CHP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                         HQM_CHP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD ] ) ) 
       | ( ( cfg_req_read[                     HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID ] ) ) 
       | ( ( cfg_req_read[                             HQM_CHP_TARGET_CFG_RETN_ZERO ] ) ) 
       | ( ( cfg_req_write[                          HQM_CHP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_read[                           HQM_CHP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_write[                          HQM_CHP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                           HQM_CHP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                             HQM_CHP_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_write[                         HQM_CHP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                          HQM_CHP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                          HQM_CHP_TARGET_CFG_UNIT_VERSION ] ) ) 
       | ( ( cfg_req_write[                     HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                      HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT ] ) & (cfg_req.addr.offset < 32)  ) 
       ) begin 
       hqm_cfg_allowed = 1'b1; 
       end 
     end 
  HQM_DP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_write[       HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 ] ) ) 
       | ( ( cfg_req_read[        HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 ] ) ) 
       | ( ( cfg_req_read[        HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1 ] ) ) 
       | ( ( cfg_req_write[    HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ] ) ) 
       | ( ( cfg_req_read[     HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ] ) ) 
       | ( ( cfg_req_read[     HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 ] ) ) 
       | ( ( cfg_req_write[                       HQM_DP_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_read[                        HQM_DP_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_write[              HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_read[               HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_write[           HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_read[            HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_write[           HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] ) ) 
       | ( ( cfg_req_read[            HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] ) ) 
       | ( ( cfg_req_read[                   HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_read[                HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] ) ) 
       | ( ( cfg_req_read[                HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] ) ) 
       | ( ( cfg_req_write[                       HQM_DP_TARGET_CFG_DIR_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_read[                        HQM_DP_TARGET_CFG_DIR_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_write[                          HQM_DP_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_read[                           HQM_DP_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_write[                HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF ] ) ) 
       | ( ( cfg_req_read[                 HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF ] ) ) 
       | ( ( cfg_req_write[         HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF ] ) ) 
       | ( ( cfg_req_read[          HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF ] ) ) 
       | ( ( cfg_req_write[      HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF ] ) ) 
       | ( ( cfg_req_read[       HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF ] ) ) 
       | ( ( cfg_req_write[         HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF ] ) ) 
       | ( ( cfg_req_read[          HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF ] ) ) 
       | ( ( cfg_req_write[      HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF ] ) ) 
       | ( ( cfg_req_read[       HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF ] ) ) 
       | ( ( cfg_req_write[         HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF ] ) ) 
       | ( ( cfg_req_read[          HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF ] ) ) 
       | ( ( cfg_req_write[          HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF ] ) ) 
       | ( ( cfg_req_read[           HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF ] ) ) 
       | ( ( cfg_req_write[                    HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_read[                     HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_write[                     HQM_DP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                      HQM_DP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                       HQM_DP_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_write[                         HQM_DP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                          HQM_DP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                    HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] ) ) 
       | ( ( cfg_req_read[                   HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] ) ) 
       | ( ( cfg_req_write[                 HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_read[                  HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_write[                 HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_read[                  HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_write[                         HQM_DP_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_read[                          HQM_DP_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_write[                         HQM_DP_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_read[                          HQM_DP_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_write[                   HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_read[                    HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_write[                   HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_read[                    HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_write[                    HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_read[                     HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_write[                            HQM_DP_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_read[                             HQM_DP_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_write[                           HQM_DP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_read[                            HQM_DP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_write[                           HQM_DP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                            HQM_DP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                              HQM_DP_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_write[                          HQM_DP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                           HQM_DP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                           HQM_DP_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_allowed = 1'b1; 
       end 
     end 
  HQM_LSP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_COUNT ] ) ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT ] ) ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT ] ) ) 
       | ( ( cfg_req_write[            HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 ] ) ) 
       | ( ( cfg_req_read[             HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 ] ) ) 
       | ( ( cfg_req_write[            HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 ] ) ) 
       | ( ( cfg_req_read[             HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 ] ) ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 ] ) ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 ] ) ) 
       | ( ( cfg_req_write[                 HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 ] ) ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 ] ) ) 
       | ( ( cfg_req_write[                 HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 ] ) ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 ] ) ) 
       | ( ( cfg_req_write[                   HQM_LSP_TARGET_CFG_ATM_QID_DPTH_THRSH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_ATM_QID_DPTH_THRSH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_CNT_WIN_COS0_H ] ) ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_CNT_WIN_COS0_L ] ) ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_CNT_WIN_COS1_H ] ) ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_CNT_WIN_COS1_L ] ) ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_CNT_WIN_COS2_H ] ) ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_CNT_WIN_COS2_L ] ) ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_CNT_WIN_COS3_H ] ) ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_CNT_WIN_COS3_L ] ) ) 
       | ( ( cfg_req_write[                    HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 ] ) ) 
       | ( ( cfg_req_read[                     HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 ] ) ) 
       | ( ( cfg_req_write[                    HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 ] ) ) 
       | ( ( cfg_req_read[                     HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 ] ) ) 
       | ( ( cfg_req_write[             HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_read[              HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_write[             HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT ] ) ) 
       | ( ( cfg_req_read[              HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT ] ) ) 
       | ( ( cfg_req_write[                             HQM_LSP_TARGET_CFG_COS_CTRL ] ) ) 
       | ( ( cfg_req_read[                              HQM_LSP_TARGET_CFG_COS_CTRL ] ) ) 
       | ( ( cfg_req_write[                             HQM_LSP_TARGET_CFG_CQ2PRIOV ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                              HQM_LSP_TARGET_CFG_CQ2PRIOV ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                              HQM_LSP_TARGET_CFG_CQ2QID0 ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                               HQM_LSP_TARGET_CFG_CQ2QID0 ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                              HQM_LSP_TARGET_CFG_CQ2QID1 ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                               HQM_LSP_TARGET_CFG_CQ2QID1 ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                       HQM_LSP_TARGET_CFG_CQ_DIR_DISABLE ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_CQ_DIR_DISABLE ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                   HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[        HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[         HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                  HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                   HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                  HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTL ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                   HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTL ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                       HQM_LSP_TARGET_CFG_CQ_LDB_DISABLE ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_CQ_LDB_DISABLE ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_LIMIT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_LIMIT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[            HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_THRESHOLD ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[             HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_THRESHOLD ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H ] ) ) 
       | ( ( cfg_req_read[           HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L ] ) ) 
       | ( ( cfg_req_write[                   HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[            HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_DEPTH_SELECT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[             HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_DEPTH_SELECT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[             HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_COUNT ] ) ) 
       | ( ( cfg_req_write[            HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT ] ) ) 
       | ( ( cfg_req_read[             HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT ] ) ) 
       | ( ( cfg_req_write[                  HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                   HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                  HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTL ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                   HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTL ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_CQ_LDB_WU_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_LIMIT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_CQ_LDB_WU_LIMIT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_CREDIT_CNT_COS0 ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_CREDIT_CNT_COS1 ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_CREDIT_CNT_COS2 ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_CREDIT_CNT_COS3 ] ) ) 
       | ( ( cfg_req_write[                      HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 ] ) ) 
       | ( ( cfg_req_write[                      HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 ] ) ) 
       | ( ( cfg_req_write[                      HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 ] ) ) 
       | ( ( cfg_req_write[                      HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 ] ) ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_read[                   HQM_LSP_TARGET_CFG_DIAGNOSTIC_STATUS_0 ] ) ) 
       | ( ( cfg_req_write[                   HQM_LSP_TARGET_CFG_DIR_QID_DPTH_THRSH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_DIR_QID_DPTH_THRSH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                         HQM_LSP_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_read[                          HQM_LSP_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_FID_INFLIGHT_COUNT ] ) ) 
       | ( ( cfg_req_write[                   HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT ] ) ) 
       | ( ( cfg_req_write[                   HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_write[                    HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                     HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                      HQM_LSP_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_write[                    HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL ] ) ) 
       | ( ( cfg_req_read[                     HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_H ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_L ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_H ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_L ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_H ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_L ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_H ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_L ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_H ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_L ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_H ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_L ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_H ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_L ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_H ] ) ) 
       | ( ( cfg_req_read[                    HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_L ] ) ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL ] ) ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL ] ) ) 
       | ( ( cfg_req_write[                      HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_read[              HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_H ] ) ) 
       | ( ( cfg_req_read[              HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_L ] ) ) 
       | ( ( cfg_req_read[              HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_H ] ) ) 
       | ( ( cfg_req_read[              HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_L ] ) ) 
       | ( ( cfg_req_write[                  HQM_LSP_TARGET_CFG_NALB_QID_DPTH_THRSH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                   HQM_LSP_TARGET_CFG_NALB_QID_DPTH_THRSH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                        HQM_LSP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                         HQM_LSP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                   HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] ) ) 
       | ( ( cfg_req_read[                   HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_01 ] ) ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] ) ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_01 ] ) ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_COUNT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_LIMIT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_LIMIT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_QID_ATM_ACTIVE ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTL ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTL ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_ATQ_ENQUEUE_COUNT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_DIR_ENQUEUE_COUNT ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                    HQM_LSP_TARGET_CFG_QID_DIR_MAX_DEPTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                     HQM_LSP_TARGET_CFG_QID_DIR_MAX_DEPTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_QID_DIR_REPLAY_COUNT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                 HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTH ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_write[                 HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTL ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTL ] ) & (cfg_req.addr.offset < 64)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_ENQUEUE_COUNT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_COUNT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_COUNT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_LIMIT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_LIMIT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_00 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_00 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_01 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_01 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_02 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_02 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_03 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_03 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_04 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_04 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_05 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_05 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_06 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_06 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_07 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_07 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_08 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_08 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_09 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_09 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_10 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_10 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_11 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_11 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_12 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_12 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_13 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_13 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_14 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_14 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_15 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_15 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                 HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_QID_LDB_REPLAY_COUNT ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[                  HQM_LSP_TARGET_CFG_QID_NALDB_MAX_DEPTH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                   HQM_LSP_TARGET_CFG_QID_NALDB_MAX_DEPTH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTH ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTL ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTL ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                            HQM_LSP_TARGET_CFG_RDY_COS0_H ] ) ) 
       | ( ( cfg_req_read[                            HQM_LSP_TARGET_CFG_RDY_COS0_L ] ) ) 
       | ( ( cfg_req_read[                            HQM_LSP_TARGET_CFG_RDY_COS1_H ] ) ) 
       | ( ( cfg_req_read[                            HQM_LSP_TARGET_CFG_RDY_COS1_L ] ) ) 
       | ( ( cfg_req_read[                            HQM_LSP_TARGET_CFG_RDY_COS2_H ] ) ) 
       | ( ( cfg_req_read[                            HQM_LSP_TARGET_CFG_RDY_COS2_L ] ) ) 
       | ( ( cfg_req_read[                            HQM_LSP_TARGET_CFG_RDY_COS3_H ] ) ) 
       | ( ( cfg_req_read[                            HQM_LSP_TARGET_CFG_RDY_COS3_L ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_RND_LOSS_COS0_H ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_RND_LOSS_COS0_L ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_RND_LOSS_COS1_H ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_RND_LOSS_COS1_L ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_RND_LOSS_COS2_H ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_RND_LOSS_COS2_L ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_RND_LOSS_COS3_H ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_RND_LOSS_COS3_L ] ) ) 
       | ( ( cfg_req_read[                           HQM_LSP_TARGET_CFG_SCHD_COS0_H ] ) ) 
       | ( ( cfg_req_read[                           HQM_LSP_TARGET_CFG_SCHD_COS0_L ] ) ) 
       | ( ( cfg_req_read[                           HQM_LSP_TARGET_CFG_SCHD_COS1_H ] ) ) 
       | ( ( cfg_req_read[                           HQM_LSP_TARGET_CFG_SCHD_COS1_L ] ) ) 
       | ( ( cfg_req_read[                           HQM_LSP_TARGET_CFG_SCHD_COS2_H ] ) ) 
       | ( ( cfg_req_read[                           HQM_LSP_TARGET_CFG_SCHD_COS2_L ] ) ) 
       | ( ( cfg_req_read[                           HQM_LSP_TARGET_CFG_SCHD_COS3_H ] ) ) 
       | ( ( cfg_req_read[                           HQM_LSP_TARGET_CFG_SCHD_COS3_L ] ) ) 
       | ( ( cfg_req_read[                             HQM_LSP_TARGET_CFG_SCH_RDY_H ] ) ) 
       | ( ( cfg_req_read[                             HQM_LSP_TARGET_CFG_SCH_RDY_L ] ) ) 
       | ( ( cfg_req_write[                            HQM_LSP_TARGET_CFG_SHDW_CTRL ] ) ) 
       | ( ( cfg_req_read[                             HQM_LSP_TARGET_CFG_SHDW_CTRL ] ) ) 
       | ( ( cfg_req_write[                      HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 ] ) ) 
       | ( ( cfg_req_write[                      HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 ] ) ) 
       | ( ( cfg_req_write[                      HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 ] ) ) 
       | ( ( cfg_req_write[                      HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 ] ) ) 
       | ( ( cfg_req_read[                       HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 ] ) ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_write[               HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_read[                HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_write[                       HQM_LSP_TARGET_CFG_SMON0_COMPARE0 ] ) ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_SMON0_COMPARE0 ] ) ) 
       | ( ( cfg_req_write[                       HQM_LSP_TARGET_CFG_SMON0_COMPARE1 ] ) ) 
       | ( ( cfg_req_read[                        HQM_LSP_TARGET_CFG_SMON0_COMPARE1 ] ) ) 
       | ( ( cfg_req_write[                 HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_write[                 HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_read[                  HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_write[                  HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_read[                   HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_write[                          HQM_LSP_TARGET_CFG_SMON0_TIMER ] ) ) 
       | ( ( cfg_req_read[                           HQM_LSP_TARGET_CFG_SMON0_TIMER ] ) ) 
       | ( ( cfg_req_write[                          HQM_LSP_TARGET_CFG_SYNDROME_HW ] ) ) 
       | ( ( cfg_req_read[                           HQM_LSP_TARGET_CFG_SYNDROME_HW ] ) ) 
       | ( ( cfg_req_write[                          HQM_LSP_TARGET_CFG_SYNDROME_SW ] ) ) 
       | ( ( cfg_req_read[                           HQM_LSP_TARGET_CFG_SYNDROME_SW ] ) ) 
       | ( ( cfg_req_read[                             HQM_LSP_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_write[                         HQM_LSP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                          HQM_LSP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                          HQM_LSP_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_allowed = 1'b1; 
       end 
     end 
  HQM_NALB_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_write[     HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_0 ] ) ) 
       | ( ( cfg_req_read[      HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_0 ] ) ) 
       | ( ( cfg_req_read[      HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_1 ] ) ) 
       | ( ( cfg_req_write[    HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_0 ] ) ) 
       | ( ( cfg_req_read[     HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_0 ] ) ) 
       | ( ( cfg_req_read[     HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_1 ] ) ) 
       | ( ( cfg_req_write[  HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ] ) ) 
       | ( ( cfg_req_read[   HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ] ) ) 
       | ( ( cfg_req_read[   HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 ] ) ) 
       | ( ( cfg_req_write[                     HQM_NALB_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_read[                      HQM_NALB_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_write[            HQM_NALB_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_read[             HQM_NALB_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_write[         HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_read[          HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_write[         HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] ) ) 
       | ( ( cfg_req_read[          HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] ) ) 
       | ( ( cfg_req_read[                 HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_read[              HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] ) ) 
       | ( ( cfg_req_read[              HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] ) ) 
       | ( ( cfg_req_write[                        HQM_NALB_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_read[                         HQM_NALB_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_write[     HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF ] ) ) 
       | ( ( cfg_req_read[      HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF ] ) ) 
       | ( ( cfg_req_write[         HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF ] ) ) 
       | ( ( cfg_req_read[          HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF ] ) ) 
       | ( ( cfg_req_write[  HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF ] ) ) 
       | ( ( cfg_req_read[   HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF ] ) ) 
       | ( ( cfg_req_write[     HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF ] ) ) 
       | ( ( cfg_req_read[      HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF ] ) ) 
       | ( ( cfg_req_write[  HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF ] ) ) 
       | ( ( cfg_req_read[   HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF ] ) ) 
       | ( ( cfg_req_write[             HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_QED_IF ] ) ) 
       | ( ( cfg_req_read[              HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_QED_IF ] ) ) 
       | ( ( cfg_req_write[      HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF ] ) ) 
       | ( ( cfg_req_read[       HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF ] ) ) 
       | ( ( cfg_req_write[ HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF ] ) ) 
       | ( ( cfg_req_read[  HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF ] ) ) 
       | ( ( cfg_req_write[                  HQM_NALB_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_read[                   HQM_NALB_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_write[                   HQM_NALB_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                    HQM_NALB_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                     HQM_NALB_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_write[                    HQM_NALB_TARGET_CFG_NALB_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_read[                     HQM_NALB_TARGET_CFG_NALB_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_write[                       HQM_NALB_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                        HQM_NALB_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                  HQM_NALB_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] ) ) 
       | ( ( cfg_req_read[                  HQM_NALB_TARGET_CFG_PIPE_HEALTH_HOLD_01 ] ) ) 
       | ( ( cfg_req_read[                 HQM_NALB_TARGET_CFG_PIPE_HEALTH_VALID_00 ] ) ) 
       | ( ( cfg_req_read[                 HQM_NALB_TARGET_CFG_PIPE_HEALTH_VALID_01 ] ) ) 
       | ( ( cfg_req_write[               HQM_NALB_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_read[                HQM_NALB_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_write[               HQM_NALB_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_read[                HQM_NALB_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_write[                       HQM_NALB_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_read[                        HQM_NALB_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_write[                       HQM_NALB_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_read[                        HQM_NALB_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_write[                 HQM_NALB_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_read[                  HQM_NALB_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_write[                 HQM_NALB_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_read[                  HQM_NALB_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_write[                  HQM_NALB_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_read[                   HQM_NALB_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_write[                          HQM_NALB_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_read[                           HQM_NALB_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_write[                         HQM_NALB_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_read[                          HQM_NALB_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_write[                         HQM_NALB_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                          HQM_NALB_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                            HQM_NALB_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_write[                        HQM_NALB_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                         HQM_NALB_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                         HQM_NALB_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_allowed = 1'b1; 
       end 
     end 
  HQM_QED_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_read[                            HQM_QED_TARGET_CFG_2RDY1ISS_H ] ) ) 
       | ( ( cfg_req_read[                            HQM_QED_TARGET_CFG_2RDY1ISS_L ] ) ) 
       | ( ( cfg_req_read[                            HQM_QED_TARGET_CFG_2RDY2ISS_H ] ) ) 
       | ( ( cfg_req_read[                            HQM_QED_TARGET_CFG_2RDY2ISS_L ] ) ) 
       | ( ( cfg_req_read[                            HQM_QED_TARGET_CFG_3RDY1ISS_H ] ) ) 
       | ( ( cfg_req_read[                            HQM_QED_TARGET_CFG_3RDY1ISS_L ] ) ) 
       | ( ( cfg_req_read[                            HQM_QED_TARGET_CFG_3RDY2ISS_H ] ) ) 
       | ( ( cfg_req_read[                            HQM_QED_TARGET_CFG_3RDY2ISS_L ] ) ) 
       | ( ( cfg_req_write[                      HQM_QED_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_read[                       HQM_QED_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_write[             HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_read[              HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_read[                  HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_write[                         HQM_QED_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_read[                          HQM_QED_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_write[                   HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_read[                    HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_write[                    HQM_QED_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                     HQM_QED_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                      HQM_QED_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_write[                        HQM_QED_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                         HQM_QED_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                      HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD ] ) ) 
       | ( ( cfg_req_read[                     HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID ] ) ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED0_WRD0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED0_WRD1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED0_WRD2 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED0_WRD3 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED1_WRD0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED1_WRD1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED1_WRD2 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED1_WRD3 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED2_WRD0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED2_WRD1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED2_WRD2 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED2_WRD3 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED3_WRD0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED3_WRD1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED3_WRD2 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED3_WRD3 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED4_WRD0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED4_WRD1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED4_WRD2 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED4_WRD3 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED5_WRD0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED5_WRD1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED5_WRD2 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED5_WRD3 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED6_WRD0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED6_WRD1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED6_WRD2 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED6_WRD3 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED7_WRD0 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED7_WRD1 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED7_WRD2 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_QED7_WRD3 ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_write[                      HQM_QED_TARGET_CFG_QED_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_read[                       HQM_QED_TARGET_CFG_QED_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_write[                HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_read[                 HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_write[                HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_read[                 HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_write[                        HQM_QED_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_read[                         HQM_QED_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_write[                        HQM_QED_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_read[                         HQM_QED_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_write[                  HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_read[                   HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_write[                  HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_read[                   HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_write[                   HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_read[                    HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_write[                           HQM_QED_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_read[                            HQM_QED_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_write[                          HQM_QED_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_read[                           HQM_QED_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_read[                             HQM_QED_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_write[                         HQM_QED_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                          HQM_QED_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                          HQM_QED_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_allowed = 1'b1; 
       end 
     end 
  HQM_ROP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_write[                    HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 ] ) ) 
       | ( ( cfg_req_read[                     HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 ] ) ) 
       | ( ( cfg_req_read[                  HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_write[              HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW ] ) ) 
       | ( ( cfg_req_read[               HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW ] ) ) 
       | ( ( cfg_req_write[             HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ ] ) ) 
       | ( ( cfg_req_read[              HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ ] ) ) 
       | ( ( cfg_req_write[             HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ ] ) ) 
       | ( ( cfg_req_read[              HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ ] ) ) 
       | ( ( cfg_req_write[           HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP ] ) ) 
       | ( ( cfg_req_read[            HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP ] ) ) 
       | ( ( cfg_req_write[              HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE ] ) ) 
       | ( ( cfg_req_read[               HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE ] ) ) 
       | ( ( cfg_req_write[               HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED ] ) ) 
       | ( ( cfg_req_read[                HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED ] ) ) 
       | ( ( cfg_req_read[                  HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT ] ) ) 
       | ( ( cfg_req_write[                     HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT ] ) & (cfg_req.addr.offset < 16)  ) 
       | ( ( cfg_req_read[                      HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT ] ) & (cfg_req.addr.offset < 16)  ) 
       | ( ( cfg_req_write[                     HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT ] ) & (cfg_req.addr.offset < 16)  ) 
       | ( ( cfg_req_read[                      HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT ] ) & (cfg_req.addr.offset < 16)  ) 
       | ( ( cfg_req_write[                          HQM_ROP_TARGET_CFG_GRP_SN_MODE ] ) ) 
       | ( ( cfg_req_read[                           HQM_ROP_TARGET_CFG_GRP_SN_MODE ] ) ) 
       | ( ( cfg_req_write[                   HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_read[                    HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_write[                    HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                     HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_read[                      HQM_ROP_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_write[                        HQM_ROP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                         HQM_ROP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_read[                 HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0 ] ) ) 
       | ( ( cfg_req_read[                 HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1 ] ) ) 
       | ( ( cfg_req_read[               HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP ] ) ) 
       | ( ( cfg_req_read[    HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP ] ) ) 
       | ( ( cfg_req_read[             HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB ] ) ) 
       | ( ( cfg_req_read[         HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED ] ) ) 
       | ( ( cfg_req_read[         HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[         HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1 ] ) & (cfg_req.addr.offset < 32)  ) 
       | ( ( cfg_req_read[                HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0 ] ) ) 
       | ( ( cfg_req_read[                HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1 ] ) ) 
       | ( ( cfg_req_read[              HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP ] ) ) 
       | ( ( cfg_req_read[   HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP ] ) ) 
       | ( ( cfg_req_read[            HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB ] ) ) 
       | ( ( cfg_req_read[        HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED ] ) ) 
       | ( ( cfg_req_read[                     HQM_ROP_TARGET_CFG_REORDER_STATE_CNT ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                  HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_HP ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                  HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_TP ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                 HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_HP ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[                 HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_TP ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_read[            HQM_ROP_TARGET_CFG_REORDER_STATE_QID_QIDIX_CQ ] ) & (cfg_req.addr.offset < 2048)  ) 
       | ( ( cfg_req_write[                      HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_read[                       HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_read[                     HQM_ROP_TARGET_CFG_SERIALIZER_STATUS ] ) ) 
       | ( ( cfg_req_write[                HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_read[                 HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_write[                HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_read[                 HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_write[                        HQM_ROP_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_read[                         HQM_ROP_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_write[                        HQM_ROP_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_read[                         HQM_ROP_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_write[                  HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_read[                   HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_write[                  HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_read[                   HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_write[                   HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_read[                    HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_write[                           HQM_ROP_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_read[                            HQM_ROP_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_write[                          HQM_ROP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_read[                           HQM_ROP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_write[                          HQM_ROP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                           HQM_ROP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_read[                             HQM_ROP_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_write[                         HQM_ROP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                          HQM_ROP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_read[                          HQM_ROP_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_allowed = 1'b1; 
       end 
     end 
    endcase 
  end 
endfunction //hqm_cfg_allowed 

function automatic hqm_cfg_noidle;
  input logic [( 4 )-1:0] node_id; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_write; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_read; 
  input cfg_req_t cfg_req; 
  logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_ix; 
  begin 

    cfg_req_ix = ( cfg_req_write | cfg_req_read ); 
    hqm_cfg_noidle = 1'b0; 
    case ( node_id ) 
  HQM_AQED_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                    HQM_AQED_TARGET_CFG_AQED_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_ix[     HQM_AQED_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_0 ] ) ) 
       | ( ( cfg_req_ix[     HQM_AQED_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATM_1 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_AQED_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_ix[            HQM_AQED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_ix[         HQM_AQED_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_ix[                HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_ix[             HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] ) ) 
       | ( ( cfg_req_ix[             HQM_AQED_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] ) ) 
       | ( ( cfg_req_ix[                        HQM_AQED_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_ix[              HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF ] ) ) 
       | ( ( cfg_req_ix[          HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF ] ) ) 
       | ( ( cfg_req_ix[         HQM_AQED_TARGET_CFG_FIFO_WMSTAT_AQED_CHP_SCH_IF ] ) ) 
       | ( ( cfg_req_ix[         HQM_AQED_TARGET_CFG_FIFO_WMSTAT_FREELIST_RETURN ] ) ) 
       | ( ( cfg_req_ix[     HQM_AQED_TARGET_CFG_FIFO_WMSTAT_LSP_AQED_CMP_FID_IF ] ) ) 
       | ( ( cfg_req_ix[     HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_FID_IF ] ) ) 
       | ( ( cfg_req_ix[         HQM_AQED_TARGET_CFG_FIFO_WMSTAT_QED_AQED_ENQ_IF ] ) ) 
       | ( ( cfg_req_ix[                  HQM_AQED_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                   HQM_AQED_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_ix[                    HQM_AQED_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_ix[                       HQM_AQED_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                    HQM_AQED_TARGET_CFG_PIPE_HEALTH_HOLD ] ) ) 
       | ( ( cfg_req_ix[                   HQM_AQED_TARGET_CFG_PIPE_HEALTH_VALID ] ) ) 
       | ( ( cfg_req_ix[               HQM_AQED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_ix[               HQM_AQED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_ix[                       HQM_AQED_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_ix[                       HQM_AQED_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AQED_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AQED_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_AQED_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_ix[                          HQM_AQED_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_ix[                         HQM_AQED_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_ix[                         HQM_AQED_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_ix[                        HQM_AQED_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_ix[                        HQM_AQED_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_noidle = 1'b1; 
       end 
     end 
  HQM_AP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                        HQM_AP_TARGET_CFG_AP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_ix[         HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_READY_BIN ] ) ) 
       | ( ( cfg_req_ix[         HQM_AP_TARGET_CFG_CONTROL_ARB_WEIGHTS_SCHED_BIN ] ) ) 
       | ( ( cfg_req_ix[                       HQM_AP_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_ix[              HQM_AP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_ix[           HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_ix[           HQM_AP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_ix[               HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] ) ) 
       | ( ( cfg_req_ix[               HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] ) ) 
       | ( ( cfg_req_ix[               HQM_AP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_03 ] ) ) 
       | ( ( cfg_req_ix[                          HQM_AP_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_ix[                HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_AQED_IF ] ) ) 
       | ( ( cfg_req_ix[             HQM_AP_TARGET_CFG_FIFO_WMSTAT_AP_LSP_ENQ_IF ] ) ) 
       | ( ( cfg_req_ix[            HQM_AP_TARGET_CFG_FIFO_WMSTAT_AQED_AP_ENQ_IF ] ) ) 
       | ( ( cfg_req_ix[                    HQM_AP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                     HQM_AP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_ix[                      HQM_AP_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_ix[                         HQM_AP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                   HQM_AP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_AP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_ix[                         HQM_AP_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_ix[                         HQM_AP_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_AP_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_AP_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_ix[                    HQM_AP_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_ix[                            HQM_AP_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_ix[                           HQM_AP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_AP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_ix[                             HQM_AP_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_ix[                          HQM_AP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_ix[                          HQM_AP_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_noidle = 1'b1; 
       end 
     end 
  HQM_MSTR_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                     HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE ] ) ) 
       | ( ( cfg_req_ix[                        HQM_MSTR_TARGET_CFG_CLK_ON_CNT_H ] ) ) 
       | ( ( cfg_req_ix[                        HQM_MSTR_TARGET_CFG_CLK_ON_CNT_L ] ) ) 
       | ( ( cfg_req_ix[                     HQM_MSTR_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_ix[                  HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_H ] ) ) 
       | ( ( cfg_req_ix[                  HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_L ] ) ) 
       | ( ( cfg_req_ix[                HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT ] ) ) 
       | ( ( cfg_req_ix[              HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS ] ) ) 
       | ( ( cfg_req_ix[          HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS ] ) ) 
       | ( ( cfg_req_ix[             HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS ] ) ) 
       | ( ( cfg_req_ix[                 HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME ] ) ) 
       | ( ( cfg_req_ix[                         HQM_MSTR_TARGET_CFG_FLR_COUNT_H ] ) ) 
       | ( ( cfg_req_ix[                         HQM_MSTR_TARGET_CFG_FLR_COUNT_L ] ) ) 
       | ( ( cfg_req_ix[                     HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                    HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL ] ) ) 
       | ( ( cfg_req_ix[               HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT ] ) ) 
       | ( ( cfg_req_ix[                         HQM_MSTR_TARGET_CFG_PM_OVERRIDE ] ) ) 
       | ( ( cfg_req_ix[                    HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE ] ) ) 
       | ( ( cfg_req_ix[                           HQM_MSTR_TARGET_CFG_PM_STATUS ] ) ) 
       | ( ( cfg_req_ix[                       HQM_MSTR_TARGET_CFG_PROCHOT_CNT_H ] ) ) 
       | ( ( cfg_req_ix[                       HQM_MSTR_TARGET_CFG_PROCHOT_CNT_L ] ) ) 
       | ( ( cfg_req_ix[                 HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_H ] ) ) 
       | ( ( cfg_req_ix[                 HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_L ] ) ) 
       | ( ( cfg_req_ix[                       HQM_MSTR_TARGET_CFG_PROC_ON_CNT_H ] ) ) 
       | ( ( cfg_req_ix[                       HQM_MSTR_TARGET_CFG_PROC_ON_CNT_L ] ) ) 
       | ( ( cfg_req_ix[                          HQM_MSTR_TARGET_CFG_TS_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                        HQM_MSTR_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_noidle = 1'b1; 
       end 
     end 
  HQM_CHP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_H ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_L ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_H ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_L ] ) ) 
       | ( ( cfg_req_ix[                HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_H ] ) ) 
       | ( ( cfg_req_ix[                HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_L ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_H ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_L ] ) ) 
       | ( ( cfg_req_ix[              HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_H ] ) ) 
       | ( ( cfg_req_ix[              HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_L ] ) ) 
       | ( ( cfg_req_ix[                HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_H ] ) ) 
       | ( ( cfg_req_ix[                HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_L ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_H ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_L ] ) ) 
       | ( ( cfg_req_ix[              HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_H ] ) ) 
       | ( ( cfg_req_ix[              HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_L ] ) ) 
       | ( ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL ] ) ) 
       | ( ( cfg_req_ix[            HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_ix[            HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_ix[              HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_ix[              HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_ix[               HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_ix[                       HQM_CHP_TARGET_CFG_CHP_SMON_TIMER ] ) ) 
       | ( ( cfg_req_ix[                HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00 ] ) ) 
       | ( ( cfg_req_ix[                HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01 ] ) ) 
       | ( ( cfg_req_ix[                HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 ] ) ) 
       | ( ( cfg_req_ix[             HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_H ] ) ) 
       | ( ( cfg_req_ix[             HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_L ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3 ] ) ) 
       | ( ( cfg_req_ix[               HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1 ] ) ) 
       | ( ( cfg_req_ix[               HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0 ] ) ) 
       | ( ( cfg_req_ix[               HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_DIR_WDRT_0 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_DIR_WDRT_1 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_DIR_WDTO_0 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_DIR_WDTO_1 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL ] ) ) 
       | ( ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_DIR_WD_IRQ0 ] ) ) 
       | ( ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_DIR_WD_IRQ1 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD ] ) ) 
       | ( ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1 ] ) ) 
       | ( ( cfg_req_ix[               HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0 ] ) ) 
       | ( ( cfg_req_ix[               HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_LDB_WDRT_0 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_LDB_WDRT_1 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_LDB_WDTO_0 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_LDB_WDTO_1 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL ] ) ) 
       | ( ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_LDB_WD_IRQ0 ] ) ) 
       | ( ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_LDB_WD_IRQ1 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD ] ) ) 
       | ( ( cfg_req_ix[                        HQM_CHP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD ] ) ) 
       | ( ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID ] ) ) 
       | ( ( cfg_req_ix[                            HQM_CHP_TARGET_CFG_RETN_ZERO ] ) ) 
       | ( ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_CHP_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_ix[                         HQM_CHP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_ix[                         HQM_CHP_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_noidle = 1'b1; 
       end 
     end 
  HQM_DP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[       HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 ] ) ) 
       | ( ( cfg_req_ix[       HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1 ] ) ) 
       | ( ( cfg_req_ix[    HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ] ) ) 
       | ( ( cfg_req_ix[    HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 ] ) ) 
       | ( ( cfg_req_ix[                       HQM_DP_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_ix[              HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_ix[           HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_ix[           HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_ix[               HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] ) ) 
       | ( ( cfg_req_ix[               HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] ) ) 
       | ( ( cfg_req_ix[                       HQM_DP_TARGET_CFG_DIR_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                          HQM_DP_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_ix[                HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF ] ) ) 
       | ( ( cfg_req_ix[         HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF ] ) ) 
       | ( ( cfg_req_ix[      HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF ] ) ) 
       | ( ( cfg_req_ix[         HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF ] ) ) 
       | ( ( cfg_req_ix[      HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF ] ) ) 
       | ( ( cfg_req_ix[         HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF ] ) ) 
       | ( ( cfg_req_ix[          HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF ] ) ) 
       | ( ( cfg_req_ix[                    HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                     HQM_DP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_ix[                      HQM_DP_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_ix[                         HQM_DP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                   HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_ix[                         HQM_DP_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_ix[                         HQM_DP_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_ix[                    HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_ix[                            HQM_DP_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_ix[                           HQM_DP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_DP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_ix[                             HQM_DP_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_ix[                          HQM_DP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_ix[                          HQM_DP_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_noidle = 1'b1; 
       end 
     end 
  HQM_LSP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_COUNT ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT ] ) ) 
       | ( ( cfg_req_ix[            HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 ] ) ) 
       | ( ( cfg_req_ix[            HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 ] ) ) 
       | ( ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_CNT_WIN_COS0_H ] ) ) 
       | ( ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_CNT_WIN_COS0_L ] ) ) 
       | ( ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_CNT_WIN_COS1_H ] ) ) 
       | ( ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_CNT_WIN_COS1_L ] ) ) 
       | ( ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_CNT_WIN_COS2_H ] ) ) 
       | ( ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_CNT_WIN_COS2_L ] ) ) 
       | ( ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_CNT_WIN_COS3_H ] ) ) 
       | ( ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_CNT_WIN_COS3_L ] ) ) 
       | ( ( cfg_req_ix[                    HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 ] ) ) 
       | ( ( cfg_req_ix[                    HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 ] ) ) 
       | ( ( cfg_req_ix[             HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_ix[             HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT ] ) ) 
       | ( ( cfg_req_ix[                             HQM_LSP_TARGET_CFG_COS_CTRL ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H ] ) ) 
       | ( ( cfg_req_ix[          HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L ] ) ) 
       | ( ( cfg_req_ix[            HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_COUNT ] ) ) 
       | ( ( cfg_req_ix[            HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_COUNT ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_LIMIT ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CREDIT_CNT_COS0 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CREDIT_CNT_COS1 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CREDIT_CNT_COS2 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CREDIT_CNT_COS3 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_DIAGNOSTIC_STATUS_0 ] ) ) 
       | ( ( cfg_req_ix[                         HQM_LSP_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_FID_INFLIGHT_COUNT ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                    HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_ix[                     HQM_LSP_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_ix[                    HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_H ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_L ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_H ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_L ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_H ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_L ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_H ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_L ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_H ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_L ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_H ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_L ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_H ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_L ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_H ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_L ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_ix[             HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_H ] ) ) 
       | ( ( cfg_req_ix[             HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_L ] ) ) 
       | ( ( cfg_req_ix[             HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_H ] ) ) 
       | ( ( cfg_req_ix[             HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_L ] ) ) 
       | ( ( cfg_req_ix[                        HQM_LSP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_01 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_01 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_LSP_TARGET_CFG_RDY_COS0_H ] ) ) 
       | ( ( cfg_req_ix[                           HQM_LSP_TARGET_CFG_RDY_COS0_L ] ) ) 
       | ( ( cfg_req_ix[                           HQM_LSP_TARGET_CFG_RDY_COS1_H ] ) ) 
       | ( ( cfg_req_ix[                           HQM_LSP_TARGET_CFG_RDY_COS1_L ] ) ) 
       | ( ( cfg_req_ix[                           HQM_LSP_TARGET_CFG_RDY_COS2_H ] ) ) 
       | ( ( cfg_req_ix[                           HQM_LSP_TARGET_CFG_RDY_COS2_L ] ) ) 
       | ( ( cfg_req_ix[                           HQM_LSP_TARGET_CFG_RDY_COS3_H ] ) ) 
       | ( ( cfg_req_ix[                           HQM_LSP_TARGET_CFG_RDY_COS3_L ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_RND_LOSS_COS0_H ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_RND_LOSS_COS0_L ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_RND_LOSS_COS1_H ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_RND_LOSS_COS1_L ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_RND_LOSS_COS2_H ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_RND_LOSS_COS2_L ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_RND_LOSS_COS3_H ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_RND_LOSS_COS3_L ] ) ) 
       | ( ( cfg_req_ix[                          HQM_LSP_TARGET_CFG_SCHD_COS0_H ] ) ) 
       | ( ( cfg_req_ix[                          HQM_LSP_TARGET_CFG_SCHD_COS0_L ] ) ) 
       | ( ( cfg_req_ix[                          HQM_LSP_TARGET_CFG_SCHD_COS1_H ] ) ) 
       | ( ( cfg_req_ix[                          HQM_LSP_TARGET_CFG_SCHD_COS1_L ] ) ) 
       | ( ( cfg_req_ix[                          HQM_LSP_TARGET_CFG_SCHD_COS2_H ] ) ) 
       | ( ( cfg_req_ix[                          HQM_LSP_TARGET_CFG_SCHD_COS2_L ] ) ) 
       | ( ( cfg_req_ix[                          HQM_LSP_TARGET_CFG_SCHD_COS3_H ] ) ) 
       | ( ( cfg_req_ix[                          HQM_LSP_TARGET_CFG_SCHD_COS3_L ] ) ) 
       | ( ( cfg_req_ix[                            HQM_LSP_TARGET_CFG_SCH_RDY_H ] ) ) 
       | ( ( cfg_req_ix[                            HQM_LSP_TARGET_CFG_SCH_RDY_L ] ) ) 
       | ( ( cfg_req_ix[                            HQM_LSP_TARGET_CFG_SHDW_CTRL ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_SMON0_COMPARE0 ] ) ) 
       | ( ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_SMON0_COMPARE1 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_ix[                          HQM_LSP_TARGET_CFG_SMON0_TIMER ] ) ) 
       | ( ( cfg_req_ix[                          HQM_LSP_TARGET_CFG_SYNDROME_HW ] ) ) 
       | ( ( cfg_req_ix[                          HQM_LSP_TARGET_CFG_SYNDROME_SW ] ) ) 
       | ( ( cfg_req_ix[                            HQM_LSP_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_ix[                         HQM_LSP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_ix[                         HQM_LSP_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_noidle = 1'b1; 
       end 
     end 
  HQM_NALB_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[     HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_0 ] ) ) 
       | ( ( cfg_req_ix[     HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_ATQ_1 ] ) ) 
       | ( ( cfg_req_ix[    HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_0 ] ) ) 
       | ( ( cfg_req_ix[    HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_NALB_1 ] ) ) 
       | ( ( cfg_req_ix[  HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ] ) ) 
       | ( ( cfg_req_ix[  HQM_NALB_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_NALB_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_ix[            HQM_NALB_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_ix[         HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] ) ) 
       | ( ( cfg_req_ix[         HQM_NALB_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] ) ) 
       | ( ( cfg_req_ix[                HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_ix[             HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] ) ) 
       | ( ( cfg_req_ix[             HQM_NALB_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] ) ) 
       | ( ( cfg_req_ix[                        HQM_NALB_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_ix[     HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_ATQ_IF ] ) ) 
       | ( ( cfg_req_ix[         HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_IF ] ) ) 
       | ( ( cfg_req_ix[  HQM_NALB_TARGET_CFG_FIFO_WMSTAT_LSP_NALB_SCH_RORPLY_IF ] ) ) 
       | ( ( cfg_req_ix[     HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_DIR_IF ] ) ) 
       | ( ( cfg_req_ix[  HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_LSP_ENQ_RORPLY_IF ] ) ) 
       | ( ( cfg_req_ix[             HQM_NALB_TARGET_CFG_FIFO_WMSTAT_NALB_QED_IF ] ) ) 
       | ( ( cfg_req_ix[      HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_RO_IF ] ) ) 
       | ( ( cfg_req_ix[ HQM_NALB_TARGET_CFG_FIFO_WMSTAT_ROP_NALB_ENQ_UNO_ORD_IF ] ) ) 
       | ( ( cfg_req_ix[                  HQM_NALB_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                   HQM_NALB_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_ix[                    HQM_NALB_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_ix[                    HQM_NALB_TARGET_CFG_NALB_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                       HQM_NALB_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                 HQM_NALB_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_NALB_TARGET_CFG_PIPE_HEALTH_HOLD_01 ] ) ) 
       | ( ( cfg_req_ix[                HQM_NALB_TARGET_CFG_PIPE_HEALTH_VALID_00 ] ) ) 
       | ( ( cfg_req_ix[                HQM_NALB_TARGET_CFG_PIPE_HEALTH_VALID_01 ] ) ) 
       | ( ( cfg_req_ix[               HQM_NALB_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_ix[               HQM_NALB_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_ix[                       HQM_NALB_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_ix[                       HQM_NALB_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_NALB_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_NALB_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_NALB_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_ix[                          HQM_NALB_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_ix[                         HQM_NALB_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_ix[                         HQM_NALB_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_NALB_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_ix[                        HQM_NALB_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_ix[                        HQM_NALB_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_noidle = 1'b1; 
       end 
     end 
  HQM_QED_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                           HQM_QED_TARGET_CFG_2RDY1ISS_H ] ) ) 
       | ( ( cfg_req_ix[                           HQM_QED_TARGET_CFG_2RDY1ISS_L ] ) ) 
       | ( ( cfg_req_ix[                           HQM_QED_TARGET_CFG_2RDY2ISS_H ] ) ) 
       | ( ( cfg_req_ix[                           HQM_QED_TARGET_CFG_2RDY2ISS_L ] ) ) 
       | ( ( cfg_req_ix[                           HQM_QED_TARGET_CFG_3RDY1ISS_H ] ) ) 
       | ( ( cfg_req_ix[                           HQM_QED_TARGET_CFG_3RDY1ISS_L ] ) ) 
       | ( ( cfg_req_ix[                           HQM_QED_TARGET_CFG_3RDY2ISS_H ] ) ) 
       | ( ( cfg_req_ix[                           HQM_QED_TARGET_CFG_3RDY2ISS_L ] ) ) 
       | ( ( cfg_req_ix[                      HQM_QED_TARGET_CFG_CONTROL_GENERAL ] ) ) 
       | ( ( cfg_req_ix[             HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] ) ) 
       | ( ( cfg_req_ix[                 HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_ix[                         HQM_QED_TARGET_CFG_ERROR_INJECT ] ) ) 
       | ( ( cfg_req_ix[                   HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                    HQM_QED_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_ix[                     HQM_QED_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_ix[                        HQM_QED_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                     HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD ] ) ) 
       | ( ( cfg_req_ix[                    HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID ] ) ) 
       | ( ( cfg_req_ix[                      HQM_QED_TARGET_CFG_QED_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_ix[                HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_ix[                        HQM_QED_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_ix[                        HQM_QED_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_ix[                           HQM_QED_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_ix[                          HQM_QED_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_ix[                         HQM_QED_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_ix[                         HQM_QED_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_noidle = 1'b1; 
       end 
     end 
  HQM_ROP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                    HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] ) ) 
       | ( ( cfg_req_ix[              HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW ] ) ) 
       | ( ( cfg_req_ix[             HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ ] ) ) 
       | ( ( cfg_req_ix[             HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ ] ) ) 
       | ( ( cfg_req_ix[           HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP ] ) ) 
       | ( ( cfg_req_ix[              HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE ] ) ) 
       | ( ( cfg_req_ix[               HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED ] ) ) 
       | ( ( cfg_req_ix[                 HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT ] ) ) 
       | ( ( cfg_req_ix[                          HQM_ROP_TARGET_CFG_GRP_SN_MODE ] ) ) 
       | ( ( cfg_req_ix[                   HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                    HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT ] ) ) 
       | ( ( cfg_req_ix[                     HQM_ROP_TARGET_CFG_INTERFACE_STATUS ] ) ) 
       | ( ( cfg_req_ix[                        HQM_ROP_TARGET_CFG_PATCH_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0 ] ) ) 
       | ( ( cfg_req_ix[                HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1 ] ) ) 
       | ( ( cfg_req_ix[              HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP ] ) ) 
       | ( ( cfg_req_ix[   HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP ] ) ) 
       | ( ( cfg_req_ix[            HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB ] ) ) 
       | ( ( cfg_req_ix[        HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED ] ) ) 
       | ( ( cfg_req_ix[               HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0 ] ) ) 
       | ( ( cfg_req_ix[               HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1 ] ) ) 
       | ( ( cfg_req_ix[             HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP ] ) ) 
       | ( ( cfg_req_ix[  HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP ] ) ) 
       | ( ( cfg_req_ix[           HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB ] ) ) 
       | ( ( cfg_req_ix[       HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED ] ) ) 
       | ( ( cfg_req_ix[                      HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL ] ) ) 
       | ( ( cfg_req_ix[                    HQM_ROP_TARGET_CFG_SERIALIZER_STATUS ] ) ) 
       | ( ( cfg_req_ix[                HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] ) ) 
       | ( ( cfg_req_ix[                HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] ) ) 
       | ( ( cfg_req_ix[                        HQM_ROP_TARGET_CFG_SMON_COMPARE0 ] ) ) 
       | ( ( cfg_req_ix[                        HQM_ROP_TARGET_CFG_SMON_COMPARE1 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 ] ) ) 
       | ( ( cfg_req_ix[                  HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER ] ) ) 
       | ( ( cfg_req_ix[                           HQM_ROP_TARGET_CFG_SMON_TIMER ] ) ) 
       | ( ( cfg_req_ix[                          HQM_ROP_TARGET_CFG_SYNDROME_00 ] ) ) 
       | ( ( cfg_req_ix[                          HQM_ROP_TARGET_CFG_SYNDROME_01 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_ROP_TARGET_CFG_UNIT_IDLE ] ) ) 
       | ( ( cfg_req_ix[                         HQM_ROP_TARGET_CFG_UNIT_TIMEOUT ] ) ) 
       | ( ( cfg_req_ix[                         HQM_ROP_TARGET_CFG_UNIT_VERSION ] ) ) 
       ) begin 
       hqm_cfg_noidle = 1'b1; 
       end 
     end 
    endcase 
  end 
endfunction //hqm_cfg_noidle 

function automatic hqm_cfg_ram;
  input logic [( 4 )-1:0] node_id; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_write; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_read; 
  input cfg_req_t cfg_req; 
  logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_ix; 
  begin 

    cfg_req_ix = ( cfg_req_write | cfg_req_read ); 
    hqm_cfg_ram = 1'b0; 
    case ( node_id ) 
  HQM_AQED_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_BCAM ] ) ) 
       | ( ( cfg_req_ix[                  HQM_AQED_TARGET_CFG_AQED_QID_FID_LIMIT ] ) ) 
       | ( ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD0 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD1 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD2 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD3 ] ) ) 
       ) begin 
       hqm_cfg_ram = 1'b1; 
       end 
     end 
  HQM_AP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                  HQM_AP_TARGET_CFG_LDB_QID_RDYLST_CLAMP ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) ) 
       ) begin 
       hqm_cfg_ram = 1'b1; 
       end 
     end 
  HQM_MSTR_CFG_NODE_ID : begin
    if ( 1'b0 
       ) begin 
       hqm_cfg_ram = 1'b1; 
       end 
     end 
  HQM_CHP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL ] ) ) 
       | ( ( cfg_req_ix[                         HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH ] ) ) 
       | ( ( cfg_req_ix[               HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH ] ) ) 
       | ( ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_COUNT ] ) ) 
       | ( ( cfg_req_ix[               HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD ] ) ) 
       | ( ( cfg_req_ix[            HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT ] ) ) 
       | ( ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_DIR_CQ_WPTR ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_0 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_1 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_2 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_3 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_4 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_5 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_6 ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_7 ] ) ) 
       | ( ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_HIST_LIST_0 ] ) ) 
       | ( ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_HIST_LIST_1 ] ) ) 
       | ( ( cfg_req_ix[                        HQM_CHP_TARGET_CFG_HIST_LIST_A_0 ] ) ) 
       | ( ( cfg_req_ix[                        HQM_CHP_TARGET_CFG_HIST_LIST_A_1 ] ) ) 
       | ( ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE ] ) ) 
       | ( ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT ] ) ) 
       | ( ( cfg_req_ix[                  HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR ] ) ) 
       | ( ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR ] ) ) 
       | ( ( cfg_req_ix[                       HQM_CHP_TARGET_CFG_HIST_LIST_BASE ] ) ) 
       | ( ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT ] ) ) 
       | ( ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR ] ) ) 
       | ( ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR ] ) ) 
       | ( ( cfg_req_ix[                         HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH ] ) ) 
       | ( ( cfg_req_ix[               HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH ] ) ) 
       | ( ( cfg_req_ix[              HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD ] ) ) 
       | ( ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_COUNT ] ) ) 
       | ( ( cfg_req_ix[               HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD ] ) ) 
       | ( ( cfg_req_ix[            HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT ] ) ) 
       | ( ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_LDB_CQ_WPTR ] ) ) 
       | ( ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_ORD_QID_SN ] ) ) 
       | ( ( cfg_req_ix[                       HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP ] ) ) 
       ) begin 
       hqm_cfg_ram = 1'b1; 
       end 
     end 
  HQM_DP_CFG_NODE_ID : begin
    if ( 1'b0 
       ) begin 
       hqm_cfg_ram = 1'b1; 
       end 
     end 
  HQM_LSP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_ATM_QID_DPTH_THRSH ] ) ) 
       | ( ( cfg_req_ix[                             HQM_LSP_TARGET_CFG_CQ2PRIOV ] ) ) 
       | ( ( cfg_req_ix[                              HQM_LSP_TARGET_CFG_CQ2QID0 ] ) ) 
       | ( ( cfg_req_ix[                              HQM_LSP_TARGET_CFG_CQ2QID1 ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_COUNT ] ) ) 
       | ( ( cfg_req_ix[        HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI ] ) ) 
       | ( ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTH ] ) ) 
       | ( ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTL ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_COUNT ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_LIMIT ] ) ) 
       | ( ( cfg_req_ix[            HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_THRESHOLD ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_COUNT ] ) ) 
       | ( ( cfg_req_ix[            HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_DEPTH_SELECT ] ) ) 
       | ( ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTH ] ) ) 
       | ( ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTL ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_COUNT ] ) ) 
       | ( ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_LIMIT ] ) ) 
       | ( ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_DIR_QID_DPTH_THRSH ] ) ) 
       | ( ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_NALB_QID_DPTH_THRSH ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_COUNT ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_LIMIT ] ) ) 
       | ( ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_QID_ATM_ACTIVE ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTH ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTL ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_ATQ_ENQUEUE_COUNT ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_DIR_ENQUEUE_COUNT ] ) ) 
       | ( ( cfg_req_ix[                    HQM_LSP_TARGET_CFG_QID_DIR_MAX_DEPTH ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_REPLAY_COUNT ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTH ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTL ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_ENQUEUE_COUNT ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_COUNT ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_LIMIT ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_00 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_01 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_02 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_03 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_04 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_05 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_06 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_07 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_08 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_09 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_10 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_11 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_12 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_13 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_14 ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_15 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) ) 
       | ( ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) ) 
       | ( ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_LDB_REPLAY_COUNT ] ) ) 
       | ( ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_QID_NALDB_MAX_DEPTH ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTH ] ) ) 
       | ( ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTL ] ) ) 
       ) begin 
       hqm_cfg_ram = 1'b1; 
       end 
     end 
  HQM_NALB_CFG_NODE_ID : begin
    if ( 1'b0 
       ) begin 
       hqm_cfg_ram = 1'b1; 
       end 
     end 
  HQM_QED_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD0 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD1 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD2 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD3 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD0 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD1 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD2 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD3 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD0 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD1 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD2 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD3 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD0 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD1 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD2 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD3 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD0 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD1 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD2 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD3 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD0 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD1 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD2 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD3 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD0 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD1 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD2 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD3 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD0 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD1 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD2 ] ) ) 
       | ( ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD3 ] ) ) 
       ) begin 
       hqm_cfg_ram = 1'b1; 
       end 
     end 
  HQM_ROP_CFG_NODE_ID : begin
    if ( 1'b0 
       | ( ( cfg_req_ix[                     HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT ] ) ) 
       | ( ( cfg_req_ix[                     HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT ] ) ) 
       | ( ( cfg_req_ix[                    HQM_ROP_TARGET_CFG_REORDER_STATE_CNT ] ) ) 
       | ( ( cfg_req_ix[                 HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_HP ] ) ) 
       | ( ( cfg_req_ix[                 HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_TP ] ) ) 
       | ( ( cfg_req_ix[                HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_HP ] ) ) 
       | ( ( cfg_req_ix[                HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_TP ] ) ) 
       | ( ( cfg_req_ix[           HQM_ROP_TARGET_CFG_REORDER_STATE_QID_QIDIX_CQ ] ) ) 
       ) begin 
       hqm_cfg_ram = 1'b1; 
       end 
     end 
    endcase 
  end 
endfunction //hqm_cfg_ram 

function automatic [( 12 )-1:0] hqm_cfg_ram_minbit; 
  input logic [( 4 )-1:0] node_id; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_write; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_read; 
  input cfg_req_t cfg_req; 
  logic [( 12 )-1:0] minbit; 
  logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_ix; 
  begin 

    cfg_req_ix = ( cfg_req_write | cfg_req_read ); 
    minbit = 12'd0; 
  if ( node_id == HQM_AQED_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_BCAM ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                  HQM_AQED_TARGET_CFG_AQED_QID_FID_LIMIT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD1 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD2 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD3 ] ) begin
        minbit = 12'd96 ;
     end 
    end 
  if ( node_id == HQM_AP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                  HQM_AP_TARGET_CFG_LDB_QID_RDYLST_CLAMP ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) begin
        minbit = 12'd96 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) begin
        minbit = 12'd128 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) begin
        minbit = 12'd160 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) begin
        minbit = 12'd192 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) begin
        minbit = 12'd224 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) begin
        minbit = 12'd256 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) begin
        minbit = 12'd288 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) begin
        minbit = 12'd320 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) begin
        minbit = 12'd352 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) begin
        minbit = 12'd384 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) begin
        minbit = 12'd416 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) begin
        minbit = 12'd448 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) begin
        minbit = 12'd480 ;
     end 
    end 
  if ( node_id == HQM_MSTR_CFG_NODE_ID ) begin
        minbit = 0;
    end 
  if ( node_id == HQM_CHP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                         HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[            HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_DIR_CQ_WPTR ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_1 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_2 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_3 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_4 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_5 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_6 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_7 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_HIST_LIST_0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_HIST_LIST_1 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                        HQM_CHP_TARGET_CFG_HIST_LIST_A_0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                        HQM_CHP_TARGET_CFG_HIST_LIST_A_1 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT ] ) begin
        minbit = 12'd15 ;
     end 
     if ( cfg_req_ix[                  HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR ] ) begin
        minbit = 12'd16 ;
     end 
     if ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                       HQM_CHP_TARGET_CFG_HIST_LIST_BASE ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT ] ) begin
        minbit = 12'd15 ;
     end 
     if ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR ] ) begin
        minbit = 12'd16 ;
     end 
     if ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                         HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[              HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[            HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_LDB_CQ_WPTR ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_ORD_QID_SN ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                       HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP ] ) begin
        minbit = 12'd0 ;
     end 
    end 
  if ( node_id == HQM_DP_CFG_NODE_ID ) begin
        minbit = 0;
    end 
  if ( node_id == HQM_LSP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_ATM_QID_DPTH_THRSH ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                             HQM_LSP_TARGET_CFG_CQ2PRIOV ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                              HQM_LSP_TARGET_CFG_CQ2QID0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                              HQM_LSP_TARGET_CFG_CQ2QID1 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[        HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTH ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTL ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_LIMIT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[            HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_THRESHOLD ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[            HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_DEPTH_SELECT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTH ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTL ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_LIMIT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_DIR_QID_DPTH_THRSH ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_NALB_QID_DPTH_THRSH ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_LIMIT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_QID_ATM_ACTIVE ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTH ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTL ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_ATQ_ENQUEUE_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_DIR_ENQUEUE_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                    HQM_LSP_TARGET_CFG_QID_DIR_MAX_DEPTH ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_REPLAY_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTH ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTL ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_ENQUEUE_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_LIMIT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_00 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_01 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_02 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_03 ] ) begin
        minbit = 12'd96 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_04 ] ) begin
        minbit = 12'd128 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_05 ] ) begin
        minbit = 12'd160 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_06 ] ) begin
        minbit = 12'd192 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_07 ] ) begin
        minbit = 12'd224 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_08 ] ) begin
        minbit = 12'd256 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_09 ] ) begin
        minbit = 12'd288 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_10 ] ) begin
        minbit = 12'd320 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_11 ] ) begin
        minbit = 12'd352 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_12 ] ) begin
        minbit = 12'd384 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_13 ] ) begin
        minbit = 12'd416 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_14 ] ) begin
        minbit = 12'd448 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_15 ] ) begin
        minbit = 12'd480 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) begin
        minbit = 12'd96 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) begin
        minbit = 12'd128 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) begin
        minbit = 12'd160 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) begin
        minbit = 12'd192 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) begin
        minbit = 12'd224 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) begin
        minbit = 12'd256 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) begin
        minbit = 12'd288 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) begin
        minbit = 12'd320 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) begin
        minbit = 12'd352 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) begin
        minbit = 12'd384 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) begin
        minbit = 12'd416 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) begin
        minbit = 12'd448 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) begin
        minbit = 12'd480 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_LDB_REPLAY_COUNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_QID_NALDB_MAX_DEPTH ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTH ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTL ] ) begin
        minbit = 12'd0 ;
     end 
    end 
  if ( node_id == HQM_NALB_CFG_NODE_ID ) begin
        minbit = 0;
    end 
  if ( node_id == HQM_QED_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD1 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD2 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD3 ] ) begin
        minbit = 12'd96 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD1 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD2 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD3 ] ) begin
        minbit = 12'd96 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD1 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD2 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD3 ] ) begin
        minbit = 12'd96 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD1 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD2 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD3 ] ) begin
        minbit = 12'd96 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD1 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD2 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD3 ] ) begin
        minbit = 12'd96 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD1 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD2 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD3 ] ) begin
        minbit = 12'd96 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD1 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD2 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD3 ] ) begin
        minbit = 12'd96 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD0 ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD1 ] ) begin
        minbit = 12'd32 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD2 ] ) begin
        minbit = 12'd64 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD3 ] ) begin
        minbit = 12'd96 ;
     end 
    end 
  if ( node_id == HQM_ROP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                     HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                     HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                    HQM_ROP_TARGET_CFG_REORDER_STATE_CNT ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                 HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_HP ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                 HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_TP ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_HP ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_TP ] ) begin
        minbit = 12'd0 ;
     end 
     if ( cfg_req_ix[           HQM_ROP_TARGET_CFG_REORDER_STATE_QID_QIDIX_CQ ] ) begin
        minbit = 12'd0 ;
     end 
    end 
  end 
  return minbit ;
endfunction //hqm_cfg_ram_minbit 

function automatic [( 12 )-1:0] hqm_cfg_ram_maxbit; 
  input logic [( 4 )-1:0] node_id; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_write; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_read; 
  input cfg_req_t cfg_req; 
  logic [( 12 )-1:0] maxbit; 
  logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_ix; 
  begin 

    cfg_req_ix = ( cfg_req_write | cfg_req_read ); 
    maxbit = 12'd0; 
  if ( node_id == HQM_AQED_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_BCAM ] ) begin
        maxbit = 12'd25 ;
     end 
     if ( cfg_req_ix[                  HQM_AQED_TARGET_CFG_AQED_QID_FID_LIMIT ] ) begin
        maxbit = 12'd12 ;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD0 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD1 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD2 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD3 ] ) begin
        maxbit = 12'd111 ;
     end 
    end 
  if ( node_id == HQM_AP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                  HQM_AP_TARGET_CFG_LDB_QID_RDYLST_CLAMP ] ) begin
        maxbit = 12'd4 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) begin
        maxbit = 12'd127 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) begin
        maxbit = 12'd159 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) begin
        maxbit = 12'd191 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) begin
        maxbit = 12'd223 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) begin
        maxbit = 12'd255 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) begin
        maxbit = 12'd287 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) begin
        maxbit = 12'd319 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) begin
        maxbit = 12'd351 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) begin
        maxbit = 12'd383 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) begin
        maxbit = 12'd415 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) begin
        maxbit = 12'd447 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) begin
        maxbit = 12'd479 ;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) begin
        maxbit = 12'd511 ;
     end 
    end 
  if ( node_id == HQM_MSTR_CFG_NODE_ID ) begin
        maxbit = 0;
    end 
  if ( node_id == HQM_CHP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL ] ) begin
        maxbit = 12'd0 ;
     end 
     if ( cfg_req_ix[                         HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH ] ) begin
        maxbit = 12'd12 ;
     end 
     if ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_COUNT ] ) begin
        maxbit = 12'd13 ;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD ] ) begin
        maxbit = 12'd13 ;
     end 
     if ( cfg_req_ix[            HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT ] ) begin
        maxbit = 12'd3 ;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_DIR_CQ_WPTR ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_0 ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_1 ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_2 ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_3 ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_4 ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_5 ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_6 ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_7 ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_HIST_LIST_0 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_HIST_LIST_1 ] ) begin
        maxbit = 12'd57 ;
     end 
     if ( cfg_req_ix[                        HQM_CHP_TARGET_CFG_HIST_LIST_A_0 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                        HQM_CHP_TARGET_CFG_HIST_LIST_A_1 ] ) begin
        maxbit = 12'd57 ;
     end 
     if ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE ] ) begin
        maxbit = 12'd12 ;
     end 
     if ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT ] ) begin
        maxbit = 12'd27 ;
     end 
     if ( cfg_req_ix[                  HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR ] ) begin
        maxbit = 12'd29 ;
     end 
     if ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR ] ) begin
        maxbit = 12'd13 ;
     end 
     if ( cfg_req_ix[                       HQM_CHP_TARGET_CFG_HIST_LIST_BASE ] ) begin
        maxbit = 12'd12 ;
     end 
     if ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT ] ) begin
        maxbit = 12'd27 ;
     end 
     if ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR ] ) begin
        maxbit = 12'd29 ;
     end 
     if ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR ] ) begin
        maxbit = 12'd13 ;
     end 
     if ( cfg_req_ix[                         HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[              HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD ] ) begin
        maxbit = 12'd29 ;
     end 
     if ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_COUNT ] ) begin
        maxbit = 12'd13 ;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD ] ) begin
        maxbit = 12'd13 ;
     end 
     if ( cfg_req_ix[            HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT ] ) begin
        maxbit = 12'd3 ;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_LDB_CQ_WPTR ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_ORD_QID_SN ] ) begin
        maxbit = 12'd9 ;
     end 
     if ( cfg_req_ix[                       HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP ] ) begin
        maxbit = 12'd9 ;
     end 
    end 
  if ( node_id == HQM_DP_CFG_NODE_ID ) begin
        maxbit = 0;
    end 
  if ( node_id == HQM_LSP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_ATM_QID_DPTH_THRSH ] ) begin
        maxbit = 12'd14 ;
     end 
     if ( cfg_req_ix[                             HQM_LSP_TARGET_CFG_CQ2PRIOV ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                              HQM_LSP_TARGET_CFG_CQ2QID0 ] ) begin
        maxbit = 12'd27 ;
     end 
     if ( cfg_req_ix[                              HQM_LSP_TARGET_CFG_CQ2QID1 ] ) begin
        maxbit = 12'd27 ;
     end 
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_COUNT ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[        HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI ] ) begin
        maxbit = 12'd5 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTH ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTL ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_COUNT ] ) begin
        maxbit = 12'd12 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_LIMIT ] ) begin
        maxbit = 12'd12 ;
     end 
     if ( cfg_req_ix[            HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_THRESHOLD ] ) begin
        maxbit = 12'd12 ;
     end 
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_COUNT ] ) begin
        maxbit = 12'd10 ;
     end 
     if ( cfg_req_ix[            HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_DEPTH_SELECT ] ) begin
        maxbit = 12'd3 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTH ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTL ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_COUNT ] ) begin
        maxbit = 12'd16 ;
     end 
     if ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_LIMIT ] ) begin
        maxbit = 12'd15 ;
     end 
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_DIR_QID_DPTH_THRSH ] ) begin
        maxbit = 12'd14 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_NALB_QID_DPTH_THRSH ] ) begin
        maxbit = 12'd14 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_COUNT ] ) begin
        maxbit = 12'd11 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_LIMIT ] ) begin
        maxbit = 12'd11 ;
     end 
     if ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_QID_ATM_ACTIVE ] ) begin
        maxbit = 12'd14 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTH ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTL ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_ATQ_ENQUEUE_COUNT ] ) begin
        maxbit = 12'd13 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_DIR_ENQUEUE_COUNT ] ) begin
        maxbit = 12'd12 ;
     end 
     if ( cfg_req_ix[                    HQM_LSP_TARGET_CFG_QID_DIR_MAX_DEPTH ] ) begin
        maxbit = 12'd12 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_REPLAY_COUNT ] ) begin
        maxbit = 12'd13 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTH ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTL ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_ENQUEUE_COUNT ] ) begin
        maxbit = 12'd13 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_COUNT ] ) begin
        maxbit = 12'd11 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_LIMIT ] ) begin
        maxbit = 12'd11 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_00 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_01 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_02 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_03 ] ) begin
        maxbit = 12'd127 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_04 ] ) begin
        maxbit = 12'd159 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_05 ] ) begin
        maxbit = 12'd191 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_06 ] ) begin
        maxbit = 12'd223 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_07 ] ) begin
        maxbit = 12'd255 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_08 ] ) begin
        maxbit = 12'd287 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_09 ] ) begin
        maxbit = 12'd319 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_10 ] ) begin
        maxbit = 12'd351 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_11 ] ) begin
        maxbit = 12'd383 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_12 ] ) begin
        maxbit = 12'd415 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_13 ] ) begin
        maxbit = 12'd447 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_14 ] ) begin
        maxbit = 12'd479 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_15 ] ) begin
        maxbit = 12'd511 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) begin
        maxbit = 12'd127 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) begin
        maxbit = 12'd159 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) begin
        maxbit = 12'd191 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) begin
        maxbit = 12'd223 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) begin
        maxbit = 12'd255 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) begin
        maxbit = 12'd287 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) begin
        maxbit = 12'd319 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) begin
        maxbit = 12'd351 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) begin
        maxbit = 12'd383 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) begin
        maxbit = 12'd415 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) begin
        maxbit = 12'd447 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) begin
        maxbit = 12'd479 ;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) begin
        maxbit = 12'd511 ;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_LDB_REPLAY_COUNT ] ) begin
        maxbit = 12'd15 ;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_QID_NALDB_MAX_DEPTH ] ) begin
        maxbit = 12'd13 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTH ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTL ] ) begin
        maxbit = 12'd31 ;
     end 
    end 
  if ( node_id == HQM_NALB_CFG_NODE_ID ) begin
        maxbit = 0;
    end 
  if ( node_id == HQM_QED_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD0 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD1 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD2 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD3 ] ) begin
        maxbit = 12'd122 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD0 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD1 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD2 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD3 ] ) begin
        maxbit = 12'd122 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD0 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD1 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD2 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD3 ] ) begin
        maxbit = 12'd122 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD0 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD1 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD2 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD3 ] ) begin
        maxbit = 12'd122 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD0 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD1 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD2 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD3 ] ) begin
        maxbit = 12'd122 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD0 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD1 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD2 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD3 ] ) begin
        maxbit = 12'd122 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD0 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD1 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD2 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD3 ] ) begin
        maxbit = 12'd122 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD0 ] ) begin
        maxbit = 12'd31 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD1 ] ) begin
        maxbit = 12'd63 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD2 ] ) begin
        maxbit = 12'd95 ;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD3 ] ) begin
        maxbit = 12'd122 ;
     end 
    end 
  if ( node_id == HQM_ROP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                     HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT ] ) begin
        maxbit = 12'd9 ;
     end 
     if ( cfg_req_ix[                     HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT ] ) begin
        maxbit = 12'd9 ;
     end 
     if ( cfg_req_ix[                    HQM_ROP_TARGET_CFG_REORDER_STATE_CNT ] ) begin
        maxbit = 12'd23 ;
     end 
     if ( cfg_req_ix[                 HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_HP ] ) begin
        maxbit = 12'd23 ;
     end 
     if ( cfg_req_ix[                 HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_TP ] ) begin
        maxbit = 12'd23 ;
     end 
     if ( cfg_req_ix[                HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_HP ] ) begin
        maxbit = 12'd27 ;
     end 
     if ( cfg_req_ix[                HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_TP ] ) begin
        maxbit = 12'd23 ;
     end 
     if ( cfg_req_ix[           HQM_ROP_TARGET_CFG_REORDER_STATE_QID_QIDIX_CQ ] ) begin
        maxbit = 12'd23 ;
     end 
    end 
  end 
  return maxbit ;
endfunction //hqm_cfg_ram_maxbit 

// END HQM_INFO_CFG
//------------------------------------------------------------------------------------------------------------------------
// BEGIN HQM_CFG_RAM_INDEX
function automatic [( 8 )-1:0] hqm_cfg_ram_index; 
  input logic [( 4 )-1:0] node_id; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_write; 
  input logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_read; 
  input cfg_req_t cfg_req; 
  logic [( 8 )-1:0] ram_index; 
  logic [( MAX_CFG_UNIT_NUM_TGTS )-1:0] cfg_req_ix; 
  begin 

    cfg_req_ix = ( cfg_req_write | cfg_req_read ); 
    ram_index = 8'd0; 
  if ( node_id == HQM_AQED_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_BCAM ] ) begin
        ram_index = 8'd2;
     end 
     if ( cfg_req_ix[                  HQM_AQED_TARGET_CFG_AQED_QID_FID_LIMIT ] ) begin
        ram_index = 8'd1;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD0 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD1 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD2 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                           HQM_AQED_TARGET_CFG_AQED_WRD3 ] ) begin
        ram_index = 8'd0;
     end 
    end 
  if ( node_id == HQM_CHP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL ] ) begin
        ram_index = 8'd10;
     end 
     if ( cfg_req_ix[                         HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH ] ) begin
        ram_index = 8'd14;
     end 
     if ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_COUNT ] ) begin
        ram_index = 8'd11;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD ] ) begin
        ram_index = 8'd28;
     end 
     if ( cfg_req_ix[            HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT ] ) begin
        ram_index = 8'd15;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_DIR_CQ_WPTR ] ) begin
        ram_index = 8'd16;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_0 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_1 ] ) begin
        ram_index = 8'd1;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_2 ] ) begin
        ram_index = 8'd2;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_3 ] ) begin
        ram_index = 8'd3;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_4 ] ) begin
        ram_index = 8'd4;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_5 ] ) begin
        ram_index = 8'd5;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_6 ] ) begin
        ram_index = 8'd6;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_FREELIST_7 ] ) begin
        ram_index = 8'd7;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_HIST_LIST_0 ] ) begin
        ram_index = 8'd8;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_HIST_LIST_1 ] ) begin
        ram_index = 8'd8;
     end 
     if ( cfg_req_ix[                        HQM_CHP_TARGET_CFG_HIST_LIST_A_0 ] ) begin
        ram_index = 8'd9;
     end 
     if ( cfg_req_ix[                        HQM_CHP_TARGET_CFG_HIST_LIST_A_1 ] ) begin
        ram_index = 8'd9;
     end 
     if ( cfg_req_ix[                     HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE ] ) begin
        ram_index = 8'd17;
     end 
     if ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT ] ) begin
        ram_index = 8'd17;
     end 
     if ( cfg_req_ix[                  HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR ] ) begin
        ram_index = 8'd18;
     end 
     if ( cfg_req_ix[                 HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR ] ) begin
        ram_index = 8'd18;
     end 
     if ( cfg_req_ix[                       HQM_CHP_TARGET_CFG_HIST_LIST_BASE ] ) begin
        ram_index = 8'd19;
     end 
     if ( cfg_req_ix[                      HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT ] ) begin
        ram_index = 8'd19;
     end 
     if ( cfg_req_ix[                    HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR ] ) begin
        ram_index = 8'd20;
     end 
     if ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR ] ) begin
        ram_index = 8'd20;
     end 
     if ( cfg_req_ix[                         HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH ] ) begin
        ram_index = 8'd21;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH ] ) begin
        ram_index = 8'd22;
     end 
     if ( cfg_req_ix[              HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD ] ) begin
        ram_index = 8'd23;
     end 
     if ( cfg_req_ix[                   HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_COUNT ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD ] ) begin
        ram_index = 8'd29;
     end 
     if ( cfg_req_ix[            HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT ] ) begin
        ram_index = 8'd24;
     end 
     if ( cfg_req_ix[                          HQM_CHP_TARGET_CFG_LDB_CQ_WPTR ] ) begin
        ram_index = 8'd25;
     end 
     if ( cfg_req_ix[                           HQM_CHP_TARGET_CFG_ORD_QID_SN ] ) begin
        ram_index = 8'd26;
     end 
     if ( cfg_req_ix[                       HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP ] ) begin
        ram_index = 8'd27;
     end 
    end 
  if ( node_id == HQM_LSP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_ATM_QID_DPTH_THRSH ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                             HQM_LSP_TARGET_CFG_CQ2PRIOV ] ) begin
        ram_index = 8'd1;
     end 
     if ( cfg_req_ix[                              HQM_LSP_TARGET_CFG_CQ2QID0 ] ) begin
        ram_index = 8'd2;
     end 
     if ( cfg_req_ix[                              HQM_LSP_TARGET_CFG_CQ2QID1 ] ) begin
        ram_index = 8'd3;
     end 
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_COUNT ] ) begin
        ram_index = 8'd20;
     end 
     if ( cfg_req_ix[        HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI ] ) begin
        ram_index = 8'd21;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTH ] ) begin
        ram_index = 8'd14;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTL ] ) begin
        ram_index = 8'd14;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_COUNT ] ) begin
        ram_index = 8'd15;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_LIMIT ] ) begin
        ram_index = 8'd4;
     end 
     if ( cfg_req_ix[            HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_THRESHOLD ] ) begin
        ram_index = 8'd5;
     end 
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_COUNT ] ) begin
        ram_index = 8'd16;
     end 
     if ( cfg_req_ix[            HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_DEPTH_SELECT ] ) begin
        ram_index = 8'd6;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTH ] ) begin
        ram_index = 8'd17;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTL ] ) begin
        ram_index = 8'd17;
     end 
     if ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_COUNT ] ) begin
        ram_index = 8'd18;
     end 
     if ( cfg_req_ix[                      HQM_LSP_TARGET_CFG_CQ_LDB_WU_LIMIT ] ) begin
        ram_index = 8'd7;
     end 
     if ( cfg_req_ix[                   HQM_LSP_TARGET_CFG_DIR_QID_DPTH_THRSH ] ) begin
        ram_index = 8'd8;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_NALB_QID_DPTH_THRSH ] ) begin
        ram_index = 8'd9;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_COUNT ] ) begin
        ram_index = 8'd22;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_LIMIT ] ) begin
        ram_index = 8'd10;
     end 
     if ( cfg_req_ix[                       HQM_LSP_TARGET_CFG_QID_ATM_ACTIVE ] ) begin
        ram_index = 8'd23;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTH ] ) begin
        ram_index = 8'd24;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTL ] ) begin
        ram_index = 8'd24;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_ATQ_ENQUEUE_COUNT ] ) begin
        ram_index = 8'd25;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_DIR_ENQUEUE_COUNT ] ) begin
        ram_index = 8'd19;
     end 
     if ( cfg_req_ix[                    HQM_LSP_TARGET_CFG_QID_DIR_MAX_DEPTH ] ) begin
        ram_index = 8'd26;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_REPLAY_COUNT ] ) begin
        ram_index = 8'd27;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTH ] ) begin
        ram_index = 8'd28;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTL ] ) begin
        ram_index = 8'd28;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_ENQUEUE_COUNT ] ) begin
        ram_index = 8'd29;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_COUNT ] ) begin
        ram_index = 8'd30;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_LIMIT ] ) begin
        ram_index = 8'd11;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_00 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_01 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_02 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_03 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_04 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_05 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_06 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_07 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_08 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_09 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_10 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_11 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_12 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_13 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_14 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_15 ] ) begin
        ram_index = 8'd12;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) begin
        ram_index = 8'd13;
     end 
     if ( cfg_req_ix[                 HQM_LSP_TARGET_CFG_QID_LDB_REPLAY_COUNT ] ) begin
        ram_index = 8'd31;
     end 
     if ( cfg_req_ix[                  HQM_LSP_TARGET_CFG_QID_NALDB_MAX_DEPTH ] ) begin
        ram_index = 8'd32;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTH ] ) begin
        ram_index = 8'd33;
     end 
     if ( cfg_req_ix[               HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTL ] ) begin
        ram_index = 8'd33;
     end 
    end 
  if ( node_id == HQM_AP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                  HQM_AP_TARGET_CFG_LDB_QID_RDYLST_CLAMP ] ) begin
        ram_index = 8'd1;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_AP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 ] ) begin
        ram_index = 8'd0;
     end 
    end 
  if ( node_id == HQM_QED_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD0 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD1 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD2 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED0_WRD3 ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD0 ] ) begin
        ram_index = 8'd1;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD1 ] ) begin
        ram_index = 8'd1;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD2 ] ) begin
        ram_index = 8'd1;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED1_WRD3 ] ) begin
        ram_index = 8'd1;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD0 ] ) begin
        ram_index = 8'd2;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD1 ] ) begin
        ram_index = 8'd2;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD2 ] ) begin
        ram_index = 8'd2;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED2_WRD3 ] ) begin
        ram_index = 8'd2;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD0 ] ) begin
        ram_index = 8'd3;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD1 ] ) begin
        ram_index = 8'd3;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD2 ] ) begin
        ram_index = 8'd3;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED3_WRD3 ] ) begin
        ram_index = 8'd3;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD0 ] ) begin
        ram_index = 8'd4;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD1 ] ) begin
        ram_index = 8'd4;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD2 ] ) begin
        ram_index = 8'd4;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED4_WRD3 ] ) begin
        ram_index = 8'd4;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD0 ] ) begin
        ram_index = 8'd5;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD1 ] ) begin
        ram_index = 8'd5;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD2 ] ) begin
        ram_index = 8'd5;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED5_WRD3 ] ) begin
        ram_index = 8'd5;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD0 ] ) begin
        ram_index = 8'd6;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD1 ] ) begin
        ram_index = 8'd6;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD2 ] ) begin
        ram_index = 8'd6;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED6_WRD3 ] ) begin
        ram_index = 8'd6;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD0 ] ) begin
        ram_index = 8'd7;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD1 ] ) begin
        ram_index = 8'd7;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD2 ] ) begin
        ram_index = 8'd7;
     end 
     if ( cfg_req_ix[                            HQM_QED_TARGET_CFG_QED7_WRD3 ] ) begin
        ram_index = 8'd7;
     end 
    end 
  if ( node_id == HQM_ROP_CFG_NODE_ID ) begin
     if ( cfg_req_ix[                     HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT ] ) begin
        ram_index = 8'd6;
     end 
     if ( cfg_req_ix[                     HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT ] ) begin
        ram_index = 8'd7;
     end 
     if ( cfg_req_ix[                    HQM_ROP_TARGET_CFG_REORDER_STATE_CNT ] ) begin
        ram_index = 8'd0;
     end 
     if ( cfg_req_ix[                 HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_HP ] ) begin
        ram_index = 8'd1;
     end 
     if ( cfg_req_ix[                 HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_TP ] ) begin
        ram_index = 8'd2;
     end 
     if ( cfg_req_ix[                HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_HP ] ) begin
        ram_index = 8'd3;
     end 
     if ( cfg_req_ix[                HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_TP ] ) begin
        ram_index = 8'd4;
     end 
     if ( cfg_req_ix[           HQM_ROP_TARGET_CFG_REORDER_STATE_QID_QIDIX_CQ ] ) begin
        ram_index = 8'd5;
     end 
    end 
  end 
  return ram_index;
endfunction //hqm_cfg_ram_index 

// END HQM_CFG_RAM_INDEX
//------------------------------------------------------------------------------------------------------------------------

localparam HQM_CHP_UNIT_VERSION                 = 8'h00 ;
localparam INBOUND_HCW_ID_WIDTH                 = HCW_ENQ_ID_WIDTH ;
localparam INBOUND_HCW_ADDR_WIDTH               = HCW_ENQ_ADDR_WIDTH ;
localparam INBOUND_HCW_DATA_WIDTH               = HCW_ENQ_DATA_WIDTH ;
localparam INBOUND_HCW_AWUSER_WIDTH             = $bits ( hcw_enq_aw_req_awuser_t ) ;
localparam INBOUND_HCW_WUSER_WIDTH              = $bits ( hcw_enq_w_req_wuser_t ) ;
localparam INBOUND_HCW_BUSER_WIDTH              = HCW_ENQ_BUSER_WIDTH ;

localparam OUTBOUND_HCW_ID_WIDTH                = HCW_SCHED_ID_WIDTH ;
localparam OUTBOUND_HCW_ADDR_WIDTH              = HCW_SCHED_ADDR_WIDTH ;
localparam OUTBOUND_HCW_DATA_WIDTH              = HCW_SCHED_DATA_WIDTH ;
localparam OUTBOUND_HCW_AWUSER_WIDTH            = $bits ( hcw_sched_aw_req_awuser_t ) ;
localparam OUTBOUND_HCW_WUSER_WIDTH             = $bits ( hcw_sched_w_req_wuser_t ) ;
localparam OUTBOUND_HCW_BUSER_WIDTH             = HCW_SCHED_BUSER_WIDTH ;

localparam DQED_REPLAY_DB_DATA_WIDTH            = $bits(dqed_chp_sch_t) ;
localparam QED_REPLAY_DB_DATA_WIDTH             = $bits(qed_chp_sch_t) ;
localparam AQED_TO_CQ_DB_DATA_WIDTH             = $bits(aqed_chp_sch_t) ;


localparam HQM_CHP_DQED_DEPTH_IMPLEMENTED = HQM_CHP_DQED_DEPTH/2 ;

localparam CFG_CONTROL_GENERAL_00_DEFAULT = {1'd0
                                            ,3'h4
                                            ,4'h8
                                            ,4'h8
                                            ,5'h10
                                            ,5'h10
                                            ,5'h10
                                            ,5'h10
                                            };
localparam CFG_CONTROL_GENERAL_01_DEFAULT = {28'h0
                                            ,1'b0
                                            ,1'b0
                                            ,1'b0
                                            ,1'b0
                                            };

localparam CFG_CONTROL_GENERAL_02_DEFAULT = {32'h0
                                             };

localparam CFG_CONTROL_GENERAL_03_DEFAULT = {32'h0
                                             };

localparam CFG_CONTROL_GENERAL_04_DEFAULT = {32'h0
                                             };

localparam CFG_CONTROL_GENERAL_05_DEFAULT = {32'h0
                                             };

localparam CFG_CONTROL_GENERAL_06_DEFAULT = {30'h0
                                            ,1'b0
                                            ,1'b1
                                             };

localparam CFG_CONTROL_GENERAL_07_DEFAULT = {32'h0
                                             };

localparam CFG_CSR_CONTROL_DEFAULT = { 32'h00180002 };
localparam CFG_PALB_CONTROL_DEFAULT = { 32'h00000008 };

localparam HQM_DQED_CFG_CONTROL_PIPE_CREDITS_DEFAULT = { 32'h00000008 } ;

localparam HQM_QED_CFG_CONTROL_PIPE_CREDITS_DEFAULT = { 32'h00000088 } ;

localparam INBOUND_ID_WIDTH                     = 20 ;
localparam INBOUND_DATA_WIDTH                   = 20 ;
localparam INBOUND_WUSER_WIDTH                  = 20 ;

localparam WSLAVE_AW_DATA_WIDTH                 = INBOUND_HCW_ID_WIDTH + INBOUND_HCW_ADDR_WIDTH + INBOUND_HCW_AWUSER_WIDTH ;
localparam WSLAVE_W_DATA_WIDTH                  = INBOUND_HCW_ID_WIDTH + INBOUND_HCW_DATA_WIDTH + INBOUND_HCW_WUSER_WIDTH ;

localparam WMASTER_AW_DATA_WIDTH                = OUTBOUND_HCW_ID_WIDTH + OUTBOUND_HCW_ADDR_WIDTH + OUTBOUND_HCW_AWUSER_WIDTH ;
localparam WMASTER_W_DATA_WIDTH                 = OUTBOUND_HCW_ID_WIDTH + OUTBOUND_HCW_DATA_WIDTH + OUTBOUND_HCW_WUSER_WIDTH ;
localparam WMASTER_B_DATA_WIDTH                 = OUTBOUND_HCW_ID_WIDTH + 2 + OUTBOUND_HCW_WUSER_WIDTH ;

typedef enum logic [ 4 : 0 ] {
  HQM_PMSM_RUN         = 5'b00001
, HQM_PMSM_IF_OFF      = 5'b00010
, HQM_PMSM_WAIT_ACK    = 5'b00100
, HQM_PMSM_PWR_OFF     = 5'b01000
, HQM_PMSM_PWR_ON      = 5'b10000
} pmsm_t;

typedef struct packed {
     logic       spare ;                              // visa_hqm_pmsm[31]
     logic       cfg_pm_status_pgcb_fet_en_b ;        // visa_hqm_pmsm[30]
     logic       cfg_pm_status_pmc_pgcb_fet_en_b ;    // visa_hqm_pmsm[29]
     logic       cfg_pm_status_pmc_pgcb_pg_ack_b ;    // visa_hqm_pmsm[28]
     logic       cfg_pm_status_pgcb_pmc_pg_req_b ;    // visa_hqm_pmsm[27]
     logic       cfg_pm_status_PMSM_PGCB_REQ_B ;      // visa_hqm_pmsm[26]
     logic       cfg_pm_status_PGCB_HQM_PG_RDY_ACK_B ;// visa_hqm_pmsm[25]
     logic       cfg_pm_status_PGCB_HQM_IDLE ;        // visa_hqm_pmsm[24]
     logic [2:0] prdata_2_0;         // visa_hqm_pmsm[23:21]
     logic       pready;             // visa_hqm_pmsm[20]
     logic [3:0] paddr_31_28;        // visa_hqm_pmsm[19:16]
     logic       pwrite;             // visa_hqm_pmsm[16]
     logic       penable;            // visa_hqm_pmsm[15]
     logic       pgcb_hqm_idle;      // visa_hqm_pmsm[14]
     logic       not_hqm_in_d3;      // visa_hqm_pmsm[13]
     logic       hqm_in_d3;          // visa_hqm_pmsm[12]
     logic       go_off;             // visa_hqm_pmsm[11]
     logic       go_on;              // visa_hqm_pmsm[10]
     logic       pmsm_shields_up;    // visa_hqm_pmsm[9]
     logic       pm_fsm_d0tod3_ok;   // visa_hqm_pmsm[8]
     logic       pm_fsm_d3tod0_ok;   // visa_hqm_pmsm[7]
     logic       pmsm_pgcb_req_b;    // visa_hqm_pmsm[6]
     logic [4:0] PMSM;               // visa_hqm_pmsm[4:0]

} pmsm_visa_t;

typedef struct packed {
    logic        cdc_gclk_en_err;
    logic        hqm_in_d3;
    logic        hqm_not_in_d3;
    logic        PROCHOT;
    logic [4:0]  PMSM;
   // SAPMA intf
    logic        pmc_hqm_pg_wake;
    logic        pmc_pgcb_pg_ack_b;
    logic        pgcb_pmc_pg_req_b;
   // iRC intf
    logic        irc_pgcb_pg_ack_b;
    logic        pgcb_irc_pg_req_b;
   // PMSM/PGCB
    logic        pmsm_pgcb_req_b;
    logic        pmsm_shields_up;
} hqm_prim_free_clk_utrigger_t;

localparam BITS_HQM_PRIM_FREE_CLK_UTRIGGER_T = $bits(hqm_prim_free_clk_utrigger_t);

typedef struct packed {
   logic      reserved;
   // CDC/PGCB
   logic      pgcb_hqm_pok;
   logic      pgcb_force_rst_b;
   logic      pgcb_restore;
   logic      pgcb_pwrgate_active;
   // PGCB/FET
   logic      pgcb_fet_en_b;
   logic      pmc_pgcb_fet_en_b;
} hqm_pgcb_clk_utrigger_t;

localparam BITS_HQM_PGCB_CLK_UTRIGGER_T = $bits(hqm_pgcb_clk_utrigger_t);

endpackage :  hqm_core_pkg
