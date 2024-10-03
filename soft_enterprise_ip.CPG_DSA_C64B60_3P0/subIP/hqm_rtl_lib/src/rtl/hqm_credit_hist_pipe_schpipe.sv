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
//
//
//-----------------------------------------------------------------------------------------------------
module hqm_credit_hist_pipe_schpipe
  import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(
  input  logic                                    hqm_gated_clk
, input  logic                                    hqm_gated_rst_b



//cfg
, input  logic                                    schpipe_error_inject_h0
, input  logic                                    schpipe_error_inject_l0
, input  logic                                    schpipe_error_inject_h1
, input  logic                                    schpipe_error_inject_l1

//errors
, output logic                                    schpipe_err_pipeline_parity_err
, output logic                                    schpipe_err_ldb_cq_hcw_h_ecc_sb
, output logic                                    schpipe_err_ldb_cq_hcw_h_ecc_mb

//counter

//smon
, output logic [ ( 1 * 1 ) - 1 : 0 ]              schpipe_hqm_chp_target_cfg_chp_smon_smon_v
, output logic [ ( 1 * 32 ) - 1 : 0 ]             schpipe_hqm_chp_target_cfg_chp_smon_smon_comp
, output logic [ ( 1 * 32 ) - 1 : 0 ]             schpipe_hqm_chp_target_cfg_chp_smon_smon_val

//status
, output logic                                    schpipe_pipe_idle
, output logic                                    schpipe_unit_idle

//idle, clock control

// top level RFW/SRW , FIFO, RMW, MFIFO

, output logic                                    sch_hist_list_cmd_v
, output aw_multi_fifo_cmd_t                      sch_hist_list_cmd
, output logic [ 5 : 0 ]                          sch_hist_list_fifo_num
, output hist_list_mf_t                           sch_hist_list_push_data
, input  logic                                    sch_hist_list_of

, input  logic [ HQM_NUM_LB_CQ - 1 : 0 ]          schpipe_hqm_chp_target_cfg_hist_list_mode

, output logic                                    sch_hist_list_a_cmd_v
, output aw_multi_fifo_cmd_t                      sch_hist_list_a_cmd
, output logic [ 5 : 0 ]                          sch_hist_list_a_fifo_num
, output hist_list_mf_t                           sch_hist_list_a_push_data
, input  logic                                    sch_hist_list_a_of

// Functional Interface

//Interface from arbiter/ingress
, input  logic                                    qed_sch_pop
, input  chp_qed_to_cq_t                          qed_sch_data
, input  logic                                    aqed_sch_pop
, input  aqed_chp_sch_t                           aqed_sch_data

//Interface to arbiter
 
//Interface to output drain FIFO
, output logic                                    fifo_outbound_hcw_push
, output outbound_hcw_fifo_t                      fifo_outbound_hcw_push_data

, output logic                                    schpipe_error_inject_h0_done_set
, output logic                                    schpipe_error_inject_l0_done_set
, output logic                                    schpipe_error_inject_h1_done_set
, output logic                                    schpipe_error_inject_l1_done_set
) ;


logic [ ( 12 ) - 1 : 0 ] p0_sch_chp_state_fid_nxt ;
logic [ ( 12 ) - 1 : 0 ] p0_sch_chp_state_fid_f ;
sch_chp_state_t p0_sch_chp_state_nxt , p0_sch_chp_state_f , p1_sch_chp_state_nxt , p1_sch_chp_state_f , p2_sch_chp_state_nxt , p2_sch_chp_state_f , p3_sch_chp_state_nxt , p3_sch_chp_state_f , p4_sch_chp_state_nxt , p4_sch_chp_state_f , p5_sch_chp_state_nxt , p5_sch_chp_state_f ;
logic p0_sch_chp_state_v_nxt , p0_sch_chp_state_v_f , p1_sch_chp_state_v_nxt , p1_sch_chp_state_v_f , p2_sch_chp_state_v_nxt , p2_sch_chp_state_v_f , p3_sch_chp_state_v_nxt , p3_sch_chp_state_v_f , p4_sch_chp_state_v_nxt , p4_sch_chp_state_v_f , p5_sch_chp_state_v_nxt , p5_sch_chp_state_v_f ;
logic [ ( 4 ) - 1 : 0 ] cmp_id_f , cmp_id_nxt ;
logic hist_list_parity ;
logic [ ( 8 ) - 1 : 0 ] hist_list_ecc ;
logic [ ( 32 ) - 1 : 0 ] parity_check_pipe_d ;
logic parity_check_pipe_p ;
logic parity_check_pipe_e ;
logic hqm_chp_partial_outbound_hcw_fifo_parity;
logic ldb_cq_hcw_v ;
logic [ 15 : 0 ] ldb_cq_hcw_ecc ;
cq_hcw_t ldb_cq_hcw ;
cq_hcw_upper_t ldb_cq_hcw_upper_corrected ;

