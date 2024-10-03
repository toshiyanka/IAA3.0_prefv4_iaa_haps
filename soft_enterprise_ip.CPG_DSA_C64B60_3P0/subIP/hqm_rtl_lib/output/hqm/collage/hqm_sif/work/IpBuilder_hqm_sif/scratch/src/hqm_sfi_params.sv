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

     // reuse-pragma startSub HQM_SFI_RX_BCM_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_BCM_EN -endTok , -indent "     "]
     parameter HQM_SFI_RX_BCM_EN                = 1     // Fixed
    ,
     // reuse-pragma endSub HQM_SFI_RX_BCM_EN
     // reuse-pragma startSub HQM_SFI_RX_BLOCK_EARLY_VLD_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_BLOCK_EARLY_VLD_EN -endTok , -indent ""]
parameter HQM_SFI_RX_BLOCK_EARLY_VLD_EN    = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_BLOCK_EARLY_VLD_EN
// reuse-pragma startSub HQM_SFI_RX_D [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_D -endTok , -indent ""]
parameter HQM_SFI_RX_D                     = 32    // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_D
// reuse-pragma startSub HQM_SFI_RX_DATA_AUX_PARITY_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_DATA_AUX_PARITY_EN -endTok , -indent ""]
parameter HQM_SFI_RX_DATA_AUX_PARITY_EN    = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_DATA_AUX_PARITY_EN
// reuse-pragma startSub HQM_SFI_RX_DATA_CRD_GRAN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_DATA_CRD_GRAN -endTok , -indent ""]
parameter HQM_SFI_RX_DATA_CRD_GRAN         = 4     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_DATA_CRD_GRAN
// reuse-pragma startSub HQM_SFI_RX_DATA_INTERLEAVE [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_DATA_INTERLEAVE -endTok , -indent ""]
parameter HQM_SFI_RX_DATA_INTERLEAVE       = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_DATA_INTERLEAVE
// reuse-pragma startSub HQM_SFI_RX_DATA_LAYER_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_DATA_LAYER_EN -endTok , -indent ""]
parameter HQM_SFI_RX_DATA_LAYER_EN         = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_DATA_LAYER_EN
// reuse-pragma startSub HQM_SFI_RX_DATA_PARITY_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_DATA_PARITY_EN -endTok , -indent ""]
parameter HQM_SFI_RX_DATA_PARITY_EN        = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_DATA_PARITY_EN
// reuse-pragma startSub HQM_SFI_RX_DATA_PASS_HDR [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_DATA_PASS_HDR -endTok , -indent ""]
parameter HQM_SFI_RX_DATA_PASS_HDR         = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_DATA_PASS_HDR
// reuse-pragma startSub HQM_SFI_RX_DATA_MAX_FC_VC [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_DATA_MAX_FC_VC -endTok , -indent ""]
parameter HQM_SFI_RX_DATA_MAX_FC_VC        = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_DATA_MAX_FC_VC
// reuse-pragma startSub HQM_SFI_RX_DS [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_DS -endTok , -indent ""]
parameter HQM_SFI_RX_DS                    = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_DS
// reuse-pragma startSub HQM_SFI_RX_ECRC_SUPPORT [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_ECRC_SUPPORT -endTok , -indent ""]
parameter HQM_SFI_RX_ECRC_SUPPORT          = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_ECRC_SUPPORT
// reuse-pragma startSub HQM_SFI_RX_FLIT_MODE_PREFIX_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_FLIT_MODE_PREFIX_EN -endTok , -indent ""]
parameter HQM_SFI_RX_FLIT_MODE_PREFIX_EN   = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_FLIT_MODE_PREFIX_EN
// reuse-pragma startSub HQM_SFI_RX_FATAL_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_FATAL_EN -endTok , -indent ""]
parameter HQM_SFI_RX_FATAL_EN              = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_FATAL_EN
// reuse-pragma startSub HQM_SFI_RX_H [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_H -endTok , -indent ""]
parameter HQM_SFI_RX_H                     = 32    // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_H
// reuse-pragma startSub HQM_SFI_RX_HDR_DATA_SEP [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_HDR_DATA_SEP -endTok , -indent ""]
parameter HQM_SFI_RX_HDR_DATA_SEP          = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_HDR_DATA_SEP
// reuse-pragma startSub HQM_SFI_RX_HDR_MAX_FC_VC [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_HDR_MAX_FC_VC -endTok , -indent ""]
parameter HQM_SFI_RX_HDR_MAX_FC_VC         = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_HDR_MAX_FC_VC
// reuse-pragma startSub HQM_SFI_RX_HGRAN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_HGRAN -endTok , -indent ""]
parameter HQM_SFI_RX_HGRAN                 = 4     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_HGRAN
// reuse-pragma startSub HQM_SFI_RX_HPARITY [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_HPARITY -endTok , -indent ""]
parameter HQM_SFI_RX_HPARITY               = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_HPARITY
// reuse-pragma startSub HQM_SFI_RX_IDE_SUPPORT [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_IDE_SUPPORT -endTok , -indent ""]
parameter HQM_SFI_RX_IDE_SUPPORT           = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_IDE_SUPPORT
// reuse-pragma startSub HQM_SFI_RX_M [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_M -endTok , -indent ""]
parameter HQM_SFI_RX_M                     = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_M
// reuse-pragma startSub HQM_SFI_RX_MAX_CRD_CNT_WIDTH [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_MAX_CRD_CNT_WIDTH -endTok , -indent ""]
parameter HQM_SFI_RX_MAX_CRD_CNT_WIDTH     = 12    // Fixed: Width of agent RX credit counters
    ,
