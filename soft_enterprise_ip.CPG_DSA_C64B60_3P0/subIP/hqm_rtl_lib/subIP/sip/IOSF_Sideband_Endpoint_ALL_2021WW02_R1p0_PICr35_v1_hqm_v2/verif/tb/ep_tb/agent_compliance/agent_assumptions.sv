//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author          : ddaftary
// Co-Author       : sshah3
// Date Created : 10-31-2011 
//-----------------------------------------------------------------
// Description:
// This file contains assumptions/assertions for the sbendpoint 
// input signals 
//------------------------------------------------------------------

/****************************************************************************
*assumption for vr_ep_0036
*Assumption - If Master pcirdy is low, implies that pctrdy was high in the past
*****************************************************************************/
property mmsg_pcirdy_valid;
  @(posedge clk) disable iff (reset !== 1) ($fell( mmsg_pcirdy)) |-> ($past(mmsg_pctrdy));
endproperty
if (EP_FPV)
mmsg_pcirdy_valid_prop: assume property (mmsg_pcirdy_valid);
else
mmsg_pcirdy_valid_prop: assert property (mmsg_pcirdy_valid) else $display("ERROR: invalid mmsg_pcirdy deassertion") ;

property mmsg_pceom_valid1;
  @(posedge clk) disable iff (reset !== 1) ($fell( mmsg_pceom)) |-> ($past(mmsg_pctrdy));
endproperty
if (EP_FPV)
mmsg_pceom_valid_prop1: assume property (mmsg_pceom_valid1);
else
mmsg_pceom_valid_prop1: assert property (mmsg_pceom_valid1) else $display("ERROR: invalid mmsg_pceom deassertion") ;

/*****************************************************************************
*Master pceom can be asserted only if master pcirdy is asserted
*****************************************************************************/ 
property mmsg_pceom_valid;
  @(posedge clk) disable iff (reset !== 1) ( mmsg_pceom == 1 ) |-> (mmsg_pcirdy);
endproperty
if (EP_FPV)
mmsg_pceom_valid_prop: assume property (mmsg_pceom_valid);
else
mmsg_pceom_valid_prop: assert property (mmsg_pceom_valid) else $display("ERROR: invalid mmsg_pceom assertion") ;
  
/****************************************************************************
*assumption for vr_ep_0037
*Assumption - If Master npirdy is low, implies that nptrdy was high in the past
*****************************************************************************/
property mmsg_npirdy_valid;
  @(posedge clk) disable iff (reset !== 1) ( $fell(mmsg_npirdy)) |-> ($past(mmsg_nptrdy));
endproperty
if (EP_FPV)  
mmsg_npirdy_valid_prop: assume property (mmsg_npirdy_valid);
else
mmsg_npirdy_valid_prop: assert property (mmsg_npirdy_valid) else $display("ERROR: invalid mmsg_npirdy deassertion") ;

property mmsg_npeom_valid1;
  @(posedge clk) disable iff (reset !== 1) ($fell( mmsg_npeom)) |-> ($past(mmsg_nptrdy));
endproperty
if (EP_FPV)
mmsg_npeom_valid_prop1: assume property (mmsg_npeom_valid1);
else
mmsg_npeom_valid_prop1: assert property (mmsg_npeom_valid1) else $display("ERROR: invalid mmsg_npeom deassertion") ;
  
/*****************************************************************************
*Master npeom can be asserted only if master npirdy is asserted
*****************************************************************************/ 
property mmsg_npeom_valid;
  @(posedge clk) disable iff (reset !== 1) ( mmsg_npeom == 1 ) |-> (mmsg_npirdy);
endproperty
if (EP_FPV)
mmsg_npeom_valid_prop: assume property (mmsg_npeom_valid);
else
mmsg_npeom_valid_prop: assume property (mmsg_npeom_valid) else $display("ERROR: invalid mmsg_npeom deassertion") ;

/*****************************************************************************
*assumption for vr_ep_0038
*Master pcpayload should not change once master pcirdy is asserted 
*****************************************************************************/ 
property mmsg_pcpayload_stable;
  @(posedge clk) disable iff (reset !== 1)
  (~$stable(mmsg_pcpayload)) |-> ($rose(mmsg_pcirdy) | ~mmsg_pcirdy | ($past(mmsg_pctrdy)));
