//=====================================================================================================================
// Title            : hqm_intel_checkers_core.sv
//
//
// Copyright (c) 2013 Intel Corporation
// Intel Proprietary and Top Secret Information
//
// There are two kinds of core entities, sequential and combinational.
// The combinational entities do not use a sampling clock and are implemented
// on top of final immediate assertions.
// The sequential entities require a clock for sampling the design signals and
// are implemented on top of concurrent assertions.
// For Sequential assertions, the reset has a default value of 1'b0. Therefore,
// if an actual argument for rst is omitted, the assertion is always enabled.
// 
// Both kinds of entities can be instantiated in procedural and in concurrent
// (structural) contexts. Both positional and named association between the
// formal and the actual arguments is supported.
// The combinational entities start with HQM_ASSERTC.
// The sequential entities start with HQM_ASSERTS.
//
// Stability assertions: there are two sets of sequential entities:
// Those checking also between specified clock ticks, and those which check only  
// on specified clock ticks.
// 
// Note 1:  HQM_ASSERTS_G Category entities operate on two clock signals, one that is
// the regular assertion clock, and the second one is a reference clock for stability
// checks. 
//
// Examples:
// =========
//
// Combinational entity:
//    `HQM_ASSERTC_MUTEXED(name, myBusEnables, `HQM_SVA_ERR_MSG("I have error"));
//
// Sequential entity:
//    `HQM_ASSERTS_TRIGGER(name, x, y, posedge clk, rst, `HQM_SVA_ERR_MSG("I have error"));
//
// Usage Examples: 
//
//    Positional association:
//       // default rst of 0
//       `HQM_ASSERTS_TRIGGER(name, x, y, posedge clk, , `HQM_SVA_ERR_MSG("I have error"))
//       // no default or inference
//       `HQM_ASSERTS_TRIGGER(name, x, y, posedge clk, rst, `HQM_SVA_ERR_MSG("I have error"))
//
//    Named associations:
//        // clk inferred either from always or def_clk, rst is 0
//       `HQM_ASSERTS_TRIGGER(name, .en(x), .ev(y), .prop(z), `HQM_SVA_ERR_MSG("I have error"))
//


// === === === Implementation for the templates                                

// --- --- --- --- --- --- --- --- --- --- ----                                


`define hqm_l_known(sig) ((hqm_intel_checkers_pkg::HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))))
`define hqm_l_same(siga, sigb) ((hqm_intel_checkers_pkg::HQM_SVA_LIB_IGNORE_XZ)? ((siga)===(sigb)) : ((siga)==(sigb)))
`define hqm_l_mutexed(sig)  ($onehot0({>>{sig}}) && `hqm_l_known(sig))
`define hqm_l_at_most_bits_high(sig, n)  (($countones({>>{sig}}) <= n) && `hqm_l_known(sig))
`define hqm_l_at_most_bits_low(sig, n)  (($countones({>>{~sig}}) <= n) && `hqm_l_known(sig))
`define hqm_l_bits_high(sig, n)  (($countones({>>{sig}}) == n) && `hqm_l_known(sig))
`define hqm_l_bits_low(sig, n)  (($countones({>>{~sig}}) == n) && `hqm_l_known(sig))
`define hqm_l_same_bits(sig)  ((&(sig)) || !(|(sig)))
`define hqm_l_one_hot(sig)  ($onehot({>>{sig}}) && `hqm_l_known(sig))
`define hqm_l_known_driven(sig)  `hqm_l_known(sig)
`define hqm_l_forbidden(cond)  (!(cond))
`define hqm_l_must(prop)  (prop)
`define hqm_l_trigger(trig_sig, prop_sig) (trig_sig -> prop_sig)
`define hqm_l_range(sig, low, high)  (((sig) >=(low)) & ((sig) <=(high)))
`define hqm_l_max_value(sig, max_val)  ((sig) <= (max_val))
`define hqm_l_min_value(sig, min_val)  ((sig) >= (min_val))



// ****************************************************************************************** //
// Common arguments:
//      clk     event       Clock event. Default: $inferred_clock.
//      rst     Boolean     Reset signal.
//      name    string      Assertion label.
//      MSG     string      Error message.
//
// ------------------------------------------------------------------------------------------ //

// --- --- --- Immediate Templates --- --- --- //


// ****************************************************************************************** //
// Name:   mutexed
// Category: Combinational
// Description:
//       At most one bit of 'sig' is high. x and z values are counted, which means that at most
//       one bit can be high or x or z.
// Arguments:
//       - sig    Bit-vector  At most one bit of <sig> is high. Limitation: 'sig' must be a packed
//       array
// Comments:
//       - MUTEXED is equivalent to AT_MOST_BITS_HIGH where 'n' is equal to 1. 
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be delayed
//         by one sampling edge compared to when the assertion is in an always_comb or in
//         structural context. 
// Related: 
//       ONE_HOT
//       AT_MOST_BITS_HIGH
//       BITS_HIGH
// Example:
//       The following will fail | @VIEW@(001x);
//
// ------------------------------------------------------------------------------------------ //



`define HQM_ASSERTC_MUTEXED(name, sig, rst, MSG)                                    \
    name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_mutexed(sig)) /* novas s-2050,s-2056 */   MSG  

`define HQM_ASSUMEC_MUTEXED(name, sig, rst, MSG)                                    \
    name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_mutexed(sig)) /* novas s-2050,s-2056 */   MSG  


`define HQM_ASSERTS_MUTEXED(name, sig, clk, rst, MSG)                               \
    name: assert property(hqm_intel_checkers_pkg::hqm_p_mutexed(sig, clk, rst)) MSG 

`define HQM_ASSUMES_MUTEXED(name, sig, clk, rst, MSG)                               \
    name: assume property(hqm_intel_checkers_pkg::hqm_p_mutexed(sig, clk, rst)) MSG 


`define COVERC_MUTEXED(name, sig, rst, MSG)                                     \
    `ifndef HQM_SVA_LIB_COVER_ENABLE                                                \
        typedef logic t_``name                                                    \
    `else                                                                       \
        name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_mutexed(sig)) /* novas s-2050,s-2056 */  MSG \
    `endif

`define COVERS_MUTEXED(name, sig, clk, rst, MSG)                                \
    `ifndef HQM_SVA_LIB_COVER_ENABLE                                                \
        typedef logic t_``name                                                    \
    `else                                                                       \
        name: cover property(hqm_intel_checkers_pkg::hqm_p_cover_mutexed(sig, clk, rst)) MSG                \
    `endif



`define NOT_MUTEXED_COVERC(name, sig, rst, MSG)                                 \
    `ifndef HQM_SVA_LIB_COVER_ENABLE                                                \
        typedef logic t_``name                                                    \
    `else                                                                       \
        name: cover `HQM_SVA_LIB_FINAL (!(rst) && ! `hqm_l_mutexed(sig)) /* novas s-2050,s-2056 */ MSG  \
    `endif


`define NOT_MUTEXED_COVERS(name, sig, clk, rst, MSG)                            \
    `ifndef HQM_SVA_LIB_COVER_ENABLE                                                \
        typedef logic t_``name                                                    \
    `else                                                                       \
        name: cover property( hqm_intel_checkers_pkg::hqm_p_not_mutexed_covered(sig, clk, rst)) MSG          \
    `endif

// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   one hot
// Category: Combinational
// Description:
//       Exactly one bit of 'sig' is high, other bits are low, and there are no x and z values
//       in 'sig'.
// Arguments:
//       - sig    Bit-vector  Exactly one bit of 'sig' is high.
// Comments:
//       - ONE_HOT is equivalent to BITS_HIGH where 'n' is equal to 1.
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//         The pass or failure of an immediate assertion inside an always_ff block would be delayed
//         by one sampling edge compared to when the assertion is in an always_comb or in structural
//         context.
// Related:
//       MUTEXED
//       AT_MOST_BITS_HIGH
//       BITS_HIGH
// Example:
//       The following will fail | @VIEW@(001x);
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTC_ONE_HOT(name, sig, rst, MSG)                                    \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_one_hot(sig)) /* novas s-2050,s-2056 */ MSG 

`define HQM_ASSUMEC_ONE_HOT(name, sig, rst, MSG)                                    \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_one_hot(sig)) /* novas s-2050,s-2056 */ MSG



`define HQM_ASSERTS_ONE_HOT(name, sig, clk, rst, MSG)                               \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_one_hot(sig, clk, rst)) MSG

`define HQM_ASSUMES_ONE_HOT(name, sig, clk, rst, MSG)                               \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_one_hot(sig, clk, rst)) MSG



`define COVERC_ONE_HOT(name, sig, rst, MSG)                                     \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_one_hot(sig)) /* novas s-2050,s-2056 */ MSG \
   `endif

`define COVERS_ONE_HOT(name, sig, clk, rst, MSG)                                \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_one_hot(sig, clk, rst)) MSG                 \
   `endif



`define NOT_ONE_HOT_COVERC(name, sig, rst, MSG)                                 \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && !`hqm_l_one_hot(sig)) /* novas s-2050,s-2056 */ MSG \
   `endif

`define NOT_ONE_HOT_COVERS(name, sig, clk, rst, MSG)                            \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_not_one_hot_cover(sig, clk, rst)) MSG             \
   `endif



// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   same bits
// Category: Combinational
// Description:
//       All bits of 'sig' have the same value: high or low.
// Arguments:
//       - sig    Bit-vector    All bits of 'sig' have the same value: high or low. 
// Comments:
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be
//         delayed by one sampling edge compared to when the assertion is in an always_comb or
//         in structural context.
// Related:
//       None
// Example:
//       The following will fail | @VIEW@(000x);
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTC_SAME_BITS(name, sig, rst, MSG)                                  \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_same_bits(sig)) /* novas s-2050,s-2056 */ MSG

`define HQM_ASSUMEC_SAME_BITS(name, sig, rst, MSG)                                  \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_same_bits(sig)) /* novas s-2050,s-2056 */ MSG



`define HQM_ASSERTS_SAME_BITS(name, sig, clk, rst, MSG)                             \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_same_bits(sig, clk, rst)) MSG

`define HQM_ASSUMES_SAME_BITS(name, sig, clk, rst, MSG)                             \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_same_bits(sig, clk, rst)) MSG



`define COVERC_SAME_BITS(name, sig, rst, MSG)                                   \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_same_bits(sig)) /* novas s-2050,s-2056 */ MSG \
   `endif

`define COVERS_SAME_BITS(name, sig, clk, rst, MSG)                              \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_same_bits(sig, clk, rst)) MSG               \
   `endif



`define NOT_SAME_BITS_COVERS(name, sig, clk, rst, MSG)                          \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_not_same_bits_cover(sig, clk, rst)) MSG           \
   `endif

