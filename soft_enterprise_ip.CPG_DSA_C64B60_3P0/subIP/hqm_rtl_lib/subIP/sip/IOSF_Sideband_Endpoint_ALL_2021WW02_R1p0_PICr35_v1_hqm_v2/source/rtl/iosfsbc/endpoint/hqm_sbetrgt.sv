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
//  Module sbetrgt : The target interface block within the sideband interface
//                   base endpoint (sbebase).
//
//------------------------------------------------------------------------------

// lintra push -60020, -60088, -80028, -68001, -60056, -60024b, -2050, -70036_simple

module hqm_sbetrgt
#(
  parameter INTERNALPLDBIT  = 7, // Maximum payload bit, should be 7, 15 or 31
  parameter MAXPCTRGT       = 0, // Maximum posted/completion target agent number
  parameter MAXNPTRGT       = 0, // Maximum non-posted        target agent number
  parameter RX_EXT_HEADER_SUPPORT = 0, // indicates agent supports receiving extended headers.
  parameter TX_EXT_HEADER_SUPPORT = 0,
  parameter NUM_TX_EXT_HEADERS    = 0,
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - START
   parameter UNIQUE_EXT_HEADERS = 0,  // set to 1 to make the register agent modules use the new extended header
   parameter SAIWIDTH           = 15, // SAI field width - MAX=15
   parameter RSWIDTH            = 3,  // RS field width - MAX=3
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - FINISH
  parameter CLAIM_DELAY         = 10,
  parameter SB_PARITY_REQUIRED  = 0,  // configures the Endpoint to support parity handling
  parameter GLOBAL_EP           = 0, // Hier Header PCR
  parameter GLOBAL_EP_IS_STRAP  = 0 
  
 // parameter NUM_REPEATER_FLOPS  = 5 
)(
  // Clock/Reset Signals
  input  logic               side_clk, 
  input  logic               side_rst_b,

  // ISM Interface Signal
  output logic               idle_trgt,

  // Target Interface Signals
  input  logic [MAXPCTRGT:0] sbi_sbe_tmsg_pcfree,    //
  input  logic [MAXNPTRGT:0] sbi_sbe_tmsg_npfree,    //
  input  logic [MAXNPTRGT:0] sbi_sbe_tmsg_npclaim,   //
  output logic               sbe_sbi_tmsg_pcput,     //
  output logic               sbe_sbi_tmsg_npput,     //
  output logic               sbe_sbi_tmsg_pcmsgip,   //
  output logic               sbe_sbi_tmsg_npmsgip,   //
  output logic               sbe_sbi_tmsg_pccmpl,    //
  output logic               sbe_sbi_tmsg_pcvalid,
  output logic               sbe_sbi_tmsg_npvalid,
  output logic [INTERNALPLDBIT:0] sbe_sbi_tmsg_nppayload,
  output logic [INTERNALPLDBIT:0] sbe_sbi_tmsg_pcpayload,
  output logic               sbe_sbi_tmsg_pcparity,
  output logic               sbe_sbi_tmsg_npparity,
  input  logic               sbe_sbi_tmsg_pceom,     // lintra s-70036 s-0527 "PC EOM is defined outside of this module"
  input  logic               sbe_sbi_tmsg_npeom,     // lintra s-70036 s-0527 "NP EOM is defined outside of this module"
  input  logic               all_ext_parity_err_det,
  
  // Ingress Port Signals
  input  logic               pcirdy,                 //
  input  logic               pceom,                  //
  input  logic               pcparity,               //
  input  logic [INTERNALPLDBIT:0] pcdata,            //
  input  logic               npirdy,                 //
  input  logic               npeom,                  //
  input  logic               npparity,                //
  input  logic [INTERNALPLDBIT:0] npdata,            //
  input  logic               npfence,                //
  output logic               pctrdy,                 //
  output logic               nptrdy,                 //

  
  // SBEMSTR Interface Signals
  input  logic               mmsg_pcsel,             //
  input  logic               mmsg_pctrdy,            //
  output logic               mmsg_pcirdy,            //
  output logic               mmsg_pceom,             //
  output logic               mmsg_pcparity,           //
  output logic [INTERNALPLDBIT:0] mmsg_pcpayload,    //

  // np source, dest , tag used for deasserting cfence only when all 3 matches with the completion in master block
  output logic [7:0]                npdest_mstr,   // Non-posted message destination port ID
  output logic [7:0]                npsrc_mstr,    // Non-posted message source port ID
  output logic [2:0]                nptag_mstr,    // Non-posted message tag

// HIERHDR outputs for completion
  input  logic                      global_ep_strap, // lintra s-0527, s-70036 Used only in transparent bridge EP
  output logic [7:0]                hier_dest_tmsg,   // Non-posted message destination port ID
  output logic [7:0]                hier_src_tmsg,    // Non-posted message source port ID

  // extended header inputs.
  input  logic [NUM_TX_EXT_HEADERS:0][31:0] tx_ext_headers, // lintra s-70036 s-0527 "With unique ext support this may not get used all the time"

  // incoming completion fence
  input  logic               cfence,
  
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
  input  logic              ur_csairs_valid,   // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  input  logic [SAIWIDTH:0] ur_csai,           // lintra s-70036 s-0527 "SAI value for extended headers"
  input  logic [ RSWIDTH:0] ur_crs,            // lintra s-70036 s-0527 "RS value for extended headers"
  output logic              ur_rx_sairs_valid, // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  output logic [SAIWIDTH:0] ur_rx_sai,         // lintra s-70036 s-0527 "SAI value for extended headers"
  output logic [ RSWIDTH:0] ur_rx_rs,          // lintra s-70036 s-0527 "RS value for extended headers"
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH

  output logic         [7:0] dbgbus
);

`include "hqm_sbcfunc.vm"
`include "hqm_sbcglobal_params.vm"

