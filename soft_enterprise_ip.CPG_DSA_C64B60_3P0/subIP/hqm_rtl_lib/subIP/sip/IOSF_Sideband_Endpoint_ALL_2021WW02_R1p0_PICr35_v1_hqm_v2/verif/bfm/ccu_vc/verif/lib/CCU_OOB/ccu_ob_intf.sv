//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 11-08-2011 
//-----------------------------------------------------------------
// Description:
// Out of Band interface
//------------------------------------------------------------------  


/*interface ccu_ob_intf (remove parameters)
  #(int MAX_OB_NUM = ccu_ob::MAX_OB_NUM,
    int  MAX_OB_SIZE = ccu_ob::MAX_OB_SIZE)
   (
    );*/
interface ccu_ob_intf();
   import ccu_ob_pkg::ccu_ob;
   localparam int MAX_OB_NUM = ccu_ob::MAX_OB_NUM;
   localparam int MAX_OB_SIZE = ccu_ob::MAX_OB_SIZE;
   
   logic [MAX_OB_NUM:0][MAX_OB_SIZE:0] ob;
   
   string intfName = $psprintf("%m");

endinterface :ccu_ob_intf
