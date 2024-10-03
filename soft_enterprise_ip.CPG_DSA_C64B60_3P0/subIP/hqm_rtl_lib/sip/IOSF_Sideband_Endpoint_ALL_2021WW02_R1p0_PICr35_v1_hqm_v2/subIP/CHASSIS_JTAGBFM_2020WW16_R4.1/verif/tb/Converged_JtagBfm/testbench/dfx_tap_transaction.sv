// =====================================================================================================
// FileName          : dfx_tap_transaction.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Fri May 28 12:57:20 CDT 2010
// Modification Date : Thu Nov 13 14:27:12 CST 2014
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// TAP Transactions base class and derived classes
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_TRANSACTION_SV
`define DFX_TAP_TRANSACTION_SV

// Base TAP transaction - not for use by sequences
//
class dfx_tap_base_transaction extends ovm_sequence_item;

  // ovm_verbosity my_verbosity = OVM_LOW;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  rand dfx_tapfsm_state_e its = DFX_TAP_TS_RTI; // final TAP state after executing instruction part of TAP transaction -
                                                // for finer control of TAP transactions
  rand dfx_tapfsm_state_e dts = DFX_TAP_TS_RTI; // final TAP state after executing data part of TAP transaction - for
                                                // finer control of TAP transactions
  rand dfx_tapfsm_state_e ts = DFX_TAP_TS_RTI; // final TAP state after executing dfx_tap_tms_tap_transaction TAP
                                               // transaction - for finer control of TAP transactions
  rand dfx_node_t instr_in[], data_in[]; // aggregate TAP network streams (set for some transaction types
                                         // (dfx_tap_raw_tap_transaction))
  rand bit assert_trst = 1'b0; // assert TRST while executing TAP transaction (set for some transaction types
                               // (dfx_tap_tms_tap_transaction)
  rand dfx_node_t tms_in[], tdi_in[]; // aggregate TAP network streams (set for some transaction types
                                      // (dfx_tap_tms_tap_transaction))
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  dfx_node_t instr_out[], data_out[]; // aggregate TAP network streams (read for some transaction types
                                      // (dfx_tap_raw_tap_transaction))
  dfx_node_t tdo_out[]; // aggregate TAP network stream (read for some transaction types (dfx_tap_tms_tap_transaction))
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  dfx_node_t bypass_data[];

  `ovm_object_utils_begin(dfx_tap_base_transaction)
    `ovm_field_array_int(bypass_data, OVM_DEFAULT)
    `ovm_field_enum(dfx_tapfsm_state_e, its, OVM_DEFAULT)
    `ovm_field_enum(dfx_tapfsm_state_e, dts, OVM_DEFAULT)
    `ovm_field_enum(dfx_tapfsm_state_e, ts, OVM_DEFAULT)
    `ovm_field_array_int(instr_in, OVM_DEFAULT)
    `ovm_field_array_int(data_in, OVM_DEFAULT)
    `ovm_field_int(assert_trst, OVM_DEFAULT)
    `ovm_field_array_int(tms_in, OVM_DEFAULT)
    `ovm_field_array_int(tdi_in, OVM_DEFAULT)
    `ovm_field_array_int(instr_out, OVM_DEFAULT)
    `ovm_field_array_int(data_out, OVM_DEFAULT)
  `ovm_object_utils_end

  function new(string name = "dfx_tap_base_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    bypass_data = new[1];
    bypass_data[0] = 1'b1; // FIXME: control through tap_env setting
  endfunction : new

  virtual function void compose(dfx_tap_port_e port);
  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
  endfunction : decompose

endclass : dfx_tap_base_transaction

// Single TAP transaction
//
// Specify TAP and instruction
// If data is not specified, it is automatically created based upon the data length specification for the TAP
// Final TAP state after instruction scan is unspecified, and after data scan is unspecified
//
class dfx_tap_single_tap_transaction_fs extends dfx_tap_base_transaction;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  rand dfx_tap_unit_e tap_u;
  rand tap_ir_t ir_in;
  rand dfx_node_t dr_in[];
  rand bit instr_only = 1'b0; // this field can be set by a sequence only when using ovm_create/ovm_send
  rand bit data_only = 1'b0; // this field can be set by a sequence only when using ovm_create/ovm_send
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  dfx_node_t tti_out[], ttd_out[]; // scanned out instruction and data for this TAP ("tti" = this tap instruction, "ttd"
                                   // = this tap data)
  tap_ir_t ir_out = tap_ir_t'(0); // scanned out instruction as a vector
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils_begin(dfx_tap_single_tap_transaction_fs)
    `ovm_field_enum(dfx_tap_unit_e, tap_u, OVM_DEFAULT)
    `ovm_field_int(ir_in, OVM_DEFAULT)
    `ovm_field_array_int(dr_in, OVM_DEFAULT)
    `ovm_field_int(instr_only, OVM_DEFAULT)
    `ovm_field_int(data_only, OVM_DEFAULT)
    `ovm_field_array_int(tti_out, OVM_DEFAULT)
    `ovm_field_int(ir_out, OVM_DEFAULT)
    `ovm_field_array_int(ttd_out, OVM_DEFAULT)
  `ovm_object_utils_end

  function new(string name = "dfx_tap_single_tap_transaction_fs",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults {
    ts == DFX_TAP_TS_RTI;
    instr_in.size() == 0;
    data_in.size() == 0;
    assert_trst == 1'b0;
    tms_in.size() == 0;
    tdi_in.size() == 0;
  } // in case of randomization

  constraint defaults2 {
    instr_only == 1'b0;
    data_only == 1'b0;
  } // in case of randomization

  virtual function void compose(dfx_tap_port_e port);
    bit tap_found = 1'b0, no_data = 1'b0;
    dfx_node_t ir_array[], dr_array[];
    dfx_tap_network nw = dfx_tap_network::get_handle();

    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != NUM_TAPS; tu_i = tu_i.next()) begin
      if (nw.tap_effectively_isolated(tu_i, port))
        continue;

      if (tu_i == tap_u) begin
        tap_found = 1'b1;

        nw.tap_array[port][tu_i].tap_handle.ir_dr_as_array(ir_in, ir_array, dr_array);

        if (!data_only)
          dfx_tap_util::prepend_array(instr_in, ir_array);

        if (!instr_only) begin
          if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED) begin
            if (dr_in.size() > 0) begin
              if (dr_in.size() != dr_array.size())
                `ovm_warning(get_type_name(),
                             $psprintf("compose(): data size supplied by user (%0d) does not match TAP %s specification",
                                       dr_in.size(), tu_i.name()))

              dfx_tap_util::prepend_array(data_in, dr_in);
            end
            else begin
              if (dr_array.size() == 0) begin
                `ovm_warning(get_type_name(),
                             $psprintf("compose(): data size according to TAP %s specification is 0", tu_i.name()))
                no_data = 1'b1;
              end
              else
                dfx_tap_util::prepend_array(data_in, dr_array);
            end
          end
          else begin
            `ovm_info(get_type_name(), $psprintf("compose(): TAP %s is excluded, no data scanned in", tu_i.name()), OVM_FULL)
            no_data = 1'b1;
          end
        end
        else
          no_data = 1'b1;
      end
      else begin
        nw.tap_array[port][tu_i].tap_handle.ir_as_array(nw.tap_array[port][tu_i].tap_handle.bypass_instr, ir_array);

        if (!data_only)
          dfx_tap_util::prepend_array(instr_in, ir_array);

        if (!instr_only) begin
          if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED)
            dfx_tap_util::prepend_array(data_in, bypass_data);
        end
        else
          no_data = 1'b1;
      end
    end

    if (!tap_found) begin
      `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
      instr_in.delete();
      data_in.delete();
    end

    if (no_data) begin
      `ovm_info(get_type_name(), "compose(): Skipping data scan", OVM_FULL)
      data_in.delete(); // clear BYPASS data, if any
    end

  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
    int isi = 0, // "isi" = instruction start index
        dsi = 0; // "dsi" = data start index
    dfx_tap_network nw = dfx_tap_network::get_handle();
    dfx_tap_unit_e tu_i = tu_i.last(); // NUM_TAPS

    tu_i = tu_i.prev();
    while (tu_i != tap_u && tu_i != tu_i.last()) begin
      if (!nw.tap_effectively_isolated(tu_i, port)) begin
          isi += nw.tap_array[port][tu_i].tap_handle.IR_length;

          if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED)
            dsi += 1;
      end

      tu_i = tu_i.prev();
    end

    // tu_i == tap_u

    if (tu_i == tu_i.last())
      `ovm_fatal(get_type_name(), $psprintf("TAP %s not in enum - impossible", tap_u.name()))

    if (nw.tap_effectively_isolated(tu_i, port))
      `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
    else begin
      if (!data_only) begin
        dfx_tap_util::extract_array(instr_out, tti_out, isi, nw.tap_array[port][tu_i].tap_handle.IR_length);
        // {<< {ir_out}} = {>> {tti_out}};
        foreach (tti_out[i])
          ir_out[i] = tti_out[i];
      end

      if (!instr_only)
        if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED) begin
          if (dr_in.size() > 0)
            dfx_tap_util::extract_array(data_out, ttd_out, dsi, dr_in.size());
          else
            dfx_tap_util::extract_array(data_out, ttd_out, dsi, nw.tap_array[port][tu_i].tap_handle.dr_length(ir_in));
        end
    end

  endfunction : decompose

