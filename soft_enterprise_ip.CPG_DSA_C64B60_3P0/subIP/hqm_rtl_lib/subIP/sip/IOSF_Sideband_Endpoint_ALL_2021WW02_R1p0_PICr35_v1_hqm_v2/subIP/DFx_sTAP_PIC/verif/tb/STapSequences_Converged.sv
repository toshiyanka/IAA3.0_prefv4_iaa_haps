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
class OnlyBypass extends  dfx_tap_seqlib_pkg::JtagBfmSequences#(ovm_sequence_item);

    function new(string name = "OnlyBypass");
        super.new(name);
    endfunction : new

    `ovm_sequence_utils(OnlyBypass, dfx_tap_virtual_sequencer)

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
class OnlySLVIDCODE extends  dfx_tap_seqlib_pkg::JtagBfmSequences#(ovm_sequence_item);

    function new(string name = "OnlySLVIDCODE");
        super.new(name);
    endfunction : new

    `ovm_sequence_utils(OnlySLVIDCODE, dfx_tap_virtual_sequencer)

    virtual task body();
        if(SIZE_OF_IR_REG == 16) begin
            MultipleTapRegisterAccess(NO_RST, 16'h000C, 32'h55555555, 16, 32);
        end else if (SIZE_OF_IR_REG == 8) begin
            MultipleTapRegisterAccess(NO_RST, 8'h0C, 32'h55555555, 8, 32);
        end
    endtask : body

endclass : OnlySLVIDCODE

//-----------------------------------------------
// Register Access
// Access All the Registers present in the sTAP
//-----------------------------------------------
class TapSequenceMultipleTapRegisterAccess extends JtagBfmSequences;

    JtagBfmSeqDrvPkt Packet;
    function new(string name = "TapSequenceMultipleTapRegisterAccess");
        super.new(name);
        Packet = new;
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
            Goto(ST_UPDR,1);
            Goto(ST_RUTI,11);
        end // (SIZE_OF_IR_REG_STAP == 8)
        //------------------------------

    endtask : body

endclass : TapSequenceMultipleTapRegisterAccess

