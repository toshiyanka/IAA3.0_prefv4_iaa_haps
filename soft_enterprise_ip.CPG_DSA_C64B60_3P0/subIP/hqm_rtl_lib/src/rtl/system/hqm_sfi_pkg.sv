//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2022 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------

package hqm_sfi_pkg;

localparam int unsigned HQM_SFI_RX_ADDR_WIDTH            = 64;
//cindralla localparam int unsigned HQM_SFI_RX_HDR_NUM_VCS           = 2;                                        // Need 0,2
localparam int unsigned HQM_SFI_RX_HDR_NUM_VCS           = 3;                                        // Need 0,1,2
localparam int unsigned HQM_SFI_RX_HDR_NUM_VCS_M1        = HQM_SFI_RX_HDR_NUM_VCS-1;
localparam int unsigned HQM_SFI_RX_HDR_VC_WIDTH          = (HQM_SFI_RX_HDR_NUM_VCS    == 1) ? 1 : $clog2(HQM_SFI_RX_HDR_NUM_VCS);
localparam int unsigned HQM_SFI_RX_HDR_NUM_FLOWS         = HQM_SFI_RX_HDR_NUM_VCS*3;
localparam int unsigned HQM_SFI_RX_HDR_FLOWS_WIDTH       = (HQM_SFI_RX_HDR_NUM_FLOWS  == 1) ? 1 : $clog2(HQM_SFI_RX_HDR_NUM_FLOWS);

//cindralla localparam int unsigned HQM_SFI_RX_DATA_NUM_VCS          = 2;                                        // Need 0,2
localparam int unsigned HQM_SFI_RX_DATA_NUM_VCS          = 3;                                        // Need 0,1,2
localparam int unsigned HQM_SFI_RX_DATA_VC_WIDTH         = (HQM_SFI_RX_DATA_NUM_VCS   == 1) ? 1 : $clog2(HQM_SFI_RX_DATA_NUM_VCS);
localparam int unsigned HQM_SFI_RX_DATA_NUM_FLOWS        = HQM_SFI_RX_DATA_NUM_VCS*3;
localparam int unsigned HQM_SFI_RX_DATA_FLOWS_WIDTH      = (HQM_SFI_RX_DATA_NUM_FLOWS == 1) ? 1 : $clog2(HQM_SFI_RX_DATA_NUM_FLOWS);

localparam int unsigned HQM_SFI_RX_DATA_WIDTH            = 512;     // Has to agree with HQM_SFI_RX_D setting
localparam int unsigned HQM_SFI_RX_DATA_POISON_WIDTH     = HQM_SFI_RX_DATA_WIDTH/32;                 // per 1 DW
localparam int unsigned HQM_SFI_RX_DATA_EDB_WIDTH        = HQM_SFI_RX_DATA_WIDTH/32;                 // per 1 DW
localparam int unsigned HQM_SFI_RX_DATA_PARITY_WIDTH     = HQM_SFI_RX_DATA_WIDTH/64;                 // per 2 DWs
localparam int unsigned HQM_SFI_RX_DATA_END_WIDTH        = HQM_SFI_RX_DATA_WIDTH/32;                 // per 1 DW

localparam int unsigned HQM_SFI_TX_ADDR_WIDTH            = 64;
//cindralla localparam int unsigned HQM_SFI_TX_HDR_NUM_VCS           = 2;                                        // Need 0,2
localparam int unsigned HQM_SFI_TX_HDR_NUM_VCS           = 3;                                        // Need 0,1,2
localparam int unsigned HQM_SFI_TX_HDR_NUM_VCS_M1        = HQM_SFI_TX_HDR_NUM_VCS-1;
localparam int unsigned HQM_SFI_TX_HDR_VC_WIDTH          = (HQM_SFI_TX_HDR_NUM_VCS    == 1) ? 1 : $clog2(HQM_SFI_TX_HDR_NUM_VCS);
localparam int unsigned HQM_SFI_TX_HDR_NUM_FLOWS         = HQM_SFI_TX_HDR_NUM_VCS*3;
localparam int unsigned HQM_SFI_TX_HDR_FLOWS_WIDTH       = (HQM_SFI_TX_HDR_NUM_FLOWS  == 1) ? 1 : $clog2(HQM_SFI_TX_HDR_NUM_FLOWS);

//cindralla localparam int unsigned HQM_SFI_TX_DATA_NUM_VCS          = 2;                                        // Need 0,2
localparam int unsigned HQM_SFI_TX_DATA_NUM_VCS          = 3;                                        // Need 0,1,2
localparam int unsigned HQM_SFI_TX_DATA_VC_WIDTH         = (HQM_SFI_TX_DATA_NUM_VCS   == 1) ? 1 : $clog2(HQM_SFI_TX_DATA_NUM_VCS);
localparam int unsigned HQM_SFI_TX_DATA_NUM_FLOWS        = HQM_SFI_TX_DATA_NUM_VCS*3;
localparam int unsigned HQM_SFI_TX_DATA_FLOWS_WIDTH      = (HQM_SFI_TX_DATA_NUM_FLOWS == 1) ? 1 : $clog2(HQM_SFI_TX_DATA_NUM_FLOWS);

localparam int unsigned HQM_SFI_TX_DATA_WIDTH            = 512;     // Has to agree with HQM_SFI_TX_D setting
localparam int unsigned HQM_SFI_TX_DATA_POISON_WIDTH     = HQM_SFI_TX_DATA_WIDTH/32;                 // per 1 DW
localparam int unsigned HQM_SFI_TX_DATA_EDB_WIDTH        = HQM_SFI_TX_DATA_WIDTH/32;                 // per 1 DW
localparam int unsigned HQM_SFI_TX_DATA_PARITY_WIDTH     = HQM_SFI_TX_DATA_WIDTH/64;                 // per 2 DWs
localparam int unsigned HQM_SFI_TX_DATA_END_WIDTH        = HQM_SFI_TX_DATA_WIDTH/32;                 // per 1 DW

localparam int unsigned HQM_SFI_SAI_WIDTH                = 8;
localparam int unsigned HQM_SFI_LEN_WIDTH                = 10;
localparam int unsigned HQM_SFI_PASID_WIDTH              = 20;
localparam int unsigned HQM_SFI_PASIDTLP_WIDTH           = HQM_SFI_PASID_WIDTH+3;

//-----------------------------------------------------------------------------------------------------
// Making these 1b wider than needed to allow indexing w/o lint issues.

// The posted header FIFO is 16 deep but has a double buffer on its output, so there are effectively
//  18 posted header FIFO locations.
// The non-posted header FIFO is  8 deep but has a double buffer on its output, so there are effectively
//  10 non-posted header FIFO locations.

localparam int unsigned HQM_SFI_RX_HDR_CREDITS[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0,  0,  0,  0}     // Ch3
    ,'{  0,  0,  0,  0}     // Ch2
    ,'{  0,  1,  0,  0}     // Ch1 (Ext Ch2) ATS responses   (Cpl/CplD)
    ,'{  0,  1, 10, 18}     // Ch0 (Ext Ch0) CFGRD0/WR0, MWr, MRd, Invalidate Reqs
};

localparam int unsigned HQM_SFI_RX_HDR_CREDITS_INF[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0,  0,  0,  0}     // Ch3
    ,'{  0,  0,  0,  0}     // Ch2
    ,'{  0,  1,  0,  0}     // Ch1 (Ext Ch2) ATS responses   (Cpl/CplD)
    ,'{  0,  1,  0,  0}     // Ch0 (Ext Ch0) CFGRD0/WR0, MWr, MRd, Invalidate Reqs
};

// The posted data   FIFO is 32 deep but has a double buffer on its output, so there are effectively
//  34 posted data   FIFO locations.
// The posted data   FIFO is 64B wide, so each location can hold 4 of the 16B data credits.
// The worst case scenario is if we've gotten 17 posted headers that each only consume 1 data credit
// (out of the 4 data credits each of the 17 posted data FIFO entries can hold).  So although we've
// consumed only 17 posted data credits, we've taken up 68 posted data credits worth of storage).
// With a 34 deep posted data FIFO, we have 17 locations left, each of which can hold 4 posted data
// credits worth (64B) of data. The single remaining posted header location can therefore accept a
// transaction that uses at most another 68 (17 remaining posted data FIFO locations * 4 data credits)
// posted data credits worth (1088B) of data.
// So the maximum number of posted data credits we can advertise is 85 (17 + 68) even though the
// posted data FIFO has a total capacity of 136 (34 posted data FIFO locations * 4 data credits)
// posted data credits.  We effectively need to underadvertise by the number of unrepresented (by
// the credits consumed) posted data FIFO storage that was consumed in the worst case scenario which
// is the 51 posted data credits representing the 3 posted data credits in each of the posted data
// FIFO entries that only contain 1 posted data credit's worth of data.
// The 85 advertised posted data credits represents the 136 max posted data credits the posted data
// FIFO storage represents minus the 51 posted data credits the worst case scenario does not account
// for in the unused but consumed posted data FIFO entries.

