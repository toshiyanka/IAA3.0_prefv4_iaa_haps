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
// lintra push -0305, -60024b, -60024a, -70036_simple

module hqm_sbcasyncfifoixb
#(
  parameter ASYNCQDEPTH    = 2,
  parameter SB_PARITY_REQUIRED = 0,
  parameter MAXPLDBIT      = 7,
  parameter INGSYNCROUTER  = 0,
  parameter EGRSYNCROUTER  = 0,
  parameter LATCHQUEUES    = 0, // Latch based queues=1 / 0=flop based queues
  parameter RELATIVE_PLACEMENT_EN =  0, // RP methodology for efficient placement in RAMS  
  parameter USYNC_ENABLE   = 0, // set to 1 to enable deterministic clock crossing
  parameter IDLE_RST_VALUE = 1, // Reset direction for the idle signal
// PCR - Add a delay counter to the usync egress path - START
   parameter USYNC_ING_DELAY = 1,
   parameter USYNC_EGR_DELAY = 1,
   parameter USE_PORT_DISABLE = 0,
   parameter SYNC_FIFO_ENABLE = 0 
// PCR - Add a delay counter to the usync egress path - FINISH
)(
  // Ingress side of the asychronous FIFO
  input  logic               ing_side_clk,
  input  logic               ing_side_rst_b,
  input  logic               cfg_parityckdef,// lintra s-0527, s-70036 used in parity case
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
  output logic               fifo_idle,     // lintra s-70036
  output logic               egress_req_pending, // lintra s-70036
  output logic               port_idle_ff,
  output logic               idle_count,    // lintra s-70036
                                              
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
  output logic        [15:0] dbgbus_in,        // lintra s-70036
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
localparam GRAYPTRWIDTH       = ( MAXQPTRBIT + 1 );           // Address width for FIFO + 1 for the full-empty detect bit
localparam EGRESS_SYNC_WIDTH  = ( 2 * ( GRAYPTRWIDTH ) + 1 ); // 2 Gray pointers + 1 to adjust for the 0-based value of 2 gray pointers
localparam INGRESS_SYNC_WIDTH = ( GRAYPTRWIDTH + 1);          // 1 Gray pointer + Idle indicator

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
localparam PARITYBITS = 1;

//logic			port_idle_ff;
logic [GRAYPTRWIDTH:0] gray_nprptr_np, gray_nprptr_pc;    //
logic [GRAYPTRWIDTH:0] gray_rptr_np, gray_rptr_pc;      //
logic [GRAYPTRWIDTH:0] gray_wptr_np, gray_wptr_pc;      //
logic [EGRESS_SYNC_WIDTH:0]	usync_rptr_nprptr_np, usync_rptr_nprptr_pc;
logic [INGRESS_SYNC_WIDTH:0]	usync_wptr_idle_np, usync_wptr_idle_pc;
logic [ MAXPLDBIT+2+PARITYBITS:0] qout_np, qout_pc;

logic egress_req_pending_ff;
always_comb egress_req_pending = egress_req_pending_ff;

generate
   if (USE_PORT_DISABLE==1) begin : gen_req_pending_flop
      always_ff @(posedge ing_side_clk or negedge ing_side_rst_b)
        if (~ing_side_rst_b) begin
           egress_req_pending_ff <= 1'b0;
        end else begin
           egress_req_pending_ff <= ~fifo_idle;
        end
   end else begin : gen_req_pending_def
      always_comb egress_req_pending_ff = ~fifo_idle;
   end
endgenerate

logic fifo_idle_np, fifo_idle_pc;
always_comb fifo_idle = fifo_idle_np & fifo_idle_pc;

logic parity_err_out_np, parity_err_out_pc;
always_comb parity_err_out = parity_err_out_np | parity_err_out_pc;

logic idle_count_np, idle_count_pc;
always_comb idle_count = idle_count_np & idle_count_pc;

logic agent_idle_np, agent_idle_pc;
always_comb agent_idle = agent_idle_np & agent_idle_pc;

logic port_idle_ff_np, port_idle_ff_pc;
always_comb port_idle_ff = port_idle_ff_np & port_idle_ff_pc;

//divided the async_fifo logic into two separate clock domains: sbasyncingress and sbasyncegress

      	hqm_sbcasyncfifo_ing #(
		.ASYNCQDEPTH    	( ASYNCQDEPTH		),
		.SB_PARITY_REQUIRED ( SB_PARITY_REQUIRED),
        .EGRESS_SYNC_WIDTH  ( EGRESS_SYNC_WIDTH ),
        .INGRESS_SYNC_WIDTH ( INGRESS_SYNC_WIDTH),
        .PARITYBITS         ( PARITYBITS        ),
        .GRAYPTRWIDTH       ( GRAYPTRWIDTH      ),
		.MAXPLDBIT      	( MAXPLDBIT		    ),
		.INGSYNCROUTER  	( INGSYNCROUTER		),
		.EGRSYNCROUTER  	( EGRSYNCROUTER		),
		.LATCHQUEUES    	( LATCHQUEUES		),
        .RELATIVE_PLACEMENT_EN (RELATIVE_PLACEMENT_EN),
		.USYNC_ENABLE   	( USYNC_ENABLE		),
		.USYNC_ING_DELAY	( USYNC_ING_DELAY	),
		.USYNC_EGR_DELAY	( USYNC_EGR_DELAY	),
        .SYNC_FIFO_ENABLE    ( SYNC_FIFO_ENABLE   )
	) sbcasyncingress_np (
		.ing_side_clk           ( ing_side_clk		),
		.egr_side_clk           ( egr_side_clk		),
		.ing_side_rst_b         ( ing_side_rst_b	),
		.usync_ing              ( usync_ing		),
		.port_idle              ( port_idle		),
		.pcirdy                 ( 1'b0  		),
		.npirdy                 ( npirdy		),
		.npfence                ( npfence		),
		.pceom                  ( 1'b0                  ),
		.pcparity               ( 1'b0                  ),
		.pcdata                 ( '0                    ),
		.npeom                  ( npeom			),
		.npparity               ( npparity		),
		.npdata                 ( npdata		),
		.pctrdy                 (       		),
		.nptrdy                 ( nptrdy		),
		.npstall                ( npstall		), // lintra s-0214
		.fifo_idle              ( fifo_idle_np          ),
		.port_idle_ff           ( port_idle_ff_np       ), // lintra s-0214
		.usync_rptr_nprptr	( usync_rptr_nprptr_np  ),
		.usync_wptr_idle	( usync_wptr_idle_np    ),
		.gray_wptr		( gray_wptr_np          ),
		.gray_rptr		( gray_rptr_np          ),
		.gray_nprptr		( gray_nprptr_np        ),
		.qout			( qout_np               ),
		.dt_latchopen           ( dt_latchopen		),
		.dt_latchclosed_b       ( dt_latchclosed_b	),
		.dbgbus_in              ( dbgbus_in		),
		.usyncselect            ( usyncselect		)
	);


      	hqm_sbcasyncfifo_ing #(
		.ASYNCQDEPTH    	( ASYNCQDEPTH		),
		.SB_PARITY_REQUIRED ( SB_PARITY_REQUIRED),
        .EGRESS_SYNC_WIDTH  ( EGRESS_SYNC_WIDTH ),
        .INGRESS_SYNC_WIDTH ( INGRESS_SYNC_WIDTH),
        .PARITYBITS         ( PARITYBITS        ),
        .GRAYPTRWIDTH       ( GRAYPTRWIDTH      ),
		.MAXPLDBIT      	( MAXPLDBIT		    ),
		.INGSYNCROUTER  	( INGSYNCROUTER		),
		.EGRSYNCROUTER  	( EGRSYNCROUTER		),
		.LATCHQUEUES    	( LATCHQUEUES		),
        .RELATIVE_PLACEMENT_EN (RELATIVE_PLACEMENT_EN),
		.USYNC_ENABLE   	( USYNC_ENABLE		),
		.USYNC_ING_DELAY	( USYNC_ING_DELAY	),
		.USYNC_EGR_DELAY	( USYNC_EGR_DELAY	),
        .SYNC_FIFO_ENABLE    ( SYNC_FIFO_ENABLE   )
	) sbcasyncingress_pc (
		.ing_side_clk           ( ing_side_clk		),
		.egr_side_clk           ( egr_side_clk		),
		.ing_side_rst_b         ( ing_side_rst_b	),
		.usync_ing              ( usync_ing		),
		.port_idle              ( port_idle		),
		.pcirdy                 ( pcirdy		),
		.npirdy                 ( 1'b0  		),
		.npfence                ( 1'b0   		),
		.pceom                  ( pceom			),
		.pcparity               ( pcparity		),
		.pcdata                 ( pcdata		),
		.npeom                  ( 1'b0                  ),
		.npparity               ( 1'b0                  ),
		.npdata                 ( '0                    ),
		.pctrdy                 ( pctrdy		),
		.nptrdy                 (       		),
		.npstall                (        		), // lintra s-0214
		.fifo_idle              ( fifo_idle_pc          ),
		.port_idle_ff           ( port_idle_ff_pc       ), // lintra s-0214
		.usync_rptr_nprptr	( usync_rptr_nprptr_pc  ),
		.usync_wptr_idle	( usync_wptr_idle_pc    ),
		.gray_wptr		( gray_wptr_pc          ),
		.gray_rptr		( gray_rptr_pc          ),
		.gray_nprptr		( gray_nprptr_pc        ),
		.qout			( qout_pc               ),
		.dt_latchopen           ( dt_latchopen		),
		.dt_latchclosed_b       ( dt_latchclosed_b	),
		.dbgbus_in              (          		),
		.usyncselect            ( usyncselect		)
	);


	hqm_sbcasyncfifo_egr #(
		.ASYNCQDEPTH    	( ASYNCQDEPTH		),
		.SB_PARITY_REQUIRED	( SB_PARITY_REQUIRED),
        .EGRESS_SYNC_WIDTH  ( EGRESS_SYNC_WIDTH ),
        .INGRESS_SYNC_WIDTH ( INGRESS_SYNC_WIDTH),
        .PARITYBITS         ( PARITYBITS        ),
        .GRAYPTRWIDTH       ( GRAYPTRWIDTH      ),
		.MAXPLDBIT      	( MAXPLDBIT		    ),
		.INGSYNCROUTER  	( INGSYNCROUTER		),
		.EGRSYNCROUTER  	( EGRSYNCROUTER		),
		.LATCHQUEUES    	( LATCHQUEUES		),
        .RELATIVE_PLACEMENT_EN (RELATIVE_PLACEMENT_EN),
		.USYNC_ENABLE   	( USYNC_ENABLE		),
		.USYNC_ING_DELAY	( USYNC_ING_DELAY	),
		.USYNC_EGR_DELAY	( USYNC_EGR_DELAY	),
        .SYNC_FIFO_ENABLE    ( SYNC_FIFO_ENABLE   )
	) sbcasyncegress_np (
		.cfg_parityckdef        ( cfg_parityckdef	),
		.port_idle_ff           ( port_idle_ff_np       ), // lintra s-0214
		.usync_rptr_nprptr	( usync_rptr_nprptr_np  ),
		.usync_wptr_idle	( usync_wptr_idle_np    ),
		.gray_wptr		( gray_wptr_np          ),
		.gray_rptr		( gray_rptr_np          ),
		.gray_nprptr		( gray_nprptr_np        ),
		.qout			( qout_np               ),
		.egr_side_clk           ( egr_side_clk		),
		.gated_egr_side_clk     ( gated_egr_side_clk	),
		.egr_side_rst_b         ( egr_side_rst_b	),
		.usync_egr              ( usync_egr		),
		.enpstall               ( enpstall		),
		.epctrdy                ( 1'b0   		),
		.enptrdy                ( enptrdy		),
		.epcirdy                (        		),
		.enpirdy                ( enpirdy		),
		.eom                    ( eom			),
		.parity                 ( parity		),
		.data                   ( data			),
		.opceom                 (       		),
		.opcdata                (        		),
		.opcparity              (          		),
		.parity_err_out         ( parity_err_out_np     ),
		.agent_idle             ( agent_idle_np         ),
		.idle_count             ( idle_count_np         ), // lintra s-0214
		.dt_latchopen           ( dt_latchopen		),
		.dt_latchclosed_b       ( dt_latchclosed_b	),
		.dbgbus_out             ( dbgbus_out		),
		.usyncselect            ( usyncselect		)
	);


	hqm_sbcasyncfifo_egr #(
		.ASYNCQDEPTH    	( ASYNCQDEPTH		),
		.SB_PARITY_REQUIRED	( SB_PARITY_REQUIRED),
        .EGRESS_SYNC_WIDTH  ( EGRESS_SYNC_WIDTH ),
        .INGRESS_SYNC_WIDTH ( INGRESS_SYNC_WIDTH),
        .PARITYBITS         ( PARITYBITS        ),
        .GRAYPTRWIDTH       ( GRAYPTRWIDTH      ),
		.MAXPLDBIT      	( MAXPLDBIT		    ),
		.INGSYNCROUTER  	( INGSYNCROUTER		),
		.EGRSYNCROUTER  	( EGRSYNCROUTER		),
		.LATCHQUEUES    	( LATCHQUEUES		),
        .RELATIVE_PLACEMENT_EN (RELATIVE_PLACEMENT_EN),
		.USYNC_ENABLE   	( USYNC_ENABLE		),
		.USYNC_ING_DELAY	( USYNC_ING_DELAY	),
		.USYNC_EGR_DELAY	( USYNC_EGR_DELAY	),
        .SYNC_FIFO_ENABLE    ( SYNC_FIFO_ENABLE   )
	) sbcasyncegress_pc (
		.cfg_parityckdef        ( cfg_parityckdef	),
		.port_idle_ff           ( port_idle_ff_pc       ), // lintra s-0214
		.usync_rptr_nprptr	( usync_rptr_nprptr_pc  ),
		.usync_wptr_idle	( usync_wptr_idle_pc    ),
		.gray_wptr		( gray_wptr_pc          ),
		.gray_rptr		( gray_rptr_pc          ),
		.gray_nprptr		( gray_nprptr_pc        ),
		.qout			( qout_pc               ),
		.egr_side_clk           ( egr_side_clk		),
		.gated_egr_side_clk     ( gated_egr_side_clk	),
		.egr_side_rst_b         ( egr_side_rst_b	),
		.usync_egr              ( usync_egr		),
		.enpstall               ( enpstall		),
		.epctrdy                ( epctrdy		),
		.enptrdy                ( 1'b0   		),
		.epcirdy                ( epcirdy		),
		.enpirdy                (        		),
		.eom                    (    			),
		.parity                 (                       ),
		.data                   (                       ),
		.opceom                 ( opceom		),
		.opcdata                ( opcdata		),
		.opcparity              ( opcparity		),
		.parity_err_out         ( parity_err_out_pc     ),
		.agent_idle             ( agent_idle_pc         ),
		.idle_count             ( idle_count_pc         ), // lintra s-0214
		.dt_latchopen           ( dt_latchopen		),
		.dt_latchclosed_b       ( dt_latchclosed_b	),
		.dbgbus_out             (           		),
		.usyncselect            ( usyncselect		)
	);

// lintra pop
    
endmodule
