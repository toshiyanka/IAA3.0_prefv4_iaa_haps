`include "stim_config_macros.svh"

class hcw_perf_dir_ldb_test1_hcw_wrp_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_perf_dir_ldb_test1_hcw_wrp_seq_stim_config";

  `ovm_object_utils_begin(hcw_perf_dir_ldb_test1_hcw_wrp_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hcw_perf_dir_ldb_test1_hcw_wrp_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hcw_perf_dir_ldb_test1_hcw_wrp_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_perf_dir_ldb_test1_hcw_wrp_seq_stim_config

class hcw_perf_dir_ldb_test1_hcw_wrp_seq extends hqm_pwr_base_seq;
  `ovm_sequence_utils(hcw_perf_dir_ldb_test1_hcw_wrp_seq, sla_sequencer)
  sla_ral_data_t   rd_data;
  rand hcw_perf_dir_ldb_test1_hcw_wrp_seq_stim_config        cfg;

  hcw_perf_dir_ldb_test1_hcw_seq hcw_perf_dir_ldb_test1_hcw;
  hqm_pwr_prochot_user_data_seq pwr_prochot_user_data;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_perf_dir_ldb_test1_hcw_wrp_seq_stim_config);
  function new(string name = "hcw_perf_dir_ldb_test1_hcw_wrp_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hcw_perf_dir_ldb_test1_hcw_wrp_seq_stim_config::type_id::create("hcw_perf_dir_ldb_test1_hcw_wrp_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);

  endfunction

  virtual task body();
    super.body();
    apply_stim_config_overrides(1);
    ral_access_path = cfg.access_path;
    base_tb_env_hier = cfg.tb_env_hier;
    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
    `ovm_info(get_full_name(),$sformatf("\n hcw_perf_dir_ldb_test1_hcw_wrp_seq started \n"),OVM_LOW)
    if ($test$plusargs("HQM_PWR_CQ_DIR_DIS")) begin 
       WriteField("list_sel_pipe","cfg_cq_dir_disable[0]","disabled",1'b1);
       read_and_check_reg("list_sel_pipe","cfg_cq_dir_disable[0]",SLA_FALSE,rd_data);
    end
    if ($test$plusargs("HQM_PWR_CQ_LDB_DIS")) begin 
       WriteField("list_sel_pipe","cfg_cq_ldb_disable[0]","disabled",1'b1);
       read_and_check_reg("list_sel_pipe","cfg_cq_ldb_disable[0]",SLA_FALSE,rd_data);
    end
    fork
    begin  
       `ovm_info(get_full_name(),$sformatf("\n hcw_perf_dir_ldb_test1_hcw seq started \n"),OVM_LOW)
       `ovm_do(hcw_perf_dir_ldb_test1_hcw);
       `ovm_info(get_full_name(),$sformatf("\n hcw_perf_dir_ldb_test1_hcw seq ended \n"),OVM_LOW)
    end 
    begin  
        `ovm_info(get_full_name(),$sformatf("\n pwr_prochot_user_data seq started \n"),OVM_LOW)
        `ovm_do(pwr_prochot_user_data);
        `ovm_info(get_full_name(),$sformatf("\n pwr_prochot_user_data seq ended \n"),OVM_LOW)
    end 
    join
    `ovm_info(get_full_name(),$sformatf("\n hcw_perf_dir_ldb_test1_hcw_wrp_seq ended \n"),OVM_LOW)
  endtask: body
endclass: hcw_perf_dir_ldb_test1_hcw_wrp_seq   

