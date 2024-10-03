//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 15-08-2011 
//-----------------------------------------------------------------
// Description:
// Out of Band Monitor
//------------------------------------------------------------------
`ifndef IP_PSMI_OOB_MON
 `define IP_PSMI_OOB_MON

/**
* Forward defs
*/
typedef class psmi_oob_agent;

class psmi_oob_monitor extends ovm_monitor;
      //------------------------------------------
      // Data Members 
      //------------------------------------------

      // Interface
      virtual interface psmi_oob_intf vintf;

      psmi_oob_cfg psmi_oob_config;
      string intf_name;
      ovm_analysis_port #(psmi_oob_xaction) analysis_port;
      ovm_event sig_event; 
   
      // Standard OVM Methods   
      extern function       new   (string name, ovm_component parent); 
      extern function void  build ();
      extern task           run ();
   
      extern task monitor_change();   

      // OVM Macros 
      `ovm_component_utils_begin(psmi_oob_monitor)
      `ovm_component_utils_end  
endclass :psmi_oob_monitor
      
/**
* psmi_oob_monitor Class constructor
* @param   name     OVM component hierarchal name
* @param   parent   OVM parent component
* @return           A new object of type psmi_oob_monitor 
*/
function psmi_oob_monitor::new (string name, ovm_component parent);
   super.new (name, parent);
endfunction : new

/**
* psmi_oob_monitor class OVM build phase
*/
function void psmi_oob_monitor:: build ();
   // Super builder
   super.build ();    
   analysis_port = new("analysis_port", this);
   
   // Get virtual interface 
   vintf = sla_resource_db #(virtual psmi_oob_intf)::get(intf_name, `__FILE__, `__LINE__);
   `ovm_info(get_type_name(), $psprintf("Using interface: %s", vintf.intfName), OVM_MEDIUM)  
endfunction : build

/*
* psmi_oob_monitor class OVM run phase
*/
task psmi_oob_monitor::run();
      
   monitor_change();

endtask


task psmi_oob_monitor::monitor_change();   

    psmi_oob::data_t psmi_oob_val[psmi_oob::sig_e],data_change;    
    psmi_oob::sig_e sig;
    psmi_oob::sig_e xaction_sig = xaction_sig.first();
    psmi_oob_xaction xaction;
    ovm_printer printer;   
   //string sig_names;   
   
    // Initiate psmi_oob array to defaults
    #0;
    foreach (vintf.oob[sig])begin
  //  for (sig = sig.first(); sig <= sig.last(); sig = sig.next() )    begin      
      psmi_oob_val[sig] = vintf.oob[sig];
     // $display("enum_type (%1s)", sig.name());      
    end
    
         
    // Monitor loop
    forever begin
       // Wait until change happens in the interface
       @(vintf.oob);

       // Fire change events/Update psmi_oob array
       foreach (psmi_oob_val[sig]) begin
          if ( psmi_oob_val[sig] != vintf.oob[sig] ) begin
           // Fire change event for each signal change
              sig_event = psmi_oob_agent::event_pool.get(psmi_oob::get_event_name(sig, psmi_oob::CHANGE));
              sig_event.trigger();

              // Additionally, if signal width is 1 fire Rising/Falling events
              if (psmi_oob::sig_prop[sig].width == 1) begin
                  if (vintf.oob[sig] == 1)begin
                      sig_event = psmi_oob_agent::event_pool.get(psmi_oob::get_event_name(sig, psmi_oob::R_EDGE));
                  end   
                  else begin
                      sig_event = psmi_oob_agent::event_pool.get(psmi_oob::get_event_name(sig, psmi_oob::F_EDGE));
                  end 
                  sig_event.trigger();
           //       sig_event.do_print(printer);                 
                 
              end

              // Update psmi_oob array
              psmi_oob_val[sig] = vintf.oob[sig];
              data_change = psmi_oob_val[sig];            
              xaction_sig = sig;
             
              
              xaction = psmi_oob_xaction::type_id::create("xaction");             
              xaction.data = data_change;
              xaction.sig = xaction_sig;
              //xaction.randomize with{
              //   data   == data_change; 
              //   sig    == xaction_sig;
              //};
              //$display("sig name %s : %h\n", xaction.sig.name, xaction.data);
              analysis_port.write(xaction);
   
          end // if signal change
       end

    end // forever begin
endtask : monitor_change  

`endif //  `ifndef IP_PSMI_OOB_MON

