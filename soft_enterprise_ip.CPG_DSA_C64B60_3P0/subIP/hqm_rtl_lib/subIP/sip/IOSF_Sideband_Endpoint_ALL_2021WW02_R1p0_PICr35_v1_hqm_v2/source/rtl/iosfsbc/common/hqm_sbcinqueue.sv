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
//  Module sbcinqueue : The ingress queues that are instantiated within the
//                      ingress block (sbcingress).  This block implements a
//                      basic queue and an accumulator output flop which
//                      changes the sideband payload width to the internal
//                      datapath width of the endpoint/router.
//
//------------------------------------------------------------------------------

// lintra push -60020, -60088, -80028, -68001, -68092, -60024b, -60024a
// lintra push -70036_simple

module hqm_sbcinqueue
#(
  parameter QUEUEDEPTH          =  3,
            EXTMAXPLDBIT        =  7,
            INTMAXPLDBIT        = 31,
            PCORNP              =  0,
            ENDPOINTONLY        =  0,
            RTR_SB_PARITY_REQUIRED = 0,
            SB_PARITY_REQUIRED  =  0,
            LATCHQUEUES         =  0,
            RELATIVE_PLACEMENT_EN = 0,
            GNR_HIER_FABRIC     =  0, // GNR Hierarchical Fabric
            GNR_GLOBAL_SEGMENT  =  0,
            GNR_HIER_BRIDGE_EN  =  0,
            GNR_16BIT_EP        =  0,
            GNR_8BIT_EP         =  0,
            GNR_RTR_SEGMENT_ID  = 8'd200,
            HIER_BRIDGE         =  0,
            HIER_BRIDGE_STRAP   =  0,  // Enable hier bridge select strap
            GLOBAL_RTR          =  0,  // set to 1 for global routers
            LOCAL2GLOBAL        =  0,  // set to 1 when the port is on global side of a local2global crossing
            SRCID_CK_EN         =  0   // Enable source id check for SAI tunneling
)(
  input  logic                  side_clk,        // Clock and reset signals
  input  logic                  side_rst_b,
  input  logic                  ism_active,
  output logic                  idle_inqueue,
  input  logic                  crdinit,
  output logic                  crdinitfc_done,
  input  logic                  credit_reinit,
  input  logic                  int_pok,         // Needed to know when to ignore credit conditions in idle state
  
  input  logic                  top_inmsg_put,       // Sideband Channel Interface
  input  logic                  nd_inmsg_put,    // Sideband Channel Interface - flopped version if PIPEINPS =1 
  input  logic                  raw_put,        //lintra s-70036, s-0527 input put not masked by parity error, used only for parity
  input  logic                  msgip,   //lintra s-70036, s-0527 used only when HIER_BRIDGE is set
  input  logic                  teom,
  input  logic                  tparity, //lintra s-70036, s-0527 used only for parity case
  input  logic [EXTMAXPLDBIT:0] tpayload,     
  output logic                  outmsg_cup,

  input  logic                  trdy,            // Interface to the decoder
  output logic                  irdy,            // block, target services and
  output logic                  dstvld,          // master completions
  output logic                  eom,
  output logic                  parity_out,
  output logic                  srcidck_err_out,
  output logic [INTMAXPLDBIT:0] data,

  input  logic                  cfg_parityckdef,  // lintra s-0527, s-70036 parity defeature
  input  logic                  cfg_srcidckdef,   // lintra s-0527, s-70036 SrcID check defeature
  input  logic [255:0]          srcid_portlist,   // lintra s-0527, s-70036 used only when SrcID check is enabled
  input  logic                  cfg_hierbridgeen, // lintra s-0527, s-70036 Used only for some ports on MI configs
  input  logic                  parity_err_in,
  output logic                  parity_err_out,
  input  logic                  dt_latchopen,     // lintra s-0527, s-70036
  input  logic                  dt_latchclosed_b, // lintra s-0527, s-70036
  output logic            [7:0] dbgbus
);

`include "hqm_sbcglobal_params.vm"
`include "hqm_sbcfunc.vm"

// PCR 58001 & 58002 - Increase the ingress queue depths means being more
// generic with the ingress queues. There should be no parameters dependent
// on inline if else trees. - START

// Maximum queue depth is 3 which is needed to enabled streaming.  This can
// be reduced to 2 if the connected egress port compiles with the parameter
// CUP2PUT1CYC=1. Maintain a reasonable credit value by bounding it.
localparam INGCREDITS   = sbc_bound_value( QUEUEDEPTH, 1, SBCMAXQUEUEDEPTH );

// Capture the in:out ratio for reworking the internal flits
localparam RATIO        = sbc_flit_ratio( (EXTMAXPLDBIT + 1), (INTMAXPLDBIT + 1) );

// Number of credits requested plus an overflow for capturing one complete internal flit
localparam INGQDEPTH    = ( INGCREDITS + RATIO - 1 );

// Max Entry is used for the reflection point in the queue
localparam INGQMAXENTRY = ( INGQDEPTH - 1 );

// # of Flits required for moving (1, 2, or 4) input flits to 1 output flit
localparam ACCUMDEPTH   = ( INGQDEPTH - INGCREDITS ); 

// Determine the number of write/read pointer bits
localparam MAXPTRBIT    = sbc_indexed_value( INGQDEPTH - 1 );

// Determine the number of bits for the counter that tracks the number
// of valid flits in the ingress queue
localparam MAXQCNTBIT   = sbc_indexed_value( INGQDEPTH );
                                                 
// Determine the number of bits needed to track the credits
localparam MAXCRDCNTBIT = sbc_bound_value(                     // Bound the values to be between 0 and SBCMAXCREDITCOUNTBIT
                              sbc_indexed_value( INGCREDITS ), // How many bits does it take to size the credits counter?
                              0,                               // Zero is the smallest size possible [0:0]
                              SBCMAXCREDITCOUNTBIT             // Maximum supported is still based on SBCMAXCREDITCOUNTBIT
                          );

// Determine the number of qcnt bits available over VISA, must saturate at 4 bits,
// otherwise it will not fit on the debug bus.
localparam DBGQCNTBIT   = sbc_bound_value( MAXQCNTBIT, 0, 3 );

// Local params used to make the lint tools happy
localparam logic [MAXQCNTBIT  :0] PUTCNT    = 1;
localparam logic [MAXQCNTBIT  :0] POPCNT    = RATIO;
localparam logic [MAXQCNTBIT  :0] PUTPOPCNT = RATIO-1;
localparam logic [MAXPTRBIT   :0] PTR1      = 1;

//localparam PARITYBITS = ENDPOINTONLY ? 2 : 0;// tparity input, parity_err input
localparam PARITYBITS = 1;// tparity input, parity_err input
localparam PLD0 = 0;
localparam EOM0 = PLD0 + EXTMAXPLDBIT + PARITYBITS + 1;
localparam PLD1 = ( RATIO == 1 ) ? 0 : ( EOM0 + 1 );
localparam EOM1 = PLD1 + EXTMAXPLDBIT + PARITYBITS + 1;
localparam PLD2 = ( RATIO == 4 ) ? ( EOM1 + 1 ) : PLD1;
localparam EOM2 = PLD2 + EXTMAXPLDBIT + PARITYBITS + 1;
localparam PLD3 = ( RATIO == 4 ) ? ( EOM2 + 1 ) : PLD2;
localparam EOM3 = PLD3 + EXTMAXPLDBIT + PARITYBITS + 1;

localparam USE_RPD = (INGQMAXENTRY >= RATIO) ? RELATIVE_PLACEMENT_EN : 0;

localparam SSF_GMCAST_RANGE_MIN = 8'd128;
localparam SSF_GMCAST_RANGE_MAX = 8'd146;

// PCR 58001 & 58002 - Increase the ingress queue depths means being more
// generic with the ingress queues. There should be no parameters dependent
// on inline if else trees. - FINISH

// Queue read/write pointers
logic [MAXPTRBIT :0] notused;
logic [MAXPTRBIT :0] wptr;
logic [MAXPTRBIT :0] rptr;
logic [MAXQCNTBIT:0] qcnt;
logic [MAXQCNTBIT:0] nxtqcnt;

logic pop;  
logic inmsg_put;

