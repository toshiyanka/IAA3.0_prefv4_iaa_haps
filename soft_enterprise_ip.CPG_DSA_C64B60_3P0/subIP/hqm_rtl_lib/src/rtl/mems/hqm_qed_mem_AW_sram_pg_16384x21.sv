//-----------------------------------------------------------------------------------------------------
// INTEL CONFIDENTIAL
//
// Copyright 2022 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------

module hqm_qed_mem_AW_sram_pg_16384x21 (

     input  logic              clk
    ,input  logic              clk_rst_n
    ,input  logic              re
    ,input  logic              we
    ,input  logic [14-1:0]     addr
    ,input  logic [21-1:0]     wdata

    ,output logic [21-1:0]     rdata

    // PWR Interface

    ,input  logic              pgcb_isol_en
    ,input  logic              pwr_enable_b_in
    ,output logic              pwr_enable_b_out

    ,input  logic              ip_reset_b

    ,input  logic              fscan_byprst_b
    ,input  logic              fscan_clkungate
    ,input  logic              fscan_rstbypen
);

logic [21-1:0] rdata_tdo_0;
logic [21-1:0] rdata_tdo_1;
logic [21-1:0] rdata_tdo_2;
logic [21-1:0] rdata_tdo_3;

logic ip_reset_b_sync;

`ifndef INTEL_NO_PWR_PINS

  `ifdef INTC_ADD_VSS

     logic  dummy_vss;

     assign dummy_vss = 1'b0;

  `endif

`endif

hqm_mem_reset_sync_scan i_ip_reset_b_sync (

     .clk                     (clk)
    ,.rst_n                   (ip_reset_b)

    ,.fscan_rstbypen          (fscan_rstbypen)
    ,.fscan_byprst_b          (fscan_byprst_b)

    ,.rst_n_sync              (ip_reset_b_sync)
);

//*******************************************************************
// Placeholder array of SRAMs
//*******************************************************************

logic [4:0] pwr_mgmt_enable;

assign pwr_mgmt_enable[0] = pwr_enable_b_in;

logic [4-1:0] WE_SEL;
logic [4-1:0] RE_SEL;
logic [4-1:0] RE_SEL_reg;

assign WE_SEL[3] =  addr[14-1] &  addr[14-2] & we;
assign WE_SEL[2] =  addr[14-1] & ~addr[14-2] & we;
assign WE_SEL[1] = ~addr[14-1] &  addr[14-2] & we;
assign WE_SEL[0] = ~addr[14-1] & ~addr[14-2] & we;
assign RE_SEL[3] =  addr[14-1] &  addr[14-2] & re;
assign RE_SEL[2] =  addr[14-1] & ~addr[14-2] & re;
assign RE_SEL[1] = ~addr[14-1] &  addr[14-2] & re;
assign RE_SEL[0] = ~addr[14-1] & ~addr[14-2] & re;

always_ff @ (posedge clk or negedge clk_rst_n ) begin
  if ( ! clk_rst_n ) begin
    RE_SEL_reg <= '0;
  end else begin
    if (re) RE_SEL_reg <= RE_SEL;
  end
end

