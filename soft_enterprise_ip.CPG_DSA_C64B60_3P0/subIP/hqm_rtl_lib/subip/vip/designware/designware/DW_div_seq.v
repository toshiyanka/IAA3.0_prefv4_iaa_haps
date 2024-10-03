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
// AUTHOR:    Aamir Farooqui                February 20, 2002
//
// VERSION:   Verilog Simulation Model for DW_div_seq
//
// DesignWare_version: e28a7baf
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
//ABSTRACT:  Sequential Divider 
//  Uses modeling functions from DW_Foundation.
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
//             during the first cycle of calculation (related to STAR 9000506285)
// 1/4/12 RJK Change behavior when inputs change during calculation with
//          input_mode = 0 to corrupt output (STAR 9000506285)
// 3/19/08 KYUNG fixed the reset error of the sim model (STAR 9000233070)
// 5/02/08 KYUNG fixed the divide_by_0 error (STAR 9000241241)
// 1/08/09 KYUNG fixed the divide_by_0 error (STAR 9000286268)
// 8/01/17 AFT fixes to sequential behavior to make the simulation model
//             match the synthesis model. 
// 01/17/18 AFT Star 9001296230 
//              Fixed error in NLP VCS, related to upadtes to next_complete
//              inside always blocks that define registers. NLP forces the
//              code to be synthesizable, forcing the code of this simulation
//              model to be changed.
//------------------------------------------------------------------------------

module DW_div_seq ( clk, rst_n, hold, start, a,  b, complete, divide_by_0, quotient, remainder);


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
  output [a_width-1 : 0] quotient;
  output [b_width-1 : 0] remainder;
  output divide_by_0;

//-----------------------------------------------------------------------------
// synopsys translate_off

localparam signed [31:0] CYC_CONT = (input_mode==1 & output_mode==1 & early_start==0)? 3 :
                                    (input_mode==early_start & output_mode==0)? 1 : 2;

//------------------------------------------------------------------------------
  // include modeling functions
