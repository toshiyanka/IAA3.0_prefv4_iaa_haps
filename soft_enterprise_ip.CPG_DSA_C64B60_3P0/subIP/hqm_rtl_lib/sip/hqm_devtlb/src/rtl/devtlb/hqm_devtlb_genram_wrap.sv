// Author   : Bobby Li
// Email    : bobby.x.li@intel.com
// Project  : gen12 (Bridge Over Troubled Water)
//
// Description:
//     short (<10 line) description of function
//
// -- Intel Proprietary
// -- Copyright (C) 2016-2017 Intel Corporation
// -- All Rights Reserved
// All Rights Reserved
//            

`ifndef HQM_DEVTLB_GENRAM_WRAP_VS
`define HQM_DEVTLB_GENRAM_WRAP_VS

`define HQM_DEVTLB_GENRAM_NOFLOPDELAY
`include "hqm_devtlb_genram_bees_knees.sv"     // RP-based latch array
`include "hqm_devtlb_gram_sdp.v"               // FPGA-based generic array

module hqm_devtlb_genram_wrap #(
//lintra -60037
        parameter       mode            = 0, // 1 = MSFF or 0 = LATCH
        parameter       width           = 32,
        parameter       depth           = 32,
        parameter       one_hot_wr_ptrs = 0,
        parameter       one_hot_rd_ptrs = 0,

        //--------------------------------------
        // Optional User supplied params
        // Only specify these parameters if you don't want the default values
        //--------------------------------------
        // Bypass the input flop stage (almost never used)
        parameter       noflopin_opt    = 0,
        // Number of Rd ports (1-4 currently supported)
        parameter       num_rd_ports    = 1,

        parameter type  T               = logic[width-1:0],
        parameter       cam_en          = 0,
        parameter       cam_width0      = (cam_en == 0) ? 1: width,
        parameter       cam_width1      = (cam_en == 0) ? 1: width,
        parameter       cam_low_bit0    = 0,
        parameter       cam_low_bit1    = 0,

        parameter       devtlb_clogb2_depth    = `HQM_DEVTLB_LOG2(depth),
        parameter       wr_ptr_width    = one_hot_wr_ptrs ? depth : devtlb_clogb2_depth,
        parameter       rd_ptr_width    = one_hot_rd_ptrs ? depth : devtlb_clogb2_depth,
        parameter       my_num_rd_ports = (num_rd_ports > 0) ? num_rd_ports : 1
    )

    (
        input  logic                        gramclk,
        input  logic                        reset_b,
        input  logic                        fscan_latchopen,
        input  logic                        fscan_latchclosed_b,

        input  logic                        wren,
        input  logic [wr_ptr_width-1:0]     wraddr,
        input  T                            wrdata,

        input  logic [rd_ptr_width-1:0]     rdaddr [my_num_rd_ports-1:0],
        output T                            rddataout [my_num_rd_ports-1:0],
        output logic [$bits(T)-1:0]         storage_data [depth-1:0],
        
        input  logic [cam_width0-1:0]     cam_data0,
        input  logic [cam_width1-1:0]     cam_data1,
        output logic [depth-1:0]            cam_hit0,
        output logic [depth-1:0]            cam_hit1
    );

    localparam num_wr_ports = 1;
    localparam i_cam_width0 = (cam_en == 0) ? 0: cam_width0;
    localparam i_cam_width1 = (cam_en == 0) ? 0: cam_width1;

//lintra +60037

    logic                     wren_mda          [num_wr_ports-1:0];
    logic [wr_ptr_width-1:0]  wraddr_mda        [num_wr_ports-1:0];
    T                         wrdata_mda        [num_wr_ports-1:0];

    T                         nocon_datain_q    [num_wr_ports-1:0];

    logic [depth*$bits(T)-1:0]nocon_storage_data;
    //logic [depth-1:0]         nocon_cam_hit0;
    //logic [depth-1:0]         nocon_cam_hit1;

    always_comb wrdata_mda[0] = wrdata;
    always_comb wraddr_mda[0] = wraddr;
    always_comb wren_mda[0]   = wren;


    hqm_devtlb_genram_bees_knees #(

         .width                  ($bits(T)),
         .depth                  (depth),
         .num_rd_ports           (num_rd_ports),
         .num_wr_ports           (1),
         .one_hot_rd_ptrs        (one_hot_rd_ptrs),
         .one_hot_wr_ptrs        (one_hot_wr_ptrs),
         .noflopin_opt           (noflopin_opt),
         .fifo_opt               (0),      
         .cam_width0             (i_cam_width0), // leave width = 0 if you don't want a cam port
         .cam_width1             (i_cam_width1),
         .cam_low_bit0           (cam_low_bit0),
         .cam_low_bit1           (cam_low_bit1),
         .num_rd_ptr_split       (1),           // This is same as num of Rd muxes 
         .svdump_en              (noflopin_opt ? 0 : 1),
         .MCP                    (1),
         .clkname_wr             ("c2xclk"),
         .use_storage_data       (0),
         .flop_latch_based       (mode),
         .xbuf_type              (0),
         .clkname_rd             ("c2xclk"),
         .psep                   (1),   
         .fifo_or_ram            (0),     
         .async_reset_enable     (0),
         .ram_version            (2),

         // All parameters above this line must be specified in this order for RP

         .T                      (T)
    )
    devtlb_genram_bees_knees_u_gt_ram (
    //input
        .gramclk            (gramclk),
        .async_reset_b      (1'b1),
        .reset_b            (reset_b),
        .dt_latchopen       (fscan_latchopen),
        .dt_latchclosed_b   (fscan_latchclosed_b),

        .wren1              (wren_mda),
        .wren2              (wren_mda),
        .wraddr             (wraddr_mda),
        .wrdata             (wrdata_mda),
        .rdaddr             (rdaddr),
        .cam_data0          (cam_data0),
        .cam_data1          (cam_data1),
    
    //output
        .datain_q           (nocon_datain_q),
        .rddataout          (rddataout),
        .cam_hit0           (cam_hit0),
        .cam_hit1           (cam_hit1),
        .storage_data       (nocon_storage_data),
        .storage_dataMDA    (storage_data)
    );

endmodule

`endif // DEVTLB_GENRAM_WRAP_VS
