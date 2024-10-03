//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 15-08-2011 
//-----------------------------------------------------------------
// Description:
// Out of Band Monitor
//------------------------------------------------------------------
`ifndef IP_OB_MON
 `define IP_OB_MON

/**
* Forward defs
*/
typedef class ccu_ob_agent;

class ccu_ob_monitor extends ovm_monitor;
      //------------------------------------------
      // Data Members 
      //------------------------------------------

      // Interface
      virtual interface ccu_ob_intf vintf;

      ccu_ob_cfg ccu_ob_config;
      ovm_analysis_port #(ccu_ob_xaction) analysis_port;
      ovm_event sig_event; 
   
      // Standard OVM Methods   
      extern function       new   (string name, ovm_component parent); 
      extern function void  build ();
      extern task           run ();
   
      extern task monitor_change();   

      // OVM Macros 
      `ovm_component_utils_begin(ccu_ob_monitor)
      `ovm_component_utils_end  
endclass :ccu_ob_monitor
      
/**
* ccu_ob_monitor Class constructor
* @param   name     OVM component hierarchal name
* @param   parent   OVM parent component
* @return           A new object of type ccu_ob_monitor 
*/
function ccu_ob_monitor::new (string name, ovm_component parent);
   super.new (name, parent);
endfunction : new

/**
* ccu_ob_monitor class OVM build phase
*/
function void ccu_ob_monitor:: build ();
  	sla_pkg::sla_vif_container #(virtual ccu_ob_intf) slaAgentIFContainer;
	ovm_object tmpPtrToAgentIFContainer;

   // Super builder
   super.build ();    
   analysis_port = new("analysis_port", this);
   
   // Get virtual interface 
   assert (get_config_object("ccu_ob_if_container", tmpPtrToAgentIFContainer));
   assert ($cast(slaAgentIFContainer, tmpPtrToAgentIFContainer)) begin
	   vintf = slaAgentIFContainer.get_v_if();
   end

   `ovm_info(get_type_name(), $psprintf("Using interface: %s", vintf.intfName), OVM_MEDIUM)  
endfunction : build

/*
* ccu_ob_monitor class OVM run phase
*/
task ccu_ob_monitor::run();
      
   monitor_change();

endtask


task ccu_ob_monitor::monitor_change();   

    ccu_ob::data_t ccu_ob_val[ccu_ob::sig_e],data_change;    
    ccu_ob::sig_e sig;
    ccu_ob::sig_e xaction_sig = xaction_sig.first();
    ccu_ob_xaction xaction;
    ovm_printer printer;   
   //string sig_names;   
   
    // Initiate ob array to defaults
    #0;
    foreach (vintf.ob[sig])begin
  //  for (sig = sig.first(); sig <= sig.last(); sig = sig.next() )    begin      
      ccu_ob_val[sig] = vintf.ob[sig];
     // $display("enum_type (%1s)", sig.name());      
    end
    
         
    // Monitor loop
    forever begin
       // Wait until change happens in the interface
       @(vintf.ob);

       // Fire change events/Update ob array
       foreach (ccu_ob_val[sig]) begin
          if ( ccu_ob_val[sig] != vintf.ob[sig] ) begin
           // Fire change event for each signal change
              sig_event = ccu_ob_agent::event_pool.get(ccu_ob::get_event_name(sig, ccu_ob::CHANGE));
              sig_event.trigger();

              // Additionally, if signal width is 1 fire Rising/Falling events
              if (ccu_ob::sig_prop[sig].width == 1) begin
                  if (vintf.ob[sig] == 1)begin
                      sig_event = ccu_ob_agent::event_pool.get(ccu_ob::get_event_name(sig, ccu_ob::R_EDGE));
                  end   
                  else begin
                      sig_event = ccu_ob_agent::event_pool.get(ccu_ob::get_event_name(sig, ccu_ob::F_EDGE));
                  end 
                  sig_event.trigger();
           //       sig_event.do_print(printer);                 
                 
              end

              // Update ob array
              ccu_ob_val[sig] = vintf.ob[sig];
              data_change = ccu_ob_val[sig];            
              xaction_sig = sig;
			  if(xaction_sig.name == "clkreq") data_change = bit'(ccu_ob_val[sig]);
             
              //`ovm_info("OOB MON", $psprintf("sig name %s : %h data_change: %h\n", xaction_sig.name, xaction_sig,
			  //	  data_change ), OVM_INFO);
             
              xaction = ccu_ob_xaction::type_id::create("xaction");             
              xaction.randomize with{
                 data   == data_change; 
                 sig    == xaction_sig;
              };
              analysis_port.write(xaction);
   
              //`ovm_info("OOB MON", $psprintf("\n %s \n", xaction.sprint() ), OVM_INFO);
          end // if signal change
       end

    end // forever begin
endtask : monitor_change  

`endif //  `ifndef IP_OB_MON

