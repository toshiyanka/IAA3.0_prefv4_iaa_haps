//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
// hqm_pm_unit
//
// This module implement the HQM PMSM logic 
//
//-----------------------------------------------------------------------------------------------------

module hqm_pm_unit

    import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
   parameter HQM_TRIGGER_WIDTH = 3
  ,parameter HQM_PMU_DEF_PWRON = 0
  // pgcb related
  ,parameter HQM_PMU_PGCB_ISOLLATCH_NOSR_EN = 0
  ,parameter HQM_PMU_PGCB_UNGATE_TIMER = 2'b11
  ,parameter HQM_PMU_PGCB_USE_DFX_SEQ = 1       // 1=DFx Sequencer is used to determine override values, 0=Latched PGCB FSM values will be used for override values
  ,parameter HQM_PMU_PGCB_DELAY_ASSN_RST = 0    // If set, the reset used by the assertions will be delayed
                                                // by 1 clock, should only set to '1' if the clk input could be
                                                // gated when s synchronized externally
  // cdc related                                
  ,parameter HQM_PMU_CDC_ITBITS = 16            // Idle Timer Bits.  Max is 16
  ,parameter HQM_PMU_CDC_RST = 1                // Number of resets.  Min is one.
  ,parameter HQM_PMU_CDC_AREQ = 1               // Number of async gclock requests.  Min is one.
  ,parameter HQM_PMU_CDC_DRIVE_POK = 0          // Determines whether this domain must drive POK
  ,parameter HQM_PMU_CDC_ISM_AGT_IS_NS = 0      // If 1, *_locked signals will be driven as the output of a flop
                                                // If 0, *_locked signals will assert combinatorially
  ,parameter HQM_PMU_CDC_RSTR_B4_FORCE = 0      // Determines if this CDC will require restore phase to complete
                                                // in order to transition from IP-Accessible to IP-Inaccessible PG
  ,parameter HQM_PMU_CDC_PRESCC = 0             // If 1, The master_clock gate logic with have clkgenctrl muxes for scan to have control
                                                //       of the master_clock branch in order to be used preSCC
                                                //       NOTE: FLOP_CG_EN and DSYNC_CG_EN are a dont care when PRESCC=1
  ,parameter HQM_PMU_CDC_DSYNC_CG_EN = 0        // If 1, the master_clock-gate enable will be synchronized to the short master_clock-tree version
                                                //       of master_clock to allow for STA convergence on fast clocks ( >120 MHz )
                                                //       Note: FLOP_CG_EN is a don't care when DSYNC_CG_EN=1
  ,parameter HQM_PMU_CDC_FLOP_CG_EN = 1         // If 1, the clock-gate enable will be driven solely by the output of a flop
                                                // If 0, there will be a combi path into the cg enable to allow for faster ungating
  ,parameter HQM_PMU_CDC_CG_LOCK_ISM = 0        // if set to 1, ism_locked signal is asserted whenever gclock_active is low
) (
      input  logic                        aon_clk 
    , input  logic                        pgcb_clk 
    , input  logic                        pgcb_tck

    , input  logic                        hqm_freerun_clk     // Restrict usage to within PM FLR Unit only
    , input  logic                        hqm_fullrate_clk    // use to synchronize resets, etc..

    , input  logic                        prim_freerun_clk
    , input  logic                        prim_gated_clk

    , input  logic                        side_rst_b
    , input  logic                        hqm_cdc_clk

    , input  logic                        prim_gated_rst_b
     
    , output logic                        flr_clkreq_b
    , output logic                        hqm_pwrgood_rst_b
    , output logic                        hqm_gated_local_override

    , output logic                        pgcb_force_rst_b

    // FUSE INTF
    , input  logic                        fuse_force_on
    , input  logic                        fuse_proc_disable
    , input  logic                        prochot_deglitch_sync

    , input  pm_fsm_t                     pm_state 

    , input  logic                        pgcb_fet_en_ack_b
    , output logic                        pgcb_fet_en_b

    , input  cfg_pm_override_t            cfg_pm_override

    , input  cfg_hqm_pgcb_ctl_t           cfg_hqm_pgcb_ctl
    , input  logic                        cfg_hqm_pgcb_ctl_v

    , input  cfg_hqm_cdc_ctl_t            cfg_hqm_cdc_ctl
    , input  logic                        cfg_hqm_cdc_ctl_v

    , input  cfg_pm_pmcsr_disable_t       cfg_pm_pmcsr_disable

    , input  logic                        master_ctl_load
    , input  master_ctl_reg_t             master_ctl

    , output cfg_pm_status_t              cfg_pm_status
    , output logic  [63:0]                cfg_flr_count
    , output logic                        cfg_d3tod0_event_cnt_inc
    , output logic                        pm_fsm_in_run 
    , output flrsm_t                      flrsm_state

    , output logic                        pm_fsm_d0tod3_ok
    , output logic                        pm_fsm_d3tod0_ok

    , input  logic                        flr_triggered               // START_FLR bit 

    , output logic                        hqm_shields_up
    , output logic                        hqm_flr_prep

    , output logic                        hqm_clk_enable_int          // hqm_proc RCL_LCB clock enble (hqm_clk)
    , output logic                        gclock_enable_final
    , output logic                        hqm_clk_ungate_presync         
    , output logic                        hqm_gated_rst_b             // connect to all hqm_proc logic 

    , output logic                        pgcb_isol_en_b
    , output logic                        pgcb_isol_en

    //--  DFx Controls --//
    , input  logic                        fdfx_powergood

    , input  logic                        fdfx_pgcb_bypass           // PGCB DFx Bypass Enable
    , input  logic                        fdfx_pgcb_ovr              // PGCB DFx Sequencer Control (1=Power Up, 2=Power Down)
    , input  logic                        fscan_isol_ctrl            // DFx Override Value for isol_en_b (if fscan_mode==1)
    , input  logic                        fscan_isol_lat_ctrl        // DFx Override Value for isol_laten (if fscan_mode==1)
    , input  logic                        fscan_ret_ctrl             // DFx Override Value for sleep (if fscan_mode==1)
    , input  logic                        fscan_mode                 // DFX Override Enabled for sleep
    , input  logic                        fscan_fet_on               // DFX Override Value for fet_en_b (if fscan_mode==1)
    , input  logic                        fscan_fet_en_sel
    , input  logic                        fscan_trigger_mask_v       // I: dfx mask valid for trigger mask
    , input  logic   [ ( 30 ) - 1 : 0 ]   fscan_trigger_mask         // I: dfx mask for trigger logic

    //-- Scan Controls --//
    , input  logic                        fscan_clkungate
    , input  logic                        fscan_rstbypen              // Scan reste bypass enable
    , input  logic                        fscan_byprst_b              // Scan reset bypass value

    , input  logic                        cdc_hqm_jta_force_clkreq    // DFx force assert clkreq
    , input  logic                        cdc_hqm_jta_clkgate_ovrd    // DFx force GATE gclock

    //-- VISA Signals --//
    , input  logic                        penable
    , input  logic                        pwrite
    , input  logic  [3:0]                 paddr_31_28
    , input  logic                        pready
    , input  logic  [2:0]                 prdata_2_0

    , output logic [9:0]                  hqm_triggers
    , input  logic [9:0]                  hqm_triggers_in

    , output logic                        pm_fsm_active

    , output logic                        hqm_cdc_clk_enable 

    , input  logic                        hw_reset_force_pwr_on 

    , output logic                        pgcb_hqm_pwrgate_active       // viewpin
    , output logic                        final_pgcb_fet_en_ack_b       // viewpin
    , output logic                        pgcb_fet_en_b_out             // viewpin

    , output logic [23:0]                 hqm_cdc_visa
    , output logic [23:0]                 hqm_pgcbunit_visa
    , output logic [31:0]                 hqm_pmsm_visa

);

