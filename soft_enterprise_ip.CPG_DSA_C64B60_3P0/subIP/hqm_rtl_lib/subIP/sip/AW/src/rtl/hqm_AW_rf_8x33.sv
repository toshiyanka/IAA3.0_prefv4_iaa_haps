//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
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

module hqm_AW_rf_8x33 (

	 input  logic			wclk
	,input  logic			wclk_rst_n
	,input  logic			we
	,input  logic	[3-1:0]   	waddr
	,input  logic	[33-1:0]   	wdata

	,input  logic			rclk
	,input  logic			rclk_rst_n
	,input  logic	[3-1:0]   	raddr
	,input  logic			re

	,output logic	[33-1:0]   	rdata

// DFX_MISC Interface
	,input logic		 dfx_sync_rst

);
//-----------------------------------------------------------------------------------------------------

wire [34-1:0]   	rdata_tdo;

`ifndef INTEL_NO_PWR_PINS
`ifdef INTC_ADD_VSS
        wire dummy_vss;
        assign dummy_vss = 1'b0;
`endif
`endif

//------------------------------------------------------------
// RF IP Placeholder

hqm_ip7413rfshpm1r1w8x34c1m5_dfx_wrapper i_rf (

         .FUNC_WR_CLK_RF_IN_P0          (wclk)
        ,.FUNC_WEN_RF_IN_P0             (we)
        ,.FUNC_WR_ADDR_RF_IN_P0         (waddr)
        ,.FUNC_DATA_RF_IN_P0            ({1'b0,wdata})
        ,.FUNC_RD_CLK_RF_IN_P0          (rclk)
        ,.FUNC_REN_RF_IN_P0             (re)
        ,.FUNC_RD_ADDR_RF_IN_P0         (raddr)
        ,.DATA_RF_OUT_P0                (rdata_tdo)

        ,.BIST_WR_CLK_RF_IN_P0          ('0)
        ,.BIST_RD_CLK_RF_IN_P0          ('0)
        ,.BIST_RF_ENABLE                ('0)
        ,.BIST_WEN_RF_IN_P0             ('0)
        ,.BIST_WR_ADDR_RF_IN_P0         ('0)
        ,.BIST_DATA_RF_IN_P0            ('0)
        ,.BIST_REN_RF_IN_P0             ('0)
        ,.BIST_RD_ADDR_RF_IN_P0         ('0)

        ,.DFX_MISC_RF_IN                ({9'b0,dfx_sync_rst})

        ,.FUSE_MISC_RF_IN               (6'b0)

        ,.FSCAN_RAM_WRDIS_B             ('1)
        ,.FSCAN_RAM_RDDIS_B             ('1)
        ,.FSCAN_RAM_ODIS_B              ('1)

        ,.UNGATE_BIST_WRTEN          ('1)

        ,.FSCAN_BYPRST_B                   ('1)
        ,.FSCAN_RSTBYPEN                   ('0)
        ,.FSCAN_RAM_BYPSEL                 ('0)
        ,.FSCAN_RAM_AWT_MODE               ('0)
        ,.FSCAN_RAM_AWT_REN                ('0)
        ,.FSCAN_RAM_AWT_WEN                ('0)
        ,.FSCAN_RAM_INIT_EN                ('0)
        ,.FSCAN_RAM_INIT_VAL               ('0)

        ,.LBIST_TEST_MODE                  ('0)

        `ifndef INTEL_NO_PWR_PINS
           ,.vccd_1p0                      ('1)
           `ifdef INTC_ADD_VSS
               ,.vss                       (dummy_vss)
           `endif
        `endif

        ,.PWR_MGMT_MISC_RF_IN           (4'b1110)

);

assign rdata = rdata_tdo[33-1:0];

endmodule // hqm_AW_rf_8x33
