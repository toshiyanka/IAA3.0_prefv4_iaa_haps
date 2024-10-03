//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
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
//    FILENAME    : JtagBfmSoCTapNwRegModel.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//
//
//    PURPOSE     : Packet Between the Sequencer and the Driver
//    DESCRIPTION : This is the Packet between the Sequencer and the
//                  driver. The feilds that are passed by the sequencer
//                  are :
//                  Address/Instruction to Drive
//                  Data
//                  Reset Mode
//                  Function Select
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// ENUM DECLARATIONS
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// Parameters for SoCTapNWPkg
//----------------------------------------------------------------------
// Total No of Taps = CLTAP + No of sTAPs

//`define JTAG_BFM_DEBUG_MSG

`ifdef USE_GENERATED_FILES_FOR_JTAGBFM
   //--`include "JtagBfmSoCTapParameters_CTT.svh"
 `ifndef JTAG_BFM_TAPLINK_MODE
   `include "JtagBfmSoCTapParameters.svh"
 `else
   `include "JtagBfmSoCTlinkTapParameters.svh"
 `endif
`else
   //`include "JtagBfmSoCTapParameters.svh"
 `ifndef JTAG_BFM_TAPLINK_MODE
   `include "JtagBfmSoCTapParameters_Internal.svh"
 `else
   `include "JtagBfmSoCTlinkTapParameters_Internal.svh"
 `endif
`endif

parameter NUMBER_OF_TAPS               = 1+NUMBER_OF_STAPS; //NUMBER_OF_TAPS_IN_ENTIRE_SOC_NETWORK

parameter TOTAL_NUMBER_OF_REGS_PER_TAP = 2000;
//parameter WIDTH_OF_EACH_REGISTER       = 1000000;
parameter WIDTH_OF_MAX_TAPS_IN_A_NODE  = 1000;

`ifndef OVM_MAX_STREAMBITS
   parameter WIDTH_OF_EACH_REGISTER        = 10000;
`else
   parameter WIDTH_OF_EACH_REGISTER        = `OVM_MAX_STREAMBITS;
`endif

////----------------------------------------------------------------------
//// ENUM DECLARATIONS
////------------------------------------------------------------------------
//--`ifdef USE_CTT_GENERATED_FILES
`ifdef USE_GENERATED_FILES_FOR_JTAGBFM
  //--`include "JtagBfmSoCTapNumInfo_CTT.svh"
 `ifndef JTAG_BFM_TAPLINK_MODE
  `include "JtagBfmSoCTapNumInfo.svh"
 `else
  `include "JtagBfmSoCTlinkTapNumInfo.svh"
 `endif
`else
  //`include "JtagBfmSoCTapNumInfo.svh"
 `ifndef JTAG_BFM_TAPLINK_MODE
  `include "JtagBfmSoCTapNumInfo_Internal.svh"
 `else
  `include "JtagBfmSoCTlinkTapNumInfo_Internal.svh"
 `endif
`endif

typedef enum bit {
   READ  = 1'b0,
   WRITE = 1'b1
} Access_Type_t;

typedef enum int {
   RED  = 'd0,
   ORANGE = 'd1,
   GREEN   = 'd2
} DFX_Security;

