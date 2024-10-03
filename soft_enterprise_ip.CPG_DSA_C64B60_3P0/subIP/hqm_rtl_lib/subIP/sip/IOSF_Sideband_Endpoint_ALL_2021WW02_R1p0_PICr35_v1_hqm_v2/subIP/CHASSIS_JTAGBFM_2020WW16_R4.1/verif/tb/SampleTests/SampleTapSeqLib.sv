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
//  dteg-jtag_bfm
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  CHASSIS_JTAGBFM_2020WW16_R4.1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
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
class TapSequenceReset extends JtagBfmSequences;

    // Packet fro Sequencer to Driver
    JtagBfmSeqDrvPkt Packet;
    
    // Register component with Factory
    function new(string name = "TapConfigure");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TapSequenceReset, JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        Reset(2'b01);
    endtask : body

endclass : TapSequenceReset

class TapSequenceGoToRuti extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceGoToRuti");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TapSequenceGoToRuti, JtagBfmSequencer)

    virtual task body();
        Goto(RUTI,10);
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

class TapSequenceHierCfg_sTap1Pri_sTAP23Ter_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierCfg_sTap1Pri_sTAP23Ter_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TapSequenceHierCfg_sTap1Pri_sTAP23Ter_Bypass, JtagBfmSequencer)

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

class TapSequenceHier_sTAP1onPri_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHier_sTAP1onPri_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TapSequenceHier_sTAP1onPri_Bypass, JtagBfmSequencer)

    virtual task body();
        // Placig sTAP1 on primary port of master
        // And in this topology for Hierarchical network, the Teritiary port is enabled.
        // Hence the data that would come out is after 2flops of bypass due to the Taps on Level-1 netowrk.
        ExpData_MultipleTapRegisterAccess( 2'b00,              // No Assert trst_b   
                                          16'hFF_FF,           // CLTAP, sTAP1 Bypass 
                                          16,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFFC,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);
    endtask : body

endclass : TapSequenceHier_sTAP1onPri_Bypass 

class TapSequenceHier_sTAP23onTer_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHier_sTAP23onTer_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TapSequenceHier_sTAP23onTer_Bypass, JtagBfmSequencer)

    virtual task body();
        // Placig all the TAP's on secondary port will  cause the TAP's on level-2 network to go on teritiary port.
        // And in this topology for Hierarchical network, the Teritiary port is not enabled.
        // Hence the data that would come out is after 2flops of bypass due to the Taps on Level-1 netowrk.
        Goto(TLRS,10);
        ExpData_MultipleTapRegisterAccess( 2'b00,              // No Assert trst_b   
                                          16'hFF_FF,              // sTAP0 Bypass 
                                          16,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFFC,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);
    endtask : body

endclass : TapSequenceHier_sTAP23onTer_Bypass

//------------------------------------
//-- Sequence-6
//-- Cfg sTAP0   - Isolated
//--     sTAP1   - Secondary
//--     sTAP2,3 - Primary
//-- Put them all in Bypass
//-- TapSequenceHier_sTAP1onSec_Bypass -> SecSequencer
//-- TapSequenceHier_sTAP2onPri_Bypass -> PriSequencer
//------------------------------------

class TapSequenceHierCfg_sTap1Sec_sTAP2Pri_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierCfg_sTap1Sec_sTAP2Pri_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TapSequenceHierCfg_sTap1Sec_sTAP2Pri_Bypass, JtagBfmSequencer)

    virtual task body();
        // CLTAP_Level - Enable s1
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0100,8,4);
        // STAP1_Level - Enable s2
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_11,6'b1_1_0001,24,6);
        // STAP1_Level - All on Pri
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_10,4'b1_1_00,24,4);
        // CLTAP_Level - s1 on Sec
        MultipleTapRegisterAccess(2'b00,8'h10,2'b10,8,2);

        //--// Enable s1
        //--MultipleTapRegisterAccess(2'b00,8'h11,4'b01_00,8,4);
        //--// Enable s2
        //--MultipleTapRegisterAccess(2'b00,16'hFF_11,5'b1_00_01,16,5);
        //--// Enable s1 on sec
        //--MultipleTapRegisterAccess(2'b00,24'h10_FF_FF,4'b10_1_1,24,4);
        //--//MultipleTapRegisterAccess(2'b00,8'h10,2'b10,8,2);
    endtask : body

endclass : TapSequenceHierCfg_sTap1Sec_sTAP2Pri_Bypass

class TapSequenceHier_sTAP1onSec_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHier_sTAP1onSec_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TapSequenceHier_sTAP1onSec_Bypass, JtagBfmSequencer)

    virtual task body();
        // Placig all the TAP's on secondary port will  cause the TAP's on level-2 network to go on teritiary port.
        // And in this topology for Hierarchical network, the Teritiary port is not enabled.
        // Hence the data that would come out is after 2flops of bypass due to the Taps on Level-1 netowrk.
        Goto(TLRS,10); 
        ExpData_MultipleTapRegisterAccess( 2'b00,              // No Assert trst_b   
                                          08'hFF,              // sTAP0 Bypass 
                                          08,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFFE,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);
    endtask : body

endclass : TapSequenceHier_sTAP1onSec_Bypass 

class TapSequenceHier_sTAP2onPri_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHier_sTAP2onPri_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TapSequenceHier_sTAP2onPri_Bypass, JtagBfmSequencer)

    virtual task body();
        // Placig all the TAP's on secondary port will  cause the TAP's on level-2 network to go on teritiary port.
        // And in this topology for Hierarchical network, the Teritiary port is not enabled.
        // Hence the data that would come out is after 2flops of bypass due to the Taps on Level-1 netowrk.
        Goto(TLRS,10);
        ExpData_MultipleTapRegisterAccess( 2'b00,              // No Assert trst_b   
                                          16'hFF_FF,              // sTAP0 Bypass 
                                          16,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFFC,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);
    endtask : body

endclass : TapSequenceHier_sTAP2onPri_Bypass

