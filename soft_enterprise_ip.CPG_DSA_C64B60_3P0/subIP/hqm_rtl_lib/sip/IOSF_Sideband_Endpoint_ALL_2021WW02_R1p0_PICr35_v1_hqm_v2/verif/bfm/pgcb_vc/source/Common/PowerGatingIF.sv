/*
================================================================================
  Copyright (c) 2011 Intel Corporation, all rights reserved.

  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY COPYRIGHT LAWS AND IS 
  CONSIDERED A TRADE SECRET BELONGING TO THE INTEL CORPORATION.
================================================================================

  Author          : 
  Email           : 
  Phone           : 
  Date            : 

================================================================================
  Description     : One line description of this class
  
Write your wordy description here.
================================================================================
*/



interface PowerGatingIF; 

	parameter int NUM_SIP_PGCB = 1;
	parameter int NUM_FET = 1;
	parameter int NUM_SW_REQ = 1;
	parameter int NUM_PMC_WAKE = 1;
	parameter int NUM_FAB_PGCB = 1;
	parameter int NUM_PRIM_EP = 1;
	parameter int NUM_SB_EP = 1;
	parameter int NUM_D3 = 1;
	parameter int NUM_D0I3 = 1;

	parameter int NUM_VNN_ACK_REQ = 1;

	parameter string test_island_name = "";

	parameter bit NO_FAB_PGCB = 0;
	parameter bit NO_SIP_PGCB = 0;
	parameter bit NO_PRIM_EP = 0;
	
	logic clk; 
	logic jtag_tck;
	logic reset_b;

	logic[NUM_SW_REQ-1:0] pmc_ip_sw_pg_req_b;
	logic[NUM_SIP_PGCB-1:0] ip_pmc_pg_req_b;
	logic[NUM_SIP_PGCB-1:0] pmc_ip_pg_ack_b;
	logic[NUM_PMC_WAKE-1:0] pmc_ip_pg_wake;

	logic[NUM_SIP_PGCB-1:0] pmc_ip_restore_b;

	logic[NUM_SIP_PGCB-1:0] ip_pmc_save_req_b;
	logic[NUM_SIP_PGCB-1:0] pmc_ip_save_ack_b;
	
	logic[NUM_PRIM_EP-1:0] prim_pok;
	logic[NUM_SB_EP-1:0] side_pok;
	logic[NUM_PRIM_EP-1:0] prim_rst_b;
	logic[NUM_SB_EP-1:0] side_rst_b;

	logic[NUM_VNN_ACK_REQ-1:0] ip_pmc_vnn_req;
	logic[NUM_VNN_ACK_REQ-1:0] pmc_ip_vnn_ack;

	logic[NUM_FAB_PGCB-1:0] fab_pmc_idle;
	
	//adding the signals back for backward compatibility
	logic[NUM_FAB_PGCB-1:0] pmc_fab_pg_req;
	logic[NUM_FAB_PGCB-1:0] fab_pmc_pg_ack;
	logic[NUM_FAB_PGCB-1:0] fab_pmc_pg_nack;
	
	logic[NUM_FAB_PGCB-1:0] pmc_fab_pg_rdy_req_b;
	logic[NUM_FAB_PGCB-1:0] fab_pmc_pg_rdy_ack_b;
	logic[NUM_FAB_PGCB-1:0] fab_pmc_pg_rdy_nack_b;

	logic[NUM_FET-1:0] fet_en_b;
	logic[NUM_FET-1:0] fet_en_ack_b;

	logic[NUM_SIP_PGCB-1:0] fdfx_pgcb_bypass;
	logic[NUM_SIP_PGCB-1:0] fdfx_pgcb_ovr;

	logic[NUM_D3-1:0] ip_pmc_d3;
	logic[NUM_D0I3-1:0] ip_pmc_d0i3;	


	`ifndef DISABLE_CHASSIS_POWER_GATING_COVERAGE
		`include "../Common/PowerGatingCoverage.svh"	
	`endif
	`include "../Common/PowerGatingChecks.svh"
endinterface : PowerGatingIF


//including all the interfaces here so that i dont have to change the HDL file
`include "interface/PowerGatingSIPIF.sv"
`include "interface/PowerGatingSIPTI.sv"

