// =====================================================================================================
// FileName          : dfx_tap_base_sequences.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Thu Jul 29 14:39:05 CDT 2010
// Modification Date : Tue Nov 11 18:10:41 CST 2014
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx TAP base sequences that can be used by other sequences
//
// Each sequence issues one transaction.
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_BASE_SEQUENCES_SV
`define DFX_TAP_BASE_SEQUENCES_SV

`define dfx_tap_single_tap_X_sequence_definitions \
  rand dfx_tap_unit_e seq_tap; \
  rand tap_ir_t seq_ir_in; \
  tap_ir_t seq_ir_out; \
  rand dfx_node_t seq_dr_in[]; \
  dfx_node_t seq_dr_out[];

`define dfx_tap_single_tap_X_sequence_fields \
  `ovm_field_enum(dfx_tap_unit_e, seq_tap, OVM_DEFAULT) \
  `ovm_field_int(seq_ir_in, OVM_DEFAULT) \
  `ovm_field_array_int(seq_dr_in, OVM_DEFAULT) \
  `ovm_field_int(seq_ir_out, OVM_DEFAULT) \
  `ovm_field_array_int(seq_dr_out, OVM_DEFAULT)

`define dfx_tap_single_tap_X_sequence_body_task \
  task body(); \
    string s; \
    `ovm_do_with(req, {tap_u == seq_tap; ir_in == seq_ir_in; \
                       dr_in.size() == seq_dr_in.size(); \
                       foreach (dr_in[i]) dr_in[i] == seq_dr_in[i];}) \
    seq_ir_out = req.ir_out; \
    seq_dr_out = req.ttd_out; \
    $sformat(s, "Response to instruction scan of 'h%0h on TAP %s: 'h%0h", \
             seq_ir_in, seq_tap.name(), seq_ir_out); \
    /* `ovm_info(get_type_name(), s, OVM_NONE) */ \
    `ovm_info(get_type_name(), s, OVM_NONE) \
    s = {"Response to data scan on TAP ", seq_tap.name(), " is stream: ", dfx_tap_util::writeh(seq_dr_out)}; \
    /* `ovm_info(get_type_name(), s, OVM_HIGH) */ \
    `ovm_info(get_type_name(), s, OVM_NONE) \
  endtask : body

class dfx_tap_single_tap_sequence extends ovm_sequence #(dfx_tap_single_tap_transaction);

  `dfx_tap_single_tap_X_sequence_definitions

  `ovm_object_utils_begin(dfx_tap_single_tap_sequence)
    `dfx_tap_single_tap_X_sequence_fields
  `ovm_object_utils_end

  `ovm_declare_p_sequencer(dfx_tap_sequencer)

  function new(string name = "dfx_tap_single_tap_sequence");
    super.new(name);
  endfunction : new

  `dfx_tap_single_tap_X_sequence_body_task

endclass : dfx_tap_single_tap_sequence

class dfx_tap_single_tap_data_only_sequence extends ovm_sequence #(dfx_tap_single_tap_data_only_transaction);

  `dfx_tap_single_tap_X_sequence_definitions

  `ovm_object_utils_begin(dfx_tap_single_tap_data_only_sequence)
    `dfx_tap_single_tap_X_sequence_fields
  `ovm_object_utils_end

  `ovm_declare_p_sequencer(dfx_tap_sequencer)

  function new(string name = "dfx_tap_single_tap_data_only_sequence");
    super.new(name);
  endfunction : new

  `dfx_tap_single_tap_X_sequence_body_task

endclass : dfx_tap_single_tap_data_only_sequence

`define dfx_tap_multiple_taps_X_sequence_definitions \
  rand tap_ir_t seq_ir_in[dfx_tap_unit_e]; \
  tap_ir_t seq_ir_out[dfx_tap_unit_e]; \
  dfx_node_ary_t seq_dr_in[dfx_tap_unit_e]; \
  dfx_node_ary_t seq_dr_out[dfx_tap_unit_e];

