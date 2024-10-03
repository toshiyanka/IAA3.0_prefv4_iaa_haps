module hqm_bcam
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
#(
  parameter HQM_AQED_CNT = 8
, parameter HQM_AQED_AWIDTH = 8
, parameter HQM_AQED_DWIDTH = 26 //qid:7 + hid:16 + v:1 parity:1 spare:1
, parameter HQM_AQED_ENTRIES = 256
, parameter HQM_AQED_IWIDTH = 3
//
, parameter HQM_AQED_ENTRIESB2 = AW_logb2 ( HQM_AQED_ENTRIES - 1 ) + 1
) (
  input  logic                                  clk
, input  logic                                  rst_n

, output logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ]           FUNC_WEN_RF_IN_P0
, output logic [ ( HQM_AQED_CNT * HQM_AQED_AWIDTH ) - 1 : 0 ]      FUNC_WR_ADDR_RF_IN_P0
, output logic [ ( HQM_AQED_CNT * HQM_AQED_DWIDTH ) - 1 : 0 ]      FUNC_WR_DATA_RF_IN_P0

, output logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ]           FUNC_CEN_RF_IN_P0
, output logic [ ( HQM_AQED_CNT * HQM_AQED_DWIDTH ) - 1 : 0 ]      FUNC_CM_DATA_RF_IN_P0
, input  logic [ ( HQM_AQED_CNT * HQM_AQED_ENTRIES ) - 1 : 0 ]     CM_MATCH_RF_OUT_P0

, input  logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ]           in_valid
, input  logic [ ( HQM_AQED_CNT * 2 ) - 1 : 0 ]           in_op
, input  logic [ ( HQM_AQED_CNT * 11 ) - 1 : 0 ]          in_fid
, input  logic [ ( HQM_AQED_CNT * 7 ) - 1 : 0 ]           in_qid
, input  logic [ ( HQM_AQED_CNT * 16 ) - 1 : 0 ]          in_hid

, output logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ]           out_valid
, output logic [ ( HQM_AQED_CNT * 2 ) - 1 : 0 ]           out_op
, output logic [ ( HQM_AQED_CNT * 11 ) - 1 : 0 ]          out_fid
, output logic [ ( HQM_AQED_CNT * 7 ) - 1 : 0 ]           out_qid
, output logic [ ( HQM_AQED_CNT * 16 ) - 1 : 0 ]          out_hid

, output logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ]           out_hit
, output logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ]           out_vac

, output logic [ ( ( HQM_AQED_CNT * 2 ) + 2 ) - 1 : 0 ]   error  

, output logic [ ( ( HQM_AQED_CNT * 1 ) ) - 1 : 0 ]       init_active
, output logic [ ( ( HQM_AQED_CNT * 1 ) ) - 1 : 0 ]       notempty
);

localparam HQM_AQED_OP_ENQ_CEN = 2'd1 ;
localparam HQM_AQED_OP_ENQ_WEN = 2'd2 ;
localparam HQM_AQED_OP_CMP_WEN = 2'd3 ;

localparam HQM_AQED_ERR_VALID_MULTIPLE = 0 ;
localparam HQM_AQED_ERR_LOOKUP_HIT_MULTIPLE = 1 ;

logic [ ( HQM_AQED_CNT * 2 )  - 1 : 0 ] mux_error ;
logic [ ( 2 ) - 1 : 0 ] error_cond ;

logic [ ( 8 * 3 ) - 1 : 0 ] bcam_inst ;
assign bcam_inst [ ( 0 * 3 ) +: 3 ] = 3'd0 ;
assign bcam_inst [ ( 1 * 3 ) +: 3 ] = 3'd1 ;
assign bcam_inst [ ( 2 * 3 ) +: 3 ] = 3'd2 ;
assign bcam_inst [ ( 3 * 3 ) +: 3 ] = 3'd3 ;
assign bcam_inst [ ( 4 * 3 ) +: 3 ] = 3'd4 ;
assign bcam_inst [ ( 5 * 3 ) +: 3 ] = 3'd5 ;
assign bcam_inst [ ( 6 * 3 ) +: 3 ] = 3'd6 ;
assign bcam_inst [ ( 7 * 3 ) +: 3 ] = 3'd7 ;

