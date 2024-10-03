
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

class hcw_processing_with_intermediate_flr_seq extends sla_sequence_base;

  `ovm_sequence_utils(hcw_processing_with_intermediate_flr_seq, sla_sequencer)

  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;
  hqm_pp_cq_status              i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed
  sla_ral_env                   ral;

  //hcw_perf_dm_test1_hcw_seq dm_test1_hcw_seq;
  hcw_perf_dir_ldb_test1_hcw_seq dir_ldb_test1_hcw_seq;
  hqm_tb_cfg_file_mode_seq  i_cfg3_file_mode_seq;
  hqm_tb_cfg_file_mode_seq  i_cfg4_file_mode_seq;
  hqm_sla_pcie_flr_sequence flr_seq;
  ral_pfrst_seq             rst_hqm_cfg;
  hqm_sla_pcie_init_seq     hqm_pcie_init;
  int                       flr_wait_num;

  function new(string name = "hcw_processing_with_intermediate_flr_seq");
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
    int flr_count;
    bit flr_with_hcw_process_on; 
    sla_ral_reg _reg_; sla_ral_data_t _ral_data_;

    //-----------------------------
    //-- get i_hqm_pp_cq_status
    //-----------------------------
    get_hqm_pp_cq_status_handle();
  
    //-----------------------------
    //-- get_hcw_tb_scoreboard_handle 
    //-----------------------------
    get_hcw_tb_scoreboard_handle();

    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."));
     _reg_     = ral.find_reg_by_file_name("pcie_cap_device_control", "hqm_pf_cfg_i");

	if(!$value$plusargs("HQM_PF_FLR_COUNT=%d",flr_count)) flr_count = 1;
        if(!$value$plusargs("HQM_PF_FLR_WITH_HCW_PROCESS_ON=%d",flr_with_hcw_process_on)) flr_with_hcw_process_on=1'b_0;
        if(!$value$plusargs("HQM_PF_FLR_WAITNUM=%d",flr_wait_num)) flr_wait_num = `HQM_PF_FLR_WAIT_WITH_HCW;
      `ovm_info(get_full_name(),$psprintf("Starting perf_dm_test1_hcw_seq before series of FLR(s) #(0x%0x) with flr_with_hcw_process_on=(0x%0x), flr_wait_num=%0d",flr_count,flr_with_hcw_process_on, flr_wait_num),OVM_LOW);

    fork
     begin 
        `ovm_do(dir_ldb_test1_hcw_seq); 
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
   
    // -- end

    `ovm_info(get_full_name(),$psprintf("Starting PF FLR %0d number of times", flr_count),OVM_LOW);

    if(flr_count > 0) begin		
      repeat(flr_count) begin
        `ovm_do(flr_seq);
        `ovm_info(get_full_name(),$psprintf("flr_seq_S1: flr_seq_issued_done"),OVM_LOW);
  
        `ovm_do(rst_hqm_cfg);
        `ovm_info(get_full_name(),$psprintf("flr_seq_S2: rst_hqm_cfg_done"),OVM_LOW);
  
        `ovm_do(hqm_pcie_init);
        `ovm_info(get_full_name(),$psprintf("flr_seq_S3: hqm_pcie_init_done"),OVM_LOW);
  
  
  	 //i_hcw_scoreboard.hcw_scoreboard_reset();
         _ral_data_='h_0; _ral_data_[15]=1'b_1;
         _reg_.set_tracking_val(_ral_data_);  // -- To reset active_seq_cnt in pp_cq_base_seq -- //
         wait_sys_clk(10);
         `ovm_info(get_full_name(),$psprintf("flr_seq_S4: flr_seq_done"),OVM_LOW);
      end

      `ovm_info(get_full_name(),$psprintf("Finish PF FLR %0d number of times, reset sb and hqm_pp_cq_status", flr_count),OVM_LOW);
      i_hcw_scoreboard.hcw_scoreboard_reset();

      //-- check hqm_pp_cq_status.cq_int and clear it
      for(int kk=0; kk<64; kk++) begin
         if(i_hqm_pp_cq_status.cq_int_received(1, kk) == 1) begin 
           `ovm_info(get_full_name(),$psprintf("Get_hqm_pp_cq_status.cq_int[%0d] mailbox ", kk),OVM_LOW);
            wait_sys_clk(1);
            i_hqm_pp_cq_status.wait_for_cq_int(1, kk); //ldb_cq[kk]
         end
      end 
    end

    `ovm_info(get_full_name(),$psprintf("Done PF FLR %0d number of times along with: hqm_cfg reset, hcw_scoreboard reset and ral reset",flr_count),OVM_LOW);
   
    // -- if($test$plusargs("HQM_DM_CFG_AFTER_PF_FLR")) begin
      wait_sys_clk(20); 
      i_cfg4_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hqm_tb_cfg4_file_mode_seq");
      i_cfg4_file_mode_seq.set_cfg("HQM_SEQ_CFG4", 1'b0);
      i_cfg4_file_mode_seq.start(get_sequencer());
      wait_sys_clk(20); 
      `ovm_do(dir_ldb_test1_hcw_seq); 
    // -- end

    super.body();

  endtask

endclass
