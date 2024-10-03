`ifdef INTEL_INST_ON

module hqm_qed_pipe_inst import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();


wire [63:0] DECODE_PIPE[1:0];
assign DECODE_PIPE[0]="ENQ from rop_qed_qed_enq";
assign DECODE_PIPE[1]="DEQ/READ from dp_qed";

`ifdef INTEL_INST_ON

logic clk;
logic rst_n;
assign clk =  hqm_qed_pipe_core.hqm_gated_clk;
assign rst_n =  hqm_qed_pipe_core.hqm_gated_rst_n;


logic [ ( 32 ) - 1 : 0 ] PERF_counter_nxt , PERF_counter_f ;

logic [ ( 32 ) - 1 : 0 ] PERF_counter_inc_1rdy_1sel_nxt , PERF_counter_inc_1rdy_1sel_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_counter_inc_2rdy_1sel_nxt , PERF_counter_inc_2rdy_1sel_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_counter_inc_2rdy_2sel_nxt , PERF_counter_inc_2rdy_2sel_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_counter_inc_3rdy_1sel_nxt , PERF_counter_inc_3rdy_1sel_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_counter_inc_3rdy_2sel_nxt , PERF_counter_inc_3rdy_2sel_f ;

logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_rop_qed_dqed_enq_valid_first_nxt , PERF_rx_sync_rop_qed_dqed_enq_valid_first_f ;
logic PERF_rx_sync_rop_qed_dqed_enq_valid_firstv_nxt , PERF_rx_sync_rop_qed_dqed_enq_valid_firstv_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_rop_qed_dqed_enq_valid_last_nxt , PERF_rx_sync_rop_qed_dqed_enq_valid_last_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_rop_qed_dqed_enq_valid_total_nxt , PERF_rx_sync_rop_qed_dqed_enq_valid_total_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_rop_qed_dqed_enq_valid_ready_nxt , PERF_rx_sync_rop_qed_dqed_enq_valid_ready_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_rop_qed_dqed_enq_valid_notready_nxt , PERF_rx_sync_rop_qed_dqed_enq_valid_notready_f ;

logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_nalb_qed_valid_first_nxt , PERF_rx_sync_nalb_qed_valid_first_f ;
logic PERF_rx_sync_nalb_qed_valid_firstv_nxt , PERF_rx_sync_nalb_qed_valid_firstv_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_nalb_qed_valid_last_nxt , PERF_rx_sync_nalb_qed_valid_last_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_nalb_qed_valid_total_nxt , PERF_rx_sync_nalb_qed_valid_total_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_nalb_qed_valid_ready_nxt , PERF_rx_sync_nalb_qed_valid_ready_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_nalb_qed_valid_notready_nxt , PERF_rx_sync_nalb_qed_valid_notready_f ;

logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_dp_dqed_valid_first_nxt , PERF_rx_sync_dp_dqed_valid_first_f ;
logic PERF_rx_sync_dp_dqed_valid_firstv_nxt , PERF_rx_sync_dp_dqed_valid_firstv_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_dp_dqed_valid_last_nxt , PERF_rx_sync_dp_dqed_valid_last_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_dp_dqed_valid_total_nxt , PERF_rx_sync_dp_dqed_valid_total_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_dp_dqed_valid_ready_nxt , PERF_rx_sync_dp_dqed_valid_ready_f ;
logic [ ( 32 ) - 1 : 0 ] PERF_rx_sync_dp_dqed_valid_notready_nxt , PERF_rx_sync_dp_dqed_valid_notready_f ;

