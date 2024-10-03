`define HQM_ASSERTH_MUTEXED(fire, label, sig, rst, MSG)        \
	fire = ~((rst) || `HQM_SVA_LIB_ONEHOT0({>>{sig}}));	         \
	`HQM_ASSERTC_MUTEXED(label``_hw, sig, rst, MSG)


`define HQM_ASSERTH_ONE_HOT(fire, label, sig, rst, MSG)	\
	fire = ~((rst) || `HQM_SVA_LIB_ONEHOT({>>{sig}}));		\
	`HQM_ASSERTC_ONE_HOT(label``_hw, sig, rst, MSG)
    
`define HQM_ASSERTH_SAME_BITS(fire, label, sig, rst, MSG)		\
	fire = ~((rst) || ((&(sig)) || !(|(sig))) );	\
        `HQM_ASSERTC_SAME_BITS(label``_hw, sig, rst, MSG)


`define HQM_ASSERTH_AT_MOST_BITS_HIGH(fire, label, sig, n, rst, MSG) \
	fire = ~((rst) || (`HQM_SVA_LIB_COUNTONES({>>{sig}}) <= n));	      \
	`HQM_ASSERTC_AT_MOST_BITS_HIGH(label``_hw, sig, n, rst, MSG)


`define HQM_ASSERTH_BITS_HIGH(fire, label, sig, n, rst, MSG)	\
	fire = ~((rst) || (`HQM_SVA_LIB_COUNTONES({>>{sig}}) == n));	\
	`HQM_ASSERTC_BITS_HIGH(label``_hw, sig, n, rst, MSG)


`define HQM_ASSERTH_FORBIDDEN(fire, label, prop, rst, MSG) \
	fire = ~((rst) || !(prop));	    \
    `HQM_ASSERTC_FORBIDDEN(label``_hw, prop, rst, MSG)


`define HQM_ASSERTH_MUST(fire, label, prop, rst, MSG)			\
	fire = ~((rst) || (prop));				\
    `HQM_ASSERTC_MUST(label``_hw, prop, rst, MSG)


`define HQM_ASSERTH_SAME(fire, label, siga, sigb, rst, MSG)		\
	fire = ~((rst) || ((siga) == (sigb)));		\
	`HQM_ASSERTC_SAME(label``_hw, siga, sigb, rst, MSG)



//MCP Assertions
// these macros assume that the user adds manually the HQM_SVA_ERR_MSG. 
//
`define HQM_ASSERT_SIGNAL_IS_PH2(clk,sig,constr_name) \
  `ifdef FEV \
     always \
  lira_transimply_``constr_name: $transimply("$rising",clk,"$unchanging",sig);\
  `endif \
  `HQM_ASSERTS_STABLE_BETWEEN_TICKS_NEGEDGE(sva_``constr_name, sig, clk, 1'b0, $info("")); 


`define HQM_ASSERT_SIGNAL_IS_PH1(clk,sig,constr_name) \
  `ifdef FEV \
     always \
  lira_transimply_``constr_name: $transimply("$falling",clk,"$unchanging",sig);\
  `endif \
  `HQM_ASSERTS_STABLE_BETWEEN_TICKS_POSEDGE(sva_``constr_name, sig, clk, 1'b0, $info(""));



`ifndef HQM_SVA_LIB_DONT_SYNTHESIZE_BOOL_SF
    `define HQM_SVA_LIB_ONEHOT    hqm_intel_checkers_pkg::hqm_f_onehot
    `define HQM_SVA_LIB_ONEHOT0   hqm_intel_checkers_pkg::hqm_f_onehot0
    `define HQM_SVA_LIB_COUNTONES hqm_intel_checkers_pkg::hqm_f_countones 
`else
    `define HQM_SVA_LIB_ONEHOT    $onehot
    `define HQM_SVA_LIB_ONEHOT0   $onehot0
    `define HQM_SVA_LIB_COUNTONES $countones 
`endif
