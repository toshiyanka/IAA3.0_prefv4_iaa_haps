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
// hqm_chp_wd (credit_hist_pipe witchdog module)
//
// hqm_chp_wd module managed watchdog timer interrups
// 
// When wd timer is enabled the time behaviro is the following:
//
//  - per[cq] timer runs while cq is not empty
//  - per[cq] timer is reset to '0 but timer continues to count for al hcw enqueues
//  - per[cq] timer is reset to '0 and counting stops if an hcq enqu (token return) empties the cq
//  - per[c1] timer stops when pre-defined global threshold is crossed. The cq timer will not count 
//    (or generate any more interrupt requests) until reset by CFG
//
//-----------------------------------------------------------------------------------------------------

// 
module hqm_chp_wd
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
  parameter HQM_CQ_WD_NUM_CQ = 128
 ,parameter HQM_CQ_TIM_WIDTH_INTERVAL = 8
 ,parameter HQM_CQ_TIM_WIDTH_THRESHOLD = 14
 ,parameter HQM_CQ_TIM_TYPE = 0
 ,parameter HQM_CQ_WD_NUM_CQ_B2 = (AW_logb2 ( HQM_CQ_WD_NUM_CQ -1 ) + 1)

) (
  input  logic                                      hqm_gated_clk
, input  logic                                      hqm_gated_rst_n

, input  logic                                      hqm_pgcb_clk
, input  logic                                      hqm_pgcb_rst_n

, input  logic                                      hqm_pgcb_rst_n_done
, output logic                                      hw_pgcb_init_done
                                                     
, input  cq_int_info_t                              enq_excep
, input  cq_int_info_t                              sch_excep

, output logic [HQM_CQ_WD_NUM_CQ-1:0]               irq
                                      
, input  logic                                      irq_update
, input  logic [HQM_CQ_WD_NUM_CQ_B2-1:0]            irq_cq
                                                    
, input  logic [HQM_CQ_WD_NUM_CQ-1:0]               cfg_wd_disable_reg_f
, output logic [HQM_CQ_WD_NUM_CQ-1:0]               cfg_wd_disable_reg_nxt

, input  logic [HQM_CQ_WD_NUM_CQ-1:0]               cfg_wd_en_f
, output logic [HQM_CQ_WD_NUM_CQ-1:0]               cfg_wd_en_nxt
, input  logic                                      cfg_wd_load_cg

, output logic                                      func_count_rmw_pipe_mem_we
, output logic [HQM_CQ_WD_NUM_CQ_B2-1:0]            func_count_rmw_pipe_mem_waddr
, output logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] func_count_rmw_pipe_mem_wdata
, output logic                                      func_count_rmw_pipe_mem_re
, output logic [HQM_CQ_WD_NUM_CQ_B2-1:0]            func_count_rmw_pipe_mem_raddr
, input  logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] func_count_rmw_pipe_mem_rdata

, output  logic [31:0]                              pipe_status 

, output logic                                      irq_active

, input  logic                                      idle_timer_report_control

, input  logic                                      cfg_tim_update_v
, input  logic [31:0]                               cfg_tim // on bit and interval value
, input  logic                                      cfg_tim_threshold_update_v
, input  logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]     cfg_tim_threshold 

, input  logic                                      cfg_access_idle_req  // cfg request to timer
, output logic                                      hqm_chp_tim_pipe_idle // timer pipe idle

, input  logic                                      hqm_flr_prep_b_sync_pgcb_clk
, output logic                                      wd_clkreq


, output logic                                      pf_count_rmw_pipe_mem_re
, output logic [HQM_CQ_WD_NUM_CQ_B2-1:0]            pf_count_rmw_pipe_mem_raddr
, output logic [HQM_CQ_WD_NUM_CQ_B2-1:0]            pf_count_rmw_pipe_mem_waddr
, output logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] pf_count_rmw_pipe_mem_wdata
, output logic                                      pf_count_rmw_pipe_mem_we
, input  logic [(HQM_CQ_TIM_WIDTH_THRESHOLD+2)-1:0] pf_count_rmw_pipe_mem_rdata

, output logic                                      cq_timer_threshold_parity_err
, output logic                                      sch_excep_parity_check_err

, output logic [HQM_CQ_WD_NUM_CQ-1:0]               hqm_chp_target_cfg_wdrt_status

);

// cq interrupt related busses
logic [HQM_CQ_WD_NUM_CQ-1:0]                 run_timer_nxt;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 run_timer_f;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 wd_run;

logic [HQM_CQ_WD_NUM_CQ-1:0]                 clr_nxt;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 clr_f;

