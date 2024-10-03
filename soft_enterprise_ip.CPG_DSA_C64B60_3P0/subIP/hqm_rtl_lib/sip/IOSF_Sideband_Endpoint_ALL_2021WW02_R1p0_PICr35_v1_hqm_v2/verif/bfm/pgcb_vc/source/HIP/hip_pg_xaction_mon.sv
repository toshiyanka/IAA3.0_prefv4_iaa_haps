//------------------------------------------------------------------------------
//  Copyright (c)
//  2010 Intel Corporation, all rights reserved.
//
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY
//  PROTECTED BY COPYRIGHT LAWS AND IS CONSIDERED A
//  TRADE SECRET BELONGING TO THE INTEL CORPORATION.
//------------------------------------------------------------------------------
//
//  Author  : Bill Bradley
//  Email   : william.l.bradley@intel.com
//  Date    : November 4, 2013
//  Desc    : HIP PG Monitor Transaction
//
//------------------------------------------------------------------------------

`ifndef HIP_PG_XACTION_MON__SV
`define HIP_PG_XACTION_MON__SV

//------------------------------------------------------------------------------
// class: mphy_pcs_xaction_mon
// HIP PG Monitor Transaction
//------------------------------------------------------------------------------
class hip_pg_xaction_mon extends ovm_sequence_item;

  // variable: op
  // Operation being tracked
  hip_pg::hip_pg_mon_op_t op;

  // variable: value
  // Value related to the operation
  logic value;
  
  // variable: timestamp
  // Time stamp that this operation occured
  realtime timestamp;
  
  // variable: timeout_value_ps
  // Timeout value for ops
  int unsigned timeout_value_ps = 10000000;

  // Interface signals
  logic pmc_phy_pwr_en;
  logic phy_pmc_pwr_stable;
  logic pmc_phy_reset_b;
  logic pmc_phy_fw_en_b;
  logic pmc_phy_sbwake;
  logic phy_pmc_sbpwr_stable;
  logic iosf_side_pok_h;
  logic iosf_side_rst_b;
  logic soc_phy_pwr_req;
  logic phy_soc_pwr_ack;
  logic pmc_phy_pmctrl_en;
  logic pmc_phy_pmctrl_pwr_en;
  logic phy_pmc_pmctrl_pwr_stable;
  logic forcePwrGatePOK;

  `ovm_object_utils_begin(hip_pg_xaction_mon)
    `ovm_field_enum (hip_pg::hip_pg_mon_op_t, op,                        OVM_DEFAULT)
    `ovm_field_int  (                         value,                     OVM_DEFAULT)
    `ovm_field_real (                         timestamp,                 OVM_DEFAULT)
    `ovm_field_int  (                         timeout_value_ps,          OVM_DEFAULT)
    `ovm_field_int  (                         pmc_phy_pwr_en,            OVM_DEFAULT)
    `ovm_field_int  (                         phy_pmc_pwr_stable,        OVM_DEFAULT)
    `ovm_field_int  (                         pmc_phy_reset_b,           OVM_DEFAULT)
    `ovm_field_int  (                         pmc_phy_fw_en_b,           OVM_DEFAULT)
    `ovm_field_int  (                         pmc_phy_sbwake,            OVM_DEFAULT)
    `ovm_field_int  (                         phy_pmc_sbpwr_stable,      OVM_DEFAULT)
    `ovm_field_int  (                         iosf_side_pok_h,           OVM_DEFAULT)
    `ovm_field_int  (                         iosf_side_rst_b,           OVM_DEFAULT)
    `ovm_field_int  (                         soc_phy_pwr_req,           OVM_DEFAULT)
    `ovm_field_int  (                         phy_soc_pwr_ack,           OVM_DEFAULT)
    `ovm_field_int  (                         pmc_phy_pmctrl_en,         OVM_DEFAULT)
    `ovm_field_int  (                         pmc_phy_pmctrl_pwr_en,     OVM_DEFAULT)
    `ovm_field_int  (                         phy_pmc_pmctrl_pwr_stable, OVM_DEFAULT)
    `ovm_field_int  (                         forcePwrGatePOK,           OVM_DEFAULT)
  `ovm_object_utils_end

  //----------------------------------------------------------------------------
  // Function: new
  //
  // Description:
  //   Creates a new instance of this type giving it an optional name and op
  //
  // Inputs:
  //   req_op  - Of type <hip_pg::hip_pg_mon_op_t> sets an initial value for
  //             op upon creation of this class
  // 
  //   name    - Instance name
  //
  // Outputs:
  //   void
  //----------------------------------------------------------------------------
  function new(hip_pg::hip_pg_mon_op_t req_op = hip_pg::HIP_PG_MON_OP_UNKNOWN,
  	       logic req_value = 1'bX,
               string name="hip_pg_xaction_mon");
    super.new(name);
    
    op = req_op;
    value = req_value;
  endfunction : new
  
endclass : hip_pg_xaction_mon

`endif //  `ifndef HIP_PG_XACTION_MON__SV
