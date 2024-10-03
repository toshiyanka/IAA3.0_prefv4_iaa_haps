// =============================================================================
// INTEL CONFIDENTIAL
// Copyright 2016 - 2016 Intel Corporation All Rights Reserved.
// The source code contained or described herein and all documents related to the source code ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material remains with Intel Corporation or its suppliers and licensors. The Material contains trade secrets and proprietary and confidential information of Intel or its suppliers and licensors. The Material is protected by worldwide copyright and trade secret laws and treaty provisions. No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted, transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
// No license under any patent, copyright, trade secret or other intellectual property right is granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by implication, inducement, estoppel or otherwise. Any license under such intellectual property rights must be express and approved by Intel in writing.
// =============================================================================

//--------------------------------------------------------------------
//
//  Author   : Khor, Hai Ming
//  Project  : DEVTLB
//  Comments : 
//
//  Functional description:
//
//--------------------------------------------------------------------

`ifndef HQM_DEVTLB_MISC_ARRAY_VS
`define HQM_DEVTLB_MISC_ARRAY_VS

`include "hqm_devtlb_pkg.vh"
`include "hqm_devtlb_array_simple.sv"

module hqm_devtlb_misc_array
import `HQM_DEVTLB_PACKAGE_NAME::*; 
#(
   parameter         logic NO_POWER_GATING  = 1'b1,
   parameter         int NUM_RD_PORTS        = 1,     // Minimum 1
   parameter         int NUM_PIPE_STAGE      = 1,     // Minimum 1
   parameter         int ENTRY               = 256,    // Minimum 1
   parameter         int ENTRY_IDW           = $clog2(ENTRY),
   parameter type    T_ENTRY                 = logic [0:0],
   parameter         logic CAM_EN            = 1,
   parameter type    T_CAMENTRY              = logic [0:0],

   parameter         logic RD_PRE_DECODE     = 0,     // Pre-decode the set addresses into a 1-hot vector to pass to the array
                                                      // This shifts the decode logic to before the clock for the read

   parameter         int ARRAY_STYLE         = ARRAY_RF      // Array Style
                                                      // 0 = LATCH Array      (gt_ram_sv)
                                                      // 1 = FPGA gram Array  (gram_sdp)
                                                      // 2 = RF Array         (customer provided)
                                                      // 3 = MSFF Array       (gt_ram_sv)

)(
    `HQM_DEVTLB_COMMON_PORTDEC_SV
    `HQM_DEVTLB_FSCAN_PORTDEC_SV
    input  logic                            PwrDnOvrd_nnnH,

`ifdef HQM_DEVTLB_EXT_MISCRF_EN  //RF-External
    output logic                                EXT_RF_CAMEn,
    output logic [$bits(T_CAMENTRY)-1:0]        EXT_RF_CAMData,
    input  logic [ENTRY-1:0]                    EXT_RF_CAMHit,

    output logic                                EXT_RF_RdEn,
    output logic [ENTRY_IDW-1:0]                EXT_RF_RdAddr,
    input  logic [$bits(T_ENTRY)-1:0]           EXT_RF_RdData,

    output logic                                EXT_RF_WrEn, 
    output logic [ENTRY_IDW-1:0]                EXT_RF_WrAddr,
    output logic [$bits(T_ENTRY)-1:0]           EXT_RF_WrData,
`endif
    
    input  logic                                WrEn,
    input  logic [ENTRY_IDW-1:0]                WrAddr,
    input  T_ENTRY                              WrData,
    
    input  logic                                RdEn,
    input  logic [ENTRY_IDW-1:0]                RdAddr,
    output T_ENTRY                              RdData,
    output logic                                Perr,
    
    input  logic                                CamEn,
    input  T_CAMENTRY                           CamData,
    output logic [ENTRY-1:0]                    CamHit
);

//-------------------------------------------------------------------------------
//  CLOCKING
//-------------------------------------------------------------------------------
   logic                                            pEn_ClkMem_H;
   logic                                            ClkMemRcb_H;

always_comb begin
    pEn_ClkMem_H = reset || CamEn || RdEn ||WrEn;
end
`HQM_DEVTLB_MAKE_LCB_PWR(ClkMemRcb_H,  clk, pEn_ClkMem_H,  PwrDnOvrd_nnnH)

   logic                                             ClkMem_H;

