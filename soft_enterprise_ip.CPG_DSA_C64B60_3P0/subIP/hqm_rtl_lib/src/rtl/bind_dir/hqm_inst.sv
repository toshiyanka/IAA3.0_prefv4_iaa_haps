
`ifdef INTEL_INST_ON

`ifndef HQM_TB_DEFINES
`include "hqm_tb_defines.sv"
`define HQM_TB_DEFINES
`endif

module hqm_inst_sys import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

 // Insert instrumentation code here
 // Refer to signals with proper prefix from hqm_tb_defines
 
 always_ff @(posedge i_hqm_sip.hqm_sip_aon_wrap.i_hqm_sif.prim_freerun_clk) begin
 
  if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH") ) begin
 
   ////////////////////////////////////////////////////////////////////////////////////////////////////
   
   if ( ( `I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_req_down_write | `I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_req_down_read ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,write:%x \
   ,read:%x \
   ,mode:%x \
   ,node:%12s \
   ,target:%x \
   ,offset:%x \
   ,wdata:%x \
   "
   ,$time
   ,"master -> proc"
   ,"CFG REQ"
   ,`I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_req_down_write
   ,`I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_req_down_read
   ,`I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_req_down.addr.mode
   ,`I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_req_down.addr.node.name
   ,`I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_req_down.addr.target
   ,`I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_req_down.addr.offset
   ,`I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_req_down.wdata
   );
   end
   
   if ( ( `I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_rsp_up_ack === 1'b1 ) ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,err:%x \
   ,rdata:%x \
   ,uid:%s \
   "
   ,$time
   ,"proc -> master"
   ,"CFG RSP"
   ,`I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_rsp_up.err
   ,`I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_rsp_up.rdata
   ,`I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.cfg_rsp_up.uid.name
   );
   end
   
   if ( ( `I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_v & `I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,is_pf_port:%x \
   ,is_ldb_port:%x \
   ,cl_last:%x \
   ,cl:%x \
   ,cli:%x \
   ,vpp:%x \
   ,hcw.flags.dsi_error:%x \
   ,hcw.cmd:%s \
   ,hcw.debug.cmp_id:%x \
   ,hcw.debug.no_dec:%x \
   ,hcw.debug.qe_wt:%x \
   ,hcw.debug.ts_flag:%x \
   ,hcw.lockid:%x \
   ,hcw.msg_info.msgtype:%x \
   ,hcw.msg_info.qpri:%x \
   ,hcw.msg_info.qtype:%s \
   ,hcw.msg_info.qid:%x \
   ,hcw.dsi:%x \
   ,hcw.ptr:%x \
   "
   ,$time
   ,"iosf -> sys"
   ,"Enqueue"
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.is_pf_port
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.is_ldb_port
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.cl_last
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.cl
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.cli
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.vpp
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.flags.dsi_error
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.cmd.hcw_cmd_dec.name
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.debug.cmp_id
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.debug.no_dec
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.debug.qe_wt
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.debug.ts_flag
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.lockid_dir_info_tokens
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.msg_info.msgtype
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.msg_info.qpri
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.msg_info.qtype.name
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.msg_info.qid
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.dsi
   ,`I_HQM_SYSTEM.i_hqm_system_core.hcw_enq_in_data.hcw.ptr
   );
   end
   
   if ( ( `I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr_v ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,src:%x \
   ,invalid:%x \
   ,ro:%x \
   ,cq_v:%x \
   ,cq_ldb:%x \
   ,cq:%x \
   ,pasidtlp.fmt2:%x \
   ,pasidtlp.pm_req:%x \
   ,pasidtlp.exe_req:%x \
   ,pasidtlp.pasid:%x \
   ,length:%x \
   ,add:%x \
   ,tc_sel:%x \
   ,num_hcws:%x \
   "
   ,$time
   ,"sys -> iosf"
   ,"PHDR"
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.src
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.invalid
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.ro
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.cq_v
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.cq_ldb
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.cq
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.pasidtlp.fmt2
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.pasidtlp.pm_req
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.pasidtlp.exe_req
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.pasidtlp.pasid
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.length
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.add
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.tc_sel
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.hdr.num_hcws
   );
   end
   
   if ( ( `I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr_v ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,data_ms:%x \
   ,data_ls:%x \
   "
   ,$time
   ,"sys -> iosf"
   ,"PDATA"
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.data_ms.data
   ,`I_HQM_SYSTEM.i_hqm_system_core.write_buffer_mstr.data_ls.data
   );
   end
   
   if ( ( `I_HQM_SYSTEM.i_hqm_system_core.hqm_alarm_v & `I_HQM_SYSTEM.i_hqm_system_core.hqm_alarm_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,unit:%x \
   ,aid:%x \
   ,cls:%x \
   ,msix_map:%x \
   ,rtype:%x \
   ,rid:%x \
   "
   ,$time
   ,"core -> sys"
   ,"Alarm"
   ,`I_HQM_SYSTEM.i_hqm_system_core.hqm_alarm_data.unit
   ,`I_HQM_SYSTEM.i_hqm_system_core.hqm_alarm_data.aid
   ,`I_HQM_SYSTEM.i_hqm_system_core.hqm_alarm_data.cls
   ,`I_HQM_SYSTEM.i_hqm_system_core.hqm_alarm_data.msix_map
   ,`I_HQM_SYSTEM.i_hqm_system_core.hqm_alarm_data.rtype
   ,`I_HQM_SYSTEM.i_hqm_system_core.hqm_alarm_data.rid
   );
   end
   
   if ( ( `I_HQM_SYSTEM.i_hqm_system_core.interrupt_w_req_valid & `I_HQM_SYSTEM.i_hqm_system_core.interrupt_w_req_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,is_ldb:%x \
   ,cq:%x \
   "
   ,$time
   ,"core -> sys"
   ,"CIAL Interrupt"
   ,`I_HQM_SYSTEM.i_hqm_system_core.interrupt_w_req.is_ldb
   ,`I_HQM_SYSTEM.i_hqm_system_core.interrupt_w_req.cq_occ_cq
   );
   end
   
   if ( ( `I_HQM_SYSTEM.i_hqm_system_core.cwdi_interrupt_w_req_valid & `I_HQM_SYSTEM.i_hqm_system_core.cwdi_interrupt_w_req_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"core -> sys"
   ,"WD Interrupt"
   );
   end
   
   if ( ( `I_HQM_CREDIT_HIST_PIPE.hcw_enq_w_req_valid & `I_HQM_CREDIT_HIST_PIPE.hcw_enq_w_req_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,ao_v:%x \
   ,vas:%x \
   ,pp_is_ldb:%x \
   ,pp:%x \
   ,qe_is_ldb:%x \
   ,qid:%x \
   ,insert_timestamp:%x \
   ,hcw.flags.dsi_error:%x \
   ,hcw.cmd:%s \
   ,hcw.debug.cmp_id:%x \
   ,hcw.debug.no_dec:%x \
   ,hcw.debug.qe_wt:%x \
   ,hcw.debug.ts_flag:%x \
   ,hcw.lockid:%x \
   ,hcw.msg_info.msgtype:%x \
   ,hcw.msg_info.qpri:%x \
   ,hcw.msg_info.qtype:%s \
   ,hcw.msg_info.qid:%x \
   ,hcw.dsi:%x \
   ,hcw.ptr:%x \
   "
   ,$time
   ,"sys -> chp"
   ,"Enqueue"
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.user.ao_v
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.user.vas
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.user.pp_is_ldb
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.user.pp
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.user.qe_is_ldb
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.user.qid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.user.insert_timestamp
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.flags.dsi_error
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec.name
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.debug.cmp_id
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.debug.no_dec
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.debug.qe_wt
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.debug.ts_flag
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.lockid_dir_info_tokens
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.msgtype
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qpri
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qtype.name
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.dsi
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_enq_w_req.data.ptr
   );
   end
   
   if ( ( `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req_valid & `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,flags.cq_is_ldb:%x \
   ,flags.congestion_management:%x \
   ,flags.write_buffer_optimization:%x \
   ,flags.ignore_cq_depth:%x \
   ,cq_wptr:%x \
   ,cq:%x \
   ,hcw_error:%x \
   ,qid_depth:%x \
   ,cq_gen:%x \
   ,hcw.debug.qe_wt:%x \
   ,hcw.debug.ts_flag:%x \
   ,hcw.lockid:%x \
   ,hcw.msg_info.msgtype:%x \
   ,hcw.msg_info.qpri:%x \
   ,hcw.msg_info.qtype:%s \
   ,hcw.msg_info.qid:%x \
   ,hcw.dsi_timestamp:%x \
   ,hcw.ptr:%x \
   "
   ,$time
   ,"chp -> sys"
   ,"Schedule"
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.cq_is_ldb
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.congestion_management
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.write_buffer_optimization
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.ignore_cq_depth
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq_wptr
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.flags.hcw_error
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.flags.qid_depth
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.flags.cq_gen
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.debug.qe_wt
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.debug.ts_flag
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.lockid_dir_info_tokens
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.msg_info.msgtype
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.msg_info.qpri
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.msg_info.qtype.name
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.msg_info.qid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.dsi_timestamp
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.hcw_sched_w_req.data.ptr
   );
   end
   
   if ( ( `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_v & `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,cq_hcw_no_dec:%x \
   ,flid:%x \
   ,hl.qtype:%s \
   ,hl.qpri:%x \
   ,hl.qid:%x \
   ,hl.qidix:%x \
   ,hl.reord_mode:%x \
   ,hl.reord_slot:%x \
   ,hl.sn_fid:%x \
   ,hcw.cmd:%s \
   ,hcw.qe_wt:%x \
   ,hcw.pp_is_ldb:%x \
   ,hcw.ppid:%x \
   ,hcw.ts_flag:%x \
   ,hcw.lockid:%x \
   ,hcw.msg_info.msgtype:%x \
   ,hcw.msg_info.qpri:%x \
   ,hcw.msg_info.qtype:%s \
   ,hcw.msg_info.qid:%x \
   ,hcw.dsi:%x \
   ,hcw.ptr:%x \
   "
   ,$time
   ,"chp -> rop"
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd.name
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw_no_dec
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.flid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.qtype.name
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.qpri
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.qid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.qidix
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.reord_mode
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.reord_slot
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.sn_fid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec.name
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.qe_wt
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.pp_is_ldb
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.ppid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.ts_flag
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.lockid_dir_info_tokens
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.msg_info.msgtype
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.msg_info.qpri
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.msg_info.qtype.name
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.msg_info.qid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.dsi_timestamp
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.ptr
   );
   end
   
   if ( ( `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_cmp_v & `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_cmp_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,pp:%x \
   ,qid:%x \
   ,sn_fid:%x \
   ,qpri:%x \
   ,qidix:%x \
   ,user:%x \
   ,hid:%x \
   "
   ,$time
   ,"chp -> lsp"
   ,"RETURN COMPLETION"
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_cmp_data.pp
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_cmp_data.qid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.sn_fid.fid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.qpri
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.qidix
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_cmp_data.user
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hid
   );
   end
   
   if ( ( `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_token_v & `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_token_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,cq:%x \
   ,is_ldb:%x \
   ,count:%x \
   "
   ,$time
   ,"chp -> lsp"
   ,"RETURN TOKEN"
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_token_data.cq
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.chp_lsp_token_data.count
   );
   end
   
   if ( ( `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_v & `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,cq:%x \
   ,flags.cq_is_ldb:%x \
   ,flags.congestion_management:%x \
   ,flags.write_buffer_optimization:%x \
   ,flags.ignore_cq_depth:%x \
   ,hcw.qe_wt:%x \
   ,hcw.pp_is_ldb:%x \
   ,hcw.ppid:%x \
   ,hcw.ts_flag:%x \
   ,hcw.lockid:%x \
   ,hcw.msg_info.msgtype:%x \
   ,hcw.msg_info.qpri:%x \
   ,hcw.msg_info.qtype:%s \
   ,hcw.msg_info.qid:%x \
   ,hcw.dsi_timestamp:%x \
   ,hcw.ptr:%x \
   ,flid:%x \
   ,qidix:%x \
   "
   ,$time
   ,"qed -> chp"
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd.name
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.congestion_management
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.write_buffer_optimization
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.ignore_cq_depth
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw.qe_wt
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw.pp_is_ldb
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw.ppid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw.ts_flag
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw.lockid_dir_info_tokens
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw.msg_info.msgtype
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw.msg_info.qpri
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw.msg_info.qtype.name
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw.msg_info.qid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw.dsi_timestamp
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw.ptr
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.flid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.qed_chp_sch_data.qidix
   );
   end
   
   if ( ( `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_v & `I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,cq:%x \
   ,flags.cq_is_ldb:%x \
   ,flags.congestion_management:%x \
   ,flags.write_buffer_optimization:%x \
   ,flags.ignore_cq_depth:%x \
   ,hcw.qe_wt:%x \
   ,hcw.pp_is_ldb:%x \
   ,hcw.ppid:%x \
   ,hcw.ts_flag:%x \
   ,hcw.lockid:%x \
   ,hcw.msg_info.msgtype:%x \
   ,hcw.msg_info.qpri:%x \
   ,hcw.msg_info.qtype:%s \
   ,hcw.msg_info.qid:%x \
   ,hcw.dsi_timestamp:%x \
   ,hcw.ptr:%x \
   ,flid:%x \
   ,qidix:%x \
   "
   ,$time
   ,"aqed -> chp"
   ,"AQED_CHP_SCH"
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.hqm_core_flags.cq_is_ldb
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.hqm_core_flags.congestion_management
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.hqm_core_flags.write_buffer_optimization
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.hqm_core_flags.ignore_cq_depth
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw.qe_wt
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw.pp_is_ldb
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw.ppid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw.ts_flag
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw.lockid_dir_info_tokens
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw.msg_info.msgtype
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw.msg_info.qpri
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw.msg_info.qtype.name
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw.msg_info.qid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw.dsi_timestamp
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw.ptr
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.fid
   ,`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.aqed_chp_sch_data.qidix
   );
   end
   
   if ( ( `I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_v & `I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,qid:%x \
   ,qpri:%x \
   ,qtype:%s \
   ,flid:%x \
   ,qidix:%x \
   ,reord_mode:%x \
   ,reord_slot:%x \
   ,sn_fid:%x \
   ,frag_list.hptr:%x \
   ,frag_list.cnt:%x \
   ,cq:%x \
   "
   ,$time
   ,"rop -> dp"
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.cmd.name
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.hist_list_info.qid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.hist_list_info.qpri
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.hist_list_info.qtype.name
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.flid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.hist_list_info.qidix
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.hist_list_info.reord_mode
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.hist_list_info.reord_slot
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.hist_list_info.sn_fid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.frag_list_info.hptr
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.frag_list_info.cnt
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dp_enq_data.cq
   );
   end
   
   if ( ( `I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_v & `I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,qid:%x \
   ,qpri:%x \
   ,qtype:%s \
   ,flid:%x \
   ,qidix:%x \
   ,reord_mode:%x \
   ,reord_slot:%x \
   ,sn_fid:%x \
   ,frag_list.hptr:%x \
   ,frag_list.cnt:%x \
   ,cq:%x \
   "
   ,$time
   ,"rop -> nalb"
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.cmd.name
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.hist_list_info.qid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.hist_list_info.qpri
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.hist_list_info.qtype.name
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.flid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.hist_list_info.qidix
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.hist_list_info.reord_mode
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.hist_list_info.reord_slot
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.hist_list_info.sn_fid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.frag_list_info.hptr
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.frag_list_info.cnt
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_nalb_enq_data.cq
   );
   end
   
   if ( ( `I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_v & `I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dqed_enq_ready & ( `I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cmd == 'h1 ) ) === 1'b1 )  begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,flid:%x \
   ,hcw.qe_wt:%x \
   ,hcw.pp_is_ldb:%x \
   ,hcw.ppid:%x \
   ,hcw.ts_flag:%x \
   ,hcw.lockid:%x \
   ,hcw.msg_info.msgtype:%x \
   ,hcw.msg_info.qpri:%x \
   ,hcw.msg_info.qtype:%s \
   ,hcw.msg_info.qid:%x \
   ,hcw.dsi:%x \
   ,hcw.ptr:%x \
   "
   ,$time
   ,"rop -> dqed"
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cmd.name
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.flid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.qe_wt
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.pp_is_ldb
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.ppid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.ts_flag
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.lockid_dir_info_tokens
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.msg_info.msgtype
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.msg_info.qpri
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.msg_info.qtype.name
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.msg_info.qid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.dsi_timestamp
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.ptr
   );
   end
   
   if ( ( `I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_v & `I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_dqed_enq_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,flid:%x \
   ,hcw.qe_wt:%x \
   ,hcw.pp_is_ldb:%x \
   ,hcw.ppid:%x \
   ,hcw.ts_flag:%x \
   ,hcw.lockid:%x \
   ,hcw.msg_info.msgtype:%x \
   ,hcw.msg_info.qpri:%x \
   ,hcw.msg_info.qtype:%s \
   ,hcw.msg_info.qid:%x \
   ,hcw.dsi:%x \
   ,hcw.ptr:%x \
   "
   ,$time
   ,"rop -> qed_or_dqed"
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cmd.name
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.flid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.qe_wt
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.pp_is_ldb
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.ppid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.ts_flag
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.lockid_dir_info_tokens
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.msg_info.msgtype
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.msg_info.qpri
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.msg_info.qtype.name
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.msg_info.qid
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.dsi_timestamp
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_qed_dqed_enq_data.cq_hcw.ptr
   );
   end
   
   if ( ( `I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_lsp_reordercmp_v & `I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_lsp_reordercmp_ready ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   ,user:%x \
   ,cq:%x \
   ,qid:%x \
   "
   ,$time
   ,"rop -> lsp"
   ,"ROP_LSP_REORDER COMPLETE"
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_lsp_reordercmp_data.user
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_lsp_reordercmp_data.cq
   ,`I_HQM_REORDER_PIPE.i_hqm_reorder_pipe_core.rop_lsp_reordercmp_data.qid
   );
   end
   
   ////////////////////////////////////////////////////////////////////////////////////////////////////
   if ( ( ~ mstr_proc_idle_status_f.SYS_UNIT_IDLE & $past (mstr_proc_idle_status_f.SYS_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"sys -> master"
   ,"NOT_IDLE"
   );
   end
   if ( ( mstr_proc_idle_status_f.SYS_UNIT_IDLE & ~ $past ( mstr_proc_idle_status_f.SYS_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"sys -> master"
   ,"IDLE"
   );
   end
   
   if ( ( ~ mstr_proc_idle_status_f.AQED_UNIT_IDLE & $past (mstr_proc_idle_status_f.AQED_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"aqed -> master"
   ,"NOT_IDLE"
   );
   end
   if ( ( mstr_proc_idle_status_f.AQED_UNIT_IDLE & ~ $past ( mstr_proc_idle_status_f.AQED_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"aqed -> master"
   ,"IDLE"
   );
   end
   
   if ( ( ~ mstr_proc_idle_status_f.DQED_UNIT_IDLE & $past (mstr_proc_idle_status_f.DQED_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dqed -> master"
   ,"NOT_IDLE"
   );
   end
   if ( ( mstr_proc_idle_status_f.DQED_UNIT_IDLE & ~ $past ( mstr_proc_idle_status_f.DQED_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dqed -> master"
   ,"IDLE"
   );
   end
   
   if ( ( ~ mstr_proc_idle_status_f.QED_UNIT_IDLE & $past (mstr_proc_idle_status_f.QED_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"qed -> master"
   ,"NOT_IDLE"
   );
   end
   if ( ( mstr_proc_idle_status_f.QED_UNIT_IDLE & ~ $past ( mstr_proc_idle_status_f.QED_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"qed -> master"
   ,"IDLE"
   );
   end
   
   if ( ( ~ mstr_proc_idle_status_f.DP_UNIT_IDLE & $past (mstr_proc_idle_status_f.DP_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dp -> master"
   ,"NOT_IDLE"
   );
   end
   if ( ( mstr_proc_idle_status_f.DP_UNIT_IDLE & ~ $past ( mstr_proc_idle_status_f.DP_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dp -> master"
   ,"IDLE"
   );
   end
   
   if ( ( ~ mstr_proc_idle_status_f.AP_UNIT_IDLE & $past (mstr_proc_idle_status_f.AP_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"ap -> master"
   ,"NOT_IDLE"
   );
   end
   if ( ( mstr_proc_idle_status_f.AP_UNIT_IDLE & ~ $past ( mstr_proc_idle_status_f.AP_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"ap -> master"
   ,"IDLE"
   );
   end
   
   if ( ( ~ mstr_proc_idle_status_f.NALB_UNIT_IDLE & $past (mstr_proc_idle_status_f.NALB_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"nalb -> master"
   ,"NOT_IDLE"
   );
   end
   if ( ( mstr_proc_idle_status_f.NALB_UNIT_IDLE & ~ $past ( mstr_proc_idle_status_f.NALB_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"nalb -> master"
   ,"IDLE"
   );
   end
   
   if ( ( ~ mstr_proc_idle_status_f.LSP_UNIT_IDLE & $past (mstr_proc_idle_status_f.LSP_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"lsp -> master"
   ,"NOT_IDLE"
   );
   end
   if ( ( mstr_proc_idle_status_f.LSP_UNIT_IDLE & ~ $past ( mstr_proc_idle_status_f.LSP_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"lsp -> master"
   ,"IDLE"
   );
   end
   
   if ( ( ~ mstr_proc_idle_status_f.ROP_UNIT_IDLE & $past (mstr_proc_idle_status_f.ROP_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"rop -> master"
   ,"NOT_IDLE"
   );
   end
   if ( ( mstr_proc_idle_status_f.ROP_UNIT_IDLE & ~ $past ( mstr_proc_idle_status_f.ROP_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"rop -> master"
   ,"IDLE"
   );
   end
   
   if ( ( ~ mstr_proc_idle_status_f.CHP_UNIT_IDLE & $past (mstr_proc_idle_status_f.CHP_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"chp -> master"
   ,"NOT_IDLE"
   );
   end
   if ( ( mstr_proc_idle_status_f.CHP_UNIT_IDLE & ~ $past ( mstr_proc_idle_status_f.CHP_UNIT_IDLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"chp -> master"
   ,"IDLE"
   );
   end
   
   
   
   
   if ( ( ~ mstr_proc_reset_status_f.PF_RESET_ACTIVE & $past (mstr_proc_reset_status_f.PF_RESET_ACTIVE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"pf -> master"
   ,"RESET_DONE"
   );
   end
   if ( ( mstr_proc_reset_status_f.PF_RESET_ACTIVE & ~ $past ( mstr_proc_reset_status_f.PF_RESET_ACTIVE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"pf -> master"
   ,"RESET_ACTIVE"
   );
   end
   
   if ( ( ~ mstr_proc_reset_status_f.SYS_PF_RESET_DONE & $past (mstr_proc_reset_status_f.SYS_PF_RESET_DONE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"sys -> master"
   ,"RESET_ACTIVE"
   );
   end
   if ( ( mstr_proc_reset_status_f.SYS_PF_RESET_DONE & ~ $past ( mstr_proc_reset_status_f.SYS_PF_RESET_DONE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"sys -> master"
   ,"RESET_DONE"
   );
   end
   
   if ( ( ~ mstr_proc_reset_status_f.AQED_PF_RESET_DONE & $past (mstr_proc_reset_status_f.AQED_PF_RESET_DONE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"aqed -> master"
   ,"RESET_ACTIVE"
   );
   end
   if ( ( mstr_proc_reset_status_f.AQED_PF_RESET_DONE & ~ $past ( mstr_proc_reset_status_f.AQED_PF_RESET_DONE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"aqed -> master"
   ,"RESET_DONE"
   );
   end
   
   if ( ( ~ mstr_proc_reset_status_f.DQED_PF_RESET_DONE & $past (mstr_proc_reset_status_f.DQED_PF_RESET_DONE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dqed -> master"
   ,"RESET_ACTIVE"
   );
   end
   if ( ( mstr_proc_reset_status_f.DQED_PF_RESET_DONE & ~ $past ( mstr_proc_reset_status_f.DQED_PF_RESET_DONE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dqed -> master"
   ,"RESET_DONE"
   );
   end
   
   if ( ( ~ mstr_proc_reset_status_f.QED_PF_RESET_DONE & $past (mstr_proc_reset_status_f.QED_PF_RESET_DONE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"qed -> master"
   ,"RESET_ACTIVE"
   );
   end
   if ( ( mstr_proc_reset_status_f.QED_PF_RESET_DONE & ~ $past ( mstr_proc_reset_status_f.QED_PF_RESET_DONE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"qed -> master"
   ,"RESET_DONE"
   );
   end
   
   if ( ( ~ mstr_proc_reset_status_f.DP_PF_RESET_DONE & $past (mstr_proc_reset_status_f.DP_PF_RESET_DONE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dp -> master"
   ,"RESET_ACTIVE"
   );
   end
   if ( ( mstr_proc_reset_status_f.DP_PF_RESET_DONE & ~ $past ( mstr_proc_reset_status_f.DP_PF_RESET_DONE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dp -> master"
   ,"RESET_DONE"
   );
   end
   
   if ( ( ~ mstr_proc_reset_status_f.AP_PF_RESET_DONE & $past (mstr_proc_reset_status_f.AP_PF_RESET_DONE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"ap -> master"
   ,"RESET_ACTIVE"
   );
   end
   if ( ( mstr_proc_reset_status_f.AP_PF_RESET_DONE & ~ $past ( mstr_proc_reset_status_f.AP_PF_RESET_DONE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"ap -> master"
   ,"RESET_DONE"
   );
   end
   
   if ( ( ~ mstr_proc_reset_status_f.NALB_PF_RESET_DONE & $past (mstr_proc_reset_status_f.NALB_PF_RESET_DONE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"nalb -> master"
   ,"RESET_ACTIVE"
   );
   end
   if ( ( mstr_proc_reset_status_f.NALB_PF_RESET_DONE & ~ $past ( mstr_proc_reset_status_f.NALB_PF_RESET_DONE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"nalb -> master"
   ,"RESET_DONE"
   );
   end
   
   if ( ( ~ mstr_proc_reset_status_f.LSP_PF_RESET_DONE & $past (mstr_proc_reset_status_f.LSP_PF_RESET_DONE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"lsp -> master"
   ,"RESET_ACTIVE"
   );
   end
   if ( ( mstr_proc_reset_status_f.LSP_PF_RESET_DONE & ~ $past ( mstr_proc_reset_status_f.LSP_PF_RESET_DONE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"lsp -> master"
   ,"RESET_DONE"
   );
   end
   
   if ( ( ~ mstr_proc_reset_status_f.ROP_PF_RESET_DONE & $past (mstr_proc_reset_status_f.ROP_PF_RESET_DONE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"rop -> master"
   ,"RESET_ACTIVE"
   );
   end
   if ( ( mstr_proc_reset_status_f.ROP_PF_RESET_DONE & ~ $past ( mstr_proc_reset_status_f.ROP_PF_RESET_DONE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"rop -> master"
   ,"RESET_DONE"
   );
   end
   
   if ( ( ~ mstr_proc_reset_status_f.CHP_PF_RESET_DONE & $past (mstr_proc_reset_status_f.CHP_PF_RESET_DONE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"chp -> master"
   ,"RESET_ACTIVE"
   );
   end
   if ( ( mstr_proc_reset_status_f.CHP_PF_RESET_DONE & ~ $past ( mstr_proc_reset_status_f.CHP_PF_RESET_DONE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"chp -> master"
   ,"RESET_DONE"
   );
   end
   
   
   
   
   
   
   
   
   
   if ( ( ~ mstr_proc_lcb_status_f.SYS_LCB_ENABLE & $past (mstr_proc_lcb_status_f.SYS_LCB_ENABLE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"sys -> master"
   ,"LCB_OFF"
   );
   end
   if ( ( mstr_proc_lcb_status_f.SYS_LCB_ENABLE & ~ $past ( mstr_proc_lcb_status_f.SYS_LCB_ENABLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"sys -> master"
   ,"LCB_ON"
   );
   end
   if ( ( ~ mstr_proc_lcb_status_f.AQED_LCB_ENABLE & $past (mstr_proc_lcb_status_f.AQED_LCB_ENABLE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"aqed -> master"
   ,"LCB_OFF"
   );
   end
   if ( ( mstr_proc_lcb_status_f.AQED_LCB_ENABLE & ~ $past ( mstr_proc_lcb_status_f.AQED_LCB_ENABLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"aqed -> master"
   ,"LCB_ON"
   );
   end
   
   if ( ( ~ mstr_proc_lcb_status_f.DQED_LCB_ENABLE & $past (mstr_proc_lcb_status_f.DQED_LCB_ENABLE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dqed -> master"
   ,"LCB_OFF"
   );
   end
   if ( ( mstr_proc_lcb_status_f.DQED_LCB_ENABLE & ~ $past ( mstr_proc_lcb_status_f.DQED_LCB_ENABLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dqed -> master"
   ,"LCB_ON"
   );
   end
   
   if ( ( ~ mstr_proc_lcb_status_f.QED_LCB_ENABLE & $past (mstr_proc_lcb_status_f.QED_LCB_ENABLE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"qed -> master"
   ,"LCB_OFF"
   );
   end
   if ( ( mstr_proc_lcb_status_f.QED_LCB_ENABLE & ~ $past ( mstr_proc_lcb_status_f.QED_LCB_ENABLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"qed -> master"
   ,"LCB_ON"
   );
   end
   
   if ( ( ~ mstr_proc_lcb_status_f.DP_LCB_ENABLE & $past (mstr_proc_lcb_status_f.DP_LCB_ENABLE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dp -> master"
   ,"LCB_OFF"
   );
   end
   if ( ( mstr_proc_lcb_status_f.DP_LCB_ENABLE & ~ $past ( mstr_proc_lcb_status_f.DP_LCB_ENABLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"dp -> master"
   ,"LCB_ON"
   );
   end
   
   if ( ( ~ mstr_proc_lcb_status_f.AP_LCB_ENABLE & $past (mstr_proc_lcb_status_f.AP_LCB_ENABLE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"ap -> master"
   ,"LCB_OFF"
   );
   end
   if ( ( mstr_proc_lcb_status_f.AP_LCB_ENABLE & ~ $past ( mstr_proc_lcb_status_f.AP_LCB_ENABLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"ap -> master"
   ,"LCB_ON"
   );
   end
   
   if ( ( ~ mstr_proc_lcb_status_f.NALB_LCB_ENABLE & $past (mstr_proc_lcb_status_f.NALB_LCB_ENABLE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"nalb -> master"
   ,"LCB_OFF"
   );
   end
   if ( ( mstr_proc_lcb_status_f.NALB_LCB_ENABLE & ~ $past ( mstr_proc_lcb_status_f.NALB_LCB_ENABLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"nalb -> master"
   ,"LCB_ON"
   );
   end
   
   if ( ( ~ mstr_proc_lcb_status_f.LSP_LCB_ENABLE & $past (mstr_proc_lcb_status_f.LSP_LCB_ENABLE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"lsp -> master"
   ,"LCB_OFF"
   );
   end
   if ( ( mstr_proc_lcb_status_f.LSP_LCB_ENABLE & ~ $past ( mstr_proc_lcb_status_f.LSP_LCB_ENABLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"lsp -> master"
   ,"LCB_ON"
   );
   end
   
   if ( ( ~ mstr_proc_lcb_status_f.ROP_LCB_ENABLE & $past (mstr_proc_lcb_status_f.ROP_LCB_ENABLE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"rop -> master"
   ,"LCB_OFF"
   );
   end
   if ( ( mstr_proc_lcb_status_f.ROP_LCB_ENABLE & ~ $past ( mstr_proc_lcb_status_f.ROP_LCB_ENABLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"rop -> master"
   ,"LCB_ON"
   );
   end
   
   if ( ( ~ mstr_proc_lcb_status_f.CHP_LCB_ENABLE & $past (mstr_proc_lcb_status_f.CHP_LCB_ENABLE) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"chp -> master"
   ,"LCB_OFF"
   );
   end
   if ( ( mstr_proc_lcb_status_f.CHP_LCB_ENABLE & ~ $past ( mstr_proc_lcb_status_f.CHP_LCB_ENABLE ) ) === 1'b1 ) begin
   $display( "@%0tps [PROC_DEBUG] \
   ,%-12s \
   ,%-26s \
   "
   ,$time
   ,"chp -> master"
   ,"LCB_ON"
   );
   end
   
  end

 end
   
 mstr_proc_reset_status_t mstr_proc_reset_status_f , mstr_proc_reset_status_nxt ;
 mstr_proc_idle_status_t  mstr_proc_idle_status_f ,  mstr_proc_idle_status_nxt ;
 mstr_proc_lcb_status_t   mstr_proc_lcb_status_f ,   mstr_proc_lcb_status_nxt ;
   
 assign mstr_proc_reset_status_nxt = `I_HQM_MASTER.i_hqm_master_core.i_hqm_proc_master.mstr_proc_reset_status ;
 assign mstr_proc_idle_status_nxt  = `I_HQM_MASTER.i_hqm_master_core.i_hqm_proc_master.mstr_proc_idle_status ;
 assign mstr_proc_lcb_status_nxt   = `I_HQM_MASTER.i_hqm_master_core.i_hqm_proc_master.mstr_proc_lcb_status ;
   
 always_ff @(posedge `I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.prim_gated_clk or negedge `I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.prim_gated_rst_b_sync ) begin
   
  if (~ `I_HQM_MASTER.i_hqm_master_core.i_hqm_cfg_master.i_hqm_cfg_master_sys2cfg.prim_gated_rst_b_sync ) begin
   mstr_proc_idle_status_f  <= '0 ;
   mstr_proc_reset_status_f <= '0 ;
   mstr_proc_lcb_status_f   <= '0 ;
  end else begin
   mstr_proc_idle_status_f  <= mstr_proc_idle_status_nxt ;
   mstr_proc_reset_status_f <= mstr_proc_reset_status_nxt ;
   mstr_proc_lcb_status_f   <= mstr_proc_lcb_status_nxt ;
  end
 end
   
 task eot_check (output bit pf);

  logic   fail ;
  integer lsp_coal_count ;
  integer aqed_credit_count ;
  
  $display("@%0tps [HQM_DEBUG], eot_check ... ,%m",$time);
  
  fail = 0 ; // pass=0

  //TODO-JTC- move these to EOT panel check?
  //      // do checks only if power is on 
  //      if (par_hqm_nalb_pipe_nalb_pgcb_fet_en_ack_b == 0) begin
  //      
  //        // Compare system_write_buffer coalescing counts with LSP debug counters.  WB count is the number of "extra" beats
  //        // that were coalesced, so that a grouping of 4 would add 3 to the count.  debug counters are only 16 bits, sim will
  //        // never send 64K HCW, want to make sure sys hw 64-bit counters are completely correct so confirm ms bits are 0.
  //        // Disable check if opt is disabled in WB, assume not changed dynamically.
  //        // Because an interrupt on an optimized DIR CQ before the write buffer receives all the beats stops the optimization, it is not possible to do an equals comparison
  //        // between LSP and WB.  In all cases the WB count should not be greater than the LSP count, so that partial check is retained.
  //        lsp_coal_count        = 0 ;
  //        for ( int i=0; i<HQM_NUM_DIR_CQ; i++) begin    // Count the extra beats
  //           lsp_coal_count = lsp_coal_count +       `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.i_hqm_list_sel_pipe_inst.dbg_lsp_dp_sch_dir_wbo1_f [i]
  //                                           + ( 2 * `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.i_hqm_list_sel_pipe_inst.dbg_lsp_dp_sch_dir_wbo2_f [i] )
  //                                           + ( 3 * `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.i_hqm_list_sel_pipe_inst.dbg_lsp_dp_sch_dir_wbo3_f [i] ) ;
  //        end // for i
  //        if ( ( {   `I_HQM_SYSTEM.i_hqm_system_core.hqm_system_cnt[21] , `I_HQM_SYSTEM.i_hqm_system_core.hqm_system_cnt[20] } > lsp_coal_count )
  //                 & ~ `I_HQM_SYSTEM.i_hqm_system_core.cfg_write_buffer_ctl.WRITE_SINGLE_BEATS
  //                 & ~ hqms_no_wbo_eot_check ) begin
  //          fail = 1 ;
  //          $display("@%0t [PROC_ERROR]        eot_check failed because system write_buffer coalesced writes count %x (extra beats) is greater than the LSP coalesced count %08x"
  //              , $time
  //              , { `I_HQM_SYSTEM.i_hqm_system_core.hqm_system_cnt[21] , `I_HQM_SYSTEM.i_hqm_system_core.hqm_system_cnt[20] }
  //              , lsp_coal_count ) ;
  //        end
  //      
  //        // AQED tracks credits, LSP tracks count which equals 2K-credits
  //        if ( `I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ptr_mem_data_f[11] == `I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ptr_mem_data_f[25] )
  //          aqed_credit_count = `I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ptr_mem_data_f[10:0] -                 // push ptr
  //                              `I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ptr_mem_data_f[24:14] ;                // pop ptr
  //        else
  //          aqed_credit_count = 2048 +
  //                              `I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ptr_mem_data_f[10:0] -                 // push ptr
  //                              `I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ptr_mem_data_f[24:14] ;                // pop ptr
  //        if ( (2048 - aqed_credit_count ) != `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.cfg_aqed_tot_enqueue_count_f [HQM_LSP_ATQ_AQED_ACT_CNT_WIDTH-1:0] ) begin
  //          fail = 1 ;
  //          $display("@%0t [PROC_ERROR]        eot_check failed because AQED total atomic credit count = %x, LSP total atomic active count = %x implies credit count of %x"
  //              , $time
  //              , aqed_credit_count
  //              , `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.cfg_aqed_tot_enqueue_count_f [HQM_LSP_ATQ_AQED_ACT_CNT_WIDTH-1:0]
  //              , ( 2048 - `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.cfg_aqed_tot_enqueue_count_f [HQM_LSP_ATQ_AQED_ACT_CNT_WIDTH-1:0] ) ) ;
  //        end
  //      end
  
  pf = fail ; // pass=0
 
 endtask : eot_check
 
endmodule

module hqm_inst_lsp import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

 always_ff @(posedge `I_HQM_LIST_SEL_PIPE.hqm_inp_gated_clk) begin

  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.qed_lsp_deq_v ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,cq:%x \
  ,qe_wt:%x \
  "
  ,$time
  ,"qed -> lsp"
  ,"RETURN DEQUEUE"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.qed_lsp_deq_data.cq
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.qed_lsp_deq_data.qe_wt
  );
  end
  
  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.aqed_lsp_deq_v ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,cq:%x \
  ,qe_wt:%x \
  "
  ,$time
  ,"aqed -> lsp"
  ,"RETURN DEQUEUE"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.aqed_lsp_deq_data.cq
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.aqed_lsp_deq_data.qe_wt
  );
  end
  
  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_v & `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,cq:%x \
  ,hcw.qid:%x \
  "
  ,$time
  ,"lsp -> nalb"
  ,"LSP_NALB_SCHEDULE_UNO,ORD"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.cq
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_nalb_sch_unoord_data.qid
  );
  end
  
  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_dp_sch_dir_v & `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_dp_sch_dir_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,cq:%x \
  ,hcw.qid:%x \
  "
  ,$time
  ,"lsp -> dp"
  ,"LSP_DP_SCHEDULE_DIR"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.cq
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_dp_sch_dir_data.qid
  );
  end
  
  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_nalb_sch_rorply_v & `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_nalb_sch_rorply_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,hcw.qid:%x \
  "
  ,$time
  ,"lsp -> nalb"
  ,"LSP_NALB_SCHEDULE_RORPLY"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_nalb_sch_rorply_data.qid
  );
  end
  
  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_dp_sch_rorply_v & `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_dp_sch_rorply_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,hcw.qid:%x \
  "
  ,$time
  ,"lsp -> dp"
  ,"LSP_DP_SCHEDULE_RORPLY"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_dp_sch_rorply_data.qid
  );
  end
  
  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_nalb_sch_atq_v & `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_nalb_sch_atq_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,hcw.qid:%x \
  "
  ,$time
  ,"lsp -> nalb"
  ,"LSP_NALB_SCHEDULE_ATQ"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.lsp_nalb_sch_atq_data.qid
  );
  end
  
  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.nalb_lsp_enq_lb_v & `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.nalb_lsp_enq_lb_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,hcw.qid:%x \
  ,hcw.qtype:%s \
  "
  ,$time
  ,"nalb -> lsp"
  ,"NALB_LSP_ENQUEUE_LB_HCW"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.nalb_lsp_enq_lb_data.qid
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.nalb_lsp_enq_lb_data.qtype
  );
  end
  
  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_v & `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,hcw.qid:%x \
  ,frag_list.cnt:%x \
  "
  ,$time
  ,"nalb -> lsp"
  ,"NALB_LSP_ENQUEUE_LB_RORPLY"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_data.qid
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.nalb_lsp_enq_rorply_data.frag_cnt
  );
  end
  
  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.dp_lsp_enq_dir_v & `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.dp_lsp_enq_dir_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,hcw.qid:%x \
  "
  ,$time
  ,"dp -> lsp"
  ,"DP_LSP_ENQUEUE_DIR_HCW"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.dp_lsp_enq_dir_data.qid
  );
  end
  
  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.dp_lsp_enq_rorply_v & `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.dp_lsp_enq_rorply_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,hcw.qid:%x \
  ,frag_list.cnt:%x \
  "
  ,$time
  ,"dp -> lsp"
  ,"DP_LSP_ENQUEUE_DIR_RORPLY"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.dp_lsp_enq_rorply_data.qid
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.dp_lsp_enq_rorply_data.frag_cnt
  );
  end
  
  if ( ( `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.aqed_lsp_sch_v & `I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.aqed_lsp_sch_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,cq:%x \
  ,hcw.qid:%x \
  ,hcw.qidix:%x \
  "
  ,$time
  ,"aqed -> lsp"
  ,"AQED_LSP_SCH"
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.aqed_lsp_sch_data.cq
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.aqed_lsp_sch_data.qid
  ,`I_HQM_LIST_SEL_PIPE.i_hqm_list_sel_pipe_core.aqed_lsp_sch_data.qidix
  );
  end
  
  if ( ( `I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ap_aqed_v & `I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ap_aqed_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,cq:%x \
  ,hcw.qid:%x \
  ,hcw.qidix:%x \
  ,hcw.fid_dir_info:%x \
  "
  ,$time
  ,"ap -> aqed"
  ,"AP_AQED_POP"
  ,`I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ap_aqed_data.cq
  ,`I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ap_aqed_data.qid
  ,`I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ap_aqed_data.qidix
  ,`I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.ap_aqed_data.flid
  );
  end
  
  if ( ( `I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.aqed_ap_enq_v & `I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.aqed_ap_enq_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,hcw.qid:%x \
  ,hcw.qpri:%x \
  ,hcw.fid_dir_info:%x \
  "
  ,$time
  ,"aqed -> ap"
  ,"AQED_AP_ATQ2ATM"
  ,`I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.aqed_ap_enq_data.qid
  ,`I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.aqed_ap_enq_data.qpri
  ,`I_HQM_AQED_PIPE.i_hqm_aqed_pipe_core.aqed_ap_enq_data.flid
  );
  end

 end
 
endmodule
 
module hqm_inst_qed import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();
 
 always_ff @(posedge `I_HQM_QED_PIPE.hqm_inp_gated_clk) begin

  if ( ( `I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_v & `I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,hcw.qe_wt:%x \
  ,hcw.pp_is_ldb:%x \
  ,hcw.ppid:%x \
  ,hcw.ts_flag:%x \
  ,hcw.lockid:%x \
  ,hcw.msg_info.msgtype:%x \
  ,hcw.msg_info.qpri:%x \
  ,hcw.msg_info.qtype:%s \
  ,hcw.msg_info.qid:%x \
  ,hcw.dsi_timestamp:%x \
  ,hcw.ptr:%x \
  "
  ,$time
  ,"qed -> aqed"
  ,"QED_AQED_ATQ2ATM"
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_data.cq_hcw.qe_wt
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_data.cq_hcw.pp_is_ldb
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_data.cq_hcw.ppid
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_data.cq_hcw.ts_flag
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_data.cq_hcw.lockid_dir_info_tokens
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_data.cq_hcw.msg_info.msgtype
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_data.cq_hcw.msg_info.qpri
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_data.cq_hcw.msg_info.qtype.name
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_data.cq_hcw.msg_info.qid
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_data.cq_hcw.dsi_timestamp
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.qed_aqed_enq_data.cq_hcw.ptr
  );
  end
  
  if ( ( `I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.nalb_qed_v & `I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.nalb_qed_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,cq:%x \
  ,hcw.qid:%x \
  ,flid:%x \
  "
  ,$time
  ,"nalb -> qed"
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.nalb_qed_data.cmd.name
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.nalb_qed_data.cq
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.nalb_qed_data.qid
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.nalb_qed_data.flid
  );
  end
  
  if ( ( `I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_dir_pipe_core.dp_dqed_v & `I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_dir_pipe_core.dp_dqed_ready ) === 1'b1 ) begin
  $display( "@%0tps [PROC_DEBUG] \
  ,%-12s \
  ,%-26s \
  ,cq:%x \
  ,hcw.qid:%x \
  ,flid:%x \
  "
  ,$time
  ,"dp -> dqed"
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_dir_pipe_core.dp_dqed_data.cmd.name
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_dir_pipe_core.dp_dqed_data.cq
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_dir_pipe_core.dp_dqed_data.qid
  ,`I_HQM_QED_PIPE.i_hqm_qed_pipe_core.i_hqm_dir_pipe_core.dp_dqed_data.flid
  );
  end
 
 end

endmodule
 
bind hqm_sip  hqm_inst_sys i_hqm_inst_sys();
bind hqm_sip  hqm_inst_lsp i_hqm_inst_lsp();
bind hqm_sip  hqm_inst_qed i_hqm_inst_qed();
 
`endif
