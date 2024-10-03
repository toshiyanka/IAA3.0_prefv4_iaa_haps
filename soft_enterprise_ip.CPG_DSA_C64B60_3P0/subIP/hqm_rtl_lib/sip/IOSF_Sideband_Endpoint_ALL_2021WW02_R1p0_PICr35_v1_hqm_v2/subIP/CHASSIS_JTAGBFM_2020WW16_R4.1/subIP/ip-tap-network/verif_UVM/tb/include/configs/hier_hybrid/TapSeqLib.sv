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
        MultipleTapRegisterAccess(2'b01,8'h10,4'h3,8,4);
        MultipleTapRegisterAccess(2'b00,8'h11,8'h55,8,8);
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
        MultipleTapRegisterAccess(2'b01,8'h10,2'h1,8,2);
        MultipleTapRegisterAccess(2'b00,8'h11,4'h1,8,4);
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
        MultipleTapRegisterAccess(2'b01,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(2'b00,8'h11,16'h0004,8,16);
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
        MultipleTapRegisterAccess(2'b01,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(2'b00,8'h11,16'h1000,8,16);
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
        MultipleTapRegisterAccess(2'b01,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(2'b00,8'h11,16'h0040,8,16);
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
        MultipleTapRegisterAccess(2'b01,8'h10,8'h5A,8,8);
        MultipleTapRegisterAccess(2'b00,8'h11,16'h0100,8,16);
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
        MultipleTapRegisterAccess(2'b00,8'h34,32'h05AF_05AF,8,32);
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
        MultipleTapRegisterAccess(2'b11,8'h10,2'h0,8,2);

        //All Normal
      MultipleTapRegisterAccess(2'b00,8'h11,4'h5,8,4);

      //All Bypass
      MultipleTapRegisterAccess(2'b00,24'hFF_FF_FF,64'h0000_0000_0000_0000,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_FF_FF,64'h5555_5555_5555_5555,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_FF_FF,64'h5555_5555_5555_5555,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,24,64);
      //All Register Access ADDR 34
      MultipleTapRegisterAccess(2'b00,24'hFF_34_34,64'h0000_0000_0000_0000,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_34_34,64'h5555_5555_5555_5555,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_34_34,64'h5555_5555_5555_5555,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_34_34,64'hAAAA_AAAA_AAAA_AAAA,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_34_34,64'hAAAA_AAAA_AAAA_AAAA,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_34_34,64'hFFFF_FFFF_FFFF_FFFF,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_34_34,64'hFFFF_FFFF_FFFF_FFFF,24,64);
      //All Register Access ADDR Ax
      MultipleTapRegisterAccess(2'b00,24'hFF_A1_A1,64'hF5FA_F5FA_F5FA_F5FA,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_A1_A1,64'hF5FA_F5FA_F5FA_F5FA,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_A1_A1,64'h5555_5555_5555_5555,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_A1_A1,64'h5555_5555_5555_5555,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_A1_A1,64'hAAAA_AAAA_AAAA_AAAA,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_A1_A1,64'hAAAA_AAAA_AAAA_AAAA,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_A1_A1,64'hFFFF_FFFF_FFFF_FFFF,24,64);
      MultipleTapRegisterAccess(2'b00,24'hFF_A1_A1,64'hFFFF_FFFF_FFFF_FFFF,24,64);
      //All Register Access ADDR Ax
      MultipleTapRegisterAccess(2'b00,24'hFF_0C_0C,64'h0000_0000,24,64);

    ////Normal Decoupled Combinations
    ////1 in Decoupled
      MultipleTapRegisterAccess(2'b11,8'h11,4'h4,8,4);
      MultipleTapRegisterAccess(2'b00,16'hFF_34,72'hA5A5_F0F0_A5A5_F0F0_5A,16,72);
      MultipleTapRegisterAccess(2'b00,16'hFF_34,72'hA5A5_F0F0_A5A5_F0F0_5A,16,72);
      MultipleTapRegisterAccess(2'b11,8'h11,4'h1,8,4);
      MultipleTapRegisterAccess(2'b00,16'hFF_34,72'hA5A5_F0F0_A5A5_F0F0_5A,16,72);
      MultipleTapRegisterAccess(2'b00,16'hFF_34,72'hA5A5_F0F0_A5A5_F0F0_5A,16,72);
    ////2 in Decoupled
      MultipleTapRegisterAccess(2'b11,8'h11,4'h0,8,4);
      MultipleTapRegisterAccess(2'b00,8'hFF,72'hA5A5_F0F0_A5A5_F0F0_5A,8,72);

    ////Normal Excluded Combinations
    ////1 in Excluded
      MultipleTapRegisterAccess(2'b11,8'h11,4'h6,8,4);
      MultipleTapRegisterAccess(2'b00,24'hFF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,24,64);
      MultipleTapRegisterAccess(2'b11,8'h11,4'h9,8,4);
      MultipleTapRegisterAccess(2'b00,24'hFF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,24,64);

    ////Normal Excluded Decoupled combination  
      MultipleTapRegisterAccess(2'b11,8'h11,4'h8,8,4);
      MultipleTapRegisterAccess(2'b00,16'hFF_FF,64'hFFFF_FFFF_FFFF_FFFF,16,64);

    ////Normal Shadow combination  
      MultipleTapRegisterAccess(2'b11,8'h11,4'h7,8,4);
      MultipleTapRegisterAccess(2'b00,16'hFF_FF,64'hFFFF_FFFF_FFFF_FFFF,16,64);
      MultipleTapRegisterAccess(2'b11,8'h11,4'hD,8,4);
      MultipleTapRegisterAccess(2'b00,16'hFF_FF,64'hFFFF_FFFF_FFFF_FFFF,16,64);

    endtask : body

endclass : TapSequencePrimaryOnly

//-----------------------------------------------------------------------------------
// Sequeneces for HIERARCHICAL HYBRID Network
//-----------------------------------------------------------------------------------

//------------------------------------
//-- Sequence-Group-1
//-- Cfg all 10 sTAP's on Pri Normal
//-- Put them all incl mTAP in Bypass
//------------------------------------
class TapSequenceHierHybridAllPriBypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierHybridAllPriBypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierHybridAllPriBypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);

        Goto(RUTI,10);
        //Access NWSel Reg of mTAP and enable s0-s5
        MultipleTapRegisterAccess(2'b00,     8'h11, 12'h555,  8, 12);
        //Access NWSel Reg of s2 and enable s6, s7, s8, s9
        MultipleTapRegisterAccess(2'b00, 56'hFF_FF_FF_11_FF_FF_FF,  11'h055, 56,  11);

        //Access External TDR
        ExpData_MultipleTapRegisterAccess(2'b00,              // No Assert trst_b   
                                          {88{1'b1}},          // Bypass all registers
                                          88,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_F800,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);
    endtask : body

endclass : TapSequenceHierHybridAllPriBypass

//------------------------------------
//-- Sequence-Group-2
//-- On Level-1 Network, put s1, s3, s4 on Sec
//-- On Level-2 Network, put s6, s8, s9 on Sec
//-- Put rest on Primary
//------------------------------------
class TapSequenceHierHybridFewPriFewSecConfig extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierHybridFewPriFewSecConfig");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierHybridFewPriFewSecConfig) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);

        //Access SecSel Reg of mTAP and put s1, s3, s4 on Sec
        MultipleTapRegisterAccess(2'b00, 8'h10, 6'b011010,  8,  6);
        //Access NWSel Reg of mTAP and enable s0-s5
        MultipleTapRegisterAccess(2'b00, 8'h11, 12'h555,    8, 12);

        //Access SecSel Reg of s2 and put enable s6, s8, s9 on Sec
        //                                    M s0 s2 s5
        MultipleTapRegisterAccess(2'b00, 32'hFF_FF_10_FF,  7'b0_0_1101_0, 32,  7);
        //Access NWSel Reg of s2 and enable s6, s7, s8, s9
        //                                    M s0 s2 s5                             
        MultipleTapRegisterAccess(2'b00, 32'hFF_FF_11_FF,  11'b0_0_01010101_0, 32,  11);

        Goto(RUTI,10);

    endtask : body

endclass : TapSequenceHierHybridFewPriFewSecConfig
//----------------------------------------------------------------
class TapSequenceHierHybrid5PriBypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierHybrid5PriBypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierHybrid5PriBypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        ExpData_MultipleTapRegisterAccess(2'b00,              // No Assert trst_b   
                                          {40{1'b1}},          // Bypass all registers
                                          40,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFE0,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);

    endtask : body

endclass : TapSequenceHierHybrid5PriBypass
//----------------------------------------------------------------
class TapSequenceHierHybrid6SecBypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierHybrid6SecBypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierHybrid6SecBypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        ExpData_MultipleTapRegisterAccess(2'b00,              // No Assert trst_b   
                                          {48{1'b1}},          // Bypass all registers
                                          48,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFC0,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);

    endtask : body

endclass : TapSequenceHierHybrid6SecBypass
//----------------------------------------------------------------
class TapSequenceHierHybrid5PriIdcode extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierHybrid5PriIdcode");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierHybrid5PriIdcode) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        ExpData_MultipleTapRegisterAccess(2'b00,               // No Assert trst_b   
                                          40'h02_0C_0C_0C_0C,  // Bypass all registers
                                          40,                  // Address Length
                                          {160{1'b0}},         // The data that needs to be loaded in selected register
                                          160'h12345679_ABCD0001_ABCD2223_ABCD7777_ABCD5555,       // The data that would come out
                                          {160{1'b1}},         // (Mask) The fields of Expected_Data that need to be compared with Data
                                          160);                // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);

    endtask : body

endclass : TapSequenceHierHybrid5PriIdcode
//----------------------------------------------------------------
class TapSequenceHierHybrid6SecIdcode extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierHybrid6SecIdcode");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierHybrid6SecIdcode) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        ExpData_MultipleTapRegisterAccess(2'b00,              // No Assert trst_b   
                                          48'h0C_0C_0C_0C_0C_0C,  // Bypass all registers
                                          48,                  // Address Length
                                          {192{1'b0}},         // The data that needs to be loaded in selected register
                                          192'hABCD1111_ABCD6667_ABCD8889_ABCD9999_ABCD3333_ABCD4445,       // The data that would come out
                                          {192{1'b1}},         // (Mask) The fields of Expected_Data that need to be compared with Data
                                          192);                // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);

    endtask : body

endclass : TapSequenceHierHybrid6SecIdcode

//------------------------------------
//-- Sequence-Group-3
//-- On Level-1 Network, put s1, s2, s5 on Sec
//-- On Level-2 Network, put s6, s7, s8, s9 on Prim
//-- Put rest on Primary
//------------------------------------
class TapSequenceHierHybridFewSecFewPriConfig extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierHybridFewSecFewPriConfig");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierHybridFewSecFewPriConfig) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);

        //Access NWSel Reg of mTAP and enable s0-s5
        //                                    M 
        MultipleTapRegisterAccess(2'b00,  8'h11, 12'h555,    8, 12);

        //Access NWSel Reg of s2 and enable s6, s7, s8, s9
        //                                    M s0 s1 s2 s3 s4 s5                            
        MultipleTapRegisterAccess(2'b00, 56'hFF_FF_FF_11_FF_FF_FF,  14'b0_0_0_01010101_0_0_0, 56,  14);

        //Access SecSel Reg of MTAP and put s1, s2, s5 on sec
        //                                   M                            
        MultipleTapRegisterAccess(2'b00, 8'h10,  6'b100101, 8,  6);

        Goto(RUTI,10);

    endtask : body

endclass : TapSequenceHierHybridFewSecFewPriConfig
//----------------------------------------------------------------
class TapSequenceHierHybrid4PriBypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierHybrid4PriBypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierHybrid4PriBypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        ExpData_MultipleTapRegisterAccess(2'b00,              // No Assert trst_b   
                                          {32{1'b1}},          // Bypass all registers
                                          32,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFF0,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);

    endtask : body

endclass : TapSequenceHierHybrid4PriBypass
//----------------------------------------------------------------
class TapSequenceHierHybrid7SecBypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierHybrid7SecBypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierHybrid7SecBypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        ExpData_MultipleTapRegisterAccess(2'b00,              // No Assert trst_b   
                                          {56{1'b1}},          // Bypass all registers
                                          56,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FF80,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);

    endtask : body

endclass : TapSequenceHierHybrid7SecBypass
//----------------------------------------------------------------
class TapSequenceHierHybrid4PriIdcode extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierHybrid4PriIdcode");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierHybrid4PriIdcode) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        ExpData_MultipleTapRegisterAccess(2'b00,               // No Assert trst_b   
                                          32'h02_0C_0C_0C,  // Bypass all registers
                                          32,                  // Address Length
                                          {128{1'b0}},         // The data that needs to be loaded in selected register
                                          128'h12345679_ABCD1111_ABCD3333_ABCD4445,       // The data that would come out
                                          {128{1'b1}},         // (Mask) The fields of Expected_Data that need to be compared with Data
                                          128);                // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);

    endtask : body

endclass : TapSequenceHierHybrid4PriIdcode
//----------------------------------------------------------------
class TapSequenceHierHybrid7SecIdcode extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierHybrid7SecIdcode");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierHybrid7SecIdcode) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        ExpData_MultipleTapRegisterAccess(2'b00,              // No Assert trst_b   
                                          {7{8'h0C}},  // Bypass all registers
                                          56,                  // Address Length
                                          {224{1'b0}},         // The data that needs to be loaded in selected register
                                          224'hABCD0001_ABCD2223_ABCD6667_ABCD7777_ABCD8889_ABCD9999_ABCD5555,       // The data that would come out
                                          {224{1'b1}},         // (Mask) The fields of Expected_Data that need to be compared with Data
                                          224);                // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);

    endtask : body

endclass : TapSequenceHierHybrid7SecIdcode

/*
//------------------------------------
//-- Sequence-Group-4
//-- Put sTAP on CLTAP's Primary.
//-- Then place his chid on CLTAP's Sec
//-- This config is architectuarlly not allowed.
//-- An assertion prevents the user from doing this.
//-- This is placeholder for negative testing
//------------------------------------
*/
