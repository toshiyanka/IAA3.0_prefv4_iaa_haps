// reuse-pragma startSub [InsertComponentPrefix %subText 7]
module hqm_AW_reset_core #(


  // reuse-pragma startSub NUM_GATED [ReplaceParameter -design hqm_AW_reset_core -lib work -format systemverilog NUM_GATED -endTok , -indent "  "]
  parameter NUM_GATED = 1
,
  // reuse-pragma endSub NUM_GATED
   // reuse-pragma startSub NUM_INP_GATED [ReplaceParameter -design hqm_AW_reset_core -lib work -format systemverilog NUM_INP_GATED -endTok , -indent " "]
 parameter NUM_INP_GATED = 1
,
 // reuse-pragma endSub NUM_INP_GATED
  // reuse-pragma startSub NUM_PATCH_GATED [ReplaceParameter -design hqm_AW_reset_core -lib work -format systemverilog NUM_PATCH_GATED -endTok , -indent " "]
 parameter NUM_PATCH_GATED = 1
,
 // reuse-pragma endSub NUM_PATCH_GATED
  // reuse-pragma startSub NUM_PGSB [ReplaceParameter -design hqm_AW_reset_core -lib work -format systemverilog NUM_PGSB -endTok , -indent " "]
 parameter NUM_PGSB = 1
,
 // reuse-pragma endSub NUM_PGSB
  // reuse-pragma startSub NO_PGCB [ReplaceParameter -design hqm_AW_reset_core -lib work -format systemverilog NO_PGCB -endTok "" -indent " "]
 parameter NO_PGCB = 0


 // reuse-pragma endSub NO_PGCB
 ) (
  input  logic                                  fscan_rstbypen
, input  logic                                  fscan_byprst_b

, input  logic                                  hqm_pgcb_clk
, output logic [ ( NUM_PGSB ) - 1 : 0 ]         hqm_pgcb_rst_n
, output logic                                  hqm_pgcb_rst_n_start

, input  logic                                  hqm_inp_gated_clk
, input  logic                                  hqm_inp_gated_rst_b
, output logic [ ( NUM_INP_GATED ) - 1 : 0 ]    hqm_inp_gated_rst_n

, input  logic                                  hqm_gated_clk
, input  logic                                  hqm_gated_rst_b
, output logic [ ( NUM_GATED ) - 1 : 0 ]        hqm_gated_rst_n
, output logic                                  hqm_gated_rst_n_start
, output logic                                  hqm_gated_rst_n_active
, input  logic                                  hqm_gated_rst_n_done

, input logic                                   hqm_flr_prep
, output logic                                  rst_prep

) ;

assign rst_prep = hqm_flr_prep ;

generate
 if ( NO_PGCB == 0 ) begin : hqm_pgcb_g_no
  for ( genvar g = 0 ; g < NUM_PGSB ; g = g + 1 ) begin : hqm_pgcb_g
    hqm_AW_reset_sync_scan i_hqm_pgcb_g (
    .clk            ( hqm_pgcb_clk )
  , .rst_n          ( hqm_gated_rst_b )
  , .fscan_rstbypen ( fscan_rstbypen )
  , .fscan_byprst_b ( fscan_byprst_b )
  , .rst_n_sync     ( hqm_pgcb_rst_n [ g ] )
    ) ;
  end
 end else begin : hqm_pgcb_g
  assign hqm_pgcb_rst_n = '0 ;
 end
endgenerate

// NOTE: hqm_inp_gated_rst_n is also used internally to reset the active flop
generate
 for ( genvar g = 0 ; g < NUM_INP_GATED ; g = g + 1 ) begin : hqm_inp_gated_g
  hqm_AW_reset_sync_scan i_hqm_inp_gated_g (
    .clk            ( hqm_inp_gated_clk )
  , .rst_n          ( hqm_inp_gated_rst_b )
  , .fscan_rstbypen ( fscan_rstbypen )
  , .fscan_byprst_b ( fscan_byprst_b )
  , .rst_n_sync     ( hqm_inp_gated_rst_n [ g ] )
  ) ;
 end
