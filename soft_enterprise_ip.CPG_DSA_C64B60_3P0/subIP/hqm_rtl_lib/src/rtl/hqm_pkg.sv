//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
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
//-----------------------------------------------------------------------------------------------------
// hqm_pkg
//
// Package for common structures, enums, functions, parameters, ... for HQM
//-----------------------------------------------------------------------------------------------------

package hqm_pkg;

parameter NUM_CREDITS                   = 16384 ;
parameter NUM_CREDITS_BANKS             = 8 ;
parameter NUM_CREDITS_PBANK             = NUM_CREDITS/NUM_CREDITS_BANKS ;
parameter NUM_DIR_QID                   = 64 ;
parameter NUM_DIR_CQ                    = NUM_DIR_QID ;
parameter NUM_DIR_PP                    = NUM_DIR_CQ ;
parameter NUM_LDB_QID                   = 32 ;
parameter NUM_LDB_CQ                    = 64 ;
parameter NUM_LDB_PP                    = NUM_LDB_CQ ;
parameter NUM_VAS                       = 32 ;
parameter NUM_VF                        = 16;
parameter NUM_VDEV                      = 16;

// collage-pragma translate_off

import hqm_AW_pkg::*;

parameter CREDITS_WIDTH                 = AW_logb2(NUM_CREDITS - 1) + 1 ;
parameter DIR_QID_WIDTH                 = AW_logb2(NUM_DIR_QID - 1) + 1 ;
parameter DIR_QID_ARCH_WIDTH            = AW_logb2(256 - 1) + 1 ;
parameter DIR_CQ_WIDTH                  = AW_logb2(NUM_DIR_CQ - 1) + 1 ;
parameter DIR_CQ_ARCH_WIDTH             = AW_logb2(256 - 1) + 1 ;
parameter DIR_PP_WIDTH                  = AW_logb2(NUM_DIR_PP - 1) + 1 ;
parameter DIR_PP_ARCH_WIDTH             = AW_logb2(256 - 1) + 1 ;
parameter LDB_QID_WIDTH                 = AW_logb2(NUM_LDB_QID - 1) + 1 ;
parameter LDB_QID_ARCH_WIDTH            = AW_logb2(256 - 1) + 1 ;
parameter LDB_CQ_WIDTH                  = AW_logb2(NUM_LDB_CQ - 1) + 1 ;
parameter LDB_CQ_ARCH_WIDTH             = AW_logb2(256 - 1) + 1 ;
parameter LDB_PP_WIDTH                  = AW_logb2(NUM_LDB_PP - 1) + 1 ;
parameter LDB_PP_ARCH_WIDTH             = AW_logb2(256 - 1) + 1 ;
parameter QID_ARCH_WIDTH                = AW_logb2(256 - 1) + 1 ;
parameter CQ_ARCH_WIDTH                 = AW_logb2(256 - 1) + 1 ;
parameter PP_ARCH_WIDTH                 = AW_logb2(256 - 1) + 1 ;
parameter VAS_WIDTH                     = AW_logb2(NUM_VAS - 1) + 1 ;
parameter VF_WIDTH                      = AW_logb2(NUM_VF - 1) + 1 ;
parameter VDEV_WIDTH                    = AW_logb2(NUM_VDEV - 1) + 1 ;
parameter NUM_CREDITS_PBANK_WIDTH       = AW_logb2(NUM_CREDITS_PBANK - 1) + 1 ;

// collage-pragma translate_on

parameter TOTAL_SN_GROUP                = 2;
parameter TOTAL_SN_SLOT                 = 16;
parameter TOTAL_SN_MODE                 = 5;

parameter DEVICE_ID                     = 16'h2714;     // v25
parameter VF_DEVICE_ID                  = 16'h2715;     // v25

