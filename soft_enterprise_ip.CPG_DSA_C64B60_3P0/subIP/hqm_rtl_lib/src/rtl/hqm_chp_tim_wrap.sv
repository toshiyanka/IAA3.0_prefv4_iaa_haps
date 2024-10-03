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
// hqm_chp_tim_wrap
//
// this module wraps the hqm_chp_tim instance 
//
//-----------------------------------------------------------------------------------------------------
module hqm_chp_tim_wrap
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
  parameter HQM_NUM_TIM_CQ = 128
 ,parameter HQM_CQ_TIM_WIDTH_INTERVAL = 8
 ,parameter HQM_CQ_TIM_WIDTH_THRESHOLD = 14
 ,parameter HQM_CQ_TIM_TYPE = 0 // 0-int timer, 1-wd timer (wd timer has only 1 threshold
 // derived
 ,parameter HQM_NUM_TIM_CQ_B2 = (AW_logb2 ( HQM_NUM_TIM_CQ -1 ) + 1)

) (
    input  logic                                       hqm_pgcb_clk
  , input  logic                                       hqm_pgcb_rst_n
                                                       
  , input  logic                                       hqm_gated_clk
  , input  logic                                       hqm_gated_rst_n
                                           
  , input  logic [HQM_NUM_TIM_CQ-1:0]                  enb
  , input  logic [HQM_NUM_TIM_CQ-1:0]                  run
                                                              
  , input  logic [HQM_NUM_TIM_CQ-1:0]                  clr
                                                              
  , output logic [HQM_NUM_TIM_CQ-1:0]                  expiry
  , output logic                                       expiry_v
  , output logic [HQM_NUM_TIM_CQ-1:0]                  ack
                                           
  , output logic                                       func_count_rmw_pipe_mem_we
  , output logic [HQM_NUM_TIM_CQ_B2-1:0]               func_count_rmw_pipe_mem_waddr
  , output logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0]  func_count_rmw_pipe_mem_wdata
  , output logic                                       func_count_rmw_pipe_mem_re
  , output logic [HQM_NUM_TIM_CQ_B2-1:0]               func_count_rmw_pipe_mem_raddr
  , input  logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0]  func_count_rmw_pipe_mem_rdata
                                                       
  , output logic                                       func_threshold_r_pipe_mem_we
  , output logic                                       func_threshold_r_pipe_mem_re
  , output logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]      func_threshold_r_pipe_mem_wdata
  , output logic [HQM_NUM_TIM_CQ_B2-1:0]               func_threshold_r_pipe_mem_addr
  , input  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]      func_threshold_r_pipe_mem_rdata
                                                       
  , output  logic [31:0]                               pipe_status 
                                                       
  , input   logic                                      cfg_tim_update_v
  , input   logic [31:0]                               cfg_tim // this field includes on bit and interval
  , input   logic                                      cfg_tim_threshold_update_v
  , input   logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]     cfg_tim_threshold
                                                       
  , input   logic                                      cfg_access_idle_req
  , output  logic                                      hqm_chp_tim_pipe_idle
                                                       

  , input  logic                                       hqm_flr_prep_b_sync_pgcb_clk                                                       
  , output logic                                       wd_clkreq
                                                       
  , input  logic                                       hqm_pgcb_rst_n_done
                                                       
  , output logic                                       hw_pgcb_init_done
                                                       
  , output logic                                       pf_count_rmw_pipe_mem_re 
  , output logic [ HQM_NUM_TIM_CQ_B2-1:0]              pf_count_rmw_pipe_mem_raddr
  , output logic [ HQM_NUM_TIM_CQ_B2-1:0]              pf_count_rmw_pipe_mem_waddr
  , output logic [ (HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] pf_count_rmw_pipe_mem_wdata
  , output logic                                       pf_count_rmw_pipe_mem_we
  , input  logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0]  pf_count_rmw_pipe_mem_rdata

  , output logic                                       cq_timer_threshold_parity_err

);

logic                                  expiry_v_nc ;

