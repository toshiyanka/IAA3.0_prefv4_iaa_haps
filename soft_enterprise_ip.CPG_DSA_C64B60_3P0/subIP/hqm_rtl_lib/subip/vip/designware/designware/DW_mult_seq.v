////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2002 - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Aamir Farooqui                February 12, 2002
//
// VERSION:   Verilog Simulation Model for DW_mult_seq
//
// DesignWare_version: c7060fd6
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
//
//ABSTRACT:  Sequential Multiplier 
// Uses modeling functions from DW_Foundation.
//
//MODIFIED:
// 2/26/16 LMSU Updated to use blocking and non-blocking assigments in
//              the correct way
// 8/06/15 RJK Update to support VCS-NLP
// 2/06/15 RJK  Updated input change monitor for input_mode=0 configurations to better
//             inform designers of severity of protocol violations (STAR 9000851903)
// 5/20/14 RJK  Extended corruption of output until next start for configurations
//             with input_mode = 0 (STAR 9000741261)
// 9/25/12 RJK  Corrected data corruption detection to catch input changes
//             during the first cycle of calculation (related to STAR 9000505348)
// 1/5/12 RJK Change behavior when inputs change during calculation with
//          input_mode = 0 to corrupt output (STAR 9000505348)
//
//------------------------------------------------------------------------------

module DW_mult_seq ( clk, rst_n, hold, start, a,  b, complete, product);


// parameters 

  parameter  integer a_width     = 3; 
  parameter  integer b_width     = 3;
  parameter  integer tc_mode     = 0;
  parameter  integer num_cyc     = 3;
  parameter  integer rst_mode    = 0;
  parameter  integer input_mode  = 1;
  parameter  integer output_mode = 1;
  parameter  integer early_start = 0;
 
//-----------------------------------------------------------------------------

// ports 
  input clk, rst_n;
  input hold, start;
  input [a_width-1:0] a;
  input [b_width-1:0] b;

  output complete;
  output [a_width+b_width-1:0] product;

//-----------------------------------------------------------------------------
// synopsys translate_off

localparam signed [31:0] CYC_CONT = (input_mode==1 & output_mode==1 & early_start==0)? 3 :
                                    (input_mode==early_start & output_mode==0)? 1 : 2;

//-------------------Integers-----------------------
  integer count;
  integer next_count;
 

//-----------------------------------------------------------------------------
// wire and registers 

  wire clk, rst_n;
  wire hold, start;
  wire [a_width-1:0] a;
  wire [b_width-1:0] b;
  wire complete;
  wire [a_width+b_width-1:0] product;

  wire [a_width+b_width-1:0] temp_product;
  reg [a_width+b_width-1:0] ext_product;
  reg [a_width+b_width-1:0] next_product;
  wire [a_width+b_width-2:0] long_temp1,long_temp2;
  reg [a_width-1:0]   in1;
  reg [b_width-1:0]   in2;
  reg [a_width-1:0]   next_in1;
  reg [b_width-1:0]   next_in2;
 
  wire [a_width-1:0]   temp_a;
  wire [b_width-1:0]   temp_b;

  wire start_n;
  wire hold_n;
  reg ext_complete;
  reg next_complete;
 


