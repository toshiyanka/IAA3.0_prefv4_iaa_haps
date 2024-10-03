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
//  Desc    : Config Descriptor for HIP PG Agent
//------------------------------------------------------------------------------

`ifndef HIP_PG_CONFIG__SV
`define HIP_PG_CONFIG__SV

//------------------------------------------------------------------------------
// class: hip_pg_config
//
// This class provides all necessary variables required for configuring the HIP PG agent.
//------------------------------------------------------------------------------
class hip_pg_config extends ovm_object;

  //----------------------------------------------------------------------------
  // Variable: name
  //
  // Name of this power domain
  //----------------------------------------------------------------------------
  string name;

  //----------------------------------------------------------------------------
  // Variable: domain_status
  //
  // Indicates current status of power domain
  //
  //----------------------------------------------------------------------------
  hip_pg::hip_pg_domain_status_t domain_status;

  //----------------------------------------------------------------------------
  // Variable: domain_controlled_by_pmc
  //
  // Indicates whether or not this domain can be controlled by the PMC.
  //
  // See Also:
  //   <cfg_update_mode_c>
  //----------------------------------------------------------------------------
  rand bit domain_controlled_by_pmc;

  //----------------------------------------------------------------------------
  // Variable: domain_controlled_by_pg
  //
  // Indicates whether or not this domain can be controlled by dynamic PG.
  //
  // See Also:
  //   <cfg_update_mode_c>
  //----------------------------------------------------------------------------
  rand bit domain_controlled_by_pg;

  //----------------------------------------------------------------------------
  // Variable: t_T0_ps
  //
  // Time parameter T0 from spec, expressed in ps.  Used by sequencer for
  // delay from phy_pmc_pwr_stable to pmc_phy_fw_en_b in cold boot sequence
  //----------------------------------------------------------------------------
  rand int t_T0_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T1_ps
  //
  // Time parameter T1 from spec, expressed in ps.  Used by sequencer for
  // delay from pmc_phy_fw_en_b to pmc_phy_reset_b in cold boot sequence
  //----------------------------------------------------------------------------
  rand int t_T1_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T2_ps
  //
  // Time parameter T2 from spec, expressed in ps.  Used by sequencer for
  // delay from pmc_phy_reset_b to pmc_phy_sbwake in cold boot sequence
  //----------------------------------------------------------------------------
  rand int t_T2_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T3_ps
  //
  // Time parameter T3 from spec, expressed in ps.  Used by sequencer for
  // delay from phy_pmc_sbpwr_stable to iosf_side_rst_l in cold boot sequence
  //----------------------------------------------------------------------------
  rand int t_T3_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T10_ps
  //
  // Time parameter T10 from spec, expressed in ps.  Used by sequencer for
  // delay from phy_pmc_sbpwr_stable to iosf_side_rst_l in shutdown sequence
  //----------------------------------------------------------------------------
  rand int t_T10_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T11_ps
  //
  // Time parameter T11 from spec, expressed in ps.  Used by sequencer for
  // delay from iosf_side_rst_l to pmc_phy_reset_b in shutdown sequence
  //----------------------------------------------------------------------------
  rand int t_T11_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T12_ps
  //
  // Time parameter T12 from spec, expressed in ps.  Used by sequencer for
  // delay from pmc_phy_reset_b to pmc_phy_fw_en_b in shutdown sequence
  //----------------------------------------------------------------------------
  rand int t_T12_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T13_ps
  //
  // Time parameter T13 from spec, expressed in ps.  Used by sequencer for
  // delay from pmc_phy_fw_en_b to pmc_phy_pwr_en in shutdown sequence
  //----------------------------------------------------------------------------
  rand int t_T13_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T14_ps
  //
  // Time parameter T14 from spec, expressed in ps.  Used by sequencer for
  // delay from pmc_phy_pwr_en to HIP power rail in shutdown sequence (?)
  //----------------------------------------------------------------------------
  rand int t_T14_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T_poweron_ps
  //
  // Time parameter T_poweron from spec, expressed in ps.  Used by checker for
  // delay from pmc_phy_pwr_en to phy_pmc_pwr_stable in cold boot flow
  //----------------------------------------------------------------------------
  rand int t_T_poweron_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T_ip_prep_reset_exit_ps
  //
  // Time parameter T_ip_prep_reset_exit from spec, expressed in ps.  Used by checker for
  // delay from pmc_phy_sbwake to phy_pmc_sbpwr_stable in cold boot flow
  //----------------------------------------------------------------------------
  rand int t_T_ip_prep_reset_exit_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T_sbwake_clkreq_p_ps
  //
  // Time parameter T_sbwake_clkreq_p from spec, expressed in ps.  Used by checker for
  // delay from pmc_phy_sbwake to iosf_sideclk_req_h in cold boot flow (?)
  //----------------------------------------------------------------------------
  rand int t_T_sbwake_clkreq_p_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T_pok_assert_ps
  //
  // Time parameter T_pok_assert from spec, expressed in ps.  Used by checker for
  // delay from iosf_side_rst_l to iosf_side_pok_h in cold boot flow
  //----------------------------------------------------------------------------
  rand int t_T_pok_assert_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T_pok_deassert_ps
  //
  // Time parameter T_pok_deassert from spec, expressed in ps.  Used by checker for
  // delay from forcePwrGatePOK to iosf_side_pok_h in shutdown sequence
  //----------------------------------------------------------------------------
  rand int t_T_pok_deassert_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T_pok_clkreq_n_ps
  //
  // Time parameter T_pok_clkreq_n from spec, expressed in ps.  Used by checker for
  // delay from iosf_side_pok_h to iosf_sideclk_req_h in shutdown sequence
  //----------------------------------------------------------------------------
  rand int t_T_pok_clkreq_n_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T_ip_prep_reset_entry_ps
  //
  // Time parameter T_ip_prep_reset_entry from spec, expressed in ps.  Used by checker for
  // delay from iosf_side_pok_h to phy_pmc_sbpwr_stable in shutdown sequence
  //----------------------------------------------------------------------------
  rand int t_T_ip_prep_reset_entry_ps;

  //----------------------------------------------------------------------------
  // Variable: t_T_powerdown_ps
  //
  // Time parameter T_powerdown from spec, expressed in ps.  Used by checker for
  // delay from pmc_phy_pwr_en to phy_pmc_pwr_stable in shutdown sequence
  //----------------------------------------------------------------------------
  rand int t_T_powerdown_ps;


  `ovm_object_utils_begin(hip_pg_config)
    `ovm_field_string(name,                       OVM_PRINT)
    `ovm_field_int   (domain_controlled_by_pmc,   OVM_PRINT)
    `ovm_field_int   (domain_controlled_by_pg,    OVM_PRINT)
    `ovm_field_int   (t_T0_ps,                    OVM_PRINT)
    `ovm_field_int   (t_T1_ps,                    OVM_PRINT)
    `ovm_field_int   (t_T2_ps,                    OVM_PRINT)
    `ovm_field_int   (t_T3_ps,                    OVM_PRINT)
    `ovm_field_int   (t_T10_ps,                   OVM_PRINT)
    `ovm_field_int   (t_T11_ps,                   OVM_PRINT)
    `ovm_field_int   (t_T12_ps,                   OVM_PRINT)
    `ovm_field_int   (t_T13_ps,                   OVM_PRINT)
    `ovm_field_int   (t_T14_ps,                   OVM_PRINT)
    `ovm_field_int   (t_T_poweron_ps,             OVM_PRINT)
    `ovm_field_int   (t_T_ip_prep_reset_exit_ps,  OVM_PRINT)
    `ovm_field_int   (t_T_sbwake_clkreq_p_ps,     OVM_PRINT)
    `ovm_field_int   (t_T_pok_assert_ps,          OVM_PRINT)
    `ovm_field_int   (t_T_pok_deassert_ps,        OVM_PRINT)
    `ovm_field_int   (t_T_pok_clkreq_n_ps,        OVM_PRINT)
    `ovm_field_int   (t_T_ip_prep_reset_entry_ps, OVM_PRINT)
    `ovm_field_int   (t_T_powerdown_ps,           OVM_PRINT)
  `ovm_object_utils_end


  //----------------------------------------------------------------------------
  // Function: new
  //
  // Description:
  //   Creates a new instance of this type giving it the optional ~name~.
  //
  // Inputs:
  //   name_in - Instance name for this class
  //
  // Returns:
  //   void
  //----------------------------------------------------------------------------
  function new(string name_in = "hip_pg_config");
    super.new(name_in);
    name = name_in;
    // all domains are off at start of simulation
    domain_status = hip_pg::HIP_PG_DOMAIN_OFF;
  endfunction : new

  //----------------------------------------------------------------------------
  // Constraint: pwrgating_mode_c
  //
  // Description:
  // All power domains need to be controlled by either PMC or PG
  //
  // Inputs:
  //  none
  //
  // Modifies:
  //  <domain_controlled_by_pmc,domain_controlled_by_pg>
  //----------------------------------------------------------------------------
  constraint pwrgating_mode_c {
    (domain_controlled_by_pmc || domain_controlled_by_pg) == 1'b1;
  }

endclass : hip_pg_config

`endif //  `ifndef HIP_PG_CONFIG__SV