logic [ HQM_NUM_TIM_CQ-1 : 0]          expiry_vec ;
logic [ HQM_NUM_TIM_CQ-1 : 0]          ack_vec ;
logic [ HQM_NUM_TIM_CQ-1 : 0]          enb_sync;
logic [ HQM_NUM_TIM_CQ-1 : 0]          run_sync;
logic [ HQM_NUM_TIM_CQ-1 : 0]          clr_sync;
logic                                  hqm_chp_tim_pipe_idle_async;

// due to clock gating and timers runing in the pgcb domain there is need to accuumlate the expiry events in cases where the destination clock( hqm_gated_clk ) is gated.
// 
logic [31:0]                           cfg_tim_sync;
logic [1+(HQM_CQ_TIM_WIDTH_THRESHOLD-1):0] cfg_tim_threshold_sync; // includes parity bit
logic cq_timer_threshold_parity_err_async;
logic [31:0] pipe_status_async;
logic cfg_tim_threshold_parity;
logic expiry_wd_clkreq;
logic ack_wd_clkreq;

hqm_chp_tim #(
  .HQM_NUM_TIM_CQ             ( HQM_NUM_TIM_CQ ) 
 ,.HQM_CQ_TIM_WIDTH_INTERVAL  ( HQM_CQ_TIM_WIDTH_INTERVAL ) 
 ,.HQM_CQ_TIM_WIDTH_THRESHOLD ( HQM_CQ_TIM_WIDTH_THRESHOLD ) 
 ,.HQM_CQ_TIM_TYPE            ( HQM_CQ_TIM_TYPE ) 
) i_hqm_chp_tim (
    .clk                             (hqm_pgcb_clk)
  , .rst_n                           (hqm_pgcb_rst_n)
                                          
  , .enb                             (enb_sync)
  , .run                             (run_sync)
                                          
  , .clr                             (clr_sync)
                                                  
  , .expiry                          (expiry_vec) // expiry vector
  , .expiry_v                        (expiry_v_nc) // unused
  , .ack                             (ack_vec)
                                          
  , .func_count_rmw_pipe_mem_we      (func_count_rmw_pipe_mem_we)
  , .func_count_rmw_pipe_mem_waddr   (func_count_rmw_pipe_mem_waddr)
  , .func_count_rmw_pipe_mem_wdata   (func_count_rmw_pipe_mem_wdata)
  , .func_count_rmw_pipe_mem_re      (func_count_rmw_pipe_mem_re)
  , .func_count_rmw_pipe_mem_raddr   (func_count_rmw_pipe_mem_raddr)
  , .func_count_rmw_pipe_mem_rdata   (func_count_rmw_pipe_mem_rdata)

  , .func_threshold_r_pipe_mem_we    (func_threshold_r_pipe_mem_we)
  , .func_threshold_r_pipe_mem_re    (func_threshold_r_pipe_mem_re)
  , .func_threshold_r_pipe_mem_wdata (func_threshold_r_pipe_mem_wdata)
  , .func_threshold_r_pipe_mem_addr  (func_threshold_r_pipe_mem_addr)
  , .func_threshold_r_pipe_mem_rdata (func_threshold_r_pipe_mem_rdata)
                                           
  , .pipe_status                     (pipe_status_async)

  , .cfg_tim_threshold               (cfg_tim_threshold_sync)
  , .cfg_tim                         (cfg_tim_sync )

  , .cfg_access_idle_req             (cfg_access_idle_req)
  , .hqm_chp_tim_pipe_idle           (hqm_chp_tim_pipe_idle_async)

  , .cq_timer_threshold_parity_err   (cq_timer_threshold_parity_err_async)
);

hqm_chp_wd_clkreq #(
  .HQM_NUM_TIM_CQ (HQM_NUM_TIM_CQ)
) i_hqm_chp_wd_exp_wake (

    .hqm_pgcb_clk   (hqm_pgcb_clk)
  , .hqm_pgcb_rst_n (hqm_pgcb_rst_n)

  , .hqm_gated_clk  (hqm_gated_clk)
  , .hqm_gated_rst_n(hqm_gated_rst_n)

  , .wd_clkreq     (expiry_wd_clkreq)

  , .expiry         (expiry_vec)

  , .cq_expiry_dest (expiry)
  , .hqm_flr_prep_b_sync_pgcb_clk (hqm_flr_prep_b_sync_pgcb_clk)

);

