// This file should be added inside the soc_pre_ti_include.sv file of the SS. In this file virtual vrc has been called. it also has connectivity between ss top and this module.
// begin: Global VISA testing, SS focus
logic [63:0]        visa_clk [0:127]; 
logic [63:0] [7:0]  visa_data[0:127]; 
logic [63:0]        visa_data_valid[0:127];

assign visa_clk[0] = `RTL_TOP.`I_HQM_ADL.adl_visa_global_muxes.global_plm.ss_clk_out; 
//assign visa_clk[1] = `RTL_TOP.`I_HQM_ADL.dvp_plm0.ss_clk_out; 
assign visa_clk[1] = `RTL_TOP.`I_HQM_ADL.dvp_plm0.visa_clk;
assign visa_clk[2] = `RTL_TOP.`I_HQM_ADL.dvp_plm1.ss_clk_out; 

assign visa_data[0] = `RTL_TOP.`I_HQM_ADL.adl_visa_global_muxes.global_plm.lane_out; 
assign visa_data[1] = `RTL_TOP.`I_HQM_ADL.dvp_plm0.lane_out; 
assign visa_data[2] = `RTL_TOP.`I_HQM_ADL.dvp_plm1.lane_out;

// Add the path to the lane_valid_out ONLY for the muxes with a gasket, usually this is dvp_plm0 for some subsystems, if there are no gaskets make them all 0
assign visa_data_valid[0] = 0;  
//assign visa_data_valid[1] = 0;  
// NOTE!!! In the case this is a mux with a gasket, then the previous line must be commented out and the next one must be uncommented
assign visa_data_valid[1] = `RTL_TOP.`I_HQM_ADL.dvp_plm0.lane_valid_out;
//assign visa_data_valid[1] = <IP_HIER>.i_adl_top.dvp_plm0.lane_valid_out; // <-- ADD THIS
assign visa_data_valid[2] = 0;  

`ifdef HQM_SS_ULT
  visa_val_ti #(
      .NUM_PLM(3),
      .NUM_OUTPUT_LANES({2, 10, 8}),
      .LANE_WIDTH({8, 8, 8}),
      .PLM_NAMES({"global_plm", "dvp_plm0", "dvp_plm1"}),
      .GASKET({0, 1, 0})  
  )
  hqm_ss_visa_val_ti (
      .visa_clk(visa_clk),
      .visa_data(visa_data),
      .visa_data_valid(visa_data_valid),
      .vrc_tb_top_data(ip_wr_data),
      .vrc_tb_top_addr(ip_wr_addr),
      .vrc_tb_top_busy(ip_busy_drv),
      .vrc_tb_top_wr_get(ip_visa_wr_get)
  );
`endif


