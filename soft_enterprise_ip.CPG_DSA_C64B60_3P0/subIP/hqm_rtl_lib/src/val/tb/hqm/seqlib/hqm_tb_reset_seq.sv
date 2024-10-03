
`ifndef HQM_TB_RESET_SEQ__SV
`define HQM_TB_RESET_SEQ__SV

class hqm_tb_reset_seq extends hqm_sla_pcie_base_seq;//hqm_sla_pcie_flr_sequence;
  `ovm_sequence_utils(hqm_tb_reset_seq,sla_sequencer)

  hqm_tb_hcw_scoreboard                 i_hcw_scoreboard;
  hqm_pp_cq_status                      i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed
  ral_pfrst_seq                         rst_hqm_cfg;
  sla_ral_env                           ral;
  hqm_sla_pcie_init_seq                 pcie_init_seq;

  function new(string name = "hqm_tb_reset_seq");
    super.new(name);
  endfunction

  function get_hcw_tb_scoreboard_handle();
    ovm_object o_tmp;
    //-----------------------------
    //-- get i_hcw_scoreboard
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hcw_scoreboard", o_tmp)) begin
                 ovm_report_fatal(get_full_name(), "Unable to find i_hcw_scoreboard object");
    end

    if (!$cast(i_hcw_scoreboard, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config_i_hcw_scoreboard %s associated with config %s is not same type", o_tmp.sprint(), i_hcw_scoreboard.sprint()));
    end else begin
      ovm_report_info(get_full_name(), $psprintf("i_hcw_scoreboard retrieved"), OVM_DEBUG);
    end
  endfunction


  function get_hqm_pp_cq_status_handle();
    ovm_object o_tmp;
    //-----------------------------
    //-- get i_hqm_pp_cq_status 
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_pp_cq_status", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
    end

    if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
    end else begin
      ovm_report_info(get_full_name(), $psprintf("i_hqm_pp_cq_status retrieved"), OVM_DEBUG);
    end
  endfunction
 

  virtual task body();
      sla_ral_reg _reg_; 
      sla_ral_data_t _ral_data_;

      super.body();

      // get i_hqm_pp_cq_status
      get_hqm_pp_cq_status_handle();
  
      // get_hcw_tb_scoreboard_handle 
      get_hcw_tb_scoreboard_handle();
      `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."));
      _reg_     = ral.find_reg_by_file_name("pcie_cap_device_control", "hqm_pf_cfg_i");

      `ovm_do(rst_hqm_cfg);
      i_hcw_scoreboard.hcw_scoreboard_reset();

      //-- check hqm_pp_cq_status.cq_int and clear it
      for(int kk=0; kk<64; kk++) begin
         if(i_hqm_pp_cq_status.cq_int_received(1, kk) == 1) begin 
          `ovm_info(get_full_name(),$psprintf("Get_hqm_pp_cq_status.cq_int[%0d] mailbox ", kk),OVM_LOW);
           wait_ns_clk(1);
           i_hqm_pp_cq_status.wait_for_cq_int(1, kk); //ldb_cq[kk]
         end
      end 
  
      _ral_data_='h_0; _ral_data_[15]=1'b_1;
      _reg_.set_tracking_val(_ral_data_);  // -- To reset active_seq_cnt in pp_cq_base_seq -- //
      `ovm_info(get_full_name(),$psprintf("Setting tracking val of 15th bit of pcie_cap_device_control in pf_cfg space to '1'. To be used by pp_cq_base_seq."),OVM_LOW);

      //init_hqm();
   `ovm_do(pcie_init_seq);
  endtask

endclass
`endif
