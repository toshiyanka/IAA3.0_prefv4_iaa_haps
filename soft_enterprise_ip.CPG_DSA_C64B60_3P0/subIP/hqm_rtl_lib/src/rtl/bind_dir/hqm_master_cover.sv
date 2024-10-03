//`ifdef INTEL_INST_ON

module hqm_master_cover import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

//`ifdef HQM_COVER_ON

  // Insert coverage code here
  // Refer to signals defined in with '' prefix
  // Refer to signals defined in sub-modules of with '<sub-module instance name>.' prefix (substitute <sub-module instance name> with actual sub-module instance name)

  logic prim_freerun_clk;
  logic hprim_gated_rst_b;
  assign clk   = hqm_master_core.prim_freerun_clk;
  assign rst_n = hqm_master_core.prim_gated_rst_b;
  

logic prim_gated_rst_b_sync ;
logic [31:0] paddr_f ;
logic        apb2cfg_req_v;
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] prim_cfg_req_write_pre_lock ;
logic hqm_fullrate_pgcb_force_rst_b_sync;

assign prim_gated_rst_b_sync   = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.prim_gated_rst_b_sync ;
assign paddr_f                     = hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.paddr_f ;
assign apb2cfg_req_v               = (hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.apb2cfg_req_write_nxt | hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.apb2cfg_req_read_nxt);
assign prim_cfg_req_write_pre_lock = hqm_master_core.i_hqm_cfg_master.prim_cfg_req_write_pre_lock ;
assign pgcb_force_rst_b            = hqm_master_core.i_hqm_clk_throttle_unit.hqm_fullrate_pgcb_force_rst_b_sync ;


 
covergroup hqm_master_CG () @( posedge clk ) ;

WCP_RING_WR: coverpoint { hqm_master_core.mstr_cfg_req_down_write } iff ( prim_gated_rst_b_sync );
WCP_RING_RD: coverpoint { hqm_master_core.mstr_cfg_req_down_read }  iff ( prim_gated_rst_b_sync );
WCP_INTL_WR: coverpoint { hqm_master_core.cfg_req_internal_write }  iff ( prim_gated_rst_b_sync );
WCP_INTL_RD: coverpoint { hqm_master_core.cfg_req_internal_read }   iff ( prim_gated_rst_b_sync );

//===============================================================================================================================
// CFG MASTER / SYS2CFG
//

// Sticky Bit Warnings
WCP_ERR_SLV_ACCESS:      coverpoint { hqm_master_core.i_hqm_cfg_master.err_slv_access }      iff ( prim_gated_rst_b_sync );
WCP_ERR_CFG_DECODE:      coverpoint { hqm_master_core.i_hqm_cfg_master.err_cfg_decode }      iff ( prim_gated_rst_b_sync );
// NOT EXERCISABLE VIA SIM.  WCP_ERR_CFG_REQ_UP_MISS: coverpoint { hqm_master_core.i_hqm_cfg_master.err_cfg_req_up_miss } iff ( prim_gated_rst_b_sync );
WCP_ERR_CFG_REQ_DROP:    coverpoint { hqm_master_core.i_hqm_cfg_master.err_cfg_req_drop }    iff ( prim_gated_rst_b_sync );

WCP_REQ_INTL_WR:          coverpoint { hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_internal_write_f } iff ( prim_gated_rst_b_sync );  
WCP_REQ_INTL_RD:          coverpoint { hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_internal_read_f }  iff ( prim_gated_rst_b_sync );  

WCP_REQ_RING_WR:          coverpoint { hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_down_write_f }     iff ( prim_gated_rst_b_sync );  
WCP_REQ_RING_RD:          coverpoint { hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_down_read_f }      iff ( prim_gated_rst_b_sync );  
WCP_REQ_RING_DROP:        coverpoint { hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.ring_pready_drop }         iff ( prim_gated_rst_b_sync & ~hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.cfg_req_down_f.user.addr_decode_err );

WCX_REQ_RING_DROP_WR: cross WCP_REQ_RING_WR, WCP_REQ_RING_DROP;
WCX_REQ_RING_DROP_RD: cross WCP_REQ_RING_RD, WCP_REQ_RING_DROP;

