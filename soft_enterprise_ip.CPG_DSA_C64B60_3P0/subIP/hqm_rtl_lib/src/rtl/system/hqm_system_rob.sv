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
// hqm_system_rob: Set of reorder buffers for putting HCW CLs back into the correct sequence order.
//
// Clients will write into the (up to) 16 CL address aperatures for a particular PP in a circular
// fashion with full CL writes (MOVDIR64) each containing 4 HCWs (could be NOOPs for padding).
// They will use the first power of 2 number of cache line addresses in the aperature depending on
// the reording support required.  Current implementation will also support getting less than 4
// HCWs per targeted cache line as long as the next write received is to the next expected cache
// line and not the same cache line (each write is to the next cache line in the circular buffer).
// Since different CLs have different addresses they could go through different CHAs and could arrive
// at the HQM out of order.  Need a reorder buffer to potentially save a fixed number worth of CLs
// (HQM_SYSTEM_NUM_ROB_CLS) for every PP (HQM_SYSTEM_NUM_ROB_PPS).
// Can use a single port SRAM that is HQM_SYSTEM_NUM_ROB_PPS*HQM_SYSTEM_NUM_ROB_CLS*4 deep to store
// the HCWs and their associated header info since there is no need for simultaneous read and write.
// The width is the 128b HCW bits plus an additional 28b for the header.
// HCW is covered by ECC and the other header info by parity, so the memory is error protected.
// Organization will be as follows where we stack the CLs for a single reordered PP and then stack
// that collection of CLs for each reordered PP in incrementing memory addresses.
// To support 128 reordered PPs with 2 CLs each would require a 1Kx155 memory.
// To support 128 reordered PPs with 4 CLs each would require a 2Kx156 memory.
//
//                           +--------------------------------------+ \
// Addr NUM_PPS*NUM_CLS*4-1: + ROB[NUM_PPS-1]: CL[NUM_CLS-1] Index3 |  |
//                           + ROB[NUM_PPS-1]: CL[NUM_CLS-1] Index2 |  |
//                           + ROB[NUM_PPS-1]: CL[NUM_CLS-1] Index1 |  |
//                           + ROB[NUM_PPS-1]: CL[NUM_CLS-1] Index0 |  |
//                           +--------------------------------------+  |
//                                             ...                     +-> ROB NUM_PPS-1
//                           +--------------------------------------+  |
//                           + ROB[NUM_PPS-1]: CL[0]         Index3 |  |
//                           + ROB[NUM_PPS-1]: CL[0]         Index2 |  |
//                           + ROB[NUM_PPS-1]: CL[0]         Index1 |  |
//                           + ROB[NUM_PPS-1]: CL[0]         Index0 |  |
//                           +--------------------------------------+ /
//                                             ...
//                           +--------------------------------------+ \
//                           + ROB[0]: CL[NUM_CLS-1]         Index3 |  |
//                           + ROB[0]: CL[NUM_CLS-1]         Index2 |  |
//                           + ROB[0]: CL[NUM_CLS-1]         Index1 |  |
//                           + ROB[0]: CL[NUM_CLS-1]         Index0 |  |
//                           +--------------------------------------+  |
//                                             ...                     |
//                           +--------------------------------------+  |
// Addr 7:                   + ROB[0]: CL[1]                 Index3 |  +-> ROB 0
// Addr 6:                   + ROB[0]: CL[1]                 Index2 |  |
// Addr 5:                   + ROB[0]: CL[1]                 Index1 |  |
// Addr 4:                   + ROB[0]: CL[1]                 Index0 |  |
//                           +--------------------------------------+  |
// Addr 3:                   + ROB[0]: CL[0]                 Index3 |  |
// Addr 2:                   + ROB[0]: CL[0]                 Index2 |  |
// Addr 1:                   + ROB[0]: CL[0]                 Index1 |  |
// Addr 0:                   + ROB[0]: CL[0]                 Index0 |  |
//                           +--------------------------------------+ /
//
// Need flops to store next expected CL per PP and CL valid count (3b) per PP*CL.
//
// Need flop to indicate when ROB, as opposed to the input driver, is sourcing the HCW data
// so the input driver can be stalled while ROB reads are active.  Also must hold if there
// is backpressure from downstream.
//
// Need flops to store the current PP and 2b index into the cache line when ROB is sourcing.
//
// Need 2-to-1 156b wide mux to select between input HCW and ROB read data for the output.
//
// One CFG bit input per reordered PP to enable reordering for that PP.  If the bit is not
// set for a PP, the saved state associated with that PP (expected CL & CL valid) can be
// reset, which provides a per reordered PP clear function to recover from errors.
//
// It will be flagged as an error if any writes from a reordered PP target a CL index that is
// already valid in the reorder buffer.
//
//--------------------------------------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_system_rob

     import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_system_csr_pkg::*;
