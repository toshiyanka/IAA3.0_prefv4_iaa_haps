`ifndef HQM_IOSF_PRIM_NONBLOCKING_SEQ__SV
`define HQM_IOSF_PRIM_NONBLOCKING_SEQ__SV

class hqm_iosf_prim_nonblocking_seq extends hqm_iosf_prim_np_base_seq;

          IosfTxn   cfgrd0_q[$];
          IosfTxn   memrd_q[$];
    local ovm_event blocking_event;

    `ovm_sequence_utils(hqm_iosf_prim_nonblocking_seq, IosfAgtSeqr)

    extern         function new                           (string name = "hqm_iosf_prim_nonblocking_seq");
    extern         function void response_handler         (ovm_sequence_item response);
    extern virtual task          send_CfgRd0              (bit [63:0] addr, bit [7:0] sai); 
    extern virtual task          send_MemRd               (bit [63:0] addr, int unsigned data_sz, bit [7:0] sai);
    extern virtual task          send_MemWr               (bit [63:0] addr, Iosf::data_t data[],  bit [7:0] sai);
    extern virtual task          wait_for_complete        (IosfTxn q[$]);
    extern virtual task          wait_for_cfgrd0_complete ();
    extern virtual task          wait_for_memrd_complete  ();
    extern virtual task          wait_for_all_responses   ();
    extern virtual task          body                     ();
    extern virtual task          end_seq                  ();

endclass : hqm_iosf_prim_nonblocking_seq

function hqm_iosf_prim_nonblocking_seq::new(string name = "hqm_iosf_prim_nonblocking_seq");
    super.new(name);
    blocking_event = new("blocking_event");
endfunction : new

task hqm_iosf_prim_nonblocking_seq::body();

    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);
    blocking_event.wait_ptrigger();
    ovm_report_info(get_full_name(), $psprintf("body -- End"),   OVM_DEBUG);

endtask : body

task hqm_iosf_prim_nonblocking_seq::end_seq();

    ovm_report_info(get_full_name(), $psprintf("end_seq -- Start"), OVM_DEBUG);
    blocking_event.trigger();
    ovm_report_info(get_full_name(), $psprintf("end_seq -- End"), OVM_DEBUG);

endtask : end_seq

task hqm_iosf_prim_nonblocking_seq::send_CfgRd0(bit [63:0] addr, bit [7:0] sai);

    IosfTxn      iosfTxn;
    Iosf::data_t data_i[];
    bit [3:0]    byte_en;

    ovm_report_info(get_full_name(), $psprintf("send_CfgRd0(addr=0x%0x, sai=0x%0x) -- Start", addr, sai), OVM_DEBUG);

    iosfTxn = new("iosfTxn");

    data_i = new[1];

    case (reg_size) 
        8  : begin
                byte_en = 4'(4'd1 << addr[1:0]);
             end
        16 : begin
                if (addr[1:0] == 2'd3) begin
                    ovm_report_error(get_full_name(), $psprintf("Unsupported RAL access combination(address=0x%0x, reg_size=0x%0x)", addr, reg_size));
                end else begin
                    byte_en = 4'(4'd3 << addr[1:0]);
                end
             end
        24 : begin
                if (addr[1:0] >= 2'd2) begin
                    ovm_report_error(get_full_name(), $psprintf("Unsupported RAL access combination(address=0x%0x, reg_size=0x%0x)", addr, reg_size));
                end else begin
                    byte_en = 4'(4'd7 << addr[1:0]);
                end
             end
        32 : begin
                 if (addr[1:0] >= 2'd1) begin
                     ovm_report_error(get_full_name(), $psprintf("Unsupported RAL access combination(address=0x%0x, reg_size=0x%0x)", addr, reg_size));
                 end else begin
                     byte_en = 4'b1111;
                 end
             end
    endcase

    iosfTxn.cmd                     = Iosf::CfgRd0;
    iosfTxn.reqChId                 = 0;
    iosfTxn.trafficClass            = 0;
    iosfTxn.reqID                   = 0;
    iosfTxn.reqType                 = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
    iosfTxn.procHint                = 0;
    iosfTxn.length                  = 1;
    iosfTxn.address                 = { addr[63:2], 2'b0 };
    iosfTxn.byteEnWithData          = 0;
    iosfTxn.data                    = data_i;
    iosfTxn.first_byte_en           = byte_en;
    iosfTxn.last_byte_en            = 4'h0;
    iosfTxn.reqLocked               = 0;  
    iosfTxn.compareType             = Iosf::CMP_EQ;
    iosfTxn.compareCompletion       = 0;
    iosfTxn.waitForCompletion       = 0;
    iosfTxn.pollingMode             = 0;
    get_next_tag();
    iosfTxn.tag                     = iosf_tag;
    iosfTxn.expectRsp               = 0;
    iosfTxn.driveBadCmdParity       =  $test$plusargs("HQM_CFG_RD_BAD_PARITY") ? 1 : 0;
    iosfTxn.driveBadDataParity      =  0;
    iosfTxn.driveBadDataParityCycle =  0;
    iosfTxn.driveBadDataParityPct   =  0;
    iosfTxn.reqGap                  =  0;
    iosfTxn.chain                   =  1'b0;
    iosfTxn.sai                     =  sai;

    start_item(iosfTxn);
    finish_item(iosfTxn);
    ovm_report_info(get_full_name(), $psprintf("Pushing transaction in cfgrd0_q\n%0s", iosfTxn.convert2string()), OVM_DEBUG);
    cfgrd0_q.push_back(iosfTxn);

    ovm_report_info(get_full_name(), $psprintf("send_CfgRd0(addr=0x%0x, sai=0x%0x) -- End", addr, sai), OVM_DEBUG);

endtask : send_CfgRd0

task hqm_iosf_prim_nonblocking_seq::send_MemRd(bit [63:0] addr, int unsigned data_sz, bit [7:0] sai);

    IosfTxn               iosfTxn;
    Iosf::data_t          data_i[];

    ovm_report_info(get_full_name(), $psprintf("send_MemRd(addr=0x%0x, data_sz=%0d, sai=0x%0x) -- Start", addr, data_sz, sai), OVM_DEBUG);

    iosfTxn = new("iosfTxn");
    iosfTxn.cmd                     = (addr[63:32] == 32'h0) ? Iosf::MRd32 : Iosf::MRd64;
    iosfTxn.reqChId                 = 0;
    iosfTxn.trafficClass            = 0;
    iosfTxn.reqID                   = 0;
    iosfTxn.reqType                 = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
    iosfTxn.procHint                = 0;
    iosfTxn.length                  = data_sz;
    iosfTxn.address                 = addr;
    iosfTxn.byteEnWithData          = 0;
    iosfTxn.data                    = data_i;
    iosfTxn.first_byte_en           = 4'hf;
    iosfTxn.last_byte_en            = (data_sz > 1) ? 4'hf : 4'h0 ;
    iosfTxn.reqLocked               = 0;  
    iosfTxn.compareType             = Iosf::CMP_EQ;
    iosfTxn.compareCompletion       = 0;
    iosfTxn.waitForCompletion       = 0;
    iosfTxn.pollingMode             = 0;
    get_next_tag();
    iosfTxn.tag                     = iosf_tag;
    iosfTxn.expectRsp               = 0;
    iosfTxn.driveBadCmdParity       =  0;
    iosfTxn.driveBadDataParity      =  0;
    iosfTxn.driveBadDataParityCycle =  0;
    iosfTxn.driveBadDataParityPct   =  0;
    iosfTxn.reqGap                  =  0;
    iosfTxn.chain                   =  1'b0;
    iosfTxn.sai                     =  sai;

    start_item(iosfTxn);
    finish_item(iosfTxn);
    ovm_report_info(get_full_name(), $psprintf("Pushing transaction in memrd_q\n%0s", iosfTxn.convert2string()), OVM_DEBUG);
    memrd_q.push_back(iosfTxn);
    ovm_report_info(get_full_name(), $psprintf("send_MemRd(addr=0x%0x, data_sz=%0d, sai=0x%0x) -- End", addr, data_sz, sai), OVM_DEBUG);

endtask : send_MemRd

task hqm_iosf_prim_nonblocking_seq::wait_for_complete(IosfTxn q[$]);

    bit all_complete;

    ovm_report_info(get_full_name(), $psprintf("wait_for_all_responses -- Start"), OVM_DEBUG);
    forever begin
        
        all_complete = 1'b1;
        foreach(q[i]) begin
            ovm_report_info(get_full_name(), $psprintf("Waiting for complete bit to set\n%0s", q[i].convert2string()), OVM_DEBUG);
            if (! (q[i].complete) ) begin
                all_complete = 1'b0;
            end else begin
                ovm_report_info(get_full_name(), $psprintf("Complete bit set(CplStatus=%0s, CplData=%0p)\n%0s", q[i].cplStatus, q[i].cplData, q[i].convert2string()), OVM_DEBUG);
            end
        end 
        if (all_complete) begin
            break;
        end
        #1ns;
    end
    ovm_report_info(get_full_name(), $psprintf("wait_for_all_responses -- End"), OVM_DEBUG);

endtask : wait_for_complete

task hqm_iosf_prim_nonblocking_seq::wait_for_cfgrd0_complete();

    ovm_report_info(get_full_name(), $psprintf("wait_for_cfgrd0_complete -- Start"), OVM_DEBUG);
    wait_for_complete(cfgrd0_q);
    ovm_report_info(get_full_name(), $psprintf("wait_for_cfgrd0_complete -- End"),   OVM_DEBUG);

endtask : wait_for_cfgrd0_complete

task hqm_iosf_prim_nonblocking_seq::wait_for_memrd_complete();

    ovm_report_info(get_full_name(), $psprintf("wait_for_memrd_complete -- Start"), OVM_DEBUG);
    wait_for_complete(memrd_q);
    ovm_report_info(get_full_name(), $psprintf("wait_for_memrd_complete -- End"),   OVM_DEBUG);

endtask : wait_for_memrd_complete

task hqm_iosf_prim_nonblocking_seq::wait_for_all_responses();
    
    ovm_report_info(get_full_name(), $psprintf("wait_for_all_responses -- Start"), OVM_DEBUG);
    // -- CfgRd0 queue
    ovm_report_info(get_full_name(), $psprintf("Wait for CfgRd0 responses -- Start"), OVM_LOW);
    wait_for_cfgrd0_complete();
    ovm_report_info(get_full_name(), $psprintf("Wait for CfgRd0 responses -- End"), OVM_LOW);
    // -- MemRd queue
    ovm_report_info(get_full_name(), $psprintf("Wait for MemRd responses -- Start"), OVM_LOW);
    wait_for_memrd_complete();
    ovm_report_info(get_full_name(), $psprintf("Wait for MemRd responses -- End"), OVM_LOW);
    ovm_report_info(get_full_name(), $psprintf("wait_for_all_responses -- End"), OVM_DEBUG);

endtask : wait_for_all_responses

function void hqm_iosf_prim_nonblocking_seq::response_handler (ovm_sequence_item response);

    IosfTgtTxn rxRspTgtTxn;

    for (int i = 0; i < this.reqQ.size(); i++) begin
        if ( (this.reqQ[i].ovmSeqID == response.get_sequence_id()) &&
             (this.reqQ[i].ovmTxnID == response.get_transaction_id())
           )
           if (this.reqQ[i].reqType == Iosf::NONPOSTED) begin
               $cast(rxRspTgtTxn, response);
               $cast(reqQ[i].cplStatus, rxRspTgtTxn.tfbe[2:0]);
           end
    end
    super.response_handler(response);

endfunction: response_handler

task hqm_iosf_prim_nonblocking_seq::send_MemWr(bit [63:0] addr, Iosf::data_t data[], bit [7:0] sai);

    IosfTxn iosf_txn;

    ovm_report_info(get_full_name(), $psprintf("send_MemWr(addr=0x%0x, data=%0p, sai=0x%0x) -- Start", addr, data, sai), OVM_DEBUG);
    iosf_txn = new("iosf_txn");
    
    iosf_txn.cmd                     = (addr[63:32] == 0)? Iosf::MWr32 : Iosf::MWr64;
    iosf_txn.reqChId                 = 0;
    iosf_txn.trafficClass            = 0; 
    iosf_txn.reqID                   = 0;
    iosf_txn.reqType                 = Iosf::getReqTypeFromCmd (iosf_txn.cmd);
    iosf_txn.procHint                = 0;
    iosf_txn.length                  = data.size();
    iosf_txn.address                 = addr;
    iosf_txn.byteEnWithData          = 0;
    iosf_txn.data                    = data;
    iosf_txn.first_byte_en           = 4'hf;
    iosf_txn.last_byte_en            = (data.size() > 1) ? 4'hf : 4'h0;
    iosf_txn.reqLocked               = 0;  
    iosf_txn.compareType             = Iosf::CMP_EQ;
    iosf_txn.compareCompletion       = 0;
    iosf_txn.waitForCompletion       = 0;
    iosf_txn.pollingMode             = 0;
    get_next_tag();
    iosf_txn.tag                     = iosf_tag;
    iosf_txn.expectRsp               = 0;
    iosf_txn.driveBadCmdParity       = 0;
    iosf_txn.driveBadDataParity      = 0;
    iosf_txn.driveBadDataParityCycle = 0;
    iosf_txn.driveBadDataParityPct   = 0;
    iosf_txn.reqGap                  = 0;
    iosf_txn.chain                   = 1'b0;
    iosf_txn.sai                     = sai;
    
    start_item(iosf_txn);
    finish_item(iosf_txn);
    ovm_report_info(get_full_name(), $psprintf("send_MemWr(addr=0x%0x, data=%0p, sai=0x%0x) -- End", addr, data, sai), OVM_DEBUG);

endtask : send_MemWr

`endif //HQM_IOSF_PRIM_NONBLOCKING_SEQ__SV
