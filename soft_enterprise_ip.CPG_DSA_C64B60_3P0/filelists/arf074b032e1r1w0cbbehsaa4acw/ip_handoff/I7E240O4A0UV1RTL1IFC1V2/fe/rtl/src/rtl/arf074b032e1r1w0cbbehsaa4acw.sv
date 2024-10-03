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
// 1r1w0c standard array for SDG server designs.
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


/// Parent Module    : arf074b032e1r1w0cbbehsaa4acw_dfx_wrapper
/// Child Module     : array_generic_rwx_std

`ifndef ARF074B032E1R1W0CBBEHSAA4ACW_SV
`define ARF074B032E1R1W0CBBEHSAA4ACW_SV

//------------------------------------------------------------------------------------------------------------------------
// module arf074b032e1r1w0cbbehsaa4acw
//------------------------------------------------------------------------------------------------------------------------
module arf074b032e1r1w0cbbehsaa4acw #(

//------------------------------------------------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------------------------------------------------
  localparam MODULE                 = "arf074b032e1r1w0cbbehsaa4acw",
  localparam BITS                   = 76,
  localparam ENTRIES                = 32,
  localparam DWIDTH                 = 76,
  localparam AWIDTH                 = 5,
  localparam RD_PORTS               = 1,
  localparam WR_PORTS               = 1,
  localparam CM_PORTS               = 0,
  localparam BPHASE_RD              = 0,
  localparam BPHASE_WR              = 0,
  localparam BPHASE_CM              = 0,
  localparam SEGMENTS               = 0,
  localparam BITS_PER_SEGMENT       = 0,
  localparam SDL_INITVAL            = {1'b0},
  localparam ADDRESS_OFFSET         = 0,
  localparam NO_CAM_LATENCY         = 0,
  localparam NO_CAM_LSB             = 0
)
(

//------------------------------------------------------------------------------------------------------------------------
// interfaces
//------------------------------------------------------------------------------------------------------------------------

  //------------------------------
  // read interfaces
  //------------------------------
  input   wire                            ckrdp0,
  input   wire                            rdenp0,
  input   wire    [AWIDTH-1:0]            rdaddrp0,
  output  wire    [DWIDTH-1:0]            rddatap0,
  input   wire                            sdl_initp0,

  //------------------------------
  // write interfaces
  //------------------------------
  input   wire                            ckwrp0,
  input   wire                            wrenp0,
  input   wire    [AWIDTH-1:0]            wraddrp0,
  input   wire    [DWIDTH-1:0]            wrdatap0,



  //------------------------------
  // rcb interfaces
  //------------------------------
  input   wire                            rdaddrp0_fd,
  input   wire                            rdaddrp0_rd,
  input   wire                            wraddrp0_fd,
  input   wire                            wraddrp0_rd,
  input   wire                            wrdatap0_fd,
  input   wire                            wrdatap0_rd

);



//------------------------------------------------------------------------------------------------------------------------
// instantiation array_generic_rwx_std
//------------------------------------------------------------------------------------------------------------------------
arf074b032e1r1w0cbbehsaa4acw_array_generic_rwx_std #
(

  .MODULE                     (MODULE),
  .BITS                       (BITS),
  .ENTRIES                    (ENTRIES),
  .AWIDTH                     (AWIDTH),
  .DWIDTH                     (DWIDTH),
  .RD_PORTS                   (RD_PORTS),
  .WR_PORTS                   (WR_PORTS),
  .CM_PORTS                   (CM_PORTS),
  .BPHASE_RD                  (BPHASE_RD),
  .BPHASE_WR                  (BPHASE_WR),
  .BPHASE_CM                  (BPHASE_CM),
  .SEGMENTS                   (SEGMENTS),
  .BITS_PER_SEGMENT           (BITS_PER_SEGMENT),
  .SDL_INITVAL                (SDL_INITVAL),
  .ADDRESS_OFFSET             (ADDRESS_OFFSET),
  .NO_CAM_LATENCY             (NO_CAM_LATENCY),
  .NO_CAM_LSB                 (NO_CAM_LSB)

)
array_generic
(

  //------------------------------
  // read interfaces
  //------------------------------
  .ckrd             ( {>>{ ckrdp0  }} ),
  .rden             ( {>>{ rdenp0 }} ),
  .rdaddr           ( {>>{ rdaddrp0 }} ),
  .rddata           ( {>>{ rddatap0 }} ),
  .sdl_init         ( {>>{ sdl_initp0 }} ),

  //------------------------------
  // write interfaces
  //------------------------------
  .ckwr             ( {>>{ ckwrp0 }} ),
  .wren             ( {>>{ wrenp0 }} ),
  .wraddr           ( {>>{ wraddrp0 }} ),
  .wrdata           ( {>>{ wrdatap0 }} ),



  //------------------------------
  // rcb interfaces
  //------------------------------
  .rdaddr_fd        ( {>>{ rdaddrp0_fd }} ),
  .rdaddr_rd        ( {>>{ rdaddrp0_rd }} ),
  .wraddr_fd        ( {>>{ wraddrp0_fd }} ),
  .wraddr_rd        ( {>>{ wraddrp0_rd }} ),
  .wrdata_fd        ( {>>{ wrdatap0_fd }} ),
  .wrdata_rd        ( {>>{ wrdatap0_rd }} )


);

