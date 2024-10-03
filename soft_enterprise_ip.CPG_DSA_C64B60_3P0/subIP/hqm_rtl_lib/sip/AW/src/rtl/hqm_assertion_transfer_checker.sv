module hqm_assertion_transfer_checker
import hqm_AW_pkg::*; #(
  parameter DEPTH                = 128 //number of operations the in->out can have active for each ID
, parameter NUM_ID               = 4   //number of independant source/dest that can be active
, parameter NUM_RESETS           = 1   //number of independant source/dest that can be active
, parameter DATA_WIDTH           = 16  //width of the operation
, parameter MAX_OPERATIONS       = 0   //use this to assert output 'done' after # of any operations issued by input
, parameter NUM_OUTPUT           = 1   //max number of operations that can be consumed by the output
, parameter DATA_MASK            = 0   //bit mask (DATA_WIDTH wide) to mask off data bits that can be modified.
//
, parameter CHECK_HANG_ID        = 1   //0:none, 1:(#active operations>0 & input v=1 & output ready=0 ) > threshold per ID
, parameter CHECK_HANG_TOTAL     = 1   //0:none, 1:(#active operations>0 & input v=1 & output ready=0 ) > threshold
, parameter CHECK_HANG_THRESH    = 16
, parameter CHECK_OUT_GT_IN      = 1   //0:none, 1:output count must be LTE input count
, parameter CHECK_ORDER_EXISTS   = 1   //0:none, 1:out_data matches in MEM (anywhere)
, parameter CHECK_ORDER_OLDEST   = 1   //0:none, 1:out_data is oldest in MEM

//TODO: support drops
//..................................................
, parameter DEPTHB2                                    = ( AW_logb2 ( DEPTH -1 ) + 1 )
, parameter NUM_IDB2                                   = ( AW_logb2 ( NUM_ID -1 ) + 1 )
) (
  input  logic                                         clk
, input  logic                                         rst_n

, input  logic                                         in_valid
, input  logic                                         in_taken
, input  logic [ ( NUM_IDB2 ) - 1 : 0 ]                in_id
, input  logic [ ( DATA_WIDTH ) - 1 : 0 ]              in_data

, input  logic [ ( NUM_OUTPUT ) - 1 : 0 ]              out_valid
, input  logic [ ( NUM_OUTPUT ) - 1 : 0 ]              out_taken
, input  logic [ ( NUM_OUTPUT * NUM_IDB2 ) - 1 : 0 ]   out_id
, input  logic [ ( NUM_OUTPUT * DATA_WIDTH ) - 1 : 0 ] out_data

, output logic                                         done

, input  logic [ ( NUM_RESETS ) - 1 : 0 ]              reset_count_v
, input  logic [ ( NUM_RESETS * NUM_IDB2 ) - 1 : 0 ]   reset_count_id

) ;

logic [ ( NUM_ID ) - 1 : 0 ] [ ( DEPTH + 1 ) - 1 : 0 ] [ ( DATA_WIDTH ) - 1 : 0 ] MEM_f , MEM_nxt ;
logic [ ( 32 ) - 1 : 0] TOTAL_COUNT_f , TOTAL_COUNT_nxt ;
logic [ ( 32 ) - 1 : 0 ] HANG_TOTAL_COUNT_f , HANG_TOTAL_COUNT_nxt ;
logic [ ( NUM_ID ) - 1 : 0 ] [ ( 32 ) - 1 : 0 ] HANG_ID_COUNT_f , HANG_ID_COUNT_nxt ;
logic [ ( NUM_ID ) - 1 : 0 ] [ ( 32 ) - 1 : 0 ] ID_COUNT_f , ID_COUNT_nxt ;
logic [ ( NUM_ID ) - 1 : 0 ] [ ( 32 ) - 1: 0 ] INPUT_COUNT_f , INPUT_COUNT_nxt ;
logic [ ( NUM_ID ) - 1 : 0 ] [ ( 32 ) - 1: 0 ] OUTPUT_COUNT_f , OUTPUT_COUNT_nxt ;

logic [ ( NUM_OUTPUT ) - 1 : 0 ] sl_out_valid ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] sl_out_taken ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] [ ( NUM_IDB2 ) - 1 : 0 ] sl_out_id ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] [ ( DATA_WIDTH ) - 1 : 0 ] sl_out_data ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] sl_out_hit_v ;
logic [ ( NUM_OUTPUT ) - 1 : 0 ] sl_out_hit_v_oldest ;

typedef struct packed {
logic check_hang ;
logic check_out_gt_in ;
logic check_out_gt_in_overflow ;
logic check_order_exists ;
logic check_order_oldest ;
} error_t ;
error_t error ;

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    MEM_f <= '0 ;
    TOTAL_COUNT_f <= '0 ;
    HANG_TOTAL_COUNT_f <= '0 ;
    HANG_ID_COUNT_f <= '0 ;
    ID_COUNT_f <= '0 ;
    INPUT_COUNT_f <= '0 ;
    OUTPUT_COUNT_f <= '0 ;
  end else begin
    MEM_f <= MEM_nxt ;
    TOTAL_COUNT_f <= TOTAL_COUNT_nxt ;
    HANG_TOTAL_COUNT_f <= HANG_TOTAL_COUNT_nxt ;
    HANG_ID_COUNT_f <= HANG_ID_COUNT_nxt ;
    ID_COUNT_f <= ID_COUNT_nxt ;
    INPUT_COUNT_f <= INPUT_COUNT_nxt ;
    OUTPUT_COUNT_f <= OUTPUT_COUNT_nxt ;
  end
end

