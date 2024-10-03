
import hqm_tb_cfg_pkg::*;
import hqm_saola_pkg::*;
import hqm_pkg::*;
import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hqm_cfg_pkg::*;
import hqm_cfg_seq_pkg::*;
import hqm_integ_pkg::*;
import hqm_tb_cfg_sequences_pkg::*;

import hqm_tb_cfg_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;
import hqm_tb_sequences_pkg::*;

class hqm_cfg_with_intermediate_primrst_seq extends hqm_base_seq;

  `ovm_sequence_utils(hqm_cfg_with_intermediate_primrst_seq, sla_sequencer)

  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;
  sla_ral_env                   ral;

  hcw_perf_dir_ldb_test1_hcw_seq        dir_ldb_test1_hcw_seq;

  hqm_reset_init_sequence               warm_reset;
  hqm_cold_reset_sequence               cold_reset;
  hqm_tb_cfg_file_mode_seq              i_cfg2_file_mode_seq;
  hqm_tb_cfg_file_mode_seq              i_cfg3_file_mode_seq;
  hqm_tb_cfg_file_mode_seq              i_cfg4_file_mode_seq;
  hqm_tb_cfg_file_mode_seq              i_cfg5_file_mode_seq;
  hqm_background_cfg_file_mode_seq      bg_cfg_seq;
  hqm_sla_pcie_flr_sequence             flr_seq;
  ral_pfrst_seq                         rst_hqm_cfg;
  hqm_sla_pcie_init_seq                 hqm_pcie_init;

//  hqm_sla_pcie_reg_rst_val_chk_sequence i_pcie_reg_rst_seq;
  hqm_iosf_sb_file_seq                  i_iosf_sb_file_mode_seq;
   
  int                                   flr_wait_num;

  function new(string name = "hqm_cfg_with_intermediate_primrst_seq");
    super.new(name);
    
  endfunction

  task wait_sys_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

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


  virtual task body();
    int    primrst_count;
    string primrst_type;
    bit flr_with_hcw_process_on; 
    sla_ral_reg _reg_; sla_ral_data_t _ral_data_;

    //-----------------------------
    //-- get i_hqm_pp_cq_status
    //-----------------------------
    get_hqm_pp_cq_status();
  
    //-----------------------------
    //-- get_hcw_tb_scoreboard_handle 
    //-----------------------------
    get_hcw_tb_scoreboard_handle();

    //-----------------------------
    //-- init: HQM_SEQ_CFG3
    //-----------------------------
        `ovm_info(get_full_name(),$psprintf("primrst_seq_S1: init calling HQM_SEQ_CFG3.cft"),OVM_LOW);
       `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."));
        _reg_     = ral.find_reg_by_file_name("pcie_cap_device_control", "hqm_pf_cfg_i");


        // -- NS Moved first cfg to CONFIG_PHASE of Saola wait_sys_clk(20);
        // -- NS Moved first cfg to CONFIG_PHASE of Saola i_cfg3_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hqm_tb_cfg3_file_mode_seq");
        // -- NS Moved first cfg to CONFIG_PHASE of Saola i_cfg3_file_mode_seq.set_cfg("HQM_SEQ_CFG3", 1'b0);
        // -- NS Moved first cfg to CONFIG_PHASE of Saola i_cfg3_file_mode_seq.start(get_sequencer());
        // -- NS Moved first cfg to CONFIG_PHASE of Saola wait_sys_clk(20); 

        if(!$value$plusargs("HQM_PRIMRST_TYPE=%s",primrst_type))      primrst_type  = "warm";
	    if(!$value$plusargs("HQM_PF_PRIMRST_COUNT=%d",primrst_count)) primrst_count = 1;
        if(!$value$plusargs("HQM_PF_PRIMRST_WITH_HCW_PROCESS_ON=%d",flr_with_hcw_process_on)) flr_with_hcw_process_on=1'b_0;
        if(!$value$plusargs("HQM_PF_PRIMRST_WAITNUM=%d",flr_wait_num)) flr_wait_num = `HQM_PF_FLR_WAIT_WITH_HCW;
       `ovm_info(get_full_name(),$psprintf("Starting hqm_cfg_with_intermediate_primrst_seq_test before series of PRIMRST(s) #(0x%0x) with flr_with_hcw_process_on=(0x%0x), flr_wait_num=%0d",primrst_count,flr_with_hcw_process_on, flr_wait_num),OVM_LOW);

    //-----------------------------
    //-- traffic: 
    //-----------------------------
    fork
       begin 
           `ovm_do(dir_ldb_test1_hcw_seq); 
           `ovm_info(get_full_name(),$psprintf("primrst_seq_S2: calling bg_cfg_seq"),OVM_LOW);
           // -- NS Independent BG access mode available. No need for special seq here.`ovm_do(bg_cfg_seq); 
           flr_with_hcw_process_on = 0; 
       end
       begin 
            while(1) begin 
              wait_sys_clk(flr_wait_num); 
              if(flr_with_hcw_process_on) break; 
            end 
      end
    join_any
    disable fork;
    stop_bg_cfg_gen_seq();
    if ($test$plusargs("ADR_FLOW")) begin
        adr_flow();
    end

    `ovm_info(get_full_name(),$psprintf("primrst_seq_S3: Starting PRIMRST %0d number of times", primrst_count),OVM_LOW);

    if(primrst_count > 0) begin		
      repeat(primrst_count) begin

        //-----------------------------
        //-- S4 : issue warm_rst
        //-----------------------------
        `ovm_info(get_full_name(),$psprintf("primrst_seq_S4: primrst_start call HQM_SEQ_CFG2"),OVM_LOW);
        // -- Use plusarg to select either cold or warm resets -- //
        wait_sys_clk(1200);
        if(primrst_type == "cold") begin `ovm_do(cold_reset); end else begin `ovm_do(warm_reset); end
        wait_sys_clk(1200); 
        `ovm_info(get_full_name(),$psprintf("primrst_seq_S4: primrst_issued"),OVM_LOW);

        //-----------------------------
        //-- S5: after warm reset, reconfigure
        //-----------------------------
        if($test$plusargs("has_rst_hqm_cfg")) begin 
           `ovm_info(get_full_name(),$psprintf("primrst_seq_S5: rst_hqm_cfg_start"),OVM_LOW);
           `ovm_do(rst_hqm_cfg);
           `ovm_info(get_full_name(),$psprintf("primrst_seq_S5: rst_hqm_cfg_done"),OVM_LOW);

        end else if($test$plusargs("has_pcie_reg_rst_resetup")) begin
           `ovm_info(get_full_name(),$psprintf("primrst_seq_S5: hqm_sla_pcie_reg_rst_val_chk_sequence_start"),OVM_LOW);
//           `ovm_do(i_pcie_reg_rst_seq);
           `ovm_info(get_full_name(),$psprintf("primrst_seq_S5: hqm_sla_pcie_reg_rst_val_chk_sequence_done"),OVM_LOW);

        end else if($test$plusargs("has_recfg_setup")) begin
           `ovm_info(get_full_name(),$psprintf("primrst_seq_S5: recfg_setup_start"),OVM_LOW);
            i_cfg5_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hqm_tb_cfg5_file_mode_seq");
            i_cfg5_file_mode_seq.set_cfg("HQM_SEQ_CFG5", 1'b0);
            i_cfg5_file_mode_seq.start(get_sequencer());
            wait_sys_clk(20); 
        end else begin
           `ovm_info(get_full_name(),$psprintf("primrst_seq_S5: rst_hqm_cfg_skip"),OVM_LOW);
        end 
  

        //-----------------------------
        //-- S6: 
        //-----------------------------
        if($test$plusargs("has_hqm_pcie_init")) begin 
            `ovm_info(get_full_name(),$psprintf("primrst_seq_S6: hqm_pcie_init_start"),OVM_LOW);
            `ovm_do(hqm_pcie_init);
            `ovm_info(get_full_name(),$psprintf("primrst_seq_S6: hqm_pcie_init_done"),OVM_LOW);
        end else begin
            `ovm_info(get_full_name(),$psprintf("primrst_seq_S6: hqm_pcie_init_skip"),OVM_LOW);
        end 
  
          wait_sys_clk(10);
         `ovm_info(get_full_name(),$psprintf("primrst_seq_S4: primrst_seq_done"),OVM_LOW);
      end

      `ovm_info(get_full_name(),$psprintf("primrst_seq_S7: Finish PRIMRST %0d number of times, reset sb and hqm_pp_cq_status", primrst_count),OVM_LOW);
       `ovm_do(rst_hqm_cfg);
       i_hcw_scoreboard.hcw_scoreboard_reset();

       //-- check hqm_pp_cq_status.cq_int and clear it
       for(int kk=0; kk<64; kk++) begin
          if(i_hqm_pp_cq_status.cq_int_received(1, kk) == 1) begin 
           `ovm_info(get_full_name(),$psprintf("Get_hqm_pp_cq_status.cq_int[%0d] mailbox ", kk),OVM_LOW);
            wait_sys_clk(1);
            i_hqm_pp_cq_status.wait_for_cq_int(1, kk); //ldb_cq[kk]
          end
       end 
  
       _ral_data_='h_0; _ral_data_[15]=1'b_1;
       _reg_.set_tracking_val(_ral_data_);  // -- To reset active_seq_cnt in pp_cq_base_seq -- //
       `ovm_info(get_full_name(),$psprintf("primrst_seq: Setting tracking val of 15th bit of pcie_cap_device_control in pf_cfg space to '1'. To be used by pp_cq_base_seq."),OVM_LOW);

    end

    `ovm_info(get_full_name(),$psprintf("primrst_seq_S8: Done PRIMRST %0d number of times, reset sb and hqm_pp_cq_status", primrst_count),OVM_LOW);
   
    //-----------------------------
    //-- S9: resume: 
    //-----------------------------

    //-----------------------------
    //-- resume: try sb config
    //-----------------------------
    // NS-- Not sure if this needs to be here `ovm_info(get_full_name(),$psprintf("primrst_seq_S10: SBCFG calling i_iosf_sb_file_mode_seq"),OVM_LOW);
    // NS-- Not sure if this needs to be here   `ovm_do(i_iosf_sb_file_mode_seq); 


    //-----------------------------
    //-- resume: sb patch register access
    //-----------------------------
    `ovm_info(get_full_name(),$psprintf("primrst_seq_S11: resume hqm_cfg followed by HCW traffic with BG accesses"),OVM_LOW);

    if ( $test$plusargs("ADR_FLOW") && (primrst_type == "warm") ) begin

          sla_ral_data_t rd_val_q[$];
          sla_ral_data_t rd_val;

          ovm_report_info(get_full_name(), $psprintf("ADR_FLOW with warm reset; clearing PCIE AER error registers"), OVM_LOW);
          //compare_fields("aer_cap_uncorr_err_status", {"UR"}, {1'b1}, rd_val_q, "hqm_pf_cfg_i");
          //compare_fields("aer_cap_corr_err_status", {"ANFES"}, {1'b1}, rd_val_q, "hqm_pf_cfg_i");
          
          write_fields("aer_cap_uncorr_err_status", {"UR"}, {1'b1}, "hqm_pf_cfg_i");
          write_fields("aer_cap_corr_err_status", {"ANFES"}, {1'b1}, "hqm_pf_cfg_i");

          compare_reg("aer_cap_uncorr_err_status", 'h0, rd_val, "hqm_pf_cfg_i");
          compare_reg("aer_cap_corr_err_status", 'h0, rd_val, "hqm_pf_cfg_i");
      end

      wait_sys_clk(20); 
      `ovm_do(hqm_pcie_init);

      wait_sys_clk(20);
      i_cfg3_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hqm_tb_cfg3_file_mode_seq");
      i_cfg3_file_mode_seq.set_cfg("HQM_SEQ_CFG3", 1'b0);
      i_cfg3_file_mode_seq.start(get_sequencer());
      wait_sys_clk(20); 

      resume_bg_cfg_gen_seq();
      `ovm_do(dir_ldb_test1_hcw_seq);
      // -- NS Independent BG access mode available. No need for special seq here.`ovm_do(bg_cfg_seq); 

  endtask

  function ovm_sequence get_seq_handle_by_name(string seq_type, string seq_name);

      ovm_factory   m_inst;
      ovm_object    tmp;
      ovm_sequence  seq;

      ovm_report_info(get_full_name(), $psprintf("get_seq_handle_by_name(seq_type=%0s, seq_name=%0s) -- Start", seq_type, seq_name), OVM_DEBUG);
      m_inst = ovm_factory::get();
      tmp    = factory.create_object_by_name(seq_type, "", seq_name);
      if ( !( $cast(seq, tmp) ) ) begin
          ovm_report_fatal(get_full_name(), $psprintf("Couldn't create sequence of type %0s", seq_type));
      end
      ovm_report_info(get_full_name(), $psprintf("get_seq_handle_by_name(seq_type=%0s, seq_name=%0s) -- End", seq_type, seq_name), OVM_DEBUG);
      return seq;

  endfunction : get_seq_handle_by_name

  task adr_flow();

             hqm_pre_adr_seq seq;
     virtual hqm_misc_if     pins;
             string          misc_if_str;
             string          adr_seq_str;

     // -- get pins interface
     if (!p_sequencer.get_config_string("hqm_misc_if_handle", misc_if_str)) begin
         ovm_report_fatal(get_full_name(), $psprintf("get_config_string failed for hqm_misc_if_handle"));
     end
     `sla_get_db(pins, virtual hqm_misc_if, misc_if_str)
     if (pins == null) begin
        ovm_report_fatal(get_full_name(), $psprintf("pins is null"));
     end 
     `ovm_info(get_type_name(), "Starting ADR flow", OVM_LOW);
     seq = new("seq");
     fork
         seq.start(p_sequencer); 
     join_none
     seq.wait_for_sequence_state(BODY);

     // -- Send non-posted requests before asserting ip_pm_adr_req
     seq.send_traffic();
     pins.drive_pm_adr_req(1'b1);
     pins.wait_for_pm_adr_ack();
     seq.check_responses();
     
     // -- Send non-posted requests on IOSF primary after ip_pm_adr_ack has been asserted
     seq.send_traffic();
     seq.check_responses();

     // -- Send non-posted requests on IOSF sideband after ip_pm_adr_ack has been asserted
     sb_traffic();

     // -- Drive pm_adr_req to '0' and move to reset flow
     pins.drive_pm_adr_req(1'b0);
     `ovm_info(get_type_name(), "ADR flow complete", OVM_LOW);
  endtask : adr_flow

  task sb_traffic();

      ovm_report_info(get_full_name(), $psprintf("sb_traffic -- Start"), OVM_DEBUG);
      // -- Send CfgRd0 transaction from SB
      send_sb_cfgrd0(get_reg_addr_sb("vendor_id",              "hqm_pf_cfg_i"));
      send_sb_cfgrd0(get_reg_addr_sb("device_command",         "hqm_pf_cfg_i"));
      send_sb_cfgrd0(get_reg_addr_sb("revision_id_class_code", "hqm_pf_cfg_i"));
      send_sb_cfgrd0(get_reg_addr_sb("cache_line_size",        "hqm_pf_cfg_i"));

      // -- Send MemRd transaction from SB
      send_sb_memrd(get_reg_addr_sb("total_vas",     "hqm_system_csr"));
      send_sb_memrd(get_reg_addr_sb("total_credits", "hqm_system_csr"));
      send_sb_memrd(get_reg_addr_sb("total_ldb_qid", "hqm_system_csr"));
      send_sb_memrd(get_reg_addr_sb("total_dir_qid", "hqm_system_csr"));

      ovm_report_info(get_full_name(), $psprintf("sb_traffic -- End"),   OVM_DEBUG);

  endtask : sb_traffic

  task send_sb_cfgrd0(sla_ral_addr_t reg_addr);

      hqm_iosf_sb_cfg_rd_seq cfg_rd_seq;

      ovm_report_info(get_full_name(), $psprintf("send_sb_cfgrd0(reg_addr=0x%0x) -- Start", reg_addr), OVM_DEBUG);
      cfg_rd_seq = new("cfg_rd_seq");
      if ( !(cfg_rd_seq.randomize() with { addr == reg_addr; exp_rsp == 1; exp_cplstatus == 2'b01; }) ) begin
          ovm_report_fatal(get_full_name(), $psprintf("Randomization failed"));
      end 
      cfg_rd_seq.start(p_sequencer);
      ovm_report_info(get_full_name(), $psprintf("send_sb_cfgrd0(reg_addr=0x%0x) -- End", reg_addr), OVM_DEBUG);

  endtask : send_sb_cfgrd0

  task send_sb_memrd(sla_ral_addr_t reg_addr);

      hqm_iosf_sb_mem_rd_seq mem_rd_seq;

      ovm_report_info(get_full_name(), $psprintf("send_sb_memrd(reg_addr=0x%0x) -- Start", reg_addr), OVM_DEBUG);
      mem_rd_seq = new("mem_rd_seq");
      if ( !(mem_rd_seq.randomize() with { addr == reg_addr; exp_rsp == 1; exp_cplstatus == 2'b01; }) ) begin
          ovm_report_fatal(get_full_name(), $psprintf("Randomization failed"));
      end 
      mem_rd_seq.start(p_sequencer);
      ovm_report_info(get_full_name(), $psprintf("send_sb_memrd(reg_addr=0x%0x) -- End", reg_addr), OVM_DEBUG);

  endtask : send_sb_memrd

endclass
