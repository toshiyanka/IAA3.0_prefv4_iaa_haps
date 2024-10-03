`ifndef HQM_MBECC_WR_BAD_LUT_SEQ__SV
`define HQM_MBECC_WR_BAD_LUT_SEQ__SV


/* 
sequence: set ecc reg, wr vpp2pp send hcw and check synd registers, RESET , config hqm, send hcw no error should be observed
Set hqm_system_csr.ecc_ctl.WRITE_BAD_MB_ECC 1 , rd back 
rd hqm_system_csr.ecc_ctl.WRITE_BAD_MB_ECC 1
wr hqm_system_csr.vf_dir_vpp2pp[2]     0xc
rd hqm_system_csr.vf_dir_vpp2pp[2]     0xc
*/
class hqm_mbecc_wr_bad_lut_seq extends hqm_pwr_base_seq;

  string cfg_cmds[$];

  hqm_cfg                                      i_hqm_cfg;
  hqm_sla_pcie_init_seq                        i_pcie_init;
  hqm_tb_hcw_cfg_seq                           i_hcw_cfg;
  
  `ovm_sequence_utils(hqm_mbecc_wr_bad_lut_seq, sla_sequencer)

    extern function                  new                           (string name = "hqm_mbecc_wr_bad_lut_seq");
    extern task                      body                          ();
    extern task                      mbecc_lut_wr                  ();
    extern task                      reset_d0hot_and_hcw_cfg       ();
    extern task                      execute_cfg_cmds              ();
endclass : hqm_mbecc_wr_bad_lut_seq


function hqm_mbecc_wr_bad_lut_seq::new(string name = "hqm_mbecc_wr_bad_lut_seq");
  super.new(name);
endfunction

task hqm_mbecc_wr_bad_lut_seq::body();

      ovm_object     o_tmp;
      sla_ral_addr_t addr;
      sla_ral_reg    reg_h;
      sla_ral_field  fields[$];
      sla_ral_data_t rd_data;

      bit            is_ldb;
      bit [5:0]      pp_num;
      bit [5:0]      pp_num_l;
      bit [5:0]      pp_num_h;
      bit [4:0]      lqid;
      bit [5:0]      qid;
      bit [31:0]     exp_synd_val;
     `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);
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
     ovm_report_info(get_full_name(), $psprintf("Starting traffic on HQM "), OVM_LOW);
     mbecc_lut_wr();
     ovm_report_info(get_full_name(), $psprintf("completed traffic on HQM "), OVM_LOW);
  endtask

