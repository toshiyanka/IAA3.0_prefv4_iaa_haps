module hqm_tap_rtdr_clk_generator #(
    parameter NAME = "TAP",
    parameter PERIOD_PS = 10000,
    parameter SKEW_PS = 0)
    ();

    timeunit 1ps;

    localparam string EN_PLUS_ARG = {NAME,"_CLK_EN"};
    localparam string PERIOD_PLUS_ARG = {NAME,"_CLK_PERIOD"};
    localparam string SKEW_PLUS_ARG = {NAME,"_CLK_SKEW"};

    logic enable, free_clk, clk_out;
    bit [31:0] clk_period, clk_skew;

    initial begin

        enable      = 'b0;
        free_clk    = 'b0;
        clk_period  = PERIOD_PS;
        clk_skew    = SKEW_PS;

        if ($test$plusargs(PERIOD_PLUS_ARG)) begin
            $value$plusargs({PERIOD_PLUS_ARG,"=%d"}, clk_period);
            $display("%m: Overriding %s clock period to '%0d'", NAME, clk_period);
        end

        if ($test$plusargs(SKEW_PLUS_ARG)) begin
            $value$plusargs({SKEW_PLUS_ARG,"=%d"}, clk_skew);
            $display("%m: Overriding %s clock skew to '%0d'", NAME, clk_skew);
        end

        if ($test$plusargs(EN_PLUS_ARG)) begin
            enable = 1;
            $display("%m: Enabling %s clock with period '%0d' and skew '%0d'", NAME, clk_period, clk_skew);
        end else
            $display("%m: Disabling %s clock", NAME);

        // inject clock skew at time=0
        #(clk_skew)
        clk_skew = 'h0;

        // begin clock generation
        forever begin

            // next two lines allow user to inject
            // skew while clock is running
            #(clk_skew);
            clk_skew = 'h0;

            // oscillate the clock signal at
            // a rate of half the clock period
            #(clk_period/2);
            free_clk = ~free_clk;

        end

    end

    always_comb clk_out = (enable) ? free_clk : 'b0;

endmodule : hqm_tap_rtdr_clk_generator


