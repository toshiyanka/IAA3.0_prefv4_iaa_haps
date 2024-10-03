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
//  Desc    : HIP PG sequence for cold boot flow
///////////////////////////////////////////////////////////////////////////////

`ifndef HIP_PG_SHUTDOWN_SEQ__SVH
`define HIP_PG_SHUTDOWN_SEQ__SVH

//--------------------------------------------------------------------------------
// class: hip_pg_shutdown_seq
//
// HIP PG cold boot sequence
//--------------------------------------------------------------------------------
class hip_pg_shutdown_seq extends hip_pg_base_seq;

  `ovm_sequence_utils(hip_pg_shutdown_seq, hip_pg_sequencer)

  //------------------------------------------------------------------------------
  // function: new
  //------------------------------------------------------------------------------
  function new(string name="hip_pg_shutdown_seq");
    super.new(name);
  endfunction : new

  //------------------------------------------------------------------------------
  // task: body
  //
  // Purpose:
  //   Step interface through HIP PG shutdown flow
  //
  // Inputs:
  //   None
  //
  // Outputs:
  //   None
  //
  // Operation:
  //   
  //------------------------------------------------------------------------------
  task body();
    hip_pg_wait_for_iosf_side_pok_h_seq	     iosf_side_pok_h_seq;
    hip_pg_wait_for_phy_pmc_sbpwr_stable_seq phy_pmc_sbpwr_stable_seq;
    hip_pg_drive_iosf_side_rst_b_seq         iosf_side_rst_b_seq;
    hip_pg_drive_pmc_phy_reset_b_seq         pmc_phy_reset_b_seq;
    hip_pg_drive_pmc_phy_fw_en_b_seq         pmc_phy_fw_en_b_seq;
    hip_pg_drive_pmc_phy_pwr_en_seq          pmc_phy_pwr_en_seq;
    hip_pg_wait_for_phy_pmc_pwr_stable_seq   phy_pmc_pwr_stable_seq;

    super.body();

    // only perform this sequence if power domain is controlled by PMC and power domain is ON 

    if ((p_sequencer.config.domain_controlled_by_pmc == 1'b1) &&
        (p_sequencer.config.domain_status == hip_pg::HIP_PG_DOMAIN_ON)) begin
      p_sequencer.config.domain_status = hip_pg::HIP_PG_DOMAIN_SHUTDOWN;

      // wait for iosf_side_pok_h deassertion, then phy_pmc_sbpwr_stable deassertion
      `ovm_do_with(iosf_side_pok_h_seq,     {value == 1'b0; timeout_value_ps == p_sequencer.config.t_T_pok_deassert_ps;})
      `ovm_do_with(phy_pmc_sbpwr_stable_seq,{value == 1'b0; timeout_value_ps == p_sequencer.config.t_T_ip_prep_reset_entry_ps;})

      #(p_sequencer.config.t_T10_ps*1ps);
      `ovm_do_with(iosf_side_rst_b_seq,{value == 1'b0;})
      #(p_sequencer.config.t_T11_ps*1ps);
      `ovm_do_with(pmc_phy_reset_b_seq,{value == 1'b0;})
      #(p_sequencer.config.t_T12_ps*1ps);
      `ovm_do_with(pmc_phy_fw_en_b_seq,{value == 1'b0;})
      #(p_sequencer.config.t_T13_ps*1ps);
      `ovm_do_with(pmc_phy_pwr_en_seq, {value == 1'b0;})

      // wait for response from HIP
      `ovm_do_with(phy_pmc_pwr_stable_seq,{value == 1'b0; timeout_value_ps == p_sequencer.config.t_T_powerdown_ps;})

      // ...and we're done!

      p_sequencer.config.domain_status = hip_pg::HIP_PG_DOMAIN_OFF;

      // In reality, we could (should?) wait T14 then look for deassertion of vcc,
      // but that's outside the scope of this VC
    end

    else begin
      if (p_sequencer.config.domain_controlled_by_pmc != 1'b1)
        `ovm_error(get_type_name(),
                   $psprintf("HIP PG shutdown sequence called on domain not under PMC control"))
      else if (p_sequencer.config.domain_status != hip_pg::HIP_PG_DOMAIN_ON)
        `ovm_error(get_type_name(),
                   $psprintf("HIP PG shutdown sequence called on domain not in HIP_PG_DOMAIN_ON state"))
    end
  endtask : body

endclass : hip_pg_shutdown_seq

`endif // `ifndef HIP_PG_SHUTDOWN_SEQ__SVH

