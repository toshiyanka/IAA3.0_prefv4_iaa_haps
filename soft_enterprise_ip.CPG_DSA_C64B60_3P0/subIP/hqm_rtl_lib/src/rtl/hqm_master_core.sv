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
// hqm_master_core
//
// This module is the wrapper for the hqm core config and status aggregator logic.
//
//-----------------------------------------------------------------------------------------------------

module hqm_master_core

    import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
   parameter HQM_TRIGGER_WIDTH = 3
) (
  // CLK
      input logic                                      prim_gated_clk                   // I: par_hqm_system 
    , input logic                                      prim_clk_enable                  // I: 
    , input logic                                      hqm_fullrate_clk                 // I: PM FLR Unit only
    , input logic                                      hqm_freerun_clk                  // I: PM FLR Unit only
                                                                                        
    , output logic                                     hqm_clk_ungate                   // O: Proc Pars
    , output logic                                     hqm_clk_enable                   // O: Proc Pars 
    , output logic                                     hqm_clk_throttle                 // O: Master Aon Only
    , output logic                                     hqm_gclock_enable                // O: Master Aon Only 

    , input  logic                                     hqm_cdc_clk                      // I:  
    , input  logic                                     hqm_inp_gated_clk                // I: par_hqm_system 
                                                                                        
    , input  logic                                     prim_freerun_clk                 // I: par_hqm_system 
                                                                                        
    , input  logic                                     aon_clk                          // I:  
    , input  logic                                     pgcb_clk                         // I:  

    , input  logic                                     wd_clkreq                        // I: CHP
    , output logic                                     hqm_proc_clkreq_b                // O: IOSF                                                                                       
                                                                                        
    , input  logic                                     pm_ip_clk_halt_b_2_rpt_0_iosf    // I: 1st rptr stage (from IOSF)                                                                          
  // RST                                                                                
    , input  logic                                     side_rst_b                       // I: SAPMA
    , input  logic                                     prim_gated_rst_b                 // I: IOSF (i_prim_cdc)
                                                                                        
    , output logic                                     hqm_gated_rst_b                  // O: proc partitions, use in hqm_proc_master  
    , output logic                                     hqm_clk_rptr_rst_b               // O: proc partitions, use in hqm_proc_master  
                                                                                        
  // PM_UNIT INTF                                                                       
    , input  logic                                     flr_triggered                    // I: IOSF
    , output logic                                     hqm_shields_up                   // O: IOSF 
    , output logic                                     hqm_flr_prep                     // O: proc pars   
    , output logic                                     hqm_pwrgood_rst_b                // O: proc pars   
    , output logic                                     hqm_gated_local_override         // O: proc pars   
                                                                                        
    , input  logic                                     prochot                          // I: PKG PIN,FIVR wired-or 
                                                                                        
    , input  pm_fsm_t                                  pm_state                         // I: IOSF 
    , input  logic                                     master_ctl_load                  // I: IOSF
    , input  master_ctl_reg_t                          master_ctl                       // I: IOSF
    , output logic                                     pm_fsm_d0tod3_ok                 // O: IOSF
    , output logic                                     pm_fsm_d3tod0_ok                 // O: IOSF
    , output logic                                     pm_fsm_in_run                    // O: IOSF
    , output logic                                     pm_allow_ing_drop                // O: IOSF
                                                                                        
    , output logic                                     pgcb_isol_en_b                   // O: isolation ctl active low
    , output logic                                     pgcb_isol_en                     // O: isolation ctl acitve high
                                                                                        
    // FET INTF                                                                        
    , output logic                                     pgcb_fet_en_b                    // O: FET daisy-chain
    , input  logic                                     pgcb_fet_en_ack_b                // I: FET daisy-chain

    // FUSE INTF                                                                        
    , input  logic                                     fuse_force_on                    // I: source is side_clk
    , input  logic                                     fuse_proc_disable                // I: source is side_clk
                                                                                        
    // CHP INTF                                                                         
    , output logic [ ( 16 ) - 1 : 0]                   master_chp_timestamp             // O: par_hqm_credit_hist_pipe 
                                                                                        
    // APB INTF (FROM IOSF)                                                             
    , input  logic    [( 20 )-1:0]                     puser                            // I: APB - IOSF
    , input  logic                                     psel                             // I: APB - IOSF
    , input  logic                                     pwrite                           // I: APB - IOSF
    , input  logic                                     penable                          // I: APB - IOSF
    , input  logic    [( 32 )-1:0]                     paddr                            // I: APB - IOSF
    , input  logic    [( 32 )-1:0]                     pwdata                           // I: APB - IOSF
                                                                                        
    , output logic                                     pready                           // O: APB - IOSF
    , output logic                                     pslverr                          // O: APB - IOSF
    , output logic   [( 32 )-1:0]                      prdata                           // O: APB - IOSF
    , output logic                                     prdata_par                       // O: APB - IOSF
                                                                                        
    // CFG RING INTF                                                                    
    , output logic                                     mstr_cfg_req_down_write          // O: hqm_system
    , output logic                                     mstr_cfg_req_down_read           // O: hqm_system
    , output logic [BITS_CFG_REQ_T-1:0]                mstr_cfg_req_down                // O: hqm_system
                                                                                        
    , input  logic                                     mstr_cfg_rsp_up_ack              // I: par_hqm_aqed_pipe
    , input  logic [BITS_CFG_RSP_T-1:0]                mstr_cfg_rsp_up                  // I: par_hqm_aqed_pipe
                                                                                        
    , input  logic                                     mstr_cfg_req_up_write            // I: par_hqm_aqed_pipe
    , input  logic                                     mstr_cfg_req_up_read             // I: par_hqm_aqed_pipe
    , input  logic [BITS_CFG_REQ_T-1:0]                mstr_cfg_req_up                  // I: par_hqm_aqed_pipe
                                                                                        
    // STATUS INTF                                                                      
    , input  logic [BITS_HQM_MSTR_RESET_DONE_T-1:0]    mstr_hqm_reset_done              // I: proc pars   **INCLUDES SYSTEM**
    , input  logic [BITS_HQM_MSTR_UNIT_IDLE_T-1:0]     mstr_unit_idle                   // I: proc pars 
    , input  logic [BITS_HQM_MSTR_UNIT_PIPEIDLE_T-1:0] mstr_unit_pipeidle               // I: proc pars
    , input  logic [BITS_HQM_MSTR_LCB_ENABLE_T-1:0]    mstr_lcb_enable                  // I: proc pars
                                                                                    
    , output logic                                     hqm_proc_reset_done_sync_hqm     // O: CHP & SYS Partitions 
    , output logic                                     hqm_proc_reset_done              // O: IOSF - Done indication of MASTER & hqm_proc PARs 

    // TRIGGER INTF
    , input  logic   [ (10 ) - 1 : 0 ]                 hqm_triggers_in                  // I: IOSF
    , output logic   [ (10 ) - 1 : 0 ]                 hqm_triggers                     // O:
 
    // VISA INTF
    , output logic                                     visa_str_hqm_proc_idle           // O: VISA
    , output logic                                     visa_str_hqm_proc_pipeidle       // O: VISA
    , output logic                                     visa_str_prim_clk_enable         // O: VISA
    , output logic                                     visa_str_hqm_clk_enable          // O: VISA
    , output logic                                     visa_str_hqm_clk_throttle        // O: VISA
    , output logic                                     visa_str_hqm_gclock_enable       // O: VISA
    , output logic                                     visa_str_hqm_cdc_clk_enable      // O: VISA
    , output logic                                     visa_str_hqm_gated_local_override // O: VISA
    , output logic                                     visa_str_hqm_flr_prep            // O: VISA
    , output logic                                     visa_str_pm_ip_clk_halt_b_2_rpt_0_iosf // O: VISA

    // DFX INTF
    , input  logic                                     pgcb_tck                         // I: DFX clock

    , input  logic                                     fdfx_powergood                   // I: 
    , input  logic                                     fdfx_pgcb_bypass                 // I: 
    , input  logic                                     fdfx_pgcb_ovr                    // I: 

    , input  logic                                     fscan_ret_ctrl                   // I: 
    , input  logic                                     fscan_isol_ctrl                  // I: 
    , input  logic                                     fscan_isol_lat_ctrl              // I: 
    , input  logic                                     fscan_clkungate                  // I: 
    , input  logic                                     fscan_rstbypen                   // I:   
    , input  logic                                     fscan_byprst_b                   // I:    
    , input  logic                                     fscan_mode                       // I: dfx for hqm_clk_switch logic
    , input  logic                                     fscan_fet_on                     // I: dfx
    , input  logic                                     fscan_fet_en_sel                 // I: 
    , input  logic                                     fscan_trigger_mask_v             // I: dfx mask valid for trigger mask
    , input  logic   [ ( 30 ) - 1 : 0 ]                fscan_trigger_mask               // I: dfx mask for trigger logic
                                                                                       
    , input  logic                                     cdc_hqm_jta_force_clkreq         // I:
    , input  logic                                     cdc_hqm_jta_clkgate_ovrd         // I:

    , output logic                                     hqm_cdc_clk_enable               // O:

    , input  logic                                     hw_reset_force_pwr_on            // I:
//-----------------------------------------------------------------------------------
    , output logic                                     pgcb_hqm_pwrgate_active          // O: viewpin
    , output logic                                     final_pgcb_fet_en_ack_b          // O: viewpin
    , output logic                                     pgcb_fet_en_b_out                // O: viewpin
    , output logic                                     pgcb_force_rst_b                 // O: viewpin
    , output logic                                     pm_fsm_active                    // O: viewpin

    , output logic [23:0]                              hqm_cdc_visa
    , output logic [23:0]                              hqm_pgcbunit_visa
    , output logic [31:0]                              hqm_pmsm_visa

    , output logic                                     hqm_cfg_master_clkreq_b          // O: visa related

);

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------

