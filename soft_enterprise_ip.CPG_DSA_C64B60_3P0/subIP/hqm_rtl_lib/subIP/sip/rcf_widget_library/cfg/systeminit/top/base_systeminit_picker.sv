
// -*- mode: Verilog; verilog-indent-level: 2; -*-

//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2013 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : Reno Massarini
// Date Created : 11-2014
//-----------------------------------------------------------------
// Description:
// Top - level Picker.
//------------------------------------------------------------------

/*Class: base_systeminit_picker
Foundation for writing a top level picker also known as a systeminit picker. It will instantiate other pickers related to topology, reset, and address map. At this time a project is required to create a component called "systeminit_picker". That component can inherit from this class and then override the types of the pickers this class instantiates using set_type_override_by_type for example. A project at this time cannot use this class directly due to limitations in systeminit.
*/

class base_systeminit_picker extends top_picker;

  // Pickers
  /* Variable: topology
  Will hold an instance of the base topology picker. It is required that that instance of the topology picker be named "topology". Projects expect keys related to topology to start with "topology::". Those keys are based on component hierarchy in system veriolog. IPs can use set_type_override_by_name in their systeminit picker's build function for example to replace the base topology picker with their topology picker. 
  */
  base_topology_picker topology;

  /* Variable: reset
  Will hold an instance of the base reset picker.
  */
  base_reset_picker reset;

  /* Variable: reset
  Will hold an instance of the base reset picker.
  */
  base_topology_credit_picker credits;

  /* Variable: addr_picker
   *
   * 
   */
   addr_map_base_picker addr_map;
 
  /* Function: build
  Build and randomize the desired pickers in this function. Typically the topology related picker will get built and randomized first. Any data required by the other pickers can be pushed down after they are built and before they are randomized. build functions are called top down in OVM.

  Inputs:
  none.

  Outputs:
  none.

  */
  function void build();
    base_top_cfg topoCfg;

    super.build();

    `ovm_info(get_name(), "Building the base systeminit picker...", OVM_LOW)
    topology = base_topology_picker::type_id::create("topology", this);
    topology.randomize();

    // Only run these pickers during the RUN stage
    if (is_stage(RUN_STAGE)) begin
      topoCfg = base_top_cfg::type_id::create("");
      topoCfg.populate_topo_cfg(topology, "build_phase");
      topoCfg.dump_cfg();
      `ovm_info(get_name(), "Building the base addr_map picker...", OVM_LOW)
      addr_map = addr_map_base_picker::type_id::create("addr_map", this);
      /* This is where we pass variables generated in topology into the addr_map */  
      set_config_object("addr_map.*", "top_cfg", topoCfg, 0);
      addr_map.randomize();

      reset = base_reset_picker::type_id::create("reset", this);
      reset.randomize();

      set_config_object("credits*", "top_cfg", topoCfg, 0);
      credits = base_topology_credit_picker::type_id::create("credits", this);
      credits.num_sockets = topology.num_cpu_socket;
    end
  endfunction: build

  /* Function: connect
  Making decisions not easily made with constraints can be done here. An example of that would be assigning IDs. connect functions are called bottom up in OVM.

  Inputs:
  none.

  Outputs:
  none.

  */
endclass: base_systeminit_picker
