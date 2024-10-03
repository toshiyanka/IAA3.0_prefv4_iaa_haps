// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_cbd
// -- Author : Mike Betker
// -- Project Name : HQM
// -- Creation Date: Dec 22, 2015
// -- Description :
// -- Command BAR Decode
// -- The command BAR decode module will receive the incoming posted
// -- and non posted PCI transactions and determine the destination
// -- of the incoming PCIE transaction.
// --
// -- cbd_*_bar_hit is the output for the module which will
// -- signal which bar was hit after the module has been queued to
// -- decode an address (assertion of cds_hdr_v and the address to
// -- decode csd_addr).
// --                     ----------------------------------
// --     cds_hdr_v ----> |                                |
// --                     |= bar0 addr -> bar0 limit--\ |  |
// --     cds_hdr.addr -> |= bar1 addr -> bar0 limit---|\--| cbd_*_bar_hit
// --                     |=                        ---|/  |
// --                     |= barN addr -> barN limit--/    |
// --                     |                                |
// --                     |                                |
// --                     ---------------------------------
// -- The decode is done in two clocks and should be available two
// -- clocks following the assertion of cds_hdr_v in most cases.
// --
// -- All inputs are flopped and the bar and region decodes are done in the decode stage.
// --
// -- clk         __|--|__|--|__|--|__|--|__|--|__|--|__|--|
// -- cds_hdr_v   ________|-----------|_____________________
// -- cds_hdr.addr--------<  X  >< Y  >---------------------
// -- decode_val_dstg___________|-----------|________________
// -- bar_hit_dstg______________|-----------|________________
// -- cbd_bar_hit ____________________|-----------|__________
// -- cbd_bar_offset__________________<OFFX><OFFY >__________
// -- cbd_rgn_hit ____________________|-----------|_________
// -- cbd_region_off_wxp______________<REGX><REGY >_________
// -- cbd_decode_val__________________|-----------|_________
// -- cds_take_decode_________________|-----------|_________
// --
// --
// -- Decode requests should not be made when cbd_rdy is not asserted.
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_ri_cbd

  import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*;
(
    //-----------------------------------------------------------------
    // Clock and reset
    //-----------------------------------------------------------------

    input  logic                            prim_nonflr_clk,            // CPP clock
    input  logic                            prim_gated_rst_b,           // Active low soft or hard reset

    //-----------------------------------------------------------------
    // Inputs
    //-----------------------------------------------------------------

    // TLQ header fifo outputs

    input logic                             cds_hdr_v,                  // The header is valid
    input logic                             cds_hdr_mmio,               // The header is not a CFG op
    input logic                             cds_hdr_check,              // The header requires bar decoding
    input cbd_hdr_t                         cds_hdr,                    // Header being decoded
    input tlq_pdata_t                       cds_wr_data,                // Write data
    input tlq_pdata_t                       cds_wr_data2,               // Write data (2nd cycle)

    input logic                             cds_take_decode,            // Take the current decode from CBD

    // IOSF sideband based transaction, only needed to see if certain transactions are enabled

    input logic                             iosfsb_mmio_txn,            // indicates this is an iosf sideband mmio transaction
    input logic [2:0]                       iosfsb_mmio_bar,            // iosf sideband mmio bar
    input logic [7:0]                       iosfsb_mmio_fid,            // iosf sideband mmio fid

    // BAR's

    input hdr_addr_t                        func_pf_bar,                // Func_PF BAR
    input hdr_addr_t                        csr_pf_bar,                 // CSR_PF BAR

    input logic                             csr_pcicmd_mem,             // physical function memory space enable

    //-----------------------------------------------------------------
    // Outputs
    //-----------------------------------------------------------------

    output logic                            cbd_rdy,                    // Signal that the decoder is ready.
    output logic                            cbd_busy,                   // Signal that the decoder is active
    output logic [3:0]                      cbd_decode_val,             // BAR decode data valid.
    output logic [1:0]                      cbd_func_pf_rgn_hit,        // The region within the BAR where an address hit
    output logic [1:0]                      cbd_csr_pf_rgn_hit,         // The region within the BAR where an address hit
    output logic [31:2]                     cbd_bar_offset,             // Address offset from the BAR
    output logic                            cbd_bar_offset_par,         // Parity on the bar offset
    output logic [1:0]                      cbd_func_pf_bar_hit,        // FUNC_PF BAR hit
    output logic                            cbd_csr_pf_bar_hit,         // CSR_PF BAR hit
    output cbd_hdr_t                        cbd_hdr,                    // The header of the address which just completed BAR decode.
    output logic                            cbd_hdr_mmio,               // Indication that cbd_hdr is not a CFG transaction
    output tlq_pdata_t                      cbd_wr_data,                // Write data associated with header/address
    output tlq_pdata_t                      cbd_wr_data2,               // Write data (2nd cycle) associated with header/address

    // Errors

    output logic                            cbd_bar_miss_err_wp,        // Address did not hit a BAR
    output logic                            cbd_multi_bar_hit_err_wp    // Multiple BAR hits, will turn off all BAR hits
);

