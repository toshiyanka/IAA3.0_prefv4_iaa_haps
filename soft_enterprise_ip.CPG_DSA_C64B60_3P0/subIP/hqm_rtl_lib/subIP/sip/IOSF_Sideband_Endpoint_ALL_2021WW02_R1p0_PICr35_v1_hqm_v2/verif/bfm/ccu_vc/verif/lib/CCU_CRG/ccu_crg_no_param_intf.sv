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

interface ccu_crg_no_param_intf
   (
      output logic [255:0] clocks, 
	  output logic [255:0] ungated_clocks,
      output logic [255:0] resets
   );

  string intfName = $psprintf("%m");

endinterface :ccu_crg_no_param_intf
 

