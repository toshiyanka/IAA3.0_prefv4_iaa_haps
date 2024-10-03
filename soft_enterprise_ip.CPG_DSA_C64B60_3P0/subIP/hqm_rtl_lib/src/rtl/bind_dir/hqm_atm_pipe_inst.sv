`ifdef INTEL_INST_ON

module hqm_lsp_atm_pipe_inst import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

`ifdef INTEL_INST_ON

logic clk;
logic rst_n;
assign clk =  hqm_lsp_atm_pipe.hqm_gated_clk;
assign rst_n =  hqm_lsp_atm_pipe.hqm_gated_rst_n;














wire [63:0] DECODE_cmd[3:0];
assign DECODE_cmd[0]="CMP     ";
assign DECODE_cmd[1]="SCH_RLST";
assign DECODE_cmd[2]="SCH_SLST";
assign DECODE_cmd[3]="ENQ     ";

wire [63:0] DECODE_func[1:0];
assign DECODE_func[0]="CLEAR  ";
assign DECODE_func[1]="SET    ";


always_ff @(posedge clk) begin




if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin

if ( hqm_lsp_atm_pipe.lsp_ap_atm_v & hqm_lsp_atm_pipe.lsp_ap_atm_ready ) begin
$display( "@%0tps [CORE_DEBUG] \
,%-12s \
,%-26s \
,cmd:%s \
,cq:%x \
,hcw.qid:%x \
,hcw.qidix:%x \
,hcw.fid_dir_info:%x \
"
,$time
,"lsp -> ap"
,"LSP_AP"
, hqm_lsp_atm_pipe.lsp_ap_atm_data.cmd.name
, hqm_lsp_atm_pipe.lsp_ap_atm_data.cq
, hqm_lsp_atm_pipe.lsp_ap_atm_data.qid
, hqm_lsp_atm_pipe.lsp_ap_atm_data.qidix
, hqm_lsp_atm_pipe.lsp_ap_atm_data.fid
);
end



if ( hqm_lsp_atm_pipe.ap_lsp_cmd_v_nxt ) begin
$display( "@%0tps [CORE_DEBUG] \
,%-12s \
,%-26s \
,cmd:%s \
,haswork_rlst_v:%x \
,haswork_rlst_func:%s \
,haswork_slst_v:%x \
,haswork_slst_func:%s \
,cmpblast_v:%x \
,cq:%x \
,qidix:%x \
,qid:%x \
,qid2cqqidix:%x \
"
,$time
,"ap -> lsp"
,"AP_LSP_CMD"
, DECODE_cmd[hqm_lsp_atm_pipe.ap_lsp_cmd_nxt]
, hqm_lsp_atm_pipe.ap_lsp_haswork_rlst_v_nxt
, DECODE_func[hqm_lsp_atm_pipe.ap_lsp_haswork_rlst_func_nxt]
, hqm_lsp_atm_pipe.ap_lsp_haswork_slst_v_nxt
, DECODE_func[hqm_lsp_atm_pipe.ap_lsp_haswork_slst_func_nxt]
, hqm_lsp_atm_pipe.ap_lsp_cmpblast_v_nxt
, hqm_lsp_atm_pipe.ap_lsp_cq_nxt
, hqm_lsp_atm_pipe.ap_lsp_qidix_nxt
, hqm_lsp_atm_pipe.ap_lsp_qid_nxt
, hqm_lsp_atm_pipe.ap_lsp_qid2cqqidix_nxt
);
end



end




















