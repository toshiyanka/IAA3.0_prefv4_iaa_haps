//-----------------------------------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------------------------------
// AW_fifo_ctl_dc
//
// This is a parametized FIFO controller for a DEPTH deep by DWIDTH wide FIFO memory with separate read
// and write clocks.
//
// The following parameters are supported:
//
//      DEPTH           Depth of the FIFO.
//      DWIDTH          Width of the FIFO datapath.
//      NUM_STAGES_PUSH Number of synchronizer stages used for clk_push.
//      NUM_STAGES_POP  Number of synchronizer stages used for clk_pop.
//
//      SYNC_POP        Controls what clock is used to sync the fifo_status bits.
//                      This should be set to 0 if clk_push is used as the configuration clock that is
//                      capturing the fifo_status information, and set to 1 if clk_pop is used.
//
//                      The fifo_status output is defined as:
//
//                              [DEPTHWIDTH+7:8]:       FIFO depth
//                              [7]:                    FIFO full         (FIFO depth == DEPTH)
//                              [6]:                    FIFO almost full  (FIFO depth >= high watermark)
//                              [5]:                    FIFO almost empty (FIFO depth <= low  watermark)
//                              [4]:                    FIFO empty        (FIFO depth == 0)
//                              [1]:                    FIFO overflow     (push while FIFO full)
//                              [0]:                    FIFO underflow    (pop  while FIFO empty)
//
// It is recommended that the entire set of fifo_status information be accessible through the
// configuration interface as read-only status.  It is required that at least the full, empty,
// overflow, and underflow bits be made available.  The overflow and underflow bits from all
// FIFO controllers must also be "OR"ed together into a single fifo_error sticky interrupt
// status bit to indicate that any FIFO error occurred.
//
//-----------------------------------------------------------------------------------------------------
//
// Push and pop are the basic FIFO operations.
// The memory interface is designed to interface to a dual clock 2-port memory, be it a register
// file (1 write port and 1 read port) or a full 2-port SRAM (2 R/W ports).
// The FIFO data is valid whenever the fifo_pop_empty signal is not asserted.
// Simultaneous push and pop are not supported on an empty or a full FIFO.
// The current FIFO depth as well as the full or empty status are provided as outputs.
// High and low watermark inputs are provided and the corresponding fifo_push_afull and
// fifo_pop_aempty outputs are set whenever fifo_push_depth >= high or fifo_pop_depth <= low.
// Push while full and pop while empty conditions are flagged by the fifo_overflow and
// fifo_underflow flags that are part of the fifo_status field (bits 1..0).
// A System Verilog checker is instantiated with the ASSERT_ON define to provide automatic
// simulation checking if assertions are enabled.
//
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//
// push operation timing
//                            _____       _____       __
// clk_push             _____|     |_____|     |_____|
//                               ___________
// push                 ________|           |___________
//                               ___________
// push_data            --------X___________X-----------
//                      _________________ ______________
// fifo_push_depth      _________________X______________
//                                        ______________
// fifo_push_full       _________________|
// fifo_push_afull
//
//--------------------------------------------------------------------------------------------
//
// pop operation timing
//                            _____       _____       __
// clk_pop              _____|     |_____|     |_____|
//                               ___________
// pop                  ________|           |______________
//                      _________________ _________________
// fifo_data            ___valid_data____X___next_data_____
//                      _________________ ______________
// fifo_pop_depth       _________________X______________
//                      _________________
// fifo_pop_empty                        |_________________
// fifo_pop_aempty
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_fifo_control_dc

        import hqm_AW_pkg::*;
