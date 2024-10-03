//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 11-08-2011 
//-----------------------------------------------------------------
// Description:
// Out of Band Agent
//------------------------------------------------------------------


`ifndef IP_PSMI_OOB_agt
`define IP_PSMI_OOB_agt 

class psmi_oob_agent extends ovm_agent;

   //------------------------------------------
   // Data Members 
   //------------------------------------------

   psmi_oob_seqr          psmi_oob_seqncr;
   psmi_oob_driver        psmi_oob_drv;
   psmi_oob_monitor       psmi_oob_mon;
   psmi_oob_cfg           psmi_oob_config; 
   ovm_analysis_port  #(psmi_oob_xaction) psmi_oob_port;
   static ovm_event_pool      event_pool;
   local bit m_active;       
      
   // Standard OVM Methods 
   extern function       new     (string name = "", ovm_component parent = null);
   extern function void  build   ();
   extern function void  connect ();
   extern function psmi_oob_seqr get_sequencer();
   
 
   // OVM Macros 
   `ovm_component_utils_begin (psmi_oob_agent)
    `ovm_field_int    (m_active, OVM_ALL_ON)
   `ovm_component_utils_end
endclass :psmi_oob_agent

/**
* psmi_oob_agent Class constructor
* @param   name     OVM component hierarchal name
* @param   parent   OVM parent component
* @return           A new object of type ip_psmi_oob_agent 
*/
function psmi_oob_agent::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

function psmi_oob_seqr psmi_oob_agent::get_sequencer();
   return psmi_oob_seqncr;
endfunction :get_sequencer

/**
* psmi_oob_agent class OVM build phase
*/
function void psmi_oob_agent::build ();

   ovm_object psmi_oob_cfg_obj;
   
   // Super builder
   // -------------
   super.build ();
   event_pool = new("event_pool");
   
   if (!get_config_object("psmi_oob_cfg", psmi_oob_cfg_obj, 0))
     `ovm_fatal("psmi_oob_agent", "Configuration object of PSMI_OOB not found")

   if (!($cast(psmi_oob_config, psmi_oob_cfg_obj)))
     `ovm_fatal("psmi_oob_agent", "Type mismatch while casting psmi_oob_cfg object")
   psmi_oob_port = new ("psmi_oob_port",this)    ;   
   
   m_active = psmi_oob_config.is_active;
   
   // active components
   if (  m_active == OVM_ACTIVE)begin
      psmi_oob_seqncr = new("psmi_oob_seqncr", this);
      psmi_oob_drv = psmi_oob_driver::type_id::create("psmi_oob_driver", this);
      psmi_oob_drv.intf_name = psmi_oob_config.intf_name;
   end   
   // monitor
   psmi_oob_mon = psmi_oob_monitor::type_id::create("psmi_oob_monitor", this) ;
   psmi_oob_mon.intf_name = psmi_oob_config.intf_name;

   // Register events
   foreach (psmi_oob::sig_prop[sig]) begin
      psmi_oob::sig_prop_s prop = psmi_oob::sig_prop[sig];
      if ( prop.width == 1 ) begin
         void'(event_pool.get(psmi_oob::get_event_name(sig, psmi_oob::R_EDGE)));
         void'(event_pool.get(psmi_oob::get_event_name(sig, psmi_oob::F_EDGE)));
      end
      void'(event_pool.get(psmi_oob::get_event_name(sig, psmi_oob::CHANGE)));
   end        
   
endfunction:build

/**
* psmi_oob_agent class OVM build phase
*/
function void psmi_oob_agent::connect ();

 if(m_active == OVM_ACTIVE) begin
   // Connect seqr to drv
   psmi_oob_drv.seq_item_port.connect(psmi_oob_seqncr.seq_item_export);
 end

   psmi_oob_port.connect(psmi_oob_mon.analysis_port);   
endfunction :connect 
      

`endif //psmi_oob_agent
