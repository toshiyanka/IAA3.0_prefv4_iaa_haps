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
//    FILENAME    : TapSequences.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : Sequences for the ENV 
//    DESCRIPTION : This Component defines various sequences that are 
//                  needed to drive and test the DUT including the Random
//------------------------------------------------------------------------
//------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------
// Sequence to do a Power Good and TRST_B resets 
//-----------------------------------------------------------------------------------------------
class TapSequenceReset extends JtagBfmSequences;

    // Packet fro Sequencer to Driver
    JtagBfmSeqDrvPkt Packet;
    
    // Register component with Factory
    function new(string name = "TapConfigure");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceReset) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(RST_PWRGUD);
        Reset(RST_HARD);
    endtask : body

endclass : TapSequenceReset
//-----------------------------------------------------------------------------------------------
// Sequence to do a TRST_B reset 
//-----------------------------------------------------------------------------------------------
class TapSequenceReset_b extends JtagBfmSequences;

    // Packet fro Sequencer to Driver
    JtagBfmSeqDrvPkt Packet;
    
    // Register component with Factory
    function new(string name = "TapSequenceReset_b");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceReset_b) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(RST_HARD);
    endtask : body

endclass : TapSequenceReset_b
//-----------------------------------------------------------------------------------------------
// Sequence to drive Single TAP
//-----------------------------------------------------------------------------------------------
class TapSequenceSingleTAP extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceSingleTAP");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceSingleTAP) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        MultipleTapRegisterAccess(RST_SOFT,8'hFF,32'h05AF_05AF,8,32);
        MultipleTapRegisterAccess(NO_RST,8'hFF,32'h05AF_05AF,8,32);
        MultipleTapRegisterAccess(NO_RST,8'h34,32'h05AF_05AF,8,32);
        MultipleTapRegisterAccess(NO_RST,8'h34,32'h05AF_05AF,8,32);
    endtask : body
endclass : TapSequenceSingleTAP
//-----------------------------------------------------------------------------------------------
// Sequence to drive TWO TAPs
//-----------------------------------------------------------------------------------------------
class TapSequence2TAPRegAccess extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequence2TAPRegAccess");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequence2TAPRegAccess) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        MultipleTapRegisterAccess(RST_SOFT,16'hFF_FF,32'h05AF_05AF,16,32);
        MultipleTapRegisterAccess(NO_RST,16'hFF_0C,64'h05AF_05AF_FAFA_FAFA,16,64);
        MultipleTapRegisterAccess(NO_RST,16'hFF_34,64'h05AF_05AF_FAFA_FAFA,16,64);
    endtask : body

endclass : TapSequence2TAPRegAccess
//-----------------------------------------------------------------------------------------------
// Sequence to drive FIVE TAPs
//-----------------------------------------------------------------------------------------------
class TapSequence5TapRegAccess extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequence5TapRegAccess");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequence5TapRegAccess) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        MultipleTapRegisterAccess(NO_RST,40'hFF_FF_FF_FF_FF,160'h05AF_05AF_05AF_05AF_05AF_05AF,40,160);
        MultipleTapRegisterAccess(NO_RST,40'h34_34_34_34_34,160'h05AF_05AF_05AF_05AF_05AF_05AF,40,160);
        MultipleTapRegisterAccess(NO_RST,40'h34_34_34_34_34,160'h05AF_05AF_05AF_05AF_05AF_05AF,40,160);
        MultipleTapRegisterAccess(NO_RST,40'h34_34_34_34_34,160'h05AF_05AF_05AF_05AF_05AF_05AF,40,160);
    endtask : body

endclass : TapSequence5TapRegAccess
//-----------------------------------------------------------------------------------------------
// Sequence to drive SEVEN TAPs
//-----------------------------------------------------------------------------------------------
class TapSequence7TapRegAccess extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequence7TapRegAccess");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequence7TapRegAccess) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        MultipleTapRegisterAccess(NO_RST,56'hFF_FF_FF_FF_FF_FF_FF,160'h05AF_05AF_05AF_05AF_05AF_05AF,56,160);
        MultipleTapRegisterAccess(NO_RST,56'hFF_0C_0C_0C_0C_0C_0C,192'h05AF_05AF_05AF_05AF_05AF_05AF,56,192);
        MultipleTapRegisterAccess(NO_RST,56'hFF_34_34_34_34_34_34,192'h05AF_05AF_05AF_05AF_05AF_05AF_05AF_05AF_05AF_05AF,56,192);
    endtask : body