#(
     parameter DEPTH                = 2
    ,parameter DWIDTH               = 2
    ,parameter SYNC_POP             = 0     // Status synced to clk_push

    ,parameter AWIDTH               = AW_logb2(DEPTH-1)+1
    ,parameter DEPTHWIDTH           = (((2**AWIDTH)==DEPTH) ? (AWIDTH+1) : AWIDTH)
) (
     input  logic                   clk_push
    ,input  logic                   rst_push_n

    ,input  logic                   clk_pop
    ,input  logic                   rst_pop_n

    ,input  logic [DEPTHWIDTH-1:0]  cfg_high_wm
    ,input  logic [DEPTHWIDTH-1:0]  cfg_low_wm

    ,input  logic                   fifo_enable

    ,input  logic                   clear_pop_state

    ,input  logic                   push
    ,input  logic [DWIDTH-1:0]      push_data

    ,input  logic                   pop
    ,output logic [DWIDTH-1:0]      pop_data

    ,output logic                   mem_we
    ,output logic [AWIDTH-1:0]      mem_waddr
    ,output logic [DWIDTH-1:0]      mem_wdata
    ,output logic                   mem_re
    ,output logic [AWIDTH-1:0]      mem_raddr
    ,input  logic [DWIDTH-1:0]      mem_rdata

    ,output logic [DEPTHWIDTH-1:0]  fifo_push_depth
    ,output logic                   fifo_push_full
    ,output logic                   fifo_push_afull
    ,output logic                   fifo_push_empty
    ,output logic                   fifo_push_aempty

    ,output logic [DEPTHWIDTH-1:0]  fifo_pop_depth
    ,output logic                   fifo_pop_aempty
    ,output logic                   fifo_pop_empty

    ,output logic [31:0]            fifo_status
);

//--------------------------------------------------------------------------------------------
logic                           fifo_push;              // clk_push

logic   [AWIDTH-1:0]            fifo_wadd_f;            // clk_push
logic   [AWIDTH-1:0]            fifo_wadd_p1;           // clk_push
logic   [AWIDTH-1:0]            fifo_wadd_next;         // clk_push
logic   [AWIDTH:0]              fifo_wptr_f;            // clk_push
logic   [AWIDTH:0]              fifo_wptr_p1;           // clk_push
logic   [AWIDTH:0]              fifo_wptr_next;         // clk_push
logic   [AWIDTH:0]              fifo_wptr_gray_f;       // clk_push
logic   [AWIDTH:0]              fifo_wptr_gray_next;    // clk_push
logic   [AWIDTH:0]              fifo_wptr_gray_sync_f;  // clk_pop
logic   [AWIDTH:0]              fifo_wptr_sync;         // clk_pop

logic   [DEPTHWIDTH-1:0]        fifo_push_depth_f;      // clk_push
logic   [DEPTHWIDTH-1:0]        fifo_push_depth_next;   // clk_push
logic                           fifo_push_full_f;       // clk_push
logic                           fifo_push_full_next;    // clk_push
logic                           fifo_push_afull_f;      // clk_push
logic                           fifo_push_afull_next;   // clk_push
logic                           fifo_push_empty_f;      // clk_push
logic                           fifo_push_empty_next;   // clk_push
logic                           fifo_push_aempty_f;     // clk_push
logic                           fifo_push_aempty_next;  // clk_push
logic                           fifo_overflow_f;        // clk_push
logic                           fifo_overflow_next;     // clk_push

logic                           fifo_pop;               // clk_pop

logic   [AWIDTH-1:0]            fifo_radd_f;            // clk_pop
logic   [AWIDTH-1:0]            fifo_radd_p1;           // clk_pop
logic   [AWIDTH-1:0]            fifo_radd_next;         // clk_pop
logic   [AWIDTH:0]              fifo_rptr_f;            // clk_pop
logic   [AWIDTH:0]              fifo_rptr_p1;           // clk_pop
logic   [AWIDTH:0]              fifo_rptr_next;         // clk_pop
logic   [AWIDTH:0]              fifo_rptr_gray_f;       // clk_pop
logic   [AWIDTH:0]              fifo_rptr_gray_next;    // clk_pop
logic   [AWIDTH:0]              fifo_rptr_gray_sync_f;  // clk_push
logic   [AWIDTH:0]              fifo_rptr_sync;         // clk_push

logic   [DEPTHWIDTH-1:0]        fifo_pop_depth_f;       // clk_pop
logic   [DEPTHWIDTH-1:0]        fifo_pop_depth_next;    // clk_pop
logic                           fifo_pop_aempty_f;      // clk_pop
logic                           fifo_pop_aempty_next;   // clk_pop
logic                           fifo_pop_empty_f;       // clk_pop
logic                           fifo_pop_empty_next;    // clk_pop
logic                           fifo_underflow_f;       // clk_pop
logic                           fifo_underflow_next;    // clk_pop

