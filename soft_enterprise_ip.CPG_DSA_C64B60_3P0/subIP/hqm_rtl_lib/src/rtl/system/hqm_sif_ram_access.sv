module hqm_sif_ram_access
     import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::*;
(
     input  logic                  prim_nonflr_clk

    ,input  logic                  prim_gated_rst_b

    ,output logic                  hqm_sif_rfw_top_ipar_error

    ,input  logic                  func_ibcpl_data_fifo_re
    ,input  logic [(       8)-1:0] func_ibcpl_data_fifo_raddr
    ,input  logic [(       8)-1:0] func_ibcpl_data_fifo_waddr
    ,input  logic                  func_ibcpl_data_fifo_we
    ,input  logic [(      66)-1:0] func_ibcpl_data_fifo_wdata
    ,output logic [(      66)-1:0] func_ibcpl_data_fifo_rdata

    ,output logic                  rf_ibcpl_data_fifo_re
    ,output logic                  rf_ibcpl_data_fifo_rclk
    ,output logic                  rf_ibcpl_data_fifo_rclk_rst_n
    ,output logic [(       8)-1:0] rf_ibcpl_data_fifo_raddr
    ,output logic [(       8)-1:0] rf_ibcpl_data_fifo_waddr
    ,output logic                  rf_ibcpl_data_fifo_we
    ,output logic                  rf_ibcpl_data_fifo_wclk
    ,output logic                  rf_ibcpl_data_fifo_wclk_rst_n
    ,output logic [(      66)-1:0] rf_ibcpl_data_fifo_wdata
    ,input  logic [(      66)-1:0] rf_ibcpl_data_fifo_rdata

    ,input  logic                  func_ibcpl_hdr_fifo_re
    ,input  logic [(       8)-1:0] func_ibcpl_hdr_fifo_raddr
    ,input  logic [(       8)-1:0] func_ibcpl_hdr_fifo_waddr
    ,input  logic                  func_ibcpl_hdr_fifo_we
    ,input  logic [(      20)-1:0] func_ibcpl_hdr_fifo_wdata
    ,output logic [(      20)-1:0] func_ibcpl_hdr_fifo_rdata

    ,output logic                  rf_ibcpl_hdr_fifo_re
    ,output logic                  rf_ibcpl_hdr_fifo_rclk
    ,output logic                  rf_ibcpl_hdr_fifo_rclk_rst_n
    ,output logic [(       8)-1:0] rf_ibcpl_hdr_fifo_raddr
    ,output logic [(       8)-1:0] rf_ibcpl_hdr_fifo_waddr
    ,output logic                  rf_ibcpl_hdr_fifo_we
    ,output logic                  rf_ibcpl_hdr_fifo_wclk
    ,output logic                  rf_ibcpl_hdr_fifo_wclk_rst_n
    ,output logic [(      20)-1:0] rf_ibcpl_hdr_fifo_wdata
    ,input  logic [(      20)-1:0] rf_ibcpl_hdr_fifo_rdata

    ,input  logic                  func_mstr_ll_data0_re
    ,input  logic [(       8)-1:0] func_mstr_ll_data0_raddr
    ,input  logic [(       8)-1:0] func_mstr_ll_data0_waddr
    ,input  logic                  func_mstr_ll_data0_we
    ,input  logic [(     129)-1:0] func_mstr_ll_data0_wdata
    ,output logic [(     129)-1:0] func_mstr_ll_data0_rdata

    ,output logic                  rf_mstr_ll_data0_re
    ,output logic                  rf_mstr_ll_data0_rclk
    ,output logic                  rf_mstr_ll_data0_rclk_rst_n
    ,output logic [(       8)-1:0] rf_mstr_ll_data0_raddr
    ,output logic [(       8)-1:0] rf_mstr_ll_data0_waddr
    ,output logic                  rf_mstr_ll_data0_we
    ,output logic                  rf_mstr_ll_data0_wclk
    ,output logic                  rf_mstr_ll_data0_wclk_rst_n
    ,output logic [(     129)-1:0] rf_mstr_ll_data0_wdata
    ,input  logic [(     129)-1:0] rf_mstr_ll_data0_rdata

    ,input  logic                  func_mstr_ll_data1_re
    ,input  logic [(       8)-1:0] func_mstr_ll_data1_raddr
    ,input  logic [(       8)-1:0] func_mstr_ll_data1_waddr
    ,input  logic                  func_mstr_ll_data1_we
    ,input  logic [(     129)-1:0] func_mstr_ll_data1_wdata
    ,output logic [(     129)-1:0] func_mstr_ll_data1_rdata

    ,output logic                  rf_mstr_ll_data1_re
    ,output logic                  rf_mstr_ll_data1_rclk
    ,output logic                  rf_mstr_ll_data1_rclk_rst_n
    ,output logic [(       8)-1:0] rf_mstr_ll_data1_raddr
    ,output logic [(       8)-1:0] rf_mstr_ll_data1_waddr
    ,output logic                  rf_mstr_ll_data1_we
    ,output logic                  rf_mstr_ll_data1_wclk
    ,output logic                  rf_mstr_ll_data1_wclk_rst_n
    ,output logic [(     129)-1:0] rf_mstr_ll_data1_wdata
    ,input  logic [(     129)-1:0] rf_mstr_ll_data1_rdata

    ,input  logic                  func_mstr_ll_data2_re
    ,input  logic [(       8)-1:0] func_mstr_ll_data2_raddr
    ,input  logic [(       8)-1:0] func_mstr_ll_data2_waddr
    ,input  logic                  func_mstr_ll_data2_we
    ,input  logic [(     129)-1:0] func_mstr_ll_data2_wdata
    ,output logic [(     129)-1:0] func_mstr_ll_data2_rdata

    ,output logic                  rf_mstr_ll_data2_re
    ,output logic                  rf_mstr_ll_data2_rclk
    ,output logic                  rf_mstr_ll_data2_rclk_rst_n
    ,output logic [(       8)-1:0] rf_mstr_ll_data2_raddr
    ,output logic [(       8)-1:0] rf_mstr_ll_data2_waddr
    ,output logic                  rf_mstr_ll_data2_we
    ,output logic                  rf_mstr_ll_data2_wclk
    ,output logic                  rf_mstr_ll_data2_wclk_rst_n
    ,output logic [(     129)-1:0] rf_mstr_ll_data2_wdata
    ,input  logic [(     129)-1:0] rf_mstr_ll_data2_rdata

    ,input  logic                  func_mstr_ll_data3_re
    ,input  logic [(       8)-1:0] func_mstr_ll_data3_raddr
    ,input  logic [(       8)-1:0] func_mstr_ll_data3_waddr
    ,input  logic                  func_mstr_ll_data3_we
    ,input  logic [(     129)-1:0] func_mstr_ll_data3_wdata
    ,output logic [(     129)-1:0] func_mstr_ll_data3_rdata

    ,output logic                  rf_mstr_ll_data3_re
    ,output logic                  rf_mstr_ll_data3_rclk
    ,output logic                  rf_mstr_ll_data3_rclk_rst_n
    ,output logic [(       8)-1:0] rf_mstr_ll_data3_raddr
    ,output logic [(       8)-1:0] rf_mstr_ll_data3_waddr
    ,output logic                  rf_mstr_ll_data3_we
    ,output logic                  rf_mstr_ll_data3_wclk
    ,output logic                  rf_mstr_ll_data3_wclk_rst_n
    ,output logic [(     129)-1:0] rf_mstr_ll_data3_wdata
    ,input  logic [(     129)-1:0] rf_mstr_ll_data3_rdata

    ,input  logic                  func_mstr_ll_hdr_re
    ,input  logic [(       8)-1:0] func_mstr_ll_hdr_raddr
    ,input  logic [(       8)-1:0] func_mstr_ll_hdr_waddr
    ,input  logic                  func_mstr_ll_hdr_we
    ,input  logic [(     153)-1:0] func_mstr_ll_hdr_wdata
    ,output logic [(     153)-1:0] func_mstr_ll_hdr_rdata

    ,output logic                  rf_mstr_ll_hdr_re
    ,output logic                  rf_mstr_ll_hdr_rclk
    ,output logic                  rf_mstr_ll_hdr_rclk_rst_n
    ,output logic [(       8)-1:0] rf_mstr_ll_hdr_raddr
    ,output logic [(       8)-1:0] rf_mstr_ll_hdr_waddr
    ,output logic                  rf_mstr_ll_hdr_we
    ,output logic                  rf_mstr_ll_hdr_wclk
    ,output logic                  rf_mstr_ll_hdr_wclk_rst_n
    ,output logic [(     153)-1:0] rf_mstr_ll_hdr_wdata
    ,input  logic [(     153)-1:0] rf_mstr_ll_hdr_rdata

    ,input  logic                  func_mstr_ll_hpa_re
    ,input  logic [(       7)-1:0] func_mstr_ll_hpa_raddr
    ,input  logic [(       7)-1:0] func_mstr_ll_hpa_waddr
    ,input  logic                  func_mstr_ll_hpa_we
    ,input  logic [(      35)-1:0] func_mstr_ll_hpa_wdata
    ,output logic [(      35)-1:0] func_mstr_ll_hpa_rdata

    ,output logic                  rf_mstr_ll_hpa_re
    ,output logic                  rf_mstr_ll_hpa_rclk
    ,output logic                  rf_mstr_ll_hpa_rclk_rst_n
    ,output logic [(       7)-1:0] rf_mstr_ll_hpa_raddr
    ,output logic [(       7)-1:0] rf_mstr_ll_hpa_waddr
    ,output logic                  rf_mstr_ll_hpa_we
    ,output logic                  rf_mstr_ll_hpa_wclk
    ,output logic                  rf_mstr_ll_hpa_wclk_rst_n
    ,output logic [(      35)-1:0] rf_mstr_ll_hpa_wdata
    ,input  logic [(      35)-1:0] rf_mstr_ll_hpa_rdata

    ,input  logic                  func_ri_tlq_fifo_npdata_re
    ,input  logic [(       3)-1:0] func_ri_tlq_fifo_npdata_raddr
    ,input  logic [(       3)-1:0] func_ri_tlq_fifo_npdata_waddr
    ,input  logic                  func_ri_tlq_fifo_npdata_we
    ,input  logic [(      33)-1:0] func_ri_tlq_fifo_npdata_wdata
    ,output logic [(      33)-1:0] func_ri_tlq_fifo_npdata_rdata

    ,output logic                  rf_ri_tlq_fifo_npdata_re
    ,output logic                  rf_ri_tlq_fifo_npdata_rclk
    ,output logic                  rf_ri_tlq_fifo_npdata_rclk_rst_n
    ,output logic [(       3)-1:0] rf_ri_tlq_fifo_npdata_raddr
    ,output logic [(       3)-1:0] rf_ri_tlq_fifo_npdata_waddr
    ,output logic                  rf_ri_tlq_fifo_npdata_we
    ,output logic                  rf_ri_tlq_fifo_npdata_wclk
    ,output logic                  rf_ri_tlq_fifo_npdata_wclk_rst_n
    ,output logic [(      33)-1:0] rf_ri_tlq_fifo_npdata_wdata
    ,input  logic [(      33)-1:0] rf_ri_tlq_fifo_npdata_rdata

    ,input  logic                  func_ri_tlq_fifo_nphdr_re
    ,input  logic [(       3)-1:0] func_ri_tlq_fifo_nphdr_raddr
    ,input  logic [(       3)-1:0] func_ri_tlq_fifo_nphdr_waddr
    ,input  logic                  func_ri_tlq_fifo_nphdr_we
    ,input  logic [(     158)-1:0] func_ri_tlq_fifo_nphdr_wdata
    ,output logic [(     158)-1:0] func_ri_tlq_fifo_nphdr_rdata

    ,output logic                  rf_ri_tlq_fifo_nphdr_re
    ,output logic                  rf_ri_tlq_fifo_nphdr_rclk
    ,output logic                  rf_ri_tlq_fifo_nphdr_rclk_rst_n
    ,output logic [(       3)-1:0] rf_ri_tlq_fifo_nphdr_raddr
    ,output logic [(       3)-1:0] rf_ri_tlq_fifo_nphdr_waddr
    ,output logic                  rf_ri_tlq_fifo_nphdr_we
    ,output logic                  rf_ri_tlq_fifo_nphdr_wclk
    ,output logic                  rf_ri_tlq_fifo_nphdr_wclk_rst_n
    ,output logic [(     158)-1:0] rf_ri_tlq_fifo_nphdr_wdata
    ,input  logic [(     158)-1:0] rf_ri_tlq_fifo_nphdr_rdata

    ,input  logic                  func_ri_tlq_fifo_pdata_re
    ,input  logic [(       5)-1:0] func_ri_tlq_fifo_pdata_raddr
    ,input  logic [(       5)-1:0] func_ri_tlq_fifo_pdata_waddr
    ,input  logic                  func_ri_tlq_fifo_pdata_we
    ,input  logic [(     264)-1:0] func_ri_tlq_fifo_pdata_wdata
    ,output logic [(     264)-1:0] func_ri_tlq_fifo_pdata_rdata

    ,output logic                  rf_ri_tlq_fifo_pdata_re
    ,output logic                  rf_ri_tlq_fifo_pdata_rclk
    ,output logic                  rf_ri_tlq_fifo_pdata_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ri_tlq_fifo_pdata_raddr
    ,output logic [(       5)-1:0] rf_ri_tlq_fifo_pdata_waddr
    ,output logic                  rf_ri_tlq_fifo_pdata_we
    ,output logic                  rf_ri_tlq_fifo_pdata_wclk
    ,output logic                  rf_ri_tlq_fifo_pdata_wclk_rst_n
    ,output logic [(     264)-1:0] rf_ri_tlq_fifo_pdata_wdata
    ,input  logic [(     264)-1:0] rf_ri_tlq_fifo_pdata_rdata

    ,input  logic                  func_ri_tlq_fifo_phdr_re
    ,input  logic [(       4)-1:0] func_ri_tlq_fifo_phdr_raddr
    ,input  logic [(       4)-1:0] func_ri_tlq_fifo_phdr_waddr
    ,input  logic                  func_ri_tlq_fifo_phdr_we
    ,input  logic [(     153)-1:0] func_ri_tlq_fifo_phdr_wdata
    ,output logic [(     153)-1:0] func_ri_tlq_fifo_phdr_rdata

    ,output logic                  rf_ri_tlq_fifo_phdr_re
    ,output logic                  rf_ri_tlq_fifo_phdr_rclk
    ,output logic                  rf_ri_tlq_fifo_phdr_rclk_rst_n
    ,output logic [(       4)-1:0] rf_ri_tlq_fifo_phdr_raddr
    ,output logic [(       4)-1:0] rf_ri_tlq_fifo_phdr_waddr
    ,output logic                  rf_ri_tlq_fifo_phdr_we
    ,output logic                  rf_ri_tlq_fifo_phdr_wclk
    ,output logic                  rf_ri_tlq_fifo_phdr_wclk_rst_n
    ,output logic [(     153)-1:0] rf_ri_tlq_fifo_phdr_wdata
    ,input  logic [(     153)-1:0] rf_ri_tlq_fifo_phdr_rdata

    ,input  logic                  func_scrbd_mem_re
    ,input  logic [(       8)-1:0] func_scrbd_mem_raddr
    ,input  logic [(       8)-1:0] func_scrbd_mem_waddr
    ,input  logic                  func_scrbd_mem_we
    ,input  logic [(      10)-1:0] func_scrbd_mem_wdata
    ,output logic [(      10)-1:0] func_scrbd_mem_rdata

    ,output logic                  rf_scrbd_mem_re
    ,output logic                  rf_scrbd_mem_rclk
    ,output logic                  rf_scrbd_mem_rclk_rst_n
    ,output logic [(       8)-1:0] rf_scrbd_mem_raddr
    ,output logic [(       8)-1:0] rf_scrbd_mem_waddr
    ,output logic                  rf_scrbd_mem_we
    ,output logic                  rf_scrbd_mem_wclk
    ,output logic                  rf_scrbd_mem_wclk_rst_n
    ,output logic [(      10)-1:0] rf_scrbd_mem_wdata
    ,input  logic [(      10)-1:0] rf_scrbd_mem_rdata

    ,input  logic                  func_tlb_data0_4k_re
    ,input  logic [(       4)-1:0] func_tlb_data0_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_data0_4k_waddr
    ,input  logic                  func_tlb_data0_4k_we
    ,input  logic [(      39)-1:0] func_tlb_data0_4k_wdata
    ,output logic [(      39)-1:0] func_tlb_data0_4k_rdata

    ,output logic                  rf_tlb_data0_4k_re
    ,output logic                  rf_tlb_data0_4k_rclk
    ,output logic                  rf_tlb_data0_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data0_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data0_4k_waddr
    ,output logic                  rf_tlb_data0_4k_we
    ,output logic                  rf_tlb_data0_4k_wclk
    ,output logic                  rf_tlb_data0_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data0_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data0_4k_rdata

    ,input  logic                  func_tlb_data1_4k_re
    ,input  logic [(       4)-1:0] func_tlb_data1_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_data1_4k_waddr
    ,input  logic                  func_tlb_data1_4k_we
    ,input  logic [(      39)-1:0] func_tlb_data1_4k_wdata
    ,output logic [(      39)-1:0] func_tlb_data1_4k_rdata

    ,output logic                  rf_tlb_data1_4k_re
    ,output logic                  rf_tlb_data1_4k_rclk
    ,output logic                  rf_tlb_data1_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data1_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data1_4k_waddr
    ,output logic                  rf_tlb_data1_4k_we
    ,output logic                  rf_tlb_data1_4k_wclk
    ,output logic                  rf_tlb_data1_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data1_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data1_4k_rdata

    ,input  logic                  func_tlb_data2_4k_re
    ,input  logic [(       4)-1:0] func_tlb_data2_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_data2_4k_waddr
    ,input  logic                  func_tlb_data2_4k_we
    ,input  logic [(      39)-1:0] func_tlb_data2_4k_wdata
    ,output logic [(      39)-1:0] func_tlb_data2_4k_rdata

    ,output logic                  rf_tlb_data2_4k_re
    ,output logic                  rf_tlb_data2_4k_rclk
    ,output logic                  rf_tlb_data2_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data2_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data2_4k_waddr
    ,output logic                  rf_tlb_data2_4k_we
    ,output logic                  rf_tlb_data2_4k_wclk
    ,output logic                  rf_tlb_data2_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data2_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data2_4k_rdata

    ,input  logic                  func_tlb_data3_4k_re
    ,input  logic [(       4)-1:0] func_tlb_data3_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_data3_4k_waddr
    ,input  logic                  func_tlb_data3_4k_we
    ,input  logic [(      39)-1:0] func_tlb_data3_4k_wdata
    ,output logic [(      39)-1:0] func_tlb_data3_4k_rdata

    ,output logic                  rf_tlb_data3_4k_re
    ,output logic                  rf_tlb_data3_4k_rclk
    ,output logic                  rf_tlb_data3_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data3_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data3_4k_waddr
    ,output logic                  rf_tlb_data3_4k_we
    ,output logic                  rf_tlb_data3_4k_wclk
    ,output logic                  rf_tlb_data3_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data3_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data3_4k_rdata

    ,input  logic                  func_tlb_data4_4k_re
    ,input  logic [(       4)-1:0] func_tlb_data4_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_data4_4k_waddr
    ,input  logic                  func_tlb_data4_4k_we
    ,input  logic [(      39)-1:0] func_tlb_data4_4k_wdata
    ,output logic [(      39)-1:0] func_tlb_data4_4k_rdata

    ,output logic                  rf_tlb_data4_4k_re
    ,output logic                  rf_tlb_data4_4k_rclk
    ,output logic                  rf_tlb_data4_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data4_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data4_4k_waddr
    ,output logic                  rf_tlb_data4_4k_we
    ,output logic                  rf_tlb_data4_4k_wclk
    ,output logic                  rf_tlb_data4_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data4_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data4_4k_rdata

    ,input  logic                  func_tlb_data5_4k_re
    ,input  logic [(       4)-1:0] func_tlb_data5_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_data5_4k_waddr
    ,input  logic                  func_tlb_data5_4k_we
    ,input  logic [(      39)-1:0] func_tlb_data5_4k_wdata
    ,output logic [(      39)-1:0] func_tlb_data5_4k_rdata

    ,output logic                  rf_tlb_data5_4k_re
    ,output logic                  rf_tlb_data5_4k_rclk
    ,output logic                  rf_tlb_data5_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data5_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data5_4k_waddr
    ,output logic                  rf_tlb_data5_4k_we
    ,output logic                  rf_tlb_data5_4k_wclk
    ,output logic                  rf_tlb_data5_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data5_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data5_4k_rdata

    ,input  logic                  func_tlb_data6_4k_re
    ,input  logic [(       4)-1:0] func_tlb_data6_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_data6_4k_waddr
    ,input  logic                  func_tlb_data6_4k_we
    ,input  logic [(      39)-1:0] func_tlb_data6_4k_wdata
    ,output logic [(      39)-1:0] func_tlb_data6_4k_rdata

    ,output logic                  rf_tlb_data6_4k_re
    ,output logic                  rf_tlb_data6_4k_rclk
    ,output logic                  rf_tlb_data6_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data6_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data6_4k_waddr
    ,output logic                  rf_tlb_data6_4k_we
    ,output logic                  rf_tlb_data6_4k_wclk
    ,output logic                  rf_tlb_data6_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data6_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data6_4k_rdata

    ,input  logic                  func_tlb_data7_4k_re
    ,input  logic [(       4)-1:0] func_tlb_data7_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_data7_4k_waddr
    ,input  logic                  func_tlb_data7_4k_we
    ,input  logic [(      39)-1:0] func_tlb_data7_4k_wdata
    ,output logic [(      39)-1:0] func_tlb_data7_4k_rdata

    ,output logic                  rf_tlb_data7_4k_re
    ,output logic                  rf_tlb_data7_4k_rclk
    ,output logic                  rf_tlb_data7_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_data7_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_data7_4k_waddr
    ,output logic                  rf_tlb_data7_4k_we
    ,output logic                  rf_tlb_data7_4k_wclk
    ,output logic                  rf_tlb_data7_4k_wclk_rst_n
    ,output logic [(      39)-1:0] rf_tlb_data7_4k_wdata
    ,input  logic [(      39)-1:0] rf_tlb_data7_4k_rdata

    ,input  logic                  func_tlb_tag0_4k_re
    ,input  logic [(       4)-1:0] func_tlb_tag0_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_tag0_4k_waddr
    ,input  logic                  func_tlb_tag0_4k_we
    ,input  logic [(      85)-1:0] func_tlb_tag0_4k_wdata
    ,output logic [(      85)-1:0] func_tlb_tag0_4k_rdata

    ,output logic                  rf_tlb_tag0_4k_re
    ,output logic                  rf_tlb_tag0_4k_rclk
    ,output logic                  rf_tlb_tag0_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag0_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag0_4k_waddr
    ,output logic                  rf_tlb_tag0_4k_we
    ,output logic                  rf_tlb_tag0_4k_wclk
    ,output logic                  rf_tlb_tag0_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag0_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag0_4k_rdata

    ,input  logic                  func_tlb_tag1_4k_re
    ,input  logic [(       4)-1:0] func_tlb_tag1_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_tag1_4k_waddr
    ,input  logic                  func_tlb_tag1_4k_we
    ,input  logic [(      85)-1:0] func_tlb_tag1_4k_wdata
    ,output logic [(      85)-1:0] func_tlb_tag1_4k_rdata

    ,output logic                  rf_tlb_tag1_4k_re
    ,output logic                  rf_tlb_tag1_4k_rclk
    ,output logic                  rf_tlb_tag1_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag1_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag1_4k_waddr
    ,output logic                  rf_tlb_tag1_4k_we
    ,output logic                  rf_tlb_tag1_4k_wclk
    ,output logic                  rf_tlb_tag1_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag1_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag1_4k_rdata

    ,input  logic                  func_tlb_tag2_4k_re
    ,input  logic [(       4)-1:0] func_tlb_tag2_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_tag2_4k_waddr
    ,input  logic                  func_tlb_tag2_4k_we
    ,input  logic [(      85)-1:0] func_tlb_tag2_4k_wdata
    ,output logic [(      85)-1:0] func_tlb_tag2_4k_rdata

    ,output logic                  rf_tlb_tag2_4k_re
    ,output logic                  rf_tlb_tag2_4k_rclk
    ,output logic                  rf_tlb_tag2_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag2_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag2_4k_waddr
    ,output logic                  rf_tlb_tag2_4k_we
    ,output logic                  rf_tlb_tag2_4k_wclk
    ,output logic                  rf_tlb_tag2_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag2_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag2_4k_rdata

    ,input  logic                  func_tlb_tag3_4k_re
    ,input  logic [(       4)-1:0] func_tlb_tag3_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_tag3_4k_waddr
    ,input  logic                  func_tlb_tag3_4k_we
    ,input  logic [(      85)-1:0] func_tlb_tag3_4k_wdata
    ,output logic [(      85)-1:0] func_tlb_tag3_4k_rdata

    ,output logic                  rf_tlb_tag3_4k_re
    ,output logic                  rf_tlb_tag3_4k_rclk
    ,output logic                  rf_tlb_tag3_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag3_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag3_4k_waddr
    ,output logic                  rf_tlb_tag3_4k_we
    ,output logic                  rf_tlb_tag3_4k_wclk
    ,output logic                  rf_tlb_tag3_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag3_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag3_4k_rdata

    ,input  logic                  func_tlb_tag4_4k_re
    ,input  logic [(       4)-1:0] func_tlb_tag4_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_tag4_4k_waddr
    ,input  logic                  func_tlb_tag4_4k_we
    ,input  logic [(      85)-1:0] func_tlb_tag4_4k_wdata
    ,output logic [(      85)-1:0] func_tlb_tag4_4k_rdata

    ,output logic                  rf_tlb_tag4_4k_re
    ,output logic                  rf_tlb_tag4_4k_rclk
    ,output logic                  rf_tlb_tag4_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag4_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag4_4k_waddr
    ,output logic                  rf_tlb_tag4_4k_we
    ,output logic                  rf_tlb_tag4_4k_wclk
    ,output logic                  rf_tlb_tag4_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag4_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag4_4k_rdata

    ,input  logic                  func_tlb_tag5_4k_re
    ,input  logic [(       4)-1:0] func_tlb_tag5_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_tag5_4k_waddr
    ,input  logic                  func_tlb_tag5_4k_we
    ,input  logic [(      85)-1:0] func_tlb_tag5_4k_wdata
    ,output logic [(      85)-1:0] func_tlb_tag5_4k_rdata

    ,output logic                  rf_tlb_tag5_4k_re
    ,output logic                  rf_tlb_tag5_4k_rclk
    ,output logic                  rf_tlb_tag5_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag5_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag5_4k_waddr
    ,output logic                  rf_tlb_tag5_4k_we
    ,output logic                  rf_tlb_tag5_4k_wclk
    ,output logic                  rf_tlb_tag5_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag5_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag5_4k_rdata

    ,input  logic                  func_tlb_tag6_4k_re
    ,input  logic [(       4)-1:0] func_tlb_tag6_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_tag6_4k_waddr
    ,input  logic                  func_tlb_tag6_4k_we
    ,input  logic [(      85)-1:0] func_tlb_tag6_4k_wdata
    ,output logic [(      85)-1:0] func_tlb_tag6_4k_rdata

    ,output logic                  rf_tlb_tag6_4k_re
    ,output logic                  rf_tlb_tag6_4k_rclk
    ,output logic                  rf_tlb_tag6_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag6_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag6_4k_waddr
    ,output logic                  rf_tlb_tag6_4k_we
    ,output logic                  rf_tlb_tag6_4k_wclk
    ,output logic                  rf_tlb_tag6_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag6_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag6_4k_rdata

    ,input  logic                  func_tlb_tag7_4k_re
    ,input  logic [(       4)-1:0] func_tlb_tag7_4k_raddr
    ,input  logic [(       4)-1:0] func_tlb_tag7_4k_waddr
    ,input  logic                  func_tlb_tag7_4k_we
    ,input  logic [(      85)-1:0] func_tlb_tag7_4k_wdata
    ,output logic [(      85)-1:0] func_tlb_tag7_4k_rdata

    ,output logic                  rf_tlb_tag7_4k_re
    ,output logic                  rf_tlb_tag7_4k_rclk
    ,output logic                  rf_tlb_tag7_4k_rclk_rst_n
    ,output logic [(       4)-1:0] rf_tlb_tag7_4k_raddr
    ,output logic [(       4)-1:0] rf_tlb_tag7_4k_waddr
    ,output logic                  rf_tlb_tag7_4k_we
    ,output logic                  rf_tlb_tag7_4k_wclk
    ,output logic                  rf_tlb_tag7_4k_wclk_rst_n
    ,output logic [(      85)-1:0] rf_tlb_tag7_4k_wdata
    ,input  logic [(      85)-1:0] rf_tlb_tag7_4k_rdata

);