endclass : TapSequence7TapRegAccess

//-----------------------------------------------------------------------------------------------
// Sequence to Override the Config using override register
//-----------------------------------------------------------------------------------------------
class TapSequenceNWp7ConfigOVR extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceNWp7ConfigOVR");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceNWp7ConfigOVR) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h12,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h0000,8,16);
        MultipleTapRegisterAccess(NO_RST,8'h12,16'hFFF5,8,16);
    endtask : body

endclass : TapSequenceNWp7ConfigOVR

//-----------------------------------------------------------------------------------------------
// To Configure the Misc set up with 2 sTAP in Sec and 2 sTAP in Pri, all WTAP are in Primary
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigure2sTAPPri2sTAPSecAllWTAPPri extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigure2sTAPPri2sTAPSecAllWTAPPri");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigure2sTAPPri2sTAPSecAllWTAPPri) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h12,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h5555,8,16);
    endtask : body

endclass : TapSequenceConfigure2sTAPPri2sTAPSecAllWTAPPri

//-----------------------------------------------------------------------------------------------
// To Configure the WTAP in Primary
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureWTAPPri extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureWTAPPri");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureWTAPPri) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h00,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h4411,8,16);
    endtask : body

endclass : TapSequenceConfigureWTAPPri

//-----------------------------------------------------------------------------------------------
// To Configure the WTAP in Secondary
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureWTAPSec extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureWTAPSec");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureWTAPSec) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'hA5,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h4411,8,16);
    endtask : body

endclass : TapSequenceConfigureWTAPSec

//-----------------------------------------------------------------------------------------------
// To Do register access to Read 4 TAP IDCODE
//-----------------------------------------------------------------------------------------------
class TapSequenceWTAPIDCODE extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceWTAPIDCODE");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceWTAPIDCODE) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        MultipleTapRegisterAccess(NO_RST,32'h0C_0C_0C_0C,128'h0000_0000_0000_0000_0000_0000_0000_0000,32,128);
    endtask : body

endclass : TapSequenceWTAPIDCODE

//-----------------------------------------------------------------------------------------------
// To Configure al sTAPs in Sec and all WTAP in Pri
//-----------------------------------------------------------------------------------------------

class TapSequenceConfigureAllSecNormal extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureAllSecNormal");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureAllSecNormal) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h1144,8,16);
    endtask : body

endclass : TapSequenceConfigureAllSecNormal

//-----------------------------------------------------------------------------------------------
// To have Register Access for all sTAPs in Sec and all WTAP in Pri
//-----------------------------------------------------------------------------------------------
class TapSequenceAllSecNormal extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceAllSecNormal");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceAllSecNormal) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        MultipleTapRegisterAccess(NO_RST,32'hFF_FF_FF_FF,128'h05AF_05AF_05AF_05AF,32,128);
        MultipleTapRegisterAccess(NO_RST,32'hFF_FF_FF_FF,128'h05AF_05AF_05AF_05AF,32,128);
        MultipleTapRegisterAccess(NO_RST,32'h34_34_34_34,128'h05AF_05AF_05AF_05AF,32,128);
        MultipleTapRegisterAccess(NO_RST,32'h34_34_34_34,128'h05AF_05AF_05AF_05AF,32,128);
        MultipleTapRegisterAccess(NO_RST,32'h34_34_34_34,128'h05AF_05AF_05AF_05AF,32,128);
    endtask : body

endclass : TapSequenceAllSecNormal

//-----------------------------------------------------------------------------------------------
// To Configure sTAP in Sec and Have Normal Decouple combination
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureAllSecNormalDecoupledC1 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureAllSecNormalDecoupledC1");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureAllSecNormalDecoupledC1) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        Goto(RUTI,10);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h0004,8,16);
        Goto(RUTI,10);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalDecoupledC1

//-----------------------------------------------------------------------------------------------
// To Configure sTAP in Sec and Have Normal Decouple combination
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureAllSecNormalDecoupledC2 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureAllSecNormalDecoupledC2");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureAllSecNormalDecoupledC2) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        Goto(RUTI,10);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h1000,8,16);
        Goto(RUTI,10);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalDecoupledC2

