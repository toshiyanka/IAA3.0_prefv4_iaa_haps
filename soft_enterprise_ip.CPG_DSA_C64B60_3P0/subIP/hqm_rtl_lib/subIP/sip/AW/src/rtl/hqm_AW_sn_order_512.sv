//-----------------------------------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------------------------------
//
// hqm_AW_sn_order_512.sv
//
// This module supports sequence number (sn) ordering in 4 sn modes per group;
// each group has 512 sequence numbers.
//
//   Mode   #qid/group    #sn/qid   #sn/group   #slt
//    0      8             64        512         8
//    1      4             128       512         4
//    2      2             256       512         2
//    3      1             512       512         1
//
// This modules needs to suport handling three functions
//  - set of sequence number bit to be ordered
//  - signal one or more slots have clear a sequence bit when replay sequence is oldest and sent down the hcw pipe
//  - process rest_vf requests on per qid basis (logic outside of this one will look up sequence # using qid
// 
//-----------------------------------------------------------------------------------------------------
// 

module hqm_AW_sn_order_512
  import hqm_AW_pkg::* ;
( 

   input  logic               clk
 , input  logic               rst_n

 // completion request for sequence  
 , input  logic	              cmp_v
 , input  logic [8:0]         cmp_sn
 , input  logic [4:0]         cmp_slt
 , output logic               cmp_ready

 // group x sequence number ready to be replayed
 , output logic               replay_v
 , input  logic               replay_selected

 , output logic               replay_sequence_v
 , output logic [8:0]         replay_sequence
 
 // configured sn mode 
 , input  logic [2:0]         sn_mode

 // hqm_AW_rmw_mem_3pipe status 
 , output logic               rmw_mem_3pipe_status

 // ram ports
 , output logic               p2_shft_mem_write
 , output logic [4:0]         p2_shft_mem_write_addr
 , output logic [11:0]        p2_shft_mem_write_data
 , output logic               p0_shft_mem_read
 , output logic [4:0]         p0_shft_mem_read_addr
 , input  logic [11:0]        p1_shft_mem_read_data

 // residue check error on shift
 , output logic               p2_shft_data_residue_check_err


  // these are debug related ports
  ,output logic [511:0]       pipe_health_sn_state_f
  ,output logic [31:0]        pipe_health_valid
  ,output logic [31:0]        pipe_health_hold

  ,output logic               sn_state_err_any_f
) ;

typedef enum logic [1:0] {
   HQM_AW_SN_ORDER_NOOP    = 2'h0
  ,HQM_AW_SN_CMP_READ      = 2'h1
  ,HQM_AW_SN_ORDER_WRITE   = 2'h2
  ,HQM_AW_SN_SEL_RMW       = 2'h3 // this is pull and results in write back of incremented value
} cmd_t;

typedef enum logic [1:0] {
   SN_QID_64     = 3'h0
  ,SN_QID_128    = 3'h1
  ,SN_QID_256    = 3'h2
  ,SN_QID_512    = 3'h3
} sn_mode_t;

typedef struct packed {
  logic [1:0] residue;
  logic [8:0] shft;
} shft_t;

typedef struct packed {
  logic [8:0]       sn;
  logic [4:0]       slt;
  cmd_t             cmd;
  logic             shift_update;
} cmp_stg0_data_t;

typedef struct packed {
  logic [8:0]       sn;
  logic [8:0]       shift;
  logic [4:0]       slt;
  cmd_t             cmd; 
} cmp_stg1_data_t;

typedef struct packed {
  logic [511:0]    sn_bindec;
  logic [4:0]       slt;
   cmd_t            cmd; 
} cmp_stg2_data_t;

typedef struct packed {
  logic             v;
  cmp_stg0_data_t   data;
} cmp_stg0_t; 

typedef struct packed {
  logic             v;
  cmp_stg1_data_t   data;
} cmp_stg1_t; 

typedef struct packed {
  logic             v;
  cmp_stg2_data_t   data;
} cmp_stg2_t; 

typedef struct packed {
  logic             hold;
  logic             enable;
} ctl_t;

