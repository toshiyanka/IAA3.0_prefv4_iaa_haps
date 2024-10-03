// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
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
// File   : hqm_alive_seq.sv
// Author : Mike Betker
//
// Description :
//
// Sequence runs basic smoke test scenario
// -----------------------------------------------------------------------------

import hcw_sequences_pkg::*;

class hqm_alive_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_alive_seq, sla_sequencer)

   function new(string name = "hqm_alive_seq");
      super.new(name); 
   endfunction
   
   task body();
      hcw_alive_seq alive_seq;

      `ovm_info("HQM_ALIVE_SEQ","Smoke test/sequence running ...", OVM_LOW);

      `ovm_do_on(alive_seq, p_sequencer.pick_sequencer("hcw_sequencer"))

      `ovm_info("HQM_ALIVE_SEQ","Smoke test/sequence running ...", OVM_LOW);
      //...TBD: test scenario
   endtask
endclass :  hqm_alive_seq

