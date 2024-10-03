//====================================================================================================================
//
// sb_genram_vram.sv
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


`include "hqm_sb_genram_macros.vh"

module hqm_sb_genram_vram
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
    ///////////////////IMPORTANT////////////////////////////
    ///DO NOT CHANGE ANY PARAMETERS BELOW THIS LINE!!!!!!///
    ///////////////////IMPORTANT////////////////////////////
    parameter           address_size            = hqm_genram_clogb2(depth),
    parameter           bwidth                  = (byte_enable_count == 1) ? width : (width/byte_enable_count),
    parameter           one_hot_wr_ptrs         = (sync_reset_enable == 1) ? 1 : 0,
    parameter           bees_knees_width        = (one_hot_wr_ptrs == 1) ? depth : address_size,
    parameter           noflopin_opt_bees_knees = (use_preflops == 1) ? 0 : 1,
    parameter           flop_based              = (latch_based == 1) ? 0 : 1
)

(vram_clock, sync_vram_reset_b, async_vram_reset_b, write_data, write_enable, 
write_byte_enable, write_address, read_address, 
dt_latchopen, dt_latchclosed_b, read_data,
write_data_flopped, data_memory);

input                           vram_clock;
input                           sync_vram_reset_b;
input                           async_vram_reset_b;
input [width-1:0]               write_data                      [num_wr_ports-1:0];
input                           write_enable                    [num_wr_ports-1:0];
input                           write_byte_enable               [byte_enable_count-1:0][num_wr_ports-1:0];
input [address_size-1:0]        write_address                   [num_wr_ports-1:0];
input [address_size-1:0]        read_address                    [num_rd_ports-1:0];
input                           dt_latchopen;
input                           dt_latchclosed_b;

output logic [width-1:0]        read_data                       [num_rd_ports-1:0];
output logic [width-1:0]        write_data_flopped              [num_wr_ports-1:0];
output logic [width*depth-1:0]  data_memory;


logic                           write_byte_enable_local         [byte_enable_count-1:0][num_wr_ports-1:0];
logic [bees_knees_width-1:0]    write_address_bees_knees        [num_wr_ports-1:0];
logic [width-1:0]               write_data_bees_knees_temp      [num_wr_ports-1:0];
logic [bwidth-1:0]              write_data_bees_knees           [byte_enable_count-1:0][num_wr_ports-1:0];
logic [bees_knees_width-1:0]    write_address_one_hot           [num_wr_ports-1:0];
wire[bwidth-1:0]                read_data_bees_knees            [byte_enable_count-1:0][num_rd_ports-1:0];
wire[bwidth-1:0]                write_data_flopped_bees_knees   [byte_enable_count-1:0][num_wr_ports-1:0];
wire[bwidth*depth-1:0]          data_memory_bees_knees          [byte_enable_count-1:0];
reg                             write_enable_bees_knees         [byte_enable_count-1:0][num_wr_ports-1:0];


generate
genvar i, j;
    if (one_hot_wr_ptrs == 1) 
    begin
        always_comb write_address_bees_knees = write_address_one_hot;
    end else begin
        for (i=0; i<num_wr_ports; i++)
        begin : wr_addr_assign
        always_comb write_address_bees_knees[i][address_size-1:0] = write_address[i];
        end
    end
    for (i=0; i<num_wr_ports; i++)
    begin : one_hot_for_loop
        if (sync_reset_enable == 1) begin
            // lintra -2056 "expression bit length is smaller than the bit length of the context "
            always_comb write_address_one_hot[i] = (sync_vram_reset_b == 0) ? 'b1 : (1'b1 << write_address[i]);
            // lintra +2056 "expression bit length is smaller than the bit length of the context "
            always_comb write_data_bees_knees_temp[i] = (sync_vram_reset_b == 0) ? 'b0 : write_data[i];
        end else begin
            // lintra -2056 "expression bit length is smaller than the bit length of the context "
            always_comb write_address_one_hot[i] = (1'b1 << write_address[i]);
            // lintra +2056 "expression bit length is smaller than the bit length of the context "
            always_comb write_data_bees_knees_temp[i] = write_data[i];
        end
        for ( j = byte_enable_count -1; j >= 0; j = j - 1)
        begin : byte_enable_portion
            if (byte_enable_count == 1) begin
                always_comb write_byte_enable_local[j][i] = 'b1;
            end else begin
                always_comb write_byte_enable_local[j][i] = write_byte_enable[j][i];
            end
            always_comb write_data_bees_knees[j][i] = write_data_bees_knees_temp[i][((j+1)*bwidth)-1:j*bwidth];
            always_comb write_data_flopped[i][((j+1)*bwidth)-1:j*bwidth] = write_data_flopped_bees_knees[j][i];
            if (sync_reset_enable == 1) begin
                always_comb write_enable_bees_knees[j][i] = (sync_vram_reset_b == 0) ? 'b1 : write_enable[i]&write_byte_enable_local[j][i];
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
            .one_hot_rd_ptrs    ( 0                         ),
            .one_hot_wr_ptrs    ( one_hot_wr_ptrs           ),
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
            .async_reset_enable ( async_reset_enable        )
        ) i_sb_vram_genram_bees_knees (
            .gramclk            ( vram_clock                        ),
            .reset_b            ( 1'b1                               ),
            .async_reset_b      ( async_vram_reset_b                ),
            .wrdata             ( write_data_bees_knees[i]          ),
            .wraddr             ( write_address_bees_knees          ),
            .wren1              ( write_enable_bees_knees[i]        ),
            .wren2              ( write_enable_bees_knees[i]        ),
            .rdaddr             ( read_address                      ),
            .dt_latchopen       ( dt_latchopen                      ),
            .dt_latchclosed_b   ( dt_latchclosed_b                  ),
            .cam_data0          ( 1'b0                              ),
            .cam_data1          ( 1'b0                              ),
            .datain_q           ( write_data_flopped_bees_knees[i]  ),
            .rddataout          ( read_data_bees_knees[i]           ),
            .cam_hit0           (                                   ),
            .cam_hit1           (                                   ),
            .storage_data       ( data_memory_bees_knees[i]         ),
            .storage_dataMDA    (                                   )
        );
    end
endgenerate
endmodule
