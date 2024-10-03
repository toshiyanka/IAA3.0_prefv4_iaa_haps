//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : tapnw5_params_include.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : TAPNW Parameters
//    DESCRIPTION : This is a parameter file. This file contains
//                  parameters for tapnw0 instance of tapnw which gets
//                  instantiated in mtap_tapnw_taps.sv file
//----------------------------------------------------------------------

   parameter TAPNW5_NUMBER_OF_STAPS           = 2;
   //Note:--> Width of parameter TAPNW_PARK_TCK_AT should be equal to value of paramater TAPNW_NUMBER_OF_STAPS    
   parameter TAPNW5_PARK_TCK_AT               = 2'b10; 
   parameter TAPNW5_HIER_HYBRID               = 0; 
   parameter TAPNW5_NUMBER_OF_STAPS_IN_SUBNW  = 0;