//Responses From Each Unit
WCP_RSP_UID: coverpoint { hqm_master_core.i_hqm_cfg_master.cfg_rsp_up.uid } iff ( prim_gated_rst_b_sync )
  {
    bins        SYS   = { 1 };
    bins        AQED  = { 2 };
    bins        AP    = { 3 };
    bins        CHP   = { 4 };
    bins        DP    = { 5 };
    bins        DQED  = { 6 };
    bins        QED   = { 7 };
    bins        NALB  = { 8 };
    bins        ROP   = { 9 };
    bins        LSP   = { 10 };
    bins        MSTR  = { 11 };
    ignore_bins UIDX  = { 0,12,13,14,15 };
  }
WCP_CFG_RSP:             coverpoint { hqm_master_core.i_hqm_cfg_master.cfg_rsp_up_ack } iff (prim_gated_rst_b_sync) ;
WCP_CFG_RSP_SLV_ACC_ERR: coverpoint { hqm_master_core.i_hqm_cfg_master.cfg_rsp_up.err } iff (prim_gated_rst_b_sync & hqm_master_core.i_hqm_cfg_master.cfg_rsp_up_ack & ~hqm_master_core.i_hqm_cfg_master.cfg_rsp_up.err_slv_par) ;

WCX_CFG_RSP_UID: cross WCP_CFG_RSP            , WCP_RSP_UID;
WCX_CFG_RSP_UID: cross WCP_CFG_RSP_SLV_ACC_ERR, WCP_RSP_UID; // Slave Access Error From Each Unit

