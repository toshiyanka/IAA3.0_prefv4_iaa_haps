module TB
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
#(
) (
);


initial begin
  $vcdplusfile("dump.vpd");
  $vcdpluson();
  $vcdplusmemon();
end

string my_string ;
logic [ 31 : 0 ] my_testid ;

logic clk_rst_b ;
integer clk_period ;
logic clk , clk_pre , clk_off ;
integer rclk_period ;
logic rclk , rclk_pre , rclk_off ;
integer wclk_period ;
logic wclk , wclk_pre , wclk_off ;

logic ERROR , VERBOSE ;
logic [ ( 32 ) - 1 : 0 ] ERROR_CNT ;

////////////////////////////////////////////////////////////////////////////////////////////////////
localparam MODULE = HQM_CHP_CFG_NODE_ID ;
localparam NUM_CFG_TARGETS = HQM_CHP_CFG_UNIT_NUM_TGTS ;
localparam NUM_CFG_ACCESSIBLE_RAM = 22 ; // from hqm_credit_hist_pipe_core.sv : localparam NUM_CFG_ACCESSIBLE_RAM = 22 ;
cfg_req_t                                         unit_cfg_req ;
logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             unit_cfg_req_write ;
logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             unit_cfg_req_read ;
logic                                             unit_cfg_rsp_ack ;
logic                                             unit_cfg_rsp_err ;
logic [ ( 32 ) - 1 : 0 ]                          unit_cfg_rsp_rdata ;
cfg_req_t                                         pfcsr_cfg_req ;
logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             pfcsr_cfg_req_write ;
logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             pfcsr_cfg_req_read ;
logic                                             pfcsr_cfg_rsp_ack ;
logic                                             pfcsr_cfg_rsp_err ;
logic [ ( 32 ) - 1 : 0 ]                          pfcsr_cfg_rsp_rdata ;
logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             cfg_req_write ;
logic [ ( NUM_CFG_TARGETS ) - 1 : 0 ]             cfg_req_read ;
logic [ ( NUM_CFG_ACCESSIBLE_RAM * 1 ) - 1 : 0 ]  cfg_mem_re ;
logic [ ( NUM_CFG_ACCESSIBLE_RAM * 1 ) - 1 : 0 ]  cfg_mem_we ;
logic [ ( 20 ) - 1 : 0 ]                          cfg_mem_addr ;
logic [ ( 12 ) - 1 : 0 ]                          cfg_mem_minbit ;
logic [ ( 12 ) - 1 : 0 ]                          cfg_mem_maxbit ;
logic [ ( 32 ) - 1 : 0 ]                          cfg_mem_wdata ;
logic [ ( NUM_CFG_ACCESSIBLE_RAM * 32 ) - 1 : 0 ] cfg_mem_rdata ;
logic [ ( NUM_CFG_ACCESSIBLE_RAM * 1 ) - 1 : 0 ]  cfg_mem_ack ;
logic                                             cfg_req_idlepipe ;
logic                                             cfg_req_ready ;
logic                                             cfg_timout_enable ;
logic [ ( 16 ) - 1 : 0 ]                          cfg_timout_threshold ;
hqm_AW_cfg_sc # (
    .MODULE                             ( MODULE )
  , .NUM_CFG_TARGETS                    ( NUM_CFG_TARGETS )
  , .NUM_CFG_ACCESSIBLE_RAM             ( NUM_CFG_ACCESSIBLE_RAM )
) i_dut (
    .hqm_gated_clk                      ( clk )
  , .hqm_gated_rst_n                    ( clk_rst_b )
  , .unit_cfg_req                       ( unit_cfg_req )
  , .unit_cfg_req_write                 ( unit_cfg_req_write )
  , .unit_cfg_req_read                  ( unit_cfg_req_read )
  , .unit_cfg_rsp_ack                   ( unit_cfg_rsp_ack )
  , .unit_cfg_rsp_err                   ( unit_cfg_rsp_err )
  , .unit_cfg_rsp_rdata                 ( unit_cfg_rsp_rdata )
  , .pfcsr_cfg_req                      ( pfcsr_cfg_req )
  , .pfcsr_cfg_req_write                ( pfcsr_cfg_req_write )
  , .pfcsr_cfg_req_read                 ( pfcsr_cfg_req_read )
  , .pfcsr_cfg_rsp_ack                  ( pfcsr_cfg_rsp_ack )
  , .pfcsr_cfg_rsp_err                  ( pfcsr_cfg_rsp_err )
  , .pfcsr_cfg_rsp_rdata                ( pfcsr_cfg_rsp_rdata )
  , .cfg_req_write                      ( cfg_req_write )
  , .cfg_req_read                       ( cfg_req_read )
  , .cfg_mem_re                         ( cfg_mem_re )
  , .cfg_mem_we                         ( cfg_mem_we )
  , .cfg_mem_addr                       ( cfg_mem_addr )
  , .cfg_mem_minbit                     ( cfg_mem_minbit )
  , .cfg_mem_maxbit                     ( cfg_mem_maxbit )
  , .cfg_mem_wdata                      ( cfg_mem_wdata )
  , .cfg_mem_rdata                      ( cfg_mem_rdata )
  , .cfg_mem_ack                        ( cfg_mem_ack )
  , .cfg_req_idlepipe                   ( cfg_req_idlepipe )
  , .cfg_req_ready                      ( cfg_req_ready )
  , .cfg_timout_enable                  ( cfg_timout_enable )
  , .cfg_timout_threshold               ( cfg_timout_threshold )
) ;
//SNOOP signals for DEBUG
logic TB_timeout ; assign TB_timeout = ( i_dut.timer_f >= i_dut.cfg_timout_threshold ) ;
////////////////////////////////////////////////////////////////////////////////////////////////////

