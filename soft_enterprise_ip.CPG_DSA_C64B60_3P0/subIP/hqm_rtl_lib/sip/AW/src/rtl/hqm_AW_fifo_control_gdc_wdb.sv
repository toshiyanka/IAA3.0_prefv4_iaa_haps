//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
// AW_fifo_ctl_dc_wdb
//
// This is just a wrapper around the AW_fifo_ctl_dc that adds an output double buffer so the memory
// read time does not appear in the output path and the pop timing is decoupled from the memory.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_fifo_control_gdc_wdb

     import hqm_AW_pkg::*;
#(
     parameter DEPTH                = 2
    ,parameter DWIDTH               = 2

    ,parameter AWIDTH               = AW_logb2(DEPTH-1)+1
    ,parameter DEPTHWIDTH           = (((2**AWIDTH)==DEPTH) ? (AWIDTH+1) : AWIDTH)
) (
     input  logic                   clk_push
    ,input  logic                   rst_push_n

    ,input  logic                   clk_pop
    ,input  logic                   rst_pop_n

    ,input  logic [DEPTHWIDTH-1:0]  cfg_high_wm
    ,input  logic [DEPTHWIDTH-1:0]  cfg_low_wm

    ,input  logic                   fifo_enable

    ,input  logic                   clear_pop_state

    ,input  logic                   push
    ,input  logic [DWIDTH-1:0]      push_data

    ,input  logic                   pop
    ,output logic                   pop_data_v
    ,output logic [DWIDTH-1:0]      pop_data

    ,output logic                   mem_we
    ,output logic [AWIDTH-1:0]      mem_waddr
    ,output logic [DWIDTH-1:0]      mem_wdata
    ,output logic                   mem_re
    ,output logic [AWIDTH-1:0]      mem_raddr
    ,input  logic [DWIDTH-1:0]      mem_rdata

    ,output logic [DEPTHWIDTH-1:0]  fifo_push_depth
    ,output logic                   fifo_push_full
    ,output logic                   fifo_push_afull
    ,output logic                   fifo_push_empty
    ,output logic                   fifo_push_aempty

    ,output logic [DEPTHWIDTH-1:0]  fifo_pop_depth
    ,output logic                   fifo_pop_aempty
    ,output logic                   fifo_pop_empty

    ,output logic [31:0]            fifo_status
    ,output logic [6:0]             db_status
);

//--------------------------------------------------------------------------------------------

logic                       fifo_pop;
logic   [DWIDTH-1:0]        fifo_pop_data;
logic                       db_ready;
logic                       pop_data_v_db;
logic                       pop_db;

//-----------------------------------------------------------------------------------------------------

hqm_AW_fifo_control_gdc_core #(

     .DEPTH                     (DEPTH)
    ,.DWIDTH                    (DWIDTH)
    ,.SYNC_POP                  (1)         // fifo_status synced to clk_pop

) i_fifo_control_dc (

     .clk_push                  (clk_push)
    ,.rst_push_n                (rst_push_n)

    ,.clk_pop                   (clk_pop)
    ,.rst_pop_n                 (rst_pop_n)

    ,.cfg_high_wm               (cfg_high_wm)
    ,.cfg_low_wm                (cfg_low_wm)

    ,.fifo_enable               (fifo_enable)

    ,.clear_pop_state           (clear_pop_state)

    ,.push                      (push)
    ,.push_data                 (push_data)

    ,.pop                       (fifo_pop)
    ,.pop_data                  (fifo_pop_data)

    ,.mem_we                    (mem_we)
    ,.mem_waddr                 (mem_waddr)
    ,.mem_wdata                 (mem_wdata)
    ,.mem_re                    (mem_re)
    ,.mem_raddr                 (mem_raddr)
    ,.mem_rdata                 (mem_rdata)

    ,.fifo_push_depth           (fifo_push_depth)
    ,.fifo_push_full            (fifo_push_full)
    ,.fifo_push_afull           (fifo_push_afull)
    ,.fifo_push_empty           (fifo_push_empty)
    ,.fifo_push_aempty          (fifo_push_aempty)

    ,.fifo_pop_depth            (fifo_pop_depth)
    ,.fifo_pop_aempty           (fifo_pop_aempty)
    ,.fifo_pop_empty            (fifo_pop_empty)

    ,.fifo_status               (fifo_status)
);

//--------------------------------------------------------------------------------------------

assign fifo_pop = ~fifo_pop_empty & db_ready;

assign pop_db   = pop & fifo_enable;

hqm_AW_double_buffer_clear #(.WIDTH($bits(fifo_pop_data))) i_db (

     .clk           (clk_pop)
    ,.rst_n         (rst_pop_n)

    ,.clear         (clear_pop_state)

    ,.status        (db_status)

    ,.in_ready      (db_ready)

    ,.in_valid      (fifo_pop)
    ,.in_data       (fifo_pop_data)

    ,.out_ready     (pop_db)

    ,.out_valid     (pop_data_v_db)
    ,.out_data      (pop_data)
);

assign pop_data_v = pop_data_v_db & fifo_enable;

`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

/* this assertion is problematic when the hwm is changing(to possibly the same as lwm) which could cause afull==empty
`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_simultaneous_fifo_push_full_empty
                   , ( ( fifo_push_empty & ( fifo_push_full | fifo_push_afull ) ) |
                       ( fifo_push_aempty & ( fifo_push_full | fifo_push_afull ) ) ) 
                   , posedge clk_push
                   , ~rst_pop_n
                   , `HQM_SVA_ERR_MSG( "Error: assert_simultaneous_fifo_push_full_empty: full:%d afull:%d aempty:%d empty:%d"
                             , $sampled ( fifo_push_full  )
                             , $sampled ( fifo_push_afull  )
                             , $sampled ( fifo_push_aempty  )
                             , $sampled ( fifo_push_empty  )
                             )
                        , SDG_SVA_SOC_SIM
                   ) 
*/

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_fifo_push_depth_empty_error
                   , ( ( fifo_push_depth > 0 ) & ( fifo_push_empty ) )
                   , posedge clk_push
                   , ~rst_push_n
                   , `HQM_SVA_ERR_MSG( "Error: assert_fifo_push_depth_empty_error: depth:%d empty:%d"
                             , $sampled ( fifo_push_depth  )
                             , $sampled ( fifo_push_empty  )
                             )
                        , SDG_SVA_SOC_SIM
                   ) 

`HQM_SDG_ASSERTS_FORBIDDEN ( assert_forbidden_fifo_pop_depth_empty_error
                   , ( fifo_enable & ( fifo_pop_depth > 0 ) & ( fifo_pop_empty ) )
                   , posedge clk_pop
                   , ~rst_pop_n
                   , `HQM_SVA_ERR_MSG( "Error: assert_fifo_pop_depth_empty_error: depth:%d empty:%d"
                             , $sampled ( fifo_pop_depth  )
                             , $sampled ( fifo_pop_empty  )
                             )
                        , SDG_SVA_SOC_SIM
                   ) 

`endif

`endif

endmodule // AW_fifo_ctl_gdc_wdb