// Decode Types & Decode Errors
WCP_DECODE_MODE: coverpoint { paddr_f[26:25] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v )
  {
   bins  VIRT ={2'b00};
   bins  VIRT2={2'b01};
   bins   REG ={2'b10};
   bins   MEM ={2'b11};
  }

// VIRT
WCP_DECODE_ERR_VIRT_BIT11: coverpoint { paddr_f[11] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26] == 1'b0) );
WCP_DECODE_ERR_VIRT_BIT10: coverpoint { paddr_f[10] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26] == 1'b0) );
WCP_DECODE_ERR_VIRT_BIT09: coverpoint { paddr_f[09] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26] == 1'b0) );
WCP_DECODE_ERR_VIRT_BIT08: coverpoint { paddr_f[08] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26] == 1'b0) );
WCP_DECODE_ERR_VIRT_BIT07: coverpoint { paddr_f[07] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26] == 1'b0) );
WCP_DECODE_ERR_VIRT_BIT06: coverpoint { paddr_f[06] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26] == 1'b0) );
WCP_DECODE_ERR_VIRT_BIT05: coverpoint { paddr_f[05] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26] == 1'b0) );
WCP_DECODE_ERR_VIRT_BIT04: coverpoint { paddr_f[04] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26] == 1'b0) );
WCP_DECODE_ERR_VIRT_BIT03: coverpoint { paddr_f[03] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26] == 1'b0) );
WCP_DECODE_ERR_VIRT_BIT02: coverpoint { paddr_f[02] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26] == 1'b0) );

// MEM
// No Decode Err bits for MEM type in V2

// REG
WCP_DECODE_ERR_REG_BIT24:  coverpoint { paddr_f[24] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26:25] == 2'b10) );
WCP_DECODE_ERR_REG_BIT23:  coverpoint { paddr_f[23] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26:25] == 2'b10) );
WCP_DECODE_ERR_REG_BIT22:  coverpoint { paddr_f[22] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26:25] == 2'b10) );
WCP_DECODE_ERR_REG_BIT21:  coverpoint { paddr_f[21] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26:25] == 2'b10) );
WCP_DECODE_ERR_REG_BIT20:  coverpoint { paddr_f[20] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26:25] == 2'b10) );
WCP_DECODE_ERR_REG_BIT19:  coverpoint { paddr_f[19] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26:25] == 2'b10) );
WCP_DECODE_ERR_REG_BIT18:  coverpoint { paddr_f[18] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26:25] == 2'b10) );
WCP_DECODE_ERR_REG_BIT17:  coverpoint { paddr_f[17] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26:25] == 2'b10) );
WCP_DECODE_ERR_REG_BIT16:  coverpoint { paddr_f[16] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26:25] == 2'b10) );
WCP_DECODE_ERR_REG_BIT15:  coverpoint { paddr_f[15] } iff ( prim_gated_rst_b_sync & apb2cfg_req_v & (paddr_f[26:25] == 2'b10) );

// Check LOCK bit mechanisms
WCP_PGCB_CDC_LOCK:    coverpoint { prim_cfg_req_write_pre_lock[HQM_MSTR_TARGET_CFG_HQM_PGCB_CDC_LOCK] } iff ( prim_gated_rst_b_sync & hqm_master_core.i_hqm_cfg_master.cfg_hqm_pgcb_cdc_lock.LOCK ) ;
WCP_PGCB_CTL_LOCK:    coverpoint { prim_cfg_req_write_pre_lock[HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL] }  iff ( prim_gated_rst_b_sync & hqm_master_core.i_hqm_cfg_master.cfg_hqm_pgcb_cdc_lock.LOCK ) ;
WCP_CDC_CTL_LOCK:     coverpoint { prim_cfg_req_write_pre_lock[HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL] }   iff ( prim_gated_rst_b_sync & hqm_master_core.i_hqm_cfg_master.cfg_hqm_pgcb_cdc_lock.LOCK ) ;
WCP_PM_OVERRIDE_LOCK: coverpoint { prim_cfg_req_write_pre_lock[HQM_MSTR_TARGET_CFG_PM_OVERRIDE] }       iff ( prim_gated_rst_b_sync & hqm_master_core.i_hqm_cfg_master.cfg_pm_override.LOCK ) ;
WCP_PMCSR_DISABLE:    coverpoint { prim_cfg_req_write_pre_lock[HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE] }  iff ( prim_gated_rst_b_sync & ~hqm_master_core.i_hqm_cfg_master.cfg_pm_pmcsr_disable.DISABLE ) ;

//===============================================================================================================================
// PROC_MASTER
// Status Vector Aggregation and synchronizing Clk crossings for CFG Req/Rsp
//
// No CPs at this time

//===============================================================================================================================
// CLK THROTTLE 
//
WCP_CLK_SEL: coverpoint { hqm_master_core.i_hqm_clk_throttle_unit.clk_switch_sel } iff ( hqm_fullrate_pgcb_force_rst_b_sync )
  { 
    bins OFF      = { 2'b00 };
    bins SEL1P0   = { 2'b01 };
    bins SEL0P125 = { 2'b10 };
  }

WCP_CLK_SEL_WOVERRIDE: coverpoint { {hqm_master_core.i_hqm_clk_throttle_unit.sel0p125,hqm_master_core.i_hqm_clk_throttle_unit.sel1p0} } iff ( hqm_fullrate_pgcb_force_rst_b_sync )
  { 
    bins OFF      = { 2'b00 };
    bins SEL1P0   = { 2'b01 };
    bins SEL0P125 = { 2'b10 };
  }

// sb register write (modeling punit)
WCP_PUNIT_SB_WRITE_MASTER_CTL: coverpoint { hqm_master_core.i_hqm_clk_throttle_unit.master_ctl_load } iff ( hqm_master_core.side_rst_b & ~hqm_master_core.prim_gated_rst_b ) 

//===============================================================================================================================
// PM UNIT / PMSM / PM FLR

WCP_FLRSM_PWRGOOD_BRANCH: coverpoint { hqm_master_core.i_hqm_pm_unit.i_hqm_pm_flr_unit.flrsm_state_f } iff ( hqm_fullrate_pgcb_force_rst_b_sync )
  {
    bins FLRSM_PWRGOOD_RST      = { 8 => 16 };
    bins FLRSM_NO_PWRGOOD_RST   = { 8 => 32 };
  }


endgroup
hqm_master_CG hqm_master_CG_inst = new();




//`endif

endmodule

bind hqm_master_core hqm_master_cover i_hqm_master_cover();

//`endif
