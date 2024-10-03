// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2019) (2019) Intel Corporation All Rights Reserved. 
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

`ifdef IP_OVM_STIM
`include "stim_config_macros.svh"
`endif

class hqm_eot_status_w_override_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hqm_eot_status_w_override_seq_stim_config";

  `uvm_object_utils_begin(hqm_eot_status_w_override_seq_stim_config)
    `uvm_field_string(tb_env_hier,              UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(inst_suffix,              UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(access_path,              UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(eot_file_plusarg,         UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(eot_override_file_plusarg,UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_string(eot_override_q,     UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(do_eot_rd_seq,               UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hqm_eot_status_w_override_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(eot_file_plusarg)
    `stimulus_config_field_string(eot_override_file_plusarg)
    `stimulus_config_field_queue_string(eot_override_q)
    `stimulus_config_field_rand_int(do_eot_rd_seq)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier                     = "*";
  string                        inst_suffix                     = "";
  string                        access_path                     = "iosf_pri";

  string                        eot_file_plusarg                = "HQM_EOT_STATUS_W_OVERRIDE_FILE";
  string                        eot_override_file_plusarg       = "HQM_EOT_STATUS_W_OVERRIDE_OVERRIDE_FILE";
  string                        eot_override_q[$]  = {};

  rand  bit                     do_eot_rd_seq;

  constraint c_do_eot_rd_seq_soft {
    soft do_eot_rd_seq       == 1'b1;
  }

  function new(string name = "hqm_eot_status_w_override_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_eot_status_w_override_seq_stim_config

class hqm_eot_status_w_override_seq extends slu_sequence_base;

  `uvm_object_utils(hqm_eot_status_w_override_seq) 

  `uvm_declare_p_sequencer(slu_sequencer)

  string      inst_suffix = "";

  rand hqm_eot_status_w_override_seq_stim_config        cfg;

  hqm_eot_rd_seq        i_hqm_eot_rd_seq;

  uvm_reg_block         ral;

  string                eot_cmd_list[$] = {
                                            "rd hqm_system_csr.hcw_enq_fifo_status           0x00000030",
                                            "rd hqm_system_csr.hcw_sch_fifo_status           0x00000010",
                                            "rd hqm_system_csr.sch_out_fifo_status           0x00000010",
                                            "rd hqm_system_csr.cfg_rx_fifo_status            0x00000010",
                                            "rd hqm_system_csr.cwdi_rx_fifo_status           0x00000010",
                                            "rd hqm_system_csr.hqm_alarm_rx_fifo_status      0x00000010",
                                            "rd hqm_system_csr.iosf_alarm_fifo_status        0x00000030",
                                            "rd hqm_iosf_csr.ibcpl_hdr_fifo_status           0x00000010",
                                            "rd hqm_iosf_csr.ibcpl_data_fifo_status          0x00000010",
                                            "rd hqm_iosf_csr.iosf_db_status                  0x00000004      # ready bit set",
                                            "rd hqm_system_csr.alarm_db_status               0x00000000",
                                            "rd hqm_system_csr.ingress_db_status             0x00000004      # ready bit set",
                                            "rd hqm_system_csr.egress_db_status              0x00000040      # ready bit set",
                                            "rd hqm_system_csr.alarm_status                  0x00000000",
                                            "rd hqm_system_csr.ingress_status                0x00000000",
                                            "rd hqm_system_csr.alarm_lut_perr                0x00000000",
                                            "rd hqm_system_csr.egress_lut_err                0x00000000",
                                            "rd hqm_system_csr.ingress_lut_err               0x00000000",
                                            "rd hqm_system_csr.alarm_err                     0x00000000",
                                            "rd hqm_system_csr.alarm_sb_ecc_err              0x00000000",
                                            "rd hqm_system_csr.alarm_mb_ecc_err              0x00000000",

                                            "rd hqm_iosf_csr.iosf_alarm_err                  0x00000000",
                                            "rd hqm_iosf_csr.ri_parity_err                   0x00000000",
                                            "rd hqm_iosf_csr.iosf_parity_err                 0x00000000",
                                            "rd hqm_iosf_csr.devtlb_ats_err                  0x00000000",
                                            "rd hqm_iosf_csr.ibcpl_err                       0x00000000",

                                            "rd hqm_system_csr.alarm_hw_synd                 0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_pf_synd0                0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[0]             0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[1]             0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[2]             0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[3]             0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[4]             0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[5]             0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[6]             0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[7]             0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[8]             0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[9]             0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[10]            0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[11]            0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[12]            0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[13]            0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[14]            0x00000000 0x80000000",
                                            "rd hqm_system_csr.alarm_vf_synd0[15]            0x00000000 0x80000000"
                                          };

  typedef struct {
    bit [31:0]          exp_val1;
    bit [31:0]          exp_val2;
    bit [31:0]          exp_mask;
  } reg_check_t;

  typedef struct {
    reg_check_t       reg_check;
    reg_check_t       reg_override[$];
  } reg_check_override_t;

  reg_check_override_t        reg_check_list[string];

`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_eot_status_w_override_seq_stim_config);
`endif

  function new(string name = "hqm_eot_status_w_override_seq");
    super.new(name);

    cfg = hqm_eot_status_w_override_seq_stim_config::type_id::create("hqm_eot_status_w_override_seq_stim_config");
`ifdef IP_OVM_STIM
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif

  endfunction

  task get_reg_val(string reg_name, output uvm_reg_data_t rdata);
    string              explode_q[$];
    string              reg_field_q[$];
    string              file_name;
    uvm_reg_block       ral_file;
    uvm_reg             ral_reg;
    uvm_status_e        status;

    rdata = '0;

    explode_q.delete();

    lvm_common_pkg::explode(".",reg_name,explode_q,2);

    if (explode_q.size() < 2) begin
      `uvm_error("HQM_TB_EOT_STATUS_SEQ",$psprintf("Illegal register identifier - %s",reg_name))
      return;
    end else begin
      //-----------
      //--08122022   `slu_assert($cast(ral_file,ral.find_file({cfg.tb_env_hier,".",explode_q[0]})),($psprintf("cast error trying to get handle to file %s.",explode_q[0])))
      `slu_assert($cast(ral_file, uvm_reg_block::find_block({cfg.tb_env_hier,".",explode_q[0]}, ral)), ($psprintf("cast error trying to get handle to file %s.",explode_q[0])))

      if (ral_file == null) begin
        `uvm_error("HQM_RAL_FILE_SEQ",$psprintf("Unable to get handle to file - %s",explode_q[0]))
        return;
      end 

      //-----------
      //--08122022  `slu_assert($cast(ral_reg,ral_file.find_reg(explode_q[1])),($psprintf("cast error trying to get handle to register %s.",explode_q[1])))
      `slu_assert($cast(ral_reg, uvm_reg::m_get_reg_by_full_name({ral_file.get_full_name(), ".explode_q[1]"})),($psprintf("cast error trying to get handle to register %s.",explode_q[1])))

      if (ral_reg == null) begin
        `uvm_error("HQM_RAL_FILE_SEQ",$psprintf("Unable to get handle to register - %s",reg_field_q[0]))
        return;
      end 

      //--08122022  ral_reg.read(status,rdata,cfg.access_path,this,.sai(ral_reg.pick_legal_sai_value(RAL_READ)));
      ral_reg.read(status, rdata, cfg.access_path, .parent(this));
      uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("HQM_TB_EOT_STATUS_Check - get_reg_val reg_name=%0s rdata=0x%0x", reg_name, rdata), UVM_LOW); 
    end 
  endtask

  function bit parse_reg_entry(string line, output string reg_name, output bit [31:0] exp_val1, output bit [31:0] exp_val2, output bit [31:0] exp_mask);
    string      cmd;
    string      arg;
    string      explode_q[$];

    lvm_common_pkg::ltrim_string(line);
    lvm_common_pkg::rtrim_string(line);

    if (line != "") begin
      cmd           = lvm_common_pkg::parse_token(line);

      if (cmd != "rd") begin
        `uvm_error("HQM_TB EOT Status SEQ",$psprintf("Unexpected command %s specified",cmd))
        return(1);
      end 

      reg_name      = lvm_common_pkg::parse_token(line);

      if (line == "") begin
        `uvm_error("HQM_TB EOT Status SEQ",$psprintf("Expected value for register %s not specified",reg_name))
        return(1);
      end else begin
        arg         = lvm_common_pkg::parse_token(line);
    
        explode_q.delete();

        lvm_common_pkg::explode("-",arg,explode_q);

        if (!lvm_common_pkg::token_to_int(explode_q[0], exp_val1)) begin
          `uvm_error("HQM_TB EOT Status SEQ",$psprintf("Expected value 1 for register %s is illegal - %s",reg_name,explode_q[0]))
          return(1);
        end 

        if (explode_q.size() > 1) begin
          if (!lvm_common_pkg::token_to_int(explode_q[1], exp_val2)) begin
            `uvm_error("HQM_TB EOT Status SEQ",$psprintf("Expected value 2 for register %s is illegal - %s",reg_name,explode_q[1]))
            return(1);
          end 
        end else begin
          exp_val2 = exp_val1;
        end 

        if (line == "") begin
          exp_mask = '1;
        end else begin
          arg     = lvm_common_pkg::parse_token(line);

          if (!lvm_common_pkg::token_to_int(arg, exp_mask)) begin
            `uvm_error("HQM_TB EOT Status SEQ",$psprintf("Expected value mask for register %s is illegal - %s",reg_name,arg))
            return(1);
          end 
        end 
      end 

      return(0);
    end 

    return(1);
  endfunction

  virtual task body();
    integer             eot_file_pointer;
    string              eot_file_name = "";
    integer             eot_override_file_pointer;
    string              eot_override_file_name = "";
    string              line;
    string              reg_name;
    int                 exp_val1;
    int                 exp_val2;
    int                 exp_mask;
    uvm_reg_data_t      rd_val;
    bit [31:0]          reg_val;
    bit                 check_ok;
    reg_check_t         reg_check;

`ifdef IP_OVM_STIM
    apply_stim_config_overrides(1);