`define NOT_SAME_BITS_COVERC(name, sig, rst, MSG)                               \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && ! `hqm_l_same_bits(sig)) /* novas s-2050,s-2056 */ MSG \
   `endif


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  range
// Category: Combinational
// Description:
//       Signal 'sig' must always be in the range [low, high], inclusive of both the range
//       values.
// Arguments:
//       - sig    Bit-vector  Signal to be monitored for its value to be within a specified range.
//       - low    Number>=0   Lower bound on 'sig'.
//       - high   Number>=0   Upper bound on 'sig'.
// Comments:
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be
//         delayed by one sampling edge compared to when the assertion is in an always_comb or
//         in structural context.
// Related:
//       ONE_OF
//       MIN
//       MAX
// Example: 
//       Valid port number is 5 to 10 | @VIEW@(port, 5, 10);
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTC_RANGE(name, sig, low, high, rst, MSG)                           \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_range(sig, low, high)) /* novas s-2050,s-2056,s-0393 */ MSG

`define HQM_ASSUMEC_RANGE(name, sig, low, high, rst, MSG)                           \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_range(sig, low, high)) /* novas s-2050,s-2056,s-0393 */ MSG

`define HQM_ASSERTS_RANGE(name, sig, low, high, clk, rst, MSG)                      \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_range(sig, low, high, clk, rst)) MSG

`define HQM_ASSUMES_RANGE(name, sig, low, high, clk, rst, MSG)                      \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_range(sig, low, high, clk, rst)) MSG



`define COVERC_RANGE(name, sig, low, high, rst, MSG)                            \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_range(sig, low, high)) /* novas s-2050,s-2056,s-0393 */ MSG \
   `endif

`define COVERS_RANGE(name, sig, low, high, clk, rst, MSG)                       \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_range(sig, low, high, clk, rst)) MSG       \
   `endif



`define NOT_RANGE_COVERS(name, sig, low, high, clk, rst, MSG)                   \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_not_range_cover(sig, low, high, clk, rst)) MSG    \
   `endif

`define NOT_RANGE_COVERC(name, sig, low, high, rst, MSG)                        \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && ! `hqm_l_range(sig, low, high)) /* novas s-2050,s-2056,s-0393 */ MSG \
   `endif



// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  at most bits high
// Category: Combinational 
// Description:
//       At most 'n' bits in 'sig' are high. x and z values are counted as high for this
//       calculation.
// Arguments:
//       - sig    Bit-vector    At most 'n' bits in 'sig' can be high. Limitation: 'sig' must be
//                              a packed array.
//       - n      Number>=0     The maximum number of bits in 'sig' that are allowed to be high.
// Comments:
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be
//         delayed by one sampling edge compared to when the assertion is in an always_comb or
//         in structural context.
// Related:
//       BITS_HIGH
//       MUTEXED
//       ONE_HOT
// Example:
//       The following will fail | @VIEW@(001x, 1);
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTC_AT_MOST_BITS_HIGH(name, sig, n, rst, MSG)                       \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_at_most_bits_high(sig, n)) /* novas s-2050,s-2056 */ MSG

`define HQM_ASSUMEC_AT_MOST_BITS_HIGH(name, sig, n, rst, MSG)                       \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_at_most_bits_high(sig, n)) /* novas s-2050,s-2056 */ MSG



`define HQM_ASSERTS_AT_MOST_BITS_HIGH(name, sig, n, clk, rst, MSG)                  \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_at_most_bits_high(sig, n, clk, rst)) MSG

`define HQM_ASSUMES_AT_MOST_BITS_HIGH(name, sig, n, clk, rst, MSG)                  \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_at_most_bits_high(sig, n, clk, rst)) MSG



`define COVERC_AT_MOST_BITS_HIGH(name, sig, n, rst, MSG)                        \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_at_most_bits_high(sig, n)) /* novas s-2050,s-2056 */ MSG \
   `endif

`define COVERS_AT_MOST_BITS_HIGH(name, sig, n, clk, rst, MSG)                   \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_at_most_bits_high(sig, n, clk, rst)) MSG    \
   `endif



`define NOT_AT_MOST_BITS_HIGH_COVERS(name, sig, n, clk, rst, MSG)               \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_not_at_most_bits_high_cover(sig, n, clk, rst)) MSG \
   `endif

`define NOT_AT_MOST_BITS_HIGH_COVERC(name ,sig, n, rst, MSG)                    \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && ! `hqm_l_at_most_bits_high(sig, n)) /* novas s-2050,s-2056 */ MSG \
   `endif


// ****************************************************************************************** //



// --- --- ---

// ****************************************************************************************** //
// Name:  bits high
// Category: Combinational
// Description:
//       Exactly 'n' bits of 'sig' are high, other bits are low, and there are no x or z
//       values in 'sig'.
// Arguments:
//       - sig    Bit-vector   Exactly 'n' bits in 'sig' are high.
//       - n      Number>=0    The number of bits in 'sig' that are high.
// Comments:
//       - BITS_HIGH where 'n' is equal to 1 is equivalent to ONE_HOT.
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be
//         delayed by one sampling edge compared to when the assertion is in an always_comb or
//         in structural context.
// Related:
//       AT_MOST_BITS_HIGH
//       REMAIN_HIGH
//       BITS_LOW
//       ONE_HOT
// Example:
//       The following will fail | @VIEW@(001x, 1);
//
// ------------------------------------------------------------------------------------------ //



`define HQM_ASSERTC_BITS_HIGH(name, sig, n, rst, MSG)                               \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_bits_high(sig, n)) /* novas s-2050,s-2056 */ MSG

`define HQM_ASSUMEC_BITS_HIGH(name, sig, n, rst, MSG)                               \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_bits_high(sig, n)) /* novas s-2050,s-2056 */ MSG



`define HQM_ASSERTS_BITS_HIGH(name, sig, n, clk, rst, MSG)                          \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_bits_high(sig, n, clk, rst)) MSG

`define HQM_ASSUMES_BITS_HIGH(name, sig, n, clk, rst, MSG)                          \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_bits_high(sig, n, clk, rst)) MSG



`define COVERS_BITS_HIGH(name, sig, n, clk, rst, MSG)                           \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_bits_high(sig, n, clk, rst)) MSG            \
   `endif

`define COVERC_BITS_HIGH(name, sig, n, rst, MSG)                                \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_bits_high(sig, n)) /* novas s-2050,s-2056 */ MSG \
   `endif



`define NOT_BITS_HIGH_COVERS(name, sig, n, clk, rst, MSG)                       \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_not_bits_high_cover(sig, n, clk, rst)) MSG        \
   `endif

`define NOT_BITS_HIGH_COVERC(name ,sig, n, rst, MSG)                            \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && ! `hqm_l_bits_high(sig, n)) /* novas s-2050,s-2056 */ MSG \
   `endif


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  one of
// Category: Combinational
// Description:
//      Signal 'sig' must be equal to one of the values listed.
// Arguments:
//       - sig    Bit-vector   Signal to be monitored for its value to be one of the values listed.
//       - set    Number>=0    Comma separated set of integers.
// Comments:
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be delayed
//         by one sampling edge compared to when the assertion is in an always_comb or in
//         structural context.
//       - set of elements is currently not supported in let statments
//       - Sequential views are not supported for this macro.
// Related:
//       RANGE
//       MIN
//       MAX
// Example: 
//       TBD |
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTC_ONE_OF(name, sig, set, rst, MSG)                                \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | (((sig) inside set) & `hqm_l_known(sig))) /* novas s-2050,s-2056 */ MSG

`define HQM_ASSUMEC_ONE_OF(name, sig, set, rst, MSG)                                \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | (((sig) inside set) & `hqm_l_known(sig))) /* novas s-2050,s-2056 */ MSG

`define COVERC_ONE_OF(name, sig, set, rst, MSG)                                 \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && ((sig) inside set)) /* novas s-2050,s-2056 */ MSG \
   `endif


`define NOT_ONE_OF_COVERC(name ,sig, set, rst, MSG)                             \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && !((sig) inside set)) /* novas s-2050,s-2056 */ MSG \
   `endif


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:   known driven
// Category: Combinational
// Description:
//       All bits of 'sig' are both known (not X) and driven (not Z). This property passes
//       vacuously in formal verification since signals in formal verification have concrete
//       (known) values (0 or 1).
// Arguments:
//       - sig    Bit-vector    Signal to check.
// Comments:
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be delayed
//         by one sampling edge compared to when the assertion is in an always_comb or in structural
//         context.
// Related:
//       None
// Example:
//       Not relevant|
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTC_KNOWN_DRIVEN(name, sig, rst, MSG)                               \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_known_driven(sig)) /* novas s-2050,s-2056 */ MSG

`define HQM_ASSUMEC_KNOWN_DRIVEN(name, sig, rst, MSG)                               \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_known_driven(sig)) /* novas s-2050,s-2056 */ MSG



`define HQM_ASSERTS_KNOWN_DRIVEN(name, sig, clk, rst, MSG)                          \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_known_driven(sig, clk, rst)) MSG

`define HQM_ASSUMES_KNOWN_DRIVEN(name, sig, clk, rst, MSG)                          \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_known_driven(sig, clk, rst)) MSG



`define COVERS_KNOWN_DRIVEN(name, sig, clk, rst, MSG)                           \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_known_driven(sig, clk, rst)) MSG            \
   `endif

`define COVERC_KNOWN_DRIVEN(name, sig, rst, MSG)                                \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_known_driven(sig)) /* novas s-2050,s-2056 */ MSG \
   `endif



`define NOT_KNOWN_DRIVEN_COVERS(name, sig, clk, rst, MSG)                       \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_not_known_driven_cover(sig, clk, rst)) MSG        \
   `endif

`define NOT_KNOWN_DRIVEN_COVERC(name, sig, rst, MSG)                            \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && ! `hqm_l_known_driven(sig)) /* novas s-2050,s-2056 */ MSG \
   `endif


// ****************************************************************************************** //



// --- --- ---

// ****************************************************************************************** //
// Name:   same
// Category: Combinational
// Description:
//       The vectors have same value . The checker compares 2 input vectors - 'siga' has the
//       same value as 'sigb'.
// Arguments:
//       - siga    Bit-vector    First vector to be checked.
//       - sigb    Bit-vector    Second vector to be checked.
// Comments:
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be
//         delayed by one sampling edge compared to when the assertion is in an always_comb or
//         in structural context.
// Related:
//       SAME_BITS
// Example:
//       Not relevant. |
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTC_SAME(name, siga, sigb, rst, MSG)                                \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_same(siga, sigb)) /* novas s-2050,s-2056 */ MSG 

`define HQM_ASSUMEC_SAME(name, siga, sigb, rst, MSG)                                \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_same(siga, sigb)) /* novas s-2050,s-2056 */ MSG 



`define HQM_ASSERTS_SAME(name, siga, sigb, clk, rst, MSG)                           \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_same(siga, sigb, clk, rst)) MSG

`define HQM_ASSUMES_SAME(name, siga, sigb, clk, rst, MSG)                           \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_same(siga, sigb, clk, rst)) MSG



`define COVERC_SAME(name, siga, sigb, rst, MSG)                                 \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_same(siga, sigb)) /* novas s-2050,s-2056 */ MSG \
   `endif

`define COVERS_SAME(name, siga, sigb, clk, rst, MSG)                            \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_same(siga, sigb, clk, rst)) MSG             \
   `endif



