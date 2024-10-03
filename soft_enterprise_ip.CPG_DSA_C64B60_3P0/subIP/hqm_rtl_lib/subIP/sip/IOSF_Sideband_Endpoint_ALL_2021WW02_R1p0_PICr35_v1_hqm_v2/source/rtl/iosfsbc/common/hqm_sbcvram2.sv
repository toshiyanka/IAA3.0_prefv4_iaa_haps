//
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2021 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2021WW02_PICr35
//
//  Module sbcvram2 : Latch-based register file implementation; inherited from
//                    chipset group.
//
//----------------------------------------------------------------------------//

// lintra push -80099, -60026, -60018, -60118, -60037, -60038, -60020, -60088, -60024b, -60024a, -70036, -70036_simple
// Questionable Lintra waivers. This is a old HIP module, probably best to leave it be
// lintra push -0393, -0527, -60029
// 81002 : valueparameter '...' should only be in uppercase letters
// lintra push -81002

module hqm_sbcvram2 (vram_clock, vram_reset_b, write_data, write_enable, 
                        write_byte_enable, write_address, read_address1, 
                        read_address2, dt_latchopen, dt_latchclosed_b, 
                        dt_ramrst_b, read_data1, read_data2, 
                        write_data_flopped, data_memory );
    parameter            width = 128;
    parameter            depth = 16;
    parameter     address_size = 4;
    parameter    write_enable_count = 1;
    parameter        use_ports = 2;
    parameter     use_preflops = 1;
    parameter    use_gated_cell = 3;
    parameter    vram_reset_enable = 0;
    parameter    latch_reset_enable = 0;
    input           vram_clock;
    input         vram_reset_b;
    input[width-1:0]    write_data;
    input         write_enable;
    input[write_enable_count-1:0]    write_byte_enable;
    input[address_size-1:0]    write_address;
    input[address_size-1:0]    read_address1;
    input[address_size-1:0]    read_address2;
    input         dt_latchopen;
    input     dt_latchclosed_b;
    input          dt_ramrst_b;
                                            // Used as functional latch
                                            // reset when enabled.
    output reg [width-1:0]    read_data1;
    output reg [width-1:0]    read_data2;
    output reg [width-1:0]    write_data_flopped; // lintra s-70036 
    output[width*depth-1:0]    data_memory;

//----------------------------------------------------------------------------//
//-------------------------- ARCHITECTURE FOR VRAM2 --------------------------//
//----------------------------------------------------------------------------//
//
//    RCS Information:
//    $Author: samckinn $
//    $Date: 2008/09/05 16:16:43 $
//    $Revision: 1.1 $
//    $Locker:  $
//
//----------------------------------------------------------------------------//
//
//    FILENAME  : vram2.v
//    DESIGNER  : jeaster
//    PROJECT   : test / vram2
//    DATE      : 01/10/08
//    PURPOSE   : Architecture for vram2
//    REVISION NUMBER   : 
//
//----------------------------------------------------------------------------//
//    Created by MAS2RTL V2006.04.05
//    Intel Proprietary
//    Copyright (C) 2003 Intel Corporation
//    All Rights Reserved
//----------------------------------------------------------------------------//
//

