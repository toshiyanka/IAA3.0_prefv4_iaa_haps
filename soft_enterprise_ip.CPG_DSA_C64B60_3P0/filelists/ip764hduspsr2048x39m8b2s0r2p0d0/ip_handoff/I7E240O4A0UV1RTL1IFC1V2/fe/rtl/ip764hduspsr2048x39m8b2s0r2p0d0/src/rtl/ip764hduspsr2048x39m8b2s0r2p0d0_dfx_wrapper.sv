/////////////////////////////////////////////////////////////////////////////////////////////
// Intel Confidential                                                                      //
/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2023 Intel Corporation. The information contained herein is the proprietary   //
// and confidential information of Intel or its licensors, and is supplied subject to, and //
// may be used only in accordance with, previously executed agreements with Intel.         //
// EXCEPT AS MAY OTHERWISE BE AGREED IN WRITING: (1) ALL MATERIALS FURNISHED BY INTEL      //
// HEREUNDER ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND; (2) INTEL SPECIFICALLY     //
// DISCLAIMS ANY WARRANTY OF NONINFRINGEMENT, FITNESS FOR A PARTICULAR PURPOSE OR          //
// MERCHANTABILITY; AND (3) INTEL WILL NOT BE LIABLE FOR ANY COSTS OF PROCUREMENT OF       //
// SUBSTITUTES, LOSS OF PROFITS, INTERRUPTION OF BUSINESS, OR FOR ANY OTHER SPECIAL,       //
// CONSEQUENTIAL OR INCIDENTAL DAMAGES, HOWEVER CAUSED, WHETHER FOR BREACH OF WARRANTY,    //
// CONTRACT, TORT, NEGLIGENCE, STRICT LIABILITY OR OTHERWISE.                              //
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//  Vendor:                Intel Corporation                                               //
//  Product:               c764hduspsr                                                     //
//  Version:               r1.0.0                                                          //
//  Technology:            p1276.4                                                         //
//  Celltype:              MemoryIP                                                        //
//  IP Owner:              Intel CMO                                                       //
//  Creation Time:         Tue Mar 28 2023 19:11:52                                        //
//  Memory Name:           ip764hduspsr2048x39m8b2s0r2p0d0                                 //
//  Memory Name Generated: ip764hduspsr2048x39m8b2s0r2p0d0                                 //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////

//lintra push -2218
//lintra push -60039

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// DFX WRAPPER
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// control the defines for FPGA/Emulation usage
//---------------------------------------------------------------------------
`ifdef INTEL_FPGA
  `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_FPGA_MODE
  `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_EF_MODE
  `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_SVA_OFF
  `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_TESTMODE
  `ifdef INTC_MEM_ESP
    `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_ESP_TASKS
    `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_EF_SIM
  `endif
`else
  `ifdef INTEL_EMULATION
    `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_EMULATION
    `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_EF_MODE
    `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_SVA_OFF
    `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_TESTMODE
    `ifdef INTC_MEM_ESP
      `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_ESP_TASKS
      `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_EF_SIM
    `endif
  `else
    `ifdef INTC_MEM_FAST_SIM
      `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_EMULATION
      `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_EF_MODE
      `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_SVA_OFF
      `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_TESTMODE
      `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_EF_SIM
      `ifdef INTC_MEM_ESP
        `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_ESP_TASKS
      `endif
    `else
      `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_ESP_TASKS
    `endif
  `endif
`endif
`ifdef INTEL_SVA_OFF
  `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_SVA_OFF
`endif // INTEL_SVA_OFF
`ifdef INTC_MEM_TESTMODE
  `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_TESTMODE
`endif // INTC_MEM_TESTMODE
`ifdef INTC_MEM_EF_SIM
  `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_EF_SIM
`endif // INTC_MEM_EF_SIM
`ifdef INTC_MEM_DISABLE_CTECH_SCAN_FEATURES
  `define INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_DISABLE_CTECH_SCAN_FEATURES
`endif // INTC_MEM_DISABLE_CTECH_SCAN_FEATURES

module ip764hduspsr2048x39m8b2s0r2p0d0_MEM_DFX_WRP_OBS //lintra s-52000
#(
    parameter OBS_PIN_NUM  = 1,
    parameter OBS_XOR_SIZE = 3,
    parameter OBS_FLOP_NUM = ( OBS_PIN_NUM / OBS_XOR_SIZE ) + ( ( OBS_PIN_NUM % OBS_XOR_SIZE ) > 0 ) //lintra s-2056
)
(
    input                       Clock,   //lintra s-68099
//  input                       Reset,   //lintra s-68099
    input   [OBS_PIN_NUM-1:0]   In,      //lintra s-60010
    output  [OBS_FLOP_NUM-1:0]  Out      //lintra s-60010
);

logic  [OBS_FLOP_NUM-1:0]          ObsFlops_notouch;
wire   [OBS_FLOP_NUM-1:0]          ObsWires;

