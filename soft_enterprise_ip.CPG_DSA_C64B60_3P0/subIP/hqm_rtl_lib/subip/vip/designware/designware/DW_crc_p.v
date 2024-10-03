////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2000 - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Jay Zhu, March 25, 2000
//
// VERSION:   Verilog Simulation Model
//
// DesignWare_version: 54da00ec
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------------
//
// ABSTRACT : Generic parallel CRC Generator/Checker 
//
// MODIFIED :
//
//      RJK     09/10/2020      Increased max data_width to 2560 (Enh STAR 3372033)
//                              and adjusted parameter checking for consistency
//
//      LMSU    07/09/2015      Changed for compatibility with VCS Native Low Power
//
//	RJK	04/12/2011 	Recoded parts to clean for lint - STAR 9000444285
//
//-------------------------------------------------------------------------------

module	DW_crc_p(
		data_in,
		crc_in,
		crc_ok,
		crc_out
		);

parameter    integer data_width = 16;
parameter    integer poly_size  = 16;
parameter    integer crc_cfg    = 7;
parameter    integer bit_order  = 3;
parameter    integer poly_coef0 = 4129;
parameter    integer poly_coef1 = 0;
parameter    integer poly_coef2 = 0;
parameter    integer poly_coef3 = 0;

input [data_width-1:0]	data_in;
input [poly_size-1:0]	crc_in;
output			crc_ok;
output [poly_size-1:0]	crc_out;


// synopsys translate_off

`define	DW_max_data_crc_l (data_width>poly_size?data_width:poly_size)


wire [poly_size-1:0]		crc_in_inv;
wire [poly_size-1:0]		crc_reg;
wire [poly_size-1:0]		crc_out_inv;
wire [poly_size-1:0]		crc_chk_crc_in;

`ifdef UPF_POWER_AWARE
  `protected
M_.8dBc_SV=c5^g[A)]B=)Q38U;a^(Jc3a[-,d)7IAf^9YGN2AJN4);M)f<B7?<+
G\fCG5c_H)RVdf@\L,4C0EAZX^Z(@90EZK7I6<cf+IEB+B-K)VNgbC@.>PEL2]V?
4QBYT&Y)#EbMZVe#4bPCOfLG1C@KY<;Y.0=JWDY]BAQ&QGRPA@;HeFb#QWDeT1a\
Yg]RNFBOSBWdRA+1JHcReI=I,(5CCD^R:AFGaRQP<g)7D(T=aC)>a3WRS=\2QJCI
N.b<ae6X8Of/Id&Af9&gZ\AQNU/+eE7NPcXAVLP)/1HfMT=F.4bZB5@48Ig1/C_;
8:F=_I^H.>2CXYFJ.ZZAXXUYQ(g@CcO-8Y<=80U53^c\06LDb_9:^UZ:]Z6\;GJI
=V/9f3eBUfdXdcWOT0F>Q/NH]-VD5,OR/PHTGH]3H8PaK8>R;2X,3WQMG^/?CL[D
c0Pe7U._2BD#b(QfV1a,KX?dLd:_ff2(T[:?KTQ<P=eGBKI22RPRe93/W(GT/-4g
eb@UdCUJJ7bGGYJ:,#<R&f0RH\4c+7\9=-<W@g[.RGb9(S@#TPYQ.)Q,]=d.IAS1
5R)>5G+7#4>FM7/Q=:ZL=48c1-E32W>?XR;HcN4b5>?_MYXNQ+JN4a8]WDO9C;bE
#-7>=UB/7MGA6D6FAVe4XaY@7WWFNfCIbUHb@8aRM>6gIM9(Q-+d4_46-@T]Fg0P
35LEJ>-JLc6W^0<JNBcVVTXNE)1f=K8Y-&(Z)C(6>,GcF[e88O/UbAJ)HITIWN;,
&e?5-=J5dA2K3DaZYV1T@=1P5O&;OX,9d-Jd-gI7[&-M0D2M5=8Yc#f^Vd7GbAfT
5\36:cdgYYeCPVVJ0]M)8e#&K-2248+SVHYLSA6:XUf7d5;NQb7B;+UHW7V)=B)a
1V3;gO<cdg+LM.GS0&+eQI]9S:Q6Y0_I8WW7I6?Z-<(TP?E4Te_J7\A\RUbA[>MK
S:8OQTM@UV/AO0gZ&BR9E7d6CER>1-&P.KII9d\8>X^CM],^LINf:S2-((RVdS:W
/c_gW)b/,^T(>M;[3SJW+1dB96HeC)fQf3gZS?;C]3-daKJW,ba0BDNL(a+<.+OI
&)VS+#5CC[LD97+HDE1QaFbJ9_U4@6;DO3B3P>edb,XW5Q\AdF,<76OeY44=+FU;
0?F6/&-AC>:V0[KJ#5XD)\.73E4Z.YV#Q7&B5G@0c;BT10X+CdI>YL03824,d6?Y
E.@RIHK3YSIVL1.JI>[MPE)?PGg9-?[eg@BfFSO@b@Y/\HLWHZXP]YND2)[Ef]Ed
4W.c.03^TOG?ZcYT1_J8-S9NCXdOJGSYWO<TI/:3DVV3,A4#VC5HMWH?-4EcM#M1
4L]\TA.I>[<&-]I?bDZ9M37Me4bC/BcE(aA83gdN8^U<A^(;W=UX;(/Y&T^Gg8A4
NG]BaWf3-_#-edLL-U;J?Q:LdJEL8K5Tf3M7&g#Ce6.CMZ.cK2Ue/_MQ_Dg2:5@<
B=0[KJAbRY:[C<&aDA-D\PWQCJ<D#Y(H6c?\^=79fWJ+R)<Q&)U/^FD5P;Tf/A1N
B;_.Q0O5][C#JAc6^4d)Dg].9[6V8W-eF9cYacORSeRTBa8ceW&-g^ZF,C;O,bO=
ET4_;J2[d]65QdS3K1dT+_I^fF9G)J1S7VNC@4F[0#9Tg38eb[\GWaZFO$
`endprotected

