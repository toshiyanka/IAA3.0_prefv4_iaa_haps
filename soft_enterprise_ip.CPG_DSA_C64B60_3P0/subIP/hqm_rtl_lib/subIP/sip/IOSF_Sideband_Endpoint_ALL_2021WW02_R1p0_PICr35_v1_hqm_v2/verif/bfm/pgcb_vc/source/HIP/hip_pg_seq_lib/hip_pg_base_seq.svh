//////////////////////////////////////////////////////////////////////////////
//  Copyright (c)
//  2010 Intel Corporation, all rights reserved.
//
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY
//  PROTECTED BY COPYRIGHT LAWS AND IS CONSIDERED A
//  TRADE SECRET BELONGING TO THE INTEL CORPORATION.
///////////////////////////////////////////////////////////////////////////////
//
//  Author  : Bill Bradley
//  Email   : william.l.bradley@intel.com
//  Date    : November 5, 2013
//  Desc    : Base sequence for HIP PG sequence library
///////////////////////////////////////////////////////////////////////////////

`ifndef HIP_PG_BASE_SEQ__SVH
`define HIP_PG_BASE_SEQ__SVH

//------------------------------------------------------------------------------
// class: hip_pg_base_seq
// Base sequence from which all sequences inherit.
//------------------------------------------------------------------------------
class hip_pg_base_seq extends ovm_sequence;

  `ovm_sequence_utils(hip_pg_base_seq, hip_pg_sequencer)

  //----------------------------------------------------------------------------
  // variables
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // variable: domain_num
  // Domain number, used in sequence for reporting
  //----------------------------------------------------------------------------
  rand int unsigned domain_num;

  //----------------------------------------------------------------------------
  // variable: driver_response
  // Driver response item
  //----------------------------------------------------------------------------
  hip_pg_xaction driver_response;
  

  //----------------------------------------------------------------------------
  // Function: trigger_event
  //----------------------------------------------------------------------------
  protected virtual task automatic trigger_event(input string        ev_name,
                                                 input ovm_verbosity verb = OVM_LOW,
                                                 input ovm_object    data = null);
    ovm_event_pool pool;
    ovm_event      ev;

    `ovm_info(get_type_name(), $psprintf("Triggering Event = %s", ev_name), verb)
    pool = ovm_event_pool::get_global_pool();
    ev   = pool.get(ev_name);
    ev.trigger(data);
  endtask : trigger_event

  //----------------------------------------------------------------------------
  // Function: wait_for_event
  //----------------------------------------------------------------------------
  protected virtual task automatic wait_for_event(input string        ev_name,
                                                  input ovm_verbosity verb = OVM_LOW);
    ovm_event_pool pool;
    ovm_event      ev;

    `ovm_info(get_type_name(), $psprintf("Start waiting for Event = %s", ev_name), verb)
    pool = ovm_event_pool::get_global_pool();
    ev   = pool.get(ev_name);
    ev.wait_trigger();
    `ovm_info(get_type_name(), $psprintf("Detected Event Trigger = %s", ev_name), verb)
  endtask : wait_for_event


  //----------------------------------------------------------------------------
  // Function: new
  //
  // Objections are raised and dropped in the base sequence.
  //----------------------------------------------------------------------------
  function new(string name="hip_pg_base_seq");
    super.new(name);
  endfunction


  //----------------------------------------------------------------------------
  // task: wait_for_phy_pmc_pwr_stable
  //
  // Description:
  //   Issues a query request to the HIP PG Monitor that blocks until phy_pmc_pwr_stable changes.
  //  
  // Inputs:
  //   value            - value to wait for on phy_pmc_pwr_stable
  //   timeout_value_ps - time to wait before throwing error (we actually wait 10ns extra)
  //
  // Outputs:
  //   mon_rsp          - <hip_pg_mon> object with result of query operation
  //----------------------------------------------------------------------------
  virtual task automatic wait_for_phy_pmc_pwr_stable(logic value = 1'bX, int timeout_value_ps = 0);
    hip_pg_pkg::hip_pg_xaction_mon mon_req;
    hip_pg_pkg::hip_pg_xaction_mon mon_rsp;

    mon_req       = hip_pg_pkg::hip_pg_xaction_mon::type_id::create("mon_req");
    mon_req.op    = hip_pg::HIP_PG_MON_WAIT_FOR_PHY_PMC_PWR_STABLE;
    mon_req.value = value;
    if (timeout_value_ps != 0) mon_req.timeout_value_ps = timeout_value_ps + 10000;
    p_sequencer.query_mon_port.transport(mon_req, mon_rsp);
    
    // note any errors
    if (mon_rsp.op != hip_pg::HIP_PG_MON_OP_COMPLETE)
      `ovm_error(get_type_name(), "Did not observe a transition on pmy_pmc_pwr_stable")
  endtask : wait_for_phy_pmc_pwr_stable

  //----------------------------------------------------------------------------
  // task: wait_for_phy_pmc_sbpwr_stable
  //
  // Description:
  //   Issues a query request to the HIP PG Monitor that blocks until phy_pmc_sbpwr_stable changes.
  //  
  // Inputs:
  //   value            - value to wait for on phy_pmc_sbpwr_stable
  //   timeout_value_ps - time to wait before throwing error (we actually wait 10ns extra)
  //
  // Outputs:
  //   mon_rsp          - <hip_pg_mon> object with result of query operation
  //----------------------------------------------------------------------------
  virtual task automatic wait_for_phy_pmc_sbpwr_stable(logic value = 1'bX, int timeout_value_ps = 0);
    hip_pg_pkg::hip_pg_xaction_mon mon_req;
    hip_pg_pkg::hip_pg_xaction_mon mon_rsp;

    mon_req       = hip_pg_pkg::hip_pg_xaction_mon::type_id::create("mon_req");
    mon_req.op    = hip_pg::HIP_PG_MON_WAIT_FOR_PHY_PMC_SBPWR_STABLE;
    mon_req.value = value;
    if (timeout_value_ps != 0) mon_req.timeout_value_ps = timeout_value_ps + 10000;
    p_sequencer.query_mon_port.transport(mon_req, mon_rsp);
    
    // note any errors
    if (mon_rsp.op != hip_pg::HIP_PG_MON_OP_COMPLETE)
      `ovm_error(get_type_name(), "Did not observe a transition on pmy_pmc_sbpwr_stable")
  endtask : wait_for_phy_pmc_sbpwr_stable

  //----------------------------------------------------------------------------
  // task: wait_for_iosf_side_pok_h
  //
  // Description:
  //   Issues a query request to the HIP PG Monitor that blocks until iosf_side_pok_h changes.
  //  
  // Inputs:
  //   value            - value to wait for on iosf_side_pok_h
  //   timeout_value_ps - time to wait before throwing error (we actually wait 10ns extra)
  //
  // Outputs:
  //   mon_rsp          - <hip_pg_mon> object with result of query operation
  //----------------------------------------------------------------------------
  virtual task automatic wait_for_iosf_side_pok_h(logic value = 1'bX, int timeout_value_ps = 0);
    hip_pg_pkg::hip_pg_xaction_mon mon_req;
    hip_pg_pkg::hip_pg_xaction_mon mon_rsp;

    mon_req       = hip_pg_pkg::hip_pg_xaction_mon::type_id::create("mon_req");
    mon_req.op    = hip_pg::HIP_PG_MON_WAIT_FOR_IOSF_SIDE_POK_H;
    mon_req.value = value;
    if (timeout_value_ps != 0) mon_req.timeout_value_ps = timeout_value_ps + 10000;
    p_sequencer.query_mon_port.transport(mon_req, mon_rsp);
    
    // note any errors
    if (mon_rsp.op != hip_pg::HIP_PG_MON_OP_COMPLETE)
      `ovm_error(get_type_name(), "Did not observe a transition on iosf_side_pok_h")
  endtask : wait_for_iosf_side_pok_h

  //----------------------------------------------------------------------------
  // task: wait_for_phy_soc_pwr_ack
  //
  // Description:
  //   Issues a query request to the HIP PG Monitor that blocks until phy_soc_pwr_ack changes.
  //  
  // Inputs:
  //   value            - value to wait for on phy_soc_pwr_ack
  //   timeout_value_ps - time to wait before throwing error (we actually wait 10ns extra)
  //
  // Outputs:
  //   mon_rsp          - <hip_pg_mon> object with result of query operation
  //----------------------------------------------------------------------------
  virtual task automatic wait_for_phy_soc_pwr_ack(logic value = 1'bX, int timeout_value_ps = 0);
    hip_pg_pkg::hip_pg_xaction_mon mon_req;
    hip_pg_pkg::hip_pg_xaction_mon mon_rsp;

    mon_req       = hip_pg_pkg::hip_pg_xaction_mon::type_id::create("mon_req");
    mon_req.op    = hip_pg::HIP_PG_MON_WAIT_FOR_PHY_SOC_PWR_ACK;
    mon_req.value = value;
    if (timeout_value_ps != 0) mon_req.timeout_value_ps = timeout_value_ps + 10000;
    p_sequencer.query_mon_port.transport(mon_req, mon_rsp);
    
    // note any errors
    if (mon_rsp.op != hip_pg::HIP_PG_MON_OP_COMPLETE)
      `ovm_error(get_type_name(), "Did not observe a transition on phy_soc_pwr_ack")
  endtask : wait_for_phy_soc_pwr_ack

  //----------------------------------------------------------------------------
  // task: wait_for_phy_pmc_pmctrl_pwr_stable
  //
  // Description:
  //   Issues a query request to the HIP PG Monitor that blocks until phy_pmc_pmctrl_pwr_stable changes.
  //  
  // Inputs:
  //   value            - value to wait for on phy_pmc_pmctrl_pwr_stable
  //   timeout_value_ps - time to wait before throwing error (we actually wait 10ns extra)
  //   None
  //
  // Outputs:
  //   mon_rsp          - <hip_pg_mon> object with result of query operation
  //----------------------------------------------------------------------------
  virtual task automatic wait_for_phy_pmc_pmctrl_pwr_stable(logic value = 1'bX, int timeout_value_ps = 0);
    hip_pg_pkg::hip_pg_xaction_mon mon_req;
    hip_pg_pkg::hip_pg_xaction_mon mon_rsp;

    mon_req       = hip_pg_pkg::hip_pg_xaction_mon::type_id::create("mon_req");
    mon_req.op    = hip_pg::HIP_PG_MON_WAIT_FOR_PHY_PMC_PMCTRL_PWR_STABLE;
    mon_req.value = value;
    if (timeout_value_ps != 0) mon_req.timeout_value_ps = timeout_value_ps + 10000;
    p_sequencer.query_mon_port.transport(mon_req, mon_rsp);
    
    // note any errors
    if (mon_rsp.op != hip_pg::HIP_PG_MON_OP_COMPLETE)
      `ovm_error(get_type_name(), "Did not observe a transition on phy_pmc_pmctrl_pwr_stable")
  endtask : wait_for_phy_pmc_pmctrl_pwr_stable


  //----------------------------------------------------------------------------
  // Task: pre_body
  // Steps performed during pre_body phase.
  //----------------------------------------------------------------------------
  task pre_body();
    super.pre_body();
    ovm_test_done.raise_objection(this);
  endtask : pre_body

  //----------------------------------------------------------------------------
  // Task: body
  // Body phase, empty in the base sequence.
  //----------------------------------------------------------------------------
  task body();
    super.body();
  endtask : body

  //----------------------------------------------------------------------------
  // Task: post_body
  // Steps performed during post_body phase.
  //----------------------------------------------------------------------------
  task post_body();
    super.post_body();
    ovm_test_done.drop_objection(this);
  endtask : post_body

endclass : hip_pg_base_seq

`endif //  `ifndef HIP_PG_BASE_SEQ__SVH
