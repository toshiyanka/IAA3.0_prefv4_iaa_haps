#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC waivers file.
#-----------------------------------------------------------------------
source /p/com/eda/intel/cdc/v20140829/prototype/cdc_global_waivers.tcl
#source /p/com/eda/intel/cdc/v20140829/prototype/cdc_global_waivers.tcl

#Example:
#cdc report crossing -scheme <scheme_name> -from {<tx_signal>} -to {<rx_signal>} -tx_clock <tx_clock_name> -rx_clock <rx_clock_name> -severity waived

## If the cfg_*_holdoff values are asynchronous to the CDC clock, they must only be updated when the
## corresponding disable input is set to '1', as described in the integration guide
## If they are driven according to this requirement, the cross-clock violations can by waived as
## when the disable is set, the holdoff values are don’t-cares
cdc report crossing -rx_clock CDC_CLK -through cfg_clkgate_holdoff -severity waived -scheme multi_bits -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through cfg_pwrgate_holdoff -severity waived -scheme multi_bits -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through cfg_clkreq_off_holdoff -severity waived -scheme multi_bits -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through cfg_clkreq_syncoff_holdoff -severity waived -scheme multi_bits -module ClockDomainController


cdc report crossing -rx_clock CDC_CLK -through *cfg_clkgate_holdoff        -severity waived -scheme no_sync -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_pwrgate_holdoff        -severity waived -scheme no_sync -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_off_holdoff     -severity waived -scheme no_sync -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_syncoff_holdoff -severity waived -scheme no_sync -module ClockDomainController

cdc report crossing -rx_clock CDC_CLK -through *cfg_clkgate_holdoff        -severity waived -scheme dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_pwrgate_holdoff        -severity waived -scheme dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_off_holdoff     -severity waived -scheme dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_syncoff_holdoff -severity waived -scheme dmux -module ClockDomainController

cdc report crossing -rx_clock CDC_CLK -through *cfg_clkgate_holdoff        -severity waived -scheme partial_dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_pwrgate_holdoff        -severity waived -scheme partial_dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_off_holdoff     -severity waived -scheme partial_dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_syncoff_holdoff -severity waived -scheme partial_dmux -module ClockDomainController

cdc report crossing -rx_clock CDC_CLK -through *cfg_clkgate_holdoff        -severity waived -scheme multi_sync_mux_select -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_pwrgate_holdoff        -severity waived -scheme multi_sync_mux_select -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_off_holdoff     -severity waived -scheme multi_sync_mux_select -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_syncoff_holdoff -severity waived -scheme multi_sync_mux_select -module ClockDomainController

cdc report crossing -rx_clock PGCB_CLK -through *pgcb_force_rst_b          -severity waived -scheme partial_dmux -module ClockDomainController

##-------------------------------------------------------------------------------------------------
## force_rst_b is asynchronously combined with greset_b signal in CDC, this is okay as when it
## deasserts the clocks will still be gated in the PGD and thus should not look like an async event
##-------------------------------------------------------------------------------------------------
cdc report crossing -rx_clock CDC_CLK -through *pgcb_force_rst_b -through *greset_b -severity waived -scheme no_sync -module ClockDomainController

##-------------------------------------------------------------------------------------------------
## Waive "Custom Sync Violation" for reset synchronizers as the tool falsely flags these as
## violations because of the connection to the reset pin
##-------------------------------------------------------------------------------------------------
#cdc report crossing -through *pgcb_reset_b -through *ctech_lib_doublesync_rstb1.rstb -severity waived -scheme custom_sync_mismatch -module ClockDomainController

##=================================================================================================
## Cautions Waivers
##-------------------------------------------------------------------------------------------------
## Waive Redundant Synch 
## cfg_* are static inputs
##-------------------------------------------------------------------------------------------------
cdc report crossing -from cfg_clkgate_holdoff        -to boundary_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_clkgate_holdoff        -to ism_locked      -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_clkreq_off_holdoff     -to boundary_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_clkreq_off_holdoff     -to ism_locked      -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_clkreq_syncoff_holdoff -to boundary_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_clkreq_syncoff_holdoff -to ism_locked      -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_pwrgate_holdoff        -to boundary_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_pwrgate_holdoff        -to ism_locked      -severity waived -scheme redundant -module ClockDomainController

##-------------------------------------------------------------------------------------------------
## Waive Reconvergence Paths
##-------------------------------------------------------------------------------------------------
# Visa signal paths
cdc report crossing -to cdc_visa* -severity waived -scheme reconvergence -module ClockDomainController

