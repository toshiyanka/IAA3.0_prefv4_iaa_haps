//
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2021 Intel Corporation All Rights Reserved.
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
//  2021WW02_PICr35
//
//  Module sbetrgtreg : The target register access interface block within the
//                      sideband interface endpoint (sbendpoint).
//
//------------------------------------------------------------------------------


// lintra push -60020, -60088, -80028, -80095, -68001, -60024b, -50002, -2050, -70036_simple, -70044_simple, -60145
// 52523 : Repeated (local) parameter: ... (e.g. NUM_ACTUAL_RX_EXT_HEADERS). Already defined in ....
// lintra push -52523

module hqm_sbetrgtreg #(
    parameter INTERNALPLDBIT        = 7, // Maximum payload bit, should be 7, 15 or 31
    parameter SB_PARITY_REQUIRED    = 0, // parity enable parameter
    parameter MAXTRGTADDR           = 31,
    parameter MAXTRGTDATA           = 63,
    parameter RX_EXT_HEADER_SUPPORT = 0, // set to nonzero if extended headers can be received.
    parameter NUM_RX_EXT_HEADERS    = 0, // number of extended headers to receive,
                                         // used to size register bank to hold headers
    parameter [NUM_RX_EXT_HEADERS:0][6:0] RX_EXT_HEADER_IDS = '0,
                                         // vector to indicate supported extended header IDs,
                                         // any unsupported headers are discarded
    parameter NUM_TX_EXT_HEADERS    = 0, // number of headers to transmit for completions.
    parameter TX_EXT_HEADER_SUPPORT = 0,
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - START
   parameter UNIQUE_EXT_HEADERS     = 0,  // set to 1 to make the register agent modules use the new extended header
   parameter SAIWIDTH               = 15, // SAI field width - MAX=15
   parameter RSWIDTH                = 3,  // RS field width - MAX=3
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - FINISH
// Hier Bridge PCR
   parameter GLOBAL_EP              = 0,
   parameter GLOBAL_EP_IS_STRAP     = 0
) (
  // Clock/Reset Signals
  input  logic                           side_clk, 
  input  logic                           side_rst_b,
  
  // Interface to the clock gating ISM
  output logic                           idle_trgtreg,
  input  logic                           sbe_sbi_idle,

  // Parity support
  input  logic                           cfg_parityckdef, // lintra s-70036, s-0527 parity defeature
  input  logic                           ext_parity_err_detected,
  output logic                           treg_tmsg_parity_err_det,
  // Interface to the target side of the base endpoint (sbebase)
  input  logic                           global_ep_strap, // lintra s-70036, s-0527 only for global EP
  input  logic                           tmsg_pcput,
  input  logic                           tmsg_npput,
  input  logic                           tmsg_pcmsgip,
  input  logic                           tmsg_npmsgip,
  input  logic                           tmsg_pceom,
  input  logic                           tmsg_npeom,
  input  logic                           tmsg_pcparity, // lintra s-70036, s-0527
  input  logic                           tmsg_npparity, // lintra s-70036, s-0527
  input  logic [INTERNALPLDBIT:0]        tmsg_pcpayload,
  input  logic [INTERNALPLDBIT:0]        tmsg_nppayload,
  output logic                           tmsg_pcfree,
  output logic                           tmsg_npfree,
  output logic                           tmsg_npclaim,

  input  logic [NUM_TX_EXT_HEADERS:0][31:0] tx_ext_headers, // lintra s-70036 s-0527 "With unique ext support this may not get used all the time"

// HIER Header inputs
  input  logic [INTERNALPLDBIT:0]       tmsg_hdr_pcpayload, // lintra s-70036 s-0527 "used only in global EP mode"
  input  logic							tmsg_hdr_pcput, // lintra s-70036 s-0527 "used only in global EP mode"
  input  logic							tmsg_hdr_pcmsgip, // lintra s-70036 s-0527 "used only in global EP mode"
  input  logic							tmsg_hdr_pceom, // lintra s-70036 s-0527 "used only in global EP mode"
  input  logic							tmsg_hdr_pcparity, // lintra s-70036 s-0527 "used only in global EP mode"
  input  logic [INTERNALPLDBIT:0]		tmsg_hdr_nppayload, // lintra s-70036 s-0527 "used only in global EP mode"
  input  logic							tmsg_hdr_npput, // lintra s-70036 s-0527 "used only in global EP mode"
  input  logic							tmsg_hdr_npmsgip, // lintra s-70036 s-0527 "used only in global EP mode"
  input  logic							tmsg_hdr_npeom, // lintra s-70036 s-0527 "used only in global EP mode"
  input  logic							tmsg_hdr_npparity, // lintra s-70036 s-0527 "used only in global EP mode"
      
  // Interface to the master side of the base endpoint (sbebase)
  // for sending completions for the non-posted target messages
  input  logic                           mmsg_pcsel,
  input  logic                           mmsg_pctrdy,
  output logic                           mmsg_pcirdy,
  output logic                           mmsg_pceom,
  output logic                           mmsg_pcparity,
  output logic [INTERNALPLDBIT:0]        mmsg_pcpayload,

  // Target Register Access Interface
                                                      // From the cluster:
  input  logic                           treg_trdy,   //   Ready to complete
                                                      //   register access msg
  input  logic                           treg_cerr,   //   Completion error
  input  logic [MAXTRGTDATA:0]           treg_rdata,  //   Read data
                                                      // From the endpoint
  output logic                           treg_irdy,   //   Endpoint ready
  output logic                           treg_np,     //   1=non-posted/0=posted
  output logic                           treg_eh,     //   state of 'eh' bit in standard header
  output logic [NUM_RX_EXT_HEADERS:0][31:0] treg_ext_header, // received extended headers
  output logic                           treg_eh_discard, // indicates unsupported header discarded
  output logic                     [7:0] treg_dest,   //   Destination Port ID
  output logic                     [7:0] treg_source, //   Source Port ID
  output logic                     [7:0] treg_opcode, //   Reg access opcode
  output logic                           treg_addrlen,//   Address length
  output logic                     [2:0] treg_bar,    //   Selected BAR
  output logic                     [2:0] treg_tag,    //   Transaction tag
  output logic [(MAXTRGTDATA == 31 ? 3 : 7):0] treg_be,     //   Byte enables
  output logic                     [7:0] treg_fid,    //   Function ID
  output logic [MAXTRGTADDR:0]           treg_addr,   //   Address
  output logic [MAXTRGTDATA:0]           treg_wdata,  //   Write data

// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
  input  logic                           treg_csairs_valid,   // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  input  logic [SAIWIDTH:0]              treg_csai,           // lintra s-70036 s-0527 "SAI value for extended headers"
  input  logic [ RSWIDTH:0]              treg_crs,            // lintra s-70036 s-0527 "RS value for extended headers"
  output logic                           treg_rx_sairs_valid, // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  output logic [SAIWIDTH:0]              treg_rx_sai,         // lintra s-70036 s-0527 "SAI value for extended headers"
  output logic [ RSWIDTH:0]              treg_rx_rs,          // lintra s-70036 s-0527 "RS value for extended headers"
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH

// Hier Bridge PCR
  output logic [7:0]                     treg_hier_destid,
  output logic [7:0]                     treg_hier_srcid,
// outputs for Hier Completion
  output logic [7:0]                     np_hier_destid, // lintra s-2058 "used only in global EP mode"
  output logic [7:0]                     np_hier_srcid, // lintra s-2058 "used only in global EP mode"

  // Debug Signals
  output logic                    [15:0] dbgbus
);

`include "hqm_sbcfunc.vm"
`include "hqm_sbcglobal_params.vm"
  

// PCR 12042104 - Unique Extended Headers localparameter assignments - START
   // Add up all the supported unique extended headers to give a non-zero value
   // if TX_EXT_HEADER_SUPPORT is present
  localparam NUM_UNIQUE_EH              = (TX_EXT_HEADER_SUPPORT == 0) ? 0 : UNIQUE_EXT_HEADERS; 
  localparam NUM_TX_EH                  = (NUM_UNIQUE_EH > 0) ? 127 : NUM_TX_EXT_HEADERS;
  localparam NUM_ACTUAL_RX_EXT_HEADERS  = (NUM_UNIQUE_EH > 0) ? 0 : NUM_RX_EXT_HEADERS;
  localparam [NUM_ACTUAL_RX_EXT_HEADERS:0][6:0] ACTUAL_RX_EXT_HEADER_IDS  = (NUM_UNIQUE_EH > 0) ? {EHOP_SAIRS} : RX_EXT_HEADER_IDS;
