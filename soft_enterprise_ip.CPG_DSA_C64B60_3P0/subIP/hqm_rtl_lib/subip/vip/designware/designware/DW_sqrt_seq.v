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
// VERSION:   Verilog Simulation Model for DW_sqrt_seq
//
// DesignWare_version: 1f72b2a5
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
//
//ABSTRACT:  Sequential Square Root 
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
//             during the first cycle of calculation (related to STAR 9000506330)
// 1/5/12 RJK Change behavior when input changes during calculation with
//          input_mode = 0 to corrupt output (STAR 9000506330)
//
//------------------------------------------------------------------------------

module DW_sqrt_seq ( clk, rst_n, hold, start, a, complete, root);


// parameters 

  parameter  integer width       = 6; 
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
  input [width-1:0] a;

  output complete;
  output [(width+1)/2-1:0] root;

//-----------------------------------------------------------------------------
// synopsys translate_off

//------------------------------------------------------------------------------
localparam signed [31:0] CYC_CONT = (input_mode==1 & output_mode==1 & early_start==0)? 3 :
                                    (input_mode==early_start & output_mode==0)? 1 : 2;

//------------------------------------------------------------------------------
  // include modeling functions
`include "DW_sqrt_function.inc"
 
//-------------------Integers-----------------------
  integer count;
  integer next_count;
 

//-----------------------------------------------------------------------------
// wire and registers 

  wire clk, rst_n;
  wire hold, start;
  wire [width-1:0] a;
  wire complete;
  wire [(width+1)/2-1:0] root;

  wire [(width+1)/2-1:0] temp_root;
  reg [(width+1)/2-1:0] ext_root;
  reg [(width+1)/2-1:0] next_root;
 
  reg [width-1:0]   in1;
  reg [width-1:0]   next_in1;

  wire start_n;
  wire hold_n;
  reg ext_complete;
  reg next_complete;
 


//-----------------------------------------------------------------------------
  
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
    
    if (width < 6) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter width (lower bound: 6)",
	width );
    end
    
    if ( (num_cyc < 3) || (num_cyc > (width+1)/2) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter num_cyc (legal range: 3 to (width+1)/2)",
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
  assign temp_root    = (tc_mode)? DWF_sqrt_tc (in1): DWF_sqrt_uns (in1); 

// Begin combinational next state assignments
  always @ (start or hold or a or count or in1 or temp_root or ext_root or ext_complete) begin : a1000_PROC
    if (start === 1'b1) begin                   // Start operation
      next_in1      = a;
      next_count    = 0;
      next_complete = 1'b0;
      next_root     = {(width+1)/2{1'bX}};
    end else if (start === 1'b0) begin          // Normal operation
      if (hold===1'b0) begin
        if (count >= (num_cyc+CYC_CONT-4)) begin
          next_in1      = in1;
          next_count    = count; 
          next_complete = 1'b1;
          next_root     = temp_root;
        end else if (count === -1) begin
          next_in1      = {width{1'bX}};
          next_count    = -1; 
          next_complete = 1'bX;
          next_root     = {(width+1)/2{1'bX}};
        end else begin
          next_in1      = in1;
          next_count    = count+1; 
          next_complete = 1'b0;
          next_root     = {(width+1)/2{1'bX}} ;
        end
      end else if (hold === 1'b1) begin         // Hold operation
        next_in1      = in1;
        next_count    = count; 
        next_complete = ext_complete;
        next_root     = ext_root;
      end else begin                            // hold == X
        next_in1      = {width{1'bX}};
        next_count    = -1;
        next_complete = 1'bX;
        next_root     = {(width+1)/2{1'bX}};
      end
    end else begin                              // start == X
      next_in1      = {width{1'bX}};
      next_count    = -1;
      next_complete = 1'bX;
      next_root     = {(width+1)/2{1'bX}};
    end
  end
// end combinational next state assignments

generate
  if (rst_mode == 0) begin : GEN_RM_EQ_0

  // Begin sequential assignments   
    always @ ( posedge clk or negedge rst_n ) begin: ar_register_PROC
      if (rst_n === 1'b0) begin                 // initialize everything asyn reset
        count        <= 0;
        in1          <= 0;
        ext_root     <= 0;
        ext_complete <= 0;
      end else if (rst_n === 1'b1) begin        // rst_n == 1
        count        <= next_count;
        in1          <= next_in1;
        ext_root     <= next_root;
        ext_complete <= next_complete & start_n;
      end else begin                            // rst_n == X
        count        <= -1;
        in1          <= {width{1'bX}};
        ext_root     <= {(width+1)/2{1'bX}};
        ext_complete <= 1'bX;
      end 
   end // ar_register_PROC

  end else begin : GEN_RM_NE_0

  // Begin sequential assignments   
    always @ ( posedge clk ) begin: sr_register_PROC 
      if (rst_n === 1'b0) begin                 // initialize everything syn reset
        count        <= 0;
        in1          <= 0;
        ext_root     <= 0;
        ext_complete <= 0;
      end else if (rst_n === 1'b1) begin        // rst_n == 1
        count        <= next_count;
        in1          <= next_in1;
        ext_root     <= next_root;
        ext_complete <= next_complete & start_n;
      end else begin                            // rst_n == X
        count        <= -1;
        in1          <= {width{1'bX}};
        ext_root     <= {(width+1)/2{1'bX}};
        ext_complete <= 1'bX;
      end 
    end // sr_register_PROC

  end
endgenerate

  wire corrupt_data;

generate
  if (input_mode == 0) begin : GEN_IM_EQ_0

    localparam [0:0] NO_OUT_REG = (output_mode == 0)? 1'b1 : 1'b0;
    reg [width-1:0] ina_hist;
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
	    change_count    <= 0;

	  init_complete   <= 1'b0;
	  corrupt_data_int <= 1'b0;
	end else begin
	  if ( rst_n === 1'b1) begin
	    if ((hold != 1'b1) || (start == 1'b1)) begin
	      ina_hist        <= a;
	      change_count    <= (start == 1'b1)? 0 :
	                         (next_alert1 == 1'b1)? change_count + 1 : change_count;
	    end

	    init_complete   <= init_complete | start;
	    corrupt_data_int<= next_corrupt_data | (corrupt_data_int & ~start);
	  end else begin
	    ina_hist        <= {width{1'bx}};
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
	    change_count    <= 0;
	  init_complete   <= 1'b0;
	  corrupt_data_int <= 1'b0;
	end else begin
	  if ( rst_n === 1'b1) begin
	    if ((hold != 1'b1) || (start == 1'b1)) begin
	      ina_hist        <= a;
	      change_count    <= (start == 1'b1)? 0 :
	                         (next_alert1 == 1'b1)? change_count + 1 : change_count;
	    end

	    init_complete   <= init_complete | start;
	    corrupt_data_int<= next_corrupt_data | (corrupt_data_int & ~start);
	  end else begin
	    ina_hist        <= {width{1'bx}};
	    init_complete    <= 1'bx;
	    corrupt_data_int <= 1'bX;
	    change_count     <= -1;
	  end
	end
      end
    end // GEN_A_RM_NE_0

    assign data_input_activity =  ((a !== ina_hist)?1'b1:1'b0) & rst_n;

    assign next_corrupt_data = (NO_OUT_REG | ~complete) &
                              (data_input_activity & ~start &
					~hold & init_complete);

`ifdef UPF_POWER_AWARE
  `protected
BZ<@7,7AJQ?,bJ@A+T0/&/=8>c1]<b:21Z&)5FTC26O&IB=0J927().5BKX;&S_P
4R(C+/OAeAQEM6X.OHdafEbDDOD08A31&:7ZVD+]4?JJKO1T1QT<B?,9V>,4K-8H
K^YMZ8.Kc[UgEJZRK1cd0C1cb-/\FOKcW8J9.R>H9908GMKO#]9>^fB<2b3CIP&+
.:[+MH.CCQ=A_,]2@I4,CAEgFJ9QJ<>-VYS^Z];/U5DG.RUg#Tf2::0MG,Q;FW+G
K)IN1Od56MeV2S0#eQB.#+^DGa(E&;FC)GVTOD;LJCE(+Y;bDH>8gfbNc=WXY[?X
dC8=HUR\@MD>aG3LUUbI4]=811R,&-0G<CBV?2YD#,R/BCBBTW+SBdWQPU5>A>cT
]D.VcH_\0DFGcdB;W/+D=/gXHb?7:H8L/RVS33ac=9U\?HZD@S=1?N9T4b][gTM]
(;9A5?SPCC=cX)>XYC9OW&T(^Z[[>aa:Gg0^(X_Uc):.E6Y_4-baScZH/W-_c;g2
M9RaOZUbXD9S^dUDG>TJ/YS>O7Wa_Y:<R<fG^b/2.AD61,9#-VeQZMd76Q4_G:)G
VWfN.dV4)BYVSI?&Z1d0(J]8<J#:4d-RK&6M#ZE<U[WM5&aZ2g4bKdW>AQ2&g8;c
Me)KNO.TR?-B?/#)G/JQY8X7N0F\B/HK]R0f]U;^>cC@WaMR=gGU7(8fdB0;?HbX
(=6gb?GIISgPa6<S9?CdUeA9B@93O[-:E8cZXKOM<;77KC7-,\<]K7G3=7dK/c2Z
g7;D);F@-_DU?G@3b1#]7?4##d^5S?B<Y.gaRK/E=ZG06gBG6(_RZJL2HeR_4;I=
S+>44-\0(a7^LV5\<bf/=\[K_1VGgW3RH)LOK9T.<07Z5:SgMQR5a?RG7V0.7S(a
=,DU[6g.^YYU?fK8fQ=\L[8KR.APLI#a@3N)AdC\c+G<(B4P>Vd>bd_OI9L0YTL#
-/^:#cJLdG4^FXDdYeI#H#HCf-[K@-6=:CFW<9aK2e>\MB]1=]]cS9JZZJ#&LJTI
MbU4QP8_YJa>RI7P4(_(1,TYW0-&\bcL+9U4JOWdPEGN<PD<DG)&_CH@>R;b7)0d
f?:f;_4BP.,_ZaPbU]g<9:[MJ[fJf,b=)gcD\AND?@X<AG]\O06PVGAB.^JX^TMB
G#EF9,[:0#1CT[3X/aE)BSR--,B6E60\__7e]U0GKG/<73\Z)3A5@CL/aF_82gRL
<H;g=-XT9f5DOFb-8CQE^AJA=Cc/fg^<QKaW1;XB6+J=#<@&1Ee4W[;2=@TQ2J4,
I68?;:fVZ;)X8X<0ZN=LTQ=Oc0aW?9Q6&GP7T7eA&VEg2.YNQM4XG0g@3\BKPV4_
44H1LcO)J,;XS@OL&9a9K5GFOWOLJ0EGG(#aCUHC+g94,9]E65@,DG98HWgP1gc^
e/(C1O=eJM]X;]gUDC\9V<<NH\EScJYb?XB>I&/d;f+3WFc<=UEDGQ&Q1=I^#D:7
&(5R;S&9OFFaWLDC_CYYf4</D+fX&Q[MNVCKbNg&g2+C-;RF86QD>F8GS(]Y./R=
@:N3_?\#IVN(7P+K;P=3]PVD)A6MgMfc=_8B9]M^g>eAH<:f8PB6fUg==A]Ga+gK
HG1d2Q3RdL0)^HaV@K<I0OPKUdd+^I(2Ue2>KV;WCfI,)45EeNP1+J>C.aOB-W^W
e[Q1ZeDS46AO0541,47P5L0dfVWN_CDg#0]CQSS1SfL_1AEYd;[fW9CgKL+2c&/4
YHPTA54P@DIQJ179<]1,?M_^,0YEb4,TRW6O1^A4#bF=/I>]Z=(C)(>[Q_4OdI0+
72[E#V1[YIDa<)C46(:8U/7Z;]PB0VC#NS0+MHHEXF.KJ>U<#5[g(RYYAe,F)_?7
&Z)_E(Z9H7T/=:8OJ2@)/JZ8X><P9R2.-]Bd55,91TVT,?T-_N[99>,)X#MTI#D+
J#GHJ2IQ4N@+MU<CYW^Y]4F+@CI2R/\&F16+.)P3Hb/WdW(-/X^3_(&M#Q<1W2>;
3NA6G]:U<gEQUBQ2T;W[1g9T\fPNKbD>8#8+1?eM0^PNW7X;L>C0e)>,b)FC-BGA
6gdY77bS///;U^A/4F1MVHP.5gIA49c==_?c(]9T\G?ISE)MB\HSa:453f>?HBPg
Y/V6.Y+GOP(KbV5J5be]=ZNeSS10(S67)N#S;Y448D2C,BLV=MdFW-3\QB;JQA1G
F=-XN;=AQ2T)TQ2)Z8Z(P-_778e:PSX/g,A[QG+UMY:^HWKNHVf+,1X.WL<KT6QX
CV?&7SRbWcE[,&ZWEX,f-PWPL^(4LZg<gH?A;<8E#3Y=GcR-d8=.\\5^^UbD.8aE
22XV,57g5>(DP4M4W^>0OI]Y0])96CYP2+)S;>;b=J4U.1]TZ57HOgece,AHaWLM
2WXVBc.JDUM64/3ARg.Uf_/&I#ICRQ)+:=OZZFK1F_9acW-R&<RbXbeGASQM-MD5
?>@F<,2dgB#ZRO81IJXZ,LIACQ\Y+O[@>G=I89A]+)EbBYJDb7)gSK?/RPX8=P+W
]FQcN23-6XJ21AWOg6.&&L0(L[Z9f18[,C4@RM/>JK_8aVHWZaB5\.SB0W..TgK0
dWYW5Hd<(QeZOPef,CCN[/4d@_e?L@R6e7f9BR1=I.bUE2K9HY.fWa2/bXQ=eRfX
/=PH2K7c(IEZ0$
`endprotected

