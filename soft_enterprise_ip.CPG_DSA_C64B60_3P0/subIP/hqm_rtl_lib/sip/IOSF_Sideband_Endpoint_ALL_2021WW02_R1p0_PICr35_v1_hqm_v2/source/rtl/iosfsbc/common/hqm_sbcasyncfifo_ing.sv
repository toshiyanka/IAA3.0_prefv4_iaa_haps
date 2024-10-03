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

// 0305 : The signal ... (e.g., 'npfifo') with variable indexing is not inferred as a memory
// lintra push -0305, -60024b, -60024a, -70036_simple, -70044_simple

module hqm_sbcasyncfifo_ing
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
   parameter SYNC_FIFO_ENABLE = 0
// PCR - Add a delay counter to the usync egress path - FINISH
)(
  // Ingress side of the asychronous FIFO
  input  logic               ing_side_clk,
  input  logic               egr_side_clk,  // lintra s-0214, s-70036, s-0527 "added for CDC FIFO black box requirement"
  input  logic               ing_side_rst_b,
  input  logic               usync_ing,      // lintra s-0527, s-70036 "configuration dependent usage"
  input  logic               port_idle,
  input  logic               pcirdy,
  input  logic               npirdy,
  input  logic               npfence,        // lintra s-0527 "configuration dependent usage"
  input  logic               pceom,
  input  logic               pcparity,
  input  logic [MAXPLDBIT:0] pcdata,
  input  logic               npeom,
  input  logic               npparity,
  input  logic [MAXPLDBIT:0] npdata,
  output logic               pctrdy,
  output logic               nptrdy,
  output logic               npstall,       // lintra s-70036
  output logic               fifo_idle,
                                             

  output logic               port_idle_ff,
  input  logic [EGRESS_SYNC_WIDTH:0]	usync_rptr_nprptr, // lintra s-0527
  output logic [INGRESS_SYNC_WIDTH:0]	usync_wptr_idle, // lintra s-2058
  output logic [GRAYPTRWIDTH:0] gray_wptr,      //
  input  logic [GRAYPTRWIDTH:0] gray_rptr,      //
  input  logic [GRAYPTRWIDTH:0] gray_nprptr,    //
  output logic [ MAXPLDBIT+2+PARITYBITS:0] qout,


  input  logic               dt_latchopen,     // lintra s-0527, s-70036
  input  logic               dt_latchclosed_b, // lintra s-0527, s-70036
  output logic        [15:0] dbgbus_in,        // lintra s-70036

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

logic                  npfull;
logic                  npsel;
logic                  qfull;
logic                  qpush;
logic [  MAXQPTRBIT:0] bin_rptr;
logic [  MAXQPTRBIT:0] bin_wptr;
logic [ MAXPLDBIT+2+PARITYBITS:0] qin;
logic [GRAYPTRWIDTH:0] gray_nprptr_ff2;
logic [GRAYPTRWIDTH:0] gray_nprptr_ff2_dsync;
logic [GRAYPTRWIDTH:0] gray_npwptr;
logic [GRAYPTRWIDTH:0] gray_rptr_ff2;
logic [GRAYPTRWIDTH:0] gray_rptr_ff2_dsync;

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

always_comb bin_rptr = gray2bin( gray_rptr ); 

//----------------------------------------------------------------
// Clock domain crossing for the ingress side of the fifo.
//
// Two forms of clock crossing are supported. 
//    1) Traditional double-flop syncronizer
//    2) Deterministic clock crossing - relies on universal
//       synchronization between clocks.
//
// The universal synchronizer is only instantiated if USYNC_ENABLE 
// is non-zero. The usyncselect input selects which 
// synchronizer to use.
//----------------------------------------------------------------

generate
if (SYNC_FIFO_ENABLE) begin  :  i_gen_gray_rptr_sync_flop
    always_ff @ ( posedge ing_side_clk or negedge ing_side_rst_b) begin
      if (!ing_side_rst_b) begin
        gray_rptr_ff2_dsync <= '0;
        gray_nprptr_ff2_dsync <= '0;
      end
      else begin
        gray_rptr_ff2_dsync <= gray_rptr;
        gray_nprptr_ff2_dsync <= gray_nprptr; 
      end      
    end
end

else begin  :  i_gen_gray_rptr_usync_doubleflop
    genvar i;
    for (i=0; i<=GRAYPTRWIDTH; i++) begin : syncptrs
        hqm_sbc_doublesync i_syncrptr ( 
         .d     ( gray_rptr[i]              ),
         .clr_b ( ing_side_rst_b            ),
         .clk   ( ing_side_clk              ),
         .q     ( gray_rptr_ff2_dsync[i]    )
        );

        hqm_sbc_doublesync i_syncnprptr ( 
         .d     ( gray_nprptr[i]            ),
         .clr_b ( ing_side_rst_b            ),
         .clk   ( ing_side_clk              ),
         .q     ( gray_nprptr_ff2_dsync[i]  )
        );
    end
end
endgenerate
// Conditionally the implement a universal synchronizer
generate
   if (|USYNC_ENABLE) begin :  i_gen_gray_rptr_nprptr_usync
      logic [EGRESS_SYNC_WIDTH:0] post_usync;


	hqm_sbcusync_clk2  #(
         .DATA_RST_VALUE   ( 0	),
         .BUSWIDTH         ( EGRESS_SYNC_WIDTH ),
         .EGRESS_CNTR_VALUE( USYNC_ING_DELAY   	)
        ) i_sbcusync_rptr_nprptr (
	   .usyncselect		(usyncselect		),
	   .clk2       		(ing_side_clk	),
	   .rst2_b     		(ing_side_rst_b		),
	   .usync2     		(usync_ing		),
	   .pre_sync_data 	(usync_rptr_nprptr	),
	   .q          		(post_usync		)
	);
 

      always_comb begin
         if( usyncselect ) begin
            gray_rptr_ff2   = post_usync[EGRESS_SYNC_WIDTH:(GRAYPTRWIDTH)+1];
            gray_nprptr_ff2 = post_usync[   (GRAYPTRWIDTH):               0];
         end else begin
            gray_rptr_ff2   = gray_rptr_ff2_dsync;
            gray_nprptr_ff2 = gray_nprptr_ff2_dsync;
         end
      end
   end
   else begin : i_gen_gray_rptr_no_usync
      assign gray_rptr_ff2   = gray_rptr_ff2_dsync;
      assign gray_nprptr_ff2 = gray_nprptr_ff2_dsync;
   end

