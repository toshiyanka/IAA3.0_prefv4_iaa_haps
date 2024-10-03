//-----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
//------------------------------------------------------------------------------
// File   : hqm_iosf_func_cov_intf.sv
// Author : rsshekha 
//
//------------------------------------------------------------------------------

`ifndef HQM_IOSF_FUNC_COV_INTF__SV
`define HQM_IOSF_FUNC_COV_INTF__SV

`timescale 1ns/1ps

`define NP_REQ 2'b00
`define CMPL_REQ 2'b10
`define CREDIT_REQ 3'd4
`define IDLE_REQ 3'd1
`define ACTIVE 3'd3
`define IDLE 3'd0
`define HQM_MAX_CREDIT_COUNT_VAL 5'd19
`define TRANSACTION_TYPE 2'b00

interface hqm_iosf_func_cov_intf (
    input  logic        side_clk
   ,input  logic        tpccup 
   ,input  logic        tnpcup
   ,input  logic        tpcput 
   ,input  logic        tnpput
   ,input  logic        mpccup 
   ,input  logic        mnpcup
   ,input  logic        mpcput 
   ,input  logic        mnpput
   ,input  logic [2:0]  side_ism_agent
   ,input  logic [2:0]  side_ism_fabric
   ,input  logic        prim_clk
   ,input  logic [2:0]  prim_ism_agent
   ,input  logic [2:0]  prim_ism_fabric
   ,input  logic        gnt 
   ,input  logic [1:0]  gnt_rtype 
   ,input  logic [1:0]  gnt_type 
   ,input  logic        req_put 
   ,input  logic [1:0]  req_rtype
   ,input  logic        cmd_put 
   ,input  logic [13:0] tdest_id
   ,input  logic [13:0] tsrc_id
);

int prim_p_credits = 0;
int prim_cmpl_credits = 0;

always @(posedge prim_clk) begin
   if (req_put) begin
       if (req_rtype == `NP_REQ) begin 
          prim_p_credits <= prim_p_credits - 1;
       end
       else if (req_rtype == `CMPL_REQ) begin
           prim_cmpl_credits <= prim_cmpl_credits - 1;
       end 
   end
   if (gnt) begin 
       if (gnt_rtype == `NP_REQ) begin
           if (prim_p_credits != `HQM_MAX_CREDIT_COUNT_VAL) begin 
               prim_p_credits <= prim_p_credits + 1;
           end 
       end 
       else if (gnt_rtype == `CMPL_REQ) begin
           if (prim_cmpl_credits != `HQM_MAX_CREDIT_COUNT_VAL) begin 
               prim_cmpl_credits <= prim_cmpl_credits + 1;
           end 
       end 
   end
end 

// Cover property to verify that 'n' back-2-back requests are sent for a particular type without receiving a grant; 
// 'n' is the number of request credits for a particular request type 
// HQM doesn't wait for grant and can generate back-2-back <n> requests without receiving a grant; 
// where <n> is number of request credits for a particular QID 
// HQM can generate back-2-back requests for same QID without waiting for the grant from fabric 
// Cover property to ensure max. value is getting hit for credits outstanding requests are equal to credits advertised.
// for specific test case if advertised more then max value then max value is getting hit. using plusargs if we can achieve this?

sequence prim_p_gnt;
   (gnt && (gnt_rtype == `NP_REQ) && (gnt_type == `TRANSACTION_TYPE));
endsequence : prim_p_gnt 
 
sequence prim_p_req_put;
   (req_put && (req_rtype == `NP_REQ));
endsequence : prim_p_req_put

sequence prim_cmpl_gnt;
   (gnt && (gnt_rtype == `CMPL_REQ) && (gnt_type == `TRANSACTION_TYPE));
endsequence : prim_cmpl_gnt
 
