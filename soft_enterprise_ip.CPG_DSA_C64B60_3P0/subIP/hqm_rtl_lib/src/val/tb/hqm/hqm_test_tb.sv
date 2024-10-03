`timescale 1ns/1ps

module hqm_test_tb #(

        `include "hqm_iosf_params_global.vh"
        ,
        `include "hqm_iosfsb_params_global.vh"
) ();

import hqm_pkg::*;

logic                           aon_clk;
logic                           powergood_rst_b;

logic                           disable_smon_strap;
logic                           csr_load_strap;
logic [63:0]                    csr_cp_strap;
logic [63:0]                    csr_wac_strap;

logic   [7:0]                   fp_cfg_portid;
logic   [7:0]                   fp_cfg_destid;
logic  [15:0]                   fp_cfg_sai;
logic  [15:0]                   fp_cfg_sai_cmpl;
logic   [7:0]                   fp_cfg_ready_portid;
logic   [2:0]                   fp_cfg_tag;
                               
logic                           prim_pok;
logic                           prim_clk_root;
logic                           prim_clk;
logic                           prim_clkreq;
logic                           prim_clkack;
logic                           prim_rst_b;
logic                           prim_lcp_fd;
logic                           prim_lcp_rd;
logic   [2:0]                   prim_ism_fabric;
logic   [2:0]                   prim_ism_agent;
                               
logic                           side_pok;
logic                           side_clk_root;
logic                           side_clk;
logic                           side_clkreq;
logic                           side_clkack;
logic                           side_rst_b;
logic                           side_lcp_fd;
logic                           side_lcp_rd;
logic   [2:0]                   gpsb_side_ism_fabric;
logic   [2:0]                   gpsb_side_ism_agent;
                               
logic                           gpsb_mpccup;
logic                           gpsb_mnpcup;
                               
logic                           gpsb_mpcput;
logic                           gpsb_mnpput;
logic                           gpsb_meom;
logic   [7:0]                   gpsb_mpayload;
                               
logic                           gpsb_tpccup;
logic                           gpsb_tnpcup;
                               
logic                           gpsb_tpcput;
logic                           gpsb_tnpput;
logic                           gpsb_teom;
logic   [7:0]                   gpsb_tpayload;

logic                           req_put;
logic   [1:0]                   req_rtype;
logic                           req_cdata;
logic   [MAX_DATA_LEN:0]        req_dlen;
logic   [3:0]                   req_tc;
logic                           req_ns;
logic                           req_ro;
logic                           req_ido;
logic                           req_locked;
logic                           req_chain;
logic                           req_opp;
logic   [RS_WIDTH:0]            req_rs;
logic   [AGENT_WIDTH:0]         req_agent;
logic   [DST_ID_WIDTH:0]        req_dest_id;

logic                           gnt;
logic   [1:0]                   gnt_rtype;
logic   [1:0]                   gnt_type;

logic   [1:0]                   mfmt;
logic   [4:0]                   mtype;
logic   [3:0]                   mtc;
logic                           mth;
logic                           mep;
logic                           mro;
logic                           mns;
logic                           mido;
logic   [1:0]                   mat;
logic   [9:0]                   mlength;
logic   [15:0]                  mrqid;
logic   [7:0]                   mtag;
logic   [3:0]                   mlbe;
logic   [3:0]                   mfbe;
logic   [MMAX_ADDR:0]           maddress;
logic   [RS_WIDTH:0]            mrs;
logic                           mtd;
logic   [31:0]                  mecrc;
logic                           mcparity;
logic   [SRC_ID_WIDTH:0]        msrc_id;
logic   [DST_ID_WIDTH:0]        mdest_id;
logic   [SAI_WIDTH:0]           msai;

logic   [MD_WIDTH:0]            mdata;
logic   [MDP_WIDTH:0]           mdparity;

logic                           credit_put;
logic   [1:0]                   credit_rtype;
logic                           credit_cmd;
logic   [2:0]                   credit_data;

logic                           tdec;
logic   [0:0]                   hit;
logic   [0:0]                   sub_hit;

logic                           cmd_put;
logic   [1:0]                   cmd_rtype;
logic                           cmd_nfs_err;

logic   [1:0]                   tfmt;
logic   [4:0]                   ttype;
logic   [3:0]                   ttc;
logic                           tth;
logic                           tep;
logic                           tro;
logic                           tns;
logic                           tido;
logic                           tchain;
logic   [1:0]                   tat;
logic   [9:0]                   tlength;
logic   [15:0]                  trqid;
logic   [7:0]                   ttag;
logic   [3:0]                   tlbe;
logic   [3:0]                   tfbe;
logic   [TMAX_ADDR:0]           taddress;
logic   [RS_WIDTH:0]            trs;
logic                           ttd;
logic   [31:0]                  tecrc;
logic                           tcparity;
logic   [SRC_ID_WIDTH:0]        tsrc_id;
logic   [DST_ID_WIDTH:0]        tdest_id;
logic   [SAI_WIDTH:0]           tsai;

logic   [TD_WIDTH:0]            tdata;
logic   [TDP_WIDTH:0]           tdparity;

logic                           fdfx_powergood;
logic                           visa_all_dis;
logic                           visa_customer_dis;

logic   [0:0]                   fscan_sdi;
logic   [0:0]                   ascan_sdo;

logic                           fscan_ret_ctrl;
logic                           fscan_mode;
logic   [20:0]                  fscan_rstbypen;
logic   [20:0]                  fscan_byprst_b;
logic                           fscan_latchopen;
logic                           fscan_latchclosed_b;
logic                           fscan_clkungate;
logic                           fscan_clkungate_syn;
logic                           fscan_shiften;
logic   [3:0]                   fscan_clkgenctrlen;
logic   [3:0]                   fscan_clkgenctrl;

logic                           fscan_ram_wrdis_b;
logic                           fscan_ram_rddis_b;
logic   [2047:0]                fscan_ram_odis_b;

logic                           prim_jta_clkgate_ovrd;
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

logic                           fary_pwren_b;
logic                           aary_pwren_b;

logic                           aqed_LV_TM_rf;
logic                           aqed_LV_WRSTN_rf;
logic                           aqed_LV_WRCK_rf;
logic                           aqed_LV_WSI_rf;
logic                           aqed_LV_UpdateWR_rf;
logic                           aqed_LV_ShiftWR_rf;
logic                           aqed_LV_CaptureWR_rf;
logic                           aqed_LV_EnableWR_rf;
logic                           aqed_LV_SelectWIR_rf;

logic                           aqed_LV_WSO_rf;
logic                           aqed_LV_AuxEn_rf;
logic                           aqed_LV_AuxOut_rf;

logic                           aqed_LV_TM_sram;
logic                           aqed_LV_WRSTN_sram;
logic                           aqed_LV_WRCK_sram;
logic                           aqed_LV_WSI_sram;
logic                           aqed_LV_UpdateWR_sram;
logic                           aqed_LV_ShiftWR_sram;
logic                           aqed_LV_CaptureWR_sram;
logic                           aqed_LV_EnableWR_sram;
logic                           aqed_LV_SelectWIR_sram;

logic                           aqed_LV_WSO_sram;
logic                           aqed_LV_AuxEn_sram;
logic                           aqed_LV_AuxOut_sram;

logic                           ap_LV_TM_rf;
logic                           ap_LV_WRSTN_rf;
logic                           ap_LV_WRCK_rf;
logic                           ap_LV_WSI_rf;
logic                           ap_LV_UpdateWR_rf;
logic                           ap_LV_ShiftWR_rf;
logic                           ap_LV_CaptureWR_rf;
logic                           ap_LV_EnableWR_rf;
logic                           ap_LV_SelectWIR_rf;

logic                           ap_LV_WSO_rf;
logic                           ap_LV_AuxEn_rf;
logic                           ap_LV_AuxOut_rf;

logic                           chp_LV_TM_rf;
logic                           chp_LV_WRSTN_rf;
logic                           chp_LV_WRCK_rf;
logic                           chp_LV_WSI_rf;
logic                           chp_LV_UpdateWR_rf;
logic                           chp_LV_ShiftWR_rf;
logic                           chp_LV_CaptureWR_rf;
logic                           chp_LV_EnableWR_rf;
logic                           chp_LV_SelectWIR_rf;

logic                           chp_LV_WSO_rf;
logic                           chp_LV_AuxEn_rf;
logic                           chp_LV_AuxOut_rf;

logic                           chp_LV_TM_sram;
logic                           chp_LV_WRSTN_sram;
logic                           chp_LV_WRCK_sram;
logic                           chp_LV_WSI_sram;
logic                           chp_LV_UpdateWR_sram;
logic                           chp_LV_ShiftWR_sram;
logic                           chp_LV_CaptureWR_sram;
logic                           chp_LV_EnableWR_sram;
logic                           chp_LV_SelectWIR_sram;

logic                           chp_LV_WSO_sram;
logic                           chp_LV_AuxEn_sram;
logic                           chp_LV_AuxOut_sram;

logic                           dp_LV_TM_rf;
logic                           dp_LV_WRSTN_rf;
logic                           dp_LV_WRCK_rf;
logic                           dp_LV_WSI_rf;
logic                           dp_LV_UpdateWR_rf;
logic                           dp_LV_ShiftWR_rf;
logic                           dp_LV_CaptureWR_rf;
logic                           dp_LV_EnableWR_rf;
logic                           dp_LV_SelectWIR_rf;

logic                           dp_LV_WSO_rf;
logic                           dp_LV_AuxEn_rf;
logic                           dp_LV_AuxOut_rf;

logic                           dp_LV_TM_sram;
logic                           dp_LV_WRSTN_sram;
logic                           dp_LV_WRCK_sram;
logic                           dp_LV_WSI_sram;
logic                           dp_LV_UpdateWR_sram;
logic                           dp_LV_ShiftWR_sram;
logic                           dp_LV_CaptureWR_sram;
logic                           dp_LV_EnableWR_sram;
logic                           dp_LV_SelectWIR_sram;

logic                           dp_LV_WSO_sram;
logic                           dp_LV_AuxEn_sram;
logic                           dp_LV_AuxOut_sram;

logic                           dqed_LV_TM_rf;
logic                           dqed_LV_WRSTN_rf;
logic                           dqed_LV_WRCK_rf;
logic                           dqed_LV_WSI_rf;
logic                           dqed_LV_UpdateWR_rf;
logic                           dqed_LV_ShiftWR_rf;
logic                           dqed_LV_CaptureWR_rf;
logic                           dqed_LV_EnableWR_rf;
logic                           dqed_LV_SelectWIR_rf;

logic                           dqed_LV_WSO_rf;
logic                           dqed_LV_AuxEn_rf;
logic                           dqed_LV_AuxOut_rf;

logic                           dqed_LV_TM_sram;
logic                           dqed_LV_WRSTN_sram;
logic                           dqed_LV_WRCK_sram;
logic                           dqed_LV_WSI_sram;
logic                           dqed_LV_UpdateWR_sram;
logic                           dqed_LV_ShiftWR_sram;
logic                           dqed_LV_CaptureWR_sram;
logic                           dqed_LV_EnableWR_sram;
logic                           dqed_LV_SelectWIR_sram;

logic                           dqed_LV_WSO_sram;
logic                           dqed_LV_AuxEn_sram;
logic                           dqed_LV_AuxOut_sram;

logic                           lsp_LV_TM_rf;
logic                           lsp_LV_WRSTN_rf;
logic                           lsp_LV_WRCK_rf;
logic                           lsp_LV_WSI_rf;
logic                           lsp_LV_UpdateWR_rf;
logic                           lsp_LV_ShiftWR_rf;
logic                           lsp_LV_CaptureWR_rf;
logic                           lsp_LV_EnableWR_rf;
logic                           lsp_LV_SelectWIR_rf;

logic                           lsp_LV_WSO_rf;
logic                           lsp_LV_AuxEn_rf;
logic                           lsp_LV_AuxOut_rf;

logic                           nalb_LV_TM_rf;
logic                           nalb_LV_WRSTN_rf;
logic                           nalb_LV_WRCK_rf;
logic                           nalb_LV_WSI_rf;
logic                           nalb_LV_UpdateWR_rf;
logic                           nalb_LV_ShiftWR_rf;
logic                           nalb_LV_CaptureWR_rf;
logic                           nalb_LV_EnableWR_rf;
logic                           nalb_LV_SelectWIR_rf;

logic                           nalb_LV_WSO_rf;
logic                           nalb_LV_AuxEn_rf;
logic                           nalb_LV_AuxOut_rf;

logic                           nalb_LV_TM_sram;
logic                           nalb_LV_WRSTN_sram;
logic                           nalb_LV_WRCK_sram;
logic                           nalb_LV_WSI_sram;
logic                           nalb_LV_UpdateWR_sram;
logic                           nalb_LV_ShiftWR_sram;
logic                           nalb_LV_CaptureWR_sram;
logic                           nalb_LV_EnableWR_sram;
logic                           nalb_LV_SelectWIR_sram;

logic                           nalb_LV_WSO_sram;
logic                           nalb_LV_AuxEn_sram;
logic                           nalb_LV_AuxOut_sram;

logic                           qed_LV_TM_rf;
logic                           qed_LV_WRSTN_rf;
logic                           qed_LV_WRCK_rf;
logic                           qed_LV_WSI_rf;
logic                           qed_LV_UpdateWR_rf;
logic                           qed_LV_ShiftWR_rf;
logic                           qed_LV_CaptureWR_rf;
logic                           qed_LV_EnableWR_rf;
logic                           qed_LV_SelectWIR_rf;

logic                           qed_LV_WSO_rf;
logic                           qed_LV_AuxEn_rf;
logic                           qed_LV_AuxOut_rf;

logic                           qed_LV_TM_sram;
logic                           qed_LV_WRSTN_sram;
logic                           qed_LV_WRCK_sram;
logic                           qed_LV_WSI_sram;
logic                           qed_LV_UpdateWR_sram;
logic                           qed_LV_ShiftWR_sram;
logic                           qed_LV_CaptureWR_sram;
logic                           qed_LV_EnableWR_sram;
logic                           qed_LV_SelectWIR_sram;

logic                           qed_LV_WSO_sram;
logic                           qed_LV_AuxEn_sram;
logic                           qed_LV_AuxOut_sram;

logic                           rop_LV_TM_rf;
logic                           rop_LV_WRSTN_rf;
logic                           rop_LV_WRCK_rf;
logic                           rop_LV_WSI_rf;
logic                           rop_LV_UpdateWR_rf;
logic                           rop_LV_ShiftWR_rf;
logic                           rop_LV_CaptureWR_rf;
logic                           rop_LV_EnableWR_rf;
logic                           rop_LV_SelectWIR_rf;

logic                           rop_LV_WSO_rf;
logic                           rop_LV_AuxEn_rf;
logic                           rop_LV_AuxOut_rf;

logic                           rop_LV_TM_sram;
logic                           rop_LV_WRSTN_sram;
logic                           rop_LV_WRCK_sram;
logic                           rop_LV_WSI_sram;
logic                           rop_LV_UpdateWR_sram;
logic                           rop_LV_ShiftWR_sram;
logic                           rop_LV_CaptureWR_sram;
logic                           rop_LV_EnableWR_sram;
logic                           rop_LV_SelectWIR_sram;

logic                           rop_LV_WSO_sram;
logic                           rop_LV_AuxEn_sram;
logic                           rop_LV_AuxOut_sram;

logic                           system_LV_TM_rf;
logic                           system_LV_WRSTN_rf;
logic                           system_LV_WRCK_rf;
logic                           system_LV_WSI_rf;
logic                           system_LV_UpdateWR_rf;
logic                           system_LV_ShiftWR_rf;
logic                           system_LV_CaptureWR_rf;
logic                           system_LV_EnableWR_rf;
logic                           system_LV_SelectWIR_rf;

logic                           system_LV_WSO_rf;
logic                           system_LV_AuxEn_rf;
logic                           system_LV_AuxOut_rf;

logic                           system_LV_TM_sram;
logic                           system_LV_WRSTN_sram;
logic                           system_LV_WRCK_sram;
logic                           system_LV_WSI_sram;
logic                           system_LV_UpdateWR_sram;
logic                           system_LV_ShiftWR_sram;
logic                           system_LV_CaptureWR_sram;
logic                           system_LV_EnableWR_sram;
logic                           system_LV_SelectWIR_sram;

logic                           system_LV_WSO_sram;
logic                           system_LV_AuxEn_sram;
logic                           system_LV_AuxOut_sram;

logic                           fvisa_serstb;
logic                           fvisa_frame;
logic                           fvisa_serdata;
logic   [8:0]                   fvisa_startid;

logic   [63:0]                  v1m_avisa_dbgbus;

integer                         i;

hqm i_hqm (.*);

always #1.250 aon_clk       = ~aon_clk;
always #0.500 prim_clk_root = ~prim_clk_root;
always #1.250 side_clk_root = ~side_clk_root;

reg     [9:0]   side_clkack_q;
reg     [9:0]   prim_clkack_q;

always_ff @(posedge prim_clk_root or negedge side_rst_b) begin
 if (~side_rst_b) begin
  prim_clkack_q <= '0;
 end else begin
  prim_clkack_q <= {prim_clkreq, prim_clkack_q[9:1]};
 end
end

assign prim_clk = prim_clk_root & prim_clkack_q[4];
assign prim_clkack = (prim_clkreq) ? prim_clkack_q[0] : prim_clkack_q[8];

always_ff @(posedge side_clk_root or negedge side_rst_b) begin
 if (~side_rst_b) begin
  side_clkack_q <= '0;
 end else begin
  side_clkack_q <= {side_clkreq, side_clkack_q[9:1]};
 end
end

assign side_clk = side_clk_root & side_clkack_q[4];
assign side_clkack = (side_clkreq) ? side_clkack_q[0] : side_clkack_q[8];

initial begin

        $vcdpluson();

        aon_clk = 1'b1;
        powergood_rst_b = 1'b0;

        disable_smon_strap = '0;
        csr_load_strap = '0;
        csr_cp_strap = '0;
        csr_wac_strap = '0;

        fp_cfg_portid = 8'd0;
        fp_cfg_destid = 8'd0;
        fp_cfg_sai = 16'd0;
        fp_cfg_sai_cmpl = 16'd0;
        fp_cfg_ready_portid = 8'd0;
        fp_cfg_tag = 3'd0;

        prim_clk_root = '1;
        prim_rst_b = '0;
        prim_lcp_fd = '0;
        prim_lcp_rd = '0;
        prim_ism_fabric = '0;

        side_clk_root = '1;
        side_rst_b = '0;
        side_lcp_fd = '0;
        side_lcp_rd = '0;
        gpsb_side_ism_fabric = '0;

        gpsb_mpccup = '0;
        gpsb_mnpcup = '0;
        gpsb_tpcput = '0;
        gpsb_tnpput = '0;
        gpsb_teom = '0;
        gpsb_tpayload = '0;

        gnt = '0;
        gnt_rtype = '0;
        gnt_type = '0;
        tdec = '0;
        cmd_put = '0;
        cmd_rtype = '0;
        cmd_nfs_err = '0;
        tfmt = '0;
        ttype = '0;
        ttc = '0;
        tth = '0;
        tep = '0;
        tro = '0;
        tns = '0;
        tido = '0;
        tchain = '0;
        tat = '0;
        tlength = '0;
        trqid = '0;
        ttag = '0;
        tlbe = '0;
        tfbe = '0;
        taddress = '0;
        trs = '0;
        ttd = '0;
        tecrc = '0;
        tcparity = '0;
        tsrc_id = '0;
        tdest_id = '0;
        tsai = '0;
        tdata = '0;
        tdparity = '0;

        fdfx_powergood = '0;

        visa_all_dis = '1;
        visa_customer_dis = '1;

        fscan_mode = '0;
        fscan_rstbypen = '0;
        fscan_byprst_b = '0;
        fscan_latchopen = '0;
        fscan_latchclosed_b = '0;
        fscan_clkungate = '0;
        fscan_clkungate_syn = '0;
        fscan_shiften = '0;
        fscan_clkgenctrlen = '0;
        fscan_clkgenctrl = '0;
        fscan_ret_ctrl = '0;

        fscan_ram_wrdis_b = '1;
        fscan_ram_rddis_b = '1;
        fscan_ram_odis_b = '1;

        prim_jta_clkgate_ovrd = '0;
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

        fary_pwren_b = '0;

        aqed_LV_TM_rf = '0;
        aqed_LV_WRSTN_rf = '0;
        aqed_LV_WRCK_rf = '0;
        aqed_LV_WSI_rf = '0;
        aqed_LV_UpdateWR_rf = '0;
        aqed_LV_ShiftWR_rf = '0;
        aqed_LV_CaptureWR_rf = '0;
        aqed_LV_EnableWR_rf = '0;
        aqed_LV_SelectWIR_rf = '0;

        aqed_LV_TM_sram = '0;
        aqed_LV_WRSTN_sram = '0;
        aqed_LV_WRCK_sram = '0;
        aqed_LV_WSI_sram = '0;
        aqed_LV_UpdateWR_sram = '0;
        aqed_LV_ShiftWR_sram = '0;
        aqed_LV_CaptureWR_sram = '0;
        aqed_LV_EnableWR_sram = '0;
        aqed_LV_SelectWIR_sram = '0;

        ap_LV_TM_rf = '0;
        ap_LV_WRSTN_rf = '0;
        ap_LV_WRCK_rf = '0;
        ap_LV_WSI_rf = '0;
        ap_LV_UpdateWR_rf = '0;
        ap_LV_ShiftWR_rf = '0;
        ap_LV_CaptureWR_rf = '0;
        ap_LV_EnableWR_rf = '0;
        ap_LV_SelectWIR_rf = '0;

        chp_LV_TM_rf = '0;
        chp_LV_WRSTN_rf = '0;
        chp_LV_WRCK_rf = '0;
        chp_LV_WSI_rf = '0;
        chp_LV_UpdateWR_rf = '0;
        chp_LV_ShiftWR_rf = '0;
        chp_LV_CaptureWR_rf = '0;
        chp_LV_EnableWR_rf = '0;
        chp_LV_SelectWIR_rf = '0;

        chp_LV_TM_sram = '0;
        chp_LV_WRSTN_sram = '0;
        chp_LV_WRCK_sram = '0;
        chp_LV_WSI_sram = '0;
        chp_LV_UpdateWR_sram = '0;
        chp_LV_ShiftWR_sram = '0;
        chp_LV_CaptureWR_sram = '0;
        chp_LV_EnableWR_sram = '0;
        chp_LV_SelectWIR_sram = '0;

        dp_LV_TM_rf = '0;
        dp_LV_WRSTN_rf = '0;
        dp_LV_WRCK_rf = '0;
        dp_LV_WSI_rf = '0;
        dp_LV_UpdateWR_rf = '0;
        dp_LV_ShiftWR_rf = '0;
        dp_LV_CaptureWR_rf = '0;
        dp_LV_EnableWR_rf = '0;
        dp_LV_SelectWIR_rf = '0;

        dp_LV_TM_sram = '0;
        dp_LV_WRSTN_sram = '0;
        dp_LV_WRCK_sram = '0;
        dp_LV_WSI_sram = '0;
        dp_LV_UpdateWR_sram = '0;
        dp_LV_ShiftWR_sram = '0;
        dp_LV_CaptureWR_sram = '0;
        dp_LV_EnableWR_sram = '0;
        dp_LV_SelectWIR_sram = '0;

        dqed_LV_TM_rf = '0;
        dqed_LV_WRSTN_rf = '0;
        dqed_LV_WRCK_rf = '0;
        dqed_LV_WSI_rf = '0;
        dqed_LV_UpdateWR_rf = '0;
        dqed_LV_ShiftWR_rf = '0;
        dqed_LV_CaptureWR_rf = '0;
        dqed_LV_EnableWR_rf = '0;
        dqed_LV_SelectWIR_rf = '0;

        dqed_LV_TM_sram = '0;
        dqed_LV_WRSTN_sram = '0;
        dqed_LV_WRCK_sram = '0;
        dqed_LV_WSI_sram = '0;
        dqed_LV_UpdateWR_sram = '0;
        dqed_LV_ShiftWR_sram = '0;
        dqed_LV_CaptureWR_sram = '0;
        dqed_LV_EnableWR_sram = '0;
        dqed_LV_SelectWIR_sram = '0;

        lsp_LV_TM_rf = '0;
        lsp_LV_WRSTN_rf = '0;
        lsp_LV_WRCK_rf = '0;
        lsp_LV_WSI_rf = '0;
        lsp_LV_UpdateWR_rf = '0;
        lsp_LV_ShiftWR_rf = '0;
        lsp_LV_CaptureWR_rf = '0;
        lsp_LV_EnableWR_rf = '0;
        lsp_LV_SelectWIR_rf = '0;

        nalb_LV_TM_rf = '0;
        nalb_LV_WRSTN_rf = '0;
        nalb_LV_WRCK_rf = '0;
        nalb_LV_WSI_rf = '0;
        nalb_LV_UpdateWR_rf = '0;
        nalb_LV_ShiftWR_rf = '0;
        nalb_LV_CaptureWR_rf = '0;
        nalb_LV_EnableWR_rf = '0;
        nalb_LV_SelectWIR_rf = '0;

        nalb_LV_TM_sram = '0;
        nalb_LV_WRSTN_sram = '0;
        nalb_LV_WRCK_sram = '0;
        nalb_LV_WSI_sram = '0;
        nalb_LV_UpdateWR_sram = '0;
        nalb_LV_ShiftWR_sram = '0;
        nalb_LV_CaptureWR_sram = '0;
        nalb_LV_EnableWR_sram = '0;
        nalb_LV_SelectWIR_sram = '0;

        qed_LV_TM_rf = '0;
        qed_LV_WRSTN_rf = '0;
        qed_LV_WRCK_rf = '0;
        qed_LV_WSI_rf = '0;
        qed_LV_UpdateWR_rf = '0;
        qed_LV_ShiftWR_rf = '0;
        qed_LV_CaptureWR_rf = '0;
        qed_LV_EnableWR_rf = '0;
        qed_LV_SelectWIR_rf = '0;

        qed_LV_TM_sram = '0;
        qed_LV_WRSTN_sram = '0;
        qed_LV_WRCK_sram = '0;
        qed_LV_WSI_sram = '0;
        qed_LV_UpdateWR_sram = '0;
        qed_LV_ShiftWR_sram = '0;
        qed_LV_CaptureWR_sram = '0;
        qed_LV_EnableWR_sram = '0;
        qed_LV_SelectWIR_sram = '0;

        rop_LV_TM_rf = '0;
        rop_LV_WRSTN_rf = '0;
        rop_LV_WRCK_rf = '0;
        rop_LV_WSI_rf = '0;
        rop_LV_UpdateWR_rf = '0;
        rop_LV_ShiftWR_rf = '0;
        rop_LV_CaptureWR_rf = '0;
        rop_LV_EnableWR_rf = '0;
        rop_LV_SelectWIR_rf = '0;

        rop_LV_TM_sram = '0;
        rop_LV_WRSTN_sram = '0;
        rop_LV_WRCK_sram = '0;
        rop_LV_WSI_sram = '0;
        rop_LV_UpdateWR_sram = '0;
        rop_LV_ShiftWR_sram = '0;
        rop_LV_CaptureWR_sram = '0;
        rop_LV_EnableWR_sram = '0;
        rop_LV_SelectWIR_sram = '0;

        system_LV_TM_rf = '0;
        system_LV_WRSTN_rf = '0;
        system_LV_WRCK_rf = '0;
        system_LV_WSI_rf = '0;
        system_LV_UpdateWR_rf = '0;
        system_LV_ShiftWR_rf = '0;
        system_LV_CaptureWR_rf = '0;
        system_LV_EnableWR_rf = '0;
        system_LV_SelectWIR_rf = '0;

        system_LV_TM_sram = '0;
        system_LV_WRSTN_sram = '0;
        system_LV_WRCK_sram = '0;
        system_LV_WSI_sram = '0;
        system_LV_UpdateWR_sram = '0;
        system_LV_ShiftWR_sram = '0;
        system_LV_CaptureWR_sram = '0;
        system_LV_EnableWR_sram = '0;
        system_LV_SelectWIR_sram = '0;

        fvisa_serstb = '0;
        fvisa_frame = '0;
        fvisa_serdata = '0;
        fvisa_startid = '0;

        repeat (100) @(posedge aon_clk); #0.1;
        powergood_rst_b = 1'b1;

        // Release IOSF sideband from reset

        repeat (20) @(posedge side_clk_root); #0.1;
        side_rst_b = 1'b1;

        // Credit initialization for IOSF sideband

        repeat (100) @(posedge side_clk_root); #0.1;
        gpsb_side_ism_fabric = 3'd4;                         // CREDIT_REQ
        repeat (10) @(posedge side_clk_root); #0.1;
        gpsb_side_ism_fabric = 3'd6;                         // CREDIT_ACK
        repeat (10) @(posedge side_clk_root); #0.1;
        gpsb_side_ism_fabric = 3'd5;                         // CREDIT_INIT
        repeat (10) @(posedge side_clk_root); #0.1;
        gpsb_mpccup = 1'd1; gpsb_mnpcup = 1'd1;              // 8 credits (2 DW IP_READY message will be coming)
        repeat (8) @(posedge side_clk_root); #0.1;
        gpsb_mpccup = 1'd0; gpsb_mnpcup = 1'd0;
        repeat (10) @(posedge side_clk_root); #0.1;
        gpsb_side_ism_fabric = 3'd0;                         // IDLE
        repeat (250) @(posedge side_clk_root); #0.1;
        gpsb_side_ism_fabric = 3'd2;                         // ACTIVE_REQ (receive IP_READY message)
        repeat (20) @(posedge side_clk_root); #0.1;
        gpsb_mpccup = 1'd1;                                  // 8 credits returned
        repeat (8) @(posedge side_clk_root); #0.1;
        gpsb_mpccup = 1'd0;
        repeat (20) @(posedge side_clk_root); #0.1;
        gpsb_side_ism_fabric = 3'd3;                         // ACTIVE
        repeat (20) @(posedge side_clk_root); #0.1;
        gpsb_side_ism_fabric = 3'd0;                         // IDLE

        // Release primary from reset

        repeat (1000) @(posedge prim_clk_root); #0.1;
        prim_rst_b = 1'b1;

        // Credit initialization for IOSF primary

        repeat (100) @(posedge prim_clk_root); #0.1;
        prim_ism_fabric = 3'd4;                         // CREDIT_REQ
        repeat (10) @(posedge prim_clk_root); #0.1;
        prim_ism_fabric = 3'd6;                         // CREDIT_ACK
        repeat (10) @(posedge prim_clk_root); #0.1;
        prim_ism_fabric = 3'd5;                         // CREDIT_INIT
        repeat (10) @(posedge prim_clk_root); #0.1;
        gnt = 1'd1; gnt_type = 2'd2;                    // 8 credits
        repeat (8) @(posedge prim_clk_root); #0.1;
        gnt = 1'd0; gnt_type = 2'd0;
        repeat (100) @(posedge prim_clk_root); #0.1;
        prim_ism_fabric = 3'd0;                         // IDLE
        repeat (100) @(posedge prim_clk_root); #0.1;
        prim_ism_fabric = 3'd2;                         // ACTIVE_REQ - To get the clocks turned back on!

        // Try an IOSF primary transaction

        repeat (1000) @(posedge prim_clk_root); #0.1;
        cmd_put=1'd1; cmd_rtype=2'd1; cmd_nfs_err=1'd0;
        tfmt=2'd2; ttype=5'd0; ttc=4'd0; tth=1'd0; tep=1'd0; tro=1'd0; tns=1'd1; tido=1'd0; tchain=1'd0; tat=2'd0;
        tlength=10'd1; trqid=16'h1234; ttag=8'h56; tlbe=4'hf; tfbe=4'hf; taddress=32'h12345678; trs=1'd0; ttd=1'd0;
        tecrc=32'h00000000; tcparity=1'd0; tsrc_id=3'h2;
        tdest_id=3'h4; tsai=8'd0; tdata=256'h00000001_00000002_00000003_00000004; tdparity=1'd1;
        repeat (1) @(posedge prim_clk_root); #0.1;
        cmd_put=1'd0;

        repeat (10) @(posedge prim_clk_root); #0.1;
        prim_ism_fabric = 3'd3;                         // ACTIVE
        repeat (20) @(posedge prim_clk_root); #0.1;
        prim_ism_fabric = 3'd0;                         // IDLE

 #1000   $finish();

end

endmodule

