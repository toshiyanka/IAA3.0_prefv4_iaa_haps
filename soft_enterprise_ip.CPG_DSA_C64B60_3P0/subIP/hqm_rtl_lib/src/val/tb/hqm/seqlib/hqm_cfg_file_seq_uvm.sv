
`ifdef IP_OVM_STIM
`include "stim_config_macros.svh"
`endif

class hqm_cfg_file_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hqm_cfg_file_seq_stim_config";

  `uvm_object_utils_begin(hqm_cfg_file_seq_stim_config)
    `uvm_field_string(tb_env_hier,        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hqm_cfg_file_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";

  function new(string name = "hqm_cfg_file_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_cfg_file_seq_stim_config




//----------------------------------------------
//----------------------------------------------
class hqm_cfg_file_seq extends hqm_base_cfg_seq;

 `uvm_object_utils(hqm_cfg_file_seq) 

 `uvm_declare_p_sequencer(slu_sequencer)

  rand hqm_cfg_file_seq_stim_config       cfg;
`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_cfg_file_seq_stim_config);
`endif

    string      file_plusarg;
    bit         err_if_no_file;

 //-------------------------
 function new(string name = "hqm_cfg_file_seq");
       super.new(name);
       cfg = hqm_cfg_file_seq_stim_config::type_id::create("hqm_cfg_file_seq_stim_config");
`ifdef IP_OVM_STIM
       apply_stim_config_overrides(0);
`else
       cfg.randomize();
`endif

       this.err_if_no_file  = 1'b1;
       this.file_plusarg    =   "HQM_SEQ_CFG"; 
       $value$plusargs("HQM_CFG_CFTFILE=%s",file_plusarg);   
       uvm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq: new - file_plusarg=%s, inst_suffix=%s", file_plusarg, inst_suffix), UVM_MEDIUM);   
 endfunction

 //-------------------------
 function set_cfg(string file_plusarg = "HQM_SEQ_CFG", bit err_if_no_file = 1'b1);
       this.file_plusarg        = file_plusarg;
       this.err_if_no_file      = err_if_no_file;
       uvm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq: set_cfg - file_plusarg=%s, inst_suffix=%s, err_if_no_file=%0d", file_plusarg, inst_suffix, err_if_no_file), UVM_MEDIUM);   
 endfunction
 
 //-------------------------
 //-------------------------
 virtual task body();
    integer          file_pointer;
    string           file_name = "";
    string           line;
    bit              file_mode_exists;
    int              post_delay;

    super.body();       // Need to get hqm_cfg class handle, cfg_cmds[] is empty, so no commands will be issued

`ifdef IP_OVM_STIM
    apply_stim_config_overrides(1);
`endif

    //-----------------------------------
    //-- read cft file
    //-----------------------------------
    if ($value$plusargs({$psprintf("HQM%s_%s",inst_suffix, file_plusarg),"=%s"}, file_name)) begin
       file_mode_exists = 1;  
        uvm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq: start - file_name=%s, inst_suffix=%s", file_name, inst_suffix), UVM_MEDIUM); 
    end else begin
       file_mode_exists = 0;  
       if (err_if_no_file) begin
         `uvm_error("HQM_CFG_FILE_SEQ","hqm_cfg_file_seq: start - file_name not set")
       end 
    end 

    //-----------------------------------
    //-- push to cfg_cmds  
    //-----------------------------------
    if (file_mode_exists) begin  

       uvm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq:S1 CFG File Mode Open File=%s, inst_suffix=%s",file_name, inst_suffix), UVM_MEDIUM); 

       file_pointer = $fopen(file_name, "r");
       assert(file_pointer != 0) else                                                           
            uvm_report_fatal(get_full_name(), $psprintf("hqm_cfg_file_seq:S1 Failed to open File=%s, inst_suffix=%s", file_name, inst_suffix));
   
       //--------------------------------
       while($fgets(line, file_pointer)) begin
            if(line != "") begin
                //uvm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq:S2 FILE COMMAND -> %s", line), UVM_MEDIUM);
                cfg_cmds.push_back(line);
                //uvm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq:S2 cfg_cmds=%s cfg_cmds.size=%0d", line, cfg_cmds.size()), UVM_MEDIUM);
                line = "";
            end 
       end 

       //--------------------------------
       for(int i=0; i<cfg_cmds.size(); i++) begin
          uvm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq:S3 - cfg_cmds[%0d]=%s", i, cfg_cmds[i]), UVM_MEDIUM); 
       end 
       uvm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq:S3.1 done - File=%s, inst_suffix=%s, cfg_cmds.size=%0d, will call super.body() to start issue_cfg ",file_name, inst_suffix, cfg_cmds.size()), UVM_MEDIUM); 

       super.body();

       //--------------------------------
       if ($value$plusargs({file_plusarg,"_POST_DELAY=%d"}, post_delay)) begin
         for(int i = 0; i < post_delay; i++)begin         // wait for 10k cycles post simulation so that packets can be dequeued
            #1ns;
         end 
       end 

    end else begin
      uvm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq: To use File Mode specify file using +%s=<file_name>", file_plusarg), UVM_MEDIUM);
    end 

 endtask

endclass