//-----------------------------------------------------------------------------------------------
// To Configure sTAP in Sec and Have Normal Decouple combination
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureAllSecNormalDecoupledC3 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureAllSecNormalDecoupledC3");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureAllSecNormalDecoupledC3) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        Goto(RUTI,10);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h0040,8,16);
        Goto(RUTI,10);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalDecoupledC3

//-----------------------------------------------------------------------------------------------
// To Configure sTAP in Sec and Have Normal Decouple combination
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureAllSecNormalDecoupledC4 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureAllSecNormalDecoupledC4");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureAllSecNormalDecoupledC4) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        Goto(RUTI,10);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h0100,8,16);
        Goto(RUTI,10);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalDecoupledC4

//-----------------------------------------------------------------------------------------------
// To Configure sTAP in Sec and Have Normal isolation combination
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureAllSecNormalShadowC1 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureAllSecNormalShadowC1");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureAllSecNormalShadowC1) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h33C4,8,16);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalShadowC1

//-----------------------------------------------------------------------------------------------
// To Configure sTAP in Sec and Have Normal isolation combination
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureAllSecNormalShadowC2 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureAllSecNormalShadowC2");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureAllSecNormalShadowC2) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h13CC,8,16);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalShadowC2

//-----------------------------------------------------------------------------------------------
// To Configure sTAP in Sec and Have Normal isolation combination
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureAllSecNormalShadowC3 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureAllSecNormalShadowC3");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureAllSecNormalShadowC3) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h334C,8,16);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalShadowC3

//-----------------------------------------------------------------------------------------------
// To Configure sTAP in Sec and Have Normal isolation combination
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureAllSecNormalShadowC4 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureAllSecNormalShadowC4");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureAllSecNormalShadowC4) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        //Reset(2'b11);
        Idle(30);
        ForceReset(2'b01,1'b0);
        Idle(30);
        ForceReset(2'b11,1'b1);
        Idle(30);
        ForceReset(2'b01,1'b1);
        Idle(30);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h31CC,8,16);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalShadowC4

//-----------------------------------------------------------------------------------------------
// To Configure sTAP in Sec and WTAP in Pri and have all TAPS in Normal
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureSTAPSecWTAPPri1 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureSTAPSecWTAPPri1");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureSTAPSecWTAPPri1) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        //Reset(2'b11);
        Idle(30);
        ForceReset(2'b01,1'b0);
        Idle(30);
        ForceReset(2'b01,1'b1);
        Idle(30);
        ForceReset(2'b11,1'b1);
        Idle(30);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h5555,8,16);
    endtask : body

endclass : TapSequenceConfigureSTAPSecWTAPPri1

//-----------------------------------------------------------------------------------------------
// To Configure sTAP in Sec and WTAP in Pri and have all TAPS in Normal
//-----------------------------------------------------------------------------------------------
class TapSequenceConfigureSTAPSecWTAPPri2 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureSTAPSecWTAPPri2");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureSTAPSecWTAPPri2) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        //Reset(2'b11);
        Idle(30);
        ForceReset(2'b01,1'b0);
        Idle(30);
        ForceReset(2'b01,1'b1);
        Idle(30);
        ForceReset(2'b11,1'b1);
        Idle(30);
        MultipleTapRegisterAccess(RST_HARD,8'h10,8'hA5,8,8);
        MultipleTapRegisterAccess(NO_RST,8'h11,16'h5555,8,16);
    endtask : body

