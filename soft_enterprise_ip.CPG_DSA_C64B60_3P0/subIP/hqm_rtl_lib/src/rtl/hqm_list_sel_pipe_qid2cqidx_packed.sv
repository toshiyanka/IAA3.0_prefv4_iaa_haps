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
//
//  pack 4 8b entry into single 128x32 RAM. Each 8b has a parity bit. Total number of 8b entry is 512
//
//
//  DOES NOT SUPPORT simultaneous re & we,
//  this is intended for application where only write access is by CONFIG
//   and the CONFIG WRITE blocks read access for the duration of the CFG WRITE + 2 cycles
//
//-----------------------------------------------------------------------------------------------------

module hqm_list_sel_pipe_qid2cqidx_packed (

    input  logic                        wclk
  , input  logic                        we
  , input  logic [ ( 9 ) -1 : 0 ]       waddr
  , input  logic [ ( 8 ) -1 : 0 ]       wdata
  , input  logic                        wdata_parity

  , input  logic                        rclk
  , input  logic [ ( 9 ) -1 : 0 ]       raddr
  , input  logic                        re
  , output logic [ ( 8 ) -1 :0 ]        rdata
  , output logic [ ( 1 ) -1 :0 ]        rdata_parity
  , output logic [ ( 36 ) -1 :0 ]       rdata_unpacked

  , input  logic                        rst_n

  //------------------------------------------------------------
  // fuse interface
  , input  logic [ 3 : 0 ]             fuse_misc_rf_in

  //------------------------------------------------------------
  // scan interface
  , input  logic                        fscan_ram_wrdis_b
  , input  logic                        fscan_ram_rddis_b
  , input  logic                        fscan_ram_odis_b

   //------------------------------------------------------------
   // power management interface
   , input  logic [ 3 : 0 ]             pwr_mgmt_in
   , output logic [ 3 : 0 ]             pwr_mgmt_out
);

//-----------------------------------------------------------------------------------------------------

localparam NUM_RAMS = 1 ;
logic [ ( NUM_RAMS+1 ) -1 : 0 ][ ( 4 ) -1 : 0 ] pwr_mgmt ;

logic mux_re ;
logic [ ( 7  ) -1 : 0 ] mux_addr ;
logic mux_we ;
logic [ ( 36  ) -1 : 0 ] mux_wdata ;
logic [ ( 36  ) -1 : 0 ] mux_rdata;

logic p0_we_f , p0_we_nxt ;
logic p0_re_f , p0_re_nxt ;
logic [ ( 9 ) -1 : 0 ] p0_addr_f , p0_addr_nxt ;
logic [ ( 36 ) -1 : 0 ] p0_data_f , p0_data_nxt ;

logic p1_we_f , p1_we_nxt ;
logic p1_re_f , p1_re_nxt ;
logic [ ( 9 ) -1 : 0 ] p1_addr_f , p1_addr_nxt ;
logic [ ( 36 ) -1 : 0 ] p1_data_f , p1_data_nxt ;

always_ff @(posedge rclk or negedge rst_n) begin
  if (!rst_n) begin
    p0_we_f <= '0 ;
    p0_re_f <= '0 ;
    p0_addr_f <= '0 ;
    p0_data_f <= '0 ;
    p1_we_f <= '0 ;
    p1_re_f <= '0 ;
    p1_addr_f <= '0 ;
    p1_data_f <= '0 ;
  end
  else begin
    p0_we_f <= p0_we_nxt ;
    p0_re_f <= p0_re_nxt ;
    p0_addr_f <= p0_addr_nxt ;
    p0_data_f <= p0_data_nxt ;
    p1_we_f <= p1_we_nxt ;
    p1_re_f <= p1_re_nxt ;
    p1_addr_f <= p1_addr_nxt ;
    p1_data_f <= p1_data_nxt ;
  end
end

hqm_AW_rf_rw_128x36 i_g (
    .clk                                ( wclk )
  , .we                                 ( mux_we )
  , .addr                               ( mux_addr )
  , .wdata                              ( mux_wdata )
  , .re                                 ( mux_re )
  , .rdata                              ( mux_rdata )
  , .fuse_misc_rf_in                    ( fuse_misc_rf_in )
  , .fscan_ram_wrdis_b                  ( fscan_ram_wrdis_b )
  , .fscan_ram_rddis_b                  ( fscan_ram_rddis_b )
  , .fscan_ram_odis_b                   ( fscan_ram_odis_b )
  , .pwr_mgmt_in                        ( 4'b0 ) 
  , .pwr_mgmt_out                       (  )
);

assign pwr_mgmt[ 0 ] = pwr_mgmt_in ;
assign pwr_mgmt_out = 4'b0 ;

always_comb begin
  rdata = '0 ;
  rdata_parity = '0 ;

  mux_re = '0 ;
  mux_addr = '0 ;
  mux_we = '0 ;
  mux_wdata = '0 ;
 
  p0_we_nxt = '0 ;
  p0_re_nxt = '0 ;
  p0_addr_nxt = p0_addr_f ;
  p0_data_nxt = p0_data_f ;
  p1_we_nxt = '0 ;
  p1_re_nxt = '0 ;
  p1_addr_nxt = p1_addr_f ;
  p1_data_nxt = p1_data_f ;

  // READ
  if ( re ) begin
    mux_re = 1'd1 ;
    mux_addr = raddr[ 8 : 2 ] ;
    p0_we_nxt = '0 ;
    p0_re_nxt = 1'b1 ;
    p0_addr_nxt = raddr ;
  end
  if ( p0_re_f & ~p0_we_f ) begin
    p1_we_nxt = 1'b0 ;
    p1_re_nxt = 1'b0 ;
    rdata = mux_rdata[ ( p0_addr_f[1:0] * 8 ) +: 8 ] ;
    rdata_parity = mux_rdata[ ( 32 + p0_addr_f[1:0] ) +: 1 ] ;
  end

  // WRITE (read modify write 1B + parity bit )
  if ( we ) begin
    mux_re = 1'd1 ;
    mux_addr = {1'b0,waddr[ 8 : 2 ]} ;
    p0_we_nxt = 1'b1 ;
    p0_re_nxt = 1'b1 ;
    p0_addr_nxt = waddr ;
    p0_data_nxt[ ( 8 ) -1 : 0 ]  = wdata ;
    p0_data_nxt[ 8 ]  = wdata_parity ;
  end
  if ( p0_re_f & p0_we_f ) begin
    p1_we_nxt = 1'b1 ;
    p1_re_nxt = 1'b1 ;
    p1_addr_nxt = p0_addr_f ;
    p1_data_nxt = mux_rdata ;
    p1_data_nxt[ ( p0_addr_f[1:0] * 8 )  +: 8 ] = p0_data_f[ 7 : 0 ] ;
    p1_data_nxt[ ( 32 + p0_addr_f[1:0] ) +: 1 ] = p0_data_f[ 8 ];
  
  end
  if ( p1_re_f & p1_we_f ) begin
    mux_we = 1'd1 ;
    mux_addr = {1'b0,p1_addr_f[ 8 : 2 ]} ;
    mux_wdata = p1_data_f ;
  end

  rdata_unpacked   = mux_rdata ;

end

endmodule
