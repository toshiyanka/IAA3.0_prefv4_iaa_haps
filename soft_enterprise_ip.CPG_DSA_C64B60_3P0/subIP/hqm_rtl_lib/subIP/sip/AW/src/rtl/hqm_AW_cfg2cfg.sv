//------------------------------------------------------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//------------------------------------------------------------------------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
//
// The following parameters are supported:
//
//      NUM_TGTS        The number of cfg interfaces.
//      TGT_MAP         Vector of NUM_TGTS values that represent the base address of each cfg interface.
//      TGT_MSK         Vector of NUM_TGTS values that represent the base address bits to match for each
//                      cfg interface.
//      ALWAYS_HITS     1 forces decode logic to pass reqs through on index zero.  0 does target match w/ the TGT_MAP before sending downstream
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_cfg2cfg
        import hqm_AW_pkg::*;
#(      
         parameter                              UNIT_ID                   = 0
        ,parameter                              NUM_TGTS                  = 1
        ,parameter [(16*NUM_TGTS)-1:0]          TGT_MAP                   = {(16*NUM_TGTS){1'b0}}
        ,parameter [(NUM_TGTS)-1:0]             ADDR_MSK_V                = {NUM_TGTS{1'b1}}
        ,parameter                              ALWAYS_HITS               = 0 
//................................................................................................................................................
        ,parameter                              ENCWIDTH        = (AW_logb2(NUM_TGTS-1)+1)
) (

        input   logic                                                clk,       
        input   logic                                                rst_n,
        input   logic                                                rst_prep,
        
        output  logic                                                cfg_idle,
 
        input   logic                                                up_cfg_req_write,
        input   logic                                                up_cfg_req_read,
        input   cfg_req_t                                            up_cfg_req,
        output  logic                                                up_cfg_rsp_ack,
        output  cfg_rsp_t                                            up_cfg_rsp,
        
        output  logic   [(NUM_TGTS)-1:0]                             down_cfg_req_write,
        output  logic   [(NUM_TGTS)-1:0]                             down_cfg_req_read,
        output  cfg_req_t                                            down_cfg_req,

        input   logic                                                down_cfg_rsp_ack,       
        input   logic   [$bits(up_cfg_rsp.err)-1:0]                  down_cfg_rsp_err,
        input   logic   [$bits(up_cfg_rsp.rdata)-1:0]                down_cfg_rsp_rdata
);
//---------------------------------------------------------------------------------------------------------------------------
//Check for invalid paramter configation
genvar GEN0 ;
generate
  if ( ~( NUM_TGTS > 0 ) ) begin : invalid_check
    for ( GEN0 = NUM_TGTS ; GEN0 <= NUM_TGTS ; GEN0 = GEN0+1 ) begin : invalid_NUM_TGTS
      INVALID_PARAM_COMBINATION i_invalid ( .invalid ( ) ) ;
    end
  end

  if ( ~( UNIT_ID <= 15 ) ) begin : invalid_check_UNIT_ID_WIDTH
    for ( GEN0 = UNIT_ID ; GEN0 <= UNIT_ID ; GEN0 = GEN0+1 ) begin : invalid_UNIT_ID_WIDTH
      INVALID_PARAM_COMBINATION i_invalid ( .invalid ( ) ) ;
    end
  end
endgenerate

//------------------------------------------------------------------------------------------------------------------------------------------------
logic                        up_cfg_req_write_f;
logic                        up_cfg_req_read_f;
logic                        up_cfg_req_write_done_f;
logic                        up_cfg_req_read_done_f;

logic     [(NUM_TGTS)-1:0]   down_cfg_req_write_f;
logic     [(NUM_TGTS)-1:0]   down_cfg_req_read_f;
cfg_req_t                    up_cfg_req_f, down_cfg_req_f;
logic     [(NUM_TGTS)-1:0]   down_cfg_req_v; 
logic                        down_cfg_rsp_v_f;    
                                
logic     [$bits(up_cfg_rsp.rdata)-1:0]       down_cfg_rsp_rdata_f;
logic     [$bits(up_cfg_rsp.err)-1:0]         down_cfg_rsp_err_f;
logic     [$bits(up_cfg_rsp.rdata)-1:0]       up_cfg_rsp_rdata_out;
logic     [$bits(up_cfg_rsp.err)-1:0]         up_cfg_rsp_err_out;
logic                                         up_cfg_rsp_rdata_par;
logic                                         up_cfg_rsp_rdy_out;
cfg_addr_t                   addr_masked;
 
logic     [NUM_TGTS-1:0]     target_decode;
logic                        target_decode_err;

logic                        cfg_req_busy_f, cfg_req_busy_nxt;
genvar     g;

//-----------------------------------------------------------------------------------------------------------------------------------------------
// Instances
localparam RDATA_WIDTH = $bits(up_cfg_rsp.rdata);
//...............................................................................................................................................
// Gen for outgoing read data
hqm_AW_parity_gen # (
  .WIDTH ( RDATA_WIDTH )
) i_hqm_AW_par_gen_rdata (
  .d     ( up_cfg_rsp_rdata_out ),
  .odd   ( 1'b1 ),
  .p     ( up_cfg_rsp_rdata_par )
) ;

//------------------------------------------------------------------------------------------------------------------------------------------------
// Register the INCOMING CFG REQUEST interface
//
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~rst_n ) begin
    up_cfg_req_write_f      <= 1'b0;
    up_cfg_req_write_done_f <= 1'b0;
    up_cfg_req_read_f       <= 1'b0;
    up_cfg_req_read_done_f  <= 1'b0;

    up_cfg_req_f            <= '0 ;
  end else begin
    up_cfg_req_write_f      <= up_cfg_req_write;
    up_cfg_req_write_done_f <= up_cfg_req_write_f;
    up_cfg_req_read_f       <= up_cfg_req_read;
    up_cfg_req_read_done_f  <= up_cfg_req_read_f;

    if ( up_cfg_req_write ) begin
    up_cfg_req_f            <= up_cfg_req;
    end else 
    if ( up_cfg_req_read ) begin
    up_cfg_req_f.cfg_ignore_pipe_busy <= up_cfg_req.cfg_ignore_pipe_busy;
    up_cfg_req_f.user                 <= up_cfg_req.user;
    up_cfg_req_f.addr_par             <= up_cfg_req.addr_par;
    up_cfg_req_f.addr                 <= up_cfg_req.addr;
    up_cfg_req_f.wdata_par            <= 1'b1;
    up_cfg_req_f.wdata                <= '0;
    end

  end
end

//------------------------------------------------------------------------------------------------------------------------------------------------
// Do the request address decode
//
generate

 if ( ALWAYS_HITS == 1 ) begin: g_always_hits

   for (g=0; g<NUM_TGTS; g=g+1) begin: g_decode
     if ( g == 0 ) begin: g_0
       assign target_decode[g]         = (up_cfg_req_write_f | up_cfg_req_read_f) ;
     end else begin: g_not_0
       assign target_decode[g]         = 1'b0 ;
     end
   end

 end else begin: g_hits

   for (g=0; g<NUM_TGTS; g=g+1) begin: g_tgtmatch_hits
    assign target_decode[g]            = (up_cfg_req_write_f | up_cfg_req_read_f) & (up_cfg_req_f.addr.target == TGT_MAP[(((g+1)*16)-1) -: 16]);
   end

 end

endgenerate


always_comb begin

  // Optional Address Masking
  //default
  addr_masked = {$bits(up_cfg_req_f.addr){1'b0}};
  for (int i=0; i<NUM_TGTS; i=i+1) begin
    if ( target_decode[i] ) begin
      if ( ADDR_MSK_V[i] & (ALWAYS_HITS == 0) ) begin
        addr_masked.node   = enum_cfg_node_id_t'(4'd0); 
        addr_masked.target = '0;
        addr_masked.offset = up_cfg_req_f.addr.offset;
      end else begin 
        addr_masked = up_cfg_req_f.addr;
      end
    end
  end
end

assign target_decode_err =  (up_cfg_req_write_f | up_cfg_req_read_f) & (~|{target_decode}); 

//------------------------------------------------------------------------------------------------------------------------------------------------
// Handle the INCOMING CFG RESPONSE interface
// Flop data when corresponding ack comes in 
// Always flop the ack signal (valid)
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~rst_n ) begin
    down_cfg_rsp_v_f     <= 1'b0;
      
    down_cfg_rsp_rdata_f <= '0 ;  
    down_cfg_rsp_err_f   <= 1'b0 ;
  end else begin
    down_cfg_rsp_v_f <= down_cfg_rsp_ack ;

    if ( down_cfg_rsp_ack) begin
      down_cfg_rsp_rdata_f  <= down_cfg_rsp_rdata;
      down_cfg_rsp_err_f    <= down_cfg_rsp_err;
    end 
  end
end

// Pass responses through to ring (upstream side)
always_comb begin
        up_cfg_rsp_rdy_out   = down_cfg_rsp_v_f ;
        up_cfg_rsp_rdata_out = down_cfg_rsp_rdata_f;
        up_cfg_rsp_err_out   = down_cfg_rsp_err_f;
end //always 

assign down_cfg_req_v = target_decode ;

always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~rst_n ) begin
    down_cfg_req_write_f <= {NUM_TGTS{1'b0}};
    down_cfg_req_read_f  <= {NUM_TGTS{1'b0}};
  end else begin 
    
    if ( up_cfg_req_write_f )  begin
      down_cfg_req_write_f <= down_cfg_req_v ;
    end 
    else if (up_cfg_req_write_done_f) begin
      down_cfg_req_write_f <= {NUM_TGTS{1'b0}} ;
    end
    else begin 
      down_cfg_req_write_f <= down_cfg_req_write_f ;
    end 

    if ( up_cfg_req_read_f ) begin 
      down_cfg_req_read_f  <= down_cfg_req_v ;
    end 
    else if (up_cfg_req_read_done_f) begin
      down_cfg_req_read_f  <= {NUM_TGTS{1'b0}} ;
    end 
    else begin 
      down_cfg_req_read_f  <= down_cfg_req_read_f ;
    end 

  end 
end 

always_ff @( posedge clk or negedge rst_n ) begin
  if (~rst_n ) begin  
    down_cfg_req_f                      <= '0 ;
  end else begin
    if ( up_cfg_req_write_f | up_cfg_req_read_f ) begin
    down_cfg_req_f.user                 <= up_cfg_req_f.user; 
    down_cfg_req_f.wdata_par            <= up_cfg_req_f.wdata_par;
    down_cfg_req_f.wdata                <= up_cfg_req_f.wdata;
    down_cfg_req_f.addr_par             <= up_cfg_req_f.addr_par;
    down_cfg_req_f.addr                 <= addr_masked;
    down_cfg_req_f.cfg_ignore_pipe_busy <= up_cfg_req_f.cfg_ignore_pipe_busy ;
    end

  end
end

//------------------------------------------------------------------------------------------------------------------------------------------------
// Idle tracking - Set on Req, clear on Rsp
always_comb begin
  cfg_req_busy_nxt = cfg_req_busy_f ;

  if ( up_cfg_req_write | up_cfg_req_read ) begin
    cfg_req_busy_nxt = 1'b1 ;
  end else
  if ( up_cfg_rsp_ack ) begin
    cfg_req_busy_nxt = 1'b0 ;
  end
end

always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~rst_n ) begin
    cfg_req_busy_f <= 1'b0 ;
  end else begin
    cfg_req_busy_f <= cfg_req_busy_nxt ;
  end 
end
//------------------------------------------------------------------------------------------------------------------------------------------------
// Drive the outputs 
//
assign cfg_idle               = ~cfg_req_busy_f ;
assign down_cfg_req_write     = (rst_prep) ? {NUM_TGTS{1'b0}} : down_cfg_req_write_f;
assign down_cfg_req_read      = (rst_prep) ? {NUM_TGTS{1'b0}} : down_cfg_req_read_f;
assign down_cfg_req           = (rst_prep) ? '0   : down_cfg_req_f;

assign up_cfg_rsp_ack         = (rst_prep) ? 1'b0 : (up_cfg_rsp_rdy_out | target_decode_err) ;
always_comb  begin

    up_cfg_rsp.uid         = enum_cfg_unit_id_t'(UNIT_ID) ;    

  if ( rst_prep ) begin 
    up_cfg_rsp.rdata       = '0 ;
    up_cfg_rsp.rdata_par   = 1'b1 ;
    up_cfg_rsp.err         = 1'b0 ;
    up_cfg_rsp.err_slv_par = 1'b0 ;
  end else begin
    up_cfg_rsp.rdata       = target_decode_err ? 32'h0 : up_cfg_rsp_rdata_out ;
    up_cfg_rsp.rdata_par   = target_decode_err ? 1'b1 : up_cfg_rsp_rdata_par ;                  
    up_cfg_rsp.err         = up_cfg_rsp_err_out | target_decode_err ; 
    up_cfg_rsp.err_slv_par = '0 ;
  end
end
//------------------------------------------------------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF
  hqm_AW_cfg2cfg_assert #(
    .NUM_TGTS (NUM_TGTS)
  )  i_hqm_AW_cfg2cfg_assert (.*) ;
`endif

endmodule // hqm_AW_cfg2cfg


`ifndef INTEL_SVA_OFF

module hqm_AW_cfg2cfg_assert import hqm_AW_pkg::*; #(
   parameter NUM_TGTS = 8
) (
   input logic clk
 , input logic rst_n
 , input logic up_cfg_req_write
 , input logic up_cfg_req_read
 , input logic up_cfg_rsp_ack
 , input logic [(NUM_TGTS-1):0] down_cfg_req_read
 , input logic [(NUM_TGTS-1):0] down_cfg_req_write
 , input logic down_cfg_rsp_ack
);

// HQMV2: SYS can generate ack on the same cycle as the req for nebulon generated registers. down_cfg_rsp_ack and down_cfg_req_read/write cannot be mixed.
`HQM_SDG_ASSERTS_AT_MOST_BITS_HIGH(ASSERTS_AT_MOST_BITS_HIGH_NORSP , { up_cfg_req_write, up_cfg_req_read, up_cfg_rsp_ack, down_cfg_req_write , down_cfg_req_read } , 1, clk, ~rst_n, `HQM_SVA_ERR_MSG("AW CFG2CFG 1: only one control bit can be valid"), SDG_SVA_SOC_SIM )

`HQM_SDG_ASSERTS_AT_MOST_BITS_HIGH(ASSERTS_AT_MOST_BITS_HIGH_NOREQ , { up_cfg_req_write, up_cfg_req_read, up_cfg_rsp_ack, down_cfg_rsp_ack } , 1, clk, ~rst_n, `HQM_SVA_ERR_MSG("AW CFG2CFG 2: only one control bit can be valid"), SDG_SVA_SOC_SIM )

endmodule // hqm_AW_cfg2cfg_assert
`endif

