// lintra -50514 " copyright statement violation"
//====================================================================================================================
//
// sb_genram_vram_spr.sv
//
// Contacts            : Eric Finley, Shruti Sethi, Vinay Chippa
// Original Author(s)  : Eric Finley
// Original Date       : 11/2016
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================
// lintra +50514 " copyright statement violation"


`include "hqm_sb_genram_macros.vh"

// lintra -60037 " Parameter names should be upper case"
// lintra -0527  " unused inputs"
module hqm_sb_genram_vram_spr
#(
    parameter           width                   = 64,
    parameter           depth                   = 32,
    parameter           num_rd_ports            = 1,
    parameter           num_wr_ports            = 1,
    parameter           byte_enable_count       = 1,
    parameter           use_preflops            = 1,
    parameter           latch_based             = 1,
    parameter           sync_reset_enable       = 0,
    parameter           async_reset_enable      = 0,
    parameter           svdump_en               = 1,
    parameter           use_storage_data        = 0,
    parameter           one_hot_wr_ptrs         = 0,
    parameter           one_hot_rd_ptrs         = 0,
    parameter           smart_async_reset       = 1,
    ///////////////////IMPORTANT////////////////////////////
    ///DO NOT CHANGE ANY PARAMETERS BELOW THIS LINE!!!!!!///
    ///////////////////IMPORTANT////////////////////////////
    parameter           address_size            = hqm_genram_clogb2(depth),
    parameter           bwidth                  = (byte_enable_count == 1) ? width : (width/byte_enable_count),
    parameter           sync_reset_enable_int   = ((async_reset_enable == 1) && (smart_async_reset == 1)) ? 1 : sync_reset_enable,
    parameter           one_hot_wr_ptrs_local   = ((sync_reset_enable_int == 1) || (one_hot_wr_ptrs == 1)) ? 1 : 0,
    parameter           one_hot_rd_ptrs_local   = one_hot_rd_ptrs,
    parameter           input_wr_width          = (one_hot_wr_ptrs == 1) ? depth : address_size,
    parameter           input_rd_width          = (one_hot_rd_ptrs == 1) ? depth : address_size,
    parameter           bees_knees_wr_width     = (one_hot_wr_ptrs_local == 1) ? depth : address_size,
    parameter           bees_knees_rd_width     = (one_hot_rd_ptrs_local == 1) ? depth : address_size,
    parameter           noflopin_opt_bees_knees = (use_preflops == 1) ? 0 : 1,
    parameter           flop_based              = (latch_based == 1) ? 0 : 1,
    parameter           async_reset_enable_int  = (smart_async_reset == 1) ? 0 : async_reset_enable
)

(input logic                     vram_clock,
input logic                      sync_vram_reset_b,
input logic                      async_vram_reset_b,
input logic [width-1:0]          write_data                      [num_wr_ports-1:0],
input logic                      write_enable                    [num_wr_ports-1:0],
input logic                      write_byte_enable               [byte_enable_count-1:0][num_wr_ports-1:0],
input logic [input_wr_width-1:0] write_address                   [num_wr_ports-1:0],
input logic [input_rd_width-1:0] read_address                    [num_rd_ports-1:0],
input logic                      dt_latchopen,
input logic                      dt_latchclosed_b,

output logic [width-1:0]         read_data                       [num_rd_ports-1:0],
output logic [width-1:0]         write_data_flopped              [num_wr_ports-1:0],
output logic [width*depth-1:0]   data_memory
);
// lintra +60037 " Parameter names should be upper case"
// lintra +0527  " unused inputs"


// lintra -0531  " unused signals"
logic                           sync_vram_reset_b_int, sync_vram_reset_int, sync_vram_reset_b_final, write_enable_final;
logic                           write_byte_enable_local         [byte_enable_count-1:0][num_wr_ports-1:0];
logic [bees_knees_wr_width-1:0] write_address_bees_knees        [num_wr_ports-1:0];
logic [bees_knees_rd_width-1:0] read_address_bees_knees         [num_rd_ports-1:0];
logic [width-1:0]               write_data_bees_knees_temp      [num_wr_ports-1:0];
logic [bwidth-1:0]              write_data_bees_knees           [byte_enable_count-1:0][num_wr_ports-1:0];
logic [bees_knees_wr_width-1:0] write_address_one_hot           [num_wr_ports-1:0];
logic [bees_knees_wr_width-1:0] shifted_write_address           [num_wr_ports-1:0];
wire[bwidth-1:0]                read_data_bees_knees            [byte_enable_count-1:0][num_rd_ports-1:0];
wire[bwidth-1:0]                write_data_flopped_bees_knees   [byte_enable_count-1:0][num_wr_ports-1:0];
wire[bwidth*depth-1:0]          data_memory_bees_knees          [byte_enable_count-1:0];
reg                             write_enable_bees_knees         [byte_enable_count-1:0][num_wr_ports-1:0];
logic                           async_reset_b_int, async_to_sync_b, async_vram_reset;
logic                           async_to_sync;

// Unconnected Signals to Genram Output Ports
wire [depth-1:0]                nc_genram_cam_hit0              [byte_enable_count-1:0];
wire [depth-1:0]                nc_genram_cam_hit1              [byte_enable_count-1:0];
wire [bwidth-1:0]               nc_genram_storage_dataMDA       [byte_enable_count-1:0][depth-1:0];
// lintra +0531  " unused signals"

generate
genvar i, j;
    if ((async_reset_enable == 1) && (smart_async_reset == 1)) begin
        always_comb async_reset_b_int = 1'b0;
        always_comb async_vram_reset = !async_vram_reset_b;
        // lintra -50002 "No x assignments outside of casex statement. "
        // lintra -60018 "implicit operator precedence. "
        `HQM_GENRAM_EN_ASYNC_RSTB_MSFF(async_to_sync_b, 1'b1, vram_clock, 1'b1, async_vram_reset_b)
        //`HQM_GENRAM_EN_ASYNC_RSTB_MSFF(async_to_sync, 1'b1, vram_clock, 1'b1, async_vram_reset)
        // lintra +60018 "implicit operator precedence. "
        // lintra +50002 "No x assignments outside of casex statement. "
        always_comb begin
            write_enable_final = 1'b0;
            for (int k=0; k<num_wr_ports; k++) begin
                write_enable_final = write_enable_final | write_enable[k];
            end
        end
        always_comb begin
            if (async_to_sync_b == 0) begin
                //if (async_to_sync == 0) begin
                    if (write_enable_final == 1) begin
                        sync_vram_reset_b_int = 1'b1;
                    end else begin
                        //First cycle after the reset has been disabled, the write enable is high
                        sync_vram_reset_b_int = 1'b0;
                    end
                //end else begin
                //    //Clock is running during reset
                //    sync_vram_reset_b_int = 1'b0;
                //end
            end else begin
                //out of reset
                sync_vram_reset_b_int = 1'b1;
            end
        end
        if (sync_reset_enable == 1) begin
            always_comb sync_vram_reset_b_final = sync_vram_reset_b_int || sync_vram_reset_b;
        end else begin
            always_comb sync_vram_reset_b_final = sync_vram_reset_b_int;
        end
    end else begin
        always_comb async_reset_b_int = async_vram_reset_b;
        always_comb sync_vram_reset_b_int = 1'b1;
        if (sync_reset_enable == 1) begin
            always_comb sync_vram_reset_b_final = sync_vram_reset_b;
        end else begin
            always_comb sync_vram_reset_b_final = 1'b1;
        end
    end
    if (one_hot_wr_ptrs_local == 1) begin
        always_comb write_address_bees_knees = write_address_one_hot;
    end else begin
        for (i=0; i<num_wr_ports; i++)
        begin : wr_addr_assign
        always_comb write_address_bees_knees[i][address_size-1:0] = write_address[i];
        end
    end
    always_comb read_address_bees_knees = read_address;
    for (i=0; i<num_wr_ports; i++)
    begin : one_hot_for_loop
        if (one_hot_wr_ptrs == 1) begin
            always_comb shifted_write_address[i] = write_address[i];
        end else begin
            // lintra -2056 "expression bit length is smaller than the bit length of the context "
            always_comb shifted_write_address[i] = 1'b1 << write_address[i];
            // lintra +2056 "expression bit length is smaller than the bit length of the context "
        end
        if (sync_reset_enable_int == 1) begin
            // lintra -2056 "expression bit length is smaller than the bit length of the context "
            always_comb write_address_one_hot[i] = (sync_vram_reset_b_final == 0) ? '1 : shifted_write_address[i];
            // lintra +2056 "expression bit length is smaller than the bit length of the context "
            always_comb write_data_bees_knees_temp[i] = (sync_vram_reset_b_final == 0) ? '0 : write_data[i];
        end else begin
            // lintra -2056 "expression bit length is smaller than the bit length of the context "
            always_comb write_address_one_hot[i] = shifted_write_address[i];
            // lintra +2056 "expression bit length is smaller than the bit length of the context "
            always_comb write_data_bees_knees_temp[i] = write_data[i];
        end
        for ( j = byte_enable_count -1; j >= 0; j = j - 1)
        begin : byte_enable_portion
            if (byte_enable_count == 1) begin
                always_comb write_byte_enable_local[j][i] = '1;
            end else begin
                always_comb write_byte_enable_local[j][i] = write_byte_enable[j][i];
            end
            always_comb write_data_bees_knees[j][i] = write_data_bees_knees_temp[i][((j+1)*bwidth)-1:j*bwidth];
            always_comb write_data_flopped[i][((j+1)*bwidth)-1:j*bwidth] = write_data_flopped_bees_knees[j][i];
            if (sync_reset_enable_int == 1) begin
                always_comb write_enable_bees_knees[j][i] = (sync_vram_reset_b_final == 0) ? 1'b1 : write_enable[i]&write_byte_enable_local[j][i];
            end else begin
                always_comb write_enable_bees_knees[j][i] = write_enable[i]&write_byte_enable_local[j][i];
            end
        end
    end
    for (i=0; i<num_rd_ports; i++)
    begin : read_data_loop
        for ( j = byte_enable_count -1; j >= 0; j = j - 1)
        begin : byte_enable_portion
            always_comb read_data[i][((j+1)*bwidth)-1:j*bwidth] = read_data_bees_knees[j][i];
        end
    end
    for ( i = depth - 1; i >= 0; i = i - 1)
    begin : data_memory_loop
        for ( j = byte_enable_count -1; j >= 0; j = j - 1)
        begin : data_memory_byte_enable_loop
            always_comb data_memory[((i*width)+(j*bwidth))+:bwidth] = data_memory_bees_knees[j][i*bwidth+:bwidth];
        end
    end
    for ( i = byte_enable_count -1; i >= 0; i = i - 1)
    begin : byte_enable
        hqm_sb_genram_bees_knees #(
            .width              ( bwidth                    ),
            .depth              ( depth                     ),
            .num_rd_ports       ( num_rd_ports              ),
            .num_wr_ports       ( num_wr_ports              ),
            .one_hot_rd_ptrs    ( one_hot_rd_ptrs_local     ),
            .one_hot_wr_ptrs    ( one_hot_wr_ptrs_local     ),
            .noflopin_opt       ( noflopin_opt_bees_knees   ),
            .fifo_opt           ( 0                         ),
            .cam_width0         ( 0                         ),
            .cam_width1         ( 0                         ),
            .cam_low_bit0       ( 0                         ),
            .cam_low_bit1       ( 0                         ),
            .num_rd_ptr_split   ( 1                         ),
            .svdump_en          ( svdump_en                 ),
            .MCP                ( 0                         ),
            .clkname_wr         ( "vram_clock"              ),
            .use_storage_data   ( use_storage_data          ),
            .flop_latch_based   ( flop_based                ),
            .xbuf_type          ( 0                         ),
            .clkname_rd         ( "vram_clock"              ),
            .psep               ( 1                         ),
            .fifo_or_ram        ( 0                         ),
            .async_reset_enable ( async_reset_enable_int    ),
            .ram_version        ( `HQM_BEES_KNEES_RAM_VERSION   )
        ) i_sb_vram_genram_bees_knees (
            .gramclk            ( vram_clock                        ),
            .reset_b            ( 1'b1                              ),
            .async_reset_b      ( async_reset_b_int                 ),
            .wrdata             ( write_data_bees_knees[i]          ),
            .wraddr             ( write_address_bees_knees          ),
            .wren1              ( write_enable_bees_knees[i]        ),
            .wren2              ( write_enable_bees_knees[i]        ),
            .rdaddr             ( read_address_bees_knees           ),
            .dt_latchopen       ( dt_latchopen                      ),
            .dt_latchclosed_b   ( dt_latchclosed_b                  ), 
            .cam_data0          ( '0                                ),//lintra -2271 type mismatch in port connection
            .cam_data1          ( '0                                ),
            .datain_q           ( write_data_flopped_bees_knees[i]  ),//lintra +2271 type mismatch in port connection
            .rddataout          ( read_data_bees_knees[i]           ),
            .cam_hit0           ( nc_genram_cam_hit0[i]             ),
            .cam_hit1           ( nc_genram_cam_hit1[i]             ),
            .storage_data       ( data_memory_bees_knees[i]         ),
            .storage_dataMDA    ( nc_genram_storage_dataMDA[i]      ) 
        );
    end
endgenerate
endmodule