typedef enum logic [ 3 : 0 ] {
  HQM_CMD_NOOP                          = 4'b0000   // NOOP
, HQM_CMD_BAT_TOK_RET                   = 4'b0001   // BAT_T
, HQM_CMD_COMP                          = 4'b0010   // COMP 
, HQM_CMD_COMP_TOK_RET                  = 4'b0011   // COMP_T
, HQM_CMD_ILLEGAL_CMD_4                 = 4'b0100   // RELEASE is now deprecated in V3
, HQM_CMD_ARM                           = 4'b0101   // ARM
, HQM_CMD_A_COMP                        = 4'b0110   // A_COMP
, HQM_CMD_A_COMP_TOK_RET                = 4'b0111   // A_COMP_T
, HQM_CMD_ENQ_NEW                       = 4'b1000   // NEW 
, HQM_CMD_ENQ_NEW_TOK_RET               = 4'b1001   // NEW_T
, HQM_CMD_ENQ_COMP                      = 4'b1010   // RENQ
, HQM_CMD_ENQ_COMP_TOK_RET              = 4'b1011   // RENQ_T
, HQM_CMD_ENQ_FRAG                      = 4'b1100   // FRAG
, HQM_CMD_ENQ_FRAG_TOK_RET              = 4'b1101   // FRAG_T
, HQM_CMD_ILLEGAL_CMD_14                = 4'b1110   //
, HQM_CMD_ILLEGAL_CMD_15                = 4'b1111   //
} hcw_cmd_dec_t ;

typedef struct packed {
  logic                         qe_valid ;
  logic                         qe_orsp ;
  logic                         qe_uhl ;
  logic                         cq_pop ;
} hcw_cmd_field_t ;

typedef union packed {
  hcw_cmd_dec_t                     hcw_cmd_dec ;
  hcw_cmd_field_t                   hcw_cmd_field ;
} hcw_cmd_t ;

typedef struct packed {
  logic [ 1 : 0 ]                   hqmrsvd ;
  logic                         dsi_error ;
  logic                         isz ;
} inbound_hcw_flags_t ;

typedef struct packed {
  logic [ 3 : 0 ]                   cmp_id ;
  logic                         no_dec ;
  logic [ 1 : 0 ]                   qe_wt ;
  logic                         ts_flag ;
} inbound_hcw_debug_t ;

typedef union packed {
  logic [ 15 : 0 ]                  lockid ;
  logic [ 15 : 0 ]                  dir_info ;
  logic [ 15 : 0 ]                  tokens ;
} inbound_hcw_lockid_dir_info_tokens_t ;

typedef enum logic [ 1 : 0 ] {
  ATOMIC                        = 2'h0
, UNORDERED                     = 2'h1
, ORDERED                       = 2'h2
, DIRECT                        = 2'h3
} qtype_t ;

typedef struct packed {
  logic [ 2 : 0 ]                   msgtype ;
  logic [ 2 : 0 ]                   qpri ;
  qtype_t                       qtype ;
  logic                         isz_0 ;
  logic [ 6 : 0 ]                   qid ;
} inbound_hcw_msg_info_t ;

typedef struct packed {
  inbound_hcw_flags_t                   flags ; 
  hcw_cmd_t                     cmd ;
  inbound_hcw_debug_t                   debug ;
  inbound_hcw_lockid_dir_info_tokens_t          lockid_dir_info_tokens ;
  inbound_hcw_msg_info_t                msg_info ;
  logic [ 15 : 0 ]                  dsi ;
  logic [ 63 : 0 ]                  ptr ;
} inbound_hcw_t ;

typedef struct packed {
  inbound_hcw_flags_t                   flags ; 
  hcw_cmd_t                     cmd ;
  inbound_hcw_debug_t                   debug ;
  inbound_hcw_lockid_dir_info_tokens_t          lockid_dir_info_tokens ;
  inbound_hcw_msg_info_t                msg_info ;
  logic [ 15 : 0 ]                  dsi ;
} inbound_hcw_noptr_t ;

typedef struct packed {
  logic [ 2 : 0 ]                   msgtype ;
  logic [ 2 : 0 ]                   qpri ;
  qtype_t                       qtype ;
  logic                         hcw_data_parity_error ;
  logic [ 6 : 0 ]                   qid ;
} cq_hcw_msg_info_t ;

