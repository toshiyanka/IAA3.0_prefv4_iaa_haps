// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name  : hqm_sb_ep_xlate
// -- Author       : 
// -- Project      : CPM 1.7 (Bell Creek)
// -- Description  :
// -- 
// --   This file performs various translation tasks for SB
// --
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_sb_ep_xlate

     import hqm_sif_pkg::*, hqm_sif_csr_pkg::*, hqm_system_type_pkg::*;

(

     input  logic                               ipclk
    ,input  logic                               ip_rst_b

    ,input  logic                               prim_gated_rst_b

    // Legal SAI values for Sideband ResetPrep message

    ,input  logic [SAI_WIDTH:0]                 strap_hqm_resetprep_sai_0
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_resetprep_sai_1

    // Legal SAI values for Sideband ForcePwrGatePOK message

    ,input  logic [SAI_WIDTH:0]                 strap_hqm_force_pok_sai_0
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_force_pok_sai_1

    // Fuse interface

    ,input  logic                               fuse_proc_disable

    // Register access controls

    ,input  logic [63:0]                        hqm_csr_rac
    ,input  logic [63:0]                        hqm_csr_wac

    // Message Info sent to EP by SB

    ,output hqm_sb_ep_msg_t                     sb_ep_msg
    ,input  logic                               ep_sb_msg_trdy              // Tready handshake for sb_sp_msg

    // Message Response from EP to SB

    ,input  hqm_cds_sb_tgt_cmsg_t               ep_sb_cmsg                  // Completion message back to the sb_tgt in the shim 

    // Message Info sent by EP

    ,input  hqm_ep_sb_msg_t                     ep_sb_msg
    ,output logic                               sb_ep_msg_trdy

    // Message Cmpl sent to EP

    ,output hqm_sb_ep_cmp_t                     sb_ep_cmsg
  
    // Ingress Target Message Interface - Msg for the IP (via xlate)

    ,input  hqm_sb_tgt_msg_t                    tgt_ip_msg                  // Tgt to IP Msg struct
    ,output logic                               ip_tgt_msg_trdy             // handshake for Tgt to IP  

    // Egress Target Completion Interface - Cmp from the IP (via xlate)

    ,output hqm_sb_tgt_cmsg_t                   ip_tgt_cmsg                 // IP to Tgt Cmp Msg

    // Egress Master Message Interface - Msg from the IP (via xlate)

    ,output hqm_ep_sb_msg_t                     ip_mst_msg
    ,input  logic                               mst_ip_msg_trdy

    // Ingress Master Completion Interface - Cmp to the IP (via xlate)

    ,input  hqm_sb_ep_cmp_t                     tgt_ip_cmsg

    // Master interface (these are on side_clk!)

    ,output logic                               master_ctl_load
    ,output logic [31:0]                        master_ctl

    ,output VISA_SW_CONTROL_t                   cfg_visa_sw_control

    ,input  logic                               cfg_visa_sw_control_write
    ,input  VISA_SW_CONTROL_t                   cfg_visa_sw_control_wdata

);

//------------------------------------------------------------------------
// Local Parameter Definition
//------------------------------------------------------------------------
// VFs are accessed as [1] topmost index and PFs are accessed as [0]

localparam SAI_LSB = 8; // bit 8 of the 32 bit is where the SAIs start

localparam HQM_SB_LOCAL_NUM_REGS                = 2;
localparam HQM_SB_LOCAL_MASTER_CTL_ADDR         = 48'h0000_ac00_0000;  // 1st FEATURE reg in the hqm_master

//------------------------------------------------------------------------
// Interconnecting wires
//------------------------------------------------------------------------
logic                                      valid_op; 

logic                                      sai_violation;

// Message Decoding

logic                                      ep_cfgrd; 
logic                                      ep_cfgwr; 
logic                                      ep_mmiord; 
logic                                      ep_mmiowr; 
logic                                      ep_rsprep; 
logic                                      ep_fpgpok; 

