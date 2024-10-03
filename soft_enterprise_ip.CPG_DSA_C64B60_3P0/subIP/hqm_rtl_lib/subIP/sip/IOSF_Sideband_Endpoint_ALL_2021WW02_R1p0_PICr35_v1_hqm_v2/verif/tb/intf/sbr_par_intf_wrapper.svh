
`ifndef INC_SBR_PAR_INTF_WRAPPER
`define INC_SBR_PAR_INTF_WRAPPER 

/******************************************************************************
 * Explicit interface wrapper, used for debugging 
 ******************************************************************************/

class sbr_par_intf_wrapper extends ovm_object;
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   virtual sbr_par_intf intf;
 
   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   function new (virtual sbr_par_intf par_intf);
      super.new("");
      this.intf = par_intf;
   endfunction 

 
  
endclass :sbr_par_intf_wrapper
`endif
//-------------------------------------
// Wrapper for comm_intf
//-------------------------------------
class par_comm_intf_wrapper extends ovm_object;
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

endclass :par_comm_intf_wrapper

 //INC_SBR_PAR_INTF_WRAPPER

