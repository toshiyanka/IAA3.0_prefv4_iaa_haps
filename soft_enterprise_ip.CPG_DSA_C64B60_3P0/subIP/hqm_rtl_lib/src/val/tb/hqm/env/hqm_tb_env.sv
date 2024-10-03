`ifndef HQM_TB_ENV__SV
`define HQM_TB_ENV__SV

import hqm_tap_rtdr_common_val_env_pkg::*;
import dft_common_val_env_pkg::*;
import IosfPkg::*;
import iosfsbm_fbrc::*;
import iosfsbm_agent::*;
import hcw_pkg::*;
import hqm_cfg_pkg::*;
import hqm_tb_cfg_pkg::*;
import sip_vintf_pkg::*;       // virtual interface wrapper package
import hqm_integ_pkg::*;
import hqm_integ_seq_pkg::*;
import hcw_sequences_pkg::*;
import hqm_reset_pkg::*;
import hqm_tb_sequences_pkg::*;

import ConfigDB::*;
import integenv_pkg::*;
import integ_projcfg_pkg::*;
import cfg_mgr_env_pkg::*;
import clk_ctrl_pkg::*;
  
  `include "IntegMacros.svh"

  `include "hqm_addr_utils_builder.svh"
  `include "hqm_iosf_pri_protocol_builder.svh"

//  `include "mesh_bfm_ip_preloader.sv"
  `include "hqm_init_utils_stim_dut_view_builder.svh"
//--08012022  `include "hqm_init_utils_stim_dut_hash_config.svh"

