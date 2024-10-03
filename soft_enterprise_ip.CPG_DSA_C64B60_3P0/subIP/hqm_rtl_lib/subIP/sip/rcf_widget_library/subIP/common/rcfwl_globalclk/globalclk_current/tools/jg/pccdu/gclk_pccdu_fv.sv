module gclk_pccdu_fv
   #(
        parameter NUM_OF_GRID_PRI_CLKS = 'd3,           // number of primary grid domain clocks
        parameter NUM_OF_GRID_SEC_CLKS = 'd6,           // number of DOP (secondary) output clocks
        parameter GRID_PRICLK_BITS = 'd4,               // number of bits needed to specify # of pri clocks
        parameter GRID_DIVISOR_BITS = 'd4,              // number of bits needed to specify divisors used by DOPs

        // Matrix to map each DOP clock to the appropriate primary grid. The layout of this sliced parameter is as follows:
        // +--------------------------------------+--------------------------------------+-----+-------------------------+
        // | dopclk[NUM_GRID_SCC-1] pri_grid_clk# | dopclk[NUM_GRID_SCC-1] pri_grid_clk# | ... | dopclk[0] pri_grid_clk# |
        // +--------------------------------------+--------------------------------------+-----+-------------------------+
        parameter [NUM_OF_GRID_SEC_CLKS*GRID_PRICLK_BITS-1:0] GRID_SEC_PRICLK_MATRIX =  
        {4'd2,  // dopclk[5] <- driven by prigrid[2]
         4'd1,  // dopclk[4] <- driven by prigrid[1]
         4'd1,  // dopclk[3] <- driven by prigrid[1]     
         4'd0,  // dopclk[2] <- driven by prigrid[0]
         4'd0,  // dopclk[1] <- driven by prigrid[0]
         4'd0}, // dopclk[0] <- driven by prigrid[0]
         // Matrix to set the divisor for each DOP clock from the corresponding primary grid. The layout of this sliced parameter is as follows:
        // +--------------------------------------+--------------------------------------+-----+-------------------------+
        // | dopclk[NUM_GRID_SCC-1]  dop_divisor# | dopclk[NUM_GRID_SCC-1]  dop_divisor# | ... | dopclk[0]  dop_divisor# |
        // +--------------------------------------+--------------------------------------+-----+-------------------------+
        parameter [NUM_OF_GRID_SEC_CLKS*GRID_DIVISOR_BITS-1:0] GRID_SEC_DIVISOR_MATRIX =        
        {4'd1,  // dopclk[5] <- driven by prigrid[2] / 1
         4'd2,  // dopclk[4] <- driven by prigrid[1] / 2
         4'd1,  // dopclk[3] <- driven by prigrid[1] / 1
         4'd4,  // dopclk[2] <- driven by prigrid[0] / 4
         4'd2,  // dopclk[1] <- driven by prigrid[0] / 2
         4'd1}, // dopclk[0] <- driven by prigrid[0] / 1
        parameter NUM_OF_GRID_NONSCAN_CLKS = 'd0,               // number of DOP free running nonscan divided clocks to instantiate 
        parameter [((NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1) *GRID_PRICLK_BITS )-1:0] GRID_NONSCAN_PRICLK_MATRIX =  '0,
        parameter [((NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1) *GRID_DIVISOR_BITS)-1:0] GRID_NONSCAN_DIVISOR_MATRIX = '0
    )
 (
  // CCDU functional inputs from PLL/PMA
  input  logic  [NUM_OF_GRID_PRI_CLKS-1:0]      fdop_preclk_grid,       // primary grid clock inputs
  input  logic  [NUM_OF_GRID_PRI_CLKS-1:0]      fpm_preclk_div_sync,      // Sync from CDU
  input  logic  [NUM_OF_GRID_SEC_CLKS-1:0]      fpm_dop_clken,              // Clock enable

  // CCDU scan inputs from scan controller
  input  logic                              fscan_mode,
  input  logic                              fscan_rpt_clk,          // Scan clock which toggles during shift only (not during capture)
  input  logic  [NUM_OF_GRID_SEC_CLKS-1:0]  fscan_dop_shift_dis,    // stop the secondary adop_postclk if necessary, per GUCC
  input  logic  [NUM_OF_GRID_SEC_CLKS-1:0]  fscan_dop_clken,          // Clock enable
  input  logic  [NUM_OF_GRID_PRI_CLKS-1:0]  fscan_preclk_div_sync,  // scan controlled div sync, divider reset from scan path, per PRI_CLK, spec will pick one of the GUCC

  // CCDU clock outputs
  input logic  [NUM_OF_GRID_SEC_CLKS-1:0]      adop_postclk,             // Clock to agent (gated by clken)
  input logic  [NUM_OF_GRID_SEC_CLKS-1:0]      adop_postclk_free,        // Clock to agent (free)
  input logic  [(NUM_OF_GRID_NONSCAN_CLKS >0 ? NUM_OF_GRID_NONSCAN_CLKS : 1)-1:0]      adop_postclk_nonscan    // Clock to agent (nonscan free running)
);
   
   logic rst, rst_ff, rst_ff2; //, sync1, sync0;
   default clocking @(posedge fdop_preclk_grid[NUM_OF_GRID_PRI_CLKS-1:0]); endclocking
   default disable iff (rst_ff2);

   always @(posedge fdop_preclk_grid[0]) begin rst_ff <= rst; rst_ff2<=rst_ff; end
 
   property p_trigger(trig, prop, clk, rst);
      @(clk) disable iff(rst) trig |-> prop;
   endproperty : p_trigger

     
   ap1: assume property (p_trigger(rst_ff,   (fpm_preclk_div_sync == 3'b000), posedge fdop_preclk_grid[0], rst));
   ap2: assume property (p_trigger($fell(rst_ff),  (fpm_preclk_div_sync == 3'b111), posedge fdop_preclk_grid[0], rst));
   ap3: assume property (p_trigger(!rst_ff2, (fpm_preclk_div_sync == 3'b000), posedge fdop_preclk_grid[0], rst));

   ap4: assume property (p_trigger(rst_ff,  (fscan_mode == 1'b1),  posedge fdop_preclk_grid[0], rst));
   ap5: assume property (p_trigger(!rst_ff, (fscan_mode == 1'b0),  posedge fdop_preclk_grid[0], rst));

   ap6: assume property (p_trigger(rst_ff,  (fscan_preclk_div_sync == 3'b000), posedge fdop_preclk_grid[0], rst)); //during cycle 0, must be 0
   ap7: assume property (p_trigger(!rst_ff, (fscan_preclk_div_sync == 3'b111), posedge fdop_preclk_grid[0], rst));

   ap8: assume property (p_trigger(rst_ff,  (fpm_dop_clken == 5'h1f), posedge fdop_preclk_grid[0], rst));
   ap9: assume property (p_trigger($fell(rst_ff2),  (fpm_dop_clken == 5'h1f), posedge fdop_preclk_grid[0], rst));

   ap10: assume property (p_trigger(rst_ff,  (fscan_rpt_clk == 1'b1), posedge fdop_preclk_grid[0], rst)); //during cycle 0, must be 0
   ap11: assume property (p_trigger(!rst_ff, (fscan_rpt_clk == 1'b0), posedge fdop_preclk_grid[0], rst));

   
   
//   `ASSUMES_TRIGGER(sync1,  rst_ff, (fpm_preclk_div_sync == 3'b111), posedge fdop_preclk_grid[0], rst);
//   `ASSUMES_TRIGGER(sync0, !rst_ff, (fpm_preclk_div_sync == 3'b000), posedge fdop_preclk_grid[0], rst);
   
   //check ungated output clocks for the specified frequencies (default parameter settings)
   dopclk0_free:  assert property ( fdop_preclk_grid === adop_postclk_free[0] );       // /1
   dopclk1_free:  assert property ( adop_postclk_free[1] |=> !adop_postclk_free[1] );  // /2
   dopclk2a_free: assert property ( (!adop_postclk_free[1] && !adop_postclk_free[2]) |=>  adop_postclk_free[2] );  // /4
   dopclk2b_free: assert property ( ( adop_postclk_free[1] &&  adop_postclk_free[2]) |=>  adop_postclk_free[2] );  // /4
   dopclk2c_free: assert property ( (!adop_postclk_free[1] &&  adop_postclk_free[2]) |=> !adop_postclk_free[2] );  // /4
   dopclk2d_free: assert property ( ( adop_postclk_free[1] && !adop_postclk_free[2]) |=> !adop_postclk_free[2] );  // /4
   dopclk3_free:  assert property ( fdop_preclk_grid === adop_postclk_free[3] );       // /1
   dopclk4_free:  assert property ( adop_postclk_free[4] |=> !adop_postclk_free[4] );  // /2
   dopclk5_free:  assert property ( fdop_preclk_grid === adop_postclk_free[5] );       // /1         

   // check that the enable bits gate the clock
   dopclk0_d:  assert property (  $fell(fpm_dop_clken[0]) |=> !adop_postclk[0] );
   dopclk1_d:  assert property (  $fell(fpm_dop_clken[1]) |=> !adop_postclk[1] );
// dopclk2_d0: assert property (  $fell(fpm_dop_clken[2] && !adop_postclk[2]) |=> !adop_postclk[2][*2] ); // could fall 1 or 2 clks 
// dopclk2_d1: assert property (  $fell(fpm_dop_clken[2] &&  adop_postclk[2]) |=> !adop_postclk[2][*2] ); // after clken
   dopclk3_d : assert property (  $fell(fpm_dop_clken[3]) |=> !adop_postclk[3] );
   dopclk4_d0: assert property (  $fell(fpm_dop_clken[4]) |=> !adop_postclk[4] );
//   dopclk4_d1: assert property (  $fell(fpm_dop_clken[4]) |=> !adop_postclk[1][*2] );
   dopclk5_d : assert property (  $fell(fpm_dop_clken[5]) |=> !adop_postclk[5] );

   
   dopclk0_e:  assert property ( $rose(fpm_dop_clken[0]) |=> (adop_postclk[0] === adop_postclk_free[0]) );
   dopclk1_e:  assert property ( $rose(fpm_dop_clken[1]) |=> (adop_postclk[1] === adop_postclk_free[1]) );
   dopclk2_e:  assert property ( $rose(fpm_dop_clken[2]) |=> (adop_postclk[2] === adop_postclk_free[2]) );
   dopclk3_e:  assert property ( $rose(fpm_dop_clken[3]) |=> (adop_postclk[3] === adop_postclk_free[3]) );
   dopclk4_e:  assert property ( $rose(fpm_dop_clken[4]) |=> (adop_postclk[4] === adop_postclk_free[4]) );
   dopclk5_e:  assert property ( $rose(fpm_dop_clken[5]) |=> (adop_postclk[5] === adop_postclk_free[5]) );

   
endmodule // gclk_pccdu_fv

bind gclk_pccdu gclk_pccdu_fv fvmod (.*);                                   