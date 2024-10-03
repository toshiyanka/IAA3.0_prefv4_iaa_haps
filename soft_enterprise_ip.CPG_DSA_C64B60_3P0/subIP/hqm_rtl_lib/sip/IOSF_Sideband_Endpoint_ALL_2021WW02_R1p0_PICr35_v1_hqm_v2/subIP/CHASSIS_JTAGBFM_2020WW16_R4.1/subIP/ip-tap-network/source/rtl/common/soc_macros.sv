//=============================================================================
//  Copyright (c) 2008 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY
//  COPYRIGHT LAWS AND IS CONSIDERED A TRADE SECRET BELONGING
//  TO THE INTEL CORPORATION.
//
//  Intel Confidential
//=============================================================================
//
// MOAD Begin
//     File/Block                          : soc_macros.sv
//     Block Type [hier|fub|shared|inst]   : shared
//     Design Style [rls|sdp|custom]       : none
//     Circuit Style [rfs|ssa|IO|ROM|other]: <circuit_style>
//     Collateral DB [pvx|na]              : <db>
//     Fub Type [fub|fubp]                 : <fub_type>
//     Unit                                : none
// MOAD End
//  
// Design Unit Owner : Martin.J.Licht@intel.com
// Primary Contact   : Aditi.D.Gore@intel.com
//
//=============================================================================
//
// Description:
//   <Enter Description Here>
//
//=============================================================================
`ifndef SOC_MACROS_SV
`define SOC_MACROS_SV

`include "vlv_macro_tech_map.vh"
//`include "pnw_macro_tech_map.vh"


///============================================================================================
///
/// Firewall
///
///============================================================================================

`define FIREWALL_AND(out,data,enable)                                               \
`ifdef DC                                                                           \
   `LIB_FIREWALL_AND(out,data,enable)                                               \
`else                                                                               \
   assign out = data & {$bits(out){enable}}; /* novas s-55000, s-55006 */           \
`endif


`define FIREWALL_OR(out,data,enable)                                                \
`ifdef DC                                                                           \
   `LIB_FIREWALL_OR(out,data,enable)                                                \
`else                                                                               \
   assign out = data | ~{$bits(out){enable}}; /* novas s-55000, s-55006 */          \
`endif

`define FIREWALL_MUX(iout, idata1, idata2, ienable, ivcc_soc)                      \
   fw_mux \``fw_mux_``iout (                                                        \
                           .out(iout),                                             \
                           .data1(idata1),                                         \
                           .data2(idata2),                                         \
                           .enable(ienable),                                       \
                           .vcc_soc(ivcc_soc)                                       \
                                );                                                 

///============================================================================================
///
/// Voltage Level Shifters
///
///============================================================================================

//Signal Description
//outb       Level shifter output,
//ib         Input signal to be level shifted,
//ipro       Input supply domain name (example: vccxxxvidsi0gt_1p05), 
//iwrite_en  Level shifter firewall enable. Should come from the output supply domain.
//Note: Output supply domain is implicit vcc!

`define LS_LATCH_UP(outb,ib,ipro,iwrite_en)                                               \
`ifdef DC                                                                                 \
     `LIB_LS_LATCH_UP(outb,iwrite_en,ipro,ib)                                             \
`else                                                                                     \
   always_latch                                                                           \
      begin                                                                               \
         if (iwrite_en) outb <= ~ib;   /* novas s-50529, s-50518, s-51501, s-55006 */     \
      end                                                                                 \
/* novas s-50500, s-50543 */                                                              \
`endif


//Signal Description
//outb       Level shifter output, 
//ipro       Output supply domain name (example: vccxxxvidsi0gt_1p05), 
// ib        Input signal to be level shifted,
//iwrite_en  Level shifter firewall enable. Should come from the output supply domain.
//Note: Input supply domain is implicit vcc!

`define LS_LATCH_DN(outb,ipro,ib,iwrite_en)                                               \
`ifdef DC                                                                                 \
     `LIB_LS_LATCH_DN(outb,iwrite_en,ipro,ib)                                             \
`else                                                                                     \
   always_latch                                                                           \
      begin                                                                               \
         if (iwrite_en) outb <= ~ib;   /* novas s-50529, s-50518, s-51501, s-55006 */     \
      end                                                                                 \
/* novas s-50500, s-50543 */                                                              \
`endif

//Signal Description
//outb       Level shifter output, 
//ipro       Output supply domain name (example: vccxxxvidsi0gt_1p05), 
//ib         Input signal to be level shifted,
//vccin      Input supply domain name (example: vccxxxvidsi0_1p05),
//iwrite_en  Level shifter firewall enable. Should come from the output supply domain.

//This macro is meant only for custom blocks as there is no DC mapping for synthesis
`define LS_LATCH_PWR_PN(outb, ipro, ib, vccin, iwrite_en )                                  \
  always_latch                                                                              \
      begin                                                                                 \
         if (iwrite_en) outb <= ~ib; /* novas s-50529, s-50518, s-55006 */                  \
      end                                                                                   \
/* novas s-50500, s-50543 */

//Signal Desctiption
//o       Level shifter output,
//pro     Output supply domain name (example: vccxxxvidsi0gt_1p05),
//a       Input signal to be level shifted,
//vcc_in  Input supply domain name (example: vccxxxvidsi0_1p05),
//en      Level shifter firewall enable. Should come from the output supply domain.
//To code level shifters with no firewall enable, please use LS_WITH_AND_FW macro with en tied to the output supply domain.

`define LS_WITH_AND_FW(o, pro, a, vcc_in, en)                                                     \
`ifdef DC                                                                                         \
     `LIB_LS_WITH_AND_FW(o, pro, a, vcc_in, en)                                                    \