module hqm_tap_rtdr_clock_interface #(
    parameter TCLK_PERIOD_PS        = 10000,  //100MHz
    parameter TCLK_SKEW_PS          = 0,
    parameter STF_PERIOD_PS         = 2500,   //400MHz
    parameter STF_SKEW_PS           = 2500,
    parameter CLK_POSTSCRIPT        = "",
    parameter TAP_COUNT             = 1,
    parameter STF_COUNT             = 1,
    parameter TRST_N_INITIAL_VALUE  = "1'b0",
    parameter TDO_PHASE_DELAY       = 0       //--TDO_PHASE_DELAY       = 1
    )

    (input logic tap_pg_rst_b, tap_clk_gate, stf_clk_gate);

    timeunit 1ps;

    logic tap_clk, stf_clk;

    hqm_tap_rtdr_clk_generator #(.NAME({"TAP",CLK_POSTSCRIPT}), .PERIOD_PS(TCLK_PERIOD_PS), .SKEW_PS(TCLK_SKEW_PS)) tap_clk_gen();
    assign tap_clk = tap_clk_gen.clk_out && tap_clk_gate;

    hqm_tap_rtdr_clk_generator #(.NAME({"STF",CLK_POSTSCRIPT}), .PERIOD_PS(STF_PERIOD_PS), .SKEW_PS(STF_SKEW_PS)) stf_clk_gen();
    assign stf_clk = stf_clk_gen.clk_out && stf_clk_gate;

    genvar jtag_bfm_inst;
    for (jtag_bfm_inst=0; jtag_bfm_inst<TAP_COUNT; jtag_bfm_inst++) begin : jtag_bfm
        logic TRST_N;
        logic TCK;
        logic TMS;
        logic TDI;
        logic TDO;

        logic [2:0] TAP_RTDR_TDI;
        logic [2:0] TAP_RTDR_TDO;
        logic [2:0] TAP_RTDR_CAPTURE;
        logic [2:0] TAP_RTDR_SHIFT;
        logic [2:0] TAP_RTDR_UPDATE;
        logic [2:0] TAP_RTDR_IRDEC;

        JtagBfmIntf #(`HQM_RTDR_VAL_ENV_JTAG_BFM_PARAMETERS) jtag_pin_intfc (tap_pg_rst_b, tap_clk);
        JtagBfmTestIsland #(.TAPVIF("*.jtag_bfm_agent*"), `HQM_RTDR_VAL_ENV_JTAG_BFM_PARAMETERS) jtag_bfm_ti (jtag_pin_intfc);
        initial begin
            // if not a DFT test, assert TRST_N
            if (!$test$plusargs("TAP_CLK_EN") && !$test$plusargs("STF_CLK_EN")) begin
                $display("%m: Non-DFT simulation, keeping TAP in reset");
                TRST_N = 1'b0;
            // otherwise use the parameterized TRST_N value
            end else begin
                $display("%m: DFT simulation, TRST_N initial value = 1'b%s", TRST_N_INITIAL_VALUE);
                TRST_N = TRST_N_INITIAL_VALUE;
            end
        end
        always @(jtag_pin_intfc.trst_b or tap_pg_rst_b) begin
            if ($test$plusargs("TAP_TRST_0") ) begin
            TRST_N = 1'b0;
            end else begin
            TRST_N = jtag_pin_intfc.trst_b & tap_pg_rst_b;
            end
        end
        assign TCK = jtag_pin_intfc.tck;
        assign TMS = jtag_pin_intfc.tms;
        assign TDI = jtag_pin_intfc.tdi;

        assign TAP_RTDR_TDI[2:0]     = jtag_pin_intfc.tap_rtdr_tdi[2:0];
        assign TAP_RTDR_IRDEC[2:0]   = jtag_pin_intfc.tap_rtdr_irdec[2:0];
        assign TAP_RTDR_CAPTURE[2:0] = jtag_pin_intfc.tap_rtdr_capture[2:0];
        assign TAP_RTDR_SHIFT[2:0]   = jtag_pin_intfc.tap_rtdr_shift[2:0];
        assign TAP_RTDR_UPDATE[2:0]  = jtag_pin_intfc.tap_rtdr_update[2:0];


        if (TDO_PHASE_DELAY) begin: g_pd1
            always @(negedge jtag_pin_intfc.tck) begin
                jtag_pin_intfc.tdo = TDO;
            end
        end else begin: g_npd1
            always @(TDO) begin
                jtag_pin_intfc.tdo = TDO;
            end
        end

        if (TDO_PHASE_DELAY) begin: g_pd2
            always @(negedge jtag_pin_intfc.tap_rtdr_tck) begin
                jtag_pin_intfc.tap_rtdr_tdo[0] = TAP_RTDR_TDO[0];
            end
        end else begin: g_npd2
            always @(TAP_RTDR_TDO[0]) begin
                jtag_pin_intfc.tap_rtdr_tdo[0] = TAP_RTDR_TDO[0];
            end
        end

        if (TDO_PHASE_DELAY) begin: g_pd3
            always @(negedge jtag_pin_intfc.tap_rtdr_tck) begin
                jtag_pin_intfc.tap_rtdr_tdo[1] = TAP_RTDR_TDO[1];
            end
        end else begin: g_npd3
            always @(TAP_RTDR_TDO[1]) begin
                jtag_pin_intfc.tap_rtdr_tdo[1] = TAP_RTDR_TDO[1];
            end
        end

        if (TDO_PHASE_DELAY) begin: g_pd4
            always @(negedge jtag_pin_intfc.tap_rtdr_tck) begin
                jtag_pin_intfc.tap_rtdr_tdo[2] = TAP_RTDR_TDO[2];
            end
        end else begin: g_npd4
            always @(TAP_RTDR_TDO[2]) begin
                jtag_pin_intfc.tap_rtdr_tdo[2] = TAP_RTDR_TDO[2];
            end
        end

    end : jtag_bfm

    
endmodule : hqm_tap_rtdr_clock_interface