endgenerate

generate
 for ( genvar g = 0 ; g < NUM_GATED ; g = g + 1 ) begin : hqm_gated_g
  hqm_AW_reset_sync_scan i_hqm_gated_g (
    .clk            ( hqm_gated_clk )
  , .rst_n          ( hqm_gated_rst_b )
  , .fscan_rstbypen ( fscan_rstbypen )
  , .fscan_byprst_b ( fscan_byprst_b )
  , .rst_n_sync     ( hqm_gated_rst_n [ g ] )
  ) ;
 end
endgenerate

// hqm_gated RST & PF reset control
//       reset active - asserted from begining of hqm_gate_rst until reset_done asserted, used to turn on local clocks 
//       reset start - used to start PF reset state machine, asserted 4 clocks after hqm_gated_rst_n is deasserted AND hqm_gated_clk are on
//       reset done - new input to signal PF reset SM is complete, will deasserte reset active

logic hqm_gated_rst_n_active_f , hqm_gated_rst_n_active_nxt ;

//..................................................
// create hqm_gated_rst_active, use this to turn on & keep on local clocks

always_ff @ ( posedge hqm_inp_gated_clk or negedge hqm_inp_gated_rst_n ) begin
  if ( ! hqm_inp_gated_rst_n ) begin
    hqm_gated_rst_n_active_f <= 1'b1 ;
  end else begin
    hqm_gated_rst_n_active_f <= hqm_gated_rst_n_active_nxt ;
  end
end
assign hqm_gated_rst_n_active     = hqm_gated_rst_n_active_f ;
assign hqm_gated_rst_n_active_nxt = hqm_gated_rst_n_active_f & ( ~ hqm_gated_rst_n_done ) ;

//..................................................
//create hqm_gated_rst_n_start 
// when local hqm_gated_clk clock is on create hqm_gated_rst_n_start to initiate PF reset SM
// which 

logic hqm_gated_rst_n_trigger0_f , hqm_gated_rst_n_trigger0_nxt ;
logic hqm_gated_rst_n_trigger1_f , hqm_gated_rst_n_trigger1_nxt ;
logic hqm_gated_rst_n_start0_f ,   hqm_gated_rst_n_start0_nxt ;
logic hqm_gated_rst_n_start1_f ,   hqm_gated_rst_n_start1_nxt ;
logic hqm_gated_rst_n_start2_f ,   hqm_gated_rst_n_start2_nxt ;
logic hqm_gated_rst_n_start3_f ,   hqm_gated_rst_n_start3_nxt ;

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n [ 0 ] ) begin
  if ( ! hqm_gated_rst_n [ 0 ] ) begin
    hqm_gated_rst_n_trigger0_f <= '0 ;
    hqm_gated_rst_n_trigger1_f <= '0 ;
    hqm_gated_rst_n_start0_f   <= '0 ;
    hqm_gated_rst_n_start1_f   <= '0 ;
    hqm_gated_rst_n_start2_f   <= '0 ;
    hqm_gated_rst_n_start3_f   <= '0 ;
  end else begin
    hqm_gated_rst_n_trigger0_f <= hqm_gated_rst_n_trigger0_nxt ;
    hqm_gated_rst_n_trigger1_f <= hqm_gated_rst_n_trigger1_nxt ;
    hqm_gated_rst_n_start0_f   <= hqm_gated_rst_n_start0_nxt ;
    hqm_gated_rst_n_start1_f   <= hqm_gated_rst_n_start1_nxt ;
    hqm_gated_rst_n_start2_f   <= hqm_gated_rst_n_start2_nxt ;
    hqm_gated_rst_n_start3_f   <= hqm_gated_rst_n_start3_nxt ;
  end
end