assign Out = ObsFlops_notouch;
genvar i;
generate
    for (i = 0; i < OBS_FLOP_NUM; i = i+1) begin : ObsAssign  //lintra s-60118
        if (i < OBS_FLOP_NUM - 1) begin : ObsWire_0 //lintra s-60018
            assign ObsWires[i] = ^ In[i*OBS_XOR_SIZE + OBS_XOR_SIZE-1 : i*OBS_XOR_SIZE];
        end else begin : ObsWire_1 //lintra s-60018
            assign ObsWires[i] = ^ In[OBS_PIN_NUM-1 : i*OBS_XOR_SIZE]; //lintra s-2050
        end
    end
//  always @ (posedge Clock) begin //lintra s-50000
//        ObsFlops <= ObsWires;
//  end
//  use of iff makes sure that block does not get
//  triggered due to posedge of clk when Reset == 1
//  always_ff @(posedge Clock iff Reset == 0 or negedge Reset)
//  always @(posedge Clock or negedge Reset) //lintra s-50000
    always @(posedge Clock) //lintra s-50000
    begin
//    if (Reset)
//    begin
//      $display ("Reset is asserted : ObsFlops are reset");
//      ObsFlops_notouch <= {OBS_FLOP_NUM{1'b0}};
//    end
//    else
//    begin
        ObsFlops_notouch <= ObsWires;
//    end
    end
endgenerate

endmodule

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// HiP upf wrapper module
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

module ip764hduspsr2048x39m8b2s0r2p0d0_upf_wrapper (

// INPUTS
  input  wire  clk,           // Clock input
`ifndef INTEL_NO_PWR_PINS
`ifdef INTC_ADD_VSS
  input  wire  vss, //lintra s-0527, s-60010
`endif

  input  wire  vddp,     //lintra s-0527, s-60010 // Memory Periphery Power Supply
`endif
  input  wire  wen,            // Write enable
  input  wire  ren,            // Read enable
  input  wire  [10:0] adr,            // Address Bus

  input  wire  [39:0] din, // Data Input Bus
  input  wire  async_reset,          // Firewall signal to firewall inputs and reset outputs

  input  wire  arysleep,     // Enables array sleep mode
  input  wire  [1:0] sbc,    // Sleep bias level control bus
  input  wire  mce,          // Enables pin programmable control of timing margin settings (fusedatsa_mc00b[5])
  input  wire  stbyp,        // Overrides self-timed clocking to support debug (fusedatsa_mc00b[4])
  input  wire  [3:0] rmce,   // Read margin control bus (fusedatsa_mc00b[3:0])
  input  wire  [1:0] wmce,   // Write margin control bus (sramvccpwmod[3:2])
  input  wire  [2:0] wpulse, // Write pulse control bus (sramvccbiasen, sramvccpwmod[1:0])
  input  wire  [1:0] ra,     // Read assist level control bus (sramwlbiasloc)
  input  wire  [2:0] wa,     // Write assist level control bus (sramvccbias)
  input  wire  [1:0] redrowen,        // redundant row enable
  input  wire  isolation_control_in, // isolation_control signal;

// OUTPUTS

  output wire  [39:0] q // Data Output Bus
); //lintra s-68000

// ---------------------------------------------------------------------------
// Instantiate "HIP" behavioral model
// ----------------------------------
ip764hduspsr2048x39m8b2s0r2p0d0 ip764hduspsr2048x39m8b2s0r2p0d0 (
   .clk(clk)
`ifndef INTEL_NO_PWR_PINS
`ifndef INTEL_DC
`ifdef INTC_ADD_VSS
  ,.vss(vss)
`endif

  ,.vddp(vddp)
`endif
`endif
  ,.async_reset(async_reset)

  ,.din(din)
  ,.ren(ren)
  ,.wen(wen)

  ,.redrowen(redrowen)

  ,.adr(adr)
  ,.arysleep(arysleep)
  ,.sbc(sbc)
  ,.mce(mce)
  ,.stbyp(stbyp)
  ,.wmce(wmce)
  ,.rmce(rmce)
  ,.wpulse(wpulse)
  ,.ra(ra)
  ,.wa(wa)

  ,.q(q)
);

endmodule

//=============================================================================
// End of HiP upf wrapper module"
//=============================================================================

