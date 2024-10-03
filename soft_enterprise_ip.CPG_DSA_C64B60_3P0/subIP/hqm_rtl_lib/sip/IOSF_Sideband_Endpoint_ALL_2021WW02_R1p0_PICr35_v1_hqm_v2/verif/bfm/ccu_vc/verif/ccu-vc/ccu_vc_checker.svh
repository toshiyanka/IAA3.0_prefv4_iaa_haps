//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2011 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr
// Date Created : 2013-03-19
//-----------------------------------------------------------------
// Description:
// ccu_vc checker and coverage
//------------------------------------------------------------------


`define check_rule(NUM,NAME,TRIGGER,DISABLE,CONDITION,IMPLICATION,MSG) \
NAME:assert property( \
	@(posedge TRIGGER) \
	disable iff(ccu_intf.pwell_pok[NUM] !== 1'b1 || ccu_intf.global_rst_b[NUM] !== 1'b1 || DISABLE) \
	CONDITION |-> IMPLICATION ) \
    else \
	`ovm_error(checker_name,MSG) \

`define async_check_rule(NUM,NAME,TRIGGER,DISABLE,CONDITION,IMPLICATION,MSG) \
NAME:assert property( \
	@(TRIGGER) \
	disable iff(ccu_intf.pwell_pok[NUM] !== 1'b1 || ($time == 0) || ccu_intf.global_rst_b[NUM] !== 1'b1 || DISABLE) \
	CONDITION |-> IMPLICATION ) \
    else \
	`ovm_error(checker_name,MSG) \

`define cover_rule(NUM,NAME,TRIGGER,CONDITION,IMPLICATION) \
NAME:cover property( \
	@(posedge TRIGGER) \
	disable iff(ccu_intf.pwell_pok[NUM] !== 1'b1) \
	CONDITION |-> IMPLICATION ); \

property afterNClks(start_event, end_event, N);
	int count;
	(start_event, count = 0) |-> (((~end_event, count = count+1) [*0:$]) ##1 (1 and (count >= N)));
endproperty: afterNClks

property withinNClkRange(start_event, end_event, min, max);
	int count;
	(start_event, count = 0) |-> (((~end_event, count = count+1) [*0:$]) ##1 ((count <=max) and (count >= min)));
endproperty: withinNClkRange

property afterNTime(start_event, end_event, N);
	time start_time, end_time;
	(start_event, start_time = ($time*1ps)) |-> (((~end_event) [*0:$]) ##1 (($time*1ps) - start_time >= N));
endproperty: afterNTime

`ifndef DISABLE_CCU_CHECKER

// checker variables
int clk_count[NUM_SLICES];
event chk_min_8[NUM_SLICES];
time clk_ungate_time[NUM_SLICES];
time clk_gate_time[NUM_SLICES];
time clk1_time[NUM_SLICES];
time clk2_time[NUM_SLICES];
time clk_period[NUM_SLICES];
time gate_ungate_time[NUM_SLICES];
time first_clkedge_time[NUM_SLICES];

generate 
for(genvar i=0; i<NUM_SLICES; i++) begin : ccu_vc_assertions

	always @(negedge ccu_intf.clkreq[i]) begin
		@(posedge ccu_intf.clk[i]);
		clk1_time[i] = $time;
		@(posedge ccu_intf.clk[i]);
		clk2_time[i] = $time;
		clk_period[i] = clk2_time[i] - clk1_time[i];
	end	

	always @(negedge ccu_intf.clkack[i]) begin
		clk_count[i] = 0;
		clk_gate_time[i] = $time;
		repeat(8) @(posedge ccu_intf.clk[i]) begin
			clk_count[i]++;
		end
	end

	always @(posedge ccu_intf.clkreq[i]) begin 
		clk_ungate_time[i] = $time;
		gate_ungate_time[i] = clk_ungate_time[i] - clk_gate_time[i];
		#1ps;
		->chk_min_8[i];
		@(posedge ccu_intf.clk[i]);
		first_clkedge_time[i] = $time - clk_ungate_time[i];
	end

