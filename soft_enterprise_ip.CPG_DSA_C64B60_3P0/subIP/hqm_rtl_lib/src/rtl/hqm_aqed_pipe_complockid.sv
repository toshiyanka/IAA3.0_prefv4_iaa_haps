module hqm_aqed_pipe_complockid
  import hqm_AW_pkg::*;
#(
  parameter HQM_AQED_NUM_QID = 128
//................................................................................................................................................
, parameter HQM_AQED_NUM_QIDB2 = ( AW_logb2 ( HQM_AQED_NUM_QID -1 ) + 1 )

) (
  input logic  [ ( HQM_AQED_NUM_QID * 3 ) -1 : 0] cfg
, input logic [ ( 16 ) -1 : 0 ] in_lockid
, input logic [ ( 7 ) -1 : 0 ] in_qid
, output logic [ ( 16 ) -1 : 0 ] out_lockid
) ;

logic [ ( 12 ) -1 : 0 ] crc ;
logic [ ( 12 ) -1 : 0 ] mix_12_01 , mix_12_02 , mix_12_03 , mix_12_04 , mix_12_05 ;
logic [ ( 11 ) -1 : 0 ] mix_11_01 , mix_11_02 , mix_11_03 , mix_11_04 , mix_11_05 ;
logic [ ( 10 ) -1 : 0 ] mix_10_01 , mix_10_02 , mix_10_03 , mix_10_04 , mix_10_05 ;
logic [ ( 9 ) -1 : 0 ] mix_9_01 , mix_9_02 , mix_9_03 , mix_9_04 , mix_9_05 ;
logic [ ( 8 ) -1 : 0 ] mix_8_01 , mix_8_02 , mix_8_03 , mix_8_04 , mix_8_05 ;
logic [ ( 7 ) -1 : 0 ] mix_7_01 , mix_7_02 , mix_7_03 , mix_7_04 , mix_7_05 ;
logic [ ( 6 ) -1 : 0 ] mix_6_01 , mix_6_02 , mix_6_03 , mix_6_04 , mix_6_05 ;

