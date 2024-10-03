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

module tooltb #(
   parameter DEF_PWRON   = 0,
   parameter NUM_CDC     = 8
)(
   input logic pgcb_clk,
   input logic clock,
   input logic prescc_clock,
   input logic pgcb_tck,
   
   input logic pgcb_rst_b,
   input logic reset_b,
   input logic pok_reset_b,
   input logic fdfx_powergood_rst_b,
   output logic [NUM_CDC*2-1:0] reset_sync_b,
   
   // ASYNC
   input logic [NUM_CDC*2-1:0] gclock_req_async,
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
   
   output logic [1:0] pgcb_ip_fet_en_b,
   output logic [1:0] pgcb_clkreq,
   
   // CDC_CLK
   input logic gclock_req_sync,
   input logic [2:0] ism_fabric,
   input logic [2:0] ism_agent,

   output logic [NUM_CDC*2-1:0] clkreq,
   output logic [NUM_CDC*2-1:0] pok,
   output logic [NUM_CDC*2-1:0] gclock_enable_final,
   output logic [NUM_CDC*2-1:0] gclock,
   output logic [NUM_CDC*2-1:0] greset_b,
   output logic [NUM_CDC*2-1:0] gclock_active,
   output logic [NUM_CDC*2-1:0] ism_locked,
   output logic [NUM_CDC*2-1:0] boundary_locked,
   output logic [NUM_CDC*2-1:0] gclock_ack_async,
   

   // PGCB_CLK
   input logic [NUM_CDC*2-1:0] clkack,
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
   
   output logic [1:0] pgcb_ip_force_clks_on,
   output logic [1:0] pgcb_pmc_pg_req_b,
   output logic [1:0] pgcb_ip_pg_rdy_ack_b,
   output logic [1:0] pgcb_restore_force_reg_rw,
   output logic [1:0] pgcb_sleep,
   output logic [1:0] pgcb_sleep2,
   output logic [1:0] pgcb_isol_latchen,
   output logic [1:0] pgcb_isol_en_b,
   
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
   
   output logic [NUM_CDC*2-1:0][23:0] cdc_visa,
   output logic [1:0][23:0] pgcb_visa,
   output logic [1:0][31:0] pgcbcg_visa
   
);   
   
   tooltb_pgd #(
      .DEF_PWRON(0),
      .NUM_CDC(NUM_CDC)
   ) i_tooltb_pgd_off (
      .gclock_req_async(gclock_req_async[NUM_CDC-1:0]),
      .pgcb_ip_fet_en_b(pgcb_ip_fet_en_b[0]),
      .pgcb_clkreq(pgcb_clkreq[0]),
      .clkreq(clkreq[NUM_CDC-1:0]),
      .pok(pok[NUM_CDC-1:0]),
      .gclock_enable_final(gclock_enable_final[NUM_CDC-1:0]),
      .gclock(gclock[NUM_CDC-1:0]),
      .greset_b(greset_b[NUM_CDC-1:0]),
      .reset_sync_b(reset_sync_b[NUM_CDC-1:0]),
      .gclock_active(gclock_active[NUM_CDC-1:0]),
      .ism_locked(ism_locked[NUM_CDC-1:0]),
      .boundary_locked(boundary_locked[NUM_CDC-1:0]),
      .gclock_ack_async(gclock_ack_async[NUM_CDC-1:0]),
      .clkack(clkack[NUM_CDC-1:0]),
      .pgcb_ip_force_clks_on(pgcb_ip_force_clks_on[0]),
      .pgcb_pmc_pg_req_b(pgcb_pmc_pg_req_b[0]),
      .pgcb_ip_pg_rdy_ack_b(pgcb_ip_pg_rdy_ack_b[0]),
      .pgcb_restore_force_reg_rw(pgcb_restore_force_reg_rw[0]),
      .pgcb_sleep(pgcb_sleep[0]),
      .pgcb_sleep2(pgcb_sleep2[0]),
      .pgcb_isol_latchen(pgcb_isol_latchen[0]),
      .pgcb_isol_en_b(pgcb_isol_en_b[0]),
      .cdc_visa(cdc_visa[NUM_CDC-1:0]),
      .pgcb_visa(pgcb_visa[0]),
      .pgcbcg_visa(pgcbcg_visa[0]),
      .*
   );   
   
   tooltb_pgd #(
      .DEF_PWRON(1),
      .NUM_CDC(NUM_CDC)
   ) i_tooltb_pgd_on (
      .gclock_req_async(gclock_req_async[NUM_CDC*2-1:NUM_CDC]),
      .pgcb_ip_fet_en_b(pgcb_ip_fet_en_b[1]),
      .pgcb_clkreq(pgcb_clkreq[1]),
      .clkreq(clkreq[NUM_CDC*2-1:NUM_CDC]),
      .pok(pok[NUM_CDC*2-1:NUM_CDC]),
      .gclock_enable_final(gclock_enable_final[NUM_CDC*2-1:NUM_CDC]),
      .gclock(gclock[NUM_CDC*2-1:NUM_CDC]),
      .greset_b(greset_b[NUM_CDC*2-1:NUM_CDC]),
      .reset_sync_b(reset_sync_b[NUM_CDC*2-1:NUM_CDC]),
      .gclock_active(gclock_active[NUM_CDC*2-1:NUM_CDC]),
      .ism_locked(ism_locked[NUM_CDC*2-1:NUM_CDC]),
      .boundary_locked(boundary_locked[NUM_CDC*2-1:NUM_CDC]),
      .gclock_ack_async(gclock_ack_async[NUM_CDC*2-1:NUM_CDC]),
      .clkack(clkack[NUM_CDC*2-1:NUM_CDC]),
      .pgcb_ip_force_clks_on(pgcb_ip_force_clks_on[1]),
      .pgcb_pmc_pg_req_b(pgcb_pmc_pg_req_b[1]),
      .pgcb_ip_pg_rdy_ack_b(pgcb_ip_pg_rdy_ack_b[1]),
      .pgcb_restore_force_reg_rw(pgcb_restore_force_reg_rw[1]),
      .pgcb_sleep(pgcb_sleep[1]),
      .pgcb_sleep2(pgcb_sleep2[1]),
      .pgcb_isol_latchen(pgcb_isol_latchen[1]),
      .pgcb_isol_en_b(pgcb_isol_en_b[1]),
      .cdc_visa(cdc_visa[NUM_CDC*2-1:NUM_CDC]),
      .pgcb_visa(pgcb_visa[1]),
      .pgcbcg_visa(pgcbcg_visa[1]),
      .*
   );   
endmodule
