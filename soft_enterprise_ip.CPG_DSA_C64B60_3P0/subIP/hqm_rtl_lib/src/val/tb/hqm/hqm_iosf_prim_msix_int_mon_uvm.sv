//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2019 Intel Corporation All Rights Reserved.
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
//-- Test
//-----------------------------------------------------------------------------------------------------

import hqm_cfg_pkg::*;
import hqm_tb_cfg_pkg::*;
import IosfPkg::*;

class hqm_iosf_prim_msix_int_mon extends hqm_msix_int_mon;

  `uvm_component_utils(hqm_iosf_prim_msix_int_mon)

  uvm_analysis_export   #(IosfMonTxn)           pvc_mon_export;
  uvm_tlm_analysis_fifo     #(IosfMonTxn)           pvc_mon_fifo;

  function new(string name = "hqm_iosf_prim_msix_int_mon", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    pvc_mon_export              = new("pvc_mon_export",this);
    pvc_mon_fifo                = new("pvc_mon_fifo",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    uvm_object o_tmp;

    super.connect_phase(phase);

    pvc_mon_export.connect(pvc_mon_fifo.analysis_export);
  endfunction

  virtual task run_phase (uvm_phase phase);
    IosfMonTxn  monTxn;

    fork
      forever begin
        hcw_transaction hcw_trans;
        int             vcq_num;
        int             cq_num;
        int             cq_type;
        bit             is_pf;
        int             vf_num;
        bit             is_ims_int;
        int             msix_num;
        bit             trans_decoded;

        pvc_mon_fifo.get(monTxn);

        // -- Check for all the transactions that are generated by HQM
        if ( (monTxn.eventType == Iosf::MDATA) && (monTxn.end_of_transaction == 1) &&
             (({ monTxn.format, monTxn.type_i } == Iosf::MWr32) ||
              ({ monTxn.format, monTxn.type_i } == Iosf::MWr64) ) &&
             (monTxn.length == 1) &&
             (monTxn.first_be == 4'hf)) begin
          uvm_report_info(get_full_name(), $psprintf("Address(0x%0x) -- Checking for MSIX Interrupt writes", monTxn.address), UVM_MEDIUM);
          if (i_hqm_cfg.decode_msix_int_addr(monTxn.address,monTxn.data[0],monTxn.req_id,msix_num)) begin
            interrupt(monTxn.req_id,msix_num,monTxn.data[0]);
          end 
        end 
      end 
    join_none
  endtask

endclass
