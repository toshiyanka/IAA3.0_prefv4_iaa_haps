//=====================================================================================================================
//
// iommu_lru.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_DEVTLB_SLRU_VS
`define HQM_DEVTLB_SLRU_VS

//`include "devtlb_pkg.vh"

module hqm_devtlb_slru
#(
   parameter         logic NO_POWER_GATING= 1'b0,
   parameter         int XREQ_PORTNUM     = 1,
   parameter         int NUM_PIPE_STAGE   = 1,        // Minimum 1
   parameter         int NUM_SETS         = 16,       // Minimum 2....MUST correlate to the SET_ADDR_WIDTH
   parameter         int NUM_WAYS         = 4         // Minimum 1         
)(
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST
   PwrDnOvrd_nnnH,        // Powerdown override

   RdSetAddr_nnnH,
   RdEn_nnnH,
   RdEnSpec_nnnH,
   RdInvert_nn1H,
   RdWayVec_nn1H,
   RdWay2ndVec_nn1H,

   LRUReset_nnnH,
   WrEn_nnnH,
   WrSetAddr_nnnH,
   WrHitVec_nnnH,
   WrRepVec_nnnH,

   Disable_Ways
//lintra +68099
);

//import `DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the IOMMU

localparam  int SET_ADDR_WIDTH      = `HQM_DEVTLB_LOG2(NUM_SETS);      

//============================================================================
// I/O Declarations
//============================================================================

   `HQM_DEVTLB_COMMON_PORTDEC
   `HQM_DEVTLB_FSCAN_PORTDEC
   input    logic                               PwrDnOvrd_nnnH;        // Powerdown override

   //==================================================================================================================
   //
   // Primary interface to/from hosting unit
   //
   //==================================================================================================================

   // Read Interface
   //
   input    logic    [SET_ADDR_WIDTH-1:0]       RdSetAddr_nnnH;
   input    logic                               RdEn_nnnH;
   input    logic                               RdEnSpec_nnnH; // Used to fire clocks
   input    logic                               RdInvert_nn1H; // Invert bit0 for B2B Write selection
   output   logic    [NUM_WAYS-1:0]             RdWayVec_nn1H;
   output   logic    [NUM_WAYS-1:0]             RdWay2ndVec_nn1H; // 2nd LRU

   // Write Interface
   //
   input    logic                                                 LRUReset_nnnH; 
   input    logic    [XREQ_PORTNUM-1:0]                           WrEn_nnnH; // ONLY support 1 port for now. TODO Assert
   input    logic    [XREQ_PORTNUM-1:0][SET_ADDR_WIDTH-1:0]       WrSetAddr_nnnH;
   input    logic    [XREQ_PORTNUM-1:0][NUM_WAYS-1:0]             WrHitVec_nnnH;
   input    logic    [XREQ_PORTNUM-1:0][NUM_WAYS-1:0]             WrRepVec_nnnH;

   input    logic    [1:0]                      Disable_Ways;

localparam int WAYS_IDX_W = `HQM_DEVTLB_LOG2(NUM_WAYS);

