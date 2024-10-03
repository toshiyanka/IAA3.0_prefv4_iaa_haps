// cct.20150909 from PCIE3201509090088BEKB0.tar drop
//----------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intels prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//----------------------------------------------------------------------------
//
//  $Id: cxt_iosf_tgt_crdt.sv,v 1.50 2013/12/19 20:07:51 cvanbeek Exp $
//
//  PROJECT : CCT-PCIE3
//  DATE    : $Date: 2013/12/19 20:07:51 $
//
//  Functional description:
//  PCIE IOSF Primary Channel Target Credit Block
//
//----------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////
// Assumptions:
// 1. port_config available @ reset,
// 2. Qs will never issue update on a channel that doesnt exist
//////////////////////////////////////////////////////////////////////////////


module hqm_iosf_tgt_crdt

     import hqm_sif_csr_pkg::*, hqm_system_type_pkg::*, hqm_system_func_pkg::*;
#(
     parameter bit TCRD_BYPASS  = 0
    ,parameter int PORTS        = 1
    ,parameter int VC           = 1
    ,parameter int TX_PRH       = 6
    ,parameter int TX_NPRH      = 4
    ,parameter int TX_CPLH      = 6
    ,parameter int TX_PRD       = 30
    ,parameter int TX_NPRD      = 4
    ,parameter int TX_CPLD      = 30

) (

    //------------------------------------------------------------------------
    // IOSF Target Clocks and Resets

     input  logic                    prim_nonflr_clk
    ,input  logic                    prim_gated_rst_b

    ,input  logic [2:0]              prim_ism_agent

    //------------------------------------------------------------------------
    // EP Credit bypass

    ,input  logic [7:0]              ep_nprdcredits_sw_rxl
    ,input  logic [7:0]              ep_nprhcredits_sw_rxl
    ,input  logic [7:0]              ep_prdcredits_sw_rxl
    ,input  logic [7:0]              ep_prhcredits_sw_rxl
    ,input  logic [7:0]              ep_cpldcredits_sw_rxl
    ,input  logic [7:0]              ep_cplhcredits_sw_rxl

    //------------------------------------------------------------------------
    // Credit updates from IOSF TGT and RI

    ,input hqm_iosf_tgt_crd_t        iosf_tgt_crd_dec
    ,input hqm_iosf_tgt_crd_t        ri_tgt_crd_inc

    //------------------------------------------------------------------------
    // Flags from/to GCGU and CNTRL

    ,input  logic                    credit_init

    ,output logic                    credit_init_in_progress
    ,output logic                    credit_init_done

    ,output logic                    tgt_has_unret_credits  // Prevent ACTIVE->IDLE_REQ

    //------------------------------------------------------------------------
    // IOSF Target Control Interface to Fabric -- Credit Return

    ,output hqm_iosf_tgt_credit_t    iosf_tgt_credit

    //------------------------------------------------------------------------
    // NOA

    ,output logic [7:0]              noa_tgtcrdt

    ,output new_TGT_INIT_HCREDITS_t  tgt_init_hcredits
    ,output new_TGT_INIT_DCREDITS_t  tgt_init_dcredits
    ,output new_TGT_REM_HCREDITS_t   tgt_rem_hcredits
    ,output new_TGT_REM_DCREDITS_t   tgt_rem_dcredits
    ,output new_TGT_RET_HCREDITS_t   tgt_ret_hcredits
    ,output new_TGT_RET_DCREDITS_t   tgt_ret_dcredits
);

//----------------------------------------------------------------------------