endproperty
if (EP_FPV)
mmsg_pcpayload_stable_prop: assume property (mmsg_pcpayload_stable);
else
mmsg_pcpayload_stable_prop: assume property (mmsg_pcpayload_stable) else $display("ERROR: mmsg_pcpayload not stable") ;

/*****************************************************************************
*assumption for vr_ep_0039
*Master nppayload should not change once master npirdy is asserted 
*****************************************************************************/ 
property mmsg_nppayload_stable;
  @(posedge clk) disable iff (reset !== 1)
  (~$stable(mmsg_nppayload)) |-> ($rose(mmsg_npirdy) | ~mmsg_npirdy | ($past(mmsg_nptrdy)));
endproperty
if (EP_FPV)
mmsg_nppayload_stable_prop: assume property (mmsg_nppayload_stable);
else
mmsg_nppayload_stable_prop: assert property (mmsg_nppayload_stable) else $display("ERROR: mmsg_nppayload not stable") ;

//valid opcode assumption for master reg
property mreg_opcode_vld;
    @(posedge clk) disable iff (reset !== 1) ( $rose(mreg_irdy) || (mreg_irdy)) |-> (mreg_opcode inside {[8'h00:8'h1f]});
endproperty
if (EP_FPV)
mreg_opcode_vld_prop: assume property (mreg_opcode_vld);
else
mreg_opcode_vld_prop: assert property (mreg_opcode_vld) else $display("ERROR: mreg_opcode not stable") ;

//assumption  TODO
property tx_ext_headers_stable;
  @(posedge clk) disable iff (reset !== 1) ( mmsg_npirdy ) |-> $stable(tx_ext_headers);
endproperty
if (EP_FPV)
tx_ext_headers_stable_prop: assume property (tx_ext_headers_stable);
else
tx_ext_headers_stable_prop: assert property (tx_ext_headers_stable) else $display("ERROR: tx_ext_headers not stable") ;

/****************************************************************************
*assumption for vr_ep_0044
*Assumption - If mreg irdy is low, implies that mreg_trdy was high in the past
*****************************************************************************/
property mreg_irdy_valid;
  @(posedge clk) disable iff (reset !== 1) ( $fell(mreg_irdy)) |-> $past(mreg_trdy);
endproperty
if (EP_FPV)
mreg_irdy_valid_prop: assume property (mreg_irdy_valid);
else
mreg_irdy_valid_prop: assert property (mreg_irdy_valid) else $display("ERROR: invalid mreg_irdy deassertion") ;

/****************************************************************************
 * The following few assumptions state that after mreg_irdy goes high, all the
 * other transaction variables must remain stable.
*****************************************************************************/ 
//assumption for vr_ep_0053
property mreg_dest_stable;
  @(posedge clk) disable iff (reset !== 1) 
  (~$stable(mreg_dest)) |-> ($rose(mreg_irdy) | ~mreg_irdy); 
endproperty
if (EP_FPV)
mreg_dest_stable_prop: assume property (mreg_dest_stable);
else
mreg_dest_stable_prop: assert property (mreg_dest_stable) else $display("ERROR: mreg_dest not stable") ;

//assumption for vr_ep_0054
property mreg_source_stable;
  @(posedge clk) disable iff (reset !== 1) 
  (~$stable(mreg_source)) |-> ($rose(mreg_irdy) | ~mreg_irdy); 
endproperty
if (EP_FPV)
mreg_source_stable_prop: assume property (mreg_source_stable);
else
mreg_source_stable_prop: assert property (mreg_source_stable) else $display("ERROR: mreg_source not stable") ;

//asmreg_source_stable_prop: assume property (mreg_source_stable);
//assumption for vr_ep_0055
property mreg_addrlen_stable;
  @(posedge clk) disable iff (reset !== 1) 
  (~$stable(mreg_addrlen)) |-> ($rose(mreg_irdy) | ~mreg_irdy); 
endproperty
if (EP_FPV)
mreg_addrlen_stable_prop: assume property (mreg_addrlen_stable);
else
mreg_addrlen_stable_prop: assert property (mreg_addrlen_stable) else $display("ERROR: mreg_addrlen not stable") ;

