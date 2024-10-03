import hqm_tb_cfg_pkg::*;

class hqm_wait_for_reset_done_seq extends hqm_base_cfg_seq;

    `uvm_object_utils(hqm_wait_for_reset_done_seq) 

    `uvm_declare_p_sequencer(slu_sequencer)

    function new(string name = "hqm_wait_for_reset_done_seq");
       super.new(name);

       // Wait for reset to be done (including hardware memory init)
       if (!$test$plusargs("HQM_SKIP_PMCSR_DISABLE")) begin
          cfg_cmds.push_back("wr config_master.cfg_pm_pmcsr_disable.disable 0");
       end 
       // poll to Wait for reset to be done 
       cfg_cmds.push_back("poll config_master.cfg_diagnostic_reset_status 0x80000bff 0x80000bff 500");
       // poll to Wait for unit_idle to be done 
       cfg_cmds.push_back("poll config_master.cfg_diagnostic_idle_status 0x0007ffff 0x0007ffff 500");
    endfunction
endclass
