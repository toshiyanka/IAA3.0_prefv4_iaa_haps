`ifndef HQM_IOSF_BACK2BACK_ERROR_MWR_SEQ__SV
`define HQM_IOSF_BACK2BACK_ERROR_MWR_SEQ__SV

class hqm_iosf_back2back_error_mwr_seq extends hqm_base_seq;

    `ovm_sequence_utils(hqm_iosf_back2back_error_mwr_seq, sla_sequencer)

    extern         function             new    (string name = "hqm_iosf_back2back_error_mwr_seq");
    extern virtual task                 body   ();
    extern         function bit [127:0] get_hcw (bit [63:0] iptr);

endclass : hqm_iosf_back2back_error_mwr_seq

function hqm_iosf_back2back_error_mwr_seq::new(string name = "hqm_iosf_back2back_error_mwr_seq");
    super.new(name);
endfunction : new

task hqm_iosf_back2back_error_mwr_seq::body();

    hqm_iosf_prim_base_seq iosf_base_seq;

    bit [63:0]             addr;
    Iosf::data_t           data[];
    sla_ral_data_t         rd_val;

    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);

    addr[31:0]  = get_actual_ral("func_bar_l", "hqm_pf_cfg_i");
    addr[63:32] = get_actual_ral("func_bar_u", "hqm_pf_cfg_i");

    addr += 64'h0000_0000_0200_0000;

    for (int i = 0 ; i < 16; i++) begin
        
        data = new[16];
        for (int j = 0; j < 4 ; j++) begin

            bit [127:0] hcw_data;

            hcw_data = get_hcw( (i * 4) + j);

            for (int k = 0 ; k < 4; k++) begin
                data[j * 4 + k] = hcw_data[32 * k +: 32];
            end
        end
        ovm_report_info(get_full_name(), $psprintf("Sending %0d MWr IOSF transaction with EP bit set to 1 to address 0x%0x and data=%0p", i, addr, data), OVM_LOW);
        `ovm_do_with(iosf_base_seq, { cmd == Iosf::MWr64; iosf_addr_l == addr; iosf_exp_error_l == 1'b1; iosf_EP_l == 1'b1; iosf_data_l.size() == data.size(); foreach(data[i]) { iosf_data_l[i] == data[i]}; })
        wait_for_clk(200);

        poll_reg ("device_status", 'h8010, "hqm_pf_cfg_i");
        write_reg("device_status", 'h8010, "hqm_pf_cfg_i");
        poll_reg ("pcie_cap_device_status", 'h1, "hqm_pf_cfg_i");
        write_reg("pcie_cap_device_status", 'h1, "hqm_pf_cfg_i");
        poll_reg ("aer_cap_corr_err_status", 'h2000, "hqm_pf_cfg_i");
        write_reg("aer_cap_corr_err_status", 'h2000, "hqm_pf_cfg_i");
    end

    for (int i = 0 ; i < 16 ; i++) begin

        data = new[16];
        for (int j = 0 ; j < 4 ; j++) begin
            
            bit [127:0] hcw_data;

            hcw_data = get_hcw( (i*4) + j);
            for (int k = 0 ; k < 4 ; k++) begin
                data[j*4 + k] = hcw_data[k*32 +: 32];
            end
        end
        ovm_report_info(get_full_name(), $psprintf("Sending %0d NPMWr IOSF transaction to address 0x%0x and data=%0p", i, addr, data), OVM_LOW);
        `ovm_do_with(iosf_base_seq, { cmd == Iosf::NPMWr64; iosf_addr_l == addr; iosf_exp_error_l == 1'b1; iosf_data_l.size() == data.size(); foreach(data[i]) { iosf_data_l[i] == data[i]}; })
    end
    wait_for_clk(100);

    compare_reg("hqm_system_cnt_0", 0, rd_val, "hqm_system_csr");
    compare_reg("hqm_system_cnt_1", 0, rd_val, "hqm_system_csr");

    ovm_report_info(get_full_name(), $psprintf("body -- End"), OVM_DEBUG);

endtask : body

function bit [127:0] hqm_iosf_back2back_error_mwr_seq::get_hcw(bit [63:0] iptr);

    hcw_transaction trans;
    
    trans = hcw_transaction::type_id::create("trans");

    trans.iptr = iptr;
    trans.idsi = $urandom;
    trans.qid  = 0;
    trans.rsvd0 = 0;
    trans.qtype = 3;
    trans.qpri  = $urandom;
    trans.msgtype = $urandom;
    trans.lockid = $urandom;
    trans.meas   = $urandom;
    trans.dbg = 0;
    trans.no_inflcnt_dec = 0;
    trans.cmp_id = 0;
    trans.cq_pop = 0;
    trans.qe_uhl = 0;
    trans.qe_orsp = 0;
    trans.qe_valid = 1;
    trans.rsvd0 = 0;
    trans.dsi_error = 0;

    return trans.byte_pack(0);

endfunction : get_hcw

`endif //HQM_IOSF_BACK2BACK_ERROR_MWR_SEQ__SV