//assumption for vr_ep_0056
property mreg_bar_stable;
  @(posedge clk) disable iff (reset !== 1) 
  (~$stable(mreg_bar)) |-> ($rose(mreg_irdy) | ~mreg_irdy);
endproperty
if (EP_FPV)
mreg_bar_stable_prop: assume property (mreg_bar_stable);
else
mreg_bar_stable_prop: assert property (mreg_bar_stable) else $display("ERROR: mreg_bar not stable") ;

//assumption for vr_ep_0057
property mreg_tag_stable;
  @(posedge clk) disable iff (reset !== 1) 
  (~$stable(mreg_tag)) |-> ($rose(mreg_irdy) | ~mreg_irdy);
endproperty
if (EP_FPV)
mreg_tag_stable_prop: assume property (mreg_tag_stable);
else
mreg_tag_stable_prop: assert property (mreg_tag_stable) else $display("ERROR: mreg_tag not stable") ;

//assumption for vr_ep_0058
property mreg_be_stable;
  @(posedge clk) disable iff (reset !== 1) 
  (~$stable(mreg_be)) |-> ($rose(mreg_irdy) | ~mreg_irdy);
endproperty
if (EP_FPV)
mreg_be_stable_prop: assume property (mreg_be_stable);
else
mreg_be_stable_prop: assert property (mreg_be_stable) else $display("ERROR: mreg_be not stable") ;

//assumption for vr_ep_0059
property mreg_fid_stable;
  @(posedge clk) disable iff (reset !== 1) 
  (~$stable(mreg_fid)) |-> ($rose(mreg_irdy) | ~mreg_irdy);
endproperty
if (EP_FPV)
mreg_fid_stable_prop: assume property (mreg_fid_stable);
else
mreg_fid_stable_prop: assert property (mreg_fid_stable) else $display("ERROR: mreg_fid not stable") ;

//assumption for vr_ep_0095
property mreg_addr_stable;
  @(posedge clk) disable iff (reset !== 1) 
  (~$stable(mreg_addr)) |-> ($rose(mreg_irdy) | ~mreg_irdy);
endproperty
if (EP_FPV)
mreg_addr_stable_prop: assume property (mreg_addr_stable);
else
mreg_addr_stable_prop: assert property (mreg_addr_stable) else $display("ERROR: mreg_addr not stable") ;

//assumption 
property mreg_opcode_stable;
  @(posedge clk) disable iff (reset !== 1) 
  (~$stable(mreg_opcode)) |-> ($rose(mreg_irdy) | ~mreg_irdy);
endproperty
if (EP_FPV)
mreg_opcode_stable_prop: assume property (mreg_opcode_stable);
else
mreg_opcode_stable_prop: assert property (mreg_opcode_stable) else $display("ERROR: mreg_opcode not stable") ;

//assumption 
property mreg_wdata_stable;
  @(posedge clk) disable iff (reset !== 1) 
  (~$stable(mreg_wdata)) |-> ($rose(mreg_irdy) | ~mreg_irdy);
endproperty
if (EP_FPV)
mreg_wdata_stable_prop: assume property (mreg_wdata_stable);
else
mreg_wdata_stable_prop: assert property (mreg_wdata_stable) else $display("ERROR: mreg_wdata not stable") ;

property mreg_npwrite_stable;
  @(posedge clk) disable iff (reset !== 1) 
  (~$stable(mreg_npwrite)) |-> ($rose(mreg_irdy) | ~mreg_irdy); 
endproperty
if (EP_FPV)
mreg_npwrite_stable_prop: assume property (mreg_npwrite_stable);
else
mreg_npwrite_stable_prop: assert property (mreg_npwrite_stable) else $display("ERROR: mreg_npwrite not stable") ;

/****************************************************************************
*Assumption - If Master reg irdy is high, then master msg npirdy/pcirdy shd be low
*****************************************************************************/
//Assumption only to simplify agent traffic
property mmsgreg_irdy_valid;
  @(posedge clk) disable iff (reset !== 1) ($rose( mreg_irdy) || (mreg_irdy)) |-> (($past(!mmsg_pcirdy)) 
                                                                    && ($past(!mmsg_npirdy)) 
                                                                    && (!$rose(mmsg_pcirdy)) 
                                                                    && (!$rose(mmsg_npirdy)) 
                                                                    && (!mmsg_pcirdy) 
                                                                    && (!mmsg_npirdy));