logic [HQM_CQ_WD_NUM_CQ-1:0]                 wd_clr;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 wd_clr_ack;

logic                                        enq_depth_gt_zero; 
logic                                        enq_depth_eq_zero; 
logic                                        sch_depth_gt_zero; 
logic                                        sch_depth_eq_zero; 
                                   
logic [HQM_CQ_WD_NUM_CQ-1:0]                 depth_gt_zero_dec;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 depth_eq_zero_dec;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 enq_depth_gt_zero_dec;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 enq_depth_eq_zero_dec;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 sch_depth_gt_zero_dec;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 sch_depth_eq_zero_dec;

logic [HQM_CQ_WD_NUM_CQ-1:0]                 irq_update_dec; // used to indicate which irq got pulled from irq vector 
logic [HQM_CQ_WD_NUM_CQ-1:0]                 clear_irq;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 irq_nxt;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 irq_f;

logic [HQM_CQ_WD_NUM_CQ-1:0]                 expiry;       // dec bit vector of expired timers
logic                                        expiry_v;

logic [HQM_CQ_WD_NUM_CQ-1:0]                 wd_en;
logic                                        load_cg; 
logic                                        sch_excep_v; 
logic                                        enq_excep_v; 
logic                                        wd_clkreq_cfg_control_nxt;
logic                                        wd_clkreq_cfg_control_f;
logic                                        wd_clkreq_cfg_control_sync;
logic                                        wd_clkreq_tim_wrap;

logic [HQM_CQ_WD_NUM_CQ-1:0]                 wd_en_f;
logic [HQM_CQ_WD_NUM_CQ-1:0]                 wd_en_nxt;
logic                                        sch_excep_parity_check_err_pre;
logic                                        sch_excep_parity_check_err_f;
logic [31:0]                                 pipe_status_local;

// The wd rtl processes events on the below 4 interfaces
//    - enq_excep        (cq_dep)
//    - sch_excep	 (cq_dep)
// 
// Event processing by interface:
//    - enq_excep.TOK event can set run bit (cq_dep>0) and/or clear_timer (cq_dep>0), all other events on enq_excep are ignored
//    - sch_excep all events can set run bit (cq_dep>0) and/or clear_timer (cq_dep>0)

assign enq_excep_v = enq_excep.hcw_v & ( (enq_excep.cmd==HQM_CMD_BAT_TOK_RET) |
                                         (enq_excep.cmd==HQM_CMD_COMP_TOK_RET) |
                                         (enq_excep.cmd==HQM_CMD_ENQ_NEW_TOK_RET) |
                                         (enq_excep.cmd==HQM_CMD_ENQ_COMP_TOK_RET) |
                                         (enq_excep.cmd==HQM_CMD_ENQ_FRAG_TOK_RET) );

// set to 1 only when valid hcw_v and cq_dw_en is set for this cq
assign enq_depth_gt_zero   = enq_excep_v && (|enq_excep.depth) && cfg_wd_en_f[enq_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]]; 
assign enq_depth_eq_zero   = enq_excep_v && !enq_depth_gt_zero && cfg_wd_en_f[enq_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]]; 

// sch
assign sch_excep_v = sch_excep.hcw_v & (sch_excep.cmd == HQM_CMD_NOOP);
assign sch_depth_gt_zero   = sch_excep_v && (|sch_excep.depth) && cfg_wd_en_f[sch_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]]; 
assign sch_depth_eq_zero   = sch_excep_v && !sch_depth_gt_zero && cfg_wd_en_f[sch_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]]; 


generate 
if (HQM_CQ_WD_NUM_CQ>64) begin : scaled_cq_gt_64

   logic [(128-HQM_CQ_WD_NUM_CQ)-1:0]           irq_update_dec_nc;
   logic [(128-HQM_CQ_WD_NUM_CQ)-1:0]           enq_depth_gt_zero_dec_nc;
   logic [(128-HQM_CQ_WD_NUM_CQ)-1:0]           enq_depth_eq_zero_dec_nc;
   logic [(128-HQM_CQ_WD_NUM_CQ)-1:0]           sch_depth_gt_zero_dec_nc;
   logic [(128-HQM_CQ_WD_NUM_CQ)-1:0]           sch_depth_eq_zero_dec_nc;


