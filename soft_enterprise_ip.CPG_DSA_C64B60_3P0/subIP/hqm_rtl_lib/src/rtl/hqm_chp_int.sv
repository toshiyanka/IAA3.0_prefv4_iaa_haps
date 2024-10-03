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
// hqm_chp_int
//
// hqm_chp_int managed threshold interrupts and timer interrupts
// 
//  The cq depth pipe line is in chp and when ever token/sch/hcw[arm] requests are procesed
//  the state is updated and interrupt generated if requred 
//
//  The cfg_[ldb/dir]_intcfg ram contains the threshold, en_depth and en_tim values. To enable the interrupts
//    - 12-bit threshold - threshold value for checking the threshold
//    - en_depth  - interrupt enable. The cq has to be armed in order to generate interrupt
//    - en_tim  - Interrupt timer enable. The cq en_depth needs to be set in order for timers to run
// 
//  With the en_depth[cq]=1 the hw will report interrupt when the depth[cq] > threshold. 
//  With the en_depth[cq]==1 en_tim[cq]=1 the hw will report report interrupt when cq is not empty and timer expires. 
//
//-----------------------------------------------------------------------------------------------------

// 
module hqm_chp_int
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
  parameter HQM_CQ_INT_NUM_CQ = 128
 ,parameter HQM_CQ_INT_NUM_CQ_B2 = (AW_logb2 ( HQM_CQ_INT_NUM_CQ -1 ) + 1)

) (
  input  logic                            clk
, input  logic                            rst_n
                                           
, input  cq_int_info_t                    enq_excep
, input  cq_int_info_t                    sch_excep

, output logic [HQM_CQ_INT_NUM_CQ-1:0]    irq
                                    
, input  logic                            irq_update
, input  logic [HQM_CQ_INT_NUM_CQ_B2-1:0] irq_cq
                                    
, input  logic [HQM_CQ_INT_NUM_CQ-1:0]    expiry // bit vector of expired timers per cq
, input  logic                            expiry_v

, output logic [HQM_CQ_INT_NUM_CQ-1:0]    armed  // this get connected to cfg
, output logic [HQM_CQ_INT_NUM_CQ-1:0]    arm_timer  // this get connected to enb on the hqm_chp_int_tim 
, input  logic [HQM_CQ_INT_NUM_CQ-1:0]    cfg_arm  // set the arm bit via cfg
, input  logic                            cfg_arm_cg
, output logic [HQM_CQ_INT_NUM_CQ-1:0]    run    // this get connected to run on the hqm_chp_int_tim 
                                          
, output logic [HQM_CQ_INT_NUM_CQ-1:0]    urgent // this is status port
, output logic [HQM_CQ_INT_NUM_CQ-1:0]    expired // this is status port
                                          
, input  logic [HQM_CQ_INT_NUM_CQ-1:0]    cfg_int_en_tim
, input  logic [HQM_CQ_INT_NUM_CQ-1:0]    cfg_int_en_depth

, output logic                            irq_active

, output logic                            smon_timer_irq
, output logic                            smon_thresh_irq

, input  logic                            idle_timer_report_control // 1'b1 - impacts unit idle due to active timer, 1'b0-does not impact unit idle
, output logic                            load_cg // external clock gating signal

, output logic [HQM_CQ_INT_NUM_CQ-1:0]    clear_cq_timer
, input  logic [HQM_CQ_INT_NUM_CQ-1:0]    clear_cq_timer_ack

, input  logic                            cfg_cial_clock_gate_control

, input  logic                            cfg_load_cg

, output logic                            sch_excep_parity_check_err

, input  logic                            global_hqm_chp_tim_enable

);

// cq interrupt related busses




logic [HQM_CQ_INT_NUM_CQ-1:0]      armed_nxt;
logic [HQM_CQ_INT_NUM_CQ-1:0]      armed_f;
                                      
logic [HQM_CQ_INT_NUM_CQ-1:0]      urgent_nxt; 
logic [HQM_CQ_INT_NUM_CQ-1:0]      urgent_f; 
                                      
logic [HQM_CQ_INT_NUM_CQ-1:0]      expired_nxt;
logic [HQM_CQ_INT_NUM_CQ-1:0]      expired_f;
                                      
logic [HQM_CQ_INT_NUM_CQ-1:0]      run_timer_nxt;
logic [HQM_CQ_INT_NUM_CQ-1:0]      run_timer_f;


logic                              enq_depth_gt_zero; 
logic                              enq_depth_eq_zero; 
logic                              enq_depth_lteq_thresh;
                                    
