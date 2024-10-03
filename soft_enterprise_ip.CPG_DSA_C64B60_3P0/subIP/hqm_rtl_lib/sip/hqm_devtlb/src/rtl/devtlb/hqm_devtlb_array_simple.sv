//=====================================================================================================================
//
// devtlb_array_simple.sv
//
// Contacts            : Hai Ming Khor
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016-2017 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_DEVTLB_ARRAY_SIMPLE_VS
`define HQM_DEVTLB_ARRAY_SIMPLE_VS

// Global includes
`include "hqm_devtlb_pkg.vh"

// Sub-module includes
`include "hqm_devtlb_genram_wrap.sv"           // RP-based latch array wrapper
`include "hqm_devtlb_gram_sdp.v"               // FPGA-based generic array

module hqm_devtlb_array_simple
#(
   parameter         logic NO_POWER_GATING  = 1'b1,
   parameter         int NUM_RD_PORTS        = 1,     // Minimum 1
   parameter         int NUM_PIPE_STAGE      = 1,     // Minimum 1
   parameter         int ENTRY               = 256,    // Minimum 1
   parameter type    T_ENTRY                 = logic [0:0],
   parameter         logic CAM_EN            = 1,
   parameter type    T_CAMENTRY              = logic [0:0],

   parameter         logic RD_PRE_DECODE     = 0,     // Pre-decode the set addresses into a 1-hot vector to pass to the array
                                                      // This shifts the decode logic to before the clock for the read

   parameter         int ARRAY_STYLE         = 2      // Array Style
                                                      // 0 = LATCH Array      (gt_ram_sv)
                                                      // 1 = FPGA gram Array  (gram_sdp)
                                                      // 2 = RF Array         (customer provided)
                                                      // 3 = MSFF Array       (gt_ram_sv)

)(
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST
   PwrDnOvrd_nnnH,

   CamEnSpec_nnnH,
   CamEn_nnnH,
   CamData_nnnH,
   CamHit_nn1H,

   RdEnSpec_nnnH,
   RdEn_nnnH,
   RdAddr_nnnH,
   RdData_nn1H,

   WrEn_nnnH,
   WrAddr_nnnH,
   WrData_nnnH
//lintra +68099
);

   import `HQM_DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the DEVTLB

   localparam         int ENTRY_IDW          = `HQM_DEVTLB_LOG2(ENTRY); // External pre-decode
   localparam         int RD_ADDR_BITS       = RD_PRE_DECODE ? ENTRY : ENTRY_IDW;    // Internal pre-decode

//======================================================================================================================
//                                           Interface signal declarations
//======================================================================================================================

   `HQM_DEVTLB_COMMON_PORTDEC
   `HQM_DEVTLB_FSCAN_PORTDEC

   input    logic                               PwrDnOvrd_nnnH;      // Powerdown override

   //==================================================================================================================
   //
   // Primary interface to/from hosting unit
   //
   //==================================================================================================================

   // CAM Interface
   //
   input    logic                                                 CamEnSpec_nnnH;
   input    logic                                                 CamEn_nnnH;
   input    T_CAMENTRY                                            CamData_nnnH;
   output   logic    [ENTRY-1:0]                                  CamHit_nn1H;

   // Read Interface
   //
   input    logic    [NUM_RD_PORTS-1:0]                           RdEnSpec_nnnH; // Used to fire clocks...can be used when true read enable is slower to generate
   input    logic    [NUM_RD_PORTS-1:0]                           RdEn_nnnH;
   input    logic    [NUM_RD_PORTS-1:0] [ENTRY_IDW-1:0]           RdAddr_nnnH;

   output   T_ENTRY  [NUM_RD_PORTS-1:0]                           RdData_nn1H;

   // Write Interface
   //
   input    logic                               WrEn_nnnH;
   input    logic    [ENTRY_IDW-1:0]            WrAddr_nnnH;
   input    T_ENTRY                             WrData_nnnH;

