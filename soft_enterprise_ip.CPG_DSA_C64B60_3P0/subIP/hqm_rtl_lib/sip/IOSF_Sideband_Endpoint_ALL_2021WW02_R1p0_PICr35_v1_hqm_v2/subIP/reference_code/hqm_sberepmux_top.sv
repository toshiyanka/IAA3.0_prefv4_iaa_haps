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
//  Module sberepmux_top : Wrapper for only the combo logics
//------------------------------------------------------------------------------

// lintra push -60020, -60088, -80018, -80028, -80099, -68001, -68000, -50514

module hqm_sberepmux_top
#(
  parameter INTERNALPLDBIT  = 31,
  parameter SPLIT_COMBO     = 0
 )(
    input logic             sbe_sbi_tmsg_pcput_ip_int,
    input logic             sbe_sbi_tmsg_npput_ip_int,
    input logic             sbe_sbi_mmsg_pcsel_ip_int,
    input logic             sbe_sbi_mmsg_npsel_ip_int,
    input logic             sbe_sbi_mmsg_pctrdy_ip_int,
    input logic             sbe_sbi_mmsg_nptrdy_ip_int,
    input logic             sbe_sbi_mmsg_pcmsgip_ip_int,
    input logic             sbe_sbi_mmsg_npmsgip_ip_int,
    input logic [1:0]       puttotgt_int,
    input logic [1:0]       empty_tgt_int,
    input logic             fence_off_np_int,
    input logic             sbi_sbe_tmsg_pcfree_ip,  
    input logic             sbi_sbe_tmsg_npfree_ip,    
    output logic            sbe_sbi_tmsg_pcput_ip,
    output logic            sbe_sbi_tmsg_npput_ip,
    output logic            sbe_sbi_tmsg_pcput_ip_frmextcmb,
    output logic            sbe_sbi_tmsg_npput_ip_frmextcmb,
    input logic             agent_clk,
    input logic             agent_rst_b,
    input logic [1:0]       full_mst_int,
    input logic             sbi_sbe_mmsg_pcirdy_ip,
    input logic             sbi_sbe_mmsg_npirdy_ip,
    input logic             sbi_sbe_mmsg_pceom_ip,
    input logic             sbi_sbe_mmsg_npeom_ip,
    output logic            sbe_sbi_mmsg_pcsel_ip,
    output logic            sbe_sbi_mmsg_npsel_ip,
    output logic            sbe_sbi_mmsg_pctrdy_ip,
    output logic            sbe_sbi_mmsg_nptrdy_ip,
    output logic            sbe_sbi_mmsg_pcmsgip_ip,
    output logic            sbe_sbi_mmsg_npmsgip_ip    
);

generate 
// if SPLIT_COMBO parameter is not set, combo and mux are generated within repeater
    if (SPLIT_COMBO ==0) begin : no_repmux
        always_comb begin
            sbe_sbi_tmsg_pcput_ip   = sbe_sbi_tmsg_pcput_ip_int;
            sbe_sbi_tmsg_npput_ip   = sbe_sbi_tmsg_npput_ip_int;
            sbe_sbi_mmsg_pcsel_ip   = sbe_sbi_mmsg_pcsel_ip_int;
            sbe_sbi_mmsg_npsel_ip   = sbe_sbi_mmsg_npsel_ip_int;
            sbe_sbi_mmsg_pctrdy_ip  = sbe_sbi_mmsg_pctrdy_ip_int;
            sbe_sbi_mmsg_nptrdy_ip  = sbe_sbi_mmsg_nptrdy_ip_int;
            sbe_sbi_mmsg_pcmsgip_ip = sbe_sbi_mmsg_pcmsgip_ip_int;
            sbe_sbi_mmsg_npmsgip_ip = sbe_sbi_mmsg_npmsgip_ip_int;
            sbe_sbi_tmsg_pcput_ip_frmextcmb = '0;
            sbe_sbi_tmsg_npput_ip_frmextcmb = '0;
        end
    end
// if SPLIT_COMBO parameter is set, then combo and mux need to be genereated outside the repeater     
    else begin : gen_repmux
        hqm_sberep_tgtmux  #(.INTERNALPLDBIT (INTERNALPLDBIT))
        i_sberep_tgtmux (
	        .puttotgt               (puttotgt_int           ),
	        .empty_tgt              (empty_tgt_int          ),
    	    .fence_off_np           (fence_off_np_int       ),
	        .sbi_sbe_tmsg_pcfree_ip (sbi_sbe_tmsg_pcfree_ip ),
	        .sbi_sbe_tmsg_npfree_ip (sbi_sbe_tmsg_npfree_ip ),
    	    .sbe_sbi_tmsg_pcput_ip  (sbe_sbi_tmsg_pcput_ip),//outputs
	        .sbe_sbi_tmsg_npput_ip  (sbe_sbi_tmsg_npput_ip)
        );

        always_comb begin
            sbe_sbi_tmsg_pcput_ip_frmextcmb = sbe_sbi_tmsg_pcput_ip; // input to tgtrep
            sbe_sbi_tmsg_npput_ip_frmextcmb = sbe_sbi_tmsg_npput_ip;
        end

        hqm_sberep_mstmux  #(.INTERNALPLDBIT (INTERNALPLDBIT))
        i_sberep_mstmux (
            .agent_clk              (agent_clk              ),
            .agent_rst_b            (agent_rst_b            ),
            .full_mst               (full_mst_int           ),
            .sbi_sbe_mmsg_pcirdy_ip (sbi_sbe_mmsg_pcirdy_ip ),
            .sbi_sbe_mmsg_npirdy_ip (sbi_sbe_mmsg_npirdy_ip ),
            .sbi_sbe_mmsg_pceom_ip  (sbi_sbe_mmsg_pceom_ip  ),
            .sbi_sbe_mmsg_npeom_ip  (sbi_sbe_mmsg_npeom_ip  ),
            .sbe_sbi_mmsg_pcsel_ip  (sbe_sbi_mmsg_pcsel_ip  ),//outputs to ip
            .sbe_sbi_mmsg_npsel_ip  (sbe_sbi_mmsg_npsel_ip  ),
            .sbe_sbi_mmsg_pctrdy_ip (sbe_sbi_mmsg_pctrdy_ip ),
            .sbe_sbi_mmsg_nptrdy_ip (sbe_sbi_mmsg_nptrdy_ip ),
            .sbe_sbi_mmsg_pcmsgip_ip(sbe_sbi_mmsg_pcmsgip_ip),
            .sbe_sbi_mmsg_npmsgip_ip(sbe_sbi_mmsg_npmsgip_ip)
        );
    end
endgenerate

endmodule