// start declarations

ctl_t                          p0_cmp_ctl;
cmp_stg0_t                     p0_cmp_nxt;
cmp_stg0_t                     p0_cmp_f;
                               
ctl_t                          p1_cmp_ctl;
cmp_stg0_t                     p1_cmp_nxt;
cmp_stg0_t                     p1_cmp_f;
                               
ctl_t                          p2_cmp_ctl; 
cmp_stg1_t                     p2_cmp_nxt;
cmp_stg1_t                     p2_cmp_f;
                               
ctl_t                          p3_cmp_ctl; 
cmp_stg2_t                     p3_cmp_nxt;
cmp_stg2_t                     p3_cmp_f;

logic                          p0_shft_v_nxt;
aw_rmwpipe_cmd_t               p0_shft_rw_nxt;
logic [4:0]                    p0_shft_addr_nxt;
shft_t                         p0_shft_write_data_nxt;
                                     
logic                          p0_shft_v_f;
aw_rmwpipe_cmd_t               p0_shft_rw_f_nc;
logic [4 : 0]                  p0_shft_addr_f_nc;
shft_t                         p0_shft_data_f_nc;
                                     
logic                          p1_shft_hold_nnc; // constant not connected (*_nnc)
logic                          p1_shft_v_f;
aw_rmwpipe_cmd_t               p1_shft_rw_f_nc;
logic [4 : 0]                  p1_shft_addr_f_nc;
shft_t                         p1_shft_data_f_nc;
                                     
logic                          p2_shft_hold_nnc; // constant not connected (*_nnc)
logic                          p2_shft_bypsel_nxt;
shft_t                         p2_shft_bypdata_nxt;
logic [10:0]                   shft_incremented_pnc; // used to detect when residue needs adjustment in wrap cases
logic                          shft_carry;
shft_t                         p2_shft_data_nxt;
                               
logic                          p2_shft_v_f;
aw_rmwpipe_cmd_t               p2_shft_rw_f_nc;
logic [4 : 0]                  p2_shft_addr_f_nc;
shft_t                         p2_shft_data_f_nc;
                                         
logic [15:0]                   sn_state_entry_f_pnc[31:0];

logic [511:0]                  sn_state_f;
logic [511:0]                  sn_state_nxt;
logic [511:0]                  sn_state_err_nxt;
logic                          sn_state_err_any_nxt;
                               
logic [511:0]                  adjusted_sn_bindec;
logic [8:0]                    adjusted_sn;
sn_mode_t                      sn_mode_f;
sn_mode_t                      sn_mode_f_copy;

logic [1:0]                    add_residue; 

logic                          slt_select_update;

logic                          replay_winner_v;
logic [4:0]                    replay_winner_slt;

logic [4:0]                    replay_winner_slt_nxt;
logic [4:0]                    replay_winner_slt_f;

logic                          replay_selected_f;

logic [511:0]                  shift_sn_data_in;
logic [511:0]                  shift_sn_data_out;

//logic [31:0]                   shift_sn_data_32_out;
logic [63:0]                   shift_sn_data_64_out;
logic [127:0]                  shift_sn_data_128_out;
logic [255:0]                  shift_sn_data_256_out;
logic [511:0]                  shift_sn_data_512_out;

logic [8:0]                    sn_shift;
logic [15:0]                   slt_state;

logic [8:0]                    shft_mask;


logic [511 : 0]                p3_cmp_f_data_sn_bindec_shifted;

logic [8:0]                    slt_base[31:0];

logic [511:0]                  pipe_health_sn_state_nxt;

// end declarations

// residue generate on cfg write
// residue checked each time ram is accessed

