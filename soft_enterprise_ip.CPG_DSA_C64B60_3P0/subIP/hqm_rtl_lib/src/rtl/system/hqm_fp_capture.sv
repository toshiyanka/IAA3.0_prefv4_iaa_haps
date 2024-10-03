// -------------------------------------------------------------------
// -- Intel Proprietary
// -- Copyright 2020 Intel Corporation
// -- All Rights Reserved
// -------------------------------------------------------------------
// -- Module      : hqm_fp_capture
// -- Author      : Justin Diether
// -- Project     : CPM 1.7 (Bell Creek)
// -- Description : 
// --
// --   This block captures fuses or straps as they stream out the 
// --   the fuse puller block.
// --
// -------------------------------------------------------------------

module hqm_fp_capture #(
  parameter DEFAULT                = '0                        , // Default values for storage element
  parameter WIDTH                  = 8                         , // Bit width of the memory
  parameter DEPTH                  = 4                         , // The number of "words" in the memory
  parameter ADDR_MSB               = (DEPTH == 1) ? 0 :          // Address width - 1 needed  
                                      $clog2(DEPTH) - 1        , // special case when 1 deep fifo
  parameter WIDTH_MSB              = WIDTH - 1                   // All bits of mem hence read all (rda)  
  )( 
  ////////////////////////////////////
  // Psuedo-Register File Interface
  ////////////////////////////////////
  input  logic [ADDR_MSB:0]        wad                         , // RF Write Address
  input  logic                     wen                         , // RF Write Enable
  input  logic [WIDTH_MSB:0]       wdi                         , // RF Write Data
  output logic [(DEPTH*WIDTH)-1:0] rda                         , // All the read data in a 1D array

  //////////////////////////////////
  // Global Signals
  //////////////////////////////////
  input  logic                     ipclk                       , // a Clock
  input  logic                     ip_rst_b                      // Asynchronous reset
  );

  /////////////////////////////////////////
  // Psuedo-Register File Support Signals
  logic [DEPTH-1:0][WIDTH_MSB:0]   mem                         ; // actual storage element for the fuse/strap values


  /////////////////
  // Read Datapath
  assign rda                       = mem                       ; // All bits of mem hence read all (rda)

  //////////////////
  // Write Datapath
  always_ff @(posedge ipclk or negedge ip_rst_b) 
    begin: mem_wr_flops_reset_p
      if(ip_rst_b == 1'b0)
        mem                       <= DEFAULT                   ; // fuse/strap default values 
      else
        if(wen)
          mem[wad]                <= wdi                       ; 
    end                                                          // "part select might be out of bounds"        
  
endmodule
