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
// hqm_credit_hist_pipe
//
// TKM 0.3
//
//-----------------------------------------------------------------------------------------------------
module hqm_chp_cwdi_wrap 
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
#(
  parameter HQM_NUM_DIR_CQ = 64
 ,parameter HQM_NUM_LDB_CQ = 64
 ,parameter HQM_CQ_TIM_WIDTH_INTERVAL = 28
 ,parameter HQM_CQ_TIM_WIDTH_THRESHOLD = 8
 ,parameter HQM_CQ_TIM_TYPE = 1

 // derived
 ,parameter HQM_NUM_DIR_CQ_B2 = (AW_logb2 ( HQM_NUM_DIR_CQ -1 ) + 1)
 ,parameter HQM_NUM_LDB_CQ_B2 = (AW_logb2 ( HQM_NUM_LDB_CQ -1 ) + 1)

) (

   input  logic                                      hqm_gated_clk
  ,input  logic                                      hqm_gated_rst_n

  ,input  logic                                      rst_prep
  ,input  logic                                      hqm_flr_prep
                                                    
  ,input  logic                                      hqm_pgcb_clk
  ,input  logic                                      hqm_pgcb_rst_n
                                                    
  ,input  logic                                      ldb_cfg_wd_load_cg_f
  ,input  logic                                      dir_cfg_wd_load_cg_f
                                                    
                                                    
  ,input  logic                                      hqm_pgcb_rst_n_done   
  ,input  logic                                      idle_cwdi_timer_report_control 


  // - begin
  // ldb
  ,output logic                                      ldb_hw_pgcb_init_done
                                                     
  ,input  cq_int_info_t                              enq_ldb_excep
  ,input  cq_int_info_t                              sch_ldb_excep
                                                     
  ,output logic [HQM_NUM_LDB_CQ-1:0]                 ldb_wd_irq

  ,input  logic [HQM_NUM_LDB_CQ-1:0]                 ldb_cfg_wd_disable_reg_f
  ,output logic [HQM_NUM_LDB_CQ-1:0]                 ldb_cfg_wd_disable_reg_nxt
                                                     
  ,input  logic [HQM_NUM_LDB_CQ-1:0]                 hqm_chp_target_cfg_ldb_cq_wd_enb_reg_f
  ,output logic [HQM_NUM_LDB_CQ-1:0]                 hqm_chp_target_cfg_ldb_cq_wd_enb_reg_nxt

  ,output logic                                      func_count_rmw_pipe_wd_ldb_mem_we
  ,output logic [HQM_NUM_LDB_CQ_B2-1:0]              func_count_rmw_pipe_wd_ldb_mem_waddr
  ,output logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] func_count_rmw_pipe_wd_ldb_mem_wdata
  ,output logic                                      func_count_rmw_pipe_wd_ldb_mem_re
  ,output logic [HQM_NUM_LDB_CQ_B2-1:0]              func_count_rmw_pipe_wd_ldb_mem_raddr
  ,input  logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] func_count_rmw_pipe_wd_ldb_mem_rdata
                                               
  ,output logic                                      pf_count_rmw_pipe_wd_ldb_mem_re
  ,output logic [HQM_NUM_LDB_CQ_B2-1:0]              pf_count_rmw_pipe_wd_ldb_mem_raddr
  ,output logic [HQM_NUM_LDB_CQ_B2-1:0]              pf_count_rmw_pipe_wd_ldb_mem_waddr
  ,output logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] pf_count_rmw_pipe_wd_ldb_mem_wdata
  ,output logic                                      pf_count_rmw_pipe_wd_ldb_mem_we
  ,input logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] pf_count_rmw_pipe_wd_ldb_mem_rdata
                                               
  ,output logic [31:0]                               hqm_chp_wd_ldb_pipe_status_pnc
                                                     
  ,input  logic                                      hqm_chp_target_cfg_ldb_wd_enb_interval_update_v
  ,input  logic [31:0]                               hqm_chp_target_cfg_ldb_wd_enb_interval_reg_f

  ,input  logic                                      hqm_chp_target_cfg_ldb_wd_threshold_update_v
  ,input  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]     hqm_chp_target_cfg_ldb_wd_threshold_reg_f

  // dir 
  ,output logic                                      dir_hw_pgcb_init_done
                                                     
  ,input  cq_int_info_t                              enq_dir_excep
  ,input  cq_int_info_t                              sch_dir_excep
                                                     
  ,output logic [HQM_NUM_DIR_CQ-1:0]                 dir_wd_irq
                                                     
  ,input  logic [HQM_NUM_DIR_CQ-1:0]                 dir_cfg_wd_disable_reg_f
  ,output logic [HQM_NUM_DIR_CQ-1:0]                 dir_cfg_wd_disable_reg_nxt
                                                     
  ,input  logic [HQM_NUM_DIR_CQ-1:0]                 hqm_chp_target_cfg_dir_cq_wd_enb_reg_f
  ,output logic [HQM_NUM_DIR_CQ-1:0]                 hqm_chp_target_cfg_dir_cq_wd_enb_reg_nxt

  ,output logic                                      func_count_rmw_pipe_wd_dir_mem_we
  ,output logic [HQM_NUM_DIR_CQ_B2-1:0]              func_count_rmw_pipe_wd_dir_mem_waddr
  ,output logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] func_count_rmw_pipe_wd_dir_mem_wdata
  ,output logic                                      func_count_rmw_pipe_wd_dir_mem_re
  ,output logic [HQM_NUM_DIR_CQ_B2-1:0]              func_count_rmw_pipe_wd_dir_mem_raddr
  ,input  logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] func_count_rmw_pipe_wd_dir_mem_rdata
                                               
  ,output logic                                      pf_count_rmw_pipe_wd_dir_mem_re
  ,output logic [HQM_NUM_DIR_CQ_B2-1:0]              pf_count_rmw_pipe_wd_dir_mem_raddr
  ,output logic [HQM_NUM_DIR_CQ_B2-1:0]              pf_count_rmw_pipe_wd_dir_mem_waddr
  ,output logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] pf_count_rmw_pipe_wd_dir_mem_wdata
  ,output logic                                      pf_count_rmw_pipe_wd_dir_mem_we
  ,input logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] pf_count_rmw_pipe_wd_dir_mem_rdata
                                               
  ,output logic [31:0]                               hqm_chp_wd_dir_pipe_status_pnc
                                                     
  ,input  logic                                      hqm_chp_target_cfg_dir_wd_enb_interval_update_v 
  ,input  logic [31:0]                               hqm_chp_target_cfg_dir_wd_enb_interval_reg_f

  ,input  logic                                      hqm_chp_target_cfg_dir_wd_threshold_update_v
  ,input  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]     hqm_chp_target_cfg_dir_wd_threshold_reg_f

  ,output logic                                      wd_clkreq

  // - end

  ,output logic                                      cwdi_interrupt_w_req_valid
  ,input  logic                                      cwdi_interrupt_w_req_ready

                                                     
  ,output logic [HQM_NUM_DIR_CQ-1:0]                 dir_wdto_nxt
  ,output logic                                      dir_wdto_v
  ,output logic [HQM_NUM_LDB_CQ-1:0]                 ldb_wdto_nxt
  ,output logic                                      ldb_wdto_v

  ,output logic                                      wd_irq_idle

  ,output logic [6:0]                                wd_tx_sync_status

  ,output logic                                      wd_tx_sync_idle

  ,output logic                                      cq_timer_threshold_parity_err_dir
  ,output logic                                      cq_timer_threshold_parity_err_ldb

  ,output logic                                      sch_excep_parity_check_err_dir
  ,output logic                                      sch_excep_parity_check_err_ldb

  ,output logic [HQM_NUM_DIR_CQ-1:0]                 hqm_chp_target_cfg_dir_wdrt_status
  ,output logic [HQM_NUM_LDB_CQ-1:0]                 hqm_chp_target_cfg_ldb_wdrt_status            


);

