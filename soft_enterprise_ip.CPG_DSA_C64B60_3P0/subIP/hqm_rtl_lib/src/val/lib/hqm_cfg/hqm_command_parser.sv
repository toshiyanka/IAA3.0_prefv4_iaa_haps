//-----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
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
//------------------------------------------------------------------------------
// File   : hqm_command_parser.sv
// Author : Mike Betker
//
// Description :
//
// This class is derived form ovm_object and it processes HQM commands
//------------------------------------------------------------------------------

class hqm_cfg_command_options extends ovm_object;

   string   option;
   longint  values[$];
   string   str_value;
   opt_randmization_type_t randmization_type;

   //------------------------- 
   // Function: new 
   // Class constructor
   //------------------------- 
   function new ();
     super.new();

     str_value = "";
     randmization_type = NONE;
     values.delete();
   endfunction : new

   function string get_str();
      string str;
      get_str = {option,"="};
      if (randmization_type == WILD_CARD_TYPE) begin
        get_str = {get_str, "*"};
      end else if (str_value == "") begin
        if (values.size() == 0) begin
          get_str = {get_str, "?"};
        end else if (values.size() == 1) begin
          get_str = {get_str, $psprintf("%0d", values.pop_front())};
        end else begin
          for (int i = 0 ; i < values.size() ; i++) begin
            if (i == 0) begin
              get_str = {get_str, "["};
            end

            get_str = {get_str, $psprintf("%0d", values[i])};

            if (i == (values.size() - 1)) begin
              get_str = {get_str, "]"};
            end else begin
              get_str = {get_str, ","};
            end
          end   
        end
      end else begin
        get_str = {get_str, str_value};
      end
   endfunction

endclass

class hqm_cfg_command extends ovm_object;

  hqm_cfg_command_type_t    c_type;
  hqm_cfg_command_target_t  target;
  string                    label;
  string                    label_value_str;
  longint                   label_value;
  hqm_cfg_command_options   options[$];

  function void set_type(hqm_cfg_command_type_t c_type);
     this.c_type = c_type;
  endfunction

  function hqm_cfg_command_type_t get_type();
     return this.c_type;
  endfunction

  function hqm_cfg_command_target_t get_target();
      return this.target;
  endfunction

  function void set_target(hqm_cfg_command_target_t target);
     this.target = target;
  endfunction

  function void add_option(hqm_cfg_command_options option);
     this.options.push_back(option);
  endfunction

  function string get_type_str();
     return c_type.name();
  endfunction

  function string get_target_str();
     return target;
  endfunction

  function string get_options_str();
     string str;
     str = "";
     foreach(this.options[i]) begin
        str = {str, " ",options[i].get_str()};
     end
     return str;
  endfunction

endclass