`define dfx_tap_multiple_taps_X_sequence_definitions_b \
  dfx_node_ary_t seq_ir_in_l[dfx_tap_unit_e]; \
  string ir_name[dfx_tap_unit_e]; \
  dfx_node_ary_t seq_ir_pr_in; \
  dfx_node_ary_t seq_ir_pr_out; \
  dfx_node_ary_t seq_dr_pr_in; \
  dfx_node_ary_t seq_dr_pr_out; \
  bit use_ir_in_l; \
  bit data_only; \
  bit user_cmd[dfx_tap_unit_e]; \
  bit locked_tap[dfx_tap_unit_e]; \
  dfx_tap_unit_e raw_mode_tap; \
  int raw_mode_dr_size; \
  bit raw_mode_full_shift; \
  bit raw_mode_move;

`define dfx_tap_multiple_taps_X_sequence_do_print_function_a \
  function void do_print(ovm_printer printer); \
    dfx_tap_unit_e tap_u; \
    dfx_node_t bit_ary[]; \
    if (m_sequencer.get_report_verbosity_level() < OVM_FULL) \
      return; \
    super.do_print(printer); \
    printer.print_array_header("seq_ir_in array of TAP instructions", seq_ir_in.size()); \
    foreach (seq_ir_in[tu_i]) begin \
      tap_u = dfx_tap_unit_e'(tu_i); \
      printer.print_field($psprintf("seq_ir_in[%s]", tap_u.name()), seq_ir_in[tu_i], $bits(seq_ir_in[tu_i]), OVM_HEX); \
    end \
    printer.print_array_footer();\
    foreach (seq_dr_in[tu_i]) begin \
      tap_u = dfx_tap_unit_e'(tu_i); \
      bit_ary = seq_dr_in[tu_i]; \
      printer.print_array_header({"seq_dr_in stream for TAP ", tap_u.name()}, bit_ary.size()); \
      foreach (bit_ary[i]) \
        printer.print_field($psprintf("seq_dr_in[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX); \
      printer.print_array_footer(); \
    end \
    printer.print_array_header("seq_ir_out array of TAP instructions", seq_ir_out.size()); \
    foreach (seq_ir_out[tu_i]) begin \
      tap_u = dfx_tap_unit_e'(tu_i); \
      printer.print_field($psprintf("seq_ir_out[%s]", tap_u.name()), seq_ir_out[tu_i], $bits(seq_ir_out[tu_i]), OVM_HEX); \
    end \
    printer.print_array_footer(); \
    foreach (seq_dr_out[tu_i]) begin \
      tap_u = dfx_tap_unit_e'(tu_i); \
      bit_ary = seq_dr_out[tu_i]; \
      printer.print_array_header({"seq_dr_out stream for TAP ", tap_u.name()}, bit_ary.size()); \
      foreach (bit_ary[i]) \
        printer.print_field($psprintf("seq_dr_out[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX); \
      printer.print_array_footer(); \
    end \
  endfunction : do_print

`define dfx_tap_multiple_taps_X_sequence_do_print_function_b \
  function void do_print(ovm_printer printer); \
    dfx_tap_unit_e tap_u; \
    dfx_node_t bit_ary[]; \
    tap_ir_t ir_value; \
    super.do_print(printer); \
    printer.print_array_header("seq_ir_in array of TAP instructions", seq_ir_in.size()); \
    if (use_ir_in_l) begin \
      foreach (seq_ir_in_l[tu_i]) begin \
        tap_u = dfx_tap_unit_e'(tu_i); \
        ir_value = tap_ir_t'(0); \
        bit_ary = seq_ir_in_l[tu_i]; \
        foreach (bit_ary[i]) \
          ir_value[i] = bit_ary[i]; \
        printer.print_field($psprintf("seq_ir_in[%s]", tap_u.name()), ir_value, seq_ir_in_l[tu_i].size(), OVM_HEX); \
      end \
    end \
    else begin \
      foreach (seq_ir_in[tu_i]) begin \
        tap_u = dfx_tap_unit_e'(tu_i); \
        printer.print_field($psprintf("seq_ir_in[%s]", tap_u.name()), seq_ir_in[tu_i], $bits(seq_ir_in[tu_i]), OVM_HEX); \
      end \
    end \
    printer.print_array_footer();\
    foreach (seq_dr_in[tu_i]) begin \
      tap_u = dfx_tap_unit_e'(tu_i); \
      bit_ary = seq_dr_in[tu_i]; \
      printer.print_array_header({"seq_dr_in stream for TAP ", tap_u.name()}, bit_ary.size()); \
      foreach (bit_ary[i]) \
        printer.print_field($psprintf("seq_dr_in[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX); \
      printer.print_array_footer(); \
    end \
    printer.print_array_header("seq_ir_out array of TAP instructions", seq_ir_out.size()); \
    foreach (seq_ir_out[tu_i]) begin \
      tap_u = dfx_tap_unit_e'(tu_i); \
      printer.print_field($psprintf("seq_ir_out[%s]", tap_u.name()), seq_ir_out[tu_i], $bits(seq_ir_out[tu_i]), OVM_HEX); \
    end \
    printer.print_array_footer(); \
    foreach (seq_dr_out[tu_i]) begin \
      tap_u = dfx_tap_unit_e'(tu_i); \
      bit_ary = seq_dr_out[tu_i]; \
      printer.print_array_header({"seq_dr_out stream for TAP ", tap_u.name()}, bit_ary.size()); \
      foreach (bit_ary[i]) \
        printer.print_field($psprintf("seq_dr_out[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX); \
      printer.print_array_footer(); \
    end \
  endfunction : do_print

`define dfx_tap_multiple_taps_X_sequence_body_task_a \
  task body(); \
    dfx_node_t bit_ary[]; \
    dfx_tap_unit_e tap_u; \
    `ovm_create(reqq) \
    foreach (seq_ir_in[tu_i]) begin \
      reqq.ir_in[tu_i] = seq_ir_in[tu_i]; \
      reqq.dr_in[tu_i] = seq_dr_in[tu_i]; \
    end \
    `ovm_send(reqq) \
    seq_ir_out = reqq.ir_out; \
    seq_dr_out = reqq.td_out; \
    foreach (seq_ir_out[tu_i]) begin \
      tap_u = dfx_tap_unit_e'(tu_i); \
      `ovm_info(get_type_name(), \
                $psprintf("Response to instruction scan of 'h%0h on TAP %s is: 'h%0h", \
                          seq_ir_in[tu_i], tap_u.name(), seq_ir_out[tu_i]), \
                OVM_HIGH) \
      bit_ary = seq_dr_out[tu_i]; \
      `ovm_info(get_type_name(), {"Response to data scan on TAP ", tap_u.name(), " is stream: ", dfx_tap_util::writeh(bit_ary)}, OVM_HIGH) \
    end \
  endtask : body

`define dfx_tap_multiple_taps_X_sequence_body_task_b \
  task body(); \
    dfx_node_t bit_ary[]; \
    dfx_tap_unit_e tap_u; \
    tap_ir_t ir_value; \
    `ovm_create(reqq) \
    if (use_ir_in_l) begin \
      reqq.use_ir_in_l = use_ir_in_l; \
      foreach (seq_ir_in_l[tu_i]) begin \
        reqq.ir_in_l[tu_i] = seq_ir_in_l[tu_i]; \
        reqq.dr_in[tu_i] = seq_dr_in[tu_i]; \
      end \
    end \
    else begin \
      foreach (seq_ir_in[tu_i]) begin \
        reqq.ir_in[tu_i] = seq_ir_in[tu_i]; \
        reqq.dr_in[tu_i] = seq_dr_in[tu_i]; \
      end \
    end \
    foreach (ir_name[tu_i]) begin \
      reqq.ir_name[tu_i] = ir_name[tu_i]; \
    end \
    foreach (user_cmd[tu_i]) begin \
      reqq.user_cmd[tu_i] = user_cmd[tu_i]; \
    end \
    foreach (locked_tap[tu_i]) begin \
      reqq.locked_tap[tu_i] = locked_tap[tu_i]; \
    end \
    reqq.data_only           = data_only; \
    reqq.raw_mode_tap        = raw_mode_tap; \
    reqq.raw_mode_dr_size    = raw_mode_dr_size; \
    reqq.raw_mode_full_shift = raw_mode_full_shift; \
    reqq.raw_mode_move       = raw_mode_move; \
    reqq.ir_prin = seq_ir_pr_in; \
    reqq.dr_prin = seq_dr_pr_in; \
    `ovm_send(reqq) \
    seq_ir_out = reqq.ir_out; \
    seq_dr_out = reqq.td_out; \
    seq_ir_pr_out = reqq.tpi_out; \
    seq_dr_pr_out = reqq.tpd_out; \
    foreach (seq_ir_out[tu_i]) begin \
      tap_u = dfx_tap_unit_e'(tu_i); \
      if (use_ir_in_l) begin \
        ir_value = tap_ir_t'(0); \
        bit_ary = seq_ir_in_l[tu_i]; \
        foreach (bit_ary[i]) \
          ir_value[i] = bit_ary[i]; \
        `ovm_info(get_type_name(), \
                $psprintf("Response to instruction scan of 'h%0h on TAP %s is: %0d'h%0h", \
                          ir_value, tap_u.name(), bit_ary.size(), seq_ir_out[tu_i]), \
                OVM_NONE) \
      end \
      else begin\
        `ovm_info(get_type_name(), \
                $psprintf("Response to instruction scan of 'h%0h on TAP %s is: 'h%0h", \
                          seq_ir_in[tu_i], tap_u.name(), seq_ir_out[tu_i]), \
                OVM_NONE) \
      end \
      bit_ary = seq_dr_out[tu_i]; \
      `ovm_info(get_type_name(), {"Response to data scan on TAP ", tap_u.name(), " is stream: ", dfx_tap_util::writeh(bit_ary)}, OVM_NONE) \
    end \
  endtask : body

class dfx_tap_multiple_taps_sequence extends ovm_sequence;

  `dfx_tap_multiple_taps_X_sequence_definitions

  `ovm_object_utils(dfx_tap_multiple_taps_sequence)

  `ovm_declare_p_sequencer(dfx_tap_sequencer)

  function new(string name = "dfx_tap_multiple_taps_sequence");
    super.new(name);
  endfunction : new

  task body();
    `ovm_error(get_type_name(), dfx_tap_build_error_message)
  endtask : body

endclass : dfx_tap_multiple_taps_sequence

class dfx_tap_multiple_taps_sequence_a extends dfx_tap_multiple_taps_sequence;

  dfx_tap_multiple_taps_transaction_a reqq;

  `ovm_object_utils(dfx_tap_multiple_taps_sequence_a)

  `ovm_declare_p_sequencer(dfx_tap_sequencer)

  function new(string name = "dfx_tap_multiple_taps_sequence_a");
    super.new(name);
  endfunction : new

  `dfx_tap_multiple_taps_X_sequence_do_print_function_a

  `dfx_tap_multiple_taps_X_sequence_body_task_a

endclass : dfx_tap_multiple_taps_sequence_a

class dfx_tap_multiple_taps_sequence_b extends dfx_tap_multiple_taps_sequence;

  `dfx_tap_multiple_taps_X_sequence_definitions_b

  dfx_tap_multiple_taps_transaction_b reqq;

  `ovm_object_utils(dfx_tap_multiple_taps_sequence_b)

  `ovm_declare_p_sequencer(dfx_tap_sequencer)

  function new(string name = "dfx_tap_multiple_taps_sequence_b");
    super.new(name);
  endfunction : new

  `dfx_tap_multiple_taps_X_sequence_do_print_function_b

  `dfx_tap_multiple_taps_X_sequence_body_task_b

endclass : dfx_tap_multiple_taps_sequence_b

class dfx_tap_multiple_taps_data_only_sequence extends ovm_sequence;

  `dfx_tap_multiple_taps_X_sequence_definitions

  dfx_tap_multiple_taps_data_only_transaction reqq;

  `ovm_object_utils(dfx_tap_multiple_taps_data_only_sequence)

  `ovm_declare_p_sequencer(dfx_tap_sequencer)

  function new(string name = "dfx_tap_multiple_taps_data_only_sequence");
    super.new(name);
  endfunction : new

  `dfx_tap_multiple_taps_X_sequence_do_print_function_a

  `dfx_tap_multiple_taps_X_sequence_body_task_a

endclass : dfx_tap_multiple_taps_data_only_sequence

`endif // `ifndef DFX_TAP_BASE_SEQUENCES_SV
