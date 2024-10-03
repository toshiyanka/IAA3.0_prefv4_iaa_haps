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

module hqm_AW_rf_pg_2048x25 (

     input  logic              wclk
    ,input  logic              wclk_rst_n
    ,input  logic              we
    ,input  logic [11-1:0]     waddr
    ,input  logic [25-1:0]     wdata

    ,input  logic              rclk
    ,input  logic              rclk_rst_n
    ,input  logic              re
    ,input  logic [11-1:0]     raddr

    ,output logic [25-1:0]     rdata

    // PWR Interface

    ,input  logic              pgcb_isol_en
    ,input  logic              pwr_enable_b_in
    ,output logic              pwr_enable_b_out

    ,input  logic              ip_reset_b

    ,input  logic              fscan_byprst_b
    ,input  logic              fscan_clkungate
    ,input  logic              fscan_rstbypen
);

logic [26-1:0] rdata_tdo_0;
logic [26-1:0] rdata_tdo_1;

logic ip_reset_b_sync;

`ifndef INTEL_NO_PWR_PINS

  `ifdef INTC_ADD_VSS

        logic  dummy_vss;

        assign dummy_vss = 1'b0;

  `endif

`endif

hqm_mem_reset_sync_scan i_ip_reset_b_sync (

     .clk                     (rclk)
    ,.rst_n                   (ip_reset_b)

    ,.fscan_rstbypen          (fscan_rstbypen)
    ,.fscan_byprst_b          (fscan_byprst_b)

    ,.rst_n_sync              (ip_reset_b_sync)
);

//*******************************************************************
// Placeholder ARRAY OF RFs
//*******************************************************************

logic [2:0] pwr_mgmt_enable;

assign pwr_mgmt_enable[0] = pwr_enable_b_in;

logic [2-1:0] WE_SEL;
logic [2-1:0] RE_SEL;
logic [2-1:0] RE_SEL_reg;

assign WE_SEL[1] =  waddr[11-1] & we;
assign WE_SEL[0] = ~waddr[11-1] & we;
assign RE_SEL[1] =  raddr[11-1] & re;
assign RE_SEL[0] = ~raddr[11-1] & re;

always_ff @ (posedge rclk or negedge rclk_rst_n ) begin
  if ( ! rclk_rst_n ) begin
    RE_SEL_reg <= '0;
  end else begin
    if (re) RE_SEL_reg <= RE_SEL;
  end
end