`INTEGENV_REGISTER_DICTIONARY(TOP, , hqm_tb_env, hqm_tb_env_cfg);

class hqm_tb_cm_env extends cfg_mgr_env;

  `ovm_component_utils(hqm_tb_cm_env)

  function new(string name, ovm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build();
    super.build();
  endfunction : build

  function void connect();
    super.connect();

  endfunction : connect

  //  Function: end_of_elaboration - Map access type to sequences.
  function void end_of_elaboration ();
    super.end_of_elaboration();

    // Randomize RAL, SM, FUSE
    //randomize_me();

  endfunction

endclass : hqm_tb_cm_env

//**************IntegEnv update ********************
class hqm_tb_env_cfg extends IntegCfg;
  `ovm_object_utils(hqm_tb_env_cfg)

    static hqm_tb_cm_env cfgMgr = null;
    
    function set_derived_class_properties(CreateSlaTbEnvConfigParams create_sla_tb_env_config_params);
        super.set_derived_class_properties(create_sla_tb_env_config_params);
        set_cfg_mgr();
    endfunction: set_derived_class_properties

    function set_cfg_mgr();
       // Get a handle to the static config-manager
       if (cfgMgr == null) begin
           $cast(cfgMgr, sla_config_manager_env::get_ptr());
           if (cfgMgr == null) `ovm_fatal(get_name(), "Unable to setup config_manager pointer");
       end
    endfunction: set_cfg_mgr

    static function hqm_tb_cm_env get_cfg_mgr();
       get_cfg_mgr = cfgMgr;
    endfunction: get_cfg_mgr

endclass: hqm_tb_env_cfg


//**************IntegEnv update ********************
class hqm_tb_env extends TopIntegEnv;   // was sla_tb_env

  logic strap_hqm_16b_portids;
  logic [15:0] strap_hqm_gpsb_srcid;
  virtual  hqm_misc_if       pins;
  hqm_tb_env_cfg        configCte;
 // Config manager
  hqm_tb_cm_env         cfg_mgr;   
  //virtual interface     hqm_ss_ti_if pins;

  //-------------------------------------
  //-----------------------preloader
  //-------------------------------------
  //system level preloader integration
//  typedef coherency_domain_ui#(init_utils_coh_dom_mem_req, init_utils_coh_dom_load_file_req) COH_DOM_UI_TYPE;
//  typedef non_coherency_domain_ui#(init_utils_non_coh_dom_preload_req, init_utils_non_coh_dom_load_file_req) NON_COH_DOM_UI_TYPE;
    
//  COH_DOM_UI_TYPE coh_dom_ui;
//  NON_COH_DOM_UI_TYPE non_coh_dom_ui;
   
//  typedef mesh_bfm_ip_preloader#(init_utils_coh_dom_mesh_bfm_req) IP_BFM_PRELOADER_TYPE;
//  IP_BFM_PRELOADER_TYPE bfm_ip_preloader;


  //-------------------------------------
  iosf_pri_stim_dut_src_config  dut_src_cfg;

  HqmIpCfgProg          hqmCfg;
  HqmIntegEnv           hqm_agent_env_handle;

  lvmDumpVpdMgr         dump_vpd_mgr;
  lvmDumpFsdbMgr        dump_fsdb_mgr;

  iosfsbm_fbrcvc        iosf_svc;
  fbrcvc_cfg            iosf_svc_cfg;
  agtvc_cfg             iosf_sagt_cfg;

  hqm_gpsb_utils        i_hqm_gpsb_utils;
   
  hqm_reset_agent       i_reset_agent;

  hqm_iosf_sb_decoder   sideband_decoder_hqm_i;
  hqm_iosf_sb_checker   sideband_checker_hqm_i;

  clk_control           m_clk_ctrl1;
  clk_control           m_clk_ctrl2;

  hqm_tap_rtdr_common_val_env_pkg::hqm_tap_rtdr_common_val_env i_hqm_tap_rtdr_common_val_env;
  //dft_common_val_env_pkg::dft_common_val_env i_dft_common_val_env;


  hqm_func_cov_collector i_hqm_func_cov_collector;
  hqm_transaction_checker i_hqm_transaction_checker;

  HqmIosfMRdCb            pvcMRdCB; //--AY_HQMV30_ATS primary callback


  `ovm_component_utils_begin(hqm_tb_env)
  `ovm_component_utils_end
     //--------------------------------------------------------
     //--------------------------------------------------------                                     
   
     extern                   function                new(string name = "hqm_tb_env", ovm_component parent = null);
     extern virtual           function void           build();
     extern virtual           function void           connect();
     extern virtual           function void           start_of_simulation();
     extern virtual           function void           end_of_elaboration();
     extern virtual           task                    set_clk_rst();
     extern                   function longint        get_strap_val(string plusarg_name, longint default_val, bit mode);
     extern                   function void           setConfigManagerType();
     extern                   function void           setSmType();
     extern                   function void           setFuseType();
     extern                   function void           setRalType();
     extern virtual           function void           set_subnetportid(string subnetportid);



//--------------------------------------------------------
// preloader
//--------------------------------------------------------
//    `DECALRE_FUNC_SYSTEM_LEVEL_RPELOAD_REGISTER_TLM_ENTITIES
//      `DECALRE_FUNC_SYSTEM_LEVEL_RPELOAD_CONNECT_TLM_ENTITIES
////function void register_tlm_entities()
////virtual function void connect_tlm_entities()

endclass



//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
function void hqm_tb_env::setConfigManagerType();
    config_manager_type = "hqm_tb_cm_env";
endfunction: setConfigManagerType                        

function void hqm_tb_env::setSmType(); //--IntegEnv
    `ovm_info(get_type_name(), "setSmType(): setting sm_type to hqm_tb_sm_env", OVM_LOW)
    sm_type = "hqm_tb_sm_env";
endfunction: setSmType

function void hqm_tb_env::setFuseType();
  fuse_type = "hqm_test_fuse_env";
endfunction: setFuseType 

function void hqm_tb_env::setRalType();
    `ovm_info(get_type_name(), "new(): setting ral_type to hqm_sla_tb_ral_env", OVM_LOW)
    ral_type = "hqm_sla_tb_ral_env";
endfunction

function hqm_tb_env::new (string name = "hqm_tb_env", ovm_component parent = null);
    super.new(name, parent);

    //-----------------------
    hqmCfg = HqmIpCfgProg::type_id::create("hqmCfg",this);
    `ovm_info(get_full_name(), $psprintf("hqm_tb_env::new create hqmCfg(HqmIpCfgProg)"), OVM_LOW)

    //-----------------------
    cfg_mgr = configCte.get_cfg_mgr();

    //if (iosfsb_base_utils::get_ptr() == null)
      i_hqm_gpsb_utils = hqm_gpsb_utils::type_id::create("i_hqm_gpsb_utils");   

    `ifndef DO_NOT_USE_RAL
       setRalType();
    `endif

     if ( _level == SLA_TOP ) begin
        // replaced by setSmType()
        //sm_type = "hqm_tb_sm_env";
     end
endfunction

//--------------------------------------------------------
//
//--------------------------------------------------------

//--------------------------------------------------------
//
//--------------------------------------------------------
function void hqm_tb_env::build();
  ovm_object  o;
  string ep_name;
  string comp_name;
  iosfsbm_cm::pid_t agt_my_ports[$], agt_other_ports[$], agt_mcast_ports[$]; 
  iosfsbm_cm::opcode_t agt_supp_opcodes[$];
  iosfsbm_cm::pid_t fab_my_ports[$], fab_other_ports[$], fab_mcast_ports[$], temp_fab_ports[$];
  iosfsbm_cm::pid_queue_t fab_my_local_ports[iosfsbm_cm::pid_t];
  iosfsbm_cm::pid_queue_t fab_other_local_ports[iosfsbm_cm::pid_t];
  iosfsbm_cm::opcode_t fab_supp_opcodes[$];
  bit[31:0] fab_ext_headers[$];
  int cpl_delay;
  int cpl_parallel_delay;
  int AgtReorderEn = 0;
  bit [7:0] func_base;
  bit       hqm_is_reg_ep_arg;
  int gntgap;
  logic [7:0]  strap_hqm_fp_cfg_portid;
  logic [7:0]  strap_hqm_fp_cfg_destid;
  logic [15:0] strap_hqm_fp_cfg_dstid;
  logic [15:0] strap_hqm_err_sb_dstid;
  logic [15:0] strap_hqm_fp_cfg_ready_dstid;
  logic [15:0] strap_hqm_do_serr_dstid;
  logic [15:0] hqm_gpsb_dstid;
  int sb_np_crd_buf, sb_p_crd_buf;

  //-----------------------
  `ovm_info(get_full_name(), $psprintf("hqm_tb_env::build create hqm_agent_env_handle(HqmIntegEnv)"), OVM_LOW)
  hqm_agent_env_handle = HqmIntegEnv::type_id::create("hqm_agent_env_handle",this);   
  `ovm_info(get_full_name(), $psprintf("hqm_tb_env::build create hqm_agent_env_handle.hqmCfg)"), OVM_LOW)
   $cast(hqm_agent_env_handle.hqmCfg, hqmCfg);

  //-----------------------
  setFuseType();

  //-----------------------
  super.build();

 //-----------------------preload
 //`ovm_info(get_name(),"Building..coh_dom_ui.", OVM_NONE)
 ////`INIT_SYSTEM_LEVEL_RPELOAD_UI
 // coh_dom_ui   = COH_DOM_UI_TYPE::rGetCoherencyDomainUI("hqm_sv_coh_dom_ui", this);
 //`ovm_info(get_name(),"Building..non_coh_dom_ui.", OVM_NONE)
 // non_coh_dom_ui = NON_COH_DOM_UI_TYPE::rGetNonCoherentDomainUI("hqm_sv_non_coh_dom_ui", this);


 ////`INIT_FUNC_SYSTEM_LEVEL_RPELOAD_REGISTER_TLM_ENTITIES
//  register_tlm_entities();

  //simulte SBx case. BFM provide everything
//  bfm_ip_preloader = IP_BFM_PRELOADER_TYPE::type_id::create("bfm_ip_preloader", this);

  //----------------------- 
  `ovm_info(get_full_name(), $psprintf("hqm_tb_env::iosf_pri_stim_dut_view_builder)"), OVM_LOW)
  //set_type_override_by_type(address_map_dut_view_pkg::address_map_dut_view_builder::get_type(), hqm_address_map_builder::get_type());
  set_type_override_by_type(iosf_pri_stim_dut_view_builder::get_type(), hqm_iosf_pri_protocol_builder::get_type());
 

  set_type_override_by_type(init_utils_stim_dut_view_pkg::init_utils_stim_dut_view_builder::get_type(), hqm_init_utils_stim_dut_view_builder::get_type(), 1);   
//--08012022   set_type_override_by_type(init_utils_stim_dut_view_pkg::init_utils_stim_dut_hash_config::get_type(),  hqm_init_utils_stim_dut_hash_config::get_type(),  1);

  //-----------------------
  dump_vpd_mgr = new("dump_vpd_mgr",this);
  dump_fsdb_mgr = new("dump_fsdb_mgr",this);

  //--  config_manager_type
  //if ( _level == SLA_TOP ) begin
  //   config_manager_type = "sla_config_manager_env";
  //end

  if(!$value$plusargs("hqm_is_reg_ep=%d",hqm_is_reg_ep_arg)) hqm_is_reg_ep_arg = '0; 

  if(hqm_is_reg_ep_arg) begin func_base = 8'h00; end       // EP Base function number
  else                  begin 
                              func_base = 8'h00;           // RCIEP Base function number
  end

  ovm_pkg::set_config_int("*", "hqm_ral_bdf_program",hqmCfg.has_ralbdf_ctrl);
  `ovm_info(get_full_name(), $psprintf("hqm_tb_env::hqmCfg.has_ralbdf_ctrl=%0d ", hqmCfg.has_ralbdf_ctrl), OVM_LOW)
  ovm_pkg::set_config_int("*", "hqm_ral_override_program",hqmCfg.has_raloverride_ctrl);
  `ovm_info(get_full_name(), $psprintf("hqm_tb_env::hqmCfg.has_raloverride_ctrl=%0d ", hqmCfg.has_raloverride_ctrl), OVM_LOW)

  ovm_pkg::set_config_int("*", "hqm_pp_cq_gen_freq",800);

  //set_config_string("*", "HQM_RTL_TOP", "hqm_tb_top.u_hqm");  //rmullick: 7/25/2018 set_config_string removed from hqm_tb_env.sv and moved to hqm_test_island.sv 

  set_type_override_by_type(hqm_hcw_enq_seq::get_type(),hqm_hcw_iosf_pri_enq_seq::get_type());

 `ifdef IP_TYP_TE
  set_type_override_by_type(iosf_pri_constrained_request_mem_wr_item::get_type(),hqm_iosf_pri_constrained_request_mem_wr_item::get_type());
  set_type_override_by_type(iosf_pri_constrained_request_mem_rd_item::get_type(),hqm_iosf_pri_constrained_request_mem_rd_item::get_type());
 `endif
  set_type_override_by_type(hqm_iosf_prim_mon::get_type(),hqm_tb_iosf_prim_mon::get_type());
  set_type_override_by_type(hqm_msix_int_mon::get_type(),hqm_iosf_prim_msix_int_mon::get_type());
  set_type_override_by_type(hqm_ims_int_mon::get_type(),hqm_iosf_prim_ims_int_mon::get_type());

  iosf_svc      = iosfsbm_fbrcvc::type_id::create("iosf_svc",this);
  iosf_svc_cfg  = fbrcvc_cfg::type_id::create("iosf_svc_cfg",this);
  iosf_sagt_cfg = agtvc_cfg::type_id::create("iosf_sagt_cfg",this);

  i_reset_agent = hqm_reset_agent::type_id::create("i_reset_agent",this);

  iosf_svc_cfg.default_deassert_clk_sigs = `HQM_SB_DEASSERT_CLK_SIGS_DEFAULT; 

  //Set ext_header_support
  iosf_sagt_cfg.ext_header_support = 1;
      
  //iosf_svc_cfg.ext_header_support = iosf_sagt_cfg.ext_header_support;
  //iosf_svc_cfg.agt_ext_header_support = iosf_sagt_cfg.ext_header_support;
  iosf_svc_cfg.ext_header_support = 1;
  iosf_svc_cfg.agt_ext_header_support = 1;
  iosf_svc_cfg.ext_headers_per_txn = 1;        // supply extended header per transaction

  if($test$plusargs("DISABLE_FAB_PARITY_CHK"))begin
    iosf_svc_cfg.fab_parity_chk = 0;
    iosf_svc_cfg.iosf_endpoint  = 1;
  end  

   if($test$plusargs("REINIT_START"))begin
  iosf_svc_cfg.enable_rnd_crd_reinit = 1;
  end

   if($test$plusargs("SIDE_NAK"))begin
  iosf_svc_cfg.rand_idle_nak_support = 1'b1;
  end

  if($test$plusargs("CHK_DISABLE"))begin
  iosf_svc_cfg.chk_enabled = 1'b0;
  end

  strap_hqm_16b_portids = get_strap_val("HQM_STRAP_16B_PORTIDS", `HQM_STRAP_16B_PORTIDS, strap_hqm_16b_portids);

  if (strap_hqm_16b_portids) begin 
      strap_hqm_gpsb_srcid = get_strap_val("HQM_STRAP_GPSB_SRCID", `HQM_STRAP_GPSB_SRCID_16B, strap_hqm_16b_portids);
      strap_hqm_fp_cfg_dstid = get_strap_val("HQM_STRAP_FP_CFG_DSTID", `HQM_STRAP_FP_CFG_DSTID_16B, strap_hqm_16b_portids);
      strap_hqm_err_sb_dstid = get_strap_val("HQM_STRAP_ERR_SB_DSTID", `HQM_STRAP_ERR_SB_DSTID_16B, strap_hqm_16b_portids);;
      strap_hqm_fp_cfg_ready_dstid = get_strap_val("HQM_STRAP_FP_CFG_READY_DSTID", `HQM_STRAP_FP_CFG_READY_DSTID_16B, strap_hqm_16b_portids);
      strap_hqm_do_serr_dstid = get_strap_val("HQM_STRAP_DO_SERR_DSTID", `HQM_STRAP_DO_SERR_DSTID_16B, strap_hqm_16b_portids);
      hqm_gpsb_dstid = get_strap_val("HQM_GPSB_DSTID", `HQM_GPSB_DSTID_16B, strap_hqm_16b_portids);
  end else begin 
      strap_hqm_gpsb_srcid = get_strap_val("HQM_STRAP_GPSB_SRCID", `HQM_STRAP_GPSB_SRCID, strap_hqm_16b_portids);
      strap_hqm_gpsb_srcid[15:8] = (strap_hqm_gpsb_srcid[15:8] == 8'h0) ? 8'h1 : strap_hqm_gpsb_srcid[15:8];
      strap_hqm_fp_cfg_dstid = get_strap_val("HQM_STRAP_FP_CFG_DSTID", `HQM_STRAP_FP_CFG_DSTID, strap_hqm_16b_portids);
      strap_hqm_err_sb_dstid = get_strap_val("HQM_STRAP_ERR_SB_DSTID", `HQM_STRAP_ERR_SB_DSTID, strap_hqm_16b_portids);;
      strap_hqm_fp_cfg_ready_dstid = get_strap_val("HQM_STRAP_FP_CFG_READY_DSTID", `HQM_STRAP_FP_CFG_READY_DSTID, strap_hqm_16b_portids);
      strap_hqm_do_serr_dstid = get_strap_val("HQM_STRAP_DO_SERR_DSTID", `HQM_STRAP_DO_SERR_DSTID, strap_hqm_16b_portids);
      hqm_gpsb_dstid = get_strap_val("HQM_GPSB_DSTID", `HQM_GPSB_DSTID_16B, strap_hqm_16b_portids);
  end 

  set_config_int("*", "strap_hqm_gpsb_srcid", strap_hqm_gpsb_srcid);
  set_config_int("*", "strap_hqm_16b_portids", strap_hqm_16b_portids);
  set_config_int("*", "strap_hqm_fp_cfg_dstid", strap_hqm_fp_cfg_dstid);
  set_config_int("*", "strap_hqm_err_sb_dstid", strap_hqm_err_sb_dstid);
  set_config_int("*", "strap_hqm_fp_cfg_ready_dstid", strap_hqm_fp_cfg_ready_dstid);
  set_config_int("*", "strap_hqm_do_serr_dstid", strap_hqm_do_serr_dstid);
  set_config_int("*", "hqm_gpsb_dstid", hqm_gpsb_dstid);


  //Configure Agent config descriptor
  //User can randomize payload_width, crd_buffers, 
  //crd_update_delay, compl_Delay etc.  
  agt_my_ports = '{strap_hqm_gpsb_srcid[7:0], strap_hqm_gpsb_srcid[15:8]};
  agt_other_ports = '{strap_hqm_fp_cfg_dstid[15:8], strap_hqm_fp_cfg_dstid[7:0], hqm_gpsb_dstid[7:0], hqm_gpsb_dstid[15:8], strap_hqm_err_sb_dstid[15:8], strap_hqm_err_sb_dstid[7:0], strap_hqm_fp_cfg_ready_dstid[15:8], strap_hqm_fp_cfg_ready_dstid[7:0], strap_hqm_do_serr_dstid[15:8], strap_hqm_do_serr_dstid[7:0]};
  agt_mcast_ports = '{'h20};
  agt_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES;
  assert (iosf_sagt_cfg.randomize with {
                                      iosf_sagt_cfg.num_tx_ext_headers == 1;
                                      iosf_sagt_cfg.payload_width == 8;
                                      iosf_sagt_cfg.compl_delay == 2;
                                      iosf_sagt_cfg.my_ports.size() == agt_my_ports.size();
                                      iosf_sagt_cfg.other_ports.size() == agt_other_ports.size();
                                      iosf_sagt_cfg.mcast_ports.size() == agt_mcast_ports.size();
                                      foreach (agt_my_ports[i])
                                        iosf_sagt_cfg.my_ports[i] == agt_my_ports[i];
                                      foreach (agt_other_ports[i])
                                        iosf_sagt_cfg.other_ports[i] == agt_other_ports[i];
                                      foreach (agt_mcast_ports[i])
                                        iosf_sagt_cfg.mcast_ports[i] == agt_mcast_ports[i];
                                      foreach (agt_supp_opcodes[i])
                                        iosf_sagt_cfg.supported_opcodes[i] == agt_supp_opcodes[i];
                                      }) else
    `iosfsbm_message_error("RND", "Randomization failed",iosfsbm_cm::VERBOSE_ERROR) 

  //Configure Fabric config descriptor
  //User can randomize payload_width, crd_buffers, 
  //crd_update_delay, compl_Delay etc. 
  
  if (strap_hqm_16b_portids) begin 
     temp_fab_ports = '{strap_hqm_fp_cfg_dstid[15:8], strap_hqm_fp_cfg_dstid[7:0], hqm_gpsb_dstid[7:0], hqm_gpsb_dstid[15:8], strap_hqm_err_sb_dstid[15:8], strap_hqm_err_sb_dstid[7:0], strap_hqm_fp_cfg_ready_dstid[15:8], strap_hqm_fp_cfg_ready_dstid[7:0], strap_hqm_do_serr_dstid[15:8], strap_hqm_do_serr_dstid[7:0]};
     fab_my_ports = temp_fab_ports.unique();
     temp_fab_ports = {};
     temp_fab_ports = fab_my_ports.find(item) with (item == strap_hqm_gpsb_srcid[7:0]); 
     if (temp_fab_ports.size() == 0) fab_other_ports.push_back(strap_hqm_gpsb_srcid[7:0]);
     temp_fab_ports = {};
     temp_fab_ports = fab_my_ports.find(item) with (item == strap_hqm_gpsb_srcid[15:8]); 
     if (temp_fab_ports.size() == 0) fab_other_ports.push_back(strap_hqm_gpsb_srcid[15:8]);
     temp_fab_ports = {};
     temp_fab_ports = fab_other_ports.unique();
     fab_other_ports = {};
     fab_other_ports = temp_fab_ports;
     temp_fab_ports = {};
  end
  else begin
     temp_fab_ports = '{strap_hqm_fp_cfg_dstid[7:0], hqm_gpsb_dstid[7:0], hqm_gpsb_dstid[15:8]}; 
     fab_my_ports = temp_fab_ports.unique();
     temp_fab_ports = {};
     temp_fab_ports = fab_my_ports.find(item) with (item == strap_hqm_gpsb_srcid[7:0]); 
     if (temp_fab_ports.size() == 0) fab_other_ports.push_back(strap_hqm_gpsb_srcid[7:0]);
     temp_fab_ports = {};
     temp_fab_ports = fab_my_ports.find(item) with (item == strap_hqm_gpsb_srcid[15:8]); 
     if (temp_fab_ports.size() == 0) fab_other_ports.push_back(strap_hqm_gpsb_srcid[15:8]);
     temp_fab_ports = {};
     temp_fab_ports = fab_other_ports.unique();
     fab_other_ports = {};
     fab_other_ports = temp_fab_ports;
     temp_fab_ports = {};
  end
  fab_mcast_ports = '{'h20};
  fab_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES;
  $display("fab_my_ports %0p, fab_other_ports %0p, fab_mcast_ports %0p", fab_my_ports, fab_other_ports, fab_mcast_ports); 

  assert (iosf_svc_cfg.randomize with {
                                       iosf_svc_cfg.num_tx_ext_headers == 1;
                                       iosf_svc_cfg.payload_width == 8;
                                       iosf_svc_cfg.compl_delay == 1;
                                       iosf_svc_cfg.my_ports.size() == fab_my_ports.size();
                                       iosf_svc_cfg.other_ports.size() == fab_other_ports.size();
                                       iosf_svc_cfg.mcast_ports.size() == fab_mcast_ports.size();
                                       foreach (fab_my_ports[i])
                                         iosf_svc_cfg.my_ports[i] == fab_my_ports[i];
                                       foreach (fab_other_ports[i])
                                         iosf_svc_cfg.other_ports[i] == fab_other_ports[i];
                                       foreach (fab_mcast_ports[i])
                                         iosf_svc_cfg.mcast_ports[i] == fab_mcast_ports[i];
                                       foreach (fab_supp_opcodes[i])
                                         iosf_svc_cfg.supported_opcodes[i] == fab_supp_opcodes[i];
                                       }) else
                                                 
    `iosfsbm_message_error("RND", "Randomization failed",iosfsbm_cm::VERBOSE_ERROR)      
   
  if (strap_hqm_16b_portids) begin

      iosf_svc_cfg.global_intf_en = 1;
      //fp_cfg_dstid[15:8] > is index for associative array for fab_my_local_ports 
      fab_my_local_ports[strap_hqm_fp_cfg_dstid[15:8]].push_back(strap_hqm_fp_cfg_dstid[7:0]);
      fab_my_local_ports[hqm_gpsb_dstid[15:8]].push_back(hqm_gpsb_dstid[7:0]);
      fab_my_local_ports[strap_hqm_err_sb_dstid[15:8]].push_back(strap_hqm_err_sb_dstid[7:0]);
      fab_my_local_ports[strap_hqm_fp_cfg_ready_dstid[15:8]].push_back(strap_hqm_fp_cfg_ready_dstid[7:0]);
      fab_my_local_ports[strap_hqm_do_serr_dstid[15:8]].push_back(strap_hqm_do_serr_dstid[7:0]);

      fab_other_local_ports[strap_hqm_gpsb_srcid[15:8]].push_back(strap_hqm_gpsb_srcid[7:0]);

      foreach(fab_my_local_ports[i]) begin 
         iosf_svc_cfg.set_my_local_ports(i, fab_my_local_ports[i]);
         `ovm_info(get_full_name(),$psprintf("fab_my_local_ports:: index:%0h : value:%0p", i, fab_my_local_ports[i]), OVM_LOW)
      end

      foreach(fab_other_local_ports[i]) begin 
         iosf_svc_cfg.set_other_local_ports(i, fab_other_local_ports[i]);
         `ovm_info(get_full_name(),$psprintf("fab_other_local_ports:: index:%0h : value:%0p", i, fab_other_local_ports[i]), OVM_LOW)
      end
  end 
  iosf_svc_cfg.inst_name = "hqm_tb_top.hqm_test_island.fab_ti";
  iosf_svc_cfg.set_intf_name("iosf_sbc_fabric_if");
      
  //To disable compliance monitor set this to 1
  iosf_svc_cfg.disable_compmon = 0;
  iosf_sagt_cfg.disable_compmon = 0;
    
  iosf_sagt_cfg.set_iosfspec_ver(iosfsbm_cm::IOSF_12);
  iosf_svc_cfg.set_iosfspec_ver(iosfsbm_cm::IOSF_12);

  iosf_sagt_cfg.m_max_data_size = 128;
  iosf_svc_cfg.m_max_data_size  = 128;

  // Enable parity
  iosf_svc_cfg.parity_en = 1'b1;

   if($test$plusargs("SIDE_NAK"))begin
  iosf_svc_cfg.rand_idle_nak_support = 1'b1;
  end

  if ($value$plusargs("HQM_IOSF_SB_NP_CRD_BUF=%d", sb_np_crd_buf)) begin 
      iosf_svc_cfg.np_crd_buffer = sb_np_crd_buf;
  end 
  if ($value$plusargs("HQM_IOSF_SB_P_CRD_BUF=%d", sb_p_crd_buf)) begin  
      iosf_svc_cfg.pc_crd_buffer = sb_p_crd_buf;
  end 

  //To turn off xaction level constraints for src, dest and opcode
  //Set these config fields
  //iosf_sagt_cfg.turn_off_txn_constraints = 1;
  //iosf_svc_cfg.turn_off_txn_constraints = 1;
      
  //Pass fabric_cfg and agent_cfg 
  set_config_object("*", "fabric_cfg", iosf_svc_cfg, 0);
  set_config_object("*", "agent_cfg", iosf_sagt_cfg, 0);
          
//  // -- Build PCIe IOSF compliance checker -- //
    set_config_object("sideband_decoder_hqm_i", "iosf_svc_tlm", iosf_svc, 0);

    sideband_decoder_hqm_i = hqm_iosf_sb_decoder::type_id::create("sideband_decoder_hqm_i", this);
    sideband_checker_hqm_i = hqm_iosf_sb_checker::type_id::create("sideband_checker_hqm_i", this);
    set_config_object("*", "sideband_checker_hqm_i",  sideband_checker_hqm_i, 0);

  m_clk_ctrl1 = clk_control::type_id::create("clk_ctrl1", this);
  m_clk_ctrl2 = clk_control::type_id::create("clk_ctrl2", this);

  i_hqm_tap_rtdr_common_val_env = hqm_tap_rtdr_common_val_env::type_id::create("i_hqm_tap_rtdr_common_val_env", this);
  i_hqm_tap_rtdr_common_val_env.set_level(SLA_SUB);
  //i_dft_common_val_env = dft_common_val_env::type_id::create("i_dft_common_val_env", this);
  //i_dft_common_val_env.set_level(SLA_SUB);


  i_hqm_func_cov_collector = hqm_func_cov_collector::type_id::create("i_hqm_func_cov_collector", this);

  i_hqm_transaction_checker = hqm_transaction_checker::type_id::create("i_hqm_transaction_checker", this);

  //--AY_HQMV30_ATS
  pvcMRdCB = HqmIosfMRdCb::type_id::create("pvcMRdCB", this);
  pvcMRdCB.set_cfg_obj(hqmCfg);


  if (_level == SLA_TOP) begin
      // -- Add new phases for PCIE config and PCIE EOT checks
      add_test_phase("PCIE_CONFIG_PHASE", "CONFIG_PHASE", "BEFORE"); // --> For doing all PCIE related configurations
      add_test_phase("POST_CONFIG_PHASE", "CONFIG_PHASE", "AFTER"); // --> Currently used to enable hw agitation.
      add_test_phase("PRE_FLUSH_PHASE",  "FLUSH_PHASE", "BEFORE");  // --> Currently using it to disable hw agitation.
      add_test_phase("PCIE_FLUSH_PHASE", "FLUSH_PHASE", "AFTER");  // --> For all PCIE related EOT checks
  end

  if ($test$plusargs("HQM_IOSF_SB_ISM_CREDIT_REQ_DELAY")) begin
      
      int unsigned credit_req_delay;

      void'($value$plusargs("HQM_IOSF_SB_ISM_CREDIT_REQ_DELAY=%0d", credit_req_delay));
      `ovm_info(get_full_name(), $psprintf("HQM_IOSF_SB_ISM_CREDIT_REQ_DELAY(%0d) plusarg provided", credit_req_delay), OVM_LOW)
      iosf_svc.set_creditreq_delay(credit_req_delay);
  end

endfunction


//--------------------------------------------------------
//
//--------------------------------------------------------
function void hqm_tb_env::connect();
    //integenv_pkg::IntegEnvQueue_t temp_container;
    int req_credits;
    hqm_iosf_prim_msix_int_mon  hqm_msix_int_mon;
    hqm_iosf_prim_ims_int_mon   hqm_ims_int_mon;
    bit rc;

    super.connect();

    //temp_container = this.getIntegEnvDescendants("HQM","");
    //if (temp_container.size() == 0 ) 
    //  `ovm_fatal (get_name(), "Found no HQM")
    //else if (temp_container.size() > 1) 
    //   `ovm_fatal (get_name(), "Found more than one HQM")
    //else 
    //   assert ($cast (hqm_agent_env_handle, temp_container[0] ) ) else `ovm_fatal (get_name(), "Casting to hqm_agent_env failed")    
    //temp_container.delete();     

    i_hqm_func_cov_collector.set_inst_suffix(hqm_agent_env_handle.hqm_config_suffix);

    // -- Setting credits for Fabric to advertise to HQM -- //
    if(!$value$plusargs("hqm_iosf_prim_req_credits=%d",req_credits)) req_credits = 19;

    //iosf_pvc.setPReqCredit  (.endpoint(1), .channel(0), .credit(req_credits));
    //iosf_pvc.setNpReqCredit (.endpoint(1), .channel(0), .credit(req_credits));
    //iosf_pvc.setCReqCredit  (.endpoint(1), .channel(0), .credit(req_credits));

    //-- add_sequencer
    if ( _level == SLA_TOP ) begin
      //void'(this.add_sequencer( "HQM", "primary", hqm_agent_env_handle.iosf_pvc.getSequencer() ));
      void'(this.add_sequencer( "HQM", "GPSB_DSTID_21", iosf_svc.fbrcvc_sequencer ));
      //void'(this.add_sequencer("IOSFSB", iosf_sb_sla_pkg::get_src_type(), get_sla_sqcr()));
      //void'(add_sequencer("IOSFSB", iosf_sb_sla_pkg::get_src_type(), iosf_svc.fbrcvc_sequencer ));
      void'(this.add_sequencer("HQM",iosf_sb_sla_pkg::get_src_type(), iosf_svc.fbrcvc_sequencer ));
      void'(this.add_sequencer("iosf_pri_source", sla_iosf_pri_reg_lib_pkg::get_src_type(),hqm_agent_env_handle.iosf_pvc.getSequencer()));      
      void'(this.add_sequencer("iosf_pri_source", "s0.f0.iosfp0.to_socket",hqm_agent_env_handle.iosf_pvc.getSequencer())); //string agent_type, sla_agent_name_t agent_name, ovm_sequencer_base sequencer
      void'(this.add_sequencer( "HQM", "reset_sequencer", i_reset_agent.sequencer));

      hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfFabPolicy = HqmIosfFabPolicy::type_id::create("iosfFabPolicy");
    end

//  // Build pcie_subenv //
    //pins = sla_resource_db #(virtual hqm_ss_ti_if)::get("hqm_ss_ti_vif", `__FILE__, `__LINE__);
    //assert(pins) `ovm_info(get_type_name(), "hqm_ss_ti_if has been obtained", OVM_NONE)

    m_clk_ctrl1.set_clk_path("hqm_tb_top.clk_inst1");    
    m_clk_ctrl2.set_clk_path("hqm_tb_top.clk_inst2");    
  
    //IOSF primary connection
    $cast(hqm_msix_int_mon,hqm_agent_env_handle.i_hqm_msix_int_mon);
    $cast(hqm_ims_int_mon,hqm_agent_env_handle.i_hqm_ims_int_mon);

    hqm_agent_env_handle.iosf_pvc.iosfMonAnalysisPort.connect(hqm_msix_int_mon.pvc_mon_export);
    hqm_agent_env_handle.iosf_pvc.iosfMonAnalysisPort.connect(hqm_ims_int_mon.pvc_mon_export);

    hqm_agent_env_handle.i_hqm_iosf_prim_mon.i_iosf_trans_type_port.connect(i_hqm_func_cov_collector.iosf_trans_type_export);
    hqm_agent_env_handle.i_hqm_iosf_prim_mon.i_hcw_enq_in_port.connect(i_hqm_func_cov_collector.hcw_trans_analysis_imp);
    hqm_agent_env_handle.i_hqm_iosf_prim_mon.i_iosf_trans_type_port.connect(i_hqm_transaction_checker.iosf_prim_trans_analysis_imp);

    sideband_decoder_hqm_i.i_iosf_sb_txn_port.connect(sideband_checker_hqm_i.hqm_iosf_sb_txn_imp);
 
    //--preloader
    ////`INIT_FUNC_SYSTEM_LEVEL_RPELOAD_CONNECT_TLM_ENTITIES
    //connect_tlm_entities();

    //----------------------
    //--AY_HQMV30_ATS
    //----------------------
    pvcMRdCB.iommu_api    = hqm_agent_env_handle.AtsEnv.get_iommu_api();
    pvcMRdCB.i_hqm_tb_cfg = hqm_agent_env_handle.i_hqm_tb_cfg;

    // Register PVC Callback with Fabric VC
    if($test$plusargs("HQMV30_ATS_IOSFCB_TEST")) begin
       rc = hqm_agent_env_handle.iosf_pvc.registerCallBack(pvcMRdCB, {Iosf::MWr64, Iosf::MWr32, Iosf::MRd64, Iosf::MRd32, Iosf::Msg0, Iosf::MsgD2}); //--temp for debug-- Iosf::MWr64, Iosf::MWr32 
    end else begin
       rc = hqm_agent_env_handle.iosf_pvc.registerCallBack(pvcMRdCB, {Iosf::MRd64, Iosf::MRd32, Iosf::Msg0, Iosf::MsgD2});
    end 

    if (!rc) begin
          `ovm_fatal(get_name(), "HQM_ENV__connect Failed to register custom IOSF PVC callback with IOSF Primary Fab VC!")
    end

    ovm_report_info(get_type_name(),$psprintf("HQM_ENV__connect done"), OVM_DEBUG); 
endfunction

  //---------------------
  //-- start_of_simulation()
  //--------------------- 
  function void hqm_tb_env::start_of_simulation();
    int skew_offset;
    int phase_adjust=10;
    skew_offset = $urandom_range(5,50);
    get_config_int("skew_offset",skew_offset);
    get_config_int("phase_adjust",phase_adjust);

     //sla_config_manager_env cfg_mgr = sla_config_manager_env::get_ptr();
     super.start_of_simulation();
     // shift the clock source in ps
     m_clk_ctrl2.refclk_offset(skew_offset);

     // set the period of x1clk in ps -- not required now, kept control if required in future
     //m_clk_ctrl2.refclk_phase(phase_adjust); 

     if ( _level == SLA_TOP) begin
          //Top-level env can randomize the RAL and all randomizable registers' fields
          //cfg_mgr.randomize_me();


          //-- ral 
          //ral.randomize();

     end
     if (strap_hqm_16b_portids) begin
         set_subnetportid("22");
     end 
  endfunction


  //---------------------
  //-- end_of_elaboration()
  //--------------------- 
  function void hqm_tb_env::end_of_elaboration();
    string hqm_misc_if_handle_name;

    super.end_of_elaboration();
    if (!get_config_string("hqm_misc_if_handle",hqm_misc_if_handle_name)) begin 
      `ovm_fatal(get_full_name(), "Unable to find hqm_misc_if_handle config string ");
    end

    `sla_get_db(pins,virtual hqm_misc_if, hqm_misc_if_handle_name);
    assert(pins) `ovm_info(get_full_name(), "hqm_misc_if has been obtained", OVM_NONE) else
                 `ovm_error(get_full_name(), "Null hqm_misc_if has been obtained")

  endfunction : end_of_elaboration



  //---------------------
  //-- set_clk_rst()
  //--------------------- 
 task hqm_tb_env::set_clk_rst();
   fork
    //Connect the system core clock signal to the sla_tb_env.
    //Core clock is needed to drive the test flow.
    
    forever begin
      if(pins.prochot_asserted) begin #4ns  ; end
      else                      begin #0.5ns; end

      -> sys_clk_r;

       -> ral.ref_clk;

      if(pins.prochot_asserted) begin #4ns  ; end
      else                      begin #0.5ns; end

      -> sys_clk_f;

      if(pins.prochot_asserted) `ovm_info(get_full_name(), $psprintf("Prochot asserted, so slowing sys_clk_r!!!"), OVM_DEBUG);

    end
   
    //Connect the system reset signal to the sla_tb_env.
    forever begin
      #0;
      -> sys_rst_r;
      #1000ns
      -> sys_rst_f;
    end
  join_none;
  
 endtask : set_clk_rst  
 
 // -----------------------------------------------------------------------------
 // -- Set subnetportid 
 // -----------------------------------------------------------------------------
  function void hqm_tb_env::set_subnetportid (string subnetportid = "22");

  sla_ral_file my_files[$];
  sla_ral_reg  my_regs[$];

  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  `ovm_info(get_full_name(), $sformatf("setting subnetportid = %s", subnetportid), OVM_LOW)
  ral.get_reg_files(my_files);
  `ovm_info(get_full_name(), $sformatf("size of register files = %0d", my_files.size()), OVM_LOW)
  
  if (my_files.size() == 0) begin 
    `ovm_error(get_full_name(),$sformatf(" my_files size is zero %d", my_files.size()))
  end
  else begin 
     foreach (my_files[i]) begin  
        `ovm_info(get_full_name(),$sformatf("files[%0d]=%s",i,my_files[i].get_name()),OVM_MEDIUM)
        my_files[i].get_regs(my_regs);
        `ovm_info(get_full_name(), $sformatf("size of registers %0d in file %0s", my_regs.size(), my_files[i].get_name()), OVM_LOW)
        if (my_regs.size() == 0) begin 
          `ovm_error(get_full_name(),$sformatf(" my_regs size is zero %d", my_regs.size()))
        end
        else begin 
           foreach (my_regs[i]) begin
              `ovm_info(get_full_name(),$sformatf("regs[%0d]=%s",i,my_regs[i].get_name()),OVM_MEDIUM)
              my_regs[i].set_user_attribute("SubnetPortID", subnetportid);
           end
        end 
        my_regs = {};
        `ovm_info(get_full_name(), $sformatf("size of registers %0d in file %0s", my_regs.size(), my_files[i].get_name()), OVM_LOW)
     end
  end
  my_files = {};
  `ovm_info(get_full_name(), $sformatf("size of register files = %0d", my_files.size()), OVM_LOW)
  endfunction : set_subnetportid 

  // -----------------------------------------------------------------------------
  // -- Returns strap value given plusarg name
  // -----------------------------------------------------------------------------
  function longint hqm_tb_env::get_strap_val(string plusarg_name, longint default_val, bit mode);
    string val_string = "";
    if(!$value$plusargs({$sformatf("%s",plusarg_name),"=%s"}, val_string)) begin
       get_strap_val = default_val; // -- Assign default value of strap, if no plusarg provided -- //
    end
    else if (lvm_common_pkg::token_to_longint(val_string,get_strap_val) == 0) begin
      `ovm_error(get_full_name(),$psprintf("+%s=%s not a valid integer value",plusarg_name,val_string))
      get_strap_val = default_val; // -- Assign default value of strap, if invalid plusarg usage -- //
    end
    if (mode == 1) begin  // 16bit mode 
      if (~(|get_strap_val[15:8])) begin 
         get_strap_val[15:8] = default_val[15:8];
      end  
    end 

    // -- Finally print the resolved strap value -- //
    `ovm_info(get_full_name(), $psprintf("Resolved strap (%s) with value (0x%0x) is_16bitmode (%0d)", plusarg_name, get_strap_val, mode), OVM_LOW);

  endfunction
`endif
