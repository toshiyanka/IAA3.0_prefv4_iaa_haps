//=====================================================================================================================
// devtlb_tlb_array.sv
//
// Contacts            : Chintan Panirwala 
// Original Author(s)  : Chintan Panirwala
// Original Date       : 7/2017
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_DEVTLB_TLB_ARRAY_VS
`define HQM_DEVTLB_TLB_ARRAY_VS

`include "hqm_devtlb_pkg.vh"

// Sub-module includes
`include "hqm_devtlb_array_gen.sv"

module hqm_devtlb_tlb_array (
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST

   PwrDnOvrd_nnnH,

   DEVTLB_Tag_RdEn_Spec,   
   DEVTLB_Tag_RdEn,   
   DEVTLB_Tag_Rd_Addr,
   DEVTLB_Tag_Rd_Data,
   DEVTLB_Tag_WrEn,  
   DEVTLB_Tag_Wr_Addr,
   DEVTLB_Tag_Wr_Way,
   DEVTLB_Tag_Wr_Data,

   DEVTLB_Data_RdEn_Spec,   
   DEVTLB_Data_RdEn,   
   DEVTLB_Data_Rd_Addr,
   DEVTLB_Data_Rd_Data,
   DEVTLB_Data_WrEn,  
   DEVTLB_Data_Wr_Addr,
   DEVTLB_Data_Wr_Way,
   DEVTLB_Data_Wr_Data
//lintra +68099
);

import `HQM_DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the IOMMU
`include "hqm_devtlb_pkgparams.vh"

parameter logic ALLOW_TLBRWCONFLICT  = 0;  //1 if TLB array allow RW conflict
parameter   type T_TAG_ENTRY_4K     = logic [0:0]; //t_devtlb_iotlb_4k_tag_entry;
parameter   type T_DATA_ENTRY_4K    = logic [0:0]; //t_devtlb_iotlb_4k_data_entry;
parameter   int NUM_RD_PORTS        = 1;     // Minimum 1
parameter   int DEVTLB_PORT_ID      = 0;
parameter   int NUM_PIPE_STAGE      = 1;     // Minimum 1
parameter   int NUM_WAYS            = 4;
parameter   int NUM_PS_SETS  [5:0]  = '{ default:0 };   // Number of sets per TLBID per Size
parameter   int PS_MAX              = 2;    // Page size tlbs supported 0=4K, 1=2M, 2=1G, 3=0.5T
parameter   int PS_MIN              = 0;    // Page size tlbs supported 0=4K, 1=2M, 2=1G, 3=0.5T
//parameter   int NUM_SETS [NUM_ARRAYS:0][5:0]   = '{ default:0 };   // Number of sets per TLBID per Size
parameter   type    T_ENTRY         = logic [0:0];
parameter   type    D_ENTRY         = logic [0:0];
parameter   type    T_BITPERWAY     = logic [0:0]; //t_tlb_bitperway;
parameter   type    T_SETADDR       = logic [0:0]; //t_devtlb_tlb_setaddr;
localparam  int READ_LATENCY        = 1;    // Number of cycles needed to read IOTLB/RCC/PWC -- should not be zero.
//localparam  int SET_ADDR_WIDTH      = `DEVTLB_LOG2(NUM_PS_SETS[0]);
parameter   int NUM_ARRAYS          = DEVTLB_TLB_NUM_ARRAYS;    // Number of TLBID's that will be supported
parameter   int ARRAY_STYLE [5:0]   = '{default:ARRAY_LATCH};     // Array Style
                                                                  // 0 = LATCH Array      (gt_ram_sv)
                                                                  // 1 = FPGA gram Array  (gram_sdp)
                                                                  // 2 = RF Array         (customer provided)
                                                                  // 3 = MSFF Array       (gt_ram_sv)


//======================================================================================================================
//                                           Interface Signal Declaration
//======================================================================================================================

`HQM_DEVTLB_COMMON_PORTDEC
`HQM_DEVTLB_FSCAN_PORTDEC