`HQM_DEVTLB_MAKE_LCB_PWR(ClkMem_H,  ClkMemRcb_H, pEn_ClkMem_H,  PwrDnOvrd_nnnH)

//-------------------------------------------------------------------------------

always_comb begin
    Perr   = '0; //TODO
end

`ifdef HQM_DEVTLB_EXT_MISCRF_EN  //RF-External
    generate
    if (ARRAY_STYLE == ARRAY_RF) begin: misc_rf      //RF
        always_comb begin
            EXT_RF_CAMEn  = CamEn;
            EXT_RF_CAMData = CamData;
            CamHit = EXT_RF_CAMHit;
            
            EXT_RF_RdEn = RdEn;
            EXT_RF_RdAddr = RdAddr;
            RdData = EXT_RF_RdData;
            
            EXT_RF_WrEn = WrEn;
            EXT_RF_WrAddr = WrAddr;
            EXT_RF_WrData = WrData;
        end
    end else begin : misc_nonrf //LATCH...etc
        hqm_devtlb_array_simple
        #(
            .NO_POWER_GATING(NO_POWER_GATING),
            .NUM_PIPE_STAGE(1),  //support 1 only for now
            .ENTRY(ENTRY),
            .T_ENTRY(T_ENTRY),
            .CAM_EN(CAM_EN),
            .T_CAMENTRY(T_CAMENTRY),
            .ARRAY_STYLE(ARRAY_STYLE)
        ) misc_array
        (
           `HQM_DEVTLB_COMMON_PORTCON
           `HQM_DEVTLB_FSCAN_PORTCON
            .PwrDnOvrd_nnnH         ('0),
            
            .CamEnSpec_nnnH(CamEn),
            .CamEn_nnnH(CamEn),
            .CamData_nnnH(CamData),
            .CamHit_nn1H(CamHit),
            
            .RdEnSpec_nnnH(RdEn),
            .RdEn_nnnH(RdEn),
            .RdAddr_nnnH(RdAddr),
            .RdData_nn1H(RdData),

            .WrEn_nnnH(WrEn),
            .WrAddr_nnnH(WrAddr),
            .WrData_nnnH(WrData)
        ) ;  
    end
    endgenerate
`else //RF - Internal
    hqm_devtlb_array_simple
    #(
        .NO_POWER_GATING(NO_POWER_GATING),
        .NUM_PIPE_STAGE(1),  //support 1 only for now
        .ENTRY(ENTRY),
        .T_ENTRY(T_ENTRY),
        .CAM_EN(CAM_EN),
        .T_CAMENTRY(T_CAMENTRY),
        .ARRAY_STYLE(ARRAY_STYLE)
    ) misc_array
    (
       `HQM_DEVTLB_COMMON_PORTCON
       `HQM_DEVTLB_FSCAN_PORTCON
        .PwrDnOvrd_nnnH         ('0),
        
        .CamEnSpec_nnnH(CamEn),
        .CamEn_nnnH(CamEn),
        .CamData_nnnH(CamData),
        .CamHit_nn1H(CamHit),
        
        .RdEnSpec_nnnH(RdEn),
        .RdEn_nnnH(RdEn),
        .RdAddr_nnnH(RdAddr),
        .RdData_nn1H(RdData),

        .WrEn_nnnH(WrEn),
        .WrAddr_nnnH(WrAddr),
        .WrData_nnnH(WrData)
    );
`endif //RF - Internal

endmodule

`endif //DEVTLB_MISC_ARRAY_VS