// PCR 12042104 - Unique Extended Headers localparameter assignments - START
   // Add up all the supported unique extended headers to give a non-zero value
   // if TX_EXT_HEADER_SUPPORT is present
   localparam NUM_UNIQUE_EH = (TX_EXT_HEADER_SUPPORT == 0) ? 0 : UNIQUE_EXT_HEADERS; 
   localparam NUM_TX_EH = (NUM_UNIQUE_EH > 0) ? 127 : NUM_TX_EXT_HEADERS;
   localparam NUM_ACTUAL_RX_EXT_HEADERS = (NUM_UNIQUE_EH > 0) ? 0 : 0;
   localparam [NUM_ACTUAL_RX_EXT_HEADERS:0][6:0] ACTUAL_RX_EXT_HEADER_IDS  = (NUM_UNIQUE_EH > 0) ? {EHOP_SAIRS} : 'd0;// lintra s-2054 "parameter truncated from default parameter size of 32bits"
   localparam NUM_RX_EXT_HEADERS_L2 = sbc_indexed_value ( NUM_ACTUAL_RX_EXT_HEADERS );
// PCR 12042104 - Unique Extended Headers localparameter assignments - FINISH
   localparam NUM_TX_EXT_HEADERS_L2 = sbc_indexed_value ( NUM_TX_EH ); // PCR 12042104 - Overloading eh_cnt
   localparam CLAIM_DELAY_INT = (CLAIM_DELAY == 0) ? 0 : (CLAIM_DELAY-1);
   localparam SAISTART = (INTERNALPLDBIT== 7) ? 0  : 8;
   localparam SAICONTD = (INTERNALPLDBIT==31) ? 16 : 0;
   localparam RSSTART = (INTERNALPLDBIT==7) ? 0 : ((INTERNALPLDBIT==15) ? 8 : 24); // OR RSSTART = INTERNALPLDBIT-7

   typedef enum logic [1:0] {
      STD_HEADER_ST,
      EXT_HEADER_ST,
      PAYLOAD_ST,
      XPROP_DO_NOT_USED = 2'bxx
   } message_state_typ;
  
  logic                      pchdrdrp; // indicates headers will be dropped for PC message.
  logic                      nphdrdrp; // indicates headers will be dropped for NP message.
  logic                      pcmsgip;  // Posted/completion message in-progress
  logic                      npmsgip;  // Posted/completion message in-progress
  logic [1:0]                npfsm;    // FSM for the unclaimed non-posted message target agent
  //   00 = IDLE
  //   1x = Completion in-progress for unclaimed message
  //   01 = Non-posted message was claimed waiting for eom
  
  logic                      npclaim;
  
  logic [NUM_TX_EXT_HEADERS_L2:0] eh_cnt;
  logic                           cmsgip;
// PCR 12042104 - Unique Extended Header Support variables - START
   logic                           tx_eh_remaining;   // Local variable used to keep track of the presence of any valid unique headers unsent.
   logic [INTERNALPLDBIT:0]        tx_ext_header_mux; // Final muxed extended header data.
   logic [31:0]        tx_ext_header_32mux; // Final muxed extended header data.
   logic [NUM_TX_EXT_HEADERS_L2:0] tx_eh_cnt_next;    // lintra s-70036 "Next eh_cnt value during header transfer may not always get exercised"
// PCR 12042104 - Unique Extended Header Support variables - FINISH
  logic [CLAIM_DELAY_INT :0] 	   npeom_delayed;
  logic [CLAIM_DELAY_INT :0] 	   npput_delayed;
  logic 			   wait_for_claim;
// HIER HDR
logic      np_nonhdr_msgip, pc_nonhdr_msgip;
logic      ur_ext_hdr_start; // lintra s-70036 "used only for ext hdr"

// ur_ext_hdr_start controls when the non hdr dw is used to generate the UR completion. The "state" for ur completion depends on put& this start signal
// global EP will always more than 1dw => msgip will always be asserted after first put and can be used to differentiate hdr payload and nonhdr payload
// for local EP, its tied to 1 => no changes.

generate
    if ( (CLAIM_DELAY) > 1 ) begin : claim_delay_twoplus
        always_ff @( posedge side_clk or negedge side_rst_b ) begin
            if (!side_rst_b) begin
                npeom_delayed  <= '0;
                npput_delayed  <= '0;        
            end
            else if ((&sbi_sbe_tmsg_npfree) || (npeom_delayed[CLAIM_DELAY_INT] && npput_delayed[CLAIM_DELAY_INT])) begin
                npeom_delayed <= {npeom_delayed[CLAIM_DELAY_INT - 1:0], (sbe_sbi_tmsg_npput & sbe_sbi_tmsg_npeom)};
                npput_delayed <= {npput_delayed[CLAIM_DELAY_INT - 1:0], sbe_sbi_tmsg_npput};
            end
        end
  
        always_ff @( posedge side_clk or negedge side_rst_b ) begin
            if (!side_rst_b) begin
                wait_for_claim  <= '0;
            end
            else if (sbe_sbi_tmsg_npeom && sbe_sbi_tmsg_npput) begin
                wait_for_claim  <= '1;
            end
            else if (npeom_delayed[CLAIM_DELAY_INT] && npput_delayed[CLAIM_DELAY_INT]) begin
                wait_for_claim <=  '0;
            end
        end  
    end // block: claim_delay
    else if ( (CLAIM_DELAY) == 1) begin : claim_delay_one
        always_ff @( posedge side_clk or negedge side_rst_b ) begin
            if (!side_rst_b) begin
                npeom_delayed  <= '0;
                npput_delayed  <= '0;        
            end
        else if ((&sbi_sbe_tmsg_npfree) || (npeom_delayed && npput_delayed)) begin
                npeom_delayed <= (sbe_sbi_tmsg_npput & sbe_sbi_tmsg_npeom);
                npput_delayed <= sbe_sbi_tmsg_npput;
            end
        end
        always_ff @( posedge side_clk or negedge side_rst_b ) begin
            if (!side_rst_b) begin
                wait_for_claim  <= '0;
            end
            else if (sbe_sbi_tmsg_npeom && sbe_sbi_tmsg_npput) begin
                wait_for_claim  <= '1;
            end
            else if (npeom_delayed && npput_delayed) begin
                wait_for_claim <=  '0;
            end
        end 
    end
    else begin : no_claim_delay
        always_comb begin
            npeom_delayed = sbe_sbi_tmsg_npeom;
            npput_delayed = sbe_sbi_tmsg_npput;
            wait_for_claim = '0;
        end
    end
endgenerate