hqm_AW_bindec #( .WIDTH ( HQM_CQ_WD_NUM_CQ_B2 ) ) i_irq_update_dec                    (.a (irq_cq                                          ) ,.enable (irq_update                    ) ,.dec ({irq_update_dec_nc,irq_update_dec}        ));
// enq                                                                                                                                                                                  
hqm_AW_bindec #( .WIDTH ( HQM_CQ_WD_NUM_CQ_B2 ) ) i_enq_depth_gt_zero_dec             (.a (enq_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]           ) ,.enable (enq_depth_gt_zero             ) ,.dec ({enq_depth_gt_zero_dec_nc,enq_depth_gt_zero_dec} ));
hqm_AW_bindec #( .WIDTH ( HQM_CQ_WD_NUM_CQ_B2 ) ) i_enq_depth_eq_zero_dec             (.a (enq_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]           ) ,.enable (enq_depth_eq_zero             ) ,.dec ({enq_depth_eq_zero_dec_nc,enq_depth_eq_zero_dec} ));
// sch                                                                                                                                                                                  
hqm_AW_bindec #( .WIDTH ( HQM_CQ_WD_NUM_CQ_B2 ) ) i_sch_depth_gt_zero_dec             (.a (sch_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]           ) ,.enable (sch_depth_gt_zero             ) ,.dec ({sch_depth_gt_zero_dec_nc,sch_depth_gt_zero_dec} ));
hqm_AW_bindec #( .WIDTH ( HQM_CQ_WD_NUM_CQ_B2 ) ) i_sch_depth_eq_zero_dec             (.a (sch_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]           ) ,.enable (sch_depth_eq_zero             ) ,.dec ({sch_depth_eq_zero_dec_nc,sch_depth_eq_zero_dec} ));

end else begin : scaled_cq_le_64
// 
hqm_AW_bindec #( .WIDTH ( HQM_CQ_WD_NUM_CQ_B2 ) ) i_irq_update_dec                    (.a (irq_cq                                          ) ,.enable (irq_update                    ) ,.dec (irq_update_dec        ));
// enq                                                                                                                                                                                  
hqm_AW_bindec #( .WIDTH ( HQM_CQ_WD_NUM_CQ_B2 ) ) i_enq_depth_gt_zero_dec             (.a (enq_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]           ) ,.enable (enq_depth_gt_zero             ) ,.dec (enq_depth_gt_zero_dec ));
hqm_AW_bindec #( .WIDTH ( HQM_CQ_WD_NUM_CQ_B2 ) ) i_enq_depth_eq_zero_dec             (.a (enq_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]           ) ,.enable (enq_depth_eq_zero             ) ,.dec (enq_depth_eq_zero_dec ));
// sch                                                                                                                                                                                  
hqm_AW_bindec #( .WIDTH ( HQM_CQ_WD_NUM_CQ_B2 ) ) i_sch_depth_gt_zero_dec             (.a (sch_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]           ) ,.enable (sch_depth_gt_zero             ) ,.dec (sch_depth_gt_zero_dec ));
hqm_AW_bindec #( .WIDTH ( HQM_CQ_WD_NUM_CQ_B2 ) ) i_sch_depth_eq_zero_dec             (.a (sch_excep.cq[HQM_CQ_WD_NUM_CQ_B2-1:0]           ) ,.enable (sch_depth_eq_zero             ) ,.dec (sch_depth_eq_zero_dec ));
end
endgenerate


assign clear_irq = ~irq_update_dec;

// update related to clock power gating
assign load_cg = ( irq_update | 
                     expiry_v | 
            enq_depth_gt_zero |
            sch_depth_gt_zero |
            enq_depth_eq_zero |
            sch_depth_eq_zero |
                (|wd_clr_ack) |
               cfg_wd_load_cg 
                 ); 

always_comb begin

     depth_gt_zero_dec = ( enq_depth_gt_zero_dec | sch_depth_gt_zero_dec );
     depth_eq_zero_dec = ( enq_depth_eq_zero_dec | sch_depth_eq_zero_dec ) & ~(depth_gt_zero_dec); // the & is here to prevent clearing of run_bit when enq_except(cq_dep==) and sch_excep(cq_dep>)

end

// update related to clock power gating
always_comb begin 

      irq_nxt = irq_f; 
      run_timer_nxt = run_timer_f;
      clr_nxt = clr_f; 

  if ( load_cg ) begin
      // irq_nxt 
      // 
      // mark irq_nxt bit for each cq expiry
      // clear if irq_f is selected 
      // 
      irq_nxt = (irq_f | expiry ) & clear_irq;
     
      // run_timer
      //
      // set when depth > zero and reset when depth == 0
      // clear run_timer[cq] if not enabled or we get expiry
      run_timer_nxt = (((run_timer_f | depth_gt_zero_dec) & ~expiry) & cfg_wd_en_f) & ~depth_eq_zero_dec ;

      // clr
      // 
      // clear counter each time we get hcw and cq depth is non-zero
      // reset clear when counter is cleared
      // cfg_tim on bit added to prevent clr_nxt from getting set if wd timer is no enabled. With wd timer off the clr_nxt getting set will prevent
      // local clock gating in chp
      clr_nxt = ((clr_f & ~wd_clr_ack) | depth_gt_zero_dec ) & {(HQM_CQ_WD_NUM_CQ){cfg_tim[HQM_CQ_TIM_WIDTH_INTERVAL]}};
  end

