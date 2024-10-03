//------------------------------------------------------------------------------
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
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  ip-iosf-sideband-endpoint-09ww51.5-v0.9pre
//
//  Module: sbetrgtarget 
//                        
//  Description:
//   The target register access interface block within the
//   sideband interface endpoint (sbendpoint).
//
//   05102013: Heavily modified to by Justin Diether to support tags
//   and a more flexible incoming completion struct including a EOM, tag,
//   and true signals cycle valid for streaming to a recieving block.
//   No fifoed handshaking (ie irdy, trdy) are needed or required. Space
//   for the completion is available and preallocated.
//
//   05102013: Converted the MSG counter to use enumerated states to help with
//   debug. Converted the interface to structures and a <src>_<dst>_<name>
//   naming convention that I favor.
//
//------------------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_sb_tgt

  import hqm_sif_pkg::*, hqm_system_type_pkg::*;
#(
  parameter MAXTRGTADDR                      = HQMEPSB_MAX_TGT_ADR                        , // Maximum address/data bits supported by the
  parameter MAXTRGTDATA                      = HQMEPSB_MAX_TGT_DAT                        , // master register access interface
  parameter RX_EXT_HEADER_SUPPORT            = HQMIOSF_RX_EXT_HEADER_SUPPORT              , // set to 1 if RX extended headers can be received.
  parameter TX_EXT_HEADER_SUPPORT            = HQMIOSF_TX_EXT_HEADER_SUPPORT              , // set to 1 if TX extended headers can be sent.
  parameter NUM_RX_EXT_HEADERS               = HQMIOSF_NUM_RX_EXT_HEADERS                 , // number of extended headers to receive,
  parameter NUM_TX_EXT_HEADERS               = HQMIOSF_NUM_TX_EXT_HEADERS                 , // number of headers to transmit for completions.
  parameter [NUM_RX_EXT_HEADERS:0][7:0]                                                     // vector to indicate supported extended header IDs,
                           RX_EXT_HEADER_IDS = HQMIOSF_RX_EXT_HEADER_IDS                    // any unsupported headers are discarded
  )(
  // Clock/Reset Signals
  input  logic                               clk                                          , 
  input  logic                               rst_b                                        , 

  // Interface to the clock gating ISM
  output logic                               tgt_idle                                     , 

  // SAI for completions
  input  logic [SAI_WIDTH:0]                 strap_hqm_cmpl_sai                           ,
  input  logic                               strap_hqm_16b_portids                        ,

  // Interface to the target side of the base endpoint (sbebase)
  // for receiving posted and non-posted messages
  input  logic                               sbe_tgt_tmsg_pcput                           , 
  input  logic                               sbe_tgt_tmsg_npput                           , 
  input  logic                               sbe_tgt_tmsg_pcmsgip                         , 
  input  logic                               sbe_tgt_tmsg_npmsgip                         , 
  input  logic                               sbe_tgt_tmsg_pceom                           , 
  input  logic                               sbe_tgt_tmsg_npeom                           , 
  input  logic [31:0]                        sbe_tgt_tmsg_pcpayload                       , 
  input  logic [31:0]                        sbe_tgt_tmsg_nppayload                       , 
  input  logic                               sbe_tgt_tmsg_pccmpl                          , 
  output logic                               tgt_sbe_tmsg_pcfree                          , 
  output logic                               tgt_sbe_tmsg_npfree                          , 
  output logic                               tgt_sbe_tmsg_npclaim                         , 

  // Interface to the master side of the base endpoint (sbebase)
  // for sending completions for the non-posted target messages
  input  logic                               sbe_tgt_mmsg_pcsel                           , 
  input  logic                               sbe_tgt_mmsg_pctrdy                          , 
  input  logic                               sbe_tgt_mmsg_pcmsgip                         , 
  output logic                               tgt_sbe_mmsg_pcirdy                          , 
  output logic                               tgt_sbe_mmsg_pceom                           , 
  output logic [31:0]                        tgt_sbe_mmsg_pcpayload                       , 

  // Ingress Master Completion Interface - Cmp to the IP
  output hqm_sb_ep_cmp_t                     tgt_ip_cmsg                                  ,

  // Egress Target Register Completion Interface - Cmp from the IP
  input  hqm_sb_tgt_cmsg_t                   ip_tgt_cmsg                                  , 
                                                                                            //  its there for future expansion.
                                                                                            // IP to Tgt Cmp Msg
  output logic                               tgt_ip_cmsg_free                             , // Available free space for Cmp 

  // Ingress Target Register Message Interface - Msg for the IP
  output hqm_sb_tgt_msg_t                    tgt_ip_msg                                   , // Tgt to IP Msg struct
  input  logic                               ip_tgt_msg_trdy                              , // handshake for Tgt to IP  

  // Reset Prep Handling Interface
  input  logic                               sif_gpsb_quiesce_req                         , // Tell Sideband to UR NPs and Drop Ps on its target
  output logic                               sif_gpsb_quiesce_ack                         , // Tell RI_IOSF_SB that the TGT is URing/Dropping NP/P

  // Debug Signals
  output logic [15:0]                        tgt_dbgbus
  );

  `include "hqm_sbcfunc.vm"
  `include "hqm_sbcglobal_params.vm"

  /////////////////////////////////////////////////////////////////////////////////////////
  // Local Parameters
  localparam MAXADDR                         = MAXTRGTADDR                                ; 
  localparam MAXDATA                         = MAXTRGTDATA                                ; 
  localparam MAXBE                           = (MAXTRGTDATA == 31) ?  3 : 7               ; 
  localparam ALLONES                         = {32{1'b1}}                                 ; 
  localparam ADDRMASK                        = ALLONES << (MAXADDR-15)                    ; 
  localparam MAXADDRINDATA                   = (MAXADDR == 15)     ?  0 : MAXADDR - 16    ; 
  localparam MAXADDRINMSG                    = (MAXADDR > 31)      ? 31 : MAXADDR         ; 
  localparam MINADDR                         = (MAXADDR == 15)     ? 15 : 16              ; 
  localparam DW2MIN                          = (MAXDATA == 63)     ? 32 : 0               ; 
  localparam DW2BEMIN                        = (MAXBE   ==  7)     ?  4 : 0               ; 

  // jbdiethe: This was removed in the IOSF 1.1 spec Revision 0.71 actually
  // Removed the Broadcast Completion message, since given the 0xFE solution, completion 
  // for broadcast/multicast is just like any other completion.
  //calparam SBCOP_CMPB                      = 8'hff                                      ; 
  localparam NUM_RX_EXT_HEADERS_L2           = sbc_logb2(NUM_RX_EXT_HEADERS)              ; 

  /////////////////////////////////////////////////////////////////////////////////////////
  // Local Signals and TypeDefs

  localparam SB_STD_HDR_BIT = 0;
  localparam SB_EXT_HDR_BIT = 1;
  localparam SB_ADDR_BIT    = 2;
  localparam SB_ADDR2_BIT   = 3;
  localparam SB_DATA_BIT    = 4;
  localparam SB_DATA2_BIT   = 5;
  localparam SB_DONE_BIT    = 6;

  typedef enum logic [6:0] {
    SB_STD_HDR                               = 7'b0000001,
    SB_EXT_HDR                               = 7'b0000010,
    SB_ADDR                                  = 7'b0000100,                                 
    SB_ADDR2                                 = 7'b0001000,                                 
    SB_DATA                                  = 7'b0010000,
    SB_DATA2                                 = 7'b0100000,
    SB_DONE                                  = 7'b1000000
  } hqm_tgt_fsm_t                                                                         ;

  localparam CPL_STD_HDR_BIT = 0;
  localparam CPL_EXT_HDR_BIT = 1;
  localparam CPL_DATA_BIT    = 2;
  localparam CPL_DONE_BIT    = 3;

  typedef enum logic [3:0] {
    CPL_STD_HDR                              = 4'b0001,
    CPL_EXT_HDR                              = 4'b0010,
    CPL_DATA                                 = 4'b0100,                                 
    CPL_DONE                                 = 4'b1000                                 
  } hqm_tgt_cfsm_t                                                                        ;

  // Structure for capturing the posted/non-posted register access and messages
  // and the current transfer state and irdy signal.
  typedef struct packed unsigned {
    logic                                    got_port_msbs                                ; // MSBs of 16b port IDs received
    hqm_tgt_fsm_t                            state                                        ; // Current 4 byte flit transfer count
    logic                                    err                                          ; // Error detected in received message
    logic                                    irdy                                         ; // Message ready
    logic [MAXDATA:0]                        data                                         ; // Read/write data
    logic [MAXADDR:0]                        addr                                         ; // Address of the message
    logic [7:0]                              fid                                          ; // Function ID
    logic [MAXBE:0]                          be                                           ; // Byte enables (4 or 8 bits)
    logic                                    addrlen                                      ; // Address length (0=16bit / 1=48bit)
    logic [2:0]                              bar                                          ; // Selected BAR
    logic                                    eh                                           ; // "EH" bit from standard header.
    logic                                    eh_discard                                   ; // unknown extended header has been dropped.
    logic [NUM_RX_EXT_HEADERS_L2:0]          ext_hdr_cnt                                  ; // counts number of ext headers received.
    logic [NUM_RX_EXT_HEADERS:0][31:0]       ext_hdr                                      ; // extended headers
    logic [2:0]                              tag                                          ; // Message tag
    logic [7:0]                              opcode                                       ; // Message opcode
    logic [15:0]                             source                                       ; // Source port ID
    logic [15:0]                             dest                                         ; // Destination port ID
    logic                                    is_message_w_data                            ; // its a Message with Data
  } hqm_regstate_t                                                                        ;

  hqm_regstate_t                             pstate                                       ; // Posted message present state
  hqm_regstate_t                             pstate_nxt                                   ; // Posted message next state
  hqm_regstate_t                             nstate                                       ; // Non-posted message present state
  hqm_regstate_t                             nstate_nxt                                   ; // Non-posted message next state

  logic                                      ppop                                         ; // Posted/non-posted pop signals that indicate that the
  logic                                      ppop_ff                                      ; // message has been transferred on the target interface
  logic                                      npop                                         ; // Posted/non-posted pop signals that indicate that the
  logic                                      npop_ff                                      ; // message has been transferred on the target interface
  logic                                      pput                                         ; // Posted/non-posted put signals that indicate that the
  logic                                      nput                                         ; // next 4 byte flit is valid and needs to be captured.
  logic                                      pignore                                      ; // Ignore flops: When active, the target message is not
  logic                                      nignore                                      ; // a register access message and is being ignored.
  logic                                      np                                           ; // Non-posted is selected when asserted
  logic                                      tmsg_pclaim                                  ; 

  typedef struct packed unsigned {
    logic                                    got_port_msbs                                ; 
    hqm_tgt_cfsm_t                           state                                        ; // Current 4 byte flit transfer count
    logic                                    err                                          ; // 
    logic                                    ursp                                         ; // completion rsp  in  unsuccessfull/unsupported
    logic [2:0]                              tag                                          ; // tag
    logic [MAXDATA:0]                        data                                         ; // Read/write data
    logic                                    eh                                           ; // SAI present.
    logic                                    eh_discard                                   ; // unknown extended header has been dropped.
    logic [NUM_RX_EXT_HEADERS_L2:0]          ext_hdr_cnt                                  ; // counts number of ext headers received.
    logic [NUM_RX_EXT_HEADERS:0][31:0]       ext_hdr                                      ; // extended headers
    logic [7:0]                              opcode                                       ; // Source port ID
    logic                                    irdy                                         ; 
    logic                                    rspdata_put                                  ; 
  } hqm_cmpl_state_t                                                                      ;

  hqm_cmpl_state_t                           cmplstate                                    ; // completion present state 
  hqm_cmpl_state_t                           cmplstate_nxt                                ; // completion next state 

  logic                                      cpop                                         ; // message has been transferred on the target interface
  logic                                      cput                                         ; // next 4 byte flit is valid and needs to be captured.
  logic                                      cput_ff                                      ; // next 4 byte flit is valid and needs to be captured.
  logic                                      cignore                                      ; // a register access message and is being ignored.
  logic                                      tmsg_cclaim                                  ; 
  logic                                      ip_tgt_msg_trdy_ff                           ; 
  logic                                      block_np_in                                  ; 
  logic                                      ip_tgt_cmsg_data_buffer_full                 ; 

  // Master completion generation
  logic                                      cirdy                                        ; // Egress Cpl is Ready to be sent.
  logic                                      ctarget_cursp                                ; // Egress Cpl error response.
  logic                                      cpending                                     ; // Non-posted issued a request which is waiting for a Egress Cpl.
  logic                                      sif_gpsb_quiesce_req_q                       ; // Tell Sideband to UR NPs and Drop Ps on its target

  localparam E_CPL_STD_HDR_BIT  = 0;
  localparam E_CPL_EXT_HDR_BIT  = 1;
  localparam E_CPL_DATA_DW1_BIT = 2;
  localparam E_CPL_DATA_DW2_BIT = 3;

  // Egress Completion Counter States
  typedef enum logic [3:0] {
    E_CPL_STD_HDR                            = 4'b0001,
    E_CPL_EXT_HDR                            = 4'b0010,
    E_CPL_DATA_DW1                           = 4'b0100,                                 
    E_CPL_DATA_DW2                           = 4'b1000                                   
  } hqm_tgt_egress_cfsm_t                                                                 ;

  hqm_tgt_egress_cfsm_t                      egress_cmplstate                             ; // Completion transfer counter
  logic                                      egress_sent_port_msbs_nxt                    ;
  logic                                      egress_sent_port_msbs                        ;
  logic                                      cmpd                                         ; // Completion with data otherwise without data
  logic                                      tx_eh                                        ; // indicates an extended header will be attached to cmp.

  // Opcodes
  logic [7:0]                                np_opcode                                    ;
  logic [7:0]                                pc_opcode                                    ;

  // Quiesce ResetPrep Handling Signals
  logic                                      np_quiesce                                   ;
  logic                                      pc_quiesce                                   ;
  logic                                      tgt_quiesced                                 ;    
  logic                                      sif_gpsb_quiesce_ack_nxt                     ;

  // Function for capturing/updating the state of the register access
  // message transfers (posted and non-posted)

  function automatic hqm_regstate_t nxtstate( 

    hqm_regstate_t                           cstate                                                 ,
    logic                                    use_16b_portids                                        ,
    logic                                    pop                                                    ,
    logic                                    put                                                    ,
    logic                                    eom                                                    ,
    logic [31:0]                             data
  ); 

    nxtstate                                 = cstate                                               ;

    unique casez (1'b1)        

      // Standard Header State, this is always seen and always the first DW. It includes:
      //   Dest/Source Port IDs, tag, bar, addrlen

      cstate.state[SB_STD_HDR_BIT]: begin // Start State

          if (put & ~cstate.irdy) begin

            // If this is the final state eom will get asserted, meaning the message can be sent.

            nxtstate.irdy                    = eom                                                  ; 

            if (use_16b_portids & ~cstate.got_port_msbs) begin   // 8 MSBs of 16b port IDs

              // In 16b (global) mode, the first DW includes the upper 8b of the 16b src/dst port IDs

              nxtstate.dest[15:8]            = data[ 7: 0]                                          ;
              nxtstate.source[15:8]          = data[15: 8]                                          ;

              if (eom) begin

                nxtstate.state               = SB_DONE                                              ;
                nxtstate.err                 = '1                                                   ;

              end else begin

                nxtstate.got_port_msbs       = '1                                                   ;

              end

            end else begin // Standard header w/ 8 LSBs of 16b port IDs or entire 8b port IDs

              if (~use_16b_portids) begin

                nxtstate.dest[15:8]          = '0                                                   ;
                nxtstate.source[15:8]        = '0                                                   ;

              end

              // Decode the Standard Header data payload

              nxtstate.dest[7:0]             = data[ 7: 0]                                          ;
              nxtstate.source[7:0]           = data[15: 8]                                          ;
              nxtstate.opcode                = data[23:16]                                          ; 
              nxtstate.tag                   = data[26:24]                                          ;
              nxtstate.bar                   = data[29:27]                                          ; 
              nxtstate.addrlen               = data[   30]                                          ; 
              nxtstate.eh                    = data[   31]                                          ; 
              nxtstate.is_message_w_data     = (nxtstate.opcode <  HQMEPSB_OP_MSGD_END) &
                                               (nxtstate.opcode >= HQMEPSB_OP_COMU_START)           ; 

              // Since this is the start state clean out fields that will be set in later states.

              nxtstate.eh_discard            = '0                                                   ; 
              nxtstate.be                    = '0                                                   ; 
              nxtstate.fid                   = '0                                                   ; 
              nxtstate.addr                  = '0                                                   ; 
              nxtstate.data                  = '0                                                   ; 
              nxtstate.ext_hdr               = '0                                                   ; // Clear these set in SB_EXT_HDR state
              nxtstate.ext_hdr_cnt           = '0                                                   ; // Clear these set in SB_EXT_HDR state
              nxtstate.got_port_msbs         = '0                                                   ;

              // The Next State Calculation

              if     (eom) begin                                                                      
                                                                        // Final state, ie simple messages, no EH so SB_DONE
                nxtstate.state               = SB_DONE                                              ;

              end else if ((|RX_EXT_HEADER_SUPPORT) & nxtstate.eh) begin// Go to EH state if 'eh' bit is set os SB_EXT_HDR

                nxtstate.state               = SB_EXT_HDR                                           ;

              end else if(nxtstate.is_message_w_data) begin             // Message with data with no extended header so SB_DATA

                nxtstate.state               = SB_DATA                                              ;

              end else if(nxtstate.opcode[7:5] == '0) begin             // Reg rd/wr Access need an Address for that so SB_ADDR

                nxtstate.state               = SB_ADDR                                              ;

              end
              
              // Error occurs if one of the following:
              // 1. Register read/write has  eom  
              // 2. Staying in STD_HDR after this is an ERROR this is a bad arc. Should never happen.

              nxtstate.err                   = ((nxtstate.opcode[7:5] == '0) & eom) |
                                               (nxtstate.state == SB_STD_HDR)                       ; 

            end
          end

      end // case: SB_STD_HDR

      // The Extended Header State, generally the 2nd DW seen on SB. On HQM its always one DW.

      cstate.state[SB_EXT_HDR_BIT]: begin

          if (put & ~cstate.irdy) begin

              // If this is the final state eom will get asserted, meaning the message can be sent.

              nxtstate.irdy                  = eom                                                  ; 

              // The Next State Calculation

              if     (eom) begin                            // Final state, ie simple messages, with EH so SB_DONE
                nxtstate.state               = SB_DONE                                              ;
              end else if(data[7]) begin                    // If the "eh" bit is 1 handle more ext headers
                nxtstate.state               = SB_EXT_HDR                                           ;
              end else if(nxtstate.is_message_w_data) begin // Message with data with EH so now SB_DATA
                nxtstate.state               = SB_DATA                                              ;
              end else if(nxtstate.opcode[7:5] == '0) begin // Reg rd/wr Access need an Address so move to SB_ADDR
                nxtstate.state               = SB_ADDR                                              ;
              end

              // Extended header Creation
              // HQM has NUM_RX_EXT_HEADERS set to 1 so this for loop is not exerciced for more
              // than 1 iteration

              for (int unsigned i=0; i <= NUM_RX_EXT_HEADERS; i++)
                if ( data[6:0] == RX_EXT_HEADER_IDS[i][6:0] ) begin

                    // bit 7, which is the 'end of eh' bit, is overridden to indicate that 
                    // this header is valid in this way, the number of headers received is 
                    // made available to the agent.

                    nxtstate.ext_hdr[nxtstate.ext_hdr_cnt]                                            
                                            |= { data[31:8], 1'b1, data[6:0] }                      ; 
                    nxtstate.ext_hdr_cnt    |= nxtstate.ext_hdr_cnt + 1'b1                          ; 
                    nxtstate.eh_discard      = '0                                                   ; 
                end else begin
                    nxtstate.eh_discard     |= '1                                                   ; 
                end
          end

      end // case: SB_EXT_HDR

      // The Address State, generally the 3rd DW seen on SB on HQM. It contains:
      //   Byte enables, Requestor ID and 16-bits of address. However its possible
      //   to need 48 bits of address that will be in the address 2 state.

      cstate.state[SB_ADDR_BIT]: begin

          if (put & ~cstate.irdy) begin

              // If this is the final state eom will get asserted, meaning the message can be sent.

              nxtstate.irdy                  = eom                                                  ; 

              // Decode the Address data payload and get be, fid, and address

              nxtstate.be                    = data[MAXBE:0]                                        ; 
              nxtstate.fid                   = data[15: 8]                                          ; 
              nxtstate.addr[15:0]            = data[31:16]                                          ; 

              // The Next State Calculation

              nxtstate.state                 = (eom) ? 
                                                SB_DONE : 
                                               (cstate.addrlen) ? 
                                                SB_ADDR2 : 
                                                SB_DATA                                             ; 

              // Error occurs if one of the following:
              // 1. the IP block only supports a dword of data and one of the second byte 
              //    enables (sbe) are active
              // 2. EOM asserted for a write 
              // 3. EOM not asserted for 16 bit address read in a non-SAI transaction.

              nxtstate.err                  |= ((MAXBE==3) & (|data[7:4])) |
                                               ((cstate.opcode[7:5] == '0) & cstate.opcode[0] & eom) |
                                               ((cstate.opcode[7:5] == '0) & ~cstate.opcode[0] & ~cstate.addrlen & ~eom ); 
          end

      end // case: SB_ADDR

      // The Upper Address State aka Address2, generally the 4th DW seen on SB on HQM. It contains:
      //   Upper order address bits, above bit 15. It should only be used by Register Access 
      //   Messages.

      cstate.state[SB_ADDR2_BIT]: begin  

          if (put & ~cstate.irdy) begin

              // If this is the final state eom will get asserted, meaning the message can be sent.

              nxtstate.irdy                  = eom                                                  ; 

              // The Next State Calculation

              nxtstate.state                 = (eom) ? 
                                                SB_DONE : 
                                                SB_DATA                                             ; 
              if (cstate.opcode[7:5] == '0) begin
                  nxtstate.addr[MAXADDR:MINADDR] 
                                             = data[MAXADDRINDATA:0]                                ; 
              end else  begin
                  nxtstate.addr[MAXADDR:0]   = {{(MAXADDR-MAXADDRINMSG){1'b0}},data[31:0]}          ; 

                  nxtstate.data[31:0]        = data[31:0]                                           ; 
              end

              // An error occurs if any of 
              // 1. the unsupported address bits are active, which would cause an aliasing error.
              // 2. this is not eom for a read 
              // 3. this is eom for a write.

              nxtstate.err                  |=  ((cstate.opcode[7:5] == 3'd0) & (|(ADDRMASK & data))) |
                                                ((cstate.opcode[7:5] == 3'd0) & (~cstate.opcode[0]) & (~eom) ) |
                                                ((cstate.opcode[7:5] == 3'd0) &   cstate.opcode[0]  &   eom  ); 
          end

      end // case: SB_ADDR2

      // Transfer 3 contains the first dword of write data or message with 2 DW of data

      cstate.state[SB_DATA_BIT]: begin

          if (put & ~cstate.irdy)                                                   begin
              nxtstate.irdy                  = eom                                                  ; 
              nxtstate.state                 = (eom) ? SB_DONE : SB_DATA2                           ; 
              nxtstate.data[31:0]            = data                                                 ; 

              // An error occurs if 
              // 1. the eom value does not match the second dword byte enables for register access.
              //    If these bits do not exist, then this should be the eom .
              //    If the bits do exist, then if the second dword is expected (non-zero be[7:4]) then this
              //    should not be eom, otherwise it should be eom.

              if (MAXBE==3) begin
                  nxtstate.err               |= (~eom) & (cstate.opcode[7:5] == '0) & 
                                                (~nxtstate.is_message_w_data)                       ; 
              end else begin
                  nxtstate.err               |= (eom == (|cstate.be[MAXBE:DW2BEMIN])) & 
                                                (~nxtstate.is_message_w_data)                       ; 
              end
          end

      end // case: SB_DATA

      // Transfer 4 contains the second dword of write data

      cstate.state[SB_DATA2_BIT]: begin

          if (put & ~cstate.irdy) begin
              nxtstate.irdy                  = eom                                                  ; 
              nxtstate.state                 = (eom) ? SB_DONE : SB_DATA2                           ; 
              nxtstate.data[MAXDATA:DW2MIN]  = data                                                 ; 
              
              // This should always be the eom.

              nxtstate.err                  |= ~eom                                                 ; 

          end

      end // case: SB_DATA2
          
      cstate.state[SB_DONE_BIT]: begin // End State

          if (put & ~cstate.irdy) begin

              // This  state is the finish state of a transaction. The "else if (pop) logic"
              // below moves the FSM out of this state or any state that asserts irdy based 
              // on eom. Its not a standard state machine style.

              nxtstate.irdy                  = eom                                                  ; 

          end else if (pop) begin

              // Clear the state when the message completes on the target register
              // access interface

              nxtstate.irdy                  = '0                                                   ; 
              nxtstate.state                 = SB_STD_HDR                                           ; 
          end

      end

      // assert pop must occur in SB_DONE
      // cstate.irdy must only assert in SB_DONE

      default: begin

          nxtstate.irdy                      = '0                                                   ; 
          nxtstate.err                       = '1                                                   ; 

      end // case: default

    endcase // case (cstate.state)
    
  endfunction
  
  // Function for capturing/updating the state of the completion 
  // message transfers completion 

  function automatic hqm_cmpl_state_t cmplnxtstate(  

    hqm_cmpl_state_t                         cmplstate                                              ,
    logic                                    use_16b_portids                                        ,
    logic                                    pop                                                    ,
    logic                                    put                                                    ,
    logic                                    eom                                                    ,
    logic [31:0]                             data
  ); 

    cmplnxtstate                             = cmplstate                                            ; 

    unique casez (1'b1)     

      // Transfer 0: Dest/Source Port IDs, opcode, tag, rsvd, eh, rsp 

      cmplstate.state[CPL_STD_HDR_BIT]: begin // Start State

        if (put & ~cmplstate.irdy) begin

          // Set Irdy if this is the final state

          cmplnxtstate.irdy                  = eom                                                  ; 

          if (use_16b_portids & ~cmplstate.got_port_msbs) begin

            if (eom) begin

              cmplnxtstate.err               = '1                                                   ;
              cmplnxtstate.state             = CPL_DONE                                             ;

            end else begin

              cmplnxtstate.got_port_msbs     = '1                                                   ;

            end

          end else begin

            // Decode the Standard Header Payload  

            cmplnxtstate.opcode              = data[23:16]                                          ; 
            cmplnxtstate.eh                  = data[31]                                             ; 
            cmplnxtstate.ursp                = data[27]                                             ; 
            cmplnxtstate.tag                 = data[26:24]                                          ;

            // Set the Next State based on the eom and extended header bit

            cmplnxtstate.state               = (eom) ? 
                                                CPL_DONE : 
                                               (cmplnxtstate.eh) ? 
                                                CPL_EXT_HDR : 
                                                CPL_DATA                                            ; 

            // This is the Start State, zero out fields that are not available yet

            cmplnxtstate.data                = '0                                                   ; // set in CPL_DATA 
            cmplnxtstate.ext_hdr             = '0                                                   ; // set in CPL_EXT_HDR 
            cmplnxtstate.ext_hdr_cnt         = '0                                                   ; // set in CPL_EXT_HDR
            cmplnxtstate.rspdata_put         = '0                                                   ; 
            cmplnxtstate.got_port_msbs       = '0                                                   ;

            // An error occurs if 
            // 1. the eom asserted for extended header received  
            // 2. the eom asserted for completion with  data  
            // 3. the eom not asserted for Non exteded header completion wo data

            cmplnxtstate.err                 = (eom & cmplnxtstate.eh) | 
                                               ((cmplnxtstate.opcode == SBCOP_CMPD ) & eom ) | 
                                                (~eom & ~cmplnxtstate.eh & (cmplnxtstate.opcode != SBCOP_CMPD )); 
          end
        end

      end

      cmplstate.state[CPL_EXT_HDR_BIT]: begin

        if (put & ~cmplstate.irdy) begin
          cmplnxtstate.irdy                  = eom                                                  ; 
          cmplnxtstate.state                 = (eom) ? 
                                                CPL_DONE : 
                                               (data[7]) ?                                            // bit 7, which is the 0 == 'end of eh' bit
                                                CPL_EXT_HDR : 
                                                CPL_DATA                                            ; // back to normal states if this is the end of hdrs.
          cmplnxtstate.rspdata_put           = '0                                                   ; 
          for (int unsigned i=0; i <= NUM_RX_EXT_HEADERS; i++)
            if ( data[6:0] == RX_EXT_HEADER_IDS[i][6:0] ) begin

                // bit 7, which is the 'end of eh' bit, is overridden to indicate that this header is valid
                // in this way, the number of headers received is made available to the agent.

                cmplnxtstate.ext_hdr[cmplnxtstate.ext_hdr_cnt]                                        
                                            |= { data[31:8], 1'b1, data[6:0] }                      ; 
                cmplnxtstate.ext_hdr_cnt    |= cmplnxtstate.ext_hdr_cnt + 1'b1                      ; 
            end else begin
              cmplnxtstate.eh_discard       |= '1                                                   ; 
            end
        end

      end

      cmplstate.state[CPL_DATA_BIT]: begin

        if (put & ~cmplstate.irdy) begin
          cmplnxtstate.irdy                  = eom                                                  ; 
          cmplnxtstate.state                 = (eom) ? CPL_DONE : CPL_DATA                          ;
          cmplnxtstate.rspdata_put           = 1                                                    ; 
          if (cmplstate.opcode == SBCOP_CMPD )  
            cmplnxtstate.data[31:0]          = data[31:0]                                           ; 
        end

      end

      cmplstate.state[CPL_DONE_BIT]: begin

        // Only entered when eom was high in the previous state add assertion

        if (pop) begin

            // Clear the state when the message completes on the target register
            // access interface

            cmplnxtstate.irdy                = '0                                                   ; 
            cmplnxtstate.state               = CPL_STD_HDR                                          ; 
            cmplnxtstate.rspdata_put         = '0                                                   ; 
        end

      end

      default: begin

        cmplnxtstate                         = cmplstate                                            ; 

      end

    endcase // case(cmplstate.state)

  endfunction

  logic sbe_tgt_mmsg_pcmsgip_nc;

  assign sbe_tgt_mmsg_pcmsgip_nc = sbe_tgt_mmsg_pcmsgip;

  // For 16b port ID mode, the first flit contains the hierarchical routing header instead of the
  // normal header as it does in 8b mode.  The posted versus completion indication is also not
  // available until the second flit.  So, when we are in 16b port ID mode, we need to the first 2
  // flits before we can make a decision. The *msgip signal being deasserted indicates the first flit.
  // So we need to add a pipeline stage to be able to look at the first and second flits at the
  // same time.  Need to hold the first flit valid until the second flit is valid on the pins.

  logic                               sbe_tgt_tmsg_pcput_q;
  logic                               sbe_tgt_tmsg_npput_q;
  logic                               sbe_tgt_tmsg_pcmsgip_q;
  logic                               sbe_tgt_tmsg_npmsgip_q;
  logic                               sbe_tgt_tmsg_pceom_q;
  logic                               sbe_tgt_tmsg_npeom_q;
  logic [31:0]                        sbe_tgt_tmsg_pcpayload_q;
  logic [31:0]                        sbe_tgt_tmsg_nppayload_q;

  logic                               sbe_tgt_tmsg_pcput_in;
  logic                               sbe_tgt_tmsg_npput_in;
  logic                               sbe_tgt_tmsg_pcmsgip_in;
  logic                               sbe_tgt_tmsg_npmsgip_in;
  logic                               sbe_tgt_tmsg_pceom_in;
  logic                               sbe_tgt_tmsg_npeom_in;
  logic [31:0]                        sbe_tgt_tmsg_pcpayload_in;
  logic [31:0]                        sbe_tgt_tmsg_nppayload_in;

  always_ff @(posedge clk or negedge rst_b) begin
   if (~rst_b) begin

    sbe_tgt_tmsg_pcput_q       <= '0;
    sbe_tgt_tmsg_pcmsgip_q     <= '0;
    sbe_tgt_tmsg_pceom_q       <= '0;
    sbe_tgt_tmsg_pcpayload_q   <= '0;

    sbe_tgt_tmsg_npput_q       <= '0;
    sbe_tgt_tmsg_npmsgip_q     <= '0;
    sbe_tgt_tmsg_npeom_q       <= '0;
    sbe_tgt_tmsg_nppayload_q   <= '0;

   end else begin

    if (strap_hqm_16b_portids) begin

     sbe_tgt_tmsg_pcput_q      <= sbe_tgt_tmsg_pcput | (sbe_tgt_tmsg_pcput_q &
                                    ~sbe_tgt_tmsg_pcmsgip_q & ~sbe_tgt_tmsg_pceom_q);

     if (sbe_tgt_tmsg_pcput) begin
      sbe_tgt_tmsg_pcmsgip_q   <= sbe_tgt_tmsg_pcmsgip;
      sbe_tgt_tmsg_pceom_q     <= sbe_tgt_tmsg_pceom;
      sbe_tgt_tmsg_pcpayload_q <= sbe_tgt_tmsg_pcpayload;
     end

     sbe_tgt_tmsg_npput_q      <= sbe_tgt_tmsg_npput | (sbe_tgt_tmsg_npput_q &
                                    ~sbe_tgt_tmsg_npmsgip_q & ~sbe_tgt_tmsg_npeom_q);

     if (sbe_tgt_tmsg_npput) begin
      sbe_tgt_tmsg_npmsgip_q   <= sbe_tgt_tmsg_npmsgip;
      sbe_tgt_tmsg_npeom_q     <= sbe_tgt_tmsg_npeom;
      sbe_tgt_tmsg_nppayload_q <= sbe_tgt_tmsg_nppayload;
     end

    end

   end
  end

  // Use the inputs directly in 8b port ID mode and the registered values when in 16b port ID mode.
  // In 16b mode, that allows us to look at the opcode and pccmpl fields of the inputs (2nd flit) when
  // evaluating the 1st flit.  So, in that mode, we cannot let the registered flit look valid unless
  // it's not the first flit (*msgip_q is set) or it's the first flit and the 2nd flit in valid on the
  // input.

  assign sbe_tgt_tmsg_pcput_in     = (strap_hqm_16b_portids) ? (sbe_tgt_tmsg_pcput_q &
                                                                (sbe_tgt_tmsg_pcmsgip_q |
                                                                 sbe_tgt_tmsg_pceom_q   |
                                                                 sbe_tgt_tmsg_pcput))    : sbe_tgt_tmsg_pcput;
  assign sbe_tgt_tmsg_pcmsgip_in   = (strap_hqm_16b_portids) ?  sbe_tgt_tmsg_pcmsgip_q   : sbe_tgt_tmsg_pcmsgip;
  assign sbe_tgt_tmsg_pceom_in     = (strap_hqm_16b_portids) ?  sbe_tgt_tmsg_pceom_q     : sbe_tgt_tmsg_pceom;
  assign sbe_tgt_tmsg_pcpayload_in = (strap_hqm_16b_portids) ?  sbe_tgt_tmsg_pcpayload_q : sbe_tgt_tmsg_pcpayload;

  assign sbe_tgt_tmsg_npput_in     = (strap_hqm_16b_portids) ? (sbe_tgt_tmsg_npput_q &
                                                                (sbe_tgt_tmsg_npmsgip_q |
                                                                 sbe_tgt_tmsg_npeom_q   |
                                                                 sbe_tgt_tmsg_npput))    : sbe_tgt_tmsg_npput;
  assign sbe_tgt_tmsg_npmsgip_in   = (strap_hqm_16b_portids) ?  sbe_tgt_tmsg_npmsgip_q   : sbe_tgt_tmsg_npmsgip;
  assign sbe_tgt_tmsg_npeom_in     = (strap_hqm_16b_portids) ?  sbe_tgt_tmsg_npeom_q     : sbe_tgt_tmsg_npeom;
  assign sbe_tgt_tmsg_nppayload_in = (strap_hqm_16b_portids) ?  sbe_tgt_tmsg_nppayload_q : sbe_tgt_tmsg_nppayload;
  
  // Output to the master interface of the base endpoint

  always_comb 
    tgt_sbe_mmsg_pcirdy                      = cirdy                                                ; 

  always_comb
    tx_eh                                    = |TX_EXT_HEADER_SUPPORT                               ; 

  always_comb begin: gen_pop_p

      // ppop relocated to its own always_comb to make linra happy.

      ppop                                   = ~np & pstate.irdy &
                                               (ip_tgt_msg_trdy | pstate.err)                       ; 
      npop                                   =  np & nstate.irdy &
                                               (((ip_tgt_msg_trdy | ip_tgt_msg_trdy_ff ) & ~block_np_in) |
                                                nstate.err)                                         ;
      cpop                                   = cmplstate.irdy | cmplstate.err                       ; 
    end

  always_comb begin

      // Setup the opcode signals for readability
      // Note this is always based on the input (1st flit for 8b port ID mode, 2nd flit for 16b port ID mode)

      np_opcode                              = sbe_tgt_tmsg_nppayload[23:16]                        ;
      pc_opcode                              = sbe_tgt_tmsg_pcpayload[23:16]                        ;

      // The target register access service is idle when irdys are de-asserted and
      // both transfer counters are zero.  
      // add completion received  irdy into this 

      tgt_idle                               =  ~pstate.irdy    & (pstate.state == SB_STD_HDR) &
                                                ~pstate.got_port_msbs &
                                                ~nstate.irdy    & (nstate.state == SB_STD_HDR) & 
                                                ~nstate.got_port_msbs &
                                                ~cmplstate.irdy & (cmplstate.state == CPL_STD_HDR) &
                                                ~cmplstate.got_port_msbs                            ;

      // Outputs to the target interface of the base endpoint

      tgt_sbe_tmsg_pcfree                    = ~pstate.irdy & ~cmplstate.irdy; 
      tgt_sbe_tmsg_npfree                    = ~nstate.irdy & 
                                               (~tgt_sbe_mmsg_pcirdy | (tgt_sbe_mmsg_pceom & 
                                                                        sbe_tgt_mmsg_pcsel & 
                                                                        sbe_tgt_mmsg_pctrdy))       ;
      // Quiesce in this context means to drop Ps and UR nPs in this context.
      // we do this by NOT claiming any transactions. irdy check is not needed.
      // All states actually have it deasserted in STD_HDR it gets set in
      // the state before SB_DONE, Shows up in SB_DONE and is cleared there.

      np_quiesce                             = (nstate.state    == SB_STD_HDR) &                      // No non-posted message pending 
                                               ~nstate.got_port_msbs           &
                                               ~cpending                       &                      // No egress completion pending
                                               sif_gpsb_quiesce_req_q                               ; // Quiesce signal 

      pc_quiesce                             = (((pstate.state  == SB_STD_HDR) &                      // No posted message pending
                                                 (~pstate.got_port_msbs |
                                                  (sbe_tgt_tmsg_pcpayload_in[23:16] == HQMEPSB_FORCEPWRGATEPOK))) |
                                                (pstate.opcode  == HQMEPSB_FORCEPWRGATEPOK)) &        // Exception is ForcePwrGatePOK   
                                               (cmplstate.state == CPL_STD_HDR)              &        // No ingress completion pending
                                               ~cmplstate.got_port_msbs                      &
                                               sif_gpsb_quiesce_req_q                               ; // Quiesce signal 

      // All non-posted register access messages are claimed by this target +  any messages

      tgt_sbe_tmsg_npclaim                   = ~np_quiesce &                                          // Not in special mode to drop/UR NP's
                                               sbe_tgt_tmsg_npput_in & ~sbe_tgt_tmsg_npmsgip_in &
                                               ((np_opcode == HQMEPSB_MRD)   |
                                                (np_opcode == HQMEPSB_MWR)   |
                                                (np_opcode == HQMEPSB_CFGRD) |
                                                (np_opcode == HQMEPSB_CFGWR)
                                               );
      
      // All legal posted register access messages (writes) are claimed by this target + any messages 
      // jbdiethe: When resetprep is detected, the requirement for the SideBand Target is the 
      // following: Drop Posted and UR Non-Posted.

      tmsg_pclaim                            = (pc_quiesce) ? (                                       // In special mode to drop/UR P's/NP's except FORCEPWRGATEPOK

                                                               ~sbe_tgt_tmsg_pcmsgip_in &
                                                                sbe_tgt_tmsg_pcput_in   &
                                                               ~sbe_tgt_tmsg_pccmpl     &
                                                               (pc_opcode == HQMEPSB_FORCEPWRGATEPOK)

                                                              ) : (                                   // Not in special mode normal claim.

                                                               ~sbe_tgt_tmsg_pcmsgip_in &
                                                                sbe_tgt_tmsg_pcput_in   &
                                                               ~sbe_tgt_tmsg_pccmpl     &
                                                               ((pc_opcode == HQMEPSB_MWR)             |
                                                                (pc_opcode == HQMEPSB_FORCEPWRGATEPOK) |
                                                                (pc_opcode == HQMEPSB_RSPREP))
                                                              );

      // jbdiethe not checking the tag here, it is now used by SpiRead 
      // sbe_tgt_tmsg_pcpayload[26:24] is completion tag 

      tmsg_cclaim                            = ~pc_quiesce &                                          // Not in special mode to drop/UR P's
                                               ~sbe_tgt_tmsg_pcmsgip_in & sbe_tgt_tmsg_pcput_in & 
                                                sbe_tgt_tmsg_pccmpl                                 ; 
      
      // Put is masked if the 1st 4 byte flit is not claimed, and then all other flits
      // will be ignored.

      if(~sbe_tgt_tmsg_pcmsgip_in) begin
        pput                                 = tmsg_pclaim & sbe_tgt_tmsg_pcput_in                  ;
        cput                                 = tmsg_cclaim & sbe_tgt_tmsg_pcput_in                  ; 
      end else begin
        pput                                 = ~pignore    & sbe_tgt_tmsg_pcput_in                  ; 
        cput                                 = ~cignore    & sbe_tgt_tmsg_pcput_in                  ; 
      end
        
      // Put is masked if the 1st 4 byte flit is not claimed, and then all other flits
      // will be ignored.

      if(~sbe_tgt_tmsg_npmsgip_in) begin
        nput                                 = tgt_sbe_tmsg_npclaim & sbe_tgt_tmsg_npput_in         ;
      end else begin
        nput                                 = ~nignore             & sbe_tgt_tmsg_npput_in         ;
      end

      // Pop occurs when the message completes on the target register access
      // interface.  Note, that if an error is detected with the message format, then
      // irdy is not asserted and the message auto-completes 1 cycles later.
      
      // Target register access interface output muxes

      tgt_ip_msg.irdy                        = (np) ? 
                                               (nstate.irdy & ~nstate.err & ~ppop_ff) : 
                                               (pstate.irdy & ~pstate.err & ~npop_ff)               ; 

      tgt_ip_msg.np                          = np                                                   ; 
      tgt_ip_msg.dest                        = np ? nstate.dest    : pstate.dest                    ; 
      tgt_ip_msg.source                      = np ? nstate.source  : pstate.source                  ; 
      tgt_ip_msg.opcode                      = np ? nstate.opcode  : pstate.opcode                  ; 
      tgt_ip_msg.tag                         = np ? nstate.tag     : pstate.tag                     ; 
      tgt_ip_msg.be                          = np ? nstate.be      : pstate.be                      ; 
      tgt_ip_msg.fid                         = np ? nstate.fid     : pstate.fid                     ; 
      tgt_ip_msg.bar                         = np ? nstate.bar     : pstate.bar                     ; 
      tgt_ip_msg.addr                        = np ? nstate.addr    : pstate.addr                    ; 
      tgt_ip_msg.wdata                       = np ? nstate.data    : pstate.data                    ; 
      
      // Generation of the completion for non-posted register accesses
      // If there is no error indicated from the target interface and the non-posted
      // register access was a read, then the completion will carry data, otherwise
      // it will be a completion without data

      cmpd                                   = ~ctarget_cursp & ~nstate.opcode[0] & 
                                               (nstate.opcode < 8'h20)                              ; 
    end 

  always_comb begin

      tgt_sbe_mmsg_pcpayload                 = '0                                                   ;          
      tgt_sbe_mmsg_pceom                     = '0                                                   ; 
      egress_sent_port_msbs_nxt              = egress_sent_port_msbs                                ;

      // Egress Completion Output forming logic - generates the EOM and PAYLOAD

      unique casez (1'b1)

        // The completion is a 4 bytes (completion without data) 

        egress_cmplstate[E_CPL_STD_HDR_BIT]: begin

          if (strap_hqm_16b_portids & ~egress_sent_port_msbs) begin

            egress_sent_port_msbs_nxt        = '1;

            tgt_sbe_mmsg_pcpayload           = {16'd0,
                                                nstate.dest[15:8],
                                                nstate.source[15:8]}                                ;

          end else begin

            egress_sent_port_msbs_nxt        = '0;

            // Completion without data, no header support, always 1 DW completion.

            tgt_sbe_mmsg_pcpayload           = {tx_eh, 3'b0, ctarget_cursp, nstate.tag,
                                                (cmpd) ? 
                                                 SBCOP_CMPD : 
                                                 SBCOP_CMP,
                                                nstate.dest[7:0],
                                                nstate.source[7:0]}                                 ;
            tgt_sbe_mmsg_pceom               = ~cmpd & ~(|TX_EXT_HEADER_SUPPORT)                    ;
          end

        end

        // 8 bytes completion (with 1 dword of read data or SAI without data)

        egress_cmplstate[E_CPL_EXT_HDR_BIT]: begin

            // Completion without data, header support, last header is EOM

            tgt_sbe_mmsg_pcpayload           = {{(32-(SAI_WIDTH+1)-8){1'b0}}, strap_hqm_cmpl_sai, 8'h0};
            tgt_sbe_mmsg_pceom               = ~cmpd &  (|TX_EXT_HEADER_SUPPORT)                    ; 
        end

        // 12 bytes completion (with 2 dwords of read data or 1 DW data plus SAI) 

        egress_cmplstate[E_CPL_DATA_DW1_BIT]: begin

            // Completion with data, EOM depends on MAXBE / be setting, regardless of header support

            tgt_sbe_mmsg_pcpayload           = nstate.data[31:0]                                    ;
            tgt_sbe_mmsg_pceom               = ~(|nstate.be[7:4]) & cmpd                            ; 
        end

        // 16 bytes completion (with 2 DW data plus 1 DW SAI).

        egress_cmplstate[E_CPL_DATA_DW2_BIT]: begin

            // Completion with data, 2nd DW of a 2 DW Completion

            tgt_sbe_mmsg_pcpayload           = nstate.data[63:32]                                   ;
            tgt_sbe_mmsg_pceom               = cmpd                                                 ; 
        end

        default: begin

            tgt_sbe_mmsg_pcpayload           = '0                                                   ;          
            tgt_sbe_mmsg_pceom               = '0                                                   ; 

        end

      endcase

  end

  generate
    if (|RX_EXT_HEADER_SUPPORT) begin: rx_hdr_support_p
        always_comb begin
            tgt_ip_msg.eh                    = np ? 
                                               nstate.eh         : pstate.eh                        ; 
            tgt_ip_msg.ext_header            = np ? 
                                               nstate.ext_hdr    : pstate.ext_hdr                   ; 
            tgt_ip_msg.eh_discard            = np ? 
                                               nstate.eh_discard : pstate.eh_discard                ; 
        end
    end else begin: no_rx_hdr_support_p
        always_comb begin
            tgt_ip_msg.eh                    = '0                                                   ; 
            tgt_ip_msg.ext_header            = '0                                                   ; 
            tgt_ip_msg.eh_discard            = '0                                                   ; 
        end
    end
  endgenerate


  always_comb begin

      pstate_nxt                             = nxtstate(pstate, 
                                                        strap_hqm_16b_portids,
                                                        ppop, 
                                                        pput, 
                                                        sbe_tgt_tmsg_pceom_in, 
                                                        sbe_tgt_tmsg_pcpayload_in)                  ; 

      nstate_nxt                             = nxtstate(nstate, 
                                                        strap_hqm_16b_portids,
                                                        npop, 
                                                        nput, 
                                                        sbe_tgt_tmsg_npeom_in,
                                                        sbe_tgt_tmsg_nppayload_in)                  ; 

      cmplstate_nxt                          = cmplnxtstate(cmplstate, 
                                                            strap_hqm_16b_portids,
                                                            cpop, 
                                                            cput, 
                                                            sbe_tgt_tmsg_pceom_in,
                                                            sbe_tgt_tmsg_pcpayload_in)              ; 
  end  


  always_ff @(posedge clk or negedge rst_b) begin
    if (~rst_b) begin

      pstate.got_port_msbs                  <= '0                                                   ;
      pstate.state                          <= SB_STD_HDR                                           ;
      pstate.err                            <= '0                                                   ;
      pstate.irdy                           <= '0                                                   ;
      pstate.data                           <= '0                                                   ;
      pstate.addr                           <= '0                                                   ;
      pstate.fid                            <= '0                                                   ;
      pstate.be                             <= '0                                                   ;
      pstate.addrlen                        <= '0                                                   ;
      pstate.bar                            <= '0                                                   ;
      pstate.eh                             <= '0                                                   ;
      pstate.eh_discard                     <= '0                                                   ;
      pstate.ext_hdr_cnt                    <= '0                                                   ;
      pstate.ext_hdr                        <= '0                                                   ;
      pstate.tag                            <= '0                                                   ;
      pstate.opcode                         <= '0                                                   ;
      pstate.source                         <= '0                                                   ;
      pstate.dest                           <= '0                                                   ;
      pstate.is_message_w_data              <= '0                                                   ;

      nstate.got_port_msbs                  <= '0                                                   ;
      nstate.state                          <= SB_STD_HDR                                           ;
      nstate.err                            <= '0                                                   ;
      nstate.irdy                           <= '0                                                   ;
      nstate.data                           <= '0                                                   ;
      nstate.addr                           <= '0                                                   ;
      nstate.fid                            <= '0                                                   ;
      nstate.be                             <= '0                                                   ;
      nstate.addrlen                        <= '0                                                   ;
      nstate.bar                            <= '0                                                   ;
      nstate.eh                             <= '0                                                   ;
      nstate.eh_discard                     <= '0                                                   ;
      nstate.ext_hdr_cnt                    <= '0                                                   ;
      nstate.ext_hdr                        <= '0                                                   ;
      nstate.tag                            <= '0                                                   ;
      nstate.opcode                         <= '0                                                   ;
      nstate.source                         <= '0                                                   ;
      nstate.dest                           <= '0                                                   ;
      nstate.is_message_w_data              <= '0                                                   ;

      cmplstate.got_port_msbs               <= '0                                                   ;
      cmplstate.state                       <= CPL_STD_HDR                                          ;
      cmplstate.err                         <= '0                                                   ;
      cmplstate.ursp                        <= '0                                                   ;
      cmplstate.tag                         <= '0                                                   ;
      cmplstate.data                        <= '0                                                   ;
      cmplstate.eh                          <= '0                                                   ;
      cmplstate.eh_discard                  <= '0                                                   ;
      cmplstate.ext_hdr_cnt                 <= '0                                                   ;
      cmplstate.ext_hdr                     <= '0                                                   ;
      cmplstate.opcode                      <= '0                                                   ;
      cmplstate.irdy                        <= '0                                                   ;
      cmplstate.rspdata_put                 <= '0                                                   ;

      egress_cmplstate                      <= E_CPL_STD_HDR                                        ; // 2 : Completion transfer counter

      pignore                               <= '0                                                   ; // 1 : Posted message is being ignored
      nignore                               <= '0                                                   ; // 1 : Non-posted message is being ignored
      cignore                               <= '0                                                   ; // 1 : completion message is being ignored
      np                                    <= '0                                                   ; // 1 : 0=posted / 1=non-posted (traffic class arbiter)
      cirdy                                 <= '0                                                   ; // 1 : Egress Completion is ready
      cpending                              <= '0                                                   ; // 1 : Egress Completion is begin waited for.
      ctarget_cursp                         <= '0                                                   ; // 1 : Egress Completion error (4-8 byte Cpl will be sent)
      egress_sent_port_msbs                 <= '0                                                   ;
      ip_tgt_msg_trdy_ff                    <= '0                                                   ; 
      ip_tgt_cmsg_data_buffer_full          <= '0                                                   ; 
      cput_ff                               <= '0                                                   ;
      ppop_ff                               <= '0                                                   ;
      npop_ff                               <= '0                                                   ;
      sif_gpsb_quiesce_req_q                <= '0                                                   ;

    end else begin
      
      // Capture flops / state update

      pstate                                <= pstate_nxt                                           ; 
      nstate                                <= nstate_nxt                                           ;
      cmplstate                             <= cmplstate_nxt                                        ; 
      cput_ff                               <= cput                                                 ; 
      ppop_ff                               <= ppop                                                 ;
      npop_ff                               <= npop                                                 ;

      if (~cpending) sif_gpsb_quiesce_req_q <= sif_gpsb_quiesce_req                                 ;

      // When master completion is in progress do not receive any np transaction 

      ip_tgt_msg_trdy_ff                    <= (~np) ? 
                                                '0 : 
                                               (ip_tgt_msg_trdy_ff) ? 
                                                block_np_in : 
                                                ip_tgt_msg_trdy                                     ; 
      ip_tgt_cmsg_data_buffer_full          <= (ip_tgt_cmsg_data_buffer_full) ? 
                                                tgt_sbe_mmsg_pcirdy  : 
                                                (ip_tgt_cmsg.dvld | ip_tgt_msg_trdy)                ; 
      
      // Ignore flops are cleared when the eom is recieved and set when the 1st
      // 4 byte flit is received and the message is not claimed

      if (sbe_tgt_tmsg_pcput_in) begin                                                            
        if (sbe_tgt_tmsg_pceom_in) begin                                                                                         
          cignore                           <= '0                                                   ; 
          pignore                           <= '0                                                   ; 
        end else begin
          if (~sbe_tgt_tmsg_pcmsgip_in) begin 
            cignore                         <= ~tmsg_cclaim                                         ; 
            pignore                         <= ~tmsg_pclaim                                         ; 
          end
        end
      end

      if (sbe_tgt_tmsg_npput_in) begin                                                            
        if (sbe_tgt_tmsg_npeom_in) 
          nignore                           <= '0                                                   ; 
        else if (~sbe_tgt_tmsg_npmsgip_in)
          nignore                           <= ~tgt_sbe_tmsg_npclaim                                ; 
      end
      
      // Simple arbiter to switch between posted and non-posted

      if (np)
        np                                  <= ((pstate.irdy  | pput) &                               // Posted state machine has something
                                                (~nstate.irdy | npop) &                               // Non-Posted is no longer busy or has sent a DW. 
                                                 ~tgt_sbe_mmsg_pcirdy &                               // No pending egress CPL pushing into sbebase
                                                 ~ip_tgt_cmsg.dvld) ?                                 // No pending egress completion about to start.
                                                '0 : '1                                             ; 
      else
        np                                  <= ((nstate.irdy  | nput) &                               // Non-Posted state machine has something
                                                (~pstate.irdy | ppop)) ?                              // Posted is no longer busy or has sent a DW.
                                                '1 : '0                                             ;       

      // Non-posted register access completion generation
      // Assert the completion irdy when the non-posted register access message
      // completes on the target interface
      // Update the completion transfer state when a completion transfer completes
      // on the egress port interface

      if (npop & nstate.err) begin
        cirdy                               <= '1                                                   ; 
        ctarget_cursp                       <= nstate.err                                           ; 

      end else if (tgt_sbe_mmsg_pcirdy & sbe_tgt_mmsg_pctrdy & sbe_tgt_mmsg_pcsel) begin

        // Update the completion transfer state when a completion transfer completes
        // on the egress port interface

        if (tgt_sbe_mmsg_pceom) begin

          // If this is the last completion transfer then irdy is de-asserted

          cirdy                             <= '0                                                   ; 
          egress_cmplstate                  <= E_CPL_STD_HDR                                        ; 
          egress_sent_port_msbs             <= '0                                                   ;

        end else if (egress_cmplstate == E_CPL_STD_HDR) begin

          // Otherwise advance to the next transfer

          egress_sent_port_msbs             <= egress_sent_port_msbs_nxt                            ;

          if (~strap_hqm_16b_portids | egress_sent_port_msbs) begin

            egress_cmplstate                <= (|TX_EXT_HEADER_SUPPORT) ? 
                                                E_CPL_EXT_HDR : 
                                                E_CPL_DATA_DW1                                      ; 
          end

        end else if (egress_cmplstate == E_CPL_EXT_HDR) begin

          egress_cmplstate                  <= E_CPL_DATA_DW1                                       ; // Case of Multiple Extended headers not used on HQM

        end else if(egress_cmplstate == E_CPL_DATA_DW1) begin

          egress_cmplstate                  <= E_CPL_DATA_DW2                                       ;

        end

      end else if (ip_tgt_cmsg.dvld |                                                                 // Non Posted Reads Completion
                   ip_tgt_cmsg.vld) begin                                                             // Non Posted Writes Ack/Cpl no data
        cirdy                               <= '1                                                   ;  
        ctarget_cursp                       <= ip_tgt_cmsg.ursp                                     ; // Send the ursp
      end 

      // Re-use the write data flops to capture the read data for the completion

      if (ip_tgt_cmsg.dvld) begin
        nstate.data                         <= ip_tgt_cmsg.data                                     ;
      end

      // Flip a bit to indicate, that the logic is waiting for a pending egress Cpl
      // Clear it when a egress Cpl hits the sbebase

      if (tgt_sbe_mmsg_pceom & tgt_sbe_mmsg_pcirdy & sbe_tgt_mmsg_pctrdy & sbe_tgt_mmsg_pcsel) begin

        cpending                            <= '0                                                   ;

      end else if(nstate.irdy) begin

        // Set it when a non posted transaction issues to the RI.

        cpending                            <= '1                                                   ;

      end

    end

  end
  
  always_comb begin 
      block_np_in                            = tgt_sbe_mmsg_pcirdy                                  ; // till completion has  been  available 
      tgt_ip_cmsg_free                       = ~ip_tgt_cmsg_data_buffer_full                        ; 
  end

  // Form the incoming cmpl msg into a struct to send to the IP

  always_comb begin: stream_cmpl_to_ip_p

      tgt_ip_cmsg.vld                        = cput_ff                                              ;
      tgt_ip_cmsg.dvld                       = cmplstate.rspdata_put & cput_ff                      ;
      tgt_ip_cmsg.eom                        = cmplstate.irdy                                       ;
      tgt_ip_cmsg.op                         = cmplstate.opcode                                     ;
      tgt_ip_cmsg.tag                        = cmplstate.tag                                        ;
      tgt_ip_cmsg.rsp                        = {1'b0, cmplstate.ursp}                               ; // ri_iosf_sb only send bottom bit
      tgt_ip_cmsg.data                       = cmplstate.data[31:0]                                 ;
  end

  // Almost the same as tgt_idle except pstate will be in SB_DONE since its sending
  // the ResetPRep and it wont get the handshake till the resetprepack is done.

  assign tgt_quiesced                        = (((pstate.state  == SB_STD_HDR) &
                                                 (~pstate.got_port_msbs | 
                                                  (sbe_tgt_tmsg_pcpayload_in[23:16] == HQMEPSB_FORCEPWRGATEPOK))) |
                                                (pstate.opcode  == HQMEPSB_FORCEPWRGATEPOK)) &        // ForcePwrGatePok is an exception.
                                               (nstate.state    == SB_STD_HDR)               & 
                                               ~nstate.got_port_msbs                         &
                                               (cmplstate.state == CPL_STD_HDR)              &
                                               ~cmplstate.got_port_msbs                             ;

  assign sif_gpsb_quiesce_ack_nxt            = ~cpending & tgt_quiesced & sif_gpsb_quiesce_req_q    ; // Egress Cpl (mst) finished and Target Quiesced.

  always_ff @(posedge clk or negedge rst_b) begin: sb_tgt_gen_vote_signal_p
    if (~rst_b) begin
      sif_gpsb_quiesce_ack                  <= '0                                                   ;
    end else begin
      sif_gpsb_quiesce_ack                  <= sif_gpsb_quiesce_ack_nxt                             ; 
    end
  end

  // Debug Signals

  logic [2:0] nstate_enc;
  logic [2:0] pstate_enc;
  logic [1:0] egress_cmplstate_enc;

  always_comb begin

         if (nstate.state == 7'b1000000) nstate_enc = 3'd6;
    else if (nstate.state == 7'b0100000) nstate_enc = 3'd5;
    else if (nstate.state == 7'b0010000) nstate_enc = 3'd4;
    else if (nstate.state == 7'b0001000) nstate_enc = 3'd3;
    else if (nstate.state == 7'b0000100) nstate_enc = 3'd2;
    else if (nstate.state == 7'b0000010) nstate_enc = 3'd1;
    else if (nstate.state == 7'b0000001) nstate_enc = 3'd0;
    else                                 nstate_enc = 3'd7;

         if (pstate.state == 7'b1000000) pstate_enc = 3'd6;
    else if (pstate.state == 7'b0100000) pstate_enc = 3'd5;
    else if (pstate.state == 7'b0010000) pstate_enc = 3'd4;
    else if (pstate.state == 7'b0001000) pstate_enc = 3'd3;
    else if (pstate.state == 7'b0000100) pstate_enc = 3'd2;
    else if (pstate.state == 7'b0000010) pstate_enc = 3'd1;
    else if (pstate.state == 7'b0000001) pstate_enc = 3'd0;
    else                                 pstate_enc = 3'd7;

         if (egress_cmplstate == 4'b1000) egress_cmplstate_enc = 3'd3;
    else if (egress_cmplstate == 4'b0100) egress_cmplstate_enc = 3'd2;
    else if (egress_cmplstate == 4'b0010) egress_cmplstate_enc = 3'd1;
    else                                  egress_cmplstate_enc = 3'd0;

    tgt_dbgbus = {cirdy,
                  ctarget_cursp,
                  egress_cmplstate_enc,
                  nignore,
                  pignore,
                  np,
                  nstate.irdy | pstate.irdy,
                  nstate.err,
                  nstate_enc,
                  pstate.err,
                  pstate_enc
    };

  end


  //-------------------------------------------------------------------------
  // Assertions
  //-------------------------------------------------------------------------

  `ifndef INTEL_SVA_OFF 

  POSTED_NO_EOM_BEFORE_SB_DONE_STATE: assert property (@(posedge clk) disable iff (~rst_b) 
    (~((pstate.state != SB_DONE) & (pstate.irdy)))) else
    $error ("Error: Posted - EOM/irdy is asserted outside the SB_DONE state which should never happen.");
  NONPOSTED_NO_EOM_BEFORE_SB_DONE_STATE: assert property (@(posedge clk) disable iff (~rst_b) 
    (~((nstate.state != SB_DONE) & (nstate.irdy)))) else
    $error ("Error: NonPosted - EOM/irdy is asserted outside the SB_DONE state which should never happen.");
  COMPLETION_NO_EOM_BEFORE_SB_DONE_STATE: assert property (@(posedge clk) disable iff (~rst_b) 
    (~((cmplstate.state != CPL_DONE) & (cmplstate.irdy)))) else
    $error ("Error: Completion - EOM/irdy is asserted outside the CPL_DONE state which should never happen.");

  POSTED_NO_EOM_IN_SB_DONE_STATE: assert property (@(posedge clk) disable iff (~rst_b) 
    (~((pstate.state == SB_DONE) & (~pstate.irdy)))) else
    $error ("Error: Posted - EOM/irdy must be asserted in the SB_DONE state.")                      ;
  NONPOSTED_NO_EOM_IN_SB_DONE_STATE: assert property (@(posedge clk) disable iff (~rst_b) 
    (~((nstate.state == SB_DONE) & (~nstate.irdy)))) else
    $error ("Error: NonPosted - EOM/irdy must be asserted in the SB_DONE state.")                   ;
  COMPLETION_NO_EOM_IN_SB_DONE_STATE: assert property (@(posedge clk) disable iff (~rst_b) 
    (~((cmplstate.state == CPL_DONE) & (~cmplstate.irdy)))) else
    $error ("Error: Completion - EOM/irdy must be asserted in the CPL_DONE state.")                 ;

  POSTED_ERROR_IN_STATE: assert property (@(posedge clk) disable iff (~rst_b) 
    ((~(pstate.err)))) else
    $error ("Error: Posted - err bit flipped, check the previous state S=%h D=%h OP=%h cur_state=%s prev_state=%s.",
            pstate.source, pstate.dest, pstate.opcode, pstate.state, $past(pstate.state))           ;
  NONPOSTED_ERROR_IN_STATE: assert property (@(posedge clk) disable iff (~rst_b) 
    ((~(nstate.err)))) else
    $error ("Error: NonPosted - err bit flipped, check the previous state S=%h D=%h OP=%h cur_state=%s prev_state=%s.",
            nstate.source, nstate.dest, nstate.opcode, nstate.state, $past(nstate.state))           ;
  COMPLETION_ERROR_IN_STATE: assert property (@(posedge clk) disable iff (~rst_b) 
    ((~(cmplstate.err)))) else
    $error ("Error: Completion - err bit flipped, check the previous state OP=%h cur_state=%s prev_state=%s.",
            cmplstate.opcode, cmplstate.state, $past(cmplstate.state));

  POSTED_DEFAULT_STATE_DETECTED: assert property (@(posedge clk) disable iff (~rst_b) 
    ($countones(pstate.state) == 1)) else
    $error ("Error: Posted - Transition to Default state detected. S=%h D=%h OP=%h cur_state=%s prev_state=%s.",
            pstate.source, pstate.dest, pstate.opcode, pstate.state, $past(pstate.state))           ;
  NONPOSTED_DEFAULT_STATE_DETECTED: assert property (@(posedge clk) disable iff (~rst_b) 
    ($countones(nstate.state) == 1)) else
    $error ("Error: NonPosted - Transition to Default state detected. S=%h D=%h OP=%h cur_state=%s prev_state=%s.",
            nstate.source, nstate.dest, nstate.opcode, nstate.state, $past(nstate.state))           ;

  // HSD COMMSIP [BUG][5314365][Rev:2][CPM 1.75][New_Bug]
  //   [CLONE from commsip: CLONE from bell_creek: [LBG-AC] : CPM Sideband Lockup due to backpressure]
  // When a Non Posted is overlapped by a Posted right as the completion for the NP is about 
  // to be returned the Simple Arbiter can change resulting in the eating of the EOM.
  //
  // Arbiter must stay on NP till the egress completion is taken by sbebase. Otherwise the
  // EOM indicater on the egress Cpl gets lost.
  logic                                      p_arb2posted_egress_cpl_active_inst                    ;  

  assign p_arb2posted_egress_cpl_active_inst = (ip_tgt_cmsg.dvld | cirdy) & ~np                     ; 
  //ARB2POSTED_EGRESS_CPL_ACTIVE: assert property (@(posedge clk) disable iff (~rst_b) 
  //  (~p_arb2posted_egress_cpl_active_inst)) else
  //  $error ("Error: Egress Cpl active, arbiter moved to P from NP too early. EOM lost.")          ;


  //////////////////////////////////
  // Reset Prep Quiesce Assertions

  // The SB Target signals to the EP must never assert during quiesce after vote. 
  DURING_RSPREP_QUIESCE_NO_SB_TGT_TRAFFIC_TO_EP: assert property (@(posedge clk) disable iff (~rst_b) 
    (~(sif_gpsb_quiesce_ack & ((tgt_ip_msg.irdy & (tgt_ip_msg.opcode != HQMEPSB_FORCEPWRGATEPOK)) | 
                                  tgt_ip_cmsg.vld)))) else
    $error ("Error: SB TGT should never issue an ingress CPL, P, NP to EP during quiesce.")         ;

  // State machine should never move out of the start states. 
  DURING_RSPREP_QUIESCE_STAY_IN_START_STATE: assert property (@(posedge clk) disable iff (~rst_b) 
    (~(sif_gpsb_quiesce_ack & 
       ((cmplstate.state  != CPL_STD_HDR  )                                             |
        (nstate.state     != SB_STD_HDR   )                                             |
         nstate.got_port_msbs                                                           |
        (pstate.got_port_msbs &
         (sbe_tgt_tmsg_pcpayload_in[23:16] != HQMEPSB_FORCEPWRGATEPOK) &
         (pstate.opcode     != HQMEPSB_FORCEPWRGATEPOK))                                |
        (egress_cmplstate   != E_CPL_STD_HDR)                                           |
        ((pstate.state      != SB_STD_HDR   ) & (pstate.opcode != HQMEPSB_FORCEPWRGATEPOK)))))) else
    $error ("Error: SB TGT FSMs should stay in start states during quiesce.")                       ;

  // The claim signals should never assert
  DURING_RSPREP_P_NP_C_CLAIM_SIGNALS_ZERO: assert property (@(posedge clk) disable iff (~rst_b) 
    (~(sif_gpsb_quiesce_ack & (tgt_sbe_tmsg_npclaim                                 |
                                 tmsg_cclaim                                          |    
                                 (tmsg_pclaim & (pc_opcode != HQMEPSB_FORCEPWRGATEPOK)))))) else
    $error ("Error: SB TGT FSMs should stay in start states during quiesce.")                       ;
    
  // The SB Egress (MST) Cpl should never send anything during quiesce after the vote is sent.
  DURING_RSPREP_QUIESCE_NO_EGRESS_CPL_ALLOWED: assert property (@(posedge clk) disable iff (~rst_b) 
    (~(sif_gpsb_quiesce_ack & tgt_sbe_mmsg_pcirdy))) else
    $error ("Error: SB TGT should never send an egress EGRESS CPL during quiesce.")                 ;


  ///////////////////////////////////////////////////////////////////////////
  // Coverage
  ///////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////
  // Reset Prep Quiesce Logic Coverage

  // A quiesce signal is received in the middle of a pending egress completion
  RSPREP_QUIESCE_PENDING_EGRESS_C_CAUSED_VOTE: cover property (@(posedge clk) disable iff (~rst_b) 
    (~sif_gpsb_quiesce_ack & sif_gpsb_quiesce_ack_nxt & 
     $past(cpending) & ~cpending))                                                                  ; 

  // Other ways to generate a vote ingress P/NP/CPL
  RSPREP_QUIESCE_PENDING_INGRESS_P_CAUSED_VOTE: cover property (@(posedge clk) disable iff (~rst_b) 
    (~sif_gpsb_quiesce_ack & sif_gpsb_quiesce_ack_nxt & 
     $past(pstate.state != SB_STD_HDR) & (pstate.state == SB_STD_HDR)))                             ; 

  RSPREP_QUIESCE_PENDING_INGRESS_NP_CAUSED_VOTE: cover property (@(posedge clk) disable iff (~rst_b) 
    (~sif_gpsb_quiesce_ack & sif_gpsb_quiesce_ack_nxt & 
     $past(nstate.state != SB_STD_HDR) & (nstate.state == SB_STD_HDR)))                             ; 

  RSPREP_QUIESCE_PENDING_INGRESS_C_CAUSED_VOTE: cover property (@(posedge clk) disable iff (~rst_b) 
    (~sif_gpsb_quiesce_ack & sif_gpsb_quiesce_ack_nxt &
    ($past(cmplstate.state != CPL_STD_HDR) & (cmplstate.state == CPL_STD_HDR))))                    ;

  `endif

endmodule