#----------
# cfg_* inputs should be stable: External Input D-synch Paths
#----------
#cfg_clkgate_disabled
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkgate_dis_sync*       -severity waived -scheme reconvergence -module ClockDomainController
#cfg_clkgate_disabled
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkreq_dis_sync*        -severity waived -scheme reconvergence -module ClockDomainController
#cfg_clkreq_ctl_disabled
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_powerGateDisable*       -severity waived -scheme reconvergence -module ClockDomainController
#fismdfx_force_clkreq
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_force_clkreq_sync*      -severity waived -scheme reconvergence -module ClockDomainController
#fismdfx_clkgate_ovrd_sync
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkgate_ovrd_sync*      -severity waived -scheme reconvergence -module ClockDomainController
#----------------------------
#Following paths are from using "next_state"   
# idle_timer 
# current state 
# cfg_upate
# boundary_locked
# ism_locked
# clkreq_hold
# domain_locked
# force_ready
# gclock_ack_async
# gclock_active 
# gclock_enable
# clkgate_diabled
#----------------------------
#EXT: cdc_restore_pg
#----------------------------

cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from  *u_clkreq_start_hold_ack_ByPgcb* -to *clkreq_hold*      -severity waived -scheme reconvergence -module ClockDomainController

cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*  -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*           -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*          -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*      -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*  -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*         -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*  -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*   -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                  -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*           -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                -to *u_CdcMainClock.clkreq_start_hold*   -severity waived -scheme reconvergence -module ClockDomainController


cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_clkreqStartHoldPG*       -to *assert_clkreq_pg*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_clkreqStartHoldPG*       -to *u_CdcPgcbClock.clkreq*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_clkreqStartHoldPG*       -to *u_CdcPgcbClock.clkreq_start_ok*  -severity waived -scheme reconvergence -module ClockDomainController


#----------------------------
#EXT: cdc_restore_pg
#----------------------------
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *idle_timer*       -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *current_state*    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *cfg_update*    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *boundary_locked*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *ism_locked*       -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *clkreq_hold*      -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *domain_locked*      -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *force_ready*      -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *gclock_active    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *gclock_enable    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*                 -to *clkgate_disabled    -severity waived -scheme reconvergence -module ClockDomainController
#----------------------------
#EXT: gclock_req_async
#----------------------------
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *idle_timer*       -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *current_state*    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *cfg_update*    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *boundary_locked*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *ism_locked*       -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *clkreq_hold*       -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *domain_locked*     -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *force_ready*     -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *gclock_ack_async*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *gclock_active     -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *gclock_enable     -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*        -to *clkgate_disabled     -severity waived -scheme reconvergence -module ClockDomainController
#-------------------------------------------------------------------------------
#EXT: pgcb_pok
#-------------------------------------------------------------------------------
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *idle_timer*        -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *current_state*     -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *cfg_update*     -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *boundary_locked*   -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *ism_locked*        -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *clkreq_hold*       -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *domain_locked*     -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *force_read*     -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *gclock_ack_async*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *gclock_active     -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *gclock_enable     -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*                   -to *clkgate_disabled     -severity waived -scheme reconvergence -module ClockDomainController

#-------------------------------------------------------------------------------
#EXT: clkack
#-------------------------------------------------------------------------------
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *idle_timer*       -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *current_state*    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *cfg_update*    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *boundary_locked*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *ism_locked*       -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *clkreq_hold*      -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *domain_locked*    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *force_ready*    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *gclock_active    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *gclock_enable    -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*                -to *clkgate_disabled    -severity waived -scheme reconvergence -module ClockDomainController

#-------------------------------------------------------------------------------
#pwrgate_active_pg from CdcPgClock.sv
#-------------------------------------------------------------------------------
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*            -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
#-------------------------------------------------------------------------------
#force_pgate_req_pg from CdcPgClock.sv
#-------------------------------------------------------------------------------
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*            -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
#-------------------------------------------------------------------------------
#unlock_domain_pg from CdcPgClock.sv
#-------------------------------------------------------------------------------
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*                 -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController

#-------------------------------------------------------------------------------
#force_pgate_req_not_pg_active_pg from CdcPgClock.sv : Added to prevent dead-lock hazard
#-------------------------------------------------------------------------------
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive*  -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController

#-------------------------------------------------------------------------------
#Meta-stability race prevention logic
#Reconverge through next_state logic.  Paths are understood and intentional.
#-------------------------------------------------------------------------------
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController

cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *clkgate_disabled  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *clkgate_disabled  -severity waived -scheme reconvergence -module ClockDomainController

#----------------------------- 
# last_do_force_pgate
#----------------------------- 
# Force power gate can proceed as long as the ISMs are idle
# 3 input paths 
#   1) force_pgate_req is D-sync output from PGCB domain
#   2) ism_agent is input
#   3) ism_locked_f is flopped version of ism_locked_c which contains paths fro next_state logic paths. 

cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm*               -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate*          -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok*               -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active*    -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll*         -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb*   -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*    -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb*          -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController


#-----------------------------
# last_gclock_req 
#-----------------------------
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*      -to *last_gclock_req* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *last_gclock_req* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb*  -to *last_gclock_req* -severity waived -scheme reconvergence -module ClockDomainController

#-----------------------------
# pok_preout 
#-----------------------------
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync*      -to *pok_preout* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync*              -to *pok_preout* -severity waived -scheme reconvergence -module ClockDomainController

