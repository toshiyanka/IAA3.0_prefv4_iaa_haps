//##############################################################################
/////////////////////////////////////////////////////////////////////////////////////////////
// Intel Confidential                                                                      //
/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2023 Intel Corporation. The information contained herein is the proprietary   //
// and confidential information of Intel or its licensors, and is supplied subject to, and //
// may be used only in accordance with, previously executed agreements with Intel.         //
// EXCEPT AS MAY OTHERWISE BE AGREED IN WRITING: (1) ALL MATERIALS FURNISHED BY INTEL      //
// HEREUNDER ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND; (2) INTEL SPECIFICALLY     //
// DISCLAIMS ANY WARRANTY OF NONINFRINGEMENT, FITNESS FOR A PARTICULAR PURPOSE OR          //
// MERCHANTABILITY; AND (3) INTEL WILL NOT BE LIABLE FOR ANY COSTS OF PROCUREMENT OF       //
// SUBSTITUTES, LOSS OF PROFITS, INTERRUPTION OF BUSINESS, OR FOR ANY OTHER SPECIAL,       //
// CONSEQUENTIAL OR INCIDENTAL DAMAGES, HOWEVER CAUSED, WHETHER FOR BREACH OF WARRANTY,    //
// CONTRACT, TORT, NEGLIGENCE, STRICT LIABILITY OR OTHERWISE.                              //
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//  Vendor:                Intel Corporation                                               //
//  Product:               c764hduspsr                                                     //
//  Version:               r1.0.0                                                          //
//  Technology:            p1276.4                                                         //
//  Celltype:              MemoryIP                                                        //
//  IP Owner:              Intel CMO                                                       //
//  Creation Time:         Tue Mar 28 2023 19:11:52                                        //
//  Memory Name:           ip764hduspsr2048x39m8b2s0r2p0d0                                 //
//  Memory Name Generated: ip764hduspsr2048x39m8b2s0r2p0d0                                 //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////

//##############################################################################
//--------------------START OF LVLIB MODEL ---------------------------------

MemoryTemplate (ip764hduspsr2048x39m8b2s0r2p0d0_dfx_wrapper) {
//ArrayRTLHier:  ip764hduspsr2048x39m8b2s0r2p0d0_upf_wrapper.ip764hduspsr2048x39m8b2s0r2p0d0.ip764hduspsr2048x39m8b2s0r2p0d0_bmod.ip764hduspsr2048x39m8b2s0r2p0d0_array.array[Address][BIST_WR_DATA_IN]

        MemoryType                           : SRAM;
        CellName                             : ip764hduspsr2048x39m8b2s0r2p0d0_dfx_wrapper;
        LogicalPorts                         : 1RW;
        OperationSet                         : SyncCustom;
        // ATD                                  : Off;
        Algorithm                            : IntelLVMARCHCMINUSFX;
        BitGrouping                          : 1;
        // ConcurrentRead                       : Off;
        // ConcurrentWrite                      : Off;
        DataOutStage                         : None;
        // DataOutHoldWithInactiveReadEnable    : On;
        // PipelineDepth                        : 0;
        ObservationLogic                     : Off;
        InternalScanLogic                    : On;
        // NumberofBits                         : 39;
        NumberofWords                        : 2048;
        // MemoryHoldWithInactiveSelect         : On;
        // ReadOutofRangeOk                     : off;
        // SelectDuringWriteThru                : off;
        ShadowRead                           : Off;
        // ShadowWriteOK                        : Off;
        // WriteOutOfRange                      : off;
        TransparentMode                      : None;
        MinHold                              : 0.00;
        MilliWattsPerMegaHertz               : 0.00597;
//       MilliWattsPerMegaHertz   <default>   : 0.18096;

    AddressCounter {
        Function (Address) {
            LogicalAddressMap {
                ColumnAddress[2:0] : Address[2:0] ; // SRAM Column Address
                RowAddress[2:0]    : Address[5:3] ; // SRAM LSB Row Address
                BankAddress[0]     : Address[6] ; // Bank Address
                RowAddress[6:3]    : Address[10:7] ; // SRAM MSB Row Address
            }
        }
        Function (RowAddress)    { CountRange [0:127] ; }
        Function (ColumnAddress) { CountRange [0:7] ; }
        Function (BankAddress)   { CountRange [0:1] ; }
    }

// LVLIB representation for row and column address for checkerboard data pattern
// Bank address is not considered part of checkerboard row address
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

    }