always_ff @ ( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
PERF_counter_f <= '0 ;

PERF_counter_inc_1rdy_1sel_f <= '0 ;
PERF_counter_inc_2rdy_1sel_f <= '0 ;
PERF_counter_inc_2rdy_2sel_f <= '0 ;
PERF_counter_inc_3rdy_1sel_f <= '0 ;
PERF_counter_inc_3rdy_2sel_f <= '0 ;

PERF_rx_sync_rop_qed_dqed_enq_valid_first_f <= '0 ;
PERF_rx_sync_rop_qed_dqed_enq_valid_firstv_f <= '0 ;
PERF_rx_sync_rop_qed_dqed_enq_valid_last_f <= '0 ;
PERF_rx_sync_rop_qed_dqed_enq_valid_total_f <= '0 ;
PERF_rx_sync_rop_qed_dqed_enq_valid_ready_f <= '0 ;
PERF_rx_sync_rop_qed_dqed_enq_valid_notready_f <= '0 ;

PERF_rx_sync_nalb_qed_valid_first_f <= '0 ;
PERF_rx_sync_nalb_qed_valid_firstv_f <= '0 ;
PERF_rx_sync_nalb_qed_valid_last_f <= '0 ;
PERF_rx_sync_nalb_qed_valid_total_f <= '0 ;
PERF_rx_sync_nalb_qed_valid_ready_f <= '0 ;
PERF_rx_sync_nalb_qed_valid_notready_f <= '0 ;

PERF_rx_sync_dp_dqed_valid_first_f <= '0 ;
PERF_rx_sync_dp_dqed_valid_firstv_f <= '0 ;
PERF_rx_sync_dp_dqed_valid_last_f <= '0 ;
PERF_rx_sync_dp_dqed_valid_total_f <= '0 ;
PERF_rx_sync_dp_dqed_valid_ready_f <= '0 ;
PERF_rx_sync_dp_dqed_valid_notready_f <= '0 ;
  end else begin
PERF_counter_f <= PERF_counter_nxt ;

PERF_counter_inc_1rdy_1sel_f <= PERF_counter_inc_1rdy_1sel_nxt ;
PERF_counter_inc_2rdy_1sel_f <= PERF_counter_inc_2rdy_1sel_nxt ;
PERF_counter_inc_2rdy_2sel_f <= PERF_counter_inc_2rdy_2sel_nxt ;
PERF_counter_inc_3rdy_1sel_f <= PERF_counter_inc_3rdy_1sel_nxt ;
PERF_counter_inc_3rdy_2sel_f <= PERF_counter_inc_3rdy_2sel_nxt ;

PERF_rx_sync_rop_qed_dqed_enq_valid_first_f <= PERF_rx_sync_rop_qed_dqed_enq_valid_first_nxt ;
PERF_rx_sync_rop_qed_dqed_enq_valid_firstv_f <= PERF_rx_sync_rop_qed_dqed_enq_valid_firstv_nxt ;
PERF_rx_sync_rop_qed_dqed_enq_valid_last_f <= PERF_rx_sync_rop_qed_dqed_enq_valid_last_nxt ;
PERF_rx_sync_rop_qed_dqed_enq_valid_total_f <= PERF_rx_sync_rop_qed_dqed_enq_valid_total_nxt ;
PERF_rx_sync_rop_qed_dqed_enq_valid_ready_f <= PERF_rx_sync_rop_qed_dqed_enq_valid_ready_nxt ;
PERF_rx_sync_rop_qed_dqed_enq_valid_notready_f <= PERF_rx_sync_rop_qed_dqed_enq_valid_notready_nxt ;

PERF_rx_sync_nalb_qed_valid_first_f <= PERF_rx_sync_nalb_qed_valid_first_nxt ;
PERF_rx_sync_nalb_qed_valid_firstv_f <= PERF_rx_sync_nalb_qed_valid_firstv_nxt ;
PERF_rx_sync_nalb_qed_valid_last_f <= PERF_rx_sync_nalb_qed_valid_last_nxt ;
PERF_rx_sync_nalb_qed_valid_total_f <= PERF_rx_sync_nalb_qed_valid_total_nxt ;
PERF_rx_sync_nalb_qed_valid_ready_f <= PERF_rx_sync_nalb_qed_valid_ready_nxt ;
PERF_rx_sync_nalb_qed_valid_notready_f <= PERF_rx_sync_nalb_qed_valid_notready_nxt ;

PERF_rx_sync_dp_dqed_valid_first_f <= PERF_rx_sync_dp_dqed_valid_first_nxt ;
PERF_rx_sync_dp_dqed_valid_firstv_f <= PERF_rx_sync_dp_dqed_valid_firstv_nxt ;
PERF_rx_sync_dp_dqed_valid_last_f <= PERF_rx_sync_dp_dqed_valid_last_nxt ;
PERF_rx_sync_dp_dqed_valid_total_f <= PERF_rx_sync_dp_dqed_valid_total_nxt ;
PERF_rx_sync_dp_dqed_valid_ready_f <= PERF_rx_sync_dp_dqed_valid_ready_nxt ;
PERF_rx_sync_dp_dqed_valid_notready_f <= PERF_rx_sync_dp_dqed_valid_notready_nxt ;
  end
end

always_comb begin
PERF_counter_nxt = PERF_counter_f + 32'd1 ;

PERF_counter_inc_1rdy_1sel_nxt = PERF_counter_inc_1rdy_1sel_f + hqm_qed_pipe_core.counter_inc_1rdy_1sel ;
PERF_counter_inc_2rdy_1sel_nxt = PERF_counter_inc_2rdy_1sel_f + hqm_qed_pipe_core.counter_inc_2rdy_1sel ;
PERF_counter_inc_2rdy_2sel_nxt = PERF_counter_inc_2rdy_2sel_f + hqm_qed_pipe_core.counter_inc_2rdy_2sel ;
PERF_counter_inc_3rdy_1sel_nxt = PERF_counter_inc_3rdy_1sel_f + hqm_qed_pipe_core.counter_inc_3rdy_1sel ; 
PERF_counter_inc_3rdy_2sel_nxt = PERF_counter_inc_3rdy_2sel_f + hqm_qed_pipe_core.counter_inc_3rdy_2sel ;

PERF_rx_sync_rop_qed_dqed_enq_valid_firstv_nxt = PERF_rx_sync_rop_qed_dqed_enq_valid_firstv_f | ( hqm_qed_pipe_core.rx_sync_rop_qed_dqed_enq_ready & hqm_qed_pipe_core.rx_sync_rop_qed_dqed_enq_valid ) ;
PERF_rx_sync_rop_qed_dqed_enq_valid_first_nxt = PERF_rx_sync_rop_qed_dqed_enq_valid_firstv_f ? PERF_rx_sync_rop_qed_dqed_enq_valid_first_f : PERF_counter_f ;
PERF_rx_sync_rop_qed_dqed_enq_valid_last_nxt = ~ hqm_qed_pipe_core.rx_sync_rop_qed_dqed_enq_valid ? PERF_rx_sync_rop_qed_dqed_enq_valid_last_f : PERF_counter_f ;
PERF_rx_sync_rop_qed_dqed_enq_valid_total_nxt = PERF_rx_sync_rop_qed_dqed_enq_valid_total_f + ( hqm_qed_pipe_core.rx_sync_rop_qed_dqed_enq_valid ) ;
PERF_rx_sync_rop_qed_dqed_enq_valid_ready_nxt = PERF_rx_sync_rop_qed_dqed_enq_valid_ready_f + ( hqm_qed_pipe_core.rx_sync_rop_qed_dqed_enq_valid & hqm_qed_pipe_core.rx_sync_rop_qed_dqed_enq_ready ) ;
PERF_rx_sync_rop_qed_dqed_enq_valid_notready_nxt = PERF_rx_sync_rop_qed_dqed_enq_valid_notready_f + ( hqm_qed_pipe_core.rx_sync_rop_qed_dqed_enq_valid & ~ hqm_qed_pipe_core.rx_sync_rop_qed_dqed_enq_ready ) ;

PERF_rx_sync_nalb_qed_valid_firstv_nxt = PERF_rx_sync_nalb_qed_valid_firstv_f | ( hqm_qed_pipe_core.rx_sync_nalb_qed_ready & hqm_qed_pipe_core.rx_sync_nalb_qed_valid ) ;
PERF_rx_sync_nalb_qed_valid_first_nxt = PERF_rx_sync_nalb_qed_valid_firstv_f ? PERF_rx_sync_nalb_qed_valid_first_f : PERF_counter_f ;
PERF_rx_sync_nalb_qed_valid_last_nxt = ~ hqm_qed_pipe_core.rx_sync_nalb_qed_valid ? PERF_rx_sync_nalb_qed_valid_last_f : PERF_counter_f ;
PERF_rx_sync_nalb_qed_valid_total_nxt = PERF_rx_sync_nalb_qed_valid_total_f + ( hqm_qed_pipe_core.rx_sync_nalb_qed_valid ) ;
PERF_rx_sync_nalb_qed_valid_ready_nxt = PERF_rx_sync_nalb_qed_valid_ready_f + ( hqm_qed_pipe_core.rx_sync_nalb_qed_valid & hqm_qed_pipe_core.rx_sync_nalb_qed_ready ) ;
PERF_rx_sync_nalb_qed_valid_notready_nxt = PERF_rx_sync_nalb_qed_valid_notready_f + ( hqm_qed_pipe_core.rx_sync_nalb_qed_valid & ~ hqm_qed_pipe_core.rx_sync_nalb_qed_ready ) ;

PERF_rx_sync_dp_dqed_valid_firstv_nxt = PERF_rx_sync_dp_dqed_valid_firstv_f | ( hqm_qed_pipe_core.rx_sync_dp_dqed_ready & hqm_qed_pipe_core.rx_sync_dp_dqed_valid ) ;
PERF_rx_sync_dp_dqed_valid_first_nxt = PERF_rx_sync_dp_dqed_valid_firstv_f ? PERF_rx_sync_dp_dqed_valid_first_f : PERF_counter_f ;
PERF_rx_sync_dp_dqed_valid_last_nxt = ~ hqm_qed_pipe_core.rx_sync_dp_dqed_valid ? PERF_rx_sync_dp_dqed_valid_last_f : PERF_counter_f ;
PERF_rx_sync_dp_dqed_valid_total_nxt = PERF_rx_sync_dp_dqed_valid_total_f + ( hqm_qed_pipe_core.rx_sync_dp_dqed_valid ) ;
PERF_rx_sync_dp_dqed_valid_ready_nxt = PERF_rx_sync_dp_dqed_valid_ready_f + ( hqm_qed_pipe_core.rx_sync_dp_dqed_valid & hqm_qed_pipe_core.rx_sync_dp_dqed_ready ) ;
PERF_rx_sync_dp_dqed_valid_notready_nxt = PERF_rx_sync_dp_dqed_valid_notready_f + ( hqm_qed_pipe_core.rx_sync_dp_dqed_valid & ~ hqm_qed_pipe_core.rx_sync_dp_dqed_ready ) ;
end



















always_ff @(posedge clk) begin

if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin

end
end // always_ff

initial begin
$display("@%0tps [QED_INFO] hqm_qed_pipe VER=%d initial block ... ,%m",$time,hqm_qed_pipe_core.hqm_qed_target_cfg_unit_version_status);
end // begin

final begin
$display("@%0tps [QED_INFO] hqm_qed_pipe VER=%d final block ... ,%m",$time,hqm_qed_pipe_core.hqm_qed_target_cfg_unit_version_status);

$display("@%0tps [QED_PERF] hqm_qed_pipe %-s:%008x",$time,"Total simulation clocks",PERF_counter_f);

$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s",$time,"Summary of QED requestors (Enq, dir sch, ldb sch) arbitration",PERF_counter_inc_1rdy_1sel_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total 1 QED reqs and 1 issued",PERF_counter_inc_1rdy_1sel_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total 2 QED reqs and 1 issued",PERF_counter_inc_2rdy_1sel_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total 2 QED reqs and 2 issued",PERF_counter_inc_2rdy_2sel_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total 3 QED reqs and 1 issued",PERF_counter_inc_3rdy_1sel_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total 3 QED reqs and 2 issued",PERF_counter_inc_3rdy_2sel_f);

