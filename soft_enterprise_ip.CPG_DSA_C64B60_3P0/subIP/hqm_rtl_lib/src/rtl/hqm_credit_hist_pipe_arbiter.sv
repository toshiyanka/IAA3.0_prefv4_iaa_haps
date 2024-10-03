//-----------------------------------------------------------------------------------------------------
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
// hqm_credit_hist_pipe_arbiter
//
//-----------------------------------------------------------------------------------------------------
module hqm_credit_hist_pipe_arbiter
  import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
# (
  parameter NONE                        = 1
) (
  input	 logic 									hqm_gated_clk
, input  logic									hqm_gated_rst_b

, input  logic                                                                  cfg_req_idlepipe

//cfg
, input  logic                                                                  cfg_chp_blk_dual_issue
, input  logic [ 5 - 1 : 0 ]                                                    cfg_chp_rop_pipe_credit_hwm
, input  logic [ 5 - 1 : 0 ]                                                    cfg_chp_lsp_tok_pipe_credit_hwm
, input  logic [ 5 - 1 : 0 ]                                                    cfg_chp_lsp_ap_cmp_pipe_credit_hwm
, input  logic [ 5 - 1 : 0 ]                                                    cfg_chp_outbound_hcw_pipe_credit_hwm

//errors


//counter

//smon
, output logic [ ( 3 * 1 ) - 1 : 0 ]                                            arb_hqm_chp_target_cfg_chp_smon_smon_v
, output logic [ ( 3 * 32 ) - 1 : 0 ]                                           arb_hqm_chp_target_cfg_chp_smon_smon_comp
, output logic [ ( 3 * 32 ) - 1 : 0 ]                                           arb_hqm_chp_target_cfg_chp_smon_smon_val

//status
, output logic [ 9 - 1 : 0 ]                                                    chp_rop_pipe_credit_status
, output logic [ 9 - 1 : 0 ]                                                    chp_lsp_tok_pipe_credit_status
, output logic [ 9 - 1 : 0 ]                                                    chp_lsp_ap_cmp_pipe_credit_status
, output logic [ 9 - 1 : 0 ]                                                    chp_outbound_hcw_pipe_credit_status

//idle, clock control
, output logic                                                                  arb_pipe_idle
, output logic                                                                  arb_unit_idle

// Functional Interface

//credit return
, input  logic                                                                  chp_rop_pipe_credit_dealloc
, input  logic                                                                  enq_to_rop_error_credit_dealloc
, input  logic                                                                  enq_to_rop_cmp_credit_dealloc
, input  logic                                                                  enq_to_lsp_cmp_error_credit_dealloc
, input  logic                                                                  chp_lsp_tok_pipe_credit_dealloc
, input  logic                                                                  chp_lsp_ap_cmp_pipe_credit_dealloc
, input  logic                                                                  chp_outbound_hcw_pipe_credit_dealloc

//interface to ingress
, output logic                                                                  hcw_enq_pop
, input  logic                                                                  hcw_enq_valid
, input  chp_pp_info_t                                                          hcw_enq_info

, output logic                                                                  hcw_replay_pop
, input  logic									hcw_replay_valid

, output logic									qed_sch_pop
, input  logic									qed_sch_valid
, input  chp_qed_to_cq_t							qed_sch_data

, output logic									aqed_sch_pop
, input  logic									aqed_sch_valid

, output logic arb_err_illegal_cmd_error
) ;


//report error cases:
// arbiter will hang if ingress sends unsupported commands

assign arb_err_illegal_cmd_error = (
  ( hcw_enq_valid & ~ hcw_enq_info.pp_is_ldb & ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP ) )
