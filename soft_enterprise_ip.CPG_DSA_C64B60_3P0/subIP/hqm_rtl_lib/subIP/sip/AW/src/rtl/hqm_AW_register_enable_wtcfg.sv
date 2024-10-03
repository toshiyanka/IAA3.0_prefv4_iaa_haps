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
// register instance that provides a CFG connection. Use paramter WIDTH to specify the nuymber of bits and parameter RESETABLE to 
//  indicate if the register should be reset to zero on rst_n=0;
//
// reg_nxt : input to provide the register next state, should default to reg_f to allow clock gating
// reg_f : output to provide the current value of the registger state
// 
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
// 
module hqm_AW_register_enable_wtcfg
  import hqm_AW_pkg::*;
#(
  parameter WIDTH = 32
, parameter DEFAULT = {WIDTH{1'b0}}
, parameter NUM_TARGET = (WIDTH+31)/32
, parameter NUM_TARGETB2 = (NUM_TARGET==1) ? 1 : (AW_logb2(NUM_TARGET-1)+1)
, parameter RESETABLE = 1
, parameter LOCKABLE = 0
, parameter LOCKED = 0
, parameter ROC = 0
, parameter W1C = 0
, parameter WIDTH_PADDED = ( NUM_TARGET * 32 )
, parameter WIDTHB2 = ( AW_logb2 ( WIDTH -1 ) + 1 )
 ) (
  input logic clk
, input logic rst_n
, input logic rst_prep
, input logic reg_v
, input logic [( WIDTH ) -1 : 0] reg_nxt
, output logic [( WIDTH ) -1 : 0] reg_f
, input logic [( NUM_TARGET ) -1 : 0] cfg_write
, input logic [( NUM_TARGET ) -1 : 0] cfg_read
, input cfg_req_t cfg_req
, output logic [( 1 ) -1 : 0] cfg_ack
, output logic [( 1 ) -1 : 0] cfg_err
, output logic [( 32 ) -1 : 0] cfg_rdata
) ;

//------------------------------------------------------------------------------------------------------------------------------------------------
//Instances & Registers
genvar GEN0 ;
logic flr_load_disable ;
assign flr_load_disable = rst_prep ;

logic [( WIDTH ) -1 : 0] internal_f ;
logic [( WIDTH_PADDED ) -1 : 0] internal_padded_f , internal_padded_nxt_pnc ;
logic cfg_ignore_pipe_busy_nc, addr_par_nc, addr_nc, wdata_par_nc, offset_nc, target_nc, node_nc, mode_nc, user_nc;
generate
  if (RESETABLE == 0) begin: GEN0_notresetable 
    always_ff @ ( posedge clk ) begin
      internal_f <= (flr_load_disable) ? internal_f : internal_padded_nxt_pnc [WIDTH-1:0] ;
    end
  end
  if (RESETABLE == 1) begin: GEN0_resetable
    always_ff @ ( posedge clk or negedge rst_n ) begin
      if ( rst_n == 1'd0 ) begin
        internal_f <= DEFAULT ;
      end 
      else begin
        internal_f <= (flr_load_disable) ? internal_f : internal_padded_nxt_pnc [WIDTH-1:0] ;
      end
    end
  end
endgenerate
logic [( 1 ) -1 : 0] lock_f , lock_nxt ;
always_ff @ ( posedge clk or negedge rst_n ) begin
  if ( rst_n == 1'd0 ) begin
    lock_f <= 0 ;
  end
  else begin
    lock_f <= (flr_load_disable) ? lock_f : lock_nxt ;
  end
end


logic [( NUM_TARGETB2 ) -1 : 0] cfg_readb2;
logic i_hqm_AW_binenc_read_any_nc ;
hqm_AW_binenc_wrap #(
 .WIDTH (NUM_TARGET)
,.EWIDTH (NUM_TARGETB2)
) i_hqm_AW_binenc_read (
 .a ( cfg_read )  
,.enc ( cfg_readb2 )
,.any ( i_hqm_AW_binenc_read_any_nc )
);


logic [( NUM_TARGETB2 ) -1 : 0] cfg_writeb2;
logic i_hqm_AW_binenc_write_any_nc ;
hqm_AW_binenc_wrap #(
 .WIDTH (NUM_TARGET)
,.EWIDTH (NUM_TARGETB2)
) i_hqm_AW_binenc_write (
 .a ( cfg_write )  
,.enc ( cfg_writeb2 )
,.any ( i_hqm_AW_binenc_write_any_nc )
);

//------------------------------------------------------------------------------------------------------------------------------------------------
//Functional Code
logic any_cfg_write ;
logic any_cfg_read ;
always_comb begin

if ( NUM_TARGET == 1 ) begin
any_cfg_write = cfg_write ;
any_cfg_read = cfg_read ;
end
else begin
any_cfg_write = |cfg_write ;
any_cfg_read = |cfg_read ;
end

  //..............................................................................................................................................
  //default output values
  cfg_ack = ( ( any_cfg_write ) | ( any_cfg_read ) ) ;
  cfg_err = 1'd1 ;
  cfg_rdata = '0 ;
  reg_f = internal_f ;
  internal_padded_f [WIDTH-1:0] = internal_f ;

  //..............................................................................................................................................
  //default flop values
  lock_nxt = LOCKABLE ? ( lock_f | ( any_cfg_write ) ) : 1'd0 ;
  internal_padded_nxt_pnc = internal_f ;
  if (reg_v) begin
  internal_padded_nxt_pnc [WIDTH-1:0] = reg_nxt ;
  end
 
  //..............................................................................................................................................
  // CFG access
  if ( ( any_cfg_write ) & ( LOCKED == 0) & ( lock_f == 1'd0 ) )  begin
    cfg_err = 1'd0;
    if (W1C==0) begin
        internal_padded_nxt_pnc[ ( cfg_writeb2 * 32 ) +: 32 ] = cfg_req.wdata ; 
    end
    if (W1C==1) begin
        internal_padded_nxt_pnc[ ( cfg_writeb2 * 32 ) +: 32 ] = ( internal_padded_nxt_pnc[ ( cfg_writeb2 * 32 ) +: 32 ] & ~cfg_req.wdata ) ; 
    end
  end

  if ( any_cfg_read )  begin
    cfg_err = 1'd0;
    cfg_rdata = internal_padded_f [ ( cfg_readb2 * 32 ) +: 32 ] ; 
    if ( ROC ) begin
      internal_padded_nxt_pnc[ ( cfg_readb2 * 32 ) +: 32 ] = 32'b0;
    end 
  end
end


assign cfg_ignore_pipe_busy_nc = cfg_req.cfg_ignore_pipe_busy;
assign user_nc                 = |cfg_req.user;
assign addr_par_nc             = cfg_req.addr_par;
assign addr_nc                 = |cfg_req.addr;
assign wdata_par_nc            = cfg_req.wdata_par;
assign offset_nc               = |cfg_req.addr.offset;
assign target_nc               = |cfg_req.addr.target;
assign node_nc                 = |cfg_req.addr.node;
assign mode_nc                 = |cfg_req.addr.mode;


endmodule
// 
