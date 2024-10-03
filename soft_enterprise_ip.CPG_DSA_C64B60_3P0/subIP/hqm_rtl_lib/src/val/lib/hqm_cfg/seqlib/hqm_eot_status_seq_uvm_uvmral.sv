
class hqm_eot_status_seq extends slu_sequence_base;

  `uvm_object_utils(hqm_eot_status_seq) 

  `uvm_declare_p_sequencer(slu_sequencer)

  rand bit              err_if_no_file;

  constraint c_err_if_no_file {
    soft        err_if_no_file  == 1'b0;
  };

  string        inst_suffix = "";

  uvm_reg_block                 ral;
  hqm_cfg                       i_hqm_cfg;

  string              eot_file_plusarg;
  string              eot_override_file_plusarg;
  string              eot_override_plusarg;
  slu_tb_env          loc_tb_env;
  sla_phase_name_t    curr_phase;

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

  function new(string name = "hqm_eot_status_seq");
    super.new(name);
    loc_tb_env                       = slu_tb_env::get_top_tb_env();
    curr_phase                       = loc_tb_env.get_current_test_phase();
    this.eot_file_plusarg            = "HQM_TB_EOT_STATUS_FILE";
    this.eot_override_file_plusarg   = "HQM_TB_EOT_OVERRIDE_FILE";
    this.eot_override_plusarg        = "HQM_TB_EOT_OVERRIDE";
  endfunction

  function set_cfg(string eot_file_plusarg, string eot_override_file_plusarg, string eot_override_plusarg, bit err_if_no_file = 1'b0);
    this.eot_file_plusarg            = eot_file_plusarg;
    this.eot_override_file_plusarg   = eot_override_file_plusarg;
    this.eot_override_plusarg        = eot_override_plusarg;
    this.err_if_no_file              = err_if_no_file;
  endfunction

  task get_reg_val(string reg_name, output uvm_reg_data_t rdata);
    string              explode_q[$];
    string              reg_field_q[$];
    string              file_name;
    uvm_reg_block       ral_file;
    uvm_reg             ral_reg;
    uvm_status_e        status;
    string              primary_id;

    rdata = '0;

    explode_q.delete();

    lvm_common_pkg::explode(".",reg_name,explode_q,2);

    if (explode_q.size() < 2) begin
      `uvm_error("HQM_TB_EOT_STATUS_SEQ",$psprintf("Illegal register identifier - %s",reg_name))
      return;
    end else begin
      //--ral_file
      //--08122022 `slu_assert($cast(ral_file,ral.find_file(explode_q[0])),($psprintf("cast error trying to get handle to file %s.",explode_q[0])))
      `slu_assert($cast(ral_file, uvm_reg_block::find_block("explode_q[0]", ral)), ($psprintf("cast error trying to get handle to file %s.",explode_q[0])))

      if (ral_file == null) begin
        `uvm_error("HQM_RAL_FILE_SEQ",$psprintf("Unable to get handle to file - %s",explode_q[0]))
        return;
      end 

      //--ral_reg
      //--08122022 `slu_assert($cast(ral_reg,ral_file.find_reg(explode_q[1])),($psprintf("cast error trying to get handle to register %s.",explode_q[1])))
      `slu_assert($cast(ral_reg, uvm_reg::m_get_reg_by_full_name({ral_file.get_full_name(), ".explode_q[1]"})),($psprintf("cast error trying to get handle to register %s.",explode_q[1])))

      if (ral_reg == null) begin
        `uvm_error("HQM_RAL_FILE_SEQ",$psprintf("Unable to get handle to register - %s",reg_field_q[0]))
        return;
      end 

      primary_id = i_hqm_cfg.ral_access_path;
      uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("get_reg_val - flie %s reg %s path %s and issue register read", explode_q[0], explode_q[1], primary_id), UVM_MEDIUM); 
      //--08122022   ral_reg.read(status,rdata,primary_id,this,.sai(ral_reg.pick_legal_sai_value(RAL_READ)));
      ral_reg.read(status, rdata, primary_id, .parent(this));
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
    string              eot_override = "";
    string              line;
    string              reg_name;
    string              arg;
    int                 exp_val1;
    int                 exp_val2;
    int                 exp_mask;
    bit                 file_mode_exists;
    uvm_reg_data_t      rd_val;
    bit [31:0]          reg_val;
    bit                 check_ok;
    uvm_object o_tmp;

    `slu_assert($cast(ral, slu_ral_db::get_regmodel()), ("Unable to get handle to RAL."))

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hqm_cfg",inst_suffix}, o_tmp)) begin
      uvm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    end 

    if (!$cast(i_hqm_cfg, o_tmp)) begin
      uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
    end    


    if ($value$plusargs({eot_file_plusarg,"=%s"}, eot_file_name)) begin
      file_mode_exists = 1;  
    end else begin
      file_mode_exists = 0;  
      if (err_if_no_file) begin
        `uvm_error("HQM_TB EOT Status SEQ","file_name not set")
      end 
    end 

    if (file_mode_exists) begin  
      bit               do_cfg_seq;
      hqm_cfg_seq       cfg_seq;
      reg_check_t       reg_check;

      uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("HQM_TB_EOT_STATUS_FILE - %s",eot_file_name), UVM_MEDIUM); 

      eot_file_pointer = $fopen(eot_file_name, "r");

      assert(eot_file_pointer != 0) else                                                           
        uvm_report_fatal(get_full_name(), $psprintf("Failed to open %s", eot_file_name));
    
      while($fgets(line, eot_file_pointer)) begin
        uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("FILE COMMAND -> %s", line), UVM_DEBUG);

        if (parse_reg_entry(line, reg_name, reg_check.exp_val1, reg_check.exp_val2, reg_check.exp_mask) == 0) begin
          if (reg_check_list.exists(reg_name)) begin
            `uvm_error("HQM_TB EOT Status SEQ",$psprintf("Register %s already specified",reg_name))
          end else begin
            reg_check_list[reg_name].reg_check = reg_check;
          end 
        end 
      end 

      if ($value$plusargs({eot_override_file_plusarg,"=%s"}, eot_override_file_name)) begin
        uvm_report_info("HQM_TB EOT Override SEQ", $psprintf("HQM_TB_EOT_OVERRIDE_FILE - %s",eot_override_file_name), UVM_MEDIUM); 

        eot_override_file_pointer = $fopen(eot_override_file_name, "r");

        assert(eot_override_file_pointer != 0) else                                                           
          uvm_report_fatal(get_full_name(), $psprintf("Failed to open %s", eot_override_file_name));
      
        while($fgets(line, eot_override_file_pointer)) begin
          uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("FILE COMMAND -> %s", line), UVM_DEBUG);

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

      if ($value$plusargs({eot_override_plusarg,"=%s"}, eot_override)) begin
        string          explode_q[$];

        for (int i = 0 ; i < eot_override.len() ; i++) begin
          if ((eot_override[i] == "=") || (eot_override[i] == "/")) begin
            eot_override[i] = " ";
          end 
        end 

        uvm_report_info("HQM_TB EOT Override SEQ", $psprintf("HQM_TB_EOT_OVERRIDE - %s",eot_override), UVM_MEDIUM); 

        explode_q.delete();

        lvm_common_pkg::explode(":",eot_override,explode_q);
      
        while(explode_q.size() > 0) begin
          line          = explode_q.pop_front();

          uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("OVERRIDE COMMAND -> %s", line), UVM_DEBUG);

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
    end else begin
      uvm_report_info("HQM_TB EOT Status SEQ", $psprintf("To use File Mode specify file using +%s=<file_name>",eot_file_plusarg), UVM_MEDIUM);
    end 

    foreach (reg_check_list[reg_name]) begin
      get_reg_val(reg_name,rd_val);

      reg_val = rd_val;

      if (reg_check_list[reg_name].reg_override.size() == 0) begin
        if ((reg_val & reg_check_list[reg_name].reg_check.exp_mask) >= (reg_check_list[reg_name].reg_check.exp_val1 & reg_check_list[reg_name].reg_check.exp_mask) ||
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
          if ((reg_val & reg_check_list[reg_name].reg_override[i].exp_mask) >= (reg_check_list[reg_name].reg_override[i].exp_val1 & reg_check_list[reg_name].reg_override[i].exp_mask) ||
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
