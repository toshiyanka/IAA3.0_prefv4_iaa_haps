// =====================================================================================================
// FileName          : dfx_tap_any.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Mon Nov  1 13:45:46 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// Base class for TAPs
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_ANY_SV
`define DFX_TAP_ANY_SV

// Configuration item structure used for enabling/disabling TAPs on the TAP network
//
typedef struct {
  dfx_tap_unit_e ci_tap;
  dfx_tap_port_e ci_port;
  dfx_tap_state_e ci_state;
} cfg_item_s;

typedef cfg_item_s ciq_t[$]; // queue of TAP-port-state triples

virtual class dfx_tap_any extends ovm_object;

  dfx_tap_unit_e this_tap;
  int IR_length; // default value could be 8
  dfx_node_t [31 : 0] IDCODE_VALUE;
  string tapSecurity; //TAP Security level
  int wait_cycles = 0;
  bit use_override = 1'b0; // use TAPC_SELECT_OVR instruction
  tap_ir_t bypass_instr = `TAP_BYPASS_INSTR;
  ovm_verbosity my_verbosity = OVM_LOW;
  int print_once = 1;

  function new(string name = "dfx_tap_any");
    super.new(name);

    if (!$cast(my_verbosity, ovm_top.get_report_verbosity_level()))
      `ovm_fatal("dfx_tap_any", "OVM verbosity not a valid enum value")
  endfunction : new

  virtual function tap_ir_t opcode_value(string opcode_str);
    // opcode_value = tap_ir_t'(0); // some value
    `ovm_fatal(get_type_name(), {"The function opcode_value() has not been defined for ", this_tap.name})
  endfunction : opcode_value

  function tap_ir_t idcode_opcode;
    idcode_opcode = opcode_value("IDCODE");

    // Do the right thing for slave TAPs.
    if (idcode_opcode == 0)
      idcode_opcode = opcode_value("SLVIDCODE");
  endfunction : idcode_opcode

  virtual function void set_idcode_value;
    // Definition of this function in the actual TAP class is necessary *only* in case of multiple instantiations of the
    // TAP class (such as CPU TAP).
  endfunction : set_idcode_value

  function dfx_node_t [31 : 0] idcode_value;
    idcode_value = IDCODE_VALUE;
  endfunction : idcode_value

  pure virtual function int dr_length(tap_ir_t opcode);

  // The order of the bits in "ir_array" is scan order:
  //
  //   ir_array[0] is scanned in first
  //   ir_array[1] is scanned in next
  //   ... and so on
  //
  // This is true for all such functions.
  //
  function void ir_as_array(tap_ir_t opcode, ref dfx_node_t ir_array[]);
    dfx_node_t local_array[];

    local_array = {<< {opcode}};
    ir_array = new[IR_length](local_array);
  endfunction : ir_as_array

  // The order of the bits in "dr_array" is scan order:
  //
  //   dr_array[0] is scanned in first
  //   dr_array[1] is scanned in next
  //   ... and so on
  //
  // This is true for all such functions.
  //
  pure virtual function void dr_as_array(tap_ir_t opcode, ref dfx_node_t dr_array[]);

  function void ir_dr_as_array(tap_ir_t opcode, ref dfx_node_t ir_array[], ref dfx_node_t dr_array[]);
    ir_as_array(opcode, ir_array);
    dr_as_array(opcode, dr_array);
  endfunction : ir_dr_as_array

  // Only 2 ports are supported because the TAP standard only allows 1 bit to represent the port.  But the secondary
  // port could really be an arbitrary port (secondary, tertiary, etc.) on the chip - it's secondary only for the
  // controlling TAP.
  //
  function void get_port_change_ir_dr(const ref ciq_t ciq, output tap_ir_t opcode, ref dfx_node_ary_t dr_array);
    if ((opcode = opcode_value("TAPC_SEL_SEC")) == tap_ir_t'(0))
      `ovm_fatal(get_type_name(), {"The opcode string \"TAPC_SEL_SEC\" has not been defined for ", this_tap.name})

    dr_array = new[ciq.size()];
    for (int i = 0; i < ciq.size(); i++)
      if (ciq[i].ci_port == TAP_PORT_P0)
        dr_array[i] = 1'b0;
      else /* if (ciq[i].ci_port == TAP_PORT_P1) */
        dr_array[i] = 1'b1;
  endfunction : get_port_change_ir_dr

  function void get_state_change_ir_dr(const ref ciq_t ciq, output tap_ir_t opcode, ref dfx_node_ary_t dr_array);
    if ((opcode = use_override ? opcode_value("TAPC_SELECT_OVR") : opcode_value("TAPC_SELECT")) == tap_ir_t'(0))
      `ovm_fatal(get_type_name(),
                 {"The opcode string \"TAPC_SELECT\" or \"TAPC_SELECT_OVR\" has not been defined for ", this_tap.name})

    dr_array = new[ciq.size() * 2];
    for (int i = 0; i < ciq.size(); i++)
      if (ciq[i].ci_state == TAP_STATE_NORMAL) begin
        dr_array[i * 2] = 1'b1;
        dr_array[i * 2 + 1] = 1'b0;
      end
      else if (ciq[i].ci_state == TAP_STATE_EXCLUDED) begin
        dr_array[i * 2] = 1'b0;
        dr_array[i * 2 + 1] = 1'b1;
      end
      else if (ciq[i].ci_state == TAP_STATE_ISOLATED) begin
        dr_array[i * 2] = 1'b0;
        dr_array[i * 2 + 1] = 1'b0;
      end

  endfunction : get_state_change_ir_dr

  function void get_wtap_config_ir_dr(const ref ciq_t ciq, output tap_ir_t opcode, ref dfx_node_ary_t dr_array);
    if ((opcode = opcode_value("TAPC_WTAP_SEL")) == tap_ir_t'(0))
      `ovm_fatal(get_type_name(), {"The opcode string \"TAPC_WTAP_SEL\" has not been defined for ", this_tap.name})

    dr_array = new[ciq.size()];
    for (int i = 0; i < ciq.size(); i++)
      if (ciq[i].ci_state == TAP_STATE_NORMAL)
        dr_array[i] = 1'b1;
      else if (ciq[i].ci_state == TAP_STATE_ISOLATED)
        dr_array[i] = 1'b0;
  endfunction : get_wtap_config_ir_dr

  function void do_print(ovm_printer printer);

    if (my_verbosity < OVM_HIGH)
      return;

    super.do_print(printer);

    if (wait_cycles && print_once)
      printer.print_field("wait_cycles", wait_cycles, $bits(wait_cycles), OVM_DEC);

    if (use_override && print_once)
      printer.print_field("use TAPC_SELECT_OVR instruction", use_override, $bits(use_override), OVM_DEC);
  endfunction : do_print

  virtual function void set_tap_security;
    `ovm_fatal(get_type_name(), {"The function set_tap_security()() has not been defined for ", this_tap.name})
  endfunction : set_tap_security

  function string tap_security;
    tap_security = tapSecurity;
  endfunction : tap_security

  virtual function string reg_irsecurity(tap_ir_t opcode);
    `ovm_fatal(get_type_name(), {"The function reg_irsecurity() has not been defined for ", this_tap.name})
  endfunction : reg_irsecurity

  virtual function void default_value(tap_ir_t opcode, ref dfx_node_t defaultval_array[]);
    `ovm_fatal(get_type_name(), {"The function default_value() has not been defined for ", this_tap.name})
  endfunction : default_value

  virtual function void mask(tap_ir_t opcode, ref dfx_node_t mask_array[]);
    `ovm_fatal(get_type_name(), {"The function mask() has not been defined for ", this_tap.name})
  endfunction : mask

  virtual function void cmpmask(tap_ir_t opcode, ref dfx_node_t mask_array[]);
    `ovm_fatal(get_type_name(), {"The function cmpmask has not been defined for ", this_tap.name})
  endfunction : cmpmask

endclass : dfx_tap_any

// Use num() or size() for _dr_length.
//
`define do_print_function \
  function void do_print(ovm_printer printer); \
    ir_code_e opcode; \
    super.do_print(printer); \
    if (my_verbosity < OVM_HIGH) \
      return; \
    if (!print_once) \
      return; \
    print_once--; \
    if (_dr_length.size()) begin \
      printer.print_array_header("_dr_length", _dr_length.size()); \
      foreach (_dr_length[i]) begin \
        opcode = ir_code_e'(i); \
        printer.print_field($psprintf("_dr_length[%s]", opcode.name()), _dr_length[i], \
                            $bits(_dr_length[i]), OVM_DEC); \
      end \
      printer.print_array_footer(); \
    end \
  endfunction : do_print

`define dr_length_function \
  virtual function int dr_length(tap_ir_t opcode); \
    if (_dr_length.exists(opcode)) \
      return _dr_length[opcode]; \
    else \
      return 0; \
  endfunction : dr_length

`define dr_as_array_function \
  virtual function void dr_as_array(tap_ir_t opcode, ref dfx_node_t dr_array[]); \
    dr_array = new[dr_length(opcode)]; \
    foreach (dr_array[i]) \
      dr_array[i] = 1'b0; \
  endfunction : dr_as_array

`define dr_functions \
  `do_print_function \
  `dr_length_function \
  `dr_as_array_function

`define reg_irsecurity_function \
  virtual function string reg_irsecurity(tap_ir_t opcode); \
    if (_reg_irsecurity.exists(opcode)) \
      return _reg_irsecurity[opcode]; \
    else \
      return ""; \
  endfunction : reg_irsecurity

`define default_value_function \
  virtual function void default_value(tap_ir_t opcode, ref dfx_node_t defaultval_array[]); \
    if (_reg_default.exists(opcode)) begin \
      defaultval_array = new[dr_length(opcode)]; \
      foreach (defaultval_array[i]) \
        defaultval_array[i] = _reg_default[opcode][i]; \
    end \
  endfunction : default_value

//Only RO bits are masked
`define mask_function \
  virtual function void mask(tap_ir_t opcode, ref dfx_node_t mask_array[]); \
    if (_reg_mask.exists(opcode)) begin \
      mask_array = new[dr_length(opcode)]; \
      foreach (mask_array[i]) \
        mask_array[i] = _reg_mask[opcode][i]; \
    end \
  endfunction : mask

//RSVD and RO bits are masked
`define cmpmask_function \
  virtual function void cmpmask(tap_ir_t opcode, ref dfx_node_t mask_array[]); \
    if (_reg_cmpmask.exists(opcode)) begin \
      mask_array = new[dr_length(opcode)]; \
      foreach (mask_array[i]) \
        mask_array[i] = _reg_cmpmask[opcode][i]; \
    end \
  endfunction : cmpmask

`endif // `ifndef DFX_TAP_ANY_SV
