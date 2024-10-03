import hqm_tb_cfg_pkg::*;

class hcw_test0_hqm_cfg_seq extends hqm_base_cfg_seq;

    `uvm_object_utils(hcw_test0_hqm_cfg_seq) 

    `uvm_declare_p_sequencer(slu_sequencer)

   hqm_mem_map_cfg mem_map_obj;
   string mem_addr;
   
   
    function void get_agent_cfg_obj();
        uvm_object tmp_obj;

        if (p_sequencer.get_config_object({"hqm_mem_map_obj",inst_suffix}, tmp_obj,0))  begin

            $cast(mem_map_obj, tmp_obj);
        end else begin
            `uvm_fatal(get_full_name(), "Unable to get config object hqm_ss_agent_cfg_obj");
        end 

    endfunction   

    function new(string name = "hcw_test0_hqm_cfg_seq");
       super.new(name);
    endfunction

    virtual task body();       
       get_agent_cfg_obj();

       mem_addr= $psprintf("0x%0h",mem_map_obj.dram_addr_hi);
       
       cfg_cmds.push_back("#mem_update      # initialize memories to hqm_cfg defaults using backdoor access");

       cfg_cmds.push_back("cfg_begin");

         cfg_cmds.push_back("dir qid 0");
         cfg_cmds.push_back("vas 0 credit_cnt=16384 dir_qidv0=1");
         cfg_cmds.push_back("dir pp 0 vas=0");
          
         if($test$plusargs("HQM_ENQ_TEST0_CQ_DEP1024"))  
            cfg_cmds.push_back({"dir cq 0 cq_depth=1024 gpa=",mem_addr});
         else
            cfg_cmds.push_back({"dir cq 0 cq_depth=64 gpa=",mem_addr});

       cfg_cmds.push_back("cfg_end");

       //cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");
       super.body();
    endtask
endclass
