
`ifdef IP_TYP_TE
`include "stim_config_macros.svh"
`endif

class hqm_cfg_file_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_cfg_file_seq_stim_config";

  `ovm_object_utils_begin(hqm_cfg_file_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

`ifdef IP_TYP_TE
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

 `ovm_sequence_utils(hqm_cfg_file_seq, sla_sequencer)

  rand hqm_cfg_file_seq_stim_config       cfg;
`ifdef IP_TYP_TE
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_cfg_file_seq_stim_config);
`endif

    string      file_plusarg;
    bit         err_if_no_file;

 //-------------------------
 function new(string name = "hqm_cfg_file_seq");
       super.new(name);
       cfg = hqm_cfg_file_seq_stim_config::type_id::create("hqm_cfg_file_seq_stim_config");
`ifdef IP_TYP_TE
       apply_stim_config_overrides(0);
`else
       cfg.randomize();
`endif

       this.err_if_no_file  = 1'b1;
       this.file_plusarg    =   "HQM_SEQ_CFG"; 
       $value$plusargs("HQM_CFG_CFTFILE=%s",file_plusarg);   
       ovm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq: new - file_plusarg=%s, inst_suffix=%s", file_plusarg, inst_suffix), OVM_MEDIUM);   
 endfunction

 //-------------------------
 function set_cfg(string file_plusarg = "HQM_SEQ_CFG", bit err_if_no_file = 1'b1);
       this.file_plusarg        = file_plusarg;
       this.err_if_no_file      = err_if_no_file;
       ovm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq: set_cfg - file_plusarg=%s, inst_suffix=%s, err_if_no_file=%0d", file_plusarg, inst_suffix, err_if_no_file), OVM_MEDIUM);   
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

`ifdef IP_TYP_TE
    apply_stim_config_overrides(1);
`endif

    //-----------------------------------
    //-- read cft file
    //-----------------------------------
    if ($value$plusargs({$psprintf("HQM%s_%s",inst_suffix, file_plusarg),"=%s"}, file_name)) begin
       file_mode_exists = 1;  
        ovm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq: start - file_name=%s, inst_suffix=%s", file_name, inst_suffix), OVM_MEDIUM); 
    end else begin
       file_mode_exists = 0;  
       if (err_if_no_file) begin
         `ovm_error("HQM_CFG_FILE_SEQ","hqm_cfg_file_seq: start - file_name not set")
       end
    end

    //-----------------------------------
    //-- push to cfg_cmds  
    //-----------------------------------
    if (file_mode_exists) begin  

       ovm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq:S1 CFG File Mode Open File=%s, inst_suffix=%s",file_name, inst_suffix), OVM_MEDIUM); 

       file_pointer = $fopen(file_name, "r");
       assert(file_pointer != 0) else                                                           
            ovm_report_fatal(get_full_name(), $psprintf("hqm_cfg_file_seq:S1 Failed to open File=%s, inst_suffix=%s", file_name, inst_suffix));
   
       //--------------------------------
       while($fgets(line, file_pointer)) begin
            if(line != "") begin
                //ovm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq:S2 FILE COMMAND -> %s", line), OVM_MEDIUM);
                cfg_cmds.push_back(line);
                //ovm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq:S2 cfg_cmds=%s cfg_cmds.size=%0d", line, cfg_cmds.size()), OVM_MEDIUM);
                line = "";
            end
       end 

       //--------------------------------
       for(int i=0; i<cfg_cmds.size(); i++) begin
          ovm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq:S3 - cfg_cmds[%0d]=%s", i, cfg_cmds[i]), OVM_MEDIUM); 
       end
       ovm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq:S3.1 done - File=%s, inst_suffix=%s, cfg_cmds.size=%0d, will call super.body() to start issue_cfg ",file_name, inst_suffix, cfg_cmds.size()), OVM_MEDIUM); 

       super.body();

       //--------------------------------
       if ($value$plusargs({file_plusarg,"_POST_DELAY=%d"}, post_delay)) begin
         for(int i = 0; i < post_delay; i++)begin         // wait for 10k cycles post simulation so that packets can be dequeued
            #1ns;
         end
       end

    end else begin
      ovm_report_info("HQM_CFG_FILE_SEQ", $psprintf("hqm_cfg_file_seq: To use File Mode specify file using +%s=<file_name>", file_plusarg), OVM_MEDIUM);
    end

 endtask

endclass
