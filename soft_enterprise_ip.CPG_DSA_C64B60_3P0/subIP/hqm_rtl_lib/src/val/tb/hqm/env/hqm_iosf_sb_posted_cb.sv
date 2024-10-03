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
// File         : hqm_iosf_sb_posted_cb.sv
// Author       : Neeraj Shete
// Description  : Monitors posted messages generated by HQM on IOSF SB interface,
//                - Flags errors for unexpected posted msgs (other than mentioned in MAS) seen from HQM
//                - Triggers event for IP_READY received
//-----------------------------------------------------------------------------------------------------


class hqm_iosf_sb_posted_cb extends iosfsbm_cm::opcode_cb;
  `ovm_component_utils(hqm_iosf_sb_posted_cb)

  ovm_event_pool  global_pool;
  ovm_event       hqm_ip_ready;
  ovm_event       hqm_ResetPrepAck;

  function new(string name, ovm_component parent);
    super.new(name, parent);
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_ip_ready = global_pool.get("hqm_ip_ready");
    hqm_ResetPrepAck = global_pool.get("hqm_ResetPrepAck");
  endfunction :new
  
  function iosfsbm_cm::simple_xaction execute_posted_simple_cb(string name, iosfsbm_cm::ep_cfg m_ep_cfg, iosfsbm_cm::common_cfg m_common_cfg, bit[1:0] rsp_field, iosfsbm_cm::xaction rx_xaction);

    `ovm_info(get_full_name(),$psprintf("execute_posted_simple_cb: rx_xaction.opcode = %0h", rx_xaction.opcode),OVM_LOW)
    // Locals
    // Handle posted
    if ( rx_xaction.xaction_class == iosfsbm_cm::POSTED) begin
      case (rx_xaction.opcode)

        // -- IP_READY from HQM -- //
        'hd0: begin

                hqm_ip_ready.trigger();
                if ($test$plusargs("HQM_STRAP_NO_MGMT_ACKS")) begin
                    `ovm_error(get_full_name(),$psprintf("HQM strap: strap_no_mgmt_acks=1; expecting IP_READY on pin instead of SB message:IP_READY. Uexpected sideband msg received with opcode (0x%0x) as below, \n%s",rx_xaction.opcode,rx_xaction.sprint_header()))
                end else begin
                   `ovm_info(get_full_name(),"Triggered IP_READY received event (hqm_ip_ready)!!",OVM_LOW)
                end

              end

        // -- DO_SERR from HQM -- //
        'h_88: ;

        // -- ResetPrepAck from HQM -- // 
        'h2b: begin

                hqm_ResetPrepAck.trigger();
                if ($test$plusargs("HQM_STRAP_NO_MGMT_ACKS")) begin
                    `ovm_error(get_full_name(),$psprintf("HQM strap: strap_no_mgmt_acks=1; expecting reset_prep_ack on pin instead of SB message:ResetPrepAck. Uexpected sideband msg received with opcode (0x%0x) as below, \n%s",rx_xaction.opcode,rx_xaction.sprint_header()))
                end else begin
                    `ovm_info(get_full_name(),"Triggered ResetPrepAck received event (hqm_ResetPrepAck)!!",OVM_LOW)
                end

              end


        // -- default including INTA ('h_80,'h_81) related   -- //
        default: begin `ovm_error(get_full_name(),$psprintf("Uexpected sideband msg received with opcode (0x%0x) as below, \n%s",rx_xaction.opcode,rx_xaction.sprint_header())) 
                 end

      endcase
    end

    return null;
    
  endfunction :execute_posted_simple_cb
endclass
