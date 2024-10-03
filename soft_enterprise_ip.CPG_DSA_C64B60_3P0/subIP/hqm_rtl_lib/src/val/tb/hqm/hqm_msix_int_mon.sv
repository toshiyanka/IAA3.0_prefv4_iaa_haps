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

class hqm_msix_int_mon extends hqm_int_mon;

  `ovm_component_utils(hqm_msix_int_mon)

  function new(string name = "hqm_msix_int_mon", ovm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build();
    super.build();
  endfunction

  virtual function void connect();
    super.connect();
  endfunction

  virtual function void end_of_elaboration();
    super.end_of_elaboration();

    im.add_intr_info("HQM_MSIX_INT", .pri(0), .e(1), .sqcr_name("SLA_SEQUENCER"), .seq_name("hqm_msix_isr_seq"));
  endfunction

  virtual task run();
    `ovm_warning(get_full_name(), "hqm_msix_int_mon class must be extended to support desired interrupt monitoring interface")
  endtask

  virtual task interrupt(bit [15:0] rid, int int_num, bit [31:0] int_data);
    sla_im_isr_object int_object;

    if (rid[7:0] == 8'h00) begin
      int_object                = sla_im_isr_object::type_id::create("int_object",this);
      int_object.intr_type      = int_data;
      int_object.intr_vector    = int_num;
      int_object.intr_name      = "HQM_MSIX_INT";
      int_object.trigger_agent  = inst_suffix;
      int_object.trigger_type   = EDGE_RISING;

      im.send_to_isr("HQM_MSIX_INT",int_object);
      im.interrupt("HQM_MSIX_INT",SLA_FALSE);
    end else begin
      `ovm_error(get_full_name(), $psprintf("Unexpected RID of %0d for HQM MSIX interrupt",rid))
    end
  endtask

endclass
