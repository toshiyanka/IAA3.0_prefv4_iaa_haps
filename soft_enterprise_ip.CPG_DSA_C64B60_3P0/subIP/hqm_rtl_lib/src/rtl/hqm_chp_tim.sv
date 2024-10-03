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
// hqm_AW_chp_int_tim
//
// hqm_AW_chp_int_tm  is an interrupt timer module
//
// This module implements tick bsed timer where number of clocks per tick is configurable. The size of the interval
// is parametarized using the HQM_CQ_TIM_WIDTH_INTERVAL parameter.
// In standard interrupt application there is per CQ count threshold for detecting expiry events. In case of watchdog (wd)
// timer there is global cont threshold used for detecting expiry events at which the timer is disabled and needs to be 
// turned back on by SW. In case of wd application the func_threshold_r_pipe_mem_* port are not used.
// 
// cfg controlled regs
//   - timer on bit and interval register
//   - ability to read the count values
//   - ability to read/write the threshold register. Note that wd has 1 threshold and cial timer has threshold per CQ
//
//
//-----------------------------------------------------------------------------------------------------
// 
module hqm_chp_tim
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
  parameter HQM_NUM_TIM_CQ = 128
 ,parameter HQM_CQ_TIM_WIDTH_INTERVAL = 8
 ,parameter HQM_CQ_TIM_WIDTH_THRESHOLD = 14
 ,parameter HQM_CQ_TIM_TYPE = 0 // 0-int timer, 1-wd timer (wd timer has only 1 threshold
 // derived
 ,parameter HQM_NUM_TIM_CQ_B2 = (AW_logb2 ( HQM_NUM_TIM_CQ -1 ) + 1)

) (
    input  logic                                        clk
  , input  logic                                        rst_n
                                           
  , input  logic [HQM_NUM_TIM_CQ-1:0]                   enb
  , input  logic [HQM_NUM_TIM_CQ-1:0]                   run
                                                             
  , input  logic [HQM_NUM_TIM_CQ-1:0]                   clr
                                                             
  , output logic [HQM_NUM_TIM_CQ-1:0]                   expiry
  , output logic                                        expiry_v
  , output logic [HQM_NUM_TIM_CQ-1:0]                   ack
                                           
  , output logic                                        func_count_rmw_pipe_mem_we
  , output logic [HQM_NUM_TIM_CQ_B2-1:0]                func_count_rmw_pipe_mem_waddr
  , output logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0]   func_count_rmw_pipe_mem_wdata
  , output logic                                        func_count_rmw_pipe_mem_re
  , output logic [HQM_NUM_TIM_CQ_B2-1:0]                func_count_rmw_pipe_mem_raddr
  , input  logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0]   func_count_rmw_pipe_mem_rdata

  , output logic                                        func_threshold_r_pipe_mem_we
  , output logic                                        func_threshold_r_pipe_mem_re
  , output logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]       func_threshold_r_pipe_mem_wdata
  , output logic [HQM_NUM_TIM_CQ_B2-1:0]                func_threshold_r_pipe_mem_addr
  , input  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]       func_threshold_r_pipe_mem_rdata
                                           
  , output  logic [31:0]                                pipe_status 
                                                      
  , input   logic [31:0]                                cfg_tim // this field includes on bit and interval
  , input   logic [1+(HQM_CQ_TIM_WIDTH_THRESHOLD-1):0]  cfg_tim_threshold         
                                                      
  , input   logic                                       cfg_access_idle_req
  , output  logic                                       hqm_chp_tim_pipe_idle

  , output  logic                                       cq_timer_threshold_parity_err
);

typedef enum logic [1:0] { 
    IDLE        = 2'b01,
    ACTIVE      = 2'b10,
    XPROP_STATE = 2'bxx
} state_t;

typedef struct packed {
   logic [1:0] residue;
   logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0] cnt;
} count_t;