always_comb begin
    // 16x32=512
    sn_state_entry_f_pnc[15] = sn_state_f[(15*32) +: 32];
    sn_state_entry_f_pnc[14] = sn_state_f[(14*32) +: 32];
    sn_state_entry_f_pnc[13] = sn_state_f[(13*32) +: 32];
    sn_state_entry_f_pnc[12] = sn_state_f[(12*32) +: 32];
    sn_state_entry_f_pnc[11] = sn_state_f[(11*32) +: 32];
    sn_state_entry_f_pnc[10] = sn_state_f[(10*32) +: 32];
    sn_state_entry_f_pnc[9]  = sn_state_f[(9*32) +: 32];
    sn_state_entry_f_pnc[8]  = sn_state_f[(8*32) +: 32];
    sn_state_entry_f_pnc[7]  = sn_state_f[(7*32) +: 32];
    sn_state_entry_f_pnc[6]  = sn_state_f[(6*32) +: 32];
    sn_state_entry_f_pnc[5]  = sn_state_f[(5*32) +: 32];
    sn_state_entry_f_pnc[4]  = sn_state_f[(4*32) +: 32];
    sn_state_entry_f_pnc[3]  = sn_state_f[(3*32) +: 32];
    sn_state_entry_f_pnc[2]  = sn_state_f[(2*32) +: 32];
    sn_state_entry_f_pnc[1]  = sn_state_f[(1*32) +: 32];
    sn_state_entry_f_pnc[0]  = sn_state_f[(0*32) +: 32];
end

hqm_AW_residue_check #(
   .WIDTH  ( 9 )
) i_shift_residue_check (
   .r          ( p2_shft_data_nxt.residue )
  ,.d          ( p2_shft_data_nxt.shft )
  ,.e          ( p1_cmp_f.v )

  ,.err        ( p2_shft_data_residue_check_err ) 
);