typedef struct {
   Tap_t       TapOfInterest;
   Tap_t       ParentTap;
   int         HierarchyLevel;
   Tap_t       NodeQueue [$]; // Contains all the parent TAPs of a given TAP.
   Tap_t       NodeArray [];
   bit         TapcRemove;
   int         DrLengthOfTapcSelectReg;
   int         PostionOfTapInTapcSelReg;
   bit [1:0]   TapMode; // SoC TAPNW Modes.
   int         IsTapEnabled;
   int         TapChangedToEnabled;
   int         TapChangedToDisabled;
   int         PreviousStateOfIsTapDisabled;
   int         TapDisabledByParent; // Child Tap is enabled however his upstream parent is disabled.
   int         TapDisabledByReset;
   int         TapShadowedByParent;
   int         TapSelfDisable; // When DisableTap API is used, this gets set for TapOfInterest. 
   int         IsTapDisabled;
   int         IsTapShadowed;
   bit [255:0] TapcSelectRegister;
   bit [127:0] TapSecondarySelect;
//   Tap_t       TapsEnabledBeforeTapOfInterestQueue [$];
//   Tap_t       TapsEnabledAfterTapOfInterestQueue  [$];
   int         TapBeforeTapOfInterestArray [];
   int         TapAfterTapOfInterestArray  [];
   int         TapBeforeTapOfInterestQueue [$];
   int         TapAfterTapOfInterestQueue  [$];
   int         ChildTapsArray []; // List of all the Childs for a given TAP. This info is made for every TAP in the design.
   int         IsTapOnSecondary;
   int         IsTapOnPrimary;
   int         IsTapOnRemove;
   bit [API_SIZE_OF_IR_REG-1:0] PreviousAccessedIr;
   bit                          EnableMultiTapAccess;
   bit [API_SIZE_OF_IR_REG-1:0] OpcodeForMultiTapAccess;
   int                          OpcodeWidthForMultiTapAccess;
   bit [WIDTH_OF_EACH_REGISTER-1:0] DataForMultiTapAccess;
   int                              DataWidthForMultiTapAccess;
   bit [WIDTH_OF_EACH_REGISTER-1:0] CompareValueForMultiTapAccess;
   bit [WIDTH_OF_EACH_REGISTER-1:0] CompareMaskForMultiTapAccess;
   bit [WIDTH_OF_EACH_REGISTER-1:0] ReturnedTapTdoData;
   bit         SecondaryConnectionEnable;
   int         IsTapOnTertiaryForAllPorts; // Helps in exclusion of all taps on various tertiray ports for the purpose of Primary and Secondary calculation. 
   bit         IsTapOnTertiary[((NUMBER_OF_TERTIARY_PORTS>0)? NUMBER_OF_TERTIARY_PORTS-1:0):0]; // Indicates on which Tertiary port a given Tap is placed.
   bit         IsTertiaryPortEnabled; // By default this will be enabled in each TAP even if there is no Tertiary port.
   Tap_t       TertiaryParentTap; // Need a function to update this value from CTT's SecondaryConnectionEnable.
   int         IsVendorTap;
   // DFx JTAG BFM Tracker to display active taps in tap network                       
   // https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=5188748
   int         IrWidthOfEachTap; 
   bit [API_SIZE_OF_IR_REG-1:0] CurrentlyAccessedIr;

} HistoryElements;

typedef enum {DONT_CARE = 0} dont_care;
typedef enum {ENABLE_ALL_TAP = 1,
              DONT_ENABLE_ALL_TAP = 0} enable_all_tap;

typedef struct packed  {
   int          Opcode; //FIXME - change to logic
   int          DR_Width;
   Tap_t        Tap_ID;
   `ifdef JTAG_BFM_TAPLINK_MODE
   int          predelay;
   int          postdelay;
   int          isTapLinkOpcode;
   `endif
} Reg_Def_t;

typedef struct {
   Tap_t                                         Tap;
   int                                           SlvIDcode;
   int                                           VendorIDcode;
   bit [API_SIZE_OF_IR_REG-1:0]                  VendorIdOpcode;
   int                                           Node;
   int                                           IR_Width;
   //logic [API_SIZE_OF_IR_REG-1:0][TOTAL_NUMBER_OF_REGS_PER_TAP-1:0] Register; // user Defined Opcodes for a given TAP
   logic [127:0][TOTAL_NUMBER_OF_REGS_PER_TAP-1:0] Register; // user Defined Opcodes for a given TAP
   Tap_t      Next_Tap [$];
   int        SecondaryConnectionEnable;
   int        SecondaryHybridEnable;
   DFX_Security dfx_security;
//   logic [31:0] history_elements [];
   int        DrWidthInTapInfoQ[TOTAL_NUMBER_OF_REGS_PER_TAP-1:0];
   int         HierarchyLevel;
   int         PostionOfTapInTapcSelReg;
   Tap_t       ParentTap;
   `ifdef JTAG_BFM_TAPLINK_MODE
   bit [31:0]  LBA;
   bit [31:0]  GBA;
   `endif
} Tap_Info_t;