`define NOT_SAME_COVERC(name, siga, sigb, rst, MSG)                             \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && !(`hqm_l_same(siga, sigb))) /* novas s-2050,s-2056 */ MSG \
   `endif

`define NOT_SAME_COVERS(name, siga, sigb, clk, rst, MSG)                        \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_not_same_cover(siga, sigb, clk, rst)) MSG         \
   `endif


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:   must
// Category: Combinational
// Description:
//       Boolean condition 'prop' must always be true.
// Arguments:
//       - prop    Boolean  The boolean condition that must always be true.
// Comments:
//       - The condition must be a boolean.
//       - When the condition is boolean and clocked, HQM_ASSERTS_MUST is equivalent to HQM_ASSERTS_VERIFY.
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be delayed by 
//         one sampling edge compared to when the assertion is in an always_comb or in structural
//         context.
// Related:
//       VERIFY
//       FORBIDDEN
//       NEVER
// Example:
//       N/A |
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTC_MUST(name, prop, rst, MSG)                                      \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_must(prop)) /* novas s-2050,s-2056 */ MSG 

`define HQM_ASSUMEC_MUST(name, prop, rst, MSG)                                      \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_must(prop)) /* novas s-2050,s-2056 */ MSG 



`define HQM_ASSUMES_MUST(name, prop, clk, rst, MSG)                                 \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_must(prop, clk, rst)) MSG

`define HQM_ASSERTS_MUST(name, prop, clk, rst, MSG)                                 \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_must(prop, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   forbidden
// Category: Combinational
// Description:
//       Boolean condition 'cond' must never occur.
// Arguments:
//       - cond    Boolean   The boolean condition that must never occur.
// Comments:
//       - The condition must be a boolean.
//       - When the condition is boolean and clocked, HQM_ASSERTS_FORBIDDEN is equivalent to
//       - HQM_ASSERTS_NEVER.
//       - The difference between HQM_ASSERTS_NEVER and HQM_ASSERTS_FORBIDDEN is that with
//         HQM_ASSERTS_FORBIDDEN the condition must be boolean, whereas with HQM_ASSERTS_NEVER the
//         condition may also span over time (i.e. be sequential).             
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be
//         delayed by one sampling edge compared to when the assertion is in an always_comb or
//         in structural context.
// Related:
//       VERIFY
//       FORBIDDEN
//       NEVER
// Example:
//       N/A |
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTC_FORBIDDEN(name, cond, rst, MSG)                                 \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_forbidden(cond)) /* novas s-2050,s-2056 */ MSG

`define HQM_ASSUMEC_FORBIDDEN(name, cond, rst, MSG)                                 \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_forbidden(cond)) /* novas s-2050,s-2056 */ MSG



`define HQM_ASSUMES_FORBIDDEN(name, cond, clk, rst, MSG)                            \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_forbidden(cond, clk, rst)) MSG

`define HQM_ASSERTS_FORBIDDEN(name, cond, clk, rst, MSG)                            \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_forbidden(cond, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:   min
// Category: Combinational
// Description:
//       The value of 'sig' must be no less than 'min_val'. It may be equal to 'min_val'.
// Arguments:
//       - sig        Bit-vector  Signal to be monitored for its value to be no lower than
//                                'min_val'.
//       - min_val    Number>=0   The minimum value that 'sig' can have.
// Comments:
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be
//         delayed by one sampling edge compared to when the assertion is in an always_comb or
//         in structural context.
// Related:
//       MAX
//       RANGE
//       ONE_OF
// Example:
//       Valid port number is no less than 5 | @VIEW@(port, 5);
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTC_MIN(name, sig, min_val, rst, MSG)                               \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_min_value(sig, min_val)) /* novas s-2050,s-2056 */ MSG

`define HQM_ASSUMEC_MIN(name, sig, min_val, rst, MSG)                               \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_min_value(sig, min_val)) /* novas s-2050,s-2056 */ MSG



`define HQM_ASSUMES_MIN(name, sig, min_val, clk, rst, MSG)                          \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_min_value(sig, min_val, clk, rst)) MSG

`define HQM_ASSERTS_MIN(name, sig, min_val, clk, rst, MSG)                          \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_min_value(sig, min_val, clk, rst)) MSG



`define COVERS_MIN(name, sig, min_val, clk, rst, MSG)                           \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_min_value(sig, min_val, clk, rst)) MSG      \
   `endif

`define COVERC_MIN(name, sig, min_val, rst, MSG)                                \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL ((!(rst) && `hqm_l_min_value(sig, min_val))) /* novas s-2050,s-2056 */ MSG \
   `endif



`define NOT_MIN_COVERS(name ,sig, min_val, clk, rst, MSG)                       \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_not_min_value_cover(sig, min_val, clk, rst)) MSG  \
   `endif

`define NOT_MIN_COVERC(name, sig, min_val, rst, MSG)                            \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_min_value(sig, min_val)) /* novas s-2050,s-2056 */ MSG \
   `endif


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:   max
// Category: Combinational
// Description:
//       The value of 'sig' must be no greater than 'max_val'. It may be equal to 'max_val'.
// Arguments:
//       - sig        Bit-vector   Signal to be monitored for its value to be no greater than
//                                 'max_val'.
//       - max_val    Number>=0    The maximum value that 'sig' can have.
// Comments:
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be delayed
//         by one sampling edge compared to when the assertion is in an always_comb or in structural
//         context.
// Related:
//       MIN
//       RANGE
//       ONE_OF
// Example:
//       Valid port number is no more than 5 | @VIEW@(port, 5);
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTC_MAX(name, sig, max_val, rst, MSG)                               \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_max_value(sig, max_val)) /* novas s-2050,s-2056 */ MSG

`define HQM_ASSUMEC_MAX(name, sig, max_val, rst, MSG)                               \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_max_value(sig, max_val)) /* novas s-2050,s-2056 */ MSG



`define HQM_ASSUMES_MAX(name, sig, max_val, clk, rst, MSG)                          \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_max_value(sig, max_val, clk, rst)) MSG

`define HQM_ASSERTS_MAX(name, sig, max_val, clk, rst, MSG)                          \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_max_value(sig, max_val, clk, rst)) MSG



`define COVERS_MAX(name, sig, max_val, clk, rst, MSG)                           \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_max_value(sig, max_val, clk, rst)) MSG      \
   `endif

`define COVERC_MAX(name, sig, max_val, rst, MSG)                                \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL ((!(rst) && `hqm_l_max_value(sig, max_val))) /* novas s-2050,s-2056 */ MSG \
   `endif



`define NOT_MAX_COVERS(name ,sig, max_val, clk, rst, MSG)                       \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_not_max_value_cover(sig, max_val, clk, rst)) MSG  \
   `endif

`define NOT_MAX_COVERC(name, sig, max_val, rst, MSG)                            \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_max_value(sig, max_val)) /* novas s-2050,s-2056 */ MSG \
   `endif


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:   at most bits low
// Category: Combinational
// Description:
//       At most 'n' bits in 'sig' are low. x and z values are counted as low for this calculation.
// Arguments:
//       - sig   Bit-vector    At most 'n' bits in 'sig' can be low. Limitation: 'sig' must be a
//                             packed array.
//       - n     Number>=0     The maximum number of bits in 'sig' that are allowed to be low.
// Comments:
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be delayed
//         by one sampling edge compared to when the assertion is in an always_comb or in structural
//         context.
// Related:
//       AT_MOST_BITS_HIGH
//       BITS_LOW
// Example:
//       The following will fail | @VIEW@(001x, 3);
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTC_AT_MOST_BITS_LOW(name, sig, n, rst, MSG)                        \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_at_most_bits_low(sig, n)) /* novas s-2050,s-2056 */ MSG

`define HQM_ASSUMEC_AT_MOST_BITS_LOW(name, sig, n, rst, MSG)                        \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_at_most_bits_low(sig, n)) /* novas s-2050,s-2056 */ MSG



`define HQM_ASSUMES_AT_MOST_BITS_LOW(name, sig, n, clk, rst, MSG)                   \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_at_most_bits_low(sig, n, clk, rst)) MSG

`define HQM_ASSERTS_AT_MOST_BITS_LOW(name, sig, n, clk, rst, MSG)                   \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_at_most_bits_low(sig, n, clk, rst)) MSG



`define COVERS_AT_MOST_BITS_LOW(name, sig, n, clk, rst, MSG)                    \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_at_most_bits_low(sig, n, clk, rst)) MSG     \
   `endif

`define COVERC_AT_MOST_BITS_LOW(name, sig, n, rst, MSG)                         \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_at_most_bits_low(sig, n)) /* novas s-2050,s-2056 */ MSG \
   `endif



`define NOT_AT_MOST_BITS_LOW_COVERS(name, sig, n, clk, rst, MSG)                \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_not_at_most_bits_low_cover(sig, n, clk, rst)) MSG \
   `endif

`define NOT_AT_MOST_BITS_LOW_COVERC(name ,sig, n, rst, MSG)                     \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && ! `hqm_l_at_most_bits_low(sig, n)) /* novas s-2050,s-2056 */ MSG \
   `endif


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:   bits low
// Category: Combinational
// Description:
//       Exactly 'n' bits of 'sig' are low, other bits are high, and there are no x or z
//       values in 'sig'.
// Arguments:
//       - sig   Bit-vector   Exactly 'n' bits in 'sig' are low.
//       - n     Number>=0    The number of bits in 'sig' that are low.
// Comments:
//       - HQM_ASSERTC view This is an immediate checker and can be used anywhere including functions.
//       - HQM_ASSUMES view This is temporal and recommended for formal verification users.
//       - The pass or failure of an immediate assertion inside an always_ff block would be
//         delayed by one sampling edge compared to when the assertion is in an always_comb or
//         in structural context.
// Related:
//       AT_MOST_BITS_LOW
//       BITS_HIGH
//       REMAIN_LOW
// Example:
//       The following will fail | @VIEW@(001x, 2);
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTC_BITS_LOW(name, sig, n, rst, MSG)                                \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_bits_low(sig, n)) /* novas s-2050,s-2056 */ MSG 

`define HQM_ASSUMEC_BITS_LOW(name, sig, n, rst, MSG)                                \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_bits_low(sig, n)) /* novas s-2050,s-2056 */ MSG 



`define HQM_ASSUMES_BITS_LOW(name, sig, n, clk, rst, MSG)                           \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_bits_low(sig, n, clk, rst)) MSG

`define HQM_ASSERTS_BITS_LOW(name, sig, n, clk, rst, MSG)                           \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_bits_low(sig, n, clk, rst)) MSG



`define COVERS_BITS_LOW(name, sig, n, clk, rst, MSG)                            \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_bits_low(sig, n, clk, rst)) MSG             \
   `endif