end

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
   if (~hqm_gated_rst_n) begin

       irq_f <= '0;
       run_timer_f <= '0;
       clr_f <= '0;
       wd_en_f <= '0; 
       wd_clkreq_cfg_control_f <= '0;

       sch_excep_parity_check_err_f <= '0;
       
   end else begin

       irq_f <= irq_nxt;
       run_timer_f <= run_timer_nxt;
       clr_f <= clr_nxt;
       wd_en_f <= wd_en_nxt; 
       wd_clkreq_cfg_control_f <= wd_clkreq_cfg_control_nxt;

       sch_excep_parity_check_err_f <= sch_excep_parity_check_err_pre; 

   end  
end

assign irq = irq_f;
assign irq_active = (|(irq_f | expiry )) | enq_depth_gt_zero | enq_depth_eq_zero;
assign wd_en_nxt = cfg_wd_en_f & (~cfg_wd_disable_reg_f); // timer enabled when cfg_wd_en_f[cq] enabled and not disabled by wd expiry[cq] event.
assign wd_en = wd_en_f; 
assign wd_run = run_timer_f;
assign wd_clr = clr_f;

//-----------------------------------------------------------------------------------------------------
logic                                      func_threshold_r_pipe_mem_we_nc;
logic                                      func_threshold_r_pipe_mem_re_nc;
logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]     func_threshold_r_pipe_mem_wdata_nc;
logic [HQM_CQ_WD_NUM_CQ_B2-1:0]            func_threshold_r_pipe_mem_addr_nc;
logic [HQM_CQ_TIM_WIDTH_THRESHOLD-1:0]     func_threshold_r_pipe_mem_rdata;
assign func_threshold_r_pipe_mem_rdata = '0;
                                                    
hqm_chp_tim_wrap #(
    .HQM_NUM_TIM_CQ             (HQM_CQ_WD_NUM_CQ )
   ,.HQM_CQ_TIM_WIDTH_INTERVAL  (HQM_CQ_TIM_WIDTH_INTERVAL )
   ,.HQM_CQ_TIM_WIDTH_THRESHOLD (HQM_CQ_TIM_WIDTH_THRESHOLD )
   ,.HQM_CQ_TIM_TYPE            (HQM_CQ_TIM_TYPE )

) i_chp_wd_tim_wrap (
    .hqm_pgcb_clk                       (hqm_pgcb_clk)
  , .hqm_pgcb_rst_n                     (hqm_pgcb_rst_n)

  , .hqm_gated_clk                      (hqm_gated_clk)
  , .hqm_gated_rst_n                    (hqm_gated_rst_n)

  , .hqm_pgcb_rst_n_done                (hqm_pgcb_rst_n_done)
                                        
  , .enb                                (wd_en)                              // I CQ
  , .run                                (wd_run)                             // I CQ
                                        
  , .clr                                (wd_clr)                             // I CQ
                                        
  , .expiry                             (expiry)                             // O CQ
  , .expiry_v                           (expiry_v)                           // O
  , .ack                                (wd_clr_ack)                         // O CQ
                                        
  , .func_count_rmw_pipe_mem_we         (func_count_rmw_pipe_mem_we)
  , .func_count_rmw_pipe_mem_waddr      (func_count_rmw_pipe_mem_waddr)
  , .func_count_rmw_pipe_mem_wdata      (func_count_rmw_pipe_mem_wdata)
  , .func_count_rmw_pipe_mem_re         (func_count_rmw_pipe_mem_re)
  , .func_count_rmw_pipe_mem_raddr      (func_count_rmw_pipe_mem_raddr)
  , .func_count_rmw_pipe_mem_rdata      (func_count_rmw_pipe_mem_rdata)
                                      
  , .func_threshold_r_pipe_mem_we       (func_threshold_r_pipe_mem_we_nc)
  , .func_threshold_r_pipe_mem_re       (func_threshold_r_pipe_mem_re_nc)
  , .func_threshold_r_pipe_mem_wdata    (func_threshold_r_pipe_mem_wdata_nc)
  , .func_threshold_r_pipe_mem_addr     (func_threshold_r_pipe_mem_addr_nc)
  , .func_threshold_r_pipe_mem_rdata    (func_threshold_r_pipe_mem_rdata)

  , .pipe_status                        (pipe_status_local)

  , .cfg_tim_update_v                   (cfg_tim_update_v)
  , .cfg_tim                            (cfg_tim)                            // I this field includes on bit and interval
  , .cfg_tim_threshold_update_v         (cfg_tim_threshold_update_v)
  , .cfg_tim_threshold                  (cfg_tim_threshold)

  , .cfg_access_idle_req                (cfg_access_idle_req)                // I 
  , .hqm_chp_tim_pipe_idle              (hqm_chp_tim_pipe_idle)              // O


  , .hqm_flr_prep_b_sync_pgcb_clk       (hqm_flr_prep_b_sync_pgcb_clk)
  , .wd_clkreq                          (wd_clkreq_tim_wrap)

  , .hw_pgcb_init_done                  (hw_pgcb_init_done)
  , .pf_count_rmw_pipe_mem_re           (pf_count_rmw_pipe_mem_re)
  , .pf_count_rmw_pipe_mem_raddr        (pf_count_rmw_pipe_mem_raddr)
  , .pf_count_rmw_pipe_mem_waddr        (pf_count_rmw_pipe_mem_waddr)
  , .pf_count_rmw_pipe_mem_wdata        (pf_count_rmw_pipe_mem_wdata)
  , .pf_count_rmw_pipe_mem_we           (pf_count_rmw_pipe_mem_we)
  , .pf_count_rmw_pipe_mem_rdata        (pf_count_rmw_pipe_mem_rdata)

  , .cq_timer_threshold_parity_err      (cq_timer_threshold_parity_err)

);