logic [HQM_CQ_INT_NUM_CQ-1:0]      enq_depth_gt_zero_dec;
logic [HQM_CQ_INT_NUM_CQ-1:0]      enq_depth_eq_zero_dec;

logic [HQM_CQ_INT_NUM_CQ-1:0]      enq_depth_lteq_thresh_dec;

logic [HQM_CQ_INT_NUM_CQ-1:0]      hcw_cmd_arm_dec;
logic                              hcw_cmd_arm_dec_enable;
logic                              hcw_cmd_arm;

logic [HQM_CQ_INT_NUM_CQ-1:0]      irq_update_dec; // used to indicate which irq got pulled from irq vector 
logic [HQM_CQ_INT_NUM_CQ_B2-1:0]   irq_cq_f;
logic [HQM_CQ_INT_NUM_CQ-1:0]      clear_irq;
logic [HQM_CQ_INT_NUM_CQ-1:0]      clear_run_timer;
logic [HQM_CQ_INT_NUM_CQ-1:0]      irq_nxt;
logic [HQM_CQ_INT_NUM_CQ-1:0]      irq_f;
logic [HQM_CQ_INT_NUM_CQ-1:0]      clear_cq_timer_nxt;
logic [HQM_CQ_INT_NUM_CQ-1:0]      clear_cq_timer_f;


logic                              enq_depth_lteq_thresh_dec_enable;
logic                              enq_depth_gt_zero_dec_enable;
logic                              enq_depth_eq_zero_dec_enable;
logic                              token_return_dec_enable;
logic [HQM_CQ_INT_NUM_CQ-1:0]      token_return_dec;

logic                              smon_timer_irq_nxt;
logic                              smon_timer_irq_f;

logic                              smon_thresh_irq_nxt;
logic                              smon_thresh_irq_f;
logic                              load_cg_nxt;
logic                              hcw_cmd_token;
logic                              rearm_cg_nxt;

logic                              sch_depth_gt_thresh_dec_enable;
logic                              sch_depth_lteq_thresh_dec_enable;
logic                              sch_depth_gt_zero_dec_enable;

logic [HQM_CQ_INT_NUM_CQ-1:0]      sch_depth_gt_thresh_dec;
logic [HQM_CQ_INT_NUM_CQ-1:0]      sch_depth_lteq_thresh_dec;
logic [HQM_CQ_INT_NUM_CQ-1:0]      sch_depth_gt_zero_dec;

logic                              sch_depth_gt_thresh;
logic                              sch_depth_gt_zero;
logic                              sch_depth_lteq_thresh;

logic [HQM_CQ_INT_NUM_CQ-1:0]      depth_lteq_thresh_dec;
logic [HQM_CQ_INT_NUM_CQ-1:0]      depth_gt_thresh_dec;
logic [HQM_CQ_INT_NUM_CQ-1:0]      depth_gt_zero_dec;

logic 				   irq_update_f;

logic                              sch_excep_parity_check_err_pre;
logic                              sch_excep_parity_check_err_f;


assign hcw_cmd_arm = sch_excep.hcw_v & (sch_excep.cmd==HQM_CMD_ARM);
assign hcw_cmd_token = enq_excep.hcw_v & (
                                            (enq_excep.cmd==HQM_CMD_BAT_TOK_RET) |
                                            (enq_excep.cmd==HQM_CMD_COMP_TOK_RET) |
                                            (enq_excep.cmd==HQM_CMD_ENQ_NEW_TOK_RET) |
                                            (enq_excep.cmd==HQM_CMD_ENQ_COMP_TOK_RET) |
                                            (enq_excep.cmd==HQM_CMD_ENQ_FRAG_TOK_RET)
                                          );

assign hcw_cmd_arm_dec_enable = hcw_cmd_arm; 
assign token_return_dec_enable = hcw_cmd_token;

// Use the enable to determine if threshold check is needed and we have valid event, only check TOK, ARM events

assign enq_depth_gt_zero = (|enq_excep.depth) && cfg_int_en_tim[enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0]] && hcw_cmd_token;
assign enq_depth_eq_zero = (enq_excep.depth == '0) && hcw_cmd_token;
assign enq_depth_lteq_thresh = ({1'b0,enq_excep.depth} <= enq_excep.threshold) && cfg_int_en_depth[enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0]] && hcw_cmd_token;


assign enq_depth_lteq_thresh_dec_enable = ( enq_depth_lteq_thresh && cfg_int_en_depth[enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0]] );
assign enq_depth_gt_zero_dec_enable     = ( enq_depth_gt_zero     && cfg_int_en_tim  [enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0]] );
assign enq_depth_eq_zero_dec_enable     = ( enq_depth_eq_zero     && cfg_int_en_tim  [enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0]] );

