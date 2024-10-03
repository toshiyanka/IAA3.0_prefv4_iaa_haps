module hqm_bcam_core
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
#(
  parameter HQM_AQED_AWIDTH = 8
, parameter HQM_AQED_DWIDTH = 26   // qid:7 + hid:16 + v:1 parity:1 spare:1
, parameter HQM_AQED_ENTRIES = 256
, parameter HQM_AQED_IWIDTH = 3
//
, parameter HQM_AQED_ENTRIESB2 = AW_logb2 ( HQM_AQED_ENTRIES - 1 ) + 1 
) (
  input   logic                                 clk
, input   logic                                 rst_n

, output  logic                                 FUNC_WEN_RF_IN_P0
, output  logic [ ( HQM_AQED_AWIDTH ) - 1 : 0 ]           FUNC_WR_ADDR_RF_IN_P0
, output  logic [ ( HQM_AQED_DWIDTH ) - 1 : 0 ]           FUNC_WR_DATA_RF_IN_P0

, output  logic                                 FUNC_CEN_RF_IN_P0
, output  logic [ ( HQM_AQED_DWIDTH ) - 1 : 0 ]           FUNC_CM_DATA_RF_IN_P0
, input   logic [ ( HQM_AQED_ENTRIES ) - 1 : 0 ]          CM_MATCH_RF_OUT_P0

, input   logic [ ( HQM_AQED_IWIDTH ) - 1 : 0 ]          bcam_inst

, input   logic                                 in_valid
, input   logic [ ( 2 ) - 1 : 0 ]                in_op
, input   logic [ ( 11 ) - 1 : 0 ]               in_fid
, input   logic [ ( 7 ) - 1 : 0 ]                in_qid
, input   logic [ ( 16 ) - 1 : 0 ]               in_hid

, output  logic                                 out_valid
, output  logic [ ( 2 ) - 1 : 0 ]                out_op
, output  logic [ ( 11 ) - 1 : 0 ]               out_fid
, output  logic [ ( 7 ) - 1 : 0 ]                out_qid
, output  logic [ ( 16 ) - 1 : 0 ]               out_hid

, output  logic                                 out_hit
, output  logic                                 out_vac

, output  logic [ ( 2 ) - 1 : 0 ]                 error

, output  logic                                 init_active
, output  logic                                 notempty 
);

//....................................................................................................
localparam HQM_AQED_P_OP_ENQ_CEN = 2'd1 ;
localparam HQM_AQED_P_OP_ENQ_WEN = 2'd2 ;
localparam HQM_AQED_P_OP_CMP_WEN = 2'd3 ;

localparam HQM_AQED_ERR_P2_LOOKUP_HIT_DOUBLE = 0 ;
localparam HQM_AQED_ERR_P2_COMPLETE_UNSET = 1 ;

//....................................................................................................
typedef struct packed {
  logic [ ( 8 ) - 1 : 0 ] fid ;
  logic [ ( 7 ) - 1 : 0 ] qid ;
  logic [ ( 16 ) - 1 : 0 ] hid ;
  logic parity ;
} data_t ;

typedef enum logic [ 1 : 0 ] {
HQM_AQED_OP_CMP_WEN = 2'd3 ,
HQM_AQED_OP_ENQ_WEN = 2'd2 ,
HQM_AQED_OP_ENQ_CEN = 2'd1 ,
ILL = 2'd0
} op_enum_t ;
typedef struct packed {
  logic v ;
  op_enum_t op ;
} ctrl_t ;

typedef struct packed {
  logic enbl ;
} pipe_t ;


logic [ ( 2 ) - 1 : 0 ] error_cond_nxt , error_cond_f ;
always_ff @( posedge clk or negedge rst_n ) begin
  if (!rst_n ) begin
    error_cond_f <= '0 ;
  end
  else begin 
    error_cond_f <= error_cond_nxt ;
  end
end




//....................................................................................................
//INITIALIZE BCAM
logic mux_FUNC_WEN_RF_IN_P0 ;
logic [ ( HQM_AQED_AWIDTH ) - 1 : 0 ] mux_FUNC_WR_ADDR_RF_IN_P0 ;
logic [ ( HQM_AQED_DWIDTH ) - 1 : 0 ] mux_FUNC_WR_DATA_RF_IN_P0 ;
logic [ ( 8 ) - 1 : 0 ] init_cnt_nxt , init_cnt_f ;
logic init_b_nxt , init_b_f ;
always_ff @( posedge clk or negedge rst_n ) begin
  if (!rst_n ) begin
    init_b_f <= '0 ; 
    init_cnt_f <= '0 ;
  end
  else begin 
    init_b_f <= init_b_nxt ;
    init_cnt_f <= init_cnt_nxt ;
  end
