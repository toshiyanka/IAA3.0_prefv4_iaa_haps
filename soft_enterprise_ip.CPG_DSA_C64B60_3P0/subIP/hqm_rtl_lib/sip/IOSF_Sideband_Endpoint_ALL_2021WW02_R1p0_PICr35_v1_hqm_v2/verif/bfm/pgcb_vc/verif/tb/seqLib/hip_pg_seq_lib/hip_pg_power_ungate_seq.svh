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

`ifndef HIP_PG_POWER_UNGATE_SEQ__SVH
`define HIP_PG_POWER_UNGATE_SEQ__SVH

//--------------------------------------------------------------------------------
// class: hip_pg_power_ungate_seq
//
// HIP PG cold boot sequence
//--------------------------------------------------------------------------------
class hip_pg_power_ungate_seq extends hip_pg_base_seq;

  `ovm_sequence_utils(hip_pg_power_ungate_seq, hip_pg_sequencer)

  //------------------------------------------------------------------------------
  // function: new
  //------------------------------------------------------------------------------
  function new(string name="hip_pg_power_ungate_seq");
    super.new(name);
  endfunction : new

  //------------------------------------------------------------------------------
  // task: body
  //
  // Purpose:
  //   Step interface through HIP PG power gating flow
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
    hip_pg_drive_soc_phy_pwr_req_seq    soc_phy_pwr_req_seq;
    hip_pg_wait_for_phy_soc_pwr_ack_seq phy_soc_pwr_ack_seq;

    super.body();

    // only perform this sequence if power domain can be gated/ungated by SIP and power domain is OFF 

    if ((p_sequencer.config.domain_controlled_by_pg == 1'b1) &&
        (p_sequencer.config.domain_status == hip_pg::HIP_PG_DOMAIN_OFF)) begin
      p_sequencer.config.domain_status = hip_pg::HIP_PG_DOMAIN_POWER_UNGATE;

      `ovm_do_with(soc_phy_pwr_req_seq,{value == 1'b1;})

      // wait for response from HIP
      // FIXME: wait time not listed in spec, so we wait up to 1000ns
      `ovm_do_with(phy_soc_pwr_ack_seq,{value == 1'b1; timeout_value_ps == 1000000;})

      // ...and we're done!

      p_sequencer.config.domain_status = hip_pg::HIP_PG_DOMAIN_ON;
    end

    else begin
      if (p_sequencer.config.domain_controlled_by_pg != 1'b1)
        `ovm_error(get_type_name(),
                   $psprintf("HIP PG power_ungate sequence called on domain not under SIP"))
      else if (p_sequencer.config.domain_status != hip_pg::HIP_PG_DOMAIN_OFF)
        `ovm_error(get_type_name(),
                   $psprintf("HIP PG power_ungate sequence called on domain not in HIP_PG_DOMAIN_OFF state"))
    end
  endtask : body

endclass : hip_pg_power_ungate_seq

`endif // `ifndef HIP_PG_POWER_UNGATE_SEQ__SVH

