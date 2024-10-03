
module hqm_fid_bcam
import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
#(
  parameter HQM_AQED_CNT = 8
, parameter HQM_AQED_AWIDTH = 8
, parameter HQM_AQED_DWIDTH = 26 //qid:7 + hid:16 + v:1 parity:1 spare:1
, parameter HQM_AQED_ENTRIES = 256
, parameter HQM_AQED_IWIDTH = 3
, parameter HQM_AQED_ENTRIESB2 = AW_logb2 ( HQM_AQED_ENTRIES - 1 ) + 1

, parameter HQM_AQED_FID_WIDTH = 11
, parameter HQM_AQED_FID_CNT = 13
, parameter HQM_AQED_QID_CNT = 13
, parameter HQM_AQED_FID_CNT_DWIDTH = 15
, parameter HQM_AQED_FID_CNT_DEPTH = 2048
, parameter HQM_AQED_FID_CNT_DEPTHB2 = AW_logb2 ( HQM_AQED_FID_CNT_DEPTH - 1 ) + 1
, parameter HQM_AQED_QID_CNT_DWIDTH = 15
, parameter HQM_AQED_QID_CNT_DEPTH = 128
, parameter HQM_AQED_QID_CNT_DEPTHB2 = AW_logb2 ( HQM_AQED_QID_CNT_DEPTH - 1 ) + 1 
, parameter HQM_AQED_QID_FID_LIMIT_DWIDTH = 14
, parameter HQM_AQED_QID_FID_LIMIT_DEPTH = 128
, parameter HQM_AQED_QID_FID_LIMIT_DEPTHB2 = AW_logb2 ( HQM_AQED_QID_FID_LIMIT_DEPTH - 1 ) + 1
) (
  input  logic                                                  clk
, input  logic                                                  rst_n

, output logic                                                  in_enq_ack
, input  logic                                                  in_enq_v
, input  logic [ ( 7 ) - 1 : 0 ]                                 in_enq_qid
, input  logic [ ( 16 ) - 1 : 0 ]                                in_enq_hid
, input  logic [ ( 139 ) - 1 : 0 ]                               in_enq_data

, output logic                                                  in_cmp_ack
, input  logic                                                  in_cmp_v
, input  logic [ ( HQM_AQED_FID_WIDTH ) - 1 : 0 ]                         in_cmp_fid
, input  logic [ ( 7 ) - 1 : 0 ]                                 in_cmp_qid
, input  logic [ ( 16 ) - 1 : 0 ]                                in_cmp_hid

, input  logic                                                  cfg_fid_decrement
, input  logic                                                  cfg_fid_sim

, output logic                                                  out_enq_v
, output logic [ ( HQM_AQED_FID_WIDTH ) - 1 : 0 ]                         out_enq_fid
, output logic [ ( 139 ) - 1 : 0 ]                               out_enq_data

, output logic                                                  aqed_lsp_fid_cnt_upd_v
, output logic                                                  aqed_lsp_fid_cnt_upd_val
, output logic [ ( 7 ) - 1 : 0 ]                                 aqed_lsp_fid_cnt_upd_qid

, output logic                                                  aqed_lsp_dec_fid_cnt_v

, output logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ]                           FUNC_WEN_RF_IN_P0
, output logic [ ( HQM_AQED_CNT * HQM_AQED_AWIDTH ) - 1 : 0 ]                      FUNC_WR_ADDR_RF_IN_P0
, output logic [ ( HQM_AQED_CNT * HQM_AQED_DWIDTH ) - 1 : 0 ]                      FUNC_WR_DATA_RF_IN_P0

, output logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ]                           FUNC_CEN_RF_IN_P0
, output logic [ ( HQM_AQED_CNT * HQM_AQED_DWIDTH ) - 1 : 0 ]                      FUNC_CM_DATA_RF_IN_P0
, input  logic [ ( HQM_AQED_CNT * HQM_AQED_ENTRIES ) - 1 : 0 ]                     CM_MATCH_RF_OUT_P0

, output logic                                                  rf_aqed_fid_cnt_re
, output logic                                                  rf_aqed_fid_cnt_we
, output logic [ ( HQM_AQED_FID_CNT_DEPTHB2 ) - 1 : 0 ]          rf_aqed_fid_cnt_waddr
, output logic [ ( HQM_AQED_FID_CNT_DEPTHB2 ) - 1 : 0 ]          rf_aqed_fid_cnt_raddr
, output logic [ ( HQM_AQED_FID_CNT_DWIDTH ) - 1 : 0 ]           rf_aqed_fid_cnt_wdata
, input  logic [ ( HQM_AQED_FID_CNT_DWIDTH ) - 1 : 0 ]           rf_aqed_fid_cnt_rdata

, output logic                                                  rf_aqed_qid_cnt_re
, output logic                                                  rf_aqed_qid_cnt_we
, output logic [ ( HQM_AQED_QID_CNT_DEPTHB2 ) - 1 : 0 ]          rf_aqed_qid_cnt_waddr
, output logic [ ( HQM_AQED_QID_CNT_DEPTHB2 ) - 1 : 0 ]          rf_aqed_qid_cnt_raddr
, output logic [ ( HQM_AQED_QID_CNT_DWIDTH ) - 1 : 0 ]           rf_aqed_qid_cnt_wdata
, input  logic [ ( HQM_AQED_QID_CNT_DWIDTH ) - 1 : 0 ]           rf_aqed_qid_cnt_rdata

, output logic                                                  rf_aqed_qid_fid_limit_re
, output logic                                                  rf_aqed_qid_fid_limit_we
, output logic [ ( HQM_AQED_QID_FID_LIMIT_DEPTHB2 ) - 1 : 0 ]    rf_aqed_qid_fid_limit_addr
, output logic [ ( HQM_AQED_QID_FID_LIMIT_DWIDTH ) - 1 : 0 ]     rf_aqed_qid_fid_limit_wdata
, input  logic [ ( HQM_AQED_QID_FID_LIMIT_DWIDTH ) - 1 : 0 ]     rf_aqed_qid_fid_limit_rdata

, output logic [ ( ( 8 * 2 ) + 2 + 6 ) - 1 : 0 ]                 error

, output logic                                                  init_active
, output logic                                                  notempty
, output logic [ ( HQM_AQED_FID_CNT + 1 ) - 1 : 0 ] total_fid
, output logic [ ( HQM_AQED_QID_CNT + 1 ) - 1 : 0 ] total_qid
, output logic [ ( 9 ) - 1 : 0 ]       pipe_health
, output logic debug_fidcnt_uf
, output logic debug_fidcnt_of
, output logic debug_qidcnt_uf
, output logic debug_qidcnt_of
, output logic debug_collide0
, output logic debug_collide1
, output logic debug_hit

);

//....................................................................................................

localparam HQM_AQED_ARB_BCAM_ENQ_MISS = 0;
localparam HQM_AQED_ARB_BCAM_CMP_CNT0 = 1;
localparam HQM_AQED_ARB_BCAM_ENQ_LU = 2;

localparam HQM_AQED_ARB_FIDCNT_ENQ = 0;
localparam HQM_AQED_ARB_FIDCNT_CMP = 1;

localparam HQM_AQED_ARB_ENQ_LU = 1;
localparam HQM_AQED_ARB_CMP = 0;


//....................................................................................................
typedef struct packed {
  logic [ ( HQM_AQED_FID_WIDTH ) - 1 : 0 ] fid ;
  logic [ ( 7 ) - 1 : 0 ] qid ;
  logic [ ( 16 ) - 1 : 0 ] hid ;
  logic [ ( 139 ) - 1 : 0 ] hcw ;
} bcam_data_t ;

typedef struct packed {
  logic [ ( HQM_AQED_FID_WIDTH ) - 1 : 0 ] fid ;
  logic [ ( 7 ) - 1 : 0 ] qid ;
  logic [ ( 16 ) - 1 : 0 ] hid ;
} fidcnt_data_t ;

typedef struct packed {
  logic [ ( 7 ) - 1 : 0 ] qid ;
} qidcnt_data_t ;

typedef enum logic [ 1 : 0 ] {
HQM_AQED_OP_BCAM_CMP_WEN = 2'd3 ,
HQM_AQED_OP_BCAM_ENQ_WEN = 2'd2 ,
HQM_AQED_OP_BCAM_ENQ_CEN = 2'd1 ,
HQM_AQED_OP_BCAM_ILL0 = 2'd0
} op_bcam_ctrl_enum_t ;
typedef struct packed {
  logic v ;
  op_bcam_ctrl_enum_t op ;
} bcam_ctrl_t ;

typedef enum logic [ 1 : 0 ] {
HQM_AQED_OP_FIDCNT_ILL3 = 2'd3 ,
HQM_AQED_OP_FIDCNT_CMP = 2'd2 ,
HQM_AQED_OP_FIDCNT_ENQ = 2'd1 ,
HQM_AQED_OP_FIDCNT_ILL0 = 2'd0
} op_fidcnt_ctrl_enum_t ;
typedef struct packed {
  logic v ;
  op_fidcnt_ctrl_enum_t op ;
} fidcnt_ctrl_t ;

typedef enum logic [ 1 : 0 ] {
HQM_AQED_OP_QIDCNT_ILL3 = 2'd3 ,
HQM_AQED_OP_QIDCNT_CMP_M1 = 2'd2 ,
HQM_AQED_OP_QIDCNT_ENQ_P1 = 2'd1 ,
HQM_AQED_OP_QIDCNT_ILL0 = 2'd0
} op_qidcnt_ctrl_enum_t ;
typedef struct packed {
  logic v ;
  op_qidcnt_ctrl_enum_t op ;
} qidcnt_ctrl_t ;

typedef struct packed {
  logic enbl ;
} pipe_t ;

logic [ ( HQM_AQED_FID_CNT ) - 1 : 0 ] fid_cnt_new ;
logic [ ( HQM_AQED_QID_CNT ) - 1 : 0 ] qid_cnt_new ;

