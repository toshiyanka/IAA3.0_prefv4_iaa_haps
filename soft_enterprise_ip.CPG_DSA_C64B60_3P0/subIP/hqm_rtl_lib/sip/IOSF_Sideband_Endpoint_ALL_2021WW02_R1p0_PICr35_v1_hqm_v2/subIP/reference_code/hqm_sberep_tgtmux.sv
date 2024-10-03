//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2021 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2021WW02_PICr35
//
//  Module sberep_tgtmux : Combo logic in repeater instance for target used in sbendpoint.
//------------------------------------------------------------------------------


// lintra push -60020, -60088, -80018, -80028, -80099, -68001, -68000, -50514, -2218
module hqm_sberep_tgtmux
# (
    parameter INTERNALPLDBIT = 31
  )(
    input logic [1:0]       puttotgt,
    input logic [1:0]       empty_tgt,
    input logic             fence_off_np,
    input logic             sbi_sbe_tmsg_pcfree_ip,  
    input logic             sbi_sbe_tmsg_npfree_ip,    
    output logic            sbe_sbi_tmsg_pcput_ip,
    output logic            sbe_sbi_tmsg_npput_ip
  );

always_comb sbe_sbi_tmsg_pcput_ip = puttotgt[0] & sbi_sbe_tmsg_pcfree_ip & !empty_tgt[0];
always_comb sbe_sbi_tmsg_npput_ip = puttotgt[1] & sbi_sbe_tmsg_npfree_ip & fence_off_np & !empty_tgt[1];

endmodule