// The non-posted data   FIFO is 16 deep but has a double buffer on its output, so there are effectively
//  18 non-posted data   FIFO locations.
// The non-posted data   FIFO is only 4B wide because we only support NP transactions up to 32b, but for
// this analysis it can be assumed each location represents 4 of the 16B data credits.
// The worst case scenario is if we've gotten 9 non-posted headers that each only consume 1 data credit
// (out of the 4 data credits each of the 9 non-posted data FIFO entries represents).  So although we've
// consumed only 9 non-posted data credits, we've taken up 36 non-posted data credits worth of storage).
// With a 18 deep non-posted data FIFO, we have 9 locations left, each of which can hold the equivalent
// of 4 non-posted data credits worth (64B) of data. The single remaining non-posted header location
// can therefore accept a transaction that uses at most another 36 (9 remaining non-posted data FIFO
// locations * 4 data credits) non-posted data credits worth (576B) of data.
// So the maximum number of non-posted data credits we can advertise is 45 (9 + 36) even though the
// non-posted data FIFO has a total capacity of 72 (18 non-posted data FIFO locations * 4 data credits)
// non-posted data credits.  We effectively need to underadvertise by the number of unrepresented (by
// the credits consumed) non-posted data FIFO storage that was consumed in the worst case scenario which
// is the 27 non-posted data credits representing the 3 non-posted data credits in each of the non-posted
// data FIFO entries that only contain 1 non-posted data credit's worth of data.
// The 45 advertised non-posted data credits represents the 72 max non-posted data credits the non-posted
// data FIFO storage represents minus the 27 non-posted data credits the worst case scenario does not
// account for in the unused but consumed non-posted data FIFO entries.

localparam int unsigned HQM_SFI_RX_DATA_CREDITS[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0,  0,  0,  0}     // Ch3
    ,'{  0,  0,  0,  0}     // Ch2
    ,'{  0,  1,  0,  0}     // Ch1 (Ext Ch2) ATS responses   (Cpl/CplD)
    ,'{  0,  1, 45, 85}     // Ch0 (Ext Ch0) CFGRD0/WR0, MWr, MRd, Invalidate Reqs
};

localparam int unsigned HQM_SFI_RX_DATA_CREDITS_INF[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0,  0,  0,  0}     // Ch3
    ,'{  0,  0,  0,  0}     // Ch2
    ,'{  0,  1,  0,  0}     // Ch1 (Ext Ch2) ATS responses   (Cpl/CplD)
    ,'{  0,  1,  0,  0}     // Ch0 (Ext Ch0) CFGRD0/WR0, MWr, MRd, Invalidate Reqs
};

localparam int unsigned HQM_SFI_BRIDGE_RX_HDR_CREDITS[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0,  0,  0,  0}     // Ch3
    ,'{  0,  0,  8,  0}     // Ch2 (Ext Ch2) ATS requests (MRd)
    ,'{  0, 32,  8, 16}     // Ch1 (Ext Ch1)
    ,'{  0, 32,  8, 16}     // Ch0 (Ext Ch0) CQ & Int writes, Cpl/CplD, Invalidate Rsps
};

localparam int unsigned HQM_SFI_BRIDGE_RX_HDR_CREDITS_INF[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0,  0,  0,  0}     // Ch3
    ,'{  0,  0,  0,  0}     // Ch2
    ,'{  0,  0,  0,  0}     // Ch1 (Ext Ch2) ATS requests (MRd)
    ,'{  0,  0,  0,  0}     // Ch0 (Ext Ch0) CQ & Int writes, Cpl/CplD, Invalidate Rsps
};

localparam int unsigned HQM_SFI_BRIDGE_RX_DATA_CREDITS[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0,  0,  0,  0}     // Ch3
    ,'{  0,  0,  1,  0}     // Ch2 (Ext Ch2) ATS requests (MRd)
    ,'{  0, 32, 32, 64}     // Ch1 (Ext Ch1) 
    ,'{  0, 32, 32, 64}     // Ch0 (Ext Ch0)
};

localparam int unsigned HQM_SFI_BRIDGE_RX_DATA_CREDITS_INF[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0,  0,  0,  0}     // Ch3
    ,'{  0,  0,  1,  0}     // Ch2
    ,'{  0,  0,  0,  0}     // Ch1 (Ext Ch2) ATS requests (MRd)
    ,'{  0,  0,  0,  0}     // Ch0 (Ext Ch0) CQ & Int writes, Cpl/CplD, Invalidate Rsps
};

// TODO: the ch2 and Ch3 values for VC and FC needs to be verified with steve and laks, for QAT and monalisa for DSA
// Specifies whether or not we're using a channel for the min credit versus idle functionality

localparam int unsigned HQM_SFI_RX_VC_FC_USED[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0, 0, 0, 0}        //ch3
    ,'{  0,  0,  0,  0}     // Ch2 (Ext Ch2) ATS requests (MRd)
    , '{  0,  1,  0,  0}     // Ch1 (Ext Ch2) ATS responses
    ,'{  0,  1,  1,  1}     // Ch0 (Ext Ch0) Completions, reads/writes
};

localparam int unsigned HQM_SFI_TX_VC_FC_USED[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0, 0, 0, 0}        //ch3
    ,'{  0,  0,  0,  0}     // Ch2 (Ext Ch2) ATS requests (MRd)
    , '{  0,  0,  1,  0}     // Ch1 (Ext Ch2) ATS requests
    ,'{  0,  1,  1,  1}     // Ch0 (Ext Ch0) Completions, reads/writes
};

// The minimum data credits required for single transaction

localparam int unsigned HQM_SFI_RX_MIN_DCRDS[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0, 0, 0, 0}        //ch3
    ,'{  0,  0,  0,  0}     // Ch2 (Ext Ch2) ATS requests (MRd)
    , '{  0, 32,  0,  0}     // Ch1 (Ext Ch2) ATS responses only (must support 512B)
    ,'{  0, 32, 32, 32}     // Ch0 (Ext Ch0) Completions, reads/writes (must supprt 512B)
};

localparam int unsigned HQM_SFI_TX_MIN_DCRDS[3:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0, 0, 0, 0}        //ch3
    ,'{  0,  0,  0,  0}     // Ch2 (Ext Ch2) ATS requests (MRd)
    , '{  0,  0,  0,  0}     // Ch1 (Ext Ch2) ATS requests only (no data)
    ,'{  0,  1,  0,  4}     // Ch0 (Ext Ch0) Completions (1 DW max), NP reads (no data), P writes (16 DWs max)
};



/*
////////////////////////////////////////////////////////////////////////////

// Specifies whether or not we're using a channel for the min credit versus idle functionality

localparam int unsigned HQM_SFI_RX_VC_FC_USED[1:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0,  1,  0,  0}     // Ch1 (Ext Ch2) ATS responses
    ,'{  0,  1,  1,  1}     // Ch0 (Ext Ch0) Completions, reads/writes
};

localparam int unsigned HQM_SFI_TX_VC_FC_USED[1:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0,  0,  1,  0}     // Ch1 (Ext Ch2) ATS requests
    ,'{  0,  1,  1,  1}     // Ch0 (Ext Ch0) Completions, reads/writes
};

// The minimum data credits required for single transaction

localparam int unsigned HQM_SFI_RX_MIN_DCRDS[1:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0, 32,  0,  0}     // Ch1 (Ext Ch2) ATS responses only (must support 512B)
    ,'{  0, 32, 32, 32}     // Ch0 (Ext Ch0) Completions, reads/writes (must supprt 512B)
};

localparam int unsigned HQM_SFI_TX_MIN_DCRDS[1:0][3:0] = '{
     // NA,Cpl, NP,  P
     '{  0,  0,  0,  0}     // Ch1 (Ext Ch2) ATS requests only (no data)
    ,'{  0,  1,  0,  4}     // Ch0 (Ext Ch0) Completions (1 DW max), NP reads (no data), P writes (16 DWs max)
};
*/
//-----------------------------------------------------------------------------------------------------

