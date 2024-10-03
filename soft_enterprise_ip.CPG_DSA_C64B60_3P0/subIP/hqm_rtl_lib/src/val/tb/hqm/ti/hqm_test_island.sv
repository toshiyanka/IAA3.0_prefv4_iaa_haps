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
//-- tb_top
//-----------------------------------------------------------------------------------------------------

import hqm_AW_pkg::*;
import hqm_pkg::*;
import nu_ecc_pkg::*;

import ovm_pkg::*;
import sla_pkg::*;
//import hcw_pkg::*; 
import IosfPkg::*;
//import JtagBfmPkg::*;

`timescale 1ns/1ps

//--------------------------------
//-- hqm_test_island - test island
//-------------------------------- 
module hqm_test_island #(
        parameter string IP_ENV = "*",
        parameter string IP_SUFIX = "",
        parameter string IP_RTL_PATH = "",

        `include "hqm_iosf_params_global.vh"
        ,
        `include "hqm_iosfsb_params_global.vh"
) (
        hqm_misc_if            hqm_vintf,
        iosf_primary_intf iosf_fabric_if,
        iosf_sbc_intf iosf_sbc_fabric_if,
        hqm_reset_if           i_reset_if
        //JtagBfmIntf            i_jtagbfm_if
);

   initial begin `sla_add_db_and_cfg(hqm_vintf,virtual hqm_misc_if,$psprintf("%m.SYSTEM_IF"),{IP_ENV, "*"},"hqm_misc_if_handle");
   end

   initial begin `sla_add_db_and_cfg(i_reset_if,virtual hqm_reset_if,$psprintf("%m.RESET_IF"),{IP_ENV, "*"},"reset_if_handle");
   end


//  iosf_primary_ti #(
//    `MY_IOSF_PARAMS,
//    .IS_COMPMON(1),
//    .IS_FABRIC(1),
//    .IS_PASSIVE(0),
//    .PIPELINE_STAGE(0)
//  ) iosf_fabric_VC (.iosf_primary_intf(iosf_fabric_if));

   // Going to use the hqm_global_ti here which just
   // has the same iosf_primary_ti inside it becasue this is
   // re-used at SS so we catch any integrations issues early
    hqm_global_ti #(.IP_EXT_CLKACK(0),
                    .IP_RTL_PATH("hqm_tb_top.u_hqm") //rmullick: 7/25/2018 setting default path to "hqm_tb_top.u_hqm" for hqm_agent, which gets passed into hqm_global_ti
       ) hqm_global_ti
      (
        .iosf_fabric_if(iosf_fabric_if)
      );

  iosf_sb_ti # (
    .PAYLOAD_WIDTH(8),
    .AGENT_MASTERING_SB_IF(0),
    .IS_COMPMON(1),
    .CLKACK_SYNC_DELAY(4),
    .INTF_NAME("iosf_sbc_fabric_if"),
    .DEASSERT_CLK_SIGS_DEFAULT(`HQM_SB_DEASSERT_CLK_SIGS_DEFAULT)
    ) fab_ti (
      .iosf_sbc_intf(iosf_sbc_fabric_if)
    );

    //hqm_backdoor_mem_if #(
    //  .IP_ENV(IP_ENV),
    //  .IP_SUFIX(IP_SUFIX),
    //  .IP_RTL_PATH(IP_RTL_PATH)
    //) hqm_backdoor_mem_intf()

endmodule