//....................................................................................................
logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ] bcam_in_valid ;
logic [ ( HQM_AQED_CNT * 2 ) - 1 : 0 ] bcam_in_op ;
logic [ ( HQM_AQED_CNT * HQM_AQED_FID_WIDTH ) - 1 : 0 ] bcam_in_fid ;
logic [ ( HQM_AQED_CNT * 7 ) - 1 : 0 ] bcam_in_qid ;
logic [ ( HQM_AQED_CNT * 16 ) - 1 : 0 ] bcam_in_hid ;
logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ] bcam_out_valid_nc ;
logic [ ( HQM_AQED_CNT * 2 ) - 1 : 0 ] bcam_out_op_nc ;
logic [ ( HQM_AQED_CNT * HQM_AQED_FID_WIDTH ) - 1 : 0 ] bcam_out_fid ;
logic [ ( HQM_AQED_CNT * 7 ) - 1 : 0 ] bcam_out_qid_nc ;
logic [ ( HQM_AQED_CNT * 16 ) - 1 : 0 ] bcam_out_hid_nc ;
logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ] bcam_out_hit ;
logic [ ( HQM_AQED_CNT * 1 ) - 1 : 0 ] bcam_out_vac ;
logic [ ( ( HQM_AQED_CNT * 2 ) + 2 ) - 1 : 0 ] bcam_error ;
logic [ ( ( HQM_AQED_CNT * 1 ) ) - 1 : 0 ] mux_init_active ;
logic [ ( ( HQM_AQED_CNT * 1 ) ) - 1 : 0 ] mux_notempty ;
hqm_bcam i_hqm_bcam (
   .clk ( clk ) 
 , .rst_n ( rst_n )

, .FUNC_WEN_RF_IN_P0 ( FUNC_WEN_RF_IN_P0 )
, .FUNC_WR_ADDR_RF_IN_P0 ( FUNC_WR_ADDR_RF_IN_P0 )
, .FUNC_WR_DATA_RF_IN_P0 ( FUNC_WR_DATA_RF_IN_P0 )

, .FUNC_CEN_RF_IN_P0 ( FUNC_CEN_RF_IN_P0 )
, .FUNC_CM_DATA_RF_IN_P0 ( FUNC_CM_DATA_RF_IN_P0 )
, .CM_MATCH_RF_OUT_P0 ( CM_MATCH_RF_OUT_P0 )

, .in_valid ( bcam_in_valid )
, .in_op ( bcam_in_op )
, .in_fid ( bcam_in_fid )
, .in_qid ( bcam_in_qid )
, .in_hid ( bcam_in_hid )

, .out_valid ( bcam_out_valid_nc )
, .out_op ( bcam_out_op_nc )
, .out_fid ( bcam_out_fid )
, .out_qid ( bcam_out_qid_nc )
, .out_hid ( bcam_out_hid_nc )
, .out_hit ( bcam_out_hit )
, .out_vac ( bcam_out_vac )

, .error ( bcam_error )

, .init_active ( mux_init_active )
, .notempty ( mux_notempty )
);

logic  rmw_aqed_fid_cnt_status_nc ;
logic  rmw_aqed_fid_cnt_p0_v_nxt ;
aw_rmwpipe_cmd_t rmw_aqed_fid_cnt_p0_rw_nxt ;
logic [ ( HQM_AQED_FID_CNT_DEPTHB2 ) - 1 : 0 ] rmw_aqed_fid_cnt_p0_addr_nxt ;
logic [ ( HQM_AQED_FID_CNT_DWIDTH ) - 1 : 0 ] rmw_aqed_fid_cnt_p0_write_data_nxt ;
logic  rmw_aqed_fid_cnt_p0_hold ;
logic  rmw_aqed_fid_cnt_p0_v_f_nc ;
aw_rmwpipe_cmd_t rmw_aqed_fid_cnt_p0_rw_f_nc ;
logic [ ( HQM_AQED_FID_CNT_DEPTHB2 ) - 1 : 0 ] rmw_aqed_fid_cnt_p0_addr_f_nc ;
logic [ ( HQM_AQED_FID_CNT_DWIDTH ) - 1 : 0 ] rmw_aqed_fid_cnt_p0_data_f_nc ;
logic  rmw_aqed_fid_cnt_p1_hold ;
logic  rmw_aqed_fid_cnt_p1_v_f_nc ;
aw_rmwpipe_cmd_t rmw_aqed_fid_cnt_p1_rw_f_nc ;
logic [ ( HQM_AQED_FID_CNT_DEPTHB2 ) - 1 : 0 ] rmw_aqed_fid_cnt_p1_addr_f_nc ;
logic [ ( HQM_AQED_FID_CNT_DWIDTH ) - 1 : 0 ] rmw_aqed_fid_cnt_p1_data_f_nc ;
logic  rmw_aqed_fid_cnt_p2_hold ;
logic  rmw_aqed_fid_cnt_p2_v_f_nc ;
aw_rmwpipe_cmd_t rmw_aqed_fid_cnt_p2_rw_f_nc ;
logic [ ( HQM_AQED_FID_CNT_DEPTHB2 ) - 1 : 0 ] rmw_aqed_fid_cnt_p2_addr_f_nc ;
logic [ ( HQM_AQED_FID_CNT_DWIDTH ) - 1 : 0 ] rmw_aqed_fid_cnt_p2_data_f ;
logic  rmw_aqed_fid_cnt_p3_hold ;
logic  rmw_aqed_fid_cnt_p3_bypsel_nxt ;
logic [ ( HQM_AQED_FID_CNT_DWIDTH ) - 1 : 0 ] rmw_aqed_fid_cnt_p3_bypdata_nxt ;
logic  rmw_aqed_fid_cnt_p3_v_f_nc ;
aw_rmwpipe_cmd_t rmw_aqed_fid_cnt_p3_rw_f_nc ;
logic [ ( HQM_AQED_FID_CNT_DEPTHB2 ) - 1 : 0 ] rmw_aqed_fid_cnt_p3_addr_f_nc ;
logic [ ( HQM_AQED_FID_CNT_DWIDTH ) - 1 : 0 ] rmw_aqed_fid_cnt_p3_data_f_nc ;
hqm_AW_rmw_mem_4pipe #(
    .DEPTH ( HQM_AQED_FID_CNT_DEPTH )
  , .WIDTH ( HQM_AQED_FID_CNT_DWIDTH )
) i_rmw_aqed_fid_cnt (
    .clk ( clk )
  , .rst_n ( rst_n )
  , .status ( rmw_aqed_fid_cnt_status_nc )

  , .p0_v_nxt ( rmw_aqed_fid_cnt_p0_v_nxt )
  , .p0_rw_nxt ( rmw_aqed_fid_cnt_p0_rw_nxt )
  , .p0_addr_nxt ( rmw_aqed_fid_cnt_p0_addr_nxt )
  , .p0_write_data_nxt ( rmw_aqed_fid_cnt_p0_write_data_nxt )
  , .p0_hold ( rmw_aqed_fid_cnt_p0_hold )
  , .p0_v_f ( rmw_aqed_fid_cnt_p0_v_f_nc )
  , .p0_rw_f ( rmw_aqed_fid_cnt_p0_rw_f_nc )
  , .p0_addr_f ( rmw_aqed_fid_cnt_p0_addr_f_nc )
  , .p0_data_f ( rmw_aqed_fid_cnt_p0_data_f_nc )

  , .p1_hold ( rmw_aqed_fid_cnt_p1_hold )
  , .p1_v_f ( rmw_aqed_fid_cnt_p1_v_f_nc )
  , .p1_rw_f ( rmw_aqed_fid_cnt_p1_rw_f_nc )
  , .p1_addr_f ( rmw_aqed_fid_cnt_p1_addr_f_nc )
  , .p1_data_f ( rmw_aqed_fid_cnt_p1_data_f_nc )

  , .p2_hold ( rmw_aqed_fid_cnt_p2_hold )
  , .p2_v_f ( rmw_aqed_fid_cnt_p2_v_f_nc )
  , .p2_rw_f ( rmw_aqed_fid_cnt_p2_rw_f_nc )
  , .p2_addr_f ( rmw_aqed_fid_cnt_p2_addr_f_nc )
  , .p2_data_f ( rmw_aqed_fid_cnt_p2_data_f )

  , .p3_hold ( rmw_aqed_fid_cnt_p3_hold )
  , .p3_bypsel_nxt ( rmw_aqed_fid_cnt_p3_bypsel_nxt )
  , .p3_bypdata_nxt ( rmw_aqed_fid_cnt_p3_bypdata_nxt )
  , .p3_v_f ( rmw_aqed_fid_cnt_p3_v_f_nc )
  , .p3_rw_f ( rmw_aqed_fid_cnt_p3_rw_f_nc )
  , .p3_addr_f ( rmw_aqed_fid_cnt_p3_addr_f_nc )
  , .p3_data_f ( rmw_aqed_fid_cnt_p3_data_f_nc )

  , .mem_write ( rf_aqed_fid_cnt_we )
  , .mem_read ( rf_aqed_fid_cnt_re )
  , .mem_write_addr ( rf_aqed_fid_cnt_waddr )
  , .mem_read_addr ( rf_aqed_fid_cnt_raddr )
  , .mem_write_data ( rf_aqed_fid_cnt_wdata )
  , .mem_read_data ( rf_aqed_fid_cnt_rdata )
) ;

