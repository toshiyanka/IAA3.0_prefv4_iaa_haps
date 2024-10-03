// Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature bf49de0a8c3d722d9d248ca1c87c47c7437e1610 % Version r1.0.0_m1.18 % _View_Id sv % Date_Time 20160216_100946 
//=============================================================================
//  Copyright (c) 2010 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY
//  COPYRIGHT LAWS AND IS CONSIDERED A TRADE SECRET BELONGING
//  TO THE INTEL CORPORATION.
//
//  Intel Confidential
//=============================================================================
//
// MOAD Begin
//     File/Block                             : soc_power_macros.sv
//     Design Style [rls|rf|ssa_fuse|sdp|
//                   custom|hier|rls_hier]    : rls
//     Circuit Style [non_rfs|rfs|ssa|fuse|
//                    IO|ROM|none]            : none
//     Common_lib (for custom blocks only)    : none  
//     Library (must be same as module name)  : soc_power_macros
//     Unit [unit id or shared]               : shared
//     Complex [North, South, CPU]            : North
//     Bizgroup [LCP|SEG|ULMD]                : ULMD
//
// Design Unit Owner :  rabiul.islam@intel.com
// Primary Contact   :  rabiul.islam@intel.com
// 
// MOAD End
//
//=============================================================================
//
// Description:
//   <Enter Description Here>
//
//=============================================================================
`ifndef SOC_POWER_MACROS_VH
`define SOC_POWER_MACROS_VH

`include "bxt_macro_tech_map.vh"

///============================================================================================
///
/// Firewall
///
///============================================================================================


//SAME as FIREWALL_AND from soc_macros.sv but created seperate version
//for different checking on clocks. Still same library cell though.
`define FIREWALL_AND_CLK(out,data,enable)                                           \
`ifdef DC                                                                           \
   `LIB_FIREWALL_AND(out,data,enable)                                               \
`else                                                                               \
   `ifdef MACRO_ATTRIBUTE                                                           \
                                                                                    \
   `endif                                                                           \
   assign out = data & {$bits(out){enable}}; /* lintra s-35000, s-35006 */          \
`endif


//SAME as LS_WITH_AND_FW from soc_macros.sv but created seperate version
//for different checking on clocks. Still same library cell though.
`define LS_WITH_AND_FW_CLK(o, pro, a, vcc_in, en)                                                 \
`ifdef DC                                                                                         \
     `LIB_LS_WITH_AND_FW_CLK(o, pro, a, vcc_in, en)                                                   \
`else                                                                                             \
     `ifdef MACRO_ATTRIBUTE                                                                       \
                                                                                                  \
     `endif                                                                                       \
     assign o = a & {$bits(o){en}};   /* lintra s-35000, s-35019 */                               \
`endif 

`define FIREWALL_AND(out,data,enable)                                               \
`ifdef DC                                                                           \
   `LIB_FIREWALL_AND(out,data,enable)                                               \
`else                                                                               \
   `ifdef MACRO_ATTRIBUTE                                                           \
                                                                                    \
   `endif                                                                           \
   assign out = data & {$bits(out){enable}}; /* lintra s-35000, s-35006 */          \
`endif

`define FIREWALL_OR(out,data,enable)                                                \
`ifdef DC                                                                           \
   `LIB_FIREWALL_OR(out,data,enable)                                                \
`else                                                                               \
   `ifdef MACRO_ATTRIBUTE                                                           \
                                                                                    \
   `endif                                                                           \
   assign out = data | ~{$bits(out){enable}}; /* lintra s-35000, s-35006 */         \
`endif


///============================================================================================
///
/// Voltage Level Shifters
///
///============================================================================================



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
   `ifdef MACRO_ATTRIBUTE                                                                 \
                                                                                          \
   `endif                                                                                 \
   always_latch                                                                           \
      begin                                                                               \
         if (iwrite_en) outb <= ~ib;   /* lintra s-30529, s-30518, s-31501, s-35006 */    \
      end                                                                                 \
/* lintra s-30500, s-30543 */                                                             \
`endif

