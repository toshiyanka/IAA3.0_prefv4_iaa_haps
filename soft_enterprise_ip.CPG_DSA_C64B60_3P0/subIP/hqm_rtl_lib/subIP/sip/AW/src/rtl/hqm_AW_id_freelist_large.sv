//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
// AW_id_freelist_large
//
//wiki(Overview)
// This module is logically identical to the AW_id_freelist with the following exceptions:
// - it is scalable to a larger number of IDs by using a RAM instead of a bit vector to store the
//   available status.
// - the number of IDs that can be pushed at once is not scalable - it is fixed at 1.
// - a "ready" output indicates if a push may be performed.  Pushes are ignored if push_ready=0; this
//   will occur when the controller needs to read a new row from the RAM.  The push_error output pulses
//   if a push is attempted with push_ready=0.
// - pops are ignores if pop_id_v=0.  The pop_error output pulses if this is attempted.
// - ports are added to interface to the (external) RAM which holds the status bits.  This allows
//   external config access, ECC etc. if desired.
// - The RAM must be initialized before any pushes or pops may be performed.  The initialize is
//   started by pulsing the start_init input.  When the initialize is complete the init_done
//   output pulses.
// - The RAM may be directly read (e.g. via config) using the cfg interface.  The read data width is
//   fixed at 32 bits.  If the RAM is wider than 32 bits, the appropriate bits of the config read address
//   are used to select a 32-bit subrange of the RAM data.  If the RAM is narrower than 32 bits the
//   read data is right-justified and padded with zeroes.  The requestor may not overlap cfg_re requests,
//   and must wait for cfg_rdata_valid after asserting cfg_re.
// - The number of entries used may be reduced in increments of 64 by the init_exclude input.  If this
//   feature is not needed the inputs must be tied to 0.  The entries which are excluded begin at
//   address 0 - the most-significant addresses are the ones in use.
//
// The RAM locations are managed by a two-level hierarchy of bit valid vectors.
// - the row valid vector maintains a bit for each RAM location (row).  If any bits in the RAM location
//   are available (1), the bit in the row vector is 1.
// - the group valid vector maintains a bit for each group of rows.  If any bits in the group of rows
//   is 1, the bit in the group vector is 1.
//
// The logic works off a "current" vector, which is a copy of one of the RAM locations.  The current
// group and current row indication which RAM location.  The current vector is managed with a standard
// AW_id_freelist.  When the current vector is exhausted, the state machine searches for an available id
// by first selecting the first (smallest index) group which has its valid bit = 1.  It then searches
// the row valid vector pointed to by that group to find the first (smallest index) row (RAM location)
// which has its valid bit = 1.  It then reads the RAM location corresponding to that row bit and
// loads it into the current vector.  This fill process requires 5 clocks.  The output of the freelist can
// be connected to a prefetch FIFO to hide these gaps in most cases, but the overall throughput can
// not be guaranteed to be any better than 1/6 clocks for popping and 1/2 clocks for pushing under
// worst-case conditions.
//
// If a push occurs and maps to the current vector, it just pushes the id into the current vector
// using the AW.  If it maps to a RAM location other than the current vector vector, it reads that
// RAM location, updates the value to set the bit for the id being pushed, and writes back to the RAM.
//

//endwiki
//
//wiki(Parameters)
// The following parameters are supported:
//
//      | *Parameter*    | *Description* |
//      | NUM_IDS        | Number of IDs being managed |
//      | RAM_DWIDTH     | Number of IDs maintained in each RAM location |
//endwiki
//-----------------------------------------------------------------------------------------------------
//wiki(Module)