$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"First Enqueue Time",PERF_rx_sync_rop_qed_dqed_enq_valid_first_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Last  Enqueue Time",PERF_rx_sync_rop_qed_dqed_enq_valid_last_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total Enqueue Valid to QED",PERF_rx_sync_rop_qed_dqed_enq_valid_total_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total Enqueue Accepted",PERF_rx_sync_rop_qed_dqed_enq_valid_ready_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total Enqueue Stalled",PERF_rx_sync_rop_qed_dqed_enq_valid_notready_f);

$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"First LDB Sch Time",PERF_rx_sync_nalb_qed_valid_first_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Last  LDB Sch Time",PERF_rx_sync_nalb_qed_valid_last_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total LDB Sch Valid to QED",PERF_rx_sync_nalb_qed_valid_total_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total LDB Sch Accepted",PERF_rx_sync_nalb_qed_valid_ready_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total LDB Sch Stalled",PERF_rx_sync_nalb_qed_valid_notready_f);

$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"First DIR Sch Time",PERF_rx_sync_dp_dqed_valid_first_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Last  DIR Sch Time",PERF_rx_sync_dp_dqed_valid_last_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total DIR Sch Valid to QED",PERF_rx_sync_dp_dqed_valid_total_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total DIR Sch Accepted",PERF_rx_sync_dp_dqed_valid_ready_f);
$display("@%0tps [QED_PERF] hqm_qed_pipe %-50s:%08x",$time,"Total DIR Sch Stalled",PERF_rx_sync_dp_dqed_valid_notready_f);

