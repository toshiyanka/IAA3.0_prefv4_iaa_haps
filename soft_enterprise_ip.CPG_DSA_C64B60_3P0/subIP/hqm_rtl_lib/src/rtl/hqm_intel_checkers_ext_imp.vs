`ifndef HQM_SVA_LIB_DONT_SYNTHESIZE_BOOL_SF

// VCS / LIRA today handle $onehot / $countones also in constraints
// RLS flow probably uses different synthesis tool, which doesn't compile
// $onehot / $countones.
// The goal of the separation is not to lose optimizations that are done 
// in the tools.

function automatic bit [2:0] hqm_f_countones_4 (input bit [3:0] i);
begin
	unique casez (i)
		4'b0001 : hqm_f_countones_4=3'b001;
		4'b0010 : hqm_f_countones_4=3'b001;
		4'b0011 : hqm_f_countones_4=3'b010;
		4'b0100 : hqm_f_countones_4=3'b001;
		4'b0101 : hqm_f_countones_4=3'b010;
		4'b0110 : hqm_f_countones_4=3'b010;
		4'b0111 : hqm_f_countones_4=3'b011;
		4'b1000 : hqm_f_countones_4=3'b001;
		4'b1001 : hqm_f_countones_4=3'b010;
		4'b1010 : hqm_f_countones_4=3'b010;
		4'b1011 : hqm_f_countones_4=3'b011;
		4'b1100 : hqm_f_countones_4=3'b010;
		4'b1101 : hqm_f_countones_4=3'b011;
		4'b1110 : hqm_f_countones_4=3'b011;
		4'b1111 : hqm_f_countones_4=3'b100;
		default : hqm_f_countones_4=3'b000;
	endcase
end
endfunction

function automatic bit [3:0] hqm_f_countones_8 (input bit [7:0] i);
begin
	hqm_f_countones_8=hqm_f_countones_4(i[7:4])+hqm_f_countones_4(i[3:0]); // lintra s-0393
end
endfunction

function automatic bit [4:0] hqm_f_countones_16 (input bit [15:0] i);
begin
	hqm_f_countones_16=hqm_f_countones_8(i[15:8])+hqm_f_countones_8(i[7:0]); // lintra s-0393
end
endfunction

function automatic bit [5:0] hqm_f_countones_32 (input bit [31:0] i);
begin
	hqm_f_countones_32=hqm_f_countones_16(i[31:16])+hqm_f_countones_16(i[15:0]); // lintra s-0393
end
endfunction

function automatic bit [6:0] hqm_f_countones_64 (input bit [63:0] i);
begin
	hqm_f_countones_64=hqm_f_countones_32(i[63:32])+hqm_f_countones_32(i[31:0]); // lintra s-0393
end
endfunction

function automatic bit [7:0] hqm_f_countones_128 (input bit [127:0] i);
begin
	hqm_f_countones_128=hqm_f_countones_64(i[127:64])+hqm_f_countones_64(i[63:0]); // lintra s-0393
end
endfunction

function automatic bit [8:0] hqm_f_countones (input bit [255:0] i);
begin
	hqm_f_countones=hqm_f_countones_128(i[255:128])+hqm_f_countones_128(i[127:0]); // lintra s-0393
end
endfunction

function automatic bit [1:0] hqm_f_onehot_8 (input bit [7:0] i);
begin
	unique casez (i)
		8'b00000000 : hqm_f_onehot_8=2'b00;
		8'b10000000 : hqm_f_onehot_8=2'b01;
		8'b01000000 : hqm_f_onehot_8=2'b01;
		8'b00100000 : hqm_f_onehot_8=2'b01;
		8'b00010000 : hqm_f_onehot_8=2'b01;
		8'b00001000 : hqm_f_onehot_8=2'b01;
		8'b00000100 : hqm_f_onehot_8=2'b01;
		8'b00000010 : hqm_f_onehot_8=2'b01;
		8'b00000001 : hqm_f_onehot_8=2'b01;
		default     : hqm_f_onehot_8=2'b11;
	endcase
end
endfunction

function automatic bit [1:0] hqm_f_onehot_adder (input bit [1:0] i1,i2);
begin
	unique casez ({i1,i2})
		4'b0000 : hqm_f_onehot_adder=2'b00;
		4'b0001 : hqm_f_onehot_adder=2'b01;
		4'b0100 : hqm_f_onehot_adder=2'b01;
		default : hqm_f_onehot_adder=2'b11;
	endcase
end
endfunction

function automatic bit [1:0] hqm_f_onehot_16 (input bit [15:0] i);
begin
	hqm_f_onehot_16=hqm_f_onehot_adder(hqm_f_onehot_8(i[15:8]),hqm_f_onehot_8(i[7:0]));
end
endfunction

function automatic bit [1:0] hqm_f_onehot_32 (input bit [31:0] i);
begin
	hqm_f_onehot_32=hqm_f_onehot_adder(hqm_f_onehot_16(i[31:16]),hqm_f_onehot_16(i[15:0]));
end
endfunction

function automatic bit [1:0] hqm_f_onehot_64 (input bit [63:0] i);
begin
	hqm_f_onehot_64=hqm_f_onehot_adder(hqm_f_onehot_32(i[63:32]),hqm_f_onehot_32(i[31:0]));
end
endfunction

function automatic bit [1:0] hqm_f_onehot_128 (input bit [127:0] i);
begin
	hqm_f_onehot_128=hqm_f_onehot_adder(hqm_f_onehot_64(i[127:64]),hqm_f_onehot_64(i[63:0]));
end
endfunction

function automatic bit hqm_f_onehot (input bit [255:0] i);
begin
	bit [1:0] t;
	t=hqm_f_onehot_adder(hqm_f_onehot_128(i[255:128]),hqm_f_onehot_128(i[127:0]));
	hqm_f_onehot=((~t[1]) && t[0]);
end
endfunction

function automatic bit hqm_f_onehot0 (input bit [255:0] i);
begin
	bit [1:0] t;
	t=hqm_f_onehot_adder(hqm_f_onehot_128(i[255:128]),hqm_f_onehot_128(i[127:0]));
	hqm_f_onehot0=~t[1];
end
endfunction

`endif
