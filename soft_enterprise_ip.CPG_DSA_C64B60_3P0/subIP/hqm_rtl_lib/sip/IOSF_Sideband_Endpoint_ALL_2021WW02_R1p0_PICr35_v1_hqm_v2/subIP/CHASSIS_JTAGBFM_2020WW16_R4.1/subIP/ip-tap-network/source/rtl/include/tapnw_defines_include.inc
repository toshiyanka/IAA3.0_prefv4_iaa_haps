//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : tapnw_defines_include.sv
//    DESIGNER    : Rakesh Kandula
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : Declaration of `defines
//    DESCRIPTION :
//       User defined `defines. Please refer User Manual for examples.
//----------------------------------------------------------------------
//    `DEFINES  :
//----------------------------------------------------------------------
//    DFX_ASSERTIONS
//       This defines will enable the SV assertions that are coded in the
//       assertions and cover point files (<block_name>_include.sv files)
//       of the respective RTL blocks, which are included under rtl/include
//       directory  of this IP
//    DFX_FPV_ENABLE
//       To enable FPV tool.
//    FEV
//       After the addition of Ctech cells, this has to be defined to
//       avoid specify construct soc_clocks.sv to be ignored by FPV tool.
//----------------------------------------------------------------------
   // *********************************************************************
   // `defines - TAPNW
   // *********************************************************************
   `define DFX_ASSERTIONS
   `define DFX_PARAMETER_CHECKER
   //`define DFX_FPV_ENABLE 
   //`define FEV