`else                                                                                             \
     assign o = a & {$bits(o){en}};   /* novas s-55019 */                                         \
`endif 

//Signal Description
//o       Level shifter output,
//pro     Output supply domain name (example: vccxxxvidsi0gt_1p05),
//a       Input signal to be level shifted,
//vcc_in  Input supply domain name (example: vccxxxvidsi0_1p05),
//en      Level shifter firewall enable. Should come from the output supply domain.

`define LS_WITH_OR_FW(o, pro, a, vcc_in, en)                                                      \
`ifdef DC                                                                                         \
     `LIB_LS_WITH_OR_FW(o, pro, a, vcc_in, en)                                                     \
`else                                                                                             \
     assign o = a | ~{$bits(o){en}};   /* novas s-55019 */                                        \
`endif 



// New always ON inverter macro for Mihir
// Usage is only for the other power plane (Non-Vnn power plane)
`define POWER_INVERTER_D(powerenout, powerenin, vcc_in)                                          \
`ifdef DC                                                                                      \
     `LIB_POWER_INVERTER_D(powerenout, powerenin, vcc_in)                                        \
`else                                                                                          \
  assign powerenout = ~powerenin ;     /* novas s-55000, s-55006 */                            \
`endif          


// New inverter for top level tie-offs
// Usage is only for top level tie-offs so inverter won't be optimized away by synthesis
`define INV_PRSRV(outb,in)                                          \
`ifdef DC                                                           \
     `LIB_INV_PRSRV(outb,in)                                        \
`else                                                               \
  assign outb = ~in ;                                               \
`endif          

//New macros for top level tie-offs
`define TIEOFF_0_PRSRV(out)                                        \
`ifdef DC                                                          \
   `LIB_TIEOFF_0_PRSRV(out)  /* novas s-50516 */                   \
`else                                                              \
   assign out = {$bits(out){1'b0}};                                \
`endif                                                             

