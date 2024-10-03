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

module tb_lv2_sbn_cfg_9_BVL_pwr;

  // misc wires.


  // Instantiate DUT
sbr_a sbr_a (
  .su_local_ugt (1'b0),
  .cfg_sbr_a_cgovrd ( 5'b0 ),
  .cfg_sbr_a_cgctrl ( { 1'b1, 1'b0, 6'h0, 8'h10 } ),
  .clk_200  ( u_clk_rst_intf.clocks[0]  ),
  .rst_b_200  ( u_clk_rst_intf.resets[0]  ),
  .sbr_a_sbr_e_pccup (  sbr_a_sbr_e_vintf.tpccup  ), 
  .sbr_e_sbr_a_pccup (  (u_power_intf.powergood[5]) ? sbr_a_sbr_e_vintf.mpccup : '0  ), 
  .sbr_a_sbr_e_npcup (  sbr_a_sbr_e_vintf.tnpcup  ), 
  .sbr_e_sbr_a_npcup (  (u_power_intf.powergood[5]) ? sbr_a_sbr_e_vintf.mnpcup : '0   ), 
  .sbr_a_sbr_e_pcput (  sbr_a_sbr_e_vintf.mpcput  ), 
  .sbr_e_sbr_a_pcput (  (u_power_intf.powergood[5]) ? sbr_a_sbr_e_vintf.tpcput: '0 ), 
  .sbr_a_sbr_e_npput (  sbr_a_sbr_e_vintf.mnpput  ), 
  .sbr_e_sbr_a_npput (  (u_power_intf.powergood[5]) ? sbr_a_sbr_e_vintf.tnpput: '0   ), 
  .sbr_a_sbr_e_eom (  sbr_a_sbr_e_vintf.meom  ), 
  .sbr_e_sbr_a_eom (  (u_power_intf.powergood[5]) ? sbr_a_sbr_e_vintf.teom : '0 ), 
  .sbr_a_sbr_e_payload (  sbr_a_sbr_e_vintf.mpayload  ), 
  .sbr_e_sbr_a_payload (  (u_power_intf.powergood[5]) ? sbr_a_sbr_e_vintf.tpayload : '0  ), 
  .sbr_e_sbr_a_side_ism_fabric ( (u_power_intf.powergood[5]) ? sbr_a_sbr_e_vintf.side_ism_fabric: '0   ),
  .sbr_a_sbr_e_side_ism_agent  ( sbr_a_sbr_e_vintf.side_ism_agent  ),
  .well5_pok ( u_power_intf.powergood[5] ), 
  .sbr_a_sbr_b_pccup (  sbr_a_sbr_b_vintf.tpccup  ), 
  .sbr_b_sbr_a_pccup (  (u_power_intf.powergood[4]  )? sbr_a_sbr_b_vintf.mpccup : '0 ), 
  .sbr_a_sbr_b_npcup (  sbr_a_sbr_b_vintf.tnpcup  ), 
  .sbr_b_sbr_a_npcup (  (u_power_intf.powergood[4]  )? sbr_a_sbr_b_vintf.mnpcup : '0 ), 
  .sbr_a_sbr_b_pcput (  sbr_a_sbr_b_vintf.mpcput  ), 
  .sbr_b_sbr_a_pcput (  (u_power_intf.powergood[4]  )? sbr_a_sbr_b_vintf.tpcput : '0 ) , 
  .sbr_a_sbr_b_npput (  sbr_a_sbr_b_vintf.mnpput  ), 
  .sbr_b_sbr_a_npput (  (u_power_intf.powergood[4]  )? sbr_a_sbr_b_vintf.tnpput : '0 ) , 
  .sbr_a_sbr_b_eom (  sbr_a_sbr_b_vintf.meom  ), 
  .sbr_b_sbr_a_eom (  (u_power_intf.powergood[4]  )? sbr_a_sbr_b_vintf.teom : '0 ) , 
  .sbr_a_sbr_b_payload (  sbr_a_sbr_b_vintf.mpayload  ), 
  .sbr_b_sbr_a_payload (  (u_power_intf.powergood[4]  )? sbr_a_sbr_b_vintf.tpayload : '0  ), 
  .sbr_b_sbr_a_side_ism_fabric ( (u_power_intf.powergood[4]  )? sbr_a_sbr_b_vintf.side_ism_fabric : '0 ),
  .sbr_a_sbr_b_side_ism_agent  ( sbr_a_sbr_b_vintf.side_ism_agent  ),
  .well4_pok ( u_power_intf.powergood[4] ), 
  .sbr_a_sbr_c_pccup (  sbr_a_sbr_c_vintf.tpccup  ), 
  .sbr_c_sbr_a_pccup (  (u_power_intf.powergood[2]) ? sbr_a_sbr_c_vintf.mpccup  : '0 )  , 
  .sbr_a_sbr_c_npcup (  sbr_a_sbr_c_vintf.tnpcup  ), 
  .sbr_c_sbr_a_npcup (  (u_power_intf.powergood[2]) ? sbr_a_sbr_c_vintf.mnpcup: '0 ), 
  .sbr_a_sbr_c_pcput (  sbr_a_sbr_c_vintf.mpcput  ), 
  .sbr_c_sbr_a_pcput (  (u_power_intf.powergood[2]) ? sbr_a_sbr_c_vintf.tpcput : '0 ), 
  .sbr_a_sbr_c_npput (  sbr_a_sbr_c_vintf.mnpput  ), 
  .sbr_c_sbr_a_npput (  (u_power_intf.powergood[2]) ? sbr_a_sbr_c_vintf.tnpput : '0 ), 
  .sbr_a_sbr_c_eom (  sbr_a_sbr_c_vintf.meom  ), 
  .sbr_c_sbr_a_eom (  (u_power_intf.powergood[2]) ? sbr_a_sbr_c_vintf.teom  : '0), 
  .sbr_a_sbr_c_payload (  sbr_a_sbr_c_vintf.mpayload  ), 
  .sbr_c_sbr_a_payload (  (u_power_intf.powergood[2]) ? sbr_a_sbr_c_vintf.tpayload : '0 ), 
  .sbr_c_sbr_a_side_ism_fabric ( (u_power_intf.powergood[2]) ? sbr_a_sbr_c_vintf.side_ism_fabric : '0 ),
  .sbr_a_sbr_c_side_ism_agent  ( sbr_a_sbr_c_vintf.side_ism_agent  ),
  .well2_pok ( u_power_intf.powergood[2] ), 
  .sbr_a_dpll_side_ism_fabric ( sbr_a_dpll_vintf.side_ism_fabric ),
  .dpll_sbr_a_side_ism_agent  ( sbr_a_dpll_vintf.side_ism_agent  ),
  .dpll_sbr_a_side_clkreq     ( sbr_a_dpll_vintf.side_clkreq ),
  .sbr_a_dpll_side_clkack     ( sbr_a_dpll_vintf.side_clkack ),
  .sbr_a_dpll_pccup (  sbr_a_dpll_vintf.mpccup  ), 
  .dpll_sbr_a_pccup (  sbr_a_dpll_vintf.tpccup  ), 
  .sbr_a_dpll_npcup (  sbr_a_dpll_vintf.mnpcup  ), 
  .dpll_sbr_a_npcup (  sbr_a_dpll_vintf.tnpcup  ), 
  .sbr_a_dpll_pcput (  sbr_a_dpll_vintf.tpcput  ), 
  .dpll_sbr_a_pcput (  sbr_a_dpll_vintf.mpcput  ), 
  .sbr_a_dpll_npput (  sbr_a_dpll_vintf.tnpput  ), 
  .dpll_sbr_a_npput (  sbr_a_dpll_vintf.mnpput  ), 
  .sbr_a_dpll_eom (  sbr_a_dpll_vintf.teom  ), 
  .dpll_sbr_a_eom (  sbr_a_dpll_vintf.meom  ), 
  .sbr_a_dpll_payload (  sbr_a_dpll_vintf.tpayload  ), 
  .dpll_sbr_a_payload (  sbr_a_dpll_vintf.mpayload  ), 
  .sbr_a_apll_side_ism_fabric ( sbr_a_apll_vintf.side_ism_fabric ),
  .apll_sbr_a_side_ism_agent  ( sbr_a_apll_vintf.side_ism_agent  ),
  .apll_sbr_a_side_clkreq     ( sbr_a_apll_vintf.side_clkreq ),
  .sbr_a_apll_side_clkack     ( sbr_a_apll_vintf.side_clkack ),
  .sbr_a_apll_pccup (  sbr_a_apll_vintf.mpccup  ), 
  .apll_sbr_a_pccup (  sbr_a_apll_vintf.tpccup  ), 
  .sbr_a_apll_npcup (  sbr_a_apll_vintf.mnpcup  ), 
  .apll_sbr_a_npcup (  sbr_a_apll_vintf.tnpcup  ), 
  .sbr_a_apll_pcput (  sbr_a_apll_vintf.tpcput  ), 
  .apll_sbr_a_pcput (  sbr_a_apll_vintf.mpcput  ), 
  .sbr_a_apll_npput (  sbr_a_apll_vintf.tnpput  ), 
  .apll_sbr_a_npput (  sbr_a_apll_vintf.mnpput  ), 
  .sbr_a_apll_eom (  sbr_a_apll_vintf.teom  ), 
  .apll_sbr_a_eom (  sbr_a_apll_vintf.meom  ), 
  .sbr_a_apll_payload (  sbr_a_apll_vintf.tpayload  ), 
  .apll_sbr_a_payload (  sbr_a_apll_vintf.mpayload  ), 
  .sbr_a_hpll_side_ism_fabric ( sbr_a_hpll_vintf.side_ism_fabric ),
  .hpll_sbr_a_side_ism_agent  ( sbr_a_hpll_vintf.side_ism_agent  ),
  .hpll_sbr_a_side_clkreq     ( sbr_a_hpll_vintf.side_clkreq ),
  .sbr_a_hpll_side_clkack     ( sbr_a_hpll_vintf.side_clkack ),
  .sbr_a_hpll_pccup (  sbr_a_hpll_vintf.mpccup  ), 
  .hpll_sbr_a_pccup (  sbr_a_hpll_vintf.tpccup  ), 
  .sbr_a_hpll_npcup (  sbr_a_hpll_vintf.mnpcup  ), 
  .hpll_sbr_a_npcup (  sbr_a_hpll_vintf.tnpcup  ), 
  .sbr_a_hpll_pcput (  sbr_a_hpll_vintf.tpcput  ), 
  .hpll_sbr_a_pcput (  sbr_a_hpll_vintf.mpcput  ), 
  .sbr_a_hpll_npput (  sbr_a_hpll_vintf.tnpput  ), 
  .hpll_sbr_a_npput (  sbr_a_hpll_vintf.mnpput  ), 
  .sbr_a_hpll_eom (  sbr_a_hpll_vintf.teom  ), 
  .hpll_sbr_a_eom (  sbr_a_hpll_vintf.meom  ), 
  .sbr_a_hpll_payload (  sbr_a_hpll_vintf.tpayload  ), 
  .hpll_sbr_a_payload (  sbr_a_hpll_vintf.mpayload  ), 
  .sbr_a_fpll_side_ism_fabric ( sbr_a_fpll_vintf.side_ism_fabric ),
  .fpll_sbr_a_side_ism_agent  ( sbr_a_fpll_vintf.side_ism_agent  ),
  .fpll_sbr_a_side_clkreq     ( sbr_a_fpll_vintf.side_clkreq ),
  .sbr_a_fpll_side_clkack     ( sbr_a_fpll_vintf.side_clkack ),
  .sbr_a_fpll_pccup (  sbr_a_fpll_vintf.mpccup  ), 
  .fpll_sbr_a_pccup (  sbr_a_fpll_vintf.tpccup  ), 
  .sbr_a_fpll_npcup (  sbr_a_fpll_vintf.mnpcup  ), 
  .fpll_sbr_a_npcup (  sbr_a_fpll_vintf.tnpcup  ), 
  .sbr_a_fpll_pcput (  sbr_a_fpll_vintf.tpcput  ), 
  .fpll_sbr_a_pcput (  sbr_a_fpll_vintf.mpcput  ), 
  .sbr_a_fpll_npput (  sbr_a_fpll_vintf.tnpput  ), 
  .fpll_sbr_a_npput (  sbr_a_fpll_vintf.mnpput  ), 
  .sbr_a_fpll_eom (  sbr_a_fpll_vintf.teom  ), 
  .fpll_sbr_a_eom (  sbr_a_fpll_vintf.meom  ), 
  .sbr_a_fpll_payload (  sbr_a_fpll_vintf.tpayload  ), 
  .fpll_sbr_a_payload (  sbr_a_fpll_vintf.mpayload  ), 
  .well1_pok ( u_power_intf.powergood[1] ), 
  .sbr_a_punit_side_ism_fabric ( sbr_a_punit_vintf.side_ism_fabric ),
  .punit_sbr_a_side_ism_agent  ( sbr_a_punit_vintf.side_ism_agent  ),
  .punit_sbr_a_side_clkreq     ( sbr_a_punit_vintf.side_clkreq ),
  .sbr_a_punit_side_clkack     ( sbr_a_punit_vintf.side_clkack ),
  .sbr_a_punit_pccup (  sbr_a_punit_vintf.mpccup  ), 
  .punit_sbr_a_pccup (  sbr_a_punit_vintf.tpccup  ), 
  .sbr_a_punit_npcup (  sbr_a_punit_vintf.mnpcup  ), 
  .punit_sbr_a_npcup (  sbr_a_punit_vintf.tnpcup  ), 
  .sbr_a_punit_pcput (  sbr_a_punit_vintf.tpcput  ), 
  .punit_sbr_a_pcput (  sbr_a_punit_vintf.mpcput  ), 
  .sbr_a_punit_npput (  sbr_a_punit_vintf.tnpput  ), 
  .punit_sbr_a_npput (  sbr_a_punit_vintf.mnpput  ), 
  .sbr_a_punit_eom (  sbr_a_punit_vintf.teom  ), 
  .punit_sbr_a_eom (  sbr_a_punit_vintf.meom  ), 
  .sbr_a_punit_payload (  sbr_a_punit_vintf.tpayload  ), 
  .punit_sbr_a_payload (  sbr_a_punit_vintf.mpayload  ), 
  .sbr_a_spare_a_side_ism_fabric ( sbr_a_spare_a_vintf.side_ism_fabric ),
  .spare_a_sbr_a_side_ism_agent  ( sbr_a_spare_a_vintf.side_ism_agent  ),
  .spare_a_sbr_a_side_clkreq     ( sbr_a_spare_a_vintf.side_clkreq ),
  .sbr_a_spare_a_side_clkack     ( sbr_a_spare_a_vintf.side_clkack ),
  .sbr_a_spare_a_pccup (  sbr_a_spare_a_vintf.mpccup  ), 
  .spare_a_sbr_a_pccup (  sbr_a_spare_a_vintf.tpccup  ), 
  .sbr_a_spare_a_npcup (  sbr_a_spare_a_vintf.mnpcup  ), 
  .spare_a_sbr_a_npcup (  sbr_a_spare_a_vintf.tnpcup  ), 
  .sbr_a_spare_a_pcput (  sbr_a_spare_a_vintf.tpcput  ), 
  .spare_a_sbr_a_pcput (  sbr_a_spare_a_vintf.mpcput  ), 
  .sbr_a_spare_a_npput (  sbr_a_spare_a_vintf.tnpput  ), 
  .spare_a_sbr_a_npput (  sbr_a_spare_a_vintf.mnpput  ), 
  .sbr_a_spare_a_eom (  sbr_a_spare_a_vintf.teom  ), 
  .spare_a_sbr_a_eom (  sbr_a_spare_a_vintf.meom  ), 
  .sbr_a_spare_a_payload (  sbr_a_spare_a_vintf.tpayload  ), 
  .spare_a_sbr_a_payload (  sbr_a_spare_a_vintf.mpayload  ));


sbr_b sbr_b (
  .su_local_ugt (1'b0),
  .cfg_sbr_b_cgovrd ( 5'b0 ),
  .cfg_sbr_b_cgctrl ( { 1'b1, 1'b0, 6'h0, 8'h10 } ),
  .clk_200  ( u_clk_rst_intf.clocks[0]  ),
  .rst_b_200  ( u_clk_rst_intf.resets[0]  ),
  .sbr_b_sbr_a_pccup (  sbr_b_sbr_a_vintf.tpccup  ), 
  .sbr_a_sbr_b_pccup (  (u_power_intf.powergood[0]) ? sbr_b_sbr_a_vintf.mpccup : '0  ), 
  .sbr_b_sbr_a_npcup (  sbr_b_sbr_a_vintf.tnpcup  ), 
  .sbr_a_sbr_b_npcup (  (u_power_intf.powergood[0]) ? sbr_b_sbr_a_vintf.mnpcup : '0  ), 
  .sbr_b_sbr_a_pcput (  sbr_b_sbr_a_vintf.mpcput  ), 
  .sbr_a_sbr_b_pcput (  (u_power_intf.powergood[0]) ? sbr_b_sbr_a_vintf.tpcput : '0  ), 
  .sbr_b_sbr_a_npput (  sbr_b_sbr_a_vintf.mnpput  ), 
  .sbr_a_sbr_b_npput (  (u_power_intf.powergood[0]) ? sbr_b_sbr_a_vintf.tnpput  : '0 ), 
  .sbr_b_sbr_a_eom (  sbr_b_sbr_a_vintf.meom  ), 
  .sbr_a_sbr_b_eom (  (u_power_intf.powergood[0]) ? sbr_b_sbr_a_vintf.teom  : '0 ), 
  .sbr_b_sbr_a_payload (  sbr_b_sbr_a_vintf.mpayload  ), 
  .sbr_a_sbr_b_payload (  (u_power_intf.powergood[0]) ? sbr_b_sbr_a_vintf.tpayload : '0  ), 
  .sbr_b_sbr_a_side_ism_fabric ( sbr_b_sbr_a_vintf.side_ism_fabric ),
  .sbr_a_sbr_b_side_ism_agent  ( (u_power_intf.powergood[0]) ? sbr_b_sbr_a_vintf.side_ism_agent : '0  ),
  .sbr_b_pcie_afe_side_ism_fabric ( sbr_b_pcie_afe_vintf.side_ism_fabric ),
  .pcie_afe_sbr_b_side_ism_agent  ( sbr_b_pcie_afe_vintf.side_ism_agent  ),
  .pcie_afe_sbr_b_side_clkreq     ( sbr_b_pcie_afe_vintf.side_clkreq ),
  .sbr_b_pcie_afe_side_clkack     ( sbr_b_pcie_afe_vintf.side_clkack ),
  .sbr_b_pcie_afe_pccup (  sbr_b_pcie_afe_vintf.mpccup  ), 
  .pcie_afe_sbr_b_pccup (  sbr_b_pcie_afe_vintf.tpccup  ), 
  .sbr_b_pcie_afe_npcup (  sbr_b_pcie_afe_vintf.mnpcup  ), 
  .pcie_afe_sbr_b_npcup (  sbr_b_pcie_afe_vintf.tnpcup  ), 
  .sbr_b_pcie_afe_pcput (  sbr_b_pcie_afe_vintf.tpcput  ), 
  .pcie_afe_sbr_b_pcput (  sbr_b_pcie_afe_vintf.mpcput  ), 
  .sbr_b_pcie_afe_npput (  sbr_b_pcie_afe_vintf.tnpput  ), 
  .pcie_afe_sbr_b_npput (  sbr_b_pcie_afe_vintf.mnpput  ), 
  .sbr_b_pcie_afe_eom (  sbr_b_pcie_afe_vintf.teom  ), 
  .pcie_afe_sbr_b_eom (  sbr_b_pcie_afe_vintf.meom  ), 
  .sbr_b_pcie_afe_payload (  sbr_b_pcie_afe_vintf.tpayload  ), 
  .pcie_afe_sbr_b_payload (  sbr_b_pcie_afe_vintf.mpayload  ), 
  .sbr_b_sata_afe_side_ism_fabric ( sbr_b_sata_afe_vintf.side_ism_fabric ),
  .sata_afe_sbr_b_side_ism_agent  ( sbr_b_sata_afe_vintf.side_ism_agent  ),
  .sata_afe_sbr_b_side_clkreq     ( sbr_b_sata_afe_vintf.side_clkreq ),
  .sbr_b_sata_afe_side_clkack     ( sbr_b_sata_afe_vintf.side_clkack ),
  .sbr_b_sata_afe_pccup (  sbr_b_sata_afe_vintf.mpccup  ), 
  .sata_afe_sbr_b_pccup (  sbr_b_sata_afe_vintf.tpccup  ), 
  .sbr_b_sata_afe_npcup (  sbr_b_sata_afe_vintf.mnpcup  ), 
  .sata_afe_sbr_b_npcup (  sbr_b_sata_afe_vintf.tnpcup  ), 
  .sbr_b_sata_afe_pcput (  sbr_b_sata_afe_vintf.tpcput  ), 
  .sata_afe_sbr_b_pcput (  sbr_b_sata_afe_vintf.mpcput  ), 
  .sbr_b_sata_afe_npput (  sbr_b_sata_afe_vintf.tnpput  ), 
  .sata_afe_sbr_b_npput (  sbr_b_sata_afe_vintf.mnpput  ), 
  .sbr_b_sata_afe_eom (  sbr_b_sata_afe_vintf.teom  ), 
  .sata_afe_sbr_b_eom (  sbr_b_sata_afe_vintf.meom  ), 
  .sbr_b_sata_afe_payload (  sbr_b_sata_afe_vintf.tpayload  ), 
  .sata_afe_sbr_b_payload (  sbr_b_sata_afe_vintf.mpayload  ), 
  .sbr_b_usb_afe_side_ism_fabric ( sbr_b_usb_afe_vintf.side_ism_fabric ),
  .usb_afe_sbr_b_side_ism_agent  ( sbr_b_usb_afe_vintf.side_ism_agent  ),
  .usb_afe_sbr_b_side_clkreq     ( sbr_b_usb_afe_vintf.side_clkreq ),
  .sbr_b_usb_afe_side_clkack     ( sbr_b_usb_afe_vintf.side_clkack ),
  .sbr_b_usb_afe_pccup (  sbr_b_usb_afe_vintf.mpccup  ), 
  .usb_afe_sbr_b_pccup (  sbr_b_usb_afe_vintf.tpccup  ), 
  .sbr_b_usb_afe_npcup (  sbr_b_usb_afe_vintf.mnpcup  ), 
  .usb_afe_sbr_b_npcup (  sbr_b_usb_afe_vintf.tnpcup  ), 
  .sbr_b_usb_afe_pcput (  sbr_b_usb_afe_vintf.tpcput  ), 
  .usb_afe_sbr_b_pcput (  sbr_b_usb_afe_vintf.mpcput  ), 
  .sbr_b_usb_afe_npput (  sbr_b_usb_afe_vintf.tnpput  ), 
  .usb_afe_sbr_b_npput (  sbr_b_usb_afe_vintf.mnpput  ), 
  .sbr_b_usb_afe_eom (  sbr_b_usb_afe_vintf.teom  ), 
  .usb_afe_sbr_b_eom (  sbr_b_usb_afe_vintf.meom  ), 
  .sbr_b_usb_afe_payload (  sbr_b_usb_afe_vintf.tpayload  ), 
  .usb_afe_sbr_b_payload (  sbr_b_usb_afe_vintf.mpayload  ), 
  .sbr_b_sata_ctrl_side_ism_fabric ( sbr_b_sata_ctrl_vintf.side_ism_fabric ),
  .sata_ctrl_sbr_b_side_ism_agent  ( sbr_b_sata_ctrl_vintf.side_ism_agent  ),
  .sata_ctrl_sbr_b_side_clkreq     ( sbr_b_sata_ctrl_vintf.side_clkreq ),
  .sbr_b_sata_ctrl_side_clkack     ( sbr_b_sata_ctrl_vintf.side_clkack ),
  .sbr_b_sata_ctrl_pccup (  sbr_b_sata_ctrl_vintf.mpccup  ), 
  .sata_ctrl_sbr_b_pccup (  sbr_b_sata_ctrl_vintf.tpccup  ), 
  .sbr_b_sata_ctrl_npcup (  sbr_b_sata_ctrl_vintf.mnpcup  ), 
  .sata_ctrl_sbr_b_npcup (  sbr_b_sata_ctrl_vintf.tnpcup  ), 
  .sbr_b_sata_ctrl_pcput (  sbr_b_sata_ctrl_vintf.tpcput  ), 
  .sata_ctrl_sbr_b_pcput (  sbr_b_sata_ctrl_vintf.mpcput  ), 
  .sbr_b_sata_ctrl_npput (  sbr_b_sata_ctrl_vintf.tnpput  ), 
  .sata_ctrl_sbr_b_npput (  sbr_b_sata_ctrl_vintf.mnpput  ), 
  .sbr_b_sata_ctrl_eom (  sbr_b_sata_ctrl_vintf.teom  ), 
  .sata_ctrl_sbr_b_eom (  sbr_b_sata_ctrl_vintf.meom  ), 
  .sbr_b_sata_ctrl_payload (  sbr_b_sata_ctrl_vintf.tpayload  ), 
  .sata_ctrl_sbr_b_payload (  sbr_b_sata_ctrl_vintf.mpayload  ), 
  .sbr_b_pcie_ctrl_side_ism_fabric ( sbr_b_pcie_ctrl_vintf.side_ism_fabric ),
  .pcie_ctrl_sbr_b_side_ism_agent  ( sbr_b_pcie_ctrl_vintf.side_ism_agent  ),
  .pcie_ctrl_sbr_b_side_clkreq     ( sbr_b_pcie_ctrl_vintf.side_clkreq ),
  .sbr_b_pcie_ctrl_side_clkack     ( sbr_b_pcie_ctrl_vintf.side_clkack ),
  .sbr_b_pcie_ctrl_pccup (  sbr_b_pcie_ctrl_vintf.mpccup  ), 
  .pcie_ctrl_sbr_b_pccup (  sbr_b_pcie_ctrl_vintf.tpccup  ), 
  .sbr_b_pcie_ctrl_npcup (  sbr_b_pcie_ctrl_vintf.mnpcup  ), 
  .pcie_ctrl_sbr_b_npcup (  sbr_b_pcie_ctrl_vintf.tnpcup  ), 
  .sbr_b_pcie_ctrl_pcput (  sbr_b_pcie_ctrl_vintf.tpcput  ), 
  .pcie_ctrl_sbr_b_pcput (  sbr_b_pcie_ctrl_vintf.mpcput  ), 
  .sbr_b_pcie_ctrl_npput (  sbr_b_pcie_ctrl_vintf.tnpput  ), 
  .pcie_ctrl_sbr_b_npput (  sbr_b_pcie_ctrl_vintf.mnpput  ), 
  .sbr_b_pcie_ctrl_eom (  sbr_b_pcie_ctrl_vintf.teom  ), 
  .pcie_ctrl_sbr_b_eom (  sbr_b_pcie_ctrl_vintf.meom  ), 
  .sbr_b_pcie_ctrl_payload (  sbr_b_pcie_ctrl_vintf.tpayload  ), 
  .pcie_ctrl_sbr_b_payload (  sbr_b_pcie_ctrl_vintf.mpayload  ), 
  .sbr_b_psf_1_side_ism_fabric ( sbr_b_psf_1_vintf.side_ism_fabric ),
  .psf_1_sbr_b_side_ism_agent  ( sbr_b_psf_1_vintf.side_ism_agent  ),
  .psf_1_sbr_b_side_clkreq     ( sbr_b_psf_1_vintf.side_clkreq ),
  .sbr_b_psf_1_side_clkack     ( sbr_b_psf_1_vintf.side_clkack ),
  .sbr_b_psf_1_pccup (  sbr_b_psf_1_vintf.mpccup  ), 
  .psf_1_sbr_b_pccup (  sbr_b_psf_1_vintf.tpccup  ), 
  .sbr_b_psf_1_npcup (  sbr_b_psf_1_vintf.mnpcup  ), 
  .psf_1_sbr_b_npcup (  sbr_b_psf_1_vintf.tnpcup  ), 
  .sbr_b_psf_1_pcput (  sbr_b_psf_1_vintf.tpcput  ), 
  .psf_1_sbr_b_pcput (  sbr_b_psf_1_vintf.mpcput  ), 
  .sbr_b_psf_1_npput (  sbr_b_psf_1_vintf.tnpput  ), 
  .psf_1_sbr_b_npput (  sbr_b_psf_1_vintf.mnpput  ), 
  .sbr_b_psf_1_eom (  sbr_b_psf_1_vintf.teom  ), 
  .psf_1_sbr_b_eom (  sbr_b_psf_1_vintf.meom  ), 
  .sbr_b_psf_1_payload (  sbr_b_psf_1_vintf.tpayload  ), 
  .psf_1_sbr_b_payload (  sbr_b_psf_1_vintf.mpayload  ), 
  .sbr_b_spare_b_side_ism_fabric ( sbr_b_spare_b_vintf.side_ism_fabric ),
  .spare_b_sbr_b_side_ism_agent  ( sbr_b_spare_b_vintf.side_ism_agent  ),
  .spare_b_sbr_b_side_clkreq     ( sbr_b_spare_b_vintf.side_clkreq ),
  .sbr_b_spare_b_side_clkack     ( sbr_b_spare_b_vintf.side_clkack ),
  .sbr_b_spare_b_pccup (  sbr_b_spare_b_vintf.mpccup  ), 
  .spare_b_sbr_b_pccup (  sbr_b_spare_b_vintf.tpccup  ), 
  .sbr_b_spare_b_npcup (  sbr_b_spare_b_vintf.mnpcup  ), 
  .spare_b_sbr_b_npcup (  sbr_b_spare_b_vintf.tnpcup  ), 
  .sbr_b_spare_b_pcput (  sbr_b_spare_b_vintf.tpcput  ), 
  .spare_b_sbr_b_pcput (  sbr_b_spare_b_vintf.mpcput  ), 
  .sbr_b_spare_b_npput (  sbr_b_spare_b_vintf.tnpput  ), 
  .spare_b_sbr_b_npput (  sbr_b_spare_b_vintf.mnpput  ), 
  .sbr_b_spare_b_eom (  sbr_b_spare_b_vintf.teom  ), 
  .spare_b_sbr_b_eom (  sbr_b_spare_b_vintf.meom  ), 
  .sbr_b_spare_b_payload (  sbr_b_spare_b_vintf.tpayload  ), 
  .spare_b_sbr_b_payload (  sbr_b_spare_b_vintf.mpayload  ));


sbr_c sbr_c (
  .su_local_ugt (1'b0),
  .cfg_sbr_c_cgovrd ( 5'b0 ),
  .cfg_sbr_c_cgctrl ( { 1'b1, 1'b0, 6'h0, 8'h10 } ),
  .clk_200  ( u_clk_rst_intf.clocks[0]  ),
  .rst_b_200  ( u_clk_rst_intf.resets[0]  ),
  .sbr_c_sbr_a_pccup (  sbr_c_sbr_a_vintf.tpccup  ), 
  .sbr_a_sbr_c_pccup (  (u_power_intf.powergood[0]) ? sbr_c_sbr_a_vintf.mpccup : '0), 
  .sbr_c_sbr_a_npcup (  sbr_c_sbr_a_vintf.tnpcup  ), 
  .sbr_a_sbr_c_npcup (  (u_power_intf.powergood[0]) ? sbr_c_sbr_a_vintf.mnpcup  : '0), 
  .sbr_c_sbr_a_pcput (  sbr_c_sbr_a_vintf.mpcput  ), 
  .sbr_a_sbr_c_pcput (  (u_power_intf.powergood[0]) ? sbr_c_sbr_a_vintf.tpcput : '0 ), 
  .sbr_c_sbr_a_npput (  sbr_c_sbr_a_vintf.mnpput  ), 
  .sbr_a_sbr_c_npput (  (u_power_intf.powergood[0]) ? sbr_c_sbr_a_vintf.tnpput : '0 ), 
  .sbr_c_sbr_a_eom (  sbr_c_sbr_a_vintf.meom  ), 
  .sbr_a_sbr_c_eom (  (u_power_intf.powergood[0]) ? sbr_c_sbr_a_vintf.teom : '0) , 
  .sbr_c_sbr_a_payload (  sbr_c_sbr_a_vintf.mpayload  ), 
  .sbr_a_sbr_c_payload (  (u_power_intf.powergood[0]) ? sbr_c_sbr_a_vintf.tpayload : '0  ), 
  .sbr_c_sbr_a_side_ism_fabric ( sbr_c_sbr_a_vintf.side_ism_fabric ),
  .sbr_a_sbr_c_side_ism_agent  ( (u_power_intf.powergood[0]) ? sbr_c_sbr_a_vintf.side_ism_agent : '0 ),
  .sbr_c_sbr_d_pccup (  sbr_c_sbr_d_vintf.tpccup  ), 
  .sbr_d_sbr_c_pccup (  (u_power_intf.powergood[2] ) ? sbr_c_sbr_d_vintf.mpccup  : '0 ), 
  .sbr_c_sbr_d_npcup (  sbr_c_sbr_d_vintf.tnpcup  ), 
  .sbr_d_sbr_c_npcup (  (u_power_intf.powergood[2] ) ? sbr_c_sbr_d_vintf.mnpcup : '0  ), 
  .sbr_c_sbr_d_pcput (  sbr_c_sbr_d_vintf.mpcput  ), 
  .sbr_d_sbr_c_pcput (  (u_power_intf.powergood[2] ) ? sbr_c_sbr_d_vintf.tpcput : '0  ), 
  .sbr_c_sbr_d_npput (  sbr_c_sbr_d_vintf.mnpput  ), 
  .sbr_d_sbr_c_npput (  (u_power_intf.powergood[2] ) ? sbr_c_sbr_d_vintf.tnpput : '0  ), 
  .sbr_c_sbr_d_eom (  sbr_c_sbr_d_vintf.meom  ), 
  .sbr_d_sbr_c_eom (  (u_power_intf.powergood[2] ) ? sbr_c_sbr_d_vintf.teom  : '0 ), 
  .sbr_c_sbr_d_payload (  sbr_c_sbr_d_vintf.mpayload  ), 
  .sbr_d_sbr_c_payload (  (u_power_intf.powergood[2] ) ? sbr_c_sbr_d_vintf.tpayload : '0  ), 
  .sbr_d_sbr_c_side_ism_fabric ( (u_power_intf.powergood[2] ) ? sbr_c_sbr_d_vintf.side_ism_fabric  : '0 ),
  .sbr_c_sbr_d_side_ism_agent  ( sbr_c_sbr_d_vintf.side_ism_agent  ),
  .sbr_c_dfx_jtag_side_ism_fabric ( sbr_c_dfx_jtag_vintf.side_ism_fabric ),
  .dfx_jtag_sbr_c_side_ism_agent  ( sbr_c_dfx_jtag_vintf.side_ism_agent  ),
  .dfx_jtag_sbr_c_side_clkreq     ( sbr_c_dfx_jtag_vintf.side_clkreq ),
  .sbr_c_dfx_jtag_side_clkack     ( sbr_c_dfx_jtag_vintf.side_clkack ),
  .sbr_c_dfx_jtag_pccup (  sbr_c_dfx_jtag_vintf.mpccup  ), 
  .dfx_jtag_sbr_c_pccup (  sbr_c_dfx_jtag_vintf.tpccup  ), 
  .sbr_c_dfx_jtag_npcup (  sbr_c_dfx_jtag_vintf.mnpcup  ), 
  .dfx_jtag_sbr_c_npcup (  sbr_c_dfx_jtag_vintf.tnpcup  ), 
  .sbr_c_dfx_jtag_pcput (  sbr_c_dfx_jtag_vintf.tpcput  ), 
  .dfx_jtag_sbr_c_pcput (  sbr_c_dfx_jtag_vintf.mpcput  ), 
  .sbr_c_dfx_jtag_npput (  sbr_c_dfx_jtag_vintf.tnpput  ), 
  .dfx_jtag_sbr_c_npput (  sbr_c_dfx_jtag_vintf.mnpput  ), 
  .sbr_c_dfx_jtag_eom (  sbr_c_dfx_jtag_vintf.teom  ), 
  .dfx_jtag_sbr_c_eom (  sbr_c_dfx_jtag_vintf.meom  ), 
  .sbr_c_dfx_jtag_payload (  sbr_c_dfx_jtag_vintf.tpayload  ), 
  .dfx_jtag_sbr_c_payload (  sbr_c_dfx_jtag_vintf.mpayload  ), 
  .sbr_c_itunit_side_ism_fabric ( sbr_c_itunit_vintf.side_ism_fabric ),
  .itunit_sbr_c_side_ism_agent  ( sbr_c_itunit_vintf.side_ism_agent  ),
  .itunit_sbr_c_side_clkreq     ( sbr_c_itunit_vintf.side_clkreq ),
  .sbr_c_itunit_side_clkack     ( sbr_c_itunit_vintf.side_clkack ),
  .sbr_c_itunit_pccup (  sbr_c_itunit_vintf.mpccup  ), 
  .itunit_sbr_c_pccup (  sbr_c_itunit_vintf.tpccup  ), 
  .sbr_c_itunit_npcup (  sbr_c_itunit_vintf.mnpcup  ), 
  .itunit_sbr_c_npcup (  sbr_c_itunit_vintf.tnpcup  ), 
  .sbr_c_itunit_pcput (  sbr_c_itunit_vintf.tpcput  ), 
  .itunit_sbr_c_pcput (  sbr_c_itunit_vintf.mpcput  ), 
  .sbr_c_itunit_npput (  sbr_c_itunit_vintf.tnpput  ), 
  .itunit_sbr_c_npput (  sbr_c_itunit_vintf.mnpput  ), 
  .sbr_c_itunit_eom (  sbr_c_itunit_vintf.teom  ), 
  .itunit_sbr_c_eom (  sbr_c_itunit_vintf.meom  ), 
  .sbr_c_itunit_payload (  sbr_c_itunit_vintf.tpayload  ), 
  .itunit_sbr_c_payload (  sbr_c_itunit_vintf.mpayload  ), 
  .sbr_c_psf_3_side_ism_fabric ( sbr_c_psf_3_vintf.side_ism_fabric ),
  .psf_3_sbr_c_side_ism_agent  ( sbr_c_psf_3_vintf.side_ism_agent  ),
  .psf_3_sbr_c_side_clkreq     ( sbr_c_psf_3_vintf.side_clkreq ),
  .sbr_c_psf_3_side_clkack     ( sbr_c_psf_3_vintf.side_clkack ),
  .sbr_c_psf_3_pccup (  sbr_c_psf_3_vintf.mpccup  ), 
  .psf_3_sbr_c_pccup (  sbr_c_psf_3_vintf.tpccup  ), 
  .sbr_c_psf_3_npcup (  sbr_c_psf_3_vintf.mnpcup  ), 
  .psf_3_sbr_c_npcup (  sbr_c_psf_3_vintf.tnpcup  ), 
  .sbr_c_psf_3_pcput (  sbr_c_psf_3_vintf.tpcput  ), 
  .psf_3_sbr_c_pcput (  sbr_c_psf_3_vintf.mpcput  ), 
  .sbr_c_psf_3_npput (  sbr_c_psf_3_vintf.tnpput  ), 
  .psf_3_sbr_c_npput (  sbr_c_psf_3_vintf.mnpput  ), 
  .sbr_c_psf_3_eom (  sbr_c_psf_3_vintf.teom  ), 
  .psf_3_sbr_c_eom (  sbr_c_psf_3_vintf.meom  ), 
  .sbr_c_psf_3_payload (  sbr_c_psf_3_vintf.tpayload  ), 
  .psf_3_sbr_c_payload (  sbr_c_psf_3_vintf.mpayload  ), 
  .sbr_c_spare_c_side_ism_fabric ( sbr_c_spare_c_vintf.side_ism_fabric ),
  .spare_c_sbr_c_side_ism_agent  ( sbr_c_spare_c_vintf.side_ism_agent  ),
  .spare_c_sbr_c_side_clkreq     ( sbr_c_spare_c_vintf.side_clkreq ),
  .sbr_c_spare_c_side_clkack     ( sbr_c_spare_c_vintf.side_clkack ),
  .sbr_c_spare_c_pccup (  sbr_c_spare_c_vintf.mpccup  ), 
  .spare_c_sbr_c_pccup (  sbr_c_spare_c_vintf.tpccup  ), 
  .sbr_c_spare_c_npcup (  sbr_c_spare_c_vintf.mnpcup  ), 
  .spare_c_sbr_c_npcup (  sbr_c_spare_c_vintf.tnpcup  ), 
  .sbr_c_spare_c_pcput (  sbr_c_spare_c_vintf.tpcput  ), 
  .spare_c_sbr_c_pcput (  sbr_c_spare_c_vintf.mpcput  ), 
  .sbr_c_spare_c_npput (  sbr_c_spare_c_vintf.tnpput  ), 
  .spare_c_sbr_c_npput (  sbr_c_spare_c_vintf.mnpput  ), 
  .sbr_c_spare_c_eom (  sbr_c_spare_c_vintf.teom  ), 
  .spare_c_sbr_c_eom (  sbr_c_spare_c_vintf.meom  ), 
  .sbr_c_spare_c_payload (  sbr_c_spare_c_vintf.tpayload  ), 
  .spare_c_sbr_c_payload (  sbr_c_spare_c_vintf.mpayload  ), 
  .sbr_c_vtunit_side_ism_fabric ( sbr_c_vtunit_vintf.side_ism_fabric ),
  .vtunit_sbr_c_side_ism_agent  ( sbr_c_vtunit_vintf.side_ism_agent  ),
  .vtunit_sbr_c_side_clkreq     ( sbr_c_vtunit_vintf.side_clkreq ),
  .sbr_c_vtunit_side_clkack     ( sbr_c_vtunit_vintf.side_clkack ),
  .sbr_c_vtunit_pccup (  sbr_c_vtunit_vintf.mpccup  ), 
  .vtunit_sbr_c_pccup (  sbr_c_vtunit_vintf.tpccup  ), 
  .sbr_c_vtunit_npcup (  sbr_c_vtunit_vintf.mnpcup  ), 
  .vtunit_sbr_c_npcup (  sbr_c_vtunit_vintf.tnpcup  ), 
  .sbr_c_vtunit_pcput (  sbr_c_vtunit_vintf.tpcput  ), 
  .vtunit_sbr_c_pcput (  sbr_c_vtunit_vintf.mpcput  ), 
  .sbr_c_vtunit_npput (  sbr_c_vtunit_vintf.tnpput  ), 
  .vtunit_sbr_c_npput (  sbr_c_vtunit_vintf.mnpput  ), 
  .sbr_c_vtunit_eom (  sbr_c_vtunit_vintf.teom  ), 
  .vtunit_sbr_c_eom (  sbr_c_vtunit_vintf.meom  ), 
  .sbr_c_vtunit_payload (  sbr_c_vtunit_vintf.tpayload  ), 
  .vtunit_sbr_c_payload (  sbr_c_vtunit_vintf.mpayload  ), 
  .sbr_c_hunit_side_ism_fabric ( sbr_c_hunit_vintf.side_ism_fabric ),
  .hunit_sbr_c_side_ism_agent  ( sbr_c_hunit_vintf.side_ism_agent  ),
  .hunit_sbr_c_side_clkreq     ( sbr_c_hunit_vintf.side_clkreq ),
  .sbr_c_hunit_side_clkack     ( sbr_c_hunit_vintf.side_clkack ),
  .sbr_c_hunit_pccup (  sbr_c_hunit_vintf.mpccup  ), 
  .hunit_sbr_c_pccup (  sbr_c_hunit_vintf.tpccup  ), 
  .sbr_c_hunit_npcup (  sbr_c_hunit_vintf.mnpcup  ), 
  .hunit_sbr_c_npcup (  sbr_c_hunit_vintf.tnpcup  ), 
  .sbr_c_hunit_pcput (  sbr_c_hunit_vintf.tpcput  ), 
  .hunit_sbr_c_pcput (  sbr_c_hunit_vintf.mpcput  ), 
  .sbr_c_hunit_npput (  sbr_c_hunit_vintf.tnpput  ), 
  .hunit_sbr_c_npput (  sbr_c_hunit_vintf.mnpput  ), 
  .sbr_c_hunit_eom (  sbr_c_hunit_vintf.teom  ), 
  .hunit_sbr_c_eom (  sbr_c_hunit_vintf.meom  ), 
  .sbr_c_hunit_payload (  sbr_c_hunit_vintf.tpayload  ), 
  .hunit_sbr_c_payload (  sbr_c_hunit_vintf.mpayload  ), 
  .sbr_c_bunit_side_ism_fabric ( sbr_c_bunit_vintf.side_ism_fabric ),
  .bunit_sbr_c_side_ism_agent  ( sbr_c_bunit_vintf.side_ism_agent  ),
  .bunit_sbr_c_side_clkreq     ( sbr_c_bunit_vintf.side_clkreq ),
  .sbr_c_bunit_side_clkack     ( sbr_c_bunit_vintf.side_clkack ),
  .sbr_c_bunit_pccup (  sbr_c_bunit_vintf.mpccup  ), 
  .bunit_sbr_c_pccup (  sbr_c_bunit_vintf.tpccup  ), 
  .sbr_c_bunit_npcup (  sbr_c_bunit_vintf.mnpcup  ), 
  .bunit_sbr_c_npcup (  sbr_c_bunit_vintf.tnpcup  ), 
  .sbr_c_bunit_pcput (  sbr_c_bunit_vintf.tpcput  ), 
  .bunit_sbr_c_pcput (  sbr_c_bunit_vintf.mpcput  ), 
  .sbr_c_bunit_npput (  sbr_c_bunit_vintf.tnpput  ), 
  .bunit_sbr_c_npput (  sbr_c_bunit_vintf.mnpput  ), 
  .sbr_c_bunit_eom (  sbr_c_bunit_vintf.teom  ), 
  .bunit_sbr_c_eom (  sbr_c_bunit_vintf.meom  ), 
  .sbr_c_bunit_payload (  sbr_c_bunit_vintf.tpayload  ), 
  .bunit_sbr_c_payload (  sbr_c_bunit_vintf.mpayload  ), 
  .sbr_c_cunit_side_ism_fabric ( sbr_c_cunit_vintf.side_ism_fabric ),
  .cunit_sbr_c_side_ism_agent  ( sbr_c_cunit_vintf.side_ism_agent  ),
  .cunit_sbr_c_side_clkreq     ( sbr_c_cunit_vintf.side_clkreq ),
  .sbr_c_cunit_side_clkack     ( sbr_c_cunit_vintf.side_clkack ),
  .sbr_c_cunit_pccup (  sbr_c_cunit_vintf.mpccup  ), 
  .cunit_sbr_c_pccup (  sbr_c_cunit_vintf.tpccup  ), 
  .sbr_c_cunit_npcup (  sbr_c_cunit_vintf.mnpcup  ), 
  .cunit_sbr_c_npcup (  sbr_c_cunit_vintf.tnpcup  ), 
  .sbr_c_cunit_pcput (  sbr_c_cunit_vintf.tpcput  ), 
  .cunit_sbr_c_pcput (  sbr_c_cunit_vintf.mpcput  ), 
  .sbr_c_cunit_npput (  sbr_c_cunit_vintf.tnpput  ), 
  .cunit_sbr_c_npput (  sbr_c_cunit_vintf.mnpput  ), 
  .sbr_c_cunit_eom (  sbr_c_cunit_vintf.teom  ), 
  .cunit_sbr_c_eom (  sbr_c_cunit_vintf.meom  ), 
  .sbr_c_cunit_payload (  sbr_c_cunit_vintf.tpayload  ), 
  .cunit_sbr_c_payload (  sbr_c_cunit_vintf.mpayload  ), 
  .sbr_c_cpunit_side_ism_fabric ( sbr_c_cpunit_vintf.side_ism_fabric ),
  .cpunit_sbr_c_side_ism_agent  ( sbr_c_cpunit_vintf.side_ism_agent  ),
  .cpunit_sbr_c_side_clkreq     ( sbr_c_cpunit_vintf.side_clkreq ),
  .sbr_c_cpunit_side_clkack     ( sbr_c_cpunit_vintf.side_clkack ),
  .sbr_c_cpunit_pccup (  sbr_c_cpunit_vintf.mpccup  ), 
  .cpunit_sbr_c_pccup (  sbr_c_cpunit_vintf.tpccup  ), 
  .sbr_c_cpunit_npcup (  sbr_c_cpunit_vintf.mnpcup  ), 
  .cpunit_sbr_c_npcup (  sbr_c_cpunit_vintf.tnpcup  ), 
  .sbr_c_cpunit_pcput (  sbr_c_cpunit_vintf.tpcput  ), 
  .cpunit_sbr_c_pcput (  sbr_c_cpunit_vintf.mpcput  ), 
  .sbr_c_cpunit_npput (  sbr_c_cpunit_vintf.tnpput  ), 
  .cpunit_sbr_c_npput (  sbr_c_cpunit_vintf.mnpput  ), 
  .sbr_c_cpunit_eom (  sbr_c_cpunit_vintf.teom  ), 
  .cpunit_sbr_c_eom (  sbr_c_cpunit_vintf.meom  ), 
  .sbr_c_cpunit_payload (  sbr_c_cpunit_vintf.tpayload  ), 
  .cpunit_sbr_c_payload (  sbr_c_cpunit_vintf.mpayload  ), 
  .sbr_c_legacy_side_ism_fabric ( sbr_c_legacy_vintf.side_ism_fabric ),
  .legacy_sbr_c_side_ism_agent  ( sbr_c_legacy_vintf.side_ism_agent  ),
  .legacy_sbr_c_side_clkreq     ( sbr_c_legacy_vintf.side_clkreq ),
  .sbr_c_legacy_side_clkack     ( sbr_c_legacy_vintf.side_clkack ),
  .sbr_c_legacy_pccup (  sbr_c_legacy_vintf.mpccup  ), 
  .legacy_sbr_c_pccup (  sbr_c_legacy_vintf.tpccup  ), 
  .sbr_c_legacy_npcup (  sbr_c_legacy_vintf.mnpcup  ), 
  .legacy_sbr_c_npcup (  sbr_c_legacy_vintf.tnpcup  ), 
  .sbr_c_legacy_pcput (  sbr_c_legacy_vintf.tpcput  ), 
  .legacy_sbr_c_pcput (  sbr_c_legacy_vintf.mpcput  ), 
  .sbr_c_legacy_npput (  sbr_c_legacy_vintf.tnpput  ), 
  .legacy_sbr_c_npput (  sbr_c_legacy_vintf.mnpput  ), 
  .sbr_c_legacy_eom (  sbr_c_legacy_vintf.teom  ), 
  .legacy_sbr_c_eom (  sbr_c_legacy_vintf.meom  ), 
  .sbr_c_legacy_payload (  sbr_c_legacy_vintf.tpayload  ), 
  .legacy_sbr_c_payload (  sbr_c_legacy_vintf.mpayload  ), 
  .sbr_c_dfx_lakemore_side_ism_fabric ( sbr_c_dfx_lakemore_vintf.side_ism_fabric ),
  .dfx_lakemore_sbr_c_side_ism_agent  ( sbr_c_dfx_lakemore_vintf.side_ism_agent  ),
  .dfx_lakemore_sbr_c_side_clkreq     ( sbr_c_dfx_lakemore_vintf.side_clkreq ),
  .sbr_c_dfx_lakemore_side_clkack     ( sbr_c_dfx_lakemore_vintf.side_clkack ),
  .sbr_c_dfx_lakemore_pccup (  sbr_c_dfx_lakemore_vintf.mpccup  ), 
  .dfx_lakemore_sbr_c_pccup (  sbr_c_dfx_lakemore_vintf.tpccup  ), 
  .sbr_c_dfx_lakemore_npcup (  sbr_c_dfx_lakemore_vintf.mnpcup  ), 
  .dfx_lakemore_sbr_c_npcup (  sbr_c_dfx_lakemore_vintf.tnpcup  ), 
  .sbr_c_dfx_lakemore_pcput (  sbr_c_dfx_lakemore_vintf.tpcput  ), 
  .dfx_lakemore_sbr_c_pcput (  sbr_c_dfx_lakemore_vintf.mpcput  ), 
  .sbr_c_dfx_lakemore_npput (  sbr_c_dfx_lakemore_vintf.tnpput  ), 
  .dfx_lakemore_sbr_c_npput (  sbr_c_dfx_lakemore_vintf.mnpput  ), 
  .sbr_c_dfx_lakemore_eom (  sbr_c_dfx_lakemore_vintf.teom  ), 
  .dfx_lakemore_sbr_c_eom (  sbr_c_dfx_lakemore_vintf.meom  ), 
  .sbr_c_dfx_lakemore_payload (  sbr_c_dfx_lakemore_vintf.tpayload  ), 
  .dfx_lakemore_sbr_c_payload (  sbr_c_dfx_lakemore_vintf.mpayload  ), 
  .sbr_c_dfx_omar_side_ism_fabric ( sbr_c_dfx_omar_vintf.side_ism_fabric ),
  .dfx_omar_sbr_c_side_ism_agent  ( sbr_c_dfx_omar_vintf.side_ism_agent  ),
  .dfx_omar_sbr_c_side_clkreq     ( sbr_c_dfx_omar_vintf.side_clkreq ),
  .sbr_c_dfx_omar_side_clkack     ( sbr_c_dfx_omar_vintf.side_clkack ),
  .sbr_c_dfx_omar_pccup (  sbr_c_dfx_omar_vintf.mpccup  ), 
  .dfx_omar_sbr_c_pccup (  sbr_c_dfx_omar_vintf.tpccup  ), 
  .sbr_c_dfx_omar_npcup (  sbr_c_dfx_omar_vintf.mnpcup  ), 
  .dfx_omar_sbr_c_npcup (  sbr_c_dfx_omar_vintf.tnpcup  ), 
  .sbr_c_dfx_omar_pcput (  sbr_c_dfx_omar_vintf.tpcput  ), 
  .dfx_omar_sbr_c_pcput (  sbr_c_dfx_omar_vintf.mpcput  ), 
  .sbr_c_dfx_omar_npput (  sbr_c_dfx_omar_vintf.tnpput  ), 
  .dfx_omar_sbr_c_npput (  sbr_c_dfx_omar_vintf.mnpput  ), 
  .sbr_c_dfx_omar_eom (  sbr_c_dfx_omar_vintf.teom  ), 
  .dfx_omar_sbr_c_eom (  sbr_c_dfx_omar_vintf.meom  ), 
  .sbr_c_dfx_omar_payload (  sbr_c_dfx_omar_vintf.tpayload  ), 
  .dfx_omar_sbr_c_payload (  sbr_c_dfx_omar_vintf.mpayload  ));


sbr_d sbr_d (
  .su_local_ugt (1'b0),
  .cfg_sbr_d_cgovrd ( 5'b0 ),
  .cfg_sbr_d_cgctrl ( { 1'b1, 1'b0, 6'h0, 8'h10 } ),
  .clk_200  ( u_clk_rst_intf.clocks[0]  ),
  .rst_b_200  ( u_clk_rst_intf.resets[0]  ),
  .sbr_d_sbr_c_pccup (  sbr_d_sbr_c_vintf.tpccup  ), 
  .sbr_c_sbr_d_pccup (  (u_power_intf.powergood[2] ) ? sbr_d_sbr_c_vintf.mpccup  :'0 ), 
  .sbr_d_sbr_c_npcup (  sbr_d_sbr_c_vintf.tnpcup  ), 
  .sbr_c_sbr_d_npcup (  (u_power_intf.powergood[2] ) ? sbr_d_sbr_c_vintf.mnpcup :'0  ), 
  .sbr_d_sbr_c_pcput (  sbr_d_sbr_c_vintf.mpcput  ), 
  .sbr_c_sbr_d_pcput (  (u_power_intf.powergood[2] ) ? sbr_d_sbr_c_vintf.tpcput :'0  ), 
  .sbr_d_sbr_c_npput (  sbr_d_sbr_c_vintf.mnpput  ), 
  .sbr_c_sbr_d_npput (  (u_power_intf.powergood[2] ) ? sbr_d_sbr_c_vintf.tnpput :'0  ), 
  .sbr_d_sbr_c_eom (  sbr_d_sbr_c_vintf.meom  ), 
  .sbr_c_sbr_d_eom (  (u_power_intf.powergood[2] ) ? sbr_d_sbr_c_vintf.teom  :'0 ), 
  .sbr_d_sbr_c_payload (  sbr_d_sbr_c_vintf.mpayload  ), 
  .sbr_c_sbr_d_payload (  (u_power_intf.powergood[2] ) ? sbr_d_sbr_c_vintf.tpayload  :'0 ), 
  .sbr_d_sbr_c_side_ism_fabric ( sbr_d_sbr_c_vintf.side_ism_fabric ),
  .sbr_c_sbr_d_side_ism_agent  ( (u_power_intf.powergood[2] ) ? sbr_d_sbr_c_vintf.side_ism_agent  :'0  ),
  .sbr_d_mcu_side_ism_fabric ( sbr_d_mcu_vintf.side_ism_fabric ),
  .mcu_sbr_d_side_ism_agent  ( sbr_d_mcu_vintf.side_ism_agent  ),
  .mcu_sbr_d_side_clkreq     ( sbr_d_mcu_vintf.side_clkreq ),
  .sbr_d_mcu_side_clkack     ( sbr_d_mcu_vintf.side_clkack ),
  .sbr_d_mcu_pccup (  sbr_d_mcu_vintf.mpccup  ), 
  .mcu_sbr_d_pccup (  sbr_d_mcu_vintf.tpccup  ), 
  .sbr_d_mcu_npcup (  sbr_d_mcu_vintf.mnpcup  ), 
  .mcu_sbr_d_npcup (  sbr_d_mcu_vintf.tnpcup  ), 
  .sbr_d_mcu_pcput (  sbr_d_mcu_vintf.tpcput  ), 
  .mcu_sbr_d_pcput (  sbr_d_mcu_vintf.mpcput  ), 
  .sbr_d_mcu_npput (  sbr_d_mcu_vintf.tnpput  ), 
  .mcu_sbr_d_npput (  sbr_d_mcu_vintf.mnpput  ), 
  .sbr_d_mcu_eom (  sbr_d_mcu_vintf.teom  ), 
  .mcu_sbr_d_eom (  sbr_d_mcu_vintf.meom  ), 
  .sbr_d_mcu_payload (  sbr_d_mcu_vintf.tpayload  ), 
  .mcu_sbr_d_payload (  sbr_d_mcu_vintf.mpayload  ), 
  .well3_pok ( u_power_intf.powergood[3] ), 
  .sbr_d_sec_side_ism_fabric ( sbr_d_sec_vintf.side_ism_fabric ),
  .sec_sbr_d_side_ism_agent  ( sbr_d_sec_vintf.side_ism_agent  ),
  .sec_sbr_d_side_clkreq     ( sbr_d_sec_vintf.side_clkreq ),
  .sbr_d_sec_side_clkack     ( sbr_d_sec_vintf.side_clkack ),
  .sbr_d_sec_pccup (  sbr_d_sec_vintf.mpccup  ), 
  .sec_sbr_d_pccup (  sbr_d_sec_vintf.tpccup  ), 
  .sbr_d_sec_npcup (  sbr_d_sec_vintf.mnpcup  ), 
  .sec_sbr_d_npcup (  sbr_d_sec_vintf.tnpcup  ), 
  .sbr_d_sec_pcput (  sbr_d_sec_vintf.tpcput  ), 
  .sec_sbr_d_pcput (  sbr_d_sec_vintf.mpcput  ), 
  .sbr_d_sec_npput (  sbr_d_sec_vintf.tnpput  ), 
  .sec_sbr_d_npput (  sbr_d_sec_vintf.mnpput  ), 
  .sbr_d_sec_eom (  sbr_d_sec_vintf.teom  ), 
  .sec_sbr_d_eom (  sbr_d_sec_vintf.meom  ), 
  .sbr_d_sec_payload (  sbr_d_sec_vintf.tpayload  ), 
  .sec_sbr_d_payload (  sbr_d_sec_vintf.mpayload  ), 
  .sbr_d_ddrio_side_ism_fabric ( sbr_d_ddrio_vintf.side_ism_fabric ),
  .ddrio_sbr_d_side_ism_agent  ( sbr_d_ddrio_vintf.side_ism_agent  ),
  .ddrio_sbr_d_side_clkreq     ( sbr_d_ddrio_vintf.side_clkreq ),
  .sbr_d_ddrio_side_clkack     ( sbr_d_ddrio_vintf.side_clkack ),
  .sbr_d_ddrio_pccup (  sbr_d_ddrio_vintf.mpccup  ), 
  .ddrio_sbr_d_pccup (  sbr_d_ddrio_vintf.tpccup  ), 
  .sbr_d_ddrio_npcup (  sbr_d_ddrio_vintf.mnpcup  ), 
  .ddrio_sbr_d_npcup (  sbr_d_ddrio_vintf.tnpcup  ), 
  .sbr_d_ddrio_pcput (  sbr_d_ddrio_vintf.tpcput  ), 
  .ddrio_sbr_d_pcput (  sbr_d_ddrio_vintf.mpcput  ), 
  .sbr_d_ddrio_npput (  sbr_d_ddrio_vintf.tnpput  ), 
  .ddrio_sbr_d_npput (  sbr_d_ddrio_vintf.mnpput  ), 
  .sbr_d_ddrio_eom (  sbr_d_ddrio_vintf.teom  ), 
  .ddrio_sbr_d_eom (  sbr_d_ddrio_vintf.meom  ), 
  .sbr_d_ddrio_payload (  sbr_d_ddrio_vintf.tpayload  ), 
  .ddrio_sbr_d_payload (  sbr_d_ddrio_vintf.mpayload  ), 
  .sbr_d_reut_0_side_ism_fabric ( sbr_d_reut_0_vintf.side_ism_fabric ),
  .reut_0_sbr_d_side_ism_agent  ( sbr_d_reut_0_vintf.side_ism_agent  ),
  .reut_0_sbr_d_side_clkreq     ( sbr_d_reut_0_vintf.side_clkreq ),
  .sbr_d_reut_0_side_clkack     ( sbr_d_reut_0_vintf.side_clkack ),
  .sbr_d_reut_0_pccup (  sbr_d_reut_0_vintf.mpccup  ), 
  .reut_0_sbr_d_pccup (  sbr_d_reut_0_vintf.tpccup  ), 
  .sbr_d_reut_0_npcup (  sbr_d_reut_0_vintf.mnpcup  ), 
  .reut_0_sbr_d_npcup (  sbr_d_reut_0_vintf.tnpcup  ), 
  .sbr_d_reut_0_pcput (  sbr_d_reut_0_vintf.tpcput  ), 
  .reut_0_sbr_d_pcput (  sbr_d_reut_0_vintf.mpcput  ), 
  .sbr_d_reut_0_npput (  sbr_d_reut_0_vintf.tnpput  ), 
  .reut_0_sbr_d_npput (  sbr_d_reut_0_vintf.mnpput  ), 
  .sbr_d_reut_0_eom (  sbr_d_reut_0_vintf.teom  ), 
  .reut_0_sbr_d_eom (  sbr_d_reut_0_vintf.meom  ), 
  .sbr_d_reut_0_payload (  sbr_d_reut_0_vintf.tpayload  ), 
  .reut_0_sbr_d_payload (  sbr_d_reut_0_vintf.mpayload  ), 
  .sbr_d_reut_1_side_ism_fabric ( sbr_d_reut_1_vintf.side_ism_fabric ),
  .reut_1_sbr_d_side_ism_agent  ( sbr_d_reut_1_vintf.side_ism_agent  ),
  .reut_1_sbr_d_side_clkreq     ( sbr_d_reut_1_vintf.side_clkreq ),
  .sbr_d_reut_1_side_clkack     ( sbr_d_reut_1_vintf.side_clkack ),
  .sbr_d_reut_1_pccup (  sbr_d_reut_1_vintf.mpccup  ), 
  .reut_1_sbr_d_pccup (  sbr_d_reut_1_vintf.tpccup  ), 
  .sbr_d_reut_1_npcup (  sbr_d_reut_1_vintf.mnpcup  ), 
  .reut_1_sbr_d_npcup (  sbr_d_reut_1_vintf.tnpcup  ), 
  .sbr_d_reut_1_pcput (  sbr_d_reut_1_vintf.tpcput  ), 
  .reut_1_sbr_d_pcput (  sbr_d_reut_1_vintf.mpcput  ), 
  .sbr_d_reut_1_npput (  sbr_d_reut_1_vintf.tnpput  ), 
  .reut_1_sbr_d_npput (  sbr_d_reut_1_vintf.mnpput  ), 
  .sbr_d_reut_1_eom (  sbr_d_reut_1_vintf.teom  ), 
  .reut_1_sbr_d_eom (  sbr_d_reut_1_vintf.meom  ), 
  .sbr_d_reut_1_payload (  sbr_d_reut_1_vintf.tpayload  ), 
  .reut_1_sbr_d_payload (  sbr_d_reut_1_vintf.mpayload  ), 
  .sbr_d_spare_d_side_ism_fabric ( sbr_d_spare_d_vintf.side_ism_fabric ),
  .spare_d_sbr_d_side_ism_agent  ( sbr_d_spare_d_vintf.side_ism_agent  ),
  .spare_d_sbr_d_side_clkreq     ( sbr_d_spare_d_vintf.side_clkreq ),
  .sbr_d_spare_d_side_clkack     ( sbr_d_spare_d_vintf.side_clkack ),
  .sbr_d_spare_d_pccup (  sbr_d_spare_d_vintf.mpccup  ), 
  .spare_d_sbr_d_pccup (  sbr_d_spare_d_vintf.tpccup  ), 
  .sbr_d_spare_d_npcup (  sbr_d_spare_d_vintf.mnpcup  ), 
  .spare_d_sbr_d_npcup (  sbr_d_spare_d_vintf.tnpcup  ), 
  .sbr_d_spare_d_pcput (  sbr_d_spare_d_vintf.tpcput  ), 
  .spare_d_sbr_d_pcput (  sbr_d_spare_d_vintf.mpcput  ), 
  .sbr_d_spare_d_npput (  sbr_d_spare_d_vintf.tnpput  ), 
  .spare_d_sbr_d_npput (  sbr_d_spare_d_vintf.mnpput  ), 
  .sbr_d_spare_d_eom (  sbr_d_spare_d_vintf.teom  ), 
  .spare_d_sbr_d_eom (  sbr_d_spare_d_vintf.meom  ), 
  .sbr_d_spare_d_payload (  sbr_d_spare_d_vintf.tpayload  ), 
  .spare_d_sbr_d_payload (  sbr_d_spare_d_vintf.mpayload  ));


sbr_e sbr_e (
  .su_local_ugt (1'b0),
  .cfg_sbr_e_cgovrd ( 5'b0 ),
  .cfg_sbr_e_cgctrl ( { 1'b1, 1'b0, 6'h0, 8'h10 } ),
  .clk_200  ( u_clk_rst_intf.clocks[0]  ),
  .rst_b_200  ( u_clk_rst_intf.resets[0]  ),
  .sbr_e_sbr_a_pccup (  sbr_e_sbr_a_vintf.tpccup  ), 
  .sbr_a_sbr_e_pccup (  (u_power_intf.powergood[0] ) ? sbr_e_sbr_a_vintf.mpccup : '0  ), 
  .sbr_e_sbr_a_npcup (  sbr_e_sbr_a_vintf.tnpcup  ), 
  .sbr_a_sbr_e_npcup (  (u_power_intf.powergood[0] ) ? sbr_e_sbr_a_vintf.mnpcup : '0    ), 
  .sbr_e_sbr_a_pcput (  sbr_e_sbr_a_vintf.mpcput  ), 
  .sbr_a_sbr_e_pcput (  (u_power_intf.powergood[0] ) ? sbr_e_sbr_a_vintf.tpcput : '0    ), 
  .sbr_e_sbr_a_npput (  sbr_e_sbr_a_vintf.mnpput  ), 
  .sbr_a_sbr_e_npput (  (u_power_intf.powergood[0] ) ? sbr_e_sbr_a_vintf.tnpput : '0     ), 
  .sbr_e_sbr_a_eom (  sbr_e_sbr_a_vintf.meom  ), 
  .sbr_a_sbr_e_eom (  (u_power_intf.powergood[0] ) ? sbr_e_sbr_a_vintf.teom  : '0   ), 
  .sbr_e_sbr_a_payload (  sbr_e_sbr_a_vintf.mpayload  ), 
  .sbr_a_sbr_e_payload (  (u_power_intf.powergood[0] ) ? sbr_e_sbr_a_vintf.tpayload   : '0  ), 
  .sbr_e_sbr_a_side_ism_fabric ( sbr_e_sbr_a_vintf.side_ism_fabric ),
  .sbr_a_sbr_e_side_ism_agent  ( (u_power_intf.powergood[0] ) ? sbr_e_sbr_a_vintf.side_ism_agent : '0      ),
  .sbr_e_vdac_side_ism_fabric ( sbr_e_vdac_vintf.side_ism_fabric ),
  .vdac_sbr_e_side_ism_agent  ( sbr_e_vdac_vintf.side_ism_agent  ),
  .vdac_sbr_e_side_clkreq     ( sbr_e_vdac_vintf.side_clkreq ),
  .sbr_e_vdac_side_clkack     ( sbr_e_vdac_vintf.side_clkack ),
  .sbr_e_vdac_pccup (  sbr_e_vdac_vintf.mpccup  ), 
  .vdac_sbr_e_pccup (  sbr_e_vdac_vintf.tpccup  ), 
  .sbr_e_vdac_npcup (  sbr_e_vdac_vintf.mnpcup  ), 
  .vdac_sbr_e_npcup (  sbr_e_vdac_vintf.tnpcup  ), 
  .sbr_e_vdac_pcput (  sbr_e_vdac_vintf.tpcput  ), 
  .vdac_sbr_e_pcput (  sbr_e_vdac_vintf.mpcput  ), 
  .sbr_e_vdac_npput (  sbr_e_vdac_vintf.tnpput  ), 
  .vdac_sbr_e_npput (  sbr_e_vdac_vintf.mnpput  ), 
  .sbr_e_vdac_eom (  sbr_e_vdac_vintf.teom  ), 
  .vdac_sbr_e_eom (  sbr_e_vdac_vintf.meom  ), 
  .sbr_e_vdac_payload (  sbr_e_vdac_vintf.tpayload  ), 
  .vdac_sbr_e_payload (  sbr_e_vdac_vintf.mpayload  ), 
  .sbr_e_adac_side_ism_fabric ( sbr_e_adac_vintf.side_ism_fabric ),
  .adac_sbr_e_side_ism_agent  ( sbr_e_adac_vintf.side_ism_agent  ),
  .adac_sbr_e_side_clkreq     ( sbr_e_adac_vintf.side_clkreq ),
  .sbr_e_adac_side_clkack     ( sbr_e_adac_vintf.side_clkack ),
  .sbr_e_adac_pccup (  sbr_e_adac_vintf.mpccup  ), 
  .adac_sbr_e_pccup (  sbr_e_adac_vintf.tpccup  ), 
  .sbr_e_adac_npcup (  sbr_e_adac_vintf.mnpcup  ), 
  .adac_sbr_e_npcup (  sbr_e_adac_vintf.tnpcup  ), 
  .sbr_e_adac_pcput (  sbr_e_adac_vintf.tpcput  ), 
  .adac_sbr_e_pcput (  sbr_e_adac_vintf.mpcput  ), 
  .sbr_e_adac_npput (  sbr_e_adac_vintf.tnpput  ), 
  .adac_sbr_e_npput (  sbr_e_adac_vintf.mnpput  ), 
  .sbr_e_adac_eom (  sbr_e_adac_vintf.teom  ), 
  .adac_sbr_e_eom (  sbr_e_adac_vintf.meom  ), 
  .sbr_e_adac_payload (  sbr_e_adac_vintf.tpayload  ), 
  .adac_sbr_e_payload (  sbr_e_adac_vintf.mpayload  ), 
  .sbr_e_hdmi_tx_side_ism_fabric ( sbr_e_hdmi_tx_vintf.side_ism_fabric ),
  .hdmi_tx_sbr_e_side_ism_agent  ( sbr_e_hdmi_tx_vintf.side_ism_agent  ),
  .hdmi_tx_sbr_e_side_clkreq     ( sbr_e_hdmi_tx_vintf.side_clkreq ),
  .sbr_e_hdmi_tx_side_clkack     ( sbr_e_hdmi_tx_vintf.side_clkack ),
  .sbr_e_hdmi_tx_pccup (  sbr_e_hdmi_tx_vintf.mpccup  ), 
  .hdmi_tx_sbr_e_pccup (  sbr_e_hdmi_tx_vintf.tpccup  ), 
  .sbr_e_hdmi_tx_npcup (  sbr_e_hdmi_tx_vintf.mnpcup  ), 
  .hdmi_tx_sbr_e_npcup (  sbr_e_hdmi_tx_vintf.tnpcup  ), 
  .sbr_e_hdmi_tx_pcput (  sbr_e_hdmi_tx_vintf.tpcput  ), 
  .hdmi_tx_sbr_e_pcput (  sbr_e_hdmi_tx_vintf.mpcput  ), 
  .sbr_e_hdmi_tx_npput (  sbr_e_hdmi_tx_vintf.tnpput  ), 
  .hdmi_tx_sbr_e_npput (  sbr_e_hdmi_tx_vintf.mnpput  ), 
  .sbr_e_hdmi_tx_eom (  sbr_e_hdmi_tx_vintf.teom  ), 
  .hdmi_tx_sbr_e_eom (  sbr_e_hdmi_tx_vintf.meom  ), 
  .sbr_e_hdmi_tx_payload (  sbr_e_hdmi_tx_vintf.tpayload  ), 
  .hdmi_tx_sbr_e_payload (  sbr_e_hdmi_tx_vintf.mpayload  ), 
  .sbr_e_hdmi_rx_side_ism_fabric ( sbr_e_hdmi_rx_vintf.side_ism_fabric ),
  .hdmi_rx_sbr_e_side_ism_agent  ( sbr_e_hdmi_rx_vintf.side_ism_agent  ),
  .hdmi_rx_sbr_e_side_clkreq     ( sbr_e_hdmi_rx_vintf.side_clkreq ),
  .sbr_e_hdmi_rx_side_clkack     ( sbr_e_hdmi_rx_vintf.side_clkack ),
  .sbr_e_hdmi_rx_pccup (  sbr_e_hdmi_rx_vintf.mpccup  ), 
  .hdmi_rx_sbr_e_pccup (  sbr_e_hdmi_rx_vintf.tpccup  ), 
  .sbr_e_hdmi_rx_npcup (  sbr_e_hdmi_rx_vintf.mnpcup  ), 
  .hdmi_rx_sbr_e_npcup (  sbr_e_hdmi_rx_vintf.tnpcup  ), 
  .sbr_e_hdmi_rx_pcput (  sbr_e_hdmi_rx_vintf.tpcput  ), 
  .hdmi_rx_sbr_e_pcput (  sbr_e_hdmi_rx_vintf.mpcput  ), 
  .sbr_e_hdmi_rx_npput (  sbr_e_hdmi_rx_vintf.tnpput  ), 
  .hdmi_rx_sbr_e_npput (  sbr_e_hdmi_rx_vintf.mnpput  ), 
  .sbr_e_hdmi_rx_eom (  sbr_e_hdmi_rx_vintf.teom  ), 
  .hdmi_rx_sbr_e_eom (  sbr_e_hdmi_rx_vintf.meom  ), 
  .sbr_e_hdmi_rx_payload (  sbr_e_hdmi_rx_vintf.tpayload  ), 
  .hdmi_rx_sbr_e_payload (  sbr_e_hdmi_rx_vintf.mpayload  ));




  // Communication matrix
  // ====================
  
  // Interface instances
  iosf_sbc_intf #( .PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(1) ) sbr_a_sbr_e_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(1) ) sbr_a_sbr_b_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(1) ) sbr_a_sbr_c_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_a_dpll_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_a_apll_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_a_hpll_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_a_fpll_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_a_punit_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_a_spare_a_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(0) ) sbr_b_sbr_a_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_b_pcie_afe_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_b_sata_afe_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_b_usb_afe_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_b_sata_ctrl_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_b_pcie_ctrl_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_b_psf_1_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_b_spare_b_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(0) ) sbr_c_sbr_a_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(1) ) sbr_c_sbr_d_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_dfx_jtag_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_itunit_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_psf_3_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_spare_c_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_vtunit_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_hunit_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_bunit_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_cunit_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_cpunit_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_legacy_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_dfx_lakemore_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_c_dfx_omar_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(0) ) sbr_d_sbr_c_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_d_mcu_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_d_sec_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_d_ddrio_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_d_reut_0_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_d_reut_1_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_d_spare_d_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #( .PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(0) ) sbr_e_sbr_a_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_e_vdac_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_e_adac_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_e_hdmi_tx_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_e_hdmi_rx_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );


  connect_sbc_intf u_connect_sbr_a_sbr_e ( .agent_if(sbr_a_sbr_e_vintf), .fabric_if(sbr_e_sbr_a_vintf) );
  connect_sbc_intf u_connect_sbr_a_sbr_b ( .agent_if(sbr_a_sbr_b_vintf), .fabric_if(sbr_b_sbr_a_vintf) );
  connect_sbc_intf u_connect_sbr_a_sbr_c ( .agent_if(sbr_a_sbr_c_vintf), .fabric_if(sbr_c_sbr_a_vintf) );
  connect_sbc_intf u_connect_sbr_c_sbr_d ( .agent_if(sbr_c_sbr_d_vintf), .fabric_if(sbr_d_sbr_c_vintf) );


  //Interface Bundle
  svlib_pkg::VintfBundle vintfBundle;
  
  clk_rst_intf u_clk_rst_intf();
  power_intf   u_power_intf();
  comm_intf    u_comm_intf();
  iosf_pmu_intf pmu_sbr2_intf();
  
 
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
  wrapper_agt_32bit = new(sbr_a_sbr_e_vintf);
  vintfBundle.setData ("sbr_a_sbr_e_vintf" , wrapper_agt_32bit);
  wrapper_agt_32bit = new(sbr_a_sbr_b_vintf);
  vintfBundle.setData ("sbr_a_sbr_b_vintf" , wrapper_agt_32bit);
  wrapper_agt_32bit = new(sbr_a_sbr_c_vintf);
  vintfBundle.setData ("sbr_a_sbr_c_vintf" , wrapper_agt_32bit);
  wrapper_agt_8bit = new(sbr_a_dpll_vintf);
  vintfBundle.setData ("sbr_a_dpll_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_a_apll_vintf);
  vintfBundle.setData ("sbr_a_apll_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_a_hpll_vintf);
  vintfBundle.setData ("sbr_a_hpll_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_a_fpll_vintf);
  vintfBundle.setData ("sbr_a_fpll_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_a_punit_vintf);
  vintfBundle.setData ("sbr_a_punit_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_a_spare_a_vintf);
  vintfBundle.setData ("sbr_a_spare_a_vintf" , wrapper_agt_8bit);
  wrapper_fbrc_32bit = new(sbr_b_sbr_a_vintf);
  vintfBundle.setData ("sbr_b_sbr_a_vintf" , wrapper_fbrc_32bit);
  wrapper_agt_8bit = new(sbr_b_pcie_afe_vintf);
  vintfBundle.setData ("sbr_b_pcie_afe_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_b_sata_afe_vintf);
  vintfBundle.setData ("sbr_b_sata_afe_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_b_usb_afe_vintf);
  vintfBundle.setData ("sbr_b_usb_afe_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_b_sata_ctrl_vintf);
  vintfBundle.setData ("sbr_b_sata_ctrl_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_b_pcie_ctrl_vintf);
  vintfBundle.setData ("sbr_b_pcie_ctrl_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_b_psf_1_vintf);
  vintfBundle.setData ("sbr_b_psf_1_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_b_spare_b_vintf);
  vintfBundle.setData ("sbr_b_spare_b_vintf" , wrapper_agt_8bit);
  wrapper_fbrc_32bit = new(sbr_c_sbr_a_vintf);
  vintfBundle.setData ("sbr_c_sbr_a_vintf" , wrapper_fbrc_32bit);
  wrapper_agt_32bit = new(sbr_c_sbr_d_vintf);
  vintfBundle.setData ("sbr_c_sbr_d_vintf" , wrapper_agt_32bit);
  wrapper_agt_8bit = new(sbr_c_dfx_jtag_vintf);
  vintfBundle.setData ("sbr_c_dfx_jtag_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_c_itunit_vintf);
  vintfBundle.setData ("sbr_c_itunit_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_c_psf_3_vintf);
  vintfBundle.setData ("sbr_c_psf_3_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_c_spare_c_vintf);
  vintfBundle.setData ("sbr_c_spare_c_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_c_vtunit_vintf);
  vintfBundle.setData ("sbr_c_vtunit_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_c_hunit_vintf);
  vintfBundle.setData ("sbr_c_hunit_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_c_bunit_vintf);
  vintfBundle.setData ("sbr_c_bunit_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_c_cunit_vintf);
  vintfBundle.setData ("sbr_c_cunit_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_c_cpunit_vintf);
  vintfBundle.setData ("sbr_c_cpunit_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_c_legacy_vintf);
  vintfBundle.setData ("sbr_c_legacy_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_c_dfx_lakemore_vintf);
  vintfBundle.setData ("sbr_c_dfx_lakemore_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_c_dfx_omar_vintf);
  vintfBundle.setData ("sbr_c_dfx_omar_vintf" , wrapper_agt_8bit);
  wrapper_fbrc_32bit = new(sbr_d_sbr_c_vintf);
  vintfBundle.setData ("sbr_d_sbr_c_vintf" , wrapper_fbrc_32bit);
  wrapper_agt_8bit = new(sbr_d_mcu_vintf);
  vintfBundle.setData ("sbr_d_mcu_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_d_sec_vintf);
  vintfBundle.setData ("sbr_d_sec_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_d_ddrio_vintf);
  vintfBundle.setData ("sbr_d_ddrio_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_d_reut_0_vintf);
  vintfBundle.setData ("sbr_d_reut_0_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_d_reut_1_vintf);
  vintfBundle.setData ("sbr_d_reut_1_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_d_spare_d_vintf);
  vintfBundle.setData ("sbr_d_spare_d_vintf" , wrapper_agt_8bit);
  wrapper_fbrc_32bit = new(sbr_e_sbr_a_vintf);
  vintfBundle.setData ("sbr_e_sbr_a_vintf" , wrapper_fbrc_32bit);
  wrapper_agt_8bit = new(sbr_e_vdac_vintf);
  vintfBundle.setData ("sbr_e_vdac_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_e_adac_vintf);
  vintfBundle.setData ("sbr_e_adac_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_e_hdmi_tx_vintf);
  vintfBundle.setData ("sbr_e_hdmi_tx_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_e_hdmi_rx_vintf);
  vintfBundle.setData ("sbr_e_hdmi_rx_vintf" , wrapper_agt_8bit);

assign sbr_a_sbr_e_vintf.side_clkreq = '1;
assign sbr_a_sbr_b_vintf.side_clkreq = '1;
assign sbr_a_sbr_c_vintf.side_clkreq = '1;
assign sbr_b_sbr_a_vintf.side_clkack = '1;
assign sbr_c_sbr_a_vintf.side_clkack = '1;
assign sbr_c_sbr_d_vintf.side_clkreq = '1;
assign sbr_d_sbr_c_vintf.side_clkack = '1;
assign sbr_e_sbr_a_vintf.side_clkack = '1;

 
    wrapper_pwr_intf = new(u_power_intf);
    vintfBundle.setData ("power_intf_i", wrapper_pwr_intf);

    wrapper_comm_intf = new(u_comm_intf);
    vintfBundle.setData ("comm_intf_i", wrapper_comm_intf);

    wrapper_clkrst_intf = new(u_clk_rst_intf);
    vintfBundle.setData ("clk_rst_intf_i", wrapper_clkrst_intf);

    wrapper_vintf_pmu_wrp = new(pmu_sbr2_intf);
    vintfBundle.setData("pmu_sbr2_intf", wrapper_vintf_pmu_wrp);
    set_config_string("*", "iosf_pmu_intf","iosf_pmu_intf_i"); 
    set_config_object("*", "vintf_pmu_wrp", wrapper_vintf_pmu_wrp,0);     

    //Pass config info to the environment
    //pass comm_intf name string
    set_config_string("*", "comm_intf_name", "comm_intf_i");      

    //pass Bundle
    set_config_object("*", SB_VINTF_BUNDLE_NAME, vintfBundle, 0);    

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
      $fsdbDumpvars(0,"tb_lv2_sbn_cfg_9_BVL_pwr");
   end
 `endif
endmodule :tb_lv2_sbn_cfg_9_BVL_pwr

