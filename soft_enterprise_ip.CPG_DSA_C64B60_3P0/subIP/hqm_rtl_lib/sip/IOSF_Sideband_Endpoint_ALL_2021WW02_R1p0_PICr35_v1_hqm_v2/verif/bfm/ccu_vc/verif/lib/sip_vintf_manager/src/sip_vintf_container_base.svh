//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved
// Author: melmalaki -- Created: 2010-03-17
//-----------------------------------------------------------------

`ifndef INC_SIP_VINTF_CONTAINER_BASE
`define INC_SIP_VINTF_CONTAINER_BASE

// Unparameterized base class virtual interface container, containing 
// common debug functions
// Extends object to allow having common object utils (e.g.:print)
class sip_vintf_container_base extends ovm_object;

   //------------------------------------------
   // Data Members 
   //------------------------------------------

   // File name of the setter for debugging
   protected string     file_name = "UNKNOWN"; 

   // Line number of the setter for debugging
   protected int        line_number = -1;

   // String containing vintf type name
   protected string     vintf_type_name = "UNKNOWN";

   // Has it been ever accessed?
   protected bit        accessed = 0;

   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   extern function new (string name = "");

   // APIs
   extern function string  get_vintf_type_name  ();
   extern function bit     get_accessed         ();

   // OVM macros
   `ovm_object_utils_begin (sip_vintf_pkg::sip_vintf_container_base)
      `ovm_field_string (vintf_type_name, OVM_ALL_ON)
      `ovm_field_string (file_name,       OVM_ALL_ON)
      `ovm_field_int    (line_number,     OVM_ALL_ON|OVM_DEC)
      `ovm_field_int    (accessed,        OVM_ALL_ON|OVM_BIN)
   `ovm_object_utils_end
endclass : sip_vintf_container_base

/**
 * sip_vintf_container_base Class constructor
 * @param   name  OVM name
 * @return        A new object of type sip_vintf_container_base 
 */
function sip_vintf_container_base::new(string name = "");
   super.new(name);
endfunction :new

/**
 * Accessor function for vintf type name
 * @return vintf type name
 */
function string sip_vintf_container_base::get_vintf_type_name();
   return vintf_type_name;
endfunction : get_vintf_type_name

/**
 * Accessor functions for accessed member
 * @return a flag to indicate whether this vintf have been accessed or not
 */
function bit sip_vintf_container_base::get_accessed();
   return accessed;
endfunction : get_accessed

`endif //INC_SIP_VINTF_CONTAINER_BASE