//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================

   // Local Cam Controls
   logic                                        ClkCamRcb_H; //lintra s-0531
   logic                                        ClkCam_nn1H;
   
   logic       [NUM_PIPE_STAGE-1:0]             StgCamEn_nnnH;
   T_CAMENTRY                                   CamData_nn1H;

   logic       [ENTRY-1:0]                      CamHitX_nn1H; //lintra s-0531
   logic       [ENTRY-1:0]                      IntCamHit_nnnH       [NUM_PIPE_STAGE:1];

   // Local Read Controls
   //
   logic                                        ClkRdRcb_H                          [NUM_RD_PORTS-1:0];
   logic                                        ClkRd_nn1H                          [NUM_RD_PORTS-1:0];

   logic       [NUM_PIPE_STAGE-1:0]             StgRdEn_nnnH                        [NUM_RD_PORTS-1:0];
   logic       [RD_ADDR_BITS-1:0]               RdAddr_nn1H                         [NUM_RD_PORTS-1:0];
   logic       [ENTRY-1:0]                      RdAddr1Hot_nnnH                     [NUM_RD_PORTS-1:0];  // Predecoded 

   T_ENTRY                                      RdDataX_nn1H         [NUM_RD_PORTS-1:0];
   T_ENTRY                                      IntRdData_nnnH       [NUM_RD_PORTS-1:0] [NUM_PIPE_STAGE:1];

   // Local Write Controls
   //
   logic                                        ClkWrRcb_nn1H;
   logic                                        WrEnX_nnnH;
   logic       [ENTRY_IDW-1:0]                  WrAddrX_nnnH;
   T_ENTRY                                      WrDataX_nnnH;     // lintra s-0531 // Preflop node that muxes between real write data and loopback data
   T_ENTRY                                      WrData_nn1H;
   T_ENTRY                                      WrDataInt_nnnH;
   T_ENTRY                                      WrDataInt_nn1H;

   genvar g_entry;
   genvar g_port;
   genvar g_stage;

//=====================================================================================================================
// Main Code
//=====================================================================================================================
always_comb begin
      WrDataInt_nnnH   =  WrData_nnnH;
end

generate

   if ((ARRAY_STYLE == ARRAY_LATCH)  // Use an Array-of-latches for this instantiation
   ||  (ARRAY_STYLE == ARRAY_RF)  // Use an RF for this instantiation...use latches for validation only
   ||  (ARRAY_STYLE == ARRAY_MSFF)) // Use MSFFs this instantiation
            begin : LATCH

