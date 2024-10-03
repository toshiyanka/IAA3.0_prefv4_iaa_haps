// cct.20150909 from PCIE3201509090088BEKB0.tar drop - partial
// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_iosf_gcgu

    import hqm_system_type_pkg::*;
(
    input  logic                    prim_freerun_clk,
    input  logic                    prim_gated_rst_b,
    input  logic                    prim_nonflr_clk,

    input  logic                    flr_treatment,
                                   
    input  logic                    csr_clkgaten,
    input  logic [7:0]              csr_idlecnt,

    input  logic [2:0]              ism_fabric,
    output logic [2:0]              ism_agent,
    output logic                    prim_clkreq,
    input  logic                    prim_clkack,
                                   
    input  logic                    agent_idle,
    input  logic                    agent_clkreq,
    input  logic                    agent_clkreq_async,

    output logic                    credit_init,
    input  logic                    credit_init_done,
                                   
    input  logic                    prim_pok,                // Power OK
    input  logic                    prim_ism_lock_b,         // ISM lock
                                   
    input  logic                    force_notidle,
    input  logic                    force_idle,
    input  logic                    force_clkreq,
    input  logic                    force_creditreq,         // Missing added by jbdiethe based on SB hqm_sbcism style

    input  logic                    dfx_scanrstbypen,
    input  logic                    dfx_scanrst_b,

    input  logic                    tgt_has_unret_credits   // Unreturned Credit Flag
);

localparam logic [2:0] CREDIT_REQ     = 3'b100;
localparam logic [2:0] CREDIT_INIT_ST = 3'b101;
localparam logic [2:0] CREDIT_ACK     = 3'b110;                // same as CREDIT_DONE
localparam logic [2:0] CREDIT_DONE    = 3'b110;                // same as CREDIT_ACK
localparam logic [2:0] IDLE_ST        = 3'b000;
localparam logic [2:0] ACTIVE_REQ     = 3'b010;
localparam logic [2:0] ACTIVE         = 3'b011;
localparam logic [2:0] IDLE_REQ       = 3'b001;                // same as IDLE_NAK
localparam logic [2:0] IDLE_NAK       = 3'b001;                // same as IDLE_REQ

logic [2:0] ism_agent_nxt;

logic clkreq;
logic clkreq_sync;
logic clkack;

logic force_notidle_sync, force_idle_sync, force_creditreq_sync;

hqm_AW_ctech_doublesync_rstb force_sync_inst0 (
    .clk    (prim_freerun_clk),
    .rstb   (prim_gated_rst_b),
    .d      (force_creditreq),
    .o      (force_creditreq_sync)
);

hqm_AW_ctech_doublesync_rstb force_sync_inst2 (
    .clk    (prim_freerun_clk),
    .rstb   (prim_gated_rst_b),
    .d      (force_idle),
    .o      (force_idle_sync)
);

hqm_AW_ctech_doublesync_rstb force_sync_inst3 (
    .clk    (prim_freerun_clk),
    .rstb   (prim_gated_rst_b),
    .d      (force_notidle),
    .o      (force_notidle_sync)
);

logic clkack_sync;

hqm_AW_ctech_doublesync_rstb agent_clkack_async_inst (
    .clk    (prim_freerun_clk),
    .rstb   (prim_gated_rst_b),
    .d      (clkack),
    .o      (clkack_sync)
);

logic pending_credit_init_done;

always_ff @(posedge prim_nonflr_clk, negedge prim_gated_rst_b)
    if (!prim_gated_rst_b)
        pending_credit_init_done <= '0;
    else if (~pending_credit_init_done & credit_init_done)
        pending_credit_init_done <= '1;
    else if ((ism_agent == CREDIT_INIT_ST) & (ism_agent_nxt == CREDIT_DONE))
        pending_credit_init_done <= '0;

logic [7:0] count;
logic count_done;

logic idle; always_comb idle = (agent_idle | force_idle_sync) & ~force_notidle_sync;

// qualify with agent_done in case we become non-idle when the count expires
always_comb 
    count_done = (count == csr_idlecnt) & idle & (ism_fabric == ACTIVE);

always_ff @(posedge prim_nonflr_clk, negedge prim_gated_rst_b)
    if (!prim_gated_rst_b)
        count <= '0;
    else if ((ism_fabric != ACTIVE) | (ism_agent != ACTIVE) | ~idle)
        count <= '0;
    else if ((ism_fabric == ACTIVE) & (ism_agent == ACTIVE) & idle & ~count_done)
        count <= count + 8'd1;

