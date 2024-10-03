`ifndef DFX_ADD_INSTRUCTION_MACRO
 `define DFX_ADD_INSTRUCTION_MACRO

`define add_instruction(TAP_NAME, TAP_CLASS, INSTRUCTION, IR, DR_SIZE) \
  task automatic INSTRUCTION(input bit [DR_SIZE - 1:0] data_in, ref dfx_node_t data_out[], input int port = 0, input bit cfg_en = 0); \
    \
    dfx_tap_multiple_taps_sequence  myseq; \
    dfx_tap_enable_sequence         cfgseq; \
    dfx_tap_disable_sequence        dsblseq; \
    dfx_tap_unit_e                  tap_u, tap_u_i; \
    dfx_tap_state_e                 tap_s; \
    dfx_tap_port_e                  tap_p; \
    bit                             disable_taps; \
    dfx_tap_network tap_nw = dfx_tap_network::get_handle(); \
    \
    `get_debug_interface(dfx_debug_ptr) \
    \
    tap_u = dfx_tap_unit_e'(TAP_NAME); \
    dfx_debug_ptr.msg1 = 0 ; \
    dfx_debug_ptr.msg2 = 0 ; \
    dfx_debug_ptr.msg3 = 0 ; \
    if (!tap_nw.tap_configured(tap_u,tap_p,tap_s)) \
      ovm_report_error(get_type_name(), $psprintf("%s not included in test", tap_u.name()), OVM_NONE); \
    else begin \
      if (cfg_en) begin \
        disable_taps = 1'b0; \
        `ovm_create(dsblseq) \
        for ( tap_u_i = dfx_tap_unit_e'(tap_u_i.first()+1) ; tap_u_i !=  tap_u_i.last() ; tap_u_i = tap_u_i.next()) begin \
          if (tap_nw.tap_configured(tap_u_i, tap_p, tap_s)) begin \
  	    if (tap_u != tap_u_i & tap_s != TAP_STATE_ISOLATED) begin \
	        disable_taps = 1'b1; \
	        dsblseq.disable_tap[tap_u_i] = TAP_STATE_ISOLATED; \
	    end \
	  end \
       end \
	if (disable_taps) begin \
          dfx_debug_ptr.msg1 = "Disable Taps Sequence"; \
	`ovm_send(dsblseq) \
	  end \
        \
        ovm_report_info(get_type_name(), $psprintf("TAP Connected: %s", tap_u.name()), OVM_NONE); \
        \
        if (tap_nw.tap_configured(tap_u, tap_p, tap_s) & (tap_p != dfx_tap_port_e'(port) | tap_s != TAP_STATE_NORMAL)) begin \
          `ovm_create(cfgseq) \
          cfgseq.enable_tap[tap_u] = dfx_tap_port_e'(port); \
          dfx_debug_ptr.msg1 = {"En Tap seq:",`"TAP_NAME`"}; \
          `ovm_send(cfgseq) \
        end \
        \
      end \
      ovm_report_info(get_type_name(), \
		      $psprintf(`"RUN_TAP_INSTRUCTION: %s runs INSTRUCTION instrunction`", tap_u.name()), OVM_NONE); \
     `ovm_create_on(myseq, p_sequencer.tap_seqr_array[dfx_tap_port_e'(port)]) \
      myseq.seq_ir_in[TAP_NAME] = TAP_CLASS::IR ; \
      myseq.seq_dr_in[TAP_NAME] = {<< {data_in}}; \
      dfx_debug_ptr.msg1 = {`"TAP_NAME`","::",`"IR`"}; \
      dfx_debug_ptr.msg2 = data_in; \
      `ovm_send(myseq) \
      data_out = myseq.seq_dr_out[TAP_NAME]; \
      dfx_debug_ptr.msg3 = {<< {data_out}}; \
      end \
  endtask
`endif