// ----------------------------------------------
// Main module
// ----------------------------------------------
//lintra push -68099
module ip764hduspsr2048x39m8b2s0r2p0d0_dfx_wrapper #( //lintra s-52000, s-68000
  parameter BYPASS_CLK_MUX         = 1, // 1-Bypass clock mux
  parameter BYPASS_RST_B_SYNC      = 1, // 1-Bypass reset synchronizer
  parameter BYPASS_AFD_SYNC        = 1, // 1-Bypass array freeze synchronizer
  parameter NUM_ROW_REPAIRS        = 2,
  parameter NUM_COL_REPAIRS        = 1,
  parameter BYPASS_TRIM_LATCHES    = 0, // 1-no trim latches are present, 0-trim latches are present
  parameter BYPASS_REPAIR_LATCHES  = 0, // 1-no repair latches are present, 0-repair latches are present
  parameter RD_OUTPUT_MODE         = 0, // 0-Output Mux, 1-Bare SDL
  parameter OBS_XOR_SIZE           = 3,
  parameter CLOCK_METHODOLOGY      = 0  // (0=CTS [CMO], 1=CTMesh [SDG])
) (
`ifndef INTEL_NO_PWR_PINS
`ifdef INTC_ADD_VSS
  vss,
`endif

  vccsoc_lv,              // vnn voltage
  vccsocaon_lv,           // vnn voltage level but AON
`endif

  IP_RESET_B,             // Obs/Cap flop reset control
  PWR_MGMT_IN,            // Power control bus
  FUNC_CLK_IN,            // baseline clock
  FUNC_ADDR_IN,           // set to access data array
  FUNC_RD_EN_IN,          // read enable
  FUNC_WR_EN_IN,          // global write enable
  FUNC_WR_DATA_IN,        // input data

  TRIM_FUSE_IN,           // Trim bit fuses
  SLEEP_FUSE_IN,          // Sleep bias fuses

  ROW_REPAIR_IN,          // Redundant row repair bus
  COL_REPAIR_IN,          // Redundant column repair bus
  GLOBAL_RROW_EN_IN,      // HB redundant row enables

  BIST_ENABLE,            // BIST/Functional  mux select
  BIST_CLK_IN,            // BIST Clock
  BIST_ADDR_IN,           // BIST Address
  BIST_RD_EN_IN,          // BIST Read Enable
  BIST_WR_EN_IN,          // BIST Write Enable
  BIST_WR_DATA_IN,        // BIST data in


  FSCAN_RAM_BYPSEL,       // Sync bypass select
  FSCAN_RAM_WDIS_B,       // Ram sequential mode write enable
  FSCAN_RAM_RDIS_B,       // Ram sequential mode write enable
  FSCAN_RAM_INIT_EN,
  FSCAN_RAM_INIT_VAL,
  FSCAN_CLKUNGATE,        // Scan control to ungate clocks
  WRAPPER_CLK_EN,         // Functional ungate of wrapper clocks
  ARRAY_FREEZE,           //signal to support array freeze and dump

  ISOLATION_CONTROL_IN,   //signal to support isolation in HiP upf wrapper
  OUTPUT_RESET,           //output reset signal for HiP

  PWR_MGMT_OUT,
  DATA_OUT                // data output
  );

// --------------------------------------------
// Parameters
// --------------------------------------------

localparam COL_RED_SLICES       = 1;
localparam DATA_WIDTH           = 39;
localparam HB_DATA_WIDTH        = 40;
localparam ADDR_WIDTH           = 11;
localparam WR_BYTEN_WIDTH       = 0;
localparam FUSE_WIDTH           = 20;
localparam ROW_REPAIR_WIDTH     = 12;
localparam COL_REPAIR_WIDTH     = 12;
localparam RROW_WIDTH           = 26;
localparam RCOL_WIDTH           = 13;
localparam POWER_WIDTH          = 6;
localparam SSA_WORDS            = 2048;
localparam ROW_BITS             = 8;
localparam COL_BITS             = 3;
localparam BNK_BITS             = 1;
localparam MAX_ROW              = 127;
localparam MAX_COL              = 7;
localparam MAX_BANK             = 1;
localparam LSR_BITS             = 3;


// --------------------------------------------
// Interface signals
// --------------------------------------------
// INPUTS
`ifndef INTEL_NO_PWR_PINS
`ifdef INTC_ADD_VSS
  input  wire  vss;
`endif

input  logic                        vccsoc_lv;  //lintra s-60010
input  logic                        vccsocaon_lv;  //lintra s-60010
`endif

input  logic                        IP_RESET_B;
input  logic [POWER_WIDTH-1:0]      PWR_MGMT_IN;
input  logic                        FUNC_CLK_IN;
input  logic                        FUNC_WR_EN_IN;
input  logic                        FUNC_RD_EN_IN;
input  logic [ADDR_WIDTH-1:0]       FUNC_ADDR_IN;
input  logic [DATA_WIDTH-1:0]       FUNC_WR_DATA_IN;

input  logic [FUSE_WIDTH-1:0]       TRIM_FUSE_IN;
input  logic [1:0]                  SLEEP_FUSE_IN;
input  logic [RROW_WIDTH-1:0]       ROW_REPAIR_IN;
input  logic [RCOL_WIDTH-1:0]       COL_REPAIR_IN;
input  logic [1:0]                  GLOBAL_RROW_EN_IN;
input  logic                        BIST_ENABLE;
input  logic                        BIST_CLK_IN;
input  logic                        BIST_WR_EN_IN;
input  logic                        BIST_RD_EN_IN;
input  logic [ADDR_WIDTH-1:0]       BIST_ADDR_IN;
input  logic [DATA_WIDTH-1:0]       BIST_WR_DATA_IN;

//lintra push -0527
input  logic                        FSCAN_RAM_BYPSEL;
input  logic                        FSCAN_RAM_WDIS_B;
input  logic                        FSCAN_RAM_RDIS_B;
//lintra pop
input  logic                        FSCAN_RAM_INIT_EN;
input  logic                        FSCAN_RAM_INIT_VAL;
input  logic                        FSCAN_CLKUNGATE;
input  logic                        WRAPPER_CLK_EN;
input  logic                        ARRAY_FREEZE;

