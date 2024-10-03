//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2020 Intel Corporation All Rights Reserved.
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
//  2020WW22_PICr33
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : TapCoverage.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : Black Box Coverage for the sTAP
//    DESCRIPTION : Contains the defination for the coverage bins
//----------------------------------------------------------------------

`include "uvm_macros.svh"

class TapCoverage extends uvm_scoreboard;

    // Packet from Input and Output Monitor
    JtagBfmInMonSbrPkt     InputPacket;
    TapInMonIntSbrPkt  InputIntPacket;
    JtagBfmOutMonSbrPkt    OutputPacket;

    uvm_analysis_export #(JtagBfmInMonSbrPkt)     InputMonExport;
    uvm_analysis_export #(TapInMonIntSbrPkt)  InputMonIntExport;
    uvm_analysis_export #(JtagBfmOutMonSbrPkt)    OutputMonExport;
    
    // TLM fifo for input and output monitor
    uvm_tlm_analysis_fifo #(JtagBfmInMonSbrPkt)     InputMonFifo;
    uvm_tlm_analysis_fifo #(TapInMonIntSbrPkt)  InputMonIntFifo;
    uvm_tlm_analysis_fifo #(JtagBfmOutMonSbrPkt)    OutputMonFifo;
    
    // Local Variables
    bit                                in_txn_covered = 1'b0;
    bit [3:0]                          state          = 4'b0;
    reg [(NO_OF_TAP*2)-1:0]            mode_reg;
    bit                                scan_ir ;
    int                                modex;
    bit [2:0]                          excluded_mode_chk[NO_OF_TAP-1:0];
    bit [1:0]                          mode_chk[NO_OF_TAP-1:0];
    bit [NO_OF_STAP -1 :0]             stap_sec_sel;
    int i;

    // Constructor
    function new(string name          = "TapCoverage",
                 uvm_component parent = null);
        super.new(name,parent);
        InputPacket         = new();
        InputIntPacket      = new();
        OutputPacket        = new();

        InputMonExport      = new("InputMonExport", this);
        InputMonIntExport   = new("InputMonIntExport", this);
        OutputMonExport     = new("OutputMonExport", this);
        
        InputMonFifo        = new("InputMonFifo", this);
        InputMonIntFifo     = new("InputMonIntFifo", this);
        OutputMonFifo       = new("OutputMonFifo", this);
        
        cg1_all_stap_modes_except_excluded_cov   = new;
        cg2_all_stap_modes_excluded_cov          = new;
        cg3_all_stap_primary_secondary_cov       = new;
        cg4_all_stap_modes_ports                 = new;
    endfunction : new

    // Register component with Factory 
    `uvm_component_utils(TapCoverage)

    // assign the virtual interface
    function void connect_phase (uvm_phase phase);
        InputMonExport.connect(InputMonFifo.analysis_export);
        InputMonIntExport.connect(InputMonIntFifo.analysis_export);
        OutputMonExport.connect(OutputMonFifo.analysis_export);
    endfunction : connect_phase

    // run phase
    virtual task run_phase (uvm_phase phase);
        forever begin
            InputMonFifo.get(InputPacket);
            OutputMonFifo.try_get(OutputPacket);
            InputMonIntFifo.get(InputIntPacket);
            mode_reg <=  InputIntPacket.enable_tap;
            this.scan_ir = ( InputPacket.FsmState == SHIR ) | 
               ( InputPacket.FsmState == CAIR ) |
               ( InputPacket.FsmState == E1IR ) |
               ( InputPacket.FsmState == E2IR ) |
               ( InputPacket.FsmState == PAIR ) |
               ( InputPacket.FsmState == UPIR ) |
               ( InputPacket.FsmState == SIRS ) ;
            sample_cvr_grps();   
            for(i = 0; i<NO_OF_TAP; i++  )begin
                this.excluded_mode_chk[i] = {scan_ir, InputIntPacket.enable_tap[i], InputIntPacket.enable_tdo[i]};
            end

            for(i = 0; i<NO_OF_TAP; i++  )begin
                this.mode_chk[i] = {InputIntPacket.enable_tap[i], InputIntPacket.enable_tdo[i]};
            end
            //this.stap_sec_sel = {InputIntPacket.sec_sel[1],InputIntPacket.sec_sel[3],InputIntPacket.sec_sel[4],InputIntPacket.sec_sel[6]};
            this.stap_sec_sel = {InputIntPacket.sec_sel[(NO_OF_TAP-1):0]};
       end
    endtask

    // Cover Group Defination Starts
    covergroup cg1_all_stap_modes_except_excluded_cov;
      wtap0_modes: coverpoint mode_chk[0]
         {
            bins wtap0_decoupled = { 2'b00 }; 
            bins wtap0_normal    = { 2'b11 }; 
            bins wtap0_shadow    = { 2'b10 }; 
         }
      stap0_modes: coverpoint mode_chk[1]
         {
            bins stap0_decoupled = { 2'b00 }; 
            bins stap0_normal    = { 2'b11 }; 
            bins stap0_shadow    = { 2'b10 }; 
         }
      wtap1_modes: coverpoint mode_chk[2]
         {
            bins wtap1_decoupled = { 2'b00 }; 
            bins wtap1_normal    = { 2'b11 }; 
            bins wtap1_shadow    = { 2'b10 }; 
         }
      stap1_modes: coverpoint mode_chk[3]
         {
            bins stap1_decoupled = { 2'b00 }; 
            bins stap1_normal    = { 2'b11 }; 
            bins stap1_shadow    = { 2'b10 }; 
         }
      stap2_modes: coverpoint mode_chk[4]
         {
            bins stap2_decoupled = { 2'b00 }; 
            bins stap2_normal    = { 2'b11 }; 
            bins stap2_shadow    = { 2'b10 }; 
         }
      wtap2_modes: coverpoint mode_chk[5]
         {
            bins wtap2_decoupled = { 2'b00 }; 
            bins wtap2_normal    = { 2'b11 }; 
            bins wtap2_shadow    = { 2'b10 }; 
         }
      stap3_modes: coverpoint mode_chk[6]
         {
            bins stap3_decoupled = { 2'b00 }; 
            bins stap3_normal    = { 2'b11 }; 
            bins stap3_shadow    = { 2'b10 }; 
         }
      wtap3_modes: coverpoint mode_chk[7]
         {
            bins wtap3_decoupled = { 2'b00 }; 
            bins wtap3_normal    = { 2'b11 }; 
            bins wtap3_shadow    = { 2'b10 }; 
         }
   endgroup

   covergroup cg2_all_stap_modes_excluded_cov;
      stap0_mode: coverpoint excluded_mode_chk[1]
         {
            bins stap0_excluded  = { 3'b111 };
         }
      stap1_mode: coverpoint excluded_mode_chk[3]
         {
            bins stap1_excluded  = { 3'b111 };
         }
      stap2_mode: coverpoint excluded_mode_chk[4]
         {
            bins stap2_excluded  = { 3'b111 };
         }
      stap3_mode: coverpoint excluded_mode_chk[6]
         {
            bins stap3_excluded  = { 3'b111 };
         }
   endgroup

   covergroup cg3_all_stap_primary_secondary_cov;
      staps_prim_sec: coverpoint {stap_sec_sel}
         {
            bins all_staps_prim  = {0}; 
            //bins all_staps_sec   = { [1:15] }; 
            bins others[]        = default;  
         }
      taps_prim: coverpoint {InputIntPacket.sec_sel[(NO_OF_TAP-1):0]}
         {
            bins all_staps_prim  = {0};  
         }
   endgroup
   
   covergroup cg4_all_stap_modes_ports;
      //all_staps_modes_ports: cross cg1_all_stap_modes_except_excluded_cov, cg3_all_stap_primary_secondary_cov;
      stap0_modes_ports: cross cg1_all_stap_modes_except_excluded_cov.stap0_modes, cg3_all_stap_primary_secondary_cov.staps_prim_sec;
      stap1_modes_ports: cross cg1_all_stap_modes_except_excluded_cov.stap1_modes, cg3_all_stap_primary_secondary_cov.staps_prim_sec;
      stap2_modes_ports: cross cg1_all_stap_modes_except_excluded_cov.stap2_modes, cg3_all_stap_primary_secondary_cov.staps_prim_sec;
      stap3_modes_ports: cross cg1_all_stap_modes_except_excluded_cov.stap3_modes, cg3_all_stap_primary_secondary_cov.staps_prim_sec;
      
      stap0_ex_prim: cross cg2_all_stap_modes_excluded_cov.stap0_mode, cg3_all_stap_primary_secondary_cov.taps_prim;
      stap1_ex_prim: cross cg2_all_stap_modes_excluded_cov.stap1_mode, cg3_all_stap_primary_secondary_cov.taps_prim;
      stap2_ex_prim: cross cg2_all_stap_modes_excluded_cov.stap2_mode, cg3_all_stap_primary_secondary_cov.taps_prim;
      stap3_ex_prim: cross cg2_all_stap_modes_excluded_cov.stap3_mode, cg3_all_stap_primary_secondary_cov.taps_prim;
  
   endgroup

    function void sample_cvr_grps();
      cg1_all_stap_modes_except_excluded_cov.sample(); 
      cg2_all_stap_modes_excluded_cov.sample();
      cg3_all_stap_primary_secondary_cov.sample();
    endfunction

endclass : TapCoverage
