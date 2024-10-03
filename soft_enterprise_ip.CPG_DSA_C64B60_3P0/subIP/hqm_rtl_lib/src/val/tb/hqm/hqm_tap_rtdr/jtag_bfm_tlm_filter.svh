class jtag_bfm_tlm_filter #(parameter IP_NAME="na", IP_LBA=0, IP_GBA=0, TDO_DEADBITS=0) extends ovm_component;

    localparam SHIR_TDI_DEADBITS = 2;
    localparam SHDR_TDI_DEADBITS = 1;
    `ifndef OVM_MAX_STREAMBITS
        localparam DATA_REG_WIDTH = 4096;
    `else
        localparam DATA_REG_WIDTH = `OVM_MAX_STREAMBITS;
    `endif

    int ip_link_ir_lba;
    int ip_link_ir_gba;
    int ip_link_dr_lba;
    int ip_link_dr_gba;
    string info_header;

    // tlm component declarations
    ovm_analysis_port #(JtagBfmPkg::JtagBfmInMonSbrPkt) tap_in_port;
    ovm_analysis_port #(JtagBfmPkg::JtagBfmOutMonSbrPkt) tap_out_port;
    ovm_analysis_export #(JtagBfmPkg::JtagBfmInMonSbrPkt) jtag_in_export;
    ovm_analysis_export #(JtagBfmPkg::JtagBfmOutMonSbrPkt) jtag_out_export;
    protected tlm_analysis_fifo #(JtagBfmPkg::JtagBfmInMonSbrPkt) jtag_in_fifo;
    protected tlm_analysis_fifo #(JtagBfmPkg::JtagBfmOutMonSbrPkt) jtag_out_fifo;

    `ovm_component_utils(jtag_bfm_tlm_filter)

    function new(string name, ovm_component parent);

        super.new(name, parent);

        if (IP_NAME == "na")
            `ovm_fatal(get_type_name(), "jtag_bfm_tlm_filter must be parameterized with non-empty IP_NAME")
        if (IP_LBA == 'h0)
            `ovm_fatal(get_type_name(), "jtag_bfm_tlm_filter must be parameterized with non-zero IP_LBA value")
        if (IP_GBA == 'h0)
            `ovm_error(get_type_name(), "jtag_bfm_tlm_filter must be parameterized with non-zero IP_GBA value")
        if (TDO_DEADBITS == 'h0)
            `ovm_error(get_type_name(), "jtag_bfm_tlm_filter must be parameterized with non-zero TDO_DEADBITS value")

        ip_link_ir_lba = IP_LBA;
        ip_link_dr_lba = IP_LBA + 1;
        ip_link_ir_gba = IP_GBA;
        ip_link_dr_gba = IP_GBA + 1;
        info_header = $psprintf("%s_%s", get_type_name(), IP_NAME);

        `ovm_info(info_header,
            $psprintf(
                "JTAG BFM TLM filter object created for %s using LBA=0x%04x, GBA=0x%04x, TDO_DEADBITS=%0d",
                    IP_NAME, IP_LBA, IP_GBA, TDO_DEADBITS),
                        OVM_NONE)

    endfunction : new

    function void build();

        super.build();

        // tlm component constructors
        jtag_in_export  = new("filter_jtag_in_export");
        jtag_out_export = new("filter_jtag_out_export");
        jtag_in_fifo    = new("filter_jtag_in_fifo");
        jtag_out_fifo   = new("filter_jtag_out_fifo");
        tap_in_port     = new("filter_tap_in_port", this);
        tap_out_port    = new("filter_tap_out_port", this);

    endfunction : build

    function void connect();

        super.connect();

        // connect exports to fifos
        jtag_in_export.connect(jtag_in_fifo.analysis_export);
        jtag_out_export.connect(jtag_out_fifo.analysis_export);

    endfunction : connect

    task run();

        // share the current IR value between input and output blocks
        int current_ir_value = 0;

        // maintain the last LINK_IR value across transactions
        int last_link_ir_value = 0;

        // split here into two processes
        // one for input jtag txns, and another for output
        fork

            begin : JTAG_INPUT_BLOCK

                JtagBfmPkg::JtagBfmInMonSbrPkt jtag_in_txn;
                JtagBfmUserDatatypesPkg::fsm_state_test jtag_in_state;

                forever begin : JTAG_INPUT_LOOP

                    // wait for the next JTAG in txn
                    jtag_in_fifo.get(jtag_in_txn);

                    // extract FSM state
                    jtag_in_state = JtagBfmUserDatatypesPkg::fsm_state_test'(jtag_in_txn.FsmState);

                    case (jtag_in_state)

                        JtagBfmUserDatatypesPkg::TLRS: begin

                            JtagBfmPkg::JtagBfmInMonSbrPkt tap_in_txn = new("tap_in_txn");
                            `ovm_info(info_header, "Found TLRS input transaction", OVM_HIGH)

                            tap_in_txn.FsmState = JtagBfmUserDatatypesPkg::TLRS;
                            tap_in_txn.ShiftRegisterAddress = jtag_in_txn.ShiftRegisterAddress;
                            tap_in_port.write(tap_in_txn);

                        end // JtagBfmUserDatatypesPkg::TLRS

                        JtagBfmUserDatatypesPkg::UPDR: begin

                            // save current IR value for input and output messages
                            current_ir_value = jtag_in_txn.ShiftRegisterAddress;

                            // generate the input IR transaction
                            if ((current_ir_value === ip_link_ir_lba) || (current_ir_value === ip_link_ir_gba)) begin

                                int shift_cnt = 0;
                                bit [DATA_REG_WIDTH-1:0] ir_mask = 0;
                                bit [DATA_REG_WIDTH-1:0] masked_ir = 0;
                                JtagBfmPkg::JtagBfmInMonSbrPkt tap_in_txn = new("tap_in_txn");
                                `ovm_info(info_header, $psprintf("Found input LINK_IR shift for %s", IP_NAME), OVM_LOW)

                                // populate local vars
                                shift_cnt = jtag_in_txn.tdi_shift_cnt - SHIR_TDI_DEADBITS;
                                ir_mask   = {shift_cnt{1'b1}};
                                masked_ir = jtag_in_txn.ShiftRegisterData & ir_mask;

                                // populate outgoing TLM message
                                tap_in_txn.FsmState             = JtagBfmUserDatatypesPkg::UPIR;
                                tap_in_txn.tdi_shift_cnt        = shift_cnt;
                                tap_in_txn.ShiftRegisterAddress = masked_ir;
                                tap_in_port.write(tap_in_txn);

                                // save current LINK_IR value until next LINK_IR transaction
                                last_link_ir_value = jtag_in_txn.ShiftRegisterData;

                            end // current_ir_value

                            // generate the input DR transation
                            if ((current_ir_value === ip_link_dr_lba) || (current_ir_value === ip_link_dr_gba)) begin

                                int shift_cnt = 0;
                                bit [DATA_REG_WIDTH-1:0] dr_mask = 0;
                                bit [DATA_REG_WIDTH-1:0] masked_dr = 0;
                                JtagBfmPkg::JtagBfmInMonSbrPkt tap_in_txn = new("tap_in_txn");
                                `ovm_info(info_header, $psprintf("Found input LINK_DR shift for %s", IP_NAME), OVM_LOW)

                                // populate local vars
                                shift_cnt = jtag_in_txn.tdi_shift_cnt - SHDR_TDI_DEADBITS - TDO_DEADBITS;
                                dr_mask   = {shift_cnt{1'b1}} << TDO_DEADBITS;
                                masked_dr = (jtag_in_txn.ShiftRegisterData & dr_mask) >> TDO_DEADBITS;

                                // populate outgoing TLM message
                                tap_in_txn.FsmState             = JtagBfmUserDatatypesPkg::UPDR;
                                tap_in_txn.tdi_shift_cnt        = shift_cnt;
                                tap_in_txn.ShiftRegisterData    = masked_dr;
                                tap_in_txn.ShiftRegisterAddress = last_link_ir_value;
                                tap_in_port.write(tap_in_txn);

                            end // current_ir_value

                        end // JtagBfmUserDatatypesPkg::UPDR

                        default:
                            continue;

                    endcase

                end : JTAG_INPUT_LOOP

            end : JTAG_INPUT_BLOCK

            begin : JTAG_OUTPUT_BLOCK

                JtagBfmPkg::JtagBfmOutMonSbrPkt jtag_out_txn;
                JtagBfmUserDatatypesPkg::fsm_state_test jtag_out_state;

                forever begin : JTAG_OUTPUT_LOOP

                    // get an output JTAG txn
                    jtag_out_fifo.get(jtag_out_txn);

                    // extract FSM state
                    jtag_out_state = JtagBfmUserDatatypesPkg::fsm_state_test'(jtag_out_txn.FsmState);

                    // only send UPDR output transactions
                    if (jtag_out_state == JtagBfmUserDatatypesPkg::UPDR) begin

                        // only send scoped output transactions
                        if ((current_ir_value === ip_link_dr_lba) || (current_ir_value === ip_link_dr_gba)) begin

                            int shift_cnt = 0;
                            bit [DATA_REG_WIDTH-1:0] dr_mask = 0;
                            bit [DATA_REG_WIDTH-1:0] masked_dr = 0;
                            JtagBfmPkg::JtagBfmOutMonSbrPkt tap_out_txn = new("tap_out_txn");
                            `ovm_info(info_header, $psprintf("Found output LINK_DR shift for %s", IP_NAME), OVM_LOW)

                            // populate local vars
                            shift_cnt = jtag_out_txn.tdo_shift_cnt - SHDR_TDI_DEADBITS - TDO_DEADBITS;
                            dr_mask   = {shift_cnt{1'b1}} << TDO_DEADBITS;
                            masked_dr = (jtag_out_txn.ShiftRegisterData & dr_mask) >> TDO_DEADBITS;

                            // populate outgoing TLM message
                            tap_out_txn.FsmState             = JtagBfmUserDatatypesPkg::UPDR;
                            tap_out_txn.tdo_shift_cnt        = shift_cnt;
                            tap_out_txn.ShiftRegisterData    = masked_dr;
                            tap_out_txn.ShiftRegisterAddress = last_link_ir_value;
                            tap_out_port.write(tap_out_txn);

                        end // current_ir_value

                    end // jtag_out_state

                end : JTAG_OUTPUT_LOOP

            end : JTAG_OUTPUT_BLOCK

        join

    endtask : run

endclass : jtag_bfm_tlm_filter
