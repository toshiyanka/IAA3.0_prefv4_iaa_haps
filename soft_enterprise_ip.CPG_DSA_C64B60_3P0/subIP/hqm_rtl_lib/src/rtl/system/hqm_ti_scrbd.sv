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
//----------------------------------------------------------------------------------------------------

module hqm_ti_scrbd

     import hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*, hqm_system_pkg::*,
            hqm_sif_csr_pkg::*, hqm_system_type_pkg::*, hqm_system_func_pkg::*;

(

     input  logic                                   prim_nonflr_clk
    ,input  logic                                   prim_gated_rst_b

    // Configuration

    ,input  logic [7:0]                             current_bus                 // Captured bus number

    ,input  SCRBD_CTL_t                             cfg_scrbd_ctl               // Scoreboard control
    ,input  logic                                   cfg_mstr_par_off            // No parity checking

    ,input  logic [HQM_SCRBD_DEPTH_WIDTH:0]         cfg_ibcpl_hdr_fifo_high_wm
    ,input  logic [HQM_SCRBD_DEPTH_WIDTH:0]         cfg_ibcpl_data_fifo_high_wm

    ,output logic [31:0]                            cfg_ibcpl_hdr_fifo_status   // FIFO status
    ,output logic [31:0]                            cfg_ibcpl_data_fifo_status

    ,output new_SCRBD_STATUS_t                      scrbd_status                // Scoreboard status

    // Scoreboard allocation

    ,output logic                                   scrbd_tag_v                 // Scoreboard tag available
    ,output logic [HQM_SCRBD_DEPTH_WIDTH-1:0]       scrbd_tag                   // Next available scoreboard tag

    ,input  logic                                   scrbd_alloc                 // Allocate a scorboard tag
    ,input  scrbd_data_t                            scrbd_alloc_data            // Scoreboard data to store

    ,output logic                                   scrbd_free                  // Free up an in use scoreboard tag

    // Inbound completion

    ,input  logic                                   ibcpl_hdr_push              // Inbound completion header push
    ,input  tdl_cplhdr_t                            ibcpl_hdr

    ,input  logic                                   ibcpl_data_push             // Inbound completion data push
    ,input  logic [HQM_IBCPL_DATA_WIDTH-1:0]        ibcpl_data
    ,input  logic [HQM_IBCPL_PARITY_WIDTH-1:0]      ibcpl_data_par              // Parity per DW

    // ATS response

    ,output logic                                   ats_rsp_v                   // ATS response valid
    ,output hqm_devtlb_ats_rsp_t                    ats_rsp                     // ATS response

    // CQ NP write response

    ,output logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0] cq_np_cnt_dec               // Dec CQ NP write count

    // Status and Errors

    ,output logic                                   np_trans_pending            // For PCIe Device Status reg

    ,output logic                                   cpl_usr                     // Completion unsupported request
    ,output logic                                   cpl_abort                   // Completer abort error
    ,output logic                                   cpl_poisoned                // Completion poisoned
    ,output logic                                   cpl_unexpected              // Completion unexpected error
    ,output tdl_cplhdr_t                            cpl_error_hdr               // Completion error header

    ,output logic                                   cpl_timeout                 // Completion timeout error
    ,output logic [8:0]                             cpl_timeout_synd            // Completion timeout syndrome

    ,output logic                                   scrbd_perr                  // Parity errors
    ,output logic                                   ibcpl_hdr_fifo_perr
    ,output logic                                   ibcpl_data_fifo_perr

    // Memory interface

    ,output hqm_sif_memi_scrbd_mem_t                memi_scrbd_mem
    ,input  hqm_sif_memo_scrbd_mem_t                memo_scrbd_mem

    ,output hqm_sif_memi_ibcpl_hdr_t                memi_ibcpl_hdr_fifo
    ,input  hqm_sif_memo_ibcpl_hdr_t                memo_ibcpl_hdr_fifo

    ,output hqm_sif_memi_ibcpl_data_t               memi_ibcpl_data_fifo
    ,input  hqm_sif_memo_ibcpl_data_t               memo_ibcpl_data_fifo
);

//----------------------------------------------------------------------------------------------------

logic [HQM_SCRBD_DEPTH-1:0]             scrbd_tag_inuse_next;
logic [HQM_SCRBD_DEPTH-1:0]             scrbd_tag_inuse_q;                  // Scoreboard tag in use vector
logic [HQM_SCRBD_DEPTH-1:0]             scrbd_tag_avail;                    // Scoreboard tag not in use vector
logic                                   scrbd_tag_any;                      // At least 1 scorebard tag available