// -------------------------------------------------------------------

logic                               reset_ff;                       // Flopped version of reset

hdr_addr_t                          func_pf_bar_dstg;               // FUNC_PF BAR
hdr_addr_t                          csr_pf_bar_dstg;                // CSR_PF BAR

logic                               dstg_full;                      // Decode stage reg is full
logic                               decode_valid;                   // OK to decode the incoming addr

logic                               decode_val_dstg;                // Valid decoded address in decode stage

logic                               cds_hdr_mmio_dstg;              // Header is not a CFG op
logic                               cds_hdr_check_dstg;             // Header requires decoding
cbd_hdr_t                           cds_hdr_dstg;                   // Header being decoded
tlq_pdata_t                         cds_wr_data_dstg;               // Write data going w/ the header being decoded
tlq_pdata_t                         cds_wr_data2_dstg;              // Write data (2nd cycle) going w/ the header being decoded

logic                               iosfsb_mmio_txn_dstg;           // used in conjunction with prod fuse
logic [2:0]                         iosfsb_mmio_bar_dstg;           // iosf sideband mmio bar
logic [7:0]                         iosfsb_mmio_fid_dstg;           // iosf sideband mmio fid

logic [31:2]                        bar_offset_dstg;                // The address offset from the BAR
logic                               bar_offset_par_dstg;            // Parity on the bar offset

logic                               func_pf_bar_disabled;           // FUNC_PF BAR disabled
logic                               csr_pf_bar_disabled;            // CSR_PF BAR disabled

logic                               func_pf_bar_hit_dstg;           // FUNC_PF BAR hit decode stage
logic                               csr_pf_bar_hit_dstg;            // CSR_PF BAR hit decode stage

logic [1:0]                         cbd_func_pf_bar_hit_raw;        // FUNC_PF BAR hit before multi BAR hit mask
logic [1:0]                         cbd_csr_pf_bar_hit_raw;         // CSR_PF BAR hit before multi BAR hit mask

logic [1:0]                         func_pf_rgn_hit_dstg;           // The region within the FUNC_PF BAR where an address hit
logic [1:0]                         csr_pf_rgn_hit_dstg;            // The region within the CSR_PF BAR where an address hit

logic                               ostg_full;                      // Output stage reg is full

logic                               cbd_hdr_check;                  // Indication that cbd_hdr needed decoding

// -------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: reset_ff_p
    if (~prim_gated_rst_b) begin
        reset_ff <= 1'b0;
    end else begin
        reset_ff <= 1'b1;
    end
end

//-------------------------------------------------------------------------
// Capture BAR state for decode stage
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: pf0_bar_ff_p
    if (~prim_gated_rst_b) begin
        csr_pf_bar_dstg  <=  '0;
        func_pf_bar_dstg <=  '0;
    end else begin
        csr_pf_bar_dstg  <= csr_pf_bar;
        func_pf_bar_dstg <= func_pf_bar;
    end
end

// Signal when the CBD is ready to decode
//   There must be room in either the decode our output stage.
//   Use valid signals only, not dependent on cds_take_decode.

assign cbd_rdy = reset_ff & ~(decode_val_dstg & cbd_decode_val[0]);

// The decode stage is full if there it currently has a valid transaction
// and the output stage is full.

assign dstg_full = decode_val_dstg & ostg_full;

// The decode is valid if the input address is valid and the decode stage is not full

assign decode_valid = reset_ff & cds_hdr_v & ~dstg_full;