end
always_comb begin
  init_b_nxt = init_b_f ;
  init_cnt_nxt = init_cnt_f ;

  init_active = ( ~init_b_f ) ;

  FUNC_WEN_RF_IN_P0 = mux_FUNC_WEN_RF_IN_P0 ;
  FUNC_WR_ADDR_RF_IN_P0 = mux_FUNC_WR_ADDR_RF_IN_P0 ;
  FUNC_WR_DATA_RF_IN_P0 = mux_FUNC_WR_DATA_RF_IN_P0 ;

  if ( ~init_b_f ) begin 
    init_cnt_nxt = init_cnt_f + 8'd1 ;

//    FUNC_WEN_RF_IN_P0 = 1'b1 ;
//    FUNC_WR_ADDR_RF_IN_P0 = init_cnt_f ;
//    FUNC_WR_DATA_RF_IN_P0 = { 1'b1 , 1'b0 , 1'b0 , 16'd0 , 7'd0 } ;

    if ( init_cnt_f == 8'd255 ) begin
      init_b_nxt = 1'b1 ;
    end
  end
end
//....................................................................................................



//....................................................................................................
pipe_t p0_pipe , p1_pipe , p2_pipe ;
ctrl_t p0_ctrl_nxt , p0_ctrl_f , p1_ctrl_nxt , p1_ctrl_f , p2_ctrl_nxt , p2_ctrl_f ;
data_t p0_data_nxt , p0_data_f , p1_data_nxt , p1_data_f , p2_data_nxt , p2_data_f ;
logic [ ( HQM_AQED_ENTRIES ) - 1 : 0 ] vld_nxt , vld_f ;
logic [ ( HQM_AQED_ENTRIES ) - 1 : 0 ] hitv_nxt , hitv_f ;
logic hit_nxt , hit_f ;
logic lookup_miss ;
logic lookup_hit ;
logic [ ( 2 ) - 1 : 0 ] error_cond ;
always_ff @( posedge clk or negedge rst_n ) begin
  if (!rst_n ) begin
    p0_ctrl_f <= '0 ;
    p1_ctrl_f <= '0 ;
    p2_ctrl_f <= '0 ;
    vld_f <= '0 ;
    hitv_f <= '0 ;
    hit_f <= '0 ;

    p0_data_f <= '0 ;
    p1_data_f <= '0 ;
    p2_data_f <= '0 ;
  end
  else begin
    p0_ctrl_f <= p0_ctrl_nxt ;
    p1_ctrl_f <= p1_ctrl_nxt ;
    p2_ctrl_f <= p2_ctrl_nxt ;
    vld_f <= vld_nxt ;
    hitv_f <= hitv_nxt ;
    hit_f <= hit_nxt ;

    p0_data_f <= p0_data_nxt ;
    p1_data_f <= p1_data_nxt ;
    p2_data_f <= p2_data_nxt ;
  end
end

//....................................................................................................
logic [ ( 23 ) - 1 : 0 ] parity_gen_cam_d ;
logic  parity_gen_cam_p ;
hqm_AW_parity_gen #(
 .WIDTH ( 23 )
) i_parity_gen_cam_d (
 .d ( parity_gen_cam_d )
,.odd ( 1'b1 )
,.p ( parity_gen_cam_p )
);

logic [ ( HQM_AQED_ENTRIES ) - 1 : 0 ] binenc_vld_a ;
logic [ ( HQM_AQED_ENTRIESB2 ) - 1 : 0 ] binenc_vld_enc ;
logic binenc_vld_any_nc ;
hqm_AW_binenc #(
 .WIDTH ( HQM_AQED_ENTRIES )
) i_binenc_vld (
 .a ( binenc_vld_a )
,.enc ( binenc_vld_enc )
,.any ( binenc_vld_any_nc )
);

logic [ ( HQM_AQED_ENTRIES ) - 1 : 0 ] binenc_hitv_a ;
logic [ ( HQM_AQED_ENTRIESB2 ) - 1 : 0 ] binenc_hitv_enc ;
logic binenc_hitv_any_nc ;
hqm_AW_binenc #(
 .WIDTH ( HQM_AQED_ENTRIES )
) i_binenc_hitv (
 .a ( binenc_hitv_a )
,.enc ( binenc_hitv_enc )
,.any ( binenc_hitv_any_nc )
);

