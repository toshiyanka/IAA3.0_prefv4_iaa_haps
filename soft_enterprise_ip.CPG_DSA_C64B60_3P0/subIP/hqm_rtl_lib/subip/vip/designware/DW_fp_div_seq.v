////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2006 - 2020 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Kyung-Nam Han, Sep. 25, 2006
//
// VERSION:   Verilog Simulation Model for DW_fp_div_seq
//
// DesignWare_version: d7eb8822
// DesignWare_release: R-2020.09-DWBB_202009.2
//
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
//
// ABSTRACT: Floating-Point Sequencial Divider
//
//              DW_fp_div_seq calculates the floating-point division
//              while supporting six rounding modes, including four IEEE
//              standard rounding modes.
//
//              parameters      valid values (defined in the DW manual)
//              ==========      ============
//              sig_width       significand size,  2 to 253 bits
//              exp_width       exponent size,     3 to 31 bits
//              ieee_compliance support the IEEE Compliance
//                              0 - IEEE 754 compatible without denormal support
//                                  (NaN becomes Infinity, Denormal becomes Zero)
//                              1 - IEEE 754 standard compatible
//                                  (NaN and denormal numbers are supported)
//              num_cyc         Number of cycles required for the FP sequential
//                              division operation including input and output
//                              register. Actual number of clock cycle is
//                              num_cyc - (1 - input_mode) - (1 - output_mode)
//                               - early_start + internal_reg
//              rst_mode        Synchronous / Asynchronous reset
//                              0 - Asynchronous reset
//                              1 - Synchronous reset
//              input_mode      Input register setup
//                              0 - No input register
//                              1 - Input registers are implemented
//              output_mode     Output register setup
//                              0 - No output register
//                              1 - Output registers are implemented
//              early_start     Computation start (only when input_mode = 1)
//                              0 - start computation in the 2nd cycle
//                              1 - start computation in the 1st cycle (forwarding)
//                              early_start should be 0 when input_mode = 0
//              internal_reg    Insert a register between an integer sequential divider
//                              and a normalization unit
//                              0 - No internal register
//                              1 - Internal register is implemented
//
//              Input ports     Size & Description
//              ===========     ==================
//              a               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Input
//              b               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Input
//              rnd             3 bits
//                              Rounding Mode Input
//              clk             Clock
//              rst_n           Reset. (active low)
//              start           Start operation
//                              A new operation is started by setting start=1
//                              for 1 clock cycle
//              z               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Output
//              status          8 bits
//                              Status Flags Output
//              complete        Operation completed
//
// Modified:
//   6/05/07 KYUNG (0703-SP3)
//           The legal range of num_cyc parameter widened.
//   3/25/08 KYUNG (0712-SP3)
//           Fixed the reset error (STAR 9000234177)
//   1/29/10 KYUNG (D-2010.03)
//           1. Removed synchronous DFF when rst_mode = 0 (STAR 9000367314)
//           2. Fixed complete signal error at the reset  (STAR 9000371212)
//           3. Fixed divide_by_zero flag error           (STAR 9000371212)
//   2/27/12 RJK (F-2011.09-SP4)
//           Added missing message when input changes during calculation
//           while input_mode=0 (STAR 9000523798)
//   9/22/14 KYUNG (J-2014.09-SP1)
//           Modified for the support of VCS NLP feature
//   9/22/15 RJK (K-2015.06-SP3) Further update for NLP compatibility
//   2/26/16 LMSU
//           Updated to use blocking and non-blocking assigments in
//           the correct way
//   10/2/17 AFT (M-2016.12-SP5-2)
//           Fixed the behavior of the complete output signal to match
//           the synthesis model and the VHDL simulation model. 
//           (STAR 9001121224)
//           Also fixed the issue with the impact of rnd input on the
//           components output 'z'. (STAR 9001251699)
//  07/10/18 AFT - Star 9001366623
//           Signal int_complete_advanced had its declaration changed from
//           'reg' to 'wire'.
//
//-----------------------------------------------------------------------------

