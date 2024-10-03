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





MemoryTemplate (c73p1rfshdxrom2048x32hb4img110_dfx_wrapper) {

        MemoryType                           : ROM;
        CellName                             : c73p1rfshdxrom2048x32hb4img110_dfx_wrapper;
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

   PhysicalAddressMap {
     ColumnAddress[0] : c[0];
     ColumnAddress[1] : c[1];
     ColumnAddress[2] : c[2];
     RowAddress[0] : r[0];
     RowAddress[1] : r[1];
     RowAddress[2] : r[2];
     RowAddress[3] : r[3];
     RowAddress[4] : r[4];
     RowAddress[5] : r[5];
     RowAddress[6] : r[6];
     RowAddress[7] : r[7];
   }


//----- Start of Logical Port wrapper definition -------------------

   Port (FUNC_CLK_ROM_IN)       { Direction: Input; Function: Clock; EmbeddedTestLogic {TestInput: BIST_CLK_ROM_IN;} }
   Port (FUNC_ADDR_ROM_IN)      { BusRange: [10:0]; Direction: Input; Function: Address; EmbeddedTestLogic {TestInput: BIST_ADDR_ROM_IN[10:0];} }
   Port (FUNC_REN_ROM)          { Direction: Input; Function: ReadEnable; Polarity: ActiveHigh; EmbeddedTestLogic {TestInput: BIST_REN_ROM;} }
   Port (BIST_ROM_ENABLE)       { Direction: Input; Function: BistEn; Polarity: ActiveHigh; }
   Port (FSCAN_RAM_AWT_MODE)    { Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 1'b0; }
   Port (FSCAN_RAM_AWT_REN)     { Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 1'b0; }
   Port (FSCAN_RAM_RDDIS_B)     { Direction: Input; Function: None; Polarity: ActiveLow; SafeValue: 1'b1; }
   Port (FSCAN_RAM_ODIS_B)      { Direction: Input; Function: None; Polarity: ActiveLow; SafeValue: 1'b1; }
   Port (DFX_MISC_ROM_IN)       { BusRange: [4:0]; Direction: Input; Function: None; Polarity: ActiveLow; SafeValue: 5'b11111; }
   Port (DFX_MISC_ROM_OUT)      { BusRange: [4:0]; Direction: Output; Function: None; Polarity: ActiveLow; }
   Port (LBIST_TEST_MODE)       { Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 1'b0; }
   Port (FUSE_MISC_ROM_IN)      { BusRange: [4:0]; Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 5'b00000; }
   Port (PWR_MGMT_MISC_ROM_IN)  { BusRange: [3:0]; Direction: Input; Function: None; Polarity: ActiveLow; SafeValue: 4'b0000; }
   Port (PWR_MGMT_MISC_ROM_OUT) { BusRange: [3:0]; Direction: Output; Function: None; Polarity: ActiveLow; }
   Port (FSCAN_RAM_BYPSEL)      { Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 0; }
   Port (DATA_ROM_OUT)          { BusRange: [31:0]; Direction: Output; Function: Data; }
}

