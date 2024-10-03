package hqm_tap_rtdr_common_val_env_pkg;

`include "ovm_macros.svh"
`include "sla_macros.svh"
   
import ovm_pkg::*;
import sla_pkg::*;

import JtagBfmPkg::*;


`ifndef HQM_RTDR_VAL_ENV_JTAG_BFM_CLOCK_PERIOD
    `define HQM_RTDR_VAL_ENV_JTAG_BFM_CLOCK_PERIOD 10000
`endif
`ifndef HQM_RTDR_VAL_ENV_JTAG_BFM_PWRGOOD_SRC
    `define HQM_RTDR_VAL_ENV_JTAG_BFM_PWRGOOD_SRC 1
`endif
`ifndef HQM_RTDR_VAL_ENV_JTAG_BFM_CLK_SRC
   `define HQM_RTDR_VAL_ENV_JTAG_BFM_CLK_SRC 1
`endif
`define HQM_RTDR_VAL_ENV_JTAG_BFM_PARAMETERS \
    .CLOCK_PERIOD(`HQM_RTDR_VAL_ENV_JTAG_BFM_CLOCK_PERIOD), \
    .PWRGOOD_SRC(`HQM_RTDR_VAL_ENV_JTAG_BFM_PWRGOOD_SRC), \
    .CLK_SRC(`HQM_RTDR_VAL_ENV_JTAG_BFM_CLK_SRC)

`define STF_PID_BITS 8
`define STF_GID_SIZE 4
`define STF_DATA_SIZE 32
`define STF_PKT_SIZE  (`STF_DATA_SIZE + `STF_GID_SIZE + 6)

typedef JtagBfmMasterAgent #(`HQM_RTDR_VAL_ENV_JTAG_BFM_PARAMETERS) JtagBfmMasterAgent_T;
//typedef STF_BFM_Agent #(`STF_PKT_SIZE) STF_BFM_Agent_T;

`include "hqm_tap_rtdr_common_val_env.svh"
`include "jtag_bfm_tlm_filter.svh"
//`include "dft_macro_parser.svh"
   
endpackage : hqm_tap_rtdr_common_val_env_pkg
