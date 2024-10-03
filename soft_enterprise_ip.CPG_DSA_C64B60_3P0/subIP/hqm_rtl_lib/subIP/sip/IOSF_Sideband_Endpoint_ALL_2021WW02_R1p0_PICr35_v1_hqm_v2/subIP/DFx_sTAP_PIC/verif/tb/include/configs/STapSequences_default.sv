//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2019 Intel Corporation All Rights Reserved.
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
//  Collateral Description:
//  dteg-stap
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_sTAP_2020WW05_RTL1P0_PIC6_V1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : STapSequences_default.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : Sequences for the ENV
//    DESCRIPTION : This Component defines various sequences that are
//                  needed to drive and test the DUT including the Random
//------------------------------------------------------------------------
//class PowergoodReset extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;
// Following are type of resets
class PowergoodReset extends JtagBfmSequences;
   //----------------------------
   // Binding with the sequencer
   //----------------------------
   //`ovm_sequence_utils (PowergoodReset, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)
   `ovm_sequence_utils(PowergoodReset, JtagBfmSequencer)

   //--------------
   // New Function
   //--------------
   function new (string name = "PowergoodReset");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
      //Powergood_Reset;
      Idle(2);
      Reset(RST_PWRGUD);
   endtask : body

endclass : PowergoodReset

//-----------------------------------------------
// Driving EarlyBootExitLOW, SucurePolicyLOW, PolicyUpdateLOW
//-----------------------------------------------
class Drive_EBE_Low extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (Drive_EBE_Low, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "Drive_EBE_Low");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveFdfxEarlybootExit(1'b0);
       DriveFdfxSecurePolicy(4'b0);
       DriveFdfxPolicyUpdate(1'b0);
   endtask : body

endclass : Drive_EBE_Low

//-----------------------------------------------
// Driving EarlyBootExitLOW
//-----------------------------------------------
class EarlyBootExitLOW extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (EarlyBootExitLOW, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "EarlyBootExitLOW");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveFdfxEarlybootExit(LOW);
   endtask : body

endclass : EarlyBootExitLOW

//-----------------------------------------------
// Driving EarlyBootExitLOW
//-----------------------------------------------
class EarlyBootExitHIGH extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (EarlyBootExitHIGH, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "EarlyBootExitHIGH");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveFdfxEarlybootExit(HIGH);
   endtask : body

endclass : EarlyBootExitHIGH

//-----------------------------------------------
// Driving Various Security Policies to DFX IP
//-----------------------------------------------
class SecurityLocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (SecurityLocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "SecurityLocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(SECURITY_LOCKED);
   endtask : body

endclass : SecurityLocked

class SecurityUnlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (SecurityUnlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "SecurityUnlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(SECURITY_UNLOCKED);
   endtask : body

endclass : SecurityUnlocked

class FunctionalityLocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (FunctionalityLocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "FunctionalityLocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(FUNCTIONALITY_LOCKED);
   endtask : body

endclass : FunctionalityLocked

class FuseProgramming extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (FuseProgramming, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "FuseProgramming");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(FUSE_PROGRAMMING);
   endtask : body

endclass : FuseProgramming

class IntelUnlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (IntelUnlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "IntelUnlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(INTEL_UNLOCKED);
   endtask : body

endclass : IntelUnlocked

class OEMUnlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (OEMUnlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "OEMUnlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(OEM_UNLOCKED);
   endtask : body

endclass : OEMUnlocked

class EnDebugUnlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (EnDebugUnlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "EnDebugUnlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(ENDEBUG_UNLOCKED);
   endtask : body

endclass : EnDebugUnlocked

class InfraRedUnlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (InfraRedUnlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "InfraRedUnlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(INFRARED_UNLOCKED);
   endtask : body

endclass : InfraRedUnlocked

class DramDebugUnlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (DramDebugUnlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "DramDebugUnlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(DRAMDEBUG_UNLOCKED);
   endtask : body

endclass : DramDebugUnlocked

class User3Unlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (User3Unlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "User3Unlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(USER3_UNLOCKED);
   endtask : body

endclass : User3Unlocked

class User4Unlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (User4Unlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "User4Unlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(USER4_UNLOCKED);
   endtask : body

endclass : User4Unlocked

class User5Unlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (User5Unlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "User5Unlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(USER5_UNLOCKED);
   endtask : body

endclass : User5Unlocked

class User6Unlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (User6Unlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "User6Unlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(USER6_UNLOCKED);
   endtask : body

endclass : User6Unlocked

class User7Unlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (User7Unlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "User7Unlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(USER7_UNLOCKED);
   endtask : body

endclass : User7Unlocked

class User8Unlocked extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (User8Unlocked, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "User8Unlocked");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(USER8_UNLOCKED);
   endtask : body

endclass : User8Unlocked

class PartDisabled extends DfxSecurePlugin_Pkg::DfxSecurePlugin_DriveUserPolicySeq;

   //----------------------------
   // Binding with the sequencer
   //----------------------------
   `ovm_sequence_utils (PartDisabled, DfxSecurePlugin_Pkg::DfxSecurePlugin_Seqr)

   //--------------
   // New Function
   //--------------
   function new (string name = "PartDisabled");
      super.new (name);
   endfunction : new

   //---------------
   // OVM Body Task
   //---------------
   virtual task body ();
       DriveDfxSecurePolicy(PART_DISABLED);
   endtask : body

endclass : PartDisabled

//-----------------------------------------------
// OnlyBypass Sequence will place sTAP in Bypass mode
//-----------------------------------------------
class OnlyBypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "OnlyBypass");
        super.new(name);
        Packet =JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(OnlyBypass, JtagBfmSequencer)

    virtual task body();
        if(SIZE_OF_IR_REG == 16) begin
            MultipleTapRegisterAccess(NO_RST, 16'h00FF, 32'hFFFFFFFF, 16, 32);
        end else if (SIZE_OF_IR_REG == 8) begin
            MultipleTapRegisterAccess(NO_RST, 8'hFF, 32'hFFFFFFFF, 8, 32);
        end
    endtask : body

endclass : OnlyBypass

//-----------------------------------------------
// OnlySLVIDCODE Sequence will access SLVIDCODE
//-----------------------------------------------
class OnlySLVIDCODE extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "OnlySLVIDCODE");
        super.new(name);
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(OnlySLVIDCODE, JtagBfmSequencer)

    virtual task body();
        if(SIZE_OF_IR_REG == 16) begin
            MultipleTapRegisterAccess(NO_RST, 16'h000C, 32'h55555555, 16, 32);
        end else if (SIZE_OF_IR_REG == 8) begin
            MultipleTapRegisterAccess(NO_RST, 8'h0C, 32'h55555555, 8, 32);
        end
    endtask : body

endclass : OnlySLVIDCODE

