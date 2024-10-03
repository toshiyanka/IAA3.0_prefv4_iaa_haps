
class hqm_sla_tb_ral_env extends sla_ral_env;

    `ovm_component_utils_begin(hqm_sla_tb_ral_env)
    `ovm_component_utils_end
    string primary_paths[$];
    string sideband_paths[$];

    function new(string name = "hqm_sla_tb_ral_env", ovm_component parent = null, string hdl_path = "");

        super.new(name, parent, hdl_path);

        `ovm_info(name, "hqm_sla_tb_ral_env new() complete", OVM_LOW);

    endfunction  : new

    function void build();

      super.build();

    endfunction : build


 function void end_of_elaboration();


    super.end_of_elaboration();

    if (_level == SLA_TOP) begin
      //set_frontdoor_seq_type("primary", "read",  "hqm_iosf_prim_access_seq");
      //set_frontdoor_seq_type("primary", "write", "hqm_iosf_prim_access_seq");
      //set_frontdoor_seq_type("sideband", "read",  "hqm_iosf_sb_access_seq");
      //set_frontdoor_seq_type("sideband", "write", "hqm_iosf_sb_access_seq");
      // SIDEBAND
      //set_frontdoor_seq_type("IOSFSB", "read", "iosf_sb_read_seq");
      //set_frontdoor_seq_type("IOSFSB", "write", "iosf_sb_write_seq"); 
      set_frontdoor_seq_type(iosf_sb_sla_pkg::get_src_type(), "read", "iosf_sb_read_seq", sla_iosf_sb_reg_transaction_sequencer::instance());
      set_frontdoor_seq_type(iosf_sb_sla_pkg::get_src_type(), "write", "iosf_sb_write_seq", sla_iosf_sb_reg_transaction_sequencer::instance());
      // Primary      
      set_frontdoor_seq_type(sla_iosf_pri_reg_lib_pkg::get_src_type(), "read", "sla_iosf_pri_reg_rd", sla_iosf_pri_reg_transaction_sequencer::instance());
      set_frontdoor_seq_type(sla_iosf_pri_reg_lib_pkg::get_src_type(), "write", "sla_iosf_pri_reg_wr", sla_iosf_pri_reg_transaction_sequencer::instance());
      set_frontdoor_alias("IOSFSB", "read", iosf_sb_sla_pkg::get_src_type());
      set_frontdoor_alias("IOSFSB", "write", iosf_sb_sla_pkg::get_src_type());
      set_frontdoor_alias("sideband", "read", iosf_sb_sla_pkg::get_src_type());
      set_frontdoor_alias("sideband", "write", iosf_sb_sla_pkg::get_src_type());       
      set_frontdoor_alias("primary", "read", sla_iosf_pri_reg_lib_pkg::get_src_type());
      set_frontdoor_alias("primary", "write", sla_iosf_pri_reg_lib_pkg::get_src_type());
      primary_paths.push_back(sla_iosf_pri_reg_lib_pkg::get_src_type());
      primary_paths.push_back("pcie");
      sideband_paths.push_back(iosf_sb_sla_pkg::get_src_type());
      sideband_paths.push_back("iosf_sideband");
      set_config_string("*","primary_id",sla_iosf_pri_reg_lib_pkg::get_src_type());

   end
 endfunction  
 
  virtual function sla_ral_addr_t get_addr_val(sla_ral_access_path_t access_path, sla_ral_reg r);
    `ovm_info("HQM_SLA_TB_RAL_ENV", $sformatf("HQM_RAL_ENV: get_addr_val access_path %s ",access_path),OVM_LOW);
    if (access_path inside {primary_paths} ) begin
        case (r.get_space())
          "CFG": begin
            //`ovm_info("HQM_SLA_TB_RAL_ENV", $psprintf("CFG Space: access path: %s for register: %s; with r.addr=0x%0x, func_num=%0d, dev_num=%0d, bus_num=%0d, addr=0x%0x", access_path,r.get_name(), (r.get_space_addr("CFG")), r.get_func_num(), r.get_dev_num(), r.get_bus_num(),  (r.get_space_addr("CFG") | (r.get_func_num() <<16) | (r.get_dev_num() <<19) | (r.get_bus_num() <<24))), OVM_LOW)
            `ovm_info("HQM_SLA_TB_RAL_ENV", $psprintf("CFG Space: access path: %s for register: %s; with r.addr=0x%0x, func_num=%0d, dev_num=%0d, bus_num=%0d, addr=0x%0x", access_path,r.get_name(), (r.get_space_addr("CFG")), r.get_func_num(), r.get_dev_num(), r.get_bus_num(),  (r.get_space_addr("CFG") | (r.get_func_num() <<16) | (r.get_dev_num() <<19) | (r.get_bus_num() <<24))), OVM_HIGH)
            return (r.get_space_addr("CFG") | (r.get_func_num() << 16) | (r.get_dev_num() << 19) | (r.get_bus_num() << 24));
          end
          "MEM": begin
            `ovm_info("HQM_SLA_TB_RAL_ENV", $psprintf("MEM Space: access path: %s for register: %s; with r.addr=0x%0x, addr=0x%0x", access_path,r.get_name(), (r.get_space_addr("MEM")),  (r.get_base_addr_val("MEM") + r.get_space_addr("MEM"))), OVM_HIGH)
            return(r.get_base_addr_val("MEM") + r.get_space_addr("MEM"));
          end
          default: begin
            return(0);
          end
        endcase
    end else if (access_path inside {sideband_paths}) begin
        case (r.get_space())
          "CFG": begin
            return (r.get_space_addr("CFG"));
          end
          "MEM": begin
            return(r.get_space_addr("MEM-SB"));
          end
          "MSG": begin
            return(r.get_space_addr("MSG"));
          end
          default: begin
            return(0);
          end
        endcase
    end

  endfunction

  function string get_log2phy_path(string logic_path, string filename, string unique_filename);

    `ovm_info("HQM_SLA_TB_RAL_ENV", $sformatf("logic_path %s  filename %s  unique %s ",logic_path, filename, unique_filename),OVM_HIGH);

    case (logic_path)

      "HQMID":
       begin
         case (filename)
           "hqm_pf_cfg_i"               : return `HQM_SIF_PATH_STR;
           "hqm_sif_csr"                : return `HQM_SIF_PATH_STR;
           "hqm_system_csr"             : return `HQM_SYSTEM_PATH_STR;
           "hqm_msix_mem"               : return `HQM_SYSTEM_PATH_STR;
           "aqed_pipe"                  : return `HQM_AQED_PIPE_PATH_STR;
           "atm_pipe"                   : return `HQM_ATM_PIPE_PATH_STR;
           "credit_hist_pipe"           : return `HQM_CREDIT_HIST_PIPE_PATH_STR;
           "config_master"              : return `HQM_MASTER_PATH_STR;
           "list_sel_pipe"              : return `HQM_LIST_SEL_PIPE_PATH_STR;
           "nalb_pipe"                  : return `HQM_NALB_PIPE_PATH_STR;
           "direct_pipe"                : return `HQM_DIR_PIPE_PATH_STR;
           "qed_pipe"                   : return `HQM_QED_PIPE_PATH_STR;
           "reorder_pipe"               : return `HQM_REORDER_PIPE_PATH_STR;
           default                      : `ovm_fatal("HQM_SLA_TB_RAL_ENV", $sformatf("Unexpected HQM filename = %s", filename))
         endcase
       end          

      "HQMIDMEM":
       begin
         case (filename)
           "hqm_pf_cfg_i"               : return `HQM_PATH_STR;
           "hqm_sif_csr"                : return `HQM_PATH_STR;
           "hqm_system_csr"             : return `HQM_PATH_STR;
           "hqm_msix_mem"               : return `HQM_PATH_STR;
           "aqed_pipe"                  : return `HQM_PATH_STR;
           "atm_pipe"                   : return `HQM_PATH_STR;
           "credit_hist_pipe"           : return `HQM_PATH_STR;
           "config_master"              : return `HQM_PATH_STR;
           "list_sel_pipe"              : return `HQM_PATH_STR;
           "nalb_pipe"                  : return `HQM_PATH_STR;
           "direct_pipe"                : return `HQM_PATH_STR;
           "qed_pipe"                   : return `HQM_PATH_STR;
           "reorder_pipe"               : return `HQM_PATH_STR;
           default                      : `ovm_fatal("HQM_SLA_TB_RAL_ENV", $sformatf("Unexpected HQM filename = %s", filename))
         endcase
       end          

    endcase

    // Not matched!

    `ovm_info("HQM_SLA_TB_RAL_ENV", $sformatf("HQM_RAL_ENV: UNRECOGNIZED logic_path %s  filename %s  unique %s ",logic_path, filename, unique_filename),OVM_LOW);

    `ovm_fatal("HQM_SLA_TB_RAL_ENV", "Logical path not found")
    return "Logical path not found";

  endfunction : get_log2phy_path


endclass