logic [INTMAXPLDBIT+RATIO+(PARITYBITS*RATIO):0]                 qout; // lintra s-70036
logic [INGQMAXENTRY:0][INTMAXPLDBIT+RATIO+(PARITYBITS*RATIO):0] readaccess; // lintra s-0531
logic [EXTMAXPLDBIT+1+PARITYBITS:0] qin;

// Credit update counter which indicates how many credit updates need to be
// sent.  The credit updates can only be stalled by the clock gating ISM.
logic [MAXQCNTBIT:0] cupsendcnt;
logic [MAXQCNTBIT:0] cupholdcnt;
logic [MAXQCNTBIT:0] cupholddec;
logic [MAXQCNTBIT:0] cupaccumcnt;
logic                accumulatorfull;
logic                nxtcup;
logic                nxtcup_parity;
logic                valid_data; // lintra s-70036
logic                msgipgnr;   // lintra s-70036

// PCR 58001 & 58002 - Place holder for the debug q count value, used for proper
// truncation on credit counters, they are now able to grow beyond the originally
// supported sizes.
logic [MAXQCNTBIT:0] dbgqcnt; // lintra s-70036
logic parity_err_gen_out;

logic return_credit; // lintra s-70036 used only when parity enabled
logic parity_err_cup_en;
logic ppp_cup;

