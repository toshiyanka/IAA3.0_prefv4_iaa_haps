//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-01 
//-----------------------------------------------------------------
// Description:
// ccu_intf interface definition
//------------------------------------------------------------------

/**
 * TODO: Add interface description
 */
interface ccu_intf #(parameter NUM_SLICES=1) ;
   //------------------------------------------
   // Block Comment 
   //------------------------------------------

   bit [NUM_SLICES-1:0] clk;
   bit [NUM_SLICES-1:0] clkreq;
   bit [NUM_SLICES-1:0] clkack;
   bit [NUM_SLICES-1:0] usync;
   bit globalusync;
   bit[NUM_SLICES-1:0] reset;
   bit[NUM_SLICES-1:0] global_rst_b;
   bit[NUM_SLICES-1:0] pwell_pok;

endinterface: ccu_intf