//-----------------------------------------------
// Bypass Sequence
// places the sTAP in Bypass and Transfers Data
//-----------------------------------------------
class TapSequenceBypass extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceBypass");
        super.new(name);
        Packet =JtagBfmSeqDrvPkt::type_id::create("JtagBfmSeqDrvPkt") ;
    endfunction : new

    `ovm_sequence_utils(TapSequenceBypass, JtagBfmSequencer)

    virtual task body();
        Idle(30);
        ForceReset(RST_PWRGUD,1'b1);
        Idle(30);
        ForceReset(RST_HARD,1'b0);
        Idle(30);
        ForceReset(RST_HARD,1'b1);
        Idle(30);
        tms_tdi_stream(9'h0F0,9'h0,9);
        Reset(RST_PWRGUD);
        Goto(ST_CADR,1);
        tms_tdi_stream(20'h3FFF0,20'h0,20);
        Reset(RST_PWRGUD);
        Goto(ST_CADR,1);
        tms_tdi_stream(20'h00F00,20'h0,20);
        Reset(RST_PWRGUD);
        if(SIZE_OF_IR_REG == 16) begin
            ExpData_MultipleTapRegisterAccess(RST_HARD,16'h00FF,16,32'hFFFF_FFFF,32'hFFFF_FFFE,32'hFFFF_FFFF,32);
        end else if (SIZE_OF_IR_REG == 8) begin
            ExpData_MultipleTapRegisterAccess(RST_HARD,8'hFF,8,32'hFFFF_FFFF,32'hFFFF_FFFE,32'hFFFF_FFFF,32);
        end
        Goto(ST_SDRS,1);
        Goto(ST_CADR,1);
        Goto(ST_E1DR,1);
        Goto(ST_PADR,1);
        Goto(ST_E2DR,1);
        tms_tdi_stream(9'h0F0,9'h0,9);
        Goto(ST_SIRS,1);
        Goto(ST_CAIR,1);
        Goto(ST_E1IR,1);
        Goto(ST_PAIR,1);
        Goto(ST_E2IR,1);
        tms_tdi_stream(9'h0F0,9'h0,9);
    endtask : body

endclass : TapSequenceBypass

//-----------------------------------------------
// Register Access
// Access All the Registers present in the sTAP
//-----------------------------------------------
class TapSequenceMultipleTapRegisterAccess extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    logic [31:0]  exp_data;
    function new(string name = "TapSequenceMultipleTapRegisterAccess");
        super.new(name);
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");;
    endfunction : new

    `ovm_sequence_utils(TapSequenceMultipleTapRegisterAccess, JtagBfmSequencer)

    virtual task body();
        //Idle(30);
        //ForceReset(RST_HARD,1'b0);
        //Idle(30);
        //ForceReset(RST_HARD,1'b1);
        //Idle(30);
        //ForceReset(RST_PWRGUD,1'b1);
        //Idle(30);

        //------------------------------
        if (SIZE_OF_IR_REG_STAP == 16) begin
            MultipleTapRegisterAccess(NO_RST, 16'hFFFF, 32'hF5A0F0A5, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h5555, 32'hF5A0F0A5, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'hAAAA, 32'hF5A0F0A5, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0000, 32'hF5A0F0A5, 16, 32);
            // VISA Register Access Assuming 4 VISA register
            // Attempt to toggle all the data Bits for each Reg
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h000FFFFFFFF, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h00055555555, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h000AAAAAAAA, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h00000000000, 16, 42);

            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h001FFFFFFFF, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h00155555555, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h001AAAAAAAA, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h00100000000, 16, 42);

            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h002FFFFFFFF, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h00255555555, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h002AAAAAAAA, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h00200000000, 16, 42);

            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h003FFFFFFFF, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h00355555555, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h003AAAAAAAA, 16, 42);
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 42'h00300000000, 16, 42);
            //for resets

            //SWCLR option of cleraing the iTDR.
            MultipleTapRegisterAccess(NO_RST, 16'h0015, 2'b10, 16, 2);
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0034, 32'hFFFFFFFF, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0016, 2'b11, 16, 2);
            MultipleTapRegisterAccess(NO_RST, 16'h0016, 2'b00, 16, 2);
            // Optional Register #1
            MultipleTapRegisterAccess(RST_HARD, 16'h0034, 32'hABCD1234, 16, 32);
            MultipleTapRegisterAccess(RST_SOFT, 16'h0034, 32'h99887766, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0016, 2'b11, 16, 2);
            MultipleTapRegisterAccess(NO_RST, 16'h0016, 2'b00, 16, 2);
            //MultipleTapRegisterAccess(NO_RST, 16'h0034, 32'hFFFFFFFF, 16, 32);
            //MultipleTapRegisterAccess(NO_RST, 16'h0034, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0034, 32'hAAAAAAAA, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0034, 32'h00000000, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0034, 32'hFFFFFFFF, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0034, 32'h55555555, 16, 32);
            // Optional Register #2
            MultipleTapRegisterAccess(RST_HARD, 16'h006B, 32'hFFFFFFFF, 16, 32);
            MultipleTapRegisterAccess(RST_SOFT, 16'h006B, 32'h55555555, 16, 32);
            //MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'hFFFFFFFF, 16, 32);
            //MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'hAAAAAAAA, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h00000000, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'hFFFFFFFF, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0016, 2'b11, 16, 2);
            MultipleTapRegisterAccess(NO_RST, 16'h0016, 2'b00, 16, 2);

            //--------------------------------------------------------------------
            //Sequence added for ITDR HARD reset
            //Clearing thru TRST_B
            MultipleTapRegisterAccess(NO_RST, 16'h0015, 2'b01,  16, 2);
            MultipleTapRegisterAccess(NO_RST, 16'h0016, 2'b11,  16, 2);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0016, 2'b00,  16, 2);

            //Access the Internal TDR's.
            MultipleTapRegisterAccess(NO_RST, 16'h0034, 32'hAAAA_BBBB, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'hCCCC_DDDD, 16, 32);

            //Clearing thru TRST_B
            MultipleTapRegisterAccess(NO_RST, 16'h0015, 2'b11,  16, 2);
            MultipleTapRegisterAccess(NO_RST, 16'h0016, 2'b11,  16, 2);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0016, 2'b00,  16, 2);
            //--------------------------------------------------------------------

            // SELECT Register Access
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'hFFFFFFFF, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'h55555555, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'hAAAAAAAA, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'h00000000, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'hFFFFFFFF, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'h55555555, 16, 32);
            end
            // SELECT  Override Register Access
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'hFFFFFFFF, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'h55555555, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'hAAAAAAAA, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'h00000000, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'hFFFFFFFF, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'h55555555, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'h00000000, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'h00000000, 16, 32);
            end
            // SELECT  Override Register Access
            MultipleTapRegisterAccess(NO_RST, 16'h0013, 32'hFFFFFFFF, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0013, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0013, 32'hAAAAAAAA, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0013, 32'h00000000, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0013, 32'hFFFFFFFF, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0013, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0013, 32'h00000000, 16, 32);
            // IDCODE Access
            MultipleTapRegisterAccess(NO_RST, 16'h000C, 32'h00000000, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h000C, 32'hAAAAAAAA, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h000C, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h000C, 32'hFFFFFFFF, 16, 32);

            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'hAAAAAAAA, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'h55555555, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'hAAAAAAAA, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'h55555555, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'hAAAAAAAA, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'h55555555, 16, 32);
            end
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'hAAAAAAAA, 16, 32);
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'hAAAAAAAA, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'hAAAAAAAA, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'hAAAAAAAA, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'hAAAAAAAA, 16, 32);
            end
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'hAAAAAAAA, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0034, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0034, 32'hAAAAAAAA, 16, 32);
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'hAAAAAAAA, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 32'h55555555, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'hAAAAAAAA, 16, 32);
               MultipleTapRegisterAccess(NO_RST, 16'h0012, 32'h55555555, 16, 32);
            end
            MultipleTapRegisterAccess(NO_RST, 16'h0010, 32'hAAAAAAAA, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0010, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h00DA, 32'hAAAAAAAA, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h00Da, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h00CC, 32'hAAAAAAAA, 16, 32);

            LoadIR(NO_RST,16'h00_14,16'h0001,16'h0000,16);
            LoadDR(NO_RST,1'b1,1'b1,1'b0,1);
            exp_data = Actual_Tdo_Collected();
            Goto(ST_UPDR,1);
            Goto(ST_RUTI,11);
        end // begin (SIZE_OF_IR_REG_STAP == 16)

        //------------------------------
        if (SIZE_OF_IR_REG_STAP == 8) begin
            MultipleTapRegisterAccess(NO_RST, 8'hFF, 32'hF5A0F0A5, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h55, 32'hF5A0F0A5, 8, 33);
            MultipleTapRegisterAccess(NO_RST, 8'hAA, 32'hF5A0F0A5, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h00, 32'hF5A0F0A5, 8, 32);
            // VISA Register Access Assuming 4 VISA register
            // Attempt to toggle all the data Bits for each Reg
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h000FFFFFFFF, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h00055555555, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h000AAAAAAAA, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h00000000000, 8, 42);

            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h001FFFFFFFF, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h00155555555, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h001AAAAAAAA, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h00100000000, 8, 42);

            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h002FFFFFFFF, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h00255555555, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h002AAAAAAAA, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h00200000000, 8, 42);

            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h003FFFFFFFF, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h00355555555, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h003AAAAAAAA, 8, 42);
            //MultipleTapRegisterAccess(NO_RST, 8'h15, 42'h00300000000, 8, 42);
            //for resets
            //MultipleTapRegisterAccess(NO_RST, 16'h0015, 2'h00, 16, 2);
            //MultipleTapRegisterAccess(NO_RST, 16'h0034, 32'hFFFFFFFF, 16, 32);
            //MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h55555555, 16, 32);
            //MultipleTapRegisterAccess(NO_RST, 16'h0016, 2'h00, 16, 2);
            //MultipleTapRegisterAccess(2'b01, 16'h0034, 32'hFFFFFFFF, 16, 32);
            //MultipleTapRegisterAccess(2'b10, 16'h0034, 32'h55555555, 16, 32);

            // Optional Register #1
            MultipleTapRegisterAccess(NO_RST, 8'h34, 32'hFFFFFFFF, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h34, 32'h55555555, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h34, 32'hAAAAAAAA, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h34, 32'h00000000, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h34, 32'hFFFFFFFF, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h34, 32'h55555555, 8, 32);
            // Optional Register #2
            //MultipleTapRegisterAccess(2'b01, 16'h006B, 32'hFFFFFFFF, 16, 32);
            //MultipleTapRegisterAccess(2'b10, 16'h006B, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'hFFFFFFFF, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h55555555, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'hAAAAAAAA, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h00000000, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'hFFFFFFFF, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h55555555, 8, 32);
            // SELECT Register Access
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'hFFFFFFFF, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'h55555555, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'hAAAAAAAA, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'h00000000, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'hFFFFFFFF, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'h55555555, 8, 32);
            end
            // SELECT  Override Register Access
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'hFFFFFFFF, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'h55555555, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'hAAAAAAAA, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'h00000000, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'hFFFFFFFF, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'h55555555, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'h00000000, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'h00000000, 8, 32);
            end
            // SELECT  Override Register Access
            MultipleTapRegisterAccess(NO_RST, 8'h13, 32'hFFFFFFFF, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h13, 32'h55555555, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h13, 32'hAAAAAAAA, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h13, 32'h00000000, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h13, 32'hFFFFFFFF, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h13, 32'h55555555, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h13, 32'h00000000, 8, 32);
            // IDCODE Access
            MultipleTapRegisterAccess(NO_RST, 8'h0C, 32'h00000000, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h0C, 32'hAAAAAAAA, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h0C, 32'h55555555, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h0C, 32'hFFFFFFFF, 8, 32);

            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'hAAAAAAAA, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'h55555555, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'hAAAAAAAA, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'h55555555, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'hAAAAAAAA, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'h55555555, 8, 32);
            end
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'hAAAAAAAA, 8, 32);
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'hAAAAAAAA, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'hAAAAAAAA, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'hAAAAAAAA, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'hAAAAAAAA, 8, 32);
            end
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h55555555, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'hAAAAAAAA, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h34, 32'h55555555, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h34, 32'hAAAAAAAA, 8, 32);
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'hAAAAAAAA, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h11, 32'h55555555, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'hAAAAAAAA, 8, 32);
               MultipleTapRegisterAccess(NO_RST, 8'h12, 32'h55555555, 8, 32);
            end
            MultipleTapRegisterAccess(NO_RST, 8'h10, 32'hAAAAAAAA, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h10, 32'h55555555, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'hDA, 32'hAAAAAAAA, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'hDa, 32'h55555555, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'hCC, 32'hAAAAAAAA, 8, 32);

            LoadIR(NO_RST,8'h14,8'h01,8'h00,8);
            LoadDR(NO_RST,1'b1,1'b1,1'b0,1);
            exp_data = Actual_Tdo_Collected();
            Goto(ST_UPDR,1);
            Goto(ST_RUTI,11);
        end // (SIZE_OF_IR_REG_STAP == 8)
        //------------------------------

    endtask : body

endclass : TapSequenceMultipleTapRegisterAccess

//------------------------------------------------------------------------------
// Access WTAP NETWORK and 0.7 TAP NW Registers and then access Data Registers
//------------------------------------------------------------------------------
class TapSequenceNetworkRegisterAccess extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceNetworkRegisterAccess");
        super.new(name);
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(TapSequenceNetworkRegisterAccess, JtagBfmSequencer)

    virtual task body();
        //Idle(30);
        //ForceReset(RST_HARD,1'b0);
        //Idle(30);
        //ForceReset(RST_PWRGUD,1'b1);
        //Idle(30);
        //ForceReset(RST_HARD,1'b1);
        //Idle(30);
        //Reset(RST_PWRGUD);
        //------------------------------
        if (SIZE_OF_IR_REG_STAP == 16) begin
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 10'h3FF, 16, 10);
            end
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h11111111, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0013, 3'h7, 16, 3);
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h22222222, 16, 32);
            //Reset(RST_PWRGUD);
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 10'h000, 16, 10);
            end
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h33333333, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0013, 3'h3, 16, 3);
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h44444444, 16, 32);
            //Reset(RST_PWRGUD);
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 10'h000, 16, 10);
            end
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0013, 3'h1, 16, 3);
            MultipleTapRegisterAccess(NO_RST, 16'h016B, 32'h66666666, 16, 32);
            //Reset(RST_PWRGUD);
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 16'h0011, 10'h000, 16, 10);
            end
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h55555555, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0013, 3'h0, 16, 3);
            MultipleTapRegisterAccess(NO_RST, 16'h006B, 32'h66666666, 16, 32);
        end
        //------------------------------
        if (SIZE_OF_IR_REG_STAP == 8) begin
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 8'h11, 10'h3FF, 8, 10);
            end
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h11111111, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h13, 3'h7, 8, 3);
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h22222222, 8, 32);
            //Reset(RST_PWRGUD);
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 8'h11, 10'h000, 8, 10);
            end
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h33333333, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h13, 3'h3, 8, 3);
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h44444444, 8, 32);
            //Reset(RST_PWRGUD);
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 8'h11, 10'h000, 8, 10);
            end
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h55555555, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h13, 3'h1, 8, 3);
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h66666666, 8, 32);
            //Reset(RST_PWRGUD);
            if(STAP_EN_TAP_NETWORK == 1) begin
               MultipleTapRegisterAccess(NO_RST, 8'h11, 10'h000, 8, 10);
            end
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h55555555, 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h13, 3'h0, 8, 3);
            MultipleTapRegisterAccess(NO_RST, 8'h6B, 32'h66666666, 8, 32);
        end
        //------------------------------
    endtask : body