hqm_ip764hd2prf1024x26s0r2p1_dfx_wrapper i_rf_b0 (

     .FUNC_WR_CLK_IN          (wclk)
    ,.FUNC_WR_EN_IN           (WE_SEL[0])
    ,.FUNC_WR_ADDR_IN         (waddr[10-1:0])
    ,.FUNC_WR_DATA_IN         ({1'b0, wdata[(0*26+26-1-1):(0*26)]})

    ,.FUNC_RD_CLK_IN          (rclk)
    ,.FUNC_RD_EN_IN           (RE_SEL[0])
    ,.FUNC_RD_ADDR_IN         (raddr[10-1:0])
    ,.DATA_OUT                (rdata_tdo_0[(0*26+26-1):(0*26)])

    ,.IP_RESET_B              (ip_reset_b_sync)
    ,.OUTPUT_RESET            ('0)

    ,.WRAPPER_RD_CLK_EN       ('1)
    ,.WRAPPER_WR_CLK_EN       ('1)

    ,.ISOLATION_CONTROL_IN    (pgcb_isol_en)
    ,.PWR_MGMT_IN             ({pwr_mgmt_enable[0], 3'd0, pwr_mgmt_enable[0]})
    ,.PWR_MGMT_OUT            (pwr_mgmt_enable[1])

    ,.COL_REPAIR_IN           ('0)
    ,.GLOBAL_RROW_EN_IN_RD    ('0)
    ,.GLOBAL_RROW_EN_IN_WR    ('0)
    ,.ROW_REPAIR_IN           ('0)
    ,.SLEEP_FUSE_IN           ('0)
    ,.TRIM_FUSE_IN            (11'h008)

    ,.ARRAY_FREEZE            ('0)

    ,.BIST_ENABLE             ('0)
    ,.BIST_WR_CLK_IN          ('0)
    ,.BIST_WR_EN_IN           ('0)
    ,.BIST_WR_ADDR_IN         ('0)
    ,.BIST_WR_DATA_IN         ('0)
    ,.BIST_RD_CLK_IN          ('0)
    ,.BIST_RD_EN_IN           ('0)
    ,.BIST_RD_ADDR_IN         ('0)

    ,.FSCAN_CLKUNGATE         (fscan_clkungate)
    ,.FSCAN_RAM_BYPSEL        ('0)
    ,.FSCAN_RAM_INIT_EN       ('0)
    ,.FSCAN_RAM_INIT_VAL      ('0)
    ,.FSCAN_RAM_RDIS_B        ('1)
    ,.FSCAN_RAM_WDIS_B        ('1)

  `ifndef INTEL_NO_PWR_PINS

    ,.vddp                    ('1)

    `ifdef INTC_ADD_VSS

    ,.vss                     (dummy_vss)

    `endif

  `endif

);

hqm_ip764hd2prf1024x26s0r2p1_dfx_wrapper i_rf_b1 (

     .FUNC_WR_CLK_IN          (wclk)
    ,.FUNC_WR_EN_IN           (WE_SEL[1])
    ,.FUNC_WR_ADDR_IN         (waddr[10-1:0])
    ,.FUNC_WR_DATA_IN         ({1'b0, wdata[(0*26+26-1-1):(0*26)]})

    ,.FUNC_RD_CLK_IN          (rclk)
    ,.FUNC_RD_EN_IN           (RE_SEL[1])
    ,.FUNC_RD_ADDR_IN         (raddr[10-1:0])
    ,.DATA_OUT                (rdata_tdo_1[(0*26+26-1):(0*26)])

    ,.IP_RESET_B              (ip_reset_b_sync)
    ,.OUTPUT_RESET            ('0)

    ,.WRAPPER_RD_CLK_EN       ('1)
    ,.WRAPPER_WR_CLK_EN       ('1)

    ,.ISOLATION_CONTROL_IN    (pgcb_isol_en)
    ,.PWR_MGMT_IN             ({pwr_mgmt_enable[1], 3'd0, pwr_mgmt_enable[1]})
    ,.PWR_MGMT_OUT            (pwr_mgmt_enable[2])

    ,.COL_REPAIR_IN           ('0)
    ,.GLOBAL_RROW_EN_IN_RD    ('0)
    ,.GLOBAL_RROW_EN_IN_WR    ('0)
    ,.ROW_REPAIR_IN           ('0)
    ,.SLEEP_FUSE_IN           ('0)
    ,.TRIM_FUSE_IN            (11'h008)

    ,.ARRAY_FREEZE            ('0)

    ,.BIST_ENABLE             ('0)
    ,.BIST_WR_CLK_IN          ('0)
    ,.BIST_WR_EN_IN           ('0)
    ,.BIST_WR_ADDR_IN         ('0)
    ,.BIST_WR_DATA_IN         ('0)
    ,.BIST_RD_CLK_IN          ('0)
    ,.BIST_RD_EN_IN           ('0)
    ,.BIST_RD_ADDR_IN         ('0)

    ,.FSCAN_CLKUNGATE         (fscan_clkungate)
    ,.FSCAN_RAM_BYPSEL        ('0)
    ,.FSCAN_RAM_INIT_EN       ('0)
    ,.FSCAN_RAM_INIT_VAL      ('0)
    ,.FSCAN_RAM_RDIS_B        ('1)
    ,.FSCAN_RAM_WDIS_B        ('1)

  `ifndef INTEL_NO_PWR_PINS

    ,.vddp                    ('1)

    `ifdef INTC_ADD_VSS

    ,.vss                     (dummy_vss)

    `endif

  `endif

);

assign pwr_enable_b_out = pwr_mgmt_enable[2];

always_comb begin: read_data
  case (RE_SEL_reg)
    2'b01:   rdata = rdata_tdo_0[25-1:0];
    2'b10:   rdata = rdata_tdo_1[25-1:0];
    default: rdata = rdata_tdo_1[25-1:0];
  endcase
end

endmodule // hqm_AW_rf_pg_2048x25

