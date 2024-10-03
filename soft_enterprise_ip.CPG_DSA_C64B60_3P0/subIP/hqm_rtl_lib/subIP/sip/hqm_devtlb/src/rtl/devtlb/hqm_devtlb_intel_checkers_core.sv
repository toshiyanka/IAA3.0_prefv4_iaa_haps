//=====================================================================================================================
//
// DEVTLB_intel_checkers_core.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Unknown (inherited)
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

/*
There are two kinds of core entities, sequential and combinational.
The combinational entities do not use a sampling clock and are implemented
on top of deferred assertions.
The sequential entities require a clock for sampling the design signals and
are implemented on top of concurrent assertions.

The sequential entities can infer the clock from its context if not specified
explicitly in the entity instance. The clk is inherited either from the
enclosing always procedure (with posedge/negedge control) or from the default
clocking. The reset has a default value of 1'b0. Therefore, if an actual
argument for rst is omitted, the assertion is always enabled.

Both kinds of entities can be instantiated in procedural and in concurrent
(structural) contexts. Both positional and named association between the
formal and the actual arguments is supported.
The combinational entities start with ASSERTC, The sequential entities start
with ASSERTS. The legacy format used by SNB is also supported.

Stability assertions: there are two sets of sequential entities:
Those checking also between specified clock ticks, and those which check only
on specified clock ticks.

Note 1:  the first operate on system clock that samples the design clock, clk,
and the design signals. Those entities start with ASSERTS_G... . These entities
trigger on both edges of the system clock.

Note2: The system-clock based entites come in two varieties,  event based
checkers and signal based.  They are distinguished by the suffixes in the names.
For the second  group only the clock name or its complement must be provided as
the  actual argument, i.e., there should be no edge specifier.



Examples:
=========

Combinational entity:
    `HQM_DEVTLB_ASSERTC_MUTEXED(name, myBusEnables, `HQM_DEVTLB_ERR_MSG("I have error"));

Sequential entity:
    `HQM_DEVTLB_ASSERTS_TRIGGER(name, x, y, posedge clk, rst, `HQM_DEVTLB_ERR_MSG("I have error"));

Usage Examples:
    // declare default clock if so desired
    default clocking def_clk @(posedge clk);
    endclocking

    Positional association:
       // clk inferred either from always or def_clk, rst is 0
       `HQM_DEVTLB_ASSERTS_TRIGGER(name, x, y, , , `HQM_DEVTLB_ERR_MSG("I have error"))
       // clk inferred either from always or def_clk,
       `HQM_DEVTLB_ASSERTS_TRIGGER(name, x, y, , rst, `HQM_DEVTLB_ERR_MSG("I have error"))
       // default rst of 0
       `HQM_DEVTLB_ASSERTS_TRIGGER(name, x, y, posedge clk, , `HQM_DEVTLB_ERR_MSG("I have error"))
       // no default or inference
       `HQM_DEVTLB_ASSERTS_TRIGGER(name, x, y, posedge clk, rst, `HQM_DEVTLB_ERR_MSG("I have error"))

    Named associations:
        // clk inferred either from always or def_clk, rst is 0
       `HQM_DEVTLB_ASSERTS_TRIGGER(name, .en(x), .ev(y), .prop(z), `HQM_DEVTLB_ERR_MSG("I have error"))

*/






// === === === Implementation for the templates