logic binenc_hitv_err_en_nxt , binenc_hitv_err_en_f , binenc_hitv_err_en_f2 ;
logic [ ( HQM_AQED_ENTRIES ) - 1 : 0 ] binenc_hitv_err_a , binenc_hitv_err_a_nxt , binenc_hitv_err_a_f , binenc_hitv_err_a_f2 , binenc_hitv_err_a_nxt2 ;
logic [ ( HQM_AQED_ENTRIESB2 ) - 1 : 0 ] binenc_hitv_err_enc_nc ; 
logic binenc_hitv_err_any_nc ;
hqm_AW_binenc #(
 .WIDTH ( HQM_AQED_ENTRIES )
) i_binenc_hitv_err (
 .a ( binenc_hitv_err_a )
,.enc ( binenc_hitv_err_enc_nc )
,.any ( binenc_hitv_err_any_nc )
);
always_ff @( posedge clk or negedge rst_n ) begin
  if (!rst_n ) begin
    binenc_hitv_err_en_f <= '0 ;
    binenc_hitv_err_en_f2 <= '0 ;
    binenc_hitv_err_a_f <= '0 ;
    binenc_hitv_err_a_f2 <= '0 ;
  end
  else begin
    binenc_hitv_err_en_f <= binenc_hitv_err_en_nxt ;
    binenc_hitv_err_en_f2 <= binenc_hitv_err_en_f ;
    binenc_hitv_err_a_f <= binenc_hitv_err_a_nxt ;
    binenc_hitv_err_a_f2 <= binenc_hitv_err_a_nxt2 ;
  end
end

//....................................................................................................
//p0 pipe stage
always_comb begin

  notempty = (|( vld_f )) ;

  vld_nxt = vld_f ;
  parity_gen_cam_d = '0 ;
  //..................................................
  //pipe control
  p0_pipe = '0 ;
  p0_ctrl_nxt = '0 ;
  p0_data_nxt = p0_data_f ;
  //

  p0_pipe.enbl                                  = ( ( ( in_valid & ( in_op == HQM_AQED_P_OP_ENQ_CEN ) )
                                                    | ( in_valid & ( in_op == HQM_AQED_P_OP_CMP_WEN ) )
                                                    | ( in_valid & ( in_op == HQM_AQED_P_OP_ENQ_WEN ) )
                                                    )
                                                  ) ;

  parity_gen_cam_d                              = { in_hid , in_qid } ;

  if ( in_valid  & ( in_op == HQM_AQED_P_OP_ENQ_WEN ) ) begin
    vld_nxt [ in_fid [ 7 : 0 ] ]                      = 1'b1 ;
  end

  p0_ctrl_nxt.v                                 = p0_pipe.enbl;
  if ( p0_pipe.enbl ) begin
    case ({( in_op == HQM_AQED_P_OP_ENQ_WEN ), ( in_op == HQM_AQED_P_OP_CMP_WEN ) } )
      2'b01   : p0_ctrl_nxt.op = HQM_AQED_OP_CMP_WEN ;
      2'b10   : p0_ctrl_nxt.op = HQM_AQED_OP_ENQ_WEN ;
      default : p0_ctrl_nxt.op = HQM_AQED_OP_ENQ_CEN ;
    endcase
    p0_data_nxt.fid                             = in_fid [ 7 : 0 ] ;
    p0_data_nxt.qid                             = in_qid ;
    p0_data_nxt.hid                             = in_hid ;
    p0_data_nxt.parity                          = parity_gen_cam_p ;
  end

  //..................................................
  //drive CAM inputs 
  FUNC_CEN_RF_IN_P0 = '0 ;
  FUNC_CM_DATA_RF_IN_P0 = { p0_data_f.parity , 1'b1 , 1'b0 , p0_data_f.hid , p0_data_f.qid } ;
  mux_FUNC_WEN_RF_IN_P0 = '0 ;
  mux_FUNC_WR_ADDR_RF_IN_P0 = { p0_data_f.fid [ ( HQM_AQED_AWIDTH ) - 1 : 0 ] } ;
  mux_FUNC_WR_DATA_RF_IN_P0 = '0 ;
  if ( p0_ctrl_f.v ) begin
    case ( { ( p0_ctrl_f.op == HQM_AQED_OP_ENQ_CEN ), (  p0_ctrl_f.op == HQM_AQED_OP_ENQ_WEN ) , ( p0_ctrl_f.op == HQM_AQED_OP_CMP_WEN ) } )
      3'b001 : begin
        mux_FUNC_WEN_RF_IN_P0                   = 1'b1 ;
        mux_FUNC_WR_DATA_RF_IN_P0               = { p0_data_f.parity , 1'b0 , 1'b0 , p0_data_f.hid , p0_data_f.qid } ;
        vld_nxt [ p0_data_f.fid ]                = 1'b0 ;
      end
      3'b010 : begin
        mux_FUNC_WEN_RF_IN_P0                   = 1'b1 ;
        mux_FUNC_WR_DATA_RF_IN_P0               = { p0_data_f.parity , 1'b1 , 1'b0 , p0_data_f.hid , p0_data_f.qid } ;
      end
      default : begin
        FUNC_CEN_RF_IN_P0                       = 1'b1 ;
      end
    endcase
  end

end

