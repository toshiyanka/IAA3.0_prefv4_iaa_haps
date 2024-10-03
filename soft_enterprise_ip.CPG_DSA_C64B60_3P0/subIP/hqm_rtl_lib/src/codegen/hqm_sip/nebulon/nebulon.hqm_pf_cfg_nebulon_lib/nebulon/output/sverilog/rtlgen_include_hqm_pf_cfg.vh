///
///  INTEL CONFIDENTIAL
///
///  Copyright 2022 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///

//                                                                             
// File:            rtlgen_include_hqm_pf_cfg.vh                               
// Nebulon version: d22ww21.1                                                  
// Description:                                                                
//                                                                             
// No Description Provided                                                     
//                                                                             
// Copyright (C) 2022 Intel Corp. All rights reserved                          
// THIS FILE IS AUTOMATICALLY GENERATED BY INTEL RDL GENERATOR, DO NOT EDIT    
//                                                                             


`ifndef RTLGEN_INC_hqm_pf_cfg
`define RTLGEN_INC_hqm_pf_cfg

//lintra push -68094

// ===================================================
// Sidebande IOSF and Nebulon req, ack conversions 

`ifndef RTLGEN_SAI_SB_TO_CR
`define RTLGEN_SAI_SB_TO_CR(sb_sai) \
   f_sai_sb_to_cr(sb_sai)
`endif // RTLGEN_SAI_SB_TO_CR

// sai_bits has two versions:
// old: treg_ext_header[15:8]
// new: treg_rx_sai 
`ifndef RTLGEN_CR_REQ_FROM_SB
`define RTLGEN_CR_REQ_FROM_SB(cr_req,sb_prf,sai_data) \
   assign cr_req.valid = ``sb_prf``treg_irdy; \
   assign cr_req.opcode = cfg_opcode_t'(``sb_prf``treg_opcode[3:0]); \
   assign cr_req.bar = ``sb_prf``treg_bar; \
   assign cr_req.be = ``sb_prf``treg_be;  \
   assign cr_req.fid = ``sb_prf``treg_fid;  \
   assign cr_req.addr = ``sb_prf``treg_addrlen ? (48'b0 | ``sb_prf``treg_addr) :  {32'b0, ``sb_prf``treg_addr[15:0]}; \
   assign cr_req.data = ``sb_prf``treg_wdata; \
   assign cr_req.sai[7:0] = `RTLGEN_SAI_SB_TO_CR((``sb_prf``treg_ext_header[6:0] != 7'h0) || !``sb_prf``treg_eh || ``sb_prf``treg_eh_discard  ? 8'h0 :  ``sb_prf````sai_data``); 
`endif // RTLGEN_CR_REQ_FROM_SB

`ifndef RTLGEN_CR_REQ_FROM_SB_SIGNALS
`define RTLGEN_CR_REQ_FROM_SB_SIGNALS(cr_req) \
   `RTLGEN_CR_REQ_FROM_SB(cr_req,,treg_rx_sai) 
`endif // RTLGEN_CR_REQ_FROM_SB_SIGNALS

`ifndef RTLGEN_CR_REQ_FROM_SB_REQ
`define RTLGEN_CR_REQ_FROM_SB_REQ(cr_req,sb_req) \
   `RTLGEN_CR_REQ_FROM_SB(cr_req,``sb_req``.,treg_rx_sai) 
`endif // RTLGEN_CR_REQ_FROM_SB_REQ

`ifndef RTLGEN_CR_REQ_FROM_SB_SIGNALS_OLD
`define RTLGEN_CR_REQ_FROM_SB_SIGNALS_OLD(cr_req) \
   `RTLGEN_CR_REQ_FROM_SB(cr_req,,treg_ext_header[15:8]) 
`endif // RTLGEN_CR_REQ_FROM_SB_SIGNALS_OLD

`ifndef RTLGEN_CR_REQ_FROM_SB_REQ_OLD
`define RTLGEN_CR_REQ_FROM_SB_REQ_OLD(cr_req,sb_req) \
   `RTLGEN_CR_REQ_FROM_SB(cr_req,``sb_req``.,treg_ext_header[15:8]) 
`endif // RTLGEN_CR_REQ_FROM_SB_REQ_OLD

// Notice treg_cerr changes:
// OLD: treg_cerr = (cr_ack.read_miss | cr_ack.write_miss | ~cr_ack.sai_successfull);
// NEW: treg_cerr = ~cr_ack.sai_successfull;
// According to IOSF chassis spec, for non-existent register, non-posted register request should report success.
`ifndef RTLGEN_SB_FROM_CR_ACK
`define RTLGEN_SB_FROM_CR_ACK(cr_ack,sb_prf) \
   ``sb_prf``treg_trdy = (cr_ack.read_valid | cr_ack.write_valid); \
   ``sb_prf``treg_cerr = ~cr_ack.sai_successfull; \
   ``sb_prf``treg_rdata = cr_ack.data;
`endif // RTLGEN_SB_FROM_CR_ACK

`ifndef RTLGEN_SB_ACK_FROM_CR_ACK
`define RTLGEN_SB_ACK_FROM_CR_ACK(sb_ack,cr_ack) \
  always_comb begin                           \
   `RTLGEN_SB_FROM_CR_ACK(cr_ack,``sb_ack``.) \
  end                                                               
`endif // RTLGEN_SB_ACK_FROM_CR_ACK

`ifndef RTLGEN_SB_SIGNALS_FROM_CR_ACK
`define RTLGEN_SB_SIGNALS_FROM_CR_ACK(cr_ack) \
  always_comb begin                \
   `RTLGEN_SB_FROM_CR_ACK(cr_ack,) \
  end                                                               
`endif // RTLGEN_SB_SIGNALS_FROM_CR_ACK

`ifndef RTLGEN_CR_ACK_LIST_TO_SB_ACK_LIST
`define RTLGEN_CR_ACK_LIST_TO_SB_ACK_LIST(cr_ack_list,sb_ack_list)     \
  always_comb begin                                                    \
     for (int i=0; i<$size(sb_ack_list); i++) begin                    \
        `RTLGEN_SB_FROM_CR_ACK(``cr_ack_list``[i],``sb_ack_list``[i].) \
     end                                                               \
  end                                                               
`endif // RTLGEN_CR_ACK_LIST_TO_SB_ACK_LIST                         

// ===================================================
// Misc Macros 

`ifndef RTLGEN_LCB
`define RTLGEN_LCB(clock,enable,gate_clk) \
always_comb gate_clk = clock & enable;
`endif // RTLGEN_LCB

`ifndef RTLGEN_ASSERT
   `ifdef INTEL_SVA_OFF
      `define RTLGEN_ASSERT(lbl,valid_condition,fail_msg) 
   `endif // INTEL_SVA_OFF
   `ifndef INTEL_SVA_OFF
      `define RTLGEN_ASSERT(lbl,valid_condition,fail_msg) \
         lbl: assert final (valid_condition)  \
         else $error(fail_msg); 
   `endif // INTEL_SVA_OFF
`endif // RTLGEN_ASSERT

`ifndef IMPORT_RTLGEN_LATEST_PKG
`define IMPORT_RTLGEN_LATEST_PKG import rtlgen_pkg_hqm_pf_cfg::*; 
`endif

//lintra pop

`endif
