// This testbench is used to validate the PCGU module standalone using FPV
// The main function it provides is the ability to gate the trunk clock seen by the PCGU

module pcgu_fpv_tb
    #(
        parameter DEF_PWRON   = 0               // If set, pgcb_clkreq will be asserted in reset
    )
    (
        input logic      pgcb_trunk_en,

        // Clocks & Resets ----------
        input logic      pgcb_clk,              // PGCB clock
        input logic      pgcb_rst_b,            // Rise-edge Synced PGCB reset
        output logic     pgcb_clkreq,           // PGCB Clock CLKREQ
        input logic      pgcb_clkack,           // PGCB Clock CLKACK

        // Hysteresis Delay
        input logic [3:0] t_clkgate,            // PGCB Clock Gating 
        input logic [3:0] t_clkwake,            // PGCB Clock Wake 
        // ECO Bits
        input logic [7:0] scratchpad,           // Scratchpad
        
        // PGCB Clock Gate and Wake Interface ----------
        input logic      sync_gate,             // Gate
        input logic      async_wake_b,          // Wake   
        output logic      sync_clkvld,          // Clock Valid
        
        // PGCB Interface ----------
        input logic     pgcb_pok,               // pgcb_pok output of PGCB
        input logic     async_pmc_ip_wake,      // Unsynchronized version of pmc_ip_wake directly from PMC

        // DFx ----------
        output logic [15:0]   pcgu_visa         // Visa Vector
);
logic pgcb_gated_clk, pgcb_rst_sync_b;

   pgcb_ctech_clock_gate pgcb_clk_gate (
      .en(pgcb_trunk_en),
      .te(1'b0),
      .clk(pgcb_clk),
      .enclk(pgcb_gated_clk)
   );
        
   pgcb_ctech_doublesync_rstmux pgcb_rst_sync (
      .clk(pgcb_gated_clk), 
      .clr_b(pgcb_rst_b), 
      .rst_bypass_b(1'b0),
      .rst_bypass_sel(1'b0), 
      .q(pgcb_rst_sync_b)
   );


pcgu 
    #(
        .DEF_PWRON(DEF_PWRON)               // If set, pgcb_clkreq will be asserted in reset
    )
    pcgu1
    (
        .pgcb_clk(pgcb_gated_clk),
        .pgcb_rst_b(pgcb_rst_sync_b),
        .fscan_byprst_b(1'b0),
        .fscan_rstbypen(1'b0),
        .*
    );


trunk_en: assume property (@(posedge pgcb_clk) disable iff (pgcb_rst_b !== 1)
   pgcb_clkack |-> pgcb_trunk_en
);

trunk_en_8clk: assume property (@(posedge pgcb_clk) disable iff (pgcb_rst_b !== 1)
   $fell(pgcb_clkack) |-> pgcb_trunk_en [*8]
);

endmodule
