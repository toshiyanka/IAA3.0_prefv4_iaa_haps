module hqm_jg_transfer_checker
import hqm_AW_pkg::*; #(
//
  parameter DEPTH                   = 128 //max number of operations for all in->out transfers held in internal storage
, parameter DATA_WIDTH              = 16  //data width of operation
, parameter DATA_MASK               = 0   //bit mask (DATA_WIDTH wide) to mask off data bits that can be modified from any in->out transfer
, parameter NUM_INPUT               = 1   //number of input requestors
, parameter NUM_OUTPUT              = 1   //number of output requestors
, parameter NUM_DROP                = 1   //number of drop requestors
, parameter NUM_RESET               = 1   //number of hang timer reset events (ex. another IF with shared credits can stall in->out tranfer)
, parameter NUM_STALL               = 1   //number of hang timer stall events (ex. output stage is issuing bp or a high prioirty  config access is taken by pipeline)
//
, parameter CHECK_HANG              = 1   //0:none, 1:(#queued operations > 0 ) & (#cycles since last out_v event > threshold)
, parameter CHECK_HANG_THRESH       = 16
, parameter CHECK_IN_HANG           = 1   //0:none, 1:in_valid asserted > threshold with no in_taken
, parameter CHECK_IN_HANG_THRESH    = 16
, parameter CHECK_OUT_HANG          = 1   //0:none, 1:out_valid asserted > threshold with no out_taken
, parameter CHECK_OUT_HANG_THRESH   = 16
, parameter CHECK_OUT_MISS          = 1   //0:none, 1:out_valid issued with no data stored in hqm_jg_transfer_checker
, parameter CHECK_DROP_MISS         = 1   //0:none, 1:drop_valid issued & no data match
, parameter CHECK_ORDER_EXISTS      = 1   //0:none, 1:out_valid issued & out_data does not hit in storage
, parameter CHECK_ORDER_OLDEST      = 1   //0:none, 1:out_valid issued & out_data is not the oldest data in storage
, parameter CHECK_OF                = 1   //0:none, 1:storage counter has overflow or underflow
, parameter CHECK_UF                = 1   //0:none, 1:storage counter has overflow or underflow
, parameter CHECK_IN_V              = 1   //0:none, 1:in_valid deasserts before taken
, parameter CHECK_IN_DATA           = 1   //0:none, 1:in_data changes before taken
, parameter CHECK_OUT_V             = 1   //0:none, 1:out_valid deasserts before taken
, parameter CHECK_OUT_DATA          = 1   //0:none, 1:out_data changes before taken
//..................................................
, parameter DEPTHB2                 = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter DEPTHB2P1               = DEPTHB2 + 1
) (
  input  logic                                         clk
, input  logic                                         rst_n

, input  logic [ ( NUM_INPUT ) - 1 : 0 ]               in_valid
, input  logic [ ( NUM_INPUT ) - 1 : 0 ]               in_taken
, input  logic [ ( NUM_INPUT * DATA_WIDTH ) - 1 : 0 ]  in_data

, input  logic [ ( NUM_OUTPUT ) - 1 : 0 ]              out_valid
, input  logic [ ( NUM_OUTPUT ) - 1 : 0 ]              out_taken
, input  logic [ ( NUM_OUTPUT * DATA_WIDTH ) - 1 : 0 ] out_data

, input  logic [ ( NUM_DROP ) - 1 : 0 ]                drop_valid
, input  logic [ ( NUM_DROP * DATA_WIDTH ) - 1 : 0 ]   drop_data

, input  logic [ ( NUM_RESET ) - 1 : 0 ]               reset_count_valid
, input  logic [ ( NUM_STALL ) - 1 : 0 ]               stall_count_valid
) ;