`ifndef HQM_DEVTLB_SIMONLY 
      // This, in combination with the corresponding ifndef  DEVTLB_SIMONLY below, aids DC in removing
      // unnnecessary logic when ARRAY_STYLE == ARRAY_RF and this latch array is only used as a
      // reference model. Specifically, the CTECH based clock gate cells that are
      // marked as "don't touch" in DC are excluded in the front end preventing them from
      // existing in the netlist and being unremovable.

      if (ARRAY_STYLE != ARRAY_RF) begin : Array
`endif

        `HQM_DEVTLB_MAKE_RCB_PH1(ClkCamRcb_H, clk,                CamEnSpec_nnnH | (|StgCamEn_nnnH), PwrDnOvrd_nnnH)
        `HQM_DEVTLB_MAKE_LCB_PWR(ClkCam_nn1H, ClkCamRcb_H, CamEnSpec_nnnH, PwrDnOvrd_nnnH)

        // Cam Controls
        `HQM_DEVTLB_MSFF(CamData_nn1H, CamData_nnnH, ClkCam_nn1H)
         
         for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Ctrl
            `HQM_DEVTLB_MAKE_RCB_PH1(ClkRdRcb_H[g_port], clk,                RdEnSpec_nnnH[g_port] | (|StgRdEn_nnnH[g_port]), PwrDnOvrd_nnnH)

            `HQM_DEVTLB_MAKE_LCB_PWR(ClkRd_nn1H[g_port], ClkRdRcb_H[g_port], RdEnSpec_nnnH[g_port],                           PwrDnOvrd_nnnH)
             // Array Read Controls
             //
             // Stage read set address and read array
             //
             // If the array is Fully-Associative, force the addresses to '0
             // Use streaming operator to get signals into the right shape
             //
             // If the array is set to use 1-hot read pointers, expand the address before passing it to the array
             // If the input set address is a 1 hot vector, just pass it to the array
             //
             // Reshape the array controls to fit the dimensions of the GT array module interfaces
             //
             if (RD_PRE_DECODE) begin : Predecode
                if (ENTRY > 1)  begin : MultipleSets
                   always_comb begin
                         RdAddr1Hot_nnnH[g_port] = '0;
                      for (int set = 0; set < ENTRY; set++) begin
                            if (RdAddr_nnnH[g_port] == set) begin
                                  RdAddr1Hot_nnnH[g_port][set] = 1'b1;
                         end
                      end
                   end
                end else begin : SingleSet
                      assign     RdAddr1Hot_nnnH[g_port][0]  = 1'b1;  // Only 1 set, always indicate the first set to be read
                end

                   `HQM_DEVTLB_MSFF(RdAddr_nn1H[g_port], RdAddr1Hot_nnnH[g_port], ClkRd_nn1H[g_port])
             end // RD_PRE_DECODE
             else begin : NormalDecode
                   assign     RdAddr1Hot_nnnH[g_port]        = '0;    // Dummy assign...not used in this variation

                if (ENTRY > 1)  begin : MultipleSet
                      `HQM_DEVTLB_MSFF(RdAddr_nn1H[g_port], RdAddr_nnnH[g_port], ClkRd_nn1H[g_port])
                end else begin : SingleSet
                      assign     RdAddr_nn1H[g_port]         = '0;    // Only 1 set, always indicate the first set to be read
                end
             end // default
         end

         // Array Write Controls
         //
         if (ENTRY > 1)  begin : MultipleSets
            assign     WrAddrX_nnnH    = WrAddr_nnnH;
         end else begin : SingleSet
            assign     WrAddrX_nnnH    = '0;
         end

         `HQM_DEVTLB_MAKE_RCB_PH1(ClkWrRcb_nn1H, clk, WrEn_nnnH, PwrDnOvrd_nnnH)

         // depend on internal genram logic to provide the flop
         assign WrData_nn1H =  WrDataInt_nnnH;
         
         // Apply bit mask to allow synthesis to remove unneeded bits 
         always_comb begin
            WrDataInt_nn1H   =  WrData_nn1H;
         end

        assign WrEnX_nnnH = WrEn_nnnH;

        hqm_devtlb_genram_wrap #(
           .mode                ((ARRAY_STYLE == ARRAY_MSFF) ? 1 : 0),
           .width               ($bits(T_ENTRY)),
           .depth               (ENTRY),
           .T                   (T_ENTRY),
           .one_hot_rd_ptrs     (RD_PRE_DECODE),
           .num_rd_ports        (NUM_RD_PORTS),
           .cam_en              (CAM_EN),
           .cam_width0          ($bits(T_CAMENTRY)),
           .cam_width1          (1),
           .cam_low_bit0        (0),
           .noflopin_opt        ((ARRAY_STYLE == ARRAY_MSFF) ? 1 : 0)
                                                       // No WrData Flop....external so that it can be shared across all ways
                                                       // Allow internal flop when only 1 way to stay with base genram structure
        ) array (
           .gramclk             (ClkWrRcb_nn1H),
           .reset_b             (~reset),
           .fscan_latchopen     (fscan_latchopen),
           .fscan_latchclosed_b (fscan_latchclosed_b),

           .wren                (WrEnX_nnnH),
           .wraddr              (WrAddrX_nnnH),
           .wrdata              (WrDataInt_nn1H),

           .rdaddr              (RdAddr_nn1H),
           .rddataout           (RdDataX_nn1H),

           .storage_data        (), // lintra s-0214 // Not used in this version
           
           .cam_data0           (CamData_nn1H),
           .cam_data1           ('0),
           .cam_hit0            (CamHitX_nn1H),
           .cam_hit1            ()  //lintra s-0214
        );

        
        always_comb IntCamHit_nnnH[1] = CamHitX_nn1H;
        // Take data from per-port oriented signal for port 0
        //
        for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Data
        always_comb begin
           IntRdData_nnnH[g_port][1] = RdDataX_nn1H[g_port];
           end
        end

`ifndef HQM_DEVTLB_SIMONLY
      end : Array

      else begin : RF_MODE_OUPUTS_NOT_USED
         assign CamData_nn1H               = '0; 
         assign ClkCam_nn1H                = '0;
         assign IntCamHit_nnnH[1]          = '0;
         
         for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports
         assign ClkRdRcb_H[g_port]       = '0;
         assign RdAddr_nn1H[g_port]      = '0;
         assign RdAddr1Hot_nnnH[g_port]  = '0;
         assign ClkRd_nn1H[g_port]        = '0;
         assign IntRdData_nnnH[g_port][1] = '0;
         assign RdDataX_nn1H[g_port]      = '0; 
         end
         assign ClkWrRcb_nn1H             = '0;
         assign WrEnX_nnnH                = '0;
         assign WrAddrX_nnnH              = '0;
         assign WrDataX_nnnH              = '0;
         assign WrData_nn1H               = '0;
         assign WrDataInt_nn1H            = '0;
      end
`endif

   end : LATCH

   if (ARRAY_STYLE == ARRAY_FPGA) begin : FPGA_MEM  // Use a generic array for this instantiation (FPGA)
//TODO add cam support
      `ifndef HQM_DEVTLB_SVA_OFF
      `HQM_DEVTLB_ASSERTS_MUST(DEVTLB_Array_FPGA_Single_Port, (NUM_RD_PORTS == 1),
            posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("FPGA array styles do not support multiple read ports."));
      `endif

      if (NUM_PIPE_STAGE>1)  begin : camLatency2   // Will need this RBC later in the read stating logic
        `HQM_DEVTLB_MAKE_RCB_PH1(ClkCamRcb_H, clk,        CamEnSpec_nnnH | (|StgCamEn_nnnH), PwrDnOvrd_nnnH)
      end
      
      for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Ctrl
         if (NUM_PIPE_STAGE>1)  begin : Latency2   // Will need this RBC later in the read stating logic
            `HQM_DEVTLB_MAKE_RCB_PH1(ClkRdRcb_H[g_port], clk,        RdEnSpec_nnnH[g_port] | (|StgRdEn_nnnH[g_port]), PwrDnOvrd_nnnH)
         end
      end

     assign WrEnX_nnnH = WrEn_nnnH;

     hqm_devtlb_gram_sdp #(
        .BUS_SIZE_ADDR               (ENTRY_IDW),     // For the gram array, both read and write are the same size
        .BUS_SIZE_DATA               ($bits(WrData_nn1H)),
        .GRAM_MODE                   (2'd1)
     ) array (
`ifdef HQM_DEVTLB_SIMONLY
        .ram                 (),  //lintra s-0214
`endif
        .clk                 (clk),

        .raddr              ((ENTRY > 1) ? RdAddr_nnnH[0] : '0),
        .dout               (RdDataX_nn1H[0]),

        .we                 (WrEnX_nnnH),
        .waddr              ((ENTRY > 1) ? WrAddr_nnnH : '0),
        .din                (WrData_nnnH)
     );

     for (g_entry =0; g_entry < ENTRY; g_entry++) begin : Cam_Hit
        always_comb CamHitX_nn1H[g_entry] = '0; //TODO CamData_nn?H == ram[g_entry], check ram timing
     end
     always_comb IntCamHit_nnnH[1] = CamHitX_nn1H;
     // Take data from per-port oriented signal for port 0
     //
     for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Data
        always_comb begin
           IntRdData_nnnH[g_port][1] = RdDataX_nn1H[g_port];
        end
     end

      // Dummy assignment to satisfy Lint
      //
      assign CamData_nn1H               = '0; 
      assign ClkCam_nn1H                = '0;
      
      for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports
      assign RdAddr_nn1H[g_port]      = '0;
      assign RdAddr1Hot_nnnH[g_port]  = '0;
      assign ClkRd_nn1H[g_port]          = '0;
      end
      assign ClkWrRcb_nn1H             = '0;
      assign WrDataX_nnnH              = '0;
      assign WrData_nn1H               = '0;
      assign WrDataInt_nn1H            = '0;

   end : FPGA_MEM

endgenerate

generate

   if (NUM_PIPE_STAGE>1)  begin : gen_Latency2
`ifndef HQM_DEVTLB_SIMONLY
      if (ARRAY_STYLE != ARRAY_RF) begin : Rd_Stg
`endif
         logic       [NUM_PIPE_STAGE:2]      ClkStgCam_nnnH;

         logic                               ClkStagedCam_H;

         logic       [NUM_PIPE_STAGE:2]      ClkStgRd_nnnH[NUM_RD_PORTS-1:0];

         logic                               ClkStagedRd_H[NUM_RD_PORTS-1:0];

        assign StgCamEn_nnnH[0] =   CamEn_nnnH;

        `HQM_DEVTLB_MAKE_LCB_PWR(ClkStagedCam_H, ClkCamRcb_H, 1'b1, PwrDnOvrd_nnnH)
        
        for(g_stage = 1; g_stage < NUM_PIPE_STAGE; g_stage++) begin: cam_For_stage 
            `HQM_DEVTLB_MSFF(StgCamEn_nnnH[g_stage],  StgCamEn_nnnH[g_stage-1],   ClkStagedCam_H)

           `HQM_DEVTLB_MAKE_LCB_PWR(ClkStgCam_nnnH[g_stage+1], ClkCamRcb_H, StgCamEn_nnnH[g_stage], PwrDnOvrd_nnnH)

           `HQM_DEVTLB_MSFF(IntCamHit_nnnH[g_stage+1], IntCamHit_nnnH[g_stage], ClkStgCam_nnnH[g_stage+1])
        end
        
         for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Stage

            `HQM_DEVTLB_MAKE_LCB_PWR(ClkStagedRd_H[g_port], ClkRdRcb_H[g_port], 1'b1, PwrDnOvrd_nnnH)

            assign StgRdEn_nnnH[g_port][0] =   RdEn_nnnH[g_port];

            for(g_stage = 1; g_stage < NUM_PIPE_STAGE; g_stage++) begin: For_stage 
               `HQM_DEVTLB_MSFF(StgRdEn_nnnH[g_port][g_stage],  StgRdEn_nnnH[g_port][g_stage-1],   ClkStagedRd_H[g_port])

               `HQM_DEVTLB_MAKE_LCB_PWR(ClkStgRd_nnnH[g_port][g_stage+1], ClkRdRcb_H[g_port], StgRdEn_nnnH[g_port][g_stage], PwrDnOvrd_nnnH)

               `HQM_DEVTLB_MSFF(IntRdData_nnnH[g_port][g_stage+1], IntRdData_nnnH[g_port][g_stage], ClkStgRd_nnnH[g_port][g_stage+1])
            end
         end
`ifndef HQM_DEVTLB_SIMONLY 
      end 
`endif
   end else begin: Latency1
      assign StgCamEn_nnnH = '0; 
      for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Stage
         assign StgRdEn_nnnH[g_port] = '0;
      end
   end

   assign CamHit_nn1H = IntCamHit_nnnH[NUM_PIPE_STAGE];
   for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Output
      assign RdData_nn1H[g_port] =  IntRdData_nnnH[g_port][NUM_PIPE_STAGE];
   end

endgenerate

//============================================================================
// GLOBALS ASSERTIONS
//============================================================================

`ifndef HQM_DEVTLB_SVA_OFF

generate
   for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Asserts

   `HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_Array_RdEn_Implies_SpecRdEn, RdEn_nnnH[g_port], RdEnSpec_nnnH[g_port],
   posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Set address to access is out of bounds of array."));

   if (ENTRY > 1) begin: NUM_SET_2
      `HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_ArrayGen_Rd_Wr_Conflict,
               RdEn_nnnH[g_port] & WrEn_nnnH & (RdAddr_nnnH[g_port] == WrAddr_nnnH),
            posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB: Array Same Cycle Read/Write Conflict"));
   end  else begin: NUM_SET_1
      `HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_Rd_Wr_Conflict_Next_Cycle,
               RdEn_nnnH[g_port] & WrEn_nnnH,
            posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB Array Following Cycle Read/Write Conflict"));
   end
   end
endgenerate

`endif

endmodule

`endif // DEVTLB_ARRAY_SIMPLE_VS