// logic declaration
  logic [1:0]                            hqm_pgcb_pg_type;
  logic                                  pgcb_hqm_pok;
  logic                                  pgcb_hqm_restore;
  logic                                  pgcb_restore_force_reg_rw_nc;
  logic                                  pgcb_sleep_nc;
  logic                                  pgcb_sleep2_nc;
  logic                                  side_rst_b_sync;

  logic                                  prim_freerun_prim_gated_rst_b_sync;
  logic                                  reset_sync_b_nc;

  logic                                  hqm_clk_ungate_f, hqm_clk_ungate_nxt; 

  // i_hqm_cdc related
  logic                                  pok_nc;

  logic                                  hqm_flr_clk_en;
  logic                                  gclock_req_async; 

  logic                                  pgcb_hqm_pg_rdy_ack_b;
  logic                                  gclock_ack_async_nc;
  logic                                  gclock_active_nc;
  logic                                  ism_locked_nc;
  logic                                  boundary_locked_nc;
  logic                                  pwrgate_force;
  logic                                  hqm_pgcb_pg_ack_b;
  logic                                  hqm_pgcb_pg_rdy_req_b;

  logic                                  pgcb_ip_force_clks_on_nc;

  logic [1:0]                            cfg_trsvd0;
  logic [1:0]                            cfg_trsvd1;
  logic [1:0]                            cfg_trsvd2;
  logic [1:0]                            cfg_trsvd3;
  logic [1:0]                            cfg_trsvd4;

  pmsm_t                                 pmsm_state_f, pmsm_state_nxt;
  logic                                  pgcb_isol_latchen_nc;
  logic                                  pgcb_hqm_pg_rdy_ack_b_f;
  logic                                  hqm_pwrgate_ready;
  logic                                  hqm_pwrgate_ready_f;
  logic                                  pmsm_pgcb_req_b;
  logic                                  cfg_pmsm_pgcb_req_b_ctl_f;
  logic                                  cfg_pmsm_pgcb_req_b_ctl_nxt;
  logic                                  hqm_proc_clkreq;
  logic                                  hqm_fullrate_clk_side_rst_b_sync;
  logic                                  hqm_proc_clkreq_sync;
  logic [2:0]                            hqm_proc_clkreq_pipe_f;
  logic                                  prim_freerun_side_rst_b_sync;

  logic                                  side_rst_b_aon_sync;


  cfg_hqm_cdc_ctl_t                      cfg_hqm_cdc_ctl_sync;
  logic                                  cfg_pm_override_ctl;
  cfg_hqm_pgcb_ctl_t                     cfg_hqm_pgcb_ctl_sync;
  logic                                  cfg_pm_pmcsr_disable_ctl;
  logic                                  pgcb_hqm_pg_rdy_ack_b_f_sync;
  logic                                  hqm_in_d3;
  logic                                  hqm_rst_b;
  logic                                  gclock_nc;
  logic                                  pmsm_shields_up;
  
  logic                                  hqm_pm_unit_flr_req_edge;

  logic                                  pmc_pgcb_fet_en_b_f;
  logic                                  pmc_pgcb_fet_en_b;
  logic                                  pmc_pgcb_pg_ack_b;
  logic                                  pmc_pgcb_pg_ack_b_in;

  logic                                  pgcb_pmc_pg_req_b;

  logic                                  master_ctl_load_sync_pgcb; 
  master_ctl_pgcb_t                      master_ctl_pgcb_nxt;
  master_ctl_pgcb_t                      master_ctl_pgcb_f;
  logic [2:0]                            master_ctl_nc;

  logic                                  master_ctl_load_sync_prim; 
  master_ctl_reg_t                       master_ctl_prim_nxt;
  master_ctl_reg_t                       master_ctl_prim_f;
  logic                                  master_ctl_prim_f_pnc;

  logic [9:0]                            vec_iosf_mask;
  logic [9:0]                            vec_pm_unit_0_mask;
  logic [9:0]                            vec_pm_unit_1_mask;
  logic                                  fscan_trigger_mask_v_prev_f;
  logic                                  fscan_trigger_mask_v_sync_f;
  logic                                  fscan_trigger_mask_load;
  logic [29:0]                           fscan_trigger_mask_aon_nxt;
  logic [29:0]                           fscan_trigger_mask_aon_f;

  logic                                  pmc_pgcb_pg_ack_b_in_delay0_f;
  logic                                  pmc_pgcb_pg_ack_b_in_delay1_f;
  
  logic                                  pgcb_hqm_idle_sync_prim;
  logic [2:0]                            final_pgcb_fet_en_ack_b_f;  
  logic                                  final_pgcb_fet_en_ack_b_f_and;  
  logic                                  final_pgcb_fet_en_ack_b_f_or;  
  logic                                  pgcb_fet_en_ack_b_sync;  

  pmsm_visa_t                            pmsm_visa_noapb;
  logic                                  pmsm_visa_nc;
  cfg_pm_pmcsr_disable_t                 cfg_pm_pmcsr_disable_f;
  cfg_pm_override_t                      cfg_pm_override_f;
//  pmsm_visa_t                            hqm_pmsm_visa;
  logic                                  pgcb_hqm_idle;
  logic                                  pgcb_fet_en_b_pre;
  logic                                  pgcb_prim_gated_rst_b_sync;

  assign pgcb_isol_en = ~pgcb_isol_en_b;

// assigns
assign hqm_pgcb_pg_type = 2'b00;  //2'b00 - IP-Accessible, 2'b01 - Warm Reset, 2'b10 - Reserved, 2'b11 - IP-Inaccessible

assign gclock_req_async = hqm_pgcb_pg_ack_b;
assign pwrgate_force = ~pgcb_hqm_pwrgate_active & ~hqm_pgcb_pg_ack_b; 
assign hqm_pgcb_pg_rdy_req_b = ~hqm_pwrgate_ready_f | hqm_pgcb_pg_ack_b | master_ctl_pgcb_f.PWRGATE_PMC_WAKE;

assign cfg_trsvd0 = 2'd2;
assign cfg_trsvd1 = 2'd2;
assign cfg_trsvd2 = 2'd2;
assign cfg_trsvd3 = 2'd2;
assign cfg_trsvd4 = 2'd2;

assign master_ctl_nc       = master_ctl.OVERRIDE_CLK_SWITCH_CONTROL ;
//------------------------------------------------------------------------------------------------------------------

hqm_AW_reset_sync_scan i_side_rst_b_sync (

         .clk               (pgcb_clk)
        ,.rst_n             (side_rst_b)
        ,.fscan_rstbypen    (fscan_rstbypen)
        ,.fscan_byprst_b    (fscan_byprst_b)
        ,.rst_n_sync        (side_rst_b_sync)
);

hqm_AW_reset_sync_scan i_side_rst_b_aon_sync (

         .clk               (aon_clk)
        ,.rst_n             (side_rst_b)
        ,.fscan_rstbypen    (fscan_rstbypen)
        ,.fscan_byprst_b    (fscan_byprst_b)
        ,.rst_n_sync        (side_rst_b_aon_sync)
);

hqm_AW_reset_sync_scan i_hqm_prim_freerun_side_rst_b_sync (

         .clk               (prim_freerun_clk)
        ,.rst_n             (side_rst_b)
        ,.fscan_rstbypen    (fscan_rstbypen)
        ,.fscan_byprst_b    (fscan_byprst_b)
        ,.rst_n_sync        (prim_freerun_side_rst_b_sync)
);

// sync prim_gated_rst_b to prim_freerun_clk
hqm_AW_reset_sync_scan i_hqm_prim_freerun_prim_gated_rst_b_sync (

         .clk               (prim_freerun_clk)
        ,.rst_n             (prim_gated_rst_b )
        ,.fscan_rstbypen    (fscan_rstbypen)
        ,.fscan_byprst_b    (fscan_byprst_b)
        ,.rst_n_sync        (prim_freerun_prim_gated_rst_b_sync)
);

