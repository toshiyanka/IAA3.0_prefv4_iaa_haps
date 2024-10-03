
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
// hqm_AW_pkg
//
// Package containing support functions for AW library and common functions provided by this library
//-----------------------------------------------------------------------------------------------------
package hqm_AW_pkg ;
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
    // AW_logb2
    //
    // This function returns the number of binary bits required to store the integer input.
    //
    //-----------------------------------------------------------------------------------------------------
    function automatic integer AW_logb2 ; 
        input [31:0] d ; 
        integer x ; 
        begin
            x = 0 ;
            for (int i = 0 ; (i < 32) ; i = (i + 1))
                if ((|(d >> i))) 
                    x = i ;
            AW_logb2 = x ;
        end
    endfunction
    typedef enum logic [3:0] { ILL15 = 4'd15, ILL14 = 4'd14, ILL13 = 4'd13, ILL12 = 4'd12, ILL11 = 4'd11, DIR_VAS = 4'd10, DIR_QID = 4'd9, DIR_CQ = 4'd8, ILL7 = 4'd7, ILL6 = 4'd6, ILL5 = 4'd5, ILL4 = 4'd4, ILL3 = 4'd3, LDB_VAS = 4'd2, LDB_QID = 4'd1, 
            LDB_CQ = 4'd0} cfg_vf_reset_type_t ; 
    localparam BITS_CFG_VF_RESET_TYPE_T = $bits(cfg_vf_reset_type_t) ; 
    // Bit 0  decode errors are marked in the user field, and dropped where appropriate
    typedef struct packed {
        logic a_par ; 
        logic // Bit 19 paddr[31:0] "odd" parity bit from IOSF to HQM Proc 
            wd_par ; 
        logic [(15 - 1):0] // Bit 18 pwdata[31:0] "odd" parity bit from IOSF to HQM Proc
            rsvd ; 
        logic addr_decode_par_err ; 
        logic // Bit 2  parity error detected at addr decode, marked in the user field, and dropped where appropriate           
            disable_ring_parity_check ; 
        logic // Bit 1  is used as disable_parity_check in the cfg_ring
            addr_decode_err ; 
    } cfg_user_t ; 
    localparam BITS_CFG_USER_T = $bits(cfg_user_t) ; 
    // NODE IDS - Note these are not the same as V1 or V2
    parameter HQM_RSV0_CFG_NODE_ID = 4'd0 ; 
    parameter HQM_SYS_CFG_NODE_ID = 4'd1 ; 
    parameter HQM_AQED_CFG_NODE_ID = 4'd2 ; 
    parameter HQM_AP_CFG_NODE_ID = 4'd3 ; 
    parameter HQM_CHP_CFG_NODE_ID = 4'd4 ; 
    parameter HQM_DP_CFG_NODE_ID = 4'd5 ; 
    parameter HQM_QED_CFG_NODE_ID = 4'd6 ; 
    parameter HQM_NALB_CFG_NODE_ID = 4'd7 ; 
    parameter HQM_ROP_CFG_NODE_ID = 4'd8 ; 
    parameter HQM_LSP_CFG_NODE_ID = 4'd9 ; 
    parameter HQM_MSTR_CFG_NODE_ID = 4'd10 ; 
    parameter HQM_RSV11_CFG_NODE_ID = 4'd11 ; 
    parameter HQM_RSV12_CFG_NODE_ID = 4'd12 ; 
    parameter HQM_RSV13_CFG_NODE_ID = 4'd13 ; 
    parameter HQM_RSV14_CFG_NODE_ID = 4'd14 ; 
    parameter HQM_RSV15_CFG_NODE_ID = 4'd15 ; 
    typedef enum logic [(4 - 1):0] { RSV0_NODE = HQM_RSV0_CFG_NODE_ID, SYS_NODE = HQM_SYS_CFG_NODE_ID, AQED_NODE = HQM_AQED_CFG_NODE_ID, AP_NODE = HQM_AP_CFG_NODE_ID, CHP_NODE = HQM_CHP_CFG_NODE_ID, DP_NODE = HQM_DP_CFG_NODE_ID, NALB_NODE = HQM_NALB_CFG_NODE_ID, ROP_NODE = HQM_ROP_CFG_NODE_ID, LSP_NODE = HQM_LSP_CFG_NODE_ID, MSTR_NODE = HQM_MSTR_CFG_NODE_ID, RSV11_NODE = HQM_RSV11_CFG_NODE_ID, RSV12_NODE = HQM_RSV12_CFG_NODE_ID, RSV13_NODE = HQM_RSV13_CFG_NODE_ID, RSV14_NODE = HQM_RSV14_CFG_NODE_ID, RSV15_NODE = HQM_RSV15_CFG_NODE_ID} enum_cfg_node_id_t ; 
    // UNIT IDS
    parameter HQM_RSV0_CFG_UNIT_ID = 4'd0 ; 
    parameter HQM_SYS_CFG_UNIT_ID = 4'd1 ; 
    parameter HQM_AQED_CFG_UNIT_ID = 4'd2 ; 
    parameter HQM_AP_CFG_UNIT_ID = 4'd3 ; 
    parameter HQM_CHP_CFG_UNIT_ID = 4'd4 ; 
    parameter HQM_DP_CFG_UNIT_ID = 4'd5 ; 
    parameter HQM_QED_CFG_UNIT_ID = 4'd6 ; 
    parameter HQM_NALB_CFG_UNIT_ID = 4'd7 ; 
    parameter HQM_ROP_CFG_UNIT_ID = 4'd8 ; 
    parameter HQM_LSP_CFG_UNIT_ID = 4'd9 ; 
    parameter HQM_MSTR_CFG_UNIT_ID = 4'd10 ; 
    parameter HQM_RSV11_CFG_UNIT_ID = 4'd11 ; 
    parameter HQM_RSV12_CFG_UNIT_ID = 4'd12 ; 
    parameter HQM_RSV13_CFG_UNIT_ID = 4'd13 ; 
    parameter HQM_RSV14_CFG_UNIT_ID = 4'd14 ; 
    parameter HQM_RSV15_CFG_UNIT_ID = 4'd15 ; 
    typedef enum logic [(4 - 1):0] { RSV0_UNIT = HQM_RSV0_CFG_UNIT_ID, SYS_UNIT = HQM_SYS_CFG_UNIT_ID, AQED_UNIT = HQM_AQED_CFG_UNIT_ID, AP_UNIT = HQM_AP_CFG_UNIT_ID, CHP_UNIT = HQM_CHP_CFG_UNIT_ID, DP_UNIT = HQM_DP_CFG_UNIT_ID, QED_UNIT = HQM_QED_CFG_UNIT_ID, NALB_UNIT = HQM_NALB_CFG_UNIT_ID, ROP_UNIT = HQM_ROP_CFG_UNIT_ID, LSP_UNIT = HQM_LSP_CFG_UNIT_ID, MSTR_UNIT = HQM_MSTR_CFG_UNIT_ID, RSV11_UNIT = HQM_RSV11_CFG_UNIT_ID, RSV12_UNIT = HQM_RSV12_CFG_UNIT_ID, RSV13_UNIT = HQM_RSV13_CFG_UNIT_ID, RSV14_UNIT = HQM_RSV14_CFG_UNIT_ID, 
            RSV15_UNIT = HQM_RSV15_CFG_UNIT_ID} enum_cfg_unit_id_t ; 
    typedef enum logic [(2 - 1):0] { VIR0 = 2'b00, VIR1 = 2'b01, REG = 2'b10, MEM = 2'b11} enum_cfg_mode_t ; 
    typedef struct packed {
        enum_cfg_mode_t mode ; 
        enum_cfg_node_id_t node ; 
        logic [(16 - 1):0] target ; 
        logic [(16 - 1):0] offset ; 
    } cfg_addr_t ; 
    localparam BITS_CFG_ADDR_T = $bits(cfg_addr_t) ; 
    typedef struct packed {
        logic cfg_ignore_pipe_busy ; 
        cfg_user_t user ; 
        logic addr_par ; 
        cfg_addr_t addr ; 
        logic wdata_par ; 
        logic [(32 - 1):0] wdata ; 
    } cfg_req_t ; 
    typedef struct packed {
        logic wr ; 
        logic rd ; 
        cfg_req_t req ; 
    } cfg_req_wctrl_t ; 
    localparam BITS_CFG_REQ_T = $bits(cfg_req_t) ; 
    typedef struct packed {
        logic err ; 
        logic err_slv_par ; 
        logic rdata_par ; 
        logic [(32 - 1):0] rdata ; 
        enum_cfg_unit_id_t uid ; 
    } cfg_rsp_t ; 
    localparam BITS_CFG_RSP_T = $bits(cfg_rsp_t) ; 
    typedef enum logic [2:0] { HQM_ALARM = 3'd0, VF_PF_SERVICE = 3'd1, HQM_WD_TIMER = 3'd2, INGRESS_ERROR = 3'd3, DM_V2P_ERROR = 3'd4, DM_NQ_AFULL = 3'd5, DM_ALARM = 3'd6, DM_VAS_RING_AEMPTY = 3'd7} aw_alarm_msix_map_t ; 
    typedef struct packed {
        aw_alarm_msix_map_t msix_map ; 
        logic [(2 - 1):0] rtype ; 
        logic [(8 - 1):0] rid ; 
    } aw_alarm_syn_t ; 
    localparam BITS_AW_ALARM_SYN_T = $bits(aw_alarm_syn_t) ; 
    typedef struct packed {
        logic [(4 - 1):0] unit ; 
        logic [(6 - 1):0] aid ; 
        logic [(2 - 1):0] cls ; 
        aw_alarm_msix_map_t msix_map ; 
        logic [(2 - 1):0] rtype ; 
        logic [(8 - 1):0] rid ; 
    } aw_alarm_t ; 
    localparam BITS_AW_ALARM_T = $bits(aw_alarm_t) ; 
    typedef enum logic [2:0] { HQM_AW_MF_NOOP = 3'h0, HQM_AW_MF_PUSH = 3'h1, HQM_AW_MF_POP = 3'h2, HQM_AW_MF_READ = 3'h3, HQM_AW_MF_INIT_PTRS = 3'h4, HQM_AW_MF_APPEND = 3'h5, HQM_AW_MF_UNDEF0 = 3'h6, HQM_AW_MF_UNDEF1 = 3'h7} aw_multi_fifo_cmd_t ; 
    localparam BITS_AW_MULTI_FIFO_CMD_T = $bits(aw_multi_fifo_cmd_t) ; 
    typedef struct packed {
        logic [23:0] depth ; 
        logic full ; 
        logic afull ; 
        logic aempty ; 
        logic empty ; 
        logic rsvd3 ; 
        logic parity_err ; 
        logic overflow ; 
        logic underflow ; 
    } aw_fifo_status_t ; 
    localparam BITS_AW_FIFO_STATUS_T = $bits(aw_fifo_status_t) ; 
    typedef enum logic [1:0] { HQM_AW_RMWPIPE_NOOP = 2'h0, HQM_AW_RMWPIPE_READ = 2'h1, HQM_AW_RMWPIPE_WRITE = 2'h2, HQM_AW_RMWPIPE_RMW = 2'h3} aw_rmwpipe_cmd_t ; 
    localparam BITS_AW_RMWPIPE_CMD_T = $bits(aw_rmwpipe_cmd_t) ; 
    typedef enum logic [1:0] { HQM_AW_RWPIPE_NOOP = 2'h0, HQM_AW_RWPIPE_READ = 2'h1, HQM_AW_RWPIPE_WRITE = 2'h2, HQM_AW_RWPIPE_ILL = 2'h3} aw_rwpipe_cmd_t ; 
    localparam BITS_AW_RWPIPE_CMD_T = $bits(aw_rwpipe_cmd_t) ; 
    typedef struct packed {
        logic [2:0] eid ; 
        logic [1:0] jid ; 
        logic [10:0] bytes ; 
        logic [63:0] addr ; 
    } aw_caal_crr_t ; 
    localparam BITS_AW_CAAL_CRR_T = $bits(aw_caal_crr_t) ; 
endpackage


