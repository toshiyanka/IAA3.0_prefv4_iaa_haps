package hqm_saola_pkg;
  `include "vip_layering_macros.svh"

  `import_base(ovm_pkg::*)
  `include_base("ovm_macros.svh")

  `import_base(sla_pkg::*)
  `include_base("sla_macros.svh")

  import hcw_transaction_pkg::*;
  import hqm_tb_sequences_pkg::*;
    `import_typ(iosfsb_connector_pkg::*)
  import IosfPkg::*;
  import iosfsbm_cm::*;
  import iosfsbm_seq::*;
  import iosfsbm_fbrc::*;
  import sla_fusegen_pkg::*;   
  import hqm_integ_pkg::*;  
  `import_typ(hqm_func_cov_pkg::*) 
  `import_typ(init_utils_comp_pkg::*)
  `import_typ(init_utils_seq_pkg::*)

  `import_typ(iosf_sb_sla_pkg::*)
  `import_typ(sla_iosf_pri_reg_lib_pkg::*) 
  `import_typ(server_sim_iosf_pri_req_context_pkg::*)
  `import_typ(iosf_sb_seq_item_pkg::*)
  `import_typ(server_sim_iosf_sb_req_context_pkg::*)
  `import_typ(server_sim_iosf_sb_req_context_registrar_pkg::*)   
  `import_typ(iosf_pri_stim_dut_view_pkg::*)
  `import_typ(iosf_pri_seq_item_pkg::*)
  `include "iosfsbm_message_macros.svh"

  `include "lvmDumpVpdMgr.sv"
  `include "lvmDumpFsdbMgr.sv"

   //import standard interface
   import hqm_base_intf_pkg::*;
   import hqm_fuse_intf_pkg::*;
   import hqm_iosf_intf_pkg::*;
   import hqm_ats_intf_pkg::*;

   // include interface programing code
   `include_typ("hqm_base_intf_prog.sv")
   `include_typ("hqm_fuse_intf_prog.sv")
   `include_typ("hqm_iosf_intf_prog.sv")
   `include_typ("hqm_ats_intf_prog.sv")

   `include_typ("HqmIpCfgProg.sv")

 `ifdef IP_TYP_TE
  `include "hqm_iosf_sb_cb.sv"
  `include "hqm_iosf_mrd_cb.sv"
  `include "hqm_iosf_sb_posted_cb.sv"
  `include "hqm_iosf_sb_PCIE_cb.sv"
  `include "hqm_iosf_sb_RESET_PREP_cb.sv"
  `include "hqm_sb_pcie_cb.sv"

  `include "hqm_sif_defines.sv";
  `include "hqm_iosf_sb_decoder.sv"
  `include "hqm_iosf_sb_checker.sv"

  `include "HqmIosfFabPolicy.svh"


   `include "hqm_transaction_checker.sv"

   `include "hqm_iosf_pri_constrained_request_items.svh"

   `include "hqm_test_fuse_env.svh"
   `include "hqm_gpsb_utils.sv" 
   `include "hqm_tb_iosf_prim_mon.sv"
   `include "HqmIosfMRdCb.svh" //--AY_HQMV30_ATS
   `include "hqm_tb_env.sv"
   `include "hqm_tb_sm_env.sv"
   `include "hqm_sla_tb_ral_env.sv"

 `elsif IP_MID_TE
   //-- remove dependency on integenv and addr_util: these are not to compile at mid layer 
   //--08092022 `include "hqm_transaction_checker.sv"

   //--08092022 `include "hqm_tb_iosf_prim_mon.sv"
 `endif

endpackage
