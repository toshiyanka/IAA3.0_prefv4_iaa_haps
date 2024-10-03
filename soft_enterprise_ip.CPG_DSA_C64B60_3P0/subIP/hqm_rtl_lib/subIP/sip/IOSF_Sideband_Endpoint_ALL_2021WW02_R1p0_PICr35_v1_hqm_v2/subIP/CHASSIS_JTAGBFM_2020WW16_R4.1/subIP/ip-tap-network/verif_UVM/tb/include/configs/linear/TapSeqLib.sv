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
// Sequeneces for HIERARCHICAL Network
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------

class TapSequenceSoftReset extends JtagBfmSequences;

    // Packet fro Sequencer to Driver
    JtagBfmSeqDrvPkt Packet;
    
    // Register component with Factory
    function new(string name = "TapSequenceSoftReset");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceSoftReset) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b10);
    endtask : body

endclass : TapSequenceSoftReset

//------------------------------------
//-- Sequence-1
//-- Cfg all 4 sTAP's on Pri Normal
//-- Put them all incl mTAP in Bypass
//-- Cfg all 4 sTAP's on Pri Normal
//-- Put them all inc mTAP in Idcode
//------------------------------------
class TapSequenceHierAllPriBypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierAllPriBypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierAllPriBypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
//        Reset(2'b11);
        // CLTAP Level - All on Primary Normal
        MultipleTapRegisterAccess(2'b00,8'h10,2'b00,8,2);
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0101,8,4);

        // STAP1 Level - All on Primary Normal
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_10,4'b1_1_00,24,4);
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_11,6'b1_1_0101,24,6);

        //Access External TDR
        ExpData_MultipleTapRegisterAccess( 2'b00,              // No Assert trst_b   
                                          40'hFF_FF_FF_FF_FF,  // Bypass all registers
                                          40,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFE0,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);

    endtask : body

endclass : TapSequenceHierAllPriBypass

class TapSequenceHierAllPriIdcode extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierAllPriIdcode");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierAllPriIdcode) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
//        Reset(2'b11);
        // CLTAP Level - All on Primary Normal
        MultipleTapRegisterAccess(2'b00,8'h10,2'b00,8,2);
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0101,8,4);

        // STAP1 Level - All on Primary Normal
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_10,4'b1_1_00,24,4);
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_11,6'b1_1_0101,24,6);

        //Access External TDR
        ExpData_MultipleTapRegisterAccess( 2'b00,             // No Assert trst_b   
                                          40'h02_0C_0C_0C_0C, // Idcode all registers
                                          40,                 // Address Length
                                          160'h0,             // The data that needs to be loaded in selected register
                                          160'h12345679_11111111_22222223_33333333_44444445, // The data that would come out
                                          160'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF, // (Mask) The fields of Expected_Data that need to be compared with Data
                                          160);            // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);
    endtask : body

endclass : TapSequenceHierAllPriIdcode

//------------------------------------
//-- Sequence-2 for linear network, no tertiary port
//-- sTAP_0123 = --P-, 2 flop delay including Master.
//-- TapSequenceLinearCfg -> PriSequencer
//-- TapSequenceLinear_sTAP2onPri_Bypass  -> PriSequencer
//------------------------------------