logic                          cfg_req_down_write ;
logic                          cfg_req_down_read ;
cfg_req_t                      cfg_req_down ;

logic                          cfg_rsp_up_ack ;
cfg_rsp_t                      cfg_rsp_up ;
 
logic                          cfg_req_up_write ;
logic                          cfg_req_up_read ;
cfg_req_t                      cfg_req_up ;

cfg_hqm_cdc_ctl_t              cfg_hqm_cdc_ctl ;
cfg_hqm_pgcb_ctl_t             cfg_hqm_pgcb_ctl ;
cfg_pm_override_t              cfg_pm_override ;
cfg_pm_pmcsr_disable_t         cfg_pm_pmcsr_disable;
cfg_pm_status_t                cfg_pm_status ;

logic                          cfg_hqm_cdc_ctl_v;
logic                          cfg_hqm_pgcb_ctl_v;
logic                          cfg_d3tod0_event_cnt_inc ; 

mstr_proc_reset_status_t       mstr_proc_reset_status ;
mstr_proc_idle_status_t        mstr_proc_idle_status ;
mstr_proc_lcb_status_t         mstr_proc_lcb_status ;
logic [63:0]                   cfg_flr_count ; 

logic                          cfg_prochot_disable;

logic                          prochot_deglitch_sync;
logic                          hqm_proc_master_unit_idle;
logic                          hqm_proc_master_reset_done;

