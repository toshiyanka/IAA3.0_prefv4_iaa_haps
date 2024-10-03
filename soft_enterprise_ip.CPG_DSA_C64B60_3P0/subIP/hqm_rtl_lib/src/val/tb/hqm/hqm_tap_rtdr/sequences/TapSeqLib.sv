//------------------------------------------------------------------------------
//  %header_copyright%
//
//  Collateral Description:
//  dteg-jtag_bfm
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  CHASSIS_JTAGBFM_2018WW12_R3.3
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2018 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : TapSequences.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : Sequences for the ENV 
//    DESCRIPTION : This Component defines various sequences that are 
//                  needed to drive and test the DUT including the Random
//------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------
// Sequence to Override the Config using override register
//-----------------------------------------------------------------------------------------------
class TapSequenceReset extends JtagBfmPkg::JtagBfmSequences;

    // Packet fro Sequencer to Driver
    JtagBfmPkg::JtagBfmSeqDrvPkt Packet;
    
    // Register component with Factory
    function new(string name = "TapConfigure");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TapSequenceReset, JtagBfmPkg::JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        Reset(2'b01);
    endtask : body

endclass : TapSequenceReset

class TapSequenceGoToRuti extends JtagBfmPkg::JtagBfmSequences;

    JtagBfmPkg::JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceGoToRuti");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TapSequenceGoToRuti, JtagBfmPkg::JtagBfmSequencer)

    virtual task body();
        Goto(JtagBfmUserDatatypesPkg::RUTI,10);
    endtask : body

endclass : TapSequenceGoToRuti

//------------------------------------
//-- Sequence-5
//-- Cfg sTAP0   - Sec
//--     sTAP1   - Prim
//--     sTAP2,3 - Teritiray
//-- Put them all in Bypass
//-- TapSequenceHier_sTAP1onPri_Bypass  -> PriSequencer
//-- TapSequenceHier_sTAP0onSec_Bypass  -> PriSequencer
//-- TapSequenceHier_sTAP23onTer_Bypass -> TerSequencer
//------------------------------------

class TapSequenceHierCfg_sTap1Pri_sTAP23Ter_Bypass extends JtagBfmPkg::JtagBfmSequences;

    JtagBfmPkg::JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierCfg_sTap1Pri_sTAP23Ter_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TapSequenceHierCfg_sTap1Pri_sTAP23Ter_Bypass, JtagBfmPkg::JtagBfmSequencer)

    virtual task body();
        //Reset(2'b11);
        // CLTAP_Level - sTAP0 on Sec, sTAP1 on Prim
////        MultipleTapRegisterAccess(2'b00,8'h10,2'b01,8,2);
////        // CLTAP_Level - All on Normal
////        MultipleTapRegisterAccess(2'b00,8'h11,4'b0101,8,4);
////        // STAP1_Level - All on Normal
////        MultipleTapRegisterAccess(2'b00,16'hFF_11,5'b1_0101,16,5);
////        // STAP1_Level - All on secondary
////        MultipleTapRegisterAccess(2'b00,16'hFF_10,3'b1_11,16,3);

        // STAP1_Level - All on secondary
        MultipleTapRegisterAccess(2'b00,16'hFF_10,3'b1_11,16,3);

    endtask : body

endclass : TapSequenceHierCfg_sTap1Pri_sTAP23Ter_Bypass