logic credits_initialized;
always_ff @(posedge prim_nonflr_clk, negedge prim_gated_rst_b)
    if (!prim_gated_rst_b)
        credits_initialized <= '0;
    else if ((ism_agent == CREDIT_INIT_ST) & (ism_agent_nxt != CREDIT_INIT_ST))
        credits_initialized <= '1;

always_comb begin

    ism_agent_nxt = ism_agent;

    case (ism_agent) 

      CREDIT_REQ:
        if (ism_fabric == CREDIT_ACK)
            ism_agent_nxt = CREDIT_INIT_ST;

      CREDIT_INIT_ST:
        if ((ism_fabric == CREDIT_INIT_ST) & pending_credit_init_done & clkreq_sync & clkack_sync)
            ism_agent_nxt = CREDIT_DONE;
        
      CREDIT_DONE:
        if (ism_fabric == IDLE_ST)
            ism_agent_nxt = IDLE_ST;

      IDLE_ST:
        if ((~credits_initialized | force_creditreq_sync) & prim_pok & prim_ism_lock_b)
            ism_agent_nxt = CREDIT_REQ;
        else if (prim_pok & prim_ism_lock_b & (ism_fabric == ACTIVE_REQ))
            ism_agent_nxt = ACTIVE_REQ; // CCT update 10302014 created this arc to ACTIVE which
                                        // causes compliance issues for CPM logic changing it to
                                        // goto ACTIVE_REQ which is how it was on CPM 1.7 jbdiethe
                                        // IOSF actually loses credits when we go straight to ACTIVE.
                                        // This seems like a performance optimization to bring the
                                        // ISM active quicker. Hence the old behavior should be acceptable.
        else if (prim_pok & prim_ism_lock_b & ~idle & clkreq_sync & clkack_sync)
            ism_agent_nxt = ACTIVE_REQ;

      ACTIVE_REQ:
        if (ism_fabric == ACTIVE_REQ)
            ism_agent_nxt = ACTIVE;
        else if (ism_fabric == CREDIT_REQ)
            ism_agent_nxt = CREDIT_REQ;

      ACTIVE:
        // HSD4377668 - not waiting for clkreq=1 before leaving ACTIVE
        if (count_done & clkreq_sync & clkack_sync & ~tgt_has_unret_credits) 
            ism_agent_nxt = IDLE_REQ;

      IDLE_REQ:
        if (ism_fabric == IDLE_ST)
            ism_agent_nxt = IDLE_ST;
        else if (ism_fabric == IDLE_NAK)
            ism_agent_nxt = ACTIVE;
      
    endcase
  end

localparam logic [2:0] ISM_DEFAULT = IDLE_ST;

always_ff @(posedge prim_nonflr_clk, negedge prim_gated_rst_b)
    if (!prim_gated_rst_b)
        ism_agent <= ISM_DEFAULT;
    else
        ism_agent <= ism_agent_nxt;

always_ff @(posedge prim_nonflr_clk, negedge prim_gated_rst_b)
    if (!prim_gated_rst_b)
        credit_init <= '0;
    else if ((ism_agent == CREDIT_REQ) & (ism_agent_nxt == CREDIT_INIT_ST))
        credit_init <= '1;
    else if (credit_init_done)
        credit_init <= '0;

logic predfx_async_clkreq_set_b, async_clkreq_set_b;

assign predfx_async_clkreq_set_b = ~(force_clkreq | agent_clkreq_async);

// Need a scan mux on this internal reset

hqm_AW_reset_mux i_async_clkreq_set_b (
    .rst_in_n       (predfx_async_clkreq_set_b),
    .fscan_rstbypen (dfx_scanrstbypen),
    .fscan_byprst_b (dfx_scanrst_b),
    .rst_out_n      (async_clkreq_set_b)
);

logic async_clkreq, async_clkreq_sync;