| ( hcw_enq_valid & ~ hcw_enq_info.pp_is_ldb & ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) )
| ( hcw_enq_valid & ~ hcw_enq_info.pp_is_ldb & ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP ) )
| ( hcw_enq_valid & ~ hcw_enq_info.pp_is_ldb & ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP_TOK_RET ) )
| ( hcw_enq_valid & ~ hcw_enq_info.pp_is_ldb & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) )
| ( hcw_enq_valid & ~ hcw_enq_info.pp_is_ldb & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) )
| ( hcw_enq_valid & ~ hcw_enq_info.pp_is_ldb & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) )
| ( hcw_enq_valid & ~ hcw_enq_info.pp_is_ldb & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) )
| ( hcw_enq_valid                            & ( hcw_enq_info.hcw_cmd == HQM_CMD_ILLEGAL_CMD_4 ) )
| ( hcw_enq_valid                            & ( hcw_enq_info.hcw_cmd == HQM_CMD_ILLEGAL_CMD_14 ) )
| ( hcw_enq_valid                            & ( hcw_enq_info.hcw_cmd == HQM_CMD_ILLEGAL_CMD_15 ) )
| ( qed_sch_valid                            & ( qed_sch_data.qed_chp_sch_data.cmd == QED_CHP_SCH_ILL0 ) )
| ( qed_sch_valid                            & ( qed_sch_data.qed_chp_sch_data.cmd == QED_CHP_SCH_REPLAY ) )
| ( qed_sch_valid                            & ( qed_sch_data.qed_chp_sch_data.cmd == QED_CHP_SCH_TRANSFER ) )
) ;

logic 								chp_rop_pipe_credit_alloc ;
logic 								chp_rop_pipe_credit_empty ;
logic 								chp_rop_pipe_credit_full ;
logic [ 5 - 1 : 0 ]						chp_rop_pipe_credit_size ;
logic 								chp_rop_pipe_credit_error ;
logic 								chp_rop_pipe_credit_afull ;

logic 								chp_lsp_tok_pipe_credit_alloc ;
logic 								chp_lsp_tok_pipe_credit_empty ;
logic 								chp_lsp_tok_pipe_credit_full ;
logic [ 5 - 1 : 0 ]						chp_lsp_tok_pipe_credit_size ;
logic 								chp_lsp_tok_pipe_credit_error ;
logic 								chp_lsp_tok_pipe_credit_afull ;

logic 								chp_lsp_ap_cmp_pipe_credit_alloc ;
logic 								chp_lsp_ap_cmp_pipe_credit_empty ;
logic 								chp_lsp_ap_cmp_pipe_credit_full ;
logic [ 5 - 1 : 0 ]						chp_lsp_ap_cmp_pipe_credit_size ;
logic 								chp_lsp_ap_cmp_pipe_credit_error ;
logic 								chp_lsp_ap_cmp_pipe_credit_afull ;

logic 								chp_outbound_hcw_pipe_credit_alloc ;
logic 								chp_outbound_hcw_pipe_credit_empty ;
logic 								chp_outbound_hcw_pipe_credit_full ;
logic [ 5 - 1 : 0 ]						chp_outbound_hcw_pipe_credit_size ;
logic 								chp_outbound_hcw_pipe_credit_error ;
logic 								chp_outbound_hcw_pipe_credit_afull ;

logic								dir_pp_dir_hcw_req ;
logic								dir_pp_ldb_hcw_req ;
logic								ldb_pp_dir_hcw_req ;
logic								ldb_pp_ldb_hcw_req ;

logic								hcw_replay_req ;

logic								qed_sch_req ;
logic								aqed_sch_req ;

logic [ 1 : 0 ]							schpipe_arb_reqs ;
logic								schpipe_arb_update ;
logic								schpipe_arb_winner_v ;
logic           						schpipe_arb_winner ;

logic [ 1 : 0 ]							enqpipe_arb_reqs ;
logic								enqpipe_arb_update ;
logic								enqpipe_arb_winner_v ;
logic           						enqpipe_arb_winner ;

logic [ 1 : 0 ]							issue_arb_reqs ;
logic								issue_arb_update ;
logic								issue_arb_winner_v ;
logic           						issue_arb_winner ;

logic								dir_pp_data_to_rop ;
logic								dir_pp_data_to_lsp_tok ;
logic								ldb_pp_data_to_rop ;
logic								ldb_pp_data_to_lsp_tok ;
logic								ldb_pp_data_to_lsp_cmp ;

logic enq_winner_collide ;
logic enq_winner_collide_replay_active ;
logic enqpipe_arb_go ;
logic schpipe_arb_go ;

logic								issue_arb_winner_dual ;