logic  rw_aqed_qid_cnt_status_nc ;
logic  rw_aqed_qid_cnt_p0_v_nxt ;
aw_rmwpipe_cmd_t rw_aqed_qid_cnt_p0_rw_nxt ;
logic [ ( HQM_AQED_QID_CNT_DEPTHB2 ) - 1 : 0 ] rw_aqed_qid_cnt_p0_addr_nxt ;
logic [ ( HQM_AQED_QID_CNT_DWIDTH ) - 1 : 0 ] rw_aqed_qid_cnt_p0_write_data_nxt ;
logic  rw_aqed_qid_cnt_p0_hold ;
logic  rw_aqed_qid_cnt_p0_v_f_nc ;
aw_rmwpipe_cmd_t rw_aqed_qid_cnt_p0_rw_f_nc ;
logic [ ( HQM_AQED_QID_CNT_DEPTHB2 ) - 1 : 0 ] rw_aqed_qid_cnt_p0_addr_f_nc ;
logic [ ( HQM_AQED_QID_CNT_DWIDTH ) - 1 : 0 ] rw_aqed_qid_cnt_p0_data_f_nc ;
logic  rw_aqed_qid_cnt_p1_hold ;
logic  rw_aqed_qid_cnt_p1_v_f_nc ;
aw_rmwpipe_cmd_t rw_aqed_qid_cnt_p1_rw_f_nc ;
logic [ ( HQM_AQED_QID_CNT_DEPTHB2 ) - 1 : 0 ] rw_aqed_qid_cnt_p1_addr_f_nc ;
logic [ ( HQM_AQED_QID_CNT_DWIDTH ) - 1 : 0 ] rw_aqed_qid_cnt_p1_data_f_nc ;
logic  rw_aqed_qid_cnt_p2_hold ;
logic  rw_aqed_qid_cnt_p2_v_f_nc ;
aw_rmwpipe_cmd_t rw_aqed_qid_cnt_p2_rw_f_nc ;
logic [ ( HQM_AQED_QID_CNT_DEPTHB2 ) - 1 : 0 ] rw_aqed_qid_cnt_p2_addr_f_nc ;
logic [ ( HQM_AQED_QID_CNT_DWIDTH ) - 1 : 0 ] rw_aqed_qid_cnt_p2_data_f ;
logic  rw_aqed_qid_cnt_p3_hold ;
logic  rw_aqed_qid_cnt_p3_bypsel_nxt ;
logic [ ( HQM_AQED_QID_CNT_DWIDTH ) - 1 : 0 ] rw_aqed_qid_cnt_p3_bypdata_nxt ;
logic  rw_aqed_qid_cnt_p3_v_f_nc ;
aw_rmwpipe_cmd_t rw_aqed_qid_cnt_p3_rw_f_nc ;
logic [ ( HQM_AQED_QID_CNT_DEPTHB2 ) - 1 : 0 ] rw_aqed_qid_cnt_p3_addr_f_nc ;
logic [ ( HQM_AQED_QID_CNT_DWIDTH ) - 1 : 0 ] rw_aqed_qid_cnt_p3_data_f_nc ;
hqm_AW_rmw_mem_4pipe #(
    .DEPTH ( HQM_AQED_QID_CNT_DEPTH )
  , .WIDTH ( HQM_AQED_QID_CNT_DWIDTH )
) i_rw_aqed_qid_cnt (
    .clk ( clk )
  , .rst_n ( rst_n )
  , .status ( rw_aqed_qid_cnt_status_nc )
  
  , .p0_v_nxt ( rw_aqed_qid_cnt_p0_v_nxt )
  , .p0_rw_nxt ( rw_aqed_qid_cnt_p0_rw_nxt )
  , .p0_addr_nxt ( rw_aqed_qid_cnt_p0_addr_nxt )
  , .p0_write_data_nxt ( rw_aqed_qid_cnt_p0_write_data_nxt )
  , .p0_hold ( rw_aqed_qid_cnt_p0_hold )
  , .p0_v_f ( rw_aqed_qid_cnt_p0_v_f_nc )
  , .p0_rw_f ( rw_aqed_qid_cnt_p0_rw_f_nc )
  , .p0_addr_f ( rw_aqed_qid_cnt_p0_addr_f_nc )
  , .p0_data_f ( rw_aqed_qid_cnt_p0_data_f_nc )
  
  , .p1_hold ( rw_aqed_qid_cnt_p1_hold )
  , .p1_v_f ( rw_aqed_qid_cnt_p1_v_f_nc )
  , .p1_rw_f ( rw_aqed_qid_cnt_p1_rw_f_nc )
  , .p1_addr_f ( rw_aqed_qid_cnt_p1_addr_f_nc )
  , .p1_data_f ( rw_aqed_qid_cnt_p1_data_f_nc )
  
  , .p2_hold ( rw_aqed_qid_cnt_p2_hold )
  , .p2_v_f ( rw_aqed_qid_cnt_p2_v_f_nc )
  , .p2_rw_f ( rw_aqed_qid_cnt_p2_rw_f_nc )
  , .p2_addr_f ( rw_aqed_qid_cnt_p2_addr_f_nc )
  , .p2_data_f ( rw_aqed_qid_cnt_p2_data_f )
  
  , .p3_hold ( rw_aqed_qid_cnt_p3_hold )
  , .p3_bypsel_nxt ( rw_aqed_qid_cnt_p3_bypsel_nxt )
  , .p3_bypdata_nxt ( rw_aqed_qid_cnt_p3_bypdata_nxt )
  , .p3_v_f ( rw_aqed_qid_cnt_p3_v_f_nc )
  , .p3_rw_f ( rw_aqed_qid_cnt_p3_rw_f_nc )
  , .p3_addr_f ( rw_aqed_qid_cnt_p3_addr_f_nc )
  , .p3_data_f ( rw_aqed_qid_cnt_p3_data_f_nc )
  
  , .mem_write ( rf_aqed_qid_cnt_we )
  , .mem_read ( rf_aqed_qid_cnt_re )
  , .mem_write_addr ( rf_aqed_qid_cnt_waddr )
  , .mem_read_addr ( rf_aqed_qid_cnt_raddr )
  , .mem_write_data ( rf_aqed_qid_cnt_wdata )
  , .mem_read_data ( rf_aqed_qid_cnt_rdata )
) ; 

logic  rw_aqed_qid_fid_limit_status_nc ;
logic  rw_aqed_qid_fid_limit_p0_v_nxt ;
aw_rwpipe_cmd_t rw_aqed_qid_fid_limit_p0_rw_nxt ;
logic [ ( HQM_AQED_QID_FID_LIMIT_DEPTHB2 ) - 1 : 0 ] rw_aqed_qid_fid_limit_p0_addr_nxt ;
logic [ ( HQM_AQED_QID_FID_LIMIT_DWIDTH ) - 1 : 0 ] rw_aqed_qid_fid_limit_p0_write_data_nxt ;
logic  rw_aqed_qid_fid_limit_p0_hold ;
logic  rw_aqed_qid_fid_limit_p0_v_f_nc ;
aw_rwpipe_cmd_t rw_aqed_qid_fid_limit_p0_rw_f_nc ;
logic [ ( HQM_AQED_QID_FID_LIMIT_DEPTHB2 ) - 1 : 0 ] rw_aqed_qid_fid_limit_p0_addr_f_nc ;
logic [ ( HQM_AQED_QID_FID_LIMIT_DWIDTH ) - 1 : 0 ] rw_aqed_qid_fid_limit_p0_data_f_nc ;
logic  rw_aqed_qid_fid_limit_p1_hold ;
logic  rw_aqed_qid_fid_limit_p1_v_f_nc ;
aw_rwpipe_cmd_t rw_aqed_qid_fid_limit_p1_rw_f_nc ;
logic [ ( HQM_AQED_QID_FID_LIMIT_DEPTHB2 ) - 1 : 0 ] rw_aqed_qid_fid_limit_p1_addr_f_nc ;
logic [ ( HQM_AQED_QID_FID_LIMIT_DWIDTH ) - 1 : 0 ] rw_aqed_qid_fid_limit_p1_data_f_nc ;
logic  rw_aqed_qid_fid_limit_p2_hold ;
logic  rw_aqed_qid_fid_limit_p2_v_f_nc ;
aw_rwpipe_cmd_t rw_aqed_qid_fid_limit_p2_rw_f_nc ;
logic [ ( HQM_AQED_QID_FID_LIMIT_DEPTHB2 ) - 1 : 0 ] rw_aqed_qid_fid_limit_p2_addr_f_nc ;
logic [ ( HQM_AQED_QID_FID_LIMIT_DWIDTH ) - 1 : 0 ] rw_aqed_qid_fid_limit_p2_data_f ;
logic  rw_aqed_qid_fid_limit_p3_hold ;
logic  rw_aqed_qid_fid_limit_p3_v_f_nc ;
aw_rwpipe_cmd_t rw_aqed_qid_fid_limit_p3_rw_f_nc ;
logic [ ( HQM_AQED_QID_FID_LIMIT_DEPTHB2 ) - 1 : 0 ] rw_aqed_qid_fid_limit_p3_addr_f_nc ;
logic [ ( HQM_AQED_QID_FID_LIMIT_DWIDTH ) - 1 : 0 ] rw_aqed_qid_fid_limit_p3_data_f_nc ;
hqm_AW_rw_mem_4pipe #(
    .DEPTH ( HQM_AQED_QID_FID_LIMIT_DEPTH )
  , .WIDTH ( HQM_AQED_QID_FID_LIMIT_DWIDTH )
) i_rw_aqed_qid_fid_limit (
    .clk ( clk )
  , .rst_n ( rst_n )
  , .status ( rw_aqed_qid_fid_limit_status_nc )
  
  , .p0_v_nxt ( rw_aqed_qid_fid_limit_p0_v_nxt )
  , .p0_rw_nxt ( rw_aqed_qid_fid_limit_p0_rw_nxt )
  , .p0_addr_nxt ( rw_aqed_qid_fid_limit_p0_addr_nxt )
  , .p0_write_data_nxt ( rw_aqed_qid_fid_limit_p0_write_data_nxt )
  , .p0_hold ( rw_aqed_qid_fid_limit_p0_hold )
  , .p0_v_f ( rw_aqed_qid_fid_limit_p0_v_f_nc )
  , .p0_rw_f ( rw_aqed_qid_fid_limit_p0_rw_f_nc )
  , .p0_addr_f ( rw_aqed_qid_fid_limit_p0_addr_f_nc )
  , .p0_data_f ( rw_aqed_qid_fid_limit_p0_data_f_nc )
  
  , .p1_hold ( rw_aqed_qid_fid_limit_p1_hold )
  , .p1_v_f ( rw_aqed_qid_fid_limit_p1_v_f_nc )
  , .p1_rw_f ( rw_aqed_qid_fid_limit_p1_rw_f_nc )
  , .p1_addr_f ( rw_aqed_qid_fid_limit_p1_addr_f_nc )
  , .p1_data_f ( rw_aqed_qid_fid_limit_p1_data_f_nc )
  
  , .p2_hold ( rw_aqed_qid_fid_limit_p2_hold )
  , .p2_v_f ( rw_aqed_qid_fid_limit_p2_v_f_nc )
  , .p2_rw_f ( rw_aqed_qid_fid_limit_p2_rw_f_nc )
  , .p2_addr_f ( rw_aqed_qid_fid_limit_p2_addr_f_nc )
  , .p2_data_f ( rw_aqed_qid_fid_limit_p2_data_f )
  
  , .p3_hold ( rw_aqed_qid_fid_limit_p3_hold )
  , .p3_v_f ( rw_aqed_qid_fid_limit_p3_v_f_nc )
  , .p3_rw_f ( rw_aqed_qid_fid_limit_p3_rw_f_nc )
  , .p3_addr_f ( rw_aqed_qid_fid_limit_p3_addr_f_nc )
  , .p3_data_f ( rw_aqed_qid_fid_limit_p3_data_f_nc )
  
  , .mem_write ( rf_aqed_qid_fid_limit_we )
  , .mem_read ( rf_aqed_qid_fid_limit_re )
  , .mem_addr ( rf_aqed_qid_fid_limit_addr )
  , .mem_write_data ( rf_aqed_qid_fid_limit_wdata )
  , .mem_read_data ( rf_aqed_qid_fid_limit_rdata )
) ; 