//// CCU VC Assertions ////	
//-----------------------------------------------------------------------//
// NAME 		: clkack_rise
// DESCRIPTION  : Verifying rule 8 of req-ack protocol
// RULE 8 		: Clkack can assert only if clkreq is asserted 
//----------------------------------------------------------------------//
`async_check_rule(i,clkack_rise,posedge(ccu_intf.clkack[i]),0,1,ccu_intf.clkreq[i] == 1'b1,
				$psprintf("Slice num %0d, clkack rise forbidden when clkreq = %0d",i,ccu_intf.clkreq[i]))

//----------------------------------------------------------------------//
// NAME 		: clkack_fall
// DESCRIPTION  : Verifying rule 7 of req-ack protocol
// RULE 7		: Clkack can deassert only if clkreq is deasserted 
//----------------------------------------------------------------------//

`async_check_rule(i,clkack_fall,negedge(ccu_intf.clkack[i]),0,1,ccu_intf.clkreq[i] == 1'b0,
				$psprintf("Slice num %0d, clkack fall forbidden when clkreq = %0d",i,ccu_intf.clkreq[i]))

//----------------------------------------------------------------------//
// NAME 		: clkreq_rise
// DESCRIPTION  : Verifying rule 5 of req-ack protocol
// RULE 5		: Clkreq can assert only if clkack is deasserted 
//----------------------------------------------------------------------//

`async_check_rule(i,clkreq_rise,posedge(ccu_intf.clkreq[i]),0,1,ccu_intf.clkack[i] == 1'b0,
				$psprintf("Slice num %0d, clkreq rise forbidden when clkack = 0%d",i,ccu_intf.clkack[i]))
	
//----------------------------------------------------------------------//
// NAME 		: clkreq_fall
// DESCRIPTION  : Verifying rule 6 of req-ack protocol
// RULE 6		: Clkreq can deassert only if clkack is asserted 
//----------------------------------------------------------------------//
			
`async_check_rule(i,clkreq_fall,negedge(ccu_intf.clkreq[i]),0,1,ccu_intf.clkack[i] == 1'b1,
				$psprintf("Slice num %0d, clkreq fall forbidden when clkack = 0%d",i,ccu_intf.clkack[i]))
	
//----------------------------------------------------------------------//
// NAME 		: clk_active_chk
// DESCRIPTION  : Verifying rule 3 of req-ack protocol
// RULE 3		: SoC must guarantee that clock is not gated when clkreq
// 				: and clkack are asserted 
//----------------------------------------------------------------------//

//`check_rule(i,clk_active_chk,ccu_intf.clk[i],0,ccu_intf.clkreq[i] && $rose(ccu_intf.clkack[i]),(ccu_intf.clk[i])[->3],
//				$psprintf("Slice num %0d, clk is not active although clkreq and clkack are asserted",i))
				
//----------------------------------------------------------------------//
// NAME 		: clk_gate_min_8_chk
// DESCRIPTION  : Verifying rule 9 of req-ack protocol
// RULE 9		: Clock must continue to operate for a minimum of 8 clock
// 				: cycles after deasserting clkack 
//----------------------------------------------------------------------//

`async_check_rule(i,clk_gate_min_8_chk,chk_min_8[i],$isunknown(first_clkedge_time[i]) || $isunknown(clk_period[i]),1,clk_count[i] >= 8 || ((10 * clk_period[i]) > gate_ungate_time[i]),
				$psprintf("Slice num %0d, clk needs to stay active for 8 min clks before gating",i))	
		
//----------------------------------------------------------------------//
// NAME 		: clkack_1clk_chk
// DESCRIPTION  : Verifying rule 10 of req-ack protocol
// RULE 10		: Clock must operate for minimum 1 clock cycle before
// 				: asserting clkack 
//----------------------------------------------------------------------//

`check_rule(i,clkack_1clk_chk,ccu_intf.clk[i],0,$rose(ccu_intf.clkreq[i]),##1 ccu_intf.clkack[i][->1],
				$psprintf("Slice num %0d, clkack should assert 1 clk after clk ungates, clkack = %0d",i,ccu_intf.clkack[i]))
				
