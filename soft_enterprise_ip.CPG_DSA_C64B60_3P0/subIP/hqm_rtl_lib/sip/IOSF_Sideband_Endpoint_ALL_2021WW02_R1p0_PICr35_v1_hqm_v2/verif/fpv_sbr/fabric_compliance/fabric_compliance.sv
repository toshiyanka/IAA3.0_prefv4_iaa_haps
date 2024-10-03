`include "iosf_sb_lib_utils.svh"

`include "iosf_sb_types.svh"

module

 iosf_sb_compliance #(
   parameter MAX_AGENT_NP_CREDITS = IOSF_COMPMON_SB_DEF_MAX_AGENT_NP_CREDITS,
   parameter MAX_AGENT_PC_CREDITS = IOSF_COMPMON_SB_DEF_MAX_AGENT_PC_CREDITS,
   parameter MAX_FABRIC_NP_CREDITS = IOSF_COMPMON_SB_DEF_MAX_FABRIC_NP_CREDITS,
   parameter MAX_FABRIC_PC_CREDITS = IOSF_COMPMON_SB_DEF_MAX_FABRIC_PC_CREDITS,
   parameter PAYLOAD_BANDWIDTH = IOSF_COMPMON_SB_DEF_PAYLOAD_BANDWIDTH,
   parameter MAX_PENDING_REQUESTS = IOSF_COMPMON_SB_DEF_MAX_PENDING_REQUESTS,
   parameter int DISABLE_CLK_ACK   = IOSF_COMPMON_SB_DEF_DISABLE_CLK_ACK_STRAP,
`ifndef SYNTHESIS                       
   parameter string LOGFILE = IOSF_COMPMON_SB_DEF_LOGFILE, 
   parameter string AGENT_ID = "Agent",
   parameter string FABRIC_ID = "Fabric",
`endif 
   parameter AGENT_IS_DUT = 0,
   parameter FABRIC_IS_DUT = 1,
   parameter CHECKER_IS_DUT = 0
)
(
   // Master Interface Signals
   input bit mnpput, // Non-Posted Put from master to target
   input bit mpcput, // Posted or Completion Put from master to target
   input bit mnpcup, // Non-Posted Credit Update from target to master
   input bit mpccup, // Posted or Completion Credit Update from target to master
   input bit meom,   // End of Message from master to target
   input bit [PAYLOAD_BANDWIDTH-1:0]  mpayload, 
                     // Message Payload from master to target

   // Target Interface Signals
   input bit tnpput, // Non-Posted Put to target from master
   input bit tpcput, // Posted or Completion Put to target from master
   input bit tnpcup, // Non-Posted Credit Update to master from target
   input bit tpccup, // Posted or Completion Credit Update to master from target
   input bit teom,   // End of Message to target from master
   input bit [PAYLOAD_BANDWIDTH-1:0]  tpayload, 
                     // Message Payload to target from master

  // Reset states for agent and fabric ISMs (CREDIT_REQ of IDLE)
   input bit                   Agent_ISM_Reset_IDLE,
   input bit                   Fabric_ISM_Reset_IDLE,
 
  // Power Management
   input bit [IOSF_COMPMON_ISM_WIDTH-1:0] side_ism_fabric, 
                      // Sideband Fabric Idle State Machine
   input bit [IOSF_COMPMON_ISM_WIDTH-1:0] side_ism_agent, 
                      // Sideband Agent Idle State Machine
   input bit side_clkreq, // Sideband Clock Request
   input bit side_clkack, // Sideband Clock Ack     
   input bit side_clk,    // Sideband Clock
   input bit side_rst_b,  // Sideband Reset

   // EH and SAI extension 
   input bit eh_support,   // Default should be set to 0
   input bit sai_support,  // Default should be set to 0
   input logic Disable_Final_Checks,
   // Multicast Parameters 
   input bit[255:0] [7:0] mcast_num_pids,
   input bit[255:0] [7:0] mcast_num_pids_agent
 
      // If mcast_num_pids[pid] is > 0, it means pid is a group id and the
      // number is the number of physical ports in the group
);

   iosf_sb_ifc_compliance #(.MAX_AGENT_NP_CREDITS (MAX_AGENT_NP_CREDITS),
                            .MAX_AGENT_PC_CREDITS (MAX_AGENT_PC_CREDITS),
                            .MAX_FABRIC_NP_CREDITS (MAX_FABRIC_NP_CREDITS),
                            .MAX_FABRIC_PC_CREDITS (MAX_FABRIC_PC_CREDITS),
                            .PAYLOAD_BANDWIDTH (PAYLOAD_BANDWIDTH),
                            .AGENT_IS_DUT(AGENT_IS_DUT),
                            .FABRIC_IS_DUT(FABRIC_IS_DUT),
                            .CHECKER_IS_DUT(CHECKER_IS_DUT)
                            )
      sbc_ifc_compliance 
       (
         .mnpput (mnpput),
         .mpcput (mpcput),
         .mnpcup (mnpcup),
         .mpccup (mpccup),
         .meom   (meom),    
         .mpayload (mpayload),
         
         // Target Interface Signals
         .tnpput (tnpput), 
         .tpcput (tpcput), 
         .tnpcup (tnpcup), 
         .tpccup (tpccup), 
         .teom   (teom),     
         .tpayload (tpayload),
         
         // Power Management
         .side_ism_fabric (side_ism_fabric),
         .side_ism_agent (side_ism_agent), 
         .side_clkreq (side_clkreq), 
         .side_clkack (side_clkack),
         .side_clk(side_clk),
         .side_rst_b(side_rst_b),

         //0.9 and mcast related straps
         //Needs review for consistency with this model.
         .Agent_ISM_Reset_IDLE(Agent_ISM_Reset_IDLE),
         .Fabric_ISM_Reset_IDLE(Fabric_ISM_Reset_IDLE),
         .eh_support(1'b1),
         .sai_support(sai_support),
         .mcast_num_pids(mcast_num_pids),
         .mcast_num_pids_agent(mcast_num_pids_agent)
         );

   
endmodule
                            

