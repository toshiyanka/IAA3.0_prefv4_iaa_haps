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
module hqm_credit_hist_pipe_shared_pipe
  import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(

  input	 logic                                    hqm_gated_clk
, input  logic                                    hqm_gated_rst_b
, input  logic                                    hqm_proc_reset_done

//cfg

//errors
, output logic                                    sharepipe_error

//counter

//smon

//status


// Functional Interface

////////////////////////////////////////////////////////////////////////////////////////////////////

, input  logic [ ( 32 ) - 1 : 0]                        hqm_chp_target_cfg_chp_palb_control_reg_f
, input  logic [ ( 1 * 6 * HQM_NUM_LB_CQ ) - 1 : 0 ]	hqm_chp_target_cfg_ldb_cq2vas_reg_f

, output logic [ ( HQM_NUM_LB_CQ ) - 1 : 0 ]		     chp_lsp_ldb_cq_off

, output logic                                    hqm_chp_target_cfg_vas_credit_count_reg_load
, output logic [ ( 1 * 17 * 32 ) - 1 : 0]         hqm_chp_target_cfg_vas_credit_count_reg_nxt 
, input  logic [ ( 1 * 17 * 32 ) - 1 : 0]         hqm_chp_target_cfg_vas_credit_count_reg_f

, output logic                                    hist_list_cmd_v
, output aw_multi_fifo_cmd_t                      hist_list_cmd
, output logic [ 5 : 0 ]                          hist_list_fifo_num
, output hist_list_mf_t                           hist_list_push_data
, input  hist_list_mf_t                           hist_list_pop_data
, input  logic                                    hist_list_uf
, input  logic                                    hist_list_of
, input  logic                                    hist_list_residue_error

, output logic                                    hist_list_a_cmd_v
, output aw_multi_fifo_cmd_t                      hist_list_a_cmd
, output logic [ 5 : 0 ]                          hist_list_a_fifo_num
, output hist_list_mf_t                           hist_list_a_push_data
, input  logic                                    hist_list_a_pop_data_v
, input  hist_list_mf_t                           hist_list_a_pop_data
, input  logic                                    hist_list_a_uf
, input  logic                                    hist_list_a_of
, input  logic                                    hist_list_a_residue_error

, input  logic                                    freelist_pf_push_v
, output logic                                    freelist_push_v
, output chp_flid_t                               freelist_push_data
, output logic                                    freelist_pop_v
, input  logic                                    freelist_pop_error
, input  chp_flid_t                               freelist_pop_data
, input  logic                                    freelist_eccerr_mb
, input  logic                                    freelist_uf

////////////////////////////////////////////////////////////////////////////////////////////////////
, output chp_credit_count_t                       ing_enq_vas_credit_count_rdata
, input  logic                                    ing_enq_vas_credit_count_we
, input  logic [ 4 : 0 ]                          ing_enq_vas_credit_count_addr
, input  chp_credit_count_t                       ing_enq_vas_credit_count_wdata

, input  logic                                    enq_hist_list_cmd_v
, input  aw_multi_fifo_cmd_t                      enq_hist_list_cmd
, input  logic [ 5 : 0 ]                          enq_hist_list_fifo_num
, output hist_list_mf_t                           enq_hist_list_pop_data
, output logic                                    enq_hist_list_uf
, output logic                                    enq_hist_list_residue_error

, input  logic                                    enq_hist_list_a_cmd_v
, input  aw_multi_fifo_cmd_t                      enq_hist_list_a_cmd
, input  logic [ 5 : 0 ]                          enq_hist_list_a_fifo_num

, input  logic                                    enq_freelist_pop_v
, output chp_flid_t                               enq_freelist_pop_data
, output logic                                    enq_freelist_pop_error
, output logic                                    enq_freelist_error_mb
, output logic                                    enq_freelist_uf

////////////////////////////////////////////////////////////////////////////////////////////////////

, output chp_credit_count_t                       ing_sch_vas_credit_count_rdata
, input  logic                                    ing_sch_vas_credit_count_we
, input  logic [ 4 : 0 ]                          ing_sch_vas_credit_count_addr
, input  chp_credit_count_t                       ing_sch_vas_credit_count_wdata

, input  logic                                    sch_hist_list_cmd_v
, input  aw_multi_fifo_cmd_t                      sch_hist_list_cmd
, input  logic [ 5 : 0 ]                          sch_hist_list_fifo_num
, input  hist_list_mf_t                           sch_hist_list_push_data
, output logic                                    sch_hist_list_of

, input  logic                                    sch_hist_list_a_cmd_v
, input  aw_multi_fifo_cmd_t                      sch_hist_list_a_cmd
, input  logic [ 5 : 0 ]                          sch_hist_list_a_fifo_num
, input  hist_list_mf_t                           sch_hist_list_a_push_data
, output logic                                    sch_hist_list_a_of

, input  logic                                    ing_freelist_push_v
, input  chp_flid_t                               ing_freelist_push_data

, output logic                                    func_ldb_cq_on_off_threshold_re
, output logic [( HQM_NUM_LB_CQB2 ) - 1 : 0 ]     func_ldb_cq_on_off_threshold_raddr
, output logic [( HQM_NUM_LB_CQB2 ) - 1 : 0 ]     func_ldb_cq_on_off_threshold_waddr
, output logic                                    func_ldb_cq_on_off_threshold_we
, output ldb_cq_on_off_threshold_t                func_ldb_cq_on_off_threshold_wdata
, input  ldb_cq_on_off_threshold_t                func_ldb_cq_on_off_threshold_rdata
) ;

