//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
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
//-- tb_top
//-----------------------------------------------------------------------------------------------------

import hqm_AW_pkg::*;
import hqm_pkg::*;
import nu_ecc_pkg::*;

import ovm_pkg::*;
import sla_pkg::*;
//import hcw_pkg::*;
import IosfPkg::*;
import JtagBfmPkg::*;

import UPF::*;
import SNPS_LP_MSG::*;




`timescale 1ns/1ps

//--------------------------------
//-- tb_top: hqm_tb_top
//--------------------------------
module hqm_tb_top #(

        `include "hqm_iosf_params_global.vh"
        ,
        `include "hqm_iosfsb_params_global.vh"


) ();

`include "std_ace_util.vic" // Has the dump_hier() routine in it, needed for FEBE tophiergen

logic                           clock;
logic [31:0]					eot_status='h_0;
logic [31:0]					eot_chk_status='h_0;
aw_alarm_t						aw_alarm_st;

logic [8:0] prim_clkack_q;
logic       prim_clkack_negedge_q;
logic [2:0] prim_ism_fabric_q;

logic                           aon_clk_root;
logic                           fdtf_clk;
logic                           pgcb_clk_root;
logic                           pgcb_clk;
logic                           side_clk_root;
logic                           side_clk;

logic                           force_prim_clk_low;
logic                           force_prim_side_clkack_hqm;
logic                           force_primclk;
logic                           force_flcp_clk_en;
logic                           force_flcp_clk_en_q;

bit                             hqm_non_std_warm_rst_seq = $test$plusargs("HQM_NON_STD_WARM_RST_SEQ");
logic                           prim_clk_root;
logic                           prim_clk;
logic                           prim_clk_sync_root;
logic                           prim_clk_sync;
logic                           prim_rst_b;
logic   [2:0]                   prim_ism_agent;
bit                             prim_clk_1ghz    = ( $test$plusargs("HQM_PRIM_CLK_1_GHZ") && !$test$plusargs("HQM_PRIM_CLK_800_MHZ") && !$test$plusargs("HQM_PRIM_CLK_LOW") ) ? 1 : $urandom_range(0,1);
bit                             prim_clk_lowfreq = $test$plusargs("HQM_PRIM_CLK_LOW") ;
int                             prim_clk_sel;
int                             refclk_phase_tune;

logic                           side_pok;
logic                           side_clkreq;
logic                           side_clkack;
logic                           side_rst_b;
logic   [2:0]                   gpsb_side_ism_fabric;
logic   [2:0]                   gpsb_side_ism_agent;

bit                             side_clk_400freqsel = ( $test$plusargs("HQM_SIDE_CLK_400MHZ")) ? 1 : 0;
bit                             side_clk_300freqsel = ( $test$plusargs("HQM_SIDE_CLK_300MHZ")) ? 1 : 0;
bit                             side_clk_200freqsel = ( $test$plusargs("HQM_SIDE_CLK_200MHZ")) ? 1 : 0;
bit [2:0]                       side_clk_freqsel =  ( $test$plusargs("HQM_SIDE_CLK_RAND")) ?  $urandom_range(0,3) : 0;

logic                           iosf_pgcb_clk_root;
logic                           iosf_pgcb_clk;

// Wake-up signals to CDCs
logic                           prim_pwrgate_pmc_wake;
logic                           side_pwrgate_pmc_wake;

logic                           gpsb_mpccup;
logic                           gpsb_mnpcup;

logic                           gpsb_mpcput;
logic                           gpsb_mnpput;
logic                           gpsb_meom;
logic   [7:0]                   gpsb_mpayload;
logic                           gpsb_mparity;

logic                           gpsb_tpccup;
logic                           gpsb_tnpcup;

logic                           gpsb_tpcput;
logic                           gpsb_tnpput;
logic                           gpsb_teom;
logic   [7:0]                   gpsb_tpayload;
logic                           gpsb_tparity;

logic                           fdfx_sbparity_def;
logic                           dig_view_out_0;
logic                           dig_view_out_1;

logic                           fscan_mode;
logic                           fscan_rstbypen;
logic                           fscan_byprst_b;
logic                           fscan_clkungate;
logic                           fscan_clkungate_syn;
logic                           fscan_latchopen;
logic                           fscan_latchclosed_b;
logic                           fscan_shiften;
logic                           fscan_ret_ctrl;
logic                           fscan_isol_ctrl;
logic                           fscan_isol_lat_ctrl;

logic                           prim_jta_force_clkreq;
logic                           prim_jta_force_creditreq;
logic                           prim_jta_force_idle;
logic                           prim_jta_force_notidle;

logic                           gpsb_jta_clkgate_ovrd;
logic                           gpsb_jta_force_clkreq;
logic                           gpsb_jta_force_creditreq;
logic                           gpsb_jta_force_idle;
logic                           gpsb_jta_force_notidle;

logic                           cdc_prim_jta_clkgate_ovrd;
logic                           cdc_prim_jta_force_clkreq;

logic                           cdc_side_jta_clkgate_ovrd;
logic                           cdc_side_jta_force_clkreq;

logic                           pma_safemode;
bit                             agitate_wr_rdy;
bit                             agitate_power;

logic                           pgcb_tck;

logic                           hqm_rtdr_iosfsb_ism_tck;
logic                           hqm_rtdr_iosfsb_ism_trst_b;
logic                           hqm_rtdr_iosfsb_ism_tdi;
logic                           hqm_rtdr_iosfsb_ism_irdec;
logic                           hqm_rtdr_iosfsb_ism_capturedr;
logic                           hqm_rtdr_iosfsb_ism_shiftdr;
logic                           hqm_rtdr_iosfsb_ism_updatedr;
logic                           hqm_rtdr_iosfsb_ism_tdo;

logic                           hqm_rtdr_tapconfig_tck;
logic                           hqm_rtdr_tapconfig_trst_b;
logic                           hqm_rtdr_tapconfig_tdi;
logic                           hqm_rtdr_tapconfig_irdec;
logic                           hqm_rtdr_tapconfig_capturedr;
logic                           hqm_rtdr_tapconfig_shiftdr;
logic                           hqm_rtdr_tapconfig_updatedr;
logic                           hqm_rtdr_tapconfig_tdo;

logic                           hqm_rtdr_taptrigger_tck;
logic                           hqm_rtdr_taptrigger_trst_b;
logic                           hqm_rtdr_taptrigger_tdi;
logic                           hqm_rtdr_taptrigger_irdec;
logic                           hqm_rtdr_taptrigger_capturedr;
logic                           hqm_rtdr_taptrigger_shiftdr;
logic                           hqm_rtdr_taptrigger_updatedr;
logic                           hqm_rtdr_taptrigger_tdo;

logic                           hw_reset_force_pwr_on;

`ifdef HQM_SFI

logic                           sfi_tx_txcon_req;

logic                           sfi_tx_rxcon_ack;
logic                           sfi_tx_rxdiscon_nack;
logic                           sfi_tx_rx_empty;

logic                           sfi_tx_hdr_valid;
logic                           sfi_tx_hdr_early_valid;
logic [15:0]                    sfi_tx_hdr_info_bytes;
logic [255:0]                   sfi_tx_header;

logic                           sfi_tx_hdr_block;

logic                           sfi_tx_hdr_crd_rtn_valid;
logic [4:0]                     sfi_tx_hdr_crd_rtn_vc_id;
logic [1:0]                     sfi_tx_hdr_crd_rtn_fc_id;
logic [3:0]                     sfi_tx_hdr_crd_rtn_value;

logic                           sfi_tx_hdr_crd_rtn_block;

logic                           sfi_tx_data_valid;
logic                           sfi_tx_data_early_valid;
logic                           sfi_tx_data_aux_parity;
logic [3:0]                     sfi_tx_data_parity;
logic [7:0]                     sfi_tx_data_poison;
logic [7:0]                     sfi_tx_data_edb;
logic                           sfi_tx_data_start;
logic [7:0]                     sfi_tx_data_end;
logic [7:0]                     sfi_tx_data_info_byte;
logic [255:0]                   sfi_tx_data;

logic                           sfi_tx_data_block;

logic                           sfi_tx_data_crd_rtn_valid;
logic [4:0]                     sfi_tx_data_crd_rtn_vc_id;
logic [1:0]                     sfi_tx_data_crd_rtn_fc_id;
logic [3:0]                     sfi_tx_data_crd_rtn_value;

logic                           sfi_tx_data_crd_rtn_block;

logic                           sfi_rx_txcon_req;

logic                           sfi_rx_rxcon_ack;
logic                           sfi_rx_rxdiscon_nack;
logic                           sfi_rx_rx_empty;

logic                           sfi_rx_hdr_valid;
logic                           sfi_rx_hdr_early_valid;
logic [15:0]                    sfi_rx_hdr_info_bytes;
logic [255:0]                   sfi_rx_header;

logic                           sfi_rx_hdr_block;

logic                           sfi_rx_hdr_crd_rtn_valid;
logic [4:0]                     sfi_rx_hdr_crd_rtn_vc_id;
logic [1:0]                     sfi_rx_hdr_crd_rtn_fc_id;
logic [3:0]                     sfi_rx_hdr_crd_rtn_value;

logic                           sfi_rx_hdr_crd_rtn_block;

logic                           sfi_rx_data_valid;
logic                           sfi_rx_data_early_valid;
logic                           sfi_rx_data_aux_parity;
logic [3:0]                     sfi_rx_data_parity;
logic [7:0]                     sfi_rx_data_poison;
logic [7:0]                     sfi_rx_data_edb;
logic                           sfi_rx_data_start;
logic [7:0]                     sfi_rx_data_end;
logic [7:0]                     sfi_rx_data_info_byte;
logic [255:0]                   sfi_rx_data;

logic                           sfi_rx_data_block;

logic                           sfi_rx_data_crd_rtn_valid;
logic [4:0]                     sfi_rx_data_crd_rtn_vc_id;
logic [1:0]                     sfi_rx_data_crd_rtn_fc_id;
logic [3:0]                     sfi_rx_data_crd_rtn_value;

logic                           sfi_rx_data_crd_rtn_block;

`endif

    //---------------------
    //-- interfaces
    //---------------------
hqm_misc_if         pins(
                          .side_clk(side_clk),
                          .prim_clk(prim_clk),
                          .pgcb_clk(pgcb_clk)
                        );
    hqm_reset_if        i_reset_if();

    iosf_primary_intf #(`MY_IOSF_PARAMS,
     .DEASSERT_CLK_SIGS_DEFAULT(`HQM_PRIM_DEASSERT_CLK_SIGS_DEFAULT)
     ) iosf_fabric_if();



    iosf_sbc_intf # (
     .AGENT_MASTERING_SB_IF(0),
     .DEASSERT_CLK_SIGS_DEFAULT(`HQM_SB_DEASSERT_CLK_SIGS_DEFAULT)
     )iosf_sbc_fabric_if(
      .side_clk         (side_clk),
      .side_rst_b       (hqm_tb_top.i_reset_if.side_rst_b),
      .gated_side_clk   (),
      .agent_rst_b      (hqm_tb_top.i_reset_if.side_rst_b)
    );