hqm_ip764hduspsr4096x21m8b2s0r2p1d0_dfx_wrapper i_sram_b0 (

     .FUNC_CLK_IN              (clk)
    ,.FUNC_RD_EN_IN            (RE_SEL[0])
    ,.FUNC_WR_EN_IN            (WE_SEL[0])
    ,.FUNC_ADDR_IN             (addr[12-1:0])
    ,.FUNC_WR_DATA_IN          (wdata[(0*21+21-1):(0*21)])

    ,.DATA_OUT                 (rdata_tdo_0[(0*21+21-1):(0*21)])

    ,.IP_RESET_B               (ip_reset_b_sync)
    ,.OUTPUT_RESET             ('0)

    ,.ISOLATION_CONTROL_IN     (pgcb_isol_en)
    ,.PWR_MGMT_IN              ({4'd0, pwr_mgmt_enable[0], pwr_mgmt_enable[0]})
    ,.PWR_MGMT_OUT             (pwr_mgmt_enable[1])

    ,.WRAPPER_CLK_EN           ('1)

    ,.COL_REPAIR_IN            ('0)
    ,.GLOBAL_RROW_EN_IN        ('0)
    ,.ROW_REPAIR_IN            ('0)
    ,.SLEEP_FUSE_IN            ('0)
    ,.TRIM_FUSE_IN             ('0)

    ,.ARRAY_FREEZE             ('0)

    ,.BIST_ENABLE              ('0)
    ,.BIST_ADDR_IN             ('0)
    ,.BIST_CLK_IN              ('0)
    ,.BIST_RD_EN_IN            ('0)
    ,.BIST_WR_DATA_IN          ('0)
    ,.BIST_WR_EN_IN            ('0)

    ,.FSCAN_CLKUNGATE          (fscan_clkungate)
    ,.FSCAN_RAM_BYPSEL         ('0)
    ,.FSCAN_RAM_INIT_EN        ('0)
    ,.FSCAN_RAM_INIT_VAL       ('0)
    ,.FSCAN_RAM_RDIS_B         ('1)
    ,.FSCAN_RAM_WDIS_B         ('1)

`ifndef INTEL_NO_PWR_PINS

  `ifdef INTC_ADD_VSS

    ,.vss                      (dummy_vss)

  `endif

    ,.vccsoc_lv                ('1)
    ,.vccsocaon_lv             ('1)

`endif

);

hqm_ip764hduspsr4096x21m8b2s0r2p1d0_dfx_wrapper i_sram_b1 (

     .FUNC_CLK_IN              (clk)
    ,.FUNC_RD_EN_IN            (RE_SEL[1])
    ,.FUNC_WR_EN_IN            (WE_SEL[1])
    ,.FUNC_ADDR_IN             (addr[12-1:0])
    ,.FUNC_WR_DATA_IN          (wdata[(0*21+21-1):(0*21)])

    ,.DATA_OUT                 (rdata_tdo_1[(0*21+21-1):(0*21)])

    ,.IP_RESET_B               (ip_reset_b_sync)
    ,.OUTPUT_RESET             ('0)

    ,.ISOLATION_CONTROL_IN     (pgcb_isol_en)
    ,.PWR_MGMT_IN              ({4'd0, pwr_mgmt_enable[1], pwr_mgmt_enable[1]})
    ,.PWR_MGMT_OUT             (pwr_mgmt_enable[2])

    ,.WRAPPER_CLK_EN           ('1)

    ,.COL_REPAIR_IN            ('0)
    ,.GLOBAL_RROW_EN_IN        ('0)
    ,.ROW_REPAIR_IN            ('0)
    ,.SLEEP_FUSE_IN            ('0)
    ,.TRIM_FUSE_IN             ('0)

    ,.ARRAY_FREEZE             ('0)

    ,.BIST_ENABLE              ('0)
    ,.BIST_ADDR_IN             ('0)
    ,.BIST_CLK_IN              ('0)
    ,.BIST_RD_EN_IN            ('0)
    ,.BIST_WR_DATA_IN          ('0)
    ,.BIST_WR_EN_IN            ('0)

    ,.FSCAN_CLKUNGATE          (fscan_clkungate)
    ,.FSCAN_RAM_BYPSEL         ('0)
    ,.FSCAN_RAM_INIT_EN        ('0)
    ,.FSCAN_RAM_INIT_VAL       ('0)
    ,.FSCAN_RAM_RDIS_B         ('1)
    ,.FSCAN_RAM_WDIS_B         ('1)

`ifndef INTEL_NO_PWR_PINS

  `ifdef INTC_ADD_VSS

    ,.vss                      (dummy_vss)

  `endif

    ,.vccsoc_lv                ('1)
    ,.vccsocaon_lv             ('1)

`endif

);

hqm_ip764hduspsr4096x21m8b2s0r2p1d0_dfx_wrapper i_sram_b2 (

     .FUNC_CLK_IN              (clk)
    ,.FUNC_RD_EN_IN            (RE_SEL[2])
    ,.FUNC_WR_EN_IN            (WE_SEL[2])
    ,.FUNC_ADDR_IN             (addr[12-1:0])
    ,.FUNC_WR_DATA_IN          (wdata[(0*21+21-1):(0*21)])

    ,.DATA_OUT                 (rdata_tdo_2[(0*21+21-1):(0*21)])

    ,.IP_RESET_B               (ip_reset_b_sync)
    ,.OUTPUT_RESET             ('0)

    ,.ISOLATION_CONTROL_IN     (pgcb_isol_en)
    ,.PWR_MGMT_IN              ({4'd0, pwr_mgmt_enable[2], pwr_mgmt_enable[2]})
    ,.PWR_MGMT_OUT             (pwr_mgmt_enable[3])

    ,.WRAPPER_CLK_EN           ('1)

    ,.COL_REPAIR_IN            ('0)
    ,.GLOBAL_RROW_EN_IN        ('0)
    ,.ROW_REPAIR_IN            ('0)
    ,.SLEEP_FUSE_IN            ('0)
    ,.TRIM_FUSE_IN             ('0)

    ,.ARRAY_FREEZE             ('0)

    ,.BIST_ENABLE              ('0)
    ,.BIST_ADDR_IN             ('0)
    ,.BIST_CLK_IN              ('0)
    ,.BIST_RD_EN_IN            ('0)
    ,.BIST_WR_DATA_IN          ('0)
    ,.BIST_WR_EN_IN            ('0)

    ,.FSCAN_CLKUNGATE          (fscan_clkungate)
    ,.FSCAN_RAM_BYPSEL         ('0)
    ,.FSCAN_RAM_INIT_EN        ('0)
    ,.FSCAN_RAM_INIT_VAL       ('0)
    ,.FSCAN_RAM_RDIS_B         ('1)
    ,.FSCAN_RAM_WDIS_B         ('1)

`ifndef INTEL_NO_PWR_PINS

  `ifdef INTC_ADD_VSS

    ,.vss                      (dummy_vss)

  `endif

    ,.vccsoc_lv                ('1)
    ,.vccsocaon_lv             ('1)

`endif

);

hqm_ip764hduspsr4096x21m8b2s0r2p1d0_dfx_wrapper i_sram_b3 (

     .FUNC_CLK_IN              (clk)
    ,.FUNC_RD_EN_IN            (RE_SEL[3])
    ,.FUNC_WR_EN_IN            (WE_SEL[3])
    ,.FUNC_ADDR_IN             (addr[12-1:0])
    ,.FUNC_WR_DATA_IN          (wdata[(0*21+21-1):(0*21)])

    ,.DATA_OUT                 (rdata_tdo_3[(0*21+21-1):(0*21)])

    ,.IP_RESET_B               (ip_reset_b_sync)
    ,.OUTPUT_RESET             ('0)

    ,.ISOLATION_CONTROL_IN     (pgcb_isol_en)
    ,.PWR_MGMT_IN              ({4'd0, pwr_mgmt_enable[3], pwr_mgmt_enable[3]})
    ,.PWR_MGMT_OUT             (pwr_mgmt_enable[4])

    ,.WRAPPER_CLK_EN           ('1)

    ,.COL_REPAIR_IN            ('0)
    ,.GLOBAL_RROW_EN_IN        ('0)
    ,.ROW_REPAIR_IN            ('0)
    ,.SLEEP_FUSE_IN            ('0)
    ,.TRIM_FUSE_IN             ('0)

    ,.ARRAY_FREEZE             ('0)

    ,.BIST_ENABLE              ('0)
    ,.BIST_ADDR_IN             ('0)
    ,.BIST_CLK_IN              ('0)
    ,.BIST_RD_EN_IN            ('0)
    ,.BIST_WR_DATA_IN          ('0)
    ,.BIST_WR_EN_IN            ('0)

    ,.FSCAN_CLKUNGATE          (fscan_clkungate)
    ,.FSCAN_RAM_BYPSEL         ('0)
    ,.FSCAN_RAM_INIT_EN        ('0)
    ,.FSCAN_RAM_INIT_VAL       ('0)
    ,.FSCAN_RAM_RDIS_B         ('1)
    ,.FSCAN_RAM_WDIS_B         ('1)

`ifndef INTEL_NO_PWR_PINS

  `ifdef INTC_ADD_VSS

    ,.vss                      (dummy_vss)

  `endif

    ,.vccsoc_lv                ('1)
    ,.vccsocaon_lv             ('1)

`endif

);

assign pwr_enable_b_out = pwr_mgmt_enable[4];

always_comb begin: read_data
  case (RE_SEL_reg)
    4'b0001: rdata = rdata_tdo_0[21-1:0];
    4'b0010: rdata = rdata_tdo_1[21-1:0];
    4'b0100: rdata = rdata_tdo_2[21-1:0];
    4'b1000: rdata = rdata_tdo_3[21-1:0];
    default: rdata = rdata_tdo_3[21-1:0];
  endcase
end

endmodule // hqm_qed_mem_AW_sram_pg_16384x21

