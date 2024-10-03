module hqm_system_ram_access
     import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::*;
(
     input  logic                  hqm_gated_clk
    ,input  logic                  prim_gated_clk

    ,input  logic                  hqm_gated_rst_n
    ,input  logic                  prim_gated_rst_n

    ,output logic                  hqm_system_rfw_top_ipar_error

    ,input  logic                  func_alarm_vf_synd0_re
    ,input  logic [(       4)-1:0] func_alarm_vf_synd0_raddr
    ,input  logic [(       4)-1:0] func_alarm_vf_synd0_waddr
    ,input  logic                  func_alarm_vf_synd0_we
    ,input  logic [(      30)-1:0] func_alarm_vf_synd0_wdata
    ,output logic [(      30)-1:0] func_alarm_vf_synd0_rdata

    ,output logic                  rf_alarm_vf_synd0_re
    ,output logic                  rf_alarm_vf_synd0_rclk
    ,output logic                  rf_alarm_vf_synd0_rclk_rst_n
    ,output logic [(       4)-1:0] rf_alarm_vf_synd0_raddr
    ,output logic [(       4)-1:0] rf_alarm_vf_synd0_waddr
    ,output logic                  rf_alarm_vf_synd0_we
    ,output logic                  rf_alarm_vf_synd0_wclk
    ,output logic                  rf_alarm_vf_synd0_wclk_rst_n
    ,output logic [(      30)-1:0] rf_alarm_vf_synd0_wdata
    ,input  logic [(      30)-1:0] rf_alarm_vf_synd0_rdata

    ,input  logic                  func_alarm_vf_synd1_re
    ,input  logic [(       4)-1:0] func_alarm_vf_synd1_raddr
    ,input  logic [(       4)-1:0] func_alarm_vf_synd1_waddr
    ,input  logic                  func_alarm_vf_synd1_we
    ,input  logic [(      32)-1:0] func_alarm_vf_synd1_wdata
    ,output logic [(      32)-1:0] func_alarm_vf_synd1_rdata

    ,output logic                  rf_alarm_vf_synd1_re
    ,output logic                  rf_alarm_vf_synd1_rclk
    ,output logic                  rf_alarm_vf_synd1_rclk_rst_n
    ,output logic [(       4)-1:0] rf_alarm_vf_synd1_raddr
    ,output logic [(       4)-1:0] rf_alarm_vf_synd1_waddr
    ,output logic                  rf_alarm_vf_synd1_we
    ,output logic                  rf_alarm_vf_synd1_wclk
    ,output logic                  rf_alarm_vf_synd1_wclk_rst_n
    ,output logic [(      32)-1:0] rf_alarm_vf_synd1_wdata
    ,input  logic [(      32)-1:0] rf_alarm_vf_synd1_rdata

    ,input  logic                  func_alarm_vf_synd2_re
    ,input  logic [(       4)-1:0] func_alarm_vf_synd2_raddr
    ,input  logic [(       4)-1:0] func_alarm_vf_synd2_waddr
    ,input  logic                  func_alarm_vf_synd2_we
    ,input  logic [(      32)-1:0] func_alarm_vf_synd2_wdata
    ,output logic [(      32)-1:0] func_alarm_vf_synd2_rdata

    ,output logic                  rf_alarm_vf_synd2_re
    ,output logic                  rf_alarm_vf_synd2_rclk
    ,output logic                  rf_alarm_vf_synd2_rclk_rst_n
    ,output logic [(       4)-1:0] rf_alarm_vf_synd2_raddr
    ,output logic [(       4)-1:0] rf_alarm_vf_synd2_waddr
    ,output logic                  rf_alarm_vf_synd2_we
    ,output logic                  rf_alarm_vf_synd2_wclk
    ,output logic                  rf_alarm_vf_synd2_wclk_rst_n
    ,output logic [(      32)-1:0] rf_alarm_vf_synd2_wdata
    ,input  logic [(      32)-1:0] rf_alarm_vf_synd2_rdata

    ,input  logic                  func_dir_wb0_re
    ,input  logic [(       6)-1:0] func_dir_wb0_raddr
    ,input  logic [(       6)-1:0] func_dir_wb0_waddr
    ,input  logic                  func_dir_wb0_we
    ,input  logic [(     144)-1:0] func_dir_wb0_wdata
    ,output logic [(     144)-1:0] func_dir_wb0_rdata

    ,output logic                  rf_dir_wb0_re
    ,output logic                  rf_dir_wb0_rclk
    ,output logic                  rf_dir_wb0_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_wb0_raddr
    ,output logic [(       6)-1:0] rf_dir_wb0_waddr
    ,output logic                  rf_dir_wb0_we
    ,output logic                  rf_dir_wb0_wclk
    ,output logic                  rf_dir_wb0_wclk_rst_n
    ,output logic [(     144)-1:0] rf_dir_wb0_wdata
    ,input  logic [(     144)-1:0] rf_dir_wb0_rdata

    ,input  logic                  func_dir_wb1_re
    ,input  logic [(       6)-1:0] func_dir_wb1_raddr
    ,input  logic [(       6)-1:0] func_dir_wb1_waddr
    ,input  logic                  func_dir_wb1_we
    ,input  logic [(     144)-1:0] func_dir_wb1_wdata
    ,output logic [(     144)-1:0] func_dir_wb1_rdata

    ,output logic                  rf_dir_wb1_re
    ,output logic                  rf_dir_wb1_rclk
    ,output logic                  rf_dir_wb1_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_wb1_raddr
    ,output logic [(       6)-1:0] rf_dir_wb1_waddr
    ,output logic                  rf_dir_wb1_we
    ,output logic                  rf_dir_wb1_wclk
    ,output logic                  rf_dir_wb1_wclk_rst_n
    ,output logic [(     144)-1:0] rf_dir_wb1_wdata
    ,input  logic [(     144)-1:0] rf_dir_wb1_rdata

    ,input  logic                  func_dir_wb2_re
    ,input  logic [(       6)-1:0] func_dir_wb2_raddr
    ,input  logic [(       6)-1:0] func_dir_wb2_waddr
    ,input  logic                  func_dir_wb2_we
    ,input  logic [(     144)-1:0] func_dir_wb2_wdata
    ,output logic [(     144)-1:0] func_dir_wb2_rdata

    ,output logic                  rf_dir_wb2_re
    ,output logic                  rf_dir_wb2_rclk
    ,output logic                  rf_dir_wb2_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_wb2_raddr
    ,output logic [(       6)-1:0] rf_dir_wb2_waddr
    ,output logic                  rf_dir_wb2_we
    ,output logic                  rf_dir_wb2_wclk
    ,output logic                  rf_dir_wb2_wclk_rst_n
    ,output logic [(     144)-1:0] rf_dir_wb2_wdata
    ,input  logic [(     144)-1:0] rf_dir_wb2_rdata

    ,input  logic                  func_hcw_enq_fifo_re
    ,input  logic [(       8)-1:0] func_hcw_enq_fifo_raddr
    ,input  logic [(       8)-1:0] func_hcw_enq_fifo_waddr
    ,input  logic                  func_hcw_enq_fifo_we
    ,input  logic [(     161)-1:0] func_hcw_enq_fifo_wdata
    ,output logic [(     161)-1:0] func_hcw_enq_fifo_rdata

    ,output logic                  rf_hcw_enq_fifo_re
    ,output logic                  rf_hcw_enq_fifo_rclk
    ,output logic                  rf_hcw_enq_fifo_rclk_rst_n
    ,output logic [(       8)-1:0] rf_hcw_enq_fifo_raddr
    ,output logic [(       8)-1:0] rf_hcw_enq_fifo_waddr
    ,output logic                  rf_hcw_enq_fifo_we
    ,output logic                  rf_hcw_enq_fifo_wclk
    ,output logic                  rf_hcw_enq_fifo_wclk_rst_n
    ,output logic [(     167)-1:0] rf_hcw_enq_fifo_wdata
    ,input  logic [(     167)-1:0] rf_hcw_enq_fifo_rdata

    ,input  logic                  func_ldb_wb0_re
    ,input  logic [(       6)-1:0] func_ldb_wb0_raddr
    ,input  logic [(       6)-1:0] func_ldb_wb0_waddr
    ,input  logic                  func_ldb_wb0_we
    ,input  logic [(     144)-1:0] func_ldb_wb0_wdata
    ,output logic [(     144)-1:0] func_ldb_wb0_rdata

    ,output logic                  rf_ldb_wb0_re
    ,output logic                  rf_ldb_wb0_rclk
    ,output logic                  rf_ldb_wb0_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_wb0_raddr
    ,output logic [(       6)-1:0] rf_ldb_wb0_waddr
    ,output logic                  rf_ldb_wb0_we
    ,output logic                  rf_ldb_wb0_wclk
    ,output logic                  rf_ldb_wb0_wclk_rst_n
    ,output logic [(     144)-1:0] rf_ldb_wb0_wdata
    ,input  logic [(     144)-1:0] rf_ldb_wb0_rdata

    ,input  logic                  func_ldb_wb1_re
    ,input  logic [(       6)-1:0] func_ldb_wb1_raddr
    ,input  logic [(       6)-1:0] func_ldb_wb1_waddr
    ,input  logic                  func_ldb_wb1_we
    ,input  logic [(     144)-1:0] func_ldb_wb1_wdata
    ,output logic [(     144)-1:0] func_ldb_wb1_rdata

    ,output logic                  rf_ldb_wb1_re
    ,output logic                  rf_ldb_wb1_rclk
    ,output logic                  rf_ldb_wb1_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_wb1_raddr
    ,output logic [(       6)-1:0] rf_ldb_wb1_waddr
    ,output logic                  rf_ldb_wb1_we
    ,output logic                  rf_ldb_wb1_wclk
    ,output logic                  rf_ldb_wb1_wclk_rst_n
    ,output logic [(     144)-1:0] rf_ldb_wb1_wdata
    ,input  logic [(     144)-1:0] rf_ldb_wb1_rdata

    ,input  logic                  func_ldb_wb2_re
    ,input  logic [(       6)-1:0] func_ldb_wb2_raddr
    ,input  logic [(       6)-1:0] func_ldb_wb2_waddr
    ,input  logic                  func_ldb_wb2_we
    ,input  logic [(     144)-1:0] func_ldb_wb2_wdata
    ,output logic [(     144)-1:0] func_ldb_wb2_rdata

    ,output logic                  rf_ldb_wb2_re
    ,output logic                  rf_ldb_wb2_rclk
    ,output logic                  rf_ldb_wb2_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_wb2_raddr
    ,output logic [(       6)-1:0] rf_ldb_wb2_waddr
    ,output logic                  rf_ldb_wb2_we
    ,output logic                  rf_ldb_wb2_wclk
    ,output logic                  rf_ldb_wb2_wclk_rst_n
    ,output logic [(     144)-1:0] rf_ldb_wb2_wdata
    ,input  logic [(     144)-1:0] rf_ldb_wb2_rdata

    ,input  logic                  func_lut_dir_cq2vf_pf_ro_re
    ,input  logic [(       5)-1:0] func_lut_dir_cq2vf_pf_ro_raddr
    ,input  logic [(       5)-1:0] func_lut_dir_cq2vf_pf_ro_waddr
    ,input  logic                  func_lut_dir_cq2vf_pf_ro_we
    ,input  logic [(      13)-1:0] func_lut_dir_cq2vf_pf_ro_wdata
    ,output logic [(      13)-1:0] func_lut_dir_cq2vf_pf_ro_rdata

    ,output logic                  rf_lut_dir_cq2vf_pf_ro_re
    ,output logic                  rf_lut_dir_cq2vf_pf_ro_rclk
    ,output logic                  rf_lut_dir_cq2vf_pf_ro_rclk_rst_n
    ,output logic [(       5)-1:0] rf_lut_dir_cq2vf_pf_ro_raddr
    ,output logic [(       5)-1:0] rf_lut_dir_cq2vf_pf_ro_waddr
    ,output logic                  rf_lut_dir_cq2vf_pf_ro_we
    ,output logic                  rf_lut_dir_cq2vf_pf_ro_wclk
    ,output logic                  rf_lut_dir_cq2vf_pf_ro_wclk_rst_n
    ,output logic [(      13)-1:0] rf_lut_dir_cq2vf_pf_ro_wdata
    ,input  logic [(      13)-1:0] rf_lut_dir_cq2vf_pf_ro_rdata

    ,input  logic                  func_lut_dir_cq_addr_l_re
    ,input  logic [(       6)-1:0] func_lut_dir_cq_addr_l_raddr
    ,input  logic [(       6)-1:0] func_lut_dir_cq_addr_l_waddr
    ,input  logic                  func_lut_dir_cq_addr_l_we
    ,input  logic [(      27)-1:0] func_lut_dir_cq_addr_l_wdata
    ,output logic [(      27)-1:0] func_lut_dir_cq_addr_l_rdata

    ,output logic                  rf_lut_dir_cq_addr_l_re
    ,output logic                  rf_lut_dir_cq_addr_l_rclk
    ,output logic                  rf_lut_dir_cq_addr_l_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_addr_l_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_addr_l_waddr
    ,output logic                  rf_lut_dir_cq_addr_l_we
    ,output logic                  rf_lut_dir_cq_addr_l_wclk
    ,output logic                  rf_lut_dir_cq_addr_l_wclk_rst_n
    ,output logic [(      27)-1:0] rf_lut_dir_cq_addr_l_wdata
    ,input  logic [(      27)-1:0] rf_lut_dir_cq_addr_l_rdata

    ,input  logic                  func_lut_dir_cq_addr_u_re
    ,input  logic [(       6)-1:0] func_lut_dir_cq_addr_u_raddr
    ,input  logic [(       6)-1:0] func_lut_dir_cq_addr_u_waddr
    ,input  logic                  func_lut_dir_cq_addr_u_we
    ,input  logic [(      33)-1:0] func_lut_dir_cq_addr_u_wdata
    ,output logic [(      33)-1:0] func_lut_dir_cq_addr_u_rdata

    ,output logic                  rf_lut_dir_cq_addr_u_re
    ,output logic                  rf_lut_dir_cq_addr_u_rclk
    ,output logic                  rf_lut_dir_cq_addr_u_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_addr_u_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_addr_u_waddr
    ,output logic                  rf_lut_dir_cq_addr_u_we
    ,output logic                  rf_lut_dir_cq_addr_u_wclk
    ,output logic                  rf_lut_dir_cq_addr_u_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_dir_cq_addr_u_wdata
    ,input  logic [(      33)-1:0] rf_lut_dir_cq_addr_u_rdata

    ,input  logic                  func_lut_dir_cq_ai_addr_l_re
    ,input  logic [(       6)-1:0] func_lut_dir_cq_ai_addr_l_raddr
    ,input  logic [(       6)-1:0] func_lut_dir_cq_ai_addr_l_waddr
    ,input  logic                  func_lut_dir_cq_ai_addr_l_we
    ,input  logic [(      31)-1:0] func_lut_dir_cq_ai_addr_l_wdata
    ,output logic [(      31)-1:0] func_lut_dir_cq_ai_addr_l_rdata

    ,output logic                  rf_lut_dir_cq_ai_addr_l_re
    ,output logic                  rf_lut_dir_cq_ai_addr_l_rclk
    ,output logic                  rf_lut_dir_cq_ai_addr_l_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_addr_l_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_addr_l_waddr
    ,output logic                  rf_lut_dir_cq_ai_addr_l_we
    ,output logic                  rf_lut_dir_cq_ai_addr_l_wclk
    ,output logic                  rf_lut_dir_cq_ai_addr_l_wclk_rst_n
    ,output logic [(      31)-1:0] rf_lut_dir_cq_ai_addr_l_wdata
    ,input  logic [(      31)-1:0] rf_lut_dir_cq_ai_addr_l_rdata

    ,input  logic                  func_lut_dir_cq_ai_addr_u_re
    ,input  logic [(       6)-1:0] func_lut_dir_cq_ai_addr_u_raddr
    ,input  logic [(       6)-1:0] func_lut_dir_cq_ai_addr_u_waddr
    ,input  logic                  func_lut_dir_cq_ai_addr_u_we
    ,input  logic [(      33)-1:0] func_lut_dir_cq_ai_addr_u_wdata
    ,output logic [(      33)-1:0] func_lut_dir_cq_ai_addr_u_rdata

    ,output logic                  rf_lut_dir_cq_ai_addr_u_re
    ,output logic                  rf_lut_dir_cq_ai_addr_u_rclk
    ,output logic                  rf_lut_dir_cq_ai_addr_u_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_addr_u_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_addr_u_waddr
    ,output logic                  rf_lut_dir_cq_ai_addr_u_we
    ,output logic                  rf_lut_dir_cq_ai_addr_u_wclk
    ,output logic                  rf_lut_dir_cq_ai_addr_u_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_dir_cq_ai_addr_u_wdata
    ,input  logic [(      33)-1:0] rf_lut_dir_cq_ai_addr_u_rdata

    ,input  logic                  func_lut_dir_cq_ai_data_re
    ,input  logic [(       6)-1:0] func_lut_dir_cq_ai_data_raddr
    ,input  logic [(       6)-1:0] func_lut_dir_cq_ai_data_waddr
    ,input  logic                  func_lut_dir_cq_ai_data_we
    ,input  logic [(      33)-1:0] func_lut_dir_cq_ai_data_wdata
    ,output logic [(      33)-1:0] func_lut_dir_cq_ai_data_rdata

    ,output logic                  rf_lut_dir_cq_ai_data_re
    ,output logic                  rf_lut_dir_cq_ai_data_rclk
    ,output logic                  rf_lut_dir_cq_ai_data_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_data_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_ai_data_waddr
    ,output logic                  rf_lut_dir_cq_ai_data_we
    ,output logic                  rf_lut_dir_cq_ai_data_wclk
    ,output logic                  rf_lut_dir_cq_ai_data_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_dir_cq_ai_data_wdata
    ,input  logic [(      33)-1:0] rf_lut_dir_cq_ai_data_rdata

    ,input  logic                  func_lut_dir_cq_isr_re
    ,input  logic [(       6)-1:0] func_lut_dir_cq_isr_raddr
    ,input  logic [(       6)-1:0] func_lut_dir_cq_isr_waddr
    ,input  logic                  func_lut_dir_cq_isr_we
    ,input  logic [(      13)-1:0] func_lut_dir_cq_isr_wdata
    ,output logic [(      13)-1:0] func_lut_dir_cq_isr_rdata

    ,output logic                  rf_lut_dir_cq_isr_re
    ,output logic                  rf_lut_dir_cq_isr_rclk
    ,output logic                  rf_lut_dir_cq_isr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_isr_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_isr_waddr
    ,output logic                  rf_lut_dir_cq_isr_we
    ,output logic                  rf_lut_dir_cq_isr_wclk
    ,output logic                  rf_lut_dir_cq_isr_wclk_rst_n
    ,output logic [(      13)-1:0] rf_lut_dir_cq_isr_wdata
    ,input  logic [(      13)-1:0] rf_lut_dir_cq_isr_rdata

    ,input  logic                  func_lut_dir_cq_pasid_re
    ,input  logic [(       6)-1:0] func_lut_dir_cq_pasid_raddr
    ,input  logic [(       6)-1:0] func_lut_dir_cq_pasid_waddr
    ,input  logic                  func_lut_dir_cq_pasid_we
    ,input  logic [(      24)-1:0] func_lut_dir_cq_pasid_wdata
    ,output logic [(      24)-1:0] func_lut_dir_cq_pasid_rdata

    ,output logic                  rf_lut_dir_cq_pasid_re
    ,output logic                  rf_lut_dir_cq_pasid_rclk
    ,output logic                  rf_lut_dir_cq_pasid_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_cq_pasid_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_cq_pasid_waddr
    ,output logic                  rf_lut_dir_cq_pasid_we
    ,output logic                  rf_lut_dir_cq_pasid_wclk
    ,output logic                  rf_lut_dir_cq_pasid_wclk_rst_n
    ,output logic [(      24)-1:0] rf_lut_dir_cq_pasid_wdata
    ,input  logic [(      24)-1:0] rf_lut_dir_cq_pasid_rdata

    ,input  logic                  func_lut_dir_pp2vas_re
    ,input  logic [(       5)-1:0] func_lut_dir_pp2vas_raddr
    ,input  logic [(       5)-1:0] func_lut_dir_pp2vas_waddr
    ,input  logic                  func_lut_dir_pp2vas_we
    ,input  logic [(      11)-1:0] func_lut_dir_pp2vas_wdata
    ,output logic [(      11)-1:0] func_lut_dir_pp2vas_rdata

    ,output logic                  rf_lut_dir_pp2vas_re
    ,output logic                  rf_lut_dir_pp2vas_rclk
    ,output logic                  rf_lut_dir_pp2vas_rclk_rst_n
    ,output logic [(       5)-1:0] rf_lut_dir_pp2vas_raddr
    ,output logic [(       5)-1:0] rf_lut_dir_pp2vas_waddr
    ,output logic                  rf_lut_dir_pp2vas_we
    ,output logic                  rf_lut_dir_pp2vas_wclk
    ,output logic                  rf_lut_dir_pp2vas_wclk_rst_n
    ,output logic [(      11)-1:0] rf_lut_dir_pp2vas_wdata
    ,input  logic [(      11)-1:0] rf_lut_dir_pp2vas_rdata

    ,input  logic                  func_lut_dir_pp_v_re
    ,input  logic [(       2)-1:0] func_lut_dir_pp_v_raddr
    ,input  logic [(       2)-1:0] func_lut_dir_pp_v_waddr
    ,input  logic                  func_lut_dir_pp_v_we
    ,input  logic [(      17)-1:0] func_lut_dir_pp_v_wdata
    ,output logic [(      17)-1:0] func_lut_dir_pp_v_rdata

    ,output logic                  rf_lut_dir_pp_v_re
    ,output logic                  rf_lut_dir_pp_v_rclk
    ,output logic                  rf_lut_dir_pp_v_rclk_rst_n
    ,output logic [(       2)-1:0] rf_lut_dir_pp_v_raddr
    ,output logic [(       2)-1:0] rf_lut_dir_pp_v_waddr
    ,output logic                  rf_lut_dir_pp_v_we
    ,output logic                  rf_lut_dir_pp_v_wclk
    ,output logic                  rf_lut_dir_pp_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_dir_pp_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_dir_pp_v_rdata

    ,input  logic                  func_lut_dir_vasqid_v_re
    ,input  logic [(       6)-1:0] func_lut_dir_vasqid_v_raddr
    ,input  logic [(       6)-1:0] func_lut_dir_vasqid_v_waddr
    ,input  logic                  func_lut_dir_vasqid_v_we
    ,input  logic [(      33)-1:0] func_lut_dir_vasqid_v_wdata
    ,output logic [(      33)-1:0] func_lut_dir_vasqid_v_rdata

    ,output logic                  rf_lut_dir_vasqid_v_re
    ,output logic                  rf_lut_dir_vasqid_v_rclk
    ,output logic                  rf_lut_dir_vasqid_v_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_dir_vasqid_v_raddr
    ,output logic [(       6)-1:0] rf_lut_dir_vasqid_v_waddr
    ,output logic                  rf_lut_dir_vasqid_v_we
    ,output logic                  rf_lut_dir_vasqid_v_wclk
    ,output logic                  rf_lut_dir_vasqid_v_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_dir_vasqid_v_wdata
    ,input  logic [(      33)-1:0] rf_lut_dir_vasqid_v_rdata

    ,input  logic                  func_lut_ldb_cq2vf_pf_ro_re
    ,input  logic [(       5)-1:0] func_lut_ldb_cq2vf_pf_ro_raddr
    ,input  logic [(       5)-1:0] func_lut_ldb_cq2vf_pf_ro_waddr
    ,input  logic                  func_lut_ldb_cq2vf_pf_ro_we
    ,input  logic [(      13)-1:0] func_lut_ldb_cq2vf_pf_ro_wdata
    ,output logic [(      13)-1:0] func_lut_ldb_cq2vf_pf_ro_rdata

    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_re
    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_rclk
    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n
    ,output logic [(       5)-1:0] rf_lut_ldb_cq2vf_pf_ro_raddr
    ,output logic [(       5)-1:0] rf_lut_ldb_cq2vf_pf_ro_waddr
    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_we
    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_wclk
    ,output logic                  rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n
    ,output logic [(      13)-1:0] rf_lut_ldb_cq2vf_pf_ro_wdata
    ,input  logic [(      13)-1:0] rf_lut_ldb_cq2vf_pf_ro_rdata

    ,input  logic                  func_lut_ldb_cq_addr_l_re
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_addr_l_raddr
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_addr_l_waddr
    ,input  logic                  func_lut_ldb_cq_addr_l_we
    ,input  logic [(      27)-1:0] func_lut_ldb_cq_addr_l_wdata
    ,output logic [(      27)-1:0] func_lut_ldb_cq_addr_l_rdata

    ,output logic                  rf_lut_ldb_cq_addr_l_re
    ,output logic                  rf_lut_ldb_cq_addr_l_rclk
    ,output logic                  rf_lut_ldb_cq_addr_l_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_addr_l_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_addr_l_waddr
    ,output logic                  rf_lut_ldb_cq_addr_l_we
    ,output logic                  rf_lut_ldb_cq_addr_l_wclk
    ,output logic                  rf_lut_ldb_cq_addr_l_wclk_rst_n
    ,output logic [(      27)-1:0] rf_lut_ldb_cq_addr_l_wdata
    ,input  logic [(      27)-1:0] rf_lut_ldb_cq_addr_l_rdata

    ,input  logic                  func_lut_ldb_cq_addr_u_re
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_addr_u_raddr
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_addr_u_waddr
    ,input  logic                  func_lut_ldb_cq_addr_u_we
    ,input  logic [(      33)-1:0] func_lut_ldb_cq_addr_u_wdata
    ,output logic [(      33)-1:0] func_lut_ldb_cq_addr_u_rdata

    ,output logic                  rf_lut_ldb_cq_addr_u_re
    ,output logic                  rf_lut_ldb_cq_addr_u_rclk
    ,output logic                  rf_lut_ldb_cq_addr_u_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_addr_u_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_addr_u_waddr
    ,output logic                  rf_lut_ldb_cq_addr_u_we
    ,output logic                  rf_lut_ldb_cq_addr_u_wclk
    ,output logic                  rf_lut_ldb_cq_addr_u_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_ldb_cq_addr_u_wdata
    ,input  logic [(      33)-1:0] rf_lut_ldb_cq_addr_u_rdata

    ,input  logic                  func_lut_ldb_cq_ai_addr_l_re
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_ai_addr_l_raddr
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_ai_addr_l_waddr
    ,input  logic                  func_lut_ldb_cq_ai_addr_l_we
    ,input  logic [(      31)-1:0] func_lut_ldb_cq_ai_addr_l_wdata
    ,output logic [(      31)-1:0] func_lut_ldb_cq_ai_addr_l_rdata

    ,output logic                  rf_lut_ldb_cq_ai_addr_l_re
    ,output logic                  rf_lut_ldb_cq_ai_addr_l_rclk
    ,output logic                  rf_lut_ldb_cq_ai_addr_l_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_addr_l_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_addr_l_waddr
    ,output logic                  rf_lut_ldb_cq_ai_addr_l_we
    ,output logic                  rf_lut_ldb_cq_ai_addr_l_wclk
    ,output logic                  rf_lut_ldb_cq_ai_addr_l_wclk_rst_n
    ,output logic [(      31)-1:0] rf_lut_ldb_cq_ai_addr_l_wdata
    ,input  logic [(      31)-1:0] rf_lut_ldb_cq_ai_addr_l_rdata

    ,input  logic                  func_lut_ldb_cq_ai_addr_u_re
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_ai_addr_u_raddr
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_ai_addr_u_waddr
    ,input  logic                  func_lut_ldb_cq_ai_addr_u_we
    ,input  logic [(      33)-1:0] func_lut_ldb_cq_ai_addr_u_wdata
    ,output logic [(      33)-1:0] func_lut_ldb_cq_ai_addr_u_rdata

    ,output logic                  rf_lut_ldb_cq_ai_addr_u_re
    ,output logic                  rf_lut_ldb_cq_ai_addr_u_rclk
    ,output logic                  rf_lut_ldb_cq_ai_addr_u_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_addr_u_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_addr_u_waddr
    ,output logic                  rf_lut_ldb_cq_ai_addr_u_we
    ,output logic                  rf_lut_ldb_cq_ai_addr_u_wclk
    ,output logic                  rf_lut_ldb_cq_ai_addr_u_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_ldb_cq_ai_addr_u_wdata
    ,input  logic [(      33)-1:0] rf_lut_ldb_cq_ai_addr_u_rdata

    ,input  logic                  func_lut_ldb_cq_ai_data_re
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_ai_data_raddr
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_ai_data_waddr
    ,input  logic                  func_lut_ldb_cq_ai_data_we
    ,input  logic [(      33)-1:0] func_lut_ldb_cq_ai_data_wdata
    ,output logic [(      33)-1:0] func_lut_ldb_cq_ai_data_rdata

    ,output logic                  rf_lut_ldb_cq_ai_data_re
    ,output logic                  rf_lut_ldb_cq_ai_data_rclk
    ,output logic                  rf_lut_ldb_cq_ai_data_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_data_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_ai_data_waddr
    ,output logic                  rf_lut_ldb_cq_ai_data_we
    ,output logic                  rf_lut_ldb_cq_ai_data_wclk
    ,output logic                  rf_lut_ldb_cq_ai_data_wclk_rst_n
    ,output logic [(      33)-1:0] rf_lut_ldb_cq_ai_data_wdata
    ,input  logic [(      33)-1:0] rf_lut_ldb_cq_ai_data_rdata

    ,input  logic                  func_lut_ldb_cq_isr_re
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_isr_raddr
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_isr_waddr
    ,input  logic                  func_lut_ldb_cq_isr_we
    ,input  logic [(      13)-1:0] func_lut_ldb_cq_isr_wdata
    ,output logic [(      13)-1:0] func_lut_ldb_cq_isr_rdata

    ,output logic                  rf_lut_ldb_cq_isr_re
    ,output logic                  rf_lut_ldb_cq_isr_rclk
    ,output logic                  rf_lut_ldb_cq_isr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_isr_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_isr_waddr
    ,output logic                  rf_lut_ldb_cq_isr_we
    ,output logic                  rf_lut_ldb_cq_isr_wclk
    ,output logic                  rf_lut_ldb_cq_isr_wclk_rst_n
    ,output logic [(      13)-1:0] rf_lut_ldb_cq_isr_wdata
    ,input  logic [(      13)-1:0] rf_lut_ldb_cq_isr_rdata

    ,input  logic                  func_lut_ldb_cq_pasid_re
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_pasid_raddr
    ,input  logic [(       6)-1:0] func_lut_ldb_cq_pasid_waddr
    ,input  logic                  func_lut_ldb_cq_pasid_we
    ,input  logic [(      24)-1:0] func_lut_ldb_cq_pasid_wdata
    ,output logic [(      24)-1:0] func_lut_ldb_cq_pasid_rdata

    ,output logic                  rf_lut_ldb_cq_pasid_re
    ,output logic                  rf_lut_ldb_cq_pasid_rclk
    ,output logic                  rf_lut_ldb_cq_pasid_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_pasid_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_cq_pasid_waddr
    ,output logic                  rf_lut_ldb_cq_pasid_we
    ,output logic                  rf_lut_ldb_cq_pasid_wclk
    ,output logic                  rf_lut_ldb_cq_pasid_wclk_rst_n
    ,output logic [(      24)-1:0] rf_lut_ldb_cq_pasid_wdata
    ,input  logic [(      24)-1:0] rf_lut_ldb_cq_pasid_rdata

    ,input  logic                  func_lut_ldb_pp2vas_re
    ,input  logic [(       5)-1:0] func_lut_ldb_pp2vas_raddr
    ,input  logic [(       5)-1:0] func_lut_ldb_pp2vas_waddr
    ,input  logic                  func_lut_ldb_pp2vas_we
    ,input  logic [(      11)-1:0] func_lut_ldb_pp2vas_wdata
    ,output logic [(      11)-1:0] func_lut_ldb_pp2vas_rdata

    ,output logic                  rf_lut_ldb_pp2vas_re
    ,output logic                  rf_lut_ldb_pp2vas_rclk
    ,output logic                  rf_lut_ldb_pp2vas_rclk_rst_n
    ,output logic [(       5)-1:0] rf_lut_ldb_pp2vas_raddr
    ,output logic [(       5)-1:0] rf_lut_ldb_pp2vas_waddr
    ,output logic                  rf_lut_ldb_pp2vas_we
    ,output logic                  rf_lut_ldb_pp2vas_wclk
    ,output logic                  rf_lut_ldb_pp2vas_wclk_rst_n
    ,output logic [(      11)-1:0] rf_lut_ldb_pp2vas_wdata
    ,input  logic [(      11)-1:0] rf_lut_ldb_pp2vas_rdata

    ,input  logic                  func_lut_ldb_qid2vqid_re
    ,input  logic [(       3)-1:0] func_lut_ldb_qid2vqid_raddr
    ,input  logic [(       3)-1:0] func_lut_ldb_qid2vqid_waddr
    ,input  logic                  func_lut_ldb_qid2vqid_we
    ,input  logic [(      21)-1:0] func_lut_ldb_qid2vqid_wdata
    ,output logic [(      21)-1:0] func_lut_ldb_qid2vqid_rdata

    ,output logic                  rf_lut_ldb_qid2vqid_re
    ,output logic                  rf_lut_ldb_qid2vqid_rclk
    ,output logic                  rf_lut_ldb_qid2vqid_rclk_rst_n
    ,output logic [(       3)-1:0] rf_lut_ldb_qid2vqid_raddr
    ,output logic [(       3)-1:0] rf_lut_ldb_qid2vqid_waddr
    ,output logic                  rf_lut_ldb_qid2vqid_we
    ,output logic                  rf_lut_ldb_qid2vqid_wclk
    ,output logic                  rf_lut_ldb_qid2vqid_wclk_rst_n
    ,output logic [(      21)-1:0] rf_lut_ldb_qid2vqid_wdata
    ,input  logic [(      21)-1:0] rf_lut_ldb_qid2vqid_rdata

    ,input  logic                  func_lut_ldb_vasqid_v_re
    ,input  logic [(       6)-1:0] func_lut_ldb_vasqid_v_raddr
    ,input  logic [(       6)-1:0] func_lut_ldb_vasqid_v_waddr
    ,input  logic                  func_lut_ldb_vasqid_v_we
    ,input  logic [(      17)-1:0] func_lut_ldb_vasqid_v_wdata
    ,output logic [(      17)-1:0] func_lut_ldb_vasqid_v_rdata

    ,output logic                  rf_lut_ldb_vasqid_v_re
    ,output logic                  rf_lut_ldb_vasqid_v_rclk
    ,output logic                  rf_lut_ldb_vasqid_v_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_ldb_vasqid_v_raddr
    ,output logic [(       6)-1:0] rf_lut_ldb_vasqid_v_waddr
    ,output logic                  rf_lut_ldb_vasqid_v_we
    ,output logic                  rf_lut_ldb_vasqid_v_wclk
    ,output logic                  rf_lut_ldb_vasqid_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_ldb_vasqid_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_ldb_vasqid_v_rdata

    ,input  logic                  func_lut_vf_dir_vpp2pp_re
    ,input  logic [(       8)-1:0] func_lut_vf_dir_vpp2pp_raddr
    ,input  logic [(       8)-1:0] func_lut_vf_dir_vpp2pp_waddr
    ,input  logic                  func_lut_vf_dir_vpp2pp_we
    ,input  logic [(      31)-1:0] func_lut_vf_dir_vpp2pp_wdata
    ,output logic [(      31)-1:0] func_lut_vf_dir_vpp2pp_rdata

    ,output logic                  rf_lut_vf_dir_vpp2pp_re
    ,output logic                  rf_lut_vf_dir_vpp2pp_rclk
    ,output logic                  rf_lut_vf_dir_vpp2pp_rclk_rst_n
    ,output logic [(       8)-1:0] rf_lut_vf_dir_vpp2pp_raddr
    ,output logic [(       8)-1:0] rf_lut_vf_dir_vpp2pp_waddr
    ,output logic                  rf_lut_vf_dir_vpp2pp_we
    ,output logic                  rf_lut_vf_dir_vpp2pp_wclk
    ,output logic                  rf_lut_vf_dir_vpp2pp_wclk_rst_n
    ,output logic [(      31)-1:0] rf_lut_vf_dir_vpp2pp_wdata
    ,input  logic [(      31)-1:0] rf_lut_vf_dir_vpp2pp_rdata

    ,input  logic                  func_lut_vf_dir_vpp_v_re
    ,input  logic [(       6)-1:0] func_lut_vf_dir_vpp_v_raddr
    ,input  logic [(       6)-1:0] func_lut_vf_dir_vpp_v_waddr
    ,input  logic                  func_lut_vf_dir_vpp_v_we
    ,input  logic [(      17)-1:0] func_lut_vf_dir_vpp_v_wdata
    ,output logic [(      17)-1:0] func_lut_vf_dir_vpp_v_rdata

    ,output logic                  rf_lut_vf_dir_vpp_v_re
    ,output logic                  rf_lut_vf_dir_vpp_v_rclk
    ,output logic                  rf_lut_vf_dir_vpp_v_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_vf_dir_vpp_v_raddr
    ,output logic [(       6)-1:0] rf_lut_vf_dir_vpp_v_waddr
    ,output logic                  rf_lut_vf_dir_vpp_v_we
    ,output logic                  rf_lut_vf_dir_vpp_v_wclk
    ,output logic                  rf_lut_vf_dir_vpp_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_vf_dir_vpp_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_vf_dir_vpp_v_rdata

    ,input  logic                  func_lut_vf_dir_vqid2qid_re
    ,input  logic [(       8)-1:0] func_lut_vf_dir_vqid2qid_raddr
    ,input  logic [(       8)-1:0] func_lut_vf_dir_vqid2qid_waddr
    ,input  logic                  func_lut_vf_dir_vqid2qid_we
    ,input  logic [(      31)-1:0] func_lut_vf_dir_vqid2qid_wdata
    ,output logic [(      31)-1:0] func_lut_vf_dir_vqid2qid_rdata

    ,output logic                  rf_lut_vf_dir_vqid2qid_re
    ,output logic                  rf_lut_vf_dir_vqid2qid_rclk
    ,output logic                  rf_lut_vf_dir_vqid2qid_rclk_rst_n
    ,output logic [(       8)-1:0] rf_lut_vf_dir_vqid2qid_raddr
    ,output logic [(       8)-1:0] rf_lut_vf_dir_vqid2qid_waddr
    ,output logic                  rf_lut_vf_dir_vqid2qid_we
    ,output logic                  rf_lut_vf_dir_vqid2qid_wclk
    ,output logic                  rf_lut_vf_dir_vqid2qid_wclk_rst_n
    ,output logic [(      31)-1:0] rf_lut_vf_dir_vqid2qid_wdata
    ,input  logic [(      31)-1:0] rf_lut_vf_dir_vqid2qid_rdata

    ,input  logic                  func_lut_vf_dir_vqid_v_re
    ,input  logic [(       6)-1:0] func_lut_vf_dir_vqid_v_raddr
    ,input  logic [(       6)-1:0] func_lut_vf_dir_vqid_v_waddr
    ,input  logic                  func_lut_vf_dir_vqid_v_we
    ,input  logic [(      17)-1:0] func_lut_vf_dir_vqid_v_wdata
    ,output logic [(      17)-1:0] func_lut_vf_dir_vqid_v_rdata

    ,output logic                  rf_lut_vf_dir_vqid_v_re
    ,output logic                  rf_lut_vf_dir_vqid_v_rclk
    ,output logic                  rf_lut_vf_dir_vqid_v_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_vf_dir_vqid_v_raddr
    ,output logic [(       6)-1:0] rf_lut_vf_dir_vqid_v_waddr
    ,output logic                  rf_lut_vf_dir_vqid_v_we
    ,output logic                  rf_lut_vf_dir_vqid_v_wclk
    ,output logic                  rf_lut_vf_dir_vqid_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_vf_dir_vqid_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_vf_dir_vqid_v_rdata

    ,input  logic                  func_lut_vf_ldb_vpp2pp_re
    ,input  logic [(       8)-1:0] func_lut_vf_ldb_vpp2pp_raddr
    ,input  logic [(       8)-1:0] func_lut_vf_ldb_vpp2pp_waddr
    ,input  logic                  func_lut_vf_ldb_vpp2pp_we
    ,input  logic [(      25)-1:0] func_lut_vf_ldb_vpp2pp_wdata
    ,output logic [(      25)-1:0] func_lut_vf_ldb_vpp2pp_rdata

    ,output logic                  rf_lut_vf_ldb_vpp2pp_re
    ,output logic                  rf_lut_vf_ldb_vpp2pp_rclk
    ,output logic                  rf_lut_vf_ldb_vpp2pp_rclk_rst_n
    ,output logic [(       8)-1:0] rf_lut_vf_ldb_vpp2pp_raddr
    ,output logic [(       8)-1:0] rf_lut_vf_ldb_vpp2pp_waddr
    ,output logic                  rf_lut_vf_ldb_vpp2pp_we
    ,output logic                  rf_lut_vf_ldb_vpp2pp_wclk
    ,output logic                  rf_lut_vf_ldb_vpp2pp_wclk_rst_n
    ,output logic [(      25)-1:0] rf_lut_vf_ldb_vpp2pp_wdata
    ,input  logic [(      25)-1:0] rf_lut_vf_ldb_vpp2pp_rdata

    ,input  logic                  func_lut_vf_ldb_vpp_v_re
    ,input  logic [(       6)-1:0] func_lut_vf_ldb_vpp_v_raddr
    ,input  logic [(       6)-1:0] func_lut_vf_ldb_vpp_v_waddr
    ,input  logic                  func_lut_vf_ldb_vpp_v_we
    ,input  logic [(      17)-1:0] func_lut_vf_ldb_vpp_v_wdata
    ,output logic [(      17)-1:0] func_lut_vf_ldb_vpp_v_rdata

    ,output logic                  rf_lut_vf_ldb_vpp_v_re
    ,output logic                  rf_lut_vf_ldb_vpp_v_rclk
    ,output logic                  rf_lut_vf_ldb_vpp_v_rclk_rst_n
    ,output logic [(       6)-1:0] rf_lut_vf_ldb_vpp_v_raddr
    ,output logic [(       6)-1:0] rf_lut_vf_ldb_vpp_v_waddr
    ,output logic                  rf_lut_vf_ldb_vpp_v_we
    ,output logic                  rf_lut_vf_ldb_vpp_v_wclk
    ,output logic                  rf_lut_vf_ldb_vpp_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_vf_ldb_vpp_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_vf_ldb_vpp_v_rdata

    ,input  logic                  func_lut_vf_ldb_vqid2qid_re
    ,input  logic [(       7)-1:0] func_lut_vf_ldb_vqid2qid_raddr
    ,input  logic [(       7)-1:0] func_lut_vf_ldb_vqid2qid_waddr
    ,input  logic                  func_lut_vf_ldb_vqid2qid_we
    ,input  logic [(      27)-1:0] func_lut_vf_ldb_vqid2qid_wdata
    ,output logic [(      27)-1:0] func_lut_vf_ldb_vqid2qid_rdata

    ,output logic                  rf_lut_vf_ldb_vqid2qid_re
    ,output logic                  rf_lut_vf_ldb_vqid2qid_rclk
    ,output logic                  rf_lut_vf_ldb_vqid2qid_rclk_rst_n
    ,output logic [(       7)-1:0] rf_lut_vf_ldb_vqid2qid_raddr
    ,output logic [(       7)-1:0] rf_lut_vf_ldb_vqid2qid_waddr
    ,output logic                  rf_lut_vf_ldb_vqid2qid_we
    ,output logic                  rf_lut_vf_ldb_vqid2qid_wclk
    ,output logic                  rf_lut_vf_ldb_vqid2qid_wclk_rst_n
    ,output logic [(      27)-1:0] rf_lut_vf_ldb_vqid2qid_wdata
    ,input  logic [(      27)-1:0] rf_lut_vf_ldb_vqid2qid_rdata

    ,input  logic                  func_lut_vf_ldb_vqid_v_re
    ,input  logic [(       5)-1:0] func_lut_vf_ldb_vqid_v_raddr
    ,input  logic [(       5)-1:0] func_lut_vf_ldb_vqid_v_waddr
    ,input  logic                  func_lut_vf_ldb_vqid_v_we
    ,input  logic [(      17)-1:0] func_lut_vf_ldb_vqid_v_wdata
    ,output logic [(      17)-1:0] func_lut_vf_ldb_vqid_v_rdata

    ,output logic                  rf_lut_vf_ldb_vqid_v_re
    ,output logic                  rf_lut_vf_ldb_vqid_v_rclk
    ,output logic                  rf_lut_vf_ldb_vqid_v_rclk_rst_n
    ,output logic [(       5)-1:0] rf_lut_vf_ldb_vqid_v_raddr
    ,output logic [(       5)-1:0] rf_lut_vf_ldb_vqid_v_waddr
    ,output logic                  rf_lut_vf_ldb_vqid_v_we
    ,output logic                  rf_lut_vf_ldb_vqid_v_wclk
    ,output logic                  rf_lut_vf_ldb_vqid_v_wclk_rst_n
    ,output logic [(      17)-1:0] rf_lut_vf_ldb_vqid_v_wdata
    ,input  logic [(      17)-1:0] rf_lut_vf_ldb_vqid_v_rdata

    ,input  logic                  func_msix_tbl_word0_re
    ,input  logic [(       6)-1:0] func_msix_tbl_word0_raddr
    ,input  logic [(       6)-1:0] func_msix_tbl_word0_waddr
    ,input  logic                  func_msix_tbl_word0_we
    ,input  logic [(      33)-1:0] func_msix_tbl_word0_wdata
    ,output logic [(      33)-1:0] func_msix_tbl_word0_rdata

    ,output logic                  rf_msix_tbl_word0_re
    ,output logic                  rf_msix_tbl_word0_rclk
    ,output logic                  rf_msix_tbl_word0_rclk_rst_n
    ,output logic [(       6)-1:0] rf_msix_tbl_word0_raddr
    ,output logic [(       6)-1:0] rf_msix_tbl_word0_waddr
    ,output logic                  rf_msix_tbl_word0_we
    ,output logic                  rf_msix_tbl_word0_wclk
    ,output logic                  rf_msix_tbl_word0_wclk_rst_n
    ,output logic [(      33)-1:0] rf_msix_tbl_word0_wdata
    ,input  logic [(      33)-1:0] rf_msix_tbl_word0_rdata

    ,input  logic                  func_msix_tbl_word1_re
    ,input  logic [(       6)-1:0] func_msix_tbl_word1_raddr
    ,input  logic [(       6)-1:0] func_msix_tbl_word1_waddr
    ,input  logic                  func_msix_tbl_word1_we
    ,input  logic [(      33)-1:0] func_msix_tbl_word1_wdata
    ,output logic [(      33)-1:0] func_msix_tbl_word1_rdata

    ,output logic                  rf_msix_tbl_word1_re
    ,output logic                  rf_msix_tbl_word1_rclk
    ,output logic                  rf_msix_tbl_word1_rclk_rst_n
    ,output logic [(       6)-1:0] rf_msix_tbl_word1_raddr
    ,output logic [(       6)-1:0] rf_msix_tbl_word1_waddr
    ,output logic                  rf_msix_tbl_word1_we
    ,output logic                  rf_msix_tbl_word1_wclk
    ,output logic                  rf_msix_tbl_word1_wclk_rst_n
    ,output logic [(      33)-1:0] rf_msix_tbl_word1_wdata
    ,input  logic [(      33)-1:0] rf_msix_tbl_word1_rdata

    ,input  logic                  func_msix_tbl_word2_re
    ,input  logic [(       6)-1:0] func_msix_tbl_word2_raddr
    ,input  logic [(       6)-1:0] func_msix_tbl_word2_waddr
    ,input  logic                  func_msix_tbl_word2_we
    ,input  logic [(      33)-1:0] func_msix_tbl_word2_wdata
    ,output logic [(      33)-1:0] func_msix_tbl_word2_rdata

    ,output logic                  rf_msix_tbl_word2_re
    ,output logic                  rf_msix_tbl_word2_rclk
    ,output logic                  rf_msix_tbl_word2_rclk_rst_n
    ,output logic [(       6)-1:0] rf_msix_tbl_word2_raddr
    ,output logic [(       6)-1:0] rf_msix_tbl_word2_waddr
    ,output logic                  rf_msix_tbl_word2_we
    ,output logic                  rf_msix_tbl_word2_wclk
    ,output logic                  rf_msix_tbl_word2_wclk_rst_n
    ,output logic [(      33)-1:0] rf_msix_tbl_word2_wdata
    ,input  logic [(      33)-1:0] rf_msix_tbl_word2_rdata

    ,input  logic                  func_sch_out_fifo_re
    ,input  logic [(       7)-1:0] func_sch_out_fifo_raddr
    ,input  logic [(       7)-1:0] func_sch_out_fifo_waddr
    ,input  logic                  func_sch_out_fifo_we
    ,input  logic [(     262)-1:0] func_sch_out_fifo_wdata
    ,output logic [(     262)-1:0] func_sch_out_fifo_rdata

    ,output logic                  rf_sch_out_fifo_re
    ,output logic                  rf_sch_out_fifo_rclk
    ,output logic                  rf_sch_out_fifo_rclk_rst_n
    ,output logic [(       7)-1:0] rf_sch_out_fifo_raddr
    ,output logic [(       7)-1:0] rf_sch_out_fifo_waddr
    ,output logic                  rf_sch_out_fifo_we
    ,output logic                  rf_sch_out_fifo_wclk
    ,output logic                  rf_sch_out_fifo_wclk_rst_n
    ,output logic [(     270)-1:0] rf_sch_out_fifo_wdata
    ,input  logic [(     270)-1:0] rf_sch_out_fifo_rdata

    ,input  logic                  func_rob_mem_re
    ,input  logic [(      11)-1:0] func_rob_mem_addr
    ,input  logic                  func_rob_mem_we
    ,input  logic [(     156)-1:0] func_rob_mem_wdata
    ,output logic [(     156)-1:0] func_rob_mem_rdata

    ,output logic                  sr_rob_mem_re
    ,output logic                  sr_rob_mem_clk
    ,output logic                  sr_rob_mem_clk_rst_n
    ,output logic [(      11)-1:0] sr_rob_mem_addr
    ,output logic                  sr_rob_mem_we
    ,output logic [(     156)-1:0] sr_rob_mem_wdata
    ,input  logic [(     156)-1:0] sr_rob_mem_rdata

);