`else
reg [poly_size-1:0]             crc_inv_alt;
reg [poly_size-1:0]             crc_polynomial;
`endif

function [`DW_max_data_crc_l-1:0]	bit_ordering;
    input [`DW_max_data_crc_l-1:0]	input_data;
    input [31:0]		v_width;

    begin : function_bit_ordering

	integer			width;
	integer			byte_idx;
	integer			bit_idx;

	width = v_width;

	case (bit_order) 
	    0 :
	  	bit_ordering = input_data;
	    1 :
		for(bit_idx=0; bit_idx<width; bit_idx=bit_idx+1)
		  bit_ordering[bit_idx] = input_data[width-bit_idx-1];
	    2 :
	  	for(byte_idx=0; byte_idx<width/8; byte_idx=byte_idx+1)
		  for(bit_idx=0;
		      bit_idx<8;
		      bit_idx=bit_idx+1)
	            bit_ordering[bit_idx+byte_idx*8]
		      = input_data[bit_idx+(width/8-byte_idx-1)*8];
	    3 :
		for(byte_idx=0; byte_idx<width/8; byte_idx=byte_idx+1)
		  for(bit_idx=0; bit_idx<8; bit_idx=bit_idx+1)
		    bit_ordering[byte_idx*8+bit_idx]
		          = input_data[(byte_idx+1)*8-1-bit_idx];
	    default : 
		begin 
		    $display("ERROR: %m : Internal Error.  Please report to Synopsys representative."); 
		    $finish; 
		end
	endcase

    end
endfunction // bit_ordering

