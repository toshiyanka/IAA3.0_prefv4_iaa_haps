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
//  Desc    : HIP PG sequence to wait for response on phy_pmc_sbpwr_stable
///////////////////////////////////////////////////////////////////////////////

`ifndef HIP_PG_WAIT_FOR_PHY_PMC_SBPWR_STABLE_SEQ__SVH
`define HIP_PG_WAIT_FOR_PHY_PMC_SBPWR_STABLE_SEQ__SVH

//--------------------------------------------------------------------------------
// class: hip_pg_wait_for_phy_pmc_sbpwr_stable_seq
//
// HIP PG sequence to wait for phy_pmc_sbpwr_stable
//--------------------------------------------------------------------------------
class hip_pg_wait_for_phy_pmc_sbpwr_stable_seq extends hip_pg_base_seq;

  `ovm_sequence_utils(hip_pg_wait_for_phy_pmc_sbpwr_stable_seq, hip_pg_sequencer)

  //------------------------------------------------------------------------------
  // Variables
  //------------------------------------------------------------------------------
  
  //------------------------------------------------------------------------------
  // variable: value
  //
  // Value to wait for on phy_pmc_sbpwr_stable
  //------------------------------------------------------------------------------
  rand logic value;
  
  //------------------------------------------------------------------------------
  // variable: timeout_value_ps
  //
  // Expected amount of time to wait (monitor will give up after additional time)
  //------------------------------------------------------------------------------
  rand int timeout_value_ps;

  //------------------------------------------------------------------------------
  // variable: rsp_status
  //
  // Return status from the monitor
  //------------------------------------------------------------------------------
  hip_pg::hip_pg_mon_op_t rsp_status;

  //------------------------------------------------------------------------------
  // function: new
  //------------------------------------------------------------------------------
  function new(string name="hip_pg_wait_for_phy_pmc_sbpwr_stable_seq");
    super.new(name);
  endfunction : new

  //------------------------------------------------------------------------------
  // task: body
  //
  // Purpose:
  //   Wait until phy_pmc_sbpwr_stable has expected value
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
    hip_pg_pkg::hip_pg_xaction_mon hip_pg_mon_req;
    hip_pg_pkg::hip_pg_xaction_mon hip_pg_mon_rsp;

    super.body();

    hip_pg_mon_req = hip_pg_xaction_mon::type_id::create("hip_pg_xaction_mon");
    hip_pg_mon_req.op = hip_pg::HIP_PG_MON_WAIT_FOR_PHY_PMC_SBPWR_STABLE;
    hip_pg_mon_req.value = value;
    hip_pg_mon_req.timeout_value_ps = timeout_value_ps;

    // send this transaction to the sequencer
    p_sequencer.query_mon_port.transport(hip_pg_mon_req, hip_pg_mon_rsp);
    rsp_status = hip_pg_mon_rsp.op;
  endtask : body

endclass : hip_pg_wait_for_phy_pmc_sbpwr_stable_seq

`endif // `ifndef HIP_PG_WAIT_FOR_PHY_PMC_SBPWR_STABLE_SEQ__SVH

