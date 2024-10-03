//=====================================================================================================================
//
// DEVTLB_macros.vh
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_DEVTLB_MACROS_VH
`define HQM_DEVTLB_MACROS_VH


`define HQM_DEVTLB_PARAM_PORTCON                                       \
.DEVTLB_TLB_ZERO_CYCLE_ARB          (DEVTLB_TLB_ZERO_CYCLE_ARB ),   \
.DEVTLB_TLB_READ_LATENCY            (DEVTLB_TLB_READ_LATENCY   ),   \
.DEVTLB_TLB_NUM_ARRAYS              (DEVTLB_TLB_NUM_ARRAYS ),   \
.DEVTLB_TLB_NUM_WAYS                (DEVTLB_TLB_NUM_WAYS   ),   \
.DEVTLB_TLB_NUM_PS_SETS             (DEVTLB_TLB_NUM_PS_SETS ),  \
.DEVTLB_TLB_NUM_SETS                (DEVTLB_TLB_NUM_SETS ), \
.DEVTLB_TLB_SHARE_EN                (DEVTLB_TLB_SHARE_EN), \
.DEVTLB_TLB_ALIASING                (DEVTLB_TLB_ALIASING), \
.DEVTLB_XREQ_PORTNUM                (DEVTLB_XREQ_PORTNUM),  \
.DEVTLB_TLB_ARBGCNT_WIDTH           (DEVTLB_TLB_ARBGCNT_WIDTH),  \
.DEVTLB_TLB_ARRAY_STYLE             (DEVTLB_TLB_ARRAY_STYLE  ), \
.DEVTLB_MAX_LINEAR_ADDRESS_WIDTH    (DEVTLB_MAX_LINEAR_ADDRESS_WIDTH),  \
.DEVTLB_MAX_HOST_ADDRESS_WIDTH      (DEVTLB_MAX_HOST_ADDRESS_WIDTH  ),  \
.DEVTLB_HCB_DEPTH                   (DEVTLB_HCB_DEPTH), \
.DEVTLB_LCB_DEPTH                   (DEVTLB_LCB_DEPTH), \
.DEVTLB_REQ_ID_WIDTH                (DEVTLB_REQ_ID_WIDTH ), \
.DEVTLB_MISSTRK_DEPTH               (DEVTLB_MISSTRK_DEPTH   ),  \
.DEVTLB_MISSTRK_ARRAY_STYLE         (DEVTLB_MISSTRK_ARRAY_STYLE ),  \
.DEVTLB_LPMSTRK_CRDT                (DEVTLB_LPMSTRK_CRDT),  \
.DEVTLB_HPMSTRK_CRDT                (DEVTLB_HPMSTRK_CRDT),  \
.DEVTLB_PENDQ_SUPP_EN               (DEVTLB_PENDQ_SUPP_EN   ),  \
.DEVTLB_PENDQ_DEPTH                 (DEVTLB_PENDQ_DEPTH ),  \
.DEVTLB_PENDQ_ARRAY_STYLE           (DEVTLB_PENDQ_ARRAY_STYLE ),    \
.DEVTLB_INVQ_DEPTH                  (DEVTLB_INVQ_DEPTH),    \
.DEVTLB_INVQ_ARRAY_STYLE            (DEVTLB_INVQ_ARRAY_STYLE  ),    \
.NO_POWER_GATING                    (NO_POWER_GATING),  \
.DEVTLB_PARITY_WIDTH                (DEVTLB_PARITY_WIDTH  ),    \
.DEVTLB_PARITY_EN                   (DEVTLB_PARITY_EN),    \
.DEVTLB_NUM_DBGPORTS                (DEVTLB_NUM_DBGPORTS),    \
.DEVTLB_BDF_SUPP_EN                 (DEVTLB_BDF_SUPP_EN),     \
.DEVTLB_BDF_WIDTH                   (DEVTLB_BDF_WIDTH),    \
.DEVTLB_PASID_SUPP_EN               (DEVTLB_PASID_SUPP_EN),    \
.DEVTLB_PASID_WIDTH                 (DEVTLB_PASID_WIDTH)

///=====================================================================================================================
/// Bit Extension Macros.  Only useful with packed data "in".
///=====================================================================================================================

