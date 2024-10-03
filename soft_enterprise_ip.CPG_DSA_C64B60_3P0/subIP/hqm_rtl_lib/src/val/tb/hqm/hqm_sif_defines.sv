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

`ifndef HQM_SIF_DEF_
`define HQM_SIF_DEF_
import hqm_sif_csr_pkg::*;

  // -- HQM SAI STRAP VALUES (default) -- //
  `define HQM_STRAP_CMPL_SAI                8'h_14
  `define HQM_STRAP_TX_SAI                  8'h_b0
  `define HQM_STRAP_ERR_SB_DSTID             'h_0033        
  `define HQM_STRAP_ERR_SB_SAI               'h_0a      
  `define HQM_STRAP_RESETPREP_ACK_SAI        'h_14               
  `define HQM_STRAP_RESETPREP_SAI_0          'h_50           
  `define HQM_STRAP_SOC_VAL_RESETPREP_SAI_0  'h_50           
  `define HQM_STRAP_RESETPREP_SAI_1          'h_12             
  `define HQM_STRAP_FORCE_POK_SAI_0          'h_50             
  `define HQM_STRAP_FORCE_POK_SAI_1          'h_12           
  `define HQM_STRAP_DO_SERR_DSTID            'h_0001         
  `define HQM_STRAP_DO_SERR_TAG              'h_2       
  `define HQM_STRAP_DO_SERR_SAIRS_VALID      'h_01               
  `define HQM_STRAP_DO_SERR_SAI              'h_0a       
  `define HQM_STRAP_DO_SERR_RS               'h_0      
  `define HQM_STRAP_GPSB_SRCID               'h_0021         
  `define HQM_STRAP_16B_PORTIDS             1'b_1
  `define HQM_STRAP_FP_CFG_DSTID             'h_0002         
  `define HQM_STRAP_FP_CFG_READY_DSTID       'h_0004               
  `define HQM_STRAP_FP_CFG_SAI               'h_26      
  `define HQM_STRAP_FP_CFG_SAI_CMPL          'h_24           
  `define HQM_STRAP_FP_CFG_TAG               'h_00      
  `define HQM_STRAP_DEVICE_ID              16'h_2714      
  `define HQM_STRAP_VF_DEVICE_ID           16'h_2715      
  `define HQM_STRAP_CSR_CP                 { HQM_CSR_CP_HI_SAI_MASK_RESET , HQM_CSR_CP_LO_SAI_MASK_RESET }
  `define HQM_STRAP_CSR_RAC                { HQM_CSR_RAC_HI_SAI_MASK_RESET , HQM_CSR_RAC_LO_SAI_MASK_RESET }
  `define HQM_STRAP_CSR_WAC                { HQM_CSR_WAC_HI_SAI_MASK_RESET , HQM_CSR_WAC_LO_SAI_MASK_RESET }
  `define HQM_STRAP_CSR_LOAD                1'b_1
  `define HQM_STRAP_GPSB_SRCID_16B         16'h_2221
  `define HQM_STRAP_FP_CFG_DSTID_16B       16'h_2302
  `define HQM_STRAP_ERR_SB_DSTID_16B       16'h_2433
  `define HQM_STRAP_FP_CFG_READY_DSTID_16B 16'h_2504
  `define HQM_STRAP_DO_SERR_DSTID_16B      16'h_2601
  `define HQM_GPSB_DSTID_16B               16'h_2705
  `define HQM_GPSB_DSTID                   16'h_0028 

  // -- HQM_PF_FUNC_NUM      (default) -- //
  `define HQM_PF_FUNC_NUM      8'h_0

  `define HQM_SUCC_CPL         3'b_000

  // -- HQM_MPS value
  `define HQM_IOSF_MPS_DW     128 // -- It is 128*4 = 512 B -- //

  `include "hqm_pcie_common_defines.sv"

  `define HQM_PRI_PCMD_CREDIT 16 
  `define HQM_PRI_PDATA_CREDIT 48
  `define HQM_PRI_NPCMD_CREDIT 8
  `define HQM_PRI_NPDATA_CREDIT 8 
  `define HQM_PRI_CPLCMD_CREDIT 0 
  `define HQM_PRI_CPLDATA_CREDIT 0

  `define HQM_FBRC_REQ_CREDIT 12

  `define HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT 1
  `define HQM_SB_DEASSERT_CLK_SIGS_DEFAULT 1


  `define HQM_VALID_SAI 8'h_01
  `define HQM_SRC_PID   8'h_01 
  `define HQM_DEST_PID  8'h_21
   `ifdef PVC_QCOV_EN
      `define HQM_PVC_FUNC_COV_EN 1
   `else    
      `define HQM_PVC_FUNC_COV_EN 0
   `endif

`endif