class TapSequenceTry extends JtagBfmSoCTapNwSequences;
 
    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceTry");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `ovm_sequence_utils(TapSequenceTry, JtagBfmSequencer)
 
    virtual task body();

    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;

       BuildTapDataBase();

       Reset(2'b11);
       
       TapAccess(.Tap(CLTAP), 
                 .Opcode('hA0), 
                 .ShiftIn('1), 
                 .ShiftLength(1000000), 
                 .CompareMask('1),
                 .ExpectedData({ {999968{1'b1}} , {32{1'b0}} }),
                 .EnRegisterPresenceCheck(0), 
                 .ReturnTdo(ReturnTdo));
    endtask : body 

endclass : TapSequenceTry



class TapSequenceFail_1_Layer0 extends JtagBfmSoCTapNwSequences;
 
    function new(string name = "TapSequenceFail_1_Layer0");
        super.new(name);
    endfunction : new
 
    `ovm_sequence_utils(TapSequenceFail_1_Layer0, JtagBfmSequencer)
 
    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;

       $display("Layer0 started");
       BuildTapDataBase();
       Reset(2'b11);
       TapAccess(CLTAP, 8'hA0, 32'h1234ABCD, 32, 0,  0, 1, 0, ReturnTdo);
       $display("Layer0 started");
    endtask : body 

endclass : TapSequenceFail_1_Layer0


class TapSequenceFail_1_Layer1 extends TapSequenceFail_1_Layer0;
 
    function new(string name = "TapSequenceFail_1_Layer1");
        super.new(name);
    endfunction : new
 
    `ovm_sequence_utils(TapSequenceFail_1_Layer1, JtagBfmSequencer)
 
    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       super.body();

       $display("Layer1 started");
       TapAccess(STAP0, 8'hA0, 32'h00AA00AA, 32,            0,  0, 1, 0, ReturnTdo);
       TapAccess(STAP1, 8'hA0, 32'hFF00FF00, 32,            0,  0, 1, 0, ReturnTdo);
       TapAccess(CLTAP, 8'hA0, 32'h1,        32, 32'h1234ABCD, '1, 1, 0, ReturnTdo);
       $display("Layer1 ended");
    endtask : body 

endclass : TapSequenceFail_1_Layer1

class TapSequenceFail_1 extends TapSequenceFail_1_Layer1;

    function new(string name = "TapSequenceFail_1");
        super.new(name);
    endfunction : new
 
    `ovm_sequence_utils(TapSequenceFail_1, JtagBfmSequencer)
 
    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       $display("Layer started");
       super.body();
       $display("Layer ended");
    endtask : body 

endclass : TapSequenceFail_1

class TapSequenceFail_2 extends TapSequenceFail_1_Layer1;

    function new(string name = "TapSequenceFail_2");
        super.new(name);
    endfunction : new
 
    `ovm_sequence_utils(TapSequenceFail_2, JtagBfmSequencer)
 
    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       BuildTapDataBase();
//       Reset(2'b11);
//       TapAccess(CLTAP, 'h34, 32'hFF00FFAA, 32, 0, 0, 0, 0, ReturnTdo);
//       TapAccess(STAP0, 'hA0, 32'hBBCCFFDD, 32, 0, 0, 0, 0, ReturnTdo);
//       RemoveTap(CLTAP);
//       TapAccess(STAP0, 'h50, 32'h123,      10, 0, 0, 0, 0, ReturnTdo);

      SelectFsmPathToUpdr(1);

      TapAccess(
         .Tap(CLTAP), 
         .Opcode(8'h34), 
         .ShiftIn(32'h1), 
         .ShiftLength(32), 
         .ExpectedData('0),
         .CompareMask('0),
         .EnUserDefinedShiftLength(1),
         .EnRegisterPresenceCheck(0), 
         .ReturnTdo(ReturnTdo));


      TapAccess(
         .Tap(CLTAP), 
         .Opcode(8'h34), 
         .ShiftIn(32'h4), 
         .ShiftLength(32), 
         .ExpectedData('0),
         .CompareMask('0),
         .EnUserDefinedShiftLength(1),
         .EnRegisterPresenceCheck(0), 
         .ReturnTdo(ReturnTdo));

//      RemoveTap(CLTAP); 
//      TapAccessSlaveIdcode(STAP29); 
        TapAccessCltapcIdcode(CLTAP);

    endtask : body 

endclass : TapSequenceFail_2


class TapSequenceFail_3 extends TapSequenceFail_1_Layer1;

    function new(string name = "TapSequenceFail_3");
        super.new(name);
    endfunction : new
 
    `ovm_sequence_utils(TapSequenceFail_3, JtagBfmSequencer)
 
    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       BuildTapDataBase();
       Reset(2'b11);
       TapAccessSlaveIdcode(STAP6); 
       DisableTap (STAP2);
       TapAccessSlaveIdcode(STAP3); 
       TapAccessSlaveIdcode(STAP4); 
       TapAccessSlaveIdcode(STAP5); 
       TapAccessSlaveIdcode(STAP6); 
       TapAccessSlaveIdcode(STAP7); 
    endtask : body 

endclass : TapSequenceFail_3



class Tap3levelHierSequenceTry extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap3levelHierSequenceTry");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `ovm_sequence_utils(Tap3levelHierSequenceTry, JtagBfmSequencer)
 
    virtual task body();
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       BuildTapDataBase();
       Reset(2'b11);
//       TapAccess(CLTAP, 'h02, 0, 0, 0, 1'b0); 
//       TapAccess(STAP1, 'h0C, 0, 0, 0, 1'b0); 
//       TapAccess(STAP3, 'h0C, 0, 0, 0, 1'b0); 
//       TapAccess(STAP4, 'h0C, 0, 0, 0, 1'b0); 
//       /* Passing Accesses - Random.
//       TapAccess(CLTAP, TAP_BYPASS1, READ, 1'b0); 
//       TapAccess(CLTAP, TAP_BYPASS1, READ, 1'b0); 
//       TapAccess(CLTAP, 'h02, READ, 1'b0); 
//       TapAccess(CLTAP, 'h34, WRITE, 1'b0); 
//       TapAccess(CLTAP, 'hA0, WRITE, 1'b0); 
//       TapAccess(CLTAP, 'h0C, WRITE, 1'b0); 
//
//       TapAccess(STAP0, TAP_BYPASS1, READ, 1'b0); 
//       TapAccess(STAP0, 'h0C, WRITE, 1'b0);
//       TapAccess(STAP0, 'h0C, READ, 1'b0);
//       TapAccess(STAP0, TAP_BYPASS1, READ, 1'b0);
//       TapAccess(STAP0, 'hA0, WRITE, 1'b0); 
//       TapAccess(STAP0, 'h34, WRITE, 1'b0); 
//
//       TapAccess(STAP1, TAP_BYPASS1, READ, 1'b0); 
//       TapAccess(STAP1, 'hA0, WRITE, 1'b0); 
//       TapAccess(STAP1, 'h0C, WRITE, 1'b0);
//       TapAccess(STAP1, 'h0C, READ, 1'b0);
//       TapAccess(STAP1, 'h34, WRITE, 1'b0); 
//
//       TapAccess(STAP2, TAP_BYPASS1, READ, 1'b0); 
//       TapAccess(STAP2, 'hFF, READ, 1'b0); 
//       TapAccess(STAP2, 'h0C, READ, 1'b0); 
//       TapAccess(STAP2, 'h34, READ, 1'b0); 
//
//       TapAccess(STAP3, TAP_BYPASS1, READ, 1'b0); 
//       TapAccess(STAP3, 'h0C, READ, 1'b0); 
//       TapAccess(STAP3, 'hA0, READ, 1'b0); 
//
//       Reset(2'b11);
//       TapAccess(STAP2, 'h34, WRITE, 1'b0); 
//       TapAccess(STAP3, 'hA0, WRITE, 1'b0); 
//
//       // Passing Accesses - Random.
//       */
//
//       
//       // Being debugged
//       //TapAccess(CLTAP, 'h02, READ, 1'b1); 
//       // TapAccess(CLTAP, TAP_BYPASS1, READ, 1'b1); 
//       // TapAccess(STAP0, 'h34, WRITE, 1'b1);
//       
//       /*
//       //TapAccess(CLTAP, 'hA0, WRITE, 1'b0); 
//       Reset(2'b11); // Since the access is to same Reg and Tap, need a Reset to clear the previously written data
//       //TapAccess(CLTAP, 'hA0, WRITE, 1'b1); 
//       */

    endtask : body
endclass : Tap3levelHierSequenceTry

class Tap4levelHierSequenceTry extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap4levelHierSequenceTry");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `ovm_sequence_utils(Tap4levelHierSequenceTry, JtagBfmSequencer)
 
    virtual task body();
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       BuildTapDataBase();
       Reset(2'b11);
//       TapAccess(CLTAP, 'h02, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP0, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP1, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP2, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP3, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP4, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP5, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP6, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP7, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP0, 'h34, WRITE, 32'h55667788, DONT_ENABLE_ALL_TAP);
//       TapAccess(CLTAP, 'h02, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP0, 'h34, READ, DONT_CARE, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hA0, WRITE, 32'hFFEEDDCC, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hA0, READ, DONT_CARE, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hA0, WRITE, 32'hAABBDDCC, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hA0, READ, DONT_CARE, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hAA, WRITE, 200'hAAAA_BBBB_5555_FFFF_DDDD_FFFF_0000_1111_EEEE_ABCD, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hAA, READ, DONT_CARE, DONT_ENABLE_ALL_TAP);

//       TapAccessCltapcIdcode(CLTAP);
//       TapAccessSlaveIdcode(STAP1);
//       TapAccessSlaveIdcode(STAP3);
//       TapAccessSlaveIdcode(STAP5);
//       TapAccessSlaveIdcode(STAP7);
//       TapAccessSlaveIdcode(STAP8);
//       TapAccessSlaveIdcode(STAP9);
//       TapAccessCltapcIdcode(CLTAP);
//       TapAccessSlaveIdcode(STAP1);
//       TapAccessSlaveIdcode(STAP3);
//       TapAccessSlaveIdcode(STAP5);
//       TapAccessSlaveIdcode(STAP7);

       TapAccessCltapcIdcode(CLTAP);
       TapAccessSlaveIdcode(STAP0);
       TapAccessSlaveIdcode(STAP1);
       TapAccessSlaveIdcode(STAP2);
       TapAccessSlaveIdcode(STAP3);
       TapAccessSlaveIdcode(STAP4);
       TapAccessSlaveIdcode(STAP5);
       TapAccessSlaveIdcode(STAP6);
       TapAccessSlaveIdcode(STAP7);
       TapAccessSlaveIdcode(STAP8);
       TapAccessSlaveIdcode(STAP9);
/*       

//       TapAccess(STAP0, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP1, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP2, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP3, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP4, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP5, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP6, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 
//       TapAccess(STAP7, 'h0C, READ, DONT_CARE, DONT_ENABLE_ALL_TAP); 

       TapAccessCltapcIdcode(CLTAP);
       TapAccessSlaveIdcode(STAP0);
       TapAccessSlaveIdcode(STAP1);
       TapAccessSlaveIdcode(STAP2);
       TapAccessSlaveIdcode(STAP3);
       TapAccessSlaveIdcode(STAP4);
       TapAccessSlaveIdcode(STAP5);
       TapAccessSlaveIdcode(STAP6);
       TapAccessSlaveIdcode(STAP7);
       TapAccessCltapcIdcode(CLTAP);
*/

//       TapAccess(STAP7, 'hA4, 32'h10000000, 0, 0, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hA4, DONT_CARE, 0, 0, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hA4, 32'h11000000, 0, 0, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hA4, DONT_CARE, 0, 0, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hA5, 200'h1000_1100_1110_1111_3000_3300_3330_3333_4000_4400, 0, 0, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hA5, DONT_CARE, 0, 0, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hA5, 200'hA000_AA00_AAA0_AAAA_C000_CC00_CCC0_CCCC_F000_FF00, 0, 0, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP7, 'hA5, DONT_CARE, 200'hA000_AA00_AAA0_AAAA_C000_CC00_CCC0_CCCC_F000_FF00, '1, DONT_ENABLE_ALL_TAP);
//
//
//
//       TapAccess(STAP8, 'hA1, 32'hEEEE_EEEE, 0, 0, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP8, 'hA1, DONT_CARE, 32'hEEEE_EEEE, '1, DONT_ENABLE_ALL_TAP);
//
//       TapAccess(STAP9, 'hA1, 32'hDDDD_DDDD, 0, 0, DONT_ENABLE_ALL_TAP);
//       TapAccess(STAP9, 'hA1, DONT_CARE, 32'hDDDD_DDDD, '1, DONT_ENABLE_ALL_TAP);


    endtask : body
endclass : Tap4levelHierSequenceTry


class Tap5levelHierSequenceTry #(parameter EN_REGISTER_PRESENCE_CHECK = 1) extends JtagBfmSoCTapNwSequences;

//    Tap_t Tap_string_array [int];
//    Tap_t Tap_enum;
//    string TapName;


   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTry");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTry, JtagBfmSequencer)

//   function void TapEnumMap();
//      Tap_enum = Tap_enum.first();
//      TapName  = Tap_enum.name();
//      Tap_string_array[0] = Tap_enum;
//
//      for (int i = 1; i < Tap_enum.num(); i++) begin 
//         Tap_enum = Tap_enum.next();
//         TapName  = Tap_enum.name(); 
//         Tap_string_array[i] = Tap_enum;
//      end
//
////      for (int i = 1; i < (Tap_enum.num()-1) ; i++) begin 
////         $display("Tap_string_array = %s", Tap_string_array[i]);
////      end
//   endfunction : TapEnumMap

    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.
       TapEnumMap();
       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       BuildTapDataBase();
       Reset(2'b11);
//       TapAccess(IDVP_sTAP, 8'hFF, 6'b11_0101, 6, 6'b10_1010, 6'hFF,1 ,6,0);
       TapAccess(STAP1, 8'hFF, 6'h35, 6, 6'h14, 6'h3F,1 ,0, ReturnTdo);

//      for (int i = 1; i < (Tap_enum.num()-1) ; i++) begin 
//         $display("Tap_string_array2 = %s", Tap_string_array[i]);
//         TapAccessSlaveIdcode(Tap_string_array[i]);
//      end

//       PutTapOnSecondary(STAP18);
//       MultipleTapRegisterAccess(2'b00,24'hFF_FF_11,6'b1_1_0101,24,6);
//             MyMultipleTapRegisterAccess(
//                NO_RST,
//                40'hA0,
//                36'hF0FF11,
//                40,
//                36);

//       input Tap_t                        Tap = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] Opcode = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
//       input int                          ShiftLength = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
//       input bit                          EnUserDefinedShiftLength = 0,
//       input bit                          EnRegisterPresenceCheck = 1);ReturnTdo

       TapAccess(CLTAP,   'h02, DONT_CARE, 0, 32'hC0DE_FF01, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP0,   'h0C, DONT_CARE, 0, 32'hC0DE_0001, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP1,   'h0C, DONT_CARE, 0, 32'hC0DE_0101, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2,   'h0C, DONT_CARE, 0, 32'hC0DE_0201, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP3,   'h0C, DONT_CARE, 0, 32'hC0DE_0301, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP4,   'h0C, DONT_CARE, 0, 32'hC0DE_0401, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP5,   'h0C, DONT_CARE, 0, 32'hC0DE_0501, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP6,   'h0C, DONT_CARE, 0, 32'hC0DE_0601, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP7,   'h0C, DONT_CARE, 0, 32'hC0DE_0701, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP8,   'h0C, DONT_CARE, 0, 32'hC0DE_0801, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP9,   'h0C, DONT_CARE, 0, 32'hC0DE_0901, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP10,  'h0C, DONT_CARE, 0, 32'hC0DE_1001, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP11,  'h0C, DONT_CARE, 0, 32'hC0DE_1101, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP12,  'h0C, DONT_CARE, 0, 32'hC0DE_1201, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP13,  'h0C, DONT_CARE, 0, 32'hC0DE_1301, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP14,  'h0C, DONT_CARE, 0, 32'hC0DE_1401, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP15,  'h0C, DONT_CARE, 0, 32'hC0DE_1501, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP16,  'h0C, DONT_CARE, 0, 32'hC0DE_1601, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP17,  'h0C, DONT_CARE, 0, 32'hC0DE_1701, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP18,  'h0C, DONT_CARE, 0, 32'hC0DE_1801, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP19,  'h0C, DONT_CARE, 0, 32'hC0DE_1901, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP20,  'h0C, DONT_CARE, 0, 32'hC0DE_2001, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP21,  'h0C, DONT_CARE, 0, 32'hC0DE_2101, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP22,  'h0C, DONT_CARE, 0, 32'hC0DE_2201, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP23,  'h0C, DONT_CARE, 0, 32'hC0DE_2301, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP24,  'h0C, DONT_CARE, 0, 32'hC0DE_2401, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP25,  'h0C, DONT_CARE, 0, 32'hC0DE_2501, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP26,  'h0C, DONT_CARE, 0, 32'hC0DE_2601, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP27,  'h0C, DONT_CARE, 0, 32'hC0DE_2701, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP28,  'h0C, DONT_CARE, 0, 32'hC0DE_2801, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP29,  'h0C, DONT_CARE, 0, 32'hC0DE_2901, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

       TapAccessCltapcIdcode(CLTAP);
       TapAccessSlaveIdcode(STAP0);
       TapAccessSlaveIdcode(STAP1);
       TapAccessSlaveIdcode(STAP2);
       TapAccessSlaveIdcode(STAP3);
       TapAccessSlaveIdcode(STAP4);
       TapAccessSlaveIdcode(STAP5);
       TapAccessSlaveIdcode(STAP6);
       TapAccessSlaveIdcode(STAP7);
       TapAccessSlaveIdcode(STAP8);
       TapAccessSlaveIdcode(STAP9);
       TapAccessSlaveIdcode(STAP10);
       TapAccessSlaveIdcode(STAP11);
       TapAccessSlaveIdcode(STAP12);
       TapAccessSlaveIdcode(STAP13);
       TapAccessSlaveIdcode(STAP14);
       TapAccessSlaveIdcode(STAP15);
       TapAccessSlaveIdcode(STAP16);
       TapAccessSlaveIdcode(STAP17);
       TapAccessSlaveIdcode(STAP18);
       TapAccessSlaveIdcode(STAP19);
       TapAccessSlaveIdcode(STAP20);
       TapAccessSlaveIdcode(STAP21);
       TapAccessSlaveIdcode(STAP22);
       TapAccessSlaveIdcode(STAP23);
       TapAccessSlaveIdcode(STAP24);
       TapAccessSlaveIdcode(STAP25);
       TapAccessSlaveIdcode(STAP26);
       TapAccessSlaveIdcode(STAP27);
       TapAccessSlaveIdcode(STAP28);
       TapAccessSlaveIdcode(STAP29);

       TapAccessCltapcIdcode(CLTAP);
       TapAccessSlaveIdcode(STAP0);
       TapAccessSlaveIdcode(STAP1);
       TapAccessSlaveIdcode(STAP2);
       TapAccessSlaveIdcode(STAP3);
       TapAccessSlaveIdcode(STAP4);
       TapAccessSlaveIdcode(STAP5);
       TapAccessSlaveIdcode(STAP6);
       TapAccessSlaveIdcode(STAP7);
       TapAccessSlaveIdcode(STAP8);
       TapAccessSlaveIdcode(STAP9);
       TapAccessSlaveIdcode(STAP10);
       TapAccessSlaveIdcode(STAP11);
       TapAccessSlaveIdcode(STAP12);
       TapAccessSlaveIdcode(STAP13);
       TapAccessSlaveIdcode(STAP14);
       TapAccessSlaveIdcode(STAP15);
       TapAccessSlaveIdcode(STAP16);
       TapAccessSlaveIdcode(STAP17);
       TapAccessSlaveIdcode(STAP18);
       TapAccessSlaveIdcode(STAP19);
       TapAccessSlaveIdcode(STAP20);
       TapAccessSlaveIdcode(STAP21);
       TapAccessSlaveIdcode(STAP22);
       TapAccessSlaveIdcode(STAP23);
       TapAccessSlaveIdcode(STAP24);
       TapAccessSlaveIdcode(STAP25);
       TapAccessSlaveIdcode(STAP26);
       TapAccessSlaveIdcode(STAP27);
       TapAccessSlaveIdcode(STAP28);
       TapAccessSlaveIdcode(STAP29);

//       input Tap_t                        Tap = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] Opcode = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
//       input int                          ShiftLength = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
//       input bit                          EnUserDefinedShiftLength = 0,
//       input bit                          EnRegisterPresenceCheck = 1);

       TapAccess(STAP29,  'h79, 39'h59,  39, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP28,  'h78, 38'h58,  38, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP27,  'h77, 37'h57,  37, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP26,  'h76, 36'h56,  36, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP25,  'h75, 35'h55,  35, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP24,  'h74, 34'h54,  34, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP23,  'h73, 33'h53,  33, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP22,  'h72, 32'h52,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP21,  'h71, 31'h51,  31, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP20,  'h70, 30'h50,  30, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP19,  'h69, 29'h49,  29, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP18,  'h68, 28'h48,  28, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP17,  'h67, 27'h47,  27, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP16,  'h66, 26'h46,  26, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP15,  'h65, 25'h45,  25, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP14,  'h64, 24'h44,  24, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP13,  'h63, 23'h43,  23, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP12,  'h62, 22'h42,  22, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP11,  'h61, 21'h41,  21, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP10,  'h60, 20'h40,  20, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP9,   'h59, 19'h39,  19, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP8,   'h58, 18'h38,  18, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP7,   'h57, 17'h37,  17, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP6,   'h56, 16'h36,  16, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP5,   'h55, 15'h35,  15, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP4,   'h54, 14'h34,  14, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP3,   'h53, 13'h33,  13, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2,   'h52, 12'h32,  12, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP1,   'h51, 11'h31,  11, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP0,   'h50, 10'h30,  10, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(CLTAP,   'h34, 32'h29,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

//       input Tap_t                        Tap = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] Opcode = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
//       input int                          ShiftLength = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
//       input bit                          EnUserDefinedShiftLength = 0,
//       input bit                          EnRegisterPresenceCheck = 1);

       TapAccess(STAP29,  'h79, DONT_CARE, 39, 39'h59,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP28,  'h78, DONT_CARE, 38, 38'h58,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP27,  'h77, DONT_CARE, 37, 37'h57,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP26,  'h76, DONT_CARE, 36, 36'h56,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP25,  'h75, DONT_CARE, 35, 35'h55,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP24,  'h74, DONT_CARE, 34, 34'h54,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP23,  'h73, DONT_CARE, 33, 33'h53,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP22,  'h72, DONT_CARE, 32, 32'h52,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP21,  'h71, DONT_CARE, 31, 31'h51,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP20,  'h70, DONT_CARE, 30, 30'h50,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP19,  'h69, DONT_CARE, 29, 29'h49,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP18,  'h68, DONT_CARE, 28, 28'h48,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP17,  'h67, DONT_CARE, 27, 27'h47,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP16,  'h66, DONT_CARE, 26, 26'h46,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP15,  'h65, DONT_CARE, 25, 25'h45,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP14,  'h64, DONT_CARE, 24, 24'h44,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP13,  'h63, DONT_CARE, 23, 23'h43,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP12,  'h62, DONT_CARE, 22, 22'h42,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP11,  'h61, DONT_CARE, 21, 21'h41,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP10,  'h60, DONT_CARE, 20, 20'h40,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP9,   'h59, DONT_CARE, 19, 19'h39,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP8,   'h58, DONT_CARE, 18, 18'h38,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP7,   'h57, DONT_CARE, 17, 17'h37,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP6,   'h56, DONT_CARE, 16, 16'h36,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP5,   'h55, DONT_CARE, 15, 15'h35,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP4,   'h54, DONT_CARE, 14, 14'h34,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP3,   'h53, DONT_CARE, 13, 13'h33,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2,   'h52, DONT_CARE, 12, 12'h32,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP1,   'h51, DONT_CARE, 11, 11'h31,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP0,   'h50, DONT_CARE, 10, 10'h30,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(CLTAP,   'h34, DONT_CARE, 32, 32'h29,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

       TapAccessSlaveIdcode(STAP29);
       TapAccessSlaveIdcode(STAP28);
       TapAccessSlaveIdcode(STAP27);
       TapAccessSlaveIdcode(STAP26);
       TapAccessSlaveIdcode(STAP25);
       TapAccessSlaveIdcode(STAP24);
       TapAccessSlaveIdcode(STAP23);
       TapAccessSlaveIdcode(STAP22);
       TapAccessSlaveIdcode(STAP21);
       TapAccessSlaveIdcode(STAP20);
       TapAccessSlaveIdcode(STAP19);
       TapAccessSlaveIdcode(STAP18);
       TapAccessSlaveIdcode(STAP17);
       TapAccessSlaveIdcode(STAP16);
       TapAccessSlaveIdcode(STAP15);
       TapAccessSlaveIdcode(STAP14);
       TapAccessSlaveIdcode(STAP13);
       TapAccessSlaveIdcode(STAP12);
       TapAccessSlaveIdcode(STAP11);
       TapAccessSlaveIdcode(STAP10);
       TapAccessSlaveIdcode(STAP9);
       TapAccessSlaveIdcode(STAP8);
       TapAccessSlaveIdcode(STAP7);
       TapAccessSlaveIdcode(STAP6);
       TapAccessSlaveIdcode(STAP5);
       TapAccessSlaveIdcode(STAP4);
       TapAccessSlaveIdcode(STAP3);
       TapAccessSlaveIdcode(STAP2);
       TapAccessSlaveIdcode(STAP1);
       TapAccessSlaveIdcode(STAP0);
       TapAccessCltapcIdcode(CLTAP);

//       input Tap_t                        Tap = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] Opcode = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
//       input int                          ShiftLength = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
//       input bit                          EnUserDefinedShiftLength = 0,
//       input bit                          EnRegisterPresenceCheck = 1);

       TapAccess(CLTAP,   'h34, 32'h29,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP0,   'h50, 10'h0,   10, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP1,   'h51, 11'h1,   11, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2,   'h52, 12'h2,   12, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP3,   'h53, 13'h3,   13, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP4,   'h54, 14'h4,   14, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP5,   'h55, 15'h5,   15, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP6,   'h56, 16'h6,   16, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP7,   'h57, 17'h7,   17, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP8,   'h58, 18'h8,   18, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP9,   'h59, 19'h9,   19, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP10,  'h60, 20'h10,  20, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP11,  'h61, 21'h11,  21, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP12,  'h62, 22'h12,  22, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP13,  'h63, 23'h13,  23, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP14,  'h64, 24'h14,  24, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP15,  'h65, 25'h15,  25, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP16,  'h66, 26'h16,  26, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP17,  'h67, 27'h17,  27, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP18,  'h68, 28'h18,  28, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP19,  'h69, 29'h19,  29, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP20,  'h70, 30'h20,  30, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP21,  'h71, 31'h21,  31, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP22,  'h72, 32'h22,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP23,  'h73, 33'h23,  33, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP24,  'h74, 34'h24,  34, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP25,  'h75, 35'h25,  35, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP26,  'h76, 36'h26,  36, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP27,  'h77, 37'h27,  37, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP28,  'h78, 38'h28,  38, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP29,  'h79, 39'h29,  39, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

       TapAccessSlaveIdcode(STAP29);
       TapAccessSlaveIdcode(STAP28);
       TapAccessSlaveIdcode(STAP27);
       TapAccessSlaveIdcode(STAP26);
       TapAccessSlaveIdcode(STAP25);
       TapAccessSlaveIdcode(STAP24);
       TapAccessSlaveIdcode(STAP23);
       TapAccessSlaveIdcode(STAP22);
       TapAccessSlaveIdcode(STAP21);
       TapAccessSlaveIdcode(STAP20);
       TapAccessSlaveIdcode(STAP19);
       TapAccessSlaveIdcode(STAP18);
       TapAccessSlaveIdcode(STAP17);
       TapAccessSlaveIdcode(STAP16);
       TapAccessSlaveIdcode(STAP15);
       TapAccessSlaveIdcode(STAP14);
       TapAccessSlaveIdcode(STAP13);
       TapAccessSlaveIdcode(STAP12);
       TapAccessSlaveIdcode(STAP11);
       TapAccessSlaveIdcode(STAP10);
       TapAccessSlaveIdcode(STAP9);
       TapAccessSlaveIdcode(STAP8);
       TapAccessSlaveIdcode(STAP7);
       TapAccessSlaveIdcode(STAP6);
       TapAccessSlaveIdcode(STAP5);
       TapAccessSlaveIdcode(STAP4);
       TapAccessSlaveIdcode(STAP3);
       TapAccessSlaveIdcode(STAP2);
       TapAccessSlaveIdcode(STAP1);
       TapAccessSlaveIdcode(STAP0);
       TapAccessCltapcIdcode(CLTAP);

//       input Tap_t                        Tap = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] Opcode = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
//       input int                          ShiftLength = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
//       input bit                          EnUserDefinedShiftLength = 0,
//       input bit                          EnRegisterPresenceCheck = 1);


       TapAccess(CLTAP,   'h34, DONT_CARE, 32, 32'h29,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP0,   'h50, DONT_CARE, 10, 10'h0,   '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP1,   'h51, DONT_CARE, 11, 11'h1,   '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2,   'h52, DONT_CARE, 12, 12'h2,   '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP3,   'h53, DONT_CARE, 13, 13'h3,   '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP4,   'h54, DONT_CARE, 14, 14'h4,   '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP5,   'h55, DONT_CARE, 15, 15'h5,   '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP6,   'h56, DONT_CARE, 16, 16'h6,   '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP7,   'h57, DONT_CARE, 17, 17'h7,   '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP8,   'h58, DONT_CARE, 18, 18'h8,   '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP9,   'h59, DONT_CARE, 19, 19'h9,   '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP10,  'h60, DONT_CARE, 20, 20'h10,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP11,  'h61, DONT_CARE, 21, 21'h11,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP12,  'h62, DONT_CARE, 22, 22'h12,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP13,  'h63, DONT_CARE, 23, 23'h13,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP14,  'h64, DONT_CARE, 24, 24'h14,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP15,  'h65, DONT_CARE, 25, 25'h15,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP16,  'h66, DONT_CARE, 26, 26'h16,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP17,  'h67, DONT_CARE, 27, 27'h17,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP18,  'h68, DONT_CARE, 28, 28'h18,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP19,  'h69, DONT_CARE, 29, 29'h19,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP20,  'h70, DONT_CARE, 30, 30'h20,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP21,  'h71, DONT_CARE, 31, 31'h21,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP22,  'h72, DONT_CARE, 32, 32'h22,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP23,  'h73, DONT_CARE, 33, 33'h23,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP24,  'h74, DONT_CARE, 34, 34'h24,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP25,  'h75, DONT_CARE, 35, 35'h25,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP26,  'h76, DONT_CARE, 36, 36'h26,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP27,  'h77, DONT_CARE, 37, 37'h27,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP28,  'h78, DONT_CARE, 38, 38'h28,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP29,  'h79, DONT_CARE, 39, 39'h29,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

       TapAccess(CLTAP,  'hBB, 10'h377,  10, 0,  0, 0, 1, ReturnTdo);
       TapAccess(STAP0,  'hBB, 10'h377,  10, 0,  0, 0, 1, ReturnTdo);
       TapAccess(STAP15, 'hBB, 10'h377,  10, 0, '1, 0, 1, ReturnTdo);
       TapAccess(STAP0,  'hBB, 10'h377,  10, 0, '1, 0, 1, ReturnTdo);
       TapAccess(STAP0,  'hBB, 10'h377,  10, 0, '1, 0, 1, ReturnTdo);
       TapAccess(STAP9,  'h79, 10'h377,  10, 0, '1, 0, 1, ReturnTdo);
       TapAccess(STAP9,  'h99, 10'h377,  10, 0, '1, 0, 1, ReturnTdo);
       TapAccess(STAP11, 'h99, 16'hFFFF, 16, 0, '1, 0, 1, ReturnTdo);

//       input Tap_t                        Tap = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] Opcode = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
//       input int                          ShiftLength = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
//       input bit                          EnUserDefinedShiftLength = 0,
//       input bit                          EnRegisterPresenceCheck = 1);

       //Bypass testing
       TapAccess(CLTAP,   'hC0, 20'h1359, 20, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP0,   'hC0, 20'h1359, 20, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP1,   'hC1, 21'h1359, 21, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP2,   'hC2, 22'h1359, 22, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP3,   'hC3, 23'h1359, 23, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP4,   'hC4, 24'h1359, 24, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP5,   'hC5, 25'h1359, 25, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP6,   'hC6, 26'h1359, 26, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP7,   'hC7, 27'h1359, 27, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP8,   'hC8, 28'h1359, 28, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP9,   'hC9, 29'h1359, 29, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP10,  'hD0, 30'h1359, 30, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP11,  'hD1, 31'h1359, 31, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP12,  'hD2, 32'h1359, 32, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP13,  'hD3, 33'h1359, 33, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP14,  'hD4, 34'h1359, 34, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP15,  'hD5, 35'h1359, 35, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP16,  'hD6, 36'h1359, 36, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP17,  'hD7, 37'h1359, 37, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP18,  'hD8, 38'h1359, 38, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP19,  'hD9, 39'h1359, 39, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP20,  'hE0, 40'h1359, 40, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP21,  'hE1, 41'h1359, 41, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP22,  'hE2, 42'h1359, 42, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP23,  'hE3, 43'h1359, 43, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP24,  'hE4, 44'h1359, 44, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP25,  'hE5, 45'h1359, 45, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP26,  'hE6, 46'h1359, 46, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP27,  'hE7, 47'h1359, 47, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP28,  'hE8, 48'h1359, 48, 0,  '1, 0, 1, ReturnTdo);
       TapAccess(STAP29,  'hE9, 49'h1359, 49, 0,  '1, 0, 1, ReturnTdo);

       TapAccess(STAP29,  'hA0, 32'h59,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP28,  'hA0, 32'h58,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP27,  'hA0, 32'h57,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP26,  'hA0, 32'h56,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP25,  'hA0, 32'h55,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP24,  'hA0, 32'h54,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP23,  'hA0, 32'h53,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP22,  'hA0, 32'h52,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP21,  'hA0, 32'h51,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP20,  'hA0, 32'h50,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP19,  'hA0, 32'h49,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP18,  'hA0, 32'h48,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP17,  'hA0, 32'h47,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP16,  'hA0, 32'h46,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP15,  'hA0, 32'h45,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP14,  'hA0, 32'h44,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP13,  'hA0, 32'h43,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP12,  'hA0, 32'h42,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP11,  'hA0, 32'h41,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP10,  'hA0, 32'h40,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP9,   'hA0, 32'h39,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP8,   'hA0, 32'h38,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP7,   'hA0, 32'h37,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP6,   'hA0, 32'h36,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP5,   'hA0, 32'h35,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP4,   'hA0, 32'h34,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP3,   'hA0, 32'h33,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2,   'hA0, 32'h32,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP1,   'hA0, 32'h31,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP0,   'hA0, 32'h30,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(CLTAP,   'hA0, 32'h50,  32, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

//       input Tap_t                        Tap = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] Opcode = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
//       input int                          ShiftLength = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
//       input bit                          EnUserDefinedShiftLength = 0,
//       input bit                          EnRegisterPresenceCheck = 1);


       TapAccess(CLTAP,   'hA0, DONT_CARE, 32, 32'h50,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP0,   'hA0, DONT_CARE, 32, 32'h30,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP1,   'hA0, DONT_CARE, 32, 32'h31,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2,   'hA0, DONT_CARE, 32, 32'h32,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP3,   'hA0, DONT_CARE, 32, 32'h33,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP4,   'hA0, DONT_CARE, 32, 32'h34,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP5,   'hA0, DONT_CARE, 32, 32'h35,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP6,   'hA0, DONT_CARE, 32, 32'h36,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP7,   'hA0, DONT_CARE, 32, 32'h37,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP8,   'hA0, DONT_CARE, 32, 32'h38,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP9,   'hA0, DONT_CARE, 32, 32'h39,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP10,  'hA0, DONT_CARE, 32, 32'h40,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP11,  'hA0, DONT_CARE, 32, 32'h41,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP12,  'hA0, DONT_CARE, 32, 32'h42,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP13,  'hA0, DONT_CARE, 32, 32'h43,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP14,  'hA0, DONT_CARE, 32, 32'h44,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP15,  'hA0, DONT_CARE, 32, 32'h45,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP16,  'hA0, DONT_CARE, 32, 32'h46,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP17,  'hA0, DONT_CARE, 32, 32'h47,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP18,  'hA0, DONT_CARE, 32, 32'h48,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP19,  'hA0, DONT_CARE, 32, 32'h49,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP20,  'hA0, DONT_CARE, 32, 32'h50,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP21,  'hA0, DONT_CARE, 32, 32'h51,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP22,  'hA0, DONT_CARE, 32, 32'h52,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP23,  'hA0, DONT_CARE, 32, 32'h53,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP24,  'hA0, DONT_CARE, 32, 32'h54,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP25,  'hA0, DONT_CARE, 32, 32'h55,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP26,  'hA0, DONT_CARE, 32, 32'h56,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP27,  'hA0, DONT_CARE, 32, 32'h57,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP28,  'hA0, DONT_CARE, 32, 32'h58,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP29,  'hA0, DONT_CARE, 32, 32'h59,  '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

//       TapAccess(CLTAP,    'h34, 32'h29,  0, 0, 0, 1, 32);
//       TapAccess(CLTAP,    'h34, DONT_CARE, 0, 32'h29,  '1, 1, 32);
//       TapAccess(STAP19,   'h69, 10'h30,  0, 0, 0, 1, 24);
//       TapAccess(STAP19,   'h69, DONT_CARE, 0, 10'h30,  '1, 1, 24);
//       TapAccess(STAP19,   'h69, 29'h49,  0, 0, 0, 1, 29, EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(STAP19,   'h69, DONT_CARE, 0, 29'h49,  '1, 1, 29, EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(STAP19,   'h69, 29'h49,  0, 0, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(STAP19,   'h69, DONT_CARE, 0, 29'h49,  '1, 0, 0, EN_REGISTER_PRESENCE_CHECK);
//
//       TapAccess(STAP0,   'h50, 10'h30, 10, 0, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(STAP0,   'h50, DONT_CARE, 10, 10'h30, '1, 0, 0, EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(STAP0,   'hB0, 10'h30, 0, 0, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(STAP0,   'hB0, DONT_CARE, 0, 10'h30, '1, 0, 0, EN_REGISTER_PRESENCE_CHECK);

//       input Tap_t                        Tap = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] Opcode = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
//       input int                          ShiftLength = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
//       input bit                          EnUserDefinedShiftLength = 0,
//       input bit                          EnRegisterPresenceCheck = 1);

       //Named mapping of arguments
       TapAccess(.Tap(STAP29), .Opcode('hA0), .ShiftIn(32'h59), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP28), .Opcode('hA0), .ShiftIn(32'h58), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP27), .Opcode('hA0), .ShiftIn(32'h57), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP26), .Opcode('hA0), .ShiftIn(32'h56), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP25), .Opcode('hA0), .ShiftIn(32'h55), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP24), .Opcode('hA0), .ShiftIn(32'h54), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP23), .Opcode('hA0), .ShiftIn(32'h53), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP22), .Opcode('hA0), .ShiftIn(32'h52), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP21), .Opcode('hA0), .ShiftIn(32'h51), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP20), .Opcode('hA0), .ShiftIn(32'h50), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP19), .Opcode('hA0), .ShiftIn(32'h49), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP18), .Opcode('hA0), .ShiftIn(32'h48), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP17), .Opcode('hA0), .ShiftIn(32'h47), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP16), .Opcode('hA0), .ShiftIn(32'h46), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP15), .Opcode('hA0), .ShiftIn(32'h45), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP14), .Opcode('hA0), .ShiftIn(32'h44), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP13), .Opcode('hA0), .ShiftIn(32'h43), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP12), .Opcode('hA0), .ShiftIn(32'h42), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP11), .Opcode('hA0), .ShiftIn(32'h41), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP10), .Opcode('hA0), .ShiftIn(32'h40), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP9),  .Opcode('hA0), .ShiftIn(32'h39), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP8),  .Opcode('hA0), .ShiftIn(32'h38), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP7),  .Opcode('hA0), .ShiftIn(32'h37), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP6),  .Opcode('hA0), .ShiftIn(32'h36), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP5),  .Opcode('hA0), .ShiftIn(32'h35), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP4),  .Opcode('hA0), .ShiftIn(32'h34), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP3),  .Opcode('hA0), .ShiftIn(32'h33), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP2),  .Opcode('hA0), .ShiftIn(32'h32), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP1),  .Opcode('hA0), .ShiftIn(32'h31), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP0),  .Opcode('hA0), .ShiftIn(32'h30), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(CLTAP),  .Opcode('hA0), .ShiftIn(32'h50), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));

       TapAccess(.Tap(CLTAP),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h50), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP0),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h30), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP1),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h31), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP2),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h32), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP3),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h33), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP4),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h34), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP5),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h35), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP6),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h36), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP7),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h37), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP8),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h38), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP9),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h39), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP10), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h40), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP11), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h41), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP12), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h42), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP13), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h43), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP14), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h44), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP15), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h45), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP16), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h46), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP17), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h47), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP18), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h48), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP19), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h49), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP20), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h50), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP21), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h51), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP22), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h52), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP23), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h53), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP24), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h54), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP25), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h55), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP26), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h56), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP27), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h57), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP28), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h58), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP29), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h59), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));


       //Positional mapping of arguments
       TapAccess(STAP29, 'hA0, 32'h59, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP28, 'hA0, 32'h58, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP27, 'hA0, 32'h57, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP26, 'hA0, 32'h56, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP25, 'hA0, 32'h55, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP24, 'hA0, 32'h54, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP23, 'hA0, 32'h53, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP22, 'hA0, 32'h52, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP21, 'hA0, 32'h51, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP20, 'hA0, 32'h50, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP19, 'hA0, 32'h49, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP18, 'hA0, 32'h48, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP17, 'hA0, 32'h47, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP16, 'hA0, 32'h46, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP15, 'hA0, 32'h45, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP14, 'hA0, 32'h44, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP13, 'hA0, 32'h43, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP12, 'hA0, 32'h42, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP11, 'hA0, 32'h41, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP10, 'hA0, 32'h40, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP9,  'hA0, 32'h39, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP8,  'hA0, 32'h38, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP7,  'hA0, 32'h37, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP6,  'hA0, 32'h36, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP5,  'hA0, 32'h35, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP4,  'hA0, 32'h34, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP3,  'hA0, 32'h33, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2,  'hA0, 32'h32, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP1,  'hA0, 32'h31, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP0,  'hA0, 32'h30, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(CLTAP,  'hA0, 32'h50, 32, , , , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

       TapAccess(CLTAP,  'hA0, , 32, 32'h50, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP0,  'hA0, , 32, 32'h30, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP1,  'hA0, , 32, 32'h31, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2,  'hA0, , 32, 32'h32, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP3,  'hA0, , 32, 32'h33, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP4,  'hA0, , 32, 32'h34, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP5,  'hA0, , 32, 32'h35, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP6,  'hA0, , 32, 32'h36, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP7,  'hA0, , 32, 32'h37, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP8,  'hA0, , 32, 32'h38, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP9,  'hA0, , 32, 32'h39, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP10, 'hA0, , 32, 32'h40, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP11, 'hA0, , 32, 32'h41, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP12, 'hA0, , 32, 32'h42, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP13, 'hA0, , 32, 32'h43, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP14, 'hA0, , 32, 32'h44, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP15, 'hA0, , 32, 32'h45, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP16, 'hA0, , 32, 32'h46, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP17, 'hA0, , 32, 32'h47, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP18, 'hA0, , 32, 32'h48, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP19, 'hA0, , 32, 32'h49, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP20, 'hA0, , 32, 32'h50, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP21, 'hA0, , 32, 32'h51, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP22, 'hA0, , 32, 32'h52, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP23, 'hA0, , 32, 32'h53, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP24, 'hA0, , 32, 32'h54, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP25, 'hA0, , 32, 32'h55, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP26, 'hA0, , 32, 32'h56, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP27, 'hA0, , 32, 32'h57, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP28, 'hA0, , 32, 32'h58, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP29, 'hA0, , 32, 32'h59, '1, , EN_REGISTER_PRESENCE_CHECK, ReturnTdo);


//       input Tap_t                        Tap = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] Opcode = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
//       input int                          ShiftLength = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
//       input bit                          EnUserDefinedShiftLength = 0,
//       input bit                          EnRegisterPresenceCheck = 1);

       //ShiftLength is required when EN_REGISTER_PRESENCE_CHECK = 0
       TapAccess(.Tap(STAP29), .Opcode('hA0), .ShiftIn(32'h59), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP28), .Opcode('hA0), .ShiftIn(32'h58), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP27), .Opcode('hA0), .ShiftIn(32'h57), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP26), .Opcode('hA0), .ShiftIn(32'h56), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP25), .Opcode('hA0), .ShiftIn(32'h55), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP24), .Opcode('hA0), .ShiftIn(32'h54), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP23), .Opcode('hA0), .ShiftIn(32'h53), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP22), .Opcode('hA0), .ShiftIn(32'h52), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP21), .Opcode('hA0), .ShiftIn(32'h51), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP20), .Opcode('hA0), .ShiftIn(32'h50), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP19), .Opcode('hA0), .ShiftIn(32'h49), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP18), .Opcode('hA0), .ShiftIn(32'h48), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP17), .Opcode('hA0), .ShiftIn(32'h47), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP16), .Opcode('hA0), .ShiftIn(32'h46), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP15), .Opcode('hA0), .ShiftIn(32'h45), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP14), .Opcode('hA0), .ShiftIn(32'h44), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP13), .Opcode('hA0), .ShiftIn(32'h43), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP12), .Opcode('hA0), .ShiftIn(32'h42), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP11), .Opcode('hA0), .ShiftIn(32'h41), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP10), .Opcode('hA0), .ShiftIn(32'h40), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP9),  .Opcode('hA0), .ShiftIn(32'h39), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP8),  .Opcode('hA0), .ShiftIn(32'h38), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP7),  .Opcode('hA0), .ShiftIn(32'h37), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP6),  .Opcode('hA0), .ShiftIn(32'h36), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP5),  .Opcode('hA0), .ShiftIn(32'h35), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP4),  .Opcode('hA0), .ShiftIn(32'h34), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP3),  .Opcode('hA0), .ShiftIn(32'h33), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP2),  .Opcode('hA0), .ShiftIn(32'h32), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP1),  .Opcode('hA0), .ShiftIn(32'h31), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP0),  .Opcode('hA0), .ShiftIn(32'h30), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(CLTAP),  .Opcode('hA0), .ShiftIn(32'h50), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));

       TapAccess(.Tap(CLTAP),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h50), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP0),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h30), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP1),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h31), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP2),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h32), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP3),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h33), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP4),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h34), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP5),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h35), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP6),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h36), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP7),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h37), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP8),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h38), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP9),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h39), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP10), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h40), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP11), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h41), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP12), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h42), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP13), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h43), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP14), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h44), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP15), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h45), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP16), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h46), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP17), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h47), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP18), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h48), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP19), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h49), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP20), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h50), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP21), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h51), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP22), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h52), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP23), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h53), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP24), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h54), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP25), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h55), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP26), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h56), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP27), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h57), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP28), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h58), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP29), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h59), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));


