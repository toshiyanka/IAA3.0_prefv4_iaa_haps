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
// hqm_AW_rtdr_reg
//
// This module implements a TAP Remote TDR register which supports shift, update and capture.
//
// The following parameters are supported:
//
//   DWIDTH     Width of the RDTR register
//
// Note that as per spec there are falling-edge flops and outputs in this design.
//-----------------------------------------------------------------------------------------------------

module hqm_AW_rtdr_reg

#(
  parameter DWIDTH      = 32
) (
  input  logic                  tck
, input  logic                  trstb
, input  logic                  tdi      
, input  logic                  irdec           // Instruction decode to access this register
, input  logic                  shiftdr   
, input  logic                  updatedr
, input  logic                  capturedr
, input  logic [DWIDTH-1:0]     func_pi         // Parallel input for capture
, output logic                  tdo
, output logic [DWIDTH-1:0]     func_po         // Parallel output for functional control
);

logic [DWIDTH-1:0]              rtdr_nxt ;
logic [DWIDTH-1:0]              rtdr_f ;
logic [DWIDTH-1:0]              rtdr_upd_nxt ;
logic [DWIDTH-1:0]              rtdr_upd_f ;

always_comb begin
  rtdr_nxt              = rtdr_f ;
  if ( irdec & capturedr ) begin
    rtdr_nxt            = func_pi ;
  end
  else if ( irdec & shiftdr ) begin
    rtdr_nxt            = { tdi , rtdr_f[DWIDTH-1:1] } ;
  end
end // always

always_ff @( posedge tck or negedge trstb ) begin
  if ( ~trstb ) begin
    rtdr_f              <= '0 ;
  end
  else begin
    rtdr_f              <= rtdr_nxt ;
  end
end // always

assign tdo              = rtdr_f [0] ;


always_comb begin
  rtdr_upd_nxt  = rtdr_upd_f ;
  if ( irdec & updatedr ) begin
    rtdr_upd_nxt        = rtdr_f ;
  end
end // always

always_ff @( negedge tck or negedge trstb ) begin
  if ( ~trstb ) begin
    rtdr_upd_f          <= '0 ;
  end
  else begin
    rtdr_upd_f          <= rtdr_upd_nxt ;
  end
end // always

assign func_po          = rtdr_upd_f ;

endmodule // hqm_AW_rtdr_reg
