//-----------------------------------------------------------------------------
// Title              : hqm_reset_cycle_sequence.svh
//-----------------------------------------------------------------------------
// Owner              : nkshete
// Creation Date      : Sep 25 2019
//-----------------------------------------------------------------------------
// Copyright (c) 2019 by Intel Corporation. This model is the confidential and
// proprietary property of Intel Corporation and the possession or use of this
// file requires a written license from Intel Corporation.
//------------------------------------------------------------------------------

// Title: hqm_reset_cycle_sequence
// Intent: <hqm_reset_cycle_sequence> sequence.

`include "stim_config_macros.svh";
`include "stim_policy_macros.svh";

typedef enum int {

  no_hcw_sc_ur_txns_arb_dly        = 0
, no_hcw_sc_ur_txns_min_dly        = 1
, no_hcw_sc_ur_txns_max_dly        = 2
, no_hcw_sc_txns_arb_dly           = 3
, no_hcw_sc_txns_min_dly           = 4
, no_hcw_sc_txns_max_dly           = 5
, no_hcw_ur_txns_arb_dly           = 6
, no_hcw_ur_txns_min_dly           = 7
, no_hcw_ur_txns_max_dly           = 8

, pf_hcw_sc_ur_txns_arb_dly        = 9
, pf_hcw_sc_ur_txns_min_dly        = 10
, pf_hcw_sc_ur_txns_max_dly        = 11
, pf_hcw_sc_txns_arb_dly           = 12
, pf_hcw_sc_txns_min_dly           = 13
, pf_hcw_sc_txns_max_dly           = 14
, pf_hcw_ur_txns_arb_dly           = 15
, pf_hcw_ur_txns_min_dly           = 16
, pf_hcw_ur_txns_max_dly           = 17

, vf_hcw_sc_ur_txns_arb_dly        = 18
, vf_hcw_sc_ur_txns_min_dly        = 19
, vf_hcw_sc_ur_txns_max_dly        = 20
, vf_hcw_sc_txns_arb_dly           = 21
, vf_hcw_sc_txns_min_dly           = 22
, vf_hcw_sc_txns_max_dly           = 23
, vf_hcw_ur_txns_arb_dly           = 24
, vf_hcw_ur_txns_min_dly           = 25
, vf_hcw_ur_txns_max_dly           = 26

, sciov_sc_ur_txns_arb_dly         = 27 
, sciov_sc_ur_txns_min_dly         = 28
, sciov_sc_ur_txns_max_dly         = 29
, sciov_sc_txns_arb_dly            = 30
, sciov_sc_txns_min_dly            = 31
, sciov_sc_txns_max_dly            = 32
, sciov_ur_txns_arb_dly            = 33
, sciov_ur_txns_min_dly            = 34
, sciov_ur_txns_max_dly            = 35

, pf_hcw_ur_txns_aer_msg           = 36

, pf_hcw_ur_txns_msix_msi          = 37

, cold_rst_with_flr                = 38
, cold_rst_with_d3_trans           = 39
, cold_rst_in_d3                   = 40
, cold_rst_in_d2                   = 41
, cold_rst_in_d1                   = 42
, cold_rst_in_d0                   = 43

, warm_rst_with_flr                = 44
, warm_rst_with_d3_trans           = 45
, warm_rst_in_d3                   = 46
, warm_rst_in_d2                   = 47
, warm_rst_in_d1                   = 48
, warm_rst_in_d0                   = 49

} reset_cycle_scenario_t ;

typedef enum int {
  cold   = 0
, warm   = 1
, flr    = 2
, no_rst = 3
} rst_t ;

typedef enum int {
  sc_only = 0
, ur_only = 1
, sc_ur   = 2
, no_txn  = 3
} txn_t ;

typedef enum int {
  arb = 0
, min = 1
, max = 2
} dly_t ;

typedef enum int {
  pf_hcw     = 0
, vf_hcw     = 1
, sciov      = 2
, no_hcw     = 3
} hcw_t ;