input    logic                                                                PwrDnOvrd_nnnH;      // Powerdown override
input    logic                [NUM_RD_PORTS-1:0][PS_MAX:PS_MIN]               DEVTLB_Tag_RdEn_Spec;
input    logic                [NUM_RD_PORTS-1:0][PS_MAX:PS_MIN]               DEVTLB_Tag_RdEn;
input    T_SETADDR            [NUM_RD_PORTS-1:0][PS_MAX:PS_MIN]               DEVTLB_Tag_Rd_Addr;
output   T_ENTRY              [NUM_RD_PORTS-1:0][PS_MAX:PS_MIN][NUM_WAYS-1:0] DEVTLB_Tag_Rd_Data;

input    logic                                  [PS_MAX:PS_MIN]               DEVTLB_Tag_WrEn;
input    T_SETADDR                   [PS_MAX:PS_MIN]               DEVTLB_Tag_Wr_Addr;
input    T_BITPERWAY                        [PS_MAX:PS_MIN]               DEVTLB_Tag_Wr_Way;
input    T_ENTRY                                [PS_MAX:PS_MIN]               DEVTLB_Tag_Wr_Data;

input    logic                [NUM_RD_PORTS-1:0][PS_MAX:PS_MIN]               DEVTLB_Data_RdEn_Spec;
input    logic                [NUM_RD_PORTS-1:0][PS_MAX:PS_MIN]               DEVTLB_Data_RdEn;
input    T_SETADDR [NUM_RD_PORTS-1:0][PS_MAX:PS_MIN]               DEVTLB_Data_Rd_Addr;
output   D_ENTRY              [NUM_RD_PORTS-1:0][PS_MAX:PS_MIN][NUM_WAYS-1:0] DEVTLB_Data_Rd_Data;

input    logic                                  [PS_MAX:PS_MIN]               DEVTLB_Data_WrEn;
input    T_SETADDR                   [PS_MAX:PS_MIN]               DEVTLB_Data_Wr_Addr;
input    T_BITPERWAY                        [PS_MAX:PS_MIN]               DEVTLB_Data_Wr_Way;
input    D_ENTRY                                [PS_MAX:PS_MIN]               DEVTLB_Data_Wr_Data;

//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================

logic                [PS_MAX:PS_MIN][NUM_RD_PORTS-1:0]               tmpDEVTLB_Tag_RdEn_Spec;
logic                [PS_MAX:PS_MIN][NUM_RD_PORTS-1:0]               tmpDEVTLB_Tag_RdEn;
T_SETADDR [PS_MAX:PS_MIN][NUM_RD_PORTS-1:0]               tmpDEVTLB_Tag_Rd_Addr;
T_ENTRY              [PS_MAX:PS_MIN][NUM_RD_PORTS-1:0][NUM_WAYS-1:0] tmpDEVTLB_Tag_Rd_Data;
                                                       
logic                [PS_MAX:PS_MIN][NUM_RD_PORTS-1:0]               tmpDEVTLB_Data_RdEn_Spec;
logic                [PS_MAX:PS_MIN][NUM_RD_PORTS-1:0]               tmpDEVTLB_Data_RdEn;
T_SETADDR [PS_MAX:PS_MIN][NUM_RD_PORTS-1:0]               tmpDEVTLB_Data_Rd_Addr;
D_ENTRY              [PS_MAX:PS_MIN][NUM_RD_PORTS-1:0][NUM_WAYS-1:0] tmpDEVTLB_Data_Rd_Data;

genvar g_ps, g_portid;
generate
   for (g_portid = 0; g_portid < DEVTLB_XREQ_PORTNUM; g_portid++) begin  : Portid_GL
      for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin  : PS_GL
         always_comb begin
            tmpDEVTLB_Tag_RdEn_Spec[g_ps][g_portid]   =  DEVTLB_Tag_RdEn_Spec[g_portid][g_ps]; 
            tmpDEVTLB_Tag_RdEn[g_ps][g_portid]        =  DEVTLB_Tag_RdEn[g_portid][g_ps];
            tmpDEVTLB_Tag_Rd_Addr[g_ps][g_portid]     =  DEVTLB_Tag_Rd_Addr[g_portid][g_ps];
            
            tmpDEVTLB_Data_RdEn_Spec[g_ps][g_portid]  =  DEVTLB_Data_RdEn_Spec[g_portid][g_ps];
            tmpDEVTLB_Data_RdEn[g_ps][g_portid]       =  DEVTLB_Data_RdEn[g_portid][g_ps];
            tmpDEVTLB_Data_Rd_Addr[g_ps][g_portid]    =  DEVTLB_Data_Rd_Addr[g_portid][g_ps];
         end
      end
   end
   
   for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin  : PS_GL2
      for (g_portid = 0; g_portid < DEVTLB_XREQ_PORTNUM; g_portid++) begin  : Portid_GL2
         always_comb begin
            DEVTLB_Tag_Rd_Data[g_portid][g_ps]        =  tmpDEVTLB_Tag_Rd_Data[g_ps][g_portid];
            DEVTLB_Data_Rd_Data[g_portid][g_ps]       =  tmpDEVTLB_Data_Rd_Data[g_ps][g_portid];
         end
      end
   end
   