always_comb begin

  //HASH 16b->12b   : crctree.perl CRC12_f13       1 16 12   0 0 0 0  0 0 0 0  0 0 0 0  0 0 0 0  0 0 0 0  1 1 1 1  0 0 0 1  0 0 1 1
  crc[00] = in_lockid[0] ^ in_lockid[1] ^ in_lockid[5] ^ in_lockid[6] ^ in_lockid[8] ^ in_lockid[12] ^ in_lockid[13] ^ in_lockid[14] ^ in_lockid[15] ;
  crc[01] = in_lockid[0] ^ in_lockid[2] ^ in_lockid[5] ^ in_lockid[7] ^ in_lockid[8] ^ in_lockid[9] ^ in_lockid[12] ;
  crc[02] = in_lockid[1] ^ in_lockid[3] ^ in_lockid[6] ^ in_lockid[8] ^ in_lockid[9] ^ in_lockid[10] ^ in_lockid[13] ;
  crc[03] = in_lockid[2] ^ in_lockid[4] ^ in_lockid[7] ^ in_lockid[9] ^ in_lockid[10] ^ in_lockid[11] ^ in_lockid[14] ;
  crc[04] = in_lockid[0] ^ in_lockid[1] ^ in_lockid[3] ^ in_lockid[6] ^ in_lockid[10] ^ in_lockid[11] ^ in_lockid[13] ^ in_lockid[14] ;
  crc[05] = in_lockid[1] ^ in_lockid[2] ^ in_lockid[4] ^ in_lockid[7] ^ in_lockid[11] ^ in_lockid[12] ^ in_lockid[14] ^ in_lockid[15] ;
  crc[06] = in_lockid[2] ^ in_lockid[3] ^ in_lockid[5] ^ in_lockid[8] ^ in_lockid[12] ^ in_lockid[13] ^ in_lockid[15] ;
  crc[07] = in_lockid[3] ^ in_lockid[4] ^ in_lockid[6] ^ in_lockid[9] ^ in_lockid[13] ^ in_lockid[14] ;
  crc[08] = in_lockid[0] ^ in_lockid[1] ^ in_lockid[4] ^ in_lockid[6] ^ in_lockid[7] ^ in_lockid[8] ^ in_lockid[10] ^ in_lockid[12] ^ in_lockid[13] ;
  crc[09] = in_lockid[0] ^ in_lockid[2] ^ in_lockid[6] ^ in_lockid[7] ^ in_lockid[9] ^ in_lockid[11] ^ in_lockid[12] ^ in_lockid[15] ;
  crc[10] = in_lockid[0] ^ in_lockid[3] ^ in_lockid[5] ^ in_lockid[6] ^ in_lockid[7] ^ in_lockid[10] ^ in_lockid[14] ^ in_lockid[15] ;
  crc[11] = in_lockid[0] ^ in_lockid[4] ^ in_lockid[5] ^ in_lockid[7] ^ in_lockid[11] ^ in_lockid[12] ^ in_lockid[13] ^ in_lockid[14] ;

  //                                        + ^ + ^ + ^ + ^
  //MIX12b          : 063 =RMSE 0 3 3005    0 2 0 1 5 6 0 3
  mix_12_01 = crc[11:0] ^ { 2'd0 ,       crc[11: 2]        } ;
  mix_12_02 = mix_12_01 ^ { 1'd0 , mix_12_01[11: 1]        } ;
  mix_12_03 = mix_12_02 + {        mix_12_02[ 6: 0] , 5'd0 } ;
  mix_12_04 = mix_12_03 ^ { 6'd0 , mix_12_03[11: 6]        } ;
  mix_12_05 = mix_12_04 ^ { 3'd0 , mix_12_04[11: 3]        } ;

  //                                        + ^ + ^ + ^ + ^
  //MIX11b          : 058 =RMSE 0 3 3005    0 1 0 2 5 5 0 3
  mix_11_01 = crc[10:0] ^ { 1'd0 ,       crc[10: 1]        } ;
  mix_11_02 = mix_11_01 ^ { 2'd0 , mix_11_01[10: 2]        } ;
  mix_11_03 = mix_11_02 + {        mix_11_02[ 5: 0] , 5'd0 } ;
  mix_11_04 = mix_11_03 ^ { 5'd0 , mix_11_03[10: 5]        } ;
  mix_11_05 = mix_11_04 ^ { 3'd0 , mix_11_04[10: 3]        } ;

  //                                        + ^ + ^ + ^ + ^
  //MIX10b          : 052 =RMSE 0 3 3005    0 2 0 1 5 5 0 2
  mix_10_01 = crc[9:0]  ^ { 2'd0 ,       crc[ 9: 2]        } ;
  mix_10_02 = mix_10_01 ^ { 1'd0 , mix_10_01[ 9: 1]        } ;
  mix_10_03 = mix_10_02 + {        mix_10_02[ 4: 0] , 5'd0 } ;
  mix_10_04 = mix_10_03 ^ { 5'd0 , mix_10_03[ 9: 5]        } ;
  mix_10_05 = mix_10_04 ^ { 2'd0 , mix_10_04[ 9: 2]        } ;

  //                                        + ^ + ^ + ^ + ^
  //MIX9b           : 043 =RMSE 0 3 3004    0 1 0 2 4 3 0 5
  mix_9_01  = crc[8:0]  ^ { 1'd0 ,       crc[ 8: 1]        } ;
  mix_9_02  = mix_9_01  ^ { 2'd0 ,  mix_9_01[ 8: 2]        } ;
  mix_9_03  = mix_9_02  + {         mix_9_02[ 4: 0] , 4'd0 } ;
  mix_9_04  = mix_9_03  ^ { 3'd0 ,  mix_9_03[ 8: 3]        } ;
  mix_9_05  = mix_9_04  ^ { 5'd0 ,  mix_9_04[ 8: 5]        } ;

  //                                        + ^ + ^ + ^ + ^
  //MIX8b           : 031 =RMSE 0 3 3004    0 1 0 2 4 2 0 4
  mix_8_01  = crc[7:0]  ^ { 1'd0 ,       crc[ 7: 1]        } ;
  mix_8_02  = mix_8_01  ^ { 2'd0 ,  mix_8_01[ 7: 2]        } ;
  mix_8_03  = mix_8_02  + {         mix_8_02[ 3: 0] , 4'd0 } ;
  mix_8_04  = mix_8_03  ^ { 2'd0 ,  mix_8_03[ 7: 2]        } ;
  mix_8_05  = mix_8_04  ^ { 4'd0 ,  mix_8_04[ 7: 4]        } ;

  //                                        + ^ + ^ + ^ + ^
  //MIX7b           : 020 =RMSE 0 3 3004    0 1 0 2 4 2 0 3
  mix_7_01  = crc[6:0]  ^ { 1'd0 ,       crc[ 6: 1]        } ;
  mix_7_02  = mix_7_01  ^ { 2'd0 ,  mix_7_01[ 6: 2]        } ;
  mix_7_03  = mix_7_02  + {         mix_7_02[ 2: 0] , 4'd0 } ;
  mix_7_04  = mix_7_03  ^ { 2'd0 ,  mix_7_03[ 6: 2]        } ;
  mix_7_05  = mix_7_04  ^ { 3'd0 ,  mix_7_04[ 6: 3]        } ;

  //                                        + ^ + ^ + ^ + ^
  //MIX6b           : 041 =RMSE 0 3 3003    0 2 0 1 3 4 0 2
  mix_6_01  = crc[5:0]  ^ { 2'd0 ,       crc[ 5: 2]        } ;
  mix_6_02  = mix_6_01  ^ { 1'd0 ,  mix_6_01[ 5: 1]        } ;
  mix_6_03  = mix_6_02  + {         mix_6_02[ 2: 0] , 3'd0 } ;
  mix_6_04  = mix_6_03  ^ { 4'd0 ,  mix_6_03[ 5: 4]        } ;
  mix_6_05  = mix_6_04  ^ { 2'd0 ,  mix_6_04[ 5: 2]        } ;


  out_lockid = '0 ;
  if ( cfg[ (in_qid * 3 ) +: 3 ] == 3'd7 ) begin out_lockid = { 4'd0  , mix_12_05[(12)-1:0] } ; end 
  if ( cfg[ (in_qid * 3 ) +: 3 ] == 3'd6 ) begin out_lockid = { 5'd0  , mix_11_05[(11)-1:0] } ; end 
  if ( cfg[ (in_qid * 3 ) +: 3 ] == 3'd5 ) begin out_lockid = { 6'd0  , mix_10_05[(10)-1:0] } ; end 
  if ( cfg[ (in_qid * 3 ) +: 3 ] == 3'd4 ) begin out_lockid = { 7'd0  , mix_9_05[(9)-1:0] } ; end 
  if ( cfg[ (in_qid * 3 ) +: 3 ] == 3'd3 ) begin out_lockid = { 8'd0  , mix_8_05[(8)-1:0] } ; end 
  if ( cfg[ (in_qid * 3 ) +: 3 ] == 3'd2 ) begin out_lockid = { 9'd0  , mix_7_05[(7)-1:0] } ; end 
  if ( cfg[ (in_qid * 3 ) +: 3 ] == 3'd1 ) begin out_lockid = { 10'd0 , mix_6_05[(6)-1:0] } ; end 
  if ( cfg[ (in_qid * 3 ) +: 3 ] == 3'd0 ) begin out_lockid = { in_lockid } ; end 

end
endmodule

