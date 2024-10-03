// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_pm
// -- Author : Dannie Feekes
// -- Project Name : Cave Creek
// -- Creation Date: Monday July 14, 2009
// -- Description :
// -- Power management FUB
// -- Here resides the power management state machines for each
// -- physical functions. Each function has it's own power management
// -- state machine along with the logic for initiating/signaling
// -- FLR to the GIGE and SHAC.
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_ri_pm

     import hqm_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*;
(
    //-----------------------------------------------------------------
    // Clock and reset
    //-----------------------------------------------------------------

     input  logic               prim_freerun_clk
    ,input  logic               prim_nonflr_clk
    ,input  logic               prim_gated_rst_b
    ,input  logic               side_gated_rst_prim_b       // side_rst_b synced to prim_clk

    //-----------------------------------------------------------------
    // Inputs
    //-----------------------------------------------------------------

    ,input  logic[1:0]          csr_pf0_ppmcsr_ps_c         // Power management state of PF0
    ,input  logic               csr_pdc_start_flr           // Function level resets for functions
    ,input  logic               csr_pcicmd_io               // Io space enable
    ,input  logic               csr_pcicmd_mem              // Memory space enable
    ,input  logic               pm_fsm_d0tod3_ok
    ,input  logic               pm_fsm_d3tod0_ok

    ,input  logic               ri_bme_rxl

    ,input  logic               flr_txn_sent                // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  nphdr_tag_t         flr_txn_tag                 // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  hdr_reqid_t         flr_txn_reqid               // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic               ps_txn_sent                 // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  nphdr_tag_t         ps_txn_tag                  // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  hdr_reqid_t         ps_txn_reqid                // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic               gnt                         // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic [1:0]         gnt_rtype                   // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic               mrsvd1_7                    // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic               mrsvd1_3                    // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic [7:0]         mtag                        // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic [15:0]        mrqid                       // added for DCN 90006 - FLR to be tied to secondary bus reset

    //-----------------------------------------------------------------
    // Outputs
    //-----------------------------------------------------------------

    ,output logic               pm_idle                     // Idle indication (keep clocks on during pending FLR)
    ,output pm_fsm_t            pm_state                    // Current power management fsm state
    ,output logic               ri_pf_disabled_wxp          // Disabled Physical Functions
    ,output logic               pm_rst                      // Per function early indication that flr is coming
    ,output logic               pm_pf_rst_wxp               // Per function power management derived reset (enter D3)
    ,output logic               func_in_rst                 // Per function is in reset indication
    ,output logic               pm_deassert_intx            // Force legacy interrupts low on reset physical function.

    // PM -> EP_CLUSTER

    ,output logic               flr_clk_enable              // Clock enable based on FLR for non-system logic
    ,output logic               flr_clk_enable_system       // Clock enable based on FLR for system logic
    ,output logic [6:0]         flr_triggered_wl            // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic               flr_treatment               // Using this to gate off bme/io/mem indication until FLR nukes it
    ,output logic [9:0]         flr_visa
);

logic                       power_down;
logic                       bme_or_mem_wr;
pm_fsm_t                    pf0_pm_state;
rst_cnt_t                   rst_act_cnt;
logic                       pm_fsm_rst;
logic                       pm_pf_rst;                  // Active low!
logic                       pm_pf_rst_q;                // Active low!

////////////////////////////////////////////////////////////////////////////
// DCN 90006 - FLR to be tied to secondary bus reset
////////////////////////////////////////////////////////////////////////////
// inputs from hqm_ri_cds to tell us if they sent an FLR or PS request

logic                       flr_txn_sent_q;
nphdr_tag_t                 flr_txn_tag_q;
hdr_reqid_t                 flr_txn_reqid_q;

logic                       ps_txn_sent_q;
nphdr_tag_t                 ps_txn_tag_q;
hdr_reqid_t                 ps_txn_reqid_q;

// detect a completion getting granted, then check if its the cmpl for the FLR or PS

