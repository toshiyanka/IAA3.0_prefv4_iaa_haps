//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved
// Author: melmalaki -- Created: 2010-03-17
//-----------------------------------------------------------------

`ifndef INC_SIP_VINTF_CONTAINER
`define INC_SIP_VINTF_CONTAINER

/**
 * Virtual interface container, specialized to interface type
 * Contains actual virtual interface access methods
 */
class sip_vintf_container #(type VINTF_TYPE = int) extends sip_vintf_container_base;
  
   //------------------------------------------
   // Data Members 
   //------------------------------------------

   // Embedded "this_type" for convenience
   typedef sip_vintf_container #(VINTF_TYPE) this_type;

   // Virtual interface reference
   protected VINTF_TYPE vintf;

   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   extern function new (string name = "");

   // APIs

   /**
    * Accessor to set vintf ref in the container
    * Note: Inline as it has a parameterized type argument 
    * @param vintf      Virtual interface reference
    * @param file_name  (Optional) file name file name of the caller for debugging
    * @param lin_number (Optional) line number of the caller for debugging
    */
   function void set_vintf(
      VINTF_TYPE vintf, 
      string file_name = "UNKNOWN", 
      int line_number  = -1
   );
      this.vintf           = vintf;
      this.file_name       = file_name;
      this.line_number     = line_number;
      this.accessed        = 0;
   endfunction :set_vintf

   /** 
    * Accessor to get vintf ref in the container
    * Note: Inline as it has a parameterized type as return type
    * @return virtual interface reference
    */
   function VINTF_TYPE get_vintf();
      // Flag that the interface was accessed
      accessed = 1;

      // Return virtual interface reference
      return vintf;
   endfunction :get_vintf

   /**
    * Factory method to create the container and set the interface at one step
    * Note: Inline as it has a parameterized type as the return type 
    * @param name       Name of the virtual interface
    * @param vintf      Virtual interface reference
    * @param file_name  (Optional) file name file name of the caller for debugging
    * @param lin_number (Optional) line number of the caller for debugging
    */
   static function this_type wrap (
      string name, 
      VINTF_TYPE vintf, 
      string file_name = "", 
      int line_number = -1
   );
      this_type wrapper = new(name);
      wrapper.set_vintf(vintf, file_name, line_number);
      return wrapper;
   endfunction

   // OVM macros
   `ovm_object_param_utils(sip_vintf_container #(VINTF_TYPE))

endclass: sip_vintf_container

/**
 * sip_vintf_container Class constructor
 * @param   name  OVM name
 * @return        A new object of type sip_vintf_container 
 */
function sip_vintf_container::new (string name = "");
   // Super constructor
   super.new (name);

   // Init vintf type name (used for debugging)
   vintf_type_name = $typename(vintf);
endfunction :new

`endif //INC_SIP_VINTF_CONTAINER

