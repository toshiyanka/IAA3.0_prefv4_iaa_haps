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
//------------------------------------------------------------------------------



bind sbr fabric_assumptions fabric_assumptions1();

bind sbr  iosf_sb_compliance 
            #(.MAX_AGENT_NP_CREDITS (1024), 
              .MAX_AGENT_PC_CREDITS (1024), 
              .MAX_FABRIC_NP_CREDITS (1024), 
              .MAX_FABRIC_PC_CREDITS (1024), 
              .PAYLOAD_BANDWIDTH (8), 
              .AGENT_IS_DUT(0), 
              .FABRIC_IS_DUT(1), 
              .CHECKER_IS_DUT(0) 
              ) 
      sbc_compliance0 
       ( 
         .mnpput (ep0_sbr_npput), 
         .mpcput (ep0_sbr_pcput), 
         .mnpcup (sbr_ep0_npcup), 
         .mpccup (sbr_ep0_pccup), 
         .meom   (ep0_sbr_eom), 
         .mpayload (ep0_sbr_payload), 
         
         // Target Interface Signals  
         .tnpput (sbr_ep0_npput), 
         .tpcput (sbr_ep0_pcput), 
         .tnpcup (ep0_sbr_npcup), 
         .tpccup (ep0_sbr_pccup), 
         .teom   (sbr_ep0_eom),   
         .tpayload (sbr_ep0_payload), 
         
         // Power Management  
         .side_ism_fabric (sbr_ep0_side_ism_fabric), 
         .side_ism_agent (ep0_sbr_side_ism_agent), 
         .side_clkreq (1'b1), 
         .side_clkack (1'b1), 
         .side_clk(clk), 
         .side_rst_b(rstb), 

         //0.9 and mcast related straps 
         //Needs review for consistency with this model. 
         .Agent_ISM_Reset_IDLE(1'b1), 
         .Fabric_ISM_Reset_IDLE(1'b1), 
         .eh_support(1'b1), 
         .sai_support(1'b0)//,   
         // .mcast_num_pids(1),   
         // .mcast_num_pids_agent(1)  
         );

bind sbr  iosf_sb_compliance 
            #(.MAX_AGENT_NP_CREDITS (1024), 
              .MAX_AGENT_PC_CREDITS (1024), 
              .MAX_FABRIC_NP_CREDITS (1024), 
              .MAX_FABRIC_PC_CREDITS (1024), 
              .PAYLOAD_BANDWIDTH (8), 
              .AGENT_IS_DUT(0), 
              .FABRIC_IS_DUT(1), 
              .CHECKER_IS_DUT(0) 
              ) 
      sbc_compliance1
       ( 
         .mnpput (ep1_sbr_npput), 
         .mpcput (ep1_sbr_pcput), 
         .mnpcup (sbr_ep1_npcup), 
         .mpccup (sbr_ep1_pccup), 
         .meom   (ep1_sbr_eom), 
         .mpayload (ep1_sbr_payload), 
         
         // Target Interface Signals  
         .tnpput (sbr_ep1_npput), 
         .tpcput (sbr_ep1_pcput), 
         .tnpcup (ep1_sbr_npcup), 
         .tpccup (ep1_sbr_pccup), 
         .teom   (sbr_ep1_eom),   
         .tpayload (sbr_ep1_payload), 
         
         // Power Management  
         .side_ism_fabric (sbr_ep1_side_ism_fabric), 
         .side_ism_agent (ep1_sbr_side_ism_agent), 
         .side_clkreq (1'b1), 
         .side_clkack (1'b1), 
         .side_clk(clk), 
         .side_rst_b(rstb), 

         //0.9 and mcast related straps 
         //Needs review for consistency with this model. 
         .Agent_ISM_Reset_IDLE(1'b1), 
         .Fabric_ISM_Reset_IDLE(1'b1), 
         .eh_support(1'b1), 
         .sai_support(1'b0)//,   
         // .mcast_num_pids(1),   
         // .mcast_num_pids_agent(1)  
         );


