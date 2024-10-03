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
//  Module sberep_mstmux : Combo logic in repeater instance for master used in sbendpoint.
//------------------------------------------------------------------------------


// lintra push -60020, -60088, -80018, -80028, -80099, -68001, -68000, -50514
module hqm_sberep_mstmux
# (
    parameter INTERNALPLDBIT = 31
  )(
    input logic             agent_clk,
    input logic             agent_rst_b,
    input logic [1:0]       full_mst,
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

logic[1:0] push_mst;

always_comb push_mst[0] = sbi_sbe_mmsg_pcirdy_ip & !full_mst[0];
always_comb push_mst[1] = sbi_sbe_mmsg_npirdy_ip & !full_mst[1];
always_comb sbe_sbi_mmsg_pcsel_ip = push_mst[0];
always_comb sbe_sbi_mmsg_npsel_ip = push_mst[1];
always_comb sbe_sbi_mmsg_pctrdy_ip = push_mst[0];
always_comb sbe_sbi_mmsg_nptrdy_ip = push_mst[1];

logic  pc_last_byte;
logic  np_last_byte;

generate
if (INTERNALPLDBIT == 31)
    begin: gen_be_31

        always_comb  pc_last_byte   = 1'b1;
        always_comb  np_last_byte   = 1'b1;
    end
else begin: gen_be_15_7
        logic pc_valid;
        logic np_valid;
    
        always_comb  pc_valid = (|(sbe_sbi_mmsg_pcsel_ip & sbi_sbe_mmsg_pcirdy_ip)) & sbe_sbi_mmsg_pctrdy_ip;
        always_comb  np_valid = (|(sbe_sbi_mmsg_npsel_ip & sbi_sbe_mmsg_npirdy_ip)) & sbe_sbi_mmsg_nptrdy_ip;
        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
        sbebytecount_pc (
            .side_clk           (agent_clk),
            .side_rst_b         (agent_rst_b),
            .valid              ( pc_valid),
            .first_byte         (),
            .second_byte        (),
            .third_byte         (),
            .last_byte          ( pc_last_byte)
        );

        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
        sbebytecount_np (
            .side_clk           (agent_clk),
            .side_rst_b         (agent_rst_b),
            .valid              ( np_valid),
            .first_byte         (),
            .second_byte        (),
            .third_byte         (),
            .last_byte          ( np_last_byte)
        );
    end
endgenerate

  // The put signals indicate that a 4 byte flit has been transferred to the
// egress port
logic pcput;
logic npput;

  always_comb
    begin
      pcput  =  sbi_sbe_mmsg_pcirdy_ip & sbe_sbi_mmsg_pctrdy_ip;
      npput  =  sbi_sbe_mmsg_npirdy_ip & sbe_sbi_mmsg_nptrdy_ip;
    end

  always_ff @(posedge agent_clk or negedge agent_rst_b)
    if (~agent_rst_b)
      begin
        sbe_sbi_mmsg_pcmsgip_ip <= '0; // 1: Posted message in progress
        sbe_sbi_mmsg_npmsgip_ip <= '0; // 1: Non-posted message in progress
      end
    else
      begin
        
        // In-progess indicators are updated when a flit transfer occurs and is
        // set to 0 if it is the eom, 1 otherwise.
        if (pcput) begin
          if (~sbi_sbe_mmsg_pceom_ip &  pc_last_byte) sbe_sbi_mmsg_pcmsgip_ip <= '1;
          if ( sbi_sbe_mmsg_pceom_ip &  pc_last_byte) sbe_sbi_mmsg_pcmsgip_ip <= '0;
        end
        if (npput) begin
          if (~sbi_sbe_mmsg_npeom_ip &  np_last_byte) sbe_sbi_mmsg_npmsgip_ip <= '1;
          if ( sbi_sbe_mmsg_npeom_ip &  np_last_byte) sbe_sbi_mmsg_npmsgip_ip <= '0;
        end
      end // else: !if(~agent_rst_b)

endmodule
