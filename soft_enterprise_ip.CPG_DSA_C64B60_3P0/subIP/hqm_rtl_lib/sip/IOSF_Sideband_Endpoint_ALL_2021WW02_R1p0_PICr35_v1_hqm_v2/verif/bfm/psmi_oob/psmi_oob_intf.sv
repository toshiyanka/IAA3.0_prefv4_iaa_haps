//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 11-08-2011 
//-----------------------------------------------------------------
// Description:
// Out of Band interface
//------------------------------------------------------------------  

interface psmi_oob_intf();

   import psmi_oob_pkg::psmi_oob;
   localparam int MAX_PSMI_OOB_NUM  = psmi_oob::MAX_PSMI_OOB_NUM;
   localparam int MAX_PSMI_OOB_SIZE = psmi_oob::MAX_PSMI_OOB_SIZE;
   
   logic [MAX_PSMI_OOB_SIZE-1:0] oob[MAX_PSMI_OOB_NUM];
   string intfName = $psprintf("%m");

endinterface :psmi_oob_intf
