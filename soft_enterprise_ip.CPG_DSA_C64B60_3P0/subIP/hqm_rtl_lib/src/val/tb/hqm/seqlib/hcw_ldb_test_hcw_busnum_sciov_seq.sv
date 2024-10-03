`ifndef HCW_LDB_TEST_HCW_BUSNUM_SCIOV_SEQ__SV
`define HCW_LDB_TEST_HCW_BUSNUM_SCIOV_SEQ__SV

class hcw_ldb_test_hcw_busnum_sciov_seq extends hcw_ldb_test_hcw_busnum_seq;

  `ovm_sequence_utils(hcw_ldb_test_hcw_busnum_sciov_seq, sla_sequencer)

  function new(string name = "hcw_ldb_test_hcw_busnum_sciov_seq");
    super.new(name);
  endfunction

  virtual task body();

      ovm_object     o_tmp;
      sla_ral_addr_t addr;
      sla_ral_reg    reg_h;
      sla_ral_data_t rd_data;
      int            test_vas;

      //-----------------------------
      //-- get i_hqm_cfg
      //-----------------------------
      if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
        ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
      end

      if (!$cast(i_hqm_cfg, o_tmp)) begin
        ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
      end  

      // -- Start traffic with the default bus number for VF and PF
      ovm_report_info(get_full_name(), $psprintf("Starting traffic with default bus number"), OVM_LOW);
      start_traffic();

      // -- Start traffic again; CQ writes should be with updated bus number for PF and should retain the default bus number for VF
      change_bus_num(1'b1, 0, 'h2f);
      ovm_report_info(get_full_name(), $psprintf("Starting traffic after changing PF bus number"), OVM_LOW);
      start_traffic();

      // -- Check the credit count for all the PPs provisioned
      if ( !(i_hqm_cfg.get_name_val("VS", test_vas)) ) begin
          ovm_report_fatal(get_full_name(), $psprintf("No value found for label VS"));
      end
      for(int i = 0; i < 32; i++) begin
          
          sla_ral_data_t rd_val;

          if (i == test_vas) begin
              compare_reg($psprintf("cfg_vas_credit_count[%0d]", i), 'd1024, rd_val, "credit_hist_pipe");
          end else begin
              compare_reg($psprintf("cfg_vas_credit_count[%0d]", i), 'd0, rd_val, "credit_hist_pipe");
          end
      end


  endtask

  virtual task start_traffic(int iteration = 0);      

      hqm_tb_cfg_file_mode_seq i_seq;

      ovm_report_info(get_full_name(), $psprintf("start_traffic -- Start"), OVM_DEBUG);
      i_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_seq");
      i_seq.set_cfg("HCW_TRAFFIC", 1'b1);
      i_seq.start(get_sequencer());
      ovm_report_info(get_full_name(), $psprintf("start_traffic -- End"), OVM_DEBUG);
      
  endtask : start_traffic

endclass : hcw_ldb_test_hcw_busnum_sciov_seq

`endif //HCW_LDB_TEST_HCW_BUSNUM_SCIOV_SEQ__SV