//Signal Description
//outb       Level shifter output, 
//ipro       Output supply domain name (example: vccxxxvidsi0gt_1p05), 
//ib         Input signal to be level shifted,
//vccin      Input supply domain name (example: vccxxxvidsi0_1p05),
//iwrite_en  Level shifter firewall enable. Should come from the output supply domain.

`define LS_LATCH_PWR_PN(outb, ipro, ib, vccin, iwrite_en )                                  \
  `ifdef MACRO_ATTRIBUTE                                                                    \
                                                                                            \
  `endif                                                                                    \
  always_latch                                                                              \
      begin                                                                                 \
         if (iwrite_en) outb <= ~ib; /* lintra s-30529, s-30518, s-35006 */                 \
      end   

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
   `ifdef MACRO_ATTRIBUTE                                                                 \
                                                                                          \
   `endif                                                                                 \
   always_latch                                                                           \
      begin                                                                               \
         if (iwrite_en) outb <= ~ib;   /* lintra s-30529, s-30518, s-31501, s-35006 */    \
      end                                                                                 \
/* lintra s-30500, s-30543 */                                                             \
`endif

/* lintra s-30500, s-30543 */

//Signal Desctiption
//o       Level shifter output,
//pro     Output supply domain name (example: vccxxxvidsi0gt_1p05),
//a       Input signal to be level shifted,
//vcc_in  Input supply domain name (example: vccxxxvidsi0_1p05),
//en      Level shifter firewall enable. Should come from the output supply domain.
//To code level shifters with no firewall enable, please use LS_WITH_AND_FW macro with en tied to the output supply domain.

`define LS_WITH_AND_FW(o, pro, a, vcc_in, en)                                                     \
`ifdef DC                                                                                         \
     `LIB_LS_WITH_AND_FW(o, pro, a, vcc_in, en)                                                   \
`else                                                                                             \
     `ifdef MACRO_ATTRIBUTE                                                                       \
                                                                                                  \
     `endif                                                                                       \
     assign o = a & {$bits(o){en}};   /* lintra s-35019 */                                        \
`endif 

//Signal Description
//o       Level shifter output,
//pro     Output supply domain name (example: vccxxxvidsi0gt_1p05),
//a       Input signal to be level shifted,
//vcc_in  Input supply domain name (example: vccxxxvidsi0_1p05),
//en      Level shifter firewall enable. Should come from the output supply domain.

`define LS_WITH_OR_FW(o, pro, a, vcc_in, en)                                                      \
`ifdef DC                                                                                         \
     `LIB_LS_WITH_OR_FW(o, pro, a, vcc_in, en)                                                    \
`else                                                                                             \
     `ifdef MACRO_ATTRIBUTE                                                                       \
                                                                                                  \
     `endif                                                                                       \
     assign o = a | ~{$bits(o){en}};   /* lintra s-35019 */                                       \
`endif 

// New always ON inverter macro for Mihir
// Usage is only for the other power plane (Non-Vnn power plane)
`define POWER_INVERTER_D(powerenout, powerenin, vcc_in)                                          \
`ifdef DC                                                                                        \
     `LIB_POWER_INVERTER_D(powerenout, powerenin, vcc_in)                                        \
`else                                                                                            \
  `ifdef MACRO_ATTRIBUTE                                                                         \
                                                                                                 \
  `endif                                                                                         \
  assign powerenout = ~powerenin ;     /* lintra s-35000, s-35006 */                             \
`endif 


///============================================================================================
///
/// Power Switch
///
///============================================================================================



//`define POWERSWITCH(pwren_out, vcc_out, pwren_in, vcc_in, vss_in)  \
//   assign vcc_out   = ~pwren_in ? vcc_in : 1'bz ;                  \
//   assign pwren_out = ~(~(pwren_in)); /* lintra s-35022 */         \