//------------------------------------------------------------------------
// HSD 4187049:  Invalid op bug
//------------------------------------------------------------------------
logic                                      invalid_op_next; 
logic                                      invalid_op_q; 

//------------------------------------------------------------------------

logic                                      prim_gated_rst_b_sync;

logic                                      access_in_prim_rst_next;
logic                                      access_in_prim_rst_q;

logic   [SAI_WIDTH:0]                      tgt_ip_msg_sai;
logic                                      tgt_ip_msg_irdy_q;
logic                                      tgt_ip_msg_irdy_redge;

logic                                      ep_rd_q;
logic                                      ep_np_q;
                                          
logic [HQM_SB_LOCAL_NUM_REGS-1:0]          sb_local_reg_hit;
logic [HQM_SB_LOCAL_NUM_REGS-1:0]          sb_local_reg_rd;
logic [HQM_SB_LOCAL_NUM_REGS-1:0]          sb_local_reg_wr;
logic [HQM_SB_LOCAL_NUM_REGS-1:0]          sb_local_reg_wr_q;
logic                                      sb_local_done_q;
logic                                      sb_local_access;
logic [31:0]                               sb_local_rdata_q;
logic [2:0]                                sb_local_cnt_next;
logic [2:0]                                sb_local_cnt_q;
                                          
logic [7:0]                                tgt_ip_msg_sai_cr;
                                          
logic                                      master_ctl_load_next;
logic                                      master_ctl_load_q;
logic [31:0]                               master_ctl_next;
logic [31:0]                               master_ctl_q;
                                          
VISA_SW_CONTROL_t                          VISA_SW_CONTROL_next;
VISA_SW_CONTROL_t                          VISA_SW_CONTROL;

logic [63:0]                               hqm_csr_rac_sync;
logic [63:0]                               hqm_csr_wac_sync;

hqm_ep_sb_msg_t                            ip_mst_msg_next;

//------------------------------------------------------------------------
// Local prim_gated_rst_b as data

hqm_AW_sync i_prim_gated_rst_b_sync (

     .clk           (ipclk)
    ,.data          (prim_gated_rst_b)
    ,.data_sync     (prim_gated_rst_b_sync)
);

// Need side_clk synced versions of these bits for the SAI check

hqm_AW_sync #(.WIDTH(128)) i_rac_wac_syncs (

     .clk           (ipclk)
    ,.data          ({hqm_csr_rac,      hqm_csr_wac     })
    ,.data_sync     ({hqm_csr_rac_sync, hqm_csr_wac_sync})
);

//------------------------------------------------------------------------
// Decodes the incoming message (similar to VLV decode logic)
//------------------------------------------------------------------------

always_comb begin : SB_TGT_DEC

    ep_cfgrd  = (tgt_ip_msg.opcode == HQMEPSB_CFGRD); 
    ep_cfgwr  = (tgt_ip_msg.opcode == HQMEPSB_CFGWR); 
    ep_mmiord = (tgt_ip_msg.opcode == HQMEPSB_MRD  ); 
    ep_mmiowr = (tgt_ip_msg.opcode == HQMEPSB_MWR  ); 
    ep_rsprep = (tgt_ip_msg.opcode == HQMEPSB_RSPREP);
    ep_fpgpok = (tgt_ip_msg.opcode == HQMEPSB_FORCEPWRGATEPOK);

    // ResetPrep/ForcePwrGatePok SAI violations and accesses when the proc_disable fuse
    // are set, will be locally detected and URed.

    // Assign DEVICE_UNTRUSTED_SAI if no eh

    tgt_ip_msg_sai = tgt_ip_msg.eh ? tgt_ip_msg.ext_header[0][SAI_LSB+:(SAI_WIDTH+1)] : '0;

    sai_violation  = (ep_rsprep & (tgt_ip_msg_sai != strap_hqm_resetprep_sai_0) &
                                  (tgt_ip_msg_sai != strap_hqm_resetprep_sai_1)) |
                     (ep_fpgpok & (tgt_ip_msg_sai != strap_hqm_force_pok_sai_0) &
                                  (tgt_ip_msg_sai != strap_hqm_force_pok_sai_1));

    valid_op       = ((|{ep_cfgrd, ep_cfgwr, ep_mmiord, ep_mmiowr}) & ~fuse_proc_disable) |
                     ((|{ep_rsprep, ep_fpgpok})                     & ~sai_violation);

