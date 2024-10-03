//=============================================================================
//  Copyright 2020 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY
//  COPYRIGHT LAWS AND IS CONSIDERED A TRADE SECRET BELONGING
//  TO THE INTEL CORPORATION.
//
//  Intel Confidential
//=============================================================================
//
// MOAD Begin
//     File/Block                             : sbendpoint_master.sv
//     Design Style [rls|rf|ssa_fuse|sdp|
//                   custom|hier|rls_hier]    : rls
//     Circuit Style [non_rfs|rfs|ssa|fuse|
//                    IO|ROM|none]            : none
//     Common_lib (for custom blocks only)    : none
//     Library (must be same as module name)  : sbendpoint_master
//     Unit [unit id or shared]               : shared
//     Complex [North, South, CPU]            : North
//     Bizgroup [LCP|SEG|ULMD]                : ULMD
//
// Design Unit Owner : priyanka.agrawal@intel.com
// Primary Contact   : priyanka.agrawal@intel.com
//
// MOAD End
//
//=============================================================================
//
//=============================================================================
//
// Description:
//   master block which handles all outmsg posted/non posted request completion 
//   generation is handled in target block    
//
//   05102013: Heavily modified to by Justin Diether (justin.b.diether@intel.com) 
//   to support Multi Message w Data upto 16 dwords. Revamped the counter based 
//   design to actually use enumerated states.
//
//   09192013: Updated the state machines to make them more consistent and 
//   correct.
//
//=============================================================================

