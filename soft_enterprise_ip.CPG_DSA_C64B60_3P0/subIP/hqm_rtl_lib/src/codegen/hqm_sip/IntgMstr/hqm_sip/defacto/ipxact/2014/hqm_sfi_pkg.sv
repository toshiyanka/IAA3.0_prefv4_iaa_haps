
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
package hqm_sfi_pkg ;
    import hqm_AW_pkg:: * ;
    localparam HQM_SFI_RX_HDR_NUM_VCS = 3 ; // Need 0,2,7
    localparam HQM_SFI_RX_HDR_NUM_VCS_M1 = (HQM_SFI_RX_HDR_NUM_VCS - 1) ; 
    localparam HQM_SFI_RX_HDR_VC_WIDTH = ((HQM_SFI_RX_HDR_NUM_VCS == 1) ? 1 :
	$clog2(HQM_SFI_RX_HDR_NUM_VCS)) ; 
    localparam HQM_SFI_RX_HDR_NUM_FLOWS = (HQM_SFI_RX_HDR_NUM_VCS * 3) ; 
    localparam HQM_SFI_RX_HDR_FLOWS_WIDTH = ((HQM_SFI_RX_HDR_NUM_FLOWS == 1) ? 1 :
	$clog2(HQM_SFI_RX_HDR_NUM_FLOWS)) ; 
    localparam HQM_SFI_RX_DATA_NUM_VCS = 3 ; // Need 0,2,7
    localparam HQM_SFI_RX_DATA_VC_WIDTH = ((HQM_SFI_RX_DATA_NUM_VCS == 1) ? 1 :
	$clog2(HQM_SFI_RX_DATA_NUM_VCS)) ; 
    localparam HQM_SFI_RX_DATA_NUM_FLOWS = (HQM_SFI_RX_DATA_NUM_VCS * 3) ; 
    localparam HQM_SFI_RX_DATA_FLOWS_WIDTH = ((HQM_SFI_RX_DATA_NUM_FLOWS == 1) ? 1 :
	$clog2(HQM_SFI_RX_DATA_NUM_FLOWS)) ; 
    localparam HQM_SFI_RX_DATA_WIDTH = 256 ; // 32B
    localparam HQM_SFI_RX_DATA_POISON_WIDTH = (HQM_SFI_RX_DATA_WIDTH / 32) ; // per 1 DW
    localparam HQM_SFI_RX_DATA_EDB_WIDTH = (HQM_SFI_RX_DATA_WIDTH / 32) ; // per 1 DW
    localparam HQM_SFI_RX_DATA_PARITY_WIDTH = (HQM_SFI_RX_DATA_WIDTH / 64) ; // per 2 DWs
    localparam HQM_SFI_RX_DATA_END_WIDTH = (HQM_SFI_RX_DATA_WIDTH / 32) ; // per 1 DW
    localparam HQM_SFI_TX_HDR_NUM_VCS = 3 ; // Need 0,2,7
    localparam HQM_SFI_TX_HDR_NUM_VCS_M1 = (HQM_SFI_TX_HDR_NUM_VCS - 1) ; 
    localparam HQM_SFI_TX_HDR_VC_WIDTH = ((HQM_SFI_TX_HDR_NUM_VCS == 1) ? 1 :
	$clog2(HQM_SFI_TX_HDR_NUM_VCS)) ; 
    localparam HQM_SFI_TX_HDR_NUM_FLOWS = (HQM_SFI_TX_HDR_NUM_VCS * 3) ; 
    localparam HQM_SFI_TX_HDR_FLOWS_WIDTH = ((HQM_SFI_TX_HDR_NUM_FLOWS == 1) ? 1 :
	$clog2(HQM_SFI_TX_HDR_NUM_FLOWS)) ; 
    localparam HQM_SFI_TX_DATA_NUM_VCS = 3 ; // Need 0,2,7
    localparam HQM_SFI_TX_DATA_VC_WIDTH = ((HQM_SFI_TX_DATA_NUM_VCS == 1) ? 1 :
	$clog2(HQM_SFI_TX_DATA_NUM_VCS)) ; 
    localparam HQM_SFI_TX_DATA_NUM_FLOWS = (HQM_SFI_TX_DATA_NUM_VCS * 3) ; 
    localparam HQM_SFI_TX_DATA_FLOWS_WIDTH = ((HQM_SFI_TX_DATA_NUM_FLOWS == 1) ? 1 :
	$clog2(HQM_SFI_TX_DATA_NUM_FLOWS)) ; 
    localparam HQM_SFI_TX_DATA_WIDTH = 256 ; // 32B
    localparam HQM_SFI_TX_DATA_POISON_WIDTH = (HQM_SFI_TX_DATA_WIDTH / 32) ; // per 1 DW
    localparam HQM_SFI_TX_DATA_EDB_WIDTH = (HQM_SFI_TX_DATA_WIDTH / 32) ; // per 1 DW
    localparam HQM_SFI_TX_DATA_PARITY_WIDTH = (HQM_SFI_TX_DATA_WIDTH / 64) ; // per 2 DWs
    localparam HQM_SFI_TX_DATA_END_WIDTH = (HQM_SFI_TX_DATA_WIDTH / 32) ; // per 1 DW
    // Making these 1 location wider for VC and FC than needed to allow indexing w/o lint issues
    localparam int // NA,Cpl, NP,  P
        // Ch3 UNUSED
        // Ch2 (Ch2) ATS responses   (Cpl/CplD)
        // Ch1 (Ch7) UIOWr responses (Cpl only)
        // Ch0 (Ch0) CFGRD0/WR0, MWr, MRd, Invalidate Reqs
        HQM_SFI_RX_HDR_CREDITS [3:0][3:0] = '{'{0,0,0,0},'{0,0,0,0},'{0,0,0,0},'{0,0,8,16}} ; 
    localparam int // NA,Cpl, NP,  P
        // Ch3 UNUSED
        // Ch2 (Ch2) ATS responses   (Cpl/CplD)
        // Ch1 (Ch7) UIOWr responses (Cpl only)
        // Ch0 (Ch0) CFGRD0/WR0, MWr, MRd, Invalidate Reqs
        HQM_SFI_RX_DATA_CREDITS [3:0][3:0] = '{'{0,0,0,0},'{0,0,0,0},'{0,0,0,0},'{0,0,8,48}} ; 
    localparam int // NA,Cpl, NP,  P
        // Ch3 UNUSED
        // Ch2 (Ch2) ATS requests (MRd)
        // Ch1 (Ch7) CQ writes (UIOWr)
        // Ch0 (Ch0) Int writes, Cpl/CplD (TBD: option to force CQ writes here?)
        HQM_SFI_BRIDGE_RX_HDR_CREDITS [3:0][3:0] = '{'{0,0,0,0},'{0,0,8,0},'{0,0,8,8},'{0,8,8,8}} ; 
    localparam int // NA,Cpl, NP,  P
        // Ch3 UNUSED
        // Ch2 (Ch2) ATS requests (MRd)
        // Ch1 (Ch7) CQ writes (UIOWr)
        // Ch0 (Ch0) Int writes, Cpl/CplD (TBD: option to force CQ writes here?)
        HQM_SFI_BRIDGE_RX_DATA_CREDITS [3:0][3:0] = '{'{0,0,0,0},'{0,0,0,0},'{0,0,16,16},'{0,8,8,8}} ; 
    typedef enum logic [7:0] { FLIT_CMD_NOP = 8'h00, FLIT_CMD_MRDLK32 = 8'h01, FLIT_CMD_IORD = 8'h02, FLIT_CMD_MRD32 = 8'h03, FLIT_CMD_CFGRD0 = 8'h04, FLIT_CMD_CFGRD1 = 8'h05, FLIT_CMD_RSVD06 = 8'h06, FLIT_CMD_RSVD07 = 8'h07, FLIT_CMD_RSVD08 = 8'h08, FLIT_CMD_RSVD09 = 8'h09, FLIT_CMD_CPL = 8'h0a, FLIT_CMD_CPLLK = 8'h0b, FLIT_CMD_UIOWRSETCPL = 8'h0c, FLIT_CMD_UIORDCPL = 8'h0d, FLIT_CMD_RSVD0E = 8'h0e, 
            FLIT_CMD_RSVD0F = 8'h0f, FLIT_CMD_RSVD10 = 8'h10, FLIT_CMD_RSVD11 = 8'h11, FLIT_CMD_RSVD12 = 8'h12, FLIT_CMD_RSVD13 = 8'h13, FLIT_CMD_RSVD14 = 8'h14, FLIT_CMD_RSVD15 = 8'h15, FLIT_CMD_RSVD16 = 8'h16, FLIT_CMD_RSVD17 = 8'h17, FLIT_CMD_RSVD18 = 8'h18, FLIT_CMD_RSVD19 = 8'h19, FLIT_CMD_RSVD1A = 8'h1a, FLIT_CMD_RSVD1B = 8'h1b, FLIT_CMD_RSVD1C = 8'h1c, FLIT_CMD_RSVD1D = 8'h1d, 
            FLIT_CMD_RSVD1E = 8'h1e, FLIT_CMD_RSVD1F = 8'h1f, FLIT_CMD_MRD64 = 8'h20, FLIT_CMD_MRDLK64 = 8'h21, FLIT_CMD_UIORD = 8'h22, FLIT_CMD_RSVD23 = 8'h23, FLIT_CMD_RSVD24 = 8'h24, FLIT_CMD_RSVD25 = 8'h25, FLIT_CMD_RSVD26 = 8'h26, FLIT_CMD_RSVD27 = 8'h27, FLIT_CMD_RSVD28 = 8'h28, FLIT_CMD_RSVD29 = 8'h29, FLIT_CMD_RSVD2A = 8'h2a, FLIT_CMD_RSVD2B = 8'h2b, FLIT_CMD_RSVD2C = 8'h2c, 
            FLIT_CMD_RSVD2D = 8'h2d, FLIT_CMD_RSVD2E = 8'h2e, FLIT_CMD_RSVD2F = 8'h2f, FLIT_CMD_MSG0 = 8'h30, FLIT_CMD_MSG1 = 8'h31, FLIT_CMD_MSG2 = 8'h32, FLIT_CMD_MSG3 = 8'h33, FLIT_CMD_MSG4 = 8'h34, FLIT_CMD_MSG5 = 8'h35, FLIT_CMD_RSVD36 = 8'h36, FLIT_CMD_RSVD37 = 8'h37, FLIT_CMD_RSVD38 = 8'h38, FLIT_CMD_RSVD39 = 8'h39, FLIT_CMD_RSVD3A = 8'h3a, FLIT_CMD_RSVD3B = 8'h3b, 
            FLIT_CMD_RSVD3C = 8'h3c, FLIT_CMD_RSVD3D = 8'h3d, FLIT_CMD_RSVD3E = 8'h3e, FLIT_CMD_RSVD3F = 8'h3f, FLIT_CMD_MWR32 = 8'h40, FLIT_CMD_RSVD41 = 8'h41, FLIT_CMD_IOWr = 8'h42, FLIT_CMD_RSVD43 = 8'h43, FLIT_CMD_CFGWR0 = 8'h44, FLIT_CMD_CFGWR1 = 8'h45, FLIT_CMD_RSVD46 = 8'h46, FLIT_CMD_RSVD47 = 8'h47, FLIT_CMD_UIORDCPLD = 8'h48, FLIT_CMD_RSVD49 = 8'h49, FLIT_CMD_CPLD = 8'h4a, 
            FLIT_CMD_CPLDLK = 8'h4b, FLIT_CMD_FETCHADD32 = 8'h4c, FLIT_CMD_SWAP32 = 8'h4d, FLIT_CMD_CAS32 = 8'h4e, FLIT_CMD_RSVD4F = 8'h4f, FLIT_CMD_RSVD50 = 8'h50, FLIT_CMD_RSVD51 = 8'h51, FLIT_CMD_RSVD52 = 8'h52, FLIT_CMD_RSVD53 = 8'h53, FLIT_CMD_RSVD54 = 8'h54, FLIT_CMD_RSVD55 = 8'h55, FLIT_CMD_RSVD56 = 8'h56, FLIT_CMD_RSVD57 = 8'h57, FLIT_CMD_RSVD58 = 8'h58, FLIT_CMD_RSVD59 = 8'h59, 
            FLIT_CMD_RSVD5A = 8'h5a, FLIT_CMD_DMWR32 = 8'h5b, FLIT_CMD_RSVD5C = 8'h5c, FLIT_CMD_RSVD5D = 8'h5d, FLIT_CMD_RSVD5E = 8'h5e, FLIT_CMD_RSVD5F = 8'h5f, FLIT_CMD_MWR64 = 8'h60, FLIT_CMD_UIOWR = 8'h61, FLIT_CMD_RSVD62 = 8'h62, FLIT_CMD_RSVD63 = 8'h63, FLIT_CMD_RSVD64 = 8'h64, FLIT_CMD_RSVD65 = 8'h65, FLIT_CMD_RSVD66 = 8'h66, FLIT_CMD_RSVD67 = 8'h67, FLIT_CMD_RSVD68 = 8'h68, 
            FLIT_CMD_RSVD69 = 8'h69, FLIT_CMD_RSVD6A = 8'h6a, FLIT_CMD_RSVD6B = 8'h6b, FLIT_CMD_FETCHADD64 = 8'h6c, FLIT_CMD_SWAP64 = 8'h6d, FLIT_CMD_CAS64 = 8'h6e, FLIT_CMD_RSVD6F = 8'h6f, FLIT_CMD_MSGD0 = 8'h70, FLIT_CMD_MSGD1 = 8'h71, FLIT_CMD_MSGD2 = 8'h72, FLIT_CMD_MSGD3 = 8'h73, FLIT_CMD_MSGD4 = 8'h74, FLIT_CMD_MSGD5 = 8'h75, FLIT_CMD_RSVD76 = 8'h76, FLIT_CMD_RSVD77 = 8'h77, 
            FLIT_CMD_RSVD78 = 8'h78, FLIT_CMD_RSVD79 = 8'h79, FLIT_CMD_RSVD7A = 8'h7a, FLIT_CMD_DMWR64 = 8'h7b, FLIT_CMD_RSVD7C = 8'h7c, FLIT_CMD_RSVD7D = 8'h7d, FLIT_CMD_RSVD7E = 8'h7e, FLIT_CMD_RSVD7F = 8'h7f, FLIT_CMD_RSVD80 = 8'h80, FLIT_CMD_RSVD81 = 8'h81, FLIT_CMD_RSVD82 = 8'h82, FLIT_CMD_RSVD83 = 8'h83, FLIT_CMD_RSVD84 = 8'h84, FLIT_CMD_RSVD85 = 8'h85, FLIT_CMD_RSVD86 = 8'h86, 
            FLIT_CMD_RSVD87 = 8'h87, FLIT_CMD_RSVD88 = 8'h88, FLIT_CMD_RSVD89 = 8'h89, FLIT_CMD_RSVD8A = 8'h8a, FLIT_CMD_RSVD8B = 8'h8b, FLIT_CMD_RSVD8C = 8'h8c, FLIT_CMD_RSVD8D = 8'h8d, FLIT_CMD_RSVD8E = 8'h8e, FLIT_CMD_RSVD8F = 8'h8f, FLIT_CMD_RSVD90 = 8'h90, FLIT_CMD_RSVD91 = 8'h91, FLIT_CMD_RSVD92 = 8'h92, FLIT_CMD_RSVD93 = 8'h93, FLIT_CMD_RSVD94 = 8'h94, FLIT_CMD_RSVD95 = 8'h95, 
            FLIT_CMD_RSVD96 = 8'h96, FLIT_CMD_RSVD97 = 8'h97, FLIT_CMD_RSVD98 = 8'h98, FLIT_CMD_RSVD99 = 8'h99, FLIT_CMD_RSVD9A = 8'h9a, FLIT_CMD_RSVD9B = 8'h9b, FLIT_CMD_RSVD9C = 8'h9c, FLIT_CMD_RSVD9D = 8'h9d, FLIT_CMD_RSVD9E = 8'h9e, FLIT_CMD_RSVD9F = 8'h9f, FLIT_CMD_RSVDA0 = 8'ha0, FLIT_CMD_RSVDA1 = 8'ha1, FLIT_CMD_RSVDA2 = 8'ha2, FLIT_CMD_RSVDA3 = 8'ha3, FLIT_CMD_RSVDA4 = 8'ha4, 
            FLIT_CMD_RSVDA5 = 8'ha5, FLIT_CMD_RSVDA6 = 8'ha6, FLIT_CMD_RSVDA7 = 8'ha7, FLIT_CMD_RSVDA8 = 8'ha8, FLIT_CMD_RSVDA9 = 8'ha9, FLIT_CMD_RSVDAA = 8'haa, FLIT_CMD_RSVDAB = 8'hab, FLIT_CMD_RSVDAC = 8'hac, FLIT_CMD_RSVDAD = 8'had, FLIT_CMD_RSVDAE = 8'hae, FLIT_CMD_RSVDAF = 8'haf, FLIT_CMD_RSVDB0 = 8'hb0, FLIT_CMD_RSVDB1 = 8'hb1, FLIT_CMD_RSVDB2 = 8'hb2, FLIT_CMD_RSVDB3 = 8'hb3, 
            FLIT_CMD_RSVDB4 = 8'hb4, FLIT_CMD_RSVDB5 = 8'hb5, FLIT_CMD_RSVDB6 = 8'hb6, FLIT_CMD_RSVDB7 = 8'hb7, FLIT_CMD_RSVDB8 = 8'hb8, FLIT_CMD_RSVDB9 = 8'hb9, FLIT_CMD_RSVDBA = 8'hba, FLIT_CMD_RSVDBB = 8'hbb, FLIT_CMD_RSVDBC = 8'hbc, FLIT_CMD_RSVDBD = 8'hbd, FLIT_CMD_RSVDBE = 8'hbe, FLIT_CMD_RSVDBF = 8'hbf, FLIT_CMD_RSVDC0 = 8'hc0, FLIT_CMD_RSVDC1 = 8'hc1, FLIT_CMD_RSVDC2 = 8'hc2, 
            FLIT_CMD_RSVDC3 = 8'hc3, FLIT_CMD_RSVDC4 = 8'hc4, FLIT_CMD_RSVDC5 = 8'hc5, FLIT_CMD_RSVDC6 = 8'hc6, FLIT_CMD_RSVDC7 = 8'hc7, FLIT_CMD_RSVDC8 = 8'hc8, FLIT_CMD_RSVDC9 = 8'hc9, FLIT_CMD_RSVDCA = 8'hca, FLIT_CMD_RSVDCB = 8'hcb, FLIT_CMD_RSVDCC = 8'hcc, FLIT_CMD_RSVDCD = 8'hcd, FLIT_CMD_RSVDCE = 8'hce, FLIT_CMD_RSVDCF = 8'hcf, FLIT_CMD_RSVDD0 = 8'hd0, FLIT_CMD_RSVDD1 = 8'hd1, 
            FLIT_CMD_RSVDD2 = 8'hd2, FLIT_CMD_RSVDD3 = 8'hd3, FLIT_CMD_RSVDD4 = 8'hd4, FLIT_CMD_RSVDD5 = 8'hd5, FLIT_CMD_RSVDD6 = 8'hd6, FLIT_CMD_RSVDD7 = 8'hd7, FLIT_CMD_RSVDD8 = 8'hd8, FLIT_CMD_RSVDD9 = 8'hd9, FLIT_CMD_RSVDDA = 8'hda, FLIT_CMD_RSVDDB = 8'hdb, FLIT_CMD_RSVDDC = 8'hdc, FLIT_CMD_RSVDDD = 8'hdd, FLIT_CMD_RSVDDE = 8'hde, FLIT_CMD_RSVDDF = 8'hdf, FLIT_CMD_RSVDE0 = 8'he0, 
            FLIT_CMD_RSVDE1 = 8'he1, FLIT_CMD_RSVDE2 = 8'he2, FLIT_CMD_RSVDE3 = 8'he3, FLIT_CMD_RSVDE4 = 8'he4, FLIT_CMD_RSVDE5 = 8'he5, FLIT_CMD_RSVDE6 = 8'he6, FLIT_CMD_RSVDE7 = 8'he7, FLIT_CMD_RSVDE8 = 8'he8, FLIT_CMD_RSVDE9 = 8'he9, FLIT_CMD_RSVDEA = 8'hea, FLIT_CMD_RSVDEB = 8'heb, FLIT_CMD_RSVDEC = 8'hec, FLIT_CMD_RSVDED = 8'hed, FLIT_CMD_RSVDEE = 8'hee, FLIT_CMD_RSVDEF = 8'hef, 
            FLIT_CMD_RSVDF0 = 8'hf0, FLIT_CMD_RSVDF1 = 8'hf1, FLIT_CMD_RSVDF2 = 8'hf2, FLIT_CMD_RSVDF3 = 8'hf3, FLIT_CMD_RSVDF4 = 8'hf4, FLIT_CMD_RSVDF5 = 8'hf5, FLIT_CMD_RSVDF6 = 8'hf6, FLIT_CMD_RSVDF7 = 8'hf7, FLIT_CMD_RSVDF8 = 8'hf8, FLIT_CMD_RSVDF9 = 8'hf9, FLIT_CMD_RSVDFA = 8'hfa, FLIT_CMD_RSVDFB = 8'hfb, FLIT_CMD_RSVDFC = 8'hfc, FLIT_CMD_RSVDFD = 8'hfd, FLIT_CMD_RSVDFE = 8'hfe, 
            FLIT_CMD_RSVDFF = 8'hff} hqm_sfi_flit_cmd_t ; 
    typedef enum logic [6:0] { PCIE_CMD_MRD32 = 7'h00, PCIE_CMD_MRDLK32 = 7'h01, PCIE_CMD_IORD = 7'h02, PCIE_CMD_RSVD03 = 7'h03, PCIE_CMD_CFGRD0 = 7'h04, PCIE_CMD_CFGRD1 = 7'h05, PCIE_CMD_RSVD06 = 7'h06, PCIE_CMD_LTMRD32 = 7'h07, PCIE_CMD_RSVD08 = 7'h08, PCIE_CMD_RSVD09 = 7'h09, PCIE_CMD_CPL = 7'h0a, PCIE_CMD_CPLLK = 7'h0b, PCIE_CMD_RSVD0C = 7'h0c, PCIE_CMD_RSVD0D = 7'h0d, PCIE_CMD_RSVD0E = 7'h0e, 
            PCIE_CMD_RSVD0F = 7'h0f, PCIE_CMD_RSVD10 = 7'h10, PCIE_CMD_RSVD11 = 7'h11, PCIE_CMD_RSVD12 = 7'h12, PCIE_CMD_RSVD13 = 7'h13, PCIE_CMD_RSVD14 = 7'h14, PCIE_CMD_RSVD15 = 7'h15, PCIE_CMD_RSVD16 = 7'h16, PCIE_CMD_RSVD17 = 7'h17, PCIE_CMD_RSVD18 = 7'h18, PCIE_CMD_RSVD19 = 7'h19, PCIE_CMD_RSVD1A = 7'h1a, PCIE_CMD_RSVD1B = 7'h1b, PCIE_CMD_RSVD1C = 7'h1c, PCIE_CMD_RSVD1D = 7'h1d, 
            PCIE_CMD_RSVD1E = 7'h1e, PCIE_CMD_RSVD1F = 7'h1f, PCIE_CMD_MRD64 = 7'h20, PCIE_CMD_MRDLK64 = 7'h21, PCIE_CMD_RSVD22 = 7'h22, PCIE_CMD_RSVD23 = 7'h23, PCIE_CMD_RSVD24 = 7'h24, PCIE_CMD_RSVD25 = 7'h25, PCIE_CMD_RSVD26 = 7'h26, PCIE_CMD_LTMRD64 = 7'h27, PCIE_CMD_RSVD28 = 7'h28, PCIE_CMD_RSVD29 = 7'h29, PCIE_CMD_RSVD2A = 7'h2a, PCIE_CMD_RSVD2B = 7'h2b, PCIE_CMD_RSVD2C = 7'h2c, 
            PCIE_CMD_RSVD2D = 7'h2d, PCIE_CMD_RSVD2E = 7'h2e, PCIE_CMD_RSVD2F = 7'h2f, PCIE_CMD_MSG0 = 7'h30, PCIE_CMD_MSG1 = 7'h31, PCIE_CMD_MSG2 = 7'h32, PCIE_CMD_MSG3 = 7'h33, PCIE_CMD_MSG4 = 7'h34, PCIE_CMD_MSG5 = 7'h35, PCIE_CMD_MSG6 = 7'h36, PCIE_CMD_MSG7 = 7'h37, PCIE_CMD_RSVD38 = 7'h38, PCIE_CMD_RSVD39 = 7'h39, PCIE_CMD_RSVD3A = 7'h3a, PCIE_CMD_RSVD3B = 7'h3b, 
            PCIE_CMD_RSVD3C = 7'h3c, PCIE_CMD_RSVD3D = 7'h3d, PCIE_CMD_RSVD3E = 7'h3e, PCIE_CMD_RSVD3F = 7'h3f, PCIE_CMD_MWR32 = 7'h40, PCIE_CMD_RSVD41 = 7'h41, PCIE_CMD_IOWR = 7'h42, PCIE_CMD_LTMWR32 = 7'h43, PCIE_CMD_CFGWR0 = 7'h44, PCIE_CMD_CFGWR1 = 7'h45, PCIE_CMD_RSVD46 = 7'h46, PCIE_CMD_RSVD47 = 7'h47, PCIE_CMD_RSVD48 = 7'h48, PCIE_CMD_RSVD49 = 7'h49, PCIE_CMD_CPLD = 7'h4a, 
            PCIE_CMD_CPLDLK = 7'h4b, PCIE_CMD_FETCHADD32 = 7'h4c, PCIE_CMD_SWAP32 = 7'h4d, PCIE_CMD_CAS32 = 7'h4e, PCIE_CMD_RSVD4F = 7'h4f, PCIE_CMD_RSVD50 = 7'h50, PCIE_CMD_RSVD51 = 7'h51, PCIE_CMD_RSVD52 = 7'h52, PCIE_CMD_RSVD53 = 7'h53, PCIE_CMD_RSVD54 = 7'h54, PCIE_CMD_RSVD55 = 7'h55, PCIE_CMD_RSVD56 = 7'h56, PCIE_CMD_RSVD57 = 7'h57, PCIE_CMD_RSVD58 = 7'h58, PCIE_CMD_RSVD59 = 7'h59, 
            PCIE_CMD_RSVD5A = 7'h5a, PCIE_CMD_NPMWR32 = 7'h5b, PCIE_CMD_RSVD5C = 7'h5c, PCIE_CMD_RSVD5D = 7'h5d, PCIE_CMD_RSVD5E = 7'h5e, PCIE_CMD_RSVD5F = 7'h5f, PCIE_CMD_MWR64 = 7'h60, PCIE_CMD_RSVD61 = 7'h61, PCIE_CMD_RSVD62 = 7'h62, PCIE_CMD_LTMWR64 = 7'h63, PCIE_CMD_RSVD64 = 7'h64, PCIE_CMD_RSVD65 = 7'h65, PCIE_CMD_RSVD66 = 7'h66, PCIE_CMD_RSVD67 = 7'h67, PCIE_CMD_RSVD68 = 7'h68, 
            PCIE_CMD_RSVD69 = 7'h69, PCIE_CMD_RSVD6A = 7'h6a, PCIE_CMD_RSVD6B = 7'h6b, PCIE_CMD_FETCHADD64 = 7'h6c, PCIE_CMD_SWAP64 = 7'h6d, PCIE_CMD_CAS64 = 7'h6e, PCIE_CMD_RSVD6F = 7'h6f, PCIE_CMD_MSGD0 = 7'h70, PCIE_CMD_MSGD1 = 7'h71, PCIE_CMD_MSGD2 = 7'h72, PCIE_CMD_MSGD3 = 7'h73, PCIE_CMD_MSGD4 = 7'h74, PCIE_CMD_MSGD5 = 7'h75, PCIE_CMD_MSGD6 = 7'h76, PCIE_CMD_MSGD7 = 7'h77, 
            PCIE_CMD_RSVD78 = 7'h78, PCIE_CMD_RSVD79 = 7'h79, PCIE_CMD_RSVD7A = 7'h7a, PCIE_CMD_NPMWR64 = 7'h7b, PCIE_CMD_RSVD7C = 7'h7c, PCIE_CMD_RSVD7D = 7'h7d, PCIE_CMD_RSVD7E = 7'h7e, PCIE_CMD_RSVD7F = 7'h7f} hqm_sfi_pcie_cmd_t ; 
    typedef enum logic [1:0] { fc_posted = 2'b00, fc_nonposted = 2'b01, fc_completion = 2'b10, fc_rsvd3 = 2'b11} hqm_sfi_fc_id_t ; 
    typedef enum logic [1:0] { at_untranslated = 2'b00, at_translation_req = 2'b01, at_translated = 2'b10, at_rsvd3 = 2'b11} hqm_sfi_at_t ; 
    typedef enum logic [2:0] { cpl_status_success = 3'b000, cpl_status_ur = 3'b001, cpl_status_rsvd2 = 3'b010, cpl_status_rsvd3 = 3'b011, cpl_status_abort = 3'b100, cpl_status_rsvd5 = 3'b101, cpl_status_rsvd6 = 3'b110, cpl_status_rsvd7 = 3'b111} hqm_sfi_cpl_status_t ; 
    typedef enum logic [4:0] { ohc_none = 5'b00000, ohc_noe_a = 5'b00001, ohc_noe_b = 5'b00010, ohc_noe_ab = 5'b00011, ohc_noe_c = 5'b00100, ohc_noe_ac = 5'b00101, ohc_noe_bc = 5'b00110, ohc_noe_abc = 5'b00111, ohc_e1_none = 5'b01000, ohc_e1_a = 5'b01001, ohc_e1_b = 5'b01010, ohc_e1_ab = 5'b01011, ohc_e1_c = 5'b01100, ohc_e1_ac = 5'b01101, ohc_e1_bc = 5'b01110, 
            ohc_e1_abc = 5'b01111, ohc_e2_none = 5'b10000, ohc_e2_a = 5'b10001, ohc_e2_b = 5'b10010, ohc_e2_ab = 5'b10011, ohc_e2_c = 5'b10100, ohc_e2_ac = 5'b10101, ohc_e2_bc = 5'b10110, ohc_e2_abc = 5'b10111, ohc_e4_none = 5'b11000, ohc_e4_a = 5'b11001, ohc_e4_b = 5'b11010, ohc_e4_ab = 5'b11011, ohc_e4_c = 5'b11100, ohc_e4_ac = 5'b11101, 
            ohc_e4_bc = 5'b11110, ohc_e4_abc = 5'b11111} hqm_sfi_ohc_t ; 
    typedef enum logic [2:0] { ts_none = 3'b000, ts_ecrc = 3'b001, ts_rsvd2 = 3'b010, ts_rsvd3 = 3'b011, ts_rsvd4 = 3'b100, ts_mac = 3'b101, ts_mac_pcrc = 3'b110, ts_rsvd7 = 3'b111} hqm_sfi_ts_t ; 
    //   3:  0 First Byte Enables
    typedef struct packed {
        logic nw ; 
        logic //  31     Read/Not Write access
            pv ; 
        logic //  30     PASID Valid
            pmr ; 
        logic //  29     Privileged Mode Required
            er ; 
        logic [19:0] //  28     Execute Required
            pasid ; 
        logic [3:0] //  27:  8 Process Address Space ID
            lbe ; 
        logic [3:0] //   7:  4 Last  Byte Enables
            fbe ; 
    } hqm_sfi_ohc_a1_t ; 
    //   3:  0 First Byte enables
    typedef struct packed {
        logic [23:0] rsvd31_8 ; 
        logic [3:0] //  31:  8
            lbe ; 
        logic [3:0] //   7:  4 Last  Byte enables
            fbe ; 
    } hqm_sfi_ohc_a2_t ; 
    //   3:  0 First Byte Enables
    typedef struct packed {
        logic [7:0] dst_sgmt ; 
        logic [7:0] //  31: 24 Destination Segment
            rsvd23_16 ; 
        logic //  23: 16
            dsv ; 
        logic [6:0] //  15     Destination Segment Valid
            rsvd14_8 ; 
        logic [3:0] //  14:  8
            lbe ; 
        logic [3:0] //   7:  4 Last  Byte Enables
            fbe ; 
    } hqm_sfi_ohc_a3_t ; 
    //   7:  0 Process Address Space ID  7: 0
    typedef struct packed {
        logic [7:0] dst_sgmt ; 
        logic [7:0] //  31: 24 Destination Segment
            pasid15_8 ; 
        logic //  23: 16 Process Address Space ID 15: 8
            dsv ; 
        logic //  15     Destination Segment Valid
            pv ; 
        logic //  14     PASID Valid
            pmr ; 
        logic //  13     Privileged Mode Required
            rsvd12 ; 
        logic [3:0] //  12
            pasid19_16 ; 
        logic [7:0] //  11:  8 Process Address Space ID 19:16
            pasid7_0 ; 
    } hqm_sfi_ohc_a4_t ; 
    //   2:  0 Completion status
    typedef struct packed {
        logic [7:0] dst_sgmnt ; 
        logic [7:0] //  31: 24 Destination Segment
            cpl_sgmnt ; 
        logic //  23: 16 Completer   Segment
            dsv ; 
        logic [9:0] //  15     Destination Segment Valid
            rsvd14_5 ; 
        logic [1:0] //  14:  5
            la1_0 ; 
        hqm_sfi_cpl_status_t //   4:  3 Lower Address
            cpl_status ; 
    } hqm_sfi_ohc_a5_t ; 
    // OHC-A1
    typedef union packed {
        hqm_sfi_ohc_a5_t a5 ; 
        hqm_sfi_ohc_a4_t // OHC-A5
            a4 ; 
        hqm_sfi_ohc_a3_t // OHC-A4
            a3 ; 
        hqm_sfi_ohc_a2_t // OHC-A3
            a2 ; 
        hqm_sfi_ohc_a1_t // OHC-A2
            a1 ; 
    } hqm_sfi_ohc_dw_t ; 
    //   7:  0
    typedef struct packed {
        logic [7:0] prefix_type ; 
        logic //  31: 24
            bcm ; 
        logic [3:0] //  23     Byte Count Modified
            rs ; 
        logic //  22: 19 Root Space
            ee ; 
        logic //  18
            n ; 
        logic //  17
            c ; 
        logic [7:0] //  16
            sai ; 
        logic [7:0] //  15:  8 Source Access Identifier
            srcid ; 
    } hqm_sfi_iosf_prefix0_t ; 
    //  31:  0
    typedef struct packed {
        hqm_sfi_ohc_dw_t // DW7
            ohc_dw3 ; 
        hqm_sfi_ohc_dw_t // 255:224 Orthogonal Header Content
            // DW6
            ohc_dw2 ; 
        hqm_sfi_ohc_dw_t // 223:192 Orthogonal Header Content
            // DW5
            ohc_dw1 ; 
        hqm_sfi_ohc_dw_t // 191:160 Orthogonal Header Content
            // DW4
            ohc_dw0 ; 
        logic [31:2] // 159:128 Orthogonal Header Content
            // DW3
            address31_2 ; 
        hqm_sfi_at_t // 159: 98 Address 63:2
            at ; 
        logic [15:0] //  97: 96 Address Translation
            // DW2
            reqid ; 
        logic //  95: 80 Requestor ID
            ep ; 
        logic //  79     Poisoned
            rsvd78 ; 
        logic [13:0] //  78
            tag ; 
        hqm_sfi_flit_cmd_t //  77: 64 Tag
            // DW1
            ttype ; 
        logic [2:0] //  63: 56 Transaction Type
            tc2_0 ; 
        hqm_sfi_ohc_t //  55: 53 Traffic Class 2:0
            ohc ; 
        hqm_sfi_ts_t //  52: 48 Orthogonal Header Content Type
            ts ; 
        logic [2:0] //  47: 45 Trailer Size
            attr ; 
        logic [9:0] //  44: 42 Attributes (IDO, RO, NS)
            len ; 
        hqm_sfi_iosf_prefix0_t //  41: 32
            // DW0
            pf0 ; 
    } hqm_sfi_flit_mem32_hdr_t ; 
    //  31:  0
    typedef struct packed {
        hqm_sfi_ohc_dw_t // DW7
            ohc_dw2 ; 
        hqm_sfi_ohc_dw_t // 255:224 Orthogonal Header Content
            // DW6
            ohc_dw1 ; 
        hqm_sfi_ohc_dw_t // 223:192 Orthogonal Header Content
            // DW5
            ohc_dw0 ; 
        logic [31:2] // 191:160 Orthogonal Header Content
            // DW4
            address31_2 ; 
        hqm_sfi_at_t // 159:130 Address 31:2
            at ; 
        logic [31:0] // 129:128 Address Translation
            // DW4
            address63_32 ; 
        logic [15:0] // 127: 96 Address 63:32
            // DW2
            reqid ; 
        logic //  95: 80 Requestor ID
            ep ; 
        logic //  79     Poisoned
            rsvd78 ; 
        logic [13:0] //  78
            tag ; 
        hqm_sfi_flit_cmd_t //  77: 64 Tag
            // DW1
            ttype ; 
        logic [2:0] //  63: 56 Transaction Type
            tc2_0 ; 
        hqm_sfi_ohc_t //  55: 53 Traffic Class 2:0
            ohc ; 
        hqm_sfi_ts_t //  52: 48 Orthogonal Header Content Type
            ts ; 
        logic [2:0] //  47: 45 Trailer Size
            attr ; 
        logic [9:0] //  44: 42 Attributes (IDO, RO, NS)
            len ; 
        hqm_sfi_iosf_prefix0_t //  41: 32
            // DW0
            pf0 ; 
    } hqm_sfi_flit_mem64_hdr_t ; 
    //  31:  0
    typedef struct packed {
        hqm_sfi_ohc_dw_t // DW7
            ohc_dw3 ; 
        hqm_sfi_ohc_dw_t // 255:224 Orthogonal Header Content
            // DW6
            ohc_dw2 ; 
        hqm_sfi_ohc_dw_t // 223:192 Orthogonal Header Content
            // DW5
            ohc_dw1 ; 
        hqm_sfi_ohc_dw_t // 191:160 Orthogonal Header Content
            // DW4 (OHCA3 is required here)
            ohc_dw0 ; 
        logic [15:0] // 159:128 Orthogonal Header Content
            // DW3
            bdf ; 
        logic [3:0] // 127:112 Bus/Device/Function
            rsvd111_108 ; 
        logic [9:0] // 111:108
            regnum ; 
        logic [1:0] // 107: 98 Register number
            rsvd97_96 ; 
        logic [15:0] //  97: 96
            // DW2
            reqid ; 
        logic //  95: 80 Requestor ID
            ep ; 
        logic //  79     Poisoned
            rsvd78 ; 
        logic [13:0] //  78
            tag ; 
        hqm_sfi_flit_cmd_t //  77: 64 Tag
            // DW1
            ttype ; 
        logic [2:0] //  63: 56 Transaction Type
            tc2_0 ; 
        hqm_sfi_ohc_t //  55: 53 Traffic Class 2:0
            ohc ; 
        hqm_sfi_ts_t //  52: 48 Orthogonal Header Content Type
            ts ; 
        logic [2:0] //  47: 45 Trailer Size
            attr ; 
        logic [9:0] //  44: 42 Attributes (IDO, RO, NS)
            len ; 
        hqm_sfi_iosf_prefix0_t //  41: 32
            // DW0
            pf0 ; 
    } hqm_sfi_flit_cfg_hdr_t ; 
    //  31:  0
    typedef struct packed {
        hqm_sfi_ohc_dw_t // DW7
            ohc_dw3 ; 
        hqm_sfi_ohc_dw_t // 255:224 Orthogonal Header Content
            // DW6
            ohc_dw2 ; 
        hqm_sfi_ohc_dw_t // 223:192 Orthogonal Header Content
            // DW5
            ohc_dw1 ; 
        hqm_sfi_ohc_dw_t // 191:160 Orthogonal Header Content
            // DW4
            ohc_dw0 ; 
        logic [15:0] // 159:128 Orthogonal Header Content
            // DW3
            bdf ; 
        logic [3:0] // 127:112 Bus/Device/Function
            la5_2 ; 
        logic [11:0] // 111:108 Lower Address 5:2
            bc ; 
        logic [15:0] // 107: 96 Byte Count
            // DW2
            cplid ; 
        logic //  95: 80 Completer ID
            ep ; 
        logic //  79     Poisoned
            la6 ; 
        logic [13:0] //  78     Lower Address 6
            tag ; 
        hqm_sfi_flit_cmd_t //  77: 64 Tag
            // DW1
            ttype ; 
        logic [2:0] //  63: 56 Transaction Type
            tc2_0 ; 
        hqm_sfi_ohc_t //  55: 53 Traffic Class 2:0
            ohc ; 
        hqm_sfi_ts_t //  52: 48 Orthogonal Header Content Type
            ts ; 
        logic [2:0] //  47: 45 Trailer Size
            attr ; 
        logic [9:0] //  44: 42 Attributes (IDO, RO, NS)
            len ; 
        hqm_sfi_iosf_prefix0_t //  41: 32
            // DW0
            pf0 ; 
    } hqm_sfi_flit_cpl_hdr_t ; 
    //  31:  0
    typedef struct packed {
        hqm_sfi_ohc_dw_t // DW7
            ohc_dw2 ; 
        hqm_sfi_ohc_dw_t // 255:224 Orthogonal Header Content
            // DW6
            ohc_dw1 ; 
        hqm_sfi_ohc_dw_t // 223:192 Orthogonal Header Content
            // DW5
            ohc_dw0 ; 
        logic [31:0] // 191:160 Orthogonal Header Content
            // DW4
            rsvd159_128 ; 
        logic [15:0] // 159:128
            // DW3
            bdf ; 
        logic [15:0] // 127:112 Bus/Device/Function
            rsvd111_96 ; 
        logic [15:0] // 111: 96
            // DW2
            reqid ; 
        logic [2:0] //  95: 80 Requestor ID
            rsvd79_77 ; 
        logic [4:0] //  79: 77
            itag ; 
        logic [7:0] //  76: 72 Invalidate Tag
            msg_code ; 
        hqm_sfi_flit_cmd_t //  71: 64 Message Code
            // DW1
            ttype ; 
        logic [2:0] //  63: 56 Transaction Type
            tc2_0 ; 
        hqm_sfi_ohc_t //  55: 53 Traffic Class 2:0
            ohc ; 
        hqm_sfi_ts_t //  52: 48 Orthogonal Header Content Type
            ts ; 
        logic [2:0] //  47: 45 Trailer Size
            attr ; 
        logic [9:0] //  44: 42 Attributes (IDO, RO, NS)
            len ; 
        hqm_sfi_iosf_prefix0_t //  41: 32
            // DW0
            pf0 ; 
    } hqm_sfi_flit_invreq_hdr_t ; 
    //  31:  0
    typedef struct packed {
        hqm_sfi_ohc_dw_t // DW7
            ohc_dw2 ; 
        hqm_sfi_ohc_dw_t // 255:224 Orthogonal Header Content
            // DW6
            ohc_dw1 ; 
        hqm_sfi_ohc_dw_t // 223:192 Orthogonal Header Content
            // DW5
            ohc_dw0 ; 
        logic [31:0] // 191:160 Orthogonal Header Content
            // DW4
            itag_vec ; 
        logic [15:0] // 159:128
            // DW3
            bdf ; 
        logic [12:0] // 127:112 Bus/Device/Function
            rsvd111_99 ; 
        logic [2:0] // 111: 99
            cc ; 
        logic [15:0] //  98: 96
            // DW2
            reqid ; 
        logic [7:0] //  95: 80 Requestor ID
            rsvd79_72 ; 
        logic [7:0] //  79: 72
            msg_code ; 
        hqm_sfi_flit_cmd_t //  71: 64 Message Code
            // DW1
            ttype ; 
        logic [2:0] //  63: 56 Transaction Type
            tc2_0 ; 
        hqm_sfi_ohc_t //  55: 53 Traffic Class 2:0
            ohc ; 
        hqm_sfi_ts_t //  52: 48 Orthogonal Header Content Type
            ts ; 
        logic [2:0] //  47: 45 Trailer Size
            attr ; 
        logic [9:0] //  44: 42 Attributes (IDO, RO, NS)
            len ; 
        hqm_sfi_iosf_prefix0_t //  41: 32
            // DW0
            pf0 ; 
    } hqm_sfi_flit_invrsp_hdr_t ; 
    typedef union packed {
        hqm_sfi_flit_mem32_hdr_t mem32 ; 
        hqm_sfi_flit_mem64_hdr_t mem64 ; 
        hqm_sfi_flit_cfg_hdr_t cfg ; 
        hqm_sfi_flit_cpl_hdr_t cpl ; 
        hqm_sfi_flit_invreq_hdr_t invreq ; 
        hqm_sfi_flit_invrsp_hdr_t invrsp ; 
    } hqm_sfi_flit_header_t ; 
    // Flow class
    typedef struct packed {
        logic parity ; 
        logic has_data ; 
        logic shared_crd ; 
        logic [4:0] vc_id ; 
        logic [3:0] // Virtual channel
            hdr_size ; 
        logic [1:0] // Header size
            rsvd3_2 ; 
        hqm_sfi_fc_id_t fc_id ; 
    } hqm_sfi_hdr_info_t ; 
    // Flow class
    typedef struct packed {
        logic [4:0] vc_id ; 
        logic // Virtual channel
            shared_crd ; 
        hqm_sfi_fc_id_t fc_id ; 
    } hqm_sfi_data_info_t ; 
    // Reciever queues are empty and all credits returned
    typedef struct packed {
        logic rxcon_ack ; 
        logic // Connection acknowledge
            rxdiscon_nack ; 
        logic // Disconnect rejection
            rx_empty ; 
    } hqm_sfi_tx_rxglobal_t ; 
    // Connection request
    typedef struct packed {
        logic txcon_req ; 
    } hqm_sfi_tx_txglobal_t ; 
    // Reciever queues are empty and all credits returned
    typedef struct packed {
        logic rxcon_ack ; 
        logic // Connection acknowledge
            rxdiscon_nack ; 
        logic // Disconnect rejection
            rx_empty ; 
    } hqm_sfi_rx_rxglobal_t ; 
    // Connection request
    typedef struct packed {
        logic txcon_req ; 
    } hqm_sfi_rx_txglobal_t ; 
    // Header
    typedef struct packed {
        logic hdr_valid ; 
        logic // Header is valid
            hdr_early_valid ; 
        hqm_sfi_hdr_info_t // Header early valid indication
            hdr_info_bytes ; 
        hqm_sfi_flit_header_t // Header info
            header ; 
    } hqm_sfi_hdr_t ; 
    // Data payload
    typedef struct packed {
        logic data_valid ; 
        logic // Data is valid
            data_early_valid ; 
        logic // Early valid indication
            data_aux_parity ; 
        logic [(HQM_SFI_RX_DATA_POISON_WIDTH - 1):0] // Data auxillary parity
            data_poison ; 
        logic [(HQM_SFI_RX_DATA_EDB_WIDTH - 1):0] // Data poisoned per DW
            data_edb ; 
        logic // Data bad per DW
            data_start ; 
        logic [(HQM_SFI_RX_DATA_END_WIDTH - 1):0] // Start of data
            data_end ; 
        logic [(HQM_SFI_RX_DATA_PARITY_WIDTH - 1):0] // End   of data
            data_parity ; 
        hqm_sfi_data_info_t // Data parity per 8B
            data_info_byte ; 
        logic [(HQM_SFI_RX_DATA_WIDTH - 1):0] // Data info
            data ; 
    } hqm_sfi_rx_data_t ; 
    // Data payload
    typedef struct packed {
        logic data_valid ; 
        logic // Data is valid
            data_early_valid ; 
        logic // Early valid indication
            data_aux_parity ; 
        logic [(HQM_SFI_TX_DATA_POISON_WIDTH - 1):0] // Data auxillary parity
            data_poison ; 
        logic [(HQM_SFI_TX_DATA_EDB_WIDTH - 1):0] // Data poisoned per DW
            data_edb ; 
        logic // Data bad per DW
            data_start ; 
        logic [(HQM_SFI_TX_DATA_END_WIDTH - 1):0] // Start of data
            data_end ; 
        logic [(HQM_SFI_TX_DATA_PARITY_WIDTH - 1):0] // End   of data
            data_parity ; 
        hqm_sfi_data_info_t // Data parity per 8B
            data_info_byte ; 
        logic [(HQM_SFI_TX_DATA_WIDTH - 1):0] // Data info
            data ; 
    } hqm_sfi_tx_data_t ; 
    typedef enum logic [3:0] { HQM_SFI_TX_STATE_DISCONNECTED = 4'b0001, HQM_SFI_TX_STATE_CONNECTING = 4'b0010, HQM_SFI_TX_STATE_CONNECTED = 4'b0100, HQM_SFI_TX_STATE_DISCONNECTING = 4'b1000} hqm_sfi_tx_state_t ; 
    localparam HQM_SFI_TX_STATE_DISCONNECTED_BIT = 0 ; 
    localparam HQM_SFI_TX_STATE_CONNECTING_BIT = 1 ; 
    localparam HQM_SFI_TX_STATE_CONNECTED_BIT = 2 ; 
    localparam HQM_SFI_TX_STATE_DISCONNECTING_BIT = 3 ; 
    typedef enum logic [2:0] { HQM_SFI_RX_STATE_DISCONNECTED = 3'b001, HQM_SFI_RX_STATE_CONNECTED = 3'b010, HQM_SFI_RX_STATE_DENY = 3'b100} hqm_sfi_rx_state_t ; 
    localparam HQM_SFI_RX_STATE_DISCONNECTED_BIT = 0 ; 
    localparam HQM_SFI_RX_STATE_CONNECTED_BIT = 1 ; 
    localparam HQM_SFI_RX_STATE_DENY_BIT = 2 ; 
    // The only requirement here is that the fmt/type/len be in the same places (126:120) as
    // the other pcie header types, so the command decoding works.
    //  31:  0
    typedef struct packed {
        logic rsvd127 ; 
        logic [1:0] // 127
            fmt ; 
        logic [4:0] // 126:125
            ttype ; 
        logic // 124:120
            bcm ; 
        logic [6:0] // 119
            lowaddr ; 
        logic [3:0] // 118:112
            tc ; 
        logic // 111:108
            attr2 ; 
        logic // 107
            rsvd106 ; 
        logic [9:0] // 106
            len ; 
        logic // 105: 96
            ep ; 
        logic [2:0] //  95
            cplstat ; 
        logic [11:0] //  94: 92
            bytecnt ; 
        logic [15:0] //  91: 80
            cplid ; 
        logic [15:0] //  79: 64
            rqid ; 
        logic [1:0] //  63: 48
            attr ; 
        logic [13:0] //  47: 46
            tag ; 
        logic [31:0] //  45: 32
            rsvd31_0 ; 
    } hqm_sficpl_hdr_t ; 
endpackage


