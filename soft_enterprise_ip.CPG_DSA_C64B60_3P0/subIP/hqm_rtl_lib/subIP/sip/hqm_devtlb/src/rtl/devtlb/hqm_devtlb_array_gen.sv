//=====================================================================================================================
//
// devtlb_array_gen.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016-2017 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_DEVTLB_ARRAY_GEN_VS
`define HQM_DEVTLB_ARRAY_GEN_VS

// Global includes
`include "hqm_devtlb_pkg.vh"

// Sub-module includes
`include "hqm_devtlb_genram_wrap.sv"           // RP-based latch array wrapper
`include "hqm_devtlb_gram_sdp.v"               // FPGA-based generic array

module hqm_devtlb_array_gen
#(
   parameter       logic NO_POWER_GATING     = 1'b0,  
   parameter       logic ALLOW_TLBRWCONFLICT  = 0,  //1 if TLB array allow RW conflict
   parameter         int NUM_RD_PORTS        = 1,     // Minimum 1
   parameter         int NUM_PIPE_STAGE      = 1,     // Minimum 1
   parameter         int NUM_SETS            = 16,    // Minimum 1
   parameter         int NUM_WAYS            = 4,     // Minimum 1
   parameter type    T_ENTRY                 = logic [0:0],

   parameter         logic RD_PRE_DECODE     = 0,     // Pre-decode the set addresses into a 1-hot vector to pass to the array
                                                      // This shifts the decode logic to before the clock for the read

   parameter         int MASK_BITS           = 0,     // Force the DFX Loopback to not pass certain bits. This is solely
                                                      // to make synthesis not keep bits that would otherwise be removed
                                                      // due to constant propagation.

   parameter         int ARRAY_STYLE         = 0      // Array Style
                                                      // 0 = LATCH Array      (gt_ram_sv)
                                                      // 1 = FPGA gram Array  (gram_sdp)
                                                      // 2 = RF Array         (customer provided)
                                                      // 3 = MSFF Array       (gt_ram_sv)

)(
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST
   PwrDnOvrd_nnnH,

   RdEnSpec_nnnH,
   RdEn_nnnH,
   RdSetAddr_nnnH,
   RdData_nn1H,

   WrEn_nnnH,
   WrSetAddr_nnnH,
   WrWayVec_nnnH,
   WrData_nnnH
//lintra +68099
);

   import `HQM_DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the DEVTLB

   localparam         int SET_ADDR_WIDTH     = `HQM_DEVTLB_LOG2(NUM_SETS); // External pre-decode
   localparam         int RD_ADDR_BITS       = RD_PRE_DECODE ? NUM_SETS : SET_ADDR_WIDTH;    // Internal pre-decode

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

   // Read Interface
   //
   input    logic    [NUM_RD_PORTS-1:0]                           RdEnSpec_nnnH; // Used to fire clocks...can be used when true read enable is slower to generate
   input    logic    [NUM_RD_PORTS-1:0]                           RdEn_nnnH;
   input    logic    [NUM_RD_PORTS-1:0] [SET_ADDR_WIDTH-1:0]      RdSetAddr_nnnH;

   output   T_ENTRY  [NUM_RD_PORTS-1:0] [NUM_WAYS-1:0]            RdData_nn1H;

   // Write Interface
   //
   input    logic                               WrEn_nnnH;
   input    logic    [SET_ADDR_WIDTH-1:0]       WrSetAddr_nnnH;
   input    logic    [NUM_WAYS-1:0]             WrWayVec_nnnH;
   input    T_ENTRY                             WrData_nnnH;


//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================

   // Local Read Controls
   //
   logic                                        ClkRdRcb_H                          [NUM_RD_PORTS-1:0]; //lintra s-0531
   logic                                        ClkRd_nn1H                          [NUM_RD_PORTS-1:0];

   logic       [NUM_PIPE_STAGE-1:0]             StgRdEn_nnnH                        [NUM_RD_PORTS-1:0];
   logic       [RD_ADDR_BITS-1:0]               RdSetAddr_nn1H                      [NUM_RD_PORTS-1:0];
   logic       [NUM_SETS-1:0]                   RdSetAddr1Hot_nnnH                  [NUM_RD_PORTS-1:0];  // Predecoded 

   T_ENTRY                                      RdDataX_nn1H         [NUM_WAYS-1:0] [NUM_RD_PORTS-1:0]; //lintra s-0531 
   T_ENTRY     [NUM_WAYS-1:0]                   IntRdData_nnnH                      [NUM_RD_PORTS-1:0] [NUM_PIPE_STAGE:1];

   T_ENTRY                                      DfxRdData_nn1H;  //lintra s-0531 // Loopback read data for DFX 

   // Local Write Controls
   //
   logic                                        ClkWrRcb_nn1H;
   logic                                        ClkWr_nn1H; //lintra s-0531
   logic       [NUM_WAYS-1:0]                   WrEnX_nnnH; //lintra s-0531
   logic       [SET_ADDR_WIDTH-1:0]             WrSetAddrX_nnnH;
   T_ENTRY                                      WrDataX_nnnH;     //lintra s-0531 // Preflop node that muxes between real write data and loopback data
   T_ENTRY                                      WrData_nn1H;
   T_ENTRY                                      WrDataInt_nnnH;
   T_ENTRY                                      WrDataInt_nn1H;

   // Array Contents
   //
   T_ENTRY                                      tmpArray_nnnH  [NUM_WAYS-1:0][NUM_SETS-1:0];       // Array Storage Nodes
   T_ENTRY     [NUM_SETS-1:0][NUM_WAYS-1:0]     Array_nnnH;          //lintra s-0531 // Array Storage Nodes


   genvar g_set;
   genvar g_way;
   genvar g_port;
   genvar g_stage;