parameter CREDIT_COUNT_WIDTH = $bits ( chp_credit_count_t ) ;

cfg_palb_control_t cfg_palb_control_nxt ;
cfg_palb_control_t cfg_palb_control_f ;

logic [ ( 16 ) - 1 : 0 ] p0_cq_on_off_thrsh_chk_ctr_nxt ;
logic [ ( 16 ) - 1 : 0 ] p0_cq_on_off_thrsh_chk_ctr_f ;

logic [ ( 6 ) - 1 : 0 ] p0_ldb_cq ;
logic [ ( 6 ) - 1 : 0 ] p1_ldb_cq_nxt ;
logic [ ( 6 ) - 1 : 0 ] p1_ldb_cq_f ;
logic [ ( 6 ) - 1 : 0 ] p2_ldb_cq_nxt ;
logic [ ( 6 ) - 1 : 0 ] p2_ldb_cq_f ;
logic p1_ldb_vas_parity_nxt ;
logic p1_ldb_vas_parity_f ;
logic [ ( 5 ) - 1 : 0 ] p1_ldb_vas_nxt ;
logic [ ( 5 ) - 1 : 0 ] p1_ldb_vas_f ;
logic p1_ldb_vas_parity_check_enable_nxt ;
logic p1_ldb_vas_parity_check_enable_f ;
logic p1_ldb_vas_parity_check_odd ;
logic p1_ldb_vas_parity_error ;
chp_credit_count_t p2_ldb_vas_credit_nxt ;
chp_credit_count_t p2_ldb_vas_credit_f ;
logic rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_nxt ;
logic rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_f ; 
logic rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_odd ;
logic [ 1 : 0 ] rw_ldb_cq_on_off_threshold_p2_data_f_parity_error ;
logic p3_chp_lsp_ldb_cq_on_set ;
logic p3_chp_lsp_ldb_cq_on_hold ;
logic p3_chp_lsp_ldb_cq_on_clear ;
logic [ ( HQM_NUM_LB_CQ ) - 1 : 0 ] p3_chp_lsp_ldb_cq_on_nxt ;
logic [ ( HQM_NUM_LB_CQ ) - 1 : 0 ] p3_chp_lsp_ldb_cq_off_f ;

chp_credit_count_t vas_credit_count_mem [ 31 : 0 ] ;

logic rw_ldb_cq_on_off_threshold_status_nc ;
logic rw_ldb_cq_on_off_threshold_p0_v_nxt ;
aw_rwpipe_cmd_t rw_ldb_cq_on_off_threshold_p0_rw_nxt ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_on_off_threshold_p0_addr_nxt ;

logic rw_ldb_cq_on_off_threshold_p0_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_on_off_threshold_p0_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_on_off_threshold_p0_addr_f ;
ldb_cq_on_off_threshold_t rw_ldb_cq_on_off_threshold_p0_data_f_nc ;

logic rw_ldb_cq_on_off_threshold_p1_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_on_off_threshold_p1_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_on_off_threshold_p1_addr_f_nc ;
ldb_cq_on_off_threshold_t rw_ldb_cq_on_off_threshold_p1_data_f_nc ;

logic rw_ldb_cq_on_off_threshold_p2_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_on_off_threshold_p2_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_on_off_threshold_p2_addr_f_nc ;
ldb_cq_on_off_threshold_t rw_ldb_cq_on_off_threshold_p2_data_f ;

