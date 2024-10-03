////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2008 - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Alexandre Tenca, June 2008
//
// VERSION:   Verilog Simulation Model for FP Natural Logarithm
//
// DesignWare_version: 8936f84b
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------------
//
// ABSTRACT: Floating-point Natural Logarithm
//           Computes the natural logarithm of a FP number
//
//              parameters      valid values (defined in the DW manual)
//              ==========      ============
//              sig_width       significand size,  2 to 59 bits
//              exp_width       I100llOO size,     3 to 31 bits
//              ieee_compliance 0 or 1
//              extra_prec      0 to 59-sig_width bits
//              arch            implementation select
//                              0 - area optimized
//                              1 - speed optimized
//
//              Input ports     Size & Description
//              ===========     ==================
//              a               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Input
//
//              Output ports    Size & Description
//              ===========     ==================
//              z               (sig_width + exp_width + 1) bits
//                              Floating-point Number that represents ln(a)
//              status          byte
//                              Status information about FP operation
//
// MODIFIED:
// 07/2020 TAWALBEH - STAR 9001576363
//                    1) Tiny bit is not set: for ieee_compliance=0, if the output falls 
//                       between Minorm and Zero, either output is correct (No rounding).
//                       If MinNorm is selected: only the Inexact bit is set and no Tiny bit. 
//                       If Zero is selected: Inexact, Tiny and Zero status bits are set (0x29).	
//                       For ieee_compliance=1: if the output is between MiNorm and MaxDenorm,
//                       either output is correct (No rounding).
//                       If MinNorm is selected: only the Inexact bit is set and no Tiny bit.
//                       If MaxDenorm is selected: Bothe Tiny and Inexact are set. 	
//                    2) Fixed: Inexact bit must be set to 1 when both INF and Huge status
//                       bits are set to 1. 
//                    3) Fixed the mismatch with the SYN model for this case by updating the 
//                       condition for the overflow test. 
//
// 11/2016   KYUNG  - STAR 9001116007
//                    Fixed the status[7] flag for ln(+0) and ln(-0)
//                    Merged into M-SP3 on March 2017. 
// 11/2015   AFT    - STAR 9000854445
//                    The ln(-0) should be the same as ln(+0)=-inf   
// 
// 07/2015   AFT    - STAR 9000927308
//                    The fix of this STAR implied the following actions:
//            	      1) the fixed-point DW_log2 is called with one more bit
//            	         than the sig_width of DW_fp_ln. As a consequence, when 
//                       sig_width=60, DW_log2 input width gets out of range (61).
//                       Had to modify the upper bound of sig_width to 59 and adjust 
//                       the limits for extra_prec. 
//                    2) for extreme cases, e.g. parameter set (59,3,1,0,x), the 
//                       calculation of exponents overflows, caused by small vectors. 
//                       Had to increase the precision of some variable to guarantee
//                       correct computation.
//           
//-------------------------------------------------------------------------------

module DW_fp_ln (a, z, status);
parameter integer sig_width=10;
parameter integer exp_width=5; 
parameter integer ieee_compliance=0;
parameter integer extra_prec=0;
parameter integer arch=0;

// declaration of inputs and outputs
input  [sig_width + exp_width:0] a;
output [sig_width + exp_width:0] z;
output [7:0] status;

