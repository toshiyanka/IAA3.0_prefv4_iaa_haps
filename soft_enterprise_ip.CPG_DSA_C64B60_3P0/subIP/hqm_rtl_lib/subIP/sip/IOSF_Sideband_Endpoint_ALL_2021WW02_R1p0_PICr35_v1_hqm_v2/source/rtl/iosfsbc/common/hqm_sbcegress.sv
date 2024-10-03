//
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2021 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
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
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2021WW02_PICr35
//
//  Module sbcegress : The egress port for all sideband IP collateral
//                     containing credit counters and output flops.  It also
//                     optionally contains store/forward flops for payload
//                     width reduction, but is only used in the synchronous
//                     router.  This is required since the flit is transferred
//                     in a single cycle across the shared internal datapath.
//                     For the endpoint and asynchronous router instantiations,
//                     there are no store/forward flops, only the output flops.
//                     The flit remains asserted over multiple cycles until
//                     the egress port can sequence through all sub-flits
//                     equal to the flit width of the sideband payload.
//
//------------------------------------------------------------------------------

// 52523 : Repeated (local) parameter: ... (e.g. MAXBIT). Already defined in ....
// lintra push -52523, -60024b, -60024a, -70036_simple

module hqm_sbcegress
#(
  parameter EXTMAXPLDBIT                 =  7, // External interface flit bit width
            INTMAXPLDBIT                 = 31, // Internal interface flit bit width
            CUP2PUT1CYC                  =  0,
            SYNCROUTER                   =  0, // Synchronous Router=1 / Asynchronous Router=0
            ENDPOINTONLY                 =  0, // Endpoint=1, Fabric=0
            SB_PARITY_REQUIRED           =  0,
            EXPECTED_COMPLETIONS_COUNTER =  0, // SBC-PCN-007 - Expected completion counter components installed when 1
            GNR_HIER_FABRIC              =  0, // GNR Hierarchical Fabric
            GNR_GLOBAL_SEGMENT           =  0,
            GNR_HIER_BRIDGE_EN           =  0,
            GNR_16BIT_EP                 =  0,
            GNR_8BIT_EP                  =  0,
            GNR_RTR_SEGMENT_ID           = 8'd200,
            GNR_MIN_SEGMENT_ID           = 8'd128,
            HIER_BRIDGE                  =  0, // set to 1 to instantiate hierachical bridge logic
            HIER_BRIDGE_PID              = 8'd0, // PortID associated with the transparent bridge
            HIER_BRIDGE_STRAP            =  0, // Enable hier bridge select strap
            MIN_GLOBAL_PID               = 8'd254, // Min global PID for transparent bridge configs
            GLOBAL_EP                    =  0, // EP in HIER mode
            GLOBAL_EP_IS_STRAP           =  0  // EP in HIER mode
)(
  input  logic                  side_clk,              // Sideband Clock
  input  logic                  side_rst_b,            // Sideband Reset
  input  logic                  ism_active,            // ISM is in the active state
  output logic                  idle_egress,           // Egress port is idle
  output logic                  idle_egress_full,      // HSD 4258336 - Egress prot is idle, modified to fix credit update turning on agent IP.
  input  logic                  credit_reinit,         // Inidication of credit reinitialization
  input  logic                  fabric_ism_creditinit, // lintra s-0527, s-70036 "SBC-PCN-001 - ECN 290 - Fabric ISM Creditinit in the case of power gating, not used otherwise"
  output logic                  pwrgt_egress,          // SBC-PCN-001 - ECN 290 - Egress Port Advertises when ready to power gate.
  output logic                  egress_comp_detect,    // SBC-PCN-007 - Egress completion detected when 1
  
  // Interface to the IOSF Sideband Channel
  input  logic                  mpccup,      // Indicator of pc credits returned from the ingress queue
  input  logic                  mnpcup,      // Indicator of np credits returned from the ingress queue
  input  logic                  nd_mpccup,   // Sideband Channel Interface - flopped version if PIPEINPS =1  
  input  logic                  nd_mnpcup,   // Sideband Channel Interface - flopped version if PIPEINPS =1  
  output logic                  mpcput,      // Indicate when putting PC data out to the interface
  output logic                  mnpput,      // Indicate when putting NP data out to the interface
  output logic                  meom,        // Indicating the final flit of the message
  output logic [EXTMAXPLDBIT:0] mpayload,    // Data payload that is being sent out of the interface
  output logic                  mparity,     // Data payload that is being sent out of the interface

  // Interface to egress arbiter
  output logic                  enpstall,
  output logic                  epctrdy,
  output logic                  enptrdy,
  input  logic                  epcirdy,
  input  logic                  enpirdy,

  // Interface to the datapath
  input  logic                  eomin,
  input  logic                  parityin, // lintra s-70036, s-0527
  input  logic [INTMAXPLDBIT:0] datain,

  // parity interface
  input  logic                  cfg_parityckdef, //lintra s-0527, s-70036, s-0527

  input  logic                  cfg_hierbridgeen,       // lintra s-0527, s-70036 Used only for some ports on MI configs
  input  logic            [7:0] cfg_hierbridgepid,      // lintra s-0527, s-70036 Used only for some ports on MI configs
  input  logic                  global_ep_strap, // lintra s-0527, s-70036 Used only in transparent bridge EP
  // Debug signals
  output logic            [5:0] dbgbus
); 

// lintra push -60020, -60088, -80095, -68001