logic [ ( DEPTH + 1 ) - 1 : 0 ] [ ( DATA_WIDTH ) - 1 : 0 ] MEM_f , MEM_nxt ;
logic [ ( DEPTH + 1 ) - 1 : 0 ] MEMv_f , MEMv_nxt ;
logic [ ( 32 ) - 1 : 0] TOTAL_COUNT_f , TOTAL_COUNT_nxt ;
logic [ ( NUM_INPUT * 32 ) - 1 : 0 ] IN_HANG_COUNT_f , IN_HANG_COUNT_nxt ;
logic [ ( NUM_OUTPUT * 32 ) - 1 : 0 ] OUT_HANG_COUNT_f , OUT_HANG_COUNT_nxt ;
logic [ ( 32 ) - 1 : 0 ] HANG_COUNT_f , HANG_COUNT_nxt ;
logic [ ( 32 ) - 1: 0 ] INPUT_COUNT_f , INPUT_COUNT_nxt ;
logic [ ( 32 ) - 1: 0 ] OUTPUT_COUNT_f , OUTPUT_COUNT_nxt ;

logic [ ( NUM_INPUT ) - 1 : 0 ] sl_in_valid ;
logic [ ( NUM_INPUT ) - 1 : 0 ] sl_in_taken ; 
logic [ ( NUM_INPUT ) - 1 : 0 ] [ ( DATA_WIDTH ) - 1 : 0 ] sl_in_data ;

logic [ ( NUM_OUTPUT ) - 1 : 0 ] sl_out_valid ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] sl_out_taken ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] [ ( DATA_WIDTH ) - 1 : 0 ] sl_out_data ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] sl_out_hit_v ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] sl_out_hit_v_oldest ;

logic [ ( NUM_DROP ) - 1 : 0 ] sl_drop_valid ;
logic [ ( NUM_DROP ) - 1 : 0 ] [ ( DATA_WIDTH ) - 1 : 0 ] sl_drop_data ;
logic [ ( NUM_DROP ) - 1 : 0 ] sl_drop_hit_v ;

typedef struct packed {
logic [ ( NUM_INPUT ) - 1 : 0 ] check_in_hang ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] check_out_hang ;
logic check_hang ;
logic check_of ;
logic check_uf ;
logic check_order_exists ;
logic check_order_oldest ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] check_out_miss ;
logic check_drop_miss ;
logic [ ( NUM_INPUT ) - 1 : 0 ] check_in_v ;
logic [ ( NUM_INPUT ) - 1 : 0 ] check_in_data ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] check_out_v ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] check_out_data ;
} error_t ;
error_t error ;

logic [ ( 32 ) - 1 : 0] DEBUG_size ;
logic DEBUG_empty ;
logic DEBUG_full ;
assign DEBUG_size = TOTAL_COUNT_f ;
assign DEBUG_empty = ( TOTAL_COUNT_f == 32'd0 ) ;
assign DEBUG_full = ( TOTAL_COUNT_f == DEPTH ) ;

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    MEM_f <= '0 ;
    MEMv_f <= '0 ;
    TOTAL_COUNT_f <= '0 ;
    IN_HANG_COUNT_f <= '0 ;
    OUT_HANG_COUNT_f <= '0 ;
    HANG_COUNT_f <= '0 ;
    INPUT_COUNT_f <= '0 ;
    OUTPUT_COUNT_f <= '0 ;
  end else begin
    MEM_f <= MEM_nxt ;
    MEMv_f <= MEMv_nxt ;
    TOTAL_COUNT_f <= TOTAL_COUNT_nxt ;
    IN_HANG_COUNT_f <= IN_HANG_COUNT_nxt ;
    OUT_HANG_COUNT_f <= OUT_HANG_COUNT_nxt ;
    HANG_COUNT_f <= HANG_COUNT_nxt ;
    INPUT_COUNT_f <= INPUT_COUNT_nxt ;
    OUTPUT_COUNT_f <= OUTPUT_COUNT_nxt ;
  end
end


logic [ ( NUM_INPUT ) - 1 : 0 ]               in_valid_f ;
logic [ ( NUM_INPUT ) - 1 : 0 ]               in_taken_f ;
logic [ ( NUM_INPUT * DATA_WIDTH ) - 1 : 0 ]  in_data_f ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ]              out_valid_f ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ]              out_taken_f ;
logic [ ( NUM_OUTPUT * DATA_WIDTH ) - 1 : 0 ] out_data_f ;
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    in_valid_f <= '0 ;
    in_taken_f <= '0 ;
    in_data_f <= '0 ;
    out_valid_f <= '0 ;
    out_taken_f <= '0 ;
    out_data_f <= '0 ;
  end else begin
    in_valid_f <= in_valid ;
    in_taken_f <= in_taken ;
    in_data_f <= in_data ;
    out_valid_f <= out_valid ;
    out_taken_f <= out_taken ;
    out_data_f <= out_data ;
  end
