
`define  STF_PKT_SIZE 42

//`include hqm_tb_top.sv


// This module instantiates the JTAG and STF pin interfaces and test islands.
// It also generates the BFM clocks using standardized parameters and plusargs.
// The input signals are DFX powergood, TAP clock gate, and STF clock gate.
// dft_clock_interface dft_clk_intf(`RTL_TOP.`TAPLINK.fdfx_pwrgood, 1'b1, 1'b1);

hqm_tap_rtdr_clock_interface hqm_tap_rtdr_clk_intf(hqm_tb_top.u_hqm.fdfx_powergood, 1'b1, 1'b1);