assign chp_rop_pipe_credit_status = { chp_rop_pipe_credit_size
                                    , chp_rop_pipe_credit_empty
                                    , chp_rop_pipe_credit_full
                                    , chp_rop_pipe_credit_afull
                                    , chp_rop_pipe_credit_error
                                    } ;
assign chp_lsp_tok_pipe_credit_status = { chp_lsp_tok_pipe_credit_size
                                        , chp_lsp_tok_pipe_credit_empty
                                        , chp_lsp_tok_pipe_credit_full
                                        , chp_lsp_tok_pipe_credit_afull
                                        , chp_lsp_tok_pipe_credit_error
                                        } ;
assign chp_lsp_ap_cmp_pipe_credit_status = { chp_lsp_ap_cmp_pipe_credit_size
                                           , chp_lsp_ap_cmp_pipe_credit_empty
                                           , chp_lsp_ap_cmp_pipe_credit_full
                                           , chp_lsp_ap_cmp_pipe_credit_afull
                                           , chp_lsp_ap_cmp_pipe_credit_error
                                           } ;
assign chp_outbound_hcw_pipe_credit_status = { chp_outbound_hcw_pipe_credit_size
                                             , chp_outbound_hcw_pipe_credit_empty
                                             , chp_outbound_hcw_pipe_credit_full
                                             , chp_outbound_hcw_pipe_credit_afull
                                             , chp_outbound_hcw_pipe_credit_error
                                             } ;

hqm_AW_control_credits #(
  .DEPTH							( 16 )
, .NUM_A							( 1 )
, .NUM_D							( 3 )
) i_chp_rop_pipe_credit (
  .clk								( hqm_gated_clk )
, .rst_n							( hqm_gated_rst_b )
, .alloc							( chp_rop_pipe_credit_alloc )
, .dealloc							( { chp_rop_pipe_credit_dealloc
                                                                  , enq_to_rop_error_credit_dealloc
                                                                  , enq_to_rop_cmp_credit_dealloc } )
, .empty							( chp_rop_pipe_credit_empty )
, .full								( chp_rop_pipe_credit_full )
, .size								( chp_rop_pipe_credit_size )
, .error							( chp_rop_pipe_credit_error )
, .hwm								( cfg_chp_rop_pipe_credit_hwm )
, .afull							( chp_rop_pipe_credit_afull )
) ;

hqm_AW_control_credits #(
  .DEPTH							( 16 )
, .NUM_A							( 1 )
, .NUM_D							( 1 )
) i_chp_lsp_tok_pipe_credit (
  .clk								( hqm_gated_clk )
, .rst_n							( hqm_gated_rst_b )
, .alloc							( chp_lsp_tok_pipe_credit_alloc )
, .dealloc							( chp_lsp_tok_pipe_credit_dealloc )
, .empty							( chp_lsp_tok_pipe_credit_empty )
, .full								( chp_lsp_tok_pipe_credit_full )
, .size								( chp_lsp_tok_pipe_credit_size )
, .error							( chp_lsp_tok_pipe_credit_error )
, .hwm								( cfg_chp_lsp_tok_pipe_credit_hwm )
, .afull							( chp_lsp_tok_pipe_credit_afull )
) ;

hqm_AW_control_credits #(
  .DEPTH							( 16 )
, .NUM_A							( 1 )
, .NUM_D							( 2 )
) i_chp_lsp_ap_cmp_pipe_credit (
  .clk								( hqm_gated_clk )
, .rst_n							( hqm_gated_rst_b )
, .alloc							( chp_lsp_ap_cmp_pipe_credit_alloc )
, .dealloc							( { chp_lsp_ap_cmp_pipe_credit_dealloc
                                                                  , enq_to_lsp_cmp_error_credit_dealloc } )
, .empty							( chp_lsp_ap_cmp_pipe_credit_empty )
, .full								( chp_lsp_ap_cmp_pipe_credit_full )
, .size								( chp_lsp_ap_cmp_pipe_credit_size )
, .error							( chp_lsp_ap_cmp_pipe_credit_error )
, .hwm								( cfg_chp_lsp_ap_cmp_pipe_credit_hwm )
, .afull							( chp_lsp_ap_cmp_pipe_credit_afull )
) ;