typedef enum logic[7:0] {
     FLIT_CMD_NOP               = 8'h00
    ,FLIT_CMD_MRDLK32           = 8'h01
    ,FLIT_CMD_IORD              = 8'h02
    ,FLIT_CMD_MRD32             = 8'h03
    ,FLIT_CMD_CFGRD0            = 8'h04
    ,FLIT_CMD_CFGRD1            = 8'h05
    ,FLIT_CMD_RSVD06            = 8'h06
    ,FLIT_CMD_RSVD07            = 8'h07
    ,FLIT_CMD_RSVD08            = 8'h08
    ,FLIT_CMD_RSVD09            = 8'h09
    ,FLIT_CMD_CPL               = 8'h0a
    ,FLIT_CMD_CPLLK             = 8'h0b
    ,FLIT_CMD_UIOWRSETCPL       = 8'h0c
    ,FLIT_CMD_UIORDCPL          = 8'h0d
    ,FLIT_CMD_RSVD0E            = 8'h0e
    ,FLIT_CMD_RSVD0F            = 8'h0f
    ,FLIT_CMD_RSVD10            = 8'h10
    ,FLIT_CMD_RSVD11            = 8'h11
    ,FLIT_CMD_RSVD12            = 8'h12
    ,FLIT_CMD_RSVD13            = 8'h13
    ,FLIT_CMD_RSVD14            = 8'h14
    ,FLIT_CMD_RSVD15            = 8'h15
    ,FLIT_CMD_RSVD16            = 8'h16
    ,FLIT_CMD_RSVD17            = 8'h17
    ,FLIT_CMD_RSVD18            = 8'h18
    ,FLIT_CMD_RSVD19            = 8'h19
    ,FLIT_CMD_RSVD1A            = 8'h1a
    ,FLIT_CMD_RSVD1B            = 8'h1b
    ,FLIT_CMD_RSVD1C            = 8'h1c
    ,FLIT_CMD_RSVD1D            = 8'h1d
    ,FLIT_CMD_RSVD1E            = 8'h1e
    ,FLIT_CMD_RSVD1F            = 8'h1f
    ,FLIT_CMD_MRD64             = 8'h20
    ,FLIT_CMD_MRDLK64           = 8'h21
    ,FLIT_CMD_UIORD             = 8'h22
    ,FLIT_CMD_RSVD23            = 8'h23
    ,FLIT_CMD_RSVD24            = 8'h24
    ,FLIT_CMD_RSVD25            = 8'h25
    ,FLIT_CMD_RSVD26            = 8'h26
    ,FLIT_CMD_RSVD27            = 8'h27
    ,FLIT_CMD_RSVD28            = 8'h28
    ,FLIT_CMD_RSVD29            = 8'h29
    ,FLIT_CMD_RSVD2A            = 8'h2a
    ,FLIT_CMD_RSVD2B            = 8'h2b
    ,FLIT_CMD_RSVD2C            = 8'h2c
    ,FLIT_CMD_RSVD2D            = 8'h2d
    ,FLIT_CMD_RSVD2E            = 8'h2e
    ,FLIT_CMD_RSVD2F            = 8'h2f
    ,FLIT_CMD_MSG0              = 8'h30
    ,FLIT_CMD_MSG1              = 8'h31
    ,FLIT_CMD_MSG2              = 8'h32
    ,FLIT_CMD_MSG3              = 8'h33
    ,FLIT_CMD_MSG4              = 8'h34
    ,FLIT_CMD_MSG5              = 8'h35
    ,FLIT_CMD_RSVD36            = 8'h36
    ,FLIT_CMD_RSVD37            = 8'h37
    ,FLIT_CMD_RSVD38            = 8'h38
    ,FLIT_CMD_RSVD39            = 8'h39
    ,FLIT_CMD_RSVD3A            = 8'h3a
    ,FLIT_CMD_RSVD3B            = 8'h3b
    ,FLIT_CMD_RSVD3C            = 8'h3c
    ,FLIT_CMD_RSVD3D            = 8'h3d
    ,FLIT_CMD_RSVD3E            = 8'h3e
    ,FLIT_CMD_RSVD3F            = 8'h3f
    ,FLIT_CMD_MWR32             = 8'h40
    ,FLIT_CMD_RSVD41            = 8'h41
    ,FLIT_CMD_IOWR              = 8'h42
    ,FLIT_CMD_RSVD43            = 8'h43
    ,FLIT_CMD_CFGWR0            = 8'h44
    ,FLIT_CMD_CFGWR1            = 8'h45
    ,FLIT_CMD_RSVD46            = 8'h46
    ,FLIT_CMD_RSVD47            = 8'h47
    ,FLIT_CMD_UIORDCPLD         = 8'h48
    ,FLIT_CMD_RSVD49            = 8'h49
    ,FLIT_CMD_CPLD              = 8'h4a
    ,FLIT_CMD_CPLDLK            = 8'h4b
    ,FLIT_CMD_FETCHADD32        = 8'h4c
    ,FLIT_CMD_SWAP32            = 8'h4d
    ,FLIT_CMD_CAS32             = 8'h4e
    ,FLIT_CMD_RSVD4F            = 8'h4f
    ,FLIT_CMD_RSVD50            = 8'h50
    ,FLIT_CMD_RSVD51            = 8'h51
    ,FLIT_CMD_RSVD52            = 8'h52
    ,FLIT_CMD_RSVD53            = 8'h53
    ,FLIT_CMD_RSVD54            = 8'h54
    ,FLIT_CMD_RSVD55            = 8'h55
    ,FLIT_CMD_RSVD56            = 8'h56
    ,FLIT_CMD_RSVD57            = 8'h57
    ,FLIT_CMD_RSVD58            = 8'h58
    ,FLIT_CMD_RSVD59            = 8'h59
    ,FLIT_CMD_RSVD5A            = 8'h5a
    ,FLIT_CMD_DMWR32            = 8'h5b
    ,FLIT_CMD_RSVD5C            = 8'h5c
    ,FLIT_CMD_RSVD5D            = 8'h5d
    ,FLIT_CMD_RSVD5E            = 8'h5e
    ,FLIT_CMD_RSVD5F            = 8'h5f
    ,FLIT_CMD_MWR64             = 8'h60
    ,FLIT_CMD_UIOWR             = 8'h61
    ,FLIT_CMD_RSVD62            = 8'h62
    ,FLIT_CMD_RSVD63            = 8'h63
    ,FLIT_CMD_RSVD64            = 8'h64
    ,FLIT_CMD_RSVD65            = 8'h65
    ,FLIT_CMD_RSVD66            = 8'h66
    ,FLIT_CMD_RSVD67            = 8'h67
    ,FLIT_CMD_RSVD68            = 8'h68
    ,FLIT_CMD_RSVD69            = 8'h69
    ,FLIT_CMD_RSVD6A            = 8'h6a
    ,FLIT_CMD_RSVD6B            = 8'h6b
    ,FLIT_CMD_FETCHADD64        = 8'h6c
    ,FLIT_CMD_SWAP64            = 8'h6d
    ,FLIT_CMD_CAS64             = 8'h6e
    ,FLIT_CMD_RSVD6F            = 8'h6f
    ,FLIT_CMD_MSGD0             = 8'h70
    ,FLIT_CMD_MSGD1             = 8'h71
    ,FLIT_CMD_MSGD2             = 8'h72
    ,FLIT_CMD_MSGD3             = 8'h73
    ,FLIT_CMD_MSGD4             = 8'h74
    ,FLIT_CMD_MSGD5             = 8'h75
    ,FLIT_CMD_RSVD76            = 8'h76
    ,FLIT_CMD_RSVD77            = 8'h77
    ,FLIT_CMD_RSVD78            = 8'h78
    ,FLIT_CMD_RSVD79            = 8'h79
    ,FLIT_CMD_RSVD7A            = 8'h7a
    ,FLIT_CMD_DMWR64            = 8'h7b
    ,FLIT_CMD_RSVD7C            = 8'h7c
    ,FLIT_CMD_RSVD7D            = 8'h7d
    ,FLIT_CMD_RSVD7E            = 8'h7e
    ,FLIT_CMD_RSVD7F            = 8'h7f
    ,FLIT_CMD_RSVD80            = 8'h80
    ,FLIT_CMD_RSVD81            = 8'h81
    ,FLIT_CMD_RSVD82            = 8'h82
    ,FLIT_CMD_RSVD83            = 8'h83
    ,FLIT_CMD_RSVD84            = 8'h84
    ,FLIT_CMD_RSVD85            = 8'h85
    ,FLIT_CMD_RSVD86            = 8'h86
    ,FLIT_CMD_RSVD87            = 8'h87
    ,FLIT_CMD_RSVD88            = 8'h88
    ,FLIT_CMD_RSVD89            = 8'h89
    ,FLIT_CMD_RSVD8A            = 8'h8a
    ,FLIT_CMD_RSVD8B            = 8'h8b
    ,FLIT_CMD_RSVD8C            = 8'h8c
    ,FLIT_CMD_RSVD8D            = 8'h8d
    ,FLIT_CMD_RSVD8E            = 8'h8e
    ,FLIT_CMD_RSVD8F            = 8'h8f
    ,FLIT_CMD_RSVD90            = 8'h90
    ,FLIT_CMD_RSVD91            = 8'h91
    ,FLIT_CMD_RSVD92            = 8'h92
    ,FLIT_CMD_RSVD93            = 8'h93
    ,FLIT_CMD_RSVD94            = 8'h94
    ,FLIT_CMD_RSVD95            = 8'h95
    ,FLIT_CMD_RSVD96            = 8'h96
    ,FLIT_CMD_RSVD97            = 8'h97
    ,FLIT_CMD_RSVD98            = 8'h98
    ,FLIT_CMD_RSVD99            = 8'h99
    ,FLIT_CMD_RSVD9A            = 8'h9a
    ,FLIT_CMD_RSVD9B            = 8'h9b
    ,FLIT_CMD_RSVD9C            = 8'h9c
    ,FLIT_CMD_RSVD9D            = 8'h9d
    ,FLIT_CMD_RSVD9E            = 8'h9e
    ,FLIT_CMD_RSVD9F            = 8'h9f
    ,FLIT_CMD_RSVDA0            = 8'ha0
    ,FLIT_CMD_RSVDA1            = 8'ha1
    ,FLIT_CMD_RSVDA2            = 8'ha2
    ,FLIT_CMD_RSVDA3            = 8'ha3
    ,FLIT_CMD_RSVDA4            = 8'ha4
    ,FLIT_CMD_RSVDA5            = 8'ha5
    ,FLIT_CMD_RSVDA6            = 8'ha6
    ,FLIT_CMD_RSVDA7            = 8'ha7
    ,FLIT_CMD_RSVDA8            = 8'ha8
    ,FLIT_CMD_RSVDA9            = 8'ha9
    ,FLIT_CMD_RSVDAA            = 8'haa
    ,FLIT_CMD_RSVDAB            = 8'hab
    ,FLIT_CMD_RSVDAC            = 8'hac
    ,FLIT_CMD_RSVDAD            = 8'had
    ,FLIT_CMD_RSVDAE            = 8'hae
    ,FLIT_CMD_RSVDAF            = 8'haf
    ,FLIT_CMD_RSVDB0            = 8'hb0
    ,FLIT_CMD_RSVDB1            = 8'hb1
    ,FLIT_CMD_RSVDB2            = 8'hb2
    ,FLIT_CMD_RSVDB3            = 8'hb3
    ,FLIT_CMD_RSVDB4            = 8'hb4
    ,FLIT_CMD_RSVDB5            = 8'hb5
    ,FLIT_CMD_RSVDB6            = 8'hb6
    ,FLIT_CMD_RSVDB7            = 8'hb7
    ,FLIT_CMD_RSVDB8            = 8'hb8
    ,FLIT_CMD_RSVDB9            = 8'hb9
    ,FLIT_CMD_RSVDBA            = 8'hba
    ,FLIT_CMD_RSVDBB            = 8'hbb
    ,FLIT_CMD_RSVDBC            = 8'hbc
    ,FLIT_CMD_RSVDBD            = 8'hbd
    ,FLIT_CMD_RSVDBE            = 8'hbe
    ,FLIT_CMD_RSVDBF            = 8'hbf
    ,FLIT_CMD_RSVDC0            = 8'hc0
    ,FLIT_CMD_RSVDC1            = 8'hc1
    ,FLIT_CMD_RSVDC2            = 8'hc2
    ,FLIT_CMD_RSVDC3            = 8'hc3
    ,FLIT_CMD_RSVDC4            = 8'hc4
    ,FLIT_CMD_RSVDC5            = 8'hc5
    ,FLIT_CMD_RSVDC6            = 8'hc6
    ,FLIT_CMD_RSVDC7            = 8'hc7
    ,FLIT_CMD_RSVDC8            = 8'hc8
    ,FLIT_CMD_RSVDC9            = 8'hc9
    ,FLIT_CMD_RSVDCA            = 8'hca
    ,FLIT_CMD_RSVDCB            = 8'hcb
    ,FLIT_CMD_RSVDCC            = 8'hcc
    ,FLIT_CMD_RSVDCD            = 8'hcd
    ,FLIT_CMD_RSVDCE            = 8'hce
    ,FLIT_CMD_RSVDCF            = 8'hcf
    ,FLIT_CMD_RSVDD0            = 8'hd0
    ,FLIT_CMD_RSVDD1            = 8'hd1
    ,FLIT_CMD_RSVDD2            = 8'hd2
    ,FLIT_CMD_RSVDD3            = 8'hd3
    ,FLIT_CMD_RSVDD4            = 8'hd4
    ,FLIT_CMD_RSVDD5            = 8'hd5
    ,FLIT_CMD_RSVDD6            = 8'hd6
    ,FLIT_CMD_RSVDD7            = 8'hd7
    ,FLIT_CMD_RSVDD8            = 8'hd8
    ,FLIT_CMD_RSVDD9            = 8'hd9
    ,FLIT_CMD_RSVDDA            = 8'hda
    ,FLIT_CMD_RSVDDB            = 8'hdb
    ,FLIT_CMD_RSVDDC            = 8'hdc
    ,FLIT_CMD_RSVDDD            = 8'hdd
    ,FLIT_CMD_RSVDDE            = 8'hde
    ,FLIT_CMD_RSVDDF            = 8'hdf
    ,FLIT_CMD_RSVDE0            = 8'he0
    ,FLIT_CMD_RSVDE1            = 8'he1
    ,FLIT_CMD_RSVDE2            = 8'he2
    ,FLIT_CMD_RSVDE3            = 8'he3
    ,FLIT_CMD_RSVDE4            = 8'he4
    ,FLIT_CMD_RSVDE5            = 8'he5
    ,FLIT_CMD_RSVDE6            = 8'he6
    ,FLIT_CMD_RSVDE7            = 8'he7
    ,FLIT_CMD_RSVDE8            = 8'he8
    ,FLIT_CMD_RSVDE9            = 8'he9
    ,FLIT_CMD_RSVDEA            = 8'hea
    ,FLIT_CMD_RSVDEB            = 8'heb
    ,FLIT_CMD_RSVDEC            = 8'hec
    ,FLIT_CMD_RSVDED            = 8'hed
    ,FLIT_CMD_RSVDEE            = 8'hee
    ,FLIT_CMD_RSVDEF            = 8'hef
    ,FLIT_CMD_RSVDF0            = 8'hf0
    ,FLIT_CMD_RSVDF1            = 8'hf1
    ,FLIT_CMD_RSVDF2            = 8'hf2
    ,FLIT_CMD_RSVDF3            = 8'hf3
    ,FLIT_CMD_RSVDF4            = 8'hf4
    ,FLIT_CMD_RSVDF5            = 8'hf5
    ,FLIT_CMD_RSVDF6            = 8'hf6
    ,FLIT_CMD_RSVDF7            = 8'hf7
    ,FLIT_CMD_RSVDF8            = 8'hf8
    ,FLIT_CMD_RSVDF9            = 8'hf9
    ,FLIT_CMD_RSVDFA            = 8'hfa
    ,FLIT_CMD_RSVDFB            = 8'hfb
    ,FLIT_CMD_RSVDFC            = 8'hfc
    ,FLIT_CMD_RSVDFD            = 8'hfd
    ,FLIT_CMD_RSVDFE            = 8'hfe
    ,FLIT_CMD_RSVDFF            = 8'hff
} hqm_sfi_flit_cmd_t;