logic        rf_ibcpl_data_fifo_rdata_error;

logic        cfg_mem_ack_ibcpl_data_fifo_nc;
logic [31:0] cfg_mem_rdata_ibcpl_data_fifo_nc;

logic        rf_ibcpl_data_fifo_error_nc;
logic [(66)-1:0] pf_ibcpl_data_fifo_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (66)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ibcpl_data_fifo (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_ibcpl_data_fifo_re)
        ,.func_mem_raddr      (func_ibcpl_data_fifo_raddr)
        ,.func_mem_waddr      (func_ibcpl_data_fifo_waddr)
        ,.func_mem_we         (func_ibcpl_data_fifo_we)
        ,.func_mem_wdata      (func_ibcpl_data_fifo_wdata)
        ,.func_mem_rdata      (func_ibcpl_data_fifo_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ibcpl_data_fifo_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ibcpl_data_fifo_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_ibcpl_data_fifo_rdata_nc)

        ,.mem_wclk            (rf_ibcpl_data_fifo_wclk)
        ,.mem_rclk            (rf_ibcpl_data_fifo_rclk)
        ,.mem_wclk_rst_n      (rf_ibcpl_data_fifo_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ibcpl_data_fifo_rclk_rst_n)
        ,.mem_re              (rf_ibcpl_data_fifo_re)
        ,.mem_raddr           (rf_ibcpl_data_fifo_raddr)
        ,.mem_waddr           (rf_ibcpl_data_fifo_waddr)
        ,.mem_we              (rf_ibcpl_data_fifo_we)
        ,.mem_wdata           (rf_ibcpl_data_fifo_wdata)
        ,.mem_rdata           (rf_ibcpl_data_fifo_rdata)

        ,.mem_rdata_error     (rf_ibcpl_data_fifo_rdata_error)
        ,.error               (rf_ibcpl_data_fifo_error_nc)
);