typedef struct packed {
  logic [ 1 : 0 ]                   qe_wt ;
  logic                         ao_v ;
  logic                         pp_is_ldb ;
  logic [ 5 : 0 ]                   ppid ;
  logic                         ts_flag ;
  inbound_hcw_lockid_dir_info_tokens_t          lockid_dir_info_tokens ;
  cq_hcw_msg_info_t                 msg_info ;
  logic [ 15 : 0 ]                  dsi_timestamp ;
  logic [ 63 : 0 ]                  ptr ;
} cq_hcw_t ;

typedef struct packed {
  logic [ 1 : 0 ]                   qe_wt ;
  logic                         ao_v ;
  logic                         pp_is_ldb ;
  logic [ 5 : 0 ]                   ppid ;
  logic                         ts_flag ;
  inbound_hcw_lockid_dir_info_tokens_t          lockid_dir_info_tokens ;
  cq_hcw_msg_info_t                 msg_info ;
  logic [ 15 : 0 ]                  dsi_timestamp ;
} cq_hcw_upper_t ;

typedef struct packed {
  logic [ 1 : 0 ]                   hqmrsvd ;
  logic                         hcw_error ;
  logic [ 1 : 0 ]                   isz ;
  logic [ 1 : 0 ]                   qid_depth ;
  logic                         cq_gen ;
} outbound_hcw_flags_t ;

typedef struct packed {
  logic [ 3 : 0 ]                   cmp_id ;
  logic                             debug ;
  logic [ 1 : 0 ]                   qe_wt ;
  logic                         ts_flag ;
} outbound_hcw_debug_t ;

typedef struct packed {
  outbound_hcw_flags_t                  flags ;
  outbound_hcw_debug_t                  debug ;
  inbound_hcw_lockid_dir_info_tokens_t          lockid_dir_info_tokens ;
  inbound_hcw_msg_info_t                msg_info ;
  logic [ 15 : 0 ]                  dsi_timestamp ;
  logic [ 63 : 0 ]                  ptr ;
} outbound_hcw_t ;



parameter HCW_ENQ_ADDR_WIDTH                = 12 ;
parameter HCW_ENQ_DATA_WIDTH                = 128 ;
parameter HCW_ENQ_WUSER_WIDTH               = 6 ;
parameter HCW_ENQ_BUSER_WIDTH               = 6 ;
parameter HCW_ENQ_ID_WIDTH              = 6 ;

  
typedef struct packed {   
  logic                         parity ;    // covers vas[4:0] , pp_is_ldb, pp[7:0], qe_is_ldb, qid[7:0]
  logic [ 4 : 0 ]                   vas ;
  logic                         pp_is_ldb ;
  logic [ 7 : 0 ]                   pp ;
  logic                         qe_is_ldb ;
  logic [ 7 : 0 ]                   qid ;
  logic                                                 insert_timestamp ; // NEW: from system per-qid storage to instruct CHP to add 16b TS delta to HCW
} hcw_enq_aw_req_awuser_t ;

typedef struct packed {
  logic [ HCW_ENQ_ID_WIDTH - 1 : 0 ]            id ;
  logic [ HCW_ENQ_ADDR_WIDTH - 1 : 0 ]          addr ;
  hcw_enq_aw_req_awuser_t               user ;
} hcw_enq_aw_req_t ;

localparam BITS_HCW_ENQ_AW_REQ_T            = $bits ( hcw_enq_aw_req_t ) ;

typedef struct packed {
  logic [ 1 : 0 ]                   hcw_parity ;    // parity[1] covers data[127:64], parity[0] covers data[63:0]
  logic                         parity ;    // covers all wuser fields except for hcw_parity
  logic                         ao_v ;
  logic [ 4 : 0 ]                   vas ;
  logic                         pp_is_ldb ;
  logic [ 7 : 0 ]                   pp ;
  logic                         qe_is_ldb ;
  logic [ 7 : 0 ]                   qid ;
  logic                                                 insert_timestamp ; // NEW: from system per-qid storage to instruct CHP to add 16b TS delta to HCW
} hcw_enq_w_req_wuser_t ;

