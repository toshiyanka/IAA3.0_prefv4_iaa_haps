//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
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
//
//  Collateral Description:
//  dteg-jtag_bfm
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  CHASSIS_JTAGBFM_2020WW16_R4.1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : JtagBfmSeqDrvPkt.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//
//
//    PURPOSE     : Packet Between the Sequencer and the Driver
//    DESCRIPTION : This is the Packet between the Sequencer and the
//                  driver. The feilds that are passed by the sequencer
//                  are :
//                  Address/Instruction to Drive
//                  Data
//                  Reset Mode
//                  Function Select
//----------------------------------------------------------------------
// Revision History : : Fixed HSD 2901749
//----------------------------------------------------------------------

`ifndef INC_JtagBfmSeqDrvPkt
 `define INC_JtagBfmSeqDrvPkt 

//----------------------------------------------------------------------
// ENUM DECLARATIONS
//------------------------------------------------------------------------
typedef enum bit[1:0]  {
                 NO_RST      = 2'b00,
                 RST_HARD    = 2'b01,
                 RST_SOFT    = 2'b10,
                 RST_PWRGUD  = 2'b11
               } ResetMode_t;

typedef enum bit[3:0] {    
                ST_TLRS = 4'b0000,  // Test Logic Reset State
                ST_RUTI = 4'b1000,  // Run test Idle State
                ST_SDRS = 4'b0001,  // Select DR Scan State
                ST_CADR = 4'b0010,  // Capture DR State
                ST_SHDR = 4'b0011,  // Shift DR State
                ST_E1DR = 4'b0100,  // Exit1 DR State
                ST_PADR = 4'b0101,  // Pause DR State
                ST_E2DR = 4'b0110,  // Exit2 DR State
                ST_UPDR = 4'b0111,  // Update DR State
                ST_SIRS = 4'b1001,  // Select IR Scan State
                ST_CAIR = 4'b1010,  // Capture IR State
                ST_SHIR = 4'b1011,  // Shift IR State
                ST_E1IR = 4'b1100,  // Exit1 IR State
                ST_PAIR = 4'b1101,  // Pause IR State
                ST_E2IR = 4'b1110,  // Exit2 IR State
                ST_UPIR = 4'b1111   // Update IR State
              } fsm_state_t;

typedef enum bit [2:0] {
                RESET_TASK      = 3'b000,
                GOTO_TASK       = 3'b001,
                LOAD_IR         = 3'b010,
                REG_ACCESS      = 3'b011,
                TMS_TDI_STREAM  = 3'b100,
                IDLE_TASK       = 3'b101,
                MULTI_TAP_RA    = 3'b110,
                LOAD_DR         = 3'b111
                } FunctionSelect_t;

   parameter PKT_SIZE_OF_IR_REG            = 4096;
`ifndef OVM_MAX_STREAMBITS
   parameter PKT_TOTAL_DATA_REGISTER_WIDTH = 4096;
   //parameter PKT_SIZE_OF_IR_REG            = 4096;
`else
   parameter PKT_TOTAL_DATA_REGISTER_WIDTH = `OVM_MAX_STREAMBITS;
   //parameter PKT_SIZE_OF_IR_REG            = `OVM_MAX_STREAMBITS;
`endif

class JtagBfmSeqDrvPkt extends ovm_sequence_item;

    //--------------------------------------------------------
    // Local Declarations
    //--------------------------------------------------------
    rand logic [PKT_SIZE_OF_IR_REG-1:0]              Address;
    rand logic [PKT_TOTAL_DATA_REGISTER_WIDTH-1:0]   Data;
    rand ResetMode_t                             ResetMode;
    rand FunctionSelect_t                        FunctionSelect;
    rand logic [1:0]                             Extended_FunctionSelect;
    rand int                                     addr_len;
    rand int                                     data_len;
    rand int                                     pause_len;
    rand int                                     Count;
    rand logic [PKT_TOTAL_DATA_REGISTER_WIDTH-1:0]   TMS_Stream;
    rand logic [PKT_TOTAL_DATA_REGISTER_WIDTH-1:0]   TDI_Stream;    
    rand logic [PKT_SIZE_OF_IR_REG-1:0]              Expected_Address;
    rand logic [PKT_TOTAL_DATA_REGISTER_WIDTH-1:0]   Expected_Data;
    rand logic [PKT_SIZE_OF_IR_REG-1:0]              Mask_Address;
    rand logic [PKT_TOTAL_DATA_REGISTER_WIDTH-1:0]   Mask_Data;
    rand logic [PKT_TOTAL_DATA_REGISTER_WIDTH-1:0]   Mask_Capture;
    rand logic [PKT_TOTAL_DATA_REGISTER_WIDTH-1:0]   actual_tdo_collected;
    rand logic                                   clk_gating_off;

    // Constructor
    function new(string name                  = "JtagBfmSeqDrvPkt",
                 ovm_sequencer_base sequencer = null,
                 ovm_sequence_base parent_seq = null);
        super.new(name,sequencer, parent_seq);
    endfunction : new

    // Register component with Factory
    `ovm_object_utils_begin(JtagBfmSeqDrvPkt)
    `ovm_field_int  (Address,OVM_ALL_ON)
    `ovm_field_int  (Data,OVM_ALL_ON)
    `ovm_field_enum (ResetMode_t,ResetMode,OVM_ALL_ON)
    `ovm_field_enum (FunctionSelect_t,FunctionSelect,OVM_ALL_ON)
    `ovm_field_int  (Extended_FunctionSelect,OVM_ALL_ON)
    `ovm_field_int  (addr_len,OVM_ALL_ON)
    `ovm_field_int  (data_len,OVM_ALL_ON)
    `ovm_field_int  (pause_len,OVM_ALL_ON)
    `ovm_field_int  (Count,OVM_ALL_ON)
    `ovm_field_int  (TMS_Stream,OVM_ALL_ON)
    `ovm_field_int  (TDI_Stream,OVM_ALL_ON)        
    `ovm_field_int  (Expected_Address,OVM_ALL_ON)
    `ovm_field_int  (Expected_Data,OVM_ALL_ON)
    `ovm_field_int  (Mask_Address,OVM_ALL_ON)
    `ovm_field_int  (Mask_Data,OVM_ALL_ON)
    `ovm_field_int  (Mask_Capture,OVM_ALL_ON)
    `ovm_field_int (actual_tdo_collected,OVM_ALL_ON)
    `ovm_field_int (clk_gating_off,OVM_ALL_ON)
    `ovm_object_utils_end

endclass : JtagBfmSeqDrvPkt
`endif // INC_JtagBfmSeqDrvPkt