logic        rf_alarm_vf_synd0_rdata_error;

logic        cfg_mem_ack_alarm_vf_synd0_nc;
logic [31:0] cfg_mem_rdata_alarm_vf_synd0_nc;

logic        rf_alarm_vf_synd0_error_nc;
logic [(30)-1:0] pf_alarm_vf_synd0_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (30)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_alarm_vf_synd0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_alarm_vf_synd0_re)
        ,.func_mem_raddr      (func_alarm_vf_synd0_raddr)
        ,.func_mem_waddr      (func_alarm_vf_synd0_waddr)
        ,.func_mem_we         (func_alarm_vf_synd0_we)
        ,.func_mem_wdata      (func_alarm_vf_synd0_wdata)
        ,.func_mem_rdata      (func_alarm_vf_synd0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_alarm_vf_synd0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_alarm_vf_synd0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_alarm_vf_synd0_rdata_nc)

        ,.mem_wclk            (rf_alarm_vf_synd0_wclk)
        ,.mem_rclk            (rf_alarm_vf_synd0_rclk)
        ,.mem_wclk_rst_n      (rf_alarm_vf_synd0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_alarm_vf_synd0_rclk_rst_n)
        ,.mem_re              (rf_alarm_vf_synd0_re)
        ,.mem_raddr           (rf_alarm_vf_synd0_raddr)
        ,.mem_waddr           (rf_alarm_vf_synd0_waddr)
        ,.mem_we              (rf_alarm_vf_synd0_we)
        ,.mem_wdata           (rf_alarm_vf_synd0_wdata)
        ,.mem_rdata           (rf_alarm_vf_synd0_rdata)

        ,.mem_rdata_error     (rf_alarm_vf_synd0_rdata_error)
        ,.error               (rf_alarm_vf_synd0_error_nc)
);