end : SB_TGT_DEC

//------------------------------------------------------------------------

assign tgt_ip_msg_irdy_redge   = tgt_ip_msg.irdy       & ~tgt_ip_msg_irdy_q;
assign invalid_op_next         = tgt_ip_msg_irdy_redge & ~(sb_local_access | valid_op);
assign access_in_prim_rst_next = tgt_ip_msg_irdy_redge & valid_op & ~prim_gated_rst_b_sync;

always_ff @(posedge ipclk or negedge ip_rst_b) begin
    if (~ip_rst_b) begin

        tgt_ip_msg_irdy_q    <= '0;
        invalid_op_q         <= '0; 
        access_in_prim_rst_q <= '0;

        ep_rd_q              <= '0;
        ep_np_q              <= '0;

    end else begin

        tgt_ip_msg_irdy_q    <= tgt_ip_msg.irdy;
        access_in_prim_rst_q <= access_in_prim_rst_next;
        invalid_op_q         <= invalid_op_next; 

        // Save read, write, and non-posted indications

        if (tgt_ip_msg_irdy_redge) begin
            ep_rd_q          <= ep_cfgrd | ep_mmiord;
            ep_np_q          <= tgt_ip_msg.np;
        end
    end
end

//------------------------------------------------------------------------
// Handle access to local sideband-only regs
//------------------------------------------------------------------------
// Adding 3 side_clk cycles of setup/hold around the load signals for the
// master control regs
//                        _   _   _   _   _   _   _   _   _   _   _
// clk                  _| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_ 
//                            ___
// sb_local_reg_wr[*]   _____|   |___________________________________
//                                ___________________________________
// sb_local_reg_wr_q    XXXXXXXXXX___________________________________
//                      _________ ___ ___ ___ ___ ___ ___ ___________
// sb_local_cnt_q       _0_______X_6_X_5_X_4_X_3_X_2_X_1_X_0_________
//                      _________                         ___________
// *_load                        |_______________________|
//                      _____________________ _______________________
// reg value            _____________________X_______________________

// Decode access to local regs
// Must be accessing specific CSR bar addresses of the local regs

// This is a 1 cycle pulse

