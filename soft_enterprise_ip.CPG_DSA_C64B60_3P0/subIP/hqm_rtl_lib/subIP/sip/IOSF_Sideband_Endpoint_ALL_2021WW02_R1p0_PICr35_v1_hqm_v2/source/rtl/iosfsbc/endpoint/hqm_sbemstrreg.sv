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
//  Module sbemstrreg : The master register access interface block instantiated
//                      in the sideband interface endpoint (sbendpoint).
//
//------------------------------------------------------------------------------

// lintra push -60020, -60088, -80028, -80095, -68001, -60024b, -2050, -70036_simple
// 52523 : Repeated (local) parameter: ... (e.g. MAXADDR). Already defined in ....
// lintra push -52523

module hqm_sbemstrreg
#(
  parameter MAXMSTRADDR           = 31,  // Maximum address/data bits supported by the
  parameter INTERNALPLDBIT        = 7, // Maximum payload bit, should be 7, 15 or 31
  parameter MAXMSTRDATA           = 63,   // master register access interface
  parameter SB_PARITY_REQUIRED    = 0,
  parameter TX_EXT_HEADER_SUPPORT = 0,
  parameter NUM_TX_EXT_HEADERS    = 0,
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - START
  parameter UNIQUE_EXT_HEADERS    = 0,  // set to 1 to make the register agent modules use the new extended header
  parameter SAIWIDTH              = 15, // SAI field width - MAX=15
  parameter RSWIDTH               = 3,   // RS field width - MAX=3
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - FINISH
// Hierarchical Bridge PCR
  parameter GLOBAL_EP             = 0,
  parameter GLOBAL_EP_IS_STRAP    = 0

)(
  // Clock/Reset Signals
  input  logic                           side_clk, 
  input  logic                           side_rst_b,

  // Interface to the clock gating ISM
  output logic                           idle_mstrreg,

  // Interface to the target side of the base endpoint (sbebase)
  input  logic                           mmsg_pctrdy,
  input  logic                           mmsg_nptrdy,
  input  logic                           mmsg_pcsel,
  input  logic                           mmsg_npsel,
  input  logic                           mmsg_npmsgip, // lintra s-0527, s-70036 "Going to leave this for now, may be a reason that it was left here"
  output logic                           mmsg_pcirdy,
  output logic                           mmsg_npirdy,
  output logic                           mmsg_pceom,
  output logic                           mmsg_npeom,
  output logic                           mmsg_pcparity,
  output logic                           mmsg_npparity,
  output logic [INTERNALPLDBIT:0]        mmsg_pcpayload,
  output logic [INTERNALPLDBIT:0]        mmsg_nppayload,

  // Master Register Access Interface
                                                      // From the IP block:
  input  logic                           mreg_irdy,   //   Reg access msg ready
  input  logic                           mreg_npwrite,//   Np=1 / posted=0 write
  input  logic                     [7:0] mreg_dest,   //   Destination Port ID
  input  logic                     [7:0] mreg_source, //   Source Port ID
  input  logic                     [7:0] mreg_opcode, //   Reg Access Opcode
  input  logic                           mreg_addrlen,//   Address length
  input  logic                     [2:0] mreg_bar,    //   Selected BAR
  input  logic                     [2:0] mreg_tag,    //   Transaction tag
  input  logic [(MAXMSTRDATA == 31 ? 3 : 7):0] mreg_be,     //   Byte enables
  input  logic                     [7:0] mreg_fid,    //   Function ID (used to be routing ID)
  input  logic [((MAXMSTRADDR < 15) ? 15 : (MAXMSTRADDR > 47) ? 47 : MAXMSTRADDR):0] mreg_addr,   //   Address
  input  logic [(MAXMSTRDATA == 31 ? 31 : 63):0] mreg_wdata,  //   Write data
                                                      // From the endpoint:
  output logic                           mreg_trdy,   //   Target (endpnt) ready
  output logic                           mreg_pmsgip, //
  output logic                           mreg_nmsgip, //
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
  input  logic                           mreg_sairs_valid, // lintra s-0527 s-70036 "Indicates when the sairs inputs are valid and should be used"
  input  logic [SAIWIDTH:0]              mreg_sai,         // lintra s-0527 s-70036 "SAI value for extended headers"
  input  logic [RSWIDTH:0]               mreg_rs,          // lintra s-0527 s-70036 "RS value for extended headers"
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH
// Hier Bridge PCR
  input  logic                           global_ep_strap, // lintra s-70036 s-0527 "only for global EP"
  input  logic                     [7:0] mreg_hier_destid,
  input  logic                     [7:0] mreg_hier_srcid,
  output logic                    [15:0] dbgbus,
  input  logic [NUM_TX_EXT_HEADERS:0][31:0] tx_ext_headers // lintra s-0527 s-70036 "TX Extended Headers may not always be used"
);