hqm_AW_reset_sync_scan i_hqm_fullrate_clk_side_rst_b_sync (

         .clk               (hqm_fullrate_clk)
        ,.rst_n             (side_rst_b)
        ,.fscan_rstbypen    (fscan_rstbypen)
        ,.fscan_byprst_b    (fscan_byprst_b)
        ,.rst_n_sync        (hqm_fullrate_clk_side_rst_b_sync)
);

hqm_AW_sync_rst0 i_hqm_proc_clkreq_sync (.clk (hqm_fullrate_clk)          ,.rst_n (hqm_fullrate_clk_side_rst_b_sync) ,.data (hqm_proc_clkreq)  ,.data_sync (hqm_proc_clkreq_sync));

hqm_AW_flops_rst0 #( .WIDTH (3) ) hqm_proc_clkreq_pipe_flops (
         .clk    (hqm_fullrate_clk)
        ,.rst_n  (hqm_fullrate_clk_side_rst_b_sync)
        ,.data   ({hqm_proc_clkreq_pipe_f[1:0],hqm_proc_clkreq_sync})

        ,.data_q (hqm_proc_clkreq_pipe_f)
);

logic hw_reset_force_pwr_on_sync;

hqm_AW_sync_rst0 i_hw_reset_force_pwr_on_sync (.clk (prim_freerun_clk)    ,.rst_n (prim_freerun_prim_gated_rst_b_sync) ,.data (hw_reset_force_pwr_on)  ,.data_sync (hw_reset_force_pwr_on_sync));

assign hqm_cdc_clk_enable = hqm_proc_clkreq_pipe_f[2];


// hqm powerm management SM
hqm_pmsm #(
  .HQM_PMSM_MAXCNT (32)
) i_hqm_pmsm (
      .prim_freerun_clk                   (prim_freerun_clk)
    , .prim_freerun_prim_gated_rst_b_sync (prim_freerun_prim_gated_rst_b_sync)

    // FUSE INTF
    , .fuse_force_on                       (fuse_force_on)
    , .fuse_proc_disable                   (fuse_proc_disable)

    , .cfg_pm_override                     (cfg_pm_override_ctl)
    , .cfg_pm_pmcsr_disable                (cfg_pm_pmcsr_disable_ctl)
    , .pgcb_hqm_pg_rdy_ack_b               (pgcb_hqm_pg_rdy_ack_b_f_sync)
    , .pgcb_hqm_idle                       (pgcb_hqm_idle)

    , .hqm_in_d3                           (hqm_in_d3)
    , .hqm_pm_unit_flr_req_edge            (hqm_pm_unit_flr_req_edge)
    , .pm_fsm_d0tod3_ok                    (pm_fsm_d0tod3_ok)
    , .pm_fsm_d3tod0_ok                    (pm_fsm_d3tod0_ok)

    , .pmsm_pgcb_req_b                     (pmsm_pgcb_req_b) 
    , .pmsm_shields_up                     (pmsm_shields_up)

    , .pmsm_state_nxt                      (pmsm_state_nxt)
    , .pmsm_state_f                        (pmsm_state_f)
    , .pgcb_hqm_idle_sync_prim             (pgcb_hqm_idle_sync_prim)

    , .pmsm_visa                           (pmsm_visa_noapb)
    , .cfg_d3tod0_event_cnt_inc            (cfg_d3tod0_event_cnt_inc)
    , .pm_fsm_in_run                       (pm_fsm_in_run)
    , .pm_fsm_active                       (pm_fsm_active)
    , .hw_reset_force_pwr_on_sync          (hw_reset_force_pwr_on_sync)

);

