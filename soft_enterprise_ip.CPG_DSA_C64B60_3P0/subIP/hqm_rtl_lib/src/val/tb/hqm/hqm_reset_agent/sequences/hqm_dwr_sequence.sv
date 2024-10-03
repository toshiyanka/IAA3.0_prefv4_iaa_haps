
`ifndef HQM_DWR_SEQUENCE__SV 
`define HQM_DWR_SEQUENCE__SV

import hqm_tb_sequences_pkg::*;
// Dirty Warm Reset (DWR) Flow Sequence
class hqm_dwr_sequence extends ovm_sequence;

  `ovm_sequence_utils(hqm_dwr_sequence, sla_sequencer);


  function new(string name = "hqm_dwr_sequence");
    super.new(name);
  endfunction: new

  hqm_reset_unit_sequence       dwr_flow_part1_seq;
  hqm_reset_unit_sequence       dwr_flow_part2_seq;
  hqm_boot_sequence             reset_deassert_seq;

  virtual task body();
    chandle force_prim_side_clkack_handle;

    super.body();

    force_prim_side_clkack_handle = SLA_VPI_get_handle_by_name("hqm_tb_top.force_prim_side_clkack_hqm",0);

    `ovm_info(get_type_name(),"Starting hqm_dwr_sequence", OVM_LOW);

    // Force prim/side_clkack and prim_clk to 0
    `ovm_info(get_type_name(),"Forcing prim_clkack & side_clk_ack to 0", OVM_DEBUG);
    hqm_seq_put_value(force_prim_side_clkack_handle, 1'b1);

    // assert prim/side reset
    `ovm_info(get_type_name(),"Starting dwr_flow_part1_seq", OVM_DEBUG);
    `ovm_do_on_with(dwr_flow_part1_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==PRIM_SIDE_RESET_ASSERT;});
    `ovm_info(get_type_name(),"Completed dwr_flow_part1_seq", OVM_DEBUG);

    // wait for prim/side clkreq to be high
    `ovm_info(get_type_name(),"Starting dwr_flow_part2_seq", OVM_DEBUG);
    `ovm_do_on_with(dwr_flow_part2_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==PRIM_SIDE_CLKREQ_ASSERT;}); 
    `ovm_info(get_type_name(),"Completed dwr_flow_part2_seq", OVM_DEBUG);

    // Release prim/side_clkack and prim_clk
    `ovm_info(get_type_name(),"Releasing prim_clkack & side_clk_ack from 0", OVM_DEBUG);
    hqm_seq_put_value(force_prim_side_clkack_handle, 1'b0);
 
    // Deassert all resets
    `ovm_info(get_type_name(),"Starting reset_deassert_seq", OVM_DEBUG);
    `ovm_do(reset_deassert_seq); 
    `ovm_info(get_type_name(),"Completed reset_deassert_seq", OVM_DEBUG);

    `ovm_info(get_type_name(),"Done with hqm_dwr_sequence", OVM_LOW);

  endtask: body

endclass:hqm_dwr_sequence

`endif

