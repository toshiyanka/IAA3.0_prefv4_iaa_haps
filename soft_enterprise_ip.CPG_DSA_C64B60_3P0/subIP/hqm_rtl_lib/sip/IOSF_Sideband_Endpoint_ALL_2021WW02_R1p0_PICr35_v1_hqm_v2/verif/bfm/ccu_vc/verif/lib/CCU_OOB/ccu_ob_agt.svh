//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 11-08-2011 
//-----------------------------------------------------------------
// Description:
// Out of Band Agent
//------------------------------------------------------------------


`ifndef IP_OB_agt
`define IP_OB_agt 

class ccu_ob_agent extends ovm_agent;

   //------------------------------------------
   // Data Members 
   //------------------------------------------

   ccu_ob_seqr          ccu_ob_seqncr;
   ccu_ob_driver        ccu_ob_drv;
   ccu_ob_monitor       ccu_ob_mon;
   ccu_ob_cfg           ccu_ob_config; 
   ovm_analysis_port  #(ccu_ob_xaction) ccu_ob_port;
   static ovm_event_pool      event_pool;
   local bit m_active;       
      
   // Standard OVM Methods 
   extern function       new     (string name = "", ovm_component parent = null);
   extern function void  build   ();
   extern function void  connect ();
   extern function ccu_ob_seqr get_sequencer();
   
 
   // OVM Macros 
   `ovm_component_utils_begin (ccu_ob_agent)
    `ovm_field_int    (m_active, OVM_ALL_ON)
   `ovm_component_utils_end
endclass :ccu_ob_agent

/**
* ccu_ob_agent Class constructor
* @param   name     OVM component hierarchal name
* @param   parent   OVM parent component
* @return           A new object of type ip_ccu_ob_agent 
*/
function ccu_ob_agent::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

function ccu_ob_seqr ccu_ob_agent::get_sequencer();
   return ccu_ob_seqncr;
endfunction :get_sequencer

/**
* ccu_ob_agent class OVM build phase
*/
function void ccu_ob_agent::build ();

   ovm_object ccu_ob_cfg_obj;
   
   // Super builder
   // -------------
   super.build ();
   event_pool = new("event_pool");
   
   if (!get_config_object("ccu_ob_cfg", ccu_ob_cfg_obj, 0))
     `ovm_fatal("ccu_ob_agent", "Configuration object of CCU_OOB not found")

   if (!($cast(ccu_ob_config, ccu_ob_cfg_obj)))
     `ovm_fatal("ccu_ob_agent", "Type mismatch while casting ccu_ob_cfg object")
   
   m_active = ccu_ob_config.is_active;
   
   // active components
   if (  m_active == OVM_ACTIVE)begin
      ccu_ob_seqncr = new("ccu_ob_seqncr", this);
      ccu_ob_drv = ccu_ob_driver::type_id::create("ccu_ob_driver", this);
   end   
   // monitor
   ccu_ob_mon = ccu_ob_monitor::type_id::create("ccu_ob_monitor", this) ;
   ccu_ob_port = new("ccu_ob_port", this);

   // Register events
   foreach (ccu_ob::sig_prop[sig]) begin
      ccu_ob::sig_prop_s prop = ccu_ob::sig_prop[sig];
      if ( prop.width == 1 ) begin
         void'(event_pool.get(ccu_ob::get_event_name(sig, ccu_ob::R_EDGE)));
         void'(event_pool.get(ccu_ob::get_event_name(sig, ccu_ob::F_EDGE)));
      end
      void'(event_pool.get(ccu_ob::get_event_name(sig, ccu_ob::CHANGE)));
   end        
   
endfunction:build

/**
* ccu_ob_agent class OVM build phase
*/
function void ccu_ob_agent::connect ();
   // Connect seqr to drv
  if( m_active == OVM_ACTIVE) begin
   	ccu_ob_drv.seq_item_port.connect(ccu_ob_seqncr.seq_item_export);
  end // is OVM_ACTIVE
   	ccu_ob_mon.analysis_port.connect(ccu_ob_port);
endfunction :connect 
      

`endif //ccu_ob_agent
