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

module hqm_sfi2iosf

     import hqm_sfi_pkg::*;
#(

`include "hqm_sfi_params.sv"

,parameter IOSF_DATA_WIDTH = 512
,parameter IOSF_DPAR_WIDTH = ((IOSF_DATA_WIDTH == 512) ? 2 : 1)

) (
     input  logic                                       prim_clk
    ,input  logic                                       prim_rst_b

    ,input  logic                                       iosf_pgcb_clk

    ,input  logic                                       agent_idle

    ,input  logic                                       config_done

    //-------------------------------------------------------------------------------------------------
    // SFI Agent to Fabric Global

    ,output logic                                       sfi_tx_txcon_req            // Connection request

    ,input  logic                                       sfi_tx_rxcon_ack            // Connection acknowledge
    ,input  logic                                       sfi_tx_rxdiscon_nack        // Disconnect rejection
    ,input  logic                                       sfi_tx_rx_empty             // Reciever queues are empty and all credits returned

    // SFI Agent to Fabric Request

    ,output logic                                       sfi_tx_hdr_valid            // Header is valid
    ,output logic                                       sfi_tx_hdr_early_valid      // Header early valid indication
    ,output hqm_sfi_hdr_info_t                          sfi_tx_hdr_info_bytes       // Header info
    ,output logic [(HQM_SFI_TX_H*8 )-1:0]               sfi_tx_header               // Header

    ,input  logic                                       sfi_tx_hdr_block            // RX requires TX to pause requests

    ,input  logic                                       sfi_tx_hdr_crd_rtn_valid    // RX returning hdr credit
    ,input  logic [4:0]                                 sfi_tx_hdr_crd_rtn_vc_id    // Credit virtual channel
    ,input  hqm_sfi_fc_id_t                             sfi_tx_hdr_crd_rtn_fc_id    // Credit flow class
    ,input  logic [HQM_SFI_TX_NHCRD-1:0]                sfi_tx_hdr_crd_rtn_value    // Number of hdr credits returned per cycle

    ,output logic                                       sfi_tx_hdr_crd_rtn_block    // TX requires RX to pause hdr credit returns

    // SFI Agent to Fabric Data

    ,output logic                                       sfi_tx_data_valid           // Data is valid
    ,output logic                                       sfi_tx_data_early_valid     // Data early valid indication
    ,output logic                                       sfi_tx_data_aux_parity      // Data auxilliary parity
    ,output logic [(HQM_SFI_TX_D/4)-1:0]                sfi_tx_data_poison          // Data poisoned per DW
    ,output logic [(HQM_SFI_TX_D/4)-1:0]                sfi_tx_data_edb             // Data bad per DW
    ,output logic                                       sfi_tx_data_start           // Start of data
    ,output logic [(HQM_SFI_TX_D/4)-1:0]                sfi_tx_data_end             // End   of data
    ,output logic [(HQM_SFI_TX_D/8)-1:0]                sfi_tx_data_parity          // Data parity per 8B
    ,output hqm_sfi_data_info_t                         sfi_tx_data_info_byte       // Data info
    ,output logic [(HQM_SFI_TX_D*8)-1:0]                sfi_tx_data                 // Data payload

    ,input  logic                                       sfi_tx_data_block           // RX requires TX to pause data

    ,input  logic                                       sfi_tx_data_crd_rtn_valid   // RX returning data credit
    ,input  logic [4:0]                                 sfi_tx_data_crd_rtn_vc_id   // Credit virtual channel
    ,input  hqm_sfi_fc_id_t                             sfi_tx_data_crd_rtn_fc_id   // Credit flow class
    ,input  logic [HQM_SFI_TX_NDCRD-1:0]                sfi_tx_data_crd_rtn_value   // Number of data credits returned per cycle

    ,output logic                                       sfi_tx_data_crd_rtn_block   // TX requires RX to pause data credit returns

    //-------------------------------------------------------------------------------------------------
    // SFI Fabric to Agent Global

    ,input  logic                                       sfi_rx_txcon_req            // Connection request

    ,output logic                                       sfi_rx_rxcon_ack            // Connection acknowledge
    ,output logic                                       sfi_rx_rxdiscon_nack        // Disconnect rejection
    ,output logic                                       sfi_rx_rx_empty             // Reciever queues are empty and all credits returned

    // SFI Fabric to Agent Request

    ,input  logic                                       sfi_rx_hdr_valid            // Header is valid
    ,input  logic                                       sfi_rx_hdr_early_valid      // Header early valid indication
    ,input  hqm_sfi_hdr_info_t                          sfi_rx_hdr_info_bytes       // Header info
    ,input  logic [(HQM_SFI_RX_H*8 )-1:0]               sfi_rx_header               // Header

    ,output logic                                       sfi_rx_hdr_block            // RX requires TX to pause requests

    ,output logic                                       sfi_rx_hdr_crd_rtn_valid    // RX returning credit
    ,output logic [4:0]                                 sfi_rx_hdr_crd_rtn_vc_id    // Credit virtual channel
    ,output hqm_sfi_fc_id_t                             sfi_rx_hdr_crd_rtn_fc_id    // Credit flow class
    ,output logic [HQM_SFI_RX_NHCRD-1:0]                sfi_rx_hdr_crd_rtn_value    // Number of credits returned per cycle

    ,input  logic                                       sfi_rx_hdr_crd_rtn_block    // TX requires RX to pause hdr credit returns

    // SFI Fabric to Agent Data

    ,input  logic                                       sfi_rx_data_valid           // Data is valid
    ,input  logic                                       sfi_rx_data_early_valid     // Data early valid indication
    ,input  logic                                       sfi_rx_data_aux_parity      // Data auxilliary parity
    ,input  logic [(HQM_SFI_RX_D/4)-1:0]                sfi_rx_data_poison          // Data poisoned per DW
    ,input  logic [(HQM_SFI_RX_D/4)-1:0]                sfi_rx_data_edb             // Data bad per DW
    ,input  logic                                       sfi_rx_data_start           // Start of data
    ,input  logic [(HQM_SFI_RX_D/4)-1:0]                sfi_rx_data_end             // End   of data
    ,input  logic [(HQM_SFI_RX_D/8)-1:0]                sfi_rx_data_parity          // Data parity per 8B
    ,input  hqm_sfi_data_info_t                         sfi_rx_data_info_byte       // Data info
    ,input  logic [(HQM_SFI_RX_D*8)-1:0]                sfi_rx_data                 // Data payload

    ,output logic                                       sfi_rx_data_block           // RX requires TX to pause data

    ,output logic                                       sfi_rx_data_crd_rtn_valid   // RX returning credit
    ,output logic [4:0]                                 sfi_rx_data_crd_rtn_vc_id   // Credit virtual channel
    ,output hqm_sfi_fc_id_t                             sfi_rx_data_crd_rtn_fc_id   // Credit flow class
    ,output logic [HQM_SFI_RX_NDCRD-1:0]                sfi_rx_data_crd_rtn_value   // Number of credits returned per cycle

    ,input  logic                                       sfi_rx_data_crd_rtn_block   // TX requires RX to pause data credit returns

    //-------------------------------------------------------------------------------------------------
    // IOSF Fabric to Agent

    ,output logic                                       prim_pok
    ,input  logic                                       prim_clkack
    ,output logic                                       prim_clkreq

    ,input  logic [2:0]                                 prim_ism_fabric
    ,output logic [2:0]                                 prim_ism_agent

    ,output logic                                       credit_put
    ,output logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]         credit_chid
    ,output logic [1:0]                                 credit_rtype
    ,output logic                                       credit_cmd
    ,output logic [2:0]                                 credit_data

    ,input  logic                                       cmd_put
    ,input  logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]         cmd_chid
    ,input  logic [1:0]                                 cmd_rtype

    ,input  logic [63:0]                                taddress
    ,input  logic [1:0]                                 tat
    ,input  logic                                       tcparity
    ,input  logic [IOSF_DATA_WIDTH-1:0]                 tdata
    ,input  logic [IOSF_DPAR_WIDTH-1:0]                 tdparity
    ,input  logic                                       tep
    ,input  logic [3:0]                                 tfbe
    ,input  logic [1:0]                                 tfmt
    ,input  logic                                       tido
    ,input  logic [3:0]                                 tlbe
    ,input  logic [9:0]                                 tlength
    ,input  logic                                       tns
    ,input  logic [22:0]                                tpasidtlp
    ,input  logic                                       tro
    ,input  logic [15:0]                                trqid
    ,input  logic                                       trsvd1_3
    ,input  logic                                       trsvd1_7
    ,input  logic [7:0]                                 tsai
    ,input  logic [7:0]                                 ttag
    ,input  logic [3:0]                                 ttc
    ,input  logic                                       ttd
    ,input  logic                                       tth
    ,input  logic [4:0]                                 ttype

    // IOSF Agent to fabric

    ,output logic                                       req_put
    ,output logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]         req_chid
    ,output logic                                       req_agent
    ,output logic                                       req_cdata
    ,output logic                                       req_chain
    ,output logic [13:0]                                req_dest_id
    ,output logic [9:0]                                 req_dlen
    ,output logic [15:0]                                req_id
    ,output logic                                       req_ido
    ,output logic                                       req_locked
    ,output logic                                       req_ns
    ,output logic                                       req_opp
    ,output logic                                       req_ro
    ,output logic                                       req_rs
    ,output logic [1:0]                                 req_rtype
    ,output logic [3:0]                                 req_tc

    ,input  logic                                       gnt
    ,input  logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]         gnt_chid
    ,input  logic [1:0]                                 gnt_rtype
    ,input  logic [1:0]                                 gnt_type

    ,output logic [63:0]                                maddress
    ,output logic [1:0]                                 mat
    ,output logic                                       mcparity
    ,output logic [IOSF_DATA_WIDTH-1:0]                 mdata
    ,output logic [IOSF_DPAR_WIDTH-1:0]                 mdparity
    ,output logic                                       mep
    ,output logic [3:0]                                 mfbe
    ,output logic [1:0]                                 mfmt
    ,output logic                                       mido
    ,output logic [3:0]                                 mlbe
    ,output logic [9:0]                                 mlength
    ,output logic                                       mns
    ,output logic [22:0]                                mpasidtlp
    ,output logic                                       mro
    ,output logic [15:0]                                mrqid
    ,output logic                                       mrsvd1_3
    ,output logic                                       mrsvd1_7
    ,output logic [7:0]                                 msai
    ,output logic [7:0]                                 mtag
    ,output logic [3:0]                                 mtc
    ,output logic                                       mtd
    ,output logic                                       mth
    ,output logic [4:0]                                 mtype
);

//-------------------------------------------------------------------------------------------------

typedef struct packed {

 logic [7:0]                            sai;           // 159:152      In TLP prefix outside of normal 128b header
 logic [22:0]                           pasidtlp;      // 151:129      In TLP prefix outside of normal 128b header
 logic                                  parity;        // 128          Header parity
 logic [1:0]                            fmt;           // 127:125
 logic [4:0]                            ttype;         // 124:120
 logic                                  tag9;          // 119          rsvd1_7
 logic [3:0]                            tc;            // 118:116
 logic                                  tag8;          // 115          rsvd1_3
 logic                                  ido;           // 114          attr2
 logic                                  rsvd1_1;       // 113
 logic                                  th;            // 112
 logic                                  td;            // 111
 logic                                  ep;            // 110
 logic                                  ro;            // 109          attr[1]
 logic                                  ns;            // 108          attr[0]
 hqm_sfi_at_t                           at;            // 107:106
 logic [9:0]                            length;        // 105: 96      DWs
 logic [15:0]                           reqid;         //  95: 80
 logic [7:0]                            tag;           //  79: 72
 logic [3:0]                            lbe;           //  71: 68
 logic [3:0]                            fbe;           //  67: 64
 logic [63:0]                           address;       //  63:  0

} hqm_iosf_mem_hdr_t;

typedef struct packed {

 logic [7:0]                            sai;           // 159:152      In TLP prefix outside of normal 128b header
 logic [22:0]                           pasidtlp;      // 151:129      In TLP prefix outside of normal 128b header
 logic                                  parity;        // 128          Header parity
 logic [1:0]                            fmt;           // 127:125
 logic [4:0]                            ttype;         // 124:120
 logic                                  tag9;          // 119          rsvd1_7
 logic [3:0]                            tc;            // 118:116
 logic                                  tag8;          // 115          rsvd1_3
 logic                                  ido;           // 114          attr2
 logic                                  rsvd1_1;       // 113
 logic                                  th;            // 112
 logic                                  td;            // 111
 logic                                  ep;            // 110
 logic                                  ro;            // 109          attr[1]
 logic                                  ns;            // 108          attr[0]
 hqm_sfi_at_t                           at;            // 107:106
 logic [9:0]                            length;        // 105: 96      DWs
 logic [15:0]                           reqid;         //  95: 80
 logic [7:0]                            tag;           //  79: 72
 logic [3:0]                            lbe;           //  71: 68
 logic [3:0]                            fbe;           //  67: 64
 logic [31:0]                           rsvd63_32;     //  63: 32
 logic [15:0]                           bdf;           //  31: 16
 logic [3:0]                            rsvd15_12;     //  15: 12
 logic [9:0]                            regnum;        //  11:  2
 logic [1:0]                            rsvd1_0;       //   1:  0

} hqm_iosf_cfg_hdr_t;

typedef struct packed {

 logic [7:0]                            sai;           // 159:152      In TLP prefix outside of normal 128b header
 logic [22:0]                           pasidtlp;      // 151:129      In TLP prefix outside of normal 128b header
 logic                                  parity;        // 128          Header parity
 logic [1:0]                            fmt;           // 127:125
 logic [4:0]                            ttype;         // 124:120
 logic                                  tag9;          // 119          rsvd1_7
 logic [3:0]                            tc;            // 118:116
 logic                                  tag8;          // 115          rsvd1_3
 logic                                  ido;           // 114          attr2
 logic                                  rsvd1_1;       // 113
 logic                                  th;            // 112
 logic                                  td;            // 111
 logic                                  ep;            // 110
 logic                                  ro;            // 109          attr[1]
 logic                                  ns;            // 108          attr[0]
 hqm_sfi_at_t                           at;            // 107:106
 logic [9:0]                            length;        // 105: 96      DWs
 logic [15:0]                           cplid;         //  95: 80
 hqm_sfi_cpl_status_t                   cpl_status;    //  79: 77
 logic                                  bcm;           //  76
 logic [11:0]                           bc;            //  71: 64
 logic [31:0]                           rsvd63_32;     //  63: 32
 logic [15:0]                           reqid;         //  31: 16
 logic [7:0]                            tag;           //  15:  8
 logic                                  rsvd7;         //   7
 logic [6:0]                            laddr;         //   6:  0

} hqm_iosf_cpl_hdr_t;

typedef struct packed {

 logic [7:0]                            sai;           // 159:152      In TLP prefix outside of normal 128b header
 logic [22:0]                           pasidtlp;      // 151:129      In TLP prefix outside of normal 128b header
 logic                                  parity;        // 128          Header parity
 logic [1:0]                            fmt;           // 127:125
 logic [4:0]                            ttype;         // 124:120
 logic                                  tag9;          // 119          rsvd1_7
 logic [3:0]                            tc;            // 118:116
 logic                                  tag8;          // 115          rsvd1_3
 logic                                  ido;           // 114          attr2
 logic                                  rsvd1_1;       // 113
 logic                                  th;            // 112
 logic                                  td;            // 111
 logic                                  ep;            // 110
 logic                                  ro;            // 109          attr[1]
 logic                                  ns;            // 108          attr[0]
 hqm_sfi_at_t                           at;            // 107:106
 logic [9:0]                            length;        // 105: 96      DWs
 logic [15:0]                           reqid;         //  95: 80
 logic [7:0]                            tag;           //  79: 72
 logic [7:0]                            msg_code;      //  71: 64
 logic [15:0]                           bdf;           //  63: 48
 logic [47:0]                           rsvd47_0;      //  47:  0

} hqm_iosf_msg_hdr_t;

typedef union packed {
 hqm_iosf_mem_hdr_t                     mem;
 hqm_iosf_cfg_hdr_t                     cfg;
 hqm_iosf_cpl_hdr_t                     cpl;
 hqm_iosf_msg_hdr_t                     msg;
} hqm_iosf_hdr_t;

typedef struct packed {

 logic                                  put;
 logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]    chid;
 hqm_sfi_fc_id_t                        rtype;
 logic                                  cdata;
 logic                                  ido;
 logic                                  ro;
 logic                                  ns;
 logic                                  locked;
 logic [3:0]                            tc;
 logic [9:0]                            dlen;
 logic [15:0]                           id;

} hqm_iosf_req_t;

typedef struct packed {

 logic                                  gnt;
 logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]    chid;
 logic [1:0]                            rtype;
 logic [1:0]                            gtype;

} hqm_iosf_gnt_t;

typedef enum logic [1:0] {

  HQM_TXQ_SM_ILLEGAL0 = 2'b00
 ,HQM_TXQ_SM_IDLE     = 2'b01
 ,HQM_TXQ_SM_BEAT2    = 2'b10
 ,HQM_TXQ_SM_ILLEGAL3 = 2'b11

} hqm_txq_sm_t;

localparam int unsigned HQM_TXQ_SM_IDLE_BIT  = 0;
localparam int unsigned HQM_TXQ_SM_BEAT2_BIT = 1;

//-------------------------------------------------------------------------------------------------
// Agent TX interface

logic                                           agent_tx_v;                 // Agent master transaction
logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             agent_tx_vc;
hqm_sfi_fc_id_t                                 agent_tx_fc;
logic [3:0]                                     agent_tx_hdr_size;
logic                                           agent_tx_hdr_has_data;
hqm_sfi_flit_header_t                           agent_tx_hdr;
logic                                           agent_tx_hdr_par;
logic [(HQM_SFI_TX_D*8)-1:0]                    agent_tx_data;
logic [(HQM_SFI_TX_D/8)-1:0]                    agent_tx_data_par;

logic                                           agent_tx_ack;

//-------------------------------------------------------------------------------------------------
// Agent RX interface

logic                                           agent_rxqs_empty;

logic                                           agent_rx_hdr_v;             // Agent target hdr  push
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             agent_rx_hdr_vc;
hqm_sfi_fc_id_t                                 agent_rx_hdr_fc;
logic [3:0]                                     agent_rx_hdr_size;
logic                                           agent_rx_hdr_has_data;
hqm_sfi_flit_header_t                           agent_rx_hdr;
logic                                           agent_rx_hdr_par;

logic                                           agent_rx_data_v;            // Agent target data push
logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]            agent_rx_data_vc;
hqm_sfi_fc_id_t                                 agent_rx_data_fc;
logic [(HQM_SFI_RX_D*8)-1:0]                    agent_rx_data;
logic [(HQM_SFI_RX_D/8)-1:0]                    agent_rx_data_par;

hqm_iosf_hdr_t                                  agent_rx_iosf_hdr;

hqm_sfi_pcie_cmd_t                              agent_rx_pcie_cmd_nc;

//-------------------------------------------------------------------------------------------------
// Agent credit interface

logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_hcrds_avail; // Available TX hdr  credits
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][2:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]  tx_dcrds_avail; // Available TX data credits

logic [HQM_SFI_TX_HDR_NUM_VCS -1:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]       txq_ph_fifo_dcrds;
logic [HQM_SFI_TX_DATA_NUM_VCS-1:0][HQM_SFI_TX_MAX_CRD_CNT_WIDTH-1:0]       txq_nph_fifo_dcrds;

logic                                           tx_hcrd_consume_v;          // Consuming TX hdr  credits
logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             tx_hcrd_consume_vc;
hqm_sfi_fc_id_t                                 tx_hcrd_consume_fc;
logic                                           tx_hcrd_consume_val;

logic                                           tx_dcrd_consume_v;          // Consuming TX data credits
logic [HQM_SFI_TX_DATA_VC_WIDTH-1:0]            tx_dcrd_consume_vc;
hqm_sfi_fc_id_t                                 tx_dcrd_consume_fc;
logic [2:0]                                     tx_dcrd_consume_val;

//-------------------------------------------------------------------------------------------------
// Agent credit return interface

logic                                           rx_hcrd_return_v;           // Agent returning RX req  credits
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             rx_hcrd_return_vc;
hqm_sfi_fc_id_t                                 rx_hcrd_return_fc;
logic [HQM_SFI_RX_NHCRD-1:0]                    rx_hcrd_return_val;

logic                                           rx_dcrd_return_v;           // Agent returning RX data credits
logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]            rx_dcrd_return_vc;
hqm_sfi_fc_id_t                                 rx_dcrd_return_fc;
logic [HQM_SFI_RX_NDCRD-1:0]                    rx_dcrd_return_val;

//-------------------------------------------------------------------------------------------------

localparam IOSF_DP_WIDTH = IOSF_DATA_WIDTH + IOSF_DPAR_WIDTH;

logic                                           no_connection;

logic                                           iosf_cmd_put_q;
hqm_sfi_fc_id_t                                 iosf_cmd_rtype_q;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             iosf_cmd_chid_q;
hqm_iosf_hdr_t                                  iosf_cmd_hdr_next;
hqm_iosf_hdr_t                                  iosf_cmd_hdr_q;

logic [IOSF_DP_WIDTH-1:0]                       iosf_cmd_data_next;
logic [IOSF_DP_WIDTH-1:0]                       iosf_cmd_data_q;
logic                                           iosf_cmd_data_vld_next;
logic                                           iosf_cmd_data_vld_q;
logic [2:0]                                     iosf_cmd_data_cnt_next;
logic [2:0]                                     iosf_cmd_data_cnt_q;
hqm_sfi_fc_id_t                                 iosf_cmd_data_rtype_q;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             iosf_cmd_data_chid_q;

logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]              txq_arb_reqs;
logic                                           txq_arb_update;
logic                                           txq_arb_v;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             txq_arb_vc;
hqm_sfi_fc_id_t                                 txq_arb_fc;
hqm_iosf_hdr_t                                  txq_arb_hdr;
logic [(HQM_SFI_RX_D*8)-1:0]                    txq_arb_data;
logic [IOSF_DPAR_WIDTH-1:0]                     txq_arb_iosf_par;
logic [(HQM_SFI_RX_D/8)-1:0]                    txq_arb_data_par;
logic [5:0]                                     txq_arb_data_crds;

hqm_sfi_pcie_cmd_t                              txq_pcie_cmd;

logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             txq_vc;
hqm_sfi_fc_id_t                                 txq_fc;

hqm_txq_sm_t                                    txq_sm_state_next;
hqm_txq_sm_t                                    txq_sm_state_q;
logic                                           txq_sm_use_saved;

logic                                           txq_sm_credit_put;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             txq_sm_credit_chid;
hqm_sfi_fc_id_t                                 txq_sm_credit_rtype;
logic                                           txq_sm_credit_cmd;
logic [2:0]                                     txq_sm_credit_data;

logic [3:0]                                     txq_sfi_hdr_size;
logic                                           txq_sfi_hdr_has_data;
hqm_sfi_flit_header_t                           txq_sfi_hdr;
logic                                           txq_sfi_hdr_par;

logic                                           agent_tx_v_next;
logic                                           agent_tx_v_q;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             agent_tx_vc_next;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             agent_tx_vc_q;
hqm_sfi_fc_id_t                                 agent_tx_fc_next;
hqm_sfi_fc_id_t                                 agent_tx_fc_q;
logic [3:0]                                     agent_tx_hdr_size_next;
logic [3:0]                                     agent_tx_hdr_size_q;
logic                                           agent_tx_hdr_has_data_next;
logic                                           agent_tx_hdr_has_data_q;
hqm_sfi_flit_header_t                           agent_tx_hdr_next;
hqm_sfi_flit_header_t                           agent_tx_hdr_q;
logic                                           agent_tx_hdr_par_next;
logic                                           agent_tx_hdr_par_q;
logic [(HQM_SFI_RX_D*8)-1:0]                    agent_tx_data_next;
logic [(HQM_SFI_RX_D*8)-1:0]                    agent_tx_data_q;
logic [(HQM_SFI_RX_D/8)-1:0]                    agent_tx_data_par_next;
logic [(HQM_SFI_RX_D/8)-1:0]                    agent_tx_data_par_q;
logic                                           agent_tx_hold;
logic [5:0]                                     agent_tx_data_cnt_next;
logic [5:0]                                     agent_tx_data_cnt_q;

logic                                           credit_init;
logic                                           credit_init_done_next;
logic                                           credit_init_done_q;
logic [5:0]                                     credit_init_ccnt_next;
logic [5:0]                                     credit_init_ccnt_q;
logic [5:0]                                     credit_init_dcnt_next;
logic [5:0]                                     credit_init_dcnt_q;

logic                                           credit_init_put;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             credit_init_chid;
hqm_sfi_fc_id_t                                 credit_init_rtype;
logic                                           credit_init_cmd;
logic [2:0]                                     credit_init_data;

logic                                           credit_put_next;
logic                                           credit_put_q;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             credit_chid_next;
logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]             credit_chid_q;
hqm_sfi_fc_id_t                                 credit_rtype_next;
hqm_sfi_fc_id_t                                 credit_rtype_q;
logic                                           credit_cmd_next;
logic                                           credit_cmd_q;
logic [2:0]                                     credit_data_next;
logic [2:0]                                     credit_data_q;

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]              rxq_arb_reqs;
logic                                           rxq_arb_update;
logic                                           rxq_arb_v;
logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             rxq_arb_vc;
hqm_sfi_fc_id_t                                 rxq_arb_fc;
hqm_iosf_hdr_t                                  rxq_arb_hdr;
logic [IOSF_DATA_WIDTH-1:0]                     rxq_arb_data;
logic [IOSF_DPAR_WIDTH-1:0]                     rxq_arb_data_par;

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][2:0]         rxq_arb_hcrd_avail;

hqm_iosf_req_t                                  iosf_req_next;
hqm_iosf_req_t                                  iosf_req_q;

hqm_iosf_gnt_t                                  iosf_gnt_next;
hqm_iosf_gnt_t                                  iosf_gnt_q;

hqm_iosf_hdr_t                                  iosf_req_hdr_out;
logic [5:0]                                     iosf_req_data_crds;

logic [IOSF_DP_WIDTH-1:0]                       iosf_req_data_out_next;
logic [IOSF_DP_WIDTH-1:0]                       iosf_req_data_out_q;
logic                                           iosf_req_data_cnt_nc;
logic [5:0]                                     iosf_req_data_cnt_next;
logic [5:0]                                     iosf_req_data_cnt_q;
logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             iosf_req_data_vc_next;
logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             iosf_req_data_vc_q;
logic [HQM_SFI_TX_HDR_VC_WIDTH-1:0]             iosf_req_data_vc;
hqm_sfi_fc_id_t                                 iosf_req_data_fc_next;
hqm_sfi_fc_id_t                                 iosf_req_data_fc_q;
hqm_sfi_fc_id_t                                 iosf_req_data_fc;
logic                                           iosf_req_data_v_next;

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][2:0]         iosf_req_crdt_cnt_inc;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][2:0]         iosf_req_crdt_cnt_dec;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][2:0][5:0]    iosf_req_crdt_cnt_next;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][2:0][5:0]    iosf_req_crdt_cnt_q;

logic                                           sfi_rx_idle;

hqm_sfi_pcie_cmd_t                              mpcie_cmd;

logic                                           prim_gated_rst_b;
logic                                           pgcb_prim_rst_b;

logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      fabric_np_cnt_inc;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      fabric_np_cnt_dec;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]    fabric_np_cnt_next;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1:0]    fabric_np_cnt_q;
logic                                                                   fabric_np_pending;

//-------------------------------------------------------------------------------------------------

hqm_AW_reset_sync_scan i_prim_gated_rst_b (

     .clk               (prim_clk)
    ,.rst_n             (prim_rst_b)
    ,.fscan_rstbypen    (1'b0)
    ,.fscan_byprst_b    (1'b0)
    ,.rst_n_sync        (prim_gated_rst_b)
);

hqm_AW_reset_sync_scan i_pgcb_prim_rst_b (

     .clk               (iosf_pgcb_clk)
    ,.rst_n             (prim_rst_b)
    ,.fscan_rstbypen    (1'b0)
    ,.fscan_byprst_b    (1'b0)
    ,.rst_n_sync        (pgcb_prim_rst_b)
);

//-------------------------------------------------------------------------------------------------
// Register IOSF target inputs

localparam DATA_BUS_1_BEAT_DWS = IOSF_DATA_WIDTH>>5;        // 4B * 8b width granularity, so width/32b
localparam DATA_BUS_2_BEAT_DWS = DATA_BUS_1_BEAT_DWS*2;
localparam DATA_BUS_3_BEAT_DWS = DATA_BUS_1_BEAT_DWS*3;
localparam DATA_BUS_4_BEAT_DWS = DATA_BUS_1_BEAT_DWS*4;
localparam DATA_BUS_5_BEAT_DWS = DATA_BUS_1_BEAT_DWS*5;
localparam DATA_BUS_6_BEAT_DWS = DATA_BUS_1_BEAT_DWS*6;
localparam DATA_BUS_7_BEAT_DWS = DATA_BUS_1_BEAT_DWS*7;

always_comb begin

 // Assign header fields

 iosf_cmd_hdr_next.mem.sai      = tsai;
 iosf_cmd_hdr_next.mem.pasidtlp = tpasidtlp;

 iosf_cmd_hdr_next.mem.parity   = tcparity;

 iosf_cmd_hdr_next.mem.fmt      = tfmt;
 iosf_cmd_hdr_next.mem.ttype    = ttype;
 iosf_cmd_hdr_next.mem.tag9     = trsvd1_7;
 iosf_cmd_hdr_next.mem.tc       = ttc;
 iosf_cmd_hdr_next.mem.tag8     = trsvd1_3;
 iosf_cmd_hdr_next.mem.ido      = tido;
 iosf_cmd_hdr_next.mem.rsvd1_1  = '0;
 iosf_cmd_hdr_next.mem.th       = tth;
 iosf_cmd_hdr_next.mem.td       = ttd;
 iosf_cmd_hdr_next.mem.ep       = tep;
 iosf_cmd_hdr_next.mem.ro       = tro;
 iosf_cmd_hdr_next.mem.ns       = tns;
 iosf_cmd_hdr_next.mem.at       = hqm_sfi_at_t'(tat);
 iosf_cmd_hdr_next.mem.length   = tlength;
 iosf_cmd_hdr_next.mem.reqid    = trqid;
 iosf_cmd_hdr_next.mem.tag      = ttag;
 iosf_cmd_hdr_next.mem.lbe      = tlbe;
 iosf_cmd_hdr_next.mem.fbe      = tfbe;
 iosf_cmd_hdr_next.mem.address  = taddress;

 iosf_cmd_data_vld_next         = '0;
 iosf_cmd_data_cnt_next         = '0;

 iosf_cmd_data_next             = {tdparity, tdata};

 if (iosf_cmd_put_q & iosf_cmd_hdr_q.mem.fmt[1]) begin // Has data

  iosf_cmd_data_vld_next = '1;

  // This is a count of the number of additional (other than the first) data bus beats
  // required to get all the data for the transaction with data.

  iosf_cmd_data_cnt_next = (iosf_cmd_hdr_q.mem.length > DATA_BUS_7_BEAT_DWS[9:0]) ? 3'd7 :
                          ((iosf_cmd_hdr_q.mem.length > DATA_BUS_6_BEAT_DWS[9:0]) ? 3'd6 :
                          ((iosf_cmd_hdr_q.mem.length > DATA_BUS_5_BEAT_DWS[9:0]) ? 3'd5 :
                          ((iosf_cmd_hdr_q.mem.length > DATA_BUS_4_BEAT_DWS[9:0]) ? 3'd4 :
                          ((iosf_cmd_hdr_q.mem.length > DATA_BUS_3_BEAT_DWS[9:0]) ? 3'd3 :
                          ((iosf_cmd_hdr_q.mem.length > DATA_BUS_2_BEAT_DWS[9:0]) ? 3'd2 :
                          ((iosf_cmd_hdr_q.mem.length > DATA_BUS_1_BEAT_DWS[9:0]) ? 3'd1 : 3'd0))))));

 end else if (iosf_cmd_data_vld_q & (|iosf_cmd_data_cnt_q)) begin

  iosf_cmd_data_vld_next = '1;

  iosf_cmd_data_cnt_next = iosf_cmd_data_cnt_q - 3'd1;

 end

end

always_ff @(posedge prim_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  iosf_cmd_put_q      <= '0;
  iosf_cmd_data_vld_q <= '0;
  iosf_cmd_data_cnt_q <= '0;
 end else begin
  iosf_cmd_put_q      <= cmd_put;
  iosf_cmd_data_vld_q <= iosf_cmd_data_vld_next;
  iosf_cmd_data_cnt_q <= iosf_cmd_data_cnt_next;
 end
end

always_ff @(posedge prim_clk) begin
 iosf_cmd_rtype_q       <= hqm_sfi_fc_id_t'(cmd_rtype);
 iosf_cmd_chid_q        <= cmd_chid;
 iosf_cmd_hdr_q         <= iosf_cmd_hdr_next;
 if (iosf_cmd_put_q) begin
  iosf_cmd_data_rtype_q <= iosf_cmd_rtype_q;
  iosf_cmd_data_chid_q  <= iosf_cmd_chid_q;
 end
 if (iosf_cmd_data_vld_next) begin
  iosf_cmd_data_q       <= iosf_cmd_data_next;
 end
end

//-----------------------------------------------------------------------------------------------------
// IOSF Target Queues (IOSF Target -> Bridge -> SFI Master)

localparam int unsigned HQM_TXQ_PH_FIFO_DEPTH         = 16;
localparam int unsigned HQM_TXQ_PD_FIFO_DEPTH         = 16;
localparam int unsigned HQM_TXQ_NPH_FIFO_DEPTH        = 8;
localparam int unsigned HQM_TXQ_NPD_FIFO_DEPTH        = 8;
localparam int unsigned HQM_TXQ_CPLH_FIFO_DEPTH       = 32;
localparam int unsigned HQM_TXQ_CPLD_FIFO_DEPTH       = 32;
localparam int unsigned HQM_TXQ_IOQ_FIFO_DEPTH        = 64;       // >= P + NP + CPL depth

localparam int unsigned HQM_TXQ_PH_FIFO_ADDR_WIDTH    = $clog2(HQM_TXQ_PH_FIFO_DEPTH);
localparam int unsigned HQM_TXQ_PD_FIFO_ADDR_WIDTH    = $clog2(HQM_TXQ_PD_FIFO_DEPTH);
localparam int unsigned HQM_TXQ_NPH_FIFO_ADDR_WIDTH   = $clog2(HQM_TXQ_NPH_FIFO_DEPTH);
localparam int unsigned HQM_TXQ_NPD_FIFO_ADDR_WIDTH   = $clog2(HQM_TXQ_NPD_FIFO_DEPTH);
localparam int unsigned HQM_TXQ_CPLH_FIFO_ADDR_WIDTH  = $clog2(HQM_TXQ_CPLH_FIFO_DEPTH);
localparam int unsigned HQM_TXQ_CPLD_FIFO_ADDR_WIDTH  = $clog2(HQM_TXQ_CPLD_FIFO_DEPTH);
localparam int unsigned HQM_TXQ_IOQ_FIFO_ADDR_WIDTH   = $clog2(HQM_TXQ_IOQ_FIFO_DEPTH);

localparam int unsigned HQM_TXQ_PH_FIFO_DATA_WIDTH    = 160;      // 128b hdr  + 1b par + 23b pasid + 8b sai
localparam int unsigned HQM_TXQ_PD_FIFO_DATA_WIDTH    = IOSF_DP_WIDTH;
localparam int unsigned HQM_TXQ_NPH_FIFO_DATA_WIDTH   = 160;      // 128b hdr  + 1b par + 23b pasid + 8b sai
localparam int unsigned HQM_TXQ_NPD_FIFO_DATA_WIDTH   = IOSF_DP_WIDTH;
localparam int unsigned HQM_TXQ_CPLH_FIFO_DATA_WIDTH  = 160;      // 128b hdr  + 1b par + 23b pasid + 8b sai
localparam int unsigned HQM_TXQ_CPLD_FIFO_DATA_WIDTH  = IOSF_DP_WIDTH;
localparam int unsigned HQM_TXQ_IOQ_FIFO_DATA_WIDTH   = $bits(hqm_sfi_fc_id_t);

logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_ph_fifo_push;
hqm_iosf_hdr_t [HQM_SFI_RX_HDR_NUM_VCS-1:0]                             txq_ph_fifo_push_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_ph_fifo_pop;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_ph_fifo_pop_data_v;
hqm_iosf_hdr_t [HQM_SFI_RX_HDR_NUM_VCS-1:0]                             txq_ph_fifo_pop_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][31:0]                                txq_ph_fifo_status;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_ph_fifo_mem_we;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PH_FIFO_ADDR_WIDTH-1:0]      txq_ph_fifo_mem_waddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PH_FIFO_DATA_WIDTH-1:0]      txq_ph_fifo_mem_wdata;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_ph_fifo_mem_re;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PH_FIFO_ADDR_WIDTH-1:0]      txq_ph_fifo_mem_raddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PH_FIFO_DATA_WIDTH-1:0]      txq_ph_fifo_mem_rdata;
logic [HQM_TXQ_PH_FIFO_DATA_WIDTH-1:0]                                  txq_ph_fifo_mem[HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PH_FIFO_DEPTH-1:0];

logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_pd_fifo_push;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PD_FIFO_DATA_WIDTH-1:0]      txq_pd_fifo_push_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_pd_fifo_pop;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_pd_fifo_pop_data_v;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PD_FIFO_DATA_WIDTH-1:0]      txq_pd_fifo_pop_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][31:0]                                txq_pd_fifo_status;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_pd_fifo_mem_we;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PD_FIFO_ADDR_WIDTH-1:0]      txq_pd_fifo_mem_waddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PD_FIFO_DATA_WIDTH-1:0]      txq_pd_fifo_mem_wdata;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_pd_fifo_mem_re;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PD_FIFO_ADDR_WIDTH-1:0]      txq_pd_fifo_mem_raddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PD_FIFO_DATA_WIDTH-1:0]      txq_pd_fifo_mem_rdata;
logic [HQM_TXQ_PD_FIFO_DATA_WIDTH-1:0]                                  txq_pd_fifo_mem[HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_PD_FIFO_DEPTH-1:0];

logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_nph_fifo_push;
hqm_iosf_hdr_t [HQM_SFI_RX_HDR_NUM_VCS-1:0]                             txq_nph_fifo_push_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_nph_fifo_pop;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_nph_fifo_pop_data_v;
hqm_iosf_hdr_t [HQM_SFI_RX_HDR_NUM_VCS-1:0]                             txq_nph_fifo_pop_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][31:0]                                txq_nph_fifo_status;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_nph_fifo_mem_we;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPH_FIFO_ADDR_WIDTH-1:0]     txq_nph_fifo_mem_waddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPH_FIFO_DATA_WIDTH-1:0]     txq_nph_fifo_mem_wdata;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_nph_fifo_mem_re;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPH_FIFO_ADDR_WIDTH-1:0]     txq_nph_fifo_mem_raddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPH_FIFO_DATA_WIDTH-1:0]     txq_nph_fifo_mem_rdata;
logic [HQM_TXQ_NPH_FIFO_DATA_WIDTH-1:0]                                 txq_nph_fifo_mem[HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPH_FIFO_DEPTH-1:0];

logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_npd_fifo_push;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPD_FIFO_DATA_WIDTH-1:0]     txq_npd_fifo_push_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_npd_fifo_pop;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_npd_fifo_pop_data_v;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPD_FIFO_DATA_WIDTH-1:0]     txq_npd_fifo_pop_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][31:0]                                txq_npd_fifo_status;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_npd_fifo_mem_we;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPD_FIFO_ADDR_WIDTH-1:0]     txq_npd_fifo_mem_waddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPD_FIFO_DATA_WIDTH-1:0]     txq_npd_fifo_mem_wdata;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_npd_fifo_mem_re;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPD_FIFO_ADDR_WIDTH-1:0]     txq_npd_fifo_mem_raddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPD_FIFO_DATA_WIDTH-1:0]     txq_npd_fifo_mem_rdata;
logic [HQM_TXQ_NPD_FIFO_DATA_WIDTH-1:0]                                 txq_npd_fifo_mem[HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_NPD_FIFO_DEPTH-1:0];

logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_cplh_fifo_push;
hqm_iosf_hdr_t [HQM_SFI_RX_HDR_NUM_VCS-1:0]                             txq_cplh_fifo_push_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_cplh_fifo_pop;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_cplh_fifo_pop_data_v;
hqm_iosf_hdr_t [HQM_SFI_RX_HDR_NUM_VCS-1:0]                             txq_cplh_fifo_pop_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][31:0]                                txq_cplh_fifo_status;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_cplh_fifo_mem_we;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLH_FIFO_ADDR_WIDTH-1:0]    txq_cplh_fifo_mem_waddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLH_FIFO_DATA_WIDTH-1:0]    txq_cplh_fifo_mem_wdata;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_cplh_fifo_mem_re;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLH_FIFO_ADDR_WIDTH-1:0]    txq_cplh_fifo_mem_raddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLH_FIFO_DATA_WIDTH-1:0]    txq_cplh_fifo_mem_rdata;
logic [HQM_TXQ_CPLH_FIFO_DATA_WIDTH-1:0]                                txq_cplh_fifo_mem[HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLH_FIFO_DEPTH-1:0];

logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_cpld_fifo_push;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLD_FIFO_DATA_WIDTH-1:0]    txq_cpld_fifo_push_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_cpld_fifo_pop;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_cpld_fifo_pop_data_v;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLD_FIFO_DATA_WIDTH-1:0]    txq_cpld_fifo_pop_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][31:0]                                txq_cpld_fifo_status;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_cpld_fifo_mem_we;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLD_FIFO_ADDR_WIDTH-1:0]    txq_cpld_fifo_mem_waddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLD_FIFO_DATA_WIDTH-1:0]    txq_cpld_fifo_mem_wdata;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_cpld_fifo_mem_re;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLD_FIFO_ADDR_WIDTH-1:0]    txq_cpld_fifo_mem_raddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLD_FIFO_DATA_WIDTH-1:0]    txq_cpld_fifo_mem_rdata;
logic [HQM_TXQ_CPLD_FIFO_DATA_WIDTH-1:0]                                txq_cpld_fifo_mem[HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_CPLD_FIFO_DEPTH-1:0];

logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_ioq_fifo_push;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_IOQ_FIFO_DATA_WIDTH-1:0]     txq_ioq_fifo_push_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_ioq_fifo_pop;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_ioq_fifo_pop_data_v;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_IOQ_FIFO_DATA_WIDTH-1:0]     txq_ioq_fifo_pop_data;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][31:0]                                txq_ioq_fifo_status;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_ioq_fifo_mem_we;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_IOQ_FIFO_ADDR_WIDTH-1:0]     txq_ioq_fifo_mem_waddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_IOQ_FIFO_DATA_WIDTH-1:0]     txq_ioq_fifo_mem_wdata;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0]                                      txq_ioq_fifo_mem_re;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_IOQ_FIFO_ADDR_WIDTH-1:0]     txq_ioq_fifo_mem_raddr;
logic [HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_IOQ_FIFO_DATA_WIDTH-1:0]     txq_ioq_fifo_mem_rdata;
logic [HQM_TXQ_IOQ_FIFO_DATA_WIDTH-1:0]                                 txq_ioq_fifo_mem[HQM_SFI_RX_HDR_NUM_VCS-1:0][HQM_TXQ_IOQ_FIFO_DEPTH-1:0];

//-----------------------------------------------------------------------------------------------------

generate
 for (genvar vc=0; vc<HQM_SFI_RX_HDR_NUM_VCS; vc=vc+1) begin: g_vc_txq

  always_comb begin

   txq_ph_fifo_push[       vc] = iosf_cmd_put_q & (iosf_cmd_chid_q == vc) & (iosf_cmd_rtype_q == 2'd0);
   txq_nph_fifo_push[      vc] = iosf_cmd_put_q & (iosf_cmd_chid_q == vc) & (iosf_cmd_rtype_q == 2'd1);
   txq_cplh_fifo_push[     vc] = iosf_cmd_put_q & (iosf_cmd_chid_q == vc) & (iosf_cmd_rtype_q == 2'd2);

   txq_pd_fifo_push[       vc] = iosf_cmd_data_vld_q & (iosf_cmd_data_chid_q == vc) & (iosf_cmd_data_rtype_q == 2'd0);
   txq_npd_fifo_push[      vc] = iosf_cmd_data_vld_q & (iosf_cmd_data_chid_q == vc) & (iosf_cmd_data_rtype_q == 2'd1);
   txq_cpld_fifo_push[     vc] = iosf_cmd_data_vld_q & (iosf_cmd_data_chid_q == vc) & (iosf_cmd_data_rtype_q == 2'd2);

   txq_ioq_fifo_push[      vc] = iosf_cmd_put_q & (iosf_cmd_chid_q == vc);

   txq_ph_fifo_push_data[  vc] = iosf_cmd_hdr_q;
   txq_nph_fifo_push_data[ vc] = iosf_cmd_hdr_q;

   // Handle IOSF header signal to DW swizzling for completions

   txq_cplh_fifo_push_data[vc].cpl.sai        =  iosf_cmd_hdr_q.mem.sai;
   txq_cplh_fifo_push_data[vc].cpl.pasidtlp   =  iosf_cmd_hdr_q.mem.pasidtlp;
   txq_cplh_fifo_push_data[vc].cpl.parity     =  iosf_cmd_hdr_q.mem.parity;
   txq_cplh_fifo_push_data[vc].cpl.fmt        =  iosf_cmd_hdr_q.mem.fmt;
   txq_cplh_fifo_push_data[vc].cpl.ttype      =  iosf_cmd_hdr_q.mem.ttype;
   txq_cplh_fifo_push_data[vc].cpl.tag9       =  iosf_cmd_hdr_q.mem.tag9;
   txq_cplh_fifo_push_data[vc].cpl.tc         =  iosf_cmd_hdr_q.mem.tc;
   txq_cplh_fifo_push_data[vc].cpl.tag8       =  iosf_cmd_hdr_q.mem.tag8;
   txq_cplh_fifo_push_data[vc].cpl.ido        =  iosf_cmd_hdr_q.mem.ido;
   txq_cplh_fifo_push_data[vc].cpl.rsvd1_1    =  iosf_cmd_hdr_q.mem.rsvd1_1;
   txq_cplh_fifo_push_data[vc].cpl.th         =  iosf_cmd_hdr_q.mem.th;
   txq_cplh_fifo_push_data[vc].cpl.td         =  iosf_cmd_hdr_q.mem.td;
   txq_cplh_fifo_push_data[vc].cpl.ep         =  iosf_cmd_hdr_q.mem.ep;
   txq_cplh_fifo_push_data[vc].cpl.ro         =  iosf_cmd_hdr_q.mem.ro;
   txq_cplh_fifo_push_data[vc].cpl.ns         =  iosf_cmd_hdr_q.mem.ns;
   txq_cplh_fifo_push_data[vc].cpl.at         =  iosf_cmd_hdr_q.mem.at;
   txq_cplh_fifo_push_data[vc].cpl.length     =  iosf_cmd_hdr_q.mem.length;
   txq_cplh_fifo_push_data[vc].cpl.cplid      =  iosf_cmd_hdr_q.mem.address[31:16];
   txq_cplh_fifo_push_data[vc].cpl.cpl_status =  hqm_sfi_cpl_status_t'(iosf_cmd_hdr_q.mem.fbe[2:0]);
   txq_cplh_fifo_push_data[vc].cpl.bcm        =  iosf_cmd_hdr_q.mem.fbe[3];
   txq_cplh_fifo_push_data[vc].cpl.bc         = {iosf_cmd_hdr_q.mem.address[15:8]
                                                ,iosf_cmd_hdr_q.mem.lbe[3:0]
                                                };
   txq_cplh_fifo_push_data[vc].cpl.rsvd63_32  =  '0;
   txq_cplh_fifo_push_data[vc].cpl.reqid      =  iosf_cmd_hdr_q.mem.reqid[15:0];
   txq_cplh_fifo_push_data[vc].cpl.tag        =  iosf_cmd_hdr_q.mem.tag[7:0];
   txq_cplh_fifo_push_data[vc].cpl.rsvd7      =  iosf_cmd_hdr_q.mem.address[7];
   txq_cplh_fifo_push_data[vc].cpl.laddr      =  iosf_cmd_hdr_q.mem.address[6:0];

   txq_pd_fifo_push_data[  vc] = iosf_cmd_data_q;
   txq_npd_fifo_push_data[ vc] = iosf_cmd_data_q;
   txq_cpld_fifo_push_data[vc] = iosf_cmd_data_q;

   txq_ioq_fifo_push_data[ vc] = iosf_cmd_rtype_q;

  end

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_TXQ_PH_FIFO_DEPTH)
    ,.DWIDTH                (HQM_TXQ_PH_FIFO_DATA_WIDTH)

  ) i_txq_ph (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (txq_ph_fifo_push[vc])
    ,.push_data             (txq_ph_fifo_push_data[vc])
    ,.pop                   (txq_ph_fifo_pop[vc])
    ,.pop_data_v            (txq_ph_fifo_pop_data_v[vc])
    ,.pop_data              (txq_ph_fifo_pop_data[vc])

    ,.mem_we                (txq_ph_fifo_mem_we[vc])
    ,.mem_waddr             (txq_ph_fifo_mem_waddr[vc])
    ,.mem_wdata             (txq_ph_fifo_mem_wdata[vc])
    ,.mem_re                (txq_ph_fifo_mem_re[vc])
    ,.mem_raddr             (txq_ph_fifo_mem_raddr[vc])
    ,.mem_rdata             (txq_ph_fifo_mem_rdata[vc])

    ,.fifo_status           (txq_ph_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_TXQ_PD_FIFO_DEPTH)
    ,.DWIDTH                (HQM_TXQ_PD_FIFO_DATA_WIDTH)

  ) i_txq_pd (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (txq_pd_fifo_push[vc])
    ,.push_data             (txq_pd_fifo_push_data[vc])
    ,.pop                   (txq_pd_fifo_pop[vc])
    ,.pop_data_v            (txq_pd_fifo_pop_data_v[vc])
    ,.pop_data              (txq_pd_fifo_pop_data[vc])

    ,.mem_we                (txq_pd_fifo_mem_we[vc])
    ,.mem_waddr             (txq_pd_fifo_mem_waddr[vc])
    ,.mem_wdata             (txq_pd_fifo_mem_wdata[vc])
    ,.mem_re                (txq_pd_fifo_mem_re[vc])
    ,.mem_raddr             (txq_pd_fifo_mem_raddr[vc])
    ,.mem_rdata             (txq_pd_fifo_mem_rdata[vc])

    ,.fifo_status           (txq_pd_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_TXQ_NPH_FIFO_DEPTH)
    ,.DWIDTH                (HQM_TXQ_NPH_FIFO_DATA_WIDTH)

  ) i_txq_nph (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (txq_nph_fifo_push[vc])
    ,.push_data             (txq_nph_fifo_push_data[vc])
    ,.pop                   (txq_nph_fifo_pop[vc])
    ,.pop_data_v            (txq_nph_fifo_pop_data_v[vc])
    ,.pop_data              (txq_nph_fifo_pop_data[vc])

    ,.mem_we                (txq_nph_fifo_mem_we[vc])
    ,.mem_waddr             (txq_nph_fifo_mem_waddr[vc])
    ,.mem_wdata             (txq_nph_fifo_mem_wdata[vc])
    ,.mem_re                (txq_nph_fifo_mem_re[vc])
    ,.mem_raddr             (txq_nph_fifo_mem_raddr[vc])
    ,.mem_rdata             (txq_nph_fifo_mem_rdata[vc])

    ,.fifo_status           (txq_nph_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_TXQ_NPD_FIFO_DEPTH)
    ,.DWIDTH                (HQM_TXQ_NPD_FIFO_DATA_WIDTH)

  ) i_txq_npd (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (txq_npd_fifo_push[vc])
    ,.push_data             (txq_npd_fifo_push_data[vc])
    ,.pop                   (txq_npd_fifo_pop[vc])
    ,.pop_data_v            (txq_npd_fifo_pop_data_v[vc])
    ,.pop_data              (txq_npd_fifo_pop_data[vc])

    ,.mem_we                (txq_npd_fifo_mem_we[vc])
    ,.mem_waddr             (txq_npd_fifo_mem_waddr[vc])
    ,.mem_wdata             (txq_npd_fifo_mem_wdata[vc])
    ,.mem_re                (txq_npd_fifo_mem_re[vc])
    ,.mem_raddr             (txq_npd_fifo_mem_raddr[vc])
    ,.mem_rdata             (txq_npd_fifo_mem_rdata[vc])

    ,.fifo_status           (txq_npd_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_TXQ_CPLH_FIFO_DEPTH)
    ,.DWIDTH                (HQM_TXQ_CPLH_FIFO_DATA_WIDTH)

  ) i_txq_cplh (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (txq_cplh_fifo_push[vc])
    ,.push_data             (txq_cplh_fifo_push_data[vc])
    ,.pop                   (txq_cplh_fifo_pop[vc])
    ,.pop_data_v            (txq_cplh_fifo_pop_data_v[vc])
    ,.pop_data              (txq_cplh_fifo_pop_data[vc])

    ,.mem_we                (txq_cplh_fifo_mem_we[vc])
    ,.mem_waddr             (txq_cplh_fifo_mem_waddr[vc])
    ,.mem_wdata             (txq_cplh_fifo_mem_wdata[vc])
    ,.mem_re                (txq_cplh_fifo_mem_re[vc])
    ,.mem_raddr             (txq_cplh_fifo_mem_raddr[vc])
    ,.mem_rdata             (txq_cplh_fifo_mem_rdata[vc])

    ,.fifo_status           (txq_cplh_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_TXQ_CPLD_FIFO_DEPTH)
    ,.DWIDTH                (HQM_TXQ_CPLD_FIFO_DATA_WIDTH)

  ) i_txq_cpld (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (txq_cpld_fifo_push[vc])
    ,.push_data             (txq_cpld_fifo_push_data[vc])
    ,.pop                   (txq_cpld_fifo_pop[vc])
    ,.pop_data_v            (txq_cpld_fifo_pop_data_v[vc])
    ,.pop_data              (txq_cpld_fifo_pop_data[vc])

    ,.mem_we                (txq_cpld_fifo_mem_we[vc])
    ,.mem_waddr             (txq_cpld_fifo_mem_waddr[vc])
    ,.mem_wdata             (txq_cpld_fifo_mem_wdata[vc])
    ,.mem_re                (txq_cpld_fifo_mem_re[vc])
    ,.mem_raddr             (txq_cpld_fifo_mem_raddr[vc])
    ,.mem_rdata             (txq_cpld_fifo_mem_rdata[vc])

    ,.fifo_status           (txq_cpld_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_TXQ_IOQ_FIFO_DEPTH)
    ,.DWIDTH                (HQM_TXQ_IOQ_FIFO_DATA_WIDTH)

  ) i_txq_ioq (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (txq_ioq_fifo_push[vc])
    ,.push_data             (txq_ioq_fifo_push_data[vc])
    ,.pop                   (txq_ioq_fifo_pop[vc])
    ,.pop_data_v            (txq_ioq_fifo_pop_data_v[vc])
    ,.pop_data              (txq_ioq_fifo_pop_data[vc])

    ,.mem_we                (txq_ioq_fifo_mem_we[vc])
    ,.mem_waddr             (txq_ioq_fifo_mem_waddr[vc])
    ,.mem_wdata             (txq_ioq_fifo_mem_wdata[vc])
    ,.mem_re                (txq_ioq_fifo_mem_re[vc])
    ,.mem_raddr             (txq_ioq_fifo_mem_raddr[vc])
    ,.mem_rdata             (txq_ioq_fifo_mem_rdata[vc])

    ,.fifo_status           (txq_ioq_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  always_ff @(posedge prim_clk) begin

   if (  txq_ph_fifo_mem_re[vc])   txq_ph_fifo_mem_rdata[vc] <=   txq_ph_fifo_mem[vc][  txq_ph_fifo_mem_raddr[vc]];
   if (  txq_pd_fifo_mem_re[vc])   txq_pd_fifo_mem_rdata[vc] <=   txq_pd_fifo_mem[vc][  txq_pd_fifo_mem_raddr[vc]];
   if ( txq_nph_fifo_mem_re[vc])  txq_nph_fifo_mem_rdata[vc] <=  txq_nph_fifo_mem[vc][ txq_nph_fifo_mem_raddr[vc]];
   if ( txq_npd_fifo_mem_re[vc])  txq_npd_fifo_mem_rdata[vc] <=  txq_npd_fifo_mem[vc][ txq_npd_fifo_mem_raddr[vc]];
   if (txq_cplh_fifo_mem_re[vc]) txq_cplh_fifo_mem_rdata[vc] <= txq_cplh_fifo_mem[vc][txq_cplh_fifo_mem_raddr[vc]];
   if (txq_cpld_fifo_mem_re[vc]) txq_cpld_fifo_mem_rdata[vc] <= txq_cpld_fifo_mem[vc][txq_cpld_fifo_mem_raddr[vc]];
   if ( txq_ioq_fifo_mem_re[vc])  txq_ioq_fifo_mem_rdata[vc] <=  txq_ioq_fifo_mem[vc][ txq_ioq_fifo_mem_raddr[vc]];

   if (  txq_ph_fifo_mem_we[vc])   txq_ph_fifo_mem[vc][  txq_ph_fifo_mem_waddr[vc]] <=   txq_ph_fifo_mem_wdata[vc];
   if (  txq_pd_fifo_mem_we[vc])   txq_pd_fifo_mem[vc][  txq_pd_fifo_mem_waddr[vc]] <=   txq_pd_fifo_mem_wdata[vc];
   if ( txq_nph_fifo_mem_we[vc])  txq_nph_fifo_mem[vc][ txq_nph_fifo_mem_waddr[vc]] <=  txq_nph_fifo_mem_wdata[vc];
   if ( txq_npd_fifo_mem_we[vc])  txq_npd_fifo_mem[vc][ txq_npd_fifo_mem_waddr[vc]] <=  txq_npd_fifo_mem_wdata[vc];
   if (txq_cplh_fifo_mem_we[vc]) txq_cplh_fifo_mem[vc][txq_cplh_fifo_mem_waddr[vc]] <= txq_cplh_fifo_mem_wdata[vc];
   if (txq_cpld_fifo_mem_we[vc]) txq_cpld_fifo_mem[vc][txq_cpld_fifo_mem_waddr[vc]] <= txq_cpld_fifo_mem_wdata[vc];
   if ( txq_ioq_fifo_mem_we[vc])  txq_ioq_fifo_mem[vc][ txq_ioq_fifo_mem_waddr[vc]] <=  txq_ioq_fifo_mem_wdata[vc];

  end

 end
endgenerate

//-------------------------------------------------------------------------------------------------
// Arbitrate among the VCs with a valid TXQ transaction

always_comb begin

 // Considering a VC valid for arbitration if the IOQ has a valid entry, and for that flow class
 // the header FIFO has a valid entry (it must) and either the transaction does not include data or
 // the data FIFO also has a valid entry. Need an SFI header credit and enough data credits as well.
 // Does using the IOQ for strict ordering break relaxed ordering model that would allow a CplD with the
 // ro bit set (like an ATS response) getting around an earlier NP transaction?

 // Account for any credits in flight in the master output reg

 for (int vc=0; vc<HQM_SFI_RX_HDR_NUM_VCS; vc=vc+1) begin

  txq_ph_fifo_dcrds[vc]  = (txq_ph_fifo_pop_data[vc].mem.length > 10'd124) ? 'd32 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd120) ? 'd31 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd116) ? 'd30 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd112) ? 'd29 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd108) ? 'd28 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd104) ? 'd27 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd100) ? 'd26 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd96 ) ? 'd25 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd92 ) ? 'd24 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd88 ) ? 'd23 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd84 ) ? 'd22 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd80 ) ? 'd21 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd76 ) ? 'd20 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd72 ) ? 'd19 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd68 ) ? 'd18 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd64 ) ? 'd17 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd60 ) ? 'd16 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd56 ) ? 'd15 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd52 ) ? 'd14 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd48 ) ? 'd13 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd44 ) ? 'd12 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd40 ) ? 'd11 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd36 ) ? 'd10 :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd32 ) ? 'd9  :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd28 ) ? 'd8  :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd24 ) ? 'd7  :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd20 ) ? 'd6  :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd16 ) ? 'd5  :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd12 ) ? 'd4  :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd8  ) ? 'd3  :
                          ((txq_ph_fifo_pop_data[vc].mem.length > 10'd4  ) ? 'd2  :
                                                                             'd1))))))))))))))))))))))))))))));

  txq_nph_fifo_dcrds[vc] = (txq_nph_fifo_pop_data[vc].mem.length > 10'd124) ? 'd32 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd120) ? 'd31 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd116) ? 'd30 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd112) ? 'd29 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd108) ? 'd28 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd104) ? 'd27 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd100) ? 'd26 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd96 ) ? 'd25 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd92 ) ? 'd24 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd88 ) ? 'd23 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd84 ) ? 'd22 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd80 ) ? 'd21 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd76 ) ? 'd20 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd72 ) ? 'd19 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd68 ) ? 'd18 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd64 ) ? 'd17 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd60 ) ? 'd16 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd56 ) ? 'd15 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd52 ) ? 'd14 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd48 ) ? 'd13 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd44 ) ? 'd12 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd40 ) ? 'd11 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd36 ) ? 'd10 :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd32 ) ? 'd9  :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd28 ) ? 'd8  :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd24 ) ? 'd7  :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd20 ) ? 'd6  :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd16 ) ? 'd5  :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd12 ) ? 'd4  :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd8  ) ? 'd3  :
                          ((txq_nph_fifo_pop_data[vc].mem.length > 10'd4  ) ? 'd2  :
                                                                              'd1))))))))))))))))))))))))))))));

  txq_arb_reqs[vc] = txq_ioq_fifo_pop_data_v[vc] &
   (((txq_ioq_fifo_pop_data[vc] == 2'd0) &          txq_ph_fifo_pop_data_v[vc] & (|tx_hcrds_avail[vc][0]) &
     ((~txq_ph_fifo_pop_data[  vc].mem.fmt[1]) |   (txq_pd_fifo_pop_data_v[vc] & ( tx_dcrds_avail[vc][0] >= txq_ph_fifo_dcrds[vc])))) |
    ((txq_ioq_fifo_pop_data[vc] == 2'd1) &         txq_nph_fifo_pop_data_v[vc] & (|tx_hcrds_avail[vc][1]) &
     ((~txq_nph_fifo_pop_data[ vc].mem.fmt[1]) |  (txq_npd_fifo_pop_data_v[vc] & ( tx_dcrds_avail[vc][1] >= txq_nph_fifo_dcrds[vc])))) |
    ((txq_ioq_fifo_pop_data[vc] == 2'd2) &        txq_cplh_fifo_pop_data_v[vc] & (|tx_hcrds_avail[vc][2]) &
     ((~txq_cplh_fifo_pop_data[vc].mem.fmt[1]) | (txq_cpld_fifo_pop_data_v[vc] & (|tx_dcrds_avail[vc][2])))));

 end // vc

end

hqm_AW_rr_arbiter #(.NUM_REQS(HQM_SFI_RX_HDR_NUM_VCS)) i_txq_arb (

     .clk           (prim_clk)
    ,.rst_n         (prim_gated_rst_b)

    ,.mode          (2'd2)
    ,.update        (txq_arb_update)

    ,.reqs          (txq_arb_reqs)

    ,.winner_v      (txq_arb_v)
    ,.winner        (txq_arb_vc)
);

always_comb begin

 // Fields for the TXQ arbitration winner (or saved winner)

 txq_arb_fc = hqm_sfi_fc_id_t'(txq_ioq_fifo_pop_data[txq_arb_vc]);

 txq_fc     = (txq_sm_use_saved) ? agent_tx_fc_q : txq_arb_fc;
 txq_vc     = (txq_sm_use_saved) ? agent_tx_vc_q : txq_arb_vc;

 case (txq_fc)

  2'd2: begin
         txq_arb_hdr                     = txq_cplh_fifo_pop_data[txq_vc];
        {txq_arb_iosf_par, txq_arb_data} = txq_cpld_fifo_pop_data[txq_vc];
  end
  2'd1: begin
         txq_arb_hdr                     = txq_nph_fifo_pop_data[txq_vc];
        {txq_arb_iosf_par, txq_arb_data} = txq_npd_fifo_pop_data[txq_vc];
  end
  default: begin
         txq_arb_hdr                     = txq_ph_fifo_pop_data[txq_vc];
        {txq_arb_iosf_par, txq_arb_data} = txq_pd_fifo_pop_data[txq_vc];
  end

 endcase

 // Length is in DWs (4B) and data credits are in 16B quantities.
 // Max of 512B or 128 DWs or 32 data credits

 txq_arb_data_crds = '0;

 if (txq_arb_hdr.mem.fmt[1]) begin

  txq_arb_data_crds = (txq_arb_hdr.mem.length > 10'd124) ? 6'd32 :
                     ((txq_arb_hdr.mem.length > 10'd120) ? 6'd31 :
                     ((txq_arb_hdr.mem.length > 10'd116) ? 6'd30 :
                     ((txq_arb_hdr.mem.length > 10'd112) ? 6'd29 :
                     ((txq_arb_hdr.mem.length > 10'd108) ? 6'd28 :
                     ((txq_arb_hdr.mem.length > 10'd104) ? 6'd27 :
                     ((txq_arb_hdr.mem.length > 10'd100) ? 6'd26 :
                     ((txq_arb_hdr.mem.length > 10'd96 ) ? 6'd25 :
                     ((txq_arb_hdr.mem.length > 10'd92 ) ? 6'd24 :
                     ((txq_arb_hdr.mem.length > 10'd88 ) ? 6'd23 :
                     ((txq_arb_hdr.mem.length > 10'd84 ) ? 6'd22 :
                     ((txq_arb_hdr.mem.length > 10'd80 ) ? 6'd21 :
                     ((txq_arb_hdr.mem.length > 10'd76 ) ? 6'd20 :
                     ((txq_arb_hdr.mem.length > 10'd72 ) ? 6'd19 :
                     ((txq_arb_hdr.mem.length > 10'd68 ) ? 6'd18 :
                     ((txq_arb_hdr.mem.length > 10'd64 ) ? 6'd17 :
                     ((txq_arb_hdr.mem.length > 10'd60 ) ? 6'd16 :
                     ((txq_arb_hdr.mem.length > 10'd56 ) ? 6'd15 :
                     ((txq_arb_hdr.mem.length > 10'd52 ) ? 6'd14 :
                     ((txq_arb_hdr.mem.length > 10'd48 ) ? 6'd13 :
                     ((txq_arb_hdr.mem.length > 10'd44 ) ? 6'd12 :
                     ((txq_arb_hdr.mem.length > 10'd40 ) ? 6'd11 :
                     ((txq_arb_hdr.mem.length > 10'd36 ) ? 6'd10 :
                     ((txq_arb_hdr.mem.length > 10'd32 ) ? 6'd9  :
                     ((txq_arb_hdr.mem.length > 10'd28 ) ? 6'd8  :
                     ((txq_arb_hdr.mem.length > 10'd24 ) ? 6'd7  :
                     ((txq_arb_hdr.mem.length > 10'd20 ) ? 6'd6  :
                     ((txq_arb_hdr.mem.length > 10'd16 ) ? 6'd5  :
                     ((txq_arb_hdr.mem.length > 10'd12 ) ? 6'd4  :
                     ((txq_arb_hdr.mem.length > 10'd8  ) ? 6'd3  :
                     ((txq_arb_hdr.mem.length > 10'd4  ) ? 6'd2  :
                                                           6'd1))))))))))))))))))))))))))))));

 end

 // IOSF has a single data parity bit while SFI has 1 bit per 2 DWs
 // TBD: Need to check parity here before regen and poison if bad parity

 for (int i=0; i<((HQM_SFI_RX_D*8)>>6); i=i+1) begin

  txq_arb_data_par[i] = (^txq_arb_data[(64*i) +: 64]);

 end

end

//-------------------------------------------------------------------------------------------------
// Convert IOSF header to SFI header

always_comb begin

 txq_pcie_cmd         = hqm_sfi_pcie_cmd_t'({txq_arb_hdr.mem.fmt[1:0], txq_arb_hdr.mem.ttype});

 txq_sfi_hdr_size     = '0;
 txq_sfi_hdr_has_data = '0;
 txq_sfi_hdr          = '0;
 txq_sfi_hdr_par      = '0;

 case (txq_pcie_cmd)

  PCIE_CMD_MRD32,
  PCIE_CMD_MWR32: begin // 4DW MMIO read/write

   txq_sfi_hdr.mem32.ohc_dw3         = '0;
   txq_sfi_hdr.mem32.ohc_dw2         = '0;
   txq_sfi_hdr.mem32.ohc_dw1         = '0;
   txq_sfi_hdr.mem32.ohc_dw0         = '0;

   txq_sfi_hdr.mem32.address31_2     = txq_arb_hdr.mem.address[31:2];
   txq_sfi_hdr.mem32.at              = txq_arb_hdr.mem.at;

   txq_sfi_hdr.mem32.reqid           = txq_arb_hdr.mem.reqid;
   txq_sfi_hdr.mem32.ep              = txq_arb_hdr.mem.ep;
   txq_sfi_hdr.mem32.rsvd78          = '0;
   txq_sfi_hdr.mem32.tag             = {4'd0, txq_arb_hdr.mem.tag9, txq_arb_hdr.mem.tag8, txq_arb_hdr.mem.tag};

   txq_sfi_hdr.mem32.ttype           = (txq_pcie_cmd == PCIE_CMD_MRD32) ? FLIT_CMD_MRD32 : FLIT_CMD_MWR32;
   txq_sfi_hdr.mem32.tc2_0           = txq_arb_hdr.mem.tc[2:0];
   txq_sfi_hdr.mem32.ohc             = ohc_none;
   txq_sfi_hdr.mem32.ts              = hqm_sfi_ts_t'('0);
   txq_sfi_hdr.mem32.attr            = {txq_arb_hdr.mem.ido, txq_arb_hdr.mem.ro, txq_arb_hdr.mem.ns};
   txq_sfi_hdr.mem32.len             = txq_arb_hdr.mem.length;

   txq_sfi_hdr.mem32.pf0.srcid       = '0;
   txq_sfi_hdr.mem32.pf0.sai         = txq_arb_hdr.mem.sai;
   txq_sfi_hdr.mem32.pf0.bcm         = '0;
   txq_sfi_hdr.mem32.pf0.rs          = '0;
   txq_sfi_hdr.mem32.pf0.ee          = '0;
   txq_sfi_hdr.mem32.pf0.n           = '0;
   txq_sfi_hdr.mem32.pf0.c           = '0;
   txq_sfi_hdr.mem32.pf0.prefix_type = 8'h8e;

   txq_sfi_hdr_size                  = 4'd4;
   txq_sfi_hdr_has_data              = (txq_pcie_cmd == PCIE_CMD_MWR32);

   // SFI header parity is on the entire header and hdr_info_bytes fields. The hdr_info_bytes bits are:
   //
   //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
   //
   // We transfer all bits from the IOSF header format except for the following, so the IOSF
   // header parity must be adjusted by the following to create the SFI header parity:
   //
   //       Need to account for replacing IOSF {fmt[1:0], type[4:0]} with SFI {type[7:0]}
   //       We do not pass the rsvd1_1, th, td, or address[1:0] bits.
   //       For MMIO transactions, we always expect the lbe/fbe to be all 0s/1s, so they
   //       should not contribute.
   //       Need to account for the sai since it is not included in the IOSF parity.
   //       The has_data bit will only be set for memory writes.
   //       The shared_credit field will always be 0 so it does not contribute.
   //       The hdr_size field needs to be taken into account.
   //       Need to account for the vc and fc.

   txq_sfi_hdr_par           = ^{ txq_arb_hdr.mem.parity
                                , txq_arb_hdr.mem.fmt
                                , txq_arb_hdr.mem.ttype
                                , txq_arb_hdr.mem.rsvd1_1
                                , txq_arb_hdr.mem.th
                                , txq_arb_hdr.mem.td
                                , txq_arb_hdr.mem.lbe
                                , txq_arb_hdr.mem.fbe
                                , txq_arb_hdr.mem.address[1:0]
                                , txq_arb_hdr.mem.sai
                                , txq_arb_hdr.mem.tc[3]
                                , txq_sfi_hdr.mem32.ttype
                                , txq_sfi_hdr_size
                                , txq_sfi_hdr_has_data
                                , txq_vc
                                , txq_fc
                                };

  end // 4DW MMIO read/Write

  PCIE_CMD_MRD64,
  PCIE_CMD_MWR64: begin // 5DW MMIO read/write

   txq_sfi_hdr.mem64.ohc_dw2         = '0;
   txq_sfi_hdr.mem64.ohc_dw1         = '0;
   txq_sfi_hdr.mem64.ohc_dw0         = '0;

   txq_sfi_hdr.mem64.address63_32    = txq_arb_hdr.mem.address[63:32];

   txq_sfi_hdr.mem64.address31_2     = txq_arb_hdr.mem.address[31:2];
   txq_sfi_hdr.mem64.at              = txq_arb_hdr.mem.at;

   txq_sfi_hdr.mem64.reqid           = txq_arb_hdr.mem.reqid;
   txq_sfi_hdr.mem64.ep              = txq_arb_hdr.mem.ep;
   txq_sfi_hdr.mem64.rsvd78          = '0;
   txq_sfi_hdr.mem64.tag             = {4'd0, txq_arb_hdr.mem.tag9, txq_arb_hdr.mem.tag8, txq_arb_hdr.mem.tag};

   txq_sfi_hdr.mem64.ttype           = (txq_pcie_cmd == PCIE_CMD_MRD64) ? FLIT_CMD_MRD64 : FLIT_CMD_MWR64;
   txq_sfi_hdr.mem64.tc2_0           = txq_arb_hdr.mem.tc[2:0];
   txq_sfi_hdr.mem64.ohc             = ohc_none;
   txq_sfi_hdr.mem64.ts              = hqm_sfi_ts_t'('0);
   txq_sfi_hdr.mem64.attr            = {txq_arb_hdr.mem.ido, txq_arb_hdr.mem.ro, txq_arb_hdr.mem.ns};
   txq_sfi_hdr.mem64.len             = txq_arb_hdr.mem.length;

   txq_sfi_hdr.mem64.pf0.srcid       = '0;
   txq_sfi_hdr.mem64.pf0.sai         = txq_arb_hdr.mem.sai;
   txq_sfi_hdr.mem64.pf0.bcm         = '0;
   txq_sfi_hdr.mem64.pf0.rs          = '0;
   txq_sfi_hdr.mem64.pf0.ee          = '0;
   txq_sfi_hdr.mem64.pf0.n           = '0;
   txq_sfi_hdr.mem64.pf0.c           = '0;
   txq_sfi_hdr.mem64.pf0.prefix_type = 8'h8e;

   txq_sfi_hdr_size                  = 4'd5;
   txq_sfi_hdr_has_data              = (txq_pcie_cmd == PCIE_CMD_MWR64);

   // SFI header parity is on the entire header and hdr_info_bytes fields. The hdr_info_bytes bits are:
   //
   //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
   //
   // We transfer all bits from the IOSF header format except for the following, so the IOSF
   // header parity must be adjusted by the following to create the SFI header parity:
   //
   //       Need to account for replacing IOSF {fmt[1:0], type[4:0]} with SFI {type[7:0]}
   //       We do not pass the rsvd1_1, th, td, or address[1:0] bits.
   //       For MMIO transactions, we always expect the lbe/fbe to be all 0s/1s, so they
   //       should not contribute.
   //       Need to account for the sai since it is not included in the IOSF parity.
   //       The has_data bit will only be set for memory writes.
   //       The shared_credit field will always be 0 so it does not contribute.
   //       The hdr_size field will always be 5 so it does not contribute.
   //       Need to account for the vc and fc.

   txq_sfi_hdr_par           = ^{ txq_arb_hdr.mem.parity
                                , txq_arb_hdr.mem.fmt
                                , txq_arb_hdr.mem.ttype
                                , txq_arb_hdr.mem.rsvd1_1
                                , txq_arb_hdr.mem.th
                                , txq_arb_hdr.mem.td
                                , txq_arb_hdr.mem.lbe
                                , txq_arb_hdr.mem.fbe
                                , txq_arb_hdr.mem.address[1:0]
                                , txq_arb_hdr.mem.sai
                                , txq_arb_hdr.mem.tc[3]
                                , txq_sfi_hdr.mem64.ttype
                                , txq_sfi_hdr_has_data
                                , txq_vc
                                , txq_fc
                                };

  end // 5DW MMIO read/Write

  PCIE_CMD_CFGRD0,
  PCIE_CMD_CFGWR0: begin // CFG Read/Write

   // CFGRD/WR require ohca3 for the byte enables

   txq_sfi_hdr.cfg.ohc_dw3         = '0;
   txq_sfi_hdr.cfg.ohc_dw2         = '0;
   txq_sfi_hdr.cfg.ohc_dw1         = '0;

   txq_sfi_hdr.cfg.ohc_dw0         = '0;
   txq_sfi_hdr.cfg.ohc_dw0.a3.lbe  = txq_arb_hdr.cfg.lbe;
   txq_sfi_hdr.cfg.ohc_dw0.a3.fbe  = txq_arb_hdr.cfg.fbe;

   txq_sfi_hdr.cfg.bdf             = txq_arb_hdr.cfg.bdf;
   txq_sfi_hdr.cfg.rsvd111_108     = '0;
   txq_sfi_hdr.cfg.regnum          = txq_arb_hdr.cfg.regnum;
   txq_sfi_hdr.cfg.rsvd97_96       = '0;

   txq_sfi_hdr.cfg.reqid           = txq_arb_hdr.cfg.reqid;
   txq_sfi_hdr.cfg.ep              = txq_arb_hdr.cfg.ep;
   txq_sfi_hdr.cfg.rsvd78          = '0;
   txq_sfi_hdr.cfg.tag             = {4'd0, txq_arb_hdr.cfg.tag9, txq_arb_hdr.cfg.tag8, txq_arb_hdr.cfg.tag};

   txq_sfi_hdr.cfg.ttype           = (txq_pcie_cmd == PCIE_CMD_CFGRD0) ? FLIT_CMD_CFGRD0 : FLIT_CMD_CFGWR0;
   txq_sfi_hdr.cfg.tc2_0           = txq_arb_hdr.cfg.tc[2:0];
   txq_sfi_hdr.cfg.ohc             = ohc_noe_a;
   txq_sfi_hdr.cfg.ts              = hqm_sfi_ts_t'('0);
   txq_sfi_hdr.cfg.attr            = {txq_arb_hdr.cfg.ido, txq_arb_hdr.cfg.ro, txq_arb_hdr.cfg.ns};
   txq_sfi_hdr.cfg.len             = txq_arb_hdr.cfg.length;

   txq_sfi_hdr.cfg.pf0.srcid       = '0;
   txq_sfi_hdr.cfg.pf0.sai         = txq_arb_hdr.cfg.sai;
   txq_sfi_hdr.cfg.pf0.bcm         = '0;
   txq_sfi_hdr.cfg.pf0.rs          = '0;
   txq_sfi_hdr.cfg.pf0.ee          = '0;
   txq_sfi_hdr.cfg.pf0.n           = '0;
   txq_sfi_hdr.cfg.pf0.c           = '0;
   txq_sfi_hdr.cfg.pf0.prefix_type = 8'h8e;

   txq_sfi_hdr_size                = 4'd5;
   txq_sfi_hdr_has_data            = (txq_pcie_cmd == PCIE_CMD_CFGWR0);

   // SFI header parity is on the entire header and hdr_info_bytes fields. The hdr_info_bytes bits are:
   //
   //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
   //
   // We transfer all bits from the IOSF header format except for the following, so the IOSF
   // header parity must be adjusted by the following to create the SFI header parity:
   //
   //       Need to account for replacing IOSF {fmt[1:0], type[4:0]} with SFI {type[7:0]}
   //       Need to account for the sai since it is not included in the IOSF parity.
   //       We do not pass the rsvd1_1, at, th, or td bits.
   //       Need to account for the ohc being set.
   //       The has_data bit will only be set for CFG writes.
   //       The shared_credit field will always be 0 so it does not contribute.
   //       The hdr_size field will always be 5 so it does not contribute.
   //       Need to account for the vc and fc.

   txq_sfi_hdr_par               = ^{ txq_arb_hdr.cfg.parity
                                    , txq_arb_hdr.cfg.fmt
                                    , txq_arb_hdr.cfg.ttype
                                    , txq_arb_hdr.cfg.sai
                                    , txq_arb_hdr.cfg.rsvd1_1
                                    , txq_arb_hdr.cfg.at
                                    , txq_arb_hdr.cfg.th
                                    , txq_arb_hdr.cfg.td
                                    , txq_arb_hdr.cfg.tc[3]
                                    , txq_sfi_hdr.cfg.ttype
                                    , txq_sfi_hdr.cfg.ohc
                                    , txq_sfi_hdr_has_data
                                    , txq_vc
                                    , txq_fc
                                    };

  end // CFG Read/Write

  PCIE_CMD_CPL,
  PCIE_CMD_CPLD: begin // Completions

   txq_sfi_hdr.cpl.ohc_dw3         = '0;
   txq_sfi_hdr.cpl.ohc_dw2         = '0;
   txq_sfi_hdr.cpl.ohc_dw1         = '0;
   txq_sfi_hdr.cpl.ohc_dw0         = '0;

   // ohca5 is only present on Cpl w/ a non-zero completion status

   if (|txq_arb_hdr.cpl.cpl_status) begin

    txq_sfi_hdr.cpl.ohc_dw0.a5.la1_0      = txq_arb_hdr.cpl.laddr[1:0];
    txq_sfi_hdr.cpl.ohc_dw0.a5.cpl_status = txq_arb_hdr.cpl.cpl_status;

    txq_sfi_hdr_size               = 4'd5;

   end else begin

    txq_sfi_hdr_size               = 4'd4;

   end

   txq_sfi_hdr_has_data            = (txq_pcie_cmd == PCIE_CMD_CPLD);

   txq_sfi_hdr.cpl.bdf             = txq_arb_hdr.cpl.reqid;
   txq_sfi_hdr.cpl.la5_2           = txq_arb_hdr.cpl.laddr[5:2];
   txq_sfi_hdr.cpl.bc              = txq_arb_hdr.cpl.bc;

   txq_sfi_hdr.cpl.cplid           = txq_arb_hdr.cpl.cplid;
   txq_sfi_hdr.cpl.ep              = txq_arb_hdr.cpl.ep;
   txq_sfi_hdr.cpl.la6             = txq_arb_hdr.cpl.laddr[6];
   txq_sfi_hdr.cpl.tag             = {4'd0, txq_arb_hdr.cpl.tag9, txq_arb_hdr.cpl.tag8, txq_arb_hdr.cpl.tag};

   txq_sfi_hdr.cpl.ttype           = (txq_pcie_cmd == PCIE_CMD_CPL) ? FLIT_CMD_CPL : FLIT_CMD_CPLD;
   txq_sfi_hdr.cpl.tc2_0           = txq_arb_hdr.cpl.tc[2:0];
   txq_sfi_hdr.cpl.ohc             = (|txq_arb_hdr.cpl.cpl_status) ? ohc_noe_a : ohc_none;
   txq_sfi_hdr.cpl.ts              = hqm_sfi_ts_t'('0);
   txq_sfi_hdr.cpl.attr            = {txq_arb_hdr.cpl.ido, txq_arb_hdr.cpl.ro, txq_arb_hdr.cpl.ns};
   txq_sfi_hdr.cpl.len             = txq_arb_hdr.cpl.length;

   txq_sfi_hdr.cpl.pf0.srcid       = '0;
   txq_sfi_hdr.cpl.pf0.sai         = txq_arb_hdr.cpl.sai;
   txq_sfi_hdr.cpl.pf0.bcm         = txq_arb_hdr.cpl.bcm;
   txq_sfi_hdr.cpl.pf0.rs          = '0;
   txq_sfi_hdr.cpl.pf0.ee          = '0;
   txq_sfi_hdr.cpl.pf0.n           = '0;
   txq_sfi_hdr.cpl.pf0.c           = '0;
   txq_sfi_hdr.cpl.pf0.prefix_type = 8'h8e;

   // SFI header parity is on the entire header and hdr_info_bytes fields. The hdr_info_bytes bits are:
   //
   //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
   //
   // We transfer all bits from the IOSF header format except for the following, so the IOSF
   // header parity must be adjusted by the following to create the SFI header parity:
   //
   //       PASID is not passed.
   //       Need to account for replacing IOSF {fmt[1:0], type[4:0]} with SFI {type[7:0]}
   //       We do not pass the rsvd1_1, rsvd7, at, th, or td bits.
   //       Need to account for the sai since it is not included in the IOSF parity.
   //       Need to account for the ohc possibly being set for a non-zero completion status.
   //       If ohca5 is present, then la[1:0] are present, otherwise they are not.
   //       The has_data bit will only be set for CplD.
   //       The shared_credit field will always be 0 so it does not contribute.
   //       The hdr_size field must be taken into account
   //       Need to account for the vc and fc.

   txq_sfi_hdr_par               = ^{ txq_arb_hdr.cpl.parity
                                    , txq_arb_hdr.cpl.sai
                                    , txq_arb_hdr.cpl.fmt
                                    , txq_arb_hdr.cpl.ttype
                                    , txq_arb_hdr.cpl.rsvd1_1
                                    , txq_arb_hdr.cpl.rsvd7
                                    , txq_arb_hdr.cpl.at
                                    , txq_arb_hdr.cpl.th
                                    , txq_arb_hdr.cpl.td
                                    , txq_arb_hdr.cpl.tc[3]
                                    , txq_sfi_hdr.cpl.ttype
                                    , txq_sfi_hdr.cpl.ohc
                                    , txq_sfi_hdr_size
                                    , txq_sfi_hdr_has_data
                                    ,(txq_arb_hdr.cpl.laddr[1:0] & ~{2{(|txq_arb_hdr.cpl.cpl_status)}})
                                    , txq_vc
                                    , txq_fc
                                    };
  end // Completions

  FLIT_CMD_MSGD2: begin // Invalidate requests

   // Invalidate requests include ohca4 to pass PASID

   txq_sfi_hdr.invreq.ohc_dw2               = '0;
   txq_sfi_hdr.invreq.ohc_dw1               = '0;

   txq_sfi_hdr.invreq.ohc_dw0               = '0;
   txq_sfi_hdr.invreq.ohc_dw0.a4.pv         = txq_arb_hdr.msg.pasidtlp[22];
   txq_sfi_hdr.invreq.ohc_dw0.a4.pmr        = txq_arb_hdr.msg.pasidtlp[21];
   txq_sfi_hdr.invreq.ohc_dw0.a4.rsvd12     = txq_arb_hdr.msg.pasidtlp[20];
   txq_sfi_hdr.invreq.ohc_dw0.a4.pasid19_16 = txq_arb_hdr.msg.pasidtlp[19:16];
   txq_sfi_hdr.invreq.ohc_dw0.a4.pasid15_8  = txq_arb_hdr.msg.pasidtlp[15: 8];
   txq_sfi_hdr.invreq.ohc_dw0.a4.pasid7_0   = txq_arb_hdr.msg.pasidtlp[ 7: 0];

   txq_sfi_hdr.invreq.rsvd159_128           = txq_arb_hdr.msg.rsvd47_0[31:0];

   txq_sfi_hdr.invreq.bdf                   = txq_arb_hdr.msg.bdf;
   txq_sfi_hdr.invreq.rsvd111_96            = txq_arb_hdr.msg.rsvd47_0[47:32];

   txq_sfi_hdr.invreq.reqid                 = txq_arb_hdr.msg.reqid;
   txq_sfi_hdr.invreq.rsvd79_77             = txq_arb_hdr.msg.tag[7:5];
   txq_sfi_hdr.invreq.itag                  = txq_arb_hdr.msg.tag[4:0];
   txq_sfi_hdr.invreq.msg_code              = txq_arb_hdr.msg.msg_code;

   txq_sfi_hdr.invreq.ttype                 = FLIT_CMD_MSGD2;
   txq_sfi_hdr.invreq.tc2_0                 = txq_arb_hdr.msg.tc[2:0];
   txq_sfi_hdr.invreq.ohc                   = ohc_noe_a;
   txq_sfi_hdr.invreq.ts                    = hqm_sfi_ts_t'('0);
   txq_sfi_hdr.invreq.attr                  = {txq_arb_hdr.msg.ido, txq_arb_hdr.msg.ro, txq_arb_hdr.msg.ns};
   txq_sfi_hdr.invreq.len                   = txq_arb_hdr.msg.length;

   txq_sfi_hdr.invreq.pf0.srcid             = '0;
   txq_sfi_hdr.invreq.pf0.sai               = txq_arb_hdr.msg.sai;
   txq_sfi_hdr.invreq.pf0.bcm               = '0;
   txq_sfi_hdr.invreq.pf0.rs                = '0;
   txq_sfi_hdr.invreq.pf0.ee                = '0;
   txq_sfi_hdr.invreq.pf0.n                 = '0;
   txq_sfi_hdr.invreq.pf0.c                 = '0;
   txq_sfi_hdr.invreq.pf0.prefix_type       = 8'h8e;

   txq_sfi_hdr_size                         = 4'd6;
   txq_sfi_hdr_has_data                     = '1;

   // SFI header parity is on the entire header and hdr_info_bytes fields. The hdr_info_bytes bits are:
   //
   //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
   //
   // We transfer all bits from the IOSF header format except for the following, so the IOSF
   // header parity must be adjusted by the following to create the SFI header parity:
   //
   //       Need to account for replacing IOSF {fmt[1:0], type[4:0]} with SFI {type[7:0]}
   //       We do not pass the rsvd1_1, th, td, tag9, or tag8 bits.
   //       Need to account for the sai since it is not included in the IOSF parity.
   //       Need to account for ohc being set.
   //       The has_data bit will always be set
   //       The shared_credit field will always be 0 so it does not contribute.
   //       The hdr_size field will always be 6 so it does not contribute.
   //       Need to account for the vc and fc.

   txq_sfi_hdr_par           = ^{  txq_arb_hdr.msg.parity
                                ,  txq_arb_hdr.msg.fmt
                                ,  txq_arb_hdr.msg.ttype
                                ,  txq_arb_hdr.msg.tag9
                                ,  txq_arb_hdr.msg.tag8
                                ,  txq_arb_hdr.msg.rsvd1_1
                                ,  txq_arb_hdr.msg.th
                                ,  txq_arb_hdr.msg.td
                                ,  txq_arb_hdr.msg.sai
                                ,  txq_arb_hdr.msg.tc[3]
                                ,  txq_sfi_hdr.invreq.ttype
                                ,  txq_sfi_hdr.invreq.ohc
                                ,  txq_sfi_hdr_has_data
                                ,  txq_vc
                                ,  txq_fc
                                };

  end // Invalidate requests

  default: begin

   txq_sfi_hdr     = '0;
   txq_sfi_hdr_par = '0;

  end

 endcase

end

//-------------------------------------------------------------------------------------------------
// TXQ State Machine

always_ff @(posedge prim_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  txq_sm_state_q <= HQM_TXQ_SM_IDLE;
 end else begin
  txq_sm_state_q <= txq_sm_state_next;
 end
end

localparam DATA_1_BEAT_DCRDS = IOSF_DATA_WIDTH>>7;  // 16B * 8b data credit granularity, so width/128b

always_comb begin

 txq_sm_state_next          = txq_sm_state_q;

 txq_sm_use_saved           = '0;

 txq_ph_fifo_pop            = '0;
 txq_pd_fifo_pop            = '0;
 txq_nph_fifo_pop           = '0;
 txq_npd_fifo_pop           = '0;
 txq_cplh_fifo_pop          = '0;
 txq_cpld_fifo_pop          = '0;
 txq_ioq_fifo_pop           = '0;

 txq_arb_update             = '0;

 agent_tx_v_next            = '0;
 agent_tx_vc_next           = agent_tx_vc_q;
 agent_tx_fc_next           = agent_tx_fc_q;
 agent_tx_hdr_size_next     = agent_tx_hdr_size_q;
 agent_tx_hdr_has_data_next = agent_tx_hdr_has_data_q;
 agent_tx_hdr_next          = agent_tx_hdr_q;
 agent_tx_hdr_par_next      = agent_tx_hdr_par_q;
 agent_tx_data_next         = agent_tx_data_q;
 agent_tx_data_par_next     = agent_tx_data_par_q;
 agent_tx_data_cnt_next     = agent_tx_data_cnt_q;

 txq_sm_credit_put          = '0;
 txq_sm_credit_chid         = '0;
 txq_sm_credit_rtype        = hqm_sfi_fc_id_t'('0);
 txq_sm_credit_cmd          = '0;
 txq_sm_credit_data         = '0;

 tx_hcrd_consume_v          = '0;
 tx_hcrd_consume_vc         = txq_arb_vc;
 tx_hcrd_consume_fc         = txq_arb_fc;
 tx_hcrd_consume_val        = '0;

 tx_dcrd_consume_v          = '0;
 tx_dcrd_consume_vc         = txq_arb_vc;
 tx_dcrd_consume_fc         = txq_arb_fc;
 tx_dcrd_consume_val        = '0;

 case (1'b1)

  txq_sm_state_q[HQM_TXQ_SM_IDLE_BIT]: begin

   if (txq_arb_v & ~agent_tx_hold) begin // Arb valid

    if (txq_arb_data_crds <= DATA_1_BEAT_DCRDS[5:0]) begin // <=1 data bus beat

     // If no data or single beat data we can just send it out

     agent_tx_v_next            = '1;
     agent_tx_vc_next           = txq_arb_vc;
     agent_tx_fc_next           = txq_arb_fc;
     agent_tx_hdr_size_next     = txq_sfi_hdr_size;
     agent_tx_hdr_has_data_next = txq_sfi_hdr_has_data;
     agent_tx_hdr_next          = txq_sfi_hdr;
     agent_tx_hdr_par_next      = txq_sfi_hdr_par;

     if (|txq_arb_data_crds) begin
      agent_tx_data_next        = txq_arb_data;
      agent_tx_data_par_next    = txq_arb_data_par;
     end

     // Pop the appropriate FIFOs

     txq_ph_fifo_pop[  txq_arb_vc] = (txq_arb_fc == 2'd0);
     txq_pd_fifo_pop[  txq_arb_vc] = (txq_arb_fc == 2'd0) & (|txq_arb_data_crds);
     txq_nph_fifo_pop[ txq_arb_vc] = (txq_arb_fc == 2'd1);
     txq_npd_fifo_pop[ txq_arb_vc] = (txq_arb_fc == 2'd1) & (|txq_arb_data_crds);
     txq_cplh_fifo_pop[txq_arb_vc] = (txq_arb_fc == 2'd2);
     txq_cpld_fifo_pop[txq_arb_vc] = (txq_arb_fc == 2'd2) & (|txq_arb_data_crds);
     txq_ioq_fifo_pop[ txq_arb_vc] = '1;

     // Update the VC arbiter

     txq_arb_update       = '1;

     // Return the IOSF hdr credit and data credit(s)

     txq_sm_credit_put    = '1;
     txq_sm_credit_chid   = txq_arb_vc;
     txq_sm_credit_rtype  = txq_arb_fc;
     txq_sm_credit_cmd    = '1;
     txq_sm_credit_data   = txq_arb_data_crds[2:0]; // Assuming <= 4 for 64B data bus

     // Consume the SFI header and data credit(s)

     tx_hcrd_consume_v    = '1;
     tx_hcrd_consume_val  = '1;

     tx_dcrd_consume_v    = (|txq_arb_data_crds);
     tx_dcrd_consume_val  = txq_arb_data_crds[2:0]; // Assuming <= 4 for 64B data bus

    end // <=1 data bus beat

    // More than 1 beat of data means we need to save the current data beat and pop
    // the data FIFO to get the next one.

    else begin // >1 data bus beat

     // Multibeat data: send out the header and first data beat

     agent_tx_v_next            = '1;
     agent_tx_vc_next           = txq_arb_vc;
     agent_tx_fc_next           = txq_arb_fc;
     agent_tx_hdr_size_next     = txq_sfi_hdr_size;
     agent_tx_hdr_has_data_next = txq_sfi_hdr_has_data;
     agent_tx_hdr_next          = txq_sfi_hdr;
     agent_tx_hdr_par_next      = txq_sfi_hdr_par;

     agent_tx_data_next         = txq_arb_data;
     agent_tx_data_par_next     = txq_arb_data_par;

     // Save the current winner info (need to in case the arbitration winner changes)

     agent_tx_vc_next           = txq_arb_vc;
     agent_tx_fc_next           = txq_arb_fc;
     agent_tx_hdr_size_next     = txq_sfi_hdr_size;
     agent_tx_hdr_has_data_next = txq_sfi_hdr_has_data;
     agent_tx_hdr_next          = txq_sfi_hdr;
     agent_tx_hdr_par_next      = txq_sfi_hdr_par;
     agent_tx_data_next         = txq_arb_data;
     agent_tx_data_par_next     = txq_arb_data_par;

     // Save the remaining data credit count

     agent_tx_data_cnt_next     = txq_arb_data_crds - DATA_1_BEAT_DCRDS[5:0];

     // Pop the appropriate data FIFO

     txq_pd_fifo_pop[  txq_arb_vc] = (txq_arb_fc == 2'd0);
     txq_npd_fifo_pop[ txq_arb_vc] = (txq_arb_fc == 2'd1);
     txq_cpld_fifo_pop[txq_arb_vc] = (txq_arb_fc == 2'd2);

     // Sequence

     txq_sm_state_next     = HQM_TXQ_SM_BEAT2;

     // Return the IOSF data credits for this beat

     txq_sm_credit_put    = '1;
     txq_sm_credit_chid   = txq_arb_vc;
     txq_sm_credit_rtype  = txq_arb_fc;
     txq_sm_credit_cmd    = '0;                         // Don't return hdr credit yet (haven't popped)
     txq_sm_credit_data   = DATA_1_BEAT_DCRDS[2:0];     // Assuming <= 4 for this 64B data bus beat

     // Consume the SFI header and data credits

     tx_hcrd_consume_v    = '1;                         // Consume header credit here
     tx_hcrd_consume_val  = '1;

     tx_dcrd_consume_v    = '1;
     tx_dcrd_consume_val  = DATA_1_BEAT_DCRDS[2:0];     // Assuming <= 4 for this 64B data bus beat

    end // >1 data bus beat

   end // Arb valid

  end // IDLE

  txq_sm_state_q[HQM_TXQ_SM_BEAT2_BIT]: begin

   // Reuse tq arb muxing logic with the saved vc/fc values

   txq_sm_use_saved       = '1;

   // Send out the next data beat

   agent_tx_v_next        = '1;

   agent_tx_data_next     = txq_arb_data;
   agent_tx_data_par_next = txq_arb_data_par;

   if (~agent_tx_hold) begin // Not holding

    // Pop the data from the appropriate data FIFO

    txq_pd_fifo_pop[  txq_arb_vc] = (agent_tx_fc_q == 2'd0);
    txq_npd_fifo_pop[ txq_arb_vc] = (agent_tx_fc_q == 2'd1);
    txq_cpld_fifo_pop[txq_arb_vc] = (agent_tx_fc_q == 2'd2);

    if (agent_tx_data_cnt_q <= DATA_1_BEAT_DCRDS[5:0]) begin // Last data beat

     // Pop the appropriate header FIFO

     txq_ph_fifo_pop[  txq_arb_vc] = (agent_tx_fc_q == 2'd0);
     txq_nph_fifo_pop[ txq_arb_vc] = (agent_tx_fc_q == 2'd1);
     txq_cplh_fifo_pop[txq_arb_vc] = (agent_tx_fc_q == 2'd2);
     txq_ioq_fifo_pop[ txq_arb_vc] = '1;

     // Return the IOSF header credit and data credit(s)

     txq_sm_credit_put    = '1;
     txq_sm_credit_chid   = agent_tx_vc_q;
     txq_sm_credit_rtype  = agent_tx_fc_q;
     txq_sm_credit_cmd    = '1;
     txq_sm_credit_data   = agent_tx_data_cnt_q[2:0];        // Assuming <= 4 for this 64B data bus beat

     // Consume the SFI data credit(s)

     tx_dcrd_consume_v    = '1;
     tx_dcrd_consume_val  = agent_tx_data_cnt_q[2:0];        // Assuming <= 4 for this 64B data bus beat

     // Update the VC arbiter

     txq_arb_update       = '1;

     // Done, so back to IDLE

     txq_sm_state_next    = HQM_TXQ_SM_IDLE;

    end // Last data bus beat

    else begin // More data beats

     // Return the IOSF data credits

     txq_sm_credit_put      = '1;
     txq_sm_credit_chid     = agent_tx_vc_q;
     txq_sm_credit_rtype    = agent_tx_fc_q;
     txq_sm_credit_cmd      = '0;                            // Don't return hdr credit yet (haven't popped)
     txq_sm_credit_data     = DATA_1_BEAT_DCRDS[2:0];        // Assuming <= 4 for this 64B data bus beat

     // Consume the SFI data credits

     tx_dcrd_consume_v      = '1;
     tx_dcrd_consume_val    = DATA_1_BEAT_DCRDS[2:0];        // Assuming <= 4 for this 64B data bus beat

     // Update remaining data beat count

     agent_tx_data_cnt_next = agent_tx_data_cnt_q - DATA_1_BEAT_DCRDS[5:0];

     // Stay in this state until all beats have been transferred

    end // More data beats

   end // Not holding

  end // BEAT2

  default: txq_sm_state_next = txq_sm_state_q;

 endcase

end

//-------------------------------------------------------------------------------------------------
// Register the agent master interface

always_ff @(posedge prim_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  agent_tx_v_q <= '0;
 end else if (~agent_tx_hold) begin
  agent_tx_v_q <= agent_tx_v_next;
 end
end

always_ff @(posedge prim_clk) begin
 if (~agent_tx_hold) begin
  agent_tx_vc_q           <= agent_tx_vc_next;
  agent_tx_fc_q           <= agent_tx_fc_next;
  agent_tx_hdr_size_q     <= agent_tx_hdr_size_next;
  agent_tx_hdr_has_data_q <= agent_tx_hdr_has_data_next;
  agent_tx_hdr_q          <= agent_tx_hdr_next;
  agent_tx_hdr_par_q      <= agent_tx_hdr_par_next;
  agent_tx_data_q         <= agent_tx_data_next;
  agent_tx_data_par_q     <= agent_tx_data_par_next;
  agent_tx_data_cnt_q     <= agent_tx_data_cnt_next;
 end
end

// Drive the agent master interface to the SFI

always_comb begin

 agent_tx_v            = agent_tx_v_q;
 agent_tx_vc           = agent_tx_vc_q;
 agent_tx_fc           = agent_tx_fc_q;
 agent_tx_hdr_size     = agent_tx_hdr_size_q;
 agent_tx_hdr_has_data = agent_tx_hdr_has_data_q;
 agent_tx_hdr          = agent_tx_hdr_q;
 agent_tx_hdr_par      = agent_tx_hdr_par_q;
 agent_tx_data         = agent_tx_data_q;
 agent_tx_data_par     = agent_tx_data_par_q;

 // Hold if we don't have the ack from SFI

 agent_tx_hold         = agent_tx_v_q & ~agent_tx_ack;

end

//-------------------------------------------------------------------------------------------------
// Target credit init

always_comb begin

 credit_init_done_next = credit_init_done_q;
 credit_init_ccnt_next = credit_init_ccnt_q;
 credit_init_dcnt_next = credit_init_dcnt_q;

 credit_init_put   = '0;
 credit_init_chid  = '0;
 credit_init_rtype = hqm_sfi_fc_id_t'('0);
 credit_init_cmd   = '0;
 credit_init_data  = '0;

 if (~credit_init_done_q) begin // Init not done

  if (credit_init) begin // Credit init

   credit_init_chid  = credit_chid_q;
   credit_init_rtype = credit_rtype_q;
   credit_init_cmd   = (|credit_init_ccnt_q);
   credit_init_data  = (credit_init_dcnt_q > 6'd3) ? 3'd4 : credit_init_dcnt_q[2:0];

   if (|{credit_init_ccnt_q, credit_init_dcnt_q}) begin // Credits left in vc/fc

    credit_init_put   = '1;

    // Decrement counts

    credit_init_ccnt_next = (credit_init_ccnt_q > 6'd0) ? (credit_init_ccnt_q - 6'd1) : 6'd0;
    credit_init_dcnt_next = (credit_init_dcnt_q > 6'd3) ? (credit_init_dcnt_q - 6'd4) : 6'd0;

   end // Credits left in vc/fc

   else begin // Last credits for this vc/fc

    if ((credit_chid_q == HQM_SFI_RX_HDR_NUM_VCS_M1[HQM_SFI_RX_HDR_VC_WIDTH-1:0]) & (credit_rtype_q == 2'd2)) begin // Done

     credit_init_done_next = '1;

    end // Done

    else begin // Next vc/fc

     if (credit_rtype_q == 2'd2) begin // Next vc

      credit_init_chid  = credit_chid_q + {{(HQM_SFI_RX_HDR_VC_WIDTH-1){1'b0}}, 1'b1};
      credit_init_rtype = hqm_sfi_fc_id_t'('0);

     end // Next vc

     else begin // Next fc

      credit_init_rtype = hqm_sfi_fc_id_t'(credit_rtype_q + 2'd1);

     end // Next fc

     // Init counts for next fc

     case (credit_rtype_q)
      2'd2: begin
             credit_init_ccnt_next = HQM_TXQ_PH_FIFO_DEPTH[5:0];
             credit_init_dcnt_next = HQM_TXQ_PD_FIFO_DEPTH[5:0];
      end
      2'd1: begin
//           credit_init_ccnt_next = HQM_TXQ_CPLH_FIFO_DEPTH[5:0];
//           credit_init_dcnt_next = HQM_TXQ_CPLD_FIFO_DEPTH[5:0];
             credit_init_ccnt_next = '0;
             credit_init_dcnt_next = '0;
      end
      default: begin
             credit_init_ccnt_next = HQM_TXQ_NPH_FIFO_DEPTH[5:0];
             credit_init_dcnt_next = HQM_TXQ_NPD_FIFO_DEPTH[5:0];
      end
     endcase

    end // Next vc/fc

   end // Last credits for this vc/fc

  end // Credit init

 end // Init not done

end

always_ff @(posedge prim_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  credit_init_done_q <= '0;
  credit_init_ccnt_q <= HQM_TXQ_PH_FIFO_DEPTH[5:0];
  credit_init_dcnt_q <= HQM_TXQ_PD_FIFO_DEPTH[5:0];
 end else begin
  credit_init_done_q <= credit_init_done_next;
  credit_init_ccnt_q <= credit_init_ccnt_next;
  credit_init_dcnt_q <= credit_init_dcnt_next;
 end
end

//-------------------------------------------------------------------------------------------------
// The credit returns are driven either from the credit initi logic or the tq sm.

always_comb begin
 credit_put_next   = (credit_init_done_q) ? txq_sm_credit_put   : credit_init_put;
 credit_chid_next  = (credit_init_done_q) ? txq_sm_credit_chid  : credit_init_chid;
 credit_rtype_next = (credit_init_done_q) ? txq_sm_credit_rtype : credit_init_rtype;
 credit_cmd_next   = (credit_init_done_q) ? txq_sm_credit_cmd   : credit_init_cmd;
 credit_data_next  = (credit_init_done_q) ? txq_sm_credit_data  : credit_init_data;
end

// Register the credit return interface

always_ff @(posedge prim_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  credit_put_q   <= '0;
  credit_chid_q  <= '0;
  credit_rtype_q <= hqm_sfi_fc_id_t'('0);
  credit_cmd_q   <= '0;
  credit_data_q  <= '0;
 end else begin
  credit_put_q   <= credit_put_next;
  credit_chid_q  <= credit_chid_next;
  credit_rtype_q <= credit_rtype_next;
  credit_cmd_q   <= credit_cmd_next;
  credit_data_q  <= credit_data_next;
 end
end

// Drive the IOSF outputs

always_comb begin
 credit_put   = credit_put_q;
 credit_chid  = credit_chid_q;
 credit_rtype = credit_rtype_q;
 credit_cmd   = credit_cmd_q;
 credit_data  = credit_data_q;
end

//-------------------------------------------------------------------------------------------------

hqm_sfi #(

     .BRIDGE(1),

`include "hqm_sfi_params_inst.sv"

) i_hqm_sfi (

     .clk                           (prim_clk)                  //I: SFI:
    ,.clk_gated                     (prim_clk)                  //I: SFI:
    ,.clk_valid                     ('1)                        //I: SFI:
    ,.rst_b                         (prim_gated_rst_b)          //I: SFI:

    ,.cfg_idle_dly                  ('0)                        //I: SFI:
    ,.cfg_inj_tx_edb                ('0)                        //I: SFI:
    ,.cfg_inj_tx_poison             ('0)                        //I: SFI:
    ,.cfg_inj_tx_auxperr            ('0)                        //I: SFI:
    ,.cfg_inj_tx_dperr              ('0)                        //I: SFI:
    ,.cfg_inj_tx_cperr              ('0)                        //I: SFI:
    ,.cfg_sif_vc_rxmap              (32'h00000a98)              //I: SFI:
    ,.cfg_sif_vc_txmap              (32'h00000210)              //I: SFI:
    ,.cfg_dbgbrk1                   ('0)                        //I: SFI:
    ,.cfg_dbgbrk2                   ('0)                        //I: SFI:
    ,.cfg_dbgbrk3                   ('0)                        //I: SFI:
    ,.cfg_sfi_rx_data_par_off       ('1)                        //I: SFI:
    ,.cfg_sfi_idle_min_crds         ('0)                        //I: SFI:

    ,.config_done                   (config_done)               //I: SFI:

    ,.sfi_dfx_ctl                   ('0)                        //I: SFI:

    ,.force_sfi_blocks              ('0)                        //I: SFI:

    ,.sfi_rx_idle                   (sfi_rx_idle)               //O: SFI:
    ,.sfi_tx_idle                   (sfi_tx_idle)               //O: SFI:

    ,.rx_sm                         ()                          //O: SFI:
    ,.tx_sm                         ()                          //O: SFI:

    ,.noa_sfi                       ()                          //O: SFI:

    //-------------------------------------------------------------------------------------------------
    // SFI Master

    ,.sfi_tx_txcon_req              (sfi_tx_txcon_req)          //O: SFI: Connection request

    ,.sfi_tx_rxcon_ack              (sfi_tx_rxcon_ack)          //I: SFI: Connection acknowledge
    ,.sfi_tx_rxdiscon_nack          (sfi_tx_rxdiscon_nack)      //I: SFI: Disconnect rejection
    ,.sfi_tx_rx_empty               (sfi_tx_rx_empty)           //I: SFI: Reciever queues are empty and all credits returned

    ,.sfi_tx_hdr_valid              (sfi_tx_hdr_valid)          //O: SFI: Header is valid
    ,.sfi_tx_hdr_early_valid        (sfi_tx_hdr_early_valid)    //O: SFI: Header early valid indication
    ,.sfi_tx_hdr_info_bytes         (sfi_tx_hdr_info_bytes)     //O: SFI: Header info
    ,.sfi_tx_header                 (sfi_tx_header)             //O: SFI: Header

    ,.sfi_tx_hdr_block              (sfi_tx_hdr_block)          //I: SFI: RX requires TX to pause hdr

    ,.sfi_tx_hdr_crd_rtn_valid      (sfi_tx_hdr_crd_rtn_valid)  //I: SFI: RX returning hdr credit
    ,.sfi_tx_hdr_crd_rtn_vc_id      (sfi_tx_hdr_crd_rtn_vc_id)  //I: SFI: Credit virtual channel
    ,.sfi_tx_hdr_crd_rtn_fc_id      (sfi_tx_hdr_crd_rtn_fc_id)  //I: SFI: Credit flow class
    ,.sfi_tx_hdr_crd_rtn_value      (sfi_tx_hdr_crd_rtn_value)  //I: SFI: Number of hdr credits returned per cycle

    ,.sfi_tx_hdr_crd_rtn_block      (sfi_tx_hdr_crd_rtn_block)  //O: SFI: TX requires RX to pause hdr credit returns

    ,.sfi_tx_data_valid             (sfi_tx_data_valid)         //O: SFI: Data is valid
    ,.sfi_tx_data_early_valid       (sfi_tx_data_early_valid)   //O: SFI: Data early valid indication
    ,.sfi_tx_data_aux_parity        (sfi_tx_data_aux_parity)    //O: SFI: Data auxilliary parity
    ,.sfi_tx_data_poison            (sfi_tx_data_poison)        //O: SFI: Data poisoned per DW
    ,.sfi_tx_data_edb               (sfi_tx_data_edb)           //O: SFI: Data bad per DW
    ,.sfi_tx_data_start             (sfi_tx_data_start)         //O: SFI: Start of data
    ,.sfi_tx_data_end               (sfi_tx_data_end)           //O: SFI: End   of data
    ,.sfi_tx_data_parity            (sfi_tx_data_parity)        //O: SFI: Data parity per 8B
    ,.sfi_tx_data_info_byte         (sfi_tx_data_info_byte)     //O: SFI: Data info
    ,.sfi_tx_data                   (sfi_tx_data)               //O: SFI: Data payload

    ,.sfi_tx_data_block             (sfi_tx_data_block)         //I: SFI: RX requires TX to pause data

    ,.sfi_tx_data_crd_rtn_valid     (sfi_tx_data_crd_rtn_valid) //I: SFI: RX returning data credit
    ,.sfi_tx_data_crd_rtn_vc_id     (sfi_tx_data_crd_rtn_vc_id) //I: SFI: Credit virtual channel
    ,.sfi_tx_data_crd_rtn_fc_id     (sfi_tx_data_crd_rtn_fc_id) //I: SFI: Credit flow class
    ,.sfi_tx_data_crd_rtn_value     (sfi_tx_data_crd_rtn_value) //I: SFI: Number of data credits returned per cycle

    ,.sfi_tx_data_crd_rtn_block     (sfi_tx_data_crd_rtn_block) //O: SFI: TX requires RX to pause data credit returns

    //-------------------------------------------------------------------------------------------------
    // SFI Target

    ,.sfi_rx_txcon_req              (sfi_rx_txcon_req)          //I: SFI: Connection request

    ,.sfi_rx_rxcon_ack              (sfi_rx_rxcon_ack)          //O: SFI: Connection acknowledge
    ,.sfi_rx_rxdiscon_nack          (sfi_rx_rxdiscon_nack)      //O: SFI: Disconnect rejection
    ,.sfi_rx_rx_empty               (sfi_rx_rx_empty)           //O: SFI: Reciever queues are empty and all credits returned

    ,.sfi_rx_hdr_valid              (sfi_rx_hdr_valid)          //I: SFI: Header is valid
    ,.sfi_rx_hdr_early_valid        (sfi_rx_hdr_early_valid)    //I: SFI: Header early valid indication
    ,.sfi_rx_hdr_info_bytes         (sfi_rx_hdr_info_bytes)     //I: SFI: Header info
    ,.sfi_rx_header                 (sfi_rx_header)             //I: SFI: Header

    ,.sfi_rx_hdr_block              (sfi_rx_hdr_block)          //O: SFI: RX requires TX to pause hdr

    ,.sfi_rx_hdr_crd_rtn_valid      (sfi_rx_hdr_crd_rtn_valid)  //O: SFI: RX returning hdr credit
    ,.sfi_rx_hdr_crd_rtn_vc_id      (sfi_rx_hdr_crd_rtn_vc_id)  //O: SFI: Credit virtual channel
    ,.sfi_rx_hdr_crd_rtn_fc_id      (sfi_rx_hdr_crd_rtn_fc_id)  //O: SFI: Credit flow class
    ,.sfi_rx_hdr_crd_rtn_value      (sfi_rx_hdr_crd_rtn_value)  //O: SFI: Number of hdr credits returned per cycle

    ,.sfi_rx_hdr_crd_rtn_block      (sfi_rx_hdr_crd_rtn_block)  //I: SFI: TX requires RX to pause hdr credit returns

    ,.sfi_rx_data_valid             (sfi_rx_data_valid)         //I: SFI: Data is valid
    ,.sfi_rx_data_early_valid       (sfi_rx_data_early_valid)   //I: SFI: Data early valid indication
    ,.sfi_rx_data_aux_parity        (sfi_rx_data_aux_parity)    //I: SFI: Data auxilliary parity
    ,.sfi_rx_data_poison            (sfi_rx_data_poison)        //I: SFI: Data poisoned per DW
    ,.sfi_rx_data_edb               (sfi_rx_data_edb)           //I: SFI: Data bad per DW
    ,.sfi_rx_data_start             (sfi_rx_data_start)         //I: SFI: Start of data
    ,.sfi_rx_data_end               (sfi_rx_data_end)           //I: SFI: End   of data
    ,.sfi_rx_data_parity            (sfi_rx_data_parity)        //I: SFI: Data parity per 8B
    ,.sfi_rx_data_info_byte         (sfi_rx_data_info_byte)     //I: SFI: Data info
    ,.sfi_rx_data                   (sfi_rx_data)               //I: SFI: Data payload

    ,.sfi_rx_data_block             (sfi_rx_data_block)         //O: SFI: RX requires TX to pause data

    ,.sfi_rx_data_crd_rtn_valid     (sfi_rx_data_crd_rtn_valid) //O: SFI: RX returning data credit
    ,.sfi_rx_data_crd_rtn_vc_id     (sfi_rx_data_crd_rtn_vc_id) //O: SFI: Credit virtual channel
    ,.sfi_rx_data_crd_rtn_fc_id     (sfi_rx_data_crd_rtn_fc_id) //O: SFI: Credit flow class
    ,.sfi_rx_data_crd_rtn_value     (sfi_rx_data_crd_rtn_value) //O: SFI: Number of data credits returned per cycle

    ,.sfi_rx_data_crd_rtn_block     (sfi_rx_data_crd_rtn_block) //I: SFI: TX requires RX to pause credit returns

    //-------------------------------------------------------------------------------------------------
    // Agent master interface

    ,.agent_tx_v                    (agent_tx_v)                //I: SFI: Agent transmit transaction
    ,.agent_tx_vc                   (agent_tx_vc)               //I: SFI:
    ,.agent_tx_fc                   (agent_tx_fc)               //I: SFI:
    ,.agent_tx_hdr_size             (agent_tx_hdr_size)         //I: SFI:
    ,.agent_tx_hdr_has_data         (agent_tx_hdr_has_data)     //I: SFI:
    ,.agent_tx_hdr                  (agent_tx_hdr)              //I: SFI:
    ,.agent_tx_hdr_par              (agent_tx_hdr_par)          //I: SFI:
    ,.agent_tx_data                 (agent_tx_data)             //I: SFI:
    ,.agent_tx_data_par             (agent_tx_data_par)         //I: SFI:

    ,.agent_tx_ack                  (agent_tx_ack)              //O: SFI:

    //-------------------------------------------------------------------------------------------------
    // Agent target interface

    ,.agent_rxqs_empty              (agent_rxqs_empty)          //I: SFI:

    ,.agent_rx_hdr_v                (agent_rx_hdr_v)            //O: SFI: Agent target hdr  push
    ,.agent_rx_hdr_vc               (agent_rx_hdr_vc)           //O: SFI:
    ,.agent_rx_hdr_fc               (agent_rx_hdr_fc)           //O: SFI:
    ,.agent_rx_hdr_size             (agent_rx_hdr_size)         //O: SFI:
    ,.agent_rx_hdr_has_data         (agent_rx_hdr_has_data)     //O: SFI:
    ,.agent_rx_hdr                  (agent_rx_hdr)              //O: SFI:
    ,.agent_rx_hdr_par              (agent_rx_hdr_par)          //O: SFI:

    ,.agent_rx_data_v               (agent_rx_data_v)           //O: SFI: Agent target data push
    ,.agent_rx_data_vc              (agent_rx_data_vc)          //O: SFI:
    ,.agent_rx_data_fc              (agent_rx_data_fc)          //O: SFI:
    ,.agent_rx_data                 (agent_rx_data)             //O: SFI:
    ,.agent_rx_data_par             (agent_rx_data_par)         //O: SFI:

    //-------------------------------------------------------------------------------------------------
    // Agent credit interface

    ,.tx_hcrds_avail                (tx_hcrds_avail)            //O: SFI: Available TX req  credits
    ,.tx_dcrds_avail                (tx_dcrds_avail)            //O: SFI: Available TX data credits

    ,.tx_hcrd_consume_v             (tx_hcrd_consume_v)         //I: SFI: Target hdr  credit consume
    ,.tx_hcrd_consume_vc            (tx_hcrd_consume_vc)        //I: SFI:
    ,.tx_hcrd_consume_fc            (tx_hcrd_consume_fc)        //I: SFI:
    ,.tx_hcrd_consume_val           (tx_hcrd_consume_val)       //I: SFI:

    ,.tx_dcrd_consume_v             (tx_dcrd_consume_v)         //I: SFI: Target data credit consume
    ,.tx_dcrd_consume_vc            (tx_dcrd_consume_vc)        //I: SFI:
    ,.tx_dcrd_consume_fc            (tx_dcrd_consume_fc)        //I: SFI:
    ,.tx_dcrd_consume_val           (tx_dcrd_consume_val)       //I: SFI:

    //-------------------------------------------------------------------------------------------------
    // Agent credit return interface

    ,.rx_hcrd_return_v              (rx_hcrd_return_v)          //I: SFI: Agent returning RX req  credits
    ,.rx_hcrd_return_vc             (rx_hcrd_return_vc)         //I: SFI:
    ,.rx_hcrd_return_fc             (rx_hcrd_return_fc)         //I: SFI:
    ,.rx_hcrd_return_val            (rx_hcrd_return_val)        //I: SFI:

    ,.rx_dcrd_return_v              (rx_dcrd_return_v)          //I: SFI: Agent returning RX data credits
    ,.rx_dcrd_return_vc             (rx_dcrd_return_vc)         //I: SFI:
    ,.rx_dcrd_return_fc             (rx_dcrd_return_fc)         //I: SFI:
    ,.rx_dcrd_return_val            (rx_dcrd_return_val)        //I: SFI:

    //-------------------------------------------------------------------------------------------------
    // Errors

    ,.tx_hcrds_used_xflow           ()                          //O: SFI:
    ,.tx_hcrds_used_xflow_synd      ()                          //O: SFI:
    ,.tx_dcrds_used_xflow           ()                          //O: SFI:
    ,.tx_dcrds_used_xflow_synd      ()                          //O: SFI:

    ,.set_sfi_rx_data_err           ()                          //O: SFI:
    ,.sfi_rx_data_aux_hdr           ()                          //O: SFI:

    ,.sfi_rx_data_edb_err_synd      ()                          //O: SFI:
    ,.sfi_rx_data_poison_err_synd   ()                          //O: SFI:
    ,.sfi_rx_data_perr_synd         ()                          //O: SFI:

    //-------------------------------------------------------------------------------------------------
    // Credit status

    ,.rx_used_hcrds                 ('0)                        //O: SFI:
    ,.rx_used_dcrds                 ('0)                        //O: SFI:

    ,.rx_init_hcrds                 ()                          //O: SFI:
    ,.rx_init_dcrds                 ()                          //O: SFI:

    ,.rx_ret_hcrds                  ()                          //O: SFI:
    ,.rx_ret_dcrds                  ()                          //O: SFI:

    ,.tx_init_hcrds                 ()                          //O: SFI:
    ,.tx_init_dcrds                 ()                          //O: SFI:

    ,.tx_rem_hcrds                  ()                          //O: SFI:
    ,.tx_rem_dcrds                  ()                          //O: SFI:

    ,.tx_used_hcrds                 ()                          //O: SFI:
    ,.tx_used_dcrds                 ()                          //O: SFI:
);

//-----------------------------------------------------------------------------------------------------
// Translate SFI header to IOSF header

always_comb begin

 agent_rx_iosf_hdr = '0;

 case (agent_rx_hdr.mem32.ttype)

  FLIT_CMD_MRD32,
  FLIT_CMD_MWR32: begin // 4DW MMIO Read/Write

   agent_rx_iosf_hdr.mem.sai            =  agent_rx_hdr.mem32.pf0.sai;

  {agent_rx_iosf_hdr.mem.fmt
  ,agent_rx_iosf_hdr.mem.ttype}         = (agent_rx_hdr.mem32.ttype == FLIT_CMD_MRD32) ? PCIE_CMD_MRD32 : PCIE_CMD_MWR32;
   agent_rx_iosf_hdr.mem.tag9           = agent_rx_hdr.mem32.tag[9];
   agent_rx_iosf_hdr.mem.tc             = {1'b0, agent_rx_hdr.mem32.tc2_0};
   agent_rx_iosf_hdr.mem.tag8           = agent_rx_hdr.mem32.tag[8];
   agent_rx_iosf_hdr.mem.ido            =  agent_rx_hdr.mem32.attr[2];
   agent_rx_iosf_hdr.mem.rsvd1_1        = '0;
   agent_rx_iosf_hdr.mem.th             = '0;
   agent_rx_iosf_hdr.mem.td             = '0;
   agent_rx_iosf_hdr.mem.ep             =  agent_rx_hdr.mem32.ep;
   agent_rx_iosf_hdr.mem.ro             =  agent_rx_hdr.mem32.attr[1];
   agent_rx_iosf_hdr.mem.ns             =  agent_rx_hdr.mem32.attr[0];
   agent_rx_iosf_hdr.mem.at             =  agent_rx_hdr.mem32.at;
   agent_rx_iosf_hdr.mem.length         =  agent_rx_hdr.mem32.len;
   agent_rx_iosf_hdr.mem.reqid          =  agent_rx_hdr.mem32.reqid;
   agent_rx_iosf_hdr.mem.tag            =  agent_rx_hdr.mem32.tag[7:0];
   agent_rx_iosf_hdr.mem.lbe            = '1;
   agent_rx_iosf_hdr.mem.fbe            = '1;

   // Default byte enables are all 1s.  If only 1 DW, the lbe must be all 0s.
   // If ohca1 present, then get bytes enable and PASID (for ATS requests) from there.

   if (agent_rx_hdr.mem32.len == 10'd1) begin
    agent_rx_iosf_hdr.mem.lbe           = '0;
   end

   agent_rx_iosf_hdr.mem.address        = {32'd0, agent_rx_hdr.mem32.address31_2, 2'd0};

   if (agent_rx_hdr.mem32.ohc[0]) begin

    agent_rx_iosf_hdr.mem.lbe           =  agent_rx_hdr.mem32.ohc_dw0.a1.lbe;
    agent_rx_iosf_hdr.mem.fbe           =  agent_rx_hdr.mem32.ohc_dw0.a1.fbe;
    agent_rx_iosf_hdr.mem.pasidtlp      = {agent_rx_hdr.mem32.ohc_dw0.a1.pv
                                          ,agent_rx_hdr.mem32.ohc_dw0.a1.pmr
                                          ,agent_rx_hdr.mem32.ohc_dw0.a1.er
                                          ,agent_rx_hdr.mem32.ohc_dw0.a1.pasid
                                          };
   end

   // SFI header parity is on the entire header and hdr_info_bytes fields. The hdr_info_bytes bits are:
   //
   //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
   //
   // We transfer all bits from the SFI header format except for the following, so the SFI
   // header parity must be adjusted by the following to create the IOSF header parity:
   //
   //       Need to account for replacing SFI {type[7:0]} with IOSF {fmt[1:0], type[4:0]}.
   //       The shared_credit field will always be 0 so it does not contribute.
   //       The hdr_size and hdr_has_data fields need to be accounted for.
   //       The SAI contribution needs to be removed.

   agent_rx_iosf_hdr.mem.parity         = ^{ agent_rx_hdr_par
                                           , agent_rx_hdr.mem32.ttype
                                           , agent_rx_hdr.mem32.ohc
                                           , agent_rx_hdr.mem32.pf0.sai
                                           , agent_rx_hdr_vc
                                           , agent_rx_hdr_fc
                                           , agent_rx_hdr_size
                                           , agent_rx_hdr_has_data
                                           , agent_rx_iosf_hdr.mem.fmt[1:0]
                                           , agent_rx_iosf_hdr.mem.ttype
                                           };
  end // 4DW MMIO Read/Write

  FLIT_CMD_MRD64,
  FLIT_CMD_MWR64: begin // 5DW MMIO Read/Write

   agent_rx_iosf_hdr.mem.sai            =  agent_rx_hdr.mem64.pf0.sai;

  {agent_rx_iosf_hdr.mem.fmt
  ,agent_rx_iosf_hdr.mem.ttype}         = (agent_rx_hdr.mem64.ttype == FLIT_CMD_MRD64) ? PCIE_CMD_MRD64 : PCIE_CMD_MWR64;
   agent_rx_iosf_hdr.mem.tag9           = agent_rx_hdr.mem64.tag[9];
   agent_rx_iosf_hdr.mem.tc             = {1'b0, agent_rx_hdr.mem64.tc2_0};
   agent_rx_iosf_hdr.mem.tag8           = agent_rx_hdr.mem64.tag[8];
   agent_rx_iosf_hdr.mem.ido            =  agent_rx_hdr.mem64.attr[2];
   agent_rx_iosf_hdr.mem.rsvd1_1        = '0;
   agent_rx_iosf_hdr.mem.th             = '0;
   agent_rx_iosf_hdr.mem.td             = '0;
   agent_rx_iosf_hdr.mem.ep             =  agent_rx_hdr.mem64.ep;
   agent_rx_iosf_hdr.mem.ro             =  agent_rx_hdr.mem64.attr[1];
   agent_rx_iosf_hdr.mem.ns             =  agent_rx_hdr.mem64.attr[0];
   agent_rx_iosf_hdr.mem.at             =  agent_rx_hdr.mem64.at;
   agent_rx_iosf_hdr.mem.length         =  agent_rx_hdr.mem64.len;
   agent_rx_iosf_hdr.mem.reqid          =  agent_rx_hdr.mem64.reqid;
   agent_rx_iosf_hdr.mem.tag            =  agent_rx_hdr.mem64.tag[7:0];
   agent_rx_iosf_hdr.mem.lbe            = '1;
   agent_rx_iosf_hdr.mem.fbe            = '1;

   // Default byte enables are all 1s.  If only 1 DW, the lbe must be all 0s.
   // If ohca1 present, then get bytes enable and PASID (for ATS requests) from there.

   if (agent_rx_hdr.mem64.len == 10'd1) begin
    agent_rx_iosf_hdr.mem.lbe           = '0;
   end

   agent_rx_iosf_hdr.mem.address        = {agent_rx_hdr.mem64.address63_32
                                          ,agent_rx_hdr.mem64.address31_2
                                          ,2'd0
                                          };

   if (agent_rx_hdr.mem64.ohc[0]) begin

    agent_rx_iosf_hdr.mem.lbe           =  agent_rx_hdr.mem64.ohc_dw0.a1.lbe;
    agent_rx_iosf_hdr.mem.fbe           =  agent_rx_hdr.mem64.ohc_dw0.a1.fbe;
    agent_rx_iosf_hdr.mem.pasidtlp      = {agent_rx_hdr.mem64.ohc_dw0.a1.pv
                                          ,agent_rx_hdr.mem64.ohc_dw0.a1.pmr
                                          ,agent_rx_hdr.mem64.ohc_dw0.a1.er
                                          ,agent_rx_hdr.mem64.ohc_dw0.a1.pasid
                                          };
   end

   // SFI header parity is on the entire header and hdr_info_bytes fields. The hdr_info_bytes bits are:
   //
   //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
   //
   // We transfer all bits from the SFI header format except for the following, so the SFI
   // header parity must be adjusted by the following to create the IOSF header parity:
   //
   //       Need to account for replacing SFI {type[7:0]} with IOSF {fmt[1:0], type[4:0]}.
   //       We do not pass the ohc, vc, or fc bits.
   //       The shared_credit field will always be 0 so it does not contribute.
   //       The hdr_size and hdr_has_data fields need to be accounted for.
   //       The SAI contribution needs to be removed.

   agent_rx_iosf_hdr.mem.parity         = ^{ agent_rx_hdr_par
                                           , agent_rx_hdr.mem64.ttype
                                           , agent_rx_hdr.mem64.ohc
                                           , agent_rx_hdr.mem64.pf0.sai
                                           , agent_rx_hdr_vc
                                           , agent_rx_hdr_fc
                                           , agent_rx_hdr_size
                                           , agent_rx_hdr_has_data
                                           , agent_rx_iosf_hdr.mem.fmt[1:0]
                                           , agent_rx_iosf_hdr.mem.ttype
                                           };
  end // 5DW MMIO Read/Write

  FLIT_CMD_CPL,
  FLIT_CMD_CPLLK,
  FLIT_CMD_CPLD: begin // Completions

   agent_rx_iosf_hdr.cpl.sai            =  agent_rx_hdr.cpl.pf0.sai;
   agent_rx_iosf_hdr.cpl.pasidtlp       = '0;
  {agent_rx_iosf_hdr.cpl.fmt
  ,agent_rx_iosf_hdr.cpl.ttype}         = (agent_rx_hdr.cpl.ttype == FLIT_CMD_CPLLK) ? PCIE_CMD_CPLLK :
                                         ((agent_rx_hdr.cpl.ttype == FLIT_CMD_CPLD ) ? PCIE_CMD_CPLD  : FLIT_CMD_CPL);
   agent_rx_iosf_hdr.cpl.tag9           =  agent_rx_hdr.cpl.tag[9];
   agent_rx_iosf_hdr.cpl.tc             = {1'b0, agent_rx_hdr.cpl.tc2_0};
   agent_rx_iosf_hdr.cpl.tag8           =  agent_rx_hdr.cpl.tag[8];
   agent_rx_iosf_hdr.cpl.ido            =  agent_rx_hdr.cpl.attr[2];
   agent_rx_iosf_hdr.cpl.rsvd1_1        = '0;
   agent_rx_iosf_hdr.cpl.th             = '0;
   agent_rx_iosf_hdr.cpl.td             = '0;
   agent_rx_iosf_hdr.cpl.ep             =  agent_rx_hdr.cpl.ep;
   agent_rx_iosf_hdr.cpl.ro             =  agent_rx_hdr.cpl.attr[1];
   agent_rx_iosf_hdr.cpl.ns             =  agent_rx_hdr.cpl.attr[0];
   agent_rx_iosf_hdr.cpl.at             =  hqm_sfi_at_t'('0);
   agent_rx_iosf_hdr.cpl.length         =  agent_rx_hdr.cpl.len;
   agent_rx_iosf_hdr.cpl.cplid          =  agent_rx_hdr.cpl.cplid;
   agent_rx_iosf_hdr.cpl.bcm            = '0;
   agent_rx_iosf_hdr.cpl.bc             =  agent_rx_hdr.cpl.bc;
   agent_rx_iosf_hdr.cpl.reqid          =  agent_rx_hdr.cpl.bdf;
   agent_rx_iosf_hdr.cpl.tag            =  agent_rx_hdr.cpl.tag[7:0];
   agent_rx_iosf_hdr.cpl.laddr          = {agent_rx_hdr.cpl.la6, agent_rx_hdr.cpl.la5_2, 2'd0};

   // If OHCA5 present, need the unsuccessful Cpl fields

   if (agent_rx_hdr.cpl.ohc[0]) begin

    agent_rx_iosf_hdr.cpl.cpl_status    =  agent_rx_hdr.cpl.ohc_dw0.a5.cpl_status;
    agent_rx_iosf_hdr.cpl.laddr[1:0]    =  agent_rx_hdr.cpl.ohc_dw0.a5.la1_0;

   end

   // SFI header parity is on the entire header and hdr_info_bytes fields. The hdr_info_bytes bits are:
   //
   //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
   //
   // We transfer all bits from the SFI header format except for the following, so the SFI
   // header parity must be adjusted by the following to create the IOSF header parity:
   //
   //       Need to account for replacing SFI {type[7:0]} with IOSF {fmt[1:0], type[4:0]}.
   //       We do not pass the ohc, vc, or fc bits.
   //       The shared_credit field will always be 0 so it does not contribute.
   //       The hdr_size and hdr_has_data fields need to be accounted for.
   //       The SAI contribution needs to be removed.

   agent_rx_iosf_hdr.cpl.parity         = ^{ agent_rx_hdr_par
                                           , agent_rx_hdr.cpl.ttype
                                           , agent_rx_hdr.cpl.ohc
                                           , agent_rx_hdr.cpl.pf0.sai
                                           , agent_rx_hdr_vc
                                           , agent_rx_hdr_fc
                                           , agent_rx_hdr_size
                                           , agent_rx_hdr_has_data
                                           , agent_rx_iosf_hdr.cpl.fmt[1:0]
                                           , agent_rx_iosf_hdr.cpl.ttype
                                           };
  end // Completions

  FLIT_CMD_MSG2: begin // Invalidate response

   agent_rx_iosf_hdr.msg.sai            =  agent_rx_hdr.invrsp.pf0.sai;

  {agent_rx_iosf_hdr.msg.fmt
  ,agent_rx_iosf_hdr.msg.ttype}         = PCIE_CMD_MSG2;
   agent_rx_iosf_hdr.msg.tag9           = '0;
   agent_rx_iosf_hdr.msg.tc             = {1'b0, agent_rx_hdr.invrsp.tc2_0};
   agent_rx_iosf_hdr.msg.tag8           = '0;
   agent_rx_iosf_hdr.msg.ido            =  agent_rx_hdr.invrsp.attr[2];
   agent_rx_iosf_hdr.msg.rsvd1_1        = '0;
   agent_rx_iosf_hdr.msg.th             = '0;
   agent_rx_iosf_hdr.msg.td             = '0;
   agent_rx_iosf_hdr.msg.ep             = '0;
   agent_rx_iosf_hdr.msg.ro             =  agent_rx_hdr.invrsp.attr[1];
   agent_rx_iosf_hdr.msg.ns             =  agent_rx_hdr.invrsp.attr[0];
   agent_rx_iosf_hdr.msg.at             = hqm_sfi_at_t'('0);
   agent_rx_iosf_hdr.msg.length         =  agent_rx_hdr.invrsp.len;
   agent_rx_iosf_hdr.msg.reqid          =  agent_rx_hdr.invrsp.reqid;
   agent_rx_iosf_hdr.msg.tag            =  agent_rx_hdr.invrsp.rsvd79_72;
   agent_rx_iosf_hdr.msg.msg_code       =  agent_rx_hdr.invrsp.msg_code;
   agent_rx_iosf_hdr.msg.bdf            =  agent_rx_hdr.invrsp.bdf;
   agent_rx_iosf_hdr.msg.rsvd47_0       = {agent_rx_hdr.invrsp.rsvd111_99
                                          ,agent_rx_hdr.invrsp.cc
                                          ,agent_rx_hdr.invrsp.itag_vec
                                          };

   // If ohca1 present, then get PASID from there.

   if (agent_rx_hdr.invrsp.ohc[0]) begin

    agent_rx_iosf_hdr.msg.pasidtlp      = {agent_rx_hdr.invrsp.ohc_dw0.a1.pv
                                          ,agent_rx_hdr.invrsp.ohc_dw0.a1.pmr
                                          ,agent_rx_hdr.invrsp.ohc_dw0.a1.er
                                          ,agent_rx_hdr.invrsp.ohc_dw0.a1.pasid
                                          };
   end

   // SFI header parity is on the entire header and hdr_info_bytes fields. The hdr_info_bytes bits are:
   //
   //  {has_data, shared_credit (always 0 for us), vc, hdr_size, and fc}
   //
   // We transfer all bits from the SFI header format except for the following, so the SFI
   // header parity must be adjusted by the following to create the IOSF header parity:
   //
   //       Need to account for replacing SFI {type[7:0]} with IOSF {fmt[1:0], type[4:0]}.
   //       We do not pass the ohc, vc, or fc bits.
   //       The shared_credit field will always be 0 so it does not contribute.
   //       The hdr_size and hdr_has_data fields need to be accounted for.
   //       The SAI contribution needs to be removed.

   agent_rx_iosf_hdr.mem.parity         = ^{ agent_rx_hdr_par
                                           , agent_rx_hdr.invrsp.ttype
                                           , agent_rx_hdr.invrsp.ohc
                                           , agent_rx_hdr.invrsp.pf0.sai
                                           , agent_rx_hdr_vc
                                           , agent_rx_hdr_fc
                                           , agent_rx_hdr_size
                                           , agent_rx_hdr_has_data
                                           , agent_rx_iosf_hdr.mem.fmt[1:0]
                                           , agent_rx_iosf_hdr.mem.ttype
                                           };
  end // Invalidate response

  default: begin
   agent_rx_iosf_hdr = '0;
  end

 endcase

 agent_rx_pcie_cmd_nc = hqm_sfi_pcie_cmd_t'({agent_rx_iosf_hdr.mem.fmt[1:0], agent_rx_iosf_hdr.mem.ttype});

end

//-----------------------------------------------------------------------------------------------------
// IOSF Receive Queues (SFI Target -> Bridge -> IOSF Master)

localparam int unsigned HQM_RXQ_PH_FIFO_DEPTH         = 8;
localparam int unsigned HQM_RXQ_PD_FIFO_DEPTH         = 16;
localparam int unsigned HQM_RXQ_NPH_FIFO_DEPTH        = 8;
localparam int unsigned HQM_RXQ_NPD_FIFO_DEPTH        = 8;
localparam int unsigned HQM_RXQ_CPLH_FIFO_DEPTH       = 8;
localparam int unsigned HQM_RXQ_CPLD_FIFO_DEPTH       = 8;
localparam int unsigned HQM_RXQ_IOQ_FIFO_DEPTH        = 32;       // P + NP + CPL depth

localparam int unsigned HQM_RXQ_PH_FIFO_ADDR_WIDTH    = $clog2(HQM_RXQ_PH_FIFO_DEPTH);
localparam int unsigned HQM_RXQ_PD_FIFO_ADDR_WIDTH    = $clog2(HQM_RXQ_PD_FIFO_DEPTH);
localparam int unsigned HQM_RXQ_NPH_FIFO_ADDR_WIDTH   = $clog2(HQM_RXQ_NPH_FIFO_DEPTH);
localparam int unsigned HQM_RXQ_NPD_FIFO_ADDR_WIDTH   = $clog2(HQM_RXQ_NPD_FIFO_DEPTH);
localparam int unsigned HQM_RXQ_CPLH_FIFO_ADDR_WIDTH  = $clog2(HQM_RXQ_CPLH_FIFO_DEPTH);
localparam int unsigned HQM_RXQ_CPLD_FIFO_ADDR_WIDTH  = $clog2(HQM_RXQ_CPLD_FIFO_DEPTH);
localparam int unsigned HQM_RXQ_IOQ_FIFO_ADDR_WIDTH   = $clog2(HQM_RXQ_IOQ_FIFO_DEPTH);

localparam int unsigned HQM_RXQ_PH_FIFO_DATA_WIDTH    = 160;      // 128b hdr  + 1b par + 23b pasid + 8b sai
localparam int unsigned HQM_RXQ_PD_FIFO_DATA_WIDTH    = IOSF_DP_WIDTH;
localparam int unsigned HQM_RXQ_NPH_FIFO_DATA_WIDTH   = 160;      // 128b hdr  + 1b par + 23b pasid + 8b sai
localparam int unsigned HQM_RXQ_NPD_FIFO_DATA_WIDTH   = IOSF_DP_WIDTH;
localparam int unsigned HQM_RXQ_CPLH_FIFO_DATA_WIDTH  = 160;      // 128b hdr  + 1b par + 23b pasid + 8b sai
localparam int unsigned HQM_RXQ_CPLD_FIFO_DATA_WIDTH  = IOSF_DP_WIDTH;
localparam int unsigned HQM_RXQ_IOQ_FIFO_DATA_WIDTH   = $bits(hqm_sfi_fc_id_t);

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_ph_fifo_push;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             rxq_ph_fifo_push_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_ph_fifo_pop;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_ph_fifo_pop_data_v;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             rxq_ph_fifo_pop_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][31:0]                                rxq_ph_fifo_status;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_ph_fifo_mem_we;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PH_FIFO_ADDR_WIDTH-1:0]      rxq_ph_fifo_mem_waddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PH_FIFO_DATA_WIDTH-1:0]      rxq_ph_fifo_mem_wdata;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_ph_fifo_mem_re;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PH_FIFO_ADDR_WIDTH-1:0]      rxq_ph_fifo_mem_raddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PH_FIFO_DATA_WIDTH-1:0]      rxq_ph_fifo_mem_rdata;
logic [HQM_RXQ_PH_FIFO_DATA_WIDTH-1:0]                                  rxq_ph_fifo_mem[HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PH_FIFO_DEPTH-1:0];

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_pd_fifo_push;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PD_FIFO_DATA_WIDTH-1:0]      rxq_pd_fifo_push_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_pd_fifo_pop;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_pd_fifo_pop_data_v;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PD_FIFO_DATA_WIDTH-1:0]      rxq_pd_fifo_pop_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][31:0]                                rxq_pd_fifo_status;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_pd_fifo_mem_we;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PD_FIFO_ADDR_WIDTH-1:0]      rxq_pd_fifo_mem_waddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PD_FIFO_DATA_WIDTH-1:0]      rxq_pd_fifo_mem_wdata;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_pd_fifo_mem_re;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PD_FIFO_ADDR_WIDTH-1:0]      rxq_pd_fifo_mem_raddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PD_FIFO_DATA_WIDTH-1:0]      rxq_pd_fifo_mem_rdata;
logic [HQM_RXQ_PD_FIFO_DATA_WIDTH-1:0]                                  rxq_pd_fifo_mem[HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_PD_FIFO_DEPTH-1:0];

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_nph_fifo_push;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             rxq_nph_fifo_push_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_nph_fifo_pop;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_nph_fifo_pop_data_v;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             rxq_nph_fifo_pop_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][31:0]                                rxq_nph_fifo_status;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_nph_fifo_mem_we;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPH_FIFO_ADDR_WIDTH-1:0]     rxq_nph_fifo_mem_waddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPH_FIFO_DATA_WIDTH-1:0]     rxq_nph_fifo_mem_wdata;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_nph_fifo_mem_re;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPH_FIFO_ADDR_WIDTH-1:0]     rxq_nph_fifo_mem_raddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPH_FIFO_DATA_WIDTH-1:0]     rxq_nph_fifo_mem_rdata;
logic [HQM_RXQ_NPH_FIFO_DATA_WIDTH-1:0]                                 rxq_nph_fifo_mem[HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPH_FIFO_DEPTH-1:0];

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_npd_fifo_push;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPD_FIFO_DATA_WIDTH-1:0]     rxq_npd_fifo_push_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_npd_fifo_pop;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_npd_fifo_pop_data_v;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPD_FIFO_DATA_WIDTH-1:0]     rxq_npd_fifo_pop_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][31:0]                                rxq_npd_fifo_status;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_npd_fifo_mem_we;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPD_FIFO_ADDR_WIDTH-1:0]     rxq_npd_fifo_mem_waddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPD_FIFO_DATA_WIDTH-1:0]     rxq_npd_fifo_mem_wdata;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_npd_fifo_mem_re;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPD_FIFO_ADDR_WIDTH-1:0]     rxq_npd_fifo_mem_raddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPD_FIFO_DATA_WIDTH-1:0]     rxq_npd_fifo_mem_rdata;
logic [HQM_RXQ_NPD_FIFO_DATA_WIDTH-1:0]                                 rxq_npd_fifo_mem[HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_NPD_FIFO_DEPTH-1:0];

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_cplh_fifo_push;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             rxq_cplh_fifo_push_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_cplh_fifo_pop;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_cplh_fifo_pop_data_v;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             rxq_cplh_fifo_pop_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][31:0]                                rxq_cplh_fifo_status;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_cplh_fifo_mem_we;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLH_FIFO_ADDR_WIDTH-1:0]    rxq_cplh_fifo_mem_waddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLH_FIFO_DATA_WIDTH-1:0]    rxq_cplh_fifo_mem_wdata;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_cplh_fifo_mem_re;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLH_FIFO_ADDR_WIDTH-1:0]    rxq_cplh_fifo_mem_raddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLH_FIFO_DATA_WIDTH-1:0]    rxq_cplh_fifo_mem_rdata;
logic [HQM_RXQ_CPLH_FIFO_DATA_WIDTH-1:0]                                rxq_cplh_fifo_mem[HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLH_FIFO_DEPTH-1:0];

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_cpld_fifo_push;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLD_FIFO_DATA_WIDTH-1:0]    rxq_cpld_fifo_push_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_cpld_fifo_pop;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_cpld_fifo_pop_data_v;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLD_FIFO_DATA_WIDTH-1:0]    rxq_cpld_fifo_pop_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][31:0]                                rxq_cpld_fifo_status;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_cpld_fifo_mem_we;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLD_FIFO_ADDR_WIDTH-1:0]    rxq_cpld_fifo_mem_waddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLD_FIFO_DATA_WIDTH-1:0]    rxq_cpld_fifo_mem_wdata;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_cpld_fifo_mem_re;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLD_FIFO_ADDR_WIDTH-1:0]    rxq_cpld_fifo_mem_raddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLD_FIFO_DATA_WIDTH-1:0]    rxq_cpld_fifo_mem_rdata;
logic [HQM_RXQ_CPLD_FIFO_DATA_WIDTH-1:0]                                rxq_cpld_fifo_mem[HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_CPLD_FIFO_DEPTH-1:0];

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_ioq_fifo_push;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_IOQ_FIFO_DATA_WIDTH-1:0]     rxq_ioq_fifo_push_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_ioq_fifo_pop;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_ioq_fifo_pop_data_v;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_IOQ_FIFO_DATA_WIDTH-1:0]     rxq_ioq_fifo_pop_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][31:0]                                rxq_ioq_fifo_status;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_ioq_fifo_mem_we;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_IOQ_FIFO_ADDR_WIDTH-1:0]     rxq_ioq_fifo_mem_waddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_IOQ_FIFO_DATA_WIDTH-1:0]     rxq_ioq_fifo_mem_wdata;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      rxq_ioq_fifo_mem_re;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_IOQ_FIFO_ADDR_WIDTH-1:0]     rxq_ioq_fifo_mem_raddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_IOQ_FIFO_DATA_WIDTH-1:0]     rxq_ioq_fifo_mem_rdata;
logic [HQM_RXQ_IOQ_FIFO_DATA_WIDTH-1:0]                                 rxq_ioq_fifo_mem[HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_RXQ_IOQ_FIFO_DEPTH-1:0];