hqm_AW_ctech_doublesync_setb async_clkreq_inst (
    .clk    (prim_freerun_clk),
    .setb   (async_clkreq_set_b),
    .d      (1'b0),
    .o      (async_clkreq)
);

hqm_AW_ctech_doublesync_rstb async_clkreq_sync_inst (
    .clk    (prim_freerun_clk),
    .rstb   (prim_gated_rst_b),
    .d      (async_clkreq),
    .o      (async_clkreq_sync)
);

logic ism_clkreq; 

always_comb ism_clkreq = (ism_agent_nxt != IDLE_ST);

logic predfx_clkreq_set_b, clkreq_set_b, clkreq_pre;

always_comb begin

    // jbdiethe The PGCB block needs async_clkreq to be 1 during reset not 'X
    //   Added prim_gated_rst_b term to insure when prim_gated_rst_b is asserted clkreq is always high

    // Leaving old comment above

    // If clocks are currently off (clkack==0) this is the combinatorial path
    // that will combinatorially assert the clkreq.
    // Note that clocks may still be on even if clkack_sync is off.

    // Combinatorially force the clkreq on if clock gating is not enabled, the
    // primary reset is asserted, or the dfx force is asserted.
    // The primary reset and fdx paths assert asynchronously but deassert
    // synchronously, while the other paths are all synchronous assert/deassert.

    predfx_clkreq_set_b = ~(~clkack_sync & (ism_clkreq      | agent_clkreq |
                                            (~csr_clkgaten) | async_clkreq));
end

// Need a scan mux on this internal reset

hqm_AW_reset_mux i_clkreq_set_b (
    .rst_in_n       (predfx_clkreq_set_b),
    .fscan_rstbypen (dfx_scanrstbypen),
    .fscan_byprst_b (dfx_scanrst_b),
    .rst_out_n      (clkreq_set_b)
);

// IOSF SPEC 1.1 - page 99 
// Rule 2. All IOSF agent primary interface outputs are driven directly off of
// a flop without any combinatorial load on the output flop.[RA197] The only
// exception to this rule is the prim_clkreq output signal.  Note: The only
// requirement on prim_clkreq and prim_clkack signals is that they should be
// glitch free. A possible compliant implementation where this signal may not
// be driven from a flop is when deassertion is controlled by a flop output
// in prim_clk domain but assertion is controlled from a flop in a different
// clock domain, and the prim_clkreq signal is an OR of these signals.
//
// clkreq_pre is in the prim_clk domain, (clkreq_set_b and agent_clkreq_sync are 
// in the cpp_clk domain. Thus Assertion of clkreq is potentially p_clk domain, 
// whereas deassertion is always in the prim_clk domain.

// These are the signals that keep the clkreq asserted once it is already set.
// When these conditions deassert the clkreq can be deasserted.

// This flop overrides the reset value of clkack_sync just to ensure we load
// a good zero into the clkreq flops during reset.

logic clkack_sync_init;

always_ff @(posedge prim_freerun_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  clkack_sync_init <= '1;
 end else begin
  clkack_sync_init <= clkack_sync;
 end
end

assign clkreq_pre = clkreq & (ism_clkreq | agent_clkreq      | (~csr_clkgaten) |
                                           async_clkreq_sync | (~clkack_sync_init));

always_ff @(posedge prim_freerun_clk or negedge clkreq_set_b) begin
 if (!clkreq_set_b) begin
  prim_clkreq <= '1;
 end else begin
  prim_clkreq <= clkreq_pre | flr_treatment;
 end
end

always_ff @(posedge prim_freerun_clk or negedge clkreq_set_b) begin
 if (!clkreq_set_b) begin
  clkreq <= '1;
 end else begin
  clkreq <= clkreq_pre | flr_treatment;
 end
end

hqm_AW_ctech_doublesync_rstb i_clkreq_sync (
     .clk   (prim_freerun_clk)
    ,.rstb  (prim_gated_rst_b)
    ,.d     (clkreq)
    ,.o     (clkreq_sync)
);

assign clkack = prim_clkack;

// Instrumentation code

`ifdef INTEL_INST_ON

    // ISM State machine used in hqm_iosf_gcgu

    typedef enum logic [2:0] {
        A_CREDIT_REQ                    = 3'b100,
        A_CREDIT_INIT_                  = 3'b101,
        A_CREDIT_DONE                   = 3'b110, // same as CREDIT_ACK
        A_IDLE_                         = 3'b000,
        A_ACTIVE_REQ                    = 3'b010,
        A_ACTIVE                        = 3'b011,
        A_IDLE_REQ                      = 3'b001  // same as IDLE_NAK
    } hqm_ism_agent_fsm_t; 
    
    typedef enum logic [2:0] {
        F_CREDIT_REQ                    = 3'b100,
        F_CREDIT_INIT_                  = 3'b101,
        F_CREDIT_ACK                    = 3'b110, // same as CREDIT_DONE
        F_IDLE_                         = 3'b000,
        F_ACTIVE_REQ                    = 3'b010,
        F_ACTIVE                        = 3'b011,
        F_IDLE_NAK                      = 3'b001  // same as IDLE_REQ
    } hqm_ism_fabric_fsm_t; 
    
    hqm_ism_agent_fsm_t                 ism_agent_ps;
    hqm_ism_fabric_fsm_t                ism_fabric_ps;

    assign ism_agent_ps                 = hqm_ism_agent_fsm_t'(ism_agent);
    assign ism_fabric_ps                = hqm_ism_fabric_fsm_t'(ism_fabric);
  
`endif

endmodule

