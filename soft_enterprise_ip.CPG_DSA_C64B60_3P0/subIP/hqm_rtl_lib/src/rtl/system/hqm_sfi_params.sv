//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2022 Intel Corporation All Rights Reserved.
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

     parameter int unsigned HQM_SFI_RX_BCM_EN                = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_BLOCK_EARLY_VLD_EN    = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_D                     = 64    // Fixed
    ,parameter int unsigned HQM_SFI_RX_DATA_AUX_PARITY_EN    = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_DATA_CRD_GRAN         = 4     // Fixed
    ,parameter int unsigned HQM_SFI_RX_DATA_INTERLEAVE       = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_DATA_LAYER_EN         = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_DATA_PARITY_EN        = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_DATA_PASS_HDR         = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_DATA_MAX_FC_VC        = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_DS                    = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_ECRC_SUPPORT          = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_FLIT_MODE_PREFIX_EN   = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_FATAL_EN              = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_H                     = 32    // Fixed
    ,parameter int unsigned HQM_SFI_RX_HDR_DATA_SEP          = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_HDR_MAX_FC_VC         = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_HGRAN                 = 4     // Fixed
    ,parameter int unsigned HQM_SFI_RX_HPARITY               = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_IDE_SUPPORT           = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_M                     = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_MAX_CRD_CNT_WIDTH     = 12    // Fixed: Width of agent RX credit counters
    ,parameter int unsigned HQM_SFI_RX_MAX_HDR_WIDTH         = 32    // Fixed
    ,parameter int unsigned HQM_SFI_RX_NDCRD                 = 4     // Fabric data   credit return value width
    ,parameter int unsigned HQM_SFI_RX_NHCRD                 = 4     // Fabric header credit return value width
    ,parameter int unsigned HQM_SFI_RX_NUM_SHARED_POOLS      = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_PCIE_MERGED_SELECT    = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_PCIE_SHARED_SELECT    = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_RBN                   = 3     // Fixed
    ,parameter int unsigned HQM_SFI_RX_SH_DATA_CRD_BLK_SZ    = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_SH_HDR_CRD_BLK_SZ     = 1     // Fixed
    ,parameter int unsigned HQM_SFI_RX_SHARED_CREDIT_EN      = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_TBN                   = 1     // Cycles after agent hdr/data_block is received before fabric TX stalls
    ,parameter int unsigned HQM_SFI_RX_TX_CRD_REG            = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_VIRAL_EN              = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_VR                    = 0     // Fixed
    ,parameter int unsigned HQM_SFI_RX_VT                    = 0     // Fixed

    ,parameter int unsigned HQM_SFI_TX_BCM_EN                = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_BLOCK_EARLY_VLD_EN    = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_D                     = 64    // Fixed
    ,parameter int unsigned HQM_SFI_TX_DATA_AUX_PARITY_EN    = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_DATA_CRD_GRAN         = 4     // Fixed
    ,parameter int unsigned HQM_SFI_TX_DATA_INTERLEAVE       = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_DATA_LAYER_EN         = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_DATA_PARITY_EN        = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_DATA_PASS_HDR         = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_DATA_MAX_FC_VC        = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_DS                    = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_ECRC_SUPPORT          = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_FLIT_MODE_PREFIX_EN   = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_FATAL_EN              = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_H                     = 32    // Fixed
    ,parameter int unsigned HQM_SFI_TX_HDR_DATA_SEP          = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_HDR_MAX_FC_VC         = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_HGRAN                 = 4     // Fixed
    ,parameter int unsigned HQM_SFI_TX_HPARITY               = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_IDE_SUPPORT           = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_M                     = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_MAX_CRD_CNT_WIDTH     = 12    // Width of agent TX credit counters
    ,parameter int unsigned HQM_SFI_TX_MAX_HDR_WIDTH         = 32    // Fixed
    ,parameter int unsigned HQM_SFI_TX_NDCRD                 = 4     // Fabric data   credit return value width
    ,parameter int unsigned HQM_SFI_TX_NHCRD                 = 4     // Fabric header credit return value width
    ,parameter int unsigned HQM_SFI_TX_NUM_SHARED_POOLS      = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_PCIE_MERGED_SELECT    = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_PCIE_SHARED_SELECT    = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_RBN                   = 1     // Cycles after fabric hdr/data_crd_rtn_block is received before agent RX stalls
    ,parameter int unsigned HQM_SFI_TX_SH_DATA_CRD_BLK_SZ    = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_SH_HDR_CRD_BLK_SZ     = 1     // Fixed
    ,parameter int unsigned HQM_SFI_TX_SHARED_CREDIT_EN      = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_TBN                   = 3     // Fixed
    ,parameter int unsigned HQM_SFI_TX_TX_CRD_REG            = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_VIRAL_EN              = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_VR                    = 0     // Fixed
    ,parameter int unsigned HQM_SFI_TX_VT                    = 0     // Fixed