//------------------------------------------------------------------------------
// Class: hqm_reset_cycle_sequence_stim_config
// Stim_Config class for hqm_reset_cycle_sequence. 
// Encapsulates all rand and non rand variables and constraints which control
// the sequence.  All constraints must be "soft" constraints.
//------------------------------------------------------------------------------
class hqm_reset_cycle_sequence_stim_config extends ovm_object;
   // Variable: stim_cfg_name
   // Static string that must be used to set/get the stim_config object from the stim config db.
   // Using this string will prevent typos.
   static string stim_cfg_name = "hqm_reset_cycle_sequence_stim_config";

   // OVM Field Macros
   // Required to provide copy/clone functions.
   `ovm_object_utils_begin(hqm_reset_cycle_sequence_stim_config)
      `ovm_field_int       (rand_value,                OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
      `ovm_field_int       (num_sch,                   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
      `ovm_field_int       (num_enq,                   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
      `ovm_field_int       (avoid_prim_txns_in_flr,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
      `ovm_field_int       (extend_prim_txns_in_rst,   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
      `ovm_field_int       (extend_sb_txns_in_rst,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
      `ovm_field_int       (outstanding_np_req_inc,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
      `ovm_field_queue_int (value_q,                   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
      `ovm_field_enum      (reset_cycle_scenario_t,    scenario,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
   `ovm_object_utils_end

   // Stimulus Config Field Macros
   // Required to provide commandline arg parsing
   `stimulus_config_object_utils_begin(hqm_reset_cycle_sequence_stim_config)
      `stimulus_config_field_rand_int (rand_value)
      `stimulus_config_field_int      (num_sch)
      `stimulus_config_field_int      (num_enq)
      `stimulus_config_field_int      (avoid_prim_txns_in_flr)
      `stimulus_config_field_int      (extend_prim_txns_in_rst)
      `stimulus_config_field_int      (extend_sb_txns_in_rst)
      `stimulus_config_field_int      (outstanding_np_req_inc)
      `stimulus_config_field_queue_int(value_q)
      `stimulus_config_field_rand_enum(reset_cycle_scenario_t,scenario)
   `stimulus_config_object_utils_end

   // Variable: rand_value
   // FIXME: USER MUST REPLACE THIS WITH REAL VARIABLE
   rand int unsigned rand_value;

   // Variable: num_sch
   int unsigned num_sch = 50;

   // Variable: num_enq
   int unsigned num_enq = 4000;

   // Variable: avoid_prim_txns_in_flr
   int unsigned avoid_prim_txns_in_flr = 1;

   // Variable: extend_prim_txns_in_rst
   int unsigned extend_prim_txns_in_rst = 0;

   // Variable: extend_sb_txns_in_rst
   int unsigned extend_sb_txns_in_rst = 0;

   // Variable: outstanding_np_req_inc
   int unsigned outstanding_np_req_inc = 5;

   // Variable: value_q
   // FIXME: USER MUST REPLACE THIS WITH REAL VARIABLE
   int unsigned value_q[$];

   // Variable: scenario
   // FIXME: USER MUST REPLACE THIS WITH REAL VARIABLE
   rand reset_cycle_scenario_t scenario;

   // Constraint: constraint_rand_value
   // FIXME: USER MUST REPLACE THIS WITH REAL CONSTRAINT
   constraint constraint_rand_value {
      soft rand_value inside { [1:9] };
   }

   // Constraint: constraint_scenario
   // FIXME: USER MUST REPLACE THIS WITH REAL CONSTRAINT
   constraint constraint_scenario {
      soft scenario == no_hcw_sc_ur_txns_arb_dly ;
   }

   //------------------------------------------------------------------------------
   // LocalFunction: new
   // Constructor for OVM object.
   //
   // Inputs:
   //   name - Name for this OVM object.
   //------------------------------------------------------------------------------
   function new(string name = "hqm_reset_cycle_sequence_stim_config");
      super.new(name);
   endfunction : new
endclass : hqm_reset_cycle_sequence_stim_config


//------------------------------------------------------------------------------
// Class: hqm_reset_cycle_sequence
// FIXME: USER MUST FILL IN DESCRIPTION AND INTENT OF SEQUENCE
//------------------------------------------------------------------------------
class hqm_reset_cycle_sequence extends hqm_sla_pcie_base_seq;
   `ovm_object_utils(hqm_reset_cycle_sequence)

   `STIMULUS_POLICY_SEQUENCE_DECLARATION(hqm_reset_cycle_sequence);
   `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_reset_cycle_sequence_stim_config);

   // Variable: cfg
   // Random configuration object for the sequence.
   rand hqm_reset_cycle_sequence_stim_config cfg;

   IosfAgtSeqr pvc_seqr;

   hqm_cfg                       i_hqm_cfg;
   hqm_tb_hcw_scoreboard         i_hcw_scoreboard;
   hqm_pp_cq_status              i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed
   ral_pfrst_seq                 rst_hqm_cfg;

   hcw_pf_test_cfg_seq             pf_cfg_seq;
   hcw_pf_test_multi_hcw_seq       pf_hcw_seq;

   hcw_sciov_test_cfg_seq          sciov_cfg_seq;
   hcw_sciov_test_hcw_seq          sciov_hcw_seq;

   hqm_sla_pcie_rand_bdf_seq       rand_bdf_seq;

   hqm_sla_pcie_eot_checks_sequence     eot_seq;
   hqm_sla_pcie_init_seq          pcie_init_seq;

   hqm_sla_pcie_flr_sequence flr_seq;
   hqm_cold_reset_sequence   cold_rst;
   hqm_reset_init_sequence   warm_rst;
 
   hqm_sb_base_seq           sb_base;

   ovm_event_pool            glbl_pool;
   ovm_event                 hqm_ResetPrepAck;

   // -------------------------------------------------------
   // -- Local scenario control variables
   // -------------------------------------------------------
   txn_t txn = sc_only;
   txn_t prev_txn ;
   dly_t dly = arb;
   hcw_t hcw = pf_hcw;
   rst_t rst = cold;

   protected bit   change_bus_num = 0;
   protected bit   inject_rst     = 0;
   protected bit   skip_checks    = 1;
   protected bit   enq_start      = 0;
   protected bit   hcw_process_on = 0;
   protected bit   rst_done       = 0;
   protected bit   issue_sb_txn   = 1;

   protected bit   first_pass     = 1;

   protected bit   resetprepack_recd = 0;

   //------------------------------------------------------------------------------
   // LocalFunction: new
   // Constructor for OVM Sequence.
   //
   // Inputs:
   //   name            - Name for this OVM object.
   //   sequencer       - Pointer to sequencer.
   //   parent_sequence - Pointer to parent sequence.
   //------------------------------------------------------------------------------
   function new(string name="hqm_reset_cycle_sequence", ovm_sequencer_base sequencer_ptr = null, ovm_sequence_base parent_seq = null);
      super.new(name);
      glbl_pool = ovm_event_pool::get_global_pool();
      hqm_ResetPrepAck = glbl_pool.get("hqm_ResetPrepAck");
      `STIMULUS_POLICY_SEQUENCE_CONSTRUCTOR;
      cfg = hqm_reset_cycle_sequence_stim_config::type_id::create("hqm_reset_cycle_sequence_stim_config");
      `APPLY_STIM_CONFIG_OVERRIDES_BEFORE_RANDOMIZE;
   endfunction : new

  function get_hcw_tb_scoreboard_handle();
    ovm_object o_tmp;
    //-----------------------------
    //-- get i_hcw_scoreboard
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hcw_scoreboard", o_tmp)) begin
                 ovm_report_fatal(get_full_name(), "Unable to find i_hcw_scoreboard object");
    end

    if (!$cast(i_hcw_scoreboard, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config_i_hcw_scoreboard %s associated with config %s is not same type", o_tmp.sprint(), i_hcw_scoreboard.sprint()));
    end else begin
      ovm_report_info(get_full_name(), $psprintf("i_hcw_scoreboard retrieved"), OVM_DEBUG);
    end
  endfunction


  function get_hqm_pp_cq_status_handle();
    ovm_object o_tmp;
    //-----------------------------
    //-- get i_hqm_pp_cq_status 
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_pp_cq_status", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
    end

    if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
    end else begin
      ovm_report_info(get_full_name(), $psprintf("i_hqm_pp_cq_status retrieved"), OVM_DEBUG);
    end
  endfunction

   //------------------------------------------------------------------------------
   // LocalTask: body
   // Entry point to the sequence.  Sequence intention goes here
   //------------------------------------------------------------------------------
   virtual task body();
      `APPLY_STIM_CONFIG_OVERRIDES_AFTER_RANDOMIZE;

    //-----------------------------
    //-- get i_hqm_pp_cq_status
    //-----------------------------
    get_hqm_pp_cq_status_handle();
  
    //-----------------------------
    //-- get_hcw_tb_scoreboard_handle 
    //-----------------------------
    get_hcw_tb_scoreboard_handle();
 
    //-----------------------------
    //-- get hqm_cfg handle 
    //-----------------------------
    if (i_hqm_cfg == null) begin i_hqm_cfg = hqm_cfg::get(); if (i_hqm_cfg == null) begin ovm_report_fatal(get_full_name(), $psprintf("Unable to get CFG object")); end end
 
    //-----------------------------
    //-- get pvc handle 
    //-----------------------------
    pvc_seqr = hqm_env.hqm_agent_env_handle.iosf_pvc.getSequencer();

      run_scenario();

      wait_ns_clk(90000);

      if(rst != no_rst) prim_checker_reset();

      if(rst inside {warm, cold, flr}) `ovm_do(pcie_init_seq)

      hqm_cfg_reset();

      juggle_scenario();

      run_scenario();

      wait_ns_clk(7000);

      if(rst inside {warm, cold, flr}) `ovm_do(pcie_init_seq)

      begin

         bit rw1cs = rst inside {no_rst, flr};
         bit rw1c  = rst inside {no_rst};

         //--`ovm_do_with(eot_seq, {func_no == 0; test_induced_ced == rw1c; test_induced_urd == rw1c; test_induced_anfes == rw1cs; })

         pf_cfg_regs.PCIE_CAP_DEVICE_STATUS.write(status,16'h_b,primary_id,this,.sai(legal_sai));
         pf_cfg_regs.AER_CAP_CORR_ERR_STATUS.write(status,'h_2000,primary_id,this,.sai(legal_sai));
         pf_cfg_regs.AER_CAP_UNCORR_ERR_STATUS.write(status,'h_100000,primary_id,this,.sai(legal_sai));

      end

         pf_cfg_regs.AER_CAP_UNCORR_ERR_STATUS.read(status,rd_val,iosf_sb_sla_pkg::get_src_type(),this,.sai(legal_sai));
         pf_cfg_regs.AER_CAP_UNCORR_ERR_STATUS.read(status,rd_val,primary_id,this,.sai(legal_sai));

	  // -----------------------------------------------------------------------------
	  // -- Masking checks from PVC as some of the completions might be lost from HQM 
	  // -- for NP requests sent during reset. 
	  // -----------------------------------------------------------------------------
	  hqm_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[0].Disable_Final_Checks=1'b_1;
	  hqm_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[1].Disable_Final_Checks=1'b_1;
     
         `ifdef HQM_IOSF_2019_BFM
      hqm_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtSlvTlm.expTgtTxnQ.q.delete();
         `else
            hqm_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtTgtTlm.expTgtTxnQ.q.delete();
         `endif

   endtask : body

   function is_sciov_scenario(reset_cycle_scenario_t rst_scenario); 
      is_sciov_scenario = rst_scenario inside {
                                                 sciov_sc_ur_txns_arb_dly
                                               , sciov_sc_ur_txns_min_dly
                                               , sciov_sc_ur_txns_max_dly
                                               , sciov_sc_txns_arb_dly   
                                               , sciov_sc_txns_min_dly   
                                               , sciov_sc_txns_max_dly   
                                               , sciov_ur_txns_arb_dly   
                                               , sciov_ur_txns_min_dly   
                                               , sciov_ur_txns_max_dly   
                                               }; 
   endfunction : is_sciov_scenario

   function is_rst_without_bus_num_change(reset_cycle_scenario_t rst_scenario); 
      is_rst_without_bus_num_change = rst_scenario inside {
                                                            cold_rst_with_flr      
                                                          , cold_rst_with_d3_trans 
                                                          , cold_rst_in_d3         
                                                          , cold_rst_in_d2         
                                                          , cold_rst_in_d1         
                                                          , cold_rst_in_d0         
                                                          
                                                          , warm_rst_with_flr      
                                                          , warm_rst_with_d3_trans 
                                                          , warm_rst_in_d3         
                                                          , warm_rst_in_d2         
                                                          , warm_rst_in_d1         
                                                          , warm_rst_in_d0         

                                                          , pf_hcw_ur_txns_aer_msg 
                                                          , pf_hcw_ur_txns_msix_msi

                                               }; 

   endfunction : is_rst_without_bus_num_change

   function hqm_cfg_reset(); i_hqm_cfg.reset_hqm_cfg(); endfunction : hqm_cfg_reset

   function prim_checker_reset();

      `ovm_info(get_full_name(), $psprintf("Start ------- prim_checker_reset "), OVM_LOW);
       
      `ovm_info(get_full_name(), $psprintf("Before resetPhase ------- prim_checker_reset pvc_seqr.display_queues(%s)", pvc_seqr.display_queues()), OVM_LOW);

      hqm_env.hqm_agent_env_handle.i_hqm_iosf_prim_checker.reset_txnid_q();
      hqm_env.hqm_agent_env_handle.i_hqm_iosf_prim_checker.reset_ep_bus_num_q();
      hqm_env.hqm_agent_env_handle.i_hqm_iosf_prim_checker.reset_func_flr_status();
      // -- hqm_env.hqm_agent_env_handle.i_hqm_iosf_prim_checker.set_bypass_cplid_check(0);

      hqm_env.hqm_agent_env_handle.iosf_pvc.resetPhase();

      pvc_seqr.stop_sequences();

      `ovm_info(get_full_name(), $psprintf("After  resetPhase ------- prim_checker_reset pvc_seqr.display_queues(%s)", pvc_seqr.display_queues()), OVM_LOW);

      `ovm_info(get_full_name(), $psprintf("End   ------- prim_checker_reset "), OVM_LOW);

   endfunction : prim_checker_reset

 
   function set_scenario_controls();

      skip_checks    = 1;
      inject_rst     = 0;
      enq_start      = 0;
      hcw_process_on = 0;
      rst_done       = 0;
      issue_sb_txn   = 1;

      resetprepack_recd = 0;

      if(first_pass) begin std::randomize(rst) with {rst != no_rst;}; first_pass = 0; end else begin rst = no_rst; end

      case(cfg.scenario)

         no_hcw_sc_ur_txns_arb_dly : begin    hcw=no_hcw  ; dly=arb; txn=sc_ur;          end
         no_hcw_sc_ur_txns_min_dly : begin    hcw=no_hcw  ; dly=min; txn=sc_ur;          end
         no_hcw_sc_ur_txns_max_dly : begin    hcw=no_hcw  ; dly=max; txn=sc_ur;          end

         no_hcw_sc_txns_arb_dly    : begin    hcw=no_hcw  ; dly=arb; txn=sc_only;        end
         no_hcw_sc_txns_min_dly    : begin    hcw=no_hcw  ; dly=min; txn=sc_only;        end
         no_hcw_sc_txns_max_dly    : begin    hcw=no_hcw  ; dly=max; txn=sc_only;        end

         no_hcw_ur_txns_arb_dly    : begin    hcw=no_hcw  ; dly=arb; txn=ur_only;        end
         no_hcw_ur_txns_min_dly    : begin    hcw=no_hcw  ; dly=min; txn=ur_only;        end
         no_hcw_ur_txns_max_dly    : begin    hcw=no_hcw  ; dly=max; txn=ur_only;        end

         pf_hcw_sc_ur_txns_arb_dly : begin    hcw=pf_hcw  ; dly=arb; txn=sc_ur;          end
         pf_hcw_sc_ur_txns_min_dly : begin    hcw=pf_hcw  ; dly=min; txn=sc_ur;          end
         pf_hcw_sc_ur_txns_max_dly : begin    hcw=pf_hcw  ; dly=max; txn=sc_ur;          end

         pf_hcw_sc_txns_arb_dly    : begin    hcw=pf_hcw  ; dly=arb; txn=sc_only;        end
         pf_hcw_sc_txns_min_dly    : begin    hcw=pf_hcw  ; dly=min; txn=sc_only;        end
         pf_hcw_sc_txns_max_dly    : begin    hcw=pf_hcw  ; dly=max; txn=sc_only;        end

         pf_hcw_ur_txns_arb_dly    : begin    hcw=pf_hcw  ; dly=arb; txn=ur_only;        end
         pf_hcw_ur_txns_min_dly    : begin    hcw=pf_hcw  ; dly=min; txn=ur_only;        end
         pf_hcw_ur_txns_max_dly    : begin    hcw=pf_hcw  ; dly=max; txn=ur_only;        end

         vf_hcw_sc_ur_txns_arb_dly : begin    hcw=vf_hcw  ; dly=arb; txn=sc_ur;          end
         vf_hcw_sc_ur_txns_min_dly : begin    hcw=vf_hcw  ; dly=min; txn=sc_ur;          end
         vf_hcw_sc_ur_txns_max_dly : begin    hcw=vf_hcw  ; dly=max; txn=sc_ur;          end

         vf_hcw_sc_txns_arb_dly    : begin    hcw=vf_hcw  ; dly=arb; txn=sc_only;        end
         vf_hcw_sc_txns_min_dly    : begin    hcw=vf_hcw  ; dly=min; txn=sc_only;        end
         vf_hcw_sc_txns_max_dly    : begin    hcw=vf_hcw  ; dly=max; txn=sc_only;        end

         vf_hcw_ur_txns_arb_dly    : begin    hcw=vf_hcw  ; dly=arb; txn=ur_only;        end
         vf_hcw_ur_txns_min_dly    : begin    hcw=vf_hcw  ; dly=min; txn=ur_only;        end
         vf_hcw_ur_txns_max_dly    : begin    hcw=vf_hcw  ; dly=max; txn=ur_only;        end

         sciov_sc_ur_txns_arb_dly  : begin    hcw=sciov   ; dly=arb; txn=sc_ur;          end
         sciov_sc_ur_txns_min_dly  : begin    hcw=sciov   ; dly=min; txn=sc_ur;          end
         sciov_sc_ur_txns_max_dly  : begin    hcw=sciov   ; dly=max; txn=sc_ur;          end

         sciov_sc_txns_arb_dly     : begin    hcw=sciov   ; dly=arb; txn=sc_only;        end
         sciov_sc_txns_min_dly     : begin    hcw=sciov   ; dly=min; txn=sc_only;        end
         sciov_sc_txns_max_dly     : begin    hcw=sciov   ; dly=max; txn=sc_only;        end

         sciov_ur_txns_arb_dly     : begin    hcw=sciov   ; dly=arb; txn=ur_only;        end
         sciov_ur_txns_min_dly     : begin    hcw=sciov   ; dly=min; txn=ur_only;        end
         sciov_ur_txns_max_dly     : begin    hcw=sciov   ; dly=max; txn=ur_only;        end

         pf_hcw_ur_txns_aer_msg    : begin    hcw=no_hcw  ; dly=min; txn=no_txn ;        end

         pf_hcw_ur_txns_msix_msi   : begin    hcw=no_hcw  ; dly=arb; txn=no_txn ;        end

         cold_rst_with_flr         : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=cold;    end
         cold_rst_with_d3_trans    : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=cold;    end
         cold_rst_in_d3            : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=cold;    end
         cold_rst_in_d2            : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=cold;    end
         cold_rst_in_d1            : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=cold;    end
         cold_rst_in_d0            : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=cold;    end

         warm_rst_with_flr         : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=warm;    end
         warm_rst_with_d3_trans    : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=warm;    end
         warm_rst_in_d3            : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=warm;    end
         warm_rst_in_d2            : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=warm;    end
         warm_rst_in_d1            : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=warm;    end
         warm_rst_in_d0            : begin    hcw=no_hcw  ; dly=min; txn=no_txn  ; rst=warm;    end

      endcase

   endfunction : set_scenario_controls
 
   function juggle_scenario();

      reset_cycle_scenario_t prev_scenario = cfg.scenario ; 
      reset_cycle_scenario_t next_scenario ; 

      std::randomize(next_scenario) with {next_scenario != prev_scenario; 
                                          next_scenario inside {
                                                               no_hcw_sc_ur_txns_arb_dly    
                                                             , no_hcw_sc_ur_txns_min_dly    
                                                             , no_hcw_sc_ur_txns_max_dly    
                                                             , no_hcw_sc_txns_arb_dly    
                                                             , no_hcw_sc_txns_min_dly    
                                                             , no_hcw_sc_txns_max_dly    
                                                             , no_hcw_ur_txns_arb_dly    
                                                             , no_hcw_ur_txns_min_dly    
                                                             , no_hcw_ur_txns_max_dly    
                                                             
                                                             , pf_hcw_sc_ur_txns_arb_dly    
                                                             , pf_hcw_sc_ur_txns_min_dly    
                                                             , pf_hcw_sc_ur_txns_max_dly    
                                                             , pf_hcw_sc_txns_arb_dly    
                                                             , pf_hcw_sc_txns_min_dly    
                                                             , pf_hcw_sc_txns_max_dly    
                                                             , pf_hcw_ur_txns_arb_dly    
                                                             , pf_hcw_ur_txns_min_dly    
                                                             , pf_hcw_ur_txns_max_dly    
                                                             
                                                             , vf_hcw_sc_ur_txns_arb_dly    
                                                             , vf_hcw_sc_ur_txns_min_dly    
                                                             , vf_hcw_sc_ur_txns_max_dly    
                                                             , vf_hcw_sc_txns_arb_dly    
                                                             , vf_hcw_sc_txns_min_dly    
                                                             , vf_hcw_sc_txns_max_dly    
                                                             , vf_hcw_ur_txns_arb_dly    
                                                             , vf_hcw_ur_txns_min_dly    
                                                             , vf_hcw_ur_txns_max_dly    
                                                             
                                                             , sciov_sc_ur_txns_arb_dly    
                                                             , sciov_sc_ur_txns_min_dly    
                                                             , sciov_sc_ur_txns_max_dly    
                                                             , sciov_sc_txns_arb_dly    
                                                             , sciov_sc_txns_min_dly    
                                                             , sciov_sc_txns_max_dly    
                                                             , sciov_ur_txns_arb_dly    
                                                             , sciov_ur_txns_min_dly    
                                                             , sciov_ur_txns_max_dly    
                                                            }; };

      cfg.scenario = next_scenario;

      `ovm_info(get_full_name(), $psprintf("juggle_scenario -> prev scenario was(%s). Next juggled scenario is (%s)", prev_scenario.name(), cfg.scenario.name()), OVM_LOW);

   endfunction : juggle_scenario


   task run_scenario();

      set_scenario_controls();

      if(~is_rst_without_bus_num_change(cfg.scenario)) change_bus_num = (hcw inside {no_hcw}); 

      if((rst == flr) && (cfg.avoid_prim_txns_in_flr == 1)) cfg.extend_prim_txns_in_rst = 0; 

      `ovm_info(get_full_name(), $sformatf("Starting run_scenario with knobs: first_pass(%0d) scenario(%s), rst(%s), txn(%s), dly(%s), hcw(%s), wait for enqueue of (%0d) # of HCW(s), wait for schedule of (%0d) # of HCW(s), enq_start(%0d), change_bus_num(%0d), extend_prim_txns_in_rst(%0d), extend_sb_txns_in_rst(%0d)", first_pass, cfg.scenario.name(), rst.name(), txn.name(), dly.name(), hcw.name(), cfg.num_enq, cfg.num_sch, enq_start, change_bus_num, cfg.extend_prim_txns_in_rst, cfg.extend_sb_txns_in_rst), OVM_LOW)


      fork
          send_prim_txns();
          send_sb_txns();
          send_hcw();
          send_cfgwr_with_bus_num_change();
          inject_intermediate_rst();
      join

      `ovm_info(get_full_name(), $sformatf("Done run_scenario with knobs: first_pass(%0d) scenario(%s), rst(%s), txn(%s), dly(%s), hcw(%s), wait for enqueue of (%0d) # of HCW(s), wait for schedule of (%0d) # of HCW(s), enq_start(%0d), change_bus_num(%0d)", first_pass, cfg.scenario.name(), rst.name(), txn.name(), dly.name(), hcw.name(), cfg.num_enq, cfg.num_sch, enq_start, change_bus_num), OVM_LOW)

   endtask : run_scenario

  task send_prim_txns();

     int unsigned outstanding_np_threshold = 50;

     while(txn != no_txn) begin

       bit ur = $urandom_range(1); 

       `ovm_info(get_full_name(), $psprintf("In send_prim_txns with txn(%s) and ur(%0d) if txn -> sc_ur ; resetprepack_recd(%0d); cfg.outstanding_np_req_inc(%0d);", txn.name(), ur, resetprepack_recd, cfg.outstanding_np_req_inc), OVM_LOW)

       case(txn)

         sc_only  :   send_tlp(get_tlp(ral.get_addr_val(primary_id,hqm_msix_mem_regs.MSG_DATA[0]), Iosf::MRd64), .skip_ur_chk(skip_checks));
         sc_ur    :   send_tlp(get_tlp((ur ? 'h_0 : ral.get_addr_val(primary_id,hqm_msix_mem_regs.MSG_DATA[0])), Iosf::MRd64), .ur(ur), .skip_ur_chk(skip_checks));
         ur_only  :   send_tlp(get_tlp('h_0, Iosf::MRd64), .ur(1), .skip_ur_chk(skip_checks));

       endcase

       wait_ns_clk( ( (dly==min) ? 1 : ( (dly==max) ? 16 : $urandom_range(1,16) ) ) );

       if(hqm_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtReqTlm.npQueue[0].q.size > outstanding_np_threshold) begin
           int unsigned npQ_dly_prim_txn_clks = $urandom_range(30,70);
           `ovm_info(get_full_name(), $sformatf("send_prim_txns: Start --- Delaying accesses by (%0d)ns due to npQueue size(%0d); Next outstanding_np_threshold->(%0d)!!", npQ_dly_prim_txn_clks, hqm_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtReqTlm.npQueue[0].q.size, outstanding_np_threshold), OVM_LOW);
           wait_ns_clk(npQ_dly_prim_txn_clks);
           outstanding_np_threshold = outstanding_np_threshold + cfg.outstanding_np_req_inc;
           `ovm_info(get_full_name(), $sformatf("send_prim_txns: End   --- Delaying accesses by (%0d)ns due to npQueue size(%0d); Next outstanding_np_threshold->(%0d)!!", npQ_dly_prim_txn_clks, hqm_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtReqTlm.npQueue[0].q.size, outstanding_np_threshold), OVM_LOW);
       end

       if(hcw_process_on && ~inject_rst) begin
           int unsigned dly_prim_txn_clks = $urandom_range(300,700);
           `ovm_info(get_full_name(), $sformatf("send_prim_txns: Delaying accesses by (%0d)ns during HCW processing/programming!!", dly_prim_txn_clks), OVM_LOW);
           wait_ns_clk(dly_prim_txn_clks);
       end
           
       if(inject_rst && rst inside {warm, cold} && ~resetprepack_recd) begin 
           `ovm_info(get_full_name(), $psprintf("send_prim_txns: Start --- waiting on hqm_ResetPrepAck as rst type is (%s)", rst.name()), OVM_LOW);
           hqm_ResetPrepAck.wait_trigger();
           resetprepack_recd = 1;
           `ovm_info(get_full_name(), $psprintf("send_prim_txns: End   --- waiting on hqm_ResetPrepAck as rst type is (%s)", rst.name()), OVM_LOW);
       end

     end

     `ovm_info(get_full_name(), $psprintf("Stopping send_prim_txns sequence !!!"), OVM_LOW)

  endtask : send_prim_txns

  task send_sb_txns();

     int unsigned sb_txn_count = 1;

     `ovm_create(sb_base);

     while((txn != no_txn) && (rst != no_rst) && (issue_sb_txn)) begin
 
       bit ur = $urandom_range(1); 

       bit [63:0] addr = sb_base.get_sb_addr("cache_line_size", "hqm_pf_cfg_i"); 
 
       `ovm_info(get_full_name(), $psprintf("In send_sb_txns with txn(%s), sb_txn_count(%0d) and ur(%0d) -> applicable only if txn == sc_ur", txn.name(), sb_txn_count,  ur), OVM_LOW)

       sb_base.send_cfg_sb_msg(addr, .rd(1), .fid((ur ? 255 : 0)), .exp_rsp(0));
 
       wait_ns_clk( $urandom_range(5,16) );

       sb_txn_count++;

       if(sb_txn_count%50 == 0) begin
            `ovm_info(get_full_name(), $psprintf("send_sb_txns : --- Start wait as sb_txn_count(%0d)", sb_txn_count), OVM_LOW);
            wait_ns_clk(3000);
            `ovm_info(get_full_name(), $psprintf("send_sb_txns : --- Done  wait as sb_txn_count(%0d)", sb_txn_count), OVM_LOW);
       end 

     end

     `ovm_info(get_full_name(), $psprintf("Stopping send_sb_txns sequence !!!"), OVM_LOW)

  endtask : send_sb_txns

  task send_hcw();

     bit hcw_processing_done = 0;

     `ovm_info(get_full_name(), $psprintf("Starting send_hcw sequence with mode(%s)!!!", hcw.name()), OVM_LOW)

     fork
         begin 

             hcw_process_on = 1; 

             `ovm_info(get_full_name(), $psprintf("Flagged hcw_process_on(%0d) in mode(%s) !!!", hcw_process_on, hcw.name()), OVM_LOW)

             case(hcw)
               pf_hcw   : begin `ovm_do(pf_cfg_seq);    program_lsp_cqs(1); enq_start = 1; `ovm_do(pf_hcw_seq);    end
               sciov    : begin `ovm_do(sciov_cfg_seq); program_lsp_cqs(1); enq_start = 1; `ovm_do(sciov_hcw_seq); end
             endcase

             hcw_process_on = 0; 

             hcw_processing_done = 1; 

             `ovm_info(get_full_name(), $psprintf("Updated hcw_process_on(%0d) in mode(%s) !!!", hcw_process_on, hcw.name()), OVM_LOW)
             `ovm_info(get_full_name(), $psprintf("Flagged hcw_processing done(%0d) in mode(%s) !!!", hcw_processing_done, hcw.name()), OVM_LOW)

             wait(inject_rst == 1); 

         end
         begin

             if(hcw == no_hcw) begin wait_ns_clk(7000);  end
             else              begin wait(enq_start==1); wait_enq_count(cfg.num_enq); program_lsp_cqs(0); wait_sch_count(cfg.num_sch);   end

             `ovm_info(get_full_name(), $psprintf("Done waiting within mode(%s)!!! Good to trigger reset using inject_rst(%0d)!!!", hcw.name(), inject_rst), OVM_LOW)

             if(rst == no_rst) begin wait(hcw_processing_done==1); end 

             inject_rst=1;

             `ovm_info(get_full_name(), $psprintf("Triggered inject_rst(%0d) within mode(%s)!!!", inject_rst, hcw.name()), OVM_LOW)

         end
     join_any

     if(rst != no_rst) begin

        wait_rst_done();

        `ovm_info(get_full_name(), $sformatf("Resetting TB components for rst type (%s)", rst.name()), OVM_LOW)

        i_hqm_pp_cq_status.force_all_seq_stop();
        wait_ns_clk(50);
        i_hqm_pp_cq_status.clr_force_all_seq_stop();
        `ovm_do(rst_hqm_cfg);
        i_hcw_scoreboard.hcw_scoreboard_reset();

     end

     disable fork;

     `ovm_info(get_full_name(), $psprintf("Stopping send_hcw sequence with mode(%s) !!!", hcw.name()), OVM_LOW)

  endtask : send_hcw

  task wait_rst_done();

     `ovm_info(get_full_name(), $psprintf("wait_rst_done : -- Start"), OVM_LOW);

     wait(rst_done == 1);

     `ovm_info(get_full_name(), $psprintf("wait_rst_done : -- End  "), OVM_LOW);

  endtask : wait_rst_done

  task send_cfgwr_with_bus_num_change();

     while(change_bus_num) begin 

               bit [7:0] arb_bus_num = $urandom_range('h_0, 'h_ff); 

               send_tlp(get_tlp({arb_bus_num, 0,16'h_000c}, Iosf::CfgWr0), .skip_ur_chk(skip_checks)); 

               pf_cfg_regs.set_bdf(arb_bus_num,0,0);

               wait_ns_clk(5); 

               if(hcw_process_on && ~inject_rst) begin
                   int unsigned num_clks = $urandom_range(300,700);
                   `ovm_info(get_full_name(), $sformatf("send_cfgwr_with_bus_num_change: Delaying accesses by (%0d)ns during HCW processing/programming!!", num_clks), OVM_LOW);
                   wait_ns_clk(num_clks);
               end

          wait_ns_clk(500);

     end

     `ovm_info(get_full_name(), $psprintf("Stopping bus_num_change sequence !!!"), OVM_LOW)

  endtask : send_cfgwr_with_bus_num_change

  task inject_intermediate_rst();

     `ovm_info(get_full_name(), $sformatf("Entering Intermediate rst with txn(%s), change_bus_num(%0d), skip_checks(%0d), inject_rst(%0d), rst type(%s)", txn.name(), change_bus_num, skip_checks, inject_rst, rst.name()), OVM_LOW)

     wait(inject_rst == 1); 

     prev_txn = txn;

     `ovm_info(get_full_name(), $sformatf("Received inject_rst: Setting -> txn(%s), change_bus_num(%0d), skip_checks(%0d) as inject_rst(%0d) for rst type(%s)", txn.name(), change_bus_num, skip_checks, inject_rst, rst.name()), OVM_LOW)

     if(rst inside {cold, warm, flr}) hqm_env.hqm_agent_env_handle.i_hqm_iosf_prim_checker.set_bypass_cplid_check(1);

     fork
         begin
              if(cfg.scenario inside {cold_rst_with_flr, warm_rst_with_flr}) begin
                  send_tlp(get_tlp(ral.get_addr_val(primary_id,pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL), Iosf::CfgWr0, {'h_8000}), .skip_ur_chk(skip_checks));
              end  
              else  
              if(cfg.scenario inside {cold_rst_with_d3_trans, warm_rst_with_d3_trans}) begin 
                  send_tlp(get_tlp(ral.get_addr_val(primary_id,pf_cfg_regs.PM_CAP_CONTROL_STATUS), Iosf::CfgWr0, {'h_3}), .skip_ur_chk(skip_checks));
              end  
              else  
              if(cfg.scenario inside {cold_rst_in_d3, warm_rst_in_d3}) begin 
                 pf_cfg_regs.PM_CAP_CONTROL_STATUS.write(status,16'h_3,primary_id,this,.sai(legal_sai)); 
              end  
              else  
              if(cfg.scenario inside {cold_rst_in_d2, warm_rst_in_d2}) begin 
                 pf_cfg_regs.PM_CAP_CONTROL_STATUS.write(status,16'h_2,primary_id,this,.sai(legal_sai)); 
              end  
              else  
              if(cfg.scenario inside {cold_rst_in_d1, warm_rst_in_d1}) begin 
                 pf_cfg_regs.PM_CAP_CONTROL_STATUS.write(status,16'h_1,primary_id,this,.sai(legal_sai)); 
              end  
              else  
              if(cfg.scenario inside {cold_rst_in_d0, warm_rst_in_d0}) begin 
                 pf_cfg_regs.PM_CAP_CONTROL_STATUS.write(status,16'h_0,primary_id,this,.sai(legal_sai)); 
              end  
              else  
              if(cfg.scenario inside {pf_hcw_ur_txns_aer_msg}) begin 
                 send_tlp(get_tlp(ral.get_addr_val(primary_id,pf_cfg_regs.AER_CAP_CORR_ERR_MASK), Iosf::CfgWr0, {'h_0}), .skip_ur_chk(skip_checks));
                 send_tlp(get_tlp('h_0, Iosf::MWr32), .skip_ur_chk(skip_checks));
                 send_tlp(get_tlp(ral.get_addr_val(primary_id,pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL), Iosf::CfgWr0, {'h_8000}), .skip_ur_chk(skip_checks)); 
                 send_tlp(get_tlp('h_0, Iosf::MRd32), .ur(1), .skip_ur_chk(skip_checks));
              end  

              case(rst)
                cold : `ovm_do(cold_rst)
                warm : `ovm_do(warm_rst)
                flr  : begin 
                           if(cfg.scenario inside {pf_hcw_ur_txns_aer_msg, pf_hcw_ur_txns_msix_msi}) begin 
                             send_tlp(get_tlp(ral.get_addr_val(primary_id,pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL), Iosf::CfgWr0, {'h_8000}), .skip_ur_chk(skip_checks)); 
                             wait_ns_clk(2000); 
                           end else begin 
                             pf_cfg_regs.PCIE_CAP_DEVICE_CONTROL.write(status,16'h_8000,primary_id,this,.sai(legal_sai)); 
                           end  
                       end
              endcase

              rst_done = 1; 

         end
         begin

              int unsigned wait_clk_ticks = $urandom_range(500,7000);
           
              if(inject_rst && rst inside {warm, cold}) begin 
                  `ovm_info(get_full_name(), $psprintf("inject_intermediate_rst: Start --- waiting on hqm_ResetPrepAck as rst type is (%s)", rst.name()), OVM_LOW);
                  hqm_ResetPrepAck.wait_trigger();
                  `ovm_info(get_full_name(), $psprintf("inject_intermediate_rst: End   --- waiting on hqm_ResetPrepAck as rst type is (%s)", rst.name()), OVM_LOW);
              end else begin
                  wait_ns_clk(300); 
              end 

              if(cfg.extend_sb_txns_in_rst == 0) begin 
                issue_sb_txn = 0;
                `ovm_info(get_full_name(), $sformatf("Stopping send_sb_txns after 300 clk while in rst as cfg.extend_sb_txns_in_rst(%0d)", cfg.extend_sb_txns_in_rst), OVM_LOW)
              end

              if(cfg.extend_prim_txns_in_rst != 0) begin
                `ovm_info(get_full_name(), $sformatf("Start --- Elongating txns by (%0d)ns clk_ticks while in reset!!!", wait_clk_ticks), OVM_LOW)
                wait_ns_clk(wait_clk_ticks); 
                `ovm_info(get_full_name(), $sformatf("Done  --- Elongating txns by (%0d)ns clk_ticks while in reset!!!", wait_clk_ticks), OVM_LOW)
              end

              txn = no_txn; change_bus_num = 0; skip_checks = 1;

         end

     join


     `ovm_info(get_full_name(), $sformatf("Intermediate rst called with txn(%s), change_bus_num(%0d), skip_checks(%0d)", txn.name(), change_bus_num, skip_checks), OVM_LOW)

  endtask : inject_intermediate_rst

  task program_lsp_cqs(bit en = 0);
       
       `ovm_info(get_full_name(), $psprintf("Start -- program_lsp_cqs with val(%0d)", en), OVM_LOW)
        
       for(int i = 0; i<`HQM_NUM_LDB_CQ; i++) begin
            send_tlp(get_tlp(ral.get_addr_val(primary_id,list_sel_pipe_regs.CFG_CQ_LDB_DISABLE[i]), Iosf::MWr64, {en}), .skip_ur_chk(skip_checks));
            // -- list_sel_pipe_regs.CFG_CQ_LDB_DISABLE[i].write(status, en, primary_id, this, .sai(legal_sai));
       end
        
       for(int i = 0; i<`HQM_NUM_DIR_CQ; i++) begin
            send_tlp(get_tlp(ral.get_addr_val(primary_id,list_sel_pipe_regs.CFG_CQ_DIR_DISABLE[i]), Iosf::MWr64, {en}), .skip_ur_chk(skip_checks));
            // -- list_sel_pipe_regs.CFG_CQ_DIR_DISABLE[i].write(status, en, primary_id, this, .sai(legal_sai));
       end
       
       `ovm_info(get_full_name(), $psprintf("Done -- program_lsp_cqs with val(%0d)", en), OVM_LOW)


  endtask : program_lsp_cqs

  task wait_enq_count(int num); 
       `ovm_info(get_full_name(), $sformatf("Start: wait_enq_count -> (%0d)", num), OVM_LOW) 
       wait(i_hcw_scoreboard.hcw_enq_q.size()>num); 
       `ovm_info(get_full_name(), $sformatf("Done: wait_enq_count:-> (%0d)", num), OVM_LOW) 
  endtask : wait_enq_count

  task wait_sch_count(int num); 

       int obs_sch_count = 0; 

       `ovm_info(get_full_name(), $sformatf("Start: wait_sch_count -> (%0d)", num), OVM_LOW) 

       while(obs_sch_count<num) begin
            obs_sch_count = 0; 
            foreach(i_hqm_pp_cq_status.ldb_pp_cq_status[idx]) obs_sch_count += i_hqm_pp_cq_status.ldb_pp_cq_status[idx].mon_sch_cnt;
            foreach(i_hqm_pp_cq_status.dir_pp_cq_status[idx]) obs_sch_count += i_hqm_pp_cq_status.dir_pp_cq_status[idx].mon_sch_cnt;
            wait_ns_clk(10);
            `ovm_info(get_full_name(), $psprintf("Observed schedule count (%0d) waiting for (%0d)", obs_sch_count, num), OVM_LOW);
       end

       `ovm_info(get_full_name(), $sformatf("Done: wait_sch_count -> (%0d)", num), OVM_LOW) 
       
  endtask : wait_sch_count

endclass : hqm_reset_cycle_sequence