input  logic                        ISOLATION_CONTROL_IN;
input  logic                        OUTPUT_RESET;

// OUTPUTS
output logic [0:0]                  PWR_MGMT_OUT;
output logic [DATA_WIDTH-1:0]       DATA_OUT;

//LV_pragma translate_off

// --------------------------------------------
// Internal signals
// --------------------------------------------
wire   [1:0]                   redrow_en; // address matches redundant address

// --------------------------------------------
// HB interface wires
// --------------------------------------------
wire   [ADDR_WIDTH-1:0]        ADDR_toMem; // Write addr to memory
wire   [HB_DATA_WIDTH-1:0]     DATAIN_toMem; //input data after colred mux
wire   [HB_DATA_WIDTH-1:0]     DATAOUT_fromMem; //output data from memory
wire   [DATA_WIDTH-1:0]        DATAOUT_fromByp; //output data from bypass Mux

wire   [HB_DATA_WIDTH-1:0]     DATAIN_toCrd; //input data before colred mux
wire   [DATA_WIDTH-1:0]        DATAOUT_fromCrd; //output data from colred

wire                           CLK_toMem;
wire                           mbisten ;
wire                           FUNC_WEN_IN; // BIST-muxed input
wire                           FUNC_REN_IN; // BIST-muxed input

wire                           CLK_ENABLE;
wire                           FUNC_CLK_IN_SYNC_GATED;
wire                           FUNC_CLK_IN_OBSBYP_GATED;
wire                           FWEN_toMem;
wire                           RESET_FSCAN_INIT_EN;

localparam OBS_PIN_NUM = ( 50 ) ; //lintra s-2056

localparam BYPSIZE = ( OBS_PIN_NUM / OBS_XOR_SIZE ) + ( ( OBS_PIN_NUM % OBS_XOR_SIZE ) > 0 ); //lintra s-2056
localparam REPSIZE = ( OBS_PIN_NUM / BYPSIZE ) + ( ( OBS_PIN_NUM % BYPSIZE ) > 0 ); //lintra s-2056

logic [BYPSIZE-1:0] mem_bypass_reg; //lintra s-0531 // Bypass data (FLOP)

wire FUNC_WEN_IN_ramseq;
wire FUNC_REN_IN_ramseq;

// ---------------
// Fuse latching
// ---------------
// latching the fuses
logic [RROW_WIDTH-1:0] row_repair_in_no_scan;
logic [RCOL_WIDTH-1:0] col_repair_in_no_scan;
logic [FUSE_WIDTH-1:0] trim_fuse_in_no_scan;

wire [1:0] sleep_fuse_in_no_scan;

wire valid_row_repair_1;
wire valid_row_repair_2;
wire valid_col_repair;
logic redcol_en;


generate
if (NUM_ROW_REPAIRS == 2)
begin : gen_redrow_fuse
  if (BYPASS_REPAIR_LATCHES == 1)
  begin : no_row_repair_fuse_latch
    assign row_repair_in_no_scan = ROW_REPAIR_IN;
  end
  else
  begin : row_repair_fuse_latch
    always_latch begin: redfuse_no_scan
      if (~FSCAN_RAM_INIT_EN) begin
        row_repair_in_no_scan <= ROW_REPAIR_IN;
      end
    end
  end
end
endgenerate



generate
if (NUM_COL_REPAIRS == 1)
begin : gen_redcol_fuse
  if (BYPASS_REPAIR_LATCHES == 1)
  begin : no_col_repair_fuse_latch
    assign col_repair_in_no_scan = COL_REPAIR_IN;
  end
  else
  begin : col_repair_fuse_latch
    always_latch begin: redfuse_no_scan
      if (~FSCAN_RAM_INIT_EN) begin
        col_repair_in_no_scan <= COL_REPAIR_IN;
      end
    end
  end
end
endgenerate


if (BYPASS_TRIM_LATCHES == 1)
begin : no_trim_fuse_latch
  assign trim_fuse_in_no_scan = TRIM_FUSE_IN;
end
else
begin : trim_fuse_latch
  always_latch begin: trimfuse_no_scan
    if (~FSCAN_RAM_INIT_EN) begin
      trim_fuse_in_no_scan <= TRIM_FUSE_IN;
    end
  end
end

// sleep bias inputs are on AON domain
assign sleep_fuse_in_no_scan = SLEEP_FUSE_IN;

generate
logic rst_sync_b, afd_sync;

// ----------------
// BIST ENABLE mux 
// ----------------
assign mbisten = FSCAN_RAM_INIT_EN ?  FSCAN_RAM_INIT_VAL : BIST_ENABLE;