logic rw_ldb_cq_on_off_threshold_p3_v_f_nc ;
aw_rwpipe_cmd_t rw_ldb_cq_on_off_threshold_p3_rw_f_nc ;
logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] rw_ldb_cq_on_off_threshold_p3_addr_f_nc ;
ldb_cq_on_off_threshold_t rw_ldb_cq_on_off_threshold_p3_data_f_nc ;

logic [ ( HQM_NUM_LB_CQB2 ) - 1 : 0 ] func_ldb_cq_on_off_threshold_addr ;

logic sharepipe_error_nxt ;
logic sharepipe_error_f ;

assign func_ldb_cq_on_off_threshold_raddr = func_ldb_cq_on_off_threshold_addr ;
assign func_ldb_cq_on_off_threshold_waddr = func_ldb_cq_on_off_threshold_addr ;

assign chp_lsp_ldb_cq_off = p3_chp_lsp_ldb_cq_off_f ;

assign ing_enq_vas_credit_count_rdata = vas_credit_count_mem [ ing_enq_vas_credit_count_addr ] ;
assign ing_sch_vas_credit_count_rdata = vas_credit_count_mem [ ing_sch_vas_credit_count_addr ] ;

assign hist_list_cmd_v                                 = enq_hist_list_cmd_v | sch_hist_list_cmd_v ;
assign hist_list_cmd                                   = enq_hist_list_cmd_v ? enq_hist_list_cmd : sch_hist_list_cmd ;
assign hist_list_fifo_num                              = enq_hist_list_cmd_v ? enq_hist_list_fifo_num : sch_hist_list_fifo_num ;
assign hist_list_push_data                             = sch_hist_list_push_data ;
assign enq_hist_list_pop_data                          = hist_list_a_pop_data_v ? hist_list_a_pop_data : hist_list_pop_data ;
assign enq_hist_list_uf                                = hist_list_a_pop_data_v ? hist_list_a_uf : hist_list_uf ;
assign enq_hist_list_residue_error                     = hist_list_a_pop_data_v ? hist_list_a_residue_error : hist_list_residue_error ;
assign sch_hist_list_of                                = hist_list_of ;

assign hist_list_a_cmd_v                               = enq_hist_list_a_cmd_v | sch_hist_list_a_cmd_v ;
assign hist_list_a_cmd                                 = enq_hist_list_a_cmd_v ? enq_hist_list_a_cmd : sch_hist_list_a_cmd ;
assign hist_list_a_fifo_num                            = enq_hist_list_a_cmd_v ? enq_hist_list_a_fifo_num : sch_hist_list_a_fifo_num ;
assign hist_list_a_push_data                           = sch_hist_list_a_push_data ;
assign sch_hist_list_a_of                              = hist_list_a_of ;

assign freelist_pop_v                                  = enq_freelist_pop_v ;
assign freelist_push_v                                 = ing_freelist_push_v ;
assign freelist_push_data                              = ing_freelist_push_data ;
assign enq_freelist_pop_data                           = freelist_pop_data ;
assign enq_freelist_pop_error                          = freelist_pop_error ;
assign enq_freelist_error_mb                           = freelist_eccerr_mb ;
assign enq_freelist_uf                                 = freelist_uf ;

assign sharepipe_error_nxt = ( ( enq_hist_list_cmd_v & sch_hist_list_cmd_v )
                               | ( enq_hist_list_a_cmd_v & sch_hist_list_a_cmd_v )
                               | ( freelist_pf_push_v & ing_freelist_push_v )
                               | p1_ldb_vas_parity_error
                               | rw_ldb_cq_on_off_threshold_p2_data_f_parity_error [ 0 ] 
                               | rw_ldb_cq_on_off_threshold_p2_data_f_parity_error [ 1 ] 
                             ) ;

assign sharepipe_error = sharepipe_error_f ;
 
hqm_AW_parity_check # (
  .WIDTH							( $bits ( p1_ldb_vas_f ) )
) i_p1_ldb_vas_parity_check (               
  .p								( p1_ldb_vas_parity_f )
, .d								( p1_ldb_vas_f ) 
, .e								( p1_ldb_vas_parity_check_enable_f )
, .odd								( p1_ldb_vas_parity_check_odd )
, .err								( p1_ldb_vas_parity_error )
) ;