hqm_AW_control_credits #(
  .DEPTH							( 16 )
, .NUM_A							( 1 )
, .NUM_D							( 1 )
) i_chp_outbound_hcw_pipe_credit (
  .clk								( hqm_gated_clk )
, .rst_n							( hqm_gated_rst_b )
, .alloc							( chp_outbound_hcw_pipe_credit_alloc )
, .dealloc							( chp_outbound_hcw_pipe_credit_dealloc )
, .empty							( chp_outbound_hcw_pipe_credit_empty )
, .full								( chp_outbound_hcw_pipe_credit_full )
, .size								( chp_outbound_hcw_pipe_credit_size )
, .error							( chp_outbound_hcw_pipe_credit_error )
, .hwm								( cfg_chp_outbound_hcw_pipe_credit_hwm )
, .afull							( chp_outbound_hcw_pipe_credit_afull )
) ;

hqm_AW_rr_arb #(
  .NUM_REQS							( 2 )
) i_schpipe_arb (
  .clk								( hqm_gated_clk )
, .rst_n							( hqm_gated_rst_b )
, .reqs								( schpipe_arb_reqs )
, .update							( schpipe_arb_update )
, .winner_v							( schpipe_arb_winner_v )
, .winner							( schpipe_arb_winner )
) ;

hqm_AW_rr_arb #(
  .NUM_REQS							( 2 )
) i_enqpipe_arb (
  .clk								( hqm_gated_clk )
, .rst_n							( hqm_gated_rst_b )
, .reqs								( enqpipe_arb_reqs )
, .update							( enqpipe_arb_update )
, .winner_v							( enqpipe_arb_winner_v )
, .winner							( enqpipe_arb_winner )
) ;

hqm_AW_rr_arb #(
  .NUM_REQS							( 2 )
) i_issue_arb (
  .clk    		       					( hqm_gated_clk )
, .rst_n          						( hqm_gated_rst_b )
, .reqs								( issue_arb_reqs )
, .update							( issue_arb_update )
, .winner_v							( issue_arb_winner_v )
, .winner							( issue_arb_winner )
) ;

assign arb_pipe_idle = ~ ( | issue_arb_reqs ) ;
assign arb_unit_idle = ( ( arb_pipe_idle )
                       & ( ~ hcw_enq_valid )
                       & ( ~ hcw_replay_valid )
                       & ( ~ qed_sch_valid )
                       & ( ~ aqed_sch_valid )
                       & ( chp_rop_pipe_credit_empty & chp_lsp_tok_pipe_credit_empty & chp_lsp_ap_cmp_pipe_credit_empty & chp_outbound_hcw_pipe_credit_empty )
                       ) ;