localparam CNT_WIDTH = `HQM_L2CEIL(VC*PORTS*3+1);

localparam logic [2:0] ACTIVE = 3'b011;

//----------------------------------------------------------------------------

logic                                               rst_complete;
logic                                               rst_complete_ff;
logic                                               rst_complete_ffd1;
logic                                               rst_complete_ffd2;

logic                                               done;
logic                                               done_ff;

logic                                               credit_init_done_nxt;

logic [(VC*PORTS*3)-1:0]                            init_done_nxt;
logic [(VC*PORTS*3)-1:0]                            init_done;

logic [CNT_WIDTH-1:0]                               init_cnt_nxt;
logic [CNT_WIDTH-1:0]                               init_cnt;

logic [7:0]                                         data_credit_p_init;
logic [7:0]                                         data_credit_np_init;
logic [7:0]                                         data_credit_c_init;

logic [(VC*PORTS*3)-1:0][7:0]                       data_credit_init;
logic [(VC*PORTS*3)-1:0][7:0]                       data_credit_val_nxt;
logic [(VC*PORTS*3)-1:0][7:0]                       data_credit_val;
logic [(VC*PORTS*3)-1:0]                            data_credit_val_lti;

logic [(VC*PORTS*3)-1:0][7:0]                       data_credit_cnt_nxt;
logic [(VC*PORTS*3)-1:0][7:0]                       data_credit_cnt;

logic [(VC*PORTS*3)-1:0][7:0]                       data_credit_inc;
logic [(VC*PORTS*3)-1:0][7:0]                       data_credit_dec;
logic [(VC*PORTS*3)-1:0][7:0]                       data_credit_ret;

logic [7:0]                                         cmd_credit_p_init;
logic [7:0]                                         cmd_credit_np_init;
logic [7:0]                                         cmd_credit_c_init;

logic [(VC*PORTS*3)-1:0][7:0]                       cmd_credit_init;
logic [(VC*PORTS*3)-1:0][7:0]                       cmd_credit_val_nxt;
logic [(VC*PORTS*3)-1:0][7:0]                       cmd_credit_val;
logic [(VC*PORTS*3)-1:0]                            cmd_credit_val_lti;

logic [(VC*PORTS*3)-1:0][7:0]                       cmd_credit_cnt_nxt;
logic [(VC*PORTS*3)-1:0][7:0]                       cmd_credit_cnt;

logic [(VC*PORTS*3)-1:0][7:0]                       cmd_credit_inc;
logic [(VC*PORTS*3)-1:0][7:0]                       cmd_credit_dec;
logic [(VC*PORTS*3)-1:0][7:0]                       cmd_credit_ret;

logic [(VC*PORTS*3)-1:0]                            credit_cnt_gt0;

logic                                               credit_put_nxt;
logic                                               credit_put;
logic [2:0]                                         credit_data_nxt;
logic [2:0]                                         credit_data;
logic                                               credit_cmd_nxt;
logic                                               credit_cmd;
logic [`HQM_L2P1(VC*PORTS)-1:0]                     credit_chid_nxt;
logic [`HQM_L2P1(VC*PORTS)-1:0]                     credit_chid;
logic [1:0]                                         credit_rtype_nxt;
logic [1:0]                                         credit_rtype;

logic                                               return_arb_v;
logic                                               return_arb_update;
logic [`HQM_L2CEIL(VC*PORTS*3)-1:0]                 return_arb_index;

//----------------------------------------------------------------------------

assign rst_complete         = credit_init;
assign done                 = &init_done;
assign credit_init_done_nxt = done & ~done_ff;

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
    if (~prim_gated_rst_b) begin

        rst_complete_ff         <= '0;
        rst_complete_ffd1       <= '0;
        rst_complete_ffd2       <= '0;

        init_cnt                <= '0;

        done_ff                 <= '0;

        credit_init_in_progress <= '0;
        credit_init_done        <= '0;

    end else begin

        rst_complete_ff         <= rst_complete;
        rst_complete_ffd1       <= rst_complete_ff;
        rst_complete_ffd2       <= rst_complete_ffd1;

        init_cnt                <= init_cnt_nxt;

        done_ff                 <= done;

        credit_init_in_progress <= ~done_ff;
        credit_init_done        <= credit_init_done_nxt;

    end
end

//----------------------------------------------------------------------------
// Per channel per flowclass regs

generate
    for (genvar g=0; g<(VC*PORTS*3); g++) begin: g_regs

        always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
            if (~prim_gated_rst_b) begin

                init_done[g]           <= '0;

                data_credit_val[g]     <= '0;
                cmd_credit_val[g]      <= '0;

                data_credit_cnt[g]     <= '0;
                cmd_credit_cnt[g]      <= '0;

            end else begin

                init_done[g]           <= init_done_nxt[g];

                data_credit_val[g]     <= data_credit_val_nxt[g];
                cmd_credit_val[g]      <= cmd_credit_val_nxt[g];

                data_credit_cnt[g]     <= data_credit_cnt_nxt[g];
                cmd_credit_cnt[g]      <= cmd_credit_cnt_nxt[g];

            end
        end

    end