always_comb begin
  done = ( TOTAL_COUNT_f > MAX_OPERATIONS ) ;
  MEM_nxt = MEM_f ;
  TOTAL_COUNT_nxt = TOTAL_COUNT_f ;
  HANG_TOTAL_COUNT_nxt = HANG_TOTAL_COUNT_f ;
  HANG_ID_COUNT_nxt = HANG_ID_COUNT_f ;
  ID_COUNT_nxt = ID_COUNT_f ;
  INPUT_COUNT_nxt = INPUT_COUNT_f ;
  OUTPUT_COUNT_nxt = OUTPUT_COUNT_f ;
  error = '0 ;


  //==================================================
  //process input interface
  if ( in_valid & in_taken ) begin
    TOTAL_COUNT_nxt = TOTAL_COUNT_nxt + 32'd1 ;
    HANG_TOTAL_COUNT_nxt = 32'd0 ;
    HANG_ID_COUNT_nxt [ in_id ] = 32'd0 ;
    INPUT_COUNT_nxt [ in_id ] = INPUT_COUNT_nxt [ in_id ] + 32'd1 ;
    ID_COUNT_nxt [ in_id ] = ID_COUNT_nxt [ in_id ] + 32'd1 ;
    MEM_nxt [ in_id ] [ ID_COUNT_f [ in_id ] [ DEPTHB2 : 0 ] ] = in_data ;
  end

  //==================================================
  //process output interface
  sl_out_valid = '0 ;
  sl_out_taken = '0 ;
  sl_out_id = '0 ;
  sl_out_data = '0 ;
  sl_out_hit_v = '0 ;
  sl_out_hit_v_oldest = '0 ;

  //convert packed input array to 2-D array for easier debug
  for ( int i = 0 ; i < NUM_OUTPUT ; i++ ) begin
      sl_out_valid [ i ] = out_valid [ i ] ;
      sl_out_taken [ i ] = ( out_valid [ i ] & out_taken [ i ] ) ;
      sl_out_id [ i ] = out_id [ ( i * NUM_IDB2 ) +: NUM_IDB2 ] ;
      sl_out_data [ i ] = out_data [ ( i * DATA_WIDTH ) +: DATA_WIDTH ] ;
  end

  for ( int i = 0 ; i < NUM_OUTPUT ; i++ ) begin
      if ( sl_out_valid [ i ] & sl_out_taken [ i ] ) begin
        TOTAL_COUNT_nxt = TOTAL_COUNT_nxt - 32'd1 ;
        HANG_TOTAL_COUNT_nxt = 32'd0 ;
        HANG_ID_COUNT_nxt [ sl_out_id [ i ] ] = 32'd0 ;
        OUTPUT_COUNT_nxt [ sl_out_id [ i ] ] = OUTPUT_COUNT_nxt [ sl_out_id [ i ] ] + 32'd1 ;
        ID_COUNT_nxt [ sl_out_id [ i ] ] = ID_COUNT_nxt [ sl_out_id [ i ] ] - 32'd1 ;
        for ( int d = 0; d < DEPTH ; d = d + 1 ) begin
          if ( ( MEM_nxt [ sl_out_id [ i ] ] [ d ] & ~DATA_MASK ) == ( sl_out_data [ i ] & ~DATA_MASK ) ) begin
            sl_out_hit_v [ i ] = 1'b1 ;
            if ( d == 0 ) begin sl_out_hit_v_oldest [ i ] = 1'b1 ; end
          end
          if ( sl_out_hit_v [ i ] ) begin MEM_nxt [ sl_out_id [ i ] ] [ d ] = MEM_nxt [ sl_out_id [ i ] ] [ ( d + 1 ) ] ; end
        end
      end
   end

  //==================================================
  //process hang timer reset
  for ( int i = 0 ; i < NUM_RESETS ; i++ ) begin
    if ( reset_count_v [ i ] ) begin
        HANG_TOTAL_COUNT_nxt = 32'd0 ;
        HANG_ID_COUNT_nxt [ reset_count_id [ ( i * NUM_IDB2 ) +: NUM_IDB2 ] ] = 32'd0 ;
    end
  end

  //==================================================
  // CHECK for hang in each ID 
  if ( ( TOTAL_COUNT_f > 32'd0 ) & ( in_valid & ~ in_taken ) ) begin
      if ( HANG_TOTAL_COUNT_nxt > CHECK_HANG_THRESH ) begin
        error.check_hang = CHECK_HANG_TOTAL ;
      end
  end

  //==================================================
  // CHECK for hang in each ID
  for ( int i = 0 ; i < NUM_ID ; i++ ) begin
    if ( ( ID_COUNT_f [ i ] > 32'd0 ) & ( in_valid & ~ in_taken ) ) begin
      HANG_ID_COUNT_nxt [ i ] = HANG_ID_COUNT_nxt [ i ] + 32'd1 ;
      if ( HANG_ID_COUNT_nxt [ i ] > CHECK_HANG_THRESH ) begin
        error.check_hang = CHECK_HANG_ID ;
      end
    end
  end

  //==================================================
  //CHECK appear on output & not issued on input
  for ( int i = 0 ; i < NUM_ID ; i++ ) begin
    if ( ID_COUNT_nxt [ i ] [ 31 ] == 1'b1 ) begin
      error.check_out_gt_in_overflow = CHECK_OUT_GT_IN ;
    end
    if ( OUTPUT_COUNT_nxt [ i ] > INPUT_COUNT_nxt [ i ] ) begin
      error.check_out_gt_in = CHECK_OUT_GT_IN ;
    end
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
  jg_checker_tx: assert property (@( posedge clk ) disable iff ( rst_n !== 1'b1 )
  !( | error ) ) else begin
    $display ("\nERROR: %t: %m: hqm_assertion_transfer_checker error detected !!!\n",$time ) ;
  end
`endif

endmodule
