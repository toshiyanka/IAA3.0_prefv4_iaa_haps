//=====================================================================================================================
// Title            : hqm_intel_checkers_core_imp.sv
//
//
// Copyright (c) 2013 Intel Corporation
// Intel Proprietary and Top Secret Information
//---------------------------------------------------------------------------------------------------------------------

`ifndef HQM_SVA_LIB_SVA2005

    let hqm_l_known(sig) = ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
    let hqm_l_same(siga,sigb) = ((HQM_SVA_LIB_IGNORE_XZ)? ((siga)===(sigb)) : ((siga)==(sigb)));
    let hqm_l_mutexed(sig) = $onehot0({>>{sig}}) && hqm_l_known(sig);
    let hqm_l_at_most_bits_high(sig, n) = ($countones({>>{sig}}) <= n) && hqm_l_known(sig);
    let hqm_l_at_most_bits_low(sig, n) = ($countones({>>{~sig}}) <= n) && hqm_l_known(sig);
    let hqm_l_bits_high(sig, n) = ($countones({>>{sig}}) == n) && hqm_l_known(sig);
    let hqm_l_bits_low(sig, n) = ($countones({>>{~sig}}) == n) && hqm_l_known(sig);
    let hqm_l_same_bits(sig) = (&(sig)) || !(|(sig));
    let hqm_l_one_hot(sig) = $onehot({>>{sig}}) && hqm_l_known(sig);
    let hqm_l_known_driven(sig) = hqm_l_known(sig);
    let hqm_l_forbidden(cond) = !(cond);
    let hqm_l_must(prop) = (prop);
    let hqm_l_trigger(trig_sig, prop_sig) = (trig_sig -> prop_sig);
    let hqm_l_range(sig, low, high) = (((sig) >=(low)) & ((sig) <=(high)));
    let hqm_l_max_value(sig, max_val) = ((sig) <= (max_val));
    let hqm_l_min_value(sig, min_val) = ((sig) >= (min_val));

`endif

// --- --- Assumption Properties --- --- //

