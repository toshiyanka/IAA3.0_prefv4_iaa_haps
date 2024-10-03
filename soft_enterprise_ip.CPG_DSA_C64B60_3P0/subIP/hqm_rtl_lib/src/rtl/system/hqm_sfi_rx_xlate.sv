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

module hqm_sfi_rx_xlate

  import hqm_sfi_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*, hqm_system_func_pkg::*;
#(

//`include "hqm_sfi_params.sv"

    parameter HQM_SFI_RX_BCM_EN                = 1,     // Fixed
    parameter HQM_SFI_RX_BLOCK_EARLY_VLD_EN    = 1,    // Fixed
    parameter HQM_SFI_RX_D                     = 32,    // Fixed
    parameter HQM_SFI_RX_DATA_AUX_PARITY_EN    = 1,     // Fixed
    parameter HQM_SFI_RX_DATA_CRD_GRAN         = 4,     // Fixed
    parameter HQM_SFI_RX_DATA_INTERLEAVE       = 0,     // Fixed
    parameter HQM_SFI_RX_DATA_LAYER_EN         = 1,     // Fixed
    parameter HQM_SFI_RX_DATA_PARITY_EN        = 1,     // Fixed
    parameter HQM_SFI_RX_DATA_PASS_HDR         = 0,     // Fixed
    parameter HQM_SFI_RX_DATA_MAX_FC_VC        = 1,     // Fixed
    parameter HQM_SFI_RX_DS                    = 1,     // Fixed
    parameter HQM_SFI_RX_ECRC_SUPPORT          = 0,     // Fixed
    parameter HQM_SFI_RX_FLIT_MODE_PREFIX_EN   = 0 ,    // Fixed
    parameter HQM_SFI_RX_FATAL_EN              = 0,     // Fixed
    parameter HQM_SFI_RX_H                     = 32,    // Fixed
    parameter HQM_SFI_RX_HDR_DATA_SEP          = 1 ,    // Fixed
    parameter HQM_SFI_RX_HDR_MAX_FC_VC         = 1 ,    // Fixed
    parameter HQM_SFI_RX_HGRAN                 = 4,     // Fixed
    parameter HQM_SFI_RX_HPARITY               = 1,     // Fixed
    parameter HQM_SFI_RX_IDE_SUPPORT           = 0,    // Fixed
    parameter HQM_SFI_RX_M                     = 1,    // Fixed
    parameter HQM_SFI_RX_MAX_CRD_CNT_WIDTH     = 12,    // Fixed: Width of agent RX credit counters
    parameter HQM_SFI_RX_MAX_HDR_WIDTH         = 32 ,   // Fixed
    parameter HQM_SFI_RX_NDCRD                 = 4 ,    // Fabric data   credit return value width
    parameter HQM_SFI_RX_NHCRD                 = 4 ,    // Fabric header credit return value width
    parameter HQM_SFI_RX_NUM_SHARED_POOLS      = 0 ,    // Fixed
    parameter HQM_SFI_RX_PCIE_MERGED_SELECT    = 0 ,    // Fixed
    parameter HQM_SFI_RX_PCIE_SHARED_SELECT    = 0 ,    // Fixed
    parameter HQM_SFI_RX_RBN                   = 3 ,    // Fixed
    parameter HQM_SFI_RX_SH_DATA_CRD_BLK_SZ    = 1 ,    // Fixed
    parameter HQM_SFI_RX_SH_HDR_CRD_BLK_SZ     = 1 ,    // Fixed
    parameter HQM_SFI_RX_SHARED_CREDIT_EN      = 0 ,    // Fixed
    parameter HQM_SFI_RX_TBN                   = 1 ,    // Cycles after agent hdr/data_block is received before fabric TX stalls
    parameter HQM_SFI_RX_TX_CRD_REG            = 1 ,    // Fixed
    parameter HQM_SFI_RX_VIRAL_EN              = 0 ,    // Fixed
    parameter HQM_SFI_RX_VR                    = 0  ,   // Fixed
    parameter HQM_SFI_RX_VT                    = 0  ,   // Fixed

    parameter HQM_SFI_TX_BCM_EN                = 1 ,   // Fixed
    parameter HQM_SFI_TX_BLOCK_EARLY_VLD_EN    = 1 ,    // Fixed
    parameter HQM_SFI_TX_D                     = 32 ,   // Fixed
    parameter HQM_SFI_TX_DATA_AUX_PARITY_EN    = 1 ,    // Fixed
    parameter HQM_SFI_TX_DATA_CRD_GRAN         = 4 ,    // Fixed
    parameter HQM_SFI_TX_DATA_INTERLEAVE       = 0 ,    // Fixed
    parameter HQM_SFI_TX_DATA_LAYER_EN         = 1 ,    // Fixed
    parameter HQM_SFI_TX_DATA_PARITY_EN        = 1 ,    // Fixed
    parameter HQM_SFI_TX_DATA_PASS_HDR         = 0 ,    // Fixed
    parameter HQM_SFI_TX_DATA_MAX_FC_VC        = 1,     // Fixed
    parameter HQM_SFI_TX_DS                    = 1 ,    // Fixed
    parameter HQM_SFI_TX_ECRC_SUPPORT          = 0 ,    // Fixed
    parameter HQM_SFI_TX_FLIT_MODE_PREFIX_EN   = 0 ,    // Fixed
    parameter HQM_SFI_TX_FATAL_EN              = 0  ,   // Fixed
    parameter HQM_SFI_TX_H                     = 32 ,   // Fixed
    parameter HQM_SFI_TX_HDR_DATA_SEP          = 1  ,   // Fixed
    parameter HQM_SFI_TX_HDR_MAX_FC_VC         = 1  ,   // Fixed
    parameter HQM_SFI_TX_HGRAN                 = 4  ,   // Fixed
    parameter HQM_SFI_TX_HPARITY               = 1  ,   // Fixed
    parameter HQM_SFI_TX_IDE_SUPPORT           = 0  ,   // Fixed
    parameter HQM_SFI_TX_M                     = 1  ,   // Fixed
    parameter HQM_SFI_TX_MAX_CRD_CNT_WIDTH     = 12 ,   // Width of agent TX credit counters
    parameter HQM_SFI_TX_MAX_HDR_WIDTH         = 32 ,   // Fixed
    parameter HQM_SFI_TX_NDCRD                 = 4  ,   // Fabric data   credit return value width
    parameter HQM_SFI_TX_NHCRD                 = 4  ,   // Fabric header credit return value width
    parameter HQM_SFI_TX_NUM_SHARED_POOLS      = 0  ,   // Fixed
    parameter HQM_SFI_TX_PCIE_MERGED_SELECT    = 0  ,   // Fixed
    parameter HQM_SFI_TX_PCIE_SHARED_SELECT    = 0  ,   // Fixed
    parameter HQM_SFI_TX_RBN                   = 1  ,   // Cycles after fabric hdr/data_crd_rtn_block is received before agent RX stalls
    parameter HQM_SFI_TX_SH_DATA_CRD_BLK_SZ    = 1 ,    // Fixed
    parameter HQM_SFI_TX_SH_HDR_CRD_BLK_SZ     = 1  ,   // Fixed
    parameter HQM_SFI_TX_SHARED_CREDIT_EN      = 0  ,   // Fixed
    parameter HQM_SFI_TX_TBN                   = 3  ,   // Fixed
    parameter HQM_SFI_TX_TX_CRD_REG            = 1  ,   // Fixed
    parameter HQM_SFI_TX_VIRAL_EN              = 0  ,   // Fixed
    parameter HQM_SFI_TX_VR                    = 0   ,  // Fixed
    parameter HQM_SFI_TX_VT                    = 0     // Fixed

) (
     input  logic                                       prim_nonflr_clk
    ,input  logic                                       prim_gated_rst_b

    //-------------------------------------------------------------------------------------------------
    // Config

    ,input  logic                                       cfg_sifp_par_off    // Parity checking disabled

    ,input  logic                                       fuse_proc_disable   // HQM is fuse disabled

    //-------------------------------------------------------------------------------------------------
    // SFI to Agent RX

    ,input  logic                                       agent_rx_hdr_v      // Agent RX hdr  push
    ,input  logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]         agent_rx_hdr_vc
    ,input  hqm_sfi_fc_id_t                             agent_rx_hdr_fc
    ,input  logic [3:0]                                 agent_rx_hdr_size
    ,input  logic                                       agent_rx_hdr_has_data
    ,input  logic                                       agent_rx_hdr_par
    ,input  hqm_sfi_flit_header_t                       agent_rx_hdr

    ,input  logic                                       agent_rx_data_v     // Agent RX data push
    ,input  logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]        agent_rx_data_vc
    ,input  hqm_sfi_fc_id_t                             agent_rx_data_fc
    ,input  logic [HQM_SFI_RX_DATA_PARITY_WIDTH-1:0]    agent_rx_data_par
    ,input  logic [(HQM_SFI_RX_D*8)-1:0]                agent_rx_data

    //-------------------------------------------------------------------------------------------------
    // Link Layer interface

    ,output logic                                       lli_phdr_val
    ,output tdl_phdr_t                                  lli_phdr

    ,output logic                                       lli_nphdr_val
    ,output tdl_nphdr_t                                 lli_nphdr

    ,output logic                                       lli_pdata_push
    ,output logic                                       lli_npdata_push
    ,output ri_bus_width_t                              lli_pkt_data
    ,output ri_bus_par_t                                lli_pkt_data_par

    //-------------------------------------------------------------------------------------------------
    // Inbound Completions

    ,output logic                                       ibcpl_hdr_push      // Inbound completion header push
    ,output tdl_cplhdr_t                                ibcpl_hdr

    ,output logic                                       ibcpl_data_push     // Inbound completion data push
    ,output logic [HQM_IBCPL_DATA_WIDTH-1:0]            ibcpl_data
    ,output logic [HQM_IBCPL_PARITY_WIDTH-1:0]          ibcpl_data_par      // Parity per DW

    //-------------------------------------------------------------------------------------------------
    // RI credit returns

    ,input  hqm_iosf_tgt_crd_t                          ri_tgt_crd_inc

    //-------------------------------------------------------------------------------------------------
    // SFI credit returns

    ,output logic                                       rx_hcrd_return_v    // Agent returning RX hdr  credits
    ,output logic [HQM_SFI_RX_HDR_VC_WIDTH-1:0]         rx_hcrd_return_vc 
    ,output hqm_sfi_fc_id_t                             rx_hcrd_return_fc 
    ,output logic [HQM_SFI_RX_NHCRD-1:0]                rx_hcrd_return_val 

    ,output logic                                       rx_dcrd_return_v    // Agent returning RX data credits
    ,output logic [HQM_SFI_RX_DATA_VC_WIDTH-1:0]        rx_dcrd_return_vc 
    ,output hqm_sfi_fc_id_t                             rx_dcrd_return_fc 
    ,output logic [HQM_SFI_RX_NDCRD-1:0]                rx_dcrd_return_val 

    //-------------------------------------------------------------------------------------------------
    // Error signals

    ,output logic                                       iosf_ep_cpar_err
    ,output errhdr_t                                    iosf_ep_chdr_w_err
);

