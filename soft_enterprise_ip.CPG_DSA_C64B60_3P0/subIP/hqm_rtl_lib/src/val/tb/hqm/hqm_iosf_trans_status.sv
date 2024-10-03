`ifndef HQM_IOSF_TRANS_STATUS__SV
`define HQM_IOSF_TRANS_STATUS__SV

typedef enum { HCW_SCH      = 0,  CQ_INT      = 1,  COMP_CQ_INT    = 2,  MSI_INT       = 3,  MSIX_INT     = 4,  HCW_ENQ            = 5, 
               HCW_ENQ_ADDR = 6,  CSR_WRITE   = 7,  CSR_WRITE_DATA = 8,  CSR_READ      = 9,  PCIE_CFG_WR0 = 10, PCIE_CFG_WR0_DATA  = 11,
               PCIE_CFG_RD0 = 12, HQM_GEN_CPL = 13, HQM_GEN_CPLD   = 14, HQM_GEN_CPLLK = 15, IMS_INT      = 16, UNKWN_TRANS_TO_HQM = 17, IMS_POLL_MODE_WR = 18
             } hqm_trans_type_e;

class hqm_iosf_trans_status extends ovm_object;

    local int unsigned trans_cnt[hqm_trans_type_e];

    `ovm_object_utils(hqm_iosf_trans_status)

    extern function new                  (string name = "hqm_iosf_trans_status");
    extern function void         inc_cnt (hqm_trans_type_e trans_type, int unsigned inc_by = 1);
    extern function int unsigned get_cnt (hqm_trans_type_e trans_type);

endclass : hqm_iosf_trans_status

function hqm_iosf_trans_status::new(string name = "hqm_iosf_trans_status");
    super.new(name);
endfunction : new

function void hqm_iosf_trans_status::inc_cnt (hqm_trans_type_e trans_type, int unsigned inc_by = 1);

    ovm_report_info(get_full_name(), $psprintf("inc_cnt(trans_type=%0s, inc_by=%0d) -- Start", trans_type.name(), inc_by), OVM_DEBUG);
    if (trans_cnt.exists(trans_type) ) begin
        trans_cnt[trans_type] += inc_by;
    end else begin
        trans_cnt[trans_type] = inc_by;
    end
    ovm_report_info(get_full_name(), $psprintf("inc_cnt(trans_type=%0s, inc_by=%0d) -- End", trans_type.name(), inc_by), OVM_DEBUG);

endfunction : inc_cnt

function int unsigned hqm_iosf_trans_status::get_cnt (hqm_trans_type_e trans_type);

    ovm_report_info(get_full_name(), $psprintf("get_cnt(trans_type=%0s) -- Start", trans_type.name()), OVM_DEBUG);
    if (trans_cnt.exists(trans_type)) begin
        get_cnt = trans_cnt[trans_type];
    end else begin
        get_cnt = 0;
    end
    ovm_report_info(get_full_name(), $psprintf("get_cnt(trans_type=%0s, get_cnt=%0d) -- End", trans_type.name(), get_cnt), OVM_DEBUG);

endfunction : get_cnt

`endif //HQM_IOSF_TRANS_STATUS_SV
