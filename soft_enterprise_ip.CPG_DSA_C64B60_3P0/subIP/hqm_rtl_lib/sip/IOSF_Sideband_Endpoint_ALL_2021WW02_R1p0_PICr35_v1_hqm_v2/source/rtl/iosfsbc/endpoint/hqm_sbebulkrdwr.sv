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
//  Module sbebulkrdwr : Bulk read and write widget (combines TRGTREG and save/restore widgets)
//
//------------------------------------------------------------------------------


// lintra push -60020, -60088, -80028, -80095, -68001, -60024b, -50002, -2050, -70036_simple, -70044_simple, -60145
// 52523 : Repeated (local) parameter: ... (e.g. NUM_ACTUAL_RX_EXT_HEADERS). Already defined in ....
// lintra push -52523 

module hqm_sbebulkrdwr #(
    parameter INTERNALPLDBIT            = 7, // Maximum payload bit, should be 7, 15 or 31
    parameter RX_EXT_HEADER_SUPPORT     = 0,
    parameter MAXADDR                   = 0,
    parameter MAXADDRINDATA             = 0,
    parameter MAXTRGTDATA               = 0,
    parameter ADDRMASK                  = 0,
    parameter DW2BEMIN                  = 0,
    parameter MAXDATA                   = 0,
    parameter DW2MIN                    = 0,
    parameter NUM_UNIQUE_EH             = 0,
    parameter HDRSTART                  = 0,
    parameter NUM_ACTUAL_RX_EXT_HEADERS = 0,
    parameter NUM_RX_EXT_HEADERS_L2     = 0,
    parameter [NUM_ACTUAL_RX_EXT_HEADERS:0][6:0] ACTUAL_RX_EXT_HEADER_IDS = 0,
    parameter MAXBE                     = 0,
    parameter NP                        = 0
) (
  // Clock/Reset Signals
    input logic                         side_clk,
    input logic                         side_rst_b,
    input logic                         pop,
    input logic                         put,
    input logic                         eom,
    input logic                         first_byte,
    input logic                         second_byte,
    input logic                         third_byte,
    input logic                         last_byte,
    input logic                         msgip,
    input logic [INTERNALPLDBIT:0]      data,
    input logic [MAXTRGTDATA:0]         treg_rdata, // lintra s-0527
    input logic                         treg_cerr, // lintra s-0527, s-70036
    input logic                         parity_err,
    input logic                         rdyfornxtirdy,
    output logic                        rdyfornxtput,
    output logic [3:0]                  op_count,
    output logic                        op_err,
    output logic                        op_irdy,
    output logic [MAXTRGTDATA:0]        op_data,
    output logic [MAXADDR:0]            op_addr,
    output logic [23:0]                 op_addrbuf,
    output logic [7:0]                  op_fid,
    output logic [MAXBE:0]              op_be,
    output logic                        op_addrlen,
    output logic [2:0]                  op_bar,
    output logic                        op_eh,
    output logic                        op_eh_discard,
    output logic [NUM_ACTUAL_RX_EXT_HEADERS:0][31:0] op_ext_hdr,
    output logic [ 2:0]                 op_tag,
    output logic [ 7:0]                 op_opcode,
    output logic [ 7:0]                 op_source,
    output logic [ 7:0]                 op_dest,
    output logic                        op_bulkopcode,  // lintra s-70036 "only used for np's completion"
    output logic                        op_bulkread,  // lintra s-70036 "only used for np's completion"
    output logic                        op_bulkeom      // lintra s-70036 "only used for np's completion

);

localparam SRC_START      = (INTERNALPLDBIT ==7)  ? 0  : 8;
localparam OPC_START      = (INTERNALPLDBIT ==31) ? 16 : 0;
localparam TAG_START      = (INTERNALPLDBIT ==31) ? 24 : ((INTERNALPLDBIT ==15) ? 8  : 0);
localparam BAR_START      = (INTERNALPLDBIT ==31) ? 27 : ((INTERNALPLDBIT ==15) ? 11 : 3);
localparam ADDRLEN_BIT    = (INTERNALPLDBIT ==31) ? 30 : ((INTERNALPLDBIT ==15) ? 14 : 6);
localparam BULKADDR_START = (INTERNALPLDBIT ==31) ? 18 : 2;
localparam ADDRMOD        = (MAXADDR+1)%(INTERNALPLDBIT+1);
localparam MINADDR        = MAXADDR==15 ? 15 : 16;
//logic               rdyfornxtput;