logic        rf_ibcpl_hdr_fifo_rdata_error;

logic        cfg_mem_ack_ibcpl_hdr_fifo_nc;
logic [31:0] cfg_mem_rdata_ibcpl_hdr_fifo_nc;

logic        rf_ibcpl_hdr_fifo_error_nc;
logic [(20)-1:0] pf_ibcpl_hdr_fifo_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (20)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ibcpl_hdr_fifo (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_ibcpl_hdr_fifo_re)
        ,.func_mem_raddr      (func_ibcpl_hdr_fifo_raddr)
        ,.func_mem_waddr      (func_ibcpl_hdr_fifo_waddr)
        ,.func_mem_we         (func_ibcpl_hdr_fifo_we)
        ,.func_mem_wdata      (func_ibcpl_hdr_fifo_wdata)
        ,.func_mem_rdata      (func_ibcpl_hdr_fifo_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ibcpl_hdr_fifo_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ibcpl_hdr_fifo_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_ibcpl_hdr_fifo_rdata_nc)

        ,.mem_wclk            (rf_ibcpl_hdr_fifo_wclk)
        ,.mem_rclk            (rf_ibcpl_hdr_fifo_rclk)
        ,.mem_wclk_rst_n      (rf_ibcpl_hdr_fifo_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ibcpl_hdr_fifo_rclk_rst_n)
        ,.mem_re              (rf_ibcpl_hdr_fifo_re)
        ,.mem_raddr           (rf_ibcpl_hdr_fifo_raddr)
        ,.mem_waddr           (rf_ibcpl_hdr_fifo_waddr)
        ,.mem_we              (rf_ibcpl_hdr_fifo_we)
        ,.mem_wdata           (rf_ibcpl_hdr_fifo_wdata)
        ,.mem_rdata           (rf_ibcpl_hdr_fifo_rdata)

        ,.mem_rdata_error     (rf_ibcpl_hdr_fifo_rdata_error)
        ,.error               (rf_ibcpl_hdr_fifo_error_nc)
);

