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
// This is the set of IOSF Primary parameters that is ported to the top.
//-----------------------------------------------------------------------------------------------------

         parameter MMAX_ADDR                    = 63
        ,parameter TMAX_ADDR                    = 63
        ,parameter MD_WIDTH                     = 255
        ,parameter TD_WIDTH                     = 255
        ,parameter MDP_WIDTH                    = 0
        ,parameter TDP_WIDTH                    = 0
        ,parameter AGENT_WIDTH                  = 0
        ,parameter SRC_ID_WIDTH                 = 13
        ,parameter DST_ID_WIDTH                 = 13
        ,parameter MAX_DATA_LEN                 = 9
        ,parameter SAI_WIDTH                    = 7
        ,parameter RS_WIDTH                     = 0
        ,parameter PARITY_REQUIRED              = 1
        ,parameter INACTIVE_ZERO_MODE_EN        = 1

        ,parameter MSTR_PCQ_SZ                  = 4
        ,parameter MSTR_PDQ_SZ                  = 4
        ,parameter MSTR_NPCQ_SZ                 = 4
        ,parameter MSTR_NPDQ_SZ                 = 4
        ,parameter MSTR_CPCQ_SZ                 = 4
        ,parameter MSTR_CPDQ_SZ                 = 4

        ,parameter RCDT_P                       = 4
        ,parameter RCDT_NP                      = 4
        ,parameter RCDT_CP                      = 4

        ,parameter PARQDEPTH                    = 4
        ,parameter NPARQDEPTH                   = 4
        ,parameter CPARQDEPTH                   = 4

        ,parameter MAX_CCDT                     = 5
        ,parameter MAX_DCDT                     = 7

        ,parameter TGT_PCQ_SZ                   = 4
        ,parameter TGT_PDQ_SZ                   = 4
        ,parameter TGT_NPCQ_SZ                  = 4
        ,parameter TGT_NPDQ_SZ                  = 4
        ,parameter TGT_CPCQ_SZ                  = 4
        ,parameter TGT_CPDQ_SZ                  = 4