endgenerate

// Reset on data path fix - START
// Fixing Reset on Data paths to free up scan issues.
// This signal will clear out as soon as the first clock returns to the design
// this may cause a cycle of non-response to the agent if they had data waiting
// immediately out of reset. For the most part this should not be a big issue.
logic trdy_gaten;

always_ff @( posedge ing_side_clk or negedge ing_side_rst_b )
   if( ~ing_side_rst_b ) begin
      trdy_gaten <= 1'b0;
   end else if( !trdy_gaten ) begin
      trdy_gaten <= 1'b1;
   end

always_comb npsel = (INGSYNCROUTER == 0) ?
                        (npirdy & ~npfull & ~npfence) :
                        (npirdy & nptrdy);
always_comb qpush = (INGSYNCROUTER == 0) ?
                        (trdy_gaten & ~qfull & (pcirdy | npsel)) :
                        ((pcirdy & pctrdy) | (npirdy & nptrdy));

always_comb pctrdy  = (INGSYNCROUTER == 0) ? (~qfull & pcirdy & ~npsel & trdy_gaten) :
                                             (~qfull & trdy_gaten);
always_comb nptrdy  = (INGSYNCROUTER == 0) ? (~qfull & npsel & trdy_gaten) :
                                             (~qfull & ~npfull & trdy_gaten);
always_comb npstall = (INGSYNCROUTER == 0) ? (~qfull & npfull) : '0;
// Reset on data path fix - FINISH

// Update the gray coded pointers
always_ff @(posedge ing_side_clk or negedge ing_side_rst_b)
  if (~ing_side_rst_b) begin
    gray_wptr   <= '0;
    gray_npwptr <= '0;
  end else begin
    if (qpush        ) gray_wptr   <= grayincrement( gray_wptr   );
    if (qpush & npsel) gray_npwptr <= grayincrement( gray_npwptr );
  end

always_comb fifo_idle = (gray_wptr   == gray_rptr_ff2  ) &
                        (gray_npwptr == gray_nprptr_ff2);

// Full comparison - If the upper 2 bits are different and all other bits are
// equal, then the queue is full
always_comb qfull  = (gray_wptr   ^ FULLXORMSK) == gray_rptr_ff2;

always_comb npfull = (gray_npwptr ^ FULLXORMSK) == gray_nprptr_ff2;

// Gray code to binary code conversion of the write pointer
always_comb bin_wptr = gray2bin( gray_wptr ); 


// Writes into the FIFO
always_comb qin = ( (INGSYNCROUTER==0) & npsel ) ? {npsel, npeom, npparity, npdata} :
                                                   {npsel, pceom, pcparity, pcdata};
