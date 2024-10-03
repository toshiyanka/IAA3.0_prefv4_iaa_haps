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

`ifndef HIP_PG_COLDBOOT_SEQ__SVH
`define HIP_PG_COLDBOOT_SEQ__SVH

//--------------------------------------------------------------------------------
// class: hip_pg_coldboot_seq
//
// HIP PG cold boot sequence
//--------------------------------------------------------------------------------
class hip_pg_coldboot_seq extends hip_pg_base_seq;

  `ovm_sequence_utils(hip_pg_coldboot_seq, hip_pg_sequencer)

  //------------------------------------------------------------------------------
  // function: new
  //------------------------------------------------------------------------------
  function new(string name="hip_pg_coldboot_seq");
    super.new(name);
  endfunction : new

  //------------------------------------------------------------------------------
  // task: body
  //
  // Purpose:
  //   Step interface through HIP PG cold boot flow
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
    hip_pg_drive_pmc_phy_pwr_en_seq          pmc_phy_pwr_en_seq;
    hip_pg_wait_for_phy_pmc_pwr_stable_seq   phy_pmc_pwr_stable_seq;
    hip_pg_drive_pmc_phy_fw_en_b_seq         pmc_phy_fw_en_b_seq;
    hip_pg_drive_pmc_phy_reset_b_seq         pmc_phy_reset_b_seq;
    hip_pg_drive_pmc_phy_sbwake_seq          pmc_phy_sbwake_seq;
    hip_pg_wait_for_phy_pmc_sbpwr_stable_seq phy_pmc_sbpwr_stable_seq;
    hip_pg_drive_iosf_side_rst_b_seq         iosf_side_rst_b_seq;
    hip_pg_wait_for_iosf_side_pok_h_seq	     iosf_side_pok_h_seq;

    super.body();

    // only perform this sequence if power domain is controlled by PMC and power domain is OFF 

    if ((p_sequencer.config.domain_controlled_by_pmc == 1'b1) &&
        (p_sequencer.config.domain_status == hip_pg::HIP_PG_DOMAIN_OFF)) begin
      p_sequencer.config.domain_status = hip_pg::HIP_PG_DOMAIN_COLDBOOT;

      `ovm_do_with(pmc_phy_pwr_en_seq,{value == 1'b1;})

      // wait for response from HIP
      `ovm_do_with(phy_pmc_pwr_stable_seq,{value == 1'b1; timeout_value_ps == p_sequencer.config.t_T_poweron_ps;})

      #(p_sequencer.config.t_T0_ps*1ps);
      `ovm_do_with(pmc_phy_fw_en_b_seq,{value == 1'b1;})
      #(p_sequencer.config.t_T1_ps*1ps);
      `ovm_do_with(pmc_phy_reset_b_seq,{value == 1'b1;})
      #(p_sequencer.config.t_T2_ps*1ps);
      `ovm_do_with(pmc_phy_sbwake_seq,{value == 1'b1;})

      // wait for response from HIP
      `ovm_do_with(phy_pmc_sbpwr_stable_seq,{value == 1'b1; timeout_value_ps == p_sequencer.config.t_T_ip_prep_reset_exit_ps;})

      #(p_sequencer.config.t_T3_ps*1ps);
      fork
        begin
//	  FIXME: #(some small random amount of time)	
          `ovm_do_with(iosf_side_rst_b_seq,{value == 1'b1;})
	end
	begin
//	  FIXME: #(some small random amount of time)
	  `ovm_do_with(pmc_phy_sbwake_seq, {value == 1'b0;})
	end
      join

      // wait for response from HIP
      `ovm_do_with(iosf_side_pok_h_seq,{value == 1'b1; timeout_value_ps == p_sequencer.config.t_T_pok_assert_ps;})

      // FIXME: what if iosf_side_pok_h goes high early?

      // ...and we're done!

      p_sequencer.config.domain_status = hip_pg::HIP_PG_DOMAIN_ON;
    end

    else begin
      if (p_sequencer.config.domain_controlled_by_pmc != 1'b1)
        `ovm_error(get_type_name(),
                   $psprintf("HIP PG coldboot sequence called on domain not under PMC control"))
      else if (p_sequencer.config.domain_status != hip_pg::HIP_PG_DOMAIN_OFF)
        `ovm_error(get_type_name(),
                   $psprintf("HIP PG coldboot sequence called on domain not in HIP_PG_DOMAIN_OFF state"))
    end
  endtask : body

endclass : hip_pg_coldboot_seq

`endif // `ifndef HIP_PG_COLDBOOT_SEQ__SVH