endclass : TapSequenceConfigureSTAPSecWTAPPri2
//-----------------------------------------------------------------------------------
// ALL the Diffrent Combination on Modes and Address with all sTAP in Primary IF
//-----------------------------------------------------------------------------------
class TapSequencePrimaryOnly extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequencePrimaryOnly");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequencePrimaryOnly) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
      Idle(30);
      ForceReset(2'b11,1'b1);
      Idle(30);
      ForceReset(2'b01,1'b0);
      Idle(30);
      ForceReset(2'b01,1'b1);
      Idle(30);
      //ForceClockGatingOff(1'b1);
      //Reset(2'b11);
      //All In Primary
      MultipleTapRegisterAccess(RST_PWRGUD,8'h10,8'h00,8,8);

      //All Normal
      MultipleTapRegisterAccess(NO_RST,8'h11,16'h5555,8,16);
      //MultipleTapRegisterAccess(NO_RST,8'h14,1'b1,8,1);
      
      //All Bypass
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'h0000_0000_0000_0000,72,64);
      //ForceClockGatingOff(1'b0);
      Idle(3000);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,72,64);
      //ForceClockGatingOff(1'b0);
      Idle(3000);

      MultipleTapRegisterAccess(NO_RST,64'hFF_FF_FF_FF_FF_FF_FF_FF,64'h0000_0000_0000_0000,64,64);
      MultipleTapRegisterAccess(NO_RST,64'hFF_FF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,64,64);
      MultipleTapRegisterAccess(NO_RST,64'hFF_FF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,64,64);
      MultipleTapRegisterAccess(NO_RST,64'hFF_FF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,64,64);
      MultipleTapRegisterAccess(NO_RST,64'hFF_FF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,64,64);
      MultipleTapRegisterAccess(NO_RST,64'hFF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,64,64);
      MultipleTapRegisterAccess(NO_RST,64'hFF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,64,64);
      
      //All In Primary
      MultipleTapRegisterAccess(RST_PWRGUD,8'h10,8'h00,8,8);

      //All Normal
      MultipleTapRegisterAccess(NO_RST,8'h11,16'h5555,8,16);

      //All Bypass
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'h0000_0000_0000_0000,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);

      //All Register Access ADDR 34
      MultipleTapRegisterAccess(NO_RST,72'hFF_34_34_34_34_34_34_34_34,64'h0000_0000_0000_0000,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_34_34_34_34_34_34_34_34,64'h5555_5555_5555_5555,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_34_34_34_34_34_34_34_34,64'h5555_5555_5555_5555,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_34_34_34_34_34_34_34_34,64'hAAAA_AAAA_AAAA_AAAA,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_34_34_34_34_34_34_34_34,64'hAAAA_AAAA_AAAA_AAAA,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_34_34_34_34_34_34_34_34,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(NO_RST,72'hFF_34_34_34_34_34_34_34_34,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      //All Register Access ADDR Ax
      MultipleTapRegisterAccess(NO_RST,72'hFF_A1_A1_A2_A2_A3_A3_A4_A4,256'hF5FA_F5FA_F5FA_F5FA,72,256);
      MultipleTapRegisterAccess(NO_RST,72'hFF_A1_A1_A2_A2_A3_A3_A4_A4,256'hF5FA_F5FA_F5FA_F5FA,72,256);
      MultipleTapRegisterAccess(NO_RST,72'hFF_A1_A1_A2_A2_A3_A3_A4_A4,256'h5555_5555_5555_5555,72,256);
      MultipleTapRegisterAccess(NO_RST,72'hFF_A1_A1_A2_A2_A3_A3_A4_A4,256'h5555_5555_5555_5555,72,256);
      MultipleTapRegisterAccess(NO_RST,72'hFF_A1_A1_A2_A2_A3_A3_A4_A4,256'hAAAA_AAAA_AAAA_AAAA,72,256);
      MultipleTapRegisterAccess(NO_RST,72'hFF_A1_A1_A2_A2_A3_A3_A4_A4,256'hAAAA_AAAA_AAAA_AAAA,72,256);
      MultipleTapRegisterAccess(NO_RST,72'hFF_A1_A1_A2_A2_A3_A3_A4_A4,256'hFFFF_FFFF_FFFF_FFFF,72,256);
      MultipleTapRegisterAccess(NO_RST,72'hFF_A1_A1_A2_A2_A3_A3_A4_A4,256'hFFFF_FFFF_FFFF_FFFF,72,256);
      //All Register Access ADDR Ax
      MultipleTapRegisterAccess(NO_RST,72'hFF_0C_0C_0C_0C_0C_0C_0C_0C,288'h0000_0000_0000_0000,72,288);

    ////Normal Decoupled Combinations
    ////1 in Decoupled
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5554,8,16);
      MultipleTapRegisterAccess(NO_RST,64'hFF_34_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,64,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5551,8,16);
      MultipleTapRegisterAccess(NO_RST,64'hFF_34_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,64,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5545,8,16);
      MultipleTapRegisterAccess(NO_RST,64'hFF_34_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,64,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5515,8,16);
      MultipleTapRegisterAccess(NO_RST,64'hFF_34_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,64,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5455,8,16);
      MultipleTapRegisterAccess(NO_RST,64'hFF_34_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,64,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5155,8,16);
      MultipleTapRegisterAccess(NO_RST,64'hFF_34_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,64,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h4555,8,16);
      MultipleTapRegisterAccess(NO_RST,64'hFF_34_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,64,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h1555,8,16);
      MultipleTapRegisterAccess(NO_RST,64'hFF_34_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,64,72);
    ////2 in Decoupled
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5550,8,16);
      MultipleTapRegisterAccess(NO_RST,56'hFF_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,56,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5505,8,16);
      MultipleTapRegisterAccess(NO_RST,56'hFF_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,56,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5511,8,16);
      MultipleTapRegisterAccess(NO_RST,56'hFF_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,56,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5544,8,16);
      MultipleTapRegisterAccess(NO_RST,56'hFF_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,56,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5055,8,16);
      MultipleTapRegisterAccess(NO_RST,56'hFF_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,56,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h0555,8,16);
      MultipleTapRegisterAccess(NO_RST,56'hFF_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,56,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h1155,8,16);
      MultipleTapRegisterAccess(NO_RST,56'hFF_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,56,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h4455,8,16);
      MultipleTapRegisterAccess(NO_RST,56'hFF_34_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,56,72);
    ////3 in Decoupled
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5510,8,16);
      MultipleTapRegisterAccess(NO_RST,48'hFF_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,48,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5501,8,16);
      MultipleTapRegisterAccess(NO_RST,48'hFF_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,48,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5540,8,16);
      MultipleTapRegisterAccess(NO_RST,48'hFF_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,48,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5504,8,16);
      MultipleTapRegisterAccess(NO_RST,48'hFF_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,48,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h1055,8,16);
      MultipleTapRegisterAccess(NO_RST,48'hFF_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,48,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h0155,8,16);
      MultipleTapRegisterAccess(NO_RST,48'hFF_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,48,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h0455,8,16);
      MultipleTapRegisterAccess(NO_RST,48'hFF_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,48,72);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h4055,8,16);
      MultipleTapRegisterAccess(NO_RST,48'hFF_34_34_34_34_34,72'hA5A5_F0F0_A5A5_F0F0_5A,48,72);

    ////Normal Excluded Combinations
    ////1 in Excluded
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5556,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5559,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5565,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5595,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5655,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5955,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h6565,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h9555,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);

    ////2 Excluded 
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h555A,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5566,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5599,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h55A5,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h5A55,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h6655,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h9955,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'hA555,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
 
    ////3 Excluded
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h556A,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h559A,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h6A55,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h9A55,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h556A,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h6A55,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'hA655,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h55A6,8,16);
      MultipleTapRegisterAccess(NO_RST,72'hFF_FF_FF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,72,64);

    ////Normal Excluded Decoupled combination  
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h4619,8,16);
      MultipleTapRegisterAccess(NO_RST,56'hFF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,56,64);

    ////Normal Shadow combination  
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'hFFFD,8,16);
      MultipleTapRegisterAccess(NO_RST,16'hFF_FF,32'hFFFF_FFFF,16,32);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'hFFF7,8,16);
      MultipleTapRegisterAccess(NO_RST,16'hFF_FF,32'hFFFF_FFFF,16,32);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'hFFDF,8,16);
      MultipleTapRegisterAccess(NO_RST,16'hFF_FF,32'hFFFF_FFFF,16,32);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'hFF7F,8,16);
      MultipleTapRegisterAccess(NO_RST,16'hFF_FF,32'hFFFF_FFFF,16,32);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'hFDFF,8,16);
      MultipleTapRegisterAccess(NO_RST,16'hFF_FF,32'hFFFF_FFFF,16,32);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'hF7FF,8,16);
      MultipleTapRegisterAccess(NO_RST,16'hFF_FF,32'hFFFF_FFFF,16,32);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'hDFFF,8,16);
      MultipleTapRegisterAccess(NO_RST,16'hFF_FF,32'hFFFF_FFFF,16,32);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h7FFF,8,16);
      MultipleTapRegisterAccess(NO_RST,16'hFF_FF,32'hFFFF_FFFF,16,32);
      MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h7FFF,8,16);

      LoadIR_idle(NO_RST,16'hFF_FF,16'h01_01,16'hFFFF,16);
      //Goto(RUTI,1);
      LoadDR_idle(NO_RST,32'h0123_4567,32'h048D_159C,32'hFFFF_FFFF,32);
      //Goto(RUTI,1);
      LoadIR(NO_RST,16'h0F_0F,16'h01_01,16'hFFFF,16);
      Goto(ST_E2IR,1);
      tms_tdi_stream(22'h3E0000,22'h0,22);
      ExpData_MultipleTapRegisterAccess(RST_PWRGUD,8'h11,8,16'hFFFD,16'h0000,16'hFFFF,16);
      Goto(RUTI,1);
      ExpData_MultipleTapRegisterAccess(NO_RST,16'hFF_FF,16,{(250){32'hFFFF_FFFF}},{{(249){32'hFFFF_FFFF}},{32'hFFFF_FFFC}},{(250){32'hFFFF_FFFF}},250*32);
      
      Idle(1000);

    endtask : body

endclass : TapSequencePrimaryOnly

//-----------------------------------------------------------------------------------
// This sequence incorporates the commands for the various feature requets.
//-----------------------------------------------------------------------------------
class TapSequenceTry extends JtagBfmSequences;
 
    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceTry");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `uvm_object_utils(TapSequenceTry) 
 
    `uvm_declare_p_sequencer(JtagBfmSequencer)
 
    virtual task body();
        // local variables
        logic [TOTAL_DATA_REGISTER_WIDTH-1:0] tdodata;

        //----------------------------------------------------
        // Verify Tap Goto Task works in a for loop
        //----------------------------------------------------
          //---This does not keep the FSM in RUTI for 2 cycles. 
          Reset(2'b11);
          
          Goto(TLRS,1);
          uvm_report_info("TRIAL",$psprintf("TC1 "),UVM_LOW);
          Goto(RUTI,1);
          Goto(RUTI,1);
          uvm_report_info("TRIAL",$psprintf("TC2 "),UVM_LOW);
          Goto(TLRS,1);
          uvm_report_info("TRIAL",$psprintf("TC3 "),UVM_LOW);
          #100ns;

          //---This does not give 30 TCK cycles. 
          Reset(2'b11);
          for (int i=0; i<30; i++) begin
              Goto(RUTI,1);
          end
          Goto(TLRS,1);

          //---This gives 30 TCK cycles. 
          Reset(2'b11);
          for (int i=0; i<30; i++) begin
              Goto(RUTI,1);
              ForceClockGatingOff(HIGH);
              Idle(1);
              ForceClockGatingOff(LOW);
          end
          Goto(TLRS,1);

          //---This also works like above. 
          ForceClockGatingOff(HIGH); // TCK will resume toggling
          Reset(2'b11);
          Goto(RUTI,1);
          for (int i=0; i<30; i++) begin
              Idle(1);
          end
          Goto(TLRS,1);
          ForceClockGatingOff(LOW); // TCK will remain OFF after Task execution
          #500ns;
          
        //----------------------------------------------------
        // Verify that ForceClockGatingOff task is working
        //----------------------------------------------------
         Idle(30);
         ForceReset(2'b11,1'b1);
         Goto(RUTI,100);
         ForceClockGatingOff(LOW); // TCK is not toggling
         Goto(RUTI,100);
         #1000ns;
         ForceClockGatingOff(HIGH); // TCK will resume toggling
 
        //----------------------------------------------------
        // To verify 16-bit counter in Goto command. 
        //----------------------------------------------------
         Goto(ST_TLRS,20);
         Goto(ST_RUTI,20);
         Goto(ST_SDRS,20);
         Goto(ST_SIRS,20);
         Goto(ST_TLRS,10000);
         Goto(ST_RUTI,10000);
 
        //----------------------------------------------------
        // To check the FSM travesal states for this task
        //----------------------------------------------------
         ExpData_MultipleTapRegisterAccess(RST_PWRGUD,8'h11,8,16'hFFFD,16'h0000,16'hFFFF,16);
         Goto(RUTI,1);
         LoadIR(RST_PWRGUD,'h02,08'h01,8'hFF,8);
         Goto(RUTI,1);
 
        //----------------------------------------------------
        // To check the new LoadIR_idle task. This ends in RUTI without going thru PAIR.
        //----------------------------------------------------
         MultipleTapRegisterAccess(RST_PWRGUD,8'h11,16'h0001,8,16);
         LoadIR_idle(NO_RST,16'hFF_FF,16'h01_01,16'hFFFF,16);
 
        //----------------------------------------------------
        // To check the new LoadDR_idle task. This ends in RUTI without going thru PADR.
        //----------------------------------------------------
         LoadDR_idle(NO_RST,32'h0123_4567,32'h048D_159C,32'hFFFF_FFFF,32);
       
        //----------------------------------------------------
        // To check the tdodata returned into this variable
        //----------------------------------------------------
         ExpData_MultipleTapRegisterAccess(RST_PWRGUD,8'h11,8,16'hFFFD,16'h0000,16'hFFFF,16);
         Goto(RUTI,1);
                                                                           //GoesInside   //ComesOut     //Mask   
         //        ExpData_MultipleTapRegisterAccess(NO_RST, 16'hFF_FF, 16, 32'hFFFF_FFFF, 32'hFFFF_FFFC, 32'hFFFF_FFFF, 32);
         ReturnTDO_ExpData_MultipleTapRegisterAccess(NO_RST, 16'hFF_FF, 16, 32'hFFFF_FFFF, 32'hFFFF_FFFC, 32'hFFFF_FFFF, 32, tdodata); Goto(UPDR,1); Goto(RUTI,11);
         $display("tdodata got: %0h, tdodata expected: 32'hFFFF_FFFC", tdodata);
         #1000ns;

        //----------------------------------------------------
        // Async Remote TDR API
        //----------------------------------------------------
        //Access External TDR0 in async mode
        LoadIR(NO_RST, 16'hFFFF, 16'h0001, 16'h0000, 16); Goto(UPIR,1); Goto(RUTI,11);
        LoadDR_Pause(NO_RST, 32'h1111_1111, 32'hABCD_EF98, 32'h0000_0000, 32, 5); Goto(UPDR,1); Goto(RUTI,11);

        //----------------------------------------------------
        // Fix for count in Goto for HSD 2904968 
        //----------------------------------------------------
        $display("Executing Goto(SHDR, 80000)");
        Goto(SHDR,80000);
        Goto(TLRS,10);

// LoadDR_E1DR, LoadIR_E1IR -- https://hsdes.intel.com/home/default.html/article?id=1018012221 
       Reset(2'b11); 
       LoadIR_E1IR(2'b00, 8'hA0, 8);
       LoadDR_E1DR(2'b00, 32'h1111_1111, 32'h0, 32'hFFFF_FFFF, 32);
       Goto(RUTI,1);
       LoadDR_E1DR(2'b00, 32'h2222_2222, 32'h1111_1111, 32'hFFFF_FFFF, 32);
       Goto(RUTI,1);

    endtask : body 

endclass : TapSequenceTry

//^^^^^^^^^^^^^^^^^^_______________^^^^^^^^^^^^^^^^^
//   TAP                                ROCKS
//vvvvvvvvvvvvvvvvvv---------------vvvvvvvvvvvvvvvvv
class SoCTapNwBuildTapDataBaseSeq extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "SoCTapNwBuildTapDataBaseSeq");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(SoCTapNwBuildTapDataBaseSeq) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();

       BuildTapDataBase();

    endtask : body
endclass : SoCTapNwBuildTapDataBaseSeq

//---------------------------------------------------------------
// Added 27Mar14 for matching ITPP opcode on Tester
// LoadDR_E1DR, LoadIR_E1IR -- https://hsdes.intel.com/home/default.html/article?id=1018012221 
//---------------------------------------------------------------
class TapSeqLoadIRDR_E1 extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSeqLoadIRDR_E1");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `uvm_object_utils(TapSeqLoadIRDR_E1) 
 
    `uvm_declare_p_sequencer(JtagBfmSequencer)
 
    virtual task body();

       LoadIR_E1IR(2'b00, 8'hA0, 8);
       LoadDR_E1DR(2'b00, 32'h1111_1111, 32'h0, 32'hFFFF_FFFF, 32);
       Goto(RUTI,1);
       LoadDR_E1DR(2'b00, 32'h2222_2222, 32'h1111_1111, 32'hFFFF_FFFF, 32);
       Goto(RUTI,1);

    endtask : body 

endclass : TapSeqLoadIRDR_E1

//--------------------------------------------------------------
// 19-Nov-2014 tms_tdi_stream missing clock issue
// https://hsdes.intel.com/home/default.html#article?id=1603916954
//--------------------------------------------------------------

class TapSeqTmsTdiStrmTry extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSeqTmsTdiStrmTry");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSeqTmsTdiStrmTry) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
       Reset(RST_HARD);  // In TLRS
       //tms_tdi_stream(1'b0,1'b0,1); // Move to RUTI
       //tms_tdi_stream(2'b10,2'b0,2);  // Move to SDRS
       tms_tdi_stream(3'b110,3'b0,3);  // Move to SIRS
       //tms_tdi_stream(6'b011010,6'b0,6);
    endtask : body

endclass : TapSeqTmsTdiStrmTry

//-----------------------------------------------------------------------------------------------------
// 05-Mar-2015: Added for displaying the bits in log file based on corresponding mask_capture inputs
// PCR_TITLE: Jtag BFM - Request for new ExpDataorCapData_MultipleTapRegisterAccess
// PCR_NO: https://hsdes.intel.com/home/default.html#article?id=1205378989 
//-----------------------------------------------------------------------------------------------------
class TapSeqCTVReturnTDO extends JtagBfmSequences;

    logic [TOTAL_DATA_REGISTER_WIDTH-1:0] tdodata;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSeqCTVReturnTDO");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `uvm_object_utils(TapSeqCTVReturnTDO) 
 
    `uvm_declare_p_sequencer(JtagBfmSequencer)
 
    virtual task body();

       CTV_ReturnTDO_ExpData_MultipleTapRegisterAccess( 
                .ResetMode(2'b00),
                .Address(8'hA0),
                .addr_len(8),
                .Data(32'hAAAAAAAA),
                .Expected_Data('b0),
                .Mask_Data(32'hFFFFFFFF),
                .Mask_Capture(32'h000F0000),
                .data_len(32),
                .tdo_data(tdodata));
       
       Goto(UPDR,1); Goto(RUTI,11);
       $display("tdodata got: %0h", tdodata);
       #100ns;

       CTV_ReturnTDO_ExpData_MultipleTapRegisterAccess( 
                .ResetMode(2'b00),
                .Address(8'hA0),
                .addr_len(8),
                .Data(32'h55555555),
                .Expected_Data(32'hAAAAAAAA),
                .Mask_Data(32'hFFFFFFFF),
                .Mask_Capture(32'h000000F0),
                .data_len(32),
                .tdo_data(tdodata));
       
       Goto(UPDR,1); Goto(RUTI,11);
       $display("tdodata got: %0h", tdodata);
       #100ns;
       

    endtask : body 

endclass : TapSeqCTVReturnTDO

class TapSeqRtdr extends JtagBfmSequences;

    logic [TOTAL_DATA_REGISTER_WIDTH-1:0] tdodata;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSeqRtdr");
        super.new(name);
        Packet = new;
    endfunction : new
 
    `uvm_object_utils(TapSeqRtdr) 
 
    `uvm_declare_p_sequencer(JtagBfmSequencer)
 
    virtual task body();
      
    Reset(RST_PWRGUD);
    LoadIR(RST_PWRGUD,'h3,'b0,16'h0000,8);
    LoadDR(NO_RST,32'hAAAAAAAA,32'h00000000,32'hFFFFFFFF,32);
    LoadDR(NO_RST,32'h55555555,32'hAAAAAAAA,32'hFFFFFFFF,32);
    LoadDR(NO_RST,32'hBBBBBBBB,32'h55555555,32'hFFFFFFFF,32);
    Reset(2'b01);
    LoadIR(RST_PWRGUD,'h3,'b0,16'h0000,8);
    LoadDR(NO_RST,32'hAAAAAAAA,32'h00000000,32'hFFFFFFFF,32);
    LoadDR(NO_RST,32'h55555555,32'hAAAAAAAA,32'hFFFFFFFF,32);
    LoadDR(NO_RST,32'hBBBBBBBB,32'h55555555,32'hFFFFFFFF,32);
    LoadIR(RST_PWRGUD,'h4,'b0,16'h0000,8);
    LoadDR(NO_RST,32'hAAAAAAAA,32'h00000000,32'hFFFFFFFF,32);
    LoadDR(NO_RST,32'h55555555,32'hAAAAAAAA,32'hFFFFFFFF,32);
    LoadDR(NO_RST,32'hBBBBBBBB,32'h55555555,32'hFFFFFFFF,32);
    Reset(2'b10);
    LoadIR(NO_RST,'h4,'b0,16'h0000,8);
    LoadDR(NO_RST,32'hAAAAAAAA,32'hBBBBBBBB,32'hFFFFFFFF,32);
    LoadDR(NO_RST,32'h55555555,32'hAAAAAAAA,32'hFFFFFFFF,32);
    LoadDR(NO_RST,32'hBBBBBBBB,32'h55555555,32'hFFFFFFFF,32);


    endtask : body 

endclass : TapSeqRtdr