always_comb begin

  dir_pp_dir_hcw_req = 1'd0 ;
  dir_pp_ldb_hcw_req = 1'd0 ;

  dir_pp_data_to_rop = 1'b0 ;
  dir_pp_data_to_lsp_tok = 1'b0 ;

  if ( ~ hcw_enq_info.pp_is_ldb ) begin
    case ( hcw_enq_info.hcw_cmd )
      HQM_CMD_NOOP : begin					// NOOP
        dir_pp_dir_hcw_req = hcw_enq_valid &
                             ~ chp_rop_pipe_credit_afull ;
        dir_pp_data_to_rop = 1'b1 ;
      end
      HQM_CMD_BAT_TOK_RET : begin				// BAT_T
        dir_pp_dir_hcw_req = hcw_enq_valid &
                             ~ chp_lsp_tok_pipe_credit_afull ;
        dir_pp_data_to_lsp_tok = 1'b1 ;
      end
      HQM_CMD_ARM : begin					// ARM
        dir_pp_dir_hcw_req = hcw_enq_valid &
                             ~ chp_lsp_tok_pipe_credit_afull ;
        dir_pp_data_to_lsp_tok = 1'b1 ;
      end
      HQM_CMD_ENQ_NEW : begin					// NEW
        dir_pp_ldb_hcw_req = hcw_enq_valid &
                             hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull ;
        dir_pp_dir_hcw_req = hcw_enq_valid &
                             ~ hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull ;
        dir_pp_data_to_rop = 1'b1 ;
      end
      HQM_CMD_ENQ_NEW_TOK_RET : begin				// NEW_T
        dir_pp_ldb_hcw_req = hcw_enq_valid &
                             hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull &
                             ~ chp_lsp_tok_pipe_credit_afull ;
        dir_pp_dir_hcw_req = hcw_enq_valid &
                             ~ hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull &
                             ~ chp_lsp_tok_pipe_credit_afull ;
        dir_pp_data_to_rop = 1'b1 ;
        dir_pp_data_to_lsp_tok = 1'b1 ;
      end
      default : begin
        dir_pp_dir_hcw_req = 1'd0 ;
        dir_pp_ldb_hcw_req = 1'd0 ;
      end
    endcase
  end

  ldb_pp_dir_hcw_req = 1'd0 ;
  ldb_pp_ldb_hcw_req = 1'd0 ;

  ldb_pp_data_to_rop = 1'b0 ;
  ldb_pp_data_to_lsp_tok = 1'b0 ;
  ldb_pp_data_to_lsp_cmp = 1'b0 ;

  if ( hcw_enq_info.pp_is_ldb ) begin
    case ( hcw_enq_info.hcw_cmd )
      HQM_CMD_NOOP : begin					// NOOP
        ldb_pp_ldb_hcw_req = hcw_enq_valid &
                             ~ chp_rop_pipe_credit_afull ;
        ldb_pp_data_to_rop = 1'b1 ;
      end
      HQM_CMD_BAT_TOK_RET : begin				// BAT_T
        ldb_pp_ldb_hcw_req = hcw_enq_valid &
                            ~ chp_lsp_tok_pipe_credit_afull ;
        ldb_pp_data_to_lsp_tok = 1'b1 ;
      end
      HQM_CMD_COMP : begin					// COMP
        ldb_pp_ldb_hcw_req = hcw_enq_valid &
                             ~ chp_rop_pipe_credit_afull &
                             ~ chp_lsp_ap_cmp_pipe_credit_afull ;
        ldb_pp_data_to_rop = 1'b1 ;
        ldb_pp_data_to_lsp_cmp = 1'b1 ;
      end
      HQM_CMD_COMP_TOK_RET : begin				// COMP_T
        ldb_pp_ldb_hcw_req = hcw_enq_valid &
                             ~ chp_rop_pipe_credit_afull &
                             ~ chp_lsp_ap_cmp_pipe_credit_afull &
                             ~ chp_lsp_tok_pipe_credit_afull ;
        ldb_pp_data_to_rop = 1'b1 ;
        ldb_pp_data_to_lsp_cmp = 1'b1 ;
        ldb_pp_data_to_lsp_tok = 1'b1 ;
      end
      HQM_CMD_A_COMP : begin					// A_COMP
        ldb_pp_ldb_hcw_req = hcw_enq_valid &
                             ~ chp_lsp_ap_cmp_pipe_credit_afull ;
        ldb_pp_data_to_lsp_cmp = 1'b1 ;
      end
      HQM_CMD_A_COMP_TOK_RET : begin				// A_COMP_T
        ldb_pp_ldb_hcw_req = hcw_enq_valid &
                             ~ chp_lsp_ap_cmp_pipe_credit_afull & 
                             ~ chp_lsp_tok_pipe_credit_afull ;
        ldb_pp_data_to_lsp_cmp = 1'b1 ;
        ldb_pp_data_to_lsp_tok = 1'b1 ;
      end
      HQM_CMD_ARM : begin					// ARM
        ldb_pp_ldb_hcw_req = hcw_enq_valid &
                             ~ chp_lsp_tok_pipe_credit_afull ;
        ldb_pp_data_to_lsp_tok = 1'b1 ;
      end
      HQM_CMD_ENQ_NEW         					// NEW
    , HQM_CMD_ENQ_FRAG : begin					// FRAG
        ldb_pp_ldb_hcw_req = hcw_enq_valid &
                             hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull ;
        ldb_pp_dir_hcw_req = hcw_enq_valid &
                             ~ hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull ;
        ldb_pp_data_to_rop = 1'b1 ;
      end
      HQM_CMD_ENQ_NEW_TOK_RET					// NEW_T
    , HQM_CMD_ENQ_FRAG_TOK_RET : begin 				// FRAG_T
        ldb_pp_ldb_hcw_req = hcw_enq_valid &
                             hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull &
                             ~ chp_lsp_tok_pipe_credit_afull ;
        ldb_pp_dir_hcw_req = hcw_enq_valid &
                             ~ hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull &
                             ~ chp_lsp_tok_pipe_credit_afull ;
        ldb_pp_data_to_rop = 1'b1 ;
        ldb_pp_data_to_lsp_tok = 1'b1 ;
      end
      HQM_CMD_ENQ_COMP : begin					// RENQ
        ldb_pp_ldb_hcw_req = hcw_enq_valid &
                             hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull &
                             ~ chp_lsp_ap_cmp_pipe_credit_afull ;
        ldb_pp_dir_hcw_req = hcw_enq_valid &
                             ~ hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull &
                             ~ chp_lsp_ap_cmp_pipe_credit_afull ;
        ldb_pp_data_to_rop = 1'b1 ;
        ldb_pp_data_to_lsp_cmp = 1'b1 ;
      end
      HQM_CMD_ENQ_COMP_TOK_RET : begin 				// RENQ_T
        ldb_pp_ldb_hcw_req = hcw_enq_valid &
                             hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull &
                             ~ chp_lsp_ap_cmp_pipe_credit_afull &
                             ~ chp_lsp_tok_pipe_credit_afull ;
        ldb_pp_dir_hcw_req = hcw_enq_valid &
                             ~ hcw_enq_info.qe_is_ldb &
                             ~ chp_rop_pipe_credit_afull &
                             ~ chp_lsp_ap_cmp_pipe_credit_afull &
                             ~ chp_lsp_tok_pipe_credit_afull ;
        ldb_pp_data_to_rop = 1'b1 ;
        ldb_pp_data_to_lsp_cmp = 1'b1 ;
        ldb_pp_data_to_lsp_tok = 1'b1 ;
      end
      default : begin
        ldb_pp_dir_hcw_req = 1'd0 ;
        ldb_pp_ldb_hcw_req = 1'd0 ;
      end
    endcase
  end

  hcw_replay_req = hcw_replay_valid & ~ chp_rop_pipe_credit_afull ;

  qed_sch_req = qed_sch_valid & ( qed_sch_data.qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) & ~ chp_outbound_hcw_pipe_credit_afull ;

  aqed_sch_req = aqed_sch_valid & ~ chp_outbound_hcw_pipe_credit_afull ; 

  enqpipe_arb_reqs = { hcw_replay_req
                     , ( dir_pp_dir_hcw_req | ldb_pp_dir_hcw_req | dir_pp_ldb_hcw_req | ldb_pp_ldb_hcw_req )
                     } ;

  schpipe_arb_reqs = { aqed_sch_req 
                     , qed_sch_req
                     } ;

  //only activate issue arb when not idling pipe for SCH or VAS reset
  issue_arb_reqs = cfg_req_idlepipe ? { 1'b0 , 1'b0 } : { schpipe_arb_winner_v , enqpipe_arb_winner_v } ;
  issue_arb_update = 1'b0 ;

  hcw_enq_pop = 1'b0 ;
  qed_sch_pop = 1'b0 ;
  aqed_sch_pop = 1'b0 ;
  hcw_replay_pop = 1'b0 ;


  // sch arb has winner ( qed or aqed schedule) and enq arb winner is  enqueue but it is from LDB PP and collides with the schedule  (take replay even if it loses arbitration)
  enq_winner_collide = ( enqpipe_arb_winner_v
                       & ( enqpipe_arb_winner == 1'd0 )
                       & ( hcw_enq_info.pp_is_ldb
                         & ( ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP ) 
                           | ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET )
                           | ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP )
                           | ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP_TOK_RET )
                           | ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP )
                           | ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET )
                           | ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG )
                           | ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET )
                           )
                         )
                       ) ;
  enq_winner_collide_replay_active = enq_winner_collide & hcw_replay_req ;