typedef struct packed {
  hcw_enq_w_req_wuser_t                 user ;
  inbound_hcw_t                     data ;
} hcw_enq_w_req_t ;

localparam BITS_HCW_ENQ_W_REQ_T             = $bits ( hcw_enq_w_req_t ) ;

typedef struct packed {
  logic [ HCW_ENQ_ID_WIDTH - 1 : 0 ]            id ;
  logic [ 1 : 0 ]                   resp ;
  logic [ HCW_ENQ_BUSER_WIDTH - 1 : 0 ]         user ;
} hcw_enq_b_req_t ;

localparam BITS_HCW_ENQ_B_REQ_T             = $bits ( hcw_enq_b_req_t ) ;

parameter HCW_SCHED_ADDR_WIDTH              = 14 ;
parameter HCW_SCHED_DATA_WIDTH              = 128 ;
parameter HCW_SCHED_WUSER_WIDTH             = 6 ;
parameter HCW_SCHED_BUSER_WIDTH             = 6 ;
parameter HCW_SCHED_ID_WIDTH                = 6 ;

typedef struct packed {
  logic                         parity ;

  logic                         pad_ok ;

  //    LSP-to-CHP-to-SYSTEM: the HCW has a qtype UNO,ORD or ATM (1) or DIR (0) 
  logic                         cq_is_ldb ;
  
  //    LSP-to-CHP: 2 bit Congestion Management Mechanism flag.
  // 11:                            depth >      threshold
  // 10: depth <=     threshold  &  depth >  .75 threshold
  // 01: depth <= .75 threshold  &  depth >  .50 threshold
  // 00:                            depth <= .50 threshold
  logic [ ( 2 ) - 1 : 0 ]               congestion_management ;

  //    LSP-to-CHP-to-WB: Write Buffer Optimization.
  // 11: Write this DIR HCW and wait for 3 more. 
  // 10: Write this DIR HCW and wait for 2 more
  // 01: Write this DIR HCW and wait for 1 more
  // 00: Write this DIR HCW. Do not wait for any more. 
  logic [ ( 2 ) - 1 : 0 ]               write_buffer_optimization ;

  //    LSP-to-CHP: scheduled CQ while ignore_depth config bit was set
  logic                         ignore_cq_depth ;
} hqm_core_flags_t ;

typedef struct packed {
  hqm_core_flags_t                  hqm_core_flags ;
  logic [ 12 : 0 ]                  cq_wptr ;
  logic [ 7 : 0 ]                   cq ;            //this is the CQ assoicated with the HCW data
} hcw_sched_aw_req_awuser_t ;

typedef struct packed {
  logic [ HCW_SCHED_ID_WIDTH - 1 : 0 ]          id ;  //NOTUSED
  logic [ HCW_SCHED_ADDR_WIDTH - 1 : 0 ]        addr ;  //NOTUSED
  hcw_sched_aw_req_awuser_t             user ;
} hcw_sched_aw_req_t;

localparam BITS_HCW_SCHED_AW_REQ_T          = $bits ( hcw_sched_aw_req_t ) ;

typedef struct packed {
  hqm_core_flags_t                  hqm_core_flags ;
  logic [ 12 : 0 ]                  cq_wptr ;
  logic [ 7 : 0 ]                   cq ;            //this is the CQ assoicated with the HCW data
  logic [ 1 : 0 ]                   hcw_parity ;        // parity[1] covers data[127:64], parity[0] covers data[63:0]
} hcw_sched_w_req_wuser_t ;

typedef struct packed {
  hcw_sched_w_req_wuser_t               user ;
  outbound_hcw_t                    data ;
} hcw_sched_w_req_t ;

