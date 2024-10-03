//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 09-03-2011 
//-----------------------------------------------------------------
// Description:
// Clock Reset Generator Agent
//------------------------------------------------------------------


`ifndef CCU_CRG_agt
`define CCU_CRG_agt 

import sla_pkg::*;

class ccu_crg_agt extends ovm_agent;

   ccu_crg_seqr                ccu_crg_seqr_i;
   ccu_crg_driver              ccu_crg_driver_i;
   ccu_crg_monitor             ccu_crg_monitor_i;
   ccu_crg_checker             ccu_crg_checker_i;
   protected virtual ccu_crg_no_param_intf        vintf; 
   ccu_crg_cfg                 ccu_crg_cfg_i;
   ccu_crg_param_cfg           ccu_crg_param_cfg_i;

   ovm_analysis_port  #(ccu_crg_xaction)   ccu_crg_port;

   // Standard OVM Methods 
   extern function       new     (string name = "", ovm_component parent = null);
   extern function void  build   ();
   extern function void  connect ();
   extern function ccu_crg_seqr get_sequencer();
   
   // OVM Macros 
   `ovm_component_utils(ccu_crg_agt)
endclass :ccu_crg_agt


/**
 * ccu_crg_agt Class constructor
 */
function ccu_crg_agt::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new


function ccu_crg_seqr ccu_crg_agt::get_sequencer();
   return ccu_crg_seqr_i;
endfunction :get_sequencer


/**
 * ccu_crg_agt class OVM build phase
 */
function void ccu_crg_agt::build ();

   // Local 
   ovm_object ccu_crg_obj;
   string ti_name;

   // Super builder
   // -------------
   super.build ();

   // Get config
   // ----------

   // Get config object
   if (!get_config_object("ccu_crg_cfg", ccu_crg_obj, 0))
     `ovm_fatal("ccu_crg_agent", "Configuration object of clock reset generator not found")

   if (!($cast(ccu_crg_cfg_i, ccu_crg_obj)))
     `ovm_fatal("ccu_crg_agent", "Type mismatch while casting ccu_crg_cfg object")

   // Get TI stuff
   ti_name = ccu_crg_cfg_i.get_ti_name();
   ccu_crg_param_cfg_i = sla_resource_db #(ccu_crg_param_cfg)::get({ti_name, ".ccu_crg_param_cfg"}, `__FILE__, `__LINE__);
   //ccu_crg_param_cfg_i = sip_vintf_proxy #(ccu_crg_param_cfg)::get({ti_name, ".ccu_crg_param_cfg"}, `__FILE__, `__LINE__);
   assert(ccu_crg_param_cfg_i) else `ovm_error(get_type_name(), "Could not retrieve ccu_crg_param_cfg");
   `ovm_info(get_type_name(), $psprintf("num_clks = %d, num_rsts = %d", ccu_crg_param_cfg_i.num_clks, ccu_crg_param_cfg_i.num_rsts), OVM_MEDIUM)
   
   vintf = sla_resource_db #(virtual ccu_crg_no_param_intf)::get({ti_name, ".ccu_crg_no_param_intf"}, `__FILE__, `__LINE__);
   //vintf = sip_vintf_proxy #(virtual ccu_crg_no_param_intf)::get({ti_name, ".ccu_crg_no_param_intf"}, `__FILE__, `__LINE__);
   `ovm_info(get_type_name(), $psprintf("Using interface: %s", vintf.intfName), OVM_MEDIUM)

   // Adjust ccu_crg_cfg with param_cfg
   ccu_crg_cfg_i.set_param(ccu_crg_param_cfg_i.num_clks, ccu_crg_param_cfg_i.num_rsts);
   
   
   // Construct children
   // ------------------

   // ALways on components
   ccu_crg_checker_i = ccu_crg_checker::type_id::create("ccu_crg_checker", this);
   ccu_crg_port = new("ccu_crg_port",this); 

   ccu_crg_monitor_i = ccu_crg_monitor::type_id::create("ccu_crg_monitor", this);
   ccu_crg_monitor_i.set_intf(vintf);
   ccu_crg_monitor_i.set_cfg(ccu_crg_cfg_i);

   // Active part in construction
   if (ccu_crg_cfg_i.get_state() == OVM_ACTIVE) begin
      // Sequencer
      ccu_crg_seqr_i = ccu_crg_seqr::type_id::create("ccu_crg_seqr", this);
      // Driver
      ccu_crg_driver_i = ccu_crg_driver::type_id::create("ccu_crg_driver", this);
      ccu_crg_driver_i.set_intf(vintf);
      ccu_crg_driver_i.set_cfg(ccu_crg_cfg_i);
      ccu_crg_seqr_i.set_cfg(ccu_crg_cfg_i);
   end else
      `ovm_info(get_name(), "ccu_crg config has OVM_PASSIVE state set, driver & sequencer won't be instantiated in ccu_crg", OVM_MEDIUM)


endfunction :build


/**
 * ccu_crg_agt class OVM connect phase
 */
function void ccu_crg_agt::connect();

   if (ccu_crg_cfg_i.get_state() == OVM_ACTIVE) begin
      // Connect driver seq_port to sequencer seq_export
      ccu_crg_driver_i.seq_item_port.connect(ccu_crg_seqr_i.seq_item_export);
   end // if OVM_ACTIVE
	  ccu_crg_monitor_i.analysis_port.connect(ccu_crg_checker_i.rx_port);
	  ccu_crg_port.connect(ccu_crg_monitor_i.analysis_port);

endfunction :connect

`endif //CCU_CRG_agt

