// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_init_seq
// -----------------------------------------------------------------------------


`ifndef HQM_INIT_SEQ__SV
`define HQM_INIT_SEQ__SV

class hqm_init_seq extends hqm_reg_cfg_base_seq;

    `ovm_sequence_utils(hqm_init_seq, sla_sequencer)

    extern function new                   (string name = "hqm_init_seq");
    extern task     body                  ();
    extern task     access_pmcsr_register (bit rd_wr, sla_ral_data_t val);

endclass : hqm_init_seq

function hqm_init_seq::new(string name = "hqm_init_seq");
    super.new(name);
endfunction : new

task hqm_init_seq::body();

    sla_ral_data_t rd_data;
    sla_ral_field  field;


    ovm_report_info(get_full_name(), $psprintf("body -- Start"), OVM_DEBUG);

    // -- Commenting the write to pmcsr register and polling of
    // -- diagnostic_reset_status, as this is done in sla_pcie_init_seq
    // -- // -- Configure pmcsr register
    // -- access_pmcsr_register(1'b0, 'h1); // -- Read and check if value is 'h1
    // -- access_pmcsr_register(1'b1, 'h0); // -- Write 'h
    access_pmcsr_register(1'b0, 'h0); // -- Read and check if value is 'h0

    // -- // -- Check if reset is done
    // -- read_compare_reg("config_master", "cfg_diagnostic_reset_status", rd_data, 1'b1, SLA_TRUE, 'h8000_0bff);

    ovm_report_info(get_full_name(), $psprintf("body -- End"),   OVM_DEBUG);

endtask : body

task hqm_init_seq::access_pmcsr_register(bit rd_wr, sla_ral_data_t val);

   sla_ral_data_t rd_data;

   if (rd_wr) begin

       ovm_report_info(get_full_name(), $psprintf("Writing disable field of config_master.cfg_pm_pmcsr_disable with 0x%0x", val), OVM_HIGH);
       WriteField("config_master", "cfg_pm_pmcsr_disable", "disable", val);
   end else begin
 
       ReadField("config_master", "cfg_pm_pmcsr_disable", "disable", SLA_FALSE, rd_data);
       if (rd_data != val) begin
           ovm_report_error(get_full_name(), $psprintf("ReadField value mismatch(exp=0x%0x, actual=0x%0x)", val, rd_data));
       end else begin
           ovm_report_info(get_full_name(), $psprintf("ReadField value match(exp=0x%0x, actual=0x%0x)", val, rd_data), OVM_HIGH);
       end
   end

endtask : access_pmcsr_register

`endif //HQM_INIT_SEQ__SV