typedef struct packed {
   logic on;
   logic [HQM_CQ_TIM_WIDTH_INTERVAL-1:0] sample_interval;
} cfg_tim_t;

  logic                                  count_rmw_pipe_status;
                                         
  logic                                  p0_count_rmw_pipe_v_nxt;
  aw_rmwpipe_cmd_t                       p0_count_rmw_pipe_rw_nxt;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p0_count_rmw_pipe_addr_nxt;
  count_t                                p0_count_rmw_pipe_write_data_nxt;
  logic                                  p0_count_rmw_pipe_hold;
  logic                                  p0_count_rmw_pipe_v_f;
  aw_rmwpipe_cmd_t                       p0_count_rmw_pipe_rw_f_nc;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p0_count_rmw_pipe_addr_f_nc;
  count_t                                p0_count_rmw_pipe_data_f_nc;
                                         
  logic                                  p1_count_rmw_pipe_hold;
  logic                                  p1_count_rmw_pipe_v_f;
  aw_rmwpipe_cmd_t                       p1_count_rmw_pipe_rw_f_nc;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p1_count_rmw_pipe_addr_f_nc;
  count_t                                p1_count_rmw_pipe_data_f_nc;
                                         
  logic                                  p2_count_rmw_pipe_hold;
  logic                                  p2_count_rmw_pipe_v_f;
  aw_rmwpipe_cmd_t                       p2_count_rmw_pipe_rw_f;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p2_count_rmw_pipe_addr_f;
  count_t                                p2_count_rmw_pipe_data_f;
  logic                                  p2_count_rmw_pipe_bypsel;
  count_t                                p2_count_rmw_pipe_bypdata;
  logic [1:0]                            p2_count_rmw_pipe_bypdata_adjusted_residue; 
                                         
  logic                                  p3_count_rmw_pipe_hold;
  logic                                  p3_count_rmw_pipe_v_f;
  aw_rmwpipe_cmd_t                       p3_count_rmw_pipe_rw_f_nc;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p3_count_rmw_pipe_addr_f_nc;
  count_t                                p3_count_rmw_pipe_data_f_nc;
                                         
  logic                                  p3_count_rmw_pipe_mem_write;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p3_count_rmw_pipe_mem_write_addr;
  count_t                                p3_count_rmw_pipe_mem_write_data;
  logic                                  p0_count_rmw_pipe_mem_read;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p0_count_rmw_pipe_mem_read_addr;
  count_t                                p1_count_rmw_pipe_mem_read_data;

// --------------------------------------------------
  logic                                  threshold_r_pipe_status;
                                         
  logic                                  p0_threshold_r_pipe_v_nxt;
  aw_rwpipe_cmd_t                        p0_threshold_r_pipe_rw_nxt;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p0_threshold_r_pipe_addr_nxt;
  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0] p0_threshold_r_pipe_write_data_nxt;
                              
  logic                                  p0_threshold_r_pipe_v_f;
  aw_rwpipe_cmd_t                        p0_threshold_r_pipe_rw_f_nc;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p0_threshold_r_pipe_addr_f_nc;
  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0] p0_threshold_r_pipe_data_f_nc;
                              
  logic                                  p1_threshold_r_pipe_v_f;
  aw_rwpipe_cmd_t                        p1_threshold_r_pipe_rw_f_nc;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p1_threshold_r_pipe_addr_f_nc;
  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0] p1_threshold_r_pipe_data_f_nc;
                              
  logic                                  p2_threshold_r_pipe_v_f;
  aw_rwpipe_cmd_t                        p2_threshold_r_pipe_rw_f_nc;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p2_threshold_r_pipe_addr_f_nc;
  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0] p2_threshold_r_pipe_data_f;        // spyglass disable W0531 not used in cial
                              
  logic                                  p3_threshold_r_pipe_v_f;
  aw_rwpipe_cmd_t                        p3_threshold_r_pipe_rw_f_nc;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          p3_threshold_r_pipe_addr_f_nc;
  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0] p3_threshold_r_pipe_data_f_nc;
                              
  logic [HQM_CQ_TIM_WIDTH_INTERVAL-1:0]  interval_nxt; 
  logic [HQM_CQ_TIM_WIDTH_INTERVAL-1:0]  interval_f; 
  logic [HQM_CQ_TIM_WIDTH_INTERVAL-1:0]  interval_f_p1;
  logic [HQM_NUM_TIM_CQ-1:0]             cq_timeout;
  logic                                  cq_timeout_v;
  logic                                  cq_timeout_v_f;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          cq_nxt;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          cq_f_p1;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          cq_f;
  logic [HQM_NUM_TIM_CQ-1:0]             expiry_nxt;
  logic [HQM_NUM_TIM_CQ-1:0]             expiry_f;
  logic                                  expiry_v_nxt;
  logic                                  expiry_v_f;
                             
  cfg_tim_t                              cfg_tim_nxt;
  cfg_tim_t                              cfg_tim_f;
                                         
  state_t                                state_ns;
  state_t                                state_ps;
                                          
  logic  [HQM_NUM_TIM_CQ_B2:0]           num_cqs;
                             
  logic                                  count_rmw_pipe_residue_err;

  logic                                  hqm_chp_tim_pipe_idle_nxt;
  logic                                  hqm_chp_tim_pipe_idle_f;

  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0] cq_timer_threshold;
  logic [HQM_CQ_TIM_WIDTH_THRESHOLD:0]   cnt_threshold_nxt; // spyglass disable W0531 - not used in cial
  logic [HQM_CQ_TIM_WIDTH_THRESHOLD:0]   cnt_threshold_f; // spyglass disable W0531 - not used in cial 
  logic                                  unused_nc; // spyglass disable W0531 - not used in cial

  logic [31:0]                           pipe_status_nxt;
  logic [31:0]                           pipe_status_f;
  logic [HQM_NUM_TIM_CQ_B2-1:0]          wrap_cq;

