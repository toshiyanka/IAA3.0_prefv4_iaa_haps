//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author          : ddaftary
// Co-Author       : sshah3
// Date Created : 10-31-2011 
//-----------------------------------------------------------------
// Description:
// 
//
//------------------------------------------------------------------
`include "agent_types.svh"

module agent_compliance #(parameter int MAXPCMSTR=0,
                          parameter int MAXNPMSTR=0,
                          parameter int MAXPCTRGT=0,
                          parameter int MAXNPTRGT=0,
                          parameter int MAXTRGTADDR=31,
                          parameter int MAXTRGTDATA=63,
                          parameter int MAXMSTRADDR=31,
                          parameter int MAXMSTRDATA=63,
                          parameter int NUM_TX_EXT_HEADERS=0,
                          parameter int NUM_RX_EXT_HEADERS=0,
                          parameter int TX_EXT_HEADER_SUPPORT=0,
                          parameter int RX_EXT_HEADER_SUPPORT=0)
(
  input logic        clk,
  input logic        reset,
  input logic        treg_trdy,
  input logic        treg_irdy,
  input logic        treg_np,
  input logic [7:0]  treg_dest,
  input logic [7:0]  treg_source,
  input logic [7:0]  treg_opcode,
  input logic        treg_addrlen,
  input logic [2:0]  treg_bar,
  input logic [2:0]  treg_tag,
  input logic [`SBEREGB(MAXTRGTDATA):0]  treg_be,
  input logic [7:0]  treg_fid,
  input logic [MAXTRGTADDR:0] treg_addr,
  input logic [MAXTRGTDATA:0] treg_wdata,
  input logic        treg_cerr,
  input logic [MAXTRGTDATA:0] treg_rdata,
  //EH + ext_header
  input logic        treg_eh,
  input logic [NUM_RX_EXT_HEADERS:0][31:0] treg_ext_header,
  input logic treg_eh_discard,

  input logic [MAXPCTRGT:0]       tmsg_pcfree,
  input logic        tmsg_pcput,
  input logic        tmsg_pcmsgip,
  input logic        tmsg_pccmpl,
  input logic        tmsg_pceom,
  input logic [31:0] tmsg_pcpayload,
  input logic        tmsg_pcvalid,

  input logic [MAXNPTRGT:0]       tmsg_npclaim,
  input logic [MAXNPTRGT:0]       tmsg_npfree,
  input logic        tmsg_npput,
  input logic        tmsg_npmsgip,
  input logic        tmsg_npeom,
  input logic [31:0] tmsg_nppayload,
  input logic        tmsg_npvalid,
  
  // master register access signals

  input logic [2:0]  mreg_nptag,
  input logic        mreg_pmsgip,
  input logic        mreg_nmsgip,
  input logic        mreg_trdy,
  input logic        mreg_irdy,
  input logic        mreg_npwrite,
  input logic [7:0]  mreg_dest,
  input logic [7:0]  mreg_source,
  input logic [7:0]  mreg_opcode,
  input logic        mreg_addrlen,
  input logic [2:0]  mreg_bar,
  input logic [2:0]  mreg_tag,
  input logic [`SBEREGB(MAXMSTRDATA):0]  mreg_be,
  input logic [7:0]  mreg_fid,
  input logic [MAXMSTRADDR:0] mreg_addr,
  input logic [MAXMSTRDATA:0] mreg_wdata,

  // master message signals

  input logic [MAXPCMSTR:0]       mmsg_pcsel,
  input logic        mmsg_pcmsgip,
  input logic        mmsg_pctrdy,
  input logic [MAXPCMSTR:0]        mmsg_pcirdy,
  input logic [MAXPCMSTR:0]        mmsg_pceom,
  input logic [32*MAXPCMSTR+31:0] mmsg_pcpayload,

  input logic [MAXNPMSTR:0]       mmsg_npsel,
  input logic        mmsg_npmsgip,
  input logic        mmsg_nptrdy,
  input logic [MAXNPMSTR:0]       mmsg_npirdy,
  input logic [MAXNPMSTR:0]       mmsg_npeom,
  input logic [32*MAXNPMSTR+31:0] mmsg_nppayload,

  // ism signals
  input logic agent_idle,
  input logic agent_clkreq,
  input logic sbe_idle,
  input logic sbe_clkreq,

  //ext_header
  input logic [NUM_TX_EXT_HEADERS:0][31:0] tx_ext_headers,
 
  input logic [7:0] cgctrl_idlecnt,
  input logic cgctrl_clkgaten,
  input logic cgctrl_clkgatedef,
 
  input logic jta_clkgate_ovrd,
  input logic jta_force_clkreq,
  input logic jta_force_idle,
  input logic jta_force_notidle,
  input logic jta_force_creditreq,

  input logic fscan_latchopen,
  input logic fscan_latchclosed_b,
  input logic fscan_clkungate,
  input logic fscan_rstbypen
  
 );

`ifdef EP_FPV
 parameter EP_FPV = 1;
`else
 parameter EP_FPV = 0;
`endif
   
   /**
    * Internal bundled and delayed signals
    */
   bit[1:0] mirdy;
   bit[1:0] mtrdy;
   bit[1:0] meom;
   bit[1:0] mmsgip;
   bit[1:0] msel;
   bit[3:0] mreg_sbe, mreg_fbe;
      
   /**
    * Signal bundling
    */
         
   assign    mreg_sbe = mreg_be[7:4];
   assign    mreg_fbe = mreg_be[3:0];

   if (!RX_EXT_HEADER_SUPPORT && !TX_EXT_HEADER_SUPPORT)
     begin: agt_comp
   /**
    * Agent master message Signal to Message Flow Compliance
    */
   agent_mmsg_compliance #(.MAXPCMSTR(MAXPCMSTR),
                           .MAXNPMSTR(MAXNPMSTR),
                           .MAXPCTRGT(MAXPCTRGT),
                           .MAXNPTRGT(MAXNPTRGT),
                           .MAXTRGTADDR(MAXTRGTADDR),
                           .MAXTRGTDATA(MAXTRGTDATA),
                           .MAXMSTRADDR(MAXMSTRADDR),
                           .MAXMSTRDATA(MAXMSTRDATA),
                           .NUM_TX_EXT_HEADERS(NUM_TX_EXT_HEADERS),
                           .NUM_RX_EXT_HEADERS(NUM_RX_EXT_HEADERS))
   agent_mmsg_compliance 
   (
    .clk      ( clk ),
    .reset    ( reset ),
    .mmsg_nppayload(mmsg_nppayload),
    .mmsg_pcpayload(mmsg_pcpayload),
    .mmsg_pcirdy(mmsg_pcirdy),
    .mmsg_pctrdy(mmsg_pctrdy),
    .mmsg_pceom(mmsg_pceom),
    .mmsg_npirdy(mmsg_npirdy),
    .mmsg_nptrdy(mmsg_nptrdy),
    .mmsg_npeom(mmsg_npeom),
    .mmsg_pcmsgip(mmsg_pcmsgip),
    .mmsg_npmsgip(mmsg_npmsgip),
    .mmsg_pcsel(mmsg_pcsel),
    .mmsg_npsel(mmsg_npsel));


  /**
    * Agent master register Signal 
    */
   agent_mreg_compliance #(.MAXPCMSTR(MAXPCMSTR),
                           .MAXNPMSTR(MAXNPMSTR),
                           .MAXPCTRGT(MAXPCTRGT),
                           .MAXNPTRGT(MAXNPTRGT),
                           .MAXTRGTADDR(MAXTRGTADDR),
                           .MAXTRGTDATA(MAXTRGTDATA),
                           .MAXMSTRADDR(MAXMSTRADDR),
                           .MAXMSTRDATA(MAXMSTRDATA),
                           .NUM_TX_EXT_HEADERS(NUM_TX_EXT_HEADERS),
                           .NUM_RX_EXT_HEADERS(NUM_RX_EXT_HEADERS))
   agent_mreg_compliance 
     (
      .clk      ( clk ),
      .reset    ( reset ),
      .mreg_irdy(mreg_irdy),
      .mreg_trdy(mreg_trdy), 
      .mreg_dest(mreg_dest),
      .mreg_source(mreg_source),
      .mreg_opcode(mreg_opcode),
      .mreg_addrlen(mreg_addrlen),
      .mreg_bar(mreg_bar),
      .mreg_tag(mreg_tag),
      .mreg_fid(mreg_fid),
      .mreg_sbe(mreg_sbe),
      .mreg_fbe(mreg_fbe),
      .mreg_addr(mreg_addr),
      .mreg_wdata(mreg_wdata),
      .mreg_npwrite(mreg_npwrite),
      .mreg_pmsgip(mreg_pmsgip),
      .mreg_nmsgip(mreg_nmsgip));
   
     
     `include "agent_assumptions.sv"
   end // block: agt_comp
   
 `ifdef EP_FPV
   `include "ep_base_chk_sig.svh"   
   `include "ep_reg_chk_sig.svh"
 `endif
      
endmodule // agent_compliance