`endif

    //--08122022  `slu_assert($cast(ral,sla_ral_env::get_ptr()),("Unable to get handle to RAL."))
    $cast(ral, slu_ral_db::get_regmodel());
    if (ral == null) begin
      uvm_report_fatal("HQM_TB EOT Status SEQ", "Unable to get RAL handle");
    end    


    uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("Start hqm_eot_status_w_override_seq ... inst_suffix=%0s", inst_suffix), UVM_LOW);

    //--------------------------------------------
    //--------------------------------------------
    if ($value$plusargs({cfg.eot_file_plusarg,"=%s"}, eot_file_name)) begin
      uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("HQM_TB_EOT_STATUS_FILE - %s",eot_file_name), UVM_LOW); 

      eot_file_pointer = $fopen(eot_file_name, "r");

      assert(eot_file_pointer != 0) else                                                           
        uvm_report_fatal(get_full_name(), $psprintf("Failed to open %s", eot_file_name));
    
      while($fgets(line, eot_file_pointer)) begin
        uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("FILE COMMAND -> %s", line), UVM_LOW);

        eot_cmd_list.push_back(line);
      end 
    end 

    uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("eot_cmd_list.size=%0d", eot_cmd_list.size()), UVM_LOW);

    //--------------------------------------------
    //--------------------------------------------
    foreach (eot_cmd_list[i]) begin
      if (parse_reg_entry(eot_cmd_list[i], reg_name, reg_check.exp_val1, reg_check.exp_val2, reg_check.exp_mask) == 0) begin
        if (reg_check_list.exists(reg_name)) begin
          `uvm_error("HQM_TB EOT Status SEQ",$psprintf("Register %s already specified",reg_name))
        end else begin
          reg_check_list[reg_name].reg_check = reg_check;
        end 
      end 
    end 

    //--------------------------------------------
    //--------------------------------------------
    if ($value$plusargs({cfg.eot_override_file_plusarg,"=%s"}, eot_override_file_name)) begin
      uvm_report_info("HQM_TB EOT Override SEQ", $psprintf("HQM_TB_EOT_OVERRIDE_FILE - %s",eot_override_file_name), UVM_LOW); 

      eot_override_file_pointer = $fopen(eot_override_file_name, "r");

      assert(eot_override_file_pointer != 0) else                                                           
        uvm_report_fatal(get_full_name(), $psprintf("Failed to open %s", eot_override_file_name));
    
      while($fgets(line, eot_override_file_pointer)) begin
        uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("FILE COMMAND -> %s", line), UVM_LOW);

        if (parse_reg_entry(line, reg_name, reg_check.exp_val1, reg_check.exp_val2, reg_check.exp_mask) == 0) begin
          if (reg_check_list.exists(reg_name)) begin
            reg_check_list[reg_name].reg_override.push_back(reg_check);
          end else begin
            reg_check_list[reg_name].reg_check = reg_check;
            reg_check_list[reg_name].reg_override.push_back(reg_check);
          end 
        end 
      end 
    end 

    //--------------------------------------------
    //--------------------------------------------
    foreach (cfg.eot_override_q[qi]) begin
      string          explode_q[$];

      for (int i = 0 ; i < cfg.eot_override_q[qi].len() ; i++) begin
        if ((cfg.eot_override_q[qi][i] == "=") || (cfg.eot_override_q[qi][i] == "/")) begin
          cfg.eot_override_q[qi][i] = " ";
        end 
      end 

      uvm_report_info("HQM_TB EOT Override SEQ", $psprintf("HQM_TB_EOT_OVERRIDE - %s",cfg.eot_override_q[qi]), UVM_LOW); 

      explode_q.delete();

      lvm_common_pkg::explode(":",cfg.eot_override_q[qi],explode_q);
    
      while(explode_q.size() > 0) begin
        line          = explode_q.pop_front();

        uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("OVERRIDE COMMAND -> %s", line), UVM_LOW);

        if (parse_reg_entry({"rd ",line}, reg_name, reg_check.exp_val1, reg_check.exp_val2, reg_check.exp_mask) == 0) begin
          if (reg_check_list.exists(reg_name)) begin
            reg_check_list[reg_name].reg_override.push_back(reg_check);
          end else begin
            reg_check_list[reg_name].reg_check = reg_check;
            reg_check_list[reg_name].reg_override.push_back(reg_check);
          end 
        end 
      end 
    end 

    //--------------------------------------------
    //--------------------------------------------
    uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("reg_check_list.size=%0d", reg_check_list.size()), UVM_LOW);
    foreach (reg_check_list[reg_name]) begin
      get_reg_val(reg_name,rd_val);

      reg_val = rd_val;

      if (reg_check_list[reg_name].reg_override.size() == 0) begin
        if ((reg_val & reg_check_list[reg_name].reg_check.exp_mask) >= (reg_check_list[reg_name].reg_check.exp_val1 & reg_check_list[reg_name].reg_check.exp_mask) &&
            (reg_val & reg_check_list[reg_name].reg_check.exp_mask) <= (reg_check_list[reg_name].reg_check.exp_val2 & reg_check_list[reg_name].reg_check.exp_mask)) begin
          `uvm_info("HQM_TB EOT Status SEQ",$psprintf("Value for register %s = 0x%0x matches expected value = 0x%0x-0x%0x (mask=0x%0x)",
                                                      reg_name,
                                                      reg_val,
                                                      reg_check_list[reg_name].reg_check.exp_val1,
                                                      reg_check_list[reg_name].reg_check.exp_val2,
                                                      reg_check_list[reg_name].reg_check.exp_mask),UVM_LOW)
        end else begin
          `uvm_error("HQM_TB EOT Status SEQ",$psprintf("Value for register %s = 0x%0x does not match expected value = 0x%0x-0x%0x (mask=0x%0x)",
                                                       reg_name,
                                                       reg_val,
                                                       reg_check_list[reg_name].reg_check.exp_val1,
                                                       reg_check_list[reg_name].reg_check.exp_val2,
                                                       reg_check_list[reg_name].reg_check.exp_mask))
        end 
      end else begin
        check_ok = 1'b0;

        foreach (reg_check_list[reg_name].reg_override[i]) begin
          if ((reg_val & reg_check_list[reg_name].reg_override[i].exp_mask) >= (reg_check_list[reg_name].reg_override[i].exp_val1 & reg_check_list[reg_name].reg_override[i].exp_mask) &&
              (reg_val & reg_check_list[reg_name].reg_override[i].exp_mask) <= (reg_check_list[reg_name].reg_override[i].exp_val2 & reg_check_list[reg_name].reg_override[i].exp_mask)) begin
            `uvm_info("HQM_TB EOT Status SEQ",$psprintf("Value for register %s = 0x%0x matches expected value override = 0x%0x-0x%0x (mask=0x%0x)",
                                                        reg_name,
                                                        reg_val,
                                                        reg_check_list[reg_name].reg_override[i].exp_val1,
                                                        reg_check_list[reg_name].reg_override[i].exp_val1,
                                                        reg_check_list[reg_name].reg_override[i].exp_mask),UVM_LOW)
            check_ok = 1'b1;
            break;
          end 
        end 

        if (!check_ok) begin
          `uvm_error("HQM_TB EOT Status SEQ",$psprintf("Value for register %s = 0x%0x does not match expected value overrides",reg_name,reg_val))
        end 
      end 
    end 
  endtask

endclass
