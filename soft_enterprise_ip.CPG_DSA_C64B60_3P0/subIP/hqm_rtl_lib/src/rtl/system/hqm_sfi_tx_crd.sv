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

module hqm_sfi_tx_crd

     import hqm_sfi_pkg::*;
#(

`include "hqm_sfi_params.sv"

) (
     input  logic                                       clk_gated

    ,input  logic                                       rst_b

    //-------------------------------------------------------------------------------------------------

    ,input  logic                                       tx_sm_disconnected          // TX SM state is DISCONNECTED

    ,input  logic [31:0]                                cfg_sif_vc_rxmap

    //-------------------------------------------------------------------------------------------------
    // Transmit Credit Consume Interface

    ,input  logic                                       tx_hcrd_consume_v           // TX hdr  credit consume
    ,input  logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]         tx_hcrd_consume_vc
    ,input  hqm_sfi_fc_id_t                             tx_hcrd_consume_fc
    ,input  logic                                       tx_hcrd_consume_val

    ,input  logic                                       tx_dcrd_consume_v           // TX data credit consume
    ,input  logic [HQM_SFI_TX_DATA_VC_WIDTH-1:0]        tx_dcrd_consume_vc
    ,input  hqm_sfi_fc_id_t                             tx_dcrd_consume_fc
    ,input  logic [2:0]                                 tx_dcrd_consume_val

    ,output logic                                       tx_has_consumed_crds

    ,output logic                                       tx_min_crds_rcvd

    //-------------------------------------------------------------------------------------------------
    // Fabric TX credit return interface

    ,input  logic                                       sfi_tx_rx_empty_q

    ,input  logic                                       sfi_tx_hdr_crd_rtn_valid_q  // TX hdr  credit return
    ,input  logic [4:0]                                 sfi_tx_hdr_crd_rtn_vc_id_q
    ,input  hqm_sfi_fc_id_t                             sfi_tx_hdr_crd_rtn_fc_id_q
    ,input  logic [HQM_SFI_TX_NHCRD-1:0]                sfi_tx_hdr_crd_rtn_value_q

    ,input  logic                                       sfi_tx_data_crd_rtn_valid_q // TX data credit return
    ,input  logic [4:0]                                 sfi_tx_data_crd_rtn_vc_id_q
    ,input  hqm_sfi_fc_id_t                             sfi_tx_data_crd_rtn_fc_id_q
    ,input  logic [HQM_SFI_TX_NDCRD-1:0]                sfi_tx_data_crd_rtn_value_q

    //-------------------------------------------------------------------------------------------------
    // Errors

    ,output logic                                       tx_hcrds_used_xflow
    ,output logic [7:0]                                 tx_hcrds_used_xflow_synd
    ,output logic                                       tx_dcrds_used_xflow
    ,output logic [7:0]                                 tx_dcrds_used_xflow_synd

    //-------------------------------------------------------------------------------------------------
    // Transmit Credits Available Interface

    ,output logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_hcrds_avail  // Available TX hdr  credits
    ,output logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_dcrds_avail  // Available TX data credits

    //-------------------------------------------------------------------------------------------------
    // Credit status

    ,output logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][12:0]  tx_init_hcrds   // Initial credits
    ,output logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][12:0]  tx_init_dcrds

    ,output logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][12:0]  tx_rem_hcrds    // Remaining credits
    ,output logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][12:0]  tx_rem_dcrds

    ,output logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][12:0]  tx_used_hcrds   // Consumed credits
    ,output logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][12:0]  tx_used_dcrds
);

//-----------------------------------------------------------------------------------------------------

logic                                                                       tx_rx_empty_rose_next;
logic                                                                       tx_rx_empty_rose_q;

logic                                                                       sfi_tx_hdr_crd_val_vc;
logic                                                                       sfi_tx_data_crd_val_vc;

logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]                                         sfi_tx_hdr_crd_rtn_vc;
logic [HQM_SFI_TX_DATA_VC_WIDTH-1:0]                                        sfi_tx_data_crd_rtn_vc;

logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_hcrds_next;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_hcrds_q;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][11:0]                              tx_hcrds_scaled;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH  :0]  tx_hcrds_sum;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_NHCRD            -1:0]  tx_hcrds_inc;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0]                                    tx_hcrds_dec;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0]                                    tx_hcrds_inf_next;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0]                                    tx_hcrds_inf_q;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0]                                    tx_hcrds_carry_q;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH  :0]  tx_hcrds_consumed_next;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_hcrds_consumed_q;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][11:0]                              tx_hcrds_consumed_scaled;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_hcrds_max_q;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][11:0]                              tx_hcrds_max_scaled;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0]                                    tx_rcvd_min_hcrds;

logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_dcrds_next;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_dcrds_q;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][11:0]                              tx_dcrds_scaled;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH  :0]  tx_dcrds_sum;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_NDCRD            -1:0]  tx_dcrds_inc;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][                             2:0]  tx_dcrds_dec;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0]                                    tx_dcrds_inf_next;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0]                                    tx_dcrds_inf_q;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0]                                    tx_dcrds_carry_q;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH  :0]  tx_dcrds_consumed_next;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_dcrds_consumed_q;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][11:0]                              tx_dcrds_consumed_scaled;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_dcrds_max_q;
logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][11:0]                              tx_dcrds_max_scaled;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0]                                    tx_rcvd_min_dcrds;

logic                                                                       tx_min_crds_rcvd_next;
logic                                                                       tx_min_crds_rcvd_q;

//-----------------------------------------------------------------------------------------------------

always_comb begin

 tx_hcrds_inc          = '0;
 tx_hcrds_dec          = '0;

 tx_dcrds_inc          = '0;
 tx_dcrds_dec          = '0;

 tx_hcrds_sum          = '0;
 tx_dcrds_sum          = '0;

 tx_hcrds_next         = tx_hcrds_q;
 tx_dcrds_next         = tx_dcrds_q;

 tx_hcrds_inf_next     = tx_hcrds_inf_q;
 tx_dcrds_inf_next     = tx_dcrds_inf_q;

 tx_rx_empty_rose_next = tx_rx_empty_rose_q;

 for (int vc=0; vc<HQM_SFI_TX_HDR_NUM_VCS; vc=vc+1) begin
  for (int fc=0; fc<3; fc=fc+1) begin
   tx_hcrds_consumed_next[vc][fc] = {1'b0, tx_hcrds_consumed_q[vc][fc]};
  end
 end

 for (int vc=0; vc<HQM_SFI_TX_DATA_NUM_VCS; vc=vc+1) begin
  for (int fc=0; fc<3; fc=fc+1) begin
   tx_dcrds_consumed_next[vc][fc] = {1'b0, tx_dcrds_consumed_q[vc][fc]};
  end
 end

 //----------------------------------------------------------------------------------------------------
 // TX interface credit returns increment the available credit counters.
 // These increments will be dropped if the TX SM is in the DISCONNECTED state.
 // Infinite credits are denoted by a credit credit return with a value of 0.
 //
 // TI transactions decrement the available credit counters and increment the consumed credit counters.
 // The data credits also require the adjust interface to account for the fact that the TX doesn't yet
 // have the header when it drives the consume interface and must assume the data credit value needed
 // is the max of 4.  If it ends up needing less than 4, the adjust interface is driven to provide the
 // required adjustment.

 // Only manage credits for a channel if it is a valid channel for the hqm and it hasn't been set to
 // infinite credits already.

 // SFI supports up to 32 VCs with 5b of vc_id.  Our mapping regs only support up to 8 VCs using the
 // lower 3b of the 5b external vc_id, which should be fine for supporting the 3 VCs we actually need,
 // unless there is a need to use an external VC > 7.

 // The VC mapping reg has 4b for each of the first 8 external VCs.  The ms bit is the valid bit which
 // indicates we are using that external channel and the lower 3b are the internal VC to which we map it.
 // So it's a valid external VC if the it is < 8 and the valid bit is set.  This is necessary because,
 // for example, during credit init the fabric may provide credits or an infinite indication for VCs
 // we are not actually using.

 sfi_tx_hdr_crd_val_vc  = sfi_tx_hdr_crd_rtn_valid_q  & (~(|sfi_tx_hdr_crd_rtn_vc_id_q[4:3]))  &
                            cfg_sif_vc_rxmap[{sfi_tx_hdr_crd_rtn_vc_id_q[2:0],  2'd3}];

 sfi_tx_data_crd_val_vc = sfi_tx_data_crd_rtn_valid_q & (~(|sfi_tx_data_crd_rtn_vc_id_q[4:3])) &
                            cfg_sif_vc_rxmap[{sfi_tx_data_crd_rtn_vc_id_q[2:0], 2'd3}];

 sfi_tx_hdr_crd_rtn_vc  = cfg_sif_vc_rxmap[{sfi_tx_hdr_crd_rtn_vc_id_q[2:0],  2'd0} +: HQM_SFI_TX_HDR_VC_WIDTH];

 sfi_tx_data_crd_rtn_vc = cfg_sif_vc_rxmap[{sfi_tx_data_crd_rtn_vc_id_q[2:0], 2'd0} +: HQM_SFI_TX_DATA_VC_WIDTH];

 // Returned hdr credits (from fabric)
 // Note that these are also driven by the fabric during credit init to provide the fabric credits.

 if (sfi_tx_hdr_crd_val_vc & ~tx_hcrds_inf_q[sfi_tx_hdr_crd_rtn_vc][sfi_tx_hdr_crd_rtn_fc_id_q]) begin

  tx_hcrds_inc[     sfi_tx_hdr_crd_rtn_vc][sfi_tx_hdr_crd_rtn_fc_id_q] = sfi_tx_hdr_crd_rtn_value_q;
  tx_hcrds_inf_next[sfi_tx_hdr_crd_rtn_vc][sfi_tx_hdr_crd_rtn_fc_id_q] = ~(|sfi_tx_hdr_crd_rtn_value_q);

 end

 // Consumed hdr credits (from TI)

 if (tx_hcrd_consume_v & ~tx_hcrds_inf_q[tx_hcrd_consume_vc][tx_hcrd_consume_fc]) begin

  tx_hcrds_dec[tx_hcrd_consume_vc][tx_hcrd_consume_fc] = tx_hcrd_consume_val;

 end

 // Returned data credits (from fabric)
 // Note that these are also driven by the fabric during credit init to provide the fabric credits.

 if (sfi_tx_data_crd_val_vc & ~tx_dcrds_inf_q[sfi_tx_data_crd_rtn_vc][sfi_tx_data_crd_rtn_fc_id_q]) begin

  tx_dcrds_inc[     sfi_tx_data_crd_rtn_vc][sfi_tx_data_crd_rtn_fc_id_q] = sfi_tx_data_crd_rtn_value_q;
  tx_dcrds_inf_next[sfi_tx_data_crd_rtn_vc][sfi_tx_data_crd_rtn_fc_id_q] = ~(|sfi_tx_data_crd_rtn_value_q);

 end

 // Consumed data credits (from TI)

 if (tx_dcrd_consume_v & ~tx_dcrds_inf_q[tx_dcrd_consume_vc][tx_dcrd_consume_fc]) begin

  tx_dcrds_dec[tx_dcrd_consume_vc][tx_dcrd_consume_fc] = tx_dcrd_consume_val;

 end

 //----------------------------------------------------------------------------------------------------
 // Accept credit returns except when in the DISCONNECTED state

 if (tx_sm_disconnected) begin // DISCONNECTED

  // If disconnected, clear the credit counters

  tx_hcrds_next         = '0;
  tx_dcrds_next         = '0;
  tx_rx_empty_rose_next = '0;

 end // DISCONNECTED

 else begin // Not DISCONNECTED

  // Normal running is to just manage the increment and decrement of the credit counters.
  // These need to be limited to the max value the counter width supports during init.
  // An underflow should never occur since TX won't issue w/o having enough credits.
  // An overflow after credit init could be flagged, but I don't think it matters.

  for (int vc=0; vc<HQM_SFI_TX_HDR_NUM_VCS; vc=vc+1) begin // vc
   for (int fc=0; fc<=2; fc=fc+1) begin // fc

    if (|{tx_hcrds_inc[vc][fc], tx_hcrds_dec[vc][fc]}) begin

     tx_hcrds_sum[vc][fc] = {1'b0, tx_hcrds_q[vc][fc]} +
      {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH - HQM_SFI_TX_NHCRD + 1){1'b0}}, tx_hcrds_inc[vc][fc]} -
      {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH - 1                + 1){1'b0}}, tx_hcrds_dec[vc][fc]};

     if (tx_hcrds_sum[vc][fc][HQM_SFI_TX_MAX_CRD_CNT_WIDTH]) begin // Saturate

      tx_hcrds_next[vc][fc] = '1;

     end // Saturate

     else begin // Normal sum

      tx_hcrds_next[vc][fc] = tx_hcrds_sum[vc][fc][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0];

     end // Normal sum

    end

    // Only apply inc to consumed after we've received tx_rx_empty so the init credits
    // don't underflow it..

    if (|{tx_hcrds_dec[vc][fc]
        ,(tx_hcrds_inc[vc][fc] & {HQM_SFI_TX_NHCRD{tx_rx_empty_rose_q}})}) begin

     tx_hcrds_consumed_next[vc][fc] = {1'b0, tx_hcrds_consumed_q[vc][fc]} -
      {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH - HQM_SFI_TX_NHCRD + 1){1'b0}}, tx_hcrds_inc[vc][fc]} +
      {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH - 1                + 1){1'b0}}, tx_hcrds_dec[vc][fc]};

    end

   end // fc
  end // vc

  for (int vc=0; vc<HQM_SFI_TX_DATA_NUM_VCS; vc=vc+1) begin // vc
   for (int fc=0; fc<=2; fc=fc+1) begin // fc

    if (|{tx_dcrds_inc[vc][fc], tx_dcrds_dec[vc][fc]}) begin

     tx_dcrds_sum[vc][fc] = {1'b0, tx_dcrds_q[vc][fc]} +
      {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH - HQM_SFI_TX_NDCRD + 1){1'b0}}, tx_dcrds_inc[vc][fc]} -
      {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH - 3                + 1){1'b0}}, tx_dcrds_dec[vc][fc]};

     if (tx_dcrds_sum[vc][fc][HQM_SFI_TX_MAX_CRD_CNT_WIDTH]) begin // Saturate

      tx_dcrds_next[vc][fc] = '1;

     end // Saturate

     else begin // Normal sum

      tx_dcrds_next[vc][fc] = tx_dcrds_sum[vc][fc][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0];

     end // Normal sum
    end

    // Only apply inc to consumed after we've received tx_rx_empty so the init credits
    // don't underflow it..

    if (|{tx_dcrds_dec[vc][fc]
        ,(tx_dcrds_inc[vc][fc] & {HQM_SFI_TX_NDCRD{tx_rx_empty_rose_q}})}) begin

     tx_dcrds_consumed_next[vc][fc] = {1'b0, tx_dcrds_consumed_q[vc][fc]} -
      {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH - HQM_SFI_TX_NDCRD + 1){1'b0}}, tx_dcrds_inc[vc][fc]} +
      {{(HQM_SFI_TX_MAX_CRD_CNT_WIDTH - 3                + 1){1'b0}}, tx_dcrds_dec[vc][fc]};

    end

   end // fc
  end // vc

  // This sets on the first rising edge of tx_rx_empty and stays set until reset or disconnected

  if (sfi_tx_rx_empty_q) begin

   tx_rx_empty_rose_next = '1;

  end

 end // Not DISCONNECTED

end

// It is an error if we oberflow or underflow the consumed credit counters.
// Flagging this in the tx_*crds_carry_q flops to be reported.

always_ff @(posedge clk_gated or negedge rst_b) begin
 if (~rst_b) begin

  tx_rx_empty_rose_q  <= '0;

  tx_hcrds_q          <= '0;
  tx_hcrds_inf_q      <= '0;
  tx_hcrds_max_q      <= '0;

  tx_hcrds_carry_q    <= '0;
  tx_hcrds_consumed_q <= '0;

  tx_dcrds_q          <= '0;
  tx_dcrds_inf_q      <= '0;
  tx_dcrds_max_q      <= '0;

  tx_dcrds_carry_q    <= '0;
  tx_dcrds_consumed_q <= '0;

  tx_min_crds_rcvd_q  <= '0;

 end else begin

  tx_rx_empty_rose_q  <= tx_rx_empty_rose_next;

  // Latch up the maximum number of credits when on a rising edge of tx_rx_empty

  if (sfi_tx_rx_empty_q & ~tx_rx_empty_rose_q & ~tx_sm_disconnected) begin

   tx_hcrds_max_q     <= tx_hcrds_next;
   tx_dcrds_max_q     <= tx_dcrds_next;

  end

  tx_hcrds_q          <= tx_hcrds_next;
  tx_hcrds_inf_q      <= tx_hcrds_inf_next;

  for (int vc=0; vc<HQM_SFI_TX_HDR_NUM_VCS; vc=vc+1) begin
   for (int fc=0; fc<3; fc=fc+1) begin
    tx_hcrds_carry_q[   vc][fc] <= tx_hcrds_consumed_next[vc][fc][HQM_SFI_TX_MAX_CRD_CNT_WIDTH];
    tx_hcrds_consumed_q[vc][fc] <= tx_hcrds_consumed_next[vc][fc][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0];
   end
  end

  tx_dcrds_q          <= tx_dcrds_next;
  tx_dcrds_inf_q      <= tx_dcrds_inf_next;

  for (int vc=0; vc<HQM_SFI_TX_DATA_NUM_VCS; vc=vc+1) begin
   for (int fc=0; fc<3; fc=fc+1) begin
    tx_dcrds_carry_q[   vc][fc] <= tx_dcrds_consumed_next[vc][fc][HQM_SFI_TX_MAX_CRD_CNT_WIDTH];
    tx_dcrds_consumed_q[vc][fc] <= tx_dcrds_consumed_next[vc][fc][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0];
   end
  end

  tx_min_crds_rcvd_q  <= tx_min_crds_rcvd_next;

 end
end

generate

 for (genvar gvc=0; gvc<HQM_SFI_TX_HDR_NUM_VCS; gvc=gvc+1) begin: g_hvc
  for (genvar gfc=0; gfc<3; gfc=gfc+1) begin: g_hfc

   hqm_AW_width_scale #(.A_WIDTH(HQM_SFI_TX_MAX_CRD_CNT_WIDTH), .Z_WIDTH(12)) i_tx_hcrds_scaled (
       .a       (tx_hcrds_q[gvc][gfc])
      ,.z       (tx_hcrds_scaled[gvc][gfc])
   );

   hqm_AW_width_scale #(.A_WIDTH(HQM_SFI_TX_MAX_CRD_CNT_WIDTH), .Z_WIDTH(12)) i_tx_hcrds_consumed_scaled (
       .a       (tx_hcrds_consumed_q[gvc][gfc])
      ,.z       (tx_hcrds_consumed_scaled[gvc][gfc])
   );

   hqm_AW_width_scale #(.A_WIDTH(HQM_SFI_TX_MAX_CRD_CNT_WIDTH), .Z_WIDTH(12)) i_tx_hcrds_max_scaled (
       .a       (tx_hcrds_max_q[gvc][gfc])
      ,.z       (tx_hcrds_max_scaled[gvc][gfc])
   );

  end
 end

 for (genvar gvc=0; gvc<HQM_SFI_TX_DATA_NUM_VCS; gvc=gvc+1) begin: g_dvc
  for (genvar gfc=0; gfc<3; gfc=gfc+1) begin: g_dfc

   hqm_AW_width_scale #(.A_WIDTH(HQM_SFI_TX_MAX_CRD_CNT_WIDTH), .Z_WIDTH(12)) i_tx_dcrds_scaled (
       .a       (tx_dcrds_q[gvc][gfc])
      ,.z       (tx_dcrds_scaled[gvc][gfc])
   );

   hqm_AW_width_scale #(.A_WIDTH(HQM_SFI_TX_MAX_CRD_CNT_WIDTH), .Z_WIDTH(12)) i_tx_dcrds_consumed_scaled (
       .a       (tx_dcrds_consumed_q[gvc][gfc])
      ,.z       (tx_dcrds_consumed_scaled[gvc][gfc])
   );

   hqm_AW_width_scale #(.A_WIDTH(HQM_SFI_TX_MAX_CRD_CNT_WIDTH), .Z_WIDTH(12)) i_tx_dcrds_max_scaled (
       .a       (tx_dcrds_max_q[gvc][gfc])
      ,.z       (tx_dcrds_max_scaled[gvc][gfc])
   );

  end
 end

endgenerate


always_comb begin

 // Output available credits

 // Force available credits to 0 if we haven't seen the rising edge of tx_rx_empty.
 // Force available credits to max if infinite credit flag is set.

 for (int vc=0; vc<HQM_SFI_TX_HDR_NUM_VCS; vc=vc+1) begin
  for (int fc=0; fc<3; fc=fc+1) begin

   tx_hcrds_avail[vc][fc] = (tx_hcrds_q[vc][fc] |
                             {HQM_SFI_TX_MAX_CRD_CNT_WIDTH{tx_hcrds_inf_q[vc][fc]}}) &
                             {HQM_SFI_TX_MAX_CRD_CNT_WIDTH{tx_rx_empty_rose_q}};

   tx_rcvd_min_hcrds[vc][fc] = (~HQM_SFI_TX_VC_FC_USED[vc][fc][0]) | (|tx_hcrds_avail[vc][fc]);

  end
 end

 for (int vc=0; vc<HQM_SFI_TX_DATA_NUM_VCS; vc=vc+1) begin
  for (int fc=0; fc<3; fc=fc+1) begin

   tx_dcrds_avail[vc][fc] = (tx_dcrds_q[vc][fc] |
                             {HQM_SFI_TX_MAX_CRD_CNT_WIDTH{tx_dcrds_inf_q[vc][fc]}}) &
                             {HQM_SFI_TX_MAX_CRD_CNT_WIDTH{tx_rx_empty_rose_q}};

   tx_rcvd_min_dcrds[vc][fc] = (~HQM_SFI_TX_VC_FC_USED[vc][fc][0]) |
     (tx_dcrds_avail[vc][fc] >=  HQM_SFI_TX_MIN_DCRDS[ vc][fc][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]);

  end
 end

 tx_min_crds_rcvd_next = tx_rx_empty_rose_q & (&{tx_rcvd_min_hcrds, tx_rcvd_min_dcrds});

 tx_min_crds_rcvd      = tx_min_crds_rcvd_q;

 // Flag if we have consumed credits outstanding

 tx_has_consumed_crds = (|{tx_hcrds_consumed_q, tx_dcrds_consumed_q});

 // Report any consumed credit overflow or underflow
 // The syndrome would need to be adjusted if we end up with more than 2 VCs

 tx_hcrds_used_xflow      = (|tx_hcrds_carry_q);
 tx_hcrds_used_xflow_synd = { 1'b0, tx_hcrds_carry_q[1][2:0], 1'b0, tx_hcrds_carry_q[0][2:0]};
 tx_dcrds_used_xflow      = (|tx_dcrds_carry_q);
 tx_dcrds_used_xflow_synd = { 1'b0, tx_dcrds_carry_q[1][2:0], 1'b0, tx_dcrds_carry_q[0][2:0]};

 // Credit status outputs

 for (int vc=0; vc<HQM_SFI_TX_HDR_NUM_VCS; vc=vc+1) begin
  for (int fc=0; fc<3; fc=fc+1) begin
   tx_init_hcrds[vc][fc] = {tx_hcrds_inf_q[vc][fc], tx_hcrds_max_scaled[vc][fc]};
   tx_rem_hcrds[ vc][fc] = {tx_hcrds_inf_q[vc][fc], tx_hcrds_scaled[vc][fc]};
   tx_used_hcrds[vc][fc] = {tx_hcrds_inf_q[vc][fc], tx_hcrds_consumed_scaled[vc][fc]};
  end
 end

 for (int vc=0; vc<HQM_SFI_TX_DATA_NUM_VCS; vc=vc+1) begin
  for (int fc=0; fc<3; fc=fc+1) begin
   tx_init_dcrds[vc][fc] = {tx_dcrds_inf_q[vc][fc], tx_dcrds_max_scaled[vc][fc]};
   tx_rem_dcrds[ vc][fc] = {tx_dcrds_inf_q[vc][fc], tx_dcrds_scaled[vc][fc]};
   tx_used_dcrds[vc][fc] = {tx_dcrds_inf_q[vc][fc], tx_dcrds_consumed_scaled[vc][fc]};
  end
 end

end

endmodule // hqm_sfi_tx_crd

