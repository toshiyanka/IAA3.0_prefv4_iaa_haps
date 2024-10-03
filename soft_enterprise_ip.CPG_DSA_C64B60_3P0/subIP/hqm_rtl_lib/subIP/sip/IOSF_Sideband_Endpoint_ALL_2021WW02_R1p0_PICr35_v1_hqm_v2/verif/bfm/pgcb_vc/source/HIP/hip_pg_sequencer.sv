///////////////////////////////////////////////////////////////////////////////
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
//  Date    : November 4, 2013
//  Desc    : HIP PG Sequencer
//
///////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// class: hip_pg_sequencer
// HIP PG Sequencer
//------------------------------------------------------------------------------
class hip_pg_sequencer extends ovm_sequencer #(hip_pg_xaction);

   // port: query_mon_port
   // TLM port to query hip_pg_monitor
   ovm_blocking_transport_port#(hip_pg_xaction_mon,hip_pg_xaction_mon) query_mon_port;

   // variable: domain_num
   //
   // Power domain number to which this agent is assigned
   protected int unsigned domain_num = 0;

   // variable: config
   //
   // Config descriptor for agent.  Sequences need timing parameters from cfg, and
   // sequencer updates power domain states as test progresses.
   hip_pg_config config;

   `ovm_sequencer_utils_begin(hip_pg_sequencer)
     `ovm_field_int   (domain_num, OVM_ALL_ON)
     `ovm_field_object(config,     OVM_ALL_ON)
   `ovm_sequencer_utils_end

   //------------------------------------------------------------------------------
   // constructor: new
   //------------------------------------------------------------------------------
   function new (string name = "hip_pg_sequencer", ovm_component parent = null) ;
     super.new (name, parent);
     `ovm_update_sequence_lib_and_item(hip_pg_xaction)
     query_mon_port = new("query_mon_port", this);
   endfunction : new

  //---------------------------------------------------------------------------
  // function: build
  //
  // Purpose:
  //   Standard build function
  //
  // Inputs:
  //   None
  //
  // Returns:
  //
  // Depends on:
  //
  // Modifies:
  //
  //---------------------------------------------------------------------------
  virtual function void build();
    hip_pg_agent agent;

    super.build();

    // get handle to virtual interface from agent
    $cast(agent, get_parent());
    config = agent.config;
  endfunction : build

endclass : hip_pg_sequencer
