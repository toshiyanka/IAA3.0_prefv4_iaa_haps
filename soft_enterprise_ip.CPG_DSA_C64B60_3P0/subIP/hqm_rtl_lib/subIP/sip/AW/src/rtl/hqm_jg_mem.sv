module hqm_jg_mem
 import hqm_AW_pkg::*; #(
parameter TOTAL_DEPTH = 8
, parameter MODEL_DEPTH = 8
, parameter DATA_WIDTH = 16
, parameter NUM_IF = 1
//...............................................................................................................................................
, parameter NUM_IFB2 = ( AW_logb2 ( NUM_IF - 1 ) + 1 )
, parameter TOTAL_DEPTHB2 = ( AW_logb2 ( TOTAL_DEPTH - 1 ) + 1 )
, parameter MODEL_DEPTHB2 = ( AW_logb2 ( MODEL_DEPTH - 1 ) + 1 )
, parameter MODEL_DEPTHB2P1 = MODEL_DEPTHB2 + 1
) (
  input  logic                                        clk
, input  logic                                        rst_n

, output logic                                        full
, output logic [ ( MODEL_DEPTHB2P1 ) - 1 : 0 ]        cnt
, output logic [ ( TOTAL_DEPTH ) - 1 : 0 ]            addr_v

, input  logic [ ( NUM_IF * 1 ) - 1 : 0 ]             lookup_v
, input  logic [ ( NUM_IF * TOTAL_DEPTHB2 ) - 1 : 0 ] lookup_addr
, output logic [ ( NUM_IF * 1 ) - 1 : 0 ]             lookup_hit
, output logic [ ( NUM_IF * DATA_WIDTH ) - 1 : 0 ]    lookup_data

, input  logic [ ( NUM_IF * 1 ) - 1 : 0 ]             wr_v
, input  logic [ ( NUM_IF * TOTAL_DEPTHB2 ) - 1 : 0 ] wr_addr
, input  logic [ ( NUM_IF * DATA_WIDTH ) - 1 : 0 ]    wr_data

, input  logic [ ( NUM_IF * 1 ) - 1 : 0 ]             dealloc_v
, input  logic [ ( NUM_IF * TOTAL_DEPTHB2 ) - 1 : 0 ] dealloc_addr
) ;

logic [ ( TOTAL_DEPTH ) - 1 : 0 ] addr_v_f , addr_v_nxt ;
logic [ ( MODEL_DEPTH ) - 1 : 0 ] model_v_f , model_v_nxt ;
logic [ ( MODEL_DEPTH ) - 1 : 0 ] [ ( TOTAL_DEPTHB2 ) - 1 : 0 ] model_addr_f , model_addr_nxt ;
logic [ ( MODEL_DEPTH ) - 1 : 0 ] [ ( DATA_WIDTH ) - 1 : 0 ] model_data_f , model_data_nxt ;
logic [ ( MODEL_DEPTHB2P1 ) - 1 : 0 ] cnt_f , cnt_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    addr_v_f <= '0 ;
    model_v_f <= '0 ;
    model_addr_f <= '0 ;
    model_data_f <= '0 ;
    cnt_f <= '0 ;
  end
  else begin
    addr_v_f <= addr_v_nxt ;
    model_v_f <= model_v_nxt ;
    model_addr_f <= model_addr_nxt ;
    model_data_f <= model_data_nxt ;
    cnt_f <= cnt_nxt ;
  end
end