logic [ ( 2 ) - 1 : 0 ] arb_cmd_reqs ;
logic arb_cmd_winner_v ;
logic arb_cmd_winner ;
hqm_AW_strict_arb #(
    .NUM_REQS ( 2 )
) i_arb_cmd (
    .reqs ( arb_cmd_reqs )
  , .winner_v ( arb_cmd_winner_v )
  , .winner ( arb_cmd_winner )
) ;

logic [ ( 3 ) - 1 : 0 ] arb_bcam_reqs ;
logic arb_bcam_winner_v ;
logic [ ( 2 ) - 1 : 0 ] arb_bcam_winner ;
hqm_AW_strict_arb #(
    .NUM_REQS ( 3 )
) i_arb_bcam (
    .reqs ( arb_bcam_reqs )
  , .winner_v ( arb_bcam_winner_v )
  , .winner ( arb_bcam_winner )
) ;

logic [ ( 2 ) - 1 : 0 ] arb_fidcnt_reqs ; 
logic arb_fidcnt_winner_v ;
logic arb_fidcnt_winner ;
hqm_AW_strict_arb #(
    .NUM_REQS ( 2 )
) i_arb_fidcnt ( 
    .reqs ( arb_fidcnt_reqs ) 
  , .winner_v ( arb_fidcnt_winner_v ) 
  , .winner ( arb_fidcnt_winner ) 
) ;

logic [ ( 8 ) - 1 : 0 ] arb_vac_reqs ;
logic arb_vac_winner_v ;
logic [ ( 3 ) - 1 : 0 ] arb_vac_winner ;
hqm_AW_strict_arb #(
    .NUM_REQS ( 8 )
) i_arb_vac (
    .reqs ( arb_vac_reqs )
  , .winner_v ( arb_vac_winner_v )
  , .winner ( arb_vac_winner )
) ;

logic [ ( 8 ) - 1 : 0 ] arb_hit_reqs ;
logic arb_hit_winner_v ;
logic [ ( 3 ) - 1 : 0 ] arb_hit_winner ;
hqm_AW_strict_arb #(
    .NUM_REQS ( 8 )
) i_arb_hit (
    .reqs ( arb_hit_reqs )
  , .winner_v ( arb_hit_winner_v )
  , .winner ( arb_hit_winner )
) ;

logic  parity_check_p ;
logic [ ( HQM_AQED_QID_CNT ) - 1 : 0 ] parity_check_d ;
logic  parity_check_e ;
logic  parity_check_err ;
hqm_AW_parity_check #(
    .WIDTH                              ( HQM_AQED_QID_CNT )
) i_parity_check (
     .p                                 ( parity_check_p )
   , .d                                 ( parity_check_d )
   , .e                                 ( parity_check_e )
   , .odd                               ( 1'b1 )
   , .err                               ( parity_check_err )
);

logic [ ( 2 ) - 1 : 0 ] residue_check_fid_cnt_r ;
logic [ ( HQM_AQED_FID_CNT ) - 1 : 0 ] residue_check_fid_cnt_d ;
logic  residue_check_fid_cnt_e ;
logic  residue_check_fid_cnt_err ;
hqm_AW_residue_check #(
   .WIDTH                             ( HQM_AQED_FID_CNT )
) i_residue_check_fid_cnt_data (
   .r                                 ( residue_check_fid_cnt_r )
 , .d                                 ( residue_check_fid_cnt_d )
 , .e                                 ( residue_check_fid_cnt_e )
 , .err                               ( residue_check_fid_cnt_err )
);

logic [ ( 2 ) - 1 : 0 ] residue_add_fid_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_fid_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_fid_cnt_r ;
hqm_AW_residue_add i_residue_add_fid_cnt (
   .a                                 ( residue_add_fid_cnt_a )
 , .b                                 ( residue_add_fid_cnt_b )
 , .r                                 ( residue_add_fid_cnt_r )
);

logic [ ( 2 ) - 1 : 0 ] residue_sub_fid_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_fid_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_fid_cnt_r ;
hqm_AW_residue_sub i_residue_sub_fid_cnt (
   .a                                 ( residue_sub_fid_cnt_a )
 , .b                                 ( residue_sub_fid_cnt_b )
 , .r                                 ( residue_sub_fid_cnt_r )
);


logic [ ( 2 ) - 1 : 0 ] residue_check_qid_cnt_r ;
logic [ ( HQM_AQED_QID_CNT ) - 1 : 0 ] residue_check_qid_cnt_d ;
logic  residue_check_qid_cnt_e ;
logic  residue_check_qid_cnt_err ;
hqm_AW_residue_check #(
   .WIDTH                             ( HQM_AQED_QID_CNT )
) i_residue_check_qid_cnt_data (
   .r                                 ( residue_check_qid_cnt_r )
 , .d                                 ( residue_check_qid_cnt_d )
 , .e                                 ( residue_check_qid_cnt_e )
 , .err                               ( residue_check_qid_cnt_err )
);

logic [ ( 2 ) - 1 : 0 ] residue_add_qid_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_add_qid_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_add_qid_cnt_r ;
hqm_AW_residue_add i_residue_add_qid_cnt (
   .a                                 ( residue_add_qid_cnt_a )
 , .b                                 ( residue_add_qid_cnt_b )
 , .r                                 ( residue_add_qid_cnt_r )
);

logic [ ( 2 ) - 1 : 0 ] residue_sub_qid_cnt_a ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_qid_cnt_b ;
logic [ ( 2 ) - 1 : 0 ] residue_sub_qid_cnt_r ;
hqm_AW_residue_sub i_residue_sub_qid_cnt (
   .a                                 ( residue_sub_qid_cnt_a )
 , .b                                 ( residue_sub_qid_cnt_b )
 , .r                                 ( residue_sub_qid_cnt_r )
);



//....................................................................................................
pipe_t p0_bcam_pipe , p1_bcam_pipe , p2_bcam_pipe ;
bcam_ctrl_t p0_bcam_ctrl_nxt , p0_bcam_ctrl_f , p1_bcam_ctrl_nxt , p1_bcam_ctrl_f , p2_bcam_ctrl_nxt , p2_bcam_ctrl_f ;
bcam_data_t p0_bcam_data_nxt , p0_bcam_data_f , p1_bcam_data_nxt , p1_bcam_data_f , p2_bcam_data_nxt , p2_bcam_data_f ;
always_ff @( posedge clk or negedge rst_n ) begin
  if (!rst_n ) begin
    p0_bcam_ctrl_f <= '0 ;
    p1_bcam_ctrl_f <= '0 ;
    p2_bcam_ctrl_f <= '0 ;

    p0_bcam_data_f <= '0 ;
    p1_bcam_data_f <= '0 ;
    p2_bcam_data_f <= '0 ;
  end
  else begin
    p0_bcam_ctrl_f <= p0_bcam_ctrl_nxt ;
    p1_bcam_ctrl_f <= p1_bcam_ctrl_nxt ;
    p2_bcam_ctrl_f <= p2_bcam_ctrl_nxt ;

    p0_bcam_data_f <= p0_bcam_data_nxt ;
    p1_bcam_data_f <= p1_bcam_data_nxt ;
    p2_bcam_data_f <= p2_bcam_data_nxt ;
  end
end

pipe_t p0_fidcnt_pipe , p1_fidcnt_pipe , p2_fidcnt_pipe ;
fidcnt_ctrl_t p0_fidcnt_ctrl_nxt , p0_fidcnt_ctrl_f , p1_fidcnt_ctrl_nxt , p1_fidcnt_ctrl_f , p2_fidcnt_ctrl_nxt , p2_fidcnt_ctrl_f ;
fidcnt_data_t p0_fidcnt_data_nxt , p0_fidcnt_data_f , p1_fidcnt_data_nxt , p1_fidcnt_data_f , p2_fidcnt_data_nxt , p2_fidcnt_data_f ;
always_ff @( posedge clk or negedge rst_n ) begin
  if (!rst_n ) begin
    p0_fidcnt_ctrl_f <= '0 ;
    p1_fidcnt_ctrl_f <= '0 ;
    p2_fidcnt_ctrl_f <= '0 ;

    p0_fidcnt_data_f <= '0 ;
    p1_fidcnt_data_f <= '0 ;
    p2_fidcnt_data_f <= '0 ;
  end
  else begin
    p0_fidcnt_ctrl_f <= p0_fidcnt_ctrl_nxt ;
    p1_fidcnt_ctrl_f <= p1_fidcnt_ctrl_nxt ;
    p2_fidcnt_ctrl_f <= p2_fidcnt_ctrl_nxt ;

    p0_fidcnt_data_f <= p0_fidcnt_data_nxt ;
    p1_fidcnt_data_f <= p1_fidcnt_data_nxt ;
    p2_fidcnt_data_f <= p2_fidcnt_data_nxt ;
  end
end

pipe_t p0_qidcnt_pipe , p1_qidcnt_pipe , p2_qidcnt_pipe ;
qidcnt_ctrl_t p0_qidcnt_ctrl_nxt , p0_qidcnt_ctrl_f , p1_qidcnt_ctrl_nxt , p1_qidcnt_ctrl_f , p2_qidcnt_ctrl_nxt , p2_qidcnt_ctrl_f ;
qidcnt_data_t p0_qidcnt_data_nxt , p0_qidcnt_data_f , p1_qidcnt_data_nxt , p1_qidcnt_data_f , p2_qidcnt_data_nxt , p2_qidcnt_data_f ;
always_ff @( posedge clk or negedge rst_n ) begin
  if (!rst_n ) begin
    p0_qidcnt_ctrl_f <= '0 ;
    p1_qidcnt_ctrl_f <= '0 ;
    p2_qidcnt_ctrl_f <= '0 ;

    p0_qidcnt_data_f <= '0 ;
    p1_qidcnt_data_f <= '0 ;
    p2_qidcnt_data_f <= '0 ;
  end
  else begin
    p0_qidcnt_ctrl_f <= p0_qidcnt_ctrl_nxt ;
    p1_qidcnt_ctrl_f <= p1_qidcnt_ctrl_nxt ;
    p2_qidcnt_ctrl_f <= p2_qidcnt_ctrl_nxt ;

    p0_qidcnt_data_f <= p0_qidcnt_data_nxt ;
    p1_qidcnt_data_f <= p1_qidcnt_data_nxt ;
    p2_qidcnt_data_f <= p2_qidcnt_data_nxt ;
  end
end

