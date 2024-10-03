`ifndef HCW_TXN_PWRGATE_DEVICE_SEQ__SV
`define HCW_TXN_PWRGATE_DEVICE_SEQ__SV


class hcw_txn_pwrgate_device_seq extends hqm_pwr_base_seq;

  typedef bit [3:0] vf_num_t;
  typedef bit [5:0] pp_num_t;

  hqm_cfg                                      i_hqm_cfg;
  hqm_pp_cq_status                             i_hqm_pp_cq_status;
  hqm_sla_pcie_init_seq                        i_pcie_init;
  hqm_tb_hcw_cfg_seq                           i_hcw_cfg;
  hcw_dir_test_hcw_seq                         i_hcw_dir_test_hcw_seq; 
  ovm_event_pool                               glbl_pool;
  ovm_event                                    exp_ep_nfatal_msg_pf;



  `ovm_sequence_utils(hcw_txn_pwrgate_device_seq, sla_sequencer)

  function new(string name = "hcw_txn_pwrgate_device_seq"); 
    super.new(name);
    glbl_pool            = ovm_event_pool::get_global_pool();
    exp_ep_nfatal_msg_pf = glbl_pool.get("exp_ep_nfatal_msg_0");
  endfunction

  virtual task body();

      ovm_object     o_tmp;
      sla_ral_addr_t addr;
      sla_ral_reg    reg_h;
      sla_ral_field  fields[$];
      sla_ral_data_t rd_data;
     `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
      //-----------------------------
      //-- get i_hqm_cfg
      //-----------------------------
      if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
        ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
      end

      if (!$cast(i_hqm_cfg, o_tmp)) begin
        ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
      end  

      if (!p_sequencer.get_config_object("i_hqm_pp_cq_status", o_tmp)) begin
        ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
      end

      if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
        ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
      end  

      start_traffic(1);


  endtask


  task start_traffic(int iteration);       
      
      string         cfg_cmds[$];
      sla_ral_reg    reg_h;
      sla_ral_field  fields[$];
      sla_ral_data_t rd_data;
      bit [31:0]     rd_val;
      bit [31:0]     exp_val;
      exp_val = 16'h8086;
       
      ovm_report_info(get_full_name(), $psprintf("starting hqm power gated sequence"), OVM_LOW);
      ovm_report_info(get_full_name(), $psprintf("starting hcw traffic"), OVM_LOW);
      `ovm_create(i_hcw_dir_test_hcw_seq) 
      i_hcw_dir_test_hcw_seq.start(p_sequencer);
      ovm_report_info(get_full_name(), $psprintf("completed hcw traffic"), OVM_LOW);

      if ($test$plusargs("HQM_BACKGROUND_CFG_GEN_SEQ")) begin
          i_hqm_pp_cq_status.pause_bg_cfg_req = 1'b1;
          wait (i_hqm_pp_cq_status.pause_bg_cfg_ack == 1'b1);
          i_hqm_pp_cq_status.pause_bg_cfg_ack = 1'b0;
      end

      // -- Check counter value is not less than value 0x1E,and timer is not reseted
      wait_for_clk(50);
      ovm_report_info(get_full_name(), $psprintf("starting d3hot"), OVM_LOW);
      pmcsr_ps_cfg(`HQM_D3STATE);
      wait_for_clk(50);
      //send cfg write/read 
      compare("hqm_pf_cfg_i","vendor_id","vid",SLA_FALSE,exp_val); 
      //send hcw transaction
      ovm_report_info(get_full_name(), $psprintf("starting hcw traffic in d3hot"), OVM_LOW);
      send_hcw_d3hot_state(30);
      ovm_report_info(get_full_name(), $psprintf("completed hcw traffic in d3hot"), OVM_LOW);
      ral.reset_regs("D3HOT","vcccfn_gated",0); 
      reset_tb("D3HOT");
      i_hqm_cfg.reset_hqm_cfg();
      ovm_report_info(get_full_name(), $psprintf("completed d3hot"), OVM_LOW);
      ovm_report_info(get_full_name(), $psprintf("starting power gated seq d0hot"), OVM_LOW);
      pmcsr_ps_cfg(`HQM_D0STATE);
      ovm_report_info(get_full_name(), $psprintf("completed power gated seq d0hot"), OVM_LOW);
      poll_rst_done(); 
      `ovm_info(get_full_name(),$sformatf("\n Starting hcw cfg seq \n"),OVM_LOW)
      `ovm_create(i_hcw_cfg)
      i_hcw_cfg.start(p_sequencer);
      if ($test$plusargs("HQM_BACKGROUND_CFG_GEN_SEQ")) begin
          i_hqm_pp_cq_status.pause_bg_cfg_req = 1'b0;
      end
      `ovm_info(get_full_name(),$sformatf("\n starting hcw tranfer seq \n"),OVM_LOW)
      i_hcw_dir_test_hcw_seq.start(p_sequencer);
      ovm_report_info(get_full_name(), $psprintf("completed hqm power gated sequence"), OVM_LOW);
  endtask : start_traffic


  task send_hcw_d3hot_state(int iteration);
      string           cfg_cmds[$];
      ovm_report_info(get_full_name(), $psprintf("Starting traffic on DIR PORT CQ->5,6"), OVM_LOW);
        exp_ep_nfatal_msg_pf.trigger();
      //send 1HCW for each QE to start timer
        cfg_cmds.push_back("dir pp 5  exp_drop=1");
        cfg_cmds.push_back("dir pp 20 exp_drop=1");
      for(int i=0;i<iteration;i++) begin
        cfg_cmds.push_back("HCW DIR:5 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=5 dsi=0x302 batch=1"); 
        cfg_cmds.push_back("HCW DIR:5 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=5 dsi=0x302 batch=1"); 
        cfg_cmds.push_back("HCW DIR:5 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=5 dsi=0x302 batch=1"); 
        cfg_cmds.push_back("HCW DIR:5 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=5 dsi=0x302 "); 
        cfg_cmds.push_back("idle 200");
        cfg_cmds.push_back("HCW DIR:20 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=20 dsi=0x302 batch=1"); 
        cfg_cmds.push_back("HCW DIR:20 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=20 dsi=0x302 batch=1"); 
        cfg_cmds.push_back("HCW DIR:20 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=20 dsi=0x302 batch=1"); 
        cfg_cmds.push_back("HCW DIR:20 is_nm_pf=1 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=20 dsi=0x302 "); 
        cfg_cmds.push_back("idle 200");
      end
        cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");

      while (cfg_cmds.size()) begin
          bit         do_cfg_seq;
          hqm_cfg_seq cfg_seq;
          string      cmd;
          cmd = cfg_cmds.pop_front();
          i_hqm_cfg.set_cfg(cmd, do_cfg_seq);
          if (do_cfg_seq) begin
            `ovm_create(cfg_seq)
            cfg_seq.pre_body();
            start_item(cfg_seq);
            finish_item(cfg_seq);
            cfg_seq.post_body();
          end
      end
      ovm_report_info(get_full_name(), $psprintf("completed traffic on DIR Ports "), OVM_LOW);
      wait_for_clk(50);
  endtask: send_hcw_d3hot_state

endclass : hcw_txn_pwrgate_device_seq

`endif //HCW_TXN_PWRGATE_DEVICE_SEQ__SV


