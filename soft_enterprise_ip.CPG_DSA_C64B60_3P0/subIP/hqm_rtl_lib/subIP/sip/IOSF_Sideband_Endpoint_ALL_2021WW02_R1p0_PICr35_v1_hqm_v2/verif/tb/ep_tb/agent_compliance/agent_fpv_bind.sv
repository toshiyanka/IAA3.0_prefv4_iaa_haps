//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author          : ddaftary
// Co-Author       : sshah3
// Date Created : 10-31-2011 
//-----------------------------------------------------------------
// Description:
// 
//------------------------------------------------------------------

bind sbendpoint  
   
 `include "agent_include.sv"

 agent_compliance                    
    (  .clk(agent_clk),
       .reset(side_rst_b),
       .agent_clkreq(agent_clkreq),
       .agent_idle(agent_idle),
       .sbe_clkreq(sbe_clkreq),
       .sbe_idle(sbe_idle),
       
       .tmsg_pcfree(tmsg_pcfree),
       .tmsg_npfree(tmsg_npfree),
       .tmsg_npclaim(tmsg_npclaim),
       .tmsg_pcput(tmsg_pcput),
       .tmsg_npput(tmsg_npput),
       .tmsg_pcmsgip(tmsg_pcmsgip),
       .tmsg_npmsgip(tmsg_npmsgip),
       .tmsg_pceom(tmsg_pceom),
       .tmsg_npeom(tmsg_npeom),
       .tmsg_pcpayload(tmsg_pcpayload),
       .tmsg_nppayload(tmsg_nppayload),
       .tmsg_pccmpl(tmsg_pccmpl),
       .tmsg_npvalid(tmsg_npvalid),
       .tmsg_pcvalid(tmsg_pcvalid),
       
       .mmsg_pcirdy(mmsg_pcirdy),
       .mmsg_npirdy(mmsg_npirdy),
       .mmsg_pceom(mmsg_pceom),
       .mmsg_npeom(mmsg_npeom),
       .mmsg_pcpayload(mmsg_pcpayload),
       .mmsg_nppayload (mmsg_nppayload),
       .mmsg_pctrdy(mmsg_pctrdy),
       .mmsg_nptrdy(mmsg_nptrdy),
       .mmsg_pcmsgip(mmsg_pcmsgip),
       .mmsg_npmsgip(mmsg_npmsgip),
       .mmsg_pcsel(mmsg_pcsel),
       .mmsg_npsel(mmsg_npsel),
       
       .treg_trdy(treg_trdy),
       .treg_cerr(treg_cerr),
       .treg_rdata(treg_rdata),
       .treg_irdy(treg_irdy),
       .treg_np(treg_np),
       .treg_dest(treg_dest),
       .treg_source(treg_source),
       .treg_opcode(treg_opcode),
       .treg_addrlen(treg_addrlen),
       .treg_bar(treg_bar),
       .treg_tag(treg_tag),
       .treg_be(treg_be),
       .treg_fid(treg_fid),
       .treg_addr(treg_addr),
       .treg_wdata(treg_wdata),
       
       .mreg_irdy(mreg_irdy),
       .mreg_npwrite(mreg_npwrite),
       .mreg_dest(mreg_dest),
       .mreg_source(mreg_source),
       .mreg_opcode(mreg_opcode),
       .mreg_addrlen(mreg_addrlen),
       .mreg_bar(mreg_bar),
       .mreg_tag(mreg_tag),
       .mreg_be(mreg_be),
       .mreg_fid(mreg_fid),
       .mreg_addr(mreg_addr),
       .mreg_wdata(mreg_wdata),
       .mreg_trdy(mreg_trdy),
       .mreg_pmsgip(mreg_pmsgip),
       .mreg_nmsgip(mreg_nmsgip),
       .tx_ext_headers(tx_ext_headers),
       
       .cgctrl_idlecnt(cgctrl_idlecnt),
       .cgctrl_clkgaten(cgctrl_clkgaten),
       .cgctrl_clkgatedef(cgctrl_clkgatedef),
       
       .jta_clkgate_ovrd(jta_clkgate_ovrd),
       .jta_force_clkreq(jta_force_clkreq),
       .jta_force_idle(jta_force_idle),
       .jta_force_notidle(jta_force_notidle),
       .jta_force_creditreq(jta_force_creditreq),
       
       .fscan_latchclosed_b(fscan_latchclosed_b),
       .fscan_clkungate(fscan_clkungate),
       .fscan_rstbypen(fscan_rstbypen),
       .fscan_latchopen(fscan_latchopen)
       );
