// =====================================================================================================
// FileName          : JtagBfmTypes.svh
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Mon Apr  6 17:42:30 CDT 2015
// Last Modified     :
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// Common defines/types for SIP-compatibility
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef JTAGBFMTYPES_SVH
`define JTAGBFMTYPES_SVH

typedef enum bit[3:0] {
                       TLRS = 4'b0000,  // Test Logic Reset State
                       RUTI = 4'b1000,  // Run test Idle State
                       SDRS = 4'b0001,  // Select DR Scan State
                       CADR = 4'b0010,  // Capture DR State
                       SHDR = 4'b0011,  // Shift DR State
                       E1DR = 4'b0100,  // Exit1 DR State
                       PADR = 4'b0101,  // Pause DR State
                       E2DR = 4'b0110,  // Exit2 DR State
                       UPDR = 4'b0111,  // Update DR State
                       SIRS = 4'b1001,  // Select IR Scan State
                       CAIR = 4'b1010,  // Capture IR State
                       SHIR = 4'b1011,  // Shift IR State
                       E1IR = 4'b1100,  // Exit1 IR State
                       PAIR = 4'b1101,  // Pause IR State
                       E2IR = 4'b1110,  // Exit2 IR State
                       UPIR = 4'b1111   // Update IR State
                       } fsm_state_test;

dfx_tapfsm_state_e TapStateTranslation[fsm_state_test] = '{
  TLRS : DFX_TAP_TS_TLR,
  RUTI : DFX_TAP_TS_RTI,
  SDRS : DFX_TAP_TS_SELECT_DR,
  CADR : DFX_TAP_TS_CAPTURE_DR,
  SHDR : DFX_TAP_TS_SHIFT_DR,
  E1DR : DFX_TAP_TS_EXIT1_DR,
  PADR : DFX_TAP_TS_PAUSE_DR,
  E2DR : DFX_TAP_TS_EXIT2_DR,
  UPDR : DFX_TAP_TS_UPDATE_DR,
  SIRS : DFX_TAP_TS_SELECT_IR,
  CAIR : DFX_TAP_TS_CAPTURE_IR,
  SHIR : DFX_TAP_TS_SHIFT_IR,
  E1IR : DFX_TAP_TS_EXIT1_IR,
  PAIR : DFX_TAP_TS_PAUSE_IR,
  E2IR : DFX_TAP_TS_EXIT2_IR,
  UPIR : DFX_TAP_TS_UPDATE_IR
};

fsm_state_test TapStateTranslation_1[dfx_tapfsm_state_e] = '{
  DFX_TAP_TS_TLR : TLRS,
  DFX_TAP_TS_RTI : RUTI,
  DFX_TAP_TS_SELECT_DR : SDRS,
  DFX_TAP_TS_CAPTURE_DR : CADR,
  DFX_TAP_TS_SHIFT_DR : SHDR,
  DFX_TAP_TS_EXIT1_DR : E1DR,
  DFX_TAP_TS_PAUSE_DR : PADR,
  DFX_TAP_TS_EXIT2_DR : E2DR,
  DFX_TAP_TS_UPDATE_DR : UPDR,
  DFX_TAP_TS_SELECT_IR : SIRS,
  DFX_TAP_TS_CAPTURE_IR : CAIR,
  DFX_TAP_TS_SHIFT_IR : SHIR,
  DFX_TAP_TS_EXIT1_IR : E1IR,
  DFX_TAP_TS_PAUSE_IR : PAIR,
  DFX_TAP_TS_EXIT2_IR : E2IR,
  DFX_TAP_TS_UPDATE_IR : UPIR
};

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
    `ovm_field_int (actual_tdo_collected,OVM_ALL_ON)
    `ovm_field_int (clk_gating_off,OVM_ALL_ON)
    `ovm_object_utils_end

endclass : JtagBfmSeqDrvPkt

typedef dfx_tap_unit_e Tap_t;

`endif // `ifndef JTAGBFMTYPES_SVH