logic        rf_alarm_vf_synd1_rdata_error;

logic        cfg_mem_ack_alarm_vf_synd1_nc;
logic [31:0] cfg_mem_rdata_alarm_vf_synd1_nc;

logic        rf_alarm_vf_synd1_error_nc;
logic [(32)-1:0] pf_alarm_vf_synd1_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (32)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_alarm_vf_synd1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_alarm_vf_synd1_re)
        ,.func_mem_raddr      (func_alarm_vf_synd1_raddr)
        ,.func_mem_waddr      (func_alarm_vf_synd1_waddr)
        ,.func_mem_we         (func_alarm_vf_synd1_we)
        ,.func_mem_wdata      (func_alarm_vf_synd1_wdata)
        ,.func_mem_rdata      (func_alarm_vf_synd1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_alarm_vf_synd1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_alarm_vf_synd1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_alarm_vf_synd1_rdata_nc)

        ,.mem_wclk            (rf_alarm_vf_synd1_wclk)
        ,.mem_rclk            (rf_alarm_vf_synd1_rclk)
        ,.mem_wclk_rst_n      (rf_alarm_vf_synd1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_alarm_vf_synd1_rclk_rst_n)
        ,.mem_re              (rf_alarm_vf_synd1_re)
        ,.mem_raddr           (rf_alarm_vf_synd1_raddr)
        ,.mem_waddr           (rf_alarm_vf_synd1_waddr)
        ,.mem_we              (rf_alarm_vf_synd1_we)
        ,.mem_wdata           (rf_alarm_vf_synd1_wdata)
        ,.mem_rdata           (rf_alarm_vf_synd1_rdata)

        ,.mem_rdata_error     (rf_alarm_vf_synd1_rdata_error)
        ,.error               (rf_alarm_vf_synd1_error_nc)
);

