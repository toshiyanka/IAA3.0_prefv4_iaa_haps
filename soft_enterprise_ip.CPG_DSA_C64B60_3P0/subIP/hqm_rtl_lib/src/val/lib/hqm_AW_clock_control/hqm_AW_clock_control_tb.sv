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

logic ERROR , VERBOSE ;
logic [ ( 32 ) - 1 : 0 ] ERROR_CNT ;

////////////////////////////////////////////////////////////////////////////////////////////////////
localparam REQS = 2 ;
logic                              hqm_inp_gated_clk ;
logic                              hqm_inp_gated_rst_n ;
logic                              hqm_gated_clk ;
logic                              hqm_gated_rst_n ;
logic [ 16 - 1 : 0 ]               cfg_co_dly ;
logic                              cfg_co_disable ;
logic                              hqm_proc_clk_en ;
logic                              unit_idle_local ;
logic                              unit_idle ;
logic                              inp_fifo_empty_pre ;
logic [ REQS - 1 : 0 ]             inp_fifo_empty ;
logic [ REQS - 1 : 0 ]             inp_fifo_en ;
logic                              cfg_idle ;
logic                              int_idle ;
logic                              rst_prep ;
logic                              reset_active ;
hqm_AW_module_clock_control_core # (
  .REQS ( REQS )
) i_dut (
  .hqm_inp_gated_clk ( hqm_inp_gated_clk )
, .hqm_inp_gated_rst_n ( hqm_inp_gated_rst_n )
, .hqm_gated_clk ( hqm_gated_clk )
, .hqm_gated_rst_n ( hqm_gated_rst_n )
, .cfg_co_dly ( cfg_co_dly )
, .cfg_co_disable ( cfg_co_disable )
, .hqm_proc_clk_en ( hqm_proc_clk_en )
, .unit_idle_local ( unit_idle_local )
, .unit_idle ( unit_idle )
, .inp_fifo_empty_pre ( inp_fifo_empty_pre )
, .inp_fifo_empty ( inp_fifo_empty )
, .inp_fifo_en ( inp_fifo_en )
, .cfg_idle ( cfg_idle )
, .int_idle ( int_idle )
, .rst_prep ( rst_prep )
, .reset_active ( reset_active )
) ;
////////////////////////////////////////////////////////////////////////////////////////////////////

always #( ( 1.0 * clk_period ) / 2.0 ) clk_pre = ~clk_pre ;

assign clk = clk_pre & ~ clk_off ;

assign hqm_inp_gated_clk = clk ;
assign hqm_gated_clk =  hqm_proc_clk_en * ( clk ) ;

initial begin
  my_testid = 32'd0 ; my_string = "";
  VERBOSE = 1 ;
  ERROR = '0 ;
  ERROR_CNT = '0 ;
  $display ("TB: @%09tps BEGIN",$time, );
  hqm_inp_gated_rst_n = 'd0 ;
  hqm_gated_rst_n = 'd0 ;
  clk_period = 1 ; clk_pre = 'd1 ; clk_off = 'd0 ;



    ////////////////////////////////////////////////////////////////////////////////////////////////////
    cfg_co_dly                  = 16'd5 ;
    cfg_co_disable              = 1'b0 ;
    unit_idle_local             = '1 ;
    inp_fifo_empty_pre          = '1 ;
    inp_fifo_empty              = '1 ;
    cfg_idle                    = '1 ;
    int_idle                    = '1 ;
    rst_prep                    = '0 ;
    reset_active                = '0 ;

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    my_testid = my_testid + 32'd1 ; my_string = "SMOKE_OFF_ON_OFF";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    hqm_inp_gated_rst_n = 'd0 ;
    hqm_gated_rst_n = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    hqm_inp_gated_rst_n = 'd1 ;
    hqm_gated_rst_n = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    if ( i_dut.hqm_proc_clk_en != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );


    ////////////////////////////////////////////////////////////////////////////////////////////////////
    my_testid = my_testid + 32'd1 ; my_string = "SMOKE_OFFBYP";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    hqm_inp_gated_rst_n = 'd0 ;
    hqm_gated_rst_n = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    hqm_inp_gated_rst_n = 'd1 ;
    hqm_gated_rst_n = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    if ( i_dut.hqm_proc_clk_en != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

//turn clock back on, bypass_off is set to 2 clocks
    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.state_f         != 5'h8    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.state_f         != 5'h16   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.state_f         != 5'h16   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.state_f         != 5'h4    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 100 ) @ (posedge clk ) ;
    $display ("TB: @%09tps TEST  End   %2d %-22s ERR:%-d ERR_CNT:%-d",$time,my_testid,my_string,ERROR,ERROR_CNT );


    ////////////////////////////////////////////////////////////////////////////////////////////////////
    my_testid = my_testid + 32'd1 ; my_string = "RST_OFFBYP";
    $display ("TB: @%09tps TEST  Start %2d %-22s",$time,my_testid,my_string );
    hqm_inp_gated_rst_n = 'd0 ;
    hqm_gated_rst_n = 'd0 ;
    repeat ( 50 ) @ (posedge clk ) ;
    hqm_inp_gated_rst_n = 'd1 ;
    hqm_gated_rst_n = 'd1 ;
    repeat ( 50 ) @ (posedge clk ) ;

    if ( i_dut.hqm_proc_clk_en != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    repeat ( 50 ) @ (posedge clk ) ;

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd3    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

//turn clock back on, bypass_off is set to 2 clocks
    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.state_f         != 5'h8    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.state_f         != 5'h16   ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    inp_fifo_empty              = '1 ;
    hqm_inp_gated_rst_n = 'd0 ;
    hqm_gated_rst_n = 'd0 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.state_f         != 5'h1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end

    @ (posedge clk ) ;
    hqm_inp_gated_rst_n = 'd1 ;
    hqm_gated_rst_n = 'd1 ;
    #0.01
    if ( i_dut.hqm_proc_clk_en != 1'b0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.inp_fifo_en     != 2'd0    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.unit_idle       != 1'b1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end
    if ( i_dut.state_f         != 5'h1    ) begin ERROR = 1'b1 ; ERROR_CNT = ERROR_CNT + 32'd1 ; end


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
