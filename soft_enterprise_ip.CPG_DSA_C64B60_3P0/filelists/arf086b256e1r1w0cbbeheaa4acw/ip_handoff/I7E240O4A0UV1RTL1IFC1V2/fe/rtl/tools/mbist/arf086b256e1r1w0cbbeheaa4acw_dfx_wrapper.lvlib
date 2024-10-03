
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


MemoryTemplate (arf086b256e1r1w0cbbeheaa4acw_dfx_wrapper) {

  CellName              : arf086b256e1r1w0cbbeheaa4acw_dfx_wrapper;
  MemoryType            : SRAM;
  LogicalPorts          : 1R1W;    //1R1W0C
  NumberofWords         : 256;
  NumberofBits          : 86;
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
        RowAddress[7:0] : Address[7:0];
      }
    }
    Function (RowAddress) {
      CountRange[255:0];  //Encoded Address
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


  Port ( FUNC_WR_ADDR_IN_P0[7:0] ) {
    LogicalPort: Write_Ports_0;
    Direction:   Input;
    Function:    Address;
    EmbeddedTestLogic {
      TestInput: BIST_WR_ADDR_IN_P0[7:0];
    }
  }

  Port ( FUNC_WR_DATA_IN_P0[85:0] ) {
    LogicalPort: Write_Ports_0;
    Direction:   Input;
    Function:    Data;
    EmbeddedTestLogic {
      TestInput: BIST_WR_DATA_IN_P0[85:0];
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


  Port ( FUNC_RD_ADDR_IN_P0[7:0] ) {
    LogicalPort: Read_Ports_0;
    Direction:   Input;
    Function:    Address;
    EmbeddedTestLogic {
      TestInput: BIST_RD_ADDR_IN_P0[7:0];
    }
  }

  Port ( DATA_OUT_P0[85:0] ) {
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
      ShiftedIORange : DATA_OUT_P0[85:0] ;
      FuseSet {
        FuseMap[6:0] {
          ShiftedIO(DATA_OUT_P0[0]) : 7'b0000000;
          ShiftedIO(DATA_OUT_P0[1]) : 7'b0000001;
          ShiftedIO(DATA_OUT_P0[2]) : 7'b0000010;
          ShiftedIO(DATA_OUT_P0[3]) : 7'b0000011;
          ShiftedIO(DATA_OUT_P0[4]) : 7'b0000100;
          ShiftedIO(DATA_OUT_P0[5]) : 7'b0000101;
          ShiftedIO(DATA_OUT_P0[6]) : 7'b0000110;
          ShiftedIO(DATA_OUT_P0[7]) : 7'b0000111;
          ShiftedIO(DATA_OUT_P0[8]) : 7'b0001000;
          ShiftedIO(DATA_OUT_P0[9]) : 7'b0001001;
          ShiftedIO(DATA_OUT_P0[10]) : 7'b0001010;
          ShiftedIO(DATA_OUT_P0[11]) : 7'b0001011;
          ShiftedIO(DATA_OUT_P0[12]) : 7'b0001100;
          ShiftedIO(DATA_OUT_P0[13]) : 7'b0001101;
          ShiftedIO(DATA_OUT_P0[14]) : 7'b0001110;
          ShiftedIO(DATA_OUT_P0[15]) : 7'b0001111;
          ShiftedIO(DATA_OUT_P0[16]) : 7'b0010000;
          ShiftedIO(DATA_OUT_P0[17]) : 7'b0010001;
          ShiftedIO(DATA_OUT_P0[18]) : 7'b0010010;
          ShiftedIO(DATA_OUT_P0[19]) : 7'b0010011;
          ShiftedIO(DATA_OUT_P0[20]) : 7'b0010100;
          ShiftedIO(DATA_OUT_P0[21]) : 7'b0010101;
          ShiftedIO(DATA_OUT_P0[22]) : 7'b0010110;
          ShiftedIO(DATA_OUT_P0[23]) : 7'b0010111;
          ShiftedIO(DATA_OUT_P0[24]) : 7'b0011000;
          ShiftedIO(DATA_OUT_P0[25]) : 7'b0011001;
          ShiftedIO(DATA_OUT_P0[26]) : 7'b0011010;
          ShiftedIO(DATA_OUT_P0[27]) : 7'b0011011;
          ShiftedIO(DATA_OUT_P0[28]) : 7'b0011100;
          ShiftedIO(DATA_OUT_P0[29]) : 7'b0011101;
          ShiftedIO(DATA_OUT_P0[30]) : 7'b0011110;
          ShiftedIO(DATA_OUT_P0[31]) : 7'b0011111;
          ShiftedIO(DATA_OUT_P0[32]) : 7'b0100000;
          ShiftedIO(DATA_OUT_P0[33]) : 7'b0100001;
          ShiftedIO(DATA_OUT_P0[34]) : 7'b0100010;
          ShiftedIO(DATA_OUT_P0[35]) : 7'b0100011;
          ShiftedIO(DATA_OUT_P0[36]) : 7'b0100100;
          ShiftedIO(DATA_OUT_P0[37]) : 7'b0100101;
          ShiftedIO(DATA_OUT_P0[38]) : 7'b0100110;
          ShiftedIO(DATA_OUT_P0[39]) : 7'b0100111;
          ShiftedIO(DATA_OUT_P0[40]) : 7'b0101000;
          ShiftedIO(DATA_OUT_P0[41]) : 7'b0101001;
          ShiftedIO(DATA_OUT_P0[42]) : 7'b0101010;
          ShiftedIO(DATA_OUT_P0[43]) : 7'b0101011;
          ShiftedIO(DATA_OUT_P0[44]) : 7'b0101100;
          ShiftedIO(DATA_OUT_P0[45]) : 7'b0101101;
          ShiftedIO(DATA_OUT_P0[46]) : 7'b0101110;
          ShiftedIO(DATA_OUT_P0[47]) : 7'b0101111;
          ShiftedIO(DATA_OUT_P0[48]) : 7'b0110000;
          ShiftedIO(DATA_OUT_P0[49]) : 7'b0110001;
          ShiftedIO(DATA_OUT_P0[50]) : 7'b0110010;
          ShiftedIO(DATA_OUT_P0[51]) : 7'b0110011;
          ShiftedIO(DATA_OUT_P0[52]) : 7'b0110100;
          ShiftedIO(DATA_OUT_P0[53]) : 7'b0110101;
          ShiftedIO(DATA_OUT_P0[54]) : 7'b0110110;
          ShiftedIO(DATA_OUT_P0[55]) : 7'b0110111;
          ShiftedIO(DATA_OUT_P0[56]) : 7'b0111000;
          ShiftedIO(DATA_OUT_P0[57]) : 7'b0111001;
          ShiftedIO(DATA_OUT_P0[58]) : 7'b0111010;
          ShiftedIO(DATA_OUT_P0[59]) : 7'b0111011;
          ShiftedIO(DATA_OUT_P0[60]) : 7'b0111100;
          ShiftedIO(DATA_OUT_P0[61]) : 7'b0111101;
          ShiftedIO(DATA_OUT_P0[62]) : 7'b0111110;
          ShiftedIO(DATA_OUT_P0[63]) : 7'b0111111;
          ShiftedIO(DATA_OUT_P0[64]) : 7'b1000000;
          ShiftedIO(DATA_OUT_P0[65]) : 7'b1000001;
          ShiftedIO(DATA_OUT_P0[66]) : 7'b1000010;
          ShiftedIO(DATA_OUT_P0[67]) : 7'b1000011;
          ShiftedIO(DATA_OUT_P0[68]) : 7'b1000100;
          ShiftedIO(DATA_OUT_P0[69]) : 7'b1000101;
          ShiftedIO(DATA_OUT_P0[70]) : 7'b1000110;
          ShiftedIO(DATA_OUT_P0[71]) : 7'b1000111;
          ShiftedIO(DATA_OUT_P0[72]) : 7'b1001000;
          ShiftedIO(DATA_OUT_P0[73]) : 7'b1001001;
          ShiftedIO(DATA_OUT_P0[74]) : 7'b1001010;
          ShiftedIO(DATA_OUT_P0[75]) : 7'b1001011;
          ShiftedIO(DATA_OUT_P0[76]) : 7'b1001100;
          ShiftedIO(DATA_OUT_P0[77]) : 7'b1001101;
          ShiftedIO(DATA_OUT_P0[78]) : 7'b1001110;
          ShiftedIO(DATA_OUT_P0[79]) : 7'b1001111;
          ShiftedIO(DATA_OUT_P0[80]) : 7'b1010000;
          ShiftedIO(DATA_OUT_P0[81]) : 7'b1010001;
          ShiftedIO(DATA_OUT_P0[82]) : 7'b1010010;
          ShiftedIO(DATA_OUT_P0[83]) : 7'b1010011;
          ShiftedIO(DATA_OUT_P0[84]) : 7'b1010100;
          ShiftedIO(DATA_OUT_P0[85]) : 7'b1010101;
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
          FuseMap[6]: COL_REPAIR_IN[7];
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
        Fuse[6] : AddressPort(FUNC_RD_ADDR_IN_P0[6]);
        Fuse[7] : AddressPort(FUNC_RD_ADDR_IN_P0[7]);
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
          Fuse[6]: ROW_REPAIR_IN[7];
          Fuse[7]: ROW_REPAIR_IN[8];
        }
      }
    }
  } 

} //end MemoryTemplate (arf086b256e1r1w0cbbeheaa4acw_dfx_wrapper)