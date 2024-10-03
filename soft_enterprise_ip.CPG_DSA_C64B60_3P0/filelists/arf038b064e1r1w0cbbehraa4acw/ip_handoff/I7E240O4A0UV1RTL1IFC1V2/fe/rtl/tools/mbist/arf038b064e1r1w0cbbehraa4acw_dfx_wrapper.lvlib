
//  INTEL CONFIDENTIAL
//
//  Copyright 2023 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code ("Material") are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//

//------------------------------------------------------------------------------------------------------------------------
// Intel Proprietary        Intel Confidential        Intel Proprietary        Intel Confidential        Intel Proprietary
//------------------------------------------------------------------------------------------------------------------------
// Generated by                  : cudoming
// Generated on                  : April 18, 2023
//------------------------------------------------------------------------------------------------------------------------
// General Information:
// ------------------------------
// 1r1w0c standard array DFX wrapper for SDG server designs.
// Synthesizable RTL for array DFX wrapper.
// RTL is written in SystemVerilog.
//------------------------------------------------------------------------------------------------------------------------
// Detail Information:
// ------------------------------
// Addresses        : RD/WR addresses are encoded.
//                    Input addresses will be valid at the array in 1 phases after being driven.
//                    Address latency of 1 is corresponding to a B-latch.
// Enables          : RD/WR enables are used to condition the clock and wordlines.
//                  : Input enables will be valid at the array in 1 phases after being driven.
//                    Enable latency of 1 is corresponding to a B-latch.
// Write Data       : Write data will be valid at the array 2 phases after being driven.
//                    Write data latency of 2 is corresponding to a rising-edge flop. 
// Read Data        : Read data will be valid at the output of a SDL 1 phase after being read.
//                    Read data latency of 1 is corresponding to a B-latch.
// Address Offset   : 
//------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------
// Other Information:
// ------------------------------
// SDG RFIP RTL Release Path:
// /p/hdk/rtl/ip_releases/shdk74/array_macro_module
//
//------------------------------------------------------------------------------------------------------------------------


