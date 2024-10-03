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
//  Module sbebulkrdwrwrapper : The target register access interface block with bulk rd wr support within the
//                      sideband interface endpoint (sbendpoint).
//
//------------------------------------------------------------------------------


// lintra push -60020, -60088, -80028, -80095, -68001, -60024b, -50002, -2050, -70036_simple, -70044_simple, -60145
// 52523 : Repeated (local) parameter: ... (e.g. NUM_ACTUAL_RX_EXT_HEADERS). Already defined in ....
// lintra push -52523

module hqm_sbebulkrdwrwrapper #(
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
   parameter GLOBAL_EP_IS_STRAP     = 0,
   parameter BULK_PERF              = 0
) (
  // Clock/Reset Signals
  input  logic                           side_clk, 
  input  logic                           side_rst_b,
  
  // Interface to the clock gating ISM
  output logic                           idle_trgtreg,

  // Parity support
  input  logic                           cfg_parityckdef, // lintra s-70036, s-0527 parity defeature
  input  logic                           ext_parity_err_detected,
  // new for bulk to terminate bulk completions and mask bulk irdy's
  input  logic                           parity_err_from_base,
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
  localparam MAXDATA                    = MAXTRGTDATA; 
  localparam MAXBE                      = (MAXTRGTDATA == 31) ? 3 : 7;
  localparam logic [31:0]      ALLONES  = '1;
  localparam logic [31:0]      ADDRMASK = ALLONES << (MAXADDR-15); // lintra s-2063
  localparam MAXADDRINDATA              = MAXADDR==15 ? 0  : MAXADDR-16;
  localparam ADDRMOD                    = MAXADDR==15 ? 0  : 16;
  localparam MINADDR                    = MAXADDR==15 ? 15 : 16;
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
  localparam BULKADDR_START = (INTERNALPLDBIT ==31) ? 18 : 2;
  
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

logic treg_cerr_next;

always_comb treg_cerr_next = treg_cerr & treg_trdy & treg_np;

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
logic treg_input_parity_err_fsm;
logic parity_err_out_nxt;
logic parity_err_out_nxt_f;

generate 
    if (SB_PARITY_REQUIRED) begin : gen_treg_par
        logic parity_err_out_d;

        always_comb parity_err_out_d = tmsg_pcput ? (^{tmsg_pcpayload, tmsg_pceom, tmsg_pcparity} & ~cfg_parityckdef): 
                                      (tmsg_npput ? (^{tmsg_nppayload, tmsg_npeom, tmsg_npparity} & ~cfg_parityckdef): '0);

        always_comb parity_err_out_nxt = (parity_err_out_d | parity_err_out);

        always_ff @(posedge side_clk or negedge side_rst_b)
            if (~side_rst_b) begin
                parity_err_out          <= '0;
// to solve the timing loop                
                parity_err_out_nxt_f    <= '0;
            end
            else begin 
                parity_err_out_nxt_f    <= parity_err_out_nxt;
                if (parity_err_out_d)
                    parity_err_out <= 1'b1;
            end
    end

    else begin : gen_treg_nopar
        always_comb parity_err_out      = 1'b0;
        always_comb parity_err_out_nxt  = 1'b0;
        always_comb parity_err_out_nxt_f= 1'b0;
    end
endgenerate
// parity_err_out_nxt is the actual err with corresponding input data,eom,parity from tmsg. 
// and is wired to treg output (which is once again fed into tmsg to stop any further trdy's.
// But connecting parity_err_out_nxt directly to treg output causes combi loop 
// tmsg_put --> pariy_err_out --> treg_tmsg_parity_err_det -->tmsg_trdy (mask)-->tmsg_put
// Hence use a flopped parity_err_out to be sent out on treg.
// IP's using treg_tmsg_parity_err should not send any payload as soon as they see this asserted.

always_comb treg_tmsg_parity_err_det    = parity_err_out;
// this is was put in the last minute to solve a combi loop and not break anything. this might not be needed and the whole treg_input could be flopped and used for completions. and combined with the mmsg_parity corruption part

logic nstate_bulkopcode, pstate_bulkopcode;
// HSD:1408282604 - send out transactions (and their completions) that arrived before parity error for non-bulk opcodes
always_comb treg_input_parity_err       = (nstate_bulkopcode | pstate_bulkopcode) ? (treg_tmsg_parity_err_det | parity_err_out_nxt_f | ext_parity_err_detected | parity_err_from_base) : (treg_tmsg_parity_err_det | parity_err_out_nxt_f | ext_parity_err_detected);
always_comb treg_input_parity_err_fsm   = (nstate_bulkopcode | pstate_bulkopcode) ? (treg_tmsg_parity_err_det | parity_err_out_nxt | ext_parity_err_detected | parity_err_from_base) : (treg_tmsg_parity_err_det | parity_err_out_nxt | ext_parity_err_detected);

  // Structure for capturing the posted/non-posted register access message
  // and the current transfer count and irdy signal.
  
  // Function for capturing/updating the state of the register access
  // message transfers (posted and non-posted)
  
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
logic   [31:0]                  nonbulk_pcpayload, mmsg_pcpayload_mux;
logic   mmsg_pceom_int;
logic   src_dst_np_claim;
logic   tmsg_npclaim_hit;
logic   np_claim_ip; //lintra s-0531
logic   src_dst_pc_claim;
logic   tmsg_pcclaim_hit;
logic   pc_claim_ip; //lintra s-0531
logic   nstate_eom;
logic   pstate_eom;

logic [3:0] nstate_count, pstate_count;
logic pstate_eh, pstate_eh_discard, nstate_eh, nstate_eh_discard; //lintra s-70036
logic pstate_err, pstate_irdy, pstate_addrlen, nstate_err, nstate_irdy, nstate_addrlen, pstate_err_int, nstate_err_int;
logic [MAXDATA:0] nstate_data, pstate_data;
logic [MAXADDR:0] nstate_addr, pstate_addr;
logic [23:0] nstate_addrbuf, pstate_addrbuf;//lintra s-70036
logic [MAXBE:0] nstate_be, pstate_be;
logic [2:0] nstate_bar, nstate_tag;
logic [2:0] pstate_bar, pstate_tag;
logic [NUM_ACTUAL_RX_EXT_HEADERS:0][31:0] nstate_ext_hdr, pstate_ext_hdr; //lintra s-70036
logic [7:0] nstate_fid, nstate_opcode, nstate_source, nstate_dest;
logic [7:0] pstate_fid, pstate_opcode, pstate_source, pstate_dest;
logic pcrdyfornxtput, nprdyfornxtput, nstate_bulkeom, pstate_bulkeom;
logic nstate_bulkread, pstate_bulkread; // lintra s-70036 "added for np write support"
logic nprdyfornxtirdy;
logic nxttregirdy; // lintra s-70036 "used only in performance mode"
logic [1:0]  bulkctregxfr;
logic firstbulkppop, pbulkmsgip;
logic mmsg_pcpop, mask_bulkcirdy;
logic nerr_to_mask_irdy, perr_to_mask_irdy;

always_comb mmsg_pcpop = mmsg_pcirdy & mmsg_pctrdy & mmsg_pcsel;

generate
    if (BULK_PERF==0) begin : gen_bulk_perf
        always_comb nprdyfornxtirdy = (nxttregirdy | ~mmsg_pcirdy);
    end
    else begin : gen_no_bulk_perf
        always_comb nprdyfornxtirdy = ((mmsg_pcpop & treg_mmsg_pc_last_byte & (bulkctregxfr==2'b10)) | ~mmsg_pcirdy);
    end
endgenerate

hqm_sbebulkrdwr #(
    .INTERNALPLDBIT         (   INTERNALPLDBIT          ),
    .RX_EXT_HEADER_SUPPORT  (   RX_EXT_HEADER_SUPPORT   ),
    .MAXADDR                (   MAXADDR                 ),
    .MAXADDRINDATA          (   MAXADDRINDATA           ),    
    .MAXTRGTDATA            (   MAXTRGTDATA             ),
    .ADDRMASK               (   ADDRMASK                ),
    .DW2BEMIN               (   DW2BEMIN                ),
    .MAXDATA                (   MAXDATA                 ),
    .DW2MIN                 (   DW2MIN                  ),
    .NUM_UNIQUE_EH          (   NUM_UNIQUE_EH           ),
    .HDRSTART               (   HDRSTART                ),
    .NUM_ACTUAL_RX_EXT_HEADERS  (   NUM_ACTUAL_RX_EXT_HEADERS   ),
    .NUM_RX_EXT_HEADERS_L2      (   NUM_RX_EXT_HEADERS_L2       ),
    .ACTUAL_RX_EXT_HEADER_IDS   (   ACTUAL_RX_EXT_HEADER_IDS    ),
    .MAXBE                  (   MAXBE                   ),
    .NP                     (   0                       )
) i_sbebulkrdwr_p (
    .side_clk       (   side_clk                ),
    .side_rst_b     (   side_rst_b              ),
    .pop            (   ppop                    ), 
    .put            (   pput                    ),
    .eom            (   pstate_eom              ),
    .first_byte     (   treg_pc_first_byte      ),
    .second_byte    (   treg_pc_second_byte     ),
    .third_byte     (   treg_pc_third_byte      ),
    .last_byte      (   treg_pc_last_byte       ),
    .msgip          (   tmsg_pcmsgip            ),
    .data           (   tmsg_pcpayload          ),
    .parity_err     (   treg_input_parity_err_fsm),
    .treg_rdata     (   '0                      ),
    .treg_cerr      (   '0                      ),
    .rdyfornxtirdy  (   '1                      ),
    .rdyfornxtput   (   pcrdyfornxtput          ),
    .op_count       (   pstate_count            ),
    .op_err         (   pstate_err_int          ),
    .op_irdy        (   pstate_irdy             ),
    .op_data        (   pstate_data             ),
    .op_addr        (   pstate_addr             ),
    .op_addrbuf     (   pstate_addrbuf          ),
    .op_fid         (   pstate_fid              ),
    .op_be          (   pstate_be               ),
    .op_addrlen     (   pstate_addrlen          ),
    .op_bar         (   pstate_bar              ),
    .op_eh          (   pstate_eh               ),
    .op_eh_discard  (   pstate_eh_discard       ),
    .op_ext_hdr     (   pstate_ext_hdr          ),
    .op_tag         (   pstate_tag              ),
    .op_opcode      (   pstate_opcode           ),
    .op_source      (   pstate_source           ),
    .op_dest        (   pstate_dest             ),
    .op_bulkopcode  (   pstate_bulkopcode       ),  // lintra s-0214 "only used for np's completion
    .op_bulkread    (   pstate_bulkread         ),  // lintra s-0214 "only used for np's completion
    .op_bulkeom     (   pstate_bulkeom          )   // lintra s-0214 "only used for np's completion
);

hqm_sbebulkrdwr #(
    .INTERNALPLDBIT         (   INTERNALPLDBIT          ),
    .RX_EXT_HEADER_SUPPORT  (   RX_EXT_HEADER_SUPPORT   ),
    .MAXADDR                (   MAXADDR                 ),
    .MAXADDRINDATA          (   MAXADDRINDATA           ),
    .MAXTRGTDATA            (   MAXTRGTDATA             ),
    .ADDRMASK               (   ADDRMASK                ),
    .DW2BEMIN               (   DW2BEMIN                ),
    .MAXDATA                (   MAXDATA                 ),
    .DW2MIN                 (   DW2MIN                  ),
    .NUM_UNIQUE_EH          (   NUM_UNIQUE_EH           ),
    .HDRSTART               (   HDRSTART                ),
    .NUM_ACTUAL_RX_EXT_HEADERS  (   NUM_ACTUAL_RX_EXT_HEADERS   ),
    .NUM_RX_EXT_HEADERS_L2      (   NUM_RX_EXT_HEADERS_L2       ),
    .ACTUAL_RX_EXT_HEADER_IDS   (   ACTUAL_RX_EXT_HEADER_IDS    ),    
    .MAXBE                  (   MAXBE                   ),
    .NP                     (   1                       )
) i_sbebulkrdwr_np (
    .side_clk       (   side_clk                ),
    .side_rst_b     (   side_rst_b              ),
    .pop            (   npop                    ), 
    .put            (   nput                    ),
    .eom            (   nstate_eom              ),
    .first_byte     (   treg_np_first_byte      ),
    .second_byte    (   treg_np_second_byte     ),
    .third_byte     (   treg_np_third_byte      ),
    .last_byte      (   treg_np_last_byte       ),
    .msgip          (   tmsg_npmsgip            ),
    .data           (   tmsg_nppayload          ),
    .parity_err     (   treg_input_parity_err_fsm),
    .treg_rdata     (   treg_rdata              ),
    .treg_cerr      (   treg_cerr_next               ),
    .rdyfornxtirdy  (   nprdyfornxtirdy         ),
    .rdyfornxtput   (   nprdyfornxtput          ),
    .op_count       (   nstate_count            ),
    .op_err         (   nstate_err_int          ),
    .op_irdy        (   nstate_irdy             ),
    .op_data        (   nstate_data             ),
    .op_addrbuf     (   nstate_addrbuf          ),
    .op_addr        (   nstate_addr             ),
    .op_fid         (   nstate_fid              ),
    .op_be          (   nstate_be               ),
    .op_addrlen     (   nstate_addrlen          ),
    .op_bar         (   nstate_bar              ),
    .op_eh          (   nstate_eh               ),
    .op_eh_discard  (   nstate_eh_discard       ),
    .op_ext_hdr     (   nstate_ext_hdr          ),
    .op_tag         (   nstate_tag              ),
    .op_opcode      (   nstate_opcode           ),
    .op_source      (   nstate_source           ),
    .op_dest        (   nstate_dest             ),
    .op_bulkopcode  (   nstate_bulkopcode       ),
    .op_bulkread    (   nstate_bulkread         ),
    .op_bulkeom     (   nstate_bulkeom          )
);

always_comb nstate_err = nstate_err_int | treg_input_parity_err;
always_comb pstate_err = pstate_err_int | treg_input_parity_err;
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
    if (SB_PARITY_REQUIRED) begin: gen_mreg_parity
        logic mmsg_pcparity_corrupt, mmsg_pcparity_true, treg_input_parity_err_f;
        always_comb mmsg_pcparity_true = ^{mmsg_pcpayload, mmsg_pceom};
        // corrupt parity when an extra payload is sent because of parity error in a bulk completion
        always_comb mmsg_pcparity_corrupt = ~mmsg_pcparity_true;
        always_ff @(posedge side_clk or negedge side_rst_b) begin
            if (~side_rst_b)
                treg_input_parity_err_f <= '0;
            else
                treg_input_parity_err_f <= treg_input_parity_err;
        end
// corruption of parity cannot be validated because of a VC restriction - VC could not know which packet had corrupted parity
        always_comb mmsg_pcparity = (treg_input_parity_err_f & (bulkctregxfr == 2'b11) & nstate_bulkopcode) ? mmsg_pcparity_corrupt : mmsg_pcparity_true;
//        always_comb mmsg_pcparity = mmsg_pcparity_true;
    end
    else begin: gen_mreg_noparity
        always_comb mmsg_pcparity = '0;
    end
endgenerate


// BULK msgip
always_ff @(posedge side_clk or negedge side_rst_b) begin
    if (~side_rst_b)
        pbulkmsgip   <= '0;
    else begin
        if (treg_irdy & treg_trdy & ~treg_np & pstate_bulkopcode)
            pbulkmsgip <= ~pstate_bulkeom;
    end
end

// arbiter will need this to switch to posteds from np
always_comb firstbulkppop = ~pbulkmsgip & ppop;
 
// BULK completions
logic bulkcirdy;
logic bulkceom, bulkrdceom, bulkwrceom, bulk_allxfr_done;
logic bulkcmpd;
logic [31:0] bulkpcpayload;
logic extra_bulkcompletion, erronlastpacket, erronearlypkts;
logic ntreg_bulkip, bulkrdcmsgip, onebulkpop, onebulkpop_extended;
logic allbulkcompletions, bulkrdcompletions, bulkwrcompletions;
logic bulkrsp;
logic bulkwr;
// npop here is treg_irdy & treg_trdy.
// block the next npop until the msg header, eh and extra completion (for error on last packet), because there shouldnt be any more puts until these are sent out
// this block is by deasserting nxttregirdy, which should deassert treg_trdy), and wait until the completion for that np read is sent fully 
// completion for a particular np read = msgpcpop (after the headers have been sent out)

// when a pop happens on treg side, assert bulkcirdy
// when a pop happens on the mmsg side for completion, deassert bulkcirdy and wait for the next pop)


// all bulk indicators
always_comb bulkwr              = nstate_opcode[0] & nstate_bulkopcode ;
always_comb bulkrdcompletions   = ((nstate_bulkopcode & ~nstate_opcode[0]) | extra_bulkcompletion | bulkrdcmsgip | onebulkpop_extended);
always_comb allbulkcompletions  = bulkrdcompletions | (bulkwrcompletions| bulkwr);

always_ff @(posedge side_clk or negedge side_rst_b) begin
    if (~side_rst_b) begin
            bulkcirdy           <= '0;
            bulkrdceom          <= '0;
            bulkctregxfr        <= '0;
            nxttregirdy         <= '1;
            extra_bulkcompletion<= '0;
            mask_bulkcirdy      <= '0;
            ntreg_bulkip        <= '0;
            erronearlypkts      <= '0;
            bulkrdcmsgip        <= '0;
            onebulkpop_extended <= '0;
            bulkwrcompletions   <= '0;
            bulkrsp             <= '0;
    end
    else begin
        // this bulkip helps in picking the error on only one packets (datalen = 1) and block trdy for the completion headers
        if (nstate_bulkopcode & npop) 
            ntreg_bulkip    <= ~nstate_bulkeom;
        
        // this is to generate a "msgip" indicator for a bulk read completion
        if (mmsg_pcpop & treg_mmsg_pc_last_byte) begin
            if (nstate_bulkopcode & ~nstate_opcode[0] & ~mmsg_pceom)
                bulkrdcmsgip <= 1'b1;
            else if (mmsg_pceom)
                bulkrdcmsgip <= 1'b0;
        end

        // bulk read completions
        if (bulkrdcompletions) begin
        // when there are no errors, bulkrdcmsgip will continue to be asserted as long as there are pending completions 
        // if there is a npop on treg widget, there has to be a completion - unless...
        // a. the mask is set to prevent cirdy from asserting once again, after a particular completion is eom'd earlier
        // b. npop happens exactly when mmsg_pop/mmsg_eom happens for a bulk xaction in progress (bcos mask cirdy will set only on the next clock, this term will block bulkcirdy from asserting during that 1 clock

            if ((npop & ~mmsg_pcpop) | (treg_input_parity_err & bulkrdcmsgip & ~bulkrdceom))begin
                if (~mask_bulkcirdy)
                    bulkcirdy   <= 1'b1;

            end else if (mmsg_pcpop & treg_mmsg_pc_last_byte & bulk_allxfr_done & ~npop) begin
                // reset cirdy on eom or if the all the completion messages are popped-using xfr pointer (after message hdr, eh are all sent out)
                if (mmsg_pceom | (~(nstate_err|treg_cerr_next)))
                    bulkcirdy   <= 1'b0;
            // when both npop and mmsg_pcpop are asserted, it could only mean that the mmsg_pcpop was for a read request that already started (ntreg_bulkip) and only the eom condition needs to be checked then. otherwise bulkcirdy can retain what the previous conditions set it to.
            end else if (mmsg_pcpop & npop) begin
                if (mmsg_pceom & ntreg_bulkip)
                    bulkcirdy   <= 1'b0;
            end

        // control bulkcirdy through eom
        // npop has priority in setting bulkrdceom. the only instance when mmsg_pcpop would set bulkrdceom is during the extra completion or the extended completion for one bulkpop messages.
            if (npop & ~mmsg_pcpop) begin
            // bulk error handling - when there is an error on any packet except the last packet, terminate the completions immediately
            // if the error happens on the last packet, xfr pointer moves to '11 and sends an extra packet with 0's. If there are no errors then assert completion eom when the request eom is asserted (nstate_bulkeom).
                if (((nstate_err|treg_cerr_next) & ~nstate_bulkeom) | (~(nstate_err|treg_cerr_next) & nstate_bulkeom))
                    bulkrdceom  <= 1'b1;
                else
                    bulkrdceom  <= 1'b0;
            end else if (mmsg_pcpop & ~npop) begin
                //when error on only packet happens assert bulkrdceom as soon as the first msg hdr is popped
                if (extra_bulkcompletion | onebulkpop_extended)
                    bulkrdceom  <= 1'b1;
                // reset bulkrdceom after the completion eom is sent and after the msg hdr/ext hdr and completions are sent out (using the xfr pointer)
                else if ((bulkctregxfr >= 2'b10) & mmsg_pceom)
                    bulkrdceom  <= 1'b0;
            end else if (mmsg_pcpop & npop) begin
// same condition as only with npop
                if (((nstate_err|treg_cerr_next) & ~nstate_bulkeom) | (~(nstate_err|treg_cerr_next) & nstate_bulkeom))
                    bulkrdceom  <= 1'b1;
            end
            
            if (npop & ~mmsg_pcpop) begin
            // mmsg_pcpop is the priority
            // block next irdy when there is a first pop on treg (to send out msg hdr and eh hdrs)
                if (~ntreg_bulkip | (bulkctregxfr==2'b10))
                    nxttregirdy <= 1'b0;
            end
            else if (mmsg_pcpop & treg_mmsg_pc_last_byte & (bulkctregxfr >= 2'b10) & mmsg_pceom)
                nxttregirdy <= 1'b1;

     
        // modified legacy xfr register to skip 2'b11, because bulk completions are always 1DW only
        // bulkxfr is a pointer to pick the correct payload
        // 00 - msg hdr, 01 - eh, 10 - completion payload, 11 - happens only during an error case while sending an extra bulkcompletion
        // entire bulk shold generate only 1 ext header -> execute this only once
            //if ( ((mmsg_pcpop & ~npop)||(mmsg_pcpop & bulkrdcompletions)) & treg_mmsg_pc_last_byte) begin
            if (mmsg_pcpop & bulkrdcompletions& treg_mmsg_pc_last_byte) begin
                if (mmsg_pceom & (bulkctregxfr >= 2'b10))
                    bulkctregxfr <= '0;
                else begin
                    unique casez (bulkctregxfr)
                        2'b00 : bulkctregxfr <= tx_eh_remaining ? 2'b01 : 2'b10; 
                        2'b01 : bulkctregxfr <= bulkctregxfr + 2'b01;
                        2'b10 : bulkctregxfr <= extra_bulkcompletion ? 2'b11 : 2'b10;
                      default : bulkctregxfr <= bulkctregxfr;
                    endcase
                end
            end

            if ( (bulkctregxfr >= 2'b10) & mmsg_pcpop & treg_mmsg_pc_last_byte & mmsg_pceom & ~npop) 
             // reset all control signals on eoms
             // mmsg pceom and nstate bulkeom for the same message hdr can happen at any time wrt each other - earlier, later or at the same time. So reset irdy on whichever happens. 
             // reset on npop & bulkeom, is done a few steps below: cont*
                extra_bulkcompletion    <='0;
            // send extra completion when there is a parity error in the middle of the completion
            // if it happens on the last completion, no more treg's irdy/trdy will happen so you can let the last completion go without any error
            // when err on last packet, send extra completion, assert cirdy
            else if ( ((npop & nstate_bulkeom) | (treg_input_parity_err & bulkrdcmsgip)) & 
                      ((erronlastpacket | (treg_input_parity_err & (bulkrdcmsgip & ~bulkrdceom)))) )
                 extra_bulkcompletion   <= 1'b1;

            if ( (bulkctregxfr >= 2'b10) & mmsg_pcpop & treg_mmsg_pc_last_byte & mmsg_pceom & ~npop )
                onebulkpop_extended <= '0;
            // all indicators are lost when only 1 bulk addr is popped. create something similar to extra_bulkcompletion
            else if (onebulkpop & ~(nstate_err|treg_cerr_next))
                onebulkpop_extended <= 1'b1;

            // mask irdy's from error to end of npop bulk 
            // but if the error is on the last packet, mask never gets reset if it is set. Do not set it in that case
            // these are not mutually exclusive cases. there is a implied priority.
            if ( ((npop & nstate_bulkeom) | (treg_input_parity_err & bulkrdcmsgip)) & ((nstate_err_int|treg_cerr_next) & ~treg_input_parity_err) )
                mask_bulkcirdy  <= 1'b0;
            else if (mmsg_pcpop & treg_mmsg_pc_last_byte & mmsg_pceom & (nstate_err|treg_cerr_next) & ~extra_bulkcompletion)
                mask_bulkcirdy  <= 1'b1;                         

            // nstate_err will stay asserted until bulkeom
            // this is to isolate the errors on earlier packets and trigger only if an error happens on the last packet
            // these are not mutually exclusive cases. there is a implied priority.
            if (npop & (nstate_err|treg_cerr_next) & ~nstate_bulkeom)
                erronearlypkts <= 1'b1;
             // only on internal error reset these, else irdy will terminate abruptly causing handshake violations
            else if ( ((npop & nstate_bulkeom) | (treg_input_parity_err & bulkrdcmsgip)) & ((nstate_err_int|treg_cerr_next) & ~treg_input_parity_err) )
                erronearlypkts  <= 1'b0;
            // completion sent after the bulkrdceom is set, shoudl be the last completion for the bulk
        end //bulkrd completions
        // bulkwr sets the bulkwrcompletions flag
        else if (bulkwr | bulkwrcompletions) begin
            if (npop) begin
                bulkrsp     <= (treg_cerr_next | nstate_err);
                if (nstate_bulkeom) begin
                    bulkwrcompletions   <= 1'b1;
                    bulkcirdy           <= 1'b1;
                end
            end
            if (mmsg_pcpop & treg_mmsg_pc_last_byte) begin
                bulkctregxfr    <= bulkctregxfr + 2'b01;

                if (mmsg_pceom) begin
                    bulkwrcompletions   <= '0;
                    bulkctregxfr        <= '0;
                    bulkcirdy           <= 1'b0;
                    nxttregirdy         <= 1'b1;
                    bulkrsp             <= '0;
                end
            end // mmsg_pop
        end // bulk wr | completions
    end
end

always_comb begin
// compared to legacy, completion for a bulk np rd, doesnt depend on treg errors. for np wr, it is a consolidated response bit
// --> there is always a completion sent irrespective of error in treg states
// the actual read data is sent, when there is no error. the data is 0'd out when there is an error and entire completion is stopped
    bulkcmpd = ~nstate_opcode[0];
    unique casez ( bulkctregxfr )
    //always successful rsp bits (1'b0)
        2'b00 : bulkpcpayload = { tx_eh_remaining, 2'b00, 1'b0, bulkrsp, nstate_tag,
                             bulkcmpd ? SBCOP_CMPD : SBCOP_CMP,
                         nstate_dest, nstate_source         };
        2'b01 : bulkpcpayload = tx_ext_header_mux;
        2'b10 : bulkpcpayload = ctregcerr ? '0 : nstate_data[31:0];
        2'b11 : bulkpcpayload = '0;
    default : bulkpcpayload = 'x;
    endcase
// if np write, all xfr is done when extended headers ar done
// if np read, all completions will be done only after the read data (w/without extra completion is sent out)

  if( ((bulkctregxfr == 2'b10) & ~extra_bulkcompletion) || ((bulkctregxfr == 2'b11) & extra_bulkcompletion) ||
      (~tx_eh_remaining & bulkwrcompletions) )begin // Data phase 1
    // this ll change for multi DW reads (refer legacy mmsg_pceom_int
        bulk_allxfr_done = 1'b1;
    end else begin
        bulk_allxfr_done = 1'b0;
    end

    erronlastpacket = npop & nstate_bulkeom & (nperror|treg_cerr_next) & ~erronearlypkts;
// onebulkpop is when datalen = 1. It is not with error and is required to send completions without the nstate_bulk* indicators, because they are asserted only for 1 clock durign the pop and cannot be used to mux the bulk/nonbulk completions
    onebulkpop  = npop & nstate_bulkeom & ~ntreg_bulkip;

    bulkwrceom  = ~tx_eh_remaining;
    bulkceom    = bulkwrcompletions ? bulkwrceom : bulkrdceom;
end
// bulkcompletions end

// Output to the master interface of the base endpoint

always_comb begin
// nstate_bulkopcode gets reset on the last bulk npop. extra bulk completion and cmsgsip will keep this mux select on bulk for the last bulk
    if (allbulkcompletions) begin
        mmsg_pcirdy         = bulkcirdy & ~mask_bulkcirdy;
        mmsg_pceom          = bulk_allxfr_done & bulkceom & treg_mmsg_pc_last_byte;
        mmsg_pcpayload_mux  = bulkpcpayload;
    end
    else begin
        mmsg_pcirdy = cirdy;
        mmsg_pceom  = mmsg_pceom_int & treg_mmsg_pc_last_byte;
        mmsg_pcpayload_mux  = nonbulk_pcpayload;
    end
end


//
logic tmsg_npfree_pre, tmsg_npfree_prebulk;
  always_comb begin
    // The target register access service is idle when irdys are de-asserted and
    // both transfer counters are zero.  The non-posted completion irdy is not
    // needed because the base endpoint uses the master irdys to keep the ISM in
    // the ACTIVE state, so this would be redundant.
    
    idle_trgtreg = ~pstate_irdy & (pstate_count == '0) &
                   ~nstate_irdy & (nstate_count == '0);


    // Outputs to the target interface of the base endpoint
    tmsg_pcfree = (~pstate_irdy | ppop) & pcrdyfornxtput;
    tmsg_npfree = tmsg_npfree_prebulk & nprdyfornxtput;


    tmsg_npfree_pre  = ~nstate_irdy & (~mmsg_pcirdy |
                                   (mmsg_pceom & mmsg_pcsel & mmsg_pctrdy));

    tmsg_npclaim_hit =      treg_np_third_byte & 
                          ((tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_MRD)  |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_MWR)   |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_IORD)  |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_IOWR)  |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_CFGRD) |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_CFGWR) |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_CRRD)  |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_CRWR)  |
                          // bulkrd wr opcodes
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == 8'h08)              |
                          (tmsg_nppayload[(SBC_COP_START+7):SBC_COP_START] == 8'h09)              );
    
    tmsg_pcclaim_hit =      treg_pc_third_byte &
                          ((tmsg_pcpayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_MWR)  |
                          (tmsg_pcpayload[(SBC_COP_START+7):SBC_COP_START] == SBCOP_REGACC_CRWR)  |
                          (tmsg_pcpayload[(SBC_COP_START+7):SBC_COP_START] == 8'h08)  |
                          (tmsg_pcpayload[(SBC_COP_START+7):SBC_COP_START] == 8'h09)  );
                            
                        


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
    cmpd      = ~ctregcerr & ~nstate_opcode[0];
    
    // The completion is either 4 bytes (completion without data), or 8 bytes
    // (completion with 1 dword of read data) or 12 bytes (completion with 2 dwords
    // of read data).  Transfer 1 always contains the dest/source port IDs, the
    // completion opcode and the transation tag.  Transfer 2 contains the 1st dword
    // of read data, and transfer 3 contains the 2nd dword of read data.
  unique casez ( ctregxfr ) //lintra s-50002, s-0257 "description in lintra webpage not clear for parallel case statements"
//vishnu: this will need the byte enable mux (removing the next mux)
// PCR 12042104 - extended headers indicator now used to indicate when there are remaining extended headers - START
      2'b00 : nonbulk_pcpayload = { tx_eh_remaining, 3'b0, ctregcerr, nstate_tag,
                                 cmpd ? SBCOP_CMPD : SBCOP_CMP,
                                 nstate_dest, nstate_source         };
      2'b01 : nonbulk_pcpayload = tx_ext_header_mux;
// PCR 12042104 - extended headers indicator now used to indicate when there are remaining extended headers - FINISH
//vishnu: how will this data be handled?

      2'b10 : nonbulk_pcpayload = nstate_data[31:0];
      2'b11 : nonbulk_pcpayload = nstate_data[MAXDATA:DW2MIN];
      default : nonbulk_pcpayload = 'x;
   endcase

    unique casez (INTERNALPLDBIT)
        31: mmsg_pcpayload[INTERNALPLDBIT:0]  =   mmsg_pcpayload_mux[INTERNALPLDBIT:0];
        15: mmsg_pcpayload[INTERNALPLDBIT:0]  =   treg_mmsg_pc_last_byte ? mmsg_pcpayload_mux[31:16] : mmsg_pcpayload_mux[15:0]; // lintra s-0396, s-0393
   default: mmsg_pcpayload[INTERNALPLDBIT:0]  =   treg_mmsg_pc_second_byte ? mmsg_pcpayload_mux[15:8] : (treg_mmsg_pc_third_byte ? mmsg_pcpayload_mux[23:16] : (treg_mmsg_pc_last_byte ? mmsg_pcpayload_mux[31:24] : mmsg_pcpayload_mux[7:0])); // lintra s-0396, s-0393, s-2033
   endcase

    // Pop occurs when the message completes on the target register access
    // interface.  Note, that if an error is detected with the message format, then
    // irdy is not asserted and the message auto-completes 1 cycles later.

    // ppop relocated to its own always_comb to make lintra happy.
    //    ppop = ~np & pstate_irdy & (treg_trdy | pstate_err);
    npop =  np & nstate_irdy & (treg_trdy | nstate_err_int);
    
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
    nperror = nstate_err;

    if (INTERNALPLDBIT ==7) begin
            addr_err = ( |(ADDRMASK[31:0] & {tmsg_nppayload,nstate_addrbuf[23:0]} & {31{treg_np_last_byte}}) |
                         ((nstate_opcode[0] == tmsg_npeom) & treg_np_last_byte)) ;
    end
    else if (INTERNALPLDBIT == 15) begin
            addr_err = (|(ADDRMASK[31:0] & {tmsg_nppayload,nstate_addrbuf[15:0]} & {31{treg_np_last_byte}}) | // lintra s-0393
                            ((nstate_opcode[0] == tmsg_npeom) & treg_np_last_byte));
    end
    else begin
            addr_err = (|(ADDRMASK[INTERNALPLDBIT:0] & tmsg_nppayload)) |
                            ((nstate_opcode[0] == tmsg_npeom) & treg_np_last_byte);
    end

    if( nput) begin
       if( nstate_irdy ) begin // lintra s-60032 "Lintra has difficulty with embedded if statements"
          nperror |= (tmsg_npeom & treg_np_last_byte);
       end else begin
         unique casez( nstate_count ) // lintra s-0257 "description in lintra webpage not clear for parallel case statements"
         4'b0000: // Standard Header
            nperror = (tmsg_npeom & treg_np_first_byte); // Always a fresh evaluation.
         4'b0001: // Address[15:0]
            nperror |= ((MAXBE==3) & (|tmsg_nppayload[7:4]) & treg_np_first_byte) |
                       ( nstate_opcode[0] & tmsg_npeom & treg_np_last_byte)   |
                       (~nstate_opcode[0] & ~nstate_addrlen & ~tmsg_npeom & treg_np_last_byte);
         4'b0010: // Address[MAXADDR:16]
            nperror |= addr_err;
         4'b0011: // Data[31:0]
            nperror |= (MAXBE==3) ?
                       (~tmsg_npeom & treg_np_last_byte) :
                       (( tmsg_npeom == |nstate_be[MAXBE:DW2BEMIN]) & treg_np_last_byte);
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

    // All non-posted access messages are claimed by this target
    // when a parity error happens on the whole package, none of the payloads are presented to bulk widget and hence it is ok for tmsg to send a unsuccessful completion (because of parity error)
    if( |NUM_UNIQUE_EH ) begin
      tmsg_npclaim = nstate_bulkopcode ?    ( tmsg_npput & tmsg_npeom & |nstate_count ) : 
                                            ( tmsg_npput & tmsg_npeom & ~nperror & |nstate_count ) ;
    end else begin
      tmsg_npclaim = tmsg_npclaim_pre;
    end
// PCR 12042104 - Delay np claim - Finish

// HSD:1408282604 - send out transactions (and their completions) that arrived before parity error for non-bulk opcodes
    nerr_to_mask_irdy  = nstate_bulkopcode ? nstate_err : nstate_err_int;
    perr_to_mask_irdy  = pstate_bulkopcode ? pstate_err : pstate_err_int;

    // Target register access interface output muxes
    treg_irdy           = np ? (nstate_irdy & ~nerr_to_mask_irdy) : (pstate_irdy & ~perr_to_mask_irdy);
    treg_np             = np;
    treg_dest           = np ? nstate_dest    : pstate_dest;
    treg_source         = np ? nstate_source  : pstate_source;
    treg_opcode         = np ? nstate_opcode  : pstate_opcode;
    treg_addrlen        = np ? nstate_addrlen : pstate_addrlen;
    treg_bar            = np ? nstate_bar     : pstate_bar;
    treg_tag            = np ? nstate_tag     : pstate_tag;
    treg_be             = np ? nstate_be      : pstate_be;
    treg_fid            = np ? nstate_fid     : pstate_fid;
    treg_addr           = np ? nstate_addr    : pstate_addr;
    treg_wdata          = np ? nstate_data    : pstate_data;
  end

always_ff @(posedge side_clk or negedge side_rst_b)
begin
    if (~side_rst_b) begin
        tmsg_npfree_prebulk <= '0;
    end
    else begin
// tmsg_npclaim is tmsg_nput and tmsg_eom. since npfree is flopped, there is a 1 clk delay between when treg is actually free (npfree_pre) and 
// when it announces that its free through output, during which b2b np could be coming in and they will be dropped.
// the agents think treg is free, while internal logic prevents treg from accepting it.
// deasserting free when the claim by treg happens should avoid that case.
        if (tmsg_npclaim) tmsg_npfree_prebulk <= '0;
        else tmsg_npfree_prebulk <= tmsg_npfree_pre;

    end
end

  generate
    if ( |RX_EXT_HEADER_SUPPORT ) begin : gen_exhd_blk1
      if( |NUM_UNIQUE_EH ) begin : gen_unique_ext_headers
         always_comb begin
            if( np ) begin
               treg_eh             = nstate_eh;
               treg_eh_discard     = nstate_eh_discard;
               treg_rx_sairs_valid = nstate_ext_hdr[EHVB_SAIRS][7];
               treg_rx_sai         = nstate_ext_hdr[EHVB_SAIRS][SAIWIDTH+ 8: 8];
               treg_rx_rs          = nstate_ext_hdr[EHVB_SAIRS][ RSWIDTH+24:24];
            end else begin
               treg_eh             = pstate_eh;
               treg_eh_discard     = pstate_eh_discard;
               treg_rx_sairs_valid = pstate_ext_hdr[EHVB_SAIRS][7];
               treg_rx_sai         = pstate_ext_hdr[EHVB_SAIRS][SAIWIDTH+ 8: 8];
               treg_rx_rs          = pstate_ext_hdr[EHVB_SAIRS][ RSWIDTH+24:24];
            end
            treg_ext_header = '0;
         end
      end else begin : gen_ext_headers
         always_comb begin
            treg_eh         = np ? nstate_eh         : pstate_eh;
            treg_ext_header = np ? nstate_ext_hdr    : pstate_ext_hdr;
            treg_eh_discard = np ? nstate_eh_discard : pstate_eh_discard;
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
    ppop = ~np & pstate_irdy & (treg_trdy | pstate_err_int);
  
// PCR 12042104 - Change pceom based on remaining extended headers - START
// removed casex to disable x-prop coding.
  always_comb
      if( !cmpd ) begin
         mmsg_pceom_int = ~tx_eh_remaining;
      end else if( ctregxfr == 2'b10 ) begin // Data phase 1
         mmsg_pceom_int = ((MAXBE==3) | ~(|nstate_be[MAXBE:DW2BEMIN]));
      end else if( ctregxfr == 2'b11 ) begin // Data phase 2
         mmsg_pceom_int = 1'b1;
      end else begin
         mmsg_pceom_int = 1'b0;
      end
// PCR 12042104 - Change pceom based on remaining extended headers - FINISH


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
               else if( npop & ~nstate_err_int)
                  tx_eh_valid <= tx_eh_valid_pre;
               else if( mmsg_pcirdy && mmsg_pctrdy && mmsg_pcsel ) begin
                if (mmsg_pceom) 
                    tx_eh_valid <= '0;
                else    
                  tx_eh_valid <= tx_eh_valid_clear;
               end

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

               if( (allbulkcompletions & (bulkctregxfr == 2'b01)) || (~allbulkcompletions & (ctregxfr == 2'b01)) ) begin
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
               end else if( npop & ~nstate_err_int) begin
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
               if( (allbulkcompletions & (bulkctregxfr == 2'b00)) || (~allbulkcompletions & (ctregxfr == 2'b00)) ) begin
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

 always_comb nstate_eom = tmsg_npeom & tmsg_npput;
 always_comb pstate_eom = tmsg_pceom & tmsg_pcput;
  
  always_ff @(posedge side_clk or negedge side_rst_b)
    if (~side_rst_b) begin
      // Flop count:
      np        <= '0;  //  1 : 0=posted / 1=non-posted (traffic class arbiter)
      cirdy     <= '0;  //  1 : Completion is ready
      ctregcerr <= '0;  //  1 : Completion error (4 byte completion will be sent)
      ctregxfr  <= '0;  //  2 : Completion transfer counter
      pignore   <= '0;  //  1 : Posted message is being ignored
      nignore   <= '0;  //  1 : Non-posted message is being ignored
      tx_eh_cnt <= '0;
    end else begin
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
// np is asserted/deasserted as soon as the first bytes of nput/pput come in respectively and when there are no p/n irdy's (of opposite type) already set.
      if (np)
        np <= ((pstate_irdy | (pput & treg_pc_last_byte)) & (~nstate_irdy | npop)) ? '0 : '1;
      else
        begin
// in bulk mode, when a posted is serviced (np =0), wait till the last bulk is popd before switching. 
// in addition to the previous case for switching to np, also check if there is no posted bulkmsgip, including the first ppop
// pstate_bulkeom makes sure np switches back to 1 as soon as all posted are done. If not, the switch will happen one clock after
            if (pstate_bulkopcode)
                np <= ((nstate_irdy | (nput & treg_np_last_byte))  & (~pstate_irdy | ppop) & ((~(firstbulkppop | pbulkmsgip)) | pstate_bulkeom)) ? '1 : '0;
            else
                np <= ((nstate_irdy | (nput & treg_np_last_byte)) & (~pstate_irdy | ppop)) ? '1 : '0;
      end
 
      // Non-posted register access completion generation
      // Assert the completion irdy when the non-posted register access message
      // completes on the target interface
      if (npop)
          ctregcerr         <= treg_cerr_next | nstate_err;
          
      if (npop & ~(allbulkcompletions)) begin
          if( |NUM_UNIQUE_EH ) begin
            cirdy <= ~nstate_err; // UNIQUE EH Mode will not send completions for errors
          end else begin
            cirdy <= '1;
          end
          // Update the completion transfer state when a completion transfer completes
          // on the egress port interface

      end else if (mmsg_pcpop & (~(allbulkcompletions)) ) begin
          
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
               nstate_irdy | pstate_irdy, 
               nstate_err | pstate_err,
               nstate_count, 
               pstate_count 
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
