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
//  Module sbcasyncfifo : 
//
//------------------------------------------------------------------------------

// lintra push -60024b, -60024a, -70036_simple, -70044_simple

module hqm_sbcasyncfifo_egr
#(
  parameter ASYNCQDEPTH    = 2,
  parameter SB_PARITY_REQUIRED = 0,
  parameter EGRESS_SYNC_WIDTH  = 0,
  parameter INGRESS_SYNC_WIDTH = 0,
  parameter PARITYBITS     = 0,
  parameter GRAYPTRWIDTH   = 0,  
  parameter MAXPLDBIT      = 7,
  parameter INGSYNCROUTER  = 0,
  parameter EGRSYNCROUTER  = 0,
  parameter LATCHQUEUES    = 0, // Latch based queues=1 / 0=flop based queues
  parameter RELATIVE_PLACEMENT_EN = 0, // RP methodology for efficient placement in RAMS  
  parameter USYNC_ENABLE   = 0, // set to 1 to enable deterministic clock crossing
  parameter IDLE_RST_VALUE = 1, // Reset direction for the idle signal
// PCR - Add a delay counter to the usync egress path - START
   parameter USYNC_ING_DELAY = 1,
   parameter USYNC_EGR_DELAY = 1,
   parameter SYNC_FIFO_ENABLE = 0 // by default 0 if set to 1 egress fifo instanciate in syc mode
// PCR - Add a delay counter to the usync egress path - FINISH
)(
  // Ingress side of the asychronous FIFO
  input  logic               cfg_parityckdef,// lintra s-0527, s-70036 used in parity case
  output logic               idle_count,    // lintra s-70036
  input  logic               		port_idle_ff,
  output logic [EGRESS_SYNC_WIDTH:0] 	usync_rptr_nprptr, // lintra s-2058, s-70044_simple
  input  logic [INGRESS_SYNC_WIDTH:0] 	usync_wptr_idle, // lintra s-0527
  input  logic [GRAYPTRWIDTH:0] 	gray_wptr,      //
  output logic [GRAYPTRWIDTH:0] 	gray_rptr,      //
  output logic [GRAYPTRWIDTH:0] 	gray_nprptr,    //
  input logic [ MAXPLDBIT+2+PARITYBITS:0] qout,

  // Egress side of the asynchronous FIFO
  input  logic               egr_side_clk,
  input  logic               gated_egr_side_clk,
  input  logic               egr_side_rst_b,
  input  logic               usync_egr,          // lintra s-0527, s-70036 "configuration dependent usage"
  input  logic               enpstall,           // lintra s-0527,"configuration dependent usage"
  input  logic               epctrdy,
  input  logic               enptrdy,
  output logic               epcirdy,
  output logic               enpirdy,
  output logic               eom,
  output logic               parity,
  output logic [MAXPLDBIT:0] data,
  output logic               opceom,           // lintra s-70036
  output logic [MAXPLDBIT:0] opcdata,          // lintra s-70036
  output logic               opcparity, // lintra s-70036 used in parity case
  output logic               parity_err_out,
  output logic               agent_idle,

  input  logic               dt_latchopen,     // lintra s-0527, s-70036
  input  logic               dt_latchclosed_b, // lintra s-0527, s-70036
  output logic        [15:0] dbgbus_out,       // lintra s-70036

  input  logic               usyncselect // lintra s-0527, s-70036 "configuration dependent usage"
);

  // lintra push -80018, -80028, -60020
  
localparam HALFDEPTH  = ASYNCQDEPTH <  2 ?  1 :
                        ASYNCQDEPTH > 32 ? 16 : ASYNCQDEPTH >> 1;

localparam FULLDEPTH  = HALFDEPTH << 1;
localparam MAXQENTRY  = FULLDEPTH - 1;

localparam MAXQPTRBIT = FULLDEPTH <=  2 ? 0 :
                        FULLDEPTH <=  4 ? 1 :
                        FULLDEPTH <=  8 ? 2 :
                        FULLDEPTH <= 16 ? 3 : 4;