// synopsys translate_off
  //-------------------------------------------------------------------------
  // Parameter legality check
  //-------------------------------------------------------------------------
  
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
  
    if ( (sig_width < 2) || (sig_width > 59) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter sig_width (legal range: 2 to 59)",
	sig_width );
    end
  
    if ( (exp_width < 3) || (exp_width > 31) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter exp_width (legal range: 3 to 31)",
	exp_width );
    end
  
    if ( (ieee_compliance < 0) || (ieee_compliance > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter ieee_compliance (legal range: 0 to 1)",
	ieee_compliance );
    end
  
    if ( (extra_prec < 0) || (extra_prec > 59-sig_width) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter extra_prec (legal range: 0 to 59-sig_width)",
	extra_prec );
    end
  
    if ( (arch < 0) || (arch > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter arch (legal range: 0 to 1)",
	arch );
    end
  
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 



 
// signals
  reg  [(exp_width + sig_width + 1)-1:0] O101l000, lIO1IOO1;
  reg  [8    -1:0] lO0lI00I, O010OO00;
  `define DW_l01O1OIO (sig_width+extra_prec+1)
  `define DW_lOO10O10 (`DW_l01O1OIO+exp_width+5)
  `define DW_OOO10100 8
  reg  [`DW_l01O1OIO-1:0] IO10000O;
  wire [`DW_l01O1OIO-1:0] lOO0O0l0;
  reg signed [`DW_lOO10O10-1:0] OOO11lOO;
  reg l1111OlI;
  reg [`DW_lOO10O10-1:0] O1I0O100;
  reg [sig_width:0] O0OO0OO1;
  reg [sig_width-1:0] O1IOl1I1;
  reg [sig_width-1:0] OI0O0lO0;
  reg [(exp_width + sig_width + 1)-1:0] O0O01lI1;
  reg [8    -1:0] lOI10I11;
  reg OIO0I1Ol, OO10lI1l, l1I111Il, OIlOllO0;
  reg [(exp_width + sig_width + 1)-1:0] lI00O010;
  reg [(exp_width + sig_width + 1)-1:0] OOOO1I0I;
  reg [(exp_width + sig_width + 1)-1:0] II1l110I;
  reg [sig_width:0] lOO00I0l;
  reg signed [exp_width+5:0] I100llOO;
  reg signed [`DW_lOO10O10-1:0] I010Il1O, O1001111;
  reg signed [`DW_lOO10O10-1:0] OI11lI10;
  reg [`DW_lOO10O10-1:0] l100101I;
  reg [`DW_lOO10O10-1:0] O101OI0O;
  reg [`DW_l01O1OIO:0] O1OO1OO1;
  reg [sig_width+1:0] lI01I1ll;
  reg [`DW_lOO10O10-1:0] OOI111O0;
  reg signed [`DW_lOO10O10:0] Ol0Il1O0;
  reg signed [`DW_lOO10O10:0] OOIOOlO1;
  reg signed [`DW_lOO10O10-1:0] O101OI0I;
  reg [8    -1:0] Il1O0IOO;
  reg O10IO0I0;
  wire l010Ol0I;
  `define DW_lOO1l101 93
  wire [(`DW_lOO1l101 - 1):0] I10IO001;
  assign I10IO001 = `DW_lOO1l101'b010110001011100100001011111110111110100011100111101111001101010111100100111100011101100111001;
  wire [`DW_l01O1OIO-1:0] OI1l00OO;
  assign OI1l00OO = I10IO001[(`DW_lOO1l101 - 1)-1:(`DW_lOO1l101 - 1)-`DW_l01O1OIO]+I10IO001[(`DW_lOO1l101 - 1)-`DW_l01O1OIO-1];

  always @ (a)
    begin                             
    OI0O0lO0 = 0;
    O1I0O100 = {1'b0,a[((exp_width + sig_width) - 1):sig_width]};
    O1IOl1I1 = a[(sig_width - 1):0];
    OIO0I1Ol = 0;
    lI00O010 = {1'b0, {exp_width{1'b1}}, OI0O0lO0};
    lI00O010[0] = (ieee_compliance == 1)?1:0;

    OOOO1I0I = {1'b1, {exp_width{1'b1}},OI0O0lO0};
    II1l110I = {1'b0, {exp_width{1'b1}},OI0O0lO0};
    
    if (ieee_compliance == 1 && O1I0O100 == 0)
      begin
        if (O1IOl1I1 == OI0O0lO0)
          begin
            OIO0I1Ol = 1;
            OO10lI1l = 0;
          end
        else
          begin
            OIO0I1Ol = 0;
            OO10lI1l = 1;
            O1I0O100[0] = 1;
          end
        O0OO0OO1 = {1'b0, a[(sig_width - 1):0]};
      end
    else if (ieee_compliance == 0 && O1I0O100 == 0)
      begin
        O0OO0OO1 = {1'b0,OI0O0lO0};
        OIO0I1Ol = 1;
        OO10lI1l = 0;
      end
    else
      begin
        O0OO0OO1 = {1'b1, a[(sig_width - 1):0]};
        OIO0I1Ol = 0;
        OO10lI1l = 0;
      end
    
    if ((O1I0O100[exp_width-1:0] == ((((1 << (exp_width-1)) - 1) * 2) + 1)) && 
        ((ieee_compliance == 0) || (O1IOl1I1 == 0)))
      l1I111Il = 1;
    else
      l1I111Il = 0;
  
    if ((O1I0O100[exp_width-1:0] == ((((1 << (exp_width-1)) - 1) * 2) + 1)) && 
        (ieee_compliance == 1) && (O1IOl1I1 != 0))
      OIlOllO0 = 1;
    else
      OIlOllO0 = 0;
  
    l1111OlI = a[(exp_width + sig_width)];
      
    lOI10I11 = 0;
    O0O01lI1 = 0;
    lOO00I0l = -1;
  
    if ((OIlOllO0 == 1) ||	((l1111OlI == 1'b1) && (OIO0I1Ol == 1'b0)))
      begin
        O0O01lI1 = lI00O010;
        lOI10I11[2] = 1;
      end
  
    else if (l1I111Il == 1) 
      begin
        O0O01lI1 = II1l110I;
        lOI10I11[1] = 1;
      end
  
    else if (OIO0I1Ol == 1)
      begin
        O0O01lI1 = OOOO1I0I;
        lOI10I11[1] = 1;
        lOI10I11[7] = 1;
      end
  
    else if (OO10lI1l == 1)
      begin
        lOO00I0l = O0OO0OO1;
        while (lOO00I0l[sig_width] == 0)
          begin
            lOO00I0l = lOO00I0l<<1;
            O1I0O100 = O1I0O100 - 1;
          end
        O0O01lI1 = 0;
      end
    else if (O1I0O100 == ((1 << (exp_width-1)) - 1) &&  O1IOl1I1 == 0 && l1111OlI == 0)
      begin
        O0O01lI1 = 0;
        lOI10I11[0] = 1;
      end
    else
      begin
        lOO00I0l = O0OO0OO1;
        O0O01lI1 = 0;
      end
  
    O101l000 = O0O01lI1;
    lO0lI00I = lOI10I11;
    IO10000O = lOO00I0l << (`DW_l01O1OIO-(sig_width+1));
    OOO11lOO = O1I0O100 - ((1 << (exp_width-1)) - 1);
  end

  DW_ln #(`DW_l01O1OIO,arch) U1 (.a(IO10000O), .z(lOO0O0l0));

  always @ (lOO0O0l0 or OOO11lOO or OI1l00OO)
  begin
    I100llOO = ((1 << (exp_width-1)) - 1);
    Ol0Il1O0 = $signed(OOO11lOO);
    OOIOOlO1 = Ol0Il1O0 * $unsigned(OI1l00OO);
    O101OI0I = OOIOOlO1[`DW_lOO10O10-1:0];
    I010Il1O = O101OI0I;
    OOI111O0 = lOO0O0l0;
    O1001111 = OOI111O0;
    OI11lI10 = I010Il1O + O1001111;
    if (OI11lI10 < 0)
      begin
        l100101I = -OI11lI10;
        O10IO0I0 = 1;
      end
    else
      begin
        l100101I = OI11lI10;
        O10IO0I0 = 0;
      end
    O101OI0O = $unsigned(l100101I);
    while ((O101OI0O[`DW_lOO10O10-1:`DW_l01O1OIO+1] != 0) && 
           (O101OI0O != 0))
      begin
        O101OI0O = O101OI0O >> 1;
        I100llOO = I100llOO + 1; 
      end
    O1OO1OO1 = O101OI0O[`DW_l01O1OIO:0];
    while ((O1OO1OO1[`DW_l01O1OIO] == 0) && (O1OO1OO1 != 0) && (I100llOO > 1))
      begin
        O1OO1OO1 = O1OO1OO1 << 1;
        I100llOO = I100llOO - 1; 
      end
    
    lI01I1ll = {1'b0,O1OO1OO1[`DW_l01O1OIO:extra_prec+1]}+O1OO1OO1[extra_prec];
    if (lI01I1ll[sig_width+1]==1)
      begin
        lI01I1ll = lI01I1ll >> 1;
        I100llOO = I100llOO + 1;
      end
    if (lI01I1ll[sig_width] == 0) 
    begin	
      if (ieee_compliance == 1)
	begin
          lIO1IOO1 = {O10IO0I0, {exp_width{1'b0}}, lI01I1ll[sig_width-1:0]};
          Il1O0IOO[3] = 1;
        end
      else
        begin
          lIO1IOO1 = 0;
          Il1O0IOO[3] = 1;
          Il1O0IOO[0] = 1;
        end
    end
    else
     begin
        if (|I100llOO[exp_width+5:exp_width] == 1 | (&I100llOO[exp_width-1:0] == 1) )   
          begin
            Il1O0IOO[4] = 1;
            Il1O0IOO[5] = 1;
            Il1O0IOO[1] = 1;
            lIO1IOO1 = OOOO1I0I;
          end
        else
          begin
            Il1O0IOO = 0;
            lIO1IOO1 = {O10IO0I0, I100llOO[exp_width-1:0],lI01I1ll[sig_width-1:0]};  
          end
      end
     Il1O0IOO[5] = (~ Il1O0IOO[1] & ~ Il1O0IOO[2] &
                                    ~ (Il1O0IOO[0] & ~ Il1O0IOO[3]) )
                                    | (Il1O0IOO[1]  & (Il1O0IOO[4]) );

    O010OO00 = Il1O0IOO;
  end

  assign z = ((^(a ^ a) !== 1'b0)) ? {(exp_width + sig_width + 1){1'bx}} : 
             (lO0lI00I != 0) ? O101l000 : lIO1IOO1;
  assign status = ((^(a ^ a) !== 1'b0)) ? {8    {1'bx}} : 
                  (lO0lI00I != 0) ? lO0lI00I : O010OO00;

`undef DW_l01O1OIO
`undef DW_lOO10O10
`undef DW_lOO1l101

// synopsys translate_on

endmodule


