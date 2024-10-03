//------------------------------------------------------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//------------------------------------------------------------------------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
// hqm_cfg_master_sys2cfg   (CONFIG RING MASTER)
//
// This module is responsible for providing an Amba 3 APB bus to cfg module bridge.  It supports one clock.
// It registers the input side and output side (APB I/O and CFG I/O). cfg request that are valid for a single cfg clock cycle.  It registers the cfg response and
// ensures that the pready, pslverr and prdata have the full APB cycle time to return to the requestor.
// The /addr/wdata outputs are common to all of the cfg request interfaces.  The
// cfg_apb_ack/err/rdata inputs are vectors that are concatenated fields from each cfg response
// interface.  The TGT_MAP and TGT_MSK input parameters are vectors that are 32 bits wide and specify the cfg
// address for the ctrl/status register internal to this module.
// A timeout counter is used to timeout requests.  If a timeout occurs, a response is triggered and pready
// is asserted.
//
// This module will also detect if the psel is deasserted w/o a corresponding pready and use this as
// an indication to abort any outstanding cfg request.
//
// The following parameters are supported:
//   
//   HQM_CORE_CFG_TIMEOUT_WIDTH    Width for the Timeout Value
//   HQM_CORE_CFG_TIMEOUT_VALUE    Timeout Value, once downcount reaches this value after a req is issued, a rsp is triggered
//   UID              Unit ID for this module
//--------------------------------------------------------------------------------------------------------------

module hqm_cfg_master_sys2cfg 
        import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(
        input  logic                            prim_gated_clk
      , input  logic                            prim_gated_rst_b_sync 
      , input  logic                            hqm_flr_prep 
      , input  logic                            pm_fsm_in_run 
      , input  logic                            core_reset_done   

      , input  logic                            inj_par_err_rdata  
      , input  logic                            inj_par_err_wdata
      , input  logic                            inj_par_err_addr
      , output logic                            inj_par_err_req_clr
      , output logic                            inj_par_err_rsp_clr
      , input  logic                            cfg_ignore_pipe_busy
      , input  logic                            cfg_disable_ring_par_ck
      , input  logic                            cfg_disable_pslverr_timeout

      , output logic                            cfg_req_ring_active
      , output logic                            cfg_req_mstr_active

      , output logic                            err_timeout
      , output logic                            err_cfg_reqrsp_unsol
      , output logic                            err_cfg_protocol
      , output logic                            err_cfg_req_up_miss
      , output logic                            err_slv_access
      , output logic                            err_slv_timeout
      , output logic                            err_slv_par
      , output logic                            err_cfg_decode
      , output logic                            err_cfg_decode_par
      , output logic                            err_cfg_req_drop
 
      , input  cfg_user_t                       puser
      , input  logic                            psel
      , input  logic                            pwrite
      , input  logic                            penable
      , input  logic    [( 32 )-1:0]            paddr
      , input  logic    [( 32 )-1:0]            pwdata

      , output logic                            pready
      , output logic                            pslverr                 // Indicates parity err on addr/wdata/slverr
      , output logic    [( 32 )-1:0]            prdata
      , output logic                            prdata_par

      , output logic                            cfg_req_internal_write
      , output logic                            cfg_req_internal_read
      , output cfg_req_t                        cfg_req_internal

      , input  logic                            cfg_rsp_internal_ack
      , input  cfg_rsp_t                        cfg_rsp_internal

      , output logic                            cfg_req_down_write 
      , output logic                            cfg_req_down_read
      , output cfg_req_t                        cfg_req_down

      , input  logic                            cfg_req_up_write
      , input  logic                            cfg_req_up_read
      , input  cfg_req_t                        cfg_req_up

      , input  logic                            cfg_rsp_up_ack
      , input  cfg_rsp_t                        cfg_rsp_up
);
//--------------------------------------------------------------------------------------------
// Check for invalid parameters at build-time
genvar GEN0 ;
generate
  if ( ~( HQM_MSTR_CFG_NODE_ID <= 15 ) ) begin : invalid_check2
    for ( GEN0 = HQM_MSTR_CFG_NODE_ID ; GEN0 <= HQM_MSTR_CFG_NODE_ID ; GEN0 = GEN0+1 ) begin : invalid_HQM_MSTR_CFG_NODE_ID_WIDTH
      INVALID_PARAM_COMBINATION i_invalid ( .invalid ( ) ) ;
    end
  end
endgenerate

//-------------------------------------------------------------------------------------------------------------
localparam RDATA_WIDTH = $bits(cfg_rsp_up.rdata);
localparam WDATA_WIDTH = $bits(cfg_req_down.wdata);
localparam ADDR_WIDTH  = $bits(cfg_req_down.addr);

