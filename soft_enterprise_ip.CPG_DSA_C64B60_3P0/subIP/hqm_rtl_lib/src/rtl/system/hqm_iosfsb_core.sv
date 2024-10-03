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
// HQM IOSF sideband interface
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_iosfsb_core

     import hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*, hqm_sif_csr_pkg::*, hqm_system_pkg::*, hqm_system_type_pkg::*;
#(
     parameter SAME_FREQUENCY              = 0                              // Asynchronous endpoint=0, 1 otherwise

    // SB SAI Extended Header Params

    ,parameter RX_EXT_HEADER_SUPPORT       = HQMIOSF_RX_EXT_HEADER_SUPPORT  // Indicate whether agent supports receiving
    ,parameter TX_EXT_HEADER_SUPPORT       = HQMIOSF_TX_EXT_HEADER_SUPPORT  // extended headers.
    ,parameter NUM_RX_EXT_HEADERS          = HQMIOSF_NUM_RX_EXT_HEADERS
    ,parameter NUM_TX_EXT_HEADERS          = HQMIOSF_NUM_TX_EXT_HEADERS
    ,parameter RX_EXT_HEADER_IDS           = HQMIOSF_RX_EXT_HEADER_IDS
    ,parameter TX_EXT_HEADER_IDS           = HQMIOSF_TX_EXT_HEADER_IDS

    // SB Target Settings

    ,parameter MAX_TGT_ADR                 = HQMEPSB_MAX_TGT_ADR
    ,parameter MAX_TGT_DAT                 = HQMEPSB_MAX_TGT_DAT

    ,parameter HQM_SBE_NPQUEUEDEPTH        = 4
    ,parameter HQM_SBE_PCQUEUEDEPTH        = 4
    ,parameter HQM_SBE_DATAWIDTH           = 8
    ,parameter HQM_SBE_PARITY_REQUIRED     = 1
) (
    // Clock/Reset Signals

     input  logic                           pgcb_clk

    ,input  logic                           side_clk
    ,output logic                           side_gated_clk

    ,input  logic                           side_pwrgate_pmc_wake
    ,input  logic                           side_rst_b
    ,output logic                           side_gated_rst_b
    ,input  logic                           side_gated_rst_prim_b       // side_rst_b synced to prim_clk

    ,output logic                           side_pok

    ,output logic                           side_clkreq
    ,input  logic                           side_clkack

    ,input  logic                           prim_freerun_clk
    ,input  logic                           prim_gated_clk
    ,input  logic                           prim_nonflr_clk

    ,input  logic                           prim_rst_b
    ,input  logic                           prim_gated_rst_b

    ,input  logic                           hard_rst_np

    // Clock gating ISM Signals (endpoint)

    ,input  logic [2:0]                     gpsb_side_ism_fabric
    ,output logic [2:0]                     gpsb_side_ism_agent
    ,output logic                           sbe_prim_clkreq

    ,output logic                           ri_iosf_sb_idle
    ,output logic                           adr_clkreq
    ,output logic                           rpa_clkreq

    ,output logic                           force_ip_inaccessible
    ,output logic                           force_warm_reset

    ,output logic                           prim_clkreq_async_sbe
    ,input  logic                           prim_clkack_async_sbe

    // Egress port interface to the IOSF Sideband Channel

    ,input  logic                           gpsb_mpccup
    ,input  logic                           gpsb_mnpcup
    ,output logic                           gpsb_mpcput
    ,output logic                           gpsb_mnpput
    ,output logic                           gpsb_meom
    ,output logic [HQM_SBE_DATAWIDTH-1:0]   gpsb_mpayload
    ,output logic                           gpsb_mparity

    // Ingress port interface to the IOSF Sideband Channel

    ,output logic                           gpsb_tpccup
    ,output logic                           gpsb_tnpcup
    ,input  logic                           gpsb_tpcput
    ,input  logic                           gpsb_tnpput
    ,input  logic                           gpsb_teom
    ,input  logic [HQM_SBE_DATAWIDTH-1:0]   gpsb_tpayload
    ,input  logic                           gpsb_tparity

    // SAI for tx

    ,input  logic [SAI_WIDTH:0]             strap_hqm_tx_sai

    // SAI for completions

    ,input  logic [SAI_WIDTH:0]             strap_hqm_cmpl_sai

    // Legal SAI values for Sideband ResetPrep message

    ,input  logic [SAI_WIDTH:0]             strap_hqm_resetprep_sai_0
    ,input  logic [SAI_WIDTH:0]             strap_hqm_resetprep_sai_1

    // Legal SAI values for Sideband ForcePwrGatePOK message

    ,input  logic [SAI_WIDTH:0]             strap_hqm_force_pok_sai_0
    ,input  logic [SAI_WIDTH:0]             strap_hqm_force_pok_sai_1

    // GPSB Source Port ID

    ,input  logic [15:0]                    strap_hqm_gpsb_srcid
    ,input  logic                           strap_hqm_16b_portids

    // Parity Message configuration

    ,input  logic [15:0]                    strap_hqm_do_serr_dstid
    ,input  logic [2:0]                     strap_hqm_do_serr_tag
    ,input  logic                           strap_hqm_do_serr_sairs_valid
    ,input  logic [SAI_WIDTH:0]             strap_hqm_do_serr_sai
    ,input  logic [ RS_WIDTH:0]             strap_hqm_do_serr_rs
    ,input  logic                           fdfx_sbparity_def

    // RI

    ,input  logic [15:0]                    strap_hqm_err_sb_dstid      // Sideband destination port ID for PCIe errors
    ,input  logic [SAI_WIDTH:0]             strap_hqm_err_sb_sai        // SAI sent with PCIe error messages
    ,input  logic [SAI_WIDTH:0]             strap_hqm_resetprep_ack_sai // SAI sent with ResetPrepAck messages

    // New

    ,input  logic                           pma_safemode

    ,input  IOSFS_CGCTL_t                   iosfs_cgctl

    // EP Fuses/Straps Global Constants

    ,output hqm_sif_fuses_t                 sb_ep_fuses                 // Contains all fuses

    // Register access controls

    ,input  logic [63:0]                    hqm_csr_rac
    ,input  logic [63:0]                    hqm_csr_wac

    // Master interface

    ,output logic                           master_ctl_load
    ,output logic [31:0]                    master_ctl

    ,input  logic                           cfg_visa_sw_control_write       // prim_clk
    ,input  VISA_SW_CONTROL_t               cfg_visa_sw_control_wdata       // prim_clk

    ,output VISA_SW_CONTROL_t               cfg_visa_sw_control             // prim_clk
    ,output logic                           cfg_visa_sw_control_write_done  // prim_clk

    // DFx

    ,input  logic                           fscan_shiften               //
    ,input  logic                           fscan_latchopen             //
    ,input  logic                           fscan_latchclosed_b         //
    ,input  logic                           fscan_clkungate             // scan mode clock gate override
    ,input  logic                           fscan_clkungate_syn         // scan mode clock gate override
    ,input  logic                           fscan_rstbypen              //
    ,input  logic                           fscan_byprst_b              //
    ,input  logic                           fscan_mode                  //

    // Side Band Channel FISM signals

    ,input  logic                           gpsb_jta_clkgate_ovrd
    ,input  logic                           gpsb_jta_force_clkreq
    ,input  logic                           gpsb_jta_force_creditreq
    ,input  logic                           gpsb_jta_force_idle
    ,input  logic                           gpsb_jta_force_notidle

    ,input  logic                           cdc_side_jta_force_clkreq       // DFx force assert clkreq
    ,input  logic                           cdc_side_jta_clkgate_ovrd       // DFx force GATE gclock

    ,input  SIDE_CDC_CTL_t                  cfg_side_cdc_ctl

    // Fuse interface

    ,output logic                           fuse_force_on
    ,output logic                           fuse_proc_disable

    ,input  logic[EARLY_FUSES_BITS_TOT-1:0] early_fuses
    ,output logic                           ip_ready
    ,input  logic                           strap_no_mgmt_acks
    ,output logic                           reset_prep_ack

    //-----------------------------------------------------------------
    // SB to EP Incoming - CSR Access Interface - handled by hqm_ri_cds
    //-----------------------------------------------------------------
    // To ri_iosf_sb block for sideband unsupported requests

    ,output hqm_sb_ri_cds_msg_t             sb_cds_msg                  // Tweaked version of sb_ep_msg for hqm_ri_cds.
    ,output logic                           sb_ep_parity_err_sync

    ,input  logic                           cds_sb_wrack                // from CDS - ack an incoming write request that has been sent
    ,input  logic                           cds_sb_rdack                // from CDS - ack an incoming read request that has been sent
    ,input  hqm_cds_sb_tgt_cmsg_t           cds_sb_cmsg                 // Completion message back to the sb_tgt in the shim

    //-----------------------------------------------------------------
    // Error Interface
    //-----------------------------------------------------------------
    // ERR -> IOSFSB - Error Message info

    ,input  logic                           err_gen_msg                 // Generate error message to host
    ,input  logic [7:0]                     err_gen_msg_data            // Error message data
    ,input  logic [15:0]                    err_gen_msg_func            // HSD 5313841 - Error function should be included in error message
    ,output logic                           err_sb_msgack

    //-----------------------------------------------------------------
    // PGCB Interface
    //-----------------------------------------------------------------

    ,input  logic                           pm_fsm_d3tod0_ok

    ,output logic                           force_pm_state_d3hot

    //-----------------------------------------------------------------
    // ADR interface
    //-----------------------------------------------------------------

    ,input  logic                           pm_hqm_adr_assert
    ,output logic                           hqm_pm_adr_ack

    //-----------------------------------------------------------------
    // Reset Prep Handling Interface
    //-----------------------------------------------------------------

    ,output logic                           sif_mstr_quiesce_req        // Tell Primary Channel to block Mastered logic
    ,output logic                           quiesce_qualifier

    ,input  logic                           sif_mstr_quiesce_ack        // Tell RI_IOSF_SB that the IOSF MSTR is empty.
);