// PCR 12042104 - Unique Extended Headers localparameter assignments - FINISH
  localparam MAXADDR                    = MAXTRGTADDR; 
  localparam MINADDR                    = MAXADDR==15 ? 15 : 16;
  localparam MAXDATA                    = MAXTRGTDATA; 
  localparam MAXBE                      = (MAXTRGTDATA == 31) ? 3 : 7;
  localparam logic [31:0]      ALLONES  = '1;
  localparam logic [31:0]      ADDRMASK = ALLONES << (MAXADDR-15); // lintra s-2063
  localparam ADDRMOD                    = (MAXADDR+1)%(INTERNALPLDBIT+1);
  localparam MAXADDRSTART               = ( MAXADDR < 15) ? ((INTERNALPLDBIT == 15) ? 32 : ((INTERNALPLDBIT == 7) ? 40 : 16)): 16;
  localparam MAXADDREND                 = ( MAXADDR < 15) ? 15: MAXADDR; 
  localparam DW2MIN                     = MAXDATA==63 ? 32 : 0;
  localparam DW2BEMIN                   = MAXBE==7 ? 4 : 0;
  localparam NUM_TX_EXT_HEADERS_L2      = sbc_indexed_value ( NUM_TX_EH ); // PCR 12042104 - Overloading tx_eh_cnt
  localparam NUM_RX_EXT_HEADERS_L2      = sbc_indexed_value ( NUM_ACTUAL_RX_EXT_HEADERS );

//  |eh|al|  bar   |  tag   |         opcode        |         source        |         dest          |     
//  |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|   32bit width
//  |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|   15bit width
//  | 7| 6| 5| 4| 3| 2| 1| 0| 7| 6| 5| 4| 3| 2| 1| 0| 7| 6| 5| 4| 3| 2| 1| 0| 7| 6| 5| 4| 3| 2| 1| 0|   7bit width

  localparam SRC_START      = (INTERNALPLDBIT ==7) ? 0 : 8;
  localparam OPC_START      = (INTERNALPLDBIT ==31) ? 16 : 0;
  localparam TAG_START      = (INTERNALPLDBIT ==31) ? 24 : ((INTERNALPLDBIT ==15) ? 8 : 0);
  localparam BAR_START      = (INTERNALPLDBIT ==31) ? 27 : ((INTERNALPLDBIT ==15) ? 11 : 3);
  localparam ADDRLEN_BIT    = (INTERNALPLDBIT ==31) ? 30 : ((INTERNALPLDBIT ==15) ? 14 : 6);
  localparam SBC_COP_START  = (INTERNALPLDBIT ==31) ? 16 : 0;
  localparam HDRSTART       = (INTERNALPLDBIT ==7) ? 0 : 8;
  
 
logic treg_pc_first_byte;
logic treg_pc_second_byte;
logic treg_pc_third_byte;
logic treg_pc_last_byte;
logic treg_np_first_byte;
logic treg_np_second_byte;
logic treg_np_third_byte;
logic treg_np_last_byte;
logic treg_mmsg_pc_first_byte; // lintra s-70036
logic treg_mmsg_pc_second_byte;
logic treg_mmsg_pc_third_byte;
logic treg_mmsg_pc_last_byte;

generate
    if (INTERNALPLDBIT ==31) begin: gen_treg_be_31
        always_comb begin
            treg_pc_first_byte  = 1'b1;
            treg_pc_second_byte = 1'b1;
            treg_pc_third_byte  = 1'b1;
            treg_pc_last_byte   = 1'b1;
            treg_np_first_byte  = 1'b1;
            treg_np_second_byte = 1'b1;
            treg_np_third_byte  = 1'b1;
            treg_np_last_byte   = 1'b1;
            treg_mmsg_pc_first_byte  = 1'b1;
            treg_mmsg_pc_second_byte = 1'b1;
            treg_mmsg_pc_third_byte  = 1'b1;
            treg_mmsg_pc_last_byte   = 1'b1;
        end
    end
    else begin: gen_treg_be_15_7
        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_treg_trgt_pc (
            .side_clk           (side_clk),
            .side_rst_b         (side_rst_b),
            .valid              (tmsg_pcput),
            .first_byte         (treg_pc_first_byte),
            .second_byte        (treg_pc_second_byte),
            .third_byte         (treg_pc_third_byte),
            .last_byte          (treg_pc_last_byte)
        );

        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_treg_trgt_np (
            .side_clk           (side_clk),
            .side_rst_b         (side_rst_b),
            .valid              (tmsg_npput),
            .first_byte         (treg_np_first_byte),
            .second_byte        (treg_np_second_byte),
            .third_byte         (treg_np_third_byte),
            .last_byte          (treg_np_last_byte)
        );

        logic   treg_mmsg_pc_valid;
        
        always_comb treg_mmsg_pc_valid = mmsg_pcirdy & mmsg_pctrdy & mmsg_pcsel; 
        
        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_treg_mmsg_pc (
            .side_clk           (side_clk),
            .side_rst_b         (side_rst_b),
            .valid              (treg_mmsg_pc_valid),
            .first_byte         (treg_mmsg_pc_first_byte),
            .second_byte        (treg_mmsg_pc_second_byte),
            .third_byte         (treg_mmsg_pc_third_byte),
            .last_byte          (treg_mmsg_pc_last_byte)
        );
    end
endgenerate

// Parity checking
logic parity_err_out;
logic treg_input_parity_err;
logic parity_err_out_nxt;