logic                       pselenb;
logic                       pabort; 

cfg_user_t                  puser_post; 
cfg_user_t                  puser_f, puser_nxt;
logic                       psel_f, psel_nxt;
logic                       penable_f, penable_nxt;
logic                       pwrite_f, pwrite_nxt;
logic                       pready_f, pready_nxt;
logic                       pabort_f, pabort_nxt;
logic [( 32 )-1:0]          paddr_f, paddr_nxt;
logic [( WDATA_WIDTH )-1:0] pwdata_f, pwdata_nxt;
logic                       pselenb_f, pselenb_nxt;

logic                       apb2cfg_req_write_f, apb2cfg_req_write_nxt;
logic                       apb2cfg_req_read_f, apb2cfg_req_read_nxt;
cfg_req_t                   apb2cfg_req_f, apb2cfg_req_nxt;
cfg_addr_t                  apb2cfg_addr_decode;
logic                       apb2cfg_addr_decode_err ;
logic                       apb2cfg_addr_decode_par_err ;

logic                       cfg_req_down_v_f, cfg_req_down_v_nxt;
logic                       cfg_req_down_start;
logic                       cfg_req_up_write_f, cfg_req_up_read_f;
cfg_req_t                   cfg_req_up_pnc;

logic                       cfg_req_down_write_f, cfg_req_down_write_nxt;
logic                       cfg_req_down_read_f, cfg_req_down_read_nxt;
cfg_req_t                   cfg_req_down_f, cfg_req_down_nxt;
logic                       cfg_req_down_was_read_f, cfg_req_down_was_read_nxt; 
logic                       cfg_req_internal_write_f, cfg_req_internal_write_nxt;
logic                       cfg_req_internal_read_f, cfg_req_internal_read_nxt;
cfg_req_t                   cfg_req_internal_f, cfg_req_internal_nxt;

logic                       cfg_rsp_up_ack_f;
cfg_rsp_t                   cfg_rsp_up_f,cfg_rsp_up_nxt;
logic                       ring_pready, internal_pready; 
logic                       ring_pready_drop, internal_pready_drop;

logic                       err_cfg_protocol_f,err_cfg_protocol_nxt;
logic                       err_pready;
logic                       err_slv_par_f,err_slv_par_nxt;
logic                       err_slv_access_f,err_slv_access_nxt;
logic                       err_slv_timeout_f,err_slv_timeout_nxt;
logic                       err_cfg_decode_f, err_cfg_decode_nxt;
logic                       err_cfg_decode_par_f, err_cfg_decode_par_nxt;
logic                       err_cfg_req_drop_f, err_cfg_req_drop_nxt;
logic                       err_cfg_req_up_miss_f,err_cfg_req_up_miss_nxt;
logic                       err_cfg_rsp_up_ack_unsol_f,err_cfg_rsp_up_ack_unsol_nxt;
logic                       err_cfg_req_up_unsol_f,err_cfg_req_up_unsol_nxt;

logic                       apb2cfg_wdata_par_err;
logic                       apb2cfg_addr_par_err;

logic [(  4 )-1:0]          sys_uid_nxt;
logic [(  4 )-1:0]          sys_uid_f, sys_uid_f_nc;

logic [( RDATA_WIDTH )-1:0] prdata_f, prdata_nxt;
logic                       prdata_par_f, prdata_par_nxt;
logic                       pslverr_f;
logic                       prdata_clr_f;

logic [(HQM_CORE_CFG_TIMEOUT_WIDTH-1):0] downcount_nxt;
logic [(HQM_CORE_CFG_TIMEOUT_WIDTH-1):0] downcount_f;

logic                       cfg_req_internal_v_f, cfg_req_internal_v_nxt;
logic                       cfg_req_internal_start;
logic                       cfg_rsp_internal_ack_f;
cfg_rsp_t                   cfg_rsp_internal_f,cfg_rsp_internal_nxt;

genvar g;
// Assign nc's
assign cfg_req_up_pnc = cfg_req_up ;
assign sys_uid_f_nc = sys_uid_f ; 
//-------------------------------------------------------------------------------------------------------------
// Provide status for cfg master level, top-level idle 
//
assign cfg_req_ring_active = ( cfg_req_down_v_f 
                             | cfg_rsp_up_ack_f
                             ) ;
assign cfg_req_mstr_active = ( pselenb
                             | pselenb_f
                             | apb2cfg_req_write_f 
                             | apb2cfg_req_read_f
                             | cfg_req_internal_v_f
                             | cfg_rsp_internal_ack_f
                             | pready_f
                             ) ;