//-------------------------------------------------------------------------
// Pipe decode_valid forward if ~dstg_full
// Pipe the header, write data, and address to the decode stage if valid
// request advancing to that stage
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: cds_hdr_dstg_p

    if (~prim_gated_rst_b) begin

        decode_val_dstg      <= '0;

        cds_hdr_mmio_dstg    <= '0;
        cds_hdr_check_dstg   <= '0;
        cds_hdr_dstg         <= '0;
        cds_wr_data_dstg     <= '0;
        cds_wr_data2_dstg    <= '0;
        iosfsb_mmio_txn_dstg <= '0;
        iosfsb_mmio_bar_dstg <= '0;
        iosfsb_mmio_fid_dstg <= '0;

    end else begin

      if (~dstg_full) begin

        decode_val_dstg      <= decode_valid;

      end

      if (cds_hdr_v & cbd_rdy & ~dstg_full) begin

        cds_hdr_mmio_dstg    <= cds_hdr_mmio;
        cds_hdr_check_dstg   <= cds_hdr_check;
        cds_hdr_dstg         <= cds_hdr;
        cds_wr_data_dstg     <= cds_wr_data;
        cds_wr_data2_dstg    <= cds_wr_data2;
        iosfsb_mmio_txn_dstg <= iosfsb_mmio_txn;
        iosfsb_mmio_bar_dstg <= iosfsb_mmio_bar;
        iosfsb_mmio_fid_dstg <= iosfsb_mmio_fid;

      end

    end

end

//-------------------------------------------------------------------------
// The Address Decode
//-------------------------------------------------------------------------