//-----------------------------------------------------------------------------------------------------

typedef enum logic[6:0] {
     PCIE_CMD_MRD32             = 7'h00
    ,PCIE_CMD_MRDLK32           = 7'h01
    ,PCIE_CMD_IORD              = 7'h02
    ,PCIE_CMD_RSVD03            = 7'h03
    ,PCIE_CMD_CFGRD0            = 7'h04
    ,PCIE_CMD_CFGRD1            = 7'h05
    ,PCIE_CMD_RSVD06            = 7'h06
    ,PCIE_CMD_LTMRD32           = 7'h07
    ,PCIE_CMD_RSVD08            = 7'h08
    ,PCIE_CMD_RSVD09            = 7'h09
    ,PCIE_CMD_CPL               = 7'h0a
    ,PCIE_CMD_CPLLK             = 7'h0b
    ,PCIE_CMD_RSVD0C            = 7'h0c
    ,PCIE_CMD_RSVD0D            = 7'h0d
    ,PCIE_CMD_RSVD0E            = 7'h0e
    ,PCIE_CMD_RSVD0F            = 7'h0f
    ,PCIE_CMD_RSVD10            = 7'h10
    ,PCIE_CMD_RSVD11            = 7'h11
    ,PCIE_CMD_RSVD12            = 7'h12
    ,PCIE_CMD_RSVD13            = 7'h13
    ,PCIE_CMD_RSVD14            = 7'h14
    ,PCIE_CMD_RSVD15            = 7'h15
    ,PCIE_CMD_RSVD16            = 7'h16
    ,PCIE_CMD_RSVD17            = 7'h17
    ,PCIE_CMD_RSVD18            = 7'h18
    ,PCIE_CMD_RSVD19            = 7'h19
    ,PCIE_CMD_RSVD1A            = 7'h1a
    ,PCIE_CMD_RSVD1B            = 7'h1b
    ,PCIE_CMD_RSVD1C            = 7'h1c
    ,PCIE_CMD_RSVD1D            = 7'h1d
    ,PCIE_CMD_RSVD1E            = 7'h1e
    ,PCIE_CMD_RSVD1F            = 7'h1f
    ,PCIE_CMD_MRD64             = 7'h20
    ,PCIE_CMD_MRDLK64           = 7'h21
    ,PCIE_CMD_RSVD22            = 7'h22
    ,PCIE_CMD_RSVD23            = 7'h23
    ,PCIE_CMD_RSVD24            = 7'h24
    ,PCIE_CMD_RSVD25            = 7'h25
    ,PCIE_CMD_RSVD26            = 7'h26
    ,PCIE_CMD_LTMRD64           = 7'h27
    ,PCIE_CMD_RSVD28            = 7'h28
    ,PCIE_CMD_RSVD29            = 7'h29
    ,PCIE_CMD_RSVD2A            = 7'h2a
    ,PCIE_CMD_RSVD2B            = 7'h2b
    ,PCIE_CMD_RSVD2C            = 7'h2c
    ,PCIE_CMD_RSVD2D            = 7'h2d
    ,PCIE_CMD_RSVD2E            = 7'h2e
    ,PCIE_CMD_RSVD2F            = 7'h2f
    ,PCIE_CMD_MSG0              = 7'h30
    ,PCIE_CMD_MSG1              = 7'h31
    ,PCIE_CMD_MSG2              = 7'h32
    ,PCIE_CMD_MSG3              = 7'h33
    ,PCIE_CMD_MSG4              = 7'h34
    ,PCIE_CMD_MSG5              = 7'h35
    ,PCIE_CMD_MSG6              = 7'h36
    ,PCIE_CMD_MSG7              = 7'h37
    ,PCIE_CMD_RSVD38            = 7'h38
    ,PCIE_CMD_RSVD39            = 7'h39
    ,PCIE_CMD_RSVD3A            = 7'h3a
    ,PCIE_CMD_RSVD3B            = 7'h3b
    ,PCIE_CMD_RSVD3C            = 7'h3c
    ,PCIE_CMD_RSVD3D            = 7'h3d
    ,PCIE_CMD_RSVD3E            = 7'h3e
    ,PCIE_CMD_RSVD3F            = 7'h3f
    ,PCIE_CMD_MWR32             = 7'h40
    ,PCIE_CMD_RSVD41            = 7'h41
    ,PCIE_CMD_IOWR              = 7'h42
    ,PCIE_CMD_LTMWR32           = 7'h43
    ,PCIE_CMD_CFGWR0            = 7'h44
    ,PCIE_CMD_CFGWR1            = 7'h45
    ,PCIE_CMD_RSVD46            = 7'h46
    ,PCIE_CMD_RSVD47            = 7'h47
    ,PCIE_CMD_RSVD48            = 7'h48
    ,PCIE_CMD_RSVD49            = 7'h49
    ,PCIE_CMD_CPLD              = 7'h4a
    ,PCIE_CMD_CPLDLK            = 7'h4b
    ,PCIE_CMD_FETCHADD32        = 7'h4c
    ,PCIE_CMD_SWAP32            = 7'h4d
    ,PCIE_CMD_CAS32             = 7'h4e
    ,PCIE_CMD_RSVD4F            = 7'h4f
    ,PCIE_CMD_RSVD50            = 7'h50
    ,PCIE_CMD_RSVD51            = 7'h51
    ,PCIE_CMD_RSVD52            = 7'h52
    ,PCIE_CMD_RSVD53            = 7'h53
    ,PCIE_CMD_RSVD54            = 7'h54
    ,PCIE_CMD_RSVD55            = 7'h55
    ,PCIE_CMD_RSVD56            = 7'h56
    ,PCIE_CMD_RSVD57            = 7'h57
    ,PCIE_CMD_RSVD58            = 7'h58
    ,PCIE_CMD_RSVD59            = 7'h59
    ,PCIE_CMD_RSVD5A            = 7'h5a
    ,PCIE_CMD_NPMWR32           = 7'h5b
    ,PCIE_CMD_RSVD5C            = 7'h5c
    ,PCIE_CMD_RSVD5D            = 7'h5d
    ,PCIE_CMD_RSVD5E            = 7'h5e
    ,PCIE_CMD_RSVD5F            = 7'h5f
    ,PCIE_CMD_MWR64             = 7'h60
    ,PCIE_CMD_RSVD61            = 7'h61
    ,PCIE_CMD_RSVD62            = 7'h62
    ,PCIE_CMD_LTMWR64           = 7'h63
    ,PCIE_CMD_RSVD64            = 7'h64
    ,PCIE_CMD_RSVD65            = 7'h65
    ,PCIE_CMD_RSVD66            = 7'h66
    ,PCIE_CMD_RSVD67            = 7'h67
    ,PCIE_CMD_RSVD68            = 7'h68
    ,PCIE_CMD_RSVD69            = 7'h69
    ,PCIE_CMD_RSVD6A            = 7'h6a
    ,PCIE_CMD_RSVD6B            = 7'h6b
    ,PCIE_CMD_FETCHADD64        = 7'h6c
    ,PCIE_CMD_SWAP64            = 7'h6d
    ,PCIE_CMD_CAS64             = 7'h6e
    ,PCIE_CMD_RSVD6F            = 7'h6f
    ,PCIE_CMD_MSGD0             = 7'h70
    ,PCIE_CMD_MSGD1             = 7'h71
    ,PCIE_CMD_MSGD2             = 7'h72
    ,PCIE_CMD_MSGD3             = 7'h73
    ,PCIE_CMD_MSGD4             = 7'h74
    ,PCIE_CMD_MSGD5             = 7'h75
    ,PCIE_CMD_MSGD6             = 7'h76
    ,PCIE_CMD_MSGD7             = 7'h77
    ,PCIE_CMD_RSVD78            = 7'h78
    ,PCIE_CMD_RSVD79            = 7'h79
    ,PCIE_CMD_RSVD7A            = 7'h7a
    ,PCIE_CMD_NPMWR64           = 7'h7b
    ,PCIE_CMD_RSVD7C            = 7'h7c
    ,PCIE_CMD_RSVD7D            = 7'h7d
    ,PCIE_CMD_RSVD7E            = 7'h7e
    ,PCIE_CMD_RSVD7F            = 7'h7f
} hqm_sfi_pcie_cmd_t;