// PARITY HANDLING
// if NP, enable cups only when no parity error (either input or after the inque (regenerated) for both RTR and EP
// if PC and if only ENDPOINT, always return cups, else for RTR only when no parity
always_comb return_credit = ~parity_err_in;
always_comb parity_err_cup_en = ((PCORNP) ? return_credit : ((ENDPOINTONLY) ? 1'b1 : return_credit));

//-------------------------------------
// Drop the hierarchical header section
//-------------------------------------
localparam XFRHBMAX = EXTMAXPLDBIT==31 ? 2 : EXTMAXPLDBIT==15 ? 3 : 5;
localparam XFRHBBIT = EXTMAXPLDBIT==31 ? 1 : EXTMAXPLDBIT==15 ? 1 : 2;
localparam XFRHBMAXGNR = EXTMAXPLDBIT==31 ? 3 : EXTMAXPLDBIT==15 ? 5 : 10;
localparam XFRHBBITGNR = EXTMAXPLDBIT==31 ? 1 : EXTMAXPLDBIT==15 ? 2 : 3;
localparam HIER_BRIDGE_GEN = HIER_BRIDGE_STRAP==1 ? 1 : HIER_BRIDGE;

logic [XFRHBBIT:0] xfrhb; // lintra s-70036, s-0531 used only when HIER_BRIDGE is set
logic inmsg_put_msk; // lintra s-70036 used only when HIER_BRIDGE is set
logic hier_bridge_en; // lintra s-70036 used only when HIER_BRIDGE is set

always_comb hier_bridge_en = (HIER_BRIDGE_STRAP == 1) ? cfg_hierbridgeen : 1'b1;

generate
   if (HIER_BRIDGE_GEN == 1) begin : gen_hier_bridge_msgip
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b )
            xfrhb   <= '0;
         else if (inmsg_put & ~msgip & hier_bridge_en)
            xfrhb <= 1;
         else if (inmsg_put & (xfrhb < XFRHBMAX) & hier_bridge_en)
            xfrhb <= xfrhb + 1; // lintra s-0393 s-0396
   end else begin : gen_hier_bridge_msgip
      always_comb xfrhb = '0;
   end
endgenerate

generate
   if ((HIER_BRIDGE_GEN == 1) & (EXTMAXPLDBIT == 31)) begin : gen_hier_bridge_31b
      always_comb inmsg_put_msk = inmsg_put & ~msgip & hier_bridge_en; 
   end else if ((HIER_BRIDGE_GEN == 1) & (EXTMAXPLDBIT == 15)) begin : gen_hier_bridge_16b
      always_comb inmsg_put_msk = inmsg_put & (~msgip | (xfrhb == 2'b01)) & hier_bridge_en; 
   end else if ((HIER_BRIDGE_GEN == 1) & (EXTMAXPLDBIT == 7)) begin : gen_hier_bridge_8b
      always_comb inmsg_put_msk = inmsg_put & (~msgip | (xfrhb == 3'b001) 
                                | (xfrhb == 3'b010) | (xfrhb == 3'b011)) & hier_bridge_en; 
   end else begin : gen_hier_bridge_bypass
      always_comb inmsg_put_msk = 1'b0;
   end
endgenerate

//------------------------------------------------------------------------------
// SAI tunneling
//------------------------------------------------------------------------------
  logic srcidck_err;

  generate
     if (SRCID_CK_EN & (EXTMAXPLDBIT == 7)) begin : gen_srcidck_err_8b
        logic srcidck_bit, msgipf;
        logic hier_srcid_ck, hier_srcid_ck_err, local_srcid_ck, local_srcid_ck_err;
        logic [2:0] msgcnt;
        logic [7:0] srcid_global;

        always_comb srcidck_bit = srcid_portlist[tpayload];
        always_ff @(posedge side_clk or negedge side_rst_b)
           if (!side_rst_b) msgipf <= 1'b0;
           else if (inmsg_put) msgipf <= msgip;
        
        if (GLOBAL_RTR) begin : gen_srcidck_err_8b_hier
           always_ff @(posedge side_clk or negedge side_rst_b)
              if (!side_rst_b) msgcnt <= '0;
              else if (~msgipf & msgip & inmsg_put) msgcnt <= '0;
              else if ((msgcnt <= 3'b100) & inmsg_put) msgcnt <= msgcnt + 3'b001;
           always_ff @(posedge side_clk or negedge side_rst_b)
              if (!side_rst_b) srcid_global <= '0;
              else if (~msgipf & msgip & inmsg_put) srcid_global <= tpayload;
        end else begin : gen_srcidck_err_8b_hier_def
           always_comb msgcnt = '0;
           always_comb srcid_global = '0;
        end

        always_comb local_srcid_ck = (msgcnt == 3'b011) & inmsg_put;
        always_comb local_srcid_ck_err = local_srcid_ck & (tpayload != srcid_global);

        always_comb hier_srcid_ck = ~msgipf & msgip & inmsg_put;
        always_comb hier_srcid_ck_err = hier_srcid_ck & ~srcidck_bit;

        always_comb srcidck_err = (hier_srcid_ck_err | local_srcid_ck_err) & ~cfg_srcidckdef;

     end else if ((SRCID_CK_EN == 1) & (EXTMAXPLDBIT != 7)) begin : gen_srcidck_err_16b
        logic srcidck_bit;
        logic hier_srcid_ck, hier_srcid_ck_err, local_srcid_ck, local_srcid_ck_err;
        logic [7:0] srcid_global;

        always_comb srcidck_bit = srcid_portlist[tpayload[15:8]];

        if (GLOBAL_RTR & (EXTMAXPLDBIT == 15)) begin : gen_srcidck_err_16b_hier
           logic [1:0] msgcnt;

           always_ff @(posedge side_clk or negedge side_rst_b)
              if (!side_rst_b) msgcnt <= '0;
              else if (~msgip & inmsg_put) msgcnt <= '0;
              else if ((msgcnt <= 2'b01) & inmsg_put) msgcnt <= msgcnt + 2'b01;

           always_comb local_srcid_ck = (msgcnt == 2'b01) & inmsg_put;

        end else if (GLOBAL_RTR & (EXTMAXPLDBIT == 31)) begin : gen_srcidck_err_32b_hier_def
           logic msgipf;
           always_ff @(posedge side_clk or negedge side_rst_b)
              if (!side_rst_b) msgipf <= 1'b0;
              else if (inmsg_put) msgipf <= msgip;

           always_comb local_srcid_ck = ~msgipf & msgip & inmsg_put;

        end else begin : gen_srcidck_err_16b_hier_def
           always_comb local_srcid_ck = '0;
        end

        if (GLOBAL_RTR) begin : gen_local_srcidck
           always_ff @(posedge side_clk or negedge side_rst_b)
              if (!side_rst_b) srcid_global <= '0;
              else if (~msgip & inmsg_put) srcid_global <= tpayload[15:8];
        end else begin : gen_local_srcidck_def
           always_comb srcid_global = '0;
        end

        if (GLOBAL_RTR & LOCAL2GLOBAL) begin : gen_l2g_bridgeidck
           always_comb local_srcid_ck_err = 1'b0;
        end else begin : gen_local_srcidck_en
           always_comb local_srcid_ck_err = local_srcid_ck & (tpayload[15:8] != srcid_global);
        end

        always_comb hier_srcid_ck = ~msgip & inmsg_put;
        always_comb hier_srcid_ck_err = hier_srcid_ck & ~srcidck_bit;

        always_comb srcidck_err = (hier_srcid_ck_err | local_srcid_ck_err) & ~cfg_srcidckdef;

     end else begin : gen_srcidck_err_bypass
        always_comb srcidck_err = 1'b0;
     end
  endgenerate


  generate
     if (SRCID_CK_EN) begin : gen_srcidck_err_out
        always_ff @( posedge side_clk or negedge side_rst_b )
           if (!side_rst_b) srcidck_err_out <= 1'b0;
           else srcidck_err_out <= srcidck_err | srcidck_err_out;
     end else begin : gen_srcidck_err_out_bypass 
        always_comb srcidck_err_out = 1'b0;
     end
  endgenerate
   

//---------------
// Queue pointers
//---------------
localparam DUMMYPOP = (PCORNP==0) & (SB_PARITY_REQUIRED ==1);


generate
    if (ENDPOINTONLY) begin : gen_forep
// if its PC (PCORNP=0) and if parity is enabled, do a dummy pop when there is a parity err, else follow legacy behavior
// Does DUMMY POP take effect for endpoint (parity error out is always 0 for EP) so the second or doesnt make sense)???        
        always_comb pop = (DUMMYPOP == 1) ? ((irdy & trdy) | (valid_data & parity_err_out)) : (irdy & trdy);
    
        if (PCORNP==0) begin : gen_pc
            logic parity_err_in_f, parity_err_pulse;
            logic [4:0] ppp_cnt, crd_cnt;
            logic out_cup;
            always_comb begin
                parity_err_pulse= parity_err_in & ~parity_err_in_f;
           // cups (for puts) can be asserted only after ISM reaches active state
                ppp_cup         = (parity_err_in_f & ism_active) ? |(ppp_cnt) : '0;
                out_cup         = outmsg_cup & ism_active;
           // copy nxtcup for parity credit returns valid only till parity _err_in
                nxtcup_parity   = (parity_err_in & ism_active) ? 0 : nxtcup;
            end
            always_ff @(posedge side_clk or negedge side_rst_b) begin
                if (!side_rst_b) begin
// while the pending credits in the sbcinqueue are being returned, there could be puts happening (also for which credits will need to be returned
// post parity puts (ppp) counter will keep track of those many puts
                   parity_err_in_f      <= '0;
                   crd_cnt              <= '0;
                   ppp_cnt              <= '0;
                end
                else begin
// used to create the pulse to capture the pending credits and to mux the ppp (post parity error puts) credit returns
                    parity_err_in_f  <= parity_err_in;
// credit counter to track pending credits in the inqueue before the parity error
// inmsg put stops exactly at parity err so we dont count extra puts
                    if (~parity_err_in) begin
                        casez ({inmsg_put,out_cup})
                            2'b00: crd_cnt <= crd_cnt;
                            2'b01: crd_cnt <= crd_cnt - 1;
                            2'b10: crd_cnt <= crd_cnt + 1;
                            2'b11: crd_cnt <= crd_cnt;
                          default: crd_cnt <= crd_cnt;
                        endcase
                    end else begin
                        crd_cnt <= crd_cnt;
                    end
// Load the pending credit counter and compensate for the put that happens on the same cycle as parity err
// out cup is the almost the final cup output (tppcup). counting that to know how many credits were returned
                    if (parity_err_pulse) begin
                        casez ({raw_put, out_cup})
                            2'b00: ppp_cnt <= ppp_cnt + crd_cnt;
                            2'b01: ppp_cnt <= ppp_cnt + crd_cnt - 1;
                            2'b10: ppp_cnt <= ppp_cnt + crd_cnt + 1;
                            2'b11: ppp_cnt <= ppp_cnt + crd_cnt;
                          default: ppp_cnt <= ppp_cnt;
                        endcase
                    end
                    else if (parity_err_in) begin // if parity_err_in
                        casez ({raw_put, ppp_cup})
                            2'b00: ppp_cnt <= ppp_cnt;                // neither increment or decrement
                            2'b01: ppp_cnt <= ppp_cnt - 1;            // only ppp_cup, so -1
                            2'b10: ppp_cnt <= ppp_cnt + 1;            // only put, so +1    
                            2'b11: ppp_cnt <= ppp_cnt;                // neither increment nor decrement
                          default: ppp_cnt <= ppp_cnt;
                        endcase
                    end // parity_err_in
                end // else rst
            end // always_ff
        end // PC
        else begin : gen_np
            always_comb begin
                ppp_cup         = '0;
                nxtcup_parity   = nxtcup;
            end
        end
    end
    else begin : gen_forrtr
        always_comb begin
            pop             = (irdy & trdy);
            ppp_cup         = '0;
            nxtcup_parity   = nxtcup;
        end
    end
endgenerate

always_comb begin
  casez ( { pop, inmsg_put & ~inmsg_put_msk } ) // lintra s-60129
    2'b00   : nxtqcnt = qcnt;
    2'b01   : nxtqcnt = qcnt + PUTCNT;
    2'b10   : nxtqcnt = qcnt - POPCNT;
    2'b11   : nxtqcnt = qcnt - PUTPOPCNT;
    default : nxtqcnt = qcnt;
  endcase
end

always_ff @(posedge side_clk or negedge side_rst_b) begin
  if( !side_rst_b ) begin // lintra s-70023
    wptr <= '0;
    rptr <= '0;
    qcnt <= '0;
  end else begin
 // cannot reset qcnt after parity_err_gen_out (its too late by that time
 // irdy is already sent out
    if (inmsg_put & ~inmsg_put_msk) wptr <= (wptr == INGQMAXENTRY) ? '0 : (wptr + PTR1);
// block anything from being read out of que as soon as its detected to be erroneus
// also once parity error is set, mask any further irdy's
    if (pop)       rptr <= (rptr == INGQMAXENTRY) ? '0 : (rptr + PTR1);
    qcnt <= nxtqcnt;  
  end
end
// similar to irdy equation
always_comb valid_data = |(qcnt >> (RATIO==4 ? 2 : RATIO-1));

//------------------------------------------------------------------------------
//
// The ingress queue storage elements
//
//------------------------------------------------------------------------------

always_comb notused = '0;

logic tparity_in;  //lintra s-70036, s-0527 not used for GNR/SSF scaling
generate
// if the port doesnt support parity but if the rtr supports parity then generate correct parity to be written to the queue
    if ((SB_PARITY_REQUIRED == 0) && (|RTR_SB_PARITY_REQUIRED == 1) && (GNR_HIER_FABRIC == 0)) begin: gen_rtr_only_parity
        always_comb tparity_in = (inmsg_put & ~inmsg_put_msk) ? ^ {tpayload, teom} : '0;
    end
    else if ((SB_PARITY_REQUIRED == 0) && (|RTR_SB_PARITY_REQUIRED == 1) && (GNR_HIER_FABRIC == 1)) begin : gen_rtr_only_parity_gnr
        always_comb tparity_in = top_inmsg_put ? ^ {tpayload, teom} : '0;
    end
    else if (|SB_PARITY_REQUIRED == 1) begin : gen_port_parity_enabled
        always_comb tparity_in =  tparity;
    end
    else begin : gen_noport_nortr_parity
        always_comb tparity_in = '0;
    end
endgenerate


//always_comb qin = { teom, tparity_in, tpayload };

generate 
   if ((GNR_HIER_FABRIC == 1) & (GNR_GLOBAL_SEGMENT == 0) & ((GNR_16BIT_EP == 1) | (GNR_HIER_BRIDGE_EN == 1))) begin : gen_gnr

      logic [XFRHBBITGNR:0] xfrgnr; 
      logic [7:0] gnr_segment_id;

      always_comb msgipgnr = msgip;
      always_comb gnr_segment_id = GNR_RTR_SEGMENT_ID;

      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b )
            xfrgnr   <= '0;
         else if (top_inmsg_put & msgip & teom)
            xfrgnr   <= '0;
         else if (top_inmsg_put & ~msgip)
            xfrgnr <= 1;
         else if (top_inmsg_put & (xfrgnr < XFRHBMAXGNR))
            xfrgnr <= xfrgnr + 1; // lintra s-0393 s-0396


      if (EXTMAXPLDBIT == 31) begin : gen_gnr32b

          logic [EXTMAXPLDBIT:0] tpayload_ff1, tpayload_ff2; // lintra s-70036
          logic [EXTMAXPLDBIT:0] tpayload_f1, tpayload_f2;
          logic teom_ff1, tparity_ff1, puteom, puteom_f2;
          logic flit1, flit2;

          always_ff @( posedge side_clk or negedge side_rst_b )
             if (!side_rst_b) begin
                tpayload_ff1 <= '0;
                tpayload_ff2 <= '0;
                teom_ff1 <= 1'b0;
                tparity_ff1 <= 1'b0;
             end else if (top_inmsg_put) begin
                tpayload_ff1 <= tpayload;
                tpayload_ff2 <= tpayload_ff1;
                teom_ff1 <= teom;
                tparity_ff1 <= tparity_in;
             end

          always_ff @( posedge side_clk or negedge side_rst_b )
             if (!side_rst_b) begin
                puteom <= 1'b0;
                puteom_f2 <= 1'b0;
             end else begin
                puteom <= top_inmsg_put & teom;
                puteom_f2 <= top_inmsg_put & teom & (xfrgnr == 2'b01);
             end

          always_comb flit1 = (top_inmsg_put & (xfrgnr == 2'b01));
          always_comb flit2 = (top_inmsg_put & (xfrgnr == 2'b10)) | puteom_f2;

          always_comb qin =   flit1 ? {teom_ff1,^{teom_ff1,tpayload_f1},tpayload_f1}
                          : ( flit2 ? {teom_ff1,^{teom_ff1,tpayload_f2},tpayload_f2}
                            : {teom_ff1,tparity_ff1,tpayload_ff1} );

          always_comb inmsg_put = (top_inmsg_put & (xfrgnr == 2'b01))
                                | (top_inmsg_put & (xfrgnr >= 2'b10)) | puteom;


          if (GNR_16BIT_EP == 1) begin : gen_gnr32b_16bep

             // EP: dst swap - if (128 <= dstSeg field <= 146) 
             //                   | (dstSeg field == localSegmentID)
             // EP: src swap - always
             
             logic [7:0] dst_f1, dst_f2;
             logic f1dstswp, f2dstswp;
             logic f1dstswpc, f2dstswpc;

             always_comb begin
                f1dstswp =   (tpayload_ff1[7:0] == gnr_segment_id)
                         | ( (tpayload_ff1[7:0] >= SSF_GMCAST_RANGE_MIN)
                           & (tpayload_ff1[7:0] <= SSF_GMCAST_RANGE_MAX) );
                f2dstswp =   (tpayload_ff2[7:0] == gnr_segment_id)
                         | ( (tpayload_ff2[7:0] >= SSF_GMCAST_RANGE_MIN)
                           & (tpayload_ff2[7:0] <= SSF_GMCAST_RANGE_MAX) );
                f1dstswpc =  (top_inmsg_put & (xfrgnr == 2'b01))              & f1dstswp;
                f2dstswpc = ((top_inmsg_put & (xfrgnr == 2'b10)) | puteom_f2) & f2dstswp;

                dst_f1 = f1dstswpc ? tpayload[7:0]     : tpayload_ff1[7:0];
                dst_f2 = f2dstswpc ? tpayload_ff2[7:0] : tpayload_ff1[7:0];

                tpayload_f1 = {tpayload_ff1[31:16],tpayload[15:8],dst_f1};
                tpayload_f2 = {tpayload_ff1[31:16],tpayload_ff2[15:8],dst_f2};
             end

          end else if ((GNR_GLOBAL_SEGMENT == 1) && (GNR_HIER_BRIDGE_EN == 1)) begin : gen_gnr32b_l2g

             always_comb tpayload_f1 = {tpayload_ff1[31:16],tpayload[15:8],tpayload_ff1[7:0]};
             always_comb tpayload_f2 = {tpayload_ff1[31:16],tpayload_ff2[15:8],tpayload_ff1[7:0]};

          end else if ((GNR_GLOBAL_SEGMENT == 0) && (GNR_HIER_BRIDGE_EN == 1)) begin : gen_gnr32b_g2l

             // G2L: dst swap - always
             // G2L: src swap - if (128 <= srcSeg field <= 146)
              
             logic [7:0] src_f1, src_f2;
             logic f1srcswp, f2srcswp;
             logic f1srcswpc, f2srcswpc;

             always_comb begin
                f1srcswp  = (tpayload_ff1[15:8] >= SSF_GMCAST_RANGE_MIN)
                          & (tpayload_ff1[15:8] <= SSF_GMCAST_RANGE_MAX);
                f2srcswp  = (tpayload_ff2[15:8] >= SSF_GMCAST_RANGE_MIN)
                          & (tpayload_ff2[15:8] <= SSF_GMCAST_RANGE_MAX);
                f1srcswpc =  (top_inmsg_put & (xfrgnr == 2'b01))              & f1srcswp;
                f2srcswpc = ((top_inmsg_put & (xfrgnr == 2'b10)) | puteom_f2) & f2srcswp;

                src_f1 = f1srcswpc ? tpayload[15:8]     : tpayload_ff1[15:8];
                src_f2 = f2srcswpc ? tpayload_ff2[15:8] : tpayload_ff1[15:8];

                tpayload_f1 = {tpayload_ff1[31:16],src_f1,tpayload[7:0]};
                tpayload_f2 = {tpayload_ff1[31:16],src_f2,tpayload_ff2[7:0]};
             end
          end

      end else if (EXTMAXPLDBIT == 15) begin : gen_gnr16b

          logic [EXTMAXPLDBIT:0] tpayload_ff1, tpayload_ff2, tpayload_ff3, tpayload_ff4;
          logic [EXTMAXPLDBIT:0] tpayload_f1, tpayload_f3;
          logic teom_ff1, teom_ff2, tparity_ff1, tparity_ff2, puteom, puteom_ff, puteom_f3;
          logic flit1, flit3;

          always_ff @( posedge side_clk or negedge side_rst_b )
             if (!side_rst_b) begin
                tpayload_ff1 <= '0;
                tpayload_ff2 <= '0;
                tpayload_ff3 <= '0;
                tpayload_ff4 <= '0;
                teom_ff1 <= 1'b0;
                teom_ff2 <= 1'b0;
                tparity_ff1 <= 1'b0;
                tparity_ff2 <= 1'b0;
             end else if (top_inmsg_put | puteom) begin
                tpayload_ff1 <= tpayload;
                tpayload_ff2 <= tpayload_ff1;
                tpayload_ff3 <= tpayload_ff2;
                tpayload_ff4 <= tpayload_ff3;
                teom_ff1 <= teom;
                teom_ff2 <= teom_ff1;
                tparity_ff1 <= tparity_in;
                tparity_ff2 <= tparity_ff1;
             end

          always_ff @( posedge side_clk or negedge side_rst_b )
             if (!side_rst_b) begin
                puteom <= 1'b0;
                puteom_ff <= 1'b0;
                puteom_f3 <= 1'b0;
             end else begin
                puteom <= top_inmsg_put & teom;
                puteom_ff <= puteom;
                puteom_f3 <= top_inmsg_put & teom & (xfrgnr == 3'b011);
             end

          always_comb flit1 = (top_inmsg_put & (xfrgnr == 3'b010));
          always_comb flit3 = (top_inmsg_put & (xfrgnr == 3'b100)) | puteom_f3;

          always_comb qin =   flit1 ? {teom_ff2,^{teom_ff2,tpayload_f1},tpayload_f1}
                          : ( flit3 ? {teom_ff2,^{teom_ff2,tpayload_f3},tpayload_f3}
                            : {teom_ff2,tparity_ff2,tpayload_ff2} );

          always_comb inmsg_put = (top_inmsg_put & (xfrgnr >= 3'b010)) | puteom | puteom_ff;

          if (GNR_16BIT_EP == 1) begin : gen_gnr16b_16bep
             
             // EP: dst swap - if (128 <= dstSeg field <= 146) 
             //                   | (dstSeg field == localSegmentID)
             // EP: src swap - always

             logic [7:0] dst_f1, dst_f3;
             logic f1dstswp, f3dstswp;
             logic f1dstswpc, f3dstswpc;

             always_comb begin
                f1dstswp =   (tpayload_ff2[7:0] == gnr_segment_id)
                         | ( (tpayload_ff2[7:0] >= SSF_GMCAST_RANGE_MIN)
                           & (tpayload_ff2[7:0] <= SSF_GMCAST_RANGE_MAX) );
                f3dstswp =   (tpayload_ff4[7:0] == gnr_segment_id)
                         | ( (tpayload_ff4[7:0] >= SSF_GMCAST_RANGE_MIN)
                           & (tpayload_ff4[7:0] <= SSF_GMCAST_RANGE_MAX) );
                f1dstswpc =  (top_inmsg_put & (xfrgnr == 3'b010))              & f1dstswp;
                f3dstswpc = ((top_inmsg_put & (xfrgnr == 3'b100)) | puteom_f3) & f3dstswp;

                dst_f1 = f1dstswpc ? tpayload[7:0]     : tpayload_ff2[7:0];
                dst_f3 = f3dstswpc ? tpayload_ff4[7:0] : tpayload_ff2[7:0];

                tpayload_f1 = {tpayload[15:8],dst_f1};
                tpayload_f3 = {tpayload_ff4[15:8],dst_f3};
             end

          end else if ((GNR_GLOBAL_SEGMENT == 1) && (GNR_HIER_BRIDGE_EN == 1)) begin : gen_gnr16b_l2g

             always_comb tpayload_f1 = {tpayload[15:8],tpayload_ff2[7:0]};
             always_comb tpayload_f3 = {tpayload_ff4[15:8],tpayload_ff2[7:0]};

          end else if ((GNR_GLOBAL_SEGMENT == 0) && (GNR_HIER_BRIDGE_EN == 1)) begin : gen_gnr16b_g2l

             // G2L: dst swap - always
             // G2L: src swap - if (128 <= srcSeg field <= 146)

             logic [7:0] src_f1, src_f3;
             logic f1srcswp, f3srcswp;
             logic f1srcswpc, f3srcswpc;

             always_comb begin
                f1srcswp  = (tpayload_ff2[15:8] >= SSF_GMCAST_RANGE_MIN)
                          & (tpayload_ff2[15:8] <= SSF_GMCAST_RANGE_MAX);
                f3srcswp  = (tpayload_ff4[15:8] >= SSF_GMCAST_RANGE_MIN)
                          & (tpayload_ff4[15:8] <= SSF_GMCAST_RANGE_MAX);
                f1srcswpc =  (top_inmsg_put & (xfrgnr == 3'b010))              & f1srcswp;
                f3srcswpc = ((top_inmsg_put & (xfrgnr == 3'b100)) | puteom_f3) & f3srcswp;

                src_f1 = f1srcswpc ? tpayload[15:8]     : tpayload_ff2[15:8];
                src_f3 = f3srcswpc ? tpayload_ff4[15:8] : tpayload_ff2[15:8];

                tpayload_f1 = {src_f1,tpayload[7:0]};
                tpayload_f3 = {src_f3,tpayload_ff4[7:0]};
             end

          end

      end else begin : gen_gnr8b

          logic [EXTMAXPLDBIT+2:0] tpayload_ff1, tpayload_ff2, tpayload_ff3, tpayload_ff4;
          logic [EXTMAXPLDBIT+2:0] tpayload_ff5, tpayload_ff6, tpayload_ff7, tpayload_ff8;
          logic [EXTMAXPLDBIT+2:0] tpayloadq;
          logic [EXTMAXPLDBIT+2:0] tpayload_f1, tpayload_f2, tpayload_f5, tpayload_f6;
          logic puteom, puteom_ff1, puteom_ff2, puteom_ff3, puteom_f7, puteom_f8;
          logic flit1, flit2, flit5, flit6;

          always_comb tpayloadq = {teom,tparity_in,tpayload};

          always_ff @( posedge side_clk or negedge side_rst_b )
             if (!side_rst_b) begin
                tpayload_ff1  <= '0;
             end else if (top_inmsg_put) begin
                tpayload_ff1  <= tpayloadq;
             end

          always_ff @( posedge side_clk or negedge side_rst_b )
             if (!side_rst_b) begin
                tpayload_ff2  <= '0;
             end else if (top_inmsg_put | puteom) begin
                tpayload_ff2  <= tpayload_ff1;
             end

          always_ff @( posedge side_clk or negedge side_rst_b )
             if (!side_rst_b) begin
                tpayload_ff3  <= '0;
             end else if (top_inmsg_put | puteom | puteom_ff1) begin
                tpayload_ff3  <= tpayload_ff2;
             end

          always_ff @( posedge side_clk or negedge side_rst_b )
             if (!side_rst_b) begin
                tpayload_ff4  <= '0;
             end else if (top_inmsg_put | puteom | puteom_ff1 | puteom_ff2) begin
                tpayload_ff4  <= tpayload_ff3;
             end

          always_ff @( posedge side_clk or negedge side_rst_b )
             if (!side_rst_b) begin
                tpayload_ff5  <= '0;
                tpayload_ff6  <= '0;
                tpayload_ff7  <= '0;
                tpayload_ff8  <= '0;
             end else if (top_inmsg_put | puteom | puteom_ff1 | puteom_ff2 | puteom_ff3) begin
                tpayload_ff5  <= tpayload_ff4;
                tpayload_ff6  <= tpayload_ff5;
                tpayload_ff7  <= tpayload_ff6;
                tpayload_ff8  <= tpayload_ff7;
             end

          always_ff @( posedge side_clk or negedge side_rst_b )
             if (!side_rst_b) begin
                puteom <= 1'b0;
                puteom_ff1 <= 1'b0;
                puteom_ff2 <= 1'b0;
                puteom_ff3 <= 1'b0;
                puteom_f7 <= 1'b0;
                puteom_f8 <= 1'b0;
             end else begin
                puteom <= top_inmsg_put & teom;
                puteom_ff1 <= puteom;
                puteom_ff2 <= puteom_ff1;
                puteom_ff3 <= puteom_ff2;
                puteom_f7 <= top_inmsg_put & teom & (xfrgnr == 4'b0111);
                puteom_f8 <= puteom_f7;
             end

          always_comb flit1 = (top_inmsg_put & (xfrgnr == 4'b0100));
          always_comb flit2 = (top_inmsg_put & (xfrgnr == 4'b0101));
          always_comb flit5 = (top_inmsg_put & (xfrgnr == 4'b1000)) | puteom_f7;
          always_comb flit6 = (top_inmsg_put & (xfrgnr == 4'b1001)) | puteom_f8;

          always_comb qin =   flit1 ? tpayload_f1 
                          : ( flit2 ? tpayload_f2
                          : ( flit5 ? tpayload_f5
                          : ( flit6 ? tpayload_f6 : tpayload_ff4 )));

          always_comb inmsg_put = (top_inmsg_put & (xfrgnr >= 4'b0100)) | puteom | puteom_ff1 | puteom_ff2 | puteom_ff3;

          if (GNR_16BIT_EP == 1) begin : gen_gnr8b_16bep

             // EP: dst swap - if (128 <= dstSeg field <= 146) 
             //                   | (dstSeg field == localSegmentID)
             // EP: src swap - always
             
             logic f1dstswp, f5dstswp;
             logic f1dstswpc, f5dstswpc;
             
             always_comb begin
                f1dstswp =   (tpayload_ff4[7:0] == gnr_segment_id)
                         | ( (tpayload_ff4[7:0] >= SSF_GMCAST_RANGE_MIN)
                           & (tpayload_ff4[7:0] <= SSF_GMCAST_RANGE_MAX) );
                f5dstswp =   (tpayload_ff8[7:0] == gnr_segment_id)
                         | ( (tpayload_ff8[7:0] >= SSF_GMCAST_RANGE_MIN)
                           & (tpayload_ff8[7:0] <= SSF_GMCAST_RANGE_MAX) );
             end

             always_comb begin
                f1dstswpc =  (top_inmsg_put & (xfrgnr == 4'b0100))              & f1dstswp;
                f5dstswpc = ((top_inmsg_put & (xfrgnr == 4'b1000)) | puteom_f7) & f5dstswp;
             end

             always_comb begin
                tpayload_f1 = f1dstswpc ? tpayloadq    : tpayload_ff4;
                tpayload_f2 = tpayloadq;
                tpayload_f5 = f5dstswpc ? tpayload_ff8 : tpayload_ff4;
                tpayload_f6 = tpayload_ff8;
             end

          end else if ((GNR_GLOBAL_SEGMENT == 1) && (GNR_HIER_BRIDGE_EN == 1)) begin : gen_gnr8b_l2g

             always_comb tpayload_f1 = tpayload_ff4;
             always_comb tpayload_f2 = tpayloadq;
             always_comb tpayload_f5 = tpayload_ff4;
             always_comb tpayload_f6 = tpayload_ff8;

          end else if ((GNR_GLOBAL_SEGMENT == 0) && (GNR_HIER_BRIDGE_EN == 1)) begin : gen_gnr8b_g2l

             // G2L: dst swap - always
             // G2L: src swap - if (128 <= srcSeg field <= 146)
             
             logic f1srcswp, f5srcswp;
             logic f1srcswpc, f5srcswpc;
             
             always_comb begin
                f1srcswp  = (tpayload_ff4[7:0] >= SSF_GMCAST_RANGE_MIN)
                          & (tpayload_ff4[7:0] <= SSF_GMCAST_RANGE_MAX);
                f5srcswp  = (tpayload_ff8[7:0] >= SSF_GMCAST_RANGE_MIN)
                          & (tpayload_ff8[7:0] <= SSF_GMCAST_RANGE_MAX);
             end

             always_comb begin
                f1srcswpc =  (top_inmsg_put & (xfrgnr == 4'b0101))              & f1srcswp;
                f5srcswpc = ((top_inmsg_put & (xfrgnr == 4'b1001)) | puteom_f8) & f5srcswp;
             end

             always_comb begin
                tpayload_f1 = tpayloadq;
                tpayload_f2 = f1srcswpc ? tpayloadq    : tpayload_ff4;
                tpayload_f5 = tpayload_ff8;
                tpayload_f6 = f5srcswpc ? tpayload_ff8 : tpayload_ff4;
             end

          end
      end

   end else begin : gen_nognr
      always_comb msgipgnr = 1'b0;
      always_comb inmsg_put = top_inmsg_put;
      always_comb qin = { teom, tparity_in, tpayload };
   end
endgenerate


generate
if (USE_RPD) begin : rp_based_impl
    parameter ONE_HOT_RPTR_WIDTH    = INGQMAXENTRY+1;
    //parameter ONE_HOT_READ = (USE_RPD == 1 && RATIO > 1) ? 1 : 0;
    parameter ONE_HOT_READ          = 1;
    parameter VRAM_READ_WIDTH       = (ONE_HOT_READ == 1) ? ONE_HOT_RPTR_WIDTH : EXTMAXPLDBIT+2+PARITYBITS;
    parameter NUM_WR_PORTS          = 1;
    parameter NUM_RD_PORTS          = RATIO;
    
    logic [EXTMAXPLDBIT+2+PARITYBITS-1:0]   vram_write_data             [NUM_WR_PORTS-1:0];
    logic [EXTMAXPLDBIT+2+PARITYBITS-1:0]   vram_read_data              [NUM_RD_PORTS-1:0];
    logic                                   vram_write_enable           [NUM_WR_PORTS-1:0];
    logic [MAXPTRBIT:0]                     vram_write_address          [NUM_WR_PORTS-1:0];
    logic [VRAM_READ_WIDTH-1:0]             vram_read_address           [NUM_RD_PORTS-1:0];
    logic [ONE_HOT_RPTR_WIDTH-1:0]          rptr_rp;

    always_comb vram_write_data[0] = qin;
    always_comb vram_write_enable[0] = inmsg_put & ~inmsg_put_msk;
    always_comb vram_write_address[0] = wptr;

    always_ff @(posedge side_clk or negedge side_rst_b) begin
        if( !side_rst_b ) begin // lintra s-70023
            rptr_rp <= 'b1;
        end else begin
            if (ONE_HOT_READ == 1) begin
                if (pop) rptr_rp <= {rptr_rp[ONE_HOT_RPTR_WIDTH-RATIO-1:0], rptr_rp[ONE_HOT_RPTR_WIDTH-1:ONE_HOT_RPTR_WIDTH-RATIO]};
            end
        end
    end
        
    if (ONE_HOT_READ == 1) begin : one_hot_read_vars
        if (RATIO == 1) begin : rd_port_1
            always_comb vram_read_address[0] = rptr_rp;
        end
        if (RATIO == 2) begin : rd_port_2
            always_comb vram_read_address[0] = rptr_rp;
            always_comb vram_read_address[1] = {vram_read_address[0][ONE_HOT_RPTR_WIDTH-2:0], vram_read_address[0][ONE_HOT_RPTR_WIDTH-1]};
        end
        if (RATIO == 4) begin : rd_port_4
            always_comb vram_read_address[0] = rptr_rp;
            always_comb vram_read_address[1] = {vram_read_address[0][ONE_HOT_RPTR_WIDTH-2:0], vram_read_address[0][ONE_HOT_RPTR_WIDTH-1]};
            always_comb vram_read_address[2] = {vram_read_address[1][ONE_HOT_RPTR_WIDTH-2:0], vram_read_address[1][ONE_HOT_RPTR_WIDTH-1]};
            always_comb vram_read_address[3] = {vram_read_address[2][ONE_HOT_RPTR_WIDTH-2:0], vram_read_address[2][ONE_HOT_RPTR_WIDTH-1]};
        end
    end else begin : regular_read_vars
        if (RATIO == 1) begin : rd_port_1
            always_comb vram_read_address[0] = rptr;
        end
        if (RATIO == 2) begin : rd_port_2
            always_comb vram_read_address[0] = (rptr<<1)%(INGQMAXENTRY+1);
            always_comb vram_read_address[1] = ((rptr<<1)+1)%(INGQMAXENTRY+1);
        end
        if (RATIO == 4) begin : rd_port_4
            always_comb vram_read_address[0] = ((rptr<<2))%(INGQMAXENTRY+1);
            always_comb vram_read_address[1] = ((rptr<<2)+1)%(INGQMAXENTRY+1);
            always_comb vram_read_address[2] = ((rptr<<2)+2)%(INGQMAXENTRY+1);
            always_comb vram_read_address[3] = ((rptr<<2)+3)%(INGQMAXENTRY+1);
        end
    end
    //always_comb read_data1_pre = vram_read_data[0];
    hqm_sb_genram_vram_spr
      #(
            .width                  ( EXTMAXPLDBIT+2+PARITYBITS ),
            .depth                  ( INGQMAXENTRY+1            ),
            .num_rd_ports           ( RATIO                     ),
            .num_wr_ports           ( 1                         ),
            .byte_enable_count      ( 1                         ),
            .use_preflops           ( 0                         ),
            .latch_based            ( LATCHQUEUES               ),
            .sync_reset_enable      ( 0                         ),
            .async_reset_enable     ( 1-LATCHQUEUES             ),
            .svdump_en              ( 0                         ),
            .use_storage_data       ( 0                         ),
            .one_hot_rd_ptrs        ( ONE_HOT_READ              )
       )
    i_vram2 
       (
            .vram_clock             ( side_clk                  ),
            .sync_vram_reset_b      (                           ), // lintra s-0214
            .async_vram_reset_b     ( side_rst_b                ),
            .write_data             ( vram_write_data           ),
            .write_enable           ( vram_write_enable         ),
            .write_byte_enable      (                           ), // lintra s-0214
            .write_address          ( vram_write_address        ),
            .read_address           ( vram_read_address         ),
            .dt_latchopen           ( dt_latchopen              ),
            .dt_latchclosed_b       ( dt_latchclosed_b          ),
            .read_data              ( vram_read_data            ),
            .write_data_flopped     (                           ), // lintra s-0214
            .data_memory            (                           )  // lintra s-0214
        );
  if (RATIO == 4) begin : gen_latch_rdacs4
     always_comb qout = {vram_read_data[3], vram_read_data[2], vram_read_data[1], vram_read_data[0]};
  end else if (RATIO == 2) begin : gen_latch_rdacs2
     always_comb qout = {vram_read_data[1], vram_read_data[0]};
  end else begin : gen_latch_rdacs1
     always_comb qout = vram_read_data[0];
  end //rp_impl
end else begin : non_rp_based_impl
  if (LATCHQUEUES==1) begin : gen_latch_queue3
      
      logic [INGQMAXENTRY:0][EXTMAXPLDBIT+1+ PARITYBITS:0] queuedata;
      logic write_enable;

      always_comb write_enable = inmsg_put & ~inmsg_put_msk;
      
      //--------------------------------------------------------------------------
      //
      // VRAM2 Instantiation:  Latched based queues
      //
      //--------------------------------------------------------------------------
      hqm_sbcvram2 #( // lintra s-80018
         .width               ( EXTMAXPLDBIT+2+PARITYBITS   ),
         .depth               ( INGQMAXENTRY+1   ),
         .address_size        ( MAXPTRBIT+1      ),
         .write_enable_count  ( 1                ),  // 1 = Number of write enables
         .use_ports           ( 0                ),  // 0 = No read addr decoders
         .use_preflops        ( 0                ),  // 0 = No pre-flops
         .use_gated_cell      ( 3                ),  // 3 = gb03
         .vram_reset_enable   ( 0                ),
         .latch_reset_enable  ( 1                )
      ) sbcvram2 (                                 
         .vram_clock          ( side_clk         ),
         .vram_reset_b        ( 1'b1             ),
         .write_data          ( qin              ),
         .write_enable        ( write_enable     ),
         .write_byte_enable   ( 1'b1             ),
         .write_address       ( wptr             ),
         .read_address1       ( notused          ),
         .read_address2       ( notused          ),
         .dt_latchopen        ( dt_latchopen     ),
         .dt_latchclosed_b    ( dt_latchclosed_b ),
         .dt_ramrst_b         ( 1'b1             ),
         .read_data1          (                  ), // lintra s-0214
         .read_data2          (                  ), // lintra s-0214
         .write_data_flopped  (                  ), // lintra s-0214
         .data_memory         ( queuedata        )
      );

      if (RATIO == 4) begin : gen_latch_rdacs4
         always_comb readaccess = {queuedata, queuedata, queuedata, queuedata};
      end else if (RATIO == 2) begin : gen_latch_rdacs2
         always_comb readaccess = {queuedata, queuedata};
      end else begin : gen_latch_rdacs1
         always_comb readaccess = queuedata;
      end 
    end //latch_queue
  else begin : gen_flop_queue3
      // Resetable flop based queue
      logic [INGQMAXENTRY:0][EXTMAXPLDBIT+1+PARITYBITS:0] queueflop;
      
      always_ff @(posedge side_clk or negedge side_rst_b)
        if( !side_rst_b ) // lintra s-70023
          queueflop <= '0;
        else if (inmsg_put & ~inmsg_put_msk) begin
          for (int entry = 0; entry <= INGQMAXENTRY; entry++) begin
             if (wptr == entry) queueflop[entry] <= qin;
          end
        end
      // Accumulator
      if (RATIO == 4) begin : gen_flop_rdacs4
         always_comb readaccess = {queueflop, queueflop, queueflop, queueflop};
      end else if (RATIO == 2) begin : gen_flop_rdacs2
         always_comb readaccess = {queueflop, queueflop};
      end else begin : gen_flop_rdacs1
         always_comb readaccess = queueflop;
      end
    end //flop_queue 

   always_comb begin
     qout = '0;
     for (int entry = 0; entry <= INGQMAXENTRY; entry++) begin
       if (rptr == entry) qout = readaccess[entry];
     end
   end
end //non_rp
  
endgenerate

//------------------------------------------------------------------------------
//
// Read port of the ingress queue
//
//------------------------------------------------------------------------------


generate
   if (RATIO == 1) begin : gen_rdacs_blk1
      always_comb begin
         eom  = qout[EOM3];
         data = qout[INTMAXPLDBIT:0];
      end
   end else if (RATIO == 2) begin : gen_rdacs_blk2
      always_comb begin
         eom  = qout[EOM3];
         data = { qout[EXTMAXPLDBIT+PLD1:PLD1],
                  qout[EXTMAXPLDBIT+PLD0:PLD0] };
      end
   end else begin : gen_rdacs_blk
      always_comb begin
         eom  = qout[EOM3];
         data = { qout[EXTMAXPLDBIT+PLD3:PLD3],
                  qout[EXTMAXPLDBIT+PLD2:PLD2],
                  qout[EXTMAXPLDBIT+PLD1:PLD1],
                  qout[EXTMAXPLDBIT+PLD0:PLD0] };
      end
   end
endgenerate

generate
    //if (ENDPOINTONLY== 1 && SB_PARITY_REQUIRED == 1) begin : gen_par_ep
    if (|RTR_SB_PARITY_REQUIRED == 1)  begin : gen_par_ep
        logic parity_err_gen_out_pre, parity_err_pre;
        // if ratio is 1, just propagate the parity, else regenerate for the payload and eom        
        if (RATIO == 1) begin : gen_par_rat1
            always_comb parity_out = qout[EOM3-1]; end
        else if (RATIO == 2) begin : gen_par_rat2
            always_comb parity_out = ^{ qout[EOM1-1], qout[EOM0-1] }; end
        else begin : gen_par_rat4
            always_comb parity_out = ^{ qout[EOM3-1], qout[EOM2-1], qout[EOM1-1], qout[EOM0-1] }; end
// rechecking parity on the data, eom , parity coming out of the queue.
// this has to be checked on irdy/trdy, else unpackaged data ll also be
// checked and will be flagged as false errors
// instead use the condition for irdy (when data is ready to be sent out)

        always_comb parity_err_pre = valid_data ? ^{data, eom, parity_out} & ~cfg_parityckdef : '0;
        always_comb parity_err_gen_out = parity_err_pre | parity_err_gen_out_pre;

        always_ff @(posedge side_clk or negedge side_rst_b)
            if (~side_rst_b) 
                parity_err_gen_out_pre <= '0;
            else if (parity_err_pre == 1)
                parity_err_gen_out_pre <= 1'b1;

// parity_err_gen_out is the correct generated parity with corresponding data,eom.
        always_comb parity_err_out = parity_err_gen_out;
    end
    else begin: gen_nortr_parity
        always_comb parity_err_out = '0;
        always_comb parity_out = '0;
        always_comb parity_err_gen_out = '0;
    end
endgenerate

// dstvld indicates that byte0 of a new message is valid (destination Port ID)
// This allows the router to start the destination egress port decoding before
// the internal flit is ready (irdy).  This only helps when the external payload
// width is less than the internal datapath width, otherwise dstvld and irdy
// will go active at the same time.  dstvld really indicates that byte0 of the
// next flit (ingress queue output) is valid.  It will only be used by the
// arbiter when it is the first byte of a new message.  It should have been
// more appropriately named something like byte0vld.
always_comb dstvld = |qcnt;

// Irdy is asserted when the queue count is greater than or equal to the
// payload width ratio.  For example, if the width ratio is 1:1, then as long
// as there is 1 element in the queue, then irdy is asserted.  If the width
// ration is 2:1, then there needs to be at least 2 elements in the queue for
// irdy to be asserted.  The comparison is to a power of 2 value (4, 2 or 1),
// so the queue cnt is right shifted either 2, 1 or 0 bits.  If any of the
// remaining bits are asserted, then irdy should be asserted...

// use parity_err_gen_out to reset qcnt
always_comb irdy = |(qcnt >> (RATIO==4 ? 2 : RATIO-1)) & ~parity_err_gen_out & ~srcidck_err_out;

// This is a similar comparison, but the comparison values are 1 less than
// above.  If the width ration is 4:1, the accumulator depth is 3.  If the width
// ratio is 2:1, then the accumulator depth is 1, otherwise (1:1 width ratio)
// the accumulator depth is 0 (no accumulator; always full).
always_comb accumulatorfull = qcnt >= ACCUMDEPTH;

// Credit updates occur 1 cycle after the put, if the flit is getting put into
// the accumulator (not in the actual ingress queue).  When an accumulator
// pop occurs, then at least one credit update should occur, because the payload
// output of this block comes from the accumulator (credit updates already sent)
// and 1 entry from the ingress queue, which requires 1 credit update when pop
// occurs.  In addition, the number of ingress queue entries that get "moved"
// into the accumulator (up to 3 ingress queue entries) will also require
// credit updates.  So, the pop can require 1 to 4 credit updates.
always_comb nxtcup = (ism_active | crdinit) &
                (|cupsendcnt | pop | (inmsg_put & ~inmsg_put_msk & ~accumulatorfull) | (inmsg_put & inmsg_put_msk));

// Calculate when credit init is done.  
always_comb crdinitfc_done = crdinit & ~(|cupsendcnt) & ~credit_reinit;

// The cupholdcnt contains the number of credits that are being held in the
// ingress queue, which can not be sent until these credits are moved into the
// accumulator (1 to 3 credits) or are consumed by irdy/trdy (1 credit max).
// The cupholddec value is the number of credits that are ready to be sent
// when the pop occurs.
always_comb cupaccumcnt = (inmsg_put & ~inmsg_put_msk) ? ACCUMDEPTH : ACCUMDEPTH+1; // lintra s-0393 s-0396
always_comb cupholddec  = (cupholdcnt <= cupaccumcnt) ? cupholdcnt : cupaccumcnt;

// synopsys sync_set_reset credit_reinit
// Credit update flop and the number of credits that still need to be issued

always_ff @(posedge side_clk or negedge side_rst_b)
  if ( !side_rst_b ) begin // lintra s-70023
      outmsg_cup <= '0;
      cupholdcnt <= '0;
      cupsendcnt <= INGCREDITS;  // Number of credits to be sent is initialized
      // to the maximum number of credits that the
      // ingress queue can support.  These will be
      // sent to the connected egress port as soon
      // as reset de-asserts and the clock gating ISM
      // reaches the ACTIVE state.
  end else begin
      if ( credit_reinit ) begin
          cupholdcnt <= '0;
          cupsendcnt <= INGCREDITS;
      end else begin
          outmsg_cup <= parity_err_cup_en ? (nxtcup_parity | ppp_cup) : '0;
          
          // Update the credit hold count (number of credits in the ingress queue).
          if ( pop ) 
            cupholdcnt <= cupholdcnt - cupholddec;
          else if ( inmsg_put & ~inmsg_put_msk & accumulatorfull )
            cupholdcnt <= cupholdcnt + 1; // lintra s-0393 s-0396
          
          // Update the number of credits that need to be sent.
          if ( pop ) begin
            casez ( { inmsg_put, nxtcup } ) // lintra s-60129
              2'b00 : cupsendcnt <= cupsendcnt + cupholddec;
              2'b01 : cupsendcnt <= cupsendcnt + (cupholddec - 1); // lintra s-0393 s-0396
              2'b10 : cupsendcnt <= cupsendcnt + (cupholddec + 1); // lintra s-0393 s-0396
              2'b11 : cupsendcnt <= cupsendcnt + cupholddec;
            endcase
          end else if ( ~pop & inmsg_put_msk ) begin
              if (nxtcup) cupsendcnt <= cupsendcnt;
              else        cupsendcnt <= cupsendcnt + 1; // lintra s-0393 s-0396
          end else begin
            casez ( { inmsg_put & ~inmsg_put_msk & ~accumulatorfull, nxtcup } ) // lintra s-60129
              2'b01   : cupsendcnt <= cupsendcnt - 1; // lintra s-0393 s-0396
              2'b10   : cupsendcnt <= cupsendcnt + 1; // lintra s-0393 s-0396
              default : cupsendcnt <= cupsendcnt;
            endcase
          end
        end
    end 
  
  // Determine if the ingress queue is idle. It is not idle if there is anything
  // currently in the  queue (dstvld) or if there is something going into the
  // queue (inmsg_put) or if there are any credits to be sent (cupsendcnt>0) or
  // if there is a credit currently being sent (outmsg_cup).
  // Power gating strategy update, if the target is POK then to prevent
  // non-idle conditions the cups must be ignored.
  always_comb idle_inqueue = ~dstvld & ~nd_inmsg_put & ((~(|cupsendcnt) & ~outmsg_cup) | !int_pok)
                           & ~((HIER_BRIDGE_GEN==1) & msgip & (xfrhb < XFRHBMAX) & hier_bridge_en)
                           & ~((GNR_HIER_FABRIC==1) & msgipgnr);



// PCR 58001 & 58002 - Place holder for the debug q count value, used for proper
// truncation on credit counters, they are now able to grow beyond the originally
// supported sizes. - START
// Debug signals
always_comb begin
  dbgbus                 = '0;
  dbgqcnt                = ( cupsendcnt + cupholdcnt );
  dbgbus[DBGQCNTBIT  :0] = qcnt[DBGQCNTBIT:0];
  dbgbus[DBGQCNTBIT+4:4] = dbgqcnt[DBGQCNTBIT:0];
end
// PCR 58001 & 58002 - Place holder for the debug q count value, used for proper
// truncation on credit counters, they are now able to grow beyond the originally
// supported sizes. - FINISH
 

//------------------------------------------------------------------------------
//
// SV Assertions 
//
//------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
`ifdef INTEL_SIMONLY
//`ifdef INTEL_INST_ON // SynTranlateOff
    // coverage off
  readaccess_bounds_check: //bjeassert
    assert property (@ (posedge side_clk) disable iff (side_rst_b !== 1'b1)
         $changed (rptr) |-> (rptr <= INGQMAXENTRY) ) else
      $error("%0t: %m: ERROR: Index into readaccess outside of bounds; rptr = %b, maximum value = %b.  Note: PC inst0; NP inst1", $time, rptr, INGQMAXENTRY);

  dword_align_check:  //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        irdy |-> RATIO==1 ? 1'b1          :
                 RATIO==2 ? ~(qout[EOM0]) : 
                            ~(qout[EOM0] | qout[EOM1] | qout[EOM2]) ) else
        $display("%0t: %m: ERROR: Sideband message is not dword aligned.  Note: PC inst0; NP inst1", $time);
    
  ingress_queue_overflow: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        inmsg_put |-> (qcnt!=INGQDEPTH) ) else
        $display("%0t: %m: ERROR: Sideband ingress queue overflow.  Note: PC inst0; NP inst1", $time);
    
  ingress_queue_underflow: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        pop |-> (qcnt!=0) ) else
        $display("%0t: %m: ERROR: Sideband ingress queue underflow.  Note: PC inst0; NP inst1", $time);
  // coverage on
  `endif // SynTranlateOn
  `endif
`endif
  
//-----------------------------------------------------------------------------
//
// SV Cover properties 
//
//-----------------------------------------------------------------------------

`ifndef IOSF_SB_EVENT_OFF
`ifdef INTEL_SIMONLY
//`ifdef INTEL_INST_ON // SynTranlateOff
  // coverage off
  
  sequence ingress_queue_full;
      @(posedge side_clk) inmsg_put ##1 (qcnt==INGQDEPTH);
  endsequence

  sequence ingress_queue_empty;
      @(posedge side_clk) pop ##1 (qcnt==0);
  endsequence



  ingress_queue_went_full: 
    cover property (@(posedge side_clk) disable iff (!side_rst_b)
      ingress_queue_full) 
      begin
`ifdef IOSF_SB_EVENT_VERBOSE       
        $info("%0t: %m: EVENT: SB inqueue went full.  Note: PC queue = inst0, NP queue = inst1", $time);
`endif
      end


  ingress_queue_went_empty: 
    cover property (@(posedge side_clk) disable iff (!side_rst_b)
      ingress_queue_empty)
      begin
`ifdef IOSF_SB_EVENT_VERBOSE       
        $info("%0t: %m: EVENT: SB inqueue went empty.  Note: PC queue = inst0, NP queue = inst1", $time);
`endif
      end


// HSD: 1209017814 causing simulation slowness

//  ingress_queue_went_full_then_empty:
//    cover property (@(posedge side_clk) disable iff (!side_rst_b)
//      ingress_queue_full |=> ##[1:$] ingress_queue_empty)
//      begin
//`ifdef IOSF_SB_EVENT_VERBOSE       
//        $info("%0t: %m: EVENT: SB inqueue went full then empty.  Note: PC queue = inst0, NP queue = inst1", $time);
//`endif
//      end 



//  ingress_queue_went_empty_then_full: 
//    cover property (@(posedge side_clk) disable iff (!side_rst_b)
//      ingress_queue_empty |=> ##[1:$] ingress_queue_full)
//      begin
//`ifdef IOSF_SB_EVENT_VERBOSE       
//        $info("%0t: %m: EVENT: SB inqueue went empty then full.  Note: PC queue = inst0, NP queue = inst1", $time);
//`endif
//      end 


  // coverage on
  `endif // SynTranlateOn
`endif

endmodule

// lintra pop