// reuse-pragma endSub HQM_SFI_RX_MAX_CRD_CNT_WIDTH
// reuse-pragma startSub HQM_SFI_RX_MAX_HDR_WIDTH [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_MAX_HDR_WIDTH -endTok , -indent ""]
parameter HQM_SFI_RX_MAX_HDR_WIDTH         = 32    // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_MAX_HDR_WIDTH
// reuse-pragma startSub HQM_SFI_RX_NDCRD [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_NDCRD -endTok , -indent ""]
parameter HQM_SFI_RX_NDCRD                 = 4     // Fabric data   credit return value width
    ,
// reuse-pragma endSub HQM_SFI_RX_NDCRD
// reuse-pragma startSub HQM_SFI_RX_NHCRD [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_NHCRD -endTok , -indent ""]
parameter HQM_SFI_RX_NHCRD                 = 4     // Fabric header credit return value width
    ,
// reuse-pragma endSub HQM_SFI_RX_NHCRD
// reuse-pragma startSub HQM_SFI_RX_NUM_SHARED_POOLS [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_NUM_SHARED_POOLS -endTok , -indent ""]
parameter HQM_SFI_RX_NUM_SHARED_POOLS      = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_NUM_SHARED_POOLS
// reuse-pragma startSub HQM_SFI_RX_PCIE_MERGED_SELECT [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_PCIE_MERGED_SELECT -endTok , -indent ""]
parameter HQM_SFI_RX_PCIE_MERGED_SELECT    = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_PCIE_MERGED_SELECT
// reuse-pragma startSub HQM_SFI_RX_PCIE_SHARED_SELECT [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_PCIE_SHARED_SELECT -endTok , -indent ""]
parameter HQM_SFI_RX_PCIE_SHARED_SELECT    = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_PCIE_SHARED_SELECT
// reuse-pragma startSub HQM_SFI_RX_RBN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_RBN -endTok , -indent ""]
parameter HQM_SFI_RX_RBN                   = 3     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_RBN
// reuse-pragma startSub HQM_SFI_RX_SH_DATA_CRD_BLK_SZ [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_SH_DATA_CRD_BLK_SZ -endTok , -indent ""]
parameter HQM_SFI_RX_SH_DATA_CRD_BLK_SZ    = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_SH_DATA_CRD_BLK_SZ
// reuse-pragma startSub HQM_SFI_RX_SH_HDR_CRD_BLK_SZ [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_SH_HDR_CRD_BLK_SZ -endTok , -indent ""]
parameter HQM_SFI_RX_SH_HDR_CRD_BLK_SZ     = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_SH_HDR_CRD_BLK_SZ
// reuse-pragma startSub HQM_SFI_RX_SHARED_CREDIT_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_SHARED_CREDIT_EN -endTok , -indent ""]
parameter HQM_SFI_RX_SHARED_CREDIT_EN      = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_SHARED_CREDIT_EN
// reuse-pragma startSub HQM_SFI_RX_TBN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_TBN -endTok , -indent ""]
parameter HQM_SFI_RX_TBN                   = 1     // Cycles after agent hdr/data_block is received before fabric TX stalls
    ,
// reuse-pragma endSub HQM_SFI_RX_TBN
// reuse-pragma startSub HQM_SFI_RX_TX_CRD_REG [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_TX_CRD_REG -endTok , -indent ""]
parameter HQM_SFI_RX_TX_CRD_REG            = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_TX_CRD_REG
// reuse-pragma startSub HQM_SFI_RX_VIRAL_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_VIRAL_EN -endTok , -indent ""]
parameter HQM_SFI_RX_VIRAL_EN              = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_VIRAL_EN
// reuse-pragma startSub HQM_SFI_RX_VR [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_VR -endTok , -indent ""]
parameter HQM_SFI_RX_VR                    = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_RX_VR
// reuse-pragma startSub HQM_SFI_RX_VT [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_RX_VT -endTok , -indent ""]
parameter HQM_SFI_RX_VT                    = 0     // Fixed

    ,
