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
// hqm_visa
//
// This module is responsible for flopping (and synchronizing some) top-level hqm_sif signals.
//
//-----------------------------------------------------------------------------------------------------

module hqm_visa_mux3
// collage-pragma translate_off

     import hqm_core_pkg::*, hqm_sif_pkg::*;

// collage-pragma translate_on


(

     input  logic                     fvisa_frame_vcfn
    ,input  logic                     fvisa_serdata_vcfn
    ,input  logic                     fvisa_serstb_vcfn
    ,input  logic [8:0]               fvisa_startid3_vcfn

    ,input  logic                     powergood_rst_b
    

    ,input  logic                     visa_all_dis
    ,input  logic                     visa_customer_dis

    ,output logic [7:0]               avisa_dbgbus3_vcfn

    ,input  logic                     pgcb_clk                  // clock for visa reference  pgcbunit, cdc

    ,input  logic [23:0]              hqm_pgcbunit_visa         // pgcbunit visa
    ,input  logic [23:0]              hqm_cdc_visa              // ClockDomain controller visa	

    ,input  logic                     fscan_mode

);

// collage-pragma translate_off

// pgcbunit visa signals


`include "hqm_visa_mux3.VISA_IT.hqm_visa_mux3.wires.sv" // Auto Included by VISA IT - *** Do not modify this line ***
logic [2:0]   dfxseq_ps;                 // pgcbdfxfxm_visa[2:0] pgcb_clk

typedef struct packed {

logic [8:0]   spare;
logic [2:0]   dfxseq_ps_tck;             // pgcbdfxfxm_visa[2:0] pgcb_tck
logic         int_isollatch_en;          // pgcbfsm_visa[11] pgcb_clk
logic         int_sleep_en;              // pgcbfsm_visa[10] pgcb_clk
logic [1:0]   int_pg_type;               // pgcbfsm_visa[9:8] pgcb_clk
logic         sync_pmc_pgcb_restore_b;   // pgcbfsm_visa[7] pgcb_clk
logic         sync_pmc_pgcb_pg_ack_b;    // pgcbfsm_visa[6]pgcb_clk
logic         ip_pgcb_pg_rdy_req_b;      // pgcbfsm_visa[5] pgcb_clk
logic [4:0]   pgcb_ps;                   // pgcbfsm_visa[4:0] pgcb_clk

} pgcbunit_visa_probe_t;

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

pgcbunit_visa_probe_t                               pgcbunit_visa_probe;
cdc_visa_probe_t                                    cdc_visa_probe;

assign pgcbunit_visa_probe = hqm_pgcbunit_visa;
assign cdc_visa_probe = hqm_cdc_visa;

`ifndef HQM_VISA_ELABORATE

//---------------------------------------------------------------------------------------
// Synchronizers

hqm_AW_sync #(
 .WIDTH                                   ( $bits ( pgcbunit_visa_probe.dfxseq_ps_tck ) )
) i_hqm_visa_mux3_AW_sync (
  .clk                                    ( pgcb_clk )
, .data                                   ( pgcbunit_visa_probe.dfxseq_ps_tck )
, .data_sync                              ( dfxseq_ps )
);


`endif

// collage-pragma translate_on


`include "hqm_visa_mux3.VISA_IT.hqm_visa_mux3.logic.sv" // Auto Included by VISA IT - *** Do not modify this line ***
endmodule // hqm_visa_mux3
