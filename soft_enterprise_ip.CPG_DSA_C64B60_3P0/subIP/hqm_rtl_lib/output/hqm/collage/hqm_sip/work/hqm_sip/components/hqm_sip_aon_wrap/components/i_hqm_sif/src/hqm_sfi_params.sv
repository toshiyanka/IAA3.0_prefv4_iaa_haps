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

     // Name:         HQM_SFI_RX_BCM_EN
     // Default:      1
     // Values:       -2147483648, ..., 2147483647
     parameter HQM_SFI_RX_BCM_EN = 1,
// Name:         HQM_SFI_RX_BLOCK_EARLY_VLD_EN
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_BLOCK_EARLY_VLD_EN = 1,
// Name:         HQM_SFI_RX_D
// Default:      32
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_D = 32,
// Name:         HQM_SFI_RX_DATA_AUX_PARITY_EN
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_DATA_AUX_PARITY_EN = 1,
// Name:         HQM_SFI_RX_DATA_CRD_GRAN
// Default:      4
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_DATA_CRD_GRAN = 4,
// Name:         HQM_SFI_RX_DATA_INTERLEAVE
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_DATA_INTERLEAVE = 0,
// Name:         HQM_SFI_RX_DATA_LAYER_EN
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_DATA_LAYER_EN = 1,
// Name:         HQM_SFI_RX_DATA_PARITY_EN
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_DATA_PARITY_EN = 1,
// Name:         HQM_SFI_RX_DATA_PASS_HDR
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_DATA_PASS_HDR = 0,
// Name:         HQM_SFI_RX_DATA_MAX_FC_VC
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_DATA_MAX_FC_VC = 1,
// Name:         HQM_SFI_RX_DS
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_DS = 1,
// Name:         HQM_SFI_RX_ECRC_SUPPORT
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_ECRC_SUPPORT = 0,
// Name:         HQM_SFI_RX_FLIT_MODE_PREFIX_EN
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_FLIT_MODE_PREFIX_EN = 0,
// Name:         HQM_SFI_RX_FATAL_EN
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_FATAL_EN = 0,
// Name:         HQM_SFI_RX_H
// Default:      32
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_H = 32,
// Name:         HQM_SFI_RX_HDR_DATA_SEP
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_HDR_DATA_SEP = 1,
// Name:         HQM_SFI_RX_HDR_MAX_FC_VC
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_HDR_MAX_FC_VC = 1,
// Name:         HQM_SFI_RX_HGRAN
// Default:      4
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_HGRAN = 4,
// Name:         HQM_SFI_RX_HPARITY
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_HPARITY = 1,
// Name:         HQM_SFI_RX_IDE_SUPPORT
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_IDE_SUPPORT = 0,
// Name:         HQM_SFI_RX_M
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_M = 1,
// Name:         HQM_SFI_RX_MAX_CRD_CNT_WIDTH
// Default:      12
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_MAX_CRD_CNT_WIDTH = 12,
// Name:         HQM_SFI_RX_MAX_HDR_WIDTH
// Default:      32
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_MAX_HDR_WIDTH = 32,
// Name:         HQM_SFI_RX_NDCRD
// Default:      4
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_NDCRD = 4,
// Name:         HQM_SFI_RX_NHCRD
// Default:      4
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_NHCRD = 4,
// Name:         HQM_SFI_RX_NUM_SHARED_POOLS
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_NUM_SHARED_POOLS = 0,
// Name:         HQM_SFI_RX_PCIE_MERGED_SELECT
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_PCIE_MERGED_SELECT = 0,
// Name:         HQM_SFI_RX_PCIE_SHARED_SELECT
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_PCIE_SHARED_SELECT = 0,
// Name:         HQM_SFI_RX_RBN
// Default:      3
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_RBN = 3,
// Name:         HQM_SFI_RX_SH_DATA_CRD_BLK_SZ
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_SH_DATA_CRD_BLK_SZ = 1,
// Name:         HQM_SFI_RX_SH_HDR_CRD_BLK_SZ
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_SH_HDR_CRD_BLK_SZ = 1,
// Name:         HQM_SFI_RX_SHARED_CREDIT_EN
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_SHARED_CREDIT_EN = 0,
// Name:         HQM_SFI_RX_TBN
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_TBN = 1,
// Name:         HQM_SFI_RX_TX_CRD_REG
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_TX_CRD_REG = 1,
// Name:         HQM_SFI_RX_VIRAL_EN
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_VIRAL_EN = 0,
// Name:         HQM_SFI_RX_VR
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_VR = 0,
// Name:         HQM_SFI_RX_VT
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_RX_VT = 0,
// Name:         HQM_SFI_TX_BCM_EN
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_BCM_EN = 1,
// Name:         HQM_SFI_TX_BLOCK_EARLY_VLD_EN
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_BLOCK_EARLY_VLD_EN = 1,
// Name:         HQM_SFI_TX_D
// Default:      32
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_D = 32,
// Name:         HQM_SFI_TX_DATA_AUX_PARITY_EN
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_DATA_AUX_PARITY_EN = 1,
// Name:         HQM_SFI_TX_DATA_CRD_GRAN
// Default:      4
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_DATA_CRD_GRAN = 4,
// Name:         HQM_SFI_TX_DATA_INTERLEAVE
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_DATA_INTERLEAVE = 0,
// Name:         HQM_SFI_TX_DATA_LAYER_EN
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_DATA_LAYER_EN = 1,
// Name:         HQM_SFI_TX_DATA_PARITY_EN
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_DATA_PARITY_EN = 1,
// Name:         HQM_SFI_TX_DATA_PASS_HDR
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_DATA_PASS_HDR = 0,
// Name:         HQM_SFI_TX_DATA_MAX_FC_VC
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_DATA_MAX_FC_VC = 1,
// Name:         HQM_SFI_TX_DS
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_DS = 1,
// Name:         HQM_SFI_TX_ECRC_SUPPORT
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_ECRC_SUPPORT = 0,
// Name:         HQM_SFI_TX_FLIT_MODE_PREFIX_EN
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_FLIT_MODE_PREFIX_EN = 0,
// Name:         HQM_SFI_TX_FATAL_EN
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_FATAL_EN = 0,
// Name:         HQM_SFI_TX_H
// Default:      32
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_H = 32,
// Name:         HQM_SFI_TX_HDR_DATA_SEP
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_HDR_DATA_SEP = 0,
// Name:         HQM_SFI_TX_HDR_MAX_FC_VC
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_HDR_MAX_FC_VC = 1,
// Name:         HQM_SFI_TX_HGRAN
// Default:      4
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_HGRAN = 4,
// Name:         HQM_SFI_TX_HPARITY
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_HPARITY = 1,
// Name:         HQM_SFI_TX_IDE_SUPPORT
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_IDE_SUPPORT = 0,
// Name:         HQM_SFI_TX_M
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_M = 1,
// Name:         HQM_SFI_TX_MAX_CRD_CNT_WIDTH
// Default:      12
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_MAX_CRD_CNT_WIDTH = 12,
// Name:         HQM_SFI_TX_MAX_HDR_WIDTH
// Default:      32
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_MAX_HDR_WIDTH = 32,
// Name:         HQM_SFI_TX_NDCRD
// Default:      4
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_NDCRD = 4,
// Name:         HQM_SFI_TX_NHCRD
// Default:      4
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_NHCRD = 4,
// Name:         HQM_SFI_TX_NUM_SHARED_POOLS
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_NUM_SHARED_POOLS = 0,
// Name:         HQM_SFI_TX_PCIE_MERGED_SELECT
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_PCIE_MERGED_SELECT = 0,
// Name:         HQM_SFI_TX_PCIE_SHARED_SELECT
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_PCIE_SHARED_SELECT = 0,
// Name:         HQM_SFI_TX_RBN
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_RBN = 1,
// Name:         HQM_SFI_TX_SH_DATA_CRD_BLK_SZ
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_SH_DATA_CRD_BLK_SZ = 1,
// Name:         HQM_SFI_TX_SH_HDR_CRD_BLK_SZ
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_SH_HDR_CRD_BLK_SZ = 1,
// Name:         HQM_SFI_TX_SHARED_CREDIT_EN
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_SHARED_CREDIT_EN = 0,
// Name:         HQM_SFI_TX_TBN
// Default:      3
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_TBN = 3,
// Name:         HQM_SFI_TX_TX_CRD_REG
// Default:      1
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_TX_CRD_REG = 1,
// Name:         HQM_SFI_TX_VIRAL_EN
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_VIRAL_EN = 0,
// Name:         HQM_SFI_TX_VR
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_VR = 0,
// Name:         HQM_SFI_TX_VT
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_SFI_TX_VT = 0
