class hqm_background_cfg_file_mode_seq extends sla_sequence_base;

  `ovm_sequence_utils(hqm_background_cfg_file_mode_seq, sla_sequencer)

  string        file_plusarg;
  bit           err_if_no_file;
  int           bg_cfg_num;
  sla_ral_env   ral;

  typedef enum {
    BG_RD,
    BG_WR,
    BG_WR_RAND
  } bg_acc_type_t;

  typedef struct {
    string              file_name;
    string              reg_name;
    string              field_name;
    bg_acc_type_t       bg_acc_type;
    sla_ral_reg         ral_reg;
    sla_ral_field       ral_field;
    bit [31:0]          wdata;
    bit                 wdata_valid;
  } bg_acc_entry_t;

  bg_acc_entry_t        bg_acc_q[$];

  sla_ral_access_path_t         primary_id, access;

  int                   bg_cfg_delay_min;
  int                   bg_cfg_delay_max;

  function new(string name = "hqm_background_cfg_file_mode_seq",
               string file_plusarg = "HQM_SEQ_BG_CFG",
               bit    err_if_no_file = 1'b0);
    super.new(name);

    this.file_plusarg           = file_plusarg;
    this.err_if_no_file         = err_if_no_file;
    primary_id                  = sla_iosf_pri_reg_lib_pkg::get_src_type();
  endfunction

  extern virtual task body();
  extern virtual task process_file();

endclass

task hqm_background_cfg_file_mode_seq::body();
  integer             file_pointer;
  string              file_name = "";
  string              line;
  bit                 file_mode_exists;
  bg_acc_entry_t      bg_acc_entry;
  string              token;
  string              explode_q[$];

  process_file();

  bg_cfg_num = 0;

  if (bg_acc_q.size() > 0) begin
    if ($value$plusargs({"HQM_BG_CFG_NUM","=%s"}, token)) begin
      if (!lvm_common_pkg::token_to_longint(token, bg_cfg_num)) begin
        bg_cfg_num = 0;
      end
    end
  end

  while (bg_cfg_num > 0) begin
    sla_status_t      status;
    int               entry_num;
    int               bg_cfg_delay;
    sla_ral_data_t    rdata;

    entry_num = $urandom_range(bg_acc_q.size()-1,0);

    if (bg_acc_q[entry_num].bg_acc_type == BG_RD) begin
      ovm_report_info("BG CFG SEQ", $psprintf("Background CFG read of register %s.%s",bg_acc_q[entry_num].file_name,bg_acc_q[entry_num].reg_name), OVM_LOW);

      bg_acc_q[entry_num].ral_reg.read(status,rdata,primary_id,this,.sai(1));
    end else if (bg_acc_q[entry_num].bg_acc_type == BG_WR) begin
      if (bg_acc_q[entry_num].wdata_valid) begin
        ovm_report_info("BG CFG SEQ", $psprintf("Background CFG write of register %s.%s - wdata = 0x%0x",bg_acc_q[entry_num].file_name,bg_acc_q[entry_num].reg_name,bg_acc_q[entry_num].wdata), OVM_LOW);

        bg_acc_q[entry_num].ral_reg.write(status,bg_acc_q[entry_num].wdata,primary_id,this,.sai(1));
      end else begin
        if($test$plusargs("hqm_cfg_bgwr_access_ena")) begin
            ovm_report_info("BG CFG SEQ", $psprintf("Background CFGENA write of register %s.%s - wdata = 0x%0x",bg_acc_q[entry_num].file_name,bg_acc_q[entry_num].reg_name,bg_acc_q[entry_num].wdata), OVM_LOW);
            bg_acc_q[entry_num].ral_reg.write(status,bg_acc_q[entry_num].wdata,primary_id,this,.sai(1));
        end else begin
            ovm_report_info("BG CFG SEQ", $psprintf("Background CFG read of register %s.%s",bg_acc_q[entry_num].file_name,bg_acc_q[entry_num].reg_name), OVM_LOW);

            bg_acc_q[entry_num].ral_reg.read(status,rdata,primary_id,this,.sai(1));
            bg_acc_q[entry_num].wdata       = rdata;
            bg_acc_q[entry_num].wdata_valid = 1'b1;
        end 
      end
    end else if (bg_acc_q[entry_num].bg_acc_type == BG_WR_RAND) begin
      std::randomize(bg_acc_q[entry_num].wdata);

      ovm_report_info("BG CFG SEQ", $psprintf("Background CFG write of register %s.%s - wdata = 0x%0x",bg_acc_q[entry_num].file_name,bg_acc_q[entry_num].reg_name,bg_acc_q[entry_num].wdata), OVM_LOW);

      bg_acc_q[entry_num].ral_reg.write(status,bg_acc_q[entry_num].wdata,primary_id,this,.sai(1));
    end

    bg_cfg_delay = $urandom_range(bg_cfg_delay_max,bg_cfg_delay_min);

    while (bg_cfg_delay > 0) begin
      #1ns;
      bg_cfg_delay--;
    end

    bg_cfg_num--;
  end
endtask

task hqm_background_cfg_file_mode_seq::process_file();
  integer             file_pointer;
  string              file_name = "";
  string              line;
  bit                 file_mode_exists;
  bg_acc_entry_t      bg_acc_entry;
  string              token;
  string              explode_q[$];

  if ($value$plusargs({file_plusarg,"=%s"}, file_name)) begin
    file_mode_exists = 1;  
  end else begin
    file_mode_exists = 0;  
    if (err_if_no_file) begin
      `ovm_error("BG CFG SEQ","file_name not set")
    end
  end

  if (file_mode_exists) begin  
    $cast(ral, sla_ral_env::get_ptr());
    if (ral == null) begin
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    if (ral.get_config_string("primary_id",access)) begin
      primary_id = access;
    end

    if ($value$plusargs({"HQM_BG_PRIMARY_ID","=%s"}, token)) begin
      primary_id = token;
    end

    bg_cfg_delay_min  = 10;

    if ($value$plusargs({"HQM_BG_CFG_DELAY_MIN","=%s"}, token)) begin
      if (!lvm_common_pkg::token_to_longint(token, bg_cfg_delay_min)) begin
        bg_cfg_delay_min = 0;
      end
    end

    bg_cfg_delay_max  = bg_cfg_delay_min;

    if ($value$plusargs({"HQM_BG_CFG_DELAY_MAX","=%s"}, token)) begin
      if (!lvm_common_pkg::token_to_longint(token, bg_cfg_delay_max)) begin
        bg_cfg_delay_max = 0;
      end
    end

    if ((bg_cfg_delay_min < 0) || (bg_cfg_delay_max < 0)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Illegal values - bg_cfg_delay_min=%d bg_cfg_delay_max=%d", bg_cfg_delay_min,bg_cfg_delay_max));
    end

    ovm_report_info("BG CFG SEQ", $psprintf("CFG File Mode - %s",file_name), OVM_LOW); 

    file_pointer = $fopen(file_name, "r");
    assert(file_pointer != 0) else                                                           
      ovm_report_fatal(get_full_name(), $psprintf("Failed to open %s", file_name));
    
    while($fgets(line, file_pointer)) begin
      ovm_report_info("BG CFG SEQ", $psprintf("FILE COMMAND -> %s", line), OVM_DEBUG);

      token = lvm_common_pkg::parse_token(line);

      token.tolower();

      bg_acc_entry.file_name          = "";
      bg_acc_entry.reg_name           = "";
      bg_acc_entry.field_name         = "";
      bg_acc_entry.bg_acc_type        = BG_RD;
      bg_acc_entry.ral_reg            = null;
      bg_acc_entry.ral_field          = null;
      bg_acc_entry.wdata              = 32'h0;
      bg_acc_entry.wdata_valid        = 1'b0;

      case (token)
        "bgrd": begin
          bg_acc_entry.bg_acc_type    = BG_RD;
        end
        "bgwr": begin
          bg_acc_entry.bg_acc_type    = BG_WR;
        end
        "bgwr_rand": begin
          bg_acc_entry.bg_acc_type    = BG_WR_RAND;
        end
        default: begin
          `ovm_error("BG CFG SEQ",$psprintf("Command %s not recognized (bgrd | bgwr)",token))
          return;
        end
      endcase

      token = lvm_common_pkg::parse_token(line);

      token.tolower();

      explode_q.delete();
      lvm_common_pkg::explode(".",token,explode_q,3);

      if (explode_q.size() == 2) begin        // file.reg
        bg_acc_entry.file_name        = explode_q[0];
        bg_acc_entry.reg_name         = explode_q[1];
      end else if (explode_q.size() == 3) begin
        bg_acc_entry.file_name        = explode_q[0];
        bg_acc_entry.reg_name         = explode_q[1];
        bg_acc_entry.field_name       = explode_q[1];
      end else begin
        `ovm_error("BG CFG SEQ",$psprintf("register/field specifier %s not legal)",token))
        return;
      end

      bg_acc_entry.ral_reg = ral.find_reg_by_file_name(bg_acc_entry.reg_name, bg_acc_entry.file_name);

      if (bg_acc_entry.ral_reg == null) begin
        `ovm_error("BG CFG SEQ",$psprintf("Unable to find register %s.%s)",bg_acc_entry.file_name,bg_acc_entry.reg_name))
      end else begin
        if (bg_acc_entry.field_name == "") begin
          bg_acc_q.push_back(bg_acc_entry);
        end else begin
          bg_acc_entry.ral_field = bg_acc_entry.ral_reg.find_field(bg_acc_entry.field_name);
          if (bg_acc_entry.ral_field == null) begin
            `ovm_error("BG CFG SEQ",$psprintf("Unable to find field %s.%s.%s)",bg_acc_entry.file_name,bg_acc_entry.reg_name,bg_acc_entry.field_name))
          end else begin
            bg_acc_q.push_back(bg_acc_entry);
          end
        end
      end
    end 
  end else begin
    ovm_report_info("BG CFG SEQ", $psprintf("To use File Mode specify file using +%s=<file_name>",file_plusarg), OVM_LOW);
  end
endtask
