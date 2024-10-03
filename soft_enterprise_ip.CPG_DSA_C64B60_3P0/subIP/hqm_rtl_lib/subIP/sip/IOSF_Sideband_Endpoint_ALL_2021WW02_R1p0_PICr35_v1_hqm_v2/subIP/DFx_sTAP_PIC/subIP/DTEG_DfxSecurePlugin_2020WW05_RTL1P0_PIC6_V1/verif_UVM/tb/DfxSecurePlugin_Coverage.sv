//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2016 Intel Corporation All Rights Reserved.
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
//
//  Collateral Description:
//  %header_collateral%
//
//  Source organization:
//  %header_organization%
//
//  Support Information:
//  %header_support%
//
//  Revision:
//  %header_tag%
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : DfxSecurePlugin_Coverage.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : Coverage for the DfxSecurePlugin ENV
//    DESCRIPTION : This component models the behaviour of the RTL
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_Coverage
`define INC_DfxSecurePlugin_Coverage

class DfxSecurePlugin_Coverage #(`DSP_TB_PARAMS_DECL) extends uvm_scoreboard;

    // Packet Received from Monitors
    DfxSecurePlugin_InpMonTxn#(`DSP_TB_PARAMS_INST)    InputPacket;
    DfxSecurePlugin_OutMonTxn#(`DSP_TB_PARAMS_INST)    OutputPacket;
    
    // Connection ports to Monitors
    uvm_analysis_export #(DfxSecurePlugin_InpMonTxn)  InputMonExport;
    uvm_analysis_export #(DfxSecurePlugin_OutMonTxn)  OutputMonExport;

    // TLM fifo for input and output monitor 
    uvm_tlm_analysis_fifo #(DfxSecurePlugin_InpMonTxn)    InputMonFifo;
    uvm_tlm_analysis_fifo #(DfxSecurePlugin_OutMonTxn)    OutputMonFifo;

   // Factory Registration
   `uvm_component_param_utils(DfxSecurePlugin_Coverage#(`DSP_TB_PARAMS_INST))

   /***************************************************************
    * Standard UVM new function creates a new object 
    *  @param name    : uvm name
    *  @param parent  : uvm parent component
    ***************************************************************/
   function new (string name = "DfxSecurePlugin_Coverage", uvm_component parent = null);
      super.new (name, parent);
      InputMonExport     = new("InputMonExport", this);
      OutputMonExport    = new("OutputMonExport", this);
      InputMonFifo       = new("InputMonFifo", this);
      OutputMonFifo      = new("OutputMonFifo", this);
      cg1_control        = new();
      cg2_policy_use1    = new();
      cg3_policy_use0    = new();
   endfunction : new

   /***************************************************************
    * Standard UVM build function
    ***************************************************************/
   function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      InputPacket        =DfxSecurePlugin_InpMonTxn#(`DSP_TB_PARAMS_INST)::type_id::create("InputPacket",this);
      OutputPacket       =DfxSecurePlugin_OutMonTxn#(`DSP_TB_PARAMS_INST)::type_id::create("OutputPacket",this);
   endfunction : build_phase
   /***************************************************************
    * Standard UVM connect function
    ***************************************************************/
   function void connect_phase (uvm_phase phase);
      InputMonExport.connect(InputMonFifo.analysis_export);
      OutputMonExport.connect(OutputMonFifo.analysis_export);
   endfunction : connect_phase
   
   
   /**************************************************************
    * Run Phase
    **************************************************************/
   task run_phase (uvm_phase phase);
      string msg;
         forever begin
            InputMonFifo.get(InputPacket);
            OutputMonFifo.get(OutputPacket);
            sample_cvr_grps();
         end
   endtask
  
   

   //-------------------------------------------------------
   function void sample_cvr_grps ();
      cg1_control.sample();
      if (TB_DFX_USE_SB_OVR == 1) begin
         cg2_policy_use1.sample();
      end
      else begin
         cg3_policy_use0.sample();
      end
      //cg2_cross_pol.sample();
   endfunction : sample_cvr_grps
   
   //-------------------------------------------------------
   covergroup cg1_control;
      fdfxpowergood: coverpoint InputPacket.fdfx_powergood
         {
             bins hi = {'h1}; 
             bins lo = {'h0}; 
         }
      fdfxearlbootexit: coverpoint InputPacket.fdfx_earlyboot_exit
         {
             bins hi = {'h1}; 
             bins lo = {'h0}; 
         }
      fdfxpolicyupdate: coverpoint InputPacket.fdfx_policy_update
         {
             bins hi = {'h1}; 
             bins lo = {'h0}; 
         }
      visaalldis: coverpoint OutputPacket.visa_all_dis
         {
             bins hi = {'h1}; 
             bins lo = {'h0}; 
         }
      visacustomerdis: coverpoint OutputPacket.visa_customer_dis
         {
             bins hi = {'h1}; 
             bins lo = {'h0}; 
         }
      crossvisas: cross visaalldis, visacustomerdis;
   endgroup
   
   //-------------------------------------------------------
   // TB_DFX_USE_SB_OVR = 1
   covergroup cg2_policy_use1;
      fdfxsecurepolicy: coverpoint InputPacket.fdfx_secure_policy
         {
             bins securepolicy[] = {[0 : (2**TB_DFX_SECURE_WIDTH) - 1]}; 
         }
      sbpolicyovrvalue: coverpoint InputPacket.sb_policy_ovr_value
         {
             bins sbpolicyovr[] = {[0 : (2**(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1)) - 1]}; 
         }
      oemsecurepolicy: coverpoint InputPacket.oem_secure_policy
         {
             bins oemsecure[] = {[7 : (2**TB_DFX_SECURE_WIDTH) - 2]}; 
         }
      dfxsecurefeatureen: coverpoint OutputPacket.dfxsecure_feature_en
         {
             bins featureen[] = {[0 : (2**TB_DFX_NUM_OF_FEATURES_TO_SECURE) - 1]}; 
         }
   endgroup
   
   //-------------------------------------------------------
   // TB_DFX_USE_SB_OVR = 0
   covergroup cg3_policy_use0;
      fdfxsecurepolicy: coverpoint InputPacket.fdfx_secure_policy
         {
             bins securepolicy[] = {[0 : (2**TB_DFX_SECURE_WIDTH) - 1]}; 
         }
      sbpolicyovrvalue: coverpoint InputPacket.sb_policy_ovr_value
         {
             bins sbpolicyovr[] = {[0 : 0]}; 
         }
      oemsecurepolicy: coverpoint InputPacket.oem_secure_policy
         {
             bins oemsecure[] = {[0 : 0]}; 
         }
      dfxsecurefeatureen: coverpoint OutputPacket.dfxsecure_feature_en
         {
             bins featureen[] = {[0 : (2**TB_DFX_NUM_OF_FEATURES_TO_SECURE) - 1]}; 
         }
   endgroup
   //covergroup cg2_cross_pol;
   //   cgupdatepolicy: cross cg2_policy.fdfxsecurepolicy, cg1_control.fdfxpolicyupdate
   //endgroup
endclass : DfxSecurePlugin_Coverage

`endif // INC_DfxSecurePlugin_Coverage