hqm_iosf_func_cov_intf   func_cov (
                          .side_clk(side_clk),
                          .tpccup(gpsb_tpccup),
                          .tnpcup(gpsb_tnpcup),
                          .tpcput(gpsb_tpcput),
                          .tnpput(gpsb_tnpput),
                          .mpccup(gpsb_mpccup),
                          .mnpcup(gpsb_mnpcup),
                          .mpcput(gpsb_mpcput),
                          .mnpput(gpsb_mnpput),
                          .side_ism_agent(gpsb_side_ism_agent),
                          .side_ism_fabric(gpsb_side_ism_fabric),
                          .prim_clk(prim_clk),
                          .prim_ism_agent(prim_ism_agent),
                          .prim_ism_fabric(prim_ism_fabric_q),
                          .gnt(iosf_fabric_if.gnt),
                          .gnt_rtype(iosf_fabric_if.gnt_rtype),
                          .gnt_type(iosf_fabric_if.gnt_type),
                          .req_put(iosf_fabric_if.req_put),
                          .req_rtype(iosf_fabric_if.req_rtype),
                          .cmd_put(iosf_fabric_if.cmd_put),
                          .tdest_id(iosf_fabric_if.tdest_id),
                          .tsrc_id(iosf_fabric_if.tsrc_id)
                         );

    //  JtagBfmIntf #(`HQM_JTAG_IF_PARAMS_INST
    //               )  i_jtagbfm_if(
    //                  .soc_powergood_rst_b(i_reset_if.powergood_rst_b),
    //                  .soc_clock(prim_clk)
    //              );


    //-- --//
    //`include "soc_pre_ti_include.sv"
    `include "hqm_tap_rtdr_pre_ti_include.sv"

    //---------------------
    //-- test island
    //---------------------
    hqm_test_island # (
      .IP_ENV("*.i_hqm_tb_env"),
      .IP_RTL_PATH("tb_top.u_hqm")
      ) hqm_test_island (
        .hqm_vintf(pins),
        .iosf_fabric_if(iosf_fabric_if),
        .iosf_sbc_fabric_if(iosf_sbc_fabric_if),
        .i_reset_if(i_reset_if)
        //.i_jtagbfm_if(i_jtagbfm_if)
      );

    `ifndef SVA_OFF
    `ifndef INTEL_SVA_OFF
      ascot_hqm ascot();
    `endif
    `endif

    `ifdef HQM_MPP
      pvr_hqm  i_pvr_hqm (
        .vcccfn_real                  (i_reset_if.vcccfn_voltage),          // This is the voltage value driven by RTL or TB

        // Outputs
        .vcccfn                       (i_reset_if.vcccfn_pwr_on),           // 0/1 indication to TB/Ascot if Power is on
        .vcccfn_on_thresh_out         (i_reset_if.vcccfn_on_thresh_out),    // ON  Voltage threshold for driver reference
        .vcccfn_ret_thresh_out        (i_reset_if.vcccfn_ret_thresh_out)    // RET Voltage threshold for driver reference
      );





      assign u_hqm.power_present_in_vcccfn = i_pvr_hqm.volt_dom_vcccfn.vcc_out;
    `else
      assign i_reset_if.vcccfn_pwr_on           = 1'b1;
      assign i_reset_if.vcccfn_on_thresh_out    = 0.65;
      assign i_reset_if.vcccfn_ret_thresh_out   = 0.30;
      assign u_hqm.power_present_in_vcccfn      = 0.65;
    `endif

      assign i_reset_if.side_clk = side_clk;

    //---------------------
    //-- program
    //---------------------
    hqm_tb_program tb_program();//m_axi_if_wrapper_in, m_axi_if_wrapper_out);

    //-- --//
    //`include "soc_post_ti_include.sv"
    `include "hqm_tap_rtdr_post_ti_include.sv"

    //---------------------
    //-- clock
    //---------------------
     initial begin
      clock = 1'b0;
      forever begin
        #1ns;
        clock = 1'b1;
        #1ns;
        clock = 1'b0;
      end
    end

    global clocking @clock; endclocking

    // locally generated signals used by iosf_fabric_if // NS: Can't these rst/clk signals be drive by iosf_fabric_if ?? //
    assign iosf_fabric_if.prim_rst_b            = hqm_tb_top.i_reset_if.prim_rst_b;//hqm_tb_top.u_hqm.prim_rst_b;//prim_rst_b;
    assign iosf_fabric_if.prim_clk              = prim_clk_root;
    assign iosf_fabric_if.prim_ism_agent        = prim_ism_agent;
    assign iosf_fabric_if.msecondary_bus_rst_b  = 1;    // tie off

    // Unused signals to iosf_fabric_if
    assign iosf_fabric_if.req_priority          = '0;
    assign iosf_fabric_if.mbewd                 = '0;
    assign iosf_fabric_if.mecrc_generate        = '0;
    assign iosf_fabric_if.mecrc_error           = '0;
    assign iosf_fabric_if.mrsvd1_1              = '0;
    assign iosf_fabric_if.mrsvd0_7              = '0;
    assign iosf_fabric_if.mdbe                  = '0;
    assign iosf_fabric_if.mdeadline             = '0;
`ifndef HQM_SFI
    assign iosf_fabric_if.req_chid              = '0;
    assign iosf_fabric_if.credit_chid           = '0;
`endif


    `ifndef HQM_IOSF_2019_BFM
      assign iosf_fabric_if.mide_t              = '0;
      assign iosf_fabric_if.mide_full           = '0;
      assign iosf_fabric_if.mide_mac            = '0;
    `endif

    // Unused signals from iosf_fabric_if
    //   iosf_fabric_if.gnt_chid
    //   iosf_fabric_if.obff
    //   iosf_fabric_if.mem_closed
    //   iosf_fabric_if.cmd_chid
    //   iosf_fabric_if.tbewd
    //   iosf_fabric_if.tecrc_generate
    //   iosf_fabric_if.tecrc_error
    //   iosf_fabric_if.trsvd1_7
    //   iosf_fabric_if.trsvd1_3
    //   iosf_fabric_if.trsvd1_1
    //   iosf_fabric_if.trsvd0_7
    //   iosf_fabric_if.tdeadline
    //   iosf_fabric_if.tpriority
    //   iosf_fabric_if.tdbe
    //assign iosf_fabric_if.tide_t              = '0;

    // locally generated signals used by iosf_fabric_if
    assign gpsb_side_ism_fabric         = iosf_sbc_fabric_if.side_ism_fabric;
    assign gpsb_tpcput                  = iosf_sbc_fabric_if.mpcput;
    assign gpsb_tnpput                  = iosf_sbc_fabric_if.mnpput;
    assign gpsb_tpayload                = iosf_sbc_fabric_if.mpayload;
    assign gpsb_teom                    = iosf_sbc_fabric_if.meom;
    assign gpsb_tparity                 = iosf_sbc_fabric_if.mparity;
    assign iosf_sbc_fabric_if.mpccup    = gpsb_tpccup;
    assign iosf_sbc_fabric_if.mnpcup    = gpsb_tnpcup;

    assign iosf_sbc_fabric_if.side_ism_agent    = gpsb_side_ism_agent;
    assign iosf_sbc_fabric_if.tpcput            = gpsb_mpcput;
    assign iosf_sbc_fabric_if.tnpput            = gpsb_mnpput;
    assign iosf_sbc_fabric_if.tpayload          = gpsb_mpayload;
    assign iosf_sbc_fabric_if.teom              = gpsb_meom;
    assign iosf_sbc_fabric_if.tparity           = gpsb_mparity;
    assign gpsb_mpccup                          = iosf_sbc_fabric_if.tpccup;
    assign gpsb_mnpcup                          = iosf_sbc_fabric_if.tnpcup;

    // reset_agent assigns start

    assign  i_reset_if.clk          = clk_inst1.xclk[0];
    assign  i_reset_if.aon_clk      = aon_clk_root;
`ifdef HQM_SFI
logic sfi2iosf_prim_clkreq;
logic hqm_prim_clkreq;
    assign  iosf_fabric_if.prim_clkreq = sfi2iosf_prim_clkreq | hqm_prim_clkreq;
    assign  i_reset_if.prim_pok     = hqm_tb_top.i_hqm_sfi2iosf.prim_pok;
    assign  i_reset_if.prim_clkreq  = hqm_tb_top.i_hqm_sfi2iosf.prim_clkreq | hqm_tb_top.u_hqm.prim_clkreq;
    assign  i_reset_if.prim_clkack  = hqm_tb_top.i_hqm_sfi2iosf.prim_clkack;
