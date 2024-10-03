module hqm_AW_control_credits
import hqm_AW_pkg::* ;
# (
    parameter DEPTH                       = 8
  , parameter WMWIDTH                     = ( AW_logb2 ( DEPTH + 1 ) + 1 )
  , parameter NUM_A                       = 1
  , parameter NUM_D                       = 1
  , parameter EARLY_AFULL                 = 0
  //...............................................................................................................................................
  , parameter NUM_AB2                     = ( NUM_A == 1 ) ? 1 : ( AW_logb2 ( NUM_A ) + 1 )
  , parameter NUM_DB2                     = ( NUM_D == 1 ) ? 1 : ( AW_logb2 ( NUM_D ) + 1 )
) (
    input  logic                          clk
  , input  logic                          rst_n

  , input  logic [ ( NUM_A ) - 1 : 0 ]   alloc
  , input  logic [ ( NUM_D ) - 1 : 0 ]   dealloc

  , output logic                          empty
  , output logic                          full
  , output logic [ ( WMWIDTH ) - 1 : 0 ]  size
  , output logic                          error

  , input  logic [ ( WMWIDTH ) - 1 : 0 ]  hwm
  , output logic                          afull
) ;


logic [ ( WMWIDTH + 1 ) - 1 : 0 ] size_f , size_nxt ;
logic empty_nxt , empty_f ;
logic full_nxt , full_f ;
logic afull_nxt , afull_f ;
logic error_nxt , error_f ;
always_ff @ ( posedge clk or negedge rst_n )
begin
  if ( rst_n == 1'd0 ) begin
    size_f <= '0 ;
    empty_f <= 1'b1 ;
    full_f <= '0 ;
    afull_f <= '0 ;
    error_f <= '0 ;
  end else begin
    size_f <= size_nxt ;
    empty_f <= empty_nxt ;
    full_f <= full_nxt ;
    afull_f <= afull_nxt ;
    error_f <= error_nxt ;
  end
end

logic [ ( NUM_AB2 ) - 1 : 0 ] alloc_cnt ;
hqm_AW_count_ones #(
  .WIDTH ( NUM_A )
) i_hqm_AW_count_ones_alloc (
  .a ( alloc )
, .z ( alloc_cnt )
) ;

logic [ ( NUM_DB2 ) - 1 : 0 ] dealloc_cnt ;
hqm_AW_count_ones #(
  .WIDTH ( NUM_D )
) i_hqm_AW_count_ones_dealloc (
  .a ( dealloc )
, .z ( dealloc_cnt )
) ;

logic [ ( WMWIDTH + 1 ) - 1 : 0 ] scale_alloc_cnt ;
hqm_AW_width_scale #(
  .A_WIDTH ( NUM_AB2 )
, .Z_WIDTH ( WMWIDTH + 1 )
 ) i_scale_alloc_cnt (
 .a ( alloc_cnt )
,.z ( scale_alloc_cnt )
);

logic [ ( WMWIDTH + 1 ) - 1 : 0 ] scale_dealloc_cnt ;
hqm_AW_width_scale #(
  .A_WIDTH ( NUM_DB2 )
, .Z_WIDTH ( WMWIDTH + 1 )
 ) i_scale_dealloc_cnt (
 .a ( dealloc_cnt )
,.z ( scale_dealloc_cnt )
);



always_comb begin
  error_nxt           = 1'b0 ;
  size_nxt            = ( size_f
                        + scale_alloc_cnt
                        - scale_dealloc_cnt
                        ) ;

  //saturate on overflow & report error
  if ( ( size_nxt > DEPTH )
     | ( size_nxt > { 1'b0 , hwm } )
     )  begin
    error_nxt         = 1'b1 ;
    size_nxt          = DEPTH ;
  end

  //saturate on underflow & report error
  if ( scale_dealloc_cnt > ( size_f + scale_alloc_cnt ) ) begin
    error_nxt         = 1'b1 ;
    size_nxt          = '0 ;
  end

end

// create empty, full & afull status
assign empty_nxt      = ~ ( | size_nxt ) ;
assign afull_nxt      = ( size_nxt >=  { 1'b0 , hwm } ) ;
assign full_nxt       = ( size_nxt == DEPTH ) ;

//drive output ports with flop output
assign empty          = empty_f ;
assign afull          = EARLY_AFULL ? ( afull_f & ~ ( | dealloc ) ) : afull_f ;
assign full           = full_f ;
assign size           = size_f [ ( WMWIDTH ) - 1 : 0 ] ;
assign error          = error_f ;

//--------------------------------------------------------------------------------------------
// Assertions

`ifndef INTEL_SVA_OFF

  check_error: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
   !(error)) else begin
   $display ("\nERROR: %t: %m: AW_control_credits error detected !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

`endif

//--------------------------------------------------------------------------------------------
// Coverage

`ifdef HQM_COVER_ON

 covergroup AW_control_credits_CG @(posedge clk);

  AW_control_credits_CP_afull: coverpoint afull iff (rst_n === 1'b1) {
        bins            NOT_AFULL       = {0};
        bins            AFULL           = {1};
  }

  AW_control_credits_CP_full: coverpoint full iff (rst_n === 1'b1) {
        bins            NOT_FULL        = {0};
        bins            FULL            = {1};
  }

 endgroup

 AW_control_credits_CG AW_control_credits_CG_inst = new();

`endif

endmodule