logic tmsg_pc_first_byte; // lintra s-70036
logic tmsg_pc_second_byte; // lintra s-70036
logic tmsg_pc_third_byte;
logic tmsg_pc_last_byte;

logic tmsg_np_first_byte;
logic tmsg_np_second_byte;
logic tmsg_np_third_byte; // lintra s-70036
logic tmsg_np_last_byte;

logic mmsg_first_byte; // lintra s-70036
logic mmsg_second_byte;
logic mmsg_third_byte;
logic mmsg_last_byte;


logic [INTERNALPLDBIT:0] mmsg_pcpayload_mux;

generate
    if (INTERNALPLDBIT ==31) begin: gen_trgt_be_31
        always_comb tmsg_pc_first_byte  = 1'b1;
        always_comb tmsg_pc_second_byte = 1'b1;
        always_comb tmsg_pc_third_byte  = 1'b1;
        always_comb tmsg_pc_last_byte   = 1'b1;
        always_comb tmsg_np_first_byte  = 1'b1;
        always_comb tmsg_np_second_byte = 1'b1;
        always_comb tmsg_np_third_byte  = 1'b1;
        always_comb tmsg_np_last_byte   = 1'b1;
        always_comb mmsg_first_byte     = 1'b1;
        always_comb mmsg_second_byte    = 1'b1;
        always_comb mmsg_third_byte     = 1'b1;
        always_comb mmsg_last_byte      = 1'b1;

    end
    else begin: gen_trgt_be_15_7
        logic tmsg_pc_valid;
        logic tmsg_np_valid;
        logic mmsg_valid;
        always_comb tmsg_pc_valid = pcirdy & pctrdy;
        always_comb tmsg_np_valid = npirdy & nptrdy;
        always_comb mmsg_valid = mmsg_pcirdy & mmsg_pctrdy & mmsg_pcsel;

        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_trgt_pc (
            .side_clk           (side_clk),
            .side_rst_b         (side_rst_b),
            .valid              (tmsg_pc_valid),
            .first_byte         (tmsg_pc_first_byte),
            .second_byte        (tmsg_pc_second_byte),
            .third_byte         (tmsg_pc_third_byte),
            .last_byte          (tmsg_pc_last_byte)
        );

        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_trgt_np (
            .side_clk           (side_clk),
            .side_rst_b         (side_rst_b),
            .valid              (tmsg_np_valid),
            .first_byte         (tmsg_np_first_byte),
            .second_byte        (tmsg_np_second_byte),
            .third_byte         (tmsg_np_third_byte),
            .last_byte          (tmsg_np_last_byte)
        );
 
        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
            i_sbebytecount_mmsg (
            .side_clk           (side_clk),
            .side_rst_b         (side_rst_b),
            .valid              (mmsg_valid),
            .first_byte         (mmsg_first_byte),
            .second_byte        (mmsg_second_byte),
            .third_byte         (mmsg_third_byte),
            .last_byte          (mmsg_last_byte)
        );
    end
endgenerate

logic all_ext_parity_err_det_f;
always_ff @(posedge side_clk or negedge side_rst_b)
    if (~side_rst_b) 
         all_ext_parity_err_det_f <= '0;
    else if (all_ext_parity_err_det)
        all_ext_parity_err_det_f <= 1'b1;

  always_comb
    mmsg_pcirdy = npfsm[1];
  
  always_comb
    begin

      // The OR reduced non-posted claim signal
      npclaim   = |sbi_sbe_tmsg_npclaim;

      // Output to the ISM
// target is not idle when there is any msg in progress or when the completion is to be sent or when the claim delay causes the completion to wait to be sent      
      idle_trgt = ~pcmsgip & ~npmsgip & ~mmsg_pcirdy & ~wait_for_claim;

      // Outputs to the ingress port
      // transfer payload as long as there is no parity_err from treg
      pctrdy = (&sbi_sbe_tmsg_pcfree | pchdrdrp) & ~(all_ext_parity_err_det | all_ext_parity_err_det_f);
      nptrdy = (&sbi_sbe_tmsg_npfree | nphdrdrp ) & ~npfence & ~cfence & ~mmsg_pcirdy & ~wait_for_claim & ~(all_ext_parity_err_det | all_ext_parity_err_det_f);

      // Outputs to the target interface (IP block)
      sbe_sbi_tmsg_pcput   = |RX_EXT_HEADER_SUPPORT ?
                             (pcirdy & pctrdy) :
                             (pcirdy & (&sbi_sbe_tmsg_pcfree) & (pcmsgip ? (~pchdrdrp || (~(pcdata[7]) & tmsg_pc_last_byte)) : ~(pcdata[INTERNALPLDBIT] & tmsg_pc_last_byte)));
      sbe_sbi_tmsg_npput   = |RX_EXT_HEADER_SUPPORT ?
                             (npirdy & nptrdy) :
                             (npirdy & (&sbi_sbe_tmsg_npfree & ~npfence & ~cfence & ~mmsg_pcirdy & ~wait_for_claim) & (npmsgip ? (~nphdrdrp || (~(npdata[7]) & tmsg_np_last_byte)) : ~(npdata[INTERNALPLDBIT] & tmsg_np_last_byte)));
      sbe_sbi_tmsg_pcmsgip = pcmsgip & ~pchdrdrp;
      sbe_sbi_tmsg_npmsgip = npmsgip & ~nphdrdrp;
      sbe_sbi_tmsg_pcvalid = pcirdy | pchdrdrp;
      sbe_sbi_tmsg_npvalid = (npirdy & ~npfence) | nphdrdrp;
      
      mmsg_pceom     = tx_eh_remaining ? ( ~tx_ext_header_32mux[7] & cmsgip & mmsg_last_byte) : mmsg_last_byte; // lintra s-0241
      // Lintra is concerned that eh_cnt may get too large for the tx_ext_headers 
      // array (hence the 0241 danger). eh_cnt can only get too large if a 
      // message with too many extended headers is processed by the endpoint.
      // The array bounds are not violated if the endpoint is configured and
      // used correctly.
      mmsg_pcpayload = cmsgip ? tx_ext_header_mux : mmsg_pcpayload_mux; // lintra s-0241

    
  end
  