//....................................................................................................
//p1 pipe stage
always_comb begin

  //..................................................
  //pipe control
  p1_pipe = '0 ;
  p1_ctrl_nxt = '0 ;
  p1_data_nxt = p1_data_f ;
  //
  p1_pipe.enbl                                  = p0_ctrl_f.v;
  //
  p1_ctrl_nxt.v                                 = p1_pipe.enbl;
  if ( p1_pipe.enbl ) begin
    p1_data_nxt                                 = p0_data_f ;
    p1_ctrl_nxt.op                              = p0_ctrl_f.op ;
  end

  //..................................................
  //pipe function
  hitv_nxt = hitv_f ;
  hit_nxt =  p1_ctrl_f.v & ( p1_ctrl_f.op == HQM_AQED_OP_ENQ_CEN ) & ( |CM_MATCH_RF_OUT_P0 ) ;
  if ( p1_ctrl_f.v & ( p1_ctrl_f.op == HQM_AQED_OP_ENQ_CEN )) begin
    hitv_nxt                                    = CM_MATCH_RF_OUT_P0;
  end

end

//....................................................................................................
//p2 pipe stage
always_comb begin

  //..................................................
  //pipe control
  p2_pipe = '0 ;
  p2_ctrl_nxt = '0 ;
  p2_data_nxt = p2_data_f ;
  //
  p2_pipe.enbl                                  = p1_ctrl_f.v ;
  //
  p2_ctrl_nxt.v                                 = p2_pipe.enbl ;
  if ( p2_pipe.enbl ) begin
    p2_ctrl_nxt.op                              = p1_ctrl_f.op ;
    p2_data_nxt                                 = p1_data_f ;
  end

  //.........................
  binenc_hitv_a                                 = hitv_f ;
  binenc_vld_a                                  = ~vld_f;

  lookup_miss                                   = p2_ctrl_f.v & ( p2_ctrl_f.op == HQM_AQED_OP_ENQ_CEN ) & ( ~hit_f ) ;
  lookup_hit                                    = p2_ctrl_f.v & ( p2_ctrl_f.op == HQM_AQED_OP_ENQ_CEN ) & ( hit_f  ) ;

  out_valid                                     = p2_ctrl_f.v & ( p2_ctrl_f.op == HQM_AQED_OP_ENQ_CEN ) ;
  out_op                                        = p2_ctrl_f.op ;
  out_qid                                       = p2_data_f.qid ;
  out_hid                                       = p2_data_f.hid ;
  out_hit                                       = lookup_hit;
  out_vac                                       = |(~vld_f );

  case ({ lookup_miss , lookup_hit } )
   2'b10  : out_fid = { bcam_inst , binenc_vld_enc } ; //OP_ENQ_CEN
   2'b01  : out_fid = { bcam_inst , binenc_hitv_enc } ; //OP_ENQ_CEN
   default : out_fid = { bcam_inst , p2_data_f.fid  } ; //OP_CMP_WEN
  endcase

end


//....................................................................................................
// ERROR
always_comb begin
  error_cond = '0 ;

  //..................................................
  binenc_hitv_err_en_nxt                        = ( p2_ctrl_f.v & ( p2_ctrl_f.op == HQM_AQED_OP_ENQ_CEN ) & ( hit_f ) ) ;
  binenc_hitv_err_a_nxt                         = binenc_hitv_err_a_f ;
  if ( binenc_hitv_err_en_nxt ) begin
  binenc_hitv_err_a_nxt                         = hitv_f ;
  end
  binenc_hitv_err_a_nxt [ binenc_hitv_enc ]        = 1'b0 ;
  binenc_hitv_err_a                             = binenc_hitv_err_a_f ;

  binenc_hitv_err_a_nxt2 = binenc_hitv_err_a_f2 ;
  if ( binenc_hitv_err_en_f ) begin
    binenc_hitv_err_a_nxt2                         = binenc_hitv_err_a_f ;
  end

  error_cond [ HQM_AQED_ERR_P2_LOOKUP_HIT_DOUBLE ] = ( ( binenc_hitv_err_en_f & ( | binenc_hitv_err_a_f [ 127 : 0 ] ) )
                                                       | ( binenc_hitv_err_en_f2 & ( | binenc_hitv_err_a_f2 [ 255 : 128 ] ) )
                                                     ) ;

  error_cond [ HQM_AQED_ERR_P2_COMPLETE_UNSET ] = ( ( p0_ctrl_f.v
                                                    & ( p0_ctrl_f.op == HQM_AQED_OP_CMP_WEN )
                                                    & ( ~vld_f [ p0_data_f.fid ] )
                                                    )
                                                  | ( lookup_hit
                                                    & ( ~vld_f [ out_fid [7:0]  ] )
                                                    )
                                                  ) ;
  error_cond_nxt = error_cond ;
  error = { error_cond_f } ;
end

endmodule
