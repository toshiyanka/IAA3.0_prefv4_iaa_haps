//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved
//-----------------------------------------------------------------
// Author       : Lakshmi Sridhar
// Date Created : 01-2017
//-----------------------------------------------------------------
// Description:
// HQM subsystem IP picker file.
// This picker is meant to specify knobs and constraints
// that are specific to the HQM IP itself. If such knobs
// don't exist and a separation of control is not required,
// then it is sufficient to use the hqm_agent_picker alone while
// ensuring the change is relfected in the proj_cfg repo too.
// Alternatively, you can change the hqm_agent_picker to extend
// from the base_hqm_picker in the proj_cfg repo too. Any overrides
// can be moved from this file into the hqm_agent_picker in HQM repo
//------------------------------------------------------------------


`topo_picker_class_begin(rtl_hqm_picker, HQM, base_hqm_picker, RTL)

   `run_knobs_begin
//      To add a knob:
//      `add_knob("fuse_enable", fuse_enable, bit)
//      you can override a knob in projcfg like so:
//      `override_cfg_val(fuse_enable, 0);
//      add_knob("num_hqm_vfs", num_hqm_vfs, int unsigned)
/////      `override_cfg_val(num_hqm_vfs, 5);
   `run_knobs_end

   function void pre_randomize();
      super.pre_randomize();
      `ovm_info("HQM_INFO", "  I am in HQM IP picker",  OVM_LOW)
   endfunction : pre_randomize

   function void build();
      super.build();
      if (is_stage(RUN_STAGE)) begin
         `override_cfg_val(bus.num_bus, 1)
      end
   endfunction : build


   virtual function void setup_iosf_ports();
      super.setup_iosf_ports();
      `override_cfg_val(iosf_port.port_mode, 1);
      `override_cfg_val(iosf_port.slowport, 0);
   endfunction : setup_iosf_ports

   constraint enable_c {
      fuse_enable == 0 -> enable == 0;
      soft enable == 1;
   }

   virtual function void connect_agent2iosf();
      super.connect_agent2iosf();
   endfunction : connect_agent2iosf

`picker_class_end
