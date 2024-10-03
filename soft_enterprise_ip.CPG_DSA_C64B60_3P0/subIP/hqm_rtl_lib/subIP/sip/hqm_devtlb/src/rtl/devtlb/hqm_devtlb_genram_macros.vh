// lintra -50514 " copyright statement violation"
//====================================================================================================================
//
// sb_genram_macros.vh
//
// Contacts            : Eric Finley, Shruti Sethi, Vinay Chippa
// Original Author(s)  : Eric Finley
// Original Date       : 11/2016
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================
// lintra +50514 " copyright statement violation"

///=====================================================================================================================
///  <QUICK_REF>
///  clogb2                                                                       - Function
///  GENRAM_ MSFF                       (Dest, Src, Clk)                          - MasterSlave FlipFlop
///  GENRAM_EN_MSFF                     (Dest, Src, Clk, En )                     - MSFF with Fully Synchronous Enable
///  GENRAM_EN_ASYNC_RSTBD_MSFF         (Dest, Src, Clk, Enable, Rst, Rst Value)  - Resettable MSFF with Enable and programable reset value
///  GENRAM_EN_ASYNC_RSTBD_MSFF_P       (Dest, Src, Clk, Enable, Rst, Rst Value)  - Neg edge, Resettable MSFF with Enable and programable reset value
///  GENRAM_EN_ASYNC_RSTB_MSFF          (Dest, Src, Clk, Enable, Rst_b)           - Resettable MSFF with Enable
///  GENRAM_EN_ASYNC_RSTB_MSFF_P        (Dest, Src, Clk, Enable, Rst_b)           - Neg edge, Resettable MSFF with Enable
///
///  LATCHES:
///  GENRAM_LATCH                       (Dest, Src, Clk)                          - Latch
///  GENRAM_LATCH_P                     (Dest, Src, Clk)                          - Neg Clock Latch
///  GENRAM_ASYNC_RSTBD_LATCH           (Dest, Src, Clk, Rst_b, Rst Value)        - Resettable Latch with programmable reset value
///  GENRAM_ASYNC_RSTB_LATCH            (Dest, Src, Clk, Rst_b)                   - Resettable Latch 
///
///  </QUICK_REF>
///=====================================================================================================================


`ifndef HQM_DEVTLB_GENRAM_MACROS_VH            // this is needed in IRR too?
`define HQM_DEVTLB_GENRAM_MACROS_VH

///=====================================================================================================================
///
/// The following are global verilog model setup macros to be used by bees_knees.
///
///=====================================================================================================================
///=====================================================================================================================
///
///         FUNCTIONS
///
///=====================================================================================================================

// lintra -60159 " global declaration of clogb2"
`ifndef INTEL_EMULATION

    function automatic integer genram_clogb2;   // lintra s-60053
      input integer d;
      integer i, x;
      begin
        x=1;
        for (i=0; x<d; i=i+1)
          x = x << 1;

        genram_clogb2 = (d==1) ? 1 : i;
      end

`else
    `define HQM_DEVTLB_GENRAM_CLOGB2(width) (width <= 0 ? -1 : width <=  2 ? 1 : width <= 4 ? 2 : width <=  8 ? 3 : width <= 16 ? 4 : width <= 32 ? 5 : width <= 64 ? 6 : width <= 128 ? 7 : width <= 256 ? 8 : width <= 512 ? 9 : width <= 1024 ? 10 : width <= 2048 ? 11 : width <= 4096 ? 12 : width <= 8192 ? 13 : width <= 16384 ? 14 : width <= 32768 ? 15 : -1)

    function integer genram_clogb2 (input integer depth);   // lintra s-60053
    begin
    genram_clogb2 = `HQM_DEVTLB_GENRAM_CLOGB2(depth);
    end