localparam BITS_HCW_SCHED_W_REQ_T           = $bits ( hcw_sched_w_req_t ) ;

typedef struct packed {
  logic [ HCW_SCHED_ID_WIDTH - 1 : 0 ]          id ;
  logic [ 1 : 0 ]                   resp ;
  logic [ HCW_SCHED_BUSER_WIDTH - 1 : 0 ]       user ;
} hcw_sched_b_req_t ;

localparam BITS_HCW_SCHED_B_REQ_T           = $bits ( hcw_sched_b_req_t ) ;

typedef struct packed {
    logic           parity;
    logic           is_ldb;
    logic [(7)-1:0] cq_occ_cq;  //this is the CQ associated with the cq occupancy interrupt
} interrupt_w_req_t;

localparam BITS_INTERRUPT_W_REQ_T = $bits(interrupt_w_req_t);

typedef struct packed {
    logic           is_ldb;
    logic [(7)-1:0] cq;
} cwdi_interrupt_w_req_t;

localparam BITS_CWDI_INTERRUPT_W_REQ_T = $bits(cwdi_interrupt_w_req_t);

// moved from hqm_core_pkg.sv to allow sharing with dm modules

typedef struct packed {
   logic [7:0] idle_status_reserved;
   logic [3:0] cfg_state;
   logic cfg_idle0;
   logic cfg_idle1;
   logic cfg_idle2;
   logic cfg_noidle;
   logic cfg_timeout;
   logic [1:0] cfg_wait_cnt;
   logic cfg_err;
   logic cfg_rmw;
   logic cfg_read;
   logic cfg_wait;
   logic cfg_active;
   logic cfg_busy;
   logic cfg_done;
   logic cfg_ready;
   logic cfg_ready0;
   logic cfg_ready1;
   logic cfg_ready2;
   logic unit_idle;
   logic pipe_idle;
} idle_status_t;

parameter VF_RESET_WORK_CNT = 16;
parameter VF_RESET_PAUSE_CNT = 256;

// State machine state for power management

`define HQM_PM_FSM_VEC_SZ   2

typedef enum logic[`HQM_PM_FSM_VEC_SZ-1:0] {
    PM_FSM_D3COLD,
    PM_FSM_D3HOT,
    PM_FSM_D0UNINIT,
    PM_FSM_D0ACT
} pm_fsm_t;

////////////////////////////////////////////////////////////////////////////////////////////////////
// The following must be kept in-sync with generated code

// START HQM_PHYSICAL_MEM
// Minimum for these needs to be 1 and not 0!

parameter NUM_BCAMS_AQED    = 8;

parameter NUM_RFS_AQED      = 37;
parameter NUM_RFS_AP        = 100;
parameter NUM_RFS_CHP       = 32;
parameter NUM_RFS_CHP_PGCB  = 2;
parameter NUM_RFS_DP        = 19;
parameter NUM_RFS_LSP       = 57;
parameter NUM_RFS_NALB      = 24;
parameter NUM_RFS_QED       = 5;
parameter NUM_RFS_ROP       = 21;

parameter NUM_RFS_SYS       = 44;
parameter NUM_RFS_SYS_DC    = 1;
parameter NUM_RFS_SYSTEM    = NUM_RFS_SYS + NUM_RFS_SYS_DC;
parameter NUM_RFS_IOSF_1C   = 9;
parameter NUM_RFS_IOSF_DC   = 3;
parameter NUM_RFS_IOSF      = NUM_RFS_IOSF_1C + NUM_RFS_IOSF_DC;

parameter NUM_SRAMS_AQED    = 5;
parameter NUM_SRAMS_CHP     = 9;
parameter NUM_SRAMS_DP      = 4;
parameter NUM_SRAMS_NALB    = 4;
parameter NUM_SRAMS_QED     = 24;

parameter NUM_SRAMS_SYSTEM  = 1;


