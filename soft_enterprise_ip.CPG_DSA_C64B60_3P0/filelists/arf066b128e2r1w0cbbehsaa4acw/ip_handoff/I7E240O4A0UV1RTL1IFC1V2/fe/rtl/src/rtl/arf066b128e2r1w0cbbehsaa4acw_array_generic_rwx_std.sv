//------------------------------------------------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2023 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code ("Material") are owned by Intel Corporation or its
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

//------------------------------------------------------------------------------------------------------------------------
// Intel Proprietary        Intel Confidential        Intel Proprietary        Intel Confidential        Intel Proprietary
//------------------------------------------------------------------------------------------------------------------------
// Generated by                  : cudoming
// Generated on                  : April 19, 2023
//------------------------------------------------------------------------------------------------------------------------
// General Information:
// ------------------------------
// 2r1w0c standard array for SDG server designs.
// Behavioral modeling of a parameterized register file core with no DFX features.
// RTL is written in SystemVerilog.
//------------------------------------------------------------------------------------------------------------------------
// Detail Information:
// ------------------------------
// Addresses        : RD/WR addresses are encoded.
//                    Input addresses will be valid at the array in 1 phases after being driven.
//                    Address latency of 1 is corresponding to a B-latch.
// Enables          : RD/WR enables are used to condition the clock and wordlines.
//                  : Input enables will be valid at the array in 1 phases after being driven.
//                    Enable latency of 1 is corresponding to a B-latch.
// Write Data       : Write data will be valid at the array 2 phases after being driven.
//                    Write data latency of 2 is corresponding to a rising-edge flop. 
// Read Data        : Read data will be valid at the output of a SDL 1 phase after being read.
//                    Read data latency of 1 is corresponding to a B-latch.
// Address Offset   : 
//------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------
// Other Information:
// ------------------------------
// SDG RFIP RTL Release Path:
// /p/hdk/rtl/ip_releases/shdk74/array_macro_module
//
//------------------------------------------------------------------------------------------------------------------------


`ifndef ARF066B128E2R1W0CBBEHSAA4ACW_ARRAY_GENERIC_RWX_STD_SV
`define ARF066B128E2R1W0CBBEHSAA4ACW_ARRAY_GENERIC_RWX_STD_SV

//INTEL_SIMONLY features

//Error injection
//Global switch
`ifdef INTC_MEM_SPRF_FAULT_SINGLE
  `define INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_FAULT_SINGLE
`endif //INTC_MEM_SPRF_FAULT_SINGLE

`ifdef INTC_MEM_SPRF_FAULT_DOUBLE
  `define INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_FAULT_DOUBLE
`endif //INTC_MEM_SPRF_FAULT_DOUBLE

`ifndef INTC_MEM_NOXHANDLING
  `define INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_X_INJECTION
`endif //INTC_MEM_NOXHANDLING

//END - INTEL_SIMONLY features

`ifdef INTEL_FPGA
  `define ARF066B128E2R1W0CBBEHSAA4ACW_FAKE_MEM
`else //INTEL_FPGA
  `ifdef INTEL_EMULATION
    //pass
  `else //INTEL_EMULATION
    `ifdef INTEL_SIMONLY
      `ifdef INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_FAULT_SINGLE
        `define INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI
        `define INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI_SINGLE
      `endif //INTC_MEM_arf066b128e2r1w0cbbehsaa4acw_fault_single
      `ifdef INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_FAULT_DOUBLE
        `define INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI
        `define INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI_DOUBLE
      `endif //INTC_MEM_arf066b128e2r1w0cbbehsaa4acw_fault_single
      `ifdef INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_X_INJECTION
        `define INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_X_INJECTION_INT
      `endif //INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_X_INJECTION
    `endif //INTEL_SIMONLY
  `endif //INTEL_EMULATION