if ( $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin

//####################################################################################################

if ( hqm_lsp_atm_pipe.int_inf_v[0] ) begin
$display( "@%0tps [AP_DEBUG] \
,%-40s \
,nopri:%x \
,enq_cnt_r_of:%x \
,enq_cnt_r_uf:%x \
,enq_cnt_s_of:%x \
,enq_cnt_s_uf:%x \
,rlst_cnt_of:%x \
,rlst_cnt_uf:%x \
,sch_cnt_of:%x \
,sch_cnt_uf:%x \
,slst_cnt_of[3]:%x \
,slst_cnt_of[2]:%x \
,slst_cnt_of[1]:%x \
,slst_cnt_of[0]:%x \
,slst_cnt_uf[3]:%x \
,slst_cnt_uf[2]:%x \
,slst_cnt_uf[1]:%x \
,slst_cnt_uf[0]:%x \
"
,$time
,"60 p6 INT_INF_V[0]"
,hqm_lsp_atm_pipe.error_nopri
,hqm_lsp_atm_pipe.report_error_enq_cnt_r_of
,hqm_lsp_atm_pipe.report_error_enq_cnt_r_uf
,hqm_lsp_atm_pipe.report_error_enq_cnt_s_of
,hqm_lsp_atm_pipe.report_error_enq_cnt_s_uf
,hqm_lsp_atm_pipe.report_error_rlst_cnt_of
,hqm_lsp_atm_pipe.report_error_rlst_cnt_uf
,hqm_lsp_atm_pipe.report_error_sch_cnt_of
,hqm_lsp_atm_pipe.report_error_sch_cnt_uf
,hqm_lsp_atm_pipe.report_error_slst_cnt_of[3]
,hqm_lsp_atm_pipe.report_error_slst_cnt_of[2]
,hqm_lsp_atm_pipe.report_error_slst_cnt_of[1]
,hqm_lsp_atm_pipe.report_error_slst_cnt_of[0]
,hqm_lsp_atm_pipe.report_error_slst_cnt_uf[3]
,hqm_lsp_atm_pipe.report_error_slst_cnt_uf[2]
,hqm_lsp_atm_pipe.report_error_slst_cnt_uf[1]
,hqm_lsp_atm_pipe.report_error_slst_cnt_uf[0]
);
end











//####################################################################################################


if (hqm_lsp_atm_pipe.p6_ll_ctrl.enable) begin


if ( hqm_lsp_atm_pipe.p6_debug_print_nc[hqm_lsp_atm_pipe.HQM_ATM_ENQ_ES] ) begin
$write( "@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:%x \
,bin:%x , ,                    \
"
,$time
,"00 ENQUEUE:  E->S SCH & PUSH"
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.p6_ll_data_nxt.fid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.bin
);
end

if ( hqm_lsp_atm_pipe.p6_debug_print_nc[hqm_lsp_atm_pipe.HQM_ATM_ENQ_SS] ) begin
$write( "@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:%x \
,bin:%x , ,                    \
"
,$time
,"01 ENQUEUE:  S->S  SCH & ACTIVE"
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.p6_ll_data_nxt.fid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.bin
);
end

if ( hqm_lsp_atm_pipe.p6_debug_print_nc[hqm_lsp_atm_pipe.HQM_ATM_ENQ_RR] ) begin
$write( "@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:%x \
,bin:%x , ,                    \
"
,$time
,"02 ENQUEUE:  R->R  RDY & ACTIVE"
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.p6_ll_data_nxt.fid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.bin
);
end

if ( hqm_lsp_atm_pipe.p6_debug_print_nc[hqm_lsp_atm_pipe.HQM_ATM_ENQ_IR] ) begin
$write( "@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:%x \
,bin:%x , ,                    \
"
,$time
,"03 ENQUEUE:  I->R  RDY & PUSH"
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.p6_ll_data_nxt.fid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.bin
);
end

if ( hqm_lsp_atm_pipe.p6_debug_print_nc[hqm_lsp_atm_pipe.HQM_ATM_CMP_SR] ) begin
$write( "@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:%x \
,bin:%x , ,                    \
"
,$time
,"10 COMPLETE: S->R  LAST SCH -> RDY"
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.p6_ll_data_nxt.fid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.bin
);
end

if ( hqm_lsp_atm_pipe.p6_debug_print_nc[hqm_lsp_atm_pipe.HQM_ATM_CMP_SI] ) begin
$write( "@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:%x \
,bin:%x , ,                    \
"
,$time
,"11 COMPLETE: S->I  LAST"
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.p6_ll_data_nxt.fid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.bin
);
end

if ( hqm_lsp_atm_pipe.p6_debug_print_nc[hqm_lsp_atm_pipe.HQM_ATM_CMP_SRESRE] ) begin
$write( "@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:%x \
,bin:%x , ,                    \
"
,$time
,"12 COMPLETE: SE->SE "
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.p6_ll_data_nxt.fid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.bin
);
end

if ( hqm_lsp_atm_pipe.p6_debug_print_nc[hqm_lsp_atm_pipe.HQM_ATM_SCH_SE] ) begin
$write( "@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:%x \
,bin:%x , ,                    \
"
,$time
,"20 SCHEDULE: S->E  SCH_WINS"
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.sch_fid_nnc
,hqm_lsp_atm_pipe.sch_bin_nnc
);
end

if ( hqm_lsp_atm_pipe.p6_debug_print_nc[hqm_lsp_atm_pipe.HQM_ATM_SCH_SS] ) begin
$write( "@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:%x \
,bin:%x , ,                    \
"
,$time
,"20 SCHEDULE: S->S  SCH_WINS"
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.sch_fid_nnc
,hqm_lsp_atm_pipe.sch_bin_nnc
);
end

if ( hqm_lsp_atm_pipe.p6_debug_print_nc[hqm_lsp_atm_pipe.HQM_ATM_SCH_RS] ) begin
$write( "@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:%x \
,bin:%x \
,dup:%x \
,rdy_override:%x \
"
,$time
,"22 SCHEDULE: R->S  RDY_WINS"
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.rdy_fid_nnc
,hqm_lsp_atm_pipe.rdy_bin_nnc
,hqm_lsp_atm_pipe.rdy_dup_nnc
,hqm_lsp_atm_pipe.rdy_override_nnc
);
end

if ( hqm_lsp_atm_pipe.p6_debug_print_nc[hqm_lsp_atm_pipe.HQM_ATM_SCH_RE] ) begin
$write( "@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:%x \
,bin:%x \
,dup:%x \
,rdy_override:%x \
"
,$time
,"22 SCHEDULE: R->E  RDY_WINS"
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.rdy_fid_nnc
,hqm_lsp_atm_pipe.rdy_bin_nnc
,hqm_lsp_atm_pipe.rdy_dup_nnc
,hqm_lsp_atm_pipe.rdy_override_nnc
);
end

if ( | hqm_lsp_atm_pipe.int_inf_v ) begin
$write( "\n@%0tps [AP_FULL] \
,%-40s \
,qid:%x \
,cq:%x \
,qidix:%x \
,fid:xxx \
,bin:x \
,dup:x \
,rdy_override:xx \
"
,$time
,"22 SCHEDULE: ERR "
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
);
end





$write( "\
,,rlst_e_ne:%x \
,rlst_ne_e:%x \
,slst_e_ne:%x \
,slst_ne_e:%x \
,,cmd:%s \
,haswork_rlst_v:%x \
,haswork_rlst_func:%s \
,haswork_slst_v:%x \
,haswork_slst_func:%s \
,cmpblast_v:%x \
"
,hqm_lsp_atm_pipe.rlst_e_ne_nnc
,hqm_lsp_atm_pipe.rlst_ne_e_nnc
,hqm_lsp_atm_pipe.slst_e_ne_nnc
,hqm_lsp_atm_pipe.slst_ne_e_nnc
,DECODE_cmd[hqm_lsp_atm_pipe.ap_lsp_cmd_nxt]
,hqm_lsp_atm_pipe.ap_lsp_haswork_rlst_v_nxt
,DECODE_func[hqm_lsp_atm_pipe.ap_lsp_haswork_rlst_func_nxt]
,hqm_lsp_atm_pipe.ap_lsp_haswork_slst_v_nxt
,DECODE_func[hqm_lsp_atm_pipe.ap_lsp_haswork_slst_func_nxt]
,hqm_lsp_atm_pipe.ap_lsp_cmpblast_v_nxt
);




$write( "\
,,rlst_cnt: v:%x qid:%x data:%x %x %x %x \
,,rdylst_tp_3: v:%x qid:%x data:%x \
,rdylst_tp_2: v:%x qid:%x data:%x \
,rdylst_tp_1: v:%x qid:%x data:%x \
,rdylst_tp_0: v:%x qid:%x data:%x \
,,rdylst_hp_3: v:%x qid:%x data:%x \
,rdylst_hp_2: v:%x qid:%x data:%x \
,rdylst_hp_1: v:%x qid:%x data:%x \
,rdylst_hp_0: v:%x qid:%x data:%x \
,,rdylst_hpnxt_3: v:%x addr:%x data:%x \
,rdylst_hpnxt_2: v:%x addr:%x data:%x \
,rdylst_hpnxt_1: v:%x addr:%x data:%x \
,rdylst_hpnxt_0: v:%x addr:%x data:%x \
,,slst_cnt: v:%x cq:%x qidix:%x data:%x %x %x %x \
,,schlst_tp_3: v:%x cq:%x qidix:%x data:%x \
,schlst_tp_2: v:%x cq:%x qidix:%x data:%x \
,schlst_tp_1: v:%x cq:%x qidix:%x data:%x \
,schlst_tp_0: v:%x cq:%x qidix:%x data:%x \
,,schlst_hp_3: v:%x cq:%x qidix:%x data:%x \
,schlst_hp_2: v:%x cq:%x qidix:%x data:%x \
,schlst_hp_1: v:%x cq:%x qidix:%x data:%x \
,schlst_hp_0: v:%x cq:%x qidix:%x data:%x \
,,schlst_hpnxt_3: v:%x addr:%x data:%x \
,schlst_hpnxt_2: v:%x addr:%x data:%x \
,schlst_hpnxt_1: v:%x addr:%x data:%x \
,schlst_hpnxt_0: v:%x addr:%x data:%x \
,,schlst_tpprv_3: v:%x addr:%x data:%x \
,schlst_tpprv_2: v:%x addr:%x data:%x \
,schlst_tpprv_1: v:%x addr:%x data:%x \
,schlst_tpprv_0: v:%x addr:%x data:%x \
,,enq_cnt_r_3: v:%x addr:%x data:%x \
,enq_cnt_r_2: v:%x addr:%x data:%x \
,enq_cnt_r_1: v:%x addr:%x data:%x \
,enq_cnt_r_0: v:%x addr:%x data:%x \
,,enq_cnt_s_3: v:%x addr:%x data:%x \
,enq_cnt_s_2: v:%x addr:%x data:%x \
,enq_cnt_s_1: v:%x addr:%x data:%x \
,enq_cnt_s_0: v:%x addr:%x data:%x \
,,sch_cnt: v:%x addr:%x data:%x  \
"
,hqm_lsp_atm_pipe.rmw_ll_rlst_cnt_p3_bypdata_sel_nxt
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.rmw_ll_rlst_cnt_p3_bypdata_nxt[53:42]
,hqm_lsp_atm_pipe.rmw_ll_rlst_cnt_p3_bypdata_nxt[39:28]
,hqm_lsp_atm_pipe.rmw_ll_rlst_cnt_p3_bypdata_nxt[25:14]
,hqm_lsp_atm_pipe.rmw_ll_rlst_cnt_p3_bypdata_nxt[11:0]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_tp_p3_bypdata_sel_nxt[3]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.rmw_ll_rdylst_tp_p3_bypdata_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_tp_p3_bypdata_sel_nxt[2]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.rmw_ll_rdylst_tp_p3_bypdata_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_tp_p3_bypdata_sel_nxt[1]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.rmw_ll_rdylst_tp_p3_bypdata_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_tp_p3_bypdata_sel_nxt[0]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.rmw_ll_rdylst_tp_p3_bypdata_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hp_p3_bypdata_sel_nxt[3]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hp_p3_bypdata_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hp_p3_bypdata_sel_nxt[2]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hp_p3_bypdata_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hp_p3_bypdata_sel_nxt[1]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hp_p3_bypdata_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hp_p3_bypdata_sel_nxt[0]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qid
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hp_p3_bypdata_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypdata_sel_nxt[3]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypaddr_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypdata_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypdata_sel_nxt[2]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypaddr_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypdata_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypdata_sel_nxt[1]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypaddr_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypdata_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypdata_sel_nxt[0]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypaddr_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_rdylst_hpnxt_p3_bypdata_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_slst_cnt_p3_bypdata_sel_nxt
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.rmw_ll_slst_cnt_p3_bypdata_nxt[53:42]
,hqm_lsp_atm_pipe.rmw_ll_slst_cnt_p3_bypdata_nxt[39:28]
,hqm_lsp_atm_pipe.rmw_ll_slst_cnt_p3_bypdata_nxt[25:14]
,hqm_lsp_atm_pipe.rmw_ll_slst_cnt_p3_bypdata_nxt[11:0]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tp_p3_bypdata_sel_nxt[3]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.rmw_ll_schlst_tp_p3_bypdata_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tp_p3_bypdata_sel_nxt[2]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.rmw_ll_schlst_tp_p3_bypdata_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tp_p3_bypdata_sel_nxt[1]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.rmw_ll_schlst_tp_p3_bypdata_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tp_p3_bypdata_sel_nxt[0]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.rmw_ll_schlst_tp_p3_bypdata_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hp_p3_bypdata_sel_nxt[3]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.rmw_ll_schlst_hp_p3_bypdata_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ] 
,hqm_lsp_atm_pipe.rmw_ll_schlst_hp_p3_bypdata_sel_nxt[2]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.rmw_ll_schlst_hp_p3_bypdata_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ] 
,hqm_lsp_atm_pipe.rmw_ll_schlst_hp_p3_bypdata_sel_nxt[1]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.rmw_ll_schlst_hp_p3_bypdata_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ] 
,hqm_lsp_atm_pipe.rmw_ll_schlst_hp_p3_bypdata_sel_nxt[0]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.cq
,hqm_lsp_atm_pipe.p6_ll_data_nxt.qidix
,hqm_lsp_atm_pipe.rmw_ll_schlst_hp_p3_bypdata_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ] 
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypdata_sel_nxt[3]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypaddr_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypdata_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypdata_sel_nxt[2]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypaddr_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypdata_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypdata_sel_nxt[1]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypaddr_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypdata_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypdata_sel_nxt[0]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypaddr_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_hpnxt_p3_bypdata_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypdata_sel_nxt[3]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypaddr_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ] 
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypdata_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypdata_sel_nxt[2]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypaddr_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypdata_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypdata_sel_nxt[1]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypaddr_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypdata_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypdata_sel_nxt[0]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypaddr_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_schlst_tpprv_p3_bypdata_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt[3]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2 +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt[2]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2 +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt[1]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2 +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypdata_sel_nxt[0]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypaddr_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2 +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p3_bypdata_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt[3]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypaddr_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2 +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypdata_nxt[ 3 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt[2]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypaddr_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2 +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypdata_nxt[ 2 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt[1]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypaddr_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2 +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypdata_nxt[ 1 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypdata_sel_nxt[0]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypaddr_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2 +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p3_bypdata_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_sch_cnt_p3_bypdata_sel_nxt
,hqm_lsp_atm_pipe.rmw_ll_sch_cnt_p3_bypaddr_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2WP +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.rmw_ll_sch_cnt_p3_bypdata_nxt[ 0 * hqm_lsp_atm_pipe.HQM_ATM_SCH_CNT_CNTB2WR +: hqm_lsp_atm_pipe.HQM_ATM_SCH_CNT_CNTB2 ]
);

$write( "\
,,rdy_hp_3:%x \
,rdy_hp_2:%x \
,rdy_hp_1:%x \
,rdy_hp_0:%x \
,,rdy_tp_3:%x \
,rdy_tp_2:%x \
,rdy_tp_1:%x \
,rdy_tp_0:%x \
,,sch_hp_3:%x \
,sch_hp_2:%x \
,sch_hp_1:%x \
,sch_hp_0:%x \
,,sch_tp_3:%x \
,sch_tp_2:%x \
,sch_tp_1:%x \
,sch_tp_0:%x \
,,bypassed_sch_tp:%x \
"
,hqm_lsp_atm_pipe.p6_ll_data_nxt.rdy_hp[ ( 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.rdy_hp[ ( 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.rdy_hp[ ( 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.rdy_hp[ ( 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.rdy_tp[ ( 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.rdy_tp[ ( 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.rdy_tp[ ( 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.rdy_tp[ ( 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.sch_hp[ ( 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.sch_hp[ ( 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.sch_hp[ ( 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.sch_hp[ ( 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.sch_tp[ ( 3 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.sch_tp[ ( 2 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.sch_tp[ ( 1 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.sch_tp[ ( 0 * hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ) +: hqm_lsp_atm_pipe.HQM_ATM_FIDB2 ]
,hqm_lsp_atm_pipe.p6_ll_data_nxt.bypassed_sch_tp
);



$write( "\
,,enq_cnt_s_3:%x \
,enq_cnt_s_2:%x \
,enq_cnt_s_1:%x \
,enq_cnt_s_0:%x \
,,enq_cnt_r_dup0_3:%x \
,enq_cnt_r_dup0_2:%x \
,enq_cnt_r_dup0_1:%x \
,enq_cnt_r_dup0_0:%x \
,,enq_cnt_r_dup1_3:%x \
,enq_cnt_r_dup1_2:%x \
,enq_cnt_r_dup1_1:%x \
,enq_cnt_r_dup1_0:%x \
,,enq_cnt_r_dup2_3:%x \
,enq_cnt_r_dup2_2:%x \
,enq_cnt_r_dup2_1:%x \
,enq_cnt_r_dup2_0:%x \
,,enq_cnt_r_dup3_3:%x \
,enq_cnt_r_dup3_2:%x \
,enq_cnt_r_dup3_1:%x \
,enq_cnt_r_dup3_0:%x \
"
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p2_data_f[ ( 3 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p2_data_f[ ( 2 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p2_data_f[ ( 1 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_s_p2_data_f[ ( 0 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p2_data_f[ ( 3 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p2_data_f[ ( 2 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p2_data_f[ ( 1 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup0_p2_data_f[ ( 0 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup1_p2_data_f[ ( 3 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup1_p2_data_f[ ( 2 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup1_p2_data_f[ ( 1 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup1_p2_data_f[ ( 0 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup2_p2_data_f[ ( 3 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup2_p2_data_f[ ( 2 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup2_p2_data_f[ ( 1 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup2_p2_data_f[ ( 0 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup3_p2_data_f[ ( 3 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup3_p2_data_f[ ( 2 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup3_p2_data_f[ ( 1 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
,hqm_lsp_atm_pipe.rmw_ll_enq_cnt_r_dup3_p2_data_f[ ( 0 * hqm_lsp_atm_pipe.HQM_ATM_CNTB2WR ) +: hqm_lsp_atm_pipe.HQM_ATM_CNTB2 ]
);

$write( "\n" );
















end


end

end


initial begin
  $display("@%0tps [AP_DEBUG] hqm_lsp_atm_pipe VER=%d initial block ...",$time,hqm_lsp_atm_pipe.hqm_ap_target_cfg_unit_version_status);
end // begin

final begin
$display("@%0tps [AP_DEBUG] hqm_lsp_atm_pipe VER=%d final block ...",$time,hqm_lsp_atm_pipe.hqm_ap_target_cfg_unit_version_status);
end // final

`endif


task eot_check (output bit pf);
  
$display("@%0tps [AP_DEBUG], eot_check ... ,%m",$time);

pf = 1'b0 ; //pass

//Unit state checks
if ( hqm_lsp_atm_pipe.hqm_ap_target_cfg_unit_idle_reg_f[0] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [AP_ERROR] \
,%-30s \
"
,$time
," hqm_lsp_atm_pipe.hqm_ap_target_cfg_unit_idle_reg_f.pipe_idle is not set "
);
end

if ( hqm_lsp_atm_pipe.hqm_ap_target_cfg_unit_idle_reg_f[1] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [AP_ERROR] \
,%-30s \
"
,$time
," hqm_lsp_atm_pipe.hqm_ap_target_cfg_unit_idle_reg_f.unit_idle is not set "
);
end


//Unit Port checks - captured in MASTER
if ( hqm_lsp_atm_pipe.ap_alarm_down_v != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [AP_ERROR] \
,%-30s \
"
,$time
," ap_alarm_down_v is not clear "
);
end

if ( hqm_lsp_atm_pipe.ap_unit_idle != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [AP_ERROR] \
,%-30s \
"
,$time
," hqm_lsp_atm_pipe.ap_unit_idle is not set "
);
end
if ( hqm_lsp_atm_pipe.ap_unit_pipeidle != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [AP_ERROR] \
,%-30s \
"
,$time
," hqm_lsp_atm_pipe.ap_unit_pipeidle is not set "
);
end

if ( hqm_lsp_atm_pipe.ap_reset_done != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [AP_ERROR] \
,%-30s \
"
,$time
," hqm_lsp_atm_pipe.ap_reset_done is not set "
);
end


//Unit Feature Report
if (hqm_lsp_atm_pipe.cfg_control7_f[13]) begin $display("@%0tps [AP_DEBUG] Detect Enqueue selection priortized over Complete/Schedule operation when elastic storage is almost full",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[12]) begin $display("@%0tps [AP_DEBUG] Detect a push to the Ready List is clamped to a bin",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[11]) begin $display("@%0tps [AP_DEBUG] Detect a push to the Ready List is clamped to a bin",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[10]) begin $display("@%0tps [AP_DEBUG] Detect a flow transition from Ready to Empty state on Schedule operation",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[9])  begin $display("@%0tps [AP_DEBUG] Detect a flow transition from Ready to Scheduled state on Schedule operation",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[8])  begin $display("@%0tps [AP_DEBUG] Detect a flow transition from Scheduled to Scheudled state on Schedule operation",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[7])  begin $display("@%0tps [AP_DEBUG] Detect a flow transition from Scheduled to Empty state on Schedule operation",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[6])  begin $display("@%0tps [AP_DEBUG] Detect a flow transition unchanged state on Completion operation ",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[5])  begin $display("@%0tps [AP_DEBUG] Detect a flow transition from Scheduled to Idle state on Completion operation",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[4])  begin $display("@%0tps [AP_DEBUG] Detect a flow transition from Scheduled to Ready state on Completion operation",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[3])  begin $display("@%0tps [AP_DEBUG] Detect a flow transition from Idle to Ready state on Enqueue operation",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[2])  begin $display("@%0tps [AP_DEBUG] Detect a flow transition from Ready to Ready state on Enqueue operation",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[1])  begin $display("@%0tps [AP_DEBUG] Detect a flow transition from Scheduled to Scheduled state on Enqueue operation",$time); end
if (hqm_lsp_atm_pipe.cfg_control7_f[0])  begin $display("@%0tps [AP_DEBUG] Detect a flow transition from Empty to Scheduled state on Enqueue operation",$time); end

if (hqm_lsp_atm_pipe.cfg_control8_f[28]) begin $display("@%0tps [AP_DEBUG] Detect full (4k) on inflight scheduled counter",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[27]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on scheduled list for priority bin 3",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[26]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on scheduled list for priority bin 2",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[25]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on scheduled list for priority bin 1",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[24]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on scheduled list for priority bin 0",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[23]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on ready list for priority bin 3",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[22]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on ready list for priority bin 2",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[21]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on ready list for priority bin 1",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[20]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on ready list for priority bin 0",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[19]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on enqueue counter for priority bin 3",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[18]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on enqueue counter for priority bin 2",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[17]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on enqueue counter for priority bin 1",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[16]) begin $display("@%0tps [AP_DEBUG] Detect full (2k) on enqueue counter for priority bin 0",$time); end

if (hqm_lsp_atm_pipe.cfg_control8_f[12]) begin $display("@%0tps [AP_DEBUG] Detect activity on inflight scheduled counter",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[11]) begin $display("@%0tps [AP_DEBUG] Detect activity on scheduled list for priority bin 3",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[10]) begin $display("@%0tps [AP_DEBUG] Detect activity on scheduled list for priority bin 2",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[9])  begin $display("@%0tps [AP_DEBUG] Detect activity on scheduled list for priority bin 1",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[8])  begin $display("@%0tps [AP_DEBUG] Detect activity on scheduled list for priority bin 0",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[7])  begin $display("@%0tps [AP_DEBUG] Detect activity on ready list for priority bin 3",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[6])  begin $display("@%0tps [AP_DEBUG] Detect activity on ready list for priority bin 2",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[5])  begin $display("@%0tps [AP_DEBUG] Detect activity on ready list for priority bin 1",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[4])  begin $display("@%0tps [AP_DEBUG] Detect activity on ready list for priority bin 0",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[3])  begin $display("@%0tps [AP_DEBUG] Detect activity on enqueue counter for priority bin 3",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[2])  begin $display("@%0tps [AP_DEBUG] Detect activity on enqueue counter for priority bin 2",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[1])  begin $display("@%0tps [AP_DEBUG] Detect activity on enqueue counter for priority bin 1",$time); end
if (hqm_lsp_atm_pipe.cfg_control8_f[0])  begin $display("@%0tps [AP_DEBUG] Detect activity on enqueue counter for priority bin 0",$time); end



endtask : eot_check

endmodule

bind hqm_lsp_atm_pipe hqm_lsp_atm_pipe_inst i_hqm_lsp_atm_pipe_inst();

`endif
