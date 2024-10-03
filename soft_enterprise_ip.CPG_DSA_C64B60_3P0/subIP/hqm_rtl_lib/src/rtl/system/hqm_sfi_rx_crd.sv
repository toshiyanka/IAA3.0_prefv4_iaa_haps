//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2022 Intel Corporation All Rights Reserved.
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

module hqm_sfi_rx_crd

     import hqm_sfi_pkg::*;
#(
     parameter int unsigned BRIDGE = 0,

`include "hqm_sfi_params.sv"

) (
     input  logic                                       clk_gated

    ,input  logic                                       rst_b

    //-------------------------------------------------------------------------------------------------

    ,input  logic                                       rx_sm_connected                     // RX SM state is CONNECTED
    ,input  logic                                       rx_sm_disconnected                  // RX SM state is DISCONNECTED

    ,input  logic [31:0]                                cfg_sif_vc_txmap

    ,input  logic                                       force_sfi_blocks

    ,input  logic                                       sfi_go_idle_ack

    ,output logic                                       rx_crd_idle

    ,output logic                                       rx_min_crds_sent

    //-------------------------------------------------------------------------------------------------
    // Receive Credit Return Interface

    ,input  logic                                       rx_hcrd_return_v                    // Queue hdr  credit return
    ,input  logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]         rx_hcrd_return_vc
    ,input  hqm_sfi_fc_id_t                             rx_hcrd_return_fc
    ,input  logic [HQM_SFI_RX_NHCRD-1:0]                rx_hcrd_return_val

    ,input  logic                                       rx_dcrd_return_v                    // Queue data credit return
    ,input  logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]        rx_dcrd_return_vc
    ,input  hqm_sfi_fc_id_t                             rx_dcrd_return_fc
    ,input  logic [HQM_SFI_RX_NDCRD-1:0]                rx_dcrd_return_val

    //-------------------------------------------------------------------------------------------------

    ,input  logic                                       sfi_rx_hdr_crd_rtn_block_q          // TX hdr  credit return backpressure
    ,input  logic                                       sfi_rx_data_crd_rtn_block_q         // TX data credit return backpressure

    ,output logic                                       sfi_rx_hdr_crd_rtn_valid_next       // RX hdr  credit return intf
    ,output logic [2:0]                                 sfi_rx_hdr_crd_rtn_vc_id_next
    ,output hqm_sfi_fc_id_t                             sfi_rx_hdr_crd_rtn_fc_id_next
    ,output logic [HQM_SFI_RX_NHCRD-1:0]                sfi_rx_hdr_crd_rtn_value_next

    ,output logic                                       sfi_rx_data_crd_rtn_valid_next      // RX data credit return intf
    ,output logic [2:0]                                 sfi_rx_data_crd_rtn_vc_id_next
    ,output hqm_sfi_fc_id_t                             sfi_rx_data_crd_rtn_fc_id_next
    ,output logic [HQM_SFI_RX_NDCRD-1:0]                sfi_rx_data_crd_rtn_value_next

    //-------------------------------------------------------------------------------------------------
    // Credit status

    ,input  logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]  rx_used_hcrds   // Consumed credits
    ,input  logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]  rx_used_dcrds

    ,output logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH  :0]  rx_init_hcrds   // Initial credits
    ,output logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH  :0]  rx_init_dcrds

    ,output logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH  :0]  rx_ret_hcrds    // Returnable credits
    ,output logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH  :0]  rx_ret_dcrds
);

//-----------------------------------------------------------------------------------------------------

//cindralla localparam int unsigned RX_HDR_CREDITS[ 1:0][3:0] = (BRIDGE == 1) ? HQM_SFI_BRIDGE_RX_HDR_CREDITS  : HQM_SFI_RX_HDR_CREDITS;
//cindralla localparam int unsigned RX_DATA_CREDITS[1:0][3:0] = (BRIDGE == 1) ? HQM_SFI_BRIDGE_RX_DATA_CREDITS : HQM_SFI_RX_DATA_CREDITS;
//cindralla 
//cindralla localparam int unsigned RX_HDR_CREDITS_INF[ 1:0][3:0] = (BRIDGE == 1) ? HQM_SFI_BRIDGE_RX_HDR_CREDITS_INF  : HQM_SFI_RX_HDR_CREDITS_INF;
//cindralla localparam int unsigned RX_DATA_CREDITS_INF[1:0][3:0] = (BRIDGE == 1) ? HQM_SFI_BRIDGE_RX_DATA_CREDITS_INF : HQM_SFI_RX_DATA_CREDITS_INF;

localparam int unsigned RX_HDR_CREDITS[ 3:0][3:0] = (BRIDGE == 1) ? HQM_SFI_BRIDGE_RX_HDR_CREDITS  : HQM_SFI_RX_HDR_CREDITS;
localparam int unsigned RX_DATA_CREDITS[3:0][3:0] = (BRIDGE == 1) ? HQM_SFI_BRIDGE_RX_DATA_CREDITS : HQM_SFI_RX_DATA_CREDITS;

localparam int unsigned RX_HDR_CREDITS_INF[ 3:0][3:0] = (BRIDGE == 1) ? HQM_SFI_BRIDGE_RX_HDR_CREDITS_INF  : HQM_SFI_RX_HDR_CREDITS_INF;
localparam int unsigned RX_DATA_CREDITS_INF[3:0][3:0] = (BRIDGE == 1) ? HQM_SFI_BRIDGE_RX_DATA_CREDITS_INF : HQM_SFI_RX_DATA_CREDITS_INF;

localparam int unsigned HQM_SFI_RX_HDR_CRD_RTN_MAX  = (1<<HQM_SFI_RX_NHCRD)-1;
localparam int unsigned HQM_SFI_RX_DATA_CRD_RTN_MAX = (1<<HQM_SFI_RX_NDCRD)-1;

//-----------------------------------------------------------------------------------------------------

logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]  ret_rx_hcrds_next;
logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]  ret_rx_hcrds_q;
logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][11:0]                              ret_rx_hcrds_scaled;
logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_RX_NHCRD            -1:0]  ret_rx_hcrds_inc;
logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_RX_NHCRD            -1:0]  ret_rx_hcrds_dec;
logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]  rx_sent_hcrds;
logic [HQM_SFI_RX_HDR_NUM_VCS -1:0][2:0]                                    rx_sent_min_hcrds;

logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]  ret_rx_dcrds_next;
logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]  ret_rx_dcrds_q;
logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][11:0]                              ret_rx_dcrds_scaled;
logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_RX_NDCRD            -1:0]  ret_rx_dcrds_inc;
logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_RX_NDCRD            -1:0]  ret_rx_dcrds_dec;
logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]  rx_sent_dcrds;
logic [HQM_SFI_RX_DATA_NUM_VCS-1:0][2:0]                                    rx_sent_min_dcrds;

logic                                       credit_init_reqd_next;
logic                                       credit_init_reqd_q;

logic [HQM_SFI_RX_HDR_NUM_FLOWS-1:0]        ret_rx_hcrd_arb_reqs;
logic                                       ret_rx_hcrd_arb_update;
logic                                       ret_rx_hcrd_arb_winner_v;
logic [HQM_SFI_RX_HDR_FLOWS_WIDTH-1:0]      ret_rx_hcrd_arb_winner;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]         ret_rx_hcrd_arb_winner_vc;
hqm_sfi_fc_id_t                             ret_rx_hcrd_arb_winner_fc;

logic [HQM_SFI_RX_DATA_NUM_FLOWS-1:0]       ret_rx_dcrd_arb_reqs;
logic                                       ret_rx_dcrd_arb_update;
logic                                       ret_rx_dcrd_arb_winner_v;
logic [HQM_SFI_RX_DATA_FLOWS_WIDTH-1:0]     ret_rx_dcrd_arb_winner;
logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]        ret_rx_dcrd_arb_winner_vc;
hqm_sfi_fc_id_t                             ret_rx_dcrd_arb_winner_fc;

logic                                       rx_min_crds_sent_next;
logic                                       rx_min_crds_sent_q;

//-----------------------------------------------------------------------------------------------------
// Manage RX return credit count for init/inc/dec

always_comb begin

 ret_rx_hcrds_next     = ret_rx_hcrds_q;
 ret_rx_dcrds_next     = ret_rx_dcrds_q;
 credit_init_reqd_next = credit_init_reqd_q;

 // Convert credit returns to increments

 ret_rx_hcrds_inc      = '0;
 ret_rx_dcrds_inc      = '0;

 if (rx_hcrd_return_v) begin
  ret_rx_hcrds_inc[rx_hcrd_return_vc][rx_hcrd_return_fc] = rx_hcrd_return_val;
 end

 if (rx_dcrd_return_v) begin
  ret_rx_dcrds_inc[rx_dcrd_return_vc][rx_dcrd_return_fc] = rx_dcrd_return_val;
 end

 // Only send credit returns when in the CONNECTED state

 if (rx_sm_connected) begin // CONNECTED

  if (credit_init_reqd_q) begin // Init required

   // Credit initialization loads the credit return counters with the parameter values
   // Infinite credits are denoted by the corresponding *_INF parameter value for that VC/FC being
   // set to 1.  To advertise infinite credits to the TX side, need a credit return with the value
   // set to 0.  Setting the actual credit parameter value to 1 for the infinite credit case so
   // the reset value of the counter will allow the arbiter can to select it during credit init,
   // but when that VC/FC wins the arbitration, the actual value sent out will be forced to 0.

   for (int vc=0; vc<HQM_SFI_RX_HDR_NUM_VCS; vc=vc+1) begin // vc
    for (int fc=0; fc<=2; fc=fc+1) begin // fc
     ret_rx_hcrds_next[vc][fc] = RX_HDR_CREDITS[ vc][fc][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0];
     ret_rx_dcrds_next[vc][fc] = RX_DATA_CREDITS[vc][fc][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0];
    end // fc
   end // vc

   // Turn off the init required flag

   credit_init_reqd_next = '0;

  end // Init required

  else begin // Init done

   // Normal running is to just manage the increment and decrement of the credit return counters

   for (int vc=0; vc<HQM_SFI_RX_HDR_NUM_VCS; vc=vc+1) begin // vc
    for (int fc=0; fc<=2; fc=fc+1) begin // fc

     if (|{ret_rx_hcrds_inc[vc][fc], ret_rx_hcrds_dec[vc][fc]}) begin

      ret_rx_hcrds_next[vc][fc] = ret_rx_hcrds_q[vc][fc] +
      {{(HQM_SFI_RX_MAX_CRD_CNT_WIDTH - HQM_SFI_RX_NHCRD){1'b0}}, ret_rx_hcrds_inc[vc][fc]} -
      {{(HQM_SFI_RX_MAX_CRD_CNT_WIDTH - HQM_SFI_RX_NHCRD){1'b0}}, ret_rx_hcrds_dec[vc][fc]};

     end

     if (|{ret_rx_dcrds_inc[vc][fc], ret_rx_dcrds_dec[vc][fc]}) begin

      ret_rx_dcrds_next[vc][fc] = ret_rx_dcrds_q[vc][fc] +
      {{(HQM_SFI_RX_MAX_CRD_CNT_WIDTH - HQM_SFI_RX_NDCRD){1'b0}}, ret_rx_dcrds_inc[vc][fc]} -
      {{(HQM_SFI_RX_MAX_CRD_CNT_WIDTH - HQM_SFI_RX_NDCRD){1'b0}}, ret_rx_dcrds_dec[vc][fc]};

     end

    end // fc
   end // vc

  end // Init done

 end // CONNECTED

 else if (rx_sm_disconnected) begin // DISCONNECTED

  // If in the DISCONNECTED state, a credit initialization will be required

  credit_init_reqd_next = '1;

 end // DISCONNECTED

end

//-----------------------------------------------------------------------------------------------------

always_ff @(posedge clk_gated or negedge rst_b) begin
 if (~rst_b) begin
  for (int vc=0; vc<HQM_SFI_RX_HDR_NUM_VCS; vc=vc+1) begin
   for (int fc=0; fc<=2; fc=fc+1) begin
    ret_rx_hcrds_q[vc][fc] <= '0;
    ret_rx_dcrds_q[vc][fc] <= '0;
   end
  end
  credit_init_reqd_q <= '1;
 end else begin
  ret_rx_hcrds_q     <= ret_rx_hcrds_next;
  ret_rx_dcrds_q     <= ret_rx_dcrds_next;
  credit_init_reqd_q <= credit_init_reqd_next;
 end
end

//-----------------------------------------------------------------------------------------------------

generate

 for (genvar gvc=0; gvc<HQM_SFI_RX_HDR_NUM_VCS; gvc=gvc+1) begin: g_hvc
  for (genvar gfc=0; gfc<3; gfc=gfc+1) begin: g_hfc

   hqm_AW_width_scale #(.A_WIDTH(HQM_SFI_RX_MAX_CRD_CNT_WIDTH), .Z_WIDTH(12)) i_ret_rx_hcrds_scaled (
       .a       (ret_rx_hcrds_q[gvc][gfc])
      ,.z       (ret_rx_hcrds_scaled[gvc][gfc])
   );

  end
 end

 for (genvar gvc=0; gvc<HQM_SFI_RX_DATA_NUM_VCS; gvc=gvc+1) begin: g_dvc
  for (genvar gfc=0; gfc<3; gfc=gfc+1) begin: g_dfc

   hqm_AW_width_scale #(.A_WIDTH(HQM_SFI_RX_MAX_CRD_CNT_WIDTH), .Z_WIDTH(12)) i_ret_rx_dcrds_scaled (
       .a       (ret_rx_dcrds_q[gvc][gfc])
      ,.z       (ret_rx_dcrds_scaled[gvc][gfc])
   );

  end
 end

endgenerate

//-----------------------------------------------------------------------------------------------------
// Idle indication

always_comb begin

 rx_crd_idle = ~(|{credit_init_reqd_q, ret_rx_hcrds_q, ret_rx_dcrds_q});

end

//-----------------------------------------------------------------------------------------------------
// Manage RX credit returns

// Credit return arbiter inputs are indication that any return credits exist for a vc/fc.
// Need to pick one from the available non-zero vc/fc return credits to return.

always_comb begin

 ret_rx_hcrd_arb_reqs      = '0;
 ret_rx_hcrd_arb_winner_vc = '0;
 ret_rx_hcrd_arb_winner_fc = hqm_sfi_fc_id_t'(2'd0);

 ret_rx_dcrd_arb_reqs      = '0;
 ret_rx_dcrd_arb_winner_vc = '0;
 ret_rx_dcrd_arb_winner_fc = hqm_sfi_fc_id_t'(2'd0);

 for (int vc=0; vc<HQM_SFI_RX_HDR_NUM_VCS; vc=vc+1) begin // vc
  for (int fc=0; fc<3; fc=fc+1) begin // fc

   // OR-reduction of any hdr return credits for vc/fc

   ret_rx_hcrd_arb_reqs[(vc*3)+fc] = (|ret_rx_hcrds_q[vc][fc]);

   // Decode hdr arb winner into corresponding vc/fc

   if ({{(32-HQM_SFI_RX_HDR_FLOWS_WIDTH){1'b0}}, ret_rx_hcrd_arb_winner} == ((vc*32'd3)+fc)) begin
    ret_rx_hcrd_arb_winner_vc = vc[HQM_SFI_RX_HDR_VC_WIDTH-1:0];
    ret_rx_hcrd_arb_winner_fc = hqm_sfi_fc_id_t'(fc[1:0]);
   end

  end // fc
 end // vc

 for (int vc=0; vc<HQM_SFI_RX_DATA_NUM_VCS; vc=vc+1) begin // vc
  for (int fc=0; fc<3; fc=fc+1) begin // fc

   // OR-reduction of any data return credits for vc/fc

   ret_rx_dcrd_arb_reqs[(vc*3)+fc] = (|ret_rx_dcrds_q[vc][fc]);

   // Decode data arb winner into corresponding vc/fc

   if ({{(32-HQM_SFI_RX_DATA_FLOWS_WIDTH){1'b0}}, ret_rx_dcrd_arb_winner} == ((vc*32'd3)+fc)) begin
    ret_rx_dcrd_arb_winner_vc = vc[HQM_SFI_RX_DATA_VC_WIDTH-1:0];
    ret_rx_dcrd_arb_winner_fc = hqm_sfi_fc_id_t'(fc[1:0]);

   end
  end // fc
 end // vc

end

//-----------------------------------------------------------------------------------------------------

hqm_AW_rr_arbiter #(.NUM_REQS(HQM_SFI_RX_HDR_NUM_FLOWS)) u_ret_rx_hcrd_arb (

     .clk           (clk_gated)
    ,.rst_n         (rst_b)

    ,.mode          (2'd2)
    ,.update        (ret_rx_hcrd_arb_update)

    ,.reqs          (ret_rx_hcrd_arb_reqs)

    ,.winner_v      (ret_rx_hcrd_arb_winner_v)
    ,.winner        (ret_rx_hcrd_arb_winner)
);

hqm_AW_rr_arbiter #(.NUM_REQS(HQM_SFI_RX_DATA_NUM_FLOWS)) u_ret_rx_dcrd_arb (

     .clk           (clk_gated)
    ,.rst_n         (rst_b)

    ,.mode          (2'd2)
    ,.update        (ret_rx_dcrd_arb_update)

    ,.reqs          (ret_rx_dcrd_arb_reqs)

    ,.winner_v      (ret_rx_dcrd_arb_winner_v)
    ,.winner        (ret_rx_dcrd_arb_winner)
);

//-----------------------------------------------------------------------------------------------------

always_comb begin

 sfi_rx_hdr_crd_rtn_valid_next  = '0;
 sfi_rx_hdr_crd_rtn_vc_id_next  = '0;
 sfi_rx_hdr_crd_rtn_fc_id_next  = hqm_sfi_fc_id_t'('0);
 sfi_rx_hdr_crd_rtn_value_next  = '0;

 sfi_rx_data_crd_rtn_valid_next = '0;
 sfi_rx_data_crd_rtn_vc_id_next = '0;
 sfi_rx_data_crd_rtn_fc_id_next = hqm_sfi_fc_id_t'('0);
 sfi_rx_data_crd_rtn_value_next = '0;

 ret_rx_hcrds_dec               = '0;
 ret_rx_dcrds_dec               = '0;

 ret_rx_hcrd_arb_update         = '0;
 ret_rx_dcrd_arb_update         = '0;

 // Return credits for return hdr credit arb winner up to max at a time unless backpressured

 // Choosing to block credit returns on a quiesce request signaled by force_sfi_blocks as well
 // to prevent abherrent case where the block was asserted and then gets deasserted just as
 // the clock is being gated.
 // Don't return any more credits if sfi_go_idle_ack is asserted.  This handles the case where
 // cfg_sfi_idle_min_crds is set and we clock gate once minimum credits have been returned but
 // we still have addition credits that could be returned. Don't want the clock to gate while
 // the credit return valid is asserted on the interface...

 if (ret_rx_hcrd_arb_winner_v &
     (~(sfi_rx_hdr_crd_rtn_block_q | force_sfi_blocks | sfi_go_idle_ack))) begin // rx_hcrd return

  sfi_rx_hdr_crd_rtn_valid_next = '1;
  sfi_rx_hdr_crd_rtn_vc_id_next = {2'd0, cfg_sif_vc_txmap[{ret_rx_hcrd_arb_winner_vc, 2'd0} +: 3]};
  sfi_rx_hdr_crd_rtn_fc_id_next = ret_rx_hcrd_arb_winner_fc;

  if (ret_rx_hcrds_q[ret_rx_hcrd_arb_winner_vc][ret_rx_hcrd_arb_winner_fc] <=
      HQM_SFI_RX_HDR_CRD_RTN_MAX[HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]) begin // <= max

   // If <= max hdr credits to return, return them all, decrement the return credit counter for that vc/fc
   // and update the arbiter index. Force value to 0 if the infinite credits parameter is set.

   sfi_rx_hdr_crd_rtn_value_next =
   ret_rx_hcrds_q[ret_rx_hcrd_arb_winner_vc][ret_rx_hcrd_arb_winner_fc][HQM_SFI_RX_NHCRD-1:0] &
   {HQM_SFI_RX_NHCRD{(~RX_HDR_CREDITS_INF[ret_rx_hcrd_arb_winner_vc][ret_rx_hcrd_arb_winner_fc][0])}};

   ret_rx_hcrds_dec[ret_rx_hcrd_arb_winner_vc][ret_rx_hcrd_arb_winner_fc] =
   ret_rx_hcrds_q[  ret_rx_hcrd_arb_winner_vc][ret_rx_hcrd_arb_winner_fc][HQM_SFI_RX_NHCRD-1:0];

   ret_rx_hcrd_arb_update = '1;

  end // <= max

  else begin // > max

   // If > max hdr credits, return max and decrement the return credit counter for that vc/fc by max.

   sfi_rx_hdr_crd_rtn_value_next = HQM_SFI_RX_HDR_CRD_RTN_MAX[HQM_SFI_RX_NHCRD-1:0];

   ret_rx_hcrds_dec[ret_rx_hcrd_arb_winner_vc][ret_rx_hcrd_arb_winner_fc] =
   HQM_SFI_RX_HDR_CRD_RTN_MAX[HQM_SFI_RX_NHCRD-1:0];

  end // > max

 end // rx_hcrd return

 // Return credits for return data credit arb winner up to max at a time unless backpressured
 // Choosing to block credit returns on a quiesce request signaled by force_sfi_blocks as well
 // to prevent abherrent case where the block was asserted and then gets deasserted just as
 // the clock is being gated.
 // Don't return any more credits if sfi_go_idle_ack is asserted.  This handles the case where
 // cfg_sfi_idle_min_crds is set and we clock gate once minimum credits have been returned but
 // we still have addition credits that could be returned. Don't want the clock to gate while
 // the credit return valid is asserted on the interface...

 if (ret_rx_dcrd_arb_winner_v &
     (~(sfi_rx_data_crd_rtn_block_q | force_sfi_blocks | sfi_go_idle_ack))) begin // rx_dcrd return

  sfi_rx_data_crd_rtn_valid_next = '1;
  sfi_rx_data_crd_rtn_vc_id_next = {2'd0, cfg_sif_vc_txmap[{ret_rx_dcrd_arb_winner_vc, 2'd0} +: 3]};
  sfi_rx_data_crd_rtn_fc_id_next = ret_rx_dcrd_arb_winner_fc;

  if (ret_rx_dcrds_q[ret_rx_dcrd_arb_winner_vc][ret_rx_dcrd_arb_winner_fc] <=
      HQM_SFI_RX_DATA_CRD_RTN_MAX[HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]) begin // <= max

   // If <= 4 data credits to return, return them all, decrement the return credit counter for that vc/fc
   // and update the arbiter index. Force value to 0 if the infinite credits parameter is set.

   sfi_rx_data_crd_rtn_value_next =
   ret_rx_dcrds_q[ret_rx_dcrd_arb_winner_vc][ret_rx_dcrd_arb_winner_fc][HQM_SFI_RX_NDCRD-1:0] &
   {HQM_SFI_RX_NDCRD{(~RX_DATA_CREDITS_INF[ret_rx_dcrd_arb_winner_vc][ret_rx_dcrd_arb_winner_fc][0])}};

   ret_rx_dcrds_dec[ret_rx_dcrd_arb_winner_vc][ret_rx_dcrd_arb_winner_fc] =
   ret_rx_dcrds_q[  ret_rx_dcrd_arb_winner_vc][ret_rx_dcrd_arb_winner_fc][HQM_SFI_RX_NDCRD-1:0];

   ret_rx_dcrd_arb_update = '1;

  end // <= max

  else begin // > max

   // If > max data credits, return max and decrement the return credit counter for that vc/fc by max.

   sfi_rx_data_crd_rtn_value_next = HQM_SFI_RX_DATA_CRD_RTN_MAX[HQM_SFI_RX_NDCRD-1:0];

   ret_rx_dcrds_dec[ret_rx_dcrd_arb_winner_vc][ret_rx_dcrd_arb_winner_fc] =
   HQM_SFI_RX_DATA_CRD_RTN_MAX[HQM_SFI_RX_NDCRD-1:0];

  end // > max

 end // rx_dcrd return

end

//-----------------------------------------------------------------------------------------------------
// Credit status

always_comb begin

 for (int vc=0; vc<HQM_SFI_RX_HDR_NUM_VCS; vc=vc+1) begin
  for (int fc=0; fc<3; fc=fc+1) begin

   rx_init_hcrds[vc][fc] = {RX_HDR_CREDITS_INF[vc][fc][0]
                         ,((RX_HDR_CREDITS_INF[vc][fc][0]) ? {HQM_SFI_RX_MAX_CRD_CNT_WIDTH{1'b0}} :
                            RX_HDR_CREDITS[    vc][fc][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0])
                           };

   rx_ret_hcrds[ vc][fc] = {RX_HDR_CREDITS_INF[vc][fc][0], ret_rx_hcrds_scaled[vc][fc]};

   rx_sent_hcrds[vc][fc] = (RX_HDR_CREDITS_INF[vc][fc][0]) ? {HQM_SFI_RX_MAX_CRD_CNT_WIDTH{1'b1}} :
                           (RX_HDR_CREDITS[    vc][fc][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0] -
                            rx_used_hcrds[     vc][fc][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0] -
                            rx_ret_hcrds[      vc][fc][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]);

   rx_sent_min_hcrds[vc][fc] = (~HQM_SFI_RX_VC_FC_USED[vc][fc][0]) | (|rx_sent_hcrds[vc][fc]);

  end
 end

 for (int vc=0; vc<HQM_SFI_RX_DATA_NUM_VCS; vc=vc+1) begin
  for (int fc=0; fc<3; fc=fc+1) begin

   rx_init_dcrds[vc][fc] = {RX_DATA_CREDITS_INF[vc][fc][0]
                         ,((RX_DATA_CREDITS_INF[vc][fc][0]) ? {HQM_SFI_RX_MAX_CRD_CNT_WIDTH{1'b0}} :
                            RX_DATA_CREDITS[    vc][fc][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0])
                           };

   rx_ret_dcrds[ vc][fc] = {RX_DATA_CREDITS_INF[vc][fc][0], ret_rx_dcrds_scaled[vc][fc]};

   rx_sent_dcrds[vc][fc] = (RX_DATA_CREDITS_INF[vc][fc][0]) ? {HQM_SFI_RX_MAX_CRD_CNT_WIDTH{1'b1}} :
                           (RX_DATA_CREDITS[    vc][fc][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0] -
                            rx_used_dcrds[      vc][fc][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0] -
                            rx_ret_dcrds[       vc][fc][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]);

   rx_sent_min_dcrds[vc][fc] = (~HQM_SFI_RX_VC_FC_USED[vc][fc][0]) |
      (rx_sent_dcrds[vc][fc] >=  HQM_SFI_RX_MIN_DCRDS[ vc][fc][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]);

  end
 end

 rx_min_crds_sent_next = (~credit_init_reqd_q) & (&{rx_sent_min_hcrds, rx_sent_min_dcrds});

 rx_min_crds_sent      = rx_min_crds_sent_q;

end

always_ff @(posedge clk_gated or negedge rst_b) begin
 if (~rst_b) begin
  rx_min_crds_sent_q <= '0;
 end else begin
  rx_min_crds_sent_q <= rx_min_crds_sent_next;
 end
end

//-----------------------------------------------------------------------------------------------------

endmodule // hqm_sfi_rx_crd