logic        rf_alarm_vf_synd2_rdata_error;

logic        cfg_mem_ack_alarm_vf_synd2_nc;
logic [31:0] cfg_mem_rdata_alarm_vf_synd2_nc;

logic        rf_alarm_vf_synd2_error_nc;
logic [(32)-1:0] pf_alarm_vf_synd2_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (32)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_alarm_vf_synd2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_alarm_vf_synd2_re)
        ,.func_mem_raddr      (func_alarm_vf_synd2_raddr)
        ,.func_mem_waddr      (func_alarm_vf_synd2_waddr)
        ,.func_mem_we         (func_alarm_vf_synd2_we)
        ,.func_mem_wdata      (func_alarm_vf_synd2_wdata)
        ,.func_mem_rdata      (func_alarm_vf_synd2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_alarm_vf_synd2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_alarm_vf_synd2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_alarm_vf_synd2_rdata_nc)

        ,.mem_wclk            (rf_alarm_vf_synd2_wclk)
        ,.mem_rclk            (rf_alarm_vf_synd2_rclk)
        ,.mem_wclk_rst_n      (rf_alarm_vf_synd2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_alarm_vf_synd2_rclk_rst_n)
        ,.mem_re              (rf_alarm_vf_synd2_re)
        ,.mem_raddr           (rf_alarm_vf_synd2_raddr)
        ,.mem_waddr           (rf_alarm_vf_synd2_waddr)
        ,.mem_we              (rf_alarm_vf_synd2_we)
        ,.mem_wdata           (rf_alarm_vf_synd2_wdata)
        ,.mem_rdata           (rf_alarm_vf_synd2_rdata)

        ,.mem_rdata_error     (rf_alarm_vf_synd2_rdata_error)
        ,.error               (rf_alarm_vf_synd2_error_nc)
);

logic        rf_dir_wb0_rdata_error;

logic        cfg_mem_ack_dir_wb0_nc;
logic [31:0] cfg_mem_rdata_dir_wb0_nc;

logic        rf_dir_wb0_error_nc;
logic [(144)-1:0] pf_dir_wb0_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (144)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_wb0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_wb0_re)
        ,.func_mem_raddr      (func_dir_wb0_raddr)
        ,.func_mem_waddr      (func_dir_wb0_waddr)
        ,.func_mem_we         (func_dir_wb0_we)
        ,.func_mem_wdata      (func_dir_wb0_wdata)
        ,.func_mem_rdata      (func_dir_wb0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_wb0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_wb0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_dir_wb0_rdata_nc)

        ,.mem_wclk            (rf_dir_wb0_wclk)
        ,.mem_rclk            (rf_dir_wb0_rclk)
        ,.mem_wclk_rst_n      (rf_dir_wb0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_wb0_rclk_rst_n)
        ,.mem_re              (rf_dir_wb0_re)
        ,.mem_raddr           (rf_dir_wb0_raddr)
        ,.mem_waddr           (rf_dir_wb0_waddr)
        ,.mem_we              (rf_dir_wb0_we)
        ,.mem_wdata           (rf_dir_wb0_wdata)
        ,.mem_rdata           (rf_dir_wb0_rdata)

        ,.mem_rdata_error     (rf_dir_wb0_rdata_error)
        ,.error               (rf_dir_wb0_error_nc)
);

logic        rf_dir_wb1_rdata_error;

logic        cfg_mem_ack_dir_wb1_nc;
logic [31:0] cfg_mem_rdata_dir_wb1_nc;

logic        rf_dir_wb1_error_nc;
logic [(144)-1:0] pf_dir_wb1_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (144)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_wb1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_wb1_re)
        ,.func_mem_raddr      (func_dir_wb1_raddr)
        ,.func_mem_waddr      (func_dir_wb1_waddr)
        ,.func_mem_we         (func_dir_wb1_we)
        ,.func_mem_wdata      (func_dir_wb1_wdata)
        ,.func_mem_rdata      (func_dir_wb1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_wb1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_wb1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_dir_wb1_rdata_nc)

        ,.mem_wclk            (rf_dir_wb1_wclk)
        ,.mem_rclk            (rf_dir_wb1_rclk)
        ,.mem_wclk_rst_n      (rf_dir_wb1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_wb1_rclk_rst_n)
        ,.mem_re              (rf_dir_wb1_re)
        ,.mem_raddr           (rf_dir_wb1_raddr)
        ,.mem_waddr           (rf_dir_wb1_waddr)
        ,.mem_we              (rf_dir_wb1_we)
        ,.mem_wdata           (rf_dir_wb1_wdata)
        ,.mem_rdata           (rf_dir_wb1_rdata)

        ,.mem_rdata_error     (rf_dir_wb1_rdata_error)
        ,.error               (rf_dir_wb1_error_nc)
);

logic        rf_dir_wb2_rdata_error;

logic        cfg_mem_ack_dir_wb2_nc;
logic [31:0] cfg_mem_rdata_dir_wb2_nc;

logic        rf_dir_wb2_error_nc;
logic [(144)-1:0] pf_dir_wb2_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (144)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_wb2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_wb2_re)
        ,.func_mem_raddr      (func_dir_wb2_raddr)
        ,.func_mem_waddr      (func_dir_wb2_waddr)
        ,.func_mem_we         (func_dir_wb2_we)
        ,.func_mem_wdata      (func_dir_wb2_wdata)
        ,.func_mem_rdata      (func_dir_wb2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_wb2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_wb2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_dir_wb2_rdata_nc)

        ,.mem_wclk            (rf_dir_wb2_wclk)
        ,.mem_rclk            (rf_dir_wb2_rclk)
        ,.mem_wclk_rst_n      (rf_dir_wb2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_wb2_rclk_rst_n)
        ,.mem_re              (rf_dir_wb2_re)
        ,.mem_raddr           (rf_dir_wb2_raddr)
        ,.mem_waddr           (rf_dir_wb2_waddr)
        ,.mem_we              (rf_dir_wb2_we)
        ,.mem_wdata           (rf_dir_wb2_wdata)
        ,.mem_rdata           (rf_dir_wb2_rdata)

        ,.mem_rdata_error     (rf_dir_wb2_rdata_error)
        ,.error               (rf_dir_wb2_error_nc)
);

logic        rf_hcw_enq_fifo_rdata_error;

hqm_AW_dc_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (161)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (6)
) i_hcw_enq_fifo (
         .rclk                (hqm_gated_clk)
        ,.rrst_n              (hqm_gated_rst_n)

        ,.wclk                (prim_gated_clk)
        ,.wrst_n              (prim_gated_rst_n)

        ,.func_mem_re         (func_hcw_enq_fifo_re)
        ,.func_mem_raddr      (func_hcw_enq_fifo_raddr)
        ,.func_mem_waddr      (func_hcw_enq_fifo_waddr)
        ,.func_mem_we         (func_hcw_enq_fifo_we)
        ,.func_mem_wdata      (func_hcw_enq_fifo_wdata)
        ,.func_mem_rdata      (func_hcw_enq_fifo_rdata)

        ,.mem_wclk            (rf_hcw_enq_fifo_wclk)
        ,.mem_rclk            (rf_hcw_enq_fifo_rclk)
        ,.mem_wclk_rst_n      (rf_hcw_enq_fifo_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_hcw_enq_fifo_rclk_rst_n)
        ,.mem_re              (rf_hcw_enq_fifo_re)
        ,.mem_raddr           (rf_hcw_enq_fifo_raddr)
        ,.mem_waddr           (rf_hcw_enq_fifo_waddr)
        ,.mem_we              (rf_hcw_enq_fifo_we)
        ,.mem_wdata           (rf_hcw_enq_fifo_wdata)
        ,.mem_rdata           (rf_hcw_enq_fifo_rdata)

        ,.mem_rdata_error     (rf_hcw_enq_fifo_rdata_error)
);

logic        rf_ldb_wb0_rdata_error;

logic        cfg_mem_ack_ldb_wb0_nc;
logic [31:0] cfg_mem_rdata_ldb_wb0_nc;

logic        rf_ldb_wb0_error_nc;
logic [(144)-1:0] pf_ldb_wb0_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (144)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ldb_wb0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ldb_wb0_re)
        ,.func_mem_raddr      (func_ldb_wb0_raddr)
        ,.func_mem_waddr      (func_ldb_wb0_waddr)
        ,.func_mem_we         (func_ldb_wb0_we)
        ,.func_mem_wdata      (func_ldb_wb0_wdata)
        ,.func_mem_rdata      (func_ldb_wb0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ldb_wb0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ldb_wb0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_ldb_wb0_rdata_nc)

        ,.mem_wclk            (rf_ldb_wb0_wclk)
        ,.mem_rclk            (rf_ldb_wb0_rclk)
        ,.mem_wclk_rst_n      (rf_ldb_wb0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ldb_wb0_rclk_rst_n)
        ,.mem_re              (rf_ldb_wb0_re)
        ,.mem_raddr           (rf_ldb_wb0_raddr)
        ,.mem_waddr           (rf_ldb_wb0_waddr)
        ,.mem_we              (rf_ldb_wb0_we)
        ,.mem_wdata           (rf_ldb_wb0_wdata)
        ,.mem_rdata           (rf_ldb_wb0_rdata)

        ,.mem_rdata_error     (rf_ldb_wb0_rdata_error)
        ,.error               (rf_ldb_wb0_error_nc)
);

logic        rf_ldb_wb1_rdata_error;

logic        cfg_mem_ack_ldb_wb1_nc;
logic [31:0] cfg_mem_rdata_ldb_wb1_nc;

logic        rf_ldb_wb1_error_nc;
logic [(144)-1:0] pf_ldb_wb1_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (144)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ldb_wb1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ldb_wb1_re)
        ,.func_mem_raddr      (func_ldb_wb1_raddr)
        ,.func_mem_waddr      (func_ldb_wb1_waddr)
        ,.func_mem_we         (func_ldb_wb1_we)
        ,.func_mem_wdata      (func_ldb_wb1_wdata)
        ,.func_mem_rdata      (func_ldb_wb1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ldb_wb1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ldb_wb1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_ldb_wb1_rdata_nc)

        ,.mem_wclk            (rf_ldb_wb1_wclk)
        ,.mem_rclk            (rf_ldb_wb1_rclk)
        ,.mem_wclk_rst_n      (rf_ldb_wb1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ldb_wb1_rclk_rst_n)
        ,.mem_re              (rf_ldb_wb1_re)
        ,.mem_raddr           (rf_ldb_wb1_raddr)
        ,.mem_waddr           (rf_ldb_wb1_waddr)
        ,.mem_we              (rf_ldb_wb1_we)
        ,.mem_wdata           (rf_ldb_wb1_wdata)
        ,.mem_rdata           (rf_ldb_wb1_rdata)

        ,.mem_rdata_error     (rf_ldb_wb1_rdata_error)
        ,.error               (rf_ldb_wb1_error_nc)
);

logic        rf_ldb_wb2_rdata_error;

logic        cfg_mem_ack_ldb_wb2_nc;
logic [31:0] cfg_mem_rdata_ldb_wb2_nc;

logic        rf_ldb_wb2_error_nc;
logic [(144)-1:0] pf_ldb_wb2_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (144)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ldb_wb2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ldb_wb2_re)
        ,.func_mem_raddr      (func_ldb_wb2_raddr)
        ,.func_mem_waddr      (func_ldb_wb2_waddr)
        ,.func_mem_we         (func_ldb_wb2_we)
        ,.func_mem_wdata      (func_ldb_wb2_wdata)
        ,.func_mem_rdata      (func_ldb_wb2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ldb_wb2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ldb_wb2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_ldb_wb2_rdata_nc)

        ,.mem_wclk            (rf_ldb_wb2_wclk)
        ,.mem_rclk            (rf_ldb_wb2_rclk)
        ,.mem_wclk_rst_n      (rf_ldb_wb2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ldb_wb2_rclk_rst_n)
        ,.mem_re              (rf_ldb_wb2_re)
        ,.mem_raddr           (rf_ldb_wb2_raddr)
        ,.mem_waddr           (rf_ldb_wb2_waddr)
        ,.mem_we              (rf_ldb_wb2_we)
        ,.mem_wdata           (rf_ldb_wb2_wdata)
        ,.mem_rdata           (rf_ldb_wb2_rdata)

        ,.mem_rdata_error     (rf_ldb_wb2_rdata_error)
        ,.error               (rf_ldb_wb2_error_nc)
);

logic        rf_lut_dir_cq2vf_pf_ro_rdata_error;

logic        cfg_mem_ack_lut_dir_cq2vf_pf_ro_nc;
logic [31:0] cfg_mem_rdata_lut_dir_cq2vf_pf_ro_nc;

logic        rf_lut_dir_cq2vf_pf_ro_error_nc;
logic [(13)-1:0] pf_lut_dir_cq2vf_pf_ro_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_dir_cq2vf_pf_ro (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_dir_cq2vf_pf_ro_re)
        ,.func_mem_raddr      (func_lut_dir_cq2vf_pf_ro_raddr)
        ,.func_mem_waddr      (func_lut_dir_cq2vf_pf_ro_waddr)
        ,.func_mem_we         (func_lut_dir_cq2vf_pf_ro_we)
        ,.func_mem_wdata      (func_lut_dir_cq2vf_pf_ro_wdata)
        ,.func_mem_rdata      (func_lut_dir_cq2vf_pf_ro_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_dir_cq2vf_pf_ro_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_dir_cq2vf_pf_ro_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_dir_cq2vf_pf_ro_rdata_nc)

        ,.mem_wclk            (rf_lut_dir_cq2vf_pf_ro_wclk)
        ,.mem_rclk            (rf_lut_dir_cq2vf_pf_ro_rclk)
        ,.mem_wclk_rst_n      (rf_lut_dir_cq2vf_pf_ro_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_dir_cq2vf_pf_ro_rclk_rst_n)
        ,.mem_re              (rf_lut_dir_cq2vf_pf_ro_re)
        ,.mem_raddr           (rf_lut_dir_cq2vf_pf_ro_raddr)
        ,.mem_waddr           (rf_lut_dir_cq2vf_pf_ro_waddr)
        ,.mem_we              (rf_lut_dir_cq2vf_pf_ro_we)
        ,.mem_wdata           (rf_lut_dir_cq2vf_pf_ro_wdata)
        ,.mem_rdata           (rf_lut_dir_cq2vf_pf_ro_rdata)

        ,.mem_rdata_error     (rf_lut_dir_cq2vf_pf_ro_rdata_error)
        ,.error               (rf_lut_dir_cq2vf_pf_ro_error_nc)
);