// sch_excep
// Use the enable to determine if threshild check is needed and we have valid event
assign sch_depth_gt_thresh = ({1'b0,sch_excep.depth} > sch_excep.threshold ) && cfg_int_en_depth[sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0]] && sch_excep.hcw_v && (sch_excep.cmd==HQM_CMD_NOOP);
assign sch_depth_gt_zero = (|sch_excep.depth) && cfg_int_en_tim  [sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0]] && sch_excep.hcw_v && (sch_excep.cmd==HQM_CMD_NOOP);
assign sch_depth_lteq_thresh = (!sch_depth_gt_thresh) && cfg_int_en_depth[sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0]] && sch_excep.hcw_v && (sch_excep.cmd==HQM_CMD_NOOP);

assign sch_depth_gt_thresh_dec_enable   = ( sch_depth_gt_thresh   && cfg_int_en_depth[sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0]] );
assign sch_depth_lteq_thresh_dec_enable = ( sch_depth_lteq_thresh && cfg_int_en_depth[sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0]] );
assign sch_depth_gt_zero_dec_enable     = ( sch_depth_gt_zero     && cfg_int_en_tim  [sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0]] );


generate 
if (HQM_CQ_INT_NUM_CQ>64) begin: scaled_cq_gt_64

logic [(128-HQM_CQ_INT_NUM_CQ)-1:0]      sch_depth_lteq_thresh_dec_nc; // unused
logic [(128-HQM_CQ_INT_NUM_CQ)-1:0]      sch_depth_gt_thresh_dec_nc; // unused
logic [(128-HQM_CQ_INT_NUM_CQ)-1:0]      token_return_dec_nc; // unused
logic [(128-HQM_CQ_INT_NUM_CQ)-1:0]      irq_update_dec_nc; // unused  // unused
logic [(128-HQM_CQ_INT_NUM_CQ)-1:0]      hcw_cmd_arm_dec_nc; // unused
logic [(128-HQM_CQ_INT_NUM_CQ)-1:0]      enq_depth_lteq_thresh_dec_nc; // unused
logic [(128-HQM_CQ_INT_NUM_CQ)-1:0]      enq_depth_eq_zero_dec_nc; // unused
logic [(128-HQM_CQ_INT_NUM_CQ)-1:0]      enq_depth_gt_zero_dec_nc; // unused
logic [(128-HQM_CQ_INT_NUM_CQ)-1:0]      sch_depth_gt_zero_dec_nc; // unused

hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_irq_update_dec            ( .a ( irq_cq_f                               ) ,.enable ( irq_update_f                     ) ,.dec ( {irq_update_dec_nc,irq_update_dec} ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_hcw_cmd_arm_dec           ( .a ( sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( hcw_cmd_arm_dec_enable           ) ,.dec ( {hcw_cmd_arm_dec_nc,hcw_cmd_arm_dec}    ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_token_return_dec          ( .a ( enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( token_return_dec_enable          ) ,.dec ( {token_return_dec_nc,token_return_dec} ) );

// enq related                                                                                                                                                                     

hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_enq_depth_lteq_thresh_dec ( .a ( enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( enq_depth_lteq_thresh_dec_enable ) ,.dec ( {enq_depth_lteq_thresh_dec_nc,enq_depth_lteq_thresh_dec} ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_enq_depth_gt_zero_dec     ( .a ( enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( enq_depth_gt_zero_dec_enable     ) ,.dec ( {enq_depth_gt_zero_dec_nc,enq_depth_gt_zero_dec} ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_enq_depth_eq_zero_dec     ( .a ( enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( enq_depth_eq_zero_dec_enable     ) ,.dec ( {enq_depth_eq_zero_dec_nc,enq_depth_eq_zero_dec} ) );

// New sch_exciep event processing
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_sch_depth_gt_thresh_dec   ( .a ( sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( sch_depth_gt_thresh_dec_enable   ) ,.dec ( {sch_depth_gt_thresh_dec_nc,sch_depth_gt_thresh_dec} ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_sch_depth_lteq_thresh_dec ( .a ( sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( sch_depth_lteq_thresh_dec_enable ) ,.dec ( {sch_depth_lteq_thresh_dec_nc,sch_depth_lteq_thresh_dec} ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_sch_depth_gt_zero_dec     ( .a ( sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( sch_depth_gt_zero_dec_enable     ) ,.dec ( {sch_depth_gt_zero_dec_nc,sch_depth_gt_zero_dec} ) );

end else begin : scaled_cq_le_64

hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_irq_update_dec            ( .a ( irq_cq_f                               ) ,.enable ( irq_update_f                     ) ,.dec ( irq_update_dec ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_hcw_cmd_arm_dec           ( .a ( sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( hcw_cmd_arm_dec_enable           ) ,.dec ( hcw_cmd_arm_dec    ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_token_return_dec          ( .a ( enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( token_return_dec_enable          ) ,.dec ( token_return_dec ) );

// enq related                                                                                                                                                                     

hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_enq_depth_lteq_thresh_dec ( .a ( enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( enq_depth_lteq_thresh_dec_enable ) ,.dec ( enq_depth_lteq_thresh_dec ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_enq_depth_gt_zero_dec     ( .a ( enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( enq_depth_gt_zero_dec_enable     ) ,.dec ( enq_depth_gt_zero_dec ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_enq_depth_eq_zero_dec     ( .a ( enq_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( enq_depth_eq_zero_dec_enable     ) ,.dec ( enq_depth_eq_zero_dec ) );

// New sch_exciep event processing
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_sch_depth_gt_thresh_dec   ( .a ( sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( sch_depth_gt_thresh_dec_enable   ) ,.dec ( sch_depth_gt_thresh_dec ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_sch_depth_lteq_thresh_dec ( .a ( sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( sch_depth_lteq_thresh_dec_enable ) ,.dec ( sch_depth_lteq_thresh_dec ) );
hqm_AW_bindec #( .WIDTH ( HQM_CQ_INT_NUM_CQ_B2 ) ) i_sch_depth_gt_zero_dec     ( .a ( sch_excep.cq[HQM_CQ_INT_NUM_CQ_B2-1:0] ) ,.enable ( sch_depth_gt_zero_dec_enable     ) ,.dec ( sch_depth_gt_zero_dec ) );

end
endgenerate


// combine events on enq/sch interfaces
always_comb begin

    depth_gt_zero_dec = (enq_depth_gt_zero_dec | sch_depth_gt_zero_dec); // keep on running timer if enq or sch dep > 0
    depth_gt_thresh_dec= ( sch_depth_gt_thresh_dec); // set urget if dep>th 
    depth_lteq_thresh_dec = (enq_depth_lteq_thresh_dec | sch_depth_lteq_thresh_dec);
    
end

assign clear_run_timer = ~( enq_depth_eq_zero_dec ); 
assign clear_irq = ~irq_update_dec;

// load_cg_nxt (load clock gate) signal for idle power optimization
assign rearm_cg_nxt = |(armed_f & (urgent_f | expired_f)); // cg enable for case when urgent_f[cq] | expired_f[cq] are set and armed_f[cq] got set

assign load_cg_nxt = (              irq_update_f |       // clear
                                     cfg_load_cg |       // cfg write, clear urgent or run_timer due to enables being cleared.
                                 enq_excep.hcw_v |       // enq 
                                 sch_excep.hcw_v |       // sch
                                        expiry_v |       // expiry
                                      cfg_arm_cg |       // include cfg_arm feature
                            (|clear_cq_timer_ack)|       // clear timer ack
                                    rearm_cg_nxt |       // report irq event due to rearm being set, when urgent_f[cq] or expired_f[cq] are set and armed_f[cq] got set
                     cfg_cial_clock_gate_control         // cfg control of clock gate behavior
                    ); 

always_comb begin 

      irq_nxt              = irq_f; 

      armed_nxt            = armed_f;
      urgent_nxt           = urgent_f; 
      expired_nxt          = expired_f;

      run_timer_nxt        = run_timer_f;
      clear_cq_timer_nxt   = clear_cq_timer_f;
      
  if ( load_cg_nxt ) begin

      // irq_nxt 
      // 
      // mark irq_nxt bit for each entry if it is armed AND expired OR urgent
      // clear if irq_f is selected 
      // 
      irq_nxt = (irq_f | (armed_f & (expired_f | urgent_f))) & clear_irq;
     
      // armed 
      // 
      // clear armed bit if irq is being generated
      // only look at cfg_arm when valid 
      // clear arm if both irq enables are cleared 
      armed_nxt = ~irq_nxt & ( armed_f | hcw_cmd_arm_dec | ({HQM_CQ_INT_NUM_CQ{cfg_arm_cg}} & cfg_arm) ) & (cfg_int_en_tim | cfg_int_en_depth);

      // urgent
      // 
      // clear urgetn when irq is generated
      // update urget bit if enq_excep.depth > threshold and en_depth==1, clear when depth <= threshold
      urgent_nxt = (urgent_f | depth_gt_thresh_dec) & ~depth_lteq_thresh_dec & cfg_int_en_depth; // cfg_int_en_depth used as enable

      // expired
      //
      // clear expired bit if irq is being set 
      // update expired state if there is expiry
      expired_nxt = ~irq_nxt & ( expired_f | expiry ) & clear_run_timer & cfg_int_en_tim; 
    
      // run_timer
      //
      // clear when irq_generated
      // update when depth_gt_0_tim
      // clear on expiry
      // stop timer when depth==0 (clear_run_timer)
      run_timer_nxt = ((~irq_nxt & (run_timer_f | depth_gt_zero_dec)) & clear_run_timer ) & cfg_int_en_tim; // cfg_int_en_tim used as enable

      // handle case of clearing timer on token/clera ack
      // cleared on ack but set on token_return
      // with cq timer disabled via the cfg_int_en_tim_f register the clears are left alone to let the timer 
      // generate the clr_ack to clear the timer
      clear_cq_timer_nxt = ( clear_cq_timer_f & ~clear_cq_timer_ack ) | token_return_dec;
  
  end // if ( load_cg_nxt


end

// smon probe points to identify timer generated/threshold irqs
assign smon_timer_irq_nxt = |(armed_f & expired_f & clear_irq);
assign smon_thresh_irq_nxt = |(armed_f & urgent_f & clear_irq); 

always_ff @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin

       irq_f <= '0;
       armed_f <= '0;
       urgent_f <= '0; 
       expired_f <= '0;
       run_timer_f <= '0;

       smon_timer_irq_f <= '0;
       smon_thresh_irq_f <= '0; 

       clear_cq_timer_f <= '0;

       irq_update_f <= '0;
       irq_cq_f <= '0;
       sch_excep_parity_check_err_f <= '0;

   end else begin

       irq_f <= irq_nxt;
       armed_f <= armed_nxt;
       urgent_f <= urgent_nxt; 
       expired_f <= expired_nxt;
       run_timer_f <= run_timer_nxt;

       smon_timer_irq_f <= smon_timer_irq_nxt; 
       smon_thresh_irq_f <= smon_thresh_irq_nxt; 

       clear_cq_timer_f <= clear_cq_timer_nxt;
       
       irq_update_f <= irq_update;
       irq_cq_f <= irq_cq;
       sch_excep_parity_check_err_f <= sch_excep_parity_check_err_pre;

   end  
end

//https://hsdes.intel.com/appstore/article/#/1407239306
// bit 6 of cq field used to carry parity
hqm_AW_parity_check #(
         .WIDTH ($bits(cq_int_info_t)-1)
) i_sch_excep_parity_check (
         .p( sch_excep.cq[7] )
        ,.d( {
               sch_excep.hcw_v 
              ,sch_excep.is_ldb
              ,sch_excep.threshold
              ,sch_excep.cq[6:0]
              ,sch_excep.depth
              ,sch_excep.cmd
             } )
        ,.e( sch_excep.hcw_v )
        ,.odd( 1'b1 ) // odd
        ,.err( sch_excep_parity_check_err_pre )
);

assign irq = irq_f & (~irq_update_dec);
assign armed = armed_nxt;
assign arm_timer = armed_f;
assign run = run_timer_f;
assign urgent = urgent_f; 
assign expired = expired_f;
assign irq_active = (|(irq_f | (armed_f & (expired_f | urgent_f)))) | (enq_excep.hcw_v==1'b1) | (|expired_nxt) | ((|(run_timer_nxt & armed_f)) & global_hqm_chp_tim_enable & idle_timer_report_control);
assign smon_timer_irq = smon_timer_irq_f; 
assign smon_thresh_irq = smon_thresh_irq_f; 
assign load_cg = load_cg_nxt;
assign clear_cq_timer = clear_cq_timer_f;
assign sch_excep_parity_check_err = sch_excep_parity_check_err_f;

// this is here to address lint errors since the msb bits of cq might not be used
logic [7:HQM_CQ_INT_NUM_CQ_B2] cq_int_info_cq_nc;

assign cq_int_info_cq_nc = enq_excep.cq[7:HQM_CQ_INT_NUM_CQ_B2]; 

endmodule // hqm_AW_chp_int
// 