logic        rf_mstr_ll_data0_rdata_error;

logic        cfg_mem_ack_mstr_ll_data0_nc;
logic [31:0] cfg_mem_rdata_mstr_ll_data0_nc;

logic        rf_mstr_ll_data0_error_nc;
logic [(129)-1:0] pf_mstr_ll_data0_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (129)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_mstr_ll_data0 (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_mstr_ll_data0_re)
        ,.func_mem_raddr      (func_mstr_ll_data0_raddr)
        ,.func_mem_waddr      (func_mstr_ll_data0_waddr)
        ,.func_mem_we         (func_mstr_ll_data0_we)
        ,.func_mem_wdata      (func_mstr_ll_data0_wdata)
        ,.func_mem_rdata      (func_mstr_ll_data0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_mstr_ll_data0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_mstr_ll_data0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_mstr_ll_data0_rdata_nc)

        ,.mem_wclk            (rf_mstr_ll_data0_wclk)
        ,.mem_rclk            (rf_mstr_ll_data0_rclk)
        ,.mem_wclk_rst_n      (rf_mstr_ll_data0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_mstr_ll_data0_rclk_rst_n)
        ,.mem_re              (rf_mstr_ll_data0_re)
        ,.mem_raddr           (rf_mstr_ll_data0_raddr)
        ,.mem_waddr           (rf_mstr_ll_data0_waddr)
        ,.mem_we              (rf_mstr_ll_data0_we)
        ,.mem_wdata           (rf_mstr_ll_data0_wdata)
        ,.mem_rdata           (rf_mstr_ll_data0_rdata)

        ,.mem_rdata_error     (rf_mstr_ll_data0_rdata_error)
        ,.error               (rf_mstr_ll_data0_error_nc)
);

logic        rf_mstr_ll_data1_rdata_error;

logic        cfg_mem_ack_mstr_ll_data1_nc;
logic [31:0] cfg_mem_rdata_mstr_ll_data1_nc;

logic        rf_mstr_ll_data1_error_nc;
logic [(129)-1:0] pf_mstr_ll_data1_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (129)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_mstr_ll_data1 (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_mstr_ll_data1_re)
        ,.func_mem_raddr      (func_mstr_ll_data1_raddr)
        ,.func_mem_waddr      (func_mstr_ll_data1_waddr)
        ,.func_mem_we         (func_mstr_ll_data1_we)
        ,.func_mem_wdata      (func_mstr_ll_data1_wdata)
        ,.func_mem_rdata      (func_mstr_ll_data1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_mstr_ll_data1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_mstr_ll_data1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_mstr_ll_data1_rdata_nc)

        ,.mem_wclk            (rf_mstr_ll_data1_wclk)
        ,.mem_rclk            (rf_mstr_ll_data1_rclk)
        ,.mem_wclk_rst_n      (rf_mstr_ll_data1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_mstr_ll_data1_rclk_rst_n)
        ,.mem_re              (rf_mstr_ll_data1_re)
        ,.mem_raddr           (rf_mstr_ll_data1_raddr)
        ,.mem_waddr           (rf_mstr_ll_data1_waddr)
        ,.mem_we              (rf_mstr_ll_data1_we)
        ,.mem_wdata           (rf_mstr_ll_data1_wdata)
        ,.mem_rdata           (rf_mstr_ll_data1_rdata)

        ,.mem_rdata_error     (rf_mstr_ll_data1_rdata_error)
        ,.error               (rf_mstr_ll_data1_error_nc)
);

logic        rf_mstr_ll_data2_rdata_error;

logic        cfg_mem_ack_mstr_ll_data2_nc;
logic [31:0] cfg_mem_rdata_mstr_ll_data2_nc;

logic        rf_mstr_ll_data2_error_nc;
logic [(129)-1:0] pf_mstr_ll_data2_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (129)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_mstr_ll_data2 (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_mstr_ll_data2_re)
        ,.func_mem_raddr      (func_mstr_ll_data2_raddr)
        ,.func_mem_waddr      (func_mstr_ll_data2_waddr)
        ,.func_mem_we         (func_mstr_ll_data2_we)
        ,.func_mem_wdata      (func_mstr_ll_data2_wdata)
        ,.func_mem_rdata      (func_mstr_ll_data2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_mstr_ll_data2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_mstr_ll_data2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_mstr_ll_data2_rdata_nc)

        ,.mem_wclk            (rf_mstr_ll_data2_wclk)
        ,.mem_rclk            (rf_mstr_ll_data2_rclk)
        ,.mem_wclk_rst_n      (rf_mstr_ll_data2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_mstr_ll_data2_rclk_rst_n)
        ,.mem_re              (rf_mstr_ll_data2_re)
        ,.mem_raddr           (rf_mstr_ll_data2_raddr)
        ,.mem_waddr           (rf_mstr_ll_data2_waddr)
        ,.mem_we              (rf_mstr_ll_data2_we)
        ,.mem_wdata           (rf_mstr_ll_data2_wdata)
        ,.mem_rdata           (rf_mstr_ll_data2_rdata)

        ,.mem_rdata_error     (rf_mstr_ll_data2_rdata_error)
        ,.error               (rf_mstr_ll_data2_error_nc)
);