assign bar_offset_dstg    = (func_pf_bar_hit_dstg) ?
                            {6'h0,cds_hdr_dstg.addr[25:2]} : cds_hdr_dstg.addr[31:2];

assign bar_offset_par_dstg = ^{cds_hdr_dstg.addr_par
                              ,cds_hdr_dstg.addr[`HQM_CSR_BAR_SIZE-1:32]
                              ,cds_hdr_dstg.addr[1:0]
                              ,(cds_hdr_dstg.addr[31:26] &
                                {6{func_pf_bar_hit_dstg}})};

always_comb begin: bar_hit_p

    // BAR disables

    csr_pf_bar_disabled  = ~cds_hdr_check_dstg | ~csr_pcicmd_mem;

    func_pf_bar_disabled = ~cds_hdr_check_dstg | ~csr_pcicmd_mem;

    csr_pf_bar_hit_dstg  = decode_val_dstg & ~csr_pf_bar_disabled &
                            ( (  iosfsb_mmio_txn_dstg &
                                (iosfsb_mmio_fid_dstg == 8'd0) &
                                (iosfsb_mmio_bar_dstg == 3'h2)
                              ) |
                              ( ~iosfsb_mmio_txn_dstg &
                                (cds_hdr_dstg.addr[63:32] == csr_pf_bar_dstg[63:32])
                              )
                            );

    func_pf_bar_hit_dstg = decode_val_dstg & ~func_pf_bar_disabled &
                            ( (  iosfsb_mmio_txn_dstg &
                                (iosfsb_mmio_fid_dstg == 8'd0) &
                                (iosfsb_mmio_bar_dstg == 3'h0)
                              ) |
                              ( ~iosfsb_mmio_txn_dstg &
                                (cds_hdr_dstg.addr[63:26] == func_pf_bar_dstg[63:26])
                              )
                            );
end // bar_hit_p

//-------------------------------------------------------------------------
// Device/Region Define
// Establish the memory range for each or the BARs regions.
//-------------------------------------------------------------------------

always_comb begin: bar_region_def_p

    csr_pf_rgn_hit_dstg[0]  = csr_pf_bar_hit_dstg  &  (cds_hdr_dstg.addr[31:28] == 4'h0);
    csr_pf_rgn_hit_dstg[1]  = csr_pf_bar_hit_dstg  &  (cds_hdr_dstg.addr[31:28] != 4'h0);

    func_pf_rgn_hit_dstg[0] = func_pf_bar_hit_dstg & ~(cds_hdr_dstg.addr[25] & cds_hdr_dstg.posted);
    func_pf_rgn_hit_dstg[1] = func_pf_bar_hit_dstg &  (cds_hdr_dstg.addr[25] & cds_hdr_dstg.posted);

end // always_comb bar_region_def_p

//-------------------------------------------------------------------------
// Output Stage Full
//   For the output stage, we signal full when there is currently a pending
//   completed decode in the output stage and it has not yet been taken.
//-------------------------------------------------------------------------

assign ostg_full = cbd_decode_val[0] & ~cds_take_decode;

assign cbd_busy  = cds_hdr_v | decode_val_dstg | cbd_decode_val[0];

//-------------------------------------------------------------------------
// Output stage pipe for Error, Hit, Offset and Header Data
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: cbd_rgn_decode_p

    if (~prim_gated_rst_b) begin

        cbd_decode_val          <= '0;

        cbd_csr_pf_bar_hit_raw  <= '0;
        cbd_func_pf_bar_hit_raw <= '0;
        cbd_func_pf_rgn_hit     <= '0;
        cbd_csr_pf_rgn_hit      <= '0;
        cbd_bar_offset          <= '0;
        cbd_bar_offset_par      <= '0;
        cbd_hdr_mmio            <= '0;
        cbd_hdr_check           <= '0;
        cbd_hdr                 <= '0;
        cbd_wr_data             <= '0;
        cbd_wr_data2            <= '0;

    end else begin

      if (~ostg_full) begin

        cbd_decode_val          <= {4{decode_val_dstg}};        // Replicate for fanout

      end

      if (decode_val_dstg & ~ostg_full) begin

        cbd_csr_pf_bar_hit_raw  <= {2{csr_pf_bar_hit_dstg}};    // Replicate for fanout
        cbd_func_pf_bar_hit_raw <= {2{func_pf_bar_hit_dstg}};   // Replicate for fanout
        cbd_func_pf_rgn_hit     <= func_pf_rgn_hit_dstg;
        cbd_csr_pf_rgn_hit      <= csr_pf_rgn_hit_dstg;
        cbd_bar_offset          <= bar_offset_dstg;
        cbd_bar_offset_par      <= bar_offset_par_dstg;
        cbd_hdr_mmio            <= cds_hdr_mmio_dstg;
        cbd_hdr_check           <= cds_hdr_check_dstg;
        cbd_hdr                 <= cds_hdr_dstg;
        cbd_wr_data             <= cds_wr_data_dstg;
        cbd_wr_data2            <= cds_wr_data2_dstg;

      end

    end

end

//-------------------------------------------------------------------------
// Signal that the address did not hit any of the BARS.
//-------------------------------------------------------------------------

assign cbd_bar_miss_err_wp = cbd_decode_val[0] & cbd_hdr_mmio & cbd_hdr_check &
                            ~( cbd_csr_pf_bar_hit_raw[0] |
                              cbd_func_pf_bar_hit_raw[0]);

//-------------------------------------------------------------------------
// Signal that the address hit multiple BARS.
//-------------------------------------------------------------------------

assign cbd_multi_bar_hit_err_wp = cbd_decode_val[0] &
        cbd_csr_pf_bar_hit_raw[0] & cbd_func_pf_bar_hit_raw[0];

assign cbd_csr_pf_bar_hit  =  cbd_csr_pf_bar_hit_raw[0] &
                            ~cbd_func_pf_bar_hit_raw[0];

assign cbd_func_pf_bar_hit = cbd_func_pf_bar_hit_raw &
                             ~cbd_csr_pf_bar_hit_raw;

//-------------------------------------------------------------------------
// Assertions
//-------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF
    assert_CBD_BAR_HIT_COUNTONES: assert property (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b)
    not (($countones({cbd_csr_pf_bar_hit_raw[0]
                     ,cbd_func_pf_bar_hit_raw[0]}) > 1) & cbd_decode_val[0]) )
    else $error ("hqm_ri_CBD_BAR_HIT_COUNTONES:CBD_BAR_HIT_MUTEX Assertion Failed.CDS_ADDR[`HQM_CBD_MAX_ADDR_WID-1:2]:%H CBD_CSR_BAR_HIT: %H CBD_FUNC_PF_BAR_HIT: %H"
        ,cds_hdr.addr[`HQM_CBD_MAX_ADDR_WID-1:2]
        ,cbd_csr_pf_bar_hit_raw[0]
        ,cbd_func_pf_bar_hit_raw[0]
    );

`endif

endmodule // hqm_ri_cbd