endclass : TapSequenceNetworkRegisterAccess

//---------------------------------------
// Access Boundary Scan Registers
//---------------------------------------
class TapSequenceBoundaryRegisterAccess extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceBoundaryRegisterAccess");
        super.new(name);
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(TapSequenceBoundaryRegisterAccess, JtagBfmSequencer)

    virtual task body();
        Reset(RST_PWRGUD);
        //------------------------------
        if (SIZE_OF_IR_REG_STAP == 16) begin
            //Mandatory Boundary Scans
            MultipleTapRegisterAccess(NO_RST, 16'h0001, 3'h5, 16, 3); // SAMPLE+PRELOAD
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0008, 3'h5, 16, 3); // HIGHZ
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0009, 3'h2, 16, 3); // EXTEST
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h000A, 3'h5, 16, 3); // RESIRA
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h000B, 3'h2, 16, 3); // RESIRB
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h000C, 3'h5, 16, 3); // SLVIDCODE
            //Optional Boundary scan
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0003, 3'h5, 16, 3); // PRELOAD
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0004, 3'h5, 16, 3); // CLAMP
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0005, 3'h5, 16, 3); // USERCODE
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0006, 3'h5, 16, 3); // INTEST
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0007, 3'h5, 16, 3); // RUNBIST
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h000D, 3'h5, 16, 3); // EXTEST_TOGGLE
            repeat (10) Goto(ST_RUTI,10);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h000E, 3'h5, 16, 3); // EXTEST_PULSE
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h000F, 3'h5, 16, 3); // EXTEST_TRAIN
            repeat (10) Goto(ST_RUTI,10);
            Reset(RST_HARD);
        end
        //------------------------------
        if (SIZE_OF_IR_REG_STAP == 8) begin
            //Mandatory Boundary Scans
            MultipleTapRegisterAccess(NO_RST, 8'h01, 3'h5, 8, 3); // SAMPLE+PRELOAD
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h08, 3'h5, 8, 3); // HIGHZ
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h09, 3'h2, 8, 3); // EXTEST
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h0A, 3'h5, 8, 3); // RESIRA
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h0B, 3'h2, 8, 3); // RESIRB
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h0C, 3'h5, 8, 3); // SLVIDCODE
            //Optional Boundary scan
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h03, 3'h5, 8, 3); // PRELOAD
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h04, 3'h5, 8, 3); // CLAMP
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h05, 3'h5, 8, 3); // USERCODE
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h06, 3'h5, 8, 3); // INTEST
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h07, 3'h5, 8, 3); // RUNBIST
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h0D, 3'h5, 8, 3); // EXTEST_TOGGLE
            repeat (10) Goto(ST_RUTI,10);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h0E, 3'h5, 8, 3); // EXTEST_PULSE
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h0F, 3'h5, 8, 3); // EXTEST_TRAIN
            repeat (10) Goto(ST_RUTI,10);
            Reset(RST_HARD);
        end
        //------------------------------
    endtask : body