endgenerate

//----------------------------------------------------------------------------
// Initial per channel per flowclass counter values

always_comb begin: Init_Values

    // These are all constant values

    data_credit_p_init  = (TCRD_BYPASS) ? ep_prdcredits_sw_rxl[ 7:0] : TX_PRD[ 7:0];
    data_credit_np_init = (TCRD_BYPASS) ? ep_nprdcredits_sw_rxl[7:0] : TX_NPRD[7:0];
    data_credit_c_init  = (TCRD_BYPASS) ? ep_cpldcredits_sw_rxl[7:0] : TX_CPLD[7:0];

    cmd_credit_p_init   = (TCRD_BYPASS) ? ep_prhcredits_sw_rxl[ 7:0] : TX_PRH[ 7:0];
    cmd_credit_np_init  = (TCRD_BYPASS) ? ep_nprhcredits_sw_rxl[7:0] : TX_NPRH[7:0];
    cmd_credit_c_init   = (TCRD_BYPASS) ? ep_cplhcredits_sw_rxl[7:0] : TX_CPLH[7:0];

    for (int ch=0; ch<(VC*PORTS); ch++) begin

        for (int fc=0; fc<3; fc++) begin

            if (fc==0) begin
               data_credit_init[(ch*3)+fc] = data_credit_p_init;
                cmd_credit_init[(ch*3)+fc] =  cmd_credit_p_init;
            end else if (fc==1) begin
               data_credit_init[(ch*3)+fc] = data_credit_np_init;
                cmd_credit_init[(ch*3)+fc] =  cmd_credit_np_init;
            end else begin
               data_credit_init[(ch*3)+fc] = data_credit_c_init;
                cmd_credit_init[(ch*3)+fc] =  cmd_credit_c_init;
            end

        end // fc

    end // ch

end // Init_Values

//----------------------------------------------------------------------------
// Credit updates

