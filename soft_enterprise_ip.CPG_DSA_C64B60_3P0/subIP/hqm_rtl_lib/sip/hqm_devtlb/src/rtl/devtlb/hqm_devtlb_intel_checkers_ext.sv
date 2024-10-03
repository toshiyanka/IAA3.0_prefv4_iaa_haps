//=====================================================================================================================
//
// DEVTLB_intel_checkers_ext.sv
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


`ifndef HQM_DEVTLB_INTEL_CHECKERS_EXT_VS
`define HQM_DEVTLB_INTEL_CHECKERS_EXT_VS


`define HQM_DEVTLB_ASSERT_MUTEXED_HW(fire, label, sig, rst)        \
	assert(1);					\
	fire = ~(rst || f_DEVTLB_onehot0({>>{sig}}));	         \
	label``_hw: `HQM_DEVTLB_ASSERT_MUTEXED(sig, rst) 

`define HQM_DEVTLB_ASSERT_ONE_HOT_HW(fire, label, sig, rst)	\
	assert(1);					\
	fire = ~(rst || f_DEVTLB_onehot({>>{sig}}));		\
	label``_hw: `HQM_DEVTLB_ASSERT_ONE_HOT(sig,rst) 

`define HQM_DEVTLB_ASSERT_SAME_BITS_HW(fire, label, sig, rst)		\
	assert(1);					\
	fire = ~(rst || ((&(sig)) || !(|(sig))) );	\
	label``_hw: `HQM_DEVTLB_ASSERT_SAME_BITS(sig,rst)  

`define HQM_DEVTLB_ASSERT_AT_MOST_BITS_HIGH_HW(fire, label, sig, n, rst) \
	assert(1);						\
	fire = ~(rst || f_DEVTLB_countones({>>{sig}}) <= n);	      \
	label``_hw: `HQM_DEVTLB_ASSERT_AT_MOST_BITS_HIGH(sig, n, rst) 

`define HQM_DEVTLB_ASSERT_BITS_HIGH_HW(fire, label, sig, n, rst )		\
	assert(1);						\
	fire = ~(rst || f_DEVTLB_countones({>>{sig}}) == n);	\
	label``_hw: `HQM_DEVTLB_ASSERT_BITS_HIGH(sig, n, rst) 

`define HQM_DEVTLB_ASSERT_FORBIDDEN_HW(fire, label, prop, rst) \
	assert (1);				\
	fire = ~(rst || !(prop));	    \
	label``_hw: `HQM_DEVTLB_ASSERT_FORBIDDEN(prop, rst) 

`define HQM_DEVTLB_ASSERT_MUST_HW(fire, label,  prop, rst)			\
	assert(1);						\
	fire = ~(rst || (prop));				\
	label``_hw: `HQM_DEVTLB_ASSERT_MUST(prop, rst) 

`define HQM_DEVTLB_ASSERT_SAME_HW(fire, label, siga , sigb , rst)		\
	assert(1);						\
	fire = ~(rst || ((siga) == (sigb)));		\
	label``_hw: `HQM_DEVTLB_ASSERT_SAME(siga, sigb, rst) 


//MCP Assertions