endgenerate

generate
   for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin  : Tag_PS_Lp

      if (NUM_PS_SETS[g_ps] > 0) begin: PS_Present
         localparam         int SET_ADDR_WIDTH      = `HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps]);
         logic [NUM_RD_PORTS-1:0][SET_ADDR_WIDTH-1:0] tmpRdSetAddr_nnnH;
         logic [SET_ADDR_WIDTH-1:0] tmpWrSetAddr_nnnH;

         always_comb begin
            for (int g_portid = 0; g_portid < DEVTLB_XREQ_PORTNUM; g_portid++) begin  : Tag_RdAddr_PS_LP
                tmpRdSetAddr_nnnH[g_portid] = tmpDEVTLB_Tag_Rd_Addr[g_ps][g_portid][`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])-1:0];
            end
         end

         assign tmpWrSetAddr_nnnH = DEVTLB_Tag_Wr_Addr[g_ps][SET_ADDR_WIDTH-1:0];

         hqm_devtlb_array_gen #(
            .NO_POWER_GATING(NO_POWER_GATING),
            .ALLOW_TLBRWCONFLICT(ALLOW_TLBRWCONFLICT),
            .NUM_RD_PORTS(NUM_RD_PORTS),
            .ARRAY_STYLE(ARRAY_STYLE[g_ps]),
            .NUM_PIPE_STAGE(NUM_PIPE_STAGE),
            .NUM_SETS(NUM_PS_SETS[g_ps]),
            .NUM_WAYS(NUM_WAYS),
            .MASK_BITS(g_ps*9),
            .RD_PRE_DECODE(1),
            .T_ENTRY(T_TAG_ENTRY_4K)
         ) devtlb_tlb_tag (
            `HQM_DEVTLB_COMMON_PORTCON
            `HQM_DEVTLB_FSCAN_PORTCON
            .PwrDnOvrd_nnnH         (PwrDnOvrd_nnnH),

            // Read Interface
            //
            .RdEnSpec_nnnH          (tmpDEVTLB_Tag_RdEn_Spec[g_ps]),
            .RdEn_nnnH              (tmpDEVTLB_Tag_RdEn[g_ps]),
            .RdSetAddr_nnnH         (tmpRdSetAddr_nnnH),
            .RdData_nn1H            (tmpDEVTLB_Tag_Rd_Data[g_ps]),

            // Write Interface
            //
            .WrEn_nnnH              (DEVTLB_Tag_WrEn[g_ps]),
            .WrSetAddr_nnnH         (tmpWrSetAddr_nnnH),
            .WrWayVec_nnnH          (DEVTLB_Tag_Wr_Way[g_ps]),
            .WrData_nnnH            (DEVTLB_Tag_Wr_Data[g_ps])
         );

      end
      else begin: PS_Not_Present
         assign tmpDEVTLB_Tag_Rd_Data[g_ps]   = '0;   
      end
   end
   for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin  : Data_PS_Lp

      if (NUM_PS_SETS[g_ps] > 0) begin: PS_Present
         localparam         int SET_ADDR_WIDTH      = `HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps]);
         logic [NUM_RD_PORTS-1:0][SET_ADDR_WIDTH-1:0] tmpRdSetAddr_nnnH;
         logic [SET_ADDR_WIDTH-1:0] tmpWrSetAddr_nnnH;
         
         always_comb begin
             for (int g_portid = 0; g_portid < DEVTLB_XREQ_PORTNUM; g_portid++) begin  : Data_RdAddr_PS_LP 
                tmpRdSetAddr_nnnH[g_portid] = tmpDEVTLB_Data_Rd_Addr[g_ps][g_portid][`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])-1:0];
             end
         end
         assign tmpWrSetAddr_nnnH = DEVTLB_Data_Wr_Addr[g_ps][SET_ADDR_WIDTH-1:0];
         
         hqm_devtlb_array_gen #(
            .NO_POWER_GATING(NO_POWER_GATING),
            .ALLOW_TLBRWCONFLICT(ALLOW_TLBRWCONFLICT),
            .NUM_RD_PORTS(NUM_RD_PORTS),
            .ARRAY_STYLE(ARRAY_STYLE[g_ps]),
            .NUM_PIPE_STAGE(NUM_PIPE_STAGE),
            .NUM_SETS(NUM_PS_SETS[g_ps]),
            .NUM_WAYS(NUM_WAYS),
            .MASK_BITS(g_ps*9),
            .RD_PRE_DECODE(1),
            .T_ENTRY(T_DATA_ENTRY_4K)
         ) devtlb_tlb_data (
            `HQM_DEVTLB_COMMON_PORTCON
            `HQM_DEVTLB_FSCAN_PORTCON
            .PwrDnOvrd_nnnH         (PwrDnOvrd_nnnH),

            // Read Interface
            //
            .RdEnSpec_nnnH          (tmpDEVTLB_Data_RdEn_Spec[g_ps]),
            .RdEn_nnnH              (tmpDEVTLB_Data_RdEn[g_ps]),
            .RdSetAddr_nnnH         (tmpRdSetAddr_nnnH),
            .RdData_nn1H            (tmpDEVTLB_Data_Rd_Data[g_ps]),

            // Write Interface
            //
            .WrEn_nnnH              (DEVTLB_Data_WrEn[g_ps]),
            .WrSetAddr_nnnH         (tmpWrSetAddr_nnnH),
            .WrWayVec_nnnH          (DEVTLB_Data_Wr_Way[g_ps]),
            .WrData_nnnH            (DEVTLB_Data_Wr_Data[g_ps])
         );
      end
      else begin: PS_Not_Present
         assign tmpDEVTLB_Data_Rd_Data[g_ps]   = '0;   
      end
   end