logic wr_hit ;
logic [ ( MODEL_DEPTHB2 ) - 1 : 0 ] wr_hit_id ;
logic wr_alloc ;
logic [ ( MODEL_DEPTHB2 ) - 1 : 0 ] wr_alloc_id ;
logic dealloc_hit ;
logic [ ( MODEL_DEPTHB2 ) - 1 : 0 ] dealloc_hit_id ;
logic error_alloc ;
logic error_dealloc ;
always_comb begin
  cnt = cnt_f ;
  full = ( & model_v_f ) ;
  addr_v = addr_v_f ;
  lookup_hit = '0 ;
  lookup_data = '0 ;

  addr_v_nxt = addr_v_f ;
  model_v_nxt = model_v_f ;
  model_addr_nxt = model_addr_f ;
  model_data_nxt = model_data_f ;
  cnt_nxt = cnt_f ;

  error_alloc = '0 ;
  error_dealloc = '0 ;

  for ( int i = 0 ; i < NUM_IF ; i = i + 1 ) begin
    for ( int m = 0 ; m < MODEL_DEPTH ; m = m + 1 ) begin
      if ( ( lookup_v [ i ] )
         & ( model_v_f [ m ] )
         & ( lookup_addr [ ( i * TOTAL_DEPTHB2 ) +: TOTAL_DEPTHB2 ] == model_addr_f [ m ] )
         ) begin
        lookup_hit [ i ] = 1'b1 ;
        lookup_data [ ( i * DATA_WIDTH ) +: DATA_WIDTH ] = model_data_f [ m ] ;
      end
    end
  end

  wr_hit = '0 ;
  wr_hit_id = '0 ;
  wr_alloc = '0 ;
  wr_alloc_id = '0 ;
  for ( int i = 0 ; i < NUM_IF ; i = i + 1 ) begin
    if ( wr_v [ i ] ) begin
      wr_hit = '0 ;
      wr_hit_id = '0 ;
      for ( int m = 0 ; m < MODEL_DEPTH ; m = m + 1 ) begin
        if ( ( model_v_nxt [ m ] )
           & ( wr_addr [ ( i * TOTAL_DEPTHB2 ) +: TOTAL_DEPTHB2 ] == model_addr_nxt [ m ] )
           ) begin
          wr_hit = 1'b1 ;
          wr_hit_id = m ;
        end
      end

      if ( wr_hit ) begin
        wr_alloc = wr_hit ;
        wr_alloc_id = wr_hit_id ;
      end
      if ( ~ wr_hit ) begin
        wr_alloc = '0 ;
        wr_alloc_id = '0 ;
        for ( int m = 0 ; m < MODEL_DEPTH ; m = m + 1 ) begin
          if ( ~ model_v_nxt [ m ] ) begin
            wr_alloc = 1'b1 ;
            wr_alloc_id = m ;
          end
        end
      end

      if ( wr_alloc ) begin
        if ( ~ wr_hit ) begin
          cnt_nxt = cnt_nxt + 1'b1 ;
        end
        model_v_nxt [ wr_alloc_id ] = 1'b1 ;
        model_addr_nxt [ wr_alloc_id ] = wr_addr [ ( i * TOTAL_DEPTHB2 ) +: TOTAL_DEPTHB2 ] ;
        model_data_nxt [ wr_alloc_id ] = wr_data [ ( i * DATA_WIDTH ) +: DATA_WIDTH ] ;
        addr_v_nxt [ wr_addr [ ( i * TOTAL_DEPTHB2 ) +: TOTAL_DEPTHB2 ] ] = 1'b1 ;
      end
      if ( ~ wr_alloc ) begin
        error_alloc = 1'b1 ;
      end

    end
  end

  for ( int i = 0 ; i < NUM_IF ; i = i + 1 ) begin
    dealloc_hit = '0 ;
    dealloc_hit_id = '0 ;
    if ( dealloc_v [ i ] ) begin
      for ( int m = 0 ; m < MODEL_DEPTH ; m = m + 1 ) begin
        if ( ( model_v_nxt [ m ] )
           & ( model_addr_nxt [ m ] == dealloc_addr [ ( i * TOTAL_DEPTHB2 ) +: TOTAL_DEPTHB2 ] )
           ) begin
          dealloc_hit = 1'b1 ;
          dealloc_hit_id = m ;
        end
      end

      if ( dealloc_hit ) begin
        cnt_nxt = cnt_nxt - 1'b1 ;
        model_v_nxt [ dealloc_hit_id ] = '0 ;
        model_addr_nxt [ dealloc_hit_id ] = '0 ;
        addr_v_nxt [ dealloc_addr [ ( i * TOTAL_DEPTHB2 ) +: TOTAL_DEPTHB2 ] ] = '0 ;
      end
      if ( ~ dealloc_hit ) begin
        error_dealloc = 1'b1 ;
      end

    end
  end

end

// Assertions
`ifndef INTEL_SVA_OFF
  jg_mem__check_alloc : assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( error_alloc ) ) else begin
   $display ("\nERROR: %t: %m: jg_mem error detected : error_alloc !!!\n",$time ) ;
  end
  jg_mem__check_dealloc : assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( error_dealloc ) ) else begin
   $display ("\nERROR: %t: %m: jg_mem error detected : error_dealloc !!!\n",$time ) ;
  end
`endif
endmodule