logic aqed_lsp_fid_cnt_upd_v_f , aqed_lsp_fid_cnt_upd_v_nxt ;
logic aqed_lsp_fid_cnt_upd_val_f , aqed_lsp_fid_cnt_upd_val_nxt ;
logic [ ( 7 ) - 1 : 0 ] aqed_lsp_fid_cnt_upd_qid_f , aqed_lsp_fid_cnt_upd_qid_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if (!rst_n ) begin
    aqed_lsp_fid_cnt_upd_v_f <= '0 ;
    aqed_lsp_fid_cnt_upd_val_f <= '0 ;
    aqed_lsp_fid_cnt_upd_qid_f <= '0 ;
  end
  else begin
    aqed_lsp_fid_cnt_upd_v_f <= aqed_lsp_fid_cnt_upd_v_nxt ;
    aqed_lsp_fid_cnt_upd_val_f <= aqed_lsp_fid_cnt_upd_val_nxt ;
    aqed_lsp_fid_cnt_upd_qid_f <= aqed_lsp_fid_cnt_upd_qid_nxt ;
  end
end

logic [ ( HQM_AQED_FID_CNT + 1 ) - 1 : 0 ] total_fid_cnt_f , total_fid_cnt_nxt ;
logic [ ( HQM_AQED_QID_CNT + 1 ) - 1 : 0 ] total_qid_cnt_f , total_qid_cnt_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if (!rst_n ) begin
    total_fid_cnt_f <= '0 ;
    total_qid_cnt_f <= '0 ;
  end
  else begin
    total_fid_cnt_f <= total_fid_cnt_nxt ;
    total_qid_cnt_f <= total_qid_cnt_nxt ;
  end
end



logic [ ( 3 ) - 1 : 0 ] inst ;
logic error_cond_lookup_miss_empty ;
logic error_cond_lookup_all_empty ;
logic error_cond_pipeline ;
logic [ ( ( 8 * 2 ) + 2 + 6 ) - 1 : 0 ] error_nxt , error_f ;

always_ff @( posedge clk or negedge rst_n ) begin
  if (!rst_n ) begin
    error_f <= '0 ;
  end
  else begin
    error_f <= error_nxt ;
  end
end
assign error_nxt = { error_cond_pipeline , residue_check_qid_cnt_err , residue_check_fid_cnt_err , parity_check_err , error_cond_lookup_all_empty , error_cond_lookup_miss_empty , bcam_error } ;
assign error = error_f ;