logic        rf_lut_dir_cq_addr_l_rdata_error;

logic        cfg_mem_ack_lut_dir_cq_addr_l_nc;
logic [31:0] cfg_mem_rdata_lut_dir_cq_addr_l_nc;

logic        rf_lut_dir_cq_addr_l_error_nc;
logic [(27)-1:0] pf_lut_dir_cq_addr_l_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (27)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_dir_cq_addr_l (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_dir_cq_addr_l_re)
        ,.func_mem_raddr      (func_lut_dir_cq_addr_l_raddr)
        ,.func_mem_waddr      (func_lut_dir_cq_addr_l_waddr)
        ,.func_mem_we         (func_lut_dir_cq_addr_l_we)
        ,.func_mem_wdata      (func_lut_dir_cq_addr_l_wdata)
        ,.func_mem_rdata      (func_lut_dir_cq_addr_l_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_dir_cq_addr_l_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_dir_cq_addr_l_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_dir_cq_addr_l_rdata_nc)

        ,.mem_wclk            (rf_lut_dir_cq_addr_l_wclk)
        ,.mem_rclk            (rf_lut_dir_cq_addr_l_rclk)
        ,.mem_wclk_rst_n      (rf_lut_dir_cq_addr_l_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_dir_cq_addr_l_rclk_rst_n)
        ,.mem_re              (rf_lut_dir_cq_addr_l_re)
        ,.mem_raddr           (rf_lut_dir_cq_addr_l_raddr)
        ,.mem_waddr           (rf_lut_dir_cq_addr_l_waddr)
        ,.mem_we              (rf_lut_dir_cq_addr_l_we)
        ,.mem_wdata           (rf_lut_dir_cq_addr_l_wdata)
        ,.mem_rdata           (rf_lut_dir_cq_addr_l_rdata)

        ,.mem_rdata_error     (rf_lut_dir_cq_addr_l_rdata_error)
        ,.error               (rf_lut_dir_cq_addr_l_error_nc)
);

logic        rf_lut_dir_cq_addr_u_rdata_error;

logic        cfg_mem_ack_lut_dir_cq_addr_u_nc;
logic [31:0] cfg_mem_rdata_lut_dir_cq_addr_u_nc;

logic        rf_lut_dir_cq_addr_u_error_nc;
logic [(33)-1:0] pf_lut_dir_cq_addr_u_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_dir_cq_addr_u (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_dir_cq_addr_u_re)
        ,.func_mem_raddr      (func_lut_dir_cq_addr_u_raddr)
        ,.func_mem_waddr      (func_lut_dir_cq_addr_u_waddr)
        ,.func_mem_we         (func_lut_dir_cq_addr_u_we)
        ,.func_mem_wdata      (func_lut_dir_cq_addr_u_wdata)
        ,.func_mem_rdata      (func_lut_dir_cq_addr_u_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_dir_cq_addr_u_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_dir_cq_addr_u_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_dir_cq_addr_u_rdata_nc)

        ,.mem_wclk            (rf_lut_dir_cq_addr_u_wclk)
        ,.mem_rclk            (rf_lut_dir_cq_addr_u_rclk)
        ,.mem_wclk_rst_n      (rf_lut_dir_cq_addr_u_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_dir_cq_addr_u_rclk_rst_n)
        ,.mem_re              (rf_lut_dir_cq_addr_u_re)
        ,.mem_raddr           (rf_lut_dir_cq_addr_u_raddr)
        ,.mem_waddr           (rf_lut_dir_cq_addr_u_waddr)
        ,.mem_we              (rf_lut_dir_cq_addr_u_we)
        ,.mem_wdata           (rf_lut_dir_cq_addr_u_wdata)
        ,.mem_rdata           (rf_lut_dir_cq_addr_u_rdata)

        ,.mem_rdata_error     (rf_lut_dir_cq_addr_u_rdata_error)
        ,.error               (rf_lut_dir_cq_addr_u_error_nc)
);

logic        rf_lut_dir_cq_ai_addr_l_rdata_error;

logic        cfg_mem_ack_lut_dir_cq_ai_addr_l_nc;
logic [31:0] cfg_mem_rdata_lut_dir_cq_ai_addr_l_nc;

logic        rf_lut_dir_cq_ai_addr_l_error_nc;
logic [(31)-1:0] pf_lut_dir_cq_ai_addr_l_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (31)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_dir_cq_ai_addr_l (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_dir_cq_ai_addr_l_re)
        ,.func_mem_raddr      (func_lut_dir_cq_ai_addr_l_raddr)
        ,.func_mem_waddr      (func_lut_dir_cq_ai_addr_l_waddr)
        ,.func_mem_we         (func_lut_dir_cq_ai_addr_l_we)
        ,.func_mem_wdata      (func_lut_dir_cq_ai_addr_l_wdata)
        ,.func_mem_rdata      (func_lut_dir_cq_ai_addr_l_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_dir_cq_ai_addr_l_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_dir_cq_ai_addr_l_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_dir_cq_ai_addr_l_rdata_nc)

        ,.mem_wclk            (rf_lut_dir_cq_ai_addr_l_wclk)
        ,.mem_rclk            (rf_lut_dir_cq_ai_addr_l_rclk)
        ,.mem_wclk_rst_n      (rf_lut_dir_cq_ai_addr_l_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_dir_cq_ai_addr_l_rclk_rst_n)
        ,.mem_re              (rf_lut_dir_cq_ai_addr_l_re)
        ,.mem_raddr           (rf_lut_dir_cq_ai_addr_l_raddr)
        ,.mem_waddr           (rf_lut_dir_cq_ai_addr_l_waddr)
        ,.mem_we              (rf_lut_dir_cq_ai_addr_l_we)
        ,.mem_wdata           (rf_lut_dir_cq_ai_addr_l_wdata)
        ,.mem_rdata           (rf_lut_dir_cq_ai_addr_l_rdata)

        ,.mem_rdata_error     (rf_lut_dir_cq_ai_addr_l_rdata_error)
        ,.error               (rf_lut_dir_cq_ai_addr_l_error_nc)
);

logic        rf_lut_dir_cq_ai_addr_u_rdata_error;

logic        cfg_mem_ack_lut_dir_cq_ai_addr_u_nc;
logic [31:0] cfg_mem_rdata_lut_dir_cq_ai_addr_u_nc;

logic        rf_lut_dir_cq_ai_addr_u_error_nc;
logic [(33)-1:0] pf_lut_dir_cq_ai_addr_u_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_dir_cq_ai_addr_u (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_dir_cq_ai_addr_u_re)
        ,.func_mem_raddr      (func_lut_dir_cq_ai_addr_u_raddr)
        ,.func_mem_waddr      (func_lut_dir_cq_ai_addr_u_waddr)
        ,.func_mem_we         (func_lut_dir_cq_ai_addr_u_we)
        ,.func_mem_wdata      (func_lut_dir_cq_ai_addr_u_wdata)
        ,.func_mem_rdata      (func_lut_dir_cq_ai_addr_u_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_dir_cq_ai_addr_u_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_dir_cq_ai_addr_u_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_dir_cq_ai_addr_u_rdata_nc)

        ,.mem_wclk            (rf_lut_dir_cq_ai_addr_u_wclk)
        ,.mem_rclk            (rf_lut_dir_cq_ai_addr_u_rclk)
        ,.mem_wclk_rst_n      (rf_lut_dir_cq_ai_addr_u_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_dir_cq_ai_addr_u_rclk_rst_n)
        ,.mem_re              (rf_lut_dir_cq_ai_addr_u_re)
        ,.mem_raddr           (rf_lut_dir_cq_ai_addr_u_raddr)
        ,.mem_waddr           (rf_lut_dir_cq_ai_addr_u_waddr)
        ,.mem_we              (rf_lut_dir_cq_ai_addr_u_we)
        ,.mem_wdata           (rf_lut_dir_cq_ai_addr_u_wdata)
        ,.mem_rdata           (rf_lut_dir_cq_ai_addr_u_rdata)

        ,.mem_rdata_error     (rf_lut_dir_cq_ai_addr_u_rdata_error)
        ,.error               (rf_lut_dir_cq_ai_addr_u_error_nc)
);

logic        rf_lut_dir_cq_ai_data_rdata_error;

logic        cfg_mem_ack_lut_dir_cq_ai_data_nc;
logic [31:0] cfg_mem_rdata_lut_dir_cq_ai_data_nc;

logic        rf_lut_dir_cq_ai_data_error_nc;
logic [(33)-1:0] pf_lut_dir_cq_ai_data_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_dir_cq_ai_data (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_dir_cq_ai_data_re)
        ,.func_mem_raddr      (func_lut_dir_cq_ai_data_raddr)
        ,.func_mem_waddr      (func_lut_dir_cq_ai_data_waddr)
        ,.func_mem_we         (func_lut_dir_cq_ai_data_we)
        ,.func_mem_wdata      (func_lut_dir_cq_ai_data_wdata)
        ,.func_mem_rdata      (func_lut_dir_cq_ai_data_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_dir_cq_ai_data_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_dir_cq_ai_data_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_dir_cq_ai_data_rdata_nc)

        ,.mem_wclk            (rf_lut_dir_cq_ai_data_wclk)
        ,.mem_rclk            (rf_lut_dir_cq_ai_data_rclk)
        ,.mem_wclk_rst_n      (rf_lut_dir_cq_ai_data_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_dir_cq_ai_data_rclk_rst_n)
        ,.mem_re              (rf_lut_dir_cq_ai_data_re)
        ,.mem_raddr           (rf_lut_dir_cq_ai_data_raddr)
        ,.mem_waddr           (rf_lut_dir_cq_ai_data_waddr)
        ,.mem_we              (rf_lut_dir_cq_ai_data_we)
        ,.mem_wdata           (rf_lut_dir_cq_ai_data_wdata)
        ,.mem_rdata           (rf_lut_dir_cq_ai_data_rdata)

        ,.mem_rdata_error     (rf_lut_dir_cq_ai_data_rdata_error)
        ,.error               (rf_lut_dir_cq_ai_data_error_nc)
);

logic        rf_lut_dir_cq_isr_rdata_error;

logic        cfg_mem_ack_lut_dir_cq_isr_nc;
logic [31:0] cfg_mem_rdata_lut_dir_cq_isr_nc;

logic        rf_lut_dir_cq_isr_error_nc;
logic [(13)-1:0] pf_lut_dir_cq_isr_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_dir_cq_isr (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_dir_cq_isr_re)
        ,.func_mem_raddr      (func_lut_dir_cq_isr_raddr)
        ,.func_mem_waddr      (func_lut_dir_cq_isr_waddr)
        ,.func_mem_we         (func_lut_dir_cq_isr_we)
        ,.func_mem_wdata      (func_lut_dir_cq_isr_wdata)
        ,.func_mem_rdata      (func_lut_dir_cq_isr_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_dir_cq_isr_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_dir_cq_isr_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_dir_cq_isr_rdata_nc)

        ,.mem_wclk            (rf_lut_dir_cq_isr_wclk)
        ,.mem_rclk            (rf_lut_dir_cq_isr_rclk)
        ,.mem_wclk_rst_n      (rf_lut_dir_cq_isr_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_dir_cq_isr_rclk_rst_n)
        ,.mem_re              (rf_lut_dir_cq_isr_re)
        ,.mem_raddr           (rf_lut_dir_cq_isr_raddr)
        ,.mem_waddr           (rf_lut_dir_cq_isr_waddr)
        ,.mem_we              (rf_lut_dir_cq_isr_we)
        ,.mem_wdata           (rf_lut_dir_cq_isr_wdata)
        ,.mem_rdata           (rf_lut_dir_cq_isr_rdata)

        ,.mem_rdata_error     (rf_lut_dir_cq_isr_rdata_error)
        ,.error               (rf_lut_dir_cq_isr_error_nc)
);

logic        rf_lut_dir_cq_pasid_rdata_error;

logic        cfg_mem_ack_lut_dir_cq_pasid_nc;
logic [31:0] cfg_mem_rdata_lut_dir_cq_pasid_nc;

logic        rf_lut_dir_cq_pasid_error_nc;
logic [(24)-1:0] pf_lut_dir_cq_pasid_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (24)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_dir_cq_pasid (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_dir_cq_pasid_re)
        ,.func_mem_raddr      (func_lut_dir_cq_pasid_raddr)
        ,.func_mem_waddr      (func_lut_dir_cq_pasid_waddr)
        ,.func_mem_we         (func_lut_dir_cq_pasid_we)
        ,.func_mem_wdata      (func_lut_dir_cq_pasid_wdata)
        ,.func_mem_rdata      (func_lut_dir_cq_pasid_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_dir_cq_pasid_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_dir_cq_pasid_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_dir_cq_pasid_rdata_nc)

        ,.mem_wclk            (rf_lut_dir_cq_pasid_wclk)
        ,.mem_rclk            (rf_lut_dir_cq_pasid_rclk)
        ,.mem_wclk_rst_n      (rf_lut_dir_cq_pasid_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_dir_cq_pasid_rclk_rst_n)
        ,.mem_re              (rf_lut_dir_cq_pasid_re)
        ,.mem_raddr           (rf_lut_dir_cq_pasid_raddr)
        ,.mem_waddr           (rf_lut_dir_cq_pasid_waddr)
        ,.mem_we              (rf_lut_dir_cq_pasid_we)
        ,.mem_wdata           (rf_lut_dir_cq_pasid_wdata)
        ,.mem_rdata           (rf_lut_dir_cq_pasid_rdata)

        ,.mem_rdata_error     (rf_lut_dir_cq_pasid_rdata_error)
        ,.error               (rf_lut_dir_cq_pasid_error_nc)
);

logic        rf_lut_dir_pp2vas_rdata_error;

logic        cfg_mem_ack_lut_dir_pp2vas_nc;
logic [31:0] cfg_mem_rdata_lut_dir_pp2vas_nc;

logic        rf_lut_dir_pp2vas_error_nc;
logic [(11)-1:0] pf_lut_dir_pp2vas_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (11)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_dir_pp2vas (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_dir_pp2vas_re)
        ,.func_mem_raddr      (func_lut_dir_pp2vas_raddr)
        ,.func_mem_waddr      (func_lut_dir_pp2vas_waddr)
        ,.func_mem_we         (func_lut_dir_pp2vas_we)
        ,.func_mem_wdata      (func_lut_dir_pp2vas_wdata)
        ,.func_mem_rdata      (func_lut_dir_pp2vas_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_dir_pp2vas_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_dir_pp2vas_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_dir_pp2vas_rdata_nc)

        ,.mem_wclk            (rf_lut_dir_pp2vas_wclk)
        ,.mem_rclk            (rf_lut_dir_pp2vas_rclk)
        ,.mem_wclk_rst_n      (rf_lut_dir_pp2vas_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_dir_pp2vas_rclk_rst_n)
        ,.mem_re              (rf_lut_dir_pp2vas_re)
        ,.mem_raddr           (rf_lut_dir_pp2vas_raddr)
        ,.mem_waddr           (rf_lut_dir_pp2vas_waddr)
        ,.mem_we              (rf_lut_dir_pp2vas_we)
        ,.mem_wdata           (rf_lut_dir_pp2vas_wdata)
        ,.mem_rdata           (rf_lut_dir_pp2vas_rdata)

        ,.mem_rdata_error     (rf_lut_dir_pp2vas_rdata_error)
        ,.error               (rf_lut_dir_pp2vas_error_nc)
);

logic        rf_lut_dir_pp_v_rdata_error;

logic        cfg_mem_ack_lut_dir_pp_v_nc;
logic [31:0] cfg_mem_rdata_lut_dir_pp_v_nc;

