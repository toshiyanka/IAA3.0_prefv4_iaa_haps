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
        Reset(2'b11);
        Reset(2'b01);
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

class TapSequenceConfigure extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapConfigure");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigure) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(2'b01,8'h10,1'h1,8,1);
        MultipleTapRegisterAccess(2'b00,8'h11,2'h3,8,2);
    endtask : body

endclass : TapSequenceConfigure

class TapSequence3TapBypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequence3TapBypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequence3TapBypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_FF,32'h0000_FFFF,24,32);
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_FF,32'h0000_FFFF,24,32);
    endtask : body

endclass : TapSequence3TapBypass

class TapSequence2TapBypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequence2TapBypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequence2TapBypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        MultipleTapRegisterAccess(2'b00,16'hFF_FF,32'h0000_FFFF,16,32);
        MultipleTapRegisterAccess(2'b00,16'hFF_FF,32'h0000_FFFF,16,32);
    endtask : body

endclass : TapSequence2TapBypass

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
        MultipleTapRegisterAccess(2'b01,8'h10,1'h1,8,1);
        MultipleTapRegisterAccess(2'b00,8'h11,2'b01,8,2);
    endtask : body

endclass : TapSequenceConfigureAllSecNormal

class TapSequenceAllSecNormal extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceAllSecNormal");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceAllSecNormal) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        MultipleTapRegisterAccess(2'b00,8'hFF,32'h05AF_05AF,8,32);
        MultipleTapRegisterAccess(2'b00,8'hFF,32'h05AF_05AF,8,32);
        MultipleTapRegisterAccess(2'b00,8'hA1,32'h05AF_05AF,8,32);
        MultipleTapRegisterAccess(2'b00,8'h34,32'h05AF_05AF,8,32);
    endtask : body

endclass : TapSequenceAllSecNormal

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
        MultipleTapRegisterAccess(2'b01,8'h10,1'h1,8,1);
        MultipleTapRegisterAccess(2'b00,8'h11,2'h0,8,2);
        Goto(RUTI,10);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalDecoupledC1

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
        MultipleTapRegisterAccess(2'b01,8'h10,1'h1,8,1);
        MultipleTapRegisterAccess(2'b00,8'h11,2'h0,8,2);
        Goto(RUTI,10);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalDecoupledC2

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
        MultipleTapRegisterAccess(2'b01,8'h10,1'h1,8,1);
        MultipleTapRegisterAccess(2'b00,8'h11,2'h0,8,2);
        Goto(RUTI,10);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalDecoupledC3

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
        MultipleTapRegisterAccess(2'b01,8'h10,1'h1,8,1);
        MultipleTapRegisterAccess(2'b00,8'h11,2'h0,8,2);
        Goto(RUTI,10);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalDecoupledC4

class TapSequenceSingleTAP extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceSingleTAP");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceSingleTAP) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        MultipleTapRegisterAccess(2'b10,8'hFF,32'h05AF_05AF,8,32);
        MultipleTapRegisterAccess(2'b00,8'h34,32'h05AF_05AF,8,32);
        MultipleTapRegisterAccess(2'b00,8'hA1,32'h05AF_05AF,8,32);
    endtask : body

endclass : TapSequenceSingleTAP


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
        MultipleTapRegisterAccess(NO_RST,16'h0C_0C,64'h05AF_05AF_FAFA_FAFA,16,64);
        MultipleTapRegisterAccess(NO_RST,16'h34_34,64'h05AF_05AF_FAFA_FAFA,16,64);
    endtask : body

endclass : TapSequence2TAPRegAccess


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
        MultipleTapRegisterAccess(NO_RST,32'h0C_0C_0C_0C,128'h0000_0000_0000_0000_0000_0000_0000_0000,40,128);
    endtask : body

endclass : TapSequenceWTAPIDCODE

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
        MultipleTapRegisterAccess(2'b01,8'h10,1'h1,8,1);
        MultipleTapRegisterAccess(2'b00,8'h11,2'h0,8,2);
        MultipleTapRegisterAccess(2'b01,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(2'b00,8'h11,16'h33C4,8,16);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalShadowC1

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
        MultipleTapRegisterAccess(2'b01,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(2'b00,8'h11,16'h13CC,8,16);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalShadowC2

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
        MultipleTapRegisterAccess(2'b01,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(2'b00,8'h11,16'h334C,8,16);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalShadowC3

class TapSequenceConfigureAllSecNormalShadowC4 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureAllSecNormalShadowC4");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureAllSecNormalShadowC4) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(2'b01,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(2'b00,8'h11,16'h31CC,8,16);
    endtask : body

endclass : TapSequenceConfigureAllSecNormalShadowC4


class TapSequenceConfigureSTAPSecWTAPPri1 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureSTAPSecWTAPPri1");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureSTAPSecWTAPPri1) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(2'b01,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(2'b00,8'h11,16'h5555,8,16);
    endtask : body

endclass : TapSequenceConfigureSTAPSecWTAPPri1

class TapSequenceConfigureSTAPSecWTAPPri2 extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceConfigureSTAPSecWTAPPri2");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceConfigureSTAPSecWTAPPri2) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        MultipleTapRegisterAccess(2'b01,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(2'b00,8'h11,16'h5555,8,16);
    endtask : body

endclass : TapSequenceConfigureSTAPSecWTAPPri2

class TapSequence5TapRegAccess extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequence5TapRegAccess");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequence5TapRegAccess) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        MultipleTapRegisterAccess(2'b00,40'hFF_FF_FF_FF_FF,160'h05AF_05AF_05AF_05AF_05AF_05AF,40,160);
        MultipleTapRegisterAccess(2'b00,40'hFF_FF_FF_FF_FF,160'h05AF_05AF_05AF_05AF_05AF_05AF,40,160);
        MultipleTapRegisterAccess(2'b00,40'h34_34_34_34_34,160'h05AF_05AF_05AF_05AF_05AF_05AF,40,160);
        MultipleTapRegisterAccess(2'b00,40'h34_34_34_34_34,160'h05AF_05AF_05AF_05AF_05AF_05AF,40,160);
        MultipleTapRegisterAccess(2'b00,40'h34_34_34_34_34,160'h05AF_05AF_05AF_05AF_05AF_05AF,40,160);
    endtask : body

endclass : TapSequence5TapRegAccess
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
        Reset(2'b11);
        //All In Primary
        MultipleTapRegisterAccess(2'b11,8'h10,1'h0,8,1);

        //All Normal
      MultipleTapRegisterAccess(2'b00,8'h11,2'b01,8,2);

      //Remove Bit Assertion
      MultipleTapRegisterAccess(NO_RST,8'h14,1'b1,8,1);
          //sTAP on Bypass with mTAP Removed 
          MultipleTapRegisterAccess(NO_RST,8'hFF,32'h0000_0000,8,32);
          MultipleTapRegisterAccess(NO_RST,8'hFF,32'h5555_5555,8,32);
          MultipleTapRegisterAccess(NO_RST,8'hFF,32'hAAAA_AAAA,8,32);
          MultipleTapRegisterAccess(NO_RST,8'hFF,32'hFFFF_FFFF,8,32);
          //sTAP Data Register 34 Access with mTAP Removed 
          MultipleTapRegisterAccess(NO_RST,8'h34,32'h0000_0000,8,32);
          MultipleTapRegisterAccess(NO_RST,8'h34,32'h5555_5555,8,32);
          MultipleTapRegisterAccess(NO_RST,8'h34,32'hAAAA_AAAA,8,32);
          MultipleTapRegisterAccess(NO_RST,8'h34,32'hFFFF_FFFF,8,32);
          //sTAP Data Register A1 Access with mTAP Removed 
          MultipleTapRegisterAccess(NO_RST,8'hA1,32'h0000_0000,8,32);
          MultipleTapRegisterAccess(NO_RST,8'hA1,32'h5555_5555,8,32);
          MultipleTapRegisterAccess(NO_RST,8'hA1,32'hAAAA_AAAA,8,32);
          MultipleTapRegisterAccess(NO_RST,8'hA1,32'hFFFF_FFFF,8,32);
          //sTAP SLVIDCODE Access with mTAP Removed 
          MultipleTapRegisterAccess(NO_RST,8'h0C,32'h0000_0000,8,32);

      // De-Assert the Remove Bit and Re Configure the mTAP    
      Reset(2'b11);
      //All In Primary
      MultipleTapRegisterAccess(2'b11,8'h10,1'h0,8,1);

      //All Normal
      MultipleTapRegisterAccess(2'b00,8'h11,2'b01,8,2);

      //All Bypass
      MultipleTapRegisterAccess(2'b00,16'hFF_FF,32'h0000_0000,16,32);
      MultipleTapRegisterAccess(2'b00,16'hFF_FF,32'h5555_5555,16,32);
      MultipleTapRegisterAccess(2'b00,16'hFF_FF,32'hAAAA_AAAA,16,32);
      MultipleTapRegisterAccess(2'b00,16'hFF_FF,32'hFFFF_FFFF,16,32);
      //All Register Access ADDR 34
      MultipleTapRegisterAccess(2'b00,16'hFF_34,32'h0000_0000,16,32);
      MultipleTapRegisterAccess(2'b00,16'hFF_34,32'h5555_5555,16,32);
      MultipleTapRegisterAccess(2'b00,16'hFF_34,32'hAAAA_AAAA,16,32);
      MultipleTapRegisterAccess(2'b00,16'hFF_34,32'hFFFF_FFFF,16,32);
      //All Register Access ADDR Ax
      MultipleTapRegisterAccess(2'b00,16'hFF_A1,32'hF5FA_F5FA,16,32);
      MultipleTapRegisterAccess(2'b00,16'hFF_A1,32'hF5FA_F5FA,16,32);
      MultipleTapRegisterAccess(2'b00,16'hFF_A1,32'h5555_5555,16,32);
      MultipleTapRegisterAccess(2'b00,16'hFF_A1,32'hAAAA_AAAA,16,32);
      MultipleTapRegisterAccess(2'b00,16'hFF_A1,32'hFFFF_FFFF,16,32);
      //All Register Access ADDR Ax
      MultipleTapRegisterAccess(2'b00,16'hFF_0C,32'h0000_0000,16,32);

    ////Normal Decoupled Combinations
    ////1 in Decoupled
      MultipleTapRegisterAccess(2'b11,8'h11,2'b00,8,2);
      MultipleTapRegisterAccess(2'b00,8'hFF,72'hA5A5_F0F0_A5A5_F0F0_5A,8,72);

    ////Normal Excluded Combinations
    ////1 in Excluded
      MultipleTapRegisterAccess(2'b11,8'h11,2'b10,8,2);
      MultipleTapRegisterAccess(2'b00,16'hFF_FF,72'hA5A5_F0F0_A5A5_F0F0_5A,16,72);

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

