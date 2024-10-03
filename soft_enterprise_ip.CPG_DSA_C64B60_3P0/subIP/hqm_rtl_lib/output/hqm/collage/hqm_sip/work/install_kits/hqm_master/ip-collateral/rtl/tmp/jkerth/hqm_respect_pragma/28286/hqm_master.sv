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
// hqm_master
//
// This module is the wrapper for the hqm core config and status aggregator logic.
//
//-----------------------------------------------------------------------------------------------------

module hqm_master

    import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
   parameter HQM_TRIGGER_WIDTH = 3
) (
  // CLK
      input logic                                      prim_gated_clk                   // I: par_hqm_system
    , input logic                                      prim_clk_enable                  // I: 
    , input  logic                                     hqm_freerun_clk                  // I: PM FLR Unit only
    , input  logic                                     hqm_fullrate_clk                 // I: 

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
    , output logic                                     hqm_flr_prep                     // O: PROC PARS 
    , output logic                                     hqm_pwrgood_rst_b                // O: PROC PARS 
    , output logic                                     hqm_gated_local_override         // O: PROC PARS 
                                                                                        
    , input  logic                                     prochot                          // I: PKG PIN,FIVR wired-or 
                                                                                        
    , input  logic [`HQM_PM_FSM_VEC_SZ-1:0]            pm_state                         // I: IOSF 
    , input  logic                                     master_ctl_load                  // I: IOSF
    , input  logic [31:0]                              master_ctl                       // I: IOSF
    , output logic                                     pm_fsm_d0tod3_ok                 // O: IOSF
    , output logic                                     pm_fsm_d3tod0_ok                 // O: IOSF
    , output logic                                     pm_fsm_in_run                    // O: IOSF
    , output logic                                     pm_allow_ing_drop                // O: IOSF
                                                                                        
    , output logic                                     pgcb_isol_en_b                   // O: isolation ctl active low 
    , output logic                                     pgcb_isol_en                     // O: isolation ctl active high 
                                                                                        
    // FET INTF                                                                        
    , output logic                                     pgcb_fet_en_b                    // O: FET en
    , input  logic                                     pgcb_fet_en_ack_b                // I: FET ack 

    // FUSE INTF                                                                        
    , input  logic                                     fuse_force_on                    // I:
    , input  logic                                     fuse_proc_disable                // I:
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
                                                                                        
    , output logic                                     hqm_proc_reset_done_sync_hqm     // O: PROC PARS (SYS & CHP)  
    , output logic                                     hqm_proc_reset_done              // O: IOSF - Done indication of MASTER & hqm_proc PARs 

    // VISA INTF
    , output logic                                     visa_str_hqm_proc_idle           // O: CHP (VISA)
    , output logic                                     visa_str_hqm_proc_pipeidle       // O: CHP (VISA)
    , output logic                                     visa_str_prim_clk_enable         // O: VISA
    , output logic                                     visa_str_hqm_clk_enable          // O: VISA
    , output logic                                     visa_str_hqm_clk_throttle        // O: VISA
    , output logic                                     visa_str_hqm_gclock_enable       // O: VISA
    , output logic                                     visa_str_hqm_cdc_clk_enable      // O: VISA
    , output logic                                     visa_str_hqm_gated_local_override // O: VISA
    , output logic                                     visa_str_hqm_flr_prep            // O: VISA
    , output logic                                     visa_str_pm_ip_clk_halt_b_2_rpt_0_iosf // O: VISA

    // TRIGGER INTF
    , input  logic   [ (10 ) - 1 : 0 ]                hqm_triggers_in                   // I: IOSF
    , output logic   [ (10 ) - 1 : 0 ]                hqm_triggers                      // O: ADL

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
    , input  logic                                     fscan_fet_on                     // I: dfx for hqm_clk_switch logic
    , input  logic                                     fscan_trigger_mask_v             // I: dfx for trigger logic
    , input  logic   [ (30 ) - 1 : 0 ]                 fscan_trigger_mask               // I: dfx for trigger logic

    , input  logic                                     fscan_fet_en_sel                 // I:

    , input  logic                                     cdc_hqm_jta_force_clkreq         // I:
    , input  logic                                     cdc_hqm_jta_clkgate_ovrd         // I:

    , output logic                                     hqm_cdc_clk_enable               // 0:

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

    , output logic                                     hqm_cfg_master_clkreq_b          // O:

);

`ifndef HQM_VISA_ELABORATE


`endif

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------

endmodule //hqm_master