endclass : TapSequenceBoundaryRegisterAccess

//----------------------------------------------------------------
// Transit all the FSM States and Follow it with Register Access
//----------------------------------------------------------------
class TapSequenceFsmStates extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceFsmStates");
        super.new(name);
        Packet =JtagBfmSeqDrvPkt::type_id::create("Packet") ;
    endfunction : new

    `ovm_sequence_utils(TapSequenceFsmStates, JtagBfmSequencer)

    virtual task body();
        Reset(RST_PWRGUD);
        //------------------------------
        if(SIZE_OF_IR_REG == 16) begin
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_TLRS,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_SDRS,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_CADR,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_SHDR,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_E1DR,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_PADR,4);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_E2DR,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_UPDR,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_RUTI,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_SIRS,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_CAIR,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_SHIR,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_E1IR,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_PAIR,4);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_E2IR,1);
            MultipleTapRegisterAccess(RST_HARD,16'h00FF,32'hAAAAAAAA, 16, 32);
            Goto(ST_UPIR,1);
            Reset(RST_PWRGUD);
        end
        //------------------------------
        if(SIZE_OF_IR_REG == 8) begin
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_TLRS,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_SDRS,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_CADR,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_SHDR,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_E1DR,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_PADR,4);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_E2DR,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_UPDR,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_RUTI,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_SIRS,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_CAIR,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_SHIR,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_E1IR,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_PAIR,4);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_E2IR,1);
            MultipleTapRegisterAccess(RST_HARD,16'hFF,32'hAAAAAAAA, 8, 32);
            Goto(ST_UPIR,1);
            Reset(RST_PWRGUD);
        end
        //------------------------------
        if(SIZE_OF_IR_REG == 16) begin
            LoadIR(NO_RST,16'hFF_FF,16'h01_01,16'h0000,16);
        end else if (SIZE_OF_IR_REG == 8) begin
            LoadIR(NO_RST,8'hFF,8'h01,8'h00,8);
        end
        Goto(ST_E2IR,1);
        tms_tdi_stream(22'h3E0000,22'h0,22);
        LoadDR(NO_RST,16'hFF_FF,16'h00_00,16'h0000,16);
        Goto(ST_E2DR,1);
        tms_tdi_stream(38'h3E00000000,38'h0,38);
        //------------------------------
    endtask : body

endclass : TapSequenceFsmStates

//--------------------------------------------------------------------
// Produce TMS Glitch at ST_TLRS and follow it with TMS High for 3 Cycle
//--------------------------------------------------------------------
class TapSequenceTmsGlitch extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceTmsGlitch");
        super.new(name);
        Packet =JtagBfmSeqDrvPkt::type_id::create("Packet") ;
    endfunction : new

    `ovm_sequence_utils(TapSequenceTmsGlitch, JtagBfmSequencer)

    virtual task body();
        Reset(RST_PWRGUD);
        Reset(RST_HARD);
        Goto(4'b0000,5);
        Goto(4'b1001,1);
        Goto(4'b0000,3);
        if(SIZE_OF_IR_REG == 16) begin
        MultipleTapRegisterAccess(NO_RST, 16'h00FF, 32'hAAAAAAAA, 16, 32);
        end
        if(SIZE_OF_IR_REG == 8) begin
        MultipleTapRegisterAccess(NO_RST, 8'hFF, 32'hAAAAAAAA, 8, 32);
        end
        Goto(4'b0000,5);
        Goto(4'b1001,1);
        Goto(4'b0000,3);
    endtask : body

endclass : TapSequenceTmsGlitch

//--------------------------------------------------------------------
// Random Sequences
//--------------------------------------------------------------------
class TapSequenceRandom extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceRandom");
        super.new(name);
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(TapSequenceRandom, JtagBfmSequencer)

    //Local Variable Declaration
    rand bit [SIZE_OF_IR_REG-1:0]                   addr;
    rand bit [TOTAL_DATA_REGISTER_WIDTH-1:0]        data;
    rand bit [1:0]                                  resetmode;
    bit      [(NO_OF_RW_REG*SIZE_OF_IR_REG)-1:0]    con_rw_reg_addr;
    //Array of Data Registers present
    bit      [NO_OF_RW_REG-1:0][SIZE_OF_IR_REG-1:0] addr_array;
    bit      [SIZE_OF_IR_REG-1:0]                   mask_bit_vector;
    //random variable to select random task and for random no of times
    rand int no_of_regress_call;
    rand int random_task_call;
    rand int rand_addr_index;
    //Constraint for Random variables
    constraint con_regress_no {((no_of_regress_call < 1600) && (no_of_regress_call >10));}
    constraint con_task_call  {((random_task_call <=2) && (random_task_call>=0));}
    constraint con_addr_index {if(NO_OF_RW_REG > 2) (rand_addr_index > 0) && (rand_addr_index < (NO_OF_RW_REG - 1));else rand_addr_index == 0;}
    constraint con_reset_mode { resetmode == RST_PWRGUD;}

    integer i,k,task_select;

    virtual task body();
        Reset(RST_PWRGUD);
        randomize_task();
    endtask : body
        //********************************************
        // RANDOM TASK
        //********************************************
    task randomize_task;
    begin
        bit [SIZE_OF_IR_REG - 1 : 0 ] address;
        Reset(RST_HARD);
        randomize();
        k           = no_of_regress_call;
        task_select = random_task_call;

        for(i = 0; i < k; i++)
        begin
            if(task_select == 0)
            begin
              address = rand_addr();
              if((STAP_EN_TAP_NETWORK == 0 | STAP_EN_WTAP_NETWORK == 0) && (address == 'h11 | address == 'h12 | address == 'h13)) begin
                  data = 0;
              end
              if(SIZE_OF_IR_REG == 16) begin
                  MultipleTapRegisterAccess(resetmode,address,data, 16, 32);
              end
              if(SIZE_OF_IR_REG == 8) begin
                  MultipleTapRegisterAccess(resetmode,address,data, 8, 32);
              end
              //If the addr is for Boundary Scan Register; Register Access should be followed By Reset
              if(address <= 'h0F)
                  Reset(RST_PWRGUD);
            end
            else if(task_select == 1)
            begin
              randomize() with { addr > 0;};
              if((STAP_EN_TAP_NETWORK == 0 | STAP_EN_WTAP_NETWORK == 0) && (addr == 'h11 | addr == 'h12 | addr == 'h13)) begin
                  data = 0;
              end
              if(SIZE_OF_IR_REG == 16) begin
                  MultipleTapRegisterAccess(resetmode,address,data, 16, 32);
              end
              if(SIZE_OF_IR_REG == 8) begin
                  MultipleTapRegisterAccess(resetmode,address,data, 8, 32);
              end

              //If the addr is for Boundary Scan Register; Register Access should be followed By Reset
              if(addr <= 'h0F)
                  Reset(RST_PWRGUD);
            end
            else if(task_select == 2)
            begin
              randomize();
              Reset(resetmode);
            end
        randomize();
        task_select = random_task_call;
        end//for
    end
    endtask;

    function bit[15:0] rand_addr();
        int i;
        con_rw_reg_addr = RW_REG_ADDR;
        for(i=0;i<SIZE_OF_IR_REG;i++)begin
            mask_bit_vector[i] = 1'b1;
        end
        for(i=0;i<NO_OF_RW_REG;i++) begin
            addr_array[i] = (((con_rw_reg_addr) >> (i*SIZE_OF_IR_REG_STAP)) & mask_bit_vector);
        end
        randomize();
        rand_addr = addr_array[rand_addr_index];
    endfunction

endclass : TapSequenceRandom

//--------------------------------------------------------------------
// RemoteTDR
//--------------------------------------------------------------------
class TapSequenceRemoteTDR extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceRemoteTDR");
        super.new(name);
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(TapSequenceRemoteTDR, JtagBfmSequencer)

    virtual task body();
        logic [TOTAL_DATA_REGISTER_WIDTH-1:0] tdodata;
        //Reset(RST_PWRGUD);
        //Reset(RST_HARD);
        if(SIZE_OF_IR_REG == 16) begin

            //Bypass
            ExpData_MultipleTapRegisterAccess(NO_RST,         // Assert trst_b
                                              16'h00FF,       // Remote TDR Address Opcode
                                              16,             // Address Length
                                              32'hFFFF_FFFF,  // The data that needs to be loaded in selected register
                                              32'hFFFF_FFFE,  // The data that would come out
                                              32'hFFFF_FFFF,  // (Mask) The fields of Expected_Data that need to be compared with Data
                                              32);            // Data Width
            Goto(ST_UPDR,1);
            Goto(ST_RUTI,11);
            //Fixed OVM checklist item : Do not have # delays 
            //#500ns;
            Idle(50);

            //Access External TDR0
            LoadIR(NO_RST, 16'h0036, 16'h0001, 16'hFFFF, 16); Goto(ST_UPIR,1); Goto(ST_RUTI,11);
                                  //GoesInside   //ComesOut     //Mask
            LoadDR_Pause(NO_RST, 32'h1111_1111, 32'hABCD_EF98, 32'h0000_0000, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR_Pause(NO_RST, 32'h2222_2222, 32'h1111_1111, 32'hFFFF_FFFF, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR_Pause(NO_RST, 32'h3333_3333, 32'h2222_2222, 32'hFFFF_FFFF, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR_Pause(NO_RST, 32'h4444_4444, 32'h3333_3333, 32'hFFFF_FFFF, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR_Pause(NO_RST, 32'h5555_5555, 32'h4444_4444, 32'hFFFF_FFFF, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR_Pause(NO_RST, 32'h6666_6666, 32'h5555_5555, 32'hFFFF_FFFF, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR_Pause(NO_RST, 32'h7777_7777, 32'h6666_6666, 32'hFFFF_FFFF, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR_Pause(NO_RST, 32'h5A5A_5A5A, 32'h7777_7777, 32'hFFFF_FFFF, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR_Pause(NO_RST, 32'h7777_7777, 32'h5A5A_5A5A, 32'hFFFF_FFFF, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);

            //Access External TDR1 in TCK mode
            LoadIR(NO_RST, 16'h0046, 16'h0001, 16'hFFFF, 16); Goto(ST_UPIR,1); Goto(ST_RUTI,11);
                                  //GoesInside   //ComesOut     //Mask
            LoadDR(NO_RST, 32'hFEFE_FEFE, 32'hABCD_EF98, 32'h0000_0000, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR(NO_RST, 32'hFEFE_FEFE, 32'hFEFE_FEFE, 32'h0000_0000, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);

            //Clearing thru SWCLR.
            MultipleTapRegisterAccess(NO_RST, 16'h0015, 2'b10,  16, 2);
            MultipleTapRegisterAccess(NO_RST, 16'h0017, 3'b111, 16, 3);
            MultipleTapRegisterAccess(NO_RST, 16'h0017, 3'b000, 16, 3);

            //Access Internal TDR
                                                                     //GoesInside   //ComesOut     //Mask
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0034, 16, 32'h0000_0000, 32'hAA55_6699, 32'hFFFF_0000, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h006B, 16, 32'hFFFF_0000, 32'h99AA_5566, 32'hFFFF_FFFF, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h006B, 16, 32'hAAAA_0000, 32'hFFFF_0000, 32'hFFFF_FFFF, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h006B, 16, 32'h5555_0000, 32'hAAAA_0000, 32'hFFFF_FFFF, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            //Fixed OVM checklist item : Do not have # delays 
            //#1000ns;
            Idle(100);

            //Access External TDR2
            LoadIR(NO_RST, 16'h0056, 16'h0001, 16'hFFFF, 16); Goto(ST_UPIR,1); Goto(ST_RUTI,11);
                                  //GoesInside   //ComesOut     //Mask
            LoadDR_Pause(NO_RST, 32'h5A5A_5A5A, 32'h1111_1111, 32'h0000_0000, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR_Pause(NO_RST, 32'hABCD_1234, 32'h5A5A_5A5A, 32'hFFFF_FFFF, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR_Pause(NO_RST, 32'hFEDC_9876, 32'hABCD_1234, 32'hFFFF_FFFF, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            LoadDR_Pause(NO_RST, 32'h5555_BBBB, 32'hFEDC_9876, 32'hFFFF_FFFF, 32, 5); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
            Goto(ST_TLRS,100);

            //Clearing thru TRST_B
            MultipleTapRegisterAccess(NO_RST, 16'h0015, 2'b01,  16, 2);
            MultipleTapRegisterAccess(NO_RST, 16'h0017, 3'b111, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0017, 3'b000, 16, 3);

            //Access the Remote TDR's.
            MultipleTapRegisterAccess(NO_RST, 16'h0036, 32'hAAAA_BBBB, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0046, 32'hCCCC_DDDD, 16, 32);
            MultipleTapRegisterAccess(NO_RST, 16'h0066, 32'hEEEE_FFFF, 16, 32);

            //Clearing thru TRST_B
            MultipleTapRegisterAccess(NO_RST, 16'h0015, 2'b11,  16, 2);
            MultipleTapRegisterAccess(NO_RST, 16'h0017, 3'b111, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0017, 3'b000, 16, 3);



        end
    endtask : body

endclass : TapSequenceRemoteTDR

//--------------------------------------------------------------------
// Try
//--------------------------------------------------------------------
class TapSequenceTry extends JtagBfmSequences;

    function new(string name = "TapSequenceTry");
        super.new(name);
        //Packet = new;
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(TapSequenceTry, JtagBfmSequencer)

    virtual task body();
        logic [TOTAL_DATA_REGISTER_WIDTH-1:0] tdodata;
        Reset(RST_PWRGUD);
        Reset(RST_HARD);

        // Added these three lines for checking if the 2nd E_MTRA goes directly to SDRS FSM state
        ExpData_MultipleTapRegisterAccess(NO_RST, 08'hFF, 08, 32'hFFFF_FFFF, 32'hFFFF_FFFE, 32'hFFFF_FFFF, 32);
        ExpData_MultipleTapRegisterAccess(NO_RST, 08'h02, 08, 32'hFFFF_FFFF, 32'hFFFF_FFFE, 32'hFFFF_FFFF, 32);
        Goto(ST_RUTI,11);

    //-
    //-    //-----------------------------------
    //-    // Min Config Registers are 00, FF, 50
    //-    // Access 02 and see if it is bypass.
    //-    ExpData_MultipleTapRegisterAccess(NO_RST, 08'hFF, 08, 32'hFFFF_FFFF, 32'hFFFF_FFFE, 32'hFFFF_FFFF, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
    //-    ExpData_MultipleTapRegisterAccess(NO_RST, 08'h02, 08, 32'hFFFF_FFFF, 32'hFFFF_FFFE, 32'hFFFF_FFFF, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
    //-    ExpData_MultipleTapRegisterAccess(NO_RST, 08'h05, 08, 32'hFFFF_FFFF, 32'hFFFF_FFFE, 32'hFFFF_FFFF, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
    //-    ExpData_MultipleTapRegisterAccess(NO_RST, 08'h0A, 08, 32'hFFFF_FFFF, 32'hFFFF_FFFE, 32'hFFFF_FFFF, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
    //-    ExpData_MultipleTapRegisterAccess(NO_RST, 08'h0B, 08, 32'hFFFF_FFFF, 32'hFFFF_FFFE, 32'hFFFF_FFFF, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
    //-    //ExpData_MultipleTapRegisterAccess(NO_RST, 08'h0E, 08, 32'hFFFF_FFFF, 32'hFFFF_FFFE, 32'hFFFF_FFFF, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
    //-    //ExpData_MultipleTapRegisterAccess(NO_RST, 08'h0F, 08, 32'hFFFF_FFFF, 32'hFFFF_FFFE, 32'hFFFF_FFFF, 32); Goto(ST_UPDR,1); Goto(ST_RUTI,11);
    //-    //-----------------------------------

        //-----------------------------------
        if(SIZE_OF_IR_REG == 16) begin
            LoadIR(NO_RST,16'h0034,16'h0101,16'h0000,16);
            LoadDR_Pause(NO_RST,32'h1234_5678,32'h0000_0000,32'h0000_0000,32,10);
        end else if (SIZE_OF_IR_REG == 8) begin
            LoadIR(NO_RST,8'h34,8'h01,8'h00,8);
            LoadDR_Pause(NO_RST,32'h1234_5678,32'h0000_0000,32'h0000_0000,32,10);
        end


    endtask : body

endclass : TapSequenceTry

//----------------------------------------------------------
// Access Boundary Scan Registers Without Reset In Between
// This Test Disables the ScoreBoard and Uses the Expect Data Test
// As the ScoreBoard has Limitations on Testing for Boundary Scan
// Register if accessed Back to back without Reset
//----------------------------------------------------------
class TapSequenceBoundaryRegisterAccessWoReset extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceBoundaryRegisterAccessWoReset");
        super.new(name);
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(TapSequenceBoundaryRegisterAccessWoReset, JtagBfmSequencer)

    virtual task body();
        Reset(RST_PWRGUD);
        Reset(RST_HARD);

        if (SIZE_OF_IR_REG_STAP == 16) begin
            //Mandatory Boundary Scans
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0001,16,3'h5,3'b000,3'b111,3); // SAMPLE+PRELOAD
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0008,16,3'h5,3'b010,3'b111,3); // HIGHZ
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0009,16,3'h2,3'b101,3'b111,3); // EXTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h000A,16,3'h5,3'b010,3'b111,3); // RESIRA
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h000B,16,3'h5,3'b010,3'b111,3); // RESIRB
            //Optional Boundary scan
            //---Reset(RST_HARD);
            //---ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0003,16,3'h5,3'b000,3'b111,3); // PRELOAD
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0003,16,3'h5,3'b010,3'b111,3); // PRELOAD
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0004,16,3'h5,3'b010,3'b111,3); // CLAMP
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0005,16,3'h5,3'b010,3'b111,3); // USERCODE
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0006,16,3'h5,3'b101,3'b111,3); // INTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0007,16,3'h5,3'b010,3'b111,3); // RUNBIST
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h000D,16,3'h5,3'b101,3'b111,3); // EXTEST_TOGGLE
            repeat (10) Goto(ST_RUTI,10);
            //---Reset(RST_HARD);
            //---ExpData_MultipleTapRegisterAccess(NO_RST, 16'h000E,16,3'h5,3'b000,3'b111,3); // EXTEST_PULSE
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h000E,16,3'h5,3'b101,3'b111,3); // EXTEST_PULSE
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h000F,16,3'h5,3'b101,3'b111,3); // EXTEST_TRAIN
            repeat (10) Goto(ST_RUTI,10);
            //Preload Followed By Intest
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0003,16,3'h5,3'b101,3'b111,3); // PRELOAD
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0006,16,3'h5,3'b101,3'b111,3); // INTEST
            //---Reset(RST_HARD);
            //Extest Followed by Sample
            //---ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0009,16,3'h2,3'b000,3'b111,3); // EXTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0009,16,3'h2,3'b101,3'b111,3); // EXTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0001,16,3'h5,3'b010,3'b111,3); // SAMPLE+PRELOAD
            //---Reset(RST_HARD);
            // Random Instruction Sequence
            //---ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0005,16,3'h5,3'b010,3'b111,3); // USERCODE
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0005,16,3'h5,3'b010,3'b111,3); // USERCODE
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h000A,16,3'h5,3'b010,3'b111,3); // RESIRA
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0007,16,3'h5,3'b010,3'b111,3); // RUNBIST
            //ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0009,16,3'h2,3'b000,3'b111,3); // EXTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0009,16,3'h2,3'b101,3'b111,3); // EXTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0001,16,3'h5,3'b010,3'b111,3); // SAMPLE+PRELOAD
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h000B,16,3'h2,3'b100,3'b111,3); // RESIRB
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0008,16,3'h5,3'b010,3'b111,3); // HIGHZ
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h000E,16,3'h5,3'b101,3'b111,3); // EXTEST_PULSE
            ExpData_MultipleTapRegisterAccess(NO_RST, 16'h0004,16,3'h5,3'b010,3'b111,3); // CLAMP
        end
        if (SIZE_OF_IR_REG_STAP == 8) begin
            //Mandatory Boundary Scans
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h01,8,3'h5,3'b000,3'b111,3); // SAMPLE+PRELOAD
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h08,8,3'h5,3'b010,3'b111,3); // HIGHZ
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h09,8,3'h2,3'b101,3'b111,3); // EXTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h0A,8,3'h5,3'b010,3'b111,3); // RESIRA
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h0B,8,3'h5,3'b010,3'b111,3); // RESIRB
            //Optional Boundary scan
            //---Reset(RST_HARD);
            //---ExpData_MultipleTapRegisterAccess(NO_RST, 8'h03,8,3'h5,3'b000,3'b111,3); // PRELOAD
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h03,8,3'h5,3'b010,3'b111,3); // PRELOAD
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h04,8,3'h5,3'b010,3'b111,3); // CLAMP
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h05,8,3'h5,3'b010,3'b111,3); // USERCODE
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h06,8,3'h5,3'b101,3'b111,3); // INTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h07,8,3'h5,3'b010,3'b111,3); // RUNBIST
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h0D,8,3'h5,3'b101,3'b111,3); // EXTEST_TOGGLE
            repeat (10) Goto(ST_RUTI,10);
            //---Reset(RST_HARD);
            //---ExpData_MultipleTapRegisterAccess(NO_RST, 8'h0E,8,3'h5,3'b000,3'b111,3); // EXTEST_PULSE
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h0E,8,3'h5,3'b101,3'b111,3); // EXTEST_PULSE
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h0F,8,3'h5,3'b101,3'b111,3); // EXTEST_TRAIN
            repeat (10) Goto(ST_RUTI,10);
            //Preload Followed By Intest
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h03,8,3'h5,3'b101,3'b111,3); // PRELOAD
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h06,8,3'h5,3'b101,3'b111,3); // INTEST
            //---Reset(RST_HARD);
            //Extest Followed by Sample
            //---ExpData_MultipleTapRegisterAccess(NO_RST, 8'h09,8,3'h2,3'b000,3'b111,3); // EXTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h09,8,3'h2,3'b101,3'b111,3); // EXTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h01,8,3'h5,3'b010,3'b111,3); // SAMPLE+PRELOAD
            //---Reset(RST_HARD);
            // Random Instruction Sequence
            //---ExpData_MultipleTapRegisterAccess(NO_RST, 8'h05,8,3'h5,3'b010,3'b111,3); // USERCODE
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h05,8,3'h5,3'b010,3'b111,3); // USERCODE
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h0A,8,3'h5,3'b010,3'b111,3); // RESIRA
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h07,8,3'h5,3'b010,3'b111,3); // RUNBIST
            //ExpData_MultipleTapRegisterAccess(NO_RST, 8'h09,8,3'h2,3'b000,3'b111,3); // EXTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h09,8,3'h2,3'b101,3'b111,3); // EXTEST
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h01,8,3'h5,3'b010,3'b111,3); // SAMPLE+PRELOAD
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h0B,8,3'h2,3'b100,3'b111,3); // RESIRB
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h08,8,3'h5,3'b010,3'b111,3); // HIGHZ
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h0E,8,3'h5,3'b101,3'b111,3); // EXTEST_PULSE
            ExpData_MultipleTapRegisterAccess(NO_RST, 8'h04,8,3'h5,3'b010,3'b111,3); // CLAMP
        end

    endtask : body

endclass : TapSequenceBoundaryRegisterAccessWoReset

class TapSequenceReservedOpcodeAccess extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceReservedOpcodeAccess");
        super.new(name);
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(TapSequenceReservedOpcodeAccess, JtagBfmSequencer)

    virtual task body();
        //Reset(RST_PWRGUD);
        //------------------------------
        if (SIZE_OF_IR_REG_STAP == 16) begin
            MultipleTapRegisterAccess(NO_RST, 16'h0001, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0002, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0003, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0004, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0005, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0006, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0007, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0008, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0009, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h000A, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h000B, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h000D, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h000E, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h000F, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0018, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0019, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h001A, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h001B, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h001C, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0012, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h001D, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h001E, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h001F, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0020, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0021, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0022, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0023, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0024, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0025, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0026, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0027, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0028, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h0029, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h002A, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h002B, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h002C, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h002D, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h002E, 3'h5, 16, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 16'h002F, 3'h5, 16, 3);
            Reset(RST_HARD);
        end
        //------------------------------
        if (SIZE_OF_IR_REG_STAP == 8) begin
            //Mandatory Boundary Scans
            MultipleTapRegisterAccess(NO_RST, 8'h01, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h02, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h03, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h04, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h05, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h06, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h07, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h08, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h09, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h0A, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h0B, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h0D, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h0E, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h0F, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h18, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h19, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h1A, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h1B, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h1C, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h12, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h1D, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h1E, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h1F, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h20, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h21, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h22, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h23, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h24, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h25, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h26, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h27, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h28, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h29, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h2A, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h2B, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h2C, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h2D, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h2E, 3'h5, 8, 3);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h2F, 3'h5, 8, 3);
            Reset(RST_HARD);
        end
        //------------------------------
    endtask : body

endclass : TapSequenceReservedOpcodeAccess

class TapSequenceProgRstITDR extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceProgRstITDR");
        super.new(name);
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(TapSequenceProgRstITDR, JtagBfmSequencer)

    virtual task body();
            // SWCLR Reset sequences for iTDR's
            MultipleTapRegisterAccess(NO_RST, 8'h15,  2'b10                 , 8,  2);
            MultipleTapRegisterAccess(NO_RST, 8'h44,  4'hC                  , 8,  4);
            MultipleTapRegisterAccess(NO_RST, 8'h43,  8'h44                 , 8,  8);
            MultipleTapRegisterAccess(NO_RST, 8'h42, 16'h8888               , 8, 16);
            MultipleTapRegisterAccess(NO_RST, 8'h41, 32'h2222_3333          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h40, 64'hBBBB_CCCC_DDDD_EEEE, 8, 64);
            MultipleTapRegisterAccess(NO_RST, 8'h16,  5'b11111              , 8,  5);
            MultipleTapRegisterAccess(NO_RST, 8'h16,  5'b00000              , 8,  5);

            // 5 TMS Reset sequences for iTDR's
            MultipleTapRegisterAccess(NO_RST, 8'h15,  2'b01                 , 8,  2);
            MultipleTapRegisterAccess(NO_RST, 8'h16,  5'b11111              , 8,  5);
            MultipleTapRegisterAccess(NO_RST, 8'h44,  4'hC                  , 8,  4);
            MultipleTapRegisterAccess(NO_RST, 8'h43,  8'h44                 , 8,  8);
            MultipleTapRegisterAccess(NO_RST, 8'h42, 16'h8888               , 8, 16);
            MultipleTapRegisterAccess(NO_RST, 8'h41, 32'h2222_3333          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h40, 64'hBBBB_CCCC_DDDD_EEEE, 8, 64);
            Reset(RST_SOFT);
            MultipleTapRegisterAccess(NO_RST, 8'h16,  5'b00000              , 8,  5);

            // TRST_B Reset sequences for iTDR's
            MultipleTapRegisterAccess(NO_RST, 8'h15,  2'b01                 , 8,  2);
            MultipleTapRegisterAccess(NO_RST, 8'h16,  5'b11111              , 8,  5);
            MultipleTapRegisterAccess(NO_RST, 8'h44,  4'hC                  , 8,  4);
            MultipleTapRegisterAccess(NO_RST, 8'h43,  8'h44                 , 8,  8);
            MultipleTapRegisterAccess(NO_RST, 8'h42, 16'h8888               , 8, 16);
            MultipleTapRegisterAccess(NO_RST, 8'h41, 32'h2222_3333          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h40, 64'hBBBB_CCCC_DDDD_EEEE, 8, 64);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h16,  5'b00000              , 8,  5);

            // SWCLR Reset sequences for iTDR's
            MultipleTapRegisterAccess(NO_RST, 8'h15,  2'b10                 , 8,  2);
            MultipleTapRegisterAccess(NO_RST, 8'h44,  4'hC                  , 8,  4);
            MultipleTapRegisterAccess(NO_RST, 8'h43,  8'h44                 , 8,  8);
            MultipleTapRegisterAccess(NO_RST, 8'h42, 16'h8888               , 8, 16);
            MultipleTapRegisterAccess(NO_RST, 8'h41, 32'h2222_3333          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h40, 64'hBBBB_CCCC_DDDD_EEEE, 8, 64);
            MultipleTapRegisterAccess(NO_RST, 8'h16,  5'b11111              , 8,  5);
            MultipleTapRegisterAccess(NO_RST, 8'h16,  5'b00000              , 8,  5);

    endtask : body

endclass : TapSequenceProgRstITDR


class TapSequenceProgRstRTDR extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceProgRstRTDR");
        super.new(name);
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(TapSequenceProgRstRTDR, JtagBfmSequencer)

    virtual task body();
            // TRST_B Reset sequences for RTDR's
            MultipleTapRegisterAccess(NO_RST, 8'h15,  2'b11                 , 8,  2);
            MultipleTapRegisterAccess(NO_RST, 8'h17,  5'b11111              , 8,  5);
            MultipleTapRegisterAccess(NO_RST, 8'h54, 32'h1111_1111          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h53, 32'h2222_2222          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h52, 32'h3333_3333          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h51, 32'h4444_4444          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h50, 32'h5555_5555          , 8, 32);
            Reset(RST_HARD);
            MultipleTapRegisterAccess(NO_RST, 8'h17,  5'b00000              , 8,  5);

            // SWCLR Reset sequences for RTDR's
            MultipleTapRegisterAccess(NO_RST, 8'h15,  2'b10                 , 8,  2);
            MultipleTapRegisterAccess(NO_RST, 8'h54, 32'h1111_1111          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h53, 32'h2222_2222          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h52, 32'h3333_3333          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h51, 32'h4444_4444          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h50, 32'h5555_5555          , 8, 32);
            MultipleTapRegisterAccess(NO_RST, 8'h17,  5'b11111              , 8,  5);
            MultipleTapRegisterAccess(NO_RST, 8'h17,  5'b00000              , 8,  5);

    endtask : body

endclass : TapSequenceProgRstRTDR


class TapSequenceIPLevelCTT extends JtagBfmSoCTapNwSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceIPLevelCTT");
        super.new(name);
        Packet = JtagBfmSeqDrvPkt::type_id::create("Packet");
    endfunction : new

    `ovm_sequence_utils(TapSequenceIPLevelCTT, JtagBfmSequencer)

    virtual task body();
            BuildTapDataBase();
            Reset(2'b11);
            TapAccessSlaveIdcode(IPLEVEL_STAP);
    endtask : body

endclass : TapSequenceIPLevelCTT