generate
  for ( genvar g = 0 ; g < HQM_AQED_CNT ; g = g + 1 ) begin : gen000
    hqm_bcam_core #(
      .HQM_AQED_AWIDTH ( HQM_AQED_AWIDTH )
    , .HQM_AQED_DWIDTH ( HQM_AQED_DWIDTH )
    , .HQM_AQED_ENTRIES ( HQM_AQED_ENTRIES )
    , .HQM_AQED_IWIDTH ( HQM_AQED_IWIDTH )
    ) i_hqm_bcam_core (
      .clk ( clk )
    , .rst_n ( rst_n )
    , .bcam_inst ( bcam_inst [ ( g * 3 ) +: 3 ] )

    , .FUNC_WEN_RF_IN_P0 ( FUNC_WEN_RF_IN_P0 [ ( g * 1 ) +: 1 ] )
    , .FUNC_WR_ADDR_RF_IN_P0 ( FUNC_WR_ADDR_RF_IN_P0 [ ( g * HQM_AQED_AWIDTH ) +: HQM_AQED_AWIDTH ] )
    , .FUNC_WR_DATA_RF_IN_P0 ( FUNC_WR_DATA_RF_IN_P0 [ ( g * HQM_AQED_DWIDTH ) +: HQM_AQED_DWIDTH ] )

    , .FUNC_CEN_RF_IN_P0 ( FUNC_CEN_RF_IN_P0 [ ( g * 1 ) +: 1 ] )
    , .FUNC_CM_DATA_RF_IN_P0 ( FUNC_CM_DATA_RF_IN_P0 [ ( g * HQM_AQED_DWIDTH ) +: HQM_AQED_DWIDTH ] )
    , .CM_MATCH_RF_OUT_P0 ( CM_MATCH_RF_OUT_P0 [ ( g * HQM_AQED_ENTRIES ) +: HQM_AQED_ENTRIES ] )

    , .in_valid ( in_valid [ ( g * 1 ) +: 1 ] )
    , .in_op ( in_op [ ( g * 2 ) +: 2 ] )
    , .in_fid ( in_fid [ ( g * 11 ) +: 11 ] )
    , .in_qid ( in_qid [ ( g * 7 ) +: 7 ] )
    , .in_hid ( in_hid [ ( g * 16 ) +: 16 ] )

    , .out_valid ( out_valid [ ( g * 1 ) +: 1 ] )
    , .out_op ( out_op [ ( g * 2 ) +: 2 ] )
    , .out_fid ( out_fid [ ( g * 11 ) +: 11 ] )
    , .out_qid ( out_qid [ ( g * 7 ) +: 7 ] )
    , .out_hid ( out_hid [ ( g * 16 ) +: 16 ] )
    , .out_hit ( out_hit [ ( g * 1 ) +: 1 ] )
    , .out_vac ( out_vac [ ( g * 1 ) +: 1 ] )

    , .error ( mux_error [ ( g * 2 ) +: 2 ] )

    , .init_active ( init_active [ ( g * 1 ) +: 1 ] )
    , .notempty ( notempty [ ( g * 1 ) +: 1 ] )
    ) ;
  end
endgenerate

//....................................................................................................
// ERROR
always_comb begin
  error_cond = '0 ;

  //.........................
       error_cond [ HQM_AQED_ERR_VALID_MULTIPLE ] = 1'b0 ; 

  //.........................
  if ( out_valid [ ( 0 * 1 ) +: 1 ] & ( out_op [ ( 0 * 2 ) +: 2 ] == HQM_AQED_OP_ENQ_CEN ) ) begin
    if ( ( out_hit [ ( 0 * 1 ) +: 1 ]
         + out_hit [ ( 1 * 1 ) +: 1 ] 
         + out_hit [ ( 2 * 1 ) +: 1 ] 
         + out_hit [ ( 3 * 1 ) +: 1 ] 
         + out_hit [ ( 4 * 1 ) +: 1 ] 
         + out_hit [ ( 5 * 1 ) +: 1 ] 
         + out_hit [ ( 6 * 1 ) +: 1 ] 
         + out_hit [ ( 7 * 1 ) +: 1 ] 
         ) > 4'd1
       ) begin
       error_cond [ HQM_AQED_ERR_LOOKUP_HIT_MULTIPLE ] = 1'b1 ; 
    end
  end


  error = { error_cond , mux_error } ; 
end

endmodule
