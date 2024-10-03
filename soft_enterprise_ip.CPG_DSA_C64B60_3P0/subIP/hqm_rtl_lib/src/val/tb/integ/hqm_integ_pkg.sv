// This file is created based on GPSB Integration doc near the end of sec 3.4.
// Reference file:
// - rlink-srvr10nm-16ww12b/verif/tb/rlink_integ/rlink_integ_pkg.sv
package hqm_integ_pkg;
   
  `include "vip_layering_macros.svh"

  `import_base(uvm_pkg::*)
  `include_base("uvm_macros.svh")
  `import_base(sla_pkg::*)
  `include_base("sla_macros.svh")

  `import_base(sla_pkg::*)
  `include_base("slu_macros.svh")

`ifdef XVM
  `import_base(ovm_pkg::*)
  `import_base(xvm_pkg::*)
  `include_base("ovm_macros.svh")
  `include_base("sla_macros.svh")
`endif


`ifndef HQM_IP_TB_OVM
   `include_base("hqm_sla_env.sv")
 
   `include_mid("hqm_iosf_trans_status_uvm.sv")
   `include_mid("hqm_iosf_prim_mon_uvm.sv")
   `include_mid("hqm_int_mon_uvm.sv")
   `include_mid("hqm_msix_int_mon_uvm.sv")  
   `include_mid("hqm_iosf_prim_msix_int_mon_uvm.sv")
   `include_mid("hqm_ims_int_mon_uvm.sv")
   `include_mid("hqm_iosf_prim_ims_int_mon_uvm.sv")

   `include_mid("hqm_iosf_prim_checker_uvm.sv")

   //import standard interface
   `import_base(hqm_base_intf_pkg::*)
   `import_base(hqm_fuse_intf_pkg::*)
   `import_base(hqm_iosf_intf_pkg::*)
   `import_base(hqm_ats_intf_pkg::*)

   // include interface programing code
   `include_base("hqm_base_intf_prog_uvm.sv")  
   `include_base("hqm_fuse_intf_prog_uvm.sv")  
   `include_base("hqm_iosf_intf_prog_uvm.sv")  
   `include_base("hqm_ats_intf_prog_uvm.sv")  

   `include_base("HqmIpCfg_uvm.sv")
   `include_base("HqmIpCfgMap_uvm.sv")         
   `include_base("HqmIpCfgProg_uvm.sv")        

   `include_base("hqm_ral_env.svh")   
   `include_base("hqm_ral_backdoor.svh")   
   `include_base("HqmBaseIntegEnv_uvm.sv")
   `include_mid("HqmMidIntegEnv_uvm.sv")
   `include_typ("HqmTypIntegEnv_uvm.sv")
   `include_base("HqmIntegEnv_uvm.sv")
`else
  `include_base("hqm_sla_env.sv")

  `include_mid("hqm_iosf_trans_status.sv")
  `include_mid("hqm_iosf_prim_mon.sv")
  `include_mid("hqm_int_mon.sv")
  `include_mid("hqm_msix_int_mon.sv")  
  `include_mid("hqm_iosf_prim_msix_int_mon.sv")
  `include_mid("hqm_ims_int_mon.sv")
  `include_mid("hqm_iosf_prim_ims_int_mon.sv")

  `include_mid("hqm_iosf_prim_checker.sv")

   //import standard interface
   `import_base(hqm_base_intf_pkg::*)
   `import_base(hqm_fuse_intf_pkg::*)
   `import_base(hqm_iosf_intf_pkg::*)
   `import_base(hqm_ats_intf_pkg::*)

   // include interface programing code
   `include_base("hqm_base_intf_prog.sv")  //`include_typ()
   `include_base("hqm_fuse_intf_prog.sv")  //`include_typ()
   `include_base("hqm_iosf_intf_prog.sv")  //`include_typ()
   `include_base("hqm_ats_intf_prog.sv")  //`include_typ()

   `include_base("HqmIpCfg.sv")
   `include_base("HqmIpCfgMap.sv")         //`include_typ()
   `include_base("HqmIpCfgProg.sv")        //`include_typ()

  `include_base("hqm_ral_env.svh")   
  `include_base("hqm_ral_backdoor.svh")   
  `include_base("HqmBaseIntegEnv.sv")
  `include_mid("HqmMidIntegEnv.sv")
  `include_typ("HqmTypIntegEnv.sv")
  `include_base("HqmIntegEnv.sv")
`endif
   
endpackage : hqm_integ_pkg