//-----------------------------------------------------------------------------------------------------

hqm_sfi_flit_cmd_t              sfi_cmd;

hqm_sfi_pcie_cmd_t              pcie_cmd;

logic                           cmd_phdr_wr;                // For the "to RI cmd" calc logic
logic                           cmd_phdr_msgd;              // Invalidate request (MsgD code=1)
logic                           cmd_nphdr_mem_rd;           // MRd32/64
logic                           cmd_nphdr_cfg_wr;           // CfgWr0
logic                           cmd_nphdr_cfg_rd;           // CfgRd0

logic                           iosf_ep_cpar_err_i;         // Header parity error
logic                           iosf_ep_stop_and_scream;    // Header parity error stop/scream

hqm_sfi_cpl_status_t            lli_cpl_status;
logic                           lli_cplhdr_val;
tdl_cplhdr_t                    lli_cplhdr;
logic                           lli_cpldata_push;

logic [HQM_SFI_RX_NHCRD-1:0]    ccredit_scaled; 

//-----------------------------------------------------------------------------------------------------

always_comb begin

 sfi_cmd       = hqm_sfi_flit_cmd_t'(agent_rx_hdr.mem32.ttype);

 // These are the only RX transactions we support.  Converting to PCIe commands so the existing RI
 // logic doesn't need to be updated to use SFI commands.

 case (sfi_cmd)

  FLIT_CMD_MWR32:       pcie_cmd = PCIE_CMD_MWR32;      // P
  FLIT_CMD_MWR64:       pcie_cmd = PCIE_CMD_MWR64;      // P

  FLIT_CMD_MSG0:        pcie_cmd = PCIE_CMD_MSG0;       // P
  FLIT_CMD_MSG1:        pcie_cmd = PCIE_CMD_MSG1;       // P
  FLIT_CMD_MSG2:        pcie_cmd = PCIE_CMD_MSG2;       // P
  FLIT_CMD_MSG3:        pcie_cmd = PCIE_CMD_MSG3;       // P
  FLIT_CMD_MSG4:        pcie_cmd = PCIE_CMD_MSG4;       // P
  FLIT_CMD_MSG5:        pcie_cmd = PCIE_CMD_MSG5;       // P
  FLIT_CMD_MSGD0:       pcie_cmd = PCIE_CMD_MSGD0;      // P
  FLIT_CMD_MSGD1:       pcie_cmd = PCIE_CMD_MSGD1;      // P
  FLIT_CMD_MSGD2:       pcie_cmd = PCIE_CMD_MSGD2;      // P
  FLIT_CMD_MSGD3:       pcie_cmd = PCIE_CMD_MSGD3;      // P
  FLIT_CMD_MSGD4:       pcie_cmd = PCIE_CMD_MSGD4;      // P
  FLIT_CMD_MSGD5:       pcie_cmd = PCIE_CMD_MSGD5;      // P

  FLIT_CMD_CFGRD0:      pcie_cmd = PCIE_CMD_CFGRD0;     // NP
  FLIT_CMD_CFGWR0:      pcie_cmd = PCIE_CMD_CFGWR0;     // NP

  FLIT_CMD_MRD32:       pcie_cmd = PCIE_CMD_MRD32;      // NP
  FLIT_CMD_MRD64:       pcie_cmd = PCIE_CMD_MRD64;      // NP
  FLIT_CMD_MRDLK32:     pcie_cmd = PCIE_CMD_MRDLK32;    // NP
  FLIT_CMD_MRDLK64:     pcie_cmd = PCIE_CMD_MRDLK64;    // NP
  FLIT_CMD_DMWR32:      pcie_cmd = PCIE_CMD_NPMWR32;    // NP
  FLIT_CMD_DMWR64:      pcie_cmd = PCIE_CMD_NPMWR64;    // NP

  FLIT_CMD_CPL:         pcie_cmd = PCIE_CMD_CPL;        // CPL
  FLIT_CMD_CPLD:        pcie_cmd = PCIE_CMD_CPLD;       // CPL
  FLIT_CMD_CPLLK:       pcie_cmd = PCIE_CMD_CPLLK;      // CPL
  FLIT_CMD_UIORDCPL:    pcie_cmd = PCIE_CMD_CPL;        // CPL
  FLIT_CMD_UIORDCPLD:   pcie_cmd = PCIE_CMD_CPLD;       // CPL

  default:              pcie_cmd = hqm_sfi_pcie_cmd_t'(agent_rx_hdr.mem32.ttype[6:0]);

 endcase

