`ifndef HQM_FLR_RERESET_SEQ_SV
`define HQM_FLR_RERESET_SEQ_SV

class hqm_flr_rereset_seq extends sla_sequence_base;

  `ovm_sequence_utils(hqm_flr_rereset_seq, sla_sequencer)

  hqm_sla_pcie_flr_sequence     flr_seq;
  int my_func_no = 0;

  function new(string name = "hqm_flr_rereset_seq");
    super.new(name);
  endfunction

  extern virtual task body();

endclass

task hqm_flr_rereset_seq::body();
  // FLR sequence - use plusargs to control reset
  // PF FLR -> {no_sys_init==1'b_1; func_no==0; }
  // VF FLR -> {no_sys_init==1'b_1; func_no==n; }
  //  where `n' is (targeted VF number + 1);
  //  E.g., n==1 for VF0, n==16 for VF15;

   $value$plusargs({"hraisflrfn","=%d"}, this.my_func_no); // set flr func_no

   `ovm_do_with(flr_seq, {no_sys_init==1'b_1; func_no==my_func_no; });
endtask

`endif //HQM_FLR_RERESET_SEQ_SV
