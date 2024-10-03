module TB
import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_system_csr_pkg::*, hqm_system_type_pkg::*;
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


logic                                           hqm_gated_clk ;
logic                                           hqm_gated_rst_n ;
WRITE_BUFFER_CTL_t                              cfg_write_buffer_ctl ;
logic                                           cfg_sch_wb_ecc_enable ;
logic   [7:0]                                   cfg_inj_ecc_err_wbuf ;
logic                                           cfg_inj_par_err_wbuf ;
logic   [HQM_SYSTEM_AWIDTH_SCH_OUT_FIFO:0]      cfg_sch_out_fifo_high_wm ;
logic                                           cfg_cnt_clear ;
logic                                           cfg_cnt_clearv ;
logic                                           cfg_dir_cq_opt_clr ;
logic   [HQM_SYSTEM_DIR_CQ_WIDTH-1:0]           cfg_dir_cq_opt_clr_cq ;
logic                                           cfg_parity_off ;
func_t                                          pci_cfg_bme ;
logic                                           pci_cfg_sciov_en ;
logic                                           sch_wb_parity_error ;
logic   [3:0]                                   sch_wb_sb_ecc_error ;
logic   [3:0]                                   sch_wb_mb_ecc_error ;
logic   [7:0]                                   sch_wb_ecc_syndrome ;
logic                                           sch_sm_error ;
logic   [7:0]                                   sch_sm_syndrome ;
logic   [2:0]                                   sch_sm_drops ;
logic   [HQM_SYSTEM_DIR_CQ_WIDTH-1:0]           sch_sm_drops_comp ;
logic   [2:0]                                   sch_clr_drops ;
logic   [HQM_SYSTEM_DIR_CQ_WIDTH-1:0]           sch_clr_drops_comp ;
aw_fifo_status_t                                sch_out_fifo_status ;
logic   [6:0]                                   cq_occ_db_status ;
new_WBUF_STATUS_t                               wbuf_status ;
new_WBUF_STATUS2_t                              wbuf_status2 ;
new_WBUF_DEBUG_t                                wbuf_debug ;
logic                                           wbuf_idle ;
logic [1:0]                                     wbuf_appended ;
logic [21:10] [31:0]                            cfg_wbuf_cnts ;
logic [84:0]                                    cfg_ti_phdr_debug ;
logic [261:0]                                   cfg_ti_pdata_debug ;
WB_SCH_OUT_AFULL_AGITATE_CONTROL_t              wb_sch_out_afull_agitate_control ;
logic                                           hcw_sched_out_ready ;
logic                                           hcw_sched_out_v ;
hqm_system_sch_data_out_t                       hcw_sched_out ;
logic                                           cq_occ_int_busy ;
logic                                           cq_occ_int_v ;
interrupt_w_req_t                               cq_occ_int ;
logic                                           msi_msix_w_ready ;
logic                                           msi_msix_w_v ;
hqm_system_msi_msix_w_t                         msi_msix_w ;
logic                                           phdr_fifo_afull ;
logic                                           phdr_fifo_push ;
HqmPhCmd_t                                      phdr_fifo_push_data ;
logic   [31:0]                                  phdr_fifo_push_comp ;
logic                                           pdata_fifo_afull ;
logic                                           pdata_fifo_push ;
CdData_t                                        pdata_fifo_push_data ;
logic   [31:0]                                  pdata_fifo_push_comp ;
logic   [31:0]                                  pdata_fifo_push_value ;
hqm_system_memi_sch_out_fifo_t                  memi_sch_out_fifo ;
hqm_system_memo_sch_out_fifo_t                  memo_sch_out_fifo ;
hqm_system_write_buffer i_dut (
  .hqm_gated_clk ( clk )
, .hqm_gated_rst_n ( clk_rst_b )
, .cfg_write_buffer_ctl ( cfg_write_buffer_ctl )
, .cfg_sch_wb_ecc_enable ( cfg_sch_wb_ecc_enable )
, .cfg_inj_ecc_err_wbuf ( cfg_inj_ecc_err_wbuf )
, .cfg_inj_par_err_wbuf ( cfg_inj_par_err_wbuf )
, .cfg_sch_out_fifo_high_wm ( cfg_sch_out_fifo_high_wm )
, .cfg_cnt_clear ( cfg_cnt_clear )
, .cfg_cnt_clearv ( cfg_cnt_clearv )
, .cfg_dir_cq_opt_clr ( cfg_dir_cq_opt_clr )
, .cfg_dir_cq_opt_clr_cq ( cfg_dir_cq_opt_clr_cq )
, .cfg_parity_off ( cfg_parity_off )
, .pci_cfg_bme ( pci_cfg_bme )
, .pci_cfg_sciov_en ( pci_cfg_sciov_en )
, .sch_wb_parity_error ( sch_wb_parity_error )
, .sch_wb_sb_ecc_error ( sch_wb_sb_ecc_error )
, .sch_wb_mb_ecc_error ( sch_wb_mb_ecc_error )
, .sch_wb_ecc_syndrome ( sch_wb_ecc_syndrome )
, .sch_sm_error ( sch_sm_error )
, .sch_sm_syndrome ( sch_sm_syndrome )
, .sch_sm_drops ( sch_sm_drops )
, .sch_sm_drops_comp ( sch_sm_drops_comp )
, .sch_clr_drops ( sch_clr_drops )
, .sch_clr_drops_comp ( sch_clr_drops_comp )
, .sch_out_fifo_status ( sch_out_fifo_status )
, .cq_occ_db_status ( cq_occ_db_status )
, .wbuf_status ( wbuf_status )
, .wbuf_status2 ( wbuf_status2 )
, .wbuf_debug ( wbuf_debug )
, .wbuf_idle ( wbuf_idle )
, .wbuf_appended ( wbuf_appended )
, .cfg_wbuf_cnts ( cfg_wbuf_cnts )
, .cfg_ti_phdr_debug ( cfg_ti_phdr_debug )
, .cfg_ti_pdata_debug ( cfg_ti_pdata_debug )
, .wb_sch_out_afull_agitate_control ( wb_sch_out_afull_agitate_control )
, .hcw_sched_out_ready ( hcw_sched_out_ready )
, .hcw_sched_out_v ( hcw_sched_out_v )
, .hcw_sched_out ( hcw_sched_out )
, .cq_occ_int_busy ( cq_occ_int_busy )
, .cq_occ_int_v ( cq_occ_int_v )
, .cq_occ_int ( cq_occ_int )
, .msi_msix_w_ready ( msi_msix_w_ready )
, .msi_msix_w_v ( msi_msix_w_v )
, .msi_msix_w ( msi_msix_w )
, .phdr_fifo_afull ( phdr_fifo_afull )
, .phdr_fifo_push ( phdr_fifo_push )
, .phdr_fifo_push_data ( phdr_fifo_push_data )
, .phdr_fifo_push_comp ( phdr_fifo_push_comp )
, .pdata_fifo_afull ( pdata_fifo_afull )
, .pdata_fifo_push ( pdata_fifo_push )
, .pdata_fifo_push_data ( pdata_fifo_push_data )
, .pdata_fifo_push_comp ( pdata_fifo_push_comp )
, .pdata_fifo_push_value ( pdata_fifo_push_value )
, .memi_sch_out_fifo ( memi_sch_out_fifo )
, .memo_sch_out_fifo ( memo_sch_out_fifo )
) ;
hqm_assertion_ram #(
  .DEPTH ( 128 )
