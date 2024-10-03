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
//  Date    : November 7, 2013
//  Desc    : HIP PG VC.  This is an array-based wrapper around hip_pg_agent,
//  	      allowing a single VC instantiation to handle multiple domains.
//               
///////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// class: hip_pg_vc
// HIP_PG VC. 
//  
// Active or passive operation set with <is_active>
// 
//------------------------------------------------------------------------------
class hip_pg_vc extends ovm_agent;

  // variable: is_active
  //
  // Control properties and default values
  protected ovm_active_passive_enum is_active = OVM_ACTIVE;

  // variable: ifc_list
  //
  // list of all interfaces referenced in hip_pg_ti instantiations
  static ovm_container #(virtual hip_pg_if) ifc_list[string];

  // variable: config
  //
  // VC-level config object
  hip_pg_vc_config vc_config;

  // variable: config_list
  //
  // list of all domain-level configs for this hip_pg_vc instantiation
  hip_pg_config config_list[string];


  hip_pg_agent                      agents[string];


  `ovm_component_utils_begin(hip_pg_vc)
    `ovm_field_int   (is_active,OVM_ALL_ON)
    `ovm_field_object(vc_config,OVM_ALL_ON)
  `ovm_component_utils_end

   //------------------------------------------------------------------------------
   // constructor: new
   //------------------------------------------------------------------------------
   function new (string name, ovm_component parent);
      super.new(name, parent);
   endfunction : new

   //------------------------------------------------------------------------------
   // public function to build if_list
   //------------------------------------------------------------------------------
   static function void set_ifc(ovm_container #(virtual hip_pg_if) ifc);
     ifc_list[ifc.name] = ifc;
   endfunction

   //------------------------------------------------------------------------------
   // public function to get sequencer by domain name
   //------------------------------------------------------------------------------
   function hip_pg_sequencer get_sequencer(string domain_name);
     if (agents.exists(domain_name)) return agents[domain_name].sequencer;
     else return null;
   endfunction


   //------------------------------------------------------------------------------
   // function: build
   // Build phase
   //------------------------------------------------------------------------------
   virtual function void build();
     int found_interface;
     ovm_object tmp;
     ovm_container #(virtual hip_pg_if) hip_pg_ifc;

//     print_config_settings();

     // get config objects, throw error if either fails
     assert(get_config_int   ("is_active",is_active));
     assert(get_config_object("config",   tmp));
     assert($cast(vc_config,tmp));
     config_list = vc_config.configs;

     // for each config in config_list, create an agent, set up its domain-level config,
     // then search the ifc_list to find the matching interface container and set up
     // its interface config object

     foreach (config_list[domain_name]) begin
       agents[domain_name] = hip_pg_agent::type_id::create($psprintf("agents[%0s]",domain_name),this);

       set_config_object($psprintf("agents[%0s]*",domain_name),"config",config_list[domain_name],0);

       if (!ifc_list.exists(domain_name)) begin
         `ovm_error("HIP_PG_VC","Not all domain config descriptors successfully associated with interfaces");
       end

       hip_pg_ifc = new();
       hip_pg_ifc = ifc_list[domain_name];
       ifc_list.delete(domain_name);
       set_config_object($psprintf("agents[%0s]*",domain_name),"interface",hip_pg_ifc,0);
     end

     if (ifc_list.size() != 0) begin
       `ovm_warning("HIP_PG_VC","Not all interfaces successfully associated with domain config descriptors");
     end

     // todo: check that ifc_list is empty by this point
   endfunction : build

endclass : hip_pg_vc