cwdi_interrupt_w_req_t                     cwdi_interrupt_w_req; 
cwdi_interrupt_w_req_t                     cwdi_interrupt_w_req_nxt , cwdi_interrupt_w_req_f ;
logic                                      cwdi_interrupt_w_req_valid_nxt , cwdi_interrupt_w_req_valid_f ;
logic                                      cwdi_interrupt_w_req_ready_f ;
logic [6:0]                                wd_irq_winner_cq;

logic                                      dir_wd_irq_update;
logic [HQM_NUM_DIR_CQ_B2-1:0]              dir_wd_irq_winner;
logic                                      ldb_wd_irq_update;
logic [HQM_NUM_LDB_CQ_B2-1:0]              ldb_wd_irq_winner;

logic                                      wd_irq_update;
logic                                      ldb_wd_irq_winner_v;
logic                                      dir_wd_irq_winner_v;

logic                                      wd_irq_winner_v;
logic                                      wd_irq_winner;

logic                                      dir_wd_clkreq;
logic                                      ldb_wd_clkreq;
logic                                      ldb_wd_irq_active;
logic                                      dir_wd_irq_active;

logic                                      hqm_chp_tim_pipe_idle_dir_nc;
logic                                      hqm_chp_tim_pipe_idle_ldb_nc;
logic                                      cfg_access_idle_req_unused;
logic                                      hqm_flr_prep_b_sync_pgcb_clk;                                                     
                                                     

