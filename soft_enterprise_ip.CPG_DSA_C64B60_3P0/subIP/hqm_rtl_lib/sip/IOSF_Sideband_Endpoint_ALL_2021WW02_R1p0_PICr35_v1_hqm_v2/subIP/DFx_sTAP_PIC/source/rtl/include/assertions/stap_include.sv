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

    logic [15:0] stap_fsm_state_ps;
    logic stap_bscan_select_bscan_internal;
    assign stap_fsm_state_ps =  i_stap_fsm.state_ps;
    generate
             if (STAP_ENABLE_BSCAN === 1)
                begin:generate_chk_bscan_sel
                   assign stap_bscan_select_bscan_internal = generate_stap_bscan.i_stap_bscan.select_bscan_internal;
                   //assign gen_select_bscan_internal = stap_bscan_select_bscan_internal;
                end
             else
                begin
                   assign stap_bscan_select_bscan_internal = LOW;
                end
          endgenerate


    stap_top_assertions #(
    //`include "stap_params_include.inc"
    .STAP_SIZE_OF_EACH_INSTRUCTION                        (STAP_SIZE_OF_EACH_INSTRUCTION                     ),
    .STAP_SWCOMP_ACTIVE                                   (STAP_SWCOMP_ACTIVE                                ),
    .STAP_SWCOMP_NUM_OF_COMPARE_BITS                      (STAP_SWCOMP_NUM_OF_COMPARE_BITS                   ),
    .STAP_ENABLE_TDO_POS_EDGE                             (STAP_ENABLE_TDO_POS_EDGE                          ),
    .STAP_ENABLE_BSCAN                                    (STAP_ENABLE_BSCAN                                 ),
    .STAP_NUMBER_OF_MANDATORY_REGISTERS                   (STAP_NUMBER_OF_MANDATORY_REGISTERS                ),
    .STAP_SECURE_GREEN                                    (STAP_SECURE_GREEN                                 ),
    .STAP_SECURE_ORANGE                                   (STAP_SECURE_ORANGE                                ),
    .STAP_SECURE_RED                                      (STAP_SECURE_RED                                   ),
    .STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                   (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                ),
    .STAP_DFX_SECURE_POLICY_SELECTREG                     (STAP_DFX_SECURE_POLICY_SELECTREG                  ),
    .STAP_ENABLE_TAPC_REMOVE                              (STAP_ENABLE_TAPC_REMOVE                           ),
    .STAP_NUMBER_OF_WTAPS_IN_NETWORK                      (STAP_NUMBER_OF_WTAPS_IN_NETWORK                   ),
    .STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL   (STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL),
    .STAP_ENABLE_WTAP_CTRL_POS_EDGE                       (STAP_ENABLE_WTAP_CTRL_POS_EDGE                    ),
    .STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS            (STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS         ),
    .STAP_ENABLE_RTDR_PROG_RST                            (STAP_ENABLE_RTDR_PROG_RST                         ),
    .STAP_RTDR_IS_BUSSED                                  (STAP_RTDR_IS_BUSSED                               ),
    .STAP_NUMBER_OF_TEST_DATA_REGISTERS                   (STAP_NUMBER_OF_TEST_DATA_REGISTERS                ),
    .STAP_ENABLE_ITDR_PROG_RST                            (STAP_ENABLE_ITDR_PROG_RST                         ),
    .STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS              (STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS           ),
    .STAP_NUMBER_OF_TOTAL_REGISTERS                       (STAP_NUMBER_OF_TOTAL_REGISTERS                    ),
    .STAP_INSTRUCTION_FOR_DATA_REGISTERS                  (STAP_INSTRUCTION_FOR_DATA_REGISTERS               ),
    .STAP_NUMBER_OF_BITS_FOR_SLICE                        (STAP_NUMBER_OF_BITS_FOR_SLICE                     ),
    .STAP_SIZE_OF_EACH_TEST_DATA_REGISTER                 (STAP_SIZE_OF_EACH_TEST_DATA_REGISTER              ),
    .STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS               (STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS            ),
    .STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS               (STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS            ),
    .STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS             (STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS          ),  
    .STAP_DFX_SECURE_POLICY_MATRIX                        (STAP_DFX_SECURE_POLICY_MATRIX                     ),
    .STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ                   (STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ                ),
    .STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2                    (STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2                 ),
    .STAP_ENABLE_WTAP_NETWORK                             (STAP_ENABLE_WTAP_NETWORK                          ),
    .STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ                (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ             ),
    .STAP_ENABLE_TAP_NETWORK                              (STAP_ENABLE_TAP_NETWORK                           ),
    .STAP_ENABLE_TAPC_SEC_SEL                             (STAP_ENABLE_TAPC_SEC_SEL                          ),
    .STAP_ENABLE_TEST_DATA_REGISTERS                      (STAP_ENABLE_TEST_DATA_REGISTERS                   ),
    .STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS               (STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS            ) 
    )
    i_stap_top_assertions(
    
    .stap_fsm_tlrs                                        (stap_fsm_tlrs                                     ), 
    .sn_fwtap_capturewr                                   (sn_fwtap_capturewr                                ), 
    .sn_fwtap_shiftwr                                     (sn_fwtap_shiftwr                                  ), 
    .ftap_tms                                             (ftap_tms                                          ), 
    .ftap_tdi                                             (ftap_tdi                                          ), 
    .ftap_tck                                             (ftap_tck                                          ), 
    .ftap_trst_b                                          (ftap_trst_b                                       ), 
    .tapc_wtap_sel                                        (tapc_wtap_sel                                     ), 
    .fdfx_powergood                                       (fdfx_powergood                                    ), 
    .stap_fsm_shift_ir                                    (stap_fsm_shift_ir                                 ), 
    .stap_fsm_shift_dr                                    (stap_fsm_shift_dr                                 ), 
    .atap_tdo                                             (atap_tdo                                          ), 
    .atap_tdoen                                           (atap_tdoen                                        ), 
    .tapc_remove                                          (tapc_remove                                       ),  
    .powergood_rst_trst_b                                 (powergood_rst_trst_b                              ), 
    .sntapnw_atap_tdo_en                                  (sntapnw_atap_tdo_en                               ), 
    .sn_fwtap_selectwir                                   (sn_fwtap_selectwir                                ), 
    .stap_selectwir                                       (stap_selectwir                                    ), 
    .stap_fbscan_runbist_en                               (stap_fbscan_runbist_en                            ), 
    .sn_fwtap_wsi                                         (sn_fwtap_wsi                                      ), 
    .tapc_select                                          (tapc_select                                       ), 
    .stap_mux_tdo                                         (stap_mux_tdo                                      ), 
    .stap_wtapnw_tdo                                      (stap_wtapnw_tdo                                   ), 
    .stap_abscan_tdo                                      (stap_abscan_tdo                                   ), 
    .sntapnw_atap_tdo                                     (sntapnw_atap_tdo                                  ), 
    .sn_awtap_wso                                         (sn_awtap_wso                                      ), 
    .sftapnw_ftap_enabletap                               (sftapnw_ftap_enabletap                            ), 
    .sftapnw_ftap_enabletdo                               (sftapnw_ftap_enabletdo                            ), 
    .stap_irreg_ireg                                      (stap_irreg_ireg                                   ), 
    .tdr_data_out                                         (tdr_data_out                                      ), 
    .tdr_data_in                                          (tdr_data_in                                       ), 
    .sftapnw_ftap_secsel                                  (sftapnw_ftap_secsel                               ),  
    .sntapnw_atap_tdo2_en                                 (sntapnw_atap_tdo2_en                              ), 
    .rtdr_tap_tdo                                         (rtdr_tap_tdo                                      ), 
    .tap_rtdr_irdec                                       (tap_rtdr_irdec                                    ), 
    .tap_rtdr_prog_rst_b                                  (tap_rtdr_prog_rst_b                               ), 
    .tap_rtdr_tdi                                         (tap_rtdr_tdi                                      ), 
    .tap_rtdr_capture                                     (tap_rtdr_capture                                  ), 
    .tap_rtdr_shift                                       (tap_rtdr_shift                                    ), 
    .tap_rtdr_update                                      (tap_rtdr_update                                   ), 
    .stap_fsm_state_ps                                    (stap_fsm_state_ps                                 ),
    .sntapnw_ftap_tdi                                     (sntapnw_ftap_tdi                                  ),
    .stap_bscan_select_bscan_internal                     (stap_bscan_select_bscan_internal                  ) 
    );
          