// Structure for capturing the posted/non-posted register access message
// and the current transfer count and irdy signal.
typedef struct packed unsigned { // lintra s-60056 "maybe fix type def at a later date."
                logic       [3:0]   count;        // Current 4 byte flit transfer count
                logic               err;          // Error detected in received message
                logic               irdy;         // Message ready
                logic [MAXDATA:0]   data;         // Read/write data
                logic [MAXADDR:0]   addr;         // Address of the message
                logic       [7:0]   fid;          // Function ID
                logic   [MAXBE:0]   be;           // Byte enables (4 or 8 bits)
                logic               addrlen;      // Address length (0=16bit / 1=48bit)
                logic       [2:0]   bar;          // Selected BAR
                logic               eh;           // "EH" bit from standard header.
                logic               eh_discard;   // unknown extended header has been dropped.
                logic [NUM_RX_EXT_HEADERS_L2:0]           ext_hdr_cnt; // counts number of ext headers received.
                logic [NUM_ACTUAL_RX_EXT_HEADERS:0][31:0] ext_hdr; // extended headers
                logic       [2:0]   tag;          // Message tag
                logic       [7:0]   opcode;       // Message opcode
                logic       [7:0]   source;       // Source port ID
                logic       [7:0]   dest;         // Destination port ID
                logic       [7:0]   source_f;
                logic       [7:0]   dest_f;
                logic      [23:0]   addrbuf;
                logic [ 7:0]        bulkdatalen;
                logic [ 1:0]        bulkspace;
                logic               bulkdone;
                logic               bulkopcode;
                logic               bulkread;
                logic               chunkeom;
                logic               rdyfornxtput;
                logic               resetstate;
                  } regstate;
 
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
                logic parity_err,
                logic treg_cerr);


    nxtstate = cstate;


// for bulk rd/wr, states must toggle once the seqrdwr state is entered and there will not be puts during those 
    if (put | (!cstate.bulkdone & cstate.bulkopcode & ((cstate.count == 4'b1100)|(cstate.count == 4'b1011) ))) begin
