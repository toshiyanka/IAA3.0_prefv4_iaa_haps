//------------------------------------------------------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------------------------------------------------------------------------
// Note: Intended usage is to tie use_mix to a constant (unused generator optimized out) or
// config bit for pre-silicon testing purposes.
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
// 
module hqm_AW_random16_wupdate #(
  parameter SEED = 1
, parameter INC = 0

) (
  input  logic                  clk
, input  logic                  rst_n
, output logic [15:0]           random
, input  logic                  update
, input  logic                  use_mix

);

logic           wrap_nc ;
logic           enable ;
logic [15:0]    random_lfsr ;

logic [15:0]    cnt_nxt ;
logic [15:0]    cnt_f ;
logic [15:0]    out_nxt ;
logic [15:0]    out_f ;
logic [15:0]    mix0 ;
logic [15:0]    mix1 ;
logic [15:0]    mix2 ;
logic [15:0]    mix3 ;
logic [15:0]    mix4 ;
logic [15:0]    mix5 ;
logic [15:0]    random_mix ;

assign enable = INC | update ;

//------------------------------------------------------------------------------------------------------------------------------------------------
//Instances & Registers

hqm_AW_max_lfsr # ( .WIDTH ( 16 ) , .SEED ( SEED ) ) i_hqm_AW_max_lfsr (
          .clk                          ( clk )
        , .rst_n                        ( rst_n )
        , .set                          ( 1'b0 )
        , .enable                       ( enable )
        , .wrap                         ( wrap_nc )
        , .count                        ( random_lfsr )
) ;

always_ff @(posedge clk or negedge rst_n) begin
  if ( ~ rst_n ) begin  
    cnt_f <= SEED [15:0] ;
    out_f <= 16'h0 ;
  end
  else begin
    cnt_f <= cnt_nxt;
    out_f <= out_nxt;
  end
end

//------------------------------------------------------------------------------------------------------------------------------------------------
//Functional Code
always_comb begin
  random_mix    = out_f ; 
  cnt_nxt       = cnt_f ;
  if ( enable )
    cnt_nxt     = cnt_f + 16'h1 ;

//mix
// 16-bit
//     00  01  02  03  04  05  06  07  08  09  10  11  12  13  14  15  
// 00 156 250 376 502 579 500 502 514 574 498 493 360 500 499 478 331 
// 01 250 376 502 563 500 499 478 574 498 491 334 500 502 482 331 501 
// 02 376 502 563 501 499 487 497 501 491 416 501 497 493 502 498 500 
// 03 533 594 500 498 491 500 504 482 455 501 477 493 498 501 481 483 
// 04 594 499 498 612 501 506 482 454 501 479 444 498 504 485 483 500 
// 05 500 496 611 503 503 494 495 500 483 466 498 502 492 505 497 537 
// 06 495 623 499 736 492 489 500 487 469 499 425 495 508 499 542 471 
// 07 627 500 735 387 489 500 519 471 495 488 523 508 498 491 478 529 
// 08 500 706 388 528 503 501 480 492 485 504 473 495 503 519 525 479 
// 09 736 438 527 590 503 496 499 490 501 485 466 496 503 499 479 499 
// 10 409 545 528 468 504 497 503 500 502 511 492 500 497 501 462 505 
// 11 526 504 471 495 498 502 479 506 513 495 495 502 505 462 509 498 
// 12 558 520 499 498 504 510 497 480 502 497 499 497 492 502 501 501 
// 13 511 495 500 500 502 499 501 505 492 499 498 500 504 499 498 516 
// 14 501 478 499 387 503 538 501 496 495 501 555 500 481 502 516 500 
// 15 499 504 388 503 501 496 504 500 502 533 498 498 509 494 497 537 

//                                   +  ^  +  ^  +  ^  +  ^
//                                   << >> << >> << >> << >>
// 02637 026 =RMSE 0 6 2011          00 10 03 02 08 04 00 07


  mix0 = cnt_f ^ { 10'h0 , cnt_f [15:10]         } ;
  mix1 = mix0  + {         mix0  [12: 0] ,  3'h0 } ;
  mix2 = mix1  ^ {  2'h0 , mix1  [15: 2]         } ;
  mix3 = mix2  + {         mix2  [ 7: 0] ,  8'h0 } ;
  mix4 = mix3  ^ {  4'h0 , mix3  [15: 4]         } ;
  mix5 = mix4  ^ {  7'h0 , mix4  [15: 7]         } ;

  out_nxt = mix5 ;


  if ( use_mix )
    random      = random_mix ;
  else
    random      = random_lfsr ;
end // always

endmodule
// 

