`ifdef INTEL_INST_ON

module hqm_nalb_pipe_inst import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();


logic clk;
logic rst_n;

assign clk =  hqm_nalb_pipe_core.hqm_gated_clk;
assign rst_n =  hqm_nalb_pipe_core.hqm_gated_rst_n;


initial begin
      $display("@%0tps [NALB_INFO] hqm_nalb_pipe VER=%d initial block ...",$time,hqm_nalb_pipe_core.hqm_nalb_target_cfg_unit_version_status);
end // begin

final begin
$display("@%0tps [NALB_INFO] hqm_nalb_pipe VER=%d final block ...",$time,hqm_nalb_pipe_core.hqm_nalb_target_cfg_unit_version_status);
end // final


////////////////////////////////////////////////////////////////////////////////////////////////////
task eot_check (output bit pf);
$display("@%0tps [NALB_DEBUG], eot_check ... ,%m",$time);

  pf = 1'b0 ; //pass


//Unit state checks
if ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_unit_idle_reg_f[1] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [NALB_ERROR] \
,%-30s \
"
,$time
," hqm_nalb_pipe_core.hqm_nalb_target_cfg_unit_idle_reg_f.pipe_idle is not set "
);
end

if ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_unit_idle_reg_f[0] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [NALB_ERROR] \
,%-30s \
"
,$time
," hqm_nalb_pipe_core.hqm_nalb_target_cfg_unit_idle_reg_f.unit_idle is not set "
);
end


//Unit Port checks - captured in MASTER
if ( hqm_nalb_pipe_core.nalb_alarm_down_v != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [NALB_ERROR] \
,%-30s \
"
,$time
," nalb_alarm_down_v is not clear "
);
end

if ( hqm_nalb_pipe_core.nalb_unit_idle != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [NALB_ERROR] \
,%-30s \
"
,$time
," hqm_nalb_pipe_core.nalb_unit_idle is not set "
);
end
if ( hqm_nalb_pipe_core.nalb_unit_pipeidle != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [NALB_ERROR] \
,%-30s \
"
,$time
," hqm_nalb_pipe_core.nalb_unit_pipeidle is not set "
);
end

if ( hqm_nalb_pipe_core.nalb_reset_done != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [NALB_ERROR] \
,%-30s \
"
,$time
," hqm_nalb_pipe_core.nalb_reset_done is not set "
);
end

endtask : eot_check

endmodule

bind hqm_nalb_pipe_core hqm_nalb_pipe_inst i_hqm_nalb_pipe_inst();

`endif
