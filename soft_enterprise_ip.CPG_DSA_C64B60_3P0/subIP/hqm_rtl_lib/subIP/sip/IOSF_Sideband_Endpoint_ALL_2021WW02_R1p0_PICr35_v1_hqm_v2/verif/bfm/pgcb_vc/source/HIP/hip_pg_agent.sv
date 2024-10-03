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
//  Desc    : HIP PG Agent.  Contains driver, sequencer and monitor.  
//          : Driver not enabled in passive mode.
//               
///////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// class: hip_pg_agent
// HIP_PG Agent. 
//  
// Active or passive operation set with <is_active>
// 
//------------------------------------------------------------------------------
class hip_pg_agent extends ovm_agent;

   // variable: is_active
   //
   // Control properties and default values
   protected ovm_active_passive_enum is_active = OVM_ACTIVE;

   // domain_name used to be here, now can be found in config.name

   // variable: config
   //
   // Config descriptor that this agent uses
   hip_pg_config    config;

   // variable: vif_container
   //
   // Virtual interface container that this agent uses
   ovm_container #(virtual hip_pg_if) hip_pg_ifc;

   // variable: _vif
   //
   // Virtual interface that this agent uses
   virtual hip_pg_if _vif;

   hip_pg_driver    driver; 
   hip_pg_monitor   monitor;
   hip_pg_sequencer sequencer;

   `ovm_component_utils_begin(hip_pg_agent)
     `ovm_field_int   (is_active,  OVM_ALL_ON)
     `ovm_field_object(config,     OVM_ALL_ON)
     `ovm_field_object(hip_pg_ifc, OVM_ALL_ON)
   `ovm_component_utils_end


   //------------------------------------------------------------------------------
   // constructor: new
   //------------------------------------------------------------------------------
   function new (string name, ovm_component parent);
      super.new(name, parent);
   endfunction : new

   //------------------------------------------------------------------------------
   // function: build
   // Build phase
   //
   // If a passive Agent, don't build the driver.  Sequencer is built in passive
   // mode to support execution of virtual sequences
   //------------------------------------------------------------------------------
   virtual function void build();
      ovm_object obj;

      super.build();

      // is_active comes from VC-level config, domain_name is agent-level
   
      assert(get_config_int("is_active",  is_active));

      // now that we have the domain_name, get the config and the vif container
      // (VC-level config, name includes domain_name)

      assert(get_config_object("config",obj));
      assert($cast(config,obj));

      assert(get_config_object("interface",obj));
      assert($cast(hip_pg_ifc,obj));
      _vif = hip_pg_ifc.val;

      // sequencer always needed (may be used in passive mode by vseq)
      sequencer = hip_pg_sequencer::type_id::create("sequencer", this);

      // driver only needed in active mode
      if(is_active == OVM_ACTIVE) begin
         driver = hip_pg_driver::type_id::create("driver", this);
      end

      // monitor always needed
      monitor   = hip_pg_monitor::type_id::create("monitor", this);
   endfunction : build

   //------------------------------------------------------------------------------
   // function: connect
   // Connect phase
   //
   // Connect driver and monitor to sequencer.
   //------------------------------------------------------------------------------
   virtual function void connect();
      sequencer.query_mon_port.connect(monitor.query_mon_imp);
      if(is_active == OVM_ACTIVE) begin
         driver.seq_item_port.connect(sequencer.seq_item_export);
      end
   endfunction : connect

   // no run task--default functionality is fine

endclass : hip_pg_agent
