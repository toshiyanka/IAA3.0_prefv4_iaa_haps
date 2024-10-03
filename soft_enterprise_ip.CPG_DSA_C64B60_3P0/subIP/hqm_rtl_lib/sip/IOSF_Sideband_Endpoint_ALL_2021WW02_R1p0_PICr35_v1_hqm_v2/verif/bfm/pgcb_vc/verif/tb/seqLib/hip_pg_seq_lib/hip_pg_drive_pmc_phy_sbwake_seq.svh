//////////////////////////////////////////////////////////////////////////////
//  Copyright (c)
//  2010 Intel Corporation, all rights reserved.
//
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY
//  PROTECTED BY COPYRIGHT LAWS AND IS CONSIDERED A
//  TRADE SECRET BELONGING TO THE INTEL CORPORATION.
///////////////////////////////////////////////////////////////////////////////
//
//  Author  : Bill Bradley
//  Email   : william.l.bradley@intel.com
//  Date    : November 5, 2013
//  Desc    : HIP PG sequence to drive pmc_phy_sbwake
///////////////////////////////////////////////////////////////////////////////

`ifndef HIP_PG_PMC_PHY_SBWAKE_SEQ__SVH
`define HIP_PG_PMC_PHY_SBWAKE_SEQ__SVH

//--------------------------------------------------------------------------------
// class: hip_pg_drive_pmc_phy_sbwake_seq
//
// Sequence to drive a value to pmc_phy_sbwake
//--------------------------------------------------------------------------------
class hip_pg_drive_pmc_phy_sbwake_seq extends hip_pg_base_seq;

  `ovm_sequence_utils(hip_pg_drive_pmc_phy_sbwake_seq, hip_pg_sequencer)

  //------------------------------------------------------------------------------
  // Variables
  //------------------------------------------------------------------------------
  
  //------------------------------------------------------------------------------
  // variable: value
  //
  // Value to drive to pmc_phy_sbwake
  //------------------------------------------------------------------------------
  rand logic value;

  //------------------------------------------------------------------------------
  // function: new
  //------------------------------------------------------------------------------
  function new(string name="pmc_phy_sbwake_seq");
    super.new(name);
  endfunction : new

  //------------------------------------------------------------------------------
  // task: body
  //
  // Purpose:
  //   
  //
  // Inputs:
  //   None
  //
  // Outputs:
  //   None
  //
  // Operation:
  //   
  //------------------------------------------------------------------------------
  task body();
    hip_pg_xaction hip_pg_x;

    super.body();

    hip_pg_x = hip_pg_xaction::type_id::create("hip_pg_xaction");
    hip_pg_x.op = hip_pg::HIP_PG_PMC_PHY_SBWAKE;
    hip_pg_x.value = value;
    `ovm_send(hip_pg_x);

  endtask : body

endclass : hip_pg_drive_pmc_phy_sbwake_seq

`endif // `ifndef HIP_PG_DRIVE_PMC_PHY_SBWAKE_SEQ__SVH

