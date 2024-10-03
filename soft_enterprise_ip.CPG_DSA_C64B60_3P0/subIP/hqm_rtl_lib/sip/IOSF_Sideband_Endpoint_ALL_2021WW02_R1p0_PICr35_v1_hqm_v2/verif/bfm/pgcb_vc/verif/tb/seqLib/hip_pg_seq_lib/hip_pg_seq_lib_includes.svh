//------------------------------------------------------------------------------
//  Copyright (c)
//  2010 Intel Corporation, all rights reserved.
//
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY
//  PROTECTED BY COPYRIGHT LAWS AND IS CONSIDERED A
//  TRADE SECRET BELONGING TO THE INTEL CORPORATION.
//------------------------------------------------------------------------------
//  Author  : Bill Bradley
//  Email   : william.l.bradley@intel.com
//  Date    : November 5, 2013
//  Desc    : Includes for all sequence files in HIP PG sequence library
//------------------------------------------------------------------------------

`include "seqLib/hip_pg_seq_lib/hip_pg_base_seq.svh"

// Low-level sequences that drive signals to the interface

//DBV need to fix from having to create dir struct
`include "seqLib/hip_pg_seq_lib/hip_pg_drive_pmc_phy_pwr_en_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_drive_pmc_phy_reset_b_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_drive_pmc_phy_fw_en_b_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_drive_pmc_phy_sbwake_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_drive_iosf_side_rst_b_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_drive_soc_phy_pwr_req_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_drive_pmc_phy_pmctrl_en_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_drive_pmc_phy_pmctrl_pwr_en_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_drive_forcePwrGatePOK_seq.svh"

// Low-level sequences that wait for responses to be observed on the interface

`include "seqLib/hip_pg_seq_lib/hip_pg_wait_for_phy_pmc_pwr_stable_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_wait_for_phy_pmc_sbpwr_stable_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_wait_for_iosf_side_pok_h_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_wait_for_phy_soc_pwr_ack_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_wait_for_phy_pmc_pmctrl_pwr_stable_seq.svh"

// High-level power management sequences

`include "seqLib/hip_pg_seq_lib/hip_pg_coldboot_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_shutdown_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_power_ungate_seq.svh"
`include "seqLib/hip_pg_seq_lib/hip_pg_power_gate_seq.svh"