//-----------------------------------------------------------------------------------------------------------------
// Instances
//.................................................................................................................
// Parity checks for a_par, wd_par (before decode of cfg requests, saves 2 instances)
logic wdata_par_e;
assign wdata_par_e = ( pselenb_f &  pwrite_f ) ;

hqm_AW_parity_check # (
  .WIDTH ( WDATA_WIDTH ) 
) i_hqm_AW_par_check_req_wdata (
  .p     ( puser_f.wd_par )
, .d     ( pwdata_f )
, .e     ( wdata_par_e )
, .odd   ( 1'b1 )
, .err   ( apb2cfg_wdata_par_err )
) ;

hqm_AW_parity_check # (
  .WIDTH ( $bits(paddr_f) )
) i_hqm_AW_par_check_req_addr (
  .p     ( puser_f.a_par )
, .d     ( paddr_f )
, .e     ( pselenb_f )
, .odd   ( 1'b1 )
, .err   ( apb2cfg_addr_par_err )
) ;


//----------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------
// Register the APB interface
// Detect psel & penable to enable flopping the interface
// Detect if the psel drops w/o a prior pready (abort indication). 
//
always_comb begin

  pselenb = (psel & penable) & (~penable_f);
  pabort  = ~psel & psel_f & ~pready_f;

  // Override bits that are only assigned/used within the CFG path
  puser_post                           = puser ;
  puser_post.a_par                     = ~puser.a_par ;    // IOSF ocnvention is EVEN Parity, HQM Proc convention is ODD Parity
  puser_post.wd_par                    = ~puser.wd_par ;   // Invert these bits before any checking is performed
  puser_post.addr_decode_par_err       = 1'b0 ; 
  puser_post.disable_ring_parity_check = 1'b0 ; 
  puser_post.addr_decode_err           = 1'b0 ; 

  psel_nxt     = psel ;
  penable_nxt  = penable ;
  pselenb_nxt  = pselenb ; 
  pwrite_nxt   = (pselenb) ? pwrite : pwrite_f ;
  pabort_nxt   = (pabort_f | pabort) & ~pselenb ;
  paddr_nxt    = (pselenb) ? paddr : paddr_f ;
  puser_nxt    = (pselenb) ? puser_post : puser_f ;
  pwdata_nxt   = (pselenb & pwrite) ? pwdata  : pwdata_f ;

  pready_nxt   = (ring_pready | internal_pready | err_timeout) ;
end

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b_sync) begin
  if (~prim_gated_rst_b_sync) begin
    psel_f      <= 1'b0 ;
    pwrite_f    <= 1'b0 ;
    pabort_f    <= 1'b0 ;
    penable_f   <= 1'b0 ;
    pselenb_f   <= 1'b0 ;

    pready_f    <= 1'b0 ;
    paddr_f     <= '0 ;
    puser_f     <= '0 ;
    pwdata_f    <= '0 ;
  end else begin
    psel_f      <= psel_nxt ;
    pabort_f    <= pabort_nxt ;
    penable_f   <= penable_nxt ;
    pselenb_f   <= pselenb_nxt ;
    pwrite_f    <= pwrite_nxt ;

    pready_f    <= pready_nxt ;
    paddr_f     <= paddr_nxt;
    puser_f     <= puser_nxt;
    pwdata_f    <= pwdata_nxt;
  end 
