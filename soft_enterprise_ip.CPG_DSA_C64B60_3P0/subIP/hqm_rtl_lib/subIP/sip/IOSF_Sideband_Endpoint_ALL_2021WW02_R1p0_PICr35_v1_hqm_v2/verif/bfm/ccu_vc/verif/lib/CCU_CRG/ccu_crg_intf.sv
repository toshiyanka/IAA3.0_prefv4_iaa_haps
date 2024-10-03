//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 25-02-2011 
//-----------------------------------------------------------------
// Description:
// Clock Reset Generator interface
//------------------------------------------------------------------  

//`undef INC_CCU_CRG_PARAMS
//`include "ccu_crg.svh"

interface ccu_crg_intf #(
      parameter NUM_CLKS = 1,
      parameter NUM_RSTS = 1 ) 
    ( output logic [NUM_CLKS-1:0] clocks, 
	  output logic [NUM_CLKS-1:0] ungated_clocks,
      output logic [NUM_RSTS-1:0] resets
   );

  string intfName = $psprintf("%m");

endinterface :ccu_crg_intf
 