#----------------------------- 
# unlock_domain_pg logic
#----------------------------- 
#fismdfx_force_clkreq_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_dfxForceClkreq* -to *unlock_domain_pg*  -severity waived -scheme reconvergence -module ClockDomainController
#gclock_req_sync_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG* -to *unlock_domain_pg*  -severity waived -scheme reconvergence -module ClockDomainController
#gclock_req_async_sync_bits
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqAsyncPG* -to *unlock_domain_pg*  -severity waived -scheme reconvergence -module ClockDomainController
#lockd_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *unlock_domain_pg*  -severity waived -scheme reconvergence -module ClockDomainController
#ism_locked_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *unlock_domain_pg*  -severity waived -scheme reconvergence -module ClockDomainController
#ism_wake_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG* -to *unlock_domain_pg*  -severity waived -scheme reconvergence -module ClockDomainController

#----------------------------- 
#force_pgate_req_pg
#----------------------------- 
#fismdfx_force_clkreq_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_dfxForceClkreq* -to *force_pgate_req*  -severity waived -scheme reconvergence -module ClockDomainController
#gclock_req_sync_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG* -to *force_pgate_req*  -severity waived -scheme reconvergence -module ClockDomainController
#gclock_req_async_sync_bits
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqAsyncPG* -to *force_pgate_req*  -severity waived -scheme reconvergence -module ClockDomainController
#lockd_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *force_pgate_req*  -severity waived -scheme reconvergence -module ClockDomainController
#ism_locked_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *force_pgate_req*  -severity waived -scheme reconvergence -module ClockDomainController
#ism_wake_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG* -to *force_pgate_req*  -severity waived -scheme reconvergence -module ClockDomainController

#-----------------------------
# pwrgate_ready
#-----------------------------
#fismdfx_force_clkreq_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_dfxForceClkreq* -to *pwrgate_ready*  -severity waived -scheme reconvergence -module ClockDomainController
#gclock_req_sync_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG* -to *pwrgate_ready*  -severity waived -scheme reconvergence -module ClockDomainController
#gclock_req_async_sync_bits
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqAsyncPG* -to *pwrgate_ready*  -severity waived -scheme reconvergence -module ClockDomainController
#lockd_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *pwrgate_ready*  -severity waived -scheme reconvergence -module ClockDomainController
#ism_locked_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *pwrgate_ready*  -severity waived -scheme reconvergence -module ClockDomainController
#ism_wake_pg
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG* -to *pwrgate_ready*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_forceRdyPG* -to *pwrgate_ready*  -severity waived -scheme reconvergence -module ClockDomainController



#-----------------------------
#  assert_clkreq_pg 
#-----------------------------
# ----------
# External Inputs
# ----------
# fismdfx_force_clkreq 
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_dfxForceClkreq* -to *assert_clkreq_pg*  -severity waived -scheme reconvergence -module ClockDomainController
# gclock_req_async
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *AsyncReqXC*       -to *assert_clkreq_pg*  -severity waived -scheme reconvergence -module ClockDomainController
# gclock_req_sync
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG* -to *assert_clkreq_pg*  -severity waived -scheme reconvergence -module ClockDomainController

# ----------
#from CdcMainClock
# ----------
# domain_locked
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *assert_clkreq_pg*  -severity waived -scheme reconvergence -module ClockDomainController
# force_ready
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_forceRdyPG*     -to *assert_clkreq_pg*  -severity waived -scheme reconvergence -module ClockDomainController
# clkreq_hold
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *SyncForDefPwrOn*  -to *assert_clkreq_pg*  -severity waived -scheme reconvergence -module ClockDomainController
# ism_wake
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG* -to *assert_clkreq_pg*  -severity waived -scheme reconvergence -module ClockDomainController
# domain_pok
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainPokPG* -to *assert_clkreq_pg*  -severity waived -scheme reconvergence -module ClockDomainController
# ism_locked_f
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *assert_clkreq_pg*  -severity waived -scheme reconvergence -module ClockDomainController

#-----------------------------
#  cdc_restore_pg  
#-----------------------------
# gclock_req_sync
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG*   -to *cdc_restore_pg*  -severity waived -scheme reconvergence -module ClockDomainController
# ism_locked_f
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *cdc_restore_pg*  -severity waived -scheme reconvergence -module ClockDomainController
# ism_wake
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG*         -to *cdc_restore_pg*  -severity waived -scheme reconvergence -module ClockDomainController
# domain_locked
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *cdc_restore_pg*  -severity waived -scheme reconvergence -module ClockDomainController

#-----------------------------
# clkreq 
#-----------------------------
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqAsyncPG* -to *clkreq*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_clkreqHoldPG*     -to *clkreq*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_dfxForceClkreq*   -to *clkreq*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *clkreq*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainPokPG*       -to *clkreq*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG*   -to *clkreq*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG* -to *clkreq*  -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *clkreq*  -severity waived -scheme reconvergence -module ClockDomainController