logic        rf_lut_dir_pp_v_error_nc;
logic [(17)-1:0] pf_lut_dir_pp_v_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_dir_pp_v (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_dir_pp_v_re)
        ,.func_mem_raddr      (func_lut_dir_pp_v_raddr)
        ,.func_mem_waddr      (func_lut_dir_pp_v_waddr)
        ,.func_mem_we         (func_lut_dir_pp_v_we)
        ,.func_mem_wdata      (func_lut_dir_pp_v_wdata)
        ,.func_mem_rdata      (func_lut_dir_pp_v_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_dir_pp_v_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_dir_pp_v_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_dir_pp_v_rdata_nc)

        ,.mem_wclk            (rf_lut_dir_pp_v_wclk)
        ,.mem_rclk            (rf_lut_dir_pp_v_rclk)
        ,.mem_wclk_rst_n      (rf_lut_dir_pp_v_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_dir_pp_v_rclk_rst_n)
        ,.mem_re              (rf_lut_dir_pp_v_re)
        ,.mem_raddr           (rf_lut_dir_pp_v_raddr)
        ,.mem_waddr           (rf_lut_dir_pp_v_waddr)
        ,.mem_we              (rf_lut_dir_pp_v_we)
        ,.mem_wdata           (rf_lut_dir_pp_v_wdata)
        ,.mem_rdata           (rf_lut_dir_pp_v_rdata)

        ,.mem_rdata_error     (rf_lut_dir_pp_v_rdata_error)
        ,.error               (rf_lut_dir_pp_v_error_nc)
);

logic        rf_lut_dir_vasqid_v_rdata_error;

logic        cfg_mem_ack_lut_dir_vasqid_v_nc;
logic [31:0] cfg_mem_rdata_lut_dir_vasqid_v_nc;

logic        rf_lut_dir_vasqid_v_error_nc;
logic [(33)-1:0] pf_lut_dir_vasqid_v_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_dir_vasqid_v (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_dir_vasqid_v_re)
        ,.func_mem_raddr      (func_lut_dir_vasqid_v_raddr)
        ,.func_mem_waddr      (func_lut_dir_vasqid_v_waddr)
        ,.func_mem_we         (func_lut_dir_vasqid_v_we)
        ,.func_mem_wdata      (func_lut_dir_vasqid_v_wdata)
        ,.func_mem_rdata      (func_lut_dir_vasqid_v_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_dir_vasqid_v_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_dir_vasqid_v_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_dir_vasqid_v_rdata_nc)

        ,.mem_wclk            (rf_lut_dir_vasqid_v_wclk)
        ,.mem_rclk            (rf_lut_dir_vasqid_v_rclk)
        ,.mem_wclk_rst_n      (rf_lut_dir_vasqid_v_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_dir_vasqid_v_rclk_rst_n)
        ,.mem_re              (rf_lut_dir_vasqid_v_re)
        ,.mem_raddr           (rf_lut_dir_vasqid_v_raddr)
        ,.mem_waddr           (rf_lut_dir_vasqid_v_waddr)
        ,.mem_we              (rf_lut_dir_vasqid_v_we)
        ,.mem_wdata           (rf_lut_dir_vasqid_v_wdata)
        ,.mem_rdata           (rf_lut_dir_vasqid_v_rdata)

        ,.mem_rdata_error     (rf_lut_dir_vasqid_v_rdata_error)
        ,.error               (rf_lut_dir_vasqid_v_error_nc)
);

logic        rf_lut_ldb_cq2vf_pf_ro_rdata_error;

logic        cfg_mem_ack_lut_ldb_cq2vf_pf_ro_nc;
logic [31:0] cfg_mem_rdata_lut_ldb_cq2vf_pf_ro_nc;

logic        rf_lut_ldb_cq2vf_pf_ro_error_nc;
logic [(13)-1:0] pf_lut_ldb_cq2vf_pf_ro_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_ldb_cq2vf_pf_ro (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_ldb_cq2vf_pf_ro_re)
        ,.func_mem_raddr      (func_lut_ldb_cq2vf_pf_ro_raddr)
        ,.func_mem_waddr      (func_lut_ldb_cq2vf_pf_ro_waddr)
        ,.func_mem_we         (func_lut_ldb_cq2vf_pf_ro_we)
        ,.func_mem_wdata      (func_lut_ldb_cq2vf_pf_ro_wdata)
        ,.func_mem_rdata      (func_lut_ldb_cq2vf_pf_ro_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_ldb_cq2vf_pf_ro_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_ldb_cq2vf_pf_ro_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_ldb_cq2vf_pf_ro_rdata_nc)

        ,.mem_wclk            (rf_lut_ldb_cq2vf_pf_ro_wclk)
        ,.mem_rclk            (rf_lut_ldb_cq2vf_pf_ro_rclk)
        ,.mem_wclk_rst_n      (rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n)
        ,.mem_re              (rf_lut_ldb_cq2vf_pf_ro_re)
        ,.mem_raddr           (rf_lut_ldb_cq2vf_pf_ro_raddr)
        ,.mem_waddr           (rf_lut_ldb_cq2vf_pf_ro_waddr)
        ,.mem_we              (rf_lut_ldb_cq2vf_pf_ro_we)
        ,.mem_wdata           (rf_lut_ldb_cq2vf_pf_ro_wdata)
        ,.mem_rdata           (rf_lut_ldb_cq2vf_pf_ro_rdata)

        ,.mem_rdata_error     (rf_lut_ldb_cq2vf_pf_ro_rdata_error)
        ,.error               (rf_lut_ldb_cq2vf_pf_ro_error_nc)
);

logic        rf_lut_ldb_cq_addr_l_rdata_error;

logic        cfg_mem_ack_lut_ldb_cq_addr_l_nc;
logic [31:0] cfg_mem_rdata_lut_ldb_cq_addr_l_nc;

logic        rf_lut_ldb_cq_addr_l_error_nc;
logic [(27)-1:0] pf_lut_ldb_cq_addr_l_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (27)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_ldb_cq_addr_l (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_ldb_cq_addr_l_re)
        ,.func_mem_raddr      (func_lut_ldb_cq_addr_l_raddr)
        ,.func_mem_waddr      (func_lut_ldb_cq_addr_l_waddr)
        ,.func_mem_we         (func_lut_ldb_cq_addr_l_we)
        ,.func_mem_wdata      (func_lut_ldb_cq_addr_l_wdata)
        ,.func_mem_rdata      (func_lut_ldb_cq_addr_l_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_ldb_cq_addr_l_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_ldb_cq_addr_l_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_ldb_cq_addr_l_rdata_nc)

        ,.mem_wclk            (rf_lut_ldb_cq_addr_l_wclk)
        ,.mem_rclk            (rf_lut_ldb_cq_addr_l_rclk)
        ,.mem_wclk_rst_n      (rf_lut_ldb_cq_addr_l_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_ldb_cq_addr_l_rclk_rst_n)
        ,.mem_re              (rf_lut_ldb_cq_addr_l_re)
        ,.mem_raddr           (rf_lut_ldb_cq_addr_l_raddr)
        ,.mem_waddr           (rf_lut_ldb_cq_addr_l_waddr)
        ,.mem_we              (rf_lut_ldb_cq_addr_l_we)
        ,.mem_wdata           (rf_lut_ldb_cq_addr_l_wdata)
        ,.mem_rdata           (rf_lut_ldb_cq_addr_l_rdata)

        ,.mem_rdata_error     (rf_lut_ldb_cq_addr_l_rdata_error)
        ,.error               (rf_lut_ldb_cq_addr_l_error_nc)
);

logic        rf_lut_ldb_cq_addr_u_rdata_error;

logic        cfg_mem_ack_lut_ldb_cq_addr_u_nc;
logic [31:0] cfg_mem_rdata_lut_ldb_cq_addr_u_nc;

logic        rf_lut_ldb_cq_addr_u_error_nc;
logic [(33)-1:0] pf_lut_ldb_cq_addr_u_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_ldb_cq_addr_u (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_ldb_cq_addr_u_re)
        ,.func_mem_raddr      (func_lut_ldb_cq_addr_u_raddr)
        ,.func_mem_waddr      (func_lut_ldb_cq_addr_u_waddr)
        ,.func_mem_we         (func_lut_ldb_cq_addr_u_we)
        ,.func_mem_wdata      (func_lut_ldb_cq_addr_u_wdata)
        ,.func_mem_rdata      (func_lut_ldb_cq_addr_u_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_ldb_cq_addr_u_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_ldb_cq_addr_u_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_ldb_cq_addr_u_rdata_nc)

        ,.mem_wclk            (rf_lut_ldb_cq_addr_u_wclk)
        ,.mem_rclk            (rf_lut_ldb_cq_addr_u_rclk)
        ,.mem_wclk_rst_n      (rf_lut_ldb_cq_addr_u_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_ldb_cq_addr_u_rclk_rst_n)
        ,.mem_re              (rf_lut_ldb_cq_addr_u_re)
        ,.mem_raddr           (rf_lut_ldb_cq_addr_u_raddr)
        ,.mem_waddr           (rf_lut_ldb_cq_addr_u_waddr)
        ,.mem_we              (rf_lut_ldb_cq_addr_u_we)
        ,.mem_wdata           (rf_lut_ldb_cq_addr_u_wdata)
        ,.mem_rdata           (rf_lut_ldb_cq_addr_u_rdata)

        ,.mem_rdata_error     (rf_lut_ldb_cq_addr_u_rdata_error)
        ,.error               (rf_lut_ldb_cq_addr_u_error_nc)
);

logic        rf_lut_ldb_cq_ai_addr_l_rdata_error;

logic        cfg_mem_ack_lut_ldb_cq_ai_addr_l_nc;
logic [31:0] cfg_mem_rdata_lut_ldb_cq_ai_addr_l_nc;

logic        rf_lut_ldb_cq_ai_addr_l_error_nc;
logic [(31)-1:0] pf_lut_ldb_cq_ai_addr_l_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (31)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_ldb_cq_ai_addr_l (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_ldb_cq_ai_addr_l_re)
        ,.func_mem_raddr      (func_lut_ldb_cq_ai_addr_l_raddr)
        ,.func_mem_waddr      (func_lut_ldb_cq_ai_addr_l_waddr)
        ,.func_mem_we         (func_lut_ldb_cq_ai_addr_l_we)
        ,.func_mem_wdata      (func_lut_ldb_cq_ai_addr_l_wdata)
        ,.func_mem_rdata      (func_lut_ldb_cq_ai_addr_l_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_ldb_cq_ai_addr_l_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_ldb_cq_ai_addr_l_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_ldb_cq_ai_addr_l_rdata_nc)

        ,.mem_wclk            (rf_lut_ldb_cq_ai_addr_l_wclk)
        ,.mem_rclk            (rf_lut_ldb_cq_ai_addr_l_rclk)
        ,.mem_wclk_rst_n      (rf_lut_ldb_cq_ai_addr_l_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_ldb_cq_ai_addr_l_rclk_rst_n)
        ,.mem_re              (rf_lut_ldb_cq_ai_addr_l_re)
        ,.mem_raddr           (rf_lut_ldb_cq_ai_addr_l_raddr)
        ,.mem_waddr           (rf_lut_ldb_cq_ai_addr_l_waddr)
        ,.mem_we              (rf_lut_ldb_cq_ai_addr_l_we)
        ,.mem_wdata           (rf_lut_ldb_cq_ai_addr_l_wdata)
        ,.mem_rdata           (rf_lut_ldb_cq_ai_addr_l_rdata)

        ,.mem_rdata_error     (rf_lut_ldb_cq_ai_addr_l_rdata_error)
        ,.error               (rf_lut_ldb_cq_ai_addr_l_error_nc)
);

logic        rf_lut_ldb_cq_ai_addr_u_rdata_error;

logic        cfg_mem_ack_lut_ldb_cq_ai_addr_u_nc;
logic [31:0] cfg_mem_rdata_lut_ldb_cq_ai_addr_u_nc;

logic        rf_lut_ldb_cq_ai_addr_u_error_nc;
logic [(33)-1:0] pf_lut_ldb_cq_ai_addr_u_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_ldb_cq_ai_addr_u (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_ldb_cq_ai_addr_u_re)
        ,.func_mem_raddr      (func_lut_ldb_cq_ai_addr_u_raddr)
        ,.func_mem_waddr      (func_lut_ldb_cq_ai_addr_u_waddr)
        ,.func_mem_we         (func_lut_ldb_cq_ai_addr_u_we)
        ,.func_mem_wdata      (func_lut_ldb_cq_ai_addr_u_wdata)
        ,.func_mem_rdata      (func_lut_ldb_cq_ai_addr_u_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_ldb_cq_ai_addr_u_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_ldb_cq_ai_addr_u_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_ldb_cq_ai_addr_u_rdata_nc)

        ,.mem_wclk            (rf_lut_ldb_cq_ai_addr_u_wclk)
        ,.mem_rclk            (rf_lut_ldb_cq_ai_addr_u_rclk)
        ,.mem_wclk_rst_n      (rf_lut_ldb_cq_ai_addr_u_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_ldb_cq_ai_addr_u_rclk_rst_n)
        ,.mem_re              (rf_lut_ldb_cq_ai_addr_u_re)
        ,.mem_raddr           (rf_lut_ldb_cq_ai_addr_u_raddr)
        ,.mem_waddr           (rf_lut_ldb_cq_ai_addr_u_waddr)
        ,.mem_we              (rf_lut_ldb_cq_ai_addr_u_we)
        ,.mem_wdata           (rf_lut_ldb_cq_ai_addr_u_wdata)
        ,.mem_rdata           (rf_lut_ldb_cq_ai_addr_u_rdata)

        ,.mem_rdata_error     (rf_lut_ldb_cq_ai_addr_u_rdata_error)
        ,.error               (rf_lut_ldb_cq_ai_addr_u_error_nc)
);

logic        rf_lut_ldb_cq_ai_data_rdata_error;

logic        cfg_mem_ack_lut_ldb_cq_ai_data_nc;
logic [31:0] cfg_mem_rdata_lut_ldb_cq_ai_data_nc;

logic        rf_lut_ldb_cq_ai_data_error_nc;
logic [(33)-1:0] pf_lut_ldb_cq_ai_data_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_ldb_cq_ai_data (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_ldb_cq_ai_data_re)
        ,.func_mem_raddr      (func_lut_ldb_cq_ai_data_raddr)
        ,.func_mem_waddr      (func_lut_ldb_cq_ai_data_waddr)
        ,.func_mem_we         (func_lut_ldb_cq_ai_data_we)
        ,.func_mem_wdata      (func_lut_ldb_cq_ai_data_wdata)
        ,.func_mem_rdata      (func_lut_ldb_cq_ai_data_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_ldb_cq_ai_data_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_ldb_cq_ai_data_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_ldb_cq_ai_data_rdata_nc)

        ,.mem_wclk            (rf_lut_ldb_cq_ai_data_wclk)
        ,.mem_rclk            (rf_lut_ldb_cq_ai_data_rclk)
        ,.mem_wclk_rst_n      (rf_lut_ldb_cq_ai_data_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_ldb_cq_ai_data_rclk_rst_n)
        ,.mem_re              (rf_lut_ldb_cq_ai_data_re)
        ,.mem_raddr           (rf_lut_ldb_cq_ai_data_raddr)
        ,.mem_waddr           (rf_lut_ldb_cq_ai_data_waddr)
        ,.mem_we              (rf_lut_ldb_cq_ai_data_we)
        ,.mem_wdata           (rf_lut_ldb_cq_ai_data_wdata)
        ,.mem_rdata           (rf_lut_ldb_cq_ai_data_rdata)

        ,.mem_rdata_error     (rf_lut_ldb_cq_ai_data_rdata_error)
        ,.error               (rf_lut_ldb_cq_ai_data_error_nc)
);

logic        rf_lut_ldb_cq_isr_rdata_error;

logic        cfg_mem_ack_lut_ldb_cq_isr_nc;
logic [31:0] cfg_mem_rdata_lut_ldb_cq_isr_nc;

logic        rf_lut_ldb_cq_isr_error_nc;
logic [(13)-1:0] pf_lut_ldb_cq_isr_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_ldb_cq_isr (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_ldb_cq_isr_re)
        ,.func_mem_raddr      (func_lut_ldb_cq_isr_raddr)
        ,.func_mem_waddr      (func_lut_ldb_cq_isr_waddr)
        ,.func_mem_we         (func_lut_ldb_cq_isr_we)
        ,.func_mem_wdata      (func_lut_ldb_cq_isr_wdata)
        ,.func_mem_rdata      (func_lut_ldb_cq_isr_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_ldb_cq_isr_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_ldb_cq_isr_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_ldb_cq_isr_rdata_nc)

        ,.mem_wclk            (rf_lut_ldb_cq_isr_wclk)
        ,.mem_rclk            (rf_lut_ldb_cq_isr_rclk)
        ,.mem_wclk_rst_n      (rf_lut_ldb_cq_isr_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_ldb_cq_isr_rclk_rst_n)
        ,.mem_re              (rf_lut_ldb_cq_isr_re)
        ,.mem_raddr           (rf_lut_ldb_cq_isr_raddr)
        ,.mem_waddr           (rf_lut_ldb_cq_isr_waddr)
        ,.mem_we              (rf_lut_ldb_cq_isr_we)
        ,.mem_wdata           (rf_lut_ldb_cq_isr_wdata)
        ,.mem_rdata           (rf_lut_ldb_cq_isr_rdata)

        ,.mem_rdata_error     (rf_lut_ldb_cq_isr_rdata_error)
        ,.error               (rf_lut_ldb_cq_isr_error_nc)
);

logic        rf_lut_ldb_cq_pasid_rdata_error;