assign init_active = ( |mux_init_active ) ;
assign notempty = ( (|( mux_notempty ))
                  | ~( total_fid_cnt_f == '0 )
                  | ~( total_qid_cnt_f == '0 )
                  ) ;
assign total_fid = total_fid_cnt_f ;
assign total_qid = total_qid_cnt_f ;
assign pipe_health = {
  p2_fidcnt_ctrl_f.v
 , p1_fidcnt_ctrl_f.v
 , p0_fidcnt_ctrl_f.v
 , p2_qidcnt_ctrl_f.v
 , p1_qidcnt_ctrl_f.v
 , p0_qidcnt_ctrl_f.v
 , p2_bcam_ctrl_f.v
 , p1_bcam_ctrl_f.v
 , p0_bcam_ctrl_f.v
} ;

//....................................................................................................
//p0 bcam pipe stage
//p0 fidcnt pipe stage
always_comb begin

  //..................................................
    inst = '0 ;
    bcam_in_valid = '0 ;
    bcam_in_op = '0 ;
    bcam_in_fid = '0 ;
    bcam_in_qid = '0 ;
    bcam_in_hid = '0 ;
    rmw_aqed_fid_cnt_p0_v_nxt = '0 ;
    rmw_aqed_fid_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
    rmw_aqed_fid_cnt_p0_addr_nxt = '0 ;
    rmw_aqed_fid_cnt_p0_write_data_nxt = '0 ;
    rmw_aqed_fid_cnt_p0_hold = '0 ;
    rmw_aqed_fid_cnt_p1_hold = '0 ;
    rmw_aqed_fid_cnt_p2_hold = '0 ;
    rmw_aqed_fid_cnt_p3_hold = '0 ;
    error_cond_lookup_miss_empty = '0 ;
    in_enq_ack = '0 ;
    in_cmp_ack = '0 ;

  //..................................................
  //pipe control
  p0_bcam_pipe = '0 ;
  p0_bcam_ctrl_nxt = '0 ;
  p0_bcam_data_nxt = p0_bcam_data_f ;

  p0_fidcnt_pipe = '0 ;
  p0_fidcnt_ctrl_nxt = '0 ;
  p0_fidcnt_data_nxt = p0_fidcnt_data_f ;

debug_collide0 = '0 ;
debug_collide1 = '0 ;

  //..................................................
  // drive arbiters to select input to bcam & fid pipeline
  arb_bcam_reqs [ HQM_AQED_ARB_BCAM_ENQ_MISS ]  = p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) & ~( |bcam_out_hit ) ;
  arb_bcam_reqs [ HQM_AQED_ARB_BCAM_CMP_CNT0 ]  = p2_fidcnt_ctrl_f.v & ( p2_fidcnt_ctrl_f.op == HQM_AQED_OP_FIDCNT_CMP ) & ( rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT - 1 ) : 0 ]  == { {( HQM_AQED_FID_CNT - 1 ){ 1'b0 }} , 1'b1 } ) ;
  arb_bcam_reqs [ HQM_AQED_ARB_BCAM_ENQ_LU ]    = ( in_enq_v

                                                  & ( cfg_fid_sim ? ~( p0_fidcnt_ctrl_f.v | p1_fidcnt_ctrl_f.v | p2_fidcnt_ctrl_f.v ) : 1'b1 )
                                                  & ( cfg_fid_sim ? ~( p0_bcam_ctrl_f.v | p1_bcam_ctrl_f.v | p2_bcam_ctrl_f.v ) : 1'b1 )

                                                  & ~( p0_fidcnt_ctrl_f.v & ( p0_fidcnt_data_f.qid == in_enq_qid ) & ( p0_fidcnt_data_f.hid == in_enq_hid ) )
                                                  & ~( p1_fidcnt_ctrl_f.v & ( p1_fidcnt_data_f.qid == in_enq_qid ) & ( p1_fidcnt_data_f.hid == in_enq_hid ) )
                                                  & ~( p2_fidcnt_ctrl_f.v & ( p2_fidcnt_ctrl_f.op == HQM_AQED_OP_FIDCNT_CMP ) & ( rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT - 1 ) : 0 ]  == { {( HQM_AQED_FID_CNT - 1 ){ 1'b0 }} , 1'b1 } ) )

                                                  & ~( p0_bcam_ctrl_f.v & ( p0_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) & ( p0_bcam_data_f.qid == in_enq_qid ) & ( p0_bcam_data_f.hid == in_enq_hid ) )
                                                  & ~( p1_bcam_ctrl_f.v & ( p1_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) & ( p1_bcam_data_f.qid == in_enq_qid ) & ( p1_bcam_data_f.hid == in_enq_hid ) )
                                                  & ~( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) & ~( |bcam_out_hit ) )

                                                  ) ;

  arb_fidcnt_reqs [ HQM_AQED_ARB_FIDCNT_ENQ ]   = p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) ;
  arb_fidcnt_reqs [ HQM_AQED_ARB_FIDCNT_CMP ]   = ( in_cmp_v

                                                  & ( cfg_fid_sim ? ~( p0_fidcnt_ctrl_f.v | p1_fidcnt_ctrl_f.v | p2_fidcnt_ctrl_f.v ) : 1'b1 )
                                                  & ( cfg_fid_sim ? ~( p0_bcam_ctrl_f.v | p1_bcam_ctrl_f.v | p2_bcam_ctrl_f.v ) : 1'b1 )

                                                  & ~( p0_bcam_ctrl_f.v & ( p0_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) & ( p0_bcam_data_f.qid == in_cmp_qid ) & ( p0_bcam_data_f.hid == in_cmp_hid ) )
                                                  & ~( p1_bcam_ctrl_f.v & ( p1_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) & ( p1_bcam_data_f.qid == in_cmp_qid ) & ( p1_bcam_data_f.hid == in_cmp_hid ) )
                                                  & ~( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) )

                                                  ) ;

  arb_cmd_reqs [ HQM_AQED_ARB_ENQ_LU ]          = ( ~init_active 
                                                  & arb_bcam_winner_v
                                                  & ( arb_bcam_winner == HQM_AQED_ARB_BCAM_ENQ_LU )
                                                  ) ;
  arb_cmd_reqs [ HQM_AQED_ARB_CMP ]             = ( ~init_active
                                                  & arb_fidcnt_winner_v
                                                  & ( arb_fidcnt_winner == HQM_AQED_ARB_FIDCNT_CMP )
                                                  )  ;



  //..................................................


debug_collide0 = arb_bcam_reqs [ HQM_AQED_ARB_BCAM_ENQ_MISS ] & arb_bcam_reqs [ HQM_AQED_ARB_BCAM_CMP_CNT0 ] ;
debug_collide1 = ( arb_cmd_winner_v & ( arb_cmd_winner == HQM_AQED_ARB_ENQ_LU ) ) & ( arb_cmd_winner_v & ( arb_cmd_winner == HQM_AQED_ARB_CMP ) ) ;

  //.........................
  //bcam_pipe: Issue enqueue lookup miss write (allocate) to bcam pipeline & bcam module.
  // This must always win arbitration and cannot be held
  if ( arb_bcam_winner_v & ( arb_bcam_winner == HQM_AQED_ARB_BCAM_ENQ_MISS ) ) begin

    inst = arb_vac_winner ; 

    p0_bcam_ctrl_nxt.v                          = 1'b1 ;
    p0_bcam_ctrl_nxt.op                         = HQM_AQED_OP_BCAM_ENQ_WEN ;
    p0_bcam_data_nxt.fid                        = bcam_out_fid [ ( inst * HQM_AQED_FID_WIDTH ) +: HQM_AQED_FID_WIDTH ] ; 
    p0_bcam_data_nxt.qid                        = p2_bcam_data_f.qid ;
    p0_bcam_data_nxt.hid                        = p2_bcam_data_f.hid ;
    p0_bcam_data_nxt.hcw                        = '0 ;

    bcam_in_valid [ ( inst * 1 ) +: 1 ]          = arb_vac_winner_v ; 
    bcam_in_op [ ( inst * 2 ) +: 2 ]             = p0_bcam_ctrl_nxt.op ; 
    bcam_in_fid [ ( inst * HQM_AQED_FID_WIDTH ) +: HQM_AQED_FID_WIDTH ]          = p0_bcam_data_nxt.fid ; 
    bcam_in_qid [ ( inst * 7 ) +: 7 ]            = p0_bcam_data_nxt.qid ; 
    bcam_in_hid [ ( inst * 16 ) +: 16 ]          = p0_bcam_data_nxt.hid ; 

    if ( arb_vac_winner_v == 0 ) begin
      error_cond_lookup_miss_empty = 1'b1 ;
    end
  end

  //.........................
  //bcam_pipe: Issue completion cnt=0 write (deallocate) to bcam pipeline & bcam module.
  // This must always win arbitration and cannot be held. 
  // Avoid contention with ARB_BCAM_ENQ_MISS since enqueue_lu and completion cannot be issued at same time at top of pipe (arb_cmd_reqs) & there is no backpressure
  if ( arb_bcam_winner_v & ( arb_bcam_winner == HQM_AQED_ARB_BCAM_CMP_CNT0 ) ) begin

    p0_bcam_ctrl_nxt.v                          = 1'b1 ;
    p0_bcam_ctrl_nxt.op                         = HQM_AQED_OP_BCAM_CMP_WEN ;
    p0_bcam_data_nxt.fid                        = p2_fidcnt_data_f.fid ;
    p0_bcam_data_nxt.qid                        = p2_fidcnt_data_f.qid ;
    p0_bcam_data_nxt.hid                        = p2_fidcnt_data_f.hid ;
    p0_bcam_data_nxt.hcw                        = '0 ;
    
    inst = p0_bcam_data_nxt.fid [ 10 : 8 ] ;
    bcam_in_valid [ ( inst * 1 ) +: 1 ]          = 1'b1 ; 
    bcam_in_op [ ( inst * 2 ) +: 2 ]             = p0_bcam_ctrl_nxt.op ; 
    bcam_in_fid [ ( inst * HQM_AQED_FID_WIDTH ) +: HQM_AQED_FID_WIDTH ]          = p0_bcam_data_nxt.fid ; 
    bcam_in_qid [ ( inst * 7 ) +: 7 ]            = p0_bcam_data_nxt.qid ; 
    bcam_in_hid [ ( inst * 16 ) +: 16 ]          = p0_bcam_data_nxt.hid ; 
  end

  //.........................
  //bcam_pipe: Issue enqueue Lookup to the bcam pipeline & bcam module
  // 
  if ( arb_cmd_winner_v & ( arb_cmd_winner == HQM_AQED_ARB_ENQ_LU ) ) begin
    in_enq_ack                                  = 1'b1 ;

    p0_bcam_ctrl_nxt.v                          = 1'b1 ;
    p0_bcam_ctrl_nxt.op                         = HQM_AQED_OP_BCAM_ENQ_CEN ;
    p0_bcam_data_nxt.fid                        = '0 ;
    p0_bcam_data_nxt.qid                        = in_enq_qid ;
    p0_bcam_data_nxt.hid                        = in_enq_hid ;
    p0_bcam_data_nxt.hcw                        = in_enq_data ;

    bcam_in_valid                               = { HQM_AQED_CNT { 1'b1 } } ;
    bcam_in_op                                  = { HQM_AQED_CNT { p0_bcam_ctrl_nxt.op } } ;
    bcam_in_fid                                 = { HQM_AQED_CNT { p0_bcam_data_nxt.fid } } ;
    bcam_in_qid                                 = { HQM_AQED_CNT { p0_bcam_data_nxt.qid } } ;
    bcam_in_hid                                 = { HQM_AQED_CNT { p0_bcam_data_nxt.hid } } ;
  end

  //.........................
  //fidcnt_pipe: Issue enqueue lookup fidcnt increment
  // This must always win arbitration and cannot be held
  if ( arb_fidcnt_winner_v & ( arb_fidcnt_winner == HQM_AQED_ARB_FIDCNT_ENQ ) ) begin

    p0_fidcnt_ctrl_nxt.v                        = 1'b1 ;
    p0_fidcnt_ctrl_nxt.op                       = HQM_AQED_OP_FIDCNT_ENQ ;
    p0_fidcnt_data_nxt.fid                      = out_enq_fid ; // get the hit or miss fid to increment the fid_cnt
    p0_fidcnt_data_nxt.qid                      = p2_bcam_data_f.qid ;
    p0_fidcnt_data_nxt.hid                      = p2_bcam_data_f.hid ;

    rmw_aqed_fid_cnt_p0_v_nxt                   = 1'b1 ; 
    rmw_aqed_fid_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_RMW ;
    rmw_aqed_fid_cnt_p0_addr_nxt                = { 1'b0 , p0_fidcnt_data_nxt.fid } ;
  end

  //.........................
  //fidcnt_pipe: Issue complete fidcnt decrement
  if ( arb_cmd_winner_v & ( arb_cmd_winner == HQM_AQED_ARB_CMP ) ) begin
    in_cmp_ack                                  = 1'b1 ;

    p0_fidcnt_ctrl_nxt.v                        = 1'b1 ;
    p0_fidcnt_ctrl_nxt.op                       = HQM_AQED_OP_FIDCNT_CMP ;
    p0_fidcnt_data_nxt.fid                      = in_cmp_fid ;
    p0_fidcnt_data_nxt.qid                      = in_cmp_qid ;
    p0_fidcnt_data_nxt.hid                      = in_cmp_hid ;

    rmw_aqed_fid_cnt_p0_v_nxt                   = 1'b1 ;
    rmw_aqed_fid_cnt_p0_rw_nxt                  = HQM_AW_RMWPIPE_RMW ;
    rmw_aqed_fid_cnt_p0_addr_nxt                = { 1'b0 , p0_fidcnt_data_nxt.fid } ;
  end

end

//....................................................................................................
//p1 bcam pipe stage
//p1 fidcnt pipe stage
always_comb begin

  //..................................................
  //pipe control
  p1_bcam_pipe = '0 ;
  p1_bcam_ctrl_nxt = '0 ;
  p1_bcam_data_nxt = p1_bcam_data_f ;

  p1_fidcnt_pipe = '0 ;
  p1_fidcnt_ctrl_nxt = '0 ;
  p1_fidcnt_data_nxt = p1_fidcnt_data_f ;

  //..................................................
  p1_bcam_ctrl_nxt.v                            = p0_bcam_ctrl_f.v ;
  if ( p0_bcam_ctrl_f.v ) begin
  p1_bcam_ctrl_nxt.op                           = p0_bcam_ctrl_f.op ;
  p1_bcam_data_nxt                              = p0_bcam_data_f ;
  end

  //..................................................
  p1_fidcnt_ctrl_nxt.v                          = p0_fidcnt_ctrl_f.v ;
  if ( p0_fidcnt_ctrl_f.v ) begin
  p1_fidcnt_ctrl_nxt.op                         = p0_fidcnt_ctrl_f.op ;
  p1_fidcnt_data_nxt                            = p0_fidcnt_data_f ;
  end

end


//....................................................................................................
//p2 bcam pipe stage
//p2 fidcnt pipe stage
always_comb begin

  residue_add_fid_cnt_a   = '0 ;
  residue_add_fid_cnt_b   = '0 ;
  residue_sub_fid_cnt_a   = '0 ;
  residue_sub_fid_cnt_b   = '0 ;
  residue_check_fid_cnt_r = '0 ;
  residue_check_fid_cnt_d = '0 ;
  residue_check_fid_cnt_e = '0 ;

  //..................................................
  error_cond_lookup_all_empty = '0 ;
  error_cond_pipeline = '0 ;

  rmw_aqed_fid_cnt_p3_bypsel_nxt = '0 ;
  rmw_aqed_fid_cnt_p3_bypdata_nxt = '0 ;

  out_enq_v = '0 ;
  out_enq_fid = '0 ;
  out_enq_data = '0 ;

  arb_hit_reqs                                  = bcam_out_hit ;
  arb_vac_reqs                                  = bcam_out_vac ;

  //..................................................
  //pipe control
  p2_bcam_pipe = '0 ;
  p2_bcam_ctrl_nxt = '0 ;
  p2_bcam_data_nxt = p2_bcam_data_f ;

  p2_fidcnt_pipe = '0 ;
  p2_fidcnt_ctrl_nxt = '0 ;
  p2_fidcnt_data_nxt = p2_fidcnt_data_f ;

  //..................................................
  p2_bcam_ctrl_nxt.v                            = p1_bcam_ctrl_f.v ;
  if ( p1_bcam_ctrl_f.v ) begin
  p2_bcam_ctrl_nxt.op                           = p1_bcam_ctrl_f.op ;
  p2_bcam_data_nxt                              = p1_bcam_data_f ;
  end
 
  //..................................................
  p2_fidcnt_ctrl_nxt.v                          = p1_fidcnt_ctrl_f.v ;
  if ( p1_fidcnt_ctrl_f.v ) begin
  p2_fidcnt_ctrl_nxt.op                         = p1_fidcnt_ctrl_f.op ;
  p2_fidcnt_data_nxt                            = p1_fidcnt_data_f ;
  end

debug_hit = '0 ;
debug_fidcnt_uf  = '0 ;
debug_fidcnt_of  = '0 ;
fid_cnt_new = '0 ;

  //..................................................
  // drive enqueue lookup compare result to ouptut port
  if ( p2_bcam_ctrl_f.v 
     & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) 
     ) begin

    out_enq_v                                   = ( arb_hit_winner_v | arb_vac_winner_v ) ;
    out_enq_data                                = p2_bcam_data_f.hcw ;
    if ( arb_hit_winner_v ) begin
debug_hit = 1'b1 ;
      out_enq_fid                               = bcam_out_fid [ ( arb_hit_winner * HQM_AQED_FID_WIDTH ) +: HQM_AQED_FID_WIDTH ] ; 
    end
    else if ( arb_vac_winner_v ) begin 
      out_enq_fid                               = bcam_out_fid [ ( arb_vac_winner * HQM_AQED_FID_WIDTH ) +: HQM_AQED_FID_WIDTH ] ; 

  if ( ( p0_bcam_ctrl_nxt.v & ( p0_bcam_ctrl_nxt.op == HQM_AQED_OP_BCAM_ENQ_CEN ) & ( p0_bcam_data_nxt.qid == p2_bcam_data_f.qid ) & ( p0_bcam_data_nxt.hid == p2_bcam_data_f.hid ))
     | ( p0_bcam_ctrl_f.v   & ( p0_bcam_ctrl_f.op   == HQM_AQED_OP_BCAM_ENQ_CEN ) & ( p0_bcam_data_f.qid   == p2_bcam_data_f.qid ) & ( p0_bcam_data_f.hid   == p2_bcam_data_f.hid ))
     | ( p1_bcam_ctrl_f.v   & ( p1_bcam_ctrl_f.op   == HQM_AQED_OP_BCAM_ENQ_CEN ) & ( p1_bcam_data_f.qid   == p2_bcam_data_f.qid ) & ( p1_bcam_data_f.hid   == p2_bcam_data_f.hid ))
     ) begin
    error_cond_pipeline = 1'b1 ;
  end

    end
    else begin
      error_cond_lookup_all_empty               = 1'b1 ;
    end 
  end

  aqed_lsp_dec_fid_cnt_v = '0 ;
  total_fid_cnt_nxt = total_fid_cnt_f ;
  //..................................................
  // increment fidcnt for enqueue miss
  if ( p2_fidcnt_ctrl_f.v
     & ( p2_fidcnt_ctrl_f.op == HQM_AQED_OP_FIDCNT_ENQ )
     ) begin
    total_fid_cnt_nxt = total_fid_cnt_f + { {( HQM_AQED_FID_CNT ){ 1'b0 }} , 1'b1 } ;
    rmw_aqed_fid_cnt_p3_bypsel_nxt              = 1'b1 ;
    fid_cnt_new = rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT ) - 1 : 0 ] + { {( HQM_AQED_FID_CNT - 1 ){ 1'b0 }} , 1'b1 } ;
    rmw_aqed_fid_cnt_p3_bypdata_nxt             = { residue_add_fid_cnt_r
                                                  , fid_cnt_new
                                                  };
if ( rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT ) - 1 : 0 ] == {( HQM_AQED_FID_CNT ){ 1'b1 }} ) begin
  debug_fidcnt_of = 1'b1 ;
end


    //return fid decrement to lsp when enqueue & fid hits (current fid_cnt not 0 )
    if ( ( rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT ) - 1 : 0 ] != { {( HQM_AQED_FID_CNT - 1 ){ 1'b0 }} , 1'b0 } )
       & ~( cfg_fid_decrement )
       )  begin
      aqed_lsp_dec_fid_cnt_v                     = 1'b1 ;
    end

    residue_add_fid_cnt_a                       = 2'd1 ;
    residue_add_fid_cnt_b                       = rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT + 2 ) - 1 : HQM_AQED_FID_CNT ] ;
    residue_check_fid_cnt_r                     = rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT + 2 ) - 1 : HQM_AQED_FID_CNT ] ;
    residue_check_fid_cnt_d                     = rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT ) - 1 : 0 ] ;
    residue_check_fid_cnt_e                     = 1'b1 ;
  end

  //..................................................
  // decrement fidcnt for completion
  if ( p2_fidcnt_ctrl_f.v
     & ( p2_fidcnt_ctrl_f.op == HQM_AQED_OP_FIDCNT_CMP )
     ) begin
    total_fid_cnt_nxt = total_fid_cnt_f - { {( HQM_AQED_FID_CNT ){ 1'b0 }} , 1'b1 } ;
    rmw_aqed_fid_cnt_p3_bypsel_nxt              = 1'b1 ;
    fid_cnt_new                                 =  rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT ) - 1 : 0 ] - { {( HQM_AQED_FID_CNT - 1 ){ 1'b0 }} , 1'b1 } ;
    rmw_aqed_fid_cnt_p3_bypdata_nxt             = { residue_sub_fid_cnt_r
                                                  , fid_cnt_new
                                                  };
if ( rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT ) - 1 : 0 ] == {( HQM_AQED_FID_CNT ){ 1'b0 }} ) begin
  debug_fidcnt_uf = 1'b1 ;
end

    //return fid decrement to lsp when last completion for fid is processed (current fid_cnt going to 0)
    if ( ( rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT ) - 1 : 0 ] == { {( HQM_AQED_FID_CNT - 1 ){ 1'b0 }} , 1'b1 } )
       | ( cfg_fid_decrement )
       ) begin
      aqed_lsp_dec_fid_cnt_v                    = 1'b1 ;
    end

    residue_sub_fid_cnt_a                       = 2'd1 ;
    residue_sub_fid_cnt_b                       = rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT + 2 ) - 1 : HQM_AQED_FID_CNT ] ;
    residue_check_fid_cnt_r                     = rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT + 2 ) - 1 : HQM_AQED_FID_CNT ] ;
    residue_check_fid_cnt_d                     = rmw_aqed_fid_cnt_p2_data_f [ ( HQM_AQED_FID_CNT ) - 1 : 0 ] ;
    residue_check_fid_cnt_e                     = 1'b1 ;
  end

end



//....................................................................................................
//p0 qidcnt pipe stage
always_comb begin

  //..................................................
  rw_aqed_qid_cnt_p0_v_nxt = '0 ;
  rw_aqed_qid_cnt_p0_rw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rw_aqed_qid_cnt_p0_addr_nxt = '0 ;
  rw_aqed_qid_cnt_p0_write_data_nxt = '0 ;
  rw_aqed_qid_cnt_p0_hold = '0 ;
  rw_aqed_qid_cnt_p1_hold = '0 ;
  rw_aqed_qid_cnt_p2_hold = '0 ;
  rw_aqed_qid_cnt_p3_hold = '0 ;

  rw_aqed_qid_fid_limit_p0_v_nxt = '0 ;
  rw_aqed_qid_fid_limit_p0_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_aqed_qid_fid_limit_p0_addr_nxt = '0 ;
  rw_aqed_qid_fid_limit_p0_write_data_nxt = '0 ;
  rw_aqed_qid_fid_limit_p0_hold = '0 ;
  rw_aqed_qid_fid_limit_p1_hold = '0 ;
  rw_aqed_qid_fid_limit_p2_hold = '0 ;
  rw_aqed_qid_fid_limit_p3_hold = '0 ;

  //..................................................
  p0_qidcnt_pipe = '0 ;
  p0_qidcnt_ctrl_nxt = '0 ;
  p0_qidcnt_data_nxt = p0_qidcnt_data_f ;

  //..................................................
  if ( ( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) & ~( |bcam_out_hit ) )
     | ( ( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_CMP_WEN ) ) )
     )  begin
    rw_aqed_qid_cnt_p0_v_nxt                    = 1'b1 ;
    rw_aqed_qid_cnt_p0_rw_nxt                   = HQM_AW_RMWPIPE_RMW ;
    rw_aqed_qid_cnt_p0_addr_nxt                 = p2_bcam_data_f.qid ;

    rw_aqed_qid_fid_limit_p0_v_nxt              = 1'b1 ;
    rw_aqed_qid_fid_limit_p0_rw_nxt             = HQM_AW_RWPIPE_READ ;
    rw_aqed_qid_fid_limit_p0_addr_nxt           = p2_bcam_data_f.qid ;

    p0_qidcnt_ctrl_nxt.v                        = 1'b1 ;
    p0_qidcnt_data_nxt.qid                      = p2_bcam_data_f.qid ;
    if ( ( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) & ~( |bcam_out_hit ) ) ) begin
      p0_qidcnt_ctrl_nxt.op                     = HQM_AQED_OP_QIDCNT_ENQ_P1 ;
    end
    if ( ( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_CMP_WEN ) ) ) begin
      p0_qidcnt_ctrl_nxt.op                     = HQM_AQED_OP_QIDCNT_CMP_M1 ;
    end 
  end

