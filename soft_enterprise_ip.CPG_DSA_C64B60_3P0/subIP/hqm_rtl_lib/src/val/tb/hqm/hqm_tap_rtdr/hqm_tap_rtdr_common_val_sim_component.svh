class hqm_tap_rtdr_common_val_sim_component extends ovm_component;

    protected bit tap_en = 0;
    protected bit stf_en = 0;

    `ovm_component_utils(hqm_tap_rtdr_common_val_sim_component)

    function new(string name, ovm_component parent);

        super.new(name, parent);

        if ($test$plusargs("TAP_CLK_EN")) begin
            tap_en = 1;
            `ovm_info("HQM_TAP_RTDR_COMMON_VAL_COMP", "TAP test enabled", OVM_NONE)
        end

        if ($test$plusargs("STF_CLK_EN")) begin
            stf_en = 1;
            `ovm_info("HQM_TAP_RTDR_COMMON_VAL_COMP", "STF test enabled", OVM_NONE)
        end

        //check_itpp_file_paths();

    endfunction : new

    function void build();
        super.build();
        `ovm_info("HQM_TAP_RTDR_COMMON_VAL_COMP", "Inside OVM build() function", OVM_NONE)
    endfunction : build

    function void connect();
        super.connect();
        `ovm_info("HQM_TAP_RTDR_COMMON_VAL_COMP", "Inside OVM connect() function", OVM_NONE)
    endfunction : connect

    function void end_of_elaboration();
        super.end_of_elaboration();
        `ovm_info("HQM_TAP_RTDR_COMMON_VAL_COMP", "Inside OVM end_of_elaboration() function", OVM_NONE)
    endfunction : end_of_elaboration

    function void start_of_simulation();
        super.start_of_simulation();
        `ovm_info("HQM_TAP_RTDR_COMMON_VAL_COMP", "Inside OVM start_of_simulation() function", OVM_NONE)
        sla_tb_env::get_top_tb_env().report_server.set_max_quit_count(0);
    endfunction : start_of_simulation

    function automatic bit tap_enabled();
        return tap_en;
    endfunction : tap_enabled

    function automatic bit stf_enabled();
        return stf_en;
    endfunction : stf_enabled

    function void check_itpp_file_paths();

        int    fstream;
        string itpp_file, macro_file, pin_file;

        `ovm_info("HQM_TAP_RTDR_COMMON_VAL_COMP", "Checking ITPP file paths", OVM_NONE)

        if (!$value$plusargs("ITPP_FILE=%s", itpp_file))
            `ovm_fatal("SPF_ITPP_READER_ERROR", "Must specify input ITPP file from command line!")

        fstream = $fopen(itpp_file, "r");
        if (!fstream)
            `ovm_fatal("SPF_ITPP_PARSER_ERROR", $psprintf("Error opening itpp file '%s'", itpp_file))
        $fclose(fstream);

        if ($value$plusargs("ITPP_MACRO_FILE=%s", macro_file)) begin
            fstream = $fopen(macro_file, "r");
            if (!fstream)
            `ovm_fatal("SPF_ITPP_PARSER_ERROR", $psprintf("Error opening macro file '%s'", macro_file))
            $fclose(fstream);
        end

        if ($value$plusargs("ITPP_PINMAP_FILE=%s", pin_file)) begin
            fstream = $fopen(pin_file, "r");
            if (!fstream)
                `ovm_fatal("SPF_ITPP_PARSER_ERROR", $psprintf("Error opening pin map file '%s'", pin_file))
            $fclose(fstream);
        end

   endfunction : check_itpp_file_paths

endclass : hqm_tap_rtdr_common_val_sim_component