logic        cfg_mem_ack_lut_ldb_cq_pasid_nc;
logic [31:0] cfg_mem_rdata_lut_ldb_cq_pasid_nc;

logic        rf_lut_ldb_cq_pasid_error_nc;
logic [(24)-1:0] pf_lut_ldb_cq_pasid_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (24)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_ldb_cq_pasid (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_ldb_cq_pasid_re)
        ,.func_mem_raddr      (func_lut_ldb_cq_pasid_raddr)
        ,.func_mem_waddr      (func_lut_ldb_cq_pasid_waddr)
        ,.func_mem_we         (func_lut_ldb_cq_pasid_we)
        ,.func_mem_wdata      (func_lut_ldb_cq_pasid_wdata)
        ,.func_mem_rdata      (func_lut_ldb_cq_pasid_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_ldb_cq_pasid_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_ldb_cq_pasid_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_ldb_cq_pasid_rdata_nc)

        ,.mem_wclk            (rf_lut_ldb_cq_pasid_wclk)
        ,.mem_rclk            (rf_lut_ldb_cq_pasid_rclk)
        ,.mem_wclk_rst_n      (rf_lut_ldb_cq_pasid_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_ldb_cq_pasid_rclk_rst_n)
        ,.mem_re              (rf_lut_ldb_cq_pasid_re)
        ,.mem_raddr           (rf_lut_ldb_cq_pasid_raddr)
        ,.mem_waddr           (rf_lut_ldb_cq_pasid_waddr)
        ,.mem_we              (rf_lut_ldb_cq_pasid_we)
        ,.mem_wdata           (rf_lut_ldb_cq_pasid_wdata)
        ,.mem_rdata           (rf_lut_ldb_cq_pasid_rdata)

        ,.mem_rdata_error     (rf_lut_ldb_cq_pasid_rdata_error)
        ,.error               (rf_lut_ldb_cq_pasid_error_nc)
);

logic        rf_lut_ldb_pp2vas_rdata_error;

logic        cfg_mem_ack_lut_ldb_pp2vas_nc;
logic [31:0] cfg_mem_rdata_lut_ldb_pp2vas_nc;

logic        rf_lut_ldb_pp2vas_error_nc;
logic [(11)-1:0] pf_lut_ldb_pp2vas_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (11)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_ldb_pp2vas (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_ldb_pp2vas_re)
        ,.func_mem_raddr      (func_lut_ldb_pp2vas_raddr)
        ,.func_mem_waddr      (func_lut_ldb_pp2vas_waddr)
        ,.func_mem_we         (func_lut_ldb_pp2vas_we)
        ,.func_mem_wdata      (func_lut_ldb_pp2vas_wdata)
        ,.func_mem_rdata      (func_lut_ldb_pp2vas_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_ldb_pp2vas_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_ldb_pp2vas_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_ldb_pp2vas_rdata_nc)

        ,.mem_wclk            (rf_lut_ldb_pp2vas_wclk)
        ,.mem_rclk            (rf_lut_ldb_pp2vas_rclk)
        ,.mem_wclk_rst_n      (rf_lut_ldb_pp2vas_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_ldb_pp2vas_rclk_rst_n)
        ,.mem_re              (rf_lut_ldb_pp2vas_re)
        ,.mem_raddr           (rf_lut_ldb_pp2vas_raddr)
        ,.mem_waddr           (rf_lut_ldb_pp2vas_waddr)
        ,.mem_we              (rf_lut_ldb_pp2vas_we)
        ,.mem_wdata           (rf_lut_ldb_pp2vas_wdata)
        ,.mem_rdata           (rf_lut_ldb_pp2vas_rdata)

        ,.mem_rdata_error     (rf_lut_ldb_pp2vas_rdata_error)
        ,.error               (rf_lut_ldb_pp2vas_error_nc)
);

logic        rf_lut_ldb_qid2vqid_rdata_error;

logic        cfg_mem_ack_lut_ldb_qid2vqid_nc;
logic [31:0] cfg_mem_rdata_lut_ldb_qid2vqid_nc;

logic        rf_lut_ldb_qid2vqid_error_nc;
logic [(21)-1:0] pf_lut_ldb_qid2vqid_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (21)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_ldb_qid2vqid (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_ldb_qid2vqid_re)
        ,.func_mem_raddr      (func_lut_ldb_qid2vqid_raddr)
        ,.func_mem_waddr      (func_lut_ldb_qid2vqid_waddr)
        ,.func_mem_we         (func_lut_ldb_qid2vqid_we)
        ,.func_mem_wdata      (func_lut_ldb_qid2vqid_wdata)
        ,.func_mem_rdata      (func_lut_ldb_qid2vqid_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_ldb_qid2vqid_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_ldb_qid2vqid_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_ldb_qid2vqid_rdata_nc)

        ,.mem_wclk            (rf_lut_ldb_qid2vqid_wclk)
        ,.mem_rclk            (rf_lut_ldb_qid2vqid_rclk)
        ,.mem_wclk_rst_n      (rf_lut_ldb_qid2vqid_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_ldb_qid2vqid_rclk_rst_n)
        ,.mem_re              (rf_lut_ldb_qid2vqid_re)
        ,.mem_raddr           (rf_lut_ldb_qid2vqid_raddr)
        ,.mem_waddr           (rf_lut_ldb_qid2vqid_waddr)
        ,.mem_we              (rf_lut_ldb_qid2vqid_we)
        ,.mem_wdata           (rf_lut_ldb_qid2vqid_wdata)
        ,.mem_rdata           (rf_lut_ldb_qid2vqid_rdata)

        ,.mem_rdata_error     (rf_lut_ldb_qid2vqid_rdata_error)
        ,.error               (rf_lut_ldb_qid2vqid_error_nc)
);

logic        rf_lut_ldb_vasqid_v_rdata_error;

logic        cfg_mem_ack_lut_ldb_vasqid_v_nc;
logic [31:0] cfg_mem_rdata_lut_ldb_vasqid_v_nc;

logic        rf_lut_ldb_vasqid_v_error_nc;
logic [(17)-1:0] pf_lut_ldb_vasqid_v_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_ldb_vasqid_v (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_ldb_vasqid_v_re)
        ,.func_mem_raddr      (func_lut_ldb_vasqid_v_raddr)
        ,.func_mem_waddr      (func_lut_ldb_vasqid_v_waddr)
        ,.func_mem_we         (func_lut_ldb_vasqid_v_we)
        ,.func_mem_wdata      (func_lut_ldb_vasqid_v_wdata)
        ,.func_mem_rdata      (func_lut_ldb_vasqid_v_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_ldb_vasqid_v_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_ldb_vasqid_v_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_ldb_vasqid_v_rdata_nc)

        ,.mem_wclk            (rf_lut_ldb_vasqid_v_wclk)
        ,.mem_rclk            (rf_lut_ldb_vasqid_v_rclk)
        ,.mem_wclk_rst_n      (rf_lut_ldb_vasqid_v_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_ldb_vasqid_v_rclk_rst_n)
        ,.mem_re              (rf_lut_ldb_vasqid_v_re)
        ,.mem_raddr           (rf_lut_ldb_vasqid_v_raddr)
        ,.mem_waddr           (rf_lut_ldb_vasqid_v_waddr)
        ,.mem_we              (rf_lut_ldb_vasqid_v_we)
        ,.mem_wdata           (rf_lut_ldb_vasqid_v_wdata)
        ,.mem_rdata           (rf_lut_ldb_vasqid_v_rdata)

        ,.mem_rdata_error     (rf_lut_ldb_vasqid_v_rdata_error)
        ,.error               (rf_lut_ldb_vasqid_v_error_nc)
);

logic        rf_lut_vf_dir_vpp2pp_rdata_error;

logic        cfg_mem_ack_lut_vf_dir_vpp2pp_nc;
logic [31:0] cfg_mem_rdata_lut_vf_dir_vpp2pp_nc;

logic        rf_lut_vf_dir_vpp2pp_error_nc;
logic [(31)-1:0] pf_lut_vf_dir_vpp2pp_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (31)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_vf_dir_vpp2pp (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_vf_dir_vpp2pp_re)
        ,.func_mem_raddr      (func_lut_vf_dir_vpp2pp_raddr)
        ,.func_mem_waddr      (func_lut_vf_dir_vpp2pp_waddr)
        ,.func_mem_we         (func_lut_vf_dir_vpp2pp_we)
        ,.func_mem_wdata      (func_lut_vf_dir_vpp2pp_wdata)
        ,.func_mem_rdata      (func_lut_vf_dir_vpp2pp_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_vf_dir_vpp2pp_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_vf_dir_vpp2pp_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_vf_dir_vpp2pp_rdata_nc)

        ,.mem_wclk            (rf_lut_vf_dir_vpp2pp_wclk)
        ,.mem_rclk            (rf_lut_vf_dir_vpp2pp_rclk)
        ,.mem_wclk_rst_n      (rf_lut_vf_dir_vpp2pp_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_vf_dir_vpp2pp_rclk_rst_n)
        ,.mem_re              (rf_lut_vf_dir_vpp2pp_re)
        ,.mem_raddr           (rf_lut_vf_dir_vpp2pp_raddr)
        ,.mem_waddr           (rf_lut_vf_dir_vpp2pp_waddr)
        ,.mem_we              (rf_lut_vf_dir_vpp2pp_we)
        ,.mem_wdata           (rf_lut_vf_dir_vpp2pp_wdata)
        ,.mem_rdata           (rf_lut_vf_dir_vpp2pp_rdata)

        ,.mem_rdata_error     (rf_lut_vf_dir_vpp2pp_rdata_error)
        ,.error               (rf_lut_vf_dir_vpp2pp_error_nc)
);

logic        rf_lut_vf_dir_vpp_v_rdata_error;

logic        cfg_mem_ack_lut_vf_dir_vpp_v_nc;
logic [31:0] cfg_mem_rdata_lut_vf_dir_vpp_v_nc;

logic        rf_lut_vf_dir_vpp_v_error_nc;
logic [(17)-1:0] pf_lut_vf_dir_vpp_v_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_vf_dir_vpp_v (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_vf_dir_vpp_v_re)
        ,.func_mem_raddr      (func_lut_vf_dir_vpp_v_raddr)
        ,.func_mem_waddr      (func_lut_vf_dir_vpp_v_waddr)
        ,.func_mem_we         (func_lut_vf_dir_vpp_v_we)
        ,.func_mem_wdata      (func_lut_vf_dir_vpp_v_wdata)
        ,.func_mem_rdata      (func_lut_vf_dir_vpp_v_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_vf_dir_vpp_v_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_vf_dir_vpp_v_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_vf_dir_vpp_v_rdata_nc)

        ,.mem_wclk            (rf_lut_vf_dir_vpp_v_wclk)
        ,.mem_rclk            (rf_lut_vf_dir_vpp_v_rclk)
        ,.mem_wclk_rst_n      (rf_lut_vf_dir_vpp_v_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_vf_dir_vpp_v_rclk_rst_n)
        ,.mem_re              (rf_lut_vf_dir_vpp_v_re)
        ,.mem_raddr           (rf_lut_vf_dir_vpp_v_raddr)
        ,.mem_waddr           (rf_lut_vf_dir_vpp_v_waddr)
        ,.mem_we              (rf_lut_vf_dir_vpp_v_we)
        ,.mem_wdata           (rf_lut_vf_dir_vpp_v_wdata)
        ,.mem_rdata           (rf_lut_vf_dir_vpp_v_rdata)

        ,.mem_rdata_error     (rf_lut_vf_dir_vpp_v_rdata_error)
        ,.error               (rf_lut_vf_dir_vpp_v_error_nc)
);

logic        rf_lut_vf_dir_vqid2qid_rdata_error;

logic        cfg_mem_ack_lut_vf_dir_vqid2qid_nc;
logic [31:0] cfg_mem_rdata_lut_vf_dir_vqid2qid_nc;

logic        rf_lut_vf_dir_vqid2qid_error_nc;
logic [(31)-1:0] pf_lut_vf_dir_vqid2qid_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (31)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_vf_dir_vqid2qid (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_vf_dir_vqid2qid_re)
        ,.func_mem_raddr      (func_lut_vf_dir_vqid2qid_raddr)
        ,.func_mem_waddr      (func_lut_vf_dir_vqid2qid_waddr)
        ,.func_mem_we         (func_lut_vf_dir_vqid2qid_we)
        ,.func_mem_wdata      (func_lut_vf_dir_vqid2qid_wdata)
        ,.func_mem_rdata      (func_lut_vf_dir_vqid2qid_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_vf_dir_vqid2qid_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_vf_dir_vqid2qid_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_vf_dir_vqid2qid_rdata_nc)

        ,.mem_wclk            (rf_lut_vf_dir_vqid2qid_wclk)
        ,.mem_rclk            (rf_lut_vf_dir_vqid2qid_rclk)
        ,.mem_wclk_rst_n      (rf_lut_vf_dir_vqid2qid_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_vf_dir_vqid2qid_rclk_rst_n)
        ,.mem_re              (rf_lut_vf_dir_vqid2qid_re)
        ,.mem_raddr           (rf_lut_vf_dir_vqid2qid_raddr)
        ,.mem_waddr           (rf_lut_vf_dir_vqid2qid_waddr)
        ,.mem_we              (rf_lut_vf_dir_vqid2qid_we)
        ,.mem_wdata           (rf_lut_vf_dir_vqid2qid_wdata)
        ,.mem_rdata           (rf_lut_vf_dir_vqid2qid_rdata)

        ,.mem_rdata_error     (rf_lut_vf_dir_vqid2qid_rdata_error)
        ,.error               (rf_lut_vf_dir_vqid2qid_error_nc)
);

logic        rf_lut_vf_dir_vqid_v_rdata_error;

logic        cfg_mem_ack_lut_vf_dir_vqid_v_nc;
logic [31:0] cfg_mem_rdata_lut_vf_dir_vqid_v_nc;

logic        rf_lut_vf_dir_vqid_v_error_nc;
logic [(17)-1:0] pf_lut_vf_dir_vqid_v_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_vf_dir_vqid_v (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_vf_dir_vqid_v_re)
        ,.func_mem_raddr      (func_lut_vf_dir_vqid_v_raddr)
        ,.func_mem_waddr      (func_lut_vf_dir_vqid_v_waddr)
        ,.func_mem_we         (func_lut_vf_dir_vqid_v_we)
        ,.func_mem_wdata      (func_lut_vf_dir_vqid_v_wdata)
        ,.func_mem_rdata      (func_lut_vf_dir_vqid_v_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_vf_dir_vqid_v_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_vf_dir_vqid_v_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_vf_dir_vqid_v_rdata_nc)

        ,.mem_wclk            (rf_lut_vf_dir_vqid_v_wclk)
        ,.mem_rclk            (rf_lut_vf_dir_vqid_v_rclk)
        ,.mem_wclk_rst_n      (rf_lut_vf_dir_vqid_v_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_vf_dir_vqid_v_rclk_rst_n)
        ,.mem_re              (rf_lut_vf_dir_vqid_v_re)
        ,.mem_raddr           (rf_lut_vf_dir_vqid_v_raddr)
        ,.mem_waddr           (rf_lut_vf_dir_vqid_v_waddr)
        ,.mem_we              (rf_lut_vf_dir_vqid_v_we)
        ,.mem_wdata           (rf_lut_vf_dir_vqid_v_wdata)
        ,.mem_rdata           (rf_lut_vf_dir_vqid_v_rdata)

        ,.mem_rdata_error     (rf_lut_vf_dir_vqid_v_rdata_error)
        ,.error               (rf_lut_vf_dir_vqid_v_error_nc)
);

logic        rf_lut_vf_ldb_vpp2pp_rdata_error;

logic        cfg_mem_ack_lut_vf_ldb_vpp2pp_nc;
logic [31:0] cfg_mem_rdata_lut_vf_ldb_vpp2pp_nc;

logic        rf_lut_vf_ldb_vpp2pp_error_nc;
logic [(25)-1:0] pf_lut_vf_ldb_vpp2pp_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (25)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_vf_ldb_vpp2pp (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_vf_ldb_vpp2pp_re)
        ,.func_mem_raddr      (func_lut_vf_ldb_vpp2pp_raddr)
        ,.func_mem_waddr      (func_lut_vf_ldb_vpp2pp_waddr)
        ,.func_mem_we         (func_lut_vf_ldb_vpp2pp_we)
        ,.func_mem_wdata      (func_lut_vf_ldb_vpp2pp_wdata)
        ,.func_mem_rdata      (func_lut_vf_ldb_vpp2pp_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_vf_ldb_vpp2pp_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_vf_ldb_vpp2pp_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_vf_ldb_vpp2pp_rdata_nc)

        ,.mem_wclk            (rf_lut_vf_ldb_vpp2pp_wclk)
        ,.mem_rclk            (rf_lut_vf_ldb_vpp2pp_rclk)
        ,.mem_wclk_rst_n      (rf_lut_vf_ldb_vpp2pp_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_vf_ldb_vpp2pp_rclk_rst_n)
        ,.mem_re              (rf_lut_vf_ldb_vpp2pp_re)
        ,.mem_raddr           (rf_lut_vf_ldb_vpp2pp_raddr)
        ,.mem_waddr           (rf_lut_vf_ldb_vpp2pp_waddr)
        ,.mem_we              (rf_lut_vf_ldb_vpp2pp_we)
        ,.mem_wdata           (rf_lut_vf_ldb_vpp2pp_wdata)
        ,.mem_rdata           (rf_lut_vf_ldb_vpp2pp_rdata)

        ,.mem_rdata_error     (rf_lut_vf_ldb_vpp2pp_rdata_error)
        ,.error               (rf_lut_vf_ldb_vpp2pp_error_nc)
);