//NOTE
// issue_arb_winner   0:enqpipe_arb_winner
//                    1:schpipe_arb_winner
// enqpipe_arb_winner 0:enqueue
//                    1:replay
// schpipe_arb_winner 0:qed
//                    1:aqed
  case ( issue_arb_winner )
    1'b0 : begin
      enqpipe_arb_go     = ( issue_arb_winner_v & enqpipe_arb_winner_v ) ;
      schpipe_arb_go     = ( issue_arb_winner_v & enqpipe_arb_winner_v
                           & ( schpipe_arb_winner_v 
                             & ( ( ( ( enqpipe_arb_winner == 1'd1 ) )
                                 | ( ( enqpipe_arb_winner == 1'd0 ) & ~ enq_winner_collide )
                                 )
                               & ~ cfg_chp_blk_dual_issue
                               )  
                             )
                           ) ;

      issue_arb_update   = issue_arb_winner_v ;
      enqpipe_arb_update = enqpipe_arb_go ;
      schpipe_arb_update = schpipe_arb_go ;

      hcw_enq_pop        = enqpipe_arb_update & ( enqpipe_arb_winner == 1'd0 ) ;
      hcw_replay_pop     = enqpipe_arb_update & ( enqpipe_arb_winner == 1'd1 ) ;
      qed_sch_pop        = schpipe_arb_update & ( schpipe_arb_winner == 1'd0 ) ;
      aqed_sch_pop       = schpipe_arb_update & ( schpipe_arb_winner == 1'd1 ) ;
    end
    1'b1 : begin
      enqpipe_arb_go     = ( issue_arb_winner_v & schpipe_arb_winner_v
                           & ( enqpipe_arb_winner_v 
                             & ( ( ( ( enqpipe_arb_winner == 1'd1 ) | enq_winner_collide_replay_active )
                                 | ( ( enqpipe_arb_winner == 1'd0 ) & ~ enq_winner_collide )
                                 )
                               & ~cfg_chp_blk_dual_issue 
                               )   
                             ) 
                           ) ;
      schpipe_arb_go     = ( issue_arb_winner_v & schpipe_arb_winner_v ) ;

      issue_arb_update   = issue_arb_winner_v ;
      enqpipe_arb_update = enqpipe_arb_go & ~ enq_winner_collide_replay_active ;
      schpipe_arb_update = schpipe_arb_go ;

      hcw_enq_pop        = enqpipe_arb_update & ( ( enqpipe_arb_winner == 1'd0 ) & ~ enq_winner_collide ) ;
      hcw_replay_pop     = enqpipe_arb_update & ( ( enqpipe_arb_winner == 1'd1 ) | enq_winner_collide_replay_active ) ;
      qed_sch_pop        = schpipe_arb_update & ( schpipe_arb_winner == 1'd0 ) ;
      aqed_sch_pop       = schpipe_arb_update & ( schpipe_arb_winner == 1'd1 ) ;
    end
    default : begin
      issue_arb_update = 1'd0 ;
      enqpipe_arb_update = 1'd0 ;
      schpipe_arb_update = 1'd0 ;
      hcw_enq_pop = 1'd0 ;
      hcw_replay_pop = 1'd0 ;
      qed_sch_pop = 1'd0 ;
      aqed_sch_pop = 1'd0 ;
    end
  endcase


  issue_arb_winner_dual = ( ( hcw_replay_pop | hcw_enq_pop ) & ( qed_sch_pop | aqed_sch_pop ) ) ;


  chp_rop_pipe_credit_alloc = hcw_replay_pop |
                              ( hcw_enq_pop & dir_pp_data_to_rop ) | ( hcw_enq_pop & ldb_pp_data_to_rop ) ;
  chp_lsp_tok_pipe_credit_alloc = ( hcw_enq_pop & dir_pp_data_to_lsp_tok ) | ( hcw_enq_pop & ldb_pp_data_to_lsp_tok ) ;
  chp_lsp_ap_cmp_pipe_credit_alloc = ( hcw_enq_pop & ldb_pp_data_to_lsp_cmp ) ;
  chp_outbound_hcw_pipe_credit_alloc = ( qed_sch_pop | aqed_sch_pop ) ; 

  arb_hqm_chp_target_cfg_chp_smon_smon_v [ ( 0 * 1 ) +: 1 ]      = chp_outbound_hcw_pipe_credit_alloc |
                                                                   chp_lsp_ap_cmp_pipe_credit_alloc |
                                                                   chp_lsp_tok_pipe_credit_alloc |
                                                                   chp_rop_pipe_credit_alloc |
                                                                   chp_outbound_hcw_pipe_credit_afull |
                                                                   chp_lsp_ap_cmp_pipe_credit_afull |
                                                                   chp_lsp_tok_pipe_credit_afull |
                                                                   chp_rop_pipe_credit_afull ;
  arb_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 0 * 32 ) +: 32 ] = { 24'd0
                                                                   , chp_outbound_hcw_pipe_credit_alloc			//  7
                                                                   , chp_lsp_ap_cmp_pipe_credit_alloc			//  6
                                                                   , chp_lsp_tok_pipe_credit_alloc			//  5
                                                                   , chp_rop_pipe_credit_alloc				//  4
                                                                   , chp_outbound_hcw_pipe_credit_afull			//  3
                                                                   , chp_lsp_ap_cmp_pipe_credit_afull			//  2
                                                                   , chp_lsp_tok_pipe_credit_afull			//  1
                                                                   , chp_rop_pipe_credit_afull				//  0
                                                                   } ;
  arb_hqm_chp_target_cfg_chp_smon_smon_val [ ( 0 * 32 ) +: 32 ]  = 32'd1 ;

  arb_hqm_chp_target_cfg_chp_smon_smon_v [ ( 1 * 1 ) +: 1 ]      = enq_to_lsp_cmp_error_credit_dealloc |	
                                                                   enq_to_rop_error_credit_dealloc |
                                                                   chp_outbound_hcw_pipe_credit_dealloc |	
                                                                   chp_lsp_ap_cmp_pipe_credit_dealloc |
                                                                   chp_lsp_tok_pipe_credit_dealloc |
                                                                   chp_rop_pipe_credit_dealloc |
                                                                   enq_to_rop_cmp_credit_dealloc | 
                                                                   chp_outbound_hcw_pipe_credit_error |
                                                                   chp_lsp_ap_cmp_pipe_credit_error |
                                                                   chp_lsp_tok_pipe_credit_error |
                                                                   chp_rop_pipe_credit_error ;
  arb_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 1 * 32 ) +: 32 ] = { 22'd0
                                                                   , enq_to_lsp_cmp_error_credit_dealloc		//  9
                                                                   , enq_to_rop_error_credit_dealloc			//  8
                                                                   , chp_outbound_hcw_pipe_credit_dealloc		//  7
                                                                   , ( chp_lsp_ap_cmp_pipe_credit_dealloc |		//  6
                                                                       enq_to_lsp_cmp_error_credit_dealloc )
                                                                   , chp_lsp_tok_pipe_credit_dealloc			//  5
                                                                   , ( chp_rop_pipe_credit_dealloc |			//  4
                                                                       enq_to_rop_error_credit_dealloc |
                                                                       enq_to_rop_cmp_credit_dealloc )
                                                                   , chp_outbound_hcw_pipe_credit_error			//  3
                                                                   , chp_lsp_ap_cmp_pipe_credit_error			//  2
                                                                   , chp_lsp_tok_pipe_credit_error			//  1
                                                                   , chp_rop_pipe_credit_error				//  0
                                                                   } ;
  arb_hqm_chp_target_cfg_chp_smon_smon_val [ ( 1 * 32 ) +: 32 ]  = 32'd1 ;

  arb_hqm_chp_target_cfg_chp_smon_smon_v [ ( 2 * 1 ) +: 1 ]      = 1'd1 ;
  arb_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 2 * 32 ) +: 32 ] = { 29'd0
                                                                   , ( ldb_pp_dir_hcw_req )				// 2
                                                                   , ( dir_pp_dir_hcw_req )				// 1
                                                                   , issue_arb_winner_dual				// 0
                                                                   } ; 
  arb_hqm_chp_target_cfg_chp_smon_smon_val [ ( 2 * 32 ) +: 32 ]  = 32'd0 ;

end

endmodule