logic [HQM_SCRBD_CNT_WIDTH-1:0]         scrbd_cnt_next;
logic [HQM_SCRBD_CNT_WIDTH-1:0]         scrbd_cnt_q;                        // # scoreboard tags in use
logic                                   scrbd_cnt_inc;
logic                                   scrbd_cnt_dec;

logic [HQM_SCRBD_DEPTH_WIDTH-1:0]       scrbd_free_tag;                     // Scoreboard tag to free

logic [HQM_SCRBD_DEPTH-1:0]             cpl_timer_v_next;
logic [HQM_SCRBD_DEPTH-1:0]             cpl_timer_v_q;                      // Per tag timeout counter valid
logic [1023:0]                          cpl_timer_v_scaled;                 // Scaled to be indexed by 10b tag
logic                                   cpl_timer_stop;                     // Stop a timeout counter
logic [HQM_SCRBD_DEPTH_WIDTH-1:0]       cpl_timer_stop_tag;                 // Timeout counter to stop
logic [HQM_SCRBD_DEPTH-1:0]             cpl_timer_stop_dec;                 // Per tag decoded version of stop
logic [23:0]                            cpl_timer_next[HQM_SCRBD_DEPTH-1:0];
logic [23:0]                            cpl_timer_q[HQM_SCRBD_DEPTH-1:0];   // Per tag timeout counter

logic [23:0]                            cpl_timeout_value;                  // Timeout value to compare
logic [HQM_SCRBD_DEPTH-1:0]             cpl_timeout_pend_next;
logic [HQM_SCRBD_DEPTH-1:0]             cpl_timeout_pend_q;                 // Vector for pending timeouts
logic                                   cpl_timeout_next;
logic                                   cpl_timeout_q;                      // Completion timeout error
logic [HQM_SCRBD_DEPTH-1:0]             cpl_timeout_pend_clr;               // Clear pending timeouts
logic [8:0]                             cpl_timeout_synd_next;
logic [8:0]                             cpl_timeout_synd_q;                 // Completion timeout syndrome

logic [HQM_SCRBD_DEPTH-1:0]             timeout_arb_reqs;                   // Arbiter for pending timeouts
logic                                   timeout_arb_update;
logic                                   timeout_arb_winner_v;
logic [HQM_SCRBD_DEPTH_WIDTH-1:0]       timeout_arb_winner;
logic                                   timeout_arb_hold;
logic [7:0]                             timeout_arb_tag;

logic                                   ibcpl_drop_data_next;
logic                                   ibcpl_drop_data_q;                  // Drop any ibcpl data (we dropped hdr)
logic                                   ibcpl_usr_next;
logic                                   ibcpl_usr_q;                        // Received a completer abort
logic                                   ibcpl_abort_next;
logic                                   ibcpl_abort_q;                      // Received a completer abort
logic                                   ibcpl_poisoned_next;
logic                                   ibcpl_poisoned_q;                   // Received a poisoned completion
logic                                   ibcpl_unexpected_next;
logic                                   ibcpl_unexpected_q;                 // Received an unexpected completion
tdl_cplhdr_t                            ibcpl_error_hdr_q;                  // Header for inbound errors

logic                                   ibcpl_hdr_fifo_push;                // Inbound completin header FIFO
scrbd_cplhdr_t                          ibcpl_hdr_fifo_push_data;
logic                                   ibcpl_hdr_fifo_pop;
logic                                   ibcpl_hdr_fifo_pop_data_v;
scrbd_cplhdr_t                          ibcpl_hdr_fifo_pop_data;
logic                                   ibcpl_hdr_fifo_full_nc;
logic                                   ibcpl_hdr_fifo_afull_nc;
logic                                   ibcpl_hdr_fifo_perr_next;
logic                                   ibcpl_hdr_fifo_perr_q;

logic                                   ibcpl_data_fifo_push;               // Inbound completion data FIFO
logic [HQM_IBCPL_DATA_FIFO_WIDTH-1:0]   ibcpl_data_fifo_push_data;
logic                                   ibcpl_data_fifo_pop;
logic                                   ibcpl_data_fifo_pop_data_v;
logic [HQM_IBCPL_DATA_FIFO_WIDTH-1:0]   ibcpl_data_fifo_pop_data;
logic                                   ibcpl_data_fifo_full_nc;
logic                                   ibcpl_data_fifo_afull_nc;
logic                                   ibcpl_data_fifo_perr_next;
logic                                   ibcpl_data_fifo_perr_q;