`define TIEOFF_1_PRSRV(out)                                        \
`ifdef DC                                                          \
   `LIB_TIEOFF_1_PRSRV(out) /* novas s-50516 */                    \
`else                                                              \
   assign out = {$bits(out){1'b1}};                                \
`endif 

// New BUFFER for 1ns of delay ***** ONLY FOR USE ON UNGATED SUPPLIES (VNN OR VNNAON)
`define BUF_1NS_DELAY_UNGATED(out,in,vcc_in)                      \
`ifdef DC                                                         \
     `LIB_BUF_1NS_DELAY_UNGATED(out,in,vcc_in)                    \
`else                                                             \
  assign out = in ;     /* novas s-55000, s-55006 */              \
`endif          


///============================================================================================
///
/// Power Switch
///
///============================================================================================

//// only behavioural defn for this macro, as per Rabiul , this macro will not be used by synthesis fubs

//`define POWERSWITCH(pwren_out, vcc_out, pwren_in, vcc_in, vss_in)  \
//   assign vcc_out   = ~pwren_in ? vcc_in : 1'bz ;                  \
//   assign pwren_out = ~(~(pwren_in)); /* novas s-55022 */          \

//// new FW macro proposed by Bradley Erwin
`define POWERSWITCH(pwren_out, vcc_out, pwren_in, vcc_in, vss_in)                                         \
`ifdef DC                                                                                                 \
     `LIB_POWERSWITCH(pwren_out, vcc_out, pwren_in, vcc_in, vss_in) \
`else                                                                                                     \
   assign vcc_out = ~pwren_in ? vcc_in : 1'bz;                                                            \
   assign pwren_out = ~(~(pwren_in)); /* novas s-55022 */                                                 \
`endif


////=========================================================================================
////
//// Firewall Mux module
////
////========================================================================================
/*
module fw_mux(out, data1, data2, enable, vcc_soc);
  output logic out;
  input logic data1;
  input logic data2;
  input logic enable;
  input logic vcc_soc;
  logic enable_b;
  logic data_out1, data_out2, data_out1_b;
  `POWER_INVERTER_D(enable_b, enable, vcc_soc)
  `POWER_INVERTER_D(data_out1_b, data_out1, vcc_soc)
  `FIREWALL_AND(data_out1, data1, enable_b)
  `FIREWALL_AND(data_out2, data2, enable)
  `FIREWALL_OR(out, data_out2, data_out1_b)
endmodule
*/
////===========================================================================================
////
//// DATA MUX
////
////===========================================================================================
// Data Mux for timing critical signals

`define MUX_2TO1_HF(out,in1,in2,sel)                       \
`ifdef DC                                                  \
   `LIB_MUX_2TO1_HF(out,in1,in2,sel)                       \
`else                                                      \
   assign out = (in1 & sel) | (in2 & ~sel);                \
`endif  

`define MUX_2TO1_INV_HF(out,in1,in2,sel)                       \
`ifdef DC                                                  \
   `LIB_MUX_2TO1_INV_HF(out,in1,in2,sel)                       \
`else                                                      \
   assign out = ~((in1 & sel) | (in2 & ~sel));                \
`endif        


// Data Mux using NAND-NAND gates for timing critical signals
`define NAND_3TO1MUX(iout,iin1,iin2,iin3,isel1,isel2,isel3)    \
nand_3to1_mux \``nand_mux_``iout (                             \
                                  .out(iout),                  \
                                  .in1(iin1),                  \
                                  .in2(iin2),                  \
                                  .in3(iin3),                  \
                                  .sel1(isel1),                \
                                  .sel2(isel2),                \
                                  .sel3(isel3)                 \
                                 ); 

module nand_3to1_mux(out,in1,in2,in3,sel1,sel2,sel3);
output logic out;
input logic in1;
input logic in2;
input logic in3;
input logic sel1;
input logic sel2;
input logic sel3;
`ifdef DC
   `LIB_NAND_3TO1MUX(out,in1,in2,in3,sel1,sel2,sel3) 
`else 
  always_comb begin
    casex({ sel1, 
            sel2,
            sel3 })
      3'b100  : out = in1;
      3'b010  : out = in2;
      3'b001  : out = in3;
      default : out = 1'b0;
    endcase
  end
`endif        
endmodule
//============================================================================================
//
//  6 Bit Comparator
//
//============================================================================================
`define COMPARATOR_6_BIT(out, in1, in2)                       \
compare_6_bit \``compare_6_bit_``out (                        \
                                  .iout(out),                 \
                                  .iin1(in1),                 \
                                  .iin2(in2)                  \
                                 ); 

module compare_6_bit(iout, iin1, iin2);
output logic iout;
input logic [5:0] iin1;
input logic [5:0] iin2;
`ifdef DC
   `LIB_compare_6_bit(iout, iin1, iin2)
`else 
   assign iout = (iin1 == iin2);
`endif        
endmodule

///============================================================================================
///
/// Flops and Drivers
///
///============================================================================================

// MSFF macros:
//
// The standard MSFF takes as its input both the gridclk and its counterpart clock enable. In real circuit
// implementation, these two signals ANDed together will give you your gated clock.
//
// If you create your own clock, (you are not using the MAKE_CLK_ENABLE() macro) then tie the clken off with 1'b1 as its
// input. Otherwise use the MAKE_CLK_ENABLE() macro and use gridclock as your clk input.
//
// If you are flopping an L phase signal, be sure to pass in ~gridclk as your clk and an L phase clken. The L phase
// clken should be created with the MAKE_CLK_ENABLE() macro, with all inputs of L phase.
//
`define MSFF(q,i,clock)                                     \
   always_ff @(posedge clock)                               \
      begin                                                 \
         q <= i;                                            \
      end                                                   \
/* novas s-50500 */

//Creating a MSFF_NONSCAN to allow users to instantiate a flop which won't be added to the scan chain
//Note that in DC mode the library module creates an instance name integration can key off
//of as well as appending _nonscan to the output signal name. Both of which should ensure the
//cell is kept and not swapped out for a scan version.
`define MSFF_NONSCAN(q,i,clock)                              \
  logic [$bits(q)-1:0] \``q``_nonscan ;                      \
  assign q = \``q``_nonscan ;                                \
                                                             \
  `ifdef DC                                                  \
    `LIB_MSFF_NONSCAN(q,i,clock)                \
  `else                                                      \
    always_ff @(posedge clock)                               \
      begin                                                  \
         \``q``_nonscan <= i;                                \
      end                                                    \
  `endif

`define MSFF_BLK(q,i,clock)                                 \
   logic [$bits(i)-1:0] \``dlyin_``q ;                        \
   assign #1 \``dlyin_``q = i;                                \
   always_ff @(posedge clock)                               \
      begin                                                 \
         q = \``dlyin_``q ;                                   \
      end                                                   \
/* novas s-50500, s-51501, s-50531 */                       \

`define MSFF_P(q,i,clock)                                   \
   always_ff @(negedge clock)                               \
      begin                                                 \
         q <= i;                                            \
      end                                                   \
/* novas s-50500 */

`define EN_MSFF(q,i,clock,enable)                           \
   always_ff @(posedge clock)                               \
      begin                                                 \
         if (enable) q <= i;                                \
       end                                                  \
/* novas s-50500 */

`define RST_MSFF(q,i,clock,rst)                             \
   always_ff @(posedge clock)                               \
      begin                                                 \
         if (rst) q <= '0;                                  \
         else     q <=  i;                                  \
      end                                                   \
/* novas s-50500 */


`define SET_MSFF(q,i,clock,set)                             \
   always_ff @(posedge clock)                               \
      begin                                                 \
         if (set) q <= {$bits(q){1'b1}};                    \
         else     q <=  i;                                  \
      end                                                   \
/* novas s-50500 */                                         \


`define RST_MSFF_P(q,i,clock,rst)                           \
   always_ff @(negedge clock)                               \
      begin                                                 \
         if (rst) q <= '0;                                  \
         else     q <=  i;                                  \
      end

`define EN_RST_MSFF(q,i,clock,enable,rst)                   \
   always_ff @(posedge clock )                              \
      begin                                                 \
         if ( rst )         q <= '0 ;                       \
         else if ( enable ) q <=  i ;                       \
      end                                                   \
/* novas s-50500 */

`define EN_RST_MSFF_P(q,i,clock,enable,rst)                 \
   always_ff @(negedge clock )                              \
      begin                                                 \
         if ( rst )         q <= '0 ;                       \
         else if ( enable ) q <=  i ;                       \
      end


`define EN_SET_MSFF(q,i,clock,enable,set)                   \
   always_ff @(posedge clock)                               \
      begin                                                 \
         if (set)         q <= {$bits(q){1'b1}};            \
         else if (enable) q <=  i;                          \
      end                                                   \
/* novas s-50500 */

// The set/reset is assigned to a variable inside the macro to facilitate passing ~rst as an input to the macro.
// Else we get a synthesis error which complains about a complex function as a clock to the flop. 

`define ASYNC_RST_MSFF(q,i,clock,rst)                       \
wire \``q``_rst ;                                           \
assign \``q``_rst = rst ;                                   \
   always_ff @(posedge clock or posedge \``q``_rst )        \
      begin                                                 \
         if ( \``q``_rst )  q <= '0;                        \
         else      q <=  i;                                 \
      end                                                   \
/* novas s-50500 */

`define ASYNC_SET_MSFF(q,i,clock,set)                       \
   logic \``q``_set ;                                       \
   assign \``q``_set = set ;                                \
   always_ff @(posedge clock or posedge \``q``_set )        \
      begin                                                 \
         if (\``q``_set ) q <= {$bits(q){1'b1}};            \
         else                 q <=  i;                      \
      end                                                   \
/* novas s-50500 */

`define NO_SYNTH_ASYNC_RST_MSFF_BLK(q,i,clock,rst)                   \
   logic [$bits(i)-1:0] \``dlyin_``q ;                        \
   assign #1 \``dlyin_``q = i;                                \
   always_ff @(posedge clock or posedge rst)                \
      begin                                                 \
         if (rst)  q = '0;                                  \
         else      q =  \``dlyin_``q ;                        \
      end                                                   \
/* novas s-50500, s-50531 */

`define ASYNC_RST_MSFF_P(q,i,clock,rst)                     \
   always_ff @(negedge clock or posedge rst)                \
      begin                                                 \
         if (rst)  q <= '0;                                 \
         else      q <=  i;                                 \
   end

`define NO_SYNTH_ASYNC_RST_MSFF_P_BLK(q,i,clock,rst)                 \
   logic [$bits(i)-1:0] \``dlyin_``q ;                        \
   assign #1 \``dlyin_``q = i;                                \
   always_ff @(negedge clock or posedge rst)                \
      begin                                                 \
         if (rst)  q = '0;                                  \
         else      q =  \``dlyin_``q ;                        \
      end                                                   \
/* novas s-50500, s-50531 */

`define ASYNC_RSTD_MSFF(q,i,clock,rst,rstd)                 \
   always_ff @(posedge clock or posedge rst)                \
      begin                                                 \
         if (rst)  q <= rstd;                               \
         else      q <= i;                                  \
      end                                                   \
/* novas s-50500 */

`define EN_ASYNC_RSTD_MSFF(q,i,clock,enable,rst,rstd)       \
   always_ff @(posedge clock or posedge rst)                \
      begin                                                 \
         if (rst)  q <= rstd;                               \
         else if (enable) q <= i;                           \
      end                                                   \
/* novas s-50500 */

`define NO_SYNTH_EN_ASYNC_RST_MSFF_BLK(q,i,clock,enable,rst)         \
   logic [$bits(i)-1:0] \``dlyin_``q ;                        \
   logic \``dlyen_``q ;                                       \
   assign #1 \``dlyin_``q = i;                                \
   assign #1 \``dlyen_``q = enable;                           \
   always_ff @(posedge clock or posedge rst)                \
      begin                                                 \
         if (rst)     q = '0;                               \
         else if (\``dlyen_``q ) q = \``dlyin_``q ;             \
      end                                                   \
/* novas s-50500, s-50531 */


`define ASYNC_SET_RST_MSFF(q,i,clock,set,rst)               \
   logic \``rst_``q ;                                          \
   logic \``set_``q ;                                          \
   assign \``rst_``q = rst ;                                  \
   assign \``set_``q = set ;                                  \
   always_ff @(posedge clock or posedge set or posedge rst ) \
      begin                                                 \
         if (rst)      q <= {$bits(q){1'b0}};        \
         else if (set) q <= {$bits(q){1'b1}};        \
         else                 q <=  i;                      \
      end                                                   
//// =========================================================================================
////                         HIGH FREQUENCY FLOPS/LATCHES
//// =========================================================================================
`define LATCH_P_HF_NONSCAN(q,i,clock)                       \
  logic [$bits(q)-1:0] \``q``_nonscan ;                     \
  assign q = \``q``_nonscan ;                               \
`ifdef DC                                                   \
   `LIB_LATCH_P_HF_NONSCAN(q,i,clock)                       \
`else                                                       \
   always_latch                                             \
      begin                                                 \
         if (~clock) \``q``_nonscan <= i;                   \
      end                                                   \
`endif

`define ASYNC_RSTB_MSFF_HF_NONSCAN(q,i,clock,rstb)                      \
  logic [$bits(q)-1:0] \``q``_nonscan ;                                 \
  assign q = \``q``_nonscan ;                                           \
`ifdef DC                                                               \
   `LIB_ASYNC_RSTB_MSFF_HF_NONSCAN(q,i,clock,rstb)                      \
`else                                                                   \
   wire \``q``_rstb ;                                                   \
   assign \``q``_rstb = rstb ;                                          \
   always_ff @(posedge clock or negedge \``q``_rstb )                   \
      begin                                                             \
         if (~(\``q``_rstb ))  \``q``_nonscan <= '0;                    \
         else      \``q``_nonscan <=  i;                                \
      end                                                               \
`endif
/* novas s-50500 */


///============================================================================================
///           META STABLE 2 FLOP MACROS - REQUESTED BY Larry Thatcher for cJTAG IP support,
///                                                    Chris Tsay for South Cluster support
///============================================================================================
`define ASYNC_RST_2MSFF_META(q,i,clk,rstb)                     \
`ifdef DC                                                      \
  `LIB_ASYNC_RST_2MSFF_META(q,i,clk,rstb)                      \
`else                                                          \
  logic [$bits(i)-1:0] \``staged_``q ;                                        \
  always_ff @(posedge clk or negedge rstb ) begin              \
    if ( ~rstb )       \``staged_``q <= '0;                    \
    else               \``staged_``q <=  i;                    \
  end                                                          \
  always_ff @(posedge clk or negedge rstb) begin               \
    if ( ~rstb )       q <= '0;                                \
    else               q <=  \``staged_``q ;                   \
  end                                                          \
`endif                                                         \
/* novas s-50500 */

`define ASYNC_SET_2MSFF_META(q,i,clk,psb)                      \
`ifdef DC                                                      \
  `LIB_ASYNC_SET_2MSFF_META(q,i,clk,psb)                       \
`else                                                          \
  logic [$bits(i)-1:0] \``staged_``q ;                                        \
  always_ff @(posedge clk or negedge psb ) begin               \
    if ( ~psb )        \``staged_``q <= '1;                    \
    else               \``staged_``q <=  i;                    \
  end                                                          \
  always_ff @(posedge clk or negedge psb) begin                \
    if ( ~psb )        q <= '1;                                \
    else               q <=  \``staged_``q ;                   \
  end                                                          \
`endif                                                         \
/* novas s-50500 */



///============================================================================================
///           META STABLE FLOP MACRO 
///============================================================================================
//***** NEEDS TO BE UPDATED BASED ON OUTCOME OF LIBRARY REQUEST *****
`define MSFF_META(q,i,clock)                                   \
`ifdef DC                                                      \
     `LIB_SOC_MSFF_META(q,i,clock)                             \
`else                                                          \
   always_ff @(posedge clock)                                  \
      begin                                                    \
         q <= i;                                               \
      end                                                      \
/* novas s-50500 */                                            \
`endif

//***** NEEDS TO BE UPDATED BASED ON OUTCOME OF LIBRARY REQUEST *****
`define ASYNC_RST_MSFF_META(q,i,clk,rstb)                      \
`ifdef DC                                                      \
  `LIB_ASYNC_RST_MSFF_META(q,i,clk,rstb)                       \
`else                                                          \
                                                               \
  always_ff @(posedge clk or negedge rstb) begin               \
    if ( ~rstb )  q <= '0;                                     \
    else          q <=  i;                                     \
  end                                                          \
`endif                                                         \
/* novas s-50500 */


`define LATCH(q,i,clock)                                    \
   always_latch                                             \
      begin                                                 \
         if (clock) q <= i;                                 \
      end                                                   \
/* novas s-50500 */

`define LATCH_P(q,i,clock)                                  \
   always_latch                                             \
      begin                                                 \
         if (~clock) q <= i;                                \
      end                                                   \
/* novas s-50500 */

`define RST_LATCH(q,i,clock,rst)                            \
   always_latch                                             \
      begin                                                 \
         if (clock)                                         \
            if (rst) q <= '0;                               \
            else     q <=  i;                               \
      end                                                   \
/* novas s-50500 */


`define ASYNC_SET_LATCH(q,i,clock,set)                      \
   always_latch                                             \
     begin                                                  \
         if (set)          q <= '1; /* novas s-50529 */     \
           else if (clock) q <=  i;                         \
             end                                            \
/* novas s-50500 */

`define ASYNC_RST_LATCH(q,i,clock,rst)                      \
   always_latch                                             \
      begin                                                 \
         if      (rst) q <= '0; /* novas s-50529 */         \
         else if (clock) q <=  i;                           \
      end /* novas s-50500 */

`define EN_ASYNC_RST_LATCH(q,i,clock,enable,rst)            \
   always_latch                                             \
      begin                                                 \
         if      (rst)      q <= '0; /* novas s-50529 */    \
         else if (clock & enable) q <=  i;                  \
      end /* novas s-50500 */

`define ASYNC_RSTD_LATCH(q,i,clock,rst,rstd)                \
   always_latch                                             \
      begin                                                 \
         if      (rst) q <= rstd;                           \
         else if (clock) q <= i;                            \
      end                                                   \
/* novas s-50500 */

//*****Is the synth tool doing the right thing here? Should be grabbing a p-latch, not putting an inverter on the clock. *****
//*** From Shreenath's reply looks like synthesis will chose a LATCH_P for inverted clocks.
`define ASYNC_RSTD_LATCH_P(q,i,clock,rst,rstd)   `ASYNC_RSTD_LATCH(q,i,(~(clock)),rst,rstd)

`define ASYNC_RST_SET_B(q_b,rst,set)                          \
   always_latch                                               \
      begin                                                   \
         if (set | rst)                                       \
            if (rst) q_b = '1; /* novas s-50529, s-50531  */  \
            else     q_b = '0;                                \
      end                                                     \
/* novas s-50500 */

`define ASYNC_RST_SET(q,rst,set)                            \
  `RST_LATCH(q,set,(set|rst),rst)                           \
/* novas s-50500 */

//Same functionality as regular latch, but adding DE-SKEW to the name
//so that it is clear whenever this latch is instantiated it is intended to be 
//redundant to reduce mindelay problems between high-skew sequentials
`define LATCH_DESKEW(q,i,clock)                             \
   always_latch                                             \
      begin                                                 \
         if (clock) q <= i;                                 \
      end                                                   \
/* novas s-50500 */

`define LATCH_P_DESKEW(q,i,clock)                           \
   always_latch                                             \
      begin                                                 \
         if (~clock) q <= i;                                \
      end                                                   \
/* novas s-50500 */

// ----------------------------------
//  RESET DISTRIBUTION MACROS
// ----------------------------------
`define MAKE_RST_DIST(irstoutb, iusyncout, iclk, irstinb, iusyncin) \
    sync_rst_gen \``sync_rst_``irstoutb (                                \
         .rstoutb(irstoutb),                                           \
         .usyncout(iusyncout),                                         \
         .clk(iclk),                                                   \
         .rstinb(irstinb),                                             \
         .usyncin(iusyncin)                                            \
   );                                                                  \
/* novas s-51500, s-53048, s-53049 */

module sync_rst_gen (rstoutb, usyncout, clk, rstinb, usyncin); 
output logic rstoutb;
output logic usyncout;
input  logic clk;
input  logic rstinb;
input  logic usyncin;
      logic n_rstoutb;                                                        
      logic nin_rstoutb;                                                      
      `MSFF(usyncout, usyncin, clk)                                            
      assign n_rstoutb = (usyncout? rstinb : rstoutb);                     
      assign nin_rstoutb = ~rstinb;                                         
      `ASYNC_RST_MSFF(rstoutb, n_rstoutb, clk, nin_rstoutb)
endmodule 



///============================================================================================
///
/// IO Driver Macros
///
///============================================================================================
///
///
///   BUS TYPE MACRO                DESCRIPTION        UNDRIVEN VALUE* CONTENTION*
///  
///   TRI                         - Tri-State          'Z              Multiple Drivers
///   WAND                        - Wired-And          Weakpull 1      None 
///   WOR                         - Wired-Or           Weakpull 0      None 
///
///   *Semantics achieved only in conjunction with applicable, explict SUSTAIN, WEAKPULL, PRECHARGE, DRIVE macros
///    and relevant assertions
///
///   BUS DRIVER MACRO              DESCRIPTION
///
///   TRI_DRIVE     (Bus,En,Data) - Driver for busses of all Tri-State types
///   WAND_DRIVE    (Bus,En,Data) - WAND bus driver
///   WAND_WEAKPULL (Bus, En)     - WAND bus weak pull up
///   WOR_DRIVE     (Bus,En,Data) - WOR bus driver
///   WOR_WEAKPULL  (Bus, En)     - WOR bus weak pull down

`define NO_SYNTH_TRI_DRIVE(Bus,En,Data) /* novas s-50505 */              \
  `ifdef SYNTH_NOZ                                                       \
        assign Bus = {$bits(Bus){1'b1}};                                 \
  `else                                                                  \
        assign Bus = En ? Data : {$bits(Bus){1'bz}};                     \
  `endif

`define NO_SYNTH_WAND_WEAKPULL(Bus,En)                                                                   \
  `ifdef SYNTH_NOZ                                                                                       \
        assign (weak1, highz0)   Bus = {$bits(Bus){1'b1}};                                               \
  `else                                                                                                  \
        assign (weak1, highz0)   Bus = En ? {$bits(Bus){1'b1}} : {$bits(Bus){1'bz}};                     \
  `endif 

`define NO_SYNTH_WAND_DRIVE(Bus,En,Data)                                                   \
  `ifdef SYNTH_NOZ                                                                         \
        assign (strong0, highz1) Bus = En ? Data : {$bits(Bus){1'b1}};                     \
  `else                                                                                    \
        assign (strong0, highz1) Bus = En ? Data : {$bits(Bus){1'bz}};                     \
  `endif 

`define NO_SYNTH_WAND_TRI_DRIVE(Bus,En,Data) /* novas s-50505 */          \
  `ifdef SYNTH_NOZ                                                       \
        assign Bus = En ? Data : {$bits(Bus){1'b1}};                     \
  `else                                                                  \
        assign Bus = En ? Data : {$bits(Bus){1'bz}};                     \
  `endif

`define NO_SYNTH_WOR_WEAKPULL(Bus,En)                                                                    \
  `ifdef SYNTH_NOZ                                                                                       \
        assign (weak0, highz1)   Bus = {$bits(Bus){1'b0}};                                               \
  `else                                                                                                  \
        assign (weak0, highz1)   Bus = En ? {$bits(Bus){1'b0}} : {$bits(Bus){1'bz}};                     \
  `endif 

`define NO_SYNTH_WOR_DRIVE(Bus,En,Data)                                                    \
  `ifdef SYNTH_NOZ                                                                         \
        assign (strong1, highz0) Bus = En ? Data : {$bits(Bus){1'b0}};                     \
  `else                                                                                    \
        assign (strong1, highz0) Bus = En ? Data : {$bits(Bus){1'bz}};                     \
  `endif 

`define NO_SYNTH_WOR_TRI_DRIVE(Bus,En,Data) /* novas s-50505 */          \
  `ifdef SYNTH_NOZ                                                       \
        assign Bus = En ? Data : {$bits(Bus){1'b0}};                     \
  `else                                                                  \
        assign Bus = En ? Data : {$bits(Bus){1'bz}};                     \
  `endif

///============================================================================================
//Added by Sanjeev. Please review

`define SET_MSFF_BLK(q,i,clock,set)                         \
   logic [$bits(i)-1:0] \``dlyin_``q ;                         \
   logic \``dlyset_``q ;                                       \
   assign #1 \``dlyin_``q = i;                                \
   assign #1 \``dlyset_``q = set;                             \
   always_ff @(posedge clock)                               \
      begin                                                 \
         if ( \``dlyset_``q ) q = {$bits(q){1'b1}};           \
         else     q =  \``dlyin_``q ;                         \
      end    /* novas s-50500, s-51501, s-50531 */
                                                      
`define EN_RSTD_MSFF(q,i,clock,enable,rst,rstd)             \
   always_ff @(posedge clock)                               \
      begin                                                 \
         if (rst)          q <= rstd;                       \
         else if (enable)  q <= i;                          \
      end /* novas s-50500 */   
                                                     
`define MSFF_P_BLK(q,i,clock)                               \
   logic [$bits(i)-1:0] \``dlyin_``q ;                         \
   assign #1 \``dlyin_``q = i;                                \
   always_ff @(negedge clock )                              \
      begin                                                 \
         q = \``dlyin_``q ;                                  \
      end /* novas s-50500, s-50531 */

`define ASYNC_RST_MSFF_BLK(q,i,clock,rst)                   \
   logic [$bits(i)-1:0] \``dlyin_``q ;                         \
   assign #1 \``dlyin_``q = i;                                \
   wire \``q``_rst ;                                              \
   assign \``q``_rst = rst ;                                       \
   always_ff @(posedge clock or posedge \``q``_rst )                \
      begin                                                 \
         if ( \``q``_rst )  q = '0;                                  \
         else      q =  \``dlyin_``q ;                        \
      end /* novas s-50500, s-51501, s-50531 */

///============================================================================================

/////////////////////////////////////////////////////////////////
// BEGIN - Multi-cycle path macros section
/////////////////////////////////////////////////////////////////


`define MCP_BNL     `BNL
`define MCP_PUNIT   `PUNIT
`define MCP_CCK     `CCK
`define MCP_DUNIT   `DUNIT
`define MCP_NORTHC  `NORTHC
`define MCP_MUNIT   `MUNIT
`define MCP_HUNIT   `HUNIT
`define MCP_AUNIT   `AUNIT
`define MCP_BUNIT   `BUNIT
`define MCP_CUNIT   `CUNIT
`define MCP_BLAUNCH_PATH  `BLAUNCH_PATH
`define MCP_BRAM_PATH     `BRAM_PATH
`define MCP_DISP_2D `DISP_2D
`define MCP_GVD     `GVD
`define MCP_GFX     `GFX
`define MCP_VED     `VED
`define MCP_VEC     `VEC
`define MCP_FUS     `FUS
`define MCP_DMIC    `DMIC


`define MCP(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
  \
 `ifdef MCP_ON \
  logic signal_``macro_inst_name; \
  SVA_``macro_inst_name : `ASSERT_FORBIDDEN (signal_``macro_inst_name , 1'b0) `ERR_MSG (`"MCP stability condition violated for assertion SVA_``macro_inst_name as MCP_source_sig was not stable for phase_delay phases before it was sampled`") ; \
  \
  generate \
    if ((`"clock_edges_aligned_at_destination`" == "ALIGNED") && ((`"sampling_edge_or_phase`" == "RISING") || (`"sampling_edge_or_phase`" == "LOW"))) \
      soc_multi_cycle #(.N($bits(MCP_source_sig)), .PHASE(phase_delay), .CLOCKS_ALIGNED(1), .RX_SAMPLED_AT_POSEDGE(1)) mcpinst_``macro_inst_name (.out(signal_``macro_inst_name), .source_sig({>>{MCP_source_sig}}), .rx_clk(MCP_rx_clk), .rx_enable(MCP_rx_enable), .count_clk(MCP_count_clk)); \
    else if ((`"clock_edges_aligned_at_destination`" == "ALIGNED") && ((`"sampling_edge_or_phase`" == "FALLING") || (`"sampling_edge_or_phase`" == "HIGH"))) \
      soc_multi_cycle #(.N($bits(MCP_source_sig)), .PHASE(phase_delay), .CLOCKS_ALIGNED(1), .RX_SAMPLED_AT_POSEDGE(0)) mcpinst_``macro_inst_name (.out(signal_``macro_inst_name), .source_sig({>>{MCP_source_sig}}), .rx_clk(MCP_rx_clk), .rx_enable(MCP_rx_enable), .count_clk(MCP_count_clk)); \
    else if ((`"clock_edges_aligned_at_destination`" == "NOT_ALIGNED") && ((`"sampling_edge_or_phase`" == "RISING") || (`"sampling_edge_or_phase`" == "LOW"))) \
      soc_multi_cycle #(.N($bits(MCP_source_sig)), .PHASE(phase_delay), .CLOCKS_ALIGNED(0), .RX_SAMPLED_AT_POSEDGE(1)) mcpinst_``macro_inst_name (.out(signal_``macro_inst_name), .source_sig({>>{MCP_source_sig}}), .rx_clk(MCP_rx_clk), .rx_enable(MCP_rx_enable), .count_clk(MCP_count_clk)); \
    else if ((`"clock_edges_aligned_at_destination`" == "NOT_ALIGNED") && ((`"sampling_edge_or_phase`" == "FALLING") || (`"sampling_edge_or_phase`" == "HIGH"))) \
      soc_multi_cycle #(.N($bits(MCP_source_sig)), .PHASE(phase_delay), .CLOCKS_ALIGNED(0), .RX_SAMPLED_AT_POSEDGE(0)) mcpinst_``macro_inst_name (.out(signal_``macro_inst_name), .source_sig({>>{MCP_source_sig}}), .rx_clk(MCP_rx_clk), .rx_enable(MCP_rx_enable), .count_clk(MCP_count_clk)); \
    else \
      non_existent_mcp_module bogus_mcp_instance(); \
  endgenerate \
`endif



`define MCP_LNCFC(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
\
`ifdef LNCFC \
`MCP(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
`endif


`define MCP_LNCGFX(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
\
`ifdef LNCGFX \
`MCP(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
`else \
`MCP_LNCFC(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
`endif 


`define MCP_LNCBFM(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
\
`ifdef LNCBFM \
`MCP(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
`else \
`MCP_LNCGFX(MCP_source_sig, MCP_rx_enable, MCP_count_clk, MCP_rx_clk, phase_delay, macro_inst_name, clock_edges_aligned_at_destination, sampling_edge_or_phase) \
`endif


/////////////////////////////////////////////////////////////////
// END - Multi-cycle path macros
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
// Penwell NorthC macros
/////////////////////////////////////////////////////////////////

`define ASYNC_RST_MSFFD(q,i,clock,rst)                       \
wire \``q``_rst ;                                             \
assign \``q``_rst = rst ;                                      \
   always_ff @(posedge clock or posedge \``q``_rst )           \
      begin                                                 \
         if ( \``q``_rst )  q <= #1 '0;                      \
         else      q <=  #1 i;                                 \
      end                                                   \
/* novas s-50500 */


`define LATCH_PD(q,i,clock)                                  \
   always_latch                                             \
      begin                                                 \
         if (~clock) q <= #1 i;                                \
      end                                                   \
/* novas s-50500 */


 `define MUX21(_sel_,_ina_,_inb_,_out_) assign _out_ = (_sel_ ? _inb_ : _ina_)
 `define MUX41(_sel_,_ina_,_inb_,_inc_,_ind_,_out_) assign _out_ = _sel_[1] ?  (_sel_[0] ? _ind_ : _inc_) : (_sel_[0] ? _inb_ : _ina_)
 `define MUX81(_sel_,_ina_,_inb_,_inc_,_ind_,_ine_,_inf_,_ing_,_inh_,_out_) assign _out_ = _sel_[2] ? (_sel_[1] ?  (_sel_[0] ? _inh_ : _ing_) : (_sel_[0] ? _inf_ : _ine_)) : (_sel_[1] ?  (_sel_[0] ? _ind_ : _inc_) : (_sel_[0] ? _inb_ : _ina_))   
 `define MUX161(_sel_,_ina_,_inb_,_inc_,_ind_,_ine_,_inf_,_ing_,_inh_,_ini_,_inj_,_ink_,_inl_,_inm_,_inn_,_ino_,_inp_,_out_) assign _out_ = _sel_[3] ? (_sel_[2] ? (_sel_[1] ?  (_sel_[0] ? _inp_ : _ino_) : (_sel_[0] ? _inn_ : _inm_)) : (_sel_[1] ?  (_sel_[0] ? _inl_ : _ink_) : (_sel_[0] ? _inj_ : _ini_))) : (_sel_[2] ? (_sel_[1] ?  (_sel_[0] ? _inh_ : _ing_) : (_sel_[0] ? _inf_ : _ine_)) : (_sel_[1] ?  (_sel_[0] ? _ind_ : _inc_) : (_sel_[0] ? _inb_ : _ina_)))  


`define FLOP(_clk_,_rstB_,_in_,_out_)                      \
   always @(posedge _clk_)                                 \
   begin                                                   \
     if (~(_rstB_)) _out_ <= #1 'b0;                       \
     else _out_ <= #1 (_in_);                              \
   end 
   
                                                           
`define FLOP_NORESET(_clk_,_in_,_out_)                     \
   always @(posedge _clk_)                                 \
   begin                                                   \
     _out_ <= #1 (_in_);                                   \
   end 
   

`define FLOP_NORESET_NODELAY(_clk_,_in_,_out_)                     \
   always @(posedge _clk_)                                 \
   begin                                                   \
     _out_ <= (_in_);                                   \
   end 
   

`define FLOP_ENABLED(_clk_,_rstB_,_en_,_in_,_out_)         \
   always @(posedge _clk_)                                 \
   begin                                                   \
     if (~(_rstB_)) _out_ <= #1 'b0;                       \
     else _out_ <= #1 (_en_) ? (_in_) : _out_;             \
   end 
   
                                                           
`define FLOP_NEGEDGE(_clk_,_rstB_,_in_,_out_)              \
   always @(negedge _clk_)                                 \
   begin                                                   \
     if (~(_rstB_)) _out_ <= #1 'b0;                       \
     else _out_ <= #1 (_in_);                              \
   end 
   
 
`define FLOP_NEGEDGE_ENABLED(_clk_,_rstB_,_en_,_in_,_out_) \
   always @(negedge _clk_)                                 \
   begin                                                   \
     if (~(_rstB_)) _out_ <= #1 'b0;                       \
     else _out_ <= #1 (_en_) ? (_in_) : _out_;             \
   end 
   
											 
`define FLOP_SET(_clk_,_rstB_,_in_,_out_)                  \
   always @(posedge _clk_)                                 \
   begin                                                   \
     if (~(_rstB_)) _out_ <= #1 {$bits(_in_){1'b1}};          \
     else _out_ <= #1 (_in_);                              \
   end
   

`define FLOP_ENABLED_SET(_clk_,_rstB_,_en_,_in_,_out_)     \
   always @(posedge _clk_)                                 \
   begin                                                   \
     if (~(_rstB_)) _out_ <= #1 ~('b0);                    \
     else _out_ <= #1 (_en_) ? (_in_) : _out_;             \
    end 
   

`define FLOP_NEGEDGE_SET(_clk_,_rstB_,_in_,_out_)          \
   always @(negedge _clk_)                                 \
   begin                                                   \
     if (~(_rstB_)) _out_ <= #1 ~('b0);                    \
     else _out_ <= #1 (_in_);                              \
   end 
   
 
`define FLOP_NEGEDGE_ENABLED_SET(_clk_,_rstB_,_en_,_in_,_out_) \
   always @(negedge _clk_)                                     \
   begin                                                       \
     if (~(_rstB_)) _out_ <= #1 ~('b0);                        \
     else _out_ <= #1 (_en_) ? (_in_) : _out_;                 \
   end 




`define ASYNC_FLOP(_clk_,_rstB_,_in_,_out_) `ASYNC_RST_MSFFD(_out_,_in_,_clk_,(~_rstB_))
`define LATCH_NEGEDGE(_le_,_in_,_out_) `LATCH_PD(_out_,_in_,_le_)

`define ASYNC_FLOP_SET(_clk_,_rstB_,_in_,_out_)            \
   always @(posedge _clk_ or negedge _rstB_)               \
   begin                                                   \
     if (~(_rstB_)) _out_ <= #1 {$bits(_in_){1'b1}};       \
     else _out_ <= #1 (_in_);                              \
   end

  `define OUTREG logic


`endif 