generate 
    if (SB_PARITY_REQUIRED) begin : gen_treg_par
        logic parity_err_out_d;

        always_comb parity_err_out_d = tmsg_pcput ? (^{tmsg_pcpayload, tmsg_pceom, tmsg_pcparity} & ~cfg_parityckdef): 
                                      (tmsg_npput ? (^{tmsg_nppayload, tmsg_npeom, tmsg_npparity} & ~cfg_parityckdef): '0);

        always_comb parity_err_out_nxt = (parity_err_out_d | parity_err_out);

        always_ff @(posedge side_clk or negedge side_rst_b)
            if (~side_rst_b) 
                parity_err_out <= '0;
            else if (parity_err_out_d)
                parity_err_out <= 1'b1;
    end
    else begin : gen_treg_nopar
        always_comb parity_err_out      = 1'b0;
        always_comb parity_err_out_nxt  = 1'b0;
    end
endgenerate
// parity_err_out_nxt is the actual err with corresponding input data,eom,parity from tmsg. 
// and is wired to treg output (which is once again fed into tmsg to stop any further trdy's.
// But connecting parity_err_out_nxt directly to treg output causes combi loop 
// tmsg_put --> pariy_err_out --> treg_tmsg_parity_err_det -->tmsg_trdy (mask)-->tmsg_put
// Hence use a flopped parity_err_out to be sent out on treg.
// IP's using treg_tmsg_parity_err should not send any payload as soon as they see this asserted.

always_comb treg_tmsg_parity_err_det = parity_err_out;
always_comb treg_input_parity_err = (treg_tmsg_parity_err_det | parity_err_out_nxt | ext_parity_err_detected);

  // Structure for capturing the posted/non-posted register access message
  // and the current transfer count and irdy signal.
  typedef struct packed unsigned { // lintra s-60056 "maybe fix type def at a later date."
                  logic       [3:0] count;        // Current 4 byte flit transfer count
                  logic             err;          // Error detected in received message
                  logic             irdy;         // Message ready
                  logic [MAXDATA:0] data;         // Read/write data
                  logic [MAXADDR:0] addr;         // Address of the message
                  logic       [7:0] fid;          // Function ID
                  logic   [MAXBE:0] be;           // Byte enables (4 or 8 bits)
                  logic             addrlen;      // Address length (0=16bit / 1=48bit)
                  logic       [2:0] bar;          // Selected BAR
                  logic             eh;           // "EH" bit from standard header.
                  logic             eh_discard;   // unknown extended header has been dropped.
                  logic [NUM_RX_EXT_HEADERS_L2:0]           ext_hdr_cnt; // counts number of ext headers received.
                  logic [NUM_ACTUAL_RX_EXT_HEADERS:0][31:0] ext_hdr; // extended headers
                  logic       [2:0] tag;          // Message tag
                  logic       [7:0] opcode;       // Message opcode
                  logic       [7:0] source;       // Source port ID
                  logic       [7:0] dest;         // Destination port ID
                  logic       [7:0] source_f;
                  logic       [7:0] dest_f;
                  logic      [23:0] addrbuf;
                  } regstate;
  
  
  // Function for capturing/updating the state of the register access
  // message transfers (posted and non-posted)
function automatic regstate nxtstate( regstate cstate,
                            logic reset,
                            logic pop,
                            logic put,
                            logic eom,
                            logic first_byte,
                            logic second_byte,
                            logic third_byte,
                            logic last_byte,
                            logic msgip,
                            logic [INTERNALPLDBIT:0] data,
                            logic parity_err);
  nxtstate = cstate;


  if (put) begin
// flop the source and destination bits since claim arrives only on the third byte
// put doesnt happen unless a claim happens
    if (first_byte & ~msgip)   nxtstate.dest_f   = data[7:0];
    if (second_byte & ~msgip)  nxtstate.source_f = data[(SRC_START+7):SRC_START];
        
    nxtstate.irdy = eom & ~parity_err;
    casez ( {cstate.irdy, cstate.count} )// lintra s-2045, s-60129 "adding unique casez creates another lintra error (2044)

      // Transfer 0: Dest/Source Port IDs, tag, bar, addrlen
      5'b1????,
      5'b00000 : begin
                  nxtstate.count      = (|RX_EXT_HEADER_SUPPORT & data[INTERNALPLDBIT] & last_byte) ? 4'b1000 : (last_byte ? 4'b0001 : 4'b0000); // go to EH state if 'eh' bit is set.
                  // An error occurs if this is only a 4 byte message.  All
                  // register access messages must be at least 8 bytes.
                  // "and" with byte enables will reset the value of these functions when the byte enable falls to 0, this block would hold the values
                  nxtstate.err        = eom;
                  //if (first_byte)           nxtstate.dest       = data[7:0];
                  if (first_byte)           nxtstate.dest       = nxtstate.dest_f;
                  //if (second_byte)          nxtstate.source     = data[(SRC_START+7):SRC_START];
                  if (second_byte)          nxtstate.source     = nxtstate.source_f;
                  if (third_byte)           nxtstate.opcode     = data[(OPC_START+7):OPC_START];
                  if (last_byte) begin
                                            nxtstate.tag        = data[(TAG_START+2):TAG_START];
                                            nxtstate.bar        = data[(BAR_START+2):BAR_START];
                                            nxtstate.addrlen    = data[ADDRLEN_BIT];
                                            nxtstate.eh         = data[INTERNALPLDBIT];
                                 end
                  nxtstate.be         = '0;
                  nxtstate.fid        = '0;
                  nxtstate.addr       = '0;
                  nxtstate.data       = '0;
                  nxtstate.ext_hdr    = '0;
                  nxtstate.ext_hdr_cnt= '0;
                  nxtstate.eh_discard = '0;
                  nxtstate.addrbuf    = '0;
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
                  regio_underflow: assert (( !eom ) || (reset !== 1'b1) )else
                    $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : REGIO messages must be at least 8 bytes", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
//coverage on
 `endif // SynTranlateOn
`endif
`endif
                end

      // Transfer 1: Byte enables, Requestor ID and 16-bits of address.
      // Minimum message length is 8 bytes for read with 16-bit addrlen
      5'b00001 : begin
                  nxtstate.count      = (cstate.addrlen & last_byte) ? 4'b0010 : (last_byte ? 4'b0011 : 4'b0001);
                  if (first_byte)       nxtstate.be         = data[MAXBE: 0];
                  if (second_byte)      nxtstate.fid        = data[(SRC_START+7)  : SRC_START];
                  if (third_byte)       nxtstate.addr[ 7:0] = data[(OPC_START+7)  : OPC_START];
                  if (last_byte)        nxtstate.addr[15:8] = data[INTERNALPLDBIT : (INTERNALPLDBIT-7)];
                  // Error occurs if the IP block only supports a dword of data
                  // and one of the second byte enables (sbe) are active.  Also
                  // This should not be the eom if this is a write and it should
                  // be the eom if this is a read and address length is 16 bits.
                  //4_17 wait till last byte to check status of eoms
                  nxtstate.err |= (((MAXBE==3) & (|data[7:4])) & first_byte) |
                                  ( cstate.opcode[0] & eom & last_byte)   |
                                  (~cstate.opcode[0] & ~cstate.addrlen & ~eom & last_byte);
                  
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
                 width_violation: assert ( (~( (MAXBE==3) & (|data[7:4]) & first_byte)) ||  (reset !== 1'b1) ) else
                   $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : SBE bits set but endpoint configured for DWORD data access.", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
                 write_underflow: assert (( ~( cstate.opcode[0] & eom & last_byte) )||  (reset !== 1'b1) ) else
                   $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Write message must be more than 2 DWORDS long", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
                 addrlen0_overflow: assert (( ~( ~cstate.opcode[0] & ~cstate.addrlen & ~eom & last_byte) )||  (reset !== 1'b1) ) else
                   $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Read messages with 16bit address must be 2 DWORDS long", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
//coverage on
 `endif // SynTranlateOn
`endif
`endif
                end

      // Transfer 2 contains the upper order address bits, above bit 15
      5'b00010 : begin
                  nxtstate.count = last_byte ? 4'b0011 : 4'b0010;
                  
                  unique casez (INTERNALPLDBIT)
                  31: begin
                        if (MAXADDR > 15)
                            nxtstate.addr[MAXADDR:MINADDR] = data; // lintra s-0396
                      end
                  15: begin 
                        if (first_byte) nxtstate.addrbuf[15: 0] = data; // lintra s-0396
                        // cstate.addr will already have 15:0 bits set from previous message
                        if (third_byte) nxtstate.addr = {data,cstate.addrbuf[15:0],cstate.addr[15:0]}; // lintra s-0396
                      end
             default: begin
                        if (first_byte)     nxtstate.addrbuf[ 7: 0] = data; // lintra s-0396
                        if (second_byte)    nxtstate.addrbuf[15: 8] = data; // lintra s-0396
                        if (third_byte)     nxtstate.addrbuf[23:16] = data; // lintra s-0396
                        if (last_byte)      nxtstate.addr = {data,cstate.addrbuf[23:0],cstate.addr[15:0]}; // lintra s-0396
                      end
                   endcase                  

                  // An error occurs if any of the unsupported address bits are
                  // active, which would cause an aliasing error.  Also an
                  // error occurs if this is not eom for a read and if this
                  // is eom for a write. 
                  unique casez (INTERNALPLDBIT)
                  31: begin
                            nxtstate.err |= (|(ADDRMASK[31:0] & data)) |
                                            ((cstate.opcode[0] == eom) & last_byte);
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
                  invalid_addr: assert (( ~( |(ADDRMASK[31:0] & data) ) )||  (reset !== 1'b1) ) else
                    $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Access to unsupported address range.", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
                  invalid_length: assert (~((cstate.opcode[0] == eom) & last_byte) ||  (reset !== 1'b1) ) else
                    if (cstate.opcode[0])
                      $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Invalid write message length", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
                    else
                      $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Invalid read message length", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
//coverage on
 `endif // SynTranlateOn
`endif
`endif                                                 
                      end
                  15: begin
                            if (MAXADDR==47)
                                nxtstate.err |= ((cstate.opcode[0] == eom) & last_byte);
                            else if ((31<=MAXADDR) && (MAXADDR<47))
                                nxtstate.err |= ((|data[INTERNALPLDBIT:ADDRMOD]) & last_byte) | //lintra s-0393, s-2056
                                                ((cstate.opcode[0] == eom) & last_byte);
                            else //maxaddr<31
                                nxtstate.err |= ((|data[INTERNALPLDBIT:ADDRMOD]) & first_byte) |  //lintra s-0393, s-2056
                                                ((|data[INTERNALPLDBIT:0]) & last_byte) |       //lintra s-0393, s-2056
                                                ((cstate.opcode[0] == eom) & last_byte);                          
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
                  invalid_addr_15bit: assert ( ~(|(ADDRMASK[31:0] & {data,cstate.addrbuf[15:0]} & {31{last_byte}})) ||  (reset !== 1'b1) ) else
                    $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Access to unsupported address range.", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);                            
//coverage on
 `endif // SynTranlateOn
`endif
`endif                                            
                        end
             default: begin
                            if (MAXADDR==47)
                                nxtstate.err |= ((cstate.opcode[0] == eom) & last_byte);
                            else if ((39<=MAXADDR) && (MAXADDR<47))
                                nxtstate.err |= ((|data[INTERNALPLDBIT:ADDRMOD]) & last_byte) |  //lintra s-0393, s-2056
                                                ((cstate.opcode[0] == eom) & last_byte);
                            else if ((31<=MAXADDR) && (MAXADDR<39))
                                nxtstate.err |= ((|data[INTERNALPLDBIT:ADDRMOD]) & third_byte) | //lintra s-0393, s-2056
                                                ((|data[INTERNALPLDBIT:0]) & last_byte) |       //lintra s-0393, s-2056
                                                ((cstate.opcode[0] == eom) & last_byte);
                            else if ((23<=MAXADDR) && (MAXADDR<31))
                                nxtstate.err |= ((|data[INTERNALPLDBIT:ADDRMOD]) & second_byte) | //lintra s-0393, s-2056
                                                ((|data[INTERNALPLDBIT:0]) & third_byte) |       //lintra s-0393, s-2056
                                                ((|data[INTERNALPLDBIT:0]) & last_byte) |       //lintra s-0393, s-2056
                                                ((cstate.opcode[0] == eom) & last_byte);                                
                            else//maxaddr<23
                                nxtstate.err |= ((|data[INTERNALPLDBIT:ADDRMOD]) & first_byte) |   //lintra s-0393, s-2056
                                                ((|data[INTERNALPLDBIT:0]) & second_byte) |       //lintra s-0393, s-2056
                                                ((|data[INTERNALPLDBIT:0]) & third_byte) |       //lintra s-0393, s-2056
                                                ((|data[INTERNALPLDBIT:0]) & last_byte) |       //lintra s-0393, s-2056
                                                ((cstate.opcode[0] == eom) & last_byte);                               
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
                  invalid_addr_7bit: assert ( ~(|(ADDRMASK[31:0] & {data,cstate.addrbuf[23:0]} & {31{last_byte}})) ||  (reset !== 1'b1) ) else
                    $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Access to unsupported address range.", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);                            
//coverage on
 `endif // SynTranlateOn
`endif
`endif                                            
                      end
                   endcase 
                end

      // Transfer 3 contains the first dword of write data
      5'b00011 : begin
                  nxtstate.count  = last_byte ? 4'b0100 : 4'b0011;
                  unique casez (INTERNALPLDBIT)
                  31: nxtstate.data   = data;// lintra s-0393
                  15: begin 
                        if (first_byte) nxtstate.data[15: 0] = data;// lintra s-0393 s-0396
                        if (third_byte) nxtstate.data[31:16] = data;// lintra s-0393 s-0396 
                      end
             default: begin
                        if (first_byte)     nxtstate.data[ 7: 0] = data;// lintra s-0396
                        if (second_byte)    nxtstate.data[15: 8] = data;// lintra s-0396
                        if (third_byte)     nxtstate.data[23:16] = data;// lintra s-0396
                        if (last_byte)      nxtstate.data[31:24] = data;// lintra s-0396
                        end
                   endcase
                                  
                  // An error occurs if the eom value does not match the second
                  // dword byte enables.  If these bits do not exist, then this
                  // should be the eom.  If the bits do exist, then if the
                  // second dword is expected (non-zero be[7:4]) then this
                  // should not be eom, otherwise it should be eom.
                  if (MAXBE==3)
                    begin
                      nxtstate.err |= ~eom & last_byte;
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
                  dw_write_overflow: assert (~( ~eom & last_byte ) ||  (reset !== 1'b1) ) else 
                    $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : MAXBE==3 and eom not asserted", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
//coverage on
 `endif // SynTranlateOn
`endif
`endif        
                    end 
                  else
                    begin
                    //4_17_added last_byte
                      nxtstate.err |= (eom == |cstate.be[MAXBE:DW2BEMIN]) & last_byte;
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
                  qw_write_underflow: assert (~((eom == |cstate.be[MAXBE:DW2BEMIN]) & last_byte) || (reset !== 1'b1))  else
                    $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Invalid EOM state with respect to indicated SBE value: eom=%h, SBE=%h", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode, eom, cstate.be[MAXBE:DW2BEMIN]);
//coverage on
 `endif // SynTranlateOn
`endif
`endif        
                    end
                end

      // Transfer 4 contains the second dword of write data
      5'b00100 : begin
                  nxtstate.count = last_byte ? 4'b0101 : 4'b0100;
                  if (MAXDATA==63)
                  begin
                  unique casez (INTERNALPLDBIT)
                  31: nxtstate.data[MAXDATA:DW2MIN]   = data;// lintra s-0393
                  15: begin 
                        if (first_byte) nxtstate.data[(DW2MIN+15):DW2MIN] = data;// lintra s-0393 s-0396
                        if (third_byte) nxtstate.data[MAXDATA:(DW2MIN+16)] = data;// lintra s-0393 s-0396
                      end
             default: begin
                        if (first_byte)  nxtstate.data[(DW2MIN+7) :      DW2MIN] = data;// lintra s-0396
                        if (second_byte) nxtstate.data[(DW2MIN+15): (DW2MIN+ 8)] = data;// lintra s-0396
                        if (third_byte)  nxtstate.data[(DW2MIN+23): (DW2MIN+16)] = data;// lintra s-0396
                        if (last_byte)   nxtstate.data[MAXDATA    : (DW2MIN+24)] = data;// lintra s-0396
                        end
                   endcase
                   end
                  // This should always be the eom (and last byte) (if it makes it this far).
                  nxtstate.err  |= ~eom & last_byte;
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
                  qw_write_overflow: assert (~(~eom & last_byte) ||  (reset !== 1'b1) ) else
                    $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : EOM not encountered after 2nd DWORD of write data", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
//coverage on
 `endif // SynTranlateOn
`endif
`endif             
                end

      // All other transfers should never occur
      5'b00101 : begin
                  nxtstate.count = 4'b0110;
                  nxtstate.err   = '1;
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
        msg_error1: assert (reset !== 1'b1) else $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Message not ended appropriately", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
//coverage on
 `endif // SynTranlateOn
`endif
`endif             
                end
                  
      5'b00110 : begin
                  nxtstate.count = 4'b0111;
                  nxtstate.err   = '1;
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
        msg_error2: assert (reset !== 1'b1) else $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Message not ended appropriately", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
//coverage on
 `endif // SynTranlateOn
`endif
`endif
                end
                  
      5'b00111 : begin
                  nxtstate.err = '1;
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
        msg_error3: assert (reset !== 1'b1) else $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Message not ended appropriately", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
//coverage on
 `endif // SynTranlateOn
`endif
`endif
                end

      5'b01000 : begin
         nxtstate.err |= eom & last_byte; // HSD BUG: Extended header checks do not have failure checks if EOM in this phase.
         nxtstate.count = (data[7] & first_byte) ? nxtstate.count : (last_byte ? 4'b0001 : 4'b1000); // back to normal state machine if this is the end of headers.
         for (int unsigned i=0; i <= NUM_ACTUAL_RX_EXT_HEADERS; i++)
            if ( (data[6:0] & {7{first_byte}}) == ACTUAL_RX_EXT_HEADER_IDS[i] ) begin
               // bit 7, which is the 'end of eh' bit, is overridden to indicate that this header is valid
               // in this way, the number of headers received is made available to the agent.
               if( |NUM_UNIQUE_EH ) begin
                   unique casez (INTERNALPLDBIT)
                   31: nxtstate.ext_hdr[i] = { data[INTERNALPLDBIT:HDRSTART], 1'b1, data[6:0] };
                   15: begin
                        if (first_byte) nxtstate.ext_hdr[i][15: 0] = {data[INTERNALPLDBIT:HDRSTART], 1'b1, data[6:0]}; // lintra s-0396, s-0393
                        if (third_byte) nxtstate.ext_hdr[i][31:16] = data; // lintra s-0396, s-0393
                       end
                   default: begin
                        if (first_byte) nxtstate.ext_hdr[i][ 7: 0] = {1'b1, data[6:0]}; // lintra s-0396, s-0393
                        if (second_byte)nxtstate.ext_hdr[i][15: 8] = data; // lintra s-0396, s-0393
                        if (third_byte) nxtstate.ext_hdr[i][23:16] = data; // lintra s-0396, s-0393
                        if (last_byte)  nxtstate.ext_hdr[i][31:24] = data; // lintra s-0396, s-0393
                        end
                   endcase
               end else begin
                   unique casez (INTERNALPLDBIT)
                   31: begin
                         for (int entry = 0; entry <= NUM_ACTUAL_RX_EXT_HEADERS; entry++) begin
                            if (nxtstate.ext_hdr_cnt == entry) nxtstate.ext_hdr[entry] = { data[INTERNALPLDBIT:HDRSTART], 1'b1, data[6:0] }; //lintra s-0241
                         end
                       end
                   15: begin
                        if (first_byte) nxtstate.ext_hdr[nxtstate.ext_hdr_cnt][15: 0] = {data[INTERNALPLDBIT:HDRSTART], 1'b1, data[6:0]}; // lintra s-0396, s-0393, s-0241
                        if (third_byte) nxtstate.ext_hdr[nxtstate.ext_hdr_cnt][31:15] =  data; // lintra s-0396, s-0393, s-0241
                       end
                   default: begin
                        if (first_byte) nxtstate.ext_hdr[nxtstate.ext_hdr_cnt][7:0] = {1'b1,data[6:0]}; // lintra s-0396, s-0393, s-2033, s-0241
                        if (second_byte)nxtstate.ext_hdr[nxtstate.ext_hdr_cnt][15:8] = data; // lintra s-0396, s-0393, s-2033, s-0241
                        if (third_byte) nxtstate.ext_hdr[nxtstate.ext_hdr_cnt][23:16] = data; // lintra s-0396, s-0393, s-2033, s-0241
                        if (last_byte)  nxtstate.ext_hdr[nxtstate.ext_hdr_cnt][31:24] = data; // lintra s-0396, s-0393, s-2033, s-0241
                    end
                   endcase
               end
               nxtstate.ext_hdr_cnt |= nxtstate.ext_hdr_cnt + 1'b1;
            end else begin
               nxtstate.eh_discard |= '1;
            end
      end
        
             
    endcase
  end else if (pop) begin
    // Clear the state when the message completes on the target register
    // access interface
    nxtstate.irdy  = '0;
    nxtstate.count = '0;
  end
endfunction
  
  regstate pstate;    // Posted message state
  regstate nstate;    // Non-posted message state
  
  logic    np;        // Non-posted is selected when asserted
  
  logic    cirdy;     // Flops to control the transfer of the completion to the
  logic    ctregcerr; // egress block
  logic [1:0] ctregxfr; // completion transfer state machine.
  logic       cmpd;      // Completion with data otherwise without data
  logic       ppop;      // Posted/non-posted pop signals that indicate that the
  logic       npop;      // message has been transferred on the target interface
  logic       pput;      // Posted/non-posted put signals that indicate that the
  logic       nput;      // next 4 byte flit is valid and needs to be captured.
  logic       pignore;   // Ignore flops: When active, the target message is not
  logic       nignore;   // a register access message and is being ignored.
  logic [NUM_TX_EXT_HEADERS_L2:0] tx_eh_cnt; // lintra s-70036 "counter for number of ehs transmitted. May not always be exercised."
  logic                           tmsg_pcclaim;
// PCR 12042104 - Unique Extended Header Support variables - START
   logic                           tx_eh_remaining;   // Local variable used to keep track of the presence of any valid unique headers unsent.
// will this header mux change?
   logic [                   31:0] tx_ext_header_mux; // Final muxed extended header data.
   logic [NUM_TX_EXT_HEADERS_L2:0] tx_eh_cnt_next;    // lintra s-70036 "Next tx_eh_cnt value during header transfer may not always get exercised"
   logic [             SAIWIDTH:0] treg_csai_ff;      // lintra s-0531, s-70036 "SAI value for extended headers"
   logic [              RSWIDTH:0] treg_crs_ff;       // lintra s-0531, s-70036 "RS value for extended headers"
   logic                           tmsg_npclaim_pre;
   logic                           nperror;           // lintra s-0531, s-70036 "Non-posted error occured"
// PCR 12042104 - Unique Extended Header Support variables - FINISH
   
   logic                           addr_err;

logic   [31:0]mmsg_pcpayload_int;
logic   src_dst_np_claim;
logic   tmsg_npclaim_hit;
logic   np_claim_ip; //lintra s-0531
logic   src_dst_pc_claim;
logic   tmsg_pcclaim_hit;
logic   pc_claim_ip; //lintra s-0531

// 7 bit case, create fake puts for first 2 bytes until claim byte arrives
// claim ip is just asserted from the third bute is checked for claim till eom
// src_dst_np_claim will create fake puts only for the time its not claimed and
// if there is a claim, that will be available on claim_ip
generate
    if (INTERNALPLDBIT ==31) begin: gen_treg_claim_31
        always_comb src_dst_np_claim = 1'b0;
        always_comb src_dst_pc_claim = 1'b0;
    end
    else begin: gen_treg_claim_15_7
        always_comb src_dst_np_claim = treg_np_last_byte ? np_claim_ip : (treg_np_first_byte | treg_np_second_byte);
        always_comb src_dst_pc_claim = treg_pc_last_byte ? pc_claim_ip : (treg_pc_first_byte | treg_pc_second_byte);

        //always_comb bytes_before_claim = (treg_np_first_byte | treg_np_second_byte) & ~claim_ip;
        always_ff @ (posedge side_clk or negedge side_rst_b) begin
            if (~side_rst_b) begin
                np_claim_ip <= '0;
                pc_claim_ip <= '0;
            end
            else begin
                if (tmsg_npput && ~tmsg_npmsgip && ~np_claim_ip)
                    np_claim_ip <= tmsg_npclaim_hit;
                if (tmsg_npput && tmsg_npeom)
                    np_claim_ip <= '0;
                if (tmsg_pcput && ~tmsg_pcmsgip && ~pc_claim_ip)
                    pc_claim_ip <= tmsg_pcclaim_hit;
                if (tmsg_pcput && tmsg_pceom)
                    pc_claim_ip <= '0;
            end
        end
    end
endgenerate

generate
    if (SB_PARITY_REQUIRED) begin: gen_treg_mmsg_parity
        always_comb mmsg_pcparity = ^{mmsg_pcpayload, mmsg_pceom};
    end
    else begin: gen_treg_mmsg_noparity
        always_comb mmsg_pcparity = '0;
    end
endgenerate

// Output to the master interface of the base endpoint
always_comb mmsg_pcirdy = cirdy; 

logic tmsg_npfree_pre;
  always_comb begin
    // The target register access service is idle when irdys are de-asserted and
    // both transfer counters are zero.  The non-posted completion irdy is not
    // needed because the base endpoint uses the master irdys to keep the ISM in
    // the ACTIVE state, so this would be redundant.
    
    idle_trgtreg = ~pstate.irdy & (pstate.count == '0) &
                   ~nstate.irdy & (nstate.count == '0);


    // Outputs to the target interface of the base endpoint
    tmsg_pcfree  = ~pstate.irdy | ppop;
    tmsg_npfree_pre  = ~nstate.irdy & (~mmsg_pcirdy |
                                   (mmsg_pceom & mmsg_pcsel & mmsg_pctrdy));

    tmsg_npclaim_hit =      treg_np_third_byte & 
                          ((tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_MRD)   |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_MWR)   |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_IORD)  |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_IOWR)  |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_CFGRD) |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_CFGWR) |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_CRRD)  |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_CRWR));
    
    tmsg_pcclaim_hit =      treg_pc_third_byte &
                          ((tmsg_pcpayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_MWR)  |
                          (tmsg_pcpayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_CRWR));
                            
                        


// PCR 12042104 - Delay np claim - START
    tmsg_npclaim_pre = ~tmsg_npmsgip & tmsg_npput & tmsg_npclaim_hit;
// PCR 12042104 - Delay np claim - Finish
    
    // All legal posted register access messages (writes) are claimed by this target
    // HSD 4964230: Removed IOWR/CFGWR is not an accepted Posted Message by IOSF Spec - START
    tmsg_pcclaim = ~tmsg_pcmsgip & tmsg_pcput & tmsg_pcclaim_hit;
    
    // HSD 4964230: Removed IOWR/CFGWR is not an accepted Posted Message by IOSF Spec - FINISH
    
    // Outputs to the master interface of the base endpoint
    // mmsg_pcirdy = cirdy;  // moved to separate always_comb to make lint happy.

    // Generation of the completion for non-posted register accesses
    // If there is no error indicated from the target interface and the non-posted
    // register access was a read, then the completion will carry data, otherwise
    // it will be a completion without data
    cmpd      = ~ctregcerr & ~nstate.opcode[0];
    
    // The completion is either 4 bytes (completion without data), or 8 bytes
    // (completion with 1 dword of read data) or 12 bytes (completion with 2 dwords
    // of read data).  Transfer 1 always contains the dest/source port IDs, the
    // completion opcode and the transation tag.  Transfer 2 contains the 1st dword
    // of read data, and transfer 3 contains the 2nd dword of read data.
  unique casez ( ctregxfr ) //lintra s-50002, s-0257 "description in lintra webpage not clear for parallel case statements"
//vishnu: this will need the byte enable mux (removing the next mux)
// PCR 12042104 - extended headers indicator now used to indicate when there are remaining extended headers - START
      2'b00 : mmsg_pcpayload_int = { tx_eh_remaining, 3'b0, ctregcerr, nstate.tag,
                                 cmpd ? SBCOP_CMPD : SBCOP_CMP,
                                 nstate.dest, nstate.source         };
      2'b01 : mmsg_pcpayload_int = tx_ext_header_mux;
// PCR 12042104 - extended headers indicator now used to indicate when there are remaining extended headers - FINISH
//vishnu: how will this data be handled?

      2'b10 : mmsg_pcpayload_int = nstate.data[31:0];
      2'b11 : mmsg_pcpayload_int = nstate.data[MAXDATA:DW2MIN];
      default : mmsg_pcpayload_int = 'x;
   endcase

    unique casez (INTERNALPLDBIT)
        31: mmsg_pcpayload[INTERNALPLDBIT:0]  =   mmsg_pcpayload_int[INTERNALPLDBIT:0];
        15: mmsg_pcpayload[INTERNALPLDBIT:0]  =   treg_mmsg_pc_last_byte ? mmsg_pcpayload_int[31:16] : mmsg_pcpayload_int[15:0]; // lintra s-0396, s-0393
   default: mmsg_pcpayload[INTERNALPLDBIT:0]  =   treg_mmsg_pc_second_byte ? mmsg_pcpayload_int[15:8] : (treg_mmsg_pc_third_byte ? mmsg_pcpayload_int[23:16] : (treg_mmsg_pc_last_byte ? mmsg_pcpayload_int[31:24] : mmsg_pcpayload_int[7:0])); // lintra s-0396, s-0393, s-2033
   endcase

    // Pop occurs when the message completes on the target register access
    // interface.  Note, that if an error is detected with the message format, then
    // irdy is not asserted and the message auto-completes 1 cycles later.

    // ppop relocated to its own always_comb to make lintra happy.
    //    ppop = ~np & pstate.irdy & (treg_trdy | pstate.err);
    npop =  np & nstate.irdy & (treg_trdy | nstate.err);
    
    // Put is masked if the 1st 4 byte flit is not claimed, and then all other flits
    // will be ignored.
    pput = tmsg_pcput & (tmsg_pcmsgip ? ~pignore : (tmsg_pcclaim | src_dst_pc_claim));
// PCR 12042104 - Delay np claim - Start
// for 7 bit payload, the opcode to check claim, arrives only on the third byte
// the previous equation, masked out all the other puts except the opcode byte
 
// src_dst_np_claim is first_byte or second_byte to flop src/dest from data bus when
// payload is not 32 bits, because of the claim arriving only on 3rd byte

// this should happen only on the first DW, since after that msgip should be asserted and
// picks up ~nignore
 
    nput = tmsg_npput & (tmsg_npmsgip ? ~nignore : (tmsg_npclaim_pre | src_dst_np_claim));
    nperror = nstate.err;

    if (INTERNALPLDBIT ==7) begin
        if (MAXADDR < 47)
            addr_err = (|(tmsg_nppayload & {8{treg_np_third_byte}}) | // lintra s-0393
                         |(tmsg_nppayload & {8{treg_np_last_byte}} ) | // lintra s-0393 
                         ((nstate.opcode[0] == tmsg_npeom) & treg_np_last_byte)) ;
        else
            addr_err = ((nstate.opcode[0] == tmsg_npeom) & treg_np_last_byte);
    end
    else if (INTERNALPLDBIT == 15) begin
        if (MAXADDR < 47)
            addr_err = (|(tmsg_nppayload & {16{treg_np_third_byte}})| // lintra s-0393
                            ((nstate.opcode[0] == tmsg_npeom) & treg_np_last_byte));
        else
            addr_err = ((nstate.opcode[0] == tmsg_npeom) & treg_np_last_byte);
    end
    else begin
            addr_err = (|(ADDRMASK[INTERNALPLDBIT:0] & tmsg_nppayload)) |
                            ((nstate.opcode[0] == tmsg_npeom) & treg_np_last_byte);
    end

    if( nput) begin
       if( nstate.irdy ) begin // lintra s-60032 "Lintra has difficulty with embedded if statements"
          nperror |= (tmsg_npeom & treg_np_last_byte);
       end else begin
         unique casez( nstate.count ) // lintra s-0257 "description in lintra webpage not clear for parallel case statements"
         4'b0000: // Standard Header
            nperror = (tmsg_npeom & treg_np_first_byte); // Always a fresh evaluation.
         4'b0001: // Address[15:0]
            nperror |= ((MAXBE==3) & (|tmsg_nppayload[7:4]) & treg_np_first_byte) |
                       ( nstate.opcode[0] & tmsg_npeom & treg_np_last_byte)   |
                       (~nstate.opcode[0] & ~nstate.addrlen & ~tmsg_npeom & treg_np_last_byte);
         4'b0010: // Address[MAXADDR:16]
            nperror |= addr_err;
         4'b0011: // Data[31:0]
            nperror |= (MAXBE==3) ?
                       (~tmsg_npeom & treg_np_last_byte) :
                       (( tmsg_npeom == |nstate.be[MAXBE:DW2BEMIN]) & treg_np_last_byte);
         4'b0100: // Data[MAXDATA:32]
            nperror |= (~tmsg_npeom & treg_np_last_byte);
         4'b0101, // Malformed message
         4'b0110, // Malformed message
         4'b0111: // Malformed message, dead state
            nperror |= '1;
         4'b1000: // Extended header phase
            nperror |= (tmsg_npeom & treg_np_last_byte);
         default: // Unused states
            nperror |= '0;
         endcase
       end
    end

    // All non-posted register access messages are claimed by this target
    if( |NUM_UNIQUE_EH ) begin
      tmsg_npclaim = ( tmsg_npput & tmsg_npeom & ~nperror & |nstate.count );
    end else begin
      tmsg_npclaim = tmsg_npclaim_pre;
    end
// PCR 12042104 - Delay np claim - Finish


    // Target register access interface output muxes
    treg_irdy           = np ? (nstate.irdy & ~nstate.err) : (pstate.irdy & ~pstate.err);
    treg_np             = np;
    treg_dest           = np ? nstate.dest    : pstate.dest;
    treg_source         = np ? nstate.source  : pstate.source;
    treg_opcode         = np ? nstate.opcode  : pstate.opcode;
    treg_addrlen        = np ? nstate.addrlen : pstate.addrlen;
    treg_bar            = np ? nstate.bar     : pstate.bar;
    treg_tag            = np ? nstate.tag     : pstate.tag;
    treg_be             = np ? nstate.be      : pstate.be;
    treg_fid            = np ? nstate.fid     : pstate.fid;
    treg_addr           = np ? nstate.addr    : pstate.addr;
    treg_wdata          = np ? nstate.data    : pstate.data;
  end

always_ff @(posedge side_clk or negedge side_rst_b)
begin
    if (~side_rst_b) begin
        tmsg_npfree <= '0;
    end
    else begin
// tmsg_npclaim is tmsg_nput and tmsg_eom. since npfree is flopped, there is a 1 clk delay between when treg is actually free (npfree_pre) and 
// when it announces that its free through output, during which b2b np could be coming in and they will be dropped.
// the agents think treg is free, while internal logic prevents treg from accepting it.
// deasserting free when the claim by treg happens should avoid that case.
        if (tmsg_npclaim) tmsg_npfree <= '0;
        else tmsg_npfree <= tmsg_npfree_pre;

    end
end

  generate
    if ( |RX_EXT_HEADER_SUPPORT ) begin : gen_exhd_blk1
      if( |NUM_UNIQUE_EH ) begin : gen_unique_ext_headers
         always_comb begin
            if( np ) begin
               treg_eh             = nstate.eh;
               treg_eh_discard     = nstate.eh_discard;
               treg_rx_sairs_valid = nstate.ext_hdr[EHVB_SAIRS][7];
               treg_rx_sai         = nstate.ext_hdr[EHVB_SAIRS][SAIWIDTH+ 8: 8];
               treg_rx_rs          = nstate.ext_hdr[EHVB_SAIRS][ RSWIDTH+24:24];
            end else begin
               treg_eh             = pstate.eh;
               treg_eh_discard     = pstate.eh_discard;
               treg_rx_sairs_valid = pstate.ext_hdr[EHVB_SAIRS][7];
               treg_rx_sai         = pstate.ext_hdr[EHVB_SAIRS][SAIWIDTH+ 8: 8];
               treg_rx_rs          = pstate.ext_hdr[EHVB_SAIRS][ RSWIDTH+24:24];
            end
            treg_ext_header = '0;
         end
      end else begin : gen_ext_headers
         always_comb begin
            treg_eh         = np ? nstate.eh         : pstate.eh;
            treg_ext_header = np ? nstate.ext_hdr    : pstate.ext_hdr;
            treg_eh_discard = np ? nstate.eh_discard : pstate.eh_discard;
            treg_rx_sairs_valid = '0;
            treg_rx_sai         = '0;
            treg_rx_rs          = '0;
         end
      end
    end else begin : gen_nexhd_blk1
      always_comb begin
         treg_eh         = '0;
         treg_ext_header = '0;
         treg_eh_discard = '0;
         treg_rx_sairs_valid = '0;
         treg_rx_sai         = '0;
         treg_rx_rs          = '0;
      end
    end
  endgenerate
  
  always_comb
    ppop = ~np & pstate.irdy & (treg_trdy | pstate.err);
  
// PCR 12042104 - Change pceom based on remaining extended headers - START
// removed casex to disable x-prop coding.
logic mmsg_pceom_int;
  always_comb
      if( !cmpd ) begin
         mmsg_pceom_int = ~tx_eh_remaining;
      end else if( ctregxfr == 2'b10 ) begin // Data phase 1
         mmsg_pceom_int = ((MAXBE==3) | ~(|nstate.be[MAXBE:DW2BEMIN]));
      end else if( ctregxfr == 2'b11 ) begin // Data phase 2
         mmsg_pceom_int = 1'b1;
      end else begin
         mmsg_pceom_int = 1'b0;
      end
// PCR 12042104 - Change pceom based on remaining extended headers - FINISH

always_comb mmsg_pceom = mmsg_pceom_int & treg_mmsg_pc_last_byte;

// PCR 12042104 - Extended headers selection MUX - START
   generate
      if( |TX_EXT_HEADER_SUPPORT ) begin : gen_tx_ext_header_mux
         if( |NUM_UNIQUE_EH ) begin : gen_unique_ext_header
            logic [NUM_UNIQUE_HEADERS:0] tx_eh_valid;       // local variable used to keep track of active extended headers
            logic [NUM_UNIQUE_HEADERS:0] tx_eh_valid_pre;   // local variable used to set tx_eh_valid with the extended headers that will be required.
            logic [NUM_UNIQUE_HEADERS:0] tx_eh_clear;       // clear bit to clear tx_eh_valid bits.
            logic [NUM_UNIQUE_HEADERS:0] tx_eh_valid_clear; // local variable used to set tx_eh_valid with the extended headers that will be required.

            // extended header valid pre signal. Used to uniformly capture
            // each supported unique extended header. As new types are
            // this should grow and have the corresponding valid bit
            // appended. The usage of the always comb block is unnecessary but
            // should help make the code readable.
            always_comb begin
               tx_eh_valid_pre             = '0;
               tx_eh_valid_pre[EHVB_SAIRS] = treg_csairs_valid;
            end

            // extended header valid signal off of a flop. Used by
            // to keep track of all the uniqueue exteneded headers
            // that require servicing. Each should be cleared as
            // accepted by the master message module.
            always_ff @( posedge side_clk or negedge side_rst_b )
               if( ~side_rst_b )
                  tx_eh_valid <= '0;
               else if( npop )
                  tx_eh_valid <= tx_eh_valid_pre;
               else if( mmsg_pcirdy && mmsg_pctrdy && mmsg_pcsel )
                  tx_eh_valid <= tx_eh_valid_clear;

            // Extended header next count (AKA Extended Header Aribiter)
            // tx_eh_cnt is being overloaded as an arbiter. This code
            // will allow for skipping any extended headers that are
            // not required for the current transmittion. As new
            // extended headers are added they should go into the
            // if statements below. If there are order dependencies
            // on the extended headers that can be resolved by putting
            // most important on top. Synthesis should be able to
            // optimize out the unused bits without much trouble so
            // the actual number of flops used will vary.
            // NOTE: If timing cycles out of control the code
            //       will need to infer a one-hot based arbitration
            //       pointer instead of the if-else tree.
            //
            // tx_eh_clear will be used to clear away the currently
            // selected supported unique extended header. Can only clear
            // when ctregxfr is indicating that extended headers are
            // being sent.
            //
            // tx_eh_remaining will be used to indicate when the
            // more extended header flag needs to be set in the header.
            // When evaluating the currently active extended header
            // should be ignored.
            always_comb begin
               tx_eh_cnt_next = '0;
               tx_eh_clear    = '0;

               if( tx_eh_valid[EHVB_SAIRS] ) begin
                  tx_eh_cnt_next          = EHOP_SAIRS;
                  tx_eh_clear[EHVB_SAIRS] = 1'b1;
               end

               if( ctregxfr == 2'b01 ) begin
                  tx_eh_valid_clear = tx_eh_valid & ~tx_eh_clear;
               end else begin
                  tx_eh_valid_clear = tx_eh_valid;
               end

               tx_eh_remaining = |( tx_eh_valid_clear );
            end

            // Store all extended header data for later use. Try to
            // keep the number of inferred flops to a minimum.
            always_ff @( posedge side_clk or negedge side_rst_b )
               if( !side_rst_b ) begin
                  treg_csai_ff <= '0;
                  treg_crs_ff  <= '0;
               end else if( npop ) begin
                  treg_csai_ff <= treg_csai;
                  treg_crs_ff  <= treg_crs;
               end

            // Extended header mux will be used to select the appropriate
            // extended header that is currently in use. As new extended
            // headers are supported by the target register module the
            // 32-bit extended header field should go here. If there
            // ends up being an order dependency that can be fixed here
            // by changing the order in tx_eh_cnt_next.
            always_comb begin
               tx_ext_header_mux  = '0;

               // Uniqueue Extended Headers Assignments for each one that
               // is created this will need to expand to accomidate.
               if( tx_eh_cnt == EHOP_SAIRS ) begin
                  tx_ext_header_mux[          6: 0] = EHOP_SAIRS;
                  tx_ext_header_mux[             7] = tx_eh_remaining;
                  tx_ext_header_mux[SAIWIDTH+ 8: 8] = treg_csai_ff[SAIWIDTH:0];
                  tx_ext_header_mux[ RSWIDTH+24:24] = treg_crs_ff [ RSWIDTH:0];
                  tx_ext_header_mux[         31:28] = 4'd0;
               end
            end
         end else begin : gen_tx_ext_headers
            always_comb tx_ext_header_mux = tx_ext_headers[tx_eh_cnt]; // lintra s-0241 "gets flagged but the index should never actually be used out of bounds"
            always_comb begin
               if( ctregxfr == '0 ) begin
                  tx_eh_remaining = 1'b1;
                  tx_eh_cnt_next  = tx_eh_cnt;
               // PCR 1203799966 - index out-of-bound for tx_ext_headers array - START
               end else if (tx_eh_cnt == NUM_TX_EXT_HEADERS) begin
                  tx_eh_remaining = 1'b0;
                  tx_eh_cnt_next  = tx_eh_cnt;
               // PCR 1203799966 - index out-of-bound for tx_ext_headers array - FINISH
               end else begin
                  tx_eh_remaining = tx_ext_header_mux[7];
                  tx_eh_cnt_next  = tx_eh_cnt + 1'b1;
               end 
            end
         end
      end else begin : gen_tx_ext_headers_none
         always_comb tx_ext_header_mux = '0;
         always_comb tx_eh_remaining   = 1'b0;
         always_comb tx_eh_cnt_next    = '0;
      end
   endgenerate
// PCR 12042104 - Extended headers selection MUX - FINISH
 
 // eom can be asserted for as long as the data is available, but it needs to be valid only when there is
 // corresponding put
 logic nstate_eom;
 logic pstate_eom;

 always_comb nstate_eom = tmsg_npeom & tmsg_npput;
 always_comb pstate_eom = tmsg_pceom & tmsg_pcput;
  
  always_ff @(posedge side_clk or negedge side_rst_b)
    if (~side_rst_b) begin
      // Flop count:
      pstate    <= '0;  // 44 + address width + data width + byte enable width
      nstate    <= '0;  // 44 + address width + data width + byte enable width
      np        <= '0;  //  1 : 0=posted / 1=non-posted (traffic class arbiter)
      cirdy     <= '0;  //  1 : Completion is ready
      ctregcerr <= '0;  //  1 : Completion error (4 byte completion will be sent)
      ctregxfr  <= '0;  //  2 : Completion transfer counter
      pignore   <= '0;  //  1 : Posted message is being ignored
      nignore   <= '0;  //  1 : Non-posted message is being ignored
      tx_eh_cnt <= '0;
    end else begin
      if (~sbe_sbi_idle | ~idle_trgtreg) begin // added for tgl clk gating improvement
        // Capture flops / state update
        pstate <= nxtstate( pstate, side_rst_b, ppop, pput, pstate_eom, treg_pc_first_byte, treg_pc_second_byte, treg_pc_third_byte, treg_pc_last_byte, tmsg_pcmsgip, tmsg_pcpayload, treg_input_parity_err);
        nstate <= nxtstate( nstate, side_rst_b, npop, nput, nstate_eom, treg_np_first_byte, treg_np_second_byte, treg_np_third_byte, treg_np_last_byte, tmsg_npmsgip, tmsg_nppayload, treg_input_parity_err);
      end
      // Re-use the write data flops to capture the read data for the completion
//vishnu: are these payload wide flops?      
      if (npop & ~nstate.opcode[0]) nstate.data <= treg_rdata;
      
      // Ignore flops are cleared when the eom is recieved and set when the
      // third byte of the 4 byte flit is received and the message is not claimed
      if (tmsg_pcput) begin
        if (tmsg_pceom & treg_pc_last_byte) pignore <= '0; // lintra s-60032
        else if (~tmsg_pcmsgip & treg_pc_third_byte) pignore <= ~tmsg_pcclaim;
      end
// check for claim on the third byte only      
      if (tmsg_npput) begin
        if (tmsg_npeom & treg_np_last_byte) nignore <= '0; // lintra s-60032
        else if (~tmsg_npmsgip & treg_np_third_byte) nignore <= ~tmsg_npclaim_pre;
      end
      
      // Simple arbiter to switch between posted and non-posted
// np is asserted as soon as the first bytes of nput come in, but they
// could be fake puts with no claims (esply in 7 bit payload). modified this to wait till the last byte      
      if (np)
        np <= ((pstate.irdy | (pput & treg_pc_last_byte)) & (~nstate.irdy | npop)) ? '0 : '1;
      else
        np <= ((nstate.irdy | (nput & treg_np_last_byte)) & (~pstate.irdy | ppop)) ? '1 : '0;
      
      // Non-posted register access completion generation
      // Assert the completion irdy when the non-posted register access message
      // completes on the target interface
      if (npop) begin
          if( |NUM_UNIQUE_EH ) begin
            cirdy <= ~nstate.err; // UNIQUE EH Mode will not send completions for errors
          end else begin
            cirdy <= '1;
          end
          ctregcerr <= treg_cerr | nstate.err;
          
          // Update the completion transfer state when a completion transfer completes
          // on the egress port interface
      end else if (mmsg_pcirdy & mmsg_pctrdy & mmsg_pcsel) begin
          
          // If this is the last completion transfer then irdy is de-asserted
          if (mmsg_pceom) begin // lintra s-60032
              cirdy     <= '0;
              ctregxfr  <= '0;
              tx_eh_cnt <= '0;
              
              // Otherwise advance to the next transfer
          end else if ( (~|ctregxfr) & treg_mmsg_pc_last_byte) begin
// PCR 12042104 - Completion transfer state modified to use variable instead of parameter - START
            ctregxfr  <= tx_eh_remaining ? 2'b01 : 2'b10;
            tx_eh_cnt <= tx_eh_cnt_next;
          end else if (( !tx_eh_remaining ) & treg_mmsg_pc_last_byte) begin // lintra s-0241
// PCR 12042104 - Completion transfer state modified to use variable instead of parameter - FINISH
            ctregxfr <= &ctregxfr ? ctregxfr : (ctregxfr + 1'b1);  // lintra s-2056 // saturate
            // The s-0241 waiver checks for out -of bounds indexes. Lintra is
            // concerned that tx_eh_cnt could increase beyond the size of the
            // tx_ext_headers array. This can only happen if a message with
            // too many extended header words is processed through the 
            // endpoint.
          end else begin
// PCR 12042104 - tx_eh_cnt now treated like an arbiter with a next state - START
            tx_eh_cnt <= tx_eh_cnt_next;
// PCR 12042104 - tx_eh_cnt now treated like an arbiter with a next state - FINISH
          end
      end
    end
  
// Hier Header PCR

generate 
    if (GLOBAL_EP_IS_STRAP==1) begin : gen_treg_hier_strap
        logic hdr_pc_fbyte, hdr_pc_sbyte;
        logic hdr_np_fbyte, hdr_np_sbyte;
        logic [7:0]     treg_hier_destid_int;
        logic [7:0]     treg_hier_srcid_int;

// NP HIER source and destinations are inputs to HIER_COMP block (to be swapped)
        logic [7:0]     pc_hier_destid, pc_hier_srcid;

        if (INTERNALPLDBIT==31) begin : gen_treg_hier_31
            always_comb begin
                hdr_pc_fbyte = 1'b1;
                hdr_pc_sbyte = 1'b1;
                hdr_np_fbyte = 1'b1;
                hdr_np_sbyte = 1'b1;
            end // always_block
        end // pldbit = 31
        else begin : gen_treg_hier_15_7
            hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
                i_sbebytecount_hier_pc (
                .side_clk           ( side_clk      ),
                .side_rst_b         ( side_rst_b    ),
                .valid              ( tmsg_hdr_pcput),
                .first_byte         ( hdr_pc_fbyte  ),
                .second_byte        ( hdr_pc_sbyte  ),
                .third_byte         (               ),
                .last_byte          (               )
            );
               
            hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
                i_sbebytecount_hier_np (
                .side_clk           ( side_clk      ),
                .side_rst_b         ( side_rst_b    ),
                .valid              ( tmsg_hdr_npput),
                .first_byte         ( hdr_np_fbyte  ),
                .second_byte        ( hdr_np_sbyte  ),
                .third_byte         (               ),
                .last_byte          (               )
            );
        end
 
        always_ff @(posedge side_clk or negedge side_rst_b) begin
            if (~side_rst_b) begin
                pc_hier_destid      <= '0;
                pc_hier_srcid       <= '0;
                np_hier_destid      <= '0;
                np_hier_srcid       <= '0;
            end
            else begin
                if (hdr_pc_fbyte & tmsg_hdr_pcput) pc_hier_destid   <= tmsg_hdr_pcpayload[7 : 0];
                if (hdr_pc_sbyte & tmsg_hdr_pcput) pc_hier_srcid    <= tmsg_hdr_pcpayload[(SRC_START+7): SRC_START];

                if (hdr_np_fbyte & tmsg_hdr_npput) np_hier_destid   <= tmsg_hdr_nppayload[7 : 0];
                if (hdr_np_sbyte & tmsg_hdr_npput) np_hier_srcid    <= tmsg_hdr_nppayload[(SRC_START+7): SRC_START];
            end
        end //always_ff
        
        always_comb begin
            treg_hier_destid_int    = np ? np_hier_destid   : pc_hier_destid;
            treg_hier_srcid_int     = np ? np_hier_srcid    : pc_hier_srcid;
        end
        always_comb begin
            treg_hier_destid    = global_ep_strap ?  treg_hier_destid_int : '0;
            treg_hier_srcid     = global_ep_strap ?  treg_hier_srcid_int : '0;
        end
    end
    else begin : gen_hier_param
        if (GLOBAL_EP==1) begin: gen_treg_hier
            logic hdr_pc_fbyte, hdr_pc_sbyte;
            logic hdr_np_fbyte, hdr_np_sbyte;
// NP HIER source and destinations are inputs to HIER_COMP block (to be swapped)
            logic [7:0]     pc_hier_destid, pc_hier_srcid;

            if (INTERNALPLDBIT==31) begin : gen_treg_hier_31
                always_comb begin
                    hdr_pc_fbyte = 1'b1;
                    hdr_pc_sbyte = 1'b1;
                    hdr_np_fbyte = 1'b1;
                    hdr_np_sbyte = 1'b1;
                end // always_block
            end // pldbit = 31
            else begin : gen_treg_hier_15_7
                hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
                    i_sbebytecount_hier_pc (
                    .side_clk           ( side_clk      ),
                    .side_rst_b         ( side_rst_b    ),
                    .valid              ( tmsg_hdr_pcput),
                    .first_byte         ( hdr_pc_fbyte  ),
                    .second_byte        ( hdr_pc_sbyte  ),
                    .third_byte         (               ),
                    .last_byte          (               )
                );
               
                hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
                    i_sbebytecount_hier_np (
                    .side_clk           ( side_clk      ),
                    .side_rst_b         ( side_rst_b    ),
                    .valid              ( tmsg_hdr_npput),
                    .first_byte         ( hdr_np_fbyte  ),
                    .second_byte        ( hdr_np_sbyte  ),
                    .third_byte         (               ),
                    .last_byte          (               )
                );
            end
 
            always_ff @(posedge side_clk or negedge side_rst_b) begin
                if (~side_rst_b) begin
                    pc_hier_destid      <= '0;
                    pc_hier_srcid       <= '0;
                    np_hier_destid      <= '0;
                    np_hier_srcid       <= '0;
                end
                else begin
                    if (hdr_pc_fbyte & tmsg_hdr_pcput) pc_hier_destid   <= tmsg_hdr_pcpayload[7 : 0];
                    if (hdr_pc_sbyte & tmsg_hdr_pcput) pc_hier_srcid    <= tmsg_hdr_pcpayload[(SRC_START+7): SRC_START];
    
                    if (hdr_np_fbyte & tmsg_hdr_npput) np_hier_destid   <= tmsg_hdr_nppayload[7 : 0];
                    if (hdr_np_sbyte & tmsg_hdr_npput) np_hier_srcid    <= tmsg_hdr_nppayload[(SRC_START+7): SRC_START];
                end
            end //always_ff
        
            always_comb begin
                treg_hier_destid    = np ? np_hier_destid   : pc_hier_destid;
                treg_hier_srcid     = np ? np_hier_srcid    : pc_hier_srcid;
            end
        end // hier=1
        else begin : gen_treg_nohier
            always_comb begin
                treg_hier_destid    = '0;
                treg_hier_srcid     = '0;
            end
        end
    end        
endgenerate 

  // Debug Signals
  always_comb
    dbgbus = { cirdy, 
               ctregcerr, 
               ctregxfr, 
               nignore | pignore,
               np,
               nstate.irdy | pstate.irdy, 
               nstate.err | pstate.err,
               nstate.count, 
               pstate.count 
               };


//-----------------------------------------------------------------------------
//
// SV Cover properties 
//
//-----------------------------------------------------------------------------

`ifndef IOSF_SB_EVENT_OFF
  `ifdef INTEL_SIMONLY
  //`ifdef INTEL_INST_ON // SynTranlateOff

  generate
    if ( |RX_EXT_HEADER_SUPPORT )
      begin

        sbetrgtreg_discarded_unsupported_header: 
          cover property (@(posedge side_clk) disable iff (~side_rst_b)
                          treg_irdy |-> treg_eh_discard )
 `ifndef IOSF_SB_EVENT_VERBOSE
            if ( 0 )
 `endif
              $info("%0t: %m: EVENT: sbetrgtreg received unsupported extended header ID", $time);

      sbetrgtreg_received_extended_header: 
        cover property (@(posedge side_clk) disable iff (~side_rst_b)
                        treg_irdy |-> treg_eh )
 `ifndef IOSF_SB_EVENT_VERBOSE
          if ( 0 )
 `endif
            $info("%0t: %m: EVENT: sbetrgtreg received extended header", $time);
        

      end // if ( RX_EXT_HEADER_SUPPORT )
  endgenerate

   `endif // SynTranlateOn
`endif
  
endmodule

// lintra pop