//-----------------------------------------------------------------------------------------------------
// SFI flow classes

typedef enum logic[1:0] {
     sfi_fc_posted              = 2'b00
    ,sfi_fc_nonposted           = 2'b01
    ,sfi_fc_completion          = 2'b10
    ,sfi_fc_rsvd3               = 2'b11
} hqm_sfi_fc_id_t;

//-----------------------------------------------------------------------------------------------------
// SFI address translation

typedef enum logic[1:0] {
     sfi_at_untranslated        = 2'b00
    ,sfi_at_translation_req     = 2'b01
    ,sfi_at_translated          = 2'b10
    ,sfi_at_rsvd3               = 2'b11
} hqm_sfi_at_t;

//-----------------------------------------------------------------------------------------------------
// SFI completion status

typedef enum logic[2:0] {
     sfi_cpl_status_success     = 3'b000
    ,sfi_cpl_status_ur          = 3'b001
    ,sfi_cpl_status_rrs         = 3'b010
    ,sfi_cpl_status_rsvd3       = 3'b011
    ,sfi_cpl_status_abort       = 3'b100
    ,sfi_cpl_status_rsvd5       = 3'b101
    ,sfi_cpl_status_rsvd6       = 3'b110
    ,sfi_cpl_status_rsvd7       = 3'b111
} hqm_sfi_cpl_status_t;

//-----------------------------------------------------------------------------------------------------
// SFI orthoganal header content

typedef enum logic[4:0] {
     ohc_none                   = 5'b00000
    ,ohc_noe_a                  = 5'b00001
    ,ohc_noe_b                  = 5'b00010
    ,ohc_noe_ab                 = 5'b00011
    ,ohc_noe_c                  = 5'b00100
    ,ohc_noe_ac                 = 5'b00101
    ,ohc_noe_bc                 = 5'b00110
    ,ohc_noe_abc                = 5'b00111
    ,ohc_e1_none                = 5'b01000
    ,ohc_e1_a                   = 5'b01001
    ,ohc_e1_b                   = 5'b01010
    ,ohc_e1_ab                  = 5'b01011
    ,ohc_e1_c                   = 5'b01100
    ,ohc_e1_ac                  = 5'b01101
    ,ohc_e1_bc                  = 5'b01110
    ,ohc_e1_abc                 = 5'b01111
    ,ohc_e2_none                = 5'b10000
    ,ohc_e2_a                   = 5'b10001
    ,ohc_e2_b                   = 5'b10010
    ,ohc_e2_ab                  = 5'b10011
    ,ohc_e2_c                   = 5'b10100
    ,ohc_e2_ac                  = 5'b10101
    ,ohc_e2_bc                  = 5'b10110
    ,ohc_e2_abc                 = 5'b10111
    ,ohc_e4_none                = 5'b11000
    ,ohc_e4_a                   = 5'b11001
    ,ohc_e4_b                   = 5'b11010
    ,ohc_e4_ab                  = 5'b11011
    ,ohc_e4_c                   = 5'b11100
    ,ohc_e4_ac                  = 5'b11101
    ,ohc_e4_bc                  = 5'b11110
    ,ohc_e4_abc                 = 5'b11111
} hqm_sfi_ohc_t;

typedef enum logic[2:0] {
     sfi_ts_none                = 3'b000
    ,sfi_ts_ecrc                = 3'b001
    ,sfi_ts_rsvd2               = 3'b010
    ,sfi_ts_rsvd3               = 3'b011
    ,sfi_ts_rsvd4               = 3'b100
    ,sfi_ts_mac                 = 3'b101
    ,sfi_ts_mac_pcrc            = 3'b110
    ,sfi_ts_rsvd7               = 3'b111
} hqm_sfi_ts_t;

typedef struct packed {
    logic                                       nw;                         //  31     Read/Not Write access
    logic                                       pv;                         //  30     PASID Valid
    logic                                       pmr;                        //  29     Privileged Mode Required
    logic                                       er;                         //  28     Execute Required
    logic [19:0]                                pasid;                      //  27:  8 Process Address Space ID
    logic [3:0]                                 lbe;                        //   7:  4 Last  Byte Enables
    logic [3:0]                                 fbe;                        //   3:  0 First Byte Enables
} hqm_sfi_ohc_a1_t;

typedef struct packed {
    logic [23:0]                                rsvd31_8;                   //  31:  8
    logic [3:0]                                 lbe;                        //   7:  4 Last  Byte enables
    logic [3:0]                                 fbe;                        //   3:  0 First Byte enables
} hqm_sfi_ohc_a2_t;

typedef struct packed {
    logic [7:0]                                 dst_segment;                //  31: 24 Destination Segment
    logic [7:0]                                 rsvd23_16;                  //  23: 16
    logic                                       dsv;                        //  15     Destination Segment Valid
    logic [6:0]                                 rsvd14_8;                   //  14:  8
    logic [3:0]                                 lbe;                        //   7:  4 Last  Byte Enables
    logic [3:0]                                 fbe;                        //   3:  0 First Byte Enables
} hqm_sfi_ohc_a3_t;

typedef struct packed {
    logic [7:0]                                 dst_segment;                //  31: 24 Destination Segment
    logic [7:0]                                 pasid15_8;                  //  23: 16 Process Address Space ID 15: 8
    logic                                       dsv;                        //  15     Destination Segment Valid
    logic                                       pv;                         //  14     PASID Valid
    logic                                       pmr;                        //  13     Privileged Mode Required
    logic                                       rsvd12;                     //  12
    logic [3:0]                                 pasid19_16;                 //  11:  8 Process Address Space ID 19:16
    logic [7:0]                                 pasid7_0;                   //   7:  0 Process Address Space ID  7: 0
} hqm_sfi_ohc_a4_t;

typedef struct packed {
    logic [7:0]                                 dst_segment;                //  31: 24 Destination Segment
    logic [7:0]                                 cpl_segment;                //  23: 16 Completer   Segment
    logic                                       dsv;                        //  15     Destination Segment Valid
    logic [9:0]                                 rsvd14_5;                   //  14:  5
    logic [1:0]                                 la1_0;                      //   4:  3 Lower Address
    hqm_sfi_cpl_status_t                        cpl_status;                 //   2:  0 Completion Status
} hqm_sfi_ohc_a5_t;