logic                       gnt_f;
logic                       gnt_f2;
logic [1:0]                 gnt_rtype_f;
logic [1:0]                 gnt_rtype_f2;
logic [9:0]                 mtag_f;
logic [15:0]                mrqid_f;

logic                       flr_cpl_sent_next;
logic                       flr_cpl_sent_q;
logic                       flr_triggered_wp;

logic                       ps_cpl_sent_next;
logic                       ps_cpl_sent_q;
logic                       ps_cpl_sent;
logic                       ps_cpl_sent_ack;

//-----------------------------------------------------------------------------
// Function 0 Power Management State Machine
//-----------------------------------------------------------------------------

logic flr;

assign flr = csr_pdc_start_flr & flr_cpl_sent_q & ~(|rst_act_cnt);

hqm_ri_pm_fsm i_ri_pm_fsm_pf0 (

     .prim_nonflr_clk       (prim_nonflr_clk)
    ,.prim_gated_rst_b      (prim_gated_rst_b)

    ,.power_down            (power_down)
    ,.pm_enable             (1'b1)
    ,.csr_ppmcsr_ps         (csr_pf0_ppmcsr_ps_c)
    ,.flr                   (flr)
    ,.bme_or_mem_wr         (bme_or_mem_wr)
    ,.pm_fsm_d0tod3_ok      (pm_fsm_d0tod3_ok)
    ,.pm_fsm_d3tod0_ok      (pm_fsm_d3tod0_ok)
    ,.ps_cpl_sent           (ps_cpl_sent)
    ,.ps_cpl_sent_ack       (ps_cpl_sent_ack)

    ,.pm_fsm_rst            (pm_fsm_rst)
    ,.pm_state              (pf0_pm_state)
);

assign pm_state  = pf0_pm_state;

assign pm_rst = pm_fsm_rst;

//-------------------------------------------------------------------------
// Physical Function Power/Link Down State
//-------------------------------------------------------------------------

always_comb begin: power_down_p
    power_down = 1'b0;
end // always_comb power_down_p

//-------------------------------------------------------------------------
// D0 Uninitialized to D0 Active Logic
//-------------------------------------------------------------------------

always_comb begin: bme_or_mem_wr_p

    // The PCIE power management spec state that the device will go from D0
    // uninitialized to the active sate if either a CSR memory write or the
    // bus master enable has been set for a given function.
    // fix for ticket 3542241

    bme_or_mem_wr = (ri_bme_rxl | csr_pcicmd_io | csr_pcicmd_mem) & ~flr_treatment;

end // always_comb bme_or_mem_wr_p

//-------------------------------------------------------------------------
// Function Level Reset Active Count
// These counters need to be on the ungated clock!
//-------------------------------------------------------------------------

always_ff @(posedge prim_freerun_clk or negedge side_gated_rst_prim_b) begin: rst_act_cnt_p

    // The following is an array of counters. One per function. When
    // a functional reset has been initiated for a given function,
    // the following logic will allow us to hold the reset signal
    // low for a given number of clocks.

    if (~side_gated_rst_prim_b) begin

        pm_pf_rst_q           <= '1;
        rst_act_cnt           <= '0;
        flr_clk_enable        <= '1;
        flr_clk_enable_system <= '1;

    end else begin

        // Function reset initiated detect. Set the counter for the
        // number of clocks we will hold reset low.

        pm_pf_rst_q <=  pm_pf_rst;

        if (pm_rst) begin

            rst_act_cnt <= `HQM_FUNC_RST_CNTR_SZ'd192;

        // If the counter has been started, continue to count down until
        // we get to 0.

        end else if (|rst_act_cnt) begin

            rst_act_cnt <= rst_act_cnt - `HQM_FUNC_RST_CNTR_SZ'd1;
        end


        flr_clk_enable        <= (rst_act_cnt > `HQM_FUNC_RST_CNTR_SZ'd64) |
                                 (rst_act_cnt < `HQM_FUNC_RST_CNTR_SZ'd32);

        flr_clk_enable_system <= (rst_act_cnt > `HQM_FUNC_RST_CNTR_SZ'd128) |
                                 (rst_act_cnt < `HQM_FUNC_RST_CNTR_SZ'd32);

    end

end // always_ff rst_act_cnt_p

assign pm_pf_rst_wxp  = pm_pf_rst_q;

// This signal is used by ri_cds to silently discard transactions for a
// function during its FLR

assign func_in_rst    = |{flr_txn_sent, flr_txn_sent_q, rst_act_cnt, ~flr_triggered_wl[0]};

assign pm_idle        = ~|{rst_act_cnt, flr_txn_sent_q, ps_txn_sent_q};

//-------------------------------------------------------------------------
// Physical Function Reset Signal
//-------------------------------------------------------------------------

always_comb begin: ri_rst_p

    // Active low reset signal. Held low for at least 96 clocks.

    pm_pf_rst = (rst_act_cnt == `HQM_FUNC_RST_CNTR_SZ'd0 ) ||     
                (rst_act_cnt >  `HQM_FUNC_RST_CNTR_SZ'd96);

end // always ri_rst_p

//-------------------------------------------------------------------------
// Control to Deassert Legacy Interrupts
//-------------------------------------------------------------------------

always_comb begin: pm_deassert_intx_p

    // Anytime that the reset counter has been started is when we should
    // force all legacy interrupts low so that a de-assert message
    // is sent prior to the reset being asserted.

     pm_deassert_intx = rst_act_cnt != {`HQM_FUNC_RST_CNTR_SZ{1'b0}};

end // always_comb pm_deassert_intx_p

//-------------------------------------------------------------------------
// Function Disabled
//-------------------------------------------------------------------------

// Detect when power state is changed in the PCIe CFG reg
// Writing PS to 0 puts us into the D0 power state
// Writing PS to 3 puts us into the D3 power state
// Writing to any other value (1/2) does not change the current power state
// Need to detect when in the D3 state so we can drop MMIO transactions in CDS

logic   [1:0]   csr_pf0_ppmcsr_ps_c_q;
logic           csr_pf0_ps_d3_next;
logic           csr_pf0_ps_d3_q;

always_comb begin: ri_pf_disabled_p

    csr_pf0_ps_d3_next = csr_pf0_ps_d3_q;

    if (csr_pf0_ppmcsr_ps_c != csr_pf0_ppmcsr_ps_c_q) begin
        if ( (&csr_pf0_ppmcsr_ps_c)) csr_pf0_ps_d3_next = '1;
        if (~(|csr_pf0_ppmcsr_ps_c)) csr_pf0_ps_d3_next = '0;
    end

    ri_pf_disabled_wxp = csr_pf0_ps_d3_q;

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
    if (~prim_gated_rst_b) begin
        csr_pf0_ppmcsr_ps_c_q <= '0;
        csr_pf0_ps_d3_q       <= '0;
    end else begin
        csr_pf0_ppmcsr_ps_c_q <= csr_pf0_ppmcsr_ps_c;
        csr_pf0_ps_d3_q       <= csr_pf0_ps_d3_next;
    end
end

////////////////////////////////////////////////////////////////////////////
// DCN 90006 - FLR to be tied to secondary bus reset
////////////////////////////////////////////////////////////////////////////

// send PF0 reset to ep_cluster top to be OR'ed in and sent to CAS to reset all units as secondary bus reset

assign flr_triggered_wp = pm_pf_rst_wxp;

// Detect a completion getting granted, then check if its the cmpl for the FLR or PS write
// flopping everything to avoid timing paths

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: flr_reqid_tag_p
    if (~prim_gated_rst_b) begin
        gnt_f               <= '0;
        gnt_f2              <= '0;
        gnt_rtype_f         <= '0;
        gnt_rtype_f2        <= '0;
        mtag_f              <= '0;
        mrqid_f             <= '0;
    end else begin
        gnt_f               <= gnt;
        gnt_f2              <= gnt_f;
        gnt_rtype_f         <= gnt_rtype;
        gnt_rtype_f2        <= gnt_rtype_f;
        mtag_f              <= {mrsvd1_7, mrsvd1_3, mtag};
        mrqid_f             <= mrqid;
    end

end // always_ff flr_reqid_tag_p

// Save CDS signals until they match with the outbound transactions
// flr_txn_sent_q will continue to keep the detection armed until the CPL is seen
//  ps_txn_sent_q will continue to keep the detection armed until the CPL is seen

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: flr_sent_p
    if (~prim_gated_rst_b) begin

        flr_txn_sent_q  <= '0;
        flr_txn_tag_q   <= '0;
        flr_txn_reqid_q <= '0;
         ps_txn_sent_q  <= '0;
         ps_txn_tag_q   <= '0;
         ps_txn_reqid_q <= '0;

    end else begin

        // These set and remain set until the completion is detected on the bus

        flr_txn_sent_q  <= (flr_txn_sent | flr_txn_sent_q) & ~flr_cpl_sent_q;
         ps_txn_sent_q  <= ( ps_txn_sent |  ps_txn_sent_q) &  ~ps_cpl_sent_next;

       // Capture these only on the txn_sent pulse to save for compare with the bus

        if (flr_txn_sent & ~flr_txn_sent_q) begin
            flr_txn_tag_q   <= flr_txn_tag;
            flr_txn_reqid_q <= flr_txn_reqid;
        end

        if ( ps_txn_sent &  ~ps_txn_sent_q) begin
             ps_txn_tag_q   <=  ps_txn_tag;
             ps_txn_reqid_q <=  ps_txn_reqid;
        end

    end
end // always flr_sent_p

// Check to see if the transaction that just got sent was the FLR or PS completion

assign flr_cpl_sent_next = flr_txn_sent_q & gnt_f2         &
                           (gnt_rtype_f2 == 2'b10)         &
                           (mtag_f       == flr_txn_tag_q) &
                           (mrqid_f      == flr_txn_reqid_q);

assign  ps_cpl_sent_next =  ps_txn_sent_q & gnt_f2         &
                           (gnt_rtype_f2 == 2'b10)         &
                           (mtag_f       ==  ps_txn_tag_q) &
                           (mrqid_f      ==  ps_txn_reqid_q);

// Save that we sent the FLR or PS completion
// The  ps_cpl_sent will remain set until we have done the power state transition

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: cpl_sent_l_f_p
    if (~prim_gated_rst_b) begin
        flr_cpl_sent_q <= '0;
         ps_cpl_sent_q <= '0;
    end else begin
        flr_cpl_sent_q <= flr_cpl_sent_next;
        if ( ps_cpl_sent_next) begin
             ps_cpl_sent_q <= '1;
        end else begin
             ps_cpl_sent_q <= ps_cpl_sent_q & ~ps_cpl_sent_ack;
        end
    end
end

assign ps_cpl_sent = ps_cpl_sent_q;

always_ff @(posedge prim_freerun_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  flr_triggered_wl <= '1;
 end else begin
  flr_triggered_wl <= {7{flr_triggered_wp}};
 end
end

assign flr_visa = {  bme_or_mem_wr          // 9
                    ,ps_txn_sent_q          // 8
                    ,ps_cpl_sent_q          // 7
                    ,ps_cpl_sent_ack        // 6
                    ,flr_txn_sent_q         // 5
                    ,flr_cpl_sent_q         // 4
                    ,flr                    // 3
                    ,pm_fsm_rst             // 2
                    ,pf0_pm_state[1:0]      // 1:0
};

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Assertions
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

//-------------------------------------------------------------------------
// PROTO & COVERAGE
//-------------------------------------------------------------------------
//  - Verify each physical function executes a BME when in D0 uninit;
//    ri.ri_pm.ri_bme_rxl & ri.ri_pm.pf*_pm_state=DOUNINT
//  - Verify each physical function executs a memory write when in D0 uninit;
//    ri.csr_req_wr & ri.ri_pm.pf*_pm_state=D0UNINIT
//  - Verify that an FLR is executed in each of the PM states for each
//    function; ri.ri_flr_rxp, ri_ri_pm.pf*_pm_state={DOUNINT, D3HOT, D0ACT}.
//  - CSR write in D0 UNINIT; ri.ri_pm.pf*_pm_state=D0UNINIT,
//    ri.ri_csr_ctl.csr_req_wr.
//  - Verify that the following power management state sequences are hit;
//    D0UNINT -> D0ACT -> D3HOT -> D0ACT
//    D0UNINT -> D0ACT -> D3HOT -> D0UNINIT
//    D0UNINT -> D0ACT -> D0UNINIT

endmodule // hqm_ri_pm

// $Log: hqm_ri_pm.sv,v $
// Revision 1.5  2012/10/23 13:04:50  hmccarth
// replaced DV_OFF with RI_DV_OFF
//
// Revision 1.4  2012/04/11 13:30:25  jkearney
// Removed unused ports
//
// Revision 1.3  2011/12/22 10:18:00  jkearney
// 2nd Master branch merge including gbe_cluster, ri, castcluster port duplication renaming
//
// Revision 1.2  2011/12/14 10:09:26  jkearney
// RTL merge MASTER_PRE_TRUNK_MERGE_DEC8_2011
//
// Revision 1.1.1.1.2.1  2011/11/23 16:52:24  jkearney
// removed physical functions, added virtual functions
//
// Revision 1.1.1.1  2011/09/28 09:03:04  acunning
// import tree
//
// Revision 1.40  2011/05/19 09:35:19  dgfeekes
// Fixed the D3 to D0 power management state machine lock issue.
//
// Revision 1.39  2011/05/12 07:15:34  dgfeekes
// Removed the link up from setting the functions into D3 cold.
//
// Revision 1.38  2011/05/05 09:58:59  hmccarth
// checkin of fix for ticket 3542241 and 3542237
//
// Revision 1.37  2011/04/08 09:41:53  dgfeekes
// Hooked up the VF FLR logic.
//
// Revision 1.36  2011/02/14 15:23:50  dgfeekes
// Removed the fuse disable from function 0 so that function 0 cannot be disabled
// via fuses for the purpose of power management.
//
// Revision 1.35  2011/02/02 11:53:19  dgfeekes
// Fixed some misc. lint errors.
//
// Revision 1.34  2011/02/01 16:32:19  dgfeekes
// Changed ri_pf_disable so that function 0 would also be disabled on FLR (fix
// for HSD 3541824).
//
// Revision 1.33  2011/01/20 11:23:46  hmccarth
// added extra stage of flops to csr write
//
// Revision 1.32  2011/01/19 13:19:34  hmccarth
// added fix for 3541748
//
// Revision 1.31  2011/01/12 13:44:52  hmccarth
// made a fix around d3 hot exit
//
// Revision 1.30  2011/01/05 08:43:07  dgfeekes
// Added legacy interrupt desassert on reset logic.
//
// Revision 1.29  2011/01/04 13:05:58  hmccarth
// modified csr_wr_detect, fix for ticket 3541539
//
// Revision 1.28  2010/09/15 11:46:54  dgfeekes
// Made fix for CSR write detect so that a write to any function will generate an update.
//
// Revision 1.27  2010/05/13 13:16:05  dgfeekes
// Added the fuse info to the power state so that functions which are fused out
// are considered powered down.
//
// Revision 1.26  2010/04/09 10:12:40  dgfeekes
// Fixed latch error with start flr signal.
//
// Revision 1.25  2010/04/05 22:54:50  dgfeekes
// Changed the GIGE PM ack to a pulse signal
//
// Revision 1.24  2010/03/31 07:04:29  dgfeekes
// Fixed the reset counter
//
// Revision 1.23  2010/03/11 16:29:45  dgfeekes
// Added clock to the DFX reset mux inst.
//