endproperty
if (EP_FPV)
mmsgreg_irdy_valid_prop: assume property (mmsgreg_irdy_valid);

/*
//assumption for tmsg_npfree
property mmsg_npfree_rise;
  @(posedge clk) disable iff (reset !== 1) 
  ((tmsg_npput == 1) & (tmsg_npeom == 1)) |-> (tmsg_npfree == 1);
endproperty
if (EP_FPV)
mmsg_npfree_rise: assume property (mmsg_npfree_rise);
else
mmsg_npfree_rise: assert property (mmsg_npfree_rise);

//assumption for tmsg_pcfree
property mmsg_pcfree_rise;
  @(posedge clk) disable iff (reset !== 1) 
  ((tmsg_pcput == 1) & (tmsg_pceom == 1)) |-> (tmsg_pcfree == 1);
endproperty
if (EP_FPV)
mmsg_pcfree_rise: assume property (mmsg_pcfree_rise);
else
mmsg_pcfree_rise: assert property (mmsg_pcfree_rise);

//assumption for tmsg_npfree
property mmsg_npfree_fall;
  @(posedge clk) disable iff (reset !== 1) 
  ((tmsg_npput == 1) && (tmsg_npeom == 0))  |-> (tmsg_npfree == 0);
endproperty
if (EP_FPV)
mmsg_npfree_fall: assume property (mmsg_npfree_fall);
else
mmsg_npfree_fall: assert property (mmsg_npfree_fall);

//assumption for tmsg_pcfree
property mmsg_pcfree_fall;
  @(posedge clk) disable iff (reset !== 1) 
  ((tmsg_pcput == 1) && (tmsg_pceom == 0)) |-> (tmsg_pcfree == 0);
endproperty
if (EP_FPV)
mmsg_pcfree_fall: assume property (mmsg_pcfree_fall);
else
mmsg_pcfree_fall: assert property (mmsg_pcfree_fall);
*/
/**************************************************************************
* If pcput is asserted and pceom is not, the PC msgip should be asserted
**************************************************************************/  
//assumption for vr_ep_0024
/*property pcput_pceom_stable;
  @(posedge clk) disable iff (reset !== 1) ((tmsg_pcput==1) && (tmsg_pceom==0)) |-> ( tmsg_pcmsgip==1);
endproperty
if (EP_FPV)
pcput_pceom_stable_prop: assume property (pcput_pceom_stable);
else
pcput_pceom_stable_prop: assert property (pcput_pceom_stable);
*/
/**************************************************************************
 * if msgip went low, implies that trdy was asserted and then deasserted after
 * the message completed
**************************************************************************/ 
//assumption for vr_ep_0041
/*property nmsgip_trdy_fell;
  @(posedge clk)  disable iff (reset !== 1) ($fell(mreg_nmsgip)) |-> ($fell(mreg_trdy));
endproperty
if (EP_FPV)
nmsgip_trdy_fell_prop: assume property (nmsgip_trdy_fell);
else
nmsgip_trdy_fell_prop: assert property (nmsgip_trdy_fell);
*/
/**************************************************************************
 * assumption for vr_ep_0074
 * Once pcvalid is asserted, Target pcpayload must not change value
**************************************************************************/  
/*property pcvalid_payload_stable;
  @(posedge clk)  disable iff (reset !== 1) tmsg_pcvalid |-> ($stable(tmsg_pcpayload));
endproperty
if (EP_FPV)
pcvalid_payload_stableassume: assume property (pcvalid_payload_stable);
else
pcvalid_payload_stableassume: assert property (pcvalid_payload_stable);
*/
/**************************************************************************
 * assumption for vr_ep_0073
 * Once npvalid is asserted, Target nppayload must not change value
**************************************************************************/ 
/*property npvalid_payload_stable;
  @(posedge clk)  disable iff (reset !== 1) tmsg_npvalid |-> ($stable(tmsg_nppayload));
endproperty
if (EP_FPV)
npvalid_payload_stableassume: assume property (npvalid_payload_stable);
else
npvalid_payload_stableassume: assert property (npvalid_payload_stable);
*/
//assumption for vr_ep_0021
/*property npput_npeom_stable;
  @(posedge clk) disable iff (reset !== 1) ((tmsg_npput==1) && (tmsg_npeom==0)) |-> ( tmsg_npmsgip==1);
endproperty
if (EP_FPV)
npput_npeom_stable_prop: assume property (npput_npeom_stable);   
else
npput_npeom_stable_prop: assert property (npput_npeom_stable);   
*/

