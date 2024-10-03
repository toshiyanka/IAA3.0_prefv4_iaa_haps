//----------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intels prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//----------------------------------------------------------------------------

`ifndef HQM_SYSTEM_DEF__
`define HQM_SYSTEM_DEF__

// If this is not defined, also need to set HQM_SFI to 0 in the tool.cth file

`define HQM_SFI

// Log2 Function
//-----------------------------------------------------------------------------------

`define HQM_L2(n)   ((n) <= (1<< 0) ?  1 : (n) <= (1<< 1) ?  1 :\
                     (n) <= (1<< 2) ?  2 : (n) <= (1<< 3) ?  3 :\
                     (n) <= (1<< 4) ?  4 : (n) <= (1<< 5) ?  5 :\
                     (n) <= (1<< 6) ?  6 : (n) <= (1<< 7) ?  7 :\
                     (n) <= (1<< 8) ?  8 : (n) <= (1<< 9) ?  9 :\
                     (n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :\
                     (n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :\
                     (n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 :\
                     (n) <= (1<<16) ? 16 : (n) <= (1<<17) ? 17 :\
                     (n) <= (1<<18) ? 18 : (n) <= (1<<19) ? 19 :\
                     (n) <= (1<<20) ? 20 : (n) <= (1<<21) ? 21 :\
                     (n) <= (1<<22) ? 22 : (n) <= (1<<23) ? 23 :\
                     (n) <= (1<<24) ? 24 : (n) <= (1<<25) ? 25 :\
                     (n) <= (1<<26) ? 26 : (n) <= (1<<27) ? 27 :\
                     (n) <= (1<<28) ? 28 : (n) <= (1<<29) ? 29 :\
                     (n) <= (1<<30) ? 30 : (n) <= (1<<31) ? 31 : 32) 


//Log2 function with log(1)=1. (Ceiling) FIX:define a case for log(1) used in [index-1:0]
//----------------------------------------------------------------------------------------

`define HQM_L2CEIL(n)   ((n) <= (1<< 0) ?  1 : (n) <= (1<< 1) ?  1 :\
                         (n) <= (1<< 2) ?  2 : (n) <= (1<< 3) ?  3 :\
                         (n) <= (1<< 4) ?  4 : (n) <= (1<< 5) ?  5 :\
                         (n) <= (1<< 6) ?  6 : (n) <= (1<< 7) ?  7 :\
                         (n) <= (1<< 8) ?  8 : (n) <= (1<< 9) ?  9 :\
                         (n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :\
                         (n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :\
                         (n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 :\
                         (n) <= (1<<16) ? 16 : (n) <= (1<<17) ? 17 :\
                         (n) <= (1<<18) ? 18 : (n) <= (1<<19) ? 19 :\
                         (n) <= (1<<20) ? 20 : (n) <= (1<<21) ? 21 :\
                         (n) <= (1<<22) ? 22 : (n) <= (1<<23) ? 23 :\
                         (n) <= (1<<24) ? 24 : (n) <= (1<<25) ? 25 :\
                         (n) <= (1<<26) ? 26 : (n) <= (1<<27) ? 27 :\
                         (n) <= (1<<28) ? 28 : (n) <= (1<<29) ? 29 :\
                         (n) <= (1<<30) ? 30 : (n) <= (1<<31) ? 31 : 32)

//Log2 +1 function 
//-----------------

`define HQM_L2P1(n) ( 1 + ((n) <= (1<< 0) ?  0 : (n) <= (1<< 1) ?  1 :\
                           (n) <= (1<< 2) ?  2 : (n) <= (1<< 3) ?  3 :\
                           (n) <= (1<< 4) ?  4 : (n) <= (1<< 5) ?  5 :\
                           (n) <= (1<< 6) ?  6 : (n) <= (1<< 7) ?  7 :\
                           (n) <= (1<< 8) ?  8 : (n) <= (1<< 9) ?  9 :\
                           (n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :\
                           (n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :\
                           (n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 :\
                           (n) <= (1<<16) ? 16 : (n) <= (1<<17) ? 17 :\
                           (n) <= (1<<18) ? 18 : (n) <= (1<<19) ? 19 :\
                           (n) <= (1<<20) ? 20 : (n) <= (1<<21) ? 21 :\
                           (n) <= (1<<22) ? 22 : (n) <= (1<<23) ? 23 :\
                           (n) <= (1<<24) ? 24 : (n) <= (1<<25) ? 25 :\
                           (n) <= (1<<26) ? 26 : (n) <= (1<<27) ? 27 :\
                           (n) <= (1<<28) ? 28 : (n) <= (1<<29) ? 29 :\
                           (n) <= (1<<30) ? 30 : (n) <= (1<<31) ? 31 : 32))


`define HQM_dw(n)   ((((n)+1)/32))

//CPP command and ID field widths

`define HQM_TI_ADDR                     63
`define HQM_TI_SRC_DEST_MSB             13
`define HQM_TI_TRN_LEN_MSB              9

//number of TI scoreboard ENTRIES-1
//this is also the maximum number of
//outstanding reads supported by the EP

`define HQM_TI_MAX_SB_ENTRY             8'd255

//Amount of credits supported by the Endpoint
//i.e. RI buffer size.

`define HQM_PHDR_CREDS                  15
`define HQM_NPHDR_CREDS                 15
`define HQM_PDATA_CREDS                 15
`define HQM_NPDATA_CREDS                15

//Counter sizes for above credits

`define HQM_LOG2_PHDR_CREDS             4
`define HQM_LOG2_NPHDR_CREDS            4
`define HQM_LOG2_PDATA_CREDS            4
`define HQM_LOG2_NPDATA_CREDS           4

// maximum number of credits supported on the link

`define HQM_PCIEHDR_CREDS               8'd128
`define HQM_PCIEDATA_CREDS              12'd2048

`define HQM_INF_CMPLHDR_CREDS           8'd255
`define HQM_INF_CMPLDATA_CREDS          12'd1024

// Defines for the link layer interface 

`define HQM_LLC_NUM_TLP_DW              8

// Defines the posted data queue pointer size(16 entries). The MSB is for wrap. 

`define HQM_LLC_PQ_PTR_SIZE             5 

// Defines the posted data queue pointer size(8 entries). The MSB is for wrap. 

`define HQM_LLC_NPQ_PTR_SIZE            4 

// The maximum number of bits for the header

`define HQM_DSL_MAX_HDR_SIZE            128 

// Header field defines

`define HQM_TDL_HDR_FMT                 6:5 
`define HQM_TDL_HDR_TYPE                4:0 
`define HQM_TDL_HDR_TC                  14:12
`define HQM_TDL_HDR_TD                  23 
`define HQM_TDL_HDR_EP                  22 
`define HQM_TDL_HDR_ATTR                21:20 
`define HQM_TDL_HDR_AT                  19:18 
`define HQM_TDL_HDR_LEN9_8              17:16 
`define HQM_TDL_HDR_LEN7_0              31:24 
`define HQM_TDL_HDR_BC7_0               63:56
`define HQM_TDL_HDR_BC10_8              51:48
`define HQM_TDL_CMPTAG                  87:80
`define HQM_TDL_HDR_TAG                 55:48
`define HQM_TDL_CMPCMPLID15_8           39:32
`define HQM_TDL_CMPCMPLID7_0            47:40
`define HQM_TDL_CMPREQID15_8            71:64
`define HQM_TDL_CMPREQID7_0             79:72
`define HQM_TDL_CPLSTAT                 55:53

`define HQM_CPLHDR_LEN_SZ               10
`define HQM_PHDR_LEN_SZ                 10

`define HQM_TDL_HDR_4ADDR7_0            127:120
`define HQM_TDL_HDR_4ADDR15_8           119:112 
`define HQM_TDL_HDR_4ADDR23_16          111:104 
`define HQM_TDL_HDR_4ADDR31_24          103:96 
`define HQM_TDL_HDR_3ADDR7_0            95:88

//PWR managment

`define HQM_PME_TURN_OFF_ACK            8'b00011001 

`define HQM_TDL_PHDR_WR                 3'h0
`define HQM_TDL_PHDR_MSG_ND             3'h1
`define HQM_TDL_PHDR_MSG_D              3'h2
`define HQM_TDL_PHDR_USR_D              3'h3
`define HQM_TDL_PHDR_USR_ND             3'h4
`define HQM_TDL_PHDR_UNDEF              3'h5
`define HQM_TDL_PHDR_ING_MSG            3'h6
`define HQM_TDL_PHDR_ING_MSG_D          3'h7

`define HQM_TDL_NPHDR_MEM_RD            3'h0 
`define HQM_TDL_NPHDR_CFG_RD            3'h1
`define HQM_TDL_NPHDR_CFG_WR            3'h2
`define HQM_TDL_NPHDR_IO_RD             3'h3
`define HQM_TDL_NPHDR_IO_WR             3'h4
`define HQM_TDL_NPHDR_USR_D             3'h5
`define HQM_TDL_NPHDR_USR_ND            3'h6
`define HQM_TDL_NPHDR_MEM_WR            3'h7

`define HQM_CSR_WR_ADDR_WID             18
`define HQM_CSR_OFFSET_WID              12
`define HQM_CSR_SIZE                    32
`define HQM_CSR_BAR_SIZE                64
`define HQM_CSR_FUNC_SZ                 7
`define HQM_CSR_ADDR_REG                11:0
`define HQM_CSR_PV_FUNC                 22:16
`define HQM_CSR_ADDR_FUNC               18:16
`define HQM_CSR_ADDR_BUS                31:24
`define HQM_CSR_ADDR_DEV                23:19
`define HQM_CSR_ADDR_DEV_FUNC           23:16
`define HQM_CSR_ADDR_DEV_FUNC_SEL       20:16
`define HQM_CSR_IOADDR_SZ               31

`define HQM_TLQ_PEND_CPL_SIZE           40 
`define HQM_TLQ_IOQ_PH                  0
`define HQM_TLQ_IOQ_NPH                 1

`define HQM_CBD_MAX_ADDR_WID            64

`define HQM_CDS_CMD_SIGNUM_SZ           16
`define HQM_CDS_CMD_SIGNUM_WID          4

`define HQM_OBC_HDR_RF_SZ               4
`define HQM_OBC_HDR_RF_ADSZ             2

`define HQM_MSI_ADDR_WID                64
`define HQM_MSI_DATA_SZ                 16
`define HQM_VF_MSI_VEC_SZ               32

// Count for the number of clocks the reset is held low

`define HQM_FUNC_RST_CNTR_SZ            8

// Power management CSR write delay

`define HQM_CSR_PPMCSR_DLY              2

// ---------------------------------------------------------------------------
// IOSF Sideband related defines
// ---------------------------------------------------------------------------

// create defines for SB bar regions

`define HQM_IOSF_SB_BAR_WID             3
`define HQM_IOSF_SB_BAR_FUNC            `HQM_IOSF_SB_BAR_WID'h0
`define HQM_IOSF_SB_BAR_CSR             `HQM_IOSF_SB_BAR_WID'h2
    
// ---------------------------------------------------------------------------

`define HQM_NUM_UERR_SRC                11 
`define HQM_NUM_CERR_SRC                7 
`define HQM_NUM_ERR_SRC                 18
`define HQM_NUM_ERR_SRC_LOG2            5

//==============================
// Flowclass
//==============================

`define HQM_FC_P                        2'b00
`define HQM_FC_NP                       2'b01
`define HQM_FC_C                        2'b10
`define HQM_FC_RSV                      2'b11

//==============================
// fmt 
//==============================

`define HQM_DW3_H                       2'b00
`define HQM_DW4_H                       2'b01
`define HQM_DW3_HDATA                   2'b10
`define HQM_DW4_HDATA                   2'b11

//==============================
// {fmt.type} 
//==============================

`define HQM_MRD32                       7'b00_00000
`define HQM_MRD64                       7'b01_00000
`define HQM_LTMRD32                     7'b00_00111
`define HQM_LTMRD64                     7'b01_00111
`define HQM_MRDLK32                     7'b00_00001
`define HQM_MRDLK64                     7'b01_00001
`define HQM_MWR32                       7'b10_00000
`define HQM_MWR64                       7'b11_00000
`define HQM_LTMWR32                     7'b10_00111
`define HQM_LTMWR64                     7'b11_00111
`define HQM_NPMWR32                     7'b10_11011
`define HQM_NPMWR64                     7'b11_11011

`define HQM_IORD                        7'b00_00010
`define HQM_IOWR                        7'b10_00010
`define HQM_CFGRD0                      7'b00_00100
`define HQM_CFGWR0                      7'b10_00100
`define HQM_CFGRD1                      7'b00_00101
`define HQM_CFGWR1                      7'b10_00101
`define HQM_ANYMSG                      4'b0110       
`define HQM_MSG_RC                      7'b01_10_000
`define HQM_MSG_AD                      7'b01_10_001
`define HQM_MSG_ID                      7'b01_10_010
`define HQM_MSG_BC                      7'b01_10_011
`define HQM_MSG_TERM                    7'b01_10_100
`define HQM_MSG_5                       7'b01_10_101
`define HQM_MSG_6                       7'b01_10_110
`define HQM_MSG_7                       7'b01_10_111
`define HQM_ANYMSGD                     4'b1110
`define HQM_MSGD_RC                     7'b11_10_000
`define HQM_MSGD_AD                     7'b11_10_001
`define HQM_MSGD_ID                     7'b11_10_010
`define HQM_MSGD_BC                     7'b11_10_011
`define HQM_MSGD_TERM                   7'b11_10_100
`define HQM_MSGD_5                      7'b11_10_101
`define HQM_MSGD_6                      7'b11_10_110
`define HQM_MSGD_7                      7'b11_10_111
`define HQM_CPL                         7'b00_01010
`define HQM_CPLD                        7'b10_01010
`define HQM_CPLLK                       7'b00_01011
`define HQM_CPLDLK                      7'b10_01011
`define HQM_FETCHADD32                  7'b10_01100
`define HQM_FETCHADD64                  7'b11_01100
`define HQM_SWAP32                      7'b10_01101
`define HQM_SWAP64                      7'b11_01101
`define HQM_CAS32                       7'b10_01110
`define HQM_CAS64                       7'b11_01110
  
//==============================
// Completion Status
//==============================

`define HQM_CPL_SC                      3'b000
`define HQM_CPL_UR                      3'b001
`define HQM_CPL_CRS                     3'b010
`define HQM_CPL_RSV3                    3'b011
`define HQM_CPL_CA                      3'b100
`define HQM_CPL_RSV5                    3'b101
`define HQM_CPL_RSV6                    3'b110
`define HQM_CPL_RSV7                    3'b111

//=============================
// VC and PORTS bits
//============================

//======================================
// Address bits ranges from IOSF CMD bus
//======================================

`define HQM_FUNC_NUM_HI                 18
`define HQM_FUNC_NUM_LO                 16
`define HQM_DEV_NUM_HI                  23
`define HQM_DEV_NUM_LO                  19
`define HQM_BUS_NUM_HI                  31
`define HQM_BUS_NUM_LO                  24

//======================================
       
//=====================================
// Address decode type
//=====================================

`define HQM_MEM_TYPE                    4'b0000
`define HQM_IO_TYPE                     4'b0001
`define HQM_CMP_TYPE                    4'b0010
`define HQM_CFG0_TYPE                   4'b0011
`define HQM_CFG1_TYPE                   4'b0100
`define HQM_MSGBYAD_TYPE                4'b0101
`define HQM_MSGBYID_TYPE                4'b0110
`define HQM_LT_TYPE                     4'b0111
    
//=====================================
// Address decode ranges
//=====================================

`define HQM_IO64K                       64'h1_0000
`define HQM_ISA0_LO                     12'h100
`define HQM_ISA0_HI                     12'h3FF  
`define HQM_ISA1_LO                     12'h500
`define HQM_ISA1_HI                     12'h7FF  
`define HQM_ISA2_LO                     12'h900
`define HQM_ISA2_HI                     12'hBFF  
`define HQM_ISA3_LO                     12'hD00
`define HQM_ISA3_HI                     12'hFFF  

//=========================================
// Address decode additional info for ERROR
//========================================== 

`define HQM_W_DATA                      3'b000  
`define HQM_LOCK                        3'b001
`define HQM_READ                        3'b010
`define HQM_WRITE                       3'b011
`define HQM_ATOMIC                      3'b100

//==========================================
// ISM States
//==========================================

`define HQM_IDLE                        3'b000
`define HQM_CREDIT_REQ                  3'b100
`define HQM_CREDIT_INIT                 3'b101
`define HQM_CREDIT_DONE                 3'b110
`define HQM_IDLE_REQ                    3'b001
`define HQM_IDLE_NAK                    3'b001
`define HQM_ACTIVE_REQ                  3'b010
`define HQM_ACTIVE                      3'b011

//==========================================   

`define HQM_IDLE_TRN                    0
`define HQM_PH_TRN                      1
`define HQM_IPR_TRN                     2
`define HQM_PD_TRN                      3
`define HQM_CMPLH_TRN                   4

`endif  // `ifndef HQM_SYSTEM_DEF__