always #( ( 1.0 * clk_period ) / 2.0 ) clk_pre = ~clk_pre ;
always #( ( 1.0 * rclk_period ) / 2.0 ) rclk_pre = ~rclk_pre ;
always #( ( 1.0 * wclk_period ) / 2.0 ) wclk_pre = ~wclk_pre ;

assign clk = clk_pre & ~ clk_off ;
assign rclk = rclk_pre & ~ rclk_off ;
assign wclk = wclk_pre & ~ wclk_off ;

initial begin
  my_testid = 32'd0 ; my_string = "";
  VERBOSE = 1 ;
  ERROR = '0 ;
  ERROR_CNT = '0 ;
  $display ("TB: @%09tps BEGIN",$time, );
  clk_rst_b = 'd0 ;
  clk_period = 1 ; clk_pre = 'd1 ; clk_off = 'd0 ;
  rclk_period = 1 ; rclk_pre = 'd1 ; rclk_off = 'd0 ;
  wclk_period = 1 ; wclk_pre = 'd1 ; wclk_off = 'd0 ;










    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_IDLE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    #0.01
    //START RESET       
    clk_rst_b = 'd0 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET                                                        
    clk_rst_b = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_BUSY";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_WAIT";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_ACK0";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_ACK1";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_ISSUE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_RAM_ACCESS";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_RAM_ACCESS1";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_mem_ack                                                       = '1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS1 ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&~unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_REG_ACCESS";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_REG_ACCESS1";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    pfcsr_cfg_rsp_ack                                                 = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS1 ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&~unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_ERR";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00]      = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00]      = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_ERR         ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_TO";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "RS_CFG_DONE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_mem_ack                                                       = '1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS1 ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&~unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_mem_ack                                                       = '0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    //START RESET
    clk_rst_b                                                         = 'd0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    //END RESET
    clk_rst_b                                                         = 'd1 ;
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );










    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_CFG_IDLE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&unit_cfg_rsp_err) ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );


    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRM_CFG_BUSY";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDM_CFG_BUSY";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRF_CFG_BUSY";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&unit_cfg_rsp_err) ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDF_CFG_BUSY";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]          = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]          = 1'b0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&unit_cfg_rsp_err) ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    
    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    
    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    
    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRM_CFG_WAIT";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&unit_cfg_rsp_err) ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDM_CFG_WAIT";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&unit_cfg_rsp_err) ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRM_CFG_ACK0";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDM_CFG_ACK0";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRM_CFG_ACK1";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDM_CFG_ACK1";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRM_CFG_ISSUE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDM_CFG_ISSUE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRF_CFG_ISSUE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDF_CFG_ISSUE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]          = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]          = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRM_CFG_RAM_ACCESS";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDM_CFG_RAM_ACCESS";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRM_CFG_RAM_ACCESS1";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_mem_ack                                                       = '1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS1 ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&~unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDM_CFG_RAM_ACCESS1";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_mem_ack                                                       = '1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS1 ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&~unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRF_CFG_REG_ACCESS";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDF_CFG_REG_ACCESS";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]          = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]          = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRF_CFG_REG_ACCESS1";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    pfcsr_cfg_rsp_ack                                                 = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS1 ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&~unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDF_CFG_REG_ACCESS1";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]          = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]          = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    pfcsr_cfg_rsp_ack                                                 = 1'b1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS1 ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&~unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRM_CFG_DONE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_mem_ack                                                       = '1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS1 ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&~unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_mem_ack                                                       = '0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDM_CFG_DONE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_WAIT    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ACK1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_req_ready                                                     = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_mem_ack                                                       = '1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_RAM_ACCESS1 ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&~unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_mem_ack                                                       = '0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRF_CFG_DONE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]         = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    pfcsr_cfg_rsp_ack                                                 = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS1 ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&~unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    pfcsr_cfg_rsp_ack                                                 = 1'b0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_RDF_CFG_DONE";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]          = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00]          = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REQ_ISSUE   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    pfcsr_cfg_rsp_ack                                                 = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_REG_ACCESS1 ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack&~unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    pfcsr_cfg_rsp_ack                                                 = 1'b0 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRF_CFG_ERR";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00]      = 1'b1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00]      = 1'b0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_ERR         ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_WRM_CFG_ERR";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b1 ; 
    unit_cfg_req.addr.offset                                          = 38'd65 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    unit_cfg_req_write[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]            = 1'b0 ;
    unit_cfg_req.addr.offset                                          = 38'h0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_ERR         ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;
    
    my_testid = my_testid + 32'd1 ; my_string = "TO_RDM_CFG_ERR";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;
    
    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    
    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]             = 1'b1 ;
    unit_cfg_req.addr.offset                                          = 38'd65 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    
    @ (posedge clk ) ;
    unit_cfg_req_read[HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL]             = 1'b0 ;
    unit_cfg_req.addr.offset                                          = 38'h0 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_BUSY        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    
    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_ERR         ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    
    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    
    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    
    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    
    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    unit_cfg_req                                                      = '0 ;
    unit_cfg_req_write                                                = '0 ;
    unit_cfg_req_read                                                 = '0 ;
    pfcsr_cfg_rsp_ack                                                 = '0 ;
    pfcsr_cfg_rsp_err                                                 = '0 ;
    pfcsr_cfg_rsp_rdata                                               = '0 ;
    cfg_mem_rdata                                                     = '0 ;
    cfg_mem_ack                                                       = '0 ;
    cfg_req_ready                                                     = '0 ;
    cfg_timout_enable                                                 = '0 ;
    cfg_timout_threshold                                              = 16'hffff ;

    my_testid = my_testid + 32'd1 ; my_string = "TO_CFG_TO";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    cfg_timout_enable                                                 = 1'h1 ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'h0000 ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    cfg_timout_threshold                                              = 16'hffff ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_TO          ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if (~(unit_cfg_rsp_ack& unit_cfg_rsp_err)) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_DONE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    #0.01
    if ( i_dut.sm_f != i_dut.CFG_IDLE        ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( (unit_cfg_rsp_ack)                  ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );










  repeat ( 100 ) @ (posedge clk ) ;
  if (ERROR) begin
    $error ("TB: @%09tps ERROR                              ERR:%-d ERR_CNT:%-d",$time,ERROR,ERROR_CNT );
    $fatal ("TB: @%09tps FATAL                              ERR:%-d ERR_CNT:%-d",$time,ERROR,ERROR_CNT );
  end
  else begin
    $display ("TB: @%09tps PASS",$time);
    $finish ;
  end
end


endmodule