`endif

endfunction
// lintra +60159 " global declaration of clogb2"


///=====================================================================================================================
///
///         ASSERTION MACROS:
///         GENRAM_ASSERT_NEVER
///
///=====================================================================================================================

//`ifndef GENRAM_SVA_LIB_SVA2005
//    property p_never(prop, clk, rst=1'b0);
//        @(clk) disable iff(rst) not(strong(prop));
//    endproperty : p_never
//`else
    property devtlb_p_never(prop, clk, rst=1'b0);
        @(clk) disable iff(rst) not(prop);
    endproperty : devtlb_p_never

//`endif


`define HQM_DEVTLB_GENRAM_ASSERT_NEVER(prop, clk, rst) \
   assert property(devtlb_p_never(prop, clk, rst))




///=====================================================================================================================
///
///         TIEOFF MACROS:
///         GENRAM_TIEOFF
///         GENRAM_MDA_TIEOFF
///
///=====================================================================================================================

`define HQM_DEVTLB_GENRAM_TIEOFF(i)                                \
    `ifdef INTEL_SIM_ONLY		                        \
		always_comb i = 'x; 	                        \
    `else				                                \
		always_comb i = '0;	                            \
    `endif				                                \
    // lintra s-50002 "No x assignments outside of casex statement. "


`define HQM_DEVTLB_GENRAM_MDA_TIEOFF(i, size)         		       \
	for (genvar inst_i = 0; inst_i < size; inst_i++) begin    \
    		`ifdef INTEL_SIM_ONLY		               \
			always_comb i[inst_i ] = 'x;	               \
		`else					                       \
			always_comb i[inst_i ] = '0;	               \
		`endif					                       \
	end						                           \
    	// lintra s-50002 "No x assignments outside of casex statement. "




///=====================================================================================================================


// MSFF macros:
//
// The standard MSFF takes as its input both the gridclk and its counterpart clock enable. In real circuit
// implementation, these two signals ANDed together will give you your gated clock.
//
// If you create your own clock, (you are not using the MAKE_CLK_ENABLE() macro) then tie the clken off with 1'b1 as its
// input. Otherwise use the MAKE_CLK_ENABLE() macro and use gridclock as your clk input.
//
// If you are flopping an L phase signal, be sure to pass in ~gridclk as your clk and an L phase clken. The L phase
// clken should be created with the MAKE_CLK_ENABLE() macro, with all inputs of L phase.

// These macros take the same inputs as the MSFF one, but also add in a data enable, which is NOT the same as the clock
// enable. There is a clear distinction between a data-enabled flop/latch and a clock-enabled flop/latch, in that the
// data-enabled flop/latch will have an impact on the D input timings, while the clock enable will not. The clock
// enable, however, should be used for a more distributed enable fanout, as it costs a lot of power to implement.
///


`ifdef GENRAM_FLOPDELAY
    `define HQM_DEVTLB_GENRAM_DELAY #1
`else
    `define HQM_DEVTLB_GENRAM_DELAY
`endif

`define HQM_DEVTLB_BEES_KNEES_RAM_VERSION 2

///=====================================================================================================================
/// FLOPS :
/// GENRAM_MSFF
/// GENRAM_EN_MSFF
/// GENRAM_EN_ASYNC_RSTBD_MSFF
/// GENRAM_EN_ASYNC_RSTBD_MSFF_P
/// GENRAM_EN_ASYNC_RSTB_MSFF
/// GENRAM_EN_ASYNC_RSTB_MSFF_P
///=====================================================================================================================

`define HQM_DEVTLB_GENRAM_MSFF(q,i,clock)                              \
always_ff @(posedge clock)                                  \
    begin                                                   \
    `ifdef INTEL_SIMONLY                                    \
    if ((clock) === 1'bX)                                   \
        q <= `HQM_DEVTLB_GENRAM_DELAY 'x;                              \
    else                                                    \
    `endif                                                  \
         q <= `HQM_DEVTLB_GENRAM_DELAY i;                              \
    end                                                     \
    // lintra s-50002 "No x assignments outside of casex statement. "



`define HQM_DEVTLB_GENRAM_EN_MSFF(q,i,clock,enable)                    \
always_ff @(posedge clock)                                  \
    begin                                                   \
    `ifdef INTEL_SIMONLY                                           \
    if ((clock) === 1'bX || (enable) === 1'bX)              \
        q <= `HQM_DEVTLB_GENRAM_DELAY 'X;                              \
    else                                                    \
    `endif                                                  \
    if (enable)                                             \
        q <= `HQM_DEVTLB_GENRAM_DELAY i;                               \
    end                                                     \
    // lintra s-50002, s-60018 "No x assignments outside of casex statement. " "implicit operator precedence. "



// RESET-DATA CELLS
`define HQM_DEVTLB_GENRAM_EN_ASYNC_RSTBD_MSFF(q,i,clock,enable,rst_b,rstd) \
always_ff @(posedge clock or negedge rst_b)                 \
    begin                                                   \
    `ifdef INTEL_SIMONLY                                           \
    if ((rst_b) === 1'bX)                                   \
        q <= `HQM_DEVTLB_GENRAM_DELAY 'X;                              \
    else                                                    \
   `endif                                                   \
    if ((rst_b) == 1'b0)                                    \
        q <= `HQM_DEVTLB_GENRAM_DELAY rstd;                            \
    else                                                    \
    `ifdef INTEL_SIMONLY                                           \
    if ((clock) === 1'bX || (enable) === 1'bX)              \
        q <= `HQM_DEVTLB_GENRAM_DELAY 'X;                              \
    else                                                    \
    `endif                                                  \
    if ((enable) == 1'b1)                                   \
        q <= `HQM_DEVTLB_GENRAM_DELAY i;                               \
    end                                                     \
    // lintra s-50002, s-60018 "No x assignments outside of casex statement. " "implicit operator precedence. "


`define HQM_DEVTLB_GENRAM_EN_ASYNC_RSTBD_MSFF_P(q,i,clock,enable,rst_b,rstd)   \
always_ff @(negedge clock or negedge rst_b)                 \
    begin                                                   \
    `ifdef INTEL_SIMONLY                                           \
    if ((rst_b) === 1'bX)                                   \
        q <= `HQM_DEVTLB_GENRAM_DELAY 'X;                              \
    else                                                    \
   `endif                                                   \
    if ((rst_b) == 1'b0)                                    \
        q <= `HQM_DEVTLB_GENRAM_DELAY rstd;                            \
    else                                                    \
    `ifdef INTEL_SIMONLY                                           \
    if ((clock) === 1'bX || (enable) === 1'bX)              \
        q <= `HQM_DEVTLB_GENRAM_DELAY 'X;                              \
    else                                                    \
    `endif                                                  \
    if ((enable) == 1'b1)                                   \
        q <= `HQM_DEVTLB_GENRAM_DELAY i;                               \
    end                                                     \
    // lintra s-50002 "No x assignments outside of casex statement. "


`define HQM_DEVTLB_GENRAM_EN_ASYNC_RSTB_MSFF(q,i,clock,enable,rst_b)   \
   `HQM_DEVTLB_GENRAM_EN_ASYNC_RSTBD_MSFF(q, i, clock, enable, rst_b, '0)


`define HQM_DEVTLB_GENRAM_EN_ASYNC_RSTB_MSFF_P(q,i,clock,enable,rst_b) \
    `HQM_DEVTLB_GENRAM_EN_ASYNC_RSTBD_MSFF_P(q, i, clock, enable, rst_b, '0)




///=====================================================================================================================
/// LATCHES :
/// GENRAM_LATCH
/// GENRAM_LATCH_P
/// GENRAM_ASYNC_RSTBD_LATCH
/// GENRAM_ASYNC_RSTB_LATCH
///=====================================================================================================================
// LATCH macros:
//
// All LATCHes must meet the following phase criteria, or you will run into race conditions in both real silicon and
// SystemVerilog. All PH1 latches (ie gridclk as your clk input) must have L phase inputs. All PH2 latches (ie ~gridclk
// as clk input) must have H phase inputs.
//

`define HQM_DEVTLB_GENRAM_LATCH(q,i,clock)                             \
always_latch                                                \
    begin                                                   \
    `ifdef INTEL_SIMONLY                                           \
    if ((clock) === 1'bx)                                   \
        q  <= `HQM_DEVTLB_GENRAM_DELAY 'x;                             \
    else                                                    \
    `endif                                                  \
    if ((clock) == 1'b1)                                    \
        q  <= `HQM_DEVTLB_GENRAM_DELAY i;                              \
    end                                                     \
    // lintra s-50002 "No x assignments outside of casex statement. "



`define HQM_DEVTLB_GENRAM_LATCH_P(q,i,clock)                           \
    always_latch                                            \
    begin                                                   \
    `ifdef INTEL_SIMONLY                                           \
    if ((clock) === 1'bx)                                   \
        q  <= `HQM_DEVTLB_GENRAM_DELAY 'x;                             \
    else                                                    \
    `endif                                                  \
    if ((clock) == 1'b0)                                    \
        q  <= `HQM_DEVTLB_GENRAM_DELAY i;                              \
    end                                                     \
    // lintra s-50002 "No x assignments outside of casex statement. "



`define HQM_DEVTLB_GENRAM_ASYNC_RSTBD_LATCH(q,i,clock,rst_b,rstd)      \
always_latch                                                \
    begin                                                   \
    `ifdef INTEL_SIMONLY                                           \
    if ((rst_b) === 1'bx)                                   \
        q <= `HQM_DEVTLB_GENRAM_DELAY 'X;                              \
    else                                                    \
    `endif                                                  \
    if ((rst_b) == 1'b0)                                    \
        q <= `HQM_DEVTLB_GENRAM_DELAY rstd;                            \
    else                                                    \
    `ifdef INTEL_SIMONLY                                           \
    if ((clock) === 1'bX)                                   \
        q <= `HQM_DEVTLB_GENRAM_DELAY 'X;                              \
    else                                                    \
    `endif                                                  \
    if ((clock) == 1'b1)                                    \
        q <= `HQM_DEVTLB_GENRAM_DELAY i;                               \
    end                                                     \
    // lintra s-50002 "No x assignments outside of casex statement. "



`define HQM_DEVTLB_GENRAM_ASYNC_RSTB_LATCH(q,i,clock,rst_b)            \
   `HQM_DEVTLB_GENRAM_ASYNC_RSTBD_LATCH(q, i, clock, rst_b, '0)



`endif
