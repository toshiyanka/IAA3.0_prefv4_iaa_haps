//##############################################################################
//## Intel Top Secret                                                         ##
//##############################################################################
//## Copyright (C) 2012, Intel Corporation.  All rights reserved.             ##
//##                                                                          ##
//## This is the property of Intel Corporation and may only be utilized       ##
//## pursuant to a written Restricted Use Nondisclosure Agreement             ##
//## with Intel Corporation.  It may not be used, reproduced, or              ##
//## disclosed to others except in accordance with the terms and              ##
//## conditions of such agreement.                                            ##
//##                                                                          ##
//## All products, processes, computer systems, dates, and figures            ##
//## specified are preliminary based on current expectations, and are         ##
//## subject to change without notice.                                        ##
//##############################################################################
//##
//##   Memory Name: c73p1rfshdxrom2048x32hb4img110
//##
//##   Memory Features :
//##   =========================================================================
//##       Word Width             = 32
//##       Word Depth             = 2048
//##       Column Mux             = 8
//##       Column Redundancy      = False
//##       Row Redundancy         = False
//##       Bist Enable            = False
//##       Scan Enable            = False
//##
//##############################################################################

//--------------------START OF LVLIB MODEL ---------------------------------




MemoryTemplate (c73p1rfshdxrom2048x32hb4img110) {

        MemoryType                           : ROM;
        CellName                             : c73p1rfshdxrom2048x32hb4img110;
        LogicalPorts                         : 1R0W;
        OperationSet                         : ROM;
        ATD                                  : Off;
        Algorithm                            : ReadOnly;
        BitGrouping                          : 1;
        ConcurrentRead                       : Off; 
        ConcurrentWrite                      : Off; 
        DataOutStage                         : None;
        DataOutHoldWithInactiveReadEnable    : On;
        PipelineDepth                        : 0;
        ObservationLogic                     : Off;     
        InternalScanLogic                    : Off;  
        NumberofBits                         : 32;
        NumberofWords                        : 2048;
        MemoryHoldWithInactiveSelect         : On;
        ReadOutofRangeOk                     : off;
        SelectDuringWriteThru                : off;
        ShadowRead                           : Off;
        ShadowWriteOK                        : Off;
        WriteOutOfRange                      : off;
        TransparentMode                      : None;

   AddressCounter {
       Function (Address) {
           LogicalAddressmap {
               ColumnAddress[2:0]  : Address[2:0] ; // ROM column address
               RowAddress[7:0]     : Address[10:3] ; // ROM Row address.
           }
       }
       Function (RowAddress)    { CountRange [0:255] ; }
       Function (ColumnAddress) { CountRange [0:7] ; }
   }

//----- Start of Logical Port wrapper definition -------------------

   Port (ickr)       { Direction: Input; Function: Clock; }
   Port (iar)        { BusRange: [10:0]; Direction: Input; Function: Address; }
   Port (iren)       { Direction: Input; Function: ReadEnable;  Polarity: ActiveHigh; }
   Port (ipwreninb)  { Direction: Input; Function: None; Polarity: ActiveLow; SafeValue: 0; }
   Port (odout)      { BusRange: [31:0]; Direction: Output; Function: Data; }
   Port (opwrenoutb) { Direction: Output; Function: None; Polarity: ActiveLow; }
}