// reuse-pragma endSub HQM_SFI_RX_VT
// reuse-pragma startSub HQM_SFI_TX_BCM_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_BCM_EN -endTok , -indent ""]
parameter HQM_SFI_TX_BCM_EN                = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_BCM_EN
// reuse-pragma startSub HQM_SFI_TX_BLOCK_EARLY_VLD_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_BLOCK_EARLY_VLD_EN -endTok , -indent ""]
parameter HQM_SFI_TX_BLOCK_EARLY_VLD_EN    = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_BLOCK_EARLY_VLD_EN
// reuse-pragma startSub HQM_SFI_TX_D [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_D -endTok , -indent ""]
parameter HQM_SFI_TX_D                     = 32    // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_D
// reuse-pragma startSub HQM_SFI_TX_DATA_AUX_PARITY_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_DATA_AUX_PARITY_EN -endTok , -indent ""]
parameter HQM_SFI_TX_DATA_AUX_PARITY_EN    = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_DATA_AUX_PARITY_EN
// reuse-pragma startSub HQM_SFI_TX_DATA_CRD_GRAN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_DATA_CRD_GRAN -endTok , -indent ""]
parameter HQM_SFI_TX_DATA_CRD_GRAN         = 4     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_DATA_CRD_GRAN
// reuse-pragma startSub HQM_SFI_TX_DATA_INTERLEAVE [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_DATA_INTERLEAVE -endTok , -indent ""]
parameter HQM_SFI_TX_DATA_INTERLEAVE       = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_DATA_INTERLEAVE
// reuse-pragma startSub HQM_SFI_TX_DATA_LAYER_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_DATA_LAYER_EN -endTok , -indent ""]
parameter HQM_SFI_TX_DATA_LAYER_EN         = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_DATA_LAYER_EN
// reuse-pragma startSub HQM_SFI_TX_DATA_PARITY_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_DATA_PARITY_EN -endTok , -indent ""]
parameter HQM_SFI_TX_DATA_PARITY_EN        = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_DATA_PARITY_EN
// reuse-pragma startSub HQM_SFI_TX_DATA_PASS_HDR [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_DATA_PASS_HDR -endTok , -indent ""]
parameter HQM_SFI_TX_DATA_PASS_HDR         = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_DATA_PASS_HDR
// reuse-pragma startSub HQM_SFI_TX_DATA_MAX_FC_VC [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_DATA_MAX_FC_VC -endTok , -indent ""]
parameter HQM_SFI_TX_DATA_MAX_FC_VC        = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_DATA_MAX_FC_VC
// reuse-pragma startSub HQM_SFI_TX_DS [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_DS -endTok , -indent ""]
parameter HQM_SFI_TX_DS                    = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_DS
// reuse-pragma startSub HQM_SFI_TX_ECRC_SUPPORT [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_ECRC_SUPPORT -endTok , -indent ""]
parameter HQM_SFI_TX_ECRC_SUPPORT          = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_ECRC_SUPPORT
// reuse-pragma startSub HQM_SFI_TX_FLIT_MODE_PREFIX_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_FLIT_MODE_PREFIX_EN -endTok , -indent ""]
parameter HQM_SFI_TX_FLIT_MODE_PREFIX_EN   = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_FLIT_MODE_PREFIX_EN
// reuse-pragma startSub HQM_SFI_TX_FATAL_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_FATAL_EN -endTok , -indent ""]
parameter HQM_SFI_TX_FATAL_EN              = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_FATAL_EN
// reuse-pragma startSub HQM_SFI_TX_H [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_H -endTok , -indent ""]
parameter HQM_SFI_TX_H                     = 32    // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_H
// reuse-pragma startSub HQM_SFI_TX_HDR_DATA_SEP [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_HDR_DATA_SEP -endTok , -indent ""]
parameter HQM_SFI_TX_HDR_DATA_SEP          = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_HDR_DATA_SEP
// reuse-pragma startSub HQM_SFI_TX_HDR_MAX_FC_VC [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_HDR_MAX_FC_VC -endTok , -indent ""]
parameter HQM_SFI_TX_HDR_MAX_FC_VC         = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_HDR_MAX_FC_VC
// reuse-pragma startSub HQM_SFI_TX_HGRAN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_HGRAN -endTok , -indent ""]
parameter HQM_SFI_TX_HGRAN                 = 4     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_HGRAN
// reuse-pragma startSub HQM_SFI_TX_HPARITY [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_HPARITY -endTok , -indent ""]
parameter HQM_SFI_TX_HPARITY               = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_HPARITY
// reuse-pragma startSub HQM_SFI_TX_IDE_SUPPORT [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_IDE_SUPPORT -endTok , -indent ""]
parameter HQM_SFI_TX_IDE_SUPPORT           = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_IDE_SUPPORT
// reuse-pragma startSub HQM_SFI_TX_M [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_M -endTok , -indent ""]
parameter HQM_SFI_TX_M                     = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_M
// reuse-pragma startSub HQM_SFI_TX_MAX_CRD_CNT_WIDTH [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_MAX_CRD_CNT_WIDTH -endTok , -indent ""]
parameter HQM_SFI_TX_MAX_CRD_CNT_WIDTH     = 12    // Width of agent TX credit counters
    ,