assign wrap_cq = HQM_NUM_TIM_CQ-1;
assign num_cqs = HQM_NUM_TIM_CQ;
assign p3_count_rmw_pipe_hold = p3_count_rmw_pipe_v_f && 1'b0; 
assign p2_count_rmw_pipe_hold = p2_count_rmw_pipe_v_f && p3_count_rmw_pipe_hold;
assign p1_count_rmw_pipe_hold = p1_count_rmw_pipe_v_f && p2_count_rmw_pipe_hold;
assign p0_count_rmw_pipe_hold = p0_count_rmw_pipe_v_f && p1_count_rmw_pipe_hold;
assign cq_f_p1 = cq_f + {{(HQM_NUM_TIM_CQ_B2-1){1'b0}},1'b1};
assign interval_f_p1 = interval_f + {{(HQM_CQ_TIM_WIDTH_INTERVAL-1){1'b0}},1'b1};

hqm_AW_rmw_mem_4pipe #(
   .DEPTH                             ( HQM_NUM_TIM_CQ )
 , .WIDTH                             ( $bits(count_t) )
) i_count_rmw_pipe (
   .clk                               ( clk )
 , .rst_n                             ( rst_n )
 , .status                            (    count_rmw_pipe_status )
 , .p0_v_nxt                          ( p0_count_rmw_pipe_v_nxt )
 , .p0_rw_nxt                         ( p0_count_rmw_pipe_rw_nxt )
 , .p0_addr_nxt                       ( p0_count_rmw_pipe_addr_nxt )
 , .p0_write_data_nxt                 ( p0_count_rmw_pipe_write_data_nxt )
 , .p0_hold                           ( p0_count_rmw_pipe_hold )
 , .p0_v_f                            ( p0_count_rmw_pipe_v_f )
 , .p0_rw_f                           ( p0_count_rmw_pipe_rw_f_nc )
 , .p0_addr_f                         ( p0_count_rmw_pipe_addr_f_nc )
 , .p0_data_f                         ( p0_count_rmw_pipe_data_f_nc )

 , .p1_hold                           ( p1_count_rmw_pipe_hold )
 , .p1_v_f                            ( p1_count_rmw_pipe_v_f )
 , .p1_rw_f                           ( p1_count_rmw_pipe_rw_f_nc )
 , .p1_addr_f                         ( p1_count_rmw_pipe_addr_f_nc )
 , .p1_data_f                         ( p1_count_rmw_pipe_data_f_nc )

 , .p2_hold                           ( p2_count_rmw_pipe_hold )
 , .p2_v_f                            ( p2_count_rmw_pipe_v_f )
 , .p2_rw_f                           ( p2_count_rmw_pipe_rw_f )
 , .p2_addr_f                         ( p2_count_rmw_pipe_addr_f)
 , .p2_data_f                         ( p2_count_rmw_pipe_data_f )
 , .p3_bypsel_nxt                     ( p2_count_rmw_pipe_bypsel )
 , .p3_bypdata_nxt                    ( p2_count_rmw_pipe_bypdata )

 , .p3_hold                           ( p3_count_rmw_pipe_hold )
 , .p3_v_f                            ( p3_count_rmw_pipe_v_f )
 , .p3_rw_f                           ( p3_count_rmw_pipe_rw_f_nc )
 , .p3_addr_f                         ( p3_count_rmw_pipe_addr_f_nc )
 , .p3_data_f                         ( p3_count_rmw_pipe_data_f_nc )

 , .mem_write                         ( p3_count_rmw_pipe_mem_write )
 , .mem_write_addr                    ( p3_count_rmw_pipe_mem_write_addr )
 , .mem_write_data                    ( p3_count_rmw_pipe_mem_write_data )
 , .mem_read                          ( p0_count_rmw_pipe_mem_read )
 , .mem_read_addr                     ( p0_count_rmw_pipe_mem_read_addr )
 , .mem_read_data                     ( p1_count_rmw_pipe_mem_read_data )
); // i_tpipe

// based on timer type check if threshold rw pipe is needed.
// for wd rw pips is not needed since there is single threshold value

generate 

if (HQM_CQ_TIM_TYPE == 0) begin : interrupt_timer_per_cq_threshold

hqm_AW_rw_mem_4pipe #(
   .DEPTH                             ( HQM_NUM_TIM_CQ )
 , .WIDTH                             ( HQM_CQ_TIM_WIDTH_THRESHOLD )
) i_threshold_r_pipe (
   .clk                               ( clk )
 , .rst_n                             ( rst_n ) 

 , .status                            ( threshold_r_pipe_status )
                                      
 , .p0_v_nxt                          ( p0_threshold_r_pipe_v_nxt ) 
 , .p0_rw_nxt                         ( p0_threshold_r_pipe_rw_nxt )
 , .p0_addr_nxt                       ( p0_threshold_r_pipe_addr_nxt )
 , .p0_write_data_nxt                 ( p0_threshold_r_pipe_write_data_nxt )
                                      
 , .p0_hold                           ( p0_count_rmw_pipe_hold )
                                      
 , .p0_v_f                            ( p0_threshold_r_pipe_v_f ) 
 , .p0_rw_f                           ( p0_threshold_r_pipe_rw_f_nc ) 
 , .p0_addr_f                         ( p0_threshold_r_pipe_addr_f_nc )
 , .p0_data_f                         ( p0_threshold_r_pipe_data_f_nc )
                                      
 , .p1_hold                           ( p1_count_rmw_pipe_hold )
                                      
 , .p1_v_f                            ( p1_threshold_r_pipe_v_f )
 , .p1_rw_f                           ( p1_threshold_r_pipe_rw_f_nc )
 , .p1_addr_f                         ( p1_threshold_r_pipe_addr_f_nc )
 , .p1_data_f                         ( p1_threshold_r_pipe_data_f_nc )
                                      
 , .p2_hold                           ( p2_count_rmw_pipe_hold )
                                      
 , .p2_v_f                            ( p2_threshold_r_pipe_v_f )
 , .p2_rw_f                           ( p2_threshold_r_pipe_rw_f_nc )
 , .p2_addr_f                         ( p2_threshold_r_pipe_addr_f_nc )
 , .p2_data_f                         ( p2_threshold_r_pipe_data_f )
                                      
 , .p3_hold                           ( p3_count_rmw_pipe_hold )
                                      
 , .p3_v_f                            ( p3_threshold_r_pipe_v_f ) // O
 , .p3_rw_f                           ( p3_threshold_r_pipe_rw_f_nc ) // O
 , .p3_addr_f                         ( p3_threshold_r_pipe_addr_f_nc ) // O
 , .p3_data_f                         ( p3_threshold_r_pipe_data_f_nc ) // O
                                      
 , .mem_write                         ( func_threshold_r_pipe_mem_we ) // O
 , .mem_read                          ( func_threshold_r_pipe_mem_re ) // O
 , .mem_addr                          ( func_threshold_r_pipe_mem_addr ) // O
 , .mem_write_data                    ( func_threshold_r_pipe_mem_wdata ) // O
 , .mem_read_data                     ( func_threshold_r_pipe_mem_rdata ) // I

);

hqm_AW_parity_check #(
         .WIDTH (HQM_CQ_TIM_WIDTH_THRESHOLD-1)
) hqm_cq_timer_threshold_parity_check (
         .p( p2_threshold_r_pipe_data_f[0] )
        ,.d( p2_threshold_r_pipe_data_f[HQM_CQ_TIM_WIDTH_THRESHOLD-1:1] )
        ,.e( p2_count_rmw_pipe_v_f )
        ,.odd( 1'b1 ) // odd
        ,.err( cq_timer_threshold_parity_err )
);

    assign cq_timer_threshold = {p2_threshold_r_pipe_data_f[HQM_CQ_TIM_WIDTH_THRESHOLD-1:1],1'b1};

    // unused
    assign cnt_threshold_nxt = '0;
    assign cnt_threshold_f = '0;
    assign unused_nc = '0;

end 
else begin : watchdog_timer_use_global_threshold


hqm_AW_parity_check #(
         .WIDTH (HQM_CQ_TIM_WIDTH_THRESHOLD)
) hqm_cq_timer_threshold_parity_check (
         .p( cnt_threshold_f[HQM_CQ_TIM_WIDTH_THRESHOLD] )
        ,.d( cnt_threshold_f[HQM_CQ_TIM_WIDTH_THRESHOLD-1:0] )
        ,.e( p2_count_rmw_pipe_v_f )
        ,.odd( 1'b1 ) // odd
        ,.err( cq_timer_threshold_parity_err )
);


    assign cq_timer_threshold = cnt_threshold_f[HQM_CQ_TIM_WIDTH_THRESHOLD-1:0];
    assign unused_nc = p0_threshold_r_pipe_v_nxt |  (|p0_threshold_r_pipe_rw_nxt) | (|p0_threshold_r_pipe_addr_nxt) | (|p0_threshold_r_pipe_write_data_nxt) | (|func_threshold_r_pipe_mem_rdata);
    assign func_threshold_r_pipe_mem_we = 1'b0;
    assign func_threshold_r_pipe_mem_wdata = '0;
    assign func_threshold_r_pipe_mem_re = '0;
    assign func_threshold_r_pipe_mem_addr = '0;

  always_comb begin

     cnt_threshold_nxt = cfg_tim_threshold;

     if ( func_threshold_r_pipe_mem_we ) begin
        cnt_threshold_nxt = {1'b0,func_threshold_r_pipe_mem_wdata};
     end

  end  

  always_ff @(posedge clk or negedge rst_n ) begin
    if (~rst_n) begin 
       cnt_threshold_f <= '0;
    end
    else begin
       cnt_threshold_f <= cnt_threshold_nxt;
    end
  end



assign p0_threshold_r_pipe_v_f = '0;
assign p2_threshold_r_pipe_v_f = '0;
assign p3_threshold_r_pipe_v_f = '0;
assign threshold_r_pipe_status = '0;
assign p1_threshold_r_pipe_v_f = '0;

assign p0_threshold_r_pipe_rw_f_nc = HQM_AW_RWPIPE_NOOP;
assign p0_threshold_r_pipe_addr_f_nc = '0;
assign p0_threshold_r_pipe_data_f_nc = '0;
assign p1_threshold_r_pipe_rw_f_nc = HQM_AW_RWPIPE_NOOP;
assign p1_threshold_r_pipe_addr_f_nc = '0;
assign p1_threshold_r_pipe_data_f_nc = '0;
assign p2_threshold_r_pipe_rw_f_nc = HQM_AW_RWPIPE_NOOP;
assign p2_threshold_r_pipe_addr_f_nc = '0;
assign p3_threshold_r_pipe_rw_f_nc = HQM_AW_RWPIPE_NOOP;
assign p3_threshold_r_pipe_addr_f_nc = '0;
assign p3_threshold_r_pipe_data_f_nc = '0;
assign p2_threshold_r_pipe_data_f = '0;

end

endgenerate

always_ff @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin

      state_ps <= IDLE;  
      expiry_f <= '0;
      expiry_v_f <= '0;
      interval_f <= '0;
      cq_f <= '0;
      cfg_tim_f <= '0;
      cq_timeout_v_f <= '0;
      hqm_chp_tim_pipe_idle_f <= '0;

      pipe_status_f <= '0;

   end else begin

      state_ps <= state_ns;  
      expiry_f <= expiry_nxt;
      expiry_v_f <= expiry_v_nxt;
      interval_f <= interval_nxt;
      cq_f <= cq_nxt;
      cfg_tim_f <= cfg_tim_nxt;
      cq_timeout_v_f <= cq_timeout_v;
      hqm_chp_tim_pipe_idle_f <= hqm_chp_tim_pipe_idle_nxt;
      pipe_status_f <= pipe_status_nxt;

   end  
end

always_comb begin: tim_sm 

     interval_nxt = interval_f;
     cq_nxt = cq_f;
     state_ns = state_ps;

     p0_count_rmw_pipe_v_nxt = 1'b0;
     p0_count_rmw_pipe_rw_nxt = HQM_AW_RMWPIPE_NOOP; 
     p0_count_rmw_pipe_addr_nxt = cq_f;
     p0_count_rmw_pipe_write_data_nxt = '0; 

     p0_threshold_r_pipe_v_nxt = 1'b0;
     p0_threshold_r_pipe_rw_nxt = HQM_AW_RWPIPE_NOOP;
     p0_threshold_r_pipe_addr_nxt = cq_f;
     p0_threshold_r_pipe_write_data_nxt = '0;
     ack = '0;

     case(state_ps) 

        IDLE : begin 

                   interval_nxt = '0; // reset interval
                   cq_nxt = '0; // reset cq back to 0
           
                   if (!cfg_access_idle_req) begin
                      if ( cfg_tim_f.on ) begin
                         state_ns = ACTIVE;
                      end else begin
                         state_ns = IDLE;
                      end
                   end

               end 
      ACTIVE : begin

                   if (!cfg_access_idle_req) begin

                       if ( cfg_tim_f.on ) begin // if on cycle through CQs based on interval

                           if ( (interval_f == cfg_tim_f.sample_interval) ) begin
                       
                              interval_nxt = '0; // reset interval

                              cq_nxt = (cq_f==wrap_cq)  ? '0 : cq_f_p1; // advance to next cq
                       
                              if ( run[cq_f] && ~clr[cq_f] && enb[cq_f] ) begin
                              
                                  p0_count_rmw_pipe_v_nxt = 1'b1;
                                  p0_count_rmw_pipe_rw_nxt = HQM_AW_RMWPIPE_RMW;  // check values
                                  p0_count_rmw_pipe_addr_nxt = cq_f;
                                 
                              end else begin
                              
                                  p0_count_rmw_pipe_v_nxt = 1'b1;
                                  p0_count_rmw_pipe_rw_nxt = HQM_AW_RMWPIPE_WRITE; // write 0's 
                                  p0_count_rmw_pipe_addr_nxt = cq_f;
                                  ack[cq_f] = clr[cq_f];
                              
                              end 
                             
                              // issue read for threshold information
                              p0_threshold_r_pipe_v_nxt = 1'b1;
                              p0_threshold_r_pipe_rw_nxt = HQM_AW_RWPIPE_READ;
                              p0_threshold_r_pipe_addr_nxt = cq_f;

                           end else begin
                       
                              interval_nxt = interval_f_p1;
                       
                           end
                       end else begin // if not on to to IDLE

                           state_ns = IDLE; 

                       end
                   end else begin
                     // during cfg access your want to continue incrementing the interval and stop once the 
                     // programmed cfg value has been reached.
                     interval_nxt = (interval_f == cfg_tim_f.sample_interval) ? interval_f : interval_f_p1;
                   end

               end
     default : begin state_ns = XPROP_STATE; end

     endcase

end

// handle generation of cq_timeout and updating the time_count entries
// the RMW types will update the value based on timer_count and timer_threshold compare
// when timer is disabled either via enb[cq] or run[cq] the timer will be cleared
//
always_comb begin

    cq_timeout = '0;
    cq_timeout_v = 1'b0;

    expiry_nxt = expiry_f;
    expiry_v_nxt = expiry_v_f;

    p2_count_rmw_pipe_bypsel = 1'b0;
    p2_count_rmw_pipe_bypdata.cnt = p2_count_rmw_pipe_data_f.cnt;
    p2_count_rmw_pipe_bypdata.residue = p2_count_rmw_pipe_data_f.residue;

    if ( p2_count_rmw_pipe_v_f && ~p2_count_rmw_pipe_hold ) begin 
       if ( p2_count_rmw_pipe_rw_f == HQM_AW_RMWPIPE_RMW ) begin

          p2_count_rmw_pipe_bypsel = 1'b1;

          if ( p2_count_rmw_pipe_data_f.cnt >= cq_timer_threshold ) begin
              p2_count_rmw_pipe_bypdata.cnt = '0;
              p2_count_rmw_pipe_bypdata.residue = '0;
              cq_timeout = {{(HQM_NUM_TIM_CQ-1){1'b0}},1'b1} << p2_count_rmw_pipe_addr_f;
              cq_timeout_v = 1'b1;
          end else begin 
              p2_count_rmw_pipe_bypdata.cnt = p2_count_rmw_pipe_data_f.cnt + {{(HQM_CQ_TIM_WIDTH_THRESHOLD-1){1'b0}},1'd1};
              p2_count_rmw_pipe_bypdata.residue = p2_count_rmw_pipe_bypdata_adjusted_residue;
              cq_timeout = '0;
          end 

       end
    end

    if (cq_timeout_v) begin // added to support clock gating
       expiry_nxt = enb & cq_timeout;
       expiry_v_nxt = 1'b1;
    end else if (cq_timeout_v_f) begin // added to support clock gating
       expiry_nxt = '0;
       expiry_v_nxt = 1'b0;
    end

end


// only hw can write to count memory
assign func_count_rmw_pipe_mem_we = p3_count_rmw_pipe_mem_write;
assign func_count_rmw_pipe_mem_waddr = p3_count_rmw_pipe_mem_write_addr;
assign func_count_rmw_pipe_mem_wdata = p3_count_rmw_pipe_mem_write_data;


// cfg
// When there is valid cfg access to timer_count and timer_threshold ram the SM will host its state
// and the cfg requests will be processed when the *timer_pipe* is idle
//
always_comb begin

    cfg_tim_nxt.on = cfg_tim[HQM_CQ_TIM_WIDTH_INTERVAL];
    cfg_tim_nxt.sample_interval = cfg_tim[HQM_CQ_TIM_WIDTH_INTERVAL-1:0];

    func_count_rmw_pipe_mem_re         = p0_count_rmw_pipe_mem_read;
    func_count_rmw_pipe_mem_raddr    = p0_count_rmw_pipe_mem_read_addr;
    p1_count_rmw_pipe_mem_read_data    = func_count_rmw_pipe_mem_rdata;

end

assign expiry = expiry_f;
assign expiry_v = expiry_v_f;

assign pipe_status_nxt = {

                       {2'b0,state_ps} 

                      ,count_rmw_pipe_residue_err
                      ,1'd0
                      ,threshold_r_pipe_status // 25
                      ,count_rmw_pipe_status
                      ,4'd0
                      ,4'd0
                      ,p0_threshold_r_pipe_v_f
                      ,p1_threshold_r_pipe_v_f
                      ,p2_threshold_r_pipe_v_f
                      ,p3_threshold_r_pipe_v_f
                      ,4'd0 
                      ,p0_count_rmw_pipe_hold
                      ,p1_count_rmw_pipe_hold
                      ,p2_count_rmw_pipe_hold
                      ,p3_count_rmw_pipe_hold 
                      ,p0_count_rmw_pipe_v_f
                      ,p1_count_rmw_pipe_v_f
                      ,p2_count_rmw_pipe_v_f
                      ,p3_count_rmw_pipe_v_f  // 0
                      };

hqm_AW_residue_check #(
     .WIDTH ( $bits(p2_count_rmw_pipe_data_f.cnt) )
) i_count_rmw_pipe_residue_check (
     .r( p2_count_rmw_pipe_data_f.residue )
    ,.d( p2_count_rmw_pipe_data_f.cnt )
    ,.e( p2_count_rmw_pipe_v_f)
    ,.err( count_rmw_pipe_residue_err )
);

// on increment residue is adjusted by adding
// residue of the increment (2'b1) addend to the residue value from memory.
hqm_AW_residue_add
i_count_rmw_piep_residue_add (
     .a   ( p2_count_rmw_pipe_data_f.residue )
    ,.b   ( 2'b1 )
    ,.r   ( p2_count_rmw_pipe_bypdata_adjusted_residue )
);

assign hqm_chp_tim_pipe_idle_nxt = ~(|pipe_status_nxt[25:0]);
assign hqm_chp_tim_pipe_idle = hqm_chp_tim_pipe_idle_f;
assign pipe_status = pipe_status_f;

endmodule // hqm_chp_tim
// 



