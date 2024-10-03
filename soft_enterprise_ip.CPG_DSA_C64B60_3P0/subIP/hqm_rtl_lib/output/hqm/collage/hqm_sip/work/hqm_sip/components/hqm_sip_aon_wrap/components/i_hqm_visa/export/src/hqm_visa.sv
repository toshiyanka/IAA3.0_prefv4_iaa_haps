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

module hqm_visa
// synopsys translate_off

     import hqm_core_pkg::*, hqm_sif_pkg::*;

// synopsys translate_on

#(

     // Name:         HQM_DTF_TO_CNT_THRESHOLD
     // Default:      1000
     // Values:       -2147483648, ..., 2147483647
     parameter HQM_DTF_TO_CNT_THRESHOLD = 1000,
// Name:         HQM_DTF_DATA_WIDTH
// Default:      64
// Values:       -2147483648, ..., 2147483647
parameter HQM_DTF_DATA_WIDTH = 64,
// Name:         HQM_TRIGFABWIDTH
// Default:      4
// Values:       -2147483648, ..., 2147483647
parameter HQM_TRIGFABWIDTH = 4,
// Name:         HQM_DVP_USE_PUSH_SWD
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_DVP_USE_PUSH_SWD = 0,
// Name:         HQM_DVP_USE_LEGACY_TIMESTAMP
// Default:      0
// Values:       -2147483648, ..., 2147483647
parameter HQM_DVP_USE_LEGACY_TIMESTAMP = 0,
// Name:         HQM_DTF_HEADER_WIDTH
// Default:      25 
//               ((HQM_DTF_DATA_WIDTH==8)?4:((HQM_DTF_DATA_WIDTH==16)?7:((HQM_DTF_DATA_WIDTH==32)?13:25)))
// Values:       -2147483648, ..., 2147483647
parameter HQM_DTF_HEADER_WIDTH = 25
) (

     input  logic                     fvisa_frame_vcfn
    ,input  logic                     fvisa_serdata_vcfn
    ,input  logic                     fvisa_serstb_vcfn
    ,input  logic [8:0]               fvisa_startid0_vcfn
    ,input  logic [8:0]               fvisa_startid1_vcfn
    ,input  logic [8:0]               fvisa_startid2_vcfn
    ,input  logic [8:0]               fvisa_startid3_vcfn

    ,input  logic                     prim_freerun_clk
    ,input  logic                     powergood_rst_b
    

    ,input  logic                     visa_all_dis
    ,input  logic                     visa_customer_dis

    ,output logic [7:0]               avisa_dbgbus0_vcfn
    ,output logic [7:0]               avisa_dbgbus1_vcfn
    ,output logic [7:0]               avisa_dbgbus2_vcfn
    ,output logic [7:0]               avisa_dbgbus3_vcfn

    ,input  logic [679:0]             hqm_sif_visa              // sif visa
 

    ,input  logic                     pgcb_clk                  // clock for visa reference  pgcbunit, cdc

    ,input  logic [23:0]              hqm_cdc_visa              // ClockDomain controller visa	
    ,input  logic [23:0]              hqm_pgcbunit_visa         // pgcbunit visa
    ,input  logic [31:0]              hqm_pmsm_visa             // pm_unit visa

    ,input  logic                     clk                       // hqm_system_visa_probe clk
    ,input  logic [29:0]              hqm_system_visa_str       // hqm_system_visa_probe probes

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
 

    , input  logic                    hqm_fullrate_clk
    , input  logic [ ( 260 ) -1 : 0 ] hqm_core_visa_str
    , input  logic                    fscan_byprst_b
    , input  logic                    fscan_rstbypen
    , input  logic                    fscan_mode

    // DVP interface will ultimately replace visa

// Type of DVP Building Block	DVP_NUMPKTSTREAMS	DVP_NUMBYTELANES	DVP_USE_LOCAL_CLOCK	DVP_STANDALONE_TOP	DVP_NO_COMPRESSION	DVP_MTSQ_IS_PRESENT	DVP_NGVISA	DVP_LEGACY_VRC	DVP_ASYNC_SUPPORT	DVP_ASYNC_PACKETIZATION
// Standard DVP	1-2 (no async) or 2-3 (w/ async)	2 to 16	1	0	0	1	1	0	0 or 1	0 or 1

    ,input  logic                               fdtf_clk                    // DTF clock
    ,input  logic                               fdtf_cry_clk                // DTF crystal clock
    ,input  logic                               fdtf_rst_b                  // DTF async reset

    ,input  logic                               pma_safemode

    // DTF Misc

    ,input  logic                               fdtf_survive_mode
    ,input  logic [1:0]                         fdtf_fast_cnt_width
    ,input  logic [7:0]                         fdtf_packetizer_mid         // Major   ID strap
    ,input  logic [7:0]                         fdtf_packetizer_cid         // Channel ID strap

    // DTF interface

    ,output logic [HQM_DTF_HEADER_WIDTH-1:0]    adtf_dnstream_header        // DTF header
    ,output logic [HQM_DTF_DATA_WIDTH-1:0]      adtf_dnstream_data          // DTF data
    ,output logic                               adtf_dnstream_valid         // DTF valid
    ,input  logic                               fdtf_upstream_credit        // DTF credit return
    ,input  logic                               fdtf_upstream_active        // DTF active
    ,input  logic                               fdtf_upstream_sync          // DTF sync

    // Timestamp

    ,input  logic                               fdtf_serial_download_tsc    // DVP serial timestamp
    ,input  logic [15:0]                        fdtf_tsc_adjustment_strap   // DVP timestamp adjust strap

    ,input  logic                               fdtf_timestamp_valid        // DVP parallel timestamp valid
    ,input  logic [55:0]                        fdtf_timestamp_value        // DVP parallel timestamp

    ,input  logic                               fdtf_force_ts

    // CTF Fabric

    ,input  logic [HQM_TRIGFABWIDTH-1:0]        ftrig_fabric_in             // Upstream trigger fabric
    ,output logic [HQM_TRIGFABWIDTH-1:0]        atrig_fabric_in_ack         // Upstream trigger fabric ack

    ,output logic [HQM_TRIGFABWIDTH-1:0]        atrig_fabric_out            // Downstream trigger fabric
    ,input  logic [HQM_TRIGFABWIDTH-1:0]        ftrig_fabric_out_ack        // Downstream trigger fabric ack

    // APB interface

    ,input  logic [31:0]                        dvp_paddr
    ,input  logic [2:0]                         dvp_pprot
    ,input  logic                               dvp_psel
    ,input  logic                               dvp_penable
    ,input  logic                               dvp_pwrite
    ,input  logic [31:0]                        dvp_pwdata
    ,input  logic [3:0]                         dvp_pstrb

    ,output logic                               dvp_pready
    ,output logic                               dvp_pslverr
    ,output logic [31:0]                        dvp_prdata

    // DFX Secure Plugin Interface

    ,input  logic                               fdfx_powergood
    ,input  logic                               fdfx_earlyboot_debug_exit
    ,input  logic                               fdfx_policy_update
    ,input  logic [7:0]                         fdfx_security_policy
    ,input  logic [7:0]                         fdfx_debug_cap
    ,input  logic                               fdfx_debug_cap_valid
);