logic                                   scrbd_perr_next;                    // Scoreboard parity error
logic                                   scrbd_perr_q;
logic                                   scrbd_read_v_next;
logic                                   scrbd_read_v_q;                     // Scoreboard read valid
scrbd_cplhdr_t                          scrbd_read_hdr_next;
scrbd_cplhdr_t                          scrbd_read_hdr_q;                   // Scoreboard read header
logic                                   scrbd_read_ur;                      // Completion status is UR
logic                                   scrbd_read_abort;                   // Completion status is abort
logic                                   scrbd_read_timeout;                 // Completion timeout
logic                                   scrbd_read_poisoned;                // Completion poisoned

logic                                   stop_and_scream_next;
logic                                   stop_and_scream_q;

//----------------------------------------------------------------------------------------------------
// Scoreboard management

always_comb begin

 scrbd_tag_inuse_next = scrbd_tag_inuse_q;
 scrbd_cnt_next       = scrbd_cnt_q;

 scrbd_cnt_inc        = '0;
 scrbd_cnt_dec        = '0;

 scrbd_tag_v          = scrbd_tag_any & (scrbd_cnt_q < cfg_scrbd_ctl.SCRBD_LIMIT) & ~stop_and_scream_q;
 scrbd_tag_avail      = ~scrbd_tag_inuse_q;

 memi_scrbd_mem.we    = '0;
 memi_scrbd_mem.waddr = scrbd_tag;
 memi_scrbd_mem.wdata = scrbd_alloc_data;

 if (scrbd_alloc) begin

  // On an allocate, write the scoreboard, set the inuse, and increment the count

  memi_scrbd_mem.we               = '1;
  scrbd_tag_inuse_next[scrbd_tag] = '1;
  scrbd_cnt_inc                   = '1;

 end

 if (scrbd_free) begin

  // On a free, reset the inuse and decrement the count

  scrbd_tag_inuse_next[scrbd_free_tag] = '0;
  scrbd_cnt_dec                        = '1;

 end

 case ({scrbd_cnt_inc, scrbd_cnt_dec})
  2'b10:   scrbd_cnt_next = scrbd_cnt_q + {{(HQM_SCRBD_CNT_WIDTH-1){1'b0}}, 1'b1};
  2'b01:   scrbd_cnt_next = scrbd_cnt_q - {{(HQM_SCRBD_CNT_WIDTH-1){1'b0}}, 1'b1};
  default: scrbd_cnt_next = scrbd_cnt_q;
 endcase

end // always_comb

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  scrbd_tag_inuse_q <= '0;
  scrbd_cnt_q       <= '0;
 end else begin
  scrbd_tag_inuse_q <= scrbd_tag_inuse_next;
  scrbd_cnt_q       <= scrbd_cnt_next;
 end
end

// This is set when there are outstanding NP transactions that haven't provided completions.

assign np_trans_pending = (|scrbd_cnt_q);

//----------------------------------------------------------------------------------------------------
// Completion timeout counters
//
// A timeout needs to push a dummy completion onto the header FIFO so the requestor can ultimately
// get notified of the error.  Since nothing holds up the normal push path from the interface into
// the header FIFO, need to hold onto any timeouts and push them when an open slot to push the FIFO
// is available.

hqm_AW_binenc #(.WIDTH(HQM_SCRBD_DEPTH)) i_scrbd_tag (

     .a         (scrbd_tag_avail)
    ,.enc       (scrbd_tag)
    ,.any       (scrbd_tag_any)
);

hqm_AW_bindec #(.WIDTH(HQM_SCRBD_DEPTH_WIDTH)) i_cpl_timer_stop_dec (

     .a         (cpl_timer_stop_tag)
    ,.enable    (cpl_timer_stop)
    ,.dec       (cpl_timer_stop_dec)
);