class TapSequenceLinearCfg extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceLinearCfg");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceLinearCfg) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
//        Reset(2'b11);
        // CLTAP_Level - sTAP0 isolated & sTAP1 normal
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0100,8,4);
        // sTAP1_Level -sTAP2 is normal & sTAP3 is isolated
        MultipleTapRegisterAccess(2'b00,16'hFF_11,5'b1_0001,16,5);
        // CTAP_Level - sTAP1 isolated
        MultipleTapRegisterAccess(2'b00,24'h11_FF_FF,6'b0000_1_1,24,6);
    endtask : body

endclass : TapSequenceLinearCfg

class TapSequenceLinear_sTAP2onPri_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceLinear_sTAP2onPri_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceLinear_sTAP2onPri_Bypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        // Placig sTAP2 on primary port of master
        // And in this topology for linear network, the Teritiary port is disabled.
        // Hence the data that would come out is after 2flops of bypass due to the Taps on Level-1 netowrk.
        ExpData_MultipleTapRegisterAccess( 2'b00,              // Assert trst_b
                                          16'hFF_FF,           // sTAP2 Bypass 
                                          16,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFFC,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);
    endtask : body

endclass : TapSequenceLinear_sTAP2onPri_Bypass 

//------------------------------------
//-- Sequence-3 for linear network, no tertiary port
//-- sTAP_0123 = --P-, Idcode for above.
//-- TapSequenceLinearCfg_Idcode -> PriSequencer
//-- TapSequenceLinear_sTAP2onPri_Idcode  -> PriSequencer
//------------------------------------

class TapSequenceLinearCfg_Idcode extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceLinearCfg_Idcode");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceLinearCfg_Idcode) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
//        Reset(2'b11);
        // CLTAP_Level - sTAP0 isolated & sTAP1 normal
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0100,8,4);
        // sTAP1_Level -sTAP2 is normal & sTAP3 is isolated
        MultipleTapRegisterAccess(2'b00,16'hFF_11,5'b1_0001,16,5);
        // CTAP_Level - sTAP1 isolated
        MultipleTapRegisterAccess(2'b00,24'h11_FF_FF,6'b0000_1_1,24,6);
    endtask : body

endclass : TapSequenceLinearCfg_Idcode  

class TapSequenceLinear_sTAP2onPri_Idcode extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceLinear_sTAP2onPri_Idcode");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceLinear_sTAP2onPri_Idcode) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        // Placig sTAP2 on primary port of master
        // And in this topology for linear network, the Teritiary port is disabled.
        ExpData_MultipleTapRegisterAccess( 2'b00,                 // Assert trst_b
                                          16'h02_0C,              // sTAP2 Bypass 
                                          16,                     // Address Length
                                          64'h0,                  // The data that needs to be loaded in selected register
                                          64'h12345679_33333333,  // The data that would come out
                                          64'hFFFFFFFF_FFFFFFFF,  // (Mask) The fields of Expected_Data that need to be compared with Data
                                          64);                    // Data Width
        //Goto(UPDR,1);
        //Goto(RUTI,11);
    endtask : body

endclass : TapSequenceLinear_sTAP2onPri_Idcode 

//------------------------------------
//-- Sequence-4
//-- Cfg sTAP0     - Sec
//--     sTAP1,2,3 - Prim
//-- Put them all in Bypass
//-- TapSequenceHierCfgAllSecBypass -> PriSequencer
//-- TapSequenceHierAllSecBypass -> SecSequencer
//------------------------------------
class TapSequenceHierCfg_sTAP0onSec_sTAP123onPrim_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHierCfgAllSecBypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHierCfg_sTAP0onSec_sTAP123onPrim_Bypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        // CLTAP_Level - All on Normal
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0101,8,4);
        // STAP1_Level - All on Normal
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_11,6'b1_1_0101,24,6);
        // STAP1_Level - All on Primary 
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_10,4'b1_1_00,24,4);
        // CLTAP_Level - sTAP0 on Sec, sTAP1 on Prim
        MultipleTapRegisterAccess(2'b00,8'h10,2'b01,8,2);
    endtask : body

endclass : TapSequenceHierCfg_sTAP0onSec_sTAP123onPrim_Bypass

class TapSequenceHier_sTAP0onSec_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHier_sTAP0onSec_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHier_sTAP0onSec_Bypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        // Placig all the TAP's on secondary port will  cause the TAP's on level-2 network to go on teritiary port.
        // And in this topology for Hierarchical network, the Teritiary port is not enabled.
        // Hence the data that would come out is after 2flops of bypass due to the Taps on Level-1 netowrk.
        ExpData_MultipleTapRegisterAccess( 2'b00,              // No Assert trst_b   
                                          32'hFF,              // sTAP0 Bypass 
                                          32,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFFE,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);
    endtask : body

endclass : TapSequenceHier_sTAP0onSec_Bypass 

class TapSequenceHier_sTAP123onPrim_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHier_sTAP123onPrim_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHier_sTAP123onPrim_Bypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        // Placig all the TAP's on secondary port will  cause the TAP's on level-2 network to go on teritiary port.
        // And in this topology for Hierarchical network, the Teritiary port is not enabled.
        // Hence the data that would come out is after 2flops of bypass due to the Taps on Level-1 netowrk.
        ExpData_MultipleTapRegisterAccess( 2'b00,              // No Assert trst_b   
                                          32'hFF,              // sTAP0 Bypass 
                                          32,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFF0,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);
    endtask : body

endclass : TapSequenceHier_sTAP123onPrim_Bypass 

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

    `uvm_object_utils(TapSequenceHierCfg_sTap1Pri_sTAP23Ter_Bypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        Reset(2'b11);
        // CLTAP_Level - sTAP0 on Sec, sTAP1 on Prim
        MultipleTapRegisterAccess(2'b00,8'h10,2'b01,8,2);
        // CLTAP_Level - All on Normal
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0101,8,4);
        // STAP1_Level - All on Normal
        MultipleTapRegisterAccess(2'b00,16'hFF_11,5'b1_0101,16,5);
        // STAP1_Level - All on Primary 
        MultipleTapRegisterAccess(2'b00,16'hFF_10,3'b1_11,16,3);
    endtask : body

endclass : TapSequenceHierCfg_sTap1Pri_sTAP23Ter_Bypass

class TapSequenceHier_sTAP1onPri_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceHier_sTAP1onPri_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceHier_sTAP1onPri_Bypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        // Placig sTAP1 on primary port of master
        // And in this topology for Hierarchical network, the Teritiary port is enabled.
        // Hence the data that would come out is after 2flops of bypass due to the Taps on Level-1 netowrk.
        ExpData_MultipleTapRegisterAccess( 2'b00,              // No Assert trst_b   
                                          32'hFF,              // sTAP0 Bypass 
                                          32,                  // Address Length
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

    `uvm_object_utils(TapSequenceHier_sTAP23onTer_Bypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        // Placig all the TAP's on secondary port will  cause the TAP's on level-2 network to go on teritiary port.
        // And in this topology for Hierarchical network, the Teritiary port is not enabled.
        // Hence the data that would come out is after 2flops of bypass due to the Taps on Level-1 netowrk.
        ExpData_MultipleTapRegisterAccess( 2'b00,              // No Assert trst_b   
                                          32'hFF,              // sTAP0 Bypass 
                                          32,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFFC,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);
    endtask : body

endclass : TapSequenceHier_sTAP23onTer_Bypass

//------------------------------------
//-- Sequence-4 for linear network, no tertiary port
//-- sTAP_0123 = --PS, Bypass.
//-- Cfg sTAP0   - Isolated
//--     sTAP1   - Normal Primary then Isolated
//--     sTAP2   - Normal Primary
//--     sTAP3   - Normal Secondary
//-- Put them all in Idcode
//-- TapSequenceLinearCfg_S2Pri_S3Sec_Byp -> PriSequencer
//-- TapSequenceLinear_sTAP2onPri_Bypass  -> PriSequencer
//-- TapSequenceLinear_sTAP3onSec_Bypass  -> SecSequencer
//-- TapSequenceLinear_sTAP2onPri_Idcode  -> PriSequencer
//-- TapSequenceLinear_sTAP3onSec_Idcode  -> SecSequencer
//------------------------------------

class TapSequenceLinearCfg_S2Pri_S3Sec_Byp extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceLinearCfg_S2Pri_S3Sec_Byp");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceLinearCfg_S2Pri_S3Sec_Byp) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
//        Reset(2'b11);
        // CLTAP_Level - sTAP0 isolated & sTAP1 normal
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0100,8,4);
        // sTAP1_Level -sTAP2 is Pri & sTAP3 is Secondary
        MultipleTapRegisterAccess(2'b00,16'hFF_10,3'b1_10,16,3);
        // sTAP1_Level -sTAP2 is normal & sTAP3 is normal 
        MultipleTapRegisterAccess(2'b00,16'hFF_11,5'b1_0101,16,5);
        // CTAP_Level - sTAP1 isolated
        MultipleTapRegisterAccess(2'b00,24'h11_FF_FF,6'b0000_1_1,24,6);
    endtask : body

endclass : TapSequenceLinearCfg_S2Pri_S3Sec_Byp

class TapSequenceLinear_sTAP3onSec_Bypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceLinear_sTAP3onSec_Bypass");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceLinear_sTAP3onSec_Bypass) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        // Placig sTAP2 on primary port of master
        // And in this topology for linear network, the Teritiary port is disabled.
        // Hence the data that would come out is after 2flops of bypass due to the Taps on Level-1 netowrk.
        ExpData_MultipleTapRegisterAccess( 2'b00,              // Assert trst_b
                                           8'hFF,              // sTAP2 Bypass 
                                           8,                  // Address Length
                                          32'hFFFF_FFFF,       // The data that needs to be loaded in selected register
                                          32'hFFFF_FFFE,       // The data that would come out
                                          32'hFFFF_FFFF,       // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);                 // Data Width
        Goto(UPDR,1);
        Goto(RUTI,11);
    endtask : body

endclass : TapSequenceLinear_sTAP3onSec_Bypass

class TapSequenceLinear_sTAP3onSec_Idcode extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceLinear_sTAP3onSec_Idcode");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceLinear_sTAP3onSec_Idcode) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        // Placig sTAP2 on primary port of master
        // And in this topology for linear network, the Teritiary port is disabled.
        ExpData_MultipleTapRegisterAccess( 2'b00,        // Assert trst_b
                                           8'h0C,        // sTAP2 Bypass 
                                           8,            // Address Length
                                          32'h0,         // The data that needs to be loaded in selected register
                                          32'h44444445,  // The data that would come out
                                          32'hFFFFFFFF,  // (Mask) The fields of Expected_Data that need to be compared with Data
                                          32);           // Data Width
        //Goto(UPDR,1);
        //Goto(RUTI,11);
    endtask : body

endclass : TapSequenceLinear_sTAP3onSec_Idcode 


//------------------------------------
//-- Sequence-5 for linear network, no tertiary port
//-- sTAP_0123 = -PS-, Bypass
//-- TapSequenceLinearCfg_S1Pri_S2Sec_Byp -> PriSequencer
//------------------------------------

class TapSequenceLinearCfg_S1Pri_S2Sec_Byp extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceLinearCfg_S1Pri_S2Sec_Byp");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceLinearCfg_S1Pri_S2Sec_Byp) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        //---// CLTAP_Level - Get sTAP0, sTAP1 on Primary
        //---MultipleTapRegisterAccess(2'b00,8'h10,2'b00,8,2);
        //---// CLTAP_Level - sTAP0 isolated & sTAP1 normal
        //---MultipleTapRegisterAccess(2'b00,8'h11,4'b0100,8,4);
        //---// sTAP1_Level - sTAP2 is normal & sTAP3 is normal 
        //---MultipleTapRegisterAccess(2'b00,16'hFF_11,5'b1_0001,16,5);
        //---// sTAP1_Level - sTAP2 is Pri & sTAP3 is Secondary
        //---MultipleTapRegisterAccess(2'b00,16'hFF_10,3'b1_01,16,3);

        //---// CLTAP_Level - Get sTAP0, sTAP1 on Primary
        MultipleTapRegisterAccess(2'b00,8'h10,2'b00,8,2);
        // CLTAP_Level - sTAP0 isolated & sTAP1 normal
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0101,8,4);

        // sTAP1_Level - sTAP2 is normal & sTAP3 is normal 
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_10,4'b1_1_01,24,4);
        // CLTAP_Level - Get sTAP0, sTAP1 on Primary
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_11,6'b1_1_0001,24,6);

        // sTAP1_Level - sTAP2 is Pri & sTAP3 is Secondary
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0100,8,4);
    endtask : body

endclass : TapSequenceLinearCfg_S1Pri_S2Sec_Byp

//------------------------------------
//-- Sequence-6 for linear network, no tertiary port
//-- Cfg sTAP_0123 = -SP-, Bypass
//-- TapSequenceLinearCfg_S1Sec_S2Pri_Byp -> PriSequencer
//------------------------------------

class TapSequenceLinearCfg_S1Sec_S2Pri_Byp extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceLinearCfg_S1Sec_S2Pri_Byp");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceLinearCfg_S1Sec_S2Pri_Byp) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        // CLTAP_Level - Get sTAP0, sTAP1 on Primary
        MultipleTapRegisterAccess(2'b00,8'h10,2'b00,8,2);
        // CLTAP_Level - sTAP0 isolated & sTAP1 normal
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0100,8,4);
        // sTAP1_Level - sTAP2 is normal & sTAP3 is isolated 
        MultipleTapRegisterAccess(2'b00,16'hFF_11,5'b1_0001,16,5);
        // sTAP1_Level - sTAP2 is Pri 
        MultipleTapRegisterAccess(2'b00,16'hFF_10,3'b1_00,16,3);
        // CLTAP_Level - Get sTAP1 on Secondary
        MultipleTapRegisterAccess(2'b00,8'h10,2'b10,8,2);
    endtask : body

endclass : TapSequenceLinearCfg_S1Sec_S2Pri_Byp

//------------------------------------
//-- Sequence-7 for linear network, no tertiary port
//-- sTAP_0123 = SSSS, 4 flop delay excluding Master.
//------------------------------------

class TapSequenceLinearCfg_AllSec_Byp extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceLinearCfg_AllSec_Byp");
        super.new(name);
        Packet = new;
    endfunction : new

    `uvm_object_utils(TapSequenceLinearCfg_AllSec_Byp) 

    `uvm_declare_p_sequencer(JtagBfmSequencer)

    virtual task body();
        // CLTAP_Level - Get sTAP0, sTAP1 on Primary
        MultipleTapRegisterAccess(2'b00,8'h10,2'b00,8,2);
        // CLTAP_Level - sTAP0 & sTAP1 normal
        MultipleTapRegisterAccess(2'b00,8'h11,4'b0101,8,4);
        // sTAP1_Level - sTAP2 is Pri 
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_10,4'b1_1_11,24,4); //Fixme
        // sTAP1_Level - sTAP2 & sTAP3 normal
        MultipleTapRegisterAccess(2'b00,24'hFF_FF_11,6'b1_1_0101,24,6);
        // CLTAP_Level - Get sTAP1 on Secondary
        MultipleTapRegisterAccess(2'b00,8'h10,2'b11,8,2);
    endtask : body

endclass : TapSequenceLinearCfg_AllSec_Byp