class hqm_cfg_command_parser extends ovm_object;

    protected   hqm_cfg_command         current_command;
    protected   hqm_cfg_command_state_t current_state;

    function  int get_command(string command, output hqm_cfg_command out_command);
    
        string          token;
        int             status;
    
        this.current_state = TYPE;
    
        status = 100;

        while(command != "") begin
           token = parse_token(command);

           if (token == "") begin
             break;
           end
           if (token[0] == "#") begin
             break;
           end

           token = token.tolower();

           case(current_state)
           TYPE    :
                begin
                   status = register_command_type(token);
                   if (!status) break;
                end
           LABEL:
                begin
                  status = register_command_label(token);
                  if (!status) break;
                end
           TARGET  :
                begin
                   status = register_command_target(token);
                   if (!status) break;
                end
           OPTIONS : 
                begin
                   status = register_command_options(token); 
                   if (!status) break;
                end
            endcase

        end
        
        out_command = this.current_command; 
        return status;

    endfunction
   
    function void print_command();
        string str;
        str = this.current_command.get_type_str();
        str = {str, " ", this.current_command.get_target_str()};
        str = {str, " ", this.current_command.get_options_str()};
        $display("%s", str);
    endfunction
 
    function bit register_command_type(string command_type);
        this.current_command = new();
        this.current_state = TARGET;
        case(command_type)
        "hcw"    : begin
                     this.current_command.set_type(HQM_HCW_ENQ);
                     this.current_state = LABEL;
                   end
        "hcws"    : begin
                     this.current_command.set_type(HQM_HCWS_ENQ);
                     this.current_state = LABEL;
                   end
        "ldb"    : this.current_command.set_type(HQM_CFG_LDB);
        "dir"    : this.current_command.set_type(HQM_CFG_DIR);
        "msix_cq": begin
                     this.current_command.set_type(HQM_CFG_MSIX_CQ);
                     this.current_state = LABEL;
                   end
        "msix_alarm": begin
                        this.current_command.set_type(HQM_CFG_MSIX_ALARM);
                        this.current_state = LABEL;
                      end
        "vas"    : begin
                     this.current_command.set_type(HQM_CFG_VAS);
                     this.current_state = LABEL;
                   end
        "vf"     : begin
                     this.current_command.set_type(HQM_CFG_VF);
                     this.current_state = LABEL;
                   end
        "vdev"     : begin
                     this.current_command.set_type(HQM_CFG_VDEV);
                     this.current_state = LABEL;
                   end
        "wr"     : this.current_command.set_type(HQM_CFG_WR_REG);
        "cwr"    : this.current_command.set_type(HQM_CFG_CWR_REG);
        "bwr"    : this.current_command.set_type(HQM_CFG_BWR_REG);
        "wre"    : this.current_command.set_type(HQM_CFG_WRE_REG);
        "owr"    : this.current_command.set_type(HQM_CFG_OWR_REG);
        "owre"   : this.current_command.set_type(HQM_CFG_OWRE_REG);
        "rd"     : this.current_command.set_type(HQM_CFG_RD_REG);
        "rde"    : this.current_command.set_type(HQM_CFG_RDE_REG);
        "ord"    : this.current_command.set_type(HQM_CFG_ORD_REG);
        "orde"   : this.current_command.set_type(HQM_CFG_ORDE_REG);
        "brd"    : this.current_command.set_type(HQM_CFG_BRD_REG);
        "mwr"    : this.current_command.set_type(HQM_MEM_WRITE);
        "mrd"    : this.current_command.set_type(HQM_MEM_READ);
        "poll"   : this.current_command.set_type(HQM_CFG_POLL_REG);
        "idle"   : begin
                     this.current_command.set_type(HQM_CFG_IDLE_REG);
                     this.current_state = OPTIONS;
                   end
        "access_path"   : begin
                     this.current_command.set_type(HQM_CFG_ACCESS_PATH);
                     this.current_state = OPTIONS;
                   end
        "push_access_path"   : begin
                     this.current_command.set_type(HQM_CFG_PUSH_ACCESS_PATH);
                     this.current_state = OPTIONS;
                   end
        "pop_access_path"   : begin
                     this.current_command.set_type(HQM_CFG_POP_ACCESS_PATH);
                     this.current_state = OPTIONS;
                   end
        "msix_alarm_wait"   : begin
                     this.current_command.set_type(HQM_MSIX_ALARM_WAIT);
                     this.current_state = OPTIONS;
                   end
        "func_pf_bar"   : begin
                     this.current_command.set_type(HQM_CFG_FUNC_PF_REG);
                     this.current_state = OPTIONS;
                   end
        "csr_bar"   : begin
                     this.current_command.set_type(HQM_CFG_CSR_BAR_REG);
                     this.current_state = OPTIONS;
                   end
        "test_done"   : begin
                     this.current_command.set_type(HQM_CFG_TEST_DONE_REG);
                     this.current_state = OPTIONS;
                   end
        "assert" : begin
                     this.current_command.set_type(HQM_ASSERT);
                   end
        "force"   : begin
                     this.current_command.set_type(HQM_FORCE);
                   end
        "release"   : begin
                     this.current_command.set_type(HQM_RELEASE);
                   end
        "cfg_begin" : begin
                        this.current_command.set_type(HQM_CFG_BEGIN);
                        this.current_state = OPTIONS;
                      end
        "cfg_end"   : begin
                        this.current_command.set_type(HQM_CFG_END);
                        this.current_state = OPTIONS;
                      end
        "sai"   : begin
                        this.current_command.set_type(HQM_SAI);
                        this.current_state = OPTIONS;
                      end
        "sysrst"    :   begin
                            this.current_command.set_type(HQM_SYSRST);
                            this.current_state = OPTIONS;
                        end
        "reg_reset" :   begin
                            this.current_command.set_type(HQM_REG_RESET);
                            this.current_state = OPTIONS;
                        end
        "runtst"    :   begin
                            this.current_command.set_type(HQM_RUNTEST);
                            this.current_state = OPTIONS;
                        end
        "poll_sch"   : begin
                            this.current_command.set_type(HQM_CFG_POLL_SCH_REG);
                            this.current_state = LABEL;
                       end
        "cfg_pad_first_write_ldb"   : begin
                                          this.current_command.set_type(HQM_PAD_FIRST_WRITE_LDB);
                                          this.current_state = OPTIONS;
                                      end
        "cfg_pad_first_write_dir"   : begin
                                          this.current_command.set_type(HQM_PAD_FIRST_WRITE_DIR);
                                          this.current_state = OPTIONS;
                                      end
        "cfg_pad_write_ldb"   : begin
                                    this.current_command.set_type(HQM_PAD_WRITE_LDB);
                                    this.current_state = OPTIONS;
                                end
        "cfg_pad_write_dir"   : begin
                                    this.current_command.set_type(HQM_PAD_WRITE_DIR);
                                    this.current_state = OPTIONS;
                                end
        "cfg_early_dir_int"   : begin
                                    this.current_command.set_type(HQM_EARLY_DIR_INT);
                                    this.current_state = OPTIONS;
                                end

        default  : return 0;
        endcase
        return 1;
    endfunction
    
    function bit register_command_target(string command_target);
        this.current_command.set_target(command_target);
        if (this.current_command.get_type() == HQM_CFG_WR_REG ||
            this.current_command.get_type() == HQM_CFG_BWR_REG ||
            this.current_command.get_type() == HQM_CFG_CWR_REG ||
            this.current_command.get_type() == HQM_CFG_WRE_REG ||
            this.current_command.get_type() == HQM_CFG_OWR_REG ||
            this.current_command.get_type() == HQM_CFG_OWRE_REG ||
            this.current_command.get_type() == HQM_CFG_RD_REG ||
            this.current_command.get_type() == HQM_CFG_BRD_REG ||
            this.current_command.get_type() == HQM_CFG_RDE_REG ||
            this.current_command.get_type() == HQM_CFG_ORD_REG ||
            this.current_command.get_type() == HQM_CFG_ORDE_REG ||
            this.current_command.get_type() == HQM_MEM_READ ||
            this.current_command.get_type() == HQM_MEM_WRITE ||
            this.current_command.get_type() == HQM_ASSERT ||
            this.current_command.get_type() == HQM_FORCE ||
            this.current_command.get_type() == HQM_RELEASE ||
            this.current_command.get_type() == HQM_CFG_POLL_REG) begin
            current_state = OPTIONS;
        end
        else begin
            current_state = LABEL;
        end
        return 1;
    endfunction
   
    protected function bit register_command_label(string label);
        string  token;  
        string  explode_q[$];
        longint value;

        explode_q.delete();

        // separate label and value
        lvm_common_pkg::explode(":",label,explode_q,2);

        if (explode_q.size() == 2) begin                // separate label and value
          current_command.label                 = explode_q[0];
          current_command.label_value_str       = explode_q[1];
        end else if (explode_q.size() == 1) begin       // value only
          current_command.label                 = "";
          current_command.label_value_str       = explode_q[0];
        end

        // if numeric value set label_value and clear label_value_str
        if (token_to_longint(current_command.label_value_str, value)) begin
          current_command.label_value           = value;
          current_command.label_value_str       = "";
        end else begin
          current_command.label_value           = -1;
        end

        current_state = OPTIONS;
        return 1;
    endfunction
 
    protected function bit register_command_options(string options);
         if ((this.current_command.get_type() == HQM_CFG_WR_REG) ||
              this.current_command.get_type() == HQM_CFG_BWR_REG ||
              this.current_command.get_type() == HQM_CFG_CWR_REG ||
              this.current_command.get_type() == HQM_CFG_WRE_REG  ||
              this.current_command.get_type() == HQM_CFG_OWR_REG ||
              this.current_command.get_type() == HQM_CFG_OWRE_REG ||
              this.current_command.get_type() == HQM_CFG_RD_REG  ||
              this.current_command.get_type() == HQM_CFG_BRD_REG  ||
              this.current_command.get_type() == HQM_CFG_RDE_REG  ||
              this.current_command.get_type() == HQM_CFG_ORD_REG ||
              this.current_command.get_type() == HQM_CFG_ORDE_REG ||
              this.current_command.get_type() == HQM_MEM_READ ||
              this.current_command.get_type() == HQM_MEM_WRITE ||
              this.current_command.get_type() == HQM_CFG_POLL_REG ||
              this.current_command.get_type() == HQM_ASSERT ||
              this.current_command.get_type() == HQM_FORCE ||
              this.current_command.get_type() == HQM_RELEASE ||
              this.current_command.get_type() == HQM_CFG_IDLE_REG ||
              this.current_command.get_type() == HQM_MSIX_ALARM_WAIT ||
              this.current_command.get_type() == HQM_CFG_TEST_DONE_REG ||
              this.current_command.get_type() == HQM_CFG_POLL_SCH_REG ||
              this.current_command.get_type() == HQM_PAD_FIRST_WRITE_LDB ||
              this.current_command.get_type() == HQM_PAD_WRITE_LDB ||
              this.current_command.get_type() == HQM_PAD_FIRST_WRITE_DIR ||
              this.current_command.get_type() == HQM_PAD_WRITE_DIR || 
              this.current_command.get_type() == HQM_EARLY_DIR_INT ) begin
            return register_command_reg_options(options);
         end else if (this.current_command.get_type() == HQM_SAI) begin
            return register_command_sai_options(options);
         end else begin
            return register_command_sub_options(options);
         end
    endfunction

    protected function bit register_command_reg_options(string options);
       string           token;
       longint          value;
       hqm_cfg_command_options  new_options;

       while (options != "") begin
         token = parse_token(options);

         if(token_to_longint(token, value)) begin
           new_options = new();
           new_options.values.push_back(value);
           this.current_command.add_option(new_options);
         end else begin
           ovm_report_error("CFG COMMAND", $psprintf("Unable to parse register value -->%s", token));
           return 0;
         end
       end

       return 1;
    endfunction


    protected function bit register_command_sai_options(string options);
       string           token;
       longint          value;
       hqm_cfg_command_options  new_options;

       if (options != "") begin
         token = parse_token(options);

         new_options = new();

         case (token)
           "hostia_postboot_sai":               new_options.values.push_back(SRVR_HOSTIA_POSTBOOT_SAI);
           "hostia_ucode_sai":                  new_options.values.push_back(SRVR_HOSTIA_UCODE_SAI);
           "hostia_smm_sai":                    new_options.values.push_back(SRVR_HOSTIA_SMM_SAI);
           "hostia_sunpass_sai":                new_options.values.push_back(SRVR_HOSTIA_SUNPASS_SAI);
           "hostia_boot_sai":                   new_options.values.push_back(SRVR_HOSTIA_BOOT_SAI);
           "gt_sai":                            new_options.values.push_back(SRVR_GT_SAI);
           "pm_pcs_sai":                        new_options.values.push_back(SRVR_PM_PCS_SAI);
           "hw_cpu_sai":                        new_options.values.push_back(SRVR_HW_CPU_SAI);
           "mem_cpl_sai":                       new_options.values.push_back(SRVR_MEM_CPL_SAI);
           "vtd_sai":                           new_options.values.push_back(SRVR_VTD_SAI);
           "hostcp_pma_sai":                    new_options.values.push_back(SRVR_HOSTCP_PMA_SAI);
           "cse_intel_sai":                     new_options.values.push_back(SRVR_CSE_INTEL_SAI);
           "cse_oem_sai":                       new_options.values.push_back(SRVR_CSE_OEM_SAI);
           "fuse_ctrl_sai":                     new_options.values.push_back(SRVR_FUSE_CTRL_SAI);
           "fuse_puller_sai":                   new_options.values.push_back(SRVR_FUSE_PULLER_SAI);
           "pm_ioss_sai":                       new_options.values.push_back(SRVR_PM_IOSS_SAI);
           "cse_dnx_sai":                       new_options.values.push_back(SRVR_CSE_DNX_SAI);
           "dfx_intel_manufacturing_sai":       new_options.values.push_back(SRVR_DFX_INTEL_MANUFACTURING_SAI);
           "dfx_untrusted_sai":                 new_options.values.push_back(SRVR_DFX_UNTRUSTED_SAI);
           "hw_pch_sai":                        new_options.values.push_back(SRVR_HW_PCH_SAI);
           "gt_pma_sai":                        new_options.values.push_back(SRVR_GT_PMA_SAI);
           "dfx_intel_production_sai":          new_options.values.push_back(SRVR_DFX_INTEL_PRODUCTION_SAI);
           "dfx_thirdparty_sai":                new_options.values.push_back(SRVR_DFX_THIRDPARTY_SAI);
           "display_sai":                       new_options.values.push_back(SRVR_DISPLAY_SAI);
           "display_kvm_sai":                   new_options.values.push_back(SRVR_DISPLAY_KVM_SAI);
           "core_event_proxy_sai":              new_options.values.push_back(SRVR_CORE_EVENT_PROXY_SAI);
           "device_untrusted_sai":              new_options.values.push_back(SRVR_DEVICE_UNTRUSTED_SAI);
           default: begin
             if(token_to_longint(token, value)) begin
               new_options.values.push_back(value);
             end else begin
               ovm_report_error("CFG COMMAND", $psprintf("Unable to parse register value -->%s", token));
               return 0;
             end
           end
         endcase
       end

       this.current_command.add_option(new_options);

       return 1;
    endfunction


    protected function bit register_command_sub_options(string options);
        string                  original_options;
        hqm_cfg_command_options new_options;
        string                  token;
        string                  value_str;
        longint                 value;
        longint                 value2;
        string                  opt_explode_q[$];
        string                  val_explode_q[$];
        string                  range_explode_q[$];

        original_options = options;

        new_options = new();

        opt_explode_q.delete();

        // separate label and value
        lvm_common_pkg::explode("=",options,opt_explode_q,2);

        if (opt_explode_q.size() == 1) begin    // no value associated with option
          new_options.option = options;
          new_options.randmization_type = NONE;
        end else if (opt_explode_q.size() == 2) begin   // value specified
          new_options.option = opt_explode_q[0];

          if (opt_explode_q[1] == "*") begin    // wildcard value
            new_options.randmization_type = WILD_CARD_TYPE;
          end else if ((opt_explode_q[1][0] == "[") && (opt_explode_q[1][opt_explode_q[1].len()-1] == "]")) begin        // value list
            opt_explode_q[1] = opt_explode_q[1].substr(1,opt_explode_q[1].len()-2);

            // get individual entries in value list
            val_explode_q.delete();
            lvm_common_pkg::explode(",",opt_explode_q[1],val_explode_q);

            // process all value list entries
            while (val_explode_q.size() > 0) begin
              new_options.randmization_type = LIST_TYPE;
              range_explode_q.delete();
              lvm_common_pkg::explode(":",val_explode_q.pop_front(),range_explode_q,2);

              if (range_explode_q.size() == 1) begin    // entry is a single value, must be a number in value list
                if ( token_to_longint(range_explode_q[0],value)) begin
                  new_options.values.push_back(value);
                end else begin
                  `ovm_error("HQM_COMMAND_PROCESSOR",$psprintf("Illegal option value - %s",original_options))
                  return 0;
                end
              end else if (range_explode_q.size() == 2) begin   // entry is a range of values
                if ( token_to_longint(range_explode_q[0],value) == 0) begin
                  `ovm_error("HQM_COMMAND_PROCESSOR",$psprintf("Illegal option value - %s",original_options))
                  return 0;
                end
                if ( token_to_longint(range_explode_q[1],value2) == 0) begin
                  `ovm_error("HQM_COMMAND_PROCESSOR",$psprintf("Illegal option value - %s",original_options))
                  return 0;
                end

                // push all values in range
                for (longint i = value ; i <= value2 ; i++) begin
                  new_options.values.push_back(i);
                end
              end
            end
          end else if ( token_to_longint(opt_explode_q[1],value)) begin // check if single integer value
            new_options.values.push_back(value);
            new_options.randmization_type = FIXED_VAL_TYPE;
          end else begin        // is not an integer, set string value
            new_options.str_value = opt_explode_q[1];
            new_options.randmization_type = STRING_TYPE;
          end
        end else begin
          `ovm_error("HQM_COMMAND_PROCESSOR",$psprintf("Illegal option value - %s",original_options))
          return 0;
        end

        this.current_command.add_option(new_options);
        return 1;
    endfunction

endclass
