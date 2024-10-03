// =====================================================================================================
// FileName          : JtagBfmSequences.sv
// Primary Contact   : asingh7
// Secondary Contact : dgkaria, psharm3
// Creation Date     : 2015
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// Base class for SEG type API sequences.
// Compatibility layer for Austin TAP TB.
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================


`ifndef JTAGBFMSEQUENCES_SV
`define JTAGBFMSEQUENCES_SV

class JtagBfmSequences #(type T = ovm_sequence_item) extends ovm_sequence #(T);

  static rand dfx_tap_unit_e my_tap;
  static rand dfx_tap_port_e my_port = TAP_PORT_P0;
  static rand byte unsigned assume_single_tap = 0; // default behaviour is raw TAP transaction
  static virtual dfx_jtag_if.ENV jtag_if;
  // static int once_only = 1;
  static dfx_node_t TapRoutingTable [dfx_tapfsm_state_e][dfx_tapfsm_state_e];

  `ovm_sequence_utils_begin(JtagBfmSequences, JtagBfmSequencer)
  `ovm_sequence_utils_end

  dfx_node_ary_t ary;
  logic flag;
  logic [SIZE_OF_IR_REG-1:0] irTdo;
  logic [TOTAL_DATA_REGISTER_WIDTH-1:0] drTdo;
  JtagBfmSeqDrvPkt Packet;
  dfx_tap_multiple_taps_instructions_only_transaction_pause  ireq_pause;// final state after IR is Pause-IR
  dfx_tap_multiple_taps_instructions_only_transaction      ireq;      // final state after IR is RTIDLE
  dfx_tap_multiple_taps_instructions_only_transaction_e1ir   ireq_e1ir; // final state after IR is E1-IR

  dfx_tap_multiple_taps_data_only_transaction              dreq;      // final state after DR is RTIDLE
  dfx_tap_multiple_taps_data_only_transaction_pause        dreq_pause;// final state after DR is Pause-DR //
  dfx_tap_multiple_taps_data_only_transaction_e1dr         dreq_e1dr; // final state after DR is E1-DR

  dfx_tap_raw_tap_transaction_pause                          rreqPause;
  dfx_tap_raw_tap_transaction                                rreq;
  dfx_tap_raw_tap_transaction_data_fs rreqi;
  dfx_tap_raw_tap_transaction_data_fs rreqd;

  dfx_tap_multiple_taps_transaction mtt;
  dfx_tap_multiple_taps_transaction_pause mttp;

  string ClassName = "JtagBfmSequences";

  function new(string name = "JtagBfmSequences");
    super.new(name);

    // Initialize static variables

    // TAP ROUTING TABLE
    // Source:
    // CS/NS TLRS RUTI SeDR CaDR ShDR E1DR PaDR E2DR UpDR SeIR CaIR ShIR E1IR PaIR E2IR UpIR
    // TLRS     1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    // RUTI     1    0    1    1    1    1    1    1    1    1    1    1    1    1    1    1
    // SeDR     1    1    x    0    0    0    0    0    0    1    1    1    1    1    1    1
    // CaDR     1    1    1    x    0    1    1    1    1    1    1    1    1    1    1    1
    // ShDR     1    1    1    1    0    1    1    1    1    1    1    1    1    1    1    1
    // E1DR     1    1    1    1    0    x    0    0    1    1    1    1    1    1    1    1
    // PaDR     1    1    1    1    1    1    0    1    1    1    1    1    1    1    1    1
    // E2DR     1    1    1    1    0    0    0    x    1    1    1    1    1    1    1    1
    // UpDR     1    0    1    1    1    1    1    1    x    1    1    1    1    1    1    1
    // SeIR     1    1    1    1    1    1    1    1    1    x    0    0    0    0    0    0
    // CaIR     1    1    1    1    1    1    1    1    1    1    x    0    1    1    1    1
    // ShIR     1    1    1    1    1    1    1    1    1    1    1    0    1    1    1    1
    // E1IR     1    1    1    1    1    1    1    1    1    1    1    0    x    0    0    1
    // PaIR     1    1    1    1    1    1    1    1    1    1    1    1    1    0    1    1
    // E2IR     1    1    1    1    1    1    1    1    1    1    1    0    0    0    x    1
    // UpIR     1    0    1    1    1    1    1    1    1    1    1    1    1    1    1    x
    TapRoutingTable[DFX_TAP_TS_TLR         ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:0, DFX_TAP_TS_SELECT_DR:0, DFX_TAP_TS_CAPTURE_DR:0, DFX_TAP_TS_SHIFT_DR:0, DFX_TAP_TS_EXIT1_DR:0, DFX_TAP_TS_PAUSE_DR:0, DFX_TAP_TS_EXIT2_DR:0, DFX_TAP_TS_UPDATE_DR:0, DFX_TAP_TS_SELECT_IR:0, DFX_TAP_TS_CAPTURE_IR:0, DFX_TAP_TS_SHIFT_IR:0, DFX_TAP_TS_EXIT1_IR:0, DFX_TAP_TS_PAUSE_IR:0, DFX_TAP_TS_EXIT2_IR:0, DFX_TAP_TS_UPDATE_IR:0};
    TapRoutingTable[DFX_TAP_TS_RTI         ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:0, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:1, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:1, DFX_TAP_TS_EXIT2_DR:1, DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:1, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:1, DFX_TAP_TS_EXIT2_IR:1, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_SELECT_DR ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1,/*x*/ DFX_TAP_TS_CAPTURE_DR:0, DFX_TAP_TS_SHIFT_DR:0, DFX_TAP_TS_EXIT1_DR:0, DFX_TAP_TS_PAUSE_DR:0, DFX_TAP_TS_EXIT2_DR:0, DFX_TAP_TS_UPDATE_DR:0, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:1, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:1, DFX_TAP_TS_EXIT2_IR:1, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_CAPTURE_DR] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1, DFX_TAP_TS_SELECT_DR:1, /*DFX_TAP_TS_CAPTURE_DR:x,*/ DFX_TAP_TS_SHIFT_DR:0, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:1, DFX_TAP_TS_EXIT2_DR:1, DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:1, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:1, DFX_TAP_TS_EXIT2_IR:1, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_SHIFT_DR  ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:0, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:1, DFX_TAP_TS_EXIT2_DR:1, DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:1, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:1, DFX_TAP_TS_EXIT2_IR:1, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_EXIT1_DR  ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:0, /*DFX_TAP_TS_EXIT1_DR:x,*/ DFX_TAP_TS_PAUSE_DR:0, DFX_TAP_TS_EXIT2_DR:0, DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:1, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:1, DFX_TAP_TS_EXIT2_IR:1, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_PAUSE_DR  ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:1, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:0, DFX_TAP_TS_EXIT2_DR:1, DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:1, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:1, DFX_TAP_TS_EXIT2_IR:1, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_EXIT2_DR  ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:0, DFX_TAP_TS_EXIT1_DR:0, DFX_TAP_TS_PAUSE_DR:0, /*DFX_TAP_TS_EXIT2_DR:x,*/ DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:1, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:1, DFX_TAP_TS_EXIT2_IR:1, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_UPDATE_DR ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:0, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:1, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:1, DFX_TAP_TS_EXIT2_DR:1, /*DFX_TAP_TS_UPDATE_DR:x,*/ DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:1, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:1, DFX_TAP_TS_EXIT2_IR:1, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_SELECT_IR ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:1, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:1, DFX_TAP_TS_EXIT2_DR:1, DFX_TAP_TS_UPDATE_DR:1, /*DFX_TAP_TS_SELECT_IR:x,*/ DFX_TAP_TS_CAPTURE_IR:0, DFX_TAP_TS_SHIFT_IR:0, DFX_TAP_TS_EXIT1_IR:0, DFX_TAP_TS_PAUSE_IR:0, DFX_TAP_TS_EXIT2_IR:0, DFX_TAP_TS_UPDATE_IR:0};
    TapRoutingTable[DFX_TAP_TS_CAPTURE_IR] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:1, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:1, DFX_TAP_TS_EXIT2_DR:1, DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, /*DFX_TAP_TS_CAPTURE_IR:x,*/ DFX_TAP_TS_SHIFT_IR:0, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:1, DFX_TAP_TS_EXIT2_IR:1, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_SHIFT_IR  ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:1, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:1, DFX_TAP_TS_EXIT2_DR:1, DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:0, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:1, DFX_TAP_TS_EXIT2_IR:1, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_EXIT1_IR  ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:1, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:1, DFX_TAP_TS_EXIT2_DR:1, DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:0, /*DFX_TAP_TS_EXIT1_IR:x,*/ DFX_TAP_TS_PAUSE_IR:0, DFX_TAP_TS_EXIT2_IR:0, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_PAUSE_IR  ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:1, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:1, DFX_TAP_TS_EXIT2_DR:1, DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:1, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:0, DFX_TAP_TS_EXIT2_IR:1, DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_EXIT2_IR  ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:1, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:1, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:1, DFX_TAP_TS_EXIT2_DR:1, DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:0, DFX_TAP_TS_EXIT1_IR:0, DFX_TAP_TS_PAUSE_IR:0, /*DFX_TAP_TS_EXIT2_IR:x,*/ DFX_TAP_TS_UPDATE_IR:1};
    TapRoutingTable[DFX_TAP_TS_UPDATE_IR ] = {DFX_TAP_TS_TLR:1, DFX_TAP_TS_RTI:0, DFX_TAP_TS_SELECT_DR:1, DFX_TAP_TS_CAPTURE_DR:1, DFX_TAP_TS_SHIFT_DR:1, DFX_TAP_TS_EXIT1_DR:1, DFX_TAP_TS_PAUSE_DR:1, DFX_TAP_TS_EXIT2_DR:1, DFX_TAP_TS_UPDATE_DR:1, DFX_TAP_TS_SELECT_IR:1, DFX_TAP_TS_CAPTURE_IR:1, DFX_TAP_TS_SHIFT_IR:1, DFX_TAP_TS_EXIT1_IR:1, DFX_TAP_TS_PAUSE_IR:1, DFX_TAP_TS_EXIT2_IR:1/*, DFX_TAP_TS_UPDATE_IR:x*/};

    endfunction : new

  //---------------------------------------------------------
  // get_interface()
  //---------------------------------------------------------
  function void get_interface();
    ovm_object o_obj;
    dfx_vif_container #(virtual dfx_jtag_if) jtag_vif;
    string s;

    // if (!once_only) return; // port may change with different invocations!

    // my_port = p_sequencer.port;

    `ovm_info(get_type_name(), $psprintf("Using port ", my_port.name), OVM_NONE)

    s={"jtag_vif_", my_port.name()};
    if (p_sequencer.get_config_object(s,o_obj,0) == 0)
      `ovm_fatal(get_type_name(), {"No JTAG interface available for port ", my_port.name()})
    if (!$cast(jtag_vif, o_obj))
      `ovm_fatal(get_type_name(), "JTAG interface not the right type")

    `ovm_info(get_type_name(), $psprintf("JTAG interface found for port ", my_port.name()), OVM_NONE)
    jtag_if = jtag_vif.get_v_if();
    if (jtag_if == null)
      `ovm_fatal(get_type_name(), {"jtag_if not set in jtag_vif_", my_port.name()})

    // once_only = 0;

    endfunction : get_interface

  //------------------------------------------
  // Load IR
  //------------------------------------------
  task LoadIR(
              input [1:0]                  ResetMode,
              input [SIZE_OF_IR_REG-1:0] Address,
              input [SIZE_OF_IR_REG-1:0] Expected_Address,
              input [SIZE_OF_IR_REG-1:0] Mask_Address,
              input int            addr_len
              );

    dfx_tapfsm_state_e cts;
    string Address_s = write_part(Address, addr_len);

    `ovm_info("sTAP Sequences",$psprintf("LOAD IR Register Access Task Selected \nAddress   %s\nReset Mode %h\nAddress Len      %d\n", Address_s,ResetMode,addr_len),OVM_NONE);

    if (assume_single_tap) begin
      `ovm_create_on(ireq_pause, p_sequencer.tap_seqr_array[my_port])
      ireq_pause.ir_in[my_tap] = Address;
      `ovm_send(ireq_pause)
      irTdo=ireq_pause.ir_out[my_tap];
    end
    else begin
      `ovm_create_on(rreqi, p_sequencer.tap_seqr_array[TAP_PORT_P0]);
      rreqi.instr_in = {<< {Address}};
      rreqi.instr_in = new[addr_len](rreqi.instr_in);
      rreqi.its = DFX_TAP_TS_PAUSE_IR;
      `ovm_send(rreqi)
      // irTdo = 0; // initialize
      // {<< {irTdo}} = {>> {rreqi.instr_out}};
      irTdo = {<< {rreqi.instr_out}};
    end

    compare_tdo(Expected_Address,
                Mask_Address,
                addr_len,
                irTdo);

    cts = get_current_state;
    `ovm_info (get_type_name(), $psprintf("\nTMS_TDI_STREAM Done Current State: %s",cts.name()), OVM_MEDIUM)

  endtask : LoadIR

  //------------------------------------------
  // LoadIR_idle
  //------------------------------------------
  task LoadIR_idle(
                   input [1:0]          ResetMode,
                   input [SIZE_OF_IR_REG-1:0] Address,
                   input [SIZE_OF_IR_REG-1:0] Expected_Address,
                   input [SIZE_OF_IR_REG-1:0] Mask_Address,
                   input int                    addr_len
                   );
    dfx_tapfsm_state_e cts;
    string Address_s = write_part(Address, addr_len);

    `ovm_info("sTAP Sequences",$psprintf("LOAD IR idle Register Access Task Selected \nAddress   %s\nReset Mode %h\nAddress Len    %d\n",Address_s,ResetMode,addr_len),OVM_NONE);

    if (assume_single_tap) begin
      `ovm_create_on(ireq, p_sequencer.tap_seqr_array[my_port])
      ireq.ir_in[my_tap] = Address;
      `ovm_send(ireq)
      irTdo=ireq.ir_out[my_tap];
    end
    else begin
      `ovm_create_on(rreqi, p_sequencer.tap_seqr_array[TAP_PORT_P0]);
      rreqi.instr_in = {<< {Address}};
      rreqi.instr_in = new[addr_len](rreqi.instr_in);
      rreqi.its = DFX_TAP_TS_RTI;
      `ovm_send(rreqi)
      // irTdo = 0; // initialize
      // {<< {irTdo}} = {>> {rreqi.instr_out}};
      irTdo = {<< {rreqi.instr_out}};
    end

    compare_tdo(Expected_Address,
                Mask_Address,
                addr_len,
                irTdo);

    cts = get_current_state;
    `ovm_info (get_type_name(), $psprintf("\nTMS_TDI_STREAM Done Current State: %s",cts.name()), OVM_MEDIUM)

  endtask : LoadIR_idle

  //------------------------------------------
  // Load IR E1IR
  //------------------------------------------
  task LoadIR_E1IR(
                   input [1:0]          ResetMode,
                   input [SIZE_OF_IR_REG-1:0] Address,
                   input int                    addr_len
                   );
    dfx_tapfsm_state_e cts;
    string Address_s = write_part(Address, addr_len), irTdo_s;

    `ovm_info("sTAP Sequences",$psprintf("LOAD IR E1-IR Register Access Task Selected \nAddress   %s\nReset Mode %h\nAddress Len    %d\n",Address_s,ResetMode,addr_len),OVM_NONE);

    if (assume_single_tap) begin
      `ovm_create_on(ireq_e1ir, p_sequencer.tap_seqr_array[my_port])
      ireq_e1ir.ir_in[my_tap] = Address;
      `ovm_send(ireq_e1ir)
      irTdo=ireq_e1ir.ir_out[my_tap];
    end
    else begin
      `ovm_create_on(rreqi, p_sequencer.tap_seqr_array[TAP_PORT_P0]);
      rreqi.instr_in = {<< {Address}};
      rreqi.instr_in = new[addr_len](rreqi.instr_in);
      rreqi.its = DFX_TAP_TS_EXIT1_IR;
      `ovm_send(rreqi)
      // irTdo = 0; // initialize
      // {<< {irTdo}} = {>> {rreqi.instr_out}};
      irTdo = {<< {rreqi.instr_out}};
    end

    irTdo_s = write_part(irTdo, addr_len);
    `ovm_info(get_type_name(), $psprintf("TDO stream received, TDO: %s",irTdo_s) , OVM_NONE)

    cts = get_current_state;
    `ovm_info (get_type_name(), $psprintf("\nTMS_TDI_STREAM Done Current State: %s",cts.name()), OVM_MEDIUM)

  endtask : LoadIR_E1IR


  //------------------------------------------
  // Load DR
  //------------------------------------------
  task LoadDR(
              input [1:0]                             ResetMode,
              input [TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
              input [TOTAL_DATA_REGISTER_WIDTH-1:0] Expected_Data,
              input [TOTAL_DATA_REGISTER_WIDTH-1:0] Mask_Data,
              input int                       data_len
              );
    dfx_tapfsm_state_e cts;
    string Data_s = write_part(Data, data_len);

    `ovm_info("sTAP Sequences",$psprintf("LOAD DR Register Access Task Selected \nData   %s\nReset Mode %h\nAddress Len      %d\n",Data_s,ResetMode,data_len),OVM_NONE);

    ary = {<<{Data}};
    // ary dynamic array needs to be resized according to each register under probe.
    ary = new[data_len](ary);

    if (assume_single_tap) begin
      `ovm_create_on(dreq_pause, p_sequencer.tap_seqr_array[my_port])
      dreq_pause.dr_in[my_tap] = ary;
      `ovm_send(dreq_pause)
      ary = dreq_pause.td_out[my_tap];
      ary = new[TOTAL_DATA_REGISTER_WIDTH](ary);
      drTdo = {<<{ary}};
    end else begin
      `ovm_create_on(rreqd, p_sequencer.tap_seqr_array[TAP_PORT_P0]);
      rreqd.data_in = ary;
      rreqd.dts = DFX_TAP_TS_PAUSE_DR;
      `ovm_send(rreqd)
      // drTdo = 0; // initialize
      // {<< {drTdo}} = {>> {rreqd.data_out}};
      drTdo = {<< {rreqd.data_out}};
    end

    compare_tdo(Expected_Data,
                Mask_Data,
                data_len,
                drTdo);
    cts = get_current_state;
    `ovm_info (get_type_name(), $psprintf("\nTMS_TDI_STREAM Done Current State: %s",cts.name()), OVM_MEDIUM)

  endtask : LoadDR

  //------------------------------------------
  // LoadDR_idle
  //------------------------------------------
  task LoadDR_idle(
                   input [1:0]                     ResetMode,
                   input [TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
                   input [TOTAL_DATA_REGISTER_WIDTH-1:0] Expected_Data,
                   input [TOTAL_DATA_REGISTER_WIDTH-1:0] Mask_Data,
                   input int                               data_len
                   );
    dfx_tapfsm_state_e cts;
    string Data_s = write_part(Data, data_len);

    `ovm_info("sTAP Sequences",$psprintf("LOAD DR idle Register Access Task Selected \nData   %s\nReset Mode %h\nAddress Len    %d\n",Data_s,ResetMode,data_len),OVM_NONE);

    ary = {<<{Data}};
    // ary dynamic array needs to be resized according to each register under probe.
    ary = new[data_len](ary);

    if (assume_single_tap) begin
      `ovm_create_on(dreq, p_sequencer.tap_seqr_array[my_port])
      dreq.dr_in[my_tap] = ary;
      `ovm_send(dreq)
      ary = dreq.td_out[my_tap];
      ary = new[TOTAL_DATA_REGISTER_WIDTH](ary);
      drTdo = {<<{ary}};
    end else begin
      `ovm_create_on(rreqd, p_sequencer.tap_seqr_array[TAP_PORT_P0]);
      rreqd.data_in = ary;
      rreqd.dts = DFX_TAP_TS_RTI;
      `ovm_send(rreqd)
      // drTdo = 0; // initialize
      // {<< {drTdo}} = {>> {rreqd.data_out}};
      drTdo = {<< {rreqd.data_out}};
    end

    compare_tdo(Expected_Data,
                Mask_Data,
                data_len,
                drTdo);
    cts = get_current_state;
    `ovm_info (get_type_name(), $psprintf("\nTMS_TDI_STREAM Done Current State: %s",cts.name()), OVM_MEDIUM)

  endtask : LoadDR_idle

  //------------------------------------------
  // Load DR Pause
  //------------------------------------------
  task LoadDR_Pause(
                    input [1:0]                     ResetMode,
                    input [TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
                    input [TOTAL_DATA_REGISTER_WIDTH-1:0] Expected_Data,
                    input [TOTAL_DATA_REGISTER_WIDTH-1:0] Mask_Data,
                    input int                               data_len,
                    input int                           pause_len
                    );
    dfx_tapfsm_state_e cts;

    LoadDR(ResetMode,
           Data,
           Expected_Data,
           Mask_Data,
           data_len);

    Idle(pause_len);

    compare_tdo(Expected_Data,
                Mask_Data,
                data_len,
                drTdo);

    cts = get_current_state;
    `ovm_info (get_type_name(), $psprintf("\nTMS_TDI_STREAM Done Current State: %s",cts.name()), OVM_MEDIUM)


  endtask : LoadDR_Pause

  //------------------------------------------
  // LoadDR_E1DR
  //------------------------------------------
  task LoadDR_E1DR(
                   input [1:0]                     ResetMode,
                   input [TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
                   input [TOTAL_DATA_REGISTER_WIDTH-1:0] Expected_Data,
                   input [TOTAL_DATA_REGISTER_WIDTH-1:0] Mask_Data,
                   input int                               data_len
                   );
    dfx_tapfsm_state_e cts;
    string Data_s = write_part(Data, data_len);

    `ovm_info("sTAP Sequences",$psprintf("LOAD DR E1DR Register Access Task Selected \nData   %h\nReset Mode %h\nData Len    %d\n",Data_s,ResetMode,data_len),OVM_NONE);

    ary = {<<{Data}};
    // ary dynamic array needs to be resized according to each register under probe.
    ary = new[data_len](ary);

    if (assume_single_tap) begin
      `ovm_create_on(dreq_e1dr, p_sequencer.tap_seqr_array[my_port])
      dreq_e1dr.dr_in[my_tap] = ary;
      `ovm_send(dreq_e1dr)
      ary = dreq_e1dr.td_out[my_tap];
      ary = new[TOTAL_DATA_REGISTER_WIDTH](ary);
      drTdo = {<<{ary}};
    end else begin
      `ovm_create_on(rreqd, p_sequencer.tap_seqr_array[TAP_PORT_P0]);
      rreqd.data_in = ary;
      rreqd.dts = DFX_TAP_TS_EXIT1_DR;
      `ovm_send(rreqd)
      // drTdo = 0; // initialize
      // {<< {drTdo}} = {>> {rreqd.data_out}};
      drTdo = {<< {rreqd.data_out}};
    end

    cts = get_current_state;
    `ovm_info (get_type_name(), $psprintf("\nTMS_TDI_STREAM Done Current State: %s",cts.name()), OVM_MEDIUM)

    compare_tdo(Expected_Data,
                Mask_Data,
                data_len,
                drTdo);

  endtask : LoadDR_E1DR


  //------------------------------------------
  // TMS TDI Stream
  //------------------------------------------
  task tms_tdi_stream(
                      input [TOTAL_DATA_REGISTER_WIDTH-1:0] tms_stream,
                      input [TOTAL_DATA_REGISTER_WIDTH-1:0] tdi_stream,
                      input int                       width);

    dfx_tap_tms_tap_transaction treq;
    dfx_node_ary_t tms_ary;
    dfx_node_ary_t tdi_ary;
    dfx_tapfsm_state_e cts;
    string tms_stream_s = write_part(tms_stream, width),
           tdi_stream_s = write_part(tdi_stream, width);

    tms_ary = {<<{tms_stream}};
    tdi_ary = {<<{tdi_stream}};

    tms_ary = new [width] (tms_ary);
    tdi_ary = new [width] (tdi_ary);

    `ovm_info (get_type_name(), $psprintf("\nTo TMS_TDI_STREAM with \nTMS STREAM: %s\nTDI STREAM: %s\nWidth       : %0d",tms_stream_s,tdi_stream_s,width), OVM_MEDIUM)

    `ovm_create_on(treq, p_sequencer.tap_seqr_array[my_port])
    treq.tms_in = tms_ary;
    treq.tdi_in = tdi_ary;
    `ovm_send(treq)

    cts = get_current_state;
    `ovm_info (get_type_name(), $psprintf("\nTMS_TDI_STREAM Done Current State: %s",cts.name()), OVM_MEDIUM)

  endtask : tms_tdi_stream

  //------------------------------------------
  // Multiple TAP Register Access
  // - End State = RUTI or PAUSE_DR
  //------------------------------------------
  task MultipleTapRegisterAccessEndState(
                                         input [1:0] ResetMode,
                                         input [SIZE_OF_IR_REG-1:0] Address,
                                         input [TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
                                         input int addr_len,
                                         input int data_len,
                                         input dfx_tapfsm_state_e end_state);

    dfx_node_ary_t opcode, data;

    opcode = {<<{Address}};
    data   = {<<{Data}};

    opcode = new[addr_len] (opcode);
    data   = new[data_len] (data);

    if(end_state == DFX_TAP_TS_RTI) begin
      if (assume_single_tap) begin
        `ovm_create_on(mtt, p_sequencer.tap_seqr_array[my_port])
        mtt.ir_in[my_tap] = Address;
        mtt.dr_in[my_tap] = data;
        `ovm_send(mtt)
      end
      else begin
        `ovm_create_on(rreq, p_sequencer.tap_seqr_array[my_port])
        rreq.instr_in = opcode;
        rreq.data_in  = data;
        `ovm_send(rreq)
      end
    end else if(end_state == DFX_TAP_TS_PAUSE_DR) begin
      if (assume_single_tap) begin
        `ovm_create_on(mttp, p_sequencer.tap_seqr_array[my_port])
        mttp.ir_in[my_tap] = Address;
        mttp.dr_in[my_tap] = data;
        `ovm_send(mttp)
      end
      else begin
        `ovm_create_on(rreqPause, p_sequencer.tap_seqr_array[my_port])
        rreqPause.instr_in = opcode;
        rreqPause.data_in  = data;
        `ovm_send(rreqPause)
      end
    end
  endtask : MultipleTapRegisterAccessEndState

  //------------------------------------------
  // Multiple TAP Register Access
  // - End State = RUTI
  //------------------------------------------
  task MultipleTapRegisterAccess(
                                 input [1:0] ResetMode,
                                 input [SIZE_OF_IR_REG-1:0] Address,
                                 input [TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
                                 input int addr_len,
                                 input int data_len);
    string Address_s = write_part(Address, addr_len),
           Data_s = write_part(Data, data_len);

    `ovm_info (ClassName, $psprintf("MultipleTapRegisterAccess Task Selected \nAddress     %s\nData          %s\nReset Mode  %0h\nAddress Len %0d\nData Len    %0d",Address_s,Data_s,ResetMode,addr_len,data_len), OVM_LOW);
    MultipleTapRegisterAccessEndState(ResetMode,Address,Data,addr_len,data_len,DFX_TAP_TS_RTI);
  endtask : MultipleTapRegisterAccess

  //------------------------------------------
  // Multiple TAP Register Access
  // - End State = PAUSE_DR
  //------------------------------------------
  task MultipleTapRegisterAccessPause(
                                      input [1:0] ResetMode,
                                      input [SIZE_OF_IR_REG-1:0] Address,
                                      input [TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
                                      input int addr_len,
                                      input int data_len);
    MultipleTapRegisterAccessEndState(ResetMode,Address,Data,addr_len,data_len,DFX_TAP_TS_PAUSE_DR);
  endtask : MultipleTapRegisterAccessPause


  //---------------------------------------------------------
  // Multiple TAP Register Access with Expected Data checker
  // - End State = PAUSE_DR
  //---------------------------------------------------------
  task ExpData_MultipleTapRegisterAccess(
                                         input [1:0]                           ResetMode,
                                         input [SIZE_OF_IR_REG-1:0]            Address,
                                         input int                             addr_len,
                                         input [TOTAL_DATA_REGISTER_WIDTH-1:0]  Data,
                                         input [TOTAL_DATA_REGISTER_WIDTH-1:0]  Expected_Data,
                                         input [TOTAL_DATA_REGISTER_WIDTH-1:0]  Mask_Data,
                                         input int                             data_len);

    dfx_node_t [TOTAL_DATA_REGISTER_WIDTH-1:0] data_out = 0;
    dfx_node_t [TOTAL_DATA_REGISTER_WIDTH-1:0] actual_data_msk = 0, expect_data_msk = 0;
    string Address_s = write_part(Address, addr_len),
           Data_s = write_part(Data, data_len);

    `ovm_info (ClassName, $psprintf("ExpData_MultipleTapRegisterAccess Task Selected \nAddress    %s\nData         %s\nReset Mode %0h",Address_s,Data_s,ResetMode), OVM_LOW);

    MultipleTapRegisterAccessPause(ResetMode,Address,Data,addr_len,data_len);

    for(int i=0; i<data_len; i++) data_out[i] = assume_single_tap ? mttp.td_out[my_tap][i] : rreqPause.data_out[i];

    actual_data_msk = data_out & Mask_Data;
    expect_data_msk = Expected_Data & Mask_Data;

    compare_tdo(Expected_Data,Mask_Data,data_len,data_out);

  endtask : ExpData_MultipleTapRegisterAccess

  //---------------------------------------------------------
  // Multiple TAP Register Access with Expected Data checker
  // - End State = RUTI
  //---------------------------------------------------------
  task ExpData_MultipleTapRegisterAccessRuti(
                                             input [1:0]                               ResetMode,
                                             input [SIZE_OF_IR_REG-1:0]        Address,
                                             input int                         addr_len,
                                             input [TOTAL_DATA_REGISTER_WIDTH-1:0]  Data,
                                             input [TOTAL_DATA_REGISTER_WIDTH-1:0]  Expected_Data,
                                             input [TOTAL_DATA_REGISTER_WIDTH-1:0]  Mask_Data,
                                             input int                         data_len);
    dfx_node_t [TOTAL_DATA_REGISTER_WIDTH-1:0] data_out = 0;
    dfx_node_t [TOTAL_DATA_REGISTER_WIDTH-1:0] actual_data_msk, expect_data_msk;

    MultipleTapRegisterAccess(ResetMode,Address,Data,addr_len,data_len);

    for(int i=0; i<data_len; i++) data_out[i] = assume_single_tap ? mtt.td_out[my_tap][i] : rreq.data_out[i];

    actual_data_msk = data_out & Mask_Data;
    expect_data_msk = Expected_Data & Mask_Data;

    compare_tdo(Expected_Data,Mask_Data,data_len,data_out);
  endtask : ExpData_MultipleTapRegisterAccessRuti

  //------------------------------------------
  // ReturnTDO Multiple TAP Register Access
  // - End State = PAUSE_DR
  //------------------------------------------
  task ReturnTDO_ExpData_MultipleTapRegisterAccess(
                                                   input [1:0]                               ResetMode,
                                                   input [SIZE_OF_IR_REG-1:0]                Address,
                                                   input int                                 addr_len,
                                                   input [TOTAL_DATA_REGISTER_WIDTH-1:0]             Data,
                                                   input [TOTAL_DATA_REGISTER_WIDTH-1:0]             Expected_Data,
                                                   input [TOTAL_DATA_REGISTER_WIDTH-1:0]             Mask_Data,
                                                   input int                                 data_len,
                                                   output logic [TOTAL_DATA_REGISTER_WIDTH-1:0] tdo_data);
    string Address_s = write_part(Address, addr_len),
           Data_s = write_part(Data, data_len);

    `ovm_info(ClassName, $psprintf("ReturnTDO_ExpData_MultipleTapRegisterAccess Task Selected \nAddress     %0h\nData          %0h\nReset Mode  %0h\nAddress Len %0d\nData Len    %0d",Address,Data,ResetMode,addr_len,data_len), OVM_LOW)
    ExpData_MultipleTapRegisterAccess(ResetMode,Address,addr_len,Data,Expected_Data,Mask_Data,data_len);
    for(int i=0; i<data_len; i++) tdo_data[i] = assume_single_tap ? mttp.td_out[my_tap][i] : rreqPause.data_out[i];
  endtask : ReturnTDO_ExpData_MultipleTapRegisterAccess

  //------------------------------------------
  // ReturnTDO Multiple TAP Register Access
  //------------------------------------------
  task ReturnTDO_ExpData_MultipleTapRegisterAccessRuti(
                                                       input [1:0]                                   ResetMode,
                                                       input [SIZE_OF_IR_REG-1:0]                    Address,
                                                       input int                                     addr_len,
                                                       input [TOTAL_DATA_REGISTER_WIDTH-1:0]         Data,
                                                       input [TOTAL_DATA_REGISTER_WIDTH-1:0]         Expected_Data,
                                                       input [TOTAL_DATA_REGISTER_WIDTH-1:0]         Mask_Data,
                                                       input int                                     data_len,
                                                       output logic [TOTAL_DATA_REGISTER_WIDTH-1:0] tdo_data);
    string Address_s = write_part(Address, addr_len),
           Data_s = write_part(Data, data_len);

    `ovm_info (ClassName, $psprintf("ReturnTDO_ExpData_MultipleTapRegisterAccessRuti Task Selected \nAddress       %s\nData        %s\nReset Mode  %0h\nAddress Len %0d\nData Len    %0d",Address_s,Data_s,ResetMode,addr_len,data_len), OVM_LOW)
    ExpData_MultipleTapRegisterAccessRuti(ResetMode,Address,addr_len,Data,Expected_Data,Mask_Data,data_len);
    for(int i=0; i<data_len; i++) tdo_data[i] = assume_single_tap ? mtt.td_out[my_tap][i] : rreq.data_out[i];
  endtask : ReturnTDO_ExpData_MultipleTapRegisterAccessRuti

  //------------------------------------------
  // check_current_state()
  //------------------------------------------
  function bit check_current_state(dfx_tapfsm_state_e state);
    dfx_tapfsm_state_e cts = get_current_state();
    if(cts == state) begin
      `ovm_info(get_type_name(), $psprintf("[check_current_state] TAP FSM State matches. TAP_STATE = %s", state.name()), OVM_NONE)
    end else begin
      `ovm_error(get_type_name(), $psprintf("[check_current_state] TAP FSM State mismatch. Expected = %s, Actual = %s", state.name, cts.name()))
    end
  endfunction : check_current_state

  //------------------------------------------
  // get_current_state()
  //------------------------------------------
  function dfx_tapfsm_state_e get_current_state;
    dfx_tapfsm_state_e cts;

    get_interface();
    cts = jtag_if.cts;

    return cts;
  endfunction : get_current_state

  //------------------------------------------
  // Goto the input state
  //----- ------------------------------------
  task Goto(
            input [3:0] FsmState,
            input int     Count);
    dfx_node_t [0:0] tms;
    dfx_tapfsm_state_e curr_state;
    dfx_tapfsm_state_e dest_state;
    dfx_tapfsm_state_e next_state;
    int index = 0;
    string msg;
    bit stay_in_state_tms = 1'b0;

    curr_state = get_current_state;
    dest_state = TapStateTranslation[FsmState];

    $swrite (msg, "FsmState Task Selected: Goto %0h", FsmState);
    `ovm_info (ClassName, msg, OVM_LOW);

    $swrite (msg, "\nIn GOTO Task:\nCurrent State: %s\nTarget    State: %s ",curr_state.name(), dest_state.name());
    `ovm_info (get_type_name(), msg, OVM_MEDIUM);

    while(curr_state != dest_state) begin
      if(TapRoutingTable[curr_state].exists(dest_state)) begin
        tms = TapRoutingTable[curr_state][dest_state];
        tms_tdi_stream(tms,0,1);
        curr_state = get_current_state();
        //`ovm_info("DGK", $psprintf("%0d: Current State = %s", index, curr_state.name()), OVM_NONE)
        index++;
      end else begin
        `ovm_fatal(ClassName, $psprintf("Tap Routing Table Error. Current State:%s, Target State:%s", curr_state.name(),dest_state.name()))
      end
    end // while (curr_state != dest_state)

    // Stay in the state the number of cycles specified in count if the state has a loop feedback
    if(dest_state == DFX_TAP_TS_TLR) stay_in_state_tms = 1'b1; // default: 1'b0

    if((dest_state == DFX_TAP_TS_TLR)        || (dest_state == DFX_TAP_TS_RTI)      ||
       (dest_state == DFX_TAP_TS_SHIFT_DR) || (dest_state == DFX_TAP_TS_PAUSE_DR) ||
       (dest_state == DFX_TAP_TS_SHIFT_IR) || (dest_state == DFX_TAP_TS_PAUSE_IR) &&
       (Count > 1)) begin
      for(int i=1; i<Count; i++) begin
        tms_tdi_stream(stay_in_state_tms,0,1);
      end
    end

    curr_state = get_current_state();
    $swrite (msg, "\nExiting GOTO Task:\nCurrent State: %s",curr_state.name());
    `ovm_info (get_type_name(), msg, OVM_MEDIUM);

  endtask : Goto

  // Write the specified number of bits from a long vector to a string and return the string
  //
  function string write_part(dfx_node_t [TDO_LEN-1:0] vec, int len);
    string s1, s2;
    $sformat(s1, "%0d'b", len);

    for (int i = len - 1; i >= 0; i--) begin
      $sformat(s2, "%0b", vec[i]);
      s1 = {s1, s2};
    end

    return s1;
  endfunction : write_part

  //------------------------------------------
  // compare_tdo()
  //------------------------------------------
  function compare_tdo(input dfx_node_t [TDO_LEN-1:0]          Expected,
                       input dfx_node_t [TDO_LEN-1:0]          Mask,
                       input int                               len,
                       input dfx_node_t [TDO_LEN-1:0]          tdo_out);
    bit flag = 0;
    string tdo_out_s = write_part(tdo_out, len), Expected_s = write_part(Expected, len);

    for(int i=0; i<len; i++) begin
      if(Mask[i]== 1'b1) begin
        if(Expected[i]!== tdo_out[i]) begin
          `ovm_error("EXPECTED_TDO_ERROR",$psprintf("The Error at bit %d Actual TDO %b Expected TDO %b",i,tdo_out[i],Expected[i]));
          flag =1;
        end
      end
    end  //closes  for statement

    if (flag==1'b1) begin
      `ovm_error("Compare Failure", {"Actual TDO: ", tdo_out_s, ", Expected TDO: ", Expected_s});
    end

    if(flag==1'b0 && |Mask) begin
      `ovm_info(get_type_name(), {"Success comparing TDO stream, expected TDO: ", Expected_s, ", actual TDO: ", tdo_out_s}, OVM_NONE)
    end
  endfunction : compare_tdo


  //------------------------------------------
  // Idle()
  //------------------------------------------
  task Idle (input int idle_count);

    dfx_tapfsm_state_e cts;

    `ovm_info (ClassName, $psprintf("idle_count Task Selected with count %0d",idle_count), OVM_LOW)

    get_interface();

    for(int i=0;i<idle_count;i++) begin
      @(negedge jtag_if.tck);
    end

    cts = get_current_state();
    `ovm_info (get_type_name(), $psprintf("\nIDLE Done Current State: %s",cts.name()), OVM_MEDIUM)

  endtask : Idle

  //------------------------------------------
  //Reset Task Depending Upon the Mode
  //------------------------------------------
  task Reset(input [1:0] ResetMode);
    begin
      bit [1:0] ResetModeInt = ResetMode;
      string    msg;
      dfx_tap_treset_sequence trsts;
      dfx_tap_powergood_sequence pgs;

      $swrite (msg, "ResetMode Task Selected");
      `ovm_info (ClassName, msg, OVM_LOW);

      case (ResetMode)
        2'b00: `ovm_info(get_type_name(), "ResetMode 2'b00 not supported, nothing will be done", OVM_MEDIUM)
        2'b01: `ovm_do_with(trsts, {tms_cycles == 0; assert_treset == 1'b1; port == my_port;})
      2'b10: `ovm_do_with(trsts, {tms_cycles == 5; assert_treset == 1'b0; port == my_port;})
      2'b11: begin
        `ovm_info(get_type_name(),
                  "PowerGood pin toggling is not supported by this API - do that first before calling the Reset() task", OVM_NONE);
        `ovm_info(get_type_name(),
                  "The Reset() task will reset the TAP and TAP network internal states to the PowerGood state", OVM_NONE);
        `ovm_do(pgs)
      end
      endcase // case (ResetMode)
    end
  endtask : Reset

  task ForceClockGatingOff(input ClockGateOff);
    begin
        string    msg;
        $swrite (msg, "ForceClockGatingOff Task Selected");
        `ovm_info (ClassName, msg, OVM_LOW);

        `ovm_info(get_type_name(), "Dynamic clock gating is not currently supported.", OVM_NONE)
        `ovm_info(get_type_name(), "Instead, use the plusarg ON_DEMAND_TCK_P<port> to turn on clock gating for the test.", OVM_NONE)
        `ovm_info(get_type_name(), "Example: +ON_DEMAND_TCK_P0 +ON_DEMAND_TCK_P1" , OVM_NONE)
        `ovm_info(get_type_name(), "The default is no clock gating or a free-running TCK" , OVM_NONE)
    end
    endtask : ForceClockGatingOff

endclass : JtagBfmSequences

`endif // `ifndef JTAGBFMSEQUENCES_SV