//--------------------------- Signal Declarations ----------------------------//

    parameter    ALL0_WIDTH_MINUS_1_0 = {(width-1)+1{1'b0}};

    parameter         ALWAYS_ARC = 1'b1;


    reg[width-1:0]    write_data_flopped1; // lintra s-70036
    reg[width-1:0]    write_data_flopped2; // lintra s-70036

    reg [width-1:0]    write_data_flopped3; // lintra s-70036
    reg [width-1:0]    i_write_data;
    reg [address_size-1:0]    nc_write_address;
    reg [depth-1:0]    write_select;
    reg [write_enable_count-1:0]    nc_write_byte_enable;
    reg [address_size-1:0]    nc_read_address1;
    reg [address_size-1:0]    nc_read_address2;
    wire[depth*write_enable_count-1:0]    i_write_line_enable;

 

reg [depth-1:0] address_select;

reg [depth*write_enable_count-1:0] write_line_select;

// synopsys async_set_reset "dt_ramrst_b"
parameter bwidth = (width / write_enable_count);
reg [width*depth-1:0] data_memory;

reg [width-1:0] mux_read_data1; // lintra s-70036
reg [width-1:0] mux_read_data2; // lintra s-70036

//---------------------------- Model Description -----------------------------//
//--------------------------------- Port Map ---------------------------------//
genvar i;
generate
  if((use_gated_cell != 9))
   begin : gen_vram_wen_count
    for(i = depth*write_enable_count-1; i >= 0; i = i-1)
    begin: gc_scanlatchen_depth_write_enable_count_1
     hqm_sbc_gc_latchen // lintra s-80018
     gc_scanlatchen 
       (
        .en(write_line_select[i]),
        .te(dt_latchopen),
        .clrb(dt_latchclosed_b),
        .ck(vram_clock),
        .enclk(i_write_line_enable[i]) 
        );

    end
  end
endgenerate

//--------------------------------------------------------//
//Free Form Table Code
//--------------------------------------------------------//
`ifdef INTEL_SIMONLY
//`ifdef INTEL_INST_ON // SynTranlateOff
initial $display (
        "VRAM2 Instance: %m %d %d %d %d %d %d %d %d %d",
        width,
        depth,
        address_size,
        write_enable_count,
        use_ports,
        use_preflops,
        use_gated_cell,
        vram_reset_enable,
        latch_reset_enable
);
`endif // SynTranlateOn



//------------------------------------//
// flopped internal signals for Flopped Signals Table
//------------------------------------//
always_ff @(posedge vram_clock or negedge vram_reset_b)
begin: vram21_internal_reset_flops
    if (vram_reset_b == 1'b0)
      begin
        write_data_flopped1[width-1:0] <= ALL0_WIDTH_MINUS_1_0;
      end
    else
      begin
        write_data_flopped1[width-1:0] <= write_data[width-1:0];
       end
end // begin: vram21_internal_reset_flops


//------------------------------------//
// flopped internal signals for Flopped Signals Table
//------------------------------------//
always_ff @ (posedge vram_clock)
begin: vram21_internal_noreset_flops

      write_data_flopped2[width-1:0] <= write_data[width-1:0];

end // begin: vram21_internal_noreset_flops


//------------------------------------//
// concurrent output signal assignments for Combinatorial Signals Table
//------------------------------------//

// Tie off the output when not using the pre-flops.
always_comb write_data_flopped[width-1:0] = ((
                                         (use_preflops == 1)&&
                                         (use_gated_cell != 9)
                                        )) ? 
                        write_data_flopped3[width-1:0] : {width{1'b0}};




//------------------------------------//
// concurrent internal signal assignments for Combinatorial Signals Table
//------------------------------------//

// Use resetable or non-resetable pre-flops.
always_comb write_data_flopped3[width-1:0] = ((vram_reset_enable == 1)) ? 
                        write_data_flopped1[width-1:0] : write_data_flopped2[width-1:0];


// Use the pre-flops or not.
always_comb i_write_data[width-1:0] = ((use_preflops == 1)) ? 
                        write_data_flopped3[width-1:0] : write_data[width-1:0];




//------------------------------------//
// concurrent internal signal assignments for Combinatorial Signals Table
//------------------------------------//

always_comb nc_write_address[address_size-1:0] = write_address[address_size-1:0];



//--------------------------------------------------------//
//Free Form Table Code
//--------------------------------------------------------//

always_comb 
begin : write_address_decoder
        integer i;
        for (i=depth-1;i>=0;i=i-1)
        begin
                if (write_address == i)
                begin
                        address_select[i] <= 1'b1;
                end
                else
                begin
                        address_select[i] <= 1'b0;
                end
        end
end // write_address_decoder

//------------------------------------//
// concurrent internal signal assignments for Combinatorial Signals Table
//------------------------------------//

// Force select to one when memory depth is one.
always_comb write_select[depth-1:0] = ((depth > 1)) ? 
                        address_select[depth-1:0] : {depth{1'b1}};




//------------------------------------//
// concurrent internal signal assignments for Combinatorial Signals Table
//------------------------------------//

// Causes a two input AND gate to be used instead of a three input AND gate
// when the byte enable width is only one.
always_comb nc_write_byte_enable[write_enable_count-1:0] = (
                                   (write_enable_count > 1)) ? 
                        write_byte_enable[write_enable_count-1:0] : {write_enable_count{1'b1}};




//--------------------------------------------------------//
//Free Form Table Code
//--------------------------------------------------------//
always_comb 
begin : write_line_select_table
        integer i;
        for ( i = depth*write_enable_count -1; i >= 0; i = i - 1)
        begin
            write_line_select[i] <= 
                write_select[i/write_enable_count] &
                write_enable &
                nc_write_byte_enable[i%write_enable_count];
        end
end // write_line_select_table

//--------------------------------------------------------//
//Free Form Table Code
//--------------------------------------------------------//

generate
if ((latch_reset_enable != 1) && (use_gated_cell != 9))
begin : LA30
always_latch
begin : vram_mem_cell0_internal_noreset_latches
        integer i;
        integer j;
        for ( i = depth-1; i >= 0; i = i - 1)
        begin
            for ( j = write_enable_count -1; j >= 0; j = j - 1)
            begin
                if ((i_write_line_enable[i*write_enable_count+j]) == 1'b1)
                begin
                    data_memory[((i*width)+(j*bwidth))+:bwidth] <=
                        i_write_data[(j*bwidth)+:bwidth];
                end
                `ifdef INTEL_SIMONLY
                //`ifdef INTEL_INST_ON // SynTranlateOff
                else if ((i_write_line_enable[i*write_enable_count+j]) === 1'bx)
                begin
                    data_memory[((i*width)+(j*bwidth))+:bwidth] <=
                        {bwidth{1'bx}};
                end
                `endif // SynTranlateOn
            end
        end
end // vram_mem_cell0_internal_noreset_latches
end // LA30
endgenerate

generate
if ((latch_reset_enable == 1) && (use_gated_cell != 9))
begin : LA32
always_latch
begin : vram_mem_cell1_internal_latches
        integer i;
        integer j;
        for ( i = depth-1; i >= 0; i = i - 1)
        begin
            for ( j = write_enable_count -1; j >= 0; j = j - 1)
            begin
                if ((dt_ramrst_b) == 1'b0)
                begin
                    data_memory[((i*width)+(j*bwidth))+:bwidth] <= 
                        {bwidth{1'b0}};
                end
                else if ((i_write_line_enable[i*write_enable_count+j]) == 1'b1)
                begin
                    data_memory[((i*width)+(j*bwidth))+:bwidth] <=
                        i_write_data[(j*bwidth)+:bwidth];
                end
                `ifdef INTEL_SIMONLY
                //`ifdef INTEL_INST_ON // SynTranlateOff
                else if ((i_write_line_enable[i*write_enable_count+j]) === 1'bx)
                begin
                    data_memory[((i*width)+(j*bwidth))+:bwidth] <= 
                        {bwidth{1'bx}};
                end
                `endif // SynTranlateOn
            end
        end
end // vram_mem_cell1_internal_latches
end // LA32
endgenerate

generate
if ((vram_reset_enable != 1) && (use_gated_cell == 9))
begin : XS00
// Can't have unused signals in the "always" check (fixed rev4.2b).
//always @ (posedge vram_clock or negedge vram_reset_b)
always_ff @ (posedge vram_clock)
begin : vram_mem_cell3_internal_flops
        integer i;
        integer j;
        for ( i = depth-1; i >= 0; i = i - 1)
        begin
            for ( j = write_enable_count -1; j >= 0; j = j - 1)
            begin
                if ((write_line_select[i*write_enable_count+j]) == 1'b1)
                begin
                    data_memory[((i*width)+(j*bwidth))+:bwidth] <= 
                        write_data[(j*bwidth)+:bwidth];
                end
            end
        end
end // vram_mem_cell_internal_flops
end // XS00
endgenerate

generate
if ((vram_reset_enable == 1) && (use_gated_cell == 9))
begin : XA02
always_ff @ (posedge vram_clock or negedge vram_reset_b)
begin : vram_mem_cell3_internal_reset_flops
        integer i;
        integer j;
        if (vram_reset_b == 1'b0)
        begin
            for ( i = depth-1; i >= 0; i = i - 1)
            begin
                for ( j = write_enable_count -1; j >= 0; j = j - 1)
                begin
                    data_memory[((i*width)+(j*bwidth))+:bwidth] <= 
                        {bwidth{1'b0}};
                end
            end
        end
        else
        begin
            for ( i = depth-1; i >= 0; i = i - 1)
            begin
                for ( j = write_enable_count -1; j >= 0; j = j - 1)
                begin
                    if ((write_line_select[i*write_enable_count+j]) == 1'b1)
                    begin
                        data_memory[((i*width)+(j*bwidth))+:bwidth] <= 
                            write_data[(j*bwidth)+:bwidth];
                    end
                end
            end
        end
end // vram_mem_cell3_internal_reset_flops
end // XA02
endgenerate

//------------------------------------//
// concurrent internal signal assignments for Combinatorial Signals Table
//------------------------------------//

// Needed to support one port mode.
always_comb nc_read_address1[address_size-1:0] = ((use_ports == 1)) ? 
                        write_address[address_size-1:0] : read_address1[address_size-1:0];


always_comb nc_read_address2[address_size-1:0] = read_address2[address_size-1:0];



//--------------------------------------------------------//
//Free Form Table Code
//--------------------------------------------------------//

always_comb 
begin : read_mux1
        integer i;
        mux_read_data1 = {width{1'b0}};
        for ( i = depth-1; i >= 0; i = i - 1)
        begin
                if (nc_read_address1 == i)
                begin
                        mux_read_data1 = data_memory [i*width+:width];
                end
        end
end // begin : read_mux1

always_comb
begin : read_mux2
        integer i;
        mux_read_data2 = {width{1'b0}};
        for ( i = depth-1; i >= 0; i = i - 1)
        begin
                if (nc_read_address2 == i)
                begin
                        mux_read_data2 = data_memory [i*width+:width];
                end
        end
end // begin : read_mux2

//------------------------------------//
// concurrent output signal assignments for Combinatorial Signals Table
//------------------------------------//

// Block output when not used (added rev4.3).
// Bypass read mux when memory depth is only one.
always_comb read_data1[width-1:0] = ((use_ports < 1)) ? 
                        {width{1'b0}} : ((depth > 1)) ? 
                        mux_read_data1[width-1:0] : data_memory[width-1:0];


// Block output when not used.
// Bypass read mux when memory depth is only one.
always_comb read_data2[width-1:0] = ((use_ports < 3)) ? 
                        {width{1'b0}} : ((depth > 1)) ? 
                        mux_read_data2[width-1:0] : data_memory[width-1:0];




endmodule // sbcvram2

// lintra pop

