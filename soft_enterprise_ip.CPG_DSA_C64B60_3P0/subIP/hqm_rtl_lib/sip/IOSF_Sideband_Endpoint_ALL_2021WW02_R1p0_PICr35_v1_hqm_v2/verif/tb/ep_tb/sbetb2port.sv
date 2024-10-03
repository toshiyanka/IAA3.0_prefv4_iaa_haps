//------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009 Intel Corporation All Rights Reserved. 
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
//  Module sbetb2port : 2 port router built out of the sideband interface
//                      endpoint (sbenpoint) that is only used in the router
//                      testbench in order to add validation coverage to the
//                      endpoint RTL
//
//  IOSF - Sideband Channel IP Collateral
//  Organization: SEG / SIP / IOSF IP Engineering
//
//------------------------------------------------------------------------------

`include "sbcglobal.vm"

module sbetb2port
#(
  parameter MAXPLDBIT   =  7, // Maximum payload bit, should be 7, 15 or 31
            QUEUEDEPTH  =  2, // Ingress queue depth
            CUP2PUT1CYC =  0, // cup to put latency is 1 cycle (s/b 1 or 0)
            LATCHQUEUES =  0  // 0 = flop-based queues, 1 = latch-based queues
)(
  // Clock/Reset Signals
  input  logic                           side_clk,           //
  input  logic                           side_rst_b,         //
                                   
  // P0 is a fabric interface which will be connected to an agent BFM
  output logic                     [2:0] p0_side_ism_fabric, //
  input  logic                     [2:0] p0_side_ism_agent,  //
  input  logic                           p0_side_clkreq,     //
  output logic                           p0_side_clkack,     //

  // Egress port interface to the IOSF Sideband Channel
  input  logic                           p0_mpccup,          //
  input  logic                           p0_mnpcup,          //
  output logic                           p0_mpcput,          //
  output logic                           p0_mnpput,          //
  output logic                           p0_meom,            //
  output logic    [`SBEPLD(MAXPLDBIT):0] p0_mpayload,        //

  // Ingress port interface to the IOSF Sideband Channel
  output logic                           p0_tpccup,          //
  output logic                           p0_tnpcup,          //
  input  logic                           p0_tpcput,          //
  input  logic                           p0_tnpput,          //
  input  logic                           p0_teom,            //
  input  logic    [`SBEPLD(MAXPLDBIT):0] p0_tpayload,        //

  // P1 is an agent (endpoint) interface which will be connected to an RTL router
  input  logic                     [2:0] p1_side_ism_fabric, //
  output logic                     [2:0] p1_side_ism_agent,  //
  output logic                           p1_side_clkreq,     //
  input  logic                           p1_side_clkack,     //

  // Egress port interface to the IOSF Sideband Channel
  input  logic                           p1_mpccup,          //
  input  logic                           p1_mnpcup,          //
  output logic                           p1_mpcput,          //
  output logic                           p1_mnpput,          //
  output logic                           p1_meom,            //
  output logic    [`SBEPLD(MAXPLDBIT):0] p1_mpayload,        //

  // Ingress port interface to the IOSF Sideband Channel
  output logic                           p1_tpccup,          //
  output logic                           p1_tnpcup,          //
  input  logic                           p1_tpcput,          //
  input  logic                           p1_tnpput,          //
  input  logic                           p1_teom,            //
  input  logic    [`SBEPLD(MAXPLDBIT):0] p1_tpayload         //
);


// Port 0 Master Signals
logic        p0_mmsg_pcirdy;     //
logic        p0_mmsg_npirdy;     //
logic        p0_mmsg_pceom;      //
logic        p0_mmsg_npeom;      //
logic [31:0] p0_mmsg_pcpayload;  //
logic [31:0] p0_mmsg_nppayload;  //
logic        p0_mmsg_pctrdy;     //
logic        p0_mmsg_nptrdy;     //
logic        p0_mmsg_pcmsgip;    //
logic        p0_mmsg_npmsgip;    //
logic        p0_mmsg_pcsel;      //
logic        p0_mmsg_npsel;      //

logic        p0_mreg_irdy;       //
logic        p0_mreg_npwrite;    //
logic  [7:0] p0_mreg_dest;       //
logic  [7:0] p0_mreg_source;     //
logic  [7:0] p0_mreg_opcode;     //
logic        p0_mreg_addrlen;    //
logic  [2:0] p0_mreg_bar;        //
logic  [2:0] p0_mreg_tag;        //
logic  [7:0] p0_mreg_be;         //
logic  [7:0] p0_mreg_fid;        //
logic [47:0] p0_mreg_addr;       //
logic [63:0] p0_mreg_wdata;      //
logic        p0_mreg_trdy;       //
logic        p0_mreg_pmsgip;     //
logic        p0_mreg_nmsgip;     //
logic  [2:0] p0_mreg_nptag;      //

// Port 1 Target Signals
logic        p0_tmsg_pcfree;     //
logic        p0_tmsg_npfree;     //
logic        p0_tmsg_npclaim;    //
logic        p0_tmsg_pcput;      //
logic        p0_tmsg_npput;      //
logic        p0_tmsg_pcmsgip;    //
logic        p0_tmsg_npmsgip;    //
logic        p0_tmsg_pceom;      //
logic        p0_tmsg_npeom;      //
logic [31:0] p0_tmsg_pcpayload;  //
logic [31:0] p0_tmsg_nppayload;  //
logic        p0_tmsg_pccmpl;     //

logic        p0_tmsg_pcclaim;    //
logic        p0_tmsg_pcignore;   //

// Port 1 Master Signals
logic        p1_mmsg_pcirdy;     //
logic        p1_mmsg_npirdy;     //
logic        p1_mmsg_pceom;      //
logic        p1_mmsg_npeom;      //
logic [31:0] p1_mmsg_pcpayload;  //
logic [31:0] p1_mmsg_nppayload;  //
logic        p1_mmsg_pctrdy;     //
logic        p1_mmsg_nptrdy;     //
logic        p1_mmsg_pcmsgip;    //
logic        p1_mmsg_npmsgip;    //
logic        p1_mmsg_pcsel;      //
logic        p1_mmsg_npsel;      //

// Port 1 Target Signals
logic        p1_tmsg_pcfree;     //
logic        p1_tmsg_npfree;     //
logic        p1_tmsg_npclaim;    //
logic        p1_tmsg_pcput;      //
logic        p1_tmsg_npput;      //
logic        p1_tmsg_pcmsgip;    //
logic        p1_tmsg_npmsgip;    //
logic        p1_tmsg_pceom;      //
logic        p1_tmsg_npeom;      //
logic [31:0] p1_tmsg_pcpayload;  //
logic [31:0] p1_tmsg_nppayload;  //
logic        p1_tmsg_pccmpl;     //
logic        p1_treg_trdy;       //
logic        p1_treg_cerr;       //
logic [63:0] p1_treg_rdata;      //
logic        p1_treg_irdy;       //
logic  [1:0] p1_treg_xfr;        //
logic        p1_treg_nptagval;   //
logic  [2:0] p1_treg_nptag;      //

logic        p1_tmsg_pcclaim;    //
logic        p1_tmsg_pcignore;   //
logic        p1_tmsg_npignore;   //

//------------------------------------------------------------------------------
//
// glue logic: Needed to connect the AGENT-side of the 2 endpoints together to
//             create a 2-port router
//
//------------------------------------------------------------------------------

// Target free signals for port 0.  There is a flit flop stage between port 0
// and port 1.  If the flop stage is busy, then the free signal will not be
// asserted.  Also, there is a basic ordering mechanism to ensure that
// non-posted messages do not pass posted/completions.
assign p0_tmsg_pcfree =  ~p1_mmsg_pcirdy | (p1_mmsg_pcsel & p1_mmsg_pctrdy);
assign p0_tmsg_npfree = (~p1_mmsg_npirdy | (p1_mmsg_npsel & p1_mmsg_nptrdy)) &
                        (p1_mmsg_npmsgip | ~(p1_mmsg_pcmsgip | p1_mmsg_pcirdy));

// Claim signals:  All non-posted messages are claimed.  For posted/completions,
// the only thing that is not claimed is the completions that are comsumed by
// the target register access block in port 1 (that were mastered on port 0 and
// the completions are returned on the port 0 target message interface).
// completions are sent to the p1 treg interface only if tag matches and
// returning completion from port 0 destination matches the original message source.
  
assign p0_tmsg_npclaim = '1;
assign p0_tmsg_pcclaim = ~p0_tmsg_pcmsgip &
                         (~p0_tmsg_pccmpl |
                          ~p1_treg_nptagval |
                          (p1_treg_nptag  != p0_tmsg_pcpayload[26:24]) |
                          (p0_mreg_source != p0_tmsg_pcpayload[7:0]) 
                          );

// The port 0 master register access irdy signal is asserted when the port 1
// target register access irdy signal is asserted as long as it is not waiting
// for a completion.  In this case, the message has already completion on the
// master register access interface (port 0), but not on the target register
// access interface (port 1), since the trdy can not occur until the completion
// has been captured/assembled and presented on the target register access
// interface.
assign p0_mreg_irdy    = p1_treg_irdy & ~p1_treg_nptagval & ~p1_treg_trdy;

always_ff @(posedge side_clk)
   p0_side_clkack <= p0_side_clkreq;
  
// Shim flops for port 0 target to port 1 master translation.  Also the
// completions that need to be delivered to port 1 register access target.
always_ff @(posedge side_clk or negedge side_rst_b)
  if (~side_rst_b) begin
    p1_mmsg_pcirdy    <= '0;
    p1_mmsg_npirdy    <= '0;
    p1_mmsg_pceom     <= '0;
    p1_mmsg_npeom     <= '0;
    p1_mmsg_pcpayload <= '0;
    p1_mmsg_nppayload <= '0;
    p0_tmsg_pcignore  <= '0;
    p1_treg_trdy      <= '0;
    p1_treg_cerr      <= '0;
    p1_treg_xfr       <= '0;
    p1_treg_rdata     <= '0;
    p1_treg_nptagval  <= '0;
    p1_treg_nptag     <= '0;

  end else begin

    // Port 0 tmsg to port 1 mmsg flops and (mmsg) irdy signal generation
    if (p0_tmsg_pcput &
        (p0_tmsg_pcmsgip ? ~p0_tmsg_pcignore : p0_tmsg_pcclaim)) begin
      p1_mmsg_pcirdy    <= '1;
      p1_mmsg_pceom     <= p0_tmsg_pceom;
      p1_mmsg_pcpayload <= p0_tmsg_pcpayload;
    end else if (p1_mmsg_pcirdy & p1_mmsg_pctrdy & p1_mmsg_pcsel)
      p1_mmsg_pcirdy    <= '0;

    if (p0_tmsg_npput) begin
      p1_mmsg_npirdy    <= '1;
      p1_mmsg_npeom     <= p0_tmsg_npeom;
      p1_mmsg_nppayload <= p0_tmsg_nppayload;
    end else if (p1_mmsg_npirdy & p1_mmsg_nptrdy & p1_mmsg_npsel)
      p1_mmsg_npirdy    <= '0;


    // Port 1 register access target trdy: Asserted immediately when the
    // message completes on the master register access interface (port 0) if the
    // message is posted.  Otherwise, it is asserted after the completion 
    // message is captured and driven to the target register access interface to
    // port 1 with the appropriate cerr value.
    p1_treg_trdy <= (p0_tmsg_pcput & p0_tmsg_pceom & (p0_tmsg_pcmsgip ? p0_tmsg_pcignore : ~p0_tmsg_pcclaim) ) |
                    (~p0_mreg_npwrite & p0_mreg_irdy & p0_mreg_trdy);

//  & (p0_tmsg_pcmsgip ? p0_tmsg_pcignore : ~p0_tmsg_pcclaim)) |

    // Flop to ignore the completion to be consumed by the port 1 register
    // access target.  All other target messages are forwarded to the port 1
    // master interface.
    if (p0_tmsg_pcput & ~p0_tmsg_pcmsgip) p0_tmsg_pcignore <= ~p0_tmsg_pcclaim;

    // Flops to capture the completion from the port 0 master register access
    // non-posted message, which is delivered to the port 1 target register
    // access block.
    if (p0_tmsg_pcput) begin
      if (~p0_tmsg_pcmsgip)
        p1_treg_cerr <= p0_tmsg_pcignore & (p0_tmsg_pceom & ~p0_mreg_opcode[0]) |
                        (|p0_tmsg_pcpayload[31:30]);
      p1_treg_xfr  <= {  p1_treg_xfr[0]  & ~p0_tmsg_pceom,
                        ~p0_tmsg_pcmsgip & ~p0_tmsg_pceom  };
      if (p1_treg_xfr[0]) p1_treg_rdata[31: 0] <= p0_tmsg_pcpayload;
      if (p1_treg_xfr[1]) p1_treg_rdata[63:32] <= p0_tmsg_pcpayload;
    end

    // Non-posted tag for completion matching used in the pcclaim signal
    if (p0_mreg_irdy & p0_mreg_trdy &
       (~p0_mreg_opcode[0] | p0_mreg_npwrite)) begin
      p1_treg_nptagval <= '1;
      p1_treg_nptag    <= p0_mreg_nptag;
    end else if (p1_treg_trdy)
      p1_treg_nptagval <= '0;
  end


// Similar shim logic for the other direction: port 1 target to port 0 master
// message translation

// Target free signals for port 1.  There is a flit flop stage between port 1
// and port 0.  If the flop stage is busy, then the free signal will not be
// asserted.  Also, there is a basic ordering mechanism to ensure that
// non-posted messages do not pass posted/completions.
assign p1_tmsg_pcfree = ~p0_mmsg_pcirdy | (p0_mmsg_pcsel & p0_mmsg_pctrdy);
  assign p1_tmsg_npfree = (~p0_mmsg_npirdy | (p0_mmsg_npsel & p0_mmsg_nptrdy));
//) &
//                        (p0_mmsg_npmsgip | ~(p0_mmsg_pcmsgip | p0_mmsg_pcirdy));

// Claim signals:  The flop stage will not claim the messages that are claimed
// by the port 1 register access target.  All other messages are claim and will
// be forwarded from port 1 (tmsg) to port 0 (mmsg).
assign p1_tmsg_npclaim = ~p1_tmsg_npmsgip &
                         (p1_tmsg_nppayload[23:16] != `SBCOP_REGACC_MRD)   &
                         (p1_tmsg_nppayload[23:16] != `SBCOP_REGACC_MWR)   &
                         (p1_tmsg_nppayload[23:16] != `SBCOP_REGACC_IORD)  &
                         (p1_tmsg_nppayload[23:16] != `SBCOP_REGACC_IOWR)  &
                         (p1_tmsg_nppayload[23:16] != `SBCOP_REGACC_CFGRD) &
                         (p1_tmsg_nppayload[23:16] != `SBCOP_REGACC_CFGWR) &
                         (p1_tmsg_nppayload[23:16] != `SBCOP_REGACC_CRRD)  &
                         (p1_tmsg_nppayload[23:16] != `SBCOP_REGACC_CRWR);
assign p1_tmsg_pcclaim = ~p1_tmsg_pcmsgip &
                         (p1_tmsg_pcpayload[23:16] != `SBCOP_REGACC_MRD)   &
                         (p1_tmsg_pcpayload[23:16] != `SBCOP_REGACC_MWR)   &
                         (p1_tmsg_pcpayload[23:16] != `SBCOP_REGACC_IORD)  &
                         (p1_tmsg_pcpayload[23:16] != `SBCOP_REGACC_IOWR)  &
                         (p1_tmsg_pcpayload[23:16] != `SBCOP_REGACC_CFGRD) &
                         (p1_tmsg_pcpayload[23:16] != `SBCOP_REGACC_CFGWR) &
                         (p1_tmsg_pcpayload[23:16] != `SBCOP_REGACC_CRRD)  &
                         (p1_tmsg_pcpayload[23:16] != `SBCOP_REGACC_CRWR);

// Shim flops for port 1 target to port 0 master translation.  Also the
// completions that need to be delivered to port 1 register access target.
always_ff @(posedge side_clk or negedge side_rst_b)
  if (~side_rst_b) begin
    p0_mmsg_pcirdy    <= '0;
    p0_mmsg_npirdy    <= '0;
    p0_mmsg_pceom     <= '0;
    p0_mmsg_npeom     <= '0;
    p0_mmsg_pcpayload <= '0;
    p0_mmsg_nppayload <= '0;
    p1_tmsg_pcignore  <= '0;
    p1_tmsg_npignore  <= '0;

  end else begin

    // Port 1 tmsg to port 0 mmsg flops and (mmsg) irdy signal generation
    if (p1_tmsg_pcput &
        (p1_tmsg_pcmsgip ? ~p1_tmsg_pcignore : p1_tmsg_pcclaim)) begin
      p0_mmsg_pcirdy    <= '1;
      p0_mmsg_pceom     <= p1_tmsg_pceom;
      p0_mmsg_pcpayload <= p1_tmsg_pcpayload;
    end else if (p0_mmsg_pcirdy & p0_mmsg_pctrdy & p0_mmsg_pcsel)
      p0_mmsg_pcirdy    <= '0;

    if (p1_tmsg_npput &
        (p1_tmsg_npmsgip ? ~p1_tmsg_npignore : p1_tmsg_npclaim)) begin
      p0_mmsg_npirdy    <= '1;
      p0_mmsg_npeom     <= p1_tmsg_npeom;
      p0_mmsg_nppayload <= p1_tmsg_nppayload;
    end else if (p0_mmsg_npirdy & p0_mmsg_nptrdy & p0_mmsg_npsel)
      p0_mmsg_npirdy    <= '0;

    // Messages are ignored when not claimed on the first flit are ignored
    // for all remaining flits until the end of the message.  Messages that are
    // claimed by the shim logic are forwarded from port 1 (tmsg) to port 1
    // (mmsg), which be all messages except register access messages which are
    // forwarded from port 1 (treg) to port 0 (mreg).
    if (p1_tmsg_pcput & ~p1_tmsg_pcmsgip) p1_tmsg_pcignore <= ~p1_tmsg_pcclaim;
    if (p1_tmsg_npput & ~p1_tmsg_npmsgip) p1_tmsg_npignore <= ~p1_tmsg_npclaim;
  end

logic p0_to_p1_clkreq;
logic p1_to_p0_clkreq;
logic p0_to_p1_idle;
logic p1_to_p0_idle;

//------------------------------------------------------------------------------
//
// sbendpoint: The sideband endpoint (base endpoint with internal register
//             access target/master agents
//
// Port 0: Which is connected to an AGENT BFM.
//
//------------------------------------------------------------------------------
sbendpoint #(
  .MAXPLDBIT               ( MAXPLDBIT                ),
  .QUEUEDEPTH              ( QUEUEDEPTH               ),
  .CUP2PUT1CYC             ( CUP2PUT1CYC              ),
  .LATCHQUEUES             ( LATCHQUEUES              ),
  .MAXPCTRGT               (  0                       ),
  .MAXNPTRGT               (  0                       ),
  .MAXPCMSTR               (  0                       ),
  .MAXNPMSTR               (  0                       ),
  .ASYNCENDPT              (  0                       ),
  .ASYNCIQDEPTH            (  2                       ),
  .ASYNCEQDEPTH            (  2                       ),
  .TARGETREG               (  0                       ),
  .MASTERREG               (  1                       ),
  .MAXTRGTADDR             ( 47                       ),
  .MAXTRGTDATA             ( 63                       ),
  .MAXMSTRADDR             ( 47                       ),
  .MAXMSTRDATA             ( 63                       ),
  .VALONLYMODEL            (  1                       )
) p0 (                                           
  .side_clk                ( side_clk                 ),
  .gated_side_clk          (                          ),
  .side_rst_b              ( side_rst_b               ),
  .agent_clk               ( 1'b0                     ),
  .agent_rst_b             ( 1'b0                     ),
  .agent_clkreq            ( p1_to_p0_clkreq          ),
  .agent_idle              ( p1_to_p0_idle            ),
  .side_ism_fabric         ( p0_side_ism_agent        ),
  .side_ism_agent          ( p0_side_ism_fabric       ),
  .side_clkreq             (            ),
  .side_clkack             ( p0_side_clkack           ),
  .sbe_clkreq              ( p0_to_p1_clkreq          ),
  .sbe_idle                ( p0_to_p1_idle            ),
  .mpccup                  ( p0_mpccup                ),
  .mnpcup                  ( p0_mnpcup                ),
  .mpcput                  ( p0_mpcput                ),
  .mnpput                  ( p0_mnpput                ),
  .meom                    ( p0_meom                  ),
  .mpayload                ( p0_mpayload              ),
  .tpccup                  ( p0_tpccup                ),
  .tnpcup                  ( p0_tnpcup                ),
  .tpcput                  ( p0_tpcput                ),
  .tnpput                  ( p0_tnpput                ),
  .teom                    ( p0_teom                  ),
  .tpayload                ( p0_tpayload              ),
  .tmsg_pcfree             ( p0_tmsg_pcfree           ),
  .tmsg_npfree             ( p0_tmsg_npfree           ),
  .tmsg_npclaim            ( p0_tmsg_npclaim          ),
  .tmsg_pcput              ( p0_tmsg_pcput            ),
  .tmsg_npput              ( p0_tmsg_npput            ),
  .tmsg_pcmsgip            ( p0_tmsg_pcmsgip          ),
  .tmsg_npmsgip            ( p0_tmsg_npmsgip          ),
  .tmsg_pceom              ( p0_tmsg_pceom            ),
  .tmsg_npeom              ( p0_tmsg_npeom            ),
  .tmsg_pcpayload          ( p0_tmsg_pcpayload        ),
  .tmsg_nppayload          ( p0_tmsg_nppayload        ),
  .tmsg_pccmpl             ( p0_tmsg_pccmpl           ),
  .mmsg_pcirdy             ( p0_mmsg_pcirdy           ),
  .mmsg_npirdy             ( p0_mmsg_npirdy           ),
  .mmsg_pceom              ( p0_mmsg_pceom            ),
  .mmsg_npeom              ( p0_mmsg_npeom            ),
  .mmsg_pcpayload          ( p0_mmsg_pcpayload        ),
  .mmsg_nppayload          ( p0_mmsg_nppayload        ),
  .mmsg_pctrdy             ( p0_mmsg_pctrdy           ),
  .mmsg_nptrdy             ( p0_mmsg_nptrdy           ),
  .mmsg_pcmsgip            ( p0_mmsg_pcmsgip          ),
  .mmsg_npmsgip            ( p0_mmsg_npmsgip          ),
  .mmsg_pcsel              ( p0_mmsg_pcsel            ),
  .mmsg_npsel              ( p0_mmsg_npsel            ),
  .mmsg_nptag              (                          ),
  .treg_trdy               (  1'b0                    ),
  .treg_cerr               (  1'b0                    ),
  .treg_rdata              ( 64'b0                    ),
  .treg_irdy               (                          ),
  .treg_np                 (                          ),
  .treg_dest               (                          ),
  .treg_source             (                          ),
  .treg_opcode             (                          ),
  .treg_addrlen            (                          ),
  .treg_bar                (                          ),
  .treg_tag                (                          ),
  .treg_be                 (                          ),
  .treg_fid                (                          ),
  .treg_addr               (                          ),
  .treg_wdata              (                          ),
  .mreg_irdy               ( p0_mreg_irdy             ),
  .mreg_npwrite            ( p0_mreg_npwrite          ),
  .mreg_dest               ( p0_mreg_dest             ),
  .mreg_source             ( p0_mreg_source           ),
  .mreg_opcode             ( p0_mreg_opcode           ),
  .mreg_addrlen            ( p0_mreg_addrlen          ),
  .mreg_bar                ( p0_mreg_bar              ),
  .mreg_tag                ( p0_mreg_tag              ),
  .mreg_be                 ( p0_mreg_be               ),
  .mreg_fid                ( p0_mreg_fid              ),
  .mreg_addr               ( p0_mreg_addr             ),
  .mreg_wdata              ( p0_mreg_wdata            ),
  .mreg_trdy               ( p0_mreg_trdy             ),
  .mreg_pmsgip             ( p0_mreg_pmsgip           ),
  .mreg_nmsgip             ( p0_mreg_nmsgip           ),
  .mreg_nptag              ( p0_mreg_nptag            ),
  .cgctrl_idlecnt          ( 8'h10                    ),
  .cgctrl_clkgaten         ( 1'b1                     ),
  .cgctrl_clkgatedef       ( 1'b0                     ),
  .noa_sb_dbgbus           (                          ),
  .noa_ag_dbgbus           (                          ),
  .jta_clkgate_ovrd        ( 1'b0                     ),
  .jta_force_clkreq        ( 1'b0                     ),
  .jta_force_idle          ( 1'b0                     ),
  .jta_force_notidle       ( 1'b0                     ),
  .jta_force_creditreq     (1'b0),
  .dt_latchopen            ( 1'b0                     ),
  .dt_latchclosed_b        ( 1'b1                     ),
  .su_local_ugt            ( 1'b0)
);


//------------------------------------------------------------------------------
//
// sbendpoint: The sideband endpoint (base endpoint with internal register
//             access target/master agents
//
// Port 1: Which is connected to router RTL.
//
//------------------------------------------------------------------------------
sbendpoint #(
  .MAXPLDBIT               ( MAXPLDBIT                ),
  .QUEUEDEPTH              ( QUEUEDEPTH               ),
  .CUP2PUT1CYC             ( CUP2PUT1CYC              ),
  .LATCHQUEUES             ( LATCHQUEUES              ),
  .MAXPCTRGT               (  0                       ),
  .MAXNPTRGT               (  0                       ),
  .MAXPCMSTR               (  0                       ),
  .MAXNPMSTR               (  0                       ),
  .ASYNCENDPT              (  1                       ),
  .ASYNCIQDEPTH            (  2                       ),
  .ASYNCEQDEPTH            (  8                       ),
  .TARGETREG               (  1                       ),
  .MASTERREG               (  0                       ),
  .MAXTRGTADDR             ( 47                       ),
  .MAXTRGTDATA             ( 63                       ),
  .MAXMSTRADDR             ( 47                       ),
  .MAXMSTRDATA             ( 63                       ),
  .VALONLYMODEL            (  2                       )
) p1 (                                           
  .side_clk                ( side_clk                 ),
  .gated_side_clk          (                          ),
  .side_rst_b              ( side_rst_b               ),
  .agent_clk               ( side_clk                 ),
  .agent_rst_b             ( side_rst_b               ),
  .agent_clkreq            ( p0_side_clkreq |
                             p0_to_p1_clkreq          ),
  .agent_idle              ( p0_to_p1_idle            ),
  .side_ism_fabric         ( p1_side_ism_fabric       ),
  .side_ism_agent          ( p1_side_ism_agent        ),
  .side_clkreq             ( p1_side_clkreq           ),
  .side_clkack             ( p1_side_clkack           ),
  .sbe_clkreq              ( p1_to_p0_clkreq          ),
  .sbe_idle                ( p1_to_p0_idle            ),
  .mpccup                  ( p1_mpccup                ),
  .mnpcup                  ( p1_mnpcup                ),
  .mpcput                  ( p1_mpcput                ),
  .mnpput                  ( p1_mnpput                ),
  .meom                    ( p1_meom                  ),
  .mpayload                ( p1_mpayload              ),
  .tpccup                  ( p1_tpccup                ),
  .tnpcup                  ( p1_tnpcup                ),
  .tpcput                  ( p1_tpcput                ),
  .tnpput                  ( p1_tnpput                ),
  .teom                    ( p1_teom                  ),
  .tpayload                ( p1_tpayload              ),
  .tmsg_pcfree             ( p1_tmsg_pcfree           ),
  .tmsg_npfree             ( p1_tmsg_npfree           ),
  .tmsg_npclaim            ( p1_tmsg_npclaim          ),
  .tmsg_pcput              ( p1_tmsg_pcput            ),
  .tmsg_npput              ( p1_tmsg_npput            ),
  .tmsg_pcmsgip            ( p1_tmsg_pcmsgip          ),
  .tmsg_npmsgip            ( p1_tmsg_npmsgip          ),
  .tmsg_pceom              ( p1_tmsg_pceom            ),
  .tmsg_npeom              ( p1_tmsg_npeom            ),
  .tmsg_pcpayload          ( p1_tmsg_pcpayload        ),
  .tmsg_nppayload          ( p1_tmsg_nppayload        ),
  .tmsg_pccmpl             ( p1_tmsg_pccmpl           ),
  .mmsg_pcirdy             ( p1_mmsg_pcirdy           ),
  .mmsg_npirdy             ( p1_mmsg_npirdy           ),
  .mmsg_pceom              ( p1_mmsg_pceom            ),
  .mmsg_npeom              ( p1_mmsg_npeom            ),
  .mmsg_pcpayload          ( p1_mmsg_pcpayload        ),
  .mmsg_nppayload          ( p1_mmsg_nppayload        ),
  .mmsg_pctrdy             ( p1_mmsg_pctrdy           ),
  .mmsg_nptrdy             ( p1_mmsg_nptrdy           ),
  .mmsg_pcmsgip            ( p1_mmsg_pcmsgip          ),
  .mmsg_npmsgip            ( p1_mmsg_npmsgip          ),
  .mmsg_pcsel              ( p1_mmsg_pcsel            ),
  .mmsg_npsel              ( p1_mmsg_npsel            ),
  .mmsg_nptag              (                          ),
  .treg_trdy               ( p1_treg_trdy             ),
  .treg_cerr               ( p1_treg_cerr             ),
  .treg_rdata              ( p1_treg_rdata            ),
  .treg_irdy               ( p1_treg_irdy             ),
  .treg_np                 ( p0_mreg_npwrite          ),
  .treg_dest               ( p0_mreg_dest             ),
  .treg_source             ( p0_mreg_source           ),
  .treg_opcode             ( p0_mreg_opcode           ),
  .treg_addrlen            ( p0_mreg_addrlen          ),
  .treg_bar                ( p0_mreg_bar              ),
  .treg_tag                ( p0_mreg_tag              ),
  .treg_be                 ( p0_mreg_be               ),
  .treg_fid                ( p0_mreg_fid              ),
  .treg_addr               ( p0_mreg_addr             ),
  .treg_wdata              ( p0_mreg_wdata            ),
  .mreg_irdy               (  1'b0                    ),
  .mreg_npwrite            (  1'b0                    ),
  .mreg_dest               (  8'b0                    ),
  .mreg_source             (  8'b0                    ),
  .mreg_opcode             (  8'b0                    ),
  .mreg_addrlen            (  1'b0                    ),
  .mreg_bar                (  3'b0                    ),
  .mreg_tag                (  3'b0                    ),
  .mreg_be                 (  8'b0                    ),
  .mreg_fid                (  8'b0                    ),
  .mreg_addr               ( 48'b0                    ),
  .mreg_wdata              ( 64'b0                    ),
  .mreg_trdy               (                          ),
  .mreg_pmsgip             (                          ),
  .mreg_nmsgip             (                          ),
  .mreg_nptag              (                          ),
  .cgctrl_idlecnt          ( 8'h10                    ),
  .cgctrl_clkgaten         ( 1'b1                     ),
  .cgctrl_clkgatedef       ( 1'b0                     ),
  .noa_sb_dbgbus           (                          ),
  .noa_ag_dbgbus           (                          ),
  .jta_clkgate_ovrd        ( 1'b0                     ),
  .jta_force_clkreq        ( 1'b0                     ),
  .jta_force_idle          ( 1'b0                     ),
  .jta_force_notidle       ( 1'b0                     ),
  .jta_force_creditreq     (1'b0),                                                 
  .dt_latchopen            ( 1'b0                     ),
  .dt_latchclosed_b        ( 1'b1                     ),
  .su_local_ugt            ( 1'b0)
   
);

endmodule
