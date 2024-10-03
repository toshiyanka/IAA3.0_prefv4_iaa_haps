//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//  Collateral Description:
//  dteg-stap
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_sTAP_2020WW05_RTL1P0_PIC6_V1
//
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

 stap_bscan_assertions #(.BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION             (BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION),
                        .BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION         (BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION),
                        .BSCAN_STAP_ADDRESS_OF_CLAMP                   (BSCAN_STAP_ADDRESS_OF_CLAMP),
                        .BSCAN_STAP_NUMBER_OF_PRELOAD_REGISTERS        (BSCAN_STAP_NUMBER_OF_PRELOAD_REGISTERS),
                        .BSCAN_STAP_NUMBER_OF_CLAMP_REGISTERS          (BSCAN_STAP_NUMBER_OF_CLAMP_REGISTERS),
                        .BSCAN_STAP_NUMBER_OF_INTEST_REGISTERS         (BSCAN_STAP_NUMBER_OF_INTEST_REGISTERS),
                        .BSCAN_STAP_NUMBER_OF_RUNBIST_REGISTERS        (BSCAN_STAP_NUMBER_OF_RUNBIST_REGISTERS),
                        .BSCAN_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS  (BSCAN_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
                        .BSCAN_STAP_ADDRESS_OF_SAMPLE_PRELOAD          (BSCAN_STAP_ADDRESS_OF_SAMPLE_PRELOAD),
                        .BSCAN_STAP_ADDRESS_OF_PRELOAD                 (BSCAN_STAP_ADDRESS_OF_PRELOAD),
                        .BSCAN_STAP_ADDRESS_OF_INTEST                  (BSCAN_STAP_ADDRESS_OF_INTEST),
                        .BSCAN_STAP_ADDRESS_OF_RUNBIST                 (BSCAN_STAP_ADDRESS_OF_RUNBIST),
                        .BSCAN_STAP_ADDRESS_OF_HIGHZ                   (BSCAN_STAP_ADDRESS_OF_HIGHZ),
                        .BSCAN_STAP_ADDRESS_OF_EXTEST                  (BSCAN_STAP_ADDRESS_OF_EXTEST),
                        .BSCAN_STAP_ADDRESS_OF_RESIRA                  (BSCAN_STAP_ADDRESS_OF_RESIRA),
                        .BSCAN_STAP_ADDRESS_OF_RESIRB                  (BSCAN_STAP_ADDRESS_OF_RESIRB),
                        .BSCAN_STAP_ADDRESS_OF_EXTEST_TOGGLE           (BSCAN_STAP_ADDRESS_OF_EXTEST_TOGGLE),
                        .BSCAN_STAP_ADDRESS_OF_EXTEST_PULSE            (BSCAN_STAP_ADDRESS_OF_EXTEST_PULSE),
                        .BSCAN_STAP_ADDRESS_OF_EXTEST_TRAIN            (BSCAN_STAP_ADDRESS_OF_EXTEST_TRAIN)
                       )
         i_stap_bscan_assertions
     (
                        .ftap_tck                                      (ftap_tck),
                        .stap_fbscan_capturedr                         (stap_fbscan_capturedr),
                        .powergood_rst_trst_b                          (powergood_rst_trst_b),
                        .stap_fbscan_shiftdr                           (stap_fbscan_shiftdr),
                        .stap_fbscan_updatedr                          (stap_fbscan_updatedr),
                        .stap_fbscan_updatedr_clk                      (stap_fbscan_updatedr_clk),
                        .stap_fsm_tlrs                                 (stap_fsm_tlrs),
                        .stap_fbscan_mode                              (stap_fbscan_mode),
                        .stap_fbscan_highz                             (stap_fbscan_highz),
                        .stap_fbscan_chainen                           (stap_fbscan_chainen),
                        .stap_fbscan_extogen                           (stap_fbscan_extogen),
                        .stap_fbscan_extogsig_b                        (stap_fbscan_extogsig_b),
                        .stap_fbscan_d6select                          (stap_fbscan_d6select),
                        .stap_fbscan_d6init                            (stap_fbscan_d6init),
                        .stap_fbscan_d6actestsig_b                     (stap_fbscan_d6actestsig_b),
                        .stap_irreg_ireg                               (stap_irreg_ireg),
                        .inst_extest                                   (inst_extest),
                        .inst_sampre                                   (inst_sampre),
                        .stap_fsm_capture_dr                           (stap_fsm_capture_dr),
                        .stap_fsm_rti                                  (stap_fsm_rti),
                        .inst_extest_train                             (inst_extest_train),
                        .e1dr_or_e2dr                                  (e1dr_or_e2dr),
                        .inst_extest_pulse                             (inst_extest_pulse),
                        .inst_clamp                                    (inst_clamp),
                        .inst_highz                                    (inst_highz),
                        .inst_preload                                  (inst_preload),
                        .inst_intest                                   (inst_intest),
                        .train_or_pulse                                (train_or_pulse)
     );

