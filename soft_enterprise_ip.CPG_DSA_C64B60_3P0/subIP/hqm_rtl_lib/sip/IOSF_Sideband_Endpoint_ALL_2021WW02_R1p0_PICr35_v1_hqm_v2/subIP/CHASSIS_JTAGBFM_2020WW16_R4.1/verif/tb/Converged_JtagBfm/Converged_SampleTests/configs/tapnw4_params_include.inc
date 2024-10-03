//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : tapnw4_params_include.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : TAPNW Parameters
//    DESCRIPTION : This is a parameter file. This file contains
//                  parameters for tapnw0 instance of tapnw which gets
//                  instantiated in mtap_tapnw_taps.sv file
//----------------------------------------------------------------------

   parameter TAPNW4_NUMBER_OF_STAPS           = 5;
   //Note:--> Width of parameter TAPNW_PARK_TCK_AT should be equal to value of paramater TAPNW_NUMBER_OF_STAPS    
   parameter TAPNW4_PARK_TCK_AT               = 2'b10; 
   parameter TAPNW4_HIER_HYBRID               = 0; 
   parameter TAPNW4_NUMBER_OF_STAPS_IN_SUBNW  = 0;
