// =====================================================================================================
// FileName          : dfx_tap_stap11_v1_0.sv
// Primary Contact   : Pankaj Sharma
// Secondary Contact : Pinchas Lange / Roee Saroosi
// Creation Date     : Tue Jan 1 2013
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// STAP11 BFM Class
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_STAP11_V1_0_SV
`define DFX_TAP_STAP11_V1_0_SV

class dfx_tap_stap11 extends dfx_tap_any;
  `ovm_object_utils_begin(dfx_tap_stap11)
    `ovm_field_int(IR_length, OVM_DEFAULT | OVM_DEC)
  `ovm_object_utils_end

  // TAP instructions
  //
  typedef enum tap_ir_t {
    SLVIDCODE = 'h0c,
    TAPC_SELECT = 'h11,
    TAPC_SEL_SEC = 'h10,
    TAPC_REMOVE = 'h14,
    BYPASS = 'hff
  } ir_code_e;

  // Associative array of data lengths for all TAP instructions
  //
  static const int _dr_length[ir_code_e] = '{
    SLVIDCODE : 32,
    TAPC_SELECT : 18, // TODO: Change size accordingly
    TAPC_SEL_SEC : 9, // TODO: Change size accordingly
    TAPC_REMOVE : 1,
    BYPASS : 1
  };

  function new(string name = "dfx_tap_stap11");
    super.new(name);

    IR_length = 8;
    wait_cycles = 12;
  endfunction : new

  function void set_idcode_value;
    IDCODE_VALUE = 32'hC0DE_1101;
  endfunction : set_idcode_value

  virtual function tap_ir_t opcode_value(string opcode_str);

    case (opcode_str)
      "SLVIDCODE": opcode_value = SLVIDCODE;
      "TAPC_SELECT": opcode_value = TAPC_SELECT;
      "TAPC_SEL_SEC": opcode_value = TAPC_SEL_SEC;
      "TAPC_REMOVE": opcode_value = TAPC_REMOVE;
      "BYPASS": opcode_value = BYPASS;
      default: `ovm_error(get_type_name(), "Invalid OPCODE string") // opcode_value = tap_ir_t'(0);
    endcase // case (opcode_str)

  endfunction : opcode_value

  `dr_functions

endclass : dfx_tap_stap11

`endif // `ifndef DFX_TAP_STAP11_V1_0_SV
