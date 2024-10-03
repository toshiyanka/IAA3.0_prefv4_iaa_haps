`ifdef INTEL_INST_ON

module hqm_aqed_pipe_inst import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

`ifdef INTEL_INST_ON

logic clk;
logic rst_n;
assign clk =  hqm_aqed_pipe_core.hqm_gated_clk;
assign rst_n =  hqm_aqed_pipe_core.hqm_gated_rst_n;


initial begin
      $display("@%0tps [AQED_DEBUG] hqm_aqed_pipe VER=%d initial block ...",$time,hqm_aqed_pipe_core.hqm_aqed_target_cfg_unit_version_status);
end // begin

final begin
      $display("@%0tps [AQED_DEBUG] hqm_aqed_pipe VER=%d final block ...",$time,hqm_aqed_pipe_core.hqm_aqed_target_cfg_unit_version_status);
end // final
`endif




logic [(2048)-1:0] active_aqed_ll_cnt_pri0_nxt , active_aqed_ll_cnt_pri0_f ;
logic [(2048)-1:0] active_aqed_ll_cnt_pri1_nxt , active_aqed_ll_cnt_pri1_f ;
logic [(2048)-1:0] active_aqed_ll_cnt_pri2_nxt , active_aqed_ll_cnt_pri2_f ;
logic [(2048)-1:0] active_aqed_ll_cnt_pri3_nxt , active_aqed_ll_cnt_pri3_f ;
logic [(2048)-1:0] active_aqed_ll_cnt_pri4_nxt , active_aqed_ll_cnt_pri4_f ;
logic [(2048)-1:0] active_aqed_ll_cnt_pri5_nxt , active_aqed_ll_cnt_pri5_f ;
logic [(2048)-1:0] active_aqed_ll_cnt_pri6_nxt , active_aqed_ll_cnt_pri6_f ;
logic [(2048)-1:0] active_aqed_ll_cnt_pri7_nxt , active_aqed_ll_cnt_pri7_f ;
always_ff @( posedge clk or negedge rst_n ) begin : L00
  if (!rst_n ) begin
    active_aqed_ll_cnt_pri0_f <= '0 ;
    active_aqed_ll_cnt_pri1_f <= '0 ;
    active_aqed_ll_cnt_pri2_f <= '0 ;
    active_aqed_ll_cnt_pri3_f <= '0 ;
    active_aqed_ll_cnt_pri4_f <= '0 ;
    active_aqed_ll_cnt_pri5_f <= '0 ;
    active_aqed_ll_cnt_pri6_f <= '0 ;
    active_aqed_ll_cnt_pri7_f <= '0 ;
  end
  else begin
    active_aqed_ll_cnt_pri0_f <= active_aqed_ll_cnt_pri0_nxt ;
    active_aqed_ll_cnt_pri1_f <= active_aqed_ll_cnt_pri1_nxt ;
    active_aqed_ll_cnt_pri2_f <= active_aqed_ll_cnt_pri2_nxt ;
    active_aqed_ll_cnt_pri3_f <= active_aqed_ll_cnt_pri3_nxt ;
    active_aqed_ll_cnt_pri4_f <= active_aqed_ll_cnt_pri4_nxt ;
    active_aqed_ll_cnt_pri5_f <= active_aqed_ll_cnt_pri5_nxt ;
    active_aqed_ll_cnt_pri6_f <= active_aqed_ll_cnt_pri6_nxt ;
    active_aqed_ll_cnt_pri7_f <= active_aqed_ll_cnt_pri7_nxt ;
  end
end
always_comb begin : L01
active_aqed_ll_cnt_pri0_nxt = active_aqed_ll_cnt_pri0_f ;
active_aqed_ll_cnt_pri1_nxt = active_aqed_ll_cnt_pri1_f ;
active_aqed_ll_cnt_pri2_nxt = active_aqed_ll_cnt_pri2_f ;
active_aqed_ll_cnt_pri3_nxt = active_aqed_ll_cnt_pri3_f ;
active_aqed_ll_cnt_pri4_nxt = active_aqed_ll_cnt_pri4_f ;
active_aqed_ll_cnt_pri5_nxt = active_aqed_ll_cnt_pri5_f ;
active_aqed_ll_cnt_pri6_nxt = active_aqed_ll_cnt_pri6_f ;
active_aqed_ll_cnt_pri7_nxt = active_aqed_ll_cnt_pri7_f ;
if (hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri0_we) begin active_aqed_ll_cnt_pri0_nxt[hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri1_waddr] = ( |hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri0_wdata [ 11 : 0 ] ) ; end
if (hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri1_we) begin active_aqed_ll_cnt_pri1_nxt[hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri1_waddr] = ( |hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri1_wdata [ 11 : 0 ] ) ; end
if (hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri2_we) begin active_aqed_ll_cnt_pri2_nxt[hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri1_waddr] = ( |hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri2_wdata [ 11 : 0 ] ) ; end
if (hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri3_we) begin active_aqed_ll_cnt_pri3_nxt[hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri1_waddr] = ( |hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri3_wdata [ 11 : 0 ] ) ; end
//#if (hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri4_we) begin active_aqed_ll_cnt_pri4_nxt[hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri1_waddr] = ( |hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri4_wdata [ 11 : 0 ] ) ; end
//#if (hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri5_we) begin active_aqed_ll_cnt_pri5_nxt[hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri1_waddr] = ( |hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri5_wdata [ 11 : 0 ] ) ; end
//#if (hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri6_we) begin active_aqed_ll_cnt_pri6_nxt[hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri1_waddr] = ( |hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri6_wdata [ 11 : 0 ] ) ; end
//#if (hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri7_we) begin active_aqed_ll_cnt_pri7_nxt[hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri1_waddr] = ( |hqm_aqed_pipe_core.rf_aqed_ll_cnt_pri7_wdata [ 11 : 0 ] ) ; end
end


task eot_check (output bit pf);
  
$display("@%0tps [AQED_DEBUG], eot_check ... ,%m",$time);

pf = 1'b0 ; //pass

//Unit state checks
if ( hqm_aqed_pipe_core.hqm_aqed_target_cfg_unit_idle_reg_f[0] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [AQED_ERROR] \
,%-30s \
"
,$time
," hqm_aqed_pipe_core.hqm_aqed_target_cfg_unit_idle_reg_f.pipe_idle is not set "
);
end

if ( hqm_aqed_pipe_core.hqm_aqed_target_cfg_unit_idle_reg_f[1] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [AQED_ERROR] \
,%-30s \
"
,$time
," hqm_aqed_pipe_core.hqm_aqed_target_cfg_unit_idle_reg_f.unit_idle is not set "
);
end

//Unit Port checks - captured in MASTER
if ( hqm_aqed_pipe_core.aqed_alarm_down_v != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [AQED_ERROR] \
,%-30s \
"
,$time
," aqed_alarm_down_v is not clear "
);
end

if ( hqm_aqed_pipe_core.aqed_unit_idle != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [AQED_ERROR] \
,%-30s \
"
,$time
," hqm_aqed_pipe_core.aqed_unit_idle is not set "
);
end
if ( hqm_aqed_pipe_core.aqed_unit_pipeidle != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [AQED_ERROR] \
,%-30s \
"
,$time
," hqm_aqed_pipe_core.aqed_unit_pipeidle is not set "
);
end

if ( hqm_aqed_pipe_core.aqed_reset_done != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [AQED_ERROR] \
,%-30s \
"
,$time
," hqm_aqed_pipe_core.aqed_reset_done is not set "
);
end

// UNit Model checks
if ($test$plusargs("HQM_INGRESS_ERROR_TEST")) begin
end
else begin
if (|active_aqed_ll_cnt_pri0_f) begin pf = 1'b1; $display("@%0tps [AQED_ERROR] Detect active_aqed_ll_cnt_pri0_f",$time); end
if (|active_aqed_ll_cnt_pri1_f) begin pf = 1'b1; $display("@%0tps [AQED_ERROR] Detect active_aqed_ll_cnt_pri1_f",$time); end
if (|active_aqed_ll_cnt_pri2_f) begin pf = 1'b1; $display("@%0tps [AQED_ERROR] Detect active_aqed_ll_cnt_pri2_f",$time); end
if (|active_aqed_ll_cnt_pri3_f) begin pf = 1'b1; $display("@%0tps [AQED_ERROR] Detect active_aqed_ll_cnt_pri3_f",$time); end
//if (|active_aqed_ll_cnt_pri4_f) begin pf = 1'b1; $display("@%0tps [AQED_ERROR] Detect active_aqed_ll_cnt_pri4_f",$time); end
//if (|active_aqed_ll_cnt_pri5_f) begin pf = 1'b1; $display("@%0tps [AQED_ERROR] Detect active_aqed_ll_cnt_pri5_f",$time); end
//if (|active_aqed_ll_cnt_pri6_f) begin pf = 1'b1; $display("@%0tps [AQED_ERROR] Detect active_aqed_ll_cnt_pri6_f",$time); end
//if (|active_aqed_ll_cnt_pri7_f) begin pf = 1'b1; $display("@%0tps [AQED_ERROR] Detect active_aqed_ll_cnt_pri7_f",$time); end
end

endtask : eot_check

endmodule

bind hqm_aqed_pipe_core hqm_aqed_pipe_inst i_hqm_aqed_pipe_inst();

`endif