hqm_pgcbunit #(
        .DEF_PWRON          (HQM_PMU_DEF_PWRON)          // If set, the PGCB will reset to a powered on state
      , .ISOLLATCH_NOSR_EN  (HQM_PMU_PGCB_ISOLLATCH_NOSR_EN)  // If set, the PGCB will close isolation latches as part of
                                                         // IP-Accessible power gating when state retention is
                                                         // disabled

      , .UNGATE_TIMER       (HQM_PMU_PGCB_UNGATE_TIMER)       // Value to use for PGCB
      , .USE_DFX_SEQ        (HQM_PMU_PGCB_USE_DFX_SEQ)        // 1=DFx Sequencer is used to determine override values
                                                         // 0=Latched PGCB FSM values will be used for override values

      , .DELAY_ASSN_RST     (HQM_PMU_PGCB_DELAY_ASSN_RST)     // If set, the reset used by the assertions will be delayed
                                                         // by 1 clock, should only set to '1' if the clk input could be
                                                         // gated when pgcb_rst_b is synchronized externally
   ) i_hqm_pgcbunit (

      //-- Clocks/Resets --//
        .clk                        (pgcb_clk)                                  // I
      , .pgcb_rst_b                 (side_rst_b_sync)                           // I
      , .pgcb_tck                   (pgcb_tck)                                  // I
      , .fdfx_powergood_rst_b       (fdfx_powergood)                            // I
                                                                                   
      //-- PGCB<->PMC Interface --//                                               
      , .pgcb_pmc_pg_req_b          (pgcb_pmc_pg_req_b)                         // O
      , .pmc_pgcb_pg_ack_b          (pmc_pgcb_pg_ack_b)                         // I
      , .pmc_pgcb_restore_b         (1'b1)                                      // I
                                                                                 
      //-- PGCB<->IP Interface (Functional) --//                                 
      , .ip_pgcb_pg_type            (hqm_pgcb_pg_type)                          // I
      , .ip_pgcb_pg_rdy_req_b       (hqm_pgcb_pg_rdy_req_b)                     // I
      , .pgcb_ip_pg_rdy_ack_b       (pgcb_hqm_pg_rdy_ack_b)                     // O 
                                                                                
      , .pgcb_pok                   (pgcb_hqm_pok)                              // O
      , .pgcb_restore               (pgcb_hqm_restore)                          // O
      , .pgcb_restore_force_reg_rw  (pgcb_restore_force_reg_rw_nc )             // O
                                                                               
      , .pgcb_sleep                 (pgcb_sleep_nc)                             // O
      , .pgcb_sleep2                (pgcb_sleep2_nc)                            // O
      , .pgcb_isol_latchen          (pgcb_isol_latchen_nc)                      // O
      , .pgcb_isol_en_b             (pgcb_isol_en_b)                            // O
                                                                               
      , .pgcb_force_rst_b           (pgcb_force_rst_b)                          // O
      , .ip_pgcb_all_pg_rst_up      (1'b1)                                      // I

      , .pgcb_idle                  (pgcb_hqm_idle)                             // O use in PMSM logic
      , .pgcb_pwrgate_active        (pgcb_hqm_pwrgate_active)                   // O Indicates that a power-gate flow is in progress
                                                                                //   and that the fabric ISMs and boundary interfaces
                                                                                //   must remain locked, unless a restore is
                                                                                //   occurring
                                                                                //   Note: unlike other outputs, this signal is
                                                                                //   combinatorial rather than the output of a flop
      , .ip_pgcb_frc_clk_srst_cc_en (1'b0)                                      // I
      , .ip_pgcb_frc_clk_cp_en      (1'b0)                                      // I
      , .pgcb_ip_force_clks_on      (pgcb_ip_force_clks_on_nc)                  // O
      , .ip_pgcb_force_clks_on_ack  (1'b0)                                      // I

      //-- PGCB<->IP Interface (Configuration)--//
      , .ip_pgcb_sleep_en           (cfg_hqm_pgcb_ctl_sync.SLEEP_EN)            // I
      , .cfg_tsleepinactiv          (cfg_hqm_pgcb_ctl_sync.SLEEP_INACTIV)       // I
      , .cfg_tdeisolate             (cfg_hqm_pgcb_ctl_sync.TDEISOLATE)          // I
      , .cfg_tpokup                 (cfg_hqm_pgcb_ctl_sync.TPOKUP)              // I
      , .cfg_tinaccrstup            (cfg_hqm_pgcb_ctl_sync.TINACCRSTUP)         // I
      , .cfg_taccrstup              (cfg_hqm_pgcb_ctl_sync.TACCRSTUP)           // I
      , .cfg_tlatchen               (cfg_hqm_pgcb_ctl_sync.TLATCHEN)            // I
                                                                               
      , .cfg_tpokdown               (cfg_hqm_pgcb_ctl_sync.TPOKDOWN)            // I
      , .cfg_tlatchdis              (cfg_hqm_pgcb_ctl_sync.TLATCHDIS)           // I
      , .cfg_tsleepact              (cfg_hqm_pgcb_ctl_sync.TSLEEPACT)           // I
      , .cfg_tisolate               (cfg_hqm_pgcb_ctl_sync.TISOLATE)            // I
      , .cfg_trstdown               (cfg_hqm_pgcb_ctl_sync.TRSTDOWN)            // I
      , .cfg_tclksonack_srst        (cfg_hqm_pgcb_ctl_sync.TCLKSONACK_SRST)     // I
      , .cfg_tclksoffack_srst       (cfg_hqm_pgcb_ctl_sync.TCLKSOFFACK_SRST)    // I
      , .cfg_tclksonack_cp          (cfg_hqm_pgcb_ctl_sync.TCLKSONACK_CP)       // I
      , .cfg_trstup2frcclks         (cfg_hqm_pgcb_ctl_sync.TRSTUP2FRCCLKS)      // I
                                                        
      , .cfg_trsvd0                 (cfg_trsvd0)                                // I
      , .cfg_trsvd1                 (cfg_trsvd1)                                // I
      , .cfg_trsvd2                 (cfg_trsvd2)                                // I
      , .cfg_trsvd3                 (cfg_trsvd3)                                // I
      , .cfg_trsvd4                 (cfg_trsvd4)                                // I
            
      //-- PFET Controls --//
      , .pmc_pgcb_fet_en_b          (pmc_pgcb_fet_en_b_f)                       // I // PFET Enable
      , .pgcb_ip_fet_en_b           (pgcb_fet_en_b_out)                         // O // PFET Enable with DFx Override, should be connected to IP FET block
                                                                                   
      //-- External DFx Override Controls --//                                     
      , .fdfx_pgcb_bypass           (fdfx_pgcb_bypass)                          // I DFx
      , .fdfx_pgcb_ovr              (fdfx_pgcb_ovr)                             // I DFx
      , .fscan_isol_ctrl            (fscan_isol_ctrl)                           // I DFx
      , .fscan_isol_lat_ctrl        (fscan_isol_lat_ctrl)                       // I DFx
      , .fscan_ret_ctrl             (fscan_ret_ctrl)                            // I DFx
      , .fscan_mode                 (fscan_mode)                                // I DFx
                                                                                   
      //-- PGCB VISA Signals --//                                                  
      , .pgcb_visa                  (hqm_pgcbunit_visa)                         // O 

);

// sync with reset for hqm_pgcb_pg_ack_b
hqm_AW_sync_rst0 i_hqm_pgcb_pg_ack_b_sync       (.clk (pgcb_clk)          ,.rst_n (side_rst_b_sync)                     ,.data (cfg_pmsm_pgcb_req_b_ctl_f) ,.data_sync (hqm_pgcb_pg_ack_b));
hqm_AW_sync_rst0 i_pgcb_hqm_pg_rdy_ack_b_f_sync (.clk (prim_freerun_clk)  ,.rst_n (prim_freerun_prim_gated_rst_b_sync) ,.data (pgcb_hqm_pg_rdy_ack_b_f) ,.data_sync (pgcb_hqm_pg_rdy_ack_b_f_sync));

always_ff @(posedge pgcb_clk or negedge side_rst_b_sync) begin
    if (~side_rst_b_sync) begin
      hqm_pwrgate_ready_f <= 1'b1;
      pgcb_hqm_pg_rdy_ack_b_f <= 1'b0; 
      final_pgcb_fet_en_ack_b_f[0] <= 1'b1;
      final_pgcb_fet_en_ack_b_f[1] <= 1'b1;
      final_pgcb_fet_en_ack_b_f[2] <= 1'b1;
    end else begin
      hqm_pwrgate_ready_f <= hqm_pwrgate_ready;
      pgcb_hqm_pg_rdy_ack_b_f <= pgcb_hqm_pg_rdy_ack_b; 
      final_pgcb_fet_en_ack_b_f[0] <= pgcb_fet_en_ack_b_sync;
      final_pgcb_fet_en_ack_b_f[1] <= final_pgcb_fet_en_ack_b_f[0];
      final_pgcb_fet_en_ack_b_f[2] <= final_pgcb_fet_en_ack_b_f[1];
    end
end

assign final_pgcb_fet_en_ack_b_f_and = &final_pgcb_fet_en_ack_b_f;
assign final_pgcb_fet_en_ack_b_f_or = |final_pgcb_fet_en_ack_b_f;

//
always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
   if (~prim_freerun_prim_gated_rst_b_sync) begin
      cfg_pmsm_pgcb_req_b_ctl_f <= '0;
   end else begin
      cfg_pmsm_pgcb_req_b_ctl_f <= cfg_pmsm_pgcb_req_b_ctl_nxt;
   end
end

assign hqm_clk_enable_int = gclock_enable_final & hqm_flr_clk_en;

hqm_ClockDomainController #(

         .DEF_PWRON     (HQM_PMU_DEF_PWRON)           // Default to a powered-off state after reset
        ,.ITBITS        (HQM_PMU_CDC_ITBITS)          // Idle Timer Bits.  Max is 16
        ,.RST           (HQM_PMU_CDC_RST)             // Number of resets.  Min is one.
        ,.AREQ          (HQM_PMU_CDC_AREQ)            // Number of async gclock requests.  Min is one.
        ,.DRIVE_POK     (HQM_PMU_CDC_DRIVE_POK)       // Determines whether this domain must drive POK
        ,.ISM_AGT_IS_NS (HQM_PMU_CDC_ISM_AGT_IS_NS)   // If 1, *_locked signals will be driven as the output of a flop
                                                      // If 0, *_locked signals will assert combinatorially
        ,.RSTR_B4_FORCE (HQM_PMU_CDC_RSTR_B4_FORCE)   // Determines if this CDC will require restore phase to complete
                                                      // in order to transition from IP-Accessible to IP-Inaccessible PG
        ,.PRESCC        (HQM_PMU_CDC_PRESCC)          // If 1, The master_clock gate logic with have clkgenctrl muxes for scan to have control
                                                      //       of the master_clock branch in order to be used preSCC
                                                      //       NOTE: FLOP_CG_EN and DSYNC_CG_EN are a dont care when PRESCC=1
        ,.DSYNC_CG_EN   (HQM_PMU_CDC_DSYNC_CG_EN)     // If 1, the master_clock-gate enable will be synchronized to the short master_clock-tree version
                                                      //       of master_clock to allow for STA convergence on fast clocks ( >120 MHz )
                                                      //       Note: FLOP_CG_EN is a don't care when DSYNC_CG_EN=1
        ,.FLOP_CG_EN    (HQM_PMU_CDC_FLOP_CG_EN)      // If 1, the clock-gate enable will be driven solely by the output of a flop
                                                      // If 0, there will be a combi path into the cg enable to allow for faster ungating
        ,.CG_LOCK_ISM   (HQM_PMU_CDC_CG_LOCK_ISM)     // if set to 1, ism_locked signal is asserted whenever gclock_active is low

) i_hqm_cdc (

        // PGCB ClockDomain
         .pgcb_clk                      (pgcb_clk)                                     //I: PGCB clock; always running
        ,.pgcb_rst_b                    (side_rst_b_sync)                              //I: Reset with de-assert synchronized to pgcb_clk

        // Master Clock Domain
        ,.clock                         (hqm_cdc_clk)                                  //I: Master clock
        ,.prescc_clock                  (1'b0)                                         //I: Tie to 0 if PRESCC param is 0
        ,.reset_b                       (hqm_rst_b)                                    //I: Asynchronous ungated reset.
        ,.reset_sync_b                  (reset_sync_b_nc )                             //O: Version of reset_b with de-assertion synchronized to clock
        ,.clkreq                        (hqm_proc_clkreq)                              //O: Async (glitch free) clock request to disable
        ,.clkack                        (hqm_proc_clkreq)                              //I: Async (glitch free) clock request acknowledge
        ,.pok_reset_b                   (1'b0)                                         //I: Asynchronous reset for POK
        ,.pok                           (pok_nc)                                       //O: Power ok indication, synchronous
        ,.gclock_enable_final           (gclock_enable_final)                          //O: Final enable signal to clock-gate
                                                                                       
        // Gated Clock Domain                                                          
        ,.gclock                        (gclock_nc)                                    //O: Gated version of the clock
        ,.greset_b                      (hqm_gated_rst_b )                             //O: Gated version of reset_sync_b
        ,.gclock_req_sync               (1'b0)                                         //I: Synchronous gclock request.
        ,.gclock_req_async              (gclock_req_async )                            //I: Async (glitch free) gclock requests
        ,.gclock_ack_async              (gclock_ack_async_nc )                         //O: Clock req ack for each gclock_req_async in this CDC's domain.
        ,.gclock_active                 (gclock_active_nc )                            //O: Indication that gclock is running.
        ,.ism_fabric                    (3'd0)                                         //I: IOSF Fabric ISM.  Tie to zero for non-IOSF domains.
        ,.ism_agent                     (3'd0)                                         //I: IOSF Agent ISM.  Tie to zero for non-IOSF domains.
        ,.ism_locked                    (ism_locked_nc )                               //O: Indicates that the ISMs for this domain should be locked
        ,.boundary_locked               (boundary_locked_nc)                           //O: Indicates that all non IOSF accesses should be locked out

        // Configuration 
        ,.cfg_clkgate_disabled          (cfg_hqm_cdc_ctl_sync.CLKGATE_DISABLED)        //I: Don't allow idle-based clock gating
        ,.cfg_clkreq_ctl_disabled       (cfg_hqm_cdc_ctl_sync.CLKREQ_CTL_DISABLED)     //I: Don't allow de-assertion of clkreq when idle
        ,.cfg_clkgate_holdoff           (cfg_hqm_cdc_ctl_sync.CLKGATE_HOLDOFF)         //I: Min time from idle to clock gating; 2^value in clocks
        ,.cfg_pwrgate_holdoff           (cfg_hqm_cdc_ctl_sync.PWRGATE_HOLDOFF)         //I: Min time from clock gate to power gate ready; 2^value in clocks
        ,.cfg_clkreq_off_holdoff        (cfg_hqm_cdc_ctl_sync.CLKREQ_OFF_HOLDOFF)      //I: Min time from locking to !clkreq; 2^value in clocks
        ,.cfg_clkreq_syncoff_holdoff    (cfg_hqm_cdc_ctl_sync.CLKREQ_SYNCOFF_HOLDOFF)  //I: Min time from ck gate to !clkreq (powerGateDisabled)

        // CDC Aggregateion and Control (synchronous to pgcb_clk domain)
        ,.pwrgate_disabled              (cfg_hqm_cdc_ctl_sync.PWRGATE_DISABLED)        //I: Don't allow idle-based clock gating; PGCB clock
        ,.pwrgate_force                 (pwrgate_force)                                //I: Force the controller to gate clocks and lock up
                                                                                       
        ,.pwrgate_pmc_wake              (master_ctl_pgcb_f.PWRGATE_PMC_WAKE)           //I: PMC wake signal (after sync); PGCB clock domain
        ,.pwrgate_ready                 (hqm_pwrgate_ready)                            //O: Allow power gating in the PGCB clock domain.  Can de-assert
                                                                                       //   even if never power gated if new wake event occurs.
        // PGCB Controls (synchronous to pgcb_clk domain)                              
        ,.pgcb_force_rst_b              (pgcb_force_rst_b)                             //I: Force for resets to assert
        ,.pgcb_pok                      (pgcb_hqm_pok)                                 //I: Power OK signal in the PGCB clock domain
        ,.pgcb_restore                  (pgcb_hqm_restore )                            //I: A restore is in pregress so  ISMs should unlock
        ,.pgcb_pwrgate_active           (pgcb_hqm_pwrgate_active)                      //I: Pwr gating in progress, so keep boundary locked
                                                                                       
        // Test Controls                                                               
        ,.fscan_clkungate               (fscan_clkungate)                              //I: Test clock ungating control
        ,.fscan_byprst_b                ({2{fscan_byprst_b}})                          //I: Scan reset bypass value
        ,.fscan_rstbypen                ({2{fscan_rstbypen}})                          //I: Scan reset bypass enable
        ,.fscan_clkgenctrlen            ('0)                                           //I: Scan clock bypass enable (unused)
        ,.fscan_clkgenctrl              ('0)                                           //I: Scan clock bypass value  (unused)
                                                                                       
        ,.fismdfx_force_clkreq          (cdc_hqm_jta_force_clkreq)                     //I: DFx force assert clkreq
        ,.fismdfx_clkgate_ovrd          (cdc_hqm_jta_clkgate_ovrd)                     //I: DFx force GATE gclock
                                                                                       
        // CDC VISA Signals                                                            
        ,.cdc_visa                      (hqm_cdc_visa)                                             //O: : Set of internal signals for VISA visibility unused
);

hqm_pm_flr_unit i_hqm_pm_flr_unit
(
         .hqm_freerun_clk                      (hqm_freerun_clk)
        ,.hqm_cdc_clk                          (hqm_cdc_clk)
        ,.prim_gated_rst_b                     (prim_gated_rst_b)
        ,.pgcb_force_rst_b                     (pgcb_force_rst_b)

        ,.prim_freerun_clk                     (prim_freerun_clk)
        ,.prim_freerun_prim_gated_rst_b_sync   (prim_freerun_prim_gated_rst_b_sync) 

        ,.fscan_rstbypen                       (fscan_rstbypen)
        ,.fscan_byprst_b                       (fscan_byprst_b)

        ,.hqm_rst_b                            (hqm_rst_b)
        ,.flr_clkreq_b                         (flr_clkreq_b)
        ,.hqm_pwrgood_rst_b                    (hqm_pwrgood_rst_b)
        ,.hqm_gated_local_override             (hqm_gated_local_override)

        ,.flr_triggered                        (flr_triggered)
        ,.pmsm_shields_up                      (pmsm_shields_up)

        ,.hqm_pm_unit_flr_req_edge             (hqm_pm_unit_flr_req_edge)

        ,.hqm_shields_up                       (hqm_shields_up)
        ,.hqm_flr_prep                         (hqm_flr_prep)
        ,.hqm_flr_clk_en                       (hqm_flr_clk_en)

        ,.flrsm_state                          (flrsm_state)
        ,.cfg_flr_count                        (cfg_flr_count)

        ,.pmsm_state_nxt                       (pmsm_state_nxt)
        ,.pmsm_state_f                         (pmsm_state_f)
        ,.cfg_pm_pmcsr_disable                 (cfg_pm_pmcsr_disable_f)
);

// generate signal for D3 in {COLD,HOT} state
// it is assumed that pm_state are in same power domain as hqm_pmsm logic no synchronization required
assign hqm_in_d3 = (pm_state==PM_FSM_D3COLD) | (pm_state==PM_FSM_D3HOT);

logic pgcb_fet_en_b_sync_prim, pgcb_fet_en_b_f;
logic pmc_pgcb_fet_en_b_sync_prim;
logic pmc_pgcb_pg_ack_b_in_sync_prim, pmc_pgcb_pg_ack_b_in_f ;
logic pgcb_pmc_pg_req_b_sync_prim, pgcb_pmc_pg_req_b_f ;

always_ff @(posedge pgcb_clk or negedge side_rst_b_sync) begin
  if (~side_rst_b_sync) begin
    pmc_pgcb_fet_en_b_f    <= 1'b1 ;
    pmc_pgcb_pg_ack_b_in_f <= 1'b0 ;
    pgcb_pmc_pg_req_b_f    <= 1'b1 ;
  end else begin
    pmc_pgcb_fet_en_b_f    <= pmc_pgcb_fet_en_b ;
    pmc_pgcb_pg_ack_b_in_f <= pmc_pgcb_pg_ack_b_in ;
    pgcb_pmc_pg_req_b_f    <= pgcb_pmc_pg_req_b ;
  end
end

hqm_AW_reset_sync_scan i_hqm_cdc_prim_gated_rst_b_sync (

         .clk               (pgcb_clk)
        ,.rst_n             (prim_gated_rst_b)
        ,.fscan_rstbypen    (fscan_rstbypen)
        ,.fscan_byprst_b    (fscan_byprst_b)
        ,.rst_n_sync        (pgcb_prim_gated_rst_b_sync)
);

always_ff @(posedge pgcb_clk or negedge pgcb_prim_gated_rst_b_sync) begin
  if (~pgcb_prim_gated_rst_b_sync) begin
    pgcb_fet_en_b_f        <= 1'b1 ; 
  end else begin
    pgcb_fet_en_b_f        <= pgcb_fet_en_b_pre;
  end
end

 
hqm_AW_sync i_pmc_pgcb_fet_en_b_sync_prim     (.clk (prim_freerun_clk)  ,.data (pmc_pgcb_fet_en_b_f)    ,.data_sync (pmc_pgcb_fet_en_b_sync_prim));
hqm_AW_sync i_pgcb_fet_en_b_sync_prim         (.clk (prim_freerun_clk)  ,.data (pgcb_fet_en_b_f)        ,.data_sync (pgcb_fet_en_b_sync_prim));
hqm_AW_sync i_pmc_pgcb_pg_ack_b_in_sync_prim  (.clk (prim_freerun_clk)  ,.data (pmc_pgcb_pg_ack_b_in_f) ,.data_sync (pmc_pgcb_pg_ack_b_in_sync_prim));
hqm_AW_sync i_pgcb_pmc_pg_req_b_sync_prim     (.clk (prim_freerun_clk)  ,.data (pgcb_pmc_pg_req_b_f)    ,.data_sync (pgcb_pmc_pg_req_b_sync_prim));


assign cfg_pm_status.PMSM                  = {3'd0,pmsm_state_f};            // pmsm current state
assign cfg_pm_status.reserved4             = '0;
assign cfg_pm_status.hqm_in_d3             = hqm_in_d3;                      // hqm in D3
assign cfg_pm_status.pm_fsm_d3tod0_ok      = pm_fsm_d3tod0_ok;               // PMSM signal that allows the hqm_ri_pm_fsm.sv state machied to move to D0.
assign cfg_pm_status.pm_fsm_d0tod3_ok      = pm_fsm_d0tod3_ok;               // PMSM signal that allows the hqm_ri_pm_fsm.sv state machied to move to D3.
assign cfg_pm_status.reserved3             = 1'b0;
assign cfg_pm_status.reserved2             = '0;
assign cfg_pm_status.FUSE_PROC_DISABLE	   = fuse_proc_disable;              // If FUSE_PROC_DISABLE == 1'b1, VCFN_HQM_PROC is forced OFF.
assign cfg_pm_status.FUSE_FORCE_ON         = fuse_force_on;                  // If FUSE_PROC_DISABLE == 1'b0,  FUSE_FORCE_ON keeps VCFN_HQM_PROC ON.
assign cfg_pm_status.reserved1             = '0;
assign cfg_pm_status.reserved0             = '0;
assign cfg_pm_status.pgcb_fet_en_b         = pgcb_fet_en_b_sync_prim;        // PGCB echoes the PMC's pmc_pgcb_fet_en_b signal.
assign cfg_pm_status.pmc_pgcb_fet_en_b	   = pmc_pgcb_fet_en_b_sync_prim;    // When 0, PMC is requesting to physically power-down the domain. When 1, power-up.
assign cfg_pm_status.pmc_pgcb_pg_ack_b	   = pmc_pgcb_pg_ack_b_in_sync_prim; // When matches pgbc_pmc_pg_req_b, the PMC has completed the request. 
assign cfg_pm_status.pgcb_pmc_pg_req_b     = pgcb_pmc_pg_req_b_sync_prim;    // When 0, PGCB requests the PMC to Powe-Off the domain. When 1, Power-On.
assign cfg_pm_status.PMSM_PGCB_REQ_B       = pmsm_pgcb_req_b;                // When 0, PSMS has requested a Power-Off. When 1, a Power-On.
assign cfg_pm_status.PGCB_HQM_PG_RDY_ACK_B = pgcb_hqm_pg_rdy_ack_b_f_sync;   // When matches PMSM_PGCB_REQ_B,  the PMSM request is complete
assign cfg_pm_status.PGCB_HQM_IDLE         = pgcb_hqm_idle_sync_prim;        // When 0, PGCB is not processing a power-gate request
assign cfg_pm_status.PROCHOT               = prochot_deglitch_sync;          // PROCHOT signal is asserted

// sync the cfg_hqm_cdc_ctl to pgcb_clk
hqm_AW_async_data #(
    .WIDTH ( $bits(cfg_hqm_cdc_ctl_t) )
   ,.RST_DEFAULT(HQM_MSTR_CFG_HQM_CDC_CONTROL_DEFAULT)
) i_cfg_hqm_cdc_ctl_sync (
    .src_clk             (prim_gated_clk)
   ,.src_rst_n           (prim_freerun_side_rst_b_sync)
   ,.dst_clk             (pgcb_clk)
   ,.dst_rst_n           (side_rst_b_sync)

   ,.data_v              (cfg_hqm_cdc_ctl_v)
   ,.data                (cfg_hqm_cdc_ctl)
   ,.data_f              (cfg_hqm_cdc_ctl_sync)

) ;

// sync the cfg_hqm_pgcb_ctl to pgcb_clk
hqm_AW_async_data #(
    .WIDTH ( $bits(cfg_hqm_pgcb_ctl_t) )
   ,.RST_DEFAULT(HQM_MSTR_CFG_HQM_PGCB_CONTROL_DEFAULT)
) i_cfg_hqm_pgcb_ctl_sync (
    .src_clk              (prim_gated_clk)
   ,.src_rst_n            (prim_freerun_side_rst_b_sync)
   ,.dst_clk              (pgcb_clk)
   ,.dst_rst_n            (side_rst_b_sync)

   ,.data_v               (cfg_hqm_pgcb_ctl_v)
   ,.data                 (cfg_hqm_pgcb_ctl)
   ,.data_f               (cfg_hqm_pgcb_ctl_sync)

) ;

//--------------------------------------------------------------------------------------------------
// Sync master_ctl_load to pgcb_clk domain
// load signal will be asserted coming out of reset
hqm_AW_sync_rst0  #(
   .WIDTH            ( 1 )
) i_master_ctl_load_sync_pgcb (
   .clk              ( pgcb_clk )
  ,.rst_n            ( side_rst_b_sync )
  ,.data             ( master_ctl_load )
  ,.data_sync        ( master_ctl_load_sync_pgcb )
);

assign master_ctl_pgcb_nxt.PWRGATE_PMC_WAKE        = ( master_ctl_load_sync_pgcb ) ? master_ctl.PWRGATE_PMC_WAKE        : master_ctl_pgcb_f.PWRGATE_PMC_WAKE;
assign master_ctl_pgcb_nxt.OVERRIDE_FET_EN_B       = ( master_ctl_load_sync_pgcb ) ? master_ctl.OVERRIDE_FET_EN_B       : master_ctl_pgcb_f.OVERRIDE_FET_EN_B;
assign master_ctl_pgcb_nxt.OVERRIDE_PMC_PGCB_ACK_B = ( master_ctl_load_sync_pgcb ) ? master_ctl.OVERRIDE_PMC_PGCB_ACK_B : master_ctl_pgcb_f.OVERRIDE_PMC_PGCB_ACK_B;

// Flop the SB master_ctl data in pgcb_clk domain
always_ff @(posedge pgcb_clk or negedge side_rst_b_sync) begin
  if (~side_rst_b_sync) begin
    master_ctl_pgcb_f     <= '0 ;  
  end else begin
    master_ctl_pgcb_f     <= master_ctl_pgcb_nxt ;
  end
end

//--------------------------------------------------------------------------------------------------
// Sync master_ctl_load to prim_clk domain
// load signal will be asserted coming out of reset
hqm_AW_sync_rst0  #(
   .WIDTH            ( 1 )
) i_master_ctl_load_sync_prim (
   .clk              ( prim_freerun_clk )
  ,.rst_n            ( prim_freerun_side_rst_b_sync )
  ,.data             ( master_ctl_load )
  ,.data_sync        ( master_ctl_load_sync_prim )
);

assign master_ctl_prim_nxt = ( master_ctl_load_sync_prim ) ? master_ctl : master_ctl_prim_f ;

// Flop the SB master_ctl data in prim_clk domain
always_ff @(posedge prim_freerun_clk or negedge prim_freerun_side_rst_b_sync) begin
  if (~prim_freerun_side_rst_b_sync) begin
    master_ctl_prim_f     <= '0 ; 
  end else begin
    master_ctl_prim_f     <= master_ctl_prim_nxt;
  end
end

assign master_ctl_prim_f_pnc = ( | master_ctl_prim_f ) ;
//--------------------------------------------------------------------------------------------------


// delay final_pgcb_fet_en_ack_b on the input to account for gcb_isol_en_b delay to isolation cells
always_ff @(posedge pgcb_clk or negedge side_rst_b_sync) begin
    if (~side_rst_b_sync) begin
      pmc_pgcb_pg_ack_b_in_delay0_f <= 1'b1;
      pmc_pgcb_pg_ack_b_in_delay1_f <= 1'b1;
    end else begin
      pmc_pgcb_pg_ack_b_in_delay0_f <= pmc_pgcb_pg_ack_b_in;
      pmc_pgcb_pg_ack_b_in_delay1_f <= pmc_pgcb_pg_ack_b_in_delay0_f;
    end
end

// pgcb_pm_gre_req_b will be turned back around and sent back as pmc_pgcb_fet_en_b into pgcbunit 
// master controls are here for survivability control
assign pmc_pgcb_fet_en_b = ~(master_ctl_pgcb_f.OVERRIDE_FET_EN_B[0] ? master_ctl_pgcb_f.OVERRIDE_FET_EN_B[1] : pgcb_pmc_pg_req_b);

// final_pgcb_fet_en_ack_b is used to generate the pmc_pgcb_ack_b to pgcbunit.
// master control is here for survivability control 
hqm_AW_sync_rst1 #(.WIDTH(1)) i_pgcb_fet_en_ack_b_sync      (.clk (pgcb_clk)          ,.rst_n (side_rst_b_sync) ,.data (pgcb_fet_en_ack_b)      ,.data_sync (pgcb_fet_en_ack_b_sync));

assign final_pgcb_fet_en_ack_b = pgcb_fet_en_b_pre ? (final_pgcb_fet_en_ack_b_f_and & pgcb_fet_en_ack_b_sync ) : (final_pgcb_fet_en_ack_b_f_or | pgcb_fet_en_ack_b_sync );

assign pmc_pgcb_pg_ack_b_in = ~(master_ctl_pgcb_f.OVERRIDE_PMC_PGCB_ACK_B[0] ? master_ctl_pgcb_f.OVERRIDE_PMC_PGCB_ACK_B[1] : final_pgcb_fet_en_ack_b);
assign pmc_pgcb_pg_ack_b = pmc_pgcb_pg_ack_b_in & pmc_pgcb_pg_ack_b_in_delay1_f; 

// to support surviability the cfg_pm_override and cfg_pm_pmcsr_disable are going to be
// controlled via the master_ctl register
always_comb begin

        cfg_pm_override_ctl = cfg_pm_override_f.OVERRIDE;
        cfg_pm_pmcsr_disable_ctl = cfg_pm_pmcsr_disable_f.DISABLE;

        if ( master_ctl_prim_f.OVERRIDE_PM_CFG_CONTROL[0] ) begin
          cfg_pm_pmcsr_disable_ctl = master_ctl_prim_f.OVERRIDE_PM_CFG_CONTROL[2];
          cfg_pm_override_ctl = master_ctl_prim_f.OVERRIDE_PM_CFG_CONTROL[1];
        end

        cfg_pmsm_pgcb_req_b_ctl_nxt = pmsm_pgcb_req_b ;

        if ( master_ctl_prim_f.OVERRIDE_PMSM_PGCB_REQ_B[0] ) begin
          cfg_pmsm_pgcb_req_b_ctl_nxt = master_ctl_prim_f.OVERRIDE_PMSM_PGCB_REQ_B[1];
        end

end

// hqm_clk_ungate is synced in hqm_clk_throttle_unit and is passed directly to
// the partition wrappers to ungate hqm_clk RCBs
assign hqm_clk_ungate_nxt = ( cfg_hqm_cdc_ctl.CLKGATE_DISABLED | master_ctl_prim_f.OVERRIDE_CLK_GATE ) ;

always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync) begin
   if (~prim_freerun_prim_gated_rst_b_sync) begin
      hqm_clk_ungate_f <= '0;
   end else begin
      hqm_clk_ungate_f <= hqm_clk_ungate_nxt;
   end
end

assign hqm_clk_ungate_presync = hqm_clk_ungate_f ;

logic [9:0] hqm_triggers_prestretch;
logic [9:0] vec_iosf, vec_pm_unit_0, vec_pm_unit_1;
logic [9:0] vec_iosf_f, vec_pm_unit_0_f, vec_pm_unit_1_f;
logic [9:0] vec_iosf_sync, vec_pm_unit_0_sync, vec_pm_unit_1_sync;
logic [9:0] vec_iosf_sync_masked, vec_pm_unit_0_sync_masked, vec_pm_unit_1_sync_masked;

//----------------------------------------------------------------------------------------------------------------
// TRIGGERS
// 3 10b vectors are masked by an RTDR register and combined to present a single 10b triggers vector
// Vector is synchonized to aon_clk, reset by synchronized side_rst_b
//--------------------------------------------------------------------------------------------------

always_ff @(posedge aon_clk or negedge side_rst_b_aon_sync ) begin
    if (~side_rst_b_aon_sync ) begin
      fscan_trigger_mask_v_prev_f       <= '0 ;
      fscan_trigger_mask_aon_f          <= '0 ;
    end else begin
      fscan_trigger_mask_v_prev_f       <= fscan_trigger_mask_v_sync_f ;
      fscan_trigger_mask_aon_f          <= fscan_trigger_mask_aon_nxt ;
    end
end

assign fscan_trigger_mask_load          = fscan_trigger_mask_v_sync_f & ~ fscan_trigger_mask_v_prev_f ;

always_comb begin
  fscan_trigger_mask_aon_nxt            = fscan_trigger_mask_aon_f ;
  if ( fscan_trigger_mask_load ) begin
    fscan_trigger_mask_aon_nxt          = fscan_trigger_mask ;
  end
end // always

//--------------------------------------------------------------------------------------------------
 
hqm_AW_sync #(
  .WIDTH     ( 10 )
) i_vec_pm_unit_1_aon_sync (
  .clk       ( aon_clk )
 ,.data      ( vec_pm_unit_1_f )
 ,.data_sync ( vec_pm_unit_1_sync )
);

hqm_AW_sync #(
  .WIDTH     ( 10 )
) i_vec_pm_unit_0_aon_sync (
  .clk       ( aon_clk )
 ,.data      ( vec_pm_unit_0_f )
 ,.data_sync ( vec_pm_unit_0_sync )
);

hqm_AW_sync #(
  .WIDTH     ( 10 )
) i_vec_iosf_aon_sync (
  .clk       ( aon_clk )
 ,.data      ( vec_iosf_f )
 ,.data_sync ( vec_iosf_sync )
);
 
hqm_AW_sync_rst0 #(
  .WIDTH     ( 1 )
) i_fscan_trigger_mask_v_sync (
  .clk       ( aon_clk )
 ,.rst_n     ( side_rst_b_aon_sync ) 
 ,.data      ( fscan_trigger_mask_v )
 ,.data_sync ( fscan_trigger_mask_v_sync_f )
);

always_comb begin

   vec_pm_unit_1[9:7] = '0;                       // prim_freerun_clk  
   vec_pm_unit_1[6:3] = pmsm_state_f[3:0];        // prim_freerun_clk only 4 bits 
   vec_pm_unit_1[2]   = hqm_in_d3;                // prim_freerun_clk
   vec_pm_unit_1[1]   = prochot_deglitch_sync;    // prim_freerun_clk 
   vec_pm_unit_1[0]   = pmsm_shields_up;          // prim_freerun_clk
  
   vec_pm_unit_0[9:6] = '0;                        
   vec_pm_unit_0[5]   = pmc_pgcb_pg_ack_b;        // hqm_pgcb_clk 
   vec_pm_unit_0[4]   = pgcb_hqm_pok;             // hqm_pgcb_clk PGCB pok
   vec_pm_unit_0[3]   = pgcb_force_rst_b;         // hqm_pgcb_clk PGCB/CDC reset
   vec_pm_unit_0[2]   = pgcb_hqm_pwrgate_active;  // hqm_pgcb_clk PGCB/CDC 
   vec_pm_unit_0[1]   = pgcb_fet_en_b_pre;        // hqm_pgcb_clk PGCB/FET ctl
   vec_pm_unit_0[0]   = pmc_pgcb_fet_en_b_f ;     // hqm_pgcb_clk PGCB/FET status
  
   vec_iosf[9]        =  hqm_triggers_in[9] ; 
   vec_iosf[8]        = (hqm_triggers_in[8] & ~hqm_shields_up);
   vec_iosf[7]        = (hqm_triggers_in[7] & ~hqm_shields_up);
   vec_iosf[6:0]      =  hqm_triggers_in[6:0] ;

   vec_iosf_mask      = fscan_trigger_mask_aon_f[9:0];
   vec_pm_unit_0_mask = fscan_trigger_mask_aon_f[19:10];
   vec_pm_unit_1_mask = fscan_trigger_mask_aon_f[29:20];

   vec_iosf_sync_masked      = vec_iosf_sync      & vec_iosf_mask ;
   vec_pm_unit_0_sync_masked = vec_pm_unit_0_sync & vec_pm_unit_0_mask ;
   vec_pm_unit_1_sync_masked = vec_pm_unit_1_sync & vec_pm_unit_1_mask ;

   hqm_triggers_prestretch   = vec_iosf_sync_masked | vec_pm_unit_0_sync_masked | vec_pm_unit_1_sync_masked ;
   
   end

always_ff @(posedge pgcb_clk or negedge side_rst_b_sync) begin
    if (~side_rst_b_sync) begin
      vec_pm_unit_0_f[9:2] <= '0 ;
      vec_pm_unit_0_f[0] <= '0 ;
    end else begin
      vec_pm_unit_0_f[9:2] <= vec_pm_unit_0[9:2];
      vec_pm_unit_0_f[0] <= vec_pm_unit_0[0];
    end
end

always_ff @(posedge pgcb_clk or negedge pgcb_prim_gated_rst_b_sync) begin
    if (~pgcb_prim_gated_rst_b_sync) begin
      vec_pm_unit_0_f[1] <= '0 ;
    end else begin
      vec_pm_unit_0_f[1] <= vec_pm_unit_0[1];
    end
end

always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync ) begin
    if (~prim_freerun_prim_gated_rst_b_sync) begin
      vec_iosf_f      <= '0 ;
      vec_pm_unit_1_f <= '0;
      cfg_pm_pmcsr_disable_f <= HQM_MSTR_CFG_PM_PMCSR_DISABLE_DEFAULT;
      cfg_pm_override_f <= HQM_MSTR_CFG_PM_OVERRIDE_DEFAULT;
    end else begin
      vec_iosf_f      <= vec_iosf;
      vec_pm_unit_1_f <= vec_pm_unit_1;
      cfg_pm_pmcsr_disable_f <= cfg_pm_pmcsr_disable;
      cfg_pm_override_f <= cfg_pm_override;
    end
end 

hqm_AW_pulse_stretch #(
     .WIDTH           ( 10 )
    ,.PULSE_WIDTH     ( HQM_TRIGGER_WIDTH )
) i_trigger_stretch   (
     .clk             ( aon_clk)
    ,.rst_n           ( side_rst_b_aon_sync)
    ,.din             ( hqm_triggers_prestretch)

    ,.dout            ( hqm_triggers)
);
//----------------------------------------------------------------------------------------------------------------
// visa 
pmsm_visa_t hqm_pmsm_visa_f , hqm_pmsm_visa_nxt;
always_ff @(posedge prim_freerun_clk or negedge prim_freerun_prim_gated_rst_b_sync ) begin
    if (~prim_freerun_prim_gated_rst_b_sync) begin
      hqm_pmsm_visa_f <= '0 ;
    end else begin
      hqm_pmsm_visa_f <= hqm_pmsm_visa_nxt ;
    end
end
always_comb begin

 pmsm_visa_nc = |{pmsm_visa_noapb.pwrite
                 ,pmsm_visa_noapb.penable
                 ,pmsm_visa_noapb.paddr_31_28
                 ,pmsm_visa_noapb.pready
                 ,pmsm_visa_noapb.prdata_2_0} ;

 hqm_pmsm_visa_nxt             = pmsm_visa_noapb ;
 hqm_pmsm_visa_nxt.penable     = penable ;
 hqm_pmsm_visa_nxt.pwrite      = pwrite ;
 hqm_pmsm_visa_nxt.paddr_31_28 = paddr_31_28 ;
 hqm_pmsm_visa_nxt.pready      = pready ;
 hqm_pmsm_visa_nxt.prdata_2_0  = prdata_2_0 ;

 hqm_pmsm_visa_nxt.cfg_pm_status_PGCB_HQM_IDLE         = cfg_pm_status.PGCB_HQM_IDLE ;
 hqm_pmsm_visa_nxt.cfg_pm_status_PGCB_HQM_PG_RDY_ACK_B = cfg_pm_status.PGCB_HQM_PG_RDY_ACK_B ;
 hqm_pmsm_visa_nxt.cfg_pm_status_PMSM_PGCB_REQ_B       = cfg_pm_status.PMSM_PGCB_REQ_B ;
 hqm_pmsm_visa_nxt.cfg_pm_status_pgcb_pmc_pg_req_b     = cfg_pm_status.pgcb_pmc_pg_req_b ;
 hqm_pmsm_visa_nxt.cfg_pm_status_pmc_pgcb_pg_ack_b     = cfg_pm_status.pmc_pgcb_pg_ack_b ;
 hqm_pmsm_visa_nxt.cfg_pm_status_pmc_pgcb_fet_en_b     = cfg_pm_status.pmc_pgcb_fet_en_b ;
 hqm_pmsm_visa_nxt.cfg_pm_status_pgcb_fet_en_b         = cfg_pm_status.pgcb_fet_en_b ;
 hqm_pmsm_visa_nxt.spare                               = 1'b0 ;

  hqm_pmsm_visa = hqm_pmsm_visa_f ;
end

// fscan mux on pgcb_fet_en_b
      hqm_pgcb_ctech_mux_2to1_gen hqm_pm_unit_ctech_mux_fet_en_scan (
         .d1(fscan_fet_on),
         .d2(pgcb_fet_en_b_out),
         .s(fscan_fet_en_sel),
         .o(pgcb_fet_en_b_pre)
      );

assign pgcb_fet_en_b = pgcb_fet_en_b_pre;

endmodule // hqm_pm_unit