// synopsys translate_off

logic [7:0]               avisa_dbgbus1_vcfn_ss ;

`ifndef HQM_VISA_ELABORATE

// For now until DVP is added

always_comb begin

 adtf_dnstream_header   = '0;
 adtf_dnstream_data     = '0;
 adtf_dnstream_valid    = '0;
 atrig_fabric_in_ack    = '0;
 atrig_fabric_out       = '0;
 dvp_pready             = '0;
 dvp_pslverr            = '0;
 dvp_prdata             = '0;

end

hqm_visa_mux0 i_hqm_visa_mux0 (
  .*
);

hqm_visa_mux1 i_hqm_visa_mux1 (
  .*
, .avisa_dbgbus1_vcfn (avisa_dbgbus1_vcfn_ss)
);

hqm_visa_mux2 i_hqm_visa_mux2 (
  .*
);

hqm_visa_mux3 i_hqm_visa_mux3 (
  .*
);

hqm_AW_ss2cc #( 
  .SDELAY ( 5 )
) i_hqm_visa_AW_ss2cc (
  .powergood_rst_b    ( powergood_rst_b )
, .fscan_rstbypen     ( fscan_rstbypen )
, .fscan_byprst_b     ( fscan_byprst_b)
, .clka               ( hqm_fullrate_clk)
, .clka_data_in       ( avisa_dbgbus1_vcfn_ss )
, .clkb               ( prim_freerun_clk )
, .clkb_data_out      ( avisa_dbgbus1_vcfn )
) ;

`endif

// synopsys translate_on

endmodule // hqm_visa