//-----------------------------------------------------------------------------
  
  
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
    
    if (b_width < 3) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter b_width (lower bound: 3)",
	b_width );
    end
    
    if ( (a_width < 3) || (a_width > b_width) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter a_width (legal range: 3 to b_width)",
	a_width );
    end
    
    if ( (num_cyc < 3) || (num_cyc > a_width) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter num_cyc (legal range: 3 to a_width)",
	num_cyc );
    end
    
    if ( (tc_mode < 0) || (tc_mode > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter tc_mode (legal range: 0 to 1)",
	tc_mode );
    end
    
    if ( (rst_mode < 0) || (rst_mode > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter rst_mode (legal range: 0 to 1)",
	rst_mode );
    end
    
    if ( (input_mode < 0) || (input_mode > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter input_mode (legal range: 0 to 1)",
	input_mode );
    end
    
    if ( (output_mode < 0) || (output_mode > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter output_mode (legal range: 0 to 1)",
	output_mode );
    end
    
    if ( (early_start < 0) || (early_start > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter early_start (legal range: 0 to 1)",
	early_start );
    end
    
    if ( (input_mode===0 && early_start===1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m : Invalid parameter combination: when input_mode=0, early_start=1 is not possible" );
    end

  
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 


//------------------------------------------------------------------------------

  assign start_n      = ~start;
  assign complete     = ext_complete & start_n;

  assign temp_a       = (in1[a_width-1])? (~in1 + 1'b1) : in1;
  assign temp_b       = (in2[b_width-1])? (~in2 + 1'b1) : in2;
  assign long_temp1   = temp_a*temp_b;
  assign long_temp2   = ~(long_temp1 - 1'b1);
  assign temp_product = (tc_mode)? (((in1[a_width-1] ^ in2[b_width-1]) && (|long_temp1))?
                                {1'b1,long_temp2} : {1'b0,long_temp1}) : in1*in2;

// Begin combinational next state assignments
  always @ (start or hold or a or b or count or in1 or in2 or
            temp_product or ext_product or ext_complete) begin
    if (start === 1'b1) begin                     // Start operation
      next_in1      = a;
      next_in2      = b;
      next_count    = 0;
      next_complete = 1'b0;
      next_product  = {a_width+b_width{1'bX}};
    end else if (start === 1'b0) begin            // Normal operation
      if (hold === 1'b0) begin
        if (count >= (num_cyc+CYC_CONT-4)) begin
          next_in1      = in1;
          next_in2      = in2;
          next_count    = count; 
          next_complete = 1'b1;
          next_product  = temp_product;
        end else if (count === -1) begin
          next_in1      = {a_width{1'bX}};
          next_in2      = {b_width{1'bX}};
          next_count    = -1; 
          next_complete = 1'bX;
          next_product  = {a_width+b_width{1'bX}};
        end else begin
          next_in1      = in1;
          next_in2      = in2;
          next_count    = count+1; 
          next_complete = 1'b0;
          next_product  = {a_width+b_width{1'bX}};
        end
      end else if (hold === 1'b1) begin           // Hold operation
        next_in1      = in1;
        next_in2      = in2;
        next_count    = count; 
        next_complete = ext_complete;
        next_product  = ext_product;
      end else begin                              // hold == x
        next_in1      = {a_width{1'bX}};
        next_in2      = {b_width{1'bX}};
        next_count    = -1;
        next_complete = 1'bX;
        next_product  = {a_width+b_width{1'bX}};
      end
    end else begin                                // start == x
      next_in1      = {a_width{1'bX}};
      next_in2      = {b_width{1'bX}};
      next_count    = -1;
      next_complete = 1'bX;
      next_product  = {a_width+b_width{1'bX}};
    end
  end
// end combinational next state assignments

generate
  if (rst_mode == 0) begin : GEN_RM_EQ_0

  // Begin sequential assignments
    always @ ( posedge clk or negedge rst_n ) begin: ar_register_PROC
      if (rst_n === 1'b0) begin                   // initialize everything asyn reset
        count        <= 0;
        in1          <= 0;
        in2          <= 0;
        ext_product  <= 0;
        ext_complete <= 0;
      end else if (rst_n === 1'b1) begin          // rst_n == 1
        count        <= next_count;
        in1          <= next_in1;
        in2          <= next_in2;
        ext_product  <= next_product;
        ext_complete <= next_complete & start_n;
      end else begin                              // rst_n == X
        in1          <= {a_width{1'bX}};
        in2          <= {b_width{1'bX}};
        count        <= -1;
        ext_product  <= {a_width+b_width{1'bX}};
        ext_complete <= 1'bX;
      end 
   end // ar_register_PROC

  end else  begin : GEN_RM_NE_0

  // Begin sequential assignments
    always @ ( posedge clk ) begin: sr_register_PROC 
      if (rst_n === 1'b0) begin                   // initialize everything asyn reset
        count        <= 0;
        in1          <= 0;
        in2          <= 0;
        ext_product  <= 0;
        ext_complete <= 0;
      end else if (rst_n === 1'b1) begin          // rst_n == 1
        count        <= next_count;
        in1          <= next_in1;
        in2          <= next_in2;
        ext_product  <= next_product;
        ext_complete <= next_complete & start_n;
      end else begin                              // rst_n == X
        in1          <= {a_width{1'bX}};
        in2          <= {b_width{1'bX}};
        count        <= -1;
        ext_product  <= {a_width+b_width{1'bX}};
        ext_complete <= 1'bX;
      end 
   end // ar_register_PROC

  end
endgenerate

  wire corrupt_data;

generate
  if (input_mode == 0) begin : GEN_IM_EQ_0

    localparam [0:0] NO_OUT_REG = (output_mode == 0)? 1'b1 : 1'b0;
    reg [a_width-1:0] ina_hist;
    reg [b_width-1:0] inb_hist;
    wire next_corrupt_data;
    reg  corrupt_data_int;
    wire data_input_activity;
    reg  init_complete;
    wire next_alert1;
    integer change_count;

    assign next_alert1 = next_corrupt_data & rst_n & init_complete &
                                    ~start & ~complete;

    if (rst_mode == 0) begin : GEN_A_RM_EQ_0
      always @ (posedge clk or negedge rst_n) begin : ar_hist_regs_PROC
	if (rst_n === 1'b0) begin
	    ina_hist        <= a;
	    inb_hist        <= b;
	    change_count    <= 0;

	  init_complete   <= 1'b0;
	  corrupt_data_int <= 1'b0;
	end else begin
	  if ( rst_n === 1'b1) begin
	    if ((hold != 1'b1) || (start == 1'b1)) begin
	      ina_hist        <= a;
	      inb_hist        <= b;
	      change_count    <= (start == 1'b1)? 0 :
	                         (next_alert1 == 1'b1)? change_count + 1 : change_count;
	    end

	    init_complete   <= init_complete | start;
	    corrupt_data_int<= next_corrupt_data | (corrupt_data_int & ~start);
	  end else begin
	    ina_hist        <= {a_width{1'bx}};
	    inb_hist        <= {b_width{1'bx}};
	    change_count    <= -1;
	    init_complete   <= 1'bx;
	    corrupt_data_int <= 1'bX;
	  end
	end
      end
    end else begin : GEN_A_RM_NE_0
      always @ (posedge clk) begin : sr_hist_regs_PROC
	if (rst_n === 1'b0) begin
	    ina_hist        <= a;
	    inb_hist        <= b;
	    change_count    <= 0;
	  init_complete   <= 1'b0;
	  corrupt_data_int <= 1'b0;
	end else begin
	  if ( rst_n === 1'b1) begin
	    if ((hold != 1'b1) || (start == 1'b1)) begin
	      ina_hist        <= a;
	      inb_hist        <= b;
	      change_count    <= (start == 1'b1)? 0 :
	                         (next_alert1 == 1'b1)? change_count + 1 : change_count;
	    end

	    init_complete   <= init_complete | start;
	    corrupt_data_int<= next_corrupt_data | (corrupt_data_int & ~start);
	  end else begin
	    ina_hist        <= {a_width{1'bx}};
	    inb_hist        <= {b_width{1'bx}};
	    init_complete    <= 1'bx;
	    corrupt_data_int <= 1'bX;
	    change_count     <= -1;
	  end
	end
      end
    end // GEN_A_RM_NE_0

    assign data_input_activity =  (((a !== ina_hist)?1'b1:1'b0) |
				 ((b !== inb_hist)?1'b1:1'b0)) & rst_n;

    assign next_corrupt_data = (NO_OUT_REG | ~complete) &
                              (data_input_activity & ~start &
					~hold & init_complete);

`ifdef UPF_POWER_AWARE
  `protected
:BI77538X>YM#RP[:-_4B;44Z<O^SAa=9Gb-HDeIW+9FD<>#/Ze.1)_1WBcgNM73
>bORe6\CV3gSdQITF1eDR(FCKeC@f9dZ)g=e_#Q[2=?7LgTV-4<2P]^e5CTP<^AP
fg1,gN:P7K/V>?4YI=7MM.CFMeaT0WNPI\</SN_;@5M9J_8_KFcGOV(,BD]IbT0J
PBRT.#)F+Z[I-NQ2SR<ZJf#eI=Hf=@Z71]P&>DT&:493@\,N?,V(Q/E#?S8Ia,XC
FLfgLSZIJ9S>:RLH&ZGC8C8;0QZgO&3X/3^Z<8W^aF8SBI&1,B02/c<5HQ/-X?O^
@3Y<PNG,1J#6\?>6gDBV8>QUd)d0M()7HKg<D8)c7D6:P>-)HeW2.PXg_MX5IbC-
2X13Z1Mf<>/df@<<M1]CXFJP_I.Mg,Bf\^]UH:U:70R;ENbLRX<;7E/.E=6XA+2&
X^]L>DMe[>8f\DQW,UQVZUa-]]_ScfN;IBW[-<R4C+ZQWH[G7OPcdG9(Zd79#0BE
M]JN.O0>WabNR3S[MJQ?BPU?WCZ?>df^JGeeWMF2d9f_#PbM;:1Wb^E;WPYPM4<[
\_WAILNXgMg;.]Kf,7R_UO(949^e1S2BDF1-\4]/1#OD3SRcU?A<0&<99Kf2J0/:
]eJ4SZ]1D3G[V7-[HdI5)4,/&\L9S>=g,VLND66@J01MV5:bJ^PLZSYPBT(>3J)5
N_#OHXV7#/I<MgV4B:MT4?c(;&17=?TE?VJ/V.:#GbZT+KCTcZe02F#a>YNb#-UL
N;:XYA10>NI9/X:<C8-V>;&8US)H#6=.gLGf9IJ28T-dBgg[CPX3JeV[<^NQXA4J
7CT66ca+I4Y3&5N)SZYV5Y.X.H^X2:\NeO>9RG4d6#=:P.FdT2AXQ6RSf;1VN1,Q
<JE0+.<7[Mfa:a4Dg2VS1HXP]@VFG?-,fR1J-V@#,fR67A>2)<a-6c(ZFY\B35BO
adR4NV07H1,GDTQIea2UfWB,#Z2@..]<67[MBT^UbQf?+_ZY.REEeZ[cXLM.ZOP<
XFEK4fQB;;,T5dP(8(P\5N696_,UE_:?>/+J<aH]^/K-T2MR(N^V/?KSHMN\#f55
#NS0B5]3YaZ9VG&QY<R^g--[@a<BI2R__\bB@^DdX-8(-LMFg/8eXQa:JK=CK&1+
Gb/J;0CZE5-DYK6\\=dL4U6IGPK#K7#Q,>MbCD6ZKgY\<3DGXE4.+R@Yb[(16@3\
@&+E[^=V4^8G8.[[/<B7gB1Z:V7PG+a^Z3=BT5d;3KL6P@=f2,N?XM0T737(IJQS
/JIP6)\)BZ=2GVD&=8I)80LB6EIMN:#I4:1fUPC^?[R^LQ^A+e4;WSG(VOP0::[.
J\,_C]f>/2Q1<>MXSaN;HQ0;D7:[8\Oba<]?(:,/Ef)KPA@XF3gXLA5TFSKSVNZL
HX^G8L0dU,]Id/5R6:\6WVJNAOD21D7D#5aOg1AUN,?BC.+eB]>L5]A,FBb?M?EI
^.TP?00H[H\=R#-^Oe@W8BIAD&:L:d;fe.+GR]f\6_5^^gK6MS=]\A7:N^:<38(C
E5EGHe;4MN:R8\f?bBF=>>[[g(+C;aG+:BH(P^(II@aPf^<S[RPW;FX3<K5B[A?K
#HS&I=JW?&3X/>_>_@cOR/8JT<8:Q917BPDS5a42d:F<WVZAFU?F,@/4(NP8?1KB
-dGFKF&GF)D(c](RXZ5+3#(:eb(YM82eM\eL.JN?.0E[3:&BQ_0)A0U^V=[O1=G<
S47JX+e9\04&.]GM6_e,-VK,C)0O-OMQ\-?Qf-]Z<Q81c,G3a()+dC)L?SBYH;^K
?D8M/+M2T,K6.J_&GF8HH0(E]64>MG#(M4(@)7A/33cLd>PMXF-a56<+>;a4T4K>
/2bC&?Z\[I0QCQE7ZZU=E10KSB9e&Sg3e[_>=cI^<7YGUPdK:4B,W?2?[;>WGDc[
gHUR=H?Q6=S]c(NG@^]KX-SF_.UIT?MeIU/@OHL^7?CT]N(<cWTb5SXZc9KH0^@2
18PI9883N1eJT0KPT[IeWT?Y2M#])e)6)Kc@498Se3e-P-BgR#PeDX(WXKX@(/DW
^b^A9<[_g\8#YZfP9\4&.\?LA(]>DKfH]WK0-gVA/?6R_D<SgS8NWM0.BRDS28YB
D1Yg9aR92H:HJFFM6Hb]Tfg7D(bFS85#=B5MK&^:gD7M(7SPP9F=bU.gf?><Z9CY
KZN^[;1(H;bI((#S[G2+IF&15RVRS8:1X27a,2^ZC&=WNF())C<)M,ZI+/IZ5=OV
EDQ:<]CPdHXM1C5,N-XZ_0;dA&#A9c=DV0.\;/@-DaF74C7=C4&>03U-DFL([?8L
]1JR^,31@7\V7X9\J7<9bN<I7G?6B6FX0YG<5U7297FH-9]A;f5DcTAZ\4ES5Q1&
_>3?V^He)#P14YcCPC.A=(32?N)=V@\V/NJ_a#_#A1+T\E.g@\NRAAYRgOXXAWS]
8ENe(#DaVfGYRg?W9+:&?<RDLC0)=NJFFcg5c[^@U=[_N]HVVTb4_V0P4]M?:bU[
^0(]:N2dV];:G8MO:DF4?Af5=\I_R.fAZP.6ID-^2_;9T6K@N25U<XP7BF85B0bI
.FAJ=&Y<@WBCZP\X5M?20fGS:YC];3MLM+a?N0>(ZR&\c=Pc<G:1,D>75C,1&68f
8cd+.OF.@AMC0$
`endprotected

`else
    always @ (posedge clk) begin : corrupt_alert_PROC
      integer updated_count;

      updated_count = change_count;

      if (next_alert1 == 1'b1) begin
`ifndef DW_SUPPRESS_WARN
          $display ("WARNING: %m:\n at time = %0t: Operand input change on DW_mult_seq during calculation (configured without an input register) will cause corrupted results if operation is allowed to complete.", $time);
`endif
	updated_count = updated_count + 1;
      end

      if (((rst_n & init_complete & ~start & ~complete & next_complete) == 1'b1) &&
          (updated_count > 0)) begin
	$display(" ");
	$display("############################################################");
	$display("############################################################");
	$display("##");
	$display("## Error!! : from %m");
	$display("##");
	$display("##    This instance of DW_mult_seq has encountered %0d change(s)", updated_count);
	$display("##    on operand input(s) after starting the calculation.");
	$display("##    The instance is configured with no input register.");
	$display("##    So, the result of the operation was corrupted.  This");
	$display("##    message is generated at the point of completion of");
	$display("##    the operation (at time %0d), separate warning(s) were", $time );
`ifndef DW_SUPPRESS_WARN
	$display("##    generated earlier during calculation.");
`else
	$display("##    suppressed earlier during calculation.");
`endif
	$display("##");
	$display("############################################################");
	$display("############################################################");
	$display(" ");
      end
    end
`endif

    assign corrupt_data = corrupt_data_int;

  if (output_mode == 0) begin : GEN_OM_EQ_0
    reg  alert2_issued;
    wire next_alert2;

    assign next_alert2 = next_corrupt_data & rst_n & init_complete &
                                     ~start & complete & ~alert2_issued;

`ifdef UPF_POWER_AWARE
  `protected
Ef1/MK8#0A)MQ)]J3I_KVVMQS7P^JW8UB_QQ=_6#I&+#CXX[/^;=()JK-L+BT.Yg
C808&bE>4O)JIE4+8NeGK\1bJd&NQ8F+C65cVJ(3HcC#@Z#:_B-,)C>+_Hb&,fNB
@e072Y9QaQg&Q^I+@FMcJ[V-L<S8A4Z#B^UG0abDS=/(:6JODC;E9aY(Q9LV_=@C
?,)LbVG5CddWP0]EM[WUDWO)e#?fWa48\Be>DS]^g3ZR:d6U^VFE;gJ6c8M:c91L
K^,(R?7g-7I6G73T57Z4G,_N_:4;I_Oe)O>\^Z-A7G8Hf?3J_TV^9JPRcQ]]L\R+
U;0)O@7\6U?Wf)CTMa5;7_c.S2abDKb<\/c95Cc@E)baPRfVB&Y5+R(S.H)Vd^J^
N(U2eP7Ya@cf:V>V<M=e2AE,H=Z[6GS1HW4_+7RP+R37N2;f1B96060T19.F[(M,
U1(=3DHaD[DEeCJcZL/X16:LW>DcMMgEfS:Y^@c1ZG](40Td31Hb^PEA?M8cX3<a
W>f)a^BPNYOE3O^B^bU&^X0]85[KWQf\P21eZ)C)F[ZZ:[QEf#6)=)2^2VO<@2+5
@;6)a+N&:2]OL)&09DX4?4fgacIZg46,G-[TC76g-Kg#N=PJ]/e5d)2,Z#eH0XRR
HE(]MV^:,4CRGBI6?;2DZ9W5BE;/@.Sc>$
`endprotected

`else
    always @ (posedge clk) begin : corrupt_alert2_PROC
      if (next_alert2 == 1'b1) begin
`ifndef DW_SUPPRESS_WARN
          $display ("WARNING: %m:\n at time = %0t: Operand input change on DW_mult_seq during calculation (configured with neither input nor output register) causes output to no longer retain result of previous operation.", $time);
`endif
      end
    end
`endif

    if (rst_mode == 0) begin : GEN_AI_REG_AR
      always @ (posedge clk or negedge rst_n) begin : ar_alrt2_reg_PROC
        if (rst_n == 1'b0) alert2_issued <= 1'b0;

	  else alert2_issued <= ~start & (alert2_issued | next_alert2);
      end
    end else begin : GEN_AI_REG_SR
      always @ (posedge clk) begin : sr_alrt2_reg_PROC
        if (rst_n == 1'b0) alert2_issued <= 1'b0;

	  else alert2_issued <= ~start & (alert2_issued | next_alert2);
      end
    end

  end  // GEN_OM_EQ_0

  // GEN_IM_EQ_0
  end else begin : GEN_IM_NE_0
    assign corrupt_data = 1'b0;
  end // GEN_IM_NE_0
endgenerate

  assign product      = ((((input_mode==0)&&(output_mode==0)) || (early_start == 1)) && start == 1'b1) ?
			  {a_width+b_width{1'bX}} :
                          (corrupt_data === 1'b0)? ext_product : {a_width+b_width{1'bX}};


 
`ifndef DW_DISABLE_CLK_MONITOR
`ifndef DW_SUPPRESS_WARN
  always @ (clk) begin : P_monitor_clk 
    if ( (clk !== 1'b0) && (clk !== 1'b1) && ($time > 0) )
      $display ("WARNING: %m:\n at time = %0t: Detected unknown value, %b, on clk input.", $time, clk);
    end // P_monitor_clk 
`endif
`endif
// synopsys translate_on

endmodule




