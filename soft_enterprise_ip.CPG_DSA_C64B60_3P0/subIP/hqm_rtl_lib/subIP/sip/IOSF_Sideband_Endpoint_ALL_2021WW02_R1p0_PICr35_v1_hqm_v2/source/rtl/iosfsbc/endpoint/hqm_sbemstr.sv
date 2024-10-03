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
//  Module sbemstr : The master interface block within the sideband interface
//                   base endpoint (sbebase).
//
//------------------------------------------------------------------------------

// lintra push -60020, -60088, -80028, -68001, -60024b, -2050, -70036_simple

module hqm_sbemstr
#(
  parameter INTERNALPLDBIT              = 7, // Maximum payload bit, should be 7, 15 or 31	 
  parameter SB_PARITY_REQUIRED          = 0,
  parameter MAXPCMSTR                   = 0, // Maximum posted/completion master agent number
            MAXNPMSTR                   = 0, // Maximum non-posted        master agent number
            DISABLE_COMPLETION_FENCING  = 0,
            GLOBAL_EP                   = 0,
  parameter GLOBAL_EP_IS_STRAP          = 0 

)(
  // Clock/Reset Signals
  input  logic                     side_clk, 
  input  logic                     side_rst_b,
  input  logic                     global_ep_strap, // lintra s-70036, s-0527 Used only in transparent bridge EP
                                   
  // ISM Interface Signal          
  output logic                     idle_mstr,

  // Master Interface Signals
  input  logic       [MAXPCMSTR:0] sbi_sbe_mmsg_pcirdy,
  input  logic       [MAXNPMSTR:0] sbi_sbe_mmsg_npirdy,
  input  logic       [MAXPCMSTR:0] sbi_sbe_mmsg_pceom,
  input  logic       [MAXNPMSTR:0] sbi_sbe_mmsg_npeom,
  input  logic       [MAXPCMSTR:0] sbi_sbe_mmsg_pcparity, // lintra s-70036, s-0527
  input  logic       [MAXNPMSTR:0] sbi_sbe_mmsg_npparity, // lintra s-70036, s-0527
  input  logic [(INTERNALPLDBIT+1)*MAXPCMSTR+INTERNALPLDBIT:0] sbi_sbe_mmsg_pcpayload,
  input  logic [(INTERNALPLDBIT+1)*MAXNPMSTR+INTERNALPLDBIT:0] sbi_sbe_mmsg_nppayload,
  output logic                     sbe_sbi_mmsg_pcmsgip,
  output logic                     sbe_sbi_mmsg_npmsgip,
  output logic       [MAXPCMSTR:0] sbe_sbi_mmsg_pcsel,
  output logic       [MAXNPMSTR:0] sbe_sbi_mmsg_npsel,

  // Egress Port Signals
  input  logic                     enpstall,
  input  logic                     epctrdy,
  input  logic                     enptrdy,
  output logic                     epcirdy,
  output logic                     enpirdy,
  output logic                     eom,
  output logic                     parity,
  output logic  [INTERNALPLDBIT:0] data,

  // SBETRGT Interface Signals
  input  logic  sbe_sbi_tmsg_npput,
  input  logic  sbe_sbi_tmsg_npeom,
  input  logic  sbe_sbi_tmsg_npmsgip,

  input  logic [7:0]                npdest_mstr,   // Non-posted message destination port ID
  input  logic [7:0]                npsrc_mstr,    // Non-posted message source port ID
  input  logic [2:0]                nptag_mstr,    // Non-posted message tag  
  output logic                      cfence,

  output logic              [23:0] dbgbus
);
`include "hqm_sbcglobal_params.vm"

localparam logic [MAXPCMSTR:0] INITIALPCSEL = 1;
localparam logic [MAXNPMSTR:0] INITIALNPSEL = 1;

localparam PC_DST_START = (INTERNALPLDBIT ==  7)    ?  0 : 8;
localparam PC_OPC_START = (INTERNALPLDBIT == 31)    ? 16 : 0;
localparam PC_TAG_START = (INTERNALPLDBIT ==  7)    ?  0 : ((INTERNALPLDBIT == 15) ? 8 : 24);

  // Flops
  logic                        np;          // Arbiter state: 0=posted/completion / 1=nonposted
  logic                        cmsgip;
  logic                         first_dw;
  
  // Arbiter signals:
  // any_* means that any master (one or more) is requesting (irdy)
  // sel_* means that the selected master is requesting (irdy)
  // msk_* means that any (except the selected) master is requesting (irdy)
  logic                        any_pc; 
  logic                        any_np; 
  logic                        sel_pc; 
  logic                        sel_np; 
  logic                        msk_pc; 
  logic                        msk_np; 

  always_comb
    begin
      any_pc = |sbi_sbe_mmsg_pcirdy;
      any_np = |sbi_sbe_mmsg_npirdy;
      sel_pc = |( sbe_sbi_mmsg_pcsel & sbi_sbe_mmsg_pcirdy);
      sel_np = |( sbe_sbi_mmsg_npsel & sbi_sbe_mmsg_npirdy);
      msk_pc = |(~sbe_sbi_mmsg_pcsel & sbi_sbe_mmsg_pcirdy);
      msk_np = |(~sbe_sbi_mmsg_npsel & sbi_sbe_mmsg_npirdy);
    end
  


logic mstr_pc_first_byte;
logic mstr_pc_second_byte;
logic mstr_pc_third_byte;
logic mstr_pc_last_byte;
logic mstr_np_first_byte;
logic mstr_np_second_byte;// lintra s-70036
logic mstr_np_third_byte;// lintra s-70036
logic mstr_np_last_byte;

logic pcparity, npparity;
logic mstr_pc_valid;// lintra s-70036 "used only in pld 8/16 and also only in global_ep"
logic mstr_np_valid;// lintra s-70036
logic cmp_lcl_done; // lintra s-0531 "used only in global ep"
    
always_comb mstr_pc_valid = (|(sbe_sbi_mmsg_pcsel & sbi_sbe_mmsg_pcirdy)) & epctrdy;
always_comb mstr_np_valid = (|(sbe_sbi_mmsg_npsel & sbi_sbe_mmsg_npirdy)) & enptrdy;

generate
if (INTERNALPLDBIT == 31)
    begin: gen_mstr_be_31
        always_comb mstr_pc_first_byte  = 1'b1;
        always_comb mstr_pc_second_byte = 1'b1;
        always_comb mstr_pc_third_byte  = 1'b1;
        always_comb mstr_pc_last_byte   = 1'b1;
        always_comb mstr_np_first_byte  = 1'b1;
        always_comb mstr_np_second_byte = 1'b1;
        always_comb mstr_np_third_byte  = 1'b1;
        always_comb mstr_np_last_byte   = 1'b1;
    end
else begin: gen_mstr_be_15_7
        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
        i_sbebytecount_mstr_pc (
            .side_clk           (side_clk),
            .side_rst_b         (side_rst_b),
            .valid              (mstr_pc_valid),
            .first_byte         (mstr_pc_first_byte),
            .second_byte        (mstr_pc_second_byte),
            .third_byte         (mstr_pc_third_byte),
            .last_byte          (mstr_pc_last_byte)
        );

        hqm_sbebytecount #(.INTERNALPLDBIT (INTERNALPLDBIT))
        i_sbebytecount_mstr_np (
            .side_clk           (side_clk),
            .side_rst_b         (side_rst_b),
            .valid              (mstr_np_valid),
            .first_byte         (mstr_np_first_byte),
            .second_byte        (mstr_np_second_byte),
            .third_byte         (mstr_np_third_byte),
            .last_byte          (mstr_np_last_byte)
        );
    end
endgenerate



// The put signals indicate that a 4 byte flit has been transferred to the
// egress port
logic pcput;
logic npput;

  always_comb
    begin
      pcput  = epcirdy & epctrdy;
      npput  = enpirdy & enptrdy;
    end
  
  // 2D array to make the output mux selection easier
  logic [MAXPCMSTR:0][INTERNALPLDBIT:0] pc_array; 
  always_comb pc_array = sbi_sbe_mmsg_pcpayload;
  logic [MAXNPMSTR:0][INTERNALPLDBIT:0] np_array;
  always_comb np_array = sbi_sbe_mmsg_nppayload;

  // Payload output muxes:  The select vector is used to mux the payload from
  // the selected master to be sent to the egress port
  logic [INTERNALPLDBIT:0]              pcpayload;
  always_comb begin
    pcpayload = '0;
    for (int i=0; i <= MAXPCMSTR; i++)
      if (sbe_sbi_mmsg_pcsel[i]) pcpayload |= pc_array[i];
  end

  logic [INTERNALPLDBIT:0] nppayload;
  always_comb begin
    nppayload = '0;
    for (int i=0; i <= MAXNPMSTR; i++)
      if (sbe_sbi_mmsg_npsel[i]) nppayload |= np_array[i];
  end
  
  always_comb
    begin
      
      // Outputs to the egress port
      
      enpirdy = sel_np & ~enpstall & np;
      epcirdy = sel_pc & ~enpirdy;
      eom     = enpirdy ? (|(sbe_sbi_mmsg_npsel & sbi_sbe_mmsg_npeom))
        : (|(sbe_sbi_mmsg_pcsel & sbi_sbe_mmsg_pceom));
      data    = ~enpirdy ? pcpayload : nppayload;
      parity  = ~enpirdy ? pcparity  : npparity;
      
      // Output to the ISM
      idle_mstr = ~sbe_sbi_mmsg_pcmsgip & ~any_pc &
                  ~sbe_sbi_mmsg_npmsgip & ~any_np;
      
    end 
  
  // Flops: 3 total
  always_ff @(posedge side_clk or negedge side_rst_b)
    if (~side_rst_b)
      begin
        sbe_sbi_mmsg_pcmsgip <= '0; // 1: Posted message in progress
        sbe_sbi_mmsg_npmsgip <= '0; // 1: Non-posted message in progress
        np <= '0;                   // 1: 0 = Posted/completion / 1 = non-posted
      end
    else
      begin
        
        // In-progess indicators are updated when a flit transfer occurs and is
        // set to 0 if it is the eom, 1 otherwise.
        //jignasa
       // if (pcput) begin
         //   if (~eom & mstr_pc_last_byte) sbe_sbi_mmsg_pcmsgip <= '1;
           // if (eom & mstr_pc_last_byte)  sbe_sbi_mmsg_pcmsgip <= '0;
        //end
        //if (npput) begin
        //    if (~eom & mstr_np_last_byte) sbe_sbi_mmsg_npmsgip <= '1;
        //    if (eom & mstr_np_last_byte)  sbe_sbi_mmsg_npmsgip <= '0;
        //end

        if (pcput & mstr_pc_last_byte) begin
            sbe_sbi_mmsg_pcmsgip <= eom ? '0 : '1;
            end
        if (npput & mstr_np_last_byte) begin
            sbe_sbi_mmsg_npmsgip <= eom ? '0 : '1;
            end

        //jignasa

        
        // Flow class arbiter: State change occurs when the selected traffic
        // class either completes the current message or there is no message in
        // progress and the other traffic class has a message to send.
        np <= np
              ? ~(any_pc & ((npput & eom) |
                            (~sbe_sbi_mmsg_npmsgip & ~sel_np)))
                :  (any_np & ((pcput & eom) |
                              (~sbe_sbi_mmsg_pcmsgip & ~sel_pc)));
        
      end

// Parity
genvar i;
generate
    if (SB_PARITY_REQUIRED) begin: gen_mstr_parity
            //for (i=0; i <= MAXPCMSTR; i++) begin
                always_comb pcparity = |(sbe_sbi_mmsg_pcsel & sbi_sbe_mmsg_pcparity);
            //end

            //for (i=0; i <= MAXNPMSTR; i++) begin
                always_comb npparity = |(sbe_sbi_mmsg_npsel & sbi_sbe_mmsg_npparity);
            //end
    end
    else begin: gen_mstr_noparity
        always_comb pcparity = '0;
        always_comb npparity = '0;
    end
endgenerate


logic block_pcsel;
logic block_pcsel_f;
logic data_opc_cmp;
logic data_src_cmp;
logic data_dst_cmp;
logic data_tag_cmp;
generate
    if (INTERNALPLDBIT ==31) begin: gen_blk_sel_31
        always_comb block_pcsel = 1'b0;
        always_comb block_pcsel_f = 1'b0;
    end // 32 bit payload end
    else begin: gen_blk_sel_15_7
// block sel, blocks pcsel from changing the masters/targets sel, in between first and last byte
// eom is anded with the ~npirdy to make sure its only pceom
        always_comb begin
            unique casez ({mstr_pc_first_byte, (mstr_pc_last_byte & eom & ~enpirdy)})
                2'b10: block_pcsel = '1;
                2'b01: block_pcsel = '0;
                2'b11: block_pcsel = '0;//in 32bit case, first byte and last byte are asserted together
                default: block_pcsel = block_pcsel_f;
            endcase
        end

        always_ff @ (posedge side_clk or negedge side_rst_b) begin
        if (~side_rst_b)
            block_pcsel_f <= '0;
        else 
            block_pcsel_f <= block_pcsel;
        end
    end // 15, 7 bit payload end
endgenerate

logic block_npsel;
logic block_npsel_f;

generate
    if (INTERNALPLDBIT ==31) begin: gen_blk_sel_31_np
        always_comb block_npsel = 1'b0;
        always_comb block_npsel_f = 1'b0;
    end // 32 bit payload end
    else begin: gen_blk_sel_15_7_np
// block sel, blocks npsel from changing the masters/targets sel, in between first and last byte
// eom is anded with the npirdy to make sure its only npeom
        always_comb begin
            unique casez ({mstr_np_first_byte, (mstr_np_last_byte & eom & enpirdy)})
                2'b10: block_npsel = '1;
                2'b01: block_npsel = '0;
                2'b11: block_npsel = '0;//in 32bit case, first byte and last byte are asserted together
                default: block_npsel = block_npsel_f;
            endcase
        end

        always_ff @ (posedge side_clk or negedge side_rst_b) begin
        if (~side_rst_b)
            block_npsel_f <= '0;
        else 
            block_npsel_f <= block_npsel;
        end
    end // 15, 7 bit payload end
endgenerate

always_comb begin
    data_opc_cmp  = ( (data[(PC_OPC_START+7):PC_OPC_START] == SBCOP_CMP )  || 
                                    (data[(PC_OPC_START+7):PC_OPC_START] == SBCOP_CMPD));
    data_src_cmp = (data[7:0] == npsrc_mstr);
    data_dst_cmp = (data[(PC_DST_START+7):PC_DST_START] == npdest_mstr);
    data_tag_cmp = (data[(PC_TAG_START+2):PC_TAG_START] == nptag_mstr);
end


logic cmp_hdr_done, hier_completion_msgip;

generate
if (GLOBAL_EP_IS_STRAP==1) begin : gen_hier_cmp
    logic cmp_hdr_done_int, cmp_lcl_done_int, hier_completion_msgip_int;
    always_ff @ (posedge side_clk or negedge side_rst_b) begin
        if (~side_rst_b) begin
            cmp_hdr_done_int <= '0;
            cmp_lcl_done_int <= '0;
            hier_completion_msgip_int <= '0;
        end
        else begin
            if (mstr_pc_valid & mstr_pc_last_byte & ~eom) begin
                cmp_hdr_done_int <= 1'b1;
                cmp_lcl_done_int <= cmp_hdr_done;
            end
            else if (mstr_pc_valid & eom & cmp_hdr_done) begin
                cmp_hdr_done_int <= 1'b0;
                cmp_lcl_done_int <= 1'b0;
            end
// When in hier hdr mode, the completion opcode and tag would come in the 2nd dw. By shifting the original msgip by 1DW here,
// hier_completion_msgip can be used to clear cfence (with all match).
            if (pcput & mstr_pc_last_byte) hier_completion_msgip_int <= sbe_sbi_mmsg_pcmsgip & ~eom;
        end //else
    end //always
    always_comb cmp_hdr_done            = global_ep_strap ?  cmp_hdr_done_int           : '0;
    always_comb first_dw                = global_ep_strap ? (cmp_hdr_done_int & ~cmp_lcl_done_int) : ~sbe_sbi_mmsg_pcmsgip;
    always_comb hier_completion_msgip   = global_ep_strap ? hier_completion_msgip_int   : sbe_sbi_mmsg_pcmsgip;
end
else begin // GLOBAL_EP parameter
    if (GLOBAL_EP==1) begin : gen_hier_cmp
        always_ff @ (posedge side_clk or negedge side_rst_b) begin
            if (~side_rst_b) begin
                cmp_hdr_done <= '0;
                cmp_lcl_done <= '0;
                hier_completion_msgip <= '0;
            end
            else begin
                if (mstr_pc_valid & mstr_pc_last_byte & ~eom) begin
                    cmp_hdr_done <= 1'b1;
                    cmp_lcl_done <= cmp_hdr_done;
                end
                else if (mstr_pc_valid & eom & cmp_hdr_done) begin
                    cmp_hdr_done <= 1'b0;
                    cmp_lcl_done <= 1'b0;
                end
// When in hier hdr mode, the completion opcode and tag would come in the 2nd dw. By shifting the original msgip by 1DW here,
// hier_completion_msgip can be used to clear cfence (with all match).
                if (pcput & mstr_pc_last_byte) hier_completion_msgip <= sbe_sbi_mmsg_pcmsgip & ~eom;
            end
        end
        always_comb first_dw = cmp_hdr_done & ~cmp_lcl_done;
    end
        else begin: gen_nohier_cmp // else
            always_comb cmp_hdr_done    = '0;
            always_comb first_dw        = ~sbe_sbi_mmsg_pcmsgip;
            always_comb hier_completion_msgip = sbe_sbi_mmsg_pcmsgip;
            always_comb cmp_lcl_done    = '0;
        end
    end
endgenerate

  generate
    if ( ~|DISABLE_COMPLETION_FENCING )
      begin : gen_fnc_en_blk
logic  dst_match; //lintra s-70036
logic  src_match; //lintra s-70036
logic  opc_match; //lintra s-70036
logic  all_match;
logic fence_valid;

        // completion fencing logic
        always_ff @(posedge side_clk or negedge side_rst_b)
          if ( ~side_rst_b )
            begin
              cfence    <= '0;
              cmsgip    <= '0;
              dst_match <= '0;
              src_match <= '0;
              opc_match <= '0;
            //  all_match <= '0;
            end
          else
            begin

              //if (pcput && ~sbe_sbi_mmsg_pcmsgip && ~eom) begin
              // 15bit payload will have eom asserted on 3rd byte.
              if (pcput && first_dw) begin
                  if (mstr_pc_first_byte & data_src_cmp)
                        src_match <= '1;
                  if (mstr_pc_second_byte & data_dst_cmp)
                        dst_match <= '1;
                  if (mstr_pc_third_byte & data_opc_cmp)
                        opc_match <= '1;
                 
              end

              // apply the fence when the NP message is received.
              // fence_valid will mask the fence for bulk completion error cases
              if ( sbe_sbi_tmsg_npput & sbe_sbi_tmsg_npeom & (fence_valid || ~sbe_sbi_tmsg_npmsgip))
                cfence <= '1;

// cmsgip should be set when there is a put and no eom (set by completion code)
// but once set, it has to be reset only by put and eom. 
              if ( pcput &&
                   (~sbe_sbi_mmsg_pcmsgip || ~hier_completion_msgip) &&
                   ~eom && ~cmsgip)
                cmsgip <= all_match;

              if ( pcput && eom ) begin
                cmsgip      <= '0;
                dst_match   <= '0;
                src_match   <= '0;
                opc_match   <= '0;
                //all_match   <= '0;
              end
              
              // clear fence when eom of the completion is transmitted
              if ( pcput &&
                   eom &&
                   ( cmsgip || (~sbe_sbi_mmsg_pcmsgip && all_match) || (~hier_completion_msgip && all_match)))
                    cfence      <= '0;
            end //else block
    
// 7 bit, the last byte and eom will come together hence the check needs to be combinatorial
// 15 bit, the last 2 bytes and eom will be together
// foe 31 bit, everythign will have to be checked combinatorially
        always_comb begin
            all_match = ( INTERNALPLDBIT == 7) ? (mstr_pc_last_byte & src_match     & dst_match     & opc_match     & data_tag_cmp) : 
                        ((INTERNALPLDBIT ==15) ? (mstr_pc_last_byte & src_match     & dst_match     & data_opc_cmp  & data_tag_cmp) :
                                                 (mstr_pc_last_byte & data_src_cmp  & data_dst_cmp  & data_opc_cmp  & data_tag_cmp));
        end
// Instead of routing the mask fence from Bulk widget, create an internal "valid" to set/mask the setting of fence
// The fence_valid should be set on the first TMSG NP and reset if the completion for a particular NP (mmsg_pc and all_match) is recieved
// That would gate the fence if the completion is recived/completes before the actual TMSG NP message completes - which would happen only in bulk NP with error case


        always_ff @ (posedge side_clk or negedge side_rst_b) begin
            if (~side_rst_b) begin
                fence_valid <= '0;
            end
            else begin
                if (sbe_sbi_tmsg_npput & ~sbe_sbi_tmsg_npmsgip)
                    fence_valid <= 1'b1;
              if ( pcput &&
                   eom &&
                   ( cmsgip || (~sbe_sbi_mmsg_pcmsgip && all_match) || (~hier_completion_msgip && all_match)))
                    fence_valid <= '0;
            end
        end
        
      end // if ( ~|DISABLE_COMPLETION_FENCING )
    else
      begin : gen_fnc_ds_blk
        always_comb cfence = '0;
        always_comb cmsgip = '0;
      end // else: !if( ~|DISABLE_COMPLETION_FENCING )
  endgenerate
  
  // Posted/Completion Master Arbiter
  generate
    if (MAXPCMSTR==0)
     begin : gen_pcmxmst_blk0 
      // If there is only 1 master, then it is always selected
      always_comb sbe_sbi_mmsg_pcsel = '1;
     end
    else
        begin : gen_pcmxmst_blk
          
          // Determine the next master by creating all possible circular shifted
          // versions of the current one-hot encoded seletion vector
          logic [MAXPCMSTR:0][MAXPCMSTR:0] pcsel_array;
          always_comb 
            begin
              pcsel_array[0] = sbe_sbi_mmsg_pcsel;
              for (int i=1; i<=MAXPCMSTR; i++)
                pcsel_array[i] = { pcsel_array[i-1][MAXPCMSTR-1:0],
                                   pcsel_array[i-1][MAXPCMSTR]     };
            end
          
          // Find the closest left shifted vector that selects an active requestor
          logic  [MAXPCMSTR:0] nxtpcsel;
          always_comb 
            begin
              nxtpcsel = pcsel_array[0];
              for (int i=MAXPCMSTR; i>0; i--)
                if ( |(pcsel_array[i] & sbi_sbe_mmsg_pcirdy) )
                  nxtpcsel = pcsel_array[i];
            end
          
          // The selection state change occurs when there is a master active (other
          // than the currently selected master) and the current message transfer is
          // just completing (eom) or there is not a message in-progress and the
          // selected master is not requesting for a transfer.
          always_ff @(posedge side_clk or negedge side_rst_b)
            if (~side_rst_b)
              sbe_sbi_mmsg_pcsel <= INITIALPCSEL;
            else if (msk_pc & ((pcput & eom) | (~sel_pc & ~sbe_sbi_mmsg_pcmsgip & ~block_pcsel)))
              sbe_sbi_mmsg_pcsel <= nxtpcsel;
          
        end 
  endgenerate
  

// Non-posted Master Arbiter
generate
  if (MAXNPMSTR==0)
   begin : gen_npmxmst_blk0  
    // If there is only 1 master, then it is always selected
    always_comb sbe_sbi_mmsg_npsel = '1;
   end
  else 
    begin : gen_npmxmst_blk0 
      
      // Determine the next master by creating all possible circular shifted
      // versions of the current one-hot encoded seletion vector
      logic [MAXNPMSTR:0][MAXNPMSTR:0] npsel_array;
      always_comb 
        begin
          npsel_array[0] = sbe_sbi_mmsg_npsel;
          for (int i=1; i<=MAXNPMSTR; i++)
            npsel_array[i] = { npsel_array[i-1][MAXNPMSTR-1:0],
                               npsel_array[i-1][MAXNPMSTR]     };
        end
      
      // Find the closest left shifted vector that selects an active requestor
      logic  [MAXNPMSTR:0] nxtnpsel;
      always_comb 
        begin
          nxtnpsel = npsel_array[0];
          for (int i=MAXNPMSTR; i>0; i--)
            if ( |(npsel_array[i] & sbi_sbe_mmsg_npirdy) )
              nxtnpsel = npsel_array[i];
        end
      
      // The selection state change occurs when there is a master active (other
      // than the currently selected master) and the current message transfer is
      // just completing (eom) or there is not a message in-progress and the
      // selected master is not requesting for a transfer.
      always_ff @(posedge side_clk or negedge side_rst_b)
        if (~side_rst_b)
          sbe_sbi_mmsg_npsel <= INITIALNPSEL;
        else if (msk_np & ((npput & eom) | (~sel_np & ~sbe_sbi_mmsg_npmsgip & ~block_npsel)))
          sbe_sbi_mmsg_npsel <= nxtnpsel;
      
    end
  
endgenerate

  logic [3:0] npsel_bin;
  logic [3:0] pcsel_bin;
  

  // supports up to 16 pc/np masters
  
  // SG lint reports this as a violation. But since these are used only for debug, this coding style is ok.
  // It is the simplest way to encode the 16 possible masters (MAXNPMSTR/MAXPCMSTR) onto 4 bits of pcsel_bin/npsel_bin.
  // E.g if sbe_sbi_mmsg_npsel is 4 (0..00100), npsel_bin would be 2 indicating that the third master (0 based maxpcmstr=2) is selected.

  always_comb
    begin
      npsel_bin = '0;
      for (int unsigned i = 0; (i <= MAXNPMSTR) && (i <= 15); i++)
        if ( sbe_sbi_mmsg_npsel[i] )
          npsel_bin |= i[3:0];

      pcsel_bin = '0;
      for (int unsigned i = 0; (i <= MAXPCMSTR) && (i <= 15); i++)
        if ( sbe_sbi_mmsg_pcsel[i] )
          pcsel_bin |= i[3:0];
    end
  
always_comb
  begin
    dbgbus = '0;
    dbgbus[          3 : 0] = npsel_bin;
    dbgbus[          7 : 4] = pcsel_bin;
    dbgbus[              8] = sbe_sbi_mmsg_pcmsgip; 
    dbgbus[              9] = sbe_sbi_mmsg_npmsgip; 
    dbgbus[             10] = np;
    dbgbus[             11] = cmsgip;
    dbgbus[             12] = cfence;
    
  end


`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF

// coverage off
// `ifdef INTEL_INST_ON // SynTranlateOff
 `ifdef INTEL_SIMONLY 
   generate
     // cfence assertions
     if (~|DISABLE_COMPLETION_FENCING) begin
       logic [31:0]  pc_opcode_cycle;
       assign pc_opcode_cycle =   (16/(INTERNALPLDBIT+1))
                                + (((|GLOBAL_EP) || ((|GLOBAL_EP_IS_STRAP) && global_ep_strap))
                                     ? (32/(INTERNALPLDBIT+1))
                                     : 0
                                  );

       logic   tmsg_np_new_msg, tmsg_np_som;   // start of message for NP
       logic   mmsg_pc_new_msg, mmsg_pc_put, mmsg_cpl_eom;  // end of message for CPL
       logic   mmsg_opc_cycle, mmsg_payload_opc_match, mmsg_cpl_opc_match;
       integer cpl_trk_cnt, mmsg_pc_cycle_cnt;

       assign  tmsg_np_som = tmsg_np_new_msg && sbe_sbi_tmsg_npput;
       assign  mmsg_pc_put = pcput && (|(sbe_sbi_mmsg_pcsel & sbi_sbe_mmsg_pcirdy));
       assign  mmsg_pc_eom = |(sbe_sbi_mmsg_pcsel & sbi_sbe_mmsg_pceom);

       assign  mmsg_opc_cycle = (mmsg_pc_cycle_cnt == pc_opcode_cycle);
       assign  mmsg_payload_opc_match  =    (pcpayload[PC_OPC_START+:8]  == SBCOP_CMP)
                                         || (pcpayload[PC_OPC_START+:8]  == SBCOP_CMPD);

       assign  mmsg_cpl_eom   = mmsg_pc_put && mmsg_pc_eom && (mmsg_cpl_opc_match || (mmsg_opc_cycle && mmsg_payload_opc_match));

       always_ff @(posedge side_clk or negedge side_rst_b) begin
         if (!side_rst_b) begin
           cpl_trk_cnt        <= 0;

           tmsg_np_new_msg    <= 1'b1;
           mmsg_pc_new_msg    <= 1'b1;

           mmsg_pc_cycle_cnt  <= 0;
           mmsg_cpl_opc_match <= 1'b0;
         end else begin
           cpl_trk_cnt  <= cpl_trk_cnt + tmsg_np_som - mmsg_cpl_eom;

           if (sbe_sbi_tmsg_npput) begin
             tmsg_np_new_msg  <= sbe_sbi_tmsg_npeom ? 1'b1 : 1'b0;
           end

           if (mmsg_pc_put) begin
             mmsg_pc_new_msg  <= mmsg_pc_eom ? 1'b1 : 1'b0;
           end

           if (mmsg_pc_put) begin
             if (mmsg_pc_eom) begin
               mmsg_pc_cycle_cnt   <= 0;
               mmsg_cpl_opc_match  <= 1'b0;
             end else begin
               mmsg_pc_cycle_cnt   <= mmsg_pc_cycle_cnt + 1;

               if (mmsg_opc_cycle && mmsg_payload_opc_match)
                  mmsg_cpl_opc_match  <= 1'b1;
             end
           end
         end
       end

       // there is only max 1 outstanding NP request
       property cpl_trk_cnt_in_range;
         @(posedge side_clk) disable iff (side_rst_b !== 1'b1)
            (|{tmsg_np_som, mmsg_cpl_eom}) |=> ((cpl_trk_cnt == 0) || (cpl_trk_cnt == 1));
       endproperty
       
       // cpl_com cannot happen at the same cycle with np_som
       property tmsg_np_mmsg_cpl_overlap;
         @(posedge side_clk) disable iff (side_rst_b !== 1'b1)
            (|{tmsg_np_som, mmsg_cpl_eom}) |-> (tmsg_np_som != mmsg_cpl_eom);
       endproperty
       
       chk_cpl_trk_cnt_in_range:
       assert property (cpl_trk_cnt_in_range)
       else $display("%t - CFENCE ERROR: %m - %d outstanding NP requests to agents while Completion Fencing is enabled !!!", $time, cpl_trk_cnt);
       
       chk_tmsg_np_mmsg_cpl_overlap:
       assert property (tmsg_np_mmsg_cpl_overlap)
       else $display("%t - CFENCE ERROR: %m - SOM of TMSG NP overlapping with MMSG CPL !!!", $time);

       // normally cfence should rise whenever tmsg_npput and tmsg_npeom happens,
       // the only exception is mmsg_cpl_eom happens before tmsg_npeom, which could happen in BulkRdWr error case
       // The sequence is np_som -> cpl_trk_cnt "1" -> cpl_eom -> cpl_trk_cnt "0" -> np_eom
       // in case of simple message np_som and np_eom is at the same cycle, which always assert cfence
       property cfence_assertion;
         @(posedge side_clk) disable iff (side_rst_b !== 1'b1)
            (&{sbe_sbi_tmsg_npput, sbe_sbi_tmsg_npeom, (tmsg_np_som || ((cpl_trk_cnt == 1) && ~mmsg_cpl_eom))})
               |=> (cfence == 1'b1);
       endproperty
       
       // all cpl_eom will cause cfence drop
       property cfence_deassertion;
         @(posedge side_clk) disable iff (side_rst_b !== 1'b1)
            (mmsg_cpl_eom) |=> (cfence == 1'b0);
       endproperty
       
       // cfence cannot change other than 2 conditions specified above
       property cfence_stable;
         @(posedge side_clk) disable iff (side_rst_b !== 1'b1)
            (!$stable(cfence))
              |-> $past(    (mmsg_cpl_eom && cfence)
                        || &{sbe_sbi_tmsg_npput, sbe_sbi_tmsg_npeom, (tmsg_np_som || ((cpl_trk_cnt == 1) && ~mmsg_cpl_eom))});
       endproperty
       
       chk_cfence_assertion:
       assert property (cfence_assertion)
       else $display("%t - CFENCE ERROR: %m - cfence is not asserted as expected !!!", $time);
       
       chk_cfence_deassertion:
       assert property (cfence_deassertion)
       else $display("%t - CFENCE ERROR: %m - cfence is not asserted as expected !!!", $time);
       
       chk_cfence_unexpected_change:
       assert property (cfence_stable)
       else $display("%t - CFENCE ERROR: %m - cfence change is not expected !!!", $time);

       // hier_completion_msgip should be the same as sbe_sbi_mmsg_pcmsgip in legacy 8 bits port ide mode
       property hier_cpl_msgip_in_legacy;
         @(posedge side_clk) disable iff (side_rst_b !== 1'b1 || (|GLOBAL_EP) || (|GLOBAL_EP_IS_STRAP && global_ep_strap))
            (!$stable({hier_completion_msgip, sbe_sbi_mmsg_pcmsgip})) |-> (hier_completion_msgip == sbe_sbi_mmsg_pcmsgip);
       endproperty
       
       chk_hier_cpl_msgip_in_legacy:
       assert property (hier_cpl_msgip_in_legacy)
       else $display("%t - CFENCE ERROR: %m - hier_completion_msgip differs from sbe_sbi_mmsg_pcmsgip in legacy 8 bits port id mode !!!", $time);
     end
   endgenerate
// coverage on
 `endif // SynTranlateOn

`endif
`endif

endmodule

// lintra pop