logic        rf_mstr_ll_data3_rdata_error;

logic        cfg_mem_ack_mstr_ll_data3_nc;
logic [31:0] cfg_mem_rdata_mstr_ll_data3_nc;

logic        rf_mstr_ll_data3_error_nc;
logic [(129)-1:0] pf_mstr_ll_data3_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (129)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_mstr_ll_data3 (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_mstr_ll_data3_re)
        ,.func_mem_raddr      (func_mstr_ll_data3_raddr)
        ,.func_mem_waddr      (func_mstr_ll_data3_waddr)
        ,.func_mem_we         (func_mstr_ll_data3_we)
        ,.func_mem_wdata      (func_mstr_ll_data3_wdata)
        ,.func_mem_rdata      (func_mstr_ll_data3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_mstr_ll_data3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_mstr_ll_data3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_mstr_ll_data3_rdata_nc)

        ,.mem_wclk            (rf_mstr_ll_data3_wclk)
        ,.mem_rclk            (rf_mstr_ll_data3_rclk)
        ,.mem_wclk_rst_n      (rf_mstr_ll_data3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_mstr_ll_data3_rclk_rst_n)
        ,.mem_re              (rf_mstr_ll_data3_re)
        ,.mem_raddr           (rf_mstr_ll_data3_raddr)
        ,.mem_waddr           (rf_mstr_ll_data3_waddr)
        ,.mem_we              (rf_mstr_ll_data3_we)
        ,.mem_wdata           (rf_mstr_ll_data3_wdata)
        ,.mem_rdata           (rf_mstr_ll_data3_rdata)

        ,.mem_rdata_error     (rf_mstr_ll_data3_rdata_error)
        ,.error               (rf_mstr_ll_data3_error_nc)
);

logic        rf_mstr_ll_hdr_rdata_error;

logic        cfg_mem_ack_mstr_ll_hdr_nc;
logic [31:0] cfg_mem_rdata_mstr_ll_hdr_nc;

logic        rf_mstr_ll_hdr_error_nc;
logic [(153)-1:0] pf_mstr_ll_hdr_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (153)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_mstr_ll_hdr (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_mstr_ll_hdr_re)
        ,.func_mem_raddr      (func_mstr_ll_hdr_raddr)
        ,.func_mem_waddr      (func_mstr_ll_hdr_waddr)
        ,.func_mem_we         (func_mstr_ll_hdr_we)
        ,.func_mem_wdata      (func_mstr_ll_hdr_wdata)
        ,.func_mem_rdata      (func_mstr_ll_hdr_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_mstr_ll_hdr_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_mstr_ll_hdr_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_mstr_ll_hdr_rdata_nc)

        ,.mem_wclk            (rf_mstr_ll_hdr_wclk)
        ,.mem_rclk            (rf_mstr_ll_hdr_rclk)
        ,.mem_wclk_rst_n      (rf_mstr_ll_hdr_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_mstr_ll_hdr_rclk_rst_n)
        ,.mem_re              (rf_mstr_ll_hdr_re)
        ,.mem_raddr           (rf_mstr_ll_hdr_raddr)
        ,.mem_waddr           (rf_mstr_ll_hdr_waddr)
        ,.mem_we              (rf_mstr_ll_hdr_we)
        ,.mem_wdata           (rf_mstr_ll_hdr_wdata)
        ,.mem_rdata           (rf_mstr_ll_hdr_rdata)

        ,.mem_rdata_error     (rf_mstr_ll_hdr_rdata_error)
        ,.error               (rf_mstr_ll_hdr_error_nc)
);

logic        rf_mstr_ll_hpa_rdata_error;

logic        cfg_mem_ack_mstr_ll_hpa_nc;
logic [31:0] cfg_mem_rdata_mstr_ll_hpa_nc;

logic        rf_mstr_ll_hpa_error_nc;
logic [(35)-1:0] pf_mstr_ll_hpa_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (128)
        ,.DWIDTH              (35)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_mstr_ll_hpa (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_mstr_ll_hpa_re)
        ,.func_mem_raddr      (func_mstr_ll_hpa_raddr)
        ,.func_mem_waddr      (func_mstr_ll_hpa_waddr)
        ,.func_mem_we         (func_mstr_ll_hpa_we)
        ,.func_mem_wdata      (func_mstr_ll_hpa_wdata)
        ,.func_mem_rdata      (func_mstr_ll_hpa_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_mstr_ll_hpa_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_mstr_ll_hpa_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_mstr_ll_hpa_rdata_nc)

        ,.mem_wclk            (rf_mstr_ll_hpa_wclk)
        ,.mem_rclk            (rf_mstr_ll_hpa_rclk)
        ,.mem_wclk_rst_n      (rf_mstr_ll_hpa_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_mstr_ll_hpa_rclk_rst_n)
        ,.mem_re              (rf_mstr_ll_hpa_re)
        ,.mem_raddr           (rf_mstr_ll_hpa_raddr)
        ,.mem_waddr           (rf_mstr_ll_hpa_waddr)
        ,.mem_we              (rf_mstr_ll_hpa_we)
        ,.mem_wdata           (rf_mstr_ll_hpa_wdata)
        ,.mem_rdata           (rf_mstr_ll_hpa_rdata)

        ,.mem_rdata_error     (rf_mstr_ll_hpa_rdata_error)
        ,.error               (rf_mstr_ll_hpa_error_nc)
);

logic        rf_ri_tlq_fifo_npdata_rdata_error;

logic        cfg_mem_ack_ri_tlq_fifo_npdata_nc;
logic [31:0] cfg_mem_rdata_ri_tlq_fifo_npdata_nc;

logic        rf_ri_tlq_fifo_npdata_error_nc;
logic [(33)-1:0] pf_ri_tlq_fifo_npdata_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ri_tlq_fifo_npdata (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_ri_tlq_fifo_npdata_re)
        ,.func_mem_raddr      (func_ri_tlq_fifo_npdata_raddr)
        ,.func_mem_waddr      (func_ri_tlq_fifo_npdata_waddr)
        ,.func_mem_we         (func_ri_tlq_fifo_npdata_we)
        ,.func_mem_wdata      (func_ri_tlq_fifo_npdata_wdata)
        ,.func_mem_rdata      (func_ri_tlq_fifo_npdata_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ri_tlq_fifo_npdata_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ri_tlq_fifo_npdata_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_ri_tlq_fifo_npdata_rdata_nc)

        ,.mem_wclk            (rf_ri_tlq_fifo_npdata_wclk)
        ,.mem_rclk            (rf_ri_tlq_fifo_npdata_rclk)
        ,.mem_wclk_rst_n      (rf_ri_tlq_fifo_npdata_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ri_tlq_fifo_npdata_rclk_rst_n)
        ,.mem_re              (rf_ri_tlq_fifo_npdata_re)
        ,.mem_raddr           (rf_ri_tlq_fifo_npdata_raddr)
        ,.mem_waddr           (rf_ri_tlq_fifo_npdata_waddr)
        ,.mem_we              (rf_ri_tlq_fifo_npdata_we)
        ,.mem_wdata           (rf_ri_tlq_fifo_npdata_wdata)
        ,.mem_rdata           (rf_ri_tlq_fifo_npdata_rdata)

        ,.mem_rdata_error     (rf_ri_tlq_fifo_npdata_rdata_error)
        ,.error               (rf_ri_tlq_fifo_npdata_error_nc)
);

logic        rf_ri_tlq_fifo_nphdr_rdata_error;

logic        cfg_mem_ack_ri_tlq_fifo_nphdr_nc;
logic [31:0] cfg_mem_rdata_ri_tlq_fifo_nphdr_nc;

logic        rf_ri_tlq_fifo_nphdr_error_nc;
logic [(158)-1:0] pf_ri_tlq_fifo_nphdr_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (158)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ri_tlq_fifo_nphdr (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_ri_tlq_fifo_nphdr_re)
        ,.func_mem_raddr      (func_ri_tlq_fifo_nphdr_raddr)
        ,.func_mem_waddr      (func_ri_tlq_fifo_nphdr_waddr)
        ,.func_mem_we         (func_ri_tlq_fifo_nphdr_we)
        ,.func_mem_wdata      (func_ri_tlq_fifo_nphdr_wdata)
        ,.func_mem_rdata      (func_ri_tlq_fifo_nphdr_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ri_tlq_fifo_nphdr_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ri_tlq_fifo_nphdr_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_ri_tlq_fifo_nphdr_rdata_nc)

        ,.mem_wclk            (rf_ri_tlq_fifo_nphdr_wclk)
        ,.mem_rclk            (rf_ri_tlq_fifo_nphdr_rclk)
        ,.mem_wclk_rst_n      (rf_ri_tlq_fifo_nphdr_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ri_tlq_fifo_nphdr_rclk_rst_n)
        ,.mem_re              (rf_ri_tlq_fifo_nphdr_re)
        ,.mem_raddr           (rf_ri_tlq_fifo_nphdr_raddr)
        ,.mem_waddr           (rf_ri_tlq_fifo_nphdr_waddr)
        ,.mem_we              (rf_ri_tlq_fifo_nphdr_we)
        ,.mem_wdata           (rf_ri_tlq_fifo_nphdr_wdata)
        ,.mem_rdata           (rf_ri_tlq_fifo_nphdr_rdata)

        ,.mem_rdata_error     (rf_ri_tlq_fifo_nphdr_rdata_error)
        ,.error               (rf_ri_tlq_fifo_nphdr_error_nc)
);