logic hist_list_a_parity ;
logic [ ( 8 ) - 1 : 0 ] hist_list_a_ecc ;

logic [ ( HQM_NUM_LB_CQ ) - 1 : 0 ] sch_hist_list_fifo_we_sel_nxt ;
logic [ ( HQM_NUM_LB_CQ ) - 1 : 0 ] sch_hist_list_fifo_we_sel_f ;

logic sch_hist_list_wrap_error ;

// AW modules
hqm_AW_parity_gen #(
   .WIDTH                             ( 2 + 3 + 7 + 3 + 3 + 5 + 12 )
) i_AW_parity_gen_hist_list (
   .d                                 ( { sch_hist_list_push_data.hist_list_info.qtype
                                        , sch_hist_list_push_data.hist_list_info.qpri
                                        , sch_hist_list_push_data.hist_list_info.qid
                                        , sch_hist_list_push_data.hist_list_info.qidix_msb
                                        , sch_hist_list_push_data.hist_list_info.qidix
                                        , sch_hist_list_push_data.hist_list_info.reord_mode
                                        , sch_hist_list_push_data.hist_list_info.reord_slot
                                        , sch_hist_list_push_data.hist_list_info.sn_fid
                                        } )
 , .odd                               ( 1'b1 )
 , .p                                 ( hist_list_parity )
);

hqm_AW_parity_gen #(
   .WIDTH                             ( 2 + 3 + 7 + 3 + 3 + 5 + 12 )
) i_AW_parity_gen_hist_list_a (
   .d                                 ( { sch_hist_list_a_push_data.hist_list_info.qtype
                                        , sch_hist_list_a_push_data.hist_list_info.qpri
                                        , sch_hist_list_a_push_data.hist_list_info.qid
                                        , sch_hist_list_a_push_data.hist_list_info.qidix_msb
                                        , sch_hist_list_a_push_data.hist_list_info.qidix
                                        , sch_hist_list_a_push_data.hist_list_info.reord_mode
                                        , sch_hist_list_a_push_data.hist_list_info.reord_slot
                                        , sch_hist_list_a_push_data.hist_list_info.sn_fid 
                                        } )
 , .odd                               ( 1'b1 )
 , .p                                 ( hist_list_a_parity )
);

hqm_AW_ecc_check # (
   .DATA_WIDTH                        ( 59 )
 , .ECC_WIDTH                         ( 8 )
) i_ldb_hcw_h_ecc_check (
   .din_v                             ( ldb_cq_hcw_v )
 , .din                               ( ldb_cq_hcw [ 122 : 64 ] )
 , .ecc                               ( ldb_cq_hcw_ecc [ 15 : 8 ] )
 , .enable                            ( 1'b1 )
 , .correct                           ( 1'b1 )
 , .dout                              ( ldb_cq_hcw_upper_corrected )
 , .error_sb                          ( schpipe_err_ldb_cq_hcw_h_ecc_sb )
 , .error_mb                          ( schpipe_err_ldb_cq_hcw_h_ecc_mb )
) ;

hqm_AW_ecc_gen #(
   .DATA_WIDTH                        ( 2 + 16 + 4 + 1 + 2 + 3 + 7 + 3 + 3 + 5 + 12 )
 , .ECC_WIDTH                         ( 8 )
) i_hist_list_wdata_ecc_gen (
   .d                                 ( { sch_hist_list_push_data.qe_wt
                                        , sch_hist_list_push_data.hid
                                        , sch_hist_list_push_data.cmp_id
                                        , sch_hist_list_push_data.hist_list_info.parity
                                        , sch_hist_list_push_data.hist_list_info.qtype
                                        , sch_hist_list_push_data.hist_list_info.qpri
                                        , sch_hist_list_push_data.hist_list_info.qid
                                        , sch_hist_list_push_data.hist_list_info.qidix_msb
                                        , sch_hist_list_push_data.hist_list_info.qidix
                                        , sch_hist_list_push_data.hist_list_info.reord_mode
                                        , sch_hist_list_push_data.hist_list_info.reord_slot
                                        , sch_hist_list_push_data.hist_list_info.sn_fid
                                        } )
 , .ecc                               ( hist_list_ecc )
);

hqm_AW_ecc_gen #(
   .DATA_WIDTH                        ( 2 + 16 + 4 + 1 + 2 + 3 + 7 + 3 + 3 + 5 + 12 )
 , .ECC_WIDTH                         ( 8 )
) i_hist_list_a_wdata_ecc_gen (
   .d                                 ( { sch_hist_list_a_push_data.qe_wt
                                        , sch_hist_list_a_push_data.hid
                                        , sch_hist_list_a_push_data.cmp_id
                                        , sch_hist_list_a_push_data.hist_list_info.parity
                                        , sch_hist_list_a_push_data.hist_list_info.qtype
                                        , sch_hist_list_a_push_data.hist_list_info.qpri
                                        , sch_hist_list_a_push_data.hist_list_info.qid
                                        , sch_hist_list_a_push_data.hist_list_info.qidix_msb
                                        , sch_hist_list_a_push_data.hist_list_info.qidix
                                        , sch_hist_list_a_push_data.hist_list_info.reord_mode
                                        , sch_hist_list_a_push_data.hist_list_info.reord_slot
                                        , sch_hist_list_a_push_data.hist_list_info.sn_fid
                                        } )
 , .ecc                               ( hist_list_a_ecc )
);

