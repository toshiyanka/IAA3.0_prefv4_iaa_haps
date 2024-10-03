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

module hqm_iosf_handshake #(

     parameter WIDTH     = 1
    ,parameter GATE_DOUT = 1

) (

     input  logic               clk_src
    ,input  logic               rst_src_n

    ,input  logic               val_src
    ,input  logic   [WIDTH-1:0] dat_src

    ,output logic               rdy_src

    ,input  logic               clk_dst
    ,input  logic               rst_dst_n

    ,output logic               val_dst
    ,output logic   [WIDTH-1:0] dat_dst

    ,input  logic               rdy_dst
);

logic               val_src_q;
logic               val_src_sync2dst;
logic               rdy_src_q;
logic   [WIDTH-1:0] dat_src_q;
logic               val_dst_q;
logic   [WIDTH-1:0] dat_dst_q;
logic               rdy_dst_q;
logic               rdy_dst_sync2src;

//--------------------------------------------------------------------------------------------------------------------------
// Register the val_src level signal and dat_src data bus as val_src_q and dst_src_q in src clock domain.
// Only load dst_src_q on rising edge of val_src if rdy_src_q is not also set (prior transaction not yet cleared).
// This holds dst_src_q stable in the src clock domain until the val_src_q can be synced into the dst clock domain and used
// to gate the transfer of the data into the dst clock domain.
//
//                        val src->dst            val->rdy    rdy dst->src    clr src->dst        clr dst->src
//                             sync                                sync            sync                sync
//                   _   _   _       _   _   _   _       _   _   _       _   _   _       _   _   _   _       _   _   _   _
// clk_src          | |_| |_| |_ ~ _| |_| |_| |_| |_ ~ _| |_| |_| |_ ~ _| |_| |_| |_ ~ _| |_| |_| |_| |_ ~ _| |_| |_| |_| |_
//                   ___________   _________________   _____________   _____     ___   _________________   _________________
// val_src          |            ~                   ~               ~      |___|    ~                   ~ 
//                   ___________   _________________   _____________   _____     ___   _________________   _________________
// dat_src          X___________ ~ _________________ ~ _____________ ~ _____XXXXX___ ~ _________________ ~ _________________
//                       _______   _________________   _____________   _____                                         _______
// val_src_q        ____|        ~                   ~               ~      |_______ ~ _________________ ~ _________|
//                       _______   _________________   _____________   _____________   _________________   _________ _______
// dat_src_q        XXXXX_______ ~ _________________ ~ _____________ ~ _____________ ~ _________________ ~ _________X_______
//
// val_src_q is synced into the dst clock domain and used to load the val_dst_q flop and dat_dst_q reg.
// The multibit dat_src_q -> dat_dst_q path is an async crossing that should be gated by the val_src_sync2dst signal.
// These flops source the qualified val_dst and dat_dst outputs until the clock after the rdy_dst is received.
//                    ___     __      ___     ___         ___     __      ___     __      ___     ___         ___     ___
// clk_dst          _|   |___|   ~ __|   |___|   |__ ~ __|   |___|   ~ __|   |___|   ~ __|   |___|   |__ ~ __|   |___|   |__
//                                    ______________   _____________   _____________   __                  
// val_src_sync2dst ____________ ~ __|               ~               ~               ~   |______________ ~ _________________
//                                            ______   _____________   _____________   __________     
// val_dst_q        ____________ ~ __________|       ~               ~               ~           |______ ~ _________________
//                                            ______   _____________   _____________   _________________   _________________
// dat_dst_q        XXXXXXXXXXXX ~ XXXXXXXXXXX______ ~ _____________ ~ _____________ ~ _________________ ~ _________________
//                                            ______   __________                                     
// val_dst          ____________ ~ __________|       ~           |__ ~ _____________ ~ _________________ ~ _________________
//                                            ______   __________                                                           
// dat_dst          000000000000 ~ 0000000000X______ ~ __________X00 ~ 0000000000000 ~ 00000000000000000 ~ 00000000000000000
//
// Keep the val_dst and dat_dst valid until the rdy_dst pulse is received.
// Register the input rdy_dst response pulse from the destination as rdy_dst_q in the dst clock domain and keep that flop set
// until the clear comes back around (ultimately via the val_src_sync2dst signal deasserting).
//                                                        _______                                      
// rdy_dst          ____________ ~ _________________ ~ __|       |__ ~ _____________ ~ _________________ ~ _________________
//                                                                __   _____________   __________          
// rdy_dst_q        ____________ ~ _________________ ~ __________|   ~               ~           |______ ~ _________________
//
// Sync the rdy_dst_q back into the src clock domain so a rising edge on it can be used as the rdy_src pulse there.
// This synced signal will also clear the val_src_q flop, which will then ripple through to the dst clock domain and clear
// the rdy_dst_q flop, which in turn will ripple back to the src clock domain and deassert rdy_src_q to allow a new
// transaction to load the src_val_q flop and start the whole process over again.
//                                                                       ___________   _________________   _        
// rdy_dst_sync2src ____________ ~ _________________ ~ _____________ ~ _|            ~                   ~  |_______________
//                                                                           _______   _________________   _____
// rdy_src_q        ____________ ~ _________________ ~ _____________ ~ _____|        ~                   ~      |___________
//                                                                       ___                           
// rdy_src          ____________ ~ _________________ ~ _____________ ~ _|   |_______ ~ _________________ ~ _________________
//
//--------------------------------------------------------------------------------------------------------------------------

// Source clock domain

always_ff @(posedge clk_src or negedge rst_src_n) begin
 if (~rst_src_n) begin
  val_src_q <= '0;
  dat_src_q <= '0;
  rdy_src_q <= '0;
 end else begin
  val_src_q <= val_src & ~rdy_dst_sync2src & ~rdy_src_q;
  if (val_src & ~val_src_q & ~rdy_src_q) dat_src_q <= dat_src;
  rdy_src_q <= rdy_dst_sync2src;
 end
end

// Sync valid from source clock domain to dest clock domain

hqm_AW_sync_rst0 u_sync_dst (

     .clk       (clk_dst)
    ,.rst_n     (rst_dst_n)
    ,.data      (val_src_q)
    ,.data_sync (val_src_sync2dst)
);

// Destination clock domain

always_ff @(posedge clk_dst or negedge rst_dst_n) begin
 if (~rst_dst_n) begin
  val_dst_q <= '0;
  dat_dst_q <= '0;
  rdy_dst_q <= '0;
 end else begin
  val_dst_q <= val_src_sync2dst;
  if (val_src_sync2dst) dat_dst_q <= dat_src_q;             // Gated clock crossing on multibit data here
  rdy_dst_q <= (rdy_dst | rdy_dst_q) & val_src_sync2dst;
 end
end

assign val_dst = val_dst_q & ~rdy_dst_q;

generate
 if (GATE_DOUT == 1) begin: g_mdout
  assign dat_dst = dat_dst_q & {WIDTH{(val_dst_q & ~rdy_dst_q)}};
 end else begin: g_dout
  assign dat_dst = dat_dst_q;
 end
endgenerate

// Sync ready from dest clock domain to source clock domain

hqm_AW_sync_rst0 u_sync_src (

     .clk       (clk_src)
    ,.rst_n     (rst_src_n)
    ,.data      (rdy_dst_q)
    ,.data_sync (rdy_dst_sync2src)
);

// Generate ready pulse in source clock domain

assign rdy_src = rdy_dst_sync2src & ~rdy_src_q;

endmodule

