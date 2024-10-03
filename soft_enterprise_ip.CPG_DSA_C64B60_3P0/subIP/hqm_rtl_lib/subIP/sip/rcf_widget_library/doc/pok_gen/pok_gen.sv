///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///
///  This module deasserts side_pok and asserts ism_lock_b when a ForcePwrGatePOK message is recieved
///  and conditions allow entry to ip-inaccessible state.  

module pok_gen
   (input logic  side_clk,
    input logic  side_rst_b,       // async assert, sync'ed deassert
                                   // all remaining inputs are assumed synchronous to side_clk
    input logic  [1:0] fpgpok_req, // 2 bit type file of the ForcePwrGatePOK message, only acts on 2'b01
    input logic  [2:0] ism_agent,  // must not have any flops between the output of the endpoint and this input
    input logic  wake,             // pm_ip_wake, optional, used to cause transition from INACCESSIBLE to ACCESSIBLE state - if not used tie to 1'b1
    input logic  sbe_idle,         // sb endpoint is idle - all credits have been returned
    input logic  fpgpok_holdoff,   // ip's NP queue status, all outgoing NP requests must be completed.  
                                   // Any ip specific reasons to keep the endpoint accessible may be included in this term

    output logic ism_lock_b,       // unflopped - must not have any flops between this output and the corresponding input on the endpoint
    output logic side_pok          // flopped output to router and local PMA
    );

   typedef enum logic [1:0]
   {
    INACCESSIBLE = 2'd0,
    ASSERT_POK   = 2'd1,
    ACCESSIBLE   = 2'd2,
    LOCK         = 2'd3
   } POK_STATE_t;
   
   POK_STATE_t pok_state, next_pok_state;

   logic        fpgpok_req_held;        
   logic        fpgpok_req_held_set;
   logic        ok_to_assert_pok, ok_to_lock;
   
   always_comb
     begin
        ok_to_assert_pok = side_rst_b && wake;
        ok_to_lock       = fpgpok_req_held && (ism_agent == 3'b0) && sbe_idle && !fpgpok_holdoff;
        
        if (!side_rst_b) next_pok_state = INACCESSIBLE;
        else begin
           next_pok_state = pok_state;
           unique case (pok_state)
             INACCESSIBLE: if (ok_to_assert_pok) next_pok_state = ASSERT_POK;
             ASSERT_POK:                         next_pok_state = ACCESSIBLE;
             ACCESSIBLE:   if (ok_to_lock)       next_pok_state = LOCK;
             LOCK:         if (!side_rst_b)      next_pok_state = INACCESSIBLE;
           endcase // case (pok_state)
        end // else: !if(!rst_b)

        unique case (next_pok_state)
          INACCESSIBLE: ism_lock_b = '0;       
          ASSERT_POK:   ism_lock_b = '0;               
          ACCESSIBLE:   ism_lock_b = '1;               
          LOCK:         ism_lock_b = '0;
        endcase // unique case (next_pok_state)

        // note that bit[0] of fpgpok_req is the bit that requests deassertion of the pok, bit[1] requests the IP be power gated, fpgpok_req == 2'b10 is invalid
        fpgpok_req_held_set = (fpgpok_req == 2'b01) || (fpgpok_req == 2'b11);

        unique case (next_pok_state)
          INACCESSIBLE: pre_side_pok = '0;
          ASSERT_POK:   pre_side_pok = '1;
          ACCESSIBLE:   pre_side_pok = '1;
          LOCK:         pre_side_pok = (pok_state == ACCESSIBLE);  //pok is asserted for the first cycle in this state and then deasserted
        endcase // unique case (next_pok_state)
  
     end // always_comb

   always_ff @(posedge side_clk or negedge side_rst_b)
     begin
        if (!side_rst_b) pok_state <= INACCESSIBLE;
        else             pok_state <= next_pok_state;

        if (!side_rst_b)               fpgpok_req_held <= '0;
        else if (fpgpok_req_held_set)  fpgpok_req_held <= '1;  // hold the request until side_rst_b happens
     end // always_ff @

   // metaflop on pok output because of sgcdc_rdc this must not go metastable to the global router which is still active
   // replace cell with your own version if you use this 
   rcfwl_ctech_doublesync pok_sync (.d(pre_pok),
                                    .o(pok),
                                    .clk(side_clk));
   
endmodule // rcfwl_pok_gen
