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
//  Desc    : HIP PG sequence to drive forcePwrGatePOK
///////////////////////////////////////////////////////////////////////////////

`ifndef HIP_PG_FORCEPWRGATEPOK_SEQ__SVH
`define HIP_PG_FORCEPWRGATEPOK_SEQ__SVH

//--------------------------------------------------------------------------------
// class: hip_pg_drive_forcePwrGatePOK_seq
//
// Sequence to drive a value to forcePwrGatePOK
//--------------------------------------------------------------------------------
class hip_pg_drive_forcePwrGatePOK_seq extends hip_pg_base_seq;

  `ovm_sequence_utils(hip_pg_drive_forcePwrGatePOK_seq, hip_pg_sequencer)

  //------------------------------------------------------------------------------
  // Variables
  //------------------------------------------------------------------------------
  
  //------------------------------------------------------------------------------
  // variable: value
  //
  // Value to drive to forcePwrGatePOK
  //------------------------------------------------------------------------------
  rand logic value;

  //------------------------------------------------------------------------------
  // function: new
  //------------------------------------------------------------------------------
  function new(string name="forcePwrGatePOK_seq");
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
    hip_pg_x.op = hip_pg::HIP_PG_FORCEPWRGATEPOK;
    hip_pg_x.value = value;
    `ovm_send(hip_pg_x);

  endtask : body

endclass : hip_pg_drive_forcePwrGatePOK_seq

`endif // `ifndef HIP_PG_DRIVE_FORCEPWRGATEPOK_SEQ__SVH