logic        rf_ri_tlq_fifo_pdata_rdata_error;

logic        cfg_mem_ack_ri_tlq_fifo_pdata_nc;
logic [31:0] cfg_mem_rdata_ri_tlq_fifo_pdata_nc;

logic        rf_ri_tlq_fifo_pdata_error_nc;
logic [(264)-1:0] pf_ri_tlq_fifo_pdata_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (264)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ri_tlq_fifo_pdata (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_ri_tlq_fifo_pdata_re)
        ,.func_mem_raddr      (func_ri_tlq_fifo_pdata_raddr)
        ,.func_mem_waddr      (func_ri_tlq_fifo_pdata_waddr)
        ,.func_mem_we         (func_ri_tlq_fifo_pdata_we)
        ,.func_mem_wdata      (func_ri_tlq_fifo_pdata_wdata)
        ,.func_mem_rdata      (func_ri_tlq_fifo_pdata_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ri_tlq_fifo_pdata_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ri_tlq_fifo_pdata_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_ri_tlq_fifo_pdata_rdata_nc)

        ,.mem_wclk            (rf_ri_tlq_fifo_pdata_wclk)
        ,.mem_rclk            (rf_ri_tlq_fifo_pdata_rclk)
        ,.mem_wclk_rst_n      (rf_ri_tlq_fifo_pdata_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ri_tlq_fifo_pdata_rclk_rst_n)
        ,.mem_re              (rf_ri_tlq_fifo_pdata_re)
        ,.mem_raddr           (rf_ri_tlq_fifo_pdata_raddr)
        ,.mem_waddr           (rf_ri_tlq_fifo_pdata_waddr)
        ,.mem_we              (rf_ri_tlq_fifo_pdata_we)
        ,.mem_wdata           (rf_ri_tlq_fifo_pdata_wdata)
        ,.mem_rdata           (rf_ri_tlq_fifo_pdata_rdata)

        ,.mem_rdata_error     (rf_ri_tlq_fifo_pdata_rdata_error)
        ,.error               (rf_ri_tlq_fifo_pdata_error_nc)
);

logic        rf_ri_tlq_fifo_phdr_rdata_error;

logic        cfg_mem_ack_ri_tlq_fifo_phdr_nc;
logic [31:0] cfg_mem_rdata_ri_tlq_fifo_phdr_nc;

logic        rf_ri_tlq_fifo_phdr_error_nc;
logic [(153)-1:0] pf_ri_tlq_fifo_phdr_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (153)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ri_tlq_fifo_phdr (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_ri_tlq_fifo_phdr_re)
        ,.func_mem_raddr      (func_ri_tlq_fifo_phdr_raddr)
        ,.func_mem_waddr      (func_ri_tlq_fifo_phdr_waddr)
        ,.func_mem_we         (func_ri_tlq_fifo_phdr_we)
        ,.func_mem_wdata      (func_ri_tlq_fifo_phdr_wdata)
        ,.func_mem_rdata      (func_ri_tlq_fifo_phdr_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ri_tlq_fifo_phdr_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ri_tlq_fifo_phdr_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_ri_tlq_fifo_phdr_rdata_nc)

        ,.mem_wclk            (rf_ri_tlq_fifo_phdr_wclk)
        ,.mem_rclk            (rf_ri_tlq_fifo_phdr_rclk)
        ,.mem_wclk_rst_n      (rf_ri_tlq_fifo_phdr_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ri_tlq_fifo_phdr_rclk_rst_n)
        ,.mem_re              (rf_ri_tlq_fifo_phdr_re)
        ,.mem_raddr           (rf_ri_tlq_fifo_phdr_raddr)
        ,.mem_waddr           (rf_ri_tlq_fifo_phdr_waddr)
        ,.mem_we              (rf_ri_tlq_fifo_phdr_we)
        ,.mem_wdata           (rf_ri_tlq_fifo_phdr_wdata)
        ,.mem_rdata           (rf_ri_tlq_fifo_phdr_rdata)

        ,.mem_rdata_error     (rf_ri_tlq_fifo_phdr_rdata_error)
        ,.error               (rf_ri_tlq_fifo_phdr_error_nc)
);

logic        rf_scrbd_mem_rdata_error;

logic        cfg_mem_ack_scrbd_mem_nc;
logic [31:0] cfg_mem_rdata_scrbd_mem_nc;

logic        rf_scrbd_mem_error_nc;
logic [(10)-1:0] pf_scrbd_mem_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (10)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_scrbd_mem (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_scrbd_mem_re)
        ,.func_mem_raddr      (func_scrbd_mem_raddr)
        ,.func_mem_waddr      (func_scrbd_mem_waddr)
        ,.func_mem_we         (func_scrbd_mem_we)
        ,.func_mem_wdata      (func_scrbd_mem_wdata)
        ,.func_mem_rdata      (func_scrbd_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_scrbd_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_scrbd_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_scrbd_mem_rdata_nc)

        ,.mem_wclk            (rf_scrbd_mem_wclk)
        ,.mem_rclk            (rf_scrbd_mem_rclk)
        ,.mem_wclk_rst_n      (rf_scrbd_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_scrbd_mem_rclk_rst_n)
        ,.mem_re              (rf_scrbd_mem_re)
        ,.mem_raddr           (rf_scrbd_mem_raddr)
        ,.mem_waddr           (rf_scrbd_mem_waddr)
        ,.mem_we              (rf_scrbd_mem_we)
        ,.mem_wdata           (rf_scrbd_mem_wdata)
        ,.mem_rdata           (rf_scrbd_mem_rdata)

        ,.mem_rdata_error     (rf_scrbd_mem_rdata_error)
        ,.error               (rf_scrbd_mem_error_nc)
);

logic        rf_tlb_data0_4k_rdata_error;

logic        cfg_mem_ack_tlb_data0_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_data0_4k_nc;

logic        rf_tlb_data0_4k_error_nc;
logic [(39)-1:0] pf_tlb_data0_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (39)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_data0_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_data0_4k_re)
        ,.func_mem_raddr      (func_tlb_data0_4k_raddr)
        ,.func_mem_waddr      (func_tlb_data0_4k_waddr)
        ,.func_mem_we         (func_tlb_data0_4k_we)
        ,.func_mem_wdata      (func_tlb_data0_4k_wdata)
        ,.func_mem_rdata      (func_tlb_data0_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_data0_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_data0_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_data0_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_data0_4k_wclk)
        ,.mem_rclk            (rf_tlb_data0_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_data0_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_data0_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_data0_4k_re)
        ,.mem_raddr           (rf_tlb_data0_4k_raddr)
        ,.mem_waddr           (rf_tlb_data0_4k_waddr)
        ,.mem_we              (rf_tlb_data0_4k_we)
        ,.mem_wdata           (rf_tlb_data0_4k_wdata)
        ,.mem_rdata           (rf_tlb_data0_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_data0_4k_rdata_error)
        ,.error               (rf_tlb_data0_4k_error_nc)
);

logic        rf_tlb_data1_4k_rdata_error;

logic        cfg_mem_ack_tlb_data1_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_data1_4k_nc;

logic        rf_tlb_data1_4k_error_nc;
logic [(39)-1:0] pf_tlb_data1_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (39)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_data1_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_data1_4k_re)
        ,.func_mem_raddr      (func_tlb_data1_4k_raddr)
        ,.func_mem_waddr      (func_tlb_data1_4k_waddr)
        ,.func_mem_we         (func_tlb_data1_4k_we)
        ,.func_mem_wdata      (func_tlb_data1_4k_wdata)
        ,.func_mem_rdata      (func_tlb_data1_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_data1_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_data1_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_data1_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_data1_4k_wclk)
        ,.mem_rclk            (rf_tlb_data1_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_data1_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_data1_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_data1_4k_re)
        ,.mem_raddr           (rf_tlb_data1_4k_raddr)
        ,.mem_waddr           (rf_tlb_data1_4k_waddr)
        ,.mem_we              (rf_tlb_data1_4k_we)
        ,.mem_wdata           (rf_tlb_data1_4k_wdata)
        ,.mem_rdata           (rf_tlb_data1_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_data1_4k_rdata_error)
        ,.error               (rf_tlb_data1_4k_error_nc)
);

logic        rf_tlb_data2_4k_rdata_error;

logic        cfg_mem_ack_tlb_data2_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_data2_4k_nc;

logic        rf_tlb_data2_4k_error_nc;
logic [(39)-1:0] pf_tlb_data2_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (39)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_data2_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_data2_4k_re)
        ,.func_mem_raddr      (func_tlb_data2_4k_raddr)
        ,.func_mem_waddr      (func_tlb_data2_4k_waddr)
        ,.func_mem_we         (func_tlb_data2_4k_we)
        ,.func_mem_wdata      (func_tlb_data2_4k_wdata)
        ,.func_mem_rdata      (func_tlb_data2_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_data2_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_data2_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_data2_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_data2_4k_wclk)
        ,.mem_rclk            (rf_tlb_data2_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_data2_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_data2_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_data2_4k_re)
        ,.mem_raddr           (rf_tlb_data2_4k_raddr)
        ,.mem_waddr           (rf_tlb_data2_4k_waddr)
        ,.mem_we              (rf_tlb_data2_4k_we)
        ,.mem_wdata           (rf_tlb_data2_4k_wdata)
        ,.mem_rdata           (rf_tlb_data2_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_data2_4k_rdata_error)
        ,.error               (rf_tlb_data2_4k_error_nc)
);

logic        rf_tlb_data3_4k_rdata_error;

logic        cfg_mem_ack_tlb_data3_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_data3_4k_nc;