hqm_AW_residue_add
 i_shift_residue_add (
   .a          ( p2_shft_data_nxt.residue )
  ,.b          ( 2'b01 )

  ,.r          ( add_residue) 
);

always_ff @( posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sn_mode_f <= SN_QID_64;
        sn_mode_f_copy <= SN_QID_64;
    end else begin
        sn_mode_f <= sn_mode_t'(sn_mode);
        sn_mode_f_copy <= sn_mode_t'(sn_mode);
    end
end

assign cmp_ready = !slt_select_update;

always_comb begin

    p0_cmp_ctl.enable      = '0;
    p0_cmp_nxt.data        = p0_cmp_f.data;
    p0_cmp_nxt.data.shift_update = 1'b0;

    p0_shft_v_nxt          = 1'b0;
    p0_shft_rw_nxt         = HQM_AW_RMWPIPE_NOOP;
    p0_shft_addr_nxt       = '0;
    p0_shft_write_data_nxt = '0;

  
    if ( slt_select_update ) begin // sn selected from this group; need to increment shift value

        p0_cmp_ctl.enable      = 1'b1;
        p0_cmp_nxt.data.cmd    = HQM_AW_SN_SEL_RMW;
        p0_cmp_nxt.data.slt    = replay_winner_slt_f;
                               
        p0_shft_v_nxt          = 1'b1;
        p0_shft_rw_nxt         = HQM_AW_RMWPIPE_RMW; // This is RMW; first get shift value and then increment since we pulled
        p0_shft_addr_nxt       = replay_winner_slt_f;

    end else if ( cmp_v ) begin

        p0_cmp_ctl.enable      = 1'b1;
        p0_cmp_nxt.data.cmd    = HQM_AW_SN_CMP_READ; // completion read 
        p0_cmp_nxt.data.sn     = cmp_sn;
        p0_cmp_nxt.data.slt    = cmp_slt;

        p0_shft_v_nxt          = 1'b1;
        p0_shft_rw_nxt         = HQM_AW_RMWPIPE_READ; // issue read to get the shift value
        p0_shft_addr_nxt       = cmp_slt;

    end

end

// generate the valids
always_comb begin 

     p3_cmp_ctl.hold = 0;
     p2_cmp_ctl.hold = p2_cmp_f.v & p3_cmp_ctl.hold; 
     p1_cmp_ctl.hold = p1_cmp_f.v & p2_cmp_ctl.hold;
     p0_cmp_ctl.hold = p0_cmp_f.v & p1_cmp_ctl.hold;

     p3_cmp_ctl.enable = p2_cmp_f.v & (~p3_cmp_ctl.hold | ~p3_cmp_f.v);
     p2_cmp_ctl.enable = p1_cmp_f.v & (~p2_cmp_ctl.hold | ~p2_cmp_f.v);
     p1_cmp_ctl.enable = p0_cmp_f.v & (~p1_cmp_ctl.hold | ~p1_cmp_f.v);

     p3_cmp_nxt.v = p3_cmp_ctl.enable | p3_cmp_ctl.hold;
     p2_cmp_nxt.v = p2_cmp_ctl.enable | p2_cmp_ctl.hold;
     p1_cmp_nxt.v = p1_cmp_ctl.enable | p1_cmp_ctl.hold;
     p0_cmp_nxt.v = p0_cmp_ctl.enable | p0_cmp_ctl.hold;

end

always_comb begin

     p1_cmp_nxt.data           = p1_cmp_f.data;
     p2_cmp_nxt.data           = p2_cmp_f.data;
     p3_cmp_nxt.data           = p3_cmp_f.data;
     //p3_cmp_nxt.data.sn_bindec = '0;

     p2_shft_bypsel_nxt        = 1'b0;
     p2_shft_bypdata_nxt       = '0;
     p2_shft_hold_nnc              = '0; // no hold condition
     p1_shft_hold_nnc              = '0; // no hold condition

     replay_sequence_v         = 1'b0;
     replay_sequence           = p2_shft_data_nxt.shft;

     shft_incremented_pnc          = '0;

     if ( p1_cmp_ctl.enable ) begin 
                                  p1_cmp_nxt.data = p0_cmp_f.data; 
                                  p1_cmp_nxt.data.shift_update = 1'b0;
                                  if ( slt_select_update & (replay_winner_slt_f== p0_cmp_f.data.slt) ) begin
                                   p1_cmp_nxt.data.shift_update = 1'b1;
                                  end
     end

     if ( p3_cmp_ctl.enable ) begin 
                                  p3_cmp_nxt.data.slt = p2_cmp_f.data.slt; 
                                  p3_cmp_nxt.data.sn_bindec = adjusted_sn_bindec;
                                  p3_cmp_nxt.data.cmd = p2_cmp_f.data.cmd; 
     end 

     if ( p1_cmp_f.v ) begin
      case ( p1_cmp_f.data.cmd )
        HQM_AW_SN_CMP_READ : begin 
                                   if (p2_cmp_ctl.enable) begin
                                       p2_cmp_nxt.data.shift = p2_shft_data_nxt.shft + {8'd0,p1_cmp_f.data.shift_update};
                                    if ( slt_select_update & (replay_winner_slt_f== p1_cmp_f.data.slt) ) begin
                                       p2_cmp_nxt.data.shift = p2_shft_data_nxt.shft + {8'd0,p1_cmp_f.data.shift_update} + 9'd1;
                                    end
                                       p2_cmp_nxt.data.slt   = p1_cmp_f.data.slt;
                                       p2_cmp_nxt.data.sn    = p1_cmp_f.data.sn;
                                       p2_cmp_nxt.data.cmd   = p1_cmp_f.data.cmd;
                                   end 
                               end
   HQM_AW_SN_SEL_RMW : begin 
                             p2_shft_bypsel_nxt         = 1'b1;
                             shft_incremented_pnc           = {1'b0,p2_shft_data_nxt.shft} + 10'd1;
                             p2_shft_bypdata_nxt.shft   = shft_incremented_pnc[8:0] & shft_mask;
                             p2_shft_bypdata_nxt.residue = shft_carry ? 2'b00 : add_residue; // on wrap adjust the residue
                             p2_cmp_nxt.data.cmd        = p1_cmp_f.data.cmd;

                             replay_sequence = slt_base[p1_cmp_f.data.slt] + (p2_shft_data_nxt.shft & shft_mask);
                             replay_sequence_v = 1'b1;  
                         end
               default : begin 
                             p2_shft_bypsel_nxt        = 1'b0;
                             p2_shft_bypdata_nxt       = '0;
                             p2_shft_hold_nnc              = '0;
                             p1_shft_hold_nnc              = '0;
                         end
      endcase
     end
end 



always_comb begin

    sn_shift       = '0;
    adjusted_sn = '0;

    if (p2_cmp_f.v) begin

        sn_shift = p2_cmp_f.data.shift;

        if ( slt_select_update & (replay_winner_slt_f== p2_cmp_f.data.slt) ) begin
                  sn_shift = p2_cmp_f.data.shift + 9'd1; 
        end

        case(sn_mode_f[2:0])
          SN_QID_64   : adjusted_sn = ( ( {3'd0,p2_cmp_f.data.sn[5:0]} - sn_shift ) & shft_mask ) + slt_base[p2_cmp_f.data.slt]; 
          SN_QID_128  : adjusted_sn = ( ( {2'd0,p2_cmp_f.data.sn[6:0]} - sn_shift ) & shft_mask ) + slt_base[p2_cmp_f.data.slt]; 
          SN_QID_256  : adjusted_sn = ( ( {1'd0,p2_cmp_f.data.sn[7:0]} - sn_shift ) & shft_mask ) + slt_base[p2_cmp_f.data.slt]; 
          SN_QID_512  : adjusted_sn = ( (       p2_cmp_f.data.sn[8:0]  - sn_shift ) & shft_mask ) + slt_base[p2_cmp_f.data.slt]; 
              default : adjusted_sn = ( (       p2_cmp_f.data.sn[8:0]  - sn_shift ) & shft_mask ) + slt_base[p2_cmp_f.data.slt]; 
        endcase

    end
end 

//----------------------------------------------------------------------------------------
// pipeline valids
always_ff @( posedge clk or negedge rst_n ) begin
  if (~rst_n) begin

    p0_cmp_f                <= '0;
    p1_cmp_f                <= '0;
    p2_cmp_f                <= '0;
    p3_cmp_f                <= '0;
    sn_state_f              <= '0;
    sn_state_err_any_f      <= 1'b0;
    replay_winner_slt_f     <= '0;
    replay_selected_f       <= 1'b0; 

    pipe_health_sn_state_f  <= '0;

  end
  else begin
    p0_cmp_f               <= p0_cmp_nxt;
    p1_cmp_f               <= p1_cmp_nxt;
    p2_cmp_f               <= p2_cmp_nxt;
    p3_cmp_f               <= p3_cmp_nxt;
    sn_state_f             <= sn_state_nxt;
    sn_state_err_any_f     <= sn_state_err_any_nxt;

    replay_winner_slt_f    <= replay_winner_slt_nxt;
    replay_selected_f      <= replay_selected; 

    pipe_health_sn_state_f <= pipe_health_sn_state_nxt;

  end
end // always

// Needs all these to ensure that we we only do cfg access when we are truly IDLE
assign pipe_health_valid = {1'b0, sn_shift[8:0],12'd0 ,(|slt_state) ,1'b0 ,p3_cmp_f.v      ,p2_cmp_f.v      ,p1_cmp_f.v      ,p0_cmp_f.v      ,p2_shft_v_f      ,p1_shft_v_f      ,p0_shft_v_f ,1'b0};
assign pipe_health_hold  = {              22'd0 ,1'b0         ,1'b0 ,p3_cmp_ctl.hold ,p2_cmp_ctl.hold ,p1_cmp_ctl.hold ,p0_cmp_ctl.hold ,p2_shft_hold_nnc ,p1_shft_hold_nnc ,1'b0        ,1'b0};

hqm_AW_bindec #(
      .WIDTH(9),
      .DWIDTH(512)
) i_hqm_AW_bindec (
    .a	      ( adjusted_sn )
  , .enable   ( p2_cmp_f.v )

  , .dec      ( adjusted_sn_bindec )
);

// The configured sn_mode will be used to derive base sequence value to be added togetehr with shift value to derive 9-bit sequence value
always_comb begin

    for (int i=0; i<32; i=i+1) begin : slt_base_loop
        slt_base[i] = '0;
    end

    shft_mask = '0 ;
    shft_carry = 1'b0;  // to be used for residue adjustment when shift wraps

  case(sn_mode_f_copy[2:0])
     SN_QID_64 : begin 
                     shft_mask = 9'h01f;
                     shft_carry = shft_incremented_pnc[5];
                     slt_state = {8'd0
                                  ,sn_state_entry_f_pnc[14][0 +: 1]
                                  ,sn_state_entry_f_pnc[12][0 +: 1]
                                  ,sn_state_entry_f_pnc[10][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 8][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 6][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 4][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 2][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 0][0 +: 1]
                               };

                     slt_base[0] =  9'b000000000; 
                     slt_base[1] =  9'b001000000; 
                     slt_base[2] =  9'b010000000; 
                     slt_base[3] =  9'b011000000; 
                     slt_base[4] =  9'b100000000; 
                     slt_base[5] =  9'b101000000; 
                     slt_base[6] =  9'b110000000; 
                     slt_base[7] =  9'b111000000; 
                 end
     SN_QID_128: begin 
                     shft_mask = 9'h03f;
                     shft_carry = shft_incremented_pnc[6];
                     slt_state = {12'd0
                                  ,sn_state_entry_f_pnc[12][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 8][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 4][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 0][0 +: 1]
                               };

                        slt_base[0] =  9'b000000000; 
                        slt_base[1] =  9'b010000000; 
                        slt_base[2] =  9'b100000000; 
                        slt_base[3] =  9'b110000000; 
                  end
     SN_QID_256 : begin 
                     
                      shft_mask = 9'h07f;
                      shft_carry = shft_incremented_pnc[7];

                      slt_state = {14'd0 
                                   ,sn_state_entry_f_pnc[ 8][0 +: 1]
                                   ,sn_state_entry_f_pnc[ 0][0 +: 1]
                                  };

                      slt_base[0] =  9'b000000000; 
                      slt_base[1] =  9'b100000000; 
                  end
     SN_QID_512 : begin 

                      shft_mask = 9'h0ff;
                      shft_carry = shft_incremented_pnc[8];

                      slt_state = {15'd0
                                   ,sn_state_entry_f_pnc[ 0][0 +: 1]
                                  };

                      slt_base[0] =  10'b0000000000; 
                  end
        default : begin 
                     shft_mask = 9'h01f;
                     shft_carry = shft_incremented_pnc[5];
                     slt_state = {8'd0
                                  ,sn_state_entry_f_pnc[14][0 +: 1]
                                  ,sn_state_entry_f_pnc[12][0 +: 1]
                                  ,sn_state_entry_f_pnc[10][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 8][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 6][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 4][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 2][0 +: 1]
                                  ,sn_state_entry_f_pnc[ 0][0 +: 1]
                               };

                     slt_base[0] =  9'b0000000000; 
                     slt_base[1] =  9'b0010000000; 
                     slt_base[2] =  9'b0100000000; 
                     slt_base[3] =  9'b0110000000; 
                     slt_base[4] =  9'b1000000000; 
                     slt_base[5] =  9'b1010000000; 
                     slt_base[6] =  9'b1100000000; 
                     slt_base[7] =  9'b1110000000; 
                  end
  endcase
end

hqm_AW_rmw_mem_3pipe #(
   .DEPTH ( 32 )
  ,.WIDTH ( 11 )
) i_shft_pipe (
   .clk               ( clk )
  ,.rst_n             ( rst_n ) 
  ,.status            ( rmw_mem_3pipe_status    )
 
  ,.p0_v_nxt          ( p0_shft_v_nxt           ) // i_
  ,.p0_rw_nxt         ( p0_shft_rw_nxt          ) // i_   cmd
  ,.p0_addr_nxt       ( p0_shft_addr_nxt        ) // i_
  ,.p0_write_data_nxt ( p0_shft_write_data_nxt  ) // i_
                                                
  ,.p0_v_f            ( p0_shft_v_f             ) // o_
  ,.p0_rw_f           ( p0_shft_rw_f_nc         ) // o_
  ,.p0_addr_f         ( p0_shft_addr_f_nc       ) // o_
  ,.p0_data_f         ( p0_shft_data_f_nc       ) // o_
                                                
  ,.p1_hold           ( p1_shft_hold_nnc            ) // i_
  ,.p1_v_f            ( p1_shft_v_f             ) // o_
  ,.p1_rw_f           ( p1_shft_rw_f_nc         ) // o_
  ,.p1_addr_f         ( p1_shft_addr_f_nc       ) // o_
  ,.p1_data_f         ( p1_shft_data_f_nc       ) // o_
                                                
  ,.p2_hold           ( p2_shft_hold_nnc            ) // i_
  ,.p2_bypsel_nxt     ( p2_shft_bypsel_nxt      ) // i_
  ,.p2_bypdata_nxt    ( p2_shft_bypdata_nxt     ) // i_
  ,.p2_data_nxt       ( p2_shft_data_nxt        ) // o_

  ,.p2_v_f            ( p2_shft_v_f             ) // o_
  ,.p2_rw_f           ( p2_shft_rw_f_nc         ) // o_
  ,.p2_addr_f         ( p2_shft_addr_f_nc       ) // o_
  ,.p2_data_f         ( p2_shft_data_f_nc       ) // o_
                                         
  ,.mem_write         ( p2_shft_mem_write       ) // o_
  ,.mem_write_addr    ( p2_shft_mem_write_addr  ) // o_
  ,.mem_write_data    ( p2_shft_mem_write_data  ) // o_
  ,.mem_read          ( p0_shft_mem_read        ) // o_
  ,.mem_read_addr     ( p0_shft_mem_read_addr   ) // o_
  ,.mem_read_data     ( p1_shft_mem_read_data   ) // i_

);

hqm_AW_rr_arb #(
   .NUM_REQS ( 16 )
) i_slt_select (
   .clk       ( clk )
  ,.rst_n     ( rst_n )
  ,.reqs      ( slt_state )
  ,.update    ( slt_select_update )
  ,.winner_v  ( replay_winner_v )
  ,.winner    ( replay_winner_slt [3:0] )
) ;

assign replay_winner_slt [4] = 1'b0 ;

always_comb begin

   replay_winner_slt_nxt = replay_winner_slt;
   slt_select_update = replay_selected_f;

   shift_sn_data_in = sn_state_f;
   shift_sn_data_out = sn_state_f;
   sn_state_nxt = sn_state_f;
   pipe_health_sn_state_nxt = pipe_health_sn_state_f;
   sn_state_err_nxt = '0;

   case(sn_mode_f) 
      
      SN_QID_64   : begin 
                       shift_sn_data_in = {448'd0, sn_state_f[replay_winner_slt_f[2:0] * 64 +:   64]}; shift_sn_data_out[(replay_winner_slt_f[2:0] * 64) +:  64] = shift_sn_data_64_out; 
                    end
      SN_QID_128  : begin 
                       shift_sn_data_in = {384'd0, sn_state_f[replay_winner_slt_f[1:0] *128 +:  128]}; shift_sn_data_out[(replay_winner_slt_f[1:0] *128) +: 128] = shift_sn_data_128_out; 
                    end
      SN_QID_256  : begin 
                       shift_sn_data_in = {256'd0, sn_state_f[replay_winner_slt_f[0:0] *256 +:  256]}; shift_sn_data_out[(replay_winner_slt_f[0:0] *256) +: 256] = shift_sn_data_256_out; 
                    end
      SN_QID_512  : begin 
                       shift_sn_data_in =          sn_state_f;                                         shift_sn_data_out                                         = shift_sn_data_512_out; 
                    end
           default: begin 
                       shift_sn_data_in =          sn_state_f;                                     
                    end

   endcase

   if ( p3_cmp_f.v & (p3_cmp_f.data.cmd == HQM_AW_SN_CMP_READ) ) begin
       if (slt_select_update & (replay_winner_slt_f == p3_cmp_f.data.slt) ) begin
           sn_state_nxt = shift_sn_data_out | p3_cmp_f_data_sn_bindec_shifted;
           pipe_health_sn_state_nxt = sn_state_nxt; 
           sn_state_err_nxt = shift_sn_data_out & p3_cmp_f_data_sn_bindec_shifted;
       end
       else begin
           if (slt_select_update) begin
              sn_state_nxt = shift_sn_data_out | p3_cmp_f.data.sn_bindec;    
           pipe_health_sn_state_nxt = sn_state_nxt; 
              sn_state_err_nxt = shift_sn_data_out & p3_cmp_f.data.sn_bindec;    
           end
           else begin
              sn_state_nxt = sn_state_f | p3_cmp_f.data.sn_bindec;    
           pipe_health_sn_state_nxt = sn_state_nxt; 
              sn_state_err_nxt = sn_state_f & p3_cmp_f.data.sn_bindec;    
           end
       end
   end
   else begin
       if ( slt_select_update ) begin
           sn_state_nxt = shift_sn_data_out;
           pipe_health_sn_state_nxt = sn_state_nxt; 
       end
   end

   sn_state_err_any_nxt = (|sn_state_err_nxt);

end

//JG
// 6 instances of bit rotators to suppor all the rotate sizes.
//hqm_AW_rotate_bit #( .WIDTH(   32 ), .LRN( 0 ), .ARITH( 1 ), .PAD( 0 ) ) i_rotate_32   (.din( shift_sn_data_in[  31:0] ),   .rot( 5'b1 ), .dout( shift_sn_data_32_out ) ); 
//hqm_AW_rotate_bit #( .WIDTH(   64 ), .LRN( 0 ), .ARITH( 1 ), .PAD( 0 ) ) i_rotate_64   (.din( shift_sn_data_in[  63:0] ),   .rot( 6'b1 ), .dout( shift_sn_data_64_out ) ); 
//hqm_AW_rotate_bit #( .WIDTH(  128 ), .LRN( 0 ), .ARITH( 1 ), .PAD( 0 ) ) i_rotate_128  (.din( shift_sn_data_in[ 127:0] ),   .rot( 7'b1 ), .dout( shift_sn_data_128_out ) ); 
//hqm_AW_rotate_bit #( .WIDTH(  256 ), .LRN( 0 ), .ARITH( 1 ), .PAD( 0 ) ) i_rotate_256  (.din( shift_sn_data_in[ 255:0] ),   .rot( 8'b1 ), .dout( shift_sn_data_256_out ) ); 
//hqm_AW_rotate_bit #( .WIDTH(  512 ), .LRN( 0 ), .ARITH( 1 ), .PAD( 0 ) ) i_rotate_512  (.din( shift_sn_data_in[ 511:0] ),   .rot( 9'b1 ), .dout( shift_sn_data_512_out ) ); 
//hqm_AW_rotate_bit #( .WIDTH( 1024 ), .LRN( 0 ), .ARITH( 1 ), .PAD( 0 ) ) i_rotate_1024 (.din( shift_sn_data_in[1023:0] ),   .rot( 10'b1 ), .dout( shift_sn_data_1024_out ) ); 

// this shifted used to adjust completion vector if there is update
//hqm_AW_rotate_bit #( .WIDTH( 1024 ), .LRN( 0 ), .ARITH( 1 ), .PAD( 0 ) ) i_rotate_set  (.din( p3_cmp_f.data.sn_bindec),  .rot( 10'b1 ), .dout( p3_cmp_f_data_sn_bindec_shifted ) ); 

//assign shift_sn_data_32_out = { shift_sn_data_in[0] , shift_sn_data_in[31:1] } ;
assign shift_sn_data_64_out = { 1'b0 , shift_sn_data_in[63:1] } ;
assign shift_sn_data_128_out = { 1'b0 , shift_sn_data_in[127:1] } ;
assign shift_sn_data_256_out = { 1'b0 , shift_sn_data_in[255:1] } ;
assign shift_sn_data_512_out = { 1'b0 , shift_sn_data_in[511:1] } ;
assign p3_cmp_f_data_sn_bindec_shifted = { 1'b0 , p3_cmp_f.data.sn_bindec[1023:1] } ;
//JG


assign replay_v = replay_winner_v & ~replay_selected_f;

endmodule // hqm_AW_sn_order
// 