`define HQM_DEVTLB_ASSERT_SIGNAL_IS_PH2(clk,sig,constr_name) \
  `ifdef FEV \
     always \
  lira_transimply_``constr_name: $transimply("$rising",clk,"$unchanging",sig);\
  `endif \
  sva_``constr_name : `HQM_DEVTLB_ASSERT_STABLE_BETWEEN_TICKS_NEGEDGE(sig,clk,1'b0)      

`define HQM_DEVTLB_ASSERT_SIGNAL_IS_PH1(clk,sig,constr_name) \
  `ifdef FEV \
     always \
  lira_transimply_``constr_name: $transimply("$falling",clk,"$unchanging",sig);\
  `endif \
sva_``constr_name : `HQM_DEVTLB_ASSERT_STABLE_BETWEEN_TICKS_POSEDGE(sig,clk,1'b0)



// RLS Assertion task conversion

function automatic bit [2:0] f_DEVTLB_countones_4 (input bit [3:0] i);
begin
	unique casez (i)
		4'b0001 : f_DEVTLB_countones_4=3'b001;
		4'b0010 : f_DEVTLB_countones_4=3'b001;
		4'b0011 : f_DEVTLB_countones_4=3'b010;
		4'b0100 : f_DEVTLB_countones_4=3'b001;
		4'b0101 : f_DEVTLB_countones_4=3'b010;
		4'b0110 : f_DEVTLB_countones_4=3'b010;
		4'b0111 : f_DEVTLB_countones_4=3'b011;
		4'b1000 : f_DEVTLB_countones_4=3'b001;
		4'b1001 : f_DEVTLB_countones_4=3'b010;
		4'b1010 : f_DEVTLB_countones_4=3'b010;
		4'b1011 : f_DEVTLB_countones_4=3'b011;
		4'b1100 : f_DEVTLB_countones_4=3'b010;
		4'b1101 : f_DEVTLB_countones_4=3'b011;
		4'b1110 : f_DEVTLB_countones_4=3'b011;
		4'b1111 : f_DEVTLB_countones_4=3'b100;
		default : f_DEVTLB_countones_4=3'b000;
	endcase;
end
endfunction

function automatic bit [3:0] f_DEVTLB_countones_8 (input bit [7:0] i);
begin
	f_DEVTLB_countones_8={1'b0,f_DEVTLB_countones_4(i[7:4])}+{1'b0,f_DEVTLB_countones_4(i[3:0])};
end
endfunction

function automatic bit [4:0] f_DEVTLB_countones_16 (input bit [15:0] i);
begin
	f_DEVTLB_countones_16={1'b0,f_DEVTLB_countones_8(i[15:8])}+{1'b0,f_DEVTLB_countones_8(i[7:0])};
end
endfunction

function automatic bit [5:0] f_DEVTLB_countones_32 (input bit [31:0] i);
begin
	f_DEVTLB_countones_32={1'b0,f_DEVTLB_countones_16(i[31:16])}+{1'b0,f_DEVTLB_countones_16(i[15:0])};
end
endfunction

function automatic bit [6:0] f_DEVTLB_countones_64 (input bit [63:0] i);
begin
	f_DEVTLB_countones_64={1'b0,f_DEVTLB_countones_32(i[63:32])}+{1'b0,f_DEVTLB_countones_32(i[31:0])};
end
endfunction

function automatic bit [7:0] f_DEVTLB_countones_128 (input bit [127:0] i);
begin
	f_DEVTLB_countones_128={1'b0,f_DEVTLB_countones_64(i[127:64])}+{1'b0,f_DEVTLB_countones_64(i[63:0])};
end
endfunction

function automatic bit [8:0] f_DEVTLB_countones (input bit [255:0] i);
begin
	f_DEVTLB_countones={1'b0,f_DEVTLB_countones_128(i[255:128])}+{1'b0,f_DEVTLB_countones_128(i[127:0])};
end
endfunction

function automatic bit [1:0] f_DEVTLB_onehot_8 (input bit [7:0] i);
begin
	unique casez (i)
		8'b00000000 : f_DEVTLB_onehot_8=2'b00;
		8'b10000000 : f_DEVTLB_onehot_8=2'b01;
		8'b01000000 : f_DEVTLB_onehot_8=2'b01;
		8'b00100000 : f_DEVTLB_onehot_8=2'b01;
		8'b00010000 : f_DEVTLB_onehot_8=2'b01;
		8'b00001000 : f_DEVTLB_onehot_8=2'b01;
		8'b00000100 : f_DEVTLB_onehot_8=2'b01;
		8'b00000010 : f_DEVTLB_onehot_8=2'b01;
		8'b00000001 : f_DEVTLB_onehot_8=2'b01;
		default     : f_DEVTLB_onehot_8=2'b11;
	endcase;
end
endfunction

function automatic bit [1:0] f_DEVTLB_onehot_adder (input bit [1:0] i1,i2);
begin
	unique casez ({i1,i2})
		4'b0000 : f_DEVTLB_onehot_adder=2'b00;
		4'b0001 : f_DEVTLB_onehot_adder=2'b01;
		4'b0100 : f_DEVTLB_onehot_adder=2'b01;
		default : f_DEVTLB_onehot_adder=2'b11;
	endcase;
end
endfunction

function automatic bit [1:0] f_DEVTLB_onehot_16 (input bit [15:0] i);
begin
	f_DEVTLB_onehot_16=f_DEVTLB_onehot_adder(f_DEVTLB_onehot_8(i[15:8]),f_DEVTLB_onehot_8(i[7:0]));
end
endfunction

function automatic bit [1:0] f_DEVTLB_onehot_32 (input bit [31:0] i);
begin
	f_DEVTLB_onehot_32=f_DEVTLB_onehot_adder(f_DEVTLB_onehot_16(i[31:16]),f_DEVTLB_onehot_16(i[15:0]));
end
endfunction

function automatic bit [1:0] f_DEVTLB_onehot_64 (input bit [63:0] i);
begin
	f_DEVTLB_onehot_64=f_DEVTLB_onehot_adder(f_DEVTLB_onehot_32(i[63:32]),f_DEVTLB_onehot_32(i[31:0]));
end
endfunction

function automatic bit [1:0] f_DEVTLB_onehot_128 (input bit [127:0] i);
begin
	f_DEVTLB_onehot_128=f_DEVTLB_onehot_adder(f_DEVTLB_onehot_64(i[127:64]),f_DEVTLB_onehot_64(i[63:0]));
end
endfunction

function automatic bit f_DEVTLB_onehot (input bit [255:0] i);
begin
	bit [1:0] t;
	t=f_DEVTLB_onehot_adder(f_DEVTLB_onehot_128(i[255:128]),f_DEVTLB_onehot_128(i[127:0]));
	f_DEVTLB_onehot=((~t[1]) && t[0]);
end
endfunction

function automatic bit f_DEVTLB_onehot0 (input bit [255:0] i);
begin
	bit [1:0] t;
	t=f_DEVTLB_onehot_adder(f_DEVTLB_onehot_128(i[255:128]),f_DEVTLB_onehot_128(i[127:0]));
	f_DEVTLB_onehot0=~t[1];
end
endfunction

`endif