logic        rf_tlb_data3_4k_error_nc;
logic [(39)-1:0] pf_tlb_data3_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (39)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_data3_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_data3_4k_re)
        ,.func_mem_raddr      (func_tlb_data3_4k_raddr)
        ,.func_mem_waddr      (func_tlb_data3_4k_waddr)
        ,.func_mem_we         (func_tlb_data3_4k_we)
        ,.func_mem_wdata      (func_tlb_data3_4k_wdata)
        ,.func_mem_rdata      (func_tlb_data3_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_data3_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_data3_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_data3_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_data3_4k_wclk)
        ,.mem_rclk            (rf_tlb_data3_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_data3_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_data3_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_data3_4k_re)
        ,.mem_raddr           (rf_tlb_data3_4k_raddr)
        ,.mem_waddr           (rf_tlb_data3_4k_waddr)
        ,.mem_we              (rf_tlb_data3_4k_we)
        ,.mem_wdata           (rf_tlb_data3_4k_wdata)
        ,.mem_rdata           (rf_tlb_data3_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_data3_4k_rdata_error)
        ,.error               (rf_tlb_data3_4k_error_nc)
);

logic        rf_tlb_data4_4k_rdata_error;

logic        cfg_mem_ack_tlb_data4_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_data4_4k_nc;

logic        rf_tlb_data4_4k_error_nc;
logic [(39)-1:0] pf_tlb_data4_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (39)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_data4_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_data4_4k_re)
        ,.func_mem_raddr      (func_tlb_data4_4k_raddr)
        ,.func_mem_waddr      (func_tlb_data4_4k_waddr)
        ,.func_mem_we         (func_tlb_data4_4k_we)
        ,.func_mem_wdata      (func_tlb_data4_4k_wdata)
        ,.func_mem_rdata      (func_tlb_data4_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_data4_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_data4_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_data4_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_data4_4k_wclk)
        ,.mem_rclk            (rf_tlb_data4_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_data4_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_data4_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_data4_4k_re)
        ,.mem_raddr           (rf_tlb_data4_4k_raddr)
        ,.mem_waddr           (rf_tlb_data4_4k_waddr)
        ,.mem_we              (rf_tlb_data4_4k_we)
        ,.mem_wdata           (rf_tlb_data4_4k_wdata)
        ,.mem_rdata           (rf_tlb_data4_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_data4_4k_rdata_error)
        ,.error               (rf_tlb_data4_4k_error_nc)
);

logic        rf_tlb_data5_4k_rdata_error;

logic        cfg_mem_ack_tlb_data5_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_data5_4k_nc;

logic        rf_tlb_data5_4k_error_nc;
logic [(39)-1:0] pf_tlb_data5_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (39)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_data5_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_data5_4k_re)
        ,.func_mem_raddr      (func_tlb_data5_4k_raddr)
        ,.func_mem_waddr      (func_tlb_data5_4k_waddr)
        ,.func_mem_we         (func_tlb_data5_4k_we)
        ,.func_mem_wdata      (func_tlb_data5_4k_wdata)
        ,.func_mem_rdata      (func_tlb_data5_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_data5_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_data5_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_data5_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_data5_4k_wclk)
        ,.mem_rclk            (rf_tlb_data5_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_data5_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_data5_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_data5_4k_re)
        ,.mem_raddr           (rf_tlb_data5_4k_raddr)
        ,.mem_waddr           (rf_tlb_data5_4k_waddr)
        ,.mem_we              (rf_tlb_data5_4k_we)
        ,.mem_wdata           (rf_tlb_data5_4k_wdata)
        ,.mem_rdata           (rf_tlb_data5_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_data5_4k_rdata_error)
        ,.error               (rf_tlb_data5_4k_error_nc)
);

logic        rf_tlb_data6_4k_rdata_error;

logic        cfg_mem_ack_tlb_data6_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_data6_4k_nc;

logic        rf_tlb_data6_4k_error_nc;
logic [(39)-1:0] pf_tlb_data6_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (39)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_data6_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_data6_4k_re)
        ,.func_mem_raddr      (func_tlb_data6_4k_raddr)
        ,.func_mem_waddr      (func_tlb_data6_4k_waddr)
        ,.func_mem_we         (func_tlb_data6_4k_we)
        ,.func_mem_wdata      (func_tlb_data6_4k_wdata)
        ,.func_mem_rdata      (func_tlb_data6_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_data6_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_data6_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_data6_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_data6_4k_wclk)
        ,.mem_rclk            (rf_tlb_data6_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_data6_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_data6_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_data6_4k_re)
        ,.mem_raddr           (rf_tlb_data6_4k_raddr)
        ,.mem_waddr           (rf_tlb_data6_4k_waddr)
        ,.mem_we              (rf_tlb_data6_4k_we)
        ,.mem_wdata           (rf_tlb_data6_4k_wdata)
        ,.mem_rdata           (rf_tlb_data6_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_data6_4k_rdata_error)
        ,.error               (rf_tlb_data6_4k_error_nc)
);

logic        rf_tlb_data7_4k_rdata_error;

logic        cfg_mem_ack_tlb_data7_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_data7_4k_nc;

logic        rf_tlb_data7_4k_error_nc;
logic [(39)-1:0] pf_tlb_data7_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (39)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_data7_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_data7_4k_re)
        ,.func_mem_raddr      (func_tlb_data7_4k_raddr)
        ,.func_mem_waddr      (func_tlb_data7_4k_waddr)
        ,.func_mem_we         (func_tlb_data7_4k_we)
        ,.func_mem_wdata      (func_tlb_data7_4k_wdata)
        ,.func_mem_rdata      (func_tlb_data7_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_data7_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_data7_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_data7_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_data7_4k_wclk)
        ,.mem_rclk            (rf_tlb_data7_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_data7_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_data7_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_data7_4k_re)
        ,.mem_raddr           (rf_tlb_data7_4k_raddr)
        ,.mem_waddr           (rf_tlb_data7_4k_waddr)
        ,.mem_we              (rf_tlb_data7_4k_we)
        ,.mem_wdata           (rf_tlb_data7_4k_wdata)
        ,.mem_rdata           (rf_tlb_data7_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_data7_4k_rdata_error)
        ,.error               (rf_tlb_data7_4k_error_nc)
);

logic        rf_tlb_tag0_4k_rdata_error;

logic        cfg_mem_ack_tlb_tag0_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_tag0_4k_nc;

logic        rf_tlb_tag0_4k_error_nc;
logic [(85)-1:0] pf_tlb_tag0_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (85)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_tag0_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_tag0_4k_re)
        ,.func_mem_raddr      (func_tlb_tag0_4k_raddr)
        ,.func_mem_waddr      (func_tlb_tag0_4k_waddr)
        ,.func_mem_we         (func_tlb_tag0_4k_we)
        ,.func_mem_wdata      (func_tlb_tag0_4k_wdata)
        ,.func_mem_rdata      (func_tlb_tag0_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_tag0_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_tag0_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_tag0_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_tag0_4k_wclk)
        ,.mem_rclk            (rf_tlb_tag0_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_tag0_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_tag0_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_tag0_4k_re)
        ,.mem_raddr           (rf_tlb_tag0_4k_raddr)
        ,.mem_waddr           (rf_tlb_tag0_4k_waddr)
        ,.mem_we              (rf_tlb_tag0_4k_we)
        ,.mem_wdata           (rf_tlb_tag0_4k_wdata)
        ,.mem_rdata           (rf_tlb_tag0_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_tag0_4k_rdata_error)
        ,.error               (rf_tlb_tag0_4k_error_nc)
);

logic        rf_tlb_tag1_4k_rdata_error;

logic        cfg_mem_ack_tlb_tag1_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_tag1_4k_nc;

logic        rf_tlb_tag1_4k_error_nc;
logic [(85)-1:0] pf_tlb_tag1_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (85)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_tag1_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_tag1_4k_re)
        ,.func_mem_raddr      (func_tlb_tag1_4k_raddr)
        ,.func_mem_waddr      (func_tlb_tag1_4k_waddr)
        ,.func_mem_we         (func_tlb_tag1_4k_we)
        ,.func_mem_wdata      (func_tlb_tag1_4k_wdata)
        ,.func_mem_rdata      (func_tlb_tag1_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_tag1_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_tag1_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_tag1_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_tag1_4k_wclk)
        ,.mem_rclk            (rf_tlb_tag1_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_tag1_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_tag1_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_tag1_4k_re)
        ,.mem_raddr           (rf_tlb_tag1_4k_raddr)
        ,.mem_waddr           (rf_tlb_tag1_4k_waddr)
        ,.mem_we              (rf_tlb_tag1_4k_we)
        ,.mem_wdata           (rf_tlb_tag1_4k_wdata)
        ,.mem_rdata           (rf_tlb_tag1_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_tag1_4k_rdata_error)
        ,.error               (rf_tlb_tag1_4k_error_nc)
);

logic        rf_tlb_tag2_4k_rdata_error;

logic        cfg_mem_ack_tlb_tag2_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_tag2_4k_nc;

logic        rf_tlb_tag2_4k_error_nc;
logic [(85)-1:0] pf_tlb_tag2_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (85)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_tag2_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_tag2_4k_re)
        ,.func_mem_raddr      (func_tlb_tag2_4k_raddr)
        ,.func_mem_waddr      (func_tlb_tag2_4k_waddr)
        ,.func_mem_we         (func_tlb_tag2_4k_we)
        ,.func_mem_wdata      (func_tlb_tag2_4k_wdata)
        ,.func_mem_rdata      (func_tlb_tag2_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_tag2_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_tag2_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_tag2_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_tag2_4k_wclk)
        ,.mem_rclk            (rf_tlb_tag2_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_tag2_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_tag2_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_tag2_4k_re)
        ,.mem_raddr           (rf_tlb_tag2_4k_raddr)
        ,.mem_waddr           (rf_tlb_tag2_4k_waddr)
        ,.mem_we              (rf_tlb_tag2_4k_we)
        ,.mem_wdata           (rf_tlb_tag2_4k_wdata)
        ,.mem_rdata           (rf_tlb_tag2_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_tag2_4k_rdata_error)
        ,.error               (rf_tlb_tag2_4k_error_nc)
);