generate
 for (genvar vc=0; vc<HQM_SFI_TX_HDR_NUM_VCS; vc=vc+1) begin: g_vc_rxq

  always_comb begin

   rxq_ph_fifo_push[       vc] = agent_rx_hdr_v  & (agent_rx_hdr_vc  == vc) & (agent_rx_hdr_fc  == 2'd0);
   rxq_nph_fifo_push[      vc] = agent_rx_hdr_v  & (agent_rx_hdr_vc  == vc) & (agent_rx_hdr_fc  == 2'd1);
   rxq_cplh_fifo_push[     vc] = agent_rx_hdr_v  & (agent_rx_hdr_vc  == vc) & (agent_rx_hdr_fc  == 2'd2);

   rxq_pd_fifo_push[       vc] = agent_rx_data_v & (agent_rx_data_vc == vc) & (agent_rx_data_fc == 2'd0);
   rxq_npd_fifo_push[      vc] = agent_rx_data_v & (agent_rx_data_vc == vc) & (agent_rx_data_fc == 2'd1);
   rxq_cpld_fifo_push[     vc] = agent_rx_data_v & (agent_rx_data_vc == vc) & (agent_rx_data_fc == 2'd2);

   rxq_ioq_fifo_push[      vc] = agent_rx_hdr_v  & (agent_rx_hdr_vc  == vc);

   rxq_ph_fifo_push_data[  vc] = agent_rx_iosf_hdr;
   rxq_nph_fifo_push_data[ vc] = agent_rx_iosf_hdr;
   rxq_cplh_fifo_push_data[vc] = agent_rx_iosf_hdr;

   // IOSF has a data parity bit per 256b while SFI has 1 bit per 2 DWs

   if (IOSF_DATA_WIDTH == 512) begin

    rxq_pd_fifo_push_data[  vc] = {(^agent_rx_data_par[7:4]), (^agent_rx_data_par[3:0]), agent_rx_data};
    rxq_npd_fifo_push_data[ vc] = {(^agent_rx_data_par[7:4]), (^agent_rx_data_par[3:0]), agent_rx_data};
    rxq_cpld_fifo_push_data[vc] = {(^agent_rx_data_par[7:4]), (^agent_rx_data_par[3:0]), agent_rx_data};

   end else begin

    rxq_pd_fifo_push_data[  vc] = {(^agent_rx_data_par), agent_rx_data};
    rxq_npd_fifo_push_data[ vc] = {(^agent_rx_data_par), agent_rx_data};
    rxq_cpld_fifo_push_data[vc] = {(^agent_rx_data_par), agent_rx_data};

   end

   rxq_ioq_fifo_push_data[ vc] = agent_rx_hdr_fc;

  end

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_RXQ_PH_FIFO_DEPTH)
    ,.DWIDTH                (HQM_RXQ_PH_FIFO_DATA_WIDTH)

  ) i_rxq_ph (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (rxq_ph_fifo_push[vc])
    ,.push_data             (rxq_ph_fifo_push_data[vc])
    ,.pop                   (rxq_ph_fifo_pop[vc])
    ,.pop_data_v            (rxq_ph_fifo_pop_data_v[vc])
    ,.pop_data              (rxq_ph_fifo_pop_data[vc])

    ,.mem_we                (rxq_ph_fifo_mem_we[vc])
    ,.mem_waddr             (rxq_ph_fifo_mem_waddr[vc])
    ,.mem_wdata             (rxq_ph_fifo_mem_wdata[vc])
    ,.mem_re                (rxq_ph_fifo_mem_re[vc])
    ,.mem_raddr             (rxq_ph_fifo_mem_raddr[vc])
    ,.mem_rdata             (rxq_ph_fifo_mem_rdata[vc])

    ,.fifo_status           (rxq_ph_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_RXQ_PD_FIFO_DEPTH)
    ,.DWIDTH                (HQM_RXQ_PD_FIFO_DATA_WIDTH)

  ) i_rxq_pd (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (rxq_pd_fifo_push[vc])
    ,.push_data             (rxq_pd_fifo_push_data[vc])
    ,.pop                   (rxq_pd_fifo_pop[vc])
    ,.pop_data_v            (rxq_pd_fifo_pop_data_v[vc])
    ,.pop_data              (rxq_pd_fifo_pop_data[vc])

    ,.mem_we                (rxq_pd_fifo_mem_we[vc])
    ,.mem_waddr             (rxq_pd_fifo_mem_waddr[vc])
    ,.mem_wdata             (rxq_pd_fifo_mem_wdata[vc])
    ,.mem_re                (rxq_pd_fifo_mem_re[vc])
    ,.mem_raddr             (rxq_pd_fifo_mem_raddr[vc])
    ,.mem_rdata             (rxq_pd_fifo_mem_rdata[vc])

    ,.fifo_status           (rxq_pd_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_RXQ_NPH_FIFO_DEPTH)
    ,.DWIDTH                (HQM_RXQ_NPH_FIFO_DATA_WIDTH)

  ) i_rxq_nph (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (rxq_nph_fifo_push[vc])
    ,.push_data             (rxq_nph_fifo_push_data[vc])
    ,.pop                   (rxq_nph_fifo_pop[vc])
    ,.pop_data_v            (rxq_nph_fifo_pop_data_v[vc])
    ,.pop_data              (rxq_nph_fifo_pop_data[vc])

    ,.mem_we                (rxq_nph_fifo_mem_we[vc])
    ,.mem_waddr             (rxq_nph_fifo_mem_waddr[vc])
    ,.mem_wdata             (rxq_nph_fifo_mem_wdata[vc])
    ,.mem_re                (rxq_nph_fifo_mem_re[vc])
    ,.mem_raddr             (rxq_nph_fifo_mem_raddr[vc])
    ,.mem_rdata             (rxq_nph_fifo_mem_rdata[vc])

    ,.fifo_status           (rxq_nph_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_RXQ_NPD_FIFO_DEPTH)
    ,.DWIDTH                (HQM_RXQ_NPD_FIFO_DATA_WIDTH)

  ) i_rxq_npd (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (rxq_npd_fifo_push[vc])
    ,.push_data             (rxq_npd_fifo_push_data[vc])
    ,.pop                   (rxq_npd_fifo_pop[vc])
    ,.pop_data_v            (rxq_npd_fifo_pop_data_v[vc])
    ,.pop_data              (rxq_npd_fifo_pop_data[vc])

    ,.mem_we                (rxq_npd_fifo_mem_we[vc])
    ,.mem_waddr             (rxq_npd_fifo_mem_waddr[vc])
    ,.mem_wdata             (rxq_npd_fifo_mem_wdata[vc])
    ,.mem_re                (rxq_npd_fifo_mem_re[vc])
    ,.mem_raddr             (rxq_npd_fifo_mem_raddr[vc])
    ,.mem_rdata             (rxq_npd_fifo_mem_rdata[vc])

    ,.fifo_status           (rxq_npd_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_RXQ_CPLH_FIFO_DEPTH)
    ,.DWIDTH                (HQM_RXQ_CPLH_FIFO_DATA_WIDTH)

  ) i_rxq_cplh (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (rxq_cplh_fifo_push[vc])
    ,.push_data             (rxq_cplh_fifo_push_data[vc])
    ,.pop                   (rxq_cplh_fifo_pop[vc])
    ,.pop_data_v            (rxq_cplh_fifo_pop_data_v[vc])
    ,.pop_data              (rxq_cplh_fifo_pop_data[vc])

    ,.mem_we                (rxq_cplh_fifo_mem_we[vc])
    ,.mem_waddr             (rxq_cplh_fifo_mem_waddr[vc])
    ,.mem_wdata             (rxq_cplh_fifo_mem_wdata[vc])
    ,.mem_re                (rxq_cplh_fifo_mem_re[vc])
    ,.mem_raddr             (rxq_cplh_fifo_mem_raddr[vc])
    ,.mem_rdata             (rxq_cplh_fifo_mem_rdata[vc])

    ,.fifo_status           (rxq_cplh_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_RXQ_CPLD_FIFO_DEPTH)
    ,.DWIDTH                (HQM_RXQ_CPLD_FIFO_DATA_WIDTH)

  ) i_rxq_cpld (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (rxq_cpld_fifo_push[vc])
    ,.push_data             (rxq_cpld_fifo_push_data[vc])
    ,.pop                   (rxq_cpld_fifo_pop[vc])
    ,.pop_data_v            (rxq_cpld_fifo_pop_data_v[vc])
    ,.pop_data              (rxq_cpld_fifo_pop_data[vc])

    ,.mem_we                (rxq_cpld_fifo_mem_we[vc])
    ,.mem_waddr             (rxq_cpld_fifo_mem_waddr[vc])
    ,.mem_wdata             (rxq_cpld_fifo_mem_wdata[vc])
    ,.mem_re                (rxq_cpld_fifo_mem_re[vc])
    ,.mem_raddr             (rxq_cpld_fifo_mem_raddr[vc])
    ,.mem_rdata             (rxq_cpld_fifo_mem_rdata[vc])

    ,.fifo_status           (rxq_cpld_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_RXQ_IOQ_FIFO_DEPTH)
    ,.DWIDTH                (HQM_RXQ_IOQ_FIFO_DATA_WIDTH)

  ) i_rxq_ioq (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (rxq_ioq_fifo_push[vc])
    ,.push_data             (rxq_ioq_fifo_push_data[vc])
    ,.pop                   (rxq_ioq_fifo_pop[vc])
    ,.pop_data_v            (rxq_ioq_fifo_pop_data_v[vc])
    ,.pop_data              (rxq_ioq_fifo_pop_data[vc])

    ,.mem_we                (rxq_ioq_fifo_mem_we[vc])
    ,.mem_waddr             (rxq_ioq_fifo_mem_waddr[vc])
    ,.mem_wdata             (rxq_ioq_fifo_mem_wdata[vc])
    ,.mem_re                (rxq_ioq_fifo_mem_re[vc])
    ,.mem_raddr             (rxq_ioq_fifo_mem_raddr[vc])
    ,.mem_rdata             (rxq_ioq_fifo_mem_rdata[vc])

    ,.fifo_status           (rxq_ioq_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  always_ff @(posedge prim_clk) begin

   if (  rxq_ph_fifo_mem_re[vc])   rxq_ph_fifo_mem_rdata[vc] <=   rxq_ph_fifo_mem[vc][  rxq_ph_fifo_mem_raddr[vc]];
   if (  rxq_pd_fifo_mem_re[vc])   rxq_pd_fifo_mem_rdata[vc] <=   rxq_pd_fifo_mem[vc][  rxq_pd_fifo_mem_raddr[vc]];
   if ( rxq_nph_fifo_mem_re[vc])  rxq_nph_fifo_mem_rdata[vc] <=  rxq_nph_fifo_mem[vc][ rxq_nph_fifo_mem_raddr[vc]];
   if ( rxq_npd_fifo_mem_re[vc])  rxq_npd_fifo_mem_rdata[vc] <=  rxq_npd_fifo_mem[vc][ rxq_npd_fifo_mem_raddr[vc]];
   if (rxq_cplh_fifo_mem_re[vc]) rxq_cplh_fifo_mem_rdata[vc] <= rxq_cplh_fifo_mem[vc][rxq_cplh_fifo_mem_raddr[vc]];
   if (rxq_cpld_fifo_mem_re[vc]) rxq_cpld_fifo_mem_rdata[vc] <= rxq_cpld_fifo_mem[vc][rxq_cpld_fifo_mem_raddr[vc]];
   if ( rxq_ioq_fifo_mem_re[vc])  rxq_ioq_fifo_mem_rdata[vc] <=  rxq_ioq_fifo_mem[vc][ rxq_ioq_fifo_mem_raddr[vc]];

   if (  rxq_ph_fifo_mem_we[vc])   rxq_ph_fifo_mem[vc][  rxq_ph_fifo_mem_waddr[vc]] <=   rxq_ph_fifo_mem_wdata[vc];
   if (  rxq_pd_fifo_mem_we[vc])   rxq_pd_fifo_mem[vc][  rxq_pd_fifo_mem_waddr[vc]] <=   rxq_pd_fifo_mem_wdata[vc];
   if ( rxq_nph_fifo_mem_we[vc])  rxq_nph_fifo_mem[vc][ rxq_nph_fifo_mem_waddr[vc]] <=  rxq_nph_fifo_mem_wdata[vc];
   if ( rxq_npd_fifo_mem_we[vc])  rxq_npd_fifo_mem[vc][ rxq_npd_fifo_mem_waddr[vc]] <=  rxq_npd_fifo_mem_wdata[vc];
   if (rxq_cplh_fifo_mem_we[vc]) rxq_cplh_fifo_mem[vc][rxq_cplh_fifo_mem_waddr[vc]] <= rxq_cplh_fifo_mem_wdata[vc];
   if (rxq_cpld_fifo_mem_we[vc]) rxq_cpld_fifo_mem[vc][rxq_cpld_fifo_mem_waddr[vc]] <= rxq_cpld_fifo_mem_wdata[vc];
   if ( rxq_ioq_fifo_mem_we[vc])  rxq_ioq_fifo_mem[vc][ rxq_ioq_fifo_mem_waddr[vc]] <=  rxq_ioq_fifo_mem_wdata[vc];

  end

 end
endgenerate

//-------------------------------------------------------------------------------------------------
// Arbitrate among the VCs with a valid transaction

always_comb begin

 // Considering a VC valid for arbitration if the IOQ has a valid entry, and for that flow class
 // the header FIFO has a valid entry (it must).  Need an IOSF request credit as well.
 // Does using the IOQ for strict ordering break relaxed ordering model that would allow a CplD with the
 // ro bit set (like an ATS response) getting around an earlier NP transaction?

 for (int vc=0; vc<HQM_SFI_TX_HDR_NUM_VCS; vc=vc+1) begin

  for (int fc=0; fc<3; fc=fc+1) begin

   rxq_arb_hcrd_avail[vc][fc] = (|iosf_req_crdt_cnt_q[vc][fc]);

  end // fc

  rxq_arb_reqs[vc] = rxq_ioq_fifo_pop_data_v[vc] &
   (((rxq_ioq_fifo_pop_data[vc] == 2'd0) &   rxq_ph_fifo_pop_data_v[vc] & rxq_arb_hcrd_avail[vc][0]) |
    ((rxq_ioq_fifo_pop_data[vc] == 2'd1) &  rxq_nph_fifo_pop_data_v[vc] & rxq_arb_hcrd_avail[vc][1]) |
    ((rxq_ioq_fifo_pop_data[vc] == 2'd2) & rxq_cplh_fifo_pop_data_v[vc] & rxq_arb_hcrd_avail[vc][2]));

 end // vc

end

hqm_AW_rr_arbiter #(.NUM_REQS(HQM_SFI_TX_HDR_NUM_VCS)) i_rxq_arb (

     .clk           (prim_clk)
    ,.rst_n         (prim_gated_rst_b)

    ,.mode          (2'd2)
    ,.update        (rxq_arb_update)

    ,.reqs          (rxq_arb_reqs)

    ,.winner_v      (rxq_arb_v)
    ,.winner        (rxq_arb_vc)
);

always_comb begin

 // Fields for the RXQ arbitration winner

 rxq_arb_fc = hqm_sfi_fc_id_t'(rxq_ioq_fifo_pop_data[rxq_arb_vc]);

 case (rxq_arb_fc)

  2'd2: begin
         rxq_arb_hdr                     = rxq_cplh_fifo_pop_data[rxq_arb_vc];
        {rxq_arb_data_par, rxq_arb_data} = rxq_cpld_fifo_pop_data[rxq_arb_vc];
  end
  2'd1: begin
         rxq_arb_hdr                     = rxq_nph_fifo_pop_data[rxq_arb_vc];
        {rxq_arb_data_par, rxq_arb_data} = rxq_npd_fifo_pop_data[rxq_arb_vc];
  end
  default: begin
         rxq_arb_hdr                     = rxq_ph_fifo_pop_data[rxq_arb_vc];
        {rxq_arb_data_par, rxq_arb_data} = rxq_pd_fifo_pop_data[rxq_arb_vc];
  end

 endcase

end

//-----------------------------------------------------------------------------------------------------
// IOSF requests

always_comb begin

 iosf_req_next      = '0;

 rxq_arb_update     = '0;

 rxq_ph_fifo_pop    = '0;
 rxq_nph_fifo_pop   = '0;
 rxq_cplh_fifo_pop  = '0;
 rxq_ioq_fifo_pop   = '0;

 rx_hcrd_return_v   = '0;
 rx_hcrd_return_vc  = '0;
 rx_hcrd_return_fc  = hqm_sfi_fc_id_t'('0);
 rx_hcrd_return_val = '0;

 if (rxq_arb_v & (prim_ism_fabric == 3'd3)) begin

  iosf_req_next.put    = '1;
  iosf_req_next.chid   = rxq_arb_vc;
  iosf_req_next.rtype  = rxq_arb_fc;
  iosf_req_next.cdata  = rxq_arb_hdr.mem.fmt[1];
  iosf_req_next.dlen   = rxq_arb_hdr.mem.length;
  iosf_req_next.id     = rxq_arb_hdr.mem.reqid;
  iosf_req_next.ido    = rxq_arb_hdr.mem.ido;
  iosf_req_next.ro     = rxq_arb_hdr.mem.ro;
  iosf_req_next.ns     = rxq_arb_hdr.mem.ns;
  iosf_req_next.tc     = rxq_arb_hdr.mem.tc;
  iosf_req_next.locked = (hqm_sfi_pcie_cmd_t'({rxq_arb_hdr.mem.fmt[1:0], rxq_arb_hdr.mem.ttype}) == PCIE_CMD_CPLLK);

  // Pop the appropriate header FIFO and the IOQ FIFO

  rxq_ph_fifo_pop[  rxq_arb_vc] = (rxq_arb_fc == 2'd0);
  rxq_nph_fifo_pop[ rxq_arb_vc] = (rxq_arb_fc == 2'd1);
  rxq_cplh_fifo_pop[rxq_arb_vc] = (rxq_arb_fc == 2'd2);
  rxq_ioq_fifo_pop[ rxq_arb_vc] = '1;

  rxq_arb_update       = '1;

  // Return request credit

  rx_hcrd_return_v   = '1;
  rx_hcrd_return_vc  = rxq_arb_vc;
  rx_hcrd_return_fc  = rxq_arb_fc;
  rx_hcrd_return_val = {{(HQM_SFI_RX_NHCRD-1){1'b0}}, 1'b1};

 end

end

always_ff @(posedge prim_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  iosf_req_q <= '0;
 end else begin
  iosf_req_q <= iosf_req_next;
 end
end

always_comb begin

 req_agent   = '0;
 req_chain   = '0;
 req_dest_id = '0;
 req_opp     = '0;
 req_rs      = '0;

 req_put     = iosf_req_q.put;
 req_chid    = iosf_req_q.chid;
 req_cdata   = iosf_req_q.cdata;
 req_dlen    = iosf_req_q.dlen;
 req_id      = iosf_req_q.id;
 req_ido     = iosf_req_q.ido;
 req_ro      = iosf_req_q.ro;
 req_ns      = iosf_req_q.ns;
 req_locked  = iosf_req_q.locked;
 req_rtype   = iosf_req_q.rtype;
 req_tc      = iosf_req_q.tc;

end

//-----------------------------------------------------------------------------------------------------
// IOSF Master Request Queues

localparam int unsigned HQM_REQ_PH_FIFO_DEPTH         = 16;
localparam int unsigned HQM_REQ_NPH_FIFO_DEPTH        = 16;
localparam int unsigned HQM_REQ_CPLH_FIFO_DEPTH       = 16;

localparam int unsigned HQM_REQ_PH_FIFO_ADDR_WIDTH    = $clog2(HQM_REQ_PH_FIFO_DEPTH);
localparam int unsigned HQM_REQ_NPH_FIFO_ADDR_WIDTH   = $clog2(HQM_REQ_NPH_FIFO_DEPTH);
localparam int unsigned HQM_REQ_CPLH_FIFO_ADDR_WIDTH  = $clog2(HQM_REQ_CPLH_FIFO_DEPTH);

localparam int unsigned HQM_REQ_PH_FIFO_DATA_WIDTH    = 160;      // 128b hdr  + 1b par + 23b pasid + 8b sai
localparam int unsigned HQM_REQ_NPH_FIFO_DATA_WIDTH   = 160;      // 128b hdr  + 1b par + 23b pasid + 8b sai
localparam int unsigned HQM_REQ_CPLH_FIFO_DATA_WIDTH  = 160;      // 128b hdr  + 1b par + 23b pasid + 8b sai

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_ph_fifo_push;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             req_ph_fifo_push_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_ph_fifo_pop;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_ph_fifo_pop_data_v;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             req_ph_fifo_pop_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][31:0]                                req_ph_fifo_status;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_ph_fifo_mem_we;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_PH_FIFO_ADDR_WIDTH-1:0]      req_ph_fifo_mem_waddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_PH_FIFO_DATA_WIDTH-1:0]      req_ph_fifo_mem_wdata;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_ph_fifo_mem_re;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_PH_FIFO_ADDR_WIDTH-1:0]      req_ph_fifo_mem_raddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_PH_FIFO_DATA_WIDTH-1:0]      req_ph_fifo_mem_rdata;
logic [HQM_REQ_PH_FIFO_DATA_WIDTH-1:0]                                  req_ph_fifo_mem[HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_PH_FIFO_DEPTH-1:0];

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_nph_fifo_push;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             req_nph_fifo_push_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_nph_fifo_pop;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_nph_fifo_pop_data_v;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             req_nph_fifo_pop_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][31:0]                                req_nph_fifo_status;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_nph_fifo_mem_we;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_NPH_FIFO_ADDR_WIDTH-1:0]     req_nph_fifo_mem_waddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_NPH_FIFO_DATA_WIDTH-1:0]     req_nph_fifo_mem_wdata;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_nph_fifo_mem_re;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_NPH_FIFO_ADDR_WIDTH-1:0]     req_nph_fifo_mem_raddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_NPH_FIFO_DATA_WIDTH-1:0]     req_nph_fifo_mem_rdata;
logic [HQM_REQ_NPH_FIFO_DATA_WIDTH-1:0]                                 req_nph_fifo_mem[HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_NPH_FIFO_DEPTH-1:0];

logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_cplh_fifo_push;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             req_cplh_fifo_push_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_cplh_fifo_pop;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_cplh_fifo_pop_data_v;
hqm_iosf_hdr_t [HQM_SFI_TX_HDR_NUM_VCS-1:0]                             req_cplh_fifo_pop_data;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][31:0]                                req_cplh_fifo_status;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_cplh_fifo_mem_we;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_CPLH_FIFO_ADDR_WIDTH-1:0]    req_cplh_fifo_mem_waddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_CPLH_FIFO_DATA_WIDTH-1:0]    req_cplh_fifo_mem_wdata;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0]                                      req_cplh_fifo_mem_re;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_CPLH_FIFO_ADDR_WIDTH-1:0]    req_cplh_fifo_mem_raddr;
logic [HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_CPLH_FIFO_DATA_WIDTH-1:0]    req_cplh_fifo_mem_rdata;
logic [HQM_REQ_CPLH_FIFO_DATA_WIDTH-1:0]                                req_cplh_fifo_mem[HQM_SFI_TX_HDR_NUM_VCS-1:0][HQM_REQ_CPLH_FIFO_DEPTH-1:0];

generate
 for (genvar vc=0; vc<HQM_SFI_TX_HDR_NUM_VCS; vc=vc+1) begin: g_vc_req

  always_comb begin

   req_ph_fifo_push[       vc] = rxq_ph_fifo_pop[  vc];
   req_nph_fifo_push[      vc] = rxq_nph_fifo_pop[ vc];
   req_cplh_fifo_push[     vc] = rxq_cplh_fifo_pop[vc];

   req_ph_fifo_push_data[  vc] = rxq_arb_hdr;
   req_nph_fifo_push_data[ vc] = rxq_arb_hdr;
   req_cplh_fifo_push_data[vc] = rxq_arb_hdr;

  end

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_REQ_PH_FIFO_DEPTH)
    ,.DWIDTH                (HQM_REQ_PH_FIFO_DATA_WIDTH)

  ) i_req_ph (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (req_ph_fifo_push[vc])
    ,.push_data             (req_ph_fifo_push_data[vc])
    ,.pop                   (req_ph_fifo_pop[vc])
    ,.pop_data_v            (req_ph_fifo_pop_data_v[vc])
    ,.pop_data              (req_ph_fifo_pop_data[vc])

    ,.mem_we                (req_ph_fifo_mem_we[vc])
    ,.mem_waddr             (req_ph_fifo_mem_waddr[vc])
    ,.mem_wdata             (req_ph_fifo_mem_wdata[vc])
    ,.mem_re                (req_ph_fifo_mem_re[vc])
    ,.mem_raddr             (req_ph_fifo_mem_raddr[vc])
    ,.mem_rdata             (req_ph_fifo_mem_rdata[vc])

    ,.fifo_status           (req_ph_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_REQ_NPH_FIFO_DEPTH)
    ,.DWIDTH                (HQM_REQ_NPH_FIFO_DATA_WIDTH)

  ) i_req_nph (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (req_nph_fifo_push[vc])
    ,.push_data             (req_nph_fifo_push_data[vc])
    ,.pop                   (req_nph_fifo_pop[vc])
    ,.pop_data_v            (req_nph_fifo_pop_data_v[vc])
    ,.pop_data              (req_nph_fifo_pop_data[vc])

    ,.mem_we                (req_nph_fifo_mem_we[vc])
    ,.mem_waddr             (req_nph_fifo_mem_waddr[vc])
    ,.mem_wdata             (req_nph_fifo_mem_wdata[vc])
    ,.mem_re                (req_nph_fifo_mem_re[vc])
    ,.mem_raddr             (req_nph_fifo_mem_raddr[vc])
    ,.mem_rdata             (req_nph_fifo_mem_rdata[vc])

    ,.fifo_status           (req_nph_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  hqm_AW_fifo_control_wreg #(

     .DEPTH                 (HQM_REQ_CPLH_FIFO_DEPTH)
    ,.DWIDTH                (HQM_REQ_CPLH_FIFO_DATA_WIDTH)

  ) i_req_cplh (

     .clk                   (prim_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)                        // unused

    ,.push                  (req_cplh_fifo_push[vc])
    ,.push_data             (req_cplh_fifo_push_data[vc])
    ,.pop                   (req_cplh_fifo_pop[vc])
    ,.pop_data_v            (req_cplh_fifo_pop_data_v[vc])
    ,.pop_data              (req_cplh_fifo_pop_data[vc])

    ,.mem_we                (req_cplh_fifo_mem_we[vc])
    ,.mem_waddr             (req_cplh_fifo_mem_waddr[vc])
    ,.mem_wdata             (req_cplh_fifo_mem_wdata[vc])
    ,.mem_re                (req_cplh_fifo_mem_re[vc])
    ,.mem_raddr             (req_cplh_fifo_mem_raddr[vc])
    ,.mem_rdata             (req_cplh_fifo_mem_rdata[vc])

    ,.fifo_status           (req_cplh_fifo_status[vc])
    ,.fifo_full             ()                          // unused
    ,.fifo_afull            ()                          // unused
  );

  always_ff @(posedge prim_clk) begin

   if (  req_ph_fifo_mem_re[vc])   req_ph_fifo_mem_rdata[vc] <=   req_ph_fifo_mem[vc][  req_ph_fifo_mem_raddr[vc]];
   if ( req_nph_fifo_mem_re[vc])  req_nph_fifo_mem_rdata[vc] <=  req_nph_fifo_mem[vc][ req_nph_fifo_mem_raddr[vc]];
   if (req_cplh_fifo_mem_re[vc]) req_cplh_fifo_mem_rdata[vc] <= req_cplh_fifo_mem[vc][req_cplh_fifo_mem_raddr[vc]];

   if (  req_ph_fifo_mem_we[vc])   req_ph_fifo_mem[vc][  req_ph_fifo_mem_waddr[vc]] <=   req_ph_fifo_mem_wdata[vc];
   if ( req_nph_fifo_mem_we[vc])  req_nph_fifo_mem[vc][ req_nph_fifo_mem_waddr[vc]] <=  req_nph_fifo_mem_wdata[vc];
   if (req_cplh_fifo_mem_we[vc]) req_cplh_fifo_mem[vc][req_cplh_fifo_mem_waddr[vc]] <= req_cplh_fifo_mem_wdata[vc];

  end

 end
endgenerate

//-----------------------------------------------------------------------------------------------------
// Register the IOSF grants

always_comb begin
 iosf_gnt_next.gnt   = gnt;
 iosf_gnt_next.chid  = gnt_chid;
 iosf_gnt_next.rtype = gnt_rtype;
 iosf_gnt_next.gtype = gnt_type;
end

always_ff @(posedge prim_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  iosf_gnt_q <= '0;
 end else begin
  iosf_gnt_q <= iosf_gnt_next;
 end
end

//-----------------------------------------------------------------------------------------------------
// IOSF Master Command

always_comb begin

 req_ph_fifo_pop    = '0;
 req_nph_fifo_pop   = '0;
 req_cplh_fifo_pop  = '0;

 iosf_req_hdr_out   = '0;

 if (iosf_gnt_q.gnt & (iosf_gnt_q.gtype == 2'd0)) begin

  case (iosf_gnt_q.rtype)

   2'd2: begin
    iosf_req_hdr_out = req_cplh_fifo_pop_data[iosf_gnt_q.chid];
    req_cplh_fifo_pop[iosf_gnt_q.chid] = '1;
   end

   2'd1: begin
    iosf_req_hdr_out = req_nph_fifo_pop_data[iosf_gnt_q.chid];
    req_nph_fifo_pop[iosf_gnt_q.chid] = '1;
   end

   default: begin
    iosf_req_hdr_out = req_ph_fifo_pop_data[iosf_gnt_q.chid];
    req_ph_fifo_pop[iosf_gnt_q.chid] = '1;
   end

  endcase

 end

 // Bus is 32B wide.  There would be a max of 16 beats for a 512B transaction.
 // We should only ever have a max of 1 CL (64B) though.

 iosf_req_data_crds = '0;

 if (iosf_req_hdr_out.mem.fmt[1]) begin

  iosf_req_data_crds = (iosf_req_hdr_out.mem.length > 10'd124) ? 6'd32 :
                      ((iosf_req_hdr_out.mem.length > 10'd120) ? 6'd31 :
                      ((iosf_req_hdr_out.mem.length > 10'd116) ? 6'd30 :
                      ((iosf_req_hdr_out.mem.length > 10'd112) ? 6'd29 :
                      ((iosf_req_hdr_out.mem.length > 10'd108) ? 6'd28 :
                      ((iosf_req_hdr_out.mem.length > 10'd104) ? 6'd27 :
                      ((iosf_req_hdr_out.mem.length > 10'd100) ? 6'd26 :
                      ((iosf_req_hdr_out.mem.length > 10'd96 ) ? 6'd25 :
                      ((iosf_req_hdr_out.mem.length > 10'd92 ) ? 6'd24 :
                      ((iosf_req_hdr_out.mem.length > 10'd88 ) ? 6'd23 :
                      ((iosf_req_hdr_out.mem.length > 10'd84 ) ? 6'd22 :
                      ((iosf_req_hdr_out.mem.length > 10'd80 ) ? 6'd21 :
                      ((iosf_req_hdr_out.mem.length > 10'd76 ) ? 6'd20 :
                      ((iosf_req_hdr_out.mem.length > 10'd72 ) ? 6'd19 :
                      ((iosf_req_hdr_out.mem.length > 10'd68 ) ? 6'd18 :
                      ((iosf_req_hdr_out.mem.length > 10'd64 ) ? 6'd17 :
                      ((iosf_req_hdr_out.mem.length > 10'd60 ) ? 6'd16 :
                      ((iosf_req_hdr_out.mem.length > 10'd56 ) ? 6'd15 :
                      ((iosf_req_hdr_out.mem.length > 10'd52 ) ? 6'd14 :
                      ((iosf_req_hdr_out.mem.length > 10'd48 ) ? 6'd13 :
                      ((iosf_req_hdr_out.mem.length > 10'd44 ) ? 6'd12 :
                      ((iosf_req_hdr_out.mem.length > 10'd40 ) ? 6'd11 :
                      ((iosf_req_hdr_out.mem.length > 10'd36 ) ? 6'd10 :
                      ((iosf_req_hdr_out.mem.length > 10'd32 ) ? 6'd9  :
                      ((iosf_req_hdr_out.mem.length > 10'd28 ) ? 6'd8  :
                      ((iosf_req_hdr_out.mem.length > 10'd24 ) ? 6'd7  :
                      ((iosf_req_hdr_out.mem.length > 10'd20 ) ? 6'd6  :
                      ((iosf_req_hdr_out.mem.length > 10'd16 ) ? 6'd5  :
                      ((iosf_req_hdr_out.mem.length > 10'd12 ) ? 6'd4  :
                      ((iosf_req_hdr_out.mem.length > 10'd8  ) ? 6'd3  :
                      ((iosf_req_hdr_out.mem.length > 10'd4  ) ? 6'd2  :
                                                                 6'd1))))))))))))))))))))))))))))));
 end

 mpasidtlp = iosf_req_hdr_out.mem.pasidtlp;
 msai      = iosf_req_hdr_out.mem.sai;

 mfmt      = iosf_req_hdr_out.mem.fmt;
 mtype     = iosf_req_hdr_out.mem.ttype;
 mrsvd1_7  = iosf_req_hdr_out.mem.tag9;
 mtc       = iosf_req_hdr_out.mem.tc;
 mrsvd1_3  = iosf_req_hdr_out.mem.tag8;
 mido      = iosf_req_hdr_out.mem.ido;
 mth       = iosf_req_hdr_out.mem.th;
 mtd       = iosf_req_hdr_out.mem.td;
 mro       = iosf_req_hdr_out.mem.ro;
 mns       = iosf_req_hdr_out.mem.ns;
 mep       = iosf_req_hdr_out.mem.ep;
 mat       = iosf_req_hdr_out.mem.at;
 mlength   = iosf_req_hdr_out.mem.length;
 mcparity  = iosf_req_hdr_out.mem.parity;

 mpcie_cmd = hqm_sfi_pcie_cmd_t'({iosf_req_hdr_out.mem.fmt, iosf_req_hdr_out.mem.ttype});

 case (mpcie_cmd)

  PCIE_CMD_CPL,
  PCIE_CMD_CPLD,
  PCIE_CMD_CPLLK: begin

   mlbe      =  iosf_req_hdr_out.cpl.bc[3:0];
   mfbe      = {iosf_req_hdr_out.cpl.bcm
               ,iosf_req_hdr_out.cpl.cpl_status
               };
   mrqid     =  iosf_req_hdr_out.cpl.reqid;
   mtag      =  iosf_req_hdr_out.cpl.tag;
   maddress  = {32'd0
               ,iosf_req_hdr_out.cpl.cplid
               ,iosf_req_hdr_out.cpl.bc[11:4]
               ,iosf_req_hdr_out.cpl.rsvd7
               ,iosf_req_hdr_out.cpl.laddr
               };

  end

  default: begin

   mlbe      = iosf_req_hdr_out.mem.lbe;
   mfbe      = iosf_req_hdr_out.mem.fbe;
   mrqid     = iosf_req_hdr_out.mem.reqid;
   mtag      = iosf_req_hdr_out.mem.tag;
   maddress  = iosf_req_hdr_out.mem.address;

  end

 endcase

end

//-----------------------------------------------------------------------------------------------------
// IOSF Master Data

always_comb begin

 rxq_pd_fifo_pop        = '0;
 rxq_npd_fifo_pop       = '0;
 rxq_cpld_fifo_pop      = '0;

 iosf_req_data_out_next = '0;
 iosf_req_data_cnt_next = '0;
 iosf_req_data_vc_next  = iosf_req_data_vc_q;
 iosf_req_data_fc_next  = iosf_req_data_fc_q;

 rx_dcrd_return_v       = '0;
 rx_dcrd_return_vc      = '0;
 rx_dcrd_return_fc      = hqm_sfi_fc_id_t'('0);
 rx_dcrd_return_val     = '0;

 iosf_req_data_v_next   = (|iosf_req_data_cnt_q) |
  (iosf_gnt_q.gnt & (iosf_gnt_q.gtype == 2'd0) & iosf_req_hdr_out.mem.fmt[1]);

 if (iosf_req_data_v_next) begin // Send data

  if (|iosf_req_data_cnt_q) begin // More data

   iosf_req_data_vc = iosf_req_data_vc_q;
   iosf_req_data_fc = iosf_req_data_fc_q;

   iosf_req_data_cnt_next = (iosf_req_data_cnt_q <= DATA_1_BEAT_DCRDS[5:0]) ? 6'd0 :
                                                    (iosf_req_data_cnt_q - DATA_1_BEAT_DCRDS[5:0]);

   rx_dcrd_return_v        = '1;
   rx_dcrd_return_vc       = iosf_req_data_vc_q;
   rx_dcrd_return_fc       = iosf_req_data_fc_q;
   rx_dcrd_return_val      = (iosf_req_data_cnt_q >= DATA_1_BEAT_DCRDS[5:0]) ?
                                DATA_1_BEAT_DCRDS[ HQM_SFI_RX_NDCRD-1:0] :
                                iosf_req_data_crds[HQM_SFI_RX_NDCRD-1:0];

  end // More data

  else begin // First data

   iosf_req_data_vc        = iosf_gnt_q.chid;
   iosf_req_data_fc        = hqm_sfi_fc_id_t'(iosf_gnt_q.rtype);

   iosf_req_data_vc_next   = iosf_req_data_vc;
   iosf_req_data_fc_next   = iosf_req_data_fc;

  {iosf_req_data_cnt_nc
  ,iosf_req_data_cnt_next} = (iosf_req_data_crds <= DATA_1_BEAT_DCRDS[5:0]) ? 6'd0 :
                                (iosf_req_data_crds - DATA_1_BEAT_DCRDS[5:0]);

   rx_dcrd_return_v        = '1;
   rx_dcrd_return_vc       = iosf_gnt_q.chid;
   rx_dcrd_return_fc       = hqm_sfi_fc_id_t'(iosf_gnt_q.rtype);
   rx_dcrd_return_val      = (iosf_req_data_crds >= DATA_1_BEAT_DCRDS[5:0]) ?
                                DATA_1_BEAT_DCRDS[ HQM_SFI_RX_NDCRD-1:0] :
                                iosf_req_data_crds[HQM_SFI_RX_NDCRD-1:0];

  end // First data

  // Select data next and pop the appropriate data FIFO

  case (iosf_req_data_fc)

   2'd2: begin
    iosf_req_data_out_next = rxq_cpld_fifo_pop_data[iosf_req_data_vc];
    rxq_cpld_fifo_pop[iosf_req_data_vc] = '1;
   end

   2'd1: begin
    iosf_req_data_out_next = rxq_npd_fifo_pop_data[iosf_req_data_vc];
    rxq_npd_fifo_pop[iosf_req_data_vc] = '1;
   end

   default: begin
    iosf_req_data_out_next = rxq_pd_fifo_pop_data[iosf_req_data_vc];
    rxq_pd_fifo_pop[iosf_req_data_vc] = '1;
   end
  endcase

 end // Send data

end

always_ff @(posedge prim_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  iosf_req_data_out_q <= '0;
  iosf_req_data_cnt_q <= '0;
 end else begin
  iosf_req_data_out_q <= iosf_req_data_out_next;
  iosf_req_data_cnt_q <= iosf_req_data_cnt_next;
 end
end

always_ff @(posedge prim_clk) begin
  iosf_req_data_vc_q <= iosf_req_data_vc_next;
  iosf_req_data_fc_q <= iosf_req_data_fc_next;
end

always_comb begin

 {mdparity, mdata} = iosf_req_data_out_q;

end

//-----------------------------------------------------------------------------------------------------
// IOSF Master Credits

always_comb begin

 iosf_req_crdt_cnt_inc = '0;
 iosf_req_crdt_cnt_dec = '0;

 if (iosf_gnt_q.gnt & ((iosf_gnt_q.gtype == 2'd0) | (iosf_gnt_q.gtype == 2'd2))) begin
  iosf_req_crdt_cnt_inc[iosf_gnt_q.chid][iosf_gnt_q.rtype] = '1;
 end

 for (int vc=0; vc<HQM_SFI_TX_HDR_NUM_VCS; vc=vc+1) begin

  iosf_req_crdt_cnt_dec[vc][0] =   req_ph_fifo_push[vc];
  iosf_req_crdt_cnt_dec[vc][1] =  req_nph_fifo_push[vc];
  iosf_req_crdt_cnt_dec[vc][2] = req_cplh_fifo_push[vc];

  for (int fc=0; fc<3; fc=fc+1) begin

   case({iosf_req_crdt_cnt_inc[vc][fc], iosf_req_crdt_cnt_dec[vc][fc]})

    2'b10:   iosf_req_crdt_cnt_next[vc][fc] = iosf_req_crdt_cnt_q[vc][fc] + 6'd1;
    2'b01:   iosf_req_crdt_cnt_next[vc][fc] = iosf_req_crdt_cnt_q[vc][fc] - 6'd1;
    default: iosf_req_crdt_cnt_next[vc][fc] = iosf_req_crdt_cnt_q[vc][fc];

   endcase

  end
 end

end

always_ff @(posedge prim_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  iosf_req_crdt_cnt_q <= '0;
 end else begin
  iosf_req_crdt_cnt_q <= iosf_req_crdt_cnt_next;
 end
end

//-----------------------------------------------------------------------------------------------------

always_comb begin

 fabric_np_cnt_inc = '0;
 fabric_np_cnt_dec = '0;

 // Increment per VC NP counter on NP put and decrement on CPL request

 if (iosf_cmd_put_q & (iosf_cmd_rtype_q == 2'd1)) begin
  fabric_np_cnt_inc[iosf_cmd_chid_q] = '1;
 end

 if (iosf_req_q.put & (iosf_req_q.rtype == 2'd2)) begin
  fabric_np_cnt_dec[iosf_req_q.chid] = '1;
 end

 for (int vc=0; vc<HQM_SFI_RX_HDR_NUM_VCS; vc=vc+1) begin

  case ({fabric_np_cnt_inc[vc], fabric_np_cnt_dec[vc]})
   2'b10:   fabric_np_cnt_next[vc] = fabric_np_cnt_q[vc] + {{(HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1){1'b0}}, 1'b1};
   2'b01:   fabric_np_cnt_next[vc] = fabric_np_cnt_q[vc] - {{(HQM_SFI_RX_MAX_CRD_CNT_WIDTH-1){1'b0}}, 1'b1};
   default: fabric_np_cnt_next[vc] = fabric_np_cnt_q[vc];
  endcase

 end

 fabric_np_pending = (|fabric_np_cnt_q);

end

always_ff @(posedge prim_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  fabric_np_cnt_q <= '0;
 end else begin
  fabric_np_cnt_q <= fabric_np_cnt_next;
 end
end

//-----------------------------------------------------------------------------------------------------
// IOSF ISM

logic                               bridge_idle;
logic                               iosf_idle;
logic                               agent_clkreq;
logic                               tgt_has_unret_credits;
logic                               prim_clkreq_gcgu;
logic [3:0]                         pgcb_cnt_q;
logic                               prim_clkreq_q;

always_ff @(posedge iosf_pgcb_clk or negedge pgcb_prim_rst_b) begin
 if (~pgcb_prim_rst_b) begin
  pgcb_cnt_q <= '0;
 end else if (~(&pgcb_cnt_q)) begin
  pgcb_cnt_q <= pgcb_cnt_q + 4'd1;
 end
end

always_comb begin

 prim_clkreq  = &{prim_clkreq_gcgu, pgcb_cnt_q};

end

hqm_AW_sync_rst0 i_prim_clkreq_q (

     .clk           (prim_clk)
    ,.rst_n         (prim_gated_rst_b)
    ,.data          (prim_clkreq)
    ,.data_sync     (prim_clkreq_q)
);


always_ff @(posedge prim_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  prim_pok <= '0;
 end else if (prim_clkreq_q) begin
  prim_pok <= '1;
 end
end

always_comb begin

  agent_rxqs_empty      = '0;

  tgt_has_unret_credits = |{iosf_cmd_put_q
                           ,iosf_cmd_data_vld_q
                           ,txq_ph_fifo_pop_data_v
                           ,txq_pd_fifo_pop_data_v
                           ,txq_nph_fifo_pop_data_v
                           ,txq_npd_fifo_pop_data_v
                           ,txq_cplh_fifo_pop_data_v
                           ,txq_cpld_fifo_pop_data_v
                           };

  iosf_idle             = ~|{credit_put_q
                            ,tgt_has_unret_credits
                            ,fabric_np_pending
                            ,agent_rx_hdr_v
                            ,rxq_ph_fifo_pop_data_v
                            ,rxq_pd_fifo_pop_data_v
                            ,rxq_nph_fifo_pop_data_v
                            ,rxq_npd_fifo_pop_data_v
                            ,rxq_cplh_fifo_pop_data_v
                            ,rxq_cpld_fifo_pop_data_v
                            ,req_ph_fifo_pop_data_v
                            ,req_nph_fifo_pop_data_v
                            ,req_cplh_fifo_pop_data_v
                            ,iosf_req_data_cnt_q
                            };

  bridge_idle           = iosf_idle & sfi_rx_idle & sfi_tx_idle;

  agent_clkreq          = ~(agent_idle & bridge_idle);

end

hqm_iosf_gcgu i_hqm_iosf_gcgu (

     .prim_freerun_clk        (prim_clk)
    ,.prim_gated_rst_b        (prim_gated_rst_b)
    ,.prim_nonflr_clk         (prim_clk)

    ,.flr_treatment           ('0)

    ,.csr_clkgaten            ('1)
    ,.csr_idlecnt             (8'd16)

    ,.ism_fabric              (prim_ism_fabric)
    ,.ism_agent               (prim_ism_agent)
    ,.prim_clkreq             (prim_clkreq_gcgu)
    ,.prim_clkack             (prim_clkack)

    ,.agent_idle              (iosf_idle)
    ,.agent_clkreq            (agent_clkreq)
    ,.agent_clkreq_async      ('0)
    ,.tgt_has_unret_credits   (tgt_has_unret_credits)

    ,.credit_init             (credit_init)
    ,.credit_init_done        (credit_init_done_q)

    ,.prim_pok                (prim_pok)
    ,.prim_ism_lock_b         ('1)

    ,.force_notidle           ('0)
    ,.force_idle              ('0)
    ,.force_clkreq            ('0)
    ,.force_creditreq         ('0)

    ,.dfx_scanrstbypen        ('0)
    ,.dfx_scanrst_b           ('1)
);

endmodule // hqm_sfi2iosf


