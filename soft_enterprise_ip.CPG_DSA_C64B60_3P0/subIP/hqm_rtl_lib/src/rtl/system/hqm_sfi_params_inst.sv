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

     .HQM_SFI_RX_BCM_EN                 (HQM_SFI_RX_BCM_EN)
    ,.HQM_SFI_RX_BLOCK_EARLY_VLD_EN     (HQM_SFI_RX_BLOCK_EARLY_VLD_EN)
    ,.HQM_SFI_RX_D                      (HQM_SFI_RX_D)
    ,.HQM_SFI_RX_DATA_AUX_PARITY_EN     (HQM_SFI_RX_DATA_AUX_PARITY_EN)
    ,.HQM_SFI_RX_DATA_CRD_GRAN          (HQM_SFI_RX_DATA_CRD_GRAN)
    ,.HQM_SFI_RX_DATA_INTERLEAVE        (HQM_SFI_RX_DATA_INTERLEAVE)
    ,.HQM_SFI_RX_DATA_LAYER_EN          (HQM_SFI_RX_DATA_LAYER_EN)
    ,.HQM_SFI_RX_DATA_PARITY_EN         (HQM_SFI_RX_DATA_PARITY_EN)
    ,.HQM_SFI_RX_DATA_PASS_HDR          (HQM_SFI_RX_DATA_PASS_HDR)
    ,.HQM_SFI_RX_DATA_MAX_FC_VC         (HQM_SFI_RX_DATA_MAX_FC_VC)
    ,.HQM_SFI_RX_DS                     (HQM_SFI_RX_DS)
    ,.HQM_SFI_RX_ECRC_SUPPORT           (HQM_SFI_RX_ECRC_SUPPORT)
    ,.HQM_SFI_RX_FLIT_MODE_PREFIX_EN    (HQM_SFI_RX_FLIT_MODE_PREFIX_EN)
    ,.HQM_SFI_RX_FATAL_EN               (HQM_SFI_RX_FATAL_EN)
    ,.HQM_SFI_RX_H                      (HQM_SFI_RX_H)
    ,.HQM_SFI_RX_HDR_DATA_SEP           (HQM_SFI_RX_HDR_DATA_SEP)
    ,.HQM_SFI_RX_HDR_MAX_FC_VC          (HQM_SFI_RX_HDR_MAX_FC_VC)
    ,.HQM_SFI_RX_HGRAN                  (HQM_SFI_RX_HGRAN)
    ,.HQM_SFI_RX_HPARITY                (HQM_SFI_RX_HPARITY)
    ,.HQM_SFI_RX_IDE_SUPPORT            (HQM_SFI_RX_IDE_SUPPORT)
    ,.HQM_SFI_RX_M                      (HQM_SFI_RX_M)
    ,.HQM_SFI_RX_MAX_CRD_CNT_WIDTH      (HQM_SFI_RX_MAX_CRD_CNT_WIDTH)
    ,.HQM_SFI_RX_MAX_HDR_WIDTH          (HQM_SFI_RX_MAX_HDR_WIDTH)
    ,.HQM_SFI_RX_NDCRD                  (HQM_SFI_RX_NDCRD)
    ,.HQM_SFI_RX_NHCRD                  (HQM_SFI_RX_NHCRD)
    ,.HQM_SFI_RX_NUM_SHARED_POOLS       (HQM_SFI_RX_NUM_SHARED_POOLS)
    ,.HQM_SFI_RX_PCIE_MERGED_SELECT     (HQM_SFI_RX_PCIE_MERGED_SELECT)
    ,.HQM_SFI_RX_PCIE_SHARED_SELECT     (HQM_SFI_RX_PCIE_SHARED_SELECT)
    ,.HQM_SFI_RX_RBN                    (HQM_SFI_RX_RBN)
    ,.HQM_SFI_RX_SH_DATA_CRD_BLK_SZ     (HQM_SFI_RX_SH_DATA_CRD_BLK_SZ)
    ,.HQM_SFI_RX_SH_HDR_CRD_BLK_SZ      (HQM_SFI_RX_SH_HDR_CRD_BLK_SZ)
    ,.HQM_SFI_RX_SHARED_CREDIT_EN       (HQM_SFI_RX_SHARED_CREDIT_EN)
    ,.HQM_SFI_RX_TBN                    (HQM_SFI_RX_TBN)
    ,.HQM_SFI_RX_TX_CRD_REG             (HQM_SFI_RX_TX_CRD_REG)
    ,.HQM_SFI_RX_VIRAL_EN               (HQM_SFI_RX_VIRAL_EN)
    ,.HQM_SFI_RX_VR                     (HQM_SFI_RX_VR)
    ,.HQM_SFI_RX_VT                     (HQM_SFI_RX_VT)

    ,.HQM_SFI_TX_BCM_EN                 (HQM_SFI_TX_BCM_EN)
    ,.HQM_SFI_TX_BLOCK_EARLY_VLD_EN     (HQM_SFI_TX_BLOCK_EARLY_VLD_EN)
    ,.HQM_SFI_TX_D                      (HQM_SFI_TX_D)
    ,.HQM_SFI_TX_DATA_AUX_PARITY_EN     (HQM_SFI_TX_DATA_AUX_PARITY_EN)
    ,.HQM_SFI_TX_DATA_CRD_GRAN          (HQM_SFI_TX_DATA_CRD_GRAN)
    ,.HQM_SFI_TX_DATA_INTERLEAVE        (HQM_SFI_TX_DATA_INTERLEAVE)
    ,.HQM_SFI_TX_DATA_LAYER_EN          (HQM_SFI_TX_DATA_LAYER_EN)
    ,.HQM_SFI_TX_DATA_PARITY_EN         (HQM_SFI_TX_DATA_PARITY_EN)
    ,.HQM_SFI_TX_DATA_PASS_HDR          (HQM_SFI_TX_DATA_PASS_HDR)
    ,.HQM_SFI_TX_DATA_MAX_FC_VC         (HQM_SFI_TX_DATA_MAX_FC_VC)
    ,.HQM_SFI_TX_DS                     (HQM_SFI_TX_DS)
    ,.HQM_SFI_TX_ECRC_SUPPORT           (HQM_SFI_TX_ECRC_SUPPORT)
    ,.HQM_SFI_TX_FLIT_MODE_PREFIX_EN    (HQM_SFI_TX_FLIT_MODE_PREFIX_EN)
    ,.HQM_SFI_TX_FATAL_EN               (HQM_SFI_TX_FATAL_EN)
    ,.HQM_SFI_TX_H                      (HQM_SFI_TX_H)
    ,.HQM_SFI_TX_HDR_DATA_SEP           (HQM_SFI_TX_HDR_DATA_SEP)
    ,.HQM_SFI_TX_HDR_MAX_FC_VC          (HQM_SFI_TX_HDR_MAX_FC_VC)
    ,.HQM_SFI_TX_HGRAN                  (HQM_SFI_TX_HGRAN)
    ,.HQM_SFI_TX_HPARITY                (HQM_SFI_TX_HPARITY)
    ,.HQM_SFI_TX_IDE_SUPPORT            (HQM_SFI_TX_IDE_SUPPORT)
    ,.HQM_SFI_TX_M                      (HQM_SFI_TX_M)
    ,.HQM_SFI_TX_MAX_CRD_CNT_WIDTH      (HQM_SFI_TX_MAX_CRD_CNT_WIDTH)
    ,.HQM_SFI_TX_MAX_HDR_WIDTH          (HQM_SFI_TX_MAX_HDR_WIDTH)
    ,.HQM_SFI_TX_NDCRD                  (HQM_SFI_TX_NDCRD)
    ,.HQM_SFI_TX_NHCRD                  (HQM_SFI_TX_NHCRD)
    ,.HQM_SFI_TX_NUM_SHARED_POOLS       (HQM_SFI_TX_NUM_SHARED_POOLS)
    ,.HQM_SFI_TX_PCIE_MERGED_SELECT     (HQM_SFI_TX_PCIE_MERGED_SELECT)
    ,.HQM_SFI_TX_PCIE_SHARED_SELECT     (HQM_SFI_TX_PCIE_SHARED_SELECT)
    ,.HQM_SFI_TX_RBN                    (HQM_SFI_TX_RBN)
    ,.HQM_SFI_TX_SH_DATA_CRD_BLK_SZ     (HQM_SFI_TX_SH_DATA_CRD_BLK_SZ)
    ,.HQM_SFI_TX_SH_HDR_CRD_BLK_SZ      (HQM_SFI_TX_SH_HDR_CRD_BLK_SZ)
    ,.HQM_SFI_TX_SHARED_CREDIT_EN       (HQM_SFI_TX_SHARED_CREDIT_EN)
    ,.HQM_SFI_TX_TBN                    (HQM_SFI_TX_TBN)
    ,.HQM_SFI_TX_TX_CRD_REG             (HQM_SFI_TX_TX_CRD_REG)
    ,.HQM_SFI_TX_VIRAL_EN               (HQM_SFI_TX_VIRAL_EN)
    ,.HQM_SFI_TX_VR                     (HQM_SFI_TX_VR)
    ,.HQM_SFI_TX_VT                     (HQM_SFI_TX_VT)
