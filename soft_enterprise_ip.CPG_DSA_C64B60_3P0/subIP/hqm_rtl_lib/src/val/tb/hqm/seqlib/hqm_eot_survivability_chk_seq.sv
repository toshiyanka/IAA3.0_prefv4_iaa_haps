`ifndef HQM_EOT_SURVIVABILITY_CHK_SEQ_SV
`define HQM_EOT_SURVIVABILITY_CHK_SEQ_SV

class hqm_eot_survivability_chk_seq extends hqm_survivability_patch_seq;

  `ovm_sequence_utils(hqm_eot_survivability_chk_seq, sla_sequencer)
  hqm_sla_pcie_flr_sequence             flr_seq;
  hqm_sla_pcie_init_seq                 pcie_init_seq;

  function new(string name = "hqm_eot_survivability_chk_seq");
    super.new(name);
  endfunction

  extern virtual task body();
  extern         task chk_non_common_survivability_registers();

task chk_survivability_field();
  sla_status_t   status; 
  sla_ral_field  my_field;
  sla_ral_data_t wr_val=0, rd_val=0;
  sla_ral_data_t rd_val_list[$];
  string	  survivability_reg_field="";
  bit found_reg=1'b_0;
  string      loc_survivability_reg_field="";
  int         num_fields_updated=0;
  int         num_fields_to_check=0;
  sla_ral_data_t exp_rd_val;
  int         curr_survi_field_num=0;
  int         survi_field_num;
  int         check_single_field;
  bit         prochot_disable;
  bit         config_master_skip;

  prochot_disable=0;
  $value$plusargs("hqm_prochot_disable=%d",prochot_disable);
  
  if(!$value$plusargs("SURVIVABILITY_NUM_FIELDS_TO_CHECK=%0d",num_fields_to_check)) num_fields_to_check=survivability_regs.size();

  
  foreach (survivability_field_typical_val[k]) begin
      config_master_skip=0;
      found_reg=1'b_0;
      loc_survivability_reg_field = k;
      survivability_reg_field = loc_survivability_reg_field.toupper();
      curr_survi_field_num++;

      `ovm_info(get_full_name(),$psprintf("Would check EOT val of HQM_SURVIVABILITY PATCH for field (%s)",survivability_reg_field),OVM_LOW)

      foreach(survivability_regs[i])	begin
         config_master_skip=0;
        `ovm_info(get_full_name(),$psprintf("chk_survivability_field:: %0d in num_fields_to_check=%0d, Finding field (%s) in reg (%s)", i, num_fields_to_check, survivability_reg_field, survivability_regs[i].get_name()),OVM_LOW)
        my_field = survivability_regs[i].find_field(survivability_reg_field);
        if(my_field == null )	begin end
        else begin
          if (!check_single_field || (check_single_field && (curr_survi_field_num == survi_field_num))) begin
              `ovm_info(get_full_name(),$psprintf("Running HQM_SURVIVABILITY EOT chk for field (%s) in reg (%s) and tracking_val (0x%0x), reset_val (0x%0x)",survivability_reg_field,survivability_regs[i].get_name(),my_field.get_tracking_val(), my_field.get_reset_val()),OVM_LOW)

              exp_rd_val = my_field.get_reset_val(); 

              case (survivability_regs[i].get_name())
                  // registers in hqm_iosf, config_master units won't get reset by PF FLR, so expect previous written values
                  "IOSFP_CGCTL", "IOSFS_CGCTL", "PRIM_CDC_CTL", "SIDE_CDC_CTL", "CFG_MASTER_CTL":exp_rd_val = my_field.get_tracking_val();
                  "CFG_CONTROL_GENERAL": begin
                      case (survivability_reg_field)
                            "IGNORE_PIPE_BUSY", "CFG_ENABLE_UNIT_IDLE", "CFG_PM_ALLOW_ING_DROP", "CFG_ENABLE_ALARMS", "CFG_DISABLE_RING_PAR_CK": begin
                                   exp_rd_val = my_field.get_tracking_val();
                                   if(prochot_disable) config_master_skip=1;
                            end
                      endcase
                  end
                  // registers from all other units except hqm_iosf, config_master will get reset by PF FLR, so expect register reset default values
                  default: exp_rd_val = my_field.get_reset_val();
              endcase

              if ((survivability_regs[i].get_name()=="WRITE_BUFFER_CTL") && (survivability_reg_field=="SCH_RATE_LIMIT")) exp_rd_val = 'h_0;

              `ovm_info(get_full_name(),$psprintf("chk_survivability_field:: %0d in num_fields_to_check=%0d, field_%s, exp_rd_val=0x%0x, prochot_disable=%0d, config_master_skip=%0d", i, num_fields_to_check, survivability_reg_field, exp_rd_val, prochot_disable, config_master_skip),OVM_LOW)

              if(config_master_skip)
                 survivability_regs[i].read_fields(status,{survivability_reg_field},rd_val_list,primary_id,.sai(SRVR_HOSTIA_UCODE_SAI));
              else
                 survivability_regs[i].readx_fields(status,{survivability_reg_field},{exp_rd_val},rd_val_list,primary_id,.sai(SRVR_HOSTIA_UCODE_SAI));


              // if CFG_ENABLE_UNIT_IDLE is not set to 1, prim/side_clkreq will never go low, HQM won't go into idle, so setting it to default value once checks are done
              if ((survivability_reg_field=="CLKREQ_CTL_DISABLED") || (survivability_reg_field=="CFG_ENABLE_UNIT_IDLE"))
                survivability_regs[i].write_fields(status,{survivability_reg_field},{my_field.get_reset_val()},primary_id,.sai(SRVR_HOSTIA_UCODE_SAI));
              end
          found_reg=1'b_1;
        end
      end

      if(found_reg==1'b_0)	begin
         `ovm_error(get_full_name(),$psprintf("Could not find HQM_SURVIVABILITY field (%s) in any reg",survivability_reg_field))
      end
      num_fields_updated++;
      if (num_fields_updated >= num_fields_to_check) begin
          `ovm_info(get_full_name(),$psprintf("All Expected number of fields are patched, so coming out of task:num_fields_to_check=%0d, num_fields_updated=%0d, Total Number of fields=%0d", num_fields_to_check, num_fields_updated, survivability_regs.size()),OVM_LOW)
          break;
      end
  end

endtask

endclass

task hqm_eot_survivability_chk_seq::body();
    ovm_object  o;
    string      loc_survivability_reg_field="";
    string      bg_cfg_access_path="";

    `ovm_do_with(flr_seq, {no_sys_init==1;});
    wait_ns_clk(1200); 
    `ovm_do(pcie_init_seq);

    if(!$value$plusargs("SURVI_FIELD_NUM=%d", survi_field_num)) begin check_single_field=0; survi_field_num = 0; end
    if (survi_field_num) check_single_field = 1;

    $cast(ral, sla_ral_env::get_ptr());
    if (ral == null) begin
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    //get cfg object
    if (cfg == null) begin
      cfg = hqm_cfg::get();
      if (cfg == null) begin
        ovm_report_fatal(get_full_name(), $psprintf("Unable to get CFG object"));
      end
    end

    if(!$value$plusargs("HQM_SURVIVABILITY_ACCESS=%s",bg_cfg_access_path)) bg_cfg_access_path="sideband";
    primary_id=select_bg_cfg_access_path(bg_cfg_access_path);
   
    load_survivability_regs();
    load_survivability_field_typical_val();
    chk_survivability_field();

    if ($test$plusargs("CHECK_NON_COMMON_REGISTERS")) begin
        ovm_report_info(get_full_name(), $psprintf("Check non-common survivability registers"), OVM_LOW);
        chk_non_common_survivability_registers();
    end

endtask

task hqm_eot_survivability_chk_seq::chk_non_common_survivability_registers();

    sla_status_t   status;
    sla_ral_reg    reg_h;
    sla_ral_data_t rd_val;
    sla_ral_data_t exp_val;

    ovm_report_info(get_full_name(), $psprintf("chk_non_common_survivability_registers -- Start"), OVM_DEBUG);

    reg_h   = ral.find_reg_by_file_name("cfg_arb_weight_atm_nalb_qid_0", "list_sel_pipe");
    exp_val = reg_h.get_reset_val();
    reg_h.readx(status, exp_val, 'hffff_ffff, rd_val, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));

    reg_h   = ral.find_reg_by_file_name("cfg_arb_weight_atm_nalb_qid_1", "list_sel_pipe");
    exp_val = reg_h.get_reset_val();
    reg_h.readx(status, exp_val, 'hffff_ffff, rd_val, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));

    reg_h   = ral.find_reg_by_file_name("cfg_arb_weight_ldb_qid_0", "list_sel_pipe");
    exp_val = reg_h.get_reset_val();
    reg_h.readx(status, exp_val, 'hffff_ffff, rd_val, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));

    reg_h   = ral.find_reg_by_file_name("cfg_arb_weight_ldb_qid_1", "list_sel_pipe");
    exp_val = reg_h.get_reset_val();
    reg_h.readx(status, exp_val, 'hffff_ffff, rd_val, primary_id, .sai(SRVR_HOSTIA_UCODE_SAI));

    ovm_report_info(get_full_name(), $psprintf("chk_non_common_survivability_registers -- End"),   OVM_DEBUG);

endtask : chk_non_common_survivability_registers

`endif //HQM_EOT_SURVIVABILITY_CHK_SEQ_SV