endclass : dfx_tap_single_tap_transaction_fs

// Single TAP transaction
//
// Specify TAP and instruction
// If data is not specified, it is automatically created based upon the data length specification for the TAP
// Final TAP state after each scan is Run-Test-Idle
//
class dfx_tap_single_tap_transaction extends dfx_tap_single_tap_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_transaction)

  function new(string name = "dfx_tap_single_tap_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

endclass : dfx_tap_single_tap_transaction

// Single TAP transaction
//
// Specify TAP and instruction
// If data is not specified, it is automatically created based upon the data length specification for the TAP
// Final TAP state after scan is Pause-DR
// (Final TAP state after instruction scan is Run-Test-Idle, and after data scan is Pause-DR)
//
class dfx_tap_single_tap_transaction_pause extends dfx_tap_single_tap_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_transaction_pause)

  function new(string name = "dfx_tap_single_tap_transaction_pause",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    dts = DFX_TAP_TS_PAUSE_DR;
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_PAUSE_DR;
  } // in case of randomization

endclass : dfx_tap_single_tap_transaction_pause

// Single TAP transaction
//
// Specify TAP and instruction
// If data is not specified, it is automatically created based upon the data length specification for the TAP
// Final TAP state after scan is Shift-DR
// (Final TAP state after instruction scan is Run-Test-Idle, and after data scan is Shift-DR)
//
class dfx_tap_single_tap_transaction_shift extends dfx_tap_single_tap_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_transaction_shift)

  function new(string name = "dfx_tap_single_tap_transaction_shift",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    dts = DFX_TAP_TS_SHIFT_DR;
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_SHIFT_DR;
  } // in case of randomization

endclass : dfx_tap_single_tap_transaction_shift

// Single TAP transaction - instruction only
//
// Specify TAP and instruction
// Final TAP state after scan is unspecified
//
class dfx_tap_single_tap_instruction_only_transaction_fs extends dfx_tap_single_tap_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_instruction_only_transaction_fs)

  function new(string name = "dfx_tap_single_tap_instruction_only_transaction_fs",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    instr_only = 1'b1;
  endfunction : new

  constraint defaults2 {
    instr_only == 1'b1;
    data_only == 1'b0;
  } // in case of randomization

endclass : dfx_tap_single_tap_instruction_only_transaction_fs

// Single TAP transaction - instruction only
//
// Specify TAP and instruction
// Final TAP state after scan is Run-Test-Idle
//
class dfx_tap_single_tap_instruction_only_transaction extends dfx_tap_single_tap_instruction_only_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_instruction_only_transaction)

  function new(string name = "dfx_tap_single_tap_instruction_only_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

endclass : dfx_tap_single_tap_instruction_only_transaction

// Single TAP transaction - instruction only
//
// Specify TAP and instruction
// Final TAP state after scan is Pause-IR
//
class dfx_tap_single_tap_instruction_only_transaction_pause extends dfx_tap_single_tap_instruction_only_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_instruction_only_transaction_pause)

  function new(string name = "dfx_tap_single_tap_instruction_only_transaction_pause",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    its = DFX_TAP_TS_PAUSE_IR;
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_PAUSE_IR;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

endclass : dfx_tap_single_tap_instruction_only_transaction_pause

// Single TAP transaction - data only (instruction may be specified but is not used)
//
// Specify TAP and instruction
// Instruction is not scanned in
// If data is not specified, it is automatically created based upon the data length specification for the TAP
// Final TAP state after scan is unspecified
//
class dfx_tap_single_tap_data_only_transaction_fs extends dfx_tap_single_tap_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_data_only_transaction_fs)

  function new(string name = "dfx_tap_single_tap_data_only_transaction_fs",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    data_only = 1'b1;
  endfunction : new

  constraint defaults2 {
    instr_only == 1'b0;
    data_only == 1'b1;
  } // in case of randomization

endclass : dfx_tap_single_tap_data_only_transaction_fs

// Single TAP transaction - data only (instruction may be specified but is not used)
//
// Specify TAP and instruction
// Instruction is not scanned in
// If data is not specified, it is automatically created based upon the data length specification for the TAP
// Final TAP state after scan is Run-Test-Idle
//
class dfx_tap_single_tap_data_only_transaction extends dfx_tap_single_tap_data_only_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_data_only_transaction)

  function new(string name = "dfx_tap_single_tap_data_only_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

endclass : dfx_tap_single_tap_data_only_transaction

// Single TAP transaction - data only (instruction may be specified but is not used)
//
// Specify TAP and instruction
// Instruction is not scanned in
// If data is not specified, it is automatically created based upon the data length specification for the TAP
// Final TAP state after scan is Pause-DR
//
class dfx_tap_single_tap_data_only_transaction_pause extends dfx_tap_single_tap_data_only_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_data_only_transaction_pause)

  function new(string name = "dfx_tap_single_tap_data_only_transaction_pause",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    dts = DFX_TAP_TS_PAUSE_DR;
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_PAUSE_DR;
  } // in case of randomization

endclass : dfx_tap_single_tap_data_only_transaction_pause

// Single TAP transaction - data only (instruction may be specified but is not used)
//
// Specify TAP and instruction
// Instruction is not scanned in
// If data is not specified, it is automatically created based upon the data length specification for the TAP
// Final TAP state after scan is Shift-DR
//
class dfx_tap_single_tap_data_only_transaction_shift extends dfx_tap_single_tap_data_only_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_data_only_transaction_shift)

  function new(string name = "dfx_tap_single_tap_data_only_transaction_shift",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    dts = DFX_TAP_TS_SHIFT_DR;
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_SHIFT_DR;
  } // in case of randomization

endclass : dfx_tap_single_tap_data_only_transaction_shift