typedef struct packed {
    logic [7:0]                                 rsvd31_24;                  //  31: 24
    logic [15:0]                                st;                         //  23:  8
    logic [1:0]                                 ph;                         //   7:  6
    logic [1:0]                                 hv;                         //   5   4
    logic [2:0]                                 ama;                        //   3:  1
    logic                                       av;                         //   0
} hqm_sfi_ohc_b_t;

typedef struct packed {
    logic [7:0]                                 req_segment;                //  31: 24 Requestor Segment
    logic [7:0]                                 pr_sent_cnt;                //  23: 16 PR Sent Counter
    logic [7:0]                                 stream_id;                  //  15:  8 Stream ID
    logic [3:0]                                 substream;                  //   7:  4
    logic                                       rsv;                        //   3     Requestor Segment Valid
    logic                                       rsvd2;                      //   2
    logic                                       k;                          //   1
    logic                                       t;                          //   0
} hqm_sfi_ohc_c_t;

typedef union packed {
    hqm_sfi_ohc_c_t                             c;                          // OHC-C
    hqm_sfi_ohc_b_t                             b;                          // OHC-B
    hqm_sfi_ohc_a5_t                            a5;                         // OHC-A5
    hqm_sfi_ohc_a4_t                            a4;                         // OHC-A4
    hqm_sfi_ohc_a3_t                            a3;                         // OHC-A3
    hqm_sfi_ohc_a2_t                            a2;                         // OHC-A2
    hqm_sfi_ohc_a1_t                            a1;                         // OHC-A1
} hqm_sfi_ohc_dw_t;

//-----------------------------------------------------------------------------------------------------
// SFI IOSF prefix

typedef struct packed {
    logic [7:0]                                 prefix_type;                //  31: 24
    logic                                       bcm;                        //  23     Byte Count Modified
    logic [3:0]                                 rs;                         //  22: 19 Root Space
    logic                                       ee;                         //  18
    logic                                       n;                          //  17
    logic                                       c;                          //  16
    logic [7:0]                                 sai;                        //  15:  8 Source Access Identifier
    logic [7:0]                                 srcid;                      //   7:  0
} hqm_sfi_iosf_prefix0_t;

//-----------------------------------------------------------------------------------------------------
// SFI 4/5 DW memory header

typedef struct packed {

    // DW7

    hqm_sfi_ohc_dw_t                            ohc_dw3;                    // 255:224 Orthogonal Header Content

    // DW6

    hqm_sfi_ohc_dw_t                            ohc_dw2;                    // 223:192 Orthogonal Header Content

    // DW5

    hqm_sfi_ohc_dw_t                            ohc_dw1;                    // 191:160 Orthogonal Header Content

    // DW4

    hqm_sfi_ohc_dw_t                            ohc_dw0;                    // 159:128 Orthogonal Header Content

    // DW3

    logic [31:2]                                address31_2;                // 159: 98 Address 63:2
    hqm_sfi_at_t                                at;                         //  97: 96 Address Translation

    // DW2

    logic [15:0]                                reqid;                      //  95: 80 Requestor ID
    logic                                       ep;                         //  79     Poisoned
    logic                                       rsvd78;                     //  78
    logic [13:0]                                tag;                        //  77: 64 Tag

    // DW1

    hqm_sfi_flit_cmd_t                          ttype;                      //  63: 56 Transaction Type
    logic [2:0]                                 tc2_0;                      //  55: 53 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  52: 48 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  47: 45 Trailer Size
    logic [2:0]                                 attr;                       //  44: 42 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //  41: 32

    // DW0

    hqm_sfi_iosf_prefix0_t                      pf0;                        //  31:  0

} hqm_sfi_flit_mem32_hdr_t;

//-----------------------------------------------------------------------------------------------------
// SFI 5/6 DW memory header

typedef struct packed {

    // DW8

    hqm_sfi_ohc_dw_t                            ohc_dw2;                    // 255:224 Orthogonal Header Content

    // DW7

    hqm_sfi_ohc_dw_t                            ohc_dw1;                    // 223:192 Orthogonal Header Content

    // DW6

    hqm_sfi_ohc_dw_t                            ohc_dw0;                    // 191:160 Orthogonal Header Content

    // DW5

    logic [31:2]                                address31_2;                // 159:130 Address 31:2
    hqm_sfi_at_t                                at;                         // 129:128 Address Translation

    // DW4

    logic [31:0]                                address63_32;               // 127: 96 Address 63:32

    // DW2

    logic [15:0]                                reqid;                      //  95: 80 Requestor ID
    logic                                       ep;                         //  79     Poisoned
    logic                                       rsvd78;                     //  78
    logic [13:0]                                tag;                        //  77: 64 Tag

    // DW1

    hqm_sfi_flit_cmd_t                          ttype;                      //  63: 56 Transaction Type
    logic [2:0]                                 tc2_0;                      //  55: 53 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  52: 48 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  47: 45 Trailer Size
    logic [2:0]                                 attr;                       //  44: 42 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //  41: 32

    // DW0

    hqm_sfi_iosf_prefix0_t                      pf0;                        //  31:  0

} hqm_sfi_flit_mem64_hdr_t;

//-----------------------------------------------------------------------------------------------------
// SFI 5/6 DW memory header

typedef struct packed {

    // DW7

    hqm_sfi_ohc_dw_t                            ohc_dw2;                    // 255:224 Orthogonal Header Content

    // DW6

    hqm_sfi_ohc_dw_t                            ohc_dw1;                    // 223:192 Orthogonal Header Content

    // DW5

    hqm_sfi_ohc_dw_t                            ohc_dw0;                    // 191:160 Orthogonal Header Content

    // DW4

    logic [31:2]                                address31_2;                // 159:130 Address 31:2
    hqm_sfi_at_t                                at;                         // 129:128 Address Translation

    // DW4

    logic [31:0]                                address63_32;               // 127: 96 Address 63:32

    // DW2

    logic [15:0]                                reqid;                      //  95: 80 Requestor ID
    logic                                       ep;                         //  79     Poisoned
    logic                                       rsvd78;                     //  78
    logic [13:0]                                tag;                        //  77: 64 Tag

    // DW1

    hqm_sfi_flit_cmd_t                          ttype;                      //  63: 56 Transaction Type
    logic [2:0]                                 tc2_0;                      //  55: 53 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  52: 48 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  47: 45 Trailer Size
    logic [2:0]                                 attr;                       //  44: 42 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //  41: 32

    // DW0

    hqm_sfi_iosf_prefix0_t                      pf0;                        //  31:  0

} hqm_sfi_flit_msg_hdr_t;

//-----------------------------------------------------------------------------------------------------
// SFI 5 DW configuration header

typedef struct packed {

    // DW7

    hqm_sfi_ohc_dw_t                            ohc_dw3;                    // 255:224 Orthogonal Header Content

    // DW6

    hqm_sfi_ohc_dw_t                            ohc_dw2;                    // 223:192 Orthogonal Header Content

    // DW5

    hqm_sfi_ohc_dw_t                            ohc_dw1;                    // 191:160 Orthogonal Header Content

    // DW4 (OHCA3 is required here)

    hqm_sfi_ohc_dw_t                            ohc_dw0;                    // 159:128 Orthogonal Header Content

    // DW3

    logic [15:0]                                bdf;                        // 127:112 Bus/Device/Function
    logic [3:0]                                 rsvd111_108;                // 111:108
    logic [9:0]                                 regnum;                     // 107: 98 Register number
    logic [1:0]                                 rsvd97_96;                  //  97: 96

    // DW2

    logic [15:0]                                reqid;                      //  95: 80 Requestor ID
    logic                                       ep;                         //  79     Poisoned
    logic                                       rsvd78;                     //  78
    logic [13:0]                                tag;                        //  77: 64 Tag

    // DW1

    hqm_sfi_flit_cmd_t                          ttype;                      //  63: 56 Transaction Type
    logic [2:0]                                 tc2_0;                      //  55: 53 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  52: 48 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  47: 45 Trailer Size
    logic [2:0]                                 attr;                       //  44: 42 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //  41: 32

    // DW0

    hqm_sfi_iosf_prefix0_t                      pf0;                        //  31:  0

} hqm_sfi_flit_cfg_hdr_t;

//-----------------------------------------------------------------------------------------------------
// SFI 4/5 DW completion header

typedef struct packed {

    // DW7

    hqm_sfi_ohc_dw_t                            ohc_dw3;                    // 255:224 Orthogonal Header Content

    // DW6

    hqm_sfi_ohc_dw_t                            ohc_dw2;                    // 223:192 Orthogonal Header Content

    // DW5

    hqm_sfi_ohc_dw_t                            ohc_dw1;                    // 191:160 Orthogonal Header Content

    // DW4

    hqm_sfi_ohc_dw_t                            ohc_dw0;                    // 159:128 Orthogonal Header Content

    // DW3

    logic [15:0]                                bdf;                        // 127:112 Bus/Device/Function
    logic [3:0]                                 la5_2;                      // 111:108 Lower Address 5:2
    logic [11:0]                                bc;                         // 107: 96 Byte Count

    // DW2

    logic [15:0]                                cplid;                      //  95: 80 Completer ID
    logic                                       ep;                         //  79     Poisoned
    logic                                       la6;                        //  78     Lower Address 6
    logic [13:0]                                tag;                        //  77: 64 Tag

    // DW1

    hqm_sfi_flit_cmd_t                          ttype;                      //  63: 56 Transaction Type
    logic [2:0]                                 tc2_0;                      //  55: 53 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  52: 48 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  47: 45 Trailer Size
    logic [2:0]                                 attr;                       //  44: 42 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //  41: 32

    // DW0

    hqm_sfi_iosf_prefix0_t                      pf0;                        //  31:  0

} hqm_sfi_flit_cpl_hdr_t;

