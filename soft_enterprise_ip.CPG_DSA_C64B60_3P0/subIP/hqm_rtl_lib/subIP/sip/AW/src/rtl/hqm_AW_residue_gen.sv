//-----------------------------------------------------------------------------------------------------
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
//
// hqm_AW_residue_gen : n-bit residue generator
//
// The following parameters are supported:
//
//      WIDTH           Width of the datapath on which to generate residue.
//
//-----------------------------------------------------------------------------------------------------
// 

module hqm_AW_residue_gen
  import hqm_AW_pkg::* ; # (
  parameter WIDTH        = 4
) (
  input  logic [WIDTH-1:0]      a
, output logic [1:0]            r
) ;

localparam WIDTH_ADJ            = ( WIDTH < 4 ) ? 4 : WIDTH ;
localparam WIDTH_SCALED         = ( 1 << ( AW_logb2 ( WIDTH_ADJ - 1 ) + 1 ) ) ;
localparam HALF_WIDTH_SCALED    = ( 1 << ( AW_logb2 ( WIDTH_ADJ - 1 )     ) ) ;
localparam DEPTH                = AW_logb2(WIDTH_SCALED-1) ;    // Number of levels of residue generators

genvar  g_lev , g_ix ;

logic   [WIDTH_SCALED-1:0]      a_pad ;
logic   [WIDTH_SCALED-1:0]      rdat_pnc [DEPTH:0] ;    // m.s. bits unused in later/narrower stages

always_comb begin
  a_pad                         = { WIDTH_SCALED { 1'b0 } } ;
  a_pad [WIDTH-1:0]             = a ;
end

generate
  for ( g_lev = DEPTH ; g_lev >= 0 ; g_lev = g_lev - 1 ) begin : g_resg_for_lev
    for ( g_ix = 0 ; g_ix <= ( HALF_WIDTH_SCALED - 1 ) ; g_ix = g_ix + 1 ) begin : g_resg_for_ix
      if ( g_ix > ( ( 2 ** g_lev ) - 1 ) ) begin : g_resg_pad
        assign rdat_pnc [g_lev] [(2*g_ix) +: 2]     = 2'h0 ;
        hqm_AW_unused_bits #(.WIDTH(2)) i_unused_resgen (.a(rdat_pnc [g_lev] [(2*g_ix) +: 2] ) );
      end
      else begin : g_resg_nopad
        if ( g_lev == DEPTH ) begin : g_resg_if
          assign rdat_pnc [g_lev] [(2*g_ix) +: 2]     = ( a_pad [(2*g_ix) +: 2] == 2'h3 ) ? 2'h0 : a_pad [(2*g_ix) +: 2] ;
        end
        else begin : g_resg_else
          hqm_AW_residue_add i_res_add (
                    .a ( rdat_pnc [g_lev+1] [ (4*g_ix)    +: 2] )
                  , .b ( rdat_pnc [g_lev+1] [((4*g_ix)+2) +: 2] )
                  , .r ( rdat_pnc [g_lev]   [ (2*g_ix)    +: 2] ) ) ;
        end
      end
    end
  end
endgenerate

assign r        = rdat_pnc [0] [1:0] ;

endmodule
// 
