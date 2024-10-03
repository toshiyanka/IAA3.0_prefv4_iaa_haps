`ifndef HQM_WARM_RESET_SEQUENCE__SV 
`define HQM_WARM_RESET_SEQUENCE__SV

import hqm_tb_sequences_pkg::*;

class hqm_warm_reset_sequence_stim_config extends ovm_object;

    static string stim_cfg_name = "hqm_warm_reset_sequence_stim_config";

    `ovm_object_utils_begin(hqm_warm_reset_sequence_stim_config)
        `ovm_field_int(adr_flow, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
        `ovm_field_int(skip_for_sideband_reset, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_object_utils_end

    `stimulus_config_object_utils_begin(hqm_warm_reset_sequence_stim_config)
        `stimulus_config_field_rand_int(adr_flow)
        `stimulus_config_field_rand_int(skip_for_sideband_reset)
    `stimulus_config_object_utils_end

    rand bit    adr_flow;
    rand bit    skip_for_sideband_reset;

    constraint c_adr_flow { soft adr_flow == 1'b0; }
    constraint c_skip_for_sb_reset { soft skip_for_sideband_reset == 1'b0; }

    function new(string name = "hqm_warm_reset_sequence_stim_config");
        super.new(name);
    endfunction : new

endclass : hqm_warm_reset_sequence_stim_config

// Graceful Warm Reset Sequence and getting out of reset
class hqm_warm_reset_sequence extends ovm_sequence;

  `ovm_sequence_utils(hqm_warm_reset_sequence, sla_sequencer);
  
    bit hqm_illegal_force_pwrgate_pok_sai = $test$plusargs("HQM_ILLEGAL_FORCE_POK_SAI");

    bit hqm_resend_force_pwrgate_pok_sai  = $test$plusargs("HQM_RESEND_FORCE_POK_SAI");

    bit hqm_illegal_resetprep_sai = $test$plusargs("HQM_ILLEGAL_RESETPREP_SAI");

    bit hqm_resend_resetprep_sai  = $test$plusargs("HQM_RESEND_RESETPREP_SAI");

       ovm_event_pool                      global_pool;
       ovm_event                           hqm_ResetPrepAck;
    rand hqm_warm_reset_sequence_stim_config cfg;
   
    rand int wait_cnt;
    rand bit bit_AckNotReqd;
    int num_x_cycles;

    //constraint wait_cnt_range {wait_cnt inside {25,50,100,150,200,250,300,350,400,450,500};}
    constraint wait_cnt_range {wait_cnt inside {150,200,250,300,350,400,450,500};}

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_warm_reset_sequence_stim_config)

  function new(string name = "hqm_warm_reset_sequence");
    super.new(name);
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_ResetPrepAck = global_pool.get("hqm_ResetPrepAck");
    cfg = hqm_warm_reset_sequence_stim_config::type_id::create("hqm_warm_reset_sequence_stim_config");
    apply_stim_config_overrides(0);
  endfunction: new

  hqm_iosf_sb_resetPrep_seq     resetPrep_seq;
  hqm_iosf_sb_forcewake_seq     forcePwrGatePOK_seq;
  hqm_reset_unit_sequence       reset_assert_seq;
  hqm_reset_unit_sequence       reset_prep_ack_seq;

  virtual task body();
    bit           default_strap_no_mgmt_acks;
    bit           default_ip_ready;
    int           delay_forcepok_wait_num;

    super.body();

    default_strap_no_mgmt_acks = 0;
    $value$plusargs("HQM_STRAP_NO_MGMT_ACKS=%d", default_strap_no_mgmt_acks);

    default_ip_ready = 1;
    $value$plusargs("HQM_USE_IP_READY=%d", default_ip_ready);

    delay_forcepok_wait_num=0;
    $value$plusargs("HQM_FORCEPOK_DELAY_NUM=%d", delay_forcepok_wait_num);

    if($test$plusargs("HQM_WARM_RESET_RESETPREP_ACK_REQ")) begin bit_AckNotReqd = 0; end

    if (!$value$plusargs("NUM_X_CYCLES=%0d",num_x_cycles)) num_x_cycles=2;
    `ovm_info(get_type_name(),"Starting hqm_warm_reset_sequence", OVM_LOW);
    apply_stim_config_overrides(1);

    // Prepare IP by sending ResetPrep Message
    if (cfg.adr_flow || cfg.skip_for_sideband_reset) begin
        ovm_report_info(get_type_name(), $psprintf("Skipping ResetPrep; ADR flow is in progress"), OVM_LOW);
    end else begin
        `ovm_info(get_type_name(),"Starting resetPrep_seq", OVM_LOW);
        `ovm_info(get_type_name(),$psprintf("resetPrep_seq control knobs: hqm_illegal_resetprep_sai(0x%0x) and hqm_resend_resetprep_sai(0x%0x) bit_AckNotReqd(%0d)",hqm_illegal_resetprep_sai, hqm_resend_resetprep_sai, bit_AckNotReqd), OVM_LOW);
        `ovm_do_with(resetPrep_seq, {inject_illegal_sai == hqm_illegal_resetprep_sai;AckNotReqd == bit_AckNotReqd;}); 
        `ovm_info(get_type_name(),"Completed resetPrep_seq", OVM_LOW);

        if  (default_strap_no_mgmt_acks==1) begin
            `ovm_do_on_with(reset_prep_ack_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==RESET_PREP_ACKED;}); 
            `ovm_info(get_type_name(),"Completed reset_prep_ack_seq", OVM_MEDIUM);
        end else if (resetPrep_seq.sb_seq.data_i[2][0]) begin 
            fork : checkresetprepack
            begin 
               // Wait for ResetPrepAck messge from IP
               `ovm_info(get_type_name(),"waiting on hqm_ResetPrepAck ", OVM_LOW);
               hqm_ResetPrepAck.wait_trigger();
               `ovm_error(get_type_name(),$psprintf("Got hqm_ResetPrepAck when AckNotReqd was set in resetprep msg"))
            end 
            begin
               repeat(wait_cnt) begin // selecting wait_cnt randomly, to reduce simulation time for regression run
                   @(sla_tb_env::sys_clk_r); 
               end
               `ovm_info(get_type_name(),"Skipping wait on hqm_ResetPrepAck, Resetprep seq had AckNotReqd set", OVM_LOW);
            end 
            join_any
            disable checkresetprepack;
        end else begin 
            if(hqm_resend_resetprep_sai) begin `ovm_do(resetPrep_seq); end

            if(hqm_illegal_resetprep_sai && !hqm_resend_resetprep_sai) begin
                `ovm_info(get_type_name(),"Skipping wait on hqm_ResetPrepAck ", OVM_LOW);
            end else begin 
                // Wait for ResetPrepAck messge from IP
                `ovm_info(get_type_name(),"waiting on hqm_ResetPrepAck ", OVM_LOW);
                hqm_ResetPrepAck.wait_trigger();
                `ovm_info(get_type_name(),"Got hqm_ResetPrepAck ", OVM_LOW);
                repeat(delay_forcepok_wait_num) begin 
                   @(sla_tb_env::sys_clk_r); 
                end
                `ovm_info(get_type_name(),$psprintf("After wait for %0d ns continue... ", delay_forcepok_wait_num), OVM_LOW);
            end
        end 
    end

    // put x on prim_clk; to check that HQM keeps the sticky status bits
    // intact after warm reset
    if($test$plusargs("STICKY_CHK_AFTER_WARM_RST")) put_x_on_prim_clk();

    // Send forcePwrGatePOK message to force an IP to deassert its POK
    `ovm_info(get_type_name(),"Starting forcePwrGatePOK_seq", OVM_LOW);
        `ovm_info(get_type_name(),$psprintf("forcePwrGatePOK_seq control knobs: inject_illegal_sai(0x%0x) && hqm_resend_force_pwrgate_pok_sai(0x%0x)",hqm_illegal_force_pwrgate_pok_sai, hqm_resend_force_pwrgate_pok_sai), OVM_LOW);
    if (cfg.skip_for_sideband_reset == 0) 
      `ovm_do_with(forcePwrGatePOK_seq,{inject_illegal_sai == hqm_illegal_force_pwrgate_pok_sai;}); 
    `ovm_info(get_type_name(),"Completed forcePwrGatePOK_seq", OVM_LOW);

    if(hqm_resend_force_pwrgate_pok_sai) `ovm_do(forcePwrGatePOK_seq)

    // Assert all resets
    `ovm_info(get_type_name(),"Starting reset_assert_seq", OVM_LOW);
    if(hqm_illegal_force_pwrgate_pok_sai && !hqm_resend_force_pwrgate_pok_sai) begin
          `ovm_do_on_with(reset_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==RESET_ASSERT_WITH_ILLEGAL_FORCE_POK;}); 
    end else begin
          `ovm_do_on_with(reset_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==RESET_ASSERT;}); 
    end
    `ovm_info(get_type_name(),"Completed reset_assert_seq", OVM_LOW);

    `ovm_info(get_type_name(),"Done with hqm_warm_reset_sequence", OVM_LOW);

  endtask: body

  task put_x_on_prim_clk();
    chandle force_prim_clk_x_handle;
    chandle force_prim_clkack_handle;
    force_prim_clk_x_handle = SLA_VPI_get_handle_by_name("hqm_tb_top.prim_clk",0);
    force_prim_clkack_handle = SLA_VPI_get_handle_by_name("hqm_tb_top.u_hqm.prim_clkack",0);
        
    repeat(200) begin 
        @(sla_tb_env::sys_clk_r); 
    end
    repeat(num_x_cycles) begin 
        //hqm_seq_put_value(force_prim_clkack_handle, 1'b1);
        hqm_seq_put_value(force_prim_clk_x_handle, 1'bx);
        @(sla_tb_env::sys_clk_r); 
    end
    hqm_seq_put_value(force_prim_clk_x_handle, 1'b0);
  endtask:put_x_on_prim_clk

endclass:hqm_warm_reset_sequence

`endif


