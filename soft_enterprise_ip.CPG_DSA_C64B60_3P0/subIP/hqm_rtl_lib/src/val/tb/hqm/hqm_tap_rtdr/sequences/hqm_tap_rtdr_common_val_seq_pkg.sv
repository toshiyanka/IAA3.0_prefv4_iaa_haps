package hqm_tap_rtdr_common_val_seq_pkg;

`include "ovm_macros.svh"
`include "sla_macros.svh"

import ovm_pkg::*;
import sla_pkg::*;
import hqm_tap_rtdr_common_val_tb_pkg::*;

// OVM sequence includes here
/////////////////////////////////////////////////
`include "TapSeqLib.sv"
`include "TapSeqLib_Converged.sv"
`include "hello_world.svh"
`include "goodbye_world.svh"
`include "hqm_tap_rtdr_val_init_seq.svh"

endpackage : hqm_tap_rtdr_common_val_seq_pkg