//============================================================================
// Array Declaration
//============================================================================
typedef logic [`HQM_DEVTLB_LOG2(NUM_WAYS)-1:0]  t_wayid;
t_wayid [NUM_SETS-1:0][NUM_WAYS-1:0]        Array_nnnH;          // Array Storage Nodes

//============================================================================
// Internal Declarations
//============================================================================
   logic                                        RdInvert_nn1H_nc;
   // Local Read Controls
   //
   logic [SET_ADDR_WIDTH-1:0]                   RdSetAddr_nn1H;

   // Clock Nodes
   //
   logic [XREQ_PORTNUM-1:0][NUM_SETS-1:0]       fEn_ClkWrLRU_nn1H;   // LCB for write operations
   logic                   [NUM_SETS-1:0]       ClkWrLRU_nn1H;       // LCB for write operations
   logic                   [NUM_SETS-1:0]       fEn_ClkWrLRUInt_nn1H;// LCB for write operations
   logic                                        ClkWrRcb_nnnH;
   logic                                        ClkWrRcbEn_nnnH;     // enable for RCB 

   logic                                        ClkRd_nn1H;

   logic       [NUM_PIPE_STAGE-1:0]             StgRdEn_nnnH;
   t_wayid     [NUM_WAYS-1:0]                   IntRdData_nnnH [NUM_PIPE_STAGE:1];
   t_wayid     [NUM_WAYS-1:0]                   RdData_nn1H;

//   logic                                        ClkWrFree_H;
   logic                                                ClkWr_nn1H;
   logic       [XREQ_PORTNUM-1:0]                       WrEn_nn1H;

   logic       [XREQ_PORTNUM-1:0][NUM_WAYS-1:0]         WrVec_nnnH;
   t_wayid     [XREQ_PORTNUM-1:0][NUM_WAYS-1:0]         WrData_nnnH;
   logic       [XREQ_PORTNUM-1:0][NUM_WAYS-1:0]         WrMask_nnnH;
   t_wayid                       [NUM_WAYS-1:0]         WrIntData_nnnH;
   logic                         [NUM_WAYS-1:0]         WrIntMask_nnnH;

   genvar g_set;
   genvar g_bit;

//============================================================================
// Array Read
//============================================================================
   logic ClkRdRcb_H;
   `HQM_DEVTLB_MAKE_RCB_PH1(ClkRdRcb_H, clk,        RdEnSpec_nnnH | (|StgRdEn_nnnH), PwrDnOvrd_nnnH)

   `HQM_DEVTLB_MAKE_LCB_PWR(ClkRd_nn1H, ClkRdRcb_H, RdEnSpec_nnnH, PwrDnOvrd_nnnH)

   // Stage read set address and read array
   //
   `HQM_DEVTLB_MSFF    (RdSetAddr_nn1H, RdSetAddr_nnnH, ClkRd_nn1H)

always_comb RdInvert_nn1H_nc = RdInvert_nn1H;

localparam int HALF_WAYS = (NUM_WAYS==1)? 0: (NUM_WAYS/2);
localparam int LQUAD_WAYS = (NUM_WAYS<4)? HALF_WAYS: (NUM_WAYS/4);
localparam int UQUAD_WAYS = (NUM_WAYS==1)? 0: (NUM_WAYS-LQUAD_WAYS);
localparam int HALF_2NDWAYS = (NUM_WAYS==1)? 0: 
                              (NUM_WAYS==2)? 1: (NUM_WAYS/2)+1;
localparam int LQUAD_2NDWAYS = (NUM_WAYS <4)? HALF_2NDWAYS: (NUM_WAYS/4)+1;

logic [WAYS_IDX_W-1:0]      LRUIdx, LRU2ndIdx;

always_comb begin
    IntRdData_nnnH[1]   = (NUM_SETS > 1) ? Array_nnnH[RdSetAddr_nn1H] : Array_nnnH[0]; // lintra s-0241 SetAddr stop at 332
    LRUIdx              = (Disable_Ways == 2'b01)? RdData_nn1H[LQUAD_WAYS]:   //disable upper quarter
                          (Disable_Ways == 2'b10)? RdData_nn1H[HALF_WAYS]:  //disable upper half
                          RdData_nn1H[0];
    LRU2ndIdx           = (Disable_Ways == 2'b01)? RdData_nn1H[LQUAD_2NDWAYS]:   //disable upper quarter
                          (Disable_Ways == 2'b10)? RdData_nn1H[HALF_2NDWAYS]:  //disable upper half
                          RdData_nn1H[(NUM_WAYS==1)? 0: 1];

    RdWayVec_nn1H = '0;
    RdWay2ndVec_nn1H = '0;
    for (int i=0; i<NUM_WAYS; i++) begin
        if(i[WAYS_IDX_W-1:0]==LRUIdx)       RdWayVec_nn1H[i]  = 1'b1;
        if(i[WAYS_IDX_W-1:0]==LRU2ndIdx)    RdWay2ndVec_nn1H[i]  = 1'b1;
    end
end

generate
    genvar g_stage;
    if (NUM_PIPE_STAGE>1)  begin : Extra_Latency
        logic       [NUM_PIPE_STAGE:2]                           ClkStgRd_nnnH;
        logic ClkStagedRd_H;

        `HQM_DEVTLB_MAKE_LCB_PWR(ClkStagedRd_H, ClkRdRcb_H, 1'b1, PwrDnOvrd_nnnH)

        assign StgRdEn_nnnH[0] =   RdEn_nnnH;

        for(g_stage = 1; g_stage < NUM_PIPE_STAGE; g_stage++) begin: For_stage 
            `HQM_DEVTLB_MSFF(StgRdEn_nnnH[g_stage],  StgRdEn_nnnH[g_stage-1],   ClkStagedRd_H)
            `HQM_DEVTLB_MAKE_LCB_PWR(ClkStgRd_nnnH[g_stage+1], ClkRdRcb_H, StgRdEn_nnnH[g_stage], PwrDnOvrd_nnnH)
            `HQM_DEVTLB_MSFF(IntRdData_nnnH[g_stage+1], IntRdData_nnnH[g_stage], ClkStgRd_nnnH[g_stage+1])
        end
    end else begin : Latency1
        assign StgRdEn_nnnH = '0;
    end
endgenerate

always_comb begin
    RdData_nn1H =  IntRdData_nnnH[NUM_PIPE_STAGE];
end

//============================================================================
// Array Write
//============================================================================
//ONLY support one XREQ port for now.

assign ClkWrRcbEn_nnnH = (|WrEn_nnnH) || (|WrEn_nn1H) || (|LRUReset_nnnH);

`HQM_DEVTLB_MAKE_RCB_PH1(ClkWrRcb_nnnH,  clk,           ClkWrRcbEn_nnnH, PwrDnOvrd_nnnH)
`HQM_DEVTLB_MAKE_LCB_PWR(ClkWr_nn1H,     clk,           ClkWrRcbEn_nnnH, PwrDnOvrd_nnnH)

always_comb begin
   WrVec_nnnH = '0;
   for (int p = 0; p < XREQ_PORTNUM;p++) begin
        priority casez (1'b1) 
            (LRUReset_nnnH || &WrRepVec_nnnH[p])      : WrVec_nnnH[p] = '0;  // Reset/Inval
            (~|WrHitVec_nnnH[p])     : WrVec_nnnH[p] = WrRepVec_nnnH[p];    // Miss & Replace
            (|WrHitVec_nnnH[p])      : WrVec_nnnH[p] = WrHitVec_nnnH[p];    // Hit
            default                  : WrVec_nnnH[p] = '0;  //TODO Assert: AND wren[p]=1 flag error
        endcase
    end
end


generate
   for (genvar port_id = 0; port_id < XREQ_PORTNUM; port_id++) begin: TLB_NUM_PORTS      
      `HQM_DEVTLB_MSFF(WrEn_nn1H[port_id],       WrEn_nnnH[port_id],        ClkWr_nn1H)
   end
endgenerate


// Generate entry specific write clock
//
generate
   for (genvar g_id = 0; g_id < XREQ_PORTNUM;g_id++) begin: EnClkWr_TLB_PORTS      
      for (g_set = 0;  g_set < NUM_SETS; g_set++) begin  : EnClkWr_Set_Lp

         // Enable only when set address is a match or there is only 1 set
         //
         assign fEn_ClkWrLRU_nn1H[g_id][g_set] = LRUReset_nnnH || (WrEn_nnnH[g_id] & ((WrSetAddr_nnnH[g_id] == g_set) || (NUM_SETS == 1)));

      end
   end
endgenerate

// Roll the port id specific WrMask and WrData into one intermediate signal
//
always_comb begin
   fEn_ClkWrLRUInt_nn1H = '0;
   for (int g_id = 0; g_id < XREQ_PORTNUM; g_id++) begin: Roll_NUM_PORTS
      fEn_ClkWrLRUInt_nn1H |= fEn_ClkWrLRU_nn1H[g_id];
   end
end

// Generate entry specific write clock
//
generate
//   for (genvar g_id = 0; g_id < XREQ_PORTNUM;g_id++) begin: ClkWr_TLB_PORTS      
      for (g_set = 0;  g_set < NUM_SETS; g_set++) begin  : ClkWr_Set_Lp

         if (NO_POWER_GATING) begin : CLOCK_GATE_OVERRIDE
                                    // when no power gating is on modify state write to eliminate functional
                                    // clock gates...NO_POWER_GATING turns the PWR clock gate into a buffer
                                    // Flops driven by this clock need to be changed into enable flops
                                    // to support this change
               `HQM_DEVTLB_MAKE_LCB_PWR(ClkWrLRU_nn1H[g_set], ClkWrRcb_nnnH, 1'b1, 1'b1)
         end else begin : CLOCK_GATE_NORMAL
               `HQM_DEVTLB_MAKE_LCB_FUNC(ClkWrLRU_nn1H[g_set], clk, fEn_ClkWrLRUInt_nn1H[g_set])
         end
      end
//   end
endgenerate

t_wayid [NUM_WAYS-1:0]  IntArray;

generate
    for (genvar g_id = 0; g_id < XREQ_PORTNUM;g_id++) begin: Wr_TLB_PORTS      
        always_comb begin
            WrMask_nnnH[g_id] = (((Disable_Ways==2'b01) && (|WrVec_nnnH[g_id][NUM_WAYS-1:UQUAD_WAYS])) ||
                                ((Disable_Ways==2'b11) && (|WrVec_nnnH[g_id][NUM_WAYS-1:HALF_WAYS])))? '0: '1;
            
            IntArray = (NUM_SETS > 1)? Array_nnnH[WrSetAddr_nnnH]: Array_nnnH[0]; // lintra s-0241 SetAddr stop at 332

            WrData_nnnH[g_id][NUM_WAYS-1] = IntArray[NUM_WAYS-1];
            for (int i=0; i<NUM_WAYS; i++) begin
                if(WrVec_nnnH[g_id][IntArray[i]]) WrData_nnnH[g_id][NUM_WAYS-1] = IntArray[i];
            end
            if (~|WrVec_nnnH[g_id]) begin
                WrData_nnnH[g_id][NUM_WAYS-1] = ({$bits(t_wayid){(Disable_Ways==2'b01)}} & t_wayid'(NUM_WAYS-1-HALF_WAYS)) |
                                                ({$bits(t_wayid){(Disable_Ways==2'b11)}} & t_wayid'(NUM_WAYS-1-UQUAD_WAYS)) |
                                                ({$bits(t_wayid){(Disable_Ways==2'b10)}} & t_wayid'(NUM_WAYS-1)) |
                                                ({$bits(t_wayid){(Disable_Ways==2'b00)}} & t_wayid'(NUM_WAYS-1));
            end
            
            for (int i=NUM_WAYS-2; i>=0; i--) begin
                WrData_nnnH[g_id][i] = IntArray[i+1];
                for (int j=NUM_WAYS-1; j>i; j-- ) begin
                    if (WrVec_nnnH[g_id][IntArray[j]]) WrData_nnnH[g_id][i] = IntArray[i];
                end
                if (~|WrVec_nnnH[g_id]) begin
                    WrData_nnnH[g_id][i] = ({$bits(t_wayid){(Disable_Ways==2'b01)}} & t_wayid'(i-HALF_WAYS)) |
                                                    ({$bits(t_wayid){(Disable_Ways==2'b11)}} & t_wayid'(i-UQUAD_WAYS)) |
                                                    ({$bits(t_wayid){(Disable_Ways==2'b10)}} & t_wayid'(i)) |
                                                    ({$bits(t_wayid){(Disable_Ways==2'b00)}} & t_wayid'(i));
                end
            end
        end
    end
endgenerate
always_comb begin
    WrIntData_nnnH = WrData_nnnH[0];
    WrIntMask_nnnH = WrMask_nnnH[0];
    
    /* Not supporting multi port now.
    for (int p = 0; p < XREQ_PORTNUM; p++) begin:
        WrIntData_nnnH |= 
    end*/
end

// Generate entry specfic clocks based on write set address and write bit vector if a write is indicated
//
generate
   for (g_set = 0;  g_set < NUM_SETS; g_set++) begin  : Array_Set_Lp
      for (g_bit = 0;  g_bit < NUM_WAYS; g_bit++) begin  : Array_Bit_Lp
         // Write selected array entry(ies) with entry specific clock
         //
         if (NO_POWER_GATING) begin : EN_MSFF_W_FREE_CLOCK
                                  // when no power gating is on, modify state write to eliminate several
                                  // functional clock gates...use enables instead
            `HQM_DEVTLB_EN_MSFF(Array_nnnH[g_set][g_bit], WrIntData_nnnH[g_bit], ClkWrLRU_nn1H[g_set], fEn_ClkWrLRUInt_nn1H[g_set] & WrIntMask_nnnH[g_bit])
         end else begin : MSFF_W_CLOCK_GATE
            `HQM_DEVTLB_EN_MSFF(Array_nnnH[g_set][g_bit], WrIntData_nnnH[g_bit], ClkWrLRU_nn1H[g_set], WrIntMask_nnnH[g_bit]) //port 0 only
         end
      end
   end
endgenerate

//============================================================================
// GLOBALS ASSERTIONS
//============================================================================

`ifndef HQM_DEVTLB_SVA_OFF
generate
   
   `HQM_DEVTLB_ASSERTS_MUST(IOMMU_XREQ_PORTNUM_out_of_LRU_Range,
               (XREQ_PORTNUM == 1)
            , posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Number of Xreq Port not supported by Strict LRU: %s", XREQ_PORTNUM));

   `HQM_DEVTLB_ASSERTS_MUST(IOMMU_Array_Ways_out_of_LRU_Range,
               (NUM_WAYS == 2)
             | (NUM_WAYS == 4)
             | (NUM_WAYS == 8)
             | (NUM_WAYS == 16)
             | (NUM_WAYS == 32)
             | (NUM_WAYS == 64)
             | (NUM_WAYS == 128)
            , posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Number of ways not supported by LRU: %s", NUM_WAYS));
      
      `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_Array_RdEn_Implies_SpecRdEn, RdEn_nnnH, RdEnSpec_nnnH,
         posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Set address to access is out of bounds of array."));
         
      `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_SLRU_RdWay_OneHot, RdEn_nnnH, NUM_PIPE_STAGE, 
         $onehot(RdWayVec_nn1H) && $onehot(RdWay2ndVec_nn1H),
         posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Bad RdWayVec_nn1H or Rd2ndWayVec_nn1H."));

        logic AsNoDuplicateWayID;
        always_comb begin
            AsNoDuplicateWayID = '1;
            for (int i=0; i<NUM_WAYS; i++) begin
                for (int j=0; j<NUM_WAYS; j++) begin
                    if(i!=j) AsNoDuplicateWayID &= Array_nnnH[RdSetAddr_nn1H][i] != Array_nnnH[RdSetAddr_nn1H][j];
                end
            end
        end
      `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(DEVTLB_SLRU_Array_NoDuplicateWay, RdEn_nnnH, NUM_PIPE_STAGE,
         AsNoDuplicateWayID, 
         posedge clk, reset_INST, 
        `HQM_DEVTLB_ERR_MSG("Dupicated way in array_nnnH."));

      `HQM_DEVTLB_IFC_ISKNOWN(WrIntData_nnnH, |WrEn_nnnH)
      `HQM_DEVTLB_IFC_ISKNOWN(WrIntMask_nnnH, |WrEn_nnnH)

      `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_SLRU_WrHitVec_OneHot, WrEn_nnnH[0], 
         ($onehot(WrHitVec_nnnH[0]) || (WrHitVec_nnnH[0]=='1) || (WrHitVec_nnnH[0]=='0)),
         posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Bad WrHitVec."));

      `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_SLRU_WrRepVec_OneHot, WrEn_nnnH[0], 
         ($onehot(WrRepVec_nnnH[0]) || (WrRepVec_nnnH[0]=='1) || (WrRepVec_nnnH[0]=='0)),
         posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Bad WrRepVec."));

     //wr with hitvec, |=> the hit idx will be moved to Array[wrsetaddr][ways_num-1]
      logic [XREQ_PORTNUM-1:0][SET_ADDR_WIDTH-1:0] WrSetAddr_nn1H;
      logic [XREQ_PORTNUM-1:0][NUM_WAYS-1:0]       WrHitVec_nn1H;
      `HQM_DEVTLB_MSFF(WrSetAddr_nn1H, WrSetAddr_nnnH, clk)
      `HQM_DEVTLB_MSFF(WrHitVec_nn1H, WrHitVec_nnnH, clk)
      `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(DEVTLB_SLRU_HitVec_UpdateLRU, 
         WrEn_nnnH[0] && WrHitVec_nnnH[0] && (Disable_Ways=='0) && ~(LRUReset_nnnH || &WrRepVec_nnnH[0]), 1,
         WrHitVec_nn1H[0][Array_nnnH[WrSetAddr_nn1H][NUM_WAYS-1]], posedge clk, reset_INST, 
        `HQM_DEVTLB_ERR_MSG("Recent used ways is not moved to Array_nnnH[N-1]"));

     // Cover wr with hitvec, |-> the hit idx is not in Array[wrsetaddr][cover all location in the array]
    for (g_bit=0; g_bit<NUM_WAYS; g_bit++) begin: gen_cp_hitvec
      `HQM_DEVTLB_COVERS(DEVTLB_SLRU_HitVec_UpdateLRU, 
         WrEn_nnnH[0] && WrHitVec_nnnH[0] && (Disable_Ways=='0) && ~(LRUReset_nnnH || &WrRepVec_nnnH[0]) &&
         WrHitVec_nnnH[0][Array_nnnH[WrSetAddr_nnnH][g_bit]], 
         posedge clk, reset_INST, 
      `HQM_DEVTLB_COVER_MSG("Valid Miss Status"));
    end

      if (NUM_SETS > 1) begin: SET_ADDR_BOUNDS
         `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_LRU_RdSetAddr_in_bounds,
            RdEn_nnnH, `HQM_DEVTLB_ZX(RdSetAddr_nnnH,32) < NUM_SETS, posedge clk, reset_INST,
         `HQM_DEVTLB_ERR_MSG("Set address to access is out of bounds of array."));
      end
   
      `ifdef XPROP
         `HQM_DEVTLB_ASSERTS_NEVER(IOMMU_ISKNOWN_XPROP_LRUWrEn, $isunknown(WrEn_nnnH), posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value of signal is unknown."));
      `endif
   
endgenerate   
`endif

endmodule

`endif // IOMMU_LRU_VS