`define COVERC_BITS_LOW(name, sig, n, rst, MSG)                                 \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && `hqm_l_bits_low(sig, n)) /* novas s-2050,s-2056 */ MSG \
   `endif



`define NOT_BITS_LOW_COVERS(name, sig, n, clk, rst, MSG)                        \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_not_bits_low_cover(sig, n, clk, rst)) MSG         \
   `endif

`define NOT_BITS_LOW_COVERC(name ,sig, n, rst, MSG)                             \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover `HQM_SVA_LIB_FINAL (!(rst) && ! `hqm_l_bits_low(sig, n)) /* novas s-2050,s-2056 */ MSG \
   `endif


// ****************************************************************************************** //


// --- --- ---


// ****************************************************************************************** //
// Name:  cover 
// Category: Cover
// Description:
//      Cover a sequence.
// Arguments:
//      - seq  Sequence   Sequence to be covered.
// Comments:
//      None.
// Related:
//      None
// Example:
//      TBD |
//
// ------------------------------------------------------------------------------------------ //

`define COVERS(name, prop, clk, rst, MSG)                                       \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
       typedef logic t_``name                                                     \
   `else                                                                        \
       name: cover property( hqm_intel_checkers_pkg::hqm_p_cover(prop, clk, rst)) MSG                        \
   `endif


`define COVERS_ENABLE(name, en, prop, clk, rst, MSG)                            \
   `ifndef HQM_SVA_LIB_COVER_ENABLE                                                 \
      typedef logic t_``name                                                      \
   `else                                                                        \
      name: cover property( hqm_intel_checkers_pkg::hqm_p_cover_enable(en, prop, clk, rst)) MSG              \
   `endif




// ****************************************************************************************** //

// --- --- ---


// ****************************************************************************************** //
// Name:   fire
// Category: Combinational
// Description:
//       Fire an error message whenever reached.
// Arguments:
//       - sig    Bit-vector   At most one bit of <sig> is high. Limitation: 'sig' must be a
//                           packed array
// Comments:
//       - This checker has generic arguments only. It is only used to fire error messages.
//       - This template is mainly useful in default clauses of case statements.
// Related:
//       None
// Code sample:
//       always_comb
//         unique casex (1'b1)
//           iq_4flight_CM105H[0] : iq_instflight_CM105H[0] = 3'b100;
//           iq_3flight_CM105H[0] : iq_instflight_CM105H[0] = 3'b011;
//         default :
//           iq_instflight_CM105H[0] = 3'b000;
//           `HQM_ASSERTC_FIRE(R_IFU_iq_instflight, `HQM_SVA_ERR_MSG("error in sva1"));
//       endcase
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTC_FIRE(name, MSG)                                                 \
   name: assert `HQM_SVA_LIB_FINAL (1'b0) MSG


// ****************************************************************************************** //





// --- --- --- Concurent Templates --- --- --- //


// ****************************************************************************************** //
// Name:  trigger
// Category: Antecedent/Consequence
// Description:
//       When 'trig' occurs, 'prop' should occur.
// Arguments:
//      - trig    Sequence   Triggering event. Checking begins each time the sequence 'trig' is
//                           matched. In the special case where the sequence is a Boolean, each
//                           time the Boolean is high.
//      - prop    Property   Property to be satisfied.
// Comments:
//      - If sequence 'trig' occurs, then property 'prop' must hold at the completion of that
//        sequence. Can also be used for simple Boolean implication, i.e. if Boolean 'b1' holds,
//        then Boolean 'b2' holds as well.
// Related:
//      DELAYED_TRIGGER
//      RECUR_TRIGGERS
// Code sample:
//      sequence e;
//        sig1 ##1 !sig1 ##1 sig1;
//      endsequence
//      sequence form;
//        sig2 ##1 !sig2 ##1 sig2[*2];
//      endsequence
//      `HQM_ASSERTS_TRIGGER(trigger_edge_clk, e, form, posedge clk, rst, `HQM_SVA_ERR_MSG("Error!"));
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTC_TRIGGER(name, trig, sig, rst, MSG)                              \
   name: assert `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_trigger(trig, sig))  /* novas s-2050 */  MSG

`define HQM_ASSERTS_TRIGGER(name, trig, prop, clk, rst, MSG)                        \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_trigger(trig, prop, clk, rst)) MSG

`define HQM_ASSUMEC_TRIGGER(name, trig, sig, rst, MSG)                         \
   name: assume `HQM_SVA_LIB_FINAL ((|(rst)) | `hqm_l_trigger(trig, sig))  /* novas s-2050 */  MSG

`define HQM_ASSUMES_TRIGGER(name, trig, prop, clk, rst, MSG)                        \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_trigger(trig, prop, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:  delayed trigger
// Category: Antecedent/Consequence
// Description:
//      When 'trig' occurs, 'prop' should occur 'delay' clock ticks after the completion of
//      'trig'.
// Arguments:
//      - trig    Sequence     Triggering event. Checking begins each time the sequence
//                             'trig' is matched. In the special case where the sequence is
//                             a Boolean, each time the Boolean is high.
//      - delay   Number>0     Delay in clock ticks after the completion of 'trig'.
//      - prop    Property     The property that should occur.
// Comments:
//      - This template no longer supports a delay of 0. To achieve this purpose, use TRIGGER.
//      - This template is expensive for a large 'delay'.
//      - If sequence 'trig' is satisfied, then property 'prop' must be satisfied 'delay' clock
//        ticks after the completion of 'trig'. Can also be used for simple Boolean implication,
//        i.e. if Boolean 'b1' holds, then after 'delay' clock ticks Boolean 'b2' holds as well.
// Related:
//      TRIGGER
//      RECUR_TRIGGERS
// Code sample:
//      sequence e;
//        sig1 ##1 !sig1 ##1 sig1;
//      endsequence
//      sequence form;
//        sig2 ##1 !sig2 ##1 sig2[*2];
//      endsequence
//      `HQM_ASSERTS_DELAYED_TRIGGER(delayed_name, e, 2, form, posedge clk, rst, `HQM_SVA_ERR_MSG("Error"));
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_DELAYED_TRIGGER(name, trig, delay, prop, clk, rst, MSG)         \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_delayed_trigger(trig, delay, prop, clk, rst)) MSG   

`define HQM_ASSUMES_DELAYED_TRIGGER(name, trig, delay, prop, clk, rst, MSG)         \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_delayed_trigger(trig, delay, prop, clk, rst)) MSG   


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  never
// Category: Data Checking
// Description:
//      The property 'prop' never occurs.
// Arguments:
//      - prop    Property  The property that should never occur.
// Comments:
//      - When the condition is boolean and clocked, HQM_ASSERTS_FORBIDDEN is equivalent to 
//        HQM_ASSERTS_NEVER. The difference between HQM_ASSERTS_NEVER and HQM_ASSERTS_FORBIDDEN is that with
//        HQM_ASSERTS_FORBIDDEN the condition must be boolean, whereas with HQM_ASSERTS_NEVER the 
//        condition may also span over time (i.e. be sequential).
// Related:
//      FORBIDDEN
//      MUST
//      VERIFY
// Example:
//      N/A |
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_NEVER(name, prop, clk, rst, MSG)                                \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_never(prop, clk, rst)) MSG