(
     input  logic                       hqm_gated_clk
    ,input  logic                       hqm_gated_rst_n

    ,output logic                       rob_enq_in_ready    // ROB is ready
    ,input  logic                       rob_enq_in_v        // Input HCW is valid
    ,input  hqm_system_enq_data_in_t    rob_enq_in          // Input HCW data

    ,input  logic                       rob_enq_out_ready   // Output is ready
    ,output logic                       rob_enq_out_v       // Output HCW is valid
    ,output hqm_system_enq_data_rob_t   rob_enq_out         // Output HCW data (w/o cl or cli)

    ,input  logic   [NUM_DIR_PP-1:0]    cfg_dir_pp_rob_v    // PP is enabled for reordering
    ,input  logic   [NUM_LDB_PP-1:0]    cfg_ldb_pp_rob_v

    ,output logic                       rob_error           // Error indication
    ,output logic   [7:0]               rob_error_synd      // Error syndrome (ldb, vpp)
    ,output new_ROB_SYNDROME_t          rob_syndrome        // ROB error syndrome (ROB state)

    ,output hqm_system_memi_rob_mem_t   memi_rob_mem        // Single port memory interface
    ,input  hqm_system_memo_rob_mem_t   memo_rob_mem
);

//--------------------------------------------------------------------------------------------------

hqm_system_enq_data_rob_t                   rob_enq_in_wo_clx;          // Same as rob_enq_in w/o cl fields

logic   [HQM_SYSTEM_NUM_ROB_CLS_WIDTH-1:0]  rob_enq_in_cl;              // CL #
logic   [HQM_SYSTEM_NUM_ROB_CLS_WIDTH-1:0]  rob_enq_in_cl_p1;           // CL # + 1

logic   [HQM_SYSTEM_NUM_ROB_PPS_WIDTH-1:0]  rob_enq_in_pp_addr;         // Producer port address
logic   [HQM_SYSTEM_NUM_ROB_PPS_WIDTH-1:0]  rob_enq_in_vpp_scaled;      // Producer port scaled

logic                                       rob_enabled;                // PP enabled for reordering

// Per PP and per CL valid counts
logic   [HQM_SYSTEM_NUM_ROB_CLS-1:0][2:0]   rob_v_cnt_next[HQM_SYSTEM_NUM_ROB_PPS-1:0];
logic   [HQM_SYSTEM_NUM_ROB_CLS-1:0][2:0]   rob_v_cnt_q[HQM_SYSTEM_NUM_ROB_PPS-1:0];

// Per PP next expected CL
logic   [HQM_SYSTEM_NUM_ROB_CLS_WIDTH-1:0]  rob_exp_cl_next[HQM_SYSTEM_NUM_ROB_PPS-1:0];
logic   [HQM_SYSTEM_NUM_ROB_CLS_WIDTH-1:0]  rob_exp_cl_q[HQM_SYSTEM_NUM_ROB_PPS-1:0];
logic   [HQM_SYSTEM_NUM_ROB_CLS_WIDTH-1:0]  rob_exp_cl;
logic   [HQM_SYSTEM_NUM_ROB_CLS_WIDTH-1:0]  rob_exp_cl_p1;              // CL # + 1

logic   [1:0]                               rob_cli_next;               // Saved CL index when ROB sourcing
logic   [1:0]                               rob_cli_q;
logic   [1:0]                               rob_cli_p1;                 // CL index + 1

