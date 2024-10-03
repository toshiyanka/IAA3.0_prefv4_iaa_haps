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
//  Desc    : HIP PG sequence to drive soc_phy_pwr_req
///////////////////////////////////////////////////////////////////////////////

`ifndef HIP_PG_SOC_PHY_PWR_REQ_SEQ__SVH
`define HIP_PG_SOC_PHY_PWR_REQ_SEQ__SVH

//--------------------------------------------------------------------------------
// class: hip_pg_drive_soc_phy_pwr_req_seq
//
// Sequence to drive a value to soc_phy_pwr_req
//--------------------------------------------------------------------------------
class hip_pg_drive_soc_phy_pwr_req_seq extends hip_pg_base_seq;

  `ovm_sequence_utils(hip_pg_drive_soc_phy_pwr_req_seq, hip_pg_sequencer)

  //------------------------------------------------------------------------------
  // Variables
  //------------------------------------------------------------------------------
  
  //------------------------------------------------------------------------------
  // variable: value
  //
  // Value to drive to soc_phy_pwr_req
  //------------------------------------------------------------------------------
  rand logic value;

  //------------------------------------------------------------------------------
  // function: new
  //------------------------------------------------------------------------------
  function new(string name="soc_phy_pwr_req_seq");
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
    hip_pg_x.op = hip_pg::HIP_PG_SOC_PHY_PWR_REQ;
    hip_pg_x.value = value;
    `ovm_send(hip_pg_x);

  endtask : body

endclass : hip_pg_drive_soc_phy_pwr_req_seq

`endif // `ifndef HIP_PG_DRIVE_SOC_PHY_PWR_REQ_SEQ__SVH

