//------------------------------------------------------------------------------
//  Copyright (c)
//  2010 Intel Corporation; all rights reserved.
//
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY
//  PROTECTED BY COPYRIGHT LAWS AND IS CONSIDERED A
//  TRADE SECRET BELONGING TO THE INTEL CORPORATION.
//------------------------------------------------------------------------------
//  Author  : Bill Bradley
//  Email   : william.l.bradley@intel.com
//  Date    : November 4, 2013
//  Desc    : SoC Chassis HIP Power Management interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// interface: hip_pg_if
// HIP PG interface connection.
//------------------------------------------------------------------------------
interface hip_pg_if;

  // Interface signals for each HIP voltage domain under control of PMC
  logic pmc_phy_pwr_en;
  logic phy_pmc_pwr_stable;
  logic pmc_phy_reset_b;
  logic pmc_phy_fw_en_b;

  // Interface signals for IOSF Power Management
  logic pmc_phy_sbwake;
  logic phy_pmc_sbpwr_stable;
  logic iosf_side_pok_h;
  logic iosf_side_rst_b;

  // Interface signals for dynamic power gating of each HIP gated voltage domain
  logic soc_phy_pwr_req;
  logic phy_soc_pwr_ack;
  logic pmc_phy_pmctrl_en;
  logic pmc_phy_pmctrl_pwr_en;
  logic phy_pmc_pmctrl_pwr_stable;

  // Interface signal for messages for IOSF-SB power management
  logic forcePwrGatePOK;

  //----------------------------------------------------------------------------
  // clocking: NONE
  // There is no clocking with this interface, since many of its flows occur before clocks are active or after they go inactive.
  //----------------------------------------------------------------------------

endinterface