logic                          hqm_clk_enable_int;
logic                          gclock_enable_final;
logic                          hqm_clk_ungate_presync;
logic                          flr_clkreq_b;
flrsm_t                        flrsm_state;
//-----------------------------------------------------------------------------------
// VISA ASSIGN
assign visa_str_hqm_clk_enable = hqm_clk_enable ;
assign visa_str_hqm_clk_throttle = hqm_clk_throttle ;
assign visa_str_hqm_gclock_enable = hqm_gclock_enable ;
assign visa_str_hqm_cdc_clk_enable = hqm_cdc_clk_enable ;
assign visa_str_hqm_gated_local_override = hqm_gated_local_override ; 
assign visa_str_hqm_flr_prep =  hqm_flr_prep ;

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
hqm_clk_throttle_unit i_hqm_clk_throttle_unit
(
     .hqm_cdc_clk                   ( hqm_cdc_clk )
    ,.hqm_fullrate_clk              ( hqm_fullrate_clk )
    ,.hqm_clk_enable_int            ( hqm_clk_enable_int )
    ,.gclock_enable_final           ( gclock_enable_final )

    ,.pgcb_force_rst_b              ( pgcb_force_rst_b )

    ,.pm_ip_clk_halt_b_2_rpt_0_iosf ( pm_ip_clk_halt_b_2_rpt_0_iosf )

    ,.prim_clk_enable               ( prim_clk_enable )
    ,.cfg_prochot_disable           ( cfg_prochot_disable )
    ,.prochot                       ( prochot )

    ,.side_rst_b                    ( side_rst_b )
    ,.master_ctl_load               ( master_ctl_load )
    ,.master_ctl                    ( master_ctl )

    ,.fscan_rstbypen                ( fscan_rstbypen )
    ,.fscan_byprst_b                ( fscan_byprst_b )

    ,.hqm_clk_ungate_presync        ( hqm_clk_ungate_presync )
    ,.hqm_clk_ungate                ( hqm_clk_ungate )

    ,.hqm_clk_rptr_rst_b            ( hqm_clk_rptr_rst_b )
    ,.hqm_clk_enable                ( hqm_clk_enable )
    ,.hqm_gclock_enable             ( hqm_gclock_enable )
    ,.hqm_clk_throttle              ( hqm_clk_throttle )
    ,.visa_str_prim_clk_enable_sync ( visa_str_prim_clk_enable )
    ,.visa_str_pm_ip_clk_halt_b_2_rpt_0_iosf_sync ( visa_str_pm_ip_clk_halt_b_2_rpt_0_iosf )
) ;



