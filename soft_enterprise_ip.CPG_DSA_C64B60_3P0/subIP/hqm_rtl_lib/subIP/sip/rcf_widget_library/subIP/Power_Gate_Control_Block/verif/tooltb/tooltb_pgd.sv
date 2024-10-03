//------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2013 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code ("Material") are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------

module tooltb_pgd #(
   parameter DEF_PWRON   = 0,
   parameter NUM_CDC     = 4
)(
   input logic pgcb_clk,
   input logic clock,
   input logic prescc_clock,
   input logic pgcb_tck,
   
   input logic pgcb_rst_b,
   input logic reset_b,
   input logic pok_reset_b,
   input logic fdfx_powergood_rst_b,
   output logic [NUM_CDC-1:0] reset_sync_b,
   
   // ASYNC
   input logic [NUM_CDC-1:0] gclock_req_async,
   input logic cfg_clkgate_disabled,
   input logic cfg_clkreq_ctl_disabled,
   input logic [3:0] cfg_clkgate_holdoff,
   input logic [3:0] cfg_pwrgate_holdoff,
   input logic [3:0] cfg_clkreq_off_holdoff,
   input logic [3:0] cfg_clkreq_syncoff_holdoff,
   input logic pmc_ip_wake,
   input logic pwrgate_disabled,
   input logic pmc_pgcb_pg_ack_b,
   input logic pmc_pgcb_restore_b,
   input logic pmc_pgcb_fet_en_b,
   input logic pgcb_clkack,
   
   output logic pgcb_ip_fet_en_b,
   output logic pgcb_clkreq,
   
   // CDC_CLK
   input logic gclock_req_sync,
   input logic [2:0] ism_fabric,
   input logic [2:0] ism_agent,

   output logic [NUM_CDC-1:0] clkreq,
   output logic [NUM_CDC-1:0] pok,
   output logic [NUM_CDC-1:0] gclock_enable_final,
   output logic [NUM_CDC-1:0] gclock,
   output logic [NUM_CDC-1:0] greset_b,
   output logic [NUM_CDC-1:0] gclock_active,
   output logic [NUM_CDC-1:0] ism_locked,
   output logic [NUM_CDC-1:0] boundary_locked,
   output logic [NUM_CDC-1:0] gclock_ack_async,
   

   // PGCB_CLK
   input logic [NUM_CDC-1:0] clkack,
   input logic pwrgate_force,
   input logic [1:0] ip_pgcb_pg_type,
   input logic ip_pgcb_all_pg_rst_up,
   input logic ip_pgcb_frc_clk_srst_cc_en,
   input logic ip_pgcb_frc_clk_cp_en,
   input logic ip_pgcb_force_clks_on_ack,
   input logic ip_pgcb_sleep_en,
   input logic cfg_acc_clkgate_disabled,
   input logic [3:0] cfg_t_clkgate,
   input logic [3:0] cfg_t_clkwake,
   
   output logic pgcb_ip_force_clks_on,
   output logic pgcb_pmc_pg_req_b,
   output logic pgcb_ip_pg_rdy_ack_b,
   output logic pgcb_restore_force_reg_rw,
   output logic pgcb_sleep,
   output logic pgcb_sleep2,
   output logic pgcb_isol_latchen,
   output logic pgcb_isol_en_b,
   
   // ASYNC
   input logic fscan_clkungate,
   input logic fismdfx_force_clkreq,
   input logic fismdfx_clkgate_ovrd,
   input logic fscan_byprst_b,
   input logic fscan_rstbypen,
   input logic fscan_clkgenctrlen,
   input logic fscan_clkgenctrl,
   
   // PGCB_TCK
   input logic fdfx_pgcb_bypass,
   input logic fdfx_pgcb_ovr,
   input logic fscan_ret_ctrl,
   input logic fscan_mode,
   
   output logic [NUM_CDC-1:0][23:0] cdc_visa,
   output logic [23:0] pgcb_visa,
   output logic [31:0] pgcbcg_visa
   
);   
   
   
   logic pwrgate_disabled_sync, pmc_ip_wake_sync;
   logic [NUM_CDC-1:0] pwrgate_ready;
   logic pgcb_rst_sync_b;

   logic pgcb_force_rst_b, pgcb_pok, pgcb_restore, pgcb_pwrgate_active;
   
   logic ip_pgcb_pg_rdy_req_b;
   
   logic pgcb_idle, pgcb_gclk;
   
   pgcb_ctech_doublesync_rstmux i_pgcb_ctech_doublesync_rstmux_pgcb_rst_mux (
      .clk(pgcb_clk), 
      .clr_b(pgcb_rst_b), 
      .rst_bypass_b(fscan_byprst_b),
      .rst_bypass_sel(fscan_rstbypen), 
      .q(pgcb_rst_sync_b)
   );
   
   pgcb_ctech_doublesync i_pgcb_ctech_doublesync_pwrgate_dis (
      .d(pwrgate_disabled), 
      .clr_b(pgcb_rst_sync_b), 
      .clk(pgcb_clk), 
      .q(pwrgate_disabled_sync)
   );
   
   pgcb_ctech_doublesync i_pgcb_ctech_doublesync_pmc_wake (
      .d(pmc_ip_wake), 
      .clr_b(pgcb_rst_sync_b), 
      .clk(pgcb_clk), 
      .q(pmc_ip_wake_sync)
   );

   localparam [NUM_CDC-1:0][31:0] DRIVE_POK      = {1,1,0,1,0,1,0,0};
   localparam [NUM_CDC-1:0][31:0] PRESCC         = {0,0,0,0,1,1,1,1};
   localparam [NUM_CDC-1:0][31:0] FLOP_CG_EN     = {0,1,0,1,0,1,0,1};
   localparam [NUM_CDC-1:0][31:0] DSYNC_CG_EN    = {1,1,0,0,0,0,1,1};
   localparam [NUM_CDC-1:0][31:0] ISM_AGT_IS_NS  = {1,0,1,1,0,0,1,0};
   localparam [NUM_CDC-1:0][31:0] RSTR_B4_FORCE  = {1,1,0,0,1,0,1,1};
   localparam [NUM_CDC-1:0][31:0] CG_LOCK_ISM    = {0,1,0,1,0,1,0,1};

   for (genvar i=0; i<NUM_CDC; i++) begin : cdc_inst
    if (DRIVE_POK[i]==1) begin: cdc_pok
      ClockDomainController #(
         .DEF_PWRON(DEF_PWRON),
         .ITBITS(16),
         .RST(1),
         .AREQ(1),
         .DRIVE_POK(DRIVE_POK[i]), //update
         .ISM_AGT_IS_NS(ISM_AGT_IS_NS[i]), //update
         .RSTR_B4_FORCE(RSTR_B4_FORCE[i]), //update
         .PRESCC(PRESCC[i]), //update
         .DSYNC_CG_EN(DSYNC_CG_EN[i]), //update
         .FLOP_CG_EN(FLOP_CG_EN[i]), //update
         .CG_LOCK_ISM(CG_LOCK_ISM[i]) //update
      ) i_ClockDomainController (
         .pgcb_clk(pgcb_gclk), // input
         .pgcb_rst_b(pgcb_rst_sync_b), // input
         .clock(clock), // input
         .prescc_clock(prescc_clock), // input
         .reset_b(reset_b), // input
         .reset_sync_b(reset_sync_b[i]), // output
         .clkreq(clkreq[i]), // output
         .clkack(clkack[i]), // input
         .pok_reset_b(pok_reset_b), // input
         .pok(pok[i]), // output
         .gclock_enable_final(gclock_enable_final[i]), // output
         .gclock(gclock[i]), // output
         .greset_b(greset_b[i]), // output
         .gclock_req_sync(gclock_req_sync), // input
         .gclock_req_async(gclock_req_async[i]), // input
         .gclock_ack_async(gclock_ack_async[i]), // output
         .gclock_active(gclock_active[i]), // output
         .ism_fabric(ism_fabric), // input
         .ism_agent(ism_agent), // input
         .ism_locked(ism_locked[i]), // output
         .boundary_locked(boundary_locked[i]), // output
         
         .cfg_clkgate_disabled(cfg_clkgate_disabled), // input
         .cfg_clkreq_ctl_disabled(cfg_clkreq_ctl_disabled), // input
         .cfg_clkgate_holdoff(cfg_clkgate_holdoff[3:0]), // input [3:0]
         .cfg_pwrgate_holdoff(cfg_pwrgate_holdoff[3:0]), // input [3:0]
         .cfg_clkreq_off_holdoff(cfg_clkreq_off_holdoff[3:0]), // input [3:0]
         .cfg_clkreq_syncoff_holdoff(cfg_clkreq_syncoff_holdoff[3:0]), // input [3:0]
         
         .pwrgate_disabled(pwrgate_disabled_sync), // input
         .pwrgate_force(pwrgate_force), // input
         .pwrgate_pmc_wake(pmc_ip_wake_sync), // input
         .pwrgate_ready(pwrgate_ready[i]), // output
         
         .pgcb_force_rst_b(pgcb_force_rst_b), // input
         .pgcb_pok(pgcb_pok), // input
         .pgcb_restore(pgcb_restore), // input
         .pgcb_pwrgate_active(pgcb_pwrgate_active), // input
      
         .fscan_clkungate(fscan_clkungate), // input
         .fismdfx_force_clkreq(fismdfx_force_clkreq), // input
         .fismdfx_clkgate_ovrd(fismdfx_clkgate_ovrd), // input
         .fscan_byprst_b({3{fscan_byprst_b}}), // input [DRIVE_POK+1:0]
         .fscan_rstbypen({3{fscan_rstbypen}}), // input [DRIVE_POK+1:0]
         .fscan_clkgenctrlen({2{fscan_clkgenctrlen}}), // input [1:0]
         .fscan_clkgenctrl({2{fscan_clkgenctrl}}), // input [1:0]
            
         .cdc_visa(cdc_visa[i]) // output [23:0]
      );    
    end else begin : cdc_nopok
      ClockDomainController #(
         .DEF_PWRON(DEF_PWRON),
         .ITBITS(16),
         .RST(1),
         .AREQ(1),
         .DRIVE_POK(DRIVE_POK[i]), //update
         .ISM_AGT_IS_NS(ISM_AGT_IS_NS[i]), //update
         .RSTR_B4_FORCE(RSTR_B4_FORCE[i]), //update
         .PRESCC(PRESCC[i]), //update
         .DSYNC_CG_EN(DSYNC_CG_EN[i]), //update
         .FLOP_CG_EN(FLOP_CG_EN[i]), //update
         .CG_LOCK_ISM(CG_LOCK_ISM[i]) //update
      ) i_ClockDomainController (
         .pgcb_clk(pgcb_gclk), // input
         .pgcb_rst_b(pgcb_rst_sync_b), // input
         .clock(clock), // input
         .prescc_clock(prescc_clock), // input
         .reset_b(reset_b), // input
         .reset_sync_b(reset_sync_b[i]), // output
         .clkreq(clkreq[i]), // output
         .clkack(clkack[i]), // input
         .pok_reset_b(pok_reset_b), // input
         .pok(pok[i]), // output
         .gclock_enable_final(gclock_enable_final[i]), // output
         .gclock(gclock[i]), // output
         .greset_b(greset_b[i]), // output
         .gclock_req_sync(gclock_req_sync), // input
         .gclock_req_async(gclock_req_async[i]), // input
         .gclock_ack_async(gclock_ack_async[i]), // output
         .gclock_active(gclock_active[i]), // output
         .ism_fabric(ism_fabric), // input
         .ism_agent(ism_agent), // input
         .ism_locked(ism_locked[i]), // output
         .boundary_locked(boundary_locked[i]), // output
         
         .cfg_clkgate_disabled(cfg_clkgate_disabled), // input
         .cfg_clkreq_ctl_disabled(cfg_clkreq_ctl_disabled), // input
         .cfg_clkgate_holdoff(cfg_clkgate_holdoff[3:0]), // input [3:0]
         .cfg_pwrgate_holdoff(cfg_pwrgate_holdoff[3:0]), // input [3:0]
         .cfg_clkreq_off_holdoff(cfg_clkreq_off_holdoff[3:0]), // input [3:0]
         .cfg_clkreq_syncoff_holdoff(cfg_clkreq_syncoff_holdoff[3:0]), // input [3:0]
         
         .pwrgate_disabled(pwrgate_disabled_sync), // input
         .pwrgate_force(pwrgate_force), // input
         .pwrgate_pmc_wake(pmc_ip_wake_sync), // input
         .pwrgate_ready(pwrgate_ready[i]), // output
         
         .pgcb_force_rst_b(pgcb_force_rst_b), // input
         .pgcb_pok(pgcb_pok), // input
         .pgcb_restore(pgcb_restore), // input
         .pgcb_pwrgate_active(pgcb_pwrgate_active), // input
      
         .fscan_clkungate(fscan_clkungate), // input
         .fismdfx_force_clkreq(fismdfx_force_clkreq), // input
         .fismdfx_clkgate_ovrd(fismdfx_clkgate_ovrd), // input
         .fscan_byprst_b({2{fscan_byprst_b}}), // input [DRIVE_POK+1:0]
         .fscan_rstbypen({2{fscan_rstbypen}}), // input [DRIVE_POK+1:0]
         .fscan_clkgenctrlen({2{fscan_clkgenctrlen}}), // input [1:0]
         .fscan_clkgenctrl({2{fscan_clkgenctrl}}), // input [1:0]
            
         .cdc_visa(cdc_visa[i]) // output [23:0]
      );
    end
   end

   assign ip_pgcb_pg_rdy_req_b = !(&pwrgate_ready);

   pgcbunit #(
      .DEF_PWRON(DEF_PWRON),
      .ISOLLATCH_NOSR_EN(DEF_PWRON),
      .USE_DFX_SEQ(DEF_PWRON)
   ) i_pgcbunit (
      .clk(pgcb_gclk), // input
      .pgcb_rst_b(pgcb_rst_sync_b), // input
      .pgcb_tck(pgcb_tck), // input
      .fdfx_powergood_rst_b(fdfx_powergood_rst_b), // input

      .pgcb_pmc_pg_req_b(pgcb_pmc_pg_req_b), // output
      .pmc_pgcb_pg_ack_b(pmc_pgcb_pg_ack_b), // input
      .pmc_pgcb_restore_b(pmc_pgcb_restore_b), // input

      .ip_pgcb_pg_type(ip_pgcb_pg_type), // input [1:0]
      .ip_pgcb_pg_rdy_req_b(ip_pgcb_pg_rdy_req_b), // input
      .pgcb_ip_pg_rdy_ack_b(pgcb_ip_pg_rdy_ack_b), // output

      .pgcb_pok(pgcb_pok), // output
      .pgcb_restore(pgcb_restore), // output
      .pgcb_restore_force_reg_rw(pgcb_restore_force_reg_rw), // output

      .pgcb_sleep(pgcb_sleep), // output
      .pgcb_sleep2(pgcb_sleep2), // output
      .pgcb_isol_latchen(pgcb_isol_latchen), // output
      .pgcb_isol_en_b(pgcb_isol_en_b), // output

      .pgcb_force_rst_b(pgcb_force_rst_b), // output
      .ip_pgcb_all_pg_rst_up(ip_pgcb_all_pg_rst_up), // input

      .pgcb_idle(pgcb_idle), // output
      .pgcb_pwrgate_active(pgcb_pwrgate_active), // output
      .ip_pgcb_frc_clk_srst_cc_en(ip_pgcb_frc_clk_srst_cc_en), // input
      .ip_pgcb_frc_clk_cp_en(ip_pgcb_frc_clk_cp_en), // input
      .pgcb_ip_force_clks_on(pgcb_ip_force_clks_on), // output
      .ip_pgcb_force_clks_on_ack(ip_pgcb_force_clks_on_ack), // input

      .ip_pgcb_sleep_en(ip_pgcb_sleep_en), // input
      
      .cfg_tsleepinactiv(2'b00), // input [1:0]
      .cfg_tdeisolate(2'b01), // input [1:0]
      .cfg_tpokup(2'b10), // input [1:0]
      .cfg_tinaccrstup(2'b11), // input [1:0]
      .cfg_taccrstup(2'b00), // input [1:0]
      .cfg_tlatchen(2'b01), // input [1:0]

      .cfg_tpokdown(2'b10), // input [1:0]
      .cfg_tlatchdis(2'b11), // input [1:0]
      .cfg_tsleepact(2'b00), // input [1:0]
      .cfg_tisolate(2'b01), // input [1:0]
      .cfg_trstdown(2'b10), // input [1:0]
      .cfg_tclksonack_srst(2'b11), // input [1:0]
      .cfg_tclksoffack_srst(2'b00), // input [1:0]
      .cfg_tclksonack_cp(2'b01), // input [1:0]
      .cfg_trstup2frcclks(2'b10), // input [1:0]

      .cfg_trsvd0('0), // input [1:0]
      .cfg_trsvd1('0), // input [1:0]
      .cfg_trsvd2('0), // input [1:0]
      .cfg_trsvd3('0), // input [1:0]
      .cfg_trsvd4('0), // input [1:0]

      .pmc_pgcb_fet_en_b(pmc_pgcb_fet_en_b), // input
      .pgcb_ip_fet_en_b(pgcb_ip_fet_en_b), // output

      .fdfx_pgcb_bypass(fdfx_pgcb_bypass), // input
      .fdfx_pgcb_ovr(fdfx_pgcb_ovr), // input
      .fscan_ret_ctrl(fscan_ret_ctrl), // input
      .fscan_mode(fscan_mode), // input

      .pgcb_visa(pgcb_visa)
   );
   
   pgcbcg #(
      .DEF_PWRON(DEF_PWRON),
      .ICDC(NUM_CDC),
      .NCDC(NUM_CDC),
      .IGCLK_REQ_ASYNC(NUM_CDC),
      .NGCLK_REQ_ASYNC(NUM_CDC)
   ) i_pgcbcg (
      .pgcb_clk(pgcb_clk),
      .pgcb_clkack(pgcb_clkack),
      .pgcb_clkreq(pgcb_clkreq),
      .pgcb_rst_b(pgcb_rst_sync_b),
      .iosf_cdc_clock({NUM_CDC{clock}}),
      .iosf_cdc_reset_b({NUM_CDC{reset_b}}),
      .iosf_cdc_ism_fabric({NUM_CDC{ism_fabric}}),
      .iosf_cdc_clkreq(clkreq),
      .iosf_cdc_clkack(clkack),
      .iosf_cdc_gclock_req_async(gclock_req_async),
      .iosf_cdc_gclock_ack_async(gclock_ack_async),

      .non_iosf_cdc_clkreq(clkreq),
      .non_iosf_cdc_clkack(clkack),
      .non_iosf_cdc_gclock_req_async(gclock_req_async),
      .non_iosf_cdc_gclock_ack_async(gclock_ack_async),

      .async_pwrgate_disabled(pwrgate_disabled),
      .pmc_pg_wake(pmc_ip_wake),
      .pgcb_pok(pgcb_pok),
      .pgcb_idle(pgcb_idle),
      .cfg_acc_clkgate_disabled(cfg_acc_clkgate_disabled),
      .cfg_t_clkgate(cfg_t_clkgate),
      .cfg_t_clkwake(cfg_t_clkwake),
      .fscan_byprst_b({8{fscan_byprst_b}}),
      .fscan_rstbypen({8{fscan_rstbypen}}),
      .fscan_clkungate(fscan_clkungate),
      .visa_bus(pgcbcg_visa),
      .pgcb_gclk(pgcb_gclk)
   );
   
endmodule
