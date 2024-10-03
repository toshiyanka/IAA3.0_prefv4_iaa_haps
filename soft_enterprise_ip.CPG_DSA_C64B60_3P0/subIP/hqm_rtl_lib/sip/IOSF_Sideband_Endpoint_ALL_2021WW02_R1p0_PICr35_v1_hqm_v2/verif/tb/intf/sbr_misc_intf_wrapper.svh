
`ifndef INC_SBR_MISC_INTF_WRAPPER
`define INC_SBR_MISC_INTF_WRAPPER 

/******************************************************************************
 * Explicit interface wrapper, used for debugging 
 ******************************************************************************/

class sbr_misc_intf_wrapper extends ovm_object;
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   virtual sbr_misc_intf intf;
 
   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   function new (virtual sbr_misc_intf misc_intf);
      super.new("");
      this.intf = misc_intf;
   endfunction 

 
  
endclass :sbr_misc_intf_wrapper
`endif
//-------------------------------------
// Wrapper for comm_intf
//-------------------------------------
class misc_comm_intf_wrapper extends ovm_object;
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   virtual comm_intf intf;
 
   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   function new (virtual comm_intf intf);
      super.new("");
      this.intf = intf;
   endfunction 

endclass :misc_comm_intf_wrapper

 //INC_SBR_MISC_INTF_WRAPPER