localparam logic [GRAYPTRWIDTH:0] ALLONES    = {(GRAYPTRWIDTH+1){1'b1}};  // bje: rewrote this for VCS compatibility.
localparam logic [GRAYPTRWIDTH:0] FULLXORMSK = ALLONES << MAXQPTRBIT;
localparam logic [MAXQPTRBIT  :0] REFLECTMSK = ALLONES[MAXQPTRBIT:0] >> 1; // lintra s-2063
localparam logic [GRAYPTRWIDTH:0] REFLECTXOR = MAXQPTRBIT == 0 ? 2'b01 : // lintra s-2056
                                               MAXQPTRBIT == 1 ? 3'b010 : // lintra s-2056
                                               MAXQPTRBIT == 2 ? 4'b0100 : // lintra s-2056
                                               MAXQPTRBIT == 3 ? 5'b01000 : // lintra s-2056
                                                                 6'b010000;
localparam logic [MAXQPTRBIT  :0] REFLECTVAL = MAXQENTRY ==  1 ?  0 :
                                               MAXQENTRY ==  3 ?  1 :
                                               MAXQENTRY ==  5 ?  3 :
                                               MAXQENTRY ==  7 ?  2 :
                                               MAXQENTRY ==  9 ?  6 :
                                               MAXQENTRY == 11 ?  7 :
                                               MAXQENTRY == 13 ?  5 :
                                               MAXQENTRY == 15 ?  4 :
                                               MAXQENTRY == 17 ? 12 :
                                               MAXQENTRY == 19 ? 13 :
                                               MAXQENTRY == 21 ? 15 :
                                               MAXQENTRY == 23 ? 14 :
                                               MAXQENTRY == 25 ? 10 :
                                               MAXQENTRY == 27 ? 11 :
                                               MAXQENTRY == 29 ?  9 : 8;

localparam logic [INGRESS_SYNC_WIDTH:0] INGRESS_RST_VALUE = { {(GRAYPTRWIDTH+1){1'b0}} , IDLE_RST_VALUE[0] };

logic                  agent_idle_ff2;
logic                  agent_idle_ff2_dsync;
logic                  npqempty;
logic                  npqpop;
logic                  npqpush;
logic                  outeom;
logic                  outparity;
logic                  outnpsel;
logic                  qempty;
logic                  qpop;
logic [   MAXPLDBIT:0] outdata;
logic [  MAXQPTRBIT:0] inc_nprptr;
logic [  MAXQPTRBIT:0] inc_npwptr;
logic [  MAXQPTRBIT:0] nprptr;
logic [  MAXQPTRBIT:0] npwptr;
logic [ MAXPLDBIT+1+PARITYBITS:0] npqin;
logic [ MAXPLDBIT+1+PARITYBITS:0] npqout;
logic [GRAYPTRWIDTH:0] gray_wptr_ff2;
logic [GRAYPTRWIDTH:0] gray_wptr_ff2_dsync;
logic                  parity_err_out_pre;

// function grayincrement:
// This function implements a non-standard gray coded incrementor.  It is not
// necessarily a power of 2, because the reflection point is specified which
// allows for an even count.  So the FIFO will have an even number of entries.
// The other interesting feature is that it uses the reflection point twice,
// so that every number has 2 representations.  This aliasing is used to
// uniquely identify the empty FIFO from the full FIFO.  Without aliasing, when
// the read pointer equals the write pointer, the queue is either full or empty.
// With aliasing, when the pointers are equal it can only mean that the queue
// is empty.  The full condition is detected when the upper 2 bits are different
// and all other bits are equal.

// HSD:1303906757 Xprop + Lintra fix for function calls
function automatic logic [GRAYPTRWIDTH:0] grayincrement (
  input logic [GRAYPTRWIDTH:0] graycode
);
  logic carry;
  if (( ~^graycode[GRAYPTRWIDTH:GRAYPTRWIDTH-1] ) &
      ((graycode[MAXQPTRBIT:0] & REFLECTMSK) == REFLECTVAL)) begin
    grayincrement = graycode ^ REFLECTXOR;
    carry = '0;
  end
  else begin
    carry = ^graycode;
    grayincrement[0] = graycode[0] ^ ~carry;
    for (int i=1; i<=GRAYPTRWIDTH; i++) begin
      grayincrement[i] = (graycode[i-1] & carry) ^ graycode[i];
      carry &= ~graycode[i-1];
    end
    grayincrement[GRAYPTRWIDTH] ^= carry;
  end
endfunction

// function gray2ptr :
//   This is not a standard graycode to binary conversion.  Since the
//   gray code does not (necessarily) contain a power of 2 number of
//   encodings.  The converted pointer value contains a value that is
//   used as a 1D array index for array of dimensions [MAXQPTRBIT:0].
//   The msb of the gray2ptr conversion is returned in the lsb position
//   to ensure that a sequential set of array elements are utilized.
//   The array will be accessed by increasing even elements followed by
//   decreasing odd elements.

  // lintra push -0209
// HSD:1303906757 Xprop + Lintra fix for function calls
function automatic logic [MAXQPTRBIT:0] gray2bin ( logic [GRAYPTRWIDTH:0] graycode );
  logic carry;
  gray2bin[0] = ^graycode[GRAYPTRWIDTH:GRAYPTRWIDTH-1];
  carry = '0;
  for (int i=MAXQPTRBIT-1; i>=0; i--) begin
    gray2bin[i+1] = graycode[i] ^ carry;
    carry ^= graycode[i];
  end
endfunction
  // lintra pop

// Signals that cross the clock domains

//-----------------------------------------------------------------------------
//
// Ingress side
//
//


// Conditionally the implement a universal synchronizer.
generate 
   if (|USYNC_ENABLE) begin :  i_gen_gray_rptr_nprptr_usync
      logic [EGRESS_SYNC_WIDTH:0] pre_usync;

      always_comb pre_usync = { gray_rptr , gray_nprptr };

// egress side of the universal synchronizer. ingress part in
// sbcasyncfifo_ing.sv 
	hqm_sbcusync_clk1  #(
         .DATA_RST_VALUE   ( 0                 ),
         .BUSWIDTH         ( EGRESS_SYNC_WIDTH ),
         .EGRESS_CNTR_VALUE( USYNC_ING_DELAY   )
        ) i_usync_rptr_nprptr (
	   .usyncselect(usyncselect		),
	   .clk1       		(gated_egr_side_clk	),
	   .rst1_b     		(egr_side_rst_b		),
	   .usync1     		(usync_egr		),
	   .pre_sync_data	(usync_rptr_nprptr	),
	   .d          		(pre_usync		)
	);
   end
endgenerate


//-----------------------------------------------------------------------------
//
// Egress side
//
//
//----------------------------------------------------------------
generate
    if (SYNC_FIFO_ENABLE) begin : i_gen_gray_wptr_sync_flop
        always_ff @ ( posedge gated_egr_side_clk or negedge egr_side_rst_b )
            if (!egr_side_rst_b)
                gray_wptr_ff2_dsync <=  '0;
            else          
                gray_wptr_ff2_dsync <=  gray_wptr; 
    end
    else begin : i_gen_gray_wptr_async_doubleflop
      genvar i;        
      for (i=0; i<=GRAYPTRWIDTH; i++) begin : syncwptrs
        hqm_sbc_doublesync i_syncwptr ( 
         .d     ( gray_wptr[i]              ),
         .clr_b ( egr_side_rst_b            ),
         .clk   ( gated_egr_side_clk        ),
         .q     ( gray_wptr_ff2_dsync[i]    )
        );
      end
   end
endgenerate
   
   generate
   if( |IDLE_RST_VALUE ) begin : i_gen_agent_idle_sync_set
      hqm_sbc_doublesync_set i_sbc_doublesync_set_port_idle_ff ( 
        .d     ( port_idle_ff         ),
        .set_b ( egr_side_rst_b       ),
        .clk   ( egr_side_clk         ),
        .q     ( agent_idle_ff2_dsync )
      );
   end else begin : i_gen_agent_idle_sync_rst
      hqm_sbc_doublesync i_sbc_doublesync_port_idle_ff ( 
        .d     ( port_idle_ff         ),
        .clr_b ( egr_side_rst_b       ),
        .clk   ( egr_side_clk         ),
        .q     ( agent_idle_ff2_dsync )
      );
   end

   if (|USYNC_ENABLE) begin :  i_gen_agent_wptr_idle_usync
      logic [INGRESS_SYNC_WIDTH:0] post_usync;


	hqm_sbcusync_clk2  #(
         .DATA_RST_VALUE   ( INGRESS_RST_VALUE 	),
         .BUSWIDTH         ( INGRESS_SYNC_WIDTH ),
         .EGRESS_CNTR_VALUE( USYNC_EGR_DELAY   	)
        ) i_sbcusync_wptr_idle (
	   .usyncselect		(usyncselect		),
	   .clk2       		(gated_egr_side_clk	),
	   .rst2_b     		(egr_side_rst_b		),
	   .usync2     		(usync_egr		),
	   .pre_sync_data 	(usync_wptr_idle	),
	   .q          		(post_usync		)
	);


      always_comb begin
         if( usyncselect ) begin
            agent_idle_ff2 = post_usync[                   0];
            gray_wptr_ff2  = post_usync[INGRESS_SYNC_WIDTH:1];
         end else begin
            agent_idle_ff2 = agent_idle_ff2_dsync;
            gray_wptr_ff2  = gray_wptr_ff2_dsync;
         end
      end
   end
   else begin : i_gen_agent_idle_no_usync
      assign agent_idle_ff2 = agent_idle_ff2_dsync;
      assign gray_wptr_ff2  = gray_wptr_ff2_dsync;
   end
endgenerate

// Gray code to binary code conversion of the read pointer
//always_comb bin_rptr = gray2bin( gray_rptr ); 

// Reads of the FIFO
always_comb {outnpsel,outeom,outparity,outdata} = qout & {MAXPLDBIT+3+PARITYBITS{~qempty}};

always_comb qempty = (gray_rptr == gray_wptr_ff2);

// Update the gray coded pointers
always_ff @(posedge gated_egr_side_clk or negedge egr_side_rst_b)
  if (~egr_side_rst_b) begin
    gray_rptr   <= '0;
    gray_nprptr <= '0;
  end else begin
    if (qpop             ) gray_rptr   <= grayincrement( gray_rptr   );
    if (enpirdy & enptrdy) gray_nprptr <= grayincrement( gray_nprptr );
  end


// NP FIFO to allow posted/completions to pass

// Queue management
always_comb inc_npwptr = (npwptr == MAXQENTRY) ? '0 : ( npwptr + 1 ); // lintra s-0393 s-0396
always_comb inc_nprptr = (nprptr == MAXQENTRY) ? '0 : ( nprptr + 1 ); // lintra s-0393 s-0396
always_comb npqpop     = enpirdy & enptrdy & ~npqempty;
always_comb npqpush    = ~qempty & outnpsel & (~npqempty | ~enpirdy | ~enptrdy);
always_comb qpop       = ~qempty & (outnpsel | (epcirdy & epctrdy));

always_ff @(posedge gated_egr_side_clk or negedge egr_side_rst_b)
  if (~egr_side_rst_b) begin
    npwptr   <= '0;
    nprptr   <= '0;
    npqempty <= '1;
  end else begin
    if (npqpush) npqempty <= '0;
    else if (npqpop & (inc_nprptr == npwptr)) npqempty <= '1;
    if (npqpush) npwptr <= inc_npwptr;
    if (npqpop ) nprptr <= inc_nprptr;
  end

always_comb npqin = {outeom,outparity,outdata};

generate
if (RELATIVE_PLACEMENT_EN) begin : rp_based_impl_np

    parameter NUM_WR_PORTS_NP = 1;
    parameter NUM_RD_PORTS_NP = 1;

    logic [MAXPLDBIT+2+PARITYBITS-1:0]   vram_npq_write_data             [NUM_WR_PORTS_NP-1:0];
    logic [MAXPLDBIT+2+PARITYBITS-1:0]   vram_npq_read_data              [NUM_RD_PORTS_NP-1:0];
    logic                                vram_npq_write_enable           [NUM_WR_PORTS_NP-1:0];
    logic [MAXQPTRBIT:0]                 vram_npq_write_address          [NUM_WR_PORTS_NP-1:0];
    logic [MAXQPTRBIT:0]                 vram_npq_read_address           [NUM_RD_PORTS_NP-1:0];
//END: RPD related parameters and variables
    always_comb vram_npq_write_data[0]      = npqin;
    always_comb vram_npq_write_enable[0]    = npqpush;
    always_comb vram_npq_write_address[0]   = npwptr;
    always_comb vram_npq_read_address[0]    = nprptr;
    always_comb npqout                      = vram_npq_read_data[0];

    hqm_sb_genram_vram_spr
      #(
            .width                  ( MAXPLDBIT+2+PARITYBITS    ),
            .depth                  ( MAXQENTRY+1               ),
            .num_rd_ports           ( 1                         ),
            .num_wr_ports           ( 1                         ),
            .byte_enable_count      ( 1                         ),
            .use_preflops           ( LATCHQUEUES               ),
            .latch_based            ( LATCHQUEUES               ),
            .sync_reset_enable      ( 0                         ),
            .async_reset_enable     ( 1                         ),
            .svdump_en              ( 0                         ),
            .use_storage_data       ( 0                         )
       )
    i_vram_npq2
       (
            .vram_clock             ( gated_egr_side_clk        ),
            .sync_vram_reset_b      (                           ), // lintra s-0214
            .async_vram_reset_b     ( egr_side_rst_b            ), // lintra s-0214
            .write_data             ( vram_npq_write_data       ),
            .write_enable           ( vram_npq_write_enable     ),
            .write_byte_enable      (                           ), // lintra s-0214
            .write_address          ( vram_npq_write_address    ),
            .read_address           ( vram_npq_read_address     ),
            .dt_latchopen           ( dt_latchopen              ),
            .dt_latchclosed_b       ( dt_latchclosed_b          ),
            .read_data              ( vram_npq_read_data        ),
            .write_data_flopped     (                           ), // lintra s-0214
            .data_memory            (                           )  // lintra s-0214
        );
end else begin : non_rp_based_impl_np
  if (LATCHQUEUES==1) 
    begin : gen_latch_queue1
      
      logic [MAXQPTRBIT:0] notused;  always_comb notused = '0;
      
      //--------------------------------------------------------------------------
      //
      // VRAM2 Instantiation:  Latched based queues
      //
      //--------------------------------------------------------------------------
      hqm_sbcvram2 #(
                 .width               ( MAXPLDBIT+2+PARITYBITS        ),
                 .depth               ( MAXQENTRY+1        ),
                 .address_size        ( GRAYPTRWIDTH       ),
                 .write_enable_count  ( 1                  ),  // 1 = Number of wr enables
                 .use_ports           ( 2                  ),  // 2 = One write, read port
                 .use_preflops        ( 1                  ),  // 1 = Use pre-flops
                 .use_gated_cell      ( 3                  ),  // 3 = gb03
                 .vram_reset_enable   ( 1                  ),
                 .latch_reset_enable  ( 1                  )
    ) sbcvram2npq (
      .vram_clock          ( gated_egr_side_clk ),
      .vram_reset_b        ( egr_side_rst_b     ),
      .write_data          ( npqin              ),
      .write_enable        ( npqpush            ),
      .write_byte_enable   ( 1'b1               ),
      .write_address       ( npwptr             ),
      .read_address1       ( nprptr             ),
      .read_address2       ( notused            ),
      .dt_latchopen        ( dt_latchopen       ),
      .dt_latchclosed_b    ( dt_latchclosed_b   ),
      .dt_ramrst_b         ( 1'b1               ),
      .read_data1          ( npqout             ),
      .read_data2          (                    ), // lintra s-0214
      .write_data_flopped  (                    ), // lintra s-0214
      .data_memory         (                    )  // lintra s-0214
    );

    end 
  else
    begin : gen_flop_queue1
      
      logic [MAXQENTRY:0][MAXPLDBIT+1+PARITYBITS:0] npfifo;

      always_ff @(posedge gated_egr_side_clk or negedge egr_side_rst_b)
        if (~egr_side_rst_b) npfifo         <= '0;
        else if (npqpush) begin
           for (int entry = 0; entry <= MAXQENTRY; entry++) begin
              if (npwptr == entry) npfifo[entry] <= npqin;
           end
        end
      
      always_comb begin
         npqout = '0;
         for (int entry = 0; entry <= MAXQENTRY; entry++) begin
            if (nprptr == entry) npqout = npfifo[entry];
         end
      end
      
    end 
end
  
endgenerate

logic pcparity_err_gen_out;
logic npparity_err_gen_out;

// Interface to the egress port
// assert irdy to egress payload, only when there is no parity err from checking
logic np_valid_data, pc_valid_data; //lintra s-70036 used in parity case

always_comb np_valid_data = (EGRSYNCROUTER == 0) ? (~enpstall & (~npqempty | (~qempty & outnpsel))) : (~npqempty | (~qempty & outnpsel));
always_comb pc_valid_data = (EGRSYNCROUTER == 0) ? (~qempty & ~outnpsel & (enpstall | npqempty)) : (~qempty & ~outnpsel);

  always_comb enpirdy = (EGRSYNCROUTER == 0) ?
                           (~enpstall & (~npqempty | (~qempty & outnpsel)) & ~npparity_err_gen_out) :
                           (            (~npqempty | (~qempty & outnpsel)) & ~npparity_err_gen_out);
  always_comb epcirdy = (EGRSYNCROUTER == 0) ?
                           (~qempty & ~outnpsel & (enpstall | npqempty) & ~pcparity_err_gen_out) :
                           (~qempty & ~outnpsel & ~pcparity_err_gen_out);
  always_comb {eom, parity, data} = (~npqempty & np_valid_data) ?
                              npqout :
                              {outeom,outparity,outdata};
  always_comb {opceom, opcparity, opcdata} = {outeom, outparity, outdata};

  // Idle signal send to the clock gating ISM
  always_comb agent_idle = agent_idle_ff2 & qempty & npqempty;
  always_comb idle_count = qempty & npqempty;

generate
// reusing parity checking block 
    if (SB_PARITY_REQUIRED == 1) begin : gen_par
        logic pcparity_err_pre, pcparity_err_gen_out_pre;
        logic npparity_err_pre, npparity_err_gen_out_pre;
        
        always_comb pcparity_err_pre = (pc_valid_data) ? ^{opceom, opcparity, opcdata} & ~cfg_parityckdef : '0;
        always_comb npparity_err_pre = (np_valid_data) ? ^{eom, parity, data} & ~cfg_parityckdef : '0;

        always_comb pcparity_err_gen_out = pcparity_err_pre | pcparity_err_gen_out_pre;
        always_comb npparity_err_gen_out = npparity_err_pre | npparity_err_gen_out_pre;

        always_ff @(posedge gated_egr_side_clk or negedge egr_side_rst_b)
            if (~egr_side_rst_b) begin
                pcparity_err_gen_out_pre <= '0;
                npparity_err_gen_out_pre <= '0;
            end
            else begin
                if (pcparity_err_pre == 1) pcparity_err_gen_out_pre <= 1'b1;
                if (npparity_err_pre == 1) npparity_err_gen_out_pre <= 1'b1;
            end

        always_comb parity_err_out_pre = pcparity_err_gen_out | npparity_err_gen_out;
    end
    else begin : gen_nopar
        always_comb parity_err_out_pre = '0;
        always_comb pcparity_err_gen_out = '0;
        always_comb npparity_err_gen_out = '0;
    end
        always_ff @( posedge gated_egr_side_clk or negedge egr_side_rst_b )
            if( !egr_side_rst_b )
                parity_err_out <= '0;
            else
                parity_err_out <=  parity_err_out_pre;
endgenerate


  // Debug signals
  always_comb
    begin
      dbgbus_out = '0;
      dbgbus_out[               6] = ^gray_wptr_ff2;
      dbgbus_out[               7] = ^gray_rptr;
      dbgbus_out[            5: 0] = gray_wptr_ff2 ^ ~gray_rptr; // lintra s-0393
      dbgbus_out[              13] = npqempty;
      dbgbus_out[              14] = epcirdy;
      dbgbus_out[              15] = enpirdy;
      dbgbus_out[           12: 8] = npwptr ^ nprptr; // lintra s-0393
    end

//------------------------------------------------------------------------------
//
// SV Assertions 
//
//------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF  
`ifndef IOSF_SB_ASSERT_OFF
   `ifdef INTEL_SIMONLY
   //`ifdef INTEL_INST_ON // SynTranlateOff
  // coverage off
  
   
  async_queue_underflow: //samassert
    assert property (@(posedge egr_side_clk) disable iff (egr_side_rst_b !== 1'b1)
        qpop |-> ~qempty ) else
        $display("%0t: %m: ERROR: Sideband async queue underflow", $time);
    
  async_npqueue_underflow: //samassert
    assert property (@(posedge egr_side_clk) disable iff (egr_side_rst_b !== 1'b1)
        npqpop |-> ~npqempty ) else
        $display("%0t: %m: ERROR: Sideband async np queue underflow", $time);
  
  property gray_nprptr_prop;
    logic  [GRAYPTRWIDTH:0] past_gray_nprptr;
    @(posedge gated_egr_side_clk) disable iff ( egr_side_rst_b !== 1'b1 )  ( (enpirdy & enptrdy, past_gray_nprptr = gray_nprptr) |=> $countones(gray_nprptr) == ($countones(past_gray_nprptr) + 1) ||
                                                                                            $countones(gray_nprptr) == ($countones(past_gray_nprptr) - 1) );
  endproperty
  
  gray_nprptr_check: assert property (gray_nprptr_prop)
    else
      $display("%0t: %m: ERROR: More than one bit changed in gray_nprptr: %b -> %b", $time, $past(gray_nprptr), gray_nprptr);

  property gray_rptr_prop;
    logic [GRAYPTRWIDTH:0]  past_gray_rptr;
    @(posedge gated_egr_side_clk) disable iff ( egr_side_rst_b !== 1'b1 ) ( (qpop, past_gray_rptr = gray_rptr) |=> $countones(gray_rptr) == ($countones(past_gray_rptr) + 1) ||
                              $countones(gray_rptr) == ($countones(past_gray_rptr) - 1) );
  endproperty
  
  
  gray_rptr_check: assert property (gray_rptr_prop)
    else
      $display("%0t: %m: ERROR: More than one bit changed in gray_rptr: %b -> %b", $time, $past(gray_rptr), gray_rptr);
  
  // coverage on
   `endif // SynTranlateOn
`endif
`endif 
  
//-----------------------------------------------------------------------------
//
// SV Cover properties 
//
//-----------------------------------------------------------------------------

`ifndef IOSF_SB_EVENT_OFF
   `ifdef INTEL_SIMONLY
   //`ifdef INTEL_INST_ON // SynTranlateOff
  // coverage off

  bit _qfull_cov;
  bit _npqfull_cov;

  initial
    begin
      _qfull_cov = 0;
      _npqfull_cov = 0;
    end

 
  async_queue_went_empty: //samevent
    cover property (@(posedge egr_side_clk) disable iff (~egr_side_rst_b)
      qpop |=> qempty) 
`ifndef IOSF_SB_EVENT_VERBOSE       
      if ( 0 ) 
`endif
      $info("%0t: %m: EVENT: SB async queue went empty.", $time);
  
  async_npqueue_went_empty: //samevent
    cover property (@(posedge egr_side_clk) disable iff (~egr_side_rst_b)
      npqpop |=> npqempty) 
`ifndef IOSF_SB_EVENT_VERBOSE       
      if ( 0 ) 
`endif
      $info("%0t: %m: EVENT: SB async np queue went empty.", $time);

  async_queue_full_to_empty: //bjeevent
    cover property (@(posedge egr_side_clk) disable iff (~egr_side_rst_b)
                    qempty |-> _qfull_cov)
      begin
`ifdef IOSF_SB_EVENT_VERBOSE       
        $info("%0t: %m: EVENT: SB async queue went full then empty.", $time);
`endif
        _qfull_cov = 0;
      end 

  async_npqueue_full_to_empty: // bjeevent
    cover property (@(posedge egr_side_clk) disable iff (~egr_side_rst_b)
                    npqempty |-> _npqfull_cov)
      begin
`ifdef IOSF_SB_EVENT_VERBOSE       
        $info("%0t: %m: EVENT: SB async np queue went full then empty.", $time);
`endif
        _npqfull_cov = 0;
      end 

  pc_passed_full_np_egress: //bjeevent
    cover property (@(posedge egr_side_clk) disable iff (~egr_side_rst_b)
                    ~npqempty && (nprptr == npwptr) |-> epcirdy & epctrdy)
      begin
`ifndef IOSF_SB_EVENT_VERBOSE
        if ( 0 )
`endif
          $info("%0t: %m: EVENT: PC flit passed full NP queue in async fifo (egress side)", $time);
      end
  
 
  // coverage on
   `endif // SynTranlateOn
`endif

    // lintra pop
    
endmodule
