// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_iosf_sb
// -- Author : Justin Diether 
// -- Project Name : Cave Creek
// -- Creation Date: Oct 2, 2008
// -- Description :
//---------------------------------------------------------------------

//----------------------------------------------------------------------
// Date Created : 02/12/2013
// Author       : aamehta1
// Project      : Bell Creek/CPM 1.7
//----------------------------------------------------------------------
//  Description: 
//  This fub handles the interface with the IOSF sideband bus.
//  It will handle incoming fuse transactions, setID operations,
//  and all incoming messages.
// 
//----------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_ri_iosf_sb

     import hqm_AW_pkg::*, hqm_sif_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_system_type_pkg::*, hqm_system_func_pkg::*, hqm_sif_csr_pkg::*;
(
    //-----------------------------------------------------------------
    // Clock, Reset, Global Constant, Global Fuses
    //-----------------------------------------------------------------

     input  logic                       side_gated_clk
    ,input  logic                       side_gated_rst_b

    ,output logic                       side_clkreq_async

    ,input  logic                       prim_freerun_clk
    ,input  logic                       prim_gated_clk
    ,input  logic                       prim_gated_rst_b                // Active low reset from the SHAC based on prim_clk.
                                                                        //  It is asynchronously asserted and synchronously 
                                                                        //  deasserted with prim_clk. This is used very sparingly
                                                                        //  in this block. However most of RI is on this reset.
    ,input  logic                       side_gated_rst_prim_b           // Active low reset based on side_rst_b. It is
                                                                        //  asynchronously asserted and synchronously 
                                                                        //  deasserted with prim_clk. This is the reset used 
                                                                        //  by the majority if the side band logic.      
    ,input  logic                       hard_rst_np 
    ,input  logic [15:0]                strap_hqm_err_sb_dstid          // Sideband destination port ID for PCIe errors
    ,input  logic [SAI_WIDTH:0]         strap_hqm_err_sb_sai            // SAI sent with PCIe error messages

    // SAI sent with ResetPrepAck messages

    ,input  logic [SAI_WIDTH:0]         strap_hqm_resetprep_ack_sai

    //-----------------------------------------------------------------
    // SB to EP Interface (Signals in side_clk domain)
    //-----------------------------------------------------------------
    // Message info sent to EP                

    ,input  hqm_sb_ep_msg_t             sb_ep_msg                       
                                                                        //  Fields of this structure are not consumed. Its an inherent 
                                                                        //  disavantage of structures, still you dont make a new       
                                                                        //  structure just for this case. Its not functional problem.  
    ,output logic                       ep_sb_msg_trdy                  // Tready for sb_sp_msg

    //-----------------------------------------------------------------
    // EP to SB Message Interface (Signals in side_clk domain)
    //-----------------------------------------------------------------

    ,output hqm_ep_sb_msg_t             ep_sb_msg                       // Posted/Non Posted Message to Side Band

    ,input  logic                       sb_ep_msg_trdy                  // This is the trdy back for the ep_sb_msg.irdy

    ,output hqm_cds_sb_tgt_cmsg_t       ep_sb_cmsg                      // Completion message back to the sb_tgt in the shim 

    //-----------------------------------------------------------------
    // SB to EP Incoming - CSR Access Interface - handled by hqm_ri_cds
    //-----------------------------------------------------------------
    // To ri_iosf_sb block for sideband unsupported requests

    ,output hqm_sb_ri_cds_msg_t         sb_cds_msg                      // Tweaked version of sb_ep_msg for hqm_ri_cds.

    ,input  logic                       cds_sb_wrack                    // from CDS - ack an incoming write request that has been sent
    ,input  logic                       cds_sb_rdack                    // from CDS - ack an incoming read request that has been sent
    ,input  hqm_cds_sb_tgt_cmsg_t       cds_sb_cmsg                     // Completion message back to the sb_tgt in the shim 

    //-----------------------------------------------------------------
    // Error Interface 
    //-----------------------------------------------------------------
    // ERR -> IOSFSB - Error Message info

    ,input  logic                       err_gen_msg                     // Generate error message to host
    ,input  logic [7:0]                 err_gen_msg_data                
                                                                        //  Curently onlys bits 7:0 are used. 31:8 are not used.
                                                                        //  that could change leaving it based on struct csr_data_t 
                                                                        // Error message data
    ,input  logic [15:0]                err_gen_msg_func                // HSD 5313841 - Error function should be included in error message 
    ,output logic                       err_sb_msgack                                      

    //-----------------------------------------------------------------
    // PGCB Interface 
    //-----------------------------------------------------------------

    ,output logic                       force_warm_reset                                   
    ,output logic                       force_ip_inaccessible                                       
    ,output logic                       force_pm_state_d3hot

    //-----------------------------------------------------------------
    // ADR interface
    //-----------------------------------------------------------------

    ,input  logic                       pm_hqm_adr_assert
    ,output logic                       hqm_pm_adr_ack

    //-----------------------------------------------------------------
    // Reset Prep Handling Interface
    //-----------------------------------------------------------------

    ,output logic                       sif_mstr_quiesce_req            // Tell Primary Channel to block Mastered logic
    ,output logic                       sif_gpsb_quiesce_req            // Tell Sideband to UR NPs and Drop Ps on its target
    ,output logic                       quiesce_qualifier

    ,input  logic                       sif_mstr_quiesce_ack            // Tell RI_IOSF_SB that the IOSF MSTR is empty.
    ,input  logic                       sif_gpsb_quiesce_ack            // Tell RI_IOSF_SB that the SB TGT is URing/Dropping NP/P
                                       
    ,output logic                       ri_iosf_sb_idle                 // Needs to go to the idle logic
    ,output logic                       adr_clkreq                      // Needs to go to the clkreq logic
    ,output logic                       rpa_clkreq                      // Needs to go to the clkreq logic

    ,input  logic                       strap_no_mgmt_acks 
    ,output logic                       reset_prep_ack                  // reset prep acknowledge
);

//-------------------------------------------------------------------------
// Local Support Signals
//-------------------------------------------------------------------------

// Device, Functions, BAR and edge detect

logic                                 iosfsb_vld_devn                                   ; // device and function number of incoming SB txn are correct
logic                                 val_ep_bar                                        ; // BAR of incoming SB txn is correct
logic                                 sb_ep_msg_prim_irdy_redge                         ; // edge detect of incoming avail signal
logic                                 sb_ep_msg_prim_irdy_ff                            ; // flop incoming avail signal
logic                                 sb_cfg_rd                                         ; // decode incoming sideband request
logic                                 sb_cfg_wr                                         ; // decode incoming sideband request
logic                                 sb_mem_rd                                         ; // decode incoming sideband request
logic                                 sb_mem_wr                                         ; // decode incoming sideband request

// Error and Interrupt logic

logic [31:0]                          err_sb_msgdata                                    ; 
logic                                 err_sb_msgavail                                   ; 
logic [7:0]                           err_sb_msgop                                      ; 
logic                                 bad_sb_mmiord_acc                                 ; 
logic                                 bad_sb_mmiowr_acc                                 ; 

// Arbitration Support signals to select which message proceeds to SB

logic                                 err_sb_msg_req                                    ; 

// PMC Reset PREP/ACK Signals

logic                                 pmc2ep_rsprep                                     ; 
logic                                 pmc2ep_rsprep_nxt                                 ; 
logic                                 pmc2ep_rsprep_r1                                  ; 
logic [31:0]                          pmc2ep_rsprep_data                                ; 
logic [31:0]                          pmc2ep_rsprep_data_nxt                            ; 
logic [15:0]                          pmc2ep_rsprep_src                                 ; 
logic [15:0]                          pmc2ep_rsprep_src_nxt                             ; 

// PMC FORCEPWRGATEPOK Signals

logic                                 force_warm_reset_nxt                              ;
logic                                 force_ip_inaccessible_nxt                         ;          

// Various State Done Signals