`include "DW_div_function.inc"
 

//-------------------Integers-----------------------
  integer count;
  integer next_count;
 

//-----------------------------------------------------------------------------
// wire and registers 

  wire [a_width-1:0] a;
  wire [b_width-1:0] b;
  wire [b_width-1:0] in2_c;
  wire [a_width-1:0] quotient;
  wire [a_width-1:0] temp_quotient;
  wire [b_width-1:0] remainder;
  wire [b_width-1:0] temp_remainder;
  wire clk, rst_n;
  wire hold, start;
  wire divide_by_0;
  wire complete;
  wire temp_div_0;
  wire start_n;
  wire start_rst;
  wire int_complete;
  wire hold_n;

  reg [a_width-1:0] next_in1;
  reg [b_width-1:0] next_in2;
  reg [a_width-1:0] in1;
  reg [b_width-1:0] in2;
  reg [b_width-1:0] ext_remainder;
  reg [b_width-1:0] next_remainder;
  reg [a_width-1:0] ext_quotient;
  reg [a_width-1:0] next_quotient;
  reg run_set;
  reg ext_div_0;
  reg next_div_0;
  reg start_r;
  reg ext_complete;
  reg next_complete;
  reg temp_div_0_ff;

  wire [b_width-1:0] b_mux;
  reg [b_width-1:0] b_reg;
  reg pr_state;
  reg rst_n_clk;
  reg nxt_complete;
  wire reset_st;
  wire nx_state;

//-----------------------------------------------------------------------------
  
  
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
    
    if (a_width < 3) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter a_width (lower bound: 3)",
	a_width );
    end
    
    if ( (b_width < 3) || (b_width > a_width) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter b_width (legal range: 3 to a_width)",
	b_width );
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
  assign complete     = ext_complete & (~start_r);
  assign in2_c        =  input_mode == 0 ? in2 : ( int_complete == 1 ? in2 : {b_width{1'b1}});
  assign temp_quotient  = (tc_mode)? DWF_div_tc(in1, in2_c) : DWF_div_uns(in1, in2_c);
  assign temp_remainder = (tc_mode)? DWF_rem_tc(in1, in2_c) : DWF_rem_uns(in1, in2_c);
  assign int_complete = (! start && run_set) || start_rst;
  assign start_rst    = ! start && start_r;
  assign reset_st = nx_state;

  assign temp_div_0 = (b_mux == 0) ? 1'b1 : 1'b0;

  assign b_mux = ((input_mode == 1) && (start == 1'b0)) ? b_reg : b;

  always @(posedge clk) begin : a1000_PROC
    if (start == 1) begin
      b_reg <= b;
    end 
  end

// Begin combinational next state assignments
  always @ (start or hold or count or a or b or in1 or in2 or
            temp_div_0 or temp_quotient or temp_remainder or
            ext_div_0 or ext_quotient or ext_remainder or ext_complete) begin
    if (start === 1'b1) begin                       // Start operation
      next_in1       = a;
      next_in2       = b;
      next_count     = 0;
      nxt_complete   = 1'b0;
      next_div_0     = temp_div_0;
      next_quotient  = {a_width{1'bX}};
      next_remainder = {b_width{1'bX}};
    end else if (start === 1'b0) begin              // Normal operation
      if (hold === 1'b0) begin
        if (count >= (num_cyc+CYC_CONT-4)) begin
          next_in1       = in1;
          next_in2       = in2;
          next_count     = count; 
          nxt_complete   = 1'b1;
          if (run_set == 1) begin
            next_div_0     = temp_div_0;
            next_quotient  = temp_quotient;
            next_remainder = temp_remainder;
          end else begin
            next_div_0     = 0;
            next_quotient  = 0;
            next_remainder = 0;
          end
        end else if (count === -1) begin
          next_in1       = {a_width{1'bX}};
          next_in2       = {b_width{1'bX}};
          next_count     = -1; 
          nxt_complete   = 1'bX;
          next_div_0     = 1'bX;
          next_quotient  = {a_width{1'bX}};
          next_remainder = {b_width{1'bX}};
        end else begin
          next_in1       = in1;
          next_in2       = in2;
          next_count     = count+1; 
          nxt_complete   = 1'b0;
          next_div_0     = temp_div_0;
          next_quotient  = {a_width{1'bX}};
          next_remainder = {b_width{1'bX}};
        end
      end else if (hold === 1'b1) begin             // Hold operation
        next_in1       = in1;
        next_in2       = in2;
        next_count     = count; 
        nxt_complete   = ext_complete;
        next_div_0     = ext_div_0;
        next_quotient  = ext_quotient;
        next_remainder = ext_remainder;
      end else begin                                // hold = X
        next_in1       = {a_width{1'bX}};
        next_in2       = {b_width{1'bX}};
        next_count     = -1;
        nxt_complete   = 1'bX;
        next_div_0     = 1'bX;
        next_quotient  = {a_width{1'bX}};
        next_remainder = {b_width{1'bX}};
      end
    end else begin                                  // start = X 
      next_in1       = {a_width{1'bX}};
      next_in2       = {b_width{1'bX}};
      next_count     = -1;
      nxt_complete   = 1'bX;
      next_div_0     = 1'bX;
      next_quotient  = {a_width{1'bX}};
      next_remainder = {b_width{1'bX}};
    end
  end
// end combinational next state assignments
  
generate
  if (rst_mode == 0) begin : GEN_RM_EQ_0

    assign nx_state = ~rst_n | (~start_r & pr_state);

  // Begin sequential assignments   
    always @ ( posedge clk or negedge rst_n ) begin : ar_register_PROC
      if (rst_n === 1'b0) begin
        count           <= 0;
        if(input_mode == 1) begin
          in1           <= 0;
          in2           <= 0;
        end else if (input_mode == 0) begin
          in1           <= a;
          in2           <= b;
        end 
        ext_complete    <= 0;
        ext_div_0       <= 0;
        start_r         <= 0;
        run_set         <= 0;
        pr_state        <= 1;
        ext_quotient    <= 0;
        ext_remainder   <= 0;
        temp_div_0_ff   <= 0;
        rst_n_clk       <= 1'b0;
      end else if (rst_n === 1'b1) begin
        count           <= next_count;
        in1             <= next_in1;
        in2             <= next_in2;
        ext_complete    <= nxt_complete & start_n;
        ext_div_0       <= next_div_0;
        ext_quotient    <= next_quotient;
        ext_remainder   <= next_remainder;
        start_r         <= start;
        pr_state        <= nx_state;
        run_set         <= 1;
        if (start == 1'b1)
          temp_div_0_ff   <= temp_div_0;
        rst_n_clk       <= rst_n;
      end else begin                                // If nothing is activated then put 'X'
        count           <= -1;
        in1             <= {a_width{1'bX}};
        in2             <= {b_width{1'bX}};
        ext_complete    <= 1'bX;
        ext_div_0       <= 1'bX;
        ext_quotient    <= {a_width{1'bX}};
        ext_remainder   <= {b_width{1'bX}};
        temp_div_0_ff   <= 1'bX;
        rst_n_clk       <= 1'bX;
      end 
    end                                             // ar_register_PROC

  end else begin : GEN_RM_NE_0

    assign nx_state = ~rst_n_clk | (~start_r & pr_state);

  // Begin sequential assignments   
    always @ ( posedge clk ) begin : sr_register_PROC
      if (rst_n === 1'b0) begin
        count           <= 0;
        if(input_mode == 1) begin
          in1           <= 0;
          in2           <= 0;
        end else if (input_mode == 0) begin
          in1           <= a;
          in2           <= b;
        end 
        ext_complete    <= 0;
        ext_div_0       <= 0;
        start_r         <= 0;
        run_set         <= 0;
        pr_state        <= 1;
        ext_quotient    <= 0;
        ext_remainder   <= 0;
        temp_div_0_ff   <= 0;
        rst_n_clk       <= 1'b0;
      end else if (rst_n === 1'b1) begin
        count           <= next_count;
        in1             <= next_in1;
        in2             <= next_in2;
        ext_complete    <= nxt_complete & start_n;
        ext_div_0       <= next_div_0;
        ext_quotient    <= next_quotient;
        ext_remainder   <= next_remainder;
        start_r         <= start;
        pr_state        <= nx_state;
        run_set         <= 1;
        if (start == 1'b1)
          temp_div_0_ff   <= temp_div_0;
        rst_n_clk       <= rst_n;
      end else begin                                // If nothing is activated then put 'X'
        count           <= -1;
        in1             <= {a_width{1'bX}};
        in2             <= {b_width{1'bX}};
        ext_complete    <= 1'bX;
        ext_div_0       <= 1'bX;
        ext_quotient    <= {a_width{1'bX}};
        ext_remainder   <= {b_width{1'bX}};
        temp_div_0_ff   <= 1'bX;
        rst_n_clk       <= 1'bX;
      end 
   end // sr_register_PROC

  end
endgenerate

  always @ (posedge clk) begin: nxt_complete_sync_PROC
    next_complete <= nxt_complete;
  end // complete_reg_PROC

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
/Qg(^)Te2/IO2WP[dY/TJHF3Hg8I_>U3gXR#f1+b?;O](IdbLOHR6)C&eC51U/UO
g7#,-N/+6dJX4OIF3KVIJ,6;VB&B)-=SMOFSMIV&0.(71XM[-XT>=Z<34bS,f,9F
P-0D3MCgT+db_YX1/KF1L#_9&Fd^[<U1^@E=Jfe]e;@,[caF2?G/Y_ES&HZLa=I[
F<PMD)+B_=)(4K-Q&=6/\Oc0KR7;Z.,<+;F5[]3UWF#LW7eQHANS)8G:#bd[TH->
XE73@]C<DI(cf;Xc1b6ZSY5G#F(3Z;_[7eYb,KgZ@f-2#c^#=X[=IWU0AY/\/+3@
^#&;J?VKe=cf7-^ZI6N3)VWOb-(9^KZ[5V96A7=>3/=FS:CR\JG>S?>660?:D;+(
dWaSgfY3ZB+T7/OdHId@VgI#H@[a>P7#e#.<3)P91QZPM4EcGKK>IeC2F#Z^SYKK
G?QS=._4_J?((R,Z@7.QSI)_(#gC?g5ZS9NNY4A:Ld_Bge)C<\(/O:DM9XHH8;FR
N5K&>0)TMIS)Tg2<F3GXL>@K1E:1CJ716ORBP).TF/IC;0\C#W05@GSdIUN>a5SU
gL__,@ZdYaVW42Q,R[?B.2<B4\c_45QSEN<_+c/KQ\&d,?C/4:B]_e^VX?M/OMUD
PbMc0AJOJ63M9eLG@SJ?PM8(K/,?][6(.2]13>&/,#\9GCP>W4[ALD77Q1TP2[Ce
E?ZJCVgef^)d44/Q94IO#.R/C>(:4d8^4493>M+29B]DWCA3]&HKO;C<5&00JgUR
+d.H1[=+;;R(Ac2<8G(LQ34c-?7:,3CLM8<O@_:cBVcVCQ(SG5FaEdcHaZW3K/K.
fb@c66PDNDJ9?DK;Tc5(N1^bOR/Y(6)Y>Tg#S](F_[\:e#,M+H0(JB?d08L==1_O
M)0GHgQa[7;[6K+T]_F&04=0NSS[X8W0g))I_e(2,;,-Pa10L.FJ4\1(d<G9=A/Z
.TBL&bTgQ.75I1;7V230(3NTEWH^TVWDEa,Gc^V)G1W:#:V;_RR;S<<]_TXaXMGD
FK2:4CS9\7HMfOTM0SSKA9:a5L9eAW/gg@B8Zg@gIdZ&49SKJ?7A9J6&ZF=8,=^L
-8eJOL^P];aM#-G(20D:3,/\fVdB+H&Yb,;/#Q(,N8FJbA/@a;V8/:]:6M0b&LPA
SL(0A:e5=Y#E1,dYN5Z7K,_D-0H^J4(6=FZNI^IFL9P@11[]_14R5T,fF.Z5[c#5
.c[>GfVMRY/Za&1,3f/CHIMY_@^a@+:=7S6-Z)>F3^SD/a^geaXDX.;OgbgE(Jgb
#BUfWb^DV,.\L-d,D2Hd.-PJ7T[Y(6DZbXCa#La?P)J_W3)2_56V+P0;Z@(@?X<=
6]4;40MA7([D&(<B\4>ZUKb[ZY/<HSF\C)cX#H4eJX@TUOZE2U#MS+IRVM3\0TA<
YP\EZ1/J2FDgQ51/@/LU6?H-R-MF0@R2J59#Ifa;bfK.7c=L)_[H\SeI@_-,e]Z>
d5HP((:(eYT\O\M@(UO1c9Wge[UOBbHSdDM8/bbMZIF[,Y-7VacAA,]>^gY\^H1_
gE78-2KcM2J:/L[M-WNJ--(XfT?3B<-]\JV2QP?+cc?\SeA1N4)HB)39JT+F6>AV
E(:_P3308(BE4XX-8a/6+:EDa[]^WA=BMD[XRO8bK^H[#LH)C+>#87+]JDd3.]#M
9gBT8PQUY2V_WXJXfY0_,-2f,Ia&7R4H;Mb/;LSF()DEFLeL7<=5=CeN&B_[Ze;_
YdILbYK[T(ZfXVJ=Q;6RU^X3CAg2#?gFPCXSJ4Pf3.??11dK,cYcUY<?5&(0<?C4
b.0.dG=:R?RLZJNFPNEDe9dVX3aTG&0WW&83W.g:=9HQ1ZXY[c:QYC3\.FL.fE5;
dN:ELG/C>7d&J&Dag1cFeSUCG01;<\O(MV(CIDdN]cNd<A@8a7NZKR6#7THX8]9I
55d5J:6/,aK>BDJ:2:?]FNN/\-;L[Z]_@SP&W5cU24d^eCGE3Zb?ZF1OUL]DJ@UE
0]>c1<?6FdXAfcdC9Z6<&JL90MXP5.3RaR-]cQJ7e&_)4[Q/)2I5_L,>0G811@dI
=ddZI7,CEbMRS&-@Ac8OAF#?@Y3LOC#+9@])12MT7ZUVLTf_5F):SPP5c4Q69UHN
V4VeM_HK,OJ?O+@N[J\ERQU#A>.?6KW-d62bUNb9R-VR+Oc^T8LJL92WNSVE[1\Q
C)2_YFe)9O;7U08T>8W#/REU9VEIf)L:C(,5gFZ<_)g+dS:]2F46)3:[EM<RKKLe
aScPLF4_6d4U:#1J/9>NYC@Ub0d>-;(,L>L6e0U@/TJJR98?FUXCIbaC+c76b#FK
:6)6#J5-WL8eC&;_4S]I1ga4A>=JD;2Ee;2GMU,(d3dUKg.d/BZ]D>WPgd[]#AK-
bN8IP)ODIgfI#>M8==:H]MCd@3T:4I]Y35KQdN:XR<JXO;<8EgRfN-7A5/HGCP9?
7?d<(Z>JBL<^3/=FI@6R9>=X_BI@e,W#RHgU<E:Z+R4J98]d[9f+:F<N&;QF3ZZL
#<FKI3c\c^>K8F06d1Z)\c=:Z#YP:LMW_4gY.Z79f#CdPaGW+7=OG1e2TPNMTgLf
:c#.ERKG;I6L92(I;\GPd+#D^[gFKD2TO80F8,e1A2SCc2GcJT,7(eK[_BF@##XD
HPH0:1B(+:7L.$
`endprotected