assign sb_local_reg_hit  = {HQM_SB_LOCAL_NUM_REGS{(tgt_ip_msg_irdy_redge &
                                                   ~fuse_proc_disable    &
                                                  (tgt_ip_msg.bar  == `HQM_IOSF_SB_BAR_CSR) &
                                                  (tgt_ip_msg.be   == 8'h0F))}} & 

                           {(tgt_ip_msg.addr == VISA_SW_CONTROL_CR_ADDR),
                            (tgt_ip_msg.addr == HQM_SB_LOCAL_MASTER_CTL_ADDR)};

assign tgt_ip_msg_sai_cr = hqm_rtlgen_pkg_v12::f_sai_sb_to_cr(tgt_ip_msg_sai);  

// These are 1 cycles pulses

assign sb_local_reg_rd   = sb_local_reg_hit &
                           {HQM_SB_LOCAL_NUM_REGS{(ep_mmiord & hqm_csr_rac_sync[tgt_ip_msg_sai_cr[5:0]])}};
assign sb_local_reg_wr   = sb_local_reg_hit &
                           {HQM_SB_LOCAL_NUM_REGS{(ep_mmiowr & hqm_csr_wac_sync[tgt_ip_msg_sai_cr[5:0]])}};

// Counter loads with 6 and counts down to 0 on any local reg write pulse

assign sb_local_cnt_next = (|sb_local_reg_wr) ? 3'd6 : (sb_local_cnt_q - {2'd0, (|sb_local_cnt_q)});

always_comb begin

    master_ctl_next      = master_ctl_q;
    master_ctl_load_next = master_ctl_load_q;
    VISA_SW_CONTROL_next = VISA_SW_CONTROL;

    // Turn off the load signal 3 clocks before writing the associated reg

        if (sb_local_reg_wr[0])   master_ctl_load_next = '0;

    // Set the load signal 3 clocks after writing the associated reg

    if (sb_local_cnt_q == 3'd1) begin
        if (sb_local_reg_wr_q[0]) master_ctl_load_next = '1;
    end

    // Write the reg 3 clocks after dropping the associated load signal

    if (sb_local_cnt_q == 3'd4) begin

        if (sb_local_reg_wr_q[0]) master_ctl_next      = tgt_ip_msg.wdata[31:0];
        if (sb_local_reg_wr_q[1]) VISA_SW_CONTROL_next = tgt_ip_msg.wdata[31:0];

    end

    // This is also written from IOSF primary after write controls synced into side_clk

    if (cfg_visa_sw_control_write) VISA_SW_CONTROL_next = cfg_visa_sw_control_wdata;

end

always_ff @(posedge ipclk or negedge ip_rst_b) begin
    if (~ip_rst_b) begin

        sb_local_cnt_q            <= '0;

        sb_local_reg_wr_q         <= '0;

        sb_local_done_q           <= '0;

        sb_local_rdata_q          <= '0;

        master_ctl_load_q         <= '1;    // Reset value is 1
        master_ctl_q              <= '0;

        VISA_SW_CONTROL           <= '0;

    end else begin

        sb_local_cnt_q            <= sb_local_cnt_next;

        // Save vector of which reg is being written

        if (|sb_local_reg_wr)     sb_local_reg_wr_q  <= sb_local_reg_wr;

        // Local reads complete immediately, local writes complete when counter is 1 

        sb_local_done_q           <= |{sb_local_reg_rd, (sb_local_cnt_q == 3'd1)};

        if (sb_local_reg_rd[0]) begin
          sb_local_rdata_q <= master_ctl_q;
        end else if (sb_local_reg_rd[1]) begin
          sb_local_rdata_q <= VISA_SW_CONTROL;
        end else if (|sb_local_reg_wr) begin
          sb_local_rdata_q <= '1;
        end

        master_ctl_load_q         <= master_ctl_load_next;
        master_ctl_q              <= master_ctl_next;

        VISA_SW_CONTROL           <= VISA_SW_CONTROL_next;

    end
end

// Inidcation a local access is in progress

assign sb_local_access = |{sb_local_reg_rd, sb_local_reg_wr, sb_local_cnt_q, sb_local_done_q};

// These are the outputs to hqm_master on side_clk

assign master_ctl_load         = master_ctl_load_q;
assign master_ctl              = master_ctl_q;

assign cfg_visa_sw_control     = VISA_SW_CONTROL;

//------------------------------------------------------------------------
// SB to EP Message Generation
//------------------------------------------------------------------------

always_comb begin : SB_EP_MSG_GEN

    // Take the full 32-bit address for possible MMIO access; for cfg 
    // accesses, address need to be dw aligned (need to confirm).

    sb_ep_msg.addr                    = tgt_ip_msg.addr; 
    sb_ep_msg.bar                     = tgt_ip_msg.bar; 
    sb_ep_msg.fid                     = tgt_ip_msg.fid; 
    sb_ep_msg.src                     = tgt_ip_msg.source; 
    sb_ep_msg.np                      = tgt_ip_msg.np; 
    sb_ep_msg.sai                     = tgt_ip_msg_sai;

    // Send opcode to EP

    sb_ep_msg.op                      = tgt_ip_msg.opcode; 
    {sb_ep_msg.sbe, sb_ep_msg.fbe}    = tgt_ip_msg.be; 
    
    // Extract only 32bits of data for EP sb messages

    {sb_ep_msg.sdata, sb_ep_msg.data} = tgt_ip_msg.wdata; 
    
    // Indicate sb is sending a valid request to EP
    // ri_cds expects an edge so no back-to-back. This is not an issue since
    // the SB is so much slower then this prim_clk logic.
    // Only send when valid transaction to external reg while prim_rst_b is deasserted

    sb_ep_msg.irdy                    = tgt_ip_msg.irdy & valid_op &
                                        prim_gated_rst_b_sync & ~sb_local_access; 

end: SB_EP_MSG_GEN

always_comb begin: SB_EGRESS_CMP_GEN_FOR_INGRESS_MSG

    // Accept the transaction by asserting ip_tgt_msm_trdy only when:
    //   1.  EP has accepted the CFG/MMIO request by asserting ep_sb_msg_trdy
    //   2.  Locally detected invalid op
    //   3.  Access is a valid access to a local reg
    //   4.  Any access to a non-local reg while prim_rst_b is asserted which will be
    //       silently dropped (posted dropped, non-posted return SC with 0 data)

    ip_tgt_msg_trdy  = tgt_ip_msg_irdy_q & (|{ep_sb_msg_trdy,  invalid_op_q,
                        sb_local_done_q, access_in_prim_rst_q}); 

    // Completion valid and end-of-message are only set on non-posted access of local reg,
    // non-posted access of external reg while prim_rst_b is asserted,  a locally detected
    // invalid non-posted op, or from a valid external completion response.

    ip_tgt_cmsg.vld  = (sb_local_done_q       |
                        access_in_prim_rst_q  |
                        invalid_op_q)         ? ep_np_q : ep_sb_cmsg.vld;

    ip_tgt_cmsg.eom  = (sb_local_done_q       |
                        access_in_prim_rst_q  |
                        invalid_op_q)         ? ep_np_q : ep_sb_cmsg.eom;

    // UR only set for locally detected invalid op or UR set on external completion response

    ip_tgt_cmsg.ursp = (sb_local_done_q       |
                        access_in_prim_rst_q) ? 1'b0    : 
                      ((invalid_op_q)         ? 1'b1    : ep_sb_cmsg.ursp); 

    // Completion data valid is only set under the same conditions valid is set and
    // if the transaction was a read (by definition non-posted w/ data).

    ip_tgt_cmsg.dvld = (sb_local_done_q       |
                        access_in_prim_rst_q  |
                        invalid_op_q)         ? ep_rd_q : ep_sb_cmsg.dvld;

    // Local accesses return the local rdata (reg value for reads, all 1s for writes)
    // External accesses w/ prim_rst_b asserted or invalid ops return all 0s for reads
    // and all 1s for writes
    // An external access response passes the external response data by default

    ip_tgt_cmsg.data = (sb_local_done_q)      ? {32'd0, sb_local_rdata_q} :
                      ((access_in_prim_rst_q  |
                        invalid_op_q)         ? ((ep_rd_q) ? '0 : '1) : ep_sb_cmsg.rdata);

end: SB_EGRESS_CMP_GEN_FOR_INGRESS_MSG

//------------------------------------------------------------------------
// Flop incoming EP to SB Msg and drive as IP to SB Msg.
//------------------------------------------------------------------------

always_comb begin

    ip_mst_msg_next = ip_mst_msg;

    if (ep_sb_msg.irdy) begin
        ip_mst_msg_next      = ep_sb_msg;
        ip_mst_msg_next.irdy = ep_sb_msg.irdy & ~mst_ip_msg_trdy; 
    end

end

always_ff @(posedge ipclk or negedge ip_rst_b) begin : FLOP_INCOMING_EP_MSG
    if (~ip_rst_b) begin
        ip_mst_msg <= '0; 
    end else begin
        ip_mst_msg <= ip_mst_msg_next; 
    end 
end : FLOP_INCOMING_EP_MSG

// Route SB Master TRdy back to EP to indicate request has been accepted

assign sb_ep_msg_trdy = mst_ip_msg_trdy; 

// Could put a flop here but it should be fine. Its coming off a flop in SB Target

assign sb_ep_cmsg     = tgt_ip_cmsg;

endmodule : hqm_sb_ep_xlate

