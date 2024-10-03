//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//-----------------------------------------------------------------------------------------------------
// hqm_chp_sys_wb_pad_flag
//
// This module sets the write buffer pad flag for hcw_sched to send to the system
//
//-----------------------------------------------------------------------------------------------------
module hqm_chp_sys_wb_pad_flag
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(
    input  logic                                     cfg_pad_first_write_ldb
  , input  logic                                     cfg_pad_first_write_dir 
  , input  logic                                     cfg_pad_write_ldb
  , input  logic                                     cfg_pad_write_dir 
                                                             
  , input  logic                                     is_ldb

  , input  logic [ 1 : 0 ]                           ldb_cq_wptr  
  , input  logic [ 1 : 0 ]                           dir_cq_wptr  

  , input  logic [ 3 : 0 ]                           ldb_cq_token_depth_select
  , input  logic [ 3 : 0 ]                           dir_cq_token_depth_select
  , input  logic [ 10 : 0 ]                          ldb_cq_depth 
  , input  logic [ 12 : 0 ]                          dir_cq_depth 

  , output logic                                     pad_ok 
);

logic                                                ldb_pad_ok ;
logic                                                dir_pad_ok ;

assign pad_ok = is_ldb ? ( ( cfg_pad_write_ldb | cfg_pad_first_write_ldb ) & ldb_pad_ok ) : 
                ( ( cfg_pad_first_write_dir | cfg_pad_write_dir ) & dir_pad_ok ) ;

