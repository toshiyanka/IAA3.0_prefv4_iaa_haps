//--------------------------------------------------------------------------------------//
//    FILENAME        : pcgu_fpv_wrapper.sv
//    DESIGNER        : amshah2
//    PROJECT         : PCGU Generic Val RTL Collateral
//    DATE            : 10/21/2013
//    PURPOSE         : Wrapper Design for PCGU FPV
//    REVISION NUMBER : 0.5
//----------------------------- Revision History ---------------------------------------//
//
//      Date        Rev     Owner     Description
//      --------    ---     -----     ---------------------------------------------------
//      10/21/2013  0.51    amshah2   Included the following:
//-------------------------------------------------------------------------------------//
`timescale 1ns/1ns

module pgcbcg_fpv_tb #(
    ICDC             = 5,
    NCDC             = 4,
    PGCB_FREQ        = 1,
    CDC_FREQ_2X      = 2,
    CDC_FREQ_8X      = 4,
    CDC_FREQ_CX      = 6,
    CDC_FREQ_14X     = 10,
    IGCLK_REQ_ASYNC  = 5,
    NGCLK_REQ_ASYNC  = 5 
       )(
//CLOCK
    input  logic                         clock,
    input  logic                         reset_b,

    input  logic[IGCLK_REQ_ASYNC-1:0]    iosf_cdc_gclock_req_async,
    input  logic[NGCLK_REQ_ASYNC-1:0]    non_iosf_cdc_gclock_req_async,

    input  logic[IGCLK_REQ_ASYNC-1:0]    iosf_cdc_gclock_ack_async,
    input  logic[NGCLK_REQ_ASYNC-1:0]    non_iosf_cdc_gclock_ack_async,
    
    input  logic[ICDC-1:0]               iosf_cdc_clkreq,   
    input  logic[ICDC-1:0]               iosf_cdc_clkack,   
    input  logic[ICDC-1:0][2:0]          iosf_cdc_ism_fabric,

    input  logic[NCDC-1:0]               non_iosf_cdc_clkreq,   
    input  logic[NCDC-1:0]               non_iosf_cdc_clkack,   

    input  logic                         pwrgate_disabled, 
    input  logic                         pmc_ip_wake,
    input  logic                         pgcb_pok,
    input  logic                         pgcb_idle,
    
    input  logic[3:0]                    cfg_t_clkgate,
    input  logic[3:0]                    cfg_t_clkwake,
    input  logic                         cfg_acc_clkgate_disabled,

    output logic[31:0]   		 visa_bus
    
    );

    logic            clk_2X, clk_8X, clk_CX, clk_14X;
    logic [ICDC-1:0] icdc_clocks, reset_aggr;
 
    pcgu_clk_gen #( .FREQ(PGCB_FREQ)) u_pcgu_clk_gen_2x (.clock(clock), .reset_b(reset_b), .pgcb_clkreq(pgcb_clkreq), .pgcb_clkack(pgcb_clkack), .clk_out(clk_pgcb_2X));
    
    icdc_clk_gen #(.FREQ(CDC_FREQ_2X))  u_icdc_clk_gen_2X (.clock(clock), .reset_b(reset_b), .clk_out(clk_2X));
    icdc_clk_gen #(.FREQ(CDC_FREQ_8X))  u_icdc_clk_gen_8X (.clock(clock), .reset_b(reset_b), .clk_out(clk_8X));
    icdc_clk_gen #(.FREQ(CDC_FREQ_CX))  u_icdc_clk_gen_CX (.clock(clock), .reset_b(reset_b), .clk_out(clk_CX));
    icdc_clk_gen #(.FREQ(CDC_FREQ_14X)) u_icdc_clk_gen_14X(.clock(clock), .reset_b(reset_b), .clk_out(clk_14X));

    assign icdc_clocks = {clock, clk_2X, clk_8X, clk_CX, clk_14X};
    assign reset_aggr  = {ICDC{reset_b}};                                                        //AGGREGATE "reset_b" AVOID VCS WARN.

    pgcb_ctech_doublesync_rstmux
        i_pgcb_doublesync_rstmux_b (
                                    .clk(clk_pgcb_2X),
                                    .clr_b(reset_b),
                                    .rst_bypass_b(1'b1),
                                    .rst_bypass_sel(1'b0), 
                                    .q(pgcb_rst_b)
                                   );

   
    pgcbcg #(
        .ICDC             (ICDC),
        .NCDC             (NCDC),
        .IGCLK_REQ_ASYNC  (IGCLK_REQ_ASYNC),
        .NGCLK_REQ_ASYNC  (NGCLK_REQ_ASYNC)    
    )
    u_pgcbcg (
        .pgcb_clk(clk_pgcb_2X),                                                                   //MODELLED IN WRAPPER RTL
        .pgcb_clkreq(pgcb_clkreq),                                                                //OUTPUT FROM PCGU WIDGET
        .pgcb_clkack(pgcb_clkack),                                                                //MODELLED IN WRAPPER RTL
        .pgcb_rst_b(pgcb_rst_b),                                                                  //GEN BC - Model going through reset synchr
        .iosf_cdc_clock(icdc_clocks[ICDC-1:0]),                                                   //MODELLED IN WRAPPER RTL
        .iosf_cdc_reset_b(reset_aggr[ICDC-1:0]),                                                  //GEN BC
        .iosf_cdc_clkack(iosf_cdc_clkack[ICDC-1:0]),                                              //FPV TO RANDOMIZE
        .non_iosf_cdc_clkack(non_iosf_cdc_clkack[NCDC-1:0]),                                      //FPV TO RANDOMIZE
        .iosf_cdc_clkreq(iosf_cdc_clkreq[ICDC-1:0]),                                              //FPV TO RANDOMIZE
        .non_iosf_cdc_clkreq(non_iosf_cdc_clkreq[NCDC-1:0]),                                      //FPV TO RANDOMIZE
        .iosf_cdc_gclock_req_async(iosf_cdc_gclock_req_async[IGCLK_REQ_ASYNC-1:0]),               //FPV TO RANDOMIZE
        .non_iosf_cdc_gclock_req_async(non_iosf_cdc_gclock_req_async[NGCLK_REQ_ASYNC-1:0]),       //FPV TO RANDOMIZE
        .iosf_cdc_gclock_ack_async(iosf_cdc_gclock_ack_async[IGCLK_REQ_ASYNC-1:0]),               //FPV TO RANDOMIZE
        .non_iosf_cdc_gclock_ack_async(non_iosf_cdc_gclock_ack_async[NGCLK_REQ_ASYNC-1:0]),       //FPV TO RANDOMIZE
        .iosf_cdc_ism_fabric(iosf_cdc_ism_fabric[ICDC-1:0]),                                      //FPV TO RANDOMIZE
        .async_pwrgate_disabled(pwrgate_disabled),                                                //FPV TO RANDOMIZE
        .pmc_pg_wake(pmc_ip_wake),                                                                //FPV TO RANDOMIZE
        .pgcb_pok(pgcb_pok),                                                                      //ASSUMES CORELATING POK/IDLE
        .pgcb_idle(pgcb_idle),                                                                    //ASSUMES CORELATING POK/IDLE
        .cfg_acc_clkgate_disabled(cfg_acc_clkgate_disabled),                                    //FPV TO RANDOMIZE
        .cfg_t_clkgate(cfg_t_clkgate),                                                            //FPV TO RANDOMIZE
        .cfg_t_clkwake(cfg_t_clkwake),                                                            //FPV TO RANDOMIZE
        .fscan_byprst_b('1),
        .fscan_rstbypen('0),
        .fscan_clkungate('0),
        .pgcb_gclk(),
        .visa_bus(visa_bus),
        .*
    );
 `ifdef ASSERT_ON
    `include "pgcbcg_fpv_tb.sva"
  `endif
endmodule //END PCGU_FPV_WRAPPER
