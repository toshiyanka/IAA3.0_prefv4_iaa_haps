`ifndef HQM_PRE_ADR_SEQ__SV
`define HQM_PRE_ADR_SEQ__SV

class hqm_pre_adr_seq extends hqm_base_seq;

    local ovm_event                      blocking_event;
           hqm_iosf_prim_nonblocking_seq i_nonblocking_seq;
           hqm_iosf_trans_status         i_hqm_iosf_trans_status;

    `ovm_sequence_utils(hqm_pre_adr_seq, sla_sequencer)

    extern         function new             (string name = "hqm_pre_adr_seq");
    extern virtual task     send_traffic    ();
    extern virtual task     body            ();
    extern virtual task     end_seq         ();
    extern virtual task     check_responses ();

endclass : hqm_pre_adr_seq

function hqm_pre_adr_seq::new(string name = "hqm_pre_adr_seq");
    super.new(name);
    blocking_event    = new("blocking_event");
    i_nonblocking_seq = hqm_iosf_prim_nonblocking_seq::type_id::create("i_nonblocking_seq");
endfunction : new

task hqm_pre_adr_seq::body();

    ovm_object tmp;

    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);
    if (p_sequencer.get_config_object("i_hqm_iosf_trans_status", tmp, 0)) begin
        if (!$cast(i_hqm_iosf_trans_status, tmp) ) begin
            ovm_report_fatal(get_full_name(), $psprintf("Object not compatible with hqm_iosf_trans_status"));
        end 
    end else begin
        ovm_report_fatal(get_full_name(), $psprintf("No object set for i_hqm_iosf_trans_status"));
    end
    fork
       begin   
          i_nonblocking_seq.start(p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()));
       end
    join_none
    blocking_event.wait_ptrigger();
    ovm_report_info(get_full_name(), $psprintf("body -- End"), OVM_DEBUG);

endtask : body

task hqm_pre_adr_seq::end_seq();

    ovm_report_info(get_full_name(), $psprintf("end_seq -- Start"), OVM_DEBUG);
    i_nonblocking_seq.end_seq();
    blocking_event.trigger();
    ovm_report_info(get_full_name(), $psprintf("end_seq -- End"),   OVM_DEBUG);
endtask : end_seq 

task hqm_pre_adr_seq::send_traffic();

    sla_ral_addr_t addr;
    int unsigned   cfgrd0_cnt;
    int unsigned   memrd_cnt;

    ovm_report_info(get_full_name(), $psprintf("send_traffic -- Start"), OVM_DEBUG); 
    i_nonblocking_seq.wait_for_sequence_state(BODY);

    // -- Get the count of CFG_RD0 and MemRd transactions 
    cfgrd0_cnt = i_hqm_iosf_trans_status.get_cnt(PCIE_CFG_RD0);
    memrd_cnt  = i_hqm_iosf_trans_status.get_cnt(CSR_READ);

    // -- Send CfgRd0 transactions
    ovm_report_info(get_full_name(), $psprintf("Send CfgRd0 transactions"), OVM_LOW);
    i_nonblocking_seq.send_CfgRd0(get_reg_addr("vendor_id", "hqm_pf_cfg_i"),      pick_legal_sai_value(RAL_READ, "vendor_id", "hqm_pf_cfg_i"));
    i_nonblocking_seq.send_CfgRd0(get_reg_addr("device_id", "hqm_pf_cfg_i"),      pick_legal_sai_value(RAL_READ, "device_id", "hqm_pf_cfg_i"));
    i_nonblocking_seq.send_CfgRd0(get_reg_addr("device_command", "hqm_pf_cfg_i"), pick_legal_sai_value(RAL_READ, "device_command", "hqm_pf_cfg_i"));
    i_nonblocking_seq.send_CfgRd0(get_reg_addr("device_status", "hqm_pf_cfg_i"),  pick_legal_sai_value(RAL_READ, "device_status", "hqm_pf_cfg_i"));

    // -- Send MemWr transactions
    ovm_report_info(get_full_name(), $psprintf("Send MemWr transactions"), OVM_LOW);
    i_nonblocking_seq.send_MemWr(get_reg_addr("total_credits", "hqm_system_csr"), '{0}, pick_legal_sai_value(RAL_WRITE, "total_credits", "hqm_system_csr"));
    i_nonblocking_seq.send_MemWr(get_reg_addr("total_ldb_qid", "hqm_system_csr"), '{0}, pick_legal_sai_value(RAL_WRITE, "total_ldb_qid", "hqm_system_csr"));
    i_nonblocking_seq.send_MemWr(get_reg_addr("total_dir_qid", "hqm_system_csr"), '{0}, pick_legal_sai_value(RAL_WRITE, "total_dir_qid", "hqm_system_csr"));

    // -- Send MemRd transactions
    ovm_report_info(get_full_name(), $psprintf("send MemRd transctions"), OVM_LOW);
    i_nonblocking_seq.send_MemRd(get_reg_addr("total_credits", "hqm_system_csr"), 1, pick_legal_sai_value(RAL_READ, "total_credits", "hqm_system_csr"));
    i_nonblocking_seq.send_MemRd(get_reg_addr("total_ldb_qid", "hqm_system_csr"), 1, pick_legal_sai_value(RAL_READ, "total_ldb_qid", "hqm_system_csr"));
    i_nonblocking_seq.send_MemRd(get_reg_addr("total_dir_qid", "hqm_system_csr"), 1, pick_legal_sai_value(RAL_READ, "total_dir_qid", "hqm_system_csr"));

    forever begin
        if ( ( (i_hqm_iosf_trans_status.get_cnt(PCIE_CFG_RD0) ) == (cfgrd0_cnt + 4) ) &&
             ( (i_hqm_iosf_trans_status.get_cnt(CSR_READ)     ) == (memrd_cnt  + 3) )
           ) begin
            break;
        end
        wait_for_clk(1);
    end
    ovm_report_info(get_full_name(), $psprintf("send_traffic -- End"),   OVM_DEBUG);
    
endtask : send_traffic

task hqm_pre_adr_seq::check_responses();

    IosfTxn tmp;

    ovm_report_info(get_full_name(), $psprintf("check_responses -- Start"), OVM_DEBUG);
    i_nonblocking_seq.wait_for_all_responses();
    while(i_nonblocking_seq.cfgrd0_q.size() != 0) begin

        tmp = i_nonblocking_seq.cfgrd0_q.pop_front();
        if (tmp.complete != 1) begin
            ovm_report_error(get_full_name(), $psprintf("Transaction not complete\n%0s", tmp.convert2string()));
            continue;
        end else begin
            ovm_report_info(get_full_name(), $psprintf("Completion(%0s) received for transaction sent before ip_pm_adr_req\n%0s", tmp.cplStatus.name(), tmp.convert2string()), OVM_HIGH);
        end
    end
    while(i_nonblocking_seq.memrd_q.size() != 0) begin

        tmp = i_nonblocking_seq.memrd_q.pop_front();
        if (tmp.complete != 1) begin
            ovm_report_error(get_full_name(), $psprintf("Transaction not complete\n%0s", tmp.convert2string()));
            continue;
        end else begin
            ovm_report_info(get_full_name(), $psprintf("Completion(%0s) received for transaction sent before ip_pm_adr_req\n%0s", tmp.cplStatus.name(), tmp.convert2string()), OVM_HIGH);
        end
    end
    ovm_report_info(get_full_name(), $psprintf("check_responses -- End"),   OVM_DEBUG);

endtask : check_responses

`endif //HQM_PRE_ADR_SEQ__SV