`endif //INTEL_FPGA

module arf066b128e2r1w0cbbehsaa4acw_array_generic_rwx_std #(
//------------------------------------------------------------------------------------------------------------------------
// parameters
//------------------------------------------------------------------------------------------------------------------------
  parameter MODULE                 = "arf066b128e2r1w0cbbehsaa4acw_array_generic_rwx_std",
  parameter BITS                   = 68,
  parameter ENTRIES                = 128,
  parameter DWIDTH                 = 68,
  parameter AWIDTH                 = 7,
  parameter RD_PORTS               = 2,
  parameter WR_PORTS               = 1,
  parameter CM_PORTS               = 0,
  parameter BPHASE_RD              = 0,
  parameter BPHASE_WR              = 0,
  parameter BPHASE_CM              = 0,
  parameter SEGMENTS               = 0,
  parameter BITS_PER_SEGMENT       = 0,
  parameter SDL_INITVAL            = {1'b0,1'b0},
  parameter ADDRESS_OFFSET         = {AWIDTH{1'b0}},
  parameter NO_CAM_LATENCY         = 0,
  parameter NO_CAM_LSB             = 0
)
(
//------------------------------------------------------------------------------------------------------------------------
// interfaces
//------------------------------------------------------------------------------------------------------------------------
  input  logic                ckrd          [RD_PORTS-1:0],
  input  logic                rden          [RD_PORTS-1:0],
  input  logic [AWIDTH-1:0]   rdaddr        [RD_PORTS-1:0],
  output logic [DWIDTH-1:0]   rddata        [RD_PORTS-1:0],
  input  logic                sdl_init      [RD_PORTS-1:0],
  input  logic                ckwr          [WR_PORTS-1:0],
  input  logic                wren          [WR_PORTS-1:0],
  input  logic [AWIDTH-1:0]   wraddr        [WR_PORTS-1:0],
  input  logic [DWIDTH-1:0]   wrdata        [WR_PORTS-1:0],
  input  logic                rdaddr_fd     [RD_PORTS-1:0],
  input  logic                rdaddr_rd     [RD_PORTS-1:0],
  input  logic                wraddr_fd     [WR_PORTS-1:0],
  input  logic                wraddr_rd     [WR_PORTS-1:0],
  input  logic                wrdata_fd     [WR_PORTS-1:0],
  input  logic                wrdata_rd     [WR_PORTS-1:0]
);

`ifndef ARF066B128E2R1W0CBBEHSAA4ACW_FAKE_MEM

//------------------------------------------------------------------------------------------------------------------------
// declarations
//------------------------------------------------------------------------------------------------------------------------
  logic                ckrdaddrrcb      [RD_PORTS-1:0];
  logic                ckwraddrrcb      [WR_PORTS-1:0];
  logic                ckwrdatarcb      [WR_PORTS-1:0];
  logic [AWIDTH-1:0]   rdaddr_lat       [RD_PORTS-1:0];
  logic                sdl_init_lat     [RD_PORTS-1:0];
  logic [AWIDTH-1:0]   wraddr_lat       [WR_PORTS-1:0];
  logic [DWIDTH-1:0]   wrdata_lat       [WR_PORTS-1:0];
  logic [DWIDTH-1:0]   sdltoout         [RD_PORTS-1:0];

  logic [DWIDTH-1:0]   ARRAY            [ENTRIES-1:0];

//------------------------------------------------------------------------------------------------------------------------
//X INJ logic for invalid conditionsFaulty array
//------------------------------------------------------------------------------------------------------------------------

