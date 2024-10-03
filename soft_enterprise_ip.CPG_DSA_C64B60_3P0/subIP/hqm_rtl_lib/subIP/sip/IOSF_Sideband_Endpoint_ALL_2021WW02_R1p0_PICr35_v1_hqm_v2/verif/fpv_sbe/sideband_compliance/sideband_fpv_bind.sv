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
bind sbendpoint  

`include "sideband_include.sv"
  
      sbc_compliance 
       (
         .mnpput (mnpput),
         .mpcput (mpcput),
         .mnpcup (mnpcup),
         .mpccup (mpccup),
         .meom   (meom),    
         .mpayload (mpayload),
         
         // Target Interface Signals
         .tnpput (tnpput), 
         .tpcput (tpcput), 
         .tnpcup (tnpcup), 
         .tpccup (tpccup), 
         .teom   (teom),     
         .tpayload (tpayload),
         
         // Power Management
         .side_ism_fabric (side_ism_fabric),
         .side_ism_agent (side_ism_agent), 
         .side_clkreq (side_clkreq), 
         .side_clkack (side_clkack),
         .side_clk(side_clk),
         .side_rst_b(side_rst_b),

         //0.9 and mcast related straps
         //Needs review for consistency with this model.
         .Agent_ISM_Reset_IDLE(1'b1),
         .Fabric_ISM_Reset_IDLE(1'b1),
         .eh_support(1'b1),
         .sai_support(1'b0)//,
         //.mcast_num_pids(1),
         //.mcast_num_pids_agent(1)
         );
  