// Single TAP transaction, unspecified final TAP state - no instruction specified or used
//
// Specify TAP and data
// Final TAP state after scan is unspecified
//
class dfx_tap_single_tap_no_instruction_transaction_fs extends dfx_tap_base_transaction;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  rand dfx_tap_unit_e tap_u;
  rand dfx_node_t dr_in[];
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  dfx_node_t ttd_out[]; // scanned out data for this TAP ("ttd" = this tap data)
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils_begin(dfx_tap_single_tap_no_instruction_transaction_fs)
    `ovm_field_enum(dfx_tap_unit_e, tap_u, OVM_DEFAULT)
    `ovm_field_array_int(dr_in, OVM_DEFAULT)
    `ovm_field_array_int(ttd_out, OVM_DEFAULT)
  `ovm_object_utils_end

  function new(string name = "dfx_tap_single_tap_no_instruction_transaction_fs",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults {
    ts == DFX_TAP_TS_RTI;
    instr_in.size() == 0;
    data_in.size() == 0;
    assert_trst == 1'b0;
    tms_in.size() == 0;
    tdi_in.size() == 0;
  } // in case of randomization

  virtual function void compose(dfx_tap_port_e port);
    bit tap_found = 1'b0;
    dfx_node_t dr_array[];
    dfx_tap_network nw = dfx_tap_network::get_handle();

    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != NUM_TAPS; tu_i = tu_i.next()) begin
      if (nw.tap_effectively_isolated(tu_i, port))
        continue;

      if (tu_i == tap_u) begin
        tap_found = 1'b1;

        if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED)
          dfx_tap_util::prepend_array(data_in, dr_in);
        else
          `ovm_info(get_type_name(), $psprintf("compose(): TAP %s is excluded, no data scanned in", tu_i.name()), OVM_FULL)
      end
      else if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED)
        dfx_tap_util::prepend_array(data_in, bypass_data); // assume BYPASS data is needed
    end

    if (!tap_found)
      `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))

    if (dr_in.size() == 0) begin
      `ovm_info(get_type_name(), $psprintf("compose(): No data was supplied for TAP %s, skipping data scan", tap_u.name()), OVM_FULL)
      data_in.delete();
    end

  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
    int dsi = 0; // "dsi" = data start index
    dfx_tap_network nw = dfx_tap_network::get_handle();
    dfx_tap_unit_e tu_i = tu_i.last(); // NUM_TAPS

    tu_i = tu_i.prev();
    while (tu_i != tap_u && tu_i != tu_i.last()) begin
      if (!nw.tap_effectively_isolated(tu_i, port))
        if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED)
          dsi += 1;

      tu_i = tu_i.prev();
    end

    // tu_i == tap_u

    if (tu_i == tu_i.last())
      `ovm_fatal(get_type_name(), $psprintf("TAP %s not in enum - impossible", tap_u.name()))

    if (nw.tap_effectively_isolated(tu_i, port))
      `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
    else
      if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED)
        dfx_tap_util::extract_array(data_out, ttd_out, dsi, dr_in.size());

  endfunction : decompose

endclass : dfx_tap_single_tap_no_instruction_transaction_fs

// Single TAP transaction - no instruction specified or used
//
// Specify TAP and data
// Final TAP state after scan is Run-Test-Idle
//
class dfx_tap_single_tap_no_instruction_transaction extends dfx_tap_single_tap_no_instruction_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_no_instruction_transaction)

  function new(string name = "dfx_tap_single_tap_no_instruction_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults2 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

endclass : dfx_tap_single_tap_no_instruction_transaction

// Single TAP transaction - no instruction specified or used
//
// Specify TAP and data
// Final TAP state after scan is Pause-DR
//
class dfx_tap_single_tap_no_instruction_transaction_pause extends dfx_tap_single_tap_no_instruction_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_no_instruction_transaction_pause)

  function new(string name = "dfx_tap_single_tap_no_instruction_transaction_pause",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    dts = DFX_TAP_TS_PAUSE_DR;
  endfunction : new

  constraint defaults2 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_PAUSE_DR;
  } // in case of randomization

endclass : dfx_tap_single_tap_no_instruction_transaction_pause

// Single TAP transaction - no instruction specified or used
//
// Specify TAP and data
// Final TAP state after scan is Shift-DR
//
class dfx_tap_single_tap_no_instruction_transaction_shift extends dfx_tap_single_tap_no_instruction_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_single_tap_no_instruction_transaction_shift)

  function new(string name = "dfx_tap_single_tap_no_instruction_transaction_shift",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    dts = DFX_TAP_TS_SHIFT_DR;
  endfunction : new

  constraint defaults2 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_SHIFT_DR;
  } // in case of randomization

endclass : dfx_tap_single_tap_no_instruction_transaction_shift

// Multiple TAPs transaction
//
// Specify TAPs and instructions
// If data is not specified for a TAP, it is automatically created based upon the data length specification for that TAP
// Final TAP state after instruction scan is unspecified, and after data scan is unspecified
//
class dfx_tap_multiple_taps_transaction_fs extends dfx_tap_base_transaction;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  tap_ir_t ir_in[dfx_tap_unit_e]; // array to hold IR values scanned in
  dfx_node_ary_t dr_in[dfx_tap_unit_e]; // array to hold DR arrays scanned in
  rand bit instr_only = 1'b0; // this field can be set by a sequence only when using ovm_create/ovm_send
  rand bit data_only = 1'b0; // this field can be set by a sequence only when using ovm_create/ovm_send
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  dfx_node_ary_t ti_out[dfx_tap_unit_e], td_out[dfx_tap_unit_e]; // scanned out instruction and data for the specified
                                                                 // TAPs ("ti" = tap instruction, "td" = tap data)
  tap_ir_t ir_out[dfx_tap_unit_e]; // array to hold IR values scanned out
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils_begin(dfx_tap_multiple_taps_transaction_fs)
    `ovm_field_int(instr_only, OVM_DEFAULT)
    `ovm_field_int(data_only, OVM_DEFAULT)
  `ovm_object_utils_end

  function new(string name = "dfx_tap_multiple_taps_transaction_fs",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults {
    ts == DFX_TAP_TS_RTI;
    instr_in.size() == 0;
    data_in.size() == 0;
    assert_trst == 1'b0;
    tms_in.size() == 0;
    tdi_in.size() == 0;
  } // in case of randomization

  constraint defaults2 {
    instr_only == 1'b0;
    data_only == 1'b0;
  } // in case of randomization

  virtual function void do_print_ir(ovm_printer printer);
    dfx_tap_unit_e tap_u;

    foreach (ir_in[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      printer.print_field($psprintf("ir_in[%s]", tap_u.name()), ir_in[tu_i], $bits(ir_in[tu_i]), OVM_HEX);
    end
  endfunction : do_print_ir

  virtual function void do_print(ovm_printer printer);
    dfx_tap_unit_e tap_u;
    dfx_node_t bit_ary[];

    // if (my_verbosity < OVM_HIGH)
    /*
    if (m_sequencer.get_report_verbosity_level() < OVM_HIGH)
      return;
     */

    super.do_print(printer);

    printer.print_array_header("ir_in array of TAP instructions", ir_in.size());
    do_print_ir(printer);
    printer.print_array_footer();

    foreach (dr_in[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      bit_ary = dr_in[tu_i];
      printer.print_array_header({"dr_in for TAP ", tap_u.name()}, bit_ary.size());

      foreach (bit_ary[i])
        printer.print_field($psprintf("dr_in[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX);

      printer.print_array_footer();
    end

    foreach (ti_out[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      bit_ary = ti_out[tu_i];
      printer.print_array_header({"ti_out for TAP ", tap_u.name()}, bit_ary.size());

      foreach (bit_ary[i])
        printer.print_field($psprintf("ti_out[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX);

      printer.print_array_footer();
    end

    printer.print_array_header("ir_out array of TAP instructions", ir_out.size());
    foreach (ir_out[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      printer.print_field($psprintf("ir_out[%s]", tap_u.name()), ir_out[tu_i], $bits(ir_out[tu_i]), OVM_HEX);
    end
    printer.print_array_footer();

    foreach (td_out[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      bit_ary = td_out[tu_i];
      printer.print_array_header({"td_out for TAP ", tap_u.name()}, bit_ary.size());

      foreach (bit_ary[i])
        printer.print_field($psprintf("td_out[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX);

      printer.print_array_footer();
    end
  endfunction : do_print

  virtual function void compose(dfx_tap_port_e port);
    bit tap_found[dfx_tap_unit_e], have_instr = 1'b0, have_data = 1'b0;
    dfx_node_t ir_array[], dr_array[];
    dfx_node_t bit_ary[];
    dfx_tap_unit_e tap_u;
    dfx_tap_network nw = dfx_tap_network::get_handle();

    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != NUM_TAPS; tu_i = tu_i.next()) begin
      if (nw.tap_effectively_isolated(tu_i, port))
        continue;

      if (ir_in.exists(tu_i) || dr_in.exists(tu_i)) begin
        tap_found[tu_i] = 1'b1;

        // Ignore error and let it be a data-only transaction?
        if (!data_only && !ir_in.exists(tu_i))
          `ovm_error(get_type_name(), {"No instruction specified for TAP ", tu_i.name})

        if (ir_in.exists(tu_i)) begin
          have_instr = 1'b1;

          nw.tap_array[port][tu_i].tap_handle.ir_dr_as_array(ir_in[tu_i], ir_array, dr_array);

          if (!data_only)
            dfx_tap_util::prepend_array(instr_in, ir_array);
        end

        if (!instr_only) begin
          if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED) begin
            if (dr_in[tu_i].size() > 0) begin
              if (ir_in.exists(tu_i) && dr_in[tu_i].size() != dr_array.size())
                `ovm_warning(get_type_name(),
                             $psprintf("compose(): data size supplied by user (%0d) does not match TAP %s specification",
                                       dr_in[tu_i].size(), tu_i.name()))

              bit_ary = dr_in[tu_i];
              dfx_tap_util::prepend_array(data_in, bit_ary);
              have_data = 1'b1;
            end
            else begin
              if (dr_array.size() == 0)
                `ovm_warning(get_type_name(),
                             $psprintf("compose(): data size either unknown or according to TAP %s specification is 0", tu_i.name()))
              else begin
                dfx_tap_util::prepend_array(data_in, dr_array);
                have_data = 1'b1;
              end
            end
          end
          else
            `ovm_info(get_type_name(), $psprintf("compose(): TAP %s is excluded, no data scanned in", tu_i.name()), OVM_FULL)
        end
      end
      else begin
        nw.tap_array[port][tu_i].tap_handle.ir_as_array(nw.tap_array[port][tu_i].tap_handle.bypass_instr, ir_array);

        if (!data_only)
          dfx_tap_util::prepend_array(instr_in, ir_array);

        if (!instr_only)
          if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED)
            dfx_tap_util::prepend_array(data_in, bypass_data);
      end
    end

    foreach (ir_in[tu_i])
      if (!tap_found.exists(tu_i)) begin
        tap_u = dfx_tap_unit_e'(tu_i);
        `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
      end

    foreach (dr_in[tu_i])
      if (!tap_found.exists(tu_i) && !ir_in.exists(tu_i)) begin
        tap_u = dfx_tap_unit_e'(tu_i);
        `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
      end

    // Comment this out to get different behaviour - empty ir_in[] causes BYPASS instruction to be scanned into each
    // TAP.
    if (!have_instr) begin
      `ovm_info(get_type_name(), "compose(): skipping instruction scan", OVM_FULL)
      instr_in.delete(); // clear BYPASS instructions, if any
    end

    // Comment this out to get different behaviour - empty dr_in[] causes BYPASS data to be scanned into each TAP.
    if (!have_data) begin
      `ovm_info(get_type_name(), "compose(): skipping data scan", OVM_FULL)
      data_in.delete(); // clear BYPASS data, if any
    end

  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
    int isi = 0, // "isi" = instruction start index
        dsi = 0; // "dsi" = data start index
    bit tap_found[dfx_tap_unit_e];
    dfx_tap_unit_e tap_u, tu_i = tu_i.last();
    dfx_node_t bit_ary[];
    dfx_tap_network nw = dfx_tap_network::get_handle();

    tu_i = tu_i.prev();
    while (tu_i != tu_i.last()) begin
      if (!nw.tap_effectively_isolated(tu_i, port)) begin
        if (ir_in.exists(tu_i) || dr_in.exists(tu_i)) begin
          tap_found[tu_i] = 1'b1;

          if (!data_only) begin
            dfx_tap_util::extract_array(instr_out, bit_ary, isi, nw.tap_array[port][tu_i].tap_handle.IR_length);
            ti_out[tu_i] = bit_ary;
            ir_out[tu_i] = tap_ir_t'(0); // initialize all bits
            foreach (bit_ary[i])
              ir_out[tu_i][i] = bit_ary[i];
          end

          if (!instr_only)
            if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED) begin
              if (dr_in[tu_i].size() > 0) begin
                dfx_tap_util::extract_array(data_out, bit_ary, dsi, dr_in[tu_i].size());
                dsi += dr_in[tu_i].size();
              end
              else begin
                dfx_tap_util::extract_array(data_out, bit_ary, dsi, nw.tap_array[port][tu_i].tap_handle.dr_length(ir_in[tu_i]));
                dsi += nw.tap_array[port][tu_i].tap_handle.dr_length(ir_in[tu_i]);
              end

              td_out[tu_i] = bit_ary;
            end
        end
        else if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED)
          dsi += 1;

        isi += nw.tap_array[port][tu_i].tap_handle.IR_length;
      end

      tu_i = tu_i.prev();
    end

    foreach (ir_in[tu_i])
      if (!tap_found.exists(tu_i)) begin
        tap_u = dfx_tap_unit_e'(tu_i);
        `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
      end

  endfunction : decompose

endclass : dfx_tap_multiple_taps_transaction_fs

// Multiple TAPs transaction
//
// Specify TAPs and instructions
// If data is not specified for a TAP, it is automatically created based upon the data length specification for that TAP
// Final TAP state after each scan is Run-Test-Idle
//
class dfx_tap_multiple_taps_transaction extends dfx_tap_multiple_taps_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_transaction)

  function new(string name = "dfx_tap_multiple_taps_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

endclass : dfx_tap_multiple_taps_transaction
//
// A version:
class dfx_tap_multiple_taps_transaction_a extends dfx_tap_multiple_taps_transaction;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_transaction_a)

  function new(string name = "dfx_tap_multiple_taps_transaction_a",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_transaction_a
//
// B version:
class dfx_tap_multiple_taps_transaction_b extends dfx_tap_multiple_taps_transaction;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  dfx_node_ary_t ir_in_l[dfx_tap_unit_e]; // array to hold IR arrays scanned in
  bit user_cmd[dfx_tap_unit_e]; // TAPs whcih user originally specified instructions for
  bit locked_tap[dfx_tap_unit_e]; // TAPs which are locked at current security level
  bit use_ir_in_l = 1'b0; // set 1 to use sized ir_in_l
  dfx_node_ary_t ir_prin; // array to hold IR prefix arrays scanned in
  dfx_node_ary_t dr_prin; // array to hold DR prefix arrays scanned in
  bit raw_mode_move       = 0;

  bit goto_tlr        = 0;
  bit set_ir          = 0;
  bit set_dr          = 0;
  bit goto_rti        = 0;
  bit is_back_to_back = 0;
  bit skip_rti        = 0;
  int clocks_in_tlr   = 5;
  int clocks_in_rti_after_instruction = 1;
  int clocks_in_rti_before_dr_shift   = 1;

  dfx_tap_unit_e raw_mode_tap = NUM_TAPS;
  int raw_mode_dr_size    = 0;
  bit raw_mode_full_shift = 0;
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  tap_nw_s tapnw_l[$]; // Final tap network connectivity/info (active TAPs) for IR/DR shift, from tdi to tdo
  string ir_name[dfx_tap_unit_e]; // IR/Opcode names

  dfx_node_ary_t tpi_out, tpd_out; // scanned out instruction and data prefixes
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  bit has_set_ir = 0;
  bit has_set_dr = 0;
  int current_shift_pause_loop;
  shift_pause_s   ir_shift_pause_l[$];
  shift_pause_s   dr_shift_pause_l[$];
  tap_fsm_state_s tap_driver_data_l[$];

  int skipped_dr_size = 0;

  `ovm_object_utils_begin(dfx_tap_multiple_taps_transaction_b)
    `ovm_field_int(goto_tlr, OVM_DEFAULT)
    `ovm_field_int(set_ir, OVM_DEFAULT)
    `ovm_field_int(set_dr, OVM_DEFAULT)
    `ovm_field_int(goto_rti, OVM_DEFAULT)
    `ovm_field_int(is_back_to_back, OVM_DEFAULT)
    `ovm_field_int(skip_rti, OVM_DEFAULT)
    `ovm_field_int(clocks_in_tlr, OVM_DEFAULT)
    `ovm_field_int(clocks_in_rti_after_instruction, OVM_DEFAULT)
    `ovm_field_int(clocks_in_rti_before_dr_shift, OVM_DEFAULT)
  `ovm_object_utils_end

  function new(string name = "dfx_tap_multiple_taps_transaction_b",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

  function void do_print_ir(ovm_printer printer);
    dfx_tap_unit_e tap_u;
    dfx_node_t bit_ary[];
    tap_ir_t ir_value = tap_ir_t'(0);

    foreach (ir_in[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      if (use_ir_in_l) begin
         ir_value = tap_ir_t'(0);
         bit_ary = ir_in_l[tu_i];
         foreach (bit_ary[i])
           ir_value[i] = bit_ary[i];
         printer.print_field($psprintf("ir_in[%s]", tap_u.name()), ir_value, bit_ary.size(), OVM_HEX);
      end
    end

  endfunction : do_print_ir

  function void do_print(ovm_printer printer);
    dfx_tap_unit_e tap_u;
    dfx_node_t bit_ary[];
    tap_ir_t ir_value = tap_ir_t'(0);
    super.do_print(printer);

    printer.print_array_header("ir_in array of TAP instructions", ir_in.size());
    do_print_ir(printer);
    printer.print_array_footer();

    foreach (dr_in[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      bit_ary = dr_in[tu_i];
      printer.print_array_header({"dr_in for TAP ", tap_u.name()}, bit_ary.size());

      foreach (bit_ary[i])
        printer.print_field($psprintf("dr_in[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX);

      printer.print_array_footer();
    end

    foreach (ti_out[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      bit_ary = ti_out[tu_i];
      printer.print_array_header({"ti_out for TAP ", tap_u.name()}, bit_ary.size());

      foreach (bit_ary[i])
        printer.print_field($psprintf("ti_out[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX);

      printer.print_array_footer();
    end

    printer.print_array_header("ir_out array of TAP instructions", ir_out.size());
    foreach (ir_out[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      printer.print_field($psprintf("ir_out[%s]", tap_u.name()), ir_out[tu_i], $bits(ir_out[tu_i]), OVM_HEX);
    end
    printer.print_array_footer();

    foreach (td_out[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      bit_ary = td_out[tu_i];
      printer.print_array_header({"td_out for TAP ", tap_u.name()}, bit_ary.size());

      foreach (bit_ary[i])
        printer.print_field($psprintf("td_out[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX);

      printer.print_array_footer();
    end
  endfunction : do_print

  virtual function void compose(dfx_tap_port_e port);
    bit tap_found[dfx_tap_unit_e], have_instr = 1'b0, have_data = 1'b0, have_instr_current = 1'b0, skip_dr_data = 1'b0;
    bit is_user_cmds = 1'b0;
    dfx_node_t ir_array[], dr_array[];
    dfx_node_t bit_ary[];
    dfx_tap_unit_e tap_u;
    tap_nw_s tap_nw_info;

    dfx_tap_network nw = dfx_tap_network::get_handle();

    if (user_cmd.size() > 0)
       is_user_cmds = 1;

    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != NUM_TAPS; tu_i = tu_i.next()) begin
      if (nw.tap_effectively_isolated(tu_i, port))
        continue;

      if (locked_tap.exists(tu_i))
        if (locked_tap[tu_i]) begin
          `ovm_info(get_type_name(),
                    $psprintf("compose(): TAP %s is LOCKED, SKIPPING", tu_i.name()), OVM_LOW)
          continue;
        end

      have_instr_current = 1'b0;
      tap_nw_info.tap_name = tu_i.name();
      tap_nw_info.ir_name  = "PREVIOUS";
      tap_nw_info.status   = TAP_STATE_NORMAL;
      tap_nw_info.user_cmd = 0;
      tap_nw_info.ir_in_l.delete();
      tap_nw_info.dr_in_l.delete();

      if (use_ir_in_l && ir_in_l.exists(tu_i)) begin
         `ovm_info(get_type_name(), $psprintf("compose(): Using instr_l flow"), OVM_NONE)
         have_instr = 1'b1;
         have_instr_current = 1'b1;
         if (!data_only) begin
           if (ir_in_l[tu_i].size() > 0) begin
             bit_ary = ir_in_l[tu_i];
             dfx_tap_util::prepend_array(instr_in, bit_ary);
             dfx_tap_util::prepend_array(tap_nw_info.ir_in_l, bit_ary);
             if (ir_name.exists(tu_i))
                tap_nw_info.ir_name = ir_name[tu_i];
             else
                tap_nw_info.ir_name = "UNKNOWN";
           end
           else
             `ovm_error(get_type_name(), {"No instruction opcode specified for TAP ", tu_i.name})
         end
      end
      else if (ir_in.exists(tu_i)) begin
         have_instr = 1'b1;
         have_instr_current = 1'b1;

         nw.tap_array[port][tu_i].tap_handle.ir_dr_as_array(ir_in[tu_i], ir_array, dr_array);

         if (!data_only) begin
           dfx_tap_util::prepend_array(instr_in, ir_array);
           dfx_tap_util::prepend_array(tap_nw_info.ir_in_l, ir_array);
           if (ir_name.exists(tu_i))
              tap_nw_info.ir_name = ir_name[tu_i];
           else
              tap_nw_info.ir_name = "UNKNOWN";
         end
      end

      if (have_instr_current || dr_in.exists(tu_i)) begin
        tap_found[tu_i] = 1'b1;
        if (~is_user_cmds)
           user_cmd[tu_i] = 1;

        // Ignore error and let it be a data-only transaction?
        if (!data_only && !have_instr_current)
          `ovm_error(get_type_name(), {"Zero size instruction opcode for TAP ", tu_i.name})

        if (!instr_only) begin
          if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED) begin
            if (dr_in[tu_i].size() > 0) begin
              if (~skip_dr_data) begin
//              if (ir_in.exists(tu_i) && dr_in[tu_i].size() != dr_array.size())
//                `ovm_warning(get_type_name(),
//                             $psprintf("compose(): data size supplied by user (%0d) does not match TAP %s specification",
//                                       dr_in[tu_i].size(), tu_i.name()))

                bit_ary = dr_in[tu_i];
                if ((tu_i == raw_mode_tap) | ~raw_mode_move) begin
                   dfx_tap_util::prepend_array(data_in, bit_ary);
                   dfx_tap_util::prepend_array(tap_nw_info.dr_in_l, bit_ary);
                end
                have_data = 1'b1;
                if (tu_i == raw_mode_tap) begin
                   skip_dr_data = 1;
                   `ovm_info(get_type_name(),
                           $psprintf("compose(): enabling RAW mode for TAP %s", tu_i.name()), OVM_MEDIUM)
                   skipped_dr_size = raw_mode_dr_size - dr_in[tu_i].size();
                end
              end
              else begin
                 skipped_dr_size += dr_in[tu_i].size();
                 `ovm_info(get_type_name(),
                       $psprintf("compose(): no data to shift in for TAP %s due to RAW mode (skipped dr size: %0d)", tu_i.name(), skipped_dr_size), OVM_MEDIUM)
              end
            end
            else begin
              if (use_ir_in_l)
                 `ovm_error(get_type_name(), {"No data specified for TAP ", tu_i.name})
              else begin
                if (dr_array.size() == 0)
                  `ovm_warning(get_type_name(),
                               $psprintf("compose(): data size either unknown or according to TAP %s specification is 0", tu_i.name()))
                else begin
                  if (!raw_mode_move) begin
                     dfx_tap_util::prepend_array(data_in, dr_array);
                     dfx_tap_util::prepend_array(tap_nw_info.dr_in_l, dr_array);
                  end
                  have_data = 1'b1;
                end
              end
            end
          end
          else begin
            `ovm_info(get_type_name(), $psprintf("compose(): TAP %s is excluded, no data scanned in", tu_i.name()), OVM_NONE)
            tap_nw_info.status = TAP_STATE_EXCLUDED;
          end
        end
      end
      else begin
        nw.tap_array[port][tu_i].tap_handle.ir_as_array(nw.tap_array[port][tu_i].tap_handle.bypass_instr, ir_array);

        tap_nw_info.ir_name = "BYPASS";

        if (!data_only) begin
          dfx_tap_util::prepend_array(instr_in, ir_array);
          dfx_tap_util::prepend_array(tap_nw_info.ir_in_l, ir_array);
        end

        if (!instr_only && !raw_mode_move) begin
          if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED) begin
            dfx_tap_util::prepend_array(data_in, bypass_data);
            dfx_tap_util::prepend_array(tap_nw_info.dr_in_l, bypass_data);
          end
          else
            tap_nw_info.status = TAP_STATE_EXCLUDED;
        end
      end
      if (user_cmd.exists(tu_i))
         tap_nw_info.user_cmd = 1;
      tapnw_l.push_back(tap_nw_info);
    end

    //adding IR/DR prefix. FIXME: support !have_instr & !have_data
    if (ir_prin.size() > 0) begin
       `ovm_info(get_type_name(), $psprintf("compose(): Adding IR prefix"), OVM_NONE)
       dfx_tap_util::prepend_array(instr_in, ir_prin);
    end
    if (dr_prin.size() > 0) begin
       `ovm_info(get_type_name(), $psprintf("compose(): Adding DR prefix"), OVM_NONE)
       dfx_tap_util::prepend_array(data_in, dr_prin);
    end
    if (raw_mode_full_shift && !raw_mode_move) begin
       if(skipped_dr_size > 0) begin
          bit_ary = new[skipped_dr_size];
          foreach(bit_ary[i])
             bit_ary[i] = 0;
          dfx_tap_util::prepend_array(data_in,bit_ary);
       end
    end

    foreach (ir_in[tu_i])
      if (!tap_found.exists(tu_i)) begin
        tap_u = dfx_tap_unit_e'(tu_i);
        if (locked_tap.exists(tap_u)) begin
          if (~locked_tap[tap_u])
            `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
        end
        else
            `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
      end

    foreach (dr_in[tu_i])
      if (!tap_found.exists(tu_i) && !ir_in.exists(tu_i)) begin
        tap_u = dfx_tap_unit_e'(tu_i);
        if (locked_tap.exists(tap_u)) begin
          if (~locked_tap[tap_u])
            `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
        end
        else
            `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
      end

    // Comment this out to get different behaviour - empty ir_in[] causes BYPASS instruction to be scanned into each
    // TAP.
    if (!have_instr) begin
      `ovm_info(get_type_name(), "compose(): skipping instruction scan", OVM_NONE)
      instr_in.delete(); // clear BYPASS instructions, if any
    end

    // Comment this out to get different behaviour - empty dr_in[] causes BYPASS data to be scanned into each TAP.
    if (!have_data) begin
      `ovm_info(get_type_name(), "compose(): skipping data scan", OVM_NONE)
      data_in.delete(); // clear BYPASS data, if any
    end

  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
    int isi = 0, // "isi" = instruction start index
        dsi = 0; // "dsi" = data start index
    int p_size = 0; // prefix size
    int ir_size = 0; // IR size
    int dr_size = 0; // DR size
    int shifted_dr_size = data_out.size();
    int remaining_data_size;
    bit tap_found[dfx_tap_unit_e];
    dfx_tap_unit_e tap_u, tu_i = tu_i.last();
    dfx_node_t bit_ary[];
    bit skip_dr_data = 0;
    dfx_tap_network nw = dfx_tap_network::get_handle();

    tu_i = tu_i.prev();
    while (tu_i != tu_i.last()) begin

      if (locked_tap.exists(tu_i))
        if (locked_tap[tu_i]) begin
          `ovm_info(get_type_name(),
                    $psprintf("decompose(): TAP %s is LOCKED, SKIPPING", tu_i.name()), OVM_LOW)
         tu_i = tu_i.prev();
         continue;
        end

      ir_size = 0;

      if (!nw.tap_effectively_isolated(tu_i, port)) begin

        if(use_ir_in_l) begin
          if (ir_in_l.exists(tu_i)) begin
            `ovm_info(get_type_name(), $psprintf("decompose(): Using instr_l flow"), OVM_NONE)
            ir_size = ir_in_l[tu_i].size();
            if (!data_only) begin
              if (ir_size > 0) begin
                dfx_tap_util::extract_array(instr_out, bit_ary, isi, ir_size);
                ti_out[tu_i] = bit_ary;
                ir_out[tu_i] = tap_ir_t'(0); // initialize all bits
                foreach (bit_ary[i])
                  ir_out[tu_i][i] = bit_ary[i];
              end
              else
                `ovm_error(get_type_name(), {"Zero size instruction opcode for TAP ", tu_i.name})
            end
          end
        end
        else begin
          if (ir_in.exists(tu_i)) begin
            tap_found[tu_i] = 1'b1;
            ir_size = nw.tap_array[port][tu_i].tap_handle.IR_length;
            if (!data_only) begin
              dfx_tap_util::extract_array(instr_out, bit_ary, isi, ir_size);
              ti_out[tu_i] = bit_ary;
              ir_out[tu_i] = tap_ir_t'(0); // initialize all bits
              foreach (bit_ary[i])
                ir_out[tu_i][i] = bit_ary[i];
            end
          end
        end

        if (dr_in.exists(tu_i)) begin
          tap_found[tu_i] = 1'b1;

          if (!instr_only)
            if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED) begin
              if (~skip_dr_data) begin
                if (tu_i == raw_mode_tap)
                   dr_size = raw_mode_dr_size;
                else
                   dr_size = dr_in[tu_i].size();
                remaining_data_size = shifted_dr_size - dsi;
                if (remaining_data_size < dr_size) begin
                   skip_dr_data = 1;
                end
                if (remaining_data_size > 0) begin
                  if (dr_in[tu_i].size() > 0) begin
                    if (skip_dr_data)
                      dfx_tap_util::extract_array(data_out, bit_ary, dsi, remaining_data_size);
                    else
                      dfx_tap_util::extract_array(data_out, bit_ary, dsi, dr_size);
                    dsi += dr_size;
                  end
                  else begin
                    `ovm_error(get_type_name(), {"No data specified for TAP ", tu_i.name})
//                   dfx_tap_util::extract_array(data_out, bit_ary, dsi, nw.tap_array[port][tu_i].tap_handle.dr_length(ir_in[tu_i]));
//                   dsi += nw.tap_array[port][tu_i].tap_handle.dr_length(ir_in[tu_i]);
                  end
                end
                else begin
                   bit_ary = new[0];
                end
              end
              else begin
                `ovm_info(get_type_name(), $psprintf("decompose(): Skipping TDO data extraction for TAP %s (RAW mode)", tu_i.name()), OVM_NONE)
                bit_ary = new[0];
              end

              td_out[tu_i] = bit_ary;
            end
        end
        else if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED)
          dsi += 1;

        if (ir_size == 0)
          ir_size = nw.tap_array[port][tu_i].tap_handle.IR_length;
        isi += ir_size;
      end

      tu_i = tu_i.prev();
    end

    //Extracting IR/DR prefixes. FIXME: support !have_instr & !have_data
    p_size = ir_prin.size();
    if (p_size > 0) begin
       `ovm_info(get_type_name(), $psprintf("decompose(): Extracting IR prefix (size: %d)", p_size) ,OVM_NONE)
       dfx_tap_util::extract_array(instr_out, bit_ary, isi, p_size);
       tpi_out = bit_ary;
       isi += p_size;
    end
    p_size = dr_prin.size();
    if (p_size > 0) begin
       `ovm_info(get_type_name(), $psprintf("decompose(): Extracting DR prefix (size: %d)", p_size) ,OVM_NONE)
       dfx_tap_util::extract_array(data_out, bit_ary, dsi, p_size);
       tpd_out = bit_ary;
       dsi += p_size;
    end

    foreach (ir_in[tu_i])
      if (!tap_found.exists(tu_i)) begin
        tap_u = dfx_tap_unit_e'(tu_i);
        `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
      end

  endfunction : decompose

endclass : dfx_tap_multiple_taps_transaction_b


// Multiple TAPs transaction
//
// Specify TAPs and instructions
// If data is not specified for a TAP, it is automatically created based upon the data length specification for that TAP
// Final TAP state after scan is Pause-DR
// (Final TAP state after instruction scan is Run-Test-Idle, and after data scan is Pause-DR)
//
class dfx_tap_multiple_taps_transaction_pause extends dfx_tap_multiple_taps_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_transaction_pause)

  function new(string name = "dfx_tap_multiple_taps_transaction_pause",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    dts = DFX_TAP_TS_PAUSE_DR;
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_PAUSE_DR;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_transaction_pause

// Multiple TAPs transaction - instructions only
//
// Specify TAPs and instructions
// Final TAP state after scan is unspecified
//
class dfx_tap_multiple_taps_instructions_only_transaction_fs extends dfx_tap_multiple_taps_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_instructions_only_transaction_fs)

  function new(string name = "dfx_tap_multiple_taps_instructions_only_transaction_fs",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    instr_only = 1'b1;
  endfunction : new

  constraint defaults2 {
    instr_only == 1'b1;
    data_only == 1'b0;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_instructions_only_transaction_fs

// Multiple TAPs transaction - instructions only
//
// Specify TAPs and instructions
// Final TAP state after scan is Run-Test-Idle
//
class dfx_tap_multiple_taps_instructions_only_transaction extends dfx_tap_multiple_taps_instructions_only_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_instructions_only_transaction)

  function new(string name = "dfx_tap_multiple_taps_instructions_only_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_instructions_only_transaction

// Multiple TAPs transaction - instructions only
//
// Specify TAPs and instructions
// Final TAP state after scan is Pause-IR
//
class dfx_tap_multiple_taps_instructions_only_transaction_pause extends dfx_tap_multiple_taps_instructions_only_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_instructions_only_transaction_pause)

  function new(string name = "dfx_tap_multiple_taps_instructions_only_transaction_pause",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    its = DFX_TAP_TS_PAUSE_IR;
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_PAUSE_IR;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_instructions_only_transaction_pause

// Multiple TAPs transaction - instructions only
//
// Specify TAPs and instructions
// Final TAP state after scan is E1-IR
//
class dfx_tap_multiple_taps_instructions_only_transaction_e1ir extends dfx_tap_multiple_taps_instructions_only_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_instructions_only_transaction_e1ir)

  function new(string name = "dfx_tap_multiple_taps_instructions_only_transaction_e1ir",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    its = DFX_TAP_TS_EXIT1_IR;
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_EXIT1_IR;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_instructions_only_transaction_e1ir

// Multiple TAPs transaction - data only (instructions may be specified but are not used)
//
// Specify TAPs and instructions
// Instructions are not scanned in
// If data is not specified for a TAP, it is automatically created based upon the data length specification for that TAP
// Final TAP state after scan is unspecified
//
class dfx_tap_multiple_taps_data_only_transaction_fs extends dfx_tap_multiple_taps_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_data_only_transaction_fs)

  function new(string name = "dfx_tap_multiple_taps_data_only_transaction_fs",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    data_only = 1'b1;
  endfunction : new

  constraint defaults2 {
    instr_only == 1'b0;
    data_only == 1'b1;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_data_only_transaction_fs

// Multiple TAPs transaction - data only (instructions may be specified but are not used)
//
// Specify TAPs and instructions
// Instructions are not scanned in
// If data is not specified for a TAP, it is automatically created based upon the data length specification for that TAP
// Final TAP state after scan is Run-Test-Idle
//
class dfx_tap_multiple_taps_data_only_transaction extends dfx_tap_multiple_taps_data_only_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_data_only_transaction)

  function new(string name = "dfx_tap_multiple_taps_data_only_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_data_only_transaction

// Multiple TAPs transaction - data only (instructions may be specified but are not used)
//
// Specify TAPs and instructions
// Instructions are not scanned in
// If data is not specified for a TAP, it is automatically created based upon the data length specification for that TAP
// Final TAP state after scan is Run-Test-Idle
//
class dfx_tap_multiple_taps_data_only_transaction_pause extends dfx_tap_multiple_taps_data_only_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_data_only_transaction_pause)

  function new(string name = "dfx_tap_multiple_taps_data_only_transaction_pause",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    dts = DFX_TAP_TS_PAUSE_DR;
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_PAUSE_DR;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_data_only_transaction_pause

// Multiple TAPs transaction - data only (instructions may be specified but are not used)
//
// Specify TAPs and instructions
// Instructions are not scanned in
// If data is not specified for a TAP, it is automatically created based upon the data length specification for that TAP
// Final TAP state after scan is E1-DR
//
class dfx_tap_multiple_taps_data_only_transaction_e1dr extends dfx_tap_multiple_taps_data_only_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_data_only_transaction_e1dr)

  function new(string name = "dfx_tap_multiple_taps_data_only_transaction_e1dr",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    dts = DFX_TAP_TS_EXIT1_DR;
  endfunction : new

  constraint defaults3 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_EXIT1_DR;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_data_only_transaction_e1dr

// Multiple TAPs transaction - no instructions specified or used
//
// Specify TAPs and data
// Final TAP state after scan is Run-Test-Idle
//
class dfx_tap_multiple_taps_no_instructions_transaction_fs extends dfx_tap_base_transaction;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  dfx_node_ary_t dr_in[dfx_tap_unit_e]; // array to hold DR arrays scanned in
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  dfx_node_ary_t td_out[dfx_tap_unit_e]; // scanned out data for the specified TAPs ("td" = tap data)
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_no_instructions_transaction_fs)

  function new(string name = "dfx_tap_multiple_taps_no_instructions_transaction_fs",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults {
    ts == DFX_TAP_TS_RTI;
    instr_in.size() == 0;
    data_in.size() == 0;
    assert_trst == 1'b0;
    tms_in.size() == 0;
    tdi_in.size() == 0;
  } // in case of randomization

  function void do_print(ovm_printer printer);
    dfx_tap_unit_e tap_u;
    dfx_node_t bit_ary[];

    // if (my_verbosity < OVM_HIGH)
    if (m_sequencer.get_report_verbosity_level() < OVM_HIGH)
      return;

    super.do_print(printer);

    foreach (dr_in[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      bit_ary = dr_in[tu_i];
      printer.print_array_header({"dr_in for TAP ", tap_u.name()}, bit_ary.size());

      foreach (bit_ary[i])
        printer.print_field($psprintf("dr_in[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX);

      printer.print_array_footer();
    end

    foreach (td_out[tu_i]) begin
      tap_u = dfx_tap_unit_e'(tu_i);
      bit_ary = td_out[tu_i];
      printer.print_array_header({"td_out for TAP ", tap_u.name()}, bit_ary.size());

      foreach (bit_ary[i])
        printer.print_field($psprintf("td_out[%0d]", i), bit_ary[i], $bits(bit_ary[i]), OVM_HEX);

      printer.print_array_footer();
    end
  endfunction : do_print

  virtual function void compose(dfx_tap_port_e port);
    bit tap_found[dfx_tap_unit_e], have_data = 1'b0;
    dfx_node_t dr_array[];
    dfx_node_t bit_ary[];
    dfx_tap_unit_e tap_u;
    dfx_tap_network nw = dfx_tap_network::get_handle();

    for (dfx_tap_unit_e tu_i = tu_i.first(); tu_i != NUM_TAPS; tu_i = tu_i.next()) begin
      if (nw.tap_effectively_isolated(tu_i, port))
        continue;

      if (dr_in.exists(tu_i)) begin
        tap_found[tu_i] = 1'b1;

        if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED) begin
          if (dr_in[tu_i].size() > 0) begin
            bit_ary = dr_in[tu_i];
            dfx_tap_util::prepend_array(data_in, bit_ary);
            have_data = 1'b1;
          end
          else
            `ovm_warning(get_type_name(), $psprintf("compose(): no data supplied for TAP %s", tu_i.name()))
        end
        else
          `ovm_info(get_type_name(), $psprintf("compose(): TAP %s is excluded, no data scanned in", tu_i.name()), OVM_FULL)
      end
      else if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED)
        dfx_tap_util::prepend_array(data_in, bypass_data);
    end

    foreach (dr_in[tu_i])
      if (!tap_found.exists(tu_i)) begin
        tap_u = dfx_tap_unit_e'(tu_i);
        `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
      end

    if (!have_data) begin
      `ovm_info(get_type_name(), "compose(): skipping data scan", OVM_FULL)
      data_in.delete(); // clear BYPASS data, if any
    end

  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
    int dsi = 0; // "dsi" = data start index
    bit tap_found[dfx_tap_unit_e];
    dfx_tap_unit_e tap_u, tu_i = tu_i.last();
    dfx_node_t bit_ary[];
    dfx_tap_network nw = dfx_tap_network::get_handle();

    tu_i = tu_i.prev();
    while (tu_i != tu_i.last()) begin
      if (!nw.tap_effectively_isolated(tu_i, port)) begin
        if (dr_in.exists(tu_i)) begin
          tap_found[tu_i] = 1'b1;

          if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED) begin
            dfx_tap_util::extract_array(data_out, bit_ary, dsi, dr_in[tu_i].size());
            dsi += dr_in[tu_i].size();
            td_out[tu_i] = bit_ary;
          end
        end
        else if (nw.tap_array[port][tu_i].e_tap_state != TAP_STATE_EXCLUDED)
          dsi += 1;
      end

      tu_i = tu_i.prev();
    end

    foreach (dr_in[tu_i])
      if (!tap_found.exists(tu_i)) begin
        tap_u = dfx_tap_unit_e'(tu_i);
        `ovm_error(get_type_name(), $psprintf("TAP %s not on %s port or is isolated", tap_u.name(), port.name()))
      end

  endfunction : decompose

endclass : dfx_tap_multiple_taps_no_instructions_transaction_fs

// Multiple TAPs transaction - no instructions specified or used
//
// Specify TAPs and data
// Final TAP state after scan is Run-Test-Idle
//
class dfx_tap_multiple_taps_no_instructions_transaction extends dfx_tap_multiple_taps_no_instructions_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_no_instructions_transaction)

  function new(string name = "dfx_tap_multiple_taps_no_instructions_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults2 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_no_instructions_transaction

// Multiple TAPs transaction - no instructions specified or used
//
// Specify TAPs and data
// Final TAP state after scan is Run-Test-Idle
//
class dfx_tap_multiple_taps_no_instructions_transaction_pause extends dfx_tap_multiple_taps_no_instructions_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_multiple_taps_no_instructions_transaction_pause)

  function new(string name = "dfx_tap_multiple_taps_no_instructions_transaction_pause",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    dts = DFX_TAP_TS_PAUSE_DR;
  endfunction : new

  constraint defaults2 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_PAUSE_DR;
  } // in case of randomization

endclass : dfx_tap_multiple_taps_no_instructions_transaction_pause

// Raw transaction, unspecified final TAP instruction/data states
//
// Specify data and instruction to be scanned in when in the SHIFT_IR/DR state
// Final TAP state after instruction scan is unspecified, and after data scan is unspecified
//
class dfx_tap_raw_tap_transaction_fs extends dfx_tap_base_transaction;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_raw_tap_transaction_fs)

  function new(string name = "dfx_tap_raw_tap_transaction_fs",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults {
    ts == DFX_TAP_TS_RTI;
    assert_trst == 1'b0;
    tms_in.size() == 0;
    tdi_in.size() == 0;
  } // in case of randomization

  // Nothing to do in this class - the user passes in raw streams using instr_in[] and data_in[] arrays, and gets back raw
  // streams in instr_out[] and data_out[] arrays.

  virtual function void compose(dfx_tap_port_e port);
  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
  endfunction : decompose

endclass : dfx_tap_raw_tap_transaction_fs

// Raw transaction - instruction only
//
// Specify instruction to be scanned in when in the SHIFT_IR state
// Final TAP state after instruction scan is unspecified
//
class dfx_tap_raw_tap_transaction_instr_fs extends dfx_tap_raw_tap_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // instr_in[]
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // instr_out[]
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_raw_tap_transaction_instr_fs)

  function new(string name = "dfx_tap_raw_tap_transaction_instr_fs",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults2 {
    dts == DFX_TAP_TS_RTI; // doesn't matter
    data_in.size() == 0;
  } // in case of randomization

  // Nothing to do in this class - the user passes in a raw stream using instr_in[] array, and gets back a raw stream in
  // instr_out[] array.

  virtual function void compose(dfx_tap_port_e port);
  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
  endfunction : decompose

endclass : dfx_tap_raw_tap_transaction_instr_fs

// Raw transaction - data only
//
// Specify data to be scanned in when in the SHIFT_DR state
// Final TAP state after data scan is unspecified
//
class dfx_tap_raw_tap_transaction_data_fs extends dfx_tap_raw_tap_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // data_in[]
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // data_out[]
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_raw_tap_transaction_data_fs)

  function new(string name = "dfx_tap_raw_tap_transaction_data_fs",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults2 {
    its == DFX_TAP_TS_RTI; // doesn't matter
    instr_in.size() == 0;
  } // in case of randomization

  // Nothing to do in this class - the user passes in a raw stream using data_in[] array, and gets back a raw stream in
  // data_out[] array.

  virtual function void compose(dfx_tap_port_e port);
  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
  endfunction : decompose

endclass : dfx_tap_raw_tap_transaction_data_fs

// Raw transaction
//
// Specify data and instruction to be scanned in when in the SHIFT_IR/DR state
// Final TAP state after scan is Run-Test-Idle
// (Final TAP state after instruction scan is Run-Test-Idle, and after data scan is Run-Test-Idle)
//
class dfx_tap_raw_tap_transaction extends dfx_tap_raw_tap_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // instr_in[], data_in[]
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // instr_out[], data_out[]
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_raw_tap_transaction)

  function new(string name = "dfx_tap_raw_tap_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults2 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_RTI;
  } // in case of randomization

  // Nothing to do in this class - the user passes in raw streams using instr_in[] and data_in[] arrays, and gets back raw
  // streams in instr_out[] and data_out[] arrays.

  virtual function void compose(dfx_tap_port_e port);
  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
  endfunction : decompose

endclass : dfx_tap_raw_tap_transaction

// Raw transaction
//
// Specify data and instruction to be scanned in when in the SHIFT_IR/DR state
// Final TAP state after scan is Pause-DR
// (Final TAP state after instruction scan is Run-Test-Idle, and after data scan is Pause-DR)
//
class dfx_tap_raw_tap_transaction_pause extends dfx_tap_raw_tap_transaction_fs;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // instr_in[], data_in[]
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // instr_out[], data_out[]
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_raw_tap_transaction_pause)

  function new(string name = "dfx_tap_raw_tap_transaction_pause",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);

    dts = DFX_TAP_TS_PAUSE_DR;
  endfunction : new

  constraint defaults2 {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_PAUSE_DR;
  } // in case of randomization

  // Nothing to do in this class - the user passes in raw streams using instr_in[] and data_in[] arrays, and gets back raw
  // streams in instr_out[] and data_out[] arrays.

  virtual function void compose(dfx_tap_port_e port);
  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
  endfunction : decompose

endclass : dfx_tap_raw_tap_transaction_pause

// TMS transaction
//
// Specify TMS and TDI to be scanned in
// Final TAP state depends upon the TMS stream
//
class dfx_tap_tms_tap_transaction extends dfx_tap_base_transaction;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // ts, assert_trst, tms_in[], tdi_in[]
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // tdo_out[]
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_tms_tap_transaction)

  function new(string name = "dfx_tap_tms_tap_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults {
    its == DFX_TAP_TS_RTI;
    dts == DFX_TAP_TS_RTI;
    instr_in.size() == 0;
    data_in.size() == 0;
    tms_in.size() == tdi_in.size();
  } // in case of randomization

  // Nothing to do in this class - the user passes in raw streams using tms_in[] and tdi_in[] arrays, and gets back a
  // raw stream in tdo_out[] array.

  // It is assumed that TMS and TDI and TDO arrays are all the same size.
  //
  // Another possible approach (not used here): only TDI and TDO arrays are the same size, possibly smaller than the TMS
  // array, with TDI/TDO bits being scanned in/out the DUT only when the TAP FSM is in SHIFT_IR or SHIFT_DR state.

  virtual function void compose(dfx_tap_port_e port);
    if (tms_in.size() != tdi_in.size())
      `ovm_error(get_type_name(), "TMS and TDI sizes are not equal")
  endfunction : compose

  virtual function void decompose(dfx_tap_port_e port);
    if (tdo_out.size() != tdi_in.size())
      `ovm_error(get_type_name(), "TDI and TDO sizes are not equal")
  endfunction : decompose

endclass : dfx_tap_tms_tap_transaction

// PowerGood (Initial State) transaction
//
// Reset TAP driver to PowerGood (Initial) state
// Specify number of times to clock TCK via size of tms_in[]
// Final TAP state depends upon the default/specified initial state
//
class dfx_tap_powergood_transaction extends dfx_tap_base_transaction;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // None
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // None
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_powergood_transaction)

  function new(string name = "dfx_tap_powergood_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults {
    its == DFX_TAP_TS_RTI; // N/A
    dts == DFX_TAP_TS_RTI; // N/A
    ts == DFX_TAP_TS_RTI; // N/A
    instr_in.size() == 0; // N/A
    data_in.size() == 0; // N/A
    assert_trst == 1'b0; // N/A
    tms_in.size() == 0; // allow user control?  define a new field instead?
    tdi_in.size() == 0; // N/A
  } // in case of randomization

endclass : dfx_tap_powergood_transaction

// Mode-setting transaction
//
// Set driver mode - 4-pin, 2-pin, etc.
//
class dfx_tap_scan_mode_transaction extends dfx_tap_base_transaction;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  rand dfx_tap_scan_format_e scan_format = TAP_SCAN_NORMAL; // default is 4-pin
  rand bit sredge = 1'b0; // if 1'b1, sample TDO value on falling edge of TCK (when in 2-pin mode)
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // None
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils_begin(dfx_tap_scan_mode_transaction)
    `ovm_field_enum(dfx_tap_scan_format_e, scan_format, OVM_DEFAULT)
  `ovm_object_utils_end


  function new(string name = "dfx_tap_scan_mode_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults {
    its == DFX_TAP_TS_RTI; // N/A
    dts == DFX_TAP_TS_RTI; // N/A
    ts == DFX_TAP_TS_RTI; // N/A
    instr_in.size() == 0; // N/A
    data_in.size() == 0; // N/A
    assert_trst == 1'b0; // N/A
    tms_in.size() == 0; // N/A
    tdi_in.size() == 0; // N/A
  } // in case of randomization

endclass : dfx_tap_scan_mode_transaction

// Escape Sequence transaction (needed for cJTAG)
//
// Hold TCK high and clock TMS at half the frquency of TCK.  Therefore, TMS is clocked as follows:
//    @(posedge ungated_TCK) TMS = tms_in[0]
//    @(posedge ungated_TCK) TMS = tms_in[1]
//    @(posedge ungated_TCK) TMS = tms_in[2]
//    ... and so on
//
class dfx_tap_escape_sequence_transaction extends dfx_tap_base_transaction;

  /************************************************************************************************************************
   * BEGIN - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/
  // See the base class
  // tms_in[]
  /************************************************************************************************************************
   * END - Fields that can be set by a sequence when using this transaction type
   ************************************************************************************************************************/

  /************************************************************************************************************************
   * BEGIN - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/
  // None
  /************************************************************************************************************************
   * END - Fields that can be read by a sequence when using this transaction type
   ************************************************************************************************************************/

  `ovm_object_utils(dfx_tap_escape_sequence_transaction)

  function new(string name = "dfx_tap_escape_sequence_transaction",
               ovm_sequencer_base sequencer = null,
               ovm_sequence parent_seq = null);
    super.new(name, sequencer, parent_seq);
  endfunction : new

  constraint defaults {
    its == DFX_TAP_TS_RTI; // N/A
    dts == DFX_TAP_TS_RTI; // N/A
    ts == DFX_TAP_TS_RTI; // N/A
    instr_in.size() == 0; // N/A
    data_in.size() == 0; // N/A
    assert_trst == 1'b0; // N/A
    tdi_in.size() == 0; // N/A
  } // in case of randomization

  // Nothing to do in this class - the user passes in a TMS stream using tms_in[].

endclass : dfx_tap_escape_sequence_transaction

`endif // `ifndef DFX_TAP_TRANSACTION_SV