`else
    assign  i_reset_if.prim_pok     = hqm_tb_top.u_hqm.prim_pok;
    assign  i_reset_if.prim_clkreq  = hqm_tb_top.u_hqm.prim_clkreq;
    assign  i_reset_if.prim_clkack  = hqm_tb_top.u_hqm.prim_clkack;
`endif
    assign  i_reset_if.side_pok     = hqm_tb_top.u_hqm.side_pok;
    assign  i_reset_if.side_clkreq  = hqm_tb_top.u_hqm.side_clkreq;
    assign  i_reset_if.side_clkack  = hqm_tb_top.u_hqm.side_clkack;
    assign  i_reset_if.flcp_clk     = force_flcp_clk_en_q ? clk_inst1.Bclk_p : 1'b0;
    //assign  i_reset_if.flcp_clk     = (i_reset_if.flcp_clk_en & clk_inst1.Bclk_p);
    assign i_reset_if.flcp_clk_out  = i_reset_if.flcp_clk;

    assign hw_reset_force_pwr_on    = i_reset_if.hw_reset_force_pwr_on;

    always @(negedge clk_inst1.Bclk_p) begin
        force_flcp_clk_en_q = force_flcp_clk_en;
    end

    // reset_agent assigns end
    //---------------------
    //-- hqm DUT
    //---------------------
    hqm  u_hqm (

      .strap_hqm_csr_cp                 (pins.strap_hqm_csr_cp),                 // Exported to SOC
      .strap_hqm_csr_rac                (pins.strap_hqm_csr_rac),                // Exported to SOC
      .strap_hqm_csr_wac                (pins.strap_hqm_csr_wac),                // Exported to SOC
      .strap_hqm_device_id              (pins.strap_hqm_device_id),              // Exported to SOC

      .strap_hqm_gpsb_srcid             (pins.strap_hqm_gpsb_srcid),             // Exported to SOC
      .strap_hqm_16b_portids            (pins.strap_hqm_16b_portids),            // Exported to SOC

      .strap_hqm_err_sb_dstid           (pins.strap_hqm_err_sb_dstid),           // Exported to SOC
      .strap_hqm_err_sb_sai             (pins.strap_hqm_err_sb_sai),             // Exported to SOC

      .strap_hqm_tx_sai                 (pins.strap_hqm_tx_sai),                 // Exported to SOC
      .strap_hqm_cmpl_sai               (pins.strap_hqm_cmpl_sai),               // Exported to SOC
      .strap_hqm_resetprep_ack_sai      (pins.strap_hqm_resetprep_ack_sai),      // Exported to SOC

      .strap_hqm_resetprep_sai_0        (pins.strap_hqm_resetprep_sai_0),        // Exported to SOC
      .strap_hqm_resetprep_sai_1        (pins.strap_hqm_resetprep_sai_1),        // Exported to SOC
      .strap_hqm_force_pok_sai_0        (pins.strap_hqm_force_pok_sai_0),        // Exported to SOC
      .strap_hqm_force_pok_sai_1        (pins.strap_hqm_force_pok_sai_1),        // Exported to SOC

      .strap_hqm_do_serr_dstid          (pins.strap_hqm_do_serr_dstid),          // Exported to SOC
      .strap_hqm_do_serr_tag            (pins.strap_hqm_do_serr_tag),            // Exported to SOC
      .strap_hqm_do_serr_sairs_valid    (pins.strap_hqm_do_serr_sairs_valid),    // Exported to SOC
      .strap_hqm_do_serr_sai            (pins.strap_hqm_do_serr_sai),            // Exported to SOC
      .strap_hqm_do_serr_rs             (pins.strap_hqm_do_serr_rs),             // Exported to SOC

      .early_fuses                      (i_reset_if.early_fuses),
      .ip_ready                         (i_reset_if.ip_ready),

      .strap_no_mgmt_acks               (pins.strap_no_mgmt_acks),
      .reset_prep_ack                   (i_reset_if.reset_prep_ack),

        //---------------------------------------------------------------------------------------------
        // Main Clock and Reset interface

      .fdfx_powergood         (i_reset_if.powergood_rst_b),
      .powergood_rst_b        (i_reset_if.powergood_rst_b),

      .prim_clk(prim_clk),
      .prim_rst_b(i_reset_if.prim_rst_b),

      .side_pok(iosf_sbc_fabric_if.side_pok),
      .side_clk(side_clk),
      .side_clkreq(iosf_sbc_fabric_if.side_clkreq),
      .side_clkack(iosf_sbc_fabric_if.side_clkack),
      .side_rst_b(i_reset_if.side_rst_b),
      .gpsb_side_ism_fabric(gpsb_side_ism_fabric),
      .gpsb_side_ism_agent(gpsb_side_ism_agent),

      .pgcb_clk(pgcb_clk),
      .iosf_pgcb_clk(iosf_pgcb_clk),

      .pma_safemode(pma_safemode),

        //---------------------------------------------------------------------------------------------
        // Egress port interface to the IOSF Sideband Channel

      .gpsb_mpccup(gpsb_mpccup),
      .gpsb_mnpcup(gpsb_mnpcup),

      .gpsb_mpcput(gpsb_mpcput),
      .gpsb_mnpput(gpsb_mnpput),
      .gpsb_meom(gpsb_meom),
      .gpsb_mpayload(gpsb_mpayload),
      .gpsb_mparity(gpsb_mparity),

        //---------------------------------------------------------------------------------------------
        // Ingress port interface to the IOSF Sideband Channel

      .gpsb_tpccup(gpsb_tpccup),
      .gpsb_tnpcup(gpsb_tnpcup),

      .gpsb_tpcput(gpsb_tpcput),
      .gpsb_tnpput(gpsb_tnpput),
      .gpsb_teom(gpsb_teom),
      .gpsb_tpayload(gpsb_tpayload),
      .gpsb_tparity(gpsb_tparity),

        //---------------------------------------------------------------------------------------------
        // RTDR TAP port

      .pgcb_tck                     (pgcb_tck),

      .rtdr_iosfsb_ism_tck          (hqm_rtdr_iosfsb_ism_tck),
      .rtdr_iosfsb_ism_trst_b       (hqm_rtdr_iosfsb_ism_trst_b),
      .rtdr_iosfsb_ism_tdi          (hqm_rtdr_iosfsb_ism_tdi),
      .rtdr_iosfsb_ism_irdec        (hqm_rtdr_iosfsb_ism_irdec),
      .rtdr_iosfsb_ism_capturedr    (hqm_rtdr_iosfsb_ism_capturedr),
      .rtdr_iosfsb_ism_shiftdr      (hqm_rtdr_iosfsb_ism_shiftdr),
      .rtdr_iosfsb_ism_updatedr     (hqm_rtdr_iosfsb_ism_updatedr),
      .rtdr_iosfsb_ism_tdo          (hqm_rtdr_iosfsb_ism_tdo),

      .rtdr_tapconfig_tck           (hqm_rtdr_tapconfig_tck),
      .rtdr_tapconfig_trst_b        (hqm_rtdr_tapconfig_trst_b),
      .rtdr_tapconfig_tdi           (hqm_rtdr_tapconfig_tdi),
      .rtdr_tapconfig_irdec         (hqm_rtdr_tapconfig_irdec),
      .rtdr_tapconfig_capturedr     (hqm_rtdr_tapconfig_capturedr),
      .rtdr_tapconfig_shiftdr       (hqm_rtdr_tapconfig_shiftdr),
      .rtdr_tapconfig_updatedr      (hqm_rtdr_tapconfig_updatedr),
      .rtdr_tapconfig_tdo           (hqm_rtdr_tapconfig_tdo),

      .rtdr_taptrigger_tck          (hqm_rtdr_taptrigger_tck),
      .rtdr_taptrigger_trst_b       (hqm_rtdr_taptrigger_trst_b),
      .rtdr_taptrigger_tdi          (hqm_rtdr_taptrigger_tdi),
      .rtdr_taptrigger_irdec        (hqm_rtdr_taptrigger_irdec),
      .rtdr_taptrigger_capturedr    (hqm_rtdr_taptrigger_capturedr),
      .rtdr_taptrigger_shiftdr      (hqm_rtdr_taptrigger_shiftdr),
      .rtdr_taptrigger_updatedr     (hqm_rtdr_taptrigger_updatedr),
      .rtdr_taptrigger_tdo          (hqm_rtdr_taptrigger_tdo),

      .prochot                          (pins.prochot),
      .pm_hqm_adr_assert                (pins.pm_hqm_adr_assert),   // Async DIMM Refresh function assertion signal
      .hqm_pm_adr_ack                   (pins.pm_hqm_adr_ack),

        //---------------------------------------------------------------------------------------------
        // DFX interface

      .fdfx_sbparity_def                (fdfx_sbparity_def),

      .dig_view_out_0                   (dig_view_out_0),
      .dig_view_out_1                   (dig_view_out_1),

        //---------------------------------------------------------------------------------------------
        // DVP interface

      .fdtf_clk                         (fdtf_clk),
      .fdtf_cry_clk                     ('0),
      .fdtf_rst_b                       ('0),

      .fdtf_survive_mode                ('0),
      .fdtf_fast_cnt_width              ('0),
      .fdtf_packetizer_mid              ('0),
      .fdtf_packetizer_cid              ('0),

      .adtf_dnstream_header             (),
      .adtf_dnstream_data               (),
      .adtf_dnstream_valid              (),
      .fdtf_upstream_credit             ('0),
      .fdtf_upstream_active             ('0),
      .fdtf_upstream_sync               ('0),
                                       
      .fdtf_serial_download_tsc         ('0),
      .fdtf_tsc_adjustment_strap        ('0),
                                       
      .fdtf_timestamp_valid             ('0),
      .fdtf_timestamp_value             ('0),
                                       
      .fdtf_force_ts                    ('0),
                                       
      .ftrig_fabric_in                  ('0),
      .atrig_fabric_in_ack              (),
                                       
      .atrig_fabric_out                 (),
      .ftrig_fabric_out_ack             ('0),

      .dvp_paddr                        ('0),
      .dvp_pprot                        ('0),
      .dvp_psel                         ('0),
      .dvp_penable                      ('0),
      .dvp_pwrite                       ('0),
      .dvp_pwdata                       ('0),
      .dvp_pstrb                        ('0),
                                       
      .dvp_pready                       (),
      .dvp_pslverr                      (),
      .dvp_prdata                       (),

      .fdfx_earlyboot_debug_exit        ('0),
      .fdfx_policy_update               ('0),
      .fdfx_security_policy             ('0),
      .fdfx_debug_cap                   ('0),
      .fdfx_debug_cap_valid             ('0),

        //---------------------------------------------------------------------------------------------
        // FSCAN interface
      .fscan_mode                       (fscan_mode),
      .fscan_rstbypen                   (fscan_rstbypen),
      .fscan_byprst_b                   (fscan_byprst_b),
      .fscan_clkungate                  (fscan_clkungate),
      .fscan_clkungate_syn              (fscan_clkungate_syn),
      .fscan_latchopen                  (fscan_latchopen),
      .fscan_latchclosed_b              (fscan_latchclosed_b),
      .fscan_shiften                    (fscan_shiften),
      .fscan_ret_ctrl                   (fscan_ret_ctrl),
      .fscan_isol_ctrl                  (fscan_isol_ctrl),
      .fscan_isol_lat_ctrl              (fscan_isol_lat_ctrl),

        //---------------------------------------------------------------------------------------------
        // CDC wake signals

      .side_pwrgate_pmc_wake(($test$plusargs("HQM_PWRGATE_PMC_WAKE_SET")) ? side_pwrgate_pmc_wake : i_reset_if.side_pwrgate_pmc_wake),
      .prim_pwrgate_pmc_wake(($test$plusargs("HQM_PWRGATE_PMC_WAKE_SET")) ? prim_pwrgate_pmc_wake : i_reset_if.prim_pwrgate_pmc_wake),

`ifdef HQM_SFI

     .prim_clkreq                           (hqm_prim_clkreq)
    ,.prim_clkack                           (hqm_prim_clkreq & prim_clkack_q[8])

    ,.sfi_tx_txcon_req                      (sfi_tx_txcon_req)

    ,.sfi_tx_rxcon_ack                      (sfi_tx_rxcon_ack)
    ,.sfi_tx_rxdiscon_nack                  (sfi_tx_rxdiscon_nack)
    ,.sfi_tx_rx_empty                       (sfi_tx_rx_empty)

    ,.sfi_tx_hdr_valid                      (sfi_tx_hdr_valid)
    ,.sfi_tx_hdr_early_valid                (sfi_tx_hdr_early_valid)
    ,.sfi_tx_hdr_info_bytes                 (sfi_tx_hdr_info_bytes)
    ,.sfi_tx_header                         (sfi_tx_header)

    ,.sfi_tx_hdr_block                      (sfi_tx_hdr_block)

    ,.sfi_tx_hdr_crd_rtn_valid              (sfi_tx_hdr_crd_rtn_valid)
    ,.sfi_tx_hdr_crd_rtn_vc_id              (sfi_tx_hdr_crd_rtn_vc_id)
    ,.sfi_tx_hdr_crd_rtn_fc_id              (sfi_tx_hdr_crd_rtn_fc_id)
    ,.sfi_tx_hdr_crd_rtn_value              (sfi_tx_hdr_crd_rtn_value)

    ,.sfi_tx_hdr_crd_rtn_block              (sfi_tx_hdr_crd_rtn_block)

    ,.sfi_tx_data_valid                     (sfi_tx_data_valid)
    ,.sfi_tx_data_early_valid               (sfi_tx_data_early_valid)
    ,.sfi_tx_data_aux_parity                (sfi_tx_data_aux_parity)
    ,.sfi_tx_data_poison                    (sfi_tx_data_poison)
    ,.sfi_tx_data_edb                       (sfi_tx_data_edb)
    ,.sfi_tx_data_start                     (sfi_tx_data_start)
    ,.sfi_tx_data_end                       (sfi_tx_data_end)
    ,.sfi_tx_data_parity                    (sfi_tx_data_parity)
    ,.sfi_tx_data_info_byte                 (sfi_tx_data_info_byte)
    ,.sfi_tx_data                           (sfi_tx_data)

    ,.sfi_tx_data_block                     (sfi_tx_data_block)

    ,.sfi_tx_data_crd_rtn_valid             (sfi_tx_data_crd_rtn_valid)
    ,.sfi_tx_data_crd_rtn_vc_id             (sfi_tx_data_crd_rtn_vc_id)
    ,.sfi_tx_data_crd_rtn_fc_id             (sfi_tx_data_crd_rtn_fc_id)
    ,.sfi_tx_data_crd_rtn_value             (sfi_tx_data_crd_rtn_value)

    ,.sfi_tx_data_crd_rtn_block             (sfi_tx_data_crd_rtn_block)

    ,.sfi_rx_txcon_req                      (sfi_rx_txcon_req)

    ,.sfi_rx_rxcon_ack                      (sfi_rx_rxcon_ack)
    ,.sfi_rx_rxdiscon_nack                  (sfi_rx_rxdiscon_nack)
    ,.sfi_rx_rx_empty                       (sfi_rx_rx_empty)

    ,.sfi_rx_hdr_valid                      (sfi_rx_hdr_valid)
    ,.sfi_rx_hdr_early_valid                (sfi_rx_hdr_early_valid)
    ,.sfi_rx_hdr_info_bytes                 (sfi_rx_hdr_info_bytes)
    ,.sfi_rx_header                         (sfi_rx_header)

    ,.sfi_rx_hdr_block                      (sfi_rx_hdr_block)

    ,.sfi_rx_hdr_crd_rtn_valid              (sfi_rx_hdr_crd_rtn_valid)
    ,.sfi_rx_hdr_crd_rtn_vc_id              (sfi_rx_hdr_crd_rtn_vc_id)
    ,.sfi_rx_hdr_crd_rtn_fc_id              (sfi_rx_hdr_crd_rtn_fc_id)
    ,.sfi_rx_hdr_crd_rtn_value              (sfi_rx_hdr_crd_rtn_value)

    ,.sfi_rx_hdr_crd_rtn_block              (sfi_rx_hdr_crd_rtn_block)

    ,.sfi_rx_data_valid                     (sfi_rx_data_valid)
    ,.sfi_rx_data_early_valid               (sfi_rx_data_early_valid)
    ,.sfi_rx_data_aux_parity                (sfi_rx_data_aux_parity)
    ,.sfi_rx_data_poison                    (sfi_rx_data_poison)
    ,.sfi_rx_data_edb                       (sfi_rx_data_edb)
    ,.sfi_rx_data_start                     (sfi_rx_data_start)
    ,.sfi_rx_data_end                       (sfi_rx_data_end)
    ,.sfi_rx_data_parity                    (sfi_rx_data_parity)
    ,.sfi_rx_data_info_byte                 (sfi_rx_data_info_byte)
    ,.sfi_rx_data                           (sfi_rx_data)

    ,.sfi_rx_data_block                     (sfi_rx_data_block)

    ,.sfi_rx_data_crd_rtn_valid             (sfi_rx_data_crd_rtn_valid)
    ,.sfi_rx_data_crd_rtn_vc_id             (sfi_rx_data_crd_rtn_vc_id)
    ,.sfi_rx_data_crd_rtn_fc_id             (sfi_rx_data_crd_rtn_fc_id)
    ,.sfi_rx_data_crd_rtn_value             (sfi_rx_data_crd_rtn_value)

    ,.sfi_rx_data_crd_rtn_block             (sfi_rx_data_crd_rtn_block)
);

hqm_sfi2iosf i_hqm_sfi2iosf (

     .prim_clk                              (prim_clk)
    ,.prim_rst_b                            (iosf_fabric_if.prim_rst_b)

    ,.iosf_pgcb_clk                         (iosf_pgcb_clk)

    ,.agent_idle                            (u_hqm.i_hqm_sip.hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.hqm_idle)

    ,.sfi_tx_txcon_req                      (sfi_rx_txcon_req)

    ,.sfi_tx_rxcon_ack                      (sfi_rx_rxcon_ack)
    ,.sfi_tx_rxdiscon_nack                  (sfi_rx_rxdiscon_nack)
    ,.sfi_tx_rx_empty                       (sfi_rx_rx_empty)

    ,.sfi_tx_hdr_valid                      (sfi_rx_hdr_valid)
    ,.sfi_tx_hdr_early_valid                (sfi_rx_hdr_early_valid)
    ,.sfi_tx_hdr_info_bytes                 (sfi_rx_hdr_info_bytes)
    ,.sfi_tx_header                         (sfi_rx_header)

    ,.sfi_tx_hdr_block                      (sfi_rx_hdr_block)

    ,.sfi_tx_hdr_crd_rtn_valid              (sfi_rx_hdr_crd_rtn_valid)
    ,.sfi_tx_hdr_crd_rtn_vc_id              (sfi_rx_hdr_crd_rtn_vc_id)
    ,.sfi_tx_hdr_crd_rtn_fc_id              (sfi_rx_hdr_crd_rtn_fc_id)
    ,.sfi_tx_hdr_crd_rtn_value              (sfi_rx_hdr_crd_rtn_value)

    ,.sfi_tx_hdr_crd_rtn_block              (sfi_rx_hdr_crd_rtn_block)

    ,.sfi_tx_data_valid                     (sfi_rx_data_valid)
    ,.sfi_tx_data_early_valid               (sfi_rx_data_early_valid)
    ,.sfi_tx_data_aux_parity                (sfi_rx_data_aux_parity)
    ,.sfi_tx_data_poison                    (sfi_rx_data_poison)
    ,.sfi_tx_data_edb                       (sfi_rx_data_edb)
    ,.sfi_tx_data_start                     (sfi_rx_data_start)
    ,.sfi_tx_data_end                       (sfi_rx_data_end)
    ,.sfi_tx_data_parity                    (sfi_rx_data_parity)
    ,.sfi_tx_data_info_byte                 (sfi_rx_data_info_byte)
    ,.sfi_tx_data                           (sfi_rx_data)

    ,.sfi_tx_data_block                     (sfi_rx_data_block)

    ,.sfi_tx_data_crd_rtn_valid             (sfi_rx_data_crd_rtn_valid)
    ,.sfi_tx_data_crd_rtn_vc_id             (sfi_rx_data_crd_rtn_vc_id)
    ,.sfi_tx_data_crd_rtn_fc_id             (sfi_rx_data_crd_rtn_fc_id)
    ,.sfi_tx_data_crd_rtn_value             (sfi_rx_data_crd_rtn_value)

    ,.sfi_tx_data_crd_rtn_block             (sfi_rx_data_crd_rtn_block)

    ,.sfi_rx_txcon_req                      (sfi_tx_txcon_req)

    ,.sfi_rx_rxcon_ack                      (sfi_tx_rxcon_ack)
    ,.sfi_rx_rxdiscon_nack                  (sfi_tx_rxdiscon_nack)
    ,.sfi_rx_rx_empty                       (sfi_tx_rx_empty)

    ,.sfi_rx_hdr_valid                      (sfi_tx_hdr_valid)
    ,.sfi_rx_hdr_early_valid                (sfi_tx_hdr_early_valid)
    ,.sfi_rx_hdr_info_bytes                 (sfi_tx_hdr_info_bytes)
    ,.sfi_rx_header                         (sfi_tx_header)

    ,.sfi_rx_hdr_block                      (sfi_tx_hdr_block)

    ,.sfi_rx_hdr_crd_rtn_valid              (sfi_tx_hdr_crd_rtn_valid)
    ,.sfi_rx_hdr_crd_rtn_vc_id              (sfi_tx_hdr_crd_rtn_vc_id)
    ,.sfi_rx_hdr_crd_rtn_fc_id              (sfi_tx_hdr_crd_rtn_fc_id)
    ,.sfi_rx_hdr_crd_rtn_value              (sfi_tx_hdr_crd_rtn_value)

    ,.sfi_rx_hdr_crd_rtn_block              (sfi_tx_hdr_crd_rtn_block)

    ,.sfi_rx_data_valid                     (sfi_tx_data_valid)
    ,.sfi_rx_data_early_valid               (sfi_tx_data_early_valid)
    ,.sfi_rx_data_aux_parity                (sfi_tx_data_aux_parity)
    ,.sfi_rx_data_poison                    (sfi_tx_data_poison)
    ,.sfi_rx_data_edb                       (sfi_tx_data_edb)
    ,.sfi_rx_data_start                     (sfi_tx_data_start)
    ,.sfi_rx_data_end                       (sfi_tx_data_end)
    ,.sfi_rx_data_parity                    (sfi_tx_data_parity)
    ,.sfi_rx_data_info_byte                 (sfi_tx_data_info_byte)
    ,.sfi_rx_data                           (sfi_tx_data)

    ,.sfi_rx_data_block                     (sfi_tx_data_block)

    ,.sfi_rx_data_crd_rtn_valid             (sfi_tx_data_crd_rtn_valid)
    ,.sfi_rx_data_crd_rtn_vc_id             (sfi_tx_data_crd_rtn_vc_id)
    ,.sfi_rx_data_crd_rtn_fc_id             (sfi_tx_data_crd_rtn_fc_id)
    ,.sfi_rx_data_crd_rtn_value             (sfi_tx_data_crd_rtn_value)

    ,.sfi_rx_data_crd_rtn_block             (sfi_tx_data_crd_rtn_block),

      .prim_pok(iosf_fabric_if.prim_pok),
      .prim_clkreq(sfi2iosf_prim_clkreq),
      .prim_clkack(sfi2iosf_prim_clkreq & prim_clkack_q[8]),
      .prim_ism_fabric(prim_ism_fabric_q),
      .prim_ism_agent(prim_ism_agent),

      .req_put          (iosf_fabric_if.req_put),                 // req: Request Put
      .req_cdata        (iosf_fabric_if.req_cdata),               // req: Request Contains Data
      .req_rtype        (iosf_fabric_if.req_rtype),               // req: Request Type
      .req_dlen         (iosf_fabric_if.req_dlen),                // req: Request Data Length
      .req_tc           (iosf_fabric_if.req_tc),                  // req: Request Traffic Class
      .req_ns           (iosf_fabric_if.req_ns),                  // req: Request Non-Snoop
      .req_ro           (iosf_fabric_if.req_ro),                  // req: Request Relaxed Order
      .req_ido          (iosf_fabric_if.req_ido),                 // opt: Req ID Based Ordering
      .req_id           (iosf_fabric_if.req_id),                  // opt: Req ID for ID Based Ordering
      .req_locked       (iosf_fabric_if.req_locked),              // req: Request Locked
      .req_chain        (iosf_fabric_if.req_chain),               // opt: Request Chain
      .req_opp          (iosf_fabric_if.req_opp),                 // opt: Request Opportunistic
      .req_rs           (iosf_fabric_if.req_rs),                  // opt: Request Root_Space
      .req_agent        (iosf_fabric_if.req_agent),               // opt: Request agent Specific
      .req_dest_id      (iosf_fabric_if.req_dest_id),             // opt: Destination ID                (src dec)
      .req_chid         (iosf_fabric_if.req_chid),

      .gnt              (iosf_fabric_if.gnt),                     // req: Grant
      .gnt_rtype        (iosf_fabric_if.gnt_rtype),               // req: Grant Request Type
      .gnt_type         (iosf_fabric_if.gnt_type),                // req: Grant Type
      .gnt_chid         (iosf_fabric_if.gnt_chid),

      .mfmt             (iosf_fabric_if.mfmt),                    // req: Fmt
      .mtype            (iosf_fabric_if.mtype),                   // req: Type
      .mtc              (iosf_fabric_if.mtc),                     // req: Traffic Class
      .mth              (iosf_fabric_if.mth),                     // opt: Transaction Hint
      .mep              (iosf_fabric_if.mep),                     // opt: Error Present
      .mro              (iosf_fabric_if.mro),                     // req: Relaxed Ordering
      .mns              (iosf_fabric_if.mns),                     // req: Non-Snoop
      .mido             (iosf_fabric_if.mido),                    // opt: ID Based Ordering
      .mat              (iosf_fabric_if.mat),                     // opt: Adrs Translation Svc
      .mrsvd1_3         (iosf_fabric_if.mrsvd1_3),                // req: 10-bit tag support -> bit#8
      .mrsvd1_7         (iosf_fabric_if.mrsvd1_7),                // req: 10-bit tag support -> bit#9
      .mlength          (iosf_fabric_if.mlength),                 // req: Length
      .mpasidtlp        (iosf_fabric_if.mpasidtlp),               // req: Pasidtlp prefix
      .mrqid            (iosf_fabric_if.mrqid),                   // req: Requester ID
      .mtag             (iosf_fabric_if.mtag),                    // req: Tag
      .mlbe             (iosf_fabric_if.mlbe),                    // req: Last DW Byte Enable
      .mfbe             (iosf_fabric_if.mfbe),                    // req: First DW Byte Enable
      .maddress         (iosf_fabric_if.maddress),                // req: Address
      .mrs              (iosf_fabric_if.mrs),                     // opt: Root Space of address
      .mtd              (iosf_fabric_if.mtd),                     // opt: TLP Digest
      .mecrc            (iosf_fabric_if.mecrc),                   // opt: End to End CRC
      .mcparity         (iosf_fabric_if.mcparity),                // req: Command Parity
      .mdest_id         (iosf_fabric_if.mdest_id),                // opt: Destination ID                (src dec)
      .msrc_id          (iosf_fabric_if.msrc_id),                 // opt: Source ID             (peer-to-peer)
      .msai             (iosf_fabric_if.msai),                    // opt: Sec Attr of Initiator

      .mdata            (iosf_fabric_if.mdata),                   // req: Data
      .mdparity         (iosf_fabric_if.mdparity),                // req: Data Parity

      .credit_put       (iosf_fabric_if.credit_put),              // req: Credit Update Put
      .credit_rtype     (iosf_fabric_if.credit_rtype),            // req: CUP Request Type
      .credit_cmd       (iosf_fabric_if.credit_cmd),              // req: Cmd  Cred Increment
      .credit_data      (iosf_fabric_if.credit_data),             // req: Data Cred Increment
      .credit_chid      (iosf_fabric_if.credit_chid),

      .tdec             (iosf_fabric_if.tdec),                    // req: Target Decode
      .hit              (iosf_fabric_if.hit),                     // opt: Hit
      .sub_hit           (iosf_fabric_if.sub_hit),                // opt: sub_Hit

      .cmd_put          (iosf_fabric_if.cmd_put),                 // req: Command Put
      .cmd_rtype        (iosf_fabric_if.cmd_rtype),               // req: Put Request Type
      .cmd_nfs_err      (iosf_fabric_if.cmd_nfs_err),             // opt: Non-Func Specific Err
      .cmd_chid         (iosf_fabric_if.cmd_chid),

      .tfmt             (iosf_fabric_if.tfmt),                    // req: Fmt
      .ttype            (iosf_fabric_if.ttype),                   // req: Type
      .ttc              (iosf_fabric_if.ttc),                     // req: Traffic Class
      .tth              (iosf_fabric_if.tth),                     // opt: Transaction Hint
      .tep              (iosf_fabric_if.tep),                     // opt: Error Present
      .tro              (iosf_fabric_if.tro),                     // req: Relaxed Ordering
      .tns              (iosf_fabric_if.tns),                     // req: Non-Snoop
      .tpasidtlp        (iosf_fabric_if.tpasidtlp),               // req: Pasidtlp prefix
      .tido             (iosf_fabric_if.tido),                    // opt: ID Based Ordering
      .tchain           (iosf_fabric_if.tchain),                  // opt: Chain
      .tat              (iosf_fabric_if.tat),                     // opt: Adrs Translation Svc
      .tlength          (iosf_fabric_if.tlength),                 // req: Length
      .trqid            (iosf_fabric_if.trqid),                   // req: Requester ID
      .ttag             (iosf_fabric_if.ttag),                    // req: Tag
      .tlbe             (iosf_fabric_if.tlbe),                    // req: Last DW Byte Enable
      .tfbe             (iosf_fabric_if.tfbe),                    // req: First DW Byte Enable
      .taddress         (iosf_fabric_if.taddress),                // req: Address
      .trs              (iosf_fabric_if.trs),                     // opt: root space of address
      .trsvd1_3         (iosf_fabric_if.trsvd1_3),                // req: 10-bit tag support -> bit#8
      .trsvd1_7         (iosf_fabric_if.trsvd1_7),                // req: 10-bit tag support -> bit#9
      .ttd              (iosf_fabric_if.ttd),                     // opt: TLP Digest
      .tecrc            (iosf_fabric_if.tecrc),                   // opt: End to End CRC
      .tcparity         (iosf_fabric_if.tcparity),                // opt: Command Parity
      .tdest_id         (iosf_fabric_if.tdest_id),                // opt: Destination ID (src dec)
      .tsrc_id          (iosf_fabric_if.tsrc_id),                 // opt: Source ID (peer-to-peer)
      .tsai             (iosf_fabric_if.tsai),                    // opt: Sec Attr of Initiator

      .tdata            (iosf_fabric_if.tdata),                   // req: Data
      .tdparity         (iosf_fabric_if.tdparity)                 // opt: Data Parity
);

`else

      .strap_hqm_completertenbittagen     (pins.strap_hqm_completertenbittagen),   // Exported to SOC

        //---------------------------------------------------------------------------------------------
        // IOSF Primary interface

      .prim_pok(iosf_fabric_if.prim_pok),
      .prim_clkreq(iosf_fabric_if.prim_clkreq),
      .prim_clkack(prim_clkack_q[8]),
      .prim_ism_fabric(prim_ism_fabric_q),
      .prim_ism_agent(prim_ism_agent),

      .req_put          (iosf_fabric_if.req_put),                 // req: Request Put
      .req_cdata        (iosf_fabric_if.req_cdata),               // req: Request Contains Data
      .req_rtype        (iosf_fabric_if.req_rtype),               // req: Request Type
      .req_dlen         (iosf_fabric_if.req_dlen),                // req: Request Data Length
      .req_tc           (iosf_fabric_if.req_tc),                  // req: Request Traffic Class
      .req_ns           (iosf_fabric_if.req_ns),                  // req: Request Non-Snoop
      .req_ro           (iosf_fabric_if.req_ro),                  // req: Request Relaxed Order
      .req_ido          (iosf_fabric_if.req_ido),                 // opt: Req ID Based Ordering
      .req_id           (iosf_fabric_if.req_id),                  // opt: Req ID for ID Based Ordering
      .req_locked       (iosf_fabric_if.req_locked),              // req: Request Locked
      .req_chain        (iosf_fabric_if.req_chain),               // opt: Request Chain
      .req_opp          (iosf_fabric_if.req_opp),                 // opt: Request Opportunistic
      .req_rs           (iosf_fabric_if.req_rs),                  // opt: Request Root_Space
      .req_agent        (iosf_fabric_if.req_agent),               // opt: Request agent Specific
      .req_dest_id      (iosf_fabric_if.req_dest_id),             // opt: Destination ID                (src dec)

      .gnt              (iosf_fabric_if.gnt),                     // req: Grant
      .gnt_rtype        (iosf_fabric_if.gnt_rtype),               // req: Grant Request Type
      .gnt_type         (iosf_fabric_if.gnt_type),                // req: Grant Type

      .mfmt             (iosf_fabric_if.mfmt),                    // req: Fmt
      .mtype            (iosf_fabric_if.mtype),                   // req: Type
      .mtc              (iosf_fabric_if.mtc),                     // req: Traffic Class
      .mth              (iosf_fabric_if.mth),                     // opt: Transaction Hint
      .mep              (iosf_fabric_if.mep),                     // opt: Error Present
      .mro              (iosf_fabric_if.mro),                     // req: Relaxed Ordering
      .mns              (iosf_fabric_if.mns),                     // req: Non-Snoop
      .mido             (iosf_fabric_if.mido),                    // opt: ID Based Ordering
      .mat              (iosf_fabric_if.mat),                     // opt: Adrs Translation Svc
      .mrsvd1_3         (iosf_fabric_if.mrsvd1_3),                // req: 10-bit tag support -> bit#8
      .mrsvd1_7         (iosf_fabric_if.mrsvd1_7),                // req: 10-bit tag support -> bit#9
      .mlength          (iosf_fabric_if.mlength),                 // req: Length
      .mpasidtlp        (iosf_fabric_if.mpasidtlp),               // req: Pasidtlp prefix
      .mrqid            (iosf_fabric_if.mrqid),                   // req: Requester ID
      .mtag             (iosf_fabric_if.mtag),                    // req: Tag
      .mlbe             (iosf_fabric_if.mlbe),                    // req: Last DW Byte Enable
      .mfbe             (iosf_fabric_if.mfbe),                    // req: First DW Byte Enable
      .maddress         (iosf_fabric_if.maddress),                // req: Address
      .mrs              (iosf_fabric_if.mrs),                     // opt: Root Space of address
      .mtd              (iosf_fabric_if.mtd),                     // opt: TLP Digest
      .mecrc            (iosf_fabric_if.mecrc),                   // opt: End to End CRC
      .mcparity         (iosf_fabric_if.mcparity),                // req: Command Parity
      .mdest_id         (iosf_fabric_if.mdest_id),                // opt: Destination ID                (src dec)
      .msrc_id          (iosf_fabric_if.msrc_id),                 // opt: Source ID             (peer-to-peer)
      .msai             (iosf_fabric_if.msai),                    // opt: Sec Attr of Initiator

      .mdata            (iosf_fabric_if.mdata),                   // req: Data
      .mdparity         (iosf_fabric_if.mdparity),                // req: Data Parity

      .credit_put       (iosf_fabric_if.credit_put),              // req: Credit Update Put
      .credit_rtype     (iosf_fabric_if.credit_rtype),            // req: CUP Request Type
      .credit_cmd       (iosf_fabric_if.credit_cmd),              // req: Cmd  Cred Increment
      .credit_data      (iosf_fabric_if.credit_data),             // req: Data Cred Increment

      .tdec             (iosf_fabric_if.tdec),                    // req: Target Decode
      .hit              (iosf_fabric_if.hit),                     // opt: Hit
      .sub_hit           (iosf_fabric_if.sub_hit),                // opt: sub_Hit

      .cmd_put          (iosf_fabric_if.cmd_put),                 // req: Command Put
      .cmd_rtype        (iosf_fabric_if.cmd_rtype),               // req: Put Request Type
      .cmd_nfs_err      (iosf_fabric_if.cmd_nfs_err),             // opt: Non-Func Specific Err

      .tfmt             (iosf_fabric_if.tfmt),                    // req: Fmt
      .ttype            (iosf_fabric_if.ttype),                   // req: Type
      .ttc              (iosf_fabric_if.ttc),                     // req: Traffic Class
      .tth              (iosf_fabric_if.tth),                     // opt: Transaction Hint
      .tep              (iosf_fabric_if.tep),                     // opt: Error Present
      .tro              (iosf_fabric_if.tro),                     // req: Relaxed Ordering
      .tns              (iosf_fabric_if.tns),                     // req: Non-Snoop
      .tpasidtlp        (iosf_fabric_if.tpasidtlp),               // req: Pasidtlp prefix
      .tido             (iosf_fabric_if.tido),                    // opt: ID Based Ordering
      .tchain           (iosf_fabric_if.tchain),                  // opt: Chain
      .tat              (iosf_fabric_if.tat),                     // opt: Adrs Translation Svc
      .tlength          (iosf_fabric_if.tlength),                 // req: Length
      .trqid            (iosf_fabric_if.trqid),                   // req: Requester ID
      .ttag             (iosf_fabric_if.ttag),                    // req: Tag
      .tlbe             (iosf_fabric_if.tlbe),                    // req: Last DW Byte Enable
      .tfbe             (iosf_fabric_if.tfbe),                    // req: First DW Byte Enable
      .taddress         (iosf_fabric_if.taddress),                // req: Address
      .trs              (iosf_fabric_if.trs),                     // opt: root space of address
      .trsvd1_3         (iosf_fabric_if.trsvd1_3),                // req: 10-bit tag support -> bit#8
      .trsvd1_7         (iosf_fabric_if.trsvd1_7),                // req: 10-bit tag support -> bit#9
      .ttd              (iosf_fabric_if.ttd),                     // opt: TLP Digest
      .tecrc            (iosf_fabric_if.tecrc),                   // opt: End to End CRC
      .tcparity         (iosf_fabric_if.tcparity),                // opt: Command Parity
      .tdest_id         (iosf_fabric_if.tdest_id),                // opt: Destination ID (src dec)
      .tsrc_id          (iosf_fabric_if.tsrc_id),                 // opt: Source ID (peer-to-peer)
      .tsai             (iosf_fabric_if.tsai),                    // opt: Sec Attr of Initiator

      .tdata            (iosf_fabric_if.tdata),                   // req: Data
      .tdparity         (iosf_fabric_if.tdparity)                 // opt: Data Parity
);

`endif

 //clk_inst_vc integration start

//--clk_inst1.xclk[3] 200MHz   side_clk 200MHz
//--clk_inst1.xclk[2] 300MHz   side_clk 300MHz
//--clk_inst1.xclk[1] 800MHz   not used
//--clk_inst1.xclk[0] 400MHz   i_reset_if.clk

//--clk_inst2.xclk[2] 800MHz  aon_L
//--clk_inst2.xclk[1] 800MHz  prim_L
//--clk_inst2.xclk[0] 500MHz  side_H

//--clk_inst3.xclk[3] 100MHz   pgcb_clk
//--clk_inst3.xclk[2] 1GHz     aon_H
//--clk_inst3.xclk[1] 1GHz     prim_H
//--clk_inst3.xclk[0] 400MHz   side_L

//--clk_inst4.xclk[3] 200MHz   iosf_pgcb_clk_root 200MHz
//--clk_inst4.xclk[2] 300MHz   iosf_pgcb_clk_root 300MHz
//--clk_inst4.xclk[1] 400MHz   iosf_pgcb_clk_root 400MHz
//--clk_inst4.xclk[0] 500MHz   iosf_pgcb_clk_root 500MHz

clk_inst #(.NUM_CLKS(4), .RATIO('{8'd2,  8'd3,  8'd8, 8'd4})) clk_inst1();
clk_inst #(.RATIO('{8'd8, 8'd8, 8'd5})) clk_inst2();
clk_inst #(.NUM_CLKS(4), .RATIO('{8'd1, 8'd10, 8'd10, 8'd4})) clk_inst3();
clk_inst #(.NUM_CLKS(4), .RATIO('{8'd2,  8'd3,  8'd4, 8'd5})) clk_inst4();

initial
begin
  if($test$plusargs("HQM_REFCLK_PHASE_TUNE")) begin
        refclk_phase_tune = $urandom_range(0,500);
        force hqm_tb_top.clk_inst3.refclk_phase_offset[31:0] = refclk_phase_tune;
        `ovm_info("HQM_TB_TOP",$psprintf("HQM force clk_inst3.refclk_phase_offset=%0d",refclk_phase_tune ),OVM_LOW)
  end

end

initial
begin
  if($test$plusargs("HQM_PWRGATE_PMC_WAKE_0")) begin
         prim_pwrgate_pmc_wake=0;
         side_pwrgate_pmc_wake=0;
  end else begin
         prim_pwrgate_pmc_wake=1;
         side_pwrgate_pmc_wake=1;
  end
  `ovm_info("HQM_TB_TOP",$psprintf("HQM HQM_PWRGATE_PMC_WAKE=%0d",prim_pwrgate_pmc_wake ),OVM_LOW)
end

logic [3:0] clk_inst1_clkack;
logic [2:0] clk_inst2_clkack;
logic [3:0] clk_inst3_clkack;
logic [3:0] clk_inst4_clkack;

assign clk_inst1.clkreq = 4'b1111;
assign clk_inst2.clkreq = 3'b111;
assign clk_inst3.clkreq = 4'b1111;
assign clk_inst4.clkreq = 4'b1111;
assign clk_inst1_clkack          = clk_inst1.clkack;
assign clk_inst2_clkack          = clk_inst2.clkack;
assign clk_inst3_clkack          = clk_inst3.clkack;
assign clk_inst4_clkack          = clk_inst4.clkack;


initial begin
  prim_clk_1ghz    = prim_clk_1ghz    && !$test$plusargs("HQM_PRIM_CLK_800_MHZ") && !$test$plusargs("HQM_PRIM_CLK_LOW");
  prim_clk_lowfreq = prim_clk_lowfreq && !$test$plusargs("HQM_PRIM_CLK_800_MHZ");
 `ovm_info("HQM_TB_TOP",$psprintf("HQM selected prim_clk frequency is %s", (prim_clk_lowfreq ? "400MHz" : ( prim_clk_1ghz ? "1GHz" : "800MHz" ) ) ),OVM_LOW)

  side_clk_400freqsel = side_clk_400freqsel || (side_clk_freqsel==1);
  side_clk_300freqsel = side_clk_300freqsel || (side_clk_freqsel==2);
  side_clk_200freqsel = side_clk_200freqsel || (side_clk_freqsel==3);
  if(prim_clk_1ghz) begin
     if(side_clk_400freqsel)
        `ovm_info("HQM_TB_TOP",$psprintf("HQM selected side_clk frequency is %s", "400MHz"),OVM_LOW)
     else if(side_clk_300freqsel)
        `ovm_info("HQM_TB_TOP",$psprintf("HQM selected side_clk frequency is %s", "300MHz"),OVM_LOW)
     else if(side_clk_200freqsel)
        `ovm_info("HQM_TB_TOP",$psprintf("HQM selected side_clk frequency is %s", "200MHz"),OVM_LOW)
     else
        `ovm_info("HQM_TB_TOP",$psprintf("HQM selected side_clk frequency is %s (default)", "500MHz"),OVM_LOW)
  end else begin
     if(side_clk_400freqsel)
        `ovm_info("HQM_TB_TOP",$psprintf("HQM selected side_clk frequency is %s (default)", "400MHz"),OVM_LOW)
     else if(side_clk_300freqsel)
        `ovm_info("HQM_TB_TOP",$psprintf("HQM selected side_clk frequency is %s", "300MHz"),OVM_LOW)
     else if(side_clk_200freqsel)
        `ovm_info("HQM_TB_TOP",$psprintf("HQM selected side_clk frequency is %s", "200MHz"),OVM_LOW)
     else
        `ovm_info("HQM_TB_TOP",$psprintf("HQM selected side_clk frequency is %s (default)", "400MHz"),OVM_LOW)
  end
  //`ovm_info("HQM_TB_TOP",$psprintf("HQM set:side_clk_freqsel=%0d side_clk_400freqsel=%0d side_clk_300freqsel=%0d side_clk_200freqsel=50d",side_clk_freqsel,side_clk_400freqsel,side_clk_300freqsel,side_clk_200freqsel ),OVM_LOW)
end

// 1200MHz -> change to 1GHz
assign aon_clk_root                 = prim_clk_1ghz ? clk_inst3.xclk[2] : clk_inst2.xclk[2];

// 800/1000 MHz
assign prim_clk_root                = prim_clk_lowfreq? clk_inst4.xclk[1] : (prim_clk_1ghz ? clk_inst3.xclk[1]         : clk_inst2.xclk[1]);
assign prim_clk_sync_root           = prim_clk_lowfreq? clk_inst4.xclk_usync[1] : (prim_clk_1ghz ? clk_inst3.xclk_usync[1]   : clk_inst2.xclk_usync[1]);

// 400MHz default (prim_clk runs at 800MHz); 500MHz as option when prim_clk runs at 1GHz
// clk_inst1.xclk[3] is 200MHz
// clk_inst1.xclk[2] is 300MHz
// clk_inst3.xclk[0] is 400MHz
// clk_inst2.xclk[0] is 500MHz
// when prim_clk running at 1GHz, regularly side_clk runs at 500MHz
//                                but TB provide +HQM_SIDE_CLK_400MHZ to select side_clk=400MHz even prim_clk runs at 1GHz (this is for power tests HSD1507681768)
//                                    TB provide +HQM_SIDE_CLK_300MHZ to select side_clk=300MHz even prim_clk runs at 1GHz
//                                    TB provide +HQM_SIDE_CLK_200MHZ to select side_clk=200MHz even prim_clk runs at 1GHz
// side_clk_freqsel==0: default
// side_clk_freqsel==1: 400MHz
// side_clk_freqsel==2: 300MHz
// side_clk_freqsel==3: 200MHz
assign side_clk_root                = prim_clk_1ghz ?  (side_clk_200freqsel?  clk_inst1.xclk[3] : (side_clk_300freqsel? clk_inst1.xclk[2] : (side_clk_400freqsel ? clk_inst3.xclk[0] : clk_inst2.xclk[0]))) :
                                                       (side_clk_200freqsel?  clk_inst1.xclk[3] : (side_clk_300freqsel? clk_inst1.xclk[2] : clk_inst3.xclk[0]));

// 100MHz
assign pgcb_clk_root                = clk_inst3.xclk[3];

// iosf_pgcb_clk_root
//--clk_inst4.xclk[3] 200MHz
//--clk_inst4.xclk[2] 300MHz
//--clk_inst4.xclk[1] 400MHz
//--clk_inst4.xclk[0] 500MHz
//assign iosf_pgcb_clk_root           = prim_clk_1ghz ? clk_inst4.xclk[0] : clk_inst4.xclk[1]  ;
assign iosf_pgcb_clk_root           = prim_clk_1ghz ? (side_clk_200freqsel?  clk_inst4.xclk[3] : (side_clk_300freqsel? clk_inst4.xclk[2] : (side_clk_400freqsel ? clk_inst4.xclk[1] : clk_inst4.xclk[0]))) :
                                                      (side_clk_200freqsel?  clk_inst4.xclk[3] : (side_clk_300freqsel? clk_inst4.xclk[2] : clk_inst4.xclk[1]));

//clk_inst_vc integration end

always_ff @(posedge prim_clk_root or negedge i_reset_if.powergood_rst_b) begin
  if (~i_reset_if.powergood_rst_b) begin
    prim_clkack_q <= '0;
  end else begin
    prim_clkack_q <= {(iosf_fabric_if.prim_clkack & (~force_prim_clk_low)), prim_clkack_q[8:1]};
  end
end

always_ff @(negedge prim_clk_root or negedge i_reset_if.powergood_rst_b) begin
 if (~i_reset_if.powergood_rst_b) begin
   prim_ism_fabric_q            <= '0;
   prim_clkack_negedge_q        <= '0;
 end else begin
   prim_ism_fabric_q            <= iosf_fabric_if.prim_ism_fabric;
   prim_clkack_negedge_q        <= iosf_fabric_if.prim_clkack;
 end
end

// Drive prim_clk during prim_rst_b and for 8 cycles after reset is removed

logic [7:0] drive_prim_clk;

always_ff @(negedge prim_clk_root) begin
 if (~iosf_fabric_if.prim_rst_b) begin
  drive_prim_clk <= '1;
 end else begin
  drive_prim_clk <= {1'b0, drive_prim_clk[7:1]};
 end
end

//always_comb begin
//
//    if (`HQM_MASTER_PATH.pgcb_isol_en_b) begin
//        release `HQM_PATH.`I_SYSTEM_BUF_HQM_CLK_TRUNK.o;
//    end else begin
//        force `HQM_PATH.`I_SYSTEM_BUF_HQM_CLK_TRUNK.o = 1'bx;
//    end
//end

assign force_primclk    = 1'b0; // This is forced in some tests

assign prim_clk         = prim_clk_root & (force_primclk |
                          ((drive_prim_clk[0] | prim_clkack_q[0] | prim_clkack_negedge_q | (prim_ism_fabric_q != 0)) & (~force_prim_clk_low)));
assign prim_clk_sync    = prim_clk_sync_root & i_reset_if.pm_ip_clk_halt_b_2;

assign fdtf_clk         = aon_clk_root  & i_reset_if.pm_ip_clk_halt_b_2;
assign pgcb_clk         = pgcb_clk_root & i_reset_if.pm_ip_clk_halt_b_2;
assign side_clk         = side_clk_root & i_reset_if.pm_ip_clk_halt_b_2;

assign iosf_pgcb_clk    = iosf_pgcb_clk_root & i_reset_if.pm_ip_clk_halt_b_2;

// hw_reset_force_pwr_on
initial
begin
  if ($test$plusargs("HQM_INIT_HW_RESET_FORCE_PWR_ON")) begin
     #1000ns;
     force hw_reset_force_pwr_on = 1'b1;
     $display("[%0t] HQM_TB_TOP: Force hw_reset_force_pwr_on=1", $time);
  end
end

// DFX interface

initial
begin
  if ( !($test$plusargs("HQM_SKIP_HCW_WR_RDY_AGITATE")) ) begin
        agitate_wr_rdy = 1;
  end else begin
        agitate_wr_rdy = 0;
  end
end

//-- agitate_power == 0 (Don't agitate), agitate_power == 1 (Can Agitate) --//
assign agitate_power = (i_reset_if.vcccfn_pwr_on);

// NS: Moved agitate logic to single file -> `include "hqm_tb_agitate_logic.sv" // Needs fixes for path hierarchy //
//-- abbiswal -- Moved back the logic for agitation --//
hqm_tb_agitate #(
  .NAME("hcw_wr_rdy"),
  .PATH("hqm_tb_top.u_hqm.i_hqm_sip.hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.i_hcw_wr_aw_db.in_ready_f"),
  .VALUE(0)
) i_hcw_wr_rdy_agitate (
  .clk(prim_clk_root),
  .switch(agitate_wr_rdy),
  .power(agitate_power)
);

initial begin
    defaults();
end

task defaults();
begin


        force_prim_clk_low = '0;
        if($test$plusargs("hqm_pma_safemode_c") || $test$plusargs("hqm_pma_safemode_d"))
           pma_safemode = 1'b1;
        else
           pma_safemode = 1'b0;

        fdfx_sbparity_def = '0;

        fscan_mode = '0;
        fscan_rstbypen = '0;
        fscan_byprst_b = '1;
        fscan_clkungate = '0;
        fscan_clkungate_syn = '0;
        fscan_latchopen = '0;
        fscan_latchclosed_b = '1;
        fscan_shiften = '0;
        fscan_ret_ctrl = '0;
        fscan_isol_ctrl = '0;
        fscan_isol_lat_ctrl = '0;

        prim_jta_force_clkreq = '0;
        prim_jta_force_creditreq = '0;
        prim_jta_force_idle = '0;
        prim_jta_force_notidle = '0;

        gpsb_jta_clkgate_ovrd = '0;
        gpsb_jta_force_clkreq = '0;
        gpsb_jta_force_creditreq = '0;
        gpsb_jta_force_idle = '0;
        gpsb_jta_force_notidle = '0;

        cdc_prim_jta_clkgate_ovrd = '0;
        cdc_prim_jta_force_clkreq = '0;

        cdc_side_jta_clkgate_ovrd = '0;
        cdc_side_jta_force_clkreq = '0;


end
endtask

always @(edge force_prim_side_clkack_hqm) begin
  if (force_prim_side_clkack_hqm == 1)  begin
     force u_hqm.side_clkack = 0;
     //force u_hqm.side_clk = 0;
`ifdef HQM_SFI
     force i_hqm_sfi2iosf.prim_clkack = 0;
`endif
     force u_hqm.prim_clkack = 0;
     force u_hqm.prim_clk = 0;
  end else if (force_prim_side_clkack_hqm == 0) begin
     release u_hqm.side_clkack;
     //release u_hqm.side_clk;
`ifdef HQM_SFI
     release i_hqm_sfi2iosf.prim_clkack;
`endif
     release u_hqm.prim_clkack;
     release u_hqm.prim_clk;
  end
end

    final begin
        hqm_tb_eot();
    end


    //---------------------
    //-- task hqm_tb_eot()
    //---------------------
	task eot_status_check();
		if((|eot_status) | (|eot_chk_status)) begin
            $display("[%0t] HQM_TB_TOP: EOT_CHECK_STATUS FAILED-> ERROR: eot_status=0x%0d, eot_chk_status=0x%0x", $time, eot_status,eot_chk_status);
		end
		else begin
            $display("[%0t] HQM_TB_TOP: EOT_CHECK_STATUS PASSED->        eot_status=0x%0d, eot_chk_status=0x%0x", $time, eot_status, eot_chk_status);
		end
	endtask
    //---------------------
    //-- task hqm_tb_eot()
    //---------------------
    task hqm_tb_eot();

        logic pf;
	
        if($test$plusargs("HQM_TB_EOT_CHECK_DISABLE") == 0)begin

        if($test$plusargs("HQM_TB_HQM_PM_UNIT_EOT_CHECK_DISABLE") == 0)begin
          $display("[%0t]==== HQM_TB_TOP : HQM_PM_UNIT eot_check ==== ", $time);
         `HQM_PM_UNIT_INST_PATH.eot_check(pf);
          eot_status[13] = pf;
          $display("[%0t]==== HQM_TB_TOP : HQM_PM_UNIT eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
        end

        if($test$plusargs("HQM_TB_HQM_EOT_CHECK_DISABLE") == 0)begin
          $display("[%0t]==== HQM_TB_TOP : HQM eot_check ==== ", $time);
         `HQM_INST_SYS_PATH.eot_check(pf);
          eot_status[12] = pf;
          $display("[%0t]==== HQM_TB_TOP : HQM eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
        end

        if($test$plusargs("HQM_TB_HQM_CHP_FREELIST_EOT_CHECK_DISABLE") == 0)begin
          $display("[%0t]==== HQM_TB_TOP : HQM_CHP_FREELIST eot_check ==== ", $time);
         `HQM_CHP_FREELIST_INST_PATH.eot_check(pf);
          eot_status[11] = pf;
          $display("[%0t]==== HQM_TB_TOP : HQM_CHP_FREELIST eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
        end

        if($test$plusargs("HQM_TB_HQM_SIF_EOT_CHECK_DISABLE") == 0)begin
          $display("[%0t]==== HQM_TB_TOP : HQM_SIF eot_check ==== ", $time);
         `HQM_SIF_INST_PATH.eot_check(pf);
          eot_status[10] = pf;
          $display("[%0t]==== HQM_TB_TOP : HQM_SIF eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
        end

        if($test$plusargs("HQM_TB_HQM_SYSTEM_EOT_CHECK_DISABLE") == 0)begin
          $display("[%0t]==== HQM_TB_TOP : HQM_SYSTEM eot_check ==== ", $time);
         `HQM_SYSTEM_INST_PATH.eot_check(pf);
          eot_status[9] = pf;
          $display("[%0t]==== HQM_TB_TOP : HQM_SYSTEM eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
        end

          if($test$plusargs("HQM_TB_HQMCORE_MST_EOT_CHECK_DISABLE") == 0)begin
        $display("[%0t]==== HQM_TB_TOP : MST eot_check ==== ", $time);
         `HQM_MASTER_INST_PATH.eot_check(pf);
        eot_status[8] = pf;
        $display("[%0t]==== HQM_TB_TOP : MST eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
          end

          if($test$plusargs("HQM_TB_HQMCORE_AQED_EOT_CHECK_DISABLE") == 0)begin
        $display("[%0t]==== HQM_TB_TOP : AQED eot_check ==== ", $time);
         `HQM_AQED_PIPE_INST_PATH.eot_check(pf);
        eot_status[7] = pf;
        $display("[%0t]==== HQM_TB_TOP : AQED eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
          end
	
          if($test$plusargs("HQM_TB_HQMCORE_QED_EOT_CHECK_DISABLE") == 0)begin
        $display("[%0t]==== HQM_TB_TOP : QED eot_check ==== ", $time);
         `HQM_QED_PIPE_INST_PATH.eot_check(pf);
        eot_status[6] = pf;
        $display("[%0t]==== HQM_TB_TOP : QED eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
          end
		
          if($test$plusargs("HQM_TB_HQMCORE_ATM_EOT_CHECK_DISABLE") == 0)begin
        $display("[%0t]==== HQM_TB_TOP : ATM eot_check ==== ", $time);
         `HQM_ATM_PIPE_INST_PATH.eot_check(pf);
        eot_status[5] = pf;
        $display("[%0t]==== HQM_TB_TOP : ATM eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
          end
	
          if($test$plusargs("HQM_TB_HQMCORE_DIR_EOT_CHECK_DISABLE") == 0)begin
        $display("[%0t]==== HQM_TB_TOP : DIR eot_check ==== ", $time);
         `HQM_DIR_PIPE_INST_PATH.eot_check(pf);
        eot_status[4] = pf;
        $display("[%0t]==== HQM_TB_TOP : DIR eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);   	
          end

          if($test$plusargs("HQM_TB_HQMCORE_NALB_EOT_CHECK_DISABLE") == 0)begin
        $display("[%0t]==== HQM_TB_TOP : NALB eot_check ==== ", $time);
         `HQM_NALB_PIPE_INST_PATH.eot_check(pf);
        eot_status[3] = pf;
        $display("[%0t]==== HQM_TB_TOP : NALB eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
          end

          if($test$plusargs("HQM_TB_HQMCORE_LSP_EOT_CHECK_DISABLE") == 0)begin
        $display("[%0t]==== HQM_TB_TOP : LSP eot_check ==== ", $time);
         `HQM_LIST_SEL_PIPE_INST_PATH.eot_check(pf);
        eot_status[2] = pf;
        $display("[%0t]==== HQM_TB_TOP : LSP eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
          end
	
          if($test$plusargs("HQM_TB_HQMCORE_ROP_EOT_CHECK_DISABLE") == 0)begin
        $display("[%0t]==== HQM_TB_TOP : ROP eot_check ==== ", $time);
         `HQM_REORDER_PIPE_INST_PATH.eot_check(pf);
        eot_status[1] = pf;
        $display("[%0t]==== HQM_TB_TOP : ROP eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
          end

          if($test$plusargs("HQM_TB_HQMCORE_CHP_EOT_CHECK_DISABLE") == 0)begin
        $display("[%0t]==== HQM_TB_TOP : CHP eot_check ==== ", $time);
         `HQM_CREDIT_HIST_PIPE_INST_PATH.eot_check(pf);
        eot_status[0] = pf;
        $display("[%0t]==== HQM_TB_TOP : CHP eot_check get pf=%0d, eot_status=0x%0x\n", $time, pf, eot_status);
          end
      end

	eot_status_check();
        $display("\n[%0t]==== HQM_TB_TOP : ALL eot_status=0x%0x", $time, eot_status);

    endtask



    initial begin:eot_init_val

        `ifndef HQM_MPP
          force hqm_tb_top.u_hqm.i_hqm_sip.par_logic_pgcb_fet_en_ack_b              = hqm_tb_top.u_hqm.i_hqm_sip.hqm_sip_aon_wrap.i_hqm_master_pgcb_fet_en_b;
        `endif

        if($test$plusargs("HQM_FORCE_FET_EN_ACK_B_1")) begin
          force  hqm_tb_top.u_hqm.i_hqm_sip.hqm_sip_aon_wrap.i_hqm_AW_fet_en_sequencer.par_mem_pgcb_fet_en_ack_b = 1'b1;
        end

        eot_status = 32'h0;
        eot_chk_status = 32'h0;
	end

property  vr_sbc_0235_prop;
  @(posedge iosf_sbc_fabric_if.side_clk)
  disable iff ((iosf_sbc_fabric_if.side_rst_b !== 1'b0) || !($test$plusargs("HQM_EN_VR_SBC_0235")))
  (iosf_sbc_fabric_if.side_rst_b== 1'b0) |-> (iosf_sbc_fabric_if.side_clkreq == 1'b0);
endproperty: vr_sbc_0235_prop

vr_sbc_0235 : assert property (vr_sbc_0235_prop)
else begin
  `ovm_error("HQM_TB_TOP",$psprintf("ERROR vr_sbc_0235: side_clkreq is not de-asserted during reset"))
  $error("side_clkreq is not de-asserted during reset");
end

property  prim_clkreq_prop;
  @(posedge iosf_fabric_if.prim_clk)
  disable iff ((iosf_fabric_if.prim_rst_b !== 1'b0) || !($test$plusargs("HQM_TB_TOP_EN_CLK_REQ_CHK")))
  (iosf_fabric_if.prim_rst_b== 1'b0) |-> (iosf_fabric_if.prim_clkreq == 1'b0);
endproperty: prim_clkreq_prop

assert_prim_clkreq : assert property (prim_clkreq_prop)
else begin
  `ovm_error("HQM_TB_TOP",$psprintf("ERROR assert_prim_clkreq: prim_clkreq is not de-asserted during reset"))
  $error("prim_clkreq is not de-asserted during reset");
end

  initial begin // Discrepancy between the IOSF spec 1.2 and SVC check VR.SBC.0235: Assert error if Clkreq is not asserted during reset
      //iosf_sbc_fabric_if.disableProperty(0235,1,1);
      //iosf_sbc_fabric_if.disableProperty(0235,0,1);
      //$assertoff(0,hqm_tb_top.iosf_sbc_fabric_if.genblk.sbc_compliance.clock_gating_compliance.ISMPM_SBMI_062_PRI_157_StateInitialization_clkack.ISMPM_SBMI_062_PRI_157_StateInitialization_clkack_ASSERT);
      //$assertoff(0,hqm_tb_top.iosf_sbc_fabric_if.genblk.sbc_compliance.SBMI_062_ClkAckValidFromReset.SBMI_062_ClkAckValidFromReset_ASSERT);
      //$assertoff(0,hqm_tb_top.hqm_test_island.hqm_global_ti.iosf_fabric_VC.genblk1.primary_compmon.clock_gating_compliance.ISMPM_SBMI_062_PRI_157_StateInitialization_clkack.ISMPM_SBMI_062_PRI_157_StateInitialization_clkack_ASSERT);
      //$assertoff(0,hqm_tb_top.hqm_test_island.hqm_global_ti.iosf_fabric_VC.genblk1.primary_compmon.clock_gating_compliance.ISMPM_SBMI_062_PRI_157_StateInitialization_clkreq.ISMPM_SBMI_062_PRI_157_StateInitialization_clkreq_ASSERT);
      if (!$test$plusargs("HQM_TB_TOP_DIS_CDC_ASSERT")) begin
         $assertoff(0,hqm_tb_top.u_hqm.i_hqm_sip.hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_iosfsb_core.i_side_cdc.u_CdcMainClock.aClkReqAckON);
         $assertoff(0,hqm_tb_top.u_hqm.i_hqm_sip.hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_iosfsb_core.i_side_cdc.u_CdcMainClock.aGClockAck);
         $assertoff(0,hqm_tb_top.u_hqm.i_hqm_sip.hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_iosfsb_core.i_side_cdc.u_CdcMainClock.aGClockActiveFell);
         $assertoff(0,hqm_tb_top.u_hqm.i_hqm_sip.hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_iosfsb_core.i_side_cdc.u_CdcMainClock.assert_gclock_ack_async[0].aGClockAckAfterReq);
      end

      // Because the IOSF_PVC violates its own compliance by changing its fabric ISM from IDLE to CREDIT_REQ
      // while the prim_pok is still deasserted...

  `ifdef IP_MID_TE
      $assertoff(0,hqm_tb_top.hqm_test_island.hqm_global_ti.iosf_fabric_VC.genblk1.primary_compmon.fabric_ism_compliance.ISMPM_002_StateTransitionFrom_FABRIC_IDLE_3.ISMPM_002_StateTransitionFrom_FABRIC_IDLE_3_ASSERT);
  `endif

  end

//initial lp_msg_register("LP_MSG_ISO_OUT_NO_TGL", "ERROR", "ON", "Assertion failure: No toggle on isolated signal '%s' when isolation is disabled for power domain '%s'. Value of isolated signal = %v, CLAMP_VALUE = %d. \n");
initial begin
    lp_msg_register( "LP_ISO_CONTROL_CORRUPT_WHILE_SUPPLY_ON", "ERROR", "ON", "corruption to %b on isolation control '%s' of isolation strategy '%s' powered by supply '%s' in mode '%s' with voltage=%fV\n" );
    lp_msg_register( "LP_ISO_OUT_CORRUPT_ON_CONTROL_DEASSERT", "ERROR", "ON", "corruption to %b on isolated signal '%s' when isolation control '%s' is de-asserted to %b for isolation strategy '%s' powered by supply '%s' in mode '%s' with voltage=%fV\n" );
    lp_msg_register( "LP_ISO_OUT_TOGGLE_ON_CONTROL_DEASSERT",  "ERROR", "ON", "toggle from CLAMP=%s to %b on isolated signal '%s' when isolation control '%s' is de-asserted to %b for isolation strategy '%s' powered by supply '%s' in mode '%s' with voltage=%fV\n" );
end // initial

`ifndef HQM_SFI
    initial begin
      assert($bits(hqm_tb_top.u_hqm.msai) == $bits(hqm_tb_top.u_hqm.tsai))
        `ovm_info("HQM_TB_TOP",$psprintf("SAI Width matched between MSAI and TSAI"),OVM_LOW)
      else
        `ovm_error("HQM_TB_TOP",$psprintf("SAI_WIDTH Mismatch. MSAI width = 0x%0x, TSAI width = 0x%0x", $bits(hqm_tb_top.u_hqm.msai), $bits(hqm_tb_top.u_hqm.tsai)))
    end
`endif
//hqm register functional cover group
    hqm_reg_func_cov_groups i_hqm_reg_func_cov_groups();

endmodule