property hqm_p_max_value(sig, max_val, clk, rst=1'b0);
     @(clk) disable iff(rst) ((sig) <= (max_val));
endproperty : hqm_p_max_value

property hqm_p_min_value(sig, min_val, clk, rst=1'b0);
     @(clk) disable iff(rst) ((sig) >= (min_val));
endproperty : hqm_p_min_value

property hqm_p_mutexed(sig, clk, rst=1'b0);
     @(clk) disable iff(rst) $onehot0({>>{sig}}) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : 
		(!($isunknown({>>{sig}}))));
endproperty : hqm_p_mutexed

property hqm_p_one_hot(sig, clk, rst=1'b0);
     @(clk) disable iff(rst) $onehot({>>{sig}}) && (HQM_SVA_LIB_IGNORE_XZ || (!($isunknown({>>{sig}}))));
endproperty : hqm_p_one_hot

property hqm_p_same_bits(sig, clk, rst=1'b0);
     @(clk) disable iff(rst) (&(sig)) || !(|(sig));
endproperty : hqm_p_same_bits

property hqm_p_range(sig, low, high, clk, rst=1'b0);
     @(clk) disable iff(rst)  (((sig) >=(low)) & ((sig) <=(high)));
endproperty : hqm_p_range

property hqm_p_at_most_bits_high(sig, n, clk, rst=1'b0);
     @(clk) disable iff(rst)  ($countones({>>{sig}}) <= n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : 	(!($isunknown({>>{sig}})))); 
endproperty : hqm_p_at_most_bits_high

property hqm_p_at_most_bits_low(sig, n, clk, rst=1'b0);
     @(clk) disable iff(rst) ($countones({>>{~sig}}) <= n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
endproperty : hqm_p_at_most_bits_low

property hqm_p_bits_high(sig, n, clk, rst=1'b0);
     @(clk) disable iff(rst) ($countones({>>{sig}}) == n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
endproperty : hqm_p_bits_high

property hqm_p_forbidden(sig, clk, rst=1'b0);
  @(clk) disable iff(rst) !(sig);
endproperty : hqm_p_forbidden

property hqm_p_must(prop, clk, rst=1'b0);
  @(clk) disable iff(rst) (prop);
endproperty : hqm_p_must

property hqm_p_known_driven(sig, clk, rst=1'b0);
  @(clk) disable iff(rst) ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
endproperty : hqm_p_known_driven

property hqm_p_same(siga, sigb, clk, rst=1'b0);
  @(clk) disable iff(rst) ((HQM_SVA_LIB_IGNORE_XZ)? ((siga)===(sigb)) : ((siga)==(sigb)));
endproperty : hqm_p_same

property hqm_p_bits_low(sig, n, clk, rst=1'b0);
   @clk disable iff(rst) ($countones({>>{~sig}}) == n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
endproperty : hqm_p_bits_low

//   --- --- --- Currently not supported in let statements --- --- --- //

//property one_of(sig, set, clk, rst=1'b0);
//     @(clk) disable iff(rst) ((sig) inside set);
//endproperty : hqm_p_one_of

//property one_of(sig, set, clk, rst=1'b0);
//     @(clk) disable iff(rst) one_of(sig, set);
//endproperty : hqm_p_one_of

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- //




// --- --- ---Cover Properties --- --- --- //


property hqm_p_cover_mutexed(sig, clk, rst=1'b0);
   @clk !(rst) && $onehot0({>>{sig}}) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
endproperty : hqm_p_cover_mutexed

property hqm_p_not_mutexed_covered(sig, clk, rst=1'b0);
   @clk !(rst) && !($onehot0({>>{sig}}) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}})))));
endproperty : hqm_p_not_mutexed_covered

property hqm_p_cover_one_hot(sig, clk, rst=1'b0);
   @clk !(rst) && $onehot({>>{sig}}) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
endproperty : hqm_p_cover_one_hot

property hqm_p_not_one_hot_cover(sig, clk, rst=1'b0);
   @clk !(rst) && !($onehot({>>{sig}}) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}})))));
endproperty : hqm_p_not_one_hot_cover

property hqm_p_cover_same_bits(sig, clk, rst=1'b0);
   @clk  !(rst) && (&(sig)) || !(|(sig));
endproperty : hqm_p_cover_same_bits

property hqm_p_not_same_bits_cover(sig, clk, rst=1'b0);
   @clk  !(rst) && !((&(sig)) || !(|(sig)) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}})))));
endproperty : hqm_p_not_same_bits_cover

property hqm_p_cover_range(sig, low, high, clk, rst=1'b0);
   @clk  !(rst) && (((sig) >=(low)) & ((sig) <=(high)));
endproperty : hqm_p_cover_range

property hqm_p_not_range_cover(sig, low, high, clk, rst=1'b0);
   @clk  !(rst) && !((((sig) >=(low)) & ((sig) <=(high))));
endproperty : hqm_p_not_range_cover

property hqm_p_cover_at_most_bits_high(sig, n, clk, rst=1'b0);
   @clk  !(rst) &&  ($countones({>>{sig}}) <= n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
endproperty : hqm_p_cover_at_most_bits_high

property hqm_p_not_at_most_bits_high_cover(sig, n, clk, rst=1'b0);
   @clk  !(rst) &&  !(($countones({>>{sig}}) <= n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}})))));
endproperty : hqm_p_not_at_most_bits_high_cover

property hqm_p_cover_at_most_bits_low(sig, n, clk, rst=1'b0);
   @clk  !(rst) &&  ($countones({>>{~sig}}) <= n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
endproperty : hqm_p_cover_at_most_bits_low

property hqm_p_not_at_most_bits_low_cover(sig, n, clk, rst=1'b0);
   @clk  !(rst) &&  !(($countones({>>{~sig}}) <= n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}})))));
endproperty : hqm_p_not_at_most_bits_low_cover

property hqm_p_cover_bits_high(sig, n, clk, rst=1'b0);
   @clk !(rst) && ($countones({>>{sig}}) == n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
endproperty : hqm_p_cover_bits_high

property hqm_p_not_bits_high_cover(sig, n, clk, rst=1'b0);
   @clk !(rst) && !(($countones({>>{sig}}) == n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}})))));
endproperty : hqm_p_not_bits_high_cover