//-----------------------------------------------------------------------------------------------------
// SFI 5/6 DW invalidate response header

typedef struct packed {

    // DW7

    hqm_sfi_ohc_dw_t                            ohc_dw2;                    // 255:224 Orthogonal Header Content

    // DW6

    hqm_sfi_ohc_dw_t                            ohc_dw1;                    // 223:192 Orthogonal Header Content

    // DW5

    logic [7:0]                                 dest_seg;                   // 191:183
    logic [7:0]                                 pasid15_8;                  // 182:176
    logic                                       dsv;                        // 175
    logic                                       pv;                         // 174
    logic [1:0]                                 dw5_rsvd;                   // 173:172
    logic [3:0]                                 pasid19_16;                 // 171:168
    logic [7:0]                                 pasid7_0;                   // 167:160
    

    // DW4

    logic [31:0]                                itag_vec;                   // 159:128

    // DW3

    logic [15:0]                                bdf;                        // 127:112 Bus/Device/Function
    logic [3:0]                                 dw3_rsvd_23_16;             // 111:104
    logic [2:0]                                 dw3_rsvd_31_27;             // 103:99
    logic [8:0]                                 cc;                         // 98:96

    // DW2

    logic [15:0]                                reqid;                      //  95: 80 Requestor ID
    logic [7:0]                                 rsvd_itag;                       //  76: 72 Invalidate Tag
    logic [7:0]                                 msg_code;                   //  71: 64 Message Code

    // DW1

    hqm_sfi_flit_cmd_t                          ttype;                      //  63: 56 Transaction Type
    logic [2:0]                                 tc2_0;                      //  55: 53 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  52: 48 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  47: 45 Trailer Size
    logic [2:0]                                 attr;                       //  44: 42 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //  41: 32

    // DW0

    hqm_sfi_iosf_prefix0_t                      pf0;                        //  31:  0

} hqm_sfi_flit_invcpl_hdr_SFIenc_t;
//-----------------------------------------------------------------------------------------------------
// SFI 5 DW invalidate response header

typedef struct packed {

    // DW7

    hqm_sfi_ohc_dw_t                            ohc_dw2;                    // 255:224 Orthogonal Header Content

    // DW6

    hqm_sfi_ohc_dw_t                            ohc_dw1;                    // 223:192 Orthogonal Header Content

    // DW5

    hqm_sfi_ohc_dw_t                            ohc_dw0;                    // 191:160 Orthogonal Header Content

    // DW4

    logic [31:0]                                itag_vec;                   // 159:128

    // DW3

    logic [15:0]                                bdf;                        // 127:112 Bus/Device/Function
    logic [3:0]                                 dw3_rsvd_23_16;             // 111:104
    logic [2:0]                                 dw3_rsvd_31_27;             // 103:99
    logic [8:0]                                 cc;                         // 98:96

    // DW2

    logic [15:0]                                reqid;                      //  95: 80 Requestor ID
    logic [7:0]                                 rsvd_itag;                       //  76: 72 Invalidate Tag
    logic [7:0]                                 msg_code;                   //  71: 64 Message Code

    // DW1

    hqm_sfi_flit_cmd_t                          ttype;                      //  63: 56 Transaction Type
    logic [2:0]                                 tc2_0;                      //  55: 53 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  52: 48 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  47: 45 Trailer Size
    logic [2:0]                                 attr;                       //  44: 42 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //  41: 32

    // DW0

    hqm_sfi_iosf_prefix0_t                      pf0;                        //  31:  0

} hqm_sfi_flit_invcpl_hdr_t;



//-----------------------------------------------------------------------------------------------------
// SFI 5/6 DW invalidate response header

typedef struct packed {

    // DW7

    hqm_sfi_ohc_dw_t                            ohc_dw2;                    // 255:224 Orthogonal Header Content

    // DW6

    hqm_sfi_ohc_dw_t                            ohc_dw1;                    // 223:192 Orthogonal Header Content

    // DW5

    //logic [7:0]                                 dest_seg_rsvd;              // 191:183
    //logic [7:0]                                 pasid15_8;                  // 182:176
    //logic                                       dv;                         // 175
    //logic                                       pv;                         // 174
    //logic [1:0]                                 dw5_rsvd;                   // 173:172
    //logic [3:0]                                 pasid19_16;                 // 171:168
    //logic [7:0]                                 pasid7_0;                   // 167:160
    hqm_sfi_ohc_dw_t                            ohc_dw0;                    // 191:160 Orthogonal Header Content

    // DW4
    logic [31:0]                                dw4_rsvd;                   // 159:128

    // DW3

    logic [15:0]                                bdf;                        // 127:112 Bus/Device/Function
    logic [3:0]                                 rsp_code;                   // 111:108
    logic [2:0]                                 dw3_rsvd;                   // 107:105
    logic [8:0]                                 pr_grp_idx;                 // 104:96

    // DW2

    logic [15:0]                                reqid;                      //  95: 80 Requestor ID
    logic [7:0]                                 rsvd_itag;                       //  76: 72 Invalidate Tag
    logic [7:0]                                 msg_code;                   //  71: 64 Message Code

    // DW1

    hqm_sfi_flit_cmd_t                          ttype;                      //  63: 56 Transaction Type
    logic [2:0]                                 tc2_0;                      //  55: 53 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  52: 48 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  47: 45 Trailer Size
    logic [2:0]                                 attr;                       //  44: 42 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //  41: 32

    // DW0

    hqm_sfi_iosf_prefix0_t                      pf0;                        //  31:  0

} hqm_sfi_flit_invrsp_hdr_SFIenc_t;
//-----------------------------------------------------------------------------------------------------
// SFI 5 DW invalidate response header

typedef struct packed {

    // DW7

    hqm_sfi_ohc_dw_t                            ohc_dw2;                    // 255:224 Orthogonal Header Content

    // DW6

    hqm_sfi_ohc_dw_t                            ohc_dw1;                    // 223:192 Orthogonal Header Content

    // DW5

    hqm_sfi_ohc_dw_t                            ohc_dw0;                    // 191:160 Orthogonal Header Content

    // DW4

    logic [31:0]                                itag_vec;                   // 159:128

    // DW3

    logic [15:0]                                bdf;                        // 127:112 Bus/Device/Function
    logic [12:0]                                rsvd111_99;                 // 111: 99
    logic [2:0]                                 cc;                         //  98: 96

    // DW2

    logic [15:0]                                reqid;                      //  95: 80 Requestor ID
    logic [7:0]                                 rsvd79_72;                  //  79: 72
    logic [7:0]                                 msg_code;                   //  71: 64 Message Code

    // DW1

    hqm_sfi_flit_cmd_t                          ttype;                      //  63: 56 Transaction Type
    logic [2:0]                                 tc2_0;                      //  55: 53 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  52: 48 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  47: 45 Trailer Size
    logic [2:0]                                 attr;                       //  44: 42 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //  41: 32

    // DW0

    hqm_sfi_iosf_prefix0_t                      pf0;                        //  31:  0

} hqm_sfi_flit_invrsp_hdr_t;


//-----------------------------------------------------------------------------------------------------
// SFI 5 DW invalidate request header

typedef struct packed {

    // DW7

    hqm_sfi_ohc_dw_t                            ohc_dw2;                    // 255:224 Orthogonal Header Content

    // DW6

    hqm_sfi_ohc_dw_t                            ohc_dw1;                    // 223:192 Orthogonal Header Content

    // DW5

    logic                                         rsvdNW;
    logic                                         pv;
    logic                                         rsvdPMR;
    logic                                         rsvdER;
    logic [19:0]                                  pasid;
    logic [3:0]                                   lbe;
    logic [3:0]                                   fbe;
    

    // DW4

    //logic [31:0]                                itag_vec;                   // 159:128
    logic [19:0]                                  page_addr31_12;
    logic [8:0]                                   page_req_grpidx;
    logic                                         pr_l;
    logic                                         pr_w;
    logic                                         pr_r;


    // DW3
    
    logic [31:0]                                  page_addr63_32;
    //logic [15:0]                                bdf;                        // 127:112 Bus/Device/Function
    //logic [12:0]                                rsvd111_99;                 // 111: 99
    //logic [2:0]                                 cc;                         //  98: 96

    // DW2

    logic [15:0]                                reqid;                      //  95: 80 Requestor ID
    logic [7:0]                                 rsvd79_72;                  //  79: 72
    logic [7:0]                                 msg_code;                   //  71: 64 Message Code

    // DW1

    hqm_sfi_flit_cmd_t                          ttype;                      //  63: 56 Transaction Type
    logic [2:0]                                 tc2_0;                      //  55: 53 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  52: 48 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  47: 45 Trailer Size
    logic [2:0]                                 attr;                       //  44: 42 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //  41: 32

    // DW0

    hqm_sfi_iosf_prefix0_t                      pf0;                        //  31:  0

} hqm_sfi_flit_invreq_hdr_SFIenc_t;
//-----------------------------------------------------------------------------------------------------
// SFI 5/6 DW invalidate request header

