import hqm_tb_cfg_pkg::*;

class hqm_idle_test_pmcs_disable_seq extends hqm_base_cfg_seq;

    `ovm_sequence_utils(hqm_idle_test_pmcs_disable_seq, sla_sequencer)

    function new(string name = "hqm_idle_test_pmcs_disable_seq");
       super.new(name);
    endfunction

    virtual task body();
      cfg_cmds.push_back("rd config_master.cfg_pm_pmcsr_disable.disable 1");
      cfg_cmds.push_back("IDLE 10000");

      super.body();
    endtask

endclass