//=====================================================================================================================
// Main Code
//=====================================================================================================================
always_comb begin
      WrDataInt_nnnH   =  WrData_nnnH;
      for (int databit= 0;databit< MASK_BITS; databit++) begin : DataBit
         WrDataInt_nnnH[databit] = '0;
      end
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
            if (NUM_SETS > 1)  begin : MultipleSets
               always_comb begin
                     RdSetAddr1Hot_nnnH[g_port] = '0;
                  for (int set = 0; set < NUM_SETS; set++) begin
                        if (RdSetAddr_nnnH[g_port] == set) begin
                              RdSetAddr1Hot_nnnH[g_port][set] = 1'b1;
                     end
                  end
               end
            end else begin : SingleSet
                  assign     RdSetAddr1Hot_nnnH[g_port][0]  = 1'b1;  // Only 1 set, always indicate the first set to be read
            end

               `HQM_DEVTLB_MSFF(RdSetAddr_nn1H[g_port], RdSetAddr1Hot_nnnH[g_port], ClkRd_nn1H[g_port])
         end // RD_PRE_DECODE
         else begin : NormalDecode
               assign     RdSetAddr1Hot_nnnH[g_port]        = '0;    // Dummy assign...not used in this variation

            if (NUM_SETS > 1)  begin : MultipleSet
                  `HQM_DEVTLB_MSFF(RdSetAddr_nn1H[g_port], RdSetAddr_nnnH[g_port], ClkRd_nn1H[g_port])
            end else begin : SingleSet
                  assign     RdSetAddr_nn1H[g_port]         = '0;    // Only 1 set, always indicate the first set to be read
            end
         end // default
         end

         // Array Write Controls
         //
         if (NUM_SETS > 1)  begin : MultipleSets
            assign     WrSetAddrX_nnnH    = WrSetAddr_nnnH;
         end else begin : SingleSet
            assign     WrSetAddrX_nnnH    = '0;
         end

         `HQM_DEVTLB_MAKE_RCB_PH1(ClkWrRcb_nn1H, clk, WrEn_nnnH, PwrDnOvrd_nnnH)

         // Choose between normal write data and the array's output loopback for Dfx Dumping 
         //
         if (NUM_WAYS == 1) begin : DM                       // If NUM_WAYS is one, depend on internal genram logic to provide the flop
            assign WrData_nn1H =  WrDataInt_nnnH;
         end else if (ARRAY_STYLE == ARRAY_MSFF) begin : MSFF  // MSFF array doesn't need shadow flop...it actually would be incorrect
            assign WrData_nn1H =  WrDataInt_nnnH;
         end else begin: SET_ASSOC
            // Mux in read data to the write path for DFX/Scan purposes
            //
            always_comb begin
               DfxRdData_nn1H = '0;
               for (int way = 0; way < NUM_WAYS; way++) begin : Way_Lp2
                  if ((dfx_array_scan_mode_way == way) || (NUM_WAYS == 1)) DfxRdData_nn1H |= RdData_nn1H[0][way]; // DFX support on port 0 only
               end
            end

         assign WrDataX_nnnH = (dfx_array_scan_mode_en && (ARRAY_STYLE != 3)) ? DfxRdData_nn1H : WrDataInt_nnnH;
            `HQM_DEVTLB_MAKE_LCB_PWR(ClkWr_nn1H,    ClkWrRcb_nn1H, WrEn_nnnH, PwrDnOvrd_nnnH)
            `HQM_DEVTLB_MSFF(WrData_nn1H, WrDataX_nnnH, ClkWr_nn1H)    // Preflop write data for all ways since it is always the same
         end
         
         // Apply bit mask to allow synthesis to remove unneeded bits 
         always_comb begin
            WrDataInt_nn1H   =  WrData_nn1H;

            for (int databit = 0;databit < MASK_BITS; databit++) begin : DataBit1
               WrDataInt_nn1H[databit] = '0;
            end
         end


         // Array Way Generation
         //
         for (g_way = 0;  g_way < NUM_WAYS; g_way++) begin : Way

            // Per-way write enable
            //
            assign WrEnX_nnnH[g_way] = WrEn_nnnH & WrWayVec_nnnH[g_way];

            hqm_devtlb_genram_wrap #(
               .mode                ((ARRAY_STYLE == ARRAY_MSFF) ? 1 : 0),
               .width               ($bits(T_ENTRY)),
               .depth               (NUM_SETS),
               .T                   (T_ENTRY),
               .cam_en              (0),
               .one_hot_rd_ptrs     (RD_PRE_DECODE),
               .num_rd_ports        (NUM_RD_PORTS),
               .noflopin_opt        (((NUM_WAYS > 1) || (ARRAY_STYLE == ARRAY_MSFF)) ? 1 : 0)
                                                           // No WrData Flop....external so that it can be shared across all ways
                                                           // Allow internal flop when only 1 way to stay with base genram structure
            ) array (
               .gramclk             (ClkWrRcb_nn1H),
               .reset_b             (~reset),
               .fscan_latchopen     (fscan_latchopen),
               .fscan_latchclosed_b (fscan_latchclosed_b),

               .wren                (WrEnX_nnnH[g_way]),
               .wraddr              (WrSetAddrX_nnnH),
               .wrdata              (WrDataInt_nn1H),

               .rdaddr              (RdSetAddr_nn1H),
               .rddataout           (RdDataX_nn1H[g_way]),

               .storage_data        (tmpArray_nnnH[g_way]), // Not used in this version
               
               .cam_data0           ('0),
               .cam_data1           ('0),
               .cam_hit0            (), //lintra s-0214
               .cam_hit1            ()  //lintra s-0214
            );

            // Reshape the array data to fit the dimensions of the GT array module interfaces
            //
            for (g_set = 0;  g_set < NUM_SETS; g_set++) begin : Set
               assign Array_nnnH[g_set][g_way] = tmpArray_nnnH[g_way][g_set];
            end

            // Take data from per-port oriented signal for port 0
            //
            for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Data
            always_comb begin
               IntRdData_nnnH[g_port][1][g_way] = RdDataX_nn1H[g_way][g_port];

               // Force implied bits to 0...synthesis doesn't consistently do a great job of
               // discarding unneeded bits here so we need to force it to do the correct thing
               //
               for (int databit = 0; databit < MASK_BITS; databit++) begin : DataBit2
                  IntRdData_nnnH[g_port][1][g_way][databit] = 1'b0;
               end
               end
            end
         end : Way
            
`ifndef HQM_DEVTLB_SIMONLY
      end : Array

      else begin : RF_MODE_OUPUTS_NOT_USED
         for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports
         assign RdSetAddr_nn1H[g_port]      = '0;
         assign RdSetAddr1Hot_nnnH[g_port]  = '0;
         assign ClkRd_nn1H[g_port]          = '0;
             for (g_way = 0;  g_way < NUM_WAYS; g_way++) begin : Int_way
                assign IntRdData_nnnH[g_port][1][g_way] = '0;
             end
         end
         assign {>>{tmpArray_nnnH}}       = {$bits(tmpArray_nnnH){1'b0}};
         assign ClkWrRcb_nn1H             = '0;
         assign ClkWr_nn1H                = '0;
         assign WrSetAddrX_nnnH           = '0;
         assign WrDataX_nnnH              = '0;
         assign WrData_nn1H               = '0;
         assign WrDataInt_nn1H            = '0;
         assign DfxRdData_nn1H            = '0;
        
      end
`endif

   end : LATCH

   if (ARRAY_STYLE == ARRAY_FPGA) begin : FPGA_MEM  // Use a generic array for this instantiation (FPGA)

      `ifndef HQM_DEVTLB_SVA_OFF
      `HQM_DEVTLB_ASSERTS_MUST(DEVTLB_Array_FPGA_Single_Port, (NUM_RD_PORTS == 1),
            posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("FPGA array styles do not support multiple read ports."));
      `endif

      for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Ctrl
         if (NUM_PIPE_STAGE>1)  begin : Latency2   // Will need this RBC later in the read stating logic
            `HQM_DEVTLB_MAKE_RCB_PH1(ClkRdRcb_H[g_port], clk,        RdEnSpec_nnnH[g_port] | (|StgRdEn_nnnH[g_port]), PwrDnOvrd_nnnH)
         end
      end

      for (g_way = 0;  g_way < NUM_WAYS; g_way++) begin : Way

         // Per-way write enable
         //
         assign WrEnX_nnnH[g_way] = WrEn_nnnH & WrWayVec_nnnH[g_way];

         hqm_devtlb_gram_sdp #(
            .BUS_SIZE_ADDR               (SET_ADDR_WIDTH),     // For the gram array, both read and write are the same size
            .BUS_SIZE_DATA               ($bits(WrData_nn1H)),
            .GRAM_MODE                   (2'd1)
         ) array (
`ifdef HQM_DEVTLB_SIMONLY
            .ram                 ({>>{tmpArray_nnnH[g_way]}}),
`endif
            .clk                 (clk),

            .raddr              ((NUM_SETS > 1) ? RdSetAddr_nnnH[0] : '0),
            .dout               (RdDataX_nn1H[g_way][0]),

            .we                 (WrEnX_nnnH[g_way]),
            .waddr              ((NUM_SETS > 1) ? WrSetAddr_nnnH : '0),
            .din                (WrData_nnnH)
         );

         // Take data from per-port oriented signal for port 0
         //
         for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Data
            always_comb begin
               IntRdData_nnnH[g_port][1][g_way] = RdDataX_nn1H[g_way][g_port];

               // Force implied bits to 0...synthesis doesn't consistently do a great job of
               // discarding unneeded bits here so we need to force it to do the correct thing
               //
               for (int databit = 0; databit < MASK_BITS; databit++) begin : DataBit2
                  IntRdData_nnnH[g_port][1][g_way][databit] = 1'b0;
               end
            end
         end

`ifdef HQM_DEVTLB_SIMONLY
         // Reshape the array data to fit the dimensions of the gram module interfaces
         //
         // Used by FPV for assumptions and assertions
         //
         for (g_set = 0;  g_set < NUM_SETS; g_set++) begin : Set
            assign Array_nnnH[g_set][g_way] = tmpArray_nnnH[g_way][g_set];
         end
`else
         for (g_set = 0;  g_set < NUM_SETS; g_set++) begin : Set
            assign tmpArray_nnnH[g_way][g_set]  = '0;
            assign Array_nnnH[g_set][g_way]     = '0;
         end
`endif
      end         

      // Dummy assignment to satisfy Lint
      //
      for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports
      assign RdSetAddr_nn1H[g_port]      = '0;
      assign RdSetAddr1Hot_nnnH[g_port]  = '0;
      assign ClkRd_nn1H[g_port]          = '0;
      end
      assign ClkWrRcb_nn1H             = '0;
      assign ClkWr_nn1H                = '0;
      assign WrSetAddrX_nnnH           = '0;
      assign WrDataX_nnnH              = '0;
      assign WrData_nn1H               = '0;
      assign WrDataInt_nn1H            = '0;
      assign DfxRdData_nn1H            = '0;

   end : FPGA_MEM

endgenerate

generate

   if (NUM_PIPE_STAGE>1)  begin : Latency2
`ifndef HQM_DEVTLB_SIMONLY
      if (ARRAY_STYLE != ARRAY_RF) begin : Rd_Stg
`endif
         logic       [NUM_PIPE_STAGE:2]      ClkStgRd_nnnH[NUM_RD_PORTS-1:0];

         logic                               ClkStagedRd_H[NUM_RD_PORTS-1:0];

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
      for (g_port = 0; g_port < NUM_RD_PORTS; g_port++) begin : Rd_Ports_Stage
         assign StgRdEn_nnnH[g_port] = '0;
      end
   end

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

// hkhor1: moving following chk to devtlb_tlb, where conflict due to xreq & fill are checked based on ALLOW_TLBRWCONFLICT.
    if (!ALLOW_TLBRWCONFLICT) begin : gen_tlbrwconflic_as
        if (NUM_SETS > 1) begin: NUM_SET_2
          `HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_ArrayGen_Rd_Wr_Conflict,
                   RdEn_nnnH[g_port] & WrEn_nnnH & (RdSetAddr_nnnH[g_port] == WrSetAddr_nnnH),
                clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB: Array Same Cycle Read/Write Conflict"));
       end  else begin: NUM_SET_1
          `HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_Rd_Wr_Conflict_Next_Cycle,
                   RdEn_nnnH[g_port] & WrEn_nnnH,
                clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB Array Following Cycle Read/Write Conflict"));
       end 
    end
   end
endgenerate

`endif

endmodule

`endif // DEVTLB_ARRAY_GEN_VS

