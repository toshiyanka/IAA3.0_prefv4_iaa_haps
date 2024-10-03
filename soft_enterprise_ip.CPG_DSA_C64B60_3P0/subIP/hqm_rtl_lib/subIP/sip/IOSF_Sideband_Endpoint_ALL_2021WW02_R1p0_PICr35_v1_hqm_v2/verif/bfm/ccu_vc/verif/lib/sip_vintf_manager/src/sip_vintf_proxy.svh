//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved
// Author: melmalaki -- Created: 2010-03-17
//-----------------------------------------------------------------

`ifndef INC_SIP_VINTF_PROXY
`define INC_SIP_VINTF_PROXY

/**
 * Virtual interface manager proxy class, allowing easy, type-safe access to
 * virtual interface manager capabilities
 */
class sip_vintf_proxy #(type VINTF_TYPE = int);
  
   //------------------------------------------
   // Data Members 
   //------------------------------------------
 
   // Reference to the vintf manager
   static protected sip_vintf_manager manager; 

   // For reporting purposes
   static protected const string rpt_id = "sip_vintf_pkg::sip_vintf_proxy";

   //------------------------------------------
   // Methods 
   //------------------------------------------

   // Note1: No constructor is needed as this class should be never constructed
   // Note2: All functions are inline as most of them has parameterized types in
   //        their arguments or return types
 
   /**
    * Local helper method to get the a description string for reporting
    * @param vintf_name vintf name to used in the reporting
    * @param file_name originating file name to use in reporting (default UNKNOWN)
    * @param line_name originating line number to use in reporting (default -1)
    * @return probably formated debug string
    */
   static protected function string get_req_descr (
      string vintf_name,
      string file_name  = "UNKNOWN", 
      int line_number   = -1
   );
      // Local
      string req_descr;

      // Construct descr
      $sformat(req_descr, 
         "Request for virtual interface named \"%s\"", vintf_name);

      if (file_name != "UNKNOWN")
         req_descr = {req_descr, " initialed from ", file_name};

      if (line_number != -1)
         $sformat(req_descr, "%s[%0d]", req_descr, line_number);

      // return constructed string
      return req_descr;
   endfunction :get_req_descr

   /**
    * Main API to add new virtual interface to the virtual interface manager
    * @param vintf_name A string name to index the virtual interface under in the vintf manager
    * @param vintf_ref  A reference to the virtual interface to add to the vintf manager
    * @param file_name  The file name of the originating add request, default 
    *                   to UNKNOWN if unspecified, use `__FILE__ macro as value for this
    *                   argument in case you want to enable file/line debug info
    * @param line_number The line number where the originating add request is made,
    *                    default to -1 if unspecified, use `__LINE__ macro as value
    *                    of this argument in case you want to enable file/line 
    *                    debug info    
    */

   static function void add(
      string vintf_name, 
      VINTF_TYPE vintf_ref,
      string file_name = "UNKNOWN", 
      int line_number = -1
   );
      // Locals
      sip_vintf_container #(VINTF_TYPE) container;
      
      // Make sure manager ref is populated
      if ( ! manager)
         manager = sip_vintf_manager::get_manager();

      // Create container
      container = sip_vintf_container #(VINTF_TYPE)::wrap(
         vintf_name, vintf_ref, 
         file_name,  line_number
      );

      // Add container to manager
      manager.add(vintf_name, container);
   endfunction :add
   
   /**
    * Main API to get virtual interface reference from the virtual interface 
    * manager
    * @param vintf_name A string name to lookup the virtual interface under in the vintf manager
    * @param file_name  The file name of the originating get request, default 
    *                   to UNKNOWN if unspecified, use `__FILE__ macro as value for this
    *                   argument in case you want to enable file/line debug info
    * @param line_number The line number where the originating get request is made,
    *                    default to -1 if unspecified, use `__LINE__ macro as value
    *                    of this argument in case you want to enable file/line 
    *                    debug info    
    * @return vintf_ref  A reference of the fetched virtual interface, null
    *                    case of errors
    */ 
   static function VINTF_TYPE get(
      string vintf_name,
      string file_name  = "UNKNOWN", 
      int line_number   = -1
   );
      // Locals
      sip_vintf_container_base            container_base;
      sip_vintf_container #(VINTF_TYPE)   container;
      VINTF_TYPE                          vintf;
      string                              msg;

      // Make sure manager ref is populated
      if ( ! manager)
         manager = sip_vintf_manager::get_manager();

      // Note:
      // The following can be done in 2 simple steps, but to support debug, 
      // the steps are decoubled into more detailed steps in order to allow
      // issuing of more detailed error messages

      // Get container base
      container_base = manager.get(vintf_name);

      // Return null if no container returned (unexisting index)
      if (container_base == null) begin
         $sformat (msg, 
            "%s returned null, no virtual interface with this name exists in the virtual interface manager.",
            get_req_descr(vintf_name, file_name, line_number)
         );
         manager.ovm_report_error(rpt_id, msg);
         return null;
      end

      // Cast to actual container type, catch the case of incorrect container type
      if ( ! $cast(container, container_base) ) begin
         $sformat(
            msg, {
               "%s returned an incorrect type\n",
               "Requested Type: \"%s\", Retrieved:\n%s"
            }, 
            get_req_descr(vintf_name, file_name, line_number), 
            $typename(vintf), 
            container_base.sprint(ovm_default_line_printer)
         );
         manager.ovm_report_error(rpt_id, msg);
         return null;
      end

      // Get virtual interface
      vintf = container.get_vintf();

      // Error if vintf returned is null
      if ( ! vintf ) begin
         $sformat(
            msg, "%s returned a null interface:\n%s",
            get_req_descr(vintf_name, file_name, line_number),
            container.sprint(ovm_default_line_printer)
         );
         manager.ovm_report_error(rpt_id, msg);
      end

      // Return vintf reference
      return vintf;
   endfunction :get

endclass : sip_vintf_proxy

`endif //INC_SIP_VINTF_PROXY

