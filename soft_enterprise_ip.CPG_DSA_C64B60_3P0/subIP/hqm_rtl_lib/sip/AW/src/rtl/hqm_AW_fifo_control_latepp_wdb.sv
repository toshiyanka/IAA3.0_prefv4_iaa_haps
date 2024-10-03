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
//
// AW_fifo_control_latepp_wdb
//
// This is just a wrapper for the AW_fifo_control_latepp FIFO controller and includes a double buffer at the
// bottom of the FIFO to take the memory read latency out of any timing paths and decouple the pop timing.
//
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_fifo_control_latepp_wdb

    import hqm_AW_pkg::* ;

#(
     parameter DEPTH                = 8
    ,parameter DWIDTH               = 16
    ,parameter MEMRE_POWER_OPT      = 0
    ,parameter NUM_V                = 1
    //............................................................................................................................................
    ,parameter DEPTHB2              = ( AW_logb2 ( DEPTH -1 ) + 1 )
    ,parameter DEPTHWIDTH           = ( AW_logb2 ( DEPTH    ) + 1 )
    ,parameter WMWIDTH              = ( AW_logb2 ( DEPTH +1 ) + 1 )

) (

     input  logic                   clk
    ,input  logic                   rst_n
    
    ,input  logic                   push
    ,input  logic [DWIDTH-1:0]      push_data
    ,input  logic                   pop

    ,output logic [NUM_V-1:0]       pop_data_v
    ,output logic [DWIDTH-1:0]      pop_data
    
    ,input  logic [WMWIDTH-1:0]     cfg_high_wm
    
    ,output logic                   mem_we
    ,output logic [DEPTHB2-1:0]     mem_waddr
    ,output logic [DWIDTH-1:0]      mem_wdata
    ,output logic                   mem_re
    ,output logic [DEPTHB2-1:0]     mem_raddr
    ,input  logic [DWIDTH-1:0]      mem_rdata
    
    ,output aw_fifo_status_t        fifo_status
    ,output logic                   fifo_full
    ,output logic                   fifo_afull
    ,output logic [6:0]             db_status
);

//--------------------------------------------------------------------------------------------

logic                       fifo_push;
logic                       fifo_pop;
logic   [DWIDTH-1:0]        fifo_pop_data;
logic                       fifo_empty;

logic                       db_ready;
logic                       db_v;
logic   [DWIDTH-1:0]        db_data;

//--------------------------------------------------------------------------------------------

hqm_AW_fifo_control_latepp #(

     .DEPTH             (DEPTH)
    ,.DWIDTH            (DWIDTH)
    ,.MEMRE_POWER_OPT   (MEMRE_POWER_OPT)

) i_hqm_AW_fifo_control_latepp (

     .clk               (clk)
    ,.rst_n             (rst_n)
    
    ,.push              (fifo_push)
    ,.push_data         (push_data)
    ,.pop               (fifo_pop)
    ,.pop_data          (fifo_pop_data)
    
    ,.cfg_high_wm       (cfg_high_wm)
    
    ,.mem_we            (mem_we)
    ,.mem_waddr         (mem_waddr)
    ,.mem_wdata         (mem_wdata)
    ,.mem_re            (mem_re)
    ,.mem_raddr         (mem_raddr)
    ,.mem_rdata         (mem_rdata)
    
    ,.fifo_status       (fifo_status)
    ,.fifo_full         (fifo_full)
    ,.fifo_afull        (fifo_afull)
    ,.fifo_empty        (fifo_empty)
);

assign fifo_push = push & ~(db_ready & fifo_empty);
assign fifo_pop  = ~fifo_empty & db_ready;

assign db_v      = db_ready & (push | ~fifo_empty);
assign db_data   = (db_ready & push & fifo_empty) ? push_data : fifo_pop_data;

hqm_AW_double_buffer #(.WIDTH($bits(fifo_pop_data))) i_db (

     .clk           (clk)
    ,.rst_n         (rst_n)

    ,.status        (db_status)

    ,.in_ready      (db_ready)

    ,.in_valid      (db_v)
    ,.in_data       (db_data)

    ,.out_ready     (pop)

    ,.out_valid     (pop_data_v)
    ,.out_data      (pop_data)
);

endmodule // hqm_AW_fifo_control_latepp_wdb

