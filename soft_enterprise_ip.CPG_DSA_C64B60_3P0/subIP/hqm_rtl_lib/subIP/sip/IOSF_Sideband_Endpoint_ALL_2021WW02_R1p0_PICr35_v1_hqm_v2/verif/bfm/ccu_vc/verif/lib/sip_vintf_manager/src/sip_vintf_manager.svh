//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved
// Author: melmalaki -- Created: 2010-03-17
//-----------------------------------------------------------------

`ifndef INC_SIP_VINTF_MANAGER
`define INC_SIP_VINTF_MANAGER

/** 
 * Virtual interface manager
 * Extends ovm_component to have a context and so allow config access
 */
class sip_vintf_manager extends ovm_component;
  
   //------------------------------------------
   // Data Members 
   //------------------------------------------

   // Virtual interface container array
   protected sip_vintf_container_base data[string];

   // Singelton reference
   protected static sip_vintf_manager self = null;

   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods
   extern protected  function       new   (string name = "", ovm_component parent = null);
   extern            function void  check ();

   // APIs
   extern static  function sip_vintf_manager          get_manager();
   extern         function void                       add(string name, sip_vintf_container_base container);
   extern         function sip_vintf_container_base   get(string name);

   // OVM Macros
   // Note: We don't register sip_vintf_manager with the factory as it has 
   // a protected constructor
   // `ovm_component_utils (sip_pkg::sip_vintf_manager)

endclass : sip_vintf_manager 


/**
 * sip_vintf_manager Class constructor, protected to enforce singleton behavior
 * @param   name  OVM name
 * @return        A new object of type sip_vintf_manager 
 */
function sip_vintf_manager::new(string name = "", ovm_component parent = null);
   // super constructor
   super.new(name, parent);
endfunction : new

/**
 * Access singleton reference of the sip_vintf_manager
 * @return sla vintf manager reference
 */
function sip_vintf_manager sip_vintf_manager::get_manager();
   if (! self)
      self = new ("sip_vintf_manager", null); 

   return self;
endfunction :get_manager

/**
 * Add virtual interface container to the manager
 * @param name Name to index the vintf container under
 * @param container vintf container reference
 */
function void sip_vintf_manager::add(string name, sip_vintf_container_base container);
   // Locals
   string msg;

   // Check for override case
   if(data.exists(name)) begin
      $sformat( msg, { 
            "Overriding virtual interface entry with name \"%s\"\n",
            "Old virtual interface:\n%s\n", 
            "New virtual interface:\n%s\n" 
         }, 
         name, data[name].sprint(ovm_default_line_printer), 
         container.sprint(ovm_default_line_printer)
      );
      ovm_report_warning( get_type_name(), msg);
   end

   // Add container to manager
   data[name] = container;
endfunction :add

/**
 * Get virtual interface container from the manager
 * @param name Name of the vintf you want to get
 * @return reference to the vintf container you are trying to get
 */
function sip_vintf_container_base sip_vintf_manager::get(string name);
   // Locals
   string msg;

   // Check for unexisting case
   if(! data.exists(name)) begin
      // Error not found
      $sformat( msg, 
         "No virtual interface with name \"%s\" exists in the virtual interface manager",
         name
      );
      ovm_report_error( get_type_name(), msg);
      
      // TODO: Add typo checker

      // Return null
      return null;
   end

   return data[name];
endfunction : get

// OVM Check Phase
function void sip_vintf_manager::check();
   // Locals
   sip_vintf_container_base unaccessed[string];
   string msg;

   // Get un-accessed interfaces
   foreach (data[idx]) begin
      if (! data[idx].get_accessed())
         unaccessed[idx] = data[idx];
   end

   // Warn if virtual interfaces are added but not accessed
   if(unaccessed.num() != 0) begin
      $sformat(msg, 
         "%0d virtual interfaces added to the virtual interface manager but not accessed",
         unaccessed.num()
      );
      ovm_report_warning(get_type_name(), msg);
   end

   //Print unaccessed interfaces
   foreach (unaccessed[idx]) begin
      $sformat (msg, "Virtual interface %s, added but not accessed\n%s", 
         idx, unaccessed[idx].sprint(ovm_default_line_printer) );
      ovm_report_info(get_type_name(), msg);
   end
endfunction :check

`endif //INC_SIP_VINTF_MANAGER