`include "hqm_devtlb_intel_checkers_core_imp.sv"

// --- --- --- --- --- --- --- --- --- --- ----




// --- --- --- Immediate Templates --- --- --- //


// ****************************************************************************************** //
// Name:   mutexed
// Description:
//       At most one bit of 'sig' is high (1 or x or z)
// Arguments:
//       sig        - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_MUTEXED(sig, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_mutexed(sig))  /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_MUTEXED(sig, clk, rst) \
   assume property(DEVTLB_p_mutexed(sig, clk, rst))

`define HQM_DEVTLB_COVER_MUTEXED(sig, clk, rst) \
   cover property(DEVTLB_p_cover_mutexed(sig, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_MUTEXED_COVER(sig, clk ,rst) \
   cover property(DEVTLB_p_not_mutexed_covered(sig, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_MUTEXED(name, sig, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_MUTEXED(sig, rst) MSG

`define HQM_DEVTLB_ASSUMEC_MUTEXED(name, sig, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_mutexed(sig)) MSG



`define HQM_DEVTLB_ASSUMES_MUTEXED(name, sig, clk, rst, MSG)  \
   name: `HQM_DEVTLB_ASSUME_MUTEXED(sig, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_MUTEXED(name, sig, clk, rst, MSG) \
   name: assert property(DEVTLB_p_mutexed(sig, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_MUTEXED(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_MUTEXED(sig, clk, rst) MSG

`define HQM_DEVTLB_COVERC_MUTEXED(name, sig, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_mutexed(sig)) MSG



`define HQM_DEVTLB_NOT_MUTEXED_COVERS(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_NOT_MUTEXED_COVER(sig, clk, rst) MSG

`define HQM_DEVTLB_NOT_MUTEXED_COVERC(name, sig, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && !`HQM_DEVTLB_l_mutexed(sig)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   one hot
// Description:
//       Exactly one bit of 'sig' is high (1)
// Arguments:
//       sig        - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_ONE_HOT(sig, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_one_hot(sig)) /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_ONE_HOT(sig, clk, rst) \
   assume property(DEVTLB_p_one_hot(sig, clk, rst))

`define HQM_DEVTLB_COVER_ONE_HOT(sig, clk, rst) \
   cover property(DEVTLB_p_cover_one_hot(sig, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_ONE_HOT_COVER(sig, clk, rst)  \
   cover property(p_no_one_hot_cover(sig, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_ONE_HOT(name, sig, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_ONE_HOT(sig, rst) MSG

`define HQM_DEVTLB_ASSUMEC_ONE_HOT(name, sig, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_one_hot(sig)) MSG



`define HQM_DEVTLB_ASSUMES_ONE_HOT(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_ONE_HOT(sig, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_ONE_HOT(name, sig, clk, rst, MSG) \
   name : assert property(DEVTLB_p_one_hot(sig, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_ONE_HOT(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_ONE_HOT(sig, clk ,rst) MSG

`define HQM_DEVTLB_COVERC_ONE_HOT(name, sig, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_one_hot(sig)) MSG



`define HQM_DEVTLB_NOT_ONE_HOT_COVERS(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_NOT_ONE_HOT_COVER(sig, clk, rst) MSG

`define HQM_DEVTLB_NOT_ONE_HOT_COVERC(name, sig, rst, MSG)\
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && !`HQM_DEVTLB_l_one_hot(sig)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   same bits
// Description:
//       All bits of sig have the same value
// Arguments:
//       sig        - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_SAME_BITS(sig, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_same_bits(sig))  /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_SAME_BITS(sig, clk, rst) \
   assume property(DEVTLB_p_same_bits(sig, clk, rst))

`define HQM_DEVTLB_COVER_SAME_BITS(sig, clk, rst) \
   cover property(DEVTLB_p_cover_same_bits(sig, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_SAME_BITS_COVER(sig, clk, rst) \
   cover property(DEVTLB_p_not_same_bits_cover(sig, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_SAME_BITS(name, sig, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_SAME_BITS(sig, rst) MSG

`define HQM_DEVTLB_ASSUMEC_SAME_BITS(name, sig, rst, MSG)\
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_same_bits(sig)) MSG



`define HQM_DEVTLB_ASSUMES_SAME_BITS(name, sig, clk, rst, MSG)\
   name: `HQM_DEVTLB_ASSUME_SAME_BITS(sig, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_SAME_BITS(name, sig, clk, rst, MSG)\
   name : assert property(DEVTLB_p_same_bits(sig, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_SAME_BITS(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_SAME_BITS(sig, clk, rst) MSG

`define HQM_DEVTLB_COVERC_SAME_BITS(name, sig, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_same_bits(sig)) MSG



`define HQM_DEVTLB_NOT_SAME_BITS_COVERS(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_NOT_SAME_BITS_COVER(sig, clk, rst) MSG

`define HQM_DEVTLB_NOT_SAME_BITS_COVERC(name, sig, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && !`HQM_DEVTLB_l_same_bits(sig)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   range
// Description:
//       Signal 'sig' must always be in the range [low,high] inclusive of both the range values.
// Arguments:
//       sig             - Bit-vector
//       low             - Integer
//       high            - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_RANGE(sig, low, high, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_range(sig, low, high)) /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_RANGE(sig, low, high, clk, rst) \
   assume property(DEVTLB_p_range(sig, low, high, clk, rst))

`define HQM_DEVTLB_COVER_RANGE(sig, low, high, clk, rst)  \
   cover property(DEVTLB_p_cover_range(sig, low, high, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_RANGE_COVER(sig, low, high, clk ,rst) \
   cover property(DEVTLB_p_not_range_cover(sig, low, high, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_RANGE(name, sig, low, high, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_RANGE(sig, low, high, rst) MSG

`define HQM_DEVTLB_ASSUMEC_RANGE(name, sig, low, high, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_range(sig, low, high)) MSG



`define HQM_DEVTLB_ASSUMES_RANGE(name, sig, low, high, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_RANGE(sig, low, high, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_RANGE(name, sig, low, high, clk, rst, MSG) \
   name: assert property(DEVTLB_p_range(sig, low, high, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_RANGE(name, sig, low, high, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_RANGE(sig, low, high, clk, rst) MSG

`define HQM_DEVTLB_COVERC_RANGE(name, sig, low, high, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_range(sig, low, high)) MSG



`define HQM_DEVTLB_NOT_RANGE_COVERS(name, sig, low, high, clk ,rst, MSG) \
   name: `HQM_DEVTLB_NOT_RANGE_COVER(sig, low, high, clk, rst) MSG

`define HQM_DEVTLB_NOT_RANGE_COVERC(name, sig, low, high, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && !`HQM_DEVTLB_l_range(sig, low, high)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   at most bits high
// Description:
//       At most 'n' bits in sig are high (1 or x or z)
// Arguments:
//       sig             - Bit-vector
//       n               - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_AT_MOST_BITS_HIGH(sig, n, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_at_most_bits_high(sig, n))  /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_AT_MOST_BITS_HIGH(sig, n, clk, rst) \
   assume property(DEVTLB_p_at_most_bits_high(sig, n, clk, rst))

`define HQM_DEVTLB_COVER_AT_MOST_BITS_HIGH(sig, n, clk, rst) \
   cover property (DEVTLB_p_cover_at_most_bits_high(sig, n, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_AT_MOST_BITS_HIGH_COVER(sig, n, clk, rst) \
   cover property (DEVTLB_p_not_at_most_bits_high_cover(sig, n, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_AT_MOST_BITS_HIGH(name, sig, n, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_AT_MOST_BITS_HIGH(sig, n, rst) MSG

`define HQM_DEVTLB_ASSUMEC_AT_MOST_BITS_HIGH(name, sig, n, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_at_most_bits_high(sig, n)) MSG



`define HQM_DEVTLB_ASSUMES_AT_MOST_BITS_HIGH(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_AT_MOST_BITS_HIGH(sig, n, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_AT_MOST_BITS_HIGH(name, sig, n, clk, rst, MSG) \
   name: assert property(DEVTLB_p_at_most_bits_high(sig, n, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_AT_MOST_BITS_HIGH(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_AT_MOST_BITS_HIGH(sig, n, clk, rst) MSG

`define HQM_DEVTLB_COVERC_AT_MOST_BITS_HIGH(name, sig, n, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_at_most_bits_high(sig, n)) MSG



`define HQM_DEVTLB_NOT_AT_MOST_BITS_HIGH_COVERS(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_NOT_AT_MOST_BITS_HIGH_COVER(sig, n, clk, rst) MSG

`define HQM_DEVTLB_NOT_AT_MOST_BITS_HIGH_COVERC(name ,sig, n, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && !`HQM_DEVTLB_l_at_most_bits_high(sig, n)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   bits high
// Description:
//       Exactly 'n' bits in sig are high (1)
// Arguments:
//       sig        - Bit-vector
//       n              - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_BITS_HIGH(sig, n, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_bits_high(sig, n)) /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_BITS_HIGH(sig, n, clk, rst) \
   assume property(DEVTLB_p_bits_high(sig, n, clk, rst))

`define HQM_DEVTLB_COVER_BITS_HIGH(sig, n, clk, rst) \
   cover property(DEVTLB_p_cover_bits_high(sig, n, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_BITS_HIGH_COVER(sig, n, clk, rst) \
   cover property(DEVTLB_p_not_bits_high_cover(sig, n, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_BITS_HIGH(name, sig, n, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_BITS_HIGH(sig, n, rst) MSG

`define HQM_DEVTLB_ASSUMEC_BITS_HIGH(name, sig, n, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_bits_high(sig, n)) MSG



`define HQM_DEVTLB_ASSUMES_BITS_HIGH(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_BITS_HIGH(sig, n, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_BITS_HIGH(name, sig, n, clk, rst, MSG) \
   name: assert property(DEVTLB_p_bits_high(sig, n, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_BITS_HIGH(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_BITS_HIGH(sig, n, clk, rst) MSG

`define HQM_DEVTLB_COVERC_BITS_HIGH(name, sig, n, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_bits_high(sig, n)) MSG



`define HQM_DEVTLB_NOT_BITS_HIGH_COVERS(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_NOT_BITS_HIGH_COVER(sig, n, clk, rst) MSG

`define HQM_DEVTLB_NOT_BITS_HIGH_COVERC(name ,sig, n, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && !`HQM_DEVTLB_l_bits_high(sig, n)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   one of
// Description:
//       Signal one of a set of values.
// Arguments:
//       sig        - Bit-vector
//       set            - Set of elements, for example {1, 2, 3, 4}
//
// Comments : - set of elements is currently not supported in let statements.
//            - several sequential templates are not supported.
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_ONE_OF(sig, set, rst) \
   assert `HQM_DEVTLB_FINAL ((|((rst | reset_INST))) | ((sig) inside set) & `HQM_DEVTLB_SVA_LIB_KNOWN(sig)) /* novas s-2050 */

// `define DEVTLB_ASSUME_ONE_OF(sig, set, clk, rst) \
//    assume property(p_one_of(sig, set, clk, rst))

// `define DEVTLB_COVER_ONE_OF(sig, sig, clk, rst) \
//    cover property (p_cover_one_of(sig, set, clk, (rst | reset_INST)))

// `define DEVTLB_NOT_ONE_OF_COVER(sig, sig, clk, rst) \
//    cover property(p_not_one_of_cover(sig, set, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_ONE_OF(name, sig, set, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_ONE_OF(sig, set, rst) MSG

`define HQM_DEVTLB_ASSUMEC_ONE_OF(name, sig, set, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || ((sig) inside set)) MSG



// `define DEVTLB_ASSUMES_ONE_OF(name, sig, set, clk, rst, MSG) \
//    name: `DEVTLB_ASSUME_ONE_OF(sig, set, clk, rst) MSG

// `define DEVTLB_ASSERTS_ONE_OF(name, sig, set, clk, rst, MSG) \
//    name: assert property(p_one_of(sig, set, clk, (rst | reset_INST))) MSG



// `define DEVTLB_COVERS_ONE_OF(name, sig, set, clk, rst, MSG) \
//    name: `DEVTLB_COVER_ONE_OF(sig, set, clk, rst) MSG

`define HQM_DEVTLB_COVERC_ONE_OF(name, sig, set, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && ((sig) inside set)) MSG



// `define DEVTLB_NOT_ONE_OF_COVERS(name, sig, set, clk, rst, MSG) \
//    name: `DEVTLB_NOT_ONE_OF_COVER(sig, set, clk, rst) MSG

`define HQM_DEVTLB_NOT_ONE_OF_COVERC(name ,sig, set, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && !((sig) inside set)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   known driven
// Description:
//       All bits of sig are both known (not X) and driven (not Z).
// Arguments:
//       sig        - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

`ifndef INTEL_EMULATION
`define HQM_DEVTLB_ASSERT_KNOWN_DRIVEN(sig, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_known_driven(sig)) /* novas s-2050 */
`else
   `define HQM_DEVTLB_ASSERT_KNOWN_DRIVEN(sig, rst) assert final(1)
`endif // INTEL_EMULATION

`define HQM_DEVTLB_ASSUME_KNOWN_DRIVEN(sig, clk, rst) \
   assume property(DEVTLB_p_known_driven(sig, clk, rst))

`define HQM_DEVTLB_COVER_KNOWN_DRIVEN(sig, clk ,rst) \
   cover property(DEVTLB_p_cover_known_driven(sig, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_KNOWN_DRIVEN_COVER(sig, clk ,rst) \
   cover property(p_not_known_driven_cover(sig, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_KNOWN_DRIVEN(name, sig, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_KNOWN_DRIVEN(sig, rst) MSG

`define HQM_DEVTLB_ASSUMEC_KNOWN_DRIVEN(name, sig, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_known_driven(sig)) MSG



`define HQM_DEVTLB_ASSUMES_KNOWN_DRIVEN(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_KNOWN_DRIVEN(sig, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_KNOWN_DRIVEN(name, sig, clk, rst, MSG) \
   name : assert property(DEVTLB_p_known_driven(sig, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_KNOWN_DRIVEN(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_KNOWN_DRIVEN(sig, clk ,rst) MSG

`define HQM_DEVTLB_COVERC_KNOWN_DRIVEN(name, sig, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_known_driven(sig)) MSG



`define HQM_DEVTLB_NOT_KNOWN_DRIVEN_COVERS(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_NOT_KNOWN_DRIVEN_COVER(sig, clk ,rst) MSG

`define HQM_DEVTLB_NOT_KNOWN_DRIVEN_COVERC(name, sig, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && !`HQM_DEVTLB_l_known_driven(sig)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   same
// Description:
//       The vectors have same value . The checker compares 2 input vectors.
// Arguments:
//       siga           - Bit-vector
//       sigb       - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

// `define DEVTLB_ASSERT_SAME(siga, sigb, rst) \
//   assert `DEVTLB_FINAL ( (|((rst | reset_INST))) | `DEVTLB_l_same(siga, sigb))

 `define HQM_DEVTLB_ASSERT_SAME(siga, sigb, rst) \
     assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_SVA_LIB_SAME(siga, sigb)) /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_SAME(siga, sigb, clk, rst) \
   assume property(DEVTLB_p_same(siga, sigb, clk, rst))

`define HQM_DEVTLB_COVER_SAME(siga, sigb, clk, rst)  \
   cover property(DEVTLB_p_cover_same(siga, sigb, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_SAME_COVER(siga, sigb, clk, rst)  \
   cover property(DEVTLB_p_not_same_cover(siga, sigb, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_SAME(name, siga, sigb, rst, MSG)\
   name: `HQM_DEVTLB_ASSERT_SAME(siga, sigb, rst) MSG

`define HQM_DEVTLB_ASSUMEC_SAME(name, siga, sigb, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_same(siga, sigb)) MSG



`define HQM_DEVTLB_ASSUMES_SAME(name, siga, sigb, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_SAME(siga, sigb, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_SAME(name, siga, sigb, clk, rst, MSG) \
   name : assert property(DEVTLB_p_same(siga, sigb, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_SAME(name, siga, sigb, clk, rst, MSG)  \
   name: `HQM_DEVTLB_COVER_SAME(siga, sigb, clk ,rst) MSG

`define HQM_DEVTLB_COVERC_SAME(name, siga, sigb, rst, MSG)  \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_same(siga, sigb)) MSG



`define HQM_DEVTLB_NOT_SAME_COVERS(name, siga, sigb, clk, rst, MSG) \
   name: `HQM_DEVTLB_NOT_SAME_COVER(siga, sigb, clk, rst) MSG

`define HQM_DEVTLB_NOT_SAME_COVERC(name, siga, sigb, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && !`HQM_DEVTLB_l_same(siga, sigb)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   must
// Description:
//       Formula 'prop' ia always true.
// Arguments:
//       Prop       - Property
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_MUST(prop, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_must(prop)) /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_MUST(prop, clk, rst) \
   assume property(DEVTLB_p_must(prop, clk, rst))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_MUST(name, prop, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_MUST(prop, rst) MSG

`define HQM_DEVTLB_ASSUMEC_MUST(name, prop, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_must(prop)) MSG



`define HQM_DEVTLB_ASSUMES_MUST(name, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_MUST(prop, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_MUST(name, prop, clk, rst, MSG) \
   name : assert property(DEVTLB_p_must(prop, clk, (rst | reset_INST))) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:  forbidden
// Description:
//       Condition 'cond' never occurs.
// Arguments:
//       cond       - Property
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_FORBIDDEN(cond, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_forbidden(cond)) /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_FORBIDDEN(cond, clk, rst) \
   assume property(DEVTLB_p_forbidden(cond, clk, rst))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_FORBIDDEN(name, cond, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_FORBIDDEN(cond, rst) MSG

`define HQM_DEVTLB_ASSUMEC_FORBIDDEN(name, cond, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_forbidden(cond)) MSG



`define HQM_DEVTLB_ASSUMES_FORBIDDEN(name, cond, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_FORBIDDEN(cond, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_FORBIDDEN(name, cond, clk, rst, MSG) \
   name : assert property(DEVTLB_p_forbidden(cond, clk, (rst | reset_INST))) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   min
// Description:
//        Sig's value equal of more then 'min_val'.
// Arguments:
//       sig        - Bit-vector
//       min_val        - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_MIN(sig, min_val, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_min_value(sig, min_val)) /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_MIN(sig, min_val, clk, rst) \
   assume property(DEVTLB_p_min_value(sig, min_val, clk, rst))

`define HQM_DEVTLB_COVER_MIN(sig, min_val, clk, rst) \
   cover property (DEVTLB_p_cover_min_value(sig, min_val, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_MIN_COVER(sig, min_val, clk, rst) \
   cover property(DEVTLB_p_not_min_value_cover(sig, min_val, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_MIN(name, sig, min_val, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_MIN(sig, min_val, rst) MSG

`define HQM_DEVTLB_ASSUMEC_MIN(name, sig, min_val, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_min_value(sig, min_val)) MSG



`define HQM_DEVTLB_ASSUMES_MIN(name, sig, min_val, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_MIN(sig, min_val, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_MIN(name, sig, min_val, clk, rst, MSG) \
   name: assert property(DEVTLB_p_min_value(sig, min_val, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_MIN(name, sig, min_val, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_MIN(sig, min_val, clk, rst) MSG

`define HQM_DEVTLB_COVERC_MIN(name, sig, min_val, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_min_value(sig, min_val)) MSG



`define HQM_DEVTLB_NOT_MIN_COVERS(name ,sig, min_val, clk, rst, MSG) \
   name: `HQM_DEVTLB_NOT_MIN_COVER(sig, min_val, clk, rst) MSG

`define HQM_DEVTLB_NOT_MIN_COVERC(name, sig, min_val, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_min_value(sig, min_val)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   max
// Description:
//      Sig's value equal or less then 'max_val'.
// Arguments:
//       sig             - Bit-vector
//       max_val         - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_MAX(sig, max_val, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_max_value(sig, max_val)) /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_MAX(sig, max_val, clk, rst) \
   assume property(DEVTLB_p_max_value(sig, max_val, clk, rst))

`define HQM_DEVTLB_COVER_MAX(sig, max_val, clk, rst) \
   cover property(DEVTLB_p_cover_max_value(sig, max_val, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_MAX_COVER(sig, max_val, clk, rst) \
   cover property(DEVTLB_p_not_max_value_cover(sig, max_val, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_MAX(name, sig, max_val, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_MAX(sig, max_val, rst) MSG

`define HQM_DEVTLB_ASSUMEC_MAX(name, sig, max_val, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_max_value(sig, max_val)) MSG



`define HQM_DEVTLB_ASSUMES_MAX(name, sig, max_val, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_MAX(sig, max_val, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_MAX(name, sig, max_val, clk, rst, MSG) \
   name: assert property(DEVTLB_p_max_value(sig, max_val, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_MAX(name, sig, max_val, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_MAX(sig, max_val, clk, rst) MSG

`define HQM_DEVTLB_COVERC_MAX(name, sig, max_val, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_max_value(sig, max_val)) MSG



`define HQM_DEVTLB_NOT_MAX_COVERS(name ,sig, max_val, clk, rst, MSG) \
   name: `HQM_DEVTLB_NOT_MAX_COVER(sig, max_val, clk, rst) MSG

`define HQM_DEVTLB_NOT_MAX_COVERC(name, sig, max_val, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_max_value(sig, max_val)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   at most bits low
// Description:
//       At most 'n' bits in sig are low.
// Arguments:
//       sig        - Bit-vector
//       n              - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_AT_MOST_BITS_LOW(sig, n, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_at_most_bits_low(sig, n)) /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_AT_MOST_BITS_LOW(sig, n, clk, rst) \
   assume property(DEVTLB_p_at_most_bits_low(sig, n, clk, rst))

`define HQM_DEVTLB_COVER_AT_MOST_BITS_LOW(sig, n, clk, rst) \
   cover property(DEVTLB_p_cover_at_most_bits_low(sig, n, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_AT_MOST_BITS_LOW_COVER(sig, n, clk, rst) \
   cover property(DEVTLB_p_not_at_most_bits_low_cover(sig, n, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_AT_MOST_BITS_LOW(name, sig, n, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_AT_MOST_BITS_LOW(sig, n, rst) MSG

`define HQM_DEVTLB_ASSUMEC_AT_MOST_BITS_LOW(name, sig, n, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_at_most_bits_low(sig, n)) MSG



`define HQM_DEVTLB_ASSUMES_AT_MOST_BITS_LOW(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_AT_MOST_BITS_LOW(sig, n, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_AT_MOST_BITS_LOW(name, sig, n, clk, rst, MSG) \
   name: assert property(DEVTLB_p_at_most_bits_low(sig, n, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_AT_MOST_BITS_LOW(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_AT_MOST_BITS_LOW(sig, n, clk, rst) MSG

`define HQM_DEVTLB_COVERC_AT_MOST_BITS_LOW(name, sig, n, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_at_most_bits_low(sig, n)) MSG



`define HQM_DEVTLB_NOT_AT_MOST_BITS_LOW_COVERS(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_NOT_AT_MOST_BITS_LOW_COVER(sig, n, clk, rst) MSG

`define HQM_DEVTLB_NOT_AT_MOST_BITS_LOW_COVERC(name ,sig, n, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && !`HQM_DEVTLB_l_at_most_bits_low(sig, n)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   bits low
// Description:
//       Exactly 'n' bits of sig are low (1 or x or z)
// Arguments:
//       sig        - Bit-vector
//       n              - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_BITS_LOW(sig, n, rst) \
   assert `HQM_DEVTLB_FINAL ( (|((rst | reset_INST))) | `HQM_DEVTLB_l_bits_low(sig, n)) /* novas s-2050 */

`define HQM_DEVTLB_ASSUME_BITS_LOW(sig, n, clk, rst) \
   assume property(DEVTLB_p_bits_low(sig, n, clk, rst))

`define HQM_DEVTLB_COVER_BITS_LOW(sig, n, clk, rst) \
   cover property(DEVTLB_p_cover_bits_low(sig, n, clk, (rst | reset_INST)))

`define HQM_DEVTLB_NOT_BITS_LOW_COVER(sig, n, clk, rst) \
   cover property(DEVTLB_p_not_bits_low_cover(sig, n, clk, (rst | reset_INST)))


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_BITS_LOW(name, sig, n, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_BITS_LOW(sig, n, rst) MSG

`define HQM_DEVTLB_ASSUMEC_BITS_LOW(name, sig, n, rst, MSG) \
   name: assume `HQM_DEVTLB_FINAL (rst || `HQM_DEVTLB_l_bits_low(sig, n)) MSG



`define HQM_DEVTLB_ASSUMES_BITS_LOW(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_BITS_LOW(sig, n, clk, rst) MSG

`define HQM_DEVTLB_ASSERTS_BITS_LOW(name, sig, n, clk, rst, MSG) \
   name: assert property(DEVTLB_p_bits_low(sig, n, clk, (rst | reset_INST))) MSG



`define HQM_DEVTLB_COVERS_BITS_LOW(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_BITS_LOW(sig, n, clk, rst) MSG

`define HQM_DEVTLB_COVERC_BITS_LOW(name, sig, n, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && `HQM_DEVTLB_l_bits_low(sig, n)) MSG



`define HQM_DEVTLB_NOT_BITS_LOW_COVERS(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_NOT_BITS_LOW_COVER(sig, n, clk, rst) MSG

`define HQM_DEVTLB_NOT_BITS_LOW_COVERC(name ,sig, n, rst, MSG) \
   name: cover `HQM_DEVTLB_FINAL (!(rst | reset_INST) && !`HQM_DEVTLB_l_bits_low(sig, n)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   fire
// Description:
//       Fire an Error message whenever it is reached
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_FIRE \
   assert `HQM_DEVTLB_FINAL (1'b0)


`ifndef DEVTLB_SVA_LIB_OLD_FORMAT


`define HQM_DEVTLB_ASSERTC_FIRE(name, MSG) \
   name: `HQM_DEVTLB_ASSERT_FIRE MSG

`endif

// ****************************************************************************************** //





// --- --- --- Concurent Templates --- --- --- //




// ****************************************************************************************** //
// Name:   trigger
// Description:
//    If sequence 'trig' occurs, then property 'prop' must hold at the completion of that
//    sequence.
//    Can also be used for simple Boolean implication, i.e. if Boolean 'b1' holds, then
//    Boolean 'b2' holds as well.
// Arguments:
//       trig       - Sequence
//       prop           - Property
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_TRIGGER(trig, prop, clk, rst) \
   assert property(DEVTLB_p_trigger(trig, prop, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_TRIGGER(trig, prop, clk, rst) \
   assume property(DEVTLB_p_trigger(trig, prop, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_TRIGGER(name, trig, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_TRIGGER(trig, prop, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_TRIGGER(name, trig, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_TRIGGER(trig, prop, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   delayed trigger
// Description:
//    If sequence 'trig' is satisfied, then property 'prop' must be satisfied 'delay' clock
//    ticks after the completion of 'trig'. Can also be used for simple Boolean implication,
//    i.e. if Boolean 'b1' holds, then after 'delay' clock ticks Boolean 'b2' holds as well
// Arguments:
//       trig       - Sequence
//       delay          - Integer
//       prop           - Property
// Comments:
//    When 'delay' is equal to 0, this template is equivalent to trigger
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_DELAYED_TRIGGER(trig, delay, prop, clk, rst) \
   assert property(DEVTLB_p_delayed_trigger(trig, delay, prop, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_DELAYED_TRIGGER(trig, delay, prop, clk, rst) \
   assume property(DEVTLB_p_delayed_trigger(trig, delay, prop, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(name, trig, delay, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_DELAYED_TRIGGER(trig, delay, prop, clk, rst)  MSG

`define HQM_DEVTLB_ASSUMES_DELAYED_TRIGGER(name, trig, delay, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_DELAYED_TRIGGER(trig, delay, prop, clk, rst)  MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   never
// Description:
//       Property 'prop' never holds
// Arguments:
//       prop       - Property
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_NEVER(prop, clk, rst) \
   assert property(DEVTLB_p_never(prop, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_NEVER(prop, clk, rst) \
   assume property(DEVTLB_p_never(prop, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_NEVER(name, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_NEVER(prop, clk, rst)  MSG

`define HQM_DEVTLB_ASSUMES_NEVER(name, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_NEVER(prop, clk, rst)  MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   eventually holds
// Description:
//       Once 'en' is high, formula 'prop' eventually holds. There is no time bound.
//       The property is violated if 'prop' never holds
// Arguments:
//       en     - Boolean
//       prop           - Property
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_EVENTUALLY_HOLDS(en, prop, clk, rst) \
   assert property(DEVTLB_p_eventually_holds(en, prop, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_EVENTUALLY_HOLDS(en, prop, clk, rst) \
   assume property(DEVTLB_p_eventually_holds(en, prop, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_EVENTUALLY_HOLDS(name, en, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_EVENTUALLY_HOLDS(en, prop, clk, rst)  MSG

`define HQM_DEVTLB_ASSUMES_EVENTUALLY_HOLDS(name, en, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_EVENTUALLY_HOLDS(en, prop, clk, rst)  MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   between
// Description:
//       'cond' holds at every sampling point between the two events 'start_ev' and 'end_ev'.
//       The end event may never occur, in which case 'cond' continues to hold forever
// Arguments:
//       start_ev       - Sequence
//       end_ev     - Boolean
//       cond           - Boolean
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_BETWEEN(start_ev, end_ev, cond, clk, rst) \
   assert property(DEVTLB_p_between(start_ev, end_ev, cond, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_BETWEEN(start_ev, end_ev, cond, clk, rst) \
   assume property(DEVTLB_p_between(start_ev, end_ev, cond, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_BETWEEN(name, start_ev, end_ev, cond, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_BETWEEN(start_ev, end_ev, cond, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_BETWEEN(name, start_ev, end_ev, cond, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_BETWEEN(start_ev, end_ev, cond, clk, rst)  MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   between time
// Description:
//        After triggering the event 'trig', 'cond' holds continuously starting at time
//        'start_time' until time 'end_time' (inclusive). Start time 0 is at the last tick
//        of the event 'trig' (or simply at 'trig' if it is a Boolean).
//        Start time 1 is a tick after 'trig' etc.
// Arguments:
//       trig       - Sequence
//       start_time     - Integer
//       end_time       - Integer
//       cond           - Boolean
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_BETWEEN_TIME(trig, start_time, end_time, cond, clk, rst) \
   assert property(DEVTLB_p_between_time(trig, start_time, end_time, cond, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_BETWEEN_TIME(trig, start_time, end_time, cond, clk, rst) \
   assume property(DEVTLB_p_between_time(trig, start_time, end_time, cond, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_BETWEEN_TIME(name, trig, start_time, end_time, cond, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_BETWEEN_TIME(trig, start_time, end_time, cond, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_BETWEEN_TIME(name, trig, start_time, end_time, cond, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_BETWEEN_TIME(trig, start_time, end_time, cond, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   next event
// Description:
//      If 'en' is high, then the next time that formula 'ev' holds, formula 'prop' must hold
//      at that point as well. 'ev' may never hold.
// Arguments:
//       en     - Boolean
//       ev             - Formula
//       prop           - Formula
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_NEXT_EVENT(en, ev, prop, clk, rst) \
   assert property(DEVTLB_p_next_event(en, ev, prop, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_NEXT_EVENT(en, ev, prop, clk, rst) \
   assume property(DEVTLB_p_next_event(en, ev, prop, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_NEXT_EVENT(name, en, ev, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_NEXT_EVENT(en, ev, prop, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_NEXT_EVENT(name, en, ev, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_NEXT_EVENT(en, ev, prop, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   before event
// Description:
//      Whenever 'en' holds, formula 'first' must hold before formula 'second'. The earliest
//     'second' can hold is one cycle after 'first' holds. 'first' is not required to hold,
//     in which case 'second' should never hold.
// Arguments:
//       en     - Boolean
//       first          - Formula
//       second         - Formula
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_BEFORE_EVENT(en, first, second, clk, rst) \
   assert property(DEVTLB_p_before_event(en, first, second, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_BEFORE_EVENT(en, first, second, clk, rst) \
   assume property(DEVTLB_p_before_event(en, first, second, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_BEFORE_EVENT(name, en, first, second, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_BEFORE_EVENT(en, first, second, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_BEFORE_EVENT(name, en, first, second, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_BEFORE_EVENT(en, first, second, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   remain high
// Description:
//    Whenever 'sig' rises, it remains high for 'n' additional clocks. The number of clocks 'n'
//    does not include the clock at which 'sig' changed. 'sig' must also be high at the 'n'th
//    tick point. Values of 'sig' are only sampled at the clock ticks and not between the
//    clock ticks.
// Arguments:
//       sig            - Bit-vector
//       n      - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_REMAIN_HIGH(sig, n, clk, rst) \
   assert property(DEVTLB_p_remain_high(sig, n, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_REMAIN_HIGH(sig, n, clk, rst) \
   assume property(DEVTLB_p_remain_high(sig, n, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_REMAIN_HIGH(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_REMAIN_HIGH(sig, n, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_REMAIN_HIGH(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_REMAIN_HIGH(sig, n, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   gremain high
// Description:
//    Whenever 'sig' rises, it remains high for 'n' additional clocks. The number of clocks 'n'
//    does not include the clock at which sig changed. 'sig' must also be high at the 'n'th tick
//    point.
//    Values of sig are also checked between the clock ticks.
// Arguments:
//       sig            - Bit-vector
//       n      - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_GREMAIN_HIGH(sig, n, clk, rst) \
   assert property(DEVTLB_p_gremain_high(sig, n, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_GREMAIN_HIGH(sig, n, clk, rst) \
   assume property(DEVTLB_p_gremain_high(sig, n, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_GREMAIN_HIGH(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_GREMAIN_HIGH(sig, n, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_GREMAIN_HIGH(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_GREMAIN_HIGH(sig, n, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   remain low
// Description:
//    Whenever 'sig' falls, it remains low for 'n' additional clocks.
//    The number of clocks 'n' does not include the clock at which 'sig' changed.
//    'Sig' must also be low at the 'n'th tick point.
//    Values of 'sig' are only sampled at the clock ticks and not between the clock ticks.
// Arguments:
//       sig            - Bit-vector
//       n      - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_REMAIN_LOW(sig, n, clk, rst) \
   assert property(DEVTLB_p_remain_low(sig, n, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_REMAIN_LOW(sig, n, clk, rst) \
   assume property(DEVTLB_p_remain_low(sig, n, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_REMAIN_LOW(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_REMAIN_LOW(sig, n, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_REMAIN_LOW(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_REMAIN_LOW(sig, n, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   gremain low
// Description:
//    Whenever 'sig' falls, it remains low for 'n' additional clocks.The number of clocks' n'
//    does not include the clock at which 'sig' changed.'Sig' must also be low at the 'n'th
//    tick point.
//    Values of sig are also checked between the clock ticks.
// Arguments:
//       sig            - Bit-vector
//       n      - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_GREMAIN_LOW(sig, n, clk, rst) \
   assert property(DEVTLB_p_gremain_low(sig, n, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_GREMAIN_LOW(sig, n, clk, rst) \
   assume property(DEVTLB_p_gremain_low(sig, n, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_GREMAIN_LOW(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_GREMAIN_LOW(sig, n, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_GREMAIN_LOW(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_GREMAIN_LOW(sig, n, clk, rst) MSG

`endif

// ****************************************************************************************** //




// --- --- ---




// ****************************************************************************************** //
// Name:   remain_high_at_most
// Description:
//       One request 'req' is asserted it will be granted (gnt) in at most n cycles.
// Arguments:
//       req        - Formula
//       n              - Integer
//       gnt            - Formula
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_REMAIN_HIGH_AT_MOST(req, n, gnt, clk, rst) \
   assert property(DEVTLB_p_remain_high_at_most(req, n, gnt, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_REMAIN_HIGH_AT_MOST(req, n, gnt, clk, rst) \
   assume property(DEVTLB_p_remain_high_at_most(req, n, gnt, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_REMAIN_HIGH_AT_MOST(name, req, n, gnt, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_REMAIN_HIGH_AT_MOST(req, n, gnt, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_REMAIN_HIGH_AT_MOST(name, req, n, gnt, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_REMAIN_HIGH_AT_MOST(req, n, gnt, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   verify
// Description:
//       Property prop is always true
// Arguments:
//       prop       - Property
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_VERIFY(prop, clk, rst) \
   assert property(DEVTLB_p_verify(prop, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_VERIFY(prop, clk, rst) \
   assume property(DEVTLB_p_verify(prop, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_VERIFY(name, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_VERIFY(prop, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_VERIFY(name, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_VERIFY(prop, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   req granted
// Description:
//    A request is eventually granted. The request does not need to remain pending until it
//    is granted (use CONT_REQ_GRANTED for that). There is no explicit bound by which the
//    request must be granted
// Arguments:
//       reg        - Boolean
//       gnt            - Formula
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_REQ_GRANTED(req, gnt, clk, rst) \
   assert property(DEVTLB_p_req_granted(req, gnt, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_REQ_GRANTED(req, gnt, clk, rst) \
   assume property(DEVTLB_p_req_granted(req, gnt, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_REQ_GRANTED(name, req, gnt, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_REQ_GRANTED(req, gnt, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_REQ_GRANTED(name, req, gnt, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_REQ_GRANTED(req, gnt, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   cont request granted
// Description:
//       A continuous request (one that is continuously pending) is eventually granted
// Arguments:
//       req        - Formula
//       gnt            - Formula
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_CONT_REQ_GRANTED(req, gnt, clk, rst) \
   assert property(DEVTLB_p_cont_req_granted(req, gnt, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_CONT_REQ_GRANTED(req, gnt, clk, rst) \
   assume property(DEVTLB_p_cont_req_granted(req, gnt, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_CONT_REQ_GRANTED(name, req, gnt, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_CONT_REQ_GRANTED(req, gnt, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_CONT_REQ_GRANTED(name, req, gnt, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_CONT_REQ_GRANTED(req, gnt, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   request granted within
// Description:
//       A request is granted at some sampling point between (and including) the m-th and n-th
//       sampling points after the current point (that is, within 'm' to 'n' clocks).
//       The request does not need to remain pending until it is granted.
// Arguments:
//       req            - Formula
//       min        - Integer
//       max            - Integer
//       gnt            - Formula
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_REQ_GRANTED_WITHIN(req, min, max, gnt, clk, rst) \
   assert property(DEVTLB_p_req_granted_within(req, min, max, gnt, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_REQ_GRANTED_WITHIN(req, min, max, gnt, clk, rst) \
   assume property(DEVTLB_p_req_granted_within(req, min, max, gnt, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_REQ_GRANTED_WITHIN(name, req, min, max, gnt, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_REQ_GRANTED_WITHIN(req, min, max, gnt, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_REQ_GRANTED_WITHIN(name, req, min, max, gnt, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_REQ_GRANTED_WITHIN(req, min, max, gnt, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   until strong
// Description:
//       Whenever 'start_ev' is high, formula 'cond' must hold until 'end_ev' holds.
//       Formula 'end_ev' must eventually hold. Formula 'cond' is not required to hold at the
//       time 'end_ev' holds
// Arguments:
//       start_ev       - Formula
//       cond       - Formula
//       start_ev       - Formula
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_UNTIL_STRONG(start_ev, cond, end_ev, clk, rst) \
   assert property(DEVTLB_p_until_strong(start_ev, cond, end_ev, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_UNTIL_STRONG(start_ev, cond, end_ev, clk, rst) \
   assume property(DEVTLB_p_until_strong(start_ev, cond, end_ev, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_UNTIL_STRONG(name, start_ev, cond, end_ev, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_UNTIL_STRONG(start_ev, cond, end_ev, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_UNTIL_STRONG(name, start_ev, cond, end_ev, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_UNTIL_STRONG(start_ev, cond, end_ev, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   fsm never stuck
// Description:
//       If "state" changes, it must not remain stuck among the values specified in "set"
// Arguments:
//       state          - Bit-vector
//       Set        - Set of integers
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_FSM_NEVER_STUCK(state, values, clk, rst) \
   assert property(p_fsm_never_stuck(state, values, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_FSM_NEVER_STUCK(state, values, clk, rst) \
   assume property(p_fsm_never_stuck(state, values, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_FSM_NEVER_STUCK(name, state, values, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_FSM_NEVER_STUCK(state, values, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_FSM_NEVER_STUCK(name, state, values, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_FSM_NEVER_STUCK(state, values, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   recur triggers
// Description:
//       The Boolean 'cond' must hold after at most 'n' repetitions of the event 'trig'.
//       That is, the 'n'-th next time event 'event' occurs without 'cond' being satisfied,
//      'cond' must be satisfied at the completion of that event
// Arguments:
//       trig           - Formula
//       n      - Integer
//       cond           - Boolean
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_RECUR_TRIGGERS(trig, n, cond, clk, rst) \
   assert property(DEVTLB_p_recur_triggers(trig, n, cond, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_RECUR_TRIGGERS(trig, n, cond, clk, rst) \
   assume property(DEVTLB_p_recur_triggers(trig, n, cond, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_RECUR_TRIGGERS(name, trig, n, cond, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_RECUR_TRIGGERS(trig, n, cond, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_RECUR_TRIGGERS(name, trig, n, cond, clk, rst, MSG) \
    name: `HQM_DEVTLB_ASSUME_RECUR_TRIGGERS(trig, n, cond, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   data transfer
// Description:
//       Data is transferred correctly from 'start_ev' to 'end_ev'. That is, 'start_data'
//       when 'start_ev' holds must be equal to 'end_data' when 'end_ev' holds. If 'start_ev'
//       holds multiple times before 'end_ev' holds, the value of 'start_data' at the
//       occurrence of last 'start_ev' must match 'end_data' when 'end_ev' holds.
// Arguments:
//       start_ev       - Formula
//       start_data     - Bit-vector
//       end_ev     - Formula
//       end_data       - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_DATA_TRANSFER(start_ev, start_data, end_ev, end_data, clk, rst) \
   assert property(DEVTLB_p_data_transfer(start_ev, start_data, end_ev, end_data, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_DATA_TRANSFER(start_ev, start_data, end_ev, end_data, clk, rst) \
   assume property(DEVTLB_p_data_transfer(start_ev, start_data, end_ev, end_data, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_DATA_TRANSFER(name, start_ev, start_data, end_ev, end_data, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_DATA_TRANSFER(start_ev, start_data, end_ev, end_data, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_DATA_TRANSFER(name, start_ev, start_data, end_ev, end_data, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_DATA_TRANSFER(start_ev, start_data, end_ev, end_data, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
/// Name:   gray code
// Description:
//    At most one bit in Signal sig changes between every two consecutive clock ticks.
// Arguments:
//       sig        - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_GRAY_CODE(sig, clk, rst) \
   assert property(DEVTLB_p_gray_code(sig, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_GRAY_CODE(sig, clk, rst) \
   assume property(DEVTLB_p_gray_code(sig, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_GRAY_CODE(name, sig, clk, rst, MSG) \
   `ifdef DC                                        \
   `elsif FEV_WORKAROUND_FOR_CONCURRENT             \
      wire \glitch_hack_``name  ;                   \
      assign \glitch_hack_``name  = |sig;           \
   `elsif INTEL_EMULATION                                 \
      name: `HQM_DEVTLB_ASSERT_GRAY_CODE(sig, clk, rst) MSG    \
   `else                                            \
      name: `HQM_DEVTLB_ASSERT_GRAY_CODE(sig, clk, rst) MSG    \
   `endif

`define HQM_DEVTLB_ASSUMES_GRAY_CODE(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_GRAY_CODE(sig, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   clock ticking
// Description:
//    The clock 'clock' is ticking. The clock is only required to tick repeatedly. There is no
//    specific pattern the clock is required to follow.
//
// Arguments:
//       clock      - Boolean
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_CLOCK_TICKING(clk) \
   assert property(DEVTLB_p_clock_ticking(clk))

`define HQM_DEVTLB_ASSUME_CLOCK_TICKING(clk) \
   assume property(DEVTLB_p_clock_ticking(clk))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_CLOCK_TICKING(name, clk, MSG) \
   name: assert property(DEVTLB_p_clock_ticking(clk)) MSG

`define HQM_DEVTLB_ASSUMES_CLOCK_TICKING(name, clk, MSG) \
   name: assume property(DEVTLB_p_clock_ticking(clk)) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   cover
// Description:
//       Cover a sequence.
// Arguments:
//       seq        - Event
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_COVER(seq, clk, rst) \
   cover property(DEVTLB_p_cov_seq(seq, clk, (rst | reset_INST)))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_COVERS(name, seq, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER(seq, clk, rst) MSG

`endif

// ****************************************************************************************** //
// Name:   cover trigger
// Description:
//       Cover a sequence.
// Arguments:
//       seq1 |-> seq2      - Event
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_COVER_TRIGGER(trig, prop, clk, rst) \
   cover property(DEVTLB_p_trigger(trig, prop, clk, (rst | reset_INST)))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_COVERS_TRIGGER(name, trig, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_TRIGGER(trig, prop, clk, rst) MSG

`endif

// ****************************************************************************************** //
// Name:   cover delayed trigger 
// Description:
//       Cover a sequence.
// Arguments:
//       seq1 |-> ##delay seq2      - Event
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_COVER_DELAYED_TRIGGER(trig, delay, prop, clk, rst) \
   cover property(DEVTLB_p_delayed_trigger(trig, delay, prop, clk, (rst | reset_INST)))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_COVERS_DELAYED_TRIGGER(name, trig, delay, prop, clk, rst, MSG) \
   name: `HQM_DEVTLB_COVER_DELAYED_TRIGGER(trig, delay, prop, clk, rst) MSG

`endif

// ****************************************************************************************** //


// --- --- --- Stability Templates --- --- --- //



// ****************************************************************************************** //
// Name:  stable
// Description:
//    Signal 'sig' is stable between the two events 'start_ev' and 'end_ev'.
//    The value of 'sig' at the clock at which 'start_ev' happens must not
//    change until the condition 'end_ev' happens.
// Arguments:
//       sig        - Bit-vector
//       start_ev       - Formula
//       end_ev         - Formula
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_STABLE(sig, start_ev, end_ev, clk, rst) \
   assert property(DEVTLB_p_stable(sig, start_ev, end_ev, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_STABLE(sig, start_ev, end_ev, clk, rst) \
   assume property(DEVTLB_p_stable(sig, start_ev, end_ev, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_STABLE(name, sig, start_ev, end_ev, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_STABLE(sig, start_ev, end_ev, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_STABLE(name, sig, start_ev, end_ev, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_STABLE(sig, start_ev, end_ev, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:  gstable
// Description:
//    Signal 'sig' is stable between the two events (sequences): 'start_ev' and 'end_ev'.
//    The value of 'sig' at the clock at which 'start_ev' completes must not change until
//    the completion of the first cycle of 'end_ev' (including event 'end_ev' if 'end_ev'
//    is a plain signal).
//    'Sig' must be stable between the clock ticks as well.
// Arguments:
//       sig        - Bit-vector
//       start_ev       - Formula
//       end_ev         - Formula
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_GSTABLE(sig, start_ev, end_ev, clk, rst) \
   assert property(DEVTLB_p_gstable_ev(sig, start_ev, end_ev, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_GSTABLE(sig, start_ev, end_ev, clk, rst) \
   assume property(DEVTLB_p_gstable_ev(sig, start_ev, end_ev, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_GSTABLE(name, sig, start_ev, end_ev, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_GSTABLE(sig, start_ev, end_ev, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_GSTABLE(name, sig, start_ev, end_ev, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_GSTABLE(sig, start_ev, end_ev, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:  stable posedge
// Description:
//    Signal 'sig' is stable between the two events (sequences): 'start_ev' and 'end_ev' at
//    posedge clk ticks. The value of 'sig' at the clock at which 'start_ev' completes must not
//    change until the completion of the first cycle of 'end_ev' (including event 'end_ev' if
//    'end_ev' is a plain signal).
//    'Sig' must be stable between the clock ticks as well.
// Arguments:
//       sig            - Bit-vector
//       start_ev       - Formula
//       end_ev         - Formula
//
// ------------------------------------------------------------------------------------------ //

`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

`define HQM_DEVTLB_ASSERT_STABLE_POSEDGE(sig, start_ev, end_ev, clk, rst) \
   `HQM_DEVTLB_ASSERT_GSTABLE(sig, start_ev, end_ev, posedge (clk), rst)

`define HQM_DEVTLB_ASSUME_STABLE_POSEDGE(sig, start_ev, end_ev, clk, rst) \
   `HQM_DEVTLB_ASSUME_GSTABLE(sig, start_ev, end_ev, posedge (clk), rst)

`else

`define HQM_DEVTLB_ASSERT_STABLE_POSEDGE(sig, start_ev, end_ev, clk, rst) \
   assert property(DEVTLB_p_gstable_sig(sig, start_ev, end_ev, $rose(clk), (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_STABLE_POSEDGE(sig, start_ev, end_ev, clk, rst) \
   assume property(DEVTLB_p_gstable_sig(sig, start_ev, end_ev, $rose(clk), rst))

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:  stable negedge
// Description:
//    Signal 'sig' is stable between the two events (sequences): 'start_ev' and 'end_ev' at
//    negedge clk ticks. The value of 'sig' at the clock at which 'start_ev' completes must not
//    change until the completion of the first cycle of 'end_ev' (including event 'end_ev' if
//    'end_ev' is a plain signal).
//    'Sig' must be stable between the clock ticks as well.
// Arguments:
//       sig            - Bit-vector
//       start_ev       - Formula
//       end_ev         - Formula
//
// ------------------------------------------------------------------------------------------ //

`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

`define HQM_DEVTLB_ASSERT_STABLE_NEGEDGE(sig, start_ev, end_ev, clk, rst) \
   `HQM_DEVTLB_ASSERT_GSTABLE(sig, start_ev, end_ev, negedge (clk), rst) \

`define HQM_DEVTLB_ASSUME_STABLE_NEGEDGE(sig, start_ev, end_ev, clk, rst) \
   `HQM_DEVTLB_ASSERT_GSTABLE(sig, start_ev, end_ev, negedge (clk), rst) \

`else

`define HQM_DEVTLB_ASSERT_STABLE_NEGEDGE(sig, start_ev, end_ev, clk, rst) \
   assert property(DEVTLB_p_gstable_sig(sig, start_ev, end_ev, $fell(clk), (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_STABLE_NEGEDGE(sig, start_ev, end_ev, clk, rst) \
   assume property(DEVTLB_p_gstable_sig(sig, start_ev, end_ev, $fell(clk), rst))

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:  stable edge
// Description:
//    Signal 'sig' is stable between the two events (sequences): 'start_ev' and 'end_ev' at
//    edge clk ticks. The value of 'sig' at the clock at which 'start_ev' completes must not
//    change until the completion of the first cycle of 'end_ev' (including event 'end_ev' if
//    'end_ev' is a plain signal).
//    'Sig' must be stable between the clock ticks as well.
// Arguments:
//       sig            - Bit-vector
//       start_ev       - Formula
//       end_ev         - Formula
//
// ------------------------------------------------------------------------------------------ //

`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

`define HQM_DEVTLB_ASSERT_STABLE_EDGE(sig, start_ev, end_ev, clk, rst) \
   `HQM_DEVTLB_ASSERT_GSTABLE(sig, start_ev, end_ev, clk, rst) \

`define HQM_DEVTLB_ASSUME_STABLE_EDGE(sig, start_ev, end_ev, clk, rst) \
   `HQM_DEVTLB_ASSERT_GSTABLE(sig, start_ev, end_ev, clk, rst) \

`else

`define HQM_DEVTLB_ASSERT_STABLE_EDGE(sig, start_ev, end_ev, clk, rst) \
   assert property(DEVTLB_p_gstable_sig(sig, start_ev, end_ev, $changed(clk), (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_STABLE_EDGE(sig, start_ev, end_ev, clk, rst) \
   assume property(DEVTLB_p_gstable_sig(sig, start_ev, end_ev, $changed(clk), rst))

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:  stable window
// Description:
//    Whenever 'sample' is high, 'sig' must keep its value for 'clks_after' additional clocks
//    after the sampling point, and 'clks_before' clocks before the sampling point.
//    'Sig' is not required to be stable between the clock ticks.
// Arguments:
//       sample         - Signal
//       sig        - Bit-vector
//       clks_before    - Integer
//       clks_after     - Integer
//
// ------------------------------------------------------------------------------------------ //

`ifndef INTEL_EMULATION
`define HQM_DEVTLB_ASSERT_STABLE_WINDOW(sample, sig, clks_before, clks_after, clk, rst) \
   assert property(DEVTLB_p_stable_window(sample, sig, clks_before, clks_after, clk, (rst | reset_INST)))
`else
`define HQM_DEVTLB_ASSERT_STABLE_WINDOW(sample, sig, clks_before, clks_after, clk, rst) \
   assert final(1)
`endif // INTEL_EMULATION

`define HQM_DEVTLB_ASSUME_STABLE_WINDOW(sample, sig, clks_before, clks_after, clk, rst) \
   assume property(DEVTLB_p_stable_window(sample, sig, clks_before, clks_after, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_STABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_STABLE_WINDOW(sample, sig, clks_before, clks_after, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_STABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_STABLE_WINDOW(sample, sig, clks_before, clks_after, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
//
// Name:  gstable window
// Description:
//    Whenever 'sample' is high, 'sig' must be stable 'clks_after' additional clocks (including)
//    after the sampling point and 'clks_before' clocks (not including) before the sampling point.
//    'sig' must be stable between the clock ticks as well.
// Arguments:
//       sample         - Signal
//       sig        - Bit-vector
//       clks_before    - Integer
//       clks_after     - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_GSTABLE_WINDOW(sample, sig, clks_before, clks_after, clk, rst) \
   assert property(DEVTLB_p_gstable_window(sample, sig, clks_before, clks_after, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_GSTABLE_WINDOW(sample, sig, clks_before, clks_after, clk, rst) \
   assume property(DEVTLB_p_gstable_window(sample, sig, clks_before, clks_after, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_GSTABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_GSTABLE_WINDOW(sample, sig, clks_before, clks_after, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_GSTABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_GSTABLE_WINDOW(sample, sig, clks_before, clks_after, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:  stable for
// Description:
//    Whenever 'sig' changes, it must keep its value for 'n' additional clocks. The number of
//    clocks 'n' does not include the clock at which 'sig' changed. 'sig' must be stable at
//    the 'n'th tick point. Values of 'sig' are only sampled at the ticks of clk.
// Arguments:
//       sig            - Bit-vector
//       n      - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_STABLE_FOR(sig, n, clk, rst) \
   assert property(DEVTLB_p_stable_for(sig, n, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_STABLE_FOR(sig, n, clk, rst) \
   assume property(DEVTLB_p_stable_for(sig, n, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_STABLE_FOR(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_STABLE_FOR(sig, n, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_STABLE_FOR(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_STABLE_FOR(sig, n, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
//
// Name:  gstable for
// Description:
//    Whenever 'sig' changes, it must keep its value for 'n' additional clocks. The number of
//    clocks 'n' does not include the clock at which 'sig' changed. 'sig' must be stable at
//    the 'n'th tick point. The change of 'sig' should be from one clock tick to another.
//    However, 'sig' is required to be stable at all times during the 'n' clock ticks, even
//    at the non-tick points of the clock.
// Arguments:
//       sig            - Bit-vector
//       n      - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_GSTABLE_FOR(sig, n, clk, rst) \
   assert property(DEVTLB_p_gstable_for(sig, n, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_GSTABLE_FOR(sig, n, clk, rst) \
   assume property(DEVTLB_p_gstable_for(sig, n, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_GSTABLE_FOR(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_GSTABLE_FOR(sig, n, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_GSTABLE_FOR(name, sig, n, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_GSTABLE_FOR(sig, n, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   stable after
// Description:
//    Whenever 'sample' is high, 'sig' must keep its value for 'clks_after' additional clocks
//    after the sampling point. The behavior of 'sig' between the clock ticks is not checked.
// Arguments:
//       sample         - Signal
//       sig        - Bit-vector
//       clks_before    - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_STABLE_AFTER(sample, sig, clks_after, clk, rst) \
   assert property(DEVTLB_p_stable_after(sample, sig, clks_after, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_STABLE_AFTER(sample, sig, clks_after, clk, rst) \
   assume property(DEVTLB_p_stable_after(sample, sig, clks_after, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_STABLE_AFTER(name, sample, sig, clks_after, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_STABLE_AFTER(sample, sig, clks_after, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_STABLE_AFTER(name, sample, sig, clks_after, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_STABLE_AFTER(sample, sig, clks_after, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:    gstable_after
// Description:
//    Whenever 'sample' is high, 'sig' must keep its value for 'clks_after' additional clocks
//    after the sampling point.
//    The behavior of 'sig' is also checked between the clock ticks.
// Arguments:
//       sample         - Signal
//       sig        - Bit-vector
//       clks_before    - Integer
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_GSTABLE_AFTER(sample, sig, clks_after, clk, rst) \
   assert property(DEVTLB_p_gstable_after(sample, sig, clks_after, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_GSTABLE_AFTER(sample, sig, clks_after, clk, rst) \
   assume property(DEVTLB_p_gstable_after(sample, sig, clks_after, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_GSTABLE_AFTER(name, sample, sig, clks_after, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_GSTABLE_AFTER(sample, sig, clks_after, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_GSTABLE_AFTER(name, sample, sig, clks_after, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_GSTABLE_AFTER(sample, sig, clks_after, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
//
// Name:  stable between ticks
// Description:
//    Signal 'sig' is stable between every two clock ticks: the value of 'sig' can only change
//    at a clock tick.
// Arguments:
//       sig            - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_STABLE_BETWEEN_TICKS(sig, clk, rst) \
   assert property(DEVTLB_p_stable_between_ticks(sig, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_STABLE_BETWEEN_TICKS(sig, clk, rst) \
   assume property(DEVTLB_p_stable_between_ticks(sig, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_STABLE_BETWEEN_TICKS(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_STABLE_BETWEEN_TICKS(sig, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_STABLE_BETWEEN_TICKS(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_STABLE_BETWEEN_TICKS(sig, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
//
// Name:  gstable between ticks
// Description:
//    Signal 'sig' is stable between every two clock ticks: the value of 'sig' can only change
//    at a clock tick.
//    'Sig' must be stable between the clock ticks as well.
// Arguments:
//       sig        - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

`define HQM_DEVTLB_ASSERT_GSTABLE_BETWEEN_TICKS(sig, clk, rst) \
   assert property(DEVTLB_p_gstable_between_ticks_ev(sig, clk, (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_GSTABLE_BETWEEN_TICKS(sig, clk, rst) \
   assume property(DEVTLB_p_gstable_between_ticks_ev(sig, clk, rst))

`ifndef DEVTLB_SVA_LIB_OLD_FORMAT

`define HQM_DEVTLB_ASSERTS_GSTABLE_BETWEEN_TICKS(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSERT_GSTABLE_BETWEEN_TICKS(sig, clk, rst) MSG

`define HQM_DEVTLB_ASSUMES_GSTABLE_BETWEEN_TICKS(name, sig, clk, rst, MSG) \
   name: `HQM_DEVTLB_ASSUME_STABLE_BETWEEN_TICKS(sig, clk, rst) MSG

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
//
// Name:  gstable between ticks posedge
// Description:
//    Signal 'sig' is stable between every two posedge clock ticks: the value of 'sig' can
//    only change at a clock tick.
//    'Sig' must be stable between the clock ticks as well.
// Arguments:
//       sig        - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

`define HQM_DEVTLB_ASSERT_STABLE_BETWEEN_TICKS_POSEDGE(sig, clk, rst) \
   `HQM_DEVTLB_ASSERT_GSTABLE_BETWEEN_TICKS(sig, posedge (clk), rst)

`define HQM_DEVTLB_ASSUME_STABLE_BETWEEN_TICKS_POSEDGE(sig, clk, rst) \
   `HQM_DEVTLB_ASSUME_GSTABLE_BETWEEN_TICKS(sig, posedge (clk), rst)

`else

`define HQM_DEVTLB_ASSERT_STABLE_BETWEEN_TICKS_POSEDGE(sig, clk, rst) \
   assert property(DEVTLB_p_gstable_between_ticks_sig(sig, $rose(clk), (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_STABLE_BETWEEN_TICKS_POSEDGE(sig, clk, rst) \
   assume property(DEVTLB_p_gstable_between_ticks_sig(sig, $rose(clk), rst))

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
//
// Name:  gstable between ticks negedge
// Description:
//    Signal 'sig' is stable between every two negedge clock ticks: the value of 'sig' can only
//    change at a clock tick.
//    'Sig' must be stable between the clock ticks as well.
// Arguments:
//       sig             - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

`define HQM_DEVTLB_ASSERT_STABLE_BETWEEN_TICKS_NEGEDGE(sig, clk, rst) \
   `HQM_DEVTLB_ASSERT_GSTABLE_BETWEEN_TICKS(sig, negedge (clk), rst)

`define HQM_DEVTLB_ASSUME_STABLE_BETWEEN_TICKS_NEGEDGE(sig, clk, rst) \
   `HQM_DEVTLB_ASSUME_GSTABLE_BETWEEN_TICKS(sig, negedge (clk), rst)

`else

`define HQM_DEVTLB_ASSERT_STABLE_BETWEEN_TICKS_NEGEDGE(sig, clk, rst) \
   assert property(DEVTLB_p_gstable_between_ticks_sig(sig, $fell(clk), (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_STABLE_BETWEEN_TICKS_NEGEDGE(sig, clk, rst) \
   assume property(DEVTLB_p_gstable_between_ticks_sig(sig, $fell(clk), rst))

`endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
//
// Name:  gstable between ticks edge
// Description:
//    Signal 'sig' is stable between every two edge clock ticks: the value of 'sig' can only
//    change at a clock tick. 'Sig' is also checked between clock ticks.
// Arguments:
//       sig        - Bit-vector
//
// ------------------------------------------------------------------------------------------ //

`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

`define HQM_DEVTLB_ASSERT_STABLE_BETWEEN_TICKS_EDGE(sig, clk, rst) \
   `HQM_DEVTLB_ASSERT_GSTABLE_BETWEEN_TICKS(sig, clk, rst)

`define HQM_DEVTLB_ASSUME_STABLE_BETWEEN_TICKS_EDGE(sig, clk, rst) \
   `HQM_DEVTLB_ASSUME_GSTABLE_BETWEEN_TICKS(sig, clk, rst)

`else

`define HQM_DEVTLB_ASSERT_STABLE_BETWEEN_TICKS_EDGE(sig, clk, rst) \
   assert property(DEVTLB_p_gstable_between_ticks_sig(sig, $changed(clk), (rst | reset_INST)))

`define HQM_DEVTLB_ASSUME_STABLE_BETWEEN_TICKS_EDGE(sig, clk, rst) \
   assume property(DEVTLB_p_gstable_between_ticks_sig(sig, $changed(clk), rst))

`endif

// ****************************************************************************************** //