`ifdef INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_X_INJECTION_INT
  //x inj signals
  logic [RD_PORTS-1:0] rd_op_conflict;
  logic [WR_PORTS-1:0] wr_op_conflict;

  //write conflict
  if (WR_PORTS>1) begin
    always_comb begin
      wr_op_conflict = {WR_PORTS{1'b0}};
      for(int wrpa=0; wrpa<(WR_PORTS-1); wrpa++) begin
        for(int wrpb=wrpa+1; wrpb<WR_PORTS; wrpb++) begin
          if ((ckwraddrrcb[wrpa] && ckwraddrrcb[wrpb]) && 
              (wraddr_lat[wrpa] == wraddr_lat[wrpb])) begin 
            wr_op_conflict[wrpa] = 1'b1;
            wr_op_conflict[wrpb] = 1'b1;
          end
        end
      end
    end
  end else assign wr_op_conflict = {WR_PORTS{1'b0}};

  //read conflict
  if (WR_PORTS>=1 && RD_PORTS>=1) begin
    always_comb begin
      rd_op_conflict = {RD_PORTS{1'b0}};
      for(int rdp=0; rdp<RD_PORTS; rdp++) begin
        for(int wrp=0; wrp<WR_PORTS; wrp++) begin
          if ((ckwraddrrcb[wrp] && ckrdaddrrcb[rdp]) &&
              (wraddr_lat[wrp] == rdaddr_lat[rdp]) && 
              ((int'(rdaddr_lat[rdp]) >= ADDRESS_OFFSET) &&
              (int'(rdaddr_lat[rdp]) <= int'((ENTRIES-1)+ADDRESS_OFFSET)))) rd_op_conflict[rdp] = 1'b1;
        end
      end
    end
  end

 
`endif //INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_X_INJECTION_INT


//------------------------------------------------------------------------------------------------------------------------
//Faulty array
//------------------------------------------------------------------------------------------------------------------------
`ifdef INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI
  parameter int fentry0 = ENTRIES/2;
  parameter int fentry1 = ENTRIES/4;

  parameter int fcol0   = DWIDTH/2;
  parameter int fcol1   = DWIDTH/4;

  logic [DWIDTH-1:0]   array_f            [ENTRIES-1:0];
  
  `ifdef INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI_SINGLE
  initial begin
    for (int i = 0; i < ENTRIES; i++) begin
       for (int k = 0; k < DWIDTH; k++) begin
          if ((i==fentry0)&&(k==fcol0)) array_f[i][k] = 1'b1;
          else  array_f[i][k] = 1'b0;
       end
    end
    $display ("-----------------------------------------------------");
    $display ("-- Fault injection table for %m");
    $display ("-- Type of fault : Single");
    $display ("-- Entry %0d, I/O %0d", fentry0, fcol0);
    $display ("-----------------------------------------------------");
    end
  `endif //INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI_SINGLE 

  `ifdef INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI_DOUBLE
  initial begin
    for (int i = 0; i < ENTRIES; i++) begin
       for (int k = 0; k < DWIDTH; k++) begin
          if ((i==fentry0)&&(k==fcol0) || (i==fentry1)&&(k==fcol1)) array_f[i][k] = 1'b1;
          else  array_f[i][k] = 1'b0;
       end
    end
    $display ("-----------------------------------------------------");
    $display ("-- Fault injection table for %m");
    $display ("-- Type of fault : Double");
    $display ("-- Entry %0d, I/O %0d", fentry0, fcol0);
    $display ("-- Entry %0d, I/O %0d", fentry1, fcol1);
    $display ("-----------------------------------------------------");
    end
  `endif //INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI_DOUBLE
`endif // INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI

//------------------------------------------------------------------------------------------------------------------------
// modeling writes
//------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------
// write address clock regional clock buffer RCB
//--------------------
  generate
  for (genvar i=0; i<WR_PORTS; i++) begin : rcb_wraddr
    arf066b128e2r1w0cbbehsaa4acw_gclk_make_clk_and_rcb_ph1 rcb (
      .CkRcbX1N       (ckwraddrrcb[i]),
      .CkGridX1N      (ckwr[i]),
      .RPEn           (wren[i]),
      .RPOvrd         (1'b0),
      .FscanClkUngate (1'b0),
      .Fd             (wraddr_fd[i]),
      .Rd             (wraddr_rd[i])
    );
  end
  endgenerate

//------------------------------------------------------------
// write data clock regional clock buffer RCB
//--------------------
  generate
  for (genvar i=0; i<WR_PORTS; i++) begin : rcb_wrdata
    arf066b128e2r1w0cbbehsaa4acw_gclk_make_clk_and_rcb_ph1 rcb (
      .CkRcbX1N       (ckwrdatarcb[i]),
      .CkGridX1N      (ckwr[i]),
      .RPEn           (wren[i]),
      .RPOvrd         (1'b0),
      .FscanClkUngate (1'b0),
      .Fd             (wrdata_fd[i]),
      .Rd             (wrdata_rd[i])
    );
  end
  endgenerate
    
//------------------------------------------------------------
// write latency modeling
//--------------------
  generate
  for (genvar i=0; i<WR_PORTS; i++) begin : latch_wraddr_lat
    arf066b128e2r1w0cbbehsaa4acw_latch_phase_b # ( .DWIDTH (AWIDTH) ) latch (
      .q(wraddr_lat[i]), .d(wraddr[i]), .en(ckwraddrrcb[i])
    );
  end
  endgenerate

  generate
  for (genvar i=0; i<WR_PORTS; i++) begin : msff_wrdata_lat
    arf066b128e2r1w0cbbehsaa4acw_msff_phase_a # ( .DWIDTH (DWIDTH) ) msff (
      .q(wrdata_lat[i]), .d(wrdata[i]), .clk(ckwrdatarcb[i]), .rst(1'b1)
    );
  end
  endgenerate

//------------------------------------------------------------
// array write modeling
//--------------------
  always_latch begin
    for (int portnum=0; portnum<WR_PORTS; portnum++) begin
      if (ckwraddrrcb[portnum]) begin
      `ifdef INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_X_INJECTION_INT
          
        if (wr_op_conflict[portnum]) ARRAY[wraddr_lat[portnum]] <= {DWIDTH{1'bx}};
        else 

      `endif //INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_X_INJECTION_INT
        //------------------------------------------------------------
        // performs array write 
        //----------------------
        if ((int'(wraddr_lat[portnum]) >= ADDRESS_OFFSET) &&
            (int'(wraddr_lat[portnum]) <= int'((ENTRIES-1)+ADDRESS_OFFSET))) begin

          ARRAY[wraddr_lat[portnum]] <= wrdata_lat[portnum];
        end
      end
    end
  end

//------------------------------------------------------------------------------------------------------------------------
// modeling reads
//------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------
// read address clock regional clock buffer RCB
//--------------------
  generate
  for (genvar i=0; i<RD_PORTS; i++) begin : rcb_rdaddr
    arf066b128e2r1w0cbbehsaa4acw_gclk_make_clk_and_rcb_ph1 rcb (
      .CkRcbX1N       (ckrdaddrrcb[i]),
      .CkGridX1N      (ckrd[i]),
      .RPEn           (rden[i]),
      .RPOvrd         (1'b0),
      .FscanClkUngate (1'b0),
      .Fd             (rdaddr_fd[i]),
      .Rd             (rdaddr_rd[i])
    );
  end
  endgenerate

//------------------------------------------------------------
// read latency modeling
//--------------------
  generate
  for (genvar i=0; i<RD_PORTS; i++) begin : latch_rdaddr_lat
    arf066b128e2r1w0cbbehsaa4acw_latch_phase_b # ( .DWIDTH (AWIDTH) ) latch (
      .q(rdaddr_lat[i]), .d(rdaddr[i]), .en(ckrdaddrrcb[i])
    );
  end
  endgenerate

//------------------------------------------------------------
// sdl init latency modeling
//--------------------
  generate
  for (genvar i=0; i<RD_PORTS; i++) begin : msff_sdl_init_lat
    arf066b128e2r1w0cbbehsaa4acw_msff_phase_a # ( .DWIDTH ($bits(sdl_init[i])) ) msff (
      .q(sdl_init_lat[i]), .d(sdl_init[i]), .clk(ckrd[i]), .rst(1'b1)
    );
  end
  endgenerate

//------------------------------------------------------------
// array read modeling
//--------------------
  always_latch begin
    for (int portnum=0; portnum<RD_PORTS; portnum++) begin
      if (sdl_init_lat[portnum]) begin
      
        sdltoout[portnum] <= {$bits(sdltoout[portnum]){SDL_INITVAL[portnum]}};
      end
      
      if (ckrdaddrrcb[portnum]) begin
      `ifdef INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_X_INJECTION_INT

        if (rd_op_conflict[portnum]) sdltoout[portnum] <= {DWIDTH{1'bx}};
        else 

      `endif //INTC_MEM_ARF066B128E2R1W0CBBEHSAA4ACW_X_INJECTION_INT  

        //------------------------------------------------------------
        // performs array read 
        //--------------------
        if ((int'(rdaddr_lat[portnum]) >= ADDRESS_OFFSET) &&
            (int'(rdaddr_lat[portnum]) <= int'((ENTRIES-1)+ADDRESS_OFFSET))) begin
        `ifdef INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI //enable err injection feature

          sdltoout[portnum] <= ARRAY[rdaddr_lat[portnum]] ^ array_f[rdaddr_lat[portnum]];

        `else //INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI - err injection feature off

          sdltoout[portnum] <= ARRAY[rdaddr_lat[portnum]];

        `endif //INTC_ARF066B128E2R1W0CBBEHSAA4ACW_FI
        end

        else begin
        
          sdltoout[portnum] <= {$bits(sdltoout[portnum]){SDL_INITVAL[portnum]}};
        end
      end
    end
  end
  
  always_comb begin
    for (int portnum=0; portnum<RD_PORTS; portnum++) begin
      rddata[portnum] = sdltoout[portnum];
    end
  end



//------------------------------------------------------------------------------------------------------------------------
// property checkers
//------------------------------------------------------------------------------------------------------------------------
`ifndef INTEL_SVA_OFF
    `ifndef AMM_SVA_OFF

////------------------------------------------------------------
//// known driven read enable
////--------------------
//if (RD_PORTS>=1) begin
//  always_comb begin
//    for(int rdp=0; rdp<RD_PORTS; rdp++) begin
//      sva_rfip_known_driven_read_enable: assert final
//        (ckrd[rdp] || 
//         ~(rden[rdp]!==1 && rden[rdp]!==0)) // ~($isunknown(rden[rdp]))
//      else $error ("Read enable should not be x.");
//    end
//  end
//end

//------------------------------------------------------------
// known driven read enable
//--------------------
if (RD_PORTS>=1) begin
  always_comb begin
  `ifdef INTEL_SIMONLY
    if ($realtime > 0) begin
    for(int rdp=0; rdp<RD_PORTS; rdp++) begin
      sva_rfip_known_driven_read_enable: assert property (
        @(posedge ckrd[rdp]) disable iff (ckrd[rdp]!==1 && ckrd[rdp]!==0) // ~($isunknown(ckrd[rdp]))
        (~(rden[rdp]!==1 && rden[rdp]!==0)) // ~($isunknown(rden[rdp]))
      )
      else $error ("Read enable should not be x.");
    end
  end
  `endif
  end
end

////------------------------------------------------------------
//// known driven write enable
////--------------------
//if (WR_PORTS>=1) begin
//  always_comb begin
//    for(int wrp=0; wrp<WR_PORTS; wrp++) begin
//      sva_rfip_known_driven_write_enable: assert final
//        (ckwr[wrp] || 
//         ~(wren[wrp]!==1 && wren[wrp]!==0)) // ~($isunknown(wren[wrp]))
//      else $error ("Write enable should not be x.");
//    end
//  end
//end

//------------------------------------------------------------
// known driven write enable
//--------------------
if (WR_PORTS>=1) begin
  always_comb begin
  `ifdef INTEL_SIMONLY
    if ($realtime > 0) begin
    for(int wrp=0; wrp<WR_PORTS; wrp++) begin
      sva_rfip_known_driven_write_enable: assert property (
        @(posedge ckwr[wrp]) disable iff (ckwr[wrp]!==1 && ckwr[wrp]!==0) // ~($isunknown(ckwr[wrp]))
        (~(wren[wrp]!==1 && wren[wrp]!==0)) // ~($isunknown(wren[wrp]))
      )
      else $error ("Write enable should not be x.");
    end
  end
  `endif
  end
end

//------------------------------------------------------------
// known driven read address
//--------------------
if (RD_PORTS>=1) begin
  always_comb begin
  `ifdef INTEL_SIMONLY
    if ($realtime > 0) begin
    for(int rdp=0; rdp<RD_PORTS; rdp++) begin
      sva_rfip_known_driven_read_address: assert final
        (ckrd[rdp] || ~rden[rdp] || 
         (rden[rdp]!==1 && rden[rdp]!==0) || // $isunknown(rden[rdp])
         $countbits(rdaddr[rdp],1'bx,1'bz)==0) // ~($isunknown(rdaddr[rdp]))
      else $error ("Read address should not be x.");
    end
  end
  `endif
  end
end

//------------------------------------------------------------
// known driven write address
//--------------------
if (WR_PORTS>=1) begin
  always_comb begin
  `ifdef INTEL_SIMONLY
    if ($realtime > 0) begin
    for(int wrp=0; wrp<WR_PORTS; wrp++) begin
      sva_rfip_known_driven_write_address: assert final
        (ckwr[wrp] || ~wren[wrp] || 
         (wren[wrp]!==1 && wren[wrp]!==0) || // $isunknown(wren[wrp])
         $countbits(wraddr[wrp],1'bx,1'bz)==0) // ~($isunknown(wraddr[wrp]))
      else $error ("Write address should not be x.");
    end
  end
  `endif
  end
end

//------------------------------------------------------------
// valid read address
//--------------------
if (RD_PORTS>=1) begin
  always_comb begin
  `ifdef INTEL_SIMONLY
    if ($realtime > 0) begin
    for(int rdp=0; rdp<RD_PORTS; rdp++) begin
      sva_rfip_valid_read_address: assert final
        (ckrd[rdp] || ~rden[rdp] || 
         (rden[rdp]!==1 && rden[rdp]!==0) || // $isunknown(rden[rdp])
         ((rdaddr[rdp] >= ADDRESS_OFFSET) && (int'(rdaddr[rdp]) <= ((ENTRIES-1)+ADDRESS_OFFSET))))
      else $error ("Read address is invalid and out of array range.");
    end
  end
  `endif
  end
end

//------------------------------------------------------------
// valid write address
//--------------------
if (WR_PORTS>=1) begin
  always_comb begin
  `ifdef INTEL_SIMONLY
    if ($realtime > 0) begin
    for(int wrp=0; wrp<WR_PORTS; wrp++) begin
      sva_rfip_valid_write_address: assert final
        (ckwr[wrp] || ~wren[wrp] || 
         (wren[wrp]!==1 && wren[wrp]!==0) || // $isunknown(wren[wrp])
         ((wraddr[wrp] >= ADDRESS_OFFSET) && (int'(wraddr[wrp]) <= ((ENTRIES-1)+ADDRESS_OFFSET))))
      else $error ("Write address is invalid and out of array range.");
    end
  end
  `endif
  end
end

//------------------------------------------------------------
// read address exclusive
//--------------------
// disabled due to supported feature
//--------------------
//if (RD_PORTS>=1) begin
//  always_comb begin
//    for(int rdpa=0; rdpa<(RD_PORTS-1); rdpa++) begin
//      for(int rdpb=rdpa+1; rdpb<RD_PORTS; rdpb++) begin
//        sva_rfip_write_address_exclusive_conflict: assert final
//          (ckrd[rdpa] || ~rden[rdpa] || ckrd[rdpb] || ~rden[rdpb] || 
//           (rden[rdpa]!==1 && rden[rdpa]!==0) || // $isunknown(rden[rdpa])
//           (rden[rdpb]!==1 && rden[rdpb]!==0) ||  // $isunknown(rden[rdpb])
//           ((rdaddr[rdpa] != rdaddr[rdpb]) && 
//            $countbits(rdaddr[rdpa],1'bx,1'bz)==0 &&
//            $countbits(rdaddr[rdpb],1'bx,1'bz)==0))
//          else $error ("Two read ports cannot read from the same address");
//      end
//    end
//  end
//end

//------------------------------------------------------------
// write address exclusive
//--------------------
if (WR_PORTS>1) begin
  always_comb begin
  `ifdef INTEL_SIMONLY
    if ($realtime > 0) begin
    for(int wrpa=0; wrpa<(WR_PORTS-1); wrpa++) begin
      for(int wrpb=wrpa+1; wrpb<WR_PORTS; wrpb++) begin
        sva_rfip_write_address_exclusive_conflict: assert final
          (ckwr[wrpa] || ~wren[wrpa] || ckwr[wrpb] || ~wren[wrpb] || 
           (wren[wrpa]!==1 && wren[wrpa]!==0) || // $isunknown(wren[wrpa])
           (wren[wrpb]!==1 && wren[wrpb]!==0) || // $isunknown(wren[wrpb])
           ((wraddr[wrpa] != wraddr[wrpb]) && 
            $countbits(wraddr[wrpa],1'bx,1'bz)==0 &&
            $countbits(wraddr[wrpb],1'bx,1'bz)==0))
          else $error ("Two write ports cannot write to the same address");
      end
    end
  end
  `endif
  end
end

//------------------------------------------------------------
// read write address exclusive
//--------------------
if ((RD_PORTS>=1) && (WR_PORTS>=1)) begin
  always_comb begin
  `ifdef INTEL_SIMONLY
    if ($realtime > 0) begin
    for(int rdp=0; rdp<RD_PORTS; rdp++) begin
      for(int wrp=0; wrp<WR_PORTS; wrp++) begin
        sva_rfip_read_write_address_exclusive_conflict: assert final
          (ckrd[rdp] || ~rden[rdp] || ckwr[wrp] || ~wren[wrp] || 
           (rden[rdp]!==1 && rden[rdp]!==0) || // $isunknown(rden[rdp])
           (wren[wrp]!==1 && wren[wrp]!==0) || // $isunknown(wren[wrp])
           ((rdaddr[rdp] != wraddr[wrp]) && 
            $countbits(rdaddr[rdp],1'bx,1'bz)==0 &&
            $countbits(wraddr[wrp],1'bx,1'bz)==0))
        else $error ("Two ports cannot read or write to the same address");
      end
    end
  end
  `endif
  end
end

//------------------------------------------------------------
// RAW/WAR Properties
//--------------------
  //RAW property 
  property p_raw_collision (wrp, rdp);  
    disable iff ((ckwr[wrp]!==1 && ckwr[wrp]!==0) || //ckrw isunknown
                 (ckrd[rdp]!==1 && ckrd[rdp]!==0) || //ckwr isunknown
                 (BPHASE_WR == BPHASE_RD))         //ckwr and ckrd same fase
    @(posedge ckwr[wrp]) wren[wrp] |=> @(posedge ckrd[rdp]) ~(rden[rdp] && (rdaddr[rdp] === wraddr_lat[wrp]));
  endproperty: p_raw_collision

  //WAR property
  property p_war_collision (wrp, rdp); 
    disable iff ((ckwr[wrp]!==1 && ckwr[wrp]!==0) || //ckrw isunknown
                 (ckrd[rdp]!==1 && ckrd[rdp]!==0) || //ckwr isunknown
                 (BPHASE_WR == BPHASE_RD))         //ckwr and ckrd same fase
    @(posedge ckrd[rdp]) rden[rdp] |=> @(posedge ckwr[wrp]) ~(wren[wrp] && (rdaddr_lat[rdp] === wraddr[wrp]));
  endproperty: p_war_collision

//------------------------------------------------------------
// RAW Collision
//--------------------
if ((RD_PORTS>=1) && (WR_PORTS>=1)) begin
  always_comb begin
  `ifdef INTEL_SIMONLY
    if ($realtime > 0) begin
    for(int wrp=0; wrp<WR_PORTS; wrp++) begin
      for(int rdp=0; rdp<RD_PORTS; rdp++) begin
        sva_rfip_raw_conflict: assert property (p_raw_collision(wrp, rdp)
        )
        else $error ("Read after Write error in same address.");
      end
    end
  end
  `endif
  end
end


//------------------------------------------------------------
// WAR Collision
//--------------------
if ((RD_PORTS>=1) && (WR_PORTS>=1)) begin
  always_comb begin
  `ifdef INTEL_SIMONLY
    if ($realtime > 0) begin
    for(int wrp=0; wrp<WR_PORTS; wrp++) begin
      for(int rdp=0; rdp<RD_PORTS; rdp++) begin
        sva_rfip_war_conflict: assert property (p_war_collision(wrp, rdp)
        )
        else $error ("Write after Read error in same address.");
      end
    end
  end
  `endif
  end
end


    `endif // MS_SVA_OFF
`endif // INTEL_SVA_OFF

//------------------------------------------------------------------------------------------------------------------------
// validation and simulation support
//------------------------------------------------------------------------------------------------------------------------

// Working In Progress

//------------------------------------------------------------------------------------------------------------------------
// Emu model
//------------------------------------------------------------------------------------------------------------------------
`else //ARF066B128E2R1W0CBBEHSAA4ACW_FAKE_MEM

  (* memory *) logic [DWIDTH-1:0] ARRAY [ENTRIES-1:0] /* synthesis syn_ramstyle = "block_ram" */;

  logic                ckrd_rcb         [RD_PORTS-1:0];
  logic                ckwr_rcb         [WR_PORTS-1:0];
  logic [AWIDTH-1:0]   rdaddr_lat       [RD_PORTS-1:0];
  logic                sdl_init_lat     [RD_PORTS-1:0];
  logic [AWIDTH-1:0]   wraddr_lat       [WR_PORTS-1:0];
  logic [DWIDTH-1:0]   wrdata_lat       [WR_PORTS-1:0];

  logic                wren_lat         [WR_PORTS-1:0];
  logic                rden_lat         [RD_PORTS-1:0];


  //wr
  always_latch begin
    for (int port=0; port<WR_PORTS; port++) begin
      if (~ckwr[port]) wren_lat[port] <= wren[port];
    end
  end

  generate
  for (genvar port=0; port<WR_PORTS; port++) begin
    assign ckwr_rcb[port] = wren_lat[port] & ckwr[port];
  end
  endgenerate

  always_latch begin
    for (int port=0; port<WR_PORTS; port++) begin
      if (~ckwr_rcb[port]) wraddr_lat[port] <= wraddr[port];
    end
  end
  
  generate
  for (genvar port=0; port<WR_PORTS; port++) begin
    always_ff @(posedge ckwr_rcb[port]) begin
      wrdata_lat[port] <= wrdata[port];
    end
  end
  endgenerate

  always_latch begin
    for (int port=0; port<WR_PORTS; port++) begin
      if (ckwr_rcb[port]) ARRAY[wraddr_lat[port]] <= wrdata_lat[port];
    end
  end

  //rd
  always_latch begin
    for (int port=0; port<RD_PORTS; port++) begin
      if (~ckrd[port]) rden_lat[port] <= rden[port];
    end
  end

  generate
  for (genvar port=0; port<RD_PORTS; port++) begin
    assign ckrd_rcb[port] = rden_lat[port] & ckrd[port];
  end
  endgenerate

  always_latch begin
    for (int port=0; port<RD_PORTS; port++) begin
      if (~ckrd_rcb[port]) rdaddr_lat[port] <= rdaddr[port];
    end
  end

  generate
  for (genvar port=0; port<RD_PORTS; port++) begin: sdlff
    always_ff @(posedge ckrd[port]) begin
      sdl_init_lat[port] <= sdl_init[port];
    end
  end
  endgenerate

  always_latch begin
    for (int port=0; port<RD_PORTS; port++) begin
      if (sdl_init_lat[port]) rddata[port] <= {DWIDTH{SDL_INITVAL[port]}};
      if (ckrd_rcb[port]) begin 
        if ((int'(rdaddr_lat[port]) >= ADDRESS_OFFSET) && (int'(rdaddr_lat[port]) <= int'((ENTRIES-1)+ADDRESS_OFFSET))) begin
          rddata[port] <= ARRAY[rdaddr_lat[port]];
        end else begin
          rddata[port] <= {DWIDTH{SDL_INITVAL[port]}};
        end
      end
    end
  end


`endif //ARF066B128E2R1W0CBBEHSAA4ACW_FAKE_MEM
endmodule // arf066b128e2r1w0cbbehsaa4acw_array_generic_rwx_std

`endif // ARF066B128E2R1W0CBBEHSAA4ACW_ARRAY_GENERIC_RWX_STD_SV