`include "hqm_system_def.vh"

module hqm_sb_mstr

  import hqm_sif_pkg::*, hqm_system_type_pkg::*;
#(
  parameter NUM_TX_EHDRS           = 0

)(
  // Clock/Reset Signals
  input  logic                     clk                                                    , 
  input  logic                     rst_b                                                  , 

  // Interface to the clock gating ISM
  output logic                     mst_idle                                               , 

  // Interface to the master side of the base endpoint (sbebase)
  input  logic                     sbe_mst_mmsg_nptrdy                                    , 
  //put  logic                     sbe_mst_mmsg_npmsgip                                   ,
  input  logic                     sbe_mst_mmsg_npsel                                     , 
  output logic                     mst_sbe_mmsg_npirdy                                    , 
  output logic                     mst_sbe_mmsg_npeom                                     , 
  output logic [31:0]              mst_sbe_mmsg_nppayload                                 , 
  input  logic                     sbe_mst_mmsg_pctrdy                                    , 
  //put  logic                     sbe_mst_mmsg_pcmsgip                                   ,  
  input  logic                     sbe_mst_mmsg_pcsel                                     , 
  output logic                     mst_sbe_mmsg_pcirdy                                    , 
  output logic                     mst_sbe_mmsg_pceom                                     , 
  output logic [31:0]              mst_sbe_mmsg_pcpayload                                 , 

  // Constants for forming messages
  input  logic [15:0]              strap_hqm_gpsb_srcid                                   ,   
  input  logic                     strap_hqm_16b_portids                                  ,

  // Master Interface  - To/From the IP block:
  input  hqm_ep_sb_msg_t           ip_mst_msg                                             , // Msg from IP    
  output logic                     mst_ip_msg_trdy                                        , // Msg has been accepted 

  // Debug
  output logic [14:0]              mst_dbgbus                                    
);

  `include "hqm_sbcglobal_params.vm"
  `include "hqm_sbcfunc.vm"

  // 48 is used through if selected only 16 bits is sent
  localparam MAXADDR               = 47                                                   ; 
  localparam MAXDATA               = 31                                                   ; 
  localparam MAXBE                 = 7                                                    ; 
  localparam NUM_TX_EHDRS_L2       = sbc_logb2(NUM_TX_EHDRS)                              ; 

  // Make seperate Msg for Posted and Non Posted
  hqm_ep_sb_msg_t                  ipnpmsg                                                ; // Non Posted Msg from IP    
  logic                            ipnpmsg_trdy                                           ; // Msg has been accepted 
  hqm_ep_sb_msg_t                  ippmsg                                                 ; 
                                                                                            //  Fields of this structure are not consumed. Its an inherent 
                                                                                            //  disavantage of structures, still a new is not made just for
                                                                                            //  thise case. Its not functional problem.                    
                                                                                            // Posted Msg from IP    
  logic                            ippmsg_trdy                                            ; // Msg has been accepted 

  // need to send a small number of requests over the np/p channel
  // message/nodata - (80 to ff)
  // message/data   - (40 to 7f)
  // register read  - (00 to 1f, bit 0 clear)
  // register write - (00 to 1f, bit 1 set)
  logic                            np_is_message_nodata                                   ; 
  logic                            np_is_message_data                                     ; 
  logic                            np_is_reg_read                                         ; 
  logic                            np_is_reg_write                                        ; 
  logic                            p_is_message_nodata                                    ; 
  logic                            p_is_message_data                                      ; 
  logic                            p_is_reg_read                                          ; 
  logic                            p_is_reg_write                                         ; 

  logic                            np_alen                                                ; // Address length
  logic                            p_alen                                                 ; // Address length
  logic                            np_eh                                                  ; // Use EH
  logic                            p_eh                                                   ; // Use EH

  // State machine
  //     SB_STD_HDR    - {TX_EHDR_USE, addrlen, bar, tag, opcode, source, dest}
  //     SB_EXT_HDR    - {ext_hdr[ext_hdr_cnt] }
  //     SB_ADDR       - {faddr[15:0], fid, sbefbe} 
  //     SB_ADDR2      - {faddr[47:16]} 
  //     SB_DATA_MULTI - {fdata[31:0] of DW(I)} where I is 1 to 16 depending on MSG type

  localparam SB_IDLE_BIT       = 0;
  localparam SB_STD_HDR_BIT    = 1;
  localparam SB_EXT_HDR_BIT    = 2;
  localparam SB_ADDR_BIT       = 3;
  localparam SB_ADDR2_BIT      = 4;
  localparam SB_DATA_MULTI_BIT = 5;

  typedef enum logic [5:0] {
    SB_IDLE                        = 6'b000001,
    SB_STD_HDR                     = 6'b000010,
    SB_EXT_HDR                     = 6'b000100,
    SB_ADDR                        = 6'b001000,                                 
    SB_ADDR2                       = 6'b010000,                                 
    SB_DATA_MULTI                  = 6'b100000
    } hqm_mstr_fsm_t                                                                      ;

  hqm_mstr_fsm_t                   np_fsm_ps                                              ; // Non-posted Present State 
  hqm_mstr_fsm_t                   np_fsm_ns                                              ; // Non-posted Next State
  hqm_mstr_fsm_t                   p_fsm_ps                                               ; // Posted Present State 
  hqm_mstr_fsm_t                   p_fsm_ns                                               ; // Posted Next State
  logic                            np_update_state_en                                     ; // Advance the state machine
  logic                            p_update_state_en                                      ; // Advance the state machine
  logic                            np_fsm_sent_port_msbs_ps                               ;
  logic                            np_fsm_sent_port_msbs_ns                               ;
  logic                            p_fsm_sent_port_msbs_ps                                ;
  logic                            p_fsm_sent_port_msbs_ns                                ;

  logic                            ippmsg_pmsgip                                          ; // Posted     is in progress
  logic                            ipnpmsg_nmsgip                                         ; // Non-Posted is in progress
  logic                            ipnpmsg_np                                             ; // Non-Posted 
  logic                            final_ptrdy                                            ; 
  logic                            final_nptrdy                                           ; 
  logic [NUM_TX_EHDRS_L2:0]        p_eh_cnt                                               ; 
  logic [NUM_TX_EHDRS_L2:0]        np_eh_cnt                                              ; 
  logic [NUM_TX_EHDRS_L2:0]        p_eh_cnt_nxt                                           ; 
  logic [NUM_TX_EHDRS_L2:0]        np_eh_cnt_nxt                                          ; 

  assign ippmsg                    = (~ip_mst_msg.np) ? ip_mst_msg : '0                   ;
  assign ipnpmsg                   = ( ip_mst_msg.np) ? ip_mst_msg : '0                   ;
  assign mst_ip_msg_trdy           = ippmsg_trdy | ipnpmsg_trdy                           ;

  assign np_alen                   = ipnpmsg.alen                                         ; 
  assign p_alen                    = ippmsg.alen                                          ; 
  assign np_eh                     = ipnpmsg.eh                                           ; 
  assign p_eh                      = ippmsg.eh                                            ; 

  assign np_is_message_nodata      = (ipnpmsg.op >= HQMEPSB_OP_SMSG_START)                ; 
  assign np_is_message_data        = (ipnpmsg.op >= HQMEPSB_OP_MSGD_START) & 
                                     (ipnpmsg.op <  HQMEPSB_OP_MSGD_END)                  ;
  assign np_is_reg_read            = (ipnpmsg.op <  HQMEPSB_OP_REGA_END) & ~ipnpmsg.op[0] ; 
  assign np_is_reg_write           = (ipnpmsg.op <  HQMEPSB_OP_REGA_END) &  ipnpmsg.op[0] ; 
  assign p_is_message_nodata       = (ippmsg.op  >= HQMEPSB_OP_SMSG_START)                ; 
  assign p_is_message_data         = (ippmsg.op  >= HQMEPSB_OP_COMU_START) &                
                                     (ippmsg.op  <  HQMEPSB_OP_MSGD_END)                  ;
  assign p_is_reg_read             = (ippmsg.op  <  HQMEPSB_OP_REGA_END) & ~ippmsg.op[0]  ; 
  assign p_is_reg_write            = (ippmsg.op  <  HQMEPSB_OP_REGA_END) &  ippmsg.op[0]  ; 

  // This function muxes the data from the master interface to the egress interface.  

  function automatic logic [31:0] datamux ( 
    logic [5:0]                    fsm_ps                                                 , // Transfer Present State
    logic                          fsm_sent_port_msbs                                     ,
    logic [15:0]                   dest                                                   , // Destination port ID
    logic [15:0]                   source                                                 , // Source port ID
    logic [7:0]                    opcode                                                 , // There rest of the
    logic                          addrlen                                                , // fields are directly
    logic [2:0]                    bar                                                    , // from the IOSF spec.
    logic [2:0]                    tag                                                    ,
    logic [MAXBE:0]                be                                                     ,
    logic [7:0]                    fid                                                    ,
    logic [MAXADDR:0]              addr                                                   ,
    logic [31:0]                   data                                                   ,
    logic                          eh                                                     , 
    logic [NUM_TX_EHDRS:0][31:0]   ext_hdr                                                , 
    logic [NUM_TX_EHDRS_L2:0]      ext_hdr_cnt                                            ,
    logic                          message_nodata                                         ,
    logic                          message_data                            
    )                                                                                     ;
    logic [47:0]                   faddr                                                  ; 
    logic [MAXDATA:0]              fdata                                                  ; 
    logic [7:0]                    sbefbe                                                 ; 

    begin
      faddr                        = '0                                                   ; 
      fdata                        = '0                                                   ; 
      sbefbe                       = '0                                                   ;
      faddr[MAXADDR:0]             = addr                                                 ;
      fdata[MAXDATA:0]             = data                                                 ;
      sbefbe[MAXBE:0]              = be                                                   ;

      unique casez (1'b1)
        
        // First transfer:  Standard 4 byte message header

        fsm_ps[SB_STD_HDR_BIT]: begin

                    if (strap_hqm_16b_portids & ~fsm_sent_port_msbs) begin

                        datamux    = {16'd0,
                                      source[15:8],
                                      dest[15:8]}                                         ;

                    end else begin

                        datamux    = {eh, 
                                      ((message_data | message_nodata) ? 1'b0 : addrlen), 
                                      ((message_data | message_nodata) ? 3'b000 : bar), 
                                      tag, 
                                      opcode, 
                                      source[7:0],
                                      dest[7:0]}                                          ;
                    end
        end
        
        // Second transfer: extended headers, if present.

        fsm_ps[SB_EXT_HDR_BIT]: begin

                        datamux    = ext_hdr[ext_hdr_cnt]                                 ; 
        end

        // Third  transfer: Lower 16 bits of address, routing ID and byte enables

        fsm_ps[SB_ADDR_BIT]: begin

                        datamux    = { faddr[15:0], fid, sbefbe }                         ; 
        end
        
        // Fourth transfer: will have Upper order address bits if reg rd/wr 

        fsm_ps[SB_ADDR2_BIT]: begin

                        datamux    = faddr[47:16]                                         ;
        end
        
        // Multi cycle Transfer added to stream data for upto 16 DW Data with Message

        fsm_ps[SB_DATA_MULTI_BIT]: begin

                        datamux    = fdata[31:0]                                          ; 
        end

        default: begin

                        datamux    = '0                                                   ; 
        end

      endcase
    end
  endfunction


  // This function muxes the eom from the master interface to the egress interface.  

  function automatic logic eommux ( 
    logic [5:0]                    fsm_ps                                                 , // Transfer Present State
    logic                          fsm_sent_port_msbs                                     ,
    logic                          addrlen                                                , // Address length
    logic                          eh                                                     , // Use Extended header
    logic                          reg_read                                               ,
    logic                          message_nodata                                         ,
    logic [4:0]                    len                                                    ,
    logic [4:0]                    dcnt                                    
    );

    unique casez (1'b1)

        // First transfer  can  be   eom for non (extended headers) message no data   

        fsm_ps[SB_STD_HDR_BIT]: begin

                    eommux         = message_nodata & (~eh) &
                                        (~strap_hqm_16b_portids | fsm_sent_port_msbs)     ;
        end

        // Second transfer is only the eom for (extended headers) message no data 

        fsm_ps[SB_EXT_HDR_BIT]: begin

                    eommux         = message_nodata & eh                                  ; 
        end

        // Third transfer is eom only for read with 16-bit addrlen 

        fsm_ps[SB_ADDR_BIT]: begin

                    eommux         = reg_read & ~addrlen                                  ; 
        end
 
        // Fourth transfer is eom only if the message is a read 

        fsm_ps[SB_ADDR2_BIT]: begin

                    eommux         = reg_read                                             ; 
        end

        // Multi Data transfer ends when the cnt reaches the dword len

        fsm_ps[SB_DATA_MULTI_BIT]: begin

                    eommux         = (len == dcnt)                                        ;
        end

        default: begin

                    eommux         = '0                                                   ; 
        end

    endcase
  endfunction

  // Idle signal sent to the clock gating ISM
  assign mst_idle                  = (p_fsm_ps == SB_IDLE) & ~p_fsm_sent_port_msbs_ps &
                                     (np_fsm_ps == SB_IDLE) & ~np_fsm_sent_port_msbs_ps &
                                     ~ippmsg_pmsgip & ~ipnpmsg_nmsgip                     ; 

  // Determine if the access message is posted or non-posted
  assign ipnpmsg_np                = np_is_reg_read  | ipnpmsg.np                         ; // Non-posted = read or non-posted write

  // payload/eom muxes 
  assign mst_sbe_mmsg_pceom        = eommux( 
                                       p_fsm_ps, 
                                       p_fsm_sent_port_msbs_ps, 
                                       p_alen,
                                       p_eh,
                                       p_is_reg_read, 
                                       p_is_message_nodata, 
                                       ippmsg.len,
                                       ippmsg.dcnt
                                       );
  
  assign mst_sbe_mmsg_npeom        = eommux( 
                                       np_fsm_ps, 
                                       np_fsm_sent_port_msbs_ps, 
                                       np_alen, 
                                       np_eh,
                                       np_is_reg_read, 
                                       np_is_message_nodata, 
                                       ipnpmsg.len,
                                       ipnpmsg.dcnt
                                       ); 

  
  assign mst_sbe_mmsg_pcpayload    = datamux ( 
                                       p_fsm_ps,
                                       p_fsm_sent_port_msbs_ps,
                                       ippmsg.dest,
                                       strap_hqm_gpsb_srcid,
                                       ippmsg.op,
                                       p_alen,
                                       ippmsg.bar,
                                       ippmsg.tag,
                                       {ippmsg.sbe, ippmsg.be},
                                       ippmsg.fid,
                                       ippmsg.addr,
                                       ippmsg.data,
                                       p_eh,
                                       {{(32-(SAI_WIDTH+1)-8){1'b0}}, ippmsg.sai, 8'h0},
                                       p_eh_cnt,
                                       p_is_message_nodata, 
                                       p_is_message_data
                                       );


  assign mst_sbe_mmsg_nppayload    = datamux( 
                                       np_fsm_ps,
                                       np_fsm_sent_port_msbs_ps,
                                       ipnpmsg.dest,
                                       strap_hqm_gpsb_srcid,
                                       ipnpmsg.op,
                                       np_alen,
                                       ipnpmsg.bar,
                                       ipnpmsg.tag,
                                       {ipnpmsg.sbe, ipnpmsg.be},
                                       ipnpmsg.fid,
                                       ipnpmsg.addr,
                                       ipnpmsg.data,
                                       np_eh,
                                       {{(32-(SAI_WIDTH+1)-8){1'b0}}, ipnpmsg.sai, 8'h0},
                                       np_eh_cnt,
                                       np_is_message_nodata, 
                                       np_is_message_data 
                                       );


  // ipnpmsg_trdy/ipnpmsg_trdy are generated if the following is true:
  //   final_trdy is true when sel & trdy & eom are true
  // OR
  //   state is the DATA state adn sel and trdy are high. Ether of those
  // and a trdy needs to be asserted to IP letting it know to move to the
  // next DATA dword or finish.
  assign ipnpmsg_trdy              = final_nptrdy |
                                      (sbe_mst_mmsg_npsel & sbe_mst_mmsg_nptrdy & 
                                       (np_fsm_ps == SB_DATA_MULTI))                      ; 
  assign ippmsg_trdy               = final_ptrdy |
                                      (sbe_mst_mmsg_pcsel & sbe_mst_mmsg_pctrdy & 
                                       (p_fsm_ps == SB_DATA_MULTI))                       ; 

  assign np_update_state_en        = sbe_mst_mmsg_npsel & 
                                       mst_sbe_mmsg_npirdy & sbe_mst_mmsg_nptrdy          ;
  assign p_update_state_en         = sbe_mst_mmsg_pcsel & 
                                       mst_sbe_mmsg_pcirdy & sbe_mst_mmsg_pctrdy          ;

  always_comb
    begin: nonposted_fsm_next_state_logic_p
      // Defaults
      np_eh_cnt_nxt                = '0                                                   ;
      np_fsm_ns                    = np_fsm_ps                                            ;
      np_fsm_sent_port_msbs_ns     = np_fsm_sent_port_msbs_ps                             ;

      // Generate the irdy signals for the mstr ifc of the base endpoint
      mst_sbe_mmsg_npirdy          = ipnpmsg_np & ipnpmsg.irdy                            ; 

      // Non-posted trdy is asserted to the master interface when the last
      // transfer (eom) has been accepted into the egress block.
      final_nptrdy                 = sbe_mst_mmsg_npsel & 
                                     sbe_mst_mmsg_nptrdy & mst_sbe_mmsg_npeom             ; 

      // Lintra 0241 is waived because np_eh_cnt could be a 1 and yet only 0
      //  is valid. np_eh_cnt will only ever be 0 more then one extended header is
      //  never sent. Its a powers of 2 issue as always with this rule. Could
      //  add an assertion to check that its never 1; however in this case that
      //  seems overkill.
      // Lintra 50002 does not like the use of Xs. However since this is in code
      //  that should never be reached AND since the Lintra SOC 1.4 Guidelines
      //  explicitly show this as a preferrable style, waiving that violation.
      unique casez (1'b1)      
        np_fsm_ps[SB_IDLE_BIT]: begin
            mst_sbe_mmsg_npirdy    = '0                                                   ;
            final_nptrdy           = '0                                                   ;
            if(ipnpmsg.irdy) begin
              np_fsm_ns            = SB_STD_HDR                                           ;
            end else begin
              np_fsm_ns            = SB_IDLE                                              ;
            end
        end
        np_fsm_ps[SB_STD_HDR_BIT]: begin
            if(np_update_state_en) begin
              if (strap_hqm_16b_portids & ~np_fsm_sent_port_msbs_ps) begin
                np_fsm_sent_port_msbs_ns = '1                                             ;
              end else begin
                np_fsm_sent_port_msbs_ns = '0                                             ;
                if     (~np_eh & (np_is_reg_read | np_is_reg_write)) begin
                  np_fsm_ns        = SB_ADDR                                              ;
                end else if(~np_eh & np_is_message_data) begin
                  np_fsm_ns        = SB_DATA_MULTI                                        ;
                end else if(~np_eh & np_is_message_nodata) begin
                  np_fsm_ns        = SB_IDLE                                              ;
                end else begin
                  np_fsm_ns        = SB_EXT_HDR                                           ;
                end
              end
            end
        end
        np_fsm_ps[SB_EXT_HDR_BIT]: begin
            if(np_update_state_en) begin
              if(np_is_message_data) begin   // only allows for 1 EH
                np_fsm_ns          = SB_DATA_MULTI                                        ;
              end else if(np_is_message_nodata) begin
                np_fsm_ns          = SB_IDLE                                              ;
              end else begin
                np_fsm_ns          = SB_ADDR                                              ;
              end
            end
            np_eh_cnt_nxt          = (np_update_state_en) ? 
                                     (np_eh_cnt + 1'b1) : np_eh_cnt                       ;               
        end
        np_fsm_ps[SB_ADDR_BIT]: begin
            if(np_update_state_en) begin
              if     (np_alen) begin
                np_fsm_ns          = SB_ADDR2                                             ;
              end else if(np_is_message_data | np_is_reg_write) begin
                np_fsm_ns          = SB_DATA_MULTI                                        ;
              end else begin
                np_fsm_ns          = SB_IDLE                                              ; 
              end
            end
        end
        np_fsm_ps[SB_ADDR2_BIT]: begin
            if(np_update_state_en) begin
              if(np_is_message_data | np_is_reg_write) begin
                np_fsm_ns          = SB_DATA_MULTI                                        ;
              end else begin
                np_fsm_ns          = SB_IDLE                                              ;
              end
            end
        end
        np_fsm_ps[SB_DATA_MULTI_BIT]: begin
            if(np_update_state_en) begin
              if(~final_nptrdy) begin
                np_fsm_ns          = SB_DATA_MULTI                                        ;
              end else begin
                np_fsm_ns          = SB_IDLE                                              ;
              end
            end
        end
        default: begin
            np_fsm_ns              = np_fsm_ps                                            ; 
        end 
      endcase
    end

  always_comb
    begin: posted_fsm_next_state_logic_p
      // Defaults
      p_eh_cnt_nxt                 = '0                                                   ;
      p_fsm_ns                     = p_fsm_ps                                             ;
      p_fsm_sent_port_msbs_ns      = p_fsm_sent_port_msbs_ps                              ;

      // Generate the irdy signals for the mstr ifc of the base endpoint
      mst_sbe_mmsg_pcirdy          = ippmsg.irdy                                          ; 

      // Posted trdy is asserted to the master interface when the last
      // transfer (eom) has been accepted into the egress block.
      final_ptrdy                  = sbe_mst_mmsg_pcsel & 
                                       sbe_mst_mmsg_pctrdy & mst_sbe_mmsg_pceom           ; 

      // Lintra 0241 is waived because np_eh_cnt could be a 1 and yet only 0
      //  is valid. np_eh_cnt will only ever be 0 more then one extended header is
      //  never sent. Its a powers of 2 issue as always with this rule. Could
      //  add an assertion to check that its never 1               ; however in this case that
      //  seems overkill.
      // Lintra 50002 does not like the use of Xs. However since this is in code
      //  that should never be reached AND since the Lintra SOC 1.4 Guidelines
      //  explicitly show this as a preferrable style, waiving that violation.
      unique casez (1'b1)       
        p_fsm_ps[SB_IDLE_BIT]: begin
            mst_sbe_mmsg_pcirdy    = '0                                                   ;
            final_ptrdy            = '0                                                   ;
            if(ippmsg.irdy) begin
              p_fsm_ns             = SB_STD_HDR                                           ;
            end else begin
              p_fsm_ns             = SB_IDLE                                              ;
            end
        end
        p_fsm_ps[SB_STD_HDR_BIT]: begin
            if(p_update_state_en) begin
              if (strap_hqm_16b_portids & ~p_fsm_sent_port_msbs_ps) begin
                p_fsm_sent_port_msbs_ns = '1                                              ;
              end else begin
                p_fsm_sent_port_msbs_ns = '0                                              ;
                if     (~p_eh & (p_is_reg_read | p_is_reg_write)) begin
                  p_fsm_ns         = SB_ADDR                                              ;
                end else if(~p_eh & p_is_message_data) begin
                  p_fsm_ns         = SB_DATA_MULTI                                        ;
                end else if(~p_eh & p_is_message_nodata) begin
                  p_fsm_ns         = SB_IDLE                                              ;
                end else begin
                  p_fsm_ns         = SB_EXT_HDR                                           ;
                end
              end
            end
        end
        p_fsm_ps[SB_EXT_HDR_BIT]: begin
            if(p_update_state_en) begin
              if(p_is_message_data) begin       // only allows for 1 EH
                p_fsm_ns           = SB_DATA_MULTI                                        ;
              end else if(p_is_message_nodata) begin
                p_fsm_ns           = SB_IDLE                                              ;
              end else begin
                p_fsm_ns           = SB_ADDR                                              ;
              end
            end
            p_eh_cnt_nxt           = (p_update_state_en) ? 
                                     (p_eh_cnt + 1'b1) : p_eh_cnt                         ;               
        end
        p_fsm_ps[SB_ADDR_BIT]: begin
            if(p_update_state_en) begin
              if     (p_alen) begin
                p_fsm_ns           = SB_ADDR2                                             ;
              end else if(p_is_message_data | p_is_reg_write) begin
                p_fsm_ns           = SB_DATA_MULTI                                        ;
              end else begin
                p_fsm_ns           = SB_IDLE                                              ; 
              end
            end
        end
        p_fsm_ps[SB_ADDR2_BIT]: begin
            if(p_update_state_en) begin
              if(p_is_message_data | p_is_reg_write) begin
                p_fsm_ns           = SB_DATA_MULTI                                        ;
              end else begin
                p_fsm_ns           = SB_IDLE                                              ;
              end
            end
        end
        p_fsm_ps[SB_DATA_MULTI_BIT]: begin
            if(p_update_state_en) begin
              if(~final_ptrdy) begin
                p_fsm_ns           = SB_DATA_MULTI                                        ;
              end else begin
                p_fsm_ns           = SB_IDLE                                              ;
              end
            end
        end
        default: begin
            p_fsm_ns               = p_fsm_ps                                             ; 
        end 
      endcase
    end
  

  always_ff @(posedge clk or negedge rst_b)
    if (~rst_b) begin
      p_fsm_ps                    <= SB_IDLE                                              ; // 3-bit posted transfer present state
      np_fsm_ps                   <= SB_IDLE                                              ; // 3-bit non-posted transfer present state
      p_fsm_sent_port_msbs_ps     <= '0                                                   ;
      np_fsm_sent_port_msbs_ps    <= '0                                                   ;
      ippmsg_pmsgip               <= '0                                                   ; // 1-bit posted message in-progress indicator
      ipnpmsg_nmsgip              <= '0                                                   ; // 1-bit non-posted message in-progress indicator
      p_eh_cnt                    <= '0                                                   ; 
      np_eh_cnt                   <= '0                                                   ; 
    end 
    else begin

      // posted transfer counters are zeroed on the last (eom) transfer and 
      // incremented otherwise
      p_fsm_ps                    <= p_fsm_ns                                             ;
      p_fsm_sent_port_msbs_ps     <= p_fsm_sent_port_msbs_ns                              ;
      p_eh_cnt                    <= p_eh_cnt_nxt                                         ;

      np_fsm_ps                   <= np_fsm_ns                                            ;
      np_fsm_sent_port_msbs_ps    <= np_fsm_sent_port_msbs_ns                             ;
      np_eh_cnt                   <= np_eh_cnt_nxt                                        ; 

      // message in-progress indicators are cleared when the transfer is complete
      // on the master interface to the base endpoint and are set when the
      // master ragister in the base endpoint sees the irdy signal for the
      // selected traffic class.
      ippmsg_pmsgip               <= ippmsg_pmsgip ? 
                                       ~(               ippmsg.irdy & final_ptrdy)  : 
                                        (sbe_mst_mmsg_pcsel & mst_sbe_mmsg_pcirdy)        ;
      ipnpmsg_nmsgip              <= ipnpmsg_nmsgip ? 
                                       ~( ipnpmsg_np & ipnpmsg.irdy & final_nptrdy) : 
                                        (sbe_mst_mmsg_npsel & mst_sbe_mmsg_npirdy)        ;
    end

    // Debug Signals

    logic [2:0] np_fsm_ps_enc;
    logic [2:0]  p_fsm_ps_enc;

    always_comb begin

          if (np_fsm_ps == 6'b100000) np_fsm_ps_enc = 3'd5;
     else if (np_fsm_ps == 6'b010000) np_fsm_ps_enc = 3'd4;
     else if (np_fsm_ps == 6'b001000) np_fsm_ps_enc = 3'd3;
     else if (np_fsm_ps == 6'b000100) np_fsm_ps_enc = 3'd2;
     else if (np_fsm_ps == 6'b000010) np_fsm_ps_enc = 3'd1;
     else if (np_fsm_ps == 6'b000001) np_fsm_ps_enc = 3'd0;
     else                             np_fsm_ps_enc = 3'd7;

          if (p_fsm_ps == 6'b100000) p_fsm_ps_enc = 3'd5;
     else if (p_fsm_ps == 6'b010000) p_fsm_ps_enc = 3'd4;
     else if (p_fsm_ps == 6'b001000) p_fsm_ps_enc = 3'd3;
     else if (p_fsm_ps == 6'b000100) p_fsm_ps_enc = 3'd2;
     else if (p_fsm_ps == 6'b000010) p_fsm_ps_enc = 3'd1;
     else if (p_fsm_ps == 6'b000001) p_fsm_ps_enc = 3'd0;
     else                            p_fsm_ps_enc = 3'd7;

     mst_dbgbus = {1'b0,
                   ipnpmsg_np,
                   ipnpmsg_trdy, 
                   mst_sbe_mmsg_npirdy,
                   mst_sbe_mmsg_pcirdy,
                   mst_sbe_mmsg_npeom,
                   mst_sbe_mmsg_pceom,
                   ipnpmsg_nmsgip,
                   np_fsm_ps_enc,
                   ippmsg_pmsgip,
                   p_fsm_ps_enc
     };

    end

endmodule
