// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_pm_fsm
// -- Author : Dannie Feekes
// -- Project Name : Cave Creek
// -- Creation Date: Monday July 13, 2009
// -- Description :
// -- Power management state machine.  
// -- Each physical function has an independent power management 
// -- state machine for the physical layer. In Cave Creek, we do not
// -- support D1 & D2. What is implemented here is the PCIE compliant 
// -- D0 hot, cold and D3 active & uninitialized states.
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_ri_pm_fsm

     import hqm_pkg::*, hqm_system_pkg::*, hqm_system_type_pkg::*;
(
    //-----------------------------------------------------------------
    // Clock and reset
    //-----------------------------------------------------------------

     input logic            prim_nonflr_clk
    ,input logic            prim_gated_rst_b

    //-----------------------------------------------------------------
    // Inputs 
    //-----------------------------------------------------------------

    ,input logic            power_down              // EP has powered down or link has moved to L2/L3 
    ,input logic            pm_enable               // power management enable
    ,input logic[1:0]       csr_ppmcsr_ps           // The power state from the PPMCSR
    ,input logic            flr                     // Function level reset executed
    ,input logic            bme_or_mem_wr           // Bus master enable or a memory write has been executed.
    ,input logic            pm_fsm_d0tod3_ok                        
    ,input logic            pm_fsm_d3tod0_ok                        
    ,input logic            ps_cpl_sent             // Sent out the completion for the write of D0->D3

    //-----------------------------------------------------------------
    // Outputs
    //-----------------------------------------------------------------
    ,output logic           pm_fsm_rst              // Signal function reset 
    ,output pm_fsm_t        pm_state                // The power management state of the function 
    ,output logic           ps_cpl_sent_ack         // Did the D0->D3 transition
);

logic flr_pending_nxt ;
logic flr_pending_f ;

pm_fsm_t            pm_cur_state;          // The current power management state
pm_fsm_t            pm_nxt_state;          // The next power management state

// ------------------------------------------------------------------------
// Power Management State Machine
//
//                           PMCSR=D0 or FLR             
//     ---------- ---------------------------------> ------------       
//     | D3COLD |       +--------------------------> | D0UNINIT |
//     ----------       |FLR                         ------------       
// power^  |csr write   |                              ^  |                    
// down |  |  +---------+                           FLR|  |BME or memory write
//      |  V  |            csr write & PMCSR=D0        |  V
//     --------- ---------------------------------> ---------       
//     | D3HOT | <--------------------------------- | D0ACT |
//     ---------           csr write & PMCSR=D3     ---------       
//                                                      
// ------------------------------------------------------------------------

always_comb begin: pm_nxt_state_p

    // Default State Assignments

    flr_pending_nxt     = flr_pending_f ;
    pm_nxt_state        = pm_cur_state;
    pm_fsm_rst          = 1'b0;
    ps_cpl_sent_ack     = 1'b0;

    case (pm_cur_state)

        // The D3 Cold state. When in this state, The link is in L2/L3 and
        // the function is disabled. Power can be removed from the function.
        // The act of writing a CSR to the function will move the function
        // to the D3 Hot state. If the PPMCSR PS bits are set to zero the
        // power management state will move to D0 uninitialized.

        PM_FSM_D3COLD: begin

            if (~pm_enable) begin
                pm_nxt_state        = PM_FSM_D0UNINIT;
            end // !pm_enable

            else if (csr_ppmcsr_ps == 2'h3) begin
                pm_nxt_state        = PM_FSM_D3HOT;
            end // PPMCSR.PS = 3 

            else if (pm_fsm_d3tod0_ok & (csr_ppmcsr_ps == 2'h0)) begin
                pm_nxt_state        = PM_FSM_D0UNINIT;
            end // cds_pm_ack_msg 

        end // case PM_FSM_D3COLD

        // This is the D3 hot power state where the function can be powered down
        // but the current state of the CSRs are maintained and RI will respond
        // to messages and CSR writes. All other transactions  will be either
        // unsupported requests or unexpected completions.

        PM_FSM_D3HOT: begin

            if (flr_pending_f | flr | ~pm_enable) begin
                if (pm_fsm_d3tod0_ok) begin
                    pm_nxt_state    = PM_FSM_D0UNINIT;
                    pm_fsm_rst      = flr_pending_f | flr; 
                    flr_pending_nxt = 1'd0 ;
                end
                else begin
                    flr_pending_nxt = flr_pending_f | flr ;
                end
            end

            else if (power_down) begin
                pm_nxt_state        = PM_FSM_D3COLD;
            end

            else if (pm_fsm_d3tod0_ok & (csr_ppmcsr_ps == 2'h0)) begin
                pm_nxt_state        = PM_FSM_D0ACT;
            end

        end // case PM_FSM_D3HOT

        // The D0 unitialized state. The function can transition from the 
        // unitialized state to the active state by setting bus master 
        // enable or by executing a memory write that hits one of the BARS
        // in the function. To transition to the D3 state the PMCSR must
        // be programmed to D3 then TI will need to indicate that the
        // link is down.

        PM_FSM_D0UNINIT: begin

            if (~pm_enable | flr) begin
                pm_nxt_state        = PM_FSM_D0UNINIT;
                pm_fsm_rst          = flr; 
            end

            else if (bme_or_mem_wr & !power_down) begin
                pm_nxt_state        = PM_FSM_D0ACT;
            end

        end // PM_FSM_D0UNINIT 
       
        // The D0 Active state. This state is achieved by programming the
        // PMCSR PS to 0 from the D3 hot state or by setting the bus master
        // enable bit when in the D0 unitialized state.

        PM_FSM_D0ACT: begin

            if (~pm_enable | flr) begin
                pm_nxt_state        = PM_FSM_D0UNINIT;
                pm_fsm_rst          = flr; 
                ps_cpl_sent_ack     = 1'b1;
            end

            else if (pm_fsm_d0tod3_ok & (csr_ppmcsr_ps == 2'h3) & ps_cpl_sent) begin
                pm_nxt_state        = PM_FSM_D3HOT;
                ps_cpl_sent_ack     = 1'b1;
            end

            else if (pm_fsm_d0tod3_ok & power_down & ps_cpl_sent) begin
                pm_nxt_state        = PM_FSM_D3COLD;
                ps_cpl_sent_ack     = 1'b1;
            end

        end // PM_FSM_D0ACT 

        default: begin

                pm_nxt_state        = PM_FSM_D0UNINIT;

        end // default case

    endcase

end // always_comb pm_nxt_state_p

// ------------------------------------------------------------------------
// Power Management State Machine
// The next power management state is assigned here.
// ------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: pm_cur_state_p

    // PCIE spec states that when the function comes out of function level
    // reset, it will enter the D0 uninitialized state.

    if (!prim_gated_rst_b) begin
        flr_pending_f <= 1'b0 ;
        pm_cur_state <= PM_FSM_D0UNINIT;
    end
    else begin
        flr_pending_f <= flr_pending_nxt ;
        pm_cur_state <= pm_nxt_state;
    end

end // always_ff  pm_cur_state_p

// ------------------------------------------------------------------------
// Function Power Management State
// ------------------------------------------------------------------------

always_comb begin: pm_state_p

    pm_state = pm_cur_state;

end // always_comb pm_sate_p

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Assertions 
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

endmodule // hqm_ri_pm_fsm