endgenerate

//=====================================================================================================================
// ASSERTIONS
//=====================================================================================================================

`ifndef HQM_DEVTLB_SVA_OFF
generate
    for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin  : AS_PS_SetAddr
        for (g_portid = 0; g_portid < DEVTLB_XREQ_PORTNUM; g_portid++) begin  : AS_Port_SetAddr
           `HQM_DEVTLB_ASSERTS_TRIGGER(DevTLB_Tag_Rd_addr_proper,
           DEVTLB_Tag_RdEn,
           (DEVTLB_Tag_Rd_Addr[g_portid][g_ps][$bits(T_SETADDR)-1:`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])] == '0),
           clk, reset_INST,
           `HQM_DEVTLB_ERR_MSG("Wrong setAddr"));

           `HQM_DEVTLB_ASSERTS_TRIGGER(DevTLB_Data_Rd_addr_proper,
           DEVTLB_Data_RdEn,
           (DEVTLB_Data_Rd_Addr[g_portid][g_ps][$bits(T_SETADDR)-1:`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])] == '0),
           clk, reset_INST,
           `HQM_DEVTLB_ERR_MSG("Wrong setAddr"));
        end
        `HQM_DEVTLB_ASSERTS_TRIGGER( DevTLB_Tag_Wr_addr_proper,
           DEVTLB_Tag_WrEn,
           (DEVTLB_Tag_Wr_Addr[g_ps][$bits(T_SETADDR)-1:`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])] == '0),
           clk, reset_INST,
           `HQM_DEVTLB_ERR_MSG("Wrong setAddr"));
        
        `HQM_DEVTLB_ASSERTS_TRIGGER( DevTLB_Data_Wr_addr_proper,
           DEVTLB_Data_WrEn,
           (DEVTLB_Data_Wr_Addr[g_ps][$bits(T_SETADDR)-1:`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])] == '0),
           clk, reset_INST,
           `HQM_DEVTLB_ERR_MSG("Wrong setAddr"));
   end
endgenerate
`endif

//=====================================================================================================================
// COVERS
//=====================================================================================================================

`ifdef HQM_DEVTLB_COVER_EN // Do not use covers in VCS...flood the log files with too many messages


`endif // DEVTLB_COVER_EN


endmodule

`endif // DEVTLB_TLB_ARRAY_VS