/*bit [7:0] pc_opcode,np_opcode;
assign pc_opcode = mmsg_pcpayload[((32*(MAXPCMSTR+1))-9):((32*(MAXPCMSTR+1))-16)];
assign np_opcode = mmsg_nppayload[((32*(MAXNPMSTR+1))-9):((32*(MAXNPMSTR+1))-16)];
*/
/***************************************************************************************
 Valid range of NP opcodes
***************************************************************************************/ 
/*property np_opcode_vld;   
  @(posedge clk) disable iff(reset !== 1)
  (mmsg_npirdy) |->
  ((( AGT_PM_REQ <= np_opcode ) && (np_opcode <= AGT_LTR)) || ((AGT_PCI_PM <= np_opcode) && (np_opcode <=AGT_PCI_E_ERROR)) ||
    ((AGT_DATA_EP_RANGE_MIN <= np_opcode) && (np_opcode <= AGT_DATA_EP_RANGE_MAX))||
  (( AGT_ASSERT_INTA <=np_opcode ) && (np_opcode <= AGT_DO_SERR)) || (np_opcode==AGT_ASSERT_PME) || (np_opcode == AGT_DEASSERT_PME)
      || ((AGT_SIMPLE_EP_RANGE_MIN <= np_opcode) && (np_opcode <= AGT_SIMPLE_EP_RANGE_MAX)) ||
  ((AGT_MRD <=np_opcode) && (np_opcode <= AGT_CRWR)) || 
   ((AGT_REG_EP_RANGE_MIN <= np_opcode) && (np_opcode <= AGT_REG_EP_RANGE_MAX)));
   
endproperty
if (EP_FPV)
np_opcode_vld_prop : assume property (np_opcode_vld);
else
np_opcode_vld_prop : assert property (np_opcode_vld);
*/
/***************************************************************************************
 Valid range of PC opcodes
***************************************************************************************/ 
/*property pc_opcode_vld;   
  @(posedge clk) disable iff(reset !== 1)
  (mmsg_pcirdy)|->
  ((( AGT_PM_REQ <= pc_opcode ) && (pc_opcode <= AGT_LTR)) || ((AGT_PCI_PM <= pc_opcode) && (pc_opcode <= AGT_PCI_E_ERROR)) ||
       ((AGT_DATA_EP_RANGE_MIN <= pc_opcode) && (pc_opcode <= AGT_DATA_EP_RANGE_MAX)) ||
  (( AGT_ASSERT_INTA <=pc_opcode ) && (pc_opcode <= AGT_DO_SERR)) || (AGT_ASSERT_PME <= pc_opcode) || (pc_opcode <=AGT_DEASSERT_PME)
      || ((AGT_SIMPLE_EP_RANGE_MIN <= pc_opcode) && (pc_opcode <= AGT_SIMPLE_EP_RANGE_MAX))||
  (pc_opcode==AGT_MWR) || (pc_opcode == AGT_CRWR) || 
    ((AGT_REG_EP_RANGE_MIN <= pc_opcode) && (pc_opcode <= AGT_REG_EP_RANGE_MAX))||
  ((AGT_CMP <=pc_opcode ) && (pc_opcode <= AGT_CMPD)));
endproperty
if (EP_FPV)
pc_opcode_vld_prop : assume property (pc_opcode_vld);
else
pc_opcode_vld_prop : assert property (pc_opcode_vld);

 
property mreg_opcode_vld;
   @(posedge clk) disable iff(reset !== 1) mreg_irdy |->
     (((AGT_MRD <=mreg_opcode) && (mreg_opcode<=AGT_CRWR)) || 
      ((AGT_REG_EP_RANGE_MIN <= mreg_opcode) && (mreg_opcode<=AGT_REG_EP_RANGE_MAX)));   
endproperty
if (EP_FPV)
mreg_opcode_vld_prop : assume property (mreg_opcode_vld);
else
mreg_opcode_vld_prop : assert property (mreg_opcode_vld);

*/