hqm_chp_wd_clkreq #(
  .HQM_NUM_TIM_CQ (HQM_NUM_TIM_CQ)
) i_hqm_chp_wd_ack_wake (

    .hqm_pgcb_clk   (hqm_pgcb_clk)
  , .hqm_pgcb_rst_n (hqm_pgcb_rst_n)

  , .hqm_gated_clk  (hqm_gated_clk)
  , .hqm_gated_rst_n(hqm_gated_rst_n)

  , .wd_clkreq     (ack_wd_clkreq)

  , .expiry         (ack_vec)

  , .cq_expiry_dest (ack)
  , .hqm_flr_prep_b_sync_pgcb_clk (hqm_flr_prep_b_sync_pgcb_clk)

);


genvar cq_i;

generate
for (cq_i=0; cq_i<HQM_NUM_TIM_CQ; cq_i=cq_i+1) begin : hhh


 hqm_AW_sync_rst0 i_hqm_AW_sync_rst0_enb (

   .clk        (hqm_pgcb_clk)
  ,.rst_n      (hqm_pgcb_rst_n)
  ,.data       (enb[cq_i])

  ,.data_sync  (enb_sync[cq_i])

 );

 hqm_AW_sync_rst0 i_hqm_AW_sync_rst0_run (

   .clk        (hqm_pgcb_clk)
  ,.rst_n      (hqm_pgcb_rst_n)
  ,.data       (run[cq_i])

  ,.data_sync  (run_sync[cq_i])

 );

 hqm_AW_sync_rst0 i_hqm_AW_sync_rst0_clr (

   .clk        (hqm_pgcb_clk)
  ,.rst_n      (hqm_pgcb_rst_n)
  ,.data       (clr[cq_i])

  ,.data_sync  (clr_sync[cq_i])

 );

// hqm_AW_async_pulse i_hqm_AW_async_pulse_ack (
//
//   .clk_src            (hqm_pgcb_clk)
//  ,.rst_src_n          (hqm_pgcb_rst_n)
//  ,.data               (ack_pre[cq_i])
//
//  ,.clk_dst            (hqm_gated_clk)
//  ,.rst_dst_n          (hqm_gated_rst_n)
//  ,.data_sync          (ack[cq_i])
//
// );
end

endgenerate

assign expiry_v = |expiry;

// pf reset logic for logic in hqm_pgcb_clk domain
//
logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] pf_count_rmw_pipe_mem_rdata_nc;
assign pf_count_rmw_pipe_mem_rdata_nc = pf_count_rmw_pipe_mem_rdata;

logic [ (32) -1 : 0 ]  reset_pf_counter_nxt, reset_pf_counter_f ;
logic hw_pgcb_init_done_f, hw_pgcb_init_done_nxt ;
logic reset_pf_active_f , reset_pf_active_nxt ;

always_ff @ ( posedge hqm_pgcb_clk or negedge hqm_pgcb_rst_n ) begin
  if ( ! hqm_pgcb_rst_n ) begin
    reset_pf_counter_f <= '0 ;
    reset_pf_active_f <= 1'b1 ;
    hw_pgcb_init_done_f <= '0 ;
  end
  else begin
    reset_pf_counter_f <= reset_pf_counter_nxt ;
    reset_pf_active_f <= reset_pf_active_nxt ;
    hw_pgcb_init_done_f <= hw_pgcb_init_done_nxt ;
  end
end

// the pf reset function for the wd timer function is going to be handled here
// to keep all logic associated with the hqm_pgcb_clk in one module

always_comb begin

    // reset_active is set on reset.
    // reset_active is cleared when hw_pgcb_init_done_f is set
    
    reset_pf_counter_nxt = reset_pf_counter_f ;
    reset_pf_active_nxt = reset_pf_active_f ;
    hw_pgcb_init_done_nxt = hw_pgcb_init_done_f ;
    
    pf_count_rmw_pipe_mem_re = '0;
    pf_count_rmw_pipe_mem_raddr = '0;
    pf_count_rmw_pipe_mem_waddr = '0; 
    pf_count_rmw_pipe_mem_wdata = '0; 
    pf_count_rmw_pipe_mem_we = '0; 
    //....................................................................................................
    // PF reset
    
    if (hqm_pgcb_rst_n_done &  reset_pf_active_f & ~hw_pgcb_init_done_f ) begin
        reset_pf_counter_nxt                    = reset_pf_counter_f + 32'd1 ;
        if ( reset_pf_counter_f < HQM_NUM_TIM_CQ ) begin

           pf_count_rmw_pipe_mem_waddr = reset_pf_counter_f [ HQM_NUM_TIM_CQ_B2-1:0 ];
           pf_count_rmw_pipe_mem_we = 1'b1; 

        end
        else begin
    
           reset_pf_counter_nxt              = reset_pf_counter_f;
           reset_pf_active_nxt = 1'b0 ;
           hw_pgcb_init_done_nxt                  = 1'b1;
    
        end
    end

