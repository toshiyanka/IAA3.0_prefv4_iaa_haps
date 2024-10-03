
class hqm_cfg_base_seq extends ovm_sequence;

  `ovm_sequence_utils(hqm_cfg_base_seq, sla_sequencer)

  string        inst_suffix = "";
  string        tb_env_hier = "*";

  protected sla_tb_env tb_env;
  protected sla_ral_env ral; 
  protected hqm_cfg     cfg;
  protected sla_ral_access_path_t access_method = "backdoor";
  protected sla_ral_access_path_t rtl_watch_access_method = "";
  protected string skip_files[$];
  protected string cfg_files[$];
  protected string ral_type = "";

  //enable file mode
  protected int seq_count        = 0;
  protected bit enable_file_mode = 0;
            bit skip_write_if_value_unchange = 1;
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  function void set_skip_if_unchange(bit state);
    this.skip_write_if_value_unchange = state;
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  function new(string name = "hqm_cfg_base_seq");
     super.new(name);
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  function void set_tb_env(sla_tb_env m_env);
     tb_env = m_env;
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  function void set_ral_env(sla_ral_env ral_env);
     ral = ral_env;
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  function void set_ral_type(string ral_env_type);
    ral_type = ral_env_type; 

    if (ral == null) begin
      `sla_assert( $cast(ral, sla_utils::get_comp_by_type( ral_type )), ( ($psprintf("set_ral_type() - Could not find RAL Env Type [%s]\n", ral_type) )));
    end
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  function void set_access_method(sla_ral_access_path_t access);
     access_method = access;
     ovm_report_info("hqm_cfg_base_seq", $psprintf("set_access_method access_method -> %s", access), OVM_HIGH);  
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  function void set_rtl_watch_access_method(sla_ral_access_path_t access);
     rtl_watch_access_method = access;
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  function void skip_files_by_name(string files[$], bit replace = 1);
     if(replace)
        skip_files = files;
     else
        skip_files = {skip_files, files};
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  function void cfg_files_by_name(string files[$], bit replace = 1);
     if(replace)
        cfg_files = files;
     else
        cfg_files = {cfg_files, files};
  endfunction
  //------------------------------------------------------------------------  
  //  
  //------------------------------------------------------------------------  
  virtual function string get_access_method(sla_ral_reg r);
     if(r.get_rtl_watch() && rtl_watch_access_method != "") begin
        ovm_report_info("hqm_cfg_base_seq", $psprintf("get_access_method rtl_watch_access_method -> %s", rtl_watch_access_method), OVM_MEDIUM);  
        return(rtl_watch_access_method);
     end else begin
        ovm_report_info("hqm_cfg_base_seq", $psprintf("get_access_method access_method -> %s", access_method), OVM_MEDIUM);  
        return(access_method);
     end
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  virtual function void apply_user_setting();
     skip_files_by_name(cfg.ral_skip_files);
     cfg_files_by_name(cfg.ral_cfg_files);
     tb_env_hier = cfg.get_tb_env_hier();
     set_ral_env(cfg.get_ral_env());
     set_ral_type(cfg.ral_type);
     set_access_method(cfg.ral_access_path);
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  function void apply_access_cfg();
     p_sequencer.get_config_string("sla_ral_config_access_method", access_method);
  endfunction
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  virtual task pre_body();
    bit         got_input = 0;
    ovm_object  o;

    //get cfg object
    if (cfg == null) begin
      if (!p_sequencer.get_config_object({"i_hqm_cfg",inst_suffix}, o)) begin
         ovm_report_fatal(get_full_name(), "Unable to find hqm_cfg object");
      end

      if (!$cast(cfg, o)) begin
         ovm_report_fatal(get_full_name(), $psprintf("Config %s associated with config %s is not same type", o.sprint(), cfg.sprint()));
      end

      if (cfg == null) begin
        ovm_report_fatal("CFG SEQ", $psprintf("Unable to get CFG object"));
      end
    end
    //user setting, parameter to connect the RAL settings, access method, type, skip files..etc
    apply_user_setting();
    //
    apply_access_cfg();
  endtask
  //------------------------------------------------------------------------  
  //
  //------------------------------------------------------------------------  
  virtual task post_body();
    seq_count++;
  endtask

endclass