`define HQM_ASSUMES_NEVER(name, prop, clk, rst, MSG)                                \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_never(prop, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:  eventually holds
// Category: Data Checking
// Description:
//      Once the enable 'en' is high, 'prop' should eventually hold (strong eventually relation).
//      There is no time bound.
//      Thus, the property is violated if 'prop' never holds or if the clock stops ticking.
// Arguments:
//      - en    Sequence   Enabling event. Checking begins each time the sequence 'en' is matched.
//                         In the special case where the sequence is a Boolean, each time the
//                         Boolean is high.
//      - prop  Property   Property that should eventually hold.
// Comments:
//      - HQM_ASSERT_EVENTUALLY_HOLDS is only useful for formal verification.
// Related:
//      NEXT_EVENT
//      REQ_GRANTED
//      UNTIL_STRONG
// Example:
//      TBD |
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_EVENTUALLY_HOLDS(name, en, prop, clk, rst, MSG)                 \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_eventually_holds(en, prop, clk, rst)) MSG

`define HQM_ASSUMES_EVENTUALLY_HOLDS(name, en, prop, clk, rst, MSG)                 \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_eventually_holds(en, prop, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  between
// Category: Stability , Events
// Description:
//      'cond' holds at every sampling point between the two events 'start_ev' and 'end_ev'
//      inclusive. The end event may never occur, in which case 'cond' continues to hold forever.
// Arguments:
//      - start_ev    Sequence   Start checking event. Checking begins each time the sequence
//                               'start_ev' is matched. In the special case where the sequence
//                               is a Boolean, each time the Boolean is high.
//      - end_ev      Property   End event is when 'end_ev' is true.
//      - cond        Property   A property that must be true between 'start_ev' and 'end_ev'.
// Comments:
//      None.
// Related:
//      BETWEEN_TIME
//      BEFORE_EVENT
//      NEXT_EVENT
// Code sample:
//      sequence e;
//        sig1 ##1 !sig1 ##1 sig1;
//      endsequence
//      `HQM_ASSERTS_BETWEEN(between_posedge_clk, e, end_b, cond, posedge clk, rst, `HQM_SVA_ERR_MSG("Bad"));
// Example:
//      Success (start-time:195 and end-time:235) | | images/BETWEEN_1.png
// Example:
//      Failure (start-time:135 and end-time:175) | | images/BETWEEN_2.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_BETWEEN(name, start_ev, end_ev, cond, clk, rst, MSG)            \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_between(start_ev, end_ev, cond, clk, rst)) MSG

`define HQM_ASSUMES_BETWEEN(name, start_ev, end_ev, cond, clk, rst, MSG)            \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_between(start_ev, end_ev, cond, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:   between time
// Category: Stability , Events
// Description:
//       After the triggering event 'trig', 'cond' holds continuously starting at time
//       'start_time' until time 'end_time' (inclusive). Start time 0 is at the last tick
//       of the event 'trig' (or simply at 'trig' if it is a Boolean). Start time 1 is a tick
//       after 'trig' etc. There are no restrictions on 'cond' outside the [start_time, end_time]
//       interval.
// Arguments:
//      - trig        Sequence   Triggering event. Checking begins each time the sequence 'trig'
//                               is matched. In the special case where the sequence is a Boolean,
//                               each time the Boolean is high.
//      - start_time  Number>=0  Starting time greater than or equal to zero.
//      - end_time    Number>=0  Ending time greater than or equal to 'start_time'.
//      - cond        Property   A property that must true between 'start_time' and 'end_time'.
// Comments:
//      - This template is expensive for large start or end times. Use BETWEEN if possible.
// Related:
//      BETWEEN
//      BEFORE_EVENT
//      NEXT_EVENT
// Example:
//       | | images/BETWEEN_TIME_1.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_BETWEEN_TIME(name, trig, start_time, end_time, cond, clk, rst, MSG) \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_between_time(trig, start_time, end_time, cond, clk, rst)) MSG

`define HQM_ASSUMES_BETWEEN_TIME(name, trig, start_time, end_time, cond, clk, rst, MSG) \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_between_time(trig, start_time, end_time, cond, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:   next event
// Category: Events
// Description:
//      If 'en' is high, then the next time that 'ev' holds, property 'prop' must hold as well.
//      'ev' and 'en' can hold simultaneously. 'ev' may never hold
// Arguments:
//      - en      Boolean     Enabler.
//      - ev      Boolean     Sampling event.
//      - prop    Property    Property to be checked.
// Comments:
//      - This template is expensive for large start or end times. Use BETWEEN if possible.
// Related:
//      BEFORE_EVENT
//      BETWEEN
//      UNTIL_STRONG
// Example:
//      TBD |
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_NEXT_EVENT(name, en, ev, prop, clk, rst, MSG)                   \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_next_event(en, ev, prop, clk, rst)) MSG

`define HQM_ASSUMES_NEXT_EVENT(name, en, ev, prop, clk, rst, MSG)                   \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_next_event(en, ev, prop, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:   before event
// Category: Events
// Description:
//      Whenever 'en' holds, 'first' must hold before 'second'. The earliest 'second' can hold
//      is one cycle after 'first' holds. 'first' is not required to hold, in which case 'second'
//      should never hold.
// Arguments:
//      - en       Sequence   Enabling sequence. Checking begins each time the sequence 'en' is
//                            matched. In the special case where the sequence is a Boolean, each
//                            time the Boolean is high.
//      - first    Property   Must be true before 'second' holds. 'first' and 'en' can hold
//                            simutaneously.
//      - second   Property   Cannot hold before 'first' is true.
// Comments:
//      None.
// Related:
//      NEXT_EVENT
//      BETWEEN
//      BETWEEN TIME
//      UNTIL_STRONG
// Example:
//      TBD |
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_BEFORE_EVENT(name, en, first, second, clk, rst, MSG)            \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_before_event(en, first, second, clk, rst)) MSG

`define HQM_ASSUMES_BEFORE_EVENT(name, en, first, second, clk, rst, MSG)            \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_before_event(en, first, second, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:  remain high
// Category: Stability
// Description:
//      Whenever 'sig' rises, it remains high for 'n' additional clocks. The number of clocks 
//      'n' does not include the clock at which 'sig' changed. 'sig' must be high at the 'n'th
//      tick point. Values of 'sig' are only sampled at the clock ticks. The behavior of 'sig'
//      between the clock ticks is not checked.
// Arguments:
//      - sig  Bit-vector  Signal to be checked.
//      - n    Number>0    The minimum number of cycles thoughtout which 'sig' must remain high.
// Comments:
//      - This checker is expensive for a large 'n'. In this case use STABLE if possible (if the
//        signal retains its value between events, rather than throughout a time interval).
// Related:
//      GREMAIN_HIGH
//      REMAIN_LOW
//      GREMAIN_LOW
// Example:
//      In the following example, both sig 1 and sig 2 pass. | | images/REMAIN_HIGH_1.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_REMAIN_HIGH(name, sig, n, clk, rst, MSG)                        \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_remain_high(sig, n, clk, rst)) MSG

`define HQM_ASSUMES_REMAIN_HIGH(name, sig, n, clk, rst, MSG)                        \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_remain_high(sig, n, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  gremain high
// Category: Stability
// Description:
//      Whenever 'sig' rises, it remains high for 'n' additional clocks. The number of clocks
//      'n' does not include the clock at which 'sig' changed. 'sig' must also be high at the
//      'n'th tick point. Values of 'sig' are only sampled at the clock ticks. However, 'sig
//      is required to be high at all times during the 'n' clock ticks, even at the non-tick
//      points of the clock.
// Arguments:
//      - sig  Bit-vector   Signal to be checked.
//      - n    Number>0     The minimum number of cycles throughout which 'sig' must remain high.
// Comments:
//      - This checker is expensive for a large 'n'. In such cases, use GSTABLE if possible
//        (if the signal retains its value between events, rather than throughout a time interval).
// Related:
//      REMAIN_HIGH
//      REMAIN_LOW
//      GREMAIN_LOW
// Example:
//      In the following example, sig 1 passes, while sig 2 fails. | | images/GREMAIN_HIGH_1.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_GREMAIN_HIGH(name, sig, n, clk, rst, MSG)                       \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_gremain_high(sig, n, clk, rst)) MSG

`define HQM_ASSUMES_GREMAIN_HIGH(name, sig, n, clk, rst, MSG)                       \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_gremain_high(sig, n, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  remain low
// Category: Stability
// Description:
//      Whenever 'sig' falls, it remains low for 'n' additional clocks. The number of clocks 'n'
//       does not include the clock at which 'sig' changed. 'sig' must be low at the 'n'th tick
//       point. Values of 'sig' are only sampled at the clock ticks. The behavior of 'sig'
//       between the clock ticks is not checked.
// Arguments:
//       - sig   Bit-vector   Signal to be checked.
//       - n     Number>0     The minimum number of cycles thoughtout which 'sig' must remain low.
// Comments:
//       - This checker is expensive for a large 'n'. In such cases, use STABLE if possible
//         (if the signal retains its value between events, rather than throughout a time interval).
// Related:
//       GREMAIN_LOW
//       REMAIN_HIGH
//       GREMAIN_HIGH
// Example:
//       In the following example, both sig 1 and sig 2 pass.| | images/REMAIN_LOW_1.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_REMAIN_LOW(name, sig, n, clk, rst, MSG)                         \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_remain_high(!(sig), n, clk, rst)) MSG

`define HQM_ASSUMES_REMAIN_LOW(name, sig, n, clk, rst, MSG)                         \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_remain_high(!(sig), n, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  gremain low
// Category: Stability
// Description:
//       Whenever 'sig' falls, it remains low for 'n' additional clocks. The number of clocks
//       'n' does not include the clock at which 'sig' changed. 'sig' must also be low at the
//       'n'th tick point. Values of 'sig' are only sampled at the clock ticks. However, 'sig'
//       is required to be low at all times during the 'n' clock ticks, even at the non-tick
//       points of the clock.
// Arguments:
//       - sig   Bit-vector   Signal to be checked.
//       - n     Number>0     The minimum number of cycles thoughtout which 'sig' must remain low.
// Comments:
//       - This checker is expensive for a large 'n'. In such cases, use GSTABLE if possible
//         (if the signal retains its value between events, rather than throughout a time interval).
// Related:
//       REMAIN_LOW
//       REMAIN_HIGH
//       GREMAIN_HIGH
// Example:
//       In the following example, sig 1 passes, while sig 2 fails. | | images/GREMAIN_LOW_1.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_GREMAIN_LOW(name, sig, n, clk, rst, MSG)                        \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_gremain_high(!(sig), n, clk, rst)) MSG

`define HQM_ASSUMES_GREMAIN_LOW(name, sig, n, clk, rst, MSG)                        \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_gremain_high(!(sig), n, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:   gremain_high_at_most
// Category: Stability
// Description:
//       Whenever 'sig' rises, it remains high for at most 'n' additional clocks, that is 'sig'
//       should fall in no more than 'n' clocks. The number of clocks 'n' does not include the 
//       clock at which 'sig' changed.
//       Values of 'sig' are also checked between the clock ticks.
// Arguments:
//      - sig  Bit-vector   Signal to be checked.
//      - n    Number>=0    The maximal number of cycles thoughtout which 'sig' is allowed 
//                          to remain high.
// Comments:
//      - This checker is expensive for a large 'n'. In such cases, use GSTABLE if possible
//        (if the signal retains its value between events, rather than throughout a time interval).
// Related:
//       REMAIN_LOW
//       GREMAIN_HIGH
//       REMAIN_HIGH
//       GREMAIN_HIGH
//       REMAIN_HIGH_AT_MOST
// Example:
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_GREMAIN_HIGH_AT_MOST(name, sig, n, clk, rst, MSG)               \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_gremain_high_at_most(sig, n, clk, rst)) MSG 

`define HQM_ASSUMES_GREMAIN_HIGH_AT_MOST(name, sig, n, clk, rst, MSG)               \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_gremain_high_at_most(sig, n, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  verify
// Category: Data Checking
// Description:
//      The property 'prop' must always be true.
// Arguments:
//      - prop    Property    The property that must always be true.
// Comments:
//      - When the condition is boolean and clocked, HQM_ASSERTS_MUST is equivalent to HQM_ASSERTS_VERIFY.
// Related:
//      MUST 
//      FORBIDDEN
//      NEVER
// Example:
//      N/A |
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_VERIFY(name, prop, clk, rst, MSG)                               \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_verify(prop, clk, rst)) MSG

`define HQM_ASSUMES_VERIFY(name, prop, clk, rst, MSG)                               \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_verify(prop, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  req granted
// Category: Antecedent/Consequence
// Description:
//       A request is eventually granted. A request is registered when 'req' rises and there
//       is no pending request, or when there is a 'gnt' followed by 'req'. As long as the
//       request is not satisfied, no new requests can be registered.
// Arguments:
//       - req   Boolean   Request signal.
//       - gnt   Boolean   Grant signal.
// Comments:
//       - The property passes if the grant holds at the same time the request is made.
//       - There is no explicit bound by which the request must be granted.
// Related:
//       CONT_REQ_GRANTED
//       REQ_GRANTED_WITHIN
// Code sample:
//       `HQM_ASSERTS_REQ_GRANTED(req_granted_clk, req, gnt, posedge clk, rst, `HQM_SVA_ERR_MSG("Error"));
// Example:
//       success (start-time:51 and end-time:81) | | images/REQ_GRANTED_1.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_REQ_GRANTED(name, req, gnt, clk, rst, MSG)                      \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_req_granted(req, gnt, clk, rst)) MSG

`define HQM_ASSUMES_REQ_GRANTED(name, req, gnt, clk, rst, MSG)                      \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_req_granted(req, gnt, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  cont req granted
// Category: Data Checking , Antecedent/Consequence
// Description:
//       A continuous request is eventually granted. A request is registered when 'req' rises
//       and there is no pending request, or when there is a 'gnt' followed by 'req'. 'req'
//       should remain high as long as the request is not satisfied.
// Arguments:
//       - req  Boolean     Request signal.
//       - gnt  Boolean     Grant signal.
// Comments:
//       - The property passes if the grant holds at the same time the request is made.
//       - There is no explicit bound by which the request must be granted.
// Related:
//       REQ_GRANTED
//       REQ_GRANTED_WITHIN
// Code sample:
//       `HQM_ASSERTS_CONT_REQ_GRANTED(cont_req_granted, req, gnt, clk, rst, `HQM_SVA_ERR_MSG("Error"));
// Example:
//       failure (start-time:75 and end-time:111) | | images/CONT_REQ_GRANTED_1.png
// Example:
//       success (start-time:27 and end-time:63) | | images/CONT_REQ_GRANTED_2.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_CONT_REQ_GRANTED(name, req, gnt, clk, rst, MSG)                 \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_cont_req_granted(req, gnt, clk, rst)) MSG

`define HQM_ASSUMES_CONT_REQ_GRANTED(name, req, gnt, clk, rst, MSG)                 \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_cont_req_granted(req, gnt, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  req granted within
// Category: Antecedent/Consequence
// Description:
//       A request is granted at some sampling point between (and including) the m-th and n-th
//       sampling points after the current point. A single grant may satisfy more than one
//       request, as long as for each request the grant occurs within the m to n interval with
//       respect to that request.
// Arguments:
//       - req  Boolean     Request signal.
//       - m    Number>=0   Starting sampling point.
//       - n    Number>0    Ending sampling point.
//       - gnt  Boolean     Grant signal.
// Comments:
//       - The request does not need to remain pending until it is granted.
//       - This template is expensive for large 'm's or 'n's. Use REQ_GRANTED if possible.
// Related:
//       REQ_GRANTED
//       CONT_REQ_GRANTED
// Code sample:
//       `HQM_ASSERTS_REQ_GRANTED_WITHIN(reg_granted_within_check, req, 3, 6, gnt, clk, rst, `HQM_SVA_ERR_MSG(""));
// Example:
//       failure (start-time:33 and end-time:51) | | images/REQ_GRANTED_WITHIN_1.png
// Example:
//       success (start-time:63 and end-time:87) | | images/REQ_GRANTED_WITHIN_2.png
// Example:
//       failure (start-time:219 and end-time:261) | | images/REQ_GRANTED_WITHIN_3.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_REQ_GRANTED_WITHIN(name, req, min, max, gnt, clk, rst, MSG)     \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_req_granted_within(req, min, max, gnt, clk, rst)) MSG

`define HQM_ASSUMES_REQ_GRANTED_WITHIN(name, req, min, max, gnt, clk, rst, MSG)     \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_req_granted_within(req, min, max, gnt, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  until strong
// Category: Stability
// Description:
//       Whenever 'start_ev' is high, 'cond' must hold until 'end_ev' holds. 'end_ev' must
//       eventually hold. 'cond' is not required to hold at the time 'end_ev' holds.
// Arguments:
//       - start_ev    Sequence   Enabling event. Occurs each time the sequence 'start_ev' is
//                                matched. In the special case where the sequence is a Boolean,
//                                each time the Boolean is high.
//       - cond        Property   A property that must hold until 'end_ev' holds.
//       - end_ev      Property   End event is when the property 'end_ev' is true.
// Comments:
//       - The property passes if 'end_ev' holds at the same time as 'start_ev'.
//       - There is no explicit bound by which 'end_ev' must occur.
// Related:
//       NEXT_EVENT
//       REQ_GRANTED
//       BETWEEN
//       UNTIL_WEAK
// Code sample:
//       `HQM_ASSERTS_UNTIL_STRONG(until_strong_clk, start_bool, sig==8'h10, end_bool, posedge clk, rst, `HQM_SVA_ERR_MSG(""));
// Example:
//       success (start-time:33 and end-time:51) | | images/UNTIL_STRONG_1.png 
// Example:
//       failure (start-time:201 and end-time:213) | | images/UNTIL_STRONG_2.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_UNTIL_STRONG(name, start_ev, cond, end_ev, clk, rst, MSG)       \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_until_strong(start_ev, cond, end_ev, clk, rst)) MSG

`define HQM_ASSUMES_UNTIL_STRONG(name, start_ev, cond, end_ev, clk, rst, MSG)       \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_until_strong(start_ev, cond, end_ev, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:   until weak
// Category: Stability
// Description: 
//       Whenever 'start_ev' is high, formula 'cond' must hold until 'end_ev' holds.
//       Formula 'end_ev' is NOT required to eventually hold, that is, 'cond' may hold forever.
//       Formula 'cond' is not required to hold at the time 'end_ev' holds
// Arguments:
//       - start_ev    Sequence   Enabling event. Occurs each time the sequence 'start_ev' is
//                                matched. In the special case where the sequence is a Boolean,
//                                each time the Boolean is high.
//       - cond        Property   A property that must hold until 'end_ev' holds.
//       - end_ev      Property   End event is when the property 'end_ev' is true.
// Comments:
//       - The property passes if 'end_ev' holds at the same time as 'start_ev'.
//       - There is no explicit bound by which 'end_ev' must occur.
// Related:
//       NEXT_EVENT
//       REQ_GRANTED
//       BETWEEN
//       UNTIL_STRONG
// Code sample:
//       `HQM_ASSERTS_UNTIL_WEAK(until_w_clk, start_bool, sig==8'h1, end_bool, posedge clk, rst, `HQM_SVA_ERR_MSG(""));
// Example:
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_UNTIL_WEAK(name, start_ev, cond, end_ev, clk, rst, MSG)         \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_until_weak(start_ev, cond, end_ev, clk, rst)) MSG

`define HQM_ASSUMES_UNTIL_WEAK(name, start_ev, cond, end_ev, clk, rst, MSG)         \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_until_weak(start_ev, cond, end_ev, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:   recur triggers
// Category: Antecedent/Consequence
// Description:
//       The Boolean 'cond' must hold after at most 'n' repetitions of the event 'trig'.
//       That is, the 'n'-th next time event 'event' occurs without 'cond' being satisfied,
//       'cond' must be satisfied at the completion of that event.
// Arguments:
//       - trig     Boolean    The Boolean that we count its repetitions.
//       - n        Number>0   The number of repetitions counted.
//       - cond     Boolean    The cond that should hold.
// Comments:
//       None.
// Related:
// Example:
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_RECUR_TRIGGERS(name, trig, n, cond, clk, rst, MSG)              \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_recur_triggers(trig, n, cond, clk, rst)) MSG

`define HQM_ASSUMES_RECUR_TRIGGERS(name, trig, n, cond, clk, rst, MSG)              \
    name: assume property( hqm_intel_checkers_pkg::hqm_p_recur_triggers(trig, n, cond, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  data transfer
// Category: Data Checking
// Description:
//      Data is transferred correctly from 'start_ev' to 'end_ev'. That is, 'start_data' when
//      'start_ev' holds must be equal to 'end_data' when 'end_ev' holds. If 'start_ev' holds
//      multiple times before 'end_ev' holds, the value of 'start_data' at the occurrence of the
//      last 'start_ev' must match 'end_data' when 'end_ev' holds.
// Arguments:
//      - start_ev    Boolean     Signal denoting the beginning of the transaction.
//      - start_data  Bit-vector  Data at the beginning of transaction.
//      - end_ev      Boolean     Signal denoting the end of the transaction.
//      - end_data    Bit-vector  Data at the end of transaction.
// Comments:
//      None.
// Related:
//      None.
// Example:
//      TBD |
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_DATA_TRANSFER(name, start_ev, start_data, end_ev, end_data, clk, rst, MSG) \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_data_transfer(start_ev, start_data, end_ev, end_data, clk, rst)) MSG

`define HQM_ASSUMES_DATA_TRANSFER(name, start_ev, start_data, end_ev, end_data, clk, rst, MSG) \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_data_transfer(start_ev, start_data, end_ev, end_data, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  gray code
// Category: Data Checking
// Description:
//      At most one bit in 'sig' can change between any two consecutive clock ticks.
// Arguments:
//      - sig   Bit-vector   Signal to be checked.
// Comments:
//      None.
// Related:
//      None
// Example:
//      TBD |
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_GRAY_CODE(name, sig, clk, rst, MSG)                             \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_gray_code(sig, clk, rst)) MSG

`define HQM_ASSUMES_GRAY_CODE(name, sig, clk, rst, MSG)                             \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_gray_code(sig, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  clock ticking
// Category: Clocks and Resets
// Description:
//      The clock 'clock' is ticking. The clock is only required to tick repeatedly.
// Arguments:
// Comments:
//      - There is no specific pattern the clock is required to follow.
//      - The gclk argument is a reference clock for stability checks.
// Related:
//      None
// Example:
//      TBD |
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_CLOCK_TICKING(name, clk, gclk, MSG)                                   \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_clock_ticking(clk, gclk)) MSG

`define HQM_ASSUMES_CLOCK_TICKING(name, clk, gclk, MSG)                                   \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_clock_ticking(clk, gclk)) MSG


// ****************************************************************************************** //



// --- --- --- Stability Templates --- --- --- //


// ****************************************************************************************** //
// Name:  rigid
// Category: Stability
// Description:
//      Signal 'sig' is considered to be rigid if the first value of 'sig' is determined when
//      the reset becomes low and maintains that value as long as the reset is low.
//      Pay attention, the reset for this template behaves as a lock; when the reset is high,
//      the signal can change its value freely.
// Arguments:
//      - sig    Bit-vector  The signal that should fulfill rigid constraint.
// Comments:
//      - If no 'rst' signal is passed, the default value will be used, and then 'sig' must 
//        retain its value all the time.
// Related:
//      None
// Example:
//      TBD |// 
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_RIGID(name, sig, clk, rst, MSG)                                 \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_rigid(sig, clk, rst)) MSG

`define HQM_ASSUMES_RIGID(name, sig, clk, rst, MSG)                                 \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_rigid(sig, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  stable
// Category: Stability
// Description:
//      Signal 'sig' is stable between the two events 'start_ev' and 'end_ev'. The behavior
//      of 'sig' between the clk ticks *is not* checked.
// Arguments:
//      - sig         Bit-vector  Signal that should remain stable.
//      - start_ev    Sequence    Start checking event. Checking begins each time the sequence
//                                'start_ev' is matched. In the special case where the sequence
//                                is a Boolean, each time the Boolean is high.
//      - end_ev      Property    End event is when 'end_ev' is true.
// Comments:
//      - This template checks the behavior of 'sig' only on specified clock ticks. To check
//        the behavior of 'sig' also between specified clock ticks, use GSTABLE.
// Related:
//      GSTABLE
//      STABLE_POSEDGE
//      STABLE_NEGEDGE
//      STABLE_EDGE
// Example:
//       | | images/STABLE_1a.png
// Code sample:
//      `HQM_ASSERTS_STABLE(stable_clk, sig, write, stop_write, posedge clk, rst, `HQM_SVA_ERR_MSG("Bad!"));
// Example:
//      Success (start-time:33 and end-time:51) | | images/STABLE_1.png
// Example:
//      Failure (start-stime:111 and end-time:135)  | | images/STABLE_2.png
// Code sample:
//     `HQM_ASSERTS_STABLE(stable_edge_clk, sig, write, stop_write, clk, rst, `HQM_SVA_ERR_MSG("Bad!"));
// Example:
//     Failure (start-time:1746 and end-time:1770) | | images/STABLE_3.png
// Example:
//     Failure (start-time:1404 and end-time:1458) | | images/STABLE_4.png
// Code sample:
//    `HQM_ASSERTS_STABLE(stable_posedge_clk, sig, write, write_stop, posedge clk, rst, `HQM_SVA_ERR_MSG("Bad!"));
// Example:
//      Success (start-time:3798 and end-time:3942) | | images/STABLE_5.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_STABLE(name, sig, start_ev, end_ev, clk, rst, MSG)              \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_stable(sig, start_ev, end_ev, clk, rst)) MSG

`define HQM_ASSUMES_STABLE(name, sig, start_ev, end_ev, clk, rst, MSG)              \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_stable(sig, start_ev, end_ev, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  gstable
// Category: Stability
// Description:
//      Signal 'sig' is stable between the two events 'start_ev' and 'end_ev'. The behavior of
//      'sig' between the clk ticks *is not* checked.
// Arguments:
//      - sig        Bit-vector  Signal that should remain stable.
//      - start_ev   Sequence    Start checking event. Checking begins each time the sequence
//                               'start_ev' is matched. In the special case where the sequence
//                               is a Boolean, each time the Boolean is high.
//      - end_ev     Property    End event is when 'end_ev' is true.
// Comments:
// 	- The gclk argument is a reference clock for stability checks.
//      - GSTABLE works correctly only when each clock tick is at least two reference clock ticks.
//      - The lint assertion associated with GSTABLE checks this condition.
//      - To get same functionality using a clock that is represented by a Boolean signal,
//        use STABLE_POSEDGE, STABLE_NEGEDGE, or STABLE_EDGE.
//      - For formal verification this template is also useful as an assumption, since it is
//        easier to debug a counter-example when the signals are stable between user-given events.
// Related:
//      STABLE
//      STABLE_POSEDGE
//      STABLE_NEGEDGE
//      STABLE_EDGE
// Example:
//       | | images/GSTABLE_1.png
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTS_GSTABLE(name, sig, start_ev, end_ev, clk, gclk, rst, MSG)             \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_gstable_ev(sig, start_ev, end_ev, clk, gclk, rst)) MSG

`define HQM_ASSUMES_GSTABLE(name, sig, start_ev, end_ev, clk, gclk, rst, MSG)             \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_gstable_ev(sig, start_ev, end_ev, clk, gclk, rst)) MSG


// ****************************************************************************************** //

// --- --- ---


// ****************************************************************************************** //
// Name:  stable posedge
// Category: Stability
// Description:
//      Signal 'sig' is stable between the two events 'start_ev' and 'end_ev'. The behavior of
//      'sig' between the clk ticks is checked. The clock argument of this template must be a
//      Boolean signal. This template regards the POSEDGE of 'clk' as the clock tick. This is
//      a global-clock based property.
// Arguments:
//      - sig         Bit-vector  Signal that should remain stable.
//      - start_ev    Sequence    Start checking event. Checking begins each time the sequence
//                                'start_ev' is matched. In the special case where the sequence
//                                is a Boolean, each time the Boolean is high.
//      - end_ev      Property    End event is when 'end_ev' is true.
// Comments:
//      - To use this checker, the global clocking should be defined.
//      - To get same functionality using a clock that is represented by an event, use GSTABLE
//      - For formal verification this template is also useful as an assumption, since it is
//        easier to debug a counter-example when the signals are stable between user-given 
//        events.
// Related:
//      GSTABLE
//      STABLE_NEGEDGE
//      STABLE_EDGE
// Example:
//       | | images/STABLE_POSEDGE_1.png
//
// ------------------------------------------------------------------------------------------ //

`ifndef HQM_SVA_LIB_SVA2005

`define HQM_ASSERT_STABLE_POSEDGE(sig, start_ev, end_ev, clk, rst)                  \
   `HQM_ASSERT_GSTABLE(sig, start_ev, end_ev, posedge (clk), rst)			 \	

`define HQM_ASSUME_STABLE_POSEDGE(sig, start_ev, end_ev, clk, rst)                  \
   `HQM_ASSUME_GSTABLE(sig, start_ev, end_ev, posedge (clk), rst)			 \	

`endif
// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  stable negedge
// Category: Stability
// Description:
//      Signal 'sig' is stable between the two events 'start_ev' and 'end_ev'. The behavior of
//      'sig' between the clk ticks is checked. The clock argument of this template must be a
//      Boolean signal. This template regards the NEGEDGE of 'clk' as the clock tick. This is
//      a global-clock based property.
// Arguments:
//      - sig        Bit-vector  Signal that should remain stable.
//      - start_ev   Sequence    Start checking event. Checking begins each time the sequence
//                               'start_ev' is matched. In the special case where the sequence
//                               is a Boolean, each time the Boolean is high.
//      - end_ev     Property    End event is when 'end_ev' is true.
// Comments:
//      - To use this checker, the global clocking should be defined.
//      - To get same functionality using a clock that is represented by an event, use GSTABLE
//      - For formal verification this template is also useful as an assumption, since it is
//        easier to debug a counter-example when the signals are stable between user-given events.
// Related:
//      GSTABLE
//      STABLE_POSEDGE
//      STABLE_EDGE
// Example:
//       | | images/STABLE_NEGEDGE_1.png
//
// ------------------------------------------------------------------------------------------ //

`ifndef HQM_SVA_LIB_SVA2005

`define HQM_ASSERT_STABLE_NEGEDGE(sig, start_ev, end_ev, clk, rst)                  \
   `HQM_ASSERT_GSTABLE(sig, start_ev, end_ev, negedge (clk), rst)                   \

`define HQM_ASSUME_STABLE_NEGEDGE(sig, start_ev, end_ev, clk, rst)                  \
   `HQM_ASSUME_GSTABLE(sig, start_ev, end_ev, negedge (clk), rst)                   \

`endif

// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  stable edge
// Category: Stability
// Description:
//      Signal 'sig' is stable between the two events 'start_ev' and 'end_ev'. The behavior of
//      'sig' between the clk ticks is checked. The clock argument of this template must be a
//      Boolean signal. This template regards every change of 'clk' as a clock tick. This is a
//      global-clock based property.
// Arguments:
//      - sig        Bit-vector  Signal that should remain stable.
//      - start_ev   Sequence    Start checking event. Checking begins each time the sequence
//                               'start_ev' is matched. In the special case where the sequence
//                               is a Boolean, each time the Boolean is high.
//      - end_ev     Property    End event is when 'end_ev' is true.
// Comments:
//      - To use this checker, the global clocking should be defined.
//      - To get same functionality using a clock that is represented by an event, use GSTABLE
// Related:
//      GSTABLE
//      STABLE_POSEDGE
//      STABLE_NEGEDGE
// Example:
//       | | images/STABLE_EDGE_1.png
//
// ------------------------------------------------------------------------------------------ //


`ifndef HQM_SVA_LIB_SVA2005

`define HQM_ASSERT_STABLE_EDGE(sig, start_ev, end_ev, clk, rst)                     \
   `HQM_ASSERT_GSTABLE(sig, start_ev, end_ev, clk, rst)                             \

`define HQM_ASSUME_STABLE_EDGE(sig, start_ev, end_ev, clk, rst)                     \
   `HQM_ASSUME_GSTABLE(sig, start_ev, end_ev, clk, rst)                             \


`endif

// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  stable window
// Category: Stability
// Description:
//      Whenever 'sample' is high, 'sig' must keep its value for 'clks_after' additional clocks
//      after the sampling point, and 'clks_before' clocks before the sampling point. 'sig' is
//      not required to remain stable between the clock ticks.
// Arguments:
//      - sample      Boolean         Sampling signal.
//      - sig         Bit-vector      Signal that should remain stable.
//      - clks_before Number>=0       Number of cycles before the sampling point during which
//                                    'sig' must keep its value.
//      - clks_after  Number>=0       Number of cycles after the sampling point during which
//                                    'sig' must keep its value.
// Comments:
//      - WARNING:  If compiling HQM_SVA_LIB in HQM_SVA2005 mode (not recommended), the value of 0 
//        for clks_before is not allowed and will cause a compile failure.
//      - This template checks the value of 'sig' only on clock ticks; 'sig' is not required to
//        remain stable between the clock ticks.
//      - When 'clks_before' is equal to 0, this template is equivalent to STABLE_AFTER.
// Related:
//      GSTABLE_WINDOW
//      STABLE_AFTER
//      BETWEEN_TIME
// Example:
//       | | images/STABLE_WINDOW_1.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_STABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, rst, MSG) \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_stable_window(sample, sig, clks_before, clks_after, clk, rst)) MSG

`define HQM_ASSUMES_STABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, rst, MSG) \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_stable_window(sample, sig, clks_before, clks_after, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  gstable window
// Category: Stability
// Description:
//      Whenever 'sample' is high, 'sig' must be stable 'clks_after' additional clocks
//      (including) after the sampling point and 'clks_before' clocks (including) before the
//      sampling point. 'sig' must be stable between the clock ticks as well.
// Arguments:
//      - sample      Boolean         Sampling signal.
//      - sig         Bit-vector      Signal that should remain stable.
//      - clks_before Number>=0       Number of cycles before the sampling point during which
//                                    'sig' must keep its value.
//      - clks_after  Number>=0       Number of cycles after the sampling point during which
//                                    'sig' must keep its value.
// Comments:
//      - The gclk argument is a reference clock for stability checks.
//        GSTABLE_WINDOW works correctly only when each clock tick is at least two reference clock
//        ticks. This template checks the value of 'sig' only on clock ticks; 'sig' is required
//      - to remain stable between the clock ticks. When 'clks_before' is equal to 0, this template
//        is equivalent to GSTABLE_AFTER.
// Related:
//      STABLE_WINDOW
//      GSTABLE_AFTER
// Example:
//       | | images/GSTABLE_WINDOW_1.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_GSTABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, gclk, rst, MSG) \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_gstable_window(sample, sig, clks_before, clks_after, clk, gclk, rst)) MSG

`define HQM_ASSUMES_GSTABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, gclk, rst, MSG) \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_gstable_window(sample, sig, clks_before, clks_after, clk, gclk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---

// ****************************************************************************************** //
// Name:  stable for
// Category: Stability
// Description:
//      Whenever 'sig' changes, it must keep its value for n additional clocks. The number of
//      clocks n does not include the clock at which 'sig' changed. 'sig' must be stable at the
//      'n'th tick point. Values of 'sig' are only sampled at the ticks of 'clk'. The change of
//      'sig' should be from one clock tick to another. The behavior of 'sig' between the clock
//      ticks *is not* checked
// Arguments:
//      - sig     Bit-vector  Signal that should remain stable.
//      - n       Number>0    The minimum number of cycles throughout which 'sig' keeps its value.
// Comments:
//      - This checker is expensive for a large n. In this case use, STABLE if possible (if the
//        signal retains its value between events, rather than during a time interval).
// Related:
//      REMAIN_HIGH
//      REMAIN_LOW
//      BETWEEN_TIME
//      GSTABLE_FOR
// Example:
//       | | images/STABLE_FOR_1.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_STABLE_FOR(name, sig, n, clk, rst, MSG)                         \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_stable_for(sig, n, clk, rst)) MSG

`define HQM_ASSUMES_STABLE_FOR(name, sig, n, clk, rst, MSG)                         \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_stable_for(sig, n, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  gstable for
// Category: Stability
// Description:
//      Whenever 'sig' changes, it must keep its value for n additional clocks. The number of
//      clocks n does not include the clock at which 'sig' changed. 'sig' must be stable at the
//      n-th tick point. Values of 'sig' are only sampled at the ticks of 'clk'. The change of
//      'sig' should be from one clock tick to another. However, 'sig' *is* required to be stable
//      at all times during the n clock ticks, even at the non-tick points of the clock.
// Arguments:
//      - sig     Bit-vector  Signal that should remain stable.
//      - n       Number>0    The minimum number of cycles throughout which 'sig' keeps its value.
// Comments:
//      - The gclk argument is a reference clock for stability checks.
//      - This checker is expensive for a large n. In this case use GSTABLE if possible (if the
//        signal retains its value between events, rather than during a time interval).
//      - In formal verification, although the value of 'sig' may be irrelevant between the tick
//        points of 'clk', it is more convenient to examine the counter-example when it is stable.
// Related:
//      STABLE_AFTER
//      GSTABLE_WINDOW
//      STABLE_FOR
// Example:
//       | | images/GSTABLE_FOR_1.png
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_GSTABLE_FOR(name, sig, n, clk, gclk, rst, MSG)                        \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_gstable_for(sig, n, clk, gclk, rst)) MSG

`define HQM_ASSUMES_GSTABLE_FOR(name, sig, n, clk, gclk, rst, MSG)                        \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_gstable_for(sig, n, clk, gclk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  stable after
// Category: Stability
// Description:
//      Whenever sample is high, 'sig' must keep its value for 'clks_after' additional clocks
//      after the sampling point. The behavior of 'sig' between the clock ticks *is* checked.
// Arguments:
//      - sample      Sequence    Sampling event. Sampling begins each time the sequence
//                                'sample' is matched. In the special case where the
//                                sequence is a Boolean, each time the Boolean is high.
//      - sig         Bit-vector  Signal that should remain stable.
//      - clks_after  Number>0    Number of additional cycles after the sampling point
//                                during which 'sig' must keep its value.
// Comments:
//      None.
// Related:
//      GSTABLE_AFTER
//      STABLE_WINDOW
//      STABLE_FOR
// Example:
//       | | images/STABLE_AFTER_1.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_STABLE_AFTER(name, sample, sig, clks_after, clk, rst, MSG)      \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_stable_after(sample, sig, clks_after, clk, rst)) MSG

`define HQM_ASSUMES_STABLE_AFTER(name, sample, sig, clks_after, clk, rst, MSG)      \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_stable_after(sample, sig, clks_after, clk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  gstable after
// Category: Stability
// Description:
//      Whenever sample is high, 'sig' must keep its value for 'clks_after' additional clocks
//      after the sampling point. The behavior of 'sig' between the clock ticks *is* checked.
// Arguments:
//      - sample      Sequence    Sampling event. Sampling begins each time the sequence
//                                'sample' is matched. In the special case where the sequence
//                                is a Boolean, each time the Boolean is high.
//      - sig         Bit-vector  Signal that should remain stable.
//      - clks_after  Number>0    Number of additional cycles after the sampling point during
//                                which 'sig' must keep its value.
// Comments:
//      - The gclk argument is a reference clock for stability checks.
// Related:
//      TBD
// Example:
//       | | images/GSTABLE_AFTER_1.png
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_GSTABLE_AFTER(name, sample, sig, clks_after, clk, gclk, rst, MSG)     \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_gstable_after(sample, sig, clks_after, clk, gclk, rst)) MSG

`define HQM_ASSUMES_GSTABLE_AFTER(name, sample, sig, clks_after, clk, gclk, rst, MSG)     \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_gstable_after(sample, sig, clks_after, clk, gclk, rst)) MSG


// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  gstable between ticks
// Category: Stability
// Description:
//      Signal 'sig' is stable between every two clock events. The value of 'sig' can only
//      change at a clock event (i.e. when 'sig' is sampled). The value of 'sig' at event 'i'
//      should hold until event 'i+1' (exclusively). The clock argument of this template must
//      be an event (e.g. a signal with an edge specifier).
// Arguments:
//      - sig     Bit-vector  Signal that should remain stable.
// Comments:
//      - The gclk argument is a reference clock for stability checks.
//      - To get same functionality using a clock that is represented by a Boolean signal, use
//        STABLE_BETWEEN_TICKS_POSEDGE, STABLE_BETWEEN_TICKS_NEGEDGE, or STABLE_BETWEEN_TICKS_EDGE.
//      - For formal verification this template is also useful as an assumption, since it is easier
//        to debug a counter-example when the signals are stable between clock ticks.
//      - Pay attention: A clock tick is needed in order to start checking, i.e, the signal is 
//        not checked for stability starting from point where the reset becomes in-active, until
//        the first clock tick.
// Related:
//      STABLE
//      GSTABLE_BETWEEN_TICKS
//      STABLE_BETWEEN_TICKS_POSEDGE
//      STABLE_BETWEEN_TICKS_NEGEDGE
//      STABLE_BETWEEN_TICKS_EDGE
// Example:
//      TBD |
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_GSTABLE_BETWEEN_TICKS(name, sig, clk, gclk, rst, MSG)                 \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_gstable_between_ticks_ev(sig, clk, gclk, rst)) /* novas s-70517 */ MSG

`define HQM_ASSUMES_GSTABLE_BETWEEN_TICKS(name, sig, clk, gclk, rst, MSG)                 \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_gstable_between_ticks_ev(sig, clk, gclk, rst)) /* novas s-70517 */ MSG


// ****************************************************************************************** //



// --- --- ---



// ****************************************************************************************** //
// Name:  stable between ticks posedge
// Category: Stability
// Description:
//      Signal 'sig' is stable between every two 'clk' ticks. The value of 'sig' can only
//      change at a 'clk' tick (i.e. when 'sig' is sampled). The value of 'sig' at tick 'i'
//      should hold until tick 'i+1' (exclusively). The clock argument of this template must be
//      a Boolean signal. This version regards the POSEDGE of 'clk' as the clock tick. This is
//      a global-clock based property.
// Arguments:
//      - sig     Bit-vector  Signal that should remain stable.
//      - clk     Boolean     clk is treated as regular signal.
// Comments:
//      - To use this checker, the global clocking should be defined.
//      - To get same functionality using a clock that is represented by an event use
//        GSTABLE_BETWEEN_TICKS. For formal verification this template is also useful as an assumption,
//        since it is easier to debug a counter-example when the signals are stable between clock ticks.
//      - This template immitates the clock behaviour by itself.
// Related:
//      STABLE
//      GSTABLE_BETWEEN_TICKS
//      STABLE_BETWEEN_TICKS_NEGEDGE
//      STABLE_BETWEEN_TICKS_EDGE
// Example:
//      TBD |
//
// ------------------------------------------------------------------------------------------ //

`define HQM_ASSERTS_STABLE_BETWEEN_TICKS_POSEDGE(name, sig, clk, rst, MSG)                         \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_stable_between_ticks_posedge(sig, clk, rst)) /* novas s-70517 */ MSG

`define HQM_ASSUMES_STABLE_BETWEEN_TICKS_POSEDGE(name, sig, clk, rst, MSG)                         \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_stable_between_ticks_posedge(sig, clk, rst)) /* novas s-70517 */ MSG

// ****************************************************************************************** //



// --- --- ---


// ****************************************************************************************** //
// Name:  stable between ticks negedge
// Category: Stability
// Description:
//      Signal 'sig' is stable between every two 'clk' ticks. The value of 'sig' can only change
//      at a 'clk' tick (i.e. when 'sig' is sampled). The value of 'sig' at tick 'i' should hold
//      until tick 'i+1' (exclusively). The clock argument of this template must be a Boolean
//      signal. This version regards the NEGEDGE of 'clk' as the clock tick. This is a global-clock
//      based property.
// Arguments:
//      - sig     Bit-vector  Signal that should remain stable.
//      - clk     Boolean     clk is treated as regular signal.
// Comments:
//      - To use this checker, the global clocking should be defined.
//      - To get same functionality using a clock that is represented by an event use
//        GSTABLE_BETWEEN_TICKS. For formal verification this template is also useful as an
//        assumption, since it is easier to debug a counter-example when the signals are stable
//        between clock ticks. This template immitates the clock behaviour by itself.
// Related:
//      STABLE
//      GSTABLE_BETWEEN_TICKS
//      STABLE_BETWEEN_TICKS_POSEDGE
//      STABLE_BETWEEN_TICKS_EDGE
// Example:
//      TBD |
//
// ------------------------------------------------------------------------------------------ //


`define HQM_ASSERTS_STABLE_BETWEEN_TICKS_NEGEDGE(name, sig, clk, rst, MSG)                         \
   name: assert property( hqm_intel_checkers_pkg::hqm_p_stable_between_ticks_negedge(sig, clk, rst)) /* novas s-70517 */ MSG

`define HQM_ASSUMES_STABLE_BETWEEN_TICKS_NEGEDGE(name, sig, clk, rst, MSG)                         \
   name: assume property( hqm_intel_checkers_pkg::hqm_p_stable_between_ticks_negedge(sig, clk, rst)) /* novas s-70517 */ MSG


// ****************************************************************************************** //


// --- --- ---


// ***********Currently not supported******************************************************** //
// Name:   transaction length
// Description:
//       Check that a transaction delimited by start_ev and end_ev lasts at least min cycles
//       and at most max cycles.
// Arguments:
//       start_ev   Formula
//       end_ev     Boolean
//       min        Signal or constant
//       max        Signal or constant
// Comments:
// Related:
// Example:
//
// ------------------------------------------------------------------------------------------ //
//
//`define HQM_ASSERT_TRANSACTION_LENGTH (start_ev, end_ev, min , max, clk , rst)    \
//   assert property( hqm_p_transaction_length(start_ev, end_ev, min , max, clk , rst)
//
//`define HQM_ASSUME_TRANSACTION_LENGTH (start_ev, end_ev, min , max, clk , rst)    \
//   assume property( hqm_p_transaction_length(start_ev, end_ev, min , max, clk , rst)
//
//`ifndef HQM_SVA_LIB_OLD_FORMAT
//
//`define HQM_ASSERTS_TRANSACTION_LENGTH (name, start_ev, end_ev, min , max, clk , rst, MSG) \
//   name: `HQM_ASSERT_TRANSACTION_LENGTH (start_ev, end_ev, min , max, clk , rst) MSG
//
//`define HQM_ASSUMES_TRANSACTION_LENGTH (name, start_ev, end_ev, min , max, clk , rst, MSG) \
//   name: `HQM_ASSUME_TRANSACTION_LENGTH (start_ev, end_ev, min , max, clk , rst) MSG
//
//`endif
//
// ****************************************************************************************** //



// --- --- ---


// **********Currently not supported********************************************************** //
// Name:   tagged request granted
// Description:
//       A tagged request is eventually granted with a signal having same tag.
//       The request does not need to remain pending until it is granted
// Arguments:
//       req       Formula
//       gnt       Formula
//       req_tag   Bit-vector
//       gnt_tag   Bit-vector
//
// ------------------------------------------------------------------------------------------ //
//
//`define HQM_ASSERT_TAGGED_REQ_GRANTED(req, req_tag, gnt, gnt_tag, clk, rst)       \
//   assert property( tagged_req_granted(req, req_tag, gnt, gnt_tag, clk, rst)) 
//
//`define HQM_ASSUME_TAGGED_REQ_GRANTED(req, req_tag, gnt, gnt_tag, clk, rst)       \
//   assume property( tagged_req_granted(req, req_tag, gnt, gnt_tag, clk, rst)) 
//
//`ifndef HQM_SVA_LIB_OLD_FORMAT
//
//`define HQM_ASSERTS_TAGGED_REQ_GRANTED(name, req, req_tag, gnt, gnt_tag, clk, rst, MSG) \
//   name:  `HQM_ASSERT_TAGGED_REQ_GRANTED(req, req_tag, gnt, gnt_tag, clk, rst) MSG
//
//`define HQM_ASSUMES_TAGGED_REQ_GRANTED(name, req, req_tag, gnt, gnt_tag, clk, rst, MSG) \
//   name:  `HQM_ASSUME_TAGGED_REQ_GRANTED(req, req_tag, gnt, gnt_tag, clk, rst) MSG
//
//`endif
//
// ****************************************************************************************** //