//----------------------------------------------------------------------//
// NAME 		: req1_ack1_chk
// DESCRIPTION  : clkreq -> 1 should be followed by a clkack -> 1 
// RULE 5		: eventually
//----------------------------------------------------------------------//

`async_check_rule(i,req1_ack1_chk,ccu_intf.clkreq[i] or ccu_intf.clkack[i],0,ccu_intf.clkreq[i],ccu_intf.clkack[i][->1],
				$psprintf("Slice num %0d,clkack never asserted in response to clkreq rise",i))
				
//----------------------------------------------------------------------//
// NAME 		: req0_ack0_chk
// DESCRIPTION  : clkreq -> 0 should be followed by a clkack -> 0
// RULE 6		: eventually
//----------------------------------------------------------------------//

`async_check_rule(i,req0_ack0_chk,ccu_intf.clkreq[i] or ccu_intf.clkack[i],0,!ccu_intf.clkreq[i],!ccu_intf.clkack[i][->1],
				$psprintf("Slice num %0d, clkack never de-asserted in response to clkreq fall",i))

//----------------------------------------------------------------------//
// NAME 		: req1_clk1_max_chk
// DESCRIPTION  : clkreq -> 1 to clk -> 1 should not exceed this time 
// 				: specified via plusarg MAX_CLK_UNGATE_TIME 
//----------------------------------------------------------------------//

`async_check_rule(i,req1_clk1_max_chk,first_clkedge_time[i] iff !$isunknown(max_ungate_time),0,max_ungate_time > 0,(first_clkedge_time[i])*1ps < (max_ungate_time),
				$psprintf("Slice num %0d, clk ungate time %0t exceeds the max ungate limit %0t",i,first_clkedge_time[i],max_ungate_time))

				
`endif

//TODO
//Glitch + unknown value checks

`ifndef DISABLE_CCU_COVERAGE
//============== CCU Coverage ==============//

//----------------------------------------------------------------------//
// NAME 		: req1_ack1_cover
// DESCRIPTION  : Handshake CP Cover rising edge on clkreq followed by rising edge
// 				: on clkack
//----------------------------------------------------------------------//

`cover_rule(i,req1_ack1_cover,ccu_intf.clk[i],$rose(ccu_intf.clkreq[i]),$rose(ccu_intf.clkack[i])[->1])

//----------------------------------------------------------------------//
// NAME 		: req0_ack0_cover
// DESCRIPTION  : Handshake CP Cover falling edge on clkreq followed by falling edge
// 				: on clkack
//----------------------------------------------------------------------//

`cover_rule(i,req0_ack0_cover,ccu_intf.clk[i],$fell(ccu_intf.clkreq[i]),$fell(ccu_intf.clkack[i])[->1])

//----------------------------------------------------------------------//
// NAME 		: req0_ack1_cover
// DESCRIPTION  : Handshake CP Cover req-ack combination 0-1 respectively 
// 				: Initiating clock gating
//----------------------------------------------------------------------//

`cover_rule(i,req0_ack1_cover,ccu_intf.clk[i],$fell(ccu_intf.clkreq[i]),ccu_intf.clkack[i])

//----------------------------------------------------------------------//
// NAME 		: req1_ack1_cover
// DESCRIPTION  : Handshake CP Cover req-ack combination 1-0 respectively
// 				: Initiating clock ungating
//----------------------------------------------------------------------//