typedef struct packed {

    // DW7

    hqm_sfi_ohc_dw_t                            ohc_dw2;                    // 255:224 Orthogonal Header Content

    // DW6

    hqm_sfi_ohc_dw_t                            ohc_dw1;                    // 223:192 Orthogonal Header Content

    // DW5

    hqm_sfi_ohc_dw_t                            ohc_dw0;                    // 191:160 Orthogonal Header Content

    // DW4

    logic [31:0]                                rsvd159_128;                // 159:128

    // DW3

    logic [15:0]                                bdf;                        // 127:112 Bus/Device/Function
    logic [15:0]                                rsvd111_96;                 // 111: 96

    // DW2

    logic [15:0]                                reqid;                      //  95: 80 Requestor ID
    logic [2:0]                                 rsvd79_77;                  //  79: 77
    logic [4:0]                                 itag;                       //  76: 72 Invalidate Tag
    logic [7:0]                                 msg_code;                   //  71: 64 Message Code

    // DW1

    hqm_sfi_flit_cmd_t                          ttype;                      //  63: 56 Transaction Type
    logic [2:0]                                 tc2_0;                      //  55: 53 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  52: 48 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  47: 45 Trailer Size
    logic [2:0]                                 attr;                       //  44: 42 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //  41: 32

    // DW0

    hqm_sfi_iosf_prefix0_t                      pf0;                        //  31:  0

} hqm_sfi_flit_invreq_hdr_t;


//-----------------------------------------------------------------------------------------------------

typedef struct packed {

    logic [31:0]                        dw7;                        // 255:224
    logic [31:0]                        dw6;                        // 223:192
    logic [31:0]                        dw5;                        // 191:160
    logic [31:0]                        dw4;                        // 159:128
    logic [31:0]                        dw3;                        // 127: 96
    logic [31:0]                        dw2;                        //  95: 64
    logic [31:0]                        dw1;                        //  63: 32
    logic [31:0]                        dw0;                        //  31:  0

} hqm_sfi_dws_hdr_t;

//-----------------------------------------------------------------------------------------------------
// Union of different SFI header types

typedef union packed {
    hqm_sfi_flit_mem32_hdr_t                    mem32;
    hqm_sfi_flit_mem64_hdr_t                    mem64;
    hqm_sfi_flit_cfg_hdr_t                      cfg;
    hqm_sfi_flit_cpl_hdr_t                      cpl;
    hqm_sfi_flit_invreq_hdr_t                   invreq;
    hqm_sfi_flit_invreq_hdr_SFIenc_t            invreqSFI;
    hqm_sfi_flit_invrsp_hdr_t                   invrsp;
    hqm_sfi_flit_invrsp_hdr_SFIenc_t            invrspSFI;
    hqm_sfi_flit_invcpl_hdr_t                   invcpl;
    hqm_sfi_flit_invcpl_hdr_SFIenc_t            invcplSFI;
    hqm_sfi_dws_hdr_t                           dws;
    hqm_sfi_flit_msg_hdr_t                      msg;
} hqm_sfi_flit_header_t;

//-----------------------------------------------------------------------------------------------------
// SFI info bytes

typedef struct packed {
    logic                                       parity;
    logic                                       has_data;
    logic                                       shared_crd;
    logic [4:0]                                 vc_id;                      // Virtual channel
    logic [3:0]                                 hdr_size;                   // Header size
    logic [1:0]                                 rsvd3_2;
    hqm_sfi_fc_id_t                             fc_id;                      // Flow class
} hqm_sfi_hdr_info_t;

typedef struct packed {
    logic [4:0]                                 vc_id;                      // Virtual channel
    logic                                       shared_crd;
    hqm_sfi_fc_id_t                             fc_id;                      // Flow class
} hqm_sfi_data_info_t;

//-----------------------------------------------------------------------------------------------------
// Inbound completion header

typedef struct packed {

    logic                                       parity;                     // 130     Parity
    logic                                       lock;                       // 129     CplLk or CplDLk
    logic                                       has_data;                   // 128     Data included

    // DW3

    hqm_sfi_ohc_dw_t                            ohc_dw0;                    // 127: 96 Orthogonal Header Content

    // DW2

    logic [15:0]                                bdf;                        //  95: 80 Bus/Device/Function
    logic [3:0]                                 la5_2;                      //  79: 76 Lower Address 5:2
    logic [11:0]                                bc;                         //  75: 64 Byte Count

    // DW1

    logic [15:0]                                cplid;                      //  63: 48 Completer ID
    logic                                       ep;                         //  47     Poisoned
    logic                                       la6;                        //  46     Lower Address 6
    logic [13:0]                                tag;                        //  45: 32 Tag

    // DW0

    hqm_sfi_flit_cmd_t                          ttype;                      //  31: 24 Transaction Type
    logic [2:0]                                 tc2_0;                      //  23: 21 Traffic Class 2:0
    hqm_sfi_ohc_t                               ohc;                        //  20: 16 Orthogonal Header Content Type
    hqm_sfi_ts_t                                ts;                         //  15: 13 Trailer Size
    logic [2:0]                                 attr;                       //  12: 10 Attributes (IDO, RO, NS)
    logic [9:0]                                 len;                        //   9:  0

} hqm_sfi_ibcpl_hdr_t;

//-----------------------------------------------------------------------------------------------------
// SFI global channels

typedef struct packed {
    logic                                       rxcon_ack;                  // Connection acknowledge
    logic                                       rxdiscon_nack;              // Disconnect rejection
    logic                                       rx_empty;                   // Reciever queues are empty and all credits returned
} hqm_sfi_tx_rxglobal_t;

typedef struct packed {
    logic                                       txcon_req;                  // Connection request
} hqm_sfi_tx_txglobal_t;

typedef struct packed {
    logic                                       rxcon_ack;                  // Connection acknowledge
    logic                                       rxdiscon_nack;              // Disconnect rejection
    logic                                       rx_empty;                   // Reciever queues are empty and all credits returned
} hqm_sfi_rx_rxglobal_t;

typedef struct packed {
    logic                                       txcon_req;                  // Connection request
} hqm_sfi_rx_txglobal_t;

//-----------------------------------------------------------------------------------------------------
// SFI header channel

typedef struct packed {
    logic                                       hdr_valid;                  // Header is valid
    logic                                       hdr_early_valid;            // Header early valid indication
    hqm_sfi_hdr_info_t                          hdr_info_bytes;             // Header info
    hqm_sfi_flit_header_t                       header;                     // Header
} hqm_sfi_hdr_t;

//-----------------------------------------------------------------------------------------------------
// SFI data channels

typedef struct packed {
    logic                                       data_valid;                 // Data is valid
    logic                                       data_early_valid;           // Early valid indication
    logic                                       data_aux_parity;            // Data auxillary parity
    logic [HQM_SFI_RX_DATA_POISON_WIDTH-1:0]    data_poison;                // Data poisoned per DW
    logic [HQM_SFI_RX_DATA_EDB_WIDTH-1:0]       data_edb;                   // Data bad per DW
    logic                                       data_start;                 // Start of data
    logic [HQM_SFI_RX_DATA_END_WIDTH-1:0]       data_end;                   // End   of data
    logic [HQM_SFI_RX_DATA_PARITY_WIDTH-1:0]    data_parity;                // Data parity per 8B
    hqm_sfi_data_info_t                         data_info_byte;             // Data info
    logic [HQM_SFI_RX_DATA_WIDTH-1:0]           data;                       // Data payload
} hqm_sfi_rx_data_t;

typedef struct packed {
    logic                                       data_valid;                 // Data is valid
    logic                                       data_early_valid;           // Early valid indication
    logic                                       data_aux_parity;            // Data auxillary parity
    logic [HQM_SFI_TX_DATA_POISON_WIDTH-1:0]    data_poison;                // Data poisoned per DW
    logic [HQM_SFI_TX_DATA_EDB_WIDTH-1:0]       data_edb;                   // Data bad per DW
    logic                                       data_start;                 // Start of data
    logic [HQM_SFI_TX_DATA_END_WIDTH-1:0]       data_end;                   // End   of data
    logic [HQM_SFI_TX_DATA_PARITY_WIDTH-1:0]    data_parity;                // Data parity per 8B
    hqm_sfi_data_info_t                         data_info_byte;             // Data info
    logic [HQM_SFI_TX_DATA_WIDTH-1:0]           data;                       // Data payload
} hqm_sfi_tx_data_t;

//-----------------------------------------------------------------------------------------------------
// SFI state machines

typedef enum logic[4:0] {
     HQM_SFI_TX_STATE_DISCONNECTED              = 5'b00001
    ,HQM_SFI_TX_STATE_CONNECTING                = 5'b00010
    ,HQM_SFI_TX_STATE_CONNECTED                 = 5'b00100
    ,HQM_SFI_TX_STATE_DISCONNECTING             = 5'b01000
    ,HQM_SFI_TX_STATE_HARD_DISCONNECT           = 5'b10000
} hqm_sfi_tx_state_t;

localparam int unsigned HQM_SFI_TX_STATE_DISCONNECTED_BIT    = 0;
localparam int unsigned HQM_SFI_TX_STATE_CONNECTING_BIT      = 1;
localparam int unsigned HQM_SFI_TX_STATE_CONNECTED_BIT       = 2;
localparam int unsigned HQM_SFI_TX_STATE_DISCONNECTING_BIT   = 3;
localparam int unsigned HQM_SFI_TX_STATE_HARD_DISCONNECT_BIT = 4;

typedef enum logic[2:0] {
     HQM_SFI_RX_STATE_DISCONNECTED              = 3'b001
    ,HQM_SFI_RX_STATE_CONNECTED                 = 3'b010
    ,HQM_SFI_RX_STATE_DENY                      = 3'b100
} hqm_sfi_rx_state_t;

localparam int unsigned HQM_SFI_RX_STATE_DISCONNECTED_BIT    = 0;
localparam int unsigned HQM_SFI_RX_STATE_CONNECTED_BIT       = 1;
localparam int unsigned HQM_SFI_RX_STATE_DENY_BIT            = 2;

//-----------------------------------------------------------------------------------------------------

endpackage: hqm_sfi_pkg

