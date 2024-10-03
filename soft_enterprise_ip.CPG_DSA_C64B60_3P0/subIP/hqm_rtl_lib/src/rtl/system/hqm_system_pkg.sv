//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
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

package hqm_system_pkg;

  import hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*, hqm_system_csr_pkg::*, hqm_msix_mem_pkg::*;

  localparam HQM_SYSTEM_NUM_MSIX                        = 65;

  localparam HQM_SYSTEM_VF_WIDTH                        = AW_logb2(NUM_VF-1)+1;
  localparam HQM_SYSTEM_VDEV_WIDTH                      = AW_logb2(NUM_VDEV-1)+1;
  localparam HQM_SYSTEM_DIR_PP_WIDTH                    = AW_logb2(NUM_DIR_PP-1)+1;
  localparam HQM_SYSTEM_LDB_PP_WIDTH                    = AW_logb2(NUM_LDB_PP-1)+1;
  localparam HQM_SYSTEM_VPP_WIDTH                       = (NUM_DIR_PP > NUM_LDB_PP) ? HQM_SYSTEM_DIR_PP_WIDTH : HQM_SYSTEM_LDB_PP_WIDTH;
  localparam HQM_SYSTEM_DIR_CQ_WIDTH                    = AW_logb2(NUM_DIR_CQ-1)+1;
  localparam HQM_SYSTEM_LDB_CQ_WIDTH                    = AW_logb2(NUM_LDB_CQ-1)+1;
  localparam HQM_SYSTEM_NUM_CQ                          = (NUM_DIR_CQ > NUM_LDB_CQ) ? NUM_DIR_CQ : NUM_LDB_CQ;
  localparam HQM_SYSTEM_CQ_WIDTH                        = (NUM_DIR_CQ > NUM_LDB_CQ) ? HQM_SYSTEM_DIR_CQ_WIDTH : HQM_SYSTEM_LDB_CQ_WIDTH;
  localparam HQM_SYSTEM_DIR_QID_WIDTH                   = AW_logb2(NUM_DIR_QID-1)+1;
  localparam HQM_SYSTEM_LDB_QID_WIDTH                   = AW_logb2(NUM_LDB_QID-1)+1;
  localparam HQM_SYSTEM_TS_WIDTH                        = 8;
  localparam HQM_SYSTEM_HCW_PP_WIDTH                    = 8;
  localparam HQM_SYSTEM_QID_WIDTH                       = HQM_SYSTEM_DIR_QID_WIDTH;
  localparam HQM_SYSTEM_VAS_WIDTH                       = 5;

  localparam HQM_SYSTEM_NUM_ROB_PPS                     = NUM_DIR_PP+NUM_LDB_PP;
  localparam HQM_SYSTEM_NUM_ROB_PPS_WIDTH               = AW_logb2(HQM_SYSTEM_NUM_ROB_PPS-1)+1;
  localparam HQM_SYSTEM_NUM_ROB_CLS                     = 4;
  localparam HQM_SYSTEM_NUM_ROB_CLS_WIDTH               = AW_logb2(HQM_SYSTEM_NUM_ROB_CLS-1)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_VF_DIR_VPP2PP         = NUM_DIR_PP * NUM_VDEV;
  localparam HQM_SYSTEM_PACK_LUT_VF_DIR_VPP2PP          = 4;                    // pack bits 256x24 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VPP2PP        = HQM_SYSTEM_DIR_PP_WIDTH;
  localparam HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP2PP        = AW_logb2(HQM_SYSTEM_DEPTH_LUT_VF_DIR_VPP2PP-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_VF_DIR_VPP2PP       = (HQM_SYSTEM_PACK_LUT_VF_DIR_VPP2PP == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP2PP :
                                                          (HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP2PP -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_VF_DIR_VPP2PP-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VPP2PP       = (HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VPP2PP *
                                                           HQM_SYSTEM_PACK_LUT_VF_DIR_VPP2PP)+7;

  localparam HQM_SYSTEM_DEPTH_LUT_VF_LDB_VPP2PP         = NUM_LDB_PP * NUM_VDEV;
  localparam HQM_SYSTEM_PACK_LUT_VF_LDB_VPP2PP          = 4;                    // pack bits 256x24 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VPP2PP        = HQM_SYSTEM_LDB_PP_WIDTH;
  localparam HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP2PP        = AW_logb2(HQM_SYSTEM_DEPTH_LUT_VF_LDB_VPP2PP-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_VF_LDB_VPP2PP       = (HQM_SYSTEM_PACK_LUT_VF_LDB_VPP2PP == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP2PP :
                                                          (HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP2PP -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_VF_LDB_VPP2PP-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VPP2PP       = (HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VPP2PP *
                                                           HQM_SYSTEM_PACK_LUT_VF_LDB_VPP2PP)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_VF_DIR_VPP_V          = NUM_DIR_PP * NUM_VDEV;
  localparam HQM_SYSTEM_PACK_LUT_VF_DIR_VPP_V           = 16;                   // pack bits 64x16 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VPP_V         = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP_V         = AW_logb2(HQM_SYSTEM_DEPTH_LUT_VF_DIR_VPP_V-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_VF_DIR_VPP_V        = (HQM_SYSTEM_PACK_LUT_VF_DIR_VPP_V == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP_V :
                                                          (HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VPP_V -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_VF_DIR_VPP_V-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VPP_V        = (HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VPP_V *
                                                           HQM_SYSTEM_PACK_LUT_VF_DIR_VPP_V)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_VF_LDB_VPP_V          = NUM_LDB_PP * NUM_VDEV;
  localparam HQM_SYSTEM_PACK_LUT_VF_LDB_VPP_V           = 16;                   // pack bits 64x16 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VPP_V         = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP_V         = AW_logb2(HQM_SYSTEM_DEPTH_LUT_VF_LDB_VPP_V-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_VF_LDB_VPP_V        = (HQM_SYSTEM_PACK_LUT_VF_LDB_VPP_V == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP_V :
                                                          (HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VPP_V -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_VF_LDB_VPP_V-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VPP_V        = (HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VPP_V *
                                                           HQM_SYSTEM_PACK_LUT_VF_LDB_VPP_V)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_PP_V              = NUM_DIR_PP;
  localparam HQM_SYSTEM_PACK_LUT_DIR_PP_V               = 16;                   // pack bits 4x32 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_PP_V             = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_PP_V             = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_PP_V-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_PP_V            = (HQM_SYSTEM_PACK_LUT_DIR_PP_V == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_PP_V :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_PP_V -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_PP_V-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_PP_V            = (HQM_SYSTEM_DWIDTH_LUT_DIR_PP_V *
                                                           HQM_SYSTEM_PACK_LUT_DIR_PP_V)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_PP_V              = NUM_LDB_PP;
  localparam HQM_SYSTEM_PACK_LUT_LDB_PP_V               = 32;                   // pack bits 2x32 Flops
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_PP_V             = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_PP_V             = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_PP_V-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_PP_V            = (HQM_SYSTEM_PACK_LUT_LDB_PP_V == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_PP_V :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_PP_V -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_PP_V-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_PP_V            = (HQM_SYSTEM_DWIDTH_LUT_LDB_PP_V *
                                                           HQM_SYSTEM_PACK_LUT_LDB_PP_V)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_VF_DIR_VQID2QID       = NUM_DIR_QID * NUM_VDEV;
  localparam HQM_SYSTEM_PACK_LUT_VF_DIR_VQID2QID        = 4;                    // pack bits 256x24 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VQID2QID      = HQM_SYSTEM_DIR_QID_WIDTH;
  localparam HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID2QID      = AW_logb2(HQM_SYSTEM_DEPTH_LUT_VF_DIR_VQID2QID-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_VF_DIR_VQID2QID     = (HQM_SYSTEM_PACK_LUT_VF_DIR_VQID2QID == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID2QID :
                                                          (HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID2QID -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_VF_DIR_VQID2QID-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VQID2QID     = (HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VQID2QID *
                                                           HQM_SYSTEM_PACK_LUT_VF_DIR_VQID2QID)+7;

  localparam HQM_SYSTEM_DEPTH_LUT_VF_LDB_VQID2QID       = NUM_LDB_QID * NUM_VDEV;
  localparam HQM_SYSTEM_PACK_LUT_VF_LDB_VQID2QID        = 4;                    // pack bits 128x20 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VQID2QID      = HQM_SYSTEM_LDB_QID_WIDTH;
  localparam HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID2QID      = AW_logb2(HQM_SYSTEM_DEPTH_LUT_VF_LDB_VQID2QID-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_VF_LDB_VQID2QID     = (HQM_SYSTEM_PACK_LUT_VF_LDB_VQID2QID == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID2QID :
                                                          (HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID2QID -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_VF_LDB_VQID2QID-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VQID2QID     = (HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VQID2QID *
                                                           HQM_SYSTEM_PACK_LUT_VF_LDB_VQID2QID)+7;

  localparam HQM_SYSTEM_DEPTH_LUT_VF_DIR_VQID_V         = NUM_DIR_QID * NUM_VDEV;
  localparam HQM_SYSTEM_PACK_LUT_VF_DIR_VQID_V          = 16;                   // pack bits 64x16 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VQID_V        = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID_V        = AW_logb2(HQM_SYSTEM_DEPTH_LUT_VF_DIR_VQID_V-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_VF_DIR_VQID_V       = (HQM_SYSTEM_PACK_LUT_VF_DIR_VQID_V == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID_V :
                                                          (HQM_SYSTEM_AWIDTH_LUT_VF_DIR_VQID_V -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_VF_DIR_VQID_V-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VQID_V       = (HQM_SYSTEM_DWIDTH_LUT_VF_DIR_VQID_V *
                                                           HQM_SYSTEM_PACK_LUT_VF_DIR_VQID_V)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_VF_LDB_VQID_V         = NUM_LDB_QID * NUM_VDEV;
  localparam HQM_SYSTEM_PACK_LUT_VF_LDB_VQID_V          = 16;                   // pack bits 64x16 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VQID_V        = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID_V        = AW_logb2(HQM_SYSTEM_DEPTH_LUT_VF_LDB_VQID_V-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_VF_LDB_VQID_V       = (HQM_SYSTEM_PACK_LUT_VF_LDB_VQID_V == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID_V :
                                                          (HQM_SYSTEM_AWIDTH_LUT_VF_LDB_VQID_V -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_VF_LDB_VQID_V-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VQID_V       = (HQM_SYSTEM_DWIDTH_LUT_VF_LDB_VQID_V *
                                                           HQM_SYSTEM_PACK_LUT_VF_LDB_VQID_V)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_QID_V             = NUM_DIR_QID;
  localparam HQM_SYSTEM_PACK_LUT_DIR_QID_V              = 1;                   // pack bits 2x32 Flops
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_QID_V            = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_QID_V            = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_QID_V-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_V           = (HQM_SYSTEM_PACK_LUT_DIR_QID_V == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_QID_V :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_QID_V -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_QID_V-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_V           = (HQM_SYSTEM_DWIDTH_LUT_DIR_QID_V *
                                                           HQM_SYSTEM_PACK_LUT_DIR_QID_V)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_QID_V             = NUM_LDB_QID;
  localparam HQM_SYSTEM_PACK_LUT_LDB_QID_V              = 16;                   // pack bits 2x16 Flops
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_QID_V            = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_QID_V            = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_QID_V-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_V           = (HQM_SYSTEM_PACK_LUT_LDB_QID_V == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_QID_V :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_QID_V -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_QID_V-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_V           = (HQM_SYSTEM_DWIDTH_LUT_LDB_QID_V *
                                                           HQM_SYSTEM_PACK_LUT_LDB_QID_V)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_PP2VAS            = NUM_DIR_PP;
  localparam HQM_SYSTEM_PACK_LUT_DIR_PP2VAS             = 2;                    // pack bits 32x10 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_PP2VAS           = HQM_SYSTEM_VAS_WIDTH;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_PP2VAS           = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_PP2VAS-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_PP2VAS          = (HQM_SYSTEM_PACK_LUT_DIR_PP2VAS == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_PP2VAS :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_PP2VAS -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_PP2VAS-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_PP2VAS          = (HQM_SYSTEM_DWIDTH_LUT_DIR_PP2VAS *
                                                           HQM_SYSTEM_PACK_LUT_DIR_PP2VAS)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_PP2VAS            = NUM_LDB_PP;
  localparam HQM_SYSTEM_PACK_LUT_LDB_PP2VAS             = 2;                    // pack bits 32x10 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_PP2VAS           = HQM_SYSTEM_VAS_WIDTH;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_PP2VAS           = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_PP2VAS-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_PP2VAS          = (HQM_SYSTEM_PACK_LUT_LDB_PP2VAS == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_PP2VAS :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_PP2VAS -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_PP2VAS-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_PP2VAS          = (HQM_SYSTEM_DWIDTH_LUT_LDB_PP2VAS *
                                                           HQM_SYSTEM_PACK_LUT_LDB_PP2VAS)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_QID_CFG_V         = NUM_LDB_QID;
  localparam HQM_SYSTEM_PACK_LUT_LDB_QID_CFG_V          = 16;                   // pack bits 2x48 Flops
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_QID_CFG_V        = 3;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_QID_CFG_V        = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_QID_CFG_V-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_CFG_V       = (HQM_SYSTEM_PACK_LUT_LDB_QID_CFG_V == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_QID_CFG_V :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_QID_CFG_V -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_QID_CFG_V-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_CFG_V       = (HQM_SYSTEM_DWIDTH_LUT_LDB_QID_CFG_V *
                                                           HQM_SYSTEM_PACK_LUT_LDB_QID_CFG_V)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_VASQID_V          = NUM_VAS * NUM_DIR_QID;
  localparam HQM_SYSTEM_PACK_LUT_DIR_VASQID_V           = 32;                   // pack bits 64x32 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_VASQID_V         = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_VASQID_V         = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_VASQID_V-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_VASQID_V        = (HQM_SYSTEM_PACK_LUT_DIR_VASQID_V == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_VASQID_V :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_VASQID_V -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_VASQID_V-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_VASQID_V        = (HQM_SYSTEM_DWIDTH_LUT_DIR_VASQID_V *
                                                           HQM_SYSTEM_PACK_LUT_DIR_VASQID_V)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_VASQID_V          = NUM_VAS * NUM_LDB_QID;
  localparam HQM_SYSTEM_PACK_LUT_LDB_VASQID_V           = 16;                   // pack bits 64x16 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_VASQID_V         = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_VASQID_V         = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_VASQID_V-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_VASQID_V        = (HQM_SYSTEM_PACK_LUT_LDB_VASQID_V == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_VASQID_V :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_VASQID_V -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_VASQID_V-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_VASQID_V        = (HQM_SYSTEM_DWIDTH_LUT_LDB_VASQID_V *
                                                           HQM_SYSTEM_PACK_LUT_LDB_VASQID_V)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_CQ_ADDR_L         = NUM_DIR_CQ;
  localparam HQM_SYSTEM_PACK_LUT_DIR_CQ_ADDR_L          = 1;                    // pack bits 64x26 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ADDR_L        = 26;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ADDR_L        = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_CQ_ADDR_L-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_ADDR_L       = (HQM_SYSTEM_PACK_LUT_DIR_CQ_ADDR_L == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ADDR_L :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ADDR_L -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_CQ_ADDR_L-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_ADDR_L       = (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ADDR_L *
                                                           HQM_SYSTEM_PACK_LUT_DIR_CQ_ADDR_L)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_CQ_ADDR_L         = NUM_LDB_CQ;
  localparam HQM_SYSTEM_PACK_LUT_LDB_CQ_ADDR_L          = 1;                    // pack bits 64x26 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ADDR_L        = 26;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ADDR_L        = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_CQ_ADDR_L-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_ADDR_L       = (HQM_SYSTEM_PACK_LUT_LDB_CQ_ADDR_L == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ADDR_L :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ADDR_L -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_CQ_ADDR_L-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_ADDR_L       = (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ADDR_L *
                                                           HQM_SYSTEM_PACK_LUT_LDB_CQ_ADDR_L)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_CQ_ADDR_U         = NUM_DIR_CQ;
  localparam HQM_SYSTEM_PACK_LUT_DIR_CQ_ADDR_U          = 1;                    // pack bits 64x32 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ADDR_U        = 32;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ADDR_U        = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_CQ_ADDR_U-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_ADDR_U       = (HQM_SYSTEM_PACK_LUT_DIR_CQ_ADDR_U == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ADDR_U :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ADDR_U -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_CQ_ADDR_U-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_ADDR_U       = (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ADDR_U *
                                                           HQM_SYSTEM_PACK_LUT_DIR_CQ_ADDR_U)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_CQ_ADDR_U         = NUM_LDB_CQ;
  localparam HQM_SYSTEM_PACK_LUT_LDB_CQ_ADDR_U          = 1;                    // pack bits 64x32 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ADDR_U        = 32;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ADDR_U        = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_CQ_ADDR_U-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_ADDR_U       = (HQM_SYSTEM_PACK_LUT_LDB_CQ_ADDR_U == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ADDR_U :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ADDR_U -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_CQ_ADDR_U-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_ADDR_U       = (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ADDR_U *
                                                           HQM_SYSTEM_PACK_LUT_LDB_CQ_ADDR_U)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_CQ_FMT            = NUM_DIR_CQ;
  localparam HQM_SYSTEM_PACK_LUT_DIR_CQ_FMT             = 1;                   // pack bits 2x32 Flops
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_FMT           = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_FMT           = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_CQ_FMT-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_FMT          = (HQM_SYSTEM_PACK_LUT_DIR_CQ_FMT == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_FMT :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_FMT -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_CQ_FMT-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_FMT          = (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_FMT *
                                                           HQM_SYSTEM_PACK_LUT_DIR_CQ_FMT)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_CQ2VF_PF_RO       = NUM_DIR_CQ;
  localparam HQM_SYSTEM_PACK_LUT_DIR_CQ2VF_PF_RO        = 2;                    // pack bits 32x12 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_CQ2VF_PF_RO      = 6;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_CQ2VF_PF_RO      = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_CQ2VF_PF_RO-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ2VF_PF_RO     = (HQM_SYSTEM_PACK_LUT_DIR_CQ2VF_PF_RO == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_CQ2VF_PF_RO :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_CQ2VF_PF_RO -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_CQ2VF_PF_RO-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ2VF_PF_RO     = (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ2VF_PF_RO *
                                                           HQM_SYSTEM_PACK_LUT_DIR_CQ2VF_PF_RO)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_CQ2VF_PF_RO       = NUM_LDB_CQ;
  localparam HQM_SYSTEM_PACK_LUT_LDB_CQ2VF_PF_RO        = 2;                    // pack bits 32x12 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_CQ2VF_PF_RO      = 6;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_CQ2VF_PF_RO      = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_CQ2VF_PF_RO-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ2VF_PF_RO     = (HQM_SYSTEM_PACK_LUT_LDB_CQ2VF_PF_RO == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_CQ2VF_PF_RO :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_CQ2VF_PF_RO -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_CQ2VF_PF_RO-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ2VF_PF_RO     = (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ2VF_PF_RO *
                                                           HQM_SYSTEM_PACK_LUT_LDB_CQ2VF_PF_RO)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_QID2VQID          = NUM_LDB_QID;
  localparam HQM_SYSTEM_PACK_LUT_LDB_QID2VQID           = 4;                    // pack bits 128x20 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_QID2VQID         = HQM_SYSTEM_LDB_QID_WIDTH;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_QID2VQID         = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_QID2VQID-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_QID2VQID        = (HQM_SYSTEM_PACK_LUT_LDB_QID2VQID == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_QID2VQID :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_QID2VQID -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_QID2VQID-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_QID2VQID        = (HQM_SYSTEM_DWIDTH_LUT_LDB_QID2VQID *
                                                           HQM_SYSTEM_PACK_LUT_LDB_QID2VQID)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_CQ_ISR            = NUM_DIR_CQ;
  localparam HQM_SYSTEM_PACK_LUT_DIR_CQ_ISR             = 1;                    // pack bits 64x12 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ISR           = 12;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ISR           = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_CQ_ISR-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_ISR          = (HQM_SYSTEM_PACK_LUT_DIR_CQ_ISR == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ISR :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_ISR -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_CQ_ISR-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_ISR          = (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_ISR *
                                                           HQM_SYSTEM_PACK_LUT_DIR_CQ_ISR)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_CQ_ISR            = NUM_LDB_CQ;
  localparam HQM_SYSTEM_PACK_LUT_LDB_CQ_ISR             = 1;                    // pack bits 64x12 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ISR           = 12;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ISR           = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_CQ_ISR-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_ISR          = (HQM_SYSTEM_PACK_LUT_LDB_CQ_ISR == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ISR :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_ISR -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_CQ_ISR-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_ISR          = (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_ISR *
                                                           HQM_SYSTEM_PACK_LUT_LDB_CQ_ISR)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_CQ_AI_ADDR_L      = NUM_DIR_CQ;
  localparam HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_ADDR_L       = 1;                    // pack bits 64x20 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_ADDR_L     = 30;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_ADDR_L     = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_CQ_AI_ADDR_L-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_AI_ADDR_L    = (HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_ADDR_L == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_ADDR_L :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_ADDR_L -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_ADDR_L-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_AI_ADDR_L    = (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_ADDR_L *
                                                           HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_ADDR_L)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_CQ_AI_ADDR_U      = NUM_DIR_CQ;
  localparam HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_ADDR_U       = 1;                    // pack bits 64x20 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_ADDR_U     = 32;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_ADDR_U     = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_CQ_AI_ADDR_U-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_AI_ADDR_U    = (HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_ADDR_U == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_ADDR_U :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_ADDR_U -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_ADDR_U-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_AI_ADDR_U    = (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_ADDR_U *
                                                           HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_ADDR_U)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_CQ_AI_ADDR_L      = NUM_LDB_CQ;
  localparam HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_ADDR_L       = 1;                    // pack bits 64x20 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_ADDR_L     = 30;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_ADDR_L     = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_CQ_AI_ADDR_L-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_AI_ADDR_L    = (HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_ADDR_L == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_ADDR_L :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_ADDR_L -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_ADDR_L-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_AI_ADDR_L    = (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_ADDR_L *
                                                           HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_ADDR_L)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_CQ_AI_ADDR_U      = NUM_LDB_CQ;
  localparam HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_ADDR_U       = 1;                    // pack bits 64x20 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_ADDR_U     = 32;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_ADDR_U     = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_CQ_AI_ADDR_U-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_AI_ADDR_U    = (HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_ADDR_U == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_ADDR_U :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_ADDR_U -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_ADDR_U-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_AI_ADDR_U    = (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_ADDR_U *
                                                           HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_ADDR_U)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_CQ_AI_DATA        = NUM_DIR_CQ;
  localparam HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_DATA         = 1;                    // pack bits 64x32 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_DATA       = 32;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_DATA       = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_CQ_AI_DATA-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_AI_DATA      = (HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_DATA == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_DATA :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_AI_DATA -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_DATA-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_AI_DATA      = (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_AI_DATA *
                                                           HQM_SYSTEM_PACK_LUT_DIR_CQ_AI_DATA)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_CQ_AI_DATA        = NUM_LDB_CQ;
  localparam HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_DATA         = 1;                    // pack bits 64x32 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_DATA       = 32;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_DATA       = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_CQ_AI_DATA-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_AI_DATA      = (HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_DATA == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_DATA :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_AI_DATA -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_DATA-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_AI_DATA      = (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_AI_DATA *
                                                           HQM_SYSTEM_PACK_LUT_LDB_CQ_AI_DATA)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_QID_ITS           = NUM_DIR_QID;
  localparam HQM_SYSTEM_PACK_LUT_DIR_QID_ITS            = 1;                   // pack bits 2x32 Flops
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_QID_ITS          = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_QID_ITS          = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_QID_ITS-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_ITS         = (HQM_SYSTEM_PACK_LUT_DIR_QID_ITS == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_QID_ITS :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_QID_ITS -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_QID_ITS-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_ITS         = (HQM_SYSTEM_DWIDTH_LUT_DIR_QID_ITS *
                                                           HQM_SYSTEM_PACK_LUT_DIR_QID_ITS)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_QID_ITS           = NUM_LDB_QID;
  localparam HQM_SYSTEM_PACK_LUT_LDB_QID_ITS            = 16;                   // pack bits 2x16 Flops
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_QID_ITS          = 1;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_QID_ITS          = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_QID_ITS-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_ITS         = (HQM_SYSTEM_PACK_LUT_LDB_QID_ITS == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_QID_ITS :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_QID_ITS -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_QID_ITS-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_ITS         = (HQM_SYSTEM_DWIDTH_LUT_LDB_QID_ITS *
                                                           HQM_SYSTEM_PACK_LUT_LDB_QID_ITS)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_DIR_CQ_PASID          = NUM_DIR_CQ;
  localparam HQM_SYSTEM_PACK_LUT_DIR_CQ_PASID           = 1;                    // pack bits 64x23 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_PASID         = HQM_PASIDTLP_WIDTH;
  localparam HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_PASID         = AW_logb2(HQM_SYSTEM_DEPTH_LUT_DIR_CQ_PASID-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_PASID        = (HQM_SYSTEM_PACK_LUT_DIR_CQ_PASID == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_PASID :
                                                          (HQM_SYSTEM_AWIDTH_LUT_DIR_CQ_PASID -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_DIR_CQ_PASID-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_PASID        = (HQM_SYSTEM_DWIDTH_LUT_DIR_CQ_PASID *
                                                           HQM_SYSTEM_PACK_LUT_DIR_CQ_PASID)+1;

  localparam HQM_SYSTEM_DEPTH_LUT_LDB_CQ_PASID          = NUM_LDB_CQ;
  localparam HQM_SYSTEM_PACK_LUT_LDB_CQ_PASID           = 1;                    // pack bits 64x23 RF
  localparam HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_PASID         = HQM_PASIDTLP_WIDTH;
  localparam HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_PASID         = AW_logb2(HQM_SYSTEM_DEPTH_LUT_LDB_CQ_PASID-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_PASID        = (HQM_SYSTEM_PACK_LUT_LDB_CQ_PASID == 1) ?
                                                          HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_PASID :
                                                          (HQM_SYSTEM_AWIDTH_LUT_LDB_CQ_PASID -
                                                           (AW_logb2(HQM_SYSTEM_PACK_LUT_LDB_CQ_PASID-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_PASID        = (HQM_SYSTEM_DWIDTH_LUT_LDB_CQ_PASID *
                                                           HQM_SYSTEM_PACK_LUT_LDB_CQ_PASID)+1;

  typedef struct packed {
    logic [7:0]                                         ecc_h;
    logic [7:0]                                         ecc_l;
    logic                                               port_parity;
    logic                                               is_nm_pf;
    logic                                               is_pf_port;
    logic                                               is_ldb_port;
    logic                                               cl_last;
    logic [3:0]                                         cl;
    logic [1:0]                                         cli;
    logic [HQM_SYSTEM_VPP_WIDTH-1:0]                    vpp;
    inbound_hcw_t                                       hcw;
  } hqm_system_enq_data_in_t;

  typedef struct packed {
    logic [7:0]                                         ecc_h;
    logic [7:0]                                         ecc_l;
    logic                                               port_parity;
    logic [1:0]                                         spare;
    logic                                               is_nm_pf;
    logic                                               is_pf_port;
    logic                                               is_ldb_port;
    logic [HQM_SYSTEM_VPP_WIDTH-1:0]                    vpp;
    inbound_hcw_t                                       hcw;
  } hqm_system_enq_data_rob_t;

  typedef struct packed {
    logic                                               mb_ecc_err;
    logic                                               hcw_parity_ms;
    logic [7:0]                                         ecc_l;
    logic                                               port_parity;
    logic                                               is_nm_pf;
    logic                                               is_pf_port;
    logic                                               is_ldb_port;
    logic [HQM_SYSTEM_VDEV_WIDTH-1:0]                   vdev;
    logic [HQM_SYSTEM_DIR_PP_WIDTH-1:0]                 vpp;
    inbound_hcw_t                                       hcw;
  } hqm_system_enq_data_p02_t;

  typedef struct packed {
    logic                                               parity_err;
    logic                                               pp_v;
    logic [HQM_SYSTEM_HCW_PP_WIDTH-1:0]                 pp;
    logic                                               qid_v;

    logic                                               mb_ecc_err;
    logic                                               hcw_parity_ms;
    logic [7:0]                                         ecc_l;
    logic                                               port_parity;
    logic                                               is_pf_port;
    logic                                               is_ldb_port;
    logic [HQM_SYSTEM_VDEV_WIDTH-1:0]                   vdev;
    logic [HQM_SYSTEM_DIR_PP_WIDTH-1:0]                 vpp;
    inbound_hcw_t                                       hcw;
  } hqm_system_enq_data_p35_t;

  typedef struct packed {
    logic                                               parity_err;
    logic [2:0]                                         qid_cfg_v;
    logic [HQM_SYSTEM_VAS_WIDTH-1:0]                    vas;

    logic                                               pp_v;
    logic [HQM_SYSTEM_HCW_PP_WIDTH-1:0]                 pp;
    logic                                               qid_v;

    logic                                               mb_ecc_err;
    logic                                               hcw_parity_ms;
    logic [7:0]                                         ecc_l;
    logic                                               port_parity;
    logic                                               is_pf_port;
    logic                                               is_ldb_port;
    logic [HQM_SYSTEM_VDEV_WIDTH-1:0]                   vdev;
    logic [HQM_SYSTEM_DIR_PP_WIDTH-1:0]                 vpp;
    inbound_hcw_t                                       hcw;
  } hqm_system_enq_data_p68_t;

  typedef struct packed {
    logic                                               insert_timestamp;
    logic [2:0]                                         qid_cfg_v;
    logic                                               vasqid_v;
    logic [HQM_SYSTEM_VAS_WIDTH-1:0]                    vas;
    logic                                               pp_v;
    logic [HQM_SYSTEM_HCW_PP_WIDTH-1:0]                 pp;
    logic                                               qid_v;

    logic [1:0]                                         hcw_parity;
    logic                                               is_pf_port;
    logic                                               is_ldb_port;
    logic [HQM_SYSTEM_VDEV_WIDTH-1:0]                   vdev;
    logic [HQM_SYSTEM_DIR_PP_WIDTH-1:0]                 vpp;
    inbound_hcw_t                                       hcw;
  } hqm_system_enq_data_out_t;

  typedef struct packed {
    logic                                               parity;
    logic                                               int_v;
    interrupt_w_req_t                                   int_d;
    logic                                               hcw_v;
    hcw_sched_w_req_t                                   w;
  } hqm_system_sch_data_in_t;

  typedef struct packed {
    logic                                               parity;
    logic [1:0]                                         cq_addr_res;
    logic                                               perr;
    logic                                               ro;
    logic [HQM_PASIDTLP_WIDTH-1:0]                      pasidtlp;
    logic                                               is_pf;
    logic [HQM_SYSTEM_VF_WIDTH-1:0]                     vf;
    logic                                               keep_pf_ppid;
    logic [63:4]                                        cq_addr;
    logic                                               int_v;
    interrupt_w_req_t                                   int_d;
    logic                                               hcw_v;
    hcw_sched_w_req_t                                   w;
  } hqm_system_sch_data_p35_t;

  typedef struct packed {
    logic                                               parity;         // 277
    logic                                               error_parity;   // 276
    logic                                               error;          // 275
    logic [1:0]                                         cq_addr_res;    // 274:273
    logic [15:0]                                        ecc;            // 272:257
    logic                                               ro;             // 256
    logic [HQM_PASIDTLP_WIDTH-1:0]                      pasidtlp;       // 255:233
    logic                                               is_pf;          // 232
    logic [HQM_SYSTEM_VF_WIDTH-1:0]                     vf;             // 231:228
    logic [63:4]                                        cq_addr;        // 227:168
    logic                                               int_v;          // 167
    interrupt_w_req_t                                   int_d;          // 166:160
    logic                                               hcw_v;          // 159
    hcw_sched_w_req_t                                   w;              // 158:0
  } hqm_system_sch_data_out_t;

  localparam HQM_CSR_OFFSET_WID     = 13;
  localparam HQM_CSR_DATA_WID       = 32;
  localparam HQM_CSR_BYTE_EN_WID    = HQM_CSR_DATA_WID/8;

  typedef logic[HQM_CSR_OFFSET_WID-1:0]         hqm_csr_offset_t;
  typedef logic[7:0]                            hqm_csr_func_t;
  typedef logic[HQM_CSR_DATA_WID-1:0]           hqm_csr_data_t;
  typedef logic[HQM_CSR_BYTE_EN_WID-1:0]        hqm_csr_byte_en_t;

  typedef struct packed {
    hqm_csr_offset_t                                    csr_wr_offset;          // The offset address for a CFG write
    hqm_csr_offset_t                                    csr_rd_offset;          // The offset address for a CFG read
    logic [31:0]                                        csr_mem_mapped_offset;  // The offset address for a memory mapped access
    logic                                               csr_mem_mapped_apar;    // Parity on csr_mem_mapped_offset
    logic                                               csr_mem_mapped_dpar;    // Parity on csr_wr_dword
    hqm_csr_data_t                                      csr_wr_dword;           // The data to be written.
    hqm_csr_byte_en_t                                   csr_byte_en;            // The write byte enable.
    hqm_csr_func_t                                      csr_wr_func;            // The function number for a CSR write
    hqm_csr_func_t                                      csr_rd_func;            // The function number for a CSR read
    logic                                               csr_mem_mapped;         // Set for all memory mapped CSR accesses
    logic                                               csr_ext_mem_mapped;     // Set for external memory mapped CSR accesses
    logic                                               csr_func_pf_mem_mapped; // FUNC_PF BAR mem mapped request
    logic                                               csr_func_vf_mem_mapped; // FUNC_VF BAR mem mapped request
    logic [HQM_SYSTEM_VF_WIDTH-1:0]                     csr_func_vf_num;        // FUNC_VF BAR VF number
    logic [7:0]                                         csr_sai;                // SAI
  } hqm_system_csr_req_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_VF_DIR_VPP2PP-1:0]    addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VPP2PP-1:0]    wdata;
  } hqm_system_memi_lut_vf_dir_vpp2pp_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VPP2PP-1:0]    rdata;
  } hqm_system_memo_lut_vf_dir_vpp2pp_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_VF_LDB_VPP2PP-1:0]    addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VPP2PP-1:0]    wdata;
  } hqm_system_memi_lut_vf_ldb_vpp2pp_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VPP2PP-1:0]    rdata;
  } hqm_system_memo_lut_vf_ldb_vpp2pp_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_VF_DIR_VPP_V-1:0]     addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VPP_V-1:0]     wdata;
  } hqm_system_memi_lut_vf_dir_vpp_v_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VPP_V-1:0]     rdata;
  } hqm_system_memo_lut_vf_dir_vpp_v_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_VF_LDB_VPP_V-1:0]     addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VPP_V-1:0]     wdata;
  } hqm_system_memi_lut_vf_ldb_vpp_v_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VPP_V-1:0]     rdata;
  } hqm_system_memo_lut_vf_ldb_vpp_v_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_PP_V-1:0]         addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_PP_V-1:0]         wdata;
  } hqm_system_memi_lut_dir_pp_v_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_PP_V-1:0]         rdata;
  } hqm_system_memo_lut_dir_pp_v_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_PP_V-1:0]         addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_PP_V-1:0]         wdata;
  } hqm_system_memi_lut_ldb_pp_v_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_PP_V-1:0]         rdata;
  } hqm_system_memo_lut_ldb_pp_v_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_VF_DIR_VQID2QID-1:0]  addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VQID2QID-1:0]  wdata;
  } hqm_system_memi_lut_vf_dir_vqid2qid_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VQID2QID-1:0]  rdata;
  } hqm_system_memo_lut_vf_dir_vqid2qid_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_VF_LDB_VQID2QID-1:0]  addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VQID2QID-1:0]  wdata;
  } hqm_system_memi_lut_vf_ldb_vqid2qid_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VQID2QID-1:0]  rdata;
  } hqm_system_memo_lut_vf_ldb_vqid2qid_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_VF_DIR_VQID_V-1:0]    addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VQID_V-1:0]    wdata;
  } hqm_system_memi_lut_vf_dir_vqid_v_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_DIR_VQID_V-1:0]    rdata;
  } hqm_system_memo_lut_vf_dir_vqid_v_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_VF_LDB_VQID_V-1:0]    addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VQID_V-1:0]    wdata;
  } hqm_system_memi_lut_vf_ldb_vqid_v_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_VF_LDB_VQID_V-1:0]    rdata;
  } hqm_system_memo_lut_vf_ldb_vqid_v_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_V-1:0]        addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_V-1:0]        wdata;
  } hqm_system_memi_lut_dir_qid_v_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_V-1:0]        rdata;
  } hqm_system_memo_lut_dir_qid_v_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_V-1:0]        addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_V-1:0]        wdata;
  } hqm_system_memi_lut_ldb_qid_v_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_V-1:0]        rdata;
  } hqm_system_memo_lut_ldb_qid_v_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_PP2VAS-1:0]       addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_PP2VAS-1:0]       wdata;
  } hqm_system_memi_lut_dir_pp2vas_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_PP2VAS-1:0]       rdata;
  } hqm_system_memo_lut_dir_pp2vas_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_PP2VAS-1:0]       addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_PP2VAS-1:0]       wdata;
  } hqm_system_memi_lut_ldb_pp2vas_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_PP2VAS-1:0]       rdata;
  } hqm_system_memo_lut_ldb_pp2vas_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_CFG_V-1:0]    addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_CFG_V-1:0]    wdata;
  } hqm_system_memi_lut_ldb_qid_cfg_v_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_CFG_V-1:0]    rdata;
  } hqm_system_memo_lut_ldb_qid_cfg_v_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_VASQID_V-1:0]     addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_VASQID_V-1:0]     wdata;
  } hqm_system_memi_lut_dir_vasqid_v_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_VASQID_V-1:0]     rdata;
  } hqm_system_memo_lut_dir_vasqid_v_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_VASQID_V-1:0]     addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_VASQID_V-1:0]     wdata;
  } hqm_system_memi_lut_ldb_vasqid_v_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_VASQID_V-1:0]     rdata;
  } hqm_system_memo_lut_ldb_vasqid_v_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_QID_ITS-1:0]      addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_ITS-1:0]      wdata;
  } hqm_system_memi_lut_dir_qid_its_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_QID_ITS-1:0]      rdata;
  } hqm_system_memo_lut_dir_qid_its_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_QID_ITS-1:0]      addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_ITS-1:0]      wdata;
  } hqm_system_memi_lut_ldb_qid_its_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID_ITS-1:0]      rdata;
  } hqm_system_memo_lut_ldb_qid_its_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_ADDR_L-1:0]    addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_ADDR_L-1:0]    wdata;
  } hqm_system_memi_lut_dir_cq_addr_l_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_ADDR_L-1:0]    rdata;
  } hqm_system_memo_lut_dir_cq_addr_l_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_ADDR_L-1:0]    addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_ADDR_L-1:0]    wdata;
  } hqm_system_memi_lut_ldb_cq_addr_l_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_ADDR_L-1:0]    rdata;
  } hqm_system_memo_lut_ldb_cq_addr_l_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_ADDR_U-1:0]    addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_ADDR_U-1:0]    wdata;
  } hqm_system_memi_lut_dir_cq_addr_u_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_ADDR_U-1:0]    rdata;
  } hqm_system_memo_lut_dir_cq_addr_u_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_ADDR_U-1:0]    addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_ADDR_U-1:0]    wdata;
  } hqm_system_memi_lut_ldb_cq_addr_u_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_ADDR_U-1:0]    rdata;
  } hqm_system_memo_lut_ldb_cq_addr_u_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_PASID-1:0]     addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_PASID-1:0]     wdata;
  } hqm_system_memi_lut_dir_cq_pasid_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_PASID-1:0]     rdata;
  } hqm_system_memo_lut_dir_cq_pasid_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_PASID-1:0]     addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_PASID-1:0]     wdata;
  } hqm_system_memi_lut_ldb_cq_pasid_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_PASID-1:0]     rdata;
  } hqm_system_memo_lut_ldb_cq_pasid_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_FMT-1:0]       addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_FMT-1:0]       wdata;
  } hqm_system_memi_lut_dir_cq_fmt_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_FMT-1:0]       rdata;
  } hqm_system_memo_lut_dir_cq_fmt_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ2VF_PF_RO-1:0]  addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ2VF_PF_RO-1:0]  wdata;
  } hqm_system_memi_lut_dir_cq2vf_pf_ro_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ2VF_PF_RO-1:0]  rdata;
  } hqm_system_memo_lut_dir_cq2vf_pf_ro_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ2VF_PF_RO-1:0]  addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ2VF_PF_RO-1:0]  wdata;
  } hqm_system_memi_lut_ldb_cq2vf_pf_ro_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ2VF_PF_RO-1:0]  rdata;
  } hqm_system_memo_lut_ldb_cq2vf_pf_ro_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_QID2VQID-1:0]     addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID2VQID-1:0]     wdata;
  } hqm_system_memi_lut_ldb_qid2vqid_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_QID2VQID-1:0]     rdata;
  } hqm_system_memo_lut_ldb_qid2vqid_t;

  typedef struct packed {
    logic                 wb_dir_cq_state;
    logic                 wb_ldb_cq_state;
  } hqm_system_wb_cfg_signal_t;
  
  typedef struct packed {
    logic                 vf_dir_vpp2pp;
    logic                 vf_ldb_vpp2pp;
    logic                 vf_dir_vpp_v;
    logic                 vf_ldb_vpp_v;
    logic                 dir_pp_v;
    logic                 ldb_pp_v;
    logic                 vf_dir_vqid2qid;
    logic                 vf_ldb_vqid2qid;
    logic                 vf_dir_vqid_v;
    logic                 vf_ldb_vqid_v;
    logic                 dir_qid_its;
    logic                 ldb_qid_its;
    logic                 dir_qid_v;
    logic                 ldb_qid_v;
    logic                 ldb_vasqid_v;
    logic                 dir_vasqid_v;
    logic                 ldb_pp2vas;
    logic                 dir_pp2vas;
    logic                 ldb_qid_cfg_v;
  } hqm_system_ingress_cfg_signal_t;
  
  typedef struct packed {
    VF_DIR_VPP2PP_t       vf_dir_vpp2pp;
    VF_LDB_VPP2PP_t       vf_ldb_vpp2pp;
    VF_DIR_VPP_V_t        vf_dir_vpp_v;
    VF_LDB_VPP_V_t        vf_ldb_vpp_v;
    DIR_PP_V_t            dir_pp_v;
    LDB_PP_V_t            ldb_pp_v;
    VF_DIR_VQID2QID_t     vf_dir_vqid2qid;
    VF_LDB_VQID2QID_t     vf_ldb_vqid2qid;
    VF_DIR_VQID_V_t       vf_dir_vqid_v;
    VF_LDB_VQID_V_t       vf_ldb_vqid_v;
    DIR_QID_ITS_t         dir_qid_its;
    LDB_QID_ITS_t         ldb_qid_its;
    DIR_QID_V_t           dir_qid_v;
    LDB_QID_V_t           ldb_qid_v;
    LDB_VASQID_V_t        ldb_vasqid_v;
    DIR_VASQID_V_t        dir_vasqid_v;
    LDB_PP2VAS_t          ldb_pp2vas;
    DIR_PP2VAS_t          dir_pp2vas;
    LDB_QID_CFG_V_t       ldb_qid_cfg_v;
  } hqm_system_ingress_cfg_data_t;
  
  typedef struct packed {
    logic                 ldb_qid2vqid;
    logic                 ldb_cq_pasid;
    logic                 ldb_cq_addr_l;
    logic                 ldb_cq_addr_u;
    logic                 ldb_cq2vf_pf_ro;
    logic                 dir_cq_pasid;
    logic                 dir_cq_addr_l;
    logic                 dir_cq_addr_u;
    logic                 dir_cq2vf_pf_ro;
    logic                 dir_cq_fmt;
  } hqm_system_egress_cfg_signal_t;
  
  typedef struct packed {
    LDB_QID2VQID_t        ldb_qid2vqid;
    LDB_CQ_PASID_t        ldb_cq_pasid;
    LDB_CQ_ADDR_L_t       ldb_cq_addr_l;
    LDB_CQ_ADDR_U_t       ldb_cq_addr_u;
    LDB_CQ2VF_PF_RO_t     ldb_cq2vf_pf_ro;
    DIR_CQ_PASID_t        dir_cq_pasid;
    DIR_CQ_ADDR_L_t       dir_cq_addr_l;
    DIR_CQ_ADDR_U_t       dir_cq_addr_u;
    DIR_CQ2VF_PF_RO_t     dir_cq2vf_pf_ro;
    DIR_CQ_FMT_t          dir_cq_fmt;
  } hqm_system_egress_cfg_data_t;

  typedef struct packed {
    logic                 sbe_cnt_0;
    logic                 sbe_cnt_1;
    logic                 alarm_hw_synd;
    logic                 alarm_pf_synd0;
    logic                 alarm_pf_synd1;
    logic                 alarm_pf_synd2;
    logic                 alarm_vf_synd0;
    logic                 alarm_vf_synd1;
    logic                 alarm_vf_synd2;
    logic                 dir_cq_isr;
    logic                 ldb_cq_isr;
    logic                 ai_addr_l;
    logic                 ai_addr_u;
    logic                 ai_data;
    logic                 msg_addr_l;
    logic                 msg_addr_u;
    logic                 msg_data;
    logic                 vector_ctrl;
  } hqm_system_alarm_cfg_signal_t;

  typedef struct packed {
    SBE_CNT_0_t           sbe_cnt_0;
    SBE_CNT_1_t           sbe_cnt_1;
    ALARM_HW_SYND_t       alarm_hw_synd;
    ALARM_PF_SYND0_t      alarm_pf_synd0;
    ALARM_PF_SYND1_t      alarm_pf_synd1;
    ALARM_PF_SYND2_t      alarm_pf_synd2;
    ALARM_VF_SYND0_t      alarm_vf_synd0;
    ALARM_VF_SYND1_t      alarm_vf_synd1;
    ALARM_VF_SYND2_t      alarm_vf_synd2;
    DIR_CQ_ISR_t          dir_cq_isr;
    LDB_CQ_ISR_t          ldb_cq_isr;
    AI_ADDR_L_t           ai_addr_l;
    AI_ADDR_U_t           ai_addr_u;
    AI_DATA_t             ai_data;
    MSG_ADDR_L_t          msg_addr_l;
    MSG_ADDR_U_t          msg_addr_u;
    MSG_DATA_t            msg_data;
    VECTOR_CTRL_t         vector_ctrl;
  } hqm_system_alarm_cfg_data_t;

  localparam HQM_SYSTEM_DEPTH_HCW_ENQ_FIFO              = 256;
  localparam HQM_SYSTEM_DWIDTH_HCW_ENQ_FIFO             = $bits(hqm_system_enq_data_in_t);
  localparam HQM_SYSTEM_AWIDTH_HCW_ENQ_FIFO             = AW_logb2(HQM_SYSTEM_DEPTH_HCW_ENQ_FIFO-1)+1;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_AWIDTH_HCW_ENQ_FIFO-1:0]          raddr;
    logic [HQM_SYSTEM_AWIDTH_HCW_ENQ_FIFO-1:0]          waddr;
    logic [HQM_SYSTEM_DWIDTH_HCW_ENQ_FIFO-1:0]          wdata;
  } hqm_system_memi_hcw_enq_fifo_t;

  typedef struct packed {
    logic [HQM_SYSTEM_DWIDTH_HCW_ENQ_FIFO-1:0]          rdata;
  } hqm_system_memo_hcw_enq_fifo_t;

  localparam HQM_SYSTEM_DEPTH_SYSTEM_CSR_RAM0           = 2048;
  localparam HQM_SYSTEM_DWIDTH_SYSTEM_CSR_RAM0          = 39;
  localparam HQM_SYSTEM_AWIDTH_SYSTEM_CSR_RAM0          = AW_logb2(HQM_SYSTEM_DEPTH_SYSTEM_CSR_RAM0-1)+1;

  typedef struct packed {
    logic                                   parity;         // 261
    logic                                   spare;          // 260
    logic                                   pad_ok;         // 259
    logic [1:0]                             cq_addr_res;    // 258:257
    logic                                   ldb;            // 256
    logic                                   ro;             // 255
    logic                                   error_parity;   // 254
    logic                                   error;          // 253
    logic [HQM_PASIDTLP_WIDTH-1:0]          pasidtlp;       // 252:230
    logic                                   is_pf;          // 229
    logic [HQM_SYSTEM_VF_WIDTH-1:0]         vf;             // 228:225
    logic                                   int_v;          // 224
    interrupt_w_req_t                       int_d;          // 223:215
    logic                                   hcw_v;          // 214
    logic [HQM_SYSTEM_CQ_WIDTH-1:0]         cq;             // 213:208
    logic [63:4]                            cq_addr;        // 207:148
    logic [1:0]                             beat;           // 147:146
    logic [1:0]                             wbo;            // 145:144
    logic [15:0]                            ecc;            // 143:128
    outbound_hcw_t                          hcw;            // 127:0
  } hqm_system_sch_out_fifo_t;

  typedef struct packed {
    logic                                   parity;
    logic                                   gen;
    logic [2:0]                             dsel1;
    logic [2:0]                             dsel0;
    logic [1:0]                             appended;
    logic                                   ldb;
    logic                                   sop;
    logic                                   eop;
    logic                                   int_v;
    interrupt_w_req_t                       int_d;
    logic                                   data_v;
    logic                                   ro;
    logic [1:0]                             spare;
    logic [HQM_PASIDTLP_WIDTH-1:0]          pasidtlp;
    logic                                   is_pf;
    logic [HQM_SYSTEM_VF_WIDTH-1:0]         vf;
    logic [2:0]                             beats;
    logic [1:0]                             cq_addr_res;
    logic [63:4]                            cq_addr;
  } hqm_system_sch_pipe_hdr_t;

  localparam HQM_SYSTEM_DEPTH_SCH_OUT_FIFO              = 128;
  localparam HQM_SYSTEM_DWIDTH_SCH_OUT_FIFO             = $bits(hqm_system_sch_out_fifo_t);
  localparam HQM_SYSTEM_AWIDTH_SCH_OUT_FIFO             = AW_logb2(HQM_SYSTEM_DEPTH_SCH_OUT_FIFO-1)+1;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_AWIDTH_SCH_OUT_FIFO-1:0]          raddr;
    logic [HQM_SYSTEM_AWIDTH_SCH_OUT_FIFO-1:0]          waddr;
    logic [HQM_SYSTEM_DWIDTH_SCH_OUT_FIFO-1:0]          wdata;
  } hqm_system_memi_sch_out_fifo_t;

  typedef struct packed {
    logic [HQM_SYSTEM_DWIDTH_SCH_OUT_FIFO-1:0]          rdata;
  } hqm_system_memo_sch_out_fifo_t;

  typedef struct packed {
    logic [15:0]                        ecc;
    outbound_hcw_t                      hcw;
  } hqm_system_wb_t;

  localparam HQM_SYSTEM_DEPTH_DIR_WB                    = NUM_DIR_CQ;
  localparam HQM_SYSTEM_DWIDTH_DIR_WB                   = $bits(hqm_system_wb_t);
  localparam HQM_SYSTEM_AWIDTH_DIR_WB                   = AW_logb2(HQM_SYSTEM_DEPTH_DIR_WB-1)+1;

  localparam HQM_SYSTEM_DEPTH_LDB_WB                    = NUM_LDB_CQ;
  localparam HQM_SYSTEM_DWIDTH_LDB_WB                   = $bits(hqm_system_wb_t);
  localparam HQM_SYSTEM_AWIDTH_LDB_WB                   = AW_logb2(HQM_SYSTEM_DEPTH_LDB_WB-1)+1;

  localparam HQM_SYSTEM_AWIDTH_WB                       = (NUM_DIR_CQ > NUM_LDB_CQ) ? HQM_SYSTEM_AWIDTH_DIR_WB : HQM_SYSTEM_AWIDTH_LDB_WB;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_AWIDTH_DIR_WB-1:0]                raddr;
    logic [HQM_SYSTEM_AWIDTH_DIR_WB-1:0]                waddr;
    logic [HQM_SYSTEM_DWIDTH_DIR_WB-1:0]                wdata;
  } hqm_system_memi_dir_wb_t;

  typedef struct packed {
    logic [HQM_SYSTEM_DWIDTH_DIR_WB-1:0]                rdata;
  } hqm_system_memo_dir_wb_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_AWIDTH_LDB_WB-1:0]                raddr;
    logic [HQM_SYSTEM_AWIDTH_LDB_WB-1:0]                waddr;
    logic [HQM_SYSTEM_DWIDTH_LDB_WB-1:0]                wdata;
  } hqm_system_memi_ldb_wb_t;

  typedef struct packed {
    logic [HQM_SYSTEM_DWIDTH_LDB_WB-1:0]                rdata;
  } hqm_system_memo_ldb_wb_t;

  localparam HQM_SYSTEM_DEPTH_MSIX_TBL_WORD             = HQM_SYSTEM_NUM_MSIX;
  localparam HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD            = 32;
  localparam HQM_SYSTEM_PACK_MSIX_TBL_WORD              = 1;
  localparam HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD            = AW_logb2(HQM_SYSTEM_DEPTH_MSIX_TBL_WORD-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_MSIX_TBL_WORD           = (HQM_SYSTEM_PACK_MSIX_TBL_WORD == 1) ?
                                                          HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD :
                                                          (HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD -
                                                           (AW_logb2(HQM_SYSTEM_PACK_MSIX_TBL_WORD-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD           = (HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD *
                                                           HQM_SYSTEM_PACK_MSIX_TBL_WORD)+1;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_MSIX_TBL_WORD-1:0]        addr;
    logic [HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD-1:0]        wdata;
  } hqm_system_memi_msix_tbl_word_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD-1:0]        rdata;
  } hqm_system_memo_msix_tbl_word_t;

  localparam HQM_SYSTEM_DEPTH_MSIX_TBL_WORD3            = HQM_SYSTEM_NUM_MSIX;
  localparam HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD3           = 1;
  localparam HQM_SYSTEM_PACK_MSIX_TBL_WORD3             = 8;
  localparam HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD3           = AW_logb2(HQM_SYSTEM_DEPTH_MSIX_TBL_WORD3-1)+1;
  localparam HQM_SYSTEM_PAWIDTH_MSIX_TBL_WORD3          = (HQM_SYSTEM_PACK_MSIX_TBL_WORD3 == 1) ?
                                                          HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD3 :
                                                          (HQM_SYSTEM_AWIDTH_MSIX_TBL_WORD3 -
                                                           (AW_logb2(HQM_SYSTEM_PACK_MSIX_TBL_WORD3-1)+1));
  localparam HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD3          = (HQM_SYSTEM_DWIDTH_MSIX_TBL_WORD3 *
                                                           HQM_SYSTEM_PACK_MSIX_TBL_WORD3)+1;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_MSIX_TBL_WORD3-1:0]       addr;
    logic [HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD3-1:0]       wdata;
  } hqm_system_memi_msix_tbl_word3_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_MSIX_TBL_WORD3-1:0]       rdata;
  } hqm_system_memo_msix_tbl_word3_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_ISR-1:0]       addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_ISR-1:0]       wdata;
  } hqm_system_memi_lut_dir_cq_isr_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_ISR-1:0]       rdata;
  } hqm_system_memo_lut_dir_cq_isr_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_ISR-1:0]       addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_ISR-1:0]       wdata;
  } hqm_system_memi_lut_ldb_cq_isr_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_ISR-1:0]       rdata;
  } hqm_system_memo_lut_ldb_cq_isr_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_AI_ADDR_L-1:0] addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_AI_ADDR_L-1:0] wdata;
  } hqm_system_memi_lut_dir_cq_ai_addr_l_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_AI_ADDR_L-1:0] rdata;
  } hqm_system_memo_lut_dir_cq_ai_addr_l_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_AI_ADDR_U-1:0] addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_AI_ADDR_U-1:0] wdata;
  } hqm_system_memi_lut_dir_cq_ai_addr_u_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_AI_ADDR_U-1:0] rdata;
  } hqm_system_memo_lut_dir_cq_ai_addr_u_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_AI_ADDR_L-1:0] addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_AI_ADDR_L-1:0] wdata;
  } hqm_system_memi_lut_ldb_cq_ai_addr_l_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_AI_ADDR_L-1:0] rdata;
  } hqm_system_memo_lut_ldb_cq_ai_addr_l_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_AI_ADDR_U-1:0] addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_AI_ADDR_U-1:0] wdata;
  } hqm_system_memi_lut_ldb_cq_ai_addr_u_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_AI_ADDR_U-1:0] rdata;
  } hqm_system_memo_lut_ldb_cq_ai_addr_u_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_DIR_CQ_AI_DATA-1:0]   addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_AI_DATA-1:0]   wdata;
  } hqm_system_memi_lut_dir_cq_ai_data_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_DIR_CQ_AI_DATA-1:0]   rdata;
  } hqm_system_memo_lut_dir_cq_ai_data_t;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_PAWIDTH_LUT_LDB_CQ_AI_DATA-1:0]   addr;
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_AI_DATA-1:0]   wdata;
  } hqm_system_memi_lut_ldb_cq_ai_data_t;

  typedef struct packed {
    logic [HQM_SYSTEM_PDWIDTH_LUT_LDB_CQ_AI_DATA-1:0]   rdata;
  } hqm_system_memo_lut_ldb_cq_ai_data_t;

  localparam HQM_SYSTEM_DEPTH_ALARM_VF_SYND0            = NUM_VDEV;
  localparam HQM_SYSTEM_DWIDTH_ALARM_VF_SYND0           = 30;
  localparam HQM_SYSTEM_AWIDTH_ALARM_VF_SYND0           = AW_logb2(HQM_SYSTEM_DEPTH_ALARM_VF_SYND0-1)+1;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_AWIDTH_ALARM_VF_SYND0-1:0]        raddr;
    logic [HQM_SYSTEM_AWIDTH_ALARM_VF_SYND0-1:0]        waddr;
    logic [HQM_SYSTEM_DWIDTH_ALARM_VF_SYND0-1:0]        wdata;
  } hqm_system_memi_alarm_vf_synd0_t;

  typedef struct packed {
    logic [HQM_SYSTEM_DWIDTH_ALARM_VF_SYND0-1:0]        rdata;
  } hqm_system_memo_alarm_vf_synd0_t;

  localparam HQM_SYSTEM_DEPTH_ALARM_VF_SYND1            = NUM_VDEV;
  localparam HQM_SYSTEM_DWIDTH_ALARM_VF_SYND1           = 32;
  localparam HQM_SYSTEM_AWIDTH_ALARM_VF_SYND1           = AW_logb2(HQM_SYSTEM_DEPTH_ALARM_VF_SYND1-1)+1;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_AWIDTH_ALARM_VF_SYND1-1:0]        raddr;
    logic [HQM_SYSTEM_AWIDTH_ALARM_VF_SYND1-1:0]        waddr;
    logic [HQM_SYSTEM_DWIDTH_ALARM_VF_SYND1-1:0]        wdata;
  } hqm_system_memi_alarm_vf_synd1_t;

  typedef struct packed {
    logic [HQM_SYSTEM_DWIDTH_ALARM_VF_SYND1-1:0]        rdata;
  } hqm_system_memo_alarm_vf_synd1_t;

  localparam HQM_SYSTEM_DEPTH_ALARM_VF_SYND2            = NUM_VDEV;
  localparam HQM_SYSTEM_DWIDTH_ALARM_VF_SYND2           = 32;
  localparam HQM_SYSTEM_AWIDTH_ALARM_VF_SYND2           = AW_logb2(HQM_SYSTEM_DEPTH_ALARM_VF_SYND2-1)+1;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_AWIDTH_ALARM_VF_SYND2-1:0]        raddr;
    logic [HQM_SYSTEM_AWIDTH_ALARM_VF_SYND2-1:0]        waddr;
    logic [HQM_SYSTEM_DWIDTH_ALARM_VF_SYND2-1:0]        wdata;
  } hqm_system_memi_alarm_vf_synd2_t;

  typedef struct packed {
    logic [HQM_SYSTEM_DWIDTH_ALARM_VF_SYND2-1:0]        rdata;
  } hqm_system_memo_alarm_vf_synd2_t;

  localparam HQM_SYSTEM_NUM_ROB_MEM_DEPTH               = HQM_SYSTEM_NUM_ROB_PPS*HQM_SYSTEM_NUM_ROB_CLS*4;
  localparam HQM_SYSTEM_NUM_ROB_MEM_DWIDTH              = $bits(hqm_system_enq_data_rob_t);
  localparam HQM_SYSTEM_NUM_ROB_MEM_AWIDTH              = AW_logb2(HQM_SYSTEM_NUM_ROB_MEM_DEPTH-1)+1;

  typedef struct packed {
    logic                                               re;
    logic                                               we;
    logic [HQM_SYSTEM_NUM_ROB_MEM_AWIDTH-1:0]           addr;
    logic [HQM_SYSTEM_NUM_ROB_MEM_DWIDTH-1:0]           wdata;
  } hqm_system_memi_rob_mem_t;

  typedef struct packed {
    logic [HQM_SYSTEM_NUM_ROB_MEM_DWIDTH-1:0]           rdata;
  } hqm_system_memo_rob_mem_t;

  typedef enum logic [4:0] {
     SCH_SM_IDLE        ='h01
    ,SCH_SM_LDB_PAD     ='h02
    ,SCH_SM_DIR         ='h04
    ,SCH_SM_DIR_PAD     ='h08
    ,SCH_SM_OPTA        ='h10
  } hqm_system_sch_sm_state_t;

  `define HQM_SYSTEM_SCH_SM_IDLE    0
  `define HQM_SYSTEM_SCH_SM_LDB_PAD 1
  `define HQM_SYSTEM_SCH_SM_DIR     2
  `define HQM_SYSTEM_SCH_SM_DIR_PAD 3
  `define HQM_SYSTEM_SCH_SM_OPTA    4

  typedef struct packed {
    logic                               parity;
    logic                               cq_v;
    logic                               cq_ldb;
    logic [HQM_SYSTEM_CQ_WIDTH-1:0]     cq;
    logic [1:0]                         tc_sel;
    logic                               poll;
    logic                               ai;
    logic [1:0]                         addr_res;
    logic [63:2]                        addr;
    logic                               data_par;
    logic [31:0]                        data;
  } hqm_system_ims_msix_w_t;

  typedef struct packed {
    aw_alarm_msix_map_t                 msix_map;
    logic [5:0]                         aid;
    logic                               is_ldb_port;
    logic                               is_pf;
    logic [HQM_SYSTEM_VDEV_WIDTH-1:0]   vdev;
    logic [HQM_SYSTEM_DIR_PP_WIDTH-1:0] vpp;
    inbound_hcw_noptr_t                 hcw;
  } hqm_system_ingress_alarm_t;

  localparam HQMEP_FUSES_DEFAULT_VALUES = {
                                               8'h00    // [  15:   8] revision_id
                                           ,   6'd0     // [   7:   2] hqm_spare
                                           ,   1'd0     // [   1:   1] force_on
                                           ,   1'd0     // [   0:   0] proc_disable
  };

endpackage: hqm_system_pkg