end

// sync the hw_pgcb_init_done back to hqm_gated_clock domain
 hqm_AW_sync_rst0 i_hqm_AW_sync_hw_pgcb_init_done (

   .clk        (hqm_gated_clk)
  ,.rst_n      (hqm_gated_rst_n)
  ,.data       (hw_pgcb_init_done_f)

  ,.data_sync  (hw_pgcb_init_done)

 );

// sync the incoming data in src_clk to dst_clk domain 
hqm_AW_async_data #(
    .WIDTH ( 32 )
) i_cfg_tim_sync (
    .src_clk              (hqm_gated_clk)
   ,.src_rst_n            (hqm_gated_rst_n)
   ,.dst_clk              (hqm_pgcb_clk)
   ,.dst_rst_n            (hqm_pgcb_rst_n)

   ,.data_v               (cfg_tim_update_v)
   ,.data                 (cfg_tim)
   ,.data_f               (cfg_tim_sync)

) ;


hqm_AW_parity_gen #(
      .WIDTH(HQM_CQ_TIM_WIDTH_THRESHOLD)
) i_chp_rop_hcw_fifo_parity_gen (
        .d     ( cfg_tim_threshold[HQM_CQ_TIM_WIDTH_THRESHOLD-1:0] )
       ,.odd   ( 1'b1 ) // odd
       ,.p     ( cfg_tim_threshold_parity )
);


// sync the incoming data in src_clk to dst_clk domain 
hqm_AW_async_data #(
    .WIDTH ( HQM_CQ_TIM_WIDTH_THRESHOLD+1 )
   ,.RST_DEFAULT ( {1'b1,{HQM_CQ_TIM_WIDTH_THRESHOLD{1'b0}}}) // reflect the odd parity on reset
) i_cfg_tim_threshold_sync (
    .src_clk              (hqm_gated_clk)
   ,.src_rst_n            (hqm_gated_rst_n)
   ,.dst_clk              (hqm_pgcb_clk)
   ,.dst_rst_n            (hqm_pgcb_rst_n)

   ,.data_v               (cfg_tim_threshold_update_v)
   ,.data                 ({cfg_tim_threshold_parity,cfg_tim_threshold})
   ,.data_f               (cfg_tim_threshold_sync)

) ;

 hqm_AW_sync_rst0 i_hqm_chp_tim_pipe_idle (

   .clk        (hqm_gated_clk)
  ,.rst_n      (hqm_gated_rst_n)
  ,.data       (hqm_chp_tim_pipe_idle_async)

  ,.data_sync  (hqm_chp_tim_pipe_idle)

 );

 hqm_AW_async_pulse i_hqm_AW_async_pulse_cq_timer_threshold_parity_err (

   .clk_src            (hqm_pgcb_clk)
  ,.rst_src_n          (hqm_pgcb_rst_n)
  ,.data               (cq_timer_threshold_parity_err_async)

  ,.clk_dst            (hqm_gated_clk)
  ,.rst_dst_n          (hqm_gated_rst_n)
  ,.data_sync          (cq_timer_threshold_parity_err)

 );

// With exception of 2-bit state all vectors are single bit events. None of these go to interrupt.
//
hqm_AW_sync #(
  .WIDTH     ( ($bits(pipe_status)) )
) i_pipe_status_sync (
  .clk       ( hqm_gated_clk )
 ,.data      ( pipe_status_async )
 ,.data_sync ( pipe_status )
);

assign wd_clkreq = expiry_wd_clkreq | ack_wd_clkreq;

endmodule // hqm_chp_tim_wrap