//       input Tap_t                        Tap = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] Opcode = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
//       input int                          ShiftLength = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
//       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
//       input bit                          EnUserDefinedShiftLength = 0,
//       input bit                          EnRegisterPresenceCheck = 1);
//
     //Testing for user defined lengths
       TapAccess(.Tap(STAP29), .Opcode('hA0), .ShiftIn(32'h59), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP28), .Opcode('hA0), .ShiftIn(32'h58), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP27), .Opcode('hA0), .ShiftIn(32'h57), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP26), .Opcode('hA0), .ShiftIn(32'h56), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP25), .Opcode('hA0), .ShiftIn(32'h55), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP24), .Opcode('hA0), .ShiftIn(32'h54), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP23), .Opcode('hA0), .ShiftIn(32'h53), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP22), .Opcode('hA0), .ShiftIn(32'h52), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP21), .Opcode('hA0), .ShiftIn(32'h51), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP20), .Opcode('hA0), .ShiftIn(32'h50), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP19), .Opcode('hA0), .ShiftIn(32'h49), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP18), .Opcode('hA0), .ShiftIn(32'h48), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP17), .Opcode('hA0), .ShiftIn(32'h47), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP16), .Opcode('hA0), .ShiftIn(32'h46), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP15), .Opcode('hA0), .ShiftIn(32'h45), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP14), .Opcode('hA0), .ShiftIn(32'h44), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP13), .Opcode('hA0), .ShiftIn(32'h43), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP12), .Opcode('hA0), .ShiftIn(32'h42), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP11), .Opcode('hA0), .ShiftIn(32'h41), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP10), .Opcode('hA0), .ShiftIn(32'h40), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP9),  .Opcode('hA0), .ShiftIn(32'h39), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP8),  .Opcode('hA0), .ShiftIn(32'h38), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP7),  .Opcode('hA0), .ShiftIn(32'h37), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP6),  .Opcode('hA0), .ShiftIn(32'h36), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP5),  .Opcode('hA0), .ShiftIn(32'h35), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP4),  .Opcode('hA0), .ShiftIn(32'h34), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP3),  .Opcode('hA0), .ShiftIn(32'h33), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP2),  .Opcode('hA0), .ShiftIn(32'h32), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP1),  .Opcode('hA0), .ShiftIn(32'h31), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP0),  .Opcode('hA0), .ShiftIn(32'h30), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(CLTAP),  .Opcode('hA0), .ShiftIn(32'h50), .ShiftLength(32), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));

       TapAccess(.Tap(CLTAP),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h50), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP0),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h30), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP1),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h31), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP2),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h32), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP3),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h33), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP4),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h34), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP5),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h35), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP6),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h36), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP7),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h37), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP8),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h38), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP9),  .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h39), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP10), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h40), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP11), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h41), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP12), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h42), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP13), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h43), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP14), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h44), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP15), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h45), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP16), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h46), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP17), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h47), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP18), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h48), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP19), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h49), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP20), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h50), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP21), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h51), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP22), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h52), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP23), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h53), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP24), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h54), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP25), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h55), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP26), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h56), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP27), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h57), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP28), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h58), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(STAP29), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h59), .CompareMask('1), .EnUserDefinedShiftLength(1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));



       TapAccessSlaveIdcode(STAP2);
       TapAccessRmw(STAP2, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
       TapAccessRmw(STAP2, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
       TapAccessRmw(STAP2, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
       TapAccess   (STAP2, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
       TapAccessSlaveIdcode(STAP2);


       SetMultiTapCapabilityOnly(CLTAP);
       SetMultiTapCapabilityOnly(STAP1);
       SetMultiTapCapabilityOnly(STAP2);


       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h0, 12'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

       MultiTapAccessLaunchPrimary();

       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h90, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h80, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h70, 12'hFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

       MultiTapAccessLaunchPrimary();

       MultiTapAccessLaunchPrimary();


       TapAccessSlaveIdcode(STAP29);
       TapAccessSlaveIdcode(STAP28);
       TapAccessSlaveIdcode(STAP27);
       TapAccessSlaveIdcode(STAP26);
       TapAccessSlaveIdcode(STAP25);
       TapAccessSlaveIdcode(STAP24);
       TapAccessSlaveIdcode(STAP23);
       TapAccessSlaveIdcode(STAP22);
       TapAccessSlaveIdcode(STAP21);
       TapAccessSlaveIdcode(STAP20);
       TapAccessSlaveIdcode(STAP19);
       TapAccessSlaveIdcode(STAP18);
       TapAccessSlaveIdcode(STAP17);
       TapAccessSlaveIdcode(STAP16);
       TapAccessSlaveIdcode(STAP15);
       TapAccessSlaveIdcode(STAP14);
       TapAccessSlaveIdcode(STAP13);
       TapAccessSlaveIdcode(STAP12);
       TapAccessSlaveIdcode(STAP11);
       TapAccessSlaveIdcode(STAP10);
       TapAccessSlaveIdcode(STAP9);
       TapAccessSlaveIdcode(STAP8);
       TapAccessSlaveIdcode(STAP7);
       TapAccessSlaveIdcode(STAP6);
       TapAccessSlaveIdcode(STAP5);
       TapAccessSlaveIdcode(STAP4);
       TapAccessSlaveIdcode(STAP3);
       TapAccessSlaveIdcode(STAP2);
       TapAccessSlaveIdcode(STAP1);
       TapAccessSlaveIdcode(STAP0);
       TapAccessCltapcIdcode(CLTAP);



       TapAccessSlaveIdcode(STAP2);
       TapAccessRmw(STAP2, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
       TapAccessRmw(STAP2, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
       TapAccessRmw(STAP2, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
       TapAccess   (STAP2, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
       TapAccessSlaveIdcode(STAP2);





    endtask : body
endclass : Tap5levelHierSequenceTry


class Tap5levelHierSequenceTryAlongWithSecondary #(parameter EN_REGISTER_PRESENCE_CHECK = 1) extends JtagBfmSoCTapNwSequences;

//    Tap_t Tap_string_array [int];
//    Tap_t Tap_enum;
//    string TapName;

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTryAlongWithSecondary");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTryAlongWithSecondary, JtagBfmSequencer)

//   function void TapEnumMap();
//      Tap_enum = Tap_enum.first();
//      TapName  = Tap_enum.name();
//      Tap_string_array[0] = Tap_enum;
//
//      for (int i = 1; i < Tap_enum.num(); i++) begin 
//         Tap_enum = Tap_enum.next();
//         TapName  = Tap_enum.name(); 
//         Tap_string_array[i] = Tap_enum;
//      end
//   endfunction : TapEnumMap

    virtual task body();
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.
       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(STAP22,  'h0C, DONT_CARE, 0, 32'hC0DE_2201, '1, 0, 0, EN_REGISTER_PRESENCE_CHECK);
       TapAccessSlaveIdcode(STAP20);
       TapAccessSlaveIdcode(STAP21);
//       TapAccessSlaveIdcode(STAP22);
       TapAccessSlaveIdcode(STAP23);
       TapAccessSlaveIdcode(STAP24);
       TapAccessSlaveIdcode(STAP25);
       TapAccessSlaveIdcode(STAP26);
    endtask : body
endclass : Tap5levelHierSequenceTryAlongWithSecondary



class Tap5levelHierSequenceTrySecConfig #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                          parameter Tap_t TAP = STAP0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTrySecConfig");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTrySecConfig, JtagBfmSequencer)
 
    virtual task body();
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       $display("1. TAP = %0s", TAP);
       BuildTapDataBase();
       Reset(2'b11);

       PutTapOnSecondary(TAP);
//       MyMultipleTapRegisterAccess(NO_RST, 40'hA0, 36'hF0FF11, 40, 36);

    endtask : body

endclass : Tap5levelHierSequenceTrySecConfig

class Tap5levelHierSequenceTrySecConfigNew #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                             parameter Tap_t TAP = STAP0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTrySecConfigNew");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTrySecConfigNew, JtagBfmSequencer)
 
    virtual task body();
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       $display("1. TAP = %0s", TAP);
       BuildTapDataBase();
       Reset(2'b11);
       PutTapOnSecondary(TAP);
       EnableTap(STAP29);
//       PutTapOnSecondary(30);
//       PutTapOnSecondary(2);
       TapAccessSlaveIdcode(STAP29);

    endtask : body

endclass : Tap5levelHierSequenceTrySecConfigNew


class Tap5levelHierSequenceTrySecondary #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                          parameter Tap_t TAP = STAP0) extends JtagBfmSoCTapNwSequences;

   Tap_t tap = TAP;
   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTrySecondary");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTrySecondary, JtagBfmSequencer)
 
    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       if (TAP > STAP9) begin
          tap = tap + 6;
       end 
       if (TAP > STAP19) begin 
          tap = tap + 6;
       end

       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       $display("2. TAP = %0s", TAP);
       $display("2. tap = %0d", tap);
       $display("2. 'h50+tap-1 = %0h", 'h50+tap-1);
       $display("2. 'h10+tap-1 = %0h", 'h10+tap-1);
       $display("2. 10+tap-1 = %0d", 10+tap-1);
//       BuildTapDataBase();
//       Reset(2'b11);

//       PutTapOnSecondary(STAP18);
//       MyMultipleTapRegisterAccess(NO_RST, 40'hA0, 36'hF0FF11, 40, 36);
//       TapAccess(STAP18,  'h68, 28'h48,  28, 0, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(.Tap(STAP14), .Opcode('hA0), .ShiftIn(32'hFFEE_C0DE), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK));
//       TapAccess(.Tap(STAP14), .Opcode('h64), .ShiftIn(24'hC0DE), .ShiftLength(24), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK));
//       TapAccess(.Tap(STAP14), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'hFFEE_C0DE), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK));
//       TapAccess(.Tap(STAP14), .Opcode('h64), .ShiftLength(24), .ExpectedData(24'hC0DE), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK));
       TapAccess(.Tap(TAP), .Opcode('h0C), .ShiftIn(32'h0), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('hA0), .ShiftIn(32'hFFEE_C0DE), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('h50+tap-1), .ShiftIn('h10+tap-1), .ShiftLength(10+TAP-1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'hFFEE_C0DE), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('h50+tap-1), .ShiftLength(10+TAP-1), .ExpectedData('h10+tap-1), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));

    endtask : body

endclass : Tap5levelHierSequenceTrySecondary



class Tap5levelHierSequenceTrySecondaryNew #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                          parameter Tap_t TAP = STAP0) extends JtagBfmSoCTapNwSequences;

   Tap_t tap = TAP;
   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTrySecondaryNew");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTrySecondaryNew, JtagBfmSequencer)
 
    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       if (TAP > STAP9) begin
          tap = tap + 6;
       end 
       if (TAP > STAP19) begin 
          tap = tap + 6;
       end

       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       $display("2. TAP = %0s", TAP);
       $display("2. tap = %0d", tap);
       $display("2. 'h50+tap-1 = %0h", 'h50+tap-1);
       $display("2. 'h10+tap-1 = %0h", 'h10+tap-1);
       $display("2. 10+tap-1 = %0d", 10+tap-1);
//       BuildTapDataBase();
//       Reset(2'b11);

//       PutTapOnSecondary(STAP18);
//       MyMultipleTapRegisterAccess(NO_RST, 40'hA0, 36'hF0FF11, 40, 36);
//       TapAccess(STAP18,  'h68, 28'h48,  28, 0, 0, 0, 0, EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(.Tap(STAP14), .Opcode('hA0), .ShiftIn(32'hFFEE_C0DE), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK));
//       TapAccess(.Tap(STAP14), .Opcode('h64), .ShiftIn(24'hC0DE), .ShiftLength(24), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK));
//       TapAccess(.Tap(STAP14), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'hFFEE_C0DE), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK));
//       TapAccess(.Tap(STAP14), .Opcode('h64), .ShiftLength(24), .ExpectedData(24'hC0DE), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK));
       TapAccess(.Tap(TAP), .Opcode('h0C), .ShiftIn(32'h0), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('hA0), .ShiftIn(32'hFFEE_C0DE), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('h50+tap-1), .ShiftIn('h10+tap-1), .ShiftLength(10+TAP-1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'hFFEE_C0DE), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('h50+tap-1), .ShiftLength(10+TAP-1), .ExpectedData('h10+tap-1), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));


      SetMultiTapCapabilityOnly(CLTAP);
      SetMultiTapCapabilityOnly(STAP1);
      SetMultiTapCapabilityOnly(STAP2);

      AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP1, 'h0C, 32'h0, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h0, 12'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      MultiTapAccessLaunchSecondary();
      AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h70, 12'hFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      MultiTapAccessLaunchSecondary();

      //=================================================
      TapAccessSlaveIdcode(STAP5);
      TapAccessRmw(STAP5, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
      TapAccessRmw(STAP5, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
      TapAccessRmw(STAP5, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
      TapAccess   (STAP5, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
      TapAccessSlaveIdcode(STAP5);
      //=================================================

    endtask : body

endclass : Tap5levelHierSequenceTrySecondaryNew




class Tap5levelHierSequenceTrySecondaryNew1 #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                          parameter Tap_t TAP = STAP0) extends JtagBfmSoCTapNwSequences;

   Tap_t tap = TAP;
   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTrySecondaryNew1");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTrySecondaryNew1, JtagBfmSequencer)
 
    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.
       TapAccessSlaveIdcode(tap);



    endtask : body

endclass : Tap5levelHierSequenceTrySecondaryNew1


class Tap5levelHierSequenceTrySecDisable #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                           parameter Tap_t TAP = STAP0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTrySecDisable");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTrySecDisable, JtagBfmSequencer)
 
    virtual task body();
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.
       DisableTap(TAP);
    endtask : body

endclass : Tap5levelHierSequenceTrySecDisable


class Tap5levelHierSequenceTrySecConfigHyb #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                             parameter Tap_t TAP = 1) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTrySecConfigHyb");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTrySecConfigHyb, JtagBfmSequencer)
 
    virtual task body();
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       $display("1. TAP = %0s", TAP);
       BuildTapDataBase();
       Reset(2'b11);

       PutTapOnSecondary(TAP);
//       MyMultipleTapRegisterAccess(NO_RST, 40'hA0, 36'hF0FF11, 40, 36);

    endtask : body

endclass : Tap5levelHierSequenceTrySecConfigHyb

class Tap5levelHierSequenceTrySecondaryHyb #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                             parameter Tap_t TAP = 1) extends JtagBfmSoCTapNwSequences;

   Tap_t tap = TAP;
   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTrySecondaryHyb");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTrySecondaryHyb, JtagBfmSequencer)
 
    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

//       if (TAP > STAP9) begin
//          tap = tap + 6;
//       end 
//       if (TAP > STAP19) begin 
//          tap = tap + 6;
//       end

       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       $display("2. TAP = %0s", TAP);
       $display("2. tap = %0d", tap);
       $display("2. 'h50+tap-1 = %0h", 'h50+tap-1);
       $display("2. 'h10+tap-1 = %0h", 'h10+tap-1);
       $display("2. 10+tap-1 = %0d", 10+tap-1);

       TapAccess(.Tap(TAP), .Opcode('h0C), .ShiftIn(32'h0), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('hA0), .ShiftIn(32'hFFEE_C0DE), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('h50+tap-1), .ShiftIn('h10+tap-1), .ShiftLength(10+TAP-1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'hFFEE_C0DE), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('h50+tap-1), .ShiftLength(10+TAP-1), .ExpectedData('h10+tap-1), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));

    endtask : body

endclass : Tap5levelHierSequenceTrySecondaryHyb

class Tap5levelHierSequenceTry_remove #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                        parameter Tap_t TAP = 0) extends JtagBfmSoCTapNwSequences;

//    Tap_t Tap_string_array [int];
//    Tap_t Tap_enum;
//    string TapName;
    int i;

   JtagBfmSeqDrvPkt Packet;
   function new(string name = "Tap5levelHierSequenceTry_remove");
      super.new(name);
      Packet = new;
   endfunction : new

   `ovm_sequence_utils(Tap5levelHierSequenceTry_remove, JtagBfmSequencer)

//   function void TapEnumMap();
//      Tap_enum = Tap_enum.first();
//      TapName  = Tap_enum.name();
//      Tap_string_array[0] = Tap_enum;
//
//      for (int i = 1; i < Tap_enum.num(); i++) begin 
//         Tap_enum = Tap_enum.next();
//         TapName  = Tap_enum.name(); 
//         Tap_string_array[i] = Tap_enum;
//      end
//
//      for (int i = 1; i < (Tap_enum.num()-1) ; i++) begin 
//         $display("Sequence Tap_string_array = %s", Tap_string_array[i]);
//         $display("Sequence Tap_string_array = %0d", Tap_string_array[i]);
//      end
//   endfunction : TapEnumMap

   task RemoveTapLocal();
   begin
      RemoveTap(i);
      $display ("RemoveTapLocal i = %0d",i);
   end
   endtask

    virtual task body();
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.
       TapEnumMap();
       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       BuildTapDataBase();
       Reset(2'b11);

       RemoveTapLocal();
    endtask : body
endclass : Tap5levelHierSequenceTry_remove

class Tap5levelHierSequenceTry_remove_detailed
   #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
     parameter Tap_t TAP = 0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
   function new(string name = "Tap5levelHierSequenceTry_remove_detailed");
      super.new(name);
      Packet = new;
   endfunction : new

   `ovm_sequence_utils(Tap5levelHierSequenceTry_remove_detailed, JtagBfmSequencer)

    virtual task body();
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.
       TapEnumMap();
       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       BuildTapDataBase();
       Reset(2'b11);
       EnableTap(STAP20);
       RemoveTap(CLTAP);
//       RemoveTap(STAP1);
//       RemoveTap(STAP2);
//       RemoveTap(STAP4);
//       RemoveTap(STAP8);
//       RemoveTap(STAP13);
//       RemoveTap(STAP14);
//       RemoveTap(STAP20);
//       RemoveTap(STAP24);
       MultipleTapRegisterAccess(NO_RST,8'h0C,0,8,32);

    endtask : body
endclass : Tap5levelHierSequenceTry_remove_detailed


class Tap5levelHierSequenceTry_ReadIdCodes
      #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
        parameter Tap_t TAP = 0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
   function new(string name = "Tap5levelHierSequenceTry_ReadIdCodes");
      super.new(name);
      Packet = new;
   endfunction : new

   `ovm_sequence_utils(Tap5levelHierSequenceTry_ReadIdCodes, JtagBfmSequencer)

   virtual task body();
      logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
      // TODO - Find a place where this object is created before the runtime.
      // JtagBfmMasterAgent - can add an start_of_simulation phase.
      TapEnumMap();
      $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
      BuildTapDataBase();
      Reset(2'b11);
      $display("ReadIdCodes1");
      ReadIdCodes();
      $display("ReadIdCodes2");
      ReadIdCodes();

      SetMultiTapCapabilityOnly(CLTAP);
      SetMultiTapCapabilityOnly(STAP1);
      SetMultiTapCapabilityOnly(STAP2);

      AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h0, 12'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      MultiTapAccessLaunchPrimary();

      AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h90, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h80, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h70, 12'hFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      MultiTapAccessLaunchPrimary();
      MultiTapAccessLaunchPrimary();

      $display("ReadIdCodes3");
      ReadIdCodes();

      //=================================================
      TapAccessSlaveIdcode(STAP10);
      TapAccessRmw(STAP10, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
      TapAccessRmw(STAP10, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
      TapAccessRmw(STAP10, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
      TapAccess   (STAP10, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
      TapAccessSlaveIdcode(STAP10);
      //=================================================

   endtask : body

endclass : Tap5levelHierSequenceTry_ReadIdCodes



class Tap5levelHierSequenceTryWithHistory
   #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
     parameter Tap_t TAP = 0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
   function new(string name = "Tap5levelHierSequenceTryWithHistory");
      super.new(name);
      Packet = new;
   endfunction : new

   `ovm_sequence_utils(Tap5levelHierSequenceTryWithHistory, JtagBfmSequencer)

    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       BuildTapDataBase();
       Reset(2'b11);

       TapAccessRmw(STAP2, 8'hA0, 32'hFFFF_00FF, 0, 0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
       TapAccessSlaveIdcode(STAP1);
       TapAccessRmw(STAP2, 8'hA0, 32'h0000_3300, 0, 0, 32'h0000_FF00, 0, 1, ReturnTdo);
       TapAccessSlaveIdcode(STAP1);
       TapAccessRmw(STAP2, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
       TapAccessRmw(STAP2, 8'hA0, 32'h0022_0000, 0,             0, 32'h00FF_0000, 0, 1, ReturnTdo);
       TapAccess   (STAP2, 8'hA0, 32'h0000_1234, 0, 32'h1122_33FF,            '1, 0, 1, ReturnTdo);

//       TapAccessNew(STAP0, 'hA0, , 32, 32'h30, 0, , , EN_REGISTER_PRESENCE_CHECK);

//       EnableTap (STAP20);
//       EnableTap (STAP27);
//       EnableTap (STAP0);
//       EnableTap (STAP28);
//       EnableTap (STAP1);
//       EnableTap (STAP29);
       
//       EnableTap (STAP27);
//       EnableTap (STAP27);
//       EnableTap (STAP27);
////       EnableTap (STAP3);
//       EnableTap (STAP27);
//       EnableTap (STAP27);
      EnableTap (STAP29);
      TapAccess(.Tap(STAP3), .Opcode('hA0), .ShiftIn(32'h33), .ShiftLength(32), .ReturnTdo(ReturnTdo));
      TapAccess(.Tap(STAP3), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h33), .CompareMask('1), .ReturnTdo(ReturnTdo));

      SetMultiTapCapabilityOnly(CLTAP);
      SetMultiTapCapabilityOnly(STAP1);
      SetMultiTapCapabilityOnly(STAP2);

      AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h0, 12'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      MultiTapAccessLaunchPrimary();

      AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h90, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h80, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h70, 12'hFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      MultiTapAccessLaunchPrimary();
      MultiTapAccessLaunchPrimary();

//       EnableTap (STAP19);
      //=================================================
      TapAccessSlaveIdcode(STAP10);
      TapAccessRmw(STAP10, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
      TapAccessRmw(STAP10, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
      TapAccessRmw(STAP10, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
      TapAccess   (STAP10, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
      TapAccessSlaveIdcode(STAP10);
      //=================================================
    endtask : body

endclass : Tap5levelHierSequenceTryWithHistory

class Tap5levelHierSequenceDisable
   #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
     parameter Tap_t TAP = 0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
   function new(string name = "Tap5levelHierSequenceDisable");
      super.new(name);
      Packet = new;
   endfunction : new

   `ovm_sequence_utils(Tap5levelHierSequenceDisable, JtagBfmSequencer)

    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       BuildTapDataBase();
       Reset(2'b11);
//       TapAccessNew(STAP0, 'hA0, , 32, 32'h30, 0, , , EN_REGISTER_PRESENCE_CHECK);

//       EnableTap (STAP20);
//       EnableTap (STAP27);
//       EnableTap (STAP0);
//       EnableTap (STAP28);
//       EnableTap (STAP1);
//       EnableTap (STAP29);
       
//       EnableTap (STAP27);
//       EnableTap (STAP27);
//       EnableTap (STAP27);
////       EnableTap (STAP3);
//       EnableTap (STAP27);
//       EnableTap (STAP27);
//       EnableTap (STAP29);
//       TapAccess(.Tap(STAP3), .Opcode('hA0), .ShiftIn(32'h33), .ShiftLength(32));
//       TapAccess(.Tap(STAP3), .Opcode('hA0), .ShiftLength(32), .ExpectedData(32'h33), .CompareMask('1));

///    Basic
//       EnableTap (STAP0);
//       EnableTap (STAP1);
//       DisableTap (STAP1);
//       EnableTap (STAP1);
//       EnableTap (STAP2);
//       EnableTap (STAP3);

////Scenario 1
//       EnableTap (STAP1);
//       EnableTap (STAP29);
//       TapAccessSlaveIdcode (STAP29);
//       DisableTap (STAP29);
//       DisableTap (STAP1);
//       TapAccessCltapcIdcode(CLTAP);


//Scenario 2
       EnableTap (STAP0);
       EnableTap (STAP1);
       EnableTap (STAP5);
       EnableTap (STAP6);
       EnableTap (STAP29);
       TapAccessSlaveIdcode (STAP5);
       TapAccessSlaveIdcode (STAP6);
       TapAccessSlaveIdcode (STAP29);
       DisableTap (STAP1);
       TapAccessCltapcIdcode(CLTAP);
//       TapAccessSlaveIdcode (STAP5);
//       TapAccessSlaveIdcode (STAP6);
//       TapAccessSlaveIdcode (STAP7);
       EnableTap (STAP1);
       TapAccessSlaveIdcode (STAP5);
       TapAccessSlaveIdcode (STAP5);

////Scenario 3
//       EnableTap (STAP15);
//       EnableTap (STAP16);
//       EnableTap (STAP17);
//       EnableTap (STAP18);
//       TapAccess(STAP15,   'h0C, DONT_CARE, 0, 32'hC0DE_1501, '1, 0, 0, EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(STAP16,   'h0C, DONT_CARE, 0, 32'hC0DE_1601, '1, 0, 0, EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(STAP17,   'h0C, DONT_CARE, 0, 32'hC0DE_1701, '1, 0, 0, EN_REGISTER_PRESENCE_CHECK);
//       TapAccess(STAP18,   'h0C, DONT_CARE, 0, 32'hC0DE_1801, '1, 0, 0, EN_REGISTER_PRESENCE_CHECK);
//       DisableTap (STAP16);
//       TapAccess(STAP16,   'h0C, DONT_CARE, 0, 32'hC0DE_1601, '1, 0, 0, EN_REGISTER_PRESENCE_CHECK);

      SetMultiTapCapabilityOnly(CLTAP);
      SetMultiTapCapabilityOnly(STAP1);
      SetMultiTapCapabilityOnly(STAP2);

      AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h0, 12'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      MultiTapAccessLaunchPrimary();

      AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h90, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h80, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h70, 12'hFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
      MultiTapAccessLaunchPrimary();
      MultiTapAccessLaunchPrimary();

      DisableTap (STAP1);
      //=================================================
      TapAccessSlaveIdcode(STAP25);
      TapAccessRmw(STAP25, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
      TapAccessRmw(STAP25, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
      TapAccessRmw(STAP25, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
      TapAccess   (STAP25, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
      TapAccessSlaveIdcode(STAP25);
      //=================================================

    endtask : body

endclass : Tap5levelHierSequenceDisable



class Tap5levelHierSequenceTry_removeNew #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                        parameter Tap_t TAP = 0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
   function new(string name = "Tap5levelHierSequenceTry_removeNew");
      super.new(name);
      Packet = new;
   endfunction : new

   `ovm_sequence_utils(Tap5levelHierSequenceTry_removeNew, JtagBfmSequencer)


    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.
       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       BuildTapDataBase();
       Reset(2'b11);
       EnableTap(STAP6);
       TapAccessSlaveIdcode (STAP5);
       RemoveTap(CLTAP);
//       RemoveTap(STAP24);
       TapAccessSlaveIdcode (STAP5);
//       RemoveTap(STAP1);
       TapAccessSlaveIdcode (STAP6);
//       RemoveTap(STAP2);
       TapAccessSlaveIdcode (STAP3);
       TapAccessSlaveIdcode (STAP17);
       TapAccessSlaveIdcode (STAP17);

       SetMultiTapCapabilityOnly(CLTAP);
       SetMultiTapCapabilityOnly(STAP1);
       SetMultiTapCapabilityOnly(STAP2);

       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h0, 12'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchPrimary();

       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h90, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h80, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h70, 12'hFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchPrimary();
       MultiTapAccessLaunchPrimary();


      //=================================================
      TapAccessSlaveIdcode(STAP17);
      TapAccessRmw(STAP17, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
      TapAccessRmw(STAP17, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
      TapAccessRmw(STAP17, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
      TapAccess   (STAP17, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
      TapAccessSlaveIdcode(STAP17);
      //=================================================


    endtask : body

endclass : Tap5levelHierSequenceTry_removeNew



class Tap5levelHierSequenceTry_removeWithSecondaryNew #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                        parameter Tap_t TAP = 0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
   function new(string name = "Tap5levelHierSequenceTry_removeWithSecondaryNew");
      super.new(name);
      Packet = new;
   endfunction : new

   `ovm_sequence_utils(Tap5levelHierSequenceTry_removeWithSecondaryNew, JtagBfmSequencer)

    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.
       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
//       BuildTapDataBase();
//       Reset(2'b11);
//       EnableTap(STAP6);
//       PutTapOnSecondary(STAP6);
       TapAccessSlaveIdcode (STAP5);
//       RemoveTap(CLTAP);
//       RemoveTap(STAP1);
       TapAccessSlaveIdcode (STAP5);
       EnableTap(STAP3);
       RemoveTap(STAP2);
       TapAccessSlaveIdcode (STAP6);
//       RemoveTap(STAP2);
       TapAccessSlaveIdcode (STAP3);
       TapAccessSlaveIdcode (STAP3);
       TapAccessSlaveIdcode (STAP3);
       TapAccessSlaveIdcode (STAP17);

       SetMultiTapCapabilityOnly(CLTAP);
       SetMultiTapCapabilityOnly(STAP1);
       SetMultiTapCapabilityOnly(STAP3);

       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'h0C, 32'h0, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP3, 'h53, 12'h70, 12, 32'h0, 12'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchSecondary();
       AddIrDrForMultiTapAccess (STAP3, 'h53, 12'h70, 12, 32'h70, 12'hFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchSecondary();


      //=================================================
      TapAccessSlaveIdcode(STAP17);
      TapAccessRmw(STAP17, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
      TapAccessRmw(STAP17, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
      TapAccessRmw(STAP17, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
      TapAccess   (STAP17, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
      TapAccessSlaveIdcode(STAP17);
      //=================================================

    endtask : body

endclass : Tap5levelHierSequenceTry_removeWithSecondaryNew



class Tap5levelHierSequenceTrySecConfigRemoveNew #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                             parameter Tap_t TAP = STAP0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTrySecConfigRemoveNew");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTrySecConfigRemoveNew, JtagBfmSequencer)
 
    virtual task body();
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       $display("1. TAP = %0s", TAP);
       BuildTapDataBase();
       Reset(2'b11);
       PutTapOnSecondary(TAP);

    endtask : body

endclass : Tap5levelHierSequenceTrySecConfigRemoveNew


class Tap5levelHierSequenceTryReturnTdo #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
                                          parameter Tap_t TAP = 1) extends JtagBfmSoCTapNwSequences;

   Tap_t tap = TAP;
   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTryReturnTdo");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTryReturnTdo, JtagBfmSequencer)
 
    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ShiftInValue;
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;

       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);

       BuildTapDataBase();
       Reset(2'b11);
       ShiftInValue = $random();
       TapAccess(.Tap(TAP), .Opcode('hA0), .ShiftIn(ShiftInValue), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));
       TapAccess(.Tap(TAP), .Opcode('hA0), .ShiftIn(ReturnTdo), .ShiftLength(32), .ExpectedData(ShiftInValue), .CompareMask('1), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));

       if (ReturnTdo[31:0] == ShiftInValue[31:0]) begin
          ovm_report_info("",$psprintf("ReturnTdo test passed for [%0s], ShiftInValue = %0h, ReturnTdo = %0h",
             TAP, ShiftInValue[31:0], ReturnTdo[31:0]));
       end
       else begin
          ovm_report_error("",$psprintf("ReturnTdo test passed for [%0s], ShiftInValue = %0h, ReturnTdo = %0h",
             TAP, ShiftInValue[31:0], ReturnTdo[31:0]));
       end

       TapAccessRmw(STAP18, 8'hA0, 32'hFFFF_00FF, 0, 0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
       TapAccessSlaveIdcode(STAP1);
       TapAccessRmw(STAP18, 8'hA0, 32'h0000_3300, 0, 0, 32'h0000_FF00, 0, 1, ReturnTdo);
       TapAccessSlaveIdcode(STAP1);
       TapAccessRmw(STAP18, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
       TapAccessRmw(STAP18, 8'hA0, 32'h0022_0000, 0,             0, 32'h00FF_0000, 0, 1, ReturnTdo);
       TapAccess   (STAP18, 8'hA0, 32'h0000_1234, 0, 32'h1122_33FF,            '1, 0, 1, ReturnTdo);

    endtask : body

endclass : Tap5levelHierSequenceTryReturnTdo


class Tap5levelHierSequenceTrySecConfigComplex
   #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
     parameter Tap_t TAP = STAP0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTrySecConfigComplex");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTrySecConfigComplex, JtagBfmSequencer)
 
    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       BuildTapDataBase();
       Reset(2'b11);
       EnableTap(STAP0);
       PutTapOnSecondary(STAP0);
       EnableTap(STAP25);
       EnableTap(STAP24);
       EnableTap(STAP20);
       PutTapOnSecondary(STAP20);
       EnableTap(STAP29);
       PutTapOnSecondary(STAP29);

       EnableTap(STAP5);
       EnableTap(STAP7);
       EnableTap(STAP15);
       EnableTap(STAP18);
    endtask : body

endclass : Tap5levelHierSequenceTrySecConfigComplex


class Tap5levelHierSequenceTryPriDataComplex
   #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
     parameter Tap_t TAP = STAP0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTryPriDataComplex");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTryPriDataComplex, JtagBfmSequencer)
 
    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       TapAccessSlaveIdcode (STAP18);

       SetMultiTapCapabilityOnly(CLTAP);
       SetMultiTapCapabilityOnly(STAP1);
       SetMultiTapCapabilityOnly(STAP2);

       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h0, 32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h0, 12'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

       MultiTapAccessLaunchPrimary();

       AddIrDrForMultiTapAccess (CLTAP, 'hFF, 32'h90, 32, 32'h0,  32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h80, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h70, 12'hFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

       MultiTapAccessLaunchPrimary();


      //=================================================
      TapAccessSlaveIdcode(STAP17);
      TapAccessRmw(STAP17, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
      TapAccessRmw(STAP17, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
      TapAccessRmw(STAP17, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
      TapAccess   (STAP17, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
      TapAccessSlaveIdcode(STAP17);
      //=================================================



    endtask : body

endclass : Tap5levelHierSequenceTryPriDataComplex


class Tap5levelHierSequenceTrySecDataComplex
   #(parameter EN_REGISTER_PRESENCE_CHECK = 1,
     parameter Tap_t TAP = STAP0) extends JtagBfmSoCTapNwSequences;

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceTrySecDataComplex");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceTrySecDataComplex, JtagBfmSequencer)
 
    virtual task body();
       logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       TapAccessSlaveIdcode (STAP25);
       TapAccessSlaveIdcode (STAP24);
       TapAccessSlaveIdcode (STAP29);
       TapAccessSlaveIdcode (STAP20);
       TapAccessSlaveIdcode (STAP0);


       SetMultiTapCapabilityOnly(STAP24);
       SetMultiTapCapabilityOnly(STAP29);

       AddIrDrForMultiTapAccess (STAP24, 'h74, 34'hABCD,   34, 34'h0, 34'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP29, 'h79, 39'hFF00FF, 39, 39'h0, 39'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchSecondary();
       AddIrDrForMultiTapAccess (STAP24, 'hA0, 32'h1234, 32, 32'h0,      32'h0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP29, 'h79, 39'h5678, 39, 39'hFF00FF,    '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchSecondary();

      //=================================================
      TapAccessSlaveIdcode(STAP24);
      TapAccessRmw(STAP24, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
      TapAccessRmw(STAP24, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
      TapAccessRmw(STAP24, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
      TapAccess   (STAP24, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
      TapAccessSlaveIdcode(STAP24);
      //=================================================

    endtask : body

endclass : Tap5levelHierSequenceTrySecDataComplex


class Tap5levelHierSequenceOptimize #(parameter EN_REGISTER_PRESENCE_CHECK = 1) extends JtagBfmSoCTapNwSequences;


   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSequenceOptimize");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSequenceOptimize, JtagBfmSequencer)

    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       BuildTapDataBase();
       Reset(2'b11);

       EnableTap(STAP0);
       EnableTap(STAP1);
       EnableTap(STAP20);

       TapAccess(STAP1, 8'hFF, 6'h35, 6, 6'h14, 6'h3F, 0, 1, ReturnTdo);
       TapAccess(STAP1, 8'hFF, 6'h36, 6, 6'h14, 6'h3F, 0, 1, ReturnTdo);
       TapAccess(STAP1, 8'hFF, 6'h37, 6, 6'h14, 6'h3F, 1, 1, ReturnTdo);
       TapAccess(STAP1, 8'hFF, 6'h38, 6, 6'h14, 6'h3F, 1, 1, ReturnTdo);
       TapAccess(STAP1, 8'hFF, 6'h39, 6, 6'h14, 6'h3F, 1, 1, ReturnTdo);

       TapAccess(STAP1, 8'hCF, 6'h3A, 6, 6'h14, 6'h3F, 0, 1, ReturnTdo);
       TapAccess(STAP1, 8'hDF, 6'h3B, 6, 6'h14, 6'h3F, 0, 1, ReturnTdo);
       TapAccess(STAP1, 8'hEF, 6'h3C, 6, 6'h14, 6'h3F, 1, 1, ReturnTdo);
       TapAccess(STAP1, 8'h9E, 6'h3D, 6, 6'h14, 6'h3F, 1, 1, ReturnTdo);
       TapAccess(STAP1, 8'h93, 6'h3E, 6, 6'h14, 6'h3F, 1, 1, ReturnTdo);

       TapAccess(STAP2, 'hA0, 32'h40,  32, 0,       0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2, 'hA0, 32'h41,  32, 32'h40, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2, 'hA0, 32'h42,  32, 32'h41, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2, 'hA0, 32'h43,  32, 32'h42, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2, 'hA0, 32'h44,  32, 32'h43, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP2, 'hA0, 32'h45,  32, 32'h44, '1, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

      //=================================================
      TapAccessSlaveIdcode(STAP24);
      TapAccessRmw(STAP24, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
      TapAccessRmw(STAP24, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
      TapAccessRmw(STAP24, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
      TapAccess   (STAP24, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
      TapAccessSlaveIdcode(STAP24);
      //=================================================

    endtask : body
endclass : Tap5levelHierSequenceOptimize

class Tap5levelHierSeqMultiTapAccess #(parameter EN_REGISTER_PRESENCE_CHECK = 1) extends JtagBfmSoCTapNwSequences;


   JtagBfmSeqDrvPkt Packet;
    function new(string name = "Tap5levelHierSeqMultiTapAccess");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Tap5levelHierSeqMultiTapAccess, JtagBfmSequencer)

    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       BuildTapDataBase();
       Reset(2'b11);

       TapAccessRmw(STAP1, 8'hA0, 32'hFFFF_00FF, 0, 0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
       TapAccessSlaveIdcode(STAP1);
       TapAccessRmw(STAP1, 8'hA0, 32'h0000_3300, 0, 0, 32'h0000_FF00, 0, 1, ReturnTdo);
       TapAccessSlaveIdcode(STAP1);
       TapAccessRmw(STAP1, 8'hA0, 32'h1100_0000, 0, 0, 32'hFF00_0000, 0, 1, ReturnTdo);
       TapAccessRmw(STAP1, 8'hA0, 32'h0022_0000, 0, 0, 32'h00FF_0000, 0, 1, ReturnTdo);
       TapAccess   (STAP1, 8'hA0, 32'h0000_1234, 0, 32'h1122_33FF,'1, 0, 1, ReturnTdo);

       TapAccessSlaveIdcode (STAP2);

       SetMultiTapCapabilityOnly(CLTAP);
       EnableTapForMultiAccess(STAP1);
       EnableTapForMultiAccess(STAP2);

       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'hAA, 32, 32'h0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h43, 32, 32'h0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h42, 12, 32'h0, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchPrimary();

       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'hBB, 32, 32'hAA, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hFF, 32'h88, 32, 32'h86, 32'h1,         0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'hDD, 12'h77, 12, 32'h42, 12'h1,         0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchPrimary();

       TapAccessSlaveIdcode (STAP3);

       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h22, 32, 32'hBB, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h33, 32, 32'h43, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h44, 12, 32'h42, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchPrimary();

       EnableTap(STAP3);
       TapAccess(STAP3, 'hA0, 32'h45,  32, 32'h44, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       TapAccess(STAP3, 'hA0, 32'h46,  32, 32'h45, 0, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);

       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h0, 32, 32'h22, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h0, 32, 32'h33, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h0, 12, 32'h44, 12'hFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchPrimary();

       TapAccessSlaveIdcode (STAP18);
       TapAccessSlaveIdcode (STAP25);

       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h0, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h0, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h0, 12'hFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchPrimary();

       AddIrDrForMultiTapAccess (CLTAP, 'h34, 32'h90, 32, 32'h90, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP1, 'hA0, 32'h80, 32, 32'h80, 32'hFFFF_FFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       AddIrDrForMultiTapAccess (STAP2, 'h52, 12'h70, 12, 32'h70, 12'hFFF, 0, EN_REGISTER_PRESENCE_CHECK, ReturnTdo);
       MultiTapAccessLaunchPrimary();

       MultiTapAccessLaunchPrimary();
      //=================================================
      TapAccessSlaveIdcode(STAP24);
      TapAccessRmw(STAP24, 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
      TapAccessRmw(STAP24, 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
      TapAccessRmw(STAP24, 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
      TapAccess   (STAP24, 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
      TapAccessSlaveIdcode(STAP24);
      //=================================================


    endtask : body
endclass : Tap5levelHierSeqMultiTapAccess

class sla_Tap5levelHierSequenceOptimize #(parameter EN_REGISTER_PRESENCE_CHECK = 1) extends sla_sequence_base;

  `ovm_sequence_utils(sla_Tap5levelHierSequenceOptimize, sla_sequencer)
  JtagBfmSequencer tapsqr, tapsqr2, tapsqr3;
  ovm_sequencer_base sqr, sqr2, sqr3;
  Tap5levelHierSequenceOptimize #(1) ST;

    function new(string name = "sla_Tap5levelHierSequenceOptimize");
        super.new(name);
    endfunction : new

    virtual task body();
      ST = new("ALL Primary Mode");
      sqr = p_sequencer.pick_sequencer("jtag_id1");
      assert($cast (tapsqr, sqr));
      `ovm_do_on (ST, sqr)
    endtask : body

endclass : sla_Tap5levelHierSequenceOptimize

class sla_Tap5levelHierSequenceTrySecConfigNew #(parameter EN_REGISTER_PRESENCE_CHECK = 1) extends JtagBfmSoCTapNwSequences; 

   JtagBfmSeqDrvPkt Packet;
    function new(string name = "sla_Tap5levelHierSequenceTrySecConfigNew");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(sla_Tap5levelHierSequenceTrySecConfigNew, JtagBfmSequencer)
 
    virtual task body();
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       BuildTapDataBase();
       Reset(2'b11);
       PutTapOnSecondary(STAP5);
       EnableTap(STAP29);
       TapAccessSlaveIdcode(STAP29);

    endtask : body

endclass : sla_Tap5levelHierSequenceTrySecConfigNew


class sla_Tap5levelHierSequenceTrySecondary #(parameter EN_REGISTER_PRESENCE_CHECK = 1) extends JtagBfmSoCTapNwSequences;

   Tap_t tap = STAP5;
   JtagBfmSeqDrvPkt Packet;
    function new(string name = "sla_Tap5levelHierSequenceTrySecondary");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(sla_Tap5levelHierSequenceTrySecondary, JtagBfmSequencer)
 
    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       // TODO - Find a place where this object is created before the runtime.
       // JtagBfmMasterAgent - can add an start_of_simulation phase.

       $display("EN_REGISTER_PRESENCE_CHECK = %0d", EN_REGISTER_PRESENCE_CHECK);
       $display("2. tap = %0d", tap);
       $display("2. 'h50+tap-1 = %0h", 'h50+tap-1);
       $display("2. 'h10+tap-1 = %0h", 'h10+tap-1);
       $display("2. 10+tap-1 = %0d", 10+tap-1);

       for (int i=0; i<NUMBER_OF_TAPS; i++) begin //{
          $display("1 2nd seq : ArrayOfHistoryElements[%0d].IsTapOnSecondary = %0d", i, ArrayOfHistoryElements[i].IsTapOnSecondary);
       end //}

       $display("====================================");

       for (int i=0; i<NUMBER_OF_TAPS; i++) begin //{
          $display("2 2nd seq : ArrayOfHistoryElements[%0d].IsTapOnSecondary = %0d", i, ArrayOfHistoryElements[i].IsTapOnSecondary);
       end //}

       TapAccess(.Tap(tap), .Opcode('h0C), .ShiftIn(32'h0), .ShiftLength(32), .EnRegisterPresenceCheck(EN_REGISTER_PRESENCE_CHECK), .ReturnTdo(ReturnTdo));

    endtask : body

endclass : sla_Tap5levelHierSequenceTrySecondary


class sla_Tap5levelHierSequenceTrySecondaryNew #(parameter EN_REGISTER_PRESENCE_CHECK = 1) extends sla_sequence_base;

   `ovm_sequence_utils(sla_Tap5levelHierSequenceTrySecondaryNew, sla_sequencer)
   JtagBfmSequencer tapsqr, tapsqr2;
   ovm_sequencer_base sqr, sqr2;
   sla_Tap5levelHierSequenceTrySecConfigNew  #(1)  ST_CONFIG;
   sla_Tap5levelHierSequenceTrySecondary     #(1)  ST_SECONDARY;

   function new (string name = "sla_Tap5levelHierSequenceTrySecondaryNew");
       super.new(name);
   endfunction : new

    virtual task body();
      ST_CONFIG = new("ALL Primary Mode");
      sqr = p_sequencer.pick_sequencer("jtag_id1");
      assert($cast (tapsqr, sqr));
      `ovm_do_on (ST_CONFIG, sqr)

      ST_SECONDARY = new("ALL Seondary Mode");
      sqr2 = p_sequencer.pick_sequencer("jtag_id2");
      assert($cast (tapsqr2, sqr2));
      `ovm_do_on (ST_SECONDARY, sqr2)

    endtask : body

endclass : sla_Tap5levelHierSequenceTrySecondaryNew

//^^^^^^^^^^^^^^^^^^_______________^^^^^^^^^^^^^^^^^
//   WTAP                                ROCKS
//vvvvvvvvvvvvvvvvvv---------------vvvvvvvvvvvvvvvvv
class SoCTapNwBuildTapDataBaseSeq extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "SoCTapNwBuildTapDataBaseSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(SoCTapNwBuildTapDataBaseSeq, JtagBfmSequencer)

    virtual task body();

       BuildTapDataBase();

    endtask : body
endclass : SoCTapNwBuildTapDataBaseSeq

//-------------------------------------------------------------
class Wtap0EnableSeq extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "Wtap0EnableSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Wtap0EnableSeq, JtagBfmSequencer)

    virtual task body();

    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;

       //BuildTapDataBase();
       //super.body();

       Reset(2'b11);

       TapAccess(.Tap(STAP19),                 .Opcode('h13),      .EnRegisterPresenceCheck(0), 
                 .EnUserDefinedShiftLength(1), .ShiftLength(2),    .ShiftIn(2'b01),
                 .ExpectedData('0),            .CompareMask('0),
                 .ReturnTdo(ReturnTdo));

    endtask : body
endclass : Wtap0EnableSeq
//-------------------------------------------------------------
class Wtap0TDRAccessSeq extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "Wtap0TDRAccessSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Wtap0TDRAccessSeq, JtagBfmSequencer)

    virtual task body();

       ExpData_MultipleTapRegisterAccess( 
                .ResetMode(2'b00),
                .Address(48'h_FF_FF_FF_FF_FF_78),
                .addr_len(48),
                .Data({{5'b11111},{32'h_1234_5678}}),
                .Expected_Data('b0),
                .Mask_Data('b0),
                .data_len(37));

       Goto(RUTI,11);

       LoadDR_idle(
                .ResetMode(2'b00),
                .Data({{5'b11111},{32'h_ABCD_BABA}}),
                .Expected_Data({{5'b00000},{32'h_1234_5678}}),
                .Mask_Data('b1),
                .data_len(37)); 
                
    endtask : body
endclass : Wtap0TDRAccessSeq
//-------------------------------------------------------------
//-------------------------------------------------------------
class Wtap1EnableSeq extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "Wtap1EnableSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Wtap1EnableSeq, JtagBfmSequencer)

    virtual task body();

    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;

       //BuildTapDataBase();

       //Reset(2'b11);

       TapAccess(.Tap(STAP19),                 .Opcode('h13),      .EnRegisterPresenceCheck(0), 
                 .EnUserDefinedShiftLength(1), .ShiftLength(2),    .ShiftIn(2'b10),
                 .ExpectedData('0),            .CompareMask('0),
                 .ReturnTdo(ReturnTdo));

    endtask : body
endclass : Wtap1EnableSeq
//-------------------------------------------------------------
class Wtap1TDRAccessSeq extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "Wtap1TDRAccessSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Wtap1TDRAccessSeq, JtagBfmSequencer)

    virtual task body();

       ExpData_MultipleTapRegisterAccess( 
                .ResetMode(2'b00),
                .Address(48'h_FF_FF_FF_FF_FF_A0),
                .addr_len(48),
                .Data({{5'b11111},{32'h_9988_7766}}),
                .Expected_Data('b0),
                .Mask_Data('b0),
                .data_len(37));

       Goto(RUTI,11);

       LoadDR_idle(
                .ResetMode(2'b00),
                .Data({{5'b11111},{32'h_2233_4455}}),
                .Expected_Data({{5'b00000},{32'h_9988_7766}}),
                .Mask_Data('b1),
                .data_len(37)); 
                
    endtask : body
endclass : Wtap1TDRAccessSeq

//-------------------------------------------------------------
class TerCfgSeq #(parameter SCENARIO = 1)  extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TerCfgSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(TerCfgSeq, JtagBfmSequencer)

    virtual task body();

    //Reset(2'b11);
    if(SCENARIO == 1) begin
       PutTapOnTertiary(STAP18);
    end
    if(SCENARIO == 2) begin
       PutTapOnTertiary(STAP4);
    end
    if((SCENARIO == 3) || (SCENARIO == 4)) begin
       PutTapOnTertiary(STAP16);
    end
    if(SCENARIO == 33) begin
       PutTapOnTertiary(STAP3);
    end
    if(SCENARIO == 44) begin
       PutTapOnSecondary(STAP7);
    end
    if(SCENARIO == 5) begin
       PutTapOnTertiary(STAP6);
    end
    if(SCENARIO == 6) begin
       PutTapOnTertiary(STAP9);
       DisableTertiaryPort(STAP13);
    end

    print_port_assocation_table();
                
    endtask : body
endclass : TerCfgSeq

//-----------
class Ter0AccessSeq #(parameter SCENARIO = 1) extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "Ter0AccessSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Ter0AccessSeq, JtagBfmSequencer)

    virtual task body();

    if(SCENARIO == 1) begin
       TapAccessSlaveIdcode(STAP6);
    end
    if(SCENARIO == 2) begin
       TapAccessSlaveIdcode(STAP4);
       TapAccessSlaveIdcode(STAP2);
    end
    if(SCENARIO == 3) begin
       TapAccessSlaveIdcode(STAP3);
       TapAccessSlaveIdcode(STAP7);
       TapAccessSlaveIdcode(STAP2);
       TapAccessSlaveIdcode(STAP5);
    end
    if(SCENARIO == 5) begin
       TapAccessSlaveIdcode(STAP5);
       RemoveTap(STAP4);
       TapAccessSlaveIdcode(STAP6);
       TapAccessSlaveIdcode(STAP7);
    end
    if(SCENARIO == 6) begin
       TapAccessSlaveIdcode(STAP9);
       EnableTap(STAP17);
       RemoveTap(STAP13);
       TapAccessSlaveIdcode(STAP17);
    end


    print_port_assocation_table();
                
    endtask : body
endclass : Ter0AccessSeq

//-----------
class Ter1AccessSeq #(parameter SCENARIO = 1) extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "Ter1AccessSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(Ter1AccessSeq, JtagBfmSequencer)

    virtual task body();

    if(SCENARIO == 1) begin
       TapAccessSlaveIdcode(STAP18);
       TapAccessSlaveIdcode(STAP15);
    end
    if(SCENARIO == 3) begin
       TapAccessSlaveIdcode(STAP16);
       TapAccessSlaveIdcode(STAP15);
    end
    if(SCENARIO == 4) begin
       TapAccessSlaveIdcode(STAP16);
    end

    print_port_assocation_table();
                
    endtask : body
endclass : Ter1AccessSeq

//-----------
class PriAccessSeq #(parameter SCENARIO = 1) extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "PriAccessSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(PriAccessSeq, JtagBfmSequencer)

    virtual task body();

    logic [WIDTH_OF_EACH_REGISTER-1:0] TdoBack;

    TapAccessCltapcIdcode(CLTAP);

    if(SCENARIO == 1) begin
       TapAccessSlaveIdcode(STAP19);
       TapAccessSlaveIdcode(STAP0);
       TapAccessSlaveIdcode(STAP5);
       TapAccessSlaveIdcode(STAP26);
       TapAccessSlaveIdcode(STAP22);
       TapAccessSlaveIdcode(STAP1);
       TapAccessSlaveIdcode(STAP27);
       TapAccessSlaveIdcode(STAP13);
    end

    if(SCENARIO == 2) begin
       TapAccessSlaveIdcode(STAP9);
       TapAccessSlaveIdcode(STAP17);
       TapAccessSlaveIdcode(STAP26);
       TapAccessSlaveIdcode(STAP22);
       TapAccessSlaveIdcode(STAP0);
       TapAccessSlaveIdcode(STAP1);
    end
            
    if(SCENARIO == 3) begin
       TapAccessSlaveIdcode(STAP0);
       TapAccessSlaveIdcode(STAP29);
       TapAccessSlaveIdcode(STAP22);
       TapAccessSlaveIdcode(STAP1);
       TapAccessSlaveIdcode(STAP19);
       TapAccessSlaveIdcode(STAP26);
       TapAccessSlaveIdcode(STAP10);
    end

    if(SCENARIO == 4) begin
       TapAccessSlaveIdcode(STAP0);
       TapAccessSlaveIdcode(STAP29);
       TapAccessSlaveIdcode(STAP22);
       TapAccessSlaveIdcode(STAP9);
       TapAccessSlaveIdcode(STAP26);
    end
    if(SCENARIO == 44) begin
       TapAccessSlaveIdcode(STAP0);
       TapAccessSlaveIdcode(STAP29);
       TapAccessSlaveIdcode(STAP22);
       TapAccessSlaveIdcode(STAP26);
    end


    if(SCENARIO == 5) begin
       EnableTap(STAP8);
       RemoveTap(STAP1);
       TapAccessSlaveIdcode(STAP9);
       TapAccessSlaveIdcode(STAP13);
       TapAccessSlaveIdcode(STAP0);
       TapAccessSlaveIdcode(STAP22);
       PutTapOnSecondary(STAP23);
       TapAccessSlaveIdcode(STAP29);
       TapAccessSlaveIdcode(STAP16);
       RemoveTap(STAP13);
       TapAccessSlaveIdcode(STAP17);
    end

    if(SCENARIO == 6) begin
       //Use this if a TAP is already enabled
       //SetMultiTapCapabilityOnly(STAP3);
       //SetMultiTapCapabilityOnly(STAP5);

       EnableTapForMultiAccess(STAP3);
       EnableTapForMultiAccess(STAP5);
       AddIrDrForMultiTapAccess (.Tap(STAP3), 
                                 .Opcode('hA0),
                                 .ShiftIn(32'h1122_3344),
                                 .ShiftLength(32),
                                 .ExpectedData(32'b0),
                                 .CompareMask(32'b0),
                                 .EnUserDefinedShiftLength(0),
                                 .EnRegisterPresenceCheck(1),
                                 .ReturnTdo(TdoBack));
       AddIrDrForMultiTapAccess (.Tap(STAP5), 
                                 .Opcode('hA0),
                                 .ShiftIn(32'h5566_7788),
                                 .ShiftLength(32),
                                 .ExpectedData(32'b0),
                                 .CompareMask(32'b0),
                                 .EnUserDefinedShiftLength(0),
                                 .EnRegisterPresenceCheck(1),
                                 .ReturnTdo(TdoBack));
       MultiTapAccessLaunchPrimary();

       EnableTap(STAP6);
       RemoveTap(STAP4);
       MultiTapAccessLaunchPrimary();

       TapAccessSlaveIdcode(STAP0);
       TapAccessSlaveIdcode(STAP7);
       RemoveTap(STAP2);
       TapAccessSlaveIdcode(STAP6);
    end
    
    print_port_assocation_table();

    endtask : body
endclass : PriAccessSeq

//-----------
class SecAccessSeq #(parameter SCENARIO = 1) extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "SecAccessSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(SecAccessSeq, JtagBfmSequencer)

    virtual task body();

    if(SCENARIO == 4) begin
       TapAccessSlaveIdcode(STAP7);
       TapAccessSlaveIdcode(STAP5);
    end

    if(SCENARIO == 5) begin
       TapAccessSlaveIdcode(STAP26);
       TapAccessSlaveIdcode(STAP23);
       TapAccessSlaveIdcode(STAP21);
    end
                
    print_port_assocation_table();

    endtask : body
endclass : SecAccessSeq


//-----------
class DisTerSeq extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "DisTerSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `ovm_sequence_utils(DisTerSeq, JtagBfmSequencer)

    virtual task body();

       DisableTertiaryPort(STAP13);
                
    endtask : body
endclass : DisTerSeq


class TapAccessReadModifyWriteTestSequence #(parameter SCENARIO = 0) extends JtagBfmSoCTapNwSequences;

    function new(string name = "TapAccessReadModifyWriteTestSequence");
        super.new(name);
    endfunction : new

    `ovm_sequence_utils(TapAccessReadModifyWriteTestSequence, JtagBfmSequencer)

    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       BuildTapDataBase();
       Reset(2'b11);
       TapEnumMap();
       if (SCENARIO == 0) begin
          for (int m=0; m < 2; m++) begin
             for (int i=0; i < NUMBER_OF_TAPS; i++) begin
                if (i != 0) begin
                   TapAccessSlaveIdcode(Tap_string_array[i]);
                   TapAccessRmw(Tap_string_array[i], 8'hA0, 32'hFFFF_00FF, 0,             0, 32'hFFFF_FFFF, 0, 1, ReturnTdo);
                   TapAccessRmw(Tap_string_array[i], 8'hA0, 32'h0000_3300, 0,             0, 32'h0000_FF00, 0, 1, ReturnTdo);
                   TapAccessRmw(Tap_string_array[i], 8'hA0, 32'h1100_0000, 0,             0, 32'hFF00_0000, 0, 1, ReturnTdo);
                   TapAccess   (Tap_string_array[i], 8'hA0, 32'h0000_1234, 0, 32'h11FF_33FF,            '1, 0, 1, ReturnTdo);
                   TapAccessSlaveIdcode(Tap_string_array[i]);
                end
             end
          end
       end
       if (SCENARIO == 1) begin

       end

    endtask : body
endclass : TapAccessReadModifyWriteTestSequence



class ShadowModeSeq extends JtagBfmSoCTapNwSequences;

    function new(string name = "ShadowModeSeq");
        super.new(name);
    endfunction : new

    `ovm_sequence_utils(ShadowModeSeq, JtagBfmSequencer)

    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       BuildTapDataBase();
       Reset(2'b11);
       
       //--------------------------------------------
       /*
       TapAccess(.Tap(CLTAP), 
                 .Opcode('h11), 
                 .ShiftIn(12'b01_11_11_11_11_11), 
                 .ShiftLength(12), 
                 .CompareMask(0),
                 .ExpectedData(0),
                 .EnRegisterPresenceCheck(0), 
                 .ReturnTdo(ReturnTdo));

       //TapAccess(.Tap(STAP29), 
       //          .Opcode('hA0), 
       //          .ShiftIn(32'h1234_5678), 
       //          .ShiftLength(32), 
       //          .CompareMask(0),
       //          .ExpectedData(0),
       //          .EnRegisterPresenceCheck(0), 
       //          .ReturnTdo(ReturnTdo));

       
       MultipleTapRegisterAccess(.ResetMode(NO_RST),
                                 .Address  (16'hFF_A0),
                                 .Data     (33'h0_1234_5678),
                                 .addr_len (16),
                                 .data_len (33));
       */                          
       //--------------------------------------------

       // Set S1 & S20 in Normal mode
       MultipleTapRegisterAccess(.ResetMode(NO_RST),
                                 .Address  (8'h11),
                                 .Data     (12'b00_00_00_01_01_00),
                                 .addr_len (8),
                                 .data_len (12));

       // Set S2, S8, S21 in Shadow mode & S22 in Normal mode
       MultipleTapRegisterAccess(.ResetMode(NO_RST),
                                 .Address  (24'hFF_11_11),
                                 .Data     (13'b0_1111_00000111),
                                 .addr_len (24),
                                 .data_len (13));

       // Set S1 in Shadow mode
       MultipleTapRegisterAccess(.ResetMode(NO_RST),
                                 .Address  (32'h11_FF_FF_FF),
                                 .Data     (15'b00_00_00_01_11_00_0_0_0),
                                 .addr_len (32),
                                 .data_len (15));

       // Pump in data into S20 & S22
       MultipleTapRegisterAccess(.ResetMode(NO_RST),
                                 .Address  (24'hFF_A0_A0),
                                 .Data     (65'h0_12345678_12345678),
                                 .addr_len (24),
                                 .data_len (65));

        
//       // Set S1 in Normal & S20 in Shadow mode
//       MultipleTapRegisterAccess(.ResetMode(NO_RST),
//                                 .Address  (8'h11),
//                                 .Data     (12'b00_00_00_11_01_00),
//                                 .addr_len (8),
//                                 .data_len (12));
//
//       // Access A0 in S1
//       MultipleTapRegisterAccess(.ResetMode(NO_RST),
//                                 .Address  (16'hFF_A0),
//                                 .Data     (33'h8765_4321),
//                                 .addr_len (16),
//                                 .data_len (33));

    endtask : body

endclass : ShadowModeSeq

class SequenceLayer0 extends JtagBfmSoCTapNwSequences;

    function new(string name = "SequenceLayer0");
        super.new(name);
    endfunction : new

    `ovm_sequence_utils(SequenceLayer0, JtagBfmSequencer)

    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       BuildTapDataBase();
       Reset(2'b11);
       
       MultipleTapRegisterAccess(
          .ResetMode(NO_RST),
          .Address  (8'h0C),
          .Data     ('h0),
          .addr_len (8),
          .data_len (32));

       TapAccess(.Tap(CLTAP), 
                 .Opcode('h0C), 
                 .ShiftIn(0), 
                 .ShiftLength(32), 
                 .CompareMask(0),
                 .ExpectedData(0),
                 .EnRegisterPresenceCheck(1), 
                 .ReturnTdo(ReturnTdo));

    endtask : body

endclass : SequenceLayer0



class SequenceLayer1 extends SequenceLayer0;

    function new(string name = "SequenceLayer1");
        super.new(name);
    endfunction : new

    `ovm_sequence_utils(SequenceLayer1, JtagBfmSequencer)

    virtual task body();
    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       BuildTapDataBase();
       Reset(2'b11);
       
       MultipleTapRegisterAccess(
          .ResetMode(NO_RST),
          .Address  (8'hAA),
          .Data     ('h0),
          .addr_len (8),
          .data_len (32));
    endtask : body

endclass : SequenceLayer1




//----------------------------------------------------------------------


class SequenceShadow_base extends JtagBfmSoCTapNwSequences;

    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;

    function new(string name = "SequenceShadow_base");
        super.new(name);
    endfunction : new

    `ovm_sequence_utils(SequenceShadow_base, JtagBfmSequencer)

    virtual task body();
       BuildTapDataBase();
       Reset(2'b11);
//       ShadowTap(STAP17);
//       TapAccess(STAP18, 8'hA0, 32'h1234, 0, 0, 0, 0, 1, ReturnTdo);

//       ShadowTap(STAP28);
//       TapAccess(STAP29, 8'hA0, 32'h1234, 0, 0, 0, 0, 1, ReturnTdo);

//       ShadowTap(STAP24);
//       TapAccess(STAP23, 8'hA0, 32'h1234, 0, 0, 0, 0, 1, ReturnTdo);

//       ShadowTap(STAP11);
//       TapAccess(STAP10, 8'hA0, 32'h1234, 0, 0, 0, 0, 1, ReturnTdo);

    endtask : body

endclass : SequenceShadow_base


class SequenceShadow #(parameter NUMBER_OF_SCENARIOS = 0,
                       parameter SCENARIO_SELECTED = 0,
                       parameter RUN_ONE_SCENARIO = 0) extends SequenceShadow_base;

    logic [NUMBER_OF_SCENARIOS:1] CompletedScenarios;
    logic [NUMBER_OF_SCENARIOS:0] SelectScenario;

    function new(string name = "SequenceShadow");
        super.new(name);
    endfunction : new

    `ovm_sequence_utils(SequenceShadow, JtagBfmSequencer)

    virtual task body();
       CompletedScenarios = 0;
       SelectScenario = 0;

       for (int i=1; i<(NUMBER_OF_SCENARIOS+1); i++) begin
          SelectScenario = i;
          if (RUN_ONE_SCENARIO == 1) begin
             SelectScenario = SCENARIO_SELECTED;
             i = NUMBER_OF_SCENARIOS;
          end
          if (SelectScenario == 1) begin
             super.body();
             ShadowTap(STAP17);
             TapAccess(STAP18, 8'hA0, 32'h1234, 0, 0, 0, 0, 1, ReturnTdo);
          end

          if (SelectScenario == 2) begin
             super.body();
             ShadowTap(STAP28);
             TapAccess(STAP29, 8'hA0, 32'h1234, 0, 0, 0, 0, 1, ReturnTdo);
          end

          if (SelectScenario == 3) begin
             super.body();
             ShadowTap(STAP23);
             TapAccess(STAP24, 8'hA0, 32'h1234, 0, 0, 0, 0, 1, ReturnTdo);
          end

          if (SelectScenario == 4) begin
             super.body();
             ShadowTap(STAP9);
             ShadowTap(STAP10);
             ShadowTap(STAP11);
             ShadowTap(STAP12);
             TapAccess(STAP13, 8'hA0, 32'h1234, 0, 0, 0, 0, 1, ReturnTdo);
          end

          if (SelectScenario == 5) begin
             super.body();
//             EnableTap(STAP9);
             ShadowTap(STAP10);
             ShadowTap(STAP11);
             ShadowTap(STAP12);
             TapAccess(STAP13, 8'hA0, 32'h1234, 0, 0, 0, 0, 1, ReturnTdo);
          end

          if (SelectScenario == 6) begin
             super.body();
             EnableTap(STAP3);
             ShadowTap(STAP4);
             TapAccess(STAP7, 8'hA0, 32'h1234, 0, 0, 0, 0, 1, ReturnTdo);
          end

          if (SelectScenario == 7) begin
             super.body();
             ShadowTap(STAP3);
             ShadowTap(STAP4);
             ShadowTap(STAP9);
             ShadowTap(STAP10);
             ShadowTap(STAP11);
             ShadowTap(STAP12);
             EnableTapForMultiAccess(STAP7);
             AddIrDrForMultiTapAccess(STAP7, 'hA0, 32'h1234, 32, 32'h0, 0, 0, 1, ReturnTdo);
             EnableTapForMultiAccess(STAP13);
             AddIrDrForMultiTapAccess(STAP13, 'hA0, 32'h5678, 32, 32'h0, 0, 0, 1, ReturnTdo);
             MultiTapAccessLaunchPrimary();
          end

          if (SelectScenario == 8) begin
             super.body();
             ShadowTap(STAP3);
             ShadowTap(STAP4);
             ShadowTap(STAP9);
             ShadowTap(STAP10);
             ShadowTap(STAP11);
             ShadowTap(STAP12);
             EnableTapForMultiAccess(STAP7);
             AddIrDrForMultiTapAccess(STAP7, 'hA0, 32'h1234, 32, 32'h0, 0, 0, 1, ReturnTdo);
             EnableTapForMultiAccess(STAP13);
             AddIrDrForMultiTapAccess(STAP13, 'hA0, 32'h5678, 32, 32'h0, 0, 0, 1, ReturnTdo);
             MultiTapAccessLaunchPrimary();

             TapAccessSlaveIdcode(STAP18);
          end

          if (SelectScenario == 9) begin
             super.body();
             ShadowTap(STAP3);
             ShadowTap(STAP4);
             ShadowTap(STAP7);
             ShadowTap(STAP2);
             ShadowTap(STAP9);
             ShadowTap(STAP10);
             ShadowTap(STAP11);
             ShadowTap(STAP12);
             TapAccess(STAP13, 8'hA0, 32'h56781234, 0, 0, 0, 0, 1, ReturnTdo);
          end

          if (SelectScenario == 10) begin
             super.body();
             ShadowTap(STAP2);
             TapAccess(STAP13, 8'hA0, 32'h56781234, 0, 0, 0, 0, 1, ReturnTdo);
             TapAccessSlaveIdcode(STAP2);
          end

          if (SelectScenario == 11) begin
             super.body();
             EnableTapForMultiAccess(STAP27);
             EnableTapForMultiAccess(STAP28);
             EnableTapForMultiAccess(STAP29);

             AddIrDrForMultiTapAccess(STAP27, 'h77, 37'h1234, 0, 0, 0, 0, 1, ReturnTdo);
             AddIrDrForMultiTapAccess(STAP28, 'h78, 38'h5678, 0, 0, 0, 0, 1, ReturnTdo);
             AddIrDrForMultiTapAccess(STAP29, 'h79, 39'h9012, 0, 0, 0, 0, 1, ReturnTdo);
             MultiTapAccessLaunchPrimary();
             ShadowTap(STAP27);
             ShadowTap(STAP28);
             TapAccess(STAP29, 8'hA0, 32'h12345678, 0, 0, 0, 0, 1, ReturnTdo);

             TapAccessRmw(STAP27, 8'h77, 32'h0, 0, 0, 0, 0, 1, ReturnTdo);
             if (ReturnTdo == 37'h1234) begin
                ovm_report_info("",$psprintf("Return TDO = %0h, check passed", ReturnTdo));
             end
             else begin
                ovm_report_error("",$psprintf("Return TDO = %0h, check failed", ReturnTdo));
             end  

             TapAccessRmw(STAP28, 8'h78, 32'h0, 0, 0, 0, 0, 1, ReturnTdo);
             if (ReturnTdo == 37'h5678) begin
                ovm_report_info("",$psprintf("Return TDO = %0h, check passed", ReturnTdo));
             end
             else begin
                ovm_report_error("",$psprintf("Return TDO = %0h, check failed", ReturnTdo));
             end

             TapAccessRmw(STAP29, 8'h79, 32'h0, 0, 0, 0, 0, 1, ReturnTdo);
             if (ReturnTdo == 37'h9012) begin
                ovm_report_info("",$psprintf("Return TDO = %0h, check passed", ReturnTdo));
             end
             else begin
                ovm_report_error("",$psprintf("Return TDO = %0h, check failed", ReturnTdo));
             end  
          end

          ovm_report_info("",$psprintf("CompletedScenarios = %0h, SelectScenario = %0h", CompletedScenarios, SelectScenario));
       end

    endtask : body

endclass : SequenceShadow


class TapSequenceFail_4 extends JtagBfmSoCTapNwSequences;

  JtagBfmSeqDrvPkt Packet;
  `ovm_sequence_utils(TapSequenceFail_4, JtagBfmSequencer)

  function new(string name = "TapSequenceFail_4");
    super.new(name);
	Packet = new;
  endfunction : new


  task body();

   logic [10000-1:0] ReturnTdo;

   ovm_report_info(get_type_name(),"Test run = TapSequenceFail_4!");
   $display("TEST: TapSequenceFail_4 sequence is started");

    BuildTapDataBase();

    //Powergood_Reset_b
    Reset(2'b11);

    //TRST
    Reset(2'b01);

		ovm_report_info(get_type_name(),"setting idvp sTAP to bypass mode");
		TapAccess(STAP21,8'hFF,7'b1010101,7,7'b0101000,7'hFF,1,0, ReturnTdo);
		DisableTap(STAP21);

		ovm_report_info(get_type_name(),"setting tap2iosfsb sTAP to bypass mode");
		TapAccess(STAP22,8'hFF,7'b1010101,7,7'b0101000,7'hFF,1,0, ReturnTdo);
		DisableTap(STAP22);

		ovm_report_info(get_type_name(),"setting dfd_tap sTAP to bypass mode");
		TapAccess(STAP23,8'hFF,7'b1010101,7,7'b0101000,7'hFF,1,0, ReturnTdo);
		DisableTap(STAP23);

		ovm_report_info(get_type_name(),"setting misc_tdo_retime sTAP to bypass mode");
		TapAccess(STAP24,8'hFF,7'b1010101,7,7'b0101000,7'hFF,1,0, ReturnTdo);
		DisableTap(STAP24);

  endtask

endclass : TapSequenceFail_4


class TapSequenceLessthan8IR extends JtagBfmSoCTapNwSequences;

  JtagBfmSeqDrvPkt Packet;
  `ovm_sequence_utils(TapSequenceLessthan8IR, JtagBfmSequencer)

  function new(string name = "TapSequenceLessthan8IR");
    super.new(name);
	Packet = new;
  endfunction : new


  task body();

   logic [10000-1:0] ReturnTdo;

   ovm_report_info(get_type_name(),"Test run = TapSequenceLessthan8IR!");
   $display("TEST: TapSequenceLessthan8IR sequence is started");

    BuildTapDataBase();

    //Powergood_Reset_b
    Reset(2'b11);

    //TRST
    Reset(2'b01);

    TapAccessCltapcIdcode(CLTAP);
    TapAccessSlaveIdcode(STAP18); 
    TapAccessSlaveIdcode(STAP29); 
  endtask

endclass : TapSequenceLessthan8IR

class TapSeqTwoOnSec extends JtagBfmSoCTapNwSequences;

  JtagBfmSeqDrvPkt Packet;
  `ovm_sequence_utils(TapSeqTwoOnSec, JtagBfmSequencer)

  function new(string name = "TapSeqTwoOnSec");
    super.new(name);
	Packet = new;
  endfunction : new


  task body();

   ovm_report_info(get_type_name(),"Test run = TapSeqTwoOnSec!");
   $display("TEST: TapSeqTwoOnSec sequence is started");

    PutTapOnSecondary(STAP1);
    PutTapOnSecondary(STAP1);
    PutTapOnSecondary(STAP29); 
    PutTapOnSecondary(STAP29); 
    PutTapOnSecondary(STAP27); 
    PutTapOnSecondary(STAP1);
    PutTapOnSecondary(STAP28); 
    TapAccessSlaveIdcode(STAP0);
    TapAccessSlaveIdcode(STAP25);
  endtask

endclass : TapSeqTwoOnSec

class TapSeqRepeatEnbDis extends JtagBfmSoCTapNwSequences;

  JtagBfmSeqDrvPkt Packet;
  `ovm_sequence_utils(TapSeqRepeatEnbDis, JtagBfmSequencer)

  function new(string name = "TapSeqRepeatEnbDis");
    super.new(name);
	Packet = new;
  endfunction : new


  task body();

   ovm_report_info(get_type_name(),"Test run = TapSeqRepeatEnbDis!");
   $display("TEST: TapSeqRepeatEnbDis sequence is started");

   //-----------
   $display("DEBUG_HANG_FROM_SEQ: B4 EnableTap STAP4");
   dump_history_table(STAP2);
   EnableTap(STAP4);
   $display("DEBUG_HANG_FROM_SEQ: After EnableTap STAP4");
   dump_history_table(STAP2);

   //-----------
   $display("DEBUG_HANG_FROM_SEQ: B4 TapAccessSlaveIdcode STAP4");
   dump_history_table(STAP2);
   TapAccessSlaveIdcode(STAP4);
   $display("DEBUG_HANG_FROM_SEQ: After TapAccessSlaveIdcode STAP4");
   dump_history_table(STAP2);

   //-----------
   $display("DEBUG_HANG_FROM_SEQ: B4 DisableTap STAP4");
   dump_history_table(STAP2);
   DisableTap(STAP4);
   $display("DEBUG_HANG_FROM_SEQ: After DisableTap STAP4");
   dump_history_table(STAP2);

   //-----------
   $display("1_DEBUG_HANG_FROM_SEQ: B4 DisableTap STAP2");
   dump_history_table(STAP2);
   DisableTap(STAP2);
   $display("1_DEBUG_HANG_FROM_SEQ: After DisableTap STAP2");
   dump_history_table(STAP2);

   //-----------
   $display("S1_p1_DEBUG_HANG_FROM_SEQ: B4 DisableTap STAP1");
   dump_history_table(STAP2);
   DisableTap(STAP1);
   $display("S1_p1_DEBUG_HANG_FROM_SEQ: After DisableTap STAP1");
   dump_history_table(STAP2);
   
   //-----------
   $display("DEBUG_HANG_FROM_SEQ: B4 EnableTap STAP25");
   dump_history_table(STAP2);
   EnableTap(STAP25);
   $display("DEBUG_HANG_FROM_SEQ: After EnableTap STAP25");
   dump_history_table(STAP2);

   //-----------
   $display("DEBUG_HANG_FROM_SEQ: B4 TapAccessSlaveIdcode STAP25");
   dump_history_table(STAP2);
   TapAccessSlaveIdcode(STAP25);
   $display("DEBUG_HANG_FROM_SEQ: After TapAccessSlaveIdcode STAP25");
   dump_history_table(STAP2);

   //-----------
   $display("DEBUG_HANG_FROM_SEQ: B4 DisableTap STAP25");
   dump_history_table(STAP2);
   DisableTap(STAP25);
   $display("DEBUG_HANG_FROM_SEQ: After DisableTap STAP25");
   dump_history_table(STAP2);

   //-----------
   $display("DEBUG_HANG_FROM_SEQ: B4 DisableTap STAP24");
   dump_history_table(STAP2);
   DisableTap(STAP24);
   $display("DEBUG_HANG_FROM_SEQ: After DisableTap STAP24");
   dump_history_table(STAP2);

   //-----------
   $display("DEBUG_HANG_FROM_SEQ: B4 DisableTap STAP20");
   dump_history_table(STAP2);
   DisableTap(STAP20);
   $display("DEBUG_HANG_FROM_SEQ: After DisableTap STAP20");
   dump_history_table(STAP2);
   
   //-----------
   $display("S1_p2_DEBUG_HANG_FROM_SEQ: B4 EnableTap STAP1");
   dump_history_table(STAP2);
   EnableTap(STAP1);
   $display("S1_p2_DEBUG_HANG_FROM_SEQ: After EnableTap STAP1");
   dump_history_table(STAP2);

   //-----------
   $display("2_DEBUG_HANG_FROM_SEQ: B4 EnableTap STAP2");
   dump_history_table(STAP2);
   EnableTap(STAP2);
   $display("2_DEBUG_HANG_FROM_SEQ: After EnableTap STAP2");
   dump_history_table(STAP2);

   TapAccessSlaveIdcode(STAP7);

  endtask

endclass : TapSeqRepeatEnbDis

class TapSeqRepeatEnbDis2 extends JtagBfmSoCTapNwSequences;

  JtagBfmSeqDrvPkt Packet;
  `ovm_sequence_utils(TapSeqRepeatEnbDis2, JtagBfmSequencer)

  function new(string name = "TapSeqRepeatEnbDis2");
    super.new(name);
	Packet = new;
  endfunction : new


  task body();

   ovm_report_info(get_type_name(),"Test run = TapSeqRepeatEnbDis2!");
   $display("TEST: TapSeqRepeatEnbDis2 sequence is started");

   EnableTap(STAP4);
   TapAccessSlaveIdcode(STAP5);
   DisableTap(STAP5);
   DisableTap(STAP4);
   DisableTap(STAP2);
   DisableTap(STAP1);

   EnableTap(STAP25);
   TapAccessSlaveIdcode(STAP25);
   DisableTap(STAP25);
   DisableTap(STAP24);
   DisableTap(STAP20);

   EnableTap(STAP1);
   EnableTap(STAP2);
   TapAccessSlaveIdcode(STAP7);

  endtask

endclass : TapSeqRepeatEnbDis2

class TapSeqIntermittentIdocde extends JtagBfmSoCTapNwSequences;

  JtagBfmSeqDrvPkt Packet;
  `ovm_sequence_utils(TapSeqIntermittentIdocde, JtagBfmSequencer)

  function new(string name = "TapSeqIntermittentIdocde");
    super.new(name);
	Packet = new;
  endfunction : new


  task body();

   ovm_report_info(get_type_name(),"Test run = TapSeqIntermittentIdocde!");
   $display("TEST: TapSeqIntermittentIdocde sequence is started");

   TapAccessCltapcIdcode(CLTAP);
   TapAccessSlaveIdcode(STAP0);
   TapAccessSlaveIdcode(STAP1);
   EnableTap(STAP20);
   TapAccessSlaveIdcode(STAP20);
   EnableTap(STAP27);
   TapAccessSlaveIdcode(STAP27);
   EnableTap(STAP28);
   TapAccessSlaveIdcode(STAP28);
   EnableTap(STAP29);
   TapAccessSlaveIdcode(STAP29);

  endtask

endclass : TapSeqIntermittentIdocde

/*
//----------------------------------------------------------
// Seqeunce Class containing the usage of BFM API's
class IP_level_TapSeq extends JtagBfmSoCTapNwSequences;
...
  task body();
   ...
   TapAccessSlaveIdcode(IP_STAP);
   ...
  endtask
...
endclass : IP_level_TapSeq

//----------------------------------------------------------
// Above class added to Env Pkg
package IP_EnvPkg; 
   ...
  `include "IP_level_TapSeq.svh"
   ...
endpackage

//----------------------------------------------------------
// Env lib exported thru ace ip_hdl.udf
   ...
   models => {
      ip_model => {
            export => {
                     libs => [ "ip_env_lib", "ip_rtl_lib" ],
                  },
   ...

//----------------------------------------------------------
// SoC imports and uses the IP lib in soc_hdl.udf   
   models => {
      soc_model => {
            import => {
                     libs => [ "ip_env_lib", "ip_rtl_lib" ],
                  },
   ...

//----------------------------------------------------------
// SoC adds IP to thier package
package Soc_EnvPkg; 
   ...
   import IP_EnvPkg::*;
   ...
endpackage

//----------------------------------------------------------
// SoC Sequence Class using containing an instance of IP seq
import Soc_EnvPkg::*;
class SoC_level_TapSeq extends JtagBfmSoCTapNwSequences;
...
  IP_level_TapSeq inst_IP_level_TapSeq = new();
  task body();
   ...
   inst_IP_level_TapSeq.start(SocEnv.inst_JtagBfmAgent.Sequencer);
   ...
  endtask
...
endclass : SoC_level_TapSeq
*/

class TapSeqEnRegPreChk extends JtagBfmSoCTapNwSequences;
 
    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSeqEnRegPreChk");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `ovm_sequence_utils(TapSeqEnRegPreChk, JtagBfmSequencer)
 
    virtual task body();

    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;

       //TapAccess(.Tap(STAP10), 
       //          .Opcode('h60), 
       //          .ShiftIn('1), 
       //          .ShiftLength(20), 
       //          .EnRegisterPresenceCheck(1), .EnUserDefinedShiftLength(0),
       //          .CompareMask('1),
       //          .ExpectedData({20{1'b0}}),
       //          .ReturnTdo(ReturnTdo));
       //$display("Debug_FortCollins_0 EnRegisterPresenceCheck=1 EnUserDefinedShiftLength=0 : ReturnTdo = %0h", ReturnTdo);

       //TapAccess(.Tap(STAP10), 
       //          .Opcode('h60), 
       //          .ShiftIn(20'h1_1111), 
       //          .ShiftLength(20), 
       //          .EnRegisterPresenceCheck(0), .EnUserDefinedShiftLength(0),
       //          .CompareMask('1),
       //          .ExpectedData({20{1'b1}}),
       //          .ReturnTdo(ReturnTdo));
       //$display("Debug_FortCollins_1 EnRegisterPresenceCheck=0 EnUserDefinedShiftLength=0 : ReturnTdo = %0h", ReturnTdo);

       //TapAccess(.Tap(STAP10), 
       //          .Opcode('h60), 
       //          .ShiftIn(20'h2_2222), 
       //          .ShiftLength(20), 
       //          .EnRegisterPresenceCheck(0), .EnUserDefinedShiftLength(1),
       //          .CompareMask('1),
       //          .ExpectedData(20'h1_1111),
       //          .ReturnTdo(ReturnTdo));
       //$display("Debug_FortCollins_2 EnRegisterPresenceCheck=0 EnUserDefinedShiftLength=1 : ReturnTdo = %0h", ReturnTdo);

       TapAccess(.Tap(STAP10), 
                 .Opcode('h60), 
                 .ShiftIn(20'hFFFFF), 
                 .ShiftLength(20), 
                 .EnRegisterPresenceCheck(1), .EnUserDefinedShiftLength(0),
                 //.EnRegisterPresenceCheck(0), .EnUserDefinedShiftLength(0),
                 //.EnRegisterPresenceCheck(1),
                 .CompareMask('1),
                 .ExpectedData(20'h0_0000),
                 .ReturnTdo(ReturnTdo));
       $display("Debug_FortCollins 3 EnRegisterPresenceCheck=1 EnUserDefinedShiftLength=0 : ReturnTdo = %0h", ReturnTdo);

       TapAccess(.Tap(STAP1), 
                 .Opcode('h0C), 
                 .ShiftIn('0), 
                 .ShiftLength(0), 
                 .EnRegisterPresenceCheck(1), .EnUserDefinedShiftLength(0),
                 .CompareMask('1),
                 .ExpectedData(32'hC0DE_0101),
                 .ReturnTdo(ReturnTdo));

       $display("Debug_FortCollins 4 SlvIdcode for STAP1 : ReturnTdo = %0h", ReturnTdo);

       TapAccessSlaveIdcode(STAP8);

       TapAccess(.Tap(STAP10), 
                 .Opcode('h60), 
                 .ShiftIn(20'hFFFFF), 
                 .ShiftLength(20), 
                 .EnRegisterPresenceCheck(1), .EnUserDefinedShiftLength(0),
                 .CompareMask('1),
                 .ExpectedData(20'hFFFFF),
                 .ReturnTdo(ReturnTdo));
       $display("Debug_FortCollins 5 EnRegisterPresenceCheck=1 EnUserDefinedShiftLength=1 : ReturnTdo = %0h", ReturnTdo);

       TapAccess(.Tap(STAP1), 
                 .Opcode('h51), 
                 .ShiftIn(11'h7FF), 
                 .ShiftLength(0), 
                 .EnRegisterPresenceCheck(1), .EnUserDefinedShiftLength(0),
                 .CompareMask('1),
                 .ExpectedData(11'h0),
                 .ReturnTdo(ReturnTdo));
       $display("Debug_FortCollins 6 EnRegisterPresenceCheck=1 EnUserDefinedShiftLength=1 : ReturnTdo = %0h", ReturnTdo);


       TapAccess(.Tap(STAP1), 
                 .Opcode('h51), 
                 .ShiftIn(11'h7FF), 
                 .ShiftLength(0), 
                 .EnRegisterPresenceCheck(1), .EnUserDefinedShiftLength(0),
                 .CompareMask('1),
                 .ExpectedData(11'h7FF),
                 .ReturnTdo(ReturnTdo));
       $display("Debug_FortCollins 7 EnRegisterPresenceCheck=1 EnUserDefinedShiftLength=1 : ReturnTdo = %0h", ReturnTdo);


    endtask : body 

endclass : TapSeqEnRegPreChk

class TapSeqAccess10Thrice extends JtagBfmSoCTapNwSequences;
 
    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSeqAccess10Thrice");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `ovm_sequence_utils(TapSeqAccess10Thrice, JtagBfmSequencer)
 
    virtual task body();

    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;


       EnableTap(STAP1);
       TapAccess(.Tap(STAP1), 
                 .Opcode('h10), .ShiftIn(2'b11), .ShiftLength(2), 
                 //.Opcode('hA0), .ShiftIn(32'h11111111), .ShiftLength(32), 
                 .EnRegisterPresenceCheck(1), .EnUserDefinedShiftLength(0),
                 .CompareMask('1),
                 .ExpectedData(2'b00),
                 .ReturnTdo(ReturnTdo));
       DisableTap(STAP1);

       EnableTap(STAP1);
       TapAccess(.Tap(STAP1), 
                 .Opcode('h10), .ShiftIn(2'b10), .ShiftLength(2), 
                 //.Opcode('hA0), .ShiftIn(32'h22222222), .ShiftLength(32), 
                 .EnRegisterPresenceCheck(1), .EnUserDefinedShiftLength(0),
                 .CompareMask('1),
                 .ExpectedData(2'b11),
                 //.ExpectedData(32'h11111111),
                 .ReturnTdo(ReturnTdo));
       DisableTap(STAP1);
       $display("Debug_TapSeqAccess10Thrice Point2");

       EnableTap(STAP1);
       TapAccess(.Tap(STAP1), 
                 .Opcode('h10), .ShiftIn(2'b01), .ShiftLength(2), 
                 //.Opcode('hA0), .ShiftIn(32'h33333333), .ShiftLength(32), 
                 .EnRegisterPresenceCheck(1), .EnUserDefinedShiftLength(0),
                 .CompareMask('1),
                 .ExpectedData(2'b10),
                 //.ExpectedData(32'h22222223),
                 .ReturnTdo(ReturnTdo));
       DisableTap(STAP1);
       $display("Debug_TapSeqAccess10Thrice Point3");

    endtask : body 

endclass : TapSeqAccess10Thrice

class TapSeqTracker extends JtagBfmSoCTapNwSequences;
 
    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSeqTracker");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `ovm_sequence_utils(TapSeqTracker, JtagBfmSequencer)
 
    virtual task body();

    logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;

       //EnableTap(STAP5);
       TapAccessSlaveIdcode(STAP20);
       TapAccessSlaveIdcode(STAP29);

    endtask : body 

endclass : TapSeqTracker

//---------------------------------------------------------------
class TapSeqTrackerSecCfg extends JtagBfmSoCTapNwSequences;
 
    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSeqTrackerSecCfg");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `ovm_sequence_utils(TapSeqTrackerSecCfg, JtagBfmSequencer)
 
    virtual task body();
       PutTapOnSecondary(STAP29);
       Goto(RUTI,5);
    endtask : body 

endclass : TapSeqTrackerSecCfg

class TapSeqTrackerSec extends JtagBfmSoCTapNwSequences;
 
    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSeqTrackerSec");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `ovm_sequence_utils(TapSeqTrackerSec, JtagBfmSequencer)
 
    virtual task body();
       Goto(RUTI,5);
       TapAccessSlaveIdcode(STAP29);
    endtask : body 

endclass : TapSeqTrackerSec
//---------------------------------------------------------------



