`ifndef HQM_HCW_ENQ_SZ_LESS_THAN_16B_SEQ__SV
`define HQM_HCW_ENQ_SZ_LESS_THAN_16B_SEQ__SV

class hqm_hcw_enq_sz_less_than_16B_seq extends hqm_sla_pcie_base_seq;

    `ovm_sequence_utils(hqm_hcw_enq_sz_less_than_16B_seq, sla_sequencer)

    extern function                  new                           (string name = "hqm_hcw_enq_sz_less_than_16B_seq");
    extern function hcw_transaction  get_hcw_data                  (bit [3:0] cmd, hcw_qtype qtype, bit [7:0] qid, bit [15:0] lockid, output Iosf::data_t hcw_data[$]);
    extern function void             get_new_cmd                   (hcw_qtype qtype, bit [7:0] qid, output Iosf::data_t hcw_data[$]);
    extern function void             get_batt_cmd                  (bit [15:0] num_tkn,  output Iosf::data_t hcw_data[$]);
    extern function void             get_cmp_cmd                   (output Iosf::data_t hcw_data[$]);
    extern function void             get_cmpt_cmd                  (bit [15:0] num_tkn, output Iosf::data_t hcw_data[$]);
    extern function bit [63:0]       get_pf_func_bar_addr          ();
    extern function IosfPkg::IosfTxn get_hcw_tlp                   (bit [7:0] pp, bit is_ldb, bit [9:0] i_length, Iosf::data_t i_data[$], bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'h0, bit [63:0] bar_offset);
    extern task                      send_new_cmd                  (bit [7:0] pp, bit is_ldb, hcw_qtype qtype, bit [7:0] qid, bit [9:0] i_length = 'd4, bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'h0, bit [63:0] bar_offset = 'h0);
    extern task                      send_new_cmd_updated_iosf_cmd (Iosf::iosf_cmd_t iosf_cmd, bit [7:0] pp, bit is_ldb, hcw_qtype qtype, bit [7:0] qid, bit [9:0] i_length = 'd4, bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'h0, bit ur = 0, bit [63:0] bar_offset = 'h0);
    extern task                      send_batt_cmd                 (bit [7:0] pp, bit is_ldb, bit [15:0] num_tkn, bit [9:0] i_length = 'd4, bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'h0);
    extern task                      send_cmp_cmd                  (bit [7:0] pp, bit is_ldb, bit [9:0] i_length = 'd4, bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'h0);
    extern task                      body                          ();
    extern function sla_ral_reg      get_reg_handle                (string reg_name, string file_name = "");
    extern task                      write_reg                     (string reg_name, sla_ral_data_t wr_data, string file_name = "");
    extern task                      compare_reg                   (string reg_name, sla_ral_data_t exp_val, output sla_ral_data_t rd_val, input string file_name = "");
    extern task                      send_iosf_prim                (bit [7:0] pp, bit is_ldb, bit [3:0] cmd, hcw_qtype qtype, bit [7:0] qid, bit [15:0] lockid, bit is_nm_pf = 1'b0);
    extern task                      send_new_iosf_prim            (bit [7:0] pp, bit is_ldb, hcw_qtype qtype, bit [7:0] qid, bit is_nm_pf = 1'b0);
    extern task                      send_batt_iosf_prim           (bit [7:0] pp, bit is_ldb, bit [15:0] num_tkn, bit is_nm_pf = 1'b0);
    extern task                      check_pcie_regs               (bit ned = 1'b1, bit fed = 1'b0, bit ced = 1'b0);
    extern task                      poll_reg                      (string reg_name, sla_ral_data_t comp_val, string file_name);
    extern function bit [7:0]        get_byte_en                   ();

endclass : hqm_hcw_enq_sz_less_than_16B_seq

function hqm_hcw_enq_sz_less_than_16B_seq::new(string name = "hqm_hcw_enq_sz_less_than_16B_seq");
    super.new(name);
endfunction : new

task hqm_hcw_enq_sz_less_than_16B_seq::body();

    bit [7:0] byte_en;

    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);

    // -- Send HCWs with length less than 16B
    for (int i = 0 ; i < 16 ; i++) begin

        bit [3:0] first_be;
        bit [3:0] last_be;
        int       len;

        len      = ( ( i >= 13)? 'd4 : ( (i >= 9)? 'd3 : ( (i >= 5)? 'd2 : 'd1 ) ) );
        first_be = ( (len > 1)  ? 'hf : ( (2 ** i) - 1) );
        last_be  = ( (len <= 1 ) ? 'h0 : ( !(i % 4)? 'hf : ( (2 ** (i%4) - 1) ) ) ); 

        ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR"), OVM_LOW);
        send_new_iosf_prim(0, 0, QDIR, 0);
        wait_ns_clk(200);

        // -- Send a <i>B HCW ENQ
        ovm_report_info(get_full_name(), $psprintf("Enqueueing a %0dB HCW to qid 0 qtype QDIR with fbe=%b, lbe=%b, len=%0d", i, first_be, last_be, len ), OVM_LOW);
        send_new_cmd(.pp(0), .is_ldb(0), .qtype(QDIR), .qid(0), .i_length(len), . is_nm_pf(0), .i_first_byte_en(first_be), .i_last_byte_en(last_be));
        wait_ns_clk(200);

        // -- Check for PCIE regs
        ovm_report_info(get_full_name(), $psprintf("Checking if PCIE status register reports UR error"), OVM_LOW);
        check_pcie_regs();

        // -- Return token 
        ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier"), OVM_LOW);
        send_batt_iosf_prim(0, 0, 1);
        wait_ns_clk(200);

        // -- Enqueue through nm_pf window
        ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR with nm_pf=1"), OVM_LOW);
        send_new_iosf_prim(0, 0, QDIR, 0, 1'b1);
        wait_ns_clk(200);

        // -- Send a <i>B HCW ENQ
        ovm_report_info(get_full_name(), $psprintf("Enqueueing a %0dB HCW to qid 0 qtype QDIR with fbe=%b, lbe=%b, len=%0d with nm_pf=1", i, first_be, last_be, len ), OVM_LOW);
        send_new_cmd(.pp(0), .is_ldb(0), .qtype(QDIR), .qid(0), .i_length(len), . is_nm_pf(1), .i_first_byte_en(first_be), .i_last_byte_en(last_be));
        wait_ns_clk(200);

        // -- Check for PCIE regs
        ovm_report_info(get_full_name(), $psprintf("Checking if PCIE status register reports UR error"), OVM_LOW);
        check_pcie_regs();

        // -- Return token
        ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier"), OVM_LOW);
        send_batt_iosf_prim(0, 0, 1, 1'b1); 
        wait_ns_clk(200);
    end

    // -- Non-contiguous byte-enable
    repeat (50) begin

        bit [3:0] first_be;
        bit [3:0] last_be;

        first_be = $urandom_range(1, 15);
        last_be  = $urandom_range(1, 15);

        ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR"), OVM_LOW);
        send_new_iosf_prim(0, 0, QDIR, 0);
        wait_ns_clk(200);

        // -- Send a 8B HCW ENQ
        ovm_report_info(get_full_name(), $psprintf("Enqueueing a %0dB HCW to qid 0 qtype QDIR with fbe=%b, lbe=%b", 8, first_be, last_be), OVM_LOW);
        send_new_cmd(.pp(0), .is_ldb(0), .qtype(QDIR), .qid(0), .i_length(2), . is_nm_pf(0), .i_first_byte_en(first_be), .i_last_byte_en(last_be));
        wait_ns_clk(200);

        // -- Check for PCIE regs
        ovm_report_info(get_full_name(), $psprintf("Checking if PCIE status register reports UR error"), OVM_LOW);
        check_pcie_regs();

        // -- Return token 
        ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier"), OVM_LOW);
        send_batt_iosf_prim(0, 0, 1);
        wait_ns_clk(200);

        // -- Enqueue through nm_pf window
        ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR with nm_pf=1"), OVM_LOW);
        send_new_iosf_prim(0, 0, QDIR, 0, 1'b1);
        wait_ns_clk(200);

        // -- Send a <i>B HCW ENQ
        ovm_report_info(get_full_name(), $psprintf("Enqueueing a %0dB HCW to qid 0 qtype QDIR with fbe=%b, lbe=%b with nm_pf=1", 8, first_be, last_be), OVM_LOW);
        send_new_cmd(.pp(0), .is_ldb(0), .qtype(QDIR), .qid(0), .i_length(2), . is_nm_pf(1), .i_first_byte_en(first_be), .i_last_byte_en(last_be));
        wait_ns_clk(200);

        // -- Check for PCIE regs
        ovm_report_info(get_full_name(), $psprintf("Checking if PCIE status register reports UR error"), OVM_LOW);
        check_pcie_regs();

        // -- Return token
        ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier"), OVM_LOW);
        send_batt_iosf_prim(0, 0, 1, 1'b1); 
        wait_ns_clk(200);
    end

    for (int i = 1; i < 65; i++) begin

        bit [3:0] lbe;

        lbe = 4'hf;
        if (i == 1) begin
            lbe = 'h0;
        end

        if ( (i == 4) || (i == 8) || (i == 12) || (i == 16) ) begin
            continue;
        end

        // -- Send a 16B HCW ENQ
        ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR"), OVM_LOW);
        send_new_iosf_prim(0, 0, QDIR, 0);
        wait_ns_clk(200);

        // -- Send a 4B HCW ENQ
        ovm_report_info(get_full_name(), $psprintf("Enqueueing a %0dB HCW to qid 0 qtype QDIR", (i * 4)), OVM_LOW);
        send_new_cmd(.pp(0), .is_ldb(0), .qtype(QDIR), .qid(0), .i_length(i), . is_nm_pf(0), .i_first_byte_en('hf), .i_last_byte_en(lbe));
        wait_ns_clk(200);

        // -- Check for PCIE regs
        ovm_report_info(get_full_name(), $psprintf("Checking if PCIE status register reports UR error"), OVM_LOW);
        check_pcie_regs();

        // -- Return token 
        ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier"), OVM_LOW);
        send_batt_iosf_prim(0, 0, 1);
        wait_ns_clk(200);

        // -- Enqueue through nm_pf window
        ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR with nm_pf=1"), OVM_LOW);
        send_new_iosf_prim(0, 0, QDIR, 0, 1'b1);
        wait_ns_clk(200);

        // -- Send a 4B HCW ENQ
        ovm_report_info(get_full_name(), $psprintf("Enqueueing a %0dB HCW to qid 0 qtype QDIR with nm_pf=1", (i * 4)), OVM_LOW);
        send_new_cmd(.pp(0), .is_ldb(0), .qtype(QDIR), .qid(0), .i_length(i), . is_nm_pf(1), .i_first_byte_en('hf), .i_last_byte_en(lbe));
        wait_ns_clk(200);

        // -- Check for PCIE regs
        ovm_report_info(get_full_name(), $psprintf("Checking if PCIE status register reports UR error"), OVM_LOW);
        check_pcie_regs();

        // -- Return token
        ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier"), OVM_LOW);
        send_batt_iosf_prim(0, 0, 1, 1'b1); 
        wait_ns_clk(200);
    end

    // -- Send a 16B HCW ENQ
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR with fbe=4'hf & lbe=4'hf"), OVM_LOW);
    send_new_iosf_prim(0, 0, QDIR, 0);
    wait_ns_clk(200);

    // -- Send a 16B HCW ENQ
    byte_en = get_byte_en();
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR with fbe=%b & lbe=%b", byte_en[3:0], byte_en[7:4]), OVM_LOW);
    send_new_cmd(.pp(0), .is_ldb(0), .qtype(QDIR), .qid(0), .i_length(4), . is_nm_pf(0), .i_first_byte_en(byte_en[3:0]), .i_last_byte_en(byte_en[7:4]));
    wait_ns_clk(200);

    // -- Check for PCIE regs
    ovm_report_info(get_full_name(), $psprintf("Checking if PCIE status register reports UR error"), OVM_LOW);
    check_pcie_regs();

    // -- Return token 
    ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier with fbe=4'hf & lbe=4'hf"), OVM_LOW);
    send_batt_iosf_prim(0, 0, 1);
    wait_ns_clk(200);

    // -- Send transaction such that the 16B write to a PP address has 8B in
    // -- the current PP and the next 8B in the subsequent PP 
    
    // -- Send a 16B HCW ENQ to PP0
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR"), OVM_LOW);
    send_new_iosf_prim(0, 0, QDIR, 0, 0);
    wait_ns_clk(200);
    
    // -- Send a 16B HCW ENQ to PP1
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 1 qtype QDIR"), OVM_LOW);
    send_new_iosf_prim(1, 0, QDIR, 1, 0);
    wait_ns_clk(200);

    // -- Send a 16B  HCW ENQ to PP0 such that 8B lies in PP0 address space and
    // -- next 8B lies in PP1 address space
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW such that first 8B lies in PP0 and next PP1 address space"), OVM_LOW);
    send_new_cmd(.pp(0), .is_ldb(0), .qtype(QDIR), .qid(0), .i_length(4), . is_nm_pf(0), .i_first_byte_en('hf), .i_last_byte_en('hf), .bar_offset('hff8));
    wait_ns_clk(200);

    // -- Check for PCIE regs
    // -- ovm_report_info(get_full_name(), $psprintf("Checking if PCIE status register reports UR error"), OVM_LOW);
    // -- check_pcie_regs();
    
    // -- Return token 
    ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier with fbe=4'hf & lbe=4'hf"), OVM_LOW);
    send_batt_iosf_prim(0, 0, 1);
    wait_ns_clk(200);

    // -- Return token 
    ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier with fbe=4'hf & lbe=4'hf"), OVM_LOW);
    send_batt_iosf_prim(1, 0, 1);
    wait_ns_clk(200);

    // -- Send transaction such that the 32B write to a PP address has 16B in
    // -- the current PP and the next 16B in the subsequent PP 
    
    // -- Send a 16B HCW ENQ to PP0
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR"), OVM_LOW);
    send_new_iosf_prim(0, 0, QDIR, 0, 0);
    wait_ns_clk(200);
    
    // -- Send a 16B HCW ENQ to PP1
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 1 qtype QDIR"), OVM_LOW);
    send_new_iosf_prim(1, 0, QDIR, 1, 0);
    wait_ns_clk(200);

    // -- Send a 32B  HCW ENQ to PP0 such that 16B lies in PP0 address space and
    // -- next 16B lies in PP1 address space
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 32B HCW such that first 16B lies in PP0 and next in PP1 address space"), OVM_LOW);
    send_new_cmd(.pp(0), .is_ldb(0), .qtype(QDIR), .qid(0), .i_length(8), . is_nm_pf(0), .i_first_byte_en('hf), .i_last_byte_en('hf), .bar_offset('hff0));
    wait_ns_clk(200);

    // -- Check for PCIE regs
    ovm_report_info(get_full_name(), $psprintf("Checking if PCIE status register reports UR error"), OVM_LOW);
    check_pcie_regs();
    
    // -- Return token 
    ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier with fbe=4'hf & lbe=4'hf"), OVM_LOW);
    send_batt_iosf_prim(0, 0, 1);
    wait_ns_clk(200);

    // -- Return token 
    ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier with fbe=4'hf & lbe=4'hf"), OVM_LOW);
    send_batt_iosf_prim(1, 0, 1);
    wait_ns_clk(200);

    // -- Send transaction such that the 48B write to a PP address has 32B in
    // -- the current PP and the next 16B in the subsequent PP 
    
    // -- Send a 16B HCW ENQ to PP0
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR"), OVM_LOW);
    send_new_iosf_prim(0, 0, QDIR, 0, 0);
    wait_ns_clk(200);
    
    // -- Send a 16B HCW ENQ to PP1
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 1 qtype QDIR"), OVM_LOW);
    send_new_iosf_prim(1, 0, QDIR, 1, 0);
    wait_ns_clk(200);

    // -- Send a 48B  HCW ENQ to PP0 such that 32B lies in PP0 address space and
    // -- next 16B lies in PP1 address space
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 48B HCW such that first 32B lies in PP0 and next 16B in PP1 address space"), OVM_LOW);
    send_new_cmd(.pp(0), .is_ldb(0), .qtype(QDIR), .qid(0), .i_length(12), . is_nm_pf(0), .i_first_byte_en('hf), .i_last_byte_en('hf), .bar_offset('hfe0));
    wait_ns_clk(200);

    // -- Check for PCIE regs
    ovm_report_info(get_full_name(), $psprintf("Checking if PCIE status register reports UR error"), OVM_LOW);
    check_pcie_regs();
    
    // -- Return token 
    ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier with fbe=4'hf & lbe=4'hf"), OVM_LOW);
    send_batt_iosf_prim(0, 0, 1);
    wait_ns_clk(200);

    // -- Return token 
    ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier with fbe=4'hf & lbe=4'hf"), OVM_LOW);
    send_batt_iosf_prim(1, 0, 1);
    wait_ns_clk(200);

    // -- Send transaction such that the 64B write to a PP address has 32B in
    // -- the current PP and the next 32B in the subsequent PP 
    
    // -- Send a 16B HCW ENQ to PP0
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 0 qtype QDIR"), OVM_LOW);
    send_new_iosf_prim(0, 0, QDIR, 0, 0);
    wait_ns_clk(200);
    
    // -- Send a 16B HCW ENQ to PP1
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 16B HCW to qid 1 qtype QDIR"), OVM_LOW);
    send_new_iosf_prim(1, 0, QDIR, 1, 0);
    wait_ns_clk(200);

    // -- Send a 64B  HCW ENQ to PP0 such that 32B lies in PP0 address space and
    // -- next 32B lies in PP1 address space
    ovm_report_info(get_full_name(), $psprintf("Enqueueing a 64B HCW such that first 32B lies in PP0 and next 32B in PP1 address space"), OVM_LOW);
    send_new_cmd(.pp(0), .is_ldb(0), .qtype(QDIR), .qid(0), .i_length(16), . is_nm_pf(0), .i_first_byte_en('hf), .i_last_byte_en('hf), .bar_offset('hfe0));
    wait_ns_clk(200);

    // -- Check for PCIE regs
    ovm_report_info(get_full_name(), $psprintf("Checking if PCIE status register reports UR error"), OVM_LOW);
    check_pcie_regs();
    
    // -- Return token 
    ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier with fbe=4'hf & lbe=4'hf"), OVM_LOW);
    send_batt_iosf_prim(0, 0, 1);
    wait_ns_clk(200);

    // -- Return token 
    ovm_report_info(get_full_name(), $psprintf("Return 1 token for the 16B HCW sent earlier with fbe=4'hf & lbe=4'hf"), OVM_LOW);
    send_batt_iosf_prim(1, 0, 1);
    wait_ns_clk(200);
   
    ovm_report_info(get_full_name(), $psprintf("body -- End"), OVM_DEBUG);

endtask : body

function hcw_transaction hqm_hcw_enq_sz_less_than_16B_seq::get_hcw_data(bit [3:0] cmd, hcw_qtype qtype, bit [7:0] qid, bit [15:0] lockid, output Iosf::data_t hcw_data[$]);

    hcw_transaction trans;
    bit [127:0]     temp;

    ovm_report_info(get_full_name(), $psprintf("get_hcw_data(cmd=0x%0x, qtype=%0s, qid=0x%0x, lockid=0x%0x) -- Start", cmd, qtype.name(), qid, lockid), OVM_DEBUG);
    trans = new("trans");
    hcw_data = '{};

    trans.byte_unpack(0, 'h0);
    { trans.qe_valid, trans.qe_orsp, trans.qe_uhl, trans.cq_pop } = cmd;
      trans.iptr                                                  = trans.get_transaction_id();
      trans.tbcnt                                                 = trans.get_transaction_id();
      trans.lockid                                                = lockid;
      trans.qtype                                                 = qtype;
      trans.qid                                                   = qid;
      temp = trans.byte_pack(0);
    for(int i = 0; i < 4; i++) begin
        hcw_data.push_back(temp[32*i +: 32]);
    end
    ovm_report_info(get_full_name(), $psprintf("get_hcw_data(cmd=0x%0x, qtype=%0s, qid=0x%0x, lockid=0x%0x, hcw_data=%0p) -- End", cmd, qtype.name(), qid, lockid, hcw_data), OVM_DEBUG);
    return trans;

endfunction : get_hcw_data

function void hqm_hcw_enq_sz_less_than_16B_seq::get_new_cmd(hcw_qtype qtype, bit [7:0] qid, output Iosf::data_t hcw_data[$]);

    ovm_report_info(get_full_name(), $psprintf("get_new_cmd(qtype=%0s, qid=0x%0x) -- Start", qtype.name(), qid), OVM_DEBUG);
    void'(get_hcw_data('b1000, qtype, qid, $urandom, hcw_data));
    ovm_report_info(get_full_name(), $psprintf("get_new_cmd(qtype=%0s, qid=0x%0x, hcw_data=%0p) -- End", qtype.name(), qid, hcw_data), OVM_DEBUG);

endfunction : get_new_cmd

function void hqm_hcw_enq_sz_less_than_16B_seq::get_batt_cmd(bit [15:0] num_tkn,  output Iosf::data_t hcw_data[$]);

    ovm_report_info(get_full_name(), $psprintf("get_batt_cmd(num_tkn=0x%0x) -- Start", num_tkn), OVM_DEBUG);
    void'(get_hcw_data('b0001, $urandom, $urandom, (num_tkn - 1), hcw_data));
    ovm_report_info(get_full_name(), $psprintf("get_batt_cmd(num_tkn=0x%0x, hcw_data=%0p) -- End", num_tkn, hcw_data), OVM_DEBUG);

endfunction : get_batt_cmd

function void hqm_hcw_enq_sz_less_than_16B_seq::get_cmp_cmd(output Iosf::data_t hcw_data[$]);

    ovm_report_info(get_full_name(), $psprintf("get_cmp_cmd -- Start"), OVM_DEBUG);
    void'(get_hcw_data('b0010, $urandom, $urandom, $urandom, hcw_data));
    ovm_report_info(get_full_name(), $psprintf("get_cmp_cmd(hcw_data=%0p) -- End", hcw_data), OVM_DEBUG);

endfunction : get_cmp_cmd

function void hqm_hcw_enq_sz_less_than_16B_seq::get_cmpt_cmd(bit [15:0] num_tkn, output Iosf::data_t hcw_data[$]);

    ovm_report_info(get_full_name(), $psprintf("get_cmpt_cmd(num_tkn=0x%0x) -- Start", num_tkn), OVM_DEBUG);
    void'(get_hcw_data('b0011, $urandom, $urandom, (num_tkn - 1), hcw_data));
    ovm_report_info(get_full_name(), $psprintf("get_cmpt_cmd(num_tkn=0x%0x, hcw_data=%0p) -- End", num_tkn, hcw_data), OVM_DEBUG);

endfunction : get_cmpt_cmd

function bit [63:0] hqm_hcw_enq_sz_less_than_16B_seq::get_pf_func_bar_addr();

    ovm_report_info(get_full_name(), $psprintf("get_pf_func_bar_addr -- Start"), OVM_DEBUG);
    get_pf_func_bar_addr[31:0]  = pf_cfg_regs.FUNC_BAR_L.get();
    get_pf_func_bar_addr[63:32] = pf_cfg_regs.FUNC_BAR_U.get();
    ovm_report_info(get_full_name(), $psprintf("get_pf_func_bar_addr(0x%0x) -- End", get_pf_func_bar_addr), OVM_DEBUG);

endfunction : get_pf_func_bar_addr

function IosfPkg::IosfTxn hqm_hcw_enq_sz_less_than_16B_seq::get_hcw_tlp(bit [7:0] pp, bit is_ldb, bit [9:0] i_length, Iosf::data_t i_data[$], bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'h0, bit [63:0] bar_offset);

    Iosf::address_t   i_addr;
    Iosf::iosf_cmd_t  i_cmd;

    ovm_report_info(get_full_name(), $psprintf("get_hcw_tlp(pp=0x%0x, is_ldb=%0b, i_length=0x%0x, i_data=%0p, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b, bar_offset=0x%0x) -- Start",
                                                            pp,       is_ldb,     i_length,       i_data,     is_nm_pf,     i_first_byte_en,    i_last_byte_en,    bar_offset), OVM_DEBUG);
    i_addr        = get_pf_func_bar_addr();
    i_addr[25:0]  = 'h200_0000;
    i_addr[21]    = is_nm_pf;
    i_addr[20]    = is_ldb;
    i_addr[19:12] = pp;
    i_addr       += bar_offset;
    i_cmd         = Iosf::MWr64;
    get_hcw_tlp   = get_tlp(i_addr, i_cmd, i_data, 0, 0, 0, 0, i_length, 0, i_first_byte_en, i_last_byte_en, 0, 0);
    ovm_report_info(get_full_name(), $psprintf("get_hcw_tlp(pp=0x%0x, is_ldb=%0b, i_data=%0p, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b, bar_offset=0x%0x) -- End",
                                                            pp,       is_ldb,     i_data,     is_nm_pf,     i_first_byte_en,    i_last_byte_en,    bar_offset), OVM_DEBUG); 

endfunction : get_hcw_tlp

task hqm_hcw_enq_sz_less_than_16B_seq::send_new_cmd(bit [7:0] pp, bit is_ldb, hcw_qtype qtype, bit [7:0] qid, bit [9:0] i_length = 'd4, bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'h0, bit [63:0] bar_offset = 'h0);

    IosfPkg::IosfTxn tlp;
    Iosf::data_t     hcw_data[$];

    ovm_report_info(get_full_name(), $psprintf("send_new_cmd(pp=0x%0x, is_ldb=%0b, qtype=%0s,    qid=0x%0x, i_length=0x%0x, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b, bar_offset=0x%0x) -- Start",
                                                             pp,       is_ldb,     qtype.name(), qid,       i_length,       is_nm_pf,     i_first_byte_en,    i_last_byte_en, bar_offset), OVM_DEBUG);
    if (i_length < 4) begin
        hcw_data = {};
        for(int i = 0; i < i_length; i++) begin
            hcw_data.push_back($urandom);
        end
    end else begin
        for (int i = 0 ; i < (i_length / 4); i++) begin

            Iosf::data_t lcl_hcw_data[$];

            get_new_cmd(qtype, qid, lcl_hcw_data);
            hcw_data = {hcw_data, lcl_hcw_data};
        end

        for (int i = 0 ; i < (i_length % 4); i++) begin
            hcw_data.push_back($urandom);
        end
    end
    tlp = get_hcw_tlp(pp, is_ldb, i_length, hcw_data, is_nm_pf, i_first_byte_en, i_last_byte_en, bar_offset);
    send_tlp(tlp);
    ovm_report_info(get_full_name(), $psprintf("send_new_cmd(pp=0x%0x, is_ldb=%0b, qtype=%0s,    qid=0x%0x, i_length=0x%0x, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b, bar_offset=0x%0x) -- End",
                                                             pp,       is_ldb,     qtype.name(), qid,       i_length,       is_nm_pf,     i_first_byte_en,    i_last_byte_en, bar_offset), OVM_DEBUG);
endtask : send_new_cmd

task hqm_hcw_enq_sz_less_than_16B_seq::send_new_cmd_updated_iosf_cmd(Iosf::iosf_cmd_t iosf_cmd, bit [7:0] pp, bit is_ldb, hcw_qtype qtype, bit [7:0] qid, bit [9:0] i_length = 'd4, bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'h0, bit ur = 0, bit [63:0] bar_offset = 'h0);

    IosfPkg::IosfTxn tlp;
    Iosf::data_t     hcw_data[$];

    ovm_report_info(get_full_name(), $psprintf("send_new_cmd_updated_iosf_cmd(iosf_cmd=%0s,    pp=0x%0x, is_ldb=%0b, qtype=%0s,    qid=0x%0x, i_length=0x%0x, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b, ur=%0b, bar_offset=0x%0x) -- Start",
                                                                              iosf_cmd.name(), pp,       is_ldb,     qtype.name(), qid,       i_length,       is_nm_pf,     i_first_byte_en,    i_last_byte_en,    ur    , bar_offset), OVM_DEBUG);
    if (i_length < 4) begin
        hcw_data = {};
        for(int i = 0; i < i_length; i++) begin
            hcw_data.push_back($urandom);
        end
    end else begin
        for(int i = 0 ; i < (i_length / 4) ; i++) begin

            Iosf::data_t lcl_hcw_data[$];

            get_new_cmd(qtype, qid, lcl_hcw_data);
            hcw_data = {hcw_data, lcl_hcw_data};
        end 

        for (int i = 0 ; i < (i_length % 4); i++) begin
            hcw_data.push_back($urandom);
        end
    end
    tlp = get_hcw_tlp(pp, is_ldb, i_length, hcw_data, is_nm_pf, i_first_byte_en, i_last_byte_en, bar_offset);
    tlp.cmd = iosf_cmd;
    send_tlp(tlp, ur);
    ovm_report_info(get_full_name(), $psprintf("send_new_cmd_updated_iosf_cmd(iosf_cmd=%0s,    pp=0x%0x, is_ldb=%0b, qtype=%0s,    qid=0x%0x, i_length=0x%0x, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b, ur=%0b, bar_offset=0x%0x) -- End",
                                                                              iosf_cmd.name(), pp,       is_ldb,     qtype.name(), qid,       i_length,       is_nm_pf,     i_first_byte_en,    i_last_byte_en,    ur    , bar_offset), OVM_DEBUG);
endtask : send_new_cmd_updated_iosf_cmd

task hqm_hcw_enq_sz_less_than_16B_seq::send_batt_cmd(bit [7:0] pp, bit is_ldb, bit [15:0] num_tkn, bit [9:0] i_length = 'd4, bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'h0);

    IosfPkg::IosfTxn tlp;
    Iosf::data_t     hcw_data[$];

    ovm_report_info(get_full_name(), $psprintf("send_batt_cmd(pp=0x%0x, is_ldb=%0b, num_tkn=0x%0x, i_length=0x%0x, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b) -- Start",
                                                             pp,       is_ldb,      num_tkn,       i_length,       is_nm_pf,     i_first_byte_en,    i_last_byte_en), OVM_DEBUG);
    get_batt_cmd(num_tkn, hcw_data);
    tlp = get_hcw_tlp(pp, is_ldb, i_length, hcw_data, is_nm_pf, i_first_byte_en, i_last_byte_en, 0);
    send_tlp(tlp);
    ovm_report_info(get_full_name(), $psprintf("send_batt_cmd(pp=0x%0x, is_ldb=%0b, num_tkn, i_length=0x%0x, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b) -- End",
                                                             pp,       is_ldb,      num_tkn,       i_length,       is_nm_pf,     i_first_byte_en,    i_last_byte_en), OVM_DEBUG);
endtask : send_batt_cmd

task hqm_hcw_enq_sz_less_than_16B_seq::send_cmp_cmd(bit [7:0] pp, bit is_ldb, bit [9:0] i_length = 'd4, bit is_nm_pf = 1'b0, bit [3:0] i_first_byte_en = 4'hf, bit [3:0] i_last_byte_en = 4'h0);

    IosfPkg::IosfTxn tlp;
    Iosf::data_t     hcw_data[$];

    ovm_report_info(get_full_name(), $psprintf("send_cmp_cmd(pp=0x%0x, is_ldb=%0b, i_length=0x%0x, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b) -- Start",
                                                             pp,       is_ldb,     i_length,       is_nm_pf,     i_first_byte_en,    i_last_byte_en), OVM_DEBUG);
    get_cmp_cmd(hcw_data);
    tlp = get_hcw_tlp(pp, is_ldb, i_length, hcw_data, is_nm_pf, i_first_byte_en, i_last_byte_en, 0);
    send_tlp(tlp);
    ovm_report_info(get_full_name(), $psprintf("send_cmp_cmd(pp=0x%0x, is_ldb=%0b, i_length=0x%0x, is_nm_pf=%0b, i_first_byte_en=%b, i_last_byte_en=%b) -- End",
                                                             pp,       is_ldb,     i_length,       is_nm_pf,     i_first_byte_en,    i_last_byte_en), OVM_DEBUG);
endtask : send_cmp_cmd

function sla_ral_reg hqm_hcw_enq_sz_less_than_16B_seq::get_reg_handle (string reg_name, string file_name = "");

    ovm_report_info(get_full_name(), $psprintf("get_reg_handle(reg_name=%0s, file_name=%0s) -- Start", reg_name, file_name), OVM_DEBUG);
    if (file_name == "") begin
        get_reg_handle = ral.find_reg(reg_name);
    end else begin
        get_reg_handle = ral.find_reg_by_file_name(reg_name, file_name);
    end
    if (get_reg_handle == null) begin
        ovm_report_fatal(get_full_name(), $psprintf("get_reg_handle(reg_name=%0s, file_name=%0s) -- Null reg handle", reg_name, file_name));
    end
    ovm_report_info(get_full_name(), $psprintf("get_reg_handle(reg_name=%0s, file_name=%0s) -- End", reg_name, file_name), OVM_DEBUG);

endfunction : get_reg_handle

task hqm_hcw_enq_sz_less_than_16B_seq::write_reg (string reg_name, sla_ral_data_t wr_data, string file_name = "");

    sla_ral_reg  reg_h;
    sla_status_t status;
    sla_ral_access_path_t ral_access_path;

    ovm_report_info(get_full_name(), $psprintf("write_reg(reg_name=%0s, wr_data=0x%0x, file_name=%0s) -- Start", reg_name, wr_data, file_name), OVM_DEBUG);
    reg_h = get_reg_handle(reg_name, file_name);
   ral_access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    reg_h.write(status, wr_data, ral_access_path, this);
    ovm_report_info(get_full_name(), $psprintf("write_reg(reg_name=%0s, wr_data=0x%0x, file_name=%0s) -- End", reg_name, wr_data, file_name), OVM_DEBUG);

endtask : write_reg

task hqm_hcw_enq_sz_less_than_16B_seq::compare_reg (string reg_name, sla_ral_data_t exp_val, output sla_ral_data_t rd_val, input string file_name = "");

    sla_ral_reg    reg_h;
    sla_status_t   status;
    sla_ral_access_path_t ral_access_path;

    ovm_report_info(get_full_name(), $psprintf("compare_reg(reg_name=%0s, exp_val=0x%0x, file_name=%0s) -- Start", reg_name, exp_val, file_name), OVM_DEBUG);
    reg_h = get_reg_handle(reg_name, file_name);
   ral_access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    reg_h.readx(status, exp_val, 'hffff_ffff, rd_val, ral_access_path, SLA_FALSE, this);
    ovm_report_info(get_full_name(), $psprintf("compare_reg(reg_name=%0s, exp_val=0x%0x, rd_val, file_name=%0s) -- End", reg_name, exp_val, rd_val, file_name), OVM_DEBUG);

endtask : compare_reg

task hqm_hcw_enq_sz_less_than_16B_seq::send_iosf_prim(bit [7:0] pp, bit is_ldb, bit [3:0] cmd, hcw_qtype qtype, bit [7:0] qid, bit [15:0] lockid, bit is_nm_pf = 1'b0);

    hcw_transaction     trans;
    Iosf::data_t        hcw_data[$];
    bit [127:0]         hcw_data_bits;
    hqm_hcw_enq_seq     hcw_enq_seq;
    bit [63:0]          pp_addr;
    sla_ral_data_t      ral_data;

    ovm_report_info(get_full_name(), $psprintf("send_iosf_prim(pp=0x%0x, is_ldb=%0b, cmd=0x%0x, qtype=%0s,    qid=0x%0x, lockid=0x%0x, is_nm_pf=%0b) -- Start",     
                                                               pp,       is_ldb,     cmd,       qtype.name(), qid,       lockid,       is_nm_pf), OVM_DEBUG);
    trans = get_hcw_data(cmd, qtype, qid, lockid, hcw_data);
    trans.ppid     = pp;
    trans.is_ldb   = is_ldb;
    trans.sai      = 8'h3;
    trans.is_nm_pf = is_nm_pf;

    if (trans.reord == 0)
      trans.ordidx = trans.tbcnt;

    trans.enqattr = 2'h0;   
    trans.sch_is_ldb = (trans.qtype == QDIR)? 1'b0 : 1'b1;
    if (trans.qe_valid == 1 && trans.qtype != QORD ) begin
      if (trans.qtype == QDIR ) begin
        trans.enqattr = 2'h0;      
      end else begin
        trans.enqattr[1:0] = {trans.qe_orsp, trans.qe_uhl};        
      end                      
    end
    
    //----    
    //-- trans.isdir is hidden info in ptr
    //----    
    if(trans.qtype == QDIR) trans.isdir=1;
    else                   trans.isdir=0;
    
    trans.set_hcw_trinfo(1);           //--kind=1: do not set iptr[63:48]=tbcnt
    
    //-- pass hcw_item to sb
    i_hqm_cfg.write_hcw_gen_port(trans);
    
    trans.hcw_batch         = 1'b0;

    hcw_data_bits = trans.byte_pack(0);
    
    pp_addr = 64'h0000_0000_0200_0000;
    
    ral_data = pf_cfg_regs.FUNC_BAR_U.get_actual();
    
    pp_addr[63:32] = ral_data[31:0];
    
    ral_data = pf_cfg_regs.FUNC_BAR_L.get_actual();
    
    pp_addr[31:26] = ral_data[31:26];
  
    pp_addr[19:12] = trans.ppid;
    pp_addr[20]    = trans.is_ldb;
    pp_addr[21]    = trans.is_nm_pf;
    pp_addr[9:6]   = 4'h0;
  
    `ovm_create(hcw_enq_seq)
  
    `ovm_rand_send_with(hcw_enq_seq, { 
                                         pp_enq_addr == pp_addr;
                                         sai == trans.sai;
                                         hcw_enq_q.size == 1;
                                         hcw_enq_q[0] == hcw_data_bits;
                                     })
      

    ovm_report_info(get_full_name(), $psprintf("send_iosf_prim(pp=0x%0x, is_ldb=%0b, cmd=0x%0x, qtype=%0s, qid=0x%0x, lockid=0x%0x, is_nm_pf=%0b) -- End",     
                                                               pp,       is_ldb,     cmd,       qtype,     qid,       lockid,       is_nm_pf), OVM_DEBUG);

endtask : send_iosf_prim

task hqm_hcw_enq_sz_less_than_16B_seq::send_new_iosf_prim(bit [7:0] pp, bit is_ldb, hcw_qtype qtype, bit [7:0] qid, bit is_nm_pf = 1'b0);

    ovm_report_info(get_full_name(), $psprintf("send_new_iosf_prim(pp=0x%0x, is_ldb=%0b, qtype=%0s,    qid=0x%0x, is_nm_pf=%0b) -- Start",
                                                                   pp,       is_ldb,     qtype.name(), qid,       is_nm_pf), OVM_DEBUG);
    send_iosf_prim(pp, is_ldb, 'b1000, qtype, qid, $urandom, is_nm_pf);
    ovm_report_info(get_full_name(), $psprintf("send_new_iosf_prim(pp=0x%0x, is_ldb=%0b, qtype=%0s,    qid=0x%0x, is_nm_pf=%0b) -- End",
                                                                   pp,       is_ldb,     qtype.name(), qid,       is_nm_pf), OVM_DEBUG);

endtask : send_new_iosf_prim

task hqm_hcw_enq_sz_less_than_16B_seq::send_batt_iosf_prim(bit [7:0] pp, bit is_ldb, bit [15:0] num_tkn, bit is_nm_pf = 1'b0);

    ovm_report_info(get_full_name(), $psprintf("send_batt_iosf_prim(pp=0x%0x, is_ldb=%0b, num_tkn=0x%0x, is_nm_pf=%0b) -- Start",
                                                                    pp,       is_ldb,     num_tkn,       is_nm_pf), OVM_DEBUG);
    send_iosf_prim(pp, is_ldb, 'b0001, hcw_qtype'($urandom_range(0, 3)), $urandom, (num_tkn - 1), is_nm_pf);
    ovm_report_info(get_full_name(), $psprintf("send_batt_iosf_prim(pp=0x%0x, is_ldb=%0b, num_tkn=0x%0x, is_nm_pf=%0b) -- End",
                                                                    pp,       is_ldb,     num_tkn,       is_nm_pf), OVM_DEBUG);

endtask : send_batt_iosf_prim

task hqm_hcw_enq_sz_less_than_16B_seq::check_pcie_regs(bit ned = 1'b1, bit fed = 1'b0, bit ced = 1'b0);

    sla_ral_data_t rd_val;

    ovm_report_info(get_full_name(), $psprintf("check_pcie_regs(fed=%0b, ned=%0d, ced=%0b) -- Start", fed, ned, ced), OVM_DEBUG);
    poll_reg("pcie_cap_device_status",  ( (1 << 3) | (fed << 2) | (ned << 1) | (ced << 0) ), "hqm_pf_cfg_i"); 
    write_reg("pcie_cap_device_status", ( (1 << 3) | (fed << 2) | (ned << 1) | (ced << 0) ), "hqm_pf_cfg_i");
    compare_reg("pcie_cap_device_status", 'h0, rd_val, "hqm_pf_cfg_i"); 

    poll_reg("aer_cap_uncorr_err_status" , 'h10_0000, "hqm_pf_cfg_i");
    write_reg("aer_cap_uncorr_err_status", 'h10_0000, "hqm_pf_cfg_i");
    compare_reg("aer_cap_uncorr_err_status", 'h0, rd_val, "hqm_pf_cfg_i");

    if (ced) begin
        poll_reg("aer_cap_corr_err_status",  'h2000, "hqm_pf_cfg_i");
        write_reg("aer_cap_corr_err_status", 'h2000, "hqm_pf_cfg_i");
        compare_reg("aer_cap_corr_err_status", 'h0, rd_val, "hqm_pf_cfg_i");
    end

    ovm_report_info(get_full_name(), $psprintf("check_pcie_regs(fed=%0b, ned=%0d, ced=%0b) -- End", fed, ned, ced),   OVM_DEBUG);

endtask : check_pcie_regs

task hqm_hcw_enq_sz_less_than_16B_seq::poll_reg(string reg_name, sla_ral_data_t comp_val, string file_name);

    sla_ral_reg reg_h;

    ovm_report_info(get_full_name(), $psprintf("poll_reg(reg_name=%0s, comp_val=0x%0x, file_name=%0s) -- Start", reg_name, comp_val, file_name), OVM_DEBUG);
    reg_h = ral.find_reg_by_file_name(reg_name, file_name);
    poll_reg_val(reg_h, comp_val, 'hffff_ffff);
    ovm_report_info(get_full_name(), $psprintf("poll_reg(reg_name=%0s, comp_val=0x%0x, file_name=%0s) -- End", reg_name, comp_val, file_name), OVM_DEBUG);

endtask : poll_reg

function bit [7:0] hqm_hcw_enq_sz_less_than_16B_seq::get_byte_en();

    int unsigned min;
    int unsigned rand_val;

    ovm_report_info(get_full_name(), $psprintf("get_byte_en -- Start"), OVM_DEBUG);
   
    rand_val    = $urandom_range(2, 7); 
    get_byte_en = ( ( 2 ** rand_val ) - 1);
    min         = (rand_val >= 5)? 0 : (5 - rand_val);
    get_byte_en = get_byte_en << $urandom_range(min, 3);

    ovm_report_info(get_full_name(), $psprintf("get_byte_en(%0d) -- End", get_byte_en), OVM_DEBUG);

endfunction : get_byte_en

`endif // HQM_HCW_ENQ_SZ_LESS_THAN_16B_SEQ__SV
