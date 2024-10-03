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

module hqm_visa_mux2
// collage-pragma translate_off

     import hqm_core_pkg::*, hqm_sif_pkg::*;

// collage-pragma translate_on


(

     input  logic                     fvisa_frame_vcfn
    ,input  logic                     fvisa_serdata_vcfn
    ,input  logic                     fvisa_serstb_vcfn
    ,input  logic [8:0]               fvisa_startid2_vcfn

    ,input  logic                     powergood_rst_b
    

    ,input  logic                     visa_all_dis
    ,input  logic                     visa_customer_dis

    ,output logic [7:0]               avisa_dbgbus2_vcfn

    // hqm_master_core_visa related

    , input  logic                    side_clk

    // CLK
    , input  logic                    wd_clkreq
    , input  logic                    hqm_cfg_master_clkreq_b

    // RST
    , input  logic                    side_rst_b
    , input  logic                    prim_gated_rst_b
    , input  logic                    hqm_gated_rst_b
    , input  logic                    hqm_clk_rptr_rst_b
    , input  logic                    hqm_pwrgood_rst_b

    // PM_UNIT INTF
    , input  logic                    prochot
    , input  logic [31:0]             master_ctl
    , input  logic                    pgcb_isol_en_b
    , input  logic                    pgcb_isol_en

    // FET INTF
    , input  logic                    pgcb_fet_en_b
    , input  logic                    pgcb_fet_en_ack_b
    , input  logic                    pgcb_fet_en_ack_b_sys  //VISA_ONLY
    , input  logic                    pgcb_fet_en_ack_b_qed  //VISA_ONLY

    // DFX INTF
    , input  logic                    cdc_hqm_jta_force_clkreq
    , input  logic                    cdc_hqm_jta_clkgate_ovrd
 
    , input  logic                    fscan_mode

);

// collage-pragma translate_off

// pgcbunit visa signals

`ifndef HQM_VISA_ELABORATE


`include "hqm_visa_mux2.VISA_IT.hqm_visa_mux2.wires.sv" // Auto Included by VISA IT - *** Do not modify this line ***
hqm_master_visa_block i_hqm_master_visa_block (
`include "hqm_visa_mux2.VISA_IT.hqm_visa_mux2.inst.i_hqm_master_visa_block.sv" // Auto Included by VISA IT - *** Do not modify this line ***

  .side_clk ( side_clk )
, .wd_clkreq ( wd_clkreq )
, .hqm_cfg_master_clkreq_b ( hqm_cfg_master_clkreq_b )
, .side_rst_b ( side_rst_b )                               
, .prim_gated_rst_b ( prim_gated_rst_b )

, .hqm_gated_rst_b ( hqm_gated_rst_b )
, .hqm_clk_rptr_rst_b ( hqm_clk_rptr_rst_b )               
, .hqm_pwrgood_rst_b ( hqm_pwrgood_rst_b )                 
, .prochot ( prochot )                                     
, .master_ctl ( master_ctl )
, .pgcb_isol_en_b ( pgcb_isol_en_b )                       
, .pgcb_isol_en ( pgcb_isol_en )                           
, .pgcb_fet_en_b ( pgcb_fet_en_b )                         
, .pgcb_fet_en_ack_b ( pgcb_fet_en_ack_b )                 
, .pgcb_fet_en_ack_b_sys ( pgcb_fet_en_ack_b_sys )         
, .pgcb_fet_en_ack_b_qed ( pgcb_fet_en_ack_b_qed )         
, .cdc_hqm_jta_force_clkreq ( cdc_hqm_jta_force_clkreq )   
, .cdc_hqm_jta_clkgate_ovrd ( cdc_hqm_jta_clkgate_ovrd )   
) ;

`endif

// collage-pragma translate_on


`include "hqm_visa_mux2.VISA_IT.hqm_visa_mux2.logic.sv" // Auto Included by VISA IT - *** Do not modify this line ***
endmodule // hqm_visa_mux2
