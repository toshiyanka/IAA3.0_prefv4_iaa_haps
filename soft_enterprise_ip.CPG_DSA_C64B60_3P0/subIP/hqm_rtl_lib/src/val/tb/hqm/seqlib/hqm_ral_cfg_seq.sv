`ifndef HQM_RAL_CFG_SEQ__SV
`define HQM_RAL_CFG_SEQ__SV
 
`include "stim_config_macros.svh"

class hqm_ral_cfg_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_ral_cfg_seq_stim_config";

  `ovm_object_utils_begin(hqm_ral_cfg_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_ral_cfg_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_ral_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_ral_cfg_seq_stim_config

class hqm_ral_cfg_seq extends hqm_base_seq ;

  `ovm_object_utils( hqm_ral_cfg_seq)

  rand hqm_ral_cfg_seq_stim_config        cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_ral_cfg_seq_stim_config);

  function new(string name = "hqm_ral_cfg_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 
    cfg = hqm_ral_cfg_seq_stim_config::type_id::create("hqm_ral_cfg_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();


endclass : hqm_ral_cfg_seq



task hqm_ral_cfg_seq::body();

  sla_ral_data_t rd_reg_val;
  sla_ral_data_t rd_field_val[$];

 `ovm_info(get_full_name(),$sformatf("\n hqm_ral_cfg_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);

 
  compare_reg   ("TOTAL_VF",                   `DEF_VAL_TOTAL_VF,               rd_reg_val, "hqm_system_csr"); 
  compare_reg   ("TOTAL_VAS",                  `DEF_VAL_TOTAL_VAS,              rd_reg_val, "hqm_system_csr");
  compare_reg   ("TOTAL_LDB_PORTS",            `DEF_VAL_TOTAL_LDB_PORTS,        rd_reg_val, "hqm_system_csr");
  compare_reg   ("TOTAL_DIR_PORTS",            `DEF_VAL_TOTAL_DIR_PORTS,        rd_reg_val, "hqm_system_csr");
  compare_reg   ("TOTAL_LDB_QID",              `DEF_VAL_TOTAL_LDB_QID,          rd_reg_val, "hqm_system_csr");
  compare_reg   ("TOTAL_DIR_QID",              `DEF_VAL_TOTAL_DIR_QID,          rd_reg_val, "hqm_system_csr");
  compare_reg   ("TOTAL_CREDITS",              `DEF_VAL_TOTAL_CREDITS,          rd_reg_val, "hqm_system_csr");
  compare_reg   ("CFG_AQED_TOT_ENQUEUE_LIMIT", `DEF_VAL_AQED_TOT_ENQUEUE_LIMIT, rd_reg_val, "list_sel_pipe");
  compare_fields("TOTAL_SN_REGIONS", {"GROUP"}, {`DEF_VAL_TOTAL_SN_REGIONS_GROUP}, rd_field_val, "hqm_system_csr");

  

  compare_reg("CFG_CQ_LDB_TOT_INFLIGHT_LIMIT", `DEF_VAL_CQ_LDB_TOT_INFLIGHT_LIMIT, rd_reg_val, "list_sel_pipe");
  compare_reg("CFG_FID_INFLIGHT_LIMIT",        `DEF_VAL_FID_INFLIGHT_LIMIT,        rd_reg_val, "list_sel_pipe");

  compare_reg("HQM_CSR_CP_LO",  `HQM_CSR_CP_LO,  rd_reg_val, "hqm_sif_csr");
  compare_reg("HQM_CSR_CP_HI",  `HQM_CSR_CP_HI,  rd_reg_val, "hqm_sif_csr");
  compare_reg("HQM_CSR_WAC_LO", `HQM_CSR_WAC_LO, rd_reg_val, "hqm_sif_csr");
  compare_reg("HQM_CSR_WAC_HI", `HQM_CSR_WAC_HI, rd_reg_val, "hqm_sif_csr");
  compare_reg("HQM_CSR_RAC_LO", `HQM_CSR_RAC_LO, rd_reg_val, "hqm_sif_csr");
  compare_reg("HQM_CSR_RAC_HI", `HQM_CSR_RAC_HI, rd_reg_val, "hqm_sif_csr");
  
  for (int qid=0;qid<32;qid++) begin
    //compare_reg("CFG_AQED_QID_FID_LIMIT[%0d]", `DEF_VAL_AQED_QID_FID_LIMIT, "aqed_pipe");
    compare_reg($psprintf("CFG_AQED_QID_FID_LIMIT[%0d]", qid), `DEF_VAL_AQED_QID_FID_LIMIT, rd_reg_val, "aqed_pipe");
  end  

  `ovm_info(get_full_name(),$sformatf("\n hqm_ral_cfg_seq  ended \n"),OVM_LOW)
  endtask: body


`endif