//----- Start of Logical Port wrapper definition -------------------

    Port ( IP_RESET_B )              { Direction: Input; Function: None; Polarity: ActiveLow; SafeValue: 1;}
    Port ( PWR_MGMT_IN[5:0] )        { Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 6'b000000; }
    Port ( FUNC_CLK_IN )             { Direction: Input; Function: Clock; Polarity: ActiveHigh; EmbeddedTestLogic { TestInput: BIST_CLK_IN ; } }
    Port ( FUNC_ADDR_IN[10:0])     { Direction: Input; Function: Address; EmbeddedTestLogic { TestInput: BIST_ADDR_IN[10:0] ; } }
    Port ( FUNC_RD_EN_IN )           { Direction: Input; Function: ReadEnable; DisableDuringScan: Off; Polarity: ActiveHigh; EmbeddedTestLogic { TestInput: BIST_RD_EN_IN ; } }
    Port ( FUNC_WR_EN_IN )           { Direction: Input; Function: WriteEnable; DisableDuringScan: Off; Polarity: ActiveHigh; EmbeddedTestLogic { TestInput: BIST_WR_EN_IN ; } }
    Port ( FUNC_WR_DATA_IN[38:0])  { Direction: Input; Function: Data; EmbeddedTestLogic { TestInput: BIST_WR_DATA_IN[38:0] ; } }
    Port ( TRIM_FUSE_IN[19:0] )      { Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 20'b00000000000000000000; }
    Port ( SLEEP_FUSE_IN[1:0] )      { Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 2'b00; }
    Port ( ROW_REPAIR_IN[25:0] )     { Direction: Input; Function: BisrParallelData; Polarity: ActiveHigh; }
    Port ( COL_REPAIR_IN[12:0] )     { Direction: Input; Function: BisrParallelData; Polarity: ActiveHigh; }
    Port ( GLOBAL_RROW_EN_IN[1:0] )  { Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 2'b00; }
    Port ( BIST_ENABLE )             { Direction: Input; Function: BistOn; Polarity: ActiveHigh; }
    Port ( FSCAN_RAM_BYPSEL )        { Direction: Input; Function: None; Polarity: ActiveHigh;  SafeValue: 0; }
    Port ( FSCAN_RAM_WDIS_B )        { Direction: Input; Function: None; Polarity: ActiveLow;  SafeValue: 1; }
    Port ( FSCAN_RAM_RDIS_B )        { Direction: Input; Function: None; Polarity: ActiveLow;  SafeValue: 1; }
    Port ( FSCAN_RAM_INIT_EN )       { Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 0; }
    Port ( FSCAN_RAM_INIT_VAL )      { Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 0; }
    Port ( FSCAN_CLKUNGATE )         { Direction: Input; Function: None; Polarity: ActiveHigh;  SafeValue: 0; }
    Port ( WRAPPER_CLK_EN )          { Direction: Input; Function: None; Polarity: ActiveHigh;  SafeValue: 1; }
    Port ( ARRAY_FREEZE )            { Direction: Input; Function: None; Polarity: ActiveHigh;  SafeValue: 0; }
    Port ( ISOLATION_CONTROL_IN )    { Direction: Input; Function: None; Polarity: ActiveHigh;  SafeValue: 0; }
    Port ( OUTPUT_RESET )            { Direction: Input; Function: None; Polarity: ActiveHigh; SafeValue: 0; }
    Port ( PWR_MGMT_OUT[0] )         { Direction: Output; Function: None; Polarity: ActiveHigh; }
    Port ( DATA_OUT[38:0])         { Direction: Output; Function: Data; }
    

//----- Start of Redundancy Analysis Segment -------------

  RedundancyAnalysis {

    ColumnSegment (All) {
      NumberOfSpareElements : 1;
        ShiftedIORange : DATA_OUT[38:0] ;
          FuseSet {
            FuseMap[5:0] {
              ShiftedIO(DATA_OUT[0]) : 6'b000000;
              ShiftedIO(DATA_OUT[1]) : 6'b000001;
              ShiftedIO(DATA_OUT[2]) : 6'b000010;
              ShiftedIO(DATA_OUT[3]) : 6'b000011;
              ShiftedIO(DATA_OUT[4]) : 6'b000100;
              ShiftedIO(DATA_OUT[5]) : 6'b000101;
              ShiftedIO(DATA_OUT[6]) : 6'b000110;
              ShiftedIO(DATA_OUT[7]) : 6'b000111;
              ShiftedIO(DATA_OUT[8]) : 6'b001000;
              ShiftedIO(DATA_OUT[9]) : 6'b001001;
              ShiftedIO(DATA_OUT[10]) : 6'b001010;
              ShiftedIO(DATA_OUT[11]) : 6'b001011;
              ShiftedIO(DATA_OUT[12]) : 6'b001100;
              ShiftedIO(DATA_OUT[13]) : 6'b001101;
              ShiftedIO(DATA_OUT[14]) : 6'b001110;
              ShiftedIO(DATA_OUT[15]) : 6'b001111;
              ShiftedIO(DATA_OUT[16]) : 6'b010000;
              ShiftedIO(DATA_OUT[17]) : 6'b010001;
              ShiftedIO(DATA_OUT[18]) : 6'b010010;
              ShiftedIO(DATA_OUT[19]) : 6'b010011;
              ShiftedIO(DATA_OUT[20]) : 6'b010100;
              ShiftedIO(DATA_OUT[21]) : 6'b010101;
              ShiftedIO(DATA_OUT[22]) : 6'b010110;
              ShiftedIO(DATA_OUT[23]) : 6'b010111;
              ShiftedIO(DATA_OUT[24]) : 6'b011000;
              ShiftedIO(DATA_OUT[25]) : 6'b011001;
              ShiftedIO(DATA_OUT[26]) : 6'b011010;
              ShiftedIO(DATA_OUT[27]) : 6'b011011;
              ShiftedIO(DATA_OUT[28]) : 6'b011100;
              ShiftedIO(DATA_OUT[29]) : 6'b011101;
              ShiftedIO(DATA_OUT[30]) : 6'b011110;
              ShiftedIO(DATA_OUT[31]) : 6'b011111;
              ShiftedIO(DATA_OUT[32]) : 6'b100000;
              ShiftedIO(DATA_OUT[33]) : 6'b100001;
              ShiftedIO(DATA_OUT[34]) : 6'b100010;
              ShiftedIO(DATA_OUT[35]) : 6'b100011;
              ShiftedIO(DATA_OUT[36]) : 6'b100100;
              ShiftedIO(DATA_OUT[37]) : 6'b100101;
              ShiftedIO(DATA_OUT[38]) : 6'b100110;

            }
          }
          PinMap {
            SpareElement {
              RepairEnable: COL_REPAIR_IN[0];
              FuseMap[0] : COL_REPAIR_IN[1];
              FuseMap[1] : COL_REPAIR_IN[2];
              FuseMap[2] : COL_REPAIR_IN[3];
              FuseMap[3] : COL_REPAIR_IN[4];
              FuseMap[4] : COL_REPAIR_IN[5];
              FuseMap[5] : COL_REPAIR_IN[6];

            }
          }
    }

    RowSegment (ALL) {
      NumberOfSpareElements : 2;
        FuseSet {
          Fuse[0] : AddressPort(FUNC_ADDR_IN[3]);
          Fuse[1] : AddressPort(FUNC_ADDR_IN[4]);
          Fuse[2] : AddressPort(FUNC_ADDR_IN[5]);
          Fuse[3] : AddressPort(FUNC_ADDR_IN[6]);
          Fuse[4] : AddressPort(FUNC_ADDR_IN[7]);
          Fuse[5] : AddressPort(FUNC_ADDR_IN[8]);
          Fuse[6] : AddressPort(FUNC_ADDR_IN[9]);
          Fuse[7] : AddressPort(FUNC_ADDR_IN[10]);
        }
        PinMap  {
          SpareElement {
            RepairEnable : ROW_REPAIR_IN[0];
            Fuse[0] : ROW_REPAIR_IN[1];
            Fuse[1] : ROW_REPAIR_IN[2];
            Fuse[2] : ROW_REPAIR_IN[3];
            Fuse[3] : ROW_REPAIR_IN[4];
            Fuse[4] : ROW_REPAIR_IN[5];
            Fuse[5] : ROW_REPAIR_IN[6];
            Fuse[6] : ROW_REPAIR_IN[7];
            Fuse[7] : ROW_REPAIR_IN[8];
          }
          SpareElement {
            RepairEnable : ROW_REPAIR_IN[13];
            Fuse[0] : ROW_REPAIR_IN[14];
            Fuse[1] : ROW_REPAIR_IN[15];
            Fuse[2] : ROW_REPAIR_IN[16];
            Fuse[3] : ROW_REPAIR_IN[17];
            Fuse[4] : ROW_REPAIR_IN[18];
            Fuse[5] : ROW_REPAIR_IN[19];
            Fuse[6] : ROW_REPAIR_IN[20];
            Fuse[7] : ROW_REPAIR_IN[21];
          }
        }
    }

  }

}