sequence prim_cmpl_req_put;
   (req_put && (req_rtype == `CMPL_REQ));
endsequence : prim_cmpl_req_put 

sequence prim_p_credits_exhausted;
    (prim_p_credits == 0);
endsequence : prim_p_credits_exhausted

sequence prim_cmpl_credits_exhausted;
    (prim_cmpl_credits == 0);
endsequence : prim_cmpl_credits_exhausted
 
property prim_p_req_credits_exhausted_scenario;
    prim_p_gnt ##[0:$] prim_p_credits_exhausted ##[0:$] prim_p_gnt;
endproperty : prim_p_req_credits_exhausted_scenario 

property prim_cmpl_req_credits_exhausted_scenario;
    prim_cmpl_gnt ##[0:$] prim_cmpl_credits_exhausted ##[0:$] prim_cmpl_gnt;
endproperty : prim_cmpl_req_credits_exhausted_scenario 

property prim_p_req_credits_exhausted_in_rollover_scenario;
    disable iff (!$test$plusargs("HQM_P_CREDIT_ROLLOVER_COV")) prim_p_gnt ##[0:$] prim_p_credits_exhausted ##[0:$] prim_p_gnt;
endproperty : prim_p_req_credits_exhausted_in_rollover_scenario 

property prim_cmpl_req_credits_exhausted_in_rollover_scenario;
    disable iff (!$test$plusargs("HQM_CMPL_CREDIT_ROLLOVER_COV")) prim_cmpl_gnt ##[0:$] prim_cmpl_credits_exhausted ##[0:$] prim_cmpl_gnt;
endproperty : prim_cmpl_req_credits_exhausted_in_rollover_scenario 

// if credits for one type of requst are exhausted, the remaining requests are not blocked.
property prim_cmpl_req_after_p_req_credits_exhausted;
    prim_p_gnt ##[0:$] prim_p_credits_exhausted ##[0:$] prim_cmpl_req_put ##[0:$] prim_p_gnt;
endproperty : prim_cmpl_req_after_p_req_credits_exhausted 

property prim_p_req_after_cmpl_req_credits_exhausted;
    prim_cmpl_gnt ##[0:$] prim_cmpl_credits_exhausted ##[0:$] prim_p_req_put ##[0:$] prim_cmpl_gnt;
endproperty : prim_p_req_after_cmpl_req_credits_exhausted

// HQM is able to process transaction grant on same cycle as request put
property prim_p_gnt_req_put;
   prim_p_gnt |-> prim_p_req_put;
endproperty : prim_p_gnt_req_put

property prim_cmpl_gnt_req_put;
   prim_cmpl_gnt |-> prim_cmpl_req_put;
endproperty : prim_cmpl_gnt_req_put

// Destination ID field on the command interface must not be used for calculating command parity
property prim_target_intf_cmd_parity;
    cmd_put |-> (^tdest_id);
endproperty : prim_target_intf_cmd_parity

property prim_master_intf_cmd_parity;
    cmd_put |-> (^tsrc_id);
endproperty : prim_master_intf_cmd_parity

// HQM adheres to the rule "Message flit put in clock N cannot be function of credit update in clock N"
property side_p_put_credit_put_in_clkn;
    disable iff (!$test$plusargs("HQM_FLIT_PUT_CREDIT_UPDATE_CLK_N_CHK")) (mpccup |-> !mpcput);
endproperty : side_p_put_credit_put_in_clkn

property side_np_put_credit_put_in_clkn;
    disable iff (!$test$plusargs("HQM_FLIT_PUT_CREDIT_UPDATE_CLK_N_CHK")) (mnpcup |-> !mnpput);
endproperty : side_np_put_credit_put_in_clkn

property prim_agent_credit_req_first;
    ( (prim_ism_agent == `CREDIT_REQ) && (prim_ism_fabric == `IDLE) ); 
endproperty : prim_agent_credit_req_first

property prim_fabric_credit_req_first;
    ( (prim_ism_agent == `IDLE) && (prim_ism_fabric == `CREDIT_REQ) );
endproperty : prim_fabric_credit_req_first

property prim_agent_fabric_credit_req_same;
    ( (prim_ism_agent == `IDLE) && (prim_ism_fabric == `IDLE) ) |=> ( (prim_ism_agent == `CREDIT_REQ) && (prim_ism_fabric == `CREDIT_REQ) ); 
endproperty : prim_agent_fabric_credit_req_same

property side_agent_credit_req_first;
    ( (side_ism_agent == `CREDIT_REQ) && (side_ism_fabric == `IDLE) ); 
endproperty : side_agent_credit_req_first

property side_fabric_credit_req_first;
    ( (side_ism_agent == `IDLE) && (side_ism_fabric == `CREDIT_REQ) );
endproperty : side_fabric_credit_req_first

property side_agent_fabric_credit_req_same;
    ( (side_ism_agent == `IDLE) && (side_ism_fabric == `IDLE) ) |=> ( (side_ism_agent == `CREDIT_REQ) && (side_ism_fabric == `CREDIT_REQ) ); 
endproperty : side_agent_fabric_credit_req_same

// On sideband hqm must be capable of accepting a flit one clock cycle after it issues a credit update P and NP
// Posted 
property side_p_crd_up_req_put;
    tpccup |=> tpcput;
endproperty: side_p_crd_up_req_put

// Non Posted
property side_np_crd_up_req_put;
    tnpcup |=> tnpput; 
endproperty: side_np_crd_up_req_put

property prim_cmd_put_in_agent_idle_req;
    ($rose(cmd_put) && (prim_ism_agent == `IDLE_REQ)) |-> (prim_ism_agent == `ACTIVE) [*12];
endproperty: prim_cmd_put_in_agent_idle_req

HQM_SIDE_P_CREDIT_UP_REQ_PUT                              : cover property (@(posedge side_clk) side_p_crd_up_req_put);
HQM_SIDE_NP_CREDIT_UP_REQ_PUT                             : cover property (@(posedge side_clk) side_np_crd_up_req_put);
HQM_PRIM_P_REQ_CREDITS_EXHAUSTED_SCENARIO                 : cover property (@(posedge prim_clk) prim_p_req_credits_exhausted_scenario);
HQM_PRIM_CMPL_REQ_CREDITS_EXHAUSTED_SCENARIO              : cover property (@(posedge prim_clk) prim_cmpl_req_credits_exhausted_scenario);
HQM_PRIM_P_REQ_AFTER_CMPL_REQ_CREDITS_EXHAUSTED           : cover property (@(posedge prim_clk) prim_p_req_after_cmpl_req_credits_exhausted);
HQM_PRIM_CMPL_REQ_AFTER_P_REQ_CREDITS_EXHAUSTED           : cover property (@(posedge prim_clk) prim_cmpl_req_after_p_req_credits_exhausted);
HQM_PRIM_P_REQ_CREDITS_EXHAUSTED_IN_ROLLOVER_SCENARIO     : cover property (@(posedge prim_clk) prim_p_req_credits_exhausted_in_rollover_scenario);
HQM_PRIM_CMPL_REQ_CREDITS_EXHAUSTED_IN_ROLLOVER_SCENARIO  : cover property (@(posedge prim_clk) prim_cmpl_req_credits_exhausted_in_rollover_scenario);
HQM_PRIM_P_GNT_REQ_PUT                                    : cover property (@(posedge prim_clk) prim_p_gnt_req_put);
HQM_PRIM_CMPL_GNT_REQ_PUT                                 : cover property (@(posedge prim_clk) prim_cmpl_gnt_req_put);
HQM_PRIM_TARGET_INTF_CMD_PARITY                           : cover property (@(posedge prim_clk) prim_target_intf_cmd_parity);
HQM_PRIM_MASTER_INTF_CMD_PARITY                           : cover property (@(posedge prim_clk) prim_master_intf_cmd_parity);
HQM_PRIM_ISM_AGENT_CREDIT_REQ_FIRST                       : cover property (@(posedge prim_clk) prim_agent_credit_req_first);
HQM_PRIM_ISM_FABRIC_CREDIT_REQ_FIRST                      : cover property (@(posedge prim_clk) prim_fabric_credit_req_first);
HQM_PRIM_ISM_AGENT_FABRIC_CREDIT_REQ_SAME                 : cover property (@(posedge prim_clk) prim_agent_fabric_credit_req_same);
HQM_SIDE_ISM_AGENT_CREDIT_REQ_FIRST                       : cover property (@(posedge side_clk) side_agent_credit_req_first);
HQM_SIDE_ISM_FABRIC_CREDIT_REQ_FIRST                      : cover property (@(posedge side_clk) side_fabric_credit_req_first);
HQM_SIDE_ISM_AGENT_FABRIC_CREDIT_REQ_SAME                 : cover property (@(posedge side_clk) side_agent_fabric_credit_req_same);
HQM_PRIM_CMD_PUT_IN_AGENT_IDLE_REQ                        : cover property (@(posedge prim_clk) prim_cmd_put_in_agent_idle_req);

HQM_SIDE_P_PUT_CREDIT_PUT_IN_CLKN_CHK                     : assert property (@(posedge side_clk) side_p_put_credit_put_in_clkn) 
else $error ("hqm_iosf_func_cov_intf : Failure for Check : P Message put in clock N cannot be function of credit update in clock N");

HQM_SIDE_NP_PUT_CREDIT_PUT_IN_CLKN_CHK                    : assert property (@(posedge side_clk) side_np_put_credit_put_in_clkn) 
else $error ("hqm_iosf_func_cov_intf : Failure for Check : NP Message flit put in clock N cannot be function of credit update in clock N");

endinterface : hqm_iosf_func_cov_intf 

`undef NP_REQ
`undef CMPL_REQ
`undef CREDIT_REQ
`undef IDLE_REQ
`undef ACTIVE
`undef IDLE
`undef HQM_MAX_CREDIT_COUNT_VAL
`undef TRANSACTION_TYPE

`endif