logic        rf_tlb_tag3_4k_rdata_error;

logic        cfg_mem_ack_tlb_tag3_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_tag3_4k_nc;

logic        rf_tlb_tag3_4k_error_nc;
logic [(85)-1:0] pf_tlb_tag3_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (85)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_tag3_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_tag3_4k_re)
        ,.func_mem_raddr      (func_tlb_tag3_4k_raddr)
        ,.func_mem_waddr      (func_tlb_tag3_4k_waddr)
        ,.func_mem_we         (func_tlb_tag3_4k_we)
        ,.func_mem_wdata      (func_tlb_tag3_4k_wdata)
        ,.func_mem_rdata      (func_tlb_tag3_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_tag3_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_tag3_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_tag3_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_tag3_4k_wclk)
        ,.mem_rclk            (rf_tlb_tag3_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_tag3_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_tag3_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_tag3_4k_re)
        ,.mem_raddr           (rf_tlb_tag3_4k_raddr)
        ,.mem_waddr           (rf_tlb_tag3_4k_waddr)
        ,.mem_we              (rf_tlb_tag3_4k_we)
        ,.mem_wdata           (rf_tlb_tag3_4k_wdata)
        ,.mem_rdata           (rf_tlb_tag3_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_tag3_4k_rdata_error)
        ,.error               (rf_tlb_tag3_4k_error_nc)
);

logic        rf_tlb_tag4_4k_rdata_error;

logic        cfg_mem_ack_tlb_tag4_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_tag4_4k_nc;

logic        rf_tlb_tag4_4k_error_nc;
logic [(85)-1:0] pf_tlb_tag4_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (85)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_tag4_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_tag4_4k_re)
        ,.func_mem_raddr      (func_tlb_tag4_4k_raddr)
        ,.func_mem_waddr      (func_tlb_tag4_4k_waddr)
        ,.func_mem_we         (func_tlb_tag4_4k_we)
        ,.func_mem_wdata      (func_tlb_tag4_4k_wdata)
        ,.func_mem_rdata      (func_tlb_tag4_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_tag4_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_tag4_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_tag4_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_tag4_4k_wclk)
        ,.mem_rclk            (rf_tlb_tag4_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_tag4_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_tag4_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_tag4_4k_re)
        ,.mem_raddr           (rf_tlb_tag4_4k_raddr)
        ,.mem_waddr           (rf_tlb_tag4_4k_waddr)
        ,.mem_we              (rf_tlb_tag4_4k_we)
        ,.mem_wdata           (rf_tlb_tag4_4k_wdata)
        ,.mem_rdata           (rf_tlb_tag4_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_tag4_4k_rdata_error)
        ,.error               (rf_tlb_tag4_4k_error_nc)
);

logic        rf_tlb_tag5_4k_rdata_error;

logic        cfg_mem_ack_tlb_tag5_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_tag5_4k_nc;

logic        rf_tlb_tag5_4k_error_nc;
logic [(85)-1:0] pf_tlb_tag5_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (85)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_tag5_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_tag5_4k_re)
        ,.func_mem_raddr      (func_tlb_tag5_4k_raddr)
        ,.func_mem_waddr      (func_tlb_tag5_4k_waddr)
        ,.func_mem_we         (func_tlb_tag5_4k_we)
        ,.func_mem_wdata      (func_tlb_tag5_4k_wdata)
        ,.func_mem_rdata      (func_tlb_tag5_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_tag5_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_tag5_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_tag5_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_tag5_4k_wclk)
        ,.mem_rclk            (rf_tlb_tag5_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_tag5_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_tag5_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_tag5_4k_re)
        ,.mem_raddr           (rf_tlb_tag5_4k_raddr)
        ,.mem_waddr           (rf_tlb_tag5_4k_waddr)
        ,.mem_we              (rf_tlb_tag5_4k_we)
        ,.mem_wdata           (rf_tlb_tag5_4k_wdata)
        ,.mem_rdata           (rf_tlb_tag5_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_tag5_4k_rdata_error)
        ,.error               (rf_tlb_tag5_4k_error_nc)
);

logic        rf_tlb_tag6_4k_rdata_error;

logic        cfg_mem_ack_tlb_tag6_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_tag6_4k_nc;

logic        rf_tlb_tag6_4k_error_nc;
logic [(85)-1:0] pf_tlb_tag6_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (85)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_tag6_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_tag6_4k_re)
        ,.func_mem_raddr      (func_tlb_tag6_4k_raddr)
        ,.func_mem_waddr      (func_tlb_tag6_4k_waddr)
        ,.func_mem_we         (func_tlb_tag6_4k_we)
        ,.func_mem_wdata      (func_tlb_tag6_4k_wdata)
        ,.func_mem_rdata      (func_tlb_tag6_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_tag6_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_tag6_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_tag6_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_tag6_4k_wclk)
        ,.mem_rclk            (rf_tlb_tag6_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_tag6_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_tag6_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_tag6_4k_re)
        ,.mem_raddr           (rf_tlb_tag6_4k_raddr)
        ,.mem_waddr           (rf_tlb_tag6_4k_waddr)
        ,.mem_we              (rf_tlb_tag6_4k_we)
        ,.mem_wdata           (rf_tlb_tag6_4k_wdata)
        ,.mem_rdata           (rf_tlb_tag6_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_tag6_4k_rdata_error)
        ,.error               (rf_tlb_tag6_4k_error_nc)
);

logic        rf_tlb_tag7_4k_rdata_error;

logic        cfg_mem_ack_tlb_tag7_4k_nc;
logic [31:0] cfg_mem_rdata_tlb_tag7_4k_nc;

logic        rf_tlb_tag7_4k_error_nc;
logic [(85)-1:0] pf_tlb_tag7_4k_rdata_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (85)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_tlb_tag7_4k (
         .clk                 (prim_nonflr_clk)
        ,.rst_n               (prim_gated_rst_b)

        ,.func_mem_re         (func_tlb_tag7_4k_re)
        ,.func_mem_raddr      (func_tlb_tag7_4k_raddr)
        ,.func_mem_waddr      (func_tlb_tag7_4k_waddr)
        ,.func_mem_we         (func_tlb_tag7_4k_we)
        ,.func_mem_wdata      (func_tlb_tag7_4k_wdata)
        ,.func_mem_rdata      (func_tlb_tag7_4k_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_tlb_tag7_4k_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_tlb_tag7_4k_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           ('0)
        ,.pf_mem_raddr        ('0)
        ,.pf_mem_waddr        ('0)
        ,.pf_mem_we           ('0)
        ,.pf_mem_wdata        ('0)
        ,.pf_mem_rdata        (pf_tlb_tag7_4k_rdata_nc)

        ,.mem_wclk            (rf_tlb_tag7_4k_wclk)
        ,.mem_rclk            (rf_tlb_tag7_4k_rclk)
        ,.mem_wclk_rst_n      (rf_tlb_tag7_4k_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_tlb_tag7_4k_rclk_rst_n)
        ,.mem_re              (rf_tlb_tag7_4k_re)
        ,.mem_raddr           (rf_tlb_tag7_4k_raddr)
        ,.mem_waddr           (rf_tlb_tag7_4k_waddr)
        ,.mem_we              (rf_tlb_tag7_4k_we)
        ,.mem_wdata           (rf_tlb_tag7_4k_wdata)
        ,.mem_rdata           (rf_tlb_tag7_4k_rdata)

        ,.mem_rdata_error     (rf_tlb_tag7_4k_rdata_error)
        ,.error               (rf_tlb_tag7_4k_error_nc)
);

assign hqm_sif_rfw_top_ipar_error = rf_ibcpl_data_fifo_rdata_error | rf_ibcpl_hdr_fifo_rdata_error | rf_mstr_ll_data0_rdata_error | rf_mstr_ll_data1_rdata_error | rf_mstr_ll_data2_rdata_error | rf_mstr_ll_data3_rdata_error | rf_mstr_ll_hdr_rdata_error | rf_mstr_ll_hpa_rdata_error | rf_ri_tlq_fifo_npdata_rdata_error | rf_ri_tlq_fifo_nphdr_rdata_error | rf_ri_tlq_fifo_pdata_rdata_error | rf_ri_tlq_fifo_phdr_rdata_error | rf_scrbd_mem_rdata_error | rf_tlb_data0_4k_rdata_error | rf_tlb_data1_4k_rdata_error | rf_tlb_data2_4k_rdata_error | rf_tlb_data3_4k_rdata_error | rf_tlb_data4_4k_rdata_error | rf_tlb_data5_4k_rdata_error | rf_tlb_data6_4k_rdata_error | rf_tlb_data7_4k_rdata_error | rf_tlb_tag0_4k_rdata_error | rf_tlb_tag1_4k_rdata_error | rf_tlb_tag2_4k_rdata_error | rf_tlb_tag3_4k_rdata_error | rf_tlb_tag4_4k_rdata_error | rf_tlb_tag5_4k_rdata_error | rf_tlb_tag6_4k_rdata_error | rf_tlb_tag7_4k_rdata_error ;

endmodule

