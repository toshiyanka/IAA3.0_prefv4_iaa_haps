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
// These are the global parameters for the IOSF SideBand EndPoint that are ported to the top.
//-----------------------------------------------------------------------------------------------------

         .SBE_DATAWIDTH                (SBE_DATAWIDTH)
        ,.SBE_NPQUEUEDEPTH             (SBE_NPQUEUEDEPTH)
        ,.SBE_PCQUEUEDEPTH             (SBE_PCQUEUEDEPTH)
        ,.SBE_ASYNCIQDEPTH             (SBE_ASYNCIQDEPTH)
        ,.SBE_ASYNCEQDEPTH             (SBE_ASYNCEQDEPTH)
        ,.SBE_PIPEISMS                 (SBE_PIPEISMS)
        ,.SBE_PIPEINPS                 (SBE_PIPEINPS)
        ,.SBE_CLKREQ_HYST_CNT          (SBE_CLKREQ_HYST_CNT)
        ,.SBE_PARITY_REQUIRED          (SBE_PARITY_REQUIRED)
        ,.SBE_DO_SERR_MASTER           (SBE_DO_SERR_MASTER)

