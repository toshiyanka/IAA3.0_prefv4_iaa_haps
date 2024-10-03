//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 04-07-2011 
//-----------------------------------------------------------------
// Description:
// test island
//------------------------------------------------------------------

import ovm_pkg::*;
import ccu_crg_pkg::*;
// SIP Vintf Manager
  `include "ovm_macros.svh"

import sla_pkg::*;

//  test island
module ccu_crg_ti #(
   parameter NUM_CLKS = 1,
   parameter NUM_RSTS = 1
)
      (
      interface i_ccu_crg_intf);
  
  // this is avoid warning during elab 
  logic [255-NUM_CLKS:0] tmp_clk;
  logic [255-NUM_CLKS:0] tmp_ungated_clk;
  logic [255-NUM_RSTS:0] tmp_rst;

  // String to hold TI nane
  string ti_name;

  // Instantiate internal interface
  ccu_crg_no_param_intf i_ccu_crg_no_param_intf(.clocks ({tmp_clk,i_ccu_crg_intf.clocks}),
										.ungated_clocks({tmp_ungated_clk,i_ccu_crg_intf.ungated_clocks}),
                                        .resets ({tmp_rst,i_ccu_crg_intf.resets}));
  
  
  // Instantiate config
   ccu_crg_param_cfg  ccu_crg_param_cfg_i ;


  // Connect ccu_crg
  function void connect_ccu_crg();
	  sla_resource_db #(virtual ccu_crg_no_param_intf)::add (
		  {ti_name, ".ccu_crg_no_param_intf"}, i_ccu_crg_no_param_intf, `__FILE__, `__LINE__
	  );
      //sip_vintf_proxy #(virtual ccu_crg_no_param_intf)::add (
      //   {ti_name, ".ccu_crg_no_param_intf"}, i_ccu_crg_no_param_intf, `__FILE__, `__LINE__
      //);
  endfunction : connect_ccu_crg

  // Connect CFG
  function void connect_cfg();
      // Create cfg
      ccu_crg_param_cfg_i = new();
      
      //set config fields
      ccu_crg_param_cfg_i.num_clks = NUM_CLKS;
      ccu_crg_param_cfg_i.num_rsts = NUM_RSTS;
      
      // Pass config
      sla_resource_db #(ccu_crg_param_cfg)::add (
         {ti_name, ".ccu_crg_param_cfg"}, ccu_crg_param_cfg_i, `__FILE__, `__LINE__
      );


//      sip_vintf_proxy #(ccu_crg_param_cfg)::add (
  //       {ti_name, ".ccu_crg_param_cfg"}, ccu_crg_param_cfg_i, `__FILE__, `__LINE__
//      );

      endfunction :connect_cfg


   initial begin 
      ti_name = $psprintf("%m");
      connect_ccu_crg();
      connect_cfg();
   end

endmodule :ccu_crg_ti