// ---------------
// BIST CLOCK mux
// ---------------
if (BYPASS_CLK_MUX == 1'b0)
  begin : gen_clkmux
    ctech_lib_clk_mux_2to1 clk_mux_2to1_obsbyp_0 (.clkout(CLK_toMem), .clk1(BIST_CLK_IN), .clk2(FUNC_CLK_IN), .s(mbisten)); //lintra s-60706
  end
else //of if (BYPASS_CLK_MUX == 0)
  begin : dont_gen_clkmux
    assign CLK_toMem = FUNC_CLK_IN;
  end

// ---------------
// Clock gating for bypass and capture flops and synchronizers
// ---------------

assign CLK_ENABLE = WRAPPER_CLK_EN | FSCAN_CLKUNGATE ;

  if ((BYPASS_RST_B_SYNC == 1'b0) || (BYPASS_AFD_SYNC == 1'b0))
  begin : bypass_sync_clk
    // control for clock to synchronizers (free clock)
    ctech_lib_clk_gate_and clk_gate_and_en_sync (.clkout(FUNC_CLK_IN_SYNC_GATED),.clk(FUNC_CLK_IN),.en(CLK_ENABLE)); //lintra s-60706
  end

    // control for clock to bypass/observation flops (obs clock)
ctech_lib_clk_gate_and clk_obsbyp_gate_and_en_sync (.clkout(FUNC_CLK_IN_OBSBYP_GATED),.clk(FUNC_CLK_IN),.en(FSCAN_CLKUNGATE)); //lintra s-60706

// ---------------
// IP_RESET Bypass Synchronizer
// ---------------
  if (BYPASS_RST_B_SYNC == 1'b0)
    begin : gen_rst_sync_b
      ctech_lib_doublesync rst_sync_no_scan (.o(rst_sync_b),.clk(FUNC_CLK_IN_SYNC_GATED),.d(IP_RESET_B)); //lintra s-60706
    end
  else
    begin : dont_gen_rst_sync_b
      assign rst_sync_b = IP_RESET_B;
    end

// ---------------
// ARRAY FREEZE Bypass Synchronizer
// ---------------
  if (BYPASS_AFD_SYNC == 1'b0)
    begin : gen_afd_sync
      ctech_lib_doublesync afd_sync_no_scan (.o(afd_sync),.clk(FUNC_CLK_IN_SYNC_GATED),.d(ARRAY_FREEZE)); //lintra s-60706
    end
  else
    begin : dont_gen_afd_sync
      assign afd_sync = ARRAY_FREEZE;
    end

// ---------------
// OUTPUT_RESET logic
// ---------------
assign RESET_FSCAN_INIT_EN = FSCAN_RAM_INIT_EN | rst_sync_b;
assign FWEN_toMem = ~RESET_FSCAN_INIT_EN | FSCAN_RAM_BYPSEL | PWR_MGMT_IN[2] | OUTPUT_RESET;

// ------------------------------------------------------------
// Begin MSWT_MODE
// ------------------------------------------------------------
// -----------------------------
//  MSWT_MODE = 00 - Ram_sequential_Bypass mode
// -----------------------------
// Start MSWT_MODE = 00 - Ram Sequential Bypass mode

// Ram sequential mode Array DFT
assign FUNC_WEN_IN_ramseq = FUNC_WEN_IN & (~afd_sync & FSCAN_RAM_WDIS_B); // Needed for inverted clocks
assign FUNC_REN_IN_ramseq = FUNC_REN_IN & FSCAN_RAM_RDIS_B;

// ----------------------------------------------
// BIST muxes
// ----------------------------------------------
assign  ADDR_toMem[ADDR_WIDTH-1:0] = mbisten ? BIST_ADDR_IN : FUNC_ADDR_IN;
assign  FUNC_WEN_IN = mbisten ? BIST_WR_EN_IN : FUNC_WR_EN_IN;
assign  FUNC_REN_IN = mbisten ? BIST_RD_EN_IN : FUNC_RD_EN_IN ;

// For COLUMN REDUNDANCY
 // Redundant I/O is tied to msb of input data for Burn In purposes.
 // If bit enables are available, the write is disabled for the BAD I/O in order to conserve power.
assign DATAIN_toCrd[HB_DATA_WIDTH-1]  = mbisten 
                                      ? BIST_WR_DATA_IN[DATA_WIDTH-1]
                                      : FUNC_WR_DATA_IN[DATA_WIDTH-1];

assign DATAIN_toCrd[DATA_WIDTH-1:0]   = mbisten
                                      ? BIST_WR_DATA_IN
                                      : FUNC_WR_DATA_IN;


endgenerate


// ----------------------------------------------
// ROW REPAIR LOGIC
// ----------------------------------------------
//Most Significant Address bits selects the row
generate
  if (NUM_ROW_REPAIRS == 2)

    begin : gen_redrowen
// If row address outside valid range, then row repair enable should be set to zero.
//    assign valid_row_repair_2 = ~|row_repair_in_no_scan[RROW_WIDTH-1:ROW_BITS+14];
//    assign valid_row_repair_1 = ~|row_repair_in_no_scan[12:ROW_BITS+1];
      assign valid_row_repair_2 = (row_repair_in_no_scan[RROW_WIDTH-1:14] <= (256 - 1)) ? 1'b1 : 1'b0 ;
      assign valid_row_repair_1 = (row_repair_in_no_scan[12:1] <= (256 - 1)) ? 1'b1 : 1'b0 ;

      assign redrow_en[1] = (((ADDR_toMem[11-1:11-8] == row_repair_in_no_scan[(ROW_BITS+14)-1:14])
                              && (row_repair_in_no_scan[13] == 1'b1)) && (FSCAN_RAM_WDIS_B || FSCAN_RAM_RDIS_B)) ? valid_row_repair_2 : 1'b0;
      assign redrow_en[0] = (((ADDR_toMem[11-1:11-8] == row_repair_in_no_scan[(ROW_BITS+1)-1:1])
                              && (row_repair_in_no_scan[0] == 1'b1)) && (FSCAN_RAM_WDIS_B || FSCAN_RAM_RDIS_B)) ? valid_row_repair_1 : 1'b0;
    end
  else
    begin : dont_gen_redrowen
      assign redrow_en[1:0] = GLOBAL_RROW_EN_IN[1:0];
    end
endgenerate
  


// ----------------------------------------------
// COLUMN REPAIR LOGIC
// ----------------------------------------------

// If column address outside valid range, then col repair enable should be set to zero.

generate
  genvar i,j,k,m;
  if (NUM_COL_REPAIRS == 1)
    begin : gen_redcolumn
      wire [31:0] badcolumn;
//    assign valid_col_repair = ~|col_repair_in_no_scan[12:7];
      assign valid_col_repair = (col_repair_in_no_scan[12:1] < DATA_WIDTH) ? 1'b1 : 1'b0;
      assign redcol_en = ((col_repair_in_no_scan[0] == 1'b1) && (FSCAN_RAM_WDIS_B || FSCAN_RAM_RDIS_B)) ? valid_col_repair : 1'b0;
      assign badcolumn = {{32-7+1{1'b0}},col_repair_in_no_scan[7-1:1]};
      for (i = 0 ; i < COL_RED_SLICES; i = i + 1) begin: loop3 //lintra s-60118 // loop #repcols
        for (j = 1 ; j < HB_DATA_WIDTH; j = j + 1) begin: loop4 //lintra s-60118 // loop columns
          // -------------------------------------------------
          // INPUT DATA REDUNDANT COLUMN MUXING
          // -------------------------------------------------
          assign DATAIN_toMem [j+(HB_DATA_WIDTH*i)]
//         = (col_repair_in_no_scan[0] // enabled?
           = (redcol_en // enabled?
              && ((j+(HB_DATA_WIDTH*i)) > badcolumn // bigger?
                 )
             )
           ? DATAIN_toCrd[j+(HB_DATA_WIDTH*i)-1] //do the shift if bigger
//           : ((col_repair_in_no_scan[0] // enabled?
//               && ((j+(HB_DATA_WIDTH*i)) == badcolumn) // match?
//              )
//              ? 1'b0 // tie0 (lower leakage) if equal (damaged col)
//              : DATAIN_toCrd[j+(HB_DATA_WIDTH*i)] // smaller, remain as is
//             );
           : DATAIN_toCrd[j+(HB_DATA_WIDTH*i)]; // eq to or smaller, use as is
           // The above writes same data to bad column as well,
           // but only for non bit write enable configuration.  See the BWE
           // section below on bit write enabled configurations.
           // This is for testing coverage purposes, i.e.  looking for shorts
           // between bad column and adjacent good column.

        end //loop4 columns

        // -------------------------------------------------
        // INPUT DATA REDUNDANT COLUMN MUXING, column 0 case
        // -------------------------------------------------
        assign DATAIN_toMem[HB_DATA_WIDTH*i]
//          = (col_repair_in_no_scan[0] // enabled?
//             && (HB_DATA_WIDTH*i) == badcolumn // match?
//            )
//          ? 1'b0 //failing col is col0 - tie0 (lower leakage)
//          : DATAIN_toCrd[HB_DATA_WIDTH*i]; //col0 is not failed
          = DATAIN_toCrd[HB_DATA_WIDTH*i]; // use as is if bad or not
          // See above comments in loop section.  Bad column get originally
          // intended data regardless.

      end //loop3 repair columns

      // -------------------------------------------------
      // OUTPUT DATA REDUNDANT COLUMN MUXING
      // -------------------------------------------------
      for (k = 0 ; k < COL_RED_SLICES; k = k + 1) begin: loop1 //lintra s-60118 // loop #repcols
        for (m = 0 ; m < (HB_DATA_WIDTH-1); m = m + 1) begin: loop2 //lintra s-60118 // loop cols
          assign DATAOUT_fromCrd[m+HB_DATA_WIDTH*k]
//         = (col_repair_in_no_scan[0] // enabled?
           = (redcol_en // enabled?
              && ((m+(HB_DATA_WIDTH*k)) >= badcolumn)) // bigger?
           ? DATAOUT_fromMem[m+(HB_DATA_WIDTH*k)+1] // match?
           : DATAOUT_fromMem[m+(HB_DATA_WIDTH)*k]; // column not failed
        end //loop1 #repcols
      end //loop2 columns
    end //gen_redcolmn
  else
    begin : dont_gen_redcolmn
  
      // output data
      assign DATAOUT_fromCrd[DATA_WIDTH-1:0] = DATAOUT_fromMem[DATA_WIDTH-1:0];

      // input data
      assign DATAIN_toMem[HB_DATA_WIDTH-1:0] = DATAIN_toCrd[HB_DATA_WIDTH-1:0];

    end //dont_gen_redcolmn

endgenerate
  
// ----------------------------------------------
// "Q" Output
// ----------------------------------------------
`ifdef INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_DISABLE_CTECH_SCAN_FEATURES
  assign DATA_OUT[DATA_WIDTH-1:0] = DATAOUT_fromByp[DATA_WIDTH-1:0];
`else // INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_DISABLE_CTECH_SCAN_FEATURES
  ctech_lib_buf ctech_buf_out_[DATA_WIDTH-1:0] ( .a(DATAOUT_fromByp), .o(DATA_OUT) ); //lintra s-60706
`endif // INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_DISABLE_CTECH_SCAN_FEATURES

if (RD_OUTPUT_MODE == 0)
  begin : data_bypass
    // ----------------------------------------------
    // Bypass/Observation flops
    // ----------------------------------------------
    //lintra push -52000, -60010, -80028, -60118, -0214
    
    // Begin bypass/observe flops for data input
    
        ip764hduspsr2048x39m8b2s0r2p0d0_MEM_DFX_WRP_OBS
        #(.OBS_PIN_NUM   (OBS_PIN_NUM),
          .OBS_XOR_SIZE  (OBS_XOR_SIZE) // set to ONE for no compression
         )
        i_ip764hduspsr2048x39m8b2s0r2p0d0_MEM_DFX_WRP_OBS_BYP (
          .Clock         ( FUNC_CLK_IN_OBSBYP_GATED    ) , // i
//        .Reset         ( ~rst_sync_b          ) , // i
          .In            ( {ADDR_toMem,
                            DATAIN_toCrd[DATA_WIDTH-1:0]} ), // i [OBS_PIN_NUM-1:0]
          .Out           ( mem_bypass_reg)   // o [OBS_FLOP_NUM-1:0]
        );

    //lintra pop
  end
`ifndef INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_EF_MODE
else
  begin : no_data_bypass
    // ----------------------------------------------
    // Bypass/Observation flops
    // ----------------------------------------------
    //lintra push -52000, -60010, -80028, -60118, -0214
    
    // Begin bypass/observe flops for data input
    
        ip764hduspsr2048x39m8b2s0r2p0d0_MEM_DFX_WRP_OBS
        #(.OBS_PIN_NUM   (OBS_PIN_NUM),
          .OBS_XOR_SIZE  (OBS_XOR_SIZE) // set to ONE for no compression
         )
        i_ip764hduspsr2048x39m8b2s0r2p0d0_MEM_DFX_WRP_OBS_BYP (
          .Clock         ( FUNC_CLK_IN_OBSBYP_GATED    ) , // i
//        .Reset         ( ~rst_sync_b          ) , // i
          .In            ( {ADDR_toMem,
                            DATAIN_toCrd[DATA_WIDTH-1:0]} ), // i [OBS_PIN_NUM-1:0]
         .Out           ()
       );

   //lintra pop
  end
`endif // INTC_MEM_ip764hduspsr2048x39m8b2s0r2p0d0_EF_MODE


// ----------------------------------------------
// Bypass and Observation
// ----------------------------------------------
// Begin bypass registers/muxes
//always_ff @(posedge FUNC_CLK_IN_OBSBYP_GATED)
//  begin
//    mem_bypass_reg[DATA_WIDTH-1:0] <= DATAIN_toCrd[DATA_WIDTH-1:0];
//  end


if (RD_OUTPUT_MODE == 0)
  begin : output_mux
    // --------------------------------------------
    // Bypass Data Output replication
    // --------------------------------------------
    if (BYPSIZE < DATA_WIDTH)
    begin : replicate
      // replicate bits to fill bypass data register
      assign DATAOUT_fromByp = FSCAN_RAM_BYPSEL ? {REPSIZE{mem_bypass_reg[BYPSIZE-1:0]}} : DATAOUT_fromCrd[DATA_WIDTH-1:0]; //lintra s-0396
    end
    else
    begin : truncate
      // truncate bits to fill bypass data register
      assign DATAOUT_fromByp = FSCAN_RAM_BYPSEL ? mem_bypass_reg[DATA_WIDTH-1:0] : DATAOUT_fromCrd[DATA_WIDTH-1:0]; //lintra s-0396
    end
  end
  else
  begin : no_output_mux
    assign DATAOUT_fromByp = DATAOUT_fromCrd[DATA_WIDTH-1:0];
  end


// end MSWT_MODE = 00 - Ram sequential mode
// ------------------------------------------------------------
// END MSWT_MODE
// ------------------------------------------------------------

// --------------------------------------------
// BMOD UPF wrapper Instantiation
// --------------------------------------------
ip764hduspsr2048x39m8b2s0r2p0d0_upf_wrapper ip764hduspsr2048x39m8b2s0r2p0d0_upf_wrapper (
    .clk(CLK_toMem),
`ifndef INTEL_NO_PWR_PINS
`ifndef INTEL_DC
`ifdef INTC_ADD_VSS
        .vss(vss),
`endif

    .vddp(vccsocaon_lv),
`endif
`endif
    .wen(FUNC_WEN_IN_ramseq),
    .ren(FUNC_REN_IN_ramseq),
    .adr(ADDR_toMem),

    .din(DATAIN_toMem),

    .async_reset(FWEN_toMem),
//  .arysleep(PWR_MGMT_IN[5]),
    .arysleep(1'b0), // Phase 1 compiler release - constrain sleep
//  .sbc(sleep_fuse_in_no_scan),
    .sbc(2'b00), // Phase 1 compiler release - constrain sleep

    .mce(trim_fuse_in_no_scan[5]),
    .stbyp(trim_fuse_in_no_scan[4]),
    .rmce(trim_fuse_in_no_scan[3:0]),
    .wmce(trim_fuse_in_no_scan[14:13]),
    .wpulse({trim_fuse_in_no_scan[10],trim_fuse_in_no_scan[12:11]}),
    .ra(trim_fuse_in_no_scan[16:15]),
    .wa(trim_fuse_in_no_scan[19:17]),
    .redrowen(redrow_en[1:0]),
    .isolation_control_in (ISOLATION_CONTROL_IN),

    .q(DATAOUT_fromMem)
);

assign PWR_MGMT_OUT[0] = PWR_MGMT_IN[0];

// =====================================
// Include of cov_points_sram1rw.inc
// =====================================
// synopsys translate_off
`ifndef INTC_MEM_COV_OFF
//Bist RD signals
covergroup SRAM_WRAP_RD_cover @(posedge CLK_toMem);
  coverpoint BIST_RD_EN_IN iff (BIST_ENABLE) {
    bins zero_one  =  (0=>1);
    bins one_zero  =  (1=>0);
  }
  coverpoint BIST_ADDR_IN iff (BIST_ENABLE & BIST_RD_EN_IN) {
    bins add_space_rd_bist[]  =  {[0:SSA_WORDS-1]};
  }
//Func RD signals
  coverpoint FUNC_RD_EN_IN iff (!BIST_ENABLE) {
    bins zero_one  =  (0 => 1);
    bins one_zero  =  (1 => 0);
  }
  coverpoint FUNC_ADDR_IN iff (!BIST_ENABLE & FUNC_RD_EN_IN) {
    bins add_space_rd_func[]  =  {[0:SSA_WORDS-1]};
  }
// Func & Bist RD signals
  coverpoint DATA_OUT iff (FUNC_RD_EN_IN | BIST_RD_EN_IN) {
    bins data_space_zero_one  =  (0 => {DATA_WIDTH{1'b1}});
    bins data_space_one_zero  =  ({DATA_WIDTH{1'b1}} => 0);

  }
endgroup

covergroup SRAM_WRAP_WR_cover @(posedge CLK_toMem);
//Bist WR signals
  coverpoint BIST_WR_EN_IN iff (BIST_ENABLE) {
    bins zero_one  =  (0=>1);
    bins one_zero  =  (1=>0);
  }
  coverpoint BIST_ADDR_IN iff (BIST_ENABLE & BIST_WR_EN_IN) {
    bins add_space_wr_bist[]  =  {[0:SSA_WORDS-1]};
  }
  coverpoint BIST_WR_DATA_IN iff (BIST_ENABLE & BIST_WR_EN_IN) {
    bins data_space_zero_one  =  (0 => {DATA_WIDTH{1'b1}});
    bins data_space_one_zero  =  ({DATA_WIDTH{1'b1}} => 0);
  }
//Func WR signals
  coverpoint FUNC_WR_EN_IN iff (!BIST_ENABLE) {
    bins zero_one  =  (0 => 1);
    bins one_zero  =  (1 => 0);
  }
  coverpoint FUNC_ADDR_IN iff (!BIST_ENABLE & FUNC_WR_EN_IN) {
    bins add_space_wr_func[]  =  {[0:SSA_WORDS-1]};
  }
  coverpoint FUNC_WR_DATA_IN iff (!BIST_ENABLE & FUNC_WR_EN_IN) {
    bins data_space_zero_one  =  (0 => {DATA_WIDTH{1'b1}});
    bins data_space_one_zero  =  ({DATA_WIDTH{1'b1}} => 0);
  }
endgroup


SRAM_WRAP_RD_cover SRAM_WRAP_RD_cover_i = new;
SRAM_WRAP_WR_cover SRAM_WRAP_WR_cover_i = new;
`endif // INTC_MEM_COV_OFF
// synopsys translate_on


// =====================================
// =====================================

//LV_pragma translate_on

endmodule
//lintra pop
//lintra pop
//lintra pop

