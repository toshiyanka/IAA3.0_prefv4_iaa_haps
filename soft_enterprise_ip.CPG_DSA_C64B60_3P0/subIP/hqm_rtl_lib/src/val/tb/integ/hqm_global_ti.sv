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

import ovm_pkg::*;
import sla_pkg::*;

import IosfPkg::*;

`ifdef HQM_SFI

`define MY_IOSF_PARAMS   \
   .MMAX_ADDR     (63),  \
   .TMAX_ADDR     (63),  \
   .MD_WIDTH      (255), \
   .TD_WIDTH      (255), \
   .MDP_WIDTH     (0),   \
   .TDP_WIDTH     (0),   \
   .AGENT_WIDTH   (0),   \
   .MNUMCHAN      (2),   \
   .TNUMCHAN      (2),   \
   .MNUMCHANL2    (1),   \
   .TNUMCHANL2    (1),   \
   .SRC_ID_WIDTH  (13),  \
   .DEST_ID_WIDTH (13),  \
   .MAX_DATA_LEN  (9),   \
   .SAI_WIDTH     (7),   \
   .RS_WIDTH      (0)

`else

`define MY_IOSF_PARAMS   \
   .MMAX_ADDR     (63),  \
   .TMAX_ADDR     (63),  \
   .MD_WIDTH      (255), \
   .TD_WIDTH      (255), \
   .MDP_WIDTH     (0),   \
   .TDP_WIDTH     (0),   \
   .AGENT_WIDTH   (0),   \
   .MNUMCHAN      (0),   \
   .TNUMCHAN      (0),   \
   .MNUMCHANL2    (0),   \
   .TNUMCHANL2    (0),   \
   .SRC_ID_WIDTH  (13),  \
   .DEST_ID_WIDTH (13),  \
   .MAX_DATA_LEN  (9),   \
   .SAI_WIDTH     (7),   \
   .RS_WIDTH      (0)

`endif
 
//--------------------------------
//-- hqm_test_island - test island
//-------------------------------- 
module hqm_global_ti #(
        parameter string IP_ENV = "*",
        parameter string IP_RTL_PATH = "",
        parameter IP_PASSIVE = 0,
        parameter IP_CLK_SYNC_ACK = 8,
        parameter IP_EXT_CLKACK = 1,
        parameter IP_PIPE_STAGE = 0
       )
      (
        iosf_primary_intf iosf_fabric_if
      );
   
  `ifdef IP_MID_TE 
  iosf_primary_ti #(
    `MY_IOSF_PARAMS,
    .IS_COMPMON(1),
    .QCOV_EN(`HQM_PVC_FUNC_COV_EN),
    .QCOV_ISM(`HQM_PVC_FUNC_COV_EN),
    .QCOV_CRD(`HQM_PVC_FUNC_COV_EN),
    .QCOV_REQ(`HQM_PVC_FUNC_COV_EN),
    .QCOV_GNT(`HQM_PVC_FUNC_COV_EN),
    .QCOV_MST(`HQM_PVC_FUNC_COV_EN),
    .QCOV_TGT(`HQM_PVC_FUNC_COV_EN),
    .QCOV_DEC(`HQM_PVC_FUNC_COV_EN),
    .QCOV_HIT(`HQM_PVC_FUNC_COV_EN),
    .IS_FABRIC(1),
    .IS_PASSIVE(IP_PASSIVE),
    .CLKACK_SYNC_DELAY(IP_CLK_SYNC_ACK),
    .IS_EXTERNAL_CLKACK(IP_EXT_CLKACK),
    .DEASSERT_CLK_SIGS_DEFAULT(`HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT),
    .PIPELINE_STAGE(IP_PIPE_STAGE)
  ) iosf_fabric_VC (.iosf_primary_intf(iosf_fabric_if));
  `endif  

initial begin
  set_config_string($psprintf("%s", IP_ENV), "HQM_RTL_TOP", IP_RTL_PATH); //rmullick:7.16.18 To set IP_RTL_PATH from hcx_tb_hqm_global_ti_0.sv for HCx OR from hqm_test_island.sv for hqm_agent(standalone). This value will be picked in HqmIntegEnv
     $display("[%0t] HQM_TB_hqm_global_ti: set_config_string", $time);
end

endmodule

