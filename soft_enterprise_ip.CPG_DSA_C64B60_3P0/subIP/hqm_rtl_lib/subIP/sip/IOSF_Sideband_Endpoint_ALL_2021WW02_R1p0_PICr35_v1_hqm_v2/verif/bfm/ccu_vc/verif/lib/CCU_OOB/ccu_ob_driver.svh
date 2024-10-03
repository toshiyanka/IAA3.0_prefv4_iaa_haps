//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 11-08-2011 
//-----------------------------------------------------------------
// Description:
// Out of Band Driver class
//------------------------------------------------------------------

`ifndef IP_OB_DRIVER
`define IP_OB_DRIVER

class ccu_ob_driver extends ovm_driver #(ccu_ob_xaction);

   //------------------------------------------
   // Data Members 
   //------------------------------------------

   // Reference to virtual interface
   virtual interface ccu_ob_intf vintf;
   ccu_ob_cfg ccu_ob_config;  
 
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
   `ovm_component_utils_begin (ccu_ob_driver)
   `ovm_component_utils_end
   
endclass : ccu_ob_driver

/**
* ccu_ob_drv Class constructor
* @param   name     OVM component hierarchal name
* @param   parent   OVM parent component
* @return           A new object of type ccu_ob_drv 
*/
function ccu_ob_driver::new (string name, ovm_component parent);         
   super.new (name, parent);
endfunction :new

/**
* ccu_ob_drv class OVM build phase
*/
function void ccu_ob_driver::build ();
   sla_pkg::sla_vif_container #(virtual ccu_ob_intf) slaAgentIFContainer;
   ovm_object tmpPtrToAgentIFContainer;
   ovm_object ccu_ob_cfg_obj;
         
   super.build ();
   event_pool = new("event_pool");

   // Get configuration
   // -----------------
   assert (get_config_object("ccu_ob_cfg", ccu_ob_cfg_obj));
   assert ($cast(ccu_ob_config , ccu_ob_cfg_obj));

   // Get virtual interface 
   assert (get_config_object("ccu_ob_if_container", tmpPtrToAgentIFContainer));
   assert ($cast(slaAgentIFContainer, tmpPtrToAgentIFContainer)) begin
	   vintf = slaAgentIFContainer.get_v_if();
   end
	  
   `ovm_info(get_type_name(), $psprintf("Using interface: %s", vintf.intfName), OVM_MEDIUM)
   
endfunction :build

/**
* ccu_ob_drv class OVM run phase
*/
task ccu_ob_driver::run ();
   ccu_ob_xaction xaction;

   //Drive default vales of the signals
   drive_default();

   //Drive transcations 
   drive_xactions();
  
endtask : run   

task ccu_ob_driver::drive_default();
   foreach (ccu_ob::sig_prop[sig]) begin
      ccu_ob::sig_prop_s prop = ccu_ob::sig_prop[sig];
      if (prop.sig_type == ccu_ob::IN && sig !== ccu_ob::clkack) 
          vintf.ob[sig] = prop.def_val;
	  else if(sig == ccu_ob::clkack && prop.sig_type == ccu_ob::IN)
		  vintf.ob[sig] = ccu_ob_config.clkack_def_val;
   end
endtask

task ccu_ob_driver::drive_xactions();
    ccu_ob_xaction xaction;

    forever begin
      seq_item_port.get_next_item(xaction);
      //`ovm_info (get_type_name(),$psprintf("Receiving Request:\n%s", xaction.sprint()),OVM_HIGH)
      if (xaction.cmd == ccu_ob::SET && xaction.sig inside {ccu_ob::clkreq, ccu_ob::clkack, ccu_ob::usync})
          vintf.ob[xaction.sig][xaction.slice_num] = xaction.data[xaction.slice_num];
      else if(xaction.cmd == ccu_ob::SET && xaction.sig inside {ccu_ob::g_usync})
		  vintf.ob[xaction.sig] = xaction.data;
	  else
          xaction.data = vintf.ob[xaction.sig];
            
      seq_item_port.item_done();
      `ovm_info (get_type_name(),$psprintf("Item Done:\n%s", xaction.sprint()),OVM_HIGH)
    end
endtask   
    
`endif //IP_OB_DRIVER      
