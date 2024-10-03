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
//import PowerGatingCommonPkg::*;
import PowerGatingParamsPkg::*;

interface PowerGatingNoParamIF;

	logic clk;
	logic jtag_tck;
	logic reset_b;
	logic[MAX_SIP-1:0] pmc_ip_sw_pg_req_b;

	logic[MAX_SIP-1:0] ip_pmc_pg_req_b;
	logic[MAX_SIP-1:0] pmc_ip_pg_ack_b;
	logic[MAX_SIP-1:0] pmc_ip_pg_wake;


	logic[MAX_SIP-1:0] pmc_ip_restore_b;

	logic[MAX_SIP-1:0] ip_pmc_save_req_b;
	logic[MAX_SIP-1:0] pmc_ip_save_ack_b;

	logic[MAX_SIP-1:0] prim_pok;
	logic[MAX_SIP-1:0] side_pok;
	logic[MAX_SIP-1:0] prim_rst_b;
	logic[MAX_SIP-1:0] side_rst_b;

	logic[MAX_SIP-1:0] pmc_ip_vnn_ack;
	logic[MAX_SIP-1:0] ip_pmc_vnn_req;
	//logic[MAX_SIP-1:0] pgcb_rst_b;

	logic[MAX_FAB-1:0] fab_pmc_idle;
/*	logic[MAX_FAB-1:0] pmc_fab_pg_req;
	logic[MAX_FAB-1:0] fab_pmc_pg_ack;
	logic[MAX_FAB-1:0] fab_pmc_pg_nack;
	*/

	logic[MAX_FAB-1:0] pmc_fab_pg_rdy_req_b;
	logic[MAX_FAB-1:0] fab_pmc_pg_rdy_ack_b;
	logic[MAX_FAB-1:0] fab_pmc_pg_rdy_nack_b;
	
//	logic[MAX_FAB-1:0] fabric_rst_b;

	logic[MAX_FET-1:0] fet_en_b;
	logic[MAX_FET-1:0] fet_en_ack_b;

	logic[MAX_SIP-1:0] fdfx_pgcb_bypass;
	logic[MAX_SIP-1:0] fdfx_pgcb_ovr;

	logic[MAX_SIP-1:0] ip_pmc_d3;
	logic[MAX_SIP-1:0] ip_pmc_d0i3;	

	bit[MAX_SIP-1:0] inacc_pg;
	
	bit[MAX_SIP-1:0] restore_next_wake;
/*	PowerGatingPrinter printer;

	function SetPrinter(PowerGatingPrinter printer_arg);
		printer = printer_arg;
	endfunction
*/


endinterface : PowerGatingNoParamIF
