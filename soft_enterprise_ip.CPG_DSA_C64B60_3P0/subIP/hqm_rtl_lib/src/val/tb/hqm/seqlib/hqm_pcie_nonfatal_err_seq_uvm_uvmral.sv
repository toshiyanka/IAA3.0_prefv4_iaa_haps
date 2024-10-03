// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_pcie_nonfatal_err_seq.sv
//
// Description :
//
//   Sequence that will cause a PCIe Error message (opcode 0x49) for a non-fatal error to be generated.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
//     * do_bar_init   - if set to 1 initialize the HQM BAR registers (default is 1)
//     * func_bar_init - value to initialize hqm_system_csr.func_bar_u/func_bar_l to if do_bar_init is 1
//     * csr_bar_init  - value to initialize hqm_system_csr.csr_bar_u/csr_bar_l to if do_bar_init is 1
// -----------------------------------------------------------------------------

`ifdef IP_OVM_STIM
`include "stim_config_macros.svh"
`endif

class hqm_pcie_nonfatal_err_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hqm_pcie_nonfatal_err_seq_stim_config";

  `uvm_object_utils_begin(hqm_pcie_nonfatal_err_seq_stim_config)
    `uvm_field_string(access_path,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(tb_env_hier,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(do_bar_init,         UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(func_bar_init,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(csr_bar_init,        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hqm_pcie_nonfatal_err_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_int(do_bar_init)
    `stimulus_config_field_rand_int(func_bar_init)
    `stimulus_config_field_rand_int(csr_bar_init)
  `stimulus_config_object_utils_end
`endif

  string                        access_path;
  string                        tb_env_hier     = "*";
  bit                           do_bar_init     = 1'b1;

  rand  bit [63:0]              func_bar_init;
  rand  bit [63:0]              csr_bar_init;

  constraint c_hqm_bar_init {
    func_bar_init[25:0] == 26'h0;
    csr_bar_init[31:0]  == 32'h0;
  }

  constraint c_hqm_bar_init_soft {
    soft func_bar_init[63:0]    == 64'h00000001_00000000;
    soft csr_bar_init[63:0]     == 64'h00000002_00000000;
  }

  function new(string name = "hqm_pcie_nonfatal_err_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pcie_nonfatal_err_seq_stim_config

class hqm_pcie_nonfatal_err_seq extends uvm_sequence;
  `uvm_object_utils(hqm_pcie_nonfatal_err_seq)

  rand hqm_pcie_nonfatal_err_seq_stim_config    cfg;

  uvm_reg_block                                 ral;

`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pcie_nonfatal_err_seq_stim_config);
`endif

  function new(string name = "hqm_pcie_nonfatal_err_seq");
    super.new(name); 

    cfg = hqm_pcie_nonfatal_err_seq_stim_config::type_id::create("hqm_pcie_nonfatal_err_seq_stim_config");
    cfg.access_path = "iosf_pri";
`ifdef IP_OVM_STIM
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif

  endfunction

  extern virtual task body();

  extern virtual task WriteReg( string          file_name,
                                string          reg_name,
                                uvm_reg_data_t  wr_data
                              );


  extern virtual task WriteField( string                file_name,
                                  string                reg_name,
                                  string                field_name,
                                  uvm_reg_data_t        wr_data
                                );

  extern virtual task ReadReg( string                   file_name,
                               string                   reg_name,
                               boolean_t                exp_error,
                               output  uvm_reg_data_t   rd_data
                              );
  extern virtual task ReadField( string                 file_name,
                                 string                 reg_name,
                                 string                 field_name,
                                 boolean_t              exp_error,
                                 output  uvm_reg_data_t rd_data
                                );
endclass : hqm_pcie_nonfatal_err_seq

task hqm_pcie_nonfatal_err_seq::body();
  uvm_reg_data_t        wr_data;
  uvm_reg_data_t        rd_data;

`ifdef IP_OVM_STIM
  apply_stim_config_overrides(1);
