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


module hqm_AW_rf_32x264 

(
    input    logic  		 wclk
   ,input    logic  		 wclk_rst_n
   ,input    logic  		 rclk
   ,input    logic  		 rclk_rst_n
   ,input    logic  [5-1:0] 	 waddr
   ,input    logic  [5-1:0] 	 raddr
   ,input    logic  [264-1:0] 	 wdata
   ,input    logic  		 we
   ,input    logic  		 re
   ,output   logic   [264-1:0] 	 rdata

// DFX_MISC Interface
	,input logic		 dfx_sync_rst


);

   wire   [2*132-1:0] 	 rdata_tdo;
`ifndef INTEL_NO_PWR_PINS
`ifdef INTC_ADD_VSS
        wire dummy_vss;
        assign dummy_vss = 1'b0;
`endif
`endif


//*******************************************************************
// Placeholder ARRAY OF RFs 
//*******************************************************************

logic      WE_SEL;
logic      RE_SEL;

assign WE_SEL = we;
assign RE_SEL = re;

hqm_ip7413rfshpm1r1w32x132c1m5_dfx_wrapper i_rf_b0 (
   .FUNC_WR_CLK_RF_IN_P0	(wclk) 				//I:

`ifndef INTEL_NO_PWR_PINS
  ,.vccd_1p0 			(1'b1)       // vcc (input) 
  `ifdef INTC_ADD_VSS
     ,.vss 			(dummy_vss)  // vss (inout) 
  `endif
`endif

  ,.FUNC_REN_RF_IN_P0 		 (RE_SEL) 			//I:
  ,.FUNC_WEN_RF_IN_P0 		 (WE_SEL) 			//I:
  ,.FUNC_WR_ADDR_RF_IN_P0 	(waddr[5-1:0]) 			//I:
  ,.FUNC_DATA_RF_IN_P0 		(wdata[(0*132+132-1):(0*132)]) 	//I:
  ,.FUNC_RD_CLK_RF_IN_P0 	(rclk) 				//I:
  ,.FUNC_RD_ADDR_RF_IN_P0 	(raddr[5-1:0]) 			//I:
  ,.DATA_RF_OUT_P0 		(rdata_tdo[(0*132+132-1):(0*132)]) 	//I:
  ,.BIST_WR_CLK_RF_IN_P0		 ('0) 			//I:
  ,.BIST_RD_CLK_RF_IN_P0		 ('0) 			//I:
  ,.BIST_RF_ENABLE 		 ('0) 			//I:
  ,.UNGATE_BIST_WRTEN 	 (1'b1) 			//I:
  ,.BIST_WEN_RF_IN_P0 		 ('0) 			//I:
  ,.BIST_WR_ADDR_RF_IN_P0 	 ('0) 			//I:
  ,.BIST_DATA_RF_IN_P0 		 ('0) 			//I:
  ,.BIST_REN_RF_IN_P0 		 ('0) 			//I:
  ,.BIST_RD_ADDR_RF_IN_P0 	 ('0) 			//I:
        ,.DFX_MISC_RF_IN                ({9'b0,dfx_sync_rst})
  ,.LBIST_TEST_MODE 		 ('0) 			//I:

  ,.FSCAN_RAM_AWT_MODE 		 ('0) 		//I:
  ,.FSCAN_RAM_AWT_REN 		 ('0) 		//I:
  ,.FSCAN_RAM_AWT_WEN 		 ('0) 		//I:
  ,.FSCAN_RAM_RDDIS_B 		 ('1) 		//I:
  ,.FSCAN_RAM_WRDIS_B 		 ('1) 		//I:
  ,.FSCAN_RAM_ODIS_B 		 ('1) 		//I:
  ,.FSCAN_RAM_BYPSEL 		 ('0) 			//I:
  ,.FSCAN_BYPRST_B 		 ('0) 		//I:
  ,.FSCAN_RSTBYPEN 		 ('0) 		//I:
  ,.FSCAN_RAM_INIT_EN 		 ('0) 		//I:
  ,.FSCAN_RAM_INIT_VAL 		 ('0) 		//I:
  ,.FUSE_MISC_RF_IN 		 (6'b0) 		//I:
  ,.PWR_MGMT_MISC_RF_IN 	 (4'b1110) 		//I:
);

hqm_ip7413rfshpm1r1w32x132c1m5_dfx_wrapper i_rf_b1 (
   .FUNC_WR_CLK_RF_IN_P0	(wclk) 				//I:

`ifndef INTEL_NO_PWR_PINS
  ,.vccd_1p0 			(1'b1)       // vcc (input) 
  `ifdef INTC_ADD_VSS
     ,.vss 			(dummy_vss)  // vss (inout) 
  `endif
`endif

  ,.FUNC_REN_RF_IN_P0 		 (RE_SEL) 			//I:
  ,.FUNC_WEN_RF_IN_P0 		 (WE_SEL) 			//I:
  ,.FUNC_WR_ADDR_RF_IN_P0 	(waddr[5-1:0]) 			//I:
  ,.FUNC_DATA_RF_IN_P0 		(wdata[(1*132+132-1):(1*132)]) 	//I:
  ,.FUNC_RD_CLK_RF_IN_P0 	(rclk) 				//I:
  ,.FUNC_RD_ADDR_RF_IN_P0 	(raddr[5-1:0]) 			//I:
  ,.DATA_RF_OUT_P0 		(rdata_tdo[(1*132+132-1):(1*132)]) 	//I:
  ,.BIST_WR_CLK_RF_IN_P0		 ('0) 			//I:
  ,.BIST_RD_CLK_RF_IN_P0		 ('0) 			//I:
  ,.BIST_RF_ENABLE 		 ('0) 			//I:
  ,.UNGATE_BIST_WRTEN 	 (1'b1) 			//I:
  ,.BIST_WEN_RF_IN_P0 		 ('0) 			//I:
  ,.BIST_WR_ADDR_RF_IN_P0 	 ('0) 			//I:
  ,.BIST_DATA_RF_IN_P0 		 ('0) 			//I:
  ,.BIST_REN_RF_IN_P0 		 ('0) 			//I:
  ,.BIST_RD_ADDR_RF_IN_P0 	 ('0) 			//I:
        ,.DFX_MISC_RF_IN                ({9'b0,dfx_sync_rst})
  ,.LBIST_TEST_MODE 		 ('0) 			//I:

  ,.FSCAN_RAM_AWT_MODE 		 ('0) 		//I:
  ,.FSCAN_RAM_AWT_REN 		 ('0) 		//I:
  ,.FSCAN_RAM_AWT_WEN 		 ('0) 		//I:
  ,.FSCAN_RAM_RDDIS_B 		 ('1) 		//I:
  ,.FSCAN_RAM_WRDIS_B 		 ('1) 		//I:
  ,.FSCAN_RAM_ODIS_B 		 ('1) 		//I:
  ,.FSCAN_RAM_BYPSEL 		 ('0) 			//I:
  ,.FSCAN_BYPRST_B 		 ('0) 		//I:
  ,.FSCAN_RSTBYPEN 		 ('0) 		//I:
  ,.FSCAN_RAM_INIT_EN 		 ('0) 		//I:
  ,.FSCAN_RAM_INIT_VAL 		 ('0) 		//I:
  ,.FUSE_MISC_RF_IN 		 (6'b0) 		//I:
  ,.PWR_MGMT_MISC_RF_IN 	 (4'b1110) 		//I:
);


assign rdata = rdata_tdo[264-1:0];

endmodule