module DW_fp_div_seq (a, b, rnd, clk, rst_n, start, z, status, complete);

  parameter integer sig_width = 23;      // RANGE 2 TO 253
  parameter integer exp_width = 8;       // RANGE 3 TO 31
  parameter integer ieee_compliance = 0; // RANGE 0 TO 1
  parameter integer num_cyc = 4;         // RANGE 4 TO (2 * sig_width + 3)
  parameter integer rst_mode = 0;        // RANGE 0 TO 1
  parameter integer input_mode = 1;      // RANGE 0 TO 1
  parameter integer output_mode = 1;     // RANGE 0 TO 1
  parameter integer early_start = 0;     // RANGE 0 TO 1
  parameter integer internal_reg = 1;    // RANGE 0 TO 1


  localparam TOTAL_WIDTH = (sig_width + exp_width + 1);

//-----------------------------------------------------------------------------

  input [(exp_width + sig_width):0] a;
  input [(exp_width + sig_width):0] b;
  input [2:0] rnd;
  input clk;
  input rst_n;
  input start;

  output [(exp_width + sig_width):0] z;
  output [8    -1:0] status;
  output complete;

// synopsys translate_off

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

  
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
    
    if ( (sig_width < 2) || (sig_width > 253) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter sig_width (legal range: 2 to 253)",
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
    
    if ( (num_cyc < 4) || (num_cyc > 2*sig_width+3) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter num_cyc (legal range: 4 to 2*sig_width+3)",
	num_cyc );
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
    
    if ( (internal_reg < 0) || (internal_reg > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter internal_reg (legal range: 0 to 1)",
	internal_reg );
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


//-----------------------------------------------------------------------------

  localparam CYC_CONT = num_cyc - 3;
  integer count;
  integer next_count;
  integer cnt_glitch;

  reg  [(exp_width + sig_width):0] ina;
  reg  [(exp_width + sig_width):0] inb;
  reg  [(exp_width + sig_width):0] next_ina;
  reg  [(exp_width + sig_width):0] next_inb;
  reg  [(exp_width + sig_width):0] next_int_z;
  reg  [(exp_width + sig_width):0] int_z;
  reg  [(exp_width + sig_width):0] int_z_d1;
  reg  [(exp_width + sig_width):0] int_z_d2;
  reg  [7:0] next_int_status;
  reg  [7:0] int_status;
  reg  [7:0] int_status_d1;
  reg  [7:0] int_status_d2;
  reg  [2:0] rnd_reg;
  reg  new_input_pre;
  reg  new_input_reg_d1;
  reg  new_input_reg_d2;
  reg  next_int_complete;
  reg  next_complete;
  reg  int_complete;
  wire int_complete_advanced; 

  reg  int_complete_d1;
  reg  int_complete_d2;
  reg  count_reseted;
  reg  next_count_reseted;

  wire [(exp_width + sig_width):0] ina_div;
  wire [(exp_width + sig_width):0] inb_div;
  wire [(exp_width + sig_width):0] z;
  wire [(exp_width + sig_width):0] temp_z;
  wire [7:0] status;
  wire [7:0] temp_status;
  wire [2:0] rnd_div;
  wire clk, rst_n;
  wire complete;
  wire start_in;

  reg  start_clk;
  wire rst_n_rst;
  reg  reset_st;
  wire corrupt_data;
  reg  [(exp_width + sig_width):0] a_reg;
  reg  [(exp_width + sig_width):0] b_reg;

  localparam [1:0] output_cont = output_mode + internal_reg;

  assign corrupt_data = (output_cont == 2) ? new_input_reg_d2:
                        (output_cont == 1) ? new_input_reg_d1:
                        new_input_pre;

  assign z = (reset_st) ? 0 :
             (corrupt_data !== 1'b0)? {TOTAL_WIDTH{1'bx}} :
             (output_cont == 2) ? int_z_d2 :
             (output_cont == 1) ? int_z_d1 :
             next_int_z;

  assign status = (reset_st) ? 0 :
                  (corrupt_data !== 1'b0)? {8{1'bx}} :
                  (output_cont == 2) ? int_status_d2 :
                  (output_cont == 1) ? int_status_d1 :
                  next_int_status;

  assign complete = (rst_n == 1'b0 && rst_mode == 0) ? 1'b0:
              (output_cont == 2) ? int_complete_d2:
              (output_cont == 1) ? int_complete_d1:
              int_complete_advanced;

  assign ina_div = (input_mode == 1) ? ina : a;
  assign inb_div = (input_mode == 1) ? inb : b;
  assign rnd_div = (input_mode==1) ? rnd_reg : rnd;

  DW_fp_div #(sig_width, exp_width, ieee_compliance) U1 (
                      .a(ina_div),
                      .b(inb_div),
                      .rnd(rnd_div),
                      .z(temp_z),
                      .status(temp_status)
  );

  generate
  if (rst_mode == 0) begin : GEN_RM_EQ_0_CORRUPT_DATA
  always @(posedge clk or negedge rst_n) begin : a1000_PROC
    if (rst_n == 1'b0) begin
      new_input_reg_d1 <= 1'b0;
      new_input_reg_d2 <=1'b0;
    end else begin
      new_input_reg_d1 <= new_input_pre;
      new_input_reg_d2 <= new_input_reg_d1;
    end
  end
  end else begin : GEN_RM_NEQ_0_CORRUPT_DATA
  always @(posedge clk) begin : a1001_PROC
    if (rst_n == 1'b0) begin
      new_input_reg_d1 <= 1'b0;
      new_input_reg_d2 <=1'b0;
    end else begin
      new_input_reg_d1 <= new_input_pre;
      new_input_reg_d2 <= new_input_reg_d1;
    end
  end 
  end
  endgenerate

  always @(ina_div or inb_div) begin : a1002_PROC
    new_input_pre = (start_in == 1'b0) & (input_mode == 0) & (reset_st == 1'b0);
  end

  generate 
  if (rst_mode == 0) begin : GEN_DATA_DETCT_RM0
  always @(posedge clk or negedge rst_n) begin: DATA_CHANGE_DETECTION_PROC
    if (rst_n == 1'b0) begin
      new_input_pre <= 1'b0;
    end else begin
      if (input_mode == 0 && reset_st == 1'b0 && start_in == 1'b0 && (a_reg != a || b_reg != b)) begin
        new_input_pre <= 1'b1;
      end else begin
        if (start_in == 1'b1) begin
          new_input_pre <= 1'b0;
        end 
      end
    end
  end
  end
  else begin : GEN_DATA_DETCT_RM1
  always @(posedge clk) begin: DATA_CHANGE_DETECTION_PROC
    if (rst_n == 1'b0) begin
      new_input_pre <= 1'b0;
    end else begin
      if (input_mode == 0 && reset_st == 1'b0 && start_in == 1'b0 && (a_reg != a || b_reg != b)) begin
        new_input_pre <= 1'b1;
      end else begin
        if (start_in == 1'b1) begin
          new_input_pre <= 1'b0;
        end 
      end
    end
  end
  end
  endgenerate

  assign start_in = (input_mode & ~early_start) ? start_clk : start;

  always @(start or a or b or ina or inb or count_reseted or next_count) begin : next_comb_PROC
    if (start===1'b1) begin
      next_ina           = a;
      next_inb           = b;
    end
    else if (start===1'b0) begin
      if (next_count >= CYC_CONT) begin
        next_ina           = ina;
        next_inb           = inb;
      end else if (next_count === -1) begin
        next_ina           = {TOTAL_WIDTH{1'bX}};
        next_inb           = {TOTAL_WIDTH{1'bX}};
      end else begin
        next_ina           = ina;
        next_inb           = inb;
      end 
    end
  end

  always @(rst_n or start_in or a or b or ina or inb or count_reseted or next_count or
           temp_z or temp_status or output_cont or count or reset_st) begin : next_state_comb_PROC
    if (start_in===1'b1) begin
      next_count_reseted = 1'b1;
      next_complete      = 1'b0;
      next_int_complete  = 1'b0;
      next_int_z         = {TOTAL_WIDTH{1'bx}};
      next_int_status    = {8{1'bx}};
    end
    else if (start_in===1'b0) begin
      next_count_reseted = 1'b0;
      if (count >= CYC_CONT) begin
        next_int_z         = temp_z & {((exp_width + sig_width) + 1){~(start_in | reset_st)}};
        next_int_status    = temp_status & {8{~(start_in | reset_st)}};
      end
      if (next_count >= CYC_CONT) begin
        next_int_complete  = rst_n;
        next_complete      = 1'b1;
      end else if (next_count === -1) begin
        next_int_complete  = 1'bX;
        next_int_z         = {TOTAL_WIDTH{1'bX}};
        next_int_status    = {8{1'bX}};
        next_complete      = 1'bX;
      end else begin
        next_int_complete  = 0;
        next_int_z         = {TOTAL_WIDTH{1'bX}};
        next_int_status    = {8{1'bX}};
      end 
    end

  end

  always @(start_in or count_reseted or count) begin : a1003_PROC
    if (start_in===1'b1)
      next_count = 0;
    else if(start_in===1'b0) begin
      if (count >= CYC_CONT)
        next_count = count;
      else if (count === -1)
        next_count = -1;
      else
        next_count = count + 1;
    end
  end
 
  assign int_complete_advanced = (internal_reg == 1 || input_mode == 1 || output_mode == 1)?int_complete & (~start_in):int_complete;

  generate
  if (rst_mode == 0) begin : GEN_RM_EQ_0_D
    always @ (posedge clk or negedge rst_n) begin: register_PROC
      if (rst_n === 1'b0) begin
        int_z           <= 0;
        int_status      <= 0;
        int_complete    <= 0;
        count_reseted   <= 0;
        count           <= 0;
        ina             <= 0;
        inb             <= 0;
        int_z_d1        <= 0;
        int_z_d2        <= 0;
        int_status_d1   <= 0;
        int_status_d2   <= 0;
        int_complete_d1 <= 0;
        int_complete_d2 <= 0;
        start_clk       <= 0;
        a_reg           <= 0;
        b_reg           <= 0;
        rnd_reg         <= 3'b000;
      end else if (rst_n === 1'b1) begin
        int_z           <= next_int_z;
        int_status      <= next_int_status;
        int_complete    <= next_int_complete;
        count_reseted   <= next_count_reseted;
        count           <= next_count;
        ina             <= next_ina;
        inb             <= next_inb;
        int_z_d1        <= next_int_z;
        int_z_d2        <= int_z_d1;
        int_status_d1   <= next_int_status;
        int_status_d2   <= int_status_d1;
        int_complete_d1 <= int_complete_advanced;
        int_complete_d2 <= int_complete_d1;
        start_clk       <= start;
        a_reg           <= a;
        b_reg           <= b;
        rnd_reg         <= (start == 1'b1)?rnd:rnd_reg;
      end else begin
        int_z           <= {(exp_width + sig_width){1'bx}};
        int_status      <= {7{1'bx}};
        int_complete    <= 1'bx;
        count_reseted   <= 1'bx;
        count           <= -1;
        ina             <= {TOTAL_WIDTH{1'bx}};
        inb             <= {TOTAL_WIDTH{1'bx}};
        int_z_d1        <= {(exp_width + sig_width){1'bx}};
        int_z_d2        <= {(exp_width + sig_width){1'bx}};
        int_status_d1   <= {8{1'bx}};
        int_status_d2   <= {8{1'bx}};
        int_complete_d1 <= 1'bx;
        int_complete_d2 <= 1'bx;
        start_clk       <= 1'bx;
        a_reg           <= {TOTAL_WIDTH{1'bx}};
        b_reg           <= {TOTAL_WIDTH{1'bx}};
        rnd_reg         <= 3'bxxx;
      end
    end
    always @(posedge clk or negedge rst_n) begin: RST_FSM_PROC
      if (rst_n == 1'b0) begin
        reset_st <= 1'b1;
      end else begin
        if (start == 1'b1) reset_st <= 1'b0;
      end 
    end
  end
  else begin : GEN_RM_NE_0_D
    always @ ( posedge clk) begin: register_PROC
      if (rst_n === 1'b0) begin
        int_z           <= 0;
        int_status      <= 0;
        int_complete    <= 0;
        count_reseted   <= 0;
        count           <= 0;
        ina             <= 0;
        inb             <= 0;
        int_z_d1        <= 0;
        int_z_d2        <= 0;
        int_status_d1   <= 0;
        int_status_d2   <= 0;
        int_complete_d1 <= 0;
        int_complete_d2 <= 0;
        start_clk       <= 0;
        a_reg           <= 0;
        b_reg           <= 0;
        rnd_reg         <= 3'b000;
      end else if (rst_n === 1'b1) begin
        int_z           <= next_int_z;
        int_status      <= next_int_status;
        int_complete    <= next_int_complete;
        count_reseted   <= next_count_reseted;
        count           <= next_count;
        ina             <= next_ina;
        inb             <= next_inb;
        int_z_d1        <= next_int_z;
        int_z_d2        <= int_z_d1;
        int_status_d1   <= next_int_status;
        int_status_d2   <= int_status_d1;
        int_complete_d1 <= int_complete_advanced;
        int_complete_d2 <= int_complete_d1;
        start_clk       <= start;
        a_reg           <= a;
        b_reg           <= b;
        rnd_reg         <= (start==1'b1)?rnd:rnd_reg;
      end else begin
        int_z           <= {(exp_width + sig_width){1'bx}};
        int_status      <= {8{1'bx}};
        int_complete    <= 1'bx;
        count_reseted   <= 1'bx;
        count           <= -1;
        ina             <= {TOTAL_WIDTH{1'bx}};
        inb             <= {TOTAL_WIDTH{1'bx}};
        int_z_d1        <= {(exp_width + sig_width){1'bx}};
        int_z_d2        <= {(exp_width + sig_width){1'bx}};
        int_status_d1   <= {8{1'bx}};
        int_status_d2   <= {8{1'bx}};
        int_complete_d1 <= 1'bx;
        int_complete_d2 <= 1'bx;
        start_clk       <= 1'bx;
        a_reg           <= {TOTAL_WIDTH{1'bx}};
        b_reg           <= {TOTAL_WIDTH{1'bx}};
        rnd_reg         <= 3'bxxx;
      end
    end
    always @(posedge clk) begin: RST_FSM_PROC
      if (rst_n == 1'b0) begin
        reset_st <= 1'b1;
      end else begin
        if (start == 1'b1) reset_st <= 1'b0;
      end 
    end
  end
  endgenerate

  
`ifndef DW_DISABLE_CLK_MONITOR
`ifndef DW_SUPPRESS_WARN
  always @ (clk) begin : P_monitor_clk 
    if ( (clk !== 1'b0) && (clk !== 1'b1) && ($time > 0) )
      $display ("WARNING: %m:\n at time = %0t: Detected unknown value, %b, on clk input.", $time, clk);
    end // P_monitor_clk 
`endif
`endif

`ifdef UPF_POWER_AWARE
  `protected
#2>OZ0WE8?./AU7=G8T+L2\bcXDK?+8f9YJ#T_=2[QUG^7--eL_#6)AI8BQ5JE[)
\8T->/VZ1LNL9+XaAB(H/U-eQ9<R)N>]?33bc^9/+-YdfI&^VUcg=^eI8S:f9;b&
CTWNb8@KA>e,B,L3,Ng(?7^(#3&;&:.MFYJ@H/e&.6DHP8U7+P1d0LVCF22Q?TD_
3-2[7[Zgd1DXINdfIGg<f8YU]e-Ge9HFYIO9TPc=0MY24<f/X&aT<-e_-90(J.&S
AZ@c5L3F/B;V[=406&Pe?6E0Q:_GcUHYb)>R/HW9>T.E(0+[TD_F<af.=gZ\1>@X
EF3E8[?36cS,#<ZD@/@35.Q9.-4ZS5cR]-OSKOTM@W=]X^RY:.HUR^J59.)0;.P=
EU[JMdHSOV(K_Xb+BK&^&_G>0:U7#L#^6]J#V[NcA;Xc.:/EV3^a[(4U@696N(RJ
X5=VZ@WB8N]0G^>gC(9?Y/JEAL9T-2R9fd;eV.\SJcWE8_9O;TH:GX4Z@??=d^CW
>_>:a=,[.f9@R9-\57P_:1g.MDL4J7]DIK6:F=KY7(6gD3b<BRF<(NEEL@JIVYFT
aEaQSW-;6TS5:MA2e8EcF_]Y>fR9&6+Od0/gH)Ne\ff@&2fS?5cAbUX.3@+OB)0G
MZ-R=(RD5)YUSLW>\>W=YW-H+J6Y^5Y9:Z</C@#Z@,NQ2B8&gF+Q1a1UXSagT:fM
84.H;Q;gE2QMB6469@MHKY,&HfX4d80]M^I6dQDW[<VY,DaZK],4R9J2WM^L^LQ<
3;1J(,WKE+ZD+2Q(LI<([c,,J_+U&_d#_M?5+g)CKOR\gO0>R+=VBg2eBLg#Ze(&
6QeG(?#]@a>^F389G90H84?BIY0W267QM1H;R<.Q5G_Q;ZM?fNB[Gd4\,(g1FSVb
DJ#=E\/0bHZ4KJO;(S9X6SC(]G81a5E7^=6;U<MY>0Y#56\<Gc=9B)g6\MJcIQ&f
Z@;AM7+59c[DSYZOfC/HID9Tc/7RG7dTSNP>A.QBe#\MR3@N7>P7>1I3#+Nd@B6/
6.+&[?7N>W(aQ2-V?C4=KW)B-5D;U6e+,eYZKZ0SAC,+5(:QH7=/,9?=5SW2^9QE
]=(7DWAL#LgZD-[c70C=@e0/R,1.(aLV>#2]UdGU8.8/a(ZV\e/XKC]c1^?-b4;+
B]W/YOZY<&]:)/]9RR5]c3(g=^3C=gaaEK_\M7WXD7f5DEJ\MB9W4b):JH7acLX0
K(3=]O:g1V\gP&=5;IY(:C1T\=Y+7)D>ISQ]fOMAOF(W]M@a38g-OMb/7,HGJ&Z&
M<f<<Y[11GOJe]Q@b0A/d0\V>,gg4eXRd7?818J;GV(,ZcA^V[Ub#+Oc=[gDZ:;R
dZITD.T&)Z//9F_J2SgB1C]a;eP5G]C6-_=Y+JE7F/3NT_Kd:D97;\\98:..NI[3
(?E+4QNIcCLXKZEE,8Y<H#RDf4+;]\>/5CC.AT>4g77(.F&DYYF<(]MSXNDaPK>8
?^]\:>FgOU(D4=]Ye9fZJ5^S0/2#5UEUd-AB0&>&ZA8Agb_]DAfLX(_Wde3#cPSR
eg2?)OLU:J#,P>37cKe8UAI<c==N?FHIbLZNC2O?Z@\H>aU1fR)N^92Y1@-ZU[@O
\Sc@V,>_4g1K9_eLY:X5Q-^.\5^I4G5ET(c6:NG6K#_22MKSL;KU2b1<@;+G9H)T
,GF3J_=eGd:JB-OI54d9;L:\a7#(?IfH2L<EbcPB61CE0D[A/+/aPTZ6+L<.E0D^
TD\&7)R:6A\E^D:IZg6:[S#D89T+&?51MD0?5?IBNQQ+S0b?.f?Y1dgHPGM4MAFJ
:\0/V0C&3fQT^GO#,A6KH@Q?@/OaC(G5?^+a=WN6OXaPYVdYL<aARZYONeFL7D17
^A9g;Lc/EC^]0;/#,W7A6#+-KgX\3[8eIQ9Aaa]NFQ4cTb.e&g99/9f^b-[fc,LF
fZ&NA>T<7B-QfUXd&.?,L=GeSa)f/Ge+-)VQ\5DF14<\bg?/+FA4R5bOF6?bcN<2
Mc:L&<)cCW-8DdZ8<.XeLKF:77]=d-Y+dJTD6(?TX4#@dB.W.3[L_YD_^EfLK8K;
.6SW--D3CgA=U@GD33&COZ@64fN4]5aUW7Wb[K&Re?cS,a2-C0P,Nb^S0O[b::=S
8[<aXEDN)N3H]7He76[UH7[3W:LO9-]=L2>7c(KSAdZE6A/-[8b#a.SHbOWZZ5E5
UW#TLPK[-U?ZJ3LTH[G.BO<2B>8(X2Xb?3[\.f4]W#TL+f,ZR:8.82-FcL[S+?M)
(2FSg?G8YE,YKeTX:<8EZ[PP^N#2dZKGV[(J:6(dJ>#c],2B5eD]W,T>)0>#[dO5
0HL5&d8776#OSYD2Y]IH(#7[a=faEbJcGI1I]H^=RU&Dg17-f5\5>E#YGCbd2>aS
CYOTC#X4C4>5PJeb4<T/?9B,.3.RSS/-G6GbFJE,Bf=DG$
`endprotected

`else
    always @ (posedge clk) begin : corrupt_alert_PROC

      if (new_input_pre == 1'b1) begin
`ifndef DW_SUPPRESS_WARN
          $display ("WARNING: %m:\n at time = %0t: Operand input change on DW_fp_div_seq during calculation (configured without an input register) will cause corrupted results if operation is allowed to complete.", $time);
`endif
      end

      if (corrupt_data == 1'b1 && complete == 1'b1) begin
	$display(" ");
	$display("############################################################");
	$display("############################################################");
	$display("##");
	$display("## Error!! : from %m");
	$display("##");
	$display("##    This instance of DW_fp_div_seq has encountered changes");
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


// synopsys translate_on

endmodule