property hqm_p_cover_known_driven(sig, clk, rst=1'b0);
   @clk !(rst) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
endproperty : hqm_p_cover_known_driven

property hqm_p_not_known_driven_cover(sig, clk, rst=1'b0);
   @clk !(rst) && !(((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}})))));
endproperty : hqm_p_not_known_driven_cover

property hqm_p_cover_same(siga, sigb, clk, rst=1'b0);
   @clk !(rst) && ((HQM_SVA_LIB_IGNORE_XZ)? ((siga)===(sigb)) : ((siga)==(sigb)));
endproperty : hqm_p_cover_same

property hqm_p_not_same_cover(siga, sigb, clk, rst=1'b0);
   @clk !(rst) && !(((HQM_SVA_LIB_IGNORE_XZ)? ((siga)===(sigb)) : ((siga)==(sigb))));
endproperty : hqm_p_not_same_cover

property hqm_p_cover_max_value(sig, max_val, clk, rst=1'b0);
   @clk !(rst) &&  ((sig) <= (max_val));
endproperty : hqm_p_cover_max_value

property hqm_p_not_max_value_cover(sig, max_val, clk, rst=1'b0);
   @clk !(rst) && !(((sig) <= (max_val)));
endproperty : hqm_p_not_max_value_cover

property hqm_p_cover_min_value(sig, min_val, clk, rst=1'b0);
   @clk !(rst) &&  ((sig) >= (min_val));
endproperty : hqm_p_cover_min_value

property hqm_p_not_min_value_cover(sig, min_val, clk, rst=1'b0);
   @clk !(rst) && !(((sig) >= (min_val)));
endproperty : hqm_p_not_min_value_cover

property hqm_p_cover_bits_low(sig, n, clk, rst=1'b0);
   @clk !(rst) && ($countones({>>{~sig}}) == n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}}))));
endproperty : hqm_p_cover_bits_low

property hqm_p_not_bits_low_cover(sig, n, clk, rst=1'b0);
   @clk !(rst) &&  !(($countones({>>{~sig}}) == n) && ((HQM_SVA_LIB_IGNORE_XZ)? (1'b1) : (!($isunknown({>>{sig}})))));
endproperty : hqm_p_not_bits_low_cover


//   --- --- --- Currently not supported in let statements --- --- --- //

//property cover_one_of(sig, set, clk, rst=1'b0);
//  @clk !(rst) && hqm_l_one_of(sig, set);
//endproperty : hqm_p_cover_one_of


//property not_one_of_cover(sig, set, clk, rst=1'b0);
//  @clk !(rst) && !(hqm_l_one_of(sig, set));
//endproperty : hqm_p_not_one_of_cover

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- //






// --- --- Sequential Properties --- --- //


property hqm_p_trigger(trig, prop, clk, rst=1'b0);
    @(clk) disable iff(rst) trig |-> prop;
endproperty : hqm_p_trigger


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_delayed_trigger(trig, delay, prop, clk, rst=1'b0);
    @(clk) disable iff(rst) trig |-> nexttime[delay] prop;
endproperty : hqm_p_delayed_trigger

`else

property hqm_p_delayed_trigger(trig, delay, prop, clk, rst=1'b0);
    @(clk) disable iff(rst) trig ##delay 1'b1 |->  prop;
endproperty : hqm_p_delayed_trigger

`endif


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_never(prop, clk, rst=1'b0);
    @(clk) disable iff(rst) not(strong(prop));
endproperty : hqm_p_never

`else

property hqm_p_never(prop, clk, rst=1'b0);
    @(clk) disable iff(rst) not(prop);
endproperty : hqm_p_never

`endif


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_eventually_holds(en, prop, clk, rst=1'b0);
    @(clk) disable iff(rst) en |-> s_eventually prop;
endproperty : hqm_p_eventually_holds

`else

property hqm_p_eventually_holds(en, prop, clk, rst=1'b0);
    @(clk) disable iff(rst) en |-> ##[0:$] prop;
endproperty : hqm_p_eventually_holds

`endif


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_between(start_ev, end_ev, cond, clk, rst=1'b0);
    @(clk) disable iff(rst) start_ev |-> cond until_with end_ev;
endproperty : hqm_p_between

`else

property hqm_p_between(start_ev, end_ev, cond, clk, rst=1'b0);
    @(clk) disable iff(rst) start_ev ##0 !(end_ev && cond)[*1:$] |-> cond;
endproperty : hqm_p_between

`endif


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_between_time(trig, start_time, end_time, cond, clk, rst=1'b0);
    @(clk) disable iff(rst) trig |-> always [start_time:end_time] cond;
endproperty : hqm_p_between_time

`else

property hqm_p_between_time(trig, start_time, end_time, cond, clk, rst=1'b0);
    @(clk) disable iff(rst)
        trig |-> ##start_time (cond[*(end_time-start_time+1)]);
endproperty : hqm_p_between_time

`endif


// --- --- ---


property hqm_p_next_event(en, ev, prop, clk, rst=1'b0);
    @(clk) disable iff(rst) en ##0 ev[->1] |-> prop;
endproperty : hqm_p_next_event


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_before_event(en, first, second, clk, rst=1'b0);
    @(clk) disable iff(rst) en |-> (not strong(second)) until_with first;
endproperty : hqm_p_before_event

`else

property hqm_p_before_event(en, first, second, clk, rst=1'b0);
    @(clk) disable iff(rst) en ##0 (!first[*1:$] or first[->1]) |-> not second;
endproperty : hqm_p_before_event

`endif


// --- --- ---


property hqm_p_remain_high(sig, n, clk, rst=1'b0);
    @(clk) disable iff(rst) !sig ##1 sig |=> sig[*n];
endproperty : hqm_p_remain_high


// --- --- ---


property hqm_p_remain_high_at_most(sig, n, clk, rst=1'b0);
    @(clk) disable iff(rst) !sig ##1 sig |=> sig[*0:n] ##1 !sig;
endproperty : hqm_p_remain_high_at_most


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_gremain_high(sig, n, clk, rst=1'b0);
   @clk disable iff(rst) !sig ##1 sig |=> reject_on(!sig) 1'b1[*n];
endproperty : hqm_p_gremain_high

`else

property hqm_p_gremain_high(sig, n, clk, rst=1'b0);
    @(clk) disable iff (1'b1) 1; 
endproperty : hqm_p_gremain_high

`endif


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_gremain_high_at_most(sig, n, clk, rst=1'b0);
   @clk disable iff(rst) !sig ##1 sig |=> accept_on(!sig) ##n !sig;
endproperty : hqm_p_gremain_high_at_most

`else

property hqm_p_gremain_high_at_most(sig, n, clk, rst=1'b0);
    @(clk) disable iff (1'b1) 1;
endproperty : hqm_p_gremain_high_at_most

`endif


// --- --- ---


property hqm_p_verify(prop, clk, rst=1'b0);
    @(clk) disable iff(rst) prop;
endproperty : hqm_p_verify


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_req_granted(req, gnt, clk, rst=1'b0);
    @(clk) disable iff(rst) (gnt || !req) ##1 req |-> s_eventually (gnt);
endproperty : hqm_p_req_granted

`else

property hqm_p_req_granted(req, gnt, clk, rst=1'b0);
    @(clk) disable iff (rst)
    (gnt || !req) ##1 req |-> gnt[->1];
endproperty : hqm_p_req_granted

`endif


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_cont_req_granted(req, gnt, clk, rst=1'b0);
    @(clk) disable iff(rst)
    (gnt || !req) ##1 req |-> strong(req throughout gnt[->1]);
endproperty : hqm_p_cont_req_granted

`else

property hqm_p_cont_req_granted(req, gnt, clk, rst=1'b0);
    @(clk) disable iff (rst)
    (gnt || !req) ##1 req |-> req throughout gnt[->1];
endproperty : hqm_p_cont_req_granted

`endif


// --- --- ---


property hqm_p_req_granted_within(req, min, max, gnt, clk, rst=1'b0);
    @(clk) disable iff(rst)
    (gnt || !req) ##1 req |-> !gnt[*min:max] ##1 gnt;
endproperty : hqm_p_req_granted_within


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_until_strong(start_ev, cond, end_ev, clk, rst=1'b0);
    @(clk) disable iff(rst)
    start_ev |-> cond s_until end_ev;
endproperty : hqm_p_until_strong

`else

property hqm_p_until_strong(start_ev, cond, end_ev, clk, rst=1'b0);
    @(clk) disable iff (rst)
    start_ev |-> cond[*0:$] ##1 end_ev;
endproperty : hqm_p_until_strong

`endif


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_until_weak(start_ev, cond, end_ev, clk, rst=1'b0);
    @(clk) disable iff(rst)
    start_ev |-> cond until end_ev;
endproperty : hqm_p_until_weak

`else

property hqm_p_until_weak(start_ev, cond, end_ev, clk, rst=1'b0);
    @(clk) disable iff (rst)
    start_ev ##0 (!cond || end_ev)[->1] |-> end_ev;
endproperty : hqm_p_until_weak

`endif


// --- --- ---


property hqm_p_recur_triggers(trig, n, cond, clk, rst=1'b0);
    @(clk) disable iff(rst)
     not( !cond throughout (trig ##1 trig[->(n-1)]) );
endproperty : hqm_p_recur_triggers


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_gray_code(sig, clk, rst=1'b0);
    @(clk) disable iff(rst)  nexttime $onehot0(sig ^ $past(sig));
endproperty : hqm_p_gray_code

`else

property hqm_p_gray_code(sig, clk, rst=1'b0);
    @(clk) disable iff(rst)  ##1 $onehot0(sig ^ $past(sig));
endproperty : hqm_p_gray_code

`endif


// --- --- ---


property hqm_p_rigid(sig, clk, rst=1'b0);
  @(clk) disable iff(rst) ##1 $stable(sig);
endproperty : hqm_p_rigid


// --- --- ---


property hqm_p_data_transfer(start_ev, start_data, end_ev, end_data, clk, rst=1'b0);
    logic [$bits(start_data)-1:0] local_data;
    @(clk) disable iff(rst)
    (start_ev, local_data = start_data) ##0
      (end_ev or (!end_ev ##1 (!start_ev throughout end_ev[->1])))
             |-> (local_data == end_data);
endproperty : hqm_p_data_transfer



// --- --- ---


property hqm_p_cover(prop, clk, rst=1'b0);
    @(clk) disable iff(rst) prop;
endproperty : hqm_p_cover


// --- --- ---

`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_cover_enable(en, prop, clk, rst=1'b0);
    @(clk) disable iff(rst) en #-# prop;
endproperty : hqm_p_cover_enable

`else

property hqm_p_cover_enable(en, prop, clk, rst=1'b0);
    @(clk) disable iff(rst) 1'b0;
endproperty : hqm_p_cover_enable

`endif

// --- --- ---


// cannot support $changing_gclk anymore.
//
//property hqm_p_clock_ticking(clk);
//    @($global_clock) s_eventually $changing_gclk(clk);
//endproperty : hqm_p_clock_ticking


property hqm_p_clock_ticking(clk, gclk);
    @(gclk) !$stable(clk)[->1];
endproperty : hqm_p_clock_ticking


// --- --- ---


// --- --- --- Stability Properties --- --- --- //

`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_stable(sig, start_ev, end_ev, clk, rst=1'b0);
    @(clk) disable iff(rst) start_ev |=> $stable(sig) until_with end_ev;
endproperty : hqm_p_stable

`else

property hqm_p_stable(sig, start_ev, end_ev, clk, rst=1'b0);
    @(clk) disable iff(rst)
        start_ev
        ##1 !(end_ev && $stable(sig))[*1:$]
              |-> $stable(sig);
endproperty : hqm_p_stable

`endif


// --- --- ---

`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_gstable_ev(sig, start_ev, end_ev, clk, gclk, rst=1'b0);
    @(clk) disable iff(rst) start_ev |->
        @(gclk) nexttime reject_on($changed(sig, gclk)) @clk 1'b1 until_with end_ev;
endproperty : hqm_p_gstable_ev

`else

property hqm_p_gstable_ev(sig, start_ev, end_ev, clk, gclk, rst=1'b0);
    @(clk) disable iff (1'b1) 1;
endproperty : hqm_p_gstable_ev

`endif


// --- --- ---

`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_stable_window(sample, sig, win_start, win_end, clk, rst=1'b0);
    @(clk) disable iff(rst) nexttime[win_start] sample implies ##1 $stable(sig)[*win_end + win_start];
endproperty : hqm_p_stable_window

`else

sequence stable_before_s(sig, clks_before, clk);
    @(clk) ##1 $stable(sig)[*clks_before-1];
endsequence : stable_before_s

property hqm_p_stable_window(sample, sig, clks_before, clks_after, clk, rst=1'b0);
    @(clk) disable iff(rst) ##clks_before sample
        |-> stable_before_s(sig, clks_before, clk).ended ##1
                ($stable(sig)[*clks_after]);
endproperty : hqm_p_stable_window

`endif


// --- --- ---

`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_gstable_window(sample, sig, win_start, win_end, clk, gclk, rst=1'b0);
    @clk disable iff(rst) nexttime[win_start] sample implies
        @(gclk) nexttime[1] reject_on($changed(sig,gclk)) @clk 1'b1[*win_end + win_start];
endproperty : hqm_p_gstable_window

`else

property hqm_p_gstable_window(sample, sig, win_start, win_end, clk, gclk, rst=1'b0);
    @(clk) disable iff (1'b1) 1;
endproperty : hqm_p_gstable_window

`endif


// --- --- ---

`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_stable_for(sig, n, clk, rst=1'b0);
    @(clk) disable iff(rst) ##1 $changed(sig) |=> $stable(sig)[*n];
endproperty : hqm_p_stable_for

`else

property hqm_p_stable_for(sig, n, clk, rst=1'b0);
    @(clk) disable iff(rst) ##1 !$stable(sig) |=> $stable(sig)[*n];
endproperty : hqm_p_stable_for

`endif


// --- --- ---

`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_gstable_for(sig, n, clk, gclk, rst=1'b0);
    @(clk) disable iff(rst) ##1 $changed(sig) |->
            @(gclk) nexttime reject_on($changed(sig,gclk)) @(clk) 1'b1[*n];
endproperty : hqm_p_gstable_for

`else

property hqm_p_gstable_for(sig, n, clk, gclk, rst=1'b0);
    @(clk) disable iff (1'b1) 1;
endproperty : hqm_p_gstable_for

`endif


// --- --- ---


property hqm_p_stable_after(sample, sig, clks_after, clk, rst=1'b0);
    @(clk) disable iff(rst) sample |=> $stable(sig)[*clks_after];
endproperty : hqm_p_stable_after


// --- --- ---

`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_gstable_after(sample, sig, clks_after, clk, gclk, rst=1'b0);
    @(clk) disable iff(rst) sample |->
        @(gclk) nexttime reject_on($changed(sig, gclk)) @(clk) 1'b1[*clks_after];
endproperty : hqm_p_gstable_after

`else

property hqm_p_gstable_after(sample, sig, clks_after, clk, gclk, rst=1'b0);
    @(clk) disable iff (1'b1) 1;
endproperty : hqm_p_gstable_after

`endif


// --- --- ---


`ifndef HQM_SVA_LIB_SVA2005

property hqm_p_gstable_between_ticks_ev(sig, clk, gclk, rst=1'b0);
    @(clk) disable iff(rst) 1'b1 |-> @(gclk) nexttime[2]
        reject_on($changed(sig, gclk)) @(clk) 1'b1;
endproperty : hqm_p_gstable_between_ticks_ev


`else

property hqm_p_gstable_between_ticks_ev(sig, clk, gclk, rst=1'b0);
    @(clk) disable iff (1'b1) 1;
endproperty : hqm_p_gstable_between_ticks_ev

`endif


// --- --- ---


property hqm_p_stable_between_ticks_posedge(sig, clk, rst=1'b0);
    @(clk) disable iff(rst) ##1 !$stable(sig) |-> $rose(clk);
endproperty : hqm_p_stable_between_ticks_posedge


property hqm_p_stable_between_ticks_negedge(sig, clk, rst=1'b0);
    @(clk) disable iff(rst) ##1 !$stable(sig) |-> $fell(clk);
endproperty : hqm_p_stable_between_ticks_negedge


property hqm_p_stable_between_ticks_edge(sig, clk, rst=1'b0);
    @(clk) disable iff(rst) ##1 !$stable(sig) |-> !$stable(clk);
endproperty : hqm_p_stable_between_ticks_edge


// --- --- ---

