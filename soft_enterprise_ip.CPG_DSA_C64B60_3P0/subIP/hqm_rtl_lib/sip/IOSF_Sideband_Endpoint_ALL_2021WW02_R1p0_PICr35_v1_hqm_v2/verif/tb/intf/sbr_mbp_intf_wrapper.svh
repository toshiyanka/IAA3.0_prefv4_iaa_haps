
`ifndef INC_SBR_MBP_INTF_WRAPPER
`define INC_SBR_MBP_INTF_WRAPPER 

/******************************************************************************
 * Explicit interface wrapper, used for debugging 
 ******************************************************************************/

class sbr_mbp_intf_wrapper extends ovm_object;
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   virtual sbr_mbp_intf intf;
 
   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   function new (virtual sbr_mbp_intf mbp_intf);
      super.new("");
      this.intf = mbp_intf;
   endfunction 

 
  
endclass :sbr_mbp_intf_wrapper
`endif
//-------------------------------------
// Wrapper for comm_intf
//-------------------------------------
class mbp_comm_intf_wrapper extends ovm_object;
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

endclass :mbp_comm_intf_wrapper

 //INC_SBR_MBP_INTF_WRAPPER