hqm_chp_wd # (
   .HQM_CQ_WD_NUM_CQ ( HQM_NUM_DIR_CQ )
 , .HQM_CQ_TIM_WIDTH_INTERVAL ( HQM_CQ_TIM_WIDTH_INTERVAL )
 , .HQM_CQ_TIM_WIDTH_THRESHOLD ( HQM_CQ_TIM_WIDTH_THRESHOLD )
 , .HQM_CQ_TIM_TYPE ( HQM_CQ_TIM_TYPE ) // 0-CIAL , 1-CWDT
) i_hqm_chp_wd_dir (
  .hqm_gated_clk                  (hqm_gated_clk )
, .hqm_gated_rst_n                (hqm_gated_rst_n )

, .hqm_pgcb_clk                   (hqm_pgcb_clk )
, .hqm_pgcb_rst_n                 (hqm_pgcb_rst_n )

, .hqm_pgcb_rst_n_done            (hqm_pgcb_rst_n_done )
, .hw_pgcb_init_done              (dir_hw_pgcb_init_done )

, .enq_excep                      (enq_dir_excep )
, .sch_excep                      (sch_dir_excep )

, .irq                            (dir_wd_irq ) // O

, .irq_update                     (dir_wd_irq_update ) // I
, .irq_cq                         (dir_wd_irq_winner ) // I

, .cfg_wd_disable_reg_f           (dir_cfg_wd_disable_reg_f )
, .cfg_wd_disable_reg_nxt         (dir_cfg_wd_disable_reg_nxt )

, .cfg_wd_en_f                    (hqm_chp_target_cfg_dir_cq_wd_enb_reg_f )
, .cfg_wd_en_nxt                  (hqm_chp_target_cfg_dir_cq_wd_enb_reg_nxt )
, .cfg_wd_load_cg                 (dir_cfg_wd_load_cg_f )

, .func_count_rmw_pipe_mem_we     (func_count_rmw_pipe_wd_dir_mem_we )
, .func_count_rmw_pipe_mem_waddr  (func_count_rmw_pipe_wd_dir_mem_waddr )
, .func_count_rmw_pipe_mem_wdata  (func_count_rmw_pipe_wd_dir_mem_wdata )
, .func_count_rmw_pipe_mem_re     (func_count_rmw_pipe_wd_dir_mem_re )
, .func_count_rmw_pipe_mem_raddr  (func_count_rmw_pipe_wd_dir_mem_raddr )
, .func_count_rmw_pipe_mem_rdata  (func_count_rmw_pipe_wd_dir_mem_rdata )

, .pipe_status                    (hqm_chp_wd_dir_pipe_status_pnc )

, .irq_active                     (dir_wd_irq_active )

, .idle_timer_report_control      (idle_cwdi_timer_report_control ) // 1'b1 - impacts unit idle due to active timer, 1'b0-does not impact unit idle

, .cfg_tim_update_v               (hqm_chp_target_cfg_dir_wd_enb_interval_update_v)
, .cfg_tim                        (hqm_chp_target_cfg_dir_wd_enb_interval_reg_f ) // I logic [HQM_CQ_TIM_WIDTH_INTERVAL:0]        cfg_tim // on bit and interval value

, .cfg_tim_threshold_update_v     (hqm_chp_target_cfg_dir_wd_threshold_update_v)
, .cfg_tim_threshold              (hqm_chp_target_cfg_dir_wd_threshold_reg_f )

, .cfg_access_idle_req            (cfg_access_idle_req_unused) // I cfg request to timer
, .hqm_chp_tim_pipe_idle          (hqm_chp_tim_pipe_idle_dir_nc) // O timer pipe idle
, .hqm_flr_prep_b_sync_pgcb_clk   (hqm_flr_prep_b_sync_pgcb_clk)
, .wd_clkreq                      (dir_wd_clkreq)


, .pf_count_rmw_pipe_mem_re       (pf_count_rmw_pipe_wd_dir_mem_re    )
, .pf_count_rmw_pipe_mem_raddr    (pf_count_rmw_pipe_wd_dir_mem_raddr )
, .pf_count_rmw_pipe_mem_waddr    (pf_count_rmw_pipe_wd_dir_mem_waddr )
, .pf_count_rmw_pipe_mem_wdata    (pf_count_rmw_pipe_wd_dir_mem_wdata )
, .pf_count_rmw_pipe_mem_we       (pf_count_rmw_pipe_wd_dir_mem_we    )
, .pf_count_rmw_pipe_mem_rdata    (pf_count_rmw_pipe_wd_dir_mem_rdata )

, .cq_timer_threshold_parity_err  (cq_timer_threshold_parity_err_dir)

, .sch_excep_parity_check_err     (sch_excep_parity_check_err_dir)

, .hqm_chp_target_cfg_wdrt_status (hqm_chp_target_cfg_dir_wdrt_status)

) ;

