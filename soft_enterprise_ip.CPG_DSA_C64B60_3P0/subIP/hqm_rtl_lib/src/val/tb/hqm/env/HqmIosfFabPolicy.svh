//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Description:
// HqmIosfFabPolicy extended class definition
//------------------------------------------------------------------

class HqmIosfFabPolicy extends IosfFabPolicy;
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   static const string CLASSNAME = "HqmIosfFabPolicy";
   
   //------------------------------------------
   // Methods 
   //------------------------------------------
   // Standard OVM Methods 
   extern function new (string name = "");
  
   // APIs 
   extern virtual function void routeDown (
      input    IosfFabCfg   iosfFabCfg,
      input    IosfMasTxn   txn,
      output   int          tgtNode,
      output   int unsigned tgtChid,
      output   int unsigned destID);
   extern virtual function void routeUp   (
      input    IosfFabCfg   iosfFabCfg,
      input    IosfMasTxn   txn,
      output   int          tgtNode,
      output   int unsigned tgtChid,
      output   int unsigned destID);

   // OVM Macros 
   `ovm_object_utils (HqmIosfFabPolicy)
endclass: HqmIosfFabPolicy

/*******************************************************************
 * HqmIosfFabPolicy Class constructor
 * @param   name  OVM name
 * @return        A new object of type HqmIosfFabPolicy 
 *******************************************************************/
function HqmIosfFabPolicy::new (string name = "");
   super.new (name);
endfunction: new

/*******************************************************************
 * Default simple implementation for routing downstream
 * @param   iosfFabCfg  Calling fabric configuration descriptor
 * @param   txn         Master transaction to route
 * @param   tgtNode     Target node to forward the transaction to
 * @param   tgtChid     Target channel ID to forward the transaction to
 * @param   destID      Target destination ID to include in the transaction
 * @return              None 
 *******************************************************************/
function void HqmIosfFabPolicy::routeDown (
    input      IosfFabCfg    iosfFabCfg,
    input      IosfMasTxn    txn,
    output     int           tgtNode,
    output     int unsigned  tgtChid,
    output     int unsigned  destID);
   tgtNode = 1;

   if(iosfFabCfg.iosfAgtCfg[tgtNode].disableTc2ChMap4Cpl == 1) 
     tgtChid = txn.trafficClass;
   else 
     tgtChid = iosfFabCfg.iosfAgtCfg[tgtNode].tc2Chid[txn.trafficClass] ;

   destID  = txn.destID;
endfunction: routeDown

/*******************************************************************
 * Default simple implementation for routing upstream
 * @param   iosfFabCfg  Calling fabric configuration descriptor
 * @param   txn         Master transaction to route
 * @param   tgtNode     Target node to forward the transaction to
 * @param   tgtChid     Target channel ID to forward the transaction to
 * @param   destID      Target destination ID to include in the transaction
 * @return              None 
 *******************************************************************/
function void HqmIosfFabPolicy::routeUp (
    input   IosfFabCfg      iosfFabCfg,
    input   IosfMasTxn      txn,
    output  int             tgtNode,
    output  int unsigned    tgtChid,
    output  int unsigned    destID);
   tgtNode  = iosfFabCfg.upNode;
   tgtChid  = 0; //txn.trafficClass;
   destID   = txn.destID;
endfunction: routeUp