always_comb begin

 cpl_timer_v_next      = cpl_timer_v_q;
 cpl_timer_next        = cpl_timer_q;
 cpl_timeout_pend_next = cpl_timeout_pend_q;

 cpl_timeout_value     = (cfg_scrbd_ctl.TIMEOUT8) ? 24'd000008 : 24'hf42400; // 16M cycles

 // Start the timeout timer on a scoreboard allocate

 if (scrbd_alloc) begin // Start timer

  cpl_timer_v_next[scrbd_tag] = '1;

 end // Start timer

 // Each cycle, check for any timeouts and increment any valid timers

 for (int i=0; i<HQM_SCRBD_DEPTH; i=i+1) begin // Each timer

  if (cpl_timer_v_q[i]) begin // Running timer

   if (cpl_timer_stop_dec[i]) begin // Stop timer

    // When stopping a timer, reset the valid and set the timeout counter to 0

    cpl_timer_v_next[i] = '0;
    cpl_timer_next[  i] = '0;

   end // Stop timer

   else if (cpl_timer_q[i] == cpl_timeout_value) begin // Timeout

    // Since all timers compare against the same timeout value and only one timer can be started on
    // any given clock, only one can timeout on any particular clock.
    // Reset the valid and the timer to 0, and set the bit for the tag in the pending timeout vector.
    // Have 2 versions of the timeout indication, one is the pending vector that can have multiple
    // bits accumulate until the dummy completion is pushed onto the cpl header FIFO and the other
    // is a single bit to be passed through the cpl header FIFO to do the error report after the
    // scoreboard info is read and available to be saved as syndrome for the erorr.

    cpl_timer_v_next[i]      = '0;
    cpl_timer_next[i]        = '0;
    cpl_timeout_pend_next[i] = '1;

   end // Timeout

   else begin // Increment timer

    cpl_timer_next[  i] = cpl_timer_q[i] + 24'd1;

   end // Increment timer

  end // Running timer

  if (cpl_timeout_pend_clr[i]) begin // Timeout clear

   cpl_timeout_pend_next[i] = '0;

  end // Timeout clear

 end // Each timer

end // always_comb

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  cpl_timer_v_q      <= '0;
  for (int i=0; i<HQM_SCRBD_DEPTH; i=i+1) begin
   cpl_timer_q[i]    <= '0;
  end
  cpl_timeout_pend_q <= '0;
 end else begin
  cpl_timer_v_q      <= cpl_timer_v_next;
  cpl_timer_q        <= cpl_timer_next;
  cpl_timeout_pend_q <= cpl_timeout_pend_next;
 end
end

// Scale to allow indexing by 10b tag

hqm_AW_width_scale #(.A_WIDTH(HQM_SCRBD_DEPTH), .Z_WIDTH(1024)) i_cpl_timer_v_scaled (

     .a     (cpl_timer_v_q)
    ,.z     (cpl_timer_v_scaled)
);

//----------------------------------------------------------------------------------------------------
// Arbitrate among timed out tags to select a tag to push a dummy completion onto the header FIFO.
// Normal push path has the priority here since it can't be held off.

always_comb begin

 timeout_arb_reqs   = cpl_timeout_pend_q;
 timeout_arb_hold   = ibcpl_hdr_push;
 timeout_arb_update = timeout_arb_winner_v & ~timeout_arb_hold;

end

hqm_AW_rr_arbiter #(.NUM_REQS(HQM_SCRBD_DEPTH)) i_timeout_arb (

     .clk           (prim_nonflr_clk)
    ,.rst_n         (prim_gated_rst_b)

    ,.mode          (2'd2)
    ,.update        (timeout_arb_update)

    ,.reqs          (timeout_arb_reqs)

    ,.winner_v      (timeout_arb_winner_v)
    ,.winner        (timeout_arb_winner)
);

hqm_AW_width_scale #(.A_WIDTH(HQM_SCRBD_DEPTH_WIDTH), .Z_WIDTH(8)) i_timeout_arb_tag (

     .a     (timeout_arb_winner)
    ,.z     (timeout_arb_tag)
);

// Clear the timeout bit for the selected tag

hqm_AW_bindec #(.WIDTH(HQM_SCRBD_DEPTH_WIDTH)) i_cpl_timeout_pend_clr (

     .a         (timeout_arb_winner)
    ,.enable    (timeout_arb_update)
    ,.dec       (cpl_timeout_pend_clr)
);

//----------------------------------------------------------------------------------------------------
// Inbound completions