generate
    if (INTERNALPLDBIT ==31) begin: gen_trgt_databus_31
        always_comb begin
 //This are the returns for the np that come out as pc - reason for using np byte controls to mux npsrc/dest/tag into mmsg pc payload
 // this mux depends on the ordering of the bytes - which is assumed to be in order
 // 4'b0001 contains 2 reserved bits and 2 rsp bits (refer table 3-10 in iosf spec for response status).
 // 00 on bits 28-29 --> successful, 01 on bits 28-29 --> ur (unsuccessful response because no one claimed the message)
            mmsg_pcpayload_mux =  { tx_eh_remaining, 4'b0001, nptag_mstr, SBCOP_CMP, npdest_mstr, npsrc_mstr};
            tx_ext_header_mux  =  tx_ext_header_32mux;
        end
    end
    else if (INTERNALPLDBIT == 15) begin: gen_trgt_databus_15
        always_comb begin
            mmsg_pcpayload_mux =  mmsg_last_byte ? {tx_eh_remaining, 4'b0001, nptag_mstr, SBCOP_CMP} : {npdest_mstr, npsrc_mstr};
            tx_ext_header_mux  =  mmsg_last_byte ? tx_ext_header_32mux[31:16]: tx_ext_header_32mux[15:0];
        end
    end
    else begin: gen_trgt_databus_7
        always_comb begin
        mmsg_pcpayload_mux =  (mmsg_second_byte ? npdest_mstr : (mmsg_third_byte ? SBCOP_CMP : (mmsg_last_byte ? {tx_eh_remaining, 4'b0001, nptag_mstr} : npsrc_mstr)));
        tx_ext_header_mux  =  mmsg_second_byte ? tx_ext_header_32mux[15:8]: (mmsg_third_byte ? tx_ext_header_32mux[23:16] : (mmsg_last_byte ? tx_ext_header_32mux[31:24] : tx_ext_header_32mux[7:0]));
        end
    end
 endgenerate

 generate
    if (SB_PARITY_REQUIRED) begin: gen_trgt_mmsg_parity
        always_comb mmsg_pcparity = ^{mmsg_pcpayload, mmsg_pceom};
    end
    else begin: gen_trgt_mmsg_noparity
        always_comb mmsg_pcparity = '0;
    end
endgenerate

// PCR 12042104 - Extended headers selection MUX - START

logic   ur_rx_sairs_valid_flag;//lintra s-0531, s-70036
logic[15:0]   ur_rx_sai_temp;
   generate
      if( |RX_EXT_HEADER_SUPPORT ) begin : gen_rx_ext_header_support
         if( |NUM_UNIQUE_EH ) begin : gen_unique_ext_header
            message_state_typ state;

            always_ff @( posedge side_clk or negedge side_rst_b ) begin
               if( !side_rst_b ) begin
                  state             <= STD_HEADER_ST;
                  ur_rx_sairs_valid <= 1'b0;
                  ur_rx_sairs_valid_flag <= 1'b0;
                  ur_rx_sai_temp        <= '0;
                  ur_rx_rs          <= '0;
               end else if( sbe_sbi_tmsg_npput & ur_ext_hdr_start) begin
                 unique casez( state ) // lintra s-0257 "description in lintra webpage unclear for parallel case statements"
                  STD_HEADER_ST:
                     // Standard Header state is the first 32-bit flit of any
                     // message. When the message is put into the agent any
                     // pre-existing EH information should be cleared.
                     // If the current message is not an EOM the current state
                     // should figure out if the next step is an extended header
                     // where nppayload[31] is set else a payload flit.
                     begin
                        ur_rx_sairs_valid <= 1'b0;
                        ur_rx_sairs_valid_flag <= 1'b0;
                        ur_rx_sai_temp         <= '0;
                        ur_rx_rs          <= '0;

                        if( !sbe_sbi_tmsg_npeom ) begin
                           // EOM => last flit, MSB of last flit = EH bit
                           if( sbe_sbi_tmsg_nppayload[INTERNALPLDBIT] & tmsg_np_last_byte) begin // lintra s-60032 "Lintra cannot handle embedded ifs"
                              state <= EXT_HEADER_ST;
                           end else if (tmsg_np_last_byte) begin
                              state <= PAYLOAD_ST;
                           end
                        end
                     end
                  EXT_HEADER_ST:
                     // Extended header state is the any subsequent flit of any
                     // message until the extended header field is a zero. At
                     // this point the next state may either be the end of a
                     // message (return to STD_HEADER_ST) or a payload flit
                     // (goto PAYLOAD_ST).
                     begin
                        if(( sbe_sbi_tmsg_nppayload[6:0] == EHOP_SAIRS ) & tmsg_np_first_byte) begin
                                ur_rx_sairs_valid_flag <= 1'b1;
                        end

                        if( sbe_sbi_tmsg_npeom ) begin
                           state <= STD_HEADER_ST;
                        end else if( !sbe_sbi_tmsg_nppayload[7] & tmsg_np_last_byte) begin
                           state <= PAYLOAD_ST;
                        end
                        
                        if (tmsg_np_second_byte)    ur_rx_sai_temp[ 7:0]  <= sbe_sbi_tmsg_nppayload[(SAISTART+7):SAISTART];
                        if (tmsg_np_third_byte)     ur_rx_sai_temp[15:8]  <= sbe_sbi_tmsg_nppayload[(SAICONTD+7):SAICONTD];
                        
                        if (tmsg_np_last_byte)      ur_rx_rs[RSWIDTH:0] <= sbe_sbi_tmsg_nppayload[(RSSTART+RSWIDTH):RSSTART];
                        
                        if (INTERNALPLDBIT ==31) begin
                            ur_rx_sairs_valid <= ( sbe_sbi_tmsg_nppayload[6:0] == EHOP_SAIRS );
                        end
                        else begin
                            if (tmsg_np_last_byte & ur_rx_sairs_valid_flag) ur_rx_sairs_valid <= 1'b1;
                        end
                     end
                  PAYLOAD_ST:
                     // Payload state is any remaining flit that does not fit
                     // the standard or extended header criteria. The only state
                     // possible to go from here is STD_HEADER_ST at the end
                     // of the current message in progress.
                     begin
                        if( sbe_sbi_tmsg_npeom ) begin
                           state <= STD_HEADER_ST;
                        end 
                     end
                  default:
                     // Should never be in this state, but if it happens goto
                     // the standard header state.
                     begin
                        state <= STD_HEADER_ST;
                     end
                  endcase
               end // sbe_sbi_tmsg_npput
            end // always_ff
         end else begin : gen_std_rx_ext_header
            // Since this outbound extended header interface signals never
            // existed before this could be easily leveraged in the standard
            // extended header handler as well. If a user does not use it then
            // the flops could be optimized away.
            always_comb begin
               ur_rx_sairs_valid = '0;
               ur_rx_sai_temp         = '0;
               ur_rx_rs          = '0;
            end
         end
      end else begin : gen_none_rx_ext_header_support
         always_comb begin
            ur_rx_sairs_valid = '0;
            ur_rx_sai_temp         = '0;
            ur_rx_rs          = '0;
         end
      end

      if( |TX_EXT_HEADER_SUPPORT ) begin : gen_tx_ext_header_mux
         if( |NUM_UNIQUE_EH ) begin : gen_unique_ext_header
            logic [NUM_UNIQUE_HEADERS:0] tx_eh_valid;       // local variable used to keep track of active extended headers
            logic [NUM_UNIQUE_HEADERS:0] tx_eh_valid_pre;   // local variable used to set tx_eh_valid with the extended headers that will be required.
            logic [NUM_UNIQUE_HEADERS:0] tx_eh_clear;       // clear bit to clear tx_eh_valid bits.
            logic [NUM_UNIQUE_HEADERS:0] tx_eh_valid_clear; // local variable used to set tx_eh_valid with the extended headers that will be required.
            logic                        tx_eh_valid_capture; // When to capture extended header valid inputs
            logic                        tx_eh_valid_update;  // When to update the extended header valid inputs

            always_comb begin
               tx_eh_valid_pre             = '0;
               tx_eh_valid_pre[EHVB_SAIRS] = ur_csairs_valid;
            end

            always_ff @( posedge side_clk or negedge side_rst_b )
               if( ~side_rst_b )
                  tx_eh_valid_capture <= 1'b0;
             //  else if( sbe_sbi_tmsg_npput && npeom )
                 else if (npeom_delayed[CLAIM_DELAY_INT] && npput_delayed[CLAIM_DELAY_INT])
                  tx_eh_valid_capture <= 1'b1;
               else if( tx_eh_valid_capture )
                  tx_eh_valid_capture <= 1'b0;

            always_comb tx_eh_valid_update = ( mmsg_pcirdy && mmsg_pctrdy && mmsg_pcsel );

            // Capture the ur_c*_valid bits at the end of every non-posted
            // message. By this time the ur_c*_valid inputs should be set
            // appropriately. Going to capture even for claimed messages for
            // design simplicity.
            // Clear the extended header being actively being sent to the
            // master message interface.
            always_ff @( posedge side_clk or negedge side_rst_b )
               if( ~side_rst_b )
                  tx_eh_valid <= '0;
               else if( tx_eh_valid_capture )
                  tx_eh_valid <= tx_eh_valid_pre;
               else if( tx_eh_valid_update )
                  tx_eh_valid <= tx_eh_valid_clear;

            always_comb begin
               tx_eh_cnt_next = '0;
               tx_eh_clear    = '0;

               if( tx_eh_valid[EHVB_SAIRS] ) begin
                  tx_eh_cnt_next          = EHOP_SAIRS;
                  tx_eh_clear[EHVB_SAIRS] = 1'b1;
               end

               // Only clear the extended header if in the extended header
               // region of the generated message.
               if( cmsgip == 1'b1 ) begin
                  tx_eh_valid_clear = tx_eh_valid & ~tx_eh_clear;
               end else begin
                  tx_eh_valid_clear = tx_eh_valid;
               end

               // When in capture mode, use the raw input from the user
               // else use the flopped versions of the yet to be sent
               // tx_eh_valid_clear vector.
               if( tx_eh_valid_capture ) begin
                  tx_eh_remaining = |( tx_eh_valid_pre );
               end else begin
                  tx_eh_remaining = |( tx_eh_valid_clear );
               end

               tx_ext_header_32mux  = '0;

               // Uniqueue Extended Headers Assignments for each one that
               // is created this will need to expand to accomidate.
               if( eh_cnt == EHOP_SAIRS ) begin
                  tx_ext_header_32mux[          6: 0] = EHOP_SAIRS;
                  tx_ext_header_32mux[             7] = tx_eh_remaining;
                  tx_ext_header_32mux[SAIWIDTH+ 8: 8] = ur_csai[SAIWIDTH:0];
                  tx_ext_header_32mux[ RSWIDTH+24:24] = ur_crs [ RSWIDTH:0];
                  tx_ext_header_32mux[         31:28] = 4'd0;
               end
            end
         end else begin : gen_tx_ext_header
            always_comb begin
               tx_eh_remaining   = |TX_EXT_HEADER_SUPPORT;
               tx_ext_header_32mux = tx_ext_headers[eh_cnt]; // lintra s-0241 "Not a problem if the final ext header is tied 0"
               // PCR 1203799966 - index out-of-bound for tx_ext_headers array - START
               // tx_eh_cnt_next    = eh_cnt + 1'b1;
               if (eh_cnt == NUM_TX_EXT_HEADERS) begin
                  tx_eh_cnt_next    = eh_cnt;
               end else begin
                  tx_eh_cnt_next    = eh_cnt + 1'b1;
               end
               // PCR 1203799966 - index out-of-bound for tx_ext_headers array - FINISH
            end
         end
      end else begin : gen_no_ext_header
         always_comb begin
            tx_eh_remaining   = '0;
            tx_ext_header_32mux = '0;
            tx_eh_cnt_next    = '0;
         end
      end
   endgenerate

always_comb ur_rx_sai[SAIWIDTH:0] = ur_rx_sai_temp[SAIWIDTH:0];

// PCR 12042104 - Extended headers selection MUX - FINISH
    logic pcdata_sbcop_cmp_int;
    logic pcpayload_sbcop_cmp_int; // lintra s-70036
    logic [INTERNALPLDBIT:0] nppayload_int, pcpayload_int; // lintra s-0531

generate
    if (INTERNALPLDBIT ==31) begin: gen_trgt_opcmp_31
        always_comb begin
                pcdata_sbcop_cmp_int    = ((pcdata[23:16] == SBCOP_CMP )        | (pcdata[23:16] == SBCOP_CMPD));
                pcpayload_sbcop_cmp_int = ((pcpayload_int[23:16] == SBCOP_CMP ) | (pcpayload_int[23:16] == SBCOP_CMPD));
        end
    end
    else if (INTERNALPLDBIT ==15) begin: gen_trgt_opcmp_15
        always_comb begin
                pcdata_sbcop_cmp_int    = ((pcdata[ 7: 0] == SBCOP_CMP )        | (pcdata[ 7: 0] == SBCOP_CMPD))        & tmsg_pc_third_byte;
                pcpayload_sbcop_cmp_int = ((pcpayload_int[7:0] == SBCOP_CMP ) | (pcpayload_int[7:0] == SBCOP_CMPD)) & tmsg_pc_third_byte;
        end
    end
    else begin: gen_trgt_opcmp_7
        always_comb begin
                pcdata_sbcop_cmp_int    = ((pcdata[ 7: 0] == SBCOP_CMP )        | (pcdata[ 7: 0] == SBCOP_CMPD))        & tmsg_pc_third_byte;
                pcpayload_sbcop_cmp_int = ((pcpayload_int[7:0] == SBCOP_CMP ) | (pcpayload_int[7:0] == SBCOP_CMPD)) & tmsg_pc_third_byte;
        end
    end
endgenerate

always_comb sbe_sbi_tmsg_pcparity  = pcparity;
always_comb sbe_sbi_tmsg_npparity  = npparity;

  generate
    if ( |RX_EXT_HEADER_SUPPORT ) begin : gen_exhd_blk0
      // if headers supported, this is a simple pass-through
      always_comb begin
          sbe_sbi_tmsg_nppayload = npdata;
          sbe_sbi_tmsg_pcpayload = pcdata;
          sbe_sbi_tmsg_pccmpl    = ~pc_nonhdr_msgip & pcdata_sbcop_cmp_int;
          pcpayload_int          = '0;
          nppayload_int          = '0;
      end
    end else begin : gen_nexhd_blk0
        
        // if headers not supported, must have a 1DW buffer.
        always_ff @(posedge side_clk or negedge side_rst_b) begin
            if ( ~side_rst_b ) begin
                nppayload_int <= '0;
                pcpayload_int <= '0;
            end else begin

                // capture 1st DW of pc/nppayload
                if ( pcirdy & pcdata[INTERNALPLDBIT] & tmsg_pc_last_byte & ~pcmsgip ) 
                  pcpayload_int <= { 1'b0, pcdata[(INTERNALPLDBIT-1):0] };
            
                if ( npirdy & npdata[INTERNALPLDBIT] & tmsg_np_last_byte & ~npmsgip )
                  nppayload_int <= { 1'b0, npdata[(INTERNALPLDBIT-1):0] };

            end // else: !if( ~side_rst_b )
        end // always_ff @

        always_comb begin
            sbe_sbi_tmsg_pcpayload = pchdrdrp ? pcpayload_int : (~pcmsgip & tmsg_pc_last_byte) ? {1'b0, pcdata[(INTERNALPLDBIT-1):0]} : pcdata;
            sbe_sbi_tmsg_nppayload = nphdrdrp ? nppayload_int : (~npmsgip & tmsg_np_last_byte) ? {1'b0, npdata[(INTERNALPLDBIT-1):0]} : npdata;
            sbe_sbi_tmsg_pccmpl    = pchdrdrp ? pcpayload_sbcop_cmp_int  : (~pc_nonhdr_msgip & pcdata_sbcop_cmp_int);
        end
    end // else: !if( |RX_EXT_HEADER_SUPPORT )
  endgenerate
  
logic[7:0] npdest_int;
logic[7:0] npsrc_int;
logic[2:0] nptag_int;
// source bits arrive on the 2nd byte if the payload is 7bits. For 15 and 31 bit payloads,
// it can be latched on the first flits itself (either 16 or 32 respectively)

generate
    if (INTERNALPLDBIT ==31) begin: gen_trgt_np_31
        always_comb begin
            npdest_int  = sbe_sbi_tmsg_nppayload[ 7:0];
            npsrc_int   = sbe_sbi_tmsg_nppayload[15:8];
            nptag_int   = sbe_sbi_tmsg_nppayload[26:24];
        end
    end
    else if (INTERNALPLDBIT ==15) begin: gen_trgt_np_15
        always_comb begin
            npdest_int  = sbe_sbi_tmsg_nppayload[ 7:0] & {8{tmsg_np_first_byte}};
            npsrc_int   = sbe_sbi_tmsg_nppayload[15:8] & {8{tmsg_np_first_byte}};
            nptag_int   = sbe_sbi_tmsg_nppayload[10:8] & {3{tmsg_np_third_byte}};
        end
    end
    else begin: gen_trgt_np_7
   // The swapping of destination and source address happens in the mmsg_payload_mux
   // usually when destination is sent as the MSB or the first byte. But for mmsg case, source
   // is sent on the first byte
   // below - first byte enable picks the dest, second byte enable picks the source from tmsg (input)
        always_comb begin
            npdest_int  = sbe_sbi_tmsg_nppayload[ 7:0] & {8{tmsg_np_first_byte}};
            npsrc_int   = sbe_sbi_tmsg_nppayload[ 7:0] & {8{tmsg_np_second_byte}};
            nptag_int   = sbe_sbi_tmsg_nppayload[ 2:0] & {3{tmsg_np_last_byte}};
        end
    end
endgenerate

// Flops
always_ff @(posedge side_clk or negedge side_rst_b)
  if (~side_rst_b)
    begin
      pchdrdrp <= '0;
      nphdrdrp <= '0;
      pcmsgip <= '0;
      npmsgip <= '0;
      npfsm   <= '0;
      eh_cnt  <= '0;
      cmsgip  <= '0;
    end 
  else
    begin

    // Posted/completion message in-progress and header handling
    if (pctrdy & pcirdy & tmsg_pc_last_byte)  begin
        if ( ~pcmsgip & pcdata[INTERNALPLDBIT] & ~|RX_EXT_HEADER_SUPPORT )
          pchdrdrp <= '1;  
        pcmsgip <= ~pceom;
    end
    if (pctrdy & pcirdy & tmsg_pc_last_byte) begin
        if ( pchdrdrp & pcmsgip )
          pchdrdrp <= pcdata[7];  
    end
    
    // Non-posted message in-progress and header handling
    if (nptrdy & npirdy & tmsg_np_last_byte) begin
        if ( ~npmsgip & npdata[INTERNALPLDBIT] & ~|RX_EXT_HEADER_SUPPORT )
          nphdrdrp <= '1;
        npmsgip <= ~npeom;
    end
    if (nptrdy & npirdy & tmsg_np_last_byte) begin
        if ( nphdrdrp & npmsgip )
          nphdrdrp <= (npdata[7]);

      end // if (sbe_sbi_tmsg_npput)

      // The FSM for handling the completions for unclaimed non-posted messages
    casez (npfsm) // lintra s-2045, s-60129
        2'b00 :
          // IDLE State: Waitng for the non-posted message to be claimed
          //             before or at the same time that the end of message
          //             occurs
          if (npeom_delayed[CLAIM_DELAY_INT] & npput_delayed[CLAIM_DELAY_INT] & ~npclaim)
            npfsm <= 2'b10;
          else if (npclaim & ((|npput_delayed) | sbe_sbi_tmsg_npput) & ~(npeom_delayed[CLAIM_DELAY_INT]))
            npfsm <= 2'b01;
        
        2'b01 :
          // Claim State: A target agent external to the base endpoint has
          //              claimed the non-posted message
          if (npeom_delayed[CLAIM_DELAY_INT] & npput_delayed[CLAIM_DELAY_INT])
            npfsm <= 2'b00;
        
        2'b1? :
          // Completion State: No targets have claimed the non-posted
          //                   message so an unsuccessful / not supported
          //                   completion is generated in this state.
          if (mmsg_pcsel & mmsg_pctrdy & mmsg_pceom)
                if ( npeom_delayed[CLAIM_DELAY_INT] & npput_delayed[CLAIM_DELAY_INT] & ~npclaim ) // lintra s-60032
                  npfsm <= 2'b10;
                else if ( npclaim & ((|npput_delayed) | sbe_sbi_tmsg_npput) & ~(npeom_delayed[CLAIM_DELAY_INT]))
                  npfsm <= 2'b01;
                else
                  npfsm <= 2'b00;
      endcase
      
      if( mmsg_pcirdy & mmsg_pctrdy & mmsg_pcsel & mmsg_last_byte) begin
         if( mmsg_pceom ) begin // lintra s-60032 "Lintra cannot handle embedded if statements"
            cmsgip <= '0;
            eh_cnt <= '0;
         end else if( tx_eh_remaining ) begin 
            if( !cmsgip ) begin // lintra s-60032 "Lintra cannot handle embedded if statements"
               cmsgip <= '1;
            end else begin
               eh_cnt <= tx_eh_cnt_next;
            end
         end
      end
  end

//------------------------------------------------------------------------------
//
// Parity handling
//
//------------------------------------------------------------------------------
// When RX_EXT_HEADER_SUPPORT is set, parity is simply propagated. When its not set, agents cannot
// handle extended header, and the payloads' eh bit is reset. Hence Parity is recalculated
// only when RX_EXT_HEADER_SUPPORT is 0.

//------------------------------------------------------------------------------
// HIER hdr changes
//------------------------------------------------------------------------------

// ur_ext_hdr_start controls when the non hdr dw is used to generate the UR completion. The "state" for ur completion depends on put& this start signal
// global EP will always more than 1dw => msgip will always be asserted after first put and can be used to differentiate hdr payload and nonhdr payload
// for local EP, its tied to 1 => no changes.

generate 
if (GLOBAL_EP_IS_STRAP==1) begin : gen_hdr_strap
    logic np_nonhdr_msgip_int, pc_nonhdr_msgip_int;
    logic [7:0] hier_dest_tmsg_int, hier_src_tmsg_int;
    always_ff @(posedge side_clk or negedge side_rst_b) begin
        if (~side_rst_b) begin
            np_nonhdr_msgip_int  <= '0;
            pc_nonhdr_msgip_int  <= '0;
            hier_dest_tmsg_int   <= '0;
            hier_src_tmsg_int    <= '0;
        end
        else begin
            if (nptrdy & npirdy & tmsg_np_last_byte)
                np_nonhdr_msgip_int <= sbe_sbi_tmsg_npmsgip & ~npeom;

            if ( sbe_sbi_tmsg_npput & ~sbe_sbi_tmsg_npmsgip & tmsg_np_first_byte)
                hier_dest_tmsg_int <= npdest_int;

            if ( sbe_sbi_tmsg_npput & ~sbe_sbi_tmsg_npmsgip & tmsg_np_second_byte)
                hier_src_tmsg_int <= npsrc_int;

            if (pctrdy & pcirdy & tmsg_pc_last_byte)
                pc_nonhdr_msgip_int <= sbe_sbi_tmsg_pcmsgip & ~pceom;                
        end
    end //always
    always_comb np_nonhdr_msgip     = global_ep_strap ? np_nonhdr_msgip_int     : sbe_sbi_tmsg_npmsgip;
    always_comb pc_nonhdr_msgip     = global_ep_strap ? pc_nonhdr_msgip_int     : sbe_sbi_tmsg_pcmsgip;
    always_comb ur_ext_hdr_start    = global_ep_strap ? sbe_sbi_tmsg_npmsgip    : 1'b1;
    always_comb hier_dest_tmsg      = global_ep_strap ? hier_dest_tmsg_int      : '0;
    always_comb hier_src_tmsg       = global_ep_strap ? hier_src_tmsg_int       : '0;
end
else begin // GLOBAL_EP parameter is used from here
    if (GLOBAL_EP==1) begin
        always_ff @(posedge side_clk or negedge side_rst_b) begin
            if (~side_rst_b) begin
                np_nonhdr_msgip  <= '0;
                pc_nonhdr_msgip  <= '0;
                hier_dest_tmsg   <= '0;
                hier_src_tmsg    <= '0;
            end
            else begin
                if (nptrdy & npirdy & tmsg_np_last_byte)
                    np_nonhdr_msgip <= sbe_sbi_tmsg_npmsgip & ~npeom;

                if (pctrdy & pcirdy & tmsg_pc_last_byte)
                    pc_nonhdr_msgip <= sbe_sbi_tmsg_pcmsgip & ~pceom;

                if ( sbe_sbi_tmsg_npput & ~sbe_sbi_tmsg_npmsgip & tmsg_np_first_byte)
                    hier_dest_tmsg <= npdest_int;

                if ( sbe_sbi_tmsg_npput & ~sbe_sbi_tmsg_npmsgip & tmsg_np_second_byte)
                    hier_src_tmsg <= npsrc_int;
            end
        end // always
        always_comb ur_ext_hdr_start = sbe_sbi_tmsg_npmsgip;

     end 
     else begin 
            always_comb np_nonhdr_msgip   = sbe_sbi_tmsg_npmsgip;
            always_comb pc_nonhdr_msgip   = sbe_sbi_tmsg_pcmsgip;
            always_comb ur_ext_hdr_start  = 1'b1;
            always_comb hier_dest_tmsg    = '0;
            always_comb hier_src_tmsg     = '0;
     end // if !GLOBAL_EP
end // else
endgenerate

// The minimal amount of flops needed to generate the completion for the
// unclaimed non-posted messages
always_ff @(posedge side_clk or negedge side_rst_b) begin
    if (~side_rst_b) begin
        npdest_mstr  <= '0;
        npsrc_mstr   <= '0;
        nptag_mstr   <= '0;
    end
    else begin
        if ( sbe_sbi_tmsg_npput & ~np_nonhdr_msgip & tmsg_np_first_byte)    npdest_mstr <= npdest_int;
        if ( sbe_sbi_tmsg_npput & ~np_nonhdr_msgip & tmsg_np_second_byte)   npsrc_mstr  <= npsrc_int;
        if ( sbe_sbi_tmsg_npput & ~np_nonhdr_msgip & tmsg_np_last_byte)     nptag_mstr  <= nptag_int;
    end
end


  // Debug signals
  always_comb
    dbgbus = { 2'b0, nphdrdrp, pchdrdrp, npfsm, npmsgip, pcmsgip };
  
//-----------------------------------------------------------------------------
//
// SV Cover properties 
//
//-----------------------------------------------------------------------------

  `ifdef INTEL_SIMONLY
  //`ifdef INTEL_INST_ON // SynTranlateOff

`ifndef IOSF_SB_EVENT_OFF

  sbetrgt_has_fenced_np_pend_req: //samevent
    cover property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
      npirdy |-> (&sbi_sbe_tmsg_npfree & (npfence | wait_for_claim) & ~(mmsg_pcirdy & (~mmsg_pcsel | ~mmsg_pctrdy))) )
`ifndef IOSF_SB_EVENT_VERBOSE
      if ( 0 )
`endif
      $info("%0t: %m: EVENT: non posted is being fenced in sbetrgt", $time);

  sbetrgt_received_unclaimed_np:
    cover property (@(posedge side_clk) disable iff (~side_rst_b)
                    (npeom_delayed[CLAIM_DELAY_INT] & npput_delayed[CLAIM_DELAY_INT]) |=> (npfsm[1] & ~npclaim))
`ifndef IOSF_SB_EVENT_VERBOSE
      if ( 0 )
`endif
      $info("%0t: %m: EVENT: sbtrgt received unclaimed NP transaction", $time);

    generate 
      if ( ~|RX_EXT_HEADER_SUPPORT )
        begin : assert_dropped_pc_header
          sbetrgt_dropped_pc_header:
            cover property (@(posedge side_clk) disable iff (~side_rst_b)
                            |pchdrdrp)
`ifndef IOSF_SB_EVENT_VERBOSE
              if ( 0 )
`endif
                $info("%0t: %m: EVENT: sbetrgt dropped incoming posted extended header", $time);
        
        sbetrgt_dropped_np_header:
          cover property (@(posedge side_clk) disable iff (~side_rst_b)
                          |nphdrdrp)
`ifndef IOSF_SB_EVENT_VERBOSE
            if ( 0 )
`endif
              $info("%0t: %m: EVENT: sbetrgt dropped incoming non-posted extended header", $time);
        end
    endgenerate

`endif

`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
    //coverage off
    generate
      if ( |TX_EXT_HEADER_SUPPORT )
        begin
          logic eh_zero, eh_one;
// check to see if the header bit is driven to zero
        if (~|NUM_TX_EXT_HEADERS) begin
            always_comb begin
                eh_zero = tx_ext_headers[NUM_TX_EXT_HEADERS][7];
                eh_one  = 1'b1;
            end
        end else if (NUM_TX_EXT_HEADERS == 1) begin 
// check to see if the ext header bit in the last ext header is 0 and the ext header bit in the previous one is 1
            always_comb begin
                eh_zero = tx_ext_headers[1][7];
                eh_one  = tx_ext_headers[0][7];
            end
        end else begin 
// check to see if all the ext header bits in all the previous ext headers are 1 and the ext header bit in the last one is 0
            always_comb begin
                eh_zero = tx_ext_headers[NUM_TX_EXT_HEADERS][7];
                for (int unsigned i=0; i<=NUM_TX_EXT_HEADERS-1; i++)
                     eh_one &= tx_ext_headers[i][7];
            end
        end
         
            sbetrgt_header_check:
                assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
                             mmsg_pcirdy |-> (eh_one & ~eh_zero))
                else
                $error("%0t: %m: ERROR: No end of EH bit was found in the tx_ext_headers input", $time);
          end
    endgenerate
 
    generate 
        if (|SB_PARITY_REQUIRED) begin
            logic ext_header, parity_enabled, parity_config_check;
            always_comb ext_header = |RX_EXT_HEADER_SUPPORT;
            always_comb parity_enabled = |SB_PARITY_REQUIRED;
            always_comb parity_config_check = ext_header | ~parity_enabled;
            
            always @ (posedge side_rst_b) begin
                parity_rx_ext_header: assert (parity_config_check) else
                $error ("Error Incorrect config setting - If parity is enabled, agents must also support extended header");
            end
        end
    endgenerate
    
    // coverage on
`endif
`endif
     `endif // SynTranlateOn

endmodule

// lintra pop
