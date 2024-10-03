module hqm_system_mem_prim_clk_rf_cont (

     input  logic                        rf_ibcpl_data_fifo_wclk
    ,input  logic                        rf_ibcpl_data_fifo_wclk_rst_n
    ,input  logic                        rf_ibcpl_data_fifo_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_ibcpl_data_fifo_waddr
    ,input  logic [ (  66 ) -1 : 0 ]     rf_ibcpl_data_fifo_wdata
    ,input  logic                        rf_ibcpl_data_fifo_rclk
    ,input  logic                        rf_ibcpl_data_fifo_rclk_rst_n
    ,input  logic                        rf_ibcpl_data_fifo_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_ibcpl_data_fifo_raddr
    ,output logic [ (  66 ) -1 : 0 ]     rf_ibcpl_data_fifo_rdata

    ,input  logic                        rf_ibcpl_hdr_fifo_wclk
    ,input  logic                        rf_ibcpl_hdr_fifo_wclk_rst_n
    ,input  logic                        rf_ibcpl_hdr_fifo_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_ibcpl_hdr_fifo_waddr
    ,input  logic [ (  20 ) -1 : 0 ]     rf_ibcpl_hdr_fifo_wdata
    ,input  logic                        rf_ibcpl_hdr_fifo_rclk
    ,input  logic                        rf_ibcpl_hdr_fifo_rclk_rst_n
    ,input  logic                        rf_ibcpl_hdr_fifo_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_ibcpl_hdr_fifo_raddr
    ,output logic [ (  20 ) -1 : 0 ]     rf_ibcpl_hdr_fifo_rdata

    ,input  logic                        rf_mstr_ll_data0_wclk
    ,input  logic                        rf_mstr_ll_data0_wclk_rst_n
    ,input  logic                        rf_mstr_ll_data0_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_mstr_ll_data0_waddr
    ,input  logic [ ( 129 ) -1 : 0 ]     rf_mstr_ll_data0_wdata
    ,input  logic                        rf_mstr_ll_data0_rclk
    ,input  logic                        rf_mstr_ll_data0_rclk_rst_n
    ,input  logic                        rf_mstr_ll_data0_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_mstr_ll_data0_raddr
    ,output logic [ ( 129 ) -1 : 0 ]     rf_mstr_ll_data0_rdata

    ,input  logic                        rf_mstr_ll_data1_wclk
    ,input  logic                        rf_mstr_ll_data1_wclk_rst_n
    ,input  logic                        rf_mstr_ll_data1_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_mstr_ll_data1_waddr
    ,input  logic [ ( 129 ) -1 : 0 ]     rf_mstr_ll_data1_wdata
    ,input  logic                        rf_mstr_ll_data1_rclk
    ,input  logic                        rf_mstr_ll_data1_rclk_rst_n
    ,input  logic                        rf_mstr_ll_data1_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_mstr_ll_data1_raddr
    ,output logic [ ( 129 ) -1 : 0 ]     rf_mstr_ll_data1_rdata

    ,input  logic                        rf_mstr_ll_data2_wclk
    ,input  logic                        rf_mstr_ll_data2_wclk_rst_n
    ,input  logic                        rf_mstr_ll_data2_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_mstr_ll_data2_waddr
    ,input  logic [ ( 129 ) -1 : 0 ]     rf_mstr_ll_data2_wdata
    ,input  logic                        rf_mstr_ll_data2_rclk
    ,input  logic                        rf_mstr_ll_data2_rclk_rst_n
    ,input  logic                        rf_mstr_ll_data2_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_mstr_ll_data2_raddr
    ,output logic [ ( 129 ) -1 : 0 ]     rf_mstr_ll_data2_rdata

    ,input  logic                        rf_mstr_ll_data3_wclk
    ,input  logic                        rf_mstr_ll_data3_wclk_rst_n
    ,input  logic                        rf_mstr_ll_data3_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_mstr_ll_data3_waddr
    ,input  logic [ ( 129 ) -1 : 0 ]     rf_mstr_ll_data3_wdata
    ,input  logic                        rf_mstr_ll_data3_rclk
    ,input  logic                        rf_mstr_ll_data3_rclk_rst_n
    ,input  logic                        rf_mstr_ll_data3_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_mstr_ll_data3_raddr
    ,output logic [ ( 129 ) -1 : 0 ]     rf_mstr_ll_data3_rdata

    ,input  logic                        rf_mstr_ll_hdr_wclk
    ,input  logic                        rf_mstr_ll_hdr_wclk_rst_n
    ,input  logic                        rf_mstr_ll_hdr_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_mstr_ll_hdr_waddr
    ,input  logic [ ( 153 ) -1 : 0 ]     rf_mstr_ll_hdr_wdata
    ,input  logic                        rf_mstr_ll_hdr_rclk
    ,input  logic                        rf_mstr_ll_hdr_rclk_rst_n
    ,input  logic                        rf_mstr_ll_hdr_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_mstr_ll_hdr_raddr
    ,output logic [ ( 153 ) -1 : 0 ]     rf_mstr_ll_hdr_rdata

    ,input  logic                        rf_mstr_ll_hpa_wclk
    ,input  logic                        rf_mstr_ll_hpa_wclk_rst_n
    ,input  logic                        rf_mstr_ll_hpa_we
    ,input  logic [ (   7 ) -1 : 0 ]     rf_mstr_ll_hpa_waddr
    ,input  logic [ (  35 ) -1 : 0 ]     rf_mstr_ll_hpa_wdata
    ,input  logic                        rf_mstr_ll_hpa_rclk
    ,input  logic                        rf_mstr_ll_hpa_rclk_rst_n
    ,input  logic                        rf_mstr_ll_hpa_re
    ,input  logic [ (   7 ) -1 : 0 ]     rf_mstr_ll_hpa_raddr
    ,output logic [ (  35 ) -1 : 0 ]     rf_mstr_ll_hpa_rdata

    ,input  logic                        rf_ri_tlq_fifo_npdata_wclk
    ,input  logic                        rf_ri_tlq_fifo_npdata_wclk_rst_n
    ,input  logic                        rf_ri_tlq_fifo_npdata_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_ri_tlq_fifo_npdata_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_ri_tlq_fifo_npdata_wdata
    ,input  logic                        rf_ri_tlq_fifo_npdata_rclk
    ,input  logic                        rf_ri_tlq_fifo_npdata_rclk_rst_n
    ,input  logic                        rf_ri_tlq_fifo_npdata_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_ri_tlq_fifo_npdata_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_ri_tlq_fifo_npdata_rdata

    ,input  logic                        rf_ri_tlq_fifo_nphdr_wclk
    ,input  logic                        rf_ri_tlq_fifo_nphdr_wclk_rst_n
    ,input  logic                        rf_ri_tlq_fifo_nphdr_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_ri_tlq_fifo_nphdr_waddr
    ,input  logic [ ( 158 ) -1 : 0 ]     rf_ri_tlq_fifo_nphdr_wdata
    ,input  logic                        rf_ri_tlq_fifo_nphdr_rclk
    ,input  logic                        rf_ri_tlq_fifo_nphdr_rclk_rst_n
    ,input  logic                        rf_ri_tlq_fifo_nphdr_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_ri_tlq_fifo_nphdr_raddr
    ,output logic [ ( 158 ) -1 : 0 ]     rf_ri_tlq_fifo_nphdr_rdata

    ,input  logic                        rf_ri_tlq_fifo_pdata_wclk
    ,input  logic                        rf_ri_tlq_fifo_pdata_wclk_rst_n
    ,input  logic                        rf_ri_tlq_fifo_pdata_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ri_tlq_fifo_pdata_waddr
    ,input  logic [ ( 264 ) -1 : 0 ]     rf_ri_tlq_fifo_pdata_wdata
    ,input  logic                        rf_ri_tlq_fifo_pdata_rclk
    ,input  logic                        rf_ri_tlq_fifo_pdata_rclk_rst_n
    ,input  logic                        rf_ri_tlq_fifo_pdata_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ri_tlq_fifo_pdata_raddr
    ,output logic [ ( 264 ) -1 : 0 ]     rf_ri_tlq_fifo_pdata_rdata

    ,input  logic                        rf_ri_tlq_fifo_phdr_wclk
    ,input  logic                        rf_ri_tlq_fifo_phdr_wclk_rst_n
    ,input  logic                        rf_ri_tlq_fifo_phdr_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_ri_tlq_fifo_phdr_waddr
    ,input  logic [ ( 153 ) -1 : 0 ]     rf_ri_tlq_fifo_phdr_wdata
    ,input  logic                        rf_ri_tlq_fifo_phdr_rclk
    ,input  logic                        rf_ri_tlq_fifo_phdr_rclk_rst_n
    ,input  logic                        rf_ri_tlq_fifo_phdr_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_ri_tlq_fifo_phdr_raddr
    ,output logic [ ( 153 ) -1 : 0 ]     rf_ri_tlq_fifo_phdr_rdata

    ,input  logic                        rf_scrbd_mem_wclk
    ,input  logic                        rf_scrbd_mem_wclk_rst_n
    ,input  logic                        rf_scrbd_mem_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_scrbd_mem_waddr
    ,input  logic [ (  10 ) -1 : 0 ]     rf_scrbd_mem_wdata
    ,input  logic                        rf_scrbd_mem_rclk
    ,input  logic                        rf_scrbd_mem_rclk_rst_n
    ,input  logic                        rf_scrbd_mem_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_scrbd_mem_raddr
    ,output logic [ (  10 ) -1 : 0 ]     rf_scrbd_mem_rdata

    ,input  logic                        rf_tlb_data0_4k_wclk
    ,input  logic                        rf_tlb_data0_4k_wclk_rst_n
    ,input  logic                        rf_tlb_data0_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data0_4k_waddr
    ,input  logic [ (  39 ) -1 : 0 ]     rf_tlb_data0_4k_wdata
    ,input  logic                        rf_tlb_data0_4k_rclk
    ,input  logic                        rf_tlb_data0_4k_rclk_rst_n
    ,input  logic                        rf_tlb_data0_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data0_4k_raddr
    ,output logic [ (  39 ) -1 : 0 ]     rf_tlb_data0_4k_rdata

    ,input  logic                        rf_tlb_data1_4k_wclk
    ,input  logic                        rf_tlb_data1_4k_wclk_rst_n
    ,input  logic                        rf_tlb_data1_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data1_4k_waddr
    ,input  logic [ (  39 ) -1 : 0 ]     rf_tlb_data1_4k_wdata
    ,input  logic                        rf_tlb_data1_4k_rclk
    ,input  logic                        rf_tlb_data1_4k_rclk_rst_n
    ,input  logic                        rf_tlb_data1_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data1_4k_raddr
    ,output logic [ (  39 ) -1 : 0 ]     rf_tlb_data1_4k_rdata

    ,input  logic                        rf_tlb_data2_4k_wclk
    ,input  logic                        rf_tlb_data2_4k_wclk_rst_n
    ,input  logic                        rf_tlb_data2_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data2_4k_waddr
    ,input  logic [ (  39 ) -1 : 0 ]     rf_tlb_data2_4k_wdata
    ,input  logic                        rf_tlb_data2_4k_rclk
    ,input  logic                        rf_tlb_data2_4k_rclk_rst_n
    ,input  logic                        rf_tlb_data2_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data2_4k_raddr
    ,output logic [ (  39 ) -1 : 0 ]     rf_tlb_data2_4k_rdata

    ,input  logic                        rf_tlb_data3_4k_wclk
    ,input  logic                        rf_tlb_data3_4k_wclk_rst_n
    ,input  logic                        rf_tlb_data3_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data3_4k_waddr
    ,input  logic [ (  39 ) -1 : 0 ]     rf_tlb_data3_4k_wdata
    ,input  logic                        rf_tlb_data3_4k_rclk
    ,input  logic                        rf_tlb_data3_4k_rclk_rst_n
    ,input  logic                        rf_tlb_data3_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data3_4k_raddr
    ,output logic [ (  39 ) -1 : 0 ]     rf_tlb_data3_4k_rdata

    ,input  logic                        rf_tlb_data4_4k_wclk
    ,input  logic                        rf_tlb_data4_4k_wclk_rst_n
    ,input  logic                        rf_tlb_data4_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data4_4k_waddr
    ,input  logic [ (  39 ) -1 : 0 ]     rf_tlb_data4_4k_wdata
    ,input  logic                        rf_tlb_data4_4k_rclk
    ,input  logic                        rf_tlb_data4_4k_rclk_rst_n
    ,input  logic                        rf_tlb_data4_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data4_4k_raddr
    ,output logic [ (  39 ) -1 : 0 ]     rf_tlb_data4_4k_rdata

    ,input  logic                        rf_tlb_data5_4k_wclk
    ,input  logic                        rf_tlb_data5_4k_wclk_rst_n
    ,input  logic                        rf_tlb_data5_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data5_4k_waddr
    ,input  logic [ (  39 ) -1 : 0 ]     rf_tlb_data5_4k_wdata
    ,input  logic                        rf_tlb_data5_4k_rclk
    ,input  logic                        rf_tlb_data5_4k_rclk_rst_n
    ,input  logic                        rf_tlb_data5_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data5_4k_raddr
    ,output logic [ (  39 ) -1 : 0 ]     rf_tlb_data5_4k_rdata

    ,input  logic                        rf_tlb_data6_4k_wclk
    ,input  logic                        rf_tlb_data6_4k_wclk_rst_n
    ,input  logic                        rf_tlb_data6_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data6_4k_waddr
    ,input  logic [ (  39 ) -1 : 0 ]     rf_tlb_data6_4k_wdata
    ,input  logic                        rf_tlb_data6_4k_rclk
    ,input  logic                        rf_tlb_data6_4k_rclk_rst_n
    ,input  logic                        rf_tlb_data6_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data6_4k_raddr
    ,output logic [ (  39 ) -1 : 0 ]     rf_tlb_data6_4k_rdata

    ,input  logic                        rf_tlb_data7_4k_wclk
    ,input  logic                        rf_tlb_data7_4k_wclk_rst_n
    ,input  logic                        rf_tlb_data7_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data7_4k_waddr
    ,input  logic [ (  39 ) -1 : 0 ]     rf_tlb_data7_4k_wdata
    ,input  logic                        rf_tlb_data7_4k_rclk
    ,input  logic                        rf_tlb_data7_4k_rclk_rst_n
    ,input  logic                        rf_tlb_data7_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_data7_4k_raddr
    ,output logic [ (  39 ) -1 : 0 ]     rf_tlb_data7_4k_rdata

    ,input  logic                        rf_tlb_tag0_4k_wclk
    ,input  logic                        rf_tlb_tag0_4k_wclk_rst_n
    ,input  logic                        rf_tlb_tag0_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag0_4k_waddr
    ,input  logic [ (  85 ) -1 : 0 ]     rf_tlb_tag0_4k_wdata
    ,input  logic                        rf_tlb_tag0_4k_rclk
    ,input  logic                        rf_tlb_tag0_4k_rclk_rst_n
    ,input  logic                        rf_tlb_tag0_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag0_4k_raddr
    ,output logic [ (  85 ) -1 : 0 ]     rf_tlb_tag0_4k_rdata

    ,input  logic                        rf_tlb_tag1_4k_wclk
    ,input  logic                        rf_tlb_tag1_4k_wclk_rst_n
    ,input  logic                        rf_tlb_tag1_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag1_4k_waddr
    ,input  logic [ (  85 ) -1 : 0 ]     rf_tlb_tag1_4k_wdata
    ,input  logic                        rf_tlb_tag1_4k_rclk
    ,input  logic                        rf_tlb_tag1_4k_rclk_rst_n
    ,input  logic                        rf_tlb_tag1_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag1_4k_raddr
    ,output logic [ (  85 ) -1 : 0 ]     rf_tlb_tag1_4k_rdata

    ,input  logic                        rf_tlb_tag2_4k_wclk
    ,input  logic                        rf_tlb_tag2_4k_wclk_rst_n
    ,input  logic                        rf_tlb_tag2_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag2_4k_waddr
    ,input  logic [ (  85 ) -1 : 0 ]     rf_tlb_tag2_4k_wdata
    ,input  logic                        rf_tlb_tag2_4k_rclk
    ,input  logic                        rf_tlb_tag2_4k_rclk_rst_n
    ,input  logic                        rf_tlb_tag2_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag2_4k_raddr
    ,output logic [ (  85 ) -1 : 0 ]     rf_tlb_tag2_4k_rdata

    ,input  logic                        rf_tlb_tag3_4k_wclk
    ,input  logic                        rf_tlb_tag3_4k_wclk_rst_n
    ,input  logic                        rf_tlb_tag3_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag3_4k_waddr
    ,input  logic [ (  85 ) -1 : 0 ]     rf_tlb_tag3_4k_wdata
    ,input  logic                        rf_tlb_tag3_4k_rclk
    ,input  logic                        rf_tlb_tag3_4k_rclk_rst_n
    ,input  logic                        rf_tlb_tag3_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag3_4k_raddr
    ,output logic [ (  85 ) -1 : 0 ]     rf_tlb_tag3_4k_rdata

    ,input  logic                        rf_tlb_tag4_4k_wclk
    ,input  logic                        rf_tlb_tag4_4k_wclk_rst_n
    ,input  logic                        rf_tlb_tag4_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag4_4k_waddr
    ,input  logic [ (  85 ) -1 : 0 ]     rf_tlb_tag4_4k_wdata
    ,input  logic                        rf_tlb_tag4_4k_rclk
    ,input  logic                        rf_tlb_tag4_4k_rclk_rst_n
    ,input  logic                        rf_tlb_tag4_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag4_4k_raddr
    ,output logic [ (  85 ) -1 : 0 ]     rf_tlb_tag4_4k_rdata

    ,input  logic                        rf_tlb_tag5_4k_wclk
    ,input  logic                        rf_tlb_tag5_4k_wclk_rst_n
    ,input  logic                        rf_tlb_tag5_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag5_4k_waddr
    ,input  logic [ (  85 ) -1 : 0 ]     rf_tlb_tag5_4k_wdata
    ,input  logic                        rf_tlb_tag5_4k_rclk
    ,input  logic                        rf_tlb_tag5_4k_rclk_rst_n
    ,input  logic                        rf_tlb_tag5_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag5_4k_raddr
    ,output logic [ (  85 ) -1 : 0 ]     rf_tlb_tag5_4k_rdata

    ,input  logic                        rf_tlb_tag6_4k_wclk
    ,input  logic                        rf_tlb_tag6_4k_wclk_rst_n
    ,input  logic                        rf_tlb_tag6_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag6_4k_waddr
    ,input  logic [ (  85 ) -1 : 0 ]     rf_tlb_tag6_4k_wdata
    ,input  logic                        rf_tlb_tag6_4k_rclk
    ,input  logic                        rf_tlb_tag6_4k_rclk_rst_n
    ,input  logic                        rf_tlb_tag6_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag6_4k_raddr
    ,output logic [ (  85 ) -1 : 0 ]     rf_tlb_tag6_4k_rdata

    ,input  logic                        rf_tlb_tag7_4k_wclk
    ,input  logic                        rf_tlb_tag7_4k_wclk_rst_n
    ,input  logic                        rf_tlb_tag7_4k_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag7_4k_waddr
    ,input  logic [ (  85 ) -1 : 0 ]     rf_tlb_tag7_4k_wdata
    ,input  logic                        rf_tlb_tag7_4k_rclk
    ,input  logic                        rf_tlb_tag7_4k_rclk_rst_n
    ,input  logic                        rf_tlb_tag7_4k_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_tlb_tag7_4k_raddr
    ,output logic [ (  85 ) -1 : 0 ]     rf_tlb_tag7_4k_rdata

    ,input  logic                        powergood_rst_b

    ,input  logic                        fscan_byprst_b
    ,input  logic                        fscan_clkungate
    ,input  logic                        fscan_rstbypen
);