`include "hqm_sbcglobal_params.vm"
`include "hqm_sbcstruct_local.vm"

//--------------------------------------------------------------------------
// Local parameter definitions
//--------------------------------------------------------------------------

localparam ASYNCENDPT   = SAME_FREQUENCY ? 0 : 1;  // Asynchronous endpoint=1, 0 otherwise
localparam DEF_PWRON    = 0;

//--------------------------------------------------------------------------
// Interconnecting Signals
//--------------------------------------------------------------------------
// Clock gating ISM Signals
// Clock/Reset Signals
logic                                 agent_side_rst_b ;
logic                                 sbi_sbe_clkreq ;
logic                                 sbi_sbe_idle ;
logic [2:0]                           gpsb_side_ism_fabric_pgmask ;

// Target interface outputs to the AGENT block
logic                                 sbi_sbe_tmsg_pcfree ; //
logic                                 sbi_sbe_tmsg_npfree ; //
logic                                 sbi_sbe_tmsg_npclaim ; //

// Target interface inputs to the AGENT block
logic                                 sbe_sbi_tmsg_pcput ; //
logic                                 sbe_sbi_tmsg_npput ; //
logic                                 sbe_sbi_tmsg_pcmsgip ; // unused
logic                                 sbe_sbi_tmsg_npmsgip ; //
logic                                 sbe_sbi_tmsg_pceom ; //
logic                                 sbe_sbi_tmsg_npeom ; //
logic [31:0]                          sbe_sbi_tmsg_pcpayload ; //
logic [31:0]                          sbe_sbi_tmsg_nppayload ; //
logic                                 sbe_sbi_tmsg_pccmpl ; //
logic                                 sbe_sbi_tmsg_pcvalid_nc ; // unused
logic                                 sbe_sbi_tmsg_npvalid_nc ; // unused

// Master interface outputs to the AGENT block
logic [ 1:0]                          sbi_sbe_mmsg_pcirdy ; //
logic                                 sbi_sbe_mmsg_npirdy ; //
logic [ 1:0]                          sbi_sbe_mmsg_pceom ; //
logic                                 sbi_sbe_mmsg_npeom ; //
logic [ 1:0][31:0]                    sbi_sbe_mmsg_pcpayload ; //
logic [31:0]                          sbi_sbe_mmsg_nppayload ; //
logic [ 1:0]                          sbi_sbe_mmsg_pcparity ; //
logic                                 sbi_sbe_mmsg_npparity ; //

// Master interface inputs to the AGENT block
logic                                 sbe_sbi_mmsg_pctrdy ; //
logic                                 sbe_sbi_mmsg_nptrdy ; //
logic                                 sbe_sbi_mmsg_pcmsgip ; // unused
logic                                 sbe_sbi_mmsg_npmsgip_nc ; // unused
logic [ 1:0]                          sbe_sbi_mmsg_pcsel ; //
logic                                 sbe_sbi_mmsg_npsel ; //
logic                                 cgctrl_clkgaten ; // registers
logic                                 cgctrl_clkgatedef ;
logic [ 7:0]                          cgctrl_idlecnt ; // Config CDV has idle cnt value set to >5'h10

// Ingress Target Message Interface - Msg for the IP
hqm_sb_tgt_msg_t                      tgt_ip_msg ; // Tgt to IP Msg struct
logic                                 ip_tgt_msg_trdy ; // handshake for Tgt to IP

// Egress Target Completion Interface - Cmp from the IP
hqm_sb_tgt_cmsg_t                     ip_tgt_cmsg ; // IP to Tgt Cmp Msg
logic                                 tgt_ip_cmsg_free_nc ;
                                                                                          //  This is generated by hqm_sb_tgt it indicates that no more
                                                                                          //  completion can be taken. I suspect since we only support
                                                                                          //  SB egress completions of 1 DW this is never and issue.
                                                                                          // Available free space for Cmp

// Ingress Master Completion Interface - Cmp to the IP
hqm_sb_ep_cmp_t                       tgt_ip_cmsg ;

// Egress Master Message Interface - Msg from the IP
hqm_ep_sb_msg_t                       ip_mst_msg ;
logic                                 mst_ip_msg_trdy ;

logic [31:0]                          tx_ext_headers ;

// Unconnected signals
logic                                 gated_side_clk_nc ;
logic                                 sbe_sbi_idle_nc ;
logic                                 sbe_sbi_clk_valid_nc ;

visa_port_tier1                       visa_port_tier1_sb_nc ; // VISA debug candidates
visa_epfifo_tier1_sb                  visa_fifo_tier1_sb_nc ; // high priority
visa_epfifo_tier1_ag                  visa_fifo_tier1_ag_nc ;
visa_agent_tier1                      visa_agent_tier1_ag_nc ;
//visa_reg_tier1                      visa_reg_tier1_ag_nc ;

visa_port_tier2                       visa_port_tier2_sb_nc ; // VISA debug candidates
visa_epfifo_tier2_sb                  visa_fifo_tier2_sb_nc ; // low priority
visa_epfifo_tier2_ag                  visa_fifo_tier2_ag_nc ;
visa_agent_tier2                      visa_agent_tier2_ag_nc ;

// Added to fix CDC bug
logic                                 sbi_sbe_clkreq_sync ;

logic                                 fdfx_sbparity_def_sync ;

logic                                 sbe_prim_clkreq_async ;

//-----------------------------------------------------------------
// SB to EP Interface (Signals in side_clk domain)
//-----------------------------------------------------------------
hqm_sb_ep_msg_t                       sb_ep_msg ;
logic                                 ep_sb_msg_trdy ; // Tready handshake for sb_ep_msg

// Message Completion sent to EP
hqm_sb_ep_cmp_t                       sb_ep_cmsg_nc ;

logic                                 sb_ep_parity_err ;

//-----------------------------------------------------------------
// EP to SB Message Interface (Signals in side_clk domain)
//-----------------------------------------------------------------
hqm_ep_sb_msg_t                       ep_sb_msg ;
logic                                 sb_ep_msg_trdy ; // Tready handshake for ep_sb_msg

// Message Completion sent from EP
hqm_cds_sb_tgt_cmsg_t                 ep_sb_cmsg ; // Completion message back to the sb_tgt in the shim

logic                                 sif_gpsb_quiesce_req ;    // Tell Sideband to UR NPs and Drop Ps on its target
logic                                 sif_gpsb_quiesce_ack ;    // Tell RI_IOSF_SB that the SB TGT is URing/Dropping NP/P

logic [1:0][7:0]                      avisa_data_out_nc ;
logic [1:0]                           avisa_clk_out_nc ;
logic [1:0]                           sbe_visa_bypass_cr_out_nc ;
logic                                 sbe_visa_serial_rd_out_nc ;
logic                                 sbe_sbi_comp_exp_nc ;
logic                                 sbe_sbi_tmsg_pcparity_nc ;
logic                                 sbe_sbi_tmsg_npparity_nc ;
logic                                 ur_rx_sairs_valid_nc ;
logic [7:0]                           ur_rx_sai_nc ;
logic                                 ur_rx_rs_nc ;