end

//....................................................................................................
//p1 qidcnt pipe stage
always_comb begin

  //..................................................
  p1_qidcnt_pipe = '0 ;
  p1_qidcnt_ctrl_nxt = '0 ;
  p1_qidcnt_data_nxt = p1_qidcnt_data_f ;

  //..................................................
  p1_qidcnt_ctrl_nxt.v                          = p0_qidcnt_ctrl_f.v ;
  p1_qidcnt_ctrl_nxt.op                         = p0_qidcnt_ctrl_f.op ;
  p1_qidcnt_data_nxt                            = p0_qidcnt_data_f ;

end

//....................................................................................................
//p2 qidcnt pipe stage
always_comb begin

  residue_add_qid_cnt_a   = '0 ;
  residue_add_qid_cnt_b   = '0 ;
  residue_sub_qid_cnt_a   = '0 ;
  residue_sub_qid_cnt_b   = '0 ;
  residue_check_qid_cnt_r = '0 ;
  residue_check_qid_cnt_d = '0 ;
  residue_check_qid_cnt_e = '0 ;

  //..................................................
  rw_aqed_qid_cnt_p3_bypsel_nxt = '0 ;
  rw_aqed_qid_cnt_p3_bypdata_nxt = '0 ; 
  
  aqed_lsp_fid_cnt_upd_v = aqed_lsp_fid_cnt_upd_v_f ;
  aqed_lsp_fid_cnt_upd_val = aqed_lsp_fid_cnt_upd_val_f ;
  aqed_lsp_fid_cnt_upd_qid = aqed_lsp_fid_cnt_upd_qid_f ;

  aqed_lsp_fid_cnt_upd_v_nxt = '0 ;
  aqed_lsp_fid_cnt_upd_val_nxt = aqed_lsp_fid_cnt_upd_val_f ;
  aqed_lsp_fid_cnt_upd_qid_nxt = aqed_lsp_fid_cnt_upd_qid_f ;

  //..................................................
  p2_qidcnt_pipe = '0 ;
  p2_qidcnt_ctrl_nxt = '0 ;
  p2_qidcnt_data_nxt = p2_qidcnt_data_f ;

  //..................................................
  p2_qidcnt_ctrl_nxt.v                          = p1_qidcnt_ctrl_f.v ;
  p2_qidcnt_ctrl_nxt.op                         = p1_qidcnt_ctrl_f.op ;
  p2_qidcnt_data_nxt                            = p1_qidcnt_data_f ;

  total_qid_cnt_nxt = total_qid_cnt_f ;

