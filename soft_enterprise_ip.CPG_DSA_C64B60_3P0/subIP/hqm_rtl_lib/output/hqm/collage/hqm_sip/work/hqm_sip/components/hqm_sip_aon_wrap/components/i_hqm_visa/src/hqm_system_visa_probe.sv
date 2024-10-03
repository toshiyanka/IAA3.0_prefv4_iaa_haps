//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
// hqm_system_visa_probe
//
// This module is responsible for flopping top-level hqm_core signals.
// The flopped values are demuxed and output as 1 32-bit bus.
//
//-----------------------------------------------------------------------------------------------------

module hqm_system_visa_probe

// synopsys translate_off

  import hqm_AW_pkg::*, hqm_pkg::*;

// synopsys translate_on

(
  input  logic                        clk

, input  logic [ ( 30) -1 : 0 ]       hqm_system_visa_str
`include "hqm_system_visa_probe.VISA_IT.hqm_system_visa_probe.port_defs.sv" // Auto Included by VISA IT - *** Do not modify this line ***


);

 
 `include "hqm_system_visa_probe.VISA_IT.hqm_system_visa_probe.wires.sv" // Auto Included by VISA IT - *** Do not modify this line ***
 typedef struct packed {

    logic           ingress_alarm_is_ldb_port;                     // 29
    logic           ingress_alarm_is_pf;                           // 28
    logic   [3:0]   ingress_alarm_vf;                              // 27:24

    logic           ingress_alarm_v2;                              // 23
    logic           ingress_alarm_v;                               // 22
    logic   [5:0]   ingress_alarm_aid;                             // 21:16

    logic           msi_msix_w_v;                                  // 15
    logic           msi_msix_w_is_pf;                              // 14
    logic   [3:0]   msi_msix_w_vf;                                 // 13:12
    logic   [1:0]   msi_msix_w_data_1_0;                           // 9:8

    logic           hqm_idle_q2;                                   // 7
    logic           hqm_idle_q;                                    // 6
    logic           hqm_unit_idle_q_and;                           // 5
    logic           sys_alarm_idle;                                // 4
    logic           sys_cfg_idle;                                  // 3
    logic           sys_wbuf_idle;                                 // 2
    logic           sys_egress_idle;                               // 1
    logic           sys_ingress_idle;                              // 0

  } hqm_system_visa_probe_t;


hqm_system_visa_probe_t hqm_system_visa_str_in;
hqm_system_visa_probe_t visa_capture_reg_f, visa_capture_reg_nxt ;
hqm_system_visa_probe_t hqm_system_visa_struct ;

`ifndef HQM_VISA_ELABORATE

//--------------------------------------------------------------------------------------- 
// Always block for assignments

always_comb begin
  
  // Assign input to struct
  hqm_system_visa_str_in = hqm_system_visa_str ; 

  // Default value of nxt for flop
  visa_capture_reg_nxt = hqm_system_visa_str_in ;

end

//---------------------------------------------------------------------------------------
// Flops

always_ff @(posedge clk) begin

  visa_capture_reg_f <= visa_capture_reg_nxt ;

end

//---------------------------------------------------------------------------------------

always_comb begin
  
    hqm_system_visa_struct.ingress_alarm_is_ldb_port=    visa_capture_reg_f.ingress_alarm_is_ldb_port; // 29
    hqm_system_visa_struct.ingress_alarm_is_pf      =    visa_capture_reg_f.ingress_alarm_is_pf;       // 28
    hqm_system_visa_struct.ingress_alarm_vf         =    visa_capture_reg_f.ingress_alarm_vf;          // 27:24
                                                                                                 
    hqm_system_visa_struct.ingress_alarm_v2         =    visa_capture_reg_f.ingress_alarm_v2;          // 23
    hqm_system_visa_struct.ingress_alarm_v          =    visa_capture_reg_f.ingress_alarm_v;           // 22
    hqm_system_visa_struct.ingress_alarm_aid        =    visa_capture_reg_f.ingress_alarm_aid;         // 21:16
                                                                                                 
    hqm_system_visa_struct.msi_msix_w_v             =    visa_capture_reg_f.msi_msix_w_v;              // 15
    hqm_system_visa_struct.msi_msix_w_is_pf         =    visa_capture_reg_f.msi_msix_w_is_pf;          // 14
    hqm_system_visa_struct.msi_msix_w_vf            =    visa_capture_reg_f.msi_msix_w_vf;             // 13:12
    hqm_system_visa_struct.msi_msix_w_data_1_0      =    visa_capture_reg_f.msi_msix_w_data_1_0;       // 9:8
                                                                                                 
    hqm_system_visa_struct.hqm_idle_q2              =    visa_capture_reg_f.hqm_idle_q2;               // 7
    hqm_system_visa_struct.hqm_idle_q               =    visa_capture_reg_f.hqm_idle_q;                // 6
    hqm_system_visa_struct.hqm_unit_idle_q_and      =    visa_capture_reg_f.hqm_unit_idle_q_and;       // 5
    hqm_system_visa_struct.sys_alarm_idle           =    visa_capture_reg_f.sys_alarm_idle;            // 4
    hqm_system_visa_struct.sys_cfg_idle             =    visa_capture_reg_f.sys_cfg_idle;              // 3
    hqm_system_visa_struct.sys_wbuf_idle            =    visa_capture_reg_f.sys_wbuf_idle;             // 2
    hqm_system_visa_struct.sys_egress_idle          =    visa_capture_reg_f.sys_egress_idle;           // 1
    hqm_system_visa_struct.sys_ingress_idle         =    visa_capture_reg_f.sys_ingress_idle;          // 0

end 

`endif

//---------------------------------------------------------------------------------------


`include "hqm_system_visa_probe.VISA_IT.hqm_system_visa_probe.logic.sv" // Auto Included by VISA IT - *** Do not modify this line ***
endmodule // hqm_system_visa_probe