`include "hqm_sbcglobal_params.vm"
`include "hqm_sbcfunc.vm"
  
// PCR 12042104 - Unique Extended Headers localparameter assignments - START
// Add up all the supported unique extended headers to give a non-zero value
// if TX_EXT_HEADER_SUPPORT is present
localparam NUM_UNIQUE_EH = (TX_EXT_HEADER_SUPPORT == 0) ? 0 : UNIQUE_EXT_HEADERS; 
localparam NUM_TX_EH = (NUM_UNIQUE_EH > 0) ? 127 : NUM_TX_EXT_HEADERS;
// PCR 12042104 - Unique Extended Headers localparameter assignments - FINISH

localparam MAXADDR = (MAXMSTRADDR < 15) ? 15 : (MAXMSTRADDR > 47) ? 47 : MAXMSTRADDR;
localparam MAXDATA = MAXMSTRDATA == 31 ? 31 : 63;
localparam MAXBE   = MAXMSTRDATA == 31 ? 3 : 7;
localparam MAXADDRINDATA = MAXADDR==15 ? 0 : MAXADDR-16;
localparam MINADDR       = MAXADDR==15 ? 15 : 16;
localparam DW2BEMIN      = MAXBE==7 ? 4 : 0;
localparam NUM_TX_EXT_HEADERS_L2 = sbc_indexed_value( NUM_TX_EH ); // PCR 12042104 - Overloading tx_eh_cnt

logic                           qword; 
logic                           write;
logic                           mreg_np;
logic [                    2:0] pcount;  // Posted transfer count
logic [                    2:0] ncount;  // Non-posted transfer count
logic [NUM_TX_EXT_HEADERS_L2:0] p_eh_cnt;
logic [NUM_TX_EXT_HEADERS_L2:0] np_eh_cnt;
// PCR 12042104 - Unique Extended Header Support variables - START
logic                           np_eh_remaining;   // Local variable used to keep track of the presence of any valid unique headers unsent.
logic                           p_eh_remaining;    // Local variable used to keep track of the presence of any valid unique headers unsent.
logic [                   31:0] np_ext_header_mux; // Final muxed extended header data.
logic [                   31:0] p_ext_header_mux;  // Final muxed extended header data.
logic [NUM_TX_EXT_HEADERS_L2:0] np_eh_cnt_next;    // lintra s-70036 "Next tx_eh_cnt value during header transfer may not always get exercised"
logic [NUM_TX_EXT_HEADERS_L2:0] p_eh_cnt_next;     // lintra s-70036 "Next tx_eh_cnt value during header transfer may not always get exercised"
// PCR 12042104 - Unique Extended Header Support variables - FINISH
  



logic mreg_pc_first_byte; // lintra s-70036
logic mreg_pc_second_byte;
logic mreg_pc_third_byte;
logic mreg_pc_last_byte;

logic mreg_np_first_byte;// lintra s-70036
logic mreg_np_second_byte;
logic mreg_np_third_byte;
logic mreg_np_last_byte;

logic   [31:0]pc_data;
logic   [31:0]np_data;