`ifdef INTC_MEM_GLS

  //err variables
  logic errSDL_INITP0;
  logic errsdl_initp0;
  logic errRDENP0;
  logic errrdenp0;
  logic errRDADDRP0;
  logic errrdaddrp0;
  
  logic errWRENP0;
  logic errwrenp0;
  logic errWRADDRP0;
  logic errwraddrp0;
  logic errWRDATAP0;
  logic errwrdatap0;


  always @(errSDL_INITP0) errsdl_initp0 = 1'b1;
  always @(errRDENP0) errrdenp0 = 1'b1;
  always @(errRDADDRP0) errrdaddrp0 = 1'b1;

  always @(errWRENP0) errwrenp0 = 1'b1;
  always @(errWRADDRP0) errwraddrp0 = 1'b1;
  always @(errWRDATAP0) errwrdatap0 = 1'b1;

  always @(negedge ckrdp0) begin
    errsdl_initp0 = 1'b0;
    errrdenp0 = 1'b0;
    errrdaddrp0 = 1'b0;
  end

  always @(negedge ckwrp0) begin
    errwrenp0 = 1'b0;
    errwraddrp0 = 1'b0;
    errwrdatap0 = 1'b0;
  end


specify
  specparam trddatap0_r = 0.00:0.00:0.00;
  specparam trddatap0_f = 0.00:0.00:0.00;

  specparam tsdl_initp0_sr = 0.00:0.00:0.00;
  specparam tsdl_initp0_sf = 0.00:0.00:0.00;
  specparam tsdl_initp0_hr = 0.00:0.00:0.00;
  specparam tsdl_initp0_hf = 0.00:0.00:0.00;

  specparam trdenp0_sr = 0.00:0.00:0.00;
  specparam trdenp0_sf = 0.00:0.00:0.00;
  specparam trdenp0_hr = 0.00:0.00:0.00;
  specparam trdenp0_hf = 0.00:0.00:0.00;

  specparam trdaddrp0_sr = 0.00:0.00:0.00;
  specparam trdaddrp0_sf = 0.00:0.00:0.00;
  specparam trdaddrp0_hr = 0.00:0.00:0.00;
  specparam trdaddrp0_hf = 0.00:0.00:0.00;

  specparam twrenp0_sr = 0.00:0.00:0.00;
  specparam twrenp0_sf = 0.00:0.00:0.00;
  specparam twrenp0_hr = 0.00:0.00:0.00;
  specparam twrenp0_hf = 0.00:0.00:0.00;

  specparam twraddrp0_sr = 0.00:0.00:0.00;
  specparam twraddrp0_sf = 0.00:0.00:0.00;
  specparam twraddrp0_hr = 0.00:0.00:0.00;
  specparam twraddrp0_hf = 0.00:0.00:0.00;
  
  specparam twrdatap0_sr = 0.00:0.00:0.00;
  specparam twrdatap0_sf = 0.00:0.00:0.00;
  specparam twrdatap0_hr = 0.00:0.00:0.00;
  specparam twrdatap0_hf = 0.00:0.00:0.00;

  //sdl_init
  $setuphold(posedge ckrdp0, posedge sdl_initp0, tsdl_initp0_sr, tsdl_initp0_hr, errSDL_INITP0);
  $setuphold(posedge ckrdp0, negedge sdl_initp0, tsdl_initp0_sf, tsdl_initp0_hf, errSDL_INITP0);


  //rden
  $setuphold(posedge ckrdp0, posedge rdenp0, trdenp0_sr, trdenp0_hr, errRDENP0);
  $setuphold(posedge ckrdp0, negedge rdenp0, trdenp0_sf, trdenp0_hf, errRDENP0);

  
  //rdaddr
  $setuphold(posedge ckrdp0, posedge rdaddrp0[4], trdaddrp0_sr, trdaddrp0_hr, errRDADDRP0);
  $setuphold(posedge ckrdp0, negedge rdaddrp0[4], trdaddrp0_sf, trdaddrp0_hf, errRDADDRP0);
  $setuphold(posedge ckrdp0, posedge rdaddrp0[3], trdaddrp0_sr, trdaddrp0_hr, errRDADDRP0);
  $setuphold(posedge ckrdp0, negedge rdaddrp0[3], trdaddrp0_sf, trdaddrp0_hf, errRDADDRP0);
  $setuphold(posedge ckrdp0, posedge rdaddrp0[2], trdaddrp0_sr, trdaddrp0_hr, errRDADDRP0);
  $setuphold(posedge ckrdp0, negedge rdaddrp0[2], trdaddrp0_sf, trdaddrp0_hf, errRDADDRP0);
  $setuphold(posedge ckrdp0, posedge rdaddrp0[1], trdaddrp0_sr, trdaddrp0_hr, errRDADDRP0);
  $setuphold(posedge ckrdp0, negedge rdaddrp0[1], trdaddrp0_sf, trdaddrp0_hf, errRDADDRP0);
  $setuphold(posedge ckrdp0, posedge rdaddrp0[0], trdaddrp0_sr, trdaddrp0_hr, errRDADDRP0);
  $setuphold(posedge ckrdp0, negedge rdaddrp0[0], trdaddrp0_sf, trdaddrp0_hf, errRDADDRP0);


  //wren
  $setuphold(posedge ckwrp0, posedge wrenp0, twrenp0_sr, twrenp0_hr, errWRENP0);
  $setuphold(posedge ckwrp0, negedge wrenp0, twrenp0_sf, twrenp0_hf, errWRENP0);

 
  //wraddr
  $setuphold(posedge ckwrp0, posedge wraddrp0[4], twraddrp0_sr, twraddrp0_hr, errWRADDRP0);
  $setuphold(posedge ckwrp0, negedge wraddrp0[4], twraddrp0_sf, twraddrp0_hf, errWRADDRP0);
  $setuphold(posedge ckwrp0, posedge wraddrp0[3], twraddrp0_sr, twraddrp0_hr, errWRADDRP0);
  $setuphold(posedge ckwrp0, negedge wraddrp0[3], twraddrp0_sf, twraddrp0_hf, errWRADDRP0);
  $setuphold(posedge ckwrp0, posedge wraddrp0[2], twraddrp0_sr, twraddrp0_hr, errWRADDRP0);
  $setuphold(posedge ckwrp0, negedge wraddrp0[2], twraddrp0_sf, twraddrp0_hf, errWRADDRP0);
  $setuphold(posedge ckwrp0, posedge wraddrp0[1], twraddrp0_sr, twraddrp0_hr, errWRADDRP0);
  $setuphold(posedge ckwrp0, negedge wraddrp0[1], twraddrp0_sf, twraddrp0_hf, errWRADDRP0);
  $setuphold(posedge ckwrp0, posedge wraddrp0[0], twraddrp0_sr, twraddrp0_hr, errWRADDRP0);
  $setuphold(posedge ckwrp0, negedge wraddrp0[0], twraddrp0_sf, twraddrp0_hf, errWRADDRP0);

  
  //wrdata
  $setuphold(posedge ckwrp0, posedge wrdatap0[75], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[75], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[74], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[74], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[73], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[73], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[72], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[72], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[71], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[71], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[70], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[70], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[69], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[69], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[68], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[68], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[67], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[67], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[66], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[66], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[65], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[65], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[64], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[64], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[63], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[63], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[62], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[62], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[61], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[61], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[60], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[60], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[59], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[59], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[58], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[58], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[57], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[57], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[56], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[56], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[55], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[55], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[54], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[54], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[53], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[53], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[52], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[52], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[51], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[51], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[50], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[50], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[49], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[49], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[48], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[48], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[47], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[47], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[46], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[46], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[45], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[45], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[44], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[44], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[43], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[43], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[42], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[42], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[41], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[41], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[40], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[40], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[39], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[39], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[38], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[38], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[37], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[37], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[36], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[36], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[35], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[35], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[34], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[34], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[33], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[33], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[32], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[32], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[31], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[31], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[30], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[30], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[29], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[29], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[28], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[28], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[27], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[27], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[26], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[26], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[25], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[25], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[24], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[24], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[23], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[23], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[22], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[22], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[21], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[21], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[20], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[20], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[19], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[19], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[18], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[18], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[17], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[17], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[16], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[16], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[15], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[15], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[14], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[14], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[13], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[13], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[12], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[12], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[11], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[11], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[10], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[10], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[9], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[9], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[8], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[8], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[7], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[7], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[6], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[6], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[5], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[5], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[4], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[4], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[3], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[3], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[2], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[2], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[1], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[1], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);
  $setuphold(posedge ckwrp0, posedge wrdatap0[0], twrdatap0_sr, twrdatap0_hr, errWRDATAP0);
  $setuphold(posedge ckwrp0, negedge wrdatap0[0], twrdatap0_sf, twrdatap0_hf, errWRDATAP0);


  //q 
  (posedge ckrdp0 => rddatap0[75]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[74]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[73]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[72]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[71]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[70]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[69]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[68]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[67]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[66]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[65]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[64]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[63]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[62]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[61]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[60]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[59]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[58]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[57]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[56]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[55]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[54]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[53]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[52]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[51]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[50]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[49]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[48]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[47]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[46]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[45]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[44]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[43]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[42]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[41]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[40]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[39]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[38]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[37]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[36]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[35]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[34]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[33]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[32]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[31]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[30]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[29]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[28]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[27]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[26]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[25]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[24]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[23]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[22]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[21]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[20]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[19]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[18]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[17]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[16]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[15]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[14]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[13]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[12]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[11]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[10]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[9]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[8]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[7]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[6]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[5]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[4]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[3]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[2]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[1]) = (trddatap0_r, trddatap0_f); 
  (posedge ckrdp0 => rddatap0[0]) = (trddatap0_r, trddatap0_f);

endspecify

`endif



endmodule // end module arf074b032e1r1w0cbbehsaa4acw
`endif // endif ifndef ARF074B032E1R1W0CBBEHSAA4ACW_SV
