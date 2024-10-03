//=====================================================================================================================
//
// DEVTLB_intel_checkers_core_imp.sv
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



// X/Z checking 
`ifndef SVA_LIB_IGNOREXZ
    `define HQM_DEVTLB_SVA_LIB_KNOWN(sig) (!($isunknown({<<{sig}})))
`else
    `define HQM_DEVTLB_SVA_LIB_KNOWN(sig) (1)
`endif

// --- --- Let Statements --- --- //

`define HQM_DEVTLB_l_mutexed(sig)  ($onehot0({<<{``sig``}}) && `HQM_DEVTLB_SVA_LIB_KNOWN(``sig``))
`define HQM_DEVTLB_l_at_most_bits_high(sig, n) (($countones({<<{``sig``}}) <= ``n``) & `HQM_DEVTLB_SVA_LIB_KNOWN(``sig``))
`define HQM_DEVTLB_l_at_most_bits_low(sig, n) ($countones(``sig``) >= ($countones(``sig``|'1) - ``n``))
`define HQM_DEVTLB_l_bits_high(sig, n) (($countones({<<{``sig``}}) == ``n``) & `HQM_DEVTLB_SVA_LIB_KNOWN(``sig``))
`define HQM_DEVTLB_l_bits_low(sig, n) (($countones(``sig``) == ($countones(``sig``|'1) - ``n``)) & `HQM_DEVTLB_SVA_LIB_KNOWN(``sig``))
`define HQM_DEVTLB_l_same_bits(sig) ((&(``sig``)) || !(|(``sig``)) & `HQM_DEVTLB_SVA_LIB_KNOWN(``sig``))
`define HQM_DEVTLB_l_one_hot(sig)  ($onehot({<<{``sig``}}) && `HQM_DEVTLB_SVA_LIB_KNOWN(``sig``))
`define HQM_DEVTLB_l_known_driven(sig)  `HQM_DEVTLB_SVA_LIB_KNOWN(``sig``)
`define HQM_DEVTLB_l_forbidden(cond)  (!(``cond``))
`define HQM_DEVTLB_l_must(prop)  (``prop``)
`define HQM_DEVTLB_l_range(sig, low, high)  (((``sig``) >= (``low``)) & ((``sig``) <= (``high``)))
`define HQM_DEVTLB_l_max_value(sig, max_val)  ((``sig``) <= (``max_val``))
`define HQM_DEVTLB_l_min_value(sig, min_val)  ((``sig``) >= (``min_val``))
`define HQM_DEVTLB_l_same(siga, sigb)  ((``siga``) == (``sigb``))


`define HQM_DEVTLB_SVA_LIB_SAME(siga,sigb) ((siga) == (sigb))


// --- --- Assumption Properties --- --- //

property DEVTLB_p_max_value(sig, max_val, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
     @(clk) disable iff(rst) `HQM_DEVTLB_l_max_value(sig, max_val);
endproperty : DEVTLB_p_max_value

property DEVTLB_p_min_value(sig, min_val, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
     @(clk) disable iff(rst) `HQM_DEVTLB_l_min_value(sig, min_val);
endproperty : DEVTLB_p_min_value

property DEVTLB_p_mutexed(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
     @(clk) disable iff(rst) `HQM_DEVTLB_l_mutexed(sig);
endproperty : DEVTLB_p_mutexed

property DEVTLB_p_one_hot(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
     @(clk) disable iff(rst) `HQM_DEVTLB_l_one_hot(sig);
endproperty : DEVTLB_p_one_hot

property DEVTLB_p_same_bits(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
     @(clk) disable iff(rst) `HQM_DEVTLB_l_same_bits(sig);
endproperty : DEVTLB_p_same_bits

property DEVTLB_p_range(sig, low, high, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
     @(clk) disable iff(rst) `HQM_DEVTLB_l_range(sig, low, high);
endproperty : DEVTLB_p_range

property DEVTLB_p_at_most_bits_high(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
     @(clk) disable iff(rst) `HQM_DEVTLB_l_at_most_bits_high(sig, n);
endproperty : DEVTLB_p_at_most_bits_high

property DEVTLB_p_at_most_bits_low(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
     @(clk) disable iff(rst) `HQM_DEVTLB_l_at_most_bits_low(sig, n);
endproperty : DEVTLB_p_at_most_bits_low

property DEVTLB_p_bits_high(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
     @(clk) disable iff(rst) `HQM_DEVTLB_l_bits_high(sig, n);
endproperty : DEVTLB_p_bits_high

property DEVTLB_p_forbidden(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @(clk) disable iff(rst) `HQM_DEVTLB_l_forbidden(sig);
endproperty : DEVTLB_p_forbidden

property DEVTLB_p_must(prop, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @(clk) disable iff(rst) `HQM_DEVTLB_l_must(prop);
endproperty : DEVTLB_p_must

property DEVTLB_known_driven (sig,  clk=`HQM_DEVTLB_default_clk, rst=1'b0) ;
  @(clk) disable iff (rst) (!($isunknown(sig))) ;
endproperty : DEVTLB_known_driven

property DEVTLB_p_known_driven(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @(clk) disable iff(rst) `HQM_DEVTLB_l_known_driven(sig);
endproperty : DEVTLB_p_known_driven

property DEVTLB_p_same(siga, sigb, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @(clk) disable iff(rst) `HQM_DEVTLB_l_same(siga, sigb);
endproperty : DEVTLB_p_same

property DEVTLB_p_bits_low(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
   @clk disable iff(rst) `HQM_DEVTLB_l_bits_low(sig, n);
endproperty : DEVTLB_p_bits_low

//   --- --- --- Currently not supported in let statements --- --- --- //

//property one_of(sig, set, clk=`DEVTLB_default_clk, rst=1'b0);
//     @(clk) disable iff(rst) ((sig) inside set);
//endproperty : p_one_of

//property one_of(sig, set, clk=`DEVTLB_default_clk, rst=1'b0);
//     @(clk) disable iff(rst) one_of(sig, set);
//endproperty : p_one_of

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- //




// --- --- ---Cover Properties --- --- --- //


property DEVTLB_p_cover_mutexed(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
   @clk !rst && `HQM_DEVTLB_l_mutexed(sig);
endproperty : DEVTLB_p_cover_mutexed

property DEVTLB_p_not_mutexed_covered(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
   @clk !rst && !(`HQM_DEVTLB_l_mutexed(sig));
endproperty : DEVTLB_p_not_mutexed_covered

property DEVTLB_p_cover_one_hot(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst && `HQM_DEVTLB_l_one_hot(sig);
endproperty : DEVTLB_p_cover_one_hot

property DEVTLB_p_not_one_hot_cover(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst && !(`HQM_DEVTLB_l_one_hot(sig));
endproperty : DEVTLB_p_not_one_hot_cover

property DEVTLB_p_cover_same_bits(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk  !rst && `HQM_DEVTLB_l_same_bits(sig);
endproperty : DEVTLB_p_cover_same_bits

property DEVTLB_p_not_same_bits_cover(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk  !rst && !(`HQM_DEVTLB_l_same_bits(sig));
endproperty : DEVTLB_p_not_same_bits_cover

property DEVTLB_p_cover_range(sig, low, high, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk  !rst && `HQM_DEVTLB_l_range(sig, low, high);
endproperty : DEVTLB_p_cover_range

property DEVTLB_p_not_range_cover(sig, low, high, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk  !rst && !(`HQM_DEVTLB_l_range(sig, low, high));
endproperty : DEVTLB_p_not_range_cover

property DEVTLB_p_cover_at_most_bits_high(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk  !rst &&  `HQM_DEVTLB_l_at_most_bits_high(sig, n);
endproperty : DEVTLB_p_cover_at_most_bits_high

property DEVTLB_p_not_at_most_bits_high_cover(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk  !rst &&  !(`HQM_DEVTLB_l_at_most_bits_high(sig, n));
endproperty : DEVTLB_p_not_at_most_bits_high_cover

property DEVTLB_p_cover_at_most_bits_low(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk  !rst &&  `HQM_DEVTLB_l_at_most_bits_low(sig, n);
endproperty : DEVTLB_p_cover_at_most_bits_low

property DEVTLB_p_not_at_most_bits_low_cover(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk  !rst &&  !(`HQM_DEVTLB_l_at_most_bits_low(sig, n));
endproperty : DEVTLB_p_not_at_most_bits_low_cover

property DEVTLB_p_cover_bits_high(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst && `HQM_DEVTLB_l_bits_high(sig, n);
endproperty : DEVTLB_p_cover_bits_high

property DEVTLB_p_not_bits_high_cover(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst && !(`HQM_DEVTLB_l_bits_high(sig, n));
endproperty : DEVTLB_p_not_bits_high_cover

property DEVTLB_p_cover_known_driven(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst && `HQM_DEVTLB_l_known_driven(sig);
endproperty : DEVTLB_p_cover_known_driven

property DEVTLB_p_no_known_driven_cover(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst && !(`HQM_DEVTLB_l_known_driven(sig));
endproperty : DEVTLB_p_no_known_driven_cover

property DEVTLB_p_cover_same(siga, sigb, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst && `HQM_DEVTLB_l_same(siga, sigb);
endproperty : DEVTLB_p_cover_same

property DEVTLB_p_not_same_cover(siga, sigb, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst && !(`HQM_DEVTLB_l_same(siga, sigb));
endproperty : DEVTLB_p_not_same_cover

property DEVTLB_p_cover_max_value(sig, max_val, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst &&  `HQM_DEVTLB_l_max_value(sig, max_val);
endproperty : DEVTLB_p_cover_max_value

property DEVTLB_p_not_max_value_cover(sig, max_val, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst && !(`HQM_DEVTLB_l_max_value(sig, max_val));
endproperty : DEVTLB_p_not_max_value_cover

property DEVTLB_p_cover_min_value(sig, min_val, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst &&  `HQM_DEVTLB_l_min_value(sig, min_val);
endproperty : DEVTLB_p_cover_min_value

property DEVTLB_p_not_min_value_cover(sig, min_val, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst && !(`HQM_DEVTLB_l_min_value(sig, min_val));
endproperty : DEVTLB_p_not_min_value_cover

property DEVTLB_p_cover_bits_low(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst && `HQM_DEVTLB_l_bits_low(sig, n);
endproperty : DEVTLB_p_cover_bits_low

property DEVTLB_p_not_bits_low_cover(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
  @clk !rst &&  !(`HQM_DEVTLB_l_bits_low(sig, n));
endproperty : DEVTLB_p_not_bits_low_cover


//   --- --- --- Currently not supported in let statements --- --- --- //

//property cover_one_of(sig, set, clk=`DEVTLB_default_clk, rst=1'b0);
//  @clk !rst && `l_one_of(sig, set);
//endproperty : p_cover_one_of


//property no_one_of_cover(sig, set, clk=`DEVTLB_default_clk, rst=1'b0);
//  @clk !rst && !(`l_one_of(sig, set));
//endproperty : p_no_one_of_cover

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- //






// --- --- Sequential Properties --- --- //


property DEVTLB_p_trigger(trig, prop, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) trig |-> prop;
endproperty : DEVTLB_p_trigger


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_delayed_trigger(trig, delay, prop, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) trig |-> nexttime[delay] prop;
endproperty : DEVTLB_p_delayed_trigger

`else

property DEVTLB_p_delayed_trigger(trig, delay, prop, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) trig |-> ##delay prop;
endproperty : DEVTLB_p_delayed_trigger

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_never(prop, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) not(strong(prop));
endproperty : DEVTLB_p_never

`else

property DEVTLB_p_never(prop, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) not(prop);
endproperty : DEVTLB_p_never

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_eventually_holds(en, prop, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) en |-> s_eventually prop;
endproperty : DEVTLB_p_eventually_holds

`else

property DEVTLB_p_eventually_holds(en, prop, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) en |-> ##[0:$] prop;
endproperty : DEVTLB_p_eventually_holds

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_between(start_ev, end_ev, cond, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) start_ev |-> cond until_with end_ev;
endproperty : DEVTLB_p_between

`else

property DEVTLB_p_between(start_ev, end_ev, cond, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) start_ev ##0 !(end_ev && cond)[*1:$] |-> cond;
endproperty : DEVTLB_p_between

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_between_time(trig, start_time, end_time, cond, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) trig |-> always [start_time:end_time] cond;
endproperty : DEVTLB_p_between_time

`else

property DEVTLB_p_between_time(trig, start_time, end_time, cond, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst)
        trig |-> ##start_time (cond[*(end_time-start_time+1)]);
endproperty : DEVTLB_p_between_time

`endif


// --- --- ---


property DEVTLB_p_next_event(en, ev, prop, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) en ##0 ev[->1] |-> prop;
endproperty : DEVTLB_p_next_event


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_before_event(en, first, second, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) en |-> (not strong(second)) until_with first;
endproperty : DEVTLB_p_before_event

`else

property DEVTLB_p_before_event(en, first, second, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) en ##0 (!first[*1:$] or first[->1]) |-> not second;
endproperty : DEVTLB_p_before_event

`endif


// --- --- ---

property DEVTLB_p_remain_high(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) !sig ##1 sig |=> sig[*n];
endproperty : DEVTLB_p_remain_high


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_gremain_high(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
   @clk disable iff(rst) !sig ##1 sig |-> reject_on(!sig) @clk 1'b1[*n];
endproperty : DEVTLB_p_gremain_high

`else

property DEVTLB_p_gremain_high(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) 1;
endproperty : DEVTLB_p_gremain_high

`endif


// --- --- ---


property DEVTLB_p_remain_low(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @clk disable iff(rst) sig ##1 !sig |=> !sig[*n];
endproperty : DEVTLB_p_remain_low


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_gremain_low(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) sig ##1 !sig |=> reject_on(sig) @clk 1'b1 [*n];
endproperty : DEVTLB_p_gremain_low

`else

property DEVTLB_p_gremain_low(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) 1;
endproperty : DEVTLB_p_gremain_low

`endif

// --- --- ---


property DEVTLB_p_verify(prop, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) prop;
endproperty : DEVTLB_p_verify


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_req_granted(req, gnt, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) (gnt || !req) ##1 req |-> s_eventually (gnt);
endproperty : DEVTLB_p_req_granted

`else

property DEVTLB_p_req_granted(req, gnt, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff (rst)
    (gnt || !req) ##1 req |-> gnt[->1];
endproperty : DEVTLB_p_req_granted

`endif



// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_cont_req_granted(req, gnt, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst)
    (gnt || !req) ##1 req |-> strong(req throughout gnt[->1]);
endproperty : DEVTLB_p_cont_req_granted

`else

property DEVTLB_p_cont_req_granted(req, gnt, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff (rst)
    (gnt || !req) ##1 req |-> req throughout gnt[->1];
endproperty : DEVTLB_p_cont_req_granted

`endif


// --- --- ---


property DEVTLB_p_req_granted_within(req, min, max, gnt, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst)
`ifdef FPV
    (gnt || !req) ##1 req |-> ##[min:max] gnt;
`elsif INTEL_EMULATION
    (gnt || !req) ##1 req |-> ##[min:max] gnt;
`else
    (gnt || !req) ##1 req |-> 1'b1[*min+1:max+1] intersect gnt[->1];
`endif
endproperty : DEVTLB_p_req_granted_within



// --- --- ---


// The following is not currently supported by FPV
`ifndef HQM_DEVTLB_SVA_LIB_SVA2005
property DEVTLB_p_tagged_req_granted(req, req_tag, gnt, gnt_tag, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    logic [$bits(req_tag)-1:0] tag;
   (req, tag = req_tag) |-> strong(##[0:$] (gnt && gnt_tag == tag));
endproperty : DEVTLB_p_tagged_req_granted

`else

property DEVTLB_p_tagged_req_granted(req, req_tag, gnt, gnt_tag, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) 1;
endproperty : DEVTLB_p_tagged_req_granted

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_until_strong(start_ev, cond, end_ev, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst)
    start_ev |-> cond s_until end_ev;
endproperty : DEVTLB_p_until_strong

`else

property DEVTLB_p_until_strong(start_ev, cond, end_ev, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff (rst)
    start_ev |-> cond[*0:$] ##1 end_ev;
endproperty : DEVTLB_p_until_strong

`endif


// --- --- ---


property DEVTLB_p_recur_triggers(trig, n, cond, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst)
     not( !cond throughout (trig ##1 trig[->(n-1)]) );
endproperty : DEVTLB_p_recur_triggers


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_gray_code(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst)  nexttime $onehot0(sig ^ $past(sig));
endproperty : DEVTLB_p_gray_code

`else

property DEVTLB_p_gray_code(sig, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst)  ##1 $onehot0(sig ^ $past(sig));
endproperty : DEVTLB_p_gray_code

`endif


// --- --- ---


property DEVTLB_p_data_transfer(start_ev, start_data, end_ev, end_data, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    logic [$bits(start_data)-1:0] local_data;
    @(clk) disable iff(rst)
    (start_ev, local_data = start_data) ##0
      (end_ev or (!end_ev ##1 (!start_ev throughout end_ev[->1])))
             |-> (local_data == end_data);
endproperty : DEVTLB_p_data_transfer



// --- --- ---


property DEVTLB_p_cov_seq(seq, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) !rst throughout (seq);
endproperty : DEVTLB_p_cov_seq

// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_clock_ticking(clk);
    @($global_clock) s_eventually $changing_gclk(clk);
endproperty : DEVTLB_p_clock_ticking

`else

`ifdef DEVTLB_SYS_CLK

property DEVTLB_p_clock_ticking(clk);
    @(`DEVTLB_SYS_CLK) !$stable(clk)[->1];
endproperty : DEVTLB_p_clock_ticking

`else

property DEVTLB_p_clock_ticking(clk);
    1;
endproperty : DEVTLB_p_clock_ticking

`endif

`endif

// --- --- ---


// --- --- Currently Not Supported --- --- //

//property transaction_length(start_ev, end_ev, min = 0, max, clk = `DEVTLB_default_clk, rst=1'b0);
//    logic [$bits(max) -1 :0] ctr;
//    (start_ev, ctr = 0) ##1 (!end_ev && !start_ev, ctr = ctr + 1) [*0:$] ##1
//    !start_ev && (end_ev  || ctr > max) |-> min + 1 <= ctr && ctr < max;
//endproperty : p_transaction_length


//property fsm_never_stuck(state, values, clk=`DEVTLB_default_clk, rst=1'b0);
//    @(clk) disable iff(rst)
//    !($stable(state)) && (state inside values);
//endproperty : p_fsm_never_stuck


//property simple_rst(rst, n, clk=`DEVTLB_default_clk);
//    @(clk) rst[*n] #=# always !rst;
//endproperty : p_simple_rst


// --- --- --- Stability Properties --- --- --- //


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_stable(sig, start_ev, end_ev, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) start_ev |=> $stable(sig) until_with end_ev;
endproperty : DEVTLB_p_stable

`else

property DEVTLB_p_stable(sig, start_ev, end_ev, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst)
        start_ev
        ##1 !(end_ev && $stable(sig))[*1:$]
              |-> $stable(sig);
endproperty : DEVTLB_p_stable

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_gstable_ev(sig, start_ev, end_ev, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) start_ev |->
        @($global_clock) nexttime reject_on($changed_gclk(sig)) @clk 1'b1 until_with end_ev;
endproperty : DEVTLB_p_gstable_ev

`else

property DEVTLB_p_gstable_ev(sig, start_ev, end_ev, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) 1;
endproperty : DEVTLB_p_gstable_ev

`endif


// --- --- ---

`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_gstable_sig(sig, start_ev, end_ev, clk, rst=1'b0);
   @(clk)  1;
endproperty : DEVTLB_p_gstable_sig

`else

`ifdef DEVTLB_SYS_CLK

property DEVTLB_p_gstable_sig(sig, start_ev, end_ev, clk, rst=1'b0);
    @(`DEVTLB_SYS_CLK) disable iff(rst)
    start_ev ##1 clk
     ##1
       (!(clk && $past(end_ev) && ($past(sig)==$past(sig,2)))[*1:$])
             |-> ($past(sig)==$past(sig,2));
endproperty : DEVTLB_p_gstable_sig

`else 

property DEVTLB_p_gstable_sig(sig, start_ev, end_ev, clk, rst=1'b0);
   @(clk)  1;
endproperty : DEVTLB_p_gstable_sig


`endif

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_stable_window(sample, sig, win_start, win_end, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) nexttime[win_start] sample implies ##1 $stable(sig)[*win_end + win_start];
endproperty : DEVTLB_p_stable_window

`else

sequence DEVTLB_stable_before_s(sig, clks_before, clk, rst=1'b0);
    @(clk) !rst throughout(##1 $stable(sig)[*clks_before-1]);
endsequence : DEVTLB_stable_before_s

property DEVTLB_p_stable_window(sample, sig, clks_before, clks_after, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) sample
        |-> DEVTLB_stable_before_s(sig, clks_before, clk, rst).ended ##1
                ($stable(sig)[*clks_after]);
endproperty : DEVTLB_p_stable_window

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_gstable_window(sample, sig, win_start, win_end, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @clk disable iff(rst) nexttime[win_start] sample implies
        @($global_clock) nexttime[1] reject_on($changed_gclk(sig)) @clk 1'b1[*win_end + win_start];
endproperty : DEVTLB_p_gstable_window

`else

property DEVTLB_p_gstable_window(sample, sig, win_start, win_end, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) 1;
endproperty : DEVTLB_p_gstable_window

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005


property DEVTLB_p_stable_for(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) ##1 $changed(sig) |=> $stable(sig)[*n];
endproperty : DEVTLB_p_stable_for

`else

property DEVTLB_p_stable_for(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) ##1 !$stable(sig) |=> $stable(sig)[*n];
endproperty : DEVTLB_p_stable_for

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_gstable_for(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) ##1 $changed(sig) |->
            @($global_clock) nexttime reject_on($changed_gclk(sig)) @(clk) 1'b1[*n];
endproperty : DEVTLB_p_gstable_for

`else

property DEVTLB_p_gstable_for(sig, n, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) 1;
endproperty : DEVTLB_p_gstable_for

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_stable_after(sample, sig, clks_after, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) sample |=> $stable(sig)[*clks_after];
endproperty : DEVTLB_p_stable_after

`else

property DEVTLB_p_stable_after(sample, sig, clks_after, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) sample
        |=> ($stable(sig)[*clks_after]);
endproperty : DEVTLB_p_stable_after

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_gstable_after(sample, sig, clks_after, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) disable iff(rst) sample |->
        @($global_clock) nexttime reject_on($changed_gclk(sig)) @(clk) 1'b1[*clks_after];
endproperty : DEVTLB_p_gstable_after

`else

property DEVTLB_p_gstable_after(sample, sig, clks_after, clk=`HQM_DEVTLB_default_clk, rst=1'b0);
    @(clk) 1;
endproperty : DEVTLB_p_gstable_after

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_stable_between_ticks(sig, clk=`HQM_DEVTLB_default_clk,rst=1'b0);
    @(clk) disable iff(rst) 1'b1 |-> @($global_clock) nexttime[2]
        reject_on($changed_gclk(sig)) @(clk) 1'b1;
endproperty : DEVTLB_p_stable_between_ticks

`else

`ifdef DEVTLB_SYS_CLK

property DEVTLB_p_stable_between_ticks(sig, clk, rst=1'b0);
    @(`DEVTLB_SYS_CLK) disable iff(rst)
        (!clk ##1 clk) ##1 (!$rose(clk)[*1:$]) |-> $stable(sig) ;
endproperty : DEVTLB_p_stable_between_ticks

`else

property DEVTLB_p_stable_between_ticks(sig, clk, rst=1'b0);
1;
endproperty

`endif

`endif

// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_gstable_between_ticks_ev(sig, clk=`HQM_DEVTLB_default_clk,rst=1'b0);
    @(clk) disable iff(rst) 1'b1 |-> @($global_clock) nexttime[2]
        reject_on($changed_gclk(sig)) @(clk) 1'b1;
endproperty : DEVTLB_p_gstable_between_ticks_ev

`else

property DEVTLB_p_gstable_between_ticks_ev(sig, clk, rst=1'b0);
    @(clk) 1;
endproperty : DEVTLB_p_gstable_between_ticks_ev

`endif


// --- --- ---


`ifndef HQM_DEVTLB_SVA_LIB_SVA2005

property DEVTLB_p_gstable_between_ticks_sig(sig, clk, rst=1'b0);
    @(clk) 1;
endproperty : DEVTLB_p_gstable_between_ticks_sig

`else

`ifdef DEVTLB_SYS_CLK

property DEVTLB_p_gstable_between_ticks_sig(sig, clk, rst=1'b0);
    @(`DEVTLB_SYS_CLK) disable iff(rst)
        (##1 clk ##1 (!clk)[*1:$])  |-> $stable(sig);
endproperty : DEVTLB_p_gstable_between_ticks_sig

`else

property DEVTLB_p_gstable_between_ticks_sig(sig, clk, rst=1'b0);
1;
endproperty

`endif

`endif