logic hier_hdr_en;
always_comb hier_hdr_en = ((GLOBAL_EP == 1) || ((GLOBAL_EP_IS_STRAP == 1) && (global_ep_strap == 1'b1))) ? 1'b1 : 1'b0;

generate
    if (INTERNALPLDBIT ==31) begin: gen_mreg_be_31
        always_comb mreg_pc_first_byte  = 1'b1;
        always_comb mreg_pc_second_byte = 1'b1;
        always_comb mreg_pc_third_byte  = 1'b1;
        always_comb mreg_pc_last_byte   = 1'b1;
        always_comb mreg_np_first_byte  = 1'b1;
        always_comb mreg_np_second_byte = 1'b1;
        always_comb mreg_np_third_byte  = 1'b1;
        always_comb mreg_np_last_byte   = 1'b1;    
    end
    else begin: gen_mreg_be_15_7
        logic mreg_pcvalid;
        logic mreg_npvalid;
            
        always_comb mreg_pcvalid = mmsg_pcirdy & mmsg_pctrdy & mmsg_pcsel;
        always_comb mreg_npvalid = mmsg_npirdy & mmsg_nptrdy & mmsg_npsel;

        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_mstrreg_pc (
            .side_clk           (side_clk),
            .side_rst_b         (side_rst_b),
            .valid              (mreg_pcvalid),
            .first_byte         (mreg_pc_first_byte),
            .second_byte        (mreg_pc_second_byte),
            .third_byte         (mreg_pc_third_byte),
            .last_byte          (mreg_pc_last_byte)
        );

        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_mstrreg_np (
            .side_clk           (side_clk),
            .side_rst_b         (side_rst_b),
            .valid              (mreg_npvalid),
            .first_byte         (mreg_np_first_byte),
            .second_byte        (mreg_np_second_byte),
            .third_byte         (mreg_np_third_byte),
            .last_byte          (mreg_np_last_byte)
        );
    end
endgenerate

generate
    if (INTERNALPLDBIT ==31) begin: gen_mreg_databus_31
        always_comb mmsg_pcpayload  =   pc_data;
        always_comb mmsg_nppayload  =   np_data;
    end
    else if (INTERNALPLDBIT ==15) begin: gen_mreg_databus_15
        always_comb mmsg_pcpayload  =   mreg_pc_last_byte ? pc_data[31:16] : pc_data[15:0];
        always_comb mmsg_nppayload  =   mreg_np_last_byte ? np_data[31:16] : np_data[15:0];
    end
    else begin: gen_mreg_databus_7
        always_comb mmsg_pcpayload  =   mreg_pc_second_byte ? pc_data[15:8] : (mreg_pc_third_byte ? pc_data[23:16] : (mreg_pc_last_byte ? pc_data[31:24] : pc_data[7:0]));
        always_comb mmsg_nppayload  =   mreg_np_second_byte ? np_data[15:8] : (mreg_np_third_byte ? np_data[23:16] : (mreg_np_last_byte ? np_data[31:24] : np_data[7:0]));
    end
endgenerate

generate
    if (SB_PARITY_REQUIRED) begin: gen_mreg_parity
        always_comb mmsg_pcparity = ^{mmsg_pcpayload, mmsg_pceom};
        always_comb mmsg_npparity = ^{mmsg_nppayload, mmsg_npeom};
    end
    else begin: gen_mreg_noparity
        always_comb mmsg_pcparity = '0;
        always_comb mmsg_npparity = '0;
    end
endgenerate



// This function muxes the data from the master interface to the egress
// interface.  
// HSD:1303906757 Xprop + Lintra fix for function calls
function automatic logic [31:0] datamux ( logic       [2:0] count,  // Transfer counter
                                logic       [7:0] dest,   // Destination port ID
                                logic       [7:0] source, // Source port ID
                                logic       [7:0] opcode, // There rest of the
                                logic             addrlen,// fields are directly
                                logic       [2:0] bar,    // from the IOSF spec.
                                logic       [2:0] tag,
                                logic   [MAXBE:0] be,
                                logic       [7:0] fid,
                                logic [MAXADDR:0] addr,
                                logic [MAXDATA:0] data,
                                // Hier Bridge PCR
                                logic       [7:0] hier_destid,
                                logic       [7:0] hier_srcid,
// PCR 12042104 - Change data mux function to use muxed EH data - START
                                logic             more_ext_hdr,
                                logic [     31:0] ext_hdr );
// PCR 12042104 - Change data mux function to use muxed EH data - START
logic [47:0] faddr;
logic [63:0] fdata;
logic [ 7:0] lbefbe;
    begin
        faddr = '0; faddr[MAXADDR:0] = addr;
        fdata = '0; fdata[MAXDATA:0] = data;
        lbefbe = '0; lbefbe[MAXBE:0] = be;

        if (hier_hdr_en == 1'b0) begin
            unique casez (count) // lintra s-0257 "description in lintra webpage not clear for parallel case statements"
    
            // Note: the third transfer is skipped if addrlen=0
            // First transfer:  Standard 4 byte message header
            3'b000  : datamux = { more_ext_hdr, addrlen, bar, tag, opcode, source, dest};
    
            // Second transfer: extended headers, if present.
            3'b001  : datamux = ext_hdr; // lintra s-0241

            // Third transfer: Lower 16 bits of address, routing ID and byte enables
            3'b010  : datamux = { faddr[15:0], fid, lbefbe };
    
            // Fourth transfer:  Upper order address bits
            3'b011  : datamux = faddr[47:16];
   
            // Fifth transfer: First dword of write data
            3'b100  : datamux = fdata[31:0];
    
            // Sixth transfer: Second dword of write data
            default : datamux = fdata[63:32];
            endcase
        end
        else begin // if in hier routing header mode
            unique casez (count) // lintra s-0257 "description in lintra webpage not clear for parallel case statements"
    
            // Note: the third transfer is skipped if addrlen=0
            // First transfer:  Hier Bridge 4 byte header
            3'b000  : datamux = { 16'h0000, hier_srcid, hier_destid};
            
            // Second transfer:  Standard 4 byte message header
            3'b001  : datamux = { more_ext_hdr, addrlen, bar, tag, opcode, source, dest};
    
            // Third transfer: extended headers, if present.
            3'b010  : datamux = ext_hdr; // lintra s-0241

            // Fourth transfer: Lower 16 bits of address, routing ID and byte enables
            3'b011  : datamux = { faddr[15:0], fid, lbefbe };
    
            // Fifth transfer:  Upper order address bits
            3'b100  : datamux = faddr[47:16];
   
            // Sixth transfer: First dword of write data
            3'b101  : datamux = fdata[31:0];
    
            // Seventh transfer: Second dword of write data
            default : datamux = fdata[63:32];
            endcase
        end
    end
endfunction


// This function muxes the eom from the master interface to the egress
// interface.  
// HSD:1303906757 Xprop + Lintra fix for function calls
function automatic logic eommux ( logic [2:0] count,     // Current transfer
                        logic       write,     // Register access write
                        logic       addrlen,   // Address length
                        logic       last_byte,   // Address length
                        logic       qword   ); // Asserted when sbe not 0

    if (hier_hdr_en == 1'b0) begin
        unique casez (count)// lintra s-0257 "description in lintra webpage not clear for parallel case statements"

            // Note: the fourth transfer is skipped if addrlen=0
            // First transfer is never the eom (register access is at least 8 bytes)
            // "Second" transfer is never the EOM (extended headers)
            3'b001,
            3'b000  : eommux = '0;

            // Third transfer is only the eom for read with 16-bit addrlen
            3'b010  : eommux = ~write & ~addrlen & last_byte;

            // Fourth transfer is eom only if the message is a read
            3'b011  : eommux = ~write & last_byte;

            // Fifth transfer is eom only for 1 dword write
            3'b100  : eommux = ~qword & last_byte;

            // Sixth transfer is always the eom; (qword write)
            default : eommux = last_byte;
        endcase       
    end
    else begin // if in hier routing header mode
        unique casez (count) // lintra s-0257 "description in lintra webpage not clear for parallel case statements"

            // Note: the fourth transfer is skipped if addrlen=0
            // First transfer is the hier routing header (8 bytes)
            // Second transfer is never the eom (register access is at least 8 bytes)
            // "Third" transfer is never the EOM (extended headers)
            3'b010,
            3'b001,
            3'b000  : eommux = '0;

            // Fourth transfer is only the eom for read with 16-bit addrlen
            3'b011  : eommux = ~write & ~addrlen & last_byte;

            // Fifth transfer is eom only if the message is a read
            3'b100  : eommux = ~write & last_byte;

            // Sixth transfer is eom only for 1 dword write
            3'b101  : eommux = ~qword & last_byte;

            // Seventh transfer is always the eom; (qword write)
            default : eommux = last_byte;
        endcase        
    end
endfunction

// Idle signal sent to the clock gating ISM
always_comb idle_mstrreg = ~(|pcount) & ~(|ncount) & ~mreg_pmsgip & ~mreg_nmsgip;

// Determine if the register access is a dword or a qword
always_comb qword = (MAXBE==7) & (|mreg_be[MAXBE:DW2BEMIN]);

// Determine if the register access message is a write or a read
always_comb write   = mreg_opcode[0];        // Bit 0 of the opcode indicates a write

// Determine if the register access message is posted or non-posted
always_comb mreg_np = ~write | mreg_npwrite; // Non-posted = read or non-posted write

// Posted/non-posted trdy is asserted to the master interface when the last
// transfer (eom) has been accepted into the egress block.
always_comb mreg_trdy   = (mmsg_pcsel & mmsg_pctrdy & mmsg_pceom) |
                          (mmsg_npsel & mmsg_nptrdy & mmsg_npeom);

// Generate the irdy signals for the master interface to the base endpoint
always_comb mmsg_pcirdy = ~mreg_np & mreg_irdy;
always_comb mmsg_npirdy =  mreg_np & mreg_irdy;

// Payload/eom muxes between the register access master interface and the
// master interface to the base endpoint
always_comb mmsg_pceom     = eommux( pcount, write, mreg_addrlen, mreg_pc_last_byte, qword );
always_comb mmsg_npeom     = eommux( ncount, write, mreg_addrlen, mreg_np_last_byte, qword );

always_comb pc_data = datamux( pcount,
                                      mreg_dest,
                                      mreg_source,
                                      mreg_opcode,
                                      mreg_addrlen,
                                      mreg_bar,
                                      mreg_tag,
                                      mreg_be,
                                      mreg_fid,
                                      mreg_addr,
                                      mreg_wdata,
                                      // Hier Bridge PCR
                                      mreg_hier_destid,
                                      mreg_hier_srcid,
// PCR 12042104 - Change data mux function to use mux data - START
                                      p_eh_remaining,
                                      p_ext_header_mux );
// PCR 12042104 - Change data mux function to use mux data - FINISH

always_comb np_data = datamux( ncount,
                                      mreg_dest,
                                      mreg_source,
                                      mreg_opcode,
                                      mreg_addrlen,
                                      mreg_bar,
                                      mreg_tag,
                                      mreg_be,
                                      mreg_fid,
                                      mreg_addr,
                                      mreg_wdata,
                                      // Hier Bridge PCR
                                      mreg_hier_destid,
                                      mreg_hier_srcid,
// PCR 12042104 - Change data mux function to use mux data - START
                                      np_eh_remaining,
                                      np_ext_header_mux );
// PCR 12042104 - Change data mux function to use mux data - FINISH

// PCR 12042104 - Extended headers selection MUX - START
generate
   if( |TX_EXT_HEADER_SUPPORT ) begin : gen_tx_ext_header_mux
      if( |NUM_UNIQUE_EH ) begin : gen_unique_ext_header
         logic [NUM_UNIQUE_HEADERS:0] np_eh_valid;       // local variable used to keep track of active extended headers
         logic [NUM_UNIQUE_HEADERS:0] np_eh_valid_pre;   // local variable used to set tx_eh_valid with the extended headers that will be required.
         logic [NUM_UNIQUE_HEADERS:0] np_eh_clear;       // clear bit to clear tx_eh_valid bits.
         logic [NUM_UNIQUE_HEADERS:0] np_eh_valid_clear; // local variable used to set tx_eh_valid with the extended headers that will be required.
         logic [NUM_UNIQUE_HEADERS:0] p_eh_valid;        // local variable used to keep track of active extended headers
         logic [NUM_UNIQUE_HEADERS:0] p_eh_valid_pre;    // local variable used to set tx_eh_valid with the extended headers that will be required.
         logic [NUM_UNIQUE_HEADERS:0] p_eh_clear;        // clear bit to clear tx_eh_valid bits.
         logic [NUM_UNIQUE_HEADERS:0] p_eh_valid_clear;  // local variable used to set tx_eh_valid with the extended headers that will be required.

         // extended header valid pre signal. Used to uniformly capture each
         // supported unique extended header. As new types are this should
         // grow and have the corresponding valid bit appended. The usage of
         // the always comb block is unnecessary but should help make the code
         // readable.
         always_comb begin
            np_eh_valid_pre             = '0;
            np_eh_valid_pre[EHVB_SAIRS] = mreg_sairs_valid;
         end

         always_comb begin
            p_eh_valid_pre             = '0;
            p_eh_valid_pre[EHVB_SAIRS] = mreg_sairs_valid;
         end

         // extended header valid signal off of a flop. Used by to keep track of
         // all the uniqueue exteneded headers that require servicing. Each
         // should be cleared as accepted by the master message module.
         // 1. Should lock in the value as soon as possible which is when the
         //    register module will first indicate its intentions to mmsg*.
         // 2. Clear the bits as each flit is sent in. The eh_valid_clear
         //    signal already indicates when an EH flit has been sent.
         always_ff @( posedge side_clk or negedge side_rst_b )
            if( !side_rst_b )
               np_eh_valid <= '0;
            else if( mmsg_npsel && mmsg_npirdy ) begin
               if( !mreg_nmsgip ) // lintra s-60032
                  np_eh_valid <= np_eh_valid_pre;
               else if( mmsg_nptrdy )
                  np_eh_valid <= np_eh_valid_clear;
            end

         always_ff @( posedge side_clk or negedge side_rst_b )
            if( !side_rst_b )
               p_eh_valid <= '0;
            else if( mmsg_pcsel && mmsg_pcirdy ) begin
               if( !mreg_pmsgip ) // lintra s-60032
                  p_eh_valid <= p_eh_valid_pre;
               else if( mmsg_pctrdy )
                  p_eh_valid <= p_eh_valid_clear;
            end

         // np_eh_cnt and p_eh_cnt are being used to act like an arbiter to
         // select which of the valid extended headers should go out at any
         // given time. Each extended header type that gets added to the spec
         // will have to go into this array. The order that the bit gets checked
         // in the checks below will determine the load order of the extended
         // header.
         // NOTE: If timing becomes too difficult to deal with when more
         //       extended headers are added a on-hot encoded arbiter pointer
         //       could be used instead.
         //
         // n/p_eh_clear is used to clear away the currently extended headers
         // valid flag. These should only be cleared away while in the extended
         // header phase (n/pcount == 3'b001, when there is no hier routing [aka local endpoint] "OR"
         // when n/pcount == 3'b010, when there is hier routing [aka global endpoint]). 
         // Otherwise extended headers may get taken away while waiting for 
         // the register module to get access to the mmsg interface.
         //
         // n/p_eh_remaining is used to indicate when there are extended headers
         // to be sent. The currently selected extended header should not be
         // counted at the same time. Due to the pass through nature of the mreg
         // module between the agent and the mmsg interface the remaining
         // indicator must select the input version of np_eh_valid until it the
         // official start of the completion message. Otherwise you will get
         // assertions and unknown values on the IOSF outputs.
         always_comb begin
            np_eh_cnt_next = '0;
            np_eh_clear    = '0;

            if( np_eh_valid[EHVB_SAIRS] ) begin
               np_eh_cnt_next          = EHOP_SAIRS;
               np_eh_clear[EHVB_SAIRS] = 1'b1;
            end
// if hier bridge (global endpoint), there ll be an additional header => 
// counts will increase by 1 to reach the ext header byte of the actual message

            if( ((hier_hdr_en == 1'b0) && (ncount == 3'b001)) || ((hier_hdr_en == 1'b1) && (ncount == 3'b010)) ) begin
               np_eh_valid_clear = np_eh_valid & ~np_eh_clear;
            end else begin
               np_eh_valid_clear = np_eh_valid;
            end

            if( !mreg_nmsgip ) begin
               np_eh_remaining = |( np_eh_valid_pre );
            end else begin
               np_eh_remaining = |( np_eh_valid_clear );
            end
         end

         always_comb begin
            p_eh_cnt_next  = '0;
            p_eh_clear     = '0;

            if( p_eh_valid[EHVB_SAIRS] ) begin
               p_eh_cnt_next          = EHOP_SAIRS;
               p_eh_clear[EHVB_SAIRS] = 1'b1;
            end
// if hier bridge (global endpoint), there ll be an additional header => 
// counts will increase by 1 to reach the ext header of the actual message
            if( ((hier_hdr_en == 1'b0) && (pcount == 3'b001)) || ((hier_hdr_en == 1'b1) && (pcount == 3'b010))) begin
               p_eh_valid_clear = p_eh_valid & ~p_eh_clear;
            end else begin
               p_eh_valid_clear = p_eh_valid;
            end

            if( !mreg_pmsgip ) begin
               p_eh_remaining  = |( p_eh_valid_pre );
            end else begin
               p_eh_remaining  = |( p_eh_valid_clear );
            end
         end

         // Extended header mux will be used to select the appropriate
         // extended header that is currently in use. As new extended
         // headers are supported by the target register module the
         // 32-bit extended header field should go here. If there
         // ends up being an order dependency that can be fixed here
         // by changing the order in n/p_eh_cnt_next.
         always_comb begin
            np_ext_header_mux = '0;

            // Uniqueue Extended Headers Assignments for each one that
            // is created this will need to expand to accomidate.
            if( np_eh_cnt == EHOP_SAIRS ) begin
               np_ext_header_mux[          6: 0] = EHOP_SAIRS;
               np_ext_header_mux[             7] = np_eh_remaining;
               np_ext_header_mux[SAIWIDTH+ 8: 8] = mreg_sai[SAIWIDTH:0];
               np_ext_header_mux[ RSWIDTH+24:24] = mreg_rs [ RSWIDTH:0];
               np_ext_header_mux[         31:28] = 4'd0;
            end
         end

         always_comb begin
            p_ext_header_mux  = '0;

            if( p_eh_cnt == EHOP_SAIRS ) begin
               p_ext_header_mux[          6: 0] = EHOP_SAIRS;
               p_ext_header_mux[             7] = p_eh_remaining;
               p_ext_header_mux[SAIWIDTH+ 8: 8] = mreg_sai[SAIWIDTH:0];
               p_ext_header_mux[ RSWIDTH+24:24] = mreg_rs [ RSWIDTH:0];
               p_ext_header_mux[         31:28] = 4'd0;
            end
         end
      end else begin : gen_tx_ext_headers
         // Extended headers will be pulled from the tx_ext_headers bus.
         always_comb np_ext_header_mux = tx_ext_headers[np_eh_cnt]; // lintra s-0241 "gets flagged but the index should never actually be used out of bounds"
         always_comb p_ext_header_mux  = tx_ext_headers[p_eh_cnt];  // lintra s-0241 "gets flagged but the index should never actually be used out of bounds"

         always_comb begin
            if(((hier_hdr_en==1'b0) && (ncount == '0)) || ((hier_hdr_en==1'b1) && (ncount == 3'b001))) begin
               np_eh_remaining = 1'b1;
               np_eh_cnt_next  = np_eh_cnt;
            // PCR 1203799966 - index out-of-bound for tx_ext_headers array - START
            end else if (np_eh_cnt == NUM_TX_EXT_HEADERS) begin
               np_eh_remaining = 1'b0;
               np_eh_cnt_next  = np_eh_cnt;
            // PCR 1203799966 - index out-of-bound for tx_ext_headers array - FINISH
            end else begin
               np_eh_remaining = np_ext_header_mux[7];
               np_eh_cnt_next  = np_eh_cnt + 1'b1;
            end 

            if(((hier_hdr_en==1'b0) && (pcount == '0)) || ((hier_hdr_en==1'b1) && (pcount == 3'b001))) begin
               p_eh_remaining = 1'b1;
               p_eh_cnt_next  = p_eh_cnt;
            // PCR 1203799966 - index out-of-bound for tx_ext_headers array - START
            end else if (p_eh_cnt == NUM_TX_EXT_HEADERS) begin
               p_eh_remaining = 1'b0;
               p_eh_cnt_next  = p_eh_cnt;
            // PCR 1203799966 - index out-of-bound for tx_ext_headers array - FINISH
            end else begin
               p_eh_remaining = p_ext_header_mux[7];
               p_eh_cnt_next  = p_eh_cnt + 1'b1;
            end 
         end
      end
   end else begin : gen_tx_ext_headers_none
      // No extended headers will be used. Make everything a constant to help out BE tools.
      always_comb np_ext_header_mux = '0;
      always_comb np_eh_remaining   = 1'b0;
      always_comb np_eh_cnt_next    = '0;
      always_comb p_ext_header_mux  = '0;
      always_comb p_eh_remaining    = 1'b0;
      always_comb p_eh_cnt_next     = '0;
   end
endgenerate
// PCR 12042104 - Extended headers selection MUX - FINISH
logic [2:0] hier_count;

generate 
    if (GLOBAL_EP_IS_STRAP==1) begin: gen_mreghier_strap
        always_comb hier_count = global_ep_strap ? 3'b001 : '0;
    end
    else begin
    if (GLOBAL_EP == 1) begin: gen_hier_count
        always_comb hier_count = 3'b001;
    end
    else begin: gen_nohier_count
        always_comb hier_count = '0;
    end
end  
endgenerate 

always_ff @(posedge side_clk or negedge side_rst_b) begin
   if (!side_rst_b) begin
      pcount      <= '0;    // 3-bit posted transfer counter
      ncount      <= '0;    // 3-bit non-posted transfer counter
      mreg_pmsgip <= '0;    // 1-bit posted message in-progress indicator
      mreg_nmsgip <= '0;    // 1-bit non-posted message in-progress indicator
      p_eh_cnt    <= '0;
      np_eh_cnt   <= '0;
   end else begin
      // Transfer counters are zeroed on the last (eom) transfer and 
      // incremented otherwise
      if (mmsg_pcirdy & mmsg_pctrdy & mmsg_pcsel & mreg_pc_last_byte) begin

         // Making the code more readable by breaking apart the giant inline if statement string.
         if( mmsg_pceom ) begin // lintra s-60032 "Lintra is unable to figure out simple if-else trees"
            pcount <= '0;
         end else if( (((hier_hdr_en == 1'b0) && (pcount == 3'b010)) || ((hier_hdr_en == 1'b1) && (pcount == 3'b011))) 
                        && ( ~mreg_addrlen ) ) begin
            pcount <= 3'b100 + hier_count;
// PCR 12042104 - pcount is a function of remainig extended headers - START
         end else if( (((hier_hdr_en == 1'b0) && (pcount == 3'b000)) || ((hier_hdr_en == 1'b1) && (pcount == 3'b001))) 
                        && ( !p_eh_remaining ) ) begin
            pcount <= 3'b010 + hier_count;
         end else if( (((hier_hdr_en == 1'b0) && (pcount == 3'b001)) || ((hier_hdr_en == 1'b1) && (pcount == 3'b010))) 
                        && ( p_eh_remaining ) ) begin
            pcount <= pcount;
// PCR 12042104 - pcount is a function of remainig extended headers - FINISH
         end else if (mreg_pc_last_byte) begin
            pcount <= pcount + 3'b001;
         end

// PCR 12042104 - eh_cnt is a function of events - START
         p_eh_cnt <= p_eh_cnt_next;
// PCR 12042104 - eh_cnt is a function of events - FINISH
      end
    
      if (mmsg_npirdy & mmsg_nptrdy & mmsg_npsel & mreg_np_last_byte) begin
         // Making the code more readable by breaking apart the giant inline if statement string.
         if( mmsg_npeom ) begin // lintra s-60032 "Lintra is unable to figure out simple if-else trees"
            ncount <= '0;
         end else if( (((hier_hdr_en == 1'b0) && (ncount == 3'b010)) ||
         ((hier_hdr_en == 1'b1) && (ncount == 3'b011))) &&
                      ( ~mreg_addrlen ) ) begin
            ncount <= 3'b100 + hier_count;
// PCR 12042104 - ncount is a function of remainig extended headers - START
         end else if( (((hier_hdr_en == 1'b0) && (ncount == 3'b000)) ||
         ((hier_hdr_en == 1'b1) && (ncount == 3'b001))) &&
                      ( !np_eh_remaining ) ) begin
            ncount <= 3'b010 + hier_count;
         end else if( (((hier_hdr_en == 1'b0) && (ncount == 3'b001)) ||
         ((hier_hdr_en == 1'b1) && (ncount == 3'b010))) &&
                      ( np_eh_remaining ) ) begin
            ncount <= ncount;
// PCR 12042104 - ncount is a function of remainig extended headers - FINISH
         end else if (mreg_np_last_byte) begin
            ncount <= ncount + 3'b001;
         end

// PCR 12042104 - eh_cnt is a function of events - START
         np_eh_cnt <= np_eh_cnt_next;
// PCR 12042104 - eh_cnt is a function of events - FINISH
      end
    
      // Message in-progress indicators are cleared when the transfer is complete
      // on the master interface to the base endpoint and are set when the
      // master arbiter in the base endpoint sees the irdy signal for the
      // selected traffic class.
      mreg_pmsgip <= mreg_pmsgip ? ~(~mreg_np & mreg_irdy & mreg_trdy)
                                 : (mmsg_pcsel & mmsg_pcirdy & mreg_pc_last_byte);
      mreg_nmsgip <= mreg_nmsgip ? ~( mreg_np & mreg_irdy & mreg_trdy)
                                 : (mmsg_npsel & mmsg_npirdy & mreg_np_last_byte);
   end
end

// Debug Signals
always_comb dbgbus = { qword,
                  write,
                  mreg_np,
                  mreg_trdy,
                  mmsg_npirdy,
                  mmsg_pcirdy,
                  mmsg_npeom,
                  mmsg_pceom,
                  mreg_nmsgip,
                  ncount,
                  mreg_pmsgip,
                  pcount
                };

endmodule

// lintra pop