logic                                   side_clkreq_sync;
logic [3:0]                             side_clkreq_async;
logic [3:0]                             side_clkack_async;

logic                                   side_clk_active_nc;
logic                                   side_boundary_locked_nc;

logic                                   side_ism_locked;
logic                                   side_ism_lock_b;

logic   [23:0]                          cdc_visa_nc;

logic                                   prim_rst_aon_b;
logic                                   side_rst_aon_b;

logic                                   side_rst_sync_b_nc;
logic                                   side_pwrgate_ready;
logic                                   side_gclock_enable_nc;

logic                                   pma_safemode_sync;
logic                                   fscan_clkungate_or_safemode;

logic                                   force_pwr_gate_pok_next;
logic                                   force_pwr_gate_pok_q;
logic                                   force_pwr_gate_pok_clr;
logic                                   force_pwr_gate_pok_sync;
logic                                   force_pwr_gate_pok_sync_q;
logic                                   force_pwr_gate_pok_sync_edge;

logic                                   allow_force_pwrgate_next;
logic                                   allow_force_pwrgate_q;

logic                                   side_pgcb_pok;
logic                                   side_pwrgate_force;
logic                                   side_pwrgate_force_in;
logic                                   side_pgcb_pwrgate_active;
logic                                   side_pwrgate_pmc_wake_sync;
logic                                   side_allow_force_pwrgate_sync;

logic                                   sb_ep_msg_irdy_q;
logic                                   sb_ep_msg_irdy_redge;
logic                                   prim_clkack_async_sbe_sync;

VISA_SW_CONTROL_t                       cfg_visa_sw_control_sb;             // side_clk

logic                                   cfg_visa_sw_control_write_sb;       // side_clk
VISA_SW_CONTROL_t                       cfg_visa_sw_control_wdata_sb;       // side_clk

logic                                   sw_control_wr_active;
logic                                   sw_control_wr_active_q;

//----------------------------------------------------------------------------

// Create the 32 bit SAI values and header ID

