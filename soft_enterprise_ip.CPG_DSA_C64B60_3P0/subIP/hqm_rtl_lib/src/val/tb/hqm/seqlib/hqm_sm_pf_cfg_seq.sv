
import hqm_tb_cfg_pkg::*;

//-----------------------------------------------------------
//-----------------------------------------------------------
class hqm_sm_pf_cfg_seq extends hqm_base_cfg_seq;

    `ovm_sequence_utils(hqm_sm_pf_cfg_seq, sla_sequencer)

    hqm_mem_map_cfg mem_map_obj;


    function new(string name = "hqm_sm_pf_cfg_seq");
       super.new(name);
    endfunction


    function void get_agent_cfg_obj();
        ovm_object tmp_obj;

        if (p_sequencer.get_config_object({"hqm_mem_map_obj",inst_suffix}, tmp_obj,0))  begin
            $cast(mem_map_obj, tmp_obj);
           `ovm_info(get_name(), $psprintf("get_config_object hqm_mem_map_obj%s", inst_suffix), OVM_NONE);
        end else begin
            `ovm_fatal(get_full_name(), "Unable to get config object hqm_mem_map_obj");
        end

    endfunction

   
    virtual task body();
       get_agent_cfg_obj();

       //--------------------------------
       `ovm_info(get_name(), $psprintf("Starting hqm_cfg cfg_cmds push... inst_suffix=%0s",inst_suffix), OVM_LOW);

       //--------------------------------
       cfg_cmds.push_back("idle 300");
       if($test$plusargs("HQM_PMCSR_DISABLE_PROG")) begin 
         `ovm_info(get_name(), $psprintf("HQM Agent Write config_master.cfg_pm_pmcsr_disable.disable=0"), OVM_LOW);
          cfg_cmds.push_back("rd config_master.cfg_pm_pmcsr_disable");
          cfg_cmds.push_back("wr config_master.cfg_pm_pmcsr_disable.disable 0");
          cfg_cmds.push_back("rd config_master.cfg_pm_pmcsr_disable");
          cfg_cmds.push_back("rd config_master.cfg_pm_override");
       end

       //--------------------------------
       cfg_cmds.push_back("idle 100");

       //--------------------------------
       //--------------------------------
       `ovm_info(get_name(), $psprintf("HQM Agent %s FUNC PF Addr set to: %h", inst_suffix, mem_map_obj.func_pf_low_base), OVM_LOW);
       `ovm_info(get_name(), $psprintf("HQM Agent %s CSR PF Addr set to: %h", inst_suffix, mem_map_obj.csr_pf_base), OVM_LOW);
       
       // Setup FUNC_PF BAR to a base address of 0x00000001_xxxxxxxx
       cfg_cmds.push_back($psprintf("wr hqm_pf_cfg_i.func_bar_l 0x%08x",{mem_map_obj.func_pf_low_base[31:4],4'h0}));
       cfg_cmds.push_back($psprintf("wr hqm_pf_cfg_i.func_bar_u 0x%08x",mem_map_obj.func_pf_low_base[63:32]));

       // Setup CSR_PF BAR to a base address of 0x00000002_xxxxxxxx
       cfg_cmds.push_back($psprintf("wr hqm_pf_cfg_i.csr_bar_l 0x%08x",{mem_map_obj.csr_pf_base[31:4],4'h0}));
       cfg_cmds.push_back($psprintf("wr hqm_pf_cfg_i.csr_bar_u 0x%08x",mem_map_obj.csr_pf_base[63:32]));

       // Enable memory operations
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");

       if($test$plusargs("HQMV30_ATS_ENA")) begin 
          cfg_cmds.push_back("rd hqm_pf_cfg_i.ATS_CAP_CONTROL");
          cfg_cmds.push_back("wr hqm_pf_cfg_i.ATS_CAP_CONTROL.ATSE 1");
          cfg_cmds.push_back("rd hqm_pf_cfg_i.ATS_CAP_CONTROL");
         `ovm_info(get_name(), $psprintf("HQM Agent Write hqm_pf_cfg_i.ATS_CAP_CONTROL.ATSE=1"), OVM_LOW);
       end

       super.body();
    endtask

endclass
