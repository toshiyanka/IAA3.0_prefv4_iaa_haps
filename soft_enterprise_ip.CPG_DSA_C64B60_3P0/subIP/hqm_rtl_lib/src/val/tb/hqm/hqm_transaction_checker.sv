//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
// Name  : hqm_transaction_checker.sv
// Desc. : To check whether the transactions generated are correct or not.
//-----------------------------------------------------------------------------------------------------

`ifndef HQM_TRANSACTION_CHECK__SV
`define HQM_TRANSACTION_CHECK__SV

// -- The defines are to be used only in this file
`define WRITE_VALID_BEATS  0
`define WRITE_SINGLE_BEATS 1
`define HOLD_SCH_SM        2

class hqm_transaction_checker extends ovm_component;

    bit [31:0] write_buffer_ctl;

    sla_ral_env ral;

    ovm_analysis_imp #(iosf_trans_type_st, hqm_transaction_checker) iosf_prim_trans_analysis_imp;

    `ovm_component_utils(hqm_transaction_checker)

    extern function      new                   (string name = "hqm_transaction_checker", ovm_component parent = null);
    extern function void build                 ();
    extern function void write                 (iosf_trans_type_st t);
    extern function void process_hcw_sch       (IosfMonTxn t);
    extern function void process_hqm_csr_write (IosfMonTxn t);

endclass : hqm_transaction_checker

function hqm_transaction_checker::new(string name = "hqm_transaction_checker", ovm_component parent = null);
    super.new(name, parent);
endfunction : new

function void hqm_transaction_checker::build();

    iosf_prim_trans_analysis_imp = new("iosf_prim_trans_analysis_imp", this);
    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

endfunction : build

function void hqm_transaction_checker::write(iosf_trans_type_st t);

    case(t.trans_type) 
        HCW_SCH   : process_hcw_sch(t.monTxn);
        CSR_WRITE : process_hqm_csr_write(t.monTxn);
    endcase

endfunction : write

function void hqm_transaction_checker::process_hcw_sch(IosfMonTxn t);

    // -- Check for Write Buffer Hold
    if (write_buffer_ctl[`HOLD_SCH_SM] == 1'b1) begin
        ovm_report_error(get_full_name(), $psprintf("HCW schedule(0x%0x) seen on HQM IOSF Primary when hold bit is set", t.address));
    end

    // -- Check for Write Single Beats
    if (write_buffer_ctl[`WRITE_SINGLE_BEATS] == 1'b1) begin
        if (t.length != 4) begin
            ovm_report_error(get_full_name(), $psprintf("More than one HCW schedule(0x%0x) seen on HQM IOSF Primary when write_single_beats is set", t.address));
        end
    end

endfunction : process_hcw_sch

function void hqm_transaction_checker::process_hqm_csr_write(IosfMonTxn t);

    sla_ral_reg    reg_h;

    reg_h = ral.find_reg_by_file_name("write_buffer_ctl", "hqm_system_csr");
    if (reg_h == null) begin
        ovm_report_fatal(get_full_name(), $psprintf("Couldn't find handle for write_buffer_ctl register in hqm_system_csr"));
    end
    if (t.address == reg_h.get_addr_val()) begin
        
        write_buffer_ctl = reg_h.get();
        ovm_report_info(get_full_name(), $psprintf("Write on write_buffer_ctl register observed(val=0x%0x)", write_buffer_ctl), OVM_MEDIUM);

    end

endfunction : process_hqm_csr_write

`undef WRITE_VALID_BEATS
`undef WRITE_SINGLE_BEATS
`undef HOLD_SCH_SM

`endif //HQM_TRANSACTION_CHECK__SV