logic ip_reset_b;

assign ip_reset_b = powergood_rst_b;

hqm_system_mem_AW_rf_256x66 i_rf_ibcpl_data_fifo (

     .wclk                    (rf_ibcpl_data_fifo_wclk)
    ,.wclk_rst_n              (rf_ibcpl_data_fifo_wclk_rst_n)
    ,.we                      (rf_ibcpl_data_fifo_we)
    ,.waddr                   (rf_ibcpl_data_fifo_waddr)
    ,.wdata                   (rf_ibcpl_data_fifo_wdata)
    ,.rclk                    (rf_ibcpl_data_fifo_rclk)
    ,.rclk_rst_n              (rf_ibcpl_data_fifo_rclk_rst_n)
    ,.re                      (rf_ibcpl_data_fifo_re)
    ,.raddr                   (rf_ibcpl_data_fifo_raddr)
    ,.rdata                   (rf_ibcpl_data_fifo_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_256x20 i_rf_ibcpl_hdr_fifo (

     .wclk                    (rf_ibcpl_hdr_fifo_wclk)
    ,.wclk_rst_n              (rf_ibcpl_hdr_fifo_wclk_rst_n)
    ,.we                      (rf_ibcpl_hdr_fifo_we)
    ,.waddr                   (rf_ibcpl_hdr_fifo_waddr)
    ,.wdata                   (rf_ibcpl_hdr_fifo_wdata)
    ,.rclk                    (rf_ibcpl_hdr_fifo_rclk)
    ,.rclk_rst_n              (rf_ibcpl_hdr_fifo_rclk_rst_n)
    ,.re                      (rf_ibcpl_hdr_fifo_re)
    ,.raddr                   (rf_ibcpl_hdr_fifo_raddr)
    ,.rdata                   (rf_ibcpl_hdr_fifo_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_256x129 i_rf_mstr_ll_data0 (

     .wclk                    (rf_mstr_ll_data0_wclk)
    ,.wclk_rst_n              (rf_mstr_ll_data0_wclk_rst_n)
    ,.we                      (rf_mstr_ll_data0_we)
    ,.waddr                   (rf_mstr_ll_data0_waddr)
    ,.wdata                   (rf_mstr_ll_data0_wdata)
    ,.rclk                    (rf_mstr_ll_data0_rclk)
    ,.rclk_rst_n              (rf_mstr_ll_data0_rclk_rst_n)
    ,.re                      (rf_mstr_ll_data0_re)
    ,.raddr                   (rf_mstr_ll_data0_raddr)
    ,.rdata                   (rf_mstr_ll_data0_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_256x129 i_rf_mstr_ll_data1 (

     .wclk                    (rf_mstr_ll_data1_wclk)
    ,.wclk_rst_n              (rf_mstr_ll_data1_wclk_rst_n)
    ,.we                      (rf_mstr_ll_data1_we)
    ,.waddr                   (rf_mstr_ll_data1_waddr)
    ,.wdata                   (rf_mstr_ll_data1_wdata)
    ,.rclk                    (rf_mstr_ll_data1_rclk)
    ,.rclk_rst_n              (rf_mstr_ll_data1_rclk_rst_n)
    ,.re                      (rf_mstr_ll_data1_re)
    ,.raddr                   (rf_mstr_ll_data1_raddr)
    ,.rdata                   (rf_mstr_ll_data1_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_256x129 i_rf_mstr_ll_data2 (

     .wclk                    (rf_mstr_ll_data2_wclk)
    ,.wclk_rst_n              (rf_mstr_ll_data2_wclk_rst_n)
    ,.we                      (rf_mstr_ll_data2_we)
    ,.waddr                   (rf_mstr_ll_data2_waddr)
    ,.wdata                   (rf_mstr_ll_data2_wdata)
    ,.rclk                    (rf_mstr_ll_data2_rclk)
    ,.rclk_rst_n              (rf_mstr_ll_data2_rclk_rst_n)
    ,.re                      (rf_mstr_ll_data2_re)
    ,.raddr                   (rf_mstr_ll_data2_raddr)
    ,.rdata                   (rf_mstr_ll_data2_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_256x129 i_rf_mstr_ll_data3 (

     .wclk                    (rf_mstr_ll_data3_wclk)
    ,.wclk_rst_n              (rf_mstr_ll_data3_wclk_rst_n)
    ,.we                      (rf_mstr_ll_data3_we)
    ,.waddr                   (rf_mstr_ll_data3_waddr)
    ,.wdata                   (rf_mstr_ll_data3_wdata)
    ,.rclk                    (rf_mstr_ll_data3_rclk)
    ,.rclk_rst_n              (rf_mstr_ll_data3_rclk_rst_n)
    ,.re                      (rf_mstr_ll_data3_re)
    ,.raddr                   (rf_mstr_ll_data3_raddr)
    ,.rdata                   (rf_mstr_ll_data3_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_256x153 i_rf_mstr_ll_hdr (

     .wclk                    (rf_mstr_ll_hdr_wclk)
    ,.wclk_rst_n              (rf_mstr_ll_hdr_wclk_rst_n)
    ,.we                      (rf_mstr_ll_hdr_we)
    ,.waddr                   (rf_mstr_ll_hdr_waddr)
    ,.wdata                   (rf_mstr_ll_hdr_wdata)
    ,.rclk                    (rf_mstr_ll_hdr_rclk)
    ,.rclk_rst_n              (rf_mstr_ll_hdr_rclk_rst_n)
    ,.re                      (rf_mstr_ll_hdr_re)
    ,.raddr                   (rf_mstr_ll_hdr_raddr)
    ,.rdata                   (rf_mstr_ll_hdr_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_128x35 i_rf_mstr_ll_hpa (

     .wclk                    (rf_mstr_ll_hpa_wclk)
    ,.wclk_rst_n              (rf_mstr_ll_hpa_wclk_rst_n)
    ,.we                      (rf_mstr_ll_hpa_we)
    ,.waddr                   (rf_mstr_ll_hpa_waddr)
    ,.wdata                   (rf_mstr_ll_hpa_wdata)
    ,.rclk                    (rf_mstr_ll_hpa_rclk)
    ,.rclk_rst_n              (rf_mstr_ll_hpa_rclk_rst_n)
    ,.re                      (rf_mstr_ll_hpa_re)
    ,.raddr                   (rf_mstr_ll_hpa_raddr)
    ,.rdata                   (rf_mstr_ll_hpa_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_8x33 i_rf_ri_tlq_fifo_npdata (

     .wclk                    (rf_ri_tlq_fifo_npdata_wclk)
    ,.wclk_rst_n              (rf_ri_tlq_fifo_npdata_wclk_rst_n)
    ,.we                      (rf_ri_tlq_fifo_npdata_we)
    ,.waddr                   (rf_ri_tlq_fifo_npdata_waddr)
    ,.wdata                   (rf_ri_tlq_fifo_npdata_wdata)
    ,.rclk                    (rf_ri_tlq_fifo_npdata_rclk)
    ,.rclk_rst_n              (rf_ri_tlq_fifo_npdata_rclk_rst_n)
    ,.re                      (rf_ri_tlq_fifo_npdata_re)
    ,.raddr                   (rf_ri_tlq_fifo_npdata_raddr)
    ,.rdata                   (rf_ri_tlq_fifo_npdata_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_8x158 i_rf_ri_tlq_fifo_nphdr (

     .wclk                    (rf_ri_tlq_fifo_nphdr_wclk)
    ,.wclk_rst_n              (rf_ri_tlq_fifo_nphdr_wclk_rst_n)
    ,.we                      (rf_ri_tlq_fifo_nphdr_we)
    ,.waddr                   (rf_ri_tlq_fifo_nphdr_waddr)
    ,.wdata                   (rf_ri_tlq_fifo_nphdr_wdata)
    ,.rclk                    (rf_ri_tlq_fifo_nphdr_rclk)
    ,.rclk_rst_n              (rf_ri_tlq_fifo_nphdr_rclk_rst_n)
    ,.re                      (rf_ri_tlq_fifo_nphdr_re)
    ,.raddr                   (rf_ri_tlq_fifo_nphdr_raddr)
    ,.rdata                   (rf_ri_tlq_fifo_nphdr_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_32x264 i_rf_ri_tlq_fifo_pdata (

     .wclk                    (rf_ri_tlq_fifo_pdata_wclk)
    ,.wclk_rst_n              (rf_ri_tlq_fifo_pdata_wclk_rst_n)
    ,.we                      (rf_ri_tlq_fifo_pdata_we)
    ,.waddr                   (rf_ri_tlq_fifo_pdata_waddr)
    ,.wdata                   (rf_ri_tlq_fifo_pdata_wdata)
    ,.rclk                    (rf_ri_tlq_fifo_pdata_rclk)
    ,.rclk_rst_n              (rf_ri_tlq_fifo_pdata_rclk_rst_n)
    ,.re                      (rf_ri_tlq_fifo_pdata_re)
    ,.raddr                   (rf_ri_tlq_fifo_pdata_raddr)
    ,.rdata                   (rf_ri_tlq_fifo_pdata_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x153 i_rf_ri_tlq_fifo_phdr (

     .wclk                    (rf_ri_tlq_fifo_phdr_wclk)
    ,.wclk_rst_n              (rf_ri_tlq_fifo_phdr_wclk_rst_n)
    ,.we                      (rf_ri_tlq_fifo_phdr_we)
    ,.waddr                   (rf_ri_tlq_fifo_phdr_waddr)
    ,.wdata                   (rf_ri_tlq_fifo_phdr_wdata)
    ,.rclk                    (rf_ri_tlq_fifo_phdr_rclk)
    ,.rclk_rst_n              (rf_ri_tlq_fifo_phdr_rclk_rst_n)
    ,.re                      (rf_ri_tlq_fifo_phdr_re)
    ,.raddr                   (rf_ri_tlq_fifo_phdr_raddr)
    ,.rdata                   (rf_ri_tlq_fifo_phdr_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_256x10 i_rf_scrbd_mem (

     .wclk                    (rf_scrbd_mem_wclk)
    ,.wclk_rst_n              (rf_scrbd_mem_wclk_rst_n)
    ,.we                      (rf_scrbd_mem_we)
    ,.waddr                   (rf_scrbd_mem_waddr)
    ,.wdata                   (rf_scrbd_mem_wdata)
    ,.rclk                    (rf_scrbd_mem_rclk)
    ,.rclk_rst_n              (rf_scrbd_mem_rclk_rst_n)
    ,.re                      (rf_scrbd_mem_re)
    ,.raddr                   (rf_scrbd_mem_raddr)
    ,.rdata                   (rf_scrbd_mem_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x39 i_rf_tlb_data0_4k (

     .wclk                    (rf_tlb_data0_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_data0_4k_wclk_rst_n)
    ,.we                      (rf_tlb_data0_4k_we)
    ,.waddr                   (rf_tlb_data0_4k_waddr)
    ,.wdata                   (rf_tlb_data0_4k_wdata)
    ,.rclk                    (rf_tlb_data0_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_data0_4k_rclk_rst_n)
    ,.re                      (rf_tlb_data0_4k_re)
    ,.raddr                   (rf_tlb_data0_4k_raddr)
    ,.rdata                   (rf_tlb_data0_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x39 i_rf_tlb_data1_4k (

     .wclk                    (rf_tlb_data1_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_data1_4k_wclk_rst_n)
    ,.we                      (rf_tlb_data1_4k_we)
    ,.waddr                   (rf_tlb_data1_4k_waddr)
    ,.wdata                   (rf_tlb_data1_4k_wdata)
    ,.rclk                    (rf_tlb_data1_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_data1_4k_rclk_rst_n)
    ,.re                      (rf_tlb_data1_4k_re)
    ,.raddr                   (rf_tlb_data1_4k_raddr)
    ,.rdata                   (rf_tlb_data1_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x39 i_rf_tlb_data2_4k (

     .wclk                    (rf_tlb_data2_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_data2_4k_wclk_rst_n)
    ,.we                      (rf_tlb_data2_4k_we)
    ,.waddr                   (rf_tlb_data2_4k_waddr)
    ,.wdata                   (rf_tlb_data2_4k_wdata)
    ,.rclk                    (rf_tlb_data2_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_data2_4k_rclk_rst_n)
    ,.re                      (rf_tlb_data2_4k_re)
    ,.raddr                   (rf_tlb_data2_4k_raddr)
    ,.rdata                   (rf_tlb_data2_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x39 i_rf_tlb_data3_4k (

     .wclk                    (rf_tlb_data3_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_data3_4k_wclk_rst_n)
    ,.we                      (rf_tlb_data3_4k_we)
    ,.waddr                   (rf_tlb_data3_4k_waddr)
    ,.wdata                   (rf_tlb_data3_4k_wdata)
    ,.rclk                    (rf_tlb_data3_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_data3_4k_rclk_rst_n)
    ,.re                      (rf_tlb_data3_4k_re)
    ,.raddr                   (rf_tlb_data3_4k_raddr)
    ,.rdata                   (rf_tlb_data3_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x39 i_rf_tlb_data4_4k (

     .wclk                    (rf_tlb_data4_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_data4_4k_wclk_rst_n)
    ,.we                      (rf_tlb_data4_4k_we)
    ,.waddr                   (rf_tlb_data4_4k_waddr)
    ,.wdata                   (rf_tlb_data4_4k_wdata)
    ,.rclk                    (rf_tlb_data4_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_data4_4k_rclk_rst_n)
    ,.re                      (rf_tlb_data4_4k_re)
    ,.raddr                   (rf_tlb_data4_4k_raddr)
    ,.rdata                   (rf_tlb_data4_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x39 i_rf_tlb_data5_4k (

     .wclk                    (rf_tlb_data5_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_data5_4k_wclk_rst_n)
    ,.we                      (rf_tlb_data5_4k_we)
    ,.waddr                   (rf_tlb_data5_4k_waddr)
    ,.wdata                   (rf_tlb_data5_4k_wdata)
    ,.rclk                    (rf_tlb_data5_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_data5_4k_rclk_rst_n)
    ,.re                      (rf_tlb_data5_4k_re)
    ,.raddr                   (rf_tlb_data5_4k_raddr)
    ,.rdata                   (rf_tlb_data5_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x39 i_rf_tlb_data6_4k (

     .wclk                    (rf_tlb_data6_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_data6_4k_wclk_rst_n)
    ,.we                      (rf_tlb_data6_4k_we)
    ,.waddr                   (rf_tlb_data6_4k_waddr)
    ,.wdata                   (rf_tlb_data6_4k_wdata)
    ,.rclk                    (rf_tlb_data6_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_data6_4k_rclk_rst_n)
    ,.re                      (rf_tlb_data6_4k_re)
    ,.raddr                   (rf_tlb_data6_4k_raddr)
    ,.rdata                   (rf_tlb_data6_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x39 i_rf_tlb_data7_4k (

     .wclk                    (rf_tlb_data7_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_data7_4k_wclk_rst_n)
    ,.we                      (rf_tlb_data7_4k_we)
    ,.waddr                   (rf_tlb_data7_4k_waddr)
    ,.wdata                   (rf_tlb_data7_4k_wdata)
    ,.rclk                    (rf_tlb_data7_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_data7_4k_rclk_rst_n)
    ,.re                      (rf_tlb_data7_4k_re)
    ,.raddr                   (rf_tlb_data7_4k_raddr)
    ,.rdata                   (rf_tlb_data7_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x85 i_rf_tlb_tag0_4k (

     .wclk                    (rf_tlb_tag0_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_tag0_4k_wclk_rst_n)
    ,.we                      (rf_tlb_tag0_4k_we)
    ,.waddr                   (rf_tlb_tag0_4k_waddr)
    ,.wdata                   (rf_tlb_tag0_4k_wdata)
    ,.rclk                    (rf_tlb_tag0_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_tag0_4k_rclk_rst_n)
    ,.re                      (rf_tlb_tag0_4k_re)
    ,.raddr                   (rf_tlb_tag0_4k_raddr)
    ,.rdata                   (rf_tlb_tag0_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x85 i_rf_tlb_tag1_4k (

     .wclk                    (rf_tlb_tag1_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_tag1_4k_wclk_rst_n)
    ,.we                      (rf_tlb_tag1_4k_we)
    ,.waddr                   (rf_tlb_tag1_4k_waddr)
    ,.wdata                   (rf_tlb_tag1_4k_wdata)
    ,.rclk                    (rf_tlb_tag1_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_tag1_4k_rclk_rst_n)
    ,.re                      (rf_tlb_tag1_4k_re)
    ,.raddr                   (rf_tlb_tag1_4k_raddr)
    ,.rdata                   (rf_tlb_tag1_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x85 i_rf_tlb_tag2_4k (

     .wclk                    (rf_tlb_tag2_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_tag2_4k_wclk_rst_n)
    ,.we                      (rf_tlb_tag2_4k_we)
    ,.waddr                   (rf_tlb_tag2_4k_waddr)
    ,.wdata                   (rf_tlb_tag2_4k_wdata)
    ,.rclk                    (rf_tlb_tag2_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_tag2_4k_rclk_rst_n)
    ,.re                      (rf_tlb_tag2_4k_re)
    ,.raddr                   (rf_tlb_tag2_4k_raddr)
    ,.rdata                   (rf_tlb_tag2_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x85 i_rf_tlb_tag3_4k (

     .wclk                    (rf_tlb_tag3_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_tag3_4k_wclk_rst_n)
    ,.we                      (rf_tlb_tag3_4k_we)
    ,.waddr                   (rf_tlb_tag3_4k_waddr)
    ,.wdata                   (rf_tlb_tag3_4k_wdata)
    ,.rclk                    (rf_tlb_tag3_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_tag3_4k_rclk_rst_n)
    ,.re                      (rf_tlb_tag3_4k_re)
    ,.raddr                   (rf_tlb_tag3_4k_raddr)
    ,.rdata                   (rf_tlb_tag3_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x85 i_rf_tlb_tag4_4k (

     .wclk                    (rf_tlb_tag4_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_tag4_4k_wclk_rst_n)
    ,.we                      (rf_tlb_tag4_4k_we)
    ,.waddr                   (rf_tlb_tag4_4k_waddr)
    ,.wdata                   (rf_tlb_tag4_4k_wdata)
    ,.rclk                    (rf_tlb_tag4_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_tag4_4k_rclk_rst_n)
    ,.re                      (rf_tlb_tag4_4k_re)
    ,.raddr                   (rf_tlb_tag4_4k_raddr)
    ,.rdata                   (rf_tlb_tag4_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x85 i_rf_tlb_tag5_4k (

     .wclk                    (rf_tlb_tag5_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_tag5_4k_wclk_rst_n)
    ,.we                      (rf_tlb_tag5_4k_we)
    ,.waddr                   (rf_tlb_tag5_4k_waddr)
    ,.wdata                   (rf_tlb_tag5_4k_wdata)
    ,.rclk                    (rf_tlb_tag5_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_tag5_4k_rclk_rst_n)
    ,.re                      (rf_tlb_tag5_4k_re)
    ,.raddr                   (rf_tlb_tag5_4k_raddr)
    ,.rdata                   (rf_tlb_tag5_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x85 i_rf_tlb_tag6_4k (

     .wclk                    (rf_tlb_tag6_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_tag6_4k_wclk_rst_n)
    ,.we                      (rf_tlb_tag6_4k_we)
    ,.waddr                   (rf_tlb_tag6_4k_waddr)
    ,.wdata                   (rf_tlb_tag6_4k_wdata)
    ,.rclk                    (rf_tlb_tag6_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_tag6_4k_rclk_rst_n)
    ,.re                      (rf_tlb_tag6_4k_re)
    ,.raddr                   (rf_tlb_tag6_4k_raddr)
    ,.rdata                   (rf_tlb_tag6_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_16x85 i_rf_tlb_tag7_4k (

     .wclk                    (rf_tlb_tag7_4k_wclk)
    ,.wclk_rst_n              (rf_tlb_tag7_4k_wclk_rst_n)
    ,.we                      (rf_tlb_tag7_4k_we)
    ,.waddr                   (rf_tlb_tag7_4k_waddr)
    ,.wdata                   (rf_tlb_tag7_4k_wdata)
    ,.rclk                    (rf_tlb_tag7_4k_rclk)
    ,.rclk_rst_n              (rf_tlb_tag7_4k_rclk_rst_n)
    ,.re                      (rf_tlb_tag7_4k_re)
    ,.raddr                   (rf_tlb_tag7_4k_raddr)
    ,.rdata                   (rf_tlb_tag7_4k_rdata)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

endmodule

