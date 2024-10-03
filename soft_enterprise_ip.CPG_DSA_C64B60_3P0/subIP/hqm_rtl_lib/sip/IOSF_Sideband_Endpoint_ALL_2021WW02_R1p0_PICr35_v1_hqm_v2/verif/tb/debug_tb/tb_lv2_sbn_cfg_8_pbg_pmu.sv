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

import ovm_pkg::*;
import svlib_pkg::*;

module tb_lv2_sbn_cfg_8_pbg_pmu ;

  // misc wires.
wire [7:0] sbr1_cgc0_pms_request_loopback;
wire [3:0] sbr2_cgc1_pms_request_loopback;  


  // Instantiate DUT
ccsb ccsb (
  .su_local_ugt (1'b0),
  .dfxa_ccsb_cgovrd ( 5'b0 ),
  .dfxa_ccsb_cgctrl ( { 1'b1, 1'b0, 6'h0, 8'h10 } ),
  .iosf_idf_side_clk  ( u_clk_rst_intf.clocks[4]  ),
  .iosf_idf_side_rst_b  ( u_clk_rst_intf.resets[4]  ),
  .ccsb_sbra_pccup (  ccsb_sbra_vintf.tpccup  ), 
  .sbra_ccsb_pccup (  ccsb_sbra_vintf.mpccup  ), 
  .ccsb_sbra_npcup (  ccsb_sbra_vintf.tnpcup  ), 
  .sbra_ccsb_npcup (  ccsb_sbra_vintf.mnpcup  ), 
  .ccsb_sbra_pcput (  ccsb_sbra_vintf.mpcput  ), 
  .sbra_ccsb_pcput (  ccsb_sbra_vintf.tpcput  ), 
  .ccsb_sbra_npput (  ccsb_sbra_vintf.mnpput  ), 
  .sbra_ccsb_npput (  ccsb_sbra_vintf.tnpput  ), 
  .ccsb_sbra_eom (  ccsb_sbra_vintf.meom  ), 
  .sbra_ccsb_eom (  ccsb_sbra_vintf.teom  ), 
  .ccsb_sbra_payload (  ccsb_sbra_vintf.mpayload  ), 
  .sbra_ccsb_payload (  ccsb_sbra_vintf.tpayload  ), 
  .sbra_ccsb_side_ism_fabric ( ccsb_sbra_vintf.side_ism_fabric ),
  .ccsb_sbra_side_ism_agent  ( ccsb_sbra_vintf.side_ism_agent  ),
  .ccsb_sbra_side_clkreq     ( ccsb_sbra_vintf.side_clkreq     ),
  .sbra_ccsb_side_clkack     ( ccsb_sbra_vintf.side_clkack ),
  .sosc_25_clk_core ( u_clk_rst_intf.clocks[2] ), 
  .sbi_rst_25_core_b ( u_clk_rst_intf.resets[2] ), 
  .ccsb_sbr1_pccup (  ccsb_sbr1_vintf.tpccup  ), 
  .sbr1_ccsb_pccup (  ccsb_sbr1_vintf.mpccup  ), 
  .ccsb_sbr1_npcup (  ccsb_sbr1_vintf.tnpcup  ), 
  .sbr1_ccsb_npcup (  ccsb_sbr1_vintf.mnpcup  ), 
  .ccsb_sbr1_pcput (  ccsb_sbr1_vintf.mpcput  ), 
  .sbr1_ccsb_pcput (  ccsb_sbr1_vintf.tpcput  ), 
  .ccsb_sbr1_npput (  ccsb_sbr1_vintf.mnpput  ), 
  .sbr1_ccsb_npput (  ccsb_sbr1_vintf.tnpput  ), 
  .ccsb_sbr1_eom (  ccsb_sbr1_vintf.meom  ), 
  .sbr1_ccsb_eom (  ccsb_sbr1_vintf.teom  ), 
  .ccsb_sbr1_payload (  ccsb_sbr1_vintf.mpayload  ), 
  .sbr1_ccsb_payload (  ccsb_sbr1_vintf.tpayload  ), 
  .sbr1_ccsb_side_ism_fabric ( ccsb_sbr1_vintf.side_ism_fabric ),
  .ccsb_sbr1_side_ism_agent  ( ccsb_sbr1_vintf.side_ism_agent  ));


sbr1 sbr1 (
  .su_local_ugt (1'b0),
  .dfxa_sbr1_cgovrd ( 5'b0 ),
  .dfxa_sbr1_cgctrl ( { 1'b1, 1'b0, 6'h0, 8'h10 } ),
  .iosf_idf_side_clk  ( u_clk_rst_intf.clocks[4]  ),
  .iosf_idf_side_rst_b  ( u_clk_rst_intf.resets[4]  ),
  .sbr1_ccsb_pccup (  sbr1_ccsb_vintf.tpccup  ), 
  .ccsb_sbr1_pccup (  sbr1_ccsb_vintf.mpccup  ), 
  .sbr1_ccsb_npcup (  sbr1_ccsb_vintf.tnpcup  ), 
  .ccsb_sbr1_npcup (  sbr1_ccsb_vintf.mnpcup  ), 
  .sbr1_ccsb_pcput (  sbr1_ccsb_vintf.mpcput  ), 
  .ccsb_sbr1_pcput (  sbr1_ccsb_vintf.tpcput  ), 
  .sbr1_ccsb_npput (  sbr1_ccsb_vintf.mnpput  ), 
  .ccsb_sbr1_npput (  sbr1_ccsb_vintf.tnpput  ), 
  .sbr1_ccsb_eom (  sbr1_ccsb_vintf.meom  ), 
  .ccsb_sbr1_eom (  sbr1_ccsb_vintf.teom  ), 
  .sbr1_ccsb_payload (  sbr1_ccsb_vintf.mpayload  ), 
  .ccsb_sbr1_payload (  sbr1_ccsb_vintf.tpayload  ), 
  .sbr1_ccsb_side_ism_fabric ( sbr1_ccsb_vintf.side_ism_fabric ),
  .ccsb_sbr1_side_ism_agent  ( sbr1_ccsb_vintf.side_ism_agent  ),
  .iosf_fust_side_clk ( u_clk_rst_intf.clocks[3] ), 
  .iosf_fust_side_rst_b ( u_clk_rst_intf.resets[3] ), 
  .sbr1_fust_side_ism_fabric ( sbr1_fust_vintf.side_ism_fabric ),
  .fust_sbr1_side_ism_agent  ( sbr1_fust_vintf.side_ism_agent  ),
  .fust_sbr1_side_clkreq     ( sbr1_fust_vintf.side_clkreq ),
  .sbr1_fust_side_clkack     ( sbr1_fust_vintf.side_clkack ),
  .sbr1_fust_pccup (  sbr1_fust_vintf.mpccup  ), 
  .fust_sbr1_pccup (  sbr1_fust_vintf.tpccup  ), 
  .sbr1_fust_npcup (  sbr1_fust_vintf.mnpcup  ), 
  .fust_sbr1_npcup (  sbr1_fust_vintf.tnpcup  ), 
  .sbr1_fust_pcput (  sbr1_fust_vintf.tpcput  ), 
  .fust_sbr1_pcput (  sbr1_fust_vintf.mpcput  ), 
  .sbr1_fust_npput (  sbr1_fust_vintf.tnpput  ), 
  .fust_sbr1_npput (  sbr1_fust_vintf.mnpput  ), 
  .sbr1_fust_eom (  sbr1_fust_vintf.teom  ), 
  .fust_sbr1_eom (  sbr1_fust_vintf.meom  ), 
  .sbr1_fust_payload (  sbr1_fust_vintf.tpayload  ), 
  .fust_sbr1_payload (  sbr1_fust_vintf.mpayload  ), 
  .sbr1_sbr2_pccup (  sbr1_sbr2_vintf.tpccup  ), 
  .sbr2_sbr1_pccup (  sbr1_sbr2_vintf.mpccup  ), 
  .sbr1_sbr2_npcup (  sbr1_sbr2_vintf.tnpcup  ), 
  .sbr2_sbr1_npcup (  sbr1_sbr2_vintf.mnpcup  ), 
  .sbr1_sbr2_pcput (  sbr1_sbr2_vintf.mpcput  ), 
  .sbr2_sbr1_pcput (  sbr1_sbr2_vintf.tpcput  ), 
  .sbr1_sbr2_npput (  sbr1_sbr2_vintf.mnpput  ), 
  .sbr2_sbr1_npput (  sbr1_sbr2_vintf.tnpput  ), 
  .sbr1_sbr2_eom (  sbr1_sbr2_vintf.meom  ), 
  .sbr2_sbr1_eom (  sbr1_sbr2_vintf.teom  ), 
  .sbr1_sbr2_payload (  sbr1_sbr2_vintf.mpayload  ), 
  .sbr2_sbr1_payload (  sbr1_sbr2_vintf.tpayload  ), 
  .sbr2_sbr1_side_ism_fabric ( sbr1_sbr2_vintf.side_ism_fabric ),
  .sbr1_sbr2_side_ism_agent  ( sbr1_sbr2_vintf.side_ism_agent  ),
  .sbr1_sbr2_side_clkreq     ( sbr1_sbr2_vintf.side_clkreq     ),
  .sbr2_sbr1_side_clkack     ( sbr1_sbr2_vintf.side_clkack ),
  .iosf_swf_side_clk ( u_clk_rst_intf.clocks[5] ), 
  .iosf_swf_side_rst_b ( u_clk_rst_intf.resets[5] ), 
  .crp_sbr1_xu_en ( u_power_intf.powergood[2] ), 
  .sbr1_isa_side_ism_fabric ( sbr1_isa_vintf.side_ism_fabric ),
  .isa_sbr1_side_ism_agent  ( sbr1_isa_vintf.side_ism_agent  ),
  .isa_sbr1_side_clkreq     ( sbr1_isa_vintf.side_clkreq ),
  .sbr1_isa_side_clkack     ( sbr1_isa_vintf.side_clkack ),
  .sbr1_isa_pccup (  sbr1_isa_vintf.mpccup  ), 
  .isa_sbr1_pccup (  sbr1_isa_vintf.tpccup  ), 
  .sbr1_isa_npcup (  sbr1_isa_vintf.mnpcup  ), 
  .isa_sbr1_npcup (  sbr1_isa_vintf.tnpcup  ), 
  .sbr1_isa_pcput (  sbr1_isa_vintf.tpcput  ), 
  .isa_sbr1_pcput (  sbr1_isa_vintf.mpcput  ), 
  .sbr1_isa_npput (  sbr1_isa_vintf.tnpput  ), 
  .isa_sbr1_npput (  sbr1_isa_vintf.mnpput  ), 
  .sbr1_isa_eom (  sbr1_isa_vintf.teom  ), 
  .isa_sbr1_eom (  sbr1_isa_vintf.meom  ), 
  .sbr1_isa_payload (  sbr1_isa_vintf.tpayload  ), 
  .isa_sbr1_payload (  sbr1_isa_vintf.mpayload  ), 
  .sbr1_dfxa_side_ism_fabric ( sbr1_dfxa_vintf.side_ism_fabric ),
  .dfxa_sbr1_side_ism_agent  ( sbr1_dfxa_vintf.side_ism_agent  ),
  .dfxa_sbr1_side_clkreq     ( sbr1_dfxa_vintf.side_clkreq ),
  .sbr1_dfxa_side_clkack     ( sbr1_dfxa_vintf.side_clkack ),
  .sbr1_dfxa_pccup (  sbr1_dfxa_vintf.mpccup  ), 
  .dfxa_sbr1_pccup (  sbr1_dfxa_vintf.tpccup  ), 
  .sbr1_dfxa_npcup (  sbr1_dfxa_vintf.mnpcup  ), 
  .dfxa_sbr1_npcup (  sbr1_dfxa_vintf.tnpcup  ), 
  .sbr1_dfxa_pcput (  sbr1_dfxa_vintf.tpcput  ), 
  .dfxa_sbr1_pcput (  sbr1_dfxa_vintf.mpcput  ), 
  .sbr1_dfxa_npput (  sbr1_dfxa_vintf.tnpput  ), 
  .dfxa_sbr1_npput (  sbr1_dfxa_vintf.mnpput  ), 
  .sbr1_dfxa_eom (  sbr1_dfxa_vintf.teom  ), 
  .dfxa_sbr1_eom (  sbr1_dfxa_vintf.meom  ), 
  .sbr1_dfxa_payload (  sbr1_dfxa_vintf.tpayload  ), 
  .dfxa_sbr1_payload (  sbr1_dfxa_vintf.mpayload  ), 
  .sbr1_scu0_side_ism_fabric ( sbr1_scu0_vintf.side_ism_fabric ),
  .scu0_sbr1_side_ism_agent  ( sbr1_scu0_vintf.side_ism_agent  ),
  .scu0_sbr1_side_clkreq     ( sbr1_scu0_vintf.side_clkreq ),
  .sbr1_scu0_side_clkack     ( sbr1_scu0_vintf.side_clkack ),
  .sbr1_scu0_pccup (  sbr1_scu0_vintf.mpccup  ), 
  .scu0_sbr1_pccup (  sbr1_scu0_vintf.tpccup  ), 
  .sbr1_scu0_npcup (  sbr1_scu0_vintf.mnpcup  ), 
  .scu0_sbr1_npcup (  sbr1_scu0_vintf.tnpcup  ), 
  .sbr1_scu0_pcput (  sbr1_scu0_vintf.tpcput  ), 
  .scu0_sbr1_pcput (  sbr1_scu0_vintf.mpcput  ), 
  .sbr1_scu0_npput (  sbr1_scu0_vintf.tnpput  ), 
  .scu0_sbr1_npput (  sbr1_scu0_vintf.mnpput  ), 
  .sbr1_scu0_eom (  sbr1_scu0_vintf.teom  ), 
  .scu0_sbr1_eom (  sbr1_scu0_vintf.meom  ), 
  .sbr1_scu0_payload (  sbr1_scu0_vintf.tpayload  ), 
  .scu0_sbr1_payload (  sbr1_scu0_vintf.mpayload  ), 
  .crp_sbr1_scu1_en ( u_power_intf.powergood[3] ), 
  .sbr1_scu1_side_ism_fabric ( sbr1_scu1_vintf.side_ism_fabric ),
  .scu1_sbr1_side_ism_agent  ( sbr1_scu1_vintf.side_ism_agent  ),
  .scu1_sbr1_side_clkreq     ( sbr1_scu1_vintf.side_clkreq ),
  .sbr1_scu1_side_clkack     ( sbr1_scu1_vintf.side_clkack ),
  .sbr1_scu1_pccup (  sbr1_scu1_vintf.mpccup  ), 
  .scu1_sbr1_pccup (  sbr1_scu1_vintf.tpccup  ), 
  .sbr1_scu1_npcup (  sbr1_scu1_vintf.mnpcup  ), 
  .scu1_sbr1_npcup (  sbr1_scu1_vintf.tnpcup  ), 
  .sbr1_scu1_pcput (  sbr1_scu1_vintf.tpcput  ), 
  .scu1_sbr1_pcput (  sbr1_scu1_vintf.mpcput  ), 
  .sbr1_scu1_npput (  sbr1_scu1_vintf.tnpput  ), 
  .scu1_sbr1_npput (  sbr1_scu1_vintf.mnpput  ), 
  .sbr1_scu1_eom (  sbr1_scu1_vintf.teom  ), 
  .scu1_sbr1_eom (  sbr1_scu1_vintf.meom  ), 
  .sbr1_scu1_payload (  sbr1_scu1_vintf.tpayload  ), 
  .scu1_sbr1_payload (  sbr1_scu1_vintf.mpayload  ), 
  .sbr1_idf_side_ism_fabric ( sbr1_idf_vintf.side_ism_fabric ),
  .idf_sbr1_side_ism_agent  ( sbr1_idf_vintf.side_ism_agent  ),
  .idf_sbr1_side_clkreq     ( sbr1_idf_vintf.side_clkreq ),
  .sbr1_idf_side_clkack     ( sbr1_idf_vintf.side_clkack ),
  .sbr1_idf_pccup (  sbr1_idf_vintf.mpccup  ), 
  .idf_sbr1_pccup (  sbr1_idf_vintf.tpccup  ), 
  .sbr1_idf_npcup (  sbr1_idf_vintf.mnpcup  ), 
  .idf_sbr1_npcup (  sbr1_idf_vintf.tnpcup  ), 
  .sbr1_idf_pcput (  sbr1_idf_vintf.tpcput  ), 
  .idf_sbr1_pcput (  sbr1_idf_vintf.mpcput  ), 
  .sbr1_idf_npput (  sbr1_idf_vintf.tnpput  ), 
  .idf_sbr1_npput (  sbr1_idf_vintf.mnpput  ), 
  .sbr1_idf_eom (  sbr1_idf_vintf.teom  ), 
  .idf_sbr1_eom (  sbr1_idf_vintf.meom  ), 
  .sbr1_idf_payload (  sbr1_idf_vintf.tpayload  ), 
  .idf_sbr1_payload (  sbr1_idf_vintf.mpayload  ), 
  .sbr1_rsp_side_ism_fabric ( sbr1_rsp_vintf.side_ism_fabric ),
  .rsp_sbr1_side_ism_agent  ( sbr1_rsp_vintf.side_ism_agent  ),
  .rsp_sbr1_side_clkreq     ( sbr1_rsp_vintf.side_clkreq ),
  .sbr1_rsp_side_clkack     ( sbr1_rsp_vintf.side_clkack ),
  .sbr1_rsp_pccup (  sbr1_rsp_vintf.mpccup  ), 
  .rsp_sbr1_pccup (  sbr1_rsp_vintf.tpccup  ), 
  .sbr1_rsp_npcup (  sbr1_rsp_vintf.mnpcup  ), 
  .rsp_sbr1_npcup (  sbr1_rsp_vintf.tnpcup  ), 
  .sbr1_rsp_pcput (  sbr1_rsp_vintf.tpcput  ), 
  .rsp_sbr1_pcput (  sbr1_rsp_vintf.mpcput  ), 
  .sbr1_rsp_npput (  sbr1_rsp_vintf.tnpput  ), 
  .rsp_sbr1_npput (  sbr1_rsp_vintf.mnpput  ), 
  .sbr1_rsp_eom (  sbr1_rsp_vintf.teom  ), 
  .rsp_sbr1_eom (  sbr1_rsp_vintf.meom  ), 
  .sbr1_rsp_payload (  sbr1_rsp_vintf.tpayload  ), 
  .rsp_sbr1_payload (  sbr1_rsp_vintf.mpayload  ), 
  .sbr1_cgc0_pms_request ( sbr1_cgc0_pms_request_loopback ),
  .cgc0_sbr1_pms_grant ( sbr1_cgc0_pms_request_loopback ),
  .cgc0_sbr1_pms_gating ( 1'b0 ));


sbr2 sbr2 (
  .su_local_ugt (1'b0),
  .dfxa_sbr2_cgovrd ( 5'b0 ),
  .dfxa_sbr2_cgctrl ( { 1'b1, 1'b0, 6'h0, 8'h10 } ),
  .iosf_swf_side_clk  ( u_clk_rst_intf.clocks[5]  ),
  .iosf_swf_side_rst_b  ( u_clk_rst_intf.resets[5]  ),
  .sbr2_sbr1_pccup (  sbr2_sbr1_vintf.tpccup  ), 
  .sbr1_sbr2_pccup (  sbr2_sbr1_vintf.mpccup  ), 
  .sbr2_sbr1_npcup (  sbr2_sbr1_vintf.tnpcup  ), 
  .sbr1_sbr2_npcup (  sbr2_sbr1_vintf.mnpcup  ), 
  .sbr2_sbr1_pcput (  sbr2_sbr1_vintf.mpcput  ), 
  .sbr1_sbr2_pcput (  sbr2_sbr1_vintf.tpcput  ), 
  .sbr2_sbr1_npput (  sbr2_sbr1_vintf.mnpput  ), 
  .sbr1_sbr2_npput (  sbr2_sbr1_vintf.tnpput  ), 
  .sbr2_sbr1_eom (  sbr2_sbr1_vintf.meom  ), 
  .sbr1_sbr2_eom (  sbr2_sbr1_vintf.teom  ), 
  .sbr2_sbr1_payload (  sbr2_sbr1_vintf.mpayload  ), 
  .sbr1_sbr2_payload (  sbr2_sbr1_vintf.tpayload  ), 
  .sbr2_sbr1_side_ism_fabric ( sbr2_sbr1_vintf.side_ism_fabric ),
  .sbr1_sbr2_side_ism_agent  ( sbr2_sbr1_vintf.side_ism_agent  ),
  .sbr1_sbr2_side_clkreq     ( sbr2_sbr1_vintf.side_clkreq ),
  .sbr2_sbr1_side_clkack     ( sbr2_sbr1_vintf.side_clkack ),
  .eva_present ( u_power_intf.powergood[1] ), 
  .sbr2_xut_side_ism_fabric ( sbr2_xut_vintf.side_ism_fabric ),
  .xut_sbr2_side_ism_agent  ( sbr2_xut_vintf.side_ism_agent  ),
  .xut_sbr2_side_clkreq     ( sbr2_xut_vintf.side_clkreq ),
  .sbr2_xut_side_clkack     ( sbr2_xut_vintf.side_clkack ),
  .sbr2_xut_pccup (  sbr2_xut_vintf.mpccup  ), 
  .xut_sbr2_pccup (  sbr2_xut_vintf.tpccup  ), 
  .sbr2_xut_npcup (  sbr2_xut_vintf.mnpcup  ), 
  .xut_sbr2_npcup (  sbr2_xut_vintf.tnpcup  ), 
  .sbr2_xut_pcput (  sbr2_xut_vintf.tpcput  ), 
  .xut_sbr2_pcput (  sbr2_xut_vintf.mpcput  ), 
  .sbr2_xut_npput (  sbr2_xut_vintf.tnpput  ), 
  .xut_sbr2_npput (  sbr2_xut_vintf.mnpput  ), 
  .sbr2_xut_eom (  sbr2_xut_vintf.teom  ), 
  .xut_sbr2_eom (  sbr2_xut_vintf.meom  ), 
  .sbr2_xut_payload (  sbr2_xut_vintf.tpayload  ), 
  .xut_sbr2_payload (  sbr2_xut_vintf.mpayload  ), 
  .sbr2_swf_side_ism_fabric ( sbr2_swf_vintf.side_ism_fabric ),
  .swf_sbr2_side_ism_agent  ( sbr2_swf_vintf.side_ism_agent  ),
  .swf_sbr2_side_clkreq     ( sbr2_swf_vintf.side_clkreq ),
  .sbr2_swf_side_clkack     ( sbr2_swf_vintf.side_clkack ),
  .sbr2_swf_pccup (  sbr2_swf_vintf.mpccup  ), 
  .swf_sbr2_pccup (  sbr2_swf_vintf.tpccup  ), 
  .sbr2_swf_npcup (  sbr2_swf_vintf.mnpcup  ), 
  .swf_sbr2_npcup (  sbr2_swf_vintf.tnpcup  ), 
  .sbr2_swf_pcput (  sbr2_swf_vintf.tpcput  ), 
  .swf_sbr2_pcput (  sbr2_swf_vintf.mpcput  ), 
  .sbr2_swf_npput (  sbr2_swf_vintf.tnpput  ), 
  .swf_sbr2_npput (  sbr2_swf_vintf.mnpput  ), 
  .sbr2_swf_eom (  sbr2_swf_vintf.teom  ), 
  .swf_sbr2_eom (  sbr2_swf_vintf.meom  ), 
  .sbr2_swf_payload (  sbr2_swf_vintf.tpayload  ), 
  .swf_sbr2_payload (  sbr2_swf_vintf.mpayload  ), 
  .sbr2_cgc1_pms_request ( sbr2_cgc1_pms_request_loopback ),
  .cgc1_sbr2_pms_grant ( pmu_sbr2_intf.pmu_pms_grant),
  .cgc1_sbr2_pms_gating ( pmu_sbr2_intf.pmu_pms_gating ));


sbra sbra (
  .su_local_ugt (1'b0),
  .dfxa_sbra_cgovrd ( 5'b0 ),
  .dfxa_sbra_cgctrl ( { 1'b1, 1'b0, 6'h0, 8'h10 } ),
  .sosc_25_clk_core  ( u_clk_rst_intf.clocks[2]  ),
  .sbi_rst_25_core_b  ( u_clk_rst_intf.resets[2]  ),
  .bb_cclk ( u_clk_rst_intf.clocks[0] ), 
  .bb_rst_b ( u_clk_rst_intf.resets[0] ), 
  .sbra_npsb_side_ism_fabric ( sbra_npsb_vintf.side_ism_fabric ),
  .npsb_sbra_side_ism_agent  ( sbra_npsb_vintf.side_ism_agent  ),
  .npsb_sbra_side_clkreq     ( sbra_npsb_vintf.side_clkreq ),
  .sbra_npsb_side_clkack     ( sbra_npsb_vintf.side_clkack ),
  .sbra_npsb_pccup (  sbra_npsb_vintf.mpccup  ), 
  .npsb_sbra_pccup (  sbra_npsb_vintf.tpccup  ), 
  .sbra_npsb_npcup (  sbra_npsb_vintf.mnpcup  ), 
  .npsb_sbra_npcup (  sbra_npsb_vintf.tnpcup  ), 
  .sbra_npsb_pcput (  sbra_npsb_vintf.tpcput  ), 
  .npsb_sbra_pcput (  sbra_npsb_vintf.mpcput  ), 
  .sbra_npsb_npput (  sbra_npsb_vintf.tnpput  ), 
  .npsb_sbra_npput (  sbra_npsb_vintf.mnpput  ), 
  .sbra_npsb_eom (  sbra_npsb_vintf.teom  ), 
  .npsb_sbra_eom (  sbra_npsb_vintf.meom  ), 
  .sbra_npsb_payload (  sbra_npsb_vintf.tpayload  ), 
  .npsb_sbra_payload (  sbra_npsb_vintf.mpayload  ), 
  .sosc_125_clk_core ( u_clk_rst_intf.clocks[1] ), 
  .sbi_rst_125_core_b ( u_clk_rst_intf.resets[1] ), 
  .sbra_xpsb_side_ism_fabric ( sbra_xpsb_vintf.side_ism_fabric ),
  .xpsb_sbra_side_ism_agent  ( sbra_xpsb_vintf.side_ism_agent  ),
  .xpsb_sbra_side_clkreq     ( sbra_xpsb_vintf.side_clkreq ),
  .sbra_xpsb_side_clkack     ( sbra_xpsb_vintf.side_clkack ),
  .sbra_xpsb_pccup (  sbra_xpsb_vintf.mpccup  ), 
  .xpsb_sbra_pccup (  sbra_xpsb_vintf.tpccup  ), 
  .sbra_xpsb_npcup (  sbra_xpsb_vintf.mnpcup  ), 
  .xpsb_sbra_npcup (  sbra_xpsb_vintf.tnpcup  ), 
  .sbra_xpsb_pcput (  sbra_xpsb_vintf.tpcput  ), 
  .xpsb_sbra_pcput (  sbra_xpsb_vintf.mpcput  ), 
  .sbra_xpsb_npput (  sbra_xpsb_vintf.tnpput  ), 
  .xpsb_sbra_npput (  sbra_xpsb_vintf.mnpput  ), 
  .sbra_xpsb_eom (  sbra_xpsb_vintf.teom  ), 
  .xpsb_sbra_eom (  sbra_xpsb_vintf.meom  ), 
  .sbra_xpsb_payload (  sbra_xpsb_vintf.tpayload  ), 
  .xpsb_sbra_payload (  sbra_xpsb_vintf.mpayload  ), 
  .sbra_ccsb_pccup (  sbra_ccsb_vintf.tpccup  ), 
  .ccsb_sbra_pccup (  sbra_ccsb_vintf.mpccup  ), 
  .sbra_ccsb_npcup (  sbra_ccsb_vintf.tnpcup  ), 
  .ccsb_sbra_npcup (  sbra_ccsb_vintf.mnpcup  ), 
  .sbra_ccsb_pcput (  sbra_ccsb_vintf.mpcput  ), 
  .ccsb_sbra_pcput (  sbra_ccsb_vintf.tpcput  ), 
  .sbra_ccsb_npput (  sbra_ccsb_vintf.mnpput  ), 
  .ccsb_sbra_npput (  sbra_ccsb_vintf.tnpput  ), 
  .sbra_ccsb_eom (  sbra_ccsb_vintf.meom  ), 
  .ccsb_sbra_eom (  sbra_ccsb_vintf.teom  ), 
  .sbra_ccsb_payload (  sbra_ccsb_vintf.mpayload  ), 
  .ccsb_sbra_payload (  sbra_ccsb_vintf.tpayload  ), 
  .sbra_ccsb_side_ism_fabric ( sbra_ccsb_vintf.side_ism_fabric ),
  .ccsb_sbra_side_ism_agent  ( sbra_ccsb_vintf.side_ism_agent  ),
  .ccsb_sbra_side_clkreq     ( sbra_ccsb_vintf.side_clkreq ),
  .sbra_ccsb_side_clkack     ( sbra_ccsb_vintf.side_clkack ),
  .eva_present ( u_power_intf.powergood[1] ), 
  .sbra_io_pxp_side_ism_fabric ( sbra_io_pxp_vintf.side_ism_fabric ),
  .io_pxp_sbra_side_ism_agent  ( sbra_io_pxp_vintf.side_ism_agent  ),
  .io_pxp_sbra_side_clkreq     ( sbra_io_pxp_vintf.side_clkreq ),
  .sbra_io_pxp_side_clkack     ( sbra_io_pxp_vintf.side_clkack ),
  .sbra_io_pxp_pccup (  sbra_io_pxp_vintf.mpccup  ), 
  .io_pxp_sbra_pccup (  sbra_io_pxp_vintf.tpccup  ), 
  .sbra_io_pxp_npcup (  sbra_io_pxp_vintf.mnpcup  ), 
  .io_pxp_sbra_npcup (  sbra_io_pxp_vintf.tnpcup  ), 
  .sbra_io_pxp_pcput (  sbra_io_pxp_vintf.tpcput  ), 
  .io_pxp_sbra_pcput (  sbra_io_pxp_vintf.mpcput  ), 
  .sbra_io_pxp_npput (  sbra_io_pxp_vintf.tnpput  ), 
  .io_pxp_sbra_npput (  sbra_io_pxp_vintf.mnpput  ), 
  .sbra_io_pxp_eom (  sbra_io_pxp_vintf.teom  ), 
  .io_pxp_sbra_eom (  sbra_io_pxp_vintf.meom  ), 
  .sbra_io_pxp_payload (  sbra_io_pxp_vintf.tpayload  ), 
  .io_pxp_sbra_payload (  sbra_io_pxp_vintf.mpayload  ), 
  .sbra_io_dmi_side_ism_fabric ( sbra_io_dmi_vintf.side_ism_fabric ),
  .io_dmi_sbra_side_ism_agent  ( sbra_io_dmi_vintf.side_ism_agent  ),
  .io_dmi_sbra_side_clkreq     ( sbra_io_dmi_vintf.side_clkreq ),
  .sbra_io_dmi_side_clkack     ( sbra_io_dmi_vintf.side_clkack ),
  .sbra_io_dmi_pccup (  sbra_io_dmi_vintf.mpccup  ), 
  .io_dmi_sbra_pccup (  sbra_io_dmi_vintf.tpccup  ), 
  .sbra_io_dmi_npcup (  sbra_io_dmi_vintf.mnpcup  ), 
  .io_dmi_sbra_npcup (  sbra_io_dmi_vintf.tnpcup  ), 
  .sbra_io_dmi_pcput (  sbra_io_dmi_vintf.tpcput  ), 
  .io_dmi_sbra_pcput (  sbra_io_dmi_vintf.mpcput  ), 
  .sbra_io_dmi_npput (  sbra_io_dmi_vintf.tnpput  ), 
  .io_dmi_sbra_npput (  sbra_io_dmi_vintf.mnpput  ), 
  .sbra_io_dmi_eom (  sbra_io_dmi_vintf.teom  ), 
  .io_dmi_sbra_eom (  sbra_io_dmi_vintf.meom  ), 
  .sbra_io_dmi_payload (  sbra_io_dmi_vintf.tpayload  ), 
  .io_dmi_sbra_payload (  sbra_io_dmi_vintf.mpayload  ), 
  .sbra_io_st_side_ism_fabric ( sbra_io_st_vintf.side_ism_fabric ),
  .io_st_sbra_side_ism_agent  ( sbra_io_st_vintf.side_ism_agent  ),
  .io_st_sbra_side_clkreq     ( sbra_io_st_vintf.side_clkreq ),
  .sbra_io_st_side_clkack     ( sbra_io_st_vintf.side_clkack ),
  .sbra_io_st_pccup (  sbra_io_st_vintf.mpccup  ), 
  .io_st_sbra_pccup (  sbra_io_st_vintf.tpccup  ), 
  .sbra_io_st_npcup (  sbra_io_st_vintf.mnpcup  ), 
  .io_st_sbra_npcup (  sbra_io_st_vintf.tnpcup  ), 
  .sbra_io_st_pcput (  sbra_io_st_vintf.tpcput  ), 
  .io_st_sbra_pcput (  sbra_io_st_vintf.mpcput  ), 
  .sbra_io_st_npput (  sbra_io_st_vintf.tnpput  ), 
  .io_st_sbra_npput (  sbra_io_st_vintf.mnpput  ), 
  .sbra_io_st_eom (  sbra_io_st_vintf.teom  ), 
  .io_st_sbra_eom (  sbra_io_st_vintf.meom  ), 
  .sbra_io_st_payload (  sbra_io_st_vintf.tpayload  ), 
  .io_st_sbra_payload (  sbra_io_st_vintf.mpayload  ));




  // Communication matrix
  // ====================

  // Interface instances
   iosf_pmu_intf pmu_sbr2_intf ( .clk( u_clk_rst_intf.clocks[5] ),.reset_b ( u_clk_rst_intf.resets[5]), .helper_meom(sbr2_swf_vintf.meom), .helper_side_ism_fabric(sbr2_swf_vintf.side_ism_fabric), .helper_side_ism_agent(sbr2_swf_vintf.side_ism_agent));
 
   assign  pmu_sbr2_intf.pmu_pms_request = sbr2_cgc1_pms_request_loopback;
   
  iosf_sbc_intf #( .PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) ccsb_sbra_vintf    ( .side_clk( u_clk_rst_intf.clocks[2] ), .side_rst_b ( u_clk_rst_intf.resets[2] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) ccsb_sbr1_vintf    ( .side_clk( u_clk_rst_intf.clocks[4] ), .side_rst_b ( u_clk_rst_intf.resets[4] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(0) ) sbr1_ccsb_vintf    ( .side_clk( u_clk_rst_intf.clocks[4] ), .side_rst_b ( u_clk_rst_intf.resets[4] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr1_fust_vintf    ( .side_clk( u_clk_rst_intf.clocks[3] ), .side_rst_b ( u_clk_rst_intf.resets[3] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr1_sbr2_vintf    ( .side_clk( u_clk_rst_intf.clocks[5] ), .side_rst_b ( u_clk_rst_intf.resets[5] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr1_isa_vintf    ( .side_clk( u_clk_rst_intf.clocks[4] ), .side_rst_b ( u_clk_rst_intf.resets[4] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr1_dfxa_vintf    ( .side_clk( u_clk_rst_intf.clocks[4] ), .side_rst_b ( u_clk_rst_intf.resets[4] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr1_scu0_vintf    ( .side_clk( u_clk_rst_intf.clocks[4] ), .side_rst_b ( u_clk_rst_intf.resets[4] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr1_scu1_vintf    ( .side_clk( u_clk_rst_intf.clocks[4] ), .side_rst_b ( u_clk_rst_intf.resets[4] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr1_idf_vintf    ( .side_clk( u_clk_rst_intf.clocks[4] ), .side_rst_b ( u_clk_rst_intf.resets[4] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr1_rsp_vintf    ( .side_clk( u_clk_rst_intf.clocks[4] ), .side_rst_b ( u_clk_rst_intf.resets[4] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(0) ) sbr2_sbr1_vintf    ( .side_clk( u_clk_rst_intf.clocks[5] ), .side_rst_b ( u_clk_rst_intf.resets[5] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr2_xut_vintf    ( .side_clk( u_clk_rst_intf.clocks[5] ), .side_rst_b ( u_clk_rst_intf.resets[5] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr2_swf_vintf    ( .side_clk( u_clk_rst_intf.clocks[5] ), .side_rst_b ( u_clk_rst_intf.resets[5] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbra_npsb_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbra_xpsb_vintf    ( .side_clk( u_clk_rst_intf.clocks[1] ), .side_rst_b ( u_clk_rst_intf.resets[1] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(0) ) sbra_ccsb_vintf    ( .side_clk( u_clk_rst_intf.clocks[2] ), .side_rst_b ( u_clk_rst_intf.resets[2] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbra_io_pxp_vintf    ( .side_clk( u_clk_rst_intf.clocks[2] ), .side_rst_b ( u_clk_rst_intf.resets[2] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbra_io_dmi_vintf    ( .side_clk( u_clk_rst_intf.clocks[2] ), .side_rst_b ( u_clk_rst_intf.resets[2] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbra_io_st_vintf    ( .side_clk( u_clk_rst_intf.clocks[2] ), .side_rst_b ( u_clk_rst_intf.resets[2] ) );


  connect_sbc_intf u_connect_ccsb_sbra ( .agent_if(ccsb_sbra_vintf), .fabric_if(sbra_ccsb_vintf) );
  connect_sbc_intf u_connect_ccsb_sbr1 ( .agent_if(ccsb_sbr1_vintf), .fabric_if(sbr1_ccsb_vintf) );
  connect_sbc_intf u_connect_sbr1_sbr2 ( .agent_if(sbr1_sbr2_vintf), .fabric_if(sbr2_sbr1_vintf) );


  //Interface Bundle
  svlib_pkg::VintfBundle vintfBundle;
  
  clk_rst_intf u_clk_rst_intf();
  power_intf   u_power_intf();
  comm_intf    u_comm_intf();
 
  event vintf_init_done;
  
  initial
    begin :INTF_WRAPPER_BLOCK

    // Dummy reference to trigger factory registration for tests
    iosfsbm_rtr_tests::rtr_base_test dummy;

    //Interface Wrappers for each i/f type used
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) wrapper_agt_8bit; 
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) wrapper_agt_16bit; 
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(1) ) wrapper_agt_32bit; 

    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(0) ) wrapper_fbrc_8bit; 
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(0) ) wrapper_fbrc_16bit; 
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(0) ) wrapper_fbrc_32bit; 
       
    iosfsbm_rtr::pwr_intf_wrapper wrapper_pwr_intf;
    iosfsbm_cm::comm_intf_wrapper wrapper_comm_intf;
    iosfsbm_rtr::clk_rst_intf_wrapper wrapper_clkrst_intf;
    iosfsbm_debug::vintf_pmu_wrp wrapper_vintf_pmu_wrp;                            


       
    //Create Bundle
    vintfBundle = new("vintfBundle");

    //Now fill up bundle with the i/f wrapper, connecting
    //actual interfaces to the virtual ones in the bundle
  wrapper_agt_8bit = new(ccsb_sbra_vintf);
  vintfBundle.setData ("ccsb_sbra_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(ccsb_sbr1_vintf);
  vintfBundle.setData ("ccsb_sbr1_vintf" , wrapper_agt_8bit);
  wrapper_fbrc_8bit = new(sbr1_ccsb_vintf);
  vintfBundle.setData ("sbr1_ccsb_vintf" , wrapper_fbrc_8bit);
  wrapper_agt_8bit = new(sbr1_fust_vintf);
  vintfBundle.setData ("sbr1_fust_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr1_sbr2_vintf);
  vintfBundle.setData ("sbr1_sbr2_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr1_isa_vintf);
  vintfBundle.setData ("sbr1_isa_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr1_dfxa_vintf);
  vintfBundle.setData ("sbr1_dfxa_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr1_scu0_vintf);
  vintfBundle.setData ("sbr1_scu0_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr1_scu1_vintf);
  vintfBundle.setData ("sbr1_scu1_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr1_idf_vintf);
  vintfBundle.setData ("sbr1_idf_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr1_rsp_vintf);
  vintfBundle.setData ("sbr1_rsp_vintf" , wrapper_agt_8bit);
  wrapper_fbrc_8bit = new(sbr2_sbr1_vintf);
  vintfBundle.setData ("sbr2_sbr1_vintf" , wrapper_fbrc_8bit);
  wrapper_agt_8bit = new(sbr2_xut_vintf);
  vintfBundle.setData ("sbr2_xut_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr2_swf_vintf);
  vintfBundle.setData ("sbr2_swf_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbra_npsb_vintf);
  vintfBundle.setData ("sbra_npsb_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbra_xpsb_vintf);
  vintfBundle.setData ("sbra_xpsb_vintf" , wrapper_agt_8bit);
  wrapper_fbrc_8bit = new(sbra_ccsb_vintf);
  vintfBundle.setData ("sbra_ccsb_vintf" , wrapper_fbrc_8bit);
  wrapper_agt_8bit = new(sbra_io_pxp_vintf);
  vintfBundle.setData ("sbra_io_pxp_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbra_io_dmi_vintf);
  vintfBundle.setData ("sbra_io_dmi_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbra_io_st_vintf);
  vintfBundle.setData ("sbra_io_st_vintf" , wrapper_agt_8bit);

assign ccsb_sbr1_vintf.side_clkreq = '1;
assign sbr1_ccsb_vintf.side_clkack = '1;

 
    wrapper_pwr_intf = new(u_power_intf);
    vintfBundle.setData ("power_intf_i", wrapper_pwr_intf);

    wrapper_comm_intf = new(u_comm_intf);
    vintfBundle.setData ("comm_intf_i", wrapper_comm_intf);

    wrapper_clkrst_intf = new(u_clk_rst_intf);
    vintfBundle.setData ("clk_rst_intf_i", wrapper_clkrst_intf);

    //Pass config info to the environment
    //pass comm_intf name string
    set_config_string("*", "comm_intf_name", "comm_intf_i");      

    //pass Bundle
    set_config_object("*", SB_VINTF_BUNDLE_NAME, vintfBundle, 0); 

    wrapper_vintf_pmu_wrp = new(pmu_sbr2_intf);
    vintfBundle.setData("pmu_sbr2_intf", wrapper_vintf_pmu_wrp);
    set_config_string("*", "iosf_pmu_intf","iosf_pmu_intf_i");
    set_config_object("*", "vintf_pmu_wrp", wrapper_vintf_pmu_wrp,0);
    set_config_int("*", "pmu_active", 1);   
       
    
    ovm_default_printer = ovm_default_line_printer;
  
    // Print header
     `ifdef OVM11
      ovm_top.report_header();
     `endif
    // Execute test
    run_test();

    // Print summary
    `ifdef OVM11
      ovm_top.report_summarize(); 
     `endif

     // Print Test Result
     svlib_pkg::ovm_report_utils::printTestStatus();


    // Finish gracefully
    
 end   :INTF_WRAPPER_BLOCK 

 `ifdef FSDB  
 initial
   begin
      $fsdbDumpvars(0,"tb_lv2_sbn_cfg_8_pbg_pmu");
   end
 `endif

   initial
     begin
        $assertoff(0, tb_lv2_sbn_cfg_8_pbg_pmu.sbr1_sbr2_vintf.sbc_compliance.clock_gating_compliance.ISMPM_057_clkack_Falls.ISMPM_057_clkack_Falls_ASSERT);
        
        $assertoff(0, tb_lv2_sbn_cfg_8_pbg_pmu.sbr2_swf_vintf.sbc_compliance.clock_gating_compliance.ISMPM_057_clkack_Falls.ISMPM_057_clkack_Falls_ASSERT);
        
        $assertoff(0, tb_lv2_sbn_cfg_8_pbg_pmu.sbr2_sbr1_vintf.sbc_compliance.clock_gating_compliance.ISMPM_057_clkack_Falls.ISMPM_057_clkack_Falls_ASSERT);
        
        $assertoff(0, tb_lv2_sbn_cfg_8_pbg_pmu.sbr2_xut_vintf.sbc_compliance.clock_gating_compliance.ISMPM_057_clkack_Falls.ISMPM_057_clkack_Falls_ASSERT);

        $assertoff(0, tb_lv2_sbn_cfg_8_pbg_pmu.sbr1_sbr2_vintf.sbc_compliance.clock_gating_compliance.ISMPM_035_clkreq_Falls.ISMPM_035_clkreq_Falls_ASSERT);
        
        $assertoff(0, tb_lv2_sbn_cfg_8_pbg_pmu.sbr2_sbr1_vintf.sbc_compliance.clock_gating_compliance.ISMPM_035_clkreq_Falls.ISMPM_035_clkreq_Falls_ASSERT);
        
     end // initial begin
   
endmodule :tb_lv2_sbn_cfg_8_pbg_pmu

