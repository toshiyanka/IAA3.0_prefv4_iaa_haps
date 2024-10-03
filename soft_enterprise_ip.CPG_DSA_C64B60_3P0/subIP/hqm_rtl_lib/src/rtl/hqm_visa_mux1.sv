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
// hqm_visa_mux1
//
// This module is responsible for flopping (and synchronizing some) top-level hqm_sif signals.
//
//-----------------------------------------------------------------------------------------------------

module hqm_visa_mux1
// collage-pragma translate_off

     import hqm_core_pkg::*, hqm_sif_pkg::*;

// collage-pragma translate_on


(

     input  logic                     fvisa_frame_vcfn
    ,input  logic                     fvisa_serdata_vcfn
    ,input  logic                     fvisa_serstb_vcfn
    ,input  logic [8:0]               fvisa_startid1_vcfn

    ,input  logic                     hqm_fullrate_clk
    ,input  logic                     powergood_rst_b
    

    ,input  logic                     visa_all_dis
    ,input  logic                     visa_customer_dis

    ,output logic [7:0]               avisa_dbgbus1_vcfn

    ,input  logic [23:0]              hqm_cdc_visa              // ClockDomain controller visa	

    ,input  logic                     clk                       // hqm_system_visa_probe clk
    ,input  logic [29:0]              hqm_system_visa_str       // hqm_system_visa_probe probes

    ,input  logic [ ( 260 ) -1 : 0 ]  hqm_core_visa_str

    ,input  logic                     fscan_rstbypen
    ,input  logic                     fscan_byprst_b
    ,input  logic                     fscan_mode

);

// collage-pragma translate_off


`include "hqm_visa_mux1.VISA_IT.hqm_visa_mux1.wires.sv" // Auto Included by VISA IT - *** Do not modify this line ***
typedef struct packed {

logic [3:0]   cdc_spare;              
logic         locked_pg;               // cdc_pg_visa[5]     pgcb_clk
logic         force_ready_pg;          // cdc_pg_visa[4]     pgcb_clk
logic         domain_pok_pg;           // cdc_pg_visa[3]     pgcb_clk
logic         assert_clkreq_pg;        // cdc_pg_visa[2]     pgcb_clk
logic         unlock_domain_pg;        // cdc_pg_visa[1]     pgcb_clk
logic         pwrgate_ready;           // cdc_pg_visa[0]     pgcb_clk
logic         spare_cdc_main_visa;      // cdc_main_visa[13]  hqm_cdc_clk
logic         gclock_active;           // cdc_main_visa[12]   hqm_cdc_clk
logic         clkreq_hold;             // cdc_main_visa[11]   hqm_cdc_clk
logic         gclock_enable;           // cdc_main_visa[10]   hqm_cdc_clk
logic         gclock_req;              // cdc_main_visa[9]   hqm_cdc_clk
logic         do_force_pgate;          // cdc_main_visa[8]   hqm_cdc_clk
logic         timer_expired;           // cdc_main_visa[7]   hqm_cdc_clk
logic [3:0]   current_state;           // cdc_main_visa[6:3]  hqm_cdc_clk
logic         ism_wake;               // dc_main_visa[2]   hqm_cdc_clk
logic         not_idle;               // dc_main_visa[1]  hqm_cdc_clk
logic         pg_disabled;            // dc_main_visa[0]  hqm_cdc_clk

} cdc_visa_probe_t;

cdc_visa_probe_t cdc_visa_probe;
 
assign cdc_visa_probe = hqm_cdc_visa;

`ifndef HQM_VISA_ELABORATE

hqm_system_visa_probe i_hqm_system_visa_probe (
`include "hqm_visa_mux1.VISA_IT.hqm_visa_mux1.inst.i_hqm_system_visa_probe.sv" // Auto Included by VISA IT - *** Do not modify this line ***

  .*
);

hqm_core_visa_block i_hqm_core_visa_block (
`include "hqm_visa_mux1.VISA_IT.hqm_visa_mux1.inst.i_hqm_core_visa_block.sv" // Auto Included by VISA IT - *** Do not modify this line ***

  .clk (hqm_fullrate_clk)
, .fscan_rstbypen  (fscan_rstbypen)
, .fscan_byprst_b  (fscan_byprst_b)
, .hqm_core_visa_str (hqm_core_visa_str)

);

`endif

// collage-pragma translate_on


`include "hqm_visa_mux1.VISA_IT.hqm_visa_mux1.logic.sv" // Auto Included by VISA IT - *** Do not modify this line ***
endmodule // hqm_visa_mux1
