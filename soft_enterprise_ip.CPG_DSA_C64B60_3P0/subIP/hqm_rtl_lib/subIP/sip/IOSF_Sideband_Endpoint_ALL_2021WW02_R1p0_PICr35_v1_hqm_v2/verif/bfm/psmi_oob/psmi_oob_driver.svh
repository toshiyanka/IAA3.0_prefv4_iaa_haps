//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 11-08-2011 
//-----------------------------------------------------------------
// Description:
// Out of Band Driver class
//------------------------------------------------------------------

`ifndef IP_PSMI_OOB_DRIVER
`define IP_PSMI_OOB_DRIVER

class psmi_oob_driver extends ovm_driver #(psmi_oob_xaction);

   //------------------------------------------
   // Data Members 
   //------------------------------------------

   // Reference to virtual interface
   virtual interface psmi_oob_intf vintf;
   string intf_name;
 
   //------------------------------------------
   // Methods 
   //------------------------------------------
      
   // Standard OVM Methods
   extern function       new   (string name, ovm_component parent);
   extern function void  build ();
   extern task           run   ();

   extern local task drive_default();
   extern local task drive_xactions();
   
   
   // OVM Macros 
   `ovm_component_utils_begin (psmi_oob_driver)
   `ovm_component_utils_end
   
endclass : psmi_oob_driver

/**
* psmi_oob_drv Class constructor
* @param   name     OVM component hierarchal name
* @param   parent   OVM parent component
* @return           A new object of type psmi_oob_drv 
*/
function psmi_oob_driver::new (string name, ovm_component parent);         
   super.new (name, parent);
endfunction :new

/**
* psmi_oob_drv class OVM build phase
*/
function void psmi_oob_driver::build ();
         
   super.build ();
   event_pool = new("event_pool");

   // Get virtual interface 
   vintf = sla_resource_db #(virtual psmi_oob_intf)::get(intf_name, `__FILE__, `__LINE__);
   `ovm_info(get_type_name(), $psprintf("Using interface: %s", vintf.intfName), OVM_MEDIUM)
   
endfunction :build

/**
* psmi_oob_drv class OVM run phase
*/
task psmi_oob_driver::run ();
   psmi_oob_xaction xaction;

   //Drive default vales of the signals
   drive_default();

   //Drive transcations 
   drive_xactions();
  
endtask : run   

task psmi_oob_driver::drive_default();
   foreach (psmi_oob::sig_prop[sig]) begin
      psmi_oob::sig_prop_s prop = psmi_oob::sig_prop[sig];
      if (prop.sig_type == psmi_oob::IN ) 
          vintf.oob[sig] = prop.def_val;
   end
endtask

task psmi_oob_driver::drive_xactions();
    psmi_oob_xaction xaction;

    forever begin
      seq_item_port.get_next_item(xaction);
      `ovm_info (get_type_name(),$psprintf("Receiving Request:\n%s", xaction.sprint()),OVM_HIGH)
      if (xaction.cmd == psmi_oob::SET)
          vintf.oob[xaction.sig] = xaction.data;
      else
          xaction.data = vintf.oob[xaction.sig];
            
      seq_item_port.item_done();
    end
endtask   
    
`endif //IP_PSMI_OOB_DRIVER      