logic                           mem_re_int;
logic                           mem_re_f;
logic                           mem_rdata_v_next;
logic                           mem_rdata_v_f;
logic   [DWIDTH-1:0]            mem_rdata_f;
logic   [DWIDTH-1:0]            mem_rdata_next;

//--------------------------------------------------------------------------------------------
// Logic on clk_push

assign fifo_push      = push & ~fifo_push_full_f;

assign fifo_wadd_p1   = ({{(32-AWIDTH){1'b0}},fifo_wadd_f} == (DEPTH-1)) ? {AWIDTH{1'b0}} : (fifo_wadd_f + { {(AWIDTH-1){1'b0}} , 1'b1 } );
assign fifo_wadd_next = (fifo_push) ? fifo_wadd_p1 : fifo_wadd_f;

assign fifo_wptr_p1   = fifo_wptr_f + { {(AWIDTH){1'b0}} , 1'b1 } ;
assign fifo_wptr_next = (fifo_push) ? fifo_wptr_p1 : fifo_wptr_f;

hqm_AW_bin2gray #(.WIDTH(AWIDTH+1)) i_fifo_wptr_gray_next (
        .binary (fifo_wptr_next),
        .gray   (fifo_wptr_gray_next)
);

hqm_AW_gray2bin #(.WIDTH(AWIDTH+1)) i_fifo_rptr_sync (
        .gray   (fifo_rptr_gray_sync_f),
        .binary (fifo_rptr_sync)
);

assign fifo_push_depth_next  = fifo_wptr_next - fifo_rptr_sync;
assign fifo_push_afull_next  = (fifo_push_depth_next >= cfg_high_wm);
assign fifo_push_empty_next  = ~(push | (|fifo_push_depth_next));
assign fifo_push_aempty_next = (fifo_push_depth_next <= cfg_low_wm);
assign fifo_push_full_next   = ({{(32-DEPTHWIDTH){1'b0}},fifo_push_depth_next} == DEPTH);
assign fifo_overflow_next    = fifo_overflow_f | (push & fifo_push_full_f);

//--------------------------------------------------------------------------------------------
// Flops on clk_push

always_ff @(posedge clk_push or negedge rst_push_n) begin: L000
 if (~rst_push_n) begin
  fifo_wadd_f        <= {AWIDTH{1'b0}};
  fifo_wptr_f        <= {(AWIDTH+1){1'b0}};
  fifo_wptr_gray_f   <= {(AWIDTH+1){1'b0}};
  fifo_push_depth_f  <= {DEPTHWIDTH{1'b0}};
  fifo_push_full_f   <= 1'b0;
  fifo_push_afull_f  <= 1'b0;
  fifo_push_empty_f  <= 1'b1;
  fifo_push_aempty_f <= 1'b1;
  fifo_overflow_f    <= 1'b0;
 end else begin
  fifo_wadd_f        <= fifo_wadd_next;
  fifo_wptr_f        <= fifo_wptr_next;
  fifo_wptr_gray_f   <= fifo_wptr_gray_next;
  fifo_push_depth_f  <= fifo_push_depth_next;
  fifo_push_full_f   <= fifo_push_full_next;
  fifo_push_afull_f  <= fifo_push_afull_next;
  fifo_push_empty_f  <= fifo_push_empty_next;
  fifo_push_aempty_f <= fifo_push_aempty_next;
  fifo_overflow_f    <= fifo_overflow_next;
 end
end

hqm_AW_sync_rst0 #(.WIDTH(AWIDTH+1)) i_fifo_rptr_gray_sync (
        .clk            (clk_push),
        .rst_n          (rst_push_n),
        .data           (fifo_rptr_gray_f),
        .data_sync      (fifo_rptr_gray_sync_f)
);

//--------------------------------------------------------------------------------------------
// Logic on clk_pop

assign fifo_pop       = pop & fifo_enable & ~fifo_pop_empty_f;

assign fifo_radd_p1   = ({{(32-AWIDTH){1'b0}},fifo_radd_f} == (DEPTH-1)) ? {AWIDTH{1'b0}} : (fifo_radd_f + { {(AWIDTH-1){1'b0}} , 1'b1 } );
assign fifo_radd_next = (fifo_pop) ? fifo_radd_p1 : fifo_radd_f;

assign fifo_rptr_p1   = fifo_rptr_f + { {(AWIDTH){1'b0}} , 1'b1 } ;
assign fifo_rptr_next = (fifo_pop) ? fifo_rptr_p1 : fifo_rptr_f;

hqm_AW_bin2gray #(.WIDTH(AWIDTH+1)) i_fifo_rptr_gray_next (
        .binary (fifo_rptr_next),
        .gray   (fifo_rptr_gray_next)
);

hqm_AW_gray2bin #(.WIDTH(AWIDTH+1)) i_fifo_wptr_sync (
        .gray   (fifo_wptr_gray_sync_f),
        .binary (fifo_wptr_sync)
);

assign fifo_pop_depth_next  = fifo_wptr_sync - fifo_rptr_next;
assign fifo_pop_aempty_next = (fifo_pop_depth_next <= cfg_low_wm);
assign fifo_pop_empty_next  = (fifo_pop_depth_next == {DEPTHWIDTH{1'b0}});
assign fifo_underflow_next  = fifo_underflow_f | (pop & fifo_pop_empty_f);

assign mem_rdata_v_next = (mem_rdata_v_f) ? ~fifo_pop : (mem_re_f & ~fifo_pop);

//--------------------------------------------------------------------------------------------
// Flops on clk_pop

always_ff @(posedge clk_pop or negedge rst_pop_n) begin: L001
 if (~rst_pop_n) begin
  fifo_radd_f       <= {AWIDTH{1'b0}};
  fifo_rptr_f       <= {(AWIDTH+1){1'b0}};
  fifo_rptr_gray_f  <= {(AWIDTH+1){1'b0}};
  fifo_pop_depth_f  <= {DEPTHWIDTH{1'b0}};
  fifo_pop_aempty_f <= 1'b1;
  fifo_pop_empty_f  <= 1'b1;
  fifo_underflow_f  <= 1'b0;
  mem_re_f          <= 1'b0;
  mem_rdata_v_f     <= 1'b0;
 end else if (clear_pop_state) begin
  fifo_radd_f       <= {AWIDTH{1'b0}};
  fifo_rptr_f       <= {(AWIDTH+1){1'b0}};
  fifo_rptr_gray_f  <= {(AWIDTH+1){1'b0}};
  fifo_pop_depth_f  <= {DEPTHWIDTH{1'b0}};
  fifo_pop_aempty_f <= 1'b1;
  fifo_pop_empty_f  <= 1'b1;
  fifo_underflow_f  <= 1'b0;
  mem_re_f          <= 1'b0;
  mem_rdata_v_f     <= 1'b0;
 end else if (fifo_enable) begin
  fifo_radd_f       <= fifo_radd_next;
  fifo_rptr_f       <= fifo_rptr_next;
  fifo_rptr_gray_f  <= fifo_rptr_gray_next;
  fifo_pop_depth_f  <= fifo_pop_depth_next;
  fifo_pop_aempty_f <= fifo_pop_aempty_next;
  fifo_pop_empty_f  <= fifo_pop_empty_next;
  fifo_underflow_f  <= fifo_underflow_next;
  mem_re_f          <= mem_re_int;
  mem_rdata_v_f     <= mem_rdata_v_next;
 end
end

assign mem_rdata_next = (~mem_rdata_v_f & mem_rdata_v_next) ? mem_rdata : mem_rdata_f ;

always_ff @(posedge clk_pop) begin: L002
 if (fifo_enable) mem_rdata_f <= mem_rdata_next ;
end

hqm_AW_sync_rst0 #(.WIDTH(AWIDTH+1)) i_fifo_wptr_gray_sync (
        .clk            (clk_pop),
        .rst_n          (rst_pop_n),
        .data           (fifo_wptr_gray_f),
        .data_sync      (fifo_wptr_gray_sync_f)
);

//--------------------------------------------------------------------------------------------
// Interface to the actual memory
//--------------------------------------------------------------------------------------------

assign mem_we     = fifo_push;
assign mem_waddr  = fifo_wadd_f;
assign mem_wdata  = push_data;

assign mem_re_int = (fifo_pop & (|{1'b0, fifo_pop_depth_next[DEPTHWIDTH-1:0]})) |
                        (fifo_pop_empty_f & ~fifo_pop_empty_next);
assign mem_re     = mem_re_int;
assign mem_raddr  = fifo_radd_next;

//--------------------------------------------------------------------------------------------
// Drive the outputs
//--------------------------------------------------------------------------------------------
assign pop_data = (mem_rdata_v_f) ? mem_rdata_f : mem_rdata;

assign fifo_push_depth  = fifo_push_depth_f;
assign fifo_push_full   = fifo_push_full_f;
assign fifo_push_afull  = fifo_push_afull_f;
assign fifo_push_empty  = fifo_push_empty_f;
assign fifo_push_aempty = fifo_push_aempty_f;

assign fifo_pop_depth   = fifo_pop_depth_f  & {DEPTHWIDTH{fifo_enable}};
assign fifo_pop_aempty  = fifo_pop_aempty_f | ~fifo_enable;
assign fifo_pop_empty   = fifo_pop_empty_f  | ~fifo_enable;

// The full, afull and overflow indications are on clk_push.  For config access to these
// we need them synced to clk_pop if the config access is on clk_pop.
// The empty, aempty and underflow indications are on clk_pop.  For config access to these
// we need them synced to clk_push if the config access is on clk_push.
// In either case, we need to ensure that the error pulse (overflow or underflow) on the other
// clock domain is correctly seen across the clock crossing.
// The fifo_status_f[1:0] signals will contain {full,afull} synced to clk_pop or {aempty,empty}
// synced to clk_push depending on the setting of the SYNC_POP parameter.

generate

 if (SYNC_POP==0) begin: Sync_to_clk_push

  logic         fifo_status_sync_f;

  hqm_AW_sync_rst0 #(.WIDTH(3)) i_fifo_status (
        .clk            (clk_push),
        .rst_n          (rst_push_n),
        .data           ({fifo_pop_aempty_f,fifo_pop_empty_f,fifo_underflow_f}),
        .data_sync      (fifo_status_sync_f)
  );

  assign fifo_status = { {(24-DEPTHWIDTH){1'b0}}
                        ,fifo_push_depth                        // depth
                        ,fifo_push_full_f                       // full
                        ,fifo_push_afull_f                      // afull
                        ,fifo_push_aempty_f                     // aempty
                        ,fifo_push_empty_f                      // empty
                        ,2'd0
                        ,fifo_overflow_f                        // overflow
                        ,fifo_status_sync_f & fifo_enable       // underflow
  };

 end else begin: Sync_to_clk_pop

  logic [2:0]   fifo_status_sync_f;

  hqm_AW_sync_rst0 #(.WIDTH(3)) i_fifo_status (
        .clk            (clk_pop),
        .rst_n          (rst_pop_n),
        .data           ({fifo_push_full_f,fifo_push_afull_f,fifo_overflow_f}),
        .data_sync      (fifo_status_sync_f)
  );

  assign fifo_status = { {(24-DEPTHWIDTH){1'b0}}
                        ,fifo_pop_depth                         // depth
                        ,fifo_status_sync_f[2] & fifo_enable    // full
                        ,fifo_status_sync_f[1] & fifo_enable    // afull
                        ,fifo_pop_aempty_f                      // aempty
                        ,fifo_pop_empty_f                       // empty
                        ,2'd0
                        ,fifo_status_sync_f[0] & fifo_enable    // overflow
                        ,fifo_underflow_f                       // underflow
  };

 end

endgenerate

//--------------------------------------------------------------------------------------------
// Assertions

`ifndef INTEL_SVA_OFF

  check_underflow: assert property (@(posedge clk_pop) disable iff (rst_pop_n !== 1'b1)
  !( fifo_underflow_f)) else begin
   $display ("\nERROR: %t: %m: FIFO underflow detected (pop while not valid) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_overflow: assert property (@(posedge clk_push) disable iff (rst_push_n !== 1'b1)
  !( fifo_overflow_f)) else begin
   $display ("\nERROR: %t: %m: FIFO overflow detected (push while full) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

`endif

endmodule // AW_fifo_ctl_dc

