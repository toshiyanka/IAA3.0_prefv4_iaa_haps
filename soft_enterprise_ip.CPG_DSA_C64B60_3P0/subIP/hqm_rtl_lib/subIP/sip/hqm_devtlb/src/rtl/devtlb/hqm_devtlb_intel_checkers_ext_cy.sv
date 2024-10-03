//=====================================================================================================================
//
// DEVTLB_intel_checkers_ext_cy.sv
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

`ifndef HQM_DEVTLB_INTEL_CHECKERS_EXT_CY_VS
`define HQM_DEVTLB_INTEL_CHECKERS_EXT_CY_VS

///////////////////////////////////////////////////
// An extension of intel_checkers (same usage)
// chao.yan@intel.com 
///////////////////////////////////////////////////


///////////////////////////////////////////////////
// Macros 

// Signal 'sig' is rigid 
// It's not implemented in SVA_LIB now. ASSUME_STABLE(sig,1,0,clk,reset) also works

`define HQM_DEVTLB_ASSERT_RIGID(sig,clk,rst) \
	assert property(rigid(sig,clk,(rst | reset_INST)))

`define HQM_DEVTLB_ASSERTS_RIGID(name, sig, clk, rst, MSG) \
	name: `HQM_DEVTLB_ASSERT_RIGID(sig, clk, rst) MSG

`define HQM_DEVTLB_ASSUME_RIGID(sig,clk,rst) \
	assume property(rigid(sig,clk,rst))
	//`DEVTLB_ASSUME_STABLE(sig,1,0,clk,rst)

`define HQM_DEVTLB_ASSUMES_RIGID(name, sig, clk, rst, MSG) \
	name: `HQM_DEVTLB_ASSUME_RIGID(sig, clk, rst) MSG

`define HQM_DEVTLB_USE_RTL_NODE(model,sig) \
	logic sig;  \
	assign sig = model.sig;

`define HQM_DEVTLB_USE_RTL_SIG(model,type,sig) \
	type sig;  \
	assign sig = model.sig;
/*
`define HQM_DEVTLB_USE_RTL_SIG(model,type,sig1, sig2) \
	type sig1, sig2;  \
	assign sig1 = model.sig1;
	assign sig2 = model.sig2;
*/


///////////////////////////////////////////////////
// properties 
// copy from SNB "imph_fpv_templates.va"

// signal changes only on posedge
//property stable_between_ticks_h_simple (sig, clk, rst);
//`ifdef TOOL_DIS_STABLE_MACRO
//	@(`DEVTLB_SYS_CLK) disable iff (rst) 1; 
//	//1;
//`else 
//	@(`DEVTLB_SYS_CLK) disable iff (rst) !$stable(sig) |-> $rose(clk);
//`endif
//endproperty: stable_between_ticks_h_simple
// 
//// signal changes only on negedge
//property stable_between_ticks_l_simple (sig, clk, rst);
// @(`DEVTLB_SYS_CLK) disable iff (rst) !$stable(sig) |-> $fell(clk);
//endproperty: stable_between_ticks_l_simple

// The function from SNB doesn't work
property rigid(sig,clk,rst);
     @(clk) disable iff (rst) ##1 $stable(sig);
     //@(`DEVTLB_SYS_CLK) disable iff (rst) ##1 $stable(sig); //work
     //@(`DEVTLB_SYS_CLK) ##1 $stable(sig); // not work
endproperty

`endif // DEVTLB_INTEL_CHECKERS_EXT_CY_VS