MemoryTemplate (arf038b064e1r1w0cbbehraa4acw_dfx_wrapper) {

  CellName              : arf038b064e1r1w0cbbehraa4acw_dfx_wrapper;
  MemoryType            : SRAM;
  LogicalPorts          : 1R1W;    //1R1W0C
  NumberofWords         : 64;
  NumberofBits          : 38;
  //BitGrouping           : 1;
  Algorithm             : IntelLVMarchCMinusFx;
  OperationSet          : SyncCustom;
  ConcurrentRead        : Off;
  ConcurrentWrite       : On;
  ShadowRead            : On;
  ShadowWrite           : Off;
  MinHold               : 0.00;
  DataOutStage          : None;
  InternalScanLogic     : On;
  ObservationLogic      : Off;
  TransparentMode       : None;
  
  //ArrayType            : Standard Array;
  //ReadPhase            : Phase A;
  //WritePhase           : Phase A;
  //AddressDecoding      : Encoded Address;
  //RedundantColumns     : 1;
  //RedundantRows        : 1;


  AddressCounter {
    Function (Address) {
      LogicalAddressMap {
        RowAddress[5:0] : Address[5:0];
      }
    }
    Function (RowAddress) {
      CountRange[63:0];  //Encoded Address
    }
  }

 
  Port ( FUNC_WR_CLK_IN_P0 ) {
    LogicalPort: Write_Ports_0;
    Direction:   Input;
    Function:    Clock;
    Polarity:    ActiveHigh;
    EmbeddedTestLogic {
      TestInput: BIST_WR_CLK_IN_P0;
    }
  }

  Port ( FUNC_WR_EN_IN_P0 ) {
    LogicalPort: Write_Ports_0;
    Direction:   Input;
    Function:    WriteEnable;
    DisableDuringScan: Off;
    Polarity:    ActiveHigh;
    EmbeddedTestLogic {
      TestInput: BIST_WR_EN_IN_P0;
    }
  }


  Port ( FUNC_WR_ADDR_IN_P0[5:0] ) {
    LogicalPort: Write_Ports_0;
    Direction:   Input;
    Function:    Address;
    EmbeddedTestLogic {
      TestInput: BIST_WR_ADDR_IN_P0[5:0];
    }
  }

  Port ( FUNC_WR_DATA_IN_P0[37:0] ) {
    LogicalPort: Write_Ports_0;
    Direction:   Input;
    Function:    Data;
    EmbeddedTestLogic {
      TestInput: BIST_WR_DATA_IN_P0[37:0];
    }
  }

  Port ( WRAPPER_WR_CLK_EN_P0 ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveHigh;
    SafeValue:   1;
  }

  Port ( GLOBAL_RROW_EN_IN_WR_P0)  { 
    Direction: Input; 
    Function: None; 
    Polarity: ActiveHigh;
    SafeValue: 1'b0;
  }

   
 
  Port ( FUNC_RD_CLK_IN_P0 ) {
    LogicalPort: Read_Ports_0;
    Direction:   Input;
    Function:    Clock;
    Polarity:    ActiveHigh;
    EmbeddedTestLogic {
      TestInput: BIST_RD_CLK_IN_P0;
    }
  }

  Port ( FUNC_RD_EN_IN_P0 ) {
    LogicalPort: Read_Ports_0;
    Direction:   Input;
    Function:    ReadEnable;
    DisableDuringScan: Off;
    Polarity:    ActiveHigh;
    EmbeddedTestLogic {
      TestInput: BIST_RD_EN_IN_P0;
    }
  }


  Port ( FUNC_RD_ADDR_IN_P0[5:0] ) {
    LogicalPort: Read_Ports_0;
    Direction:   Input;
    Function:    Address;
    EmbeddedTestLogic {
      TestInput: BIST_RD_ADDR_IN_P0[5:0];
    }
  }

  Port ( DATA_OUT_P0[37:0] ) {
    LogicalPort: Read_Ports_0;
    Direction:   Output;
    Function:    Data;
  }

  Port ( OUTPUT_RESET_P0 ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveHigh;
    SafeValue:   0;
  }

  
   Port ( WRAPPER_RD_CLK_EN_P0 ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveHigh;
    SafeValue:   1;
  } 

  Port ( GLOBAL_RROW_EN_IN_RD_P0)  { 
    Direction: Input; 
    Function: None; 
    Polarity: ActiveHigh;
    SafeValue: 1'b0; 
  } 



  Port ( BIST_ENABLE ) {
    Direction:   Input;
    Function:    BistEn;
    Polarity:    ActiveHigh;
  }

  Port ( flcp_fd[2:0] ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveHigh;
    SafeValue:   3'b000;
  }

  Port ( flcp_rd[2:0] ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveHigh;
    SafeValue:   3'b000;
  }


  Port ( IP_RESET_B ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveLow;
    SafeValue:   1'b1;
  }
  
  Port ( COL_REPAIR_IN[12:0] ) {
    Direction:   Input;
    Function:    BisrParallelData;
    Polarity:    ActiveHigh;
    
  }

  Port ( ROW_REPAIR_IN[12:0] ) {
    Direction:   Input;
    Function:    BisrParallelData;
    Polarity:    ActiveHigh;
    
  }

  Port ( FSCAN_RAM_RDIS_B ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveLow;
    SafeValue:   1;
  }

  Port ( FSCAN_RAM_WDIS_B ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveLow;
    SafeValue:   1;
  }
  

  Port ( FSCAN_RAM_INIT_EN ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveHigh;
    SafeValue:   0;
  }

  Port ( FSCAN_RAM_INIT_VAL ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveHigh;
    SafeValue:   0;
  }

  Port ( FSCAN_RAM_BYPSEL ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveHigh;
    SafeValue:   0;
  }

  Port ( FSCAN_CLKUNGATE ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveHigh;
    SafeValue:   0;
  }

  Port ( ISOLATION_CONTROL_IN ) {
    Direction: Input;
    Function: None;
    Polarity: ActiveHigh;
    Safevalue: 1'b0;
  }

  Port ( ARRAY_FREEZE ) {
    Direction: Input;
    Function: None;
    Polarity: ActiveHigh;
    Safevalue: 1'b0;
  }

  Port ( SLEEP_FUSE_IN ) {
    Direction: Input;
    Function: None;
    Polarity: ActiveHigh;
    Safevalue: 1'b0;
  }

  Port ( TRIM_FUSE_IN[19:0] ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveHigh;
    SafeValue:   20'b00000000000000000000;
  }

  Port ( PWR_MGMT_IN[3:0] ) {
    Direction:   Input;
    Function:    None;
    Polarity:    ActiveHigh;
    SafeValue:   4'b0000;
  }

  Port ( PWR_MGMT_OUT[3:0] ) {
    Direction:   Output;
    Function:    None;
    Polarity:    ActiveHigh;
  }

 
//----- Start of Redundancy Analysis Segment -------------

  RedundancyAnalysis { 
    
    ColumnSegment(All) {
      NumberOfSpareElements : 1;
      ShiftedIORange : DATA_OUT_P0[37:0] ;
      FuseSet {
        FuseMap[5:0] {
          ShiftedIO(DATA_OUT_P0[0]) : 6'b000000;
          ShiftedIO(DATA_OUT_P0[1]) : 6'b000001;
          ShiftedIO(DATA_OUT_P0[2]) : 6'b000010;
          ShiftedIO(DATA_OUT_P0[3]) : 6'b000011;
          ShiftedIO(DATA_OUT_P0[4]) : 6'b000100;
          ShiftedIO(DATA_OUT_P0[5]) : 6'b000101;
          ShiftedIO(DATA_OUT_P0[6]) : 6'b000110;
          ShiftedIO(DATA_OUT_P0[7]) : 6'b000111;
          ShiftedIO(DATA_OUT_P0[8]) : 6'b001000;
          ShiftedIO(DATA_OUT_P0[9]) : 6'b001001;
          ShiftedIO(DATA_OUT_P0[10]) : 6'b001010;
          ShiftedIO(DATA_OUT_P0[11]) : 6'b001011;
          ShiftedIO(DATA_OUT_P0[12]) : 6'b001100;
          ShiftedIO(DATA_OUT_P0[13]) : 6'b001101;
          ShiftedIO(DATA_OUT_P0[14]) : 6'b001110;
          ShiftedIO(DATA_OUT_P0[15]) : 6'b001111;
          ShiftedIO(DATA_OUT_P0[16]) : 6'b010000;
          ShiftedIO(DATA_OUT_P0[17]) : 6'b010001;
          ShiftedIO(DATA_OUT_P0[18]) : 6'b010010;
          ShiftedIO(DATA_OUT_P0[19]) : 6'b010011;
          ShiftedIO(DATA_OUT_P0[20]) : 6'b010100;
          ShiftedIO(DATA_OUT_P0[21]) : 6'b010101;
          ShiftedIO(DATA_OUT_P0[22]) : 6'b010110;
          ShiftedIO(DATA_OUT_P0[23]) : 6'b010111;
          ShiftedIO(DATA_OUT_P0[24]) : 6'b011000;
          ShiftedIO(DATA_OUT_P0[25]) : 6'b011001;
          ShiftedIO(DATA_OUT_P0[26]) : 6'b011010;
          ShiftedIO(DATA_OUT_P0[27]) : 6'b011011;
          ShiftedIO(DATA_OUT_P0[28]) : 6'b011100;
          ShiftedIO(DATA_OUT_P0[29]) : 6'b011101;
          ShiftedIO(DATA_OUT_P0[30]) : 6'b011110;
          ShiftedIO(DATA_OUT_P0[31]) : 6'b011111;
          ShiftedIO(DATA_OUT_P0[32]) : 6'b100000;
          ShiftedIO(DATA_OUT_P0[33]) : 6'b100001;
          ShiftedIO(DATA_OUT_P0[34]) : 6'b100010;
          ShiftedIO(DATA_OUT_P0[35]) : 6'b100011;
          ShiftedIO(DATA_OUT_P0[36]) : 6'b100100;
          ShiftedIO(DATA_OUT_P0[37]) : 6'b100101;
        }
      }
      PinMap {
        SpareElement {
          RepairEnable:COL_REPAIR_IN[0];
          FuseMap[0]: COL_REPAIR_IN[1];
          FuseMap[1]: COL_REPAIR_IN[2];
          FuseMap[2]: COL_REPAIR_IN[3];
          FuseMap[3]: COL_REPAIR_IN[4];
          FuseMap[4]: COL_REPAIR_IN[5];
          FuseMap[5]: COL_REPAIR_IN[6];
        }
      }
    }  
//--------------------ROW Repair-----------------//
    
    RowSegment(ALL) {
      NumberOfSpareElements : 1;
      FuseSet {
        Fuse[0] : AddressPort(FUNC_RD_ADDR_IN_P0[0]);
        Fuse[1] : AddressPort(FUNC_RD_ADDR_IN_P0[1]);
        Fuse[2] : AddressPort(FUNC_RD_ADDR_IN_P0[2]);
        Fuse[3] : AddressPort(FUNC_RD_ADDR_IN_P0[3]);
        Fuse[4] : AddressPort(FUNC_RD_ADDR_IN_P0[4]);
        Fuse[5] : AddressPort(FUNC_RD_ADDR_IN_P0[5]);
      }
      PinMap {
        SpareElement {
          RepairEnable:ROW_REPAIR_IN[0];
          Fuse[0]: ROW_REPAIR_IN[1];
          Fuse[1]: ROW_REPAIR_IN[2];
          Fuse[2]: ROW_REPAIR_IN[3];
          Fuse[3]: ROW_REPAIR_IN[4];
          Fuse[4]: ROW_REPAIR_IN[5];
          Fuse[5]: ROW_REPAIR_IN[6];
        }
      }
    }
  } 

} //end MemoryTemplate (arf038b064e1r1w0cbbehraa4acw_dfx_wrapper)