typedef bit [31:0] tl_ba_t;

//
//1. Need a data type per stap that contains ..
//   a. All opcodes.
//   b. Width of each opcode.
//   c. Attributes of each opcode. (RO, RW) on a per bit basis.
//      We can start with a per TDR basis.
//      Opcode = 8'hA0
//      Width  = 32
//      Attrib = 32'b RO_RW_RO_RW_RW
//                    4  3  2  1  0
//2. Need to take care of Write operation witn ALL Taps are enabled in the NW.
//   Data structure is a must for this case. Since scoreboard is
//   disabled (for Single Hier) need to calculate expected data.

//----------------------------------------------------------------------
// ENUM DECLARATIONS
//----------------------------------------------------------------------
//class JtagBfmSoCTapNwRegModel extends ovm_object;
class JtagBfmSoCTapNwRegModel extends JtagBfmSequences;

   //https://hsdes.intel.com/home/default.html#article?id=1503985289
   //Changed due to an error in SVTB Lintra Tool
   `ovm_sequence_utils(JtagBfmSoCTapNwRegModel,JtagBfmSequencer)

  function new(string name = "JtagBfmSoCTapNwRegModel" );
    super.new(name);
  endfunction : new
   
  // TODO - The following struct has to be based on No of TAPs in the NW+CLTAP.
  static Reg_Def_t  Reg_Model [$]; 
  static Tap_Info_t Tap_Info_q [$];
  static Tap_Info_t Tap_Info_array [] = new [NUMBER_OF_TAPS];
  static HistoryElements CreateArrayOfHistoryElements [0:NUMBER_OF_TAPS-1];
  static Tap_t TapLink_LBA_map[tl_ba_t];
  static Tap_t TapLink_GBA_map[tl_ba_t];
   
   virtual function Create_Reg_Model(
      input Tap_t      Tap_ID,
      input int        Opcode,
      input int        DR_Width
   `ifdef JTAG_BFM_TAPLINK_MODE
      ,
      input int        postdelay=0,
      input int        predelay=0,
      input bit        isTapLinkOpcode=0
   `endif
      );

         Reg_Def_t Reg_Model_Int;
         Reg_Model_Int.Opcode    = Opcode;
         Reg_Model_Int.DR_Width  = DR_Width;
         Reg_Model_Int.Tap_ID    = Tap_ID;
         `ifdef JTAG_BFM_TAPLINK_MODE
         Reg_Model_Int.predelay  = predelay;
         Reg_Model_Int.postdelay = postdelay;
         Reg_Model_Int.isTapLinkOpcode = isTapLinkOpcode;
         `endif

         Reg_Model.push_back(Reg_Model_Int);

    endfunction : Create_Reg_Model

    virtual function Create_TAP_LUT(
       input Tap_t                        Tap,
       input int                          Tap_SlvIDcode,
       input int                          Tap_VendorIDcode,
       input int                          IR_Width,
       `ifdef JTAG_BFM_TAPLINK_MODE
       input bit [31:0]                   Node,
       input bit [31:0]                   SecondaryConnectionEnable,
       `else
       input int                          Node,
       input int                          SecondaryConnectionEnable,
       `endif
       input int                          SecondaryHybridEnable,
       input DFX_Security                 Dfx_Ssecurity,
       input int                          HierarchyLevel,
       input int                          PostionOfTapInTapcSelReg,
       input int                          IsVendorTap,
       input bit [API_SIZE_OF_IR_REG-1:0] VendorIdOpcode);

       Tap_Info_t Tap_Info_Int;
       int k;

       Tap_Info_Int.Tap          = Tap;
       Tap_Info_Int.SlvIDcode    = Tap_SlvIDcode;
       Tap_Info_Int.VendorIDcode = Tap_VendorIDcode;
       Tap_Info_Int.VendorIdOpcode = VendorIdOpcode;
       Tap_Info_Int.IR_Width     = IR_Width;
       `ifdef JTAG_BFM_TAPLINK_MODE
       Tap_Info_Int.LBA = Node;
       Tap_Info_Int.GBA = SecondaryConnectionEnable;
       // LBA checks & hash
       //if (Node == 0) // CLTAP will have 0
       //   `ovm_fatal(get_name(),$psprintf("Tap %s has incorrect LBA address 0x%0h - it cannot be 0\n",Tap.name(),Node))
       if (Node[1:0] != 0) 
          `ovm_fatal(get_name(),$psprintf("Tap %s has incorrect LBA address 0x%0h - two LSB bits must be 0\n",Tap.name(),Node))
       if (TapLink_LBA_map.exists(Node))
          `ovm_fatal(get_name(),$psprintf("Tap %s has conflicting LBA address 0x%0h - it is occupied already\n",Tap.name(),Node))
       else
          TapLink_LBA_map[Node] = Tap;
       if (TapLink_LBA_map.exists(Node+1))
          `ovm_fatal(get_name(),$psprintf("Tap %s has conflicting LBA address 0x%0h - 0x%0h occupied already\n",Tap.name(),Node,(Node+1)))
       else
          TapLink_LBA_map[(Node+1)] = Tap;

       // GBA checks & hash
       if (SecondaryConnectionEnable != 0) begin
          if (SecondaryConnectionEnable[0] != 0) 
             `ovm_fatal(get_name(),$psprintf("Tap %s has incorrect GBA address 0x%0h - LSB bit must be 0\n",Tap.name(),SecondaryConnectionEnable))
          if (TapLink_LBA_map.exists(SecondaryConnectionEnable))
             `ovm_fatal(get_name(),$psprintf("Tap %s has conflicting GBA address 0x%0h - it matches some LBA\n",Tap.name(),SecondaryConnectionEnable))
          if (TapLink_GBA_map.exists(SecondaryConnectionEnable))
             `ovm_info(get_name(),$psprintf("Tap %s belongs to group with GBA address 0x%0h\n",Tap.name(),SecondaryConnectionEnable), OVM_MEDIUM)
          else begin
              TapLink_GBA_map[SecondaryConnectionEnable]= Tap;
              TapLink_GBA_map[(SecondaryConnectionEnable+1)]= Tap;
          end
       end
       `endif
       Tap_Info_Int.Node         = Node;
       Tap_Info_Int.SecondaryConnectionEnable = SecondaryConnectionEnable;
       Tap_Info_Int.SecondaryHybridEnable = SecondaryHybridEnable;
       Tap_Info_Int.dfx_security = Dfx_Ssecurity;

       //--`ifdef USE_CTT_GENERATED_FILES
       `ifdef USE_GENERATED_FILES_FOR_JTAGBFM
          //--`include "JtagBfmSoCTapNetworkInfo_CTT.svh"
         `ifndef JTAG_BFM_TAPLINK_MODE
          `include "JtagBfmSoCTapNetworkInfo.svh"
         `else
          `include "JtagBfmSoCTlinkTapNetworkInfo.svh"
         `endif
       `else
          //--`include "JtagBfmSoCTapNetworkInfo.svh"
         `ifndef JTAG_BFM_TAPLINK_MODE
          `include "JtagBfmSoCTapNetworkInfo_Internal.svh"
         `else
          `include "JtagBfmSoCTlinkTapNetworkInfo_Internal.svh"
         `endif
       `endif

       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
//          Tap_Info_array[i].history_elements    = new[NUMBER_OF_TAPS];
//          Tap_Info_array[i].history_elements[i] = i;
          k=0;
          for (int j=0; j<Reg_Model.size(); j++) begin
             if(Reg_Model[j].Tap_ID == Tap) begin
                Tap_Info_Int.Register[k] = Reg_Model[j].Opcode;
                Tap_Info_Int.DrWidthInTapInfoQ[k] = Reg_Model[j].DR_Width;
                k++;
              end
           end // No of Regs
       end // NUMBER_OF_TAPS

       Tap_Info_array[Tap] = Tap_Info_Int;
       Tap_Info_q.push_back(Tap_Info_Int);
          `dbg_display ("Tap_Info_array.size() = %0d", Tap_Info_array.size());

       CreateArrayOfHistoryElements[Tap].HierarchyLevel = HierarchyLevel;
       CreateArrayOfHistoryElements[Tap].PostionOfTapInTapcSelReg = PostionOfTapInTapcSelReg;
       CreateArrayOfHistoryElements[Tap].SecondaryConnectionEnable = SecondaryConnectionEnable;
       CreateArrayOfHistoryElements[Tap].IsVendorTap = IsVendorTap;

    endfunction : Create_TAP_LUT

    // --------------------------------------
    // Printing Look up Table
    //--------------------------------------    
    virtual function Print_TAP_LUT();
       for (int i=0; i <NUMBER_OF_TAPS; i = i+1) begin
          `dbg_display("\nPrinting TAP LUT ");
          `dbg_display("Tap_Info_q[%0d].Tap          : %0s",i, StrTap(Tap_Info_q[i].Tap));
          `dbg_display("Tap_Info_q[%0d].IR_Width     : %0d",i, Tap_Info_q[i].IR_Width);
          `dbg_display ("reg_model dbg_display"); 
          for (int j=0; j <TOTAL_NUMBER_OF_REGS_PER_TAP; j = j+1) begin
          end
`ifndef JTAG_BFM_TAPLINK_MODE
          for (int j=0; j <Tap_Info_q[i].Next_Tap.size(); j = j+1) begin
             `dbg_display("Tap_Info_q[%0d].Next_Tap[%0d]  : %s",
                i, j, StrTap(Tap_Info_q[i].Next_Tap[j]));
          end
`else
         // for (int j=0; j <Tap_Info_q[i].Next_Tap.size(); j = j+1) begin
         //    `dbg_display("Tap_Info_q[%0d].Next_Tap[%0d]  : %s",
         //       i, j, Tap_Info_q[i].Next_Tap[j].name());
         // end
`endif
       end
    endfunction : Print_TAP_LUT

    // --------------------------------------
    // Updating Look up Table
    //--------------------------------------    
    virtual function Update_Lookup_Table(
            input [API_SIZE_OF_IR_REG-1:0] Address,
            input [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
            input int addr_len,
            input int data_len);
            `dbg_display("** Update_Lookup_Table is called !!!");
            `dbg_display("\nAddrss : %0h\nData : %0h\nAddressLength : %0h\nDataLength : %0h",
               Address, Data, addr_len, data_len);
    endfunction : Update_Lookup_Table

    // --------------------------------------
    // Printing Register Table
    //--------------------------------------    
    virtual function Print_Reg_Model();
       for (int i=0; i<Reg_Model.size(); i++) begin
          `dbg_display("\nPrinting Register Model ");
          `dbg_display("Tap ID          : %0s", StrTap(Reg_Model[i].Tap_ID));
          `dbg_display("Tap Opcode      : %0h", Reg_Model[i].Opcode);
          `dbg_display("Reg DR_Width    : %0d", Reg_Model[i].DR_Width);
`ifdef JTAG_BFM_TAPLINK_MODE
          `dbg_display("Reg Dummy_Hi (pre-delay)  : %0d", Reg_Model[i].predelay);
          `dbg_display("Reg Dummy_Lo (post-delay) : %0d", Reg_Model[i].postdelay);
          `dbg_display("Reg isTapLinkOpcode       : %0d", Reg_Model[i].isTapLinkOpcode);
`endif
       end
    endfunction : Print_Reg_Model

    // ------------------------------------------------
    // Building Register Model with all default Values
    //-------------------------------------------------    
     task Build_TAP_LUT();
     begin
        //--`ifdef USE_CTT_GENERATED_FILES
        `ifdef USE_GENERATED_FILES_FOR_JTAGBFM
           //--`include "JtagBfmSoCTapsInfo_CTT.svh"
          `ifndef JTAG_BFM_TAPLINK_MODE
           `include "JtagBfmSoCTapsInfo.svh"
          `else
           `include "JtagBfmSoCTlinkTapsInfo.svh"
          `endif
        `else
           //--`include "JtagBfmSoCTapsInfo.svh"
         `ifndef JTAG_BFM_TAPLINK_MODE
           `include "JtagBfmSoCTapsInfo_Internal.svh"
          `else
           `include "JtagBfmSoCTlinkTapsInfo_Internal.svh"
          `endif
        `endif
     end
     endtask : Build_TAP_LUT

    // ------------------------------------------------
    // Building Register Model with all default Values
    //-------------------------------------------------    

    task Build_Reg_Model();
    begin
       Reg_Def_t Reg_Model_Int;

       //--`ifdef USE_CTT_GENERATED_FILES
       `ifdef USE_GENERATED_FILES_FOR_JTAGBFM
          //--`include "JtagBfmSoCTapsRegInfo_CTT.svh"
         `ifndef JTAG_BFM_TAPLINK_MODE
          `include "JtagBfmSoCTapsRegInfo.svh"
         `else
          `include "JtagBfmSoCTlinkTapsRegInfo.svh"
         `endif
       `else
          //--`include "JtagBfmSoCTapsRegInfo.svh"
         `ifndef JTAG_BFM_TAPLINK_MODE
          `include "JtagBfmSoCTapsRegInfo_Internal.svh"
         `else
          `include "JtagBfmSoCTlinkTapsRegInfo_Internal.svh"
         `endif
       `endif
       
       //https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=4798351
       //HSD Title:Order dependency for Bypass Opcode position in JtagBfmSoCTapsRegInfo.svh

       Reg_Model_Int.Opcode    = 'hFF;
       Reg_Model_Int.DR_Width  = 1;
       //Reg_Model_Int.Tap_ID    = CLTAP;
       //For BFM usage in Cluster/Single TAP level
       Reg_Model_Int.Tap_ID    = Tap_t'(0);

       Reg_Model.push_front(Reg_Model_Int);

    end
    endtask : Build_Reg_Model

    //--`ifdef USE_CTT_GENERATED_FILES
    `ifdef USE_GENERATED_FILES_FOR_JTAGBFM
       //--`include "JtagBfmSoCTapStringInfo_CTT.svh"
      `ifndef JTAG_BFM_TAPLINK_MODE
       `include "JtagBfmSoCTapStringInfo.svh"
      `else
       `include "JtagBfmSoCTlinkTapStringInfo.svh"
      `endif
    `else
       //--`include "JtagBfmSoCTapStringInfo.svh"
      `ifndef JTAG_BFM_TAPLINK_MODE
       `include "JtagBfmSoCTapStringInfo_Internal.svh"
      `else
       `include "JtagBfmSoCTlinkTapStringInfo_Internal.svh"
      `endif
    `endif

    function string StrAccess (input bit AccessType); begin
        string str;
        case (AccessType)
            READ  : begin str = "READ"; end
            WRITE : begin str = "WRITE";  end
        endcase 
        return str; 
    end
    endfunction : StrAccess

endclass : JtagBfmSoCTapNwRegModel