always_comb begin

  ldb_pad_ok = 1'b0 ;

  case ( ldb_cq_token_depth_select ) 
    4'h0 : begin
      ldb_pad_ok = ( ldb_cq_wptr == 2'd3 ) ? ( ldb_cq_depth <= 11'd3 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd2 ) ? ( ldb_cq_depth <= 11'd2 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd1 ) ? ( ldb_cq_depth <= 11'd1 ) & ~ cfg_pad_first_write_ldb : ( ldb_cq_depth == 11'd0 ) ;
    end
    4'h1 : begin
      ldb_pad_ok = ( ldb_cq_wptr == 2'd3 ) ? ( ldb_cq_depth <= 11'd7 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd2 ) ? ( ldb_cq_depth <= 11'd6 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd1 ) ? ( ldb_cq_depth <= 11'd5 ) & ~ cfg_pad_first_write_ldb : ( ldb_cq_depth <= 11'd4 ) ;
    end
    4'h2 : begin
      ldb_pad_ok = ( ldb_cq_wptr == 2'd3 ) ? ( ldb_cq_depth <= 11'd15 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd2 ) ? ( ldb_cq_depth <= 11'd14 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd1 ) ? ( ldb_cq_depth <= 11'd13 ) & ~ cfg_pad_first_write_ldb : ( ldb_cq_depth <= 11'd12 ) ;
    end
    4'h3 : begin
      ldb_pad_ok = ( ldb_cq_wptr == 2'd3 ) ? ( ldb_cq_depth <= 11'd31 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd2 ) ? ( ldb_cq_depth <= 11'd30 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd1 ) ? ( ldb_cq_depth <= 11'd29 ) & ~ cfg_pad_first_write_ldb : ( ldb_cq_depth <= 11'd28 ) ;
    end
    4'h4 : begin
      ldb_pad_ok = ( ldb_cq_wptr == 2'd3 ) ? ( ldb_cq_depth <= 11'd63 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd2 ) ? ( ldb_cq_depth <= 11'd62 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd1 ) ? ( ldb_cq_depth <= 11'd61 ) & ~ cfg_pad_first_write_ldb : ( ldb_cq_depth <= 11'd60 ) ;
    end
    4'h5 : begin
      ldb_pad_ok = ( ldb_cq_wptr == 2'd3 ) ? ( ldb_cq_depth <= 11'd127 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd2 ) ? ( ldb_cq_depth <= 11'd126 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd1 ) ? ( ldb_cq_depth <= 11'd125 ) & ~ cfg_pad_first_write_ldb : ( ldb_cq_depth <= 11'd124 ) ;
    end
    4'h6 : begin
      ldb_pad_ok = ( ldb_cq_wptr == 2'd3 ) ? ( ldb_cq_depth <= 11'd255 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd2 ) ? ( ldb_cq_depth <= 11'd254 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd1 ) ? ( ldb_cq_depth <= 11'd253 ) & ~ cfg_pad_first_write_ldb : ( ldb_cq_depth <= 11'd252 ) ;
    end
    4'h7 : begin
      ldb_pad_ok = ( ldb_cq_wptr == 2'd3 ) ? ( ldb_cq_depth <= 11'd511 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd2 ) ? ( ldb_cq_depth <= 11'd510 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd1 ) ? ( ldb_cq_depth <= 11'd509 ) & ~ cfg_pad_first_write_ldb : ( ldb_cq_depth <= 11'd508 ) ;
    end
    4'h8 : begin
      ldb_pad_ok = ( ldb_cq_wptr == 2'd3 ) ? ( ldb_cq_depth <= 11'd1023 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd2 ) ? ( ldb_cq_depth <= 11'd1022 ) & ~ cfg_pad_first_write_ldb :
                   ( ldb_cq_wptr == 2'd1 ) ? ( ldb_cq_depth <= 11'd1021 ) & ~ cfg_pad_first_write_ldb : ( ldb_cq_depth <= 11'd1020 ) ;
    end
    default : begin
      ldb_pad_ok = 1'b0 ;
    end
  endcase 

  dir_pad_ok = 1'b0 ;

  case ( dir_cq_token_depth_select ) 
    4'h0 : begin
      dir_pad_ok = ( dir_cq_wptr == 2'd3 ) ? ( dir_cq_depth <= 13'd3 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd2 ) ? ( dir_cq_depth <= 13'd2 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd1 ) ? ( dir_cq_depth <= 13'd1 ) & ~ cfg_pad_first_write_dir : ( dir_cq_depth == 13'd0 ) ;
    end
    4'h1 : begin
      dir_pad_ok = ( dir_cq_wptr == 2'd3 ) ? ( dir_cq_depth <= 13'd7 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd2 ) ? ( dir_cq_depth <= 13'd6 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd1 ) ? ( dir_cq_depth <= 13'd5 ) & ~ cfg_pad_first_write_dir : ( dir_cq_depth <= 13'd4 ) ;
    end
    4'h2 : begin
      dir_pad_ok = ( dir_cq_wptr == 2'd3 ) ? ( dir_cq_depth <= 13'd15 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd2 ) ? ( dir_cq_depth <= 13'd14 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd1 ) ? ( dir_cq_depth <= 13'd13 ) & ~ cfg_pad_first_write_dir : ( dir_cq_depth <= 13'd12 ) ;
    end
    4'h3 : begin
      dir_pad_ok = ( dir_cq_wptr == 2'd3 ) ? ( dir_cq_depth <= 13'd31 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd2 ) ? ( dir_cq_depth <= 13'd30 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd1 ) ? ( dir_cq_depth <= 13'd29 ) & ~ cfg_pad_first_write_dir : ( dir_cq_depth <= 13'd28 ) ;
    end
    4'h4 : begin
      dir_pad_ok = ( dir_cq_wptr == 2'd3 ) ? ( dir_cq_depth <= 13'd63 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd2 ) ? ( dir_cq_depth <= 13'd62 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd1 ) ? ( dir_cq_depth <= 13'd61 ) & ~ cfg_pad_first_write_dir : ( dir_cq_depth <= 13'd60 ) ;
    end
    4'h5 : begin
      dir_pad_ok = ( dir_cq_wptr == 2'd3 ) ? ( dir_cq_depth <= 13'd127 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd2 ) ? ( dir_cq_depth <= 13'd126 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd1 ) ? ( dir_cq_depth <= 13'd125 ) & ~ cfg_pad_first_write_dir : ( dir_cq_depth <= 13'd124 ) ;
    end
    4'h6 : begin
      dir_pad_ok = ( dir_cq_wptr == 2'd3 ) ? ( dir_cq_depth <= 13'd255 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd2 ) ? ( dir_cq_depth <= 13'd254 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd1 ) ? ( dir_cq_depth <= 13'd253 ) & ~ cfg_pad_first_write_dir : ( dir_cq_depth <= 13'd252 ) ;
    end
    4'h7 : begin
      dir_pad_ok = ( dir_cq_wptr == 2'd3 ) ? ( dir_cq_depth <= 13'd511 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd2 ) ? ( dir_cq_depth <= 13'd510 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd1 ) ? ( dir_cq_depth <= 13'd509 ) & ~ cfg_pad_first_write_dir : ( dir_cq_depth <= 13'd508 ) ;
    end
    4'h8 : begin
      dir_pad_ok = ( dir_cq_wptr == 2'd3 ) ? ( dir_cq_depth <= 13'd1023 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd2 ) ? ( dir_cq_depth <= 13'd1022 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd1 ) ? ( dir_cq_depth <= 13'd1021 ) & ~ cfg_pad_first_write_dir : ( dir_cq_depth <= 13'd1020 ) ;
    end
    4'h9 : begin
      dir_pad_ok = ( dir_cq_wptr == 2'd3 ) ? ( dir_cq_depth <= 13'd2047 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd2 ) ? ( dir_cq_depth <= 13'd2046 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd1 ) ? ( dir_cq_depth <= 13'd2045 ) & ~ cfg_pad_first_write_dir : ( dir_cq_depth <= 13'd2044 ) ;
    end
    4'ha : begin
      dir_pad_ok = ( dir_cq_wptr == 2'd3 ) ? ( dir_cq_depth <= 13'd4095 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd2 ) ? ( dir_cq_depth <= 13'd4094 ) & ~ cfg_pad_first_write_dir :
                   ( dir_cq_wptr == 2'd1 ) ? ( dir_cq_depth <= 13'd4093 ) & ~ cfg_pad_first_write_dir : ( dir_cq_depth <= 13'd4092 ) ;
    end
    default : begin
      dir_pad_ok = 1'b0 ;
    end
  endcase 

end // always_comb

endmodule // hqm_chp_sys_wb_pad_flag
