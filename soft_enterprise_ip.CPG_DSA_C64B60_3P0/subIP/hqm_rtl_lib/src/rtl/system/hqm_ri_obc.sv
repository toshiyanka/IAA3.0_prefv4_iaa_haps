// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_obc
// -- Author : Dannie Feekes
// -- Project Name : Cave Creek
// -- Creation Date: Thursday December 30, 2008
// -- Description :
// -- RI Outbound Completion FUB
// -- All outbound completion headers and data to TI are scheduled
// -- and maintained here. There are essentially two data paths
// -- for the completion transaction in the RI_OBC FUB. 1) The CSR
// -- completion path and 2) the CPP completion data path. This FUB
// -- will arbitrate between these two paths and handle the
// -- handshaking between the CPP and link clock
// -- domain when an outbound completion is ready to be sent.
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_ri_obc

     import hqm_sif_pkg::*, hqm_system_type_pkg::*, hqm_sif_csr_pkg::*;
(
     input  logic                               prim_nonflr_clk         // Clock
    ,input  logic                               prim_gated_rst_b        // Active low reset

    // Outbound completions from CDS

    ,output logic                               obcpl_fifo_afull        // Outbound completion FIFO is full

    ,input  logic                               obcpl_fifo_push         // Outbound completion valid
    ,input  RiObCplHdr_t                        obcpl_fifo_push_hdr     // Outbound completion headr
    ,input  csr_data_t                          obcpl_fifo_push_data    // Outbound completion data
    ,input  logic                               obcpl_fifo_push_dpar    // Outbound completion data parity
    ,input  upd_enables_t                       obcpl_fifo_push_enables // Outbound completion enable update

    // OBC -> MSTR

    ,output logic                               obcpl_v                 // Outbound completion valid to MSTR
    ,output RiObCplHdr_t                        obcpl_hdr               // Outbound completion header to MSTR
    ,output csr_data_t                          obcpl_data              // Outbound completion data to MSTR
    ,output logic                               obcpl_dpar              // Outbound completion data parity to MSTR
    ,output upd_enables_t                       obcpl_enables           // Outbound completion enable update to MSTR

    ,input  logic                               obcpl_ready             // MSTR accepting outbound completions

    // Config and Status

    ,input  OBCPL_AFULL_AGITATE_CONTROL_t       obcpl_afull_agitate_control

    ,output logic [31:0]                        obcpl_fifo_status

    ,output logic                               obc_idle

    ,output logic [63:0]                        obc_noa                 // OBC NOA debug signals
);

//-----------------------------------------------------------------

localparam OBCPL_FIFO_WIDTH = $bits(obcpl_fifo_push_dpar)
                            + $bits(obcpl_fifo_push_data)
                            + $bits(obcpl_fifo_push_hdr)
                            + $bits(obcpl_fifo_push_enables);

logic                                   obcpl_fifo_pop;             // Pop the next CSR completion data.
logic                                   obcpl_fifo_pop_data_v;      // Valid data available from the CSR fifo.
logic                                   obcpl_fifo_full_nc;
logic                                   obcpl_fifo_afull_raw;       // Obcpl FIFO is full

logic                                   obcpl_fifo_we;
logic                                   obcpl_fifo_re;
logic [1:0]                             obcpl_fifo_waddr;
logic [1:0]                             obcpl_fifo_raddr;
logic [OBCPL_FIFO_WIDTH-1:0]            obcpl_fifo_wdata;
logic [OBCPL_FIFO_WIDTH-1:0]            obcpl_fifo_rdata;
logic [OBCPL_FIFO_WIDTH-1:0]            obcpl_mem[3:0];

//-----------------------------------------------------------------
// Outbound completion FIFO

hqm_AW_fifo_control_wreg #(

     .DEPTH                 (4)
    ,.DWIDTH                (OBCPL_FIFO_WIDTH)
    ,.MEMRE_POWER_OPT       (0)

) i_obcpl_fifo (

     .clk                   (prim_nonflr_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           (3'd4)

    ,.push                  (obcpl_fifo_push)
    ,.push_data             ({
                             obcpl_fifo_push_enables
                            ,obcpl_fifo_push_hdr
                            ,obcpl_fifo_push_dpar
                            ,obcpl_fifo_push_data
                            })

    ,.pop                   (obcpl_fifo_pop)
    ,.pop_data_v            (obcpl_fifo_pop_data_v)
    ,.pop_data              ({
                             obcpl_enables
                            ,obcpl_hdr
                            ,obcpl_dpar
                            ,obcpl_data
                            })

    ,.mem_we                (obcpl_fifo_we)
    ,.mem_waddr             (obcpl_fifo_waddr)
    ,.mem_wdata             (obcpl_fifo_wdata)
    ,.mem_re                (obcpl_fifo_re)
    ,.mem_raddr             (obcpl_fifo_raddr)
    ,.mem_rdata             (obcpl_fifo_rdata)

    ,.fifo_status           (obcpl_fifo_status)
    ,.fifo_full             (obcpl_fifo_full_nc)                              
    ,.fifo_afull            (obcpl_fifo_afull_raw)
);

always_ff @(posedge prim_nonflr_clk) begin
 if (obcpl_fifo_re) obcpl_fifo_rdata <= obcpl_mem[obcpl_fifo_raddr];
 if (obcpl_fifo_we) obcpl_mem[obcpl_fifo_waddr] <= obcpl_fifo_wdata; 
end

assign obcpl_v        = obcpl_fifo_pop_data_v;
assign obcpl_fifo_pop = obcpl_v & obcpl_ready;

//-------------------------------------------------------------------------

hqm_AW_agitate #(.SEED(32'h6283)) i_agitate_obcpl_fifo_afull (

     .clk                   (prim_nonflr_clk)
    ,.rst_n                 (prim_gated_rst_b)
    ,.control               (obcpl_afull_agitate_control)
    ,.in_agitate_value      (1'b1)
    ,.in_data               (obcpl_fifo_afull_raw)
    ,.in_stall_trigger      (1'b1)
    ,.out_data              (obcpl_fifo_afull)
);

//-------------------------------------------------------------------------

//TBD: Update noa

always_comb begin

 obc_idle = ~(obcpl_fifo_push | obcpl_v);

 obc_noa  = {40'd0

            ,obcpl_hdr.rid[15:8]        // 2

            ,obcpl_hdr.tag[7:0]         // 1

            ,obcpl_v                    // 0
            ,obcpl_hdr.cs
            ,obcpl_fifo_push
            ,obcpl_fifo_pop
            ,obcpl_fifo_pop_data_v
            ,obcpl_fifo_afull
            };

end

endmodule // hqm_ri_obc