hqm_AW_parity_check # (
  .WIDTH							( $bits ( rw_ldb_cq_on_off_threshold_p2_data_f.on_thrsh ) )
) i_rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_0 (
  .p								( rw_ldb_cq_on_off_threshold_p2_data_f.parity [ 0 ] )
, .d								( rw_ldb_cq_on_off_threshold_p2_data_f.on_thrsh ) 
, .e								( rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_f )
, .odd								( rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_odd )
, .err								( rw_ldb_cq_on_off_threshold_p2_data_f_parity_error [ 0 ] )
) ;

hqm_AW_parity_check # (
  .WIDTH							( $bits ( rw_ldb_cq_on_off_threshold_p2_data_f.off_thrsh ) )
) i_rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_1 (
  .p								( rw_ldb_cq_on_off_threshold_p2_data_f.parity [ 1 ] )
, .d								( rw_ldb_cq_on_off_threshold_p2_data_f.off_thrsh ) 
, .e								( rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_f )
, .odd								( rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_odd )
, .err								( rw_ldb_cq_on_off_threshold_p2_data_f_parity_error [ 1 ] )
) ;

always_comb begin
  rw_ldb_cq_on_off_threshold_p0_v_nxt = 1'b0 ;
  rw_ldb_cq_on_off_threshold_p0_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_ldb_cq_on_off_threshold_p0_addr_nxt = rw_ldb_cq_on_off_threshold_p0_addr_f ;

  cfg_palb_control_nxt.enable = hqm_chp_target_cfg_chp_palb_control_reg_f [ 31 ] ;
  cfg_palb_control_nxt.period = 16'd64 ;
  if ( hqm_chp_target_cfg_chp_palb_control_reg_f [ 3 : 0 ] >= 7 ) begin
    cfg_palb_control_nxt.period = ( 1 << hqm_chp_target_cfg_chp_palb_control_reg_f [ 3 : 0 ] ) ;
  end
  p0_cq_on_off_thrsh_chk_ctr_nxt = p0_cq_on_off_thrsh_chk_ctr_f ;
  p0_ldb_cq = p0_cq_on_off_thrsh_chk_ctr_f [ HQM_NUM_LB_CQB2 - 1 : 0 ] ;
  p1_ldb_vas_parity_check_odd = 1'b1 ;
  p1_ldb_vas_parity_nxt = p1_ldb_vas_parity_f ;
  p1_ldb_vas_nxt = p1_ldb_vas_f ;
  p1_ldb_cq_nxt = p1_ldb_cq_f ;
  p1_ldb_vas_parity_check_enable_nxt = p1_ldb_vas_parity_check_enable_f ;
  rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_odd = 1'b1 ;
  rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_nxt = rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_f ;
  p2_ldb_cq_nxt = p2_ldb_cq_f ;
  p2_ldb_vas_credit_nxt = p2_ldb_vas_credit_f ;
  p3_chp_lsp_ldb_cq_on_nxt = cfg_palb_control_f.enable ? ~ p3_chp_lsp_ldb_cq_off_f : { HQM_NUM_LB_CQ { 1'b1 } } ;
  p3_chp_lsp_ldb_cq_on_set = ( rw_ldb_cq_on_off_threshold_p2_data_f.on_thrsh == rw_ldb_cq_on_off_threshold_p2_data_f.off_thrsh ) |
                             ( rw_ldb_cq_on_off_threshold_p2_data_f.on_thrsh == 15'h0 ) |
                             ( rw_ldb_cq_on_off_threshold_p2_data_f.off_thrsh == 15'h0 ) |
                             ( p2_ldb_vas_credit_f.count == 15'h0 ) ;
  p3_chp_lsp_ldb_cq_on_hold = ( p2_ldb_vas_credit_f.count <= rw_ldb_cq_on_off_threshold_p2_data_f.off_thrsh ) ;
  p3_chp_lsp_ldb_cq_on_clear = ( p2_ldb_vas_credit_f.count > rw_ldb_cq_on_off_threshold_p2_data_f.on_thrsh ) ;

  if ( hqm_proc_reset_done & cfg_palb_control_f.enable ) begin
    if ( ( cfg_palb_control_nxt.period & ~ cfg_palb_control_f.period ) | ( p0_cq_on_off_thrsh_chk_ctr_f >= cfg_palb_control_f.period ) ) begin
      p0_cq_on_off_thrsh_chk_ctr_nxt = 16'h0000 ;
    end
    else begin
      p0_cq_on_off_thrsh_chk_ctr_nxt = p0_cq_on_off_thrsh_chk_ctr_f + 1'b1 ;
    end

    p1_ldb_vas_parity_nxt = hqm_chp_target_cfg_ldb_cq2vas_reg_f [ ( ( p0_ldb_cq * 6 ) + 5 ) +: 1 ] ; 
    p1_ldb_vas_nxt        = hqm_chp_target_cfg_ldb_cq2vas_reg_f [   ( p0_ldb_cq * 6 )       +: 5 ] ;
    p1_ldb_vas_parity_check_enable_nxt = ( p0_cq_on_off_thrsh_chk_ctr_f < HQM_NUM_LB_CQ ) ;

    p1_ldb_cq_nxt = p1_ldb_vas_parity_check_enable_nxt ? p0_ldb_cq : p1_ldb_cq_f ;

    if ( p1_ldb_vas_parity_check_enable_f ) begin
      p2_ldb_vas_credit_nxt = hqm_chp_target_cfg_vas_credit_count_reg_f [ p1_ldb_vas_f * CREDIT_COUNT_WIDTH +: CREDIT_COUNT_WIDTH ] ; 
    end

    rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_nxt = p1_ldb_vas_parity_check_enable_f ;

    p2_ldb_cq_nxt = rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_nxt ? p1_ldb_cq_f : p2_ldb_cq_f ;

    p3_chp_lsp_ldb_cq_on_nxt = ~ p3_chp_lsp_ldb_cq_off_f ;
    if ( rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_f ) begin
      if ( p3_chp_lsp_ldb_cq_off_f [ p2_ldb_cq_f ] == 1'b0 ) begin
        p3_chp_lsp_ldb_cq_on_nxt [ p2_ldb_cq_f ] = p3_chp_lsp_ldb_cq_on_set | p3_chp_lsp_ldb_cq_on_hold ;
      end
      else begin
        p3_chp_lsp_ldb_cq_on_nxt [ p2_ldb_cq_f ] = p3_chp_lsp_ldb_cq_on_set | ( ~ p3_chp_lsp_ldb_cq_on_clear ) ;
      end
    end
  end

  if ( hqm_proc_reset_done & cfg_palb_control_nxt.enable ) begin
    if ( p0_cq_on_off_thrsh_chk_ctr_nxt < HQM_NUM_LB_CQ ) begin 
      rw_ldb_cq_on_off_threshold_p0_v_nxt = 1'b1 ;
      rw_ldb_cq_on_off_threshold_p0_addr_nxt = p0_cq_on_off_thrsh_chk_ctr_nxt [ HQM_NUM_LB_CQB2 - 1 : 0 ] ;
      rw_ldb_cq_on_off_threshold_p0_rw_nxt = HQM_AW_RWPIPE_READ ;
    end
  end

  for ( int i = 0; i < 32 ; i++ ) begin
    vas_credit_count_mem [ i ] = hqm_chp_target_cfg_vas_credit_count_reg_f [ i * CREDIT_COUNT_WIDTH +: CREDIT_COUNT_WIDTH ] ;
  end
  hqm_chp_target_cfg_vas_credit_count_reg_load = 1'b0 ;
  hqm_chp_target_cfg_vas_credit_count_reg_nxt = hqm_chp_target_cfg_vas_credit_count_reg_f ; 
  if ( ing_enq_vas_credit_count_we & ing_sch_vas_credit_count_we & ( ing_enq_vas_credit_count_addr == ing_sch_vas_credit_count_addr ) ) begin
    hqm_chp_target_cfg_vas_credit_count_reg_load = 1'b0 ;
  end
  else begin
    if ( ing_enq_vas_credit_count_we ) begin
      hqm_chp_target_cfg_vas_credit_count_reg_load = 1'b1 ;
      hqm_chp_target_cfg_vas_credit_count_reg_nxt [ ing_enq_vas_credit_count_addr * CREDIT_COUNT_WIDTH +: 17 ] = ing_enq_vas_credit_count_wdata ; 
    end
    if ( ing_sch_vas_credit_count_we ) begin
      hqm_chp_target_cfg_vas_credit_count_reg_load = 1'b1 ;
      hqm_chp_target_cfg_vas_credit_count_reg_nxt [ ing_sch_vas_credit_count_addr * CREDIT_COUNT_WIDTH +: 17 ] = ing_sch_vas_credit_count_wdata ; 
    end
  end
end // always_comb

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_b ) begin
  if ( ~ hqm_gated_rst_b ) begin
    sharepipe_error_f <= 1'b0 ;
    cfg_palb_control_f <= 17'h0 ;
    p0_cq_on_off_thrsh_chk_ctr_f <= 16'h0 ;
    p1_ldb_vas_parity_check_enable_f <= 1'b0 ;
    rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_f <= 1'b0 ;
    p3_chp_lsp_ldb_cq_off_f <= { HQM_NUM_LB_CQ { 1'b0 } } ;
  end
  else begin
    sharepipe_error_f <= sharepipe_error_nxt ;
    cfg_palb_control_f <= cfg_palb_control_nxt ;
    p0_cq_on_off_thrsh_chk_ctr_f <= p0_cq_on_off_thrsh_chk_ctr_nxt ;
    p1_ldb_vas_parity_check_enable_f <= p1_ldb_vas_parity_check_enable_nxt ;
    rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_f <= rw_ldb_cq_on_off_threshold_p2_data_f_parity_check_enable_nxt ;
    p3_chp_lsp_ldb_cq_off_f <= ~ p3_chp_lsp_ldb_cq_on_nxt ;
  end
end

always_ff @ ( posedge hqm_gated_clk ) begin
  p1_ldb_cq_f <= p1_ldb_cq_nxt ;
  p2_ldb_cq_f <= p2_ldb_cq_nxt ;
  p1_ldb_vas_f <= p1_ldb_vas_nxt ;
  p1_ldb_vas_parity_f <= p1_ldb_vas_parity_nxt ;
  p2_ldb_vas_credit_f <= p2_ldb_vas_credit_nxt ;
end

hqm_AW_rw_mem_4pipe # (
   .DEPTH                             ( HQM_NUM_LB_CQ )
 , .WIDTH                             ( $bits ( func_ldb_cq_on_off_threshold_wdata ) )
) i_rw_ldb_cq_on_off_threshold (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_b )
 , .status                            ( rw_ldb_cq_on_off_threshold_status_nc )
 , .p0_v_nxt                          ( rw_ldb_cq_on_off_threshold_p0_v_nxt )
 , .p0_rw_nxt                         ( rw_ldb_cq_on_off_threshold_p0_rw_nxt )
 , .p0_addr_nxt                       ( rw_ldb_cq_on_off_threshold_p0_addr_nxt )
 , .p0_write_data_nxt                 ( '0 )
 , .p0_hold                           ( '0 )
 , .p0_v_f                            ( rw_ldb_cq_on_off_threshold_p0_v_f_nc )
 , .p0_rw_f                           ( rw_ldb_cq_on_off_threshold_p0_rw_f_nc )
 , .p0_addr_f                         ( rw_ldb_cq_on_off_threshold_p0_addr_f )
 , .p0_data_f                         ( rw_ldb_cq_on_off_threshold_p0_data_f_nc )
 , .p1_hold                           ( '0 )
 , .p1_v_f                            ( rw_ldb_cq_on_off_threshold_p1_v_f_nc )
 , .p1_rw_f                           ( rw_ldb_cq_on_off_threshold_p1_rw_f_nc )
 , .p1_addr_f                         ( rw_ldb_cq_on_off_threshold_p1_addr_f_nc )
 , .p1_data_f                         ( rw_ldb_cq_on_off_threshold_p1_data_f_nc )
 , .p2_hold                           ( '0 )
 , .p2_v_f                            ( rw_ldb_cq_on_off_threshold_p2_v_f_nc )
 , .p2_rw_f                           ( rw_ldb_cq_on_off_threshold_p2_rw_f_nc )
 , .p2_addr_f                         ( rw_ldb_cq_on_off_threshold_p2_addr_f_nc )
 , .p2_data_f                         ( rw_ldb_cq_on_off_threshold_p2_data_f )
 , .p3_hold                           ( '0 )
 , .p3_v_f                            ( rw_ldb_cq_on_off_threshold_p3_v_f_nc )
 , .p3_rw_f                           ( rw_ldb_cq_on_off_threshold_p3_rw_f_nc )
 , .p3_addr_f                         ( rw_ldb_cq_on_off_threshold_p3_addr_f_nc )
 , .p3_data_f                         ( rw_ldb_cq_on_off_threshold_p3_data_f_nc )
 , .mem_write                         ( func_ldb_cq_on_off_threshold_we )
 , .mem_read                          ( func_ldb_cq_on_off_threshold_re )
 , .mem_addr                          ( func_ldb_cq_on_off_threshold_addr )
 , .mem_write_data                    ( func_ldb_cq_on_off_threshold_wdata )
 , .mem_read_data                     ( func_ldb_cq_on_off_threshold_rdata )
) ;

endmodule
