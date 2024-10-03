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
//  Date    : November 4, 2013
//  Desc    : Wrapper class for HIP PG Agent related functionality
//            Contains definitions of the Monitor and Driver operations and transactions.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// class: hip_pg
// Wrapper class for HIP PG Agent related functionality
//------------------------------------------------------------------------------
class hip_pg;

  //---------------------------------------------------------------------------
  // Enum: hip_pg_op_t
  // Defines all supported HIP PG driver transactions
  //---------------------------------------------------------------------------
  typedef enum byte {
    HIP_PG_OP_UNKNOWN,
    HIP_PG_OP_COMPLETE,

    // signals to drive
    HIP_PG_PMC_PHY_PWR_EN,
    HIP_PG_PHY_PMC_PWR_STABLE,
    HIP_PG_PMC_PHY_RESET_B,
    HIP_PG_PMC_PHY_FW_EN_B,
    HIP_PG_PMC_PHY_SBWAKE,
    HIP_PG_PHY_PMC_SBPWR_STABLE,
    HIP_PG_IOSF_SIDE_POK_H,
    HIP_PG_IOSF_SIDE_RST_B,
    HIP_PG_SOC_PHY_PWR_REQ,
    HIP_PG_PHY_SOC_PWR_ACK,
    HIP_PG_PMC_PHY_PMCTRL_EN,
    HIP_PG_PMC_PHY_PMCTRL_PWR_EN,
    HIP_PG_PHY_PMC_PMCTRL_PWR_STABLE,
    HIP_PG_FORCEPWRGATEPOK

  } hip_pg_op_t;

  //---------------------------------------------------------------------------
  // Enum: hip_pg_mon_op_t
  // Defines all supported HIP PG monitor transactions
  //---------------------------------------------------------------------------
  typedef enum byte {
    HIP_PG_MON_OP_UNKNOWN,
    HIP_PG_MON_OP_COMPLETE,
    HIP_PG_MON_OP_FAIL_TIMEOUT,

    // signals to monitor
    HIP_PG_MON_PMC_PHY_PWR_EN,
    HIP_PG_MON_PHY_PMC_PWR_STABLE,
    HIP_PG_MON_PMC_PHY_RESET_B,
    HIP_PG_MON_PMC_PHY_FW_EN_B,
    HIP_PG_MON_PMC_PHY_SBWAKE,
    HIP_PG_MON_PHY_PMC_SBPWR_STABLE,
    HIP_PG_MON_IOSF_SIDE_POK_H,
    HIP_PG_MON_IOSF_SIDE_RST_B,
    HIP_PG_MON_SOC_PHY_PWR_REQ,
    HIP_PG_MON_PHY_SOC_PWR_ACK,
    HIP_PG_MON_PMC_PHY_PMCTRL_EN,
    HIP_PG_MON_PMC_PHY_PMCTRL_PWR_EN,
    HIP_PG_MON_PHY_PMC_PMCTRL_PWR_STABLE,
    HIP_PG_MON_FORCEPWRGATEPOK,

    // wait-based events
    HIP_PG_MON_WAIT_FOR_PHY_PMC_PWR_STABLE,
    HIP_PG_MON_WAIT_FOR_PHY_PMC_SBPWR_STABLE,
    HIP_PG_MON_WAIT_FOR_IOSF_SIDE_POK_H,
    HIP_PG_MON_WAIT_FOR_PHY_SOC_PWR_ACK,
    HIP_PG_MON_WAIT_FOR_PHY_PMC_PMCTRL_PWR_STABLE

  } hip_pg_mon_op_t;

  //---------------------------------------------------------------------------
  // Enum: hip_pg_domain_status_t
  // Defines all power domain statuses for HIP PG
  //---------------------------------------------------------------------------
  typedef enum byte {
    HIP_PG_DOMAIN_OFF,
    HIP_PG_DOMAIN_ON,
    HIP_PG_DOMAIN_COLDBOOT,
    HIP_PG_DOMAIN_SHUTDOWN,
    HIP_PG_DOMAIN_POWER_UNGATE,
    HIP_PG_DOMAIN_POWER_GATE
  } hip_pg_domain_status_t;

endclass : hip_pg