parameter NUM_RAMS_AQED     = NUM_SRAMS_AQED   + NUM_RFS_AQED + NUM_BCAMS_AQED;
parameter NUM_RAMS_AP       =                    NUM_RFS_AP;
parameter NUM_RAMS_CHP      = NUM_SRAMS_CHP    + NUM_RFS_CHP;
parameter NUM_RAMS_DP       = NUM_SRAMS_DP     + NUM_RFS_DP;
parameter NUM_RAMS_LSP      =                    NUM_RFS_LSP;
parameter NUM_RAMS_NALB     = NUM_SRAMS_NALB   + NUM_RFS_NALB;
parameter NUM_RAMS_QED      = NUM_SRAMS_QED    + NUM_RFS_QED;
parameter NUM_RAMS_ROP      =                  + NUM_RFS_ROP;
parameter NUM_RAMS_SYSTEM   = NUM_SRAMS_SYSTEM + NUM_RFS_SYSTEM;
parameter NUM_RAMS_IOSF     =                    NUM_RFS_IOSF;

parameter NUM_RAMS_CORE     = NUM_RAMS_AQED    + NUM_RAMS_AP  + NUM_RAMS_CHP  +
                              NUM_RAMS_DP      + NUM_RAMS_LSP + NUM_RAMS_NALB + 
                              NUM_RAMS_QED     + NUM_RAMS_ROP + NUM_RAMS_SYSTEM;

parameter NUM_RAMS_TOTAL    = NUM_RAMS_CORE + NUM_RAMS_IOSF;
// END HQM_PHYSICAL_MEM

// START HQM_SCANCHAIN
parameter NUM_SCHAINS_AQED      = 82;
parameter NUM_SCHAINS_CHP       = 166;
parameter NUM_SCHAINS_DP        = 32;
parameter NUM_SCHAINS_LSP       = 145;
parameter NUM_SCHAINS_NALB      = 41;
parameter NUM_SCHAINS_QED       = 30;
parameter NUM_SCHAINS_ROP       = 84;

parameter NUM_SCHAINS_CORE      = NUM_SCHAINS_AQED + NUM_SCHAINS_CHP +
                                  NUM_SCHAINS_DP   + NUM_SCHAINS_LSP +
                                  NUM_SCHAINS_NALB + NUM_SCHAINS_QED +
                                  NUM_SCHAINS_ROP;

parameter NUM_SCHAINS_MASTER    = 5;
parameter NUM_SCHAINS_SYSTEM    = 95;
parameter NUM_SCHAINS_IOSF      = 182;

parameter SCHAIN_SINDEX_AQED    = 0;
parameter SCHAIN_SINDEX_CHP     = SCHAIN_SINDEX_AQED + NUM_SCHAINS_AQED;
parameter SCHAIN_SINDEX_DP      = SCHAIN_SINDEX_CHP  + NUM_SCHAINS_CHP;
parameter SCHAIN_SINDEX_LSP     = SCHAIN_SINDEX_DP   + NUM_SCHAINS_DP;
parameter SCHAIN_SINDEX_NALB    = SCHAIN_SINDEX_LSP  + NUM_SCHAINS_LSP;
parameter SCHAIN_SINDEX_QED     = SCHAIN_SINDEX_NALB + NUM_SCHAINS_NALB;
parameter SCHAIN_SINDEX_ROP     = SCHAIN_SINDEX_QED  + NUM_SCHAINS_QED;

parameter SCHAIN_SINDEX_MASTER  = 0;
parameter SCHAIN_SINDEX_SYSTEM  = SCHAIN_SINDEX_MASTER + NUM_SCHAINS_MASTER;
parameter SCHAIN_SINDEX_CORE    = SCHAIN_SINDEX_SYSTEM + NUM_SCHAINS_SYSTEM;
parameter SCHAIN_SINDEX_IOSF    = SCHAIN_SINDEX_CORE   + NUM_SCHAINS_CORE;
// END HQM_SCANCHAIN

////////////////////////////////////////////////////////////////////////////////////////////////////

endpackage : hqm_pkg