generate
if (RELATIVE_PLACEMENT_EN) begin : rp_based_impl

    parameter NUM_WR_PORTS = 1;
    parameter NUM_RD_PORTS = 1;

    logic [MAXPLDBIT+3+PARITYBITS-1:0]   vram_write_data             [NUM_WR_PORTS-1:0];
    logic [MAXPLDBIT+3+PARITYBITS-1:0]   vram_read_data              [NUM_RD_PORTS-1:0];
    logic                                vram_write_enable           [NUM_WR_PORTS-1:0];
    logic [MAXQPTRBIT:0]                 vram_write_address          [NUM_WR_PORTS-1:0];
    logic [MAXQPTRBIT:0]                 vram_read_address           [NUM_RD_PORTS-1:0];
//END: RPD related parameters and variables

    always_comb vram_write_data[0]      = qin;
    always_comb vram_write_enable[0]    = qpush;
    always_comb vram_write_address[0]   = bin_wptr;
    always_comb vram_read_address[0]    = bin_rptr;
    always_comb qout                    = vram_read_data[0];
    hqm_sb_genram_vram_spr
      #(
            .width                  ( MAXPLDBIT+3+PARITYBITS    ),
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
    i_vram2
       (
            .vram_clock             ( ing_side_clk              ),
            .sync_vram_reset_b      (                           ), // lintra s-0214
            .async_vram_reset_b     ( ing_side_rst_b            ),
            .write_data             ( vram_write_data           ),
            .write_enable           ( vram_write_enable         ),
            .write_byte_enable      (                           ), // lintra s-0214
            .write_address          ( vram_write_address        ),
            .read_address           ( vram_read_address         ),
            .dt_latchopen           ( dt_latchopen              ),
            .dt_latchclosed_b       ( dt_latchclosed_b          ),
            .read_data              ( vram_read_data            ),
            .write_data_flopped     (                           ), // lintra s-0214
            .data_memory            (                           )  // lintra s-0214
        );
end else begin : non_rp_based_impl
  if (LATCHQUEUES==1) 
    begin : gen_latch_queue0
      
      logic [MAXQPTRBIT:0] notused;
      always_comb notused = '0;
      
      //--------------------------------------------------------------------------
      //
      // VRAM2 Instantiation:  Latched based queues
      //
      //--------------------------------------------------------------------------
      hqm_sbcvram2 #( 
                  .width               ( MAXPLDBIT+3+PARITYBITS     ),
                  .depth               ( MAXQENTRY+1      ),
                  .address_size        ( GRAYPTRWIDTH     ),
                  .write_enable_count  ( 1                ),  // 1 = Number of write enables
                  .use_ports           ( 2                ),  // 2 = One write, read port
                  .use_preflops        ( 1                ),  // 1 = Use pre-flops
                  .use_gated_cell      ( 3                ),  // 3 = gb03
                  .vram_reset_enable   ( 1                ),
                  .latch_reset_enable  ( 1                )
                  ) sbcvram2q (
      .vram_clock          ( ing_side_clk     ),
      .vram_reset_b        ( ing_side_rst_b   ),
      .write_data          ( qin              ),
      .write_enable        ( qpush            ),
      .write_byte_enable   ( 1'b1             ),
      .write_address       ( bin_wptr         ),
      .read_address1       ( bin_rptr         ),
      .read_address2       ( notused          ),
      .dt_latchopen        ( dt_latchopen     ),
      .dt_latchclosed_b    ( dt_latchclosed_b ),
      .dt_ramrst_b         ( 1'b1             ),
      .read_data1          ( qout             ),
      .read_data2          (                  ), // lintra s-0214
      .write_data_flopped  (                  ), // lintra s-0214
      .data_memory         (                  )  // lintra s-0214
    );
      
    end 
  else 
    begin : gen_flop_queue0
      
      hqm_sbcfifo #( .MAXQENTRY ( MAXQENTRY ),
                 .MAXPLDBIT ( MAXPLDBIT+2+PARITYBITS ),
                 .MAXQPTRBIT ( MAXQPTRBIT ) )
      i_sbcfifo (
                 .qin ( qin ),
                 .ing_side_clk ( ing_side_clk ),
                 .egr_side_clk ( egr_side_clk ),
                 .ing_side_rst_b ( ing_side_rst_b ),
                 .qpush ( qpush ),
                 .bin_wptr ( bin_wptr ),
                 .bin_rptr ( bin_rptr ),
                 .qout ( qout )
                 );
      
    end
end

endgenerate

// Flop on port_idle prior to async crossing
always_ff @(posedge ing_side_clk or negedge ing_side_rst_b)
  if (!ing_side_rst_b)
    port_idle_ff <= IDLE_RST_VALUE[0];
  else
    port_idle_ff <= port_idle & fifo_idle;


// Debug signals
always_comb begin
  dbgbus_in = '0;
  dbgbus_in[               6] = ^gray_wptr;
  dbgbus_in[               7] = ^gray_rptr_ff2;
  dbgbus_in[             5:0] = gray_wptr ^ ~gray_rptr_ff2; // lintra s-0393
  dbgbus_in[              14] = ^gray_npwptr;
  dbgbus_in[              15] = ^gray_nprptr_ff2;
  dbgbus_in[           13: 8] = gray_npwptr ^ ~gray_nprptr_ff2; // lintra s-0393
end





generate 
   if (|USYNC_ENABLE) begin :  i_gen_agent_wptr_idle_usync
      logic [INGRESS_SYNC_WIDTH:0] pre_usync;

      always_comb pre_usync = {gray_wptr , port_idle_ff};

      hqm_sbcusync_clk1 #(
         .DATA_RST_VALUE   ( INGRESS_RST_VALUE  ),
         .BUSWIDTH         ( INGRESS_SYNC_WIDTH ),
         .EGRESS_CNTR_VALUE( USYNC_EGR_DELAY    )
      ) i_sbcusync_wptr_idle (
         .usyncselect (usyncselect),

         .clk1     	(ing_side_clk         ),
         .rst1_b   	(ing_side_rst_b       ),
         .usync1   	(usync_ing            ),
	 .pre_sync_data	(usync_wptr_idle	),
         .d        	(pre_usync            )
      );
   end
