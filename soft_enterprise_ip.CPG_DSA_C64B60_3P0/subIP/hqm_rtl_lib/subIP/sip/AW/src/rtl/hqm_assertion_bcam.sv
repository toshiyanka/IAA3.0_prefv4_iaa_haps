//
// common design to be used in assertion code (cycle accurate BCAM )
//
module hqm_assertion_bcam #
 ( 
parameter ENTRIES = 256
, parameter AWIDTH = 8
, parameter DWIDTH = 26
 ) ( 
input logic clk
, input logic rst_n
, input logic FUNC_WR_CLK_RF_IN_P0
, input logic FUNC_WEN_RF_IN_P0
, input logic [ AWIDTH - 1 : 0 ] FUNC_WR_ADDR_RF_IN_P0
, input logic [ DWIDTH - 1 : 0 ] FUNC_WR_DATA_RF_IN_P0
, input logic FUNC_CM_CLK_RF_IN_P0
, input logic FUNC_CEN_RF_IN_P0
, input logic [ DWIDTH - 1 : 0 ] FUNC_CM_DATA_RF_IN_P0
, output logic [ ENTRIES - 1 : 0 ] CM_MATCH_RF_OUT_P0
 ) ;

logic FUNC_WEN_RF_IN_P0_f ;
logic [ AWIDTH - 1 : 0 ] FUNC_WR_ADDR_RF_IN_P0_f ;
logic [ DWIDTH - 1 : 0 ] FUNC_WR_DATA_RF_IN_P0_f ;
logic FUNC_CEN_RF_IN_P0_f ;
logic [ DWIDTH - 1 : 0 ] FUNC_CM_DATA_RF_IN_P0_f ;
logic [ ( ENTRIES * DWIDTH ) - 1 : 0 ] bcam_nxt , bcam_f ;
always_ff @( posedge FUNC_WR_CLK_RF_IN_P0 ) begin
 FUNC_WEN_RF_IN_P0_f <= FUNC_WEN_RF_IN_P0 ;
 FUNC_WR_ADDR_RF_IN_P0_f <= FUNC_WR_ADDR_RF_IN_P0 ;
 FUNC_WR_DATA_RF_IN_P0_f <= FUNC_WR_DATA_RF_IN_P0 ;
 FUNC_CEN_RF_IN_P0_f <= FUNC_CEN_RF_IN_P0 ;
 FUNC_CM_DATA_RF_IN_P0_f <= FUNC_CM_DATA_RF_IN_P0 ;
end
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    bcam_f <= '0 ;
  end
  else begin
    bcam_f <= bcam_nxt ;
  end
end

always_comb begin
 bcam_nxt = bcam_f ;

 //lookup
 CM_MATCH_RF_OUT_P0 = '0 ;
 if ( FUNC_CEN_RF_IN_P0_f ) begin
 for ( int i = 0 ; i < 256 ; i = i + 1 ) begin
 if ( bcam_f [ ( i * DWIDTH ) +: DWIDTH ] == FUNC_CM_DATA_RF_IN_P0_f ) begin
 CM_MATCH_RF_OUT_P0 [ i ] = 1'b1 ;
 end 
 end
 end

 //write
 if ( FUNC_WEN_RF_IN_P0 ) begin 
 bcam_nxt [ ( FUNC_WR_ADDR_RF_IN_P0 * DWIDTH ) +: DWIDTH ] = FUNC_WR_DATA_RF_IN_P0 ;
 end
end
endmodule 