`include "hqm_sbcglobal_params.vm"

localparam RATIO = (INTMAXPLDBIT==31) & (EXTMAXPLDBIT==7)
                   ? 4 : (INTMAXPLDBIT==EXTMAXPLDBIT) ? 1 : 2;
localparam MAXENTRY = (SYNCROUTER==0) | (RATIO==1) ? 0 : (RATIO==4) ? 6 : 2;
localparam PC1 = MAXENTRY==6 ? 1 : MAXENTRY==2 ? 1 : 0;
localparam PC2 = MAXENTRY==6 ? 2 : MAXENTRY==2 ? 1 : 0;
localparam PC3 = MAXENTRY==6 ? 3 : MAXENTRY==2 ? 1 : 0;
localparam NP1 = MAXENTRY==6 ? 4 : MAXENTRY==2 ? 2 : 0;
localparam NP2 = MAXENTRY==6 ? 5 : MAXENTRY==2 ? 2 : 0;
localparam NP3 = MAXENTRY==6 ? 6 : MAXENTRY==2 ? 2 : 0;
localparam NPEOM  = MAXENTRY==0 ? 0 : 2;
localparam PCEOM  = MAXENTRY==0 ? 0 : 1;
localparam MAXBIT = RATIO==4 ? 1 : 0;
localparam XFR1 = RATIO==1 ? 0 : RATIO==4 ?  8 : INTMAXPLDBIT == 31 ? 16 : 8;
localparam XFR2 = RATIO==1 ? 0 : RATIO==4 ? 16 :  0;
localparam XFR3 = RATIO==1 ? 0 : RATIO==4 ? 24 :  0;
localparam XFRHBMAX = INTMAXPLDBIT==31 ? 2 : INTMAXPLDBIT==15 ? 3 : 8;
localparam XFRHBMIN = INTMAXPLDBIT==7 ? 3 : 0;
localparam XFRHBBIT = INTMAXPLDBIT==31 ? 1 : INTMAXPLDBIT==15 ? 1 : 4;
localparam XFRHBMAXGNR = INTMAXPLDBIT==31 ? 2 : INTMAXPLDBIT==15 ? 3 : 7;
localparam XFRHBBITGNR = INTMAXPLDBIT==31 ? 1 : INTMAXPLDBIT==15 ? 1 : 3;
localparam XFRHBMAXGNRF = INTMAXPLDBIT==31 ? 3 : INTMAXPLDBIT==15 ? 5 : 10;
localparam XFRHBBITGNRF = INTMAXPLDBIT==31 ? 1 : INTMAXPLDBIT==15 ? 2 : 3;
localparam OPCBIT = (INTMAXPLDBIT>15) ? 16 :
                                         0 ;
localparam FLITTRACKERMAXBIT = (INTMAXPLDBIT==31) ? 0 :
                               (INTMAXPLDBIT==15) ? 1 :
                                                    3 ;
localparam logic [FLITTRACKERMAXBIT:0] OPCFLITTRACKER_RSTVAL =
                                          (INTMAXPLDBIT==31) ? 1 : // 1'b1
                                          (INTMAXPLDBIT==15) ? 2 : // 2'b10
                                                               4 ; // 4'b0100
localparam logic [FLITTRACKERMAXBIT:0] MIPFLITTRACKER_RSTVAL =
                                          (INTMAXPLDBIT==31) ? 1 : // 1'b1
                                          (INTMAXPLDBIT==15) ? 2 : // 2'b10
                                                               8 ; // 4'b1000
localparam HIER_BRIDGE_GEN = HIER_BRIDGE_STRAP==1 ? 1 : HIER_BRIDGE;

localparam SSF_GMCAST_RANGE_MIN = 8'd128;
localparam SSF_GMCAST_RANGE_MAX = 8'd146;
localparam SSF_LMCAST_RANGE_MIN = 8'd111;
localparam SSF_LMCAST_RANGE_MAX = 8'd127;

                          
  logic [SBCMAXCREDITCOUNTBIT:0]     pccredits;  // Current number of credits
  logic [SBCMAXCREDITCOUNTBIT:0]     npcredits;

  logic                              pcstall;            // Egress stall due to insufficient credits or because
  logic                              npstall;            // the clock gating ISM is not in the active state
  logic                              pcput;
  logic                              npput;
  logic                              nxtpcput;           // Pre-flopped sideband put signals to be sent during
  logic                              nxtnpput;           // the next cycle
  logic                              npsel;              // Put priority (NP=1 / PC=0)
  logic [MAXBIT  :0]                 pcxfr; // Current transfer within the 4 byte flit.  Only
  logic [MAXBIT  :0]                 npxfr; // used if sideband width is less than 4 bytes.
  logic [NPEOM   :0]                 outeom;
  logic 				                   outparity;
  logic [MAXENTRY:0][EXTMAXPLDBIT:0] outdata;
  logic                              pcbusy;
  logic                              npbusy;
  logic                              pclast;
  logic                              nplast;
  
  logic                     in_pc_parity_err, in_pc_parity_err_f; // lintra s-70036, s-0531 used only when there is width crossing
  logic                     in_np_parity_err, in_np_parity_err_f; // lintra s-70036, s-0531 used only when there is width crossing

  logic [INTMAXPLDBIT:0]             data, datahh; // lintra s-70036, s-0531 not used when parity not enabled
  logic                              eom, eomhh;   // lintra s-70036, s-0531 not used when parity not enabled
  logic                              parity, parityhh;  // lintra s-70036, s-0531 not used when parity not enabled
  logic [INTMAXPLDBIT+2:0]           hhdin;        // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
  logic [INTMAXPLDBIT+2:0]           pchhdin_ff;   // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
  logic [INTMAXPLDBIT+2:0]           nphhdin_ff;   // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
  logic [INTMAXPLDBIT+2:0]           pchhdout;     // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
  logic [INTMAXPLDBIT+2:0]           nphhdout;     // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
  logic              pcmsgiphb, npmsgiphb;         // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
  logic [XFRHBBIT:0] pcxfrhb, npxfrhb;             // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
  logic              pcputhh, npputhh;             // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
  logic              pcdouthhsel, npdouthhsel;     // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
  logic              pcstallh, npstallh;           // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
  logic              pcbusyh, npbusyh;             // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
  logic              pcputgnr, npputgnr;           // lintra s-70036, s-0531 used only when GNR_HIER_FABRIC is set

  logic hier_bridge_en; // lintra s-70036 used only when HIER_BRIDGE is set
  logic [7:0] hier_bridge_id; // lintra s-70036 used only when HIER_BRIDGE is set

  logic mpcput_visa, mnpput_visa;
  logic update_pcput, update_npput;
  logic epctrdygnr, enptrdygnr; // lintra s-70036 used only when GNR_HIER_FABRIC is set
  logic idlegnr; // lintra s-70036 used only when GNR_HIER_FABRIC is set
  logic pcxfrdbg, npxfrdbg, pccreditsdbg, npcreditsdbg;


generate 
   if ((GNR_HIER_FABRIC == 1) && (GNR_GLOBAL_SEGMENT == 0) &&  
       ((GNR_16BIT_EP == 1) || (GNR_HIER_BRIDGE_EN == 1)) && ((INTMAXPLDBIT == 31) || (INTMAXPLDBIT == 15) || (INTMAXPLDBIT == 7))) begin : gen_gnrf

      logic pcmsgipgnr, npmsgipgnr;
      logic [XFRHBBITGNRF:0] pcxfrgnr, npxfrgnr;
      logic [INTMAXPLDBIT+1:0] gnrdin;
      logic [INTMAXPLDBIT+1:0] pcdatain_ff1, npdatain_ff1;
      logic parerr, pcparerr_ff1, npparerr_ff1;
      logic [INTMAXPLDBIT:0] pcgnr_data, npgnr_data;
      logic pcgnr_eom, npgnr_eom;
      logic pcgnr_par, npgnr_par;
      logic [7:0] pcdstfield, pcsrcfield; 
      logic [7:0] npdstfield, npsrcfield; 
      logic [7:0] pcgnr_srcid_ff, npgnr_srcid_ff;
      logic [7:0] pcgnr_dstseg_ff, npgnr_dstseg_ff;
      logic [7:0] gnr_segment_id;
      logic pcputq, pcputgnrq;
      logic npputq, npputgnrq;

      always_comb gnr_segment_id = GNR_RTR_SEGMENT_ID;
      always_comb gnrdin = {eomin, datain};
      always_comb parerr = (parityin != ^{eomin,datain});

      always_comb pcputq = ((SYNCROUTER==0) && (INTMAXPLDBIT != 7)) ? (epctrdy & pcput) : pcput;
      always_comb pcputgnrq = ((SYNCROUTER==0) && (INTMAXPLDBIT != 7)) ? (pcputgnr & pclast) : pcputgnr;
      always_comb npputq = ((SYNCROUTER==0) && (INTMAXPLDBIT != 7)) ? (enptrdy & npput) : npput;
      always_comb npputgnrq = ((SYNCROUTER==0) && (INTMAXPLDBIT != 7)) ? (npputgnr & nplast) : npputgnr;

      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin
            pcmsgipgnr <= 1'b0;
            npmsgipgnr <= 1'b0;
            pcxfrgnr  <= '0;
            npxfrgnr  <= '0;
         end else begin
            if (pcputq) pcmsgipgnr <= ~eomin;
            if (npputq) npmsgipgnr <= ~eomin;
            if (pcputq & ~pcmsgipgnr) pcxfrgnr <= 1;
            else if (pcputq & (pcxfrgnr < XFRHBMAXGNRF)) pcxfrgnr <= pcxfrgnr + 1; // lintra s-0393 s-0396
            if (npputq & ~npmsgipgnr) npxfrgnr <= 1;
            else if (npputq & (npxfrgnr < XFRHBMAXGNRF)) npxfrgnr <= npxfrgnr + 1; // lintra s-0393 s-0396
         end

      always_ff @( posedge side_clk or negedge side_rst_b )
          if ( !side_rst_b ) begin
             pcdatain_ff1 <= '0;
             pcparerr_ff1 <= 1'b0;
          end else if ( pcputq | pcputgnrq ) begin
             pcdatain_ff1 <= gnrdin;
             pcparerr_ff1 <= parerr;
          end

      always_ff @( posedge side_clk or negedge side_rst_b )
          if ( !side_rst_b ) begin
             npdatain_ff1 <= '0;
             npparerr_ff1 <= 1'b0;
          end else if ( npputq | npputgnrq ) begin
             npdatain_ff1 <= gnrdin;
             npparerr_ff1 <= parerr;
          end


      always_comb data   = pcputgnr ? pcgnr_data : (npputgnr ? npgnr_data : '0);
      always_comb eom    = pcputgnr ? pcgnr_eom  : (npputgnr ? npgnr_eom  : 1'b0);
      always_comb parity = pcputgnr ? pcgnr_par  : (npputgnr ? npgnr_par  : 1'b0);


      if ((INTMAXPLDBIT == 31) || (INTMAXPLDBIT == 15)) begin : gen_gnr_16and32b

         logic [INTMAXPLDBIT+1:0] pcgnrdout, npgnrdout;
         logic pcsrcswp_ff1, pcdstswp_ff1;
         logic npsrcswp_ff1, npdstswp_ff1;
         logic srcswp, dstswp;
         logic pcgnrdst1, pcgnrdst2;
         logic npgnrdst1, npgnrdst2;
         logic [7:0] srcidfield, dstsegfield; // lintra s-70036
         logic pcgnrdst1q, pcgnrdst2q;
         logic npgnrdst1q, npgnrdst2q;

         always_comb pcgnrdst1q = (SYNCROUTER==0) ? (pcgnrdst1 & epctrdy) : pcgnrdst1;
       //always_comb pcgnrdst2q = ((SYNCROUTER==0) && (RATIO != 1)) ? (pcgnrdst2 & epctrdy) : pcgnrdst2;
         always_comb pcgnrdst2q = ((SYNCROUTER==0) && (RATIO != 1)) ? (pcgnrdst2 & pcputgnrq) : pcgnrdst2;

         always_comb npgnrdst1q = (SYNCROUTER==0) ? (npgnrdst1 & enptrdy) : npgnrdst1;
      // always_comb npgnrdst2q = ((SYNCROUTER==0) && (RATIO != 1)) ? (npgnrdst2 & enptrdy) : npgnrdst2;
         always_comb npgnrdst2q = ((SYNCROUTER==0) && (RATIO != 1)) ? (npgnrdst2 & npputgnrq) : npgnrdst2;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b ) begin
                pcsrcswp_ff1 <= 1'b0;
                pcdstswp_ff1 <= 1'b0;
             end else if ( pcgnrdst2q ) begin
                pcsrcswp_ff1 <= 1'b0;
                pcdstswp_ff1 <= 1'b0;
             end else if ( pcgnrdst1q ) begin
                pcsrcswp_ff1 <= srcswp;
                pcdstswp_ff1 <= dstswp;
             end

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b ) begin
                npsrcswp_ff1 <= 1'b0;
                npdstswp_ff1 <= 1'b0;
             end else if ( npgnrdst2q ) begin
                npsrcswp_ff1 <= 1'b0;
                npdstswp_ff1 <= 1'b0;
             end else if ( npgnrdst1q ) begin
                npsrcswp_ff1 <= srcswp;
                npdstswp_ff1 <= dstswp;
             end

         always_comb srcswp = (pcgnrdst1 | npgnrdst1)
                            & ( (srcidfield == gnr_segment_id)
                              | ( (srcidfield >= SSF_GMCAST_RANGE_MIN)
                                & (srcidfield <= SSF_GMCAST_RANGE_MAX) ));
         always_comb dstswp = (pcgnrdst1 | npgnrdst1)
                            & ( (GNR_16BIT_EP == 1)
                              | ( (GNR_HIER_BRIDGE_EN == 1)
                                & ( (dstsegfield >= SSF_LMCAST_RANGE_MIN)
                                  & (dstsegfield <= SSF_LMCAST_RANGE_MAX) )));


         if (INTMAXPLDBIT == 31) begin : gen_gnr32b

            logic pceom, npeom;
            logic pceomsp, npeomsp;
            logic pcputgnrrdy, npputgnrrdy;

            always_comb epctrdygnr = (RATIO == 1) ? 1'b0 : (pcput & ~pcmsgipgnr & ~pceom & ~pceomsp);
            always_comb enptrdygnr = (RATIO == 1) ? 1'b0 : (npput & ~npmsgipgnr & ~npeom & ~npeomsp);
            always_comb idlegnr = ~pcmsgipgnr & ~pceom & ~pceomsp
                                & ~npmsgipgnr & ~npeom & ~npeomsp;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b )
                   pceom <= 1'b0;
                else if (pcputgnrq & pceom)
                   pceom <= 1'b0;
                else if (pcputq & eomin)
                   pceom <= 1'b1;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b )
                   npeom <= 1'b0;
                else if (npputgnrq & npeom)
                   npeom <= 1'b0;
                else if (npputq & eomin)
                   npeom <= 1'b1;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b )
                   pceomsp <= 1'b0;
                else if (pcputgnrq & pceomsp)
                   pceomsp <= 1'b0;
                else if (pcputq & eomin & (pcxfrgnr == 2'b01))
                   pceomsp <= 1'b1;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b )
                   npeomsp <= 1'b0;
                else if (npputgnrq & npeomsp)
                   npeomsp <= 1'b0;
                else if (npputq & eomin & (npxfrgnr == 2'b01))
                   npeomsp <= 1'b1;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b ) begin
                   pcgnr_dstseg_ff <= '0;
                   pcgnr_srcid_ff  <= '0;
                end else if ( pcgnrdst1 ) begin
                   pcgnr_dstseg_ff <= pcdatain_ff1[7:0];
                   pcgnr_srcid_ff  <= pcdatain_ff1[15:8];
                end

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b ) begin
                   npgnr_dstseg_ff <= '0;
                   npgnr_srcid_ff  <= '0;
                end else if ( npgnrdst1 ) begin
                   npgnr_dstseg_ff <= npdatain_ff1[7:0];
                   npgnr_srcid_ff  <= npdatain_ff1[15:8];
                end

            always_comb pcputgnrrdy = (SYNCROUTER==0) ? ~pcstall : (~pcstall & ~pcbusy);
            always_comb pcputgnr = ( pcput &  pcmsgipgnr)
                                 | ( pcput & ~pcmsgipgnr & pceom)
                                 | (~pcput & ~npput & pceom & pcputgnrrdy);
            always_comb npputgnrrdy = (SYNCROUTER==0) ? ~npstall : (~npstall & ~pcbusy & ~npbusy);
            always_comb npputgnr = ( npput &  npmsgipgnr)
                                 | ( npput & ~npmsgipgnr & npeom)
                                 | (~pcput & ~npput & ~pceom & npeom & npputgnrrdy);

            always_comb pcgnrdst1 =   pcput & (pcxfrgnr == 2'b01);
            always_comb pcgnrdst2 = ( pcput & (pcxfrgnr == 2'b10))
                                  | (~pcput & ~npput & pceomsp & pcputgnrrdy);

            always_comb npgnrdst1 =   npput & (npxfrgnr == 2'b01);
            always_comb npgnrdst2 = ( npput & (npxfrgnr == 2'b10))
                                  | (~pcput & ~npput & ~pceom & npeomsp & npputgnrrdy);

            always_comb srcidfield  = (pcgnrdst1 | npgnrdst1) ? datain[15:8] : 8'h00;
            always_comb dstsegfield =  pcgnrdst1 ? pcdatain_ff1[7:0]
                                    : (npgnrdst1 ? npdatain_ff1[7:0] : 8'h00);

            always_comb pcdstfield =  dstswp ? datain[7:0] 
                                   : (pcdstswp_ff1 ? pcgnr_dstseg_ff : pcdatain_ff1[7:0]);
            always_comb pcsrcfield =  srcswp ? datain[15:8] 
                                   : (pcsrcswp_ff1 ? pcgnr_srcid_ff  : pcdatain_ff1[15:8]);
            always_comb pcgnrdout  = (pcgnrdst1 | pcgnrdst2) 
                                   ? {pcdatain_ff1[32:16],pcsrcfield,pcdstfield}
                                   :  pcdatain_ff1;

            always_comb npdstfield =  dstswp ? datain[7:0] 
                                   : (npdstswp_ff1 ? npgnr_dstseg_ff : npdatain_ff1[7:0]);
            always_comb npsrcfield =  srcswp ? datain[15:8] 
                                   : (npsrcswp_ff1 ? npgnr_srcid_ff  : npdatain_ff1[15:8]);
            always_comb npgnrdout  = (npgnrdst1 | npgnrdst2) 
                                   ? {npdatain_ff1[32:16],npsrcfield,npdstfield}
                                   :  npdatain_ff1;

            always_comb pcgnr_data =  pcgnrdout[31:0];
            always_comb pcgnr_eom  =  pcgnrdout[32];
            always_comb pcgnr_par  = ^pcgnrdout ^ pcparerr_ff1;

            always_comb npgnr_data =  npgnrdout[31:0];
            always_comb npgnr_eom  =  npgnrdout[32];
            always_comb npgnr_par  = ^npgnrdout ^ npparerr_ff1;

         end else if (INTMAXPLDBIT == 15) begin : gen_gnr16b

            logic [INTMAXPLDBIT+1:0] pcdatain_ff2, npdatain_ff2;
            logic pcparerr_ff2, npparerr_ff2;
            logic pceomf1, npeomf1;
            logic pceomf2, npeomf2;
            logic pceomsp, npeomsp;
            logic pcputgnrrdy, npputgnrrdy;

            always_comb epctrdygnr = (RATIO == 1) ? 1'b0 
                                   : ( ((pcput & ~pcmsgipgnr) | (pcput & (pcxfrgnr==3'b001)))
                                      & ~pceomf1 & ~pceomf2 & ~pceomsp );
            always_comb enptrdygnr = (RATIO == 1) ? 1'b0
                                   : ( ((npput & ~npmsgipgnr) | (npput & (npxfrgnr==3'b001)))
                                      & ~npeomf1 & ~npeomf2 & ~npeomsp );
            always_comb idlegnr = ~pcmsgipgnr & ~pceomf1 & ~pceomf2 & ~pceomsp
                                & ~npmsgipgnr & ~npeomf1 & ~npeomf2 & ~npeomsp;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b ) begin
                   pcdatain_ff2 <= '0;
                   pcparerr_ff2 <= 1'b0;
                end else if ( pcputq | pcputgnrq ) begin
                   pcdatain_ff2 <= pcdatain_ff1;
                   pcparerr_ff2 <= pcparerr_ff1;
                end

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b ) begin
                   npdatain_ff2 <= '0;
                   npparerr_ff2 <= 1'b0;
                end else if ( npputq | npputgnrq ) begin
                   npdatain_ff2 <= npdatain_ff1;
                   npparerr_ff2 <= npparerr_ff1;
                end

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b )
                   pceomf1 <= 1'b0;
                else if (pcputgnrq & pceomf1)
                   pceomf1 <= 1'b0;
                else if (pcputq & eomin)
                   pceomf1 <= 1'b1;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b )
                   npeomf1 <= 1'b0;
                else if (npputgnrq & npeomf1)
                   npeomf1 <= 1'b0;
                else if (npputq & eomin)
                   npeomf1 <= 1'b1;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b )
                   pceomf2 <= 1'b0;
                else if (pcputgnrq & pceomf2)
                   pceomf2 <= 1'b0;
                else if (pcputgnrq & pceomf1)
                   pceomf2 <= 1'b1;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b )
                   npeomf2 <= 1'b0;
                else if (npputgnrq & npeomf2)
                   npeomf2 <= 1'b0;
                else if (npputgnrq & npeomf1)
                   npeomf2 <= 1'b1;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b )
                   pceomsp <= 1'b0;
                else if (pcputgnrq & pceomsp)
                   pceomsp <= 1'b0;
                else if (pcputq & eomin & (pcxfrgnr == 3'b011))
                   pceomsp <= 1'b1;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b )
                   npeomsp <= 1'b0;
                else if (npputgnrq & npeomsp)
                   npeomsp <= 1'b0;
                else if (npputq & eomin & (npxfrgnr == 3'b011))
                   npeomsp <= 1'b1;

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b ) begin
                   pcgnr_dstseg_ff <= '0;
                   pcgnr_srcid_ff  <= '0;
                end else if ( pcgnrdst1q ) begin
                   pcgnr_dstseg_ff <= pcdatain_ff2[7:0];
                   pcgnr_srcid_ff  <= pcdatain_ff2[15:8];
                end

            always_ff @( posedge side_clk or negedge side_rst_b )
                if ( !side_rst_b ) begin
                   npgnr_dstseg_ff <= '0;
                   npgnr_srcid_ff  <= '0;
                end else if ( npgnrdst1q ) begin
                   npgnr_dstseg_ff <= npdatain_ff2[7:0];
                   npgnr_srcid_ff  <= npdatain_ff2[15:8];
                end

            always_comb pcputgnrrdy = (SYNCROUTER==0) ? ~pcstall : ~pcstall & ~pcbusy;
            always_comb pcputgnr = ( pcput &  pcmsgipgnr & (pcxfrgnr >= 3'b010))
                                 | ( pcput & ~pcmsgipgnr          & pceomf1)
                                 | ( pcput & ~pcmsgipgnr          & pceomf2)
                                 | ( pcput & (pcxfrgnr == 3'b001) & pceomf2)
                                 | (~pcmsgipgnr & ~pcput & ~npput & pcputgnrrdy & pceomf1)
                                 | (~pcmsgipgnr & ~pcput & ~npput & pcputgnrrdy & pceomf2);
            always_comb npputgnrrdy = (SYNCROUTER==0) ? ~npstall : ~npstall & ~pcbusy & ~npbusy;
            always_comb npputgnr = ( npput &  npmsgipgnr & (npxfrgnr >= 3'b010))
                                 | ( npput & ~npmsgipgnr          & npeomf1)
                                 | ( npput & ~npmsgipgnr          & npeomf2)
                                 | ( npput & (npxfrgnr == 3'b001) & npeomf2)
                                 | (~npmsgipgnr & ~pcput & ~npput & npputgnrrdy & ~pceomf1 & ~pceomf2 & npeomf1)
                                 | (~npmsgipgnr & ~pcput & ~npput & npputgnrrdy & ~pceomf1 & ~pceomf2 & npeomf2);

            always_comb pcgnrdst1 =   pcput & (pcxfrgnr == 3'b010) &  pcmsgipgnr;
            always_comb pcgnrdst2 = ( pcput & (pcxfrgnr == 3'b100) &  pcmsgipgnr)
                                  | ( pcput & (pcxfrgnr == 3'b100) & ~pcmsgipgnr & pceomsp)
                                  | (~pcmsgipgnr & ~pcput & ~npput & pcputgnrrdy & pceomsp);

            always_comb npgnrdst1 =   npput & (npxfrgnr == 3'b010) &  npmsgipgnr;
            always_comb npgnrdst2 = ( npput & (npxfrgnr == 3'b100) &  npmsgipgnr)
                                  | ( npput & (npxfrgnr == 3'b100) & ~npmsgipgnr & npeomsp)
                                  | (~npmsgipgnr & ~pcput & ~npput & npputgnrrdy & ~pceomf1 & ~pceomf2 & npeomsp);

            always_comb srcidfield  = (pcgnrdst1 | npgnrdst1) ? datain[15:8] : 8'h00;
            always_comb dstsegfield =  pcgnrdst1 ? pcdatain_ff2[7:0]
                                    : (npgnrdst1 ? npdatain_ff2[7:0] : 8'h00);

            always_comb pcdstfield =  dstswp ? datain[7:0] 
                                   : (pcdstswp_ff1 ? pcgnr_dstseg_ff : pcdatain_ff2[7:0]);
            always_comb pcsrcfield =  srcswp ? datain[15:8] 
                                   : (pcsrcswp_ff1 ? pcgnr_srcid_ff  : pcdatain_ff2[15:8]);
            always_comb pcgnrdout  = (pcgnrdst1 | pcgnrdst2) 
                                   ? {pcsrcfield,pcdstfield}
                                   :  pcdatain_ff2;

            always_comb npdstfield =  dstswp ? datain[7:0] 
                                   : (npdstswp_ff1 ? npgnr_dstseg_ff : npdatain_ff2[7:0]);
            always_comb npsrcfield =  srcswp ? datain[15:8] 
                                   : (npsrcswp_ff1 ? npgnr_srcid_ff  : npdatain_ff2[15:8]);
            always_comb npgnrdout  = (npgnrdst1 | npgnrdst2) 
                                   ? {npsrcfield,npdstfield}
                                   :  npdatain_ff2;

            always_comb pcgnr_data =  pcgnrdout[15:0];
            always_comb pcgnr_eom  =  pcdatain_ff2[16];
            always_comb pcgnr_par  = ^pcgnrdout ^ pcparerr_ff2;

            always_comb npgnr_data =  npgnrdout[15:0];
            always_comb npgnr_eom  =  npdatain_ff2[16];
            always_comb npgnr_par  = ^npgnrdout ^ npparerr_ff2;

         end // end else if (INTMAXPLDBIT == 15) begin : gen_gnr16b

      end else if (INTMAXPLDBIT == 7) begin : gen_bp_gnr_7b

         logic [INTMAXPLDBIT+1:0] pcgnrdout8b, npgnrdout8b;
         logic [INTMAXPLDBIT+1:0] pcdatain_ff2, npdatain_ff2;
         logic [INTMAXPLDBIT+1:0] pcdatain_ff3, npdatain_ff3;
         logic [INTMAXPLDBIT+1:0] pcdatain_ff4, npdatain_ff4;
         logic pcparerr_ff2, npparerr_ff2;
         logic pcparerr_ff3, npparerr_ff3;
         logic pcparerr_ff4, npparerr_ff4;
         logic pceomf1, npeomf1;
         logic pceomf2, npeomf2;
         logic pceomf3, npeomf3;
         logic pceomf4, npeomf4;
         logic pceomsp8b, npeomsp8b;
         logic pceomsp8b_ff, npeomsp8b_ff;
         logic pcgnrdst18b, pcgnrdst28b;
         logic npgnrdst18b, npgnrdst28b;
         logic pcgnrsrc18b, npgnrsrc18b;
         logic pcgnrsrc28b, npgnrsrc28b;
         logic srcswp8b, dstswp8b;
         logic pcsrcswp8b_ff, pcdstswp8b_ff;
         logic npsrcswp8b_ff, npdstswp8b_ff;
         logic [7:0] srcidfield8b;
         logic [7:0] dstsegfield8b; // lintra s-70036, s-0527 used only when GNR_HIER_BRIDGE_EN is set
         logic pcputgnrrdy, npputgnrrdy;

         always_comb epctrdygnr = 1'b0;
         always_comb enptrdygnr = 1'b0;

         always_comb idlegnr = ~pcmsgipgnr & ~pceomf1 & ~pceomf2 & ~pceomf3 & ~pceomf4
                             & ~npmsgipgnr & ~npeomf1 & ~npeomf2 & ~npeomf3 & ~npeomf4;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b ) begin
                pcdatain_ff2 <= '0;
                pcparerr_ff2 <= 1'b0;
                pcdatain_ff3 <= '0;
                pcparerr_ff3 <= 1'b0;
                pcdatain_ff4 <= '0;
                pcparerr_ff4 <= 1'b0;
             end else if ( pcput | pcputgnr ) begin
                pcdatain_ff2 <= pcdatain_ff1;
                pcparerr_ff2 <= pcparerr_ff1;
                pcdatain_ff3 <= pcdatain_ff2;
                pcparerr_ff3 <= pcparerr_ff2;
                pcdatain_ff4 <= pcdatain_ff3;
                pcparerr_ff4 <= pcparerr_ff3;
             end

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b ) begin
                npdatain_ff2 <= '0;
                npparerr_ff2 <= 1'b0;
                npdatain_ff3 <= '0;
                npparerr_ff3 <= 1'b0;
                npdatain_ff4 <= '0;
                npparerr_ff4 <= 1'b0;
             end else if ( npput | npputgnr ) begin
                npdatain_ff2 <= npdatain_ff1;
                npparerr_ff2 <= npparerr_ff1;
                npdatain_ff3 <= npdatain_ff2;
                npparerr_ff3 <= npparerr_ff2;
                npdatain_ff4 <= npdatain_ff3;
                npparerr_ff4 <= npparerr_ff3;
             end

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )           pceomf1 <= 1'b0;
             else if (pcputgnr & pceomf1) pceomf1 <= 1'b0;
             else if (pcput & eomin)      pceomf1 <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )           npeomf1 <= 1'b0;
             else if (npputgnr & npeomf1) npeomf1 <= 1'b0;
             else if (npput & eomin)      npeomf1 <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )           pceomf2 <= 1'b0;
             else if (pcputgnr & pceomf2) pceomf2 <= 1'b0;
             else if (pcputgnr & pceomf1) pceomf2 <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )           npeomf2 <= 1'b0;
             else if (npputgnr & npeomf2) npeomf2 <= 1'b0;
             else if (npputgnr & npeomf1) npeomf2 <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )           pceomf3 <= 1'b0;
             else if (pcputgnr & pceomf3) pceomf3 <= 1'b0;
             else if (pcputgnr & pceomf2) pceomf3 <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )           npeomf3 <= 1'b0;
             else if (npputgnr & npeomf3) npeomf3 <= 1'b0;
             else if (npputgnr & npeomf2) npeomf3 <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )           pceomf4 <= 1'b0;
             else if (pcputgnr & pceomf4) pceomf4 <= 1'b0;
             else if (pcputgnr & pceomf3) pceomf4 <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )           npeomf4 <= 1'b0;
             else if (npputgnr & npeomf4) npeomf4 <= 1'b0;
             else if (npputgnr & npeomf3) npeomf4 <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )                              pceomsp8b <= 1'b0;
             else if (pcputgnr & pceomsp8b)                  pceomsp8b <= 1'b0;
             else if (pcput & eomin & (pcxfrgnr == 4'b0111)) pceomsp8b <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )                              npeomsp8b <= 1'b0;
             else if (npputgnr & npeomsp8b)                  npeomsp8b <= 1'b0;
             else if (npput & eomin & (npxfrgnr == 4'b0111)) npeomsp8b <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )                pceomsp8b_ff <= 1'b0;
             else if (pcputgnr & pceomsp8b_ff) pceomsp8b_ff <= 1'b0;
             else if (pcputgnr & pceomsp8b)    pceomsp8b_ff <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )                npeomsp8b_ff <= 1'b0;
             else if (npputgnr & npeomsp8b_ff) npeomsp8b_ff <= 1'b0;
             else if (npputgnr & npeomsp8b)    npeomsp8b_ff <= 1'b1;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )      pcdstswp8b_ff <= 1'b0;
             else if ( pcgnrdst28b & pcputgnr ) pcdstswp8b_ff <= 1'b0;
             else if ( pcgnrdst18b ) pcdstswp8b_ff <= dstswp8b;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )      pcsrcswp8b_ff <= 1'b0;
             else if ( pcgnrsrc28b & pcputgnr ) pcsrcswp8b_ff <= 1'b0;
             else if ( pcgnrsrc18b ) pcsrcswp8b_ff <= srcswp8b;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )      npdstswp8b_ff <= 1'b0;
             else if ( npgnrdst28b & npputgnr ) npdstswp8b_ff <= 1'b0;
             else if ( npgnrdst18b ) npdstswp8b_ff <= dstswp8b;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )      npsrcswp8b_ff <= 1'b0;
             else if ( npgnrsrc28b & npputgnr ) npsrcswp8b_ff <= 1'b0;
             else if ( npgnrsrc18b ) npsrcswp8b_ff <= srcswp8b;

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )      pcgnr_dstseg_ff <= '0;
             else if ( pcgnrdst18b ) pcgnr_dstseg_ff <= pcdatain_ff4[7:0];

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )      pcgnr_srcid_ff  <= '0;
             else if ( pcgnrsrc18b ) pcgnr_srcid_ff  <= pcdatain_ff4[7:0];

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )      npgnr_dstseg_ff <= '0;
             else if ( npgnrdst18b ) npgnr_dstseg_ff <= npdatain_ff4[7:0];

         always_ff @( posedge side_clk or negedge side_rst_b )
             if ( !side_rst_b )      npgnr_srcid_ff  <= '0;
             else if ( npgnrsrc18b ) npgnr_srcid_ff  <= npdatain_ff4[7:0];


         always_comb srcswp8b = (pcgnrsrc18b | npgnrsrc18b)
                              & ( (srcidfield8b == gnr_segment_id)
                                | ( (srcidfield8b >= SSF_GMCAST_RANGE_MIN)
                                  & (srcidfield8b <= SSF_GMCAST_RANGE_MAX) ));
         always_comb dstswp8b = (pcgnrdst18b | npgnrdst18b)
                              & ( (GNR_16BIT_EP == 1)
                                | ( (GNR_HIER_BRIDGE_EN == 1)
                                  & ( (dstsegfield8b >= SSF_LMCAST_RANGE_MIN)
                                    & (dstsegfield8b <= SSF_LMCAST_RANGE_MAX) )));


         always_comb pcputgnrrdy = (SYNCROUTER==0) ? ~pcstall : ~pcstall & ~pcbusy;
         always_comb pcputgnr = ( pcput &  pcmsgipgnr & (pcxfrgnr >= 4'b0100))
                              | ( pcput & ~pcmsgipgnr           & ( pceomf1 | pceomf2 | pceomf3 | pceomf4 ))
                              | (~pcmsgipgnr & ~pcput & ~npput  & ( pceomf1 | pceomf2 | pceomf3 | pceomf4 ) & pcputgnrrdy)
                              | ( pcput & (pcxfrgnr == 4'b0001) & ( pceomf2 | pceomf3 | pceomf4 ))
                              | ( pcput & (pcxfrgnr == 4'b0010) & ( pceomf3 | pceomf4 ))
                              | ( pcput & (pcxfrgnr == 4'b0011) &   pceomf4 );
         always_comb npputgnrrdy = (SYNCROUTER==0) ? ~npstall : ~npstall & ~pcbusy & ~npbusy;
         always_comb npputgnr = ( npput &  npmsgipgnr & (npxfrgnr >= 4'b0100))
                              | ( npput & ~npmsgipgnr           & ( npeomf1 |  npeomf2 |  npeomf3 |  npeomf4 ))
                              | (~npmsgipgnr & ~pcput & ~npput  & (~pceomf1 & ~pceomf2 & ~pceomf3 & ~pceomf4 )
                                             & ~pcputgnr & ( npeomf1 |  npeomf2 |  npeomf3 |  npeomf4 ) & npputgnrrdy)
                              | ( npput & (npxfrgnr == 4'b0001) & ( npeomf2 |  npeomf3 |  npeomf4 ))
                              | ( npput & (npxfrgnr == 4'b0010) & ( npeomf3 |  npeomf4 ))
                              | ( npput & (npxfrgnr == 4'b0011) &   npeomf4 );


         always_comb srcidfield8b  = (pcgnrsrc18b | npgnrsrc18b) ? datain : 8'h00;
         always_comb dstsegfield8b =  pcgnrdst18b ? pcdatain_ff4[7:0]
                                   : (npgnrdst18b ? npdatain_ff4[7:0] : 8'h00);

         always_comb pcgnrdst18b =   pcput & (pcxfrgnr == 4'b0100) &  pcmsgipgnr;
         always_comb pcgnrdst28b = ( pcput & (pcxfrgnr == 4'b1000) &  pcmsgipgnr )
                                 | ( pcput & (pcxfrgnr == 4'b1000) & ~pcmsgipgnr & pceomsp8b )
                                 | (~pcmsgipgnr & ~pcput & ~npput & pceomsp8b & pcputgnrrdy);

         always_comb pcgnrsrc18b =   pcput & (pcxfrgnr == 4'b0101) &  pcmsgipgnr;
         always_comb pcgnrsrc28b = ( pcput & (pcxfrgnr == 4'b1001) &  pcmsgipgnr )
                                 | ( pcput & (pcxfrgnr == 4'b1000) & ~pcmsgipgnr & pceomsp8b_ff )
                                 | ( pcput & (pcxfrgnr == 4'b0001) &  pcmsgipgnr & pceomsp8b_ff )
                                 | (~pcmsgipgnr & ~pcput & ~npput & pceomsp8b_ff & pcputgnrrdy);

         always_comb npgnrdst18b =   npput & (npxfrgnr == 4'b0100) &  npmsgipgnr;
         always_comb npgnrdst28b = ( npput & (npxfrgnr == 4'b1000) &  npmsgipgnr )
                                 | ( npput & (npxfrgnr == 4'b1000) & ~npmsgipgnr & npeomsp8b )
                                 | (~npmsgipgnr & ~pcput & ~pcputgnr & ~npput 
                                     & (~pceomf1 & ~pceomf2 & ~pceomf3 & ~pceomf4) & npeomsp8b & npputgnrrdy);

         always_comb npgnrsrc18b =   npput & (npxfrgnr == 4'b0101) &  npmsgipgnr;
         always_comb npgnrsrc28b = ( npput & (npxfrgnr == 4'b1001) &  npmsgipgnr )
                                 | ( npput & (npxfrgnr == 4'b1000) & ~npmsgipgnr & npeomsp8b_ff )
                                 | ( npput & (npxfrgnr == 4'b0001) &  npmsgipgnr & npeomsp8b_ff )
                                 | (~npmsgipgnr & ~pcput & ~pcputgnr & ~npput 
                                     & (~pceomf1 & ~pceomf2 & ~pceomf3 & ~pceomf4) & npeomsp8b_ff & npputgnrrdy);


         always_comb pcdstfield =  dstswp8b ? datain[7:0] 
                                : (pcdstswp8b_ff ? pcgnr_dstseg_ff : pcdatain_ff4[7:0]);
         always_comb pcsrcfield =  srcswp8b ? datain[7:0]
                                : (pcsrcswp8b_ff ? pcgnr_srcid_ff  : pcdatain_ff4[7:0]);
         always_comb pcgnrdout8b = (pcgnrdst18b | pcgnrdst28b) ? pcdstfield
                                 : (pcgnrsrc18b | pcgnrsrc28b) ? pcsrcfield
                                 :  pcdatain_ff4[7:0];

         always_comb npdstfield =  dstswp8b ? datain[7:0]
                                : (npdstswp8b_ff ? npgnr_dstseg_ff : npdatain_ff4[7:0]);
         always_comb npsrcfield =  srcswp8b ? datain[7:0]
                                : (npsrcswp8b_ff ? npgnr_srcid_ff  : npdatain_ff4[7:0]);
         always_comb npgnrdout8b = (npgnrdst18b | npgnrdst28b) ? npdstfield
                                 : (npgnrsrc18b | npgnrsrc28b) ? npsrcfield
                                 :  npdatain_ff4[7:0];


         always_comb pcgnr_data =  pcgnrdout8b[7:0];
         always_comb pcgnr_eom  =  pcdatain_ff4[8];
         always_comb pcgnr_par  = ^{pcgnrdout8b,pcdatain_ff4[8]} ^ pcparerr_ff4;

         always_comb npgnr_data =  npgnrdout8b[7:0];
         always_comb npgnr_eom  =  npdatain_ff4[8];
         always_comb npgnr_par  = ^{npgnrdout8b,npdatain_ff4[8]} ^ npparerr_ff4;

      end // end else if (INTMAXPLDBIT == 7) begin : gen_bp_gnr_7b

   end else begin : gen_bp_gnr

      always_comb begin
          pcputgnr = pcput;
          npputgnr = npput;
          data   = datahh;
          eom    = eomhh;
          parity = parityhh;
          epctrdygnr = 1'b0;
          enptrdygnr = 1'b0;
          idlegnr = 1'b1;
      end

   end
endgenerate


  always_comb hier_bridge_en = (HIER_BRIDGE_STRAP == 1) ? cfg_hierbridgeen : 1'b1;
  always_comb hier_bridge_id = (HIER_BRIDGE_STRAP == 1) ? cfg_hierbridgepid : HIER_BRIDGE_PID;

generate 
   if (HIER_BRIDGE_GEN == 1) begin : gen_hier_bridge_msgip
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin
            pcmsgiphb <= 1'b0;
            npmsgiphb <= 1'b0;
            pcxfrhb   <= '0;
            npxfrhb   <= '0;
         end else begin
            if (pcput) pcmsgiphb <= ~eomin;
            if (npput) npmsgiphb <= ~eomin;
            if (pcput & ~pcmsgiphb) pcxfrhb <= 1;
            else if ((pcputhh | pcput) & (pcxfrhb < XFRHBMAX)) pcxfrhb <= pcxfrhb + 1; // lintra s-0393 s-0396
            if (npput & ~npmsgiphb) npxfrhb <= 1;
            else if ((npputhh | npput) & (npxfrhb < XFRHBMAX)) npxfrhb <= npxfrhb + 1; // lintra s-0393 s-0396
         end

      always_comb hhdin  = {parityin, eomin, datain};
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin
            pchhdin_ff <= '0;
            nphhdin_ff <= '0;
         end else begin
            if (~pcmsgiphb & pcput) pchhdin_ff <= hhdin;
            if (~npmsgiphb & npput) nphhdin_ff <= hhdin;
         end

      logic [INTMAXPLDBIT+2:0]           hhdout;
      always_comb begin
          pcstallh = hier_bridge_en & ((pcxfrhb > XFRHBMIN) & (pcxfrhb < XFRHBMAX));
          npstallh = hier_bridge_en & ((npxfrhb > XFRHBMIN) & (npxfrhb < XFRHBMAX));
          pcbusyh  = hier_bridge_en & ((pcxfrhb > 0) & (pcxfrhb < XFRHBMAX));
          npbusyh  = hier_bridge_en & ((npxfrhb > 0) & (npxfrhb < XFRHBMAX));
          hhdout   = (hier_bridge_en & pcdouthhsel) ? pchhdout 
                   : (hier_bridge_en & npdouthhsel) ? nphhdout : hhdin;
          datahh   = hhdout[INTMAXPLDBIT:0];
          eomhh    = hhdout[INTMAXPLDBIT+1];
          parityhh = hhdout[INTMAXPLDBIT+2];
      end
   end else begin : gen_hier_bridge_msgip_bp
      always_comb begin
          pcputhh  = 1'b0;
          npputhh  = 1'b0;
          pcstallh = 1'b0;
          npstallh = 1'b0;
          pcbusyh  = 1'b0;
          npbusyh  = 1'b0;
          datahh   = datain;
          eomhh    = eomin;
          parityhh = parityin;
      end
   end
endgenerate

generate 
   if ((HIER_BRIDGE_GEN == 1) & (INTMAXPLDBIT == 31)) begin : gen_hier_bridge_32b

      logic pconedwmsg, nponedwmsg;
      logic [15:0] hhdingen;

      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b )
            pconedwmsg <= '0;
         else if (~pcmsgiphb & pcput & eomin)
            pconedwmsg <= 1'b1;
         else if (pcputhh & pconedwmsg)
            pconedwmsg <= 1'b0;

      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b )
            nponedwmsg <= '0;
         else if (~npmsgiphb & npput & eomin)
            nponedwmsg <= 1'b1;
         else if (npputhh & nponedwmsg)
            nponedwmsg <= 1'b0;

      always_comb hhdingen = {((datain[7:0]==8'hfe) | (datain[7:0]==8'hff) | (datain[15:8] >= MIN_GLOBAL_PID)) ? datain[15:8] : hier_bridge_id, datain[7:0]};
      // always_comb hhdingen = {(datain[7:0] >= MIN_GLOBAL_PID) ? datain[15:8] : hier_bridge_id, datain[7:0]};
      // always_comb hhdingen = {((datain[7:0]==8'hfe) | (datain[7:0]==8'hff)) ? datain[15:8] : hier_bridge_id, datain[7:0]};
      // always_comb hhdingen = datain[15:0];

      always_comb pcputhh  = hier_bridge_en & (~pcstall & ~pcbusy & ((pcmsgiphb & (pcxfrhb==2'b01)) | pconedwmsg));
      always_comb pchhdout = (~pcmsgiphb & pcput) ? {^hhdingen[15:0],1'b0,16'h0000,hhdingen[15:0]} 
                           : pcputhh ? pchhdin_ff : hhdin;
      always_comb pcdouthhsel = pcputhh | (~pcmsgiphb & pcput);

      always_comb npputhh  = hier_bridge_en & (~npstall & ~npbusy & ~pcputhh & ((npmsgiphb & (npxfrhb==2'b01)) | nponedwmsg));
      always_comb nphhdout = (~npmsgiphb & npput) ? {^hhdingen[15:0],1'b0,16'h0000,hhdingen[15:0]} 
                           : npputhh ? nphhdin_ff : hhdin;
      always_comb npdouthhsel = npputhh | (~npmsgiphb & npput);

   end else if ((HIER_BRIDGE_GEN == 1) & (INTMAXPLDBIT == 15)) begin : gen_hier_bridge_16b

      logic pcputhbrsvd, pcputhbdst;
      logic npputhbrsvd, npputhbdst;
      logic [16:0] hhdingen;
      logic [17:0] hhdinp;

      always_comb pcputhbrsvd = (pcxfrhb==2'b01);
      always_comb pcputhbdst  = (pcxfrhb==2'b10);
      always_comb npputhbrsvd = (npxfrhb==2'b01);
      always_comb npputhbdst  = (npxfrhb==2'b10);
      always_comb hhdingen    = {eomin, ((datain[7:0]==8'hfe) | (datain[7:0]==8'hff) | (datain[15:8] >= MIN_GLOBAL_PID)) ? datain[15:8] : hier_bridge_id, datain[7:0]};
      // always_comb hhdingen    = {eomin, (datain[15:8] >= MIN_GLOBAL_PID) ? datain[15:8] : hier_bridge_id, datain[7:0]};
      // always_comb hhdingen    = {eomin, ((datain[7:0]==8'hfe) | (datain[7:0]==8'hff)) ? datain[15:8] : hier_bridge_id, datain[7:0]};
      always_comb hhdinp      = {^hhdingen, hhdingen};
      // always_comb hhdinp      = hhdin;

      always_comb pcputhh  = hier_bridge_en & (~pcstall & ~pcbusy & (pcputhbrsvd | pcputhbdst));
      always_comb pchhdout = pcputhbrsvd ? '0 : pcputhbdst ? pchhdin_ff : hhdinp;
      always_comb pcdouthhsel = pcputhh | (~pcmsgiphb & pcput);

      always_comb npputhh  = hier_bridge_en & (~npstall & ~npbusy & ~pcputhh & (npputhbrsvd | npputhbdst));
      always_comb nphhdout = npputhbrsvd ? '0 : npputhbdst ? nphhdin_ff : hhdinp;
      always_comb npdouthhsel = npputhh | (~npmsgiphb & npput);

   end else if ((HIER_BRIDGE_GEN == 1) & (INTMAXPLDBIT == 7)) begin : gen_hier_bridge_8b

      logic pcputhbdst, pcputhbsrc, pcputhbopc, pcputhbtag;
      logic [9:0] pchhsrc, pchhopc, pchhtag;
      logic npputhbdst, npputhbsrc, npputhbopc, npputhbtag;
      logic [9:0] nphhsrc, nphhopc, nphhtag;
      // logic [8:0] hhdingen;
      // logic [9:0] hhdinp;
      logic [8:0] nphhdingen, pchhdingen;
      logic [9:0] nphhdinp, pchhdinp;

      always_comb pcputhbdst = (pcxfrhb==5'h4);
      always_comb pcputhbsrc = (pcxfrhb==5'h5);
      always_comb pcputhbopc = (pcxfrhb==5'h6);
      always_comb pcputhbtag = (pcxfrhb==5'h7);

      always_comb npputhbdst = (npxfrhb==5'h4);
      always_comb npputhbsrc = (npxfrhb==5'h5);
      always_comb npputhbopc = (npxfrhb==5'h6);
      always_comb npputhbtag = (npxfrhb==5'h7);

      always_comb pcputhh = hier_bridge_en & (~pcstall & ~pcbusy & (pcputhbdst | pcputhbsrc | pcputhbopc | pcputhbtag));
      always_comb npputhh = hier_bridge_en & (~npstall & ~npbusy & ~pcputhh & (npputhbdst | npputhbsrc | npputhbopc | npputhbtag));

      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin
            pchhsrc <= '0;
            pchhopc <= '0;
            pchhtag <= '0;
         end else begin
            if ((pcxfrhb==5'h1) & pcput) pchhsrc <= hhdin;
            if ((pcxfrhb==5'h2) & pcput) pchhopc <= hhdin;
            if ((pcxfrhb==5'h3) & pcput) pchhtag <= hhdin;
         end

      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin
            nphhsrc <= '0;
            nphhopc <= '0;
            nphhtag <= '0;
         end else begin
            if ((npxfrhb==5'h1) & npput) nphhsrc <= hhdin;
            if ((npxfrhb==5'h2) & npput) nphhopc <= hhdin;
            if ((npxfrhb==5'h3) & npput) nphhtag <= hhdin;
         end

      // always_comb hhdingen = {eomin, (datain[7:0] >= MIN_GLOBAL_PID) ? datain[7:0] : hier_bridge_id};
      // always_comb hhdingen = {eomin, ((datain[7:0]==8'hfe) | (datain[7:0]==8'hff)) ? datain[7:0] : hier_bridge_id};
      // always_comb hhdinp   = {^hhdingen, hhdingen};
      //always_comb hhdinp   = hhdin;
      
      
      always_comb pchhdingen = {eomin,((pchhdin_ff[7:0]==8'hfe) | (pchhdin_ff[7:0]==8'hff) | (datain[7:0] >= MIN_GLOBAL_PID)) ? datain[7:0] : hier_bridge_id};
      always_comb pchhdinp   = {^pchhdingen, pchhdingen};

      always_comb pchhdout = ((pcxfrhb == 5'h2) | (pcxfrhb == 5'h3)) ? '0 
                           : pcputhbdst ? pchhdin_ff : pcputhbsrc ? pchhsrc
                           : pcputhbopc ? pchhopc : pcputhbtag ? pchhtag : (pcxfrhb == 5'h1) ? pchhdinp : hhdin;
      always_comb pcdouthhsel = (pcput & (~pcmsgiphb | ((pcxfrhb >= 5'h1) & (pcxfrhb <= 5'h3)))) | pcputhh;



      always_comb nphhdingen = {eomin,((nphhdin_ff[7:0]==8'hfe) | (nphhdin_ff[7:0]==8'hff) | (datain[7:0] >= MIN_GLOBAL_PID)) ? datain[7:0] : hier_bridge_id};
      always_comb nphhdinp   = {^nphhdingen, nphhdingen};

      always_comb nphhdout = ((npxfrhb == 5'h2) | (npxfrhb == 5'h3)) ? '0 
                           : npputhbdst ? nphhdin_ff : npputhbsrc ? nphhsrc
                           : npputhbopc ? nphhopc : npputhbtag ? nphhtag : (npxfrhb == 5'h1) ? nphhdinp : hhdin;
      always_comb npdouthhsel = (npput & (~npmsgiphb | ((npxfrhb >= 5'h1) & (npxfrhb <= 5'h3)))) | npputhh;
   end
endgenerate

generate
    if (|SB_PARITY_REQUIRED == 1) begin : gen_par_signs
        always_comb in_pc_parity_err = (pcputgnr | nxtpcput) ? ^{data,eom,parity} : '0;
        always_comb in_np_parity_err = (npputgnr | nxtnpput) ? ^{data,eom,parity} : '0;
    end
    else begin : gen_no_par_signs
        always_comb in_pc_parity_err = '0;
        always_comb in_np_parity_err = '0;
    end
endgenerate

    // The output flops
  always_comb mpayload = outdata[0][EXTMAXPLDBIT:0];
  always_comb meom     = outeom[0];
  always_comb mparity  = outparity;

  // Determine if the egress port is idle (used by the clock gating ISM)
  // HSD 4258336 - idle_egress_full is the original version of idle_egress
  always_comb idle_egress_full = !nd_mpccup & !nd_mnpcup &
                                 !mpcput & !mnpput & ~npbusyh & ~pcbusyh &
                                 ( (RATIO==1) ? '1 : (pcxfr=='0) & (npxfr=='0) ) & idlegnr;
  // HSD 4258336 - idle_egress for ENDPOINTONLY should not include credit updates
  always_comb idle_egress = ( (ENDPOINTONLY==1) ? '1 : (~nd_mpccup & ~nd_mnpcup) ) &
                            !mpcput & !mnpput & ~npbusyh & ~pcbusyh &
                            ( (RATIO==1) ? '1 : (pcxfr=='0) & (npxfr=='0) ) & idlegnr;

// SBC-PCN-007 - Egress port completion detection logic - START
generate
   if( |EXPECTED_COMPLETIONS_COUNTER ) begin: gen_egress_comp_detect
      logic [FLITTRACKERMAXBIT:0] opcflittracker; // Opcode flit tracker
      logic [FLITTRACKERMAXBIT:0] mipflittracker; // Message in progress flit tracker
      logic                       pcmsgip;        // Posted/completion message in progress
      logic                       nonhier_pcmsgip;// Actual payload Posted/completion message in progress

      if( FLITTRACKERMAXBIT == 0 ) begin: gen_single_flit_tracker
         always_comb opcflittracker = OPCFLITTRACKER_RSTVAL;
         always_comb mipflittracker = MIPFLITTRACKER_RSTVAL;
      end else begin: gen_multibit_flit_tracker
         // Barrel shifter used to track where the current pc message is at.
         // This is a fairly generic approach to detecting progress while
         // remaining sensitive to timing. It is waistful with bits, especially
         // in smaller internal data bus sizes. May be worth rexploring what
         // the virtual port does, although that code is a little very confusing.
         always_ff @( posedge side_clk or negedge side_rst_b ) begin
            if( !side_rst_b ) begin
               opcflittracker <= OPCFLITTRACKER_RSTVAL;
               mipflittracker <= MIPFLITTRACKER_RSTVAL;
            end else if( epctrdy ) begin
               mipflittracker <= { mipflittracker[0] , mipflittracker[FLITTRACKERMAXBIT:1] };
               if( !nonhier_pcmsgip ) begin
                  opcflittracker <= { opcflittracker[0] , opcflittracker[FLITTRACKERMAXBIT:1] };
               end
            end
         end
      end

      // Detect when a completion message has gone into the egress accumulator.
      // If timing becomes an issue due to pcput, it would be possible to put
      // in a pipe stage by making egress_comp_detect a register. Only setting
      // it when the conditions are met and clearing the signal only when it
      // is set to accomidate clock gating efficiency checks.
      always_comb egress_comp_detect = epctrdy           & // PC flit on databus accepted
                                       opcflittracker[0] & // opcflittracker is signalling the current flit as an OPCODE
                                       !nonhier_pcmsgip          & // headerphase of PC message in progress
                                       ( {data[OPCBIT+7:OPCBIT+1] , 1'b0} == SBCOP_CMP );

      // When PC Transfer is all ones and a put is issued when the pc header
      // has cleared the data bus. This bit should clear while the EOM
      // is high.
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin
            pcmsgip <= 1'b0;
         end else if( epctrdy && mipflittracker[0] ) begin
            pcmsgip <= ~eom;
         end
      // when in hier hdr mode, the payload for opcode comparison comes in 2nd dw (similar to completion fencing)
      if (GLOBAL_EP_IS_STRAP) begin: gen_eg_globalep_strap
        logic nonhier_pcmsgip_int;
        always_ff @( posedge side_clk or negedge side_rst_b )
            if( !side_rst_b ) begin
                nonhier_pcmsgip_int <= 1'b0;
            end else if( epctrdy && mipflittracker[0] ) begin
                nonhier_pcmsgip_int <= ~eom & pcmsgip;
            end
        always_comb nonhier_pcmsgip = global_ep_strap ? nonhier_pcmsgip_int : pcmsgip;
      end
      else begin : gen_eg_glb_ep_param
        if (GLOBAL_EP) begin: gen_eg_globalep_param
            always_ff @( posedge side_clk or negedge side_rst_b )
            if( !side_rst_b ) begin
                nonhier_pcmsgip <= 1'b0;
            end else if( epctrdy && mipflittracker[0] ) begin
                nonhier_pcmsgip <= ~eom & pcmsgip;
            end
        end
        else begin : gen_eg_lcl_ep_param
          always_comb nonhier_pcmsgip  = pcmsgip;
        end
      end // glb_param
   end else begin: gen_no_egress_comp_detect
      always_comb egress_comp_detect = 1'b0;
   end
endgenerate
// SBC-PCN-007 - Egress port completion detection logic - FINISH

  always_comb pcbusy = |pcxfr & (RATIO!=1);
  always_comb npbusy = |npxfr & (RATIO!=1);
  
  always_comb pclast = pcxfr=='1;
  always_comb nplast = npxfr=='1;
  
  always_comb pcstall = ~ism_active | ~(|pccredits | ((CUP2PUT1CYC!=0) & mpccup));
  always_comb npstall = ~ism_active | ~(|npcredits | ((CUP2PUT1CYC!=0) & mnpcup));

  // always_comb enpstall = npstall;
  generate
    if ((SYNCROUTER==0) && (HIER_BRIDGE_GEN==1)) begin : enpstall_hier
       always_comb enpstall = npstall | pcstallh | pcputhh | pcbusyh;
    end else begin : enpstall_hier_bp
       always_comb enpstall = npstall;
    end
  endgenerate
                
  // Note that for the endpoint/async router usage (SYNCROUTER==0) both irdy
  // signals can not be asserted at the same time.
always_comb epctrdy  = SYNCROUTER==0
                  ? ~pcstall & ~pcstallh & ~npputhh & epcirdy & (pclast | epctrdygnr) & (npstall | ~enpirdy)
                  : ~pcstall & ~pcstallh & ~npputhh & ~pcbusy;
always_comb enptrdy  = SYNCROUTER==0
                  ? ~npstall & ~npstallh & ~pcputhh & ~pcbusyh & enpirdy & (nplast | enptrdygnr)
                  : ~npstall & ~npstallh & ~pcputhh & ~pcbusyh & ~npbusy;

  // always_comb pcput = SYNCROUTER==0 ? ~pcstall & epcirdy : epcirdy ;
  // always_comb npput = SYNCROUTER==0 ? ~npstall & enpirdy : enpirdy ;
  generate
    if (HIER_BRIDGE_GEN==1) begin : put_hier
       always_comb pcput = SYNCROUTER==0 ? ~pcstall & epcirdy & epctrdy : epcirdy ;
       always_comb npput = SYNCROUTER==0 ? ~npstall & enpirdy & enptrdy : enpirdy ;
    end else begin : put_hier_bp
       always_comb pcput = SYNCROUTER==0 ? ~pcstall & epcirdy : epcirdy ;
       always_comb npput = SYNCROUTER==0 ? ~npstall & enpirdy : enpirdy ;
    end
  endgenerate

always_comb nxtpcput = (SYNCROUTER!=0) &
                  ~npputgnr & ~npputhh & ~pcstall & pcbusy & (~npbusy | ~npsel | npstall);

always_comb nxtnpput = (SYNCROUTER!=0) &
                  ~pcputgnr & ~pcputhh & ~npstall & npbusy & (~pcbusy |  npsel |
                                                (pcstall & ~outeom[PCEOM]));
  generate
    if (RATIO == 1)
     begin : gen_smasg_blk
       always_comb
        begin
          pcxfr = '1;
          npxfr = '1;
          npsel = '0;
        end
     end
    else
      begin : gen_msgip_blk
        
        // Message In-Progress Tracking Flops
        always_ff @(posedge side_clk or negedge side_rst_b)
          if (~side_rst_b)  // lintra s-70023
            begin
              pcxfr <= '0;
              npxfr <= '0;
              npsel <= '0;
            end 
          else
            begin
              if (pcputgnr | nxtpcput | pcputhh)
                pcxfr <= pcxfr + 1; // lintra s-0393 s-0396
              
              if (npputgnr | nxtnpput | npputhh)
                npxfr <= npxfr + 1; // lintra s-0393 s-0396
              
              npsel <= ~npputgnr & (npsel | pcputgnr);  // npput clears, pcput sets
            end 
      end 
  endgenerate
  
  // Removed maxcredit checks, this could have caused the router to potentially
  // never power gate due to greedy agents.
  always_comb pwrgt_egress = 1'b1; // Always ready to power gate for agents

  always_comb mpcput_visa = (pcputgnr | nxtpcput | pcputhh);
  always_comb mnpput_visa = (npputgnr | nxtnpput | npputhh);
  always_comb update_pcput = pcputgnr | nxtpcput | pcputhh | mpccup;
  always_comb update_npput = npputgnr | nxtnpput | npputhh | mnpcup;

  // synopsys sync_set_reset credit_reinit
  // Egress Port Credit Counters and Put Output Flops
  always_ff @(posedge side_clk or negedge side_rst_b) 
    if (~side_rst_b)  // lintra s-70023
      begin
        pccredits    <= '0;
        npcredits    <= '0;
        mpcput       <= '0;
        mnpput       <= '0;
      end 
    else if ( credit_reinit ) begin
        pccredits    <= '0;
        npcredits    <= '0;
      end
    else
      begin
        mpcput       <= pcputgnr | nxtpcput | pcputhh;
        mnpput       <= npputgnr | nxtnpput | npputhh;
        
        if (update_pcput) begin
           unique casez ( {pcputgnr | nxtpcput | pcputhh, mpccup} ) // lintra s-0257 "description in lintra webpage unclear for parallel case statements"
             2'b01 : pccredits <= &pccredits ? pccredits : (pccredits + 1); // lintra s-2033
             2'b10 : pccredits <= pccredits - 1;
             default: pccredits <= pccredits;
           endcase
        end
        
        if (update_npput) begin
           unique casez ( {npputgnr | nxtnpput | npputhh, mnpcup} )// lintra s-0257 "description in lintra webpage unclear for parallel case statements"
             2'b01 : npcredits <= &npcredits ? npcredits : (npcredits + 1); // lintra s-2033
             2'b10 : npcredits <= npcredits - 1;
             default : npcredits <= npcredits;
           endcase
        end
      end

  // converted the outdata sequential block to generate to avoid
  // lint problems with previous implementation.

  generate
    if (MAXENTRY == 0)
      if (RATIO == 1)
        begin: gen_outdata_max0_ratio1
          // Sideband Channel Output Flops
          always_ff @(posedge side_clk or negedge side_rst_b) 
            if (~side_rst_b)
              begin
                outdata <= '0;
                outeom  <= '0;
                outparity <= 1'b0;
              end 
            else 
              begin
                if (pcputgnr | pcputhh) begin
                  {outeom[0], outdata[0]} <= {eom,data};
                   outparity<= parity & SB_PARITY_REQUIRED;
                end
                
                if (npputgnr | npputhh) begin
                  {outeom[0], outdata[0]} <= {eom,data};
                   outparity<= parity & SB_PARITY_REQUIRED;
                end
                
                if (nxtpcput)
                  begin
                    outeom[0]   <= outeom[PCEOM] & (pcxfr=='1);
                    outdata[0]  <= outdata[PC1];
                    outparity <= outparity & (pcxfr=='1) & SB_PARITY_REQUIRED;
                  end
                
                if (nxtnpput)
                  begin
                    outeom[0]   <= outeom[NPEOM] & (npxfr=='1);
                    outdata[0]  <= outdata[NP1];
                    outparity <= outparity & (npxfr=='1) & SB_PARITY_REQUIRED;
                  end
              end
        end 
      else if (RATIO == 2)
        begin: gen_outdata_max0_ratio2
          
          // Sideband Channel Output Flops
          always_ff @(posedge side_clk or negedge side_rst_b) 
            if (~side_rst_b)
              begin
                outdata <= '0;
                outeom  <= '0;
                outparity <= 1'b0;
                in_pc_parity_err_f <= '0;
                in_np_parity_err_f <= '0;
              end 
            else 
              begin
                
                if (pcputgnr | pcputhh)
                  begin
                    outeom[0] <= (pcxfr=='1) & eom;
                    if (pcxfr[0]) // lintra s-60032
                      outdata[0]  <= data[XFR1+EXTMAXPLDBIT:XFR1];
                    else
                      outdata[0]  <= data[     EXTMAXPLDBIT:   0];
                    
                    if (pcxfr[0])// lintra s-60032
                      outparity <= in_pc_parity_err ? ~(^{data[XFR1+EXTMAXPLDBIT:XFR1], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR1+EXTMAXPLDBIT:XFR1], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                    else
                      outparity <= in_pc_parity_err ? ~(^{data[     EXTMAXPLDBIT:   0], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[     EXTMAXPLDBIT:   0], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                    
                    in_pc_parity_err_f <= in_pc_parity_err & ~((pcxfr=='1) & eom);
                  end

                if (npputgnr | npputhh)
                  begin
                    outeom[0] <= (npxfr=='1) & eom;
                    if (npxfr[0]) // lintra s-60032
                      outdata[0]  <= data[XFR1+EXTMAXPLDBIT:XFR1];
                    else
                      outdata[0]  <= data[     EXTMAXPLDBIT:   0];

                    if (npxfr[0]) // lintra s-60032
                      outparity <= in_np_parity_err ? ~(^{data[XFR1+EXTMAXPLDBIT:XFR1], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR1+EXTMAXPLDBIT:XFR1], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                    else
                      outparity <= in_np_parity_err ? ~(^{data[     EXTMAXPLDBIT:   0], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[     EXTMAXPLDBIT:   0], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                      
                    in_np_parity_err_f <= in_np_parity_err & ~((npxfr=='1) & eom);
                  end
                
                if (nxtpcput)
                  begin
                    outeom[0]   <= outeom[PCEOM] & (pcxfr=='1);
                    outdata[0]  <= outdata[PC1];
                    outparity   <= in_pc_parity_err_f ? ~(^{outdata[PC1], ((pcxfr=='1) & outeom[PCEOM])}) & SB_PARITY_REQUIRED : (^{outdata[PC1], ((pcxfr=='1) & outeom[PCEOM])}) & SB_PARITY_REQUIRED;
                  end
                
                if (nxtnpput)
                  begin
                    outeom[0]   <= outeom[NPEOM] & (npxfr=='1);
                    outdata[0]  <= outdata[NP1];
                    outparity   <= in_np_parity_err_f ? ~(^{outdata[NP1], ((npxfr=='1) & outeom[NPEOM])}) & SB_PARITY_REQUIRED : (^{outdata[NP1], ((npxfr=='1) & outeom[NPEOM])}) & SB_PARITY_REQUIRED;
                  end
              end // else: !if(~side_rst_b)
        end // block: gen_outdata_max0_ratio2
      else
        begin : gen_outdata_max0_ratio4
          
          // Sideband Channel Output Flops
          always_ff @(posedge side_clk or negedge side_rst_b) 
            if (~side_rst_b)
              begin
                outdata <= '0;
                outeom  <= '0;
                outparity <= 1'b0;
                in_pc_parity_err_f <= '0;
                in_np_parity_err_f <= '0;
              end 
            else 
              begin
                
                if (pcputgnr | pcputhh)
                  begin
                    outeom[0] <= (pcxfr=='1) & eom;
                    in_pc_parity_err_f <= in_pc_parity_err & ~((pcxfr=='1) & eom);

                    casez (pcxfr) // lintra s-60129
                      2'b00 : outdata[0]  <= data[     EXTMAXPLDBIT:   0];
                      2'b01 : outdata[0]  <= data[XFR1+EXTMAXPLDBIT:XFR1];
                      2'b10 : outdata[0]  <= data[XFR2+EXTMAXPLDBIT:XFR2];
                      2'b11 : outdata[0]  <= data[XFR3+EXTMAXPLDBIT:XFR3];
                    endcase
                    casez (pcxfr) // lintra s-60129
                      2'b00 : outparity <= in_pc_parity_err ? ~(^{data[     EXTMAXPLDBIT:   0], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[     EXTMAXPLDBIT:   0], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                      2'b01 : outparity <= in_pc_parity_err ? ~(^{data[XFR1+EXTMAXPLDBIT:XFR1], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR1+EXTMAXPLDBIT:XFR1], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                      2'b10 : outparity <= in_pc_parity_err ? ~(^{data[XFR2+EXTMAXPLDBIT:XFR2], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR2+EXTMAXPLDBIT:XFR2], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                      2'b11 : outparity <= in_pc_parity_err ? ~(^{data[XFR3+EXTMAXPLDBIT:XFR3], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR3+EXTMAXPLDBIT:XFR3], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                    endcase
                  end
                
                if (npputgnr | npputhh)
                  begin
                    outeom[0] <= (npxfr=='1) & eom;
                    in_np_parity_err_f <= in_np_parity_err & ~((npxfr=='1) & eom);
                    casez (npxfr) // lintra s-60129
                      2'b00 : outdata[0]  <= data[     EXTMAXPLDBIT:   0];
                      2'b01 : outdata[0]  <= data[XFR1+EXTMAXPLDBIT:XFR1];
                      2'b10 : outdata[0]  <= data[XFR2+EXTMAXPLDBIT:XFR2];
                      2'b11 : outdata[0]  <= data[XFR3+EXTMAXPLDBIT:XFR3];
                    endcase
                    casez (npxfr) // lintra s-60129
                      2'b00 : outparity <= in_np_parity_err ? ~(^{data[     EXTMAXPLDBIT:   0], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[     EXTMAXPLDBIT:   0], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                      2'b01 : outparity <= in_np_parity_err ? ~(^{data[XFR1+EXTMAXPLDBIT:XFR1], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR1+EXTMAXPLDBIT:XFR1], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                      2'b10 : outparity <= in_np_parity_err ? ~(^{data[XFR2+EXTMAXPLDBIT:XFR2], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR2+EXTMAXPLDBIT:XFR2], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                      2'b11 : outparity <= in_np_parity_err ? ~(^{data[XFR3+EXTMAXPLDBIT:XFR3], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR3+EXTMAXPLDBIT:XFR3], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                    endcase
                  end
                
                if (nxtpcput)
                  begin
                    outeom[0] <= outeom[PCEOM] & (pcxfr=='1);
                      casez (pcxfr) // lintra s-60129
                        2'b0? : outdata[0]  <= outdata[PC1];
                        2'b10 : outdata[0]  <= outdata[PC2];
                        2'b11 : outdata[0]  <= outdata[PC3];
                      endcase
                      casez (pcxfr) // lintra s-60129
                        2'b0? : outparity <= in_pc_parity_err_f ? ~(^{outdata[PC1], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[PC1], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED;
                        2'b10 : outparity <= in_pc_parity_err_f ? ~(^{outdata[PC2], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[PC2], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED;
                        2'b11 : outparity <= in_pc_parity_err_f ? ~(^{outdata[PC3], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[PC3], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED;
                      endcase
                  end
                
                if (nxtnpput)
                  begin
                    outeom[0] <= outeom[NPEOM] & (npxfr=='1);
                      casez (npxfr) // lintra s-60129
                        2'b0? : outdata[0]  <= outdata[NP1];
                        2'b10 : outdata[0]  <= outdata[NP2];
                        2'b11 : outdata[0]  <= outdata[NP3];
                      endcase
                      casez (npxfr) // lintra s-60129
                        2'b0? : outparity <= in_np_parity_err_f ? ~(^{outdata[NP1], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[NP1], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED;
                        2'b10 : outparity <= in_np_parity_err_f ? ~(^{outdata[NP2], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[NP2], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED;
                        2'b11 : outparity <= in_np_parity_err_f ? ~(^{outdata[NP3], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[NP3], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED;
                      endcase
                  end
              end 
        end // block: gen_outdata_max0_ratio4
    else if (MAXENTRY == 2)
      begin : gen_outdata_max2
        
        // Sideband Channel Output Flops
        always_ff @(posedge side_clk or negedge side_rst_b) 
          if (~side_rst_b)
            begin
              outdata <= '0;
              outeom  <= '0;
              outparity <= 1'b0;
              in_pc_parity_err_f <= '0;
              in_np_parity_err_f <= '0;
            end 
          else 
            begin
              
              if (pcputgnr | pcputhh)
                begin
                  outeom[PCEOM] <= eom;
                  outeom[0]     <= '0;
                  { outdata[PC1], outdata[0] } <= data;
                    if (pcxfr[0])// lintra s-60032
                      outparity <= in_pc_parity_err ? ~(^{data[XFR1+EXTMAXPLDBIT:XFR1], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR1+EXTMAXPLDBIT:XFR1], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                    else
                      outparity <= in_pc_parity_err ? ~(^{data[     EXTMAXPLDBIT:   0], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[     EXTMAXPLDBIT:   0], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;                  
                  in_pc_parity_err_f <= in_pc_parity_err & ~((pcxfr=='1) & eom);
                end
                
              if (npputgnr | npputhh)
                begin
                  outeom[NPEOM] <= eom;
                  outeom[0]     <= '0;
                  { outdata[NP1], outdata[0] } <= data;
                    if (npxfr[0]) // lintra s-60032
                      outparity <= in_np_parity_err ? ~(^{data[XFR1+EXTMAXPLDBIT:XFR1], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR1+EXTMAXPLDBIT:XFR1], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                    else
                      outparity <= in_np_parity_err ? ~(^{data[     EXTMAXPLDBIT:   0], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[     EXTMAXPLDBIT:   0], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                  in_np_parity_err_f <= in_np_parity_err & ~((npxfr=='1) & eom);
                end
              
              if (nxtpcput)
                begin
                  outeom[0] <= outeom[PCEOM] & (pcxfr=='1);
                  outdata[0] <= outdata[PC1];
                  outparity <= in_pc_parity_err_f ? ~(^{outdata[PC1], outeom[PCEOM] & (pcxfr=='1)}) & SB_PARITY_REQUIRED : (^{outdata[PC1], outeom[PCEOM] & (pcxfr=='1)}) & SB_PARITY_REQUIRED; 
                end
                
              if (nxtnpput)
                begin
                  outeom[0] <= outeom[NPEOM] & (npxfr=='1);
                  outdata[0] <= outdata[NP1];
                  outparity <= in_np_parity_err_f ? ~(^{outdata[NP1], outeom[NPEOM] & (npxfr=='1)}) & SB_PARITY_REQUIRED : (^{outdata[NP1], outeom[NPEOM] & (npxfr=='1)}) & SB_PARITY_REQUIRED;
                end
            end 
      end // block: gen_outdata_max2
    else if (MAXENTRY == 6)
      begin : gen_outdata_max6
        
        // Sideband Channel Output Flops
        always_ff @(posedge side_clk or negedge side_rst_b) 
          if (~side_rst_b) // lintra s-70023
            begin
              outdata <= '0;
              outeom  <= '0;
              outparity <= 1'b0;
              in_pc_parity_err_f <= '0;
              in_np_parity_err_f <= '0;
            end 
          else 
            begin
              
              if (pcputgnr | pcputhh)
                begin
                  outeom[PCEOM] <= eom;
                  outeom[0]     <= '0;
                  { outdata[PC3], outdata[PC2], outdata[PC1], outdata[0] } <= data;
                  casez (pcxfr) // lintra s-60129
                    2'b00 : outparity <= in_pc_parity_err ? ~(^{data[     EXTMAXPLDBIT:   0], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[     EXTMAXPLDBIT:   0], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                    2'b01 : outparity <= in_pc_parity_err ? ~(^{data[XFR1+EXTMAXPLDBIT:XFR1], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR1+EXTMAXPLDBIT:XFR1], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                    2'b10 : outparity <= in_pc_parity_err ? ~(^{data[XFR2+EXTMAXPLDBIT:XFR2], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR2+EXTMAXPLDBIT:XFR2], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                    2'b11 : outparity <= in_pc_parity_err ? ~(^{data[XFR3+EXTMAXPLDBIT:XFR3], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR3+EXTMAXPLDBIT:XFR3], ((pcxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                  endcase
                  in_pc_parity_err_f <= in_pc_parity_err & ~((pcxfr=='1) & eom);
                end
              
              if (npputgnr | npputhh)
                begin
                  outeom[NPEOM] <= eom;
                  outeom[0]     <= '0;
                  { outdata[NP3], outdata[NP2], outdata[NP1], outdata[0] } <= data;
                    casez (npxfr) // lintra s-60129
                      2'b00 : outparity <= in_np_parity_err ? ~(^{data[     EXTMAXPLDBIT:   0], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[     EXTMAXPLDBIT:   0], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                      2'b01 : outparity <= in_np_parity_err ? ~(^{data[XFR1+EXTMAXPLDBIT:XFR1], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR1+EXTMAXPLDBIT:XFR1], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                      2'b10 : outparity <= in_np_parity_err ? ~(^{data[XFR2+EXTMAXPLDBIT:XFR2], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR2+EXTMAXPLDBIT:XFR2], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                      2'b11 : outparity <= in_np_parity_err ? ~(^{data[XFR3+EXTMAXPLDBIT:XFR3], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED : (^{data[XFR3+EXTMAXPLDBIT:XFR3], ((npxfr=='1) & eom)}) & SB_PARITY_REQUIRED;
                    endcase
                  in_np_parity_err_f <= in_np_parity_err & ~((npxfr=='1) & eom);
                end
              
              if (nxtpcput)
                begin
                  outeom[0] <= outeom[PCEOM] & (pcxfr=='1);
                  casez (pcxfr) // lintra s-60129
                    2'b0? : outdata[0]  <= outdata[PC1];
                    2'b10 : outdata[0]  <= outdata[PC2];
                    2'b11 : outdata[0]  <= outdata[PC3];
                  endcase
                  casez (pcxfr) // lintra s-60129
                    2'b0? : outparity <= in_pc_parity_err_f ? ~(^{outdata[PC1], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[PC1], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED;
                    2'b10 : outparity <= in_pc_parity_err_f ? ~(^{outdata[PC2], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[PC2], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED;
                    2'b11 : outparity <= in_pc_parity_err_f ? ~(^{outdata[PC3], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[PC3], (outeom[PCEOM] & (pcxfr=='1))}) & SB_PARITY_REQUIRED;
                  endcase
                end
              
              if (nxtnpput)
                begin
                  outeom[0] <= outeom[NPEOM] & (npxfr=='1);
                  casez (npxfr) // lintra s-60129
                    2'b0? : outdata[0]  <= outdata[NP1];
                    2'b10 : outdata[0]  <= outdata[NP2];
                    2'b11 : outdata[0]  <= outdata[NP3];
                  endcase
                  casez (npxfr) // lintra s-60129
                     2'b0? : outparity <= in_np_parity_err_f ? ~(^{outdata[NP1], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[NP1], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED;
                     2'b10 : outparity <= in_np_parity_err_f ? ~(^{outdata[NP2], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[NP2], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED;
                     2'b11 : outparity <= in_np_parity_err_f ? ~(^{outdata[NP3], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED : (^{outdata[NP3], (outeom[NPEOM] & (npxfr=='1))}) & SB_PARITY_REQUIRED;
                  endcase
                end
            end 
      end // block: gen_outdata_max6
    
  endgenerate


// Adding flops on dbg signals that are generated as OR logic.
// Without flops, these may show up as downstream CDC errors
// e.g., see https://hsdes.intel.com/appstore/article/#/14012690954
// related to gen_dfx_tap[*].i_sbc_doublesync_tap_credavail_o
//
// // Debug signals
// always_comb dbgbus = { |pcxfr,
//                        |npxfr,
//                        |pccredits,
//                        |npcredits,
//                        mpcput_visa,
//                        mnpput_visa
//                      };

  // Debug signals

  always_ff @( posedge side_clk or negedge side_rst_b )
      if ( !side_rst_b ) begin
         pcxfrdbg     <= 1'b0;
         npxfrdbg     <= 1'b0;
         pccreditsdbg <= 1'b0;
         npcreditsdbg <= 1'b0;
      end else begin
         pcxfrdbg     <= |pcxfr;
         npxfrdbg     <= |npxfr;
         pccreditsdbg <= |pccredits;
         npcreditsdbg <= |npcredits;
      end

  always_comb dbgbus = { pcxfrdbg,
                         npxfrdbg,
                         pccreditsdbg,
                         npcreditsdbg,
                         mpcput_visa,
                         mnpput_visa
                       };

  // SV Assertions

`ifndef INTEL_SVA_OFF  
`ifndef IOSF_SB_ASSERT_OFF
   `ifdef INTEL_SIMONLY
   //`ifdef INTEL_INST_ON // SynTranlateOff
  //coverage off

  pccredit_overfow : // bjeassert
  assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
                   (&pccredits & mpccup & ~mpcput) |=> ( &pccredits || $past(credit_reinit) ) ) else
  $display("%0t: %m: ERROR: a maxed pccredit counter did not stay at max value when a cup was received without a put", $time);
  
  npcredit_overflow: // bjeassert
  assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
                   (&npcredits & mnpcup & ~mnpput) |=> ( &npcredits || $past(credit_reinit) ) ) else
  $display("%0t: %m: ERROR: a maxed npcredit counter did not stay at max value when a cup was received without a put", $time);
  
  
  //coverage on
   `endif // SynTranlateOn
`endif
`endif

  // lintra pop
    
endmodule