logic        rf_lut_vf_ldb_vpp_v_rdata_error;

logic        cfg_mem_ack_lut_vf_ldb_vpp_v_nc;
logic [31:0] cfg_mem_rdata_lut_vf_ldb_vpp_v_nc;

logic        rf_lut_vf_ldb_vpp_v_error_nc;
logic [(17)-1:0] pf_lut_vf_ldb_vpp_v_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_vf_ldb_vpp_v (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_vf_ldb_vpp_v_re)
        ,.func_mem_raddr      (func_lut_vf_ldb_vpp_v_raddr)
        ,.func_mem_waddr      (func_lut_vf_ldb_vpp_v_waddr)
        ,.func_mem_we         (func_lut_vf_ldb_vpp_v_we)
        ,.func_mem_wdata      (func_lut_vf_ldb_vpp_v_wdata)
        ,.func_mem_rdata      (func_lut_vf_ldb_vpp_v_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_vf_ldb_vpp_v_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_vf_ldb_vpp_v_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_vf_ldb_vpp_v_rdata_nc)

        ,.mem_wclk            (rf_lut_vf_ldb_vpp_v_wclk)
        ,.mem_rclk            (rf_lut_vf_ldb_vpp_v_rclk)
        ,.mem_wclk_rst_n      (rf_lut_vf_ldb_vpp_v_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_vf_ldb_vpp_v_rclk_rst_n)
        ,.mem_re              (rf_lut_vf_ldb_vpp_v_re)
        ,.mem_raddr           (rf_lut_vf_ldb_vpp_v_raddr)
        ,.mem_waddr           (rf_lut_vf_ldb_vpp_v_waddr)
        ,.mem_we              (rf_lut_vf_ldb_vpp_v_we)
        ,.mem_wdata           (rf_lut_vf_ldb_vpp_v_wdata)
        ,.mem_rdata           (rf_lut_vf_ldb_vpp_v_rdata)

        ,.mem_rdata_error     (rf_lut_vf_ldb_vpp_v_rdata_error)
        ,.error               (rf_lut_vf_ldb_vpp_v_error_nc)
);

logic        rf_lut_vf_ldb_vqid2qid_rdata_error;

logic        cfg_mem_ack_lut_vf_ldb_vqid2qid_nc;
logic [31:0] cfg_mem_rdata_lut_vf_ldb_vqid2qid_nc;

logic        rf_lut_vf_ldb_vqid2qid_error_nc;
logic [(27)-1:0] pf_lut_vf_ldb_vqid2qid_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (128)
        ,.DWIDTH              (27)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_vf_ldb_vqid2qid (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_vf_ldb_vqid2qid_re)
        ,.func_mem_raddr      (func_lut_vf_ldb_vqid2qid_raddr)
        ,.func_mem_waddr      (func_lut_vf_ldb_vqid2qid_waddr)
        ,.func_mem_we         (func_lut_vf_ldb_vqid2qid_we)
        ,.func_mem_wdata      (func_lut_vf_ldb_vqid2qid_wdata)
        ,.func_mem_rdata      (func_lut_vf_ldb_vqid2qid_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_vf_ldb_vqid2qid_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_vf_ldb_vqid2qid_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_vf_ldb_vqid2qid_rdata_nc)

        ,.mem_wclk            (rf_lut_vf_ldb_vqid2qid_wclk)
        ,.mem_rclk            (rf_lut_vf_ldb_vqid2qid_rclk)
        ,.mem_wclk_rst_n      (rf_lut_vf_ldb_vqid2qid_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_vf_ldb_vqid2qid_rclk_rst_n)
        ,.mem_re              (rf_lut_vf_ldb_vqid2qid_re)
        ,.mem_raddr           (rf_lut_vf_ldb_vqid2qid_raddr)
        ,.mem_waddr           (rf_lut_vf_ldb_vqid2qid_waddr)
        ,.mem_we              (rf_lut_vf_ldb_vqid2qid_we)
        ,.mem_wdata           (rf_lut_vf_ldb_vqid2qid_wdata)
        ,.mem_rdata           (rf_lut_vf_ldb_vqid2qid_rdata)

        ,.mem_rdata_error     (rf_lut_vf_ldb_vqid2qid_rdata_error)
        ,.error               (rf_lut_vf_ldb_vqid2qid_error_nc)
);

logic        rf_lut_vf_ldb_vqid_v_rdata_error;

logic        cfg_mem_ack_lut_vf_ldb_vqid_v_nc;
logic [31:0] cfg_mem_rdata_lut_vf_ldb_vqid_v_nc;

logic        rf_lut_vf_ldb_vqid_v_error_nc;
logic [(17)-1:0] pf_lut_vf_ldb_vqid_v_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lut_vf_ldb_vqid_v (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lut_vf_ldb_vqid_v_re)
        ,.func_mem_raddr      (func_lut_vf_ldb_vqid_v_raddr)
        ,.func_mem_waddr      (func_lut_vf_ldb_vqid_v_waddr)
        ,.func_mem_we         (func_lut_vf_ldb_vqid_v_we)
        ,.func_mem_wdata      (func_lut_vf_ldb_vqid_v_wdata)
        ,.func_mem_rdata      (func_lut_vf_ldb_vqid_v_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lut_vf_ldb_vqid_v_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lut_vf_ldb_vqid_v_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_lut_vf_ldb_vqid_v_rdata_nc)

        ,.mem_wclk            (rf_lut_vf_ldb_vqid_v_wclk)
        ,.mem_rclk            (rf_lut_vf_ldb_vqid_v_rclk)
        ,.mem_wclk_rst_n      (rf_lut_vf_ldb_vqid_v_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lut_vf_ldb_vqid_v_rclk_rst_n)
        ,.mem_re              (rf_lut_vf_ldb_vqid_v_re)
        ,.mem_raddr           (rf_lut_vf_ldb_vqid_v_raddr)
        ,.mem_waddr           (rf_lut_vf_ldb_vqid_v_waddr)
        ,.mem_we              (rf_lut_vf_ldb_vqid_v_we)
        ,.mem_wdata           (rf_lut_vf_ldb_vqid_v_wdata)
        ,.mem_rdata           (rf_lut_vf_ldb_vqid_v_rdata)

        ,.mem_rdata_error     (rf_lut_vf_ldb_vqid_v_rdata_error)
        ,.error               (rf_lut_vf_ldb_vqid_v_error_nc)
);

logic        rf_msix_tbl_word0_rdata_error;

logic        cfg_mem_ack_msix_tbl_word0_nc;
logic [31:0] cfg_mem_rdata_msix_tbl_word0_nc;

logic        rf_msix_tbl_word0_error_nc;
logic [(33)-1:0] pf_msix_tbl_word0_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_msix_tbl_word0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_msix_tbl_word0_re)
        ,.func_mem_raddr      (func_msix_tbl_word0_raddr)
        ,.func_mem_waddr      (func_msix_tbl_word0_waddr)
        ,.func_mem_we         (func_msix_tbl_word0_we)
        ,.func_mem_wdata      (func_msix_tbl_word0_wdata)
        ,.func_mem_rdata      (func_msix_tbl_word0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_msix_tbl_word0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_msix_tbl_word0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_msix_tbl_word0_rdata_nc)

        ,.mem_wclk            (rf_msix_tbl_word0_wclk)
        ,.mem_rclk            (rf_msix_tbl_word0_rclk)
        ,.mem_wclk_rst_n      (rf_msix_tbl_word0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_msix_tbl_word0_rclk_rst_n)
        ,.mem_re              (rf_msix_tbl_word0_re)
        ,.mem_raddr           (rf_msix_tbl_word0_raddr)
        ,.mem_waddr           (rf_msix_tbl_word0_waddr)
        ,.mem_we              (rf_msix_tbl_word0_we)
        ,.mem_wdata           (rf_msix_tbl_word0_wdata)
        ,.mem_rdata           (rf_msix_tbl_word0_rdata)

        ,.mem_rdata_error     (rf_msix_tbl_word0_rdata_error)
        ,.error               (rf_msix_tbl_word0_error_nc)
);

logic        rf_msix_tbl_word1_rdata_error;

logic        cfg_mem_ack_msix_tbl_word1_nc;
logic [31:0] cfg_mem_rdata_msix_tbl_word1_nc;

logic        rf_msix_tbl_word1_error_nc;
logic [(33)-1:0] pf_msix_tbl_word1_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_msix_tbl_word1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_msix_tbl_word1_re)
        ,.func_mem_raddr      (func_msix_tbl_word1_raddr)
        ,.func_mem_waddr      (func_msix_tbl_word1_waddr)
        ,.func_mem_we         (func_msix_tbl_word1_we)
        ,.func_mem_wdata      (func_msix_tbl_word1_wdata)
        ,.func_mem_rdata      (func_msix_tbl_word1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_msix_tbl_word1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_msix_tbl_word1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_msix_tbl_word1_rdata_nc)

        ,.mem_wclk            (rf_msix_tbl_word1_wclk)
        ,.mem_rclk            (rf_msix_tbl_word1_rclk)
        ,.mem_wclk_rst_n      (rf_msix_tbl_word1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_msix_tbl_word1_rclk_rst_n)
        ,.mem_re              (rf_msix_tbl_word1_re)
        ,.mem_raddr           (rf_msix_tbl_word1_raddr)
        ,.mem_waddr           (rf_msix_tbl_word1_waddr)
        ,.mem_we              (rf_msix_tbl_word1_we)
        ,.mem_wdata           (rf_msix_tbl_word1_wdata)
        ,.mem_rdata           (rf_msix_tbl_word1_rdata)

        ,.mem_rdata_error     (rf_msix_tbl_word1_rdata_error)
        ,.error               (rf_msix_tbl_word1_error_nc)
);

logic        rf_msix_tbl_word2_rdata_error;

logic        cfg_mem_ack_msix_tbl_word2_nc;
logic [31:0] cfg_mem_rdata_msix_tbl_word2_nc;

logic        rf_msix_tbl_word2_error_nc;
logic [(33)-1:0] pf_msix_tbl_word2_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_msix_tbl_word2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_msix_tbl_word2_re)
        ,.func_mem_raddr      (func_msix_tbl_word2_raddr)
        ,.func_mem_waddr      (func_msix_tbl_word2_waddr)
        ,.func_mem_we         (func_msix_tbl_word2_we)
        ,.func_mem_wdata      (func_msix_tbl_word2_wdata)
        ,.func_mem_rdata      (func_msix_tbl_word2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_msix_tbl_word2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_msix_tbl_word2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_msix_tbl_word2_rdata_nc)

        ,.mem_wclk            (rf_msix_tbl_word2_wclk)
        ,.mem_rclk            (rf_msix_tbl_word2_rclk)
        ,.mem_wclk_rst_n      (rf_msix_tbl_word2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_msix_tbl_word2_rclk_rst_n)
        ,.mem_re              (rf_msix_tbl_word2_re)
        ,.mem_raddr           (rf_msix_tbl_word2_raddr)
        ,.mem_waddr           (rf_msix_tbl_word2_waddr)
        ,.mem_we              (rf_msix_tbl_word2_we)
        ,.mem_wdata           (rf_msix_tbl_word2_wdata)
        ,.mem_rdata           (rf_msix_tbl_word2_rdata)

        ,.mem_rdata_error     (rf_msix_tbl_word2_rdata_error)
        ,.error               (rf_msix_tbl_word2_error_nc)
);

logic        rf_sch_out_fifo_rdata_error;

logic        cfg_mem_ack_sch_out_fifo_nc;
logic [31:0] cfg_mem_rdata_sch_out_fifo_nc;

logic        rf_sch_out_fifo_error_nc;
logic [(262)-1:0] pf_sch_out_fifo_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (128)
        ,.DWIDTH              (262)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (8)
) i_sch_out_fifo (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_sch_out_fifo_re)
        ,.func_mem_raddr      (func_sch_out_fifo_raddr)
        ,.func_mem_waddr      (func_sch_out_fifo_waddr)
        ,.func_mem_we         (func_sch_out_fifo_we)
        ,.func_mem_wdata      (func_sch_out_fifo_wdata)
        ,.func_mem_rdata      (func_sch_out_fifo_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_sch_out_fifo_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_sch_out_fifo_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_sch_out_fifo_rdata_nc)

        ,.mem_wclk            (rf_sch_out_fifo_wclk)
        ,.mem_rclk            (rf_sch_out_fifo_rclk)
        ,.mem_wclk_rst_n      (rf_sch_out_fifo_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_sch_out_fifo_rclk_rst_n)
        ,.mem_re              (rf_sch_out_fifo_re)
        ,.mem_raddr           (rf_sch_out_fifo_raddr)
        ,.mem_waddr           (rf_sch_out_fifo_waddr)
        ,.mem_we              (rf_sch_out_fifo_we)
        ,.mem_wdata           (rf_sch_out_fifo_wdata)
        ,.mem_rdata           (rf_sch_out_fifo_rdata)

        ,.mem_rdata_error     (rf_sch_out_fifo_rdata_error)
        ,.error               (rf_sch_out_fifo_error_nc)
);

logic        cfg_mem_ack_rob_mem_nc;
logic [31:0] cfg_mem_rdata_rob_mem_nc;

logic        sr_rob_mem_error_nc;
logic [(156)-1:0] pf_rob_mem_rdata_nc;

hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (156)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_rob_mem ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_rob_mem_re)
        ,.func_mem_addr       (func_rob_mem_addr)
        ,.func_mem_we         (func_rob_mem_we)
        ,.func_mem_wdata      (func_rob_mem_wdata)
        ,.func_mem_rdata      (func_rob_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rob_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rob_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_addr         ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_rob_mem_rdata_nc)

        ,.mem_clk             (sr_rob_mem_clk)
        ,.mem_clk_rst_n       (sr_rob_mem_clk_rst_n)
        ,.mem_re              (sr_rob_mem_re)
        ,.mem_addr            (sr_rob_mem_addr)
        ,.mem_we              (sr_rob_mem_we)
        ,.mem_wdata           (sr_rob_mem_wdata)
        ,.mem_rdata           (sr_rob_mem_rdata)

        ,.error               (sr_rob_mem_error_nc)
);


assign hqm_system_rfw_top_ipar_error = rf_alarm_vf_synd0_rdata_error | rf_alarm_vf_synd1_rdata_error | rf_alarm_vf_synd2_rdata_error | rf_dir_wb0_rdata_error | rf_dir_wb1_rdata_error | rf_dir_wb2_rdata_error | rf_ldb_wb0_rdata_error | rf_ldb_wb1_rdata_error | rf_ldb_wb2_rdata_error | rf_lut_dir_cq2vf_pf_ro_rdata_error | rf_lut_dir_cq_addr_l_rdata_error | rf_lut_dir_cq_addr_u_rdata_error | rf_lut_dir_cq_ai_addr_l_rdata_error | rf_lut_dir_cq_ai_addr_u_rdata_error | rf_lut_dir_cq_ai_data_rdata_error | rf_lut_dir_cq_isr_rdata_error | rf_lut_dir_cq_pasid_rdata_error | rf_lut_dir_pp2vas_rdata_error | rf_lut_dir_pp_v_rdata_error | rf_lut_dir_vasqid_v_rdata_error | rf_lut_ldb_cq2vf_pf_ro_rdata_error | rf_lut_ldb_cq_addr_l_rdata_error | rf_lut_ldb_cq_addr_u_rdata_error | rf_lut_ldb_cq_ai_addr_l_rdata_error | rf_lut_ldb_cq_ai_addr_u_rdata_error | rf_lut_ldb_cq_ai_data_rdata_error | rf_lut_ldb_cq_isr_rdata_error | rf_lut_ldb_cq_pasid_rdata_error | rf_lut_ldb_pp2vas_rdata_error | rf_lut_ldb_qid2vqid_rdata_error | rf_lut_ldb_vasqid_v_rdata_error | rf_lut_vf_dir_vpp2pp_rdata_error | rf_lut_vf_dir_vpp_v_rdata_error | rf_lut_vf_dir_vqid2qid_rdata_error | rf_lut_vf_dir_vqid_v_rdata_error | rf_lut_vf_ldb_vpp2pp_rdata_error | rf_lut_vf_ldb_vpp_v_rdata_error | rf_lut_vf_ldb_vqid2qid_rdata_error | rf_lut_vf_ldb_vqid_v_rdata_error | rf_msix_tbl_word0_rdata_error | rf_msix_tbl_word1_rdata_error | rf_msix_tbl_word2_rdata_error | rf_sch_out_fifo_rdata_error | rf_hcw_enq_fifo_rdata_error ;

endmodule