end

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
// APB Address Decoding
// APB->CFG request conversion
// Use flopped pselenb to align with pwrite_f level of flops, otherwise cfg req will assert early
//
always_comb begin 


  // APB to CFG conversion
  // user.a_par (address parity) will be overwritten, when it is modified to subtract out unused/redundant1 bits
  apb2cfg_req_write_nxt                          = ( pselenb_f &  pwrite_f ) ;
  apb2cfg_req_read_nxt                           = ( pselenb_f & ~pwrite_f ) ;
  apb2cfg_req_nxt.cfg_ignore_pipe_busy           = cfg_ignore_pipe_busy ;
  apb2cfg_req_nxt.user                           = puser_f ;
  apb2cfg_req_nxt.user.disable_ring_parity_check = cfg_disable_ring_par_ck ;

  // Maintaining two copies of parity bits from this point downstream due to legacy code
  // User field parity is used to send parity info from IOSF to Master
  // Non-User field parity bits are used by the cfg_ring to check parity before pulling from ring
  apb2cfg_req_nxt.addr_par                       = puser_f.a_par ;

  if ( pwrite_f ) begin
    apb2cfg_req_nxt.wdata                        = pwdata_f ;
    apb2cfg_req_nxt.wdata_par                    = puser_f.wd_par ;
  end else begin
    apb2cfg_req_nxt.wdata                        = '0 ;
    apb2cfg_req_nxt.wdata_par                    = 1'b1 ;
  end  

  // Do address decode for internal request and decode for Broadcast registers 
  // All bits [25:2] must be accounted for in the decode modes. Unused bits are checked and flagged via decode_err
  // decode_err will cause the request to be dropped form the ring and immediatley acked.
  // addr and wdata (conditoned by write) parity errors also use this dropping/acking mechanism
  apb2cfg_addr_decode_err       = 1'b0;
  apb2cfg_addr_decode.node      = enum_cfg_node_id_t'(paddr_f[31:28]);
  apb2cfg_addr_decode.mode      = enum_cfg_mode_t'(2'd0) ;
  apb2cfg_addr_decode.offset    = '0 ;
  apb2cfg_addr_decode.target    = '0 ;
  apb2cfg_addr_decode_par_err   = ( apb2cfg_wdata_par_err | apb2cfg_addr_par_err ) ;

  if (paddr_f[26] == 1'b0) begin
    // MODE 0 - VIRTUAL
    apb2cfg_addr_decode.mode    = enum_cfg_mode_t'({paddr_f[26],1'b0});
    apb2cfg_addr_decode.target  = {paddr_f[27],paddr_f[26],paddr_f[25:19],7'd0};
    apb2cfg_addr_decode.offset  = {9'd0,paddr_f[18:12]};
    apb2cfg_addr_decode_err     = (|paddr_f[11:2]) ;
    
    apb2cfg_req_nxt.addr_par    = puser_f.a_par ^ (^paddr_f[11:2]) ; // Not fully decoded, subtract [11:02] from parity
    apb2cfg_req_nxt.user.a_par  = puser_f.a_par ^ (^paddr_f[11:2]) ; // [26] = 1'b0, so duplication requires no modification
  end else
  if (paddr_f[26:25] == 2'b10) begin
    // MODE 2 - REGISTER
    apb2cfg_addr_decode.mode    = enum_cfg_mode_t'({paddr_f[26:25]});
    apb2cfg_addr_decode.target  = {paddr_f[27],paddr_f[26:25],paddr_f[14:02]};
    apb2cfg_addr_decode.offset  = {16'b0};  // NA
    apb2cfg_addr_decode_err     = (|paddr_f[24:15]) ; 

    apb2cfg_req_nxt.addr_par    = puser_f.a_par ^ (^{paddr_f[24:15],paddr_f[26]}) ;  // Not fully decoded, subtract [24:15] from parity 
    apb2cfg_req_nxt.user.a_par  = puser_f.a_par ^ (^{paddr_f[24:15],paddr_f[26]}) ;  // [26:25] = 2'b10, so duplicating bit 26 requires subtraction from parity
  end else 
  if (paddr_f[26:25] == 2'b11) begin
    // MODE 3 - MEMORY
    apb2cfg_addr_decode.mode    = enum_cfg_mode_t'({paddr_f[26:25]});
    apb2cfg_addr_decode.target  = {paddr_f[27],paddr_f[26:25],paddr_f[24:16],4'd0};
    apb2cfg_addr_decode.offset  = {2'd0, paddr_f[15:02]};
    apb2cfg_addr_decode_err     = '0 ;

    apb2cfg_req_nxt.addr_par    = puser_f.a_par ;  // Fully decoded, no bits to subtract from parity
    apb2cfg_req_nxt.user.a_par  = puser_f.a_par ;  // [26:25] == 2'b11, so no change by duplicating 
  end

  apb2cfg_req_nxt.user.addr_decode_err           = apb2cfg_addr_decode_err ;
  apb2cfg_req_nxt.user.addr_decode_par_err       = apb2cfg_addr_decode_par_err ;
  apb2cfg_req_nxt.addr                           = apb2cfg_addr_decode ;

end

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b_sync) begin
  if (~prim_gated_rst_b_sync) begin     
    apb2cfg_req_write_f         <= '0 ;
    apb2cfg_req_read_f          <= '0 ;
    apb2cfg_req_f               <= '0 ;
  end else begin         
    apb2cfg_req_write_f         <= apb2cfg_req_write_nxt ;
    apb2cfg_req_read_f          <= apb2cfg_req_read_nxt ;
    apb2cfg_req_f               <= apb2cfg_req_nxt ;
  end
end

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
// Drive Internal Logic or Downstream Logic
// Bcast addresses have internal master addresses, but are not considered internal requests
// They will be sent to the ring as if they were an external node.
// 
// Pabort and Timeouts clear the req_v state.
// The ring_pready and internal_pready do as well. 
//
always_comb begin

  cfg_req_internal_write_nxt           = 1'b0;
  cfg_req_internal_read_nxt            = 1'b0;
  cfg_req_internal_nxt                 = '0 ;
  cfg_req_down_write_nxt               = 1'b0;
  cfg_req_down_read_nxt                = 1'b0;
  cfg_req_down_nxt                     = '0 ;

  cfg_req_internal_start               = 1'b0 ;
  cfg_req_down_start                   = 1'b0 ;

  cfg_req_internal_v_nxt               = cfg_req_internal_v_f ;
  cfg_req_down_v_nxt                   = cfg_req_down_v_f ;

  // Req Flop holds its value, Write and Read Flops are Pulses
  if ( (apb2cfg_req_f.addr.node == HQM_MSTR_CFG_NODE_ID) ) begin
    cfg_req_internal_write_nxt       = apb2cfg_req_write_f ; 
    cfg_req_internal_read_nxt        = apb2cfg_req_read_f ;
    cfg_req_internal_nxt             = apb2cfg_req_f ;
     
    cfg_req_internal_start           = ( (apb2cfg_req_write_f | apb2cfg_req_read_f)      & ~(pabort) ) ;
    cfg_req_internal_v_nxt           = ( cfg_req_internal_start | ( cfg_req_internal_v_f & ~(pabort | internal_pready | err_timeout) ) ) ;
  end else begin
    cfg_req_down_write_nxt           = apb2cfg_req_write_f ;
    cfg_req_down_read_nxt            = apb2cfg_req_read_f ;
    cfg_req_down_nxt                 = apb2cfg_req_f ;
    cfg_req_down_nxt.addr_par        = (inj_par_err_addr)  ? ~apb2cfg_req_f.addr_par  : apb2cfg_req_f.addr_par ;

    if (apb2cfg_req_write_f) begin
    cfg_req_down_nxt.wdata_par       = (inj_par_err_wdata) ? ~apb2cfg_req_f.wdata_par : apb2cfg_req_f.wdata_par ;
    end

    cfg_req_down_start               = ( (apb2cfg_req_write_f | apb2cfg_req_read_f) & ~(pabort) ) ;
    cfg_req_down_v_nxt               = ( cfg_req_down_start   | ( cfg_req_down_v_f  & ~(pabort | ring_pready | err_timeout) ) ) ;   
  end

    // Clear out parity error injection when req goes out, after parity bit has been flipped. 
    inj_par_err_req_clr              = (inj_par_err_wdata | inj_par_err_addr)  & (cfg_req_down_write_f | cfg_req_down_read_f) ;

    // Track that external request was a config read
    cfg_req_down_was_read_nxt        = ((cfg_req_down_read_f | cfg_req_down_was_read_f) & ~ring_pready) ;

end

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b_sync) begin
  if (~prim_gated_rst_b_sync) begin
    cfg_req_internal_write_f           <= '0 ;
    cfg_req_internal_read_f            <= '0 ;
    cfg_req_internal_f                 <= '0 ;
    cfg_req_down_write_f               <= '0 ;
    cfg_req_down_read_f                <= '0 ;
    cfg_req_down_f                     <= '0 ;

    cfg_req_internal_v_f               <= '0 ; 
    cfg_req_down_v_f                   <= '0 ;

    cfg_req_down_was_read_f            <= '0 ;
  end else begin
    cfg_req_internal_write_f           <= cfg_req_internal_write_nxt ;
    cfg_req_internal_read_f            <= cfg_req_internal_read_nxt ;
    cfg_req_internal_f                 <= cfg_req_internal_nxt ;
    cfg_req_down_write_f               <= cfg_req_down_write_nxt ;
    cfg_req_down_read_f                <= cfg_req_down_read_nxt ;
    cfg_req_down_f                     <= cfg_req_down_nxt ;

    cfg_req_internal_v_f               <= cfg_req_internal_v_nxt ;
    cfg_req_down_v_f                   <= cfg_req_down_v_nxt ;

    cfg_req_down_was_read_f            <= cfg_req_down_was_read_nxt ;
  end
end

//-------------------------------------------------------------------------------------------------------------
// ALLOW, or DROP, CFG Ring Requests
// Address Decode Errors are dropped here for simplicity (only support one drop point)
// Both Internal Master Requests and Extarnal Ring Requests can be dropped due to address decode errors
//
always_comb begin

  //...........................................................................................................
  // CFG Ring Access
  ring_pready_drop         = '0 ;        

  if ( (~pm_fsm_in_run) | (hqm_flr_prep | ~core_reset_done) | cfg_req_down_f.user.addr_decode_err | cfg_req_down_f.user.addr_decode_par_err ) begin
    
    // CFG Ring Drop 
    cfg_req_down_write     = '0 ;
    cfg_req_down_read      = '0 ;
    cfg_req_down           = '0 ;

    ring_pready_drop       = ( cfg_req_down_write_f | cfg_req_down_read_f ) ;
  end else begin
    
    // Allow
    cfg_req_down_write     = cfg_req_down_write_f ;
    cfg_req_down_read      = cfg_req_down_read_f ;
    cfg_req_down           = cfg_req_down_f ;
  end

  //...........................................................................................................
  // Master Access
  internal_pready_drop     = '0 ;
  
  if ( cfg_req_internal_f.user.addr_decode_err | cfg_req_internal_f.user.addr_decode_par_err ) begin

    cfg_req_internal_write = '0 ;
    cfg_req_internal_read  = '0 ;
    cfg_req_internal       = '0 ;

    
internal_pready_drop   = ( cfg_req_internal_write_f | cfg_req_internal_read_f ) ;
  end else begin

    cfg_req_internal_write = cfg_req_internal_write_f ;
    cfg_req_internal_read  = cfg_req_internal_read_f ;
    cfg_req_internal       = cfg_req_internal_f ;
  end

end

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
// Handle CFG->SYS Request Return and Internal Responses
//
always_comb begin 
  cfg_rsp_internal_nxt              = '0 ;
  cfg_rsp_internal_nxt.rdata_par    = 1'b1 ;
  cfg_rsp_up_nxt                    = '0 ; 
  cfg_rsp_up_nxt.rdata_par          = 1'b1 ; 
  inj_par_err_rsp_clr               = 1'b0 ;

  if (cfg_rsp_internal_ack) begin
    cfg_rsp_internal_nxt            = cfg_rsp_internal ;
  end
  if (cfg_rsp_up_ack) begin
    cfg_rsp_up_nxt                  = cfg_rsp_up ;
    
    // Parity injection
    if ( inj_par_err_rdata & cfg_req_down_was_read_f )  begin
      cfg_rsp_up_nxt.rdata[0]       = ~cfg_rsp_up.rdata[0] ;
      inj_par_err_rsp_clr           = 1'b1 ; 
    end
  end
end

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b_sync) begin
  if (~prim_gated_rst_b_sync) begin
    cfg_req_up_write_f              <= 1'b0;
    cfg_req_up_read_f               <= 1'b0;
    cfg_rsp_up_ack_f                <= 1'b0;
    cfg_rsp_internal_ack_f          <= 1'b0;
    cfg_rsp_internal_f              <= 39'h10_0000_0000;
    cfg_rsp_up_f                    <= 39'h10_0000_0000;
  end else begin
    cfg_req_up_write_f              <= cfg_req_up_write;
    cfg_req_up_read_f               <= cfg_req_up_read;
    cfg_rsp_up_ack_f                <= cfg_rsp_up_ack;
    cfg_rsp_internal_ack_f          <= cfg_rsp_internal_ack;
    cfg_rsp_internal_f              <= cfg_rsp_internal_nxt;
    cfg_rsp_up_f                    <= cfg_rsp_up_nxt;
  end  
end

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
// Handle the Core->APB response
//
// External reads and writes wait for the ack to come back from the cfg logic, which is assumed to be
// a single cfg clock cycle pulse that can come back at any time, so we need to grab and flop it and
// the error and rdata associated with it.  
//
always_comb begin
  
  err_slv_access_nxt        = '0;
  err_slv_par_nxt           = '0;
  prdata_nxt                = '0;
  prdata_par_nxt            = 1'b0;   // IOSF convention is EVEN parity
  sys_uid_nxt               = '0;
 
  if (cfg_rsp_internal_ack_f & cfg_req_internal_v_f) begin
    err_slv_access_nxt      = (cfg_rsp_internal_f.err & ~cfg_rsp_internal_f.err_slv_par);
    err_slv_par_nxt         = (cfg_rsp_internal_f.err &  cfg_rsp_internal_f.err_slv_par);
    prdata_nxt              = cfg_rsp_internal_f.rdata;
    prdata_par_nxt          = ~cfg_rsp_internal_f.rdata_par;   
    sys_uid_nxt             = cfg_rsp_internal_f.uid;
  end
  if (cfg_rsp_up_ack_f & cfg_req_down_v_f) begin
    err_slv_access_nxt      = (cfg_rsp_up_f.err & ~cfg_rsp_up_f.err_slv_par);
    err_slv_par_nxt         = (cfg_rsp_up_f.err &  cfg_rsp_up_f.err_slv_par);
    prdata_nxt              = cfg_rsp_up_f.rdata;
    prdata_par_nxt          = ~cfg_rsp_up_f.rdata_par;
    sys_uid_nxt             = cfg_rsp_up_f.uid;
  end

end

assign err_slv_timeout_nxt   = (cfg_rsp_internal_ack_f & (cfg_rsp_internal_f.rdata == 32'haaaabeef) & cfg_rsp_internal_f.err) | (cfg_rsp_up_ack_f & (cfg_rsp_up_f.rdata == 32'haaaabeef) & cfg_rsp_up_f.err); 

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b_sync) begin
  if ( ~prim_gated_rst_b_sync ) begin 
    err_slv_access_f        <= 1'b0;
    err_slv_timeout_f       <= 1'b0;
    err_slv_par_f           <= 1'b0;
    prdata_f                <= '0;
    prdata_par_f            <= 1'b0;  // IOSF convention is EVEN parity
    sys_uid_f               <= '0;
  end else begin   
    err_slv_access_f        <= err_slv_access_nxt;
    err_slv_timeout_f       <= err_slv_timeout_nxt;
    err_slv_par_f           <= err_slv_par_nxt;
    prdata_f                <= prdata_nxt;
    prdata_par_f            <= prdata_par_nxt;
    sys_uid_f               <= sys_uid_nxt;
  end
end

//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
// Error Aggregation and Pready 
// Errors are reported via pslverr to system, and are logged in Master Syndrome Register / Sticky Register
//
// Create an error-induced pready for valid reqs that miss.
// Decode Errors and parity errors are included in the pready_drop signals
// Do not include unsolicited responses/requests from ring.
// Timeout Error is dependent upon receiving the pready. Must split it out from the miss to avoid logic loop
assign err_pready           = ( err_cfg_req_up_miss_f );

// Indicate decode stage error dur to wdata/addr parity
assign err_cfg_decode_par_nxt       = ( ((cfg_req_down_write_f     | cfg_req_down_read_f    ) & cfg_req_down_f.user.addr_decode_par_err )
                                      | ((cfg_req_internal_write_f | cfg_req_internal_read_f) & cfg_req_internal_f.user.addr_decode_par_err)
                                      ) ;
// Indicate decode stage error due to invalid bits
assign err_cfg_decode_nxt           = ( ((cfg_req_down_write_f     | cfg_req_down_read_f    ) & cfg_req_down_f.user.addr_decode_err)
                                      | ((cfg_req_internal_write_f | cfg_req_internal_read_f) & cfg_req_internal_f.user.addr_decode_err)
                                      ) ;
// Indicate non-parity error drop for requests to ring (Sticky bit)
assign err_cfg_req_drop_nxt         = ( ring_pready_drop & ~cfg_req_down_f.user.addr_decode_err & ~cfg_req_down_f.user.addr_decode_par_err) ;
assign err_cfg_req_up_miss_nxt      = (  cfg_req_down_v_f & (cfg_req_up_write_f | cfg_req_up_read_f) ) ;
assign err_cfg_req_up_unsol_nxt     = ( ~cfg_req_down_v_f & (cfg_req_up_write_f | cfg_req_up_read_f) ) ;
assign err_cfg_rsp_up_ack_unsol_nxt = ( ~cfg_req_down_v_f & cfg_rsp_up_ack_f ) ; 
assign err_cfg_protocol_nxt         = ( pselenb & pselenb_f ) ;

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b_sync) begin
  if (~prim_gated_rst_b_sync) begin
    err_cfg_req_up_miss_f      <= 1'b0;
    err_cfg_req_up_unsol_f     <= 1'b0;
    err_cfg_rsp_up_ack_unsol_f <= 1'b0;
    err_cfg_protocol_f         <= 1'b0;
    err_cfg_decode_f           <= 1'b0;
    err_cfg_decode_par_f       <= 1'b0;
    err_cfg_req_drop_f         <= 1'b0;
 
    prdata_clr_f               <= 1'b0;
    pslverr_f                  <= 1'b0;
  end else begin
    err_cfg_req_up_miss_f      <= err_cfg_req_up_miss_nxt;
    err_cfg_req_up_unsol_f     <= err_cfg_req_up_unsol_nxt;
    err_cfg_rsp_up_ack_unsol_f <= err_cfg_rsp_up_ack_unsol_nxt;
    err_cfg_protocol_f         <= err_cfg_protocol_nxt;
    err_cfg_decode_f           <= err_cfg_decode_nxt;
    err_cfg_decode_par_f       <= err_cfg_decode_par_nxt;
    err_cfg_req_drop_f         <= err_cfg_req_drop_nxt;

    prdata_clr_f               <= ( err_slv_access_nxt | err_slv_timeout_nxt ) ; // ALWAYS Clear prdata for errors where the slave (cfg_sc) puts an error code in the rdata.
    pslverr_f                  <= ( err_slv_par_nxt | err_cfg_decode_par_nxt | ((err_timeout | err_slv_timeout_nxt) & ~cfg_disable_pslverr_timeout) );
  end
end

assign err_cfg_protocol        = err_cfg_protocol_f ;          // Request from system recvd while prev req in progress
assign err_cfg_req_up_miss     = err_cfg_req_up_miss_f ;       // Request to ring missed and came back to master
assign err_slv_access          = err_slv_access_f ;            // Slv reported access err (Non-parity Err)
assign err_slv_timeout         = err_slv_timeout_f ;           // Slv reported timeout err  via rdata code(Non-parity Err)
assign err_slv_par             = err_slv_par_f ;               // Slv reported parity err (ADDR or WDATA)
assign err_cfg_decode          = err_cfg_decode_f ;            // Mstr reported decode err on paddr, no req sent to ring/internal, acked via drop mechanism 
assign err_cfg_decode_par      = err_cfg_decode_par_f ;        // Mstr reported decode err on paddr/wdata, no req sent to ring/internal, acked via drop mechanism 
assign err_cfg_req_drop        = err_cfg_req_drop_f ;          // Mstr reported drop of req sent to ring (silently acked)
assign err_cfg_reqrsp_unsol    = (err_cfg_rsp_up_ack_unsol_f   // Unsolicted Request or Response 
                                 |err_cfg_req_up_unsol_f) ;
// pready indications
assign ring_pready             = ( ( cfg_req_down_v_f     & cfg_rsp_up_ack_f )       | err_pready | ring_pready_drop ) ;
assign internal_pready         = ( ( cfg_req_internal_v_f & cfg_rsp_internal_ack_f ) | err_pready | internal_pready_drop ) ;

// Drive the SYS response outputs
assign pready                  = (pready_f &  ~pabort_f) ;
assign prdata                  = (pready_f &  ~pabort_f & ~prdata_clr_f) ? prdata_f     : 32'd0; 
assign prdata_par              = (pready_f &  ~pabort_f & ~prdata_clr_f) ? prdata_par_f : 1'b0;  
assign pslverr                 = (pready_f &  ~pabort_f)                 ? pslverr_f    : 1'b0; 

//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
// Timeout Logic for requests
// Counter Loads TIMEOUTVALUE -1 when a request goes out onto the ring
// Counter counts down while the request is active (cfg_req_down_v_f)
// Counter Stops when a flopped response ack is set 
// Timeout interrupt is generated on the clock after the flopped count is 0 (and no response has been received)  
//
always_comb begin

  // Default is HOLD
  downcount_nxt   = downcount_f ;
  err_timeout     = 1'b0 ; 

  // START
  if ( (cfg_req_down_write | cfg_req_down_read | cfg_req_internal_write | cfg_req_internal_read) ) begin 
    downcount_nxt = (HQM_CORE_CFG_TIMEOUT_VALUE[HQM_CORE_CFG_TIMEOUT_WIDTH-1:0] - {{(HQM_CORE_CFG_TIMEOUT_WIDTH-1){1'b0}},1'b1}) ;
  end else

  // STOP
  if ( (ring_pready | internal_pready | pabort) ) begin
    downcount_nxt = downcount_f ;
  end else

  // ALARM 
  if ( ((cfg_req_down_v_f | cfg_req_internal_v_f) & ~(|downcount_f)) ) begin
    downcount_nxt = (HQM_CORE_CFG_TIMEOUT_VALUE[HQM_CORE_CFG_TIMEOUT_WIDTH-1:0] - {{(HQM_CORE_CFG_TIMEOUT_WIDTH-1){1'b0}},1'b1}) ;

    err_timeout   = 1'b1 ;
  end else

  //COUNT
  if ( (cfg_req_down_v_f | cfg_req_internal_v_f) ) begin  
    downcount_nxt = (downcount_f - {{(HQM_CORE_CFG_TIMEOUT_WIDTH-1){1'b0}},1'b1})  ;
  end 

end

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b_sync) begin
  if (~prim_gated_rst_b_sync) begin
    downcount_f   <= (HQM_CORE_CFG_TIMEOUT_VALUE[HQM_CORE_CFG_TIMEOUT_WIDTH-1:0] - {{(HQM_CORE_CFG_TIMEOUT_WIDTH-1){1'b0}},1'b1}) ;
  end else begin
    downcount_f   <= downcount_nxt;
  end
end

endmodule // hqm_cfg_master_sys2cfg