// reuse-pragma endSub HQM_SFI_TX_MAX_CRD_CNT_WIDTH
// reuse-pragma startSub HQM_SFI_TX_MAX_HDR_WIDTH [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_MAX_HDR_WIDTH -endTok , -indent ""]
parameter HQM_SFI_TX_MAX_HDR_WIDTH         = 32    // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_MAX_HDR_WIDTH
// reuse-pragma startSub HQM_SFI_TX_NDCRD [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_NDCRD -endTok , -indent ""]
parameter HQM_SFI_TX_NDCRD                 = 4     // Fabric data   credit return value width
    ,
// reuse-pragma endSub HQM_SFI_TX_NDCRD
// reuse-pragma startSub HQM_SFI_TX_NHCRD [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_NHCRD -endTok , -indent ""]
parameter HQM_SFI_TX_NHCRD                 = 4     // Fabric header credit return value width
    ,
// reuse-pragma endSub HQM_SFI_TX_NHCRD
// reuse-pragma startSub HQM_SFI_TX_NUM_SHARED_POOLS [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_NUM_SHARED_POOLS -endTok , -indent ""]
parameter HQM_SFI_TX_NUM_SHARED_POOLS      = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_NUM_SHARED_POOLS
// reuse-pragma startSub HQM_SFI_TX_PCIE_MERGED_SELECT [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_PCIE_MERGED_SELECT -endTok , -indent ""]
parameter HQM_SFI_TX_PCIE_MERGED_SELECT    = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_PCIE_MERGED_SELECT
// reuse-pragma startSub HQM_SFI_TX_PCIE_SHARED_SELECT [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_PCIE_SHARED_SELECT -endTok , -indent ""]
parameter HQM_SFI_TX_PCIE_SHARED_SELECT    = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_PCIE_SHARED_SELECT
// reuse-pragma startSub HQM_SFI_TX_RBN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_RBN -endTok , -indent ""]
parameter HQM_SFI_TX_RBN                   = 1     // Cycles after fabric hdr/data_crd_rtn_block is received before agent RX stalls
    ,
// reuse-pragma endSub HQM_SFI_TX_RBN
// reuse-pragma startSub HQM_SFI_TX_SH_DATA_CRD_BLK_SZ [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_SH_DATA_CRD_BLK_SZ -endTok , -indent ""]
parameter HQM_SFI_TX_SH_DATA_CRD_BLK_SZ    = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_SH_DATA_CRD_BLK_SZ
// reuse-pragma startSub HQM_SFI_TX_SH_HDR_CRD_BLK_SZ [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_SH_HDR_CRD_BLK_SZ -endTok , -indent ""]
parameter HQM_SFI_TX_SH_HDR_CRD_BLK_SZ     = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_SH_HDR_CRD_BLK_SZ
// reuse-pragma startSub HQM_SFI_TX_SHARED_CREDIT_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_SHARED_CREDIT_EN -endTok , -indent ""]
parameter HQM_SFI_TX_SHARED_CREDIT_EN      = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_SHARED_CREDIT_EN
// reuse-pragma startSub HQM_SFI_TX_TBN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_TBN -endTok , -indent ""]
parameter HQM_SFI_TX_TBN                   = 3     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_TBN
// reuse-pragma startSub HQM_SFI_TX_TX_CRD_REG [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_TX_CRD_REG -endTok , -indent ""]
parameter HQM_SFI_TX_TX_CRD_REG            = 1     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_TX_CRD_REG
// reuse-pragma startSub HQM_SFI_TX_VIRAL_EN [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_VIRAL_EN -endTok , -indent ""]
parameter HQM_SFI_TX_VIRAL_EN              = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_VIRAL_EN
// reuse-pragma startSub HQM_SFI_TX_VR [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_VR -endTok , -indent ""]
parameter HQM_SFI_TX_VR                    = 0     // Fixed
    ,
// reuse-pragma endSub HQM_SFI_TX_VR
// reuse-pragma startSub HQM_SFI_TX_VT [ReplaceParameter -design hqm_sif -lib work -format systemverilog HQM_SFI_TX_VT -endTok "" -indent ""]
parameter HQM_SFI_TX_VT                    = 0     // Fixed

// reuse-pragma endSub HQM_SFI_TX_VT