endgenerate



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
  
  async_queue_overflow: //samassert
    assert property (@(posedge ing_side_clk) disable iff (ing_side_rst_b !== 1'b1)
        qpush |-> ~qfull ) else
        $display("%0t: %m: ERROR: Sideband async queue overflow", $time);
    
  async_npqueue_overflow: //samassert
    assert property (@(posedge ing_side_clk) disable iff (ing_side_rst_b !== 1'b1)
        (qpush & npsel) |-> ~npfull ) else
        $display("%0t: %m: ERROR: Sideband async np queue overflow", $time);
    
 
  property gray_npwptr_prop;
    logic  [GRAYPTRWIDTH:0] past_gray_npwptr;
//HSD: 1306286043    
    @(posedge ing_side_clk) disable iff ( ing_side_rst_b !== 1'b1 ) ( (qpush & npsel) |=> $countones(gray_npwptr) == ($countones($past(gray_npwptr)) + 1) ||
                                                                      $countones(gray_npwptr) == ($countones($past(gray_npwptr)) - 1) );
  endproperty

  gray_npwptr_check: assert property (gray_npwptr_prop)
    else
      $display("%0t: %m: ERROR: More than one bit changed in gray_npwptr: %b -> %b", $time, $past(gray_npwptr), gray_npwptr);

  property gray_wptr_prop;
    logic  [GRAYPTRWIDTH:0] past_gray_wptr;
    @(posedge ing_side_clk) disable iff ( ing_side_rst_b !== 1'b1 ) ( (qpush, past_gray_wptr = gray_wptr) |=> $countones(gray_wptr) == ($countones(past_gray_wptr) + 1) ||
                                                                      $countones(gray_wptr) == ($countones(past_gray_wptr) - 1) );
  endproperty

  gray_wptr_check: assert property (gray_wptr_prop)
    else
      $display("%0t: %m: ERROR: More than one bit changed in gray_wptr: %b -> %b", $time, $past(gray_wptr), gray_wptr);

 
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

  async_queue_went_full: //samevent
    cover property (@(posedge ing_side_clk) disable iff (~ing_side_rst_b)
                    qpush |=> qfull) 
      begin
`ifdef IOSF_SB_EVENT_VERBOSE       
        $info("%0t: %m: EVENT: SB async queue went full.", $time);
`endif
        _qfull_cov = 1;
      end 
  
  
  async_npqueue_went_full: //samevent
    cover property (@(posedge ing_side_clk) disable iff (~ing_side_rst_b)
                    (qpush & npsel) |=> npfull)
      begin
`ifdef IOSF_SB_EVENT_VERBOSE       
        $info("%0t: %m: EVENT: SB async np queue went full.", $time);
`endif
        _npqfull_cov = 1;
      end 
 
  generate
    if (INGSYNCROUTER == 0)
      pc_passed_full_np_ingress: //bjeevent
        cover property (@(posedge ing_side_clk) disable iff (~ing_side_rst_b)
                        npstall |-> pcirdy & pctrdy)
          begin
`ifndef IOSF_SB_EVENT_VERBOSE
            if ( 0 )
`endif
              $info("%0t: %m: EVENT: PC flit passed stalled NP queue in async fifo (ingress side)", $time);
          end
  endgenerate
  
  // coverage on
   `endif // SynTranlateOn
`endif

    // lintra pop
    
endmodule