hqm_cfg_master i_hqm_cfg_master
(
     .prim_gated_clk                ( prim_gated_clk )
    ,.prim_freerun_clk              ( prim_freerun_clk )
    ,.prim_gated_rst_b              ( prim_gated_rst_b )

    ,.pgcb_clk                      ( pgcb_clk )
    ,.wd_clkreq                     ( wd_clkreq )
    ,.hqm_proc_clkreq_b             ( hqm_proc_clkreq_b )
    ,.hqm_cfg_master_clkreq_b       ( hqm_cfg_master_clkreq_b )

    ,.hqm_cdc_clk                   ( hqm_cdc_clk )  // Heartbeat ONLY
    ,.hqm_inp_gated_clk             ( hqm_inp_gated_clk )
    ,.hqm_gated_rst_b               ( hqm_gated_rst_b ) 

    ,.pgcb_force_rst_b              ( pgcb_force_rst_b )

    ,.cfg_prochot_disable           ( cfg_prochot_disable )

    ,.prochot                       ( prochot )
    ,.prochot_deglitch_sync         ( prochot_deglitch_sync )

    ,.flr_triggered                 ( flr_triggered ) 

    ,.hqm_shields_up                ( hqm_shields_up )
    ,.hqm_flr_prep                  ( hqm_flr_prep )

    ,.master_chp_timestamp          ( master_chp_timestamp )

    ,.cfg_hqm_cdc_ctl               ( cfg_hqm_cdc_ctl )
    ,.cfg_hqm_cdc_ctl_v             ( cfg_hqm_cdc_ctl_v )
    ,.cfg_hqm_pgcb_ctl              ( cfg_hqm_pgcb_ctl )
    ,.cfg_hqm_pgcb_ctl_v            ( cfg_hqm_pgcb_ctl_v )
    ,.cfg_pm_override               ( cfg_pm_override )
    ,.cfg_pm_pmcsr_disable          ( cfg_pm_pmcsr_disable )

    ,.cfg_pm_status                 ( cfg_pm_status ) 
    ,.cfg_d3tod0_event_cnt_inc      ( cfg_d3tod0_event_cnt_inc )
    ,.pm_fsm_in_run                 ( pm_fsm_in_run )  
    ,.pm_allow_ing_drop             ( pm_allow_ing_drop )

    // HQM_IOSF APB I/O
    ,.puser                         ( puser )
    ,.psel                          ( psel ) 
    ,.pwrite                        ( pwrite )
    ,.penable                       ( penable )
    ,.paddr                         ( paddr )
    ,.pwdata                        ( pwdata )

    ,.pready                        ( pready )
    ,.pslverr                       ( pslverr )
    ,.prdata                        ( prdata )
    ,.prdata_par                    ( prdata_par )

    //  PROC_MASTER <> CFG_MASTER CONNECTIONS
    ,.cfg_req_down_write            ( cfg_req_down_write )
    ,.cfg_req_down_read             ( cfg_req_down_read )
    ,.cfg_req_down                  ( cfg_req_down )

    ,.cfg_rsp_up_ack                ( cfg_rsp_up_ack  )
    ,.cfg_rsp_up                    ( cfg_rsp_up )

    ,.cfg_req_up_write              ( cfg_req_up_write )
    ,.cfg_req_up_read               ( cfg_req_up_read  )
    ,.cfg_req_up                    ( cfg_req_up )

    ,.flr_clkreq_b                  ( flr_clkreq_b )
    ,.flrsm_state                   ( flrsm_state )

    ,.hqm_proc_master_unit_idle     ( hqm_proc_master_unit_idle )
    ,.hqm_proc_master_reset_done    ( hqm_proc_master_reset_done )
    ,.hqm_proc_reset_done           ( hqm_proc_reset_done )
    ,.hqm_proc_reset_done_sync_hqm  ( hqm_proc_reset_done_sync_hqm )
 
    ,.mstr_proc_reset_status        ( mstr_proc_reset_status )
    ,.mstr_proc_idle_status         ( mstr_proc_idle_status )
    ,.mstr_proc_lcb_status          ( mstr_proc_lcb_status )
    ,.cfg_flr_count                 ( cfg_flr_count )

    ,.visa_str_hqm_proc_idle        ( visa_str_hqm_proc_idle )

    ,.fscan_rstbypen                ( fscan_rstbypen )
    ,.fscan_byprst_b                ( fscan_byprst_b )
    ,.pm_fsm_active                 (pm_fsm_active)

);

