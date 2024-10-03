//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-01 
//-----------------------------------------------------------------
// Description: non param interface
// ccu_intf interface definition
//------------------------------------------------------------------

/**
 * TODO: Add interface description
 */
interface ccu_np_intf(
   //------------------------------------------
   // Block Comment 
   //------------------------------------------
   input bit [512:0] clk,
   input bit [512:0] clkreq,
   input bit [512:0] clkack,
   input bit [512:0] usync,
   input bit globalusync,
   input bit [512:0] reset,
   input bit [512:0] global_rst_b,
   input bit [512:0] pwell_pok

);

endinterface: ccu_np_intf