function [poly_size-1 : 0] bit_order_crc;

    input [poly_size-1 : 0] crc_in;

    begin : function_bit_order_crc

        reg [`DW_max_data_crc_l-1 : 0] input_value;
        reg [`DW_max_data_crc_l-1 : 0] return_value;
	integer i;

	input_value = {`DW_max_data_crc_l{1'b0}};

	for (i=0 ; i < poly_size ; i=i+1)
	  input_value[i] = crc_in[i];

	return_value = bit_ordering(input_value,poly_size);

	bit_order_crc = return_value[poly_size-1 : 0];
    end
endfunction // bit_order_crc


function [data_width-1 : 0] bit_order_data;

    input [data_width-1 : 0] data_in;

    begin : function_bit_order_data

        reg [`DW_max_data_crc_l-1 : 0] input_value;
        reg [`DW_max_data_crc_l-1 : 0] return_value;
	integer i;

	input_value = {`DW_max_data_crc_l{1'b0}};

	for (i=0 ; i < data_width ; i=i+1)
	  input_value[i] = data_in[i];

	return_value = bit_ordering(input_value,data_width);

	bit_order_data = return_value[data_width-1 : 0];
    end
endfunction // bit_order_data


function [poly_size-1:0]	calculate_crc_w_in;

    input [poly_size-1:0]		crc_in;
    input [`DW_max_data_crc_l-1:0]	input_data;
    input [31:0]			width0;

    begin : function_calculate_crc_w_in

	integer			width;
	reg			feedback_bit;
	reg [poly_size-1:0]	feedback_vector;
	integer			bit_idx;

	width = width0;
	calculate_crc_w_in = crc_in;
	for(bit_idx=width-1; bit_idx>=0; bit_idx=bit_idx-1) begin
	    feedback_bit = calculate_crc_w_in[poly_size-1]
				^ input_data[bit_idx];
	    feedback_vector = {poly_size{feedback_bit}};

	    calculate_crc_w_in = {calculate_crc_w_in[poly_size-2:0],1'b0}
	  		^ (crc_polynomial & feedback_vector);
	end

    end
endfunction // calculate_crc_w_in


function [poly_size-1:0]	calculate_crc;
    input [data_width-1:0]	input_data;

    begin : function_calculate_crc

	reg [`DW_max_data_crc_l-1:0]	input_value;
	reg [poly_size-1:0]		crc_tmp;
	integer i;

	input_value = {`DW_max_data_crc_l{1'b0}};

	for (i=0 ; i < data_width ; i=i+1)
	  input_value[i] = input_data[i];

	crc_tmp = {poly_size{(crc_cfg % 2)?1'b1:1'b0}};
	calculate_crc = calculate_crc_w_in(crc_tmp, input_value,
			data_width);
    end
endfunction // calculate_crc_crc


function [poly_size-1:0]	calculate_crc_crc;
    input [poly_size-1:0]	input_crc;
    input [poly_size-1:0]	input_data;

    begin : function_calculate_crc_crc

	reg [`DW_max_data_crc_l-1:0]	input_value;
	reg [poly_size-1:0]		crc_tmp;
	integer i;

	input_value = {`DW_max_data_crc_l{1'b0}};

	for (i=0 ; i < poly_size ; i=i+1)
	  input_value[i] = input_data[i];

	calculate_crc_crc = calculate_crc_w_in(input_crc, input_value,
			poly_size);
    end
endfunction // calculate_crc_crc


    
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    

	
    if ( (data_width < 1) || (data_width > 2560) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter data_width (legal range: 1 to 2560)",
	data_width );
    end
	
    if ( (poly_size < 2) || (poly_size > 64) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter poly_size (legal range: 2 to 64)",
	poly_size );
    end
	
    if ( (crc_cfg < 0) || (crc_cfg > 7) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter crc_cfg (legal range: 0 to 7)",
	crc_cfg );
    end
	
    if ( (bit_order < 0) || (bit_order > 3) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter bit_order (legal range: 0 to 3)",
	bit_order );
    end
	
    if ( (poly_coef0 < 1) || (poly_coef0 > 65535) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter poly_coef0 (legal range: 1 to 65535)",
	poly_coef0 );
    end
	
    if ( (poly_coef1 < 0) || (poly_coef1 > 65535) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter poly_coef1 (legal range: 0 to 65535)",
	poly_coef1 );
    end
	
    if ( (poly_coef2 < 0) || (poly_coef2 > 65535) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter poly_coef2 (legal range: 0 to 65535)",
	poly_coef2 );
    end
	
    if ( (poly_coef3 < 0) || (poly_coef3 > 65535) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter poly_coef3 (legal range: 0 to 65535)",
	poly_coef3 );
    end
	
    if ( (poly_coef0 % 2)==0 ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m : Invalid parameter (poly_coef0 value MUST be odd)" );
    end
	
    if ( (bit_order>1) && ((data_width % 8) > 0) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m : Invalid parameter combination (bit_order > 1 is only allowed when data_width is a multiple of 8)" );
    end
	
    if ( (bit_order>1) && ((poly_size % 8) > 0) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m : Invalid parameter combination (bit_order > 1 is only allowed when poly_size is a moltiple of 8)" );
    end
    
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 



`ifndef UPF_POWER_AWARE
    initial begin : initialize_vars

	reg [63:0]	crc_polynomial64;
	reg [15:0]	coef0;
	reg [15:0]	coef1;
	reg [15:0]	coef2;
	reg [15:0]	coef3;
	integer		bit_idx;

	coef0 = poly_coef0;
	coef1 = poly_coef1;
	coef2 = poly_coef2;
	coef3 = poly_coef3;

	crc_polynomial64 = {coef3, coef2, coef1, coef0};
	crc_polynomial = crc_polynomial64[poly_size-1:0];

	case(crc_cfg/2)
	    0 : crc_inv_alt = {poly_size{1'b0}};
	    1 : for(bit_idx=0; bit_idx<poly_size; bit_idx=bit_idx+1)
		crc_inv_alt[bit_idx] = (bit_idx % 2)? 1'b0 : 1'b1;
	    2 : for(bit_idx=0; bit_idx<poly_size; bit_idx=bit_idx+1)
		crc_inv_alt[bit_idx] = (bit_idx % 2)? 1'b1 : 1'b0;
	    3 : crc_inv_alt = {poly_size{1'b1}};
	    default : 
		begin 
		    $display("ERROR: %m : Internal Error.  Please report to Synopsys representative."); 
		    $finish; 
		end
	endcase

    end // initialize_vars


`endif
    assign	crc_in_inv = bit_order_crc(crc_in) ^ crc_inv_alt;

    assign	crc_reg = calculate_crc(bit_order_data(data_in));

    assign	crc_out_inv = crc_reg ^ crc_inv_alt;
    assign	crc_out = bit_order_crc(crc_out_inv);
    assign	crc_chk_crc_in = calculate_crc_crc(crc_reg, crc_in_inv);
    assign	crc_ok = ! (| crc_chk_crc_in);


`undef	DW_max_data_crc_l

// synopsys translate_on

endmodule