hqm_chp_wd # (
   .HQM_CQ_WD_NUM_CQ ( HQM_NUM_LDB_CQ )
 , .HQM_CQ_TIM_WIDTH_INTERVAL ( HQM_CQ_TIM_WIDTH_INTERVAL )
 , .HQM_CQ_TIM_WIDTH_THRESHOLD ( HQM_CQ_TIM_WIDTH_THRESHOLD )
 , .HQM_CQ_TIM_TYPE ( HQM_CQ_TIM_TYPE ) // 0-CIAL , 1-CWDT
) i_hqm_chp_wd_ldb (
  .hqm_gated_clk                  (hqm_gated_clk)
, .hqm_gated_rst_n                (hqm_gated_rst_n)

, .hqm_pgcb_clk                   (hqm_pgcb_clk)
, .hqm_pgcb_rst_n                 (hqm_pgcb_rst_n)

, .hqm_pgcb_rst_n_done            (hqm_pgcb_rst_n_done)
, .hw_pgcb_init_done              (ldb_hw_pgcb_init_done)

, .enq_excep                      (enq_ldb_excep)
, .sch_excep                      (sch_ldb_excep)

, .irq                            (ldb_wd_irq)                                    // O

, .irq_update                     (ldb_wd_irq_update)                             // I
, .irq_cq                         (ldb_wd_irq_winner)                             // I
, .cfg_wd_disable_reg_f           (ldb_cfg_wd_disable_reg_f)
, .cfg_wd_disable_reg_nxt         (ldb_cfg_wd_disable_reg_nxt)

, .cfg_wd_en_f                    (hqm_chp_target_cfg_ldb_cq_wd_enb_reg_f)
, .cfg_wd_en_nxt                  (hqm_chp_target_cfg_ldb_cq_wd_enb_reg_nxt)
, .cfg_wd_load_cg                 (ldb_cfg_wd_load_cg_f)

, .func_count_rmw_pipe_mem_we     (func_count_rmw_pipe_wd_ldb_mem_we)
, .func_count_rmw_pipe_mem_waddr  (func_count_rmw_pipe_wd_ldb_mem_waddr)
, .func_count_rmw_pipe_mem_wdata  (func_count_rmw_pipe_wd_ldb_mem_wdata)
, .func_count_rmw_pipe_mem_re     (func_count_rmw_pipe_wd_ldb_mem_re)
, .func_count_rmw_pipe_mem_raddr  (func_count_rmw_pipe_wd_ldb_mem_raddr)
, .func_count_rmw_pipe_mem_rdata  (func_count_rmw_pipe_wd_ldb_mem_rdata)

, .pipe_status                    (hqm_chp_wd_ldb_pipe_status_pnc)

, .irq_active                     (ldb_wd_irq_active)

, .idle_timer_report_control      (idle_cwdi_timer_report_control)                 // 1'b1 - impacts unit idle due to active timer, 1'b0-does not impact unit idle

, .cfg_tim_update_v               (hqm_chp_target_cfg_ldb_wd_enb_interval_update_v)
, .cfg_tim                        (hqm_chp_target_cfg_ldb_wd_enb_interval_reg_f)

, .cfg_tim_threshold_update_v     (hqm_chp_target_cfg_ldb_wd_threshold_update_v)
, .cfg_tim_threshold              (hqm_chp_target_cfg_ldb_wd_threshold_reg_f )

, .cfg_access_idle_req            (cfg_access_idle_req_unused)                        // I cfg request to timer
, .hqm_chp_tim_pipe_idle          (hqm_chp_tim_pipe_idle_ldb_nc)                      // O timer pipe idle
, .hqm_flr_prep_b_sync_pgcb_clk   (hqm_flr_prep_b_sync_pgcb_clk)
, .wd_clkreq                      (ldb_wd_clkreq)


, .pf_count_rmw_pipe_mem_re       (pf_count_rmw_pipe_wd_ldb_mem_re)
, .pf_count_rmw_pipe_mem_raddr    (pf_count_rmw_pipe_wd_ldb_mem_raddr)
, .pf_count_rmw_pipe_mem_waddr    (pf_count_rmw_pipe_wd_ldb_mem_waddr)
, .pf_count_rmw_pipe_mem_wdata    (pf_count_rmw_pipe_wd_ldb_mem_wdata)
, .pf_count_rmw_pipe_mem_we       (pf_count_rmw_pipe_wd_ldb_mem_we)
, .pf_count_rmw_pipe_mem_rdata    (pf_count_rmw_pipe_wd_ldb_mem_rdata)

, .cq_timer_threshold_parity_err  (cq_timer_threshold_parity_err_ldb)
, .sch_excep_parity_check_err     (sch_excep_parity_check_err_ldb)

, .hqm_chp_target_cfg_wdrt_status (hqm_chp_target_cfg_ldb_wdrt_status)

) ;

