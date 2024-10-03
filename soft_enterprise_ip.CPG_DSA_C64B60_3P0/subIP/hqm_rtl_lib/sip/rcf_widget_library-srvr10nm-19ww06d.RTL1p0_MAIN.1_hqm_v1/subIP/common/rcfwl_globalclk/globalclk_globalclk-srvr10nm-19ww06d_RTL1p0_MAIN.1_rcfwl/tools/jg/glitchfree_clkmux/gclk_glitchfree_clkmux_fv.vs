module gclk_glitchfree_clkmux_fv (
                 
               input logic x12clk,
               input logic agentclk,
               input logic x12clk_sync,
               input logic agentclk_sync,
               input logic iso_b,
               input logic clk_out,
               input logic sync_out
);

    // Artificial high-speed clock to enable catching glitches
    logic fastclk, rst;

    default clocking @(posedge fastclk); endclocking
    default disable iff (rst);

    // Assume x12clk and agentclk each last 4 fastclk cycles,
    // but not necessarily synced with each other
    as1: assume property ($changed(x12clk) |=> $stable(x12clk)[*3]);
    as2: assume property (not ($stable(x12clk)[*4]));
    as3: assume property ($changed(agentclk) |=> $stable(agentclk)[*3]);
    as4: assume property (not ($stable(agentclk)[*4]));

    // Assume iso_b & sync signals don't change very often
    as5: assume property ($changed(iso_b) |=> $stable(iso_b)[*10]);
    as6: assume property ($changed(x12clk_sync) |=> $stable(x12clk_sync)[*10]);
    as7: assume property ($changed(agentclk_sync) |=> $stable(agentclk_sync)[*10]);

    // Sync signals are synced to their corresponding clks
    sync1: assume property ($changed(x12clk_sync) |-> $rose(x12clk));
    sync2: assume property ($changed(agentclk_sync) |-> $rose(agentclk));

    // Just need to check rise of iso_b
    isob_never_falls: assume property (iso_b |=> iso_b); 
    isob_starts_at_0:  assume property ($past(rst) |-> (iso_b==0)[*10]);
    clksync_starts_at_0:  assume property ($past(rst) |-> (x12clk_sync==0));
    agentsync_starts_at_0:  assume property ($past(rst) |-> (agentclk_sync==0));

    // Assertion to check if 1-fastclk "pulse" of clk_out is ruled out
    // Use ##10 to avoid boundary conditions just after reset
    glitch_assert: assert property (##60 $changed(clk_out) |-> $stable(clk_out)[*2]);

endmodule

bind gclk_glitchfree_clkmux gclk_glitchfree_clkmux_fv fvmod (.*);