debug_qidcnt_uf  = '0 ;
debug_qidcnt_of  = '0 ;
qid_cnt_new = '0 ;

  //..................................................
  if ( p2_qidcnt_ctrl_f.v & ( p2_qidcnt_ctrl_f.op == HQM_AQED_OP_QIDCNT_ENQ_P1 ) ) begin
    total_qid_cnt_nxt = total_qid_cnt_f + { {( HQM_AQED_QID_CNT ){ 1'b0 }} , 1'b1 } ;
    rw_aqed_qid_cnt_p3_bypsel_nxt               = 1'b1 ;
    qid_cnt_new = rw_aqed_qid_cnt_p2_data_f [ ( HQM_AQED_QID_CNT ) - 1 : 0 ] + { {( HQM_AQED_QID_CNT - 1 ){ 1'b0 }} , 1'b1 } ;
    rw_aqed_qid_cnt_p3_bypdata_nxt              = { residue_add_qid_cnt_r , qid_cnt_new } ;

if (  rw_aqed_qid_cnt_p2_data_f [ ( HQM_AQED_QID_CNT ) - 1 : 0 ] == {( HQM_AQED_QID_CNT ){ 1'b1 }} ) begin
  debug_qidcnt_of = 1'b1 ;
end

    residue_add_qid_cnt_a   = 2'd1 ;
    residue_add_qid_cnt_b   = rw_aqed_qid_cnt_p2_data_f [ ( HQM_AQED_QID_CNT + 2 ) - 1 : HQM_AQED_QID_CNT ] ;
    residue_check_qid_cnt_r = rw_aqed_qid_cnt_p2_data_f [ ( HQM_AQED_QID_CNT + 2 ) - 1 : HQM_AQED_QID_CNT ] ;
    residue_check_qid_cnt_d = rw_aqed_qid_cnt_p2_data_f [ ( HQM_AQED_QID_CNT ) - 1 : 0 ] ;
    residue_check_qid_cnt_e = 1'b1 ;
  end
  if ( p2_qidcnt_ctrl_f.v & ( p2_qidcnt_ctrl_f.op == HQM_AQED_OP_QIDCNT_CMP_M1 ) ) begin
    total_qid_cnt_nxt = total_qid_cnt_f - { {( HQM_AQED_QID_CNT ){ 1'b0 }} , 1'b1 } ;
    rw_aqed_qid_cnt_p3_bypsel_nxt               = 1'b1 ;
    qid_cnt_new = rw_aqed_qid_cnt_p2_data_f [ ( HQM_AQED_QID_CNT ) - 1 : 0 ] - { {( HQM_AQED_QID_CNT - 1 ){ 1'b0 }} , 1'b1 } ;
    rw_aqed_qid_cnt_p3_bypdata_nxt              = { residue_sub_qid_cnt_r , qid_cnt_new } ;

if ( rw_aqed_qid_cnt_p2_data_f [ ( HQM_AQED_QID_CNT ) - 1 : 0 ] == {( HQM_AQED_QID_CNT ){ 1'b0 }} ) begin
  debug_qidcnt_uf = 1'b1 ;
end

    residue_sub_qid_cnt_a   = 2'd1 ;
    residue_sub_qid_cnt_b   = rw_aqed_qid_cnt_p2_data_f [ ( HQM_AQED_QID_CNT + 2 ) - 1 : HQM_AQED_QID_CNT ] ;
    residue_check_qid_cnt_r = rw_aqed_qid_cnt_p2_data_f [ ( HQM_AQED_QID_CNT + 2 ) - 1 : HQM_AQED_QID_CNT ] ;
    residue_check_qid_cnt_d = rw_aqed_qid_cnt_p2_data_f [ ( HQM_AQED_QID_CNT ) - 1 : 0 ] ;
    residue_check_qid_cnt_e = 1'b1 ;
  end

  parity_check_e = '0 ;
  parity_check_p = rw_aqed_qid_fid_limit_p2_data_f [ HQM_AQED_QID_CNT ] ;
  parity_check_d = rw_aqed_qid_fid_limit_p2_data_f [( HQM_AQED_QID_CNT - 1 ): 0 ] ;

  //..................................................
  // if qidcnt is above threshold then send lsp command to set bit to disable qid
  // if qidcnt is lte threshold then send lsp command to set bit to enable qid
  if ( rw_aqed_qid_cnt_p3_bypsel_nxt & ( rw_aqed_qid_cnt_p3_bypdata_nxt [ ( HQM_AQED_QID_CNT - 1 ) : 0 ] > rw_aqed_qid_fid_limit_p2_data_f [ ( HQM_AQED_QID_CNT - 1 ) : 0 ] ) ) begin
    parity_check_e = 1'b1 ;
    aqed_lsp_fid_cnt_upd_v_nxt                  = 1'b1 ;
    aqed_lsp_fid_cnt_upd_val_nxt                = 1'b0 ;
    aqed_lsp_fid_cnt_upd_qid_nxt                = p2_qidcnt_data_f.qid ;
  end
  if ( rw_aqed_qid_cnt_p3_bypsel_nxt & ( rw_aqed_qid_cnt_p3_bypdata_nxt [ ( HQM_AQED_QID_CNT - 1 ) : 0 ] <= rw_aqed_qid_fid_limit_p2_data_f [ ( HQM_AQED_QID_CNT - 1 ) : 0 ] ) ) begin
    parity_check_e = 1'b1 ;
    aqed_lsp_fid_cnt_upd_v_nxt                  = 1'b1 ;
    aqed_lsp_fid_cnt_upd_val_nxt                = 1'b1 ;
    aqed_lsp_fid_cnt_upd_qid_nxt                = p2_qidcnt_data_f.qid ;
  end





end



//====================================================================================================
`ifdef INTEL_INST_ON

always_ff @( posedge clk ) begin

if ($test$plusargs ("HQM_DEBUG_HIGH")) begin


if ( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) & ( arb_hit_winner_v  ) ) begin
$display ( "@%0tps [ FID_BCAM_DEBUG ] \
,%- 26s \
"
,$time
,"P2 BCAM ENQ_CEN HIT"
);
end

if ( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) & ( ~arb_hit_winner_v ) & ( arb_vac_winner_v  ) ) begin
$display ( "@%0tps [ FID_BCAM_DEBUG ] \
,%- 26s \
"
,$time
,"P2 BCAM ENQ_CEN MISS"
);
end

if ( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN ) ) begin
$display ( "\
, qid :%x \
, hid :%x \
, fid :%x \
\n"
, p2_bcam_data_f.qid
, p2_bcam_data_f.hid
, out_enq_fid
);
end



if ( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_WEN ) ) begin
$display ( "@%0tps [ FID_BCAM_DEBUG ] \
,%- 26s \
"
,$time
,"P2 BCAM ENQ_WEN"
);
end
if ( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_WEN ) ) begin
$display ( "\
, qid :%x \
, hid :%x \
, fid :%x \
\n"
, p2_bcam_data_f.qid
, p2_bcam_data_f.hid
, p2_bcam_data_f.fid
);
end




if ( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_CMP_WEN ) ) begin
$display ( "@%0tps [ FID_BCAM_DEBUG ] \
,%- 26s \
"
,$time
,"P2 BCAM CMP_WEN"
);
end
if ( p2_bcam_ctrl_f.v & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_CMP_WEN ) ) begin
$display ( "\
, qid :%x \
, hid :%x \
, fid :%x \
\n"
, p2_bcam_data_f.qid
, p2_bcam_data_f.hid
, p2_bcam_data_f.fid
);
end






if ( p2_fidcnt_ctrl_f.v & ( p2_fidcnt_ctrl_f.op == HQM_AQED_OP_FIDCNT_ENQ ) ) begin
$display ( "@%0tps [ FID_BCAM_DEBUG ] \
,%- 26s \
"
,$time
,"P2 FIDCNT ENQ "
);
end

if ( p2_fidcnt_ctrl_f.v & ( p2_fidcnt_ctrl_f.op == HQM_AQED_OP_FIDCNT_CMP ) ) begin
$display ( "@%0tps [ FID_BCAM_DEBUG ] \
,%- 26s \
"
,$time
,"P2 FIDCNT CMP "
);
end

if ( p2_fidcnt_ctrl_f.v ) begin
$display ( "\
, qid :%x \
, hid :%x \
, fid :%x \
, count :%x \
\n"
, p2_fidcnt_data_f.qid
, p2_fidcnt_data_f.hid
, p2_fidcnt_data_f.fid
, rmw_aqed_fid_cnt_p3_bypdata_nxt
);
end






if ( p2_qidcnt_ctrl_f.v & ( p2_qidcnt_ctrl_f.op == HQM_AQED_OP_QIDCNT_ENQ_P1 ) ) begin
$display ( "@%0tps [ FID_BCAM_DEBUG ] \
,%- 26s \
"
,$time
,"P2 QIDCNT ENQ_P1 "
);
end

if ( p2_qidcnt_ctrl_f.v & ( p2_qidcnt_ctrl_f.op == HQM_AQED_OP_QIDCNT_CMP_M1 ) ) begin
$display ( "@%0tps [ FID_BCAM_DEBUG ] \
,%- 26s \
"
,$time
,"P2 QIDCNT CMP_M1 "
);
end

if ( p2_fidcnt_ctrl_f.v ) begin
$display ( "\
, qid :%x \
, count :%x \
aqed_lsp_fid_cnt_upd_v :%x \
aqed_lsp_fid_cnt_upd_val :%x \
\n"
, p2_qidcnt_data_f.qid
, rw_aqed_qid_cnt_p3_bypdata_nxt
, aqed_lsp_fid_cnt_upd_v
, aqed_lsp_fid_cnt_upd_val
);
end









if ( ( aqed_lsp_dec_fid_cnt_v )
   & ( p2_fidcnt_ctrl_f.op == HQM_AQED_OP_FIDCNT_ENQ )
   )  begin
$display ( "@%0tps [ FID_BCAM_DEBUG ] \
,%- 26s \
\n"
,$time
,"AQED_LSP_DEC_FID ENQ"
);
end
if ( ( aqed_lsp_dec_fid_cnt_v )
   & ( p2_fidcnt_ctrl_f.op == HQM_AQED_OP_FIDCNT_CMP )
   )  begin
$display ( "@%0tps [ FID_BCAM_DEBUG ] \
,%- 26s \
\n"
,$time
,"AQED_LSP_DEC_FID CMP"
);
end







end

end










 `ifndef INTEL_SVA_OFF
  `HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_p2illegal0
                        , ( ( p2_fidcnt_ctrl_f.v  )
                          & ( p2_fidcnt_ctrl_f.op == HQM_AQED_OP_FIDCNT_CMP )
                          & ( p2_bcam_ctrl_f.v  )
                          & ( p2_bcam_ctrl_f.op == HQM_AQED_OP_BCAM_ENQ_CEN )
                          )
                        , clk
                        , ~rst_n
                        , `HQM_SVA_ERR_MSG ( "assert_forbidden_p2illegal0 : " )
                        , SDG_SVA_SOC_SIM
                        ) ;

     
 `endif
`endif

endmodule