end

//-----------------------------------------------------------------------------------------------------
// SFI (FLIT) -> RI (PCIe non-FLIT) Translation

always_comb begin

 //----------------------------------------------------------------------------------------------------
 // Posted Requests

 lli_phdr_val           = agent_rx_hdr_v & ~(|agent_rx_hdr_vc) & (agent_rx_hdr_fc == sfi_fc_posted) &
                            (~(iosf_ep_cpar_err | iosf_ep_stop_and_scream));

 // Not passing at[1:0], td, th, ln, attr[2:0], or tc[2:0] fields.

 lli_phdr.tag           =  agent_rx_hdr.mem32.tag[7:0];
 lli_phdr.reqid         =  agent_rx_hdr.mem32.reqid;
 lli_phdr.length        =  agent_rx_hdr.mem32.len;
 lli_phdr.poison        =  agent_rx_hdr.mem32.ep;
{lli_phdr.fmt
,lli_phdr.ttype}        =  pcie_cmd;

 // In FLIT mode, ending and starting byte enables are assumed to be all 1s by default except if the
 // transaction length is 1 DW, where the ending byte enables must be all 0s.
 // OHCA1 will be used on memory space transactions to provide non-default values for these fields.

 case (pcie_cmd)

  PCIE_CMD_MWR32: begin

   lli_phdr.addr    = {32'd0, agent_rx_hdr.mem32.address31_2, 2'd0};

   lli_phdr.endbe   = (agent_rx_hdr.mem32.len == 10'd1) ? '0 : '1;
   lli_phdr.startbe = '1;

   if (agent_rx_hdr.mem32.ohc[0]) begin
    lli_phdr.endbe   = agent_rx_hdr.mem32.ohc_dw0.a1.lbe;
    lli_phdr.startbe = agent_rx_hdr.mem32.ohc_dw0.a1.fbe;
   end

  end

  PCIE_CMD_MWR64: begin

   lli_phdr.addr    = {agent_rx_hdr.mem64.address63_32
                      ,agent_rx_hdr.mem64.address31_2
                      ,2'd0
                      };

   lli_phdr.endbe   = (agent_rx_hdr.mem64.len == 10'd1) ? '0 : '1;
   lli_phdr.startbe = '1;

   if (agent_rx_hdr.mem64.ohc[0]) begin
    lli_phdr.endbe   = agent_rx_hdr.mem64.ohc_dw0.a1.lbe;
    lli_phdr.startbe = agent_rx_hdr.mem64.ohc_dw0.a1.fbe;
   end

  end

  default: begin

   lli_phdr.addr    = {agent_rx_hdr.mem64.address63_32
                      ,agent_rx_hdr.mem64.address31_2
                      ,2'd0
                      };

   {lli_phdr.endbe, lli_phdr.startbe} = agent_rx_hdr.invreq.msg_code;

  end

 endcase

 lli_phdr.sai           = agent_rx_hdr.mem32.pf0.sai;

 cmd_phdr_msgd          = (sfi_cmd == FLIT_CMD_MSGD2) & (agent_rx_hdr.mem32.len == 10'h002) &
                          (agent_rx_hdr.invreq.msg_code == 8'h01);

 cmd_phdr_wr            = (sfi_cmd == FLIT_CMD_MWR32) | (sfi_cmd == FLIT_CMD_MWR64);  // posted write

 lli_phdr.cmd           = (cmd_phdr_msgd)  ?
                            ((fuse_proc_disable)  ? `HQM_TDL_PHDR_USR_D : `HQM_TDL_PHDR_MSG_D) :
                         ((cmd_phdr_wr)    ?
                            ((fuse_proc_disable)  ? `HQM_TDL_PHDR_USR_D : `HQM_TDL_PHDR_WR) :
                         ((agent_rx_hdr_has_data) ? `HQM_TDL_PHDR_USR_D : `HQM_TDL_PHDR_USR_ND));

 // An invalidate request is the only transaction we should see with a PASID

 lli_phdr.pasidtlp      = (cmd_phdr_msgd & agent_rx_hdr.invreq.ohc[0]) ?
                            {agent_rx_hdr.invreq.ohc_dw0.a4.pv
                            ,agent_rx_hdr.invreq.ohc_dw0.a4.pmr
                            ,1'b0
                            ,agent_rx_hdr.invreq.ohc_dw0.a4.pasid19_16
                            ,agent_rx_hdr.invreq.ohc_dw0.a4.pasid15_8
                            ,agent_rx_hdr.invreq.ohc_dw0.a4.pasid7_0} : '0;

 lli_phdr.cmdlen_par    = ^{lli_phdr.cmd
                           ,lli_phdr.fmt
                           ,lli_phdr.ttype
                           ,lli_phdr.length
                           };

 lli_phdr.addr_par      = {(^lli_phdr.addr[63:32])
                          ,(^lli_phdr.addr[31: 0])
                          };

 lli_phdr.par           = {(^{lli_phdr.sai
                             ,lli_phdr.pasidtlp
                             ,lli_phdr.poison
                             }
                           )
                          ,(^{lli_phdr.tag
                             ,lli_phdr.reqid
                             ,lli_phdr.endbe
                             ,lli_phdr.startbe
                             }
                           )
                          };

 //----------------------------------------------------------------------------------------------------
 // Non-Posted Requests

 lli_nphdr_val          = agent_rx_hdr_v & ~(|agent_rx_hdr_vc) & (agent_rx_hdr_fc == sfi_fc_nonposted) &
                            (~(iosf_ep_cpar_err | iosf_ep_stop_and_scream));

 // Not passing at[1:0], td, th, or ln fields.

 lli_nphdr              = '0                                                        ;
 lli_nphdr.tag          = agent_rx_hdr.mem32.tag[9:0];
 lli_nphdr.reqid        = agent_rx_hdr.mem32.reqid;
 lli_nphdr.length       = agent_rx_hdr.mem32.len;
 lli_nphdr.poison       = agent_rx_hdr.mem32.ep;
 lli_nphdr.attr         = agent_rx_hdr.mem32.attr[1:0];
 lli_nphdr.tc           = agent_rx_hdr.mem32.tc2_0;
{lli_nphdr.fmt
,lli_nphdr.ttype}       = pcie_cmd;

 // In FLIT mode, ending and starting byte enables are assumed to be all 1s by default except if the
 // transaction length is 1 DW, where the ending byte enables must be all 0s.
 // OHCA1 will be used on memory space transactions to provide non-default values for these fields.
 // OHCA3 must be used on config space transactions to provide the         values for these fields.

 case (pcie_cmd)

  PCIE_CMD_CFGRD0,
  PCIE_CMD_CFGWR0: begin

   lli_nphdr.addr    = {32'd0
                       ,agent_rx_hdr.cfg.bdf
                       ,agent_rx_hdr.cfg.rsvd111_108
                       ,agent_rx_hdr.cfg.regnum
                       };

   lli_nphdr.endbe   = (agent_rx_hdr.cfg.len == 10'd1) ? '0 : '1;
   lli_nphdr.startbe = '1;

   if (agent_rx_hdr.cfg.ohc[0]) begin
    lli_nphdr.endbe   = agent_rx_hdr.cfg.ohc_dw0.a3.lbe;
    lli_nphdr.startbe = agent_rx_hdr.cfg.ohc_dw0.a3.fbe;
   end

  end

  PCIE_CMD_MRD32,
  PCIE_CMD_MRDLK32,
  PCIE_CMD_NPMWR32: begin

   lli_nphdr.addr    = {32'd0, agent_rx_hdr.mem32.address31_2};

   lli_nphdr.endbe   = (agent_rx_hdr.mem32.len == 10'd1) ? '0 : '1;
   lli_nphdr.startbe = '1;

   if (agent_rx_hdr.mem32.ohc[0]) begin
    lli_nphdr.endbe   = agent_rx_hdr.mem32.ohc_dw0.a1.lbe;
    lli_nphdr.startbe = agent_rx_hdr.mem32.ohc_dw0.a1.fbe;
   end

  end

  PCIE_CMD_MRD64,
  PCIE_CMD_MRDLK64,
  PCIE_CMD_NPMWR64: begin

   lli_nphdr.addr    = {agent_rx_hdr.mem64.address63_32
                       ,agent_rx_hdr.mem64.address31_2
                       };

   lli_nphdr.endbe   = (agent_rx_hdr.mem64.len == 10'd1) ? '0 : '1;
   lli_nphdr.startbe = '1;

   if (agent_rx_hdr.mem64.ohc[0]) begin
    lli_nphdr.endbe   = agent_rx_hdr.mem64.ohc_dw0.a1.lbe;
    lli_nphdr.startbe = agent_rx_hdr.mem64.ohc_dw0.a1.fbe;
   end

  end

  default: begin

   lli_nphdr.addr    = {agent_rx_hdr.mem64.address63_32
                       ,agent_rx_hdr.mem64.address31_2
                       };

   {lli_nphdr.endbe, lli_nphdr.startbe} = agent_rx_hdr.invreq.msg_code;

  end

 endcase

 cmd_nphdr_mem_rd       = ((sfi_cmd == FLIT_CMD_MRD32) | (sfi_cmd == FLIT_CMD_MRD64));  // non-posted req, mem rd
 cmd_nphdr_cfg_wr       =  (sfi_cmd == FLIT_CMD_CFGWR0);                                // non-posted req, cfg wr
 cmd_nphdr_cfg_rd       =  (sfi_cmd == FLIT_CMD_CFGRD0);                                // non-posted req, cfg rd

 lli_nphdr.cmd          = (cmd_nphdr_mem_rd) ?
                            ((fuse_proc_disable)  ? `HQM_TDL_NPHDR_USR_ND : `HQM_TDL_NPHDR_MEM_RD) :
                         ((cmd_nphdr_cfg_wr) ?
                            ((fuse_proc_disable)  ? `HQM_TDL_NPHDR_USR_D  : `HQM_TDL_NPHDR_CFG_WR) :
                         ((cmd_nphdr_cfg_rd) ?
                            ((fuse_proc_disable)  ? `HQM_TDL_NPHDR_USR_ND : `HQM_TDL_NPHDR_CFG_RD) :
                         ((agent_rx_hdr_has_data) ? `HQM_TDL_NPHDR_USR_D  : `HQM_TDL_NPHDR_USR_ND)));

 lli_nphdr.sai          = agent_rx_hdr.mem32.pf0.sai;

 // No NP transactions require PASID, (can use these bits for upper tag bits?).
 // TBD: Could reduce the size of the Ri TLQ NP header FIFO to remove the upper pasidtlp bits.

 lli_nphdr.pasidtlp     = {19'd0, agent_rx_hdr.mem32.tag[13:10]};

 lli_nphdr.cmdlen_par   = ^{lli_nphdr.cmd
                           ,lli_nphdr.fmt
                           ,lli_nphdr.ttype
                           ,lli_nphdr.length
                           };

 lli_nphdr.addr_par     = {(^lli_nphdr.addr[63:32])
                          ,(^lli_nphdr.addr[31: 2])
                          };

 lli_nphdr.par          = {(^{lli_nphdr.sai
                             ,lli_nphdr.pasidtlp
                             ,lli_nphdr.attr
                             ,lli_nphdr.tc
                             }
                           )
                          ,(^{lli_nphdr.poison
                             ,lli_nphdr.tag
                             ,lli_nphdr.reqid
                             ,lli_nphdr.endbe
                             ,lli_nphdr.startbe
                             }
                           )
                          };

 //----------------------------------------------------------------------------------------------------
 // Completion

 // Completions should only be on Ch1 and Ch2

 lli_cplhdr_val         = agent_rx_hdr_v & (|agent_rx_hdr_vc) & (agent_rx_hdr_fc == sfi_fc_completion) &
                            (~(iosf_ep_cpar_err | iosf_ep_stop_and_scream));

 // Not passing at[1:0], td, th, ln, or bcm fields.

 lli_cpl_status         = hqm_sfi_cpl_status_t'(3'd0);
 lli_cplhdr.addr        = {agent_rx_hdr.cpl.la5_2, 2'd0};

 if (agent_rx_hdr.cpl.ohc[0]) begin
  lli_cpl_status        = agent_rx_hdr.cpl.ohc_dw0.a5.cpl_status;
  lli_cplhdr.addr       = {agent_rx_hdr.cpl.la5_2, agent_rx_hdr.cpl.ohc_dw0.a5.la1_0};  // Lower 2b only present in OHCA5
 end

 // TBD: What about la6? Currently only 6b in the cplhdr for addr instead of 7b? Use the extra tag bit?

 lli_cplhdr             = '0;
 lli_cplhdr.cid         = agent_rx_hdr.cpl.cplid;
 lli_cplhdr.status      = ((sfi_cmd == FLIT_CMD_CPLLK) || (sfi_cmd == FLIT_CMD_CPLDLK)) ? 3'd7 : // Force unsupported CplLk/CplDLk to 7
                         (((lli_cpl_status == 3'd3) || (lli_cpl_status >= 3'd5))          ? 3'd1 : // Force unsupported encodings to UR
                            lli_cpl_status);                                                       // Otherwise pass actual status
 lli_cplhdr.bc          = agent_rx_hdr.cpl.bc;

 // We should only ever send out tags 0-255, so ORing the upper Cpl tag bits into a single 9th bit
 // so the scoreboard will still flag as an invalid outstanding tag (unexpected completion).

 lli_cplhdr.tag         = {1'b0, (|agent_rx_hdr.cpl.tag[13:8]), agent_rx_hdr.cpl.tag[7:0]};
 lli_cplhdr.rid         = agent_rx_hdr.cpl.bdf;
 lli_cplhdr.length      = agent_rx_hdr.cpl.len;
 lli_cplhdr.poison      = agent_rx_hdr.cpl.ep;
 lli_cplhdr.ido         = agent_rx_hdr.cpl.attr[2];
 lli_cplhdr.ro          = agent_rx_hdr.cpl.attr[1];
 lli_cplhdr.ns          = agent_rx_hdr.cpl.attr[0];
 lli_cplhdr.tc          = agent_rx_hdr.cpl.tc2_0;

 lli_cplhdr.wdata       = agent_rx_hdr.cpl.ttype[6];

 // TBD: No parity on cpl headers?

 //----------------------------------------------------------------------------------------------------
 // Packet data

 // Expect P and NP only on Ch0.  Ch1 and Ch3 should just be Cpl/CplD.

 lli_pdata_push         = agent_rx_data_v & ~(|agent_rx_data_vc) & (agent_rx_data_fc == sfi_fc_posted);
 lli_npdata_push        = agent_rx_data_v & ~(|agent_rx_data_vc) & (agent_rx_data_fc == sfi_fc_nonposted);

 lli_cpldata_push       = agent_rx_data_v &  (|agent_rx_data_vc) & (agent_rx_data_fc == sfi_fc_completion);

 lli_pkt_data           = (agent_rx_data_v) ? agent_rx_data     : '0;

 // RI parity is per DW, SFI is per 2 DWs

 for (int i=0; i<4; i=i+1) begin

  lli_pkt_data_par[(i*2)]   = (agent_rx_data_v) ? ^{agent_rx_data_par[i], agent_rx_data[((i*64)+32) +: 32]} : '0;
  lli_pkt_data_par[(i*2)+1] = (agent_rx_data_v) ? ^{agent_rx_data_par[i], agent_rx_data[ (i*64)     +: 32]} : '0;

 end

 //----------------------------------------------------------------------------------------------------

 ibcpl_hdr_push         = lli_cplhdr_val;
 ibcpl_hdr              = lli_cplhdr;

 ibcpl_data_push        = lli_cpldata_push;
 ibcpl_data             = lli_pkt_data[HQM_IBCPL_DATA_WIDTH-1:0];
 ibcpl_data_par         = lli_pkt_data_par[HQM_IBCPL_PARITY_WIDTH-1:0];

end

//-----------------------------------------------------------------------------------------------------
// Header parity error

// Capture Cmd Header Parity Error

always_comb begin

 // SFI header parity is on the entire header and hdr_info_bytes fields which includes the has_data,
 // shared_credit, hdr_size, vc, and fc fields. The agent_rx_hdr_par is the SFI header parity bit,
 // so we need to include the equivalent fields in the header parity check:
 //
 //     The shared_credit will always be 0 for us
 //     Need to account for vc, fc, and size

 iosf_ep_cpar_err_i     = (cfg_sifp_par_off) ? 1'b0 :
                            (^{agent_rx_hdr_par
                              ,agent_rx_hdr
                              ,agent_rx_hdr_vc
                              ,agent_rx_hdr_fc
                              ,agent_rx_hdr_size
                              ,agent_rx_hdr_has_data
                            });

 iosf_ep_cpar_err       = agent_rx_hdr_v & iosf_ep_cpar_err_i & ~iosf_ep_stop_and_scream;

 // TBD: Error header format?

 iosf_ep_chdr_w_err.header   = {agent_rx_hdr[ 63:  32]
                               ,agent_rx_hdr[ 95:  64]
                               ,agent_rx_hdr[127:  96]
                               ,agent_rx_hdr[159: 128]};

 iosf_ep_chdr_w_err.pasidtlp = (cmd_phdr_msgd) ? lli_phdr.pasidtlp : '0;

end

// Stop and scream is persistent until reset

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  iosf_ep_stop_and_scream <= '0;
 end else begin
  iosf_ep_stop_and_scream <= iosf_ep_stop_and_scream | iosf_ep_cpar_err;
 end
end

//-----------------------------------------------------------------------------------------------------
// Credit translation
//
// We support infinite completion credits on all channels so don't need to worry about CPL credits.
// Ch0 is the only channel we expect to get P/NP transactions
// Ch1 UIOCpl only
// Ch2 ATS responses only (Cpl/CplD)

hqm_AW_width_scale #(.A_WIDTH(1), .Z_WIDTH(HQM_SFI_RX_NHCRD)) i_ccredit_scaled (

     .a         (ri_tgt_crd_inc.ccredit)
    ,.z         (ccredit_scaled)
);

always_comb begin

 // Should only need to return credits for VC0

 rx_hcrd_return_v    = ri_tgt_crd_inc.ccreditup;
 rx_hcrd_return_vc   = '0;
 rx_hcrd_return_fc   = hqm_sfi_fc_id_t'(ri_tgt_crd_inc.ccredit_fc);
 rx_hcrd_return_val  = ccredit_scaled;

 rx_dcrd_return_v    = ri_tgt_crd_inc.dcreditup;
 rx_dcrd_return_vc   = '0;
 rx_dcrd_return_fc   = hqm_sfi_fc_id_t'(ri_tgt_crd_inc.dcredit_fc);
 rx_dcrd_return_val  = ri_tgt_crd_inc.dcredit[HQM_SFI_RX_NDCRD-1:0];

end

endmodule // hqm_sfi_rx_xlate