//// new FW macro proposed by Bradley Erwin
`define POWERSWITCH(pwren_out, vcc_out, pwren_in, vcc_in, vss_in)                                         \
`ifdef DC                                                                                                 \
     `LIB_POWERSWITCH(pwren_out, vcc_out, pwren_in, vcc_in, vss_in)                                       \
`else                                                                                                     \
   `ifdef MACRO_ATTRIBUTE                                                                                 \
                                                                                                          \
   `endif                                                                                                 \
   assign vcc_out = ~pwren_in ? vcc_in : 1'bz; /* lintra s-30505 */                                       \
   assign pwren_out = ~(~(pwren_in)); /* lintra s-35022 */                                                \
`endif


//Signal Description
//o                    Level shifter output,
//vccout            Output supply domain name (example: vccxxxvidsi0gt_1p05),
//a                    Input signal to be level shifted,
//vccin              Input supply domain name (example: vccxxxvidsi0_1p05),
//THIS MACRO SHOULD ONLY BE USED GOING FROM ALWAYS ON SUPPLIES TO COLLAPSIBLE SUPPLIES
 
`define LS_WITH_NO_FW(o, vccout, a, vccin)                                                                \
`ifdef DC                                                                                                 \
`else                                                                                                     \
     `ifdef MACRO_ATTRIBUTE                                                                               \
         (* macro_attribute = `"LS_WITH_NO_FW(o``,vccout``,a``,vccin``)`" *)                              \
     `endif                                                                                               \
     assign o = a;   /* lintra s-35000, s-35019 */                                                        \
`endif                                                                                                    \

//Adding this macro after approval from Raboul. 
//Email notes from Quddus, Wasim: We need a MACRO to instantiate LS going from rtc_well to sus_well.
//I talked with Rabiul, he suggested to use a different name, i.e. LS_WITH_NO_FW_TG.
//We want the b12sirblnx20tg cell to implement the LS from TG library.

//
`define LS_WITH_NO_FW_TG(o, vccout, a, vccin)                                                             \
`ifdef DC                                                                                                 \
  `LIB_LS_WITH_NO_FW_TG(o, pro, a, vcc_in)                                                                \
`else                                                                                                     \
     `ifdef MACRO_ATTRIBUTE                                                                               \
         (* macro_attribute = `"LS_WITH_NO_FW_TG(o``,vccout``,a``,vccin``)`" *)                           \
     `endif                                                                                               \
     assign o = a;   /* lintra s-35000, s-35019 */                                                        \
`endif



`endif //  `ifndef SOC_POWER_MACROS_VH

/*******************************************************************************************************************
*
 *  MACROS NOT BEING USED BY ANYONE ELSE - 
*  
*******************************************************************************************************************/
////=========================================================================================
////
//// Firewall Mux module
////
////========================================================================================





//`define FIREWALL_MUX(iout, idata1, idata2, ienable, ivcc_soc)                      \
//   fw_mux \``fw_mux_``iout (                                                       \
//                           .out(iout),                                             \
//                           .data1(idata1),                                         \
//                           .data2(idata2),                                         \
//                           .enable(ienable),                                       \
//                           .vcc_soc(ivcc_soc)                                      \
//                                );                
//
// // This param will be and with the (HMBOUND[5:0] << 20)
//
//
//gmodule fw_mux(out, data1, data2, enable, vcc_soc);
//g  output logic out;
//g  input logic data1;
//g  input logic data2;
//g  input logic enable;
//g  input logic vcc_soc;
//g  logic enable_b;
//g  logic data_out1, data_out2, data_out1_b;
//g  `POWER_INVERTER_D(enable_b, enable, vcc_soc)
//g  `POWER_INVERTER_D(data_out1_b, data_out1, vcc_soc)
//g  `FIREWALL_AND(data_out1, data1, enable_b)
//g  `FIREWALL_AND(data_out2, data2, enable)
//g  `FIREWALL_OR(out, data_out2, data_out1_b)
//gendmodule

