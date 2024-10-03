//------------------------------------------------------------------------------
// Class: iosf_pri_constrained_request_mem_wr_item
// IOSF-P request to do a constrained random Memory write. See <iosf_pri_request_mem_wr_item> for an unconstrained version of this request.
//------------------------------------------------------------------------------
class hqm_iosf_pri_constrained_request_mem_wr_item extends iosf_pri_constrained_request_mem_wr_item;
  `ovm_object_utils(hqm_iosf_pri_constrained_request_mem_wr_item)

  function new(string name="hqm_iosf_pri_request_mem_wr_item", ovm_sequencer_base sequencer = null, ovm_sequence_base parent_sequence = null);
    super.new(name, sequencer, parent_sequence);

    process_addr_space_id = 64'hffffffff_ffffffff;
  endfunction : new

endclass : hqm_iosf_pri_constrained_request_mem_wr_item

//------------------------------------------------------------------------------
// Class: iosf_pri_constrained_request_mem_rd_item
// IOSF-P request to do a constrained random Memory write. See <iosf_pri_request_mem_rd_item> for an unconstrained version of this request.
//------------------------------------------------------------------------------
class hqm_iosf_pri_constrained_request_mem_rd_item extends iosf_pri_constrained_request_mem_rd_item;
  `ovm_object_utils(hqm_iosf_pri_constrained_request_mem_rd_item)

  function new(string name="hqm_iosf_pri_request_mem_rd_item", ovm_sequencer_base sequencer = null, ovm_sequence_base parent_sequence = null);
    super.new(name, sequencer, parent_sequence);

    process_addr_space_id = 64'hffffffff_ffffffff;
  endfunction : new

endclass : hqm_iosf_pri_constrained_request_mem_rd_item