`else
    always @ (posedge clk) begin : corrupt_alert_PROC
      integer updated_count;

      updated_count = change_count;

      if (next_alert1 == 1'b1) begin
`ifndef DW_SUPPRESS_WARN
          $display ("WARNING: %m:\n at time = %0t: Operand input change on DW_div_seq during calculation (configured without an input register) will cause corrupted results if operation is allowed to complete.", $time);
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
	$display("##    This instance of DW_div_seq has encountered %0d change(s)", updated_count);
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
9@#^#HQ++?d5X^c9PX6bYK#5cVaaE0I=82dJ4:+8X#g0_@UVQI@#7)#QKUQ^ZN4V
6-5L_A/D-DRFcUK;bA65bK6bJ(W&YS6_)cfG_R<cGW9:^GFN&\;,L,EL8#V#]OL]
+)J?:UKYM5?VH?TAO--#0\@JEeNI(#BfOfDBTO,?Y<56)I)dWYN7,ZU6CX3?WTb[
N@6cY?,)4?1++UH6\1I24-16TBZ^Wf57J<ZaO.2.Q^G:8R(18:FN&fdNB+(N^=1\
a__5[IY;VV#Zf-])=0M:UV:)E@);gXd<[L9WX\()9WgdB)PF[AMG6ZN#G)5W]c+c
>6c,#cDH2\_&NUV\:eO,GG>\QML/CPd)9X1[W95W91Q?;9=b\R]/1E3R(6_A6HMa
>adbMdYL(F2,\ZB)(c@L=<N3.FeXTfV)V728aYdIEZBGWP-M@XagWEAVO8/-26dL
V&W&6d6T;3a-;a7=\?,TMF\5\KgCb6Tf.QD#JD?/8&5bL>\.UIJY#AYU^9Y=+=Ye
.TWFP(I9V+/^W<]f,IeeR>dfL@LFN6BV[dW:e&P+/<,E4O@L38?#G^C4b71VG6_;
CbW^9+ab_JK<ge.KW6cI:c#MD2+3L/#JNZ.gQOG2=Xb\^fE67H.a8K/UY]P#3#Hd
g5?6_#O6&:I[?6_WSTCRcDd/7,&]]4Vf=$
`endprotected

`else
    always @ (posedge clk) begin : corrupt_alert2_PROC
      if (next_alert2 == 1'b1) begin
`ifndef DW_SUPPRESS_WARN
          $display ("WARNING: %m:\n at time = %0t: Operand input change on DW_div_seq during calculation (configured with neither input nor output register) causes output to no longer retain result of previous operation.", $time);
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
    

  assign quotient     = (reset_st == 1) ? {a_width{1'b0}} :
                        ((((input_mode==0)&&(output_mode==0))||(early_start==1)) & start == 1'b1) ? {a_width{1'bX}} :
                        (corrupt_data !== 1'b0)? {a_width{1'bX}} : ext_quotient;
  assign remainder    = (reset_st == 1) ? {b_width{1'b0}} :
                        ((((input_mode==0)&&(output_mode==0))||(early_start==1)) & start == 1'b1) ? {b_width{1'bX}} :
                        (corrupt_data !== 1'b0)? {b_width{1'bX}} : ext_remainder;
  assign divide_by_0  = (reset_st == 1) ? 1'b0 :
                        (input_mode == 1 && output_mode == 0 && early_start == 0) ? ext_div_0 :
                        (output_mode == 1 && early_start == 0) ? temp_div_0_ff :
                        temp_div_0_ff;

 
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