always_comb begin
  hqm_gated_rst_n_trigger0_nxt = 1'b1 ;
  hqm_gated_rst_n_trigger1_nxt = hqm_gated_rst_n_trigger0_f ;
  hqm_gated_rst_n_start0_nxt   = ( hqm_gated_rst_n_trigger0_f & ~ hqm_gated_rst_n_trigger1_f ) | hqm_gated_rst_n_start0_f ;
  hqm_gated_rst_n_start1_nxt   = hqm_gated_rst_n_start0_f ;
  hqm_gated_rst_n_start2_nxt   = hqm_gated_rst_n_start1_f ;
  hqm_gated_rst_n_start3_nxt   = hqm_gated_rst_n_start2_f ;
  hqm_gated_rst_n_start        = hqm_gated_rst_n_start3_f ;
end

////////////////////////////////////////////////////////////////////////////////////////////////////

generate
 if ( NO_PGCB == 0 ) begin : hqm_pgcb_g_no2

  logic hqm_pgcb_rst_n_trigger0_f , hqm_pgcb_rst_n_trigger0_nxt ;
  logic hqm_pgcb_rst_n_trigger1_f , hqm_pgcb_rst_n_trigger1_nxt ;
  logic hqm_pgcb_rst_n_start0_f ,   hqm_pgcb_rst_n_start0_nxt ;
  logic hqm_pgcb_rst_n_start1_f ,   hqm_pgcb_rst_n_start1_nxt ;
  logic hqm_pgcb_rst_n_start2_f ,   hqm_pgcb_rst_n_start2_nxt ;
  logic hqm_pgcb_rst_n_start3_f ,   hqm_pgcb_rst_n_start3_nxt ;

  always_ff @ ( posedge hqm_pgcb_clk or negedge hqm_pgcb_rst_n [ 0 ] ) begin
   if ( ! hqm_pgcb_rst_n [ 0 ] ) begin
    hqm_pgcb_rst_n_trigger0_f <= '0 ;
    hqm_pgcb_rst_n_trigger1_f <= '0 ;
    hqm_pgcb_rst_n_start0_f   <= '0 ;
    hqm_pgcb_rst_n_start1_f   <= '0 ;
    hqm_pgcb_rst_n_start2_f   <= '0 ;
    hqm_pgcb_rst_n_start3_f   <= '0 ;
   end else begin
    hqm_pgcb_rst_n_trigger0_f <= hqm_pgcb_rst_n_trigger0_nxt ;
    hqm_pgcb_rst_n_trigger1_f <= hqm_pgcb_rst_n_trigger1_nxt ;
    hqm_pgcb_rst_n_start0_f   <= hqm_pgcb_rst_n_start0_nxt ;
    hqm_pgcb_rst_n_start1_f   <= hqm_pgcb_rst_n_start1_nxt ;
    hqm_pgcb_rst_n_start2_f   <= hqm_pgcb_rst_n_start2_nxt ;
    hqm_pgcb_rst_n_start3_f   <= hqm_pgcb_rst_n_start3_nxt ;
   end
  end

  always_comb begin
   hqm_pgcb_rst_n_trigger0_nxt = 1'b1 ;
   hqm_pgcb_rst_n_trigger1_nxt = hqm_pgcb_rst_n_trigger0_f ;
   hqm_pgcb_rst_n_start0_nxt   = ( hqm_pgcb_rst_n_trigger0_f & ~ hqm_pgcb_rst_n_trigger1_f ) | hqm_pgcb_rst_n_start0_f ;
   hqm_pgcb_rst_n_start1_nxt   = hqm_pgcb_rst_n_start0_f ;
   hqm_pgcb_rst_n_start2_nxt   = hqm_pgcb_rst_n_start1_f ;
   hqm_pgcb_rst_n_start3_nxt   = hqm_pgcb_rst_n_start2_f ;
   hqm_pgcb_rst_n_start        = hqm_pgcb_rst_n_start3_f ;
  end

 end else begin : hqm_pgcb_g2

  assign hqm_pgcb_rst_n_start = '0 ;

 end
endgenerate

endmodule