logic   [HQM_SYSTEM_NUM_ROB_PPS_WIDTH-1:0]  rob_pp_addr_next;           // Saved PP address when ROB sourcing
logic   [HQM_SYSTEM_NUM_ROB_PPS_WIDTH-1:0]  rob_pp_addr_q;

logic                                       rob_sourcing_next;          // ROB sourcing indication
logic                                       rob_sourcing_q;

//--------------------------------------------------------------------------------------------------
// Flops

always_ff @(posedge hqm_gated_clk or negedge hqm_gated_rst_n) begin
 if (~hqm_gated_rst_n) begin
  for (int i=0; i<HQM_SYSTEM_NUM_ROB_PPS; i=i+1) begin
   for (int j=0; j<HQM_SYSTEM_NUM_ROB_CLS; j=j+1) begin
    rob_v_cnt_q[i][j] <= '0;
   end
   rob_exp_cl_q[i]    <= '0;
  end
  rob_cli_q           <= '0;
  rob_pp_addr_q       <= '0;
  rob_sourcing_q      <= '0;
 end else begin
  rob_v_cnt_q         <= rob_v_cnt_next;
  rob_exp_cl_q        <= rob_exp_cl_next;
  rob_cli_q           <= rob_cli_next;
  rob_pp_addr_q       <= rob_pp_addr_next;
  rob_sourcing_q      <= rob_sourcing_next;
 end
end

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_NUM_ROB_PPS_WIDTH), .Z_WIDTH(8)) i_rob_error_synd (

     .a     (rob_enq_in_pp_addr)
    ,.z     (rob_error_synd)
);

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_VPP_WIDTH), .Z_WIDTH(HQM_SYSTEM_NUM_ROB_PPS_WIDTH)) i_rob_enq_in_vpp_scaled (

     .a     (rob_enq_in.vpp)
    ,.z     (rob_enq_in_vpp_scaled)
);

//--------------------------------------------------------------------------------------------------
// Sequential logic