`else
    always @ (posedge clk) begin : corrupt_alert_PROC
      integer updated_count;

      updated_count = change_count;

      if (next_alert1 == 1'b1) begin
`ifndef DW_SUPPRESS_WARN
          $display ("WARNING: %m:\n at time = %0t: Operand input change on DW_sqrt_seq during calculation (configured without an input register) will cause corrupted results if operation is allowed to complete.", $time);
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
	$display("##    This instance of DW_sqrt_seq has encountered %0d change(s)", updated_count);
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
.=#Vg#__]>2,.acW+;1?FI=NYfB0G[K5U(-e4<W\)c7X0/f]LR/#7)/PEFBX)^c-
C7\J3;4]PU7)]C_1Q8=?4J;AL^[LB(LGe(8dfVLE:&HG4&BDF,7b:;[B[MQcM[=F
/NX-c,c7P?23<<R)Ee,d[a0SUeI4&G3^T8#Ka:TVbP-E)0)Dfg_+b<1B\1S7N6a-
HM>WN#40)N)((C+5=C:D&UVJgB5P1b8cCIMA[LA+d_81TA3_,D]I\Z3HQO6VG&U\
KFRG)BN,R16;R\W+@IY?a.D3?VLdS:3EJ[]MfK^bKSWc<V6SB.5YB&-:JI1ZdSYU
)&:0BK?^EY?d-+:IHM3\WF9(+KF=N0:K:[6;=c]&Y.XL]N4c#L/=U/-_ZKI4R3)O
OeDgP:NU925O^V@fZg-BY^TYTJH=1a#>d#2&AD)_Z&(>,IS^D.^<;MPf@9=&,<g0
(=d=/R])UXJ9+)C)U73C\U-4d2P9J1bZVOGaB1<?G,dH(D,BeXNJB:F[)77)PH8;
URGJQE(6=Jc+^;9N.1466-86PP2RY:L:^A>BZ^2g/R0e+fZg]<dA=g1^_QHD5+^/
E_AJeN[XC.;=EGTd\O;G\[g)YS.^+(Ld@9G75/#-0cbYL3QKFT(?D<-HZM7caQG:
JU2\f4D=_/TK81&QXc?Rb7SUBA]U&e3<>$
`endprotected

`else
    always @ (posedge clk) begin : corrupt_alert2_PROC
      if (next_alert2 == 1'b1) begin
`ifndef DW_SUPPRESS_WARN
          $display ("WARNING: %m:\n at time = %0t: Operand input change on DW_sqrt_seq during calculation (configured with neither input nor output register) causes output to no longer retain result of previous operation.", $time);
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

  assign root         = ((((input_mode==0)&&(output_mode==0))||(early_start==1)) & start == 1'b1) ?
			     {(width+1)/2{1'bX}} :
                             (corrupt_data === 1'b0)? ext_root : {(width+1)/2{1'bX}} ;

 
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