logic wd_clkreq_nxt;
logic wd_clkreq_f;

// the cwdi_interrupt is driven when we have 
hqm_AW_rr_arb # (
  .NUM_REQS  ( HQM_NUM_LDB_CQ )
) i_wd_irq_rr_arb_ldb (
  .clk           (hqm_gated_clk)
, .rst_n         (hqm_gated_rst_n)
, .reqs          (ldb_wd_irq)
, .update        (ldb_wd_irq_update)
, .winner_v      (ldb_wd_irq_winner_v)
, .winner        (ldb_wd_irq_winner)
) ;

hqm_AW_rr_arb # (
  .NUM_REQS  ( HQM_NUM_DIR_CQ )
) i_wd_irq_rr_arb_dir (
  .clk           (hqm_gated_clk)
, .rst_n         (hqm_gated_rst_n)
, .reqs          (dir_wd_irq)
, .update        (dir_wd_irq_update)
, .winner_v      (dir_wd_irq_winner_v)
, .winner        (dir_wd_irq_winner)
) ;

hqm_AW_rr_arb # (
  .NUM_REQS  ( 2 )
) i_wd_irq_rr_arb (
  .clk           (hqm_gated_clk)
, .rst_n         (hqm_gated_rst_n)
, .reqs          ({ ldb_wd_irq_winner_v , dir_wd_irq_winner_v })
, .update        (wd_irq_update)
, .winner_v      (wd_irq_winner_v)
, .winner        (wd_irq_winner)
) ;

hqm_AW_tx_sync # (
   .WIDTH  ( $bits (cwdi_interrupt_w_req_f) )
) i_wd_tx_sync (
    .hqm_gated_clk   (hqm_gated_clk)                // I
  , .hqm_gated_rst_n (hqm_gated_rst_n)              // I

  , .status          (wd_tx_sync_status)            // O 7-bits
  , .idle            (wd_tx_sync_idle)              // O
  , .rst_prep        (rst_prep)                     // I

  , .in_ready        (cwdi_interrupt_w_req_ready_f) // O
  , .in_valid        (cwdi_interrupt_w_req_valid_f) // I
  , .in_data         (cwdi_interrupt_w_req_f)       // I

  , .out_ready       (cwdi_interrupt_w_req_ready)   // I
  , .out_valid       (cwdi_interrupt_w_req_valid)   // O
  , .out_data        (cwdi_interrupt_w_req)         // O
) ;