// The SX macro is used to SIGN-EXTEND packed data to a desired size.
`define HQM_DEVTLB_SX(in,sz) {{sz-$bits(in){in[$bits(in)-1]}},in}

// The OX macro is used to ONES-EXTEND packed data to a desired size.
`define HQM_DEVTLB_OX(in,sz) {{sz-$bits(in){1'b1}},in}

// The ZX macro is used to ZERO-EXTEND packed data to a desired size.  This macro is generally not needed.
// Standard verilog will zero-extend data.  However, it is included here for completeness.
`define HQM_DEVTLB_ZX(in,sz) {{sz-$bits(in){1'b0}},in}

// The SHL1 and SHR1 shift the "in" vector "cnt" number of bits, either Left or Right, and shift IN 1 values
`define HQM_DEVTLB_SHL1(in,cnt) {in[$bits(in)-1-cnt:0], {cnt{1'b1}}}
`define HQM_DEVTLB_SHR1(in,cnt) {{cnt{1'b1}},in[$bits(in)-1:cnt]}

// The SHL1 and SHR1 shift the "in" vector "cnt" number of bits, either Left or Right, and shift IN 0 values
// Standard verilog will already shift 0's with the << and >> operators, but added here for completeness.
`define HQM_DEVTLB_SHL0(in,cnt) {in[$bits(in)-1-cnt:0], {cnt{1'b0}}}
`define HQM_DEVTLB_SHR0(in,cnt) {{cnt{1'b0}},in[$bits(in)-1:cnt]}

// The ASHR is an "arithmetic" shift right that fills in with the MSB bit of the vector.  A signed shift.
`define HQM_DEVTLB_ASHR(in,cnt) {{cnt{in[$bits(in)-1]}},in[$bits(in)-1:cnt]}

// The SHRV and SRLV shifts right or left, filling in the MSB(s) or LSB(s) with a specified signal
// Be careful about getting the right number of bits
`define HQM_DEVTLB_SHLV(in,cnt,lsb) {in[$bits(in)-1-cnt:0],lsb}
`define HQM_DEVTLB_SHRV(in,cnt,msb) {msb,in[$bits(in)-1:cnt]}

///=====================================================================================================================
/// Rotate macros
///
/// Note that there are also rotate functions in nhm_functions.sv.  
/// The functions may provide better synthesis results for a rotater with a variable rotation amount.
///=====================================================================================================================

// Rotate "a" to the left by "n" bits
//
`define HQM_ROTL_N(a,n) ((a << n) | ( a >> ($bits(a)-n)))  

// Rotate "a" to the right by "n" bits
//
`define HQM_ROTR_N(a,n) ((a >> n) | ( a << ($bits(a)-n)))

//=====================================================================================================================
// State macros
//=====================================================================================================================

`define HQM_DEVTLB_MSFF(q,i,clock)                                      \
   always_ff @(posedge clock)                                \
      begin                                                  \
   `ifdef VAL4_OPTIMIZED                                     \
        q <=  (clock) ? i : q;                               \
   `else                                                     \
        q <= i;                                              \
   `endif                                                    \
      end                                                    \

`define HQM_DEVTLB_EN_MSFF(q,i,clock,enable)                            \
   always_ff @(posedge clock)                                \
      begin                                                  \
  `ifdef VAL4_OPTIMIZED                                      \
         q <=  ((clock) & (enable)) ? i : q;                 \
   `else                                                     \
         if ((enable)) q <= i;                               \
   `endif                                                    \
       end                                                   \

`define HQM_DEVTLB_EN_RST_MSFF(q,i,clock,enable,rst)                    \
   always_ff @(posedge clock )                               \
      begin                                                  \
   `ifdef VAL4_OPTIMIZED                                     \
         q <= (clock) ? ((rst) ? '0 : ((enable) ? i : q)) : q; \
   `else                                                     \
            if ( rst )         q <= '0 ;                     \
            else if ( enable ) q <=  i ;                     \
   `endif                                                    \
      end                                                    \

`define HQM_DEVTLB_RST_MSFF(q,i,clock,rst)                              \
   always_ff @(posedge clock)                                \
      begin                                                  \
   `ifdef VAL4_OPTIMIZED                                     \
          q <= (clock) ? ((rst) ? '0 : i) : q ;              \
   `else                                                     \
           if (rst) q <= '0;                                 \
          else     q <=  i;                                  \
   `endif                                                    \
      end                                                    \

`define HQM_DEVTLB_ARST_MSFF(q,i,clock,arst)                      \
   always_ff @(posedge clock, posedge arst)                  \
      begin                                                  \
   `ifdef VAL4_OPTIMIZED                                     \
          q <= (clock) ? ((arst) ? '0 : i) : q ;              \
   `else                                                     \
           if (arst) q <= '0;                                 \
          else     q <=  i;                                  \
   `endif                                                    \
      end                                                    \

`define HQM_DEVTLB_SET_RST_MSFF(q,i,clock,set,rst)                      \
   always_ff @(posedge clock)                                \
      begin                                                  \
   `ifdef VAL4_OPTIMIZED                                     \
       q <= (clock) ? ((rst) ? '0 : ((set) ? '1 : i)) : q;   \
   `else                                                     \
         if (rst)      q <= '0;                              \
         else if (set) q <= '1;                              \
         else          q <=  i;                              \
   `endif                                                    \
      end                                                    \

`define HQM_DEVTLB_RSTD_MSFF(q,i,clock,rst,rstd)                        \
   always_ff @(posedge clock)                                \
      begin                                                  \
   `ifdef VAL4_OPTIMIZED                                     \
         q <= (clock) ? ((rst) ? rstd : i) : q ;             \
   `else                                                     \
         if (rst)                                            \
            q <= rstd;                                       \
         else                                                \
            q <= i;                                          \
   `endif                                                    \
      end                                                    \

`define HQM_DEVTLB_EN_RSTD_MSFF(q,i,clock,enable,rst,rstd)              \
   always_ff @(posedge clock)                                \
       begin                                                 \
   `ifdef VAL4_OPTIMIZED                                     \
         q <= (clock) ? ((rst) ? rstd : ((enable) ? i : q)) : q; \
   `else                                                     \
         if (rst)          q <= rstd;                        \
         else if (enable)  q <= i;                           \
   `endif                                                    \
      end

`define HQM_DEVTLB_LATCH(q,i,clock)                                     \
   always_latch                                              \
      begin                                                  \
   `ifdef VAL4_OPTIMIZED                                     \
         q <= (clock) ? i : q;                               \
   `else                                                     \
         if (clock) q <= i;                                  \
   `endif                                                    \
      end                                                    \

//=====================================================================================================================
//
// TLB Address Macros
//
//=====================================================================================================================

// The TLB Set Address is the number of bits needed to address the designated TLB
// starting from the lowest translated bit for the given page size
//
// 4K pages start from bit 12 and all other page sizes are on a 9 bit stride from bit 12
//
`define HQM_DEVTLB_TLB_SET_LSB(NUM_SETS,tlb_id,tlb_ps)   (12+(9*tlb_ps))
`define HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,tlb_id,tlb_ps)   `HQM_DEVTLB_LOG2(NUM_SETS[tlb_id][tlb_ps])-1+`HQM_DEVTLB_TLB_SET_LSB(NUM_SETS,tlb_id,tlb_ps)
`define HQM_DEVTLB_TLB_SET_RANGE(NUM_SETS,tlb_id,tlb_ps) `HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,tlb_id,tlb_ps):`HQM_DEVTLB_TLB_SET_LSB(NUM_SETS,tlb_id,tlb_ps)

`define HQM_DEVTLB_TLB_TAG_BITS(ps)                    DEVTLB_GAW_LAW_MAX-(12+(9*ps))
`define HQM_DEVTLB_TLB_TAG_RANGE(ps)                   DEVTLB_GAW_LAW_MAX-1:(12+(9*ps))

`define HQM_DEVTLB_TLB_UNTRAN_RANGE(ps)                  (11+(9*ps)):12
`define HQM_DEVTLB_TLB_DATA_RANGE(ps)                    DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:(12+(9*ps))

`define HQM_DEVTLB_TLB_UNTRAN_RANGE_MSB(ps)              (11+(9*ps))

// Abbreviated code substitutions for frequently used elements
//
`define HQM_DEVTLB_GET_TLBID(tlbid, ps)                     (TLB_SHARE_EN? TLB_ALIASING[tlbid][ps]: tlbid)
`define HQM_DEVTLB_PIPE_TLBID(stage, ps)                    (TLB_SHARE_EN? TLB_ALIASING[TLBPipe_H[stage].Req.TlbId][ps]: TLBPipe_H[stage].Req.TlbId)

//=====================================================================================================================
//
// Misc. Functions
//
//=====================================================================================================================

`define HQM_DEVTLB_LOG2(depth) (          \
      (depth <= 2)      ? 1 :        \
      (depth <= 4)      ? 2 :        \
      (depth <= 8)      ? 3 :        \
      (depth <= 16)     ? 4 :        \
      (depth <= 32)     ? 5 :        \
      (depth <= 64)     ? 6 :        \
      (depth <= 128)    ? 7 :        \
      (depth <= 256)    ? 8 :        \
      (depth <= 512)    ? 9 :        \
      (depth <= 1024)   ? 10 :       \
      (depth <= 2048)   ? 11 : 12)

//=====================================================================================================================
//
// Parameterized macros
//
// This define is used to pass top-level parameters down through the
// interface of each sub-module so that they can receive the alternate
// parameter values assigned for each iommu instance
//
//=====================================================================================================================
//

`define HQM_DEVTLB_COMMON_PORTLIST                                                    \
      clk,                                                                       \
                                                                                 \
      dfx_array_scan_mode_en,                                                    \
      dfx_array_scan_mode_way,                                                   \
      reset,                                                                     \
      reset_INST,

`define HQM_DEVTLB_FSCAN_PORTLIST                                                     \
      fscan_clkungate,                                                           \
      fscan_latchopen,                                                           \
      fscan_latchclosed_b,                                                       \
      fscan_rstbypen,                                                            \
      fscan_byprst_b,

`define HQM_DEVTLB_COMMON_PORTDEC                                                     \
      input    logic                                  clk;                       \
                                                                                 \
      input    logic                                  dfx_array_scan_mode_en;    \
      input    logic  [7:0]                           dfx_array_scan_mode_way;   \
      input    logic                                  reset;                     \
      input    logic                                  reset_INST;

`define HQM_DEVTLB_COMMON_PORTDEC_SV                                                     \
      input    logic                                  clk,                       \
                                                                                 \
      input    logic                                  dfx_array_scan_mode_en,    \
      input    logic  [7:0]                           dfx_array_scan_mode_way,   \
      input    logic                                  reset,                     \
      input    logic                                  reset_INST,

`define HQM_DEVTLB_FSCAN_PORTDEC                                                      \
      input    logic                                  fscan_clkungate;           \
      input    logic                                  fscan_latchopen;           \
      input    logic                                  fscan_latchclosed_b;       \
      input    logic                                  fscan_rstbypen;            \
      input    logic                                  fscan_byprst_b;

`define HQM_DEVTLB_FSCAN_PORTDEC_SV                                                  \
      input    logic                                  fscan_clkungate,           \
      input    logic                                  fscan_latchopen,           \
      input    logic                                  fscan_latchclosed_b,       \
      input    logic                                  fscan_rstbypen,            \
      input    logic                                  fscan_byprst_b,

`define HQM_DEVTLB_COMMON_PORTCON                                                     \
      .clk                       (clk),                                          \
                                                                                 \
      .dfx_array_scan_mode_en    (dfx_array_scan_mode_en),                       \
      .dfx_array_scan_mode_way   (dfx_array_scan_mode_way),                      \
      .reset                     (reset),                                        \
      .reset_INST                (reset_INST),

`define HQM_DEVTLB_FSCAN_PORTCON                                                     \
      .fscan_clkungate           (fscan_clkungate),                              \
      .fscan_latchopen           (fscan_latchopen),                              \
      .fscan_latchclosed_b       (fscan_latchclosed_b),                          \
      .fscan_rstbypen            (fscan_rstbypen),                               \
      .fscan_byprst_b            (fscan_byprst_b),

`define HQM_DEVTLB_COMMON_PORTCON_W_SYNC_RESET                                        \
      .clk                       (clk),                                          \
                                                                                 \
      .dfx_array_scan_mode_en    (dfx_array_scan_mode_en),                       \
      .dfx_array_scan_mode_way   (dfx_array_scan_mode_way),                      \
      .reset                     (local_reset),                                   \
      .reset_INST                (reset_INST),

`define HQM_DEVTLB_COMMON_PORTCON_W_ASYNC_RESET                                       \
      .clk                       (clk),                                          \
                                                                                 \
      .dfx_array_scan_mode_en    (dfx_array_scan_mode_en),                       \
      .dfx_array_scan_mode_way   (dfx_array_scan_mode_way),                      \
      .reset                     (local_reset),                                  \
      .reset_INST                (reset_INST),

`define HQM_DEVTLB_MAKE_RCB_PH1(iCkRcbXPN, iCkGcbXPN, iLPEn, iLPOvrd)                                        \
    `ifdef HQM_MACRO_ATTRIBUTE                                                                              \
      (* macro_attribute = `"DEVTLB_MAKE_RCB_PH1(iCkRcbXPN``,iCkGcbXPN``,iLPEn``,iLPOvrd``)`" *)         \
    `endif                                                                                              \
    (* instance_name = `"\rcb_``iCkRcbXPN`" *)                                                          \
    hqm_devtlb_ctech_clk_gate_te \rcb_``iCkRcbXPN (                                                            \
           .en      (iLPEn | iLPOvrd | NO_POWER_GATING),                                            \
           .te      (fscan_clkungate | NO_POWER_GATING/*1'b0*/),                                    \
           .clk     (iCkGcbXPN),                                                                    \
           .clkout  (iCkRcbXPN)                                                                     \
    );

// Macro to instantiate a normal LCB clock.
//
`define HQM_DEVTLB_MAKE_LCB_PWR(iCkLcbXPN, iCkRcbXPN, iLPEn, iLPOvrd)          \
   `ifdef HQM_MACRO_ATTRIBUTE                                                 \
      (* macro_attribute = `"DEVTLB_MAKE_LCB_PWR(iCkLcbXPN``,iCkRcbXPN``,iLPEn``,iLPOvrd``)`" *) \
   `endif                                                                 \
   (* instance_name = `"\lcb_``iCkLcbXPN`" *)                             \
   hqm_devtlb_ctech_clk_gate_te \lcb_``iCkLcbXPN (                               \
           .en      (iLPEn | iLPOvrd | NO_POWER_GATING),              \
           .te      (fscan_clkungate | NO_POWER_GATING/*1'b0*/),      \
           .clk    ( iCkRcbXPN),                                      \
           .clkout  (iCkLcbXPN)                                       \
   );

`define HQM_DEVTLB_MAKE_LCB_FUNC(iCkLcbXPN, iCkRcbXPN, iFcEn)                  \
   `ifdef HQM_MACRO_ATTRIBUTE                                                 \
      (* macro_attribute = `"DEVTLB_MAKE_LCB_FUNC(iCkLcbXPN``,iCkRcbXPN``,iFcEn``)`" *) \
   `endif                                                                 \
   (* instance_name = `"\lcb_``iCkLcbXPN`" *)                             \
   hqm_devtlb_ctech_clk_gate_te \lcb_``iCkLcbXPN (                               \
           .en      (iFcEn),                                          \
           .te      (fscan_clkungate/*1'b0*/),                        \
           .clk    ( iCkRcbXPN),                                      \
           .clkout  (iCkLcbXPN)                                       \
   );  

`define HQM_DEVTLB_GCLATCHEN_VEC(width, in_en, in_te, in_clrb, in_ck, in_enclk)             \
            genvar gt_gclatchen_vec_idx;                                               \
            for(gt_gclatchen_vec_idx = 0; gt_gclatchen_vec_idx < width; gt_gclatchen_vec_idx++) begin : gclatchen   \
                                                                                       \
                hqm_devtlb_ctech_clk_gate_te_rstb clk_gate (                            \
                .en(in_en[gt_gclatchen_vec_idx]),                              \
                        .te(in_te),                                                    \
                        .rstb(in_clrb),                                                \
                        .clk(in_ck),                                                   \
                        .clkout(in_enclk[gt_gclatchen_vec_idx])                        \
                );                                                                 \
                                                                                       \
            end : gclatchen                                                        \

`define HQM_DEVTLB_GCMSFFEN_VEC(width, in_en, in_te, in_ck, in_enclk)                       \
            genvar gt_gclatchen_vec_idx;                                               \
            for(gt_gclatchen_vec_idx = 0; gt_gclatchen_vec_idx < width; gt_gclatchen_vec_idx++) begin : gclatchen   \
                                                                                       \
                     hqm_devtlb_ctech_clk_gate_te clk_gate (                                  \
                .en(in_en[gt_gclatchen_vec_idx]),                              \
                        .te(in_te),                                                    \
                        .clk(in_ck),                                                   \
                        .clkout(in_enclk[gt_gclatchen_vec_idx])                        \
                     );                                                                \
                                                                                       \
            end : gclatchen                                                        \


`define HQM_DEVTLB_IFC_ISKNOWN(sig, en)                                                     \
  `HQM_DEVTLB_ASSERTS_TRIGGER(\DEVTLB_IFC_ISKNOWN_``sig , en , ~$isunknown(sig) ,            \
            clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value of interface signal is unknown.")); 

`define HQM_DEVTLB_CALC_PARITY(data, en) (                                                         \
   (~(DEVTLB_PARITY_EN && en))? '0:                                                                    \
   ((DEVTLB_PARITY_WIDTH == 2)                                                              \
         ? {^{`HQM_DEVTLB_ZX(data,500) & {250{2'b10}}},^{`HQM_DEVTLB_ZX(data,500) & {250{2'b01}}}}  \
         : {^{data}} ))

// Parity Check Macro - input expected parity and bits to be checked
// 1 -> parity check passes
`define HQM_DEVTLB_PARITY_CHECK(parity, data, en)   ((parity == `HQM_DEVTLB_CALC_PARITY(data, en)) || ~(DEVTLB_PARITY_EN && en))

`endif // DEVTLB_MACROS_VH 