, .DWIDTH ( 259 )
) i_hqm_assertion_ram (
  .clk ( clk )
, .rst_n ( clk_rst_b )
, .rst_val ( 33152'b0 )
, .ram_we ( memi_sch_out_fifo.we )
, .ram_waddr ( memi_sch_out_fifo.waddr )
, .ram_wdata ( memi_sch_out_fifo.wdata )
, .ram_we2 ( '0 )
, .ram_waddr2 ( '0 )
, .ram_wdata2 ( '0 )
, .ram_re ( memi_sch_out_fifo.re )
, .ram_raddr ( memi_sch_out_fifo.raddr )
, .ram_rdata ( memo_sch_out_fifo.rdata )
);
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
    cfg_write_buffer_ctl = '0 ;
    cfg_sch_wb_ecc_enable = '0 ;
    cfg_inj_ecc_err_wbuf = '0 ;
    cfg_inj_par_err_wbuf = '0 ;
    cfg_sch_out_fifo_high_wm = '0 ;
    cfg_cnt_clear = '0 ;
    cfg_cnt_clearv = '0 ;
    cfg_dir_cq_opt_clr = '0 ;
    cfg_dir_cq_opt_clr_cq = '0 ;
    cfg_parity_off = '0 ;
    pci_cfg_bme = '0 ;
    pci_cfg_sciov_en = '0 ;
    wb_sch_out_afull_agitate_control = '0 ;
    hcw_sched_out_v = '0 ;
    hcw_sched_out = '0 ;
    cq_occ_int_busy = '0 ;
    msi_msix_w_v = '0 ;
    msi_msix_w = '0 ;
    phdr_fifo_afull = '0 ;
    pdata_fifo_afull = '0 ;

    my_testid = my_testid + 32'd1 ; my_string = "RESET";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;



    // configure
    cfg_sch_wb_ecc_enable        = 1'b1 ;
    cfg_sch_out_fifo_high_wm     = 8'h7f ;
    pci_cfg_bme                  = 17'h1ffff ;


    @ (posedge clk ) ;
    #0.01             
    hcw_sched_out_v              = 1'd0 ;
    hcw_sched_out.error          = 1'd0 ;
    hcw_sched_out.vas_gen        = 2'd0 ;
    hcw_sched_out.ecc            = 16'd0 ;
    hcw_sched_out.ro             = 1'd0 ;
    hcw_sched_out.at             = 2'd0 ;
    hcw_sched_out.pasidtlp       = 23'd0 ;
    hcw_sched_out.is_pf          = 1'd0 ;
    hcw_sched_out.vf             = 4'd0 ;
    hcw_sched_out.cq_addr        = 60'd0 ; //63:4
    hcw_sched_out.int_v          = 1'd0 ;
    hcw_sched_out.int_d          = 7'd0 ;
    hcw_sched_out.hcw_v          = 1'd0 ;
    hcw_sched_out.w              = 159'h0 ;

    cq_occ_int_busy              = 1'd0 ;

    msi_msix_w_v                 = 1'd0 ;
    msi_msix_w.ai                = 1'd0 ;
    msi_msix_w.is_pf             = 1'd0 ;
    msi_msix_w.vf                = 4'd0 ;
    msi_msix_w.addr              = 64'd0 ;
    msi_msix_w.data              = 32'd0 ;
    
//  phdr_fifo_push_data.par      //[3:0]
//  phdr_fifo_push_data.invalid  //
//  phdr_fifo_push_data.ro       //
//  phdr_fifo_push_data.at       //[1:0]
//  phdr_fifo_push_data.pasidtlp //
//  phdr_fifo_push_data.rid      //[4:0]
//  phdr_fifo_push_data.length   //[9:0]
//  phdr_fifo_push_data.add      //[63:0]
//  
//  pdata_fifo_push_data.sop     //
//  pdata_fifo_push_data.eop     //
//  pdata_fifo_push_data.error   //
//  pdata_fifo_push_data.dpar    //[7:0]
//  pdata_fifo_push_data.data    //[255:0]





    my_testid = my_testid + 32'd1 ; my_string = "OVERFLOW";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    clk_rst_b = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    clk_rst_b = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    // configure
    cfg_sch_wb_ecc_enable        = 1'b1 ;
    cfg_sch_out_fifo_high_wm     = 8'h7f ;
    pci_cfg_bme                  = 17'h1ffff ;

    phdr_fifo_afull = '1 ;
    pdata_fifo_afull = '1 ;

for ( int i = 0 ; i < 128 ; i++ ) begin
    @ (posedge clk ) ;
    #0.01             
    hcw_sched_out_v              = 1'd1 ;
    hcw_sched_out.error          = 1'd0 ;
    hcw_sched_out.vas_gen        = 2'd0 ;
    hcw_sched_out.ecc            = 16'd0 ;
    hcw_sched_out.ro             = 1'd0 ;
    hcw_sched_out.at             = 2'd0 ;
    hcw_sched_out.pasidtlp       = 23'd0 ;
    hcw_sched_out.is_pf          = 1'd0 ;
    hcw_sched_out.vf             = 4'd0 ;
    hcw_sched_out.cq_addr        = 60'd0 ; //63:4
    hcw_sched_out.int_v          = 1'd0 ;
    hcw_sched_out.int_d          = 7'd0 ;
    hcw_sched_out.hcw_v          = 1'd1 ;
    hcw_sched_out.w              = 159'h0 ;
    
    cq_occ_int_busy              = 1'd0 ;
    
    msi_msix_w_v                 = 1'd0 ;
    msi_msix_w.ai                = 1'd0 ;
    msi_msix_w.is_pf             = 1'd0 ;
    msi_msix_w.vf                = 4'd0 ;
    msi_msix_w.addr              = 64'd0 ;
    msi_msix_w.data              = 32'd0 ;
end

for ( int i = 0 ; i < 4 ; i++ ) begin
    @ (posedge clk ) ;
    #0.01             
    hcw_sched_out_v              = 1'd1 ;
    hcw_sched_out.error          = 1'd1 ;
    hcw_sched_out.vas_gen        = 2'd0 ;
    hcw_sched_out.ecc            = 16'd0 ;
    hcw_sched_out.ro             = 1'd0 ;
    hcw_sched_out.at             = 2'd0 ;
    hcw_sched_out.pasidtlp       = 23'd0 ;
    hcw_sched_out.is_pf          = 1'd0 ;
    hcw_sched_out.vf             = 4'd0 ;
    hcw_sched_out.cq_addr        = 60'd0 ; //63:4
    hcw_sched_out.int_v          = 1'd0 ;
    hcw_sched_out.int_d          = 7'd0 ;
    hcw_sched_out.hcw_v          = 1'd0 ; //cannot set both error & hcw_v
    hcw_sched_out.w              = 159'h0 ;
end

    @ (posedge clk ) ;
    #0.01             
    hcw_sched_out_v              = 1'd0 ;
    hcw_sched_out.error          = 1'd0 ;
    hcw_sched_out.vas_gen        = 2'd0 ;
    hcw_sched_out.ecc            = 16'd0 ;
    hcw_sched_out.ro             = 1'd0 ;
    hcw_sched_out.at             = 2'd0 ;
    hcw_sched_out.pasidtlp       = 23'd0 ;
    hcw_sched_out.is_pf          = 1'd0 ;
    hcw_sched_out.vf             = 4'd0 ;
    hcw_sched_out.cq_addr        = 60'd0 ; //63:4
    hcw_sched_out.int_v          = 1'd0 ;
    hcw_sched_out.int_d          = 7'd0 ;
    hcw_sched_out.hcw_v          = 1'd0 ;
    hcw_sched_out.w              = 159'h0 ;























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
