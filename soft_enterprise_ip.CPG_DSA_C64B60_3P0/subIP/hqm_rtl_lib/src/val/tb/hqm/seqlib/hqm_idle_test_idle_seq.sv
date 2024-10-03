import hqm_tb_cfg_pkg::*;

class hqm_idle_test_idle_seq extends hqm_base_cfg_seq;

    `ovm_sequence_utils(hqm_idle_test_idle_seq, sla_sequencer)

    function new(string name = "hqm_idle_test_idle_seq");
       super.new(name);
    endfunction

    virtual task body();
      cfg_cmds.push_back("IDLE 10000");

      super.body();
    endtask

endclass