// cfg
// When there is valid cfg access to timer_count and timer_threshold ram the SM will host its state
// and the cfg requests will be processed when the *timer_pipe* is idle
//


always_comb begin

    cfg_wd_disable_reg_nxt = cfg_wd_disable_reg_f;

    // expiry_v is gating signal
    if (expiry_v) begin
      cfg_wd_disable_reg_nxt = cfg_wd_disable_reg_f | expiry; // sticky wd_diable when we have expiry, clear by writing 1 to cq bit location
    end

end

// this is here to address lint errors since the msb bits of cq might not be used
logic [7:HQM_CQ_WD_NUM_CQ_B2] cq_wd_info_cq_nc;

assign cq_wd_info_cq_nc = enq_excep.cq[7:HQM_CQ_WD_NUM_CQ_B2]; 
assign cfg_wd_en_nxt = cfg_wd_en_f;

// the wd_clkreq needs to take into account the idle_timer_report_control and run_timer_f, where run_timer_f can only be set if cfg_wd_en_f[cq] is set
assign wd_clkreq_cfg_control_nxt = ((|run_timer_f) & idle_timer_report_control);

hqm_AW_sync_rst0 i_wd_clkreq_sync (

   .clk        (hqm_pgcb_clk)
  ,.rst_n      (hqm_pgcb_rst_n)
  ,.data       (wd_clkreq_cfg_control_f)

  ,.data_sync  (wd_clkreq_cfg_control_sync) 

 );

assign wd_clkreq = wd_clkreq_cfg_control_sync | wd_clkreq_tim_wrap;


//https://hsdes.intel.com/appstore/article/#/1407239306
// bit 7 of cq field used to carry parity
hqm_AW_parity_check #(
         .WIDTH ($bits(cq_int_info_t)-1)
) i_sch_excep_parity_check (
         .p( sch_excep.cq[7] )
        ,.d( {
               sch_excep_v
              ,sch_excep.is_ldb
              ,sch_excep.threshold
              ,sch_excep.cq[6:0]
              ,sch_excep.depth
              ,sch_excep.cmd
             } )
        ,.e( sch_excep_v )
        ,.odd( 1'b1 ) // odd
        ,.err( sch_excep_parity_check_err_pre )
);

assign sch_excep_parity_check_err = sch_excep_parity_check_err_f;
assign pipe_status[7:0] = pipe_status_local[7:0];
assign pipe_status[8] = |run_timer_f;
assign pipe_status[9] = |clr_f;
assign pipe_status[10] = |irq_f;
assign pipe_status[11] = 1'b0;
assign pipe_status[31:12] = pipe_status_local[31:12];
assign hqm_chp_target_cfg_wdrt_status = run_timer_f;


endmodule // hqm_chp_wd
// 