end




always_comb begin
  MEM_nxt = MEM_f ;
  MEMv_nxt = MEMv_f ;
  TOTAL_COUNT_nxt = TOTAL_COUNT_f ;
  IN_HANG_COUNT_nxt = IN_HANG_COUNT_f ;
  OUT_HANG_COUNT_nxt = OUT_HANG_COUNT_f ;
  HANG_COUNT_nxt = HANG_COUNT_f ;
  INPUT_COUNT_nxt = INPUT_COUNT_f ;
  OUTPUT_COUNT_nxt = OUTPUT_COUNT_f ;
  error = '0 ;

  //==================================================
  //process input interface
  sl_in_valid = '0 ;
  sl_in_taken = '0 ; 
  sl_in_data = '0 ;
  for ( int i = 0 ; i < NUM_INPUT ; i++ ) begin
      sl_in_valid [ i ] = in_valid [ i ] ;
      sl_in_taken [ i ] = ( in_valid [ i ] & in_taken [ i ] ) ;
      sl_in_data [ i ] = in_data [ ( i * DATA_WIDTH ) +: DATA_WIDTH ] ;
  end
  //
  for ( int i = 0 ; i < NUM_INPUT ; i++ ) begin 
    if ( sl_in_valid [ i ] & sl_in_taken [ i ] ) begin
      MEM_nxt [ TOTAL_COUNT_nxt [ ( DEPTHB2 ) - 1 : 0 ] ] = in_data [ (i*DATA_WIDTH) +: DATA_WIDTH] ;
      MEMv_nxt [ TOTAL_COUNT_nxt [ ( DEPTHB2 ) - 1 : 0 ] ] = 1'b1 ;
      TOTAL_COUNT_nxt = TOTAL_COUNT_nxt + 32'd1 ;
      INPUT_COUNT_nxt = INPUT_COUNT_nxt + 32'd1 ;
    end
  end 

  //check for input interface hang ( support phase handshake)
  for ( int i = 0 ; i < NUM_INPUT ; i++ ) begin
    if ( sl_in_valid [ i ] ) begin IN_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] = IN_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] + 32'd1 ; end
    if ( sl_in_taken [ i ] ) begin IN_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] = 32'd0 ; end
    if ( | reset_count_valid ) begin IN_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] = 32'd0 ; end
    if ( | stall_count_valid ) begin IN_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] = IN_HANG_COUNT_f [ ( i ) * 32 +: 32 ] ; end
  end
  for ( int i = 0 ; i < NUM_INPUT ; i++ ) begin
    if ( IN_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] > CHECK_IN_HANG_THRESH ) begin error.check_in_hang [ i ] = CHECK_IN_HANG ; end
  end

  //check for invalid transfer
  for ( int i = 0 ; i < NUM_INPUT ; i++ ) begin
    if ( in_valid_f [ i ] & ~ in_taken_f [ i ] & ( ~ in_valid [ i ] ) ) begin error.check_in_v [ i ] = CHECK_IN_V ; end
    if ( in_valid_f [ i ] & ~ in_taken_f [ i ] & ( in_data [ (i*DATA_WIDTH) +: DATA_WIDTH] != in_data_f [ (i*DATA_WIDTH) +: DATA_WIDTH] ) ) begin error.check_in_data [ i ] = CHECK_IN_DATA ; end
  end

  //==================================================
  //process drop interface
  sl_drop_valid = '0 ;
  sl_drop_data = '0 ;
  sl_drop_hit_v = '0 ;
  //
  for ( int i = 0 ; i < NUM_DROP ; i++ ) begin
      sl_drop_valid [ i ] = drop_valid [ i ] ; 
      sl_drop_data [ i ] = drop_data [ ( i * DATA_WIDTH ) +: DATA_WIDTH ] ;
  end
  for ( int i = 0 ; i < NUM_DROP ; i++ ) begin
      if ( sl_drop_valid [ i ] ) begin
        for ( int d = 0; d < DEPTH ; d = d + 1 ) begin
          if ( MEMv_nxt [ d ] & ( ( MEM_nxt [ d ] & ~DATA_MASK ) == ( sl_drop_data [ i ] & ~DATA_MASK ) ) ) begin
            sl_drop_hit_v [ i ] = 1'b1 ;
          end
          if ( sl_drop_hit_v [ i ] ) begin MEM_nxt [ d ] = MEM_nxt [ ( d + 1 ) ] ; MEMv_nxt [ d ] = MEMv_nxt [ ( d + 1 ) ] ; end
        end
        if ( ~ sl_drop_hit_v [ i ] ) begin error.check_drop_miss = CHECK_DROP_MISS ; end
      end
  end

  //==================================================
  //process output interface
  sl_out_valid = '0 ;
  sl_out_taken = '0 ;
  sl_out_data = '0 ;
  sl_out_hit_v = '0 ;
  sl_out_hit_v_oldest = '0 ;
  //
  for ( int i = 0 ; i < NUM_OUTPUT ; i++ ) begin
      sl_out_valid [ i ] = out_valid [ i ] ;
      sl_out_taken [ i ] = ( out_valid [ i ] & out_taken [ i ] ) ;
      sl_out_data [ i ] = out_data [ ( i * DATA_WIDTH ) +: DATA_WIDTH ] ;
  end
  //
  for ( int i = 0 ; i < NUM_OUTPUT ; i++ ) begin
      if ( sl_out_valid [ i ] & sl_out_taken [ i ] ) begin
        if ( TOTAL_COUNT_nxt == 32'd0 ) begin error.check_out_miss [ i ] = CHECK_OUT_MISS ; error.check_uf = CHECK_UF ; end
        TOTAL_COUNT_nxt = TOTAL_COUNT_nxt - 32'd1 ;
        OUTPUT_COUNT_nxt = OUTPUT_COUNT_nxt + 32'd1 ;
        for ( int d = 0; d < DEPTH ; d = d + 1 ) begin
          if ( MEMv_nxt [ d ] & ( ( MEM_nxt [ d ] & ~DATA_MASK ) == ( sl_out_data [ i ] & ~DATA_MASK ) ) ) begin
            sl_out_hit_v [ i ] = 1'b1 ;
            if ( d == 0 ) begin sl_out_hit_v_oldest [ i ] = 1'b1 ; end
          end
          if ( sl_out_hit_v [ i ] ) begin MEM_nxt [ d ] = MEM_nxt [ ( d + 1 ) ] ; MEMv_nxt [ d ] = MEMv_nxt [ ( d + 1 ) ] ; end
        end
      end
  end

  //check for input interface hang ( support phase handshake)
  for ( int i = 0 ; i < NUM_OUTPUT ; i++ ) begin
    if ( sl_out_valid [ i ] ) begin OUT_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] = OUT_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] + 32'd1 ; end
    if ( sl_out_taken [ i ] ) begin OUT_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] = 32'd0 ; end
    if ( | reset_count_valid ) begin OUT_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] = 32'd0 ; end
    if ( | stall_count_valid ) begin OUT_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] = OUT_HANG_COUNT_f [ ( i ) * 32 +: 32 ] ; end
  end
  for ( int i = 0 ; i < NUM_OUTPUT ; i++ ) begin
    if ( OUT_HANG_COUNT_nxt [ ( i ) * 32 +: 32 ] > CHECK_OUT_HANG_THRESH ) begin error.check_out_hang [ i ] = CHECK_OUT_HANG ; end
  end

  //check for invalid transfer
  for ( int i = 0 ; i < NUM_OUTPUT ; i++ ) begin
    if ( out_valid_f [ i ] & ~ out_taken_f [ i ] & ( ~ out_valid [ i ] ) ) begin error.check_out_v [ i ] = CHECK_OUT_V ; end
    if ( out_valid_f [ i ] & ~ out_taken_f [ i ] & ( out_data [ (i*DATA_WIDTH) +: DATA_WIDTH] != out_data_f [ (i*DATA_WIDTH) +: DATA_WIDTH] ) ) begin error.check_out_data [ i ] = CHECK_OUT_DATA ; end
  end

  //==================================================
  //process hang timer 
  if ( ( TOTAL_COUNT_f > 32'd0 ) ) begin HANG_COUNT_nxt = HANG_COUNT_nxt + 32'd1 ; end
  if ( | stall_count_valid ) begin HANG_COUNT_nxt = HANG_COUNT_f ; end
  if ( | out_valid ) begin HANG_COUNT_nxt = 32'd0 ; end
  if ( | reset_count_valid ) begin HANG_COUNT_nxt = 32'd0 ; end

  //==================================================
  // CHECK for hang 
  if ( HANG_COUNT_nxt > CHECK_HANG_THRESH ) begin
    error.check_hang = CHECK_HANG ;
  end

  //==================================================
  //CHECK total count overflow/underflow
  if ( TOTAL_COUNT_nxt > DEPTH ) begin
    error.check_of = CHECK_OF ;
  end


  //==================================================
  //CHECK order when on output
  //+ was data issued in input by ID
  //+ is the data the oldest issued on input by ID
  for ( int i = 0 ; i < NUM_OUTPUT ; i++ ) begin
    if ( out_valid [ i ] & out_taken [ i ] ) begin
      if ( ~ sl_out_hit_v [ i ] ) begin
        error.check_order_exists = CHECK_ORDER_EXISTS ;
      end
      if ( ~ sl_out_hit_v_oldest [ i ] ) begin
        error.check_order_oldest = CHECK_ORDER_OLDEST ;
      end
    end
  end

end

//--------------------------------------------------------------------------------------------
// Assertions
`ifndef INTEL_SVA_OFF

  jg_transfer_checker__check_out_miss: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_out_miss ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_out_miss         :%d \n",$time,error.check_out_miss ) ;
  end

  jg_transfer_checker__check_drop_miss: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_drop_miss ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_drop_miss        :%d \n",$time,error.check_drop_miss ) ;
  end

  jg_transfer_checker__check_in_hang: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_in_hang ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_in_hang          :%d \n",$time,error.check_in_hang ) ;
  end

  jg_transfer_checker__check_out_hang: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_out_hang ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_out_hang         :%d \n",$time,error.check_out_hang ) ;
  end

  jg_transfer_checker__check_hang: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_hang ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_hang             :%d \n",$time,error.check_hang ) ;
  end

  jg_transfer_checker__check_of: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_of ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_of               :%d \n",$time,error.check_of ) ;
  end

  jg_transfer_checker__check_uf: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_uf ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_uf               :%d \n",$time,error.check_uf ) ;
  end

  jg_transfer_checker__check_order_exists: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_order_exists ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_order_exists     :%d \n",$time,error.check_order_exists ) ;
  end

  jg_transfer_checker__check_order_oldest: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_order_oldest ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_order_oldest     :%d \n",$time,error.check_order_oldest ) ;
  end

  jg_transfer_checker__check_in_v: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_in_v ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_in_v     :%d \n",$time,error.check_in_v ) ;
  end

  jg_transfer_checker__check_in_data: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_in_data ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_in_data     :%d \n",$time,error.check_in_data ) ;
  end

  jg_transfer_checker__check_out_v: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_out_v ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_out_v     :%d \n",$time,error.check_out_v ) ;
  end

  jg_transfer_checker__check_out_data: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error.check_out_data ) ) else begin
    $display ("\nERROR: %t: %m: jg_transfer_checker error detected : error.check_out_data     :%d \n",$time,error.check_out_data ) ;
  end
`endif

endmodule
