
`ifndef INTEL_SVA_OFF

module hqm_system_assert import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*; ();

logic           continue_on_perr;
logic           continue_on_eerr;
logic           continue_on_pferr;
logic           continue_on_vferr;
logic           continue_on_cq_ov;
logic           continue_on_rob_err;
logic           disable_beat_checks;

initial begin
 continue_on_perr=0; if ($test$plusargs("HQM_SYSTEM_CONTINUE_ON_PERR"))   continue_on_perr='1;
 continue_on_eerr=0; if ($test$plusargs("HQM_SYSTEM_CONTINUE_ON_ECCERR")) continue_on_eerr='1;
 continue_on_pferr=0; if ($test$plusargs("HQM_SYSTEM_CONTINUE_ON_PFERR")) continue_on_pferr='1;
 continue_on_vferr=0; if ($test$plusargs("HQM_SYSTEM_CONTINUE_ON_VFERR")) continue_on_vferr='1;
 continue_on_cq_ov=0; if ($test$plusargs("HQM_SYSTEM_CONTINUE_ON_CQ_OV")) continue_on_cq_ov='1;
 continue_on_rob_err=0; if ($test$plusargs("HQM_SYSTEM_CONTINUE_ON_ROB_ERR")) continue_on_rob_err='1;
 disable_beat_checks=0; if ($test$plusargs("HQM_SYSTEM_DISABLE_BEAT_CHECKS")) disable_beat_checks='1;
end

logic           egress_perr_mask;
logic           sch_sm_error_wbo_mask;

always_comb begin
  egress_perr_mask = 1'b0;
  if ($test$plusargs("HQM_CHP_EGRESS_HCW_DATA_PARITY_ERROR_INJECTION_TEST") ) begin
    egress_perr_mask = egress_perr_mask | ( hqm_system_core.i_hqm_system_egress.perr_q & hqm_system_core.i_hqm_system_egress.intf_perr_q[0]) ;
  end
  if ($test$plusargs("HQM_CHP_EGRESS_HCW_USER_PARITY_ERROR_INJECTION_TEST") ) begin
    egress_perr_mask = egress_perr_mask | ( hqm_system_core.i_hqm_system_egress.perr_q & hqm_system_core.i_hqm_system_egress.intf_perr_q[1]) ;
  end
  sch_sm_error_wbo_mask = 1'b0;
  if ($test$plusargs("HQM_CHP_EGRESS_WBO_ERROR_INJECTION_TEST")) begin
    sch_sm_error_wbo_mask = 1'b1;
  end
end

// Check that the cq wp address we get from the hqm_core for scheduled HCWs keeps wrapping for beats 0-1-2-3,0-1-2-3, etc.

logic   [1:0]   expected_dir_cq_beat_q[NUM_DIR_CQ-1:0];
logic   [1:0]   expected_ldb_cq_beat_q[NUM_LDB_CQ-1:0];
logic           hcw_sched_dir_cq_beat_out_of_sequence;
logic           hcw_sched_ldb_cq_beat_out_of_sequence;

always @(posedge hqm_system_core.i_hqm_system_write_buffer.hqm_gated_clk or negedge hqm_system_core.i_hqm_system_write_buffer.hqm_gated_rst_n) begin: Expected_Beats
 int i;
 if (~hqm_system_core.i_hqm_system_write_buffer.hqm_gated_rst_n) begin
  for (i=0; i<NUM_DIR_CQ; i=i+1) expected_dir_cq_beat_q[i] <= '0;
  for (i=0; i<NUM_LDB_CQ; i=i+1) expected_ldb_cq_beat_q[i] <= '0;
 end else begin
  if (hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out_v & hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out_ready &
   hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.hcw_v) begin
   if (hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.w.user.hqm_core_flags.cq_is_ldb) begin
    expected_ldb_cq_beat_q[hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.w.user.cq[HQM_SYSTEM_LDB_CQ_WIDTH-1:0]] <=
    expected_ldb_cq_beat_q[hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.w.user.cq[HQM_SYSTEM_LDB_CQ_WIDTH-1:0]] + 1'b1;
   end else begin
    expected_dir_cq_beat_q[hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.w.user.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0]] <=
    expected_dir_cq_beat_q[hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.w.user.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0]] + 1'b1;
   end
  end
 end
end

assign hcw_sched_dir_cq_beat_out_of_sequence = hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out_v &
 hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out_ready & hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.hcw_v &
 ~hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.w.user.hqm_core_flags.cq_is_ldb &
(hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.w.user.cq_wptr[1:0] !=
 expected_dir_cq_beat_q[hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.w.user.cq[HQM_SYSTEM_DIR_CQ_WIDTH-1:0]]);

assign hcw_sched_ldb_cq_beat_out_of_sequence = hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out_v &
 hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out_ready & hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.hcw_v &
 hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.w.user.hqm_core_flags.cq_is_ldb &
(hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.w.user.cq_wptr[1:0] !=
 expected_ldb_cq_beat_q[hqm_system_core.i_hqm_system_write_buffer.hcw_sched_out.w.user.cq[HQM_SYSTEM_LDB_CQ_WIDTH-1:0]]);

//`HQM_SDG_ASSERTS_FORBIDDEN(
//     hqm_system_hcw_sched_dir_cq_beat_out_of_sequence
//    ,hcw_sched_dir_cq_beat_out_of_sequence
//    ,posedge hqm_system_core.i_hqm_system_write_buffer.hqm_gated_clk
//    ,(~hqm_system_core.i_hqm_system_write_buffer.hqm_gated_rst_n | disable_beat_checks)
//    ,`HQM_SVA_ERR_MSG("Directed HCW schedule request from hqm_core had beat portion of offset out of sequence")
//);

//`HQM_SDG_ASSERTS_FORBIDDEN(
//     hqm_system_hcw_sched_ldb_cq_beat_out_of_sequence
//    ,hcw_sched_ldb_cq_beat_out_of_sequence
//    ,posedge hqm_system_core.i_hqm_system_write_buffer.hqm_gated_clk
//    ,(~hqm_system_core.i_hqm_system_write_buffer.hqm_gated_rst_n | disable_beat_checks)
//    ,`HQM_SVA_ERR_MSG("Load balanced HCW schedule request from hqm_core had beat portion of offset out of sequence")
//);

always @(posedge hqm_system_core.hqm_gated_clk) begin

 if (hqm_system_core.hqm_gated_rst_n === 1'b1) begin
 // Just flag any single bit ECC errors

 if (hqm_system_core.ingress_sb_ecc_error)    $display ("%t: [HQMS_DEBUG]: WARNING: Single bit ECC error detected on ingress LUT!", $time);

 if (hqm_system_core.sch_wb_sb_ecc_error[0]) $display ("%t: [HQMS_DEBUG]: WARNING: Single bit ECC error detected on scheduled HCW [63:0] (cq=%x)!",
    $time, hqm_system_core.sch_wb_ecc_syndrome);
 if (hqm_system_core.sch_wb_sb_ecc_error[1]) $display ("%t: [HQMS_DEBUG]: WARNING: Single bit ECC error detected on scheduled HCW [127:64] (cq=%x)!",
    $time, hqm_system_core.sch_wb_ecc_syndrome);
 if (hqm_system_core.sch_wb_sb_ecc_error[2]) $display ("%t: [HQMS_DEBUG]: WARNING: Single bit ECC error detected on scheduled HCW [191:128] (cq=%x)!",
    $time, hqm_system_core.sch_wb_ecc_syndrome);
 if (hqm_system_core.sch_wb_sb_ecc_error[3]) $display ("%t: [HQMS_DEBUG]: WARNING: Single bit ECC error detected on scheduled HCW [255:192] (cq=%x)!",
    $time, hqm_system_core.sch_wb_ecc_syndrome);

 if (hqm_system_core.i_hqm_system_ingress.rob_enq_out_mb_ecc_error) $display ("%t: [HQMS_DEBUG]: WARNING: Single bit ECC error detected on ingress HCW [127:64]!", $time);
 if (hqm_system_core.i_hqm_system_ingress.p8_sb_ecc_error) $display ("%t: [HQMS_DEBUG]: WARNING: Single bit ECC error detected on ingress HCW [63:0]!", $time);

 // Just flag any ingress errors

 if (hqm_system_core.i_hqm_system_ingress.ingress_alarm_v_next & (hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd0))
    $display ("%t: [HQMS_DEBUG]: WARNING: Ingress HCW had illegal command or port type (pf=%x vdev=%x vpp=%x pp=%x pp_ldb=%x cmd=%x)!",
         $time
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vdev
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vpp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.cmd
    );
 if (hqm_system_core.i_hqm_system_ingress.ingress_alarm_v_next & (hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd1))
    $display ("%t: [HQMS_DEBUG]: WARNING: Ingress HCW producer port not valid (pf=%x vdev=%x vpp=%x pp_v=%x pp=%x pp_ldb=%x)!",
         $time
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vdev
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vpp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp_v
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_ldb_port
    );
 if (hqm_system_core.i_hqm_system_ingress.ingress_alarm_v_next & (hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd3))
    $display ("%t: [HQMS_DEBUG]: WARNING: Ingress HCW queue ID not valid (pf=%x vdev=%x vpp=%x pp_v=%x pp=%x pp_ldb=%x qid_v=%x qid_t=%x qid=%x)!",
         $time
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vdev
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vpp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp_v
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.qid_v
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qid
    );
 if (hqm_system_core.i_hqm_system_ingress.ingress_alarm_v_next & (hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd4)) begin
    $display ("%t: [HQMS_DEBUG]: WARNING: Ingress HCW queue ID not valid for VAS (pf=%x vdev=%x vpp=%x pp_v=%x pp=%x pp_ldb=%x qid_v=%x qid_t=%x qid=%x vasqid_v=%x)!",
         $time
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vdev
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vpp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp_v
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.qid_v
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vasqid_v
    );
 end
 if (hqm_system_core.i_hqm_system_ingress.ingress_alarm_v_next & (hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd5)) begin
   if (hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qtype == ORDERED)
    $display ("%t: [HQMS_DEBUG]: WARNING: Ingress HCW had invalid SN for ORD queue (pf=%x vdev=%x vpp=%x pp_v=%x pp=%x pp_ldb=%x qid_v=%x qid_t=%x qid=%x sn=%x)!",
         $time
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vdev
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vpp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp_v
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.qid_v
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.qid_cfg_v[0]
    );
   else if (hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qtype == UNORDERED)
    $display ("%t: [HQMS_DEBUG]: WARNING: Ingress HCW had valid SN for UNO queue (pf=%x vdev=%x vpp=%x pp_v=%x pp=%x pp_ldb=%x qid_v=%x qid_t=%x qid=%x sn=%x)!",
         $time
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vdev
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vpp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp_v
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.qid_v
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.qid_cfg_v[0]
    );
   else
    $display ("%t: [HQMS_DEBUG]: WARNING: Ingress HCW had invalid FID for ATM queue (pf=%x vdev=%x vpp=%x pp_v=%x pp=%x pp_ldb=%x qid_v=%x qid_t=%x qid=%x fid=%x)!",
         $time
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vdev
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.vpp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp_v
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.pp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.qid_v
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.qid_cfg_v[1]
    );
  end
 end

 if (continue_on_perr & (hqm_system_core.hqm_gated_rst_n === 1'b1)) begin
  if (hqm_system_core.ingress_perr)      $display ("%t: [HQMS_DEBUG]: WARNING: An ingress LUT CFG parity error occurred!", $time);
  if (hqm_system_core.egress_perr)       $display ("%t: [HQMS_DEBUG]: WARNING: An egress LUT or sched parity or residue error occurred!", $time);
  if (hqm_system_core.alarm_perr)        $display ("%t: [HQMS_DEBUG]: WARNING: An alarm LUT parity error occurred!", $time);
 end

 if (continue_on_cq_ov & (hqm_system_core.hqm_gated_rst_n === 1'b1)) begin
  if (hqm_system_core.cq_addr_overflow_error)  $display ("%t: [HQMS_DEBUG]: WARNING: CQ address overflowed on a scheduled HCW!", $time);
 end

 if (continue_on_eerr & (hqm_system_core.hqm_gated_rst_n === 1'b1)) begin
  if (hqm_system_core.ingress_mb_ecc_error)    $display ("%t: [HQMS_DEBUG]: WARNING: An ingress LUT MB ECC error occurred!", $time);
  if (hqm_system_core.sch_wb_mb_ecc_error)     $display ("%t: [HQMS_DEBUG]: WARNING: A write buffer MB ECC error occurred!", $time);

  if (hqm_system_core.i_hqm_system_ingress.rob_enq_out_mb_ecc_error) $display ("%t: [HQMS_DEBUG]: WARNING: An HCW enqueue [127:64] MB ECC error occurred!", $time);
  if (hqm_system_core.i_hqm_system_ingress.p8_mb_ecc_error)  $display ("%t: [HQMS_DEBUG]: WARNING: An HCW enqueue [63:0] MB ECC error occurred!", $time);
 end

end

// Assertions for multiple bit ECC errors

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_ingress_mb_ecc_error_0
    ,hqm_system_core.ingress_mb_ecc_error[0]
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_eerr)
    ,`HQM_SVA_ERR_MSG($psprintf("Multiple bit ECC error detected on ingress LUT!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_ingress_mb_ecc_error_1
    ,hqm_system_core.ingress_mb_ecc_error[1]
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_eerr)
    ,`HQM_SVA_ERR_MSG($psprintf("Multiple bit ECC error detected on ingress LUT!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_ingress_mb_ecc_error_2
    ,hqm_system_core.ingress_mb_ecc_error[2]
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_eerr)
    ,`HQM_SVA_ERR_MSG($psprintf("Multiple bit ECC error detected on ingress LUT!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_rob_enq_out_mb_ecc_error
    ,hqm_system_core.i_hqm_system_ingress.rob_enq_out_mb_ecc_error
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_eerr)
    ,`HQM_SVA_ERR_MSG($psprintf("Multiple bit ECC error detected on ingress HCW [127:64]!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_p8_mb_ecc_error
    ,hqm_system_core.i_hqm_system_ingress.p8_mb_ecc_error
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_eerr)
    ,`HQM_SVA_ERR_MSG($psprintf("Multiple bit ECC error detected on ingress HCW [63:0]!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_sch_wb_mb_ecc_error_0
    ,hqm_system_core.sch_wb_mb_ecc_error[0]
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_eerr)
    ,`HQM_SVA_ERR_MSG($psprintf("Multiple bit ECC error detected on scheduled HCW [63:0] (cq=%x)!",
        $sampled(hqm_system_core.sch_wb_ecc_syndrome)))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_sch_wb_mb_ecc_error_1
    ,hqm_system_core.sch_wb_mb_ecc_error[1]
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_eerr)
    ,`HQM_SVA_ERR_MSG($psprintf("Multiple bit ECC error detected on scheduled HCW [127:64] (cq=%x)!",
        $sampled(hqm_system_core.sch_wb_ecc_syndrome)))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_sch_wb_mb_ecc_error_2
    ,hqm_system_core.sch_wb_mb_ecc_error[2]
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_eerr)
    ,`HQM_SVA_ERR_MSG($psprintf("Multiple bit ECC error detected on scheduled HCW [181:128] (cq=%x)!",
        $sampled(hqm_system_core.sch_wb_ecc_syndrome)))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_sch_wb_mb_ecc_error_3
    ,hqm_system_core.sch_wb_mb_ecc_error[3]
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_eerr)
    ,`HQM_SVA_ERR_MSG($psprintf("Multiple bit ECC error detected on scheduled HCW [255:192] (cq=%x)!",
        $sampled(hqm_system_core.sch_wb_ecc_syndrome)))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_cq_addr_overflow_error
    ,hqm_system_core.cq_addr_overflow_error
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_cq_ov)
    ,`HQM_SVA_ERR_MSG($psprintf("CQ address overflowed on a scheduled HCW (cq=%x)!",
        $sampled(hqm_system_core.cq_addr_overflow_syndrome)))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_ingress_perr
    ,hqm_system_core.ingress_perr
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG("An ingress LUT CFG parity error occurred!")
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_egress_perr
    ,(hqm_system_core.egress_perr & ~egress_perr_mask)
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG("An egress LUT or sched req/data parity or residue error occurred!")
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_alarm_perr
    ,hqm_system_core.alarm_perr
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG("An alarm LUT parity error occurred!")
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_sch_sm_error_idv
    ,hqm_system_core.i_hqm_system_write_buffer.sch_sm_error_idv
    ,posedge hqm_system_core.hqm_gated_clk
    ,~hqm_system_core.hqm_gated_rst_n
    ,`HQM_SVA_ERR_MSG($psprintf("A scheduled HCW found the write buffer's internal optimization state in an invalid state (cq=%x beat=%x wbo=%x oip=%x dcq=%x ddv=%x)!",
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.cq),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.beat),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.wbo),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_sm_opt_in_prog_q),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_sm_dir_cq_q),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_sm_dir_data_v_q[2:0])))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_sch_sm_error_wbo
    ,(hqm_system_core.i_hqm_system_write_buffer.sch_sm_error_wbo & ~sch_sm_error_wbo_mask)
    ,posedge hqm_system_core.hqm_gated_clk
    ,~hqm_system_core.hqm_gated_rst_n | ~($sampled(hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop))
    ,`HQM_SVA_ERR_MSG($psprintf("A scheduled HCW had a write_buffer_optimization field indicating more beats than the # of beats remaining in the cache line based on the cq_wptr value (cq=%x beat=%x wbo=%x oip=%x dcq=%x ddv=%x)!",
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.cq),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.beat),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.wbo),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_sm_opt_in_prog_q),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_sm_dir_cq_q),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_sm_dir_data_v_q[2:0])))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_sch_sm_error_vdv
    ,hqm_system_core.i_hqm_system_write_buffer.sch_sm_error_vdv
    ,posedge hqm_system_core.hqm_gated_clk | ~($sampled(hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop))
    ,~hqm_system_core.hqm_gated_rst_n
    ,`HQM_SVA_ERR_MSG($psprintf("A scheduled HCW had a cq_wptr field indicating a write to a beat that was already marked valid (cq=%x beat=%x wbo=%x oip=%x dcq=%x ddv=%x)!",
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.cq),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.beat),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.wbo),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_sm_opt_in_prog_q),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_sm_dir_cq_q),
        $sampled(hqm_system_core.i_hqm_system_write_buffer.sch_sm_dir_data_v_q[2:0])))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_fifo_underflow
    ,(hqm_system_core.fifo_underflow & ~hqm_system_core.alarm_err.FIFO_UNDERFLOW)
    ,posedge hqm_system_core.hqm_gated_clk
    ,~hqm_system_core.hqm_gated_rst_n
    ,`HQM_SVA_ERR_MSG($psprintf("A FIFO underflow occurred!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_fifo_overflow
    ,(hqm_system_core.fifo_overflow & ~hqm_system_core.alarm_err.FIFO_OVERFLOW)
    ,posedge hqm_system_core.hqm_gated_clk
    ,~hqm_system_core.hqm_gated_rst_n
    ,`HQM_SVA_ERR_MSG($psprintf("A FIFO overflow occurred!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_hcw_enq_w_parity_error
    ,(hqm_system_core.hcw_enq_w_req_valid & hqm_system_core.hcw_enq_w_req_ready & ~(^hqm_system_core.hcw_enq_w_req))
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("An HCW enqueue HCW had bad parity!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_wb_residue_error
    ,(hqm_system_core.sch_wb_error & hqm_system_core.sch_wb_error_synd[0])
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("A write buffer sch_out CQ addr residue occurred!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_wb_pl_parity_error
    ,(hqm_system_core.sch_wb_error & hqm_system_core.sch_wb_error_synd[1])
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("A write buffer sch_out pipeline parity error occurred!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_wb_fifo_parity_error
    ,(hqm_system_core.sch_wb_error & hqm_system_core.sch_wb_error_synd[2])
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("A write buffer sch_out FIFO parity error occurred!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_wb_ims_msix_residue_error
    ,(hqm_system_core.sch_wb_error & hqm_system_core.sch_wb_error_synd[3])
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("A write buffer ims_msix interrupt address residue error occurred!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_wb_ims_msix_parity_error
    ,(hqm_system_core.sch_wb_error & hqm_system_core.sch_wb_error_synd[4])
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("A write_buffer ims_msix interrupt pipeline parity error occurred!"))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_vf_synd_parity_error
    ,hqm_system_core.i_hqm_system_alarm.vf_synd_perr
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("A VF syndrome parity error occurred!"))
    , SDG_SVA_SOC_SIM
)

//`HQM_SDG_ASSERTS_FORBIDDEN (
//     assert_forbidden_sif_alarm_inf_v
//    , ( | hqm_system_core.sif_alarm_inf_v )
//    , posedge hqm_system_core.hqm_gated_clk
//    , ~hqm_system_core.hqm_gated_rst_n
//    , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf0: " )
//) ;

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_dir_wb0_v_error
    ,(hqm_system_core.i_hqm_system_write_buffer.memi_dir_wb_next[0].we & 
      ~hqm_system_core.i_hqm_system_write_buffer.dir_wb0_v_next[hqm_system_core.i_hqm_system_write_buffer.memi_dir_wb_next[0].waddr])
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("Writing data to dir_wb0[%0d] without setting dir_wb0_v!",$sampled(hqm_system_core.i_hqm_system_write_buffer.memi_dir_wb_next[0].waddr)))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_dir_wb1_v_error
    ,(hqm_system_core.i_hqm_system_write_buffer.memi_dir_wb_next[1].we & 
      ~hqm_system_core.i_hqm_system_write_buffer.dir_wb1_v_next[hqm_system_core.i_hqm_system_write_buffer.memi_dir_wb_next[1].waddr])
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("Writing data to dir_wb1[%0d] without setting dir_wb1_v!",$sampled(hqm_system_core.i_hqm_system_write_buffer.memi_dir_wb_next[1].waddr)))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_dir_wb2_v_error
    ,(hqm_system_core.i_hqm_system_write_buffer.memi_dir_wb_next[2].we & 
      ~hqm_system_core.i_hqm_system_write_buffer.dir_wb2_v_next[hqm_system_core.i_hqm_system_write_buffer.memi_dir_wb_next[2].waddr])
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("Writing data to dir_wb2[%0d] without setting dir_wb2_v!",$sampled(hqm_system_core.i_hqm_system_write_buffer.memi_dir_wb_next[2].waddr)))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_ldb_wb0_v_error
    ,(hqm_system_core.i_hqm_system_write_buffer.memi_ldb_wb_next[0].we & 
      ~hqm_system_core.i_hqm_system_write_buffer.ldb_wb0_v_next[hqm_system_core.i_hqm_system_write_buffer.memi_ldb_wb_next[0].waddr])
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("Writing data to ldb_wb0[%0d] without setting ldb_wb0_v!",$sampled(hqm_system_core.i_hqm_system_write_buffer.memi_ldb_wb_next[0].waddr)))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_ldb_wb1_v_error
    ,(hqm_system_core.i_hqm_system_write_buffer.memi_ldb_wb_next[1].we & 
      ~hqm_system_core.i_hqm_system_write_buffer.ldb_wb1_v_next[hqm_system_core.i_hqm_system_write_buffer.memi_ldb_wb_next[1].waddr])
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("Writing data to ldb_wb1[%0d] without setting ldb_wb1_v!",$sampled(hqm_system_core.i_hqm_system_write_buffer.memi_ldb_wb_next[1].waddr)))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_ldb_wb2_v_error
    ,(hqm_system_core.i_hqm_system_write_buffer.memi_ldb_wb_next[2].we & 
      ~hqm_system_core.i_hqm_system_write_buffer.ldb_wb2_v_next[hqm_system_core.i_hqm_system_write_buffer.memi_ldb_wb_next[2].waddr])
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("Writing data to ldb_wb2[%0d] without setting ldb_wb2_v!",$sampled(hqm_system_core.i_hqm_system_write_buffer.memi_ldb_wb_next[2].waddr)))
    , SDG_SVA_SOC_SIM
)

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_system_rob_error
    ,hqm_system_core.rob_error
    ,posedge hqm_system_core.hqm_gated_clk
    ,(~hqm_system_core.hqm_gated_rst_n | continue_on_rob_err)
    ,`HQM_SVA_ERR_MSG($psprintf("ROB error for %s PP %d detected!",(($sampled(hqm_system_core.rob_error_synd[6]))?"LDB":"DIR"), $sampled(hqm_system_core.rob_error_synd[5:0])))
    , SDG_SVA_SOC_SIM
)

endmodule

bind hqm_system_core hqm_system_assert i_hqm_system_assert();

`endif