assign tx_ext_headers                 = {{(32-(SAI_WIDTH+1)-8){1'b0}},
                                         strap_hqm_tx_sai,
                                         TX_EXT_HEADER_IDS}                             ;

//--------------------------------------------------------------------------
// Internal strap (values from VLV)
//--------------------------------------------------------------------------
assign cgctrl_clkgaten                = iosfs_cgctl.CLKGATE_ENABLE                      ;
assign cgctrl_clkgatedef              = pma_safemode                                    ;
assign cgctrl_idlecnt                 = iosfs_cgctl.IDLE_COUNT                          ;

// asynchronous reset synchronization

generate
  if (ASYNCENDPT==1) begin: reset_async_p

      logic sbi_sbe_clkreq_async;

      assign agent_side_rst_b = side_gated_rst_prim_b;

      always_ff @(posedge side_clk or negedge side_gated_rst_prim_b) begin
       if (~side_gated_rst_prim_b) begin
        sbi_sbe_clkreq_async <= '0;
       end else begin
        sbi_sbe_clkreq_async <= sbi_sbe_clkreq;
       end
      end

      hqm_AW_ctech_doublesync_rstb i_sync2 (

               .clk   (side_clk)
              ,.rstb  (side_gated_rst_b)
              ,.d     (sbi_sbe_clkreq_async)
              ,.o     (sbi_sbe_clkreq_sync)
      );

    end else begin: reset_sync_p

      hqm_AW_unused_bits i_unused (.a(side_gated_rst_prim_b));

      assign agent_side_rst_b = side_gated_rst_b;

      assign sbi_sbe_clkreq_sync = sbi_sbe_clkreq;

    end
endgenerate

// Sync this locally

hqm_AW_ctech_doublesync_rstb i_fdfx_sbparity_def_sync (

       .clk   (side_clk)
      ,.rstb  (side_gated_rst_b)
      ,.d     (fdfx_sbparity_def)
      ,.o     (fdfx_sbparity_def_sync)
);

// Register this side_clk generated clkreq before it is synced in the CDC

always_ff @(posedge side_clk or negedge side_gated_rst_b) begin
 if (~side_gated_rst_b) begin
  sbe_prim_clkreq <= '0;
 end else begin
  sbe_prim_clkreq <= sbe_prim_clkreq_async;
 end
end

//--------------------------------------------------------------------------
// sbebase: Base Endpoint
//--------------------------------------------------------------------------

// PG insertion doc requires that the Masked version of the fabric ism be sent to the
// agent sb ism

assign gpsb_side_ism_fabric_pgmask = (side_ism_lock_b) ?  gpsb_side_ism_fabric : '0;

assign sbi_sbe_mmsg_pcparity   = {(^{sbi_sbe_mmsg_pceom[1], sbi_sbe_mmsg_pcpayload[1]})
                                 ,(^{sbi_sbe_mmsg_pceom[0], sbi_sbe_mmsg_pcpayload[0]})};
assign sbi_sbe_mmsg_npparity   = ^{sbi_sbe_mmsg_npeom, sbi_sbe_mmsg_nppayload};

hqm_sbebase #(

  .CLAIM_DELAY                        (0                                               ),
  .MAXPLDBIT                          (HQM_SBE_DATAWIDTH-1                             ),
  .NPQUEUEDEPTH                       (HQM_SBE_NPQUEUEDEPTH                            ),
  .PCQUEUEDEPTH                       (HQM_SBE_PCQUEUEDEPTH                            ),
  .CUP2PUT1CYC                        (0                                               ),
  .LATCHQUEUES                        (0                                               ),
  .MAXPCTRGT                          (0                                               ),
  .MAXNPTRGT                          (0                                               ),
  .MAXPCMSTR                          (1                                               ),
  .MAXNPMSTR                          (0                                               ),
  .ASYNCENDPT                         (ASYNCENDPT                                      ),
  .ASYNCIQDEPTH                       (SBE_ASYNCIQDEPTH                                ),
  .ASYNCEQDEPTH                       (SBE_ASYNCEQDEPTH                                ),
  .VALONLYMODEL                       (0                                               ), // Deprecated
  .RX_EXT_HEADER_SUPPORT              (RX_EXT_HEADER_SUPPORT                           ),
  .DUMMY_CLKBUF                       (0                                               ),
  .TX_EXT_HEADER_SUPPORT              (TX_EXT_HEADER_SUPPORT                           ),
  .NUM_TX_EXT_HEADERS                 (NUM_TX_EXT_HEADERS                              ),
  // jbdiethe 03062014 changed to 0. I want to rely on the SB bilt in claim logic to
  // order its UR correctly with other completions. It simplifies the rejection of
  // unsupported sideband request.  The reality is the way the MRd/Mwr SB logic works
  // all NP are handled one completion at a time so this should not change performance
  // in a meaningful way.
  //
  // From the integration guide here is the quote on this:
  // This feature effectively limits the agent to process only one NP
  // transaction at a time. For most agents this is not an issue, however,
  // there can be complex agents that need to queue many NP transactions. In
  // this case, the agent designer can disable the fence by setting the
  // DISABLE_COMPLETION_FENCING parameter to 1. Whenever this parameter is
  // set to a nonzero value, the agent *must* claim all NP transactions, even
  // those which eventually result in a UR completion, and correctly order
  // the completions. Relying on the unclaimed UR logic within the endpoint
  // in this scenario can lead to completion ordering violations.
  .DISABLE_COMPLETION_FENCING         (0                                               ),
  .RST_PRESYNC                        (1                                               ), // changed to '1' for cpm to eliminate double sync
  // Following are VISA insertion parameters, used for inserting VISA on the endpoint itself.
  // this is not the intended flow for end-users, but is present for VISA verify flow on endpoint collateral.
  // intended flow for end-users is to take provided signal list and integrate with overall signal list for
  // the design for inserting VISA at the top design level.
  .SBE_VISA_ID_PARAM                  (0                                               ),
  .NUMBER_OF_BITS_PER_LANE            (8                                               ),
  .NUMBER_OF_VISAMUX_MODULES          (1                                               ),
  .SKIP_ACTIVEREQ                     (1                                               ), // set to 1 to skip ACTIVE_REQ, per IOSF 1.0
  .PIPEISMS                           (SBE_PIPEISMS                                    ), // Set to 1 to pipeline fabric ism inputs
  .PIPEINPS                           (SBE_PIPEINPS                                    ), // Set to 1 to pipeline all put-cup-eom-payload inputs
  .USYNC_ENABLE                       (0                                               ), // Newer feature appeared in the 2013ww18 SB EP. Special
                                                                                          // synchronizer versus the standard two flop synchronizer
                                                                                          // used everywere else in CPM. Disabling.
  .AGENT_USYNC_DELAY                  (1                                               ),
  .SIDE_USYNC_DELAY                   (1                                               ),
  .UNIQUE_EXT_HEADERS                 (1                                               ),  // set to 1 to make the register agent modules use the new extended header
  .SAIWIDTH                           (SAI_WIDTH                                       ), // SAI field width - MAX=15
  .RSWIDTH                            (RS_WIDTH                                        ), // RS field width - MAX=3
  .EXPECTED_COMPLETIONS_COUNTER       (1                                               ), // Set to 1 if expected completion counters are needed
  .ISM_COMPLETION_FENCING             (1                                               ), // Set to 1 if ISM should stay ACTIVE w/ exp completions
  .SIDE_CLKREQ_HYST_CNT               (SBE_CLKREQ_HYST_CNT                             ), // sets the clock request modules hysteresis counter
  .SB_PARITY_REQUIRED                 (HQM_SBE_PARITY_REQUIRED                         ),
  .DO_SERR_MASTER                     (SBE_DO_SERR_MASTER                              ),
  .GLOBAL_EP                          (0                                               ),
  .GLOBAL_EP_IS_STRAP                 (1                                               )

  ) i_hqm_sbebase (

  // Clocks and Resets
  .side_clk                           (side_gated_clk                                  ),
  .side_rst_b                         (side_gated_rst_b                                ),
  .gated_side_clk                     (gated_side_clk_nc                               ),
  .agent_clk                          (side_clk                                        ),
  .agent_side_rst_b_sync              (agent_side_rst_b                                ),
  .sbi_sbe_clkreq                     (sbi_sbe_clkreq_sync                             ), // jbdiethe PGCB hookup guide says this should go
                                                                                          // directly to the CDC PG. Impression I get is this will work.
  // Unused Deterministic Synchronizer mode.
  .usyncselect                        ('0                                              ), // Deterministic Synchonizer feature. Not used. See USYNC_ENABLE.
  .agent_usync                        ('0                                              ), // Deterministic Synchonizer feature. Not used. See USYNC_ENABLE.
  .side_usync                         ('0                                              ), // Deterministic Synchonizer feature. Not used. See USYNC_ENABLE.

  // ISM
  .sbi_sbe_idle                       (sbi_sbe_idle                                    ), // When clock gating is added on prim_clk this should be inverted
                                                                                          // and drive gclock_req_sync input on the CDC controlling the
                                                                                          // prim_clk domain.
  .side_ism_fabric                    (gpsb_side_ism_fabric_pgmask                     ), // Needs to be masked by the side_lock signal for PG
  .side_ism_agent                     (gpsb_side_ism_agent                             ),
  .side_clkreq                        (side_clkreq_async[0]                            ),
  .side_clkack                        (side_clkack_async[0]                            ),
  .sbe_sbi_clkreq                     (sbe_prim_clkreq_async                           ),
  .sbe_sbi_idle                       (sbe_sbi_idle_nc                                 ),
  .sbe_sbi_clk_valid                  (sbe_sbi_clk_valid_nc                            ),
  .side_ism_lock_b                    (side_ism_lock_b                                 ),

  // SB External Interface

  .mpccup                             (gpsb_mpccup                                     ),
  .mnpcup                             (gpsb_mnpcup                                     ),
  .mpcput                             (gpsb_mpcput                                     ),
  .mnpput                             (gpsb_mnpput                                     ),
  .meom                               (gpsb_meom                                       ),
  .mpayload                           (gpsb_mpayload                                   ),
  .mparity                            (gpsb_mparity                                    ),

  .tpccup                             (gpsb_tpccup                                     ),
  .tnpcup                             (gpsb_tnpcup                                     ),
  .tpcput                             (gpsb_tpcput                                     ),
  .tnpput                             (gpsb_tnpput                                     ),
  .teom                               (gpsb_teom                                       ),
  .tpayload                           (gpsb_tpayload                                   ),
  .tparity                            (gpsb_tparity                                    ),

  // Parity Message interface

  .do_serr_srcid_strap                (strap_hqm_gpsb_srcid[7:0]                       ),
  .do_serr_hier_srcid_strap           (strap_hqm_gpsb_srcid[15:8]                      ),
  .do_serr_dstid_strap                (strap_hqm_do_serr_dstid[7:0]                    ),
  .do_serr_hier_dstid_strap           (strap_hqm_do_serr_dstid[15:8]                   ),
  .do_serr_tag_strap                  (strap_hqm_do_serr_tag                           ),
  .do_serr_sairs_valid                (strap_hqm_do_serr_sairs_valid                   ),
  .do_serr_sai                        (strap_hqm_do_serr_sai                           ),
  .do_serr_rs                         (strap_hqm_do_serr_rs                            ),
  .global_ep_strap                    (strap_hqm_16b_portids                           ),
  .ext_parity_err_detected            ('0                                              ),
  .fdfx_sbparity_def                  (fdfx_sbparity_def_sync                          ),

  .sbe_sbi_parity_err_out             (sb_ep_parity_err                                ),

  // SB Internal Interface
  .sbi_sbe_tmsg_pcfree                (sbi_sbe_tmsg_pcfree                             ),
  .sbi_sbe_tmsg_npfree                (sbi_sbe_tmsg_npfree                             ),
  .sbi_sbe_tmsg_npclaim               (sbi_sbe_tmsg_npclaim                            ),
  .sbe_sbi_tmsg_pcput                 (sbe_sbi_tmsg_pcput                              ),
  .sbe_sbi_tmsg_npput                 (sbe_sbi_tmsg_npput                              ),
  .sbe_sbi_tmsg_pcmsgip               (sbe_sbi_tmsg_pcmsgip                            ),
  .sbe_sbi_tmsg_npmsgip               (sbe_sbi_tmsg_npmsgip                            ),
  .sbe_sbi_tmsg_pceom                 (sbe_sbi_tmsg_pceom                              ),
  .sbe_sbi_tmsg_npeom                 (sbe_sbi_tmsg_npeom                              ),
  .sbe_sbi_tmsg_pcpayload             (sbe_sbi_tmsg_pcpayload                          ),
  .sbe_sbi_tmsg_nppayload             (sbe_sbi_tmsg_nppayload                          ),
  .sbe_sbi_tmsg_pccmpl                (sbe_sbi_tmsg_pccmpl                             ),
  .sbe_sbi_tmsg_pcvalid               (sbe_sbi_tmsg_pcvalid_nc                         ),
  .sbe_sbi_tmsg_npvalid               (sbe_sbi_tmsg_npvalid_nc                         ),
  .sbe_sbi_tmsg_pcparity              (sbe_sbi_tmsg_pcparity_nc                        ),
  .sbe_sbi_tmsg_npparity              (sbe_sbi_tmsg_npparity_nc                        ),

  .sbi_sbe_mmsg_pcirdy                (sbi_sbe_mmsg_pcirdy                             ),
  .sbi_sbe_mmsg_npirdy                (sbi_sbe_mmsg_npirdy                             ),
  .sbi_sbe_mmsg_pceom                 (sbi_sbe_mmsg_pceom                              ),
  .sbi_sbe_mmsg_npeom                 (sbi_sbe_mmsg_npeom                              ),
  .sbi_sbe_mmsg_pcpayload             (sbi_sbe_mmsg_pcpayload                          ),
  .sbi_sbe_mmsg_nppayload             (sbi_sbe_mmsg_nppayload                          ),
  .sbi_sbe_mmsg_pcparity              (sbi_sbe_mmsg_pcparity                           ),
  .sbi_sbe_mmsg_npparity              (sbi_sbe_mmsg_npparity                           ),
  .sbe_sbi_mmsg_pctrdy                (sbe_sbi_mmsg_pctrdy                             ),
  .sbe_sbi_mmsg_nptrdy                (sbe_sbi_mmsg_nptrdy                             ),
  .sbe_sbi_mmsg_pcmsgip               (sbe_sbi_mmsg_pcmsgip                            ),
  .sbe_sbi_mmsg_npmsgip               (sbe_sbi_mmsg_npmsgip_nc                         ),
  .sbe_sbi_mmsg_pcsel                 (sbe_sbi_mmsg_pcsel                              ),
  .sbe_sbi_mmsg_npsel                 (sbe_sbi_mmsg_npsel                              ),

  // SB Control Settings
  .cgctrl_idlecnt                     (cgctrl_idlecnt                                  ),
  .cgctrl_clkgaten                    (cgctrl_clkgaten                                 ),
  .cgctrl_clkgatedef                  (cgctrl_clkgatedef                               ),
  .tx_ext_headers                     (tx_ext_headers                                  ),

  // DFX
  .avisa_clk_out                      (avisa_clk_out_nc                                ),
  .avisa_data_out                     (avisa_data_out_nc                               ),
  .visa_port_tier1_sb                 (visa_port_tier1_sb_nc                           ),
  .visa_fifo_tier1_sb                 (visa_fifo_tier1_sb_nc                           ),
  .visa_fifo_tier1_ag                 (visa_fifo_tier1_ag_nc                           ),
  .visa_agent_tier1_ag                (visa_agent_tier1_ag_nc                          ),
  .visa_port_tier2_sb                 (visa_port_tier2_sb_nc                           ),
  .visa_fifo_tier2_sb                 (visa_fifo_tier2_sb_nc                           ),
  .visa_fifo_tier2_ag                 (visa_fifo_tier2_ag_nc                           ),
  .visa_agent_tier2_ag                (visa_agent_tier2_ag_nc                          ),
  .jta_clkgate_ovrd                   (gpsb_jta_clkgate_ovrd                           ),
  .jta_force_clkreq                   (gpsb_jta_force_clkreq                           ),
  .jta_force_idle                     (gpsb_jta_force_idle                             ),
  .jta_force_notidle                  (gpsb_jta_force_notidle                          ),
  .jta_force_creditreq                (gpsb_jta_force_creditreq                        ),
  .fscan_shiften                      (fscan_shiften                                   ),
  .fscan_mode                         (fscan_mode                                      ), // jbdiethe 10062014 not actually used in hqm_sbebase
                                                                                          // was tied to '0 which was fine however maybe a later rev
                                                                                          // will use this signal.
  .fscan_latchopen                    (fscan_latchopen                                 ),
  .fscan_latchclosed_b                (fscan_latchclosed_b                             ),
  .fscan_clkungate                    (fscan_clkungate                                 ),
  .fscan_clkungate_syn                (fscan_clkungate_syn                             ),
  .fscan_rstbypen                     (fscan_rstbypen                                  ),
  .fscan_byprst_b                     (fscan_byprst_b                                  ),
  .visa_all_disable                   ('0                                              ),
  .visa_customer_disable              ('0                                              ),
  .visa_ser_cfg_in                    ('0                                              ),

  // jbdiethe 03172015 These 6 signal were new with the 2014ww39 iosfsb drop. They seem
  // to make it so that the endpoint can actually ur bad sai messages. We handle that in
  // I nice to have would be to look at migrating to this built in facitlity for
  // generating the SAI ur's. IT looks like SAI and Root Space related. SB on root
  // space we dont use, however SAI is and this could be interesting.
  //
  // The integration guide has then all triggered off one so I will stick a '0 and
  // stub out the outputs I will then waive
  .ur_csairs_valid                    ('1                                              ),
  .ur_csai                            (strap_hqm_cmpl_sai                              ),
  .ur_crs                             ('0                                              ),
  .ur_rx_sairs_valid                  (ur_rx_sairs_valid_nc                            ),
  .ur_rx_sai                          (ur_rx_sai_nc                                    ),
  .ur_rx_rs                           (ur_rx_rs_nc                                     ),

  // jbdiethe 03172015 This 1 signal was new with the 2014ww39 iosfsb drop. I seems
  // to be a pending completion count indicator.  The descriptition in the integration
  // guid states:
  //  "Indicates when the IOSF interface has outstanding completions yet to be returned
  //   from the agent. The counter will max out at 31 outstanding completions before
  //   saturating and does not track based on message contents.
  //   Disabled when EXPECTED_COMPLETIONS_COUNTER is 1."
  .sbe_sbi_comp_exp                   (sbe_sbi_comp_exp_nc                             ),

  .sbe_visa_bypass_cr_out             (sbe_visa_bypass_cr_out_nc                       ),
  .sbe_visa_serial_rd_out             (sbe_visa_serial_rd_out_nc                       )

);

// This is on side_clk and needs to be synced to prim_clk

hqm_AW_ctech_doublesync_rstb i_sb_ep_parity_err_sync (
    .clk    (prim_freerun_clk),
    .rstb   (prim_gated_rst_b),
    .d      (sb_ep_parity_err),
    .o      (sb_ep_parity_err_sync)
);


hqm_msg_wrapper #(

  // SB SAI Extended Header Params
  .TX_EXT_HEADER_SUPPORT              (TX_EXT_HEADER_SUPPORT                           ),
  .NUM_TX_EXT_HEADERS                 (NUM_TX_EXT_HEADERS                              ),
  .RX_EXT_HEADER_SUPPORT              (RX_EXT_HEADER_SUPPORT                           ),
  .NUM_RX_EXT_HEADERS                 (NUM_RX_EXT_HEADERS                              ),
  .RX_EXT_HEADER_IDS                  (RX_EXT_HEADER_IDS                               ),

  // SB Target Params
  .MAXTRGTADDR                        (MAX_TGT_ADR                                     ), // Max address/data bits supported by the
  .MAXTRGTDATA                        (MAX_TGT_DAT                                     )  // master register access interface
  ) i_hqm_msg_wrapper (
  // Clock gating ISM Signals
  // Clock/Reset Signals
  .ipclk                              (side_clk                                        ),
  .ip_rst_b                           (agent_side_rst_b                                ),
  .sbi_sbe_clkreq                     (sbi_sbe_clkreq                                  ),
  .sbi_sbe_idle                       (sbi_sbe_idle                                    ),

  .strap_hqm_cmpl_sai                 (strap_hqm_cmpl_sai                              ),

  .strap_hqm_gpsb_srcid               (strap_hqm_gpsb_srcid                            ),
  .strap_hqm_16b_portids              (strap_hqm_16b_portids                           ),

  // Target interface outputs to the AGENT block
  .sbi_sbe_tmsg_pcfree                (sbi_sbe_tmsg_pcfree                             ), //
  .sbi_sbe_tmsg_npfree                (sbi_sbe_tmsg_npfree                             ), //
  .sbi_sbe_tmsg_npclaim               (sbi_sbe_tmsg_npclaim                            ), //

  // Target interface inputs to the AGENT block
  .sbe_sbi_tmsg_pcput                 (sbe_sbi_tmsg_pcput                              ), //
  .sbe_sbi_tmsg_npput                 (sbe_sbi_tmsg_npput                              ), //
  .sbe_sbi_tmsg_pcmsgip               (sbe_sbi_tmsg_pcmsgip                            ), // unused
  .sbe_sbi_tmsg_npmsgip               (sbe_sbi_tmsg_npmsgip                            ), //
  .sbe_sbi_tmsg_pceom                 (sbe_sbi_tmsg_pceom                              ), //
  .sbe_sbi_tmsg_npeom                 (sbe_sbi_tmsg_npeom                              ), //
  .sbe_sbi_tmsg_pcpayload             (sbe_sbi_tmsg_pcpayload                          ), //
  .sbe_sbi_tmsg_nppayload             (sbe_sbi_tmsg_nppayload                          ), //
  .sbe_sbi_tmsg_pccmpl                (sbe_sbi_tmsg_pccmpl                             ), //

  // Master interface outputs to the AGENT block
  .sbi_sbe_mmsg_pcirdy                (sbi_sbe_mmsg_pcirdy                             ), //
  .sbi_sbe_mmsg_npirdy                (sbi_sbe_mmsg_npirdy                             ), //
  .sbi_sbe_mmsg_pceom                 (sbi_sbe_mmsg_pceom                              ), //
  .sbi_sbe_mmsg_npeom                 (sbi_sbe_mmsg_npeom                              ), //
  .sbi_sbe_mmsg_pcpayload             (sbi_sbe_mmsg_pcpayload                          ), //
  .sbi_sbe_mmsg_nppayload             (sbi_sbe_mmsg_nppayload                          ), //

  // Master interface inputs to the AGENT block
  .sbe_sbi_mmsg_pctrdy                (sbe_sbi_mmsg_pctrdy                             ), //
  .sbe_sbi_mmsg_nptrdy                (sbe_sbi_mmsg_nptrdy                             ), //
  .sbe_sbi_mmsg_pcmsgip               (sbe_sbi_mmsg_pcmsgip                            ), // unused
  .sbe_sbi_mmsg_pcsel                 (sbe_sbi_mmsg_pcsel                              ), //
  .sbe_sbi_mmsg_npsel                 (sbe_sbi_mmsg_npsel                              ), //

  // EP Fuse and Straps
  .early_fuses                        (early_fuses                                     ),
  .sb_ep_fuses                        (sb_ep_fuses                                     ),
  .ip_ready                           (ip_ready                                        ),

  // Ingress Message Interface - Msg to the IP (via xlate)
  .tgt_ip_msg                         (tgt_ip_msg                                      ), //
  .ip_tgt_msg_trdy                    (ip_tgt_msg_trdy                                 ), // Handshake back for tgt_ip_msg

  // Egress Completion Interface  - Cmp from the IP (via xlate)
  .ip_tgt_cmsg                        (ip_tgt_cmsg                                     ), //
  .tgt_ip_cmsg_free                   (tgt_ip_cmsg_free_nc                             ), // Available free space for ip_tgt_cmsg

  // Ingress Master Completion Interface - Cmp to the IP (via xlate)
  .tgt_ip_cmsg                        (tgt_ip_cmsg                                     ),

  // Egress Master Message Interface - Msg from the IP (via xlate)
  .ip_mst_msg                         (ip_mst_msg                                      ),
  .mst_ip_msg_trdy                    (mst_ip_msg_trdy                                 ), // Handshake for ip_mst_msg

  // Reset Prep Handling Interface
  .sif_gpsb_quiesce_req               (sif_gpsb_quiesce_req                            ), // Tell Sideband to UR NPs and Drop Ps on its target
  .sif_gpsb_quiesce_ack               (sif_gpsb_quiesce_ack                            )  // Tell RI_IOSF_SB that the TGT is URing/Dropping NP/P

  );

hqm_sb_ep_xlate i_hqm_sb_ep_xlate (

  // Clock, Reset, and Instance Number Constant

  .ipclk                              (side_clk                                        ),
  .ip_rst_b                           (agent_side_rst_b                                ),

  .prim_gated_rst_b                   (prim_gated_rst_b                                ),

  // Legal SAI values for Sideband ResetPrep message

  .strap_hqm_resetprep_sai_0          (strap_hqm_resetprep_sai_0                       ),
  .strap_hqm_resetprep_sai_1          (strap_hqm_resetprep_sai_1                       ),

  // Legal SAI values for Sideband ForcePwrGatePOK message

  .strap_hqm_force_pok_sai_0          (strap_hqm_force_pok_sai_0                       ),
  .strap_hqm_force_pok_sai_1          (strap_hqm_force_pok_sai_1                       ),


  // Fuse interface

  .fuse_proc_disable                  (fuse_proc_disable                               ),

  // Register access controls

  .hqm_csr_rac                        (hqm_csr_rac                                     ),
  .hqm_csr_wac                        (hqm_csr_wac                                     ),

  // Message Info sent from SB to EP

  .sb_ep_msg                          (sb_ep_msg                                       ),
  .ep_sb_msg_trdy                     (ep_sb_msg_trdy                                  ), // Handshake for sb_ep_msg

  // Message Completion from EP to SB

  .ep_sb_cmsg                         (ep_sb_cmsg                                      ),

  // P and NP Messages from EP to SB

  .ep_sb_msg                          (ep_sb_msg                                       ),
  .sb_ep_msg_trdy                     (sb_ep_msg_trdy                                  ),

  // Completion sent to EP from SB

  .sb_ep_cmsg                         (sb_ep_cmsg_nc                                   ),

  // Ingress Message Interface - Msg to the IP (via xlate)

  .tgt_ip_msg                         (tgt_ip_msg                                      ), //
  .ip_tgt_msg_trdy                    (ip_tgt_msg_trdy                                 ), // Handshake back for tgt_ip_msg

  // Egress Completion Interface  - Cmp from the IP (via xlate)

  .ip_tgt_cmsg                        (ip_tgt_cmsg                                     ), //

  // Ingress Master Completion Interface - Cmp to the IP (via xlate)

  .tgt_ip_cmsg                        (tgt_ip_cmsg                                     ),

  // Egress Master Message Interface - Msg from the IP (via xlate)

  .ip_mst_msg                         (ip_mst_msg                                      ),
  .mst_ip_msg_trdy                    (mst_ip_msg_trdy                                 ),

  // Master interface

  .master_ctl_load                    (master_ctl_load                                 ),
  .master_ctl                         (master_ctl                                      ),

  .cfg_visa_sw_control                (cfg_visa_sw_control_sb                          ),

  .cfg_visa_sw_control_write          (cfg_visa_sw_control_write_sb                    ),
  .cfg_visa_sw_control_wdata          (cfg_visa_sw_control_wdata_sb                    )

);

//-----------------------------------------------------------------------------------------------------
// The CFG write from IOSF primary needs to be synced into the side_clk domain
// in order to write this side_clk domain register

hqm_AW_async_one_pulse_reg #(.WIDTH($bits(cfg_visa_sw_control_wdata))) i_sw_control_wr_sync (

     .src_clk      (prim_gated_clk)
    ,.src_rst_n    (prim_gated_rst_b)
    ,.dst_clk      (side_clk)
    ,.dst_rst_n    (side_gated_rst_b)

    ,.in_v         (cfg_visa_sw_control_write)
    ,.in_data      (cfg_visa_sw_control_wdata)
    ,.out_v        (cfg_visa_sw_control_write_sb)
    ,.out_data     (cfg_visa_sw_control_wdata_sb)

    ,.req_active   (sw_control_wr_active)
);

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  sw_control_wr_active_q <= '0;
 end else begin
  sw_control_wr_active_q <= sw_control_wr_active;
 end
end

// Complete the write on the falling edge of the req_active indication

assign cfg_visa_sw_control_write_done = sw_control_wr_active_q & ~sw_control_wr_active;

// These side_clk domain control bits need to be synced from the side_clk to the prim_clk

hqm_AW_sync_rst0 #(.WIDTH($bits(cfg_visa_sw_control_sb))) i_sw_control_syncs (

     .clk       (prim_freerun_clk)
    ,.rst_n     (side_gated_rst_prim_b)
    ,.data      (cfg_visa_sw_control_sb)
    ,.data_sync (cfg_visa_sw_control)
);

//------------------------------------------------------------------------------
// RI IOSF SideBand  Block
//------------------------------------------------------------------------------

hqm_ri_iosf_sb i_ri_iosf_sb (

     .side_gated_clk                    (side_gated_clk)
    ,.side_gated_rst_b                  (side_gated_rst_b)

    ,.side_clkreq_async                 (side_clkreq_async[1])

    ,.prim_freerun_clk                  (prim_freerun_clk)
    ,.prim_gated_clk                    (prim_nonflr_clk)
    ,.prim_gated_rst_b                  (prim_gated_rst_b)
    ,.side_gated_rst_prim_b             (side_gated_rst_prim_b)
    ,.hard_rst_np                       (hard_rst_np)

    ,.strap_hqm_err_sb_dstid            (strap_hqm_err_sb_dstid) // Sideband destination port ID for PCIe errors
    ,.strap_hqm_err_sb_sai              (strap_hqm_err_sb_sai)
    ,.strap_hqm_resetprep_ack_sai       (strap_hqm_resetprep_ack_sai)

    // SB Message sent to EP from SB

    ,.sb_ep_msg                         (sb_ep_msg)
    ,.ep_sb_msg_trdy                    (ep_sb_msg_trdy)

    // Relayed to CDS

    ,.sb_cds_msg                        (sb_cds_msg)

    // Message Response from EP to SB

    ,.ep_sb_cmsg                        (ep_sb_cmsg)

    // From ri_cds to ri_iosf_sb block for sideband unsupported requests

    ,.cds_sb_wrack                      (cds_sb_wrack)          // from CDS - ack an incoming wr request that has been sent
    ,.cds_sb_rdack                      (cds_sb_rdack)          // from CDS - ack an incoming rd request that has been sent
    ,.cds_sb_cmsg                       (cds_sb_cmsg)           // from CDS - completion message

    // Error Msg Interface to from RI

    ,.err_gen_msg                       (err_gen_msg)           // Generate error message to host
    ,.err_gen_msg_data                  (err_gen_msg_data)      // Error message data
    ,.err_gen_msg_func                  (err_gen_msg_func)      // HSD 5313841 - Error function should be included in error message
    ,.err_sb_msgack                     (err_sb_msgack)         // to tell CDS that an error message has been granted
                                                                //  (eventually to ERR fub)

    // SB Message info from EP

    ,.ep_sb_msg                         (ep_sb_msg)
    ,.sb_ep_msg_trdy                    (sb_ep_msg_trdy)

    // PGCB IOSF SB Interface

    ,.force_warm_reset                  (force_warm_reset)
    ,.force_ip_inaccessible             (force_ip_inaccessible)
    ,.force_pm_state_d3hot              (force_pm_state_d3hot)

    // ADR interface

    ,.pm_hqm_adr_assert                 (pm_hqm_adr_assert)
    ,.hqm_pm_adr_ack                    (hqm_pm_adr_ack)

    // Reset Prep Quiesce Logic Interface for PC and SB

    ,.sif_mstr_quiesce_req              (sif_mstr_quiesce_req)
    ,.sif_gpsb_quiesce_req              (sif_gpsb_quiesce_req)
    ,.quiesce_qualifier                 (quiesce_qualifier)

    ,.sif_mstr_quiesce_ack              (sif_mstr_quiesce_ack)
    ,.sif_gpsb_quiesce_ack              (sif_gpsb_quiesce_ack)  // Tell RI_IOSF_SB that the TGT is URing/Dropping NP/P

    ,.ri_iosf_sb_idle                   (ri_iosf_sb_idle)
    ,.adr_clkreq                        (adr_clkreq)
    ,.rpa_clkreq                        (rpa_clkreq)

    ,.strap_no_mgmt_acks                ( strap_no_mgmt_acks )
    ,.reset_prep_ack                    ( reset_prep_ack )
);

assign fuse_proc_disable   = sb_ep_fuses.proc_disable;
assign fuse_force_on       = sb_ep_fuses.force_on;

//-----------------------------------------------------------------------------------------------------

hqm_AW_reset_sync_scan i_prim_rst_aon_b (

         .clk               (pgcb_clk)
        ,.rst_n             (prim_rst_b)
        ,.fscan_rstbypen    (fscan_rstbypen)
        ,.fscan_byprst_b    (fscan_byprst_b)
        ,.rst_n_sync        (prim_rst_aon_b)
);

hqm_AW_reset_sync_scan i_side_rst_aon_b (

         .clk               (pgcb_clk)
        ,.rst_n             (side_rst_b)
        ,.fscan_rstbypen    (fscan_rstbypen)
        ,.fscan_byprst_b    (fscan_byprst_b)
        ,.rst_n_sync        (side_rst_aon_b)
);

//-----------------------------------------------------------------------------------------------------
// The force_pwr_gate_pok_q must set when either of the force_ip_inaccessible or force_warm_reset
// inputs are asserted.  It must remain set until it can be captured by the sync in the pgcb_clk domain,
// so we hold it once it sets and sync the pgcb_clk domain synced version back into the prim_clk domain
// and use that as the clear.

assign force_pwr_gate_pok_next = (force_ip_inaccessible | force_warm_reset | force_pwr_gate_pok_q) &
                                    ~force_pwr_gate_pok_clr;

assign allow_force_pwrgate_next = force_pm_state_d3hot & pm_fsm_d3tod0_ok;

always_ff @(posedge prim_freerun_clk or negedge prim_gated_rst_b) begin
  if (~prim_gated_rst_b) begin
     force_pwr_gate_pok_q  <= '0;
     allow_force_pwrgate_q <= '0;
  end else begin
     force_pwr_gate_pok_q  <= force_pwr_gate_pok_next;
     allow_force_pwrgate_q <= allow_force_pwrgate_next;
  end
end

hqm_AW_sync_rst0 #(.WIDTH(1)) i_force_pwr_gate_pok_sync (

  .clk                  ( pgcb_clk ),
  .rst_n                ( prim_rst_aon_b ),
  .data                 ( force_pwr_gate_pok_q ),
  .data_sync            ( force_pwr_gate_pok_sync )
);

hqm_AW_sync_rst0 #(.WIDTH(1)) i_force_pwr_gate_pok_clr (

  .clk                  ( prim_freerun_clk ),
  .rst_n                ( prim_gated_rst_b ),
  .data                 ( force_pwr_gate_pok_sync ),
  .data_sync            ( force_pwr_gate_pok_clr )
);

// Logic that takes the pwrgate_ready output and feeds it back into cdc

always_ff @(posedge pgcb_clk or negedge prim_rst_aon_b) begin
  if (~prim_rst_aon_b) begin
    force_pwr_gate_pok_sync_q <= '0;
  end else begin
    force_pwr_gate_pok_sync_q <= force_pwr_gate_pok_sync;
  end
end

assign force_pwr_gate_pok_sync_edge = force_pwr_gate_pok_sync & ~force_pwr_gate_pok_sync_q;

always_ff @(posedge pgcb_clk or negedge side_rst_aon_b) begin
  if (~side_rst_aon_b) begin
    side_pgcb_pok             <= '0;
    side_pwrgate_force        <= '0;
  end else begin
    side_pgcb_pok             <= ~side_pwrgate_ready;
    side_pwrgate_force        <= (force_pwr_gate_pok_sync_edge | side_pwrgate_force) & side_pgcb_pok;
  end
end

hqm_AW_sync_rst0 #(.WIDTH(1)) i_side_allow_force_pwrgate_sync (

  .clk                  (pgcb_clk),
  .rst_n                (side_rst_aon_b),
  .data                 (allow_force_pwrgate_q),
  .data_sync            (side_allow_force_pwrgate_sync)
);

assign side_pwrgate_force_in    = side_pwrgate_force & side_allow_force_pwrgate_sync;

assign side_pgcb_pwrgate_active = ~side_pgcb_pok | side_pwrgate_ready;

// Only allow the synchronized wake signals to be seen by the CDCs once the resets have been deasserted

hqm_AW_sync_rst0 #(.WIDTH(1)) i_side_pwrgate_pmc_wake_sync (

     .clk               (pgcb_clk)
    ,.rst_n             (side_rst_aon_b)
    ,.data              (side_pwrgate_pmc_wake)
    ,.data_sync         (side_pwrgate_pmc_wake_sync)
);

// Register this combinatorial side_clk signal before using it as an async clock
// request indicating we have a pending GPSB transaction coming from the SBEP
// that requires prim_clk in order to perform the access in the prim_clk domain.
// Maintain the request until it has been acked.

assign sb_ep_msg_irdy_redge = sb_ep_msg.irdy & ~sb_ep_msg_irdy_q ;

always_ff @(posedge side_gated_clk, negedge side_gated_rst_b) begin
 if(~side_gated_rst_b) begin
  sb_ep_msg_irdy_q       <= '0;
  prim_clkreq_async_sbe  <= '0;
 end else begin
  sb_ep_msg_irdy_q       <= sb_ep_msg.irdy;
  if (sb_ep_msg_irdy_redge) begin
   prim_clkreq_async_sbe <= 1'b1 ;
  end else if (prim_clkack_async_sbe_sync) begin
   prim_clkreq_async_sbe <= 1'b0 ;
  end
 end
end

hqm_AW_sync_rst0 #(.WIDTH(1)) i_prim_clkack_sync (

     .clk       (side_gated_clk)
    ,.rst_n     (side_gated_rst_b)
    ,.data      (prim_clkack_async_sbe)
    ,.data_sync (prim_clkack_async_sbe_sync)
);

//-----------------------------------------------------------------------------------------------------
// IOSF Sideband Clock CDC

hqm_AW_sync i_pma_safemode_sync (

         .clk           (side_clk)
        ,.data          (pma_safemode)
        ,.data_sync     (pma_safemode_sync)
);

assign fscan_clkungate_or_safemode = fscan_clkungate | pma_safemode_sync;

assign side_clkreq_sync = '0;

assign side_clkreq_async[3] = adr_clkreq;
assign side_clkreq_async[2] = sw_control_wr_active;

hqm_ClockDomainController #(

         .DEF_PWRON     (DEF_PWRON)     // Default to a powered-on state after reset
        ,.ITBITS        (16)            // Idle Timer Bits.  Max is 16
        ,.RST           (1)             // Number of resets.  Min is one.
        ,.AREQ          (4)             // Number of async gclock requests.  Min is one.
        ,.DRIVE_POK     (1)             // Determines whether this domain must drive POK
        ,.ISM_AGT_IS_NS (0)             // If 1, *_locked signals will be driven as the output of a flop
                                        // If 0, *_locked signals will assert combinatorially
        ,.RSTR_B4_FORCE (0)             // Determines if this CDC will require restore phase to complete
                                        // in order to transition from IP-Accessible to IP-Inaccessible PG
        ,.PRESCC        (0)             // If 1, The master_clock gate logic with have clkgenctrl muxes for scan to have control
                                        //       of the master_clock branch in order to be used preSCC
                                        //       NOTE: FLOP_CG_EN and DSYNC_CG_EN are a dont care when PRESCC=1
        ,.DSYNC_CG_EN   (0)             // If 1, the master_clock-gate enable will be synchronized to the short master_clock-tree version
                                        //       of master_clock to allow for STA convergence on fast clocks ( >120 MHz )
                                        //       Note: FLOP_CG_EN is a don't care when DSYNC_CG_EN=1
        ,.FLOP_CG_EN    (1)             // If 1, the clock-gate enable will be driven solely by the output of a flop
                                        // If 0, there will be a combi path into the cg enable to allow for faster ungating
        ,.CG_LOCK_ISM   (0)             // if set to 1, ism_locked signal is asserted whenever gclock_active is low

) i_side_cdc (

        // PGCB ClockDomain

         .pgcb_clk                      (pgcb_clk)                      //I: SIDE_CDC: PGCB clock; always running
        ,.pgcb_rst_b                    (side_rst_aon_b)                //I: SIDE_CDC: Reset with de-assert synchronized to pgcb_clk

        // Master Clock Domain

        ,.clock                         (side_clk)                      //I: SIDE_CDC: Master clock
        ,.prescc_clock                  (1'b0)                          //I: PRIM_CDC: Tie to 0 if PRESCC param is 0
        ,.reset_b                       (side_rst_b)                    //I: SIDE_CDC: Asynchronous ungated reset.  reset_b[0] must be deepest
                                                                        //   reset for the domain.
        ,.reset_sync_b                  (side_rst_sync_b_nc)            //O: SIDE_CDC: Version of reset_b with de-assertion synchronized to clock

        ,.clkreq                        (side_clkreq)                   //O: SIDE_CDC: Async (glitch free) clock request to disable
        ,.clkack                        (side_clkack)                   //I: SIDE_CDC: Async (glitch free) clock request acknowledge
        ,.pok_reset_b                   (side_rst_b)                    //I: SIDE_CDC: Asynchronous reset for POK
        ,.pok                           (side_pok)                      //O: SIDE_CDC: Power ok indication, synchronous

        ,.gclock_enable_final           (side_gclock_enable_nc)         //O: SIDE_CDC: Final enable signal to clock-gate

        // Gated Clock Domain

        ,.gclock                        (side_gated_clk)                //O: SIDE_CDC: Gated version of the clock
        ,.greset_b                      (side_gated_rst_b)              //O: SIDE_CDC: Gated version of reset_sync_b

        ,.gclock_req_sync               (side_clkreq_sync)              //I: SIDE_CDC: Synchronous gclock request.
        ,.gclock_req_async              (side_clkreq_async)             //I: SIDE_CDC: Async (glitch free) gclock requests
        ,.gclock_ack_async              (side_clkack_async)             //O: SIDE_CDC: Clock req ack for each gclock_req_async in this CDC's domain.
        ,.gclock_active                 (side_clk_active_nc)            //O: SIDE_CDC: Indication that gclock is running.
        ,.ism_fabric                    (gpsb_side_ism_fabric[2:0])     //I: SIDE_CDC: IOSF Fabric ISM.  Tie to zero for non-IOSF domains.
        ,.ism_agent                     (gpsb_side_ism_agent[2:0])      //I: SIDE_CDC: IOSF Agent ISM.  Tie to zero for non-IOSF domains.
        ,.ism_locked                    (side_ism_locked)               //O: SIDE_CDC: Indicates that the ISMs for this domain should be locked
        ,.boundary_locked               (side_boundary_locked_nc)       //O: SIDE_CDC: Indicates that all non IOSF accesses should be locked out

        // Configuration - Quasi-static

        ,.cfg_clkgate_disabled          (cfg_side_cdc_ctl.CLKGATE_DISABLED)         //I: SIDE_CDC: Don't allow idle-based clock gating
        ,.cfg_clkreq_ctl_disabled       (cfg_side_cdc_ctl.CLKREQ_CTL_DISABLED)      //I: SIDE_CDC: Don't allow de-assertion of clkreq when idle
        ,.cfg_clkgate_holdoff           (cfg_side_cdc_ctl.CLKGATE_HOLDOFF)          //I: SIDE_CDC: Min time from idle to clock gating; 2^value in clocks
        ,.cfg_pwrgate_holdoff           (cfg_side_cdc_ctl.PWRGATE_HOLDOFF)          //I: SIDE_CDC: Min time from clock gate to power gate ready; 2^value in clocks
        ,.cfg_clkreq_off_holdoff        (cfg_side_cdc_ctl.CLKREQ_OFF_HOLDOFF)       //I: SIDE_CDC: Min time from locking to !clkreq; 2^value in clocks
        ,.cfg_clkreq_syncoff_holdoff    (cfg_side_cdc_ctl.CLKREQ_SYNCOFF_HOLDOFF)   //I: SIDE_CDC: Min time from ck gate to !clkreq (powerGateDisabled)

        // CDC Aggregateion and Control (synchronous to pgcb_clk domain)

        ,.pwrgate_disabled              (1'd1)                          //I: SIDE_CDC: Don't allow idle-based clock gating; PGCB clock
        ,.pwrgate_force                 (side_pwrgate_force_in)         //I: SIDE_CDC: Force the controller to gate clocks and lock up
        ,.pwrgate_pmc_wake              (side_pwrgate_pmc_wake_sync)    //I: SIDE_CDC: PMC wake signal (after sync); PGCB clock domain
        ,.pwrgate_ready                 (side_pwrgate_ready)            //O: SIDE_CDC: Allow power gating in the PGCB clock domain.  Can de-assert
                                                                        //   even if neeven if never power gated if new wake event occurs.

        // PGCB Controls (synchronous to pgcb_clk domain)

        ,.pgcb_force_rst_b              (1'd1)                          //I: SIDE_CDC: Force for resets to assert
        ,.pgcb_pok                      (side_pgcb_pok)                 //I: SIDE_CDC: Power OK signal in the PGCB clock domain
        ,.pgcb_restore                  (1'd0)                          //I: SIDE_CDC: A restore is in pregress so  ISMs should unlock
        ,.pgcb_pwrgate_active           (side_pgcb_pwrgate_active)      //I: SIDE_CDC: Pwr gating in progress, so keep boundary locked

        // Test Controls

        ,.fscan_clkungate               (fscan_clkungate_or_safemode)   //I: SIDE_CDC: Test clock ungating control
        ,.fscan_byprst_b                ({3{fscan_byprst_b}})           //I: SIDE_CDC: Scan reset bypass value
        ,.fscan_rstbypen                ({3{fscan_rstbypen}})           //I: SIDE_CDC: Scan reset bypass enable
        ,.fscan_clkgenctrlen            ('0)                            //I: SIDE_CDC: Scan clock bypass enable (unused)
        ,.fscan_clkgenctrl              ('0)                            //I: SIDE_CDC: Scan clock bypass value  (unused)

        ,.fismdfx_force_clkreq          (cdc_side_jta_force_clkreq)     //I: SIDE_CDC: DFx force assert clkreq
        ,.fismdfx_clkgate_ovrd          (cdc_side_jta_clkgate_ovrd)     //I: SIDE_CDC: DFx force GATE gclock

        // CDC VISA Signals

        ,.cdc_visa                      (cdc_visa_nc)                   //O: SIDE_CDC: Set of internal signals for VISA visibility
);

assign side_ism_lock_b = ~side_ism_locked;

hqm_AW_unused_bits i_unused_side_cdc (

         .a     (|{side_rst_sync_b_nc
                  ,side_gclock_enable_nc
                  ,side_clk_active_nc
                  ,side_boundary_locked_nc
                  ,side_clkack_async[3]
                  ,side_clkack_async[2]
                  ,side_clkack_async[1]
                  ,cdc_visa_nc
                })
);

//------------------------------------------------------------------------------
// Assertions
//------------------------------------------------------------------------------
`ifndef INTEL_SVA_OFF
    //////////////////////////////////
    // Reset Prep Quiesce Assertions

    // The votes shuld stay high throughout send_rsprepack.
    RSPREP_VOTES_ONCE_HIGH_STAY_HIGH: assert property (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b)
        (~(i_ri_iosf_sb.send_rsprepack &
           i_ri_iosf_sb.quiesce_pc     & (~sif_mstr_quiesce_ack |
                                          ~i_ri_iosf_sb.sif_gpsb_quiesce_ack    )))) else
        $error ("Error: Once the votes to send resetprepack have gone high they must stay high.") ;

`endif

endmodule : hqm_iosfsb_core