always_comb begin

 //-------------------------------------------------------------------------------------------------
 // Defaults

 // Strip cl_last/cl/cli from input (not needed downstream) and adjust the parity accordingly

 rob_enq_in_wo_clx               = '0;
 rob_enq_in_wo_clx.ecc_h         = rob_enq_in.ecc_h;
 rob_enq_in_wo_clx.ecc_l         = rob_enq_in.ecc_l;
 rob_enq_in_wo_clx.is_nm_pf      = rob_enq_in.is_nm_pf;
 rob_enq_in_wo_clx.is_pf_port    = rob_enq_in.is_pf_port;
 rob_enq_in_wo_clx.is_ldb_port   = rob_enq_in.is_ldb_port;
 rob_enq_in_wo_clx.vpp           = rob_enq_in.vpp;
 rob_enq_in_wo_clx.hcw           = rob_enq_in.hcw;          
 rob_enq_in_wo_clx.port_parity   = ^{rob_enq_in.port_parity, rob_enq_in.cl_last, rob_enq_in.cl, rob_enq_in.cli};

 rob_enq_in_ready       = '1;

 rob_enq_in_cl          = rob_enq_in.cl[HQM_SYSTEM_NUM_ROB_CLS_WIDTH-1:0];
 rob_enq_in_cl_p1       = rob_enq_in_cl + {{(HQM_SYSTEM_NUM_ROB_CLS_WIDTH-1){1'b0}}, 1'b1};

 rob_enq_in_pp_addr     = (rob_enq_in.is_ldb_port) ?
                            (rob_enq_in_vpp_scaled + NUM_DIR_PP[HQM_SYSTEM_NUM_ROB_PPS_WIDTH-1:0]) :
                             rob_enq_in_vpp_scaled;

 rob_v_cnt_next         = rob_v_cnt_q;
 rob_exp_cl_next        = rob_exp_cl_q;
 rob_cli_next           = rob_cli_q;
 rob_pp_addr_next       = rob_pp_addr_q;
 rob_sourcing_next      = rob_sourcing_q;

 rob_exp_cl             = rob_exp_cl_q[rob_pp_addr_q];
 rob_exp_cl_p1          = rob_exp_cl + {{(HQM_SYSTEM_NUM_ROB_CLS_WIDTH-1){1'b0}}, 1'b1};

 rob_cli_p1             = rob_cli_q + 2'd1;

 rob_error              = '0;

 rob_syndrome.PP_IS_LDB = rob_enq_in.is_ldb_port;
 rob_syndrome.PP        = rob_enq_in.vpp;
 rob_syndrome.CL        = rob_enq_in.cl;
 rob_syndrome.CLI       = rob_enq_in.cli;
 rob_syndrome.CL_LAST   = rob_enq_in.cl_last;
 rob_syndrome.ROB_V_CNT = rob_v_cnt_q[rob_enq_in_pp_addr][rob_enq_in_cl];

 rob_enq_out_v          = '0;
 rob_enq_out            = rob_enq_in_wo_clx;    // Don't need cl/cli downstream

 memi_rob_mem           = '0;
 memi_rob_mem.wdata     = rob_enq_in_wo_clx;    // Don't need stored in ROB
 memi_rob_mem.addr      = {rob_enq_in_pp_addr, rob_enq_in_cl, rob_enq_in.cli};

 // Reordering is enabled if the CFG bit for this PP is set and the CL # is < HQM_SYSTEM_NUM_ROB_CLS

 rob_enabled            = ((rob_enq_in.is_ldb_port) ?
                            cfg_ldb_pp_rob_v[rob_enq_in.vpp[HQM_SYSTEM_DIR_PP_WIDTH-1:0]] :
                            cfg_dir_pp_rob_v[rob_enq_in.vpp[HQM_SYSTEM_LDB_PP_WIDTH-1:0]]) &
                           (rob_enq_in.cl < HQM_SYSTEM_NUM_ROB_CLS[3:0]);

 //-------------------------------------------------------------------------------------------------
 // ROB sourcing

 if (rob_sourcing_q) begin // ROB sourcing

  // ROB is sourcing the output HCW, so use ROB read data and backpressure input

  rob_enq_in_ready = '0;

  rob_enq_out_v    = '1;
  rob_enq_out      = memo_rob_mem.rdata;

  if (rob_enq_out_ready) begin // Downstream ready

   // Update state if the HCW is being accepted downstream

   if (rob_v_cnt_q[rob_pp_addr_q][rob_exp_cl] == 3'd1) begin // Last ROB CL index

    // If this was the last valid CL index, set the valid count to 0 and bump the
    // next expected CL pointer, and reset the CL index.

    rob_v_cnt_next[rob_pp_addr_q][rob_exp_cl] = '0;

    rob_exp_cl_next[rob_pp_addr_q] = rob_exp_cl_p1;

    rob_cli_next = '0;

    // Check if the next CL is also already valid in the ROB

    if (~(|rob_v_cnt_q[rob_pp_addr_q][rob_exp_cl_p1])) begin // Done sourcing

     // If this was the last valid CL in the ROB for this PP, reset the sourcing flag.

     rob_sourcing_next = '0;

    end // Done sourcing

    else begin // Next CL also valid

     // Keep sourcing flag set and start reading next HCW in next CL from the ROB.

     memi_rob_mem.re   = '1;
     memi_rob_mem.addr = {rob_pp_addr_q, rob_exp_cl_p1, 2'd0};

    end // Next CL also valid

   end // Last ROB CL index

   else begin // Not last CL index

    // Keep sourcing flag set and read the next HCW in this CL from the ROB.
    // Decrement the valid count and increment the CL index.

    memi_rob_mem.re   = '1;
    memi_rob_mem.addr = {rob_pp_addr_q, rob_exp_cl, rob_cli_p1};

    rob_v_cnt_next[rob_pp_addr_q][rob_exp_cl] = rob_v_cnt_q[rob_pp_addr_q][rob_exp_cl] - 3'd1;

    rob_cli_next = rob_cli_p1;

   end // Not last CL index

  end // Downstream ready

 end // ROB sourcing

 //-------------------------------------------------------------------------------------------------
 // Input valid

 else if (rob_enq_in_v) begin // Input valid

  if (rob_enabled) begin // Reordered PP

   if (rob_enq_in_cl == rob_exp_cl_q[rob_enq_in_pp_addr]) begin // Current CL bypass

    // Input HCW is next expected CL, so bypass to output (default).

    rob_enq_out_v = '1;

    if (~rob_enq_out_ready) begin // Backpressure

     // Downstream not ready, so backpressure input

     rob_enq_in_ready = '0;

    end // Backpressure

    else begin // No backpressure

     // If downstream ready, update state

     if (rob_enq_in.cl_last) begin // Last CL index

      // If last CL index, bump CL pointer

      rob_exp_cl_next[rob_enq_in_pp_addr] = rob_enq_in_cl_p1;

      // If next CL is already in the ROB, set the ROB sourcing flag to hold
      // off the next input so that the ROB read data can be used as the output.
      // Read from the ROB and save the PP address and CL index.

      if (|rob_v_cnt_q[rob_enq_in_pp_addr][rob_enq_in_cl_p1]) begin // Start ROB sourcing

       memi_rob_mem.re   = '1;
       memi_rob_mem.addr = {rob_enq_in_pp_addr, rob_enq_in_cl_p1, 2'd0};

       rob_sourcing_next = '1;
       rob_pp_addr_next  = rob_enq_in_pp_addr;
       rob_cli_next      = '0;

      end // Start ROB sourcing

     end // Last CL index

    end // No backpressure

   end // Current CL bypass

   //-----------------------------------------------------------------------------------------------

   else begin // Write ROB

    // Input HCW is not next expected CL, so write it into ROB and increment valid count.

    // Error if CL data is already marked valid (based on valid count) for current CL index.
    // Valid count must be 0 for cli=0, 1 for cli=1, 2 for cli=2, 3 for cli=3

    if (rob_v_cnt_q[rob_enq_in_pp_addr][rob_enq_in_cl] != {1'b0, rob_enq_in.cli}) begin

     rob_error = '1;        // HCW is also thrown away

    end else begin

     rob_v_cnt_next[rob_enq_in_pp_addr][rob_enq_in_cl] = rob_v_cnt_q[rob_enq_in_pp_addr][rob_enq_in_cl] + 3'd1;

     memi_rob_mem.we   = '1;
     memi_rob_mem.addr = {rob_enq_in_pp_addr, rob_enq_in_cl, rob_enq_in.cli};

    end

   end // Write ROB

  end // Reordered PP

  //------------------------------------------------------------------------------------------------

  else begin // Not a reordered PP

   rob_enq_out_v = '1; // Just bypass input HCW (default)

   // If downstream not ready, backpressure input

   if (~rob_enq_out_ready) begin
     rob_enq_in_ready = '0;
   end

  end

 end // Input valid

 //-------------------------------------------------------------------------------------------------
 // If CFG enable bit is not set for a reordered PP, reset its saved state if already set.
 // Only clocked on clear if currently non-zero.

 for (int i=0; i<NUM_DIR_PP; i=i+1) begin
  if (~cfg_dir_pp_rob_v[i]) begin
   for (int j=0; j<HQM_SYSTEM_NUM_ROB_CLS; j=j+1) begin
    if (|rob_v_cnt_q[i][j]) begin
     rob_v_cnt_next[i][j] = '0;
    end
   end
   if (|rob_exp_cl_q[i]) begin
    rob_exp_cl_next[i] = '0;
   end
  end
 end

 for (int i=0; i<NUM_LDB_PP; i=i+1) begin
  if (~cfg_ldb_pp_rob_v[i]) begin
   for (int j=0; j<HQM_SYSTEM_NUM_ROB_CLS; j=j+1) begin
    if (|rob_v_cnt_q[NUM_DIR_PP+i][j]) begin
     rob_v_cnt_next[NUM_DIR_PP+i][j] = '0;
    end
   end
   if (|rob_exp_cl_q[NUM_DIR_PP+i]) begin
    rob_exp_cl_next[NUM_DIR_PP+i] = '0;
   end
  end
 end

end // always_comb

endmodule // hqm_system_rob