hqm_proc_master i_hqm_proc_master
(
     .hqm_inp_gated_clk             ( hqm_inp_gated_clk )
    ,.hqm_cdc_clk                   ( hqm_cdc_clk )
    ,.hqm_gated_rst_b               ( hqm_gated_rst_b )

    ,.prim_gated_clk                ( prim_gated_clk )   // For clk-crossings
    ,.prim_freerun_clk              ( prim_freerun_clk ) // For clk-crossings
    ,.prim_gated_rst_b              ( prim_gated_rst_b ) // For clk-crossings

    ,.hqm_flr_prep                  ( hqm_flr_prep )
    ,.hqm_shields_up                ( hqm_shields_up )

    // HQM_PROC CFG I/O
    ,.mstr_cfg_req_down_write       ( mstr_cfg_req_down_write )
    ,.mstr_cfg_req_down_read        ( mstr_cfg_req_down_read )
    ,.mstr_cfg_req_down             ( mstr_cfg_req_down )

    ,.mstr_cfg_rsp_up_ack           ( mstr_cfg_rsp_up_ack  )
    ,.mstr_cfg_rsp_up               ( mstr_cfg_rsp_up )

    ,.mstr_cfg_req_up_write         ( mstr_cfg_req_up_write )
    ,.mstr_cfg_req_up_read          ( mstr_cfg_req_up_read  )
    ,.mstr_cfg_req_up               ( mstr_cfg_req_up ) 

    //  PROC_MASTER <> CFG_MASTER CONNECTIONS
    ,.cfg_req_down_write            ( cfg_req_down_write )
    ,.cfg_req_down_read             ( cfg_req_down_read )
    ,.cfg_req_down                  ( cfg_req_down )

    ,.cfg_rsp_up_ack                ( cfg_rsp_up_ack  )
    ,.cfg_rsp_up                    ( cfg_rsp_up )

    ,.cfg_req_up_write              ( cfg_req_up_write )
    ,.cfg_req_up_read               ( cfg_req_up_read  )
    ,.cfg_req_up                    ( cfg_req_up )

    ,.mstr_hqm_reset_done           ( mstr_hqm_reset_done )
    ,.mstr_unit_idle                ( mstr_unit_idle )    
    ,.mstr_lcb_enable               ( mstr_lcb_enable )    
    ,.mstr_unit_pipeidle            ( mstr_unit_pipeidle ) 

    ,.hqm_proc_master_reset_done    ( hqm_proc_master_reset_done )
    ,.hqm_proc_master_unit_idle     ( hqm_proc_master_unit_idle )

    ,.mstr_proc_reset_status        ( mstr_proc_reset_status )
    ,.mstr_proc_idle_status         ( mstr_proc_idle_status )
    ,.mstr_proc_lcb_status          ( mstr_proc_lcb_status )

    ,.visa_str_hqm_proc_pipeidle    ( visa_str_hqm_proc_pipeidle )

    ,.fscan_rstbypen                ( fscan_rstbypen )
    ,.fscan_byprst_b                ( fscan_byprst_b )

);

