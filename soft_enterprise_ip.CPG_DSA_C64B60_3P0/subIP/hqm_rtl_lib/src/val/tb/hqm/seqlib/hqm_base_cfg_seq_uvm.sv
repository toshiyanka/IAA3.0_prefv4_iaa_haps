import hqm_cfg_pkg::*;

class hqm_base_cfg_seq extends slu_sequence_base;

    `uvm_object_utils(hqm_base_cfg_seq) 

    `uvm_declare_p_sequencer(slu_sequencer)

    string      inst_suffix = "";

    hqm_cfg     i_hqm_cfg;

    string      cfg_cmds[$];

    function new(string name = "hqm_base_cfg_seq");
       super.new(name);
    endfunction

    virtual task body();
       bit              do_cfg_seq;
       hqm_cfg_seq      cfg_seq;
       uvm_object       o_tmp;

       //-----------------------------
       //-- get i_hqm_cfg
       //-----------------------------
       if (!p_sequencer.get_config_object({"i_hqm_cfg",inst_suffix}, o_tmp)) begin
         uvm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
       end 

       if (!$cast(i_hqm_cfg, o_tmp)) begin
         uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
       end 

       for (int i = 0 ; i < cfg_cmds.size() ; i++) begin
         issue_cfg(i_hqm_cfg,cfg_cmds[i]);
       end 
    endtask

    virtual task issue_cfg(hqm_cfg cfg, string cfg_cmd);
       bit              do_cfg_seq;
       hqm_cfg_seq      cfg_seq;

       uvm_report_info("CFG SEQ", $psprintf("COMMAND -> %s", cfg_cmd), UVM_DEBUG);
       i_hqm_cfg.set_cfg(cfg_cmd,do_cfg_seq); 

       if (do_cfg_seq) begin
         `uvm_create(cfg_seq)
         cfg_seq.inst_suffix = inst_suffix;
         cfg_seq.pre_body();
         start_item(cfg_seq);
         finish_item(cfg_seq);
         cfg_seq.post_body();
       end 
    endtask

endclass
