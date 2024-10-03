
`ifdef INTEL_INST_ON

module hqm_system_inst import hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*, hqm_system_pkg::*, hqm_system_type_pkg::*; ();

  logic hqms_debug;
  logic hqms_no_eot_cnt_checks;
  logic hqms_no_sch_eot_check;

  logic [31:0]  count_hcw_enq_in_q;
  logic [31:0]  count_hcw_enq_w_out_q;
  logic [31:0]  count_hcw_sch_w_in_q;
  logic [31:0]  count_phdr_q;
  logic [31:0]  count_phdr_bytes_q;
  logic [31:0]  count_phdr_inv_q;
  logic [63:0]  countx;
  logic [63:0]  county;
  logic [63:0]  countz;

  //--------------------------------------------------------------------------------------------------------

  initial begin
   $display("@%0tps [HQMS_DEBUG] hqm_system initial block ...",$time);
   hqms_debug='0; if ($test$plusargs("HQMS_DEBUG")) hqms_debug='1;
   $display("@%0tps [HQMS_DEBUG] hqms_debug=%x",$time, hqms_debug);
   hqms_no_eot_cnt_checks='0; if ($test$plusargs("HQMS_NO_EOT_CNT_CHECKS")) hqms_no_eot_cnt_checks='1;
   hqms_no_sch_eot_check='0; if ($test$plusargs("HQMS_NO_SCH_EOT_CHECK")) hqms_no_sch_eot_check='1;
  end // begin

  //--------------------------------------------------------------------------------------------------------

  final begin
   $display("@%0tps [HQMS_INFO] --------------------------------------------------------------------------------------",$time);
   $display("@%0tps [HQMS_INFO] hqm_system final block ...",$time);
   $display("@%0tps [HQMS_INFO] SIM COUNTER HCW_Enqueue_Input_Count                        : 0x0%x",$time,count_hcw_enq_in_q);
   $display("@%0tps [HQMS_INFO] SIM COUNTER HCW_Enqueue_Input_Count(bytes)                 : 0x%x",$time,{count_hcw_enq_in_q,4'h0});
   $display("@%0tps [HQMS_INFO] SIM COUNTER HCW_Enqueue_Output_Count(W)                    : 0x0%x",$time,count_hcw_enq_w_out_q);
   $display("@%0tps [HQMS_INFO] SIM COUNTER HCW_Schedule_Input_Count(W)                    : 0x0%x",$time,count_hcw_sch_w_in_q);
   $display("@%0tps [HQMS_INFO] SIM COUNTER HCW_Schedule_Input_Count(W bytes)              : 0x%x",$time,{count_hcw_sch_w_in_q,4'h0});
   $display("@%0tps [HQMS_INFO] SIM COUNTER Posted_Header_Count                            : 0x0%x",$time,count_phdr_q);
   $display("@%0tps [HQMS_INFO] SIM COUNTER Posted_Header_Count(bytes)                     : 0x0%x",$time,count_phdr_bytes_q);
   $display("@%0tps [HQMS_INFO] SIM COUNTER Posted_Header_Invalid_Count                    : 0x0%x",$time,count_phdr_inv_q);
   $display("@%0tps [HQMS_INFO] --------------------------------------------------------------------------------------",$time);

   $display("@%0tps [HQMS_INFO] HW COUNTER[ 1, 0] Enqueued HCW Input  Count                : 0x%08x_%08x",
        $time, hqm_system_core.hqm_system_cnt[ 1], hqm_system_core.hqm_system_cnt[ 0]);
   $display("");
   $display("@%0tps [HQMS_INFO] HW COUNTER[ 3, 2] Enqueued HCW Output Count                : 0x%08x_%08x",
        $time, hqm_system_core.hqm_system_cnt[ 3], hqm_system_core.hqm_system_cnt[ 2]);
   $display("@%0tps [HQMS_INFO] HW COUNTER[ 5, 4] Enqueued HCW Drop   Count                : 0x%08x_%08x",
        $time, hqm_system_core.hqm_system_cnt[ 5], hqm_system_core.hqm_system_cnt[ 4]);
   $display("");
   countx={hqm_system_core.hqm_system_cnt[ 1], hqm_system_core.hqm_system_cnt[ 0]};
   county={hqm_system_core.hqm_system_cnt[ 3], hqm_system_core.hqm_system_cnt[ 2]}+
          {hqm_system_core.hqm_system_cnt[ 5], hqm_system_core.hqm_system_cnt[ 4]};
   countz={hqm_system_core.hqm_system_cnt[ 3], hqm_system_core.hqm_system_cnt[ 2]};
   $display("@%0tps [HQMS_INFO]                   Input  HCWs = Counter[1,0]               : 0x%08x_%08x",
        $time, (countx>>32), (countx&32'hFFFFFFFF));
   $display("@%0tps [HQMS_INFO]                   Output HCWs = Counter[3,2]+Counter[5,4]  : 0x%08x_%08x",
        $time, (county>>32), (county&32'hFFFFFFFF));
   $display("@%0tps [HQMS_INFO]                   Good   HCWs = Counter[3,2]               : 0x%08x_%08x",
        $time, (countz>>32), (countz&32'hFFFFFFFF));
   $display("");
   if ((hqm_system_core.hqm_system_cnt[ 1] !== 32'hFFFFFFFF) &
       (hqm_system_core.hqm_system_cnt[ 3] !== 32'hFFFFFFFF) &
       (hqm_system_core.hqm_system_cnt[ 5] !== 32'hFFFFFFFF) &
       (countx !== county) & ~hqms_no_eot_cnt_checks) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Number of enqueued HCW inputs (0x%08x_%08x) does not equal number of enqueued HCW outputs (0x%08x_%08x)!!!\n",
        $time, (countx>>32), (countx&32'hFFFFFFFF), (county>>32), (county&32'hFFFFFFFF));
   end
   $display("@%0tps [HQMS_INFO] HW COUNTER[ 7, 6] Scheduled HCW Egress  Input Count        : 0x%08x_%08x",
        $time, hqm_system_core.hqm_system_cnt[ 7], hqm_system_core.hqm_system_cnt[ 6]);
   $display("@%0tps [HQMS_INFO] HW COUNTER[ 9: 8] Scheduled HCW Egress Output Count        : 0x%08x_%08x",
        $time, hqm_system_core.hqm_system_cnt[ 9], hqm_system_core.hqm_system_cnt[ 8]);
   $display("");
   if ((hqm_system_core.hqm_system_cnt[ 9] !== 32'hFFFFFFFF) &
       (hqm_system_core.hqm_system_cnt[ 7] !== 32'hFFFFFFFF) & (~hqms_no_sch_eot_check) &
       ({hqm_system_core.hqm_system_cnt[ 9],hqm_system_core.hqm_system_cnt[ 8]} !==
        {hqm_system_core.hqm_system_cnt[ 7],hqm_system_core.hqm_system_cnt[ 6]}) & ~hqms_no_eot_cnt_checks) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Number of scheduled HCW inputs (0x%08x_%08x) does not equal number of scheduled HCW outputs (0x%08x_%08x)!!!\n",
        $time, hqm_system_core.hqm_system_cnt[7], hqm_system_core.hqm_system_cnt[6],
               hqm_system_core.hqm_system_cnt[9], hqm_system_core.hqm_system_cnt[8]);
   end
   $display("@%0tps [HQMS_INFO] HW COUNTER[21:20] Scheduled HCW Coalesced Count            : 0x%08x_%08x",
        $time, hqm_system_core.hqm_system_cnt[21], hqm_system_core.hqm_system_cnt[20]);
   countx={hqm_system_core.hqm_system_cnt[ 9], hqm_system_core.hqm_system_cnt[ 8]}-
          {hqm_system_core.hqm_system_cnt[21], hqm_system_core.hqm_system_cnt[20]};
   $display("");
   $display("@%0tps [HQMS_INFO]                   SCH Writes = Counter[9,8]-Counter[21,20] : 0x%08x_%08x",
        $time, (countx>>32), (countx&32'hFFFFFFFF));
   $display("");
   $display("@%0tps [HQMS_INFO] HW COUNTER[13,12] IMS    Write Request Input Count         : 0x%08x_%08x",
        $time, hqm_system_core.hqm_system_cnt[13], hqm_system_core.hqm_system_cnt[12]);
   $display("@%0tps [HQMS_INFO] HW COUNTER[15:14] MSI-X  Write Request Input Count         : 0x%08x_%08x",
        $time, hqm_system_core.hqm_system_cnt[15], hqm_system_core.hqm_system_cnt[14]);
   $display("");
   $display("@%0tps [HQMS_INFO] HW COUNTER[11,10] Posted Header Write Invalid Count        : 0x%08x_%08x",
        $time, hqm_system_core.hqm_system_cnt[11], hqm_system_core.hqm_system_cnt[10]);
   $display("@%0tps [HQMS_INFO] HW COUNTER[17,16] Posted Header Write Output Count         : 0x%08x_%08x",
        $time, hqm_system_core.hqm_system_cnt[17], hqm_system_core.hqm_system_cnt[16]);
   $display("@%0tps [HQMS_INFO] HW COUNTER[19,18] Posted Header Write Drop   Count         : 0x%08x_%08x",
        $time, hqm_system_core.hqm_system_cnt[19], hqm_system_core.hqm_system_cnt[18]);
   $display("");
   countx={hqm_system_core.hqm_system_cnt[ 9], hqm_system_core.hqm_system_cnt[ 8]}-
          {hqm_system_core.hqm_system_cnt[21], hqm_system_core.hqm_system_cnt[20]}+
          {hqm_system_core.hqm_system_cnt[13], hqm_system_core.hqm_system_cnt[12]}+
          {hqm_system_core.hqm_system_cnt[15], hqm_system_core.hqm_system_cnt[14]};
   $display("@%0tps [HQMS_INFO]         WBUF Input  Writes = [9,8]+[13,12]+[15,14]-[21,20] : 0x%08x_%08x",
        $time, (countx>>32), (countx&32'hFFFFFFFF));
   county={hqm_system_core.hqm_system_cnt[17], hqm_system_core.hqm_system_cnt[16]}+
          {hqm_system_core.hqm_system_cnt[19], hqm_system_core.hqm_system_cnt[18]};
   $display("@%0tps [HQMS_INFO]         WBUF Output Writes = Counter[17,16]+[19,18]        : 0x%08x_%08x",
        $time, (county>>32), (county&32'hFFFFFFFF));
   $display("");
   if ((hqm_system_core.hqm_system_cnt[ 9] !== 32'hFFFFFFFF) &
       (hqm_system_core.hqm_system_cnt[13] !== 32'hFFFFFFFF) &
       (hqm_system_core.hqm_system_cnt[15] !== 32'hFFFFFFFF) &
       (hqm_system_core.hqm_system_cnt[17] !== 32'hFFFFFFFF) &
       (hqm_system_core.hqm_system_cnt[19] !== 32'hFFFFFFFF) &
       (hqm_system_core.hqm_system_cnt[21] !== 32'hFFFFFFFF) &
       (countx !== county) & ~hqms_no_eot_cnt_checks) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Number of WBUF write inputs (0x%08x_%08x) does not equal number of WBUF write outputs (0x%08x_%08x)!!!\n",
        $time, (countx>>32), (countx&32'hFFFFFFFF), (county>>32), (county&32'hFFFFFFFF));
   $display("@%0tps [HQMS_INFO] --------------------------------------------------------------------------------------",$time);
   end
  end // final

  //--------------------------------------------------------------------------------------------------------
  // Counters

  always_ff @(posedge hqm_system_core.prim_gated_clk or 
              negedge hqm_system_core.prim_gated_rst_n) begin
   if (~hqm_system_core.prim_gated_rst_n) begin
    count_hcw_enq_in_q <= '0;
   end else begin
    if (hqm_system_core.hcw_enq_in_v &
        hqm_system_core.hcw_enq_in_ready)
            count_hcw_enq_in_q <= count_hcw_enq_in_q + 1;
   end
  end

  always_ff @(posedge hqm_system_core.hqm_inp_gated_clk or 
              negedge hqm_system_core.hqm_inp_gated_rst_b_sys) begin
   if (~hqm_system_core.hqm_inp_gated_rst_b_sys) begin
    count_hcw_enq_w_out_q <= '0;
    count_hcw_sch_w_in_q <= '0;
    count_phdr_q <= '0;
    count_phdr_bytes_q <= '0;
    count_phdr_inv_q <= '0;
   end else begin
    if (hqm_system_core.hcw_enq_w_req_valid &
        hqm_system_core.hcw_enq_w_req_ready)
            count_hcw_enq_w_out_q <= count_hcw_enq_w_out_q + 1;
    if (hqm_system_core.hcw_sched_w_req_valid &
        hqm_system_core.hcw_sched_w_req_ready)
            count_hcw_sch_w_in_q <= count_hcw_sch_w_in_q + 1;
    if (hqm_system_core.pwrite_v & ~hqm_system_core.write_buffer_mstr.hdr.invalid)
            count_phdr_q <= count_phdr_q + 1;
    if (hqm_system_core.pwrite_v & ~hqm_system_core.write_buffer_mstr.hdr.invalid)
            count_phdr_bytes_q <= count_phdr_bytes_q +
                {hqm_system_core.write_buffer_mstr.hdr.length, 2'd0};
    if (hqm_system_core.pwrite_v & hqm_system_core.write_buffer_mstr.hdr.invalid)
            count_phdr_inv_q <= count_phdr_inv_q + 1;
   end
  end

  //--------------------------------------------------------------------------------------------------------

  always_ff @(posedge hqm_system_core.i_hqm_system_ingress.prim_gated_clk) begin
   if (hqms_debug & (hqm_system_core.i_hqm_system_ingress.prim_gated_rst_n === 1'b1)) begin
    if (hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push)
     $display("%0tps: [HQMS_DEBUG] INGRESS HCW FIFO PUSH: ppar=%x (pf=%x nm=%x cl=%x/0x%0x/%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) ecc=%x%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.port_parity
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.is_nm_pf
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.cl_last
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.cl
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.cli
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.vpp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.ecc_h
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_push_data.ecc_l
     );
   end
  end

  always_ff @(posedge hqm_system_core.hqm_inp_gated_clk) begin
   if (hqms_debug & (hqm_system_core.hqm_inp_gated_rst_b_sys === 1'b1)) begin
    if (hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop)
     $display("%0tps: [HQMS_DEBUG] INGRESS HCW FIFO POP:  ppar=%x (pf=%x nm=%x cl=%x/0x%0x/%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) ecc=%x%x pp_rob_v=%x rob_we=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.port_parity
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.is_nm_pf
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.cl_last
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.cl
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.cli
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.vpp
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.ecc_h
        ,hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data.ecc_l
        ,hqm_system_core.i_hqm_system_ingress.i_hqm_system_rob.rob_enabled
        ,hqm_system_core.i_hqm_system_ingress.memi_rob_mem.we
     );
    if (hqm_system_core.i_hqm_system_ingress.rob_enq_out_ready_limited & hqm_system_core.i_hqm_system_ingress.rob_enq_out_v)
     $display("%0tps: [HQMS_DEBUG] INGRESS HCW ROB OUT:   ppar=%x (pf=%x nm=%x rob_src=%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) ecc=%x%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.port_parity
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.is_nm_pf
        ,hqm_system_core.i_hqm_system_ingress.i_hqm_system_rob.rob_sourcing_q
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.vpp
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.ecc_h
        ,hqm_system_core.i_hqm_system_ingress.rob_enq_out.ecc_l
     );
    if (hqm_system_core.i_hqm_system_ingress.p0_v_q & hqm_system_core.i_hqm_system_ingress.p1_load)
     if (hqm_system_core.i_hqm_system_ingress.p0_cfg_q) begin
      if (~hqm_system_core.i_hqm_system_ingress.p0_cfg_we_q | &hqm_system_core.i_hqm_system_ingress.p2_cfg_we_q)
       $display("%0tps: [HQMS_DEBUG] INGRESS CFG P0:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.cfg_re_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_we_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_wdata_q
       );
     end else
      $display("%0tps: [HQMS_DEBUG] INGRESS HCW P0:        ppar=%x (pf=%x nm=%x vdev=%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) eccl=%x mb_ecc_err=%x ms_par=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.port_parity
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.is_nm_pf
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.vdev
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.vpp
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.ecc_l
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.mb_ecc_err
        ,hqm_system_core.i_hqm_system_ingress.p0_data_q.hcw_parity_ms
      );
    if (hqm_system_core.i_hqm_system_ingress.p1_v_q & ~hqm_system_core.i_hqm_system_ingress.p2_hold)
     if (hqm_system_core.i_hqm_system_ingress.p1_cfg_q)
      $display("%0tps: [HQMS_DEBUG] INGRESS CFG P1:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.cfg_re_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_we_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] INGRESS HCW P1:        ppar=%x (pf=%x nm=%x vdev=%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) eccl=%x mb_ecc_err=%x ms_par=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.port_parity
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.is_nm_pf
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.vdev
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.vpp
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.ecc_l
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.mb_ecc_err
        ,hqm_system_core.i_hqm_system_ingress.p1_data_q.hcw_parity_ms
      );
    if (hqm_system_core.i_hqm_system_ingress.p2_v_q & ~hqm_system_core.i_hqm_system_ingress.p3_hold)
     if (hqm_system_core.i_hqm_system_ingress.p2_cfg_q)
      $display("%0tps: [HQMS_DEBUG] INGRESS CFG P2:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.cfg_re_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_we_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] INGRESS HCW P2:        ppar=%x (pf=%x nm=%x vdev=%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) eccl=%x mb_ecc_err=%x ms_par=%x pp_v=%x pp=%x qid_v=%x perr=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.port_parity
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.is_nm_pf
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.vdev
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.vpp
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.ecc_l
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.mb_ecc_err
        ,hqm_system_core.i_hqm_system_ingress.p2_data_q.hcw_parity_ms
        ,hqm_system_core.i_hqm_system_ingress.p2_pp_v
        ,hqm_system_core.i_hqm_system_ingress.p2_pp
        ,hqm_system_core.i_hqm_system_ingress.p2_qid_v
        ,hqm_system_core.i_hqm_system_ingress.p2_perr
      );
    if (hqm_system_core.i_hqm_system_ingress.p3_v_q &
        hqm_system_core.i_hqm_system_ingress.p4_load)
     if (hqm_system_core.i_hqm_system_ingress.p3_cfg_q) begin
      if (~hqm_system_core.i_hqm_system_ingress.p3_cfg_we_q |
          &hqm_system_core.i_hqm_system_ingress.p5_cfg_we_q)
       $display("%0tps: [HQMS_DEBUG] INGRESS CFG P3:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.cfg_re_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_we_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_wdata_q
       );
     end else
      $display("%0tps: [HQMS_DEBUG] INGRESS HCW P3:        ppar=%x (pf=%x      vdev=%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) eccl=%x mb_ecc_err=%x ms_par=%x pp_v=%x pp=%x qid_v=%x perr=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.port_parity
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.vdev
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.vpp
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.ecc_l
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.mb_ecc_err
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.hcw_parity_ms
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.pp_v
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.pp
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.qid_v
        ,hqm_system_core.i_hqm_system_ingress.p3_data_q.parity_err
      );
    if (hqm_system_core.i_hqm_system_ingress.p4_v_q &
       ~hqm_system_core.i_hqm_system_ingress.p5_hold)
     if (hqm_system_core.i_hqm_system_ingress.p4_cfg_q)
      $display("%0tps: [HQMS_DEBUG] INGRESS CFG P4:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.cfg_re_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_we_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] INGRESS HCW P4:        ppar=%x (pf=%x      vdev=%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) eccl=%x mb_ecc_err=%x ms_par=%x pp_v=%x pp=%x qid_v=%x perr=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.port_parity
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.vdev
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.vpp
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.ecc_l
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.mb_ecc_err
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.hcw_parity_ms
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.pp_v
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.pp
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.qid_v
        ,hqm_system_core.i_hqm_system_ingress.p4_data_q.parity_err
      );
    if (hqm_system_core.i_hqm_system_ingress.p5_v_q &
       ~hqm_system_core.i_hqm_system_ingress.p6_hold)
     if (hqm_system_core.i_hqm_system_ingress.p5_cfg_q)
      $display("%0tps: [HQMS_DEBUG] INGRESS CFG P5:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.cfg_re_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_we_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] INGRESS HCW P5:        ppar=%x (pf=%x      vdev=%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) eccl=%x mb_ecc_err=%x ms_par=%x pp_v=%x pp=%x qid_v=%x perr=%x vas=%x qid_cfg_v=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.port_parity
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.vdev
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.vpp
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.ecc_l
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.mb_ecc_err
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.hcw_parity_ms
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.pp_v
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.pp
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.qid_v
        ,hqm_system_core.i_hqm_system_ingress.p5_data_q.parity_err
        ,hqm_system_core.i_hqm_system_ingress.p5_vas
        ,hqm_system_core.i_hqm_system_ingress.p5_qid_cfg_v
      );
    if (hqm_system_core.i_hqm_system_ingress.p6_v_q &
        hqm_system_core.i_hqm_system_ingress.p7_load)
     if (hqm_system_core.i_hqm_system_ingress.p6_cfg_q) begin
      if (~hqm_system_core.i_hqm_system_ingress.p6_cfg_we_q |
          &hqm_system_core.i_hqm_system_ingress.p8_cfg_we_q)
       $display("%0tps: [HQMS_DEBUG] INGRESS CFG P6:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.cfg_re_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_we_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_wdata_q
       );
     end else
      $display("%0tps: [HQMS_DEBUG] INGRESS HCW P6:        ppar=%x (pf=%x      vdev=%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) eccl=%x mb_ecc_err=%x ms_par=%x pp_v=%x pp=%x qid_v=%x         perr=%x vas=%x qid_cfg_v=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.port_parity
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.vdev
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.vpp
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.ecc_l
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.mb_ecc_err
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.hcw_parity_ms
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.pp_v
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.pp
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.qid_v
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.parity_err
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.vas
        ,hqm_system_core.i_hqm_system_ingress.p6_data_q.qid_cfg_v
      );
    if (hqm_system_core.i_hqm_system_ingress.p7_v_q &
       ~hqm_system_core.i_hqm_system_ingress.p8_hold)
     if (hqm_system_core.i_hqm_system_ingress.p7_cfg_q)
      $display("%0tps: [HQMS_DEBUG] INGRESS CFG P7:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.cfg_re_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_we_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] INGRESS HCW P7:        ppar=%x (pf=%x      vdev=%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) eccl=%x mb_ecc_err=%x ms_par=%x pp_v=%x pp=%x qid_v=%x        perr=%x vas=%x qid_cfg_v=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.port_parity
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.vdev
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.vpp
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.ecc_l
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.mb_ecc_err
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.hcw_parity_ms
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.pp_v
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.pp
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.qid_v
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.parity_err
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.vas
        ,hqm_system_core.i_hqm_system_ingress.p7_data_q.qid_cfg_v
      );
    if (hqm_system_core.i_hqm_system_ingress.p8_v_q &
        hqm_system_core.i_hqm_system_ingress.hcw_enq_out_ready)
     if (hqm_system_core.i_hqm_system_ingress.p8_cfg_q)
      $display("%0tps: [HQMS_DEBUG] INGRESS CFG P8:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.cfg_re_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_we_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_ingress.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] INGRESS HCW P8:        ppar=%x (pf=%x      vdev=%x ldb=%x vpp=%x) hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) eccl=%x mb_ecc_err=%x ms_par=%x pp_v=%x pp=%x qid_v=%x         perr=%x vas=%x qid_cfg_v=%x vasqid_v=%x ins_ts=%x ppe=%x pe=%x alrm=%x aid=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.port_parity
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.is_pf_port
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.vdev
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.is_ldb_port
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.vpp
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.hcw.cmd
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.hcw.debug
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.hcw.dsi
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.hcw.ptr
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.ecc_l
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.mb_ecc_err
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.hcw_parity_ms
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.pp_v
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.pp
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.qid_v
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.parity_err
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.vas
        ,hqm_system_core.i_hqm_system_ingress.p8_data_q.qid_cfg_v
        ,hqm_system_core.i_hqm_system_ingress.p8_vasqid_v
        ,hqm_system_core.i_hqm_system_ingress.p8_qid_its
        ,hqm_system_core.i_hqm_system_ingress.p8_port_perr
        ,hqm_system_core.i_hqm_system_ingress.p8_perr
        ,hqm_system_core.i_hqm_system_ingress.ingress_alarm_v_next
        ,hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid
      );
    if (hqm_system_core.hcw_enq_w_req_valid &
        hqm_system_core.hcw_enq_w_req_ready)
     $display("%0tps: [HQMS_DEBUG] INGRESS HCW OUT:        pp=%x ppldb=%x qid=%x qeldb=%x vas=%x ao_v=%x hcw(cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) par=%x hcw_par=%x"
        ,$time
        ,hqm_system_core.hcw_enq_w_req.user.pp
        ,hqm_system_core.hcw_enq_w_req.user.pp_is_ldb
        ,hqm_system_core.hcw_enq_w_req.user.qid
        ,hqm_system_core.hcw_enq_w_req.user.qe_is_ldb
        ,hqm_system_core.hcw_enq_w_req.user.vas
        ,hqm_system_core.hcw_enq_w_req.user.ao_v
        ,hqm_system_core.hcw_enq_w_req.data.cmd
        ,hqm_system_core.hcw_enq_w_req.data.debug
        ,hqm_system_core.hcw_enq_w_req.data.lockid_dir_info_tokens
        ,hqm_system_core.hcw_enq_w_req.data.msg_info.msgtype
        ,hqm_system_core.hcw_enq_w_req.data.msg_info.qpri
        ,hqm_system_core.hcw_enq_w_req.data.msg_info.qtype
        ,hqm_system_core.hcw_enq_w_req.data.msg_info.qid
        ,hqm_system_core.hcw_enq_w_req.data.dsi
        ,hqm_system_core.hcw_enq_w_req.data.ptr
        ,hqm_system_core.hcw_enq_w_req.user.parity
        ,hqm_system_core.hcw_enq_w_req.user.hcw_parity
     );

    if (|{hqm_system_core.i_hqm_system_ingress.cfg_rvalid,
          hqm_system_core.i_hqm_system_ingress.cfg_wvalid})
     $display("%0tps: [HQMS_DEBUG] INGRESS CFG ACK: rv=%x wv=%x          rdata=%x err=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.cfg_rvalid
        ,hqm_system_core.i_hqm_system_ingress.cfg_wvalid
        ,hqm_system_core.i_hqm_system_ingress.cfg_rdata
        ,hqm_system_core.i_hqm_system_ingress.cfg_error
     );

    if (hqm_system_core.i_hqm_system_ingress.p9_load &
       ~hqm_system_core.i_hqm_system_ingress.hcw_enq_w_v)
     $display ("%0tps: [HQMS_DEBUG] INGRESS HCW DROP:  aid=%x %s"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid
        ,((hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd0)                ? "Illegal HCW command or PP type"    :
         ((hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd1)                ? "PP not valid                  "    :
         ((hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd3)                ? 
          (((hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qtype == DIRECT) ?
            (hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info[7:0] >= NUM_DIR_QID) :
            (hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info[7:0] >= NUM_LDB_QID)) ?
                                                                                                 "QID is out of range           "    :
            ((~hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.qid_v)                    ? "QID not valid                 "    :
                                                                                                 "RELEASE command on DIR QID    "))  :
         ((hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd4)                ? "QID not valid for VAS         "    :
         ((hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd5)                ? "LDB QID_CFG not correct       "    :
         ((hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd43)               ?
          ((hqm_system_core.i_hqm_system_ingress.p8_port_perr == 1'b1)                         ? "HCW header parity err         "    :
                                                                                                 "Ingress LUT parity err        ")   :
         ((hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd44)               ? "Multi bit HCW ECC err         "    :
                                                                                                 "XXX                           ")))))))
     );

    if (hqm_system_core.i_hqm_system_ingress.p9_load &
        hqm_system_core.i_hqm_system_ingress.hcw_enq_w_v &
        ((hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.cmd.hcw_cmd_field.qe_valid &
         ~hqm_system_core.i_hqm_system_ingress.hcw_enq_w.data.cmd.hcw_cmd_field.qe_valid) |
         (hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.cmd.hcw_cmd_field.qe_orsp &
         ~hqm_system_core.i_hqm_system_ingress.hcw_enq_w.data.cmd.hcw_cmd_field.qe_orsp)))
     $display ("%0tps: [HQMS_DEBUG] INGRESS HCW DROP (QE-ONLY - CQ portion sent to core):  aid=%x %s"
        ,$time
        ,hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid
        ,((hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd3)                ? 
          (((hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info.qtype == DIRECT) ?
            (hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info[7:0] >= NUM_DIR_QID) :
            (hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.hcw.msg_info[7:0] >= NUM_LDB_QID)) ?
                                                                                                 "QID is out of range           "    :
            ((~hqm_system_core.i_hqm_system_ingress.hcw_enq_out_data.qid_v)                    ? "QID not valid                 "    :
                                                                                                 "RELEASE command on DIR QID    "))  :
         ((hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd4)                ? "QID not valid for VAS         "    :
         ((hqm_system_core.i_hqm_system_ingress.ingress_alarm_next.aid == 6'd5)                ? "LDB QID_CFG not correct       "    :
                                                                                                 "XXX                           ")))
     );

   end // debug

  end // ingress.hqm_inp_gated_clk

  //--------------------------------------------------------------------------------------------------------

  always_ff @(posedge hqm_system_core.hqm_inp_gated_clk) begin
   if (hqms_debug & (hqm_system_core.hqm_inp_gated_rst_b_sys === 1'b1)) begin

    if (hqm_system_core.i_hqm_system_egress.hcw_sched_w_req_valid &
        hqm_system_core.i_hqm_system_egress.hcw_sched_w_req_ready) 
     $display("%0tps: [HQMS_DEBUG] EGRESS SCH IN:           cq=%x wp=%x par=%x (ldb=%x cm=%x rbeats=%x icqd=%x) hcw(err=%x qidd=%x gen=%x cid=%x db=%x tsf=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x)"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.user.cq
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.user.cq_wptr
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.user.hqm_core_flags.parity
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.user.hqm_core_flags.cq_is_ldb
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.user.hqm_core_flags.congestion_management
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.user.hqm_core_flags.write_buffer_optimization
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.user.hqm_core_flags.ignore_cq_depth
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.flags.hcw_error
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.flags.qid_depth
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.flags.cq_gen
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.debug.cmp_id
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.debug.debug
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.debug.ts_flag
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.msg_info.qpri
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.msg_info.qtype
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.msg_info.qid
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.dsi_timestamp
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_w_req.data.ptr
     );
    if (hqm_system_core.i_hqm_system_egress.p0_v_q &
        hqm_system_core.i_hqm_system_egress.p1_load)
     if (hqm_system_core.i_hqm_system_egress.p0_cfg_q) begin
      if (~hqm_system_core.i_hqm_system_egress.p0_cfg_we_q |
          &hqm_system_core.i_hqm_system_egress.p2_cfg_we_q)
       $display("%0tps: [HQMS_DEBUG] EGRESS SCH CFG P0:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.cfg_re_q
        ,hqm_system_core.i_hqm_system_egress.cfg_we_q
        ,hqm_system_core.i_hqm_system_egress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_egress.cfg_wdata_q
       );
     end else
      $display("%0tps: [HQMS_DEBUG] EGRESS SCH P0:   hcw_v=%x cq=%x wp=%x par=%x (ldb=%x cm=%x rbeats=%x icqd=%x) hcw(err=%x qidd=%x gen=%x cid=%x db=%x tsf=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) (int_v=%x ldb=%x cq=%x)"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.hcw_v
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.user.cq
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.user.cq_wptr
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.user.hqm_core_flags.parity
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.user.hqm_core_flags.cq_is_ldb
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.user.hqm_core_flags.congestion_management
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.user.hqm_core_flags.write_buffer_optimization
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.user.hqm_core_flags.ignore_cq_depth
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.flags.hcw_error
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.flags.qid_depth
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.flags.cq_gen
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.debug.cmp_id
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.debug.debug
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.debug.ts_flag
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.msg_info.qpri
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.msg_info.qtype
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.msg_info.qid
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.dsi_timestamp
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.w.data.ptr
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.int_v
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_egress.p0_data_q.int_d.cq_occ_cq
      );
    if (hqm_system_core.i_hqm_system_egress.p1_v_q &
       ~hqm_system_core.i_hqm_system_egress.p2_hold)
     if (hqm_system_core.i_hqm_system_egress.p1_cfg_q)
      $display("%0tps: [HQMS_DEBUG] EGRESS SCH CFG P1:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.cfg_re_q
        ,hqm_system_core.i_hqm_system_egress.cfg_we_q
        ,hqm_system_core.i_hqm_system_egress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_egress.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] EGRESS SCH P1:   hcw_v=%x cq=%x wp=%x par=%x (ldb=%x cm=%x rbeats=%x icqd=%x) hcw(err=%x qidd=%x gen=%x cid=%x db=%x tsf=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) (int_v=%x ldb=%x cq=%x)"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.hcw_v
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.user.cq
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.user.cq_wptr
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.user.hqm_core_flags.parity
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.user.hqm_core_flags.cq_is_ldb
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.user.hqm_core_flags.congestion_management
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.user.hqm_core_flags.write_buffer_optimization
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.user.hqm_core_flags.ignore_cq_depth
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.flags.hcw_error
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.flags.qid_depth
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.flags.cq_gen
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.debug.cmp_id
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.debug.debug
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.debug.ts_flag
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.msg_info.qpri
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.msg_info.qtype
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.msg_info.qid
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.dsi_timestamp
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.w.data.ptr
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.int_v
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_egress.p1_data_q.int_d.cq_occ_cq
      );
    if (hqm_system_core.i_hqm_system_egress.p2_v_q &
       ~hqm_system_core.i_hqm_system_egress.p3_hold)
     if (hqm_system_core.i_hqm_system_egress.p2_cfg_q)
      $display("%0tps: [HQMS_DEBUG] EGRESS SCH CFG P2:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.cfg_re_q
        ,hqm_system_core.i_hqm_system_egress.cfg_we_q
        ,hqm_system_core.i_hqm_system_egress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_egress.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] EGRESS SCH P2:   hcw_v=%x cq=%x wp=%x par=%x (ldb=%x cm=%x rbeats=%x icqd=%x) hcw(err=%x qidd=%x gen=%x cid=%x db=%x tsf=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) (int_v=%x ldb=%x cq=%x) pf=%x vf=%x keeppfppid=%x cq_addr=%x pasid=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.hcw_v
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.user.cq
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.user.cq_wptr
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.user.hqm_core_flags.parity
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.user.hqm_core_flags.cq_is_ldb
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.user.hqm_core_flags.congestion_management
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.user.hqm_core_flags.write_buffer_optimization
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.user.hqm_core_flags.ignore_cq_depth
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.flags.hcw_error
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.flags.qid_depth
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.flags.cq_gen
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.debug.cmp_id
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.debug.debug
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.debug.ts_flag
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.msg_info.qpri
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.msg_info.qtype
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.msg_info.qid
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.dsi_timestamp
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.w.data.ptr
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.int_v
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_egress.p2_data_q.int_d.cq_occ_cq
        ,hqm_system_core.i_hqm_system_egress.p2_is_pf
        ,hqm_system_core.i_hqm_system_egress.p2_vf
        ,hqm_system_core.i_hqm_system_egress.p2_cq_fmt
        ,hqm_system_core.i_hqm_system_egress.p2_cq_addr
        ,hqm_system_core.i_hqm_system_egress.p2_cq_pasidtlp
      );
    if (hqm_system_core.i_hqm_system_egress.p3_v_q &
        hqm_system_core.i_hqm_system_egress.p4_load)
     if (hqm_system_core.i_hqm_system_egress.p3_cfg_q) begin
      if (~hqm_system_core.i_hqm_system_egress.p3_cfg_we_q |
          &hqm_system_core.i_hqm_system_egress.p5_cfg_we_q)
       $display("%0tps: [HQMS_DEBUG] EGRESS SCH CFG P3:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.cfg_re_q
        ,hqm_system_core.i_hqm_system_egress.cfg_we_q
        ,hqm_system_core.i_hqm_system_egress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_egress.cfg_wdata_q
       );
     end else
      $display("%0tps: [HQMS_DEBUG] EGRESS SCH P3:   hcw_v=%x cq=%x wp=%x par=%x (ldb=%x cm=%x rbeats=%x icqd=%x) hcw(err=%x qidd=%x gen=%x cid=%x db=%x tsf=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) (int_v=%x ldb=%x cq=%x) pf=%x vf=%x keeppf=%x cq_addr=%x pasid=%x perr=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.hcw_v
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.user.cq
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.user.cq_wptr
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.user.hqm_core_flags.parity
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.user.hqm_core_flags.cq_is_ldb
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.user.hqm_core_flags.congestion_management
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.user.hqm_core_flags.write_buffer_optimization
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.user.hqm_core_flags.ignore_cq_depth
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.flags.hcw_error
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.flags.qid_depth
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.flags.cq_gen
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.debug.cmp_id
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.debug.debug
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.debug.ts_flag
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.msg_info.qpri
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.msg_info.qtype
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.msg_info.qid
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.dsi_timestamp
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.w.data.ptr
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.int_v
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.int_d.cq_occ_cq
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.is_pf
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.vf
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.keep_pf_ppid
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.cq_addr
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.pasidtlp
        ,hqm_system_core.i_hqm_system_egress.p3_data_q.perr
      );
    if (hqm_system_core.i_hqm_system_egress.p4_v_q &
       ~hqm_system_core.i_hqm_system_egress.p5_hold)
     if (hqm_system_core.i_hqm_system_egress.p4_cfg_q)
      $display("%0tps: [HQMS_DEBUG] EGRESS SCH CFG P4:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.cfg_re_q
        ,hqm_system_core.i_hqm_system_egress.cfg_we_q
        ,hqm_system_core.i_hqm_system_egress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_egress.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] EGRESS SCH P4:   hcw_v=%x cq=%x wp=%x par=%x (ldb=%x cm=%x rbeats=%x icqd=%x) hcw(err=%x qidd=%x gen=%x cid=%x db=%x tsf=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) (int_v=%x ldb=%x cq=%x) pf=%x vf=%x keeppf=%x cq_addr=%x pasid=%x perr=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.hcw_v
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.user.cq
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.user.cq_wptr
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.user.hqm_core_flags.parity
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.user.hqm_core_flags.cq_is_ldb
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.user.hqm_core_flags.congestion_management
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.user.hqm_core_flags.write_buffer_optimization
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.user.hqm_core_flags.ignore_cq_depth
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.flags.hcw_error
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.flags.qid_depth
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.flags.cq_gen
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.debug.cmp_id
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.debug.debug
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.debug.ts_flag
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.msg_info.qpri
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.msg_info.qtype
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.msg_info.qid
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.dsi_timestamp
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.w.data.ptr
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.int_v
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.int_d.cq_occ_cq
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.is_pf
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.vf
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.keep_pf_ppid
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.cq_addr
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.pasidtlp
        ,hqm_system_core.i_hqm_system_egress.p4_data_q.perr
      );
    if (hqm_system_core.i_hqm_system_egress.p5_v_q)
     if (hqm_system_core.i_hqm_system_egress.p5_cfg_q)
      $display("%0tps: [HQMS_DEBUG] EGRESS SCH CFG P5:  re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.cfg_re_q
        ,hqm_system_core.i_hqm_system_egress.cfg_we_q
        ,hqm_system_core.i_hqm_system_egress.cfg_addr_q
        ,hqm_system_core.i_hqm_system_egress.cfg_wdata_q
      );
     else if (hqm_system_core.i_hqm_system_egress.sched_out_ready)
      $display("%0tps: [HQMS_DEBUG] EGRESS SCH P5:   hcw_v=%x cq=%x wp=%x par=%x (ldb=%x cm=%x rbeats=%x icqd=%x) hcw(err=%x qidd=%x gen=%x cid=%x db=%x tsf=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) (int_v=%x ldb=%x cq=%x) pf=%x vf=%x keeppf=%x cq_addr=%x pasid=%x perr=%x vqid=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.hcw_v
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.user.cq
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.user.cq_wptr
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.user.hqm_core_flags.parity
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.user.hqm_core_flags.cq_is_ldb
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.user.hqm_core_flags.congestion_management
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.user.hqm_core_flags.write_buffer_optimization
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.user.hqm_core_flags.ignore_cq_depth
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.flags.hcw_error
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.flags.qid_depth
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.flags.cq_gen
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.debug.cmp_id
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.debug.debug
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.debug.ts_flag
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.msg_info.qpri
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.msg_info.qtype
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.msg_info.qid
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.dsi_timestamp
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.w.data.ptr
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.int_v
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.int_d.cq_occ_cq
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.is_pf
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.vf
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.keep_pf_ppid
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.cq_addr
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.pasidtlp
        ,hqm_system_core.i_hqm_system_egress.p5_data_q.perr
        ,hqm_system_core.i_hqm_system_egress.p5_vqid
      );
    if (hqm_system_core.i_hqm_system_egress.hcw_sched_out_v &
        hqm_system_core.i_hqm_system_egress.hcw_sched_out_ready)
      $display("%0tps: [HQMS_DEBUG] EGRESS SCH OUT   hcw_v=%x cq=%x wp=%x par=%x (ldb=%x cm=%x rbeats=%x icqd=%x) hcw(err=%x qidd=%x gen=%x cid=%x db=%x tsf=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x ptr=%x) (int_v=%x ldb=%x cq=%x) pf=%x vf=%x ecc=%x cq_addr=%x pasid=%x err=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.hcw_v
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.user.cq
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.user.cq_wptr
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.user.hqm_core_flags.parity
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.user.hqm_core_flags.cq_is_ldb
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.user.hqm_core_flags.congestion_management
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.user.hqm_core_flags.write_buffer_optimization
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.user.hqm_core_flags.ignore_cq_depth
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.flags.hcw_error
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.flags.qid_depth
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.flags.cq_gen
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.debug.cmp_id
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.debug.debug
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.debug.ts_flag
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.msg_info.qpri
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.msg_info.qtype
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.msg_info.qid
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.dsi_timestamp
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.w.data.ptr
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.int_v
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.int_d.cq_occ_cq
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.is_pf
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.vf
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.ecc
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.cq_addr
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.pasidtlp
        ,hqm_system_core.i_hqm_system_egress.hcw_sched_out.error
     );

    if (|{hqm_system_core.i_hqm_system_egress.cfg_rvalid,
          hqm_system_core.i_hqm_system_egress.cfg_wvalid})
     $display("%0tps: [HQMS_DEBUG] EGRESS     CFG ACK: rv=%x wv=%x          rdata=%x err=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_egress.cfg_rvalid
        ,hqm_system_core.i_hqm_system_egress.cfg_wvalid
        ,hqm_system_core.i_hqm_system_egress.cfg_rdata
        ,hqm_system_core.i_hqm_system_egress.cfg_error
     );

   end // debug

  end // egress.hqm_inp_gated_clk

  //--------------------------------------------------------------------------------------------------------

  logic sch_hdr_v_q;
  logic sch_data_v_q;
  logic ims_msix_w_ready_q;

  always_ff @(posedge hqm_system_core.hqm_inp_gated_clk or
              negedge hqm_system_core.hqm_inp_gated_rst_b_sys) begin
   if (~hqm_system_core.hqm_inp_gated_rst_b_sys) begin

    sch_hdr_v_q          <= '0;
    sch_data_v_q         <= '0;
    ims_msix_w_ready_q   <= '0;

   end else begin

    sch_hdr_v_q          <= hqm_system_core.i_hqm_system_write_buffer.sch_hdr_v;
    sch_data_v_q         <= hqm_system_core.i_hqm_system_write_buffer.sch_data_v;
    ims_msix_w_ready_q   <= hqm_system_core.i_hqm_system_write_buffer.ims_msix_w_ready;

   end
  end

  always_ff @(posedge hqm_system_core.hqm_inp_gated_clk) begin
   if (hqms_debug & (hqm_system_core.hqm_inp_gated_rst_b_sys === 1'b1)) begin

    if (hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push) 
     $display("%0tps: [HQMS_DEBUG] WBUF SCH FIFO PUSH: hcw(v=%x err-%x cq=%x ldb=%x beat=%x par=%x cq_addr=%x pf=%x vf=%x pasid=%x wbo=%x ecc=%x hcw=%x) int(v=%x ldb=%x cq=%x)"
        ,$time
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.hcw_v
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.error
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.cq
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.ldb
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.beat
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.parity
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.cq_addr
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.is_pf
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.vf
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.pasidtlp
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.wbo
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.ecc
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.hcw
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.int_v
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_push_data.int_d.cq_occ_cq
     );

    if (hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop) 
     $display("%0tps: [HQMS_DEBUG] WBUF SCH FIFO POP:  hcw(v=%x err=%x cq=%x ldb=%x beat=%x par=%x cq_addr=%x pf=%x vf=%x pasid=%x wbo=%x ecc=%x hcw=%x) int(v=%x ldb=%x cq=%x)"
        ,$time
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.hcw_v
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.error
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.cq
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.ldb
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.beat
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.parity
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.cq_addr
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.is_pf
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.vf
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.pasidtlp
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.wbo
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.ecc
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.hcw
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.int_v
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data.int_d.cq_occ_cq
     );

    if (hqm_system_core.i_hqm_system_write_buffer.sch_p0_v_q &
       ~hqm_system_core.i_hqm_system_write_buffer.sch_p0_hold) 
     $display("%0tps: [HQMS_DEBUG] WBUF SCH P0:        data_v=%x cq=%x sop=%x eop=%x beats=%x ldb=%x cq_addr=%x pf=%x vf=%x pasid=%x ro=%x ecc=%x hcw=%x) int(v=%x ldb=%x cq=%x) app=%1d ds1=%1d ds0=%1d"
        ,$time
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.data_v
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_cq_q
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.sop
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.eop
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.beats
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.ldb
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.cq_addr
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.is_pf
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.vf
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.pasidtlp
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.ro
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_data_q[143:128]
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_data_q[127:0]
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.int_v
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.int_d.cq_occ_cq
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.appended
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.dsel1
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p0_hdr_q.dsel0
     );

    if (hqm_system_core.i_hqm_system_write_buffer.sch_p1_v_q &
       ~hqm_system_core.i_hqm_system_write_buffer.sch_p1_hold) 
     $display("%0tps: [HQMS_DEBUG] WBUF SCH P1:        data_v=%x cq=%x sop=%x eop=%x beats=%x ldb=%x cq_addr=%x pf=%x vf=%x pasid=%x ro=%x ecc=%x hcw=%x) int(v=%x ldb=%x cq=%x) app=%1d ds1=%1d ds0=%1d"
        ,$time
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.data_v
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_cq_q
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.sop
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.eop
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.beats
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.ldb
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.cq_addr
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.is_pf
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.vf
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.pasidtlp
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.ro
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_data_q[143:128]
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_data_q[127:0]
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.int_v
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.int_d.cq_occ_cq
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.appended
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.dsel1
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p1_hdr_q.dsel0
     );

    if (hqm_system_core.i_hqm_system_write_buffer.sch_p2_v_q &
       ~hqm_system_core.i_hqm_system_write_buffer.sch_p2_hold) 
     $display("%0tps: [HQMS_DEBUG] WBUF SCH P2:        data_v=%x cq=%x sop=%x eop=%x beats=%x ldb=%x cq_addr=%x pf=%x vf=%x pasid=%x ro=%x ecc=%x hcw=%x) int(v=%x ldb=%x cq=%x) app=%1d ds1=%1d ds0=%1d"
        ,$time
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.data_v
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_cq_q
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.sop
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.eop
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.beats
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.ldb
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.cq_addr
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.is_pf
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.vf
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.pasidtlp
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.ro
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_data_q[143:128]
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_data_q[127:0]
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.int_v
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.int_d.is_ldb
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.int_d.cq_occ_cq
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.appended
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.dsel1
        ,hqm_system_core.i_hqm_system_write_buffer.sch_p2_hdr_q.dsel0
     );

    if (hqm_system_core.i_hqm_system_write_buffer.cq_occ_int_v) 
     $display("%0tps: [HQMS_DEBUG] WBUF  CQ OCC INT: ldb=%x cq=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_write_buffer.cq_occ_int.is_ldb
        ,hqm_system_core.i_hqm_system_write_buffer.cq_occ_int.cq_occ_cq
     );

    if (hqm_system_core.i_hqm_system_write_buffer.pwrite_v)
     $display("%0tps: [HQMS_DEBUG] WBUF PHDR:  cq(v=%x ldb=%x 0x%02x) addr=0x%08x_%08x len=0x%02x inv=%x pasid=0x%06x ro=%x tc_sel=%x src=%x(%s hcws=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.cq_v
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.cq_ldb
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.cq
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.add[63:32]
        ,{hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.add[31:2], 2'd0}
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.length
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.invalid
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.pasidtlp
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.ro
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.tc_sel
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.src
        ,((hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.src==SCH) ?"SCH)  ":
         ((hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.src==MSIX)?"MSI-X)":"AI)   "))
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.num_hcws
     );

    if (hqm_system_core.i_hqm_system_write_buffer.pwrite_v)
     $display("%0tps: [HQMS_DEBUG] WBUF PDATA: cq(v=%x ldb=%x 0x%02x) data_ls=0x%08x_%08x_%08x_%08x_%08x_%08x_%08x_%08x  p=0x%x src=%x(%s hcws=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.cq_v
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.cq_ldb
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.cq
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ls.data[255:224]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ls.data[223:192]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ls.data[191:160]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ls.data[159:128]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ls.data[127: 96]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ls.data[ 95: 64]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ls.data[ 63: 32]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ls.data[ 31:  0]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ls.dpar
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.src
        ,((hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.src==SCH) ?"SCH)  ":
         ((hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.src==MSIX)?"MSI-X)":"AI)   "))
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.num_hcws
     );

    if (hqm_system_core.i_hqm_system_write_buffer.pwrite_v & (hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.length>5'd8))
     $display("%0tps: [HQMS_DEBUG] WBUF PDATA: cq(v=%x ldb=%x 0x%02x) data_ms=0x%08x_%08x_%08x_%08x_%08x_%08x_%08x_%08x  p=0x%x src=%x(%s"
        ,$time
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.cq_v
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.cq_ldb
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.cq
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ms.data[255:224]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ms.data[223:192]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ms.data[191:160]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ms.data[159:128]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ms.data[127: 96]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ms.data[ 95: 64]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ms.data[ 63: 32]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ms.data[ 31:  0]
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.data_ms.dpar
        ,hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.src
        ,((hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.src==SCH) ?"SCH)  ":
         ((hqm_system_core.i_hqm_system_write_buffer.write_buffer_mstr.hdr.src==MSIX)?"MSI-X)":"AI)   "))
     );

   end // debug

  end // write_buffer.hqm_inp_gated_clk

  //--------------------------------------------------------------------------------------------------------

  always_ff @(posedge hqm_system_core.hqm_inp_gated_clk) begin
   if (hqms_debug & (hqm_system_core.hqm_inp_gated_rst_b_sys === 1'b1)) begin

    if (hqm_system_core.i_hqm_system_alarm.p0_v_q &
        hqm_system_core.i_hqm_system_alarm.p1_load)
     if (~hqm_system_core.i_hqm_system_alarm.p0_cfg_q)
      $display("%0tps: [HQMS_DEBUG] ALARM CQ_OCC P0:  ldb=%x cq=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.p0_data_q.is_ldb
        ,hqm_system_core.i_hqm_system_alarm.p0_data_q.cq_occ_cq
      );
     else
      if (~hqm_system_core.i_hqm_system_alarm.p0_cfg_we_q |
          &hqm_system_core.i_hqm_system_alarm.p2_cfg_we_q)
       $display("%0tps: [HQMS_DEBUG] ALARM CQ_OCC CFG P0:   re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.cfg_re_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_we_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_addr_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_wdata_q
       );

    if (hqm_system_core.i_hqm_system_alarm.p1_v_q &
        hqm_system_core.i_hqm_system_alarm.p2_load)
     if (hqm_system_core.i_hqm_system_alarm.p1_cfg_q)
      $display("%0tps: [HQMS_DEBUG] ALARM CQ_OCC CFG P1:   re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.cfg_re_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_we_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_addr_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] ALARM CQ_OCC P1:  ldb=%x cq=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.p1_data_q.is_ldb
        ,hqm_system_core.i_hqm_system_alarm.p1_data_q.cq_occ_cq
      );

    if (hqm_system_core.i_hqm_system_alarm.p2_v_q &
       ~hqm_system_core.i_hqm_system_alarm.p2_hold)
     if (hqm_system_core.i_hqm_system_alarm.p2_cfg_q)
      $display("%0tps: [HQMS_DEBUG] ALARM CQ_OCC CFG P2:   re=%x we=%x addr=%x wdata=%x"
       ,$time
        ,hqm_system_core.i_hqm_system_alarm.cfg_re_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_we_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_addr_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_wdata_q
       );
     else
      $display("%0tps: [HQMS_DEBUG] ALARM CQ_OCC P2:  ldb=%x cq=%x code=%x vf=%x vec=%x(%0d)"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.p2_data_q.is_ldb
        ,hqm_system_core.i_hqm_system_alarm.p2_data_q.cq_occ_cq
        ,hqm_system_core.i_hqm_system_alarm.p2_int_code
        ,hqm_system_core.i_hqm_system_alarm.p2_int_vf
        ,hqm_system_core.i_hqm_system_alarm.p2_int_vec
        ,hqm_system_core.i_hqm_system_alarm.p2_int_vec
      );

    if (hqm_system_core.i_hqm_system_alarm.msix_tbl_req)
     $display("%0tps: [HQMS_DEBUG] ALARM MSIX_TBL IN:  vec=%x(%0d)"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.msix_tbl_vec
        ,hqm_system_core.i_hqm_system_alarm.msix_tbl_vec
     );

    if (hqm_system_core.i_hqm_system_alarm.msix_p0_v_q &
        hqm_system_core.i_hqm_system_alarm.msix_p1_load)
     if (~hqm_system_core.i_hqm_system_alarm.msix_p0_cfg_q)
      $display("%0tps: [HQMS_DEBUG] ALARM MSIX_TBL P0:  vec=%x(%0d)"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.msix_p0_vec_q
        ,hqm_system_core.i_hqm_system_alarm.msix_p0_vec_q
      );
     else
      if (~hqm_system_core.i_hqm_system_alarm.msix_p0_cfg_we_q |
          &hqm_system_core.i_hqm_system_alarm.msix_p2_cfg_we_q)
       $display("%0tps: [HQMS_DEBUG] ALARM MSIX_TBL CFG P0: re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.cfg_re_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_we_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_addr_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_wdata_q
       );

    if (hqm_system_core.i_hqm_system_alarm.msix_p1_v_q &
        hqm_system_core.i_hqm_system_alarm.msix_p2_load)
     if (hqm_system_core.i_hqm_system_alarm.msix_p1_cfg_q)
      $display("%0tps: [HQMS_DEBUG] ALARM MSIX_TBL CFG P1: re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.cfg_re_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_we_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_addr_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] ALARM MSIX_TBL P1:  vec=%x(%0d)"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.msix_p1_vec_q
        ,hqm_system_core.i_hqm_system_alarm.msix_p1_vec_q
      );

    if (hqm_system_core.i_hqm_system_alarm.msix_p2_v_q &
       ~hqm_system_core.i_hqm_system_alarm.msix_p2_hold)
     if (hqm_system_core.i_hqm_system_alarm.msix_p2_cfg_q)
      $display("%0tps: [HQMS_DEBUG] ALARM MSIX_TBL CFG P2: re=%x we=%x addr=%x wdata=%x"
       ,$time
        ,hqm_system_core.i_hqm_system_alarm.cfg_re_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_we_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_addr_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_wdata_q
       );
     else
      $display("%0tps: [HQMS_DEBUG] ALARM MSIX_TBL P2:  vec=%x(%0d) addr=%x data=%x mask=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.msix_p2_vec_q
        ,hqm_system_core.i_hqm_system_alarm.msix_p2_vec_q
        ,hqm_system_core.i_hqm_system_alarm.msix_tbl_rdata_addr
        ,hqm_system_core.i_hqm_system_alarm.msix_tbl_rdata_data
        ,hqm_system_core.i_hqm_system_alarm.msix_tbl_rdata_mask
      );

    if (hqm_system_core.i_hqm_system_alarm.ai_tbl_req)
     $display("%0tps: [HQMS_DEBUG] ALARM AI_TBL IN:  vec=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.ai_tbl_vec
     );

    if (hqm_system_core.i_hqm_system_alarm.ai_p0_v_q &
        hqm_system_core.i_hqm_system_alarm.ai_p1_load)
     if (~hqm_system_core.i_hqm_system_alarm.ai_p0_cfg_q)
      $display("%0tps: [HQMS_DEBUG] ALARM AI_TBL P0:  vec=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.ai_p0_vec_q
      );
     else
      if (~hqm_system_core.i_hqm_system_alarm.ai_p0_cfg_we_q |
          &hqm_system_core.i_hqm_system_alarm.ai_p2_cfg_we_q)
       $display("%0tps: [HQMS_DEBUG] ALARM AI_TBL   CFG P0: re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.cfg_re_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_we_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_addr_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_wdata_q
       );

    if (hqm_system_core.i_hqm_system_alarm.ai_p1_v_q &
        hqm_system_core.i_hqm_system_alarm.ai_p2_load)
     if (hqm_system_core.i_hqm_system_alarm.ai_p1_cfg_q)
      $display("%0tps: [HQMS_DEBUG] ALARM AI_TBL   CFG P1: re=%x we=%x addr=%x wdata=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.cfg_re_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_we_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_addr_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_wdata_q
      );
     else
      $display("%0tps: [HQMS_DEBUG] ALARM AI_TBL P1:  vec=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.ai_p1_vec_q
      );

    if (hqm_system_core.i_hqm_system_alarm.ai_p2_v_q &
       ~hqm_system_core.i_hqm_system_alarm.ai_p2_hold)
     if (hqm_system_core.i_hqm_system_alarm.ai_p2_cfg_q)
      $display("%0tps: [HQMS_DEBUG] ALARM AI_TBL   CFG P2: re=%x we=%x addr=%x wdata=%x"
       ,$time
        ,hqm_system_core.i_hqm_system_alarm.cfg_re_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_we_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_addr_q
        ,hqm_system_core.i_hqm_system_alarm.cfg_wdata_q
       );
     else
      $display("%0tps: [HQMS_DEBUG] ALARM AI_TBL P2:  vec=%x addr=%x data=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.ai_p2_vec_q
        ,hqm_system_core.i_hqm_system_alarm.ai_p2_addr
        ,hqm_system_core.i_hqm_system_alarm.ai_p2_data
      );

    if (|{hqm_system_core.i_hqm_system_alarm.cfg_rvalid,
          hqm_system_core.i_hqm_system_alarm.cfg_wvalid})
     $display("%0tps: [HQMS_DEBUG] ALARM CFG ACK:         rv=%x wv=%x         rdata=%x err=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.cfg_rvalid
        ,hqm_system_core.i_hqm_system_alarm.cfg_wvalid
        ,hqm_system_core.i_hqm_system_alarm.cfg_rdata
        ,hqm_system_core.i_hqm_system_alarm.cfg_error
     );

    if (hqm_system_core.i_hqm_system_alarm.ims_msix_v &
        hqm_system_core.i_hqm_system_alarm.ims_msix_ready)
     if (hqm_system_core.i_hqm_system_alarm.func_arb_winner == 1)
      $display("%0tps: [HQMS_DEBUG] ALARM AI   Req: vec=%x tc_sel=%x poll=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.ai_p2_vec_q
        ,hqm_system_core.i_hqm_system_alarm.ims_msix.tc_sel
        ,hqm_system_core.i_hqm_system_alarm.ims_msix.poll
      );
     else 
      $display("%0tps: [HQMS_DEBUG] ALARM MSIX Req: vec=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.msix_p2_vec_q
      );

   end // debug

  end // alarm.hqm_inp_gated_clk

  //--------------------------------------------------------------------------------------------------------

  always_ff @(posedge hqm_system_core.i_hqm_system_alarm.prim_gated_clk) begin
   if (hqms_debug & (hqm_system_core.i_hqm_system_alarm.prim_gated_rst_n === 1'b1)) begin

    if (hqm_system_core.i_hqm_system_alarm.sif_alarm_fifo_push == 1'd1)
     $display ("%0tps: [HQMS_DEBUG] hqm_system received SIF alarm: unit=%x      cls=%x aid=%x msix_map=%x rtype=%x rid=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.sif_alarm_data_q.unit
        ,hqm_system_core.i_hqm_system_alarm.sif_alarm_data_q.cls
        ,hqm_system_core.i_hqm_system_alarm.sif_alarm_data_q.aid
        ,hqm_system_core.i_hqm_system_alarm.sif_alarm_data_q.msix_map
        ,hqm_system_core.i_hqm_system_alarm.sif_alarm_data_q.rtype
        ,hqm_system_core.i_hqm_system_alarm.sif_alarm_data_q.rid
     );

   end
  end

  always_ff @(posedge hqm_system_core.hqm_inp_gated_clk) begin
   if (hqms_debug & (hqm_system_core.hqm_inp_gated_rst_b_sys === 1'b1)) begin

    if (hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_ready == 1'd1)
     $display ("%0tps: [HQMS_DEBUG] hqm_system received HQM alarm: unit=%x(%s) cls=%x aid=%x msix_map=%x rtype=%x rid=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.unit
        ,((hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.unit == 4'h1) ? "SYS " :
         ((hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.unit == 4'h2) ? "AQED" :
         ((hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.unit == 4'h3) ? "AP  " :
         ((hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.unit == 4'h4) ? "CHP " :
         ((hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.unit == 4'h5) ? "DP  " :
         ((hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.unit == 4'h6) ? "QED " :
         ((hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.unit == 4'h7) ? "NALB" :
         ((hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.unit == 4'h8) ? "ROP " :
         ((hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.unit == 4'h9) ? "LSP " :
         ((hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.unit == 4'ha) ? "MSTR" : "XXXX"))))))))))
        ,hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.cls
        ,hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.aid
        ,hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.msix_map
        ,hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.rtype
        ,hqm_system_core.i_hqm_system_alarm.hqm_alarm_db_data.rid
     );

    if (hqm_system_core.i_hqm_system_alarm.sys_alarm_db_ready == 1'd1)
     $display ("%0tps: [HQMS_DEBUG] hqm_system received SYS alarm: unit=1       cls=%x aid=%x msix_map=%x rtype=%x rid=%x"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.sys_alarm_db_data.cls
        ,hqm_system_core.i_hqm_system_alarm.sys_alarm_db_data.aid
        ,hqm_system_core.i_hqm_system_alarm.sys_alarm_db_data.msix_map
        ,hqm_system_core.i_hqm_system_alarm.sys_alarm_db_data.rtype
        ,hqm_system_core.i_hqm_system_alarm.sys_alarm_db_data.rid
     );

    if (hqm_system_core.i_hqm_system_alarm.ingress_alarm_v == 1'd1)
     $display ("%0tps: [HQMS_DEBUG] hqm_system received ING alarm: pf=%x vdev=%x vpp=%x cmd=%x db=%x ldt=%x mt=%x qp=%x qt=%x qid=%x dsi=%x aid=%x(%s"
        ,$time
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.is_pf
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.vdev
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.vpp
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.hcw.cmd
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.hcw.debug
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.hcw.lockid_dir_info_tokens
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.hcw.msg_info.msgtype
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.hcw.msg_info.qpri
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.hcw.msg_info.qtype
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.hcw.msg_info.qid
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.hcw.dsi
        ,hqm_system_core.i_hqm_system_alarm.ingress_alarm.aid
        ,((hqm_system_core.i_hqm_system_alarm.ingress_alarm.aid == 6'd0)  ? "illegal_hcw)        " :
         ((hqm_system_core.i_hqm_system_alarm.ingress_alarm.aid == 6'd1)  ? "illegal_pp)         " :
         ((hqm_system_core.i_hqm_system_alarm.ingress_alarm.aid == 6'd2)  ? "illegal_pasid)      " :
         ((hqm_system_core.i_hqm_system_alarm.ingress_alarm.aid == 6'd3)  ? "illegal_qid)        " :
         ((hqm_system_core.i_hqm_system_alarm.ingress_alarm.aid == 6'd4)  ? "disabled_qid)       " :
         ((hqm_system_core.i_hqm_system_alarm.ingress_alarm.aid == 6'd5)  ? "illegal_ldb_qid_cfg)" :
         ((hqm_system_core.i_hqm_system_alarm.ingress_alarm.aid == 6'd43) ? "parity_err)         " :
         ((hqm_system_core.i_hqm_system_alarm.ingress_alarm.aid == 6'd44) ? "mb_ecc_err)         " :
                                                                            "XXX)                "))))))))
     );

   end // debug

  end // alarm.hqm_inp_gated_clk

 //---------------------------------------------------------------------------------------------------------

 always_ff @(posedge hqm_system_core.hqm_inp_gated_clk) begin
  if (hqms_debug & (hqm_system_core.hqm_inp_gated_rst_b_sys === 1'b1)) begin
   if ($rose(hqm_system_core.cfg_write_bad_parity)) $display("%t: [HQMS_DEBUG]: Write bad parity was asserted.", $time);
   if ($fell(hqm_system_core.cfg_write_bad_parity)) $display("%t: [HQMS_DEBUG]: Write bad parity was deasserted.", $time);
   if ($rose(hqm_system_core.cfg_parity_ctl.INGRESS_PAR_OFF)) $display("%t: [HQMS_DEBUG]: Ingress parity checking was turned off.", $time);
   if ($fell(hqm_system_core.cfg_parity_ctl.INGRESS_PAR_OFF)) $display("%t: [HQMS_DEBUG]: Ingress parity checking was turned on.", $time);
   if ($rose(hqm_system_core.cfg_parity_ctl.EGRESS_PAR_OFF)) $display("%t: [HQMS_DEBUG]: Egress parity checking was turned off.", $time);
   if ($fell(hqm_system_core.cfg_parity_ctl.EGRESS_PAR_OFF)) $display("%t: [HQMS_DEBUG]: Egress parity checking was turned on.", $time);
   if ($rose(hqm_system_core.cfg_parity_ctl.ALARM_PAR_OFF)) $display("%t: [HQMS_DEBUG]: Alarm parity checking was turned off.", $time);
   if ($fell(hqm_system_core.cfg_parity_ctl.ALARM_PAR_OFF)) $display("%t: [HQMS_DEBUG]: Alarm parity checking was turned on.", $time);
  end // debug
 end
   
 //---------------------------------------------------------------------------------------------------------

 always_ff @(posedge hqm_system_core.hqm_inp_gated_clk) begin: error_p
  if (hqms_debug) begin

   if ($fell(hqm_system_core.hqm_inp_gated_rst_b_sys))                   $display("%t: [HQMS_DEBUG]: RESET: hqm_inp_gated_rst_b        asserted.", $time);
   if ($rose(hqm_system_core.hqm_inp_gated_rst_b_sys))                   $display("%t: [HQMS_DEBUG]: RESET: hqm_inp_gated_rst_b      deasserted.", $time);
   if ($fell(hqm_system_core.hqm_gated_rst_b_sys))                       $display("%t: [HQMS_DEBUG]: RESET: hqm_gated_rst_b            asserted.", $time);
   if ($rose(hqm_system_core.hqm_gated_rst_b_sys))                       $display("%t: [HQMS_DEBUG]: RESET: hqm_gated_rst_b          deasserted.", $time);
   if ($rose(hqm_system_core.hqm_proc_clk_en_sys))                       $display("%t: [HQMS_DEBUG]: RESET: hqm_proc_clk_en_sys        asserted.", $time);
   if ($fell(hqm_system_core.hqm_proc_clk_en_sys))                       $display("%t: [HQMS_DEBUG]: RESET: hqm_proc_clk_en_sys      deasserted.", $time);
   if ($rose(hqm_system_core.hqm_rst_prep_sys))                          $display("%t: [HQMS_DEBUG]: RESET: hqm_rst_prep_sys           asserted.", $time);
   if ($fell(hqm_system_core.hqm_rst_prep_sys))                          $display("%t: [HQMS_DEBUG]: RESET: hqm_rst_prep_sys         deasserted.", $time);
   if ($rose(hqm_system_core.system_reset_done))                         $display("%t: [HQMS_DEBUG]: RESET: system_reset_done          asserted.", $time);
   if ($fell(hqm_system_core.system_reset_done))                         $display("%t: [HQMS_DEBUG]: RESET: system_reset_done        deasserted.", $time);
   if ($rose(hqm_system_core.system_idle))                               $display("%t: [HQMS_DEBUG]: RESET: system_idle                asserted.", $time);
   if ($fell(hqm_system_core.system_idle))                               $display("%t: [HQMS_DEBUG]: RESET: system_idle              deasserted.", $time);
  end
 end

 //---------------------------------------------------------------------------------------------------------

 task eot_check (output bit pf);

  pf = 1'b0 ; //pass

  if (hqm_system_core.i_hqm_system_ingress.p0_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Ingress hcw_enq p0 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_ingress.p1_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Ingress hcw_enq p1 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_ingress.p2_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Ingress hcw_enq p2 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_ingress.p3_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Ingress hcw_enq p3 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_ingress.p4_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Ingress hcw_enq p4 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_ingress.p5_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Ingress hcw_enq p5 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_ingress.p6_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Ingress hcw_enq p6 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_ingress.p7_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Ingress hcw_enq p7 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_ingress.p8_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Ingress hcw_enq p8 still valid!!!", $time);
    pf = 1'b1;
  end

  if (hqm_system_core.i_hqm_system_ingress.hcw_enq_fifo_pop_data_v) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Ingress hcw_enq FIFO is not empty!!!", $time);
    pf = 1'b1;
  end

  if (hqm_system_core.i_hqm_system_egress.p0_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Egress hcw_sch p0 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_egress.p1_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Egress hcw_sch p1 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_egress.p2_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Egress hcw_sch p2 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_egress.p3_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Egress hcw_sch p3 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_egress.p4_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Egress hcw_sch p4 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_egress.p5_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Egress hcw_sch p5 still valid!!!", $time);
    pf = 1'b1;
  end

  if (hqm_system_core.i_hqm_system_write_buffer.sch_out_fifo_pop_data_v) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Write buffer hcw_sch FIFO is not empty!!!", $time);
    pf = 1'b1;
  end

  if (hqm_system_core.i_hqm_system_write_buffer.sch_p0_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Write buffer hcw_sch p0 still valid!!!", $time);
    pf = 1'b1;
  end

  if (hqm_system_core.i_hqm_system_alarm.p0_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Alarm cq_occ_isr p0 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_alarm.p1_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Alarm cq_occ_isr p1 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_alarm.p2_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Alarm cq_occ_isr p2 still valid!!!", $time);
    pf = 1'b1;
  end

  if (hqm_system_core.i_hqm_system_alarm.msix_p0_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Alarm msix_tbl p0 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_alarm.msix_p1_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Alarm msix_tbl p1 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_alarm.msix_p2_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Alarm msix_tbl p2 still valid!!!", $time);
    pf = 1'b1;
  end

  if (hqm_system_core.i_hqm_system_alarm.ai_p0_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Alarm ai_tbl p0 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_alarm.ai_p1_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Alarm ai_tbl p1 still valid!!!", $time);
    pf = 1'b1;
  end
  if (hqm_system_core.i_hqm_system_alarm.ai_p2_v_q) begin
    $display ("%0tps: [HQMS_EOT]: ERROR: Alarm ai_tbl p2 still valid!!!", $time);
    pf = 1'b1;
  end

 endtask : eot_check

 //---------------------------------------------------------------------------------------------------------

endmodule

bind hqm_system_core hqm_system_inst i_hqm_system_inst();

`endif