always_comb begin

 // If the tag from the completion does not currently have a completion timer running, then this is an
 // unexpected completion and the header/data should be dropped before being pushed to the FIFOs.

 ibcpl_hdr_fifo_push             = '0;
 ibcpl_hdr_fifo_push_data        = '0;
 ibcpl_hdr_fifo_push_data.poison = ibcpl_hdr.poison;
 ibcpl_hdr_fifo_push_data.status = ibcpl_hdr.status;
 ibcpl_hdr_fifo_push_data.length = ibcpl_hdr.length[4:0];
 ibcpl_hdr_fifo_push_data.tag    = ibcpl_hdr.tag[7:0];
 ibcpl_hdr_fifo_push_data.parity = ^{ibcpl_hdr.poison
                                    ,ibcpl_hdr.status
                                    ,ibcpl_hdr.length[4:0]
                                    ,ibcpl_hdr.tag[7:0]
                                    };

 ibcpl_data_fifo_push            = '0;
 ibcpl_data_fifo_push_data       = {ibcpl_data_par, ibcpl_data};

 ibcpl_usr_next          = '0;
 ibcpl_abort_next        = '0;
 ibcpl_poisoned_next     = '0;
 ibcpl_unexpected_next   = '0;

 ibcpl_drop_data_next    = ibcpl_drop_data_q;

 cpl_timer_stop          = '0;
 cpl_timer_stop_tag      = ibcpl_hdr.tag[HQM_SCRBD_DEPTH_WIDTH-1:0];

 // Header pushes

 if (ibcpl_hdr_push) begin // Normal hdr push

  if ((ibcpl_hdr.rid == {current_bus,8'd0}) &   // Requestor ID matches our PF {bus[7:0], 8'd0}
      (cpl_timer_v_scaled[ibcpl_hdr.tag]))      // A timer is currently running for this tag
  begin // Timer valid

   // This is an expected completion (device and tag match scoreboard entry w/ a running timer).
   // Push expected completion header onto the header FIFO and stop the timer.

   ibcpl_hdr_fifo_push   = '1;
   ibcpl_drop_data_next  = '0;
   cpl_timer_stop        = '1;

   // Only expecting ATS completions which have a data payload of 64b (2DW).
   // So if length is anything other than 0 or 2, we need to flag it.
   // We can treat it as an unexpected completion for error reporting based on the spec, but we still
   // need to pass the header so that the requestor gets notified of the error.
   // So set the bad length indication and throw away any associated data pushes (since the length may
   // be greater than the 8DW cpl data FIFO storage allocated, we need to protect it from overflowing).
   // Need to adjust the hdr parity to account for the setting of bad_len.

   if ((ibcpl_hdr.length != 10'd0) & (ibcpl_hdr.length != 10'd2)) begin // Unexpected length

    ibcpl_hdr_fifo_push_data.bad_len = '1;
    ibcpl_hdr_fifo_push_data.parity  = ~ibcpl_hdr_fifo_push_data.parity;

    ibcpl_unexpected_next = '1;
    ibcpl_drop_data_next  = '1;

   end // Unexpected length

   else begin // Status Checks

    // Report these errors from this level (even though they need to go through the hdr FIFO so
    // the requestor gets notified) so they can use the same error hdr as the unexpected Cpl.

    if (ibcpl_hdr.status == 3'd4) begin // Completer Abort Error (Cpl)

     ibcpl_abort_next = '1;

    end // Completer Abort Error

    else if (ibcpl_hdr.status != 3'd0) begin // Completion UR Error (Cpl)

     ibcpl_usr_next   = '1;

    end // Completion UR Error

    else begin // CplD

     // Set the poison error indication if the data was poisoned

     ibcpl_poisoned_next = ibcpl_hdr.poison;

    end // CplD

   end // Status Checks

   // TBD: Any other header field checks we need to do here?

  end // Timer valid

  else begin // Unexpected completion

   // Throw away the header by not pushing it to the FIFO and drop any associated data pushes

   ibcpl_unexpected_next = '1;
   ibcpl_drop_data_next  = '1;

  end // Unexpected completion

 end // Normal header push

 else if (timeout_arb_winner_v) begin // Timeout header push

  ibcpl_hdr_fifo_push              = '1;                        // Push a dummy header
  ibcpl_hdr_fifo_push_data         = '0;
  ibcpl_hdr_fifo_push_data.timeout = '1;                        // Set timeout indication
  ibcpl_hdr_fifo_push_data.tag     = timeout_arb_tag;           // Tag
  ibcpl_hdr_fifo_push_data.parity  = ^{timeout_arb_tag, 1'b1};

 end // Timeout header push

 // Data pushes

 if (ibcpl_data_push & ~ibcpl_drop_data_q) begin

  ibcpl_data_fifo_push = '1;

 end

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  ibcpl_drop_data_q  <= '0;
  ibcpl_usr_q        <= '0;
  ibcpl_abort_q      <= '0;
  ibcpl_poisoned_q   <= '0;
  ibcpl_unexpected_q <= '0;
 end else begin
  ibcpl_drop_data_q  <= ibcpl_drop_data_next;
  ibcpl_usr_q        <= ibcpl_usr_next;
  ibcpl_abort_q      <= ibcpl_abort_next;
  ibcpl_poisoned_q   <= ibcpl_poisoned_next;
  ibcpl_unexpected_q <= ibcpl_unexpected_next;
 end
end

always_ff @(posedge prim_nonflr_clk) begin
 if (|{ibcpl_usr_next, ibcpl_abort_next, ibcpl_poisoned_next, ibcpl_unexpected_next}) begin
  ibcpl_error_hdr_q <= ibcpl_hdr;
 end
end

// Error reports and error header

assign cpl_usr        = ibcpl_usr_q;
assign cpl_abort      = ibcpl_abort_q;
assign cpl_poisoned   = ibcpl_poisoned_q;
assign cpl_unexpected = ibcpl_unexpected_q;
assign cpl_error_hdr  = ibcpl_error_hdr_q;

//----------------------------------------------------------------------------------------------------
// Header and Data FIFOs

hqm_AW_fifo_control_big_wreg #(

     .DEPTH                 (HQM_SCRBD_DEPTH)
    ,.DWIDTH                ($bits(scrbd_cplhdr_t))
    ,.MEMRE_POWER_OPT       (0)

) i_ibcpl_hdr_fifo (

     .clk                   (prim_nonflr_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           (cfg_ibcpl_hdr_fifo_high_wm)

    ,.push                  (ibcpl_hdr_fifo_push)
    ,.push_data             (ibcpl_hdr_fifo_push_data)
    ,.pop                   (ibcpl_hdr_fifo_pop)
    ,.pop_data_v            (ibcpl_hdr_fifo_pop_data_v)
    ,.pop_data              (ibcpl_hdr_fifo_pop_data)

    ,.mem_we                (memi_ibcpl_hdr_fifo.we)
    ,.mem_waddr             (memi_ibcpl_hdr_fifo.waddr)
    ,.mem_wdata             (memi_ibcpl_hdr_fifo.wdata)
    ,.mem_re                (memi_ibcpl_hdr_fifo.re)
    ,.mem_raddr             (memi_ibcpl_hdr_fifo.raddr)
    ,.mem_rdata             (memo_ibcpl_hdr_fifo.rdata)

    ,.fifo_status           (cfg_ibcpl_hdr_fifo_status)
    ,.fifo_full             (ibcpl_hdr_fifo_full_nc)
    ,.fifo_afull            (ibcpl_hdr_fifo_afull_nc)
);

hqm_AW_fifo_control_big_wreg #(

     .DEPTH                 (HQM_SCRBD_DEPTH)
    ,.DWIDTH                (HQM_IBCPL_DATA_FIFO_WIDTH)
    ,.MEMRE_POWER_OPT       (0)

) i_ibcpl_data_fifo (

     .clk                   (prim_nonflr_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           (cfg_ibcpl_data_fifo_high_wm)

    ,.push                  (ibcpl_data_fifo_push)
    ,.push_data             (ibcpl_data_fifo_push_data)
    ,.pop                   (ibcpl_data_fifo_pop)
    ,.pop_data_v            (ibcpl_data_fifo_pop_data_v)
    ,.pop_data              (ibcpl_data_fifo_pop_data)

    ,.mem_we                (memi_ibcpl_data_fifo.we)
    ,.mem_waddr             (memi_ibcpl_data_fifo.waddr)
    ,.mem_wdata             (memi_ibcpl_data_fifo.wdata)
    ,.mem_re                (memi_ibcpl_data_fifo.re)
    ,.mem_raddr             (memi_ibcpl_data_fifo.raddr)
    ,.mem_rdata             (memo_ibcpl_data_fifo.rdata)

    ,.fifo_status           (cfg_ibcpl_data_fifo_status)
    ,.fifo_full             (ibcpl_data_fifo_full_nc)
    ,.fifo_afull            (ibcpl_data_fifo_afull_nc)
);

hqm_AW_unused_bits i_unused (

     .a     (|{  ibcpl_hdr_fifo_full_nc
                ,ibcpl_hdr_fifo_afull_nc
                ,ibcpl_data_fifo_full_nc
                ,ibcpl_data_fifo_afull_nc
            })
);

//----------------------------------------------------------------------------------------------------
// Process completion at the output of the FIFOs

always_comb begin

 ibcpl_hdr_fifo_pop    = '0;
 ibcpl_data_fifo_pop   = '0;

 memi_scrbd_mem.re     = '0;
 memi_scrbd_mem.raddr  = ibcpl_hdr_fifo_pop_data.tag[HQM_SCRBD_DEPTH_WIDTH-1:0];

 scrbd_read_v_next     = '0;
 scrbd_read_hdr_next   = ibcpl_hdr_fifo_pop_data;

 scrbd_read_ur         = '0;
 scrbd_read_abort      = '0;
 scrbd_read_timeout    = '0;
 scrbd_read_poisoned   = '0;

 scrbd_free            = '0;
 scrbd_free_tag        = scrbd_read_hdr_q.tag[HQM_SCRBD_DEPTH_WIDTH-1:0];

 cq_np_cnt_dec         = '0;

 ats_rsp_v             = '0;
 ats_rsp               = '0;
 ats_rsp.id            = memo_scrbd_mem.rdata.id[5:0];
 ats_rsp.data          = ibcpl_data_fifo_pop_data[63:0];

 //---------------------------------------------------------------------------------------------------
 // A scoreboard or header parity failure is fatal, so need to report and freeze.

 scrbd_perr_next           = ~stop_and_scream_q & ~cfg_mstr_par_off & scrbd_read_v_q &
                                (^memo_scrbd_mem.rdata);

 ibcpl_hdr_fifo_perr_next  = ~stop_and_scream_q & ~cfg_mstr_par_off & ibcpl_hdr_fifo_pop_data_v &
                                (^ibcpl_hdr_fifo_pop_data);

 ibcpl_data_fifo_perr_next = '0;    // Check only on data FIFO pop

 // This is persistent and requires a reset of the IP

 stop_and_scream_next      =  stop_and_scream_q | scrbd_perr_next | ibcpl_hdr_fifo_perr_next;

 //---------------------------------------------------------------------------------------------------
 // If the cpl_hdr FIFO isn't empty, read the scoreboard data for the entry at the head of the FIFO,
 // pop the header and pipe it forward to combine with the scoreboard data available next clock.
 // Don't do any of this if a header parity error is detected, effectively freezing the pipeline.

 if (ibcpl_hdr_fifo_pop_data_v & ~(ibcpl_hdr_fifo_perr_next | stop_and_scream_q)) begin // Read scoreboard

  ibcpl_hdr_fifo_pop = '1;

  memi_scrbd_mem.re  = '1;

  scrbd_read_v_next  = '1;

 end // Read scoreboard

 //---------------------------------------------------------------------------------------------------
 // Scoreboard data available.  Freeze if we have a scoreboard data parity error

 if (scrbd_read_v_q & ~(scrbd_perr_next | stop_and_scream_q)) begin // Scoreboad read valid

  if (scrbd_read_hdr_q.timeout) begin // Completion Timeout Error

   // If timeout is set, this is a dummy header, generate the error report and syndrome,
   // but still forward a response to the requestor.

   scrbd_read_timeout = '1;

   // Syndrome is the scoreboard read data

  end // Completion Timeout Error

  //--------------------------------------------------------------------------------------------------

  else if (~scrbd_read_hdr_q.bad_len & (scrbd_read_hdr_q.status == 3'd4)) begin // Completer Abort Error (Cpl)

   // This error was already reported when the header was pushed

   scrbd_read_abort   = '1;

  end // Completer Abort Error

  //--------------------------------------------------------------------------------------------------

  else if (~scrbd_read_hdr_q.bad_len & (scrbd_read_hdr_q.status != 3'd0)) begin // Completion UR Error (Cpl)

   // This error was already reported when the header was pushed

   scrbd_read_ur      = '1;

  end // Completer UR Error

  //--------------------------------------------------------------------------------------------------

  else begin // Successful Completion (CplD)

   if (~scrbd_read_hdr_q.bad_len) begin // Data valid

    // Pop the data FIFO and check the data parity only if the bad_len indication is not set

    ibcpl_data_fifo_pop = '1;

    for (int i=0; i<HQM_IBCPL_PARITY_WIDTH; i=i+1) begin
     if (^{ibcpl_data_fifo_pop_data[HQM_IBCPL_DATA_WIDTH+i], ibcpl_data_fifo_pop_data[(32*i) +: 32]}) begin
      ibcpl_data_fifo_perr_next = ~cfg_mstr_par_off;
     end
    end

    // Set the poison error indication if the data was poisoned

    scrbd_read_poisoned = scrbd_read_hdr_q.poison;

   end // Data valid

  end // Successful Completion

  //--------------------------------------------------------------------------------------------------
  // Route completion back to the requestor (currently just devtlb ATS responses)

  if (memo_scrbd_mem.rdata.src == 2'd0) begin // CQ NP write response

   // Completion for CQ NP write.  Decrement the associated CQ NP write counter.

   cq_np_cnt_dec[memo_scrbd_mem.rdata.id[HQM_MSTR_NUM_CQS_WIDTH-1:0]] = '1;

  end // CQ NP write response

  else if (memo_scrbd_mem.rdata.src == 2'd1) begin // Send atsrsp

   // Send back the ATS response to the devtlb
   // Set the dperror if the poison bit was set or the data FIFO output has a parity error.
   // Set the hdrerror if this was a timeout, bad length, a completer abort, or an unsupported request.

   ats_rsp_v        = '1;
   ats_rsp.dperror  = scrbd_read_poisoned | ibcpl_data_fifo_perr_next;
   ats_rsp.hdrerror = scrbd_read_timeout | scrbd_read_hdr_q.bad_len | scrbd_read_abort | scrbd_read_ur;

   // Zero out the data if any header type error, otherwise default is just to send the popped data

   if (scrbd_read_timeout | scrbd_read_hdr_q.bad_len | scrbd_read_abort | scrbd_read_ur) begin

    ats_rsp.data = '0;

   end

  end // Send atsrsp

  //--------------------------------------------------------------------------------------------------
  // Free up the scoreboard tag since we are now done with it

  scrbd_free = '1;

 end // Scoreboard read valid

 cpl_timeout_next      = scrbd_read_timeout;
 cpl_timeout_synd_next = {memo_scrbd_mem.rdata.src, memo_scrbd_mem.rdata.id};

end // always_comb

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  cpl_timeout_q          <= '0;
  scrbd_read_v_q         <= '0;
  scrbd_perr_q           <= '0;
  ibcpl_hdr_fifo_perr_q  <= '0;
  ibcpl_data_fifo_perr_q <= '0;
  stop_and_scream_q      <= '0;
 end else begin
  cpl_timeout_q          <= cpl_timeout_next;
  scrbd_read_v_q         <= scrbd_read_v_next;
  scrbd_perr_q           <= scrbd_perr_next;
  ibcpl_hdr_fifo_perr_q  <= ibcpl_hdr_fifo_perr_next;
  ibcpl_data_fifo_perr_q <= ibcpl_data_fifo_perr_next;
  stop_and_scream_q      <= stop_and_scream_next;
 end
end

always_ff @(posedge prim_nonflr_clk) begin
 if (scrbd_read_v_next) begin
  scrbd_read_hdr_q <= scrbd_read_hdr_next;
 end
 if (cpl_timeout_next) begin
  cpl_timeout_synd_q <= cpl_timeout_synd_next;
 end
end

always_comb begin

 // Send out timout error report and syndrome

 cpl_timeout          = cpl_timeout_q;
 cpl_timeout_synd     = cpl_timeout_synd_q;

 // Send out parity errors

 scrbd_perr           = scrbd_perr_q;
 ibcpl_hdr_fifo_perr  = ibcpl_hdr_fifo_perr_q;
 ibcpl_data_fifo_perr = ibcpl_data_fifo_perr_q;

end

//----------------------------------------------------------------------------------------------------
// Status

always_comb begin

 scrbd_status.STOPNSCREAM = stop_and_scream_q;
 scrbd_status.TIM_INUSE   = (|cpl_timer_v_q);
 scrbd_status.TO_PEND     = (|cpl_timeout_pend_q);
 scrbd_status.SCRBD_CNT   = scrbd_cnt_q;

end

//----------------------------------------------------------------------------------------------------

// TBD: Need CFG read access to the scoreboard inuse and memory to allow robust debug

endmodule // hqm_ti_scrbd
