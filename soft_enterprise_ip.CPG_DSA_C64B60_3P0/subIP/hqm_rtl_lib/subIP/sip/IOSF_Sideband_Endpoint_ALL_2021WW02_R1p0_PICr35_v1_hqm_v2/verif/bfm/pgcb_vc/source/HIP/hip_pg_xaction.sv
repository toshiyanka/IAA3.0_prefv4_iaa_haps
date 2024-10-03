//------------------------------------------------------------------------------
//  Copyright (c)
//  2010 Intel Corporation, all rights reserved.
//
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY
//  PROTECTED BY COPYRIGHT LAWS AND IS CONSIDERED A
//  TRADE SECRET BELONGING TO THE INTEL CORPORATION.
//--------------------------------------------------------------------------------
//
//  Author  : Bill Bradley
//  Email   : william.l.bradley@intel.com
//  Date    : November 4, 2013
//  Desc    : HIP PG Driver Transaction and set of constraints.
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// class: hip_pg_xaction
// 
// HIP PG Driver Transaction
//--------------------------------------------------------------------------------
class hip_pg_xaction extends ovm_sequence_item;

  //------------------------------------------------------------------------------
  // variable: op
  //
  // Operation being performed by this xaction.  Generally refers to which
  // signals needs to be updated.
  //------------------------------------------------------------------------------
  rand hip_pg::hip_pg_op_t op;
  
  //------------------------------------------------------------------------------
  // variable: value
  //
  // Value related to the operation.  Generally refers to value to be driver
  // to the signal.
  //------------------------------------------------------------------------------
  rand logic value;


  //------------------------------------------------------------------------------
  // Random Variables
  //------------------------------------------------------------------------------
  //
  // NONE


  //------------------------------------------------------------------------------
  // Constraints
  //------------------------------------------------------------------------------
  //
  // NONE
  

  `ovm_object_utils_begin(hip_pg_xaction)
    `ovm_field_enum       (hip_pg::hip_pg_op_t, op,    OVM_DEFAULT)
    `ovm_field_int        (                     value, OVM_DEFAULT)
  `ovm_object_utils_end


  //----------------------------------------------------------------------------
  // Function: new
  //
  // Description:
  //   Creates a new instance of this type giving it the optional ~name~.
  //
  // Inputs:
  //  name - Instance name for this class
  //
  // Returns:
  //   void
  //----------------------------------------------------------------------------
  function new(string name="hip_pg_xaction");
    super.new(name);
  endfunction: new
  
endclass: hip_pg_xaction