hqm_AW_parity_check #(
   .WIDTH                             ( 32 )
) i_AW_parity_check_pipe (
   .p                                 ( parity_check_pipe_p )
 , .d                                 ( parity_check_pipe_d )
 , .e                                 ( parity_check_pipe_e )
 , .odd                               ( 1'b1 )
 , .err                               ( schpipe_err_pipeline_parity_err )
);

assign schpipe_hqm_chp_target_cfg_chp_smon_smon_v [ ( 0 * 1 ) +: 1 ]      = qed_sch_pop | aqed_sch_pop | fifo_outbound_hcw_push ;
assign schpipe_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 0 * 32 ) +: 32 ] = { 29'd0 , qed_sch_pop , aqed_sch_pop , fifo_outbound_hcw_push } ;
assign schpipe_hqm_chp_target_cfg_chp_smon_smon_val [ ( 0 * 32 ) +: 32 ]  = 32'd1 ;

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_b ) begin
  if ( ~ hqm_gated_rst_b ) begin
    p0_sch_chp_state_v_f <= '0 ;
    p1_sch_chp_state_v_f <= '0 ;
    p2_sch_chp_state_v_f <= '0 ;
    p3_sch_chp_state_v_f <= '0 ;
    p4_sch_chp_state_v_f <= '0 ;
    p5_sch_chp_state_v_f <= '0 ;
    cmp_id_f <= '0 ;
    sch_hist_list_fifo_we_sel_f <= { HQM_NUM_LB_CQ { 1'b0 } } ; 
  end else begin
    p0_sch_chp_state_v_f <= p0_sch_chp_state_v_nxt ;
    p1_sch_chp_state_v_f <= p1_sch_chp_state_v_nxt ;
    p2_sch_chp_state_v_f <= p2_sch_chp_state_v_nxt ;
    p3_sch_chp_state_v_f <= p3_sch_chp_state_v_nxt ;
    p4_sch_chp_state_v_f <= p4_sch_chp_state_v_nxt ;
    p5_sch_chp_state_v_f <= p5_sch_chp_state_v_nxt ;
    cmp_id_f <= cmp_id_nxt ;
    sch_hist_list_fifo_we_sel_f <= sch_hist_list_fifo_we_sel_nxt ;
  end
end

always_ff @ ( posedge hqm_gated_clk ) begin
    p0_sch_chp_state_fid_f <= p0_sch_chp_state_fid_nxt ;
    p0_sch_chp_state_f <= p0_sch_chp_state_nxt ;
    p1_sch_chp_state_f <= p1_sch_chp_state_nxt ;
    p2_sch_chp_state_f <= p2_sch_chp_state_nxt ;
    p3_sch_chp_state_f <= p3_sch_chp_state_nxt ;
    p4_sch_chp_state_f <= p4_sch_chp_state_nxt ;
    p5_sch_chp_state_f <= p5_sch_chp_state_nxt ;
end


always_comb begin

  //pipeline control - hold unless previous stage is valid
  p0_sch_chp_state_v_nxt = '0 ;
  p0_sch_chp_state_nxt   = p0_sch_chp_state_f ;
  schpipe_error_inject_h0_done_set = 1'd0 ;
  schpipe_error_inject_l0_done_set = 1'd0 ;
  schpipe_error_inject_h1_done_set = 1'd0 ;
  schpipe_error_inject_l1_done_set = 1'd0 ;
  p1_sch_chp_state_v_nxt = p0_sch_chp_state_v_f ;
  p1_sch_chp_state_nxt = p1_sch_chp_state_f ;
  if ( p0_sch_chp_state_v_f ) begin
    p1_sch_chp_state_nxt = p0_sch_chp_state_f ;
    p1_sch_chp_state_nxt.hist_list_v = 1'b0 ;
    p1_sch_chp_state_nxt.hist_list_data = '0 ;
    if ( schpipe_error_inject_h0 ) begin
      p1_sch_chp_state_nxt.cq_hcw.dsi_timestamp [ 0 ] = p1_sch_chp_state_nxt.cq_hcw.dsi_timestamp [ 0 ] ^ 1'b1 ;
      schpipe_error_inject_h0_done_set = 1'd1 ;
    end
    if ( schpipe_error_inject_l0 ) begin
      p1_sch_chp_state_nxt.cq_hcw.ptr [ 0 ] = p1_sch_chp_state_nxt.cq_hcw.ptr [ 0 ] ^ 1'b1 ;
      schpipe_error_inject_l0_done_set = 1'd1 ;
    end
    if ( schpipe_error_inject_h1 ) begin
      p1_sch_chp_state_nxt.cq_hcw.dsi_timestamp [ 1 ] = p1_sch_chp_state_nxt.cq_hcw.dsi_timestamp [ 1 ] ^ 1'b1 ;
      schpipe_error_inject_h1_done_set = 1'd1 ;
    end
    if ( schpipe_error_inject_l1 ) begin
      p1_sch_chp_state_nxt.cq_hcw.ptr [ 48 ] = p1_sch_chp_state_nxt.cq_hcw.ptr [ 48 ] ^ 1'b1 ;
      schpipe_error_inject_l1_done_set = 1'd1 ;
    end
  end
  p2_sch_chp_state_v_nxt = p1_sch_chp_state_v_f ;
  p2_sch_chp_state_nxt   = p1_sch_chp_state_v_f ? p1_sch_chp_state_f : p2_sch_chp_state_f ;
  p2_sch_chp_state_nxt.hist_list_v = 1'b0 ;
  p2_sch_chp_state_nxt.hist_list_data = '0 ;
  p3_sch_chp_state_v_nxt = p2_sch_chp_state_v_f ;
  p3_sch_chp_state_nxt   = p2_sch_chp_state_v_f ? p2_sch_chp_state_f : p3_sch_chp_state_f ;
  p3_sch_chp_state_nxt.hist_list_v = 1'b0 ;
  p3_sch_chp_state_nxt.hist_list_data = '0 ;
  p4_sch_chp_state_v_nxt = p3_sch_chp_state_v_f ;
  p4_sch_chp_state_nxt   = p3_sch_chp_state_v_f ? p3_sch_chp_state_f : p4_sch_chp_state_f ;
  p4_sch_chp_state_nxt.hist_list_v = 1'b0 ;
  p4_sch_chp_state_nxt.hist_list_data = '0 ;
  p5_sch_chp_state_v_nxt = p4_sch_chp_state_v_f ;
  p5_sch_chp_state_nxt   = p4_sch_chp_state_v_f ? p4_sch_chp_state_f : p5_sch_chp_state_f ;
  p5_sch_chp_state_nxt.hist_list_v = 1'b0 ;
  p5_sch_chp_state_nxt.hist_list_data = '0 ;

  schpipe_pipe_idle = ( ( ~ p0_sch_chp_state_v_f )
                      & ( ~ p1_sch_chp_state_v_f )
                      & ( ~ p2_sch_chp_state_v_f )
                      & ( ~ p3_sch_chp_state_v_f )
                      & ( ~ p4_sch_chp_state_v_f )
                      & ( ~ p5_sch_chp_state_v_f )
                      ) ;
  schpipe_unit_idle = ( ( schpipe_pipe_idle )
                      ) ;

  cmp_id_nxt = cmp_id_f ;
  parity_check_pipe_p = '0 ;
  parity_check_pipe_d = '0 ;
  parity_check_pipe_e = '0 ;

  //====================================================================================================
  //load data from ingress into P0 stage
  //   igress delivers 4 mutually exclusive interfacesi that are loaded into the P0 pipeline data:
  //     qed_sch_pop & qed_sch_data   : qed DIR/ORD/UNO HCW schedule
  //     aqed_sch_pop & aqed_sch_data : aqed ATM HCW schedule
  //   this section also creates special pipeline control flags in P0 that are passed down the pipeline:
  //   * atmsch          : this indicates an atomic schedule. no freelist return is performed
  //   * hist_list_v     : this indicates to performe a hist list push using p0_v_f
  //   * cmp_id          : the completion ID is written into the hist list and sent down the pipe to engress to be instered into the HCW

  ldb_cq_hcw_v = ( qed_sch_pop & ( qed_sch_data.qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) & qed_sch_data.qed_chp_sch_data.hqm_core_flags.cq_is_ldb ) | aqed_sch_pop ;
  ldb_cq_hcw_ecc = qed_sch_pop ? qed_sch_data.qed_chp_sch_data.cq_hcw_ecc : aqed_sch_data.cq_hcw_ecc ;
  ldb_cq_hcw = qed_sch_pop ? qed_sch_data.qed_chp_sch_data.cq_hcw : aqed_sch_data.cq_hcw ;

  p0_sch_chp_state_fid_nxt = qed_sch_data.qed_chp_sch_data.flid [ ( 12 ) - 1 : 0 ] ;
 
  p0_sch_chp_state_v_nxt  = qed_sch_pop | aqed_sch_pop ;
  if ( p0_sch_chp_state_v_nxt ) begin
    p0_sch_chp_state_nxt = '0 ; // intiialize pipeline data fields to zero on new command

    if ( qed_sch_pop & ( qed_sch_data.qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) & ~ qed_sch_data.qed_chp_sch_data.hqm_core_flags.cq_is_ldb ) begin
      p0_sch_chp_state_nxt.cq_hcw_ecc                               = qed_sch_data.qed_chp_sch_data.cq_hcw_ecc ;
      p0_sch_chp_state_nxt.cq_hcw                                   = qed_sch_data.qed_chp_sch_data.cq_hcw ;
      p0_sch_chp_state_nxt.hqm_core_flags                           = qed_sch_data.qed_chp_sch_data.hqm_core_flags ;
      p0_sch_chp_state_nxt.cq                                       = qed_sch_data.qed_chp_sch_data.cq ;

      parity_check_pipe_e = 1'b1 ;
      parity_check_pipe_p = ^ { 1'b1
                              , qed_sch_data.qed_chp_sch_data.parity
                              , qed_sch_data.qed_chp_sch_data.hqm_core_flags.parity } ;
      parity_check_pipe_d = { 14'd0
                            , 2'd0 
                            , qed_sch_data.qed_chp_sch_data.cq
                            , 2'd0
                            , qed_sch_data.qed_chp_sch_data.hqm_core_flags.cq_is_ldb
                            , qed_sch_data.qed_chp_sch_data.hqm_core_flags.congestion_management
                            , qed_sch_data.qed_chp_sch_data.hqm_core_flags.write_buffer_optimization
                            , qed_sch_data.qed_chp_sch_data.hqm_core_flags.ignore_cq_depth
                            } ;
    end

    if ( qed_sch_pop & ( qed_sch_data.qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) & qed_sch_data.qed_chp_sch_data.hqm_core_flags.cq_is_ldb ) begin
      p0_sch_chp_state_nxt.cq_hcw_ecc                               = qed_sch_data.qed_chp_sch_data.cq_hcw_ecc ;
      p0_sch_chp_state_nxt.cq_hcw                                   = { ldb_cq_hcw_upper_corrected, qed_sch_data.qed_chp_sch_data.cq_hcw.ptr } ;
      p0_sch_chp_state_nxt.hqm_core_flags                           = qed_sch_data.qed_chp_sch_data.hqm_core_flags ;
      p0_sch_chp_state_nxt.cmp_id                                   = cmp_id_f ;
      cmp_id_nxt                                                    = cmp_id_f + 4'd1 ;
      p0_sch_chp_state_nxt.cq                                       = qed_sch_data.qed_chp_sch_data.cq ;
      p0_sch_chp_state_nxt.hist_list_v                              = 1'b1 ;
      p0_sch_chp_state_nxt.hist_list_data.ecc                       = 'd0 ;
      p0_sch_chp_state_nxt.hist_list_data.qe_wt                     = ldb_cq_hcw_upper_corrected.qe_wt ;
      p0_sch_chp_state_nxt.hist_list_data.hid                       = '0 ;
      p0_sch_chp_state_nxt.hist_list_data.hid                       = ldb_cq_hcw_upper_corrected.lockid_dir_info_tokens ;
      p0_sch_chp_state_nxt.hist_list_data.cmp_id                    = cmp_id_f ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.parity     = 1'd0 ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.qtype      = ldb_cq_hcw_upper_corrected.msg_info.qtype ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.qpri       = ldb_cq_hcw_upper_corrected.msg_info.qpri ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.qid        = ldb_cq_hcw_upper_corrected.msg_info.qid [ 5 : 0 ] ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.qidix_msb  = qed_sch_data.qed_chp_sch_data.hqm_core_flags.ignore_cq_depth ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.qidix      = qed_sch_data.qed_chp_sch_data.qidix ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.reord_mode = qed_sch_data.mode ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.reord_slot = qed_sch_data.slot ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.sn_fid     = ( ( ( ldb_cq_hcw_upper_corrected.msg_info.qtype == ATOMIC ) & ldb_cq_hcw_upper_corrected.ao_v ) | 
                                                                        ( ldb_cq_hcw_upper_corrected.msg_info.qtype == ORDERED ) ) ? qed_sch_data.sn  : 
                                                                      ( ldb_cq_hcw_upper_corrected.lockid_dir_info_tokens [ 11 : 0 ]  ) ;
      parity_check_pipe_e = 1'b1 ;
      parity_check_pipe_p = ^ { 1'b1
                              , qed_sch_data.qed_chp_sch_data.parity
                              , qed_sch_data.qed_chp_sch_data.hqm_core_flags.parity } ;
      parity_check_pipe_d = { 11'd0
                            , 2'd0 
                            , qed_sch_data.qed_chp_sch_data.cq
                            , qed_sch_data.qed_chp_sch_data.qidix
                            , 2'd0 
                            , qed_sch_data.qed_chp_sch_data.hqm_core_flags.cq_is_ldb
                            , qed_sch_data.qed_chp_sch_data.hqm_core_flags.congestion_management
                            , qed_sch_data.qed_chp_sch_data.hqm_core_flags.write_buffer_optimization
                            , qed_sch_data.qed_chp_sch_data.hqm_core_flags.ignore_cq_depth
                            } ;
    end

    if ( aqed_sch_pop ) begin
      p0_sch_chp_state_nxt.atmsch                                   = 1'b1 ;
      p0_sch_chp_state_nxt.cq_hcw_ecc                               = aqed_sch_data.cq_hcw_ecc ;
      p0_sch_chp_state_nxt.cq_hcw                                   = { ldb_cq_hcw_upper_corrected , aqed_sch_data.cq_hcw.ptr } ;
      p0_sch_chp_state_nxt.hqm_core_flags                           = aqed_sch_data.hqm_core_flags ;
      p0_sch_chp_state_nxt.cmp_id                                   = cmp_id_f ;
      cmp_id_nxt                                                    = cmp_id_f + 4'd1 ;
      p0_sch_chp_state_nxt.cq                                       = aqed_sch_data.cq ;
      p0_sch_chp_state_nxt.hist_list_v                              = 1'b1 ; 
      p0_sch_chp_state_nxt.hist_list_data.ecc                       = 'd0 ;
      p0_sch_chp_state_nxt.hist_list_data.qe_wt                     = ldb_cq_hcw_upper_corrected.qe_wt ;
      p0_sch_chp_state_nxt.hist_list_data.hid                       = ldb_cq_hcw_upper_corrected.lockid_dir_info_tokens ;
      p0_sch_chp_state_nxt.hist_list_data.cmp_id                    = cmp_id_f ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.parity     = 1'd0 ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.qtype      = ldb_cq_hcw_upper_corrected.msg_info.qtype ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.qpri       = ldb_cq_hcw_upper_corrected.msg_info.qpri ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.qid        = ldb_cq_hcw_upper_corrected.msg_info.qid [ 5 : 0 ] ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.qidix_msb  = aqed_sch_data.hqm_core_flags.ignore_cq_depth ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.qidix      = aqed_sch_data.qidix ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.reord_mode = '0 ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.reord_slot = '0 ;
      p0_sch_chp_state_nxt.hist_list_data.hist_list_info.sn_fid     = aqed_sch_data.fid ;

      parity_check_pipe_e = 1'b1 ;
      parity_check_pipe_p = ^ { 1'b1
                              , aqed_sch_data.parity
                              , aqed_sch_data.hqm_core_flags.parity } ;
      parity_check_pipe_d = { 6'd0
                            , aqed_sch_data.cq
                            , aqed_sch_data.qid
                            , aqed_sch_data.qidix
                            , 2'd0 
                            , aqed_sch_data.hqm_core_flags.cq_is_ldb
                            , aqed_sch_data.hqm_core_flags.congestion_management
                            , aqed_sch_data.hqm_core_flags.write_buffer_optimization
                            , aqed_sch_data.hqm_core_flags.ignore_cq_depth
                            } ;
    end
  end

  //====================================================================================================
  // drive history list push on P0 output
  //..................................................
  //  is_ldb=1 dequeue/schedule pushes the hist_list
  //  use hist_list_v flag credted in p0_nxt stage to control pushing hist list

  sch_hist_list_fifo_we_sel_nxt = sch_hist_list_fifo_we_sel_f ; 
  sch_hist_list_wrap_error                        = 1'b0 ;
  sch_hist_list_cmd_v                             = 1'd0 ; 
  sch_hist_list_a_cmd_v                           = 1'd0 ; 

  if ( schpipe_hqm_chp_target_cfg_hist_list_mode [ p0_sch_chp_state_f.cq [ 5 : 0 ] ] ) begin
    if ( p0_sch_chp_state_v_f & p0_sch_chp_state_f.hist_list_v ) begin
      if ( sch_hist_list_fifo_we_sel_f [ p0_sch_chp_state_f.cq [ 5 : 0 ] ] ) begin
        sch_hist_list_a_cmd_v                       = 1'b1 ;
      end
      else begin
        sch_hist_list_cmd_v                         = 1'b1 ;
      end
      sch_hist_list_fifo_we_sel_nxt [ p0_sch_chp_state_f.cq [ 5 : 0 ] ] = ~ sch_hist_list_fifo_we_sel_f [ p0_sch_chp_state_f.cq [ 5 : 0 ] ] ;
    end
  end
  else begin
    sch_hist_list_cmd_v                             = p0_sch_chp_state_v_f & p0_sch_chp_state_f.hist_list_v ;
    if ( ( p0_sch_chp_state_f.cq_hcw.msg_info.qtype == ATOMIC ) & p0_sch_chp_state_f.cq_hcw.ao_v ) begin
      sch_hist_list_a_cmd_v                         = p0_sch_chp_state_v_f & p0_sch_chp_state_f.hist_list_v ;
    end
  end

  sch_hist_list_cmd                               = HQM_AW_MF_PUSH ;
  sch_hist_list_fifo_num                          = p0_sch_chp_state_f.cq [ 5 : 0 ] ;
  sch_hist_list_push_data                         = p0_sch_chp_state_f.hist_list_data ;
  if ( ( p0_sch_chp_state_f.cq_hcw.msg_info.qtype == ATOMIC ) & p0_sch_chp_state_f.cq_hcw.ao_v ) begin
    sch_hist_list_push_data.hist_list_info.qtype  = ORDERED ;
  end
  sch_hist_list_push_data.hist_list_info.parity   = hist_list_parity ;
  sch_hist_list_push_data.ecc                     = hist_list_ecc ;

  sch_hist_list_a_cmd                             = HQM_AW_MF_PUSH ;
  sch_hist_list_a_fifo_num                        = p0_sch_chp_state_f.cq [ 5 : 0 ] ;
  sch_hist_list_a_push_data                       = p0_sch_chp_state_f.hist_list_data ;
  if ( ( p0_sch_chp_state_f.cq_hcw.msg_info.qtype == ATOMIC ) & p0_sch_chp_state_f.cq_hcw.ao_v ) begin
    sch_hist_list_a_push_data.hist_list_info.sn_fid = p0_sch_chp_state_fid_f ;
  end
  sch_hist_list_a_push_data.hist_list_info.parity = hist_list_a_parity ;
  sch_hist_list_a_push_data.ecc                   = hist_list_a_ecc ;

  p5_sch_chp_state_nxt.error                      =  sch_hist_list_of | sch_hist_list_a_of | sch_hist_list_wrap_error ; //Send to egress to load into HCW after ECC correction

  //====================================================================================================
  // P5: freelist push return
  //  push freelist ID back onto multi FIFO
  //  NOTE: push freelist ID on all operations except atmsch since it does not have a freelist ID

  //====================================================================================================
  // P5: send HCW, flags and special control to dequeue drain FIFO
  //..................................................
  // push dequeue drain FIFO
  fifo_outbound_hcw_push                          = p5_sch_chp_state_v_f ;
  fifo_outbound_hcw_push_data.hcw_ecc             = p5_sch_chp_state_f.cq_hcw_ecc ;
  fifo_outbound_hcw_push_data.hcw                 = p5_sch_chp_state_f.cq_hcw ;
  fifo_outbound_hcw_push_data.flags               = p5_sch_chp_state_f.hqm_core_flags ;
  fifo_outbound_hcw_push_data.flags.pad_ok        = hqm_chp_partial_outbound_hcw_fifo_parity ;
  fifo_outbound_hcw_push_data.cmp_id              = p5_sch_chp_state_f.cmp_id ;
  fifo_outbound_hcw_push_data.cq                  = p5_sch_chp_state_f.cq [ 6 : 0 ] ;
  fifo_outbound_hcw_push_data.cq_is_ldb           = p5_sch_chp_state_f.hqm_core_flags.cq_is_ldb ;
  fifo_outbound_hcw_push_data.error               = p5_sch_chp_state_f.error ;

end

//https://hsdes.intel.com/appstore/article/#/1407239306
// bit 6 of cq field used to carry parity

hqm_AW_parity_gen #(
      .WIDTH( $bits(fifo_outbound_hcw_push_data.cq[6:0]) + 
              $bits(fifo_outbound_hcw_push_data.cq_is_ldb) + 
              $bits(fifo_outbound_hcw_push_data.error) + 
              $bits(fifo_outbound_hcw_push_data.cmp_id) )
) i_hqm_chp_partial_outbound_hcw_fifo_parity_gen (
        .d     ( {p5_sch_chp_state_f.cq [ 6 : 0 ], p5_sch_chp_state_f.hqm_core_flags.cq_is_ldb,p5_sch_chp_state_f.error,p5_sch_chp_state_f.cmp_id} )
       ,.odd   ( 1'b1 ) // odd
       ,.p     ( hqm_chp_partial_outbound_hcw_fifo_parity )
);

endmodule