`endif

  //--08122022   `slu_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
  `slu_assert($cast(ral,slu_ral_db::get_regmodel()), ("Unable to get handle to RAL."))

  // Initialize HQM BAR registers?
  if (cfg.do_bar_init) begin
    WriteReg("hqm_pf_cfg_i","func_bar_l",cfg.func_bar_init[31:0]);
    WriteReg("hqm_pf_cfg_i","func_bar_u",cfg.func_bar_init[63:32]);
    WriteReg("hqm_pf_cfg_i","csr_bar_l", cfg.csr_bar_init[31:0]);
    WriteReg("hqm_pf_cfg_i","csr_bar_u", cfg.csr_bar_init[63:32]);
  end 

  // Enable UR, fatal, non-fatal, and correctable error messages
  WriteReg("hqm_pf_cfg_i","pcie_cap_device_control",'h0000291f);

  // Make sure errors are not masked
  WriteReg("hqm_pf_cfg_i","aer_cap_uncorr_err_mask",'h00000000);
  WriteReg("hqm_pf_cfg_i","aer_cap_corr_err_mask",'h00000000);

  // Make sure the MEM field is 0, disabling the memory space
  WriteReg("hqm_pf_cfg_i","device_command",'h00000004);
  ReadReg("hqm_pf_cfg_i","device_command",SLA_FALSE,rd_data);

  if (rd_data != 'h00000004) begin
    `uvm_error(get_full_name(),"hqm_pf_cfg_i.device_command register does not equal 0x00000004")
  end 

  // Generate ANFES correctable error
  WriteReg("hqm_system_csr","msix_mode",'h00000000);

  // Allows for latency of setting of status registers checked below
  ReadReg("hqm_pf_cfg_i","device_command",SLA_FALSE,rd_data);

  // Check that the AER uncorrectable error status UR field is set
  ReadField("hqm_pf_cfg_i","aer_cap_uncorr_err_status","ur",SLA_FALSE,rd_data);
  if (rd_data != 'h00000001) begin
    `uvm_error(get_full_name(),"hqm_pf_cfg_i.aer_cap_uncorr_err_status register UR field does not equal 1")
  end 

  // Clear UR field
  WriteField("hqm_pf_cfg_i","aer_cap_uncorr_err_status","ur",1);

  // Check that device status has the URD and CED fields set
  ReadReg("hqm_pf_cfg_i","pcie_cap_device_status",SLA_FALSE,rd_data);
  if ((rd_data & 'h0000000f) != 'h0000000a) begin
    `uvm_error(get_full_name(),"hqm_pf_cfg_i.pcie_cap_device_status register does not equal 0x0000000a")
  end 

  // Clear device status register
  WriteReg("hqm_pf_cfg_i","pcie_cap_device_status",'h0000000a);

endtask : body





//--------------------------------------------------------------------
//--------------------------------------------------------------------
task hqm_pcie_nonfatal_err_seq::WriteReg( string               file_name,
                                 string               reg_name,
                                 uvm_reg_data_t       wr_data
                               );
  uvm_reg_block     ral_file;
  uvm_reg           ral_reg;
  uvm_status_e      status;
  slu_ral_sai_t     legal_sai;

  //--------------------
  //--08122022   ral_file = ral.find_file({cfg.tb_env_hier, ".", file_name});
  $cast(ral_file, uvm_reg_block::find_block({cfg.tb_env_hier,".",file_name}, ral));

  if (ral_file == null) begin
    `uvm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end 

  //--------------------
  //--08122022   ral_reg = ral_file.find_reg(reg_name);
  $cast(ral_reg, uvm_reg::m_get_reg_by_full_name({ral_file.get_full_name(), reg_name}));

  if (ral_reg == null) begin
    `uvm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end 

  //--------------------
  //--08122022  legal_sai     = ral_reg.pick_legal_sai_value(RAL_WRITE);
  //--08122022  ral_reg.write(status,wr_data,cfg.access_path,this,.sai(legal_sai));
  ral_reg.write(status, wr_data, cfg.access_path, .parent(this));

endtask : WriteReg

//--------------------------------------------------------------------
//--------------------------------------------------------------------
task hqm_pcie_nonfatal_err_seq::WriteField( string          file_name,
                                   string          reg_name,
                                   string          field_name,
                                   uvm_reg_data_t  wr_data
                                 );
  uvm_reg_block         ral_file;
  uvm_reg               ral_reg;
  uvm_status_e          status;
  slu_ral_sai_t         legal_sai;
  string                field_names[$];
  uvm_reg_data_t        field_vals[$];

  //--------------------
  //--08122022   ral_file = ral.find_file({cfg.tb_env_hier, ".", file_name});
  $cast(ral_file, uvm_reg_block::find_block({cfg.tb_env_hier,".",file_name}, ral));
  if (ral_file == null) begin
    `uvm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end 

  //--------------------
  //--08122022   ral_reg = ral_file.find_reg(reg_name);
  $cast(ral_reg, uvm_reg::m_get_reg_by_full_name({ral_file.get_full_name(), reg_name}));
  if (ral_reg == null) begin
    `uvm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end 

  //--------------------
  //--08122022   legal_sai     = ral_reg.pick_legal_sai_value(RAL_WRITE);

  field_names.delete();
  field_vals.delete();

  field_name = field_name.toupper();
  field_names.push_back(field_name);
  field_vals.push_back(wr_data);

  //--08122022   ral_reg.write_fields(status,field_names,field_vals,cfg.access_path,this,.sai(legal_sai));
  slu_ral_db::write_fields(ral_reg, field_names, status, field_vals, cfg.access_path);
endtask : WriteField

//--------------------------------------------------------------------
//--------------------------------------------------------------------
task hqm_pcie_nonfatal_err_seq::ReadReg( string                     file_name,
                                string                     reg_name,
                                boolean_t                  exp_error,
                                output     uvm_reg_data_t  rd_data
                              );
  uvm_reg_block         ral_file;
  uvm_reg               ral_reg;
  uvm_status_e          status;
  slu_ral_sai_t         legal_sai;

  //--------------------
  //--08122022   ral_file = ral.find_file({cfg.tb_env_hier, ".", file_name});
  $cast(ral_file, uvm_reg_block::find_block({cfg.tb_env_hier,".",file_name}, ral));
  if (ral_file == null) begin
    `uvm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end 

  //--------------------
  //--08122022   ral_reg = ral_file.find_reg(reg_name);
  $cast(ral_reg, uvm_reg::m_get_reg_by_full_name({ral_file.get_full_name(), reg_name}));
  if (ral_reg == null) begin
    `uvm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end 

  //--------------------
  //--08122022   legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);
  //--08122022   ral_reg.read(status,rd_data,cfg.access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));
  ral_reg.read(status, rd_data, cfg.access_path, .parent(this));
  //--08122022   rd_data = rd_data & ral_reg.get_read_mask(); //masked to adjust rd_data if its 16 bit or 32 bit

endtask : ReadReg

//--------------------------------------------------------------------
//--------------------------------------------------------------------
task hqm_pcie_nonfatal_err_seq::ReadField( string                   file_name,
                                  string                   reg_name,
                                  string                   field_name,
                                  boolean_t                exp_error,
                                  output   uvm_reg_data_t  rd_data
                                );
  uvm_reg_block         ral_file;
  uvm_reg               ral_reg;
  uvm_reg_field         ral_field;
  uvm_status_e          status;
  slu_ral_sai_t         legal_sai;
  uvm_reg_data_t        reg_val;

  //--------------------
  //--08122022   ral_file = ral.find_file({cfg.tb_env_hier, ".", file_name});
  $cast(ral_file, uvm_reg_block::find_block({cfg.tb_env_hier,".",file_name}, ral));
  if (ral_file == null) begin
    `uvm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end 

  //--------------------
  //--08122022   ral_reg = ral_file.find_reg(reg_name);
  $cast(ral_reg, uvm_reg::m_get_reg_by_full_name({ral_file.get_full_name(), reg_name}));
  if (ral_reg == null) begin
    `uvm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end 

  //--------------------
  field_name = field_name.toupper();
  //--08122022   ral_field = ral_reg.find_field(field_name);
  ral_field = uvm_reg_field::m_get_field_by_full_name({ral_reg.get_full_name(), ".field_name"});
  if (ral_field == null) begin
    `uvm_error(get_full_name(),{"unable to get handle to RAL field ",field_name})
    return;
  end 

  //--------------------
  //--08122022   legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);
  //--08122022   ral_reg.read(status,reg_val,cfg.access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));
  //--08122022   rd_data = ral_field.get_val(reg_val);
  ral_reg.read(status, reg_val, cfg.access_path, .parent(this));
  rd_data = slu_ral_db::fields.get_cfg_val(ral_field);
endtask : ReadField