task hqm_mbecc_wr_bad_lut_seq::mbecc_lut_wr();
     sla_ral_data_t rd_field_val[$];
     sla_ral_data_t rd_reg_val;
     cfg_cmds.push_back("wr hqm_system_csr.ecc_ctl.WRITE_BAD_MB_ECC 1");
     cfg_cmds.push_back("rd hqm_system_csr.ecc_ctl.WRITE_BAD_MB_ECC 1");
     execute_cfg_cmds(); 
     cfg_cmds.push_back("wr hqm_system_csr.vf_dir_vpp2pp[2]     0xc ");
     cfg_cmds.push_back("rd hqm_system_csr.vf_dir_vpp2pp[2]     0xc ");
     execute_cfg_cmds(); 
     cfg_cmds.push_back("msix_alarm_wait 500");
     execute_cfg_cmds(); 
     cfg_cmds.push_back("wr hqm_system_csr.msix_ack.MSIX_0_ACK 1");
     execute_cfg_cmds(); 
     cfg_cmds.push_back("rd hqm_system_csr.msix_ack.MSIX_0_ACK 0");
     execute_cfg_cmds(); 
     
    //send HCW on PP which had bed LUT , drop expected
    cfg_cmds.push_back("HCW DIR:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=2  dsi=0x300 ingress_drop=1");  
    cfg_cmds.push_back("HCW DIR:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=2  dsi=0x300 ingress_drop=1"); 
    cfg_cmds.push_back("HCW DIR:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=2  dsi=0x300 ingress_drop=1"); 
    cfg_cmds.push_back("HCW DIR:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=2  dsi=0x300 ingress_drop=1");
    cfg_cmds.push_back("HCW DIR:20 vf_num=7 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=20  dsi=0x300"); 
    cfg_cmds.push_back("HCW DIR:20 vf_num=7 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=20  dsi=0x300"); 
    cfg_cmds.push_back("HCW DIR:20 vf_num=7 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=20  dsi=0x300"); 
    cfg_cmds.push_back("HCW DIR:20 vf_num=7 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=20  dsi=0x300");
    execute_cfg_cmds(); 
    // wait for scheduling
    cfg_cmds.push_back("poll hqm_system_csr.hqm_system_cnt_4 0x4 0xffffffff 1000 200 ");
    cfg_cmds.push_back("poll_sch dir:31  0x4 200 100");
    execute_cfg_cmds(); 
    cfg_cmds.push_back("msix_alarm_wait 500");
    execute_cfg_cmds(); 
    cfg_cmds.push_back("wr hqm_system_csr.msix_ack.MSIX_0_ACK 1");
    execute_cfg_cmds(); 
    cfg_cmds.push_back("rd hqm_system_csr.msix_ack.MSIX_0_ACK 0");
    execute_cfg_cmds(); 
    cfg_cmds.push_back("rd hqm_system_csr.alarm_mb_ecc_err   0x00000020 ");
    cfg_cmds.push_back("rd hqm_system_csr.alarm_hw_synd      0xC0458402 ");
    execute_cfg_cmds(); 
    wait_for_clk(100);
    reset_d0hot_and_hcw_cfg();
    //send hcw
   `ovm_info(get_full_name(),$sformatf("\n starting hcw tranfer \n"),OVM_LOW)
    cfg_cmds.push_back("HCW DIR:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=2  dsi=0x300 ");  
    cfg_cmds.push_back("HCW DIR:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=2  dsi=0x300 "); 
    cfg_cmds.push_back("HCW DIR:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=2  dsi=0x300 "); 
    cfg_cmds.push_back("HCW DIR:2 vf_num=0 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=2  dsi=0x300 ");
    cfg_cmds.push_back("HCW DIR:20 vf_num=7 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=20  dsi=0x300"); 
    cfg_cmds.push_back("HCW DIR:20 vf_num=7 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=20  dsi=0x300"); 
    cfg_cmds.push_back("HCW DIR:20 vf_num=7 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=20  dsi=0x300"); 
    cfg_cmds.push_back("HCW DIR:20 vf_num=7 qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x123 msgtype=0 qpri=0 qtype=dir qid=20  dsi=0x300");
    execute_cfg_cmds(); 
    cfg_cmds.push_back("poll_sch dir:12  0x4 200 100");
    cfg_cmds.push_back("poll_sch dir:31  0x4 200 100");
    cfg_cmds.push_back("rd hqm_system_csr.alarm_mb_ecc_err   0x00000000 ");
    execute_cfg_cmds(); 
    //return tokens 
    cfg_cmds.push_back("HCW DIR:2  vf_num=0 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x03 msgtype=0 qpri=0 qtype=dir qid=2  dsi=0x300 ");  
    cfg_cmds.push_back("HCW DIR:20 vf_num=7 qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x03 msgtype=0 qpri=0 qtype=dir qid=20 dsi=0x300"); 
    execute_cfg_cmds(); 
    wait_for_clk(500);
endtask

task hqm_mbecc_wr_bad_lut_seq::execute_cfg_cmds();

  while (cfg_cmds.size()) begin

    bit         do_cfg_seq;
    hqm_cfg_seq cfg_seq;
    string      cmd;

    cmd = cfg_cmds.pop_front();
    ovm_report_info(get_full_name(), $psprintf("Processing command -> %0s", cmd), OVM_LOW);
    i_hqm_cfg.set_cfg(cmd, do_cfg_seq);
     if (do_cfg_seq) begin
       `ovm_create(cfg_seq)
        cfg_seq.pre_body();
        start_item(cfg_seq);
        finish_item(cfg_seq);
        cfg_seq.post_body();
     end
 end
      wait_for_clk(100);
endtask

task hqm_mbecc_wr_bad_lut_seq::reset_d0hot_and_hcw_cfg();
    // Reset     
    ovm_report_info(get_full_name(), $psprintf("starting d3hot"), OVM_LOW);
    pmcsr_ps_cfg(`HQM_D3STATE);
    ral.reset_regs("D3HOT","vcccfn_gated",0); 
    reset_tb("D3HOT");
    i_hqm_cfg.reset_hqm_cfg();
      ovm_report_info(get_full_name(), $psprintf("starting power gated seq d0hot"), OVM_LOW);
    pmcsr_ps_cfg(`HQM_D0STATE);
    poll_rst_done();
    ovm_report_info(get_full_name(), $psprintf("completed power gated seq d0hot"), OVM_LOW);
    ovm_report_info(get_full_name(), $psprintf("completed d3hot"), OVM_LOW);
    `ovm_info(get_full_name(),$sformatf("\n Starting hcw cfg seq \n"),OVM_LOW)
    `ovm_create(i_hcw_cfg)
    i_hcw_cfg.start(p_sequencer);

endtask: reset_d0hot_and_hcw_cfg

`endif //HQM_MBECC_WR_BAD_LUT_SEQ__SV