`cover_rule(i,req1_ack0_cover,ccu_intf.clk[i],$rose(ccu_intf.clkreq[i]),!ccu_intf.clkack[i])

//----------------------------------------------------------------------//
// NAME 		: req1_ack1_cover
// DESCRIPTION  : Cover reset asserting without the global reset
//----------------------------------------------------------------------//

`cover_rule(i,reset_assert_cover,ccu_intf.clk[i],$fell(ccu_intf.reset[i]),ccu_intf.global_rst_b[i])

//---------------------------------------------------------------------//
// NAME 		: pwell_pok_cover
// DESCRIPTION 	: Connectivity checking on pwell pok, Making sure it is 
// 				: not just tied off to 0
//---------------------------------------------------------------------//

pwell_pok_cover: cover property( @(posedge ccu_intf.clk[i]) $rose(ccu_intf.pwell_pok[i]));

//---------------------------------------------------------------------//
// NAME 		: pwell_pok_cover
// DESCRIPTION 	: Connectivity checking on global reset, Making sure it is 
// 				: not just tied off to 0
//---------------------------------------------------------------------//

global_rst_b_cover: cover property( @(posedge ccu_intf.clk[i]) $rose(ccu_intf.global_rst_b[i]));


//---------------------------------------------------------------------//
// NAME 		: req1_clk1_dly
// DESCRIPTION 	: Cover min-med-max delay from req asserting to clock
// 				: ungating
//--------------------------------------------------------------------//

req1_clk1_dly: cover property (
	@(first_clkedge_time[i])
	REQ1_CLK1_MIN[i] < (first_clkedge_time[i]*1ps) < REQ1_CLK1_MAX[i]);

//---------------------------------------------------------------------//
// NAME 		: clk1_ack1_dly
// DESCRIPTION 	: Cover min-med-max delay from clk ungating to ack
// 				: asserting
//--------------------------------------------------------------------//

clk1_ack1_dly_min: cover property (
	@(posedge ccu_intf.clk[i])
	afterNClks(ccu_intf.clkreq[i],ccu_intf.clkack[i],CLK1_ACK1_MIN[i]));

clk1_ack1_dly_range: cover property (
	@(posedge ccu_intf.clk[i])
	withinNClkRange($rose(ccu_intf.clkreq[i]),ccu_intf.clkack[i],CLK1_ACK1_MIN[i],CLK1_ACK1_MAX[i]));	
//---------------------------------------------------------------------//
// NAME 		: req0_ack0_dly
// DESCRIPTION 	: Cover min-med-max delay from req deasserting to ack
// 				: deasserting
//--------------------------------------------------------------------//

req0_ack0_dly_min: cover property (
	@(posedge ccu_intf.clk[i])
	afterNClks(!ccu_intf.clkreq[i],!ccu_intf.clkack[i],REQ0_ACK0_MIN[i]));
	
req0_ack0_dly_range: cover property (
	@(posedge ccu_intf.clk[i])
	withinNClkRange(!ccu_intf.clkreq[i],!ccu_intf.clkack[i],REQ0_ACK0_MIN[i],REQ0_ACK0_MAX[i]));
	
//---------------------------------------------------------------------//
// NAME 		: ack0_clk0_dly
// DESCRIPTION 	: Cover min-med-max delay from ack deasserting to clock
// 				: gating
//--------------------------------------------------------------------//

ack0_clk0_dly_min: cover property (
	@(posedge ccu_intf.clk[i])
	afterNClks(!ccu_intf.clkack[i], ccu_intf.clkreq[i],ACK0_CLK0_MIN[i]));

ack0_clk0_dly_range: cover property (
	@(posedge ccu_intf.clk[i])
	withinNClkRange(!ccu_intf.clkack[i],ccu_intf.clkreq[i],ACK0_CLK0_MIN[i],ACK0_CLK0_MAX[i]));
	
`endif

end: ccu_vc_assertions
endgenerate