logic                                 ep_sb_wrack                                       ; 
logic                                 ep_sb_rdack                                       ;
logic                                 ep_sb_msgack                                      ; // acks ingress msg
logic                                 ep_sb_msgack_nxt                                  ; // acks ingress msg
logic                                 ep_sb_ursp_temp                                   ;
logic                                 ep_sb_local_cfg_cpl_vld                           ;
logic                                 ep_sb_local_mmio_cpl_vld                          ;
logic                                 ep_sb_during_prim_rst                             ;

// State assignments, these are the 1 HOT locations

localparam MN_IDLE_S                  =  0                                              ;
localparam MN_MSG_ERR_S               =  1                                              ;
localparam MN_MSG_RSPREPACK_S         =  2                                              ;

// State declarations for EP to SB Message Generation

typedef enum logic [2:0] {
  MN_IDLE                             = (3'b1 << MN_IDLE_S                            ),
  // Specific Message States                                                 
  MN_MSG_ERR                          = (3'b1 << MN_MSG_ERR_S                         ),
  MN_MSG_RSPREPACK                    = (3'b1 << MN_MSG_RSPREPACK_S                   )
} hqm_sb_main_fsm_t                                                                     ;

hqm_sb_main_fsm_t                     main_fsm_ps                                       ; 
hqm_sb_main_fsm_t                     main_fsm_ns                                       ; 

// Used to handle the outgoing multi dword writes

logic [4:0]                           cnt_nxt                                           ;
logic [4:0]                           cnt                                               ;

// State assignments, these are the 1 HOT location

localparam SUB_IDLE_S                 = 0                                               ;
localparam SUB_UPDATE_S               = 1                                               ;
localparam SUB_WAIT_S                 = 2                                               ;
localparam SUB_EOM_S                  = 3                                               ; 

// Substate declarations used to sequence inside the main state.

typedef enum logic [3:0] {
  // Convert to one hot
  SUB_IDLE                            = (4'b1 << SUB_IDLE_S                            ),
  // Generic Substates                       
  SUB_UPDATE                          = (4'b1 << SUB_UPDATE_S                          ),
  SUB_WAIT                            = (4'b1 << SUB_WAIT_S                            ),
  SUB_EOM                             = (4'b1 << SUB_EOM_S                             )
  } hqm_sub_fsm_t                                                                       ;

// In order to use these effectively the actual state sampled is the next state
// when checking waveforms pull up the main_fsm_ps and place it side by side with 
// the sub_fsm_ns

hqm_sub_fsm_t                         sub_fsm_ps                                        ; 
hqm_sub_fsm_t                         sub_fsm_ns                                        ;

// State assignments, these are the 1 HOT location

localparam IDLE_RST_STATE_S           = 0                                               ;
localparam RSPREP_DETECTED_STATE_S    = 1                                               ;
localparam RESET_STARTED_STATE_S      = 2                                               ;
localparam RESET_ENDED_STATE_S        = 3                                               ;

// Resetprep Quiesce Logic - "Out of CPP Warm Reset FSM"

typedef enum logic [3:0] {
  // Convert to one hot
  IDLE_RST_STATE                      = (4'b1 << IDLE_RST_STATE_S                      ),
  RSPREP_DETECTED_STATE               = (4'b1 << RSPREP_DETECTED_STATE_S               ),
  RESET_STARTED_STATE                 = (4'b1 << RESET_STARTED_STATE_S                 ),
  RESET_ENDED_STATE                   = (4'b1 << RESET_ENDED_STATE_S                   )
  } hqm_out_of_cpp_rst_fsm_t                                                           ;

hqm_out_of_cpp_rst_fsm_t              out_of_cpp_rs_fsm_ns                             ; 
hqm_out_of_cpp_rst_fsm_t              out_of_cpp_rs_fsm_ps                             ;

// Support logic for the Reset Quiesce Logic 

logic                                 quiesce_pc                                       ; // Tell Primary Channel to block Mastered logic
logic                                 quiesce_pc_sync                                  ;
logic [3:0]                           quiesce_pc_cnt                                   ;
logic                                 quiesce_sb                                       ; // Tell Sideband to UR/drop NP/P on its target.
logic                                 quiesce_pc_nxt                                   ;
logic                                 quiesce_sb_nxt                                   ;
logic                                 out_of_cpp_rst                                   ;
logic                                 send_rsprepack                                   ;
logic                                 send_rsprepack_nxt                               ;
logic                                 disable_sb_mst                                   ;
logic                                 disable_sb_mst_nxt                               ;
logic                                 sif_gpsb_quiesce_ack_sync                        ;

// prim_clk domain versions of side_clk domain signals

hqm_sb_ep_msg_t                       sb_ep_msg_prim                                   ;
logic                                 ep_sb_msg_prim_trdy                              ;

hqm_ep_sb_msg_t                       ep_sb_msg_prim_pnc                               ; 
logic                                 sb_ep_msg_prim_trdy                              ;

hqm_cds_sb_tgt_cmsg_t                 ep_sb_cmsg_prim                                  ;
logic                                 ep_sb_cmsg_prim_valid                            ;
logic                                 ep_sb_cmsg_prim_valid_q                          ;
logic                                 sb_ep_cmsg_prim_trdy                             ;

// Handle clock crossing side_clk domain -> prim_clk domain for sb_ep_msg input

hqm_iosf_handshake #(.WIDTH($bits(sb_ep_msg)-33)) i_sb_ep_msg_hs (

     .clk_src       (side_gated_clk)
    ,.rst_src_n     (side_gated_rst_b)

    ,.val_src       ( sb_ep_msg.irdy)
    ,.dat_src       ({sb_ep_msg.op
                     ,sb_ep_msg.src
                     ,sb_ep_msg.addr
                     ,sb_ep_msg.data
                     ,sb_ep_msg.fbe
                     ,sb_ep_msg.sbe
                     ,sb_ep_msg.bar
                     ,sb_ep_msg.fid
                     ,sb_ep_msg.np
                     ,sb_ep_msg.sai
                    })

    ,.rdy_src       ( ep_sb_msg_trdy)

    ,.clk_dst       (prim_gated_clk)
    ,.rst_dst_n     (side_gated_rst_prim_b)

    ,.val_dst       ( sb_ep_msg_prim.irdy)
    ,.dat_dst       ({sb_ep_msg_prim.op
                     ,sb_ep_msg_prim.src
                     ,sb_ep_msg_prim.addr
                     ,sb_ep_msg_prim.data
                     ,sb_ep_msg_prim.fbe
                     ,sb_ep_msg_prim.sbe
                     ,sb_ep_msg_prim.bar
                     ,sb_ep_msg_prim.fid
                     ,sb_ep_msg_prim.np
                     ,sb_ep_msg_prim.sai
                    })

    ,.rdy_dst       ( ep_sb_msg_prim_trdy)
);

assign sb_ep_msg_prim.sdata = '0;

// Handle clock crossing prim_clk domain -> side_clk domain for ep_sb_msg output

hqm_iosf_handshake #(.WIDTH($bits(ep_sb_msg)-64)) i_ep_sb_msg_hs (

     .clk_src       (prim_gated_clk)
    ,.rst_src_n     (side_gated_rst_prim_b)

    ,.val_src       ( ep_sb_msg_prim_pnc.irdy)
    ,.dat_src       ({ep_sb_msg_prim_pnc.op
                     ,ep_sb_msg_prim_pnc.dest
                     ,ep_sb_msg_prim_pnc.eh
                     ,ep_sb_msg_prim_pnc.sai
                     ,ep_sb_msg_prim_pnc.fid
                     ,ep_sb_msg_prim_pnc.len
                     ,ep_sb_msg_prim_pnc.dcnt
                     ,ep_sb_msg_prim_pnc.data
                     ,ep_sb_msg_prim_pnc.np
                    })

    ,.rdy_src       ( sb_ep_msg_prim_trdy)

    ,.clk_dst       (side_gated_clk)
    ,.rst_dst_n     (side_gated_rst_b)

    ,.val_dst       ( ep_sb_msg.irdy)
    ,.dat_dst       ({ep_sb_msg.op
                     ,ep_sb_msg.dest
                     ,ep_sb_msg.eh
                     ,ep_sb_msg.sai
                     ,ep_sb_msg.fid
                     ,ep_sb_msg.len
                     ,ep_sb_msg.dcnt
                     ,ep_sb_msg.data
                     ,ep_sb_msg.np
                    })

    ,.rdy_dst       ( sb_ep_msg_trdy)
);

assign ep_sb_msg.tag  ='0;
assign ep_sb_msg.addr ='0;
assign ep_sb_msg.alen ='0;
assign ep_sb_msg.bar  ='0;
assign ep_sb_msg.be   ='0;
assign ep_sb_msg.sbe  ='0;

// Handle clock crossing prim_clk domain -> side_clk domain for ep_sb_cmsg output

hqm_cds_sb_tgt_cmsg_t                 ep_sb_cmsg_int                                   ;
logic                                 ep_sb_cmsg_valid                                 ;

always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin
 if (~side_gated_rst_prim_b) begin
  ep_sb_cmsg_prim_valid_q <= '0;
 end else begin
  ep_sb_cmsg_prim_valid_q <= ep_sb_cmsg_prim_valid & ~sb_ep_cmsg_prim_trdy;
 end
end

assign ep_sb_cmsg_prim_valid = ep_sb_cmsg_prim.vld | ep_sb_cmsg_prim.dvld |
                               ep_sb_cmsg_prim_valid_q;

hqm_iosf_handshake #(.WIDTH($bits(ep_sb_cmsg)), .GATE_DOUT(0)) i_ep_sb_cmsg_hs (

     .clk_src       (prim_gated_clk)
    ,.rst_src_n     (side_gated_rst_prim_b)

    ,.val_src       (ep_sb_cmsg_prim_valid)
    ,.dat_src       (ep_sb_cmsg_prim)

    ,.rdy_src       (sb_ep_cmsg_prim_trdy)

    ,.clk_dst       (side_gated_clk)
    ,.rst_dst_n     (side_gated_rst_b)

    ,.val_dst       (ep_sb_cmsg_valid)
    ,.dat_dst       (ep_sb_cmsg_int)

    ,.rdy_dst       (ep_sb_cmsg_valid)
);

// The response to a non-posted request (ep_sb_msg_prim_trdy) and the completion associated with it
// (ep_sb_cmsg_prim) can occur at the same time.  Due to the clock crossing uncertainty, they can
// appear out of order with respect to each other.  The EP logic does not expect to get the completion
// before the response to the request, so we need to account for this and ensure the EP logic doesn't
// see them out of order.

logic                                 allow_ep_sb_cmsg                                 ;
logic                                 ep_sb_cmsg_vld                                   ;
logic                                 ep_sb_cmsg_dvld                                  ;

always_ff @(posedge side_gated_clk or negedge side_gated_rst_b) begin
 if (~side_gated_rst_b) begin
  allow_ep_sb_cmsg <= '0;
  ep_sb_cmsg_vld   <= '0;
  ep_sb_cmsg_dvld  <= '0;
 end else begin

  // Set this on trdy acceptance of sb_ep_msg for NP request and hold until the completion is sent out.

  allow_ep_sb_cmsg <= (sb_ep_msg.irdy & sb_ep_msg.np & ep_sb_msg_trdy) |
                      (allow_ep_sb_cmsg & ~(ep_sb_cmsg.vld | ep_sb_cmsg.dvld));

  // Save these on the completion valid pulse and hold until the completion is sent out.

  ep_sb_cmsg_vld   <= (ep_sb_cmsg_valid &  ep_sb_cmsg_int.vld) |
                      (ep_sb_cmsg_vld   & ~ep_sb_cmsg.vld);

  ep_sb_cmsg_dvld  <= (ep_sb_cmsg_valid &  ep_sb_cmsg_int.dvld) |
                      (ep_sb_cmsg_dvld  & ~ep_sb_cmsg.dvld);
 end
end

always_comb begin

 // Default is to not set the vld or dvld

 ep_sb_cmsg      = ep_sb_cmsg_int;
 ep_sb_cmsg.vld  = '0;
 ep_sb_cmsg.dvld = '0;

 // Only send the completion (set vld and/or dvld) after trdy response

 if (allow_ep_sb_cmsg) begin
  ep_sb_cmsg.vld  = ep_sb_cmsg_vld;
  ep_sb_cmsg.dvld = ep_sb_cmsg_dvld;
 end

end

// Need to request the side_clk if we have a prim_clk request destined for the SBEP

always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin
 if (~side_gated_rst_prim_b) begin
  side_clkreq_async <= '0;
 end else begin
  side_clkreq_async <= ep_sb_msg_prim_pnc.irdy | ep_sb_cmsg_prim_valid;
 end
end

// Other request generation INTA/ERR

assign err_sb_msg_req                 = err_sb_msgavail                                                ; 

// Detect and incoming ResetPrep from SB need to ResetPrepAck

always_comb begin: ep_rsprep_comb_p 

    pmc2ep_rsprep_nxt                 = pmc2ep_rsprep                                                  ;
    pmc2ep_rsprep_data_nxt            = pmc2ep_rsprep_data                                             ;
    pmc2ep_rsprep_src_nxt             = pmc2ep_rsprep_src                                              ;

    if (main_fsm_ps[MN_MSG_RSPREPACK_S] & (sub_fsm_ns[SUB_IDLE_S] | sub_fsm_ns[SUB_EOM_S])) begin
        pmc2ep_rsprep_nxt             = '0                                                             ;
        pmc2ep_rsprep_data_nxt        = '0                                                             ;
        pmc2ep_rsprep_src_nxt         = '0                                                             ;
    end

    // Only respond if there was not a previous rsprepack 
    // that is still being cleared out of the flops in the tgt (pmc2ep_rsprep_r1)

    else if ((sb_ep_msg_prim.irdy & (sb_ep_msg_prim.op == HQMEPSB_RSPREP)) & ~pmc2ep_rsprep_r1) begin
        pmc2ep_rsprep_nxt             = '1                                                             ;
        pmc2ep_rsprep_data_nxt        = sb_ep_msg_prim.data                                            ;
        pmc2ep_rsprep_src_nxt         = sb_ep_msg_prim.src                                             ;
    end

end

// ADR 4-phase handshake
// When pm_hqm_adr_assert is asserted from the PMA, set the quiesce signals.  On the rising edge move to the
// RSPREP_DETECTED_STATE state to wait for all the quiesce votes to assert.  Once they are all asserted, set
// the hqm_pm_adr_ack indication back to the PMA and keep it asserted until pm_hqm_adr_assert deasserts.
//
logic   pm_hqm_adr_assert_sync;
logic   pm_hqm_adr_assert_q;
logic   pm_hqm_adr_assert_redge;
logic   adr_quiesce_req;
logic   send_adr_ack_nxt;
logic   hqm_pm_adr_ack_q;

hqm_AW_sync_rst0 i_pm_hqm_adr_assert_sync (

     .clk           (prim_freerun_clk)
    ,.rst_n         (side_gated_rst_prim_b)
    ,.data          (pm_hqm_adr_assert)
    ,.data_sync     (pm_hqm_adr_assert_sync)
);

always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin
 if (~side_gated_rst_prim_b) begin
  hqm_pm_adr_ack_q    <= '0;
  pm_hqm_adr_assert_q <= '0;
 end else begin
  hqm_pm_adr_ack_q    <= (send_adr_ack_nxt | hqm_pm_adr_ack_q) & pm_hqm_adr_assert_sync;
  pm_hqm_adr_assert_q <= pm_hqm_adr_assert_sync;
 end
end

assign adr_quiesce_req         = pm_hqm_adr_assert_sync & ~hqm_pm_adr_ack_q;
assign pm_hqm_adr_assert_redge = pm_hqm_adr_assert_sync & ~pm_hqm_adr_assert_q;
assign hqm_pm_adr_ack          = hqm_pm_adr_ack_q;

always_comb begin: ep_set_quiesce_logic_p 

    quiesce_pc_nxt                    =  quiesce_pc                                                    ;
    quiesce_sb_nxt                    =  quiesce_sb                                                    ;  
    disable_sb_mst_nxt                =  disable_sb_mst                                                ;
    
    if (adr_quiesce_req) begin

        quiesce_pc_nxt                =  '1                                                            ;
        quiesce_sb_nxt                =  '1                                                            ;  
        disable_sb_mst_nxt            =  main_fsm_ns[MN_IDLE_S]                                        ;

    end

    else if (out_of_cpp_rs_fsm_ns == RSPREP_DETECTED_STATE) begin

        quiesce_pc_nxt                =  '1                                                            ;
        quiesce_sb_nxt                =  '1                                                            ;  

        // Once we see the move to MN_MSG_RSPREPACK disable the master otherwise hold its value

        if (main_fsm_ps[MN_MSG_RSPREPACK_S] & (sub_fsm_ns[SUB_EOM_S] | sub_fsm_ns[SUB_IDLE_S])) begin

          disable_sb_mst_nxt          =  '1                                                            ;

        end

    end else if (out_of_cpp_rs_fsm_ns == RESET_STARTED_STATE) begin                                      // Primary channel reset preventing
                                                                                                         // any upstream logic to be sent.
        quiesce_pc_nxt                =  '0                                                            ; // Prim channel in reset can clear now
        disable_sb_mst_nxt            =  '1                                                            ;
    end

    else if (out_of_cpp_rs_fsm_ns == RESET_ENDED_STATE) begin                                            // Coming alive again.

        quiesce_sb_nxt                =  '0                                                            ; // Can stop URing/Dropping on SB 
        disable_sb_mst_nxt            =  '0                                                            ; // Clear disable_sb_mst

    end
end

always_comb begin: ep_resetprep_reset_fsm_p 

    out_of_cpp_rs_fsm_ns              = out_of_cpp_rs_fsm_ps                                           ; 

    unique casez (1'b1)

      // This is when no resetprep is pending we are out of CPP reset and everything
      // is merrily moving along.

      out_of_cpp_rs_fsm_ps[IDLE_RST_STATE_S]: begin

          // Thing get interesting when a resetprep is detected and quiesce_pc goes high.

          if (pmc2ep_rsprep_nxt | pm_hqm_adr_assert_redge) begin
              out_of_cpp_rs_fsm_ns    = RSPREP_DETECTED_STATE                                          ; 
          end
      end

      out_of_cpp_rs_fsm_ps[RSPREP_DETECTED_STATE_S]: begin

          // The Plot Thickens when PMC asserts the prim_rst or SBR actually asserts
          // This will drive the signal ~out_of_cpp_re_set low. Meaning that the CPP reset 
          // prim_gated_rst_b is asserted, it also mean the prim_rst is being assertted.
          // Good thing this FSM is side_rst based, no?

          if (~out_of_cpp_rst) begin
              out_of_cpp_rs_fsm_ns    = RESET_STARTED_STATE                                            ;
          end
      end 

      out_of_cpp_rs_fsm_ps[RESET_STARTED_STATE_S]: begin

          // The Plot Climax is reached when CPP reset deasserts

          if (out_of_cpp_rst) begin
              out_of_cpp_rs_fsm_ns    = RESET_ENDED_STATE                                              ;
          end
      end

      out_of_cpp_rs_fsm_ps[RESET_ENDED_STATE_S]: begin

          // Its done, time to quite quiescing and get on with the Host Interface tasks.
          // Only 1 cycle is spent here mainly to clear the quiesce_pc signal.

          out_of_cpp_rs_fsm_ns        = IDLE_RST_STATE                                                 ;
      end

      default: begin

          // Something bad happened this should never be entered.

          out_of_cpp_rs_fsm_ns        = out_of_cpp_rs_fsm_ps                                           ; 
      end 

    endcase
end 

// Collect the votes from IOSF Primary and IOSF SB to allow a resetprepack 
// It only matters when we are quiescing.

always_comb begin: rsprepack_votes_pass_comb_p

    send_rsprepack_nxt                = '0                                                             ;
    send_adr_ack_nxt                  = '0                                                             ;

    if (out_of_cpp_rs_fsm_ns[RSPREP_DETECTED_STATE_S]) begin
      if (pm_hqm_adr_assert_sync) begin

        send_adr_ack_nxt              = sif_mstr_quiesce_ack           &                                 // IOSF Primary Master is empty
                                        sif_gpsb_quiesce_ack_sync      &                                 // IOSF Sideband Target is Uring/Dropping NP/P
                                        disable_sb_mst                                                 ;

      end else begin

        send_rsprepack_nxt            = sif_mstr_quiesce_ack           &                                 // IOSF Primary Master is empty
                                        sif_gpsb_quiesce_ack_sync                                      ; // IOSF Sideband Target is Uring/Dropping NP/P
      end
    end

end

// Detect an incoming FORCEPWRGATEPOK Msg with Type field (data[1:0]) from SB. Send single cycle pulse.

assign force_warm_reset_nxt           = sb_ep_msg_prim.irdy &
                                       (sb_ep_msg_prim.op        == HQMEPSB_FORCEPWRGATEPOK) &
                                       (sb_ep_msg_prim.data[1:0] == HQMEPSB_FORCEPWRGATE_01);

assign force_ip_inaccessible_nxt      = sb_ep_msg_prim.irdy &
                                       (sb_ep_msg_prim.op        == HQMEPSB_FORCEPWRGATEPOK) &
                                       (sb_ep_msg_prim.data[1:0] == HQMEPSB_FORCEPWRGATE_11);

always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin: ep_ingress_capture_p
    if (~side_gated_rst_prim_b) begin
        pmc2ep_rsprep                <= '0                                                             ;
        pmc2ep_rsprep_r1             <= '0                                                             ;
        pmc2ep_rsprep_data           <= '0                                                             ;
        pmc2ep_rsprep_src            <= '0                                                             ;

        force_warm_reset             <= '0                                                             ;
        force_ip_inaccessible        <= '0                                                             ;          

        quiesce_pc                   <= '0                                                             ;
        quiesce_sb                   <= '0                                                             ;
        disable_sb_mst               <= '0                                                             ;
        send_rsprepack               <= '0                                                             ;
    end else begin
        pmc2ep_rsprep                <= pmc2ep_rsprep_nxt                                              ;
        pmc2ep_rsprep_r1             <= pmc2ep_rsprep                                                  ;
        pmc2ep_rsprep_data           <= pmc2ep_rsprep_data_nxt                                         ;
        pmc2ep_rsprep_src            <= pmc2ep_rsprep_src_nxt                                          ;

        force_warm_reset             <= force_warm_reset_nxt                                           ;
        force_ip_inaccessible        <= force_ip_inaccessible_nxt                                      ;    

        quiesce_pc                   <= quiesce_pc_nxt                                                 ;
        quiesce_sb                   <= quiesce_sb_nxt                                                 ;
        disable_sb_mst               <= disable_sb_mst_nxt                                             ;
        send_rsprepack               <= send_rsprepack_nxt                                             ;
    end
end 

//----------------------------------------------------------------------------------------------------------------------------------
// Force pm_state logic
//
// Need to force pm_state output the master block to be D3Hot after receiving ForcePwrGatePok and keep it forced until the prim
// reset has completed, otherwise the pm_state output needs to be the internal pm_state_int value.
// force_warm_reset or force_ip_inaccessible are the indications that we received ForcePwrGatePok.
// Will force the pm_state output at the ri level.
//
// Normal Reset Cases
//                                   Warm/Cold Reset deassert  -> Run    -> FrcPwrGatePok -> Warm/Cold Reset assert -> Back to start
//                           ___     ___   ~   ___   ~   ___     ___   ~   ___     ___   ~   ___   ~   ___     ___   ~   ___
// prim_freerun_clk         |   |___|   |_ ~ _|   |_ ~ _|   |___|   |_ ~ _|   |___|   |_ ~ _|   |_ ~ _|   |___|   |_ ~ _|   |___|
//                                   _____ ~ _______ ~ _______________ ~ _______________ ~ _______ ~ _______________ ~ ___
// side_rst_prim_b          ________|      ~         ~                 ~                 ~         ~                 ~    |______
//                                         ~   _____ ~ _______________ ~ _______________ ~ ___     ~                 ~ 
// prim_gated_rst_b         ______________ ~ _|      ~                 ~                 ~    |___ ~ _______________ ~ __________
//                                         ~         ~   _____________ ~ _______________ ~ _______ ~ _               ~
// prim_gated_rst_b_sync    ______________ ~ _______ ~ _|              ~                 ~         ~  |_____________ ~ __________
//                                         ~         ~           _____ ~ _______________ ~ _______ ~ _________       ~
// prim_gated_rst_b_sync_q  ______________ ~ _______ ~ _________|      ~                 ~         ~          |_____ ~ __________
//                                         ~         ~                 ~   ______        ~         ~                 ~
// force_warm_or_ip_inacc   ______________ ~ _______ ~________________ ~ _|      |______ ~ _______ ~ _______________ ~ __________
//                          ______________ ~ _______ ~__________       ~          ______ ~ _______ ~ _______________ ~ __________
// force_pm_state_d3hot                    ~         ~          |_____ ~ ________|       ~         ~             
//
// pm_state                 Force D3Hot                         X pm_state_int   X Force D3Hot
//
//----------------------------------------------------------------------------------------------------------------------------------
// Dirty Reset Case
//                                   Warm/Cold Reset deassert  -> Run    -> Warm/Cold Reset assert -> Back to start
//                           ___     ___   ~   ___   ~   ___     ___   ~     ___   ~   ___     ___   ~   ___
// prim_freerun_clk         |   |___|   |_ ~ _|   |_ ~ _|   |___|   |_ ~ ___|   |_ ~ _|   |___|   |_ ~ _|   |___|
//                                   _____ ~ _______ ~ _______________ ~ _________ ~ _______________ ~ ___
// side_rst_prim_b          ________|      ~         ~                 ~           ~                 ~    |______
//                                         ~   _____ ~ _______________ ~ _____     ~                 ~ 
// prim_gated_rst_b         ______________ ~ _|      ~                 ~      |___ ~ _______________ ~ __________
//                                         ~         ~   _____________ ~ _________ ~ _               ~
// prim_gated_rst_b_sync    ______________ ~ _______ ~ _|              ~           ~  |_____________ ~ __________
//                                         ~         ~           _____ ~ _________ ~ _________       ~
// prim_gated_rst_b_sync_q  ______________ ~ _______ ~ _________|      ~           ~          |_____ ~ __________
//                                         ~         ~                 ~           ~                 ~
// force_warm_or_ip_inacc   ______________ ~ _______ ~________________ ~ _________ ~ _______________ ~ __________
//                          ______________ ~ _______ ~__________       ~       ___ ~ _______________ ~ __________
// force_pm_state_d3hot                    ~         ~          |_____ ~ _____|    ~             
//
// pm_state                 Force D3Hot                         X pm_state_intX Force D3Hot
//----------------------------------------------------------------------------------------------------------------------------------

logic prim_gated_rst_b_sync;
logic prim_gated_rst_b_sync_q;
logic force_pm_state_d3hot_nxt;

// prim_gated_rst_b synced as data because we need a rising edge on it to reset force_pm_state_d3hot once it's been set

hqm_AW_sync i_prim_gated_rst_b_sync (

     .clk           (prim_freerun_clk)
    ,.data          (prim_gated_rst_b)
    ,.data_sync     (prim_gated_rst_b_sync)
);

always_ff @(posedge prim_freerun_clk) begin
    prim_gated_rst_b_sync_q <= prim_gated_rst_b_sync;
end

always_comb begin

    // Default is to set on force_warm_reset or force_ip_inaccessible and remain set

    force_pm_state_d3hot_nxt = force_warm_reset | force_ip_inaccessible | force_pm_state_d3hot;

    // Reset only on rising edge of prim_rst_b

    if (force_pm_state_d3hot & prim_gated_rst_b_sync & ~prim_gated_rst_b_sync_q) begin

        force_pm_state_d3hot_nxt = '0;
    end

end

always_ff @(posedge prim_freerun_clk or negedge prim_gated_rst_b) begin
    if (~prim_gated_rst_b) begin
        force_pm_state_d3hot <= '1;
    end else begin
        force_pm_state_d3hot <= force_pm_state_d3hot_nxt;
    end
end

// This needs to use prim_gated_rst_b

hqm_AW_sync_rst0 i_out_of_cpp_rst (

     .clk           (prim_gated_clk)
    ,.rst_n         (side_gated_rst_prim_b)
    ,.data          (prim_gated_rst_b)
    ,.data_sync     (out_of_cpp_rst)
);

assign sif_mstr_quiesce_req           = quiesce_pc                                                     ;

// These are in the side_clk domain

hqm_AW_sync_rst0 i_sif_gpsb_quiesce_req_synchroniser (

     .clk           (side_gated_clk)
    ,.rst_n         (side_gated_rst_b)
    ,.data          (quiesce_sb)
    ,.data_sync     (sif_gpsb_quiesce_req)
);

hqm_AW_sync_rst0 i_sif_gpsb_quiesce_ack_synchroniser (

     .clk           (prim_gated_clk)
    ,.rst_n         (side_gated_rst_prim_b)
    ,.data          (sif_gpsb_quiesce_ack)
    ,.data_sync     (sif_gpsb_quiesce_ack_sync)
);

hqm_AW_sync_rst0 i_quiesce_pc_sync (

     .clk           (prim_freerun_clk)
    ,.rst_n         (hard_rst_np)
    ,.data          (quiesce_pc)
    ,.data_sync     (quiesce_pc_sync)
);

always_ff @(posedge prim_freerun_clk or negedge hard_rst_np) begin
    if (~hard_rst_np) begin
        quiesce_pc_cnt    <= '0;
        quiesce_qualifier <= '0;
    end else begin
        if (quiesce_pc_sync) begin
            quiesce_pc_cnt  <= '1;
        end else if (|quiesce_pc_cnt) begin
            quiesce_pc_cnt  <= quiesce_pc_cnt - 4'd1;
        end
        quiesce_qualifier <= (|quiesce_pc_cnt);
    end
end

// IOSF SB SPEC compliant Ordering. Posted can pass Non Posted.
// Stretch Goal: Two arbiters one for Posted one for Non Posted
// Interface needs to have seperate access to CPP CSRs and IA CSRs

//-------------------------------------------------------------------------
// Posted EP to SB Message State Machine 
//-------------------------------------------------------------------------

// Really we probably should have a Non Posted (NP) and Posted (P) state machine
// The SB collateral is setup to allow Posted to pass NP (see spec 1.1 sec 3.5 
// this is "required"). Posted/CMPL must be allowed to pass a Non Posted. 
// 
// In our case though these Posted are not completions so the potential deadlock
// sceneraio with keeping them ordered strictly should not arise. If the need
// arises the state machine can be broken into 2. It was designed with seperate
// states for Posted and non Posted.
//
// Thinking about it the strictly ordered (non IOSF compliant) versus SB ordering
// compliant can actually be controlled by the aribiter. If one aribter is used,
// the double state machines, np and p, become strictly ordered. If two aribters
// are used, one for p and one for np, then it becomes SB ordering compliant.
//
// The downstream logic ensures that np's dont pass p's.
//
// So proceeding with two state machines and both arbiter approaches. I will
// introduce a chicken bit to select which ordering is enabled. NOTE: 
// Decide to just implement the one state machine. Maybe at a later date I can
// do the addition described in this paragraph. It would not be that hard
// jbdiethe

// Lintra 50002 does not like the use of Xs. However since this is in code
//  that should never be reached AND since the Lintra SOC 1.4 Guidelines
//  explicitly show this as a preferable style, waiving that violation.

always_comb begin: main_fsm_next_state_logic

    ep_sb_msg_prim_pnc                = '0                                                             ; 
    ep_sb_msg_prim_pnc.fid            = '0                                                             ;
    cnt_nxt                           = '0                                                             ;

    main_fsm_ns                       = main_fsm_ps                                                    ; 

    unique casez (1'b1)        

      main_fsm_ps[MN_IDLE_S]: begin

          // The EP to SB interface can only actually accept a new message about
          // 1 every 16 pclk cycles. Hence making this super efficient is not needed. 
          // That is providing the MSG as soon as gnt goes high is not necessary. Nor is
          // the optimization to issue back-to-back messages. Therefore IDLE
          // state will always be entered as the reqing cycle to the arbiter.  

          // If a Reset is Pending disable the master.

          if     (disable_sb_mst)

            main_fsm_ns               = MN_IDLE                                                        ; 

          // High priority tasks first before the fairly arbitrated tasks

          else if (pmc2ep_rsprep & send_rsprepack)
            main_fsm_ns               = MN_MSG_RSPREPACK                                               ; 
          else begin
              if (err_sb_msg_req & ~adr_quiesce_req)
                main_fsm_ns           = MN_MSG_ERR                                                     ; 
              else
                main_fsm_ns           = main_fsm_ps                                                    ; 
          end
      end

      main_fsm_ps[MN_MSG_ERR_S]: begin

          // BEK Err Messages - goes to the VSP[0,1,2] ('h31 'h32 'h33) based on HQM inst.

          ep_sb_msg_prim_pnc.irdy     = err_sb_msgavail                                                ; 
          ep_sb_msg_prim_pnc.data     = err_sb_msgdata                                                 ; 
          ep_sb_msg_prim_pnc.op       = err_sb_msgop                                                   ; // Per IOSF Spec 1.0
          ep_sb_msg_prim_pnc.dest     = strap_hqm_err_sb_dstid                                         ;
          ep_sb_msg_prim_pnc.sai      = strap_hqm_err_sb_sai                                           ;
          ep_sb_msg_prim_pnc.eh       = '1                                                             ;
          ep_sb_msg_prim_pnc.np       = '0                                                             ;

          if (sub_fsm_ns[SUB_EOM_S]) begin
              main_fsm_ns             = MN_IDLE                                                        ;
          end
      end

      main_fsm_ps[MN_MSG_RSPREPACK_S]: begin

        if (pmc2ep_rsprep_data[16] | strap_no_mgmt_acks ) begin    // AckNotReqd

          // If ack not required, just go back to IDLE

          main_fsm_ns                 = MN_IDLE                                                        ;

        end else begin

          // BEK ResetPrepAck Message - goes to the PMC

          ep_sb_msg_prim_pnc.irdy     = 1'b1                                                           ; 
          ep_sb_msg_prim_pnc.op       = HQMEPSB_RSPREPACK                                              ; 
          ep_sb_msg_prim_pnc.data     = pmc2ep_rsprep_data                                             ; 
          ep_sb_msg_prim_pnc.dest     = pmc2ep_rsprep_src                                              ; 
          ep_sb_msg_prim_pnc.sai      = strap_hqm_resetprep_ack_sai                                    ; 
          ep_sb_msg_prim_pnc.eh       = '1                                                             ;
          ep_sb_msg_prim_pnc.np       = '0                                                             ;

          if (sub_fsm_ns[SUB_EOM_S])
            main_fsm_ns               = MN_IDLE                                                        ;
        end

      end 

      default: begin

          // Something bad happened this should never be entered.

          main_fsm_ns                 = main_fsm_ps                                                    ; 
      end 

    endcase

    // Need prim_gated_clk for sending ResetPrepAck

    rpa_clkreq = quiesce_pc & ~disable_sb_mst                                                          ;

end 

logic reset_prep_ack_wire_nxt ;
logic reset_prep_ack_wire_f ;
always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin: reset_prep_ack_logic
    if (side_gated_rst_prim_b == 1'b0) begin
        reset_prep_ack_wire_f  <= '0 ;
    end else begin
       reset_prep_ack_wire_f  <= reset_prep_ack_wire_nxt;
    end
end
hqm_AW_sync_rst0 i_reset_prep_ack_sync (
     .clk           ( side_gated_clk )
    ,.rst_n         ( side_gated_rst_b )
    ,.data          ( reset_prep_ack_wire_f )
    ,.data_sync     ( reset_prep_ack )
);

always_comb begin: substate_fsm_next_state_logic

    sub_fsm_ns                        = sub_fsm_ps                                                     ; 
    reset_prep_ack_wire_nxt = reset_prep_ack_wire_f ;

    unique casez (1'b1)

      sub_fsm_ps[SUB_IDLE_S]: begin
          reset_prep_ack_wire_nxt = reset_prep_ack_wire_f | (main_fsm_ps[MN_MSG_RSPREPACK_S] & ( strap_no_mgmt_acks | ~pmc2ep_rsprep_data[16] ) ) ;
          if ((main_fsm_ps[MN_MSG_RSPREPACK_S] & ~pmc2ep_rsprep_data[16] & ~ strap_no_mgmt_acks  ) | // ResetPrep & AckReqd
              main_fsm_ps[MN_MSG_ERR_S])
            sub_fsm_ns                = SUB_WAIT                                                       ;
      end

      sub_fsm_ps[SUB_WAIT_S]: begin
          if (sb_ep_msg_prim_trdy & ep_sb_msg_prim_pnc.irdy & (ep_sb_msg_prim_pnc.dcnt == ep_sb_msg_prim_pnc.len))
            sub_fsm_ns                = SUB_EOM                                                        ;
          else if (sb_ep_msg_prim_trdy & ep_sb_msg_prim_pnc.irdy) 
            sub_fsm_ns                = SUB_UPDATE                                                     ;
      end

      sub_fsm_ps[SUB_UPDATE_S]: begin
          sub_fsm_ns                  = SUB_WAIT                                                       ;
      end

      sub_fsm_ps[SUB_EOM_S]: begin
          sub_fsm_ns                  = SUB_IDLE                                                       ;
      end

      default: begin

          // Something bad happened this should never be entered.

          sub_fsm_ns                  = sub_fsm_ps                                                     ; 
      end 
    endcase
end 

always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin: fsms_state_flops_p
    if (side_gated_rst_prim_b == 1'b0) begin
        main_fsm_ps                <= MN_IDLE                                                          ; 
        sub_fsm_ps                 <= SUB_IDLE                                                         ;
        cnt                        <= '0                                                               ;
        out_of_cpp_rs_fsm_ps       <= IDLE_RST_STATE                                                   ;
    end else begin  
        main_fsm_ps                <= main_fsm_ns                                                      ; 
        sub_fsm_ps                 <= sub_fsm_ns                                                       ;
        cnt                        <= cnt_nxt                                                          ;
        out_of_cpp_rs_fsm_ps       <= out_of_cpp_rs_fsm_ns                                             ;
    end
end

//-------------------------------------------------------------------------
// IOSF SB access decode logic CSRs (both MMIO and Config)  
//-------------------------------------------------------------------------

// Detect rising edge of msg from SB

assign sb_ep_msg_prim_irdy_redge = sb_ep_msg_prim.irdy & ~sb_ep_msg_prim_irdy_ff; 

// HSD 5020226 - wrack/rdack need to be sent for cfg txns to incorrect functions
// decode incoming sideband request type

assign sb_cfg_rd = sb_ep_msg_prim.irdy & (sb_ep_msg_prim.op == HQMEPSB_CFGRD); 
assign sb_cfg_wr = sb_ep_msg_prim.irdy & (sb_ep_msg_prim.op == HQMEPSB_CFGWR); 
assign sb_mem_wr = sb_ep_msg_prim.irdy & (sb_ep_msg_prim.op == HQMEPSB_MWR);
assign sb_mem_rd = sb_ep_msg_prim.irdy & (sb_ep_msg_prim.op == HQMEPSB_MRD);

always_comb begin: sb_ri_cds_msg_gen_p

    sb_cds_msg                        = '0                                                             ;

    // jbdiethe According to the IOSF Shim MAS the Device/Function number is a
    // dont care for Mrd/Mwr "Function ID - HQM's Physical Function ID ('d11).  
    // This is a don't care for Memory requests." moved the iosfsb_vld_devn
    // to qualify the iosfsb_cfgrd and iosfsb_cfgwr
    // HSD 4728542 - only CFG/MEM txns should go to CDS. Other types should 
    // not activate avail to cds.

    sb_cds_msg.addr                   = sb_ep_msg_prim.addr                                            ;
    sb_cds_msg.data                   = sb_ep_msg_prim.data                                            ;
    sb_cds_msg.sdata                  = sb_ep_msg_prim.sdata                                           ;
    sb_cds_msg.fbe                    = sb_ep_msg_prim.fbe                                             ;
    sb_cds_msg.sbe                    = sb_ep_msg_prim.sbe                                             ;
    sb_cds_msg.bar                    = sb_ep_msg_prim.bar                                             ;
    sb_cds_msg.np                     = sb_ep_msg_prim.np                                              ;
    sb_cds_msg.sai                    = sb_ep_msg_prim.sai                                             ;
    sb_cds_msg.fid                    = sb_ep_msg_prim.fid                                             ;

    sb_cds_msg.cfgrd                  = sb_cfg_rd & iosfsb_vld_devn & out_of_cpp_rst                   ;
    sb_cds_msg.cfgwr                  = sb_cfg_wr & iosfsb_vld_devn & out_of_cpp_rst                   ; 
    sb_cds_msg.mmiord                 = sb_mem_rd & val_ep_bar      & out_of_cpp_rst                   ; 
    sb_cds_msg.mmiowr                 = sb_mem_wr & val_ep_bar      & out_of_cpp_rst                   ; 
    sb_cds_msg.irdy                   = sb_cds_msg.cfgrd  | sb_cds_msg.cfgwr |
                                        sb_cds_msg.mmiord | sb_cds_msg.mmiowr                          ;

end

// HSD 4186883 - added valid_func in to valid device checking for sideband so it 
//               can respond to VF requests correctly based on SRIOV EN bits
// HSD 5020226 - VF 1-16 not working for Bell, need to update function numbers
// HSD 4727753 - VF getting UR due to mismatching FID field

assign iosfsb_vld_devn = sb_ep_msg_prim.irdy & ~(|sb_ep_msg_prim.fid[7:0])                             ;

// may need to update for new BARs added or removed in various projects
// HSD 5020249 - txns with bad bar not sending ursp
// HSD 4727758 - SB txns fail with addr > 48 bits. ESRAM needs its 
//               own bar and need to add to valid decoding

assign val_ep_bar                     = (   (sb_ep_msg_prim.bar == `HQM_IOSF_SB_BAR_FUNC)
                                         & ~(|sb_ep_msg_prim.addr[47:26])
                                         &  iosfsb_vld_devn
                                        ) | 
                                        (   (sb_ep_msg_prim.bar == `HQM_IOSF_SB_BAR_CSR)
                                         & ~(|sb_ep_msg_prim.addr[47:32])
                                         & ~(|sb_ep_msg_prim.fid)
                                        )                                                              ;
assign bad_sb_mmiord_acc              = sb_mem_rd & !val_ep_bar                                        ; 
assign bad_sb_mmiowr_acc              = sb_mem_wr & !val_ep_bar                                        ; 
    

//-------------------------------------------------------------------------
// IOSF SB MMIO Req register block
//-------------------------------------------------------------------------
// HSD 5020226 - wrack/rdack need to be sent for cfg txns to incorrect functions
// HSD 4727958 - URSP has to be held high instead of pulsed. set with pulse, clear with next avail
//
// Only use the 00 and 01 responses hence 1 bit:
//   Response Status: Indicates the status of the Completion.
//     00: Successful
//     01: Unsuccessful / Not Supported
//     10: Powered Down
//     11: Multicast Mixed Status

always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin: ILLEGAL_IOSFSB_BAR_AND_STAGING_FLOPS
    if (!side_gated_rst_prim_b) begin

        ep_sb_ursp_temp              <= '0                                                             ;
        ep_sb_cmsg_prim.rdata        <= '0                                                             ; 
        ep_sb_cmsg_prim.eom          <= '0                                                             ;
        ep_sb_cmsg_prim.dvld         <= '0                                                             ;
        ep_sb_cmsg_prim.vld          <= '0                                                             ;

    end else begin

        if (ep_sb_local_mmio_cpl_vld | ep_sb_local_cfg_cpl_vld | ep_sb_during_prim_rst) begin

            // CFG access w/ invalid function or MMIO access w/ invalid bar must be URed.
            // Any accesses to non-local regs while prim_rst_b is asserted must be silently dropped.
            // So we drop the writes and return 0's for reads.
            // Set the vld signal if non-posted.

            ep_sb_ursp_temp          <= (ep_sb_local_mmio_cpl_vld | ep_sb_local_cfg_cpl_vld)           ; 
            ep_sb_cmsg_prim.rdata    <= '0                                                             ;
            ep_sb_cmsg_prim.eom      <= '1                                                             ;
            ep_sb_cmsg_prim.dvld     <= '0                                                             ;
            ep_sb_cmsg_prim.vld      <= sb_ep_msg_prim.np                                              ;

        end else begin

            // Default is to pass the CDS response signals which should only be active when a valid
            // CDS transaction is outstanding.

            ep_sb_ursp_temp          <= cds_sb_cmsg.ursp & ~sb_ep_msg_prim_irdy_redge                  ; 
            ep_sb_cmsg_prim.rdata    <= cds_sb_cmsg.rdata                                              ;
            ep_sb_cmsg_prim.eom      <= cds_sb_cmsg.eom                                                ;
            ep_sb_cmsg_prim.dvld     <= cds_sb_cmsg.dvld                                               ;
            ep_sb_cmsg_prim.vld      <= cds_sb_cmsg.vld                                                ;

        end
    end
end: ILLEGAL_IOSFSB_BAR_AND_STAGING_FLOPS

assign ep_sb_cmsg_prim.ursp         = ep_sb_ursp_temp & ~sb_ep_msg_prim_irdy_redge                     ; 

assign ep_sb_local_cfg_cpl_vld      = (sb_cfg_rd | sb_cfg_wr) & ~iosfsb_vld_devn &
                                        sb_ep_msg_prim_irdy_redge                                      ;

assign ep_sb_local_mmio_cpl_vld     = (bad_sb_mmiord_acc | bad_sb_mmiowr_acc) &
                                        sb_ep_msg_prim_irdy_redge                                      ;

assign ep_sb_during_prim_rst        = (sb_cfg_rd | sb_cfg_wr | sb_mem_wr | sb_mem_rd) &
                                        ~out_of_cpp_rst & sb_ep_msg_prim_irdy_redge                    ;

//-------------------------------------------------------------------------
// IOSF SB request register block
//-------------------------------------------------------------------------

always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin: iosf_csr_req_p
    
    if (!side_gated_rst_prim_b) begin
        sb_ep_msg_prim_irdy_ff       <= 1'b0                                                           ; 
    end else begin
        sb_ep_msg_prim_irdy_ff       <= sb_ep_msg_prim.irdy                                            ; 
    end
    
end // always_ff csr_pcpp_gnt_p

// HSD 4186978

always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin: ep_wrack_p
    if (!side_gated_rst_prim_b) 
      ep_sb_wrack                    <= '0                                                             ; 
    else

      // HSD 5020226 - wrack/rdack need to be sent for cfg txns to incorrect functions

      ep_sb_wrack                    <= (sb_ep_msg_prim_irdy_redge &
                                         (( sb_cfg_wr              & ~iosfsb_vld_devn) |                 // CFGWR and not valid function
                                          ((sb_cfg_wr | sb_mem_wr) & ~out_of_cpp_rst)  |                 // CFGWR/MWR during prim reset
                                          bad_sb_mmiowr_acc))                          |                 // Illegal mmio bar
                                        cds_sb_wrack                                                   ; // Write ack from CDS

end : ep_wrack_p

always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin: ep_rdack_p
    if (!side_gated_rst_prim_b) 
      ep_sb_rdack                    <= '0                                                             ; 
    else

      // HSD 5020226 - wrack/rdack need to be sent for cfg txns to incorrect functions

      ep_sb_rdack                    <= (sb_ep_msg_prim_irdy_redge &
                                         (( sb_cfg_rd              & ~iosfsb_vld_devn) |                 // CFGRD and not valid function
                                          ((sb_cfg_rd | sb_mem_rd) & ~out_of_cpp_rst)  |                 // CFGRD/MRD during prim reset
                                          bad_sb_mmiord_acc))                          |                 // Illegal mmio bar
                                        cds_sb_rdack                                                   ; // Read ack from CDS

end

always_comb begin: sb_ep_sb_msgack_gen_p

    ep_sb_msgack_nxt              = sb_ep_msg_prim_irdy_redge &                                          // Common Ack for most messages
                                         ((sb_ep_msg_prim.op == HQMEPSB_FORCEPWRGATEPOK) |
                                          (sb_ep_msg_prim.op == HQMEPSB_RSPREP))                       ;
end

always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin: ep_msgack_p
    
    if (!side_gated_rst_prim_b) begin
        ep_sb_msgack                  <= '0                                                            ; 
    end else begin
        ep_sb_msgack                  <= ep_sb_msgack_nxt                                              ;
    end
    
end 

assign ep_sb_msg_prim_trdy            = (ep_sb_wrack  | ep_sb_rdack | ep_sb_msgack )                   ;

//-------------------------------------------------------------------------
// NCPM Error Logic will be re-routed to ri_int where it will be arbitrated
// Legacy Interrupts.
//-------------------------------------------------------------------------

always_ff @(posedge prim_gated_clk or negedge side_gated_rst_prim_b) begin: err_sb_ff_p
    if (!side_gated_rst_prim_b) begin
        err_sb_msgdata               <= '0                                                             ; 
        err_sb_msgavail              <= '0                                                             ; 
        err_sb_msgop                 <= '0                                                             ; 
    end else if (err_gen_msg & !err_sb_msgavail) begin
        err_sb_msgdata               <= {8'b0,
                                         err_gen_msg_data,
                                         err_gen_msg_func[15:0]}                                       ;
        err_sb_msgavail              <= 1'b1                                                           ; 
        err_sb_msgop                 <= HQMEPSB_ERR                                                    ; 
    end else if (err_sb_msgack) begin
        err_sb_msgdata               <= '0                                                             ; 
        err_sb_msgavail              <= '0                                                             ; 
        err_sb_msgop                 <= '0                                                             ; 
    end
end: err_sb_ff_p

//----------------------------------------------------------------------
// Error message has been sent off.  Trigger a release response from the
// error logic in ri_cds.  ri_err may issue another request, but will 
// not be serviced until it has acknowledge any preceding msg request.
//----------------------------------------------------------------------

assign err_sb_msgack                  = sub_fsm_ns[SUB_EOM_S] &
                                        (ep_sb_msg_prim_pnc.op == HQMEPSB_ERR)                         ; 

assign ri_iosf_sb_idle                = ~|{pm_hqm_adr_assert_sync
                                          ,sb_ep_msg_prim.irdy
                                          ,ep_sb_msg_prim_pnc.irdy
                                          ,ep_sb_cmsg_prim_valid_q
                                          ,(main_fsm_ps          != MN_IDLE)
                                          ,(sub_fsm_ps           != SUB_IDLE)
};

assign adr_clkreq                     = pm_hqm_adr_assert_sync;

//-------------------------------------------------------------------------
// Assertions
//-------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

MAIN_FSM_MUST_BE_MUTEX: assert property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  $onehot(main_fsm_ps)) else                                                           
  $error ("Error: Main FSM states are not mutually exclusive")                                         ;

SUB_FSM_MUST_BE_MUTEX: assert property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  $onehot(sub_fsm_ps)) else                                                           
  $error ("Error: Substate FSM states are not mutually exclusive")                                     ;

//////////////////////////////////
// Reset Prep Quiesce Assertions

// SB MST should never issue anything after the resetprepack has been issued.
AFTER_RESETPREPACK_NO_SB_MST_TRAFFIC: assert property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  (~(disable_sb_mst & ep_sb_msg_prim_pnc.irdy))) else
  $error ("Error: SB TGT should never issue an ingress P, NP to EP during quiesce.")              ;   

// The last transaction issued before quiescing the master is RESETPREPACK
logic [7:0]                                last_opcode_sent_inst                                       ;

always_ff @(posedge prim_gated_clk, negedge side_gated_rst_prim_b) begin: ri_sb_last_opcode_sent_inst
    if (!side_gated_rst_prim_b) begin
        last_opcode_sent_inst             <= '0                                                        ; 
    end else begin 
        if (ep_sb_msgack_nxt | pm_hqm_adr_assert_redge) begin
          last_opcode_sent_inst           <= (pm_hqm_adr_assert_redge) ? HQMEPSB_RSPREP : sb_ep_msg_prim.op ;
        end
    end
end

LAST_MESSAGE_BEFORE_QUIESCE_WAS_RSPREP: assert property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  (~(disable_sb_mst & (last_opcode_sent_inst != HQMEPSB_RSPREP)          &
                      (last_opcode_sent_inst != HQMEPSB_FORCEPWRGATEPOK)))) else
  $error ("Error: Last message before a SB MST quiesce must be a reseprep or forcepwrgatepok.")        ;   

// Should never see this. The 2nd resetprep will actually get dropped. The SB tgt is dropping Ps
// and URing NPs.
RSPREP_SENT_WHILE_ANOTHER_PENDING: assert property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  (~(pmc2ep_rsprep & 
     $past(~sb_ep_msg_prim.irdy) & sb_ep_msg_prim.irdy & 
     (ep_sb_msg_prim_pnc.op == HQMEPSB_RSPREP)))) else
  $error ("Error: HQM no longer supports the receiving of a rsprep while an earlier one is pending.")  ;

                                        
//-------------------------------------------------------------------------
// Coverage
//-------------------------------------------------------------------------

//////////////////////////////////////
// Reset Prep Quiesce Logic Coverage

// State transition of the Reset Prep Quiesce Logic State machine
// Could add assertion for any other arcs, they are forbidden. However these must be hit 
// to exercise the Reset Prep Quiesce State machine and accordingly the quiesce logic
// itself.  
// 
RSPREP_QUIESCE_FSM_ARC_IDLE_TO_DETECT: cover property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  (out_of_cpp_rs_fsm_ps[IDLE_RST_STATE_S]        |=> out_of_cpp_rs_fsm_ps[RSPREP_DETECTED_STATE_S]))   ; 

RSPREP_QUIESCE_FSM_ARC_DETECT_TO_RST_START: cover property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  (out_of_cpp_rs_fsm_ps[RSPREP_DETECTED_STATE_S] |=> out_of_cpp_rs_fsm_ps[RESET_STARTED_STATE_S]))     ; 

RSPREP_QUIESCE_FSM_ARC_RST_START_TO_RST_END: cover property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  (out_of_cpp_rs_fsm_ps[RESET_STARTED_STATE_S]   |=> out_of_cpp_rs_fsm_ps[RESET_ENDED_STATE_S]))       ; 

RSPREP_QUIESCE_FSM_ARC_RST_END_TO_IDLE: cover property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  (out_of_cpp_rs_fsm_ps[RESET_ENDED_STATE_S]     |=> out_of_cpp_rs_fsm_ps[IDLE_RST_STATE_S]))          ;           

// After quieces is asserted sometime later votes should go from 0 to 1
RSPREP_QUIESCE_PC_MSTR_VOTE_WENT_HIGH: cover property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  (quiesce_pc & $past(~sif_mstr_quiesce_ack) & sif_mstr_quiesce_ack))              ;           

RSPREP_QUIESCE_SB_TGT_VOTE_WENT_HIGH: cover property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  (sif_gpsb_quiesce_req & $past(~sif_gpsb_quiesce_ack_sync) & sif_gpsb_quiesce_ack_sync))              ;           

// The collating of votes needs to go high during quiesce.
RSPREP_QUIESCE_ALL_VOTES_COUNTED: cover property (@(posedge prim_gated_clk) disable iff (~side_gated_rst_prim_b) 
  (quiesce_pc & $past(~send_rsprepack) & send_rsprepack))                                              ;           

`endif

endmodule // hqm_ri_iosf_sb