// there is 2 stage arbitration to equally serve ldb and dir  wd interrupts
// 
always_comb begin

   cwdi_interrupt_w_req_nxt = cwdi_interrupt_w_req_f ;
   cwdi_interrupt_w_req_valid_nxt = cwdi_interrupt_w_req_valid_f ;

   // by default assign ldb cq
   wd_irq_winner_cq = {1'b0,ldb_wd_irq_winner} ;

   // if dir cq is winner assign dir cq
   if ( wd_irq_winner_v & ( wd_irq_winner ==1'b0 ) ) begin
        wd_irq_winner_cq = dir_wd_irq_winner ;
   end

       wd_irq_update = 1'b0 ;
   ldb_wd_irq_update = 1'b0 ;
   dir_wd_irq_update = 1'b0 ;

   // when there are wd interrupts to be reported
   // these will be reported at max rate of 1 every other clock. 
   // pull one if valid & ready or ~valid
   if ( wd_irq_winner_v ) begin

      if ( ( (cwdi_interrupt_w_req_valid_f & cwdi_interrupt_w_req_ready_f ) | ~ cwdi_interrupt_w_req_valid_f ) ) begin

         wd_irq_update = 1'b1 ;
         ldb_wd_irq_update = ( wd_irq_winner ==1'b1 ) ;
         dir_wd_irq_update = ( wd_irq_winner ==1'b0 ) ;

         cwdi_interrupt_w_req_valid_nxt = 1'b1 ;
         cwdi_interrupt_w_req_nxt.cq = wd_irq_winner_cq ;
         cwdi_interrupt_w_req_nxt.is_ldb = ( wd_irq_winner ==1'b1 ) ;
      end

   end else begin

      // // if ready set deassert valid since have nothing to report
      if ( cwdi_interrupt_w_req_ready_f ) begin
         cwdi_interrupt_w_req_valid_nxt = 1'b0 ;
      end

   end

end


//flops
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ~ hqm_gated_rst_n ) begin

      cwdi_interrupt_w_req_f <= '0 ;
      cwdi_interrupt_w_req_valid_f <= '0 ;

  end else begin

      cwdi_interrupt_w_req_f <= cwdi_interrupt_w_req_nxt ;
      cwdi_interrupt_w_req_valid_f <= cwdi_interrupt_w_req_valid_nxt ;

  end
end


// sticky registers for keeping track of already reported wd cq interrutps
// these are set when interrupt is reported and can be cleared on write of 1 to bit position
//
assign dir_wdto_v = cwdi_interrupt_w_req_valid & cwdi_interrupt_w_req_ready & ( cwdi_interrupt_w_req.is_ldb ==1'b0 ) ;
assign ldb_wdto_v = cwdi_interrupt_w_req_valid & cwdi_interrupt_w_req_ready & ( cwdi_interrupt_w_req.is_ldb ==1'b1 ) ;

generate 
if (HQM_NUM_DIR_CQ==96) begin : scaled_dir_cq_96

logic [(128-HQM_NUM_DIR_CQ)-1:0]                 dir_wdto_nxt_nc;

hqm_AW_bindec # (
  .WIDTH ( 7 )
) i_dir_wdto (
    .a      (cwdi_interrupt_w_req.cq [ 6 : 0 ])
  , .enable (dir_wdto_v)

  , .dec    ({dir_wdto_nxt_nc,dir_wdto_nxt})
) ;

end else begin : scaled_dir_cq_64_32

hqm_AW_bindec # (
  .WIDTH ( HQM_NUM_DIR_CQ_B2 )
) i_dir_wdto (
    .a      (cwdi_interrupt_w_req.cq [ HQM_NUM_DIR_CQ_B2 - 1 : 0 ])
  , .enable (dir_wdto_v)

  , .dec    (dir_wdto_nxt)
) ;

end
endgenerate

hqm_AW_bindec # (
  .WIDTH ( HQM_NUM_LDB_CQ_B2 )
) i_ldb_wdto (
    .a        (cwdi_interrupt_w_req.cq [ HQM_NUM_LDB_CQ_B2 - 1 : 0 ])
   , .enable   (ldb_wdto_v)

   , .dec      (ldb_wdto_nxt)
) ;

assign wd_irq_idle = ~ ( cwdi_interrupt_w_req_valid_f | wd_irq_winner_v | dir_wd_irq_active | ldb_wd_irq_active ) ;

always_comb begin wd_clkreq_nxt = dir_wd_clkreq | ldb_wd_clkreq; end

always_ff @(posedge hqm_pgcb_clk or negedge hqm_pgcb_rst_n) begin
  if (~hqm_pgcb_rst_n) begin
      wd_clkreq_f <= 1'b0;
  end else begin
      wd_clkreq_f <= wd_clkreq_nxt;
  end
end

assign wd_clkreq = wd_clkreq_f; 
assign cfg_access_idle_req_unused = 1'b0;

hqm_AW_sync_rst1 i_hqm_flr_prep_sync (.clk (hqm_pgcb_clk) ,.rst_n (hqm_pgcb_rst_n) ,.data (hqm_flr_prep)  ,.data_sync (hqm_flr_prep_b_sync_pgcb_clk));

endmodule // hqm_chp_wd_wrap