// flop the source and destination bits since claim arrives only on the third byte
// put doesnt happen unless a claim happens
        if (put) begin
            if (first_byte & ~msgip)   nxtstate.dest_f   = data[7:0];
            if (second_byte & ~msgip)  nxtstate.source_f = data[(SRC_START+7):SRC_START];
        end

        if (~cstate.bulkopcode)
            nxtstate.irdy = eom & ~parity_err;
    
        cstate.resetstate = ((cstate.irdy & ~cstate.bulkopcode) | (cstate.bulkopcode & cstate.bulkdone));

        casez ( {cstate.resetstate, cstate.count} )// lintra s-2045, s-60129 "adding unique casez creates another lintra error (2044)

      // Transfer 0: Dest/Source Port IDs, tag, bar, addrlen
        5'b1????,
        5'b00000 : begin
                  nxtstate.count      = (|RX_EXT_HEADER_SUPPORT & data[INTERNALPLDBIT] & last_byte) ? 4'b1000 : 
                                        (((cstate.bulkopcode | (((INTERNALPLDBIT==31)||(INTERNALPLDBIT==15)) & (data[(OPC_START+7):OPC_START] >= 8'h08))) & last_byte) ? 4'b1001 : 
                                        (last_byte ? 4'b0001 : 4'b0000)); // go to EH state if 'eh' bit is set.
                  // An error occurs if this is only a 4 byte message.  All
                  // register access messages must be at least 8 bytes.
                  // "and" with byte enables will reset the value of these functions when the byte enable falls to 0, this block would hold the values
                  nxtstate.err        = eom;
                  //if (first_byte)           nxtstate.dest       = data[7:0];
                  if (first_byte)           nxtstate.dest       = nxtstate.dest_f;
                  //if (second_byte)          nxtstate.source     = data[(SRC_START+7):SRC_START];
                  if (second_byte)          nxtstate.source     = nxtstate.source_f;
                  if (third_byte)           nxtstate.opcode     = data[(OPC_START+7):OPC_START];
                  if (last_byte)    begin
                                            nxtstate.tag        = data[(TAG_START+2):TAG_START];
                                            nxtstate.bar        = data[(BAR_START+2):BAR_START];
                                            nxtstate.addrlen    = data[ADDRLEN_BIT];
                                            nxtstate.eh         = data[INTERNALPLDBIT];
                                    end
                  if (third_byte & ((data[(OPC_START+7):OPC_START]) >= 8'h08)) begin
                                            nxtstate.bulkdone   = 1'b0;
                                            nxtstate.bulkopcode = 1'b1;
                                            nxtstate.bulkdatalen= 8'h01;
                                    end
                  // this is used in np write. as of now it is not claimed, until there is more info on the completions for np write
                  if (third_byte & ((data[(OPC_START+7):OPC_START]) == 8'h08))
                                            nxtstate.bulkread = 1'b1;

                  nxtstate.be         = '0;
                  nxtstate.fid        = '0;
                  nxtstate.addr       = '0;
                  nxtstate.data       = '0;
                  nxtstate.ext_hdr    = '0;
                  nxtstate.ext_hdr_cnt= '0;
                  nxtstate.eh_discard = '0;
                  nxtstate.bulkspace  = '0;
                  nxtstate.rdyfornxtput='1;
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
                            nxtstate.addr[MAXADDR:MINADDR] = data;
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
                  nxtstate.count= last_byte ? 4'b0100 : 4'b0011;
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
                  dw_write_overflow: assert (~( ~eom & last_byte) ||  (reset !== 1'b1) ) else 
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
                  nxtstate.count= last_byte ? 4'b0101 : 4'b0100;
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
                if (data[7] & first_byte) begin
                    nxtstate.count  = 4'b1000;
                end
                else if (cstate.bulkopcode & last_byte) begin
                    nxtstate.count  = 4'b1001;
                    nxtstate.bulkdatalen = 8'h01;
                end
                else if (last_byte) begin
                    nxtstate.count  = 4'b0001;
                end
//         nxtstate.count = (data[7] & first_byte) ? nxtstate.count : (((cstate.opcode >= 8'h08) & last_byte) ? 4'b1001: (last_byte ? 4'b0001 : 4'b1000)); // back to normal state machine if this is the end of headers.
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
       
      5'b01001: begin
                    // 1. put happens on input from tmsg, pop happens on treg when irdy&trdy
                    // 2. pop and put cannot happen on the same cycle because of the rdyfornxtput gating put
                    // put on first chunk hdr
//                    if (cstate.bulkdatalen-8'h01 == '0) begin
                    nxtstate.be = 8'h0F;

                    if (first_byte)     nxtstate.bulkdatalen    = data[7:0];
                    if (second_byte)    nxtstate.fid            = data[(SRC_START+7): SRC_START];
                    if (third_byte)     nxtstate.bulkspace      = data[(OPC_START+1): OPC_START];
                    // the new opcode shold be generated only on the put, else it ll keep changing based on prev opcode
                    // Address' contain DW aligned data and so consequtive addresses will have last 2 bits as 0's
                    if (third_byte)     nxtstate.addr[ 7:0] = {data[(BULKADDR_START+5) : BULKADDR_START],2'b00};
                    if (last_byte)      nxtstate.addr[15:8] = data[INTERNALPLDBIT : (INTERNALPLDBIT-7)];
                    if (third_byte) begin
                        unique casez ({data[(OPC_START+1): OPC_START],cstate.opcode[0]})
                            3'b000: nxtstate.opcode = 8'h00;
                            3'b001: nxtstate.opcode = 8'h01;
                            3'b010: nxtstate.opcode = 8'h02;
                            3'b011: nxtstate.opcode = 8'h03;
                            3'b100: nxtstate.opcode = 8'h04;
                            3'b101: nxtstate.opcode = 8'h05;
                            3'b110: nxtstate.opcode = 8'h06;
                            3'b111: nxtstate.opcode = 8'h07;
                            default:nxtstate.opcode = 8'h00;
                        endcase
                    end
//                  end
                    if (last_byte)  begin
                    // if 2 byte address, start generating the sequenced addresses and write data
                    // if 6 bytes, then get the next 4 bytes of address and then start sequencing
                    // if data write, get the data. else 
                    //start sequencing
                        if (~cstate.addrlen) begin
                            nxtstate.bulkdone       = 1'b0;
                            // assert irdy only when its a read (and 16bit addr). for a write get the write data first
                            if (~cstate.opcode[0]) begin
                                nxtstate.irdy       = ~parity_err;
                                nxtstate.count      = 4'b1100;
                                nxtstate.rdyfornxtput = 1'b0;
                            end else //write opcode
                                nxtstate.count      = 4'b1011;
                        end else begin // addrlen
                            nxtstate.count      = 4'b1010;
                        end
                        if (eom)
                            nxtstate.chunkeom   = 1'b1;
                        // Check 1: Input message is shorter when addrelen bit is set - error packet
                        if (eom & cstate.addrlen)
                            nxtstate.err = '1;
                    end else begin // other bytes
                        nxtstate.count = 4'b1001;
                    end
                end
                
      5'b01010: begin // 6Byte address
                    // enter this state only when addrlen is set
                    if (cstate.addrlen) begin
                      unique casez (INTERNALPLDBIT)
                        31: begin
                            if (MAXADDR > 15)
                                nxtstate.addr[MAXADDR:MINADDR] = data;
                          end
                        15: begin 
                            if (first_byte) nxtstate.addrbuf[15: 0] = data;  // lintra s-0396
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
                    end

                    if (last_byte) begin
                        if (cstate.opcode[0]) begin
                            // if write, fetch the write data
                            nxtstate.count  = 4'b1011;
                        end else begin
                            // if read, start sequencing
                            nxtstate.irdy           = ~parity_err;
                            nxtstate.count          = 4'b1100;
                            nxtstate.rdyfornxtput   = 1'b0;
                        end
                        if (eom)
                            nxtstate.chunkeom       = 1'b1;
                    end else
                        nxtstate.count  = 4'b1010;
                  
                  // An error occurs if any of the unsupported address bits are
                  // active, which would cause an aliasing error.  
                  // Check 2: If there is a write, but there is a EOM, its an incorrect packet
                  unique casez (INTERNALPLDBIT)
                  31: begin
                            nxtstate.err |= ((|(ADDRMASK[31:0] & data)) | (eom & cstate.opcode[0] & last_byte));
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
                  invalid_bulkaddr: assert ( ~( (|(ADDRMASK[31:0] & data)) | (eom & cstate.opcode[0] & last_byte)) ||  (reset !== 1'b1) ) else
                    $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Access to unsupported address range.", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);
//coverage on
 `endif // SynTranlateOn
`endif
`endif                                                 
                      end
                  15: begin
                            nxtstate.err |= ( (|(ADDRMASK[31:0] & {data,cstate.addrbuf[15:0]} & {31{last_byte}})) | (eom & cstate.opcode[0] & last_byte)); // lintra s-0393, s-2056
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
                  invalid_bulkaddr_15bit: assert ( ~( (|(ADDRMASK[31:0] & {data,cstate.addrbuf[15:0]} & {31{last_byte}})) | (eom & cstate.opcode[0] & last_byte)) ||  (reset !== 1'b1) ) else
                    $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Access to unsupported address range.", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);                            
//coverage on
 `endif // SynTranlateOn
`endif
`endif                                            
                        end
             default: begin
                            nxtstate.err |= ( (|(ADDRMASK[31:0] & {data,cstate.addrbuf[23:0]} & {31{last_byte}})) | (eom & cstate.opcode[0] & last_byte));// lintra s-0393, s-2056
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off
                  invalid_bulkaddr_7bit: assert ( ~( (|(ADDRMASK[31:0] & {data,cstate.addrbuf[23:0]} & {31{last_byte}})) | (eom & cstate.opcode[0] & last_byte)) ||  (reset !== 1'b1) ) else
                    $display("%0t: %m: ERROR: Invalid ingress message: S=%h D=%h OPCODE=%h : Access to unsupported address range.", $time, nxtstate.source, nxtstate.dest, nxtstate.opcode);                            
//coverage on
 `endif // SynTranlateOn
`endif
`endif                                            
                      end
                   endcase
                end
      
      5'b01011: begin // write data

                  if (put) begin
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
//                    nxtstate.count = last_byte ? 4'b1100 : 4'b1011;
                    if (last_byte) begin
                        nxtstate.irdy           = ~parity_err;
                        nxtstate.rdyfornxtput   = 1'b0;
                        if (eom)
                            nxtstate.chunkeom   = 1'b1;
                    end
                  end //end if(put)

                  if (pop) begin
                    // treg should be in SEQRDWR state as long as bulkdone is 0. so on every pop (trdy), shift out the next address
                        if ((cstate.bulkdatalen-8'h01) != '0) begin
                            nxtstate.bulkdatalen    = cstate.bulkdatalen - 8'h01;
                            nxtstate.addr           = cstate.addr + ({{MAXADDR-7{1'b0}},8'h04}); // increment address in 4 byte chunks
                            if (~(put & last_byte)) begin
                                nxtstate.irdy           = 1'b0;
                                nxtstate.rdyfornxtput   = 1'b1;
                            end
                            nxtstate.count          = 4'b1011;
                        end

                    // bulkdone -> all the bulkrdwrs are done for all the message chunks 
                    // if eom for a particular chunk is already set (in tmsg), send eom for the the bulkrdwrs too and reset the state, 
                    // if eom for the chunk is not set, get the next chunk's first 8 bytes (cos it is already available at this point from tmsg)
                        else if ((cstate.bulkdatalen-8'h01) == '0) begin
                        // pop on last datalen then ready for next put from tmsg
                        // if chunkeom is already set at this point, reset everything
                            nxtstate.rdyfornxtput   = 1'b1;
//                            if (~(put & last_byte)) begin
                              nxtstate.irdy           = 1'b0;
//                            end
                            if (cstate.chunkeom) begin
                                nxtstate.bulkdone   = 1'b1;
                                nxtstate.count      = '0;
                                nxtstate.bulkopcode = '0;
                                nxtstate.bulkread   = '0;
                                nxtstate.chunkeom   = '0;
                            end
                            else begin
                                //fetch new chunk
                                nxtstate.count      = 4'b1001;
                            end
                        end
                    end // end of pop

                    // Check 3: If eom happens before all datalen is done, its an incorrect packet
                    // if put and pop happen on the same clock then datalen should be 2 else if there is only a put & eom, it should be 1
                    if (put & pop & eom & ((cstate.bulkdatalen-8'h02) != '0))
                         nxtstate.err    = '1;
                    else if (put & ~pop & eom & ((cstate.bulkdatalen-8'h01) != '0))
                         nxtstate.err    = '1;
                    else if (pop & treg_cerr)
                         nxtstate.err    = '1;

                end
      5'b01100: begin // sequencing address
                    // irdy is alreayd set to 1
                    // rdyfornxtput is set to 0
                    if (pop) begin
                    // treg should be in SEQRDWR state as long as bulkdone is 0. so on every pop (trdy), shift out the next address
                        if ((cstate.bulkdatalen-8'h01) != '0) begin
                            nxtstate.bulkdatalen    = cstate.bulkdatalen - 8'h01;
                            nxtstate.addr           = cstate.addr + ({{MAXADDR-7{1'b0}},8'h04}); // increment address in 4 byte chunks
//                            if (cstate.opcode[0]) begin
//                                nxtstate.irdy           = 1'b0;
//                                nxtstate.rdyfornxtput   = 1'b1;
//                                nxtstate.count          = 4'b1011;
//                            end
//                            else begin
                                nxtstate.irdy           = ~parity_err;
                                nxtstate.rdyfornxtput   = 1'b0;
//                            end
                        end
                    // bulkdone -> all the bulkrdwrs are done for all the message chunks 
                    // if eom for a particular chunk is already set (in tmsg), send eom for the the bulkrdwrs too and reset the state, 
                    // if eom for the chunk is not set, get the next chunk's first 8 bytes (cos it is already available at this point from tmsg)
                        else if ((cstate.bulkdatalen-8'h01) == '0) begin
                        // pop on last datalen then ready for next put from tmsg
                        // if chunkeom is already set at this point, reset everything
                            nxtstate.rdyfornxtput   = 1'b1;
                            nxtstate.irdy           = 1'b0;
                            if (cstate.chunkeom) begin
                                nxtstate.bulkdone   = 1'b1;
                                nxtstate.count      = '0;
                                nxtstate.bulkopcode = '0;
                                nxtstate.bulkread   = '0;
                                nxtstate.chunkeom   = '0;
                            end
                            else begin
                                //fetch new chunk
                                nxtstate.count      = 4'b1001;
                            end
                        end
                        if (treg_cerr)
                            nxtstate.err    = '1;
                    end // end of pop
                end
    endcase
  end else if (pop & ~cstate.bulkopcode) begin
    // Clear the state when the message completes on the target register
    // access interface
    nxtstate.irdy  = '0;
    nxtstate.count = '0;
  end
endfunction

regstate fstate;

always_ff @(posedge side_clk or negedge side_rst_b)
    if (~side_rst_b) begin
      // Flop count:
        fstate.rdyfornxtput <= 1'b1;
        fstate.bulkdone     <= 1'b1;
        fstate.count        <= '0;
		fstate.err          <= '0;
		fstate.irdy         <= '0;
		fstate.data         <= '0;
		fstate.addr         <= '0; 
		fstate.fid          <= '0; 
		fstate.be           <= '0; 
		fstate.addrlen      <= '0; 
		fstate.bar          <= '0; 
		fstate.eh           <= '0; 
		fstate.eh_discard   <= '0; 
		fstate.ext_hdr_cnt  <= '0; 
		fstate.ext_hdr      <= '0; 
		fstate.tag          <= '0; 
		fstate.opcode       <= '0; 
		fstate.source       <= '0; 
		fstate.dest         <= '0; 
		fstate.source_f     <= '0; 
		fstate.dest_f       <= '0; 
		fstate.addrbuf      <= '0; 
		fstate.bulkdatalen  <= '0; 
		fstate.bulkspace    <= '0; 
		fstate.bulkopcode   <= '0;
		fstate.bulkread     <= '0;
		fstate.chunkeom     <= '0;
		fstate.resetstate   <= '0;
    end
    else begin
        // Capture flops / state update
        fstate <= nxtstate( fstate, side_rst_b, pop, put, eom, first_byte, second_byte, third_byte, last_byte, msgip, data, parity_err, treg_cerr);
        if ( (NP==1) & pop & (~fstate.opcode[0]))
// this will change after spec clarification: When there is an input error on the rd data, 0 out all the data
            fstate.data <= treg_rdata;
    end

always_comb begin
    op_count        = fstate.count;
    op_err          = fstate.err;
// non bulk irdy is checked for parity errors in the fsm itself. bulk irdy's need to be checked at the very end (cos the irdy can be asserted any time for bulk)
    op_irdy         = fstate.irdy & rdyfornxtirdy;
    op_data         = fstate.data;
    op_addr         = fstate.addr;
    op_addrbuf      = fstate.addrbuf;
    op_fid          = fstate.fid;
    op_be           = fstate.be;
    op_addrlen      = fstate.addrlen;
    op_bar          = fstate.bar;
    op_eh           = fstate.eh;
    op_eh_discard   = fstate.eh_discard;
    op_ext_hdr      = fstate.ext_hdr;
    op_tag          = fstate.tag;
    op_opcode       = fstate.opcode;
    op_source       = fstate.source;
    op_dest         = fstate.dest;
    op_bulkopcode   = fstate.bulkopcode;
    op_bulkread     = fstate.bulkread;
    op_bulkeom      = fstate.chunkeom & fstate.bulkopcode & (fstate.bulkdatalen==8'h01) & pop;
    if (NP==1) begin
      rdyfornxtput    = fstate.rdyfornxtput;
    end else begin
      rdyfornxtput    = fstate.rdyfornxtput | (pop & ~((fstate.bulkdatalen-8'h01) == '0)  );      
    end
end

endmodule

// lintra pop