end // final


`endif

////////////////////////////////////////////////////////////////////////////////////////////////////
task eot_check (output bit pf);
  
$display("@%0tps [QED_DEBUG], eot_check ... ,%m",$time);

pf = 1'b0 ; //pass

//Unit state checks
if ( hqm_qed_pipe_core.hqm_qed_target_cfg_unit_idle_reg_f[0] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [QED_ERROR] \
,%-30s \
"
,$time
," hqm_qed_pipe_core.hqm_qed_target_cfg_unit_idle_reg_f.pipe_idle is not set "
);
end

if ( hqm_qed_pipe_core.hqm_qed_target_cfg_unit_idle_reg_f[1] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [QED_ERROR] \
,%-30s \
"
,$time
," hqm_qed_pipe_core.hqm_qed_target_cfg_unit_idle_reg_f.unit_idle is not set "
);
end

//Unit Port checks - captured in MASTER
if ( hqm_qed_pipe_core.qed_alarm_down_v != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [QED_ERROR] \
,%-30s \
"
,$time
," qed_alarm_down_v is not clear "
);
end

if ( hqm_qed_pipe_core.qed_unit_idle != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [QED_ERROR] \
,%-30s \
"
,$time
," hqm_qed_pipe_core.qed_unit_idle is not set "
);
end
if ( hqm_qed_pipe_core.qed_unit_pipeidle != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [QED_ERROR] \
,%-30s \
"
,$time
," hqm_qed_pipe_core.qed_unit_pipeidle is not set "
);
end

if ( hqm_qed_pipe_core.qed_reset_done != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [QED_ERROR] \
,%-30s \
"
,$time
," hqm_qed_pipe_core.qed_reset_done is not set "
);
end

endtask : eot_check

endmodule

bind hqm_qed_pipe_core hqm_qed_pipe_inst i_hqm_qed_pipe_inst();

`endif