always_comb begin: Credit_Updates

    int data_channel_inc;
    int data_channel_dec;
    int  cmd_channel_inc;
    int  cmd_channel_dec;

    // Channel IDs for the decrement and increment interfaces

    data_channel_dec = {{(32-`HQM_L2CEIL(VC)-`HQM_L2CEIL(PORTS)){1'b0}},
                        iosf_tgt_crd_dec.dcredit_vc, iosf_tgt_crd_dec.dcredit_port};
     cmd_channel_dec = {{(32-`HQM_L2CEIL(VC)-`HQM_L2CEIL(PORTS)){1'b0}},
                        iosf_tgt_crd_dec.ccredit_vc, iosf_tgt_crd_dec.ccredit_port};

    data_channel_inc = {{(32-`HQM_L2CEIL(VC)-`HQM_L2CEIL(PORTS)){1'b0}},
                        ri_tgt_crd_inc.dcredit_vc, ri_tgt_crd_inc.dcredit_port};
     cmd_channel_inc = {{(32-`HQM_L2CEIL(VC)-`HQM_L2CEIL(PORTS)){1'b0}},
                        ri_tgt_crd_inc.ccredit_vc, ri_tgt_crd_inc.ccredit_port};

    for (int ch=0; ch<(VC*PORTS); ch++) begin

        for (int fc=0; fc<3; fc++) begin

            data_credit_dec[(ch*3)+fc] = '0;
             cmd_credit_dec[(ch*3)+fc] = '0;
            data_credit_inc[(ch*3)+fc] = '0;
             cmd_credit_inc[(ch*3)+fc] = '0;
            data_credit_ret[(ch*3)+fc] = '0;
             cmd_credit_ret[(ch*3)+fc] = '0;

            if (&init_done) begin

                // Decrement for val counters on receive from IOSF

                if (iosf_tgt_crd_dec.dcreditup & (data_channel_dec == ch) &
                   (iosf_tgt_crd_dec.dcredit_fc == fc)) begin
                    data_credit_dec[(ch*3)+fc] = iosf_tgt_crd_dec.dcredit;
                end
               
                if (iosf_tgt_crd_dec.ccreditup & (cmd_channel_dec == ch) &
                   (iosf_tgt_crd_dec.ccredit_fc == fc)) begin
                    cmd_credit_dec[(ch*3)+fc] = {7'd0, iosf_tgt_crd_dec.ccredit};
                end
               
                // Increment for val and cnt counters when RI pops the queues

                if (ri_tgt_crd_inc.dcreditup & (data_channel_inc == ch) &
                   (ri_tgt_crd_inc.dcredit_fc == fc)) begin
                    data_credit_inc[(ch*3)+fc] = ri_tgt_crd_inc.dcredit;
                end
               
                if (ri_tgt_crd_inc.ccreditup & (cmd_channel_inc == ch) &
                   (ri_tgt_crd_inc.ccredit_fc == fc)) begin
                    cmd_credit_inc[(ch*3)+fc] = {7'd0, ri_tgt_crd_inc.ccredit};
                end
               
                // Decrement for cnt counters on send to IOSF

                if (credit_put_nxt & (|credit_data_nxt) & (credit_chid_nxt == ch) &
                   (credit_rtype_nxt == fc)) begin
                    data_credit_ret[(ch*3)+fc] = {5'd0, credit_data_nxt};
                end
               
                if (credit_put_nxt & credit_cmd_nxt & (credit_chid_nxt == ch) &
                   (credit_rtype_nxt == fc)) begin
                    cmd_credit_ret[(ch*3)+fc] = {7'd0, credit_cmd_nxt};
                end

            end // init_done

        end // fc

    end // ch

end // Credit_Updates

//----------------------------------------------------------------------------
// Credit counters

always_comb begin: Counters

    init_cnt_nxt          = init_cnt;
    init_done_nxt         = init_done;

    data_credit_val_nxt   = data_credit_val;
    cmd_credit_val_nxt    = cmd_credit_val;

    data_credit_cnt_nxt   = data_credit_cnt;
    cmd_credit_cnt_nxt    = cmd_credit_cnt;

    data_credit_val_lti   = '0;
    cmd_credit_val_lti    = '0;
    credit_cnt_gt0        = '0;

    tgt_has_unret_credits = '0;

    credit_put_nxt        = '0;
    credit_cmd_nxt        = '0;
    credit_data_nxt       = '0;
    credit_chid_nxt       = '0;
    credit_rtype_nxt      = '0;

    return_arb_update     = '0;

    //===========================================================
    // Reset conditions: Set val and cnt to initial credit values
    //===========================================================

    if (rst_complete & ~rst_complete_ff) begin: Reset_Values

        data_credit_val_nxt = data_credit_init;
         cmd_credit_val_nxt =  cmd_credit_init;
        data_credit_cnt_nxt = data_credit_init;
         cmd_credit_cnt_nxt =  cmd_credit_init;

    end // Reset_Values

    //==============================================================
    // Credit Init: Send credits to fabric and decrement cnt until 0
    //==============================================================

    

    else if (~(&init_done) & rst_complete_ffd2) begin: Credit_Init

        if ({{(32-CNT_WIDTH){1'b0}}, init_cnt} < (VC*PORTS*3)) begin

            if (|{data_credit_cnt[init_cnt], cmd_credit_cnt[init_cnt]}) begin

                credit_put_nxt   = 1'b1;
                credit_chid_nxt  = credit_chid;
                credit_rtype_nxt = credit_rtype;

                if (data_credit_cnt[init_cnt] > 8'd4) begin

                    data_credit_cnt_nxt[init_cnt] = data_credit_cnt[init_cnt] - 8'd4;       
                    credit_data_nxt               = 3'b100;

                end else begin

                    data_credit_cnt_nxt[init_cnt] = '0;                                     
                    credit_data_nxt               = data_credit_cnt[init_cnt][0 +: 3];
                end

                if (cmd_credit_cnt[init_cnt] > 8'd0) begin

                    cmd_credit_cnt_nxt[init_cnt]  = cmd_credit_cnt[init_cnt] - 8'd1;        
                    credit_cmd_nxt                = 1'b1;

                end else begin

                    cmd_credit_cnt_nxt[init_cnt]  = '0;                                     
                    credit_cmd_nxt                = '0;
                end

            end else begin

                if (credit_rtype == 2'd2) begin
                    credit_chid_nxt  = credit_chid  + {{(`HQM_L2P1(VC*PORTS)-1){1'b0}}, 1'b1};
                    credit_rtype_nxt = '0;
                end else begin
                    credit_rtype_nxt = credit_rtype + 2'd1;
                end

                init_done_nxt[init_cnt] = 1'b1;                                             
                init_cnt_nxt            = init_cnt + {{(CNT_WIDTH-1){1'b0}}, 1'b1};

            end

        end // if init_cnt < (VC*PORTS*3)

    end // Credit_Init

    //=====================================================================
    // Normal Running: Decrement val on credit consumed by target interface
    //                 Increment val on credit freed by RI TLQ
    //                 Increment cnt on credit freed by RI TLQ
    //                 Decrement cnt on credit returned to fabric
    //
    // Cannot change ISM from ACTIVE to IDLE_REQ if outstanding credits to
    // return (val != init value)
    // We have credits to return if cnt is non-zero.
    //=====================================================================

    else if (&init_done) begin: Normal_Running

        for (int i=0; i<(VC*PORTS*3); i++) begin

            data_credit_val_nxt[i] =   data_credit_val[i] +  data_credit_inc[i]
                                                          -  data_credit_dec[i];
                                                            
             cmd_credit_val_nxt[i] =    cmd_credit_val[i] +   cmd_credit_inc[i]
                                                          -   cmd_credit_dec[i];
                                                            
            data_credit_cnt_nxt[i] =   data_credit_cnt[i] +  data_credit_inc[i]
                                                          -  data_credit_ret[i];
                                                            
             cmd_credit_cnt_nxt[i] =    cmd_credit_cnt[i] +   cmd_credit_inc[i]
                                                          -   cmd_credit_ret[i];
                                               
            data_credit_val_lti[i] =   data_credit_val[i] != data_credit_init[i];
                                               
             cmd_credit_val_lti[i] =    cmd_credit_val[i] !=  cmd_credit_init[i];

                 credit_cnt_gt0[i] = |{data_credit_cnt[i],    cmd_credit_cnt[i]};

        end // i

        // If we have any unreturned credits, need to prevent the ISM from
        // transitioning ACTIVE->IDLE_REQ

        tgt_has_unret_credits = |{data_credit_val_lti, cmd_credit_val_lti, credit_cnt_gt0};

    end // Normal_Running

    // Issue updates to the fabric only when the agent ISM is in the ACTIVE state

    if ((&init_done) & (prim_ism_agent == ACTIVE) & return_arb_v) begin: Have_Arb_Winner

        for (int ch=0; ch<(VC*PORTS); ch++) begin

            for (int fc=0; fc<3; fc++) begin

                if ({{(32-`HQM_L2P1(VC*PORTS*3)){1'b0}}, return_arb_index} == ((ch*3)+fc)) begin

                    // Return credits for the return arbitration winner

                    credit_put_nxt   = 1'b1;
                    credit_chid_nxt  = ch[`HQM_L2P1(VC*PORTS)-1:0];
                    credit_rtype_nxt = fc[1:0];

                    if (|cmd_credit_cnt[return_arb_index]) begin
                        credit_cmd_nxt = 1'b1;
                    end

                    // Can only return a max of 4 data credits on any cycle

                    if (data_credit_cnt[return_arb_index] >= 8'd4) begin
                        credit_data_nxt = 3'd4;
                    end else if (data_credit_cnt[return_arb_index] > 8'd0) begin
                        credit_data_nxt = data_credit_cnt[return_arb_index][0 +: 3];
                    end

                    // Update arbitration after any credit return

                    return_arb_update = 1'b1;

                end // arb winner matches loop index

            end // fc

        end // ch

    end // Have_Arb_Winner

end // Counters

//----------------------------------------------------------------------------
// Return arbiter
//
// Select a non-zero credit counter to return the credits to the fabric

hqm_AW_rr_arbiter #(.NUM_REQS(VC*PORTS*3)) i_return_arb (

     .clk           (prim_nonflr_clk)
    ,.rst_n         (prim_gated_rst_b)

    ,.mode          (2'd2)
    ,.update        (return_arb_update)

    ,.reqs          (credit_cnt_gt0)

    ,.winner_v      (return_arb_v)
    ,.winner        (return_arb_index)
);

//----------------------------------------------------------------------------
// Register the outputs to fabric

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
    if (~prim_gated_rst_b) begin
        credit_put   <= '0;
        credit_data  <= '0;
        credit_chid  <= '0;
        credit_cmd   <= '0;
        credit_rtype <= '0;
    end else if (credit_init | (prim_ism_agent == ACTIVE)) begin
        credit_put   <= credit_put_nxt;
        credit_data  <= credit_data_nxt;
        credit_chid  <= credit_chid_nxt;
        credit_cmd   <= credit_cmd_nxt;
        credit_rtype <= credit_rtype_nxt;
    end
end

assign iosf_tgt_credit.credit_put   = credit_put & (credit_init | (prim_ism_agent == ACTIVE));
assign iosf_tgt_credit.credit_chid  = credit_chid;
assign iosf_tgt_credit.credit_rtype = credit_rtype;
assign iosf_tgt_credit.credit_cmd   = credit_cmd;
assign iosf_tgt_credit.credit_data  = credit_data;

//----------------------------------------------------------------------------
// NOA Signals

assign noa_tgtcrdt = {rst_complete
                     ,tgt_has_unret_credits
                     ,credit_init_in_progress
                     ,credit_init_done
                     ,credit_init
                     ,credit_put
                     ,credit_rtype
};

assign tgt_init_hcredits.INIT_HCREDITS_CPL = ep_cplhcredits_sw_rxl;
assign tgt_init_hcredits.INIT_HCREDITS_NP  = ep_nprhcredits_sw_rxl;
assign tgt_init_hcredits.INIT_HCREDITS_P   = ep_prhcredits_sw_rxl;

assign tgt_init_dcredits.INIT_DCREDITS_CPL = ep_cpldcredits_sw_rxl;
assign tgt_init_dcredits.INIT_DCREDITS_NP  = ep_nprdcredits_sw_rxl;
assign tgt_init_dcredits.INIT_DCREDITS_P   = ep_prdcredits_sw_rxl;

assign tgt_rem_hcredits.REM_HCREDITS_CPL   =  cmd_credit_val[2];
assign tgt_rem_hcredits.REM_HCREDITS_NP    =  cmd_credit_val[1];
assign tgt_rem_hcredits.REM_HCREDITS_P     =  cmd_credit_val[0];

assign tgt_rem_dcredits.REM_DCREDITS_CPL   = data_credit_val[2];
assign tgt_rem_dcredits.REM_DCREDITS_NP    = data_credit_val[1];
assign tgt_rem_dcredits.REM_DCREDITS_P     = data_credit_val[0];

assign tgt_ret_hcredits.RET_HCREDITS_CPL   =  cmd_credit_cnt[2];
assign tgt_ret_hcredits.RET_HCREDITS_NP    =  cmd_credit_cnt[1];
assign tgt_ret_hcredits.RET_HCREDITS_P     =  cmd_credit_cnt[0];

assign tgt_ret_dcredits.RET_DCREDITS_CPL   = data_credit_cnt[2];
assign tgt_ret_dcredits.RET_DCREDITS_NP    = data_credit_cnt[1];
assign tgt_ret_dcredits.RET_DCREDITS_P     = data_credit_cnt[0];

`ifndef INTEL_SVA_OFF

generate
 for (genvar assert_ch=0; assert_ch<(VC*PORTS); assert_ch=assert_ch+1) begin: g_assert_ch
  for (genvar assert_fc=0; assert_fc<(VC*PORTS); assert_fc=assert_fc+1) begin: g_assert_fc

   `HQM_SDG_ASSERTS_FORBIDDEN(
     remaining_cmd_credit_underflow
    ,((cmd_credit_val[(assert_ch*3)+assert_fc]=='0) & (cmd_credit_val_nxt[(assert_ch*3)+assert_fc]=='1))
    ,posedge prim_nonflr_clk
    ,~(prim_gated_rst_b & done)
    ,`HQM_SVA_ERR_MSG($psprintf("The remaining header credit counter for channel %d and flowclass %d underflowed!",assert_ch, assert_fc))
    , SDG_SVA_SOC_SIM
   );

   `HQM_SDG_ASSERTS_FORBIDDEN(
     remaining_cmd_credit_overflow
    ,(cmd_credit_val_nxt[(assert_ch*3)+assert_fc]>cmd_credit_init[(assert_ch*3)+assert_fc])
    ,posedge prim_nonflr_clk
    ,~(prim_gated_rst_b & done)
    ,`HQM_SVA_ERR_MSG($psprintf("The remaining header credit counter for channel %d and flowclass %d overflowed!",assert_ch, assert_fc))
    , SDG_SVA_SOC_SIM
   );

   `HQM_SDG_ASSERTS_FORBIDDEN(
     return_cmd_credit_underflow
    ,((cmd_credit_cnt[(assert_ch*3)+assert_fc]=='0) & (cmd_credit_cnt_nxt[(assert_ch*3)+assert_fc]=='1))
    ,posedge prim_nonflr_clk
    ,~(prim_gated_rst_b & done)
    ,`HQM_SVA_ERR_MSG($psprintf("The return header credit counter for channel %d and flowclass %d underflowed!",assert_ch, assert_fc))
    , SDG_SVA_SOC_SIM
   );

   `HQM_SDG_ASSERTS_FORBIDDEN(
     return_cmd_credit_overflow
    ,(cmd_credit_cnt_nxt[(assert_ch*3)+assert_fc]>cmd_credit_init[(assert_ch*3)+assert_fc])
    ,posedge prim_nonflr_clk
    ,~(prim_gated_rst_b & done)
    ,`HQM_SVA_ERR_MSG($psprintf("The return header credit counter for channel %d and flowclass %d overflowed!",assert_ch, assert_fc))
    , SDG_SVA_SOC_SIM
   );

   `HQM_SDG_ASSERTS_FORBIDDEN(
     remaining_data_credit_underflow
    ,((data_credit_val[(assert_ch*3)+assert_fc][3 +: 5]=='0) & (data_credit_val_nxt[(assert_ch*3)+assert_fc][4 +: 4]!='0))
    ,posedge prim_nonflr_clk
    ,~(prim_gated_rst_b & done)
    ,`HQM_SVA_ERR_MSG($psprintf("The remaining data credit counter for channel %d and flowclass %d underflowed!",assert_ch, assert_fc))
    , SDG_SVA_SOC_SIM
   );

   `HQM_SDG_ASSERTS_FORBIDDEN(
     remaining_data_credit_overflow
    ,((data_credit_val_nxt[(assert_ch*3)+assert_fc]>data_credit_init[(assert_ch*3)+assert_fc]) |
      ((data_credit_val[(assert_ch*3)+assert_fc][7 +: 1]=='1) & (data_credit_val_nxt[(assert_ch*3)+assert_fc][6 +: 2]=='0)))
    ,posedge prim_nonflr_clk
    ,~(prim_gated_rst_b & done)
    ,`HQM_SVA_ERR_MSG($psprintf("The remaining data credit counter for channel %d and flowclass %d overflowed!",assert_ch, assert_fc))
    , SDG_SVA_SOC_SIM
   );

   `HQM_SDG_ASSERTS_FORBIDDEN(
     return_data_credit_underflow
    ,((data_credit_cnt[(assert_ch*3)+assert_fc][3 +: 5]=='0) & (data_credit_cnt_nxt[(assert_ch*3)+assert_fc][4 +: 4]!='0))
    ,posedge prim_nonflr_clk
    ,~(prim_gated_rst_b & done)
    ,`HQM_SVA_ERR_MSG($psprintf("The return data credit counter for channel %d and flowclass %d underflowed!",assert_ch, assert_fc))
    , SDG_SVA_SOC_SIM
   );

   `HQM_SDG_ASSERTS_FORBIDDEN(
     return_data_credit_overflow
    ,((data_credit_cnt_nxt[(assert_ch*3)+assert_fc]>data_credit_init[(assert_ch*3)+assert_fc]) |
      ((data_credit_cnt[(assert_ch*3)+assert_fc][7 +: 1]=='1) & (data_credit_cnt_nxt[(assert_ch*3)+assert_fc][6 +: 2]=='0)))
    ,posedge prim_nonflr_clk
    ,~(prim_gated_rst_b & done)
    ,`HQM_SVA_ERR_MSG($psprintf("The return data credit counter for channel %d and flowclass %d overflowed!",assert_ch, assert_fc))
    , SDG_SVA_SOC_SIM
   );

  end
 end
endgenerate

`endif

endmodule