module hqm_AW_id_freelist_large
       import hqm_AW_pkg::*; #(
 parameter NUM_IDS       	= 16384 ,
 parameter RAM_DWIDTH		= 64 ,
 // Not to be changed, but included here so they can be used to scale ports
 parameter ID_WIDTH		= (AW_logb2(NUM_IDS-1)+1) ,				// Number of bits to represent the full ID
 parameter ID_DEPTHWIDTH	= (((2**ID_WIDTH)==NUM_IDS) ? (ID_WIDTH+1) : ID_WIDTH),	// Number of bits to represent number of IDs
 parameter BITPOS_WIDTH		= (AW_logb2(RAM_DWIDTH-1)+1) ,				// Number of bits to represent bit position within RAM word
 parameter GROUP_WIDTH		= ( ( ID_WIDTH - BITPOS_WIDTH ) / 2 ) ,
 parameter ROW_WIDTH		= ( ( ID_WIDTH & 32'h1 ) == 1 ) ? GROUP_WIDTH + 1 : GROUP_WIDTH ,
 parameter RAM_ADDR_WIDTH	= ID_WIDTH - BITPOS_WIDTH ,
 parameter CFG_RAM_ADDR_WIDTH	= ( BITPOS_WIDTH > 5 ) ? ( RAM_ADDR_WIDTH + ( BITPOS_WIDTH - 5 ) ) : RAM_ADDR_WIDTH ,
 parameter CFG_RAM_ADDR_LSBIT	= ( BITPOS_WIDTH > 5 ) ? ( BITPOS_WIDTH - 5 ) : 0
) (
// System Control Interface
input	logic				clk ,
input	logic				rst_n ,
output	logic	[31:0]			fl_status ,
output 	logic	[ID_DEPTHWIDTH-1:0]	fl_count ,

// Init interface
input	logic				start_init ,
input	logic	[RAM_ADDR_WIDTH-1:0]	init_exclude,	// Number of RAM locs to exclude from valid initialization
output	logic				init_done ,	// level

// Pop interface
input	logic				pop ,
output	logic	[ID_WIDTH-1:0]		pop_id ,
output	logic				pop_id_v ,
output	logic				pop_error ,
output	logic	[3:0]			pop_status ,

// Push interface
input	logic				push ,			
input	logic	[ID_WIDTH-1:0]		push_id ,
output	logic				push_ready ,
output	logic				push_error ,
output	logic	[3:0]			push_status ,

// Configuration RAM read interface
input	logic				cfg_re ,
input	logic	[CFG_RAM_ADDR_WIDTH-1:0]cfg_addr ,
output	logic				cfg_rdata_valid ,
output	logic	[31:0]			cfg_rdata ,


// Status RAM interface
output	logic	[RAM_ADDR_WIDTH-1:0]	flram_addr ,
output	logic	flram_re ,
output	logic	flram_we ,
output	logic	[RAM_DWIDTH-1:0]	flram_wdata ,
input	logic	[RAM_DWIDTH-1:0]	flram_rdata
);
//endwiki

//-----------------------------------------------------------------------------------------------------


localparam FLSM_READY			= 8'h01 ;
localparam FLSM_INIT			= 8'h02 ;
localparam FLSM_CFG_RD			= 8'h04 ;
localparam FLSM_PUSH_WR_RAM		= 8'h08 ;
localparam FLSM_FILL_UPD_GRP		= 8'h10 ;
localparam FLSM_FILL_NEW_GRP		= 8'h20 ;
localparam FLSM_FILL_RD_RAM		= 8'h40 ;
localparam FLSM_FILL_LOAD_VEC		= 8'h80 ;

localparam	NUM_GROUPS		= ( 1 << GROUP_WIDTH ) ;
localparam	NUM_ROWS_PER_GROUP	= ( 1 << ROW_WIDTH ) ;

`ifndef INTEL_SVA_OFF

  initial begin

   // Smaller than 2K should just use AW_id_freelist

   check_num_ids_param: assert ((NUM_IDS>=2048) && ($countones(NUM_IDS)==1)) else begin
    $display ("\nERROR: %m: Parameter NUM_IDS had an illegal value (%d).  Valid values are (2**n >=2048) !!!\n",NUM_IDS);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

   check_ram_dwidth_param: assert ((RAM_DWIDTH >=2) && ($countones(RAM_DWIDTH)==1)) else begin
    $display ("\nERROR: %m: Parameter RAM_DWIDTH had an illegal value (%d).  Valid values are (2**n >=2) !!!\n",RAM_DWIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

logic	[GROUP_WIDTH-1:0]		push_id_group ;
logic	[ROW_WIDTH-1:0]			push_id_row ;
logic	[BITPOS_WIDTH-1:0]		push_id_bitsel ;
logic	[BITPOS_WIDTH-1:0]		push_id_ls ;
logic					push_buf ;
logic	[ID_WIDTH-1:0]			push_buf_id ;
logic	[6:0]				push_buf_status ;
logic					push_error_q ;

logic					init_in_progress_q ;
logic					init_hold ;

logic					cfg_fl_re_q ;
logic	[CFG_RAM_ADDR_WIDTH-1:0]	cfg_fl_addr_q ;
logic					cfg_hold ;

logic					flsm_push_done ;
logic					flsm_push_freelist ;
logic					flsm_pop_freelist ;
logic					flsm_load_curr_vec ;
logic					flsm_load_curr_group ;
logic					flsm_load_curr_row ;
logic					flsm_reset_row_v ;
logic					flsm_load_row_v ;
logic					flsm_reset_group_v ;
logic					flsm_set_group_v ;
logic					flsm_load_upd_row_v ;
logic					flsm_init_start ;
logic					flsm_init_in_progress ;
logic					flsm_init_done ;
logic					flsm_cfg_rd_done ;
logic					flsm_init_write_valid ;
logic	[7:0]				flsm_state_next ;
logic	[7:0]				flsm_state_q ;
logic	[RAM_ADDR_WIDTH-1:0]		init_cntr_q ;
logic					initialized_q ;

logic	[GROUP_WIDTH-1:0]		curr_group_q ;
logic	[GROUP_WIDTH-1:0]		curr_group_next ;
logic	[ROW_WIDTH-1:0]			curr_row_q ;
logic	[ROW_WIDTH-1:0]			curr_row_next ;
logic	[RAM_DWIDTH-1:0]		curr_vec_q ;
logic	[RAM_DWIDTH-1:0]		curr_vec_next ;
logic	[BITPOS_WIDTH-1:0]		curr_pop_id ;
logic					curr_pop_id_v ;
logic	[ID_WIDTH-1:0]			pop_id_to_buf ;
logic					pop_id_buf_ready ;
logic					pop_buf_req ;		// Request to fill pop buffer
logic	[6:0]				pop_buf_status ;
logic					pop_error_q ;

logic	[NUM_GROUPS-1:0]		fl_group_v_q ;
logic					fl_group_v_any ;
logic	[NUM_ROWS_PER_GROUP-1:0]	fl_row_v_q [0:NUM_GROUPS-1] ;
logic	[NUM_ROWS_PER_GROUP-1:0]	upd_row_v_q ;		// Intermediate result
logic	[NUM_ROWS_PER_GROUP-1:0]	fl_push_row_v ;
logic	[NUM_ROWS_PER_GROUP-1:0]	fl_curr_row_v ;
logic	[ROW_WIDTH-1:0]			fl_next_row_v ;
logic					fl_next_row_v_any ;

logic					flram_we_init ;
logic	[ID_DEPTHWIDTH-1:0]		fl_free_count_q	;

integer					i ;

//-----------------------------------------------------------------------------------------------------
// Push interface

hqm_AW_double_buffer	# ( .WIDTH ( ID_WIDTH ) ) i_AW_db_push (
	.clk				( clk ) ,
	.rst_n				( rst_n ) ,
	.status				( push_buf_status ) ,	// O

	// Input side
	.in_ready			( push_ready ) ,	// O
	.in_valid			( push ) ,		// I
	.in_data			( push_id ) ,		// I

	// Output side
	.out_ready			( flsm_push_done ) ,	// I
	.out_valid			( push_buf ) ,		// O - buffered push request
	.out_data			( push_buf_id )		// O
) ;

assign push_id_ls		= push_buf_id [BITPOS_WIDTH-1:0] ;
assign push_id_row		= push_buf_id [BITPOS_WIDTH+ROW_WIDTH-1:BITPOS_WIDTH] ;
assign push_id_group		= push_buf_id [ID_WIDTH-1:BITPOS_WIDTH+ROW_WIDTH ] ;

// AW_id_freelist assigns bits from ms position (uses lz).  Vectors are stored in RAM that way as well
assign push_id_bitsel		= ( RAM_DWIDTH - 1 ) - push_id_ls ;

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n)  begin
  push_error_q		<= 1'b0 ;
 end
 else begin
  push_error_q		<= push && ! push_ready ;
 end
end // always
assign push_error	= push_error_q ;

//-----------------------------------------------------------------------------------------------------
// Init interface
always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n)  begin
  init_in_progress_q		<= 1'b0 ;
  init_cntr_q			<= { RAM_ADDR_WIDTH { 1'b0 } } ;
  initialized_q			<= 1'b0 ;
 end
 else begin
  if ( ! init_hold ) begin
   init_in_progress_q		<= start_init ;
  end
  if ( flsm_init_start )
   init_cntr_q			<= { RAM_ADDR_WIDTH { 1'b0 } } ;
  else if ( flsm_init_in_progress )
   init_cntr_q			<= init_cntr_q + 1 ;
  if ( flsm_init_done )
   initialized_q		<= 1'b1 ;
 end
end // always

assign init_hold		= init_in_progress_q && ! flsm_init_done ;
assign init_done		= initialized_q ;

//-----------------------------------------------------------------------------------------------------
// Config read interface

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n)  begin
  cfg_fl_re_q			<= 1'b0 ;
  cfg_fl_addr_q			<= { CFG_RAM_ADDR_WIDTH { 1'b0 } } ;
 end
 else begin
  if ( ! cfg_hold ) begin
   cfg_fl_re_q			<= cfg_re ;
   cfg_fl_addr_q		<= cfg_addr ;
  end
 end
end // always

assign cfg_hold			= cfg_fl_re_q && ! flsm_cfg_rd_done ;

assign cfg_rdata_valid		= flsm_cfg_rd_done ;

generate
 if ( CFG_RAM_ADDR_LSBIT > 0 ) begin : gen_cfg_rdata
  always_comb begin
   cfg_rdata				= flram_rdata [ (cfg_fl_addr_q[(CFG_RAM_ADDR_LSBIT-1):0]*32) +: 32 ] ;
  end // always
 end
 else begin : gen_cfg_rdata					// spyglass disable W121 - label not unique
  always_comb begin
   cfg_rdata				= 32'h0 ;
   cfg_rdata [RAM_DWIDTH-1:0]		= flram_rdata ;
  end // always
 end
endgenerate

//-----------------------------------------------------------------------------------------------------
// State machine

always_comb begin
 flsm_state_next			= flsm_state_q ;
 flram_re				= 1'b0 ;
 flram_we				= 1'b0 ;
 flram_we_init				= 1'b0 ;
 flram_addr				= { curr_group_q , curr_row_q } ;
 flram_wdata				= { RAM_DWIDTH { 1'b0 } } ;
 flsm_push_done				= 1'b0 ;
 flsm_push_freelist			= 1'b0 ;
 flsm_pop_freelist			= 1'b0 ;
 flsm_load_curr_vec			= 1'b0 ;
 flsm_load_curr_group			= 1'b0 ;
 flsm_load_curr_row			= 1'b0 ;
 flsm_reset_row_v			= 1'b0 ;
 flsm_load_row_v			= 1'b0 ;
 flsm_reset_group_v			= 1'b0 ;
 flsm_set_group_v			= 1'b0 ;
 flsm_load_upd_row_v			= 1'b0 ;
 flsm_init_start			= 1'b0 ;
 flsm_init_in_progress			= 1'b0 ;
 flsm_init_done				= 1'b0 ;
 flsm_cfg_rd_done			= 1'b0 ;
 flsm_init_write_valid			= 1'b0 ;

 case ( flsm_state_q )
  FLSM_READY : begin
   if ( init_in_progress_q ) begin
    flsm_init_start			= 1'b1 ;
    flsm_state_next			= FLSM_INIT ;
   end
   else if ( cfg_fl_re_q ) begin
    flram_re				= 1'b1 ;
    flram_addr				= cfg_fl_addr_q [CFG_RAM_ADDR_WIDTH-1:CFG_RAM_ADDR_LSBIT] ;
    flsm_state_next			= FLSM_CFG_RD ;
   end
   else if ( ! initialized_q ) begin
    flsm_state_next			= FLSM_READY ;		// Stay here until init done
   end
   else begin
    if ( pop_buf_req ) begin					// curr_vec will not be empty if this is true
     flsm_pop_freelist			= 1'b1 ;
     flsm_state_next			= FLSM_READY ;		// All done in this state
    end
    else if ( push_buf && ( push_id_group == curr_group_q ) && ( push_id_row == curr_row_q ) ) begin
     flsm_push_freelist			= 1'b1 ;
     flsm_push_done			= 1'b1 ;
     flsm_state_next			= FLSM_READY ;		// All done in this state
    end
    else if ( push_buf ) begin				// Read RAM location pointed to by push id
     flram_re				= 1'b1 ;
     flram_addr				= { push_id_group , push_id_row } ;
     flsm_load_upd_row_v		= 1'b1 ;		// Read current row status of selected row
     flsm_state_next			= FLSM_PUSH_WR_RAM ;
    end
    else if ( ! curr_pop_id_v && fl_group_v_any ) begin		// Write 0 to RAM (curr_vec=0) and bit of selected row_v
								// If all group_v bits = 0 don't do fill - totally empty
     flram_we				= 1'b1 ;
     flram_addr				= { curr_group_q , curr_row_q } ;
     flram_wdata			= { RAM_DWIDTH { 1'b0 } } ;
     flsm_reset_row_v			= 1'b1 ;
     flsm_state_next			= FLSM_FILL_UPD_GRP ;
    end
   end

  end // FLSM_READY

  FLSM_INIT : begin
   flsm_init_write_valid		= ( init_cntr_q >= init_exclude ) ;
   flram_we				= 1'b1 ;
   flram_addr				= init_cntr_q ;
   flram_wdata				= { RAM_DWIDTH { flsm_init_write_valid } } ;
   flram_we_init			= 1'b1 ;
   if ( init_cntr_q == { RAM_ADDR_WIDTH { 1'b1 } } ) begin
    flsm_init_done			= 1'b1 ;
    flsm_state_next			= FLSM_READY ;
   end
   else begin
    flsm_init_in_progress		= 1'b1 ;		// Stay in this state
   end
  end // FLSM_INIT

  FLSM_PUSH_WR_RAM : begin		// Write RAM, turn valid bit on in row and group vectors
   flram_we				= 1'b1 ;
   flram_addr				= { push_id_group , push_id_row } ;
   flram_wdata				= flram_rdata | ( 1 << push_id_bitsel ) ;	// Turn on selected bit in RAM
   flsm_load_row_v			= 1'b1 ; 					// Load selected row_v with updated status
   flsm_set_group_v			= 1'b1 ;					// Set group_v bit
   flsm_push_done			= 1'b1 ;
   flsm_state_next			= FLSM_READY ;
  end // FLSM_PUSH_WR_RAM

  FLSM_FILL_UPD_GRP : begin		// Reset group_v for current row if row_v = 0 (updated previous clock)
   flsm_reset_group_v			= ! fl_next_row_v_any ;
   flsm_state_next			= FLSM_FILL_NEW_GRP ;
  end // FLSM_FILL_UPD_GRP

  FLSM_FILL_NEW_GRP : begin		// Load curr_group based on f(group_v)
   flsm_load_curr_group			= 1'b1 ;
   flsm_state_next			= FLSM_FILL_RD_RAM ;
  end // FLSM_FILL_NEW_GRP

  FLSM_FILL_RD_RAM : begin		// Pick next row based on f(row_v[curr_group]) and read that row from RAM
   flsm_load_curr_row			= 1'b1 ;
   flram_re				= 1'b1 ;
   flram_addr				= { curr_group_q , fl_next_row_v } ;
   flsm_state_next			= FLSM_FILL_LOAD_VEC ;
  end // FLSM_FILL_RD_RAM

  FLSM_FILL_LOAD_VEC : begin		// Load RAM data into curr_vec
   flsm_load_curr_vec			= 1'b1 ;
   flsm_state_next			= FLSM_READY ;
  end // FLSM_FILL_LOAD_VEC

  FLSM_CFG_RD : begin
   flsm_cfg_rd_done			= 1'b1 ;
   flsm_state_next			= FLSM_READY ;
  end // FLSM_CFG_RD

 endcase // flsm_state_q
end // always

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n)  begin
  flsm_state_q		<= FLSM_READY ;
 end
 else begin
  flsm_state_q		<= flsm_state_next ;
 end
end // always

//-----------------------------------------------------------------------------------------------------
// current state

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n)  begin
  curr_group_q		<= { GROUP_WIDTH { 1'b0 } } ;
  curr_row_q		<= { ROW_WIDTH { 1'b0 } } ;
  curr_vec_q		<= { RAM_DWIDTH { 1'b1 } } ;		// Relies on init being done before allowing requests
 end
 else begin
  if ( flsm_init_start )
   curr_group_q		<= init_exclude [RAM_ADDR_WIDTH-1:ROW_WIDTH] ;
  else if ( flsm_load_curr_group )
   curr_group_q		<= curr_group_next ;

  if ( flsm_init_start )
   curr_row_q		<= init_exclude [ROW_WIDTH-1:0] ;
  else if ( flsm_load_curr_row )
   curr_row_q		<= curr_row_next ;

  if ( flsm_load_curr_vec )
   curr_vec_q		<= flram_rdata ;
  else
   curr_vec_q		<= curr_vec_next ;
 end
end // always

hqm_AW_id_freelist_bb_core # (					// Manage the current vector
	.NUM_IDS		( RAM_DWIDTH ) ,
	.NUM_PUSHES		( 1 )
) i_AW_id_freelist_bb_core (
	.clk			( clk ) ,
	.rst_n			( rst_n ) ,
	.pop			( flsm_pop_freelist ) ,
	.pop_id_v		( curr_pop_id_v ) ,
	.pop_id			( curr_pop_id ) ,
	.push			( flsm_push_freelist ) ,
	.push_id		( push_id_ls ) ,
	.id_vector		( ) ,				// Unused
	.id_v_nxt		( curr_vec_next ) ,		// Output, default next value of external reg
	.id_v_q			( curr_vec_q )			// Actual register, maintained external to AW
) ;

//-----------------------------------------------------------------------------------------------------
// Valid vectors to track RAM state
always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n)  begin
  fl_group_v_q		<= { NUM_GROUPS { 1'b0 } } ;
  for (i=0 ; i<NUM_GROUPS ; i=i+1) begin
   fl_row_v_q [ i ]	<= { NUM_ROWS_PER_GROUP { 1'b0 } } ;
  end
  upd_row_v_q		<= { NUM_ROWS_PER_GROUP { 1'b0 } } ;
 end
 else begin
  if ( flsm_init_write_valid )
   fl_group_v_q	[ init_cntr_q [RAM_ADDR_WIDTH-1:ROW_WIDTH] ]					<= 1'b1 ;	// Group portion of init counter / RAM address
  if ( flsm_set_group_v )
   fl_group_v_q	[ push_id_group ]								<= 1'b1 ;
  if ( flsm_reset_group_v )
   fl_group_v_q	[ curr_group_q ]								<= 1'b0 ;

  if ( flsm_init_write_valid )
   fl_row_v_q [ init_cntr_q [RAM_ADDR_WIDTH-1:ROW_WIDTH] ] [ init_cntr_q [ROW_WIDTH-1:0] ]	<= 1'b1 ;	// cntr/addr[group][row]
  if ( flsm_load_row_v )
   fl_row_v_q [ push_id_group ]									<= upd_row_v_q ;
  if ( flsm_reset_row_v )
   fl_row_v_q [ curr_group_q ] [ curr_row_q ]							<= 1'b0 ;

  if ( flsm_load_upd_row_v )
   upd_row_v_q											<= fl_push_row_v | ( 1 << push_id_row ) ;
 end
end // always

assign fl_push_row_v	= fl_row_v_q [ push_id_group ] ;
assign fl_curr_row_v	= fl_row_v_q [ curr_group_q ] ;

// Find ls group bit which is set - pick that group as the next group
// If none are set, free list is empty, curr_group is then a dont-care.
hqm_AW_binenc #(
	.WIDTH				( NUM_GROUPS )
) i_group_enc (
	.a				( fl_group_v_q ) ,

	.enc				( curr_group_next ) ,
	.any				( fl_group_v_any )
) ;

// Find ls row bit from the currently-selected row vector which is set - pick that row as the next row
// If none are set, free list is empty - curr_row is a dont-care.  flsm will read 0 from RAM and load
// into curr_vec_q.
hqm_AW_binenc #(
	.WIDTH				( NUM_ROWS_PER_GROUP )
) i_row_enc (
	.a				( fl_curr_row_v ) ,

	.enc				( fl_next_row_v ) ,
	.any				( fl_next_row_v_any )
) ;

assign curr_row_next			= fl_next_row_v ;

//-----------------------------------------------------------------------------------------------------
// Pop interface

assign pop_id_to_buf			= { curr_group_q , curr_row_q , curr_pop_id } ;
assign pop_buf_req			= pop_id_buf_ready && curr_pop_id_v ;

// buffer is always kept full; not empty at eot
hqm_AW_double_buffer	# ( .WIDTH ( ID_WIDTH ) , .NOT_EMPTY_AT_EOT ( 1 ) ) i_AW_db_pop (
	.clk				( clk ) ,
	.rst_n				( rst_n ) ,
	.status				( pop_buf_status ) ,	// O

	// Input side
	.in_ready			( pop_id_buf_ready ) ,	// O
	.in_valid			( flsm_pop_freelist ) ,	// I
	.in_data			( pop_id_to_buf ) ,	// I

	// Output side
	.out_ready			( pop ) ,		// I
	.out_valid			( pop_id_v ) ,		// O
	.out_data			( pop_id )		// O
) ;

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n)  begin
  pop_error_q		<= 1'b0 ;
 end
 else begin
  pop_error_q		<= pop && ! pop_id_v ;
 end
end // always
assign pop_error	= pop_error_q ;

//-----------------------------------------------------------------------------------------------------
// State

always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n)  begin
  fl_free_count_q			<= { ID_DEPTHWIDTH { 1'b0 } } ;
 end
 else begin
  if ( flsm_init_start ) begin
   fl_free_count_q			<= { ID_DEPTHWIDTH { 1'b0 } } ;
  end
  else if ( flram_we_init && flsm_init_write_valid ) begin
   fl_free_count_q			<= fl_free_count_q + RAM_DWIDTH ;
  end
  else begin
   case ( { flsm_push_done , flsm_pop_freelist } )
    2'b01 : fl_free_count_q		<= fl_free_count_q - 1 ;
    2'b10 : fl_free_count_q		<= fl_free_count_q + 1 ;
   endcase
  end
 end
end // always

//-----------------------------------------------------------------------------------------------------
// Debug

// Include depth of prefetch buffer
assign fl_count		= fl_free_count_q + ( pop_buf_status [1:0] ) ;	// spyglass disable W164a W484 - LHS < RHS - can't exceed ID_DEPTHWIDTH

assign push_status	= push_buf_status [6:3] ;	// Events possibly of interest for smon
assign pop_status	= pop_buf_status [6:3] ;	// Events possibly of interest for smon

always_comb begin
 fl_status		= 32'h0 ;
 fl_status [7:0]	= flsm_state_q ;
 fl_status [31:16]	= {	3'h0 ,			// 31:29
				pop_buf_status [2:0] ,	// 28:26 - out_ready, depth[1:0]
				push_buf_status [2:0] ,	// 25:23 - out_ready, depth[1:0]
				initialized_q ,		// 22
				cfg_rdata_valid ,	// 21
				push_ready ,	 	// 20
				pop_id_v ,	 	// 19
				cfg_re ,	 	// 18
				push ,	  		// 17
				pop } ;			// 16

end // always

//----------------------------------------------------------------------
// Assertions

`ifndef INTEL_SVA_OFF

  check_push_ready: assert property (@(posedge clk) disable iff (rst_n != 1'b1) !(push_error)) else begin
   $display ("\nERROR: Parent module attempted push while push_ready=0 @ %.2f  !!!\n", $time ) ;
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_pop_id_v: assert property (@(posedge clk) disable iff (rst_n != 1'b1) !(pop_error)) else begin
   $display ("\nERROR: Parent module attempted pop while pop_id_v=0 @ %.2f  !!!\n", $time ) ;
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

  check_push_pop_uninit: assert property (@(posedge clk) disable iff (rst_n != 1'b1) !((push||pop) && !initialized_q)) else begin
   $display ("\nERROR: Parent module attempted push or pop before freelist initialization complete @ %.2f  !!!\n", $time ) ;
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end

`endif

endmodule // AW_id_freelist_large