hqm_pm_unit #( .HQM_TRIGGER_WIDTH (HQM_TRIGGER_WIDTH) ) i_hqm_pm_unit
(
     .aon_clk                       ( aon_clk )
    ,.pgcb_clk                      ( pgcb_clk )
    ,.pgcb_tck                      ( pgcb_tck )

    ,.hqm_fullrate_clk              ( hqm_fullrate_clk )
    ,.hqm_freerun_clk               ( hqm_freerun_clk )
    ,.hqm_cdc_clk                   ( hqm_cdc_clk )    // CDC ONLY

    ,.side_rst_b                    ( side_rst_b )

    ,.prim_freerun_clk              ( prim_freerun_clk )
    ,.prim_gated_clk                ( prim_gated_clk )
    ,.prim_gated_rst_b              ( prim_gated_rst_b )

    ,.flr_clkreq_b                  ( flr_clkreq_b ) 
    ,.flr_triggered                 ( flr_triggered )
    ,.hqm_shields_up                ( hqm_shields_up )
    ,.hqm_flr_prep                  ( hqm_flr_prep )
    ,.hqm_pwrgood_rst_b             ( hqm_pwrgood_rst_b )
    ,.hqm_gated_local_override      ( hqm_gated_local_override )
    ,.pgcb_force_rst_b              ( pgcb_force_rst_b )

    ,.fuse_force_on                 ( fuse_force_on )
    ,.fuse_proc_disable             ( fuse_proc_disable )
    ,.prochot_deglitch_sync         ( prochot_deglitch_sync )

    ,.pm_state                      ( pm_state )
    ,.cfg_d3tod0_event_cnt_inc      ( cfg_d3tod0_event_cnt_inc )
    ,.pm_fsm_in_run                 ( pm_fsm_in_run )   
    ,.flrsm_state                   ( flrsm_state )
    ,.cfg_flr_count                 ( cfg_flr_count )

    ,.pgcb_fet_en_ack_b             ( pgcb_fet_en_ack_b)
    ,.pgcb_fet_en_b                 ( pgcb_fet_en_b )

    ,.master_ctl_load               ( master_ctl_load )
    ,.master_ctl                    ( master_ctl )

    ,.cfg_pm_override               ( cfg_pm_override )

    ,.cfg_hqm_pgcb_ctl              ( cfg_hqm_pgcb_ctl ) 
    ,.cfg_hqm_pgcb_ctl_v            ( cfg_hqm_pgcb_ctl_v )

    ,.cfg_hqm_cdc_ctl               ( cfg_hqm_cdc_ctl ) 
    ,.cfg_hqm_cdc_ctl_v             ( cfg_hqm_cdc_ctl_v )

    ,.cfg_pm_pmcsr_disable          ( cfg_pm_pmcsr_disable ) 

    ,.cfg_pm_status                 ( cfg_pm_status )

    ,.pm_fsm_d0tod3_ok              ( pm_fsm_d0tod3_ok )
    ,.pm_fsm_d3tod0_ok              ( pm_fsm_d3tod0_ok )

    ,.hqm_clk_enable_int            ( hqm_clk_enable_int )
    ,.gclock_enable_final           ( gclock_enable_final )
    ,.hqm_clk_ungate_presync        ( hqm_clk_ungate_presync )
    ,.hqm_gated_rst_b               ( hqm_gated_rst_b )

    ,.pgcb_isol_en_b                ( pgcb_isol_en_b )
    ,.pgcb_isol_en                  ( pgcb_isol_en )

    ,.fdfx_powergood                ( fdfx_powergood )

    ,.fdfx_pgcb_bypass              ( fdfx_pgcb_bypass )
    ,.fdfx_pgcb_ovr                 ( fdfx_pgcb_ovr )
    ,.fscan_isol_ctrl               ( fscan_isol_ctrl )
    ,.fscan_isol_lat_ctrl           ( fscan_isol_lat_ctrl )
    ,.fscan_ret_ctrl                ( fscan_ret_ctrl )
    ,.fscan_mode                    ( fscan_mode ) 
    ,.fscan_fet_on                  ( fscan_fet_on )
    ,.fscan_trigger_mask_v          ( fscan_trigger_mask_v )
    ,.fscan_trigger_mask            ( fscan_trigger_mask )

    ,.fscan_clkungate               ( fscan_clkungate )
    ,.fscan_rstbypen                ( fscan_rstbypen )
    ,.fscan_byprst_b                ( fscan_byprst_b )
    ,.fscan_fet_en_sel              ( fscan_fet_en_sel )

    ,.cdc_hqm_jta_force_clkreq      ( cdc_hqm_jta_force_clkreq )
    ,.cdc_hqm_jta_clkgate_ovrd      ( cdc_hqm_jta_clkgate_ovrd )

    ,.penable                       ( penable )
    ,.pwrite                        ( pwrite )
    ,.paddr_31_28                   ( paddr[31:28] )
    ,.pready                        ( pready )
    ,.prdata_2_0                    ( prdata[2:0] )

    ,.hqm_triggers_in               ( hqm_triggers_in )
    ,.hqm_triggers                  ( hqm_triggers )
    ,.pm_fsm_active                 ( pm_fsm_active )

    ,.hqm_cdc_clk_enable            ( hqm_cdc_clk_enable )

    ,.hw_reset_force_pwr_on         ( hw_reset_force_pwr_on )

    ,.pgcb_hqm_pwrgate_active       ( pgcb_hqm_pwrgate_active )         // viewpin
    ,.final_pgcb_fet_en_ack_b       ( final_pgcb_fet_en_ack_b )         // viewpin
    ,.pgcb_fet_en_b_out             ( pgcb_fet_en_b_out )               // viewpin

    ,.hqm_cdc_visa                  ( hqm_cdc_visa )
    ,.hqm_pgcbunit_visa             ( hqm_pgcbunit_visa )
    ,.hqm_pmsm_visa                 ( hqm_pmsm_visa )

);


// collage-pragma translate_on

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------

endmodule //hqm_master_core

