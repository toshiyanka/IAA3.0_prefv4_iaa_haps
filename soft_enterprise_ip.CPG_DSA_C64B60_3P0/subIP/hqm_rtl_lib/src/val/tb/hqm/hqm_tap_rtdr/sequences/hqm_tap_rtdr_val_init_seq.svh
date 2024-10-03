class hqm_tap_rtdr_val_init_seq extends ovm_sequence;

    hqm_tap_rtdr_common_val_env_pkg::hqm_tap_rtdr_common_val_env           hqm_tap_rtdr_env;
    hqm_tap_rtdr_common_val_tb_pkg::hqm_tap_rtdr_common_val_sim_component  hqm_tap_rtdr_sim_comp;

    JtagBfmPkg::JtagBfmSequencer                                           tap_sqr;

    `ovm_sequence_utils(hqm_tap_rtdr_val_init_seq, sla_sequencer)

    //----------------------------------------
    //--new()
    //----------------------------------------
    function new(string name = "hqm_tap_rtdr_val_init_seq");

        super.new(name);

        `sla_assert($cast(hqm_tap_rtdr_env, sla_utils::get_comp_by_name("i_hqm_tap_rtdr_common_val_env")), ("Could not find HQM_TAP_RTDR common val env"))
        if (hqm_tap_rtdr_env == null)
            `ovm_error("HQM_TAP_RTDR_VAL_INIT_ERROR", "hqm_tap_rtdr_env object is null")
        else
            `ovm_info("HQM_TAP_RTDR_VAL_INIT", "hqm_tap_rtdr_env object obtained", OVM_NONE)

        `sla_assert($cast(hqm_tap_rtdr_sim_comp, sla_utils::get_comp_by_name("hqm_tap_rtdr_val_sim_comp")), ("Could not find HQM_TAP_RTDR common sim comp"))
        if (hqm_tap_rtdr_sim_comp == null)
            `ovm_error("HQM_TAP_RTDR_VAL_INIT_ERROR", "hqm_tap_rtdr_sim_comp object is null")
        else
            `ovm_info("HQM_TAP_RTDR_VAL_INIT", "hqm_tap_rtdr_sim_comp object obtained", OVM_NONE)

        //if (hqm_tap_rtdr_sim_comp.tap_enabled()) begin
            `sla_assert($cast(tap_sqr, hqm_tap_rtdr_env.get_jtag_bfm_sequencer()), ("Could not find JTAG BFM sequencer"))
            if (tap_sqr == null)
                `ovm_error("HQM_TAP_RTDR_VAL_INIT_ERROR", "tap_sqr object is null")
            else
                `ovm_info("HQM_TAP_RTDR_VAL_INIT", "tap_sqr object obtained", OVM_NONE)
        //end else begin
        //        `ovm_info("HQM_TAP_RTDR_VAL_INIT", "hqm_tap_rtdr_sim_comp.tap_enabled=0", OVM_NONE)
        //end
    endfunction : new


    //----------------------------------------
    //--body()
    //----------------------------------------
    task body();
         TapSequenceReset       Tap_reset_seq;
         TapSequencePrimaryOnly Tap_SP_seq;
         TapDataLoadSeq_T0      Tap_dataload_seq;

        `ovm_info("HQM_TAP_RTDR_VAL_INIT", "Inside HQM_TAP_RTDR val init sequence", OVM_NONE)

        `ovm_info("HQM_TAP_RTDR_VAL_INIT", "Call TapSequenceReset ", OVM_NONE)
         `ovm_do_on(Tap_reset_seq, tap_sqr)

         //--
         if ($test$plusargs("has_tap_sp_seq")) begin
           `ovm_info("HQM_TAP_RTDR_VAL_INIT", "Call TapSequencePrimaryOnly", OVM_NONE)
           `ovm_do_on(Tap_SP_seq, tap_sqr)
         end

         //--
         if ($test$plusargs("has_tap_dataload_seq")) begin
           `ovm_info("HQM_TAP_RTDR_VAL_INIT", "Call TapDataLoadSeq_T0", OVM_NONE)
           `ovm_do_on(Tap_dataload_seq, tap_sqr)
         end

        `ovm_info("HQM_TAP_RTDR_VAL_INIT", "HQM_TAP_RTDR val init sequence completed", OVM_NONE)




//        if (hqm_tap_rtdr_sim_comp.tap_enabled()) begin
//
//            itpp_reader_pkg::itpp_tap_idle_seq tap_idle_seq;
//            itpp_reader_pkg::itpp_tap_reset_seq tap_rst_seq;
//
//            `ovm_info("DFT_VAL_INIT", "Start of TAP init sequence", OVM_NONE)
//
//            `ovm_info("DFT_VAL_INIT", "Running TAP powergood reset sequence", OVM_NONE)
//            `ovm_do_on_with(tap_rst_seq, tap_sqr, {mode == 2'b11;})
//
//            `ovm_info("DFT_VAL_INIT", "Waiting 10 TCKs after TAP powergood reset sequence", OVM_NONE)
//            `ovm_do_on_with(tap_idle_seq, tap_sqr, {count == 10;})
//
//            `ovm_info("DFT_VAL_INIT", "Running TAP hard reset sequence", OVM_NONE)
//            `ovm_do_on_with(tap_rst_seq, tap_sqr, {mode == 2'b01;})
//
//            `ovm_info("DFT_VAL_INIT", "Waiting 10 TCKs after TAP hard reset sequence", OVM_NONE)
//            `ovm_do_on_with(tap_idle_seq, tap_sqr, {count == 10;})
//
//            `ovm_info("DFT_VAL_INIT", "TAP init sequence completed", OVM_NONE)
//
//        end // tap_enabled()


    endtask : body


endclass : hqm_tap_rtdr_val_init_seq;


function void add_hqm_tap_rtdr_val_init_phase(string itpp_test_phase = "USER_DATA_PHASE");

    string dft_init_phase;
    sla_tb_env top_tb_env;
    sla_phase_name_t test_phases[$];

     $value$plusargs("ITPP_TEST_PHASE=%s", itpp_test_phase);
     `ovm_info("ADD_DFT_VAL_INIT_FUNCTION_INFO", $psprintf("Detected ITPP phase '%s'", itpp_test_phase), OVM_NONE)

     dft_init_phase = (itpp_test_phase == "USER_DATA_PHASE") ? "DATA_PHASE" : itpp_test_phase;
     top_tb_env.add_test_phase("DFT_VAL_INIT_PHASE", dft_init_phase, "BEFORE");
     top_tb_env.set_test_phase_type(top_tb_env.get_name(), "DFT_VAL_INIT_PHASE", "hqm_tap_rtdr_val_init_seq");

endfunction : add_hqm_tap_rtdr_val_init_phase
