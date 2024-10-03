//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : tapnw_params_include.sv
//    DESIGNER    : Shivaprashant Bulusu
//    PROJECT     : TAP Network
//    
//    
//    PURPOSE     : Parameter declarations
//    DESCRIPTION :
//       User defined parameters. Please refer User Manual for examples.
//    PARAMETERS  :
//       TAPNW_NUMBER_OF_STAPS
//          The number of Slave TAP's in the network.
//       TAPNW_PARK_TCK_AT    
//          Hold TCK High or Hold TCK Low
//       TAPNW_HIER_HYBRID     
//          Hierarchical Hybrid
//       TAPNW_NUMBER_OF_STAPS_IN_SUBNW 
//          User defined (Number of  Slave TAP's of Next network) NS"
//----------------------------------------------------------------------
   // *********************************************************************
   // Parameters
   // *********************************************************************

   // *********************************************************************
   // ======================USER AREA STARTS===============================
   // *********************************************************************

   parameter TAPNW_NUMBER_OF_STAPS           = 8,
   //Note:--> Width of parameter TAPNW_PARK_TCK_AT should be equal to value of paramater TAPNW_NUMBER_OF_STAPS   
   parameter TAPNW_PARK_TCK_AT               = 8'b0000_0000, 
   parameter TAPNW_HIER_HYBRID               = 0, 
   parameter TAPNW_NUMBER_OF_STAPS_IN_SUBNW  = 1, 


   // *********************************************************************
   // ======================USER AREA ENDS=================================
   // *********************************************************************


