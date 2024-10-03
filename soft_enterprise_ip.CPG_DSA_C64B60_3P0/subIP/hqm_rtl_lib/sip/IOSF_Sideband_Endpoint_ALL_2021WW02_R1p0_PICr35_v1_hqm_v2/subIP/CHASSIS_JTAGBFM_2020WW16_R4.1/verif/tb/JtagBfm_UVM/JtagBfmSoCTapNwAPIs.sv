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
//    FILENAME    : JtagBfmSoCTapNwAPIs.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//
//
//    PURPOSE     : Sequences for the ENV 
//    DESCRIPTION : This Component defines various sequences that are 
//                  needed to drive and test the DUT including the Random
//                  https://hsdes.intel.com/home/default.html#article?id=1503985289
//                  All uvm_*_info are changed to `uvm_info due to an error in SVTB //                  Lintra Tool.Please see above HSd.
//------------------------------------------------------------------------

`ifndef  JtagBfmSoCTapNwAPIs
 `define JtagBfmSoCTapNwAPIs

class JtagBfmSoCTapNwSequences extends JtagBfmSequences;

   static JtagBfmSoCTapNwRegModel TapRegModel;
   static bit    [API_SIZE_OF_IR_REG-1:0] IrChainValue1_previous;
   Tap_t Tap_string_array [int];
   Tap_t Tap_enum;
   static Tap_t PreviousTapAccess;
   string TapName;

   // Constructor
    function new (
       string name                      = "JtagBfmSoCTapNwSequences",
       uvm_sequencer_base sequencer_ptr = null,
       uvm_sequence_base parent_seq     = null);
       super.new(name);
       //https://hsdes.intel.com/home/default.html#article?id=1503985289
       //Commented due to an error in SVTB Lintra Tool
       //TapRegModel                      = new();
    endfunction : new

    // Register component with Factory 
    `uvm_object_utils(JtagBfmSoCTapNwSequences)  
    `uvm_declare_p_sequencer(JtagBfmSequencer)

    typedef Tap_t            TypeQueueOfTap_t[$];
    Tap_t                    Tap_Node_q [$];
    static HistoryElements   ArrayOfHistoryElements [0:NUMBER_OF_TAPS-1];
    static Tap_t             PathTillCltapQueue [$];
    static Tap_t             PathWithTapOfInterestQueue[$];
    static Tap_t             PathWithoutCltapQueue[$];
    static Tap_t             AllTapsEnabledQueue[$];
    static Tap_t             AllTapsDisabledQueue[$];
    static Tap_t             AllTapsOnSecondary[$];
    static Tap_t             AllTapsOnPrimary[$];
    static Tap_t             AllTapsOnRemove[$];
    static Tap_t             AllTapsOnAllTertiaries[$];
    static Tap_t             AllTapsOnOtherTertiaries[$];
    static int               TapExistFlag;
    static bit               ByPassSelected;
    static bit               ByPassSelectedForMultiTapAccess;
    static bit               MultiTapAccessSelected;
    static bit               MultiLaunchPrimary;
    static bit               MultiLaunchSecondary;
    //Starting from zero, this array contains the enum TapName association for each Tertiary port.
    static Tap_t             TertiaryPortNumbering[0:((NUMBER_OF_TERTIARY_PORTS>0)? NUMBER_OF_TERTIARY_PORTS-1:0)];
    static int               ReadModifyWriteEnabled;
    static int               ShortLongFsmPaths;
    static bit               IsSameTapAccessed;
    static Tap_t             PreviousAccesedTapOfInterest;
`ifndef JTAGBFM_EN_DFTB_HTAP
    static bit               CltapcNetworkSelOpcodeis_h12 = 1'b1;
`else
    static bit               CltapcNetworkSelOpcodeis_h12 = 1'b0;
`endif 
    static int               CLTAP_Ir_Width;
    static int               InputDrWidthInternal_CLTAP;

    static Tap_t             MultiTapAccess [$];
    `include "JtagBfmEndebugTapAccess.sv"
    //--------------------------------------    
    task BuildTapDataBase();
    begin
       `uvm_info (get_type_name(), "JTAGBFM: Executing BuildTapDataBase...", UVM_NONE);
       `dbg_display(" Start Executing Build_Reg_Model");
       `uvm_create(TapRegModel);
       TapRegModel.Build_Reg_Model();
       TapRegModel.Print_Reg_Model(); //FIXME - revisit print
       `dbg_display(" End Executing Build_Reg_Model");
       `dbg_display(" Start Executing Build_TAP_LUT");
       TapRegModel.Build_TAP_LUT();
       `dbg_display(" End Executing Build_TAP_LUT");
       TapRegModel.Print_TAP_LUT(); //FIXME - revisit print
       `dbg_display(" End Executing Print_TAP_LUT");
       InitializeHistoryElements();
       PreviousAccesedTapOfInterest = NOTAP;
    end
    endtask : BuildTapDataBase

    task SelectFsmPathToUpdr(input int ShortLongPath = 0); //0 for short path, 1 for long path
    begin
       ShortLongFsmPaths = ShortLongPath;
       `uvm_info("",$psprintf("ShortLongFsmPaths = %0d --- '0' => SHORT PATH, '1' => LONG PATH", ShortLongFsmPaths),UVM_NONE);
    end
    endtask : SelectFsmPathToUpdr

    //Initialize history elements
    task InitializeHistoryElements();
    begin
       Tap_t TapUnderInvestigationTemp;
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          ArrayOfHistoryElements[i].TapOfInterest                 = Tap_t'(i);
`ifdef JTAG_BFM_TAPLINK_MODE
          ArrayOfHistoryElements[i].ParentTap                     = Tap_t'(0);
`else
          ArrayOfHistoryElements[i].ParentTap                     = Get_Tap_Node(Tap_t'(i));
`endif
          ArrayOfHistoryElements[i].HierarchyLevel                = TapRegModel.CreateArrayOfHistoryElements[i].HierarchyLevel;
          ArrayOfHistoryElements[i].IsVendorTap                   = TapRegModel.CreateArrayOfHistoryElements[i].IsVendorTap;
          ArrayOfHistoryElements[i].NodeArray                     = new [NUMBER_OF_HIER];
          ArrayOfHistoryElements[i].TapcRemove                    = 0;
`ifdef JTAG_BFM_TAPLINK_MODE
          ArrayOfHistoryElements[i].DrLengthOfTapcSelectReg       = 0;
`else
          ArrayOfHistoryElements[i].DrLengthOfTapcSelectReg       = Get_DR_Width(Tap_t'(i), 5'h11);
`endif
          ArrayOfHistoryElements[i].PostionOfTapInTapcSelReg      = TapRegModel.CreateArrayOfHistoryElements[i].PostionOfTapInTapcSelReg;
`ifndef JTAGBFM_EN_DFTB_HTAP
          ArrayOfHistoryElements[i].TapMode                       = 0;
`else
          ArrayOfHistoryElements[i].TapMode                       = 2;
`endif
          ArrayOfHistoryElements[i].IsTapEnabled                  = 0;
          ArrayOfHistoryElements[i].IsTapDisabled                 = 1;
          ArrayOfHistoryElements[i].PreviousStateOfIsTapDisabled  = 0; 
          ArrayOfHistoryElements[i].IsTapShadowed                 = 0;
          ArrayOfHistoryElements[i].TapChangedToEnabled           = 0;
          ArrayOfHistoryElements[i].TapChangedToDisabled          = 0;
          ArrayOfHistoryElements[i].TapDisabledByParent           = 0;
          ArrayOfHistoryElements[i].TapShadowedByParent           = 0;
`ifdef JTAG_BFM_TAPLINK_MODE
          ArrayOfHistoryElements[i].TapDisabledByReset            = 0;
`else
          ArrayOfHistoryElements[i].TapDisabledByReset            = 1;
`endif
          ArrayOfHistoryElements[i].TapSelfDisable                = 0;
`ifndef JTAGBFM_EN_DFTB_HTAP
          ArrayOfHistoryElements[i].TapcSelectRegister            = 0;
`else
          ArrayOfHistoryElements[i].TapcSelectRegister            = {128{2'b10}};
`endif
          ArrayOfHistoryElements[i].TapSecondarySelect            = 0;
          ArrayOfHistoryElements[i].TapBeforeTapOfInterestArray   = new[NUMBER_OF_TAPS];
          ArrayOfHistoryElements[i].TapAfterTapOfInterestArray    = new[NUMBER_OF_TAPS];
          ArrayOfHistoryElements[i].ChildTapsArray                = new[NUMBER_OF_TAPS];
          ArrayOfHistoryElements[i].IsTapOnSecondary              = 0;
          ArrayOfHistoryElements[i].IsTapOnPrimary                = 1;
          ArrayOfHistoryElements[i].IsTapOnRemove                 = 0;
          ArrayOfHistoryElements[i].PreviousAccessedIr            = 0;
          ArrayOfHistoryElements[i].CurrentlyAccessedIr           = 0;
          ArrayOfHistoryElements[i].EnableMultiTapAccess          = 0;
          ArrayOfHistoryElements[i].OpcodeForMultiTapAccess       = 0;
          ArrayOfHistoryElements[i].OpcodeWidthForMultiTapAccess  = 0;
          ArrayOfHistoryElements[i].DataForMultiTapAccess         = 0;
          ArrayOfHistoryElements[i].DataWidthForMultiTapAccess    = 0;
          ArrayOfHistoryElements[i].CompareValueForMultiTapAccess = 0;
          ArrayOfHistoryElements[i].CompareMaskForMultiTapAccess  = 0;
          ArrayOfHistoryElements[i].SecondaryConnectionEnable     = TapRegModel.CreateArrayOfHistoryElements[i].SecondaryConnectionEnable;
          ArrayOfHistoryElements[i].IsTertiaryPortEnabled         = 1;
          ArrayOfHistoryElements[i].IsTapOnTertiaryForAllPorts    = 0; 
          ArrayOfHistoryElements[i].IrWidthOfEachTap              = Get_IR_Width(Tap_t'(i)); 

          // Clear the Structs before starting any operation.
          Tap_Node_q.delete();
          PreviousTapAccess = Tap_t'(0);
          IrChainValue1_previous = 0;
          // Calcuates the Father TAP's of a given TAP and puts it in a queue.
          UpdateTapNodeQueue (Tap_t'(i));
          ArrayOfHistoryElements[i].NodeQueue.delete();
          ArrayOfHistoryElements[i].NodeQueue = Tap_Node_q;
          for (int j=0; j<Tap_Node_q.size; j++) begin
             ArrayOfHistoryElements[i].NodeArray[j] = Tap_Node_q[j];
          end
`ifndef JTAG_BFM_TAPLINK_MODE
          ArrayOfHistoryElements[i].TertiaryParentTap             = GetTertiaryParentTap(Tap_t'(i));
          for (int j=0; j<NUMBER_OF_TERTIARY_PORTS; j++) begin
             ArrayOfHistoryElements[i].IsTapOnTertiary[j]         = 0;
          end
`endif
       end

       //CLTAP is always enabled
       ArrayOfHistoryElements[0].IsTapEnabled  = 1;
       ArrayOfHistoryElements[0].IsTapDisabled = 0;
       ArrayOfHistoryElements[0].IsTapShadowed = 0;

`ifndef JTAG_BFM_TAPLINK_MODE
       //Number the Tertiary ports in the design excluding the CLTAP as its SecConnEnb will be 1
       for (int i=1, j=0; i<NUMBER_OF_TAPS; i++) begin
          if (ArrayOfHistoryElements[i].SecondaryConnectionEnable == 1) begin
             TertiaryPortNumbering[j] = Tap_t'(i);
             `dbg_display("TertiaryPortNumbering[%0d] = %0d", j, Tap_t'(TertiaryPortNumbering[i]));
             j++;
          end
       end
`endif

       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          for (int j=0; j<NUMBER_OF_HIER; j++) begin
             `dbg_display("Init ArrayOfHistoryElements[%0d].NodeArray[%0d] = %0d",
                i, j, ArrayOfHistoryElements[i].NodeArray[j]);
          end
       end
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          `dbg_display("Init ArrayOfHistoryElements[%0d].NodeQueue.size = %0d",
             i, ArrayOfHistoryElements[i].NodeQueue.size);
       end
       `dbg_display("InitializeHistoryElements");
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          `dbg_display("ArrayOfHistoryElements[%0d].TapOfInterest               = %0s", i, ArrayOfHistoryElements[i].TapOfInterest);
          `dbg_display("ArrayOfHistoryElements[%0d].ParentTap                   = %0s", Tap_t'(i), ArrayOfHistoryElements[i].ParentTap);
          `dbg_display("ArrayOfHistoryElements[%0d].HierarchyLevel              = %0d", i, ArrayOfHistoryElements[i].HierarchyLevel);
          `dbg_display("ArrayOfHistoryElements[%0d].IsVendorTap               = %0d", i, ArrayOfHistoryElements[i].IsVendorTap);
          `dbg_display("ArrayOfHistoryElements[%0d].NodeQueue.size              = %0d", i, ArrayOfHistoryElements[i].NodeQueue.size);
          `dbg_display("ArrayOfHistoryElements[%0d].Tap_Node_q                  = ", i, ArrayOfHistoryElements[i].NodeQueue);
          `dbg_display("ArrayOfHistoryElements[%0d].NodeArray                   = %0d", i, NUMBER_OF_HIER, ArrayOfHistoryElements[i].NodeArray);
          `dbg_display("ArrayOfHistoryElements[%0d].TapcRemove                  = %0d", i, ArrayOfHistoryElements[i].TapcRemove);
          `dbg_display("ArrayOfHistoryElements[%0d].DrLengthOfTapcSelectReg     = %0d", i, ArrayOfHistoryElements[i].DrLengthOfTapcSelectReg);
          `dbg_display("ArrayOfHistoryElements[%0d].PostionOfTapInTapcSelReg    = %0d", i, ArrayOfHistoryElements[i].PostionOfTapInTapcSelReg);
          `dbg_display("ArrayOfHistoryElements[%0d].TapMode                     = %0d", i, ArrayOfHistoryElements[i].TapMode);
          `dbg_display("ArrayOfHistoryElements[%0d].IsTapEnabled                = %0d", i, ArrayOfHistoryElements[i].IsTapEnabled);
          `dbg_display("ArrayOfHistoryElements[%0d].IsTapDisabled               = %0d", i, ArrayOfHistoryElements[i].IsTapDisabled);
          `dbg_display("ArrayOfHistoryElements[%0d].IsTapShadowed               = %0d", i, ArrayOfHistoryElements[i].IsTapShadowed);
          `dbg_display("ArrayOfHistoryElements[%0d].TapcSelectRegister          = %0d", i, ArrayOfHistoryElements[i].TapcSelectRegister);
          `dbg_display("ArrayOfHistoryElements[%0d].TapSecondarySelect          = %0d", i, ArrayOfHistoryElements[i].TapSecondarySelect);
          `dbg_display("ArrayOfHistoryElements[%0d].TapBeforeTapOfInterestArray = %0d",
             i, NUMBER_OF_TAPS, ArrayOfHistoryElements[i].TapBeforeTapOfInterestArray);
          `dbg_display("ArrayOfHistoryElements[%0d].TapAfterTapOfInterestArray  = %0d",
             i, NUMBER_OF_TAPS, ArrayOfHistoryElements[i].TapAfterTapOfInterestArray);
          `dbg_display("ArrayOfHistoryElements[%0d].IsTertiaryPortEnabled       = %0d", i, ArrayOfHistoryElements[i].IsTertiaryPortEnabled);
          `dbg_display("ArrayOfHistoryElements[%0d].TertiaryParentTap           = %0s", Tap_t'(i), ArrayOfHistoryElements[i].TertiaryParentTap);
          `dbg_display("\n ---------------------------------------------------------------------");
       end

       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          for (int j=0; j<NUMBER_OF_TAPS; j++) begin
             `dbg_display("TapOfInterest = %0d, TapUnderInvestigation = %0d", Tap_t'(i), Tap_t'(j));
             `ifndef JTAG_BFM_TAPLINK_MODE
             UpdateArrayIfBeforeOrAfterTapOfInterest (Tap_t'(i), Tap_t'(j)); 
             `endif
             `dbg_display("ArrayOfHistoryElements[%0d].TapBeforeTapOfInterestArray = %0d",
                Tap_t'(i), NUMBER_OF_TAPS, ArrayOfHistoryElements[Tap_t'(i)].TapBeforeTapOfInterestArray);
             `dbg_display("ArrayOfHistoryElements[%0d].TapAfterTapOfInterestArray  = %0d",
                Tap_t'(i), NUMBER_OF_TAPS, ArrayOfHistoryElements[Tap_t'(i)].TapAfterTapOfInterestArray);
          end
       end
       `dbg_display("Printing Arrays before and after Tap");
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          `dbg_display("ArrayOfHistoryElements[%2d].TapBeforeTapOfInterestArray = %0d",
             Tap_t'(i), NUMBER_OF_TAPS, ArrayOfHistoryElements[Tap_t'(i)].TapBeforeTapOfInterestArray);
       end
       `dbg_display("====================================");
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          `dbg_display("ArrayOfHistoryElements[%2d].TapAfterTapOfInterestArray  = %0d",
             Tap_t'(i), NUMBER_OF_TAPS, ArrayOfHistoryElements[Tap_t'(i)].TapAfterTapOfInterestArray);
       end

       UpdateChildTapArrayTable();

       for (int j=0; j<NUMBER_OF_TAPS; j++) begin
          `dbg_display("ArrayOfHistoryElements[%2d].ChildTapsArray = %0d",
             Tap_t'(j), NUMBER_OF_TAPS, ArrayOfHistoryElements[Tap_t'(j)].ChildTapsArray);
       end

       SelectFsmPathToUpdr(0);
    end
    endtask : InitializeHistoryElements

    //Check whether Tap of interest exists in the network.
    //TapExistFlag flag is set when Tap of interest matches with
    //Tap id given in Tap_t enum declaration.
    task GetTapAvailableStatus (input Tap_t TapInt = 0);
    begin
       `dbg_display("Checking whether TAP Exists");
       TapExistFlag = 0;
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
        //if (TapInt == Tap_t'(i)) begin
         if ((TapInt == Tap_t'(i)) && (ArrayOfHistoryElements[i].TapcRemove == 0)) begin
             TapExistFlag = 1;
             break;
          end
       end
       if (TapExistFlag == 1) begin
          `dbg_display(" Target TAP Exists !!!TapExistFlag", TapExistFlag);
       end
       else begin
          `dbg_display(" Target TAP Does NOT Exist !!!TapExistFlag", TapExistFlag);
       end
    end
    endtask : GetTapAvailableStatus


    // Identify the fathers of a given Tap
    task UpdateTapNodeQueue (
       input Tap_t TapInt = 0);
    begin
       Tap_t Node_Temp;
       Node_Temp  = TapInt;
       `dbg_display(" 1. Node_Temp is : %0s", TapRegModel.StrTap(Node_Temp));
       if(TapInt == 0) begin //CLTAP
          `dbg_display("Nothing to push for CLTAP", TapRegModel.StrTap(Node_Temp));
       end
       else begin
`ifdef JTAG_BFM_TAPLINK_MODE
         Tap_Node_q.push_front(Tap_t'(0));
`else
          while (Node_Temp != 0) begin //CLTAP
             for (int i =0; i < NUMBER_OF_TAPS; i++) begin
                for (int j = 0; j < TapRegModel.Tap_Info_q[i].Next_Tap.size(); j++) begin
                   if(TapRegModel.Tap_Info_q[i].Next_Tap[j] == Node_Temp) begin
                      Tap_Node_q.push_front(TapRegModel.Tap_Info_q[i].Tap);
                      Node_Temp = TapRegModel.Tap_Info_q[i].Tap;
                   end
                end
             end
          end
`endif
       end
 
       // Debug Message. Can be removed later
       // Printing all the parents of a selected Tap
       `dbg_display(" Depth of Tap_Node_q is : %0d",Tap_Node_q.size());
       for (int i = 0; i<Tap_Node_q.size(); i++) begin
          `dbg_display(" Values Tap_Node_q[%0d] is : %0s", 
             i,TapRegModel.StrTap(Tap_Node_q[i]));
       end
    end
    endtask : UpdateTapNodeQueue

    //This task reads all the SLVIDCODE in a given network
    //and compares with slvidcodes provided in file "JtagBfmSoCTapsInfo.svh".
    //"JtagBfmSoCTapsInfo.svh" is an output of CTT
    task TapAccessSlaveIdcode (input Tap_t Tap);
    begin
      logic [API_SIZE_OF_IR_REG-1:0]     RegisterInt   = 'h0C;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] expected_data = 0;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data1;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] compare_mask  = 0;
      int                                slvidcode;
      int                                unmask_idcode = '1;
      int                                lsb_idcode    = 1;
      bit                                en_user_defined_dr_length = 0;
      bit                                En_RegisterPresenceCheck = 1;
      int                                InputDrWidth;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData;
      Tap_t                              AllTapsEnabledQueueTemp[$];
      Tap_t                              LocalArray4[$];
      Tap_t                              LocalQueue4Temp[$];

      //Check whether Tap of interest exists in the network.
      GetTapAvailableStatus (Tap);

      //If Tap of interest exists in a given network then
      //proceed with enable and access operation.
      if (TapExistFlag == 1) begin
         //Enable Tap of interest before accessing any opcode.
         EnableTap (Tap);

         RegisterInt = Get_Tap_IDcodeOpcode (Tap);

         AccessTargetReg(
            .TapOfInterest           (Tap),
            .Opcode                  (RegisterInt),
            .InputDrWidth            (InputDrWidth),
            .InputDrData             (InputDrData),
            .ExpectedData            (expected_data),
            .Mask                    (compare_mask),
            .EnRegisterPresenceCheck (En_RegisterPresenceCheck),
            .EnUserDefinedDRLength   (en_user_defined_dr_length),
            .TDOData                 (tdo_data),
            .TDODataChopped          (tdo_data_chopped));

`ifndef JTAG_BFM_TAPLINK_MODE

         //Get all enabled Taps in given network
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = GetAllEnabledTaps();

         for (int j=0; j<AllTapsEnabledQueue.size(); j++) begin
            `dbg_display("Before sort AllTapsEnabledQueue [%0d] = %0d", j, AllTapsEnabledQueue[j]);
         end

         AllTapsDisabledQueue.delete();
         AllTapsDisabledQueue = GetAllDisabledTaps();

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsDisabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsOnOtherModes(Tap, AllTapsEnabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;


         LocalQueue4Temp.delete();
         AllTapsOnRemove.delete();
         AllTapsOnRemove = GetAllTapsOnRemove();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsOnRemove);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalArray4.delete();
         LocalArray4 = SortQueueBasedOnAfterTapOfInterest(AllTapsEnabledQueue);

         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalArray4;
         LocalArray4.delete();

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Sorted Slvidcode AllTapsEnabledQueue[%0d]", i, AllTapsEnabledQueue[i]);
         end

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Slvidcode ArrayOfHistoryElements[%0d].TapAfterTapOfInterestArray[%0d] = %0d",
               Tap, i, ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]]);
            if (ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]] == 1) begin
               AllTapsEnabledQueueTemp.push_back(AllTapsEnabledQueue[i]);
            end  
         end
         `dbg_display("Tap %0s", Tap);

         for (int i=0; i<AllTapsEnabledQueueTemp.size(); i++) begin
            `dbg_display("Slvidcode AllTapsEnabledQueueTemp[%0d]", i, AllTapsEnabledQueueTemp[i]);
         end
         `dbg_display("Slvidcode AllTapsEnabledQueueTemp", AllTapsEnabledQueueTemp);

         `dbg_display("AllTapsEnabledQueue.size()", AllTapsEnabledQueue.size());
         if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap == Tap_t'(0))) begin 
            tdo_data1 = tdo_data;
         end
         else
         begin
            tdo_data1 = (tdo_data >> AllTapsEnabledQueueTemp.size());
         end

         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         end //}

`else
         `dbg_display("Tap %0s", Tap);
         tdo_data1 = tdo_data_chopped;
         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         //if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         //end //}
`endif
         //if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap !== Tap_t'(0))) begin
         //   HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
         //   for (int k=HierarchyLevel_Internal; k>0;k--) begin
         //      for (int p=0; p<NUMBER_OF_TAPS; p++) begin
         //         if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
         //            if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	 //                    DisableTap(Tap_t'(p));
         //            end
         //         end
         //      end
         //   end
         //end
      end
      `dbg_display("TapAccessSlaveIdcode : RUTI ");
      Goto(RUTI,1);
      AllTapsEnabledQueue.delete();

    end
    endtask : TapAccessSlaveIdcode

    //This task used to do ARC TAP trasnactions through ENDEBUG.
    //This task similar to TapAccessSlaveIdcode. But there are two differences.
    //1) Programming of ENDEBUG_CFG[20] bit 
    //2) This task used for ENDEBUG only. Dont use this task in Normal Access.
    task TapAccessSlaveIdcodeArcEndbg (input Tap_t Tap);
    begin
      logic [API_SIZE_OF_IR_REG-1:0]     RegisterInt   = 'h0C;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] expected_data = 0;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data1;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] compare_mask  = 0;
      int                                slvidcode;
      int                                unmask_idcode = '1;
      int                                lsb_idcode    = 1;
      bit                                en_user_defined_dr_length = 0;
      bit                                En_RegisterPresenceCheck = 1;
      int                                InputDrWidth;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData;
      Tap_t                              AllTapsEnabledQueueTemp[$];
      Tap_t                              LocalArray4[$];
      Tap_t                              LocalQueue4Temp[$];

      //Check whether Tap of interest exists in the network.
      GetTapAvailableStatus (Tap);

`ifndef JTAGBFM_ENDEBUG_110REV
      //If Tap of interest exists in a given network then
      //proceed with enable and access operation.
      if (TapExistFlag == 1) begin
         //Enable Tap of interest before accessing any opcode.
         EnableTap (Tap);

         RegisterInt = Get_Tap_IDcodeOpcode (Tap);
         `ifdef JTAG_BFM_TAPLINK_MODE
            CLTAP_Ir_Width = Get_IR_Width(Tap_t'(0));
         `endif
         
         //This should execute only once:
         if(ArrayOfHistoryElements[Tap].TapChangedToEnabled == 0) begin
            ArcTapEnDbgCount = 0;
         end
         if((ArcTapEnDbgCount == 0) && (ArrayOfHistoryElements[Tap].TapChangedToEnabled == 0)) begin
            if ((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) begin
                JtagBfmEnDebug_FSMMODE00_RUTI_TO_TLRS (.CLTAPIrWidth(CLTAP_Ir_Width));
            end
            ArcTapEnDbgCount++;
         end
         
         ArrayOfHistoryElements[Tap].TapChangedToEnabled = 1;
         if ((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) begin
            ENDEBUG_ENCRYPTION_CFG.SKIPRUTISTATEEN = 1'b1;
            MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h1, ENDEBUG_ENCRYPTION_CFG, CLTAP_Ir_Width, ENDEBUG_CFG_REG_LENGTH);
         end
         AccessTargetReg(
            .TapOfInterest           (Tap),
            .Opcode                  (RegisterInt),
            .InputDrWidth            (InputDrWidth),
            .InputDrData             (InputDrData),
            .ExpectedData            (expected_data),
            .Mask                    (compare_mask),
            .EnRegisterPresenceCheck (En_RegisterPresenceCheck),
            .EnUserDefinedDRLength   (en_user_defined_dr_length),
            .TDOData                 (tdo_data),
            .TDODataChopped          (tdo_data_chopped));

`ifndef JTAG_BFM_TAPLINK_MODE

         //Get all enabled Taps in given network
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = GetAllEnabledTaps();

         for (int j=0; j<AllTapsEnabledQueue.size(); j++) begin
            `dbg_display("Before sort AllTapsEnabledQueue [%0d] = %0d", j, AllTapsEnabledQueue[j]);
         end

         AllTapsDisabledQueue.delete();
         AllTapsDisabledQueue = GetAllDisabledTaps();

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsDisabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsOnOtherModes(Tap, AllTapsEnabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;


         LocalQueue4Temp.delete();
         AllTapsOnRemove.delete();
         AllTapsOnRemove = GetAllTapsOnRemove();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsOnRemove);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalArray4.delete();
         LocalArray4 = SortQueueBasedOnAfterTapOfInterest(AllTapsEnabledQueue);

         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalArray4;
         LocalArray4.delete();

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Sorted Slvidcode AllTapsEnabledQueue[%0d]", i, AllTapsEnabledQueue[i]);
         end

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Slvidcode ArrayOfHistoryElements[%0d].TapAfterTapOfInterestArray[%0d] = %0d",
               Tap, i, ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]]);
            if (ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]] == 1) begin
               AllTapsEnabledQueueTemp.push_back(AllTapsEnabledQueue[i]);
            end  
         end
         `dbg_display("Tap %0s", Tap);

         for (int i=0; i<AllTapsEnabledQueueTemp.size(); i++) begin
            `dbg_display("Slvidcode AllTapsEnabledQueueTemp[%0d]", i, AllTapsEnabledQueueTemp[i]);
         end
         `dbg_display("Slvidcode AllTapsEnabledQueueTemp", AllTapsEnabledQueueTemp);

         `dbg_display("AllTapsEnabledQueue.size()", AllTapsEnabledQueue.size());
         if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap == Tap_t'(0))) begin 
            tdo_data1 = tdo_data;
         end
         else
         begin
            tdo_data1 = (tdo_data >> AllTapsEnabledQueueTemp.size());
         end

         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         end //}

`else
         `dbg_display("Tap %0s", Tap);
         tdo_data1 = tdo_data_chopped;
         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         //if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         //end //}
`endif
          if ((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) begin
             ENDEBUG_ENCRYPTION_CFG.SKIPRUTISTATEEN = 1'b0;
             MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h1, ENDEBUG_ENCRYPTION_CFG, CLTAP_Ir_Width, ENDEBUG_CFG_REG_LENGTH);
          end
          //HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
          //for (int k=HierarchyLevel_Internal; k>0;k--) begin
          //   for (int p=0; p<NUMBER_OF_TAPS; p++) begin
          //      if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
          //         if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	  //                 DisableTap(Tap_t'(p));
          //         end
          //      end
          //   end
          //end
      end
      `dbg_display("TapAccessSlaveIdcodeArcEndbg : RUTI ");
      Goto(RUTI,1);
      AllTapsEnabledQueue.delete();
`else
       `uvm_fatal(get_name(),"ENDEBUG Version 110 dont have ARCTAP support")
`endif

    end
    endtask : TapAccessSlaveIdcodeArcEndbg

    //This task used to do PHY TAP trasnactions through ENDEBUG.
    task TapAccessSlaveIdcodePhyEndbg (input Tap_t Tap);
    begin
      logic [API_SIZE_OF_IR_REG-1:0]     RegisterInt   = 'h0C;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] expected_data = 0;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data1;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] compare_mask  = 0;
      int                                slvidcode;
      int                                unmask_idcode = '1;
      int                                lsb_idcode    = 1;
      bit                                en_user_defined_dr_length = 0;
      bit                                En_RegisterPresenceCheck = 1;
      int                                InputDrWidth;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData;
      Tap_t                              AllTapsEnabledQueueTemp[$];
      Tap_t                              LocalArray4[$];
      Tap_t                              LocalQueue4Temp[$];

      //Check whether Tap of interest exists in the network.
      GetTapAvailableStatus (Tap);

      //If Tap of interest exists in a given network then
      //proceed with enable and access operation.
      if (TapExistFlag == 1) begin
         //Enable Tap of interest before accessing any opcode.
         EnableTap (Tap);

         RegisterInt = Get_Tap_IDcodeOpcode (Tap);
         `ifdef JTAG_BFM_TAPLINK_MODE
            CLTAP_Ir_Width = Get_IR_Width(Tap_t'(0));
         `endif

         //This should execute only once:
         if(ArrayOfHistoryElements[Tap].TapChangedToEnabled == 0) begin
            PhyTapEnDbgCount = 0;
         end
         if((PhyTapEnDbgCount == 0) && (ArrayOfHistoryElements[Tap].TapChangedToEnabled == 0)) begin
            if ((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) begin
                JtagBfmEnDebug_FSMMODE00_RUTI_TO_TLRS (.CLTAPIrWidth(CLTAP_Ir_Width));
            end
            PhyTapEnDbgCount++;
         end

         ArrayOfHistoryElements[Tap].TapChangedToEnabled = 1;
         AccessTargetReg(
            .TapOfInterest           (Tap),
            .Opcode                  (RegisterInt),
            .InputDrWidth            (InputDrWidth),
            .InputDrData             (InputDrData),
            .ExpectedData            (expected_data),
            .Mask                    (compare_mask),
            .EnRegisterPresenceCheck (En_RegisterPresenceCheck),
            .EnUserDefinedDRLength   (en_user_defined_dr_length),
            .TDOData                 (tdo_data),
            .TDODataChopped          (tdo_data_chopped));

`ifndef JTAG_BFM_TAPLINK_MODE

         //Get all enabled Taps in given network
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = GetAllEnabledTaps();

         for (int j=0; j<AllTapsEnabledQueue.size(); j++) begin
            `dbg_display("Before sort AllTapsEnabledQueue [%0d] = %0d", j, AllTapsEnabledQueue[j]);
         end

         AllTapsDisabledQueue.delete();
         AllTapsDisabledQueue = GetAllDisabledTaps();

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsDisabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsOnOtherModes(Tap, AllTapsEnabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;


         LocalQueue4Temp.delete();
         AllTapsOnRemove.delete();
         AllTapsOnRemove = GetAllTapsOnRemove();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsOnRemove);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalArray4.delete();
         LocalArray4 = SortQueueBasedOnAfterTapOfInterest(AllTapsEnabledQueue);

         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalArray4;
         LocalArray4.delete();

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Sorted Slvidcode AllTapsEnabledQueue[%0d]", i, AllTapsEnabledQueue[i]);
         end

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Slvidcode ArrayOfHistoryElements[%0d].TapAfterTapOfInterestArray[%0d] = %0d",
               Tap, i, ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]]);
            if (ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]] == 1) begin
               AllTapsEnabledQueueTemp.push_back(AllTapsEnabledQueue[i]);
            end  
         end
         `dbg_display("Tap %0s", Tap);

         for (int i=0; i<AllTapsEnabledQueueTemp.size(); i++) begin
            `dbg_display("Slvidcode AllTapsEnabledQueueTemp[%0d]", i, AllTapsEnabledQueueTemp[i]);
         end
         `dbg_display("Slvidcode AllTapsEnabledQueueTemp", AllTapsEnabledQueueTemp);

         `dbg_display("AllTapsEnabledQueue.size()", AllTapsEnabledQueue.size());
         if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap == Tap_t'(0))) begin 
            tdo_data1 = tdo_data;
         end
         else
         begin
            tdo_data1 = (tdo_data >> AllTapsEnabledQueueTemp.size());
         end

         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         end //}

`else
         `dbg_display("Tap %0s", Tap);
         tdo_data1 = tdo_data_chopped;
         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         //if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         //end //}
`endif
          //HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
          //for (int k=HierarchyLevel_Internal; k>0;k--) begin
          //   for (int p=0; p<NUMBER_OF_TAPS; p++) begin
          //      if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
          //         if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	  //                 DisableTap(Tap_t'(p));
          //         end
          //      end
          //   end
          //end
      end
      `dbg_display("TapAccessSlaveIdcodePhyEndbg : RUTI ");
      Goto(RUTI,1);
      AllTapsEnabledQueue.delete();

    end
    endtask : TapAccessSlaveIdcodePhyEndbg

    //This task reads all the SLVIDCODE in a given network
    //and compares with slvidcodes provided in file "JtagBfmSoCTapsInfo.svh".
    //"JtagBfmSoCTapsInfo.svh" is an output of CTT
    task TapAccessSlaveIdcodeRuti (input Tap_t Tap, input [63:0] RutiLen = 1);
    begin
      logic [API_SIZE_OF_IR_REG-1:0]     RegisterInt   = 'h0C;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] expected_data = 0;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data1;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] compare_mask  = 0;
      int                                slvidcode;
      int                                unmask_idcode = '1;
      int                                lsb_idcode    = 1;
      bit                                en_user_defined_dr_length = 0;
      bit                                En_RegisterPresenceCheck = 1;
      int                                InputDrWidth;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData;
      Tap_t                              AllTapsEnabledQueueTemp[$];
      Tap_t                              LocalArray4[$];
      Tap_t                              LocalQueue4Temp[$];

      //Check whether Tap of interest exists in the network.
      GetTapAvailableStatus (Tap);

      //If Tap of interest exists in a given network then
      //proceed with enable and access operation.
      if (TapExistFlag == 1) begin
         //Enable Tap of interest before accessing any opcode.
         EnableTap (Tap);
         Goto(RUTI,RutiLen);

         RegisterInt = Get_Tap_IDcodeOpcode (Tap);

         AccessTargetReg(
            .TapOfInterest           (Tap),
            .Opcode                  (RegisterInt),
            .InputDrWidth            (InputDrWidth),
            .InputDrData             (InputDrData),
            .ExpectedData            (expected_data),
            .Mask                    (compare_mask),
            .EnRegisterPresenceCheck (En_RegisterPresenceCheck),
            .EnUserDefinedDRLength   (en_user_defined_dr_length),
            .TDOData                 (tdo_data),
            .TDODataChopped          (tdo_data_chopped));

`ifndef JTAG_BFM_TAPLINK_MODE

         //Get all enabled Taps in given network
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = GetAllEnabledTaps();

         for (int j=0; j<AllTapsEnabledQueue.size(); j++) begin
            `dbg_display("Before sort AllTapsEnabledQueue [%0d] = %0d", j, AllTapsEnabledQueue[j]);
         end

         AllTapsDisabledQueue.delete();
         AllTapsDisabledQueue = GetAllDisabledTaps();

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsDisabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsOnOtherModes(Tap, AllTapsEnabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;


         LocalQueue4Temp.delete();
         AllTapsOnRemove.delete();
         AllTapsOnRemove = GetAllTapsOnRemove();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsOnRemove);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalArray4.delete();
         LocalArray4 = SortQueueBasedOnAfterTapOfInterest(AllTapsEnabledQueue);

         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalArray4;
         LocalArray4.delete();

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Sorted Slvidcode AllTapsEnabledQueue[%0d]", i, AllTapsEnabledQueue[i]);
         end

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Slvidcode ArrayOfHistoryElements[%0d].TapAfterTapOfInterestArray[%0d] = %0d",
               Tap, i, ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]]);
            if (ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]] == 1) begin
               AllTapsEnabledQueueTemp.push_back(AllTapsEnabledQueue[i]);
            end  
         end
         `dbg_display("Tap %0s", Tap);

         for (int i=0; i<AllTapsEnabledQueueTemp.size(); i++) begin
            `dbg_display("Slvidcode AllTapsEnabledQueueTemp[%0d]", i, AllTapsEnabledQueueTemp[i]);
         end
         `dbg_display("Slvidcode AllTapsEnabledQueueTemp", AllTapsEnabledQueueTemp);

         `dbg_display("AllTapsEnabledQueue.size()", AllTapsEnabledQueue.size());
         if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap == Tap_t'(0))) begin 
            tdo_data1 = tdo_data;
         end
         else
         begin
            tdo_data1 = (tdo_data >> AllTapsEnabledQueueTemp.size());
         end

         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         end //}

`else
         `dbg_display("Tap %0s", Tap);
         tdo_data1 = tdo_data_chopped;
         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         //if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         //end //}
`endif
       //  if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap !== Tap_t'(0))) begin
       //     HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
       //     for (int k=HierarchyLevel_Internal; k>0;k--) begin
       //        for (int p=0; p<NUMBER_OF_TAPS; p++) begin
       //           if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
       //              if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
       //                      DisableTap(Tap_t'(p));
       //              end
       //           end
       //        end
       //     end
       //  end
      end
      `dbg_display("TapAccessSlaveIdcodeRuti : RUTI ");
      Goto(RUTI,1);
      AllTapsEnabledQueue.delete();

    end
    endtask : TapAccessSlaveIdcodeRuti

    //This task reads all the SLVIDCODE in a given network
    //and compares with slvidcodes provided in file "JtagBfmSoCTapsInfo.svh".
    //"JtagBfmSoCTapsInfo.svh" is an output of CTT.
    // https://hsdes.intel.com/appstore/article/#/1604609162
    task TapAccessSlaveIdcodeGetStatus (input Tap_t Tap, output bit Status);
    begin
      logic [API_SIZE_OF_IR_REG-1:0]     RegisterInt   = 'h0C;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] expected_data = 0;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data1;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] compare_mask  = 0;
      int                                slvidcode;
      int                                unmask_idcode = '1;
      int                                lsb_idcode    = 1;
      bit                                en_user_defined_dr_length = 0;
      bit                                En_RegisterPresenceCheck = 1;
      int                                InputDrWidth;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData;
      Tap_t                              AllTapsEnabledQueueTemp[$];
      Tap_t                              LocalArray4[$];
      Tap_t                              LocalQueue4Temp[$];

      //Check whether Tap of interest exists in the network.
      GetTapAvailableStatus (Tap);

      //If Tap of interest exists in a given network then
      //proceed with enable and access operation.
      if (TapExistFlag == 1) begin
         //Enable Tap of interest before accessing any opcode.
         EnableTap (Tap);

         RegisterInt = Get_Tap_IDcodeOpcode (Tap);

         AccessTargetReg(
            .TapOfInterest           (Tap),
            .Opcode                  (RegisterInt),
            .InputDrWidth            (InputDrWidth),
            .InputDrData             (InputDrData),
            .ExpectedData            (expected_data),
            .Mask                    (compare_mask),
            .EnRegisterPresenceCheck (En_RegisterPresenceCheck),
            .EnUserDefinedDRLength   (en_user_defined_dr_length),
            .TDOData                 (tdo_data),
            .TDODataChopped          (tdo_data_chopped));

`ifndef JTAG_BFM_TAPLINK_MODE

         //Get all enabled Taps in given network
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = GetAllEnabledTaps();

         for (int j=0; j<AllTapsEnabledQueue.size(); j++) begin
            `dbg_display("Before sort AllTapsEnabledQueue [%0d] = %0d", j, AllTapsEnabledQueue[j]);
         end

         AllTapsDisabledQueue.delete();
         AllTapsDisabledQueue = GetAllDisabledTaps();

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsDisabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsOnOtherModes(Tap, AllTapsEnabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;


         LocalQueue4Temp.delete();
         AllTapsOnRemove.delete();
         AllTapsOnRemove = GetAllTapsOnRemove();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsOnRemove);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalArray4.delete();
         LocalArray4 = SortQueueBasedOnAfterTapOfInterest(AllTapsEnabledQueue);

         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalArray4;
         LocalArray4.delete();

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Sorted Slvidcode AllTapsEnabledQueue[%0d]", i, AllTapsEnabledQueue[i]);
         end

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Slvidcode ArrayOfHistoryElements[%0d].TapAfterTapOfInterestArray[%0d] = %0d",
               Tap, i, ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]]);
            if (ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]] == 1) begin
               AllTapsEnabledQueueTemp.push_back(AllTapsEnabledQueue[i]);
            end  
         end
         `dbg_display("Tap %0s", Tap);

         for (int i=0; i<AllTapsEnabledQueueTemp.size(); i++) begin
            `dbg_display("Slvidcode AllTapsEnabledQueueTemp[%0d]", i, AllTapsEnabledQueueTemp[i]);
         end
         `dbg_display("Slvidcode AllTapsEnabledQueueTemp", AllTapsEnabledQueueTemp);

         `dbg_display("AllTapsEnabledQueue.size()", AllTapsEnabledQueue.size());
         if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap == Tap_t'(0)) ) begin 
            tdo_data1 = tdo_data;
         end
         else
         begin
            tdo_data1 = (tdo_data >> AllTapsEnabledQueueTemp.size());
         end

         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               Status = 1'b1;
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h. SlaveIdCode Read Status is PASS",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               Status = 1'b0;
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h. SlaveIdCode Read Status is FAIL",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         end //}

`else
         `dbg_display("Tap %0s", Tap);
         tdo_data1 = tdo_data_chopped;
         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         //if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               Status = 1'b1;
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h. SlaveIdCode Read Status is PASS",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               Status = 1'b0;
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h. SlaveIdCode Read Status is FAIL",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         //end //}
`endif

         //if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap !== Tap_t'(0))) begin
         //   HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
         //   for (int k=HierarchyLevel_Internal; k>0;k--) begin
         //      for (int p=0; p<NUMBER_OF_TAPS; p++) begin
         //         if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
         //            if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	 //                    DisableTap(Tap_t'(p));
         //            end
         //         end
         //      end
         //   end
         //end
      end
      `dbg_display("TapAccessSlaveIdcodeGetStatus: RUTI ");
      Goto(RUTI,1);
      AllTapsEnabledQueue.delete();

    end
    endtask : TapAccessSlaveIdcodeGetStatus

    //This task reads all the SLVIDCODE in a given network
    //and compares with slvidcodes provided in file "JtagBfmSoCTapsInfo.svh".
    //"JtagBfmSoCTapsInfo.svh" is an output of CTT.
    // https://hsdes.intel.com/appstore/article/#/1604609162
    task TapAccessSlaveIdcodeGetStatusRuti (input Tap_t Tap, input [63:0] RutiLen = 1, output bit Status);
    begin
      logic [API_SIZE_OF_IR_REG-1:0]     RegisterInt   = 'h0C;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] expected_data = 0;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data1;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] compare_mask  = 0;
      int                                slvidcode;
      int                                unmask_idcode = '1;
      int                                lsb_idcode    = 1;
      bit                                en_user_defined_dr_length = 0;
      bit                                En_RegisterPresenceCheck = 1;
      int                                InputDrWidth;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData;
      Tap_t                              AllTapsEnabledQueueTemp[$];
      Tap_t                              LocalArray4[$];
      Tap_t                              LocalQueue4Temp[$];

      //Check whether Tap of interest exists in the network.
      GetTapAvailableStatus (Tap);

      //If Tap of interest exists in a given network then
      //proceed with enable and access operation.
      if (TapExistFlag == 1) begin
         //Enable Tap of interest before accessing any opcode.
         EnableTap (Tap);
         Goto(RUTI,RutiLen);

         RegisterInt = Get_Tap_IDcodeOpcode (Tap);

         AccessTargetReg(
            .TapOfInterest           (Tap),
            .Opcode                  (RegisterInt),
            .InputDrWidth            (InputDrWidth),
            .InputDrData             (InputDrData),
            .ExpectedData            (expected_data),
            .Mask                    (compare_mask),
            .EnRegisterPresenceCheck (En_RegisterPresenceCheck),
            .EnUserDefinedDRLength   (en_user_defined_dr_length),
            .TDOData                 (tdo_data),
            .TDODataChopped          (tdo_data_chopped));

`ifndef JTAG_BFM_TAPLINK_MODE

         //Get all enabled Taps in given network
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = GetAllEnabledTaps();

         for (int j=0; j<AllTapsEnabledQueue.size(); j++) begin
            `dbg_display("Before sort AllTapsEnabledQueue [%0d] = %0d", j, AllTapsEnabledQueue[j]);
         end

         AllTapsDisabledQueue.delete();
         AllTapsDisabledQueue = GetAllDisabledTaps();

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsDisabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsOnOtherModes(Tap, AllTapsEnabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;


         LocalQueue4Temp.delete();
         AllTapsOnRemove.delete();
         AllTapsOnRemove = GetAllTapsOnRemove();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsOnRemove);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalArray4.delete();
         LocalArray4 = SortQueueBasedOnAfterTapOfInterest(AllTapsEnabledQueue);

         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalArray4;
         LocalArray4.delete();

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Sorted Slvidcode AllTapsEnabledQueue[%0d]", i, AllTapsEnabledQueue[i]);
         end

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Slvidcode ArrayOfHistoryElements[%0d].TapAfterTapOfInterestArray[%0d] = %0d",
               Tap, i, ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]]);
            if (ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]] == 1) begin
               AllTapsEnabledQueueTemp.push_back(AllTapsEnabledQueue[i]);
            end  
         end
         `dbg_display("Tap %0s", Tap);

         for (int i=0; i<AllTapsEnabledQueueTemp.size(); i++) begin
            `dbg_display("Slvidcode AllTapsEnabledQueueTemp[%0d]", i, AllTapsEnabledQueueTemp[i]);
         end
         `dbg_display("Slvidcode AllTapsEnabledQueueTemp", AllTapsEnabledQueueTemp);

         `dbg_display("AllTapsEnabledQueue.size()", AllTapsEnabledQueue.size());
         if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap == Tap_t'(0)) ) begin 
            tdo_data1 = tdo_data;
         end
         else
         begin
            tdo_data1 = (tdo_data >> AllTapsEnabledQueueTemp.size());
         end

         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               Status = 1'b1;
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h. SlaveIdCode Read Status is PASS",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               Status = 1'b0;
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h. SlaveIdCode Read Status is FAIL",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         end //}

`else
         `dbg_display("Tap %0s", Tap);
         tdo_data1 = tdo_data_chopped;
         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         slvidcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("From History Table slvidcode [%0s] = %0h", TapRegModel.StrTap(Tap), slvidcode);

         //if (ArrayOfHistoryElements[Tap].IsTapDisabled != 1) begin //{
            if ((tdo_data1 & unmask_idcode) == (slvidcode | lsb_idcode)) begin
               Status = 1'b1;
               `uvm_info("",$psprintf("slvidcode read passed. slvidcode tdo_data1 collected [%0s] = %0h. SlaveIdCode Read Status is PASS",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end else begin
               Status = 1'b0;
               `uvm_error("",$psprintf("slvidcode read failed. slvidcode tdo_data1 collected [%0s] = %0h. SlaveIdCode Read Status is FAIL",
                  TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
               `uvm_info("",$psprintf("slvidcode expect data from CTT [%0s] = %0h",
                  TapRegModel.StrTap(Tap), (slvidcode | lsb_idcode)),UVM_NONE);
            end
         //end //}
`endif

         //if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap !== Tap_t'(0))) begin
         //   HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
         //   for (int k=HierarchyLevel_Internal; k>0;k--) begin
         //      for (int p=0; p<NUMBER_OF_TAPS; p++) begin
         //         if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
         //            if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	 //                    DisableTap(Tap_t'(p));
         //            end
         //         end
         //      end
         //   end
         //end
      end
      `dbg_display("TapAccessSlaveIdcodeGetStatusRuti: RUTI ");
      Goto(RUTI,1);
      AllTapsEnabledQueue.delete();

    end
    endtask : TapAccessSlaveIdcodeGetStatusRuti

    task TapAccessCltapcIdcode (input Tap_t Tap);
    begin
      logic [API_SIZE_OF_IR_REG-1:0]     RegisterInt   = 'h02;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] expected_data = 0;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data1;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] compare_mask  = 0;
      int                                idcode;
      int                                unmask_idcode = '1;
      int                                lsb_idcode    = 1;
      bit                                en_user_defined_dr_length = 0;
      bit                                En_RegisterPresenceCheck = 1;
      int                                InputDrWidth;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData;
      Tap_t                              AllTapsEnabledQueueTemp[$];
      Tap_t                              LocalArray4[$];
      Tap_t                              LocalQueue4Temp[$];

      //Check whether Tap of interest exists in the network.
      GetTapAvailableStatus (Tap);

      RegisterInt = Get_Tap_IDcodeOpcode (Tap);
      //If Tap of interest exists in a given network then
      //proceed with enable and access operation.
      if (TapExistFlag == 1) begin

         //Enable Tap of interest before accessing any opcode.
         EnableTap (Tap);

         AccessTargetReg(
            .TapOfInterest           (Tap),
            .Opcode                  (RegisterInt),
            .InputDrWidth            (InputDrWidth),
            .InputDrData             (InputDrData),
            .ExpectedData            (expected_data),
            .Mask                    (compare_mask),
            .EnRegisterPresenceCheck (En_RegisterPresenceCheck),
            .EnUserDefinedDRLength   (en_user_defined_dr_length),
            .TDOData                 (tdo_data),
            .TDODataChopped          (tdo_data_chopped));
         
`ifndef JTAG_BFM_TAPLINK_MODE

         //Get all enabled Taps in given network
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = GetAllEnabledTaps();

         for (int j=0; j<AllTapsEnabledQueue.size(); j++) begin
            `dbg_display("Before sort AllTapsEnabledQueue [%0d] = %0d", j, AllTapsEnabledQueue[j]);
         end

         AllTapsDisabledQueue.delete();
         AllTapsDisabledQueue = GetAllDisabledTaps();

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsDisabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsOnOtherModes(Tap, AllTapsEnabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;


         LocalQueue4Temp.delete();
         AllTapsOnRemove.delete();
         AllTapsOnRemove = GetAllTapsOnRemove();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsOnRemove);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalArray4.delete();
         LocalArray4 = SortQueueBasedOnAfterTapOfInterest(AllTapsEnabledQueue);

         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalArray4;
         LocalArray4.delete();

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Sorted idcode AllTapsEnabledQueue[%0d]", i, AllTapsEnabledQueue[i]);
         end

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("idcode ArrayOfHistoryElements[%0d].TapAfterTapOfInterestArray[%0d] = %0d",
               Tap, i, ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]]);
            if (ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]] == 1) begin
               AllTapsEnabledQueueTemp.push_back(AllTapsEnabledQueue[i]);
            end  
         end
         `dbg_display("Tap %0s", Tap);

         for (int i=0; i<AllTapsEnabledQueueTemp.size(); i++) begin
            `dbg_display("idcode AllTapsEnabledQueueTemp[%0d]", i, AllTapsEnabledQueueTemp[i]);
         end
         `dbg_display("idcode AllTapsEnabledQueueTemp", AllTapsEnabledQueueTemp);

         `dbg_display("AllTapsEnabledQueue.size()", AllTapsEnabledQueue.size());
         if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap == Tap_t'(0)) ) begin 
            tdo_data1 = tdo_data;
         end
         else
         begin
            tdo_data1 = (tdo_data >> AllTapsEnabledQueueTemp.size());
         end

`else
         `dbg_display("Tap %0s", Tap);
         tdo_data1 = tdo_data_chopped;

`endif

         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         idcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("idcode [%0s] = %0h", TapRegModel.StrTap(Tap), idcode);

         if ((tdo_data1 & unmask_idcode) == (idcode | lsb_idcode)) begin
            `uvm_info("",$psprintf("idcode read passed. idcode tdo_data1 collected [%0s] = %0h",
               TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
         end else begin
            `uvm_error("",$psprintf("idcode read failed. idcode tdo_data1 collected [%0s] = %0h",
               TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
         end
         //if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap !== Tap_t'(0))) begin
         //   HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
         //   for (int k=HierarchyLevel_Internal; k>0;k--) begin
         //      for (int p=0; p<NUMBER_OF_TAPS; p++) begin
         //         if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
         //            if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	 //                    DisableTap(Tap_t'(p));
         //            end
         //         end
         //      end
         //   end
         //end
      end
      `dbg_display("TapAccessCltapcIdcode : RUTI ");
      Goto(RUTI,1);
      AllTapsEnabledQueue.delete();

    end
    endtask : TapAccessCltapcIdcode

    task TapAccessCltapcIdcodeGetStatus (input Tap_t Tap, output bit Status);
    begin
      logic [API_SIZE_OF_IR_REG-1:0]     RegisterInt   = 'h02;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] expected_data = 0;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data1;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] compare_mask  = 0;
      int                                idcode;
      int                                unmask_idcode = '1;
      int                                lsb_idcode    = 1;
      bit                                en_user_defined_dr_length = 0;
      bit                                En_RegisterPresenceCheck = 1;
      int                                InputDrWidth;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData;
      Tap_t                              AllTapsEnabledQueueTemp[$];
      Tap_t                              LocalArray4[$];
      Tap_t                              LocalQueue4Temp[$];

      //Check whether Tap of interest exists in the network.
      GetTapAvailableStatus (Tap);

      RegisterInt = Get_Tap_IDcodeOpcode (Tap);
      //If Tap of interest exists in a given network then
      //proceed with enable and access operation.
      if (TapExistFlag == 1) begin

         //Enable Tap of interest before accessing any opcode.
         EnableTap (Tap);

         AccessTargetReg(
            .TapOfInterest           (Tap),
            .Opcode                  (RegisterInt),
            .InputDrWidth            (InputDrWidth),
            .InputDrData             (InputDrData),
            .ExpectedData            (expected_data),
            .Mask                    (compare_mask),
            .EnRegisterPresenceCheck (En_RegisterPresenceCheck),
            .EnUserDefinedDRLength   (en_user_defined_dr_length),
            .TDOData                 (tdo_data),
            .TDODataChopped          (tdo_data_chopped));
         
`ifndef JTAG_BFM_TAPLINK_MODE

         //Get all enabled Taps in given network
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = GetAllEnabledTaps();

         for (int j=0; j<AllTapsEnabledQueue.size(); j++) begin
            `dbg_display("Before sort AllTapsEnabledQueue [%0d] = %0d", j, AllTapsEnabledQueue[j]);
         end

         AllTapsDisabledQueue.delete();
         AllTapsDisabledQueue = GetAllDisabledTaps();

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsDisabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalQueue4Temp.delete();
         LocalQueue4Temp = DeleteTapsOnOtherModes(Tap, AllTapsEnabledQueue);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;


         LocalQueue4Temp.delete();
         AllTapsOnRemove.delete();
         AllTapsOnRemove = GetAllTapsOnRemove();
         LocalQueue4Temp = DeleteTapsFromTapsQueue(AllTapsEnabledQueue, AllTapsOnRemove);
         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalQueue4Temp;

         LocalArray4.delete();
         LocalArray4 = SortQueueBasedOnAfterTapOfInterest(AllTapsEnabledQueue);

         AllTapsEnabledQueue.delete();
         AllTapsEnabledQueue = LocalArray4;
         LocalArray4.delete();

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("Sorted idcode AllTapsEnabledQueue[%0d]", i, AllTapsEnabledQueue[i]);
         end

         for (int i=0; i<AllTapsEnabledQueue.size(); i++) begin
            `dbg_display("idcode ArrayOfHistoryElements[%0d].TapAfterTapOfInterestArray[%0d] = %0d",
               Tap, i, ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]]);
            if (ArrayOfHistoryElements[Tap].TapAfterTapOfInterestArray[AllTapsEnabledQueue[i]] == 1) begin
               AllTapsEnabledQueueTemp.push_back(AllTapsEnabledQueue[i]);
            end  
         end
         `dbg_display("Tap %0s", Tap);

         for (int i=0; i<AllTapsEnabledQueueTemp.size(); i++) begin
            `dbg_display("idcode AllTapsEnabledQueueTemp[%0d]", i, AllTapsEnabledQueueTemp[i]);
         end
         `dbg_display("idcode AllTapsEnabledQueueTemp", AllTapsEnabledQueueTemp);

         `dbg_display("AllTapsEnabledQueue.size()", AllTapsEnabledQueue.size());
         if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap == Tap_t'(0))) begin 
            tdo_data1 = tdo_data;
         end
         else
         begin
            tdo_data1 = (tdo_data >> AllTapsEnabledQueueTemp.size());
         end

`else
         `dbg_display("Tap %0s", Tap);
         tdo_data1 = tdo_data_chopped;

`endif

         `dbg_display("tdo_data  = %0h", tdo_data);
         `dbg_display("tdo_data1 = %0h", tdo_data1);
         idcode = Get_Tap_SlvIDcode(Tap);
         `dbg_display("idcode [%0s] = %0h", TapRegModel.StrTap(Tap), idcode);

         if ((tdo_data1 & unmask_idcode) == (idcode | lsb_idcode)) begin
            Status = 1'b1;
            `uvm_info("",$psprintf("idcode read passed. idcode tdo_data1 collected [%0s] = %0h. SlaveIdCode Read Status is PASS",
               TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)),UVM_NONE);
         end else begin
            Status = 1'b0;
            `uvm_error("",$psprintf("idcode read failed. idcode tdo_data1 collected [%0s] = %0h. SlaveIdCode Read Status is FAIL",
               TapRegModel.StrTap(Tap), (tdo_data1 & unmask_idcode)));
         end
         //if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap !== Tap_t'(0))) begin
         //   HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
         //   for (int k=HierarchyLevel_Internal; k>0;k--) begin
         //      for (int p=0; p<NUMBER_OF_TAPS; p++) begin
         //         if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
         //            if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	 //                    DisableTap(Tap_t'(p));
         //            end
         //         end
         //      end
         //   end
         //end
      end
      `dbg_display("TapAccessCltapcIdcodeGetStatus : RUTI ");
      Goto(RUTI,1);
      AllTapsEnabledQueue.delete();

    end
    endtask : TapAccessCltapcIdcodeGetStatus

    //Enable Tap of interest before accessing any opcode.
    task EnableTap (input Tap_t TapOfInterest = Tap_t'(0));
    begin

       `uvm_info (get_type_name(), $psprintf("JTAGBFM: Enabling TAP %s...", TapOfInterest.name()), UVM_LOW);

       // HSD_5075802 
       if (PreviousAccesedTapOfInterest == TapOfInterest) begin
          IsSameTapAccessed = 1'b1;
       end
       else begin
          IsSameTapAccessed = 1'b0;
       end
       `dbg_display("1.PreviousAccesedTapOfInterest = %0d", PreviousAccesedTapOfInterest);
       PreviousAccesedTapOfInterest = TapOfInterest;
       `dbg_display("2.PreviousAccesedTapOfInterest = %0d", PreviousAccesedTapOfInterest);

       //Check whether Tap of interest exists in the network.
       GetTapAvailableStatus (TapOfInterest);
       if (ArrayOfHistoryElements[TapOfInterest].TapDisabledByParent == 1) begin
          if ((ENDEBUG_OWN == 1'b0) || (FuseDisable == 1'b1)) begin
             `uvm_error("",$psprintf("%0s is TapDisabledByParent and can not be accessed until parent is enabled", TapOfInterest));
          end
       end
       //if ((ENDEBUG_OWN == 1'b0) || (FuseDisable == 1'b1) || (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b1)) begin
          if (TapExistFlag == 1) begin
             if (ArrayOfHistoryElements[TapOfInterest].IsTapEnabled != 1) begin
                `dbg_display("ArrayOfHistoryElements[%0s].IsTapDisabled",
                   TapOfInterest, ArrayOfHistoryElements[TapOfInterest].IsTapDisabled);
                `dbg_display("ArrayOfHistoryElements[%0s].TapDisabledByParent",
                   TapOfInterest, ArrayOfHistoryElements[TapOfInterest].TapDisabledByParent);

                if ((ArrayOfHistoryElements[TapOfInterest].IsTapDisabled       == 1) &&
                    (ArrayOfHistoryElements[TapOfInterest].TapDisabledByParent != 1)) begin
                   EnableTapInternal(TapOfInterest);
                end  

                if ((ArrayOfHistoryElements[TapOfInterest].IsTapShadowed       == 1) &&
                    (ArrayOfHistoryElements[TapOfInterest].TapShadowedByParent != 1)) begin
                   EnableTapInternal(TapOfInterest);
                end  
             end  
          end
       //end
       //else
       //begin
       //   if (TapExistFlag == 1) begin
       //      EnableTapInternal(TapOfInterest);
       //   end
       //end

    end
    endtask : EnableTap



    task EnableTapForMultiAccess (input Tap_t TapOfInterest = Tap_t'(0));
    begin
       EnableTap (TapOfInterest);
       ArrayOfHistoryElements[TapOfInterest].EnableMultiTapAccess = 1;
      `dbg_display("From task EnableTapForMultiAccess, EnableMultiTapAccess[%0s] = %0b",
                 TapOfInterest, ArrayOfHistoryElements[TapOfInterest].EnableMultiTapAccess);
    end
    endtask : EnableTapForMultiAccess


    task DisableTap (input Tap_t TapOfInterest = Tap_t'(0));
    begin

        `uvm_info (get_type_name(), $psprintf("JTAGBFM: Disabling TAP %s...", TapOfInterest.name()), UVM_LOW);

       // HSD_5075802 
       if (PreviousAccesedTapOfInterest == TapOfInterest) begin
          IsSameTapAccessed = 1'b1;
       end
       else begin
          IsSameTapAccessed = 1'b0;
       end
       PreviousAccesedTapOfInterest = TapOfInterest;
       // HSD_5152489 - IR Register stays in FF when disabling and re-enabling STAP using the same opcode
       IrChainValue1_previous = 0;

       //Check whether Tap of interest exists in the network.
       GetTapAvailableStatus (TapOfInterest);
       //if ((ENDEBUG_OWN == 1'b0) || (FuseDisable == 1'b1) || (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b1)) begin
          if (TapExistFlag == 1) begin
             if (ArrayOfHistoryElements[TapOfInterest].IsTapDisabled != 1) begin
                DisableTapInternal(TapOfInterest);
                ArrayOfHistoryElements[TapOfInterest].TapChangedToEnabled = 0;
             end
          end
       //end
       //else
       //begin
       //   if (TapExistFlag == 1) begin
       //      DisableTapInternal(TapOfInterest);
       //   end
       //end
    end
    endtask : DisableTap


    task ShadowTap (input Tap_t TapOfInterest = Tap_t'(0));
    begin
       //Check whether Tap of interest exists in the network.
       GetTapAvailableStatus (TapOfInterest);
       if (TapExistFlag == 1) begin
          if (ArrayOfHistoryElements[TapOfInterest].IsTapShadowed != 1) begin
             EnableTap(ArrayOfHistoryElements[TapOfInterest].ParentTap);
             ShadowTapInternal(TapOfInterest);
          end
       end
    end
    endtask : ShadowTap


    task DisableTapForMultiAccess(input Tap_t TapOfInterest = Tap_t'(0));
    begin
       DisableTap(TapOfInterest);
       ArrayOfHistoryElements[TapOfInterest].EnableMultiTapAccess = 0;
    end
    endtask : DisableTapForMultiAccess

    task ClearMultiTapCapabilityOnly(input Tap_t TapOfInterest = Tap_t'(0));
    begin
       ArrayOfHistoryElements[TapOfInterest].EnableMultiTapAccess = 0;
    end
    endtask : ClearMultiTapCapabilityOnly

    task SetMultiTapCapabilityOnly(input Tap_t TapOfInterest = Tap_t'(0));
    begin
       ArrayOfHistoryElements[TapOfInterest].EnableMultiTapAccess = 1;
       `dbg_display ("SetMultiTapCapabilityOnly ArrayOfHistoryElements[%0s].EnableMultiTapAccess = %0h",
                      TapOfInterest, ArrayOfHistoryElements[TapOfInterest].EnableMultiTapAccess);
    end
    endtask : SetMultiTapCapabilityOnly

    function GetPathTillCltap (input Tap_t TapOfInterest = Tap_t'(0));
    begin
       PathTillCltapQueue.delete();
       PathTillCltapQueue = ArrayOfHistoryElements[TapOfInterest].NodeQueue;
       `dbg_display("GetPathTillCltap = %0d", TapOfInterest);
       `dbg_display("PathTillCltapQueue.size = %0d", PathTillCltapQueue.size());
       for (int i=0; i<PathTillCltapQueue.size(); i++) begin
          `dbg_display("GetPathTillCltap PathTillCltapQueue[%0d] = %0d", i, PathTillCltapQueue[i]);
       end  
    end
    endfunction : GetPathTillCltap

    //Get all enabled Taps in given network
    //At the end of task "AllTapsEnabledQueue" is filled with Taps which are enable
    //Example:
    //AllTapsEnabledQueue =
    //'{STAP29, STAP3, STAP2, STAP1, CLTAP}
    function TypeQueueOfTap_t GetAllEnabledTaps();
    begin
       int   k;
       Tap_t AllTapsEnabledQueueLocal[$];
       AllTapsEnabledQueueLocal.delete();
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          if (ArrayOfHistoryElements[i].IsTapEnabled == 1) begin
             AllTapsEnabledQueueLocal.push_front(Tap_t'(i));
             k++;
          end  
       end
       for (int i=0; i<AllTapsEnabledQueueLocal.size(); i++) begin
          `dbg_display("3 AllTapsEnabledQueueLocal[%0d]", i, AllTapsEnabledQueueLocal[i]);
       end
       `dbg_display("AllTapsEnabledQueueLocal = ", AllTapsEnabledQueueLocal);
       return (AllTapsEnabledQueueLocal);
    end
    endfunction : GetAllEnabledTaps


    function TypeQueueOfTap_t DeleteTapsOnOtherModes(
       input Tap_t TapOfInterest = Tap_t'(0),
       input Tap_t InputQueue[$]);
    begin
       Tap_t WorkingQueue[$];
       Tap_t AllTapsOnPrimary[$];
       Tap_t AllTapsOnSecondary[$];
       Tap_t AllTapsOnAllTertiaries[$];
       Tap_t AllTapsOnOtherTertiaries[$];
       Tap_t InputQueueLocal[$];

       InputQueueLocal.delete();
       InputQueueLocal = InputQueue;
       `dbg_display("DeleteTapsOnOtherModes: InputQueue = ", InputQueue);
       `dbg_display("DeleteTapsOnOtherModes: InputQueueLocal = ", InputQueueLocal);

       if (ArrayOfHistoryElements[TapOfInterest].IsTapOnPrimary == 1) begin //{
          // Remove those TAP entries that are on Secondary
          WorkingQueue.delete();
          AllTapsOnSecondary.delete();
          AllTapsOnSecondary = GetAllTapsOnSecondary();
          WorkingQueue = DeleteTapsFromTapsQueue(InputQueueLocal, AllTapsOnSecondary);
          InputQueueLocal.delete();
          InputQueueLocal = WorkingQueue;

          // Remove those TAP entries that are all Tertiary
          WorkingQueue.delete();
          AllTapsOnAllTertiaries.delete();
          AllTapsOnAllTertiaries = GetAllTapsOnAllTertiaries();
          WorkingQueue = DeleteTapsFromTapsQueue(InputQueueLocal, AllTapsOnAllTertiaries);
          InputQueueLocal.delete();
          InputQueueLocal = WorkingQueue;

          `dbg_display("IsTapOnPrimary: InputQueueLocal = ", InputQueueLocal);
       end //}  
       else if (ArrayOfHistoryElements[TapOfInterest].IsTapOnSecondary == 1) begin //{
          // Remove those TAP entries that are on Primary
          WorkingQueue.delete();
          AllTapsOnPrimary.delete();
          AllTapsOnPrimary = GetAllTapsOnPrimary();
          WorkingQueue = DeleteTapsFromTapsQueue(InputQueueLocal, AllTapsOnPrimary);
          InputQueueLocal.delete();
          InputQueueLocal = WorkingQueue;

          // Remove those TAP entries that are all Tertiary
          WorkingQueue.delete();
          AllTapsOnAllTertiaries.delete();
          AllTapsOnAllTertiaries = GetAllTapsOnAllTertiaries();
          WorkingQueue = DeleteTapsFromTapsQueue(InputQueueLocal, AllTapsOnAllTertiaries);
          InputQueueLocal.delete();
          InputQueueLocal = WorkingQueue;

          `dbg_display("IsTapOnSecondary: InputQueueLocal = ", InputQueueLocal);
       end //}
       else if (ArrayOfHistoryElements[TapOfInterest].IsTapOnTertiaryForAllPorts == 1) begin //{
          // Remove those TAP entries that are on Primary
          WorkingQueue.delete();
          AllTapsOnPrimary.delete();
          AllTapsOnPrimary = GetAllTapsOnPrimary();
          WorkingQueue = DeleteTapsFromTapsQueue(InputQueueLocal, AllTapsOnPrimary);
          InputQueueLocal.delete();
          InputQueueLocal = WorkingQueue;

          // Remove those TAP entries that are on Secondary
          WorkingQueue.delete();
          AllTapsOnSecondary.delete();
          AllTapsOnSecondary = GetAllTapsOnSecondary();
          WorkingQueue = DeleteTapsFromTapsQueue(InputQueueLocal, AllTapsOnSecondary);
          InputQueueLocal.delete();
          InputQueueLocal = WorkingQueue;

          // Remove those TAP entries that are on other Tertiray
          WorkingQueue.delete();
          AllTapsOnOtherTertiaries.delete();
          AllTapsOnOtherTertiaries = GetAllTapsOnOtherTertiaries(TapOfInterest);
          WorkingQueue = DeleteTapsFromTapsQueue(InputQueueLocal, AllTapsOnOtherTertiaries);
          InputQueueLocal.delete();
          InputQueueLocal = WorkingQueue;

          `dbg_display("IsTapOnTertiaryForAllPorts: InputQueueLocal = ", InputQueueLocal);
       end //}
       `dbg_display("DeleteTapsOnOtherModes return: InputQueueLocal = ", InputQueueLocal);
       return (InputQueueLocal);
    end
    endfunction : DeleteTapsOnOtherModes


    function TypeQueueOfTap_t DeleteTapsFromTapsQueue(
       input Tap_t AllTapsEnabledQueue[$],
       input Tap_t AllTapsDisabledQueue[$]);
    begin
       int   TapDisabledFlagLocal = 0;
       Tap_t LocalQueue4TempLocal[$];
       for (int j=0; j<AllTapsEnabledQueue.size(); j++) begin
          TapDisabledFlagLocal = 0;
          for (int k=0; k<AllTapsDisabledQueue.size(); k++) begin
             if (AllTapsEnabledQueue[j] == AllTapsDisabledQueue[k]) begin
                TapDisabledFlagLocal = 1;
             end
          end
          if (TapDisabledFlagLocal == 0) begin
             LocalQueue4TempLocal.push_back(AllTapsEnabledQueue[j]);
          end
       end
       return (LocalQueue4TempLocal);
    end
    endfunction : DeleteTapsFromTapsQueue


    function TypeQueueOfTap_t GetAllDisabledTaps();
    begin
       int   k;
       Tap_t AllTapsDisabledQueueLocal[$];
       AllTapsDisabledQueueLocal.delete();
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          if (ArrayOfHistoryElements[i].IsTapDisabled == 1) begin
             AllTapsDisabledQueueLocal.push_front(Tap_t'(i));
             k++;
          end  
       end
       for (int i=0; i<AllTapsDisabledQueueLocal.size(); i++) begin
          `dbg_display("3 AllTapsDisabledQueueLocal[%0d]", i, AllTapsDisabledQueueLocal[i]);
       end
       `dbg_display("AllTapsDisabledQueueLocal = ", AllTapsDisabledQueueLocal);
       return (AllTapsDisabledQueueLocal);
    end
    endfunction : GetAllDisabledTaps

    function TypeQueueOfTap_t GetAllTapsOnAllTertiaries();
    begin
       Tap_t AllTapsOnAllTertiariesQueue[$];
       AllTapsOnAllTertiariesQueue.delete();
`ifndef JTAGBFM_EN_DFTB_HTAP
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          if (ArrayOfHistoryElements[i].IsTapOnTertiaryForAllPorts == 1) begin
             AllTapsOnAllTertiariesQueue.push_front(Tap_t'(i));
          end  
       end
       for (int i=0; i<AllTapsOnAllTertiariesQueue.size(); i++) begin
          `dbg_display("3 AllTapsOnAllTertiariesQueue[%0d]", i, AllTapsOnAllTertiariesQueue[i]);
       end
       `dbg_display("AllTapsOnAllTertiariesQueue = ", AllTapsOnAllTertiariesQueue);
`endif
       return (AllTapsOnAllTertiariesQueue);
    end
    endfunction : GetAllTapsOnAllTertiaries

    function TypeQueueOfTap_t GetAllTapsOnOtherTertiaries(input Tap_t TapOfInterest);
    begin
       Tap_t AllTapsOnOtherTertiariesQueue[$];
       Tap_t TerParent;
       int index_into_terport;

`ifndef JTAGBFM_EN_DFTB_HTAP
       AllTapsOnOtherTertiariesQueue.delete();

       TerParent = GetTertiaryParentTap(TapOfInterest);
       `dbg_display("TerParent = %0s", TerParent);
       for (int i=0; i<NUMBER_OF_TERTIARY_PORTS; i++) begin //{
          if (TerParent == Tap_t'(TertiaryPortNumbering[i])) begin
             index_into_terport = i;
          end
       end
       `dbg_display("index_into_terport = ", index_into_terport);

       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          for (int j=0; j<NUMBER_OF_TERTIARY_PORTS; j++) begin //{
             if (j != index_into_terport) begin
                if (ArrayOfHistoryElements[i].IsTapOnTertiary[j] == 1) begin
                   AllTapsOnOtherTertiariesQueue.push_front(Tap_t'(i));
                end
             end
          end 
       end
       `dbg_display("AllTapsOnOtherTertiariesQueue = ", AllTapsOnOtherTertiariesQueue);

       for (int i=0; i<AllTapsOnOtherTertiariesQueue.size(); i++) begin
          `dbg_display("3 AllTapsOnOtherTertiariesQueue[%0d]", i, AllTapsOnOtherTertiariesQueue[i]);
       end
       `dbg_display("AllTapsOnOtherTertiariesQueue = ", AllTapsOnOtherTertiariesQueue);
`endif
       return (AllTapsOnOtherTertiariesQueue);
    end
    endfunction : GetAllTapsOnOtherTertiaries


    function TypeQueueOfTap_t GetAllTapsOnSecondary();
    begin
       Tap_t AllTapsOnSecondaryQueue[$];
       AllTapsOnSecondaryQueue.delete();
    `ifndef JTAGBFM_EN_DFTB_HTAP
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          if (ArrayOfHistoryElements[i].IsTapOnSecondary == 1) begin
             AllTapsOnSecondaryQueue.push_front(Tap_t'(i));
          end  
       end
       for (int i=0; i<AllTapsOnSecondaryQueue.size(); i++) begin
          `dbg_display("3 AllTapsOnSecondaryQueue[%0d]", i, AllTapsOnSecondaryQueue[i]);
       end
       `dbg_display("AllTapsOnSecondaryQueue = ", AllTapsOnSecondaryQueue);
     `endif
       return (AllTapsOnSecondaryQueue);
    end
    endfunction : GetAllTapsOnSecondary

    function TypeQueueOfTap_t GetAllTapsOnRemove();
    begin
       Tap_t AllTapsOnRemoveQueue[$];
       AllTapsOnRemoveQueue.delete();
`ifndef JTAGBFM_EN_DFTB_HTAP
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          if (ArrayOfHistoryElements[i].IsTapOnRemove == 1) begin
             AllTapsOnRemoveQueue.push_front(Tap_t'(i));
          end  
       end
       for (int i=0; i<AllTapsOnRemoveQueue.size(); i++) begin
          `dbg_display("3 AllTapsOnRemoveQueue[%0d]", i, AllTapsOnRemoveQueue[i]);
       end
       `dbg_display("AllTapsOnRemoveQueue = ", AllTapsOnRemoveQueue);
`endif
       return (AllTapsOnRemoveQueue);
    end
    endfunction : GetAllTapsOnRemove

    function TypeQueueOfTap_t GetAllTapsOnPrimary();
    begin
       Tap_t AllTapsOnPrimaryQueue[$];
       AllTapsOnPrimaryQueue.delete();
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          if (ArrayOfHistoryElements[i].IsTapOnPrimary == 1) begin
             AllTapsOnPrimaryQueue.push_front(Tap_t'(i));
          end  
       end
       for (int i=0; i<AllTapsOnPrimaryQueue.size(); i++) begin
          `dbg_display("AllTapsOnPrimaryQueue[%0d]", i, AllTapsOnPrimaryQueue[i]);
       end
       `dbg_display("AllTapsOnPrimaryQueue = ", AllTapsOnPrimaryQueue);
       return (AllTapsOnPrimaryQueue);
    end
    endfunction : GetAllTapsOnPrimary

//======================================================
    function TypeQueueOfTap_t SortQueueBasedOnAfterTapOfInterest(
       input Tap_t QueueToBeSorted [$]);
    begin

       Tap_t QueueToBeSortedLocal[$];
       Tap_t LocalQueueTemp[$];
       Tap_t x, y;
       Tap_t SortTapsTempHolderLocal;

       //Sort
       for (int j=0; j<QueueToBeSorted.size(); j++) begin
          `dbg_display("Before sort QueueToBeSorted [%0d] = %0d", j, QueueToBeSorted[j]);
       end

       QueueToBeSortedLocal.delete();
       QueueToBeSortedLocal = QueueToBeSorted;

       for (int i=0; i<QueueToBeSorted.size(); i++) begin
          for (int j=0; j<QueueToBeSorted.size(); j++) begin
             x = QueueToBeSortedLocal[i];
             y = QueueToBeSortedLocal[j];
             if (ArrayOfHistoryElements[x].TapAfterTapOfInterestArray[y] == 1) begin
                SortTapsTempHolderLocal = QueueToBeSortedLocal[j];
                QueueToBeSortedLocal[j] = QueueToBeSortedLocal[i];
                QueueToBeSortedLocal[i] = SortTapsTempHolderLocal;
             end  
          end
       end

       for (int j=0; j<QueueToBeSorted.size(); j++) begin
          `dbg_display("After sort QueueToBeSorted QueueToBeSortedLocal [%0d] = %0d", j, QueueToBeSortedLocal[j]);
       end

       LocalQueueTemp.delete();
       for (int j=0; j<QueueToBeSorted.size(); j++) begin
          LocalQueueTemp.push_back(QueueToBeSortedLocal[j]);
       end

       QueueToBeSorted.delete();
       QueueToBeSorted = LocalQueueTemp;
       LocalQueueTemp.delete();

       for (int j=0; j<QueueToBeSorted.size(); j++) begin
          `dbg_display("After GetAllEnabledTaps Sorted QueueToBeSorted [%0d] = %0d", j, QueueToBeSorted[j]);
       end

       return (QueueToBeSorted);
    end
    endfunction : SortQueueBasedOnAfterTapOfInterest


    //=============
    //Update child information of each tap till last leaf
    //This information helps to disable all child Taps when parent Tap is disabled
    //Example: In test hierarchy following array with value idicates it is child of given tap.
    //-------------
    //ArrayOfHistoryElements[ 5].ChildTapsArray:
    //31'{0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} 
    //Tap of interest; 5
    //Child taps: 6 and 7
    //-------------
    //ArrayOfHistoryElements[9].ChildTapsArray:
    //31'{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} 
    //Tap of interest; 9
    //Child taps: 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 and 20
    //=============
    function void UpdateChildTapArrayTable ();
    begin
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          PathTillCltapQueue.delete();
          if (i != 0) begin
             GetPathTillCltap (Tap_t'(i));
          
             for (int j=0; j<PathTillCltapQueue.size(); j++) begin
                `dbg_display("1. UpdateChildTapArrayTable PathTillCltapQueue[%0d] = %0d", j, PathTillCltapQueue[j]);
             end  

             for (int j=0; j<PathTillCltapQueue.size(); j++) begin
                `dbg_display("2. UpdateChildTapArrayTable PathTillCltapQueue[%0d] = %0d", j, PathTillCltapQueue[j]);
             end  

             for (int j=0; j<PathTillCltapQueue.size(); j++) begin
                ArrayOfHistoryElements[PathTillCltapQueue[j]].ChildTapsArray[Tap_t'(i)] = 1;
             end
          end
       end
    end
    endfunction: UpdateChildTapArrayTable

    task AddTapOfInterestToPathTillCltapQueue (input Tap_t TapOfInterest = Tap_t'(0));
    begin
       PathWithTapOfInterestQueue.delete();
       PathWithTapOfInterestQueue = PathTillCltapQueue;
       PathWithTapOfInterestQueue.push_back(TapOfInterest);
       `dbg_display("AddTapOfInterestToPathTillCltapQueue = %0d", TapOfInterest);
       for (int i=0; i<PathWithTapOfInterestQueue.size(); i++) begin
          `dbg_display("PathWithTapOfInterestQueue[%0d] = %0d", i, PathWithTapOfInterestQueue[i]);
       end  
    end
    endtask : AddTapOfInterestToPathTillCltapQueue

    task DeleteCltapFromPathWithTapOfInterest();
    begin
       int index;

       PathWithoutCltapQueue.delete(); 
       PathWithoutCltapQueue = PathWithTapOfInterestQueue;

       for (int i=0; i<PathWithoutCltapQueue.size(); i++) begin
          if (PathWithoutCltapQueue[i] == Tap_t'(0)) begin
             index = i;
          end  
       end  

       PathWithoutCltapQueue.delete(index);
       `dbg_display("PathWithoutCltapQueue.size() = %0d", PathWithoutCltapQueue.size());
       for (int i=0; i<PathWithoutCltapQueue.size(); i++) begin
          `dbg_display("PathWithoutCltapQueue [%0d] = %0d", i, PathWithoutCltapQueue[i]);
       end  

    end
    endtask : DeleteCltapFromPathWithTapOfInterest

    //Function is to convert Queues to Arrays.
    //This is required as we need to pass only arrays to Tap access command.
    function bit [WIDTH_OF_EACH_REGISTER-1:0] ConvertQueuesToArrays1(bit InputQueue[$]);
    begin
       bit [WIDTH_OF_EACH_REGISTER-1:0] ConvertedArray;
       ConvertedArray = 0;
       for (int i=0; i<InputQueue.size(); i++) begin
          ConvertedArray[i] = InputQueue[i];
       end
       `dbg_display("ConvertedArray = %0h", ConvertedArray);
       return ConvertedArray;
    end
    endfunction: ConvertQueuesToArrays1

    //Task is used to enable Tap of interest
    task EnableTapInternal (input Tap_t TapOfInterest = Tap_t'(0));
    begin
`ifndef JTAGBFM_EN_DFTB_HTAP    
       int TapMode = 1;
       //Tap is enabled by writing 01 to TapSelect register
`else
       int TapMode = 0;
      //Tap is enabled by writing 00 to TapSelect register
`endif

       //Opcode of TapcSelect register is 'h11
       PrepareIrDrChainAndChangeMode (TapOfInterest, TapMode);
    end
    endtask : EnableTapInternal


    //Task is used to disable Tap of interest
    task DisableTapInternal (input Tap_t TapOfInterest = Tap_t'(0));
    begin
`ifndef JTAGBFM_EN_DFTB_HTAP 
       int TapMode = 0;
       //Tap is disabled by writing 00 to TapSelect register
`else
       int TapMode = 2;
       //Tap is disabled by writing 10 to TapSelect register 
`endif
       //Opcode of TapcSelect register is 'h11
       PrepareIrDrChainAndChangeMode (TapOfInterest, TapMode);
    end
    endtask : DisableTapInternal


    //Task is used to disable Tap of interest
    task ShadowTapInternal (input Tap_t TapOfInterest = Tap_t'(0));
    begin
       int TapMode = 3;

`ifndef JTAGBFM_EN_DFTB_HTAP
       //Tap is disabled by writing 00 to TapSelect register
`else
       //Tap is disabled by writing 11 to TapSelect register 
`endif
       //Opcode of TapcSelect register is 'h11
       `uvm_info("",$psprintf("To enable any number of sTAPs in shadow mode it is important to place N-1 TAPs in shadow mode nearest to the network master sTAP. Then the last sTAP in the serial chain is configured to be Normal."),UVM_NONE);

       PrepareIrDrChainAndChangeMode (TapOfInterest, TapMode);

    end
    endtask : ShadowTapInternal

    //-------------------------------------------------------------------------
    // Landmark Day 10-Oct-2012.
    //-------------------------------------------------------------------------
    // This is heart of the Jtag BFM to use network aware capability.
    //-------------------------------------------------------------------------
    task PrepareIrDrChainAndChangeMode (input Tap_t TapOfInterest = Tap_t'(0),
                                    input int   TapMode = 0);
    begin //{
       Tap_t                              LocalQueue4[$];
       Tap_t                              LocalQueue5[$];
       bit                                LocalQueue6[$];
       bit                                LocalQueue6_Shadow_En[$];
       bit                                LocalQueue7[$];
       bit                                LocalQueue7_Shadow_En[$];
       Tap_t                              LocalArray4[$];
       Tap_t                              LocalQueue4Temp[$];
       Tap_t                              TapOfInterestInternal;
       Tap_t                              TapOfReference;
       int                                IrWidth;
       int                                IrWidthFinal;
       int                                DrWidthFinal;
       int                                IrWidthFinal_Shadow_En;
       int                                DrWidthFinal_Shadow_En;
       int                                index;
       int                                PostionOfTap;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] DrChainValue;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] DrChainValue_0;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] DrChainValue_1;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] DrChainValue1;
       bit   [API_SIZE_OF_IR_REG-1:0]     IrChainValue1;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] DrChainValue1_Shadow_En;
       bit   [API_SIZE_OF_IR_REG-1:0]     IrChainValue1_Shadow_En;
       logic [API_SIZE_OF_IR_REG-1:0]     Opcode = 'h11;
       logic [API_SIZE_OF_IR_REG-1:0]     Opcode_Shadow_En = 'h12;
       bit   [API_SIZE_OF_IR_REG-1:0]     IrChainValueLocal;
       bit                                EndebugDisableChildStapForCltap;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] TDOData;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] TDODataChopped;


`ifndef JTAG_BFM_TAPLINK_MODE
       
       //PathTillCltapQueue is filled with path till CLTAP
       GetPathTillCltap (TapOfInterest); 

       //Prepare queue along with tap of interest
       AddTapOfInterestToPathTillCltapQueue(TapOfInterest);

       //Sort and make it uniq
       MakePathWithTapOfInterestQueueUniq();

       //Make queue excluding CLTAP
       DeleteCltapFromPathWithTapOfInterest();

       //Getting IR Width for CLTAP
       CLTAP_Ir_Width = Get_IR_Width(Tap_t'(0));
       EndebugDisableChildStapForCltap = 1'b0;

       //Enable each Tap in the path till Tap of interest 
       //Loop from first parent till TapOfInterest
       for (int i=0; i<PathWithoutCltapQueue.size(); i++) begin
          `dbg_display("Loop1 i = %0d", i);
          `dbg_display("ArrayOfHistoryElements[TapOfInterest].IsTapEnabled = %0d, TapMode = %0d", 
             ArrayOfHistoryElements[TapOfInterest].IsTapEnabled, TapMode);
          `dbg_display("ArrayOfHistoryElements[TapOfInterest].IsTapDisabled = %0d, TapMode = %0d", 
             ArrayOfHistoryElements[TapOfInterest].IsTapDisabled, TapMode);
          //Check whether Tap of interest is already enabled.
          //If not proceed to enable
`ifndef JTAGBFM_EN_DFTB_HTAP 
          if (((ArrayOfHistoryElements[TapOfInterest].IsTapEnabled  != 1) && (TapMode == 1)) || 
              ((ArrayOfHistoryElements[TapOfInterest].IsTapDisabled != 1) && (TapMode == 0)) ||
`else
          if (((ArrayOfHistoryElements[TapOfInterest].IsTapEnabled  != 1) && (TapMode == 0)) || 
              ((ArrayOfHistoryElements[TapOfInterest].IsTapDisabled != 1) && (TapMode == 2)) ||
`endif
              ((ArrayOfHistoryElements[TapOfInterest].IsTapShadowed != 1) && (TapMode == 3))) begin
             `dbg_display("Loop1 if1 i = %0d", i);
             //Get tap of interest from Queue without CLTAP
             TapOfInterestInternal = PathWithoutCltapQueue[i];
             TapOfReference        = PathWithTapOfInterestQueue[i];
             `dbg_display("TapOfReference = %0d", TapOfReference);
             `dbg_display("TapOfInterestInternal = %0d", TapOfInterestInternal);
             `dbg_display("ArrayOfHistoryElements[TapOfInterestInternal].IsTapEnabled = %0d",
                ArrayOfHistoryElements[TapOfInterestInternal].IsTapEnabled);
             //Check whether Tap of interest is already enabled.
             //If not proceed to enable
`ifndef JTAGBFM_EN_DFTB_HTAP
             if (((ArrayOfHistoryElements[TapOfInterestInternal].IsTapEnabled  != 1) && (TapMode == 1)) || 
                (((ArrayOfHistoryElements[TapOfInterestInternal].IsTapDisabled != 1) && (TapMode == 0)) && (TapOfInterestInternal == TapOfInterest)) || 
`else
             if (((ArrayOfHistoryElements[TapOfInterestInternal].IsTapEnabled  != 1) && (TapMode == 0)) || 
                (((ArrayOfHistoryElements[TapOfInterestInternal].IsTapDisabled != 1) && (TapMode == 2)) && (TapOfInterestInternal == TapOfInterest)) ||
`endif 
                (((ArrayOfHistoryElements[TapOfInterestInternal].IsTapShadowed != 1) && (TapMode == 3)) && (TapOfInterestInternal == TapOfInterest))
                ) begin

                `dbg_display("Loop1 if2 TapOfInterestInternal = %0d", TapOfInterestInternal);
                LocalQueue4.delete();
                LocalQueue5.delete();
                LocalQueue6.delete();
                LocalQueue7.delete();
`ifdef JTAGBFM_EN_DFTB_HTAP
                if( TapMode == 3) begin 
                   LocalQueue6_Shadow_En.delete();
                   LocalQueue7_Shadow_En.delete();
                end
`endif
                //MakeQueue4
                //Make queue only till tap not being enabled in the path
                for (int j=0; j<PathWithoutCltapQueue.size(); j++) begin
                   `dbg_display("Loop2  j = %0d", j);
                   `dbg_display("PathWithoutCltapQueue[%0d] = %0d", j, PathWithoutCltapQueue[j]);
                   if (PathWithTapOfInterestQueue[j] == TapOfReference) begin
                      index = j;
                      `dbg_display("Loop2 if1 j = %0d", j);
                      `dbg_display("Loop2 if1 index = %0d", index);
                   end  
                end  

                for (int j=0; j<PathWithTapOfInterestQueue.size(); j++) begin
                   if (j <= index) begin
                      LocalQueue4.push_back(PathWithTapOfInterestQueue[j]);
                   end
                end

                for (int j=0; j<LocalQueue4.size(); j++) begin
                   `dbg_display("Before GetAllEnabledTaps LocalQueue4 [%0d] = %0d", j, LocalQueue4[j]);
                end
     
                //Get all enabled Taps in given network
                AllTapsEnabledQueue.delete();
                AllTapsEnabledQueue = GetAllEnabledTaps();
                // Add all enabled taps
                for (int j=0; j<AllTapsEnabledQueue.size(); j++) begin
                   LocalQueue4.push_back(AllTapsEnabledQueue[j]);
                end  
                for (int j=0; j<LocalQueue4.size(); j++) begin
                   `dbg_display("After GetAllEnabledTaps LocalQueue4 [%0d] = %0d", j, LocalQueue4[j]);
                end
                //Uniq
                LocalQueue4Temp.delete();
                LocalQueue4Temp = LocalQueue4.unique();
                LocalQueue4.delete();
                LocalQueue4 = LocalQueue4Temp;
                for (int j=0; j<LocalQueue4.size(); j++) begin
                   `dbg_display("After GetAllEnabledTaps Uniq LocalQueue4 [%0d] = %0d", j, LocalQueue4[j]);
                end

                AllTapsDisabledQueue.delete();
                AllTapsDisabledQueue = GetAllDisabledTaps();

                LocalQueue4Temp.delete();
                // Remove those enabled TAP entries whose parents are disabled 
                LocalQueue4Temp = DeleteTapsFromTapsQueue(LocalQueue4, AllTapsDisabledQueue);
                LocalQueue4.delete();
                LocalQueue4 = LocalQueue4Temp;

                LocalQueue4Temp.delete();
                LocalQueue4Temp = DeleteTapsOnOtherModes(TapOfInterest, LocalQueue4);
                LocalQueue4.delete();
                LocalQueue4 = LocalQueue4Temp;



                LocalQueue4Temp.delete();
                AllTapsOnRemove.delete();
                AllTapsOnRemove = GetAllTapsOnRemove();
                // Remove those TAP entries that are TAPC_Removed
                LocalQueue4Temp = DeleteTapsFromTapsQueue(LocalQueue4, AllTapsOnRemove);
                LocalQueue4.delete();
                LocalQueue4 = LocalQueue4Temp;


                //Sort
                LocalArray4.delete();
                LocalArray4 = SortQueueBasedOnAfterTapOfInterest(LocalQueue4);

                LocalQueue4.delete();
                LocalQueue4 = LocalArray4;
                for (int j=0; j<LocalQueue4.size(); j++) begin
                   `dbg_display("After GetAllEnabledTaps Sorted LocalQueue4 [%0d] = %0d", j, LocalQueue4[j]);
                end

                //Reverse queue
                for (int j=0; j<LocalQueue4.size(); j++) begin
                   LocalQueue5.push_back(LocalQueue4[(LocalQueue4.size()-1)-j]);
                end  
                for (int j=0; j<LocalQueue5.size(); j++) begin
                   `dbg_display("Reverse LocalQueue5 [%0d] = %0d", j, LocalQueue5[j]);
                end
                IrWidthFinal = 0;
                DrWidthFinal = 0;
`ifdef JTAGBFM_EN_DFTB_HTAP
                if( TapMode == 3) begin 
                   IrWidthFinal_Shadow_En = 0;
                   DrWidthFinal_Shadow_En = 0;
                end
`endif
                //Concatinate bits
                `dbg_display("Concatinate ============");
                for (int j=0; j<LocalQueue5.size(); j++) begin
                   IrWidth = Get_IR_Width (LocalQueue5[j]);
                   IrWidthFinal = IrWidthFinal + IrWidth;
                   IrChainValueLocal = 0;
                   if (LocalQueue5[j] != TapOfReference) begin
                      for (int k=0; k<IrWidth; k++) begin
                         LocalQueue6.push_back(1);
`ifdef JTAGBFM_EN_DFTB_HTAP
                         if( TapMode == 3) begin 
                            LocalQueue6_Shadow_En.push_back(1);
                         end
`endif
                         IrChainValueLocal[k] = 1;
                      end 
                      DrWidthFinal = DrWidthFinal + 1;
                      LocalQueue7.push_back(0);
`ifdef JTAGBFM_EN_DFTB_HTAP
                      if( TapMode == 3) begin 
                         LocalQueue7_Shadow_En.push_back(0);
                      end
`endif
                   end  
                   else if (LocalQueue5[j] == TapOfReference) begin
                      if (LocalQueue5[j] == Tap_t'(0)) begin
                         // 24-Feb-2015 HSD https://hsdes.intel.com/home/default.html#article?id=1603913399
                         // JTAG BFM to have control over STAP ACCESS using CLTAP_SEL_OVR and TAP MODE 
                         Opcode = CltapcNetworkSelOpcodeis_h12 ? 'h12 : 'h11;
                         EndebugDisableChildStapForCltap = 0;
                      end
                      else begin
                         Opcode = 'h11;
                         EndebugDisableChildStapForCltap = 1;
                      end  
                      for (int k=0; k<IrWidth; k++) begin
                         LocalQueue6.push_back(Opcode[k]);
                         IrChainValueLocal[k] = Opcode[k];
                      end 
`ifdef JTAGBFM_EN_DFTB_HTAP
                      if( TapMode == 3) begin 
                         for (int k=0; k<IrWidth; k++) begin
                            LocalQueue6_Shadow_En.push_back(Opcode_Shadow_En[k]);
                         end 
                      end
                      DrWidthFinal_Shadow_En = DrWidthFinal + 1'b1;
`endif
                      DrWidthFinal   = DrWidthFinal + ArrayOfHistoryElements[LocalQueue5[j]].DrLengthOfTapcSelectReg;
                      PostionOfTap   = ArrayOfHistoryElements[TapOfInterestInternal].PostionOfTapInTapcSelReg;
`ifndef JTAGBFM_EN_DFTB_HTAP
                      DrChainValue_0 = 0;
                      DrChainValue_1 = 0;
                      DrChainValue   = 0;
                      DrChainValue_0 =  DrChainValue_0 | 1'b1;
                      DrChainValue_1 =  DrChainValue_1 | 1'b1;
                      DrChainValue_0 = (DrChainValue_0 <<  (2*PostionOfTap));
                      DrChainValue_1 = (DrChainValue_1 << ((2*PostionOfTap)+1));
                      DrChainValue   =  DrChainValue_0 | DrChainValue_1;
                      DrChainValue   = ~DrChainValue;

                      //Clear TapcSelect register
                      ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister = 
                         ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister & DrChainValue;
                         
                      DrChainValue = 0;
                      if (TapMode == 0) begin //{
                         DrChainValue = DrChainValue | 2'b00; //Disable
                      end //}
                      else if (TapMode == 1) begin //{
                         DrChainValue = DrChainValue | 2'b01; //Enable
                      end //}
                      else if (TapMode == 3) begin //{
                         DrChainValue = DrChainValue | 2'b11; //Enable
                      end //}

                      DrChainValue = (DrChainValue << (2*PostionOfTap));
                      `dbg_display("DrChainValue = %0h", DrChainValue);
                      `dbg_display("PostionOfTap = %0h", PostionOfTap);
                      `dbg_display("Before TapcSelectRegister = %0h", ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister);
                      ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister = 
                         ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister | DrChainValue;
`else
                      ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister[(2*PostionOfTap)] = 1'b0;
                      ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister[(2*PostionOfTap)+1] = 1'b1;
                      
                      DrChainValue = 2;
                      if (TapMode == 2) begin //{
                         DrChainValue = 2'b10; //Disable
                      end //}
                      else if (TapMode == 0) begin //{
                         DrChainValue = 2'b00; //Enable
                      end //}
                      else if (TapMode == 3) begin //{
                         DrChainValue = 2'b11; //Enable
                      end //}
                      //DrChainValue = (DrChainValue << (2*PostionOfTap));
                      `dbg_display("DrChainValue = %0h", DrChainValue);
                      `dbg_display("PostionOfTap = %0h", PostionOfTap);
                      `dbg_display("Before TapcSelectRegister = %0h", ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister);
                      //ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister = 
                       //  ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister | DrChainValue;
                      ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister[(2*PostionOfTap)] = DrChainValue[0];
                      ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister[(2*PostionOfTap)+1] = DrChainValue[1];
`endif
                      `dbg_display("After TapcSelectRegister = %0h", ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister);

                      for (int i=0; i<ArrayOfHistoryElements[LocalQueue5[j]].DrLengthOfTapcSelectReg; i++) begin //{
                         LocalQueue7.push_back(ArrayOfHistoryElements[LocalQueue5[j]].TapcSelectRegister[i]);
                      end  //} 
`ifdef JTAGBFM_EN_DFTB_HTAP
                      LocalQueue7_Shadow_En.push_back(1'b1);
`endif
                   end  
                   ArrayOfHistoryElements[LocalQueue5[j]].PreviousAccessedIr = IrChainValueLocal;
                   ArrayOfHistoryElements[LocalQueue5[j]].CurrentlyAccessedIr = IrChainValueLocal;
                   //`dbg_display("TRAKER_DEBUG Opcode = %0h", Opcode);
                   `dbg_display("TRAKER_DEBUG IrChainValueLocal = %0h from task PrepareIrDrChainAndChangeMode", IrChainValueLocal);
                end  
                for (int j=0; j<LocalQueue6.size(); j++) begin
                   `dbg_display("Reverse LocalQueue6 [%0d] = %0d", j, LocalQueue6[j]);
                end
                `dbg_display("IrWidthFinal = %0d", IrWidthFinal);
                `dbg_display("DrWidthFinal = %0d", DrWidthFinal);
                for (int j=0; j<LocalQueue7.size(); j++) begin
                   `dbg_display("LocalQueue7 [%0d] = %0d", j, LocalQueue7[j]);
                end
                IrChainValue1 = ConvertQueuesToArrays1 (LocalQueue6);
`ifdef JTAGBFM_EN_DFTB_HTAP
                IrChainValue1_Shadow_En = ConvertQueuesToArrays1 (LocalQueue6_Shadow_En);
`endif
                `dbg_display("IrChainValue1 = %0h", IrChainValue1);
                DrChainValue1 = ConvertQueuesToArrays1 (LocalQueue7);
`ifdef JTAGBFM_EN_DFTB_HTAP
                DrChainValue1_Shadow_En = ConvertQueuesToArrays1 (LocalQueue7_Shadow_En);
`endif
                `dbg_display("DrChainValue1 = %0h", DrChainValue1);

                // Moved it to above updating history table to align with display in Tracker to be printed before accessing an IR.
                if((ENDEBUG_OWN === 1'b0) || (FuseDisable == 1'b1) || (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b1)) begin
`ifdef JTAGBFM_EN_DFTB_HTAP
                   if(TapMode == 3) begin
                      IrWidthFinal_Shadow_En = IrWidthFinal;
                      MultipleTapRegisterAccess(
                         NO_RST,                //NO_RST
                         IrChainValue1_Shadow_En,         //OPCODE
                         DrChainValue1_Shadow_En,         //DATA
                         IrWidthFinal_Shadow_En,          //ADDRESS LENGTH
                         DrWidthFinal_Shadow_En);  

                   end
`endif
                   MultipleTapRegisterAccess(
                      NO_RST,                //NO_RST
                      IrChainValue1,         //OPCODE
                      DrChainValue1,         //DATA
                      IrWidthFinal,          //ADDRESS LENGTH
                      DrWidthFinal);         //DATA LENGTH
                      if((ENDEBUG_OWN === 1'b1) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b1) && (EndebugDisableChildStapForCltap  === 1'b0)) begin
                         ENDEBUG_ENCRYPTION_CFG.CLEAR_LATCHED_NETWORK = 1'b1;
                         ENDEBUG_ENCRYPTION_CFG.TAP_RESET = 1'b0;
                         ENDEBUG_ENCRYPTION_CFG.START_DEBUG_SESSION = 2'b00;
                         MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h1, ENDEBUG_ENCRYPTION_CFG, CLTAP_Ir_Width, ENDEBUG_CFG_REG_LENGTH);
                         Goto(RUTI,10);
                         ENDEBUG_ENCRYPTION_CFG.CLEAR_LATCHED_NETWORK = 1'b0;
                         MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h1, ENDEBUG_ENCRYPTION_CFG, CLTAP_Ir_Width, ENDEBUG_CFG_REG_LENGTH);
                         Goto(RUTI,10);
                      end
                end
                else
                begin//{
                   if(EndebugDisableChildStapForCltap  === 1'b0) begin
                      MultipleTapRegisterAccess(
                         NO_RST,                //NO_RST
                         IrChainValue1,         //OPCODE
                         DrChainValue1,         //DATA
                         IrWidthFinal,          //ADDRESS LENGTH
                         DrWidthFinal);         //DATA LENGTH
                      ENDEBUG_ENCRYPTION_CFG.CLEAR_LATCHED_NETWORK = 1'b1;
                      ENDEBUG_ENCRYPTION_CFG.START_DEBUG_SESSION = 2'b00;
                      ENDEBUG_ENCRYPTION_CFG.TAP_RESET = 1'b0;
                      MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h1, ENDEBUG_ENCRYPTION_CFG, CLTAP_Ir_Width, ENDEBUG_CFG_REG_LENGTH);
                      ENDEBUG_ENCRYPTION_CFG.CLEAR_LATCHED_NETWORK = 1'b0;
                      MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h1, ENDEBUG_ENCRYPTION_CFG, CLTAP_Ir_Width, ENDEBUG_CFG_REG_LENGTH);
                      if(IrWidthFinal > CLTAP_Ir_Width) begin
                         Endebug_Tap_Access(
                              IrWidthFinal,
                              (DrWidthFinal-ArrayOfHistoryElements[Tap_t'(0)].DrLengthOfTapcSelectReg)+1,
                              IrChainValue1,
                              DrChainValue1,
                              'h0,
                              'h0, 
                              'h0,
                              'h0,
                              'h0,
                              TapOfInterestInternal,
                              CLTAP_Ir_Width,
                              1'b1,
                              TDOData,
                              TDODataChopped
                         );                          
                      end
                   end
                   else begin
                      Endebug_Tap_Access(
                           IrWidthFinal,
                           DrWidthFinal,
                           IrChainValue1,
                           DrChainValue1,
                           'h0,
                           'h0, 
                           'h0,
                           'h0,
                           'h0,
                           TapOfInterestInternal,
                           CLTAP_Ir_Width,
                           1'b1,
                           TDOData,
                           TDODataChopped
                      );
                   end
                end//}

                //Update history element with information Tap being enabled. 
`ifndef JTAGBFM_EN_DFTB_HTAP
                if (TapMode == 1) begin //{
`else
                if (TapMode == 0) begin //{
`endif
                   `dbg_display("TapMode1 Entered");
                   ArrayOfHistoryElements[TapOfInterestInternal].IsTapEnabled       = 1;
                   ArrayOfHistoryElements[TapOfInterestInternal].IsTapDisabled      = 0;
                   ArrayOfHistoryElements[TapOfInterestInternal].TapDisabledByReset = 0;
                   ArrayOfHistoryElements[TapOfInterestInternal].TapSelfDisable     = 0;
                   //Change status of "IsTapDisabled" to 0 only if Tap is disable due to reset or
                   //disabled by writing to Tapc select reigster of the parent. And Tap should not 
                   //have been disabled by parent to change its status to enabled.
                   for (int i=0; i<NUMBER_OF_TAPS; i++) begin //{
                      if (ArrayOfHistoryElements[TapOfInterestInternal].ChildTapsArray[Tap_t'(i)] == 1) begin //{
                         if (ArrayOfHistoryElements[Tap_t'(i)].TapDisabledByParent == 1) begin //{
                            if (ArrayOfHistoryElements[Tap_t'(i)].PreviousStateOfIsTapDisabled == 0) begin //{
                               ArrayOfHistoryElements[Tap_t'(i)].IsTapDisabled = 0;
                            end //}
                            else if (ArrayOfHistoryElements[Tap_t'(i)].PreviousStateOfIsTapDisabled == 1) begin //{
                               ArrayOfHistoryElements[Tap_t'(i)].IsTapDisabled = 1;
                            end //}
                            ArrayOfHistoryElements[Tap_t'(i)].TapDisabledByParent = 0;
                         end //}
                         `dbg_display("ArrayOfHistoryElements[%0d].IsTapDisabled = %0d", 
                            i, ArrayOfHistoryElements[Tap_t'(i)].IsTapDisabled);
                         `dbg_display("ArrayOfHistoryElements[%0d].TapDisabledByParent = %0d", 
                            i, ArrayOfHistoryElements[Tap_t'(i)].TapDisabledByParent);
                      end //}  
                   end //}
                end //}
`ifndef JTAGBFM_EN_DFTB_HTAP
                else if (TapMode == 0) begin //{
`else
                else if (TapMode == 2) begin //{
`endif
                   `dbg_display("TapMode0 Entered");
                   ArrayOfHistoryElements[TapOfInterest].IsTapEnabled   = 0;
                   ArrayOfHistoryElements[TapOfInterest].IsTapDisabled  = 1;
                   ArrayOfHistoryElements[TapOfInterest].TapSelfDisable = 1;
                   for (int i=0; i<NUMBER_OF_TAPS; i++) begin //{
                      // HSD_5076042 - EnableTap() and DisableTap() APIs will cause test simulation to hang if used to disable and then enable the same TAP again
                      // ArrayOfHistoryElements[Tap_t'(i)].PreviousStateOfIsTapDisabled = 0;
                      // If Parent is disabled, then all its children are disabled
                      if (ArrayOfHistoryElements[TapOfInterest].ChildTapsArray[Tap_t'(i)] == 1) begin //{
                         if (ArrayOfHistoryElements[Tap_t'(i)].IsTapDisabled != 1) begin //{
                            ArrayOfHistoryElements[Tap_t'(i)].IsTapDisabled = 1;
                            ArrayOfHistoryElements[Tap_t'(i)].PreviousStateOfIsTapDisabled = 0;
                         end //}  
                         else if (ArrayOfHistoryElements[Tap_t'(i)].IsTapDisabled == 1) begin //{
                            ArrayOfHistoryElements[Tap_t'(i)].PreviousStateOfIsTapDisabled = 1;
                         end //}  

                         if ((ENDEBUG_OWN == 1'b0) || (FuseDisable == 1'b1)) begin
                             ArrayOfHistoryElements[Tap_t'(i)].TapDisabledByParent = 1;
                         end
                         `dbg_display("ArrayOfHistoryElements[%0d].IsTapDisabled = %0d", 
                            i, ArrayOfHistoryElements[Tap_t'(i)].IsTapDisabled);
                         `dbg_display("ArrayOfHistoryElements[%0d].TapDisabledByParent = %0d", 
                            i, ArrayOfHistoryElements[Tap_t'(i)].TapDisabledByParent);
                      end //}  
                   end //}
                end //}
                else if (TapMode == 3) begin //{
                   `dbg_display("TapMode3 Entered");
                   ArrayOfHistoryElements[TapOfInterest].IsTapEnabled  = 0;
                   ArrayOfHistoryElements[TapOfInterest].IsTapDisabled = 0;
                   ArrayOfHistoryElements[TapOfInterest].IsTapShadowed = 1;
                   for (int i=0; i<NUMBER_OF_TAPS; i++) begin //{
                      if (ArrayOfHistoryElements[TapOfInterest].ChildTapsArray[Tap_t'(i)] == 1) begin //{
                         if (ArrayOfHistoryElements[Tap_t'(i)].IsTapShadowed != 1) begin //{
                            ArrayOfHistoryElements[Tap_t'(i)].IsTapShadowed = 1;
                         end //}  

                         ArrayOfHistoryElements[Tap_t'(i)].TapShadowedByParent = 1;
                         `dbg_display("ArrayOfHistoryElements[%0d].IsTapShadowed = %0d", 
                            i, ArrayOfHistoryElements[Tap_t'(i)].IsTapShadowed);
                         `dbg_display("ArrayOfHistoryElements[%0d].TapShadowedByParent = %0d", 
                            i, ArrayOfHistoryElements[Tap_t'(i)].TapShadowedByParent);
                      end //}  
                   end //}
                end //}




                for (int i=0; i<NUMBER_OF_TAPS; i++) begin
                   `dbg_display("MultipleTapRegisterAccess ArrayOfHistoryElements[%0d].PreviousAccessedIr = %0h",
                      i, ArrayOfHistoryElements[i].PreviousAccessedIr);
                end   
             end
          end 
       end
`endif

`ifdef JTAG_BFM_TAPLINK_MODE
`ifndef JTAGBFM_EN_DFTB_HTAP
       	if ((ArrayOfHistoryElements[TapOfInterest].IsTapEnabled  != 1) && (TapMode == 1)) begin
`else
       	if ((ArrayOfHistoryElements[TapOfInterest].IsTapEnabled  != 1) && (TapMode == 0)) begin
`endif
           ArrayOfHistoryElements[TapOfInterest].IsTapEnabled   = 1;
           ArrayOfHistoryElements[TapOfInterest].IsTapDisabled  = 0;
       	end
`ifndef JTAGBFM_EN_DFTB_HTAP
       	else if ((ArrayOfHistoryElements[TapOfInterest].IsTapDisabled != 1) && (TapMode == 0)) begin
`else
       	else if ((ArrayOfHistoryElements[TapOfInterest].IsTapDisabled != 1) && (TapMode == 2)) begin
`endif
           ArrayOfHistoryElements[TapOfInterest].IsTapEnabled   = 0;
           ArrayOfHistoryElements[TapOfInterest].IsTapDisabled  = 1;
	end 
	else if ((ArrayOfHistoryElements[TapOfInterest].IsTapShadowed != 1) && (TapMode == 3)) begin
	   `uvm_fatal(get_name(),"JTAG BFM does not support TAP shadowing in TapLink mode")
	end

       `dbg_display("ArrayOfHistoryElements[%0d].IsTapEnabled = %0d", 
          TapOfInterest, ArrayOfHistoryElements[TapOfInterest].IsTapEnabled);
       `dbg_display("ArrayOfHistoryElements[%0d].IsTapDisabled = %0d", 
          TapOfInterest, ArrayOfHistoryElements[TapOfInterest].IsTapDisabled);
`endif

    end //}
    endtask : PrepareIrDrChainAndChangeMode

    task MakePathWithTapOfInterestQueueUniq();
    begin
       Tap_t PathWithTapOfInterestQueueUniq[$];
       Tap_t Queue4Temp[$];

       PathWithTapOfInterestQueueUniq.delete();
       PathWithTapOfInterestQueueUniq = PathWithTapOfInterestQueue.unique();
       Queue4Temp.delete();
       Queue4Temp = SortQueueBasedOnAfterTapOfInterest(PathWithTapOfInterestQueueUniq);

       PathWithTapOfInterestQueueUniq.delete();
       PathWithTapOfInterestQueueUniq = Queue4Temp;
       Queue4Temp.delete();

       for (int j=0; j<PathWithTapOfInterestQueueUniq.size(); j++) begin
          `dbg_display("After Queue4Temp Sorted PathWithTapOfInterestQueueUniq [%0d] = %0d", j, PathWithTapOfInterestQueueUniq[j]);
       end

       PathWithTapOfInterestQueue.delete();
       PathWithTapOfInterestQueue = PathWithTapOfInterestQueueUniq;

       for (int i=0; i<PathWithTapOfInterestQueueUniq.size(); i++) begin
          `dbg_display("MakePathWithTapOfInterestQueueUniq PathWithTapOfInterestQueueUniq [%0d] = %0d", i, PathWithTapOfInterestQueueUniq[i]);
       end

       for (int i=0; i<PathWithTapOfInterestQueue.size(); i++) begin
          `dbg_display("MakePathWithTapOfInterestQueueUniq PathWithTapOfInterestQueue [%0d] = %0d", i, PathWithTapOfInterestQueue[i]);
       end

    end
    endtask : MakePathWithTapOfInterestQueueUniq

    task TapAccess(
       input Tap_t                        Tap = Tap_t'(0),
       input [API_SIZE_OF_IR_REG-1:0]     Opcode = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
       input int                          ShiftLength = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
       input bit                          EnUserDefinedShiftLength = 0,
       input bit                          EnRegisterPresenceCheck = 1,
       output bit [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo);
    begin
       bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] cmp_mask_chopped = 0;

	for (int ii=0; ii < ShiftLength; ii++)
	   cmp_mask_chopped[ii] = CompareMask[ii];

       `uvm_info (get_type_name(), $psprintf("JTAGBFM: Starting access for TAP %s, Opcode 'h0%0h, Inp Data %0d'h0%0h, Exp Data 'h0%0h, Exp Mask 'h0%0h",
       Tap.name(), Opcode, ShiftLength, ShiftIn, ExpectedData, cmp_mask_chopped), UVM_NONE);

       //Task check for availability of Tap in the network
       GetTapAvailableStatus (Tap);

       //If Tap of interest exists in a given network then
       //proceed with enable and access operation.
       if (TapExistFlag == 1) begin

          //Enable Tap of interest before accessing any opcode.
          EnableTap (Tap);

          AccessTargetReg(
             .TapOfInterest (Tap),
             .Opcode        (Opcode),
             .InputDrWidth  (ShiftLength),
             .InputDrData   (ShiftIn),
             .ExpectedData  (ExpectedData),
             .Mask          (CompareMask),
             .EnRegisterPresenceCheck (EnRegisterPresenceCheck),
             .EnUserDefinedDRLength (EnUserDefinedShiftLength),
             .TDOData(tdo_data),
             .TDODataChopped (ReturnTdo));

          //if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap !== Tap_t'(0))) begin
          //  HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
          //  for (int k=HierarchyLevel_Internal; k>0;k--) begin
          //     for (int p=0; p<NUMBER_OF_TAPS; p++) begin
          //        if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
          //           if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	  //                   DisableTap(Tap_t'(p));
          //           end
          //        end
          //     end
          //  end
          //end
       end

       `dbg_display("TapAccess Calling RUTI...");
       Goto(RUTI,1);
    end
    endtask : TapAccess

    //This task used to do ARC TAP trasnactions through ENDEBUG.
    //This task similar to TapAccess. But there are two differences.
    //1) Programming of ENDEBUG_CFG[20] bit 
    //2) This task used for ENDEBUG only. Dont use this task in Normal Access.
    task TapAccessArcEndbg(
       input Tap_t                        Tap = Tap_t'(0),
       input [API_SIZE_OF_IR_REG-1:0]     Opcode = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
       input int                          ShiftLength = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
       input bit                          EnUserDefinedShiftLength = 0,
       input bit                          EnRegisterPresenceCheck = 1,
       output bit [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo);
    begin
       bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] cmp_mask_chopped = 0;

`ifndef JTAGBFM_ENDEBUG_110REV
	for (int ii=0; ii < ShiftLength; ii++)
	   cmp_mask_chopped[ii] = CompareMask[ii];

       `uvm_info (get_type_name(), $psprintf("JTAGBFM: Starting access for TAP %s, Opcode 'h0%0h, Inp Data %0d'h0%0h, Exp Data 'h0%0h, Exp Mask 'h0%0h",
       Tap.name(), Opcode, ShiftLength, ShiftIn, ExpectedData, cmp_mask_chopped), UVM_NONE);

       //Task check for availability of Tap in the network
       GetTapAvailableStatus (Tap);

       //If Tap of interest exists in a given network then
       //proceed with enable and access operation.
       if (TapExistFlag == 1) begin

          //Enable Tap of interest before accessing any opcode.
          EnableTap (Tap);
         `ifdef JTAG_BFM_TAPLINK_MODE
            CLTAP_Ir_Width = Get_IR_Width(Tap_t'(0));
         `endif

         //This should execute only once:
         if(ArrayOfHistoryElements[Tap].TapChangedToEnabled == 0) begin
            ArcTapEnDbgCount = 0;
         end
         if((ArcTapEnDbgCount == 0) && (ArrayOfHistoryElements[Tap].TapChangedToEnabled == 0)) begin
            if ((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) begin
                JtagBfmEnDebug_FSMMODE00_RUTI_TO_TLRS (.CLTAPIrWidth(CLTAP_Ir_Width));
            end
            ArcTapEnDbgCount++;
         end

         ArrayOfHistoryElements[Tap].TapChangedToEnabled = 1;
          if ((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) begin
             ENDEBUG_ENCRYPTION_CFG.SKIPRUTISTATEEN = 1'b1;
             MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h1, ENDEBUG_ENCRYPTION_CFG, CLTAP_Ir_Width, ENDEBUG_CFG_REG_LENGTH);
          end
          AccessTargetReg(
             .TapOfInterest (Tap),
             .Opcode        (Opcode),
             .InputDrWidth  (ShiftLength),
             .InputDrData   (ShiftIn),
             .ExpectedData  (ExpectedData),
             .Mask          (CompareMask),
             .EnRegisterPresenceCheck (EnRegisterPresenceCheck),
             .EnUserDefinedDRLength (EnUserDefinedShiftLength),
             .TDOData(tdo_data),
             .TDODataChopped (ReturnTdo));

          if ((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) begin
             ENDEBUG_ENCRYPTION_CFG.SKIPRUTISTATEEN = 1'b0;
             MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h1, ENDEBUG_ENCRYPTION_CFG, CLTAP_Ir_Width, ENDEBUG_CFG_REG_LENGTH);
          end
         // HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
         // for (int k=HierarchyLevel_Internal; k>0;k--) begin
         //    for (int p=0; p<NUMBER_OF_TAPS; p++) begin
         //       if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
         //          if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	      //             DisableTap(Tap_t'(p));
         //          end
         //       end
         //    end
         // end
       end

       `dbg_display("TapAccessArcEndbg Calling RUTI...");
       Goto(RUTI,1);
`else
       `uvm_fatal(get_name(),"ENDEBUG Version 110 dont have ARCTAP support")
`endif
    end
    endtask : TapAccessArcEndbg

    //This task used to do PHY TAP trasnactions through ENDEBUG.
    task TapAccessPhyEndbg(
       input Tap_t                        Tap = Tap_t'(0),
       input [API_SIZE_OF_IR_REG-1:0]     Opcode = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
       input int                          ShiftLength = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
       input bit                          EnUserDefinedShiftLength = 0,
       input bit                          EnRegisterPresenceCheck = 1,
       output bit [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo);
    begin
       bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] cmp_mask_chopped = 0;

	for (int ii=0; ii < ShiftLength; ii++)
	   cmp_mask_chopped[ii] = CompareMask[ii];

       `uvm_info (get_type_name(), $psprintf("JTAGBFM: Starting access for TAP %s, Opcode 'h0%0h, Inp Data %0d'h0%0h, Exp Data 'h0%0h, Exp Mask 'h0%0h",
       Tap.name(), Opcode, ShiftLength, ShiftIn, ExpectedData, cmp_mask_chopped), UVM_NONE);

       //Task check for availability of Tap in the network
       GetTapAvailableStatus (Tap);

       //If Tap of interest exists in a given network then
       //proceed with enable and access operation.
       if (TapExistFlag == 1) begin

          //Enable Tap of interest before accessing any opcode.
          EnableTap (Tap);
         `ifdef JTAG_BFM_TAPLINK_MODE
            CLTAP_Ir_Width = Get_IR_Width(Tap_t'(0));
         `endif

         //This should execute only once:
         if(ArrayOfHistoryElements[Tap].TapChangedToEnabled == 0) begin
            PhyTapEnDbgCount = 0;
         end
         if((PhyTapEnDbgCount == 0) && (ArrayOfHistoryElements[Tap].TapChangedToEnabled == 0)) begin
            if ((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) begin
                JtagBfmEnDebug_FSMMODE00_RUTI_TO_TLRS (.CLTAPIrWidth(CLTAP_Ir_Width));
            end
            PhyTapEnDbgCount++;
         end

         ArrayOfHistoryElements[Tap].TapChangedToEnabled = 1;           
          AccessTargetReg(
             .TapOfInterest (Tap),
             .Opcode        (Opcode),
             .InputDrWidth  (ShiftLength),
             .InputDrData   (ShiftIn),
             .ExpectedData  (ExpectedData),
             .Mask          (CompareMask),
             .EnRegisterPresenceCheck (EnRegisterPresenceCheck),
             .EnUserDefinedDRLength (EnUserDefinedShiftLength),
             .TDOData(tdo_data),
             .TDODataChopped (ReturnTdo));

         // HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
         // for (int k=HierarchyLevel_Internal; k>0;k--) begin
         //    for (int p=0; p<NUMBER_OF_TAPS; p++) begin
         //       if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
         //          if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	      //             DisableTap(Tap_t'(p));
         //          end
         //       end
         //    end
         // end
       end

       `dbg_display("TapAccessPhyEndbg Calling RUTI...");
       Goto(RUTI,1);
    
    end
    endtask : TapAccessPhyEndbg

    task TapAccessRuti(
       input Tap_t                        Tap = Tap_t'(0),
       input [API_SIZE_OF_IR_REG-1:0]     Opcode = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
       input int                          ShiftLength = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0,
       input bit                          EnUserDefinedShiftLength = 0,
       input bit                          EnRegisterPresenceCheck = 1,
       input [63:0]                       RutiLen = 1,
       output bit [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo);
    begin
       bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] cmp_mask_chopped = 0;

	for (int ii=0; ii < ShiftLength; ii++)
	   cmp_mask_chopped[ii] = CompareMask[ii];

       `uvm_info (get_type_name(), $psprintf("JTAGBFM: Starting access for TAP %s, Opcode 'h0%0h, Inp Data %0d'h0%0h, Exp Data 'h0%0h, Exp Mask 'h0%0h",
       Tap.name(), Opcode, ShiftLength, ShiftIn, ExpectedData, cmp_mask_chopped), UVM_NONE);

       //Task check for availability of Tap in the network
       GetTapAvailableStatus (Tap);

       //If Tap of interest exists in a given network then
       //proceed with enable and access operation.
       if (TapExistFlag == 1) begin

          //Enable Tap of interest before accessing any opcode.
          EnableTap (Tap);
          Goto(RUTI,RutiLen);

          AccessTargetReg(
             .TapOfInterest (Tap),
             .Opcode        (Opcode),
             .InputDrWidth  (ShiftLength),
             .InputDrData   (ShiftIn),
             .ExpectedData  (ExpectedData),
             .Mask          (CompareMask),
             .EnRegisterPresenceCheck (EnRegisterPresenceCheck),
             .EnUserDefinedDRLength (EnUserDefinedShiftLength),
             .TDOData(tdo_data),
             .TDODataChopped (ReturnTdo));

          //if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap !== Tap_t'(0))) begin
          //  HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
          //  for (int k=HierarchyLevel_Internal; k>0;k--) begin
          //     for (int p=0; p<NUMBER_OF_TAPS; p++) begin
          //        if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
          //           if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	  //                   DisableTap(Tap_t'(p));
          //           end
          //        end
          //     end
          //  end
          //end
       end

       `dbg_display("TapAccessRuti Calling RUTI...");
       Goto(RUTI,1);
    end
    endtask : TapAccessRuti

    task MultiTapAccessLaunchPrimary();
    begin
       Tap_t                            Tap;
       bit [API_SIZE_OF_IR_REG-1:0]     Opcode = 0;
       bit [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0;
       int                              ShiftLength = 0;
       bit [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0;
       bit [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0;
       bit                              EnUserDefinedShiftLength = 0;
       bit                              EnRegisterPresenceCheck = 1;
       bit [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       bit [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;

       MultiTapAccessSelected = 1;
       MultiLaunchPrimary     = 1;

       `uvm_info (get_type_name(), "JTAGBFM: Starting Multi-Tap access on Primary Port...", UVM_NONE);

       Tap = Tap_t'(0);

       `dbg_display("MultiTapAccessLaunchPrimary Started...");
       AccessTargetReg(
          .TapOfInterest (Tap),
          .Opcode        (Opcode),
          .InputDrWidth  (ShiftLength),
          .InputDrData   (ShiftIn),
          .ExpectedData  (ExpectedData),
          .Mask          (CompareMask),
          .EnRegisterPresenceCheck (EnRegisterPresenceCheck),
          .EnUserDefinedDRLength (EnUserDefinedShiftLength),
          .TDOData(ReturnTdo),
          .TDODataChopped (tdo_data_chopped));

       `dbg_display("MultiTapAccessLaunchPrimary Calling RUTI...");
       Goto(RUTI,1);
       MultiTapAccessSelected = 0;
       MultiLaunchPrimary     = 0;
    end
    endtask : MultiTapAccessLaunchPrimary


    task MultiTapAccessLaunchSecondary();
    begin
       Tap_t                            Tap;
       bit [API_SIZE_OF_IR_REG-1:0]     Opcode = 0;
       bit [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0;
       int                              ShiftLength = 0;
       bit [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0;
       bit [WIDTH_OF_EACH_REGISTER-1:0] CompareMask = 0;
       bit                              EnUserDefinedShiftLength = 0;
       bit                              EnRegisterPresenceCheck = 1;
       bit [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
       bit [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
`ifndef JTAGBFM_EN_DFTB_HTAP
       MultiTapAccessSelected = 1;
       MultiLaunchSecondary   = 1;

      `uvm_info (get_type_name(), "JTAGBFM: Starting Multi-Tap access on Secondary Port...", UVM_NONE);

`ifdef JTAG_BFM_TAPLINK_MODE
       `uvm_fatal(get_name(),"JTAG BFM does not support TAP secondary port in TapLink mode")
`endif

       Tap = Tap_t'(0);

       `dbg_display("MultiTapAccessLaunchSecondary Started...");
       AccessTargetReg(
          .TapOfInterest (Tap),
          .Opcode        (Opcode),
          .InputDrWidth  (ShiftLength),
          .InputDrData   (ShiftIn),
          .ExpectedData  (ExpectedData),
          .Mask          (CompareMask),
          .EnRegisterPresenceCheck (EnRegisterPresenceCheck),
          .EnUserDefinedDRLength (EnUserDefinedShiftLength),
          .TDOData(ReturnTdo),
          .TDODataChopped (tdo_data_chopped));

       `dbg_display("MultiTapAccessLaunchSecondary Calling RUTI...");
       Goto(RUTI,1);
       MultiTapAccessSelected = 0;
       MultiLaunchSecondary   = 0;
`endif
    end
    endtask : MultiTapAccessLaunchSecondary


    task AddIrDrForMultiTapAccess(
       input Tap_t                             Tap = 0,
       input [API_SIZE_OF_IR_REG-1:0]          Opcode = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0]      ShiftIn = 0,
       input int                               ShiftLength = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0]      ExpectedData = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0]      CompareMask = 0,
       input bit                               EnUserDefinedShiftLength = 0,
       input bit                               EnRegisterPresenceCheck = 1,
       output bit [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo);
    begin  
       int   InputDrWidthInternal;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] cmp_mask_chopped = 0;

`ifndef JTAG_BFM_TAPLINK_MODE
       if (EnRegisterPresenceCheck == 1) begin
          if (EnUserDefinedShiftLength == 0) begin
             InputDrWidthInternal = Get_DR_Width(Tap, Opcode);
          end
          else if (EnUserDefinedShiftLength == 1) begin
             InputDrWidthInternal = ShiftLength;
          end  
       end
       else if (EnRegisterPresenceCheck == 0) begin
          InputDrWidthInternal = ShiftLength;
       end
`else

          if (EnRegisterPresenceCheck == 1) begin
             if (EnUserDefinedShiftLength == 0) begin
                InputDrWidthInternal = Get_DR_Width(Tap, Opcode);
             end
             else if (EnUserDefinedShiftLength == 1) begin
	        if (Tap == Tap_t'(0)) begin
                  InputDrWidthInternal = ShiftLength;
		end
		else begin // IP TAP
                  InputDrWidthInternal = Get_DR_Width(Tap, Opcode);
                  if (InputDrWidthInternal != ShiftLength) begin
		    //`uvm_fatal(get_name(),"JTAG BFM does not support user defined DR data width in TapLink mode")
       	    	    `uvm_info (get_type_name(), $psprintf("JTAGBFM: WARNING: user specified DR size %0d, spec size %0d",
              	        ShiftLength, InputDrWidthInternal), UVM_NONE);
                    InputDrWidthInternal = ShiftLength;
		  end
		end
             end  
          end
          else if (EnRegisterPresenceCheck == 0) begin
	        if (Tap == Tap_t'(0)) begin
                  InputDrWidthInternal = ShiftLength;
		end
		else begin // IP TAP
                  //InputDrWidthInternal = Get_DR_Width(Tap, Opcode);
                  //if (InputDrWidthInternal != ShiftLength) begin
		    //`uvm_fatal(get_name(),"JTAG BFM does not support user defined DR data width in TapLink mode")
       	    	    `uvm_info (get_type_name(), $psprintf("JTAGBFM: WARNING: user specified DR size %0d",
              	    	ShiftLength), UVM_NONE);
                    InputDrWidthInternal = ShiftLength;
		  //end
		end
          end

          EnableTapForMultiAccess(Tap);
	  MultiTapAccess.push_back(Tap);
`endif

	for (int ii=0; ii < InputDrWidthInternal; ii++)
	   cmp_mask_chopped[ii] = CompareMask[ii];

       `uvm_info (get_type_name(), $psprintf("JTAGBFM: Add Multi-Tap access for TAP %s, Opcode 'h0%0h, Inp Data %0d'h0%0h, Exp Data 'h0%0h, Exp Mask 'h0%0h",
              Tap.name(), Opcode, InputDrWidthInternal, ShiftIn, ExpectedData, cmp_mask_chopped), UVM_NONE);

       ArrayOfHistoryElements[Tap].OpcodeForMultiTapAccess       = Opcode;
       ArrayOfHistoryElements[Tap].OpcodeWidthForMultiTapAccess  = Get_IR_Width(Tap);
       ArrayOfHistoryElements[Tap].DataForMultiTapAccess         = ShiftIn;
       ArrayOfHistoryElements[Tap].DataWidthForMultiTapAccess    = InputDrWidthInternal;
       ArrayOfHistoryElements[Tap].CompareValueForMultiTapAccess = ExpectedData;
       ArrayOfHistoryElements[Tap].CompareMaskForMultiTapAccess  = CompareMask;
       `dbg_display("From task AddIrDrForMultiTapAccess, DataWidthForMultiTapAccess = %0d", ArrayOfHistoryElements[Tap].DataWidthForMultiTapAccess);
    end
    endtask : AddIrDrForMultiTapAccess

    //=========================================
    //Get number of Taps enabled in given network
    //This task creates a table which contains information of each Tap compared 
    //with reference Reference Tap.
    //Output come of this function are two tables TapAfterTapOfInterestArray and
    //TapBeforeTapOfInterestArray.
    //Example: In given hierarchy following holds true.
    //ArrayOfHistoryElements[17].TapBeforeTapOfInterestArray =
    //31'{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} 
    //
    //ArrayOfHistoryElements[17].TapAfterTapOfInterestArray  =
    //31'{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1} 
    //=========================================
    function void UpdateArrayIfBeforeOrAfterTapOfInterest(
       input Tap_t TapOfInterest         = Tap_t'(0),
       input Tap_t TapUnderInvestigation = Tap_t'(0));
    begin
       int HierarchyLevelOfTapOfInterest;
       int HierarchyLevelOfTapUnderInvestigation;
       int ChildOfTapOfInterestFlag;
       int ParentOfTapOfInterestFlag;
       Tap_t ParentOfTapOfInterest;
       Tap_t ParentOfTapUnderInvestigation;
       int PostionOfTapOfTapOfInterest;
       int PostionOfTapOfTapUnderInvestigation;
       Tap_t InternalTapOfInterest         = Tap_t'(0);
       Tap_t InternalTapUnderInvestigation = Tap_t'(0);

       HierarchyLevelOfTapOfInterest         = ArrayOfHistoryElements[TapOfInterest].HierarchyLevel;
       HierarchyLevelOfTapUnderInvestigation = ArrayOfHistoryElements[TapUnderInvestigation].HierarchyLevel;
       ParentOfTapOfInterest                 = ArrayOfHistoryElements[TapOfInterest].ParentTap;
       ParentOfTapUnderInvestigation         = ArrayOfHistoryElements[TapUnderInvestigation].ParentTap;
       PostionOfTapOfTapOfInterest           = ArrayOfHistoryElements[TapOfInterest].PostionOfTapInTapcSelReg;
       PostionOfTapOfTapUnderInvestigation   = ArrayOfHistoryElements[TapUnderInvestigation].PostionOfTapInTapcSelReg;
       InternalTapOfInterest                 = TapOfInterest;
       InternalTapUnderInvestigation         = TapUnderInvestigation;

       `dbg_display("HierarchyLevelOfTapOfInterest        ", HierarchyLevelOfTapOfInterest);
       `dbg_display("HierarchyLevelOfTapUnderInvestigation", HierarchyLevelOfTapUnderInvestigation);
       `dbg_display("ParentOfTapOfInterest                ", ParentOfTapOfInterest);
       `dbg_display("ParentOfTapUnderInvestigation        ", ParentOfTapUnderInvestigation);
       `dbg_display("PostionOfTapOfTapOfInterest          ", PostionOfTapOfTapOfInterest);
       `dbg_display("PostionOfTapOfTapUnderInvestigation  ", PostionOfTapOfTapUnderInvestigation);
       `dbg_display("InternalTapOfInterest                ", InternalTapOfInterest);
       `dbg_display("InternalTapUnderInvestigation        ", InternalTapUnderInvestigation);

       //Conditions
       //
       //Are tap of interest and tap under investigation at same hierarchy?
       //  if yes 
       //    check postion of tap to decide whether before or after
       //Is Tap hierarchy of investigation is less than tap of interest?
       //  if yes
       //    get parent of tap of interest untill they are on same hierarchy level
       //    check postion of tap to decide whether before or after 

       ChildOfTapOfInterestFlag  = 0;
       ParentOfTapOfInterestFlag = 0;

       if (HierarchyLevelOfTapUnderInvestigation == HierarchyLevelOfTapOfInterest) begin
          if (ParentOfTapOfInterest != ParentOfTapUnderInvestigation) begin
             while (ParentOfTapOfInterest != ParentOfTapUnderInvestigation) begin      
                InternalTapOfInterest               = ParentOfTapOfInterest;
                InternalTapUnderInvestigation       = ParentOfTapUnderInvestigation;
                ParentOfTapOfInterest               = ArrayOfHistoryElements[InternalTapOfInterest].ParentTap;
                ParentOfTapUnderInvestigation       = ArrayOfHistoryElements[InternalTapUnderInvestigation].ParentTap;
                PostionOfTapOfTapOfInterest         = ArrayOfHistoryElements[InternalTapOfInterest].PostionOfTapInTapcSelReg;
                PostionOfTapOfTapUnderInvestigation = ArrayOfHistoryElements[InternalTapUnderInvestigation].PostionOfTapInTapcSelReg;

                `dbg_display("== HierarchyLevelOfTapOfInterest        ", HierarchyLevelOfTapOfInterest);
                `dbg_display("== HierarchyLevelOfTapUnderInvestigation", HierarchyLevelOfTapUnderInvestigation);
                `dbg_display("== ParentOfTapOfInterest                ", ParentOfTapOfInterest);
                `dbg_display("== ParentOfTapUnderInvestigation        ", ParentOfTapUnderInvestigation);
                `dbg_display("== PostionOfTapOfTapOfInterest          ", PostionOfTapOfTapOfInterest);
                `dbg_display("== PostionOfTapOfTapUnderInvestigation  ", PostionOfTapOfTapUnderInvestigation);
                `dbg_display("== InternalTapOfInterest                ", InternalTapOfInterest);
                `dbg_display("== InternalTapUnderInvestigation        ", InternalTapUnderInvestigation);
             end  
          end  
       end
       //Is Tap hierarchy of investigation is less than tap of interest?
       //  if yes
       //    get parent of tap of interest untill they are on same hierarchy level
       //    check postion of tap to decide whether before or after 
       else if (HierarchyLevelOfTapUnderInvestigation < HierarchyLevelOfTapOfInterest) begin
          ParentOfTapOfInterest         = ArrayOfHistoryElements[TapOfInterest].ParentTap;
          ParentOfTapUnderInvestigation = ArrayOfHistoryElements[TapUnderInvestigation].ParentTap;
          ParentOfTapOfInterestFlag     = 0;
          `dbg_display("1 < ParentOfTapOfInterest", ParentOfTapOfInterest);
          `dbg_display("1 < ParentOfTapUnderInvestigation", ParentOfTapUnderInvestigation);
          `dbg_display("1 < ParentOfTapOfInterestFlag", ParentOfTapOfInterestFlag);
          `dbg_display("1 < TapOfInterest = %0s", TapOfInterest);
          `dbg_display("1 < TapUnderInvestigation = %0s", TapUnderInvestigation);

          while (Tap_t'(0) != ParentOfTapOfInterest) begin      
             if (TapUnderInvestigation == ParentOfTapOfInterest) begin
                ParentOfTapOfInterestFlag = 1;
                `dbg_display("2 < Break Applied");
                break;
             end
             ParentOfTapOfInterest = ArrayOfHistoryElements[ParentOfTapOfInterest].ParentTap;
             `dbg_display("3 < ParentOfTapUnderInvestigation", ParentOfTapUnderInvestigation);
          end  
          `dbg_display("4 < ParentOfTapOfInterestFlag", ParentOfTapOfInterestFlag);

          if (ParentOfTapOfInterestFlag == 0) begin
             HierarchyLevelOfTapOfInterest         = ArrayOfHistoryElements[TapOfInterest].HierarchyLevel;
             HierarchyLevelOfTapUnderInvestigation = ArrayOfHistoryElements[TapUnderInvestigation].HierarchyLevel;
             InternalTapOfInterest                 = TapOfInterest;
             `dbg_display("5 < HierarchyLevelOfTapOfInterest           ", HierarchyLevelOfTapOfInterest);
             `dbg_display("5 < HierarchyLevelOfTapUnderInvestigation   ", HierarchyLevelOfTapUnderInvestigation);
             `dbg_display("5 < InternalTapOfInterest                   ", InternalTapOfInterest);

             while (HierarchyLevelOfTapUnderInvestigation != HierarchyLevelOfTapOfInterest) begin
                InternalTapOfInterest         = ArrayOfHistoryElements[InternalTapOfInterest].ParentTap;
                HierarchyLevelOfTapOfInterest = ArrayOfHistoryElements[InternalTapOfInterest].HierarchyLevel;
                `dbg_display("6 < InternalTapOfInterest                ", InternalTapOfInterest);
                `dbg_display("6 < HierarchyLevelOfTapOfInterest        ", HierarchyLevelOfTapOfInterest);
             end  

             `dbg_display("7 < InternalTapOfInterest                ", InternalTapOfInterest);
             `dbg_display("7 < TapUnderInvestigation                ", TapUnderInvestigation);
             ParentOfTapOfInterest         = ArrayOfHistoryElements[InternalTapOfInterest].ParentTap;
             ParentOfTapUnderInvestigation = ArrayOfHistoryElements[TapUnderInvestigation].ParentTap;
             `dbg_display("8 < ParentOfTapOfInterest                ", ParentOfTapOfInterest);
             `dbg_display("8 < ParentOfTapUnderInvestigation        ", ParentOfTapUnderInvestigation);

             if (ParentOfTapOfInterest != ParentOfTapUnderInvestigation) begin
                while (ParentOfTapOfInterest != ParentOfTapUnderInvestigation) begin      
                   InternalTapOfInterest         = ParentOfTapOfInterest;
                   InternalTapUnderInvestigation = ParentOfTapUnderInvestigation;
                   ParentOfTapOfInterest         = ArrayOfHistoryElements[InternalTapOfInterest].ParentTap;
                   ParentOfTapUnderInvestigation = ArrayOfHistoryElements[InternalTapUnderInvestigation].ParentTap;

                   `dbg_display("9 < HierarchyLevelOfTapOfInterest        ", HierarchyLevelOfTapOfInterest);
                   `dbg_display("9 < HierarchyLevelOfTapUnderInvestigation", HierarchyLevelOfTapUnderInvestigation);
                   `dbg_display("9 < ParentOfTapOfInterest                ", ParentOfTapOfInterest);
                   `dbg_display("9 < ParentOfTapUnderInvestigation        ", ParentOfTapUnderInvestigation);
                   `dbg_display("9 < PostionOfTapOfTapOfInterest          ", PostionOfTapOfTapOfInterest);
                   `dbg_display("9 < PostionOfTapOfTapUnderInvestigation  ", PostionOfTapOfTapUnderInvestigation);
                   `dbg_display("9 < InternalTapOfInterest                ", InternalTapOfInterest);
                   `dbg_display("9 < InternalTapUnderInvestigation        ", InternalTapUnderInvestigation);

                end  
             end
          end
          PostionOfTapOfTapOfInterest         = ArrayOfHistoryElements[InternalTapOfInterest].PostionOfTapInTapcSelReg;
          PostionOfTapOfTapUnderInvestigation = ArrayOfHistoryElements[InternalTapUnderInvestigation].PostionOfTapInTapcSelReg;
          `dbg_display("10 < PostionOfTapOfTapOfInterest          ", PostionOfTapOfTapOfInterest);
          `dbg_display("10 < PostionOfTapOfTapUnderInvestigation  ", PostionOfTapOfTapUnderInvestigation);
       end  
       else if (HierarchyLevelOfTapUnderInvestigation > HierarchyLevelOfTapOfInterest) begin
          ParentOfTapOfInterest         = ArrayOfHistoryElements[TapOfInterest].ParentTap;
          ParentOfTapUnderInvestigation = ArrayOfHistoryElements[TapUnderInvestigation].ParentTap;
          ChildOfTapOfInterestFlag      = 0;
          `dbg_display("11 < ParentOfTapOfInterest", ParentOfTapOfInterest);
          `dbg_display("11 < ParentOfTapUnderInvestigation", ParentOfTapUnderInvestigation);
          `dbg_display("11 < ChildOfTapOfInterestFlag", ChildOfTapOfInterestFlag);
          `dbg_display("11 < TapOfInterest = %0s", TapOfInterest);
          `dbg_display("11 < TapUnderInvestigation = %0s", TapUnderInvestigation);

          while (Tap_t'(0) != ParentOfTapUnderInvestigation) begin      
             if (ParentOfTapUnderInvestigation == TapOfInterest) begin
                ChildOfTapOfInterestFlag = 1;
                `dbg_display("12 < Break Applied");
                break;
             end
             ParentOfTapUnderInvestigation = ArrayOfHistoryElements[ParentOfTapUnderInvestigation].ParentTap;
             `dbg_display("13 < ParentOfTapUnderInvestigation", ParentOfTapUnderInvestigation);
          end  
          `dbg_display("14 < ChildOfTapOfInterestFlag", ChildOfTapOfInterestFlag);

          if (ChildOfTapOfInterestFlag == 0) begin
             HierarchyLevelOfTapOfInterest         = ArrayOfHistoryElements[TapOfInterest].HierarchyLevel;
             HierarchyLevelOfTapUnderInvestigation = ArrayOfHistoryElements[TapUnderInvestigation].HierarchyLevel;
             InternalTapUnderInvestigation         = TapUnderInvestigation;
             `dbg_display("15 < HierarchyLevelOfTapOfInterest           ", HierarchyLevelOfTapOfInterest);
             `dbg_display("15 < HierarchyLevelOfTapUnderInvestigation   ", HierarchyLevelOfTapUnderInvestigation);
             `dbg_display("15 < InternalTapUnderInvestigation           ", InternalTapUnderInvestigation);

             while (HierarchyLevelOfTapUnderInvestigation != HierarchyLevelOfTapOfInterest) begin
                InternalTapUnderInvestigation         = ArrayOfHistoryElements[InternalTapUnderInvestigation].ParentTap;
                HierarchyLevelOfTapUnderInvestigation = ArrayOfHistoryElements[InternalTapUnderInvestigation].HierarchyLevel;
                `dbg_display("16 < InternalTapUnderInvestigation", InternalTapUnderInvestigation);
                `dbg_display("16 < HierarchyLevelOfTapUnderInvestigation", HierarchyLevelOfTapUnderInvestigation);
             end  

             ParentOfTapOfInterest         = ArrayOfHistoryElements[TapOfInterest].ParentTap;
             ParentOfTapUnderInvestigation = ArrayOfHistoryElements[InternalTapUnderInvestigation].ParentTap;

             if (ParentOfTapOfInterest != ParentOfTapUnderInvestigation) begin
                while (ParentOfTapOfInterest != ParentOfTapUnderInvestigation) begin
                   InternalTapOfInterest         = ParentOfTapOfInterest;
                   InternalTapUnderInvestigation = ParentOfTapUnderInvestigation;
                   ParentOfTapOfInterest         = ArrayOfHistoryElements[InternalTapOfInterest].ParentTap;
                   ParentOfTapUnderInvestigation = ArrayOfHistoryElements[InternalTapUnderInvestigation].ParentTap;

                   `dbg_display("17 < HierarchyLevelOfTapOfInterest        ", HierarchyLevelOfTapOfInterest);
                   `dbg_display("17 < HierarchyLevelOfTapUnderInvestigation", HierarchyLevelOfTapUnderInvestigation);
                   `dbg_display("17 < ParentOfTapOfInterest                ", ParentOfTapOfInterest);
                   `dbg_display("17 < ParentOfTapUnderInvestigation        ", ParentOfTapUnderInvestigation);
                   `dbg_display("17 < PostionOfTapOfTapOfInterest          ", PostionOfTapOfTapOfInterest);
                   `dbg_display("17 < PostionOfTapOfTapUnderInvestigation  ", PostionOfTapOfTapUnderInvestigation);
                   `dbg_display("17 < InternalTapOfInterest                ", InternalTapOfInterest);
                   `dbg_display("17 < InternalTapUnderInvestigation        ", InternalTapUnderInvestigation);
                end  
             end

             PostionOfTapOfTapOfInterest         = ArrayOfHistoryElements[InternalTapOfInterest].PostionOfTapInTapcSelReg;
             PostionOfTapOfTapUnderInvestigation = ArrayOfHistoryElements[InternalTapUnderInvestigation].PostionOfTapInTapcSelReg;
             `dbg_display("18 < PostionOfTapOfTapOfInterest          ", PostionOfTapOfTapOfInterest);
             `dbg_display("18 < PostionOfTapOfTapUnderInvestigation  ", PostionOfTapOfTapUnderInvestigation);
          end  
       end  

       if (TapUnderInvestigation != TapOfInterest) begin
          if (TapUnderInvestigation == Tap_t'(0)) begin
             ArrayOfHistoryElements[TapOfInterest].TapBeforeTapOfInterestArray[TapUnderInvestigation] = 1;
             ArrayOfHistoryElements[TapOfInterest].TapBeforeTapOfInterestQueue.push_front(1);
          end  
          else if (TapOfInterest == Tap_t'(0)) begin
             ArrayOfHistoryElements[TapOfInterest].TapAfterTapOfInterestArray[TapUnderInvestigation] = 1;
             ArrayOfHistoryElements[TapOfInterest].TapAfterTapOfInterestQueue.push_front(1);
          end  
          else if (ParentOfTapOfInterestFlag == 1) begin
             ArrayOfHistoryElements[TapOfInterest].TapBeforeTapOfInterestArray[TapUnderInvestigation] = 1;
             ArrayOfHistoryElements[TapOfInterest].TapBeforeTapOfInterestQueue.push_front(1);
          end  
          else if (ChildOfTapOfInterestFlag == 1) begin
             ArrayOfHistoryElements[TapOfInterest].TapAfterTapOfInterestArray[TapUnderInvestigation] = 1;
             ArrayOfHistoryElements[TapOfInterest].TapAfterTapOfInterestQueue.push_front(1);
          end  
          else if (PostionOfTapOfTapUnderInvestigation < PostionOfTapOfTapOfInterest) begin
             ArrayOfHistoryElements[TapOfInterest].TapBeforeTapOfInterestArray[TapUnderInvestigation] = 1;
             ArrayOfHistoryElements[TapOfInterest].TapBeforeTapOfInterestQueue.push_front(1);
          end
          else if (PostionOfTapOfTapUnderInvestigation > PostionOfTapOfTapOfInterest) begin
             ArrayOfHistoryElements[TapOfInterest].TapAfterTapOfInterestArray[TapUnderInvestigation] = 1;
             ArrayOfHistoryElements[TapOfInterest].TapAfterTapOfInterestQueue.push_front(1);
          end
       end
    end
    endfunction : UpdateArrayIfBeforeOrAfterTapOfInterest

    //This task access a register provided Tap of Interest is enabled using the Landmark Task.
    // 05-Mar-2015 Made this task automatic to ensure that the variables are released once the call to the task is over.
    task automatic AccessTargetReg (
       input Tap_t TapOfInterest = Tap_t'(0),
       input logic [API_SIZE_OF_IR_REG-1:0] Opcode = 0,
       input int   InputDrWidth = 0,
       input bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData = 0,
       input bit   [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
       input bit   [WIDTH_OF_EACH_REGISTER-1:0] Mask = 0,
       input bit   EnRegisterPresenceCheck = 1,
       input bit   EnUserDefinedDRLength = 0,
       output bit  [WIDTH_OF_EACH_REGISTER-1:0] TDOData,
       output bit  [WIDTH_OF_EACH_REGISTER-1:0] TDODataChopped);
    begin

       Tap_t LocalQueue4[$];
       Tap_t LocalQueue5[$];
       bit   LocalQueue6[$];
       bit   LocalQueue7[$];
       bit   LocalQueue8[$];
       bit   LocalQueue9[$];
       bit   LocalQueue10[$];
       Tap_t LocalQueue4Temp[$];
       Tap_t TapOfInterestInternal;
       Tap_t CltapTap;
       int   PreDelay;
       int   PostDelay;
       int   IrWidth;
       int   IrWidthFinal;
       int   DrWidthFinal;
       int   AddressLength;
       int   PostionOfTap;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] DrChainValue1;
       bit   [API_SIZE_OF_IR_REG-1:0]     IrChainValue1;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] CompareValue1;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdoQualifier; // Pick the bits corresponding to the TAP on interest int he ReturnedTdo vector.
       bit   [WIDTH_OF_EACH_REGISTER-1:0] MaskValue1;
       Tap_t LocalArray4[$];
       int   InputDrWidthInternal;
       bit   [API_SIZE_OF_IR_REG-1:0]     IrChainValueLocal;
       int   IndexInt;
       int   IrWidthTmp;
       bit   AndOpcode;
       bit  [WIDTH_OF_EACH_REGISTER-1:0] TempTDOData;
       bit  [WIDTH_OF_EACH_REGISTER-1:0] cmp_mask_chopped = 0;

       //bit  [WIDTH_OF_EACH_REGISTER-1:0] InternalTDOData;
       //bit  [WIDTH_OF_EACH_REGISTER-1:0] TdoDataAndQualifier;
       //bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped_temp1;
       //bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped_temp2;
       //bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped_temp3;
       //int  Count;
       static int entry=0;
       string msg;

       msg = "";
       if (MultiTapAccessSelected == 1) begin
          foreach (MultiTapAccess [j])
             msg = {msg, MultiTapAccess[j].name(), " "};
         `uvm_info (get_type_name(), $psprintf("JTAGBFM: Multi-Tap access for TAPs %s...", msg), UVM_NONE);
       end
       else begin
         `uvm_info (get_type_name(), $psprintf("JTAGBFM: Access to TAP %s with opcode 'h0%0h...", TapOfInterest.name(), Opcode), UVM_NONE);
       end

       CltapTap = Tap_t'(0);

       entry++;
       `dbg_display("0. MYDBG Entered AccessTargetReg for     entry%0d     at time = %t", entry, $time);
       
       ArrayOfHistoryElements[TapOfInterest].CurrentlyAccessedIr = Opcode;
       ByPassSelected = 0;
       ByPassSelectedForMultiTapAccess = 0;
       AndOpcode = 1;
       `dbg_display("1. Opcode = %0h", Opcode);
       `dbg_display("1. Tap = %s, Opcode = %0h", TapOfInterest.name(), Opcode);

       IrWidthTmp = Get_IR_Width(TapOfInterest);

       // Checking the incoming opcode is a Bypass opcode or not
       for (int i=0; i<IrWidthTmp; i++) begin
          AndOpcode = AndOpcode & Opcode[i];
       end  
       `dbg_display("1. AndOpcode = %0h", AndOpcode);


       if (AndOpcode == 1) begin
          IndexInt = 0;
       end
       else begin
          IndexInt = Get_Reg_Index(TapOfInterest, Opcode);
       end

       `dbg_display("1. ByPassSelected = %0d", ByPassSelected);
       `dbg_display("1. IndexInt = %0d", IndexInt);
       if (MultiTapAccessSelected == 0) begin
          if (IndexInt == 0) begin
             if (EnRegisterPresenceCheck == 1) begin
                ByPassSelected = 1;
                ExpectedData = InputDrData;
                `dbg_display("2. ByPassSelected = %0d", ByPassSelected);
             end
          end
       end


`ifndef JTAG_BFM_TAPLINK_MODE
       if (ArrayOfHistoryElements[TapOfInterest].IsTapDisabled != 1) begin //{
`endif
          LocalQueue4.delete();
          LocalQueue5.delete();
          LocalQueue6.delete();
          LocalQueue7.delete();
          LocalQueue8.delete();
          LocalQueue9.delete();
          LocalQueue10.delete();

          if (MultiTapAccessSelected == 0) begin
             TapOfInterestInternal = TapOfInterest;
          end
          else begin
             //HSD Fix for https://hsdes.intel.com/home/default.html/article?id=1205419522
             //TapOfInterestInternal = Tap_t'(1);
             TapOfInterestInternal = NOTAP;
          end  

          //Get all enabled Taps in given network
          AllTapsEnabledQueue.delete();
          AllTapsEnabledQueue = GetAllEnabledTaps();

          // Add all enabled taps to Q4
          for (int j=0; j<AllTapsEnabledQueue.size(); j++) begin
             LocalQueue4.push_back(AllTapsEnabledQueue[j]);
          end  
          for (int j=0; j<LocalQueue4.size(); j++) begin
             `dbg_display("AccessTargetReg After GetAllEnabledTaps LocalQueue4 [%0d] = %0d", j, LocalQueue4[j]);
          end
          //Uniq
          LocalQueue4Temp.delete();
          LocalQueue4Temp = LocalQueue4.unique();
          LocalQueue4.delete();
          LocalQueue4 = LocalQueue4Temp;
          LocalQueue4Temp.delete();
          for (int j=0; j<LocalQueue4.size(); j++) begin
             `dbg_display("AccessTargetReg After GetAllEnabledTaps Uniq LocalQueue4 [%0d] = %0d", j, LocalQueue4[j]);
          end

          AllTapsDisabledQueue.delete();
          AllTapsDisabledQueue = GetAllDisabledTaps();

          // Delete disabled TAPs from Q4
          LocalQueue4Temp.delete();
          LocalQueue4Temp = DeleteTapsFromTapsQueue(LocalQueue4, AllTapsDisabledQueue);
          LocalQueue4.delete();
          LocalQueue4 = LocalQueue4Temp;

          `dbg_display("After LocalQueue4 ArrayOfHistoryElements[%0s].IsTapOnSecondary = %0h",
          TapOfInterest, ArrayOfHistoryElements[TapOfInterest].IsTapOnSecondary);


          // Delete Secondary TAPs from Q4
          if (MultiTapAccessSelected == 0) begin //{
             LocalQueue4Temp.delete();
             LocalQueue4Temp = DeleteTapsOnOtherModes(TapOfInterest, LocalQueue4);
             LocalQueue4.delete();
             LocalQueue4 = LocalQueue4Temp;
             `dbg_display("AccessReg: LocalQueue4 = ", LocalQueue4);
          end //}
          else if (MultiTapAccessSelected == 1) begin //{
             if (MultiLaunchPrimary == 1) begin //{
                LocalQueue4Temp.delete();
                AllTapsOnSecondary.delete();
                AllTapsOnSecondary = GetAllTapsOnSecondary();
                LocalQueue4Temp = DeleteTapsFromTapsQueue(LocalQueue4, AllTapsOnSecondary);
                LocalQueue4.delete();
                LocalQueue4 = LocalQueue4Temp;
             end //}
             if (MultiLaunchSecondary == 1) begin //{
                LocalQueue4Temp.delete();
                AllTapsOnPrimary.delete();
                AllTapsOnPrimary = GetAllTapsOnPrimary();
                LocalQueue4Temp = DeleteTapsFromTapsQueue(LocalQueue4, AllTapsOnPrimary);
                LocalQueue4.delete();
                LocalQueue4 = LocalQueue4Temp;
             end //}
          end //}

          // Delete REMOVE TAPs from Q4
          LocalQueue4Temp.delete();
          AllTapsOnRemove.delete();
          AllTapsOnRemove = GetAllTapsOnRemove();
          LocalQueue4Temp = DeleteTapsFromTapsQueue(LocalQueue4, AllTapsOnRemove);
          LocalQueue4.delete();
          LocalQueue4 = LocalQueue4Temp;


          //Sort
          LocalArray4.delete();
          LocalArray4 = SortQueueBasedOnAfterTapOfInterest(LocalQueue4);

          LocalQueue4.delete();
          LocalQueue4 = LocalArray4;
          LocalArray4.delete();

          for (int j=0; j<LocalQueue4.size(); j++) begin
             `dbg_display("AccessTargetReg After Sorted LocalQueue4 [%0d] = %0d", j, LocalQueue4[j]);
          end

          for (int j=0; j<LocalQueue4.size(); j++) begin
             `dbg_display("AccessTargetReg After Sorted LocalQueue4 [%0d] = %0d", j, LocalQueue4[j]);
          end
          //Reverse queue
          for (int j=0; j<LocalQueue4.size(); j++) begin
             LocalQueue5.push_back(LocalQueue4[(LocalQueue4.size()-1)-j]);
          end  
          for (int j=0; j<LocalQueue5.size(); j++) begin
             `dbg_display("AccessTargetReg Reverse LocalQueue5 [%0d] = %0d", j, LocalQueue5[j]);
          end

          IrWidthFinal = 0;
          DrWidthFinal = 0;

`ifndef JTAG_BFM_TAPLINK_MODE

          if (EnRegisterPresenceCheck == 1) begin
             if (EnUserDefinedDRLength == 0) begin
                InputDrWidthInternal = Get_DR_Width(TapOfInterest, Opcode);
             end
             else if (EnUserDefinedDRLength == 1) begin
                InputDrWidthInternal = InputDrWidth;
             end  
          end
          else if (EnRegisterPresenceCheck == 0) begin
             InputDrWidthInternal = InputDrWidth;
          end

	    if (TapOfInterestInternal == Tap_t'(0)) begin
          InputDrWidthInternal_CLTAP = InputDrWidthInternal;
       end
`else

          if (EnRegisterPresenceCheck == 1) begin
             if (EnUserDefinedDRLength == 0) begin
                InputDrWidthInternal = Get_DR_Width(TapOfInterest, Opcode);
             end
             else if (EnUserDefinedDRLength == 1) begin
	        if (TapOfInterest == Tap_t'(0)) begin
                  InputDrWidthInternal = InputDrWidth;
		end
		else begin // IP TAP
                  InputDrWidthInternal = Get_DR_Width(TapOfInterest, Opcode);
                  if (InputDrWidthInternal != InputDrWidth) begin
		    //`uvm_fatal(get_name(),"JTAG BFM does not support user defined DR data width in TapLink mode")
       	    	    `uvm_info (get_type_name(), $psprintf("JTAGBFM: WARNING: user specified DR size %0d, spec size %0d",
              	        InputDrWidth, InputDrWidthInternal), UVM_NONE);
                    InputDrWidthInternal = InputDrWidth;
		  end
		end
             end  
          end
          else if (EnRegisterPresenceCheck == 0) begin
	        if (TapOfInterest == Tap_t'(0)) begin
                  InputDrWidthInternal = InputDrWidth;
		end
		else begin // IP TAP
                  //InputDrWidthInternal = Get_DR_Width(TapOfInterest, Opcode);
                  //if (InputDrWidthInternal != InputDrWidth) begin
		    //`uvm_fatal(get_name(),"JTAG BFM does not support user defined DR data width in TapLink mode")
       	    	    `uvm_info (get_type_name(), $psprintf("JTAGBFM: WARNING: user specified DR size %0d",
              	    	InputDrWidth), UVM_NONE);
                    InputDrWidthInternal = InputDrWidth;
		  //end
		end
          end
`endif


          `dbg_display("InputDrWidthInternal = %0d", InputDrWidthInternal);

       `ifndef JTAG_BFM_TAPLINK_MODE

          //Concatinate bits
          `dbg_display("Concatinate ============");
          for (int j=0; j<LocalQueue5.size(); j++) begin

             `dbg_display("Debug1: 1");
             if (MultiTapAccessSelected == 1) begin
                ByPassSelectedForMultiTapAccess = 0;
                AndOpcode = 1;
                `dbg_display("1.MultiTapAccessSelected Opcode = %0h", Opcode);

                IrWidthTmp = Get_IR_Width(LocalQueue5[j]);

                for (int i=0; i<IrWidthTmp; i++) begin
                   AndOpcode = AndOpcode & Opcode[i];
                end  
                `dbg_display("1.MultiTapAccessSelected AndOpcode = %0h", AndOpcode);

                if (AndOpcode == 1) begin
                   IndexInt = 0;
                end
                else begin
                   IndexInt = Get_Reg_Index(LocalQueue5[j], Opcode);
                end

                `dbg_display("1. ByPassSelectedForMultiTapAccess = %0d", ByPassSelectedForMultiTapAccess);
                `dbg_display("1. ByPassSelectedForMultiTapAccess IndexInt = %0d", IndexInt);

                if (IndexInt == 0) begin
                   ByPassSelectedForMultiTapAccess = 1;
                   ExpectedData = ArrayOfHistoryElements[LocalQueue5[j]].CompareValueForMultiTapAccess;
                   `dbg_display("3. ByPassSelectedForMultiTapAccess = %0d", ByPassSelectedForMultiTapAccess);
                   `dbg_display("3. ByPassSelectedForMultiTapAccess ExpectedData = %0h", ExpectedData);
                end
             end

             `dbg_display ("ArrayOfHistoryElements[%0s].EnableMultiTapAccess = %0h",
                LocalQueue5[j], ArrayOfHistoryElements[LocalQueue5[j]].EnableMultiTapAccess);

             IrWidth = Get_IR_Width (LocalQueue5[j]);
             IrWidthFinal = IrWidthFinal + IrWidth;
             IrChainValueLocal = 0;
             `dbg_display ("BUG_DEBUG LocalQueue5[%0d] = %0s, TapOfInterestInternal = %0s",
                                      j, LocalQueue5[j], TapOfInterestInternal);
             if (LocalQueue5[j] != TapOfInterestInternal) begin
                `dbg_display("Debug1: 2");
                for (int k=0; k<IrWidth; k++) begin
                   if (MultiTapAccessSelected == 1) begin
                      if (ArrayOfHistoryElements[LocalQueue5[j]].EnableMultiTapAccess == 0) begin
                         LocalQueue6.push_back(1);
                         IrChainValueLocal[k] = 1;
                      end   
                      else begin
                         LocalQueue6.push_back(ArrayOfHistoryElements[LocalQueue5[j]].OpcodeForMultiTapAccess[k]);
                      end   
                   end   
                   else begin
                      LocalQueue6.push_back(1);
                      IrChainValueLocal[k] = 1;
                   end  
                end 

                `dbg_display("    MultiTapAccessSelected = %0h", MultiTapAccessSelected);
                if (MultiTapAccessSelected == 1) begin
                   if (ArrayOfHistoryElements[LocalQueue5[j]].EnableMultiTapAccess == 0) begin
                      DrWidthFinal = DrWidthFinal + 1;
                      `dbg_display ("0 AccessTargetReg DrWidthFinal = %0d",DrWidthFinal);
                   end   
                   else begin
                      DrWidthFinal = DrWidthFinal + ArrayOfHistoryElements[LocalQueue5[j]].DataWidthForMultiTapAccess;
                      `dbg_display ("1 AccessTargetReg DrWidthFinal = %0d",DrWidthFinal);
                   end
                end
                else begin
                   DrWidthFinal = DrWidthFinal + 1;
                   `dbg_display ("1 AccessTargetReg DrWidthFinal = %0d",DrWidthFinal);
                end  

                `dbg_display ("Debug1: 3 ByPassSelected = %0h", ByPassSelected);
                if (ByPassSelected == 0) begin
                   if (MultiTapAccessSelected == 1) begin
                      `dbg_display ("Entered if part of multitap selection");
                      if (ArrayOfHistoryElements[LocalQueue5[j]].EnableMultiTapAccess == 0) begin
                         LocalQueue7.push_back(0);
                      end
                      else begin
                         for (int k=0; k<ArrayOfHistoryElements[LocalQueue5[j]].DataWidthForMultiTapAccess;k++) begin
                            LocalQueue7.push_back(ArrayOfHistoryElements[LocalQueue5[j]].DataForMultiTapAccess[k]);
                         end
                      end  
                   end  
                   else begin
                      `dbg_display ("Entered else part of multitap selection");
                      LocalQueue7.push_back(0);
                   end 
                end
                if (MultiTapAccessSelected == 1) begin
                   if (ArrayOfHistoryElements[LocalQueue5[j]].EnableMultiTapAccess == 0) begin
                      LocalQueue8.push_back(0);
                      LocalQueue9.push_back(0);
                      LocalQueue10.push_back(0);
                   end   
                   else begin
                      for (int k=0; k<ArrayOfHistoryElements[LocalQueue5[j]].DataWidthForMultiTapAccess;k++) begin
                         LocalQueue8.push_back(ArrayOfHistoryElements[LocalQueue5[j]].CompareValueForMultiTapAccess[k]);
                         LocalQueue9.push_back(ArrayOfHistoryElements[LocalQueue5[j]].CompareMaskForMultiTapAccess[k]);
                         LocalQueue10.push_back(1);
                      end   
                   end  
                end  
                else begin
                   LocalQueue8.push_back(0);
                   LocalQueue9.push_back(0);
                   LocalQueue10.push_back(0);
                end  
             end  
             else if (LocalQueue5[j] == TapOfInterestInternal) begin
                for (int k=0; k<IrWidth; k++) begin
                   LocalQueue6.push_back(Opcode[k]);
                   IrChainValueLocal[k] = Opcode[k];
                end  

                DrWidthFinal = DrWidthFinal + InputDrWidthInternal;
                if (ByPassSelected == 1) begin
                   LocalQueue8.push_back(0);
                   LocalQueue9.push_back(0);
                   LocalQueue10.push_back(0);
                end   
                for (int k=0; k<InputDrWidthInternal; k++) begin
                   `dbg_display ("Debug1:");
                   LocalQueue7.push_back(InputDrData[k]);
                   if (ByPassSelected == 0) begin
                      LocalQueue8.push_back(ExpectedData[k]);
                      LocalQueue9.push_back(Mask[k]);
                      LocalQueue10.push_back(1);
                   end   
                end  
             end  
             ArrayOfHistoryElements[LocalQueue5[j]].PreviousAccessedIr = IrChainValueLocal;
             // ArrayOfHistoryElements[LocalQueue5[j]].CurrentlyAccessedIr = IrChainValueLocal; //Added 6-Sep-13
             // if (MultiTapAccessSelected == 1) begin
             //    ArrayOfHistoryElements[LocalQueue5[j]].CurrentlyAccessedIr = ArrayOfHistoryElements[LocalQueue5[j]].OpcodeForMultiTapAccess | ArrayOfHistoryElements[LocalQueue5[j]].CurrentlyAccessedIr; //Added 16-Sep-13
             // end

             ArrayOfHistoryElements[LocalQueue5[j]].CurrentlyAccessedIr = IrChainValueLocal; //Added 6-Sep-13
             // Needed for tracker to display all the active Taps correrctly. This accounts for Taps that are marked for multi as well.
             if (MultiTapAccessSelected == 1) begin //Added 16-Sep-13
                if (ArrayOfHistoryElements[LocalQueue5[j]].EnableMultiTapAccess == 1) begin
                   ArrayOfHistoryElements[LocalQueue5[j]].CurrentlyAccessedIr = ArrayOfHistoryElements[LocalQueue5[j]].OpcodeForMultiTapAccess;
                end
                else begin
                   ArrayOfHistoryElements[LocalQueue5[j]].CurrentlyAccessedIr = IrChainValueLocal; //Added 6-Sep-13
                end   
             end

             `dbg_display("TRAKER_DEBUG 2 IrChainValueLocal = %0h from task AccessTargetReg", IrChainValueLocal);
             `dbg_display("TRAKER_DEBUG 3 OpcodeForMultiTapAccess = %0h from task AccessTargetReg", ArrayOfHistoryElements[LocalQueue5[j]].OpcodeForMultiTapAccess);

             if (MultiTapAccessSelected == 1) begin
                if (ByPassSelectedForMultiTapAccess == 1) begin
                   if (InputDrWidthInternal > 1) begin
                      for (int k=0; k<InputDrWidthInternal-1; k++) begin
                         LocalQueue8.push_back(ExpectedData[k]);
                         LocalQueue9.push_back(Mask[k]);
                         LocalQueue10.push_back(1);
                      end
                   end  
                end
             end
          end  

          if (MultiTapAccessSelected == 0) begin
             if (ByPassSelected == 1) begin
                if (InputDrWidthInternal > 1) begin
                   for (int k=0; k<InputDrWidthInternal-1; k++) begin
                      LocalQueue8.push_back(ExpectedData[k]);
                      LocalQueue9.push_back(Mask[k]);
                      LocalQueue10.push_back(1);
                   end
                end  
                else if (InputDrWidthInternal == 1) begin
                   LocalQueue10.push_back(1);
                end  
             end
          end


          for (int j=0; j<LocalQueue6.size(); j++) begin
             `dbg_display("AccessTargetReg LocalQueue6 [%0d] = %0d", j, LocalQueue6[j]);
          end
          `dbg_display("AccessTargetReg IrWidthFinal = %0d", IrWidthFinal);
          `dbg_display("AccessTargetReg DrWidthFinal = %0d", DrWidthFinal);
          for (int j=0; j<LocalQueue7.size(); j++) begin
             `dbg_display("LocalQueue7 [%0d] = %0d", j, LocalQueue7[j]);
          end
          for (int j=0; j<LocalQueue8.size(); j++) begin
             `dbg_display("LocalQueue8 [%0d] = %0d", j, LocalQueue8[j]);
          end
          for (int j=0; j<LocalQueue9.size(); j++) begin
             `dbg_display("LocalQueue9 [%0d] = %0d", j, LocalQueue9[j]);
          end
          for (int j=0; j<LocalQueue10.size(); j++) begin
             `dbg_display("LocalQueue10 [%0d] = %0d", j, LocalQueue10[j]);
          end
          IrChainValue1 = ConvertQueuesToArrays1 (LocalQueue6);
          `dbg_display("AccessTargetReg IrChainValue1 = %0h", IrChainValue1);
          DrChainValue1 = ConvertQueuesToArrays1 (LocalQueue7);
          `dbg_display("AccessTargetReg DrChainValue1 = %0h", DrChainValue1);
          CompareValue1 = ConvertQueuesToArrays1 (LocalQueue8);
          `dbg_display("AccessTargetReg CompareValue1 = %0h", CompareValue1);
          MaskValue1 = ConvertQueuesToArrays1 (LocalQueue9);
          `dbg_display("AccessTargetReg MaskValue1 = %0h", MaskValue1);
          ReturnTdoQualifier = ConvertQueuesToArrays1 (LocalQueue10);
          `dbg_display("AccessTargetReg ReturnTdoQualifier = %0h", ReturnTdoQualifier);

          `dbg_display("PreviousTapAccess = %0h", PreviousTapAccess);
       `endif

      // 05-Mar-2015 https://hsdes.intel.com/home/default.html#article?id=1404045114
      // JTAG BFM issue with parallel multi-tap accesses on different ports at the same time
          `dbg_display ("debug24 : AccessTargetReg");
       `ifndef JTAG_BFM_TAPLINK_MODE
       MultiTapAccessSelected = 0;
       MultiLaunchPrimary     = 0;
       MultiLaunchSecondary   = 0;
       
          `dbg_display("0. MYDBG Calling JTAGBFM Driver Task for entry%0d     at time = %t, IR=%0h, DR=%0h", entry, $time, IrChainValue1, DrChainValue1);
          if ((ENDEBUG_OWN == 1'b0) || (FuseDisable == 1'b1) || (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b1)) begin
              call_bfm_driver_apis(
                   IrWidthFinal,
                   DrWidthFinal,
                   IrChainValue1,
                   DrChainValue1,
                   CompareValue1,
                   MaskValue1, 
                   ReturnTdoQualifier,
                   Mask,
                   InputDrData,
                   TapOfInterestInternal,
                   TDOData,
                   TDODataChopped
              );
          end
          else
          begin
             if (TapOfInterestInternal == Tap_t'(0)) begin
                call_bfm_driver_apis(
                     IrWidthFinal,
                     DrWidthFinal,
                     IrChainValue1,
                     DrChainValue1,
                     CompareValue1,
                     MaskValue1, 
                     ReturnTdoQualifier,
                     Mask,
                     InputDrData,
                     TapOfInterestInternal,
                     TDOData,
                     TDODataChopped
                );
             end
             else
             begin
                CLTAP_Ir_Width = Get_IR_Width(Tap_t'(0));
                Endebug_Tap_Access(
                     IrWidthFinal,
                     DrWidthFinal,
                     IrChainValue1,
                     DrChainValue1,
                     CompareValue1,
                     MaskValue1, 
                     ReturnTdoQualifier,
                     Mask,
                     InputDrData,
                     TapOfInterestInternal,
                     CLTAP_Ir_Width,
                     1'b0,
                     TDOData,
                     TDODataChopped
                );
             end
          end
         `dbg_display("0. MYDBG Exited AccessTargetReg  for     entry%0d     at time = %t, IR=%0h, DR=%0h", entry, $time, IrChainValue1, DrChainValue1);

       `endif

      `ifdef JTAG_BFM_TAPLINK_MODE
          `dbg_display("debug 60 :MultiTapAccessSelected = %0d", MultiTapAccessSelected);
          if (MultiTapAccessSelected == 0) begin

	     MultiTapAccess.delete();
	     MultiTapAccess.push_back(TapOfInterest);
        `dbg_display("debug 61 :MultiTapAccess[0] = %0s", MultiTapAccess[0]);
	     
             ArrayOfHistoryElements[TapOfInterest].OpcodeForMultiTapAccess	 = Opcode;
             ArrayOfHistoryElements[TapOfInterest].OpcodeWidthForMultiTapAccess  = Get_IR_Width(TapOfInterest);
             ArrayOfHistoryElements[TapOfInterest].DataForMultiTapAccess	 = InputDrData;
             ArrayOfHistoryElements[TapOfInterest].DataWidthForMultiTapAccess	 = InputDrWidthInternal;
             ArrayOfHistoryElements[TapOfInterest].CompareValueForMultiTapAccess = ExpectedData;
             ArrayOfHistoryElements[TapOfInterest].CompareMaskForMultiTapAccess  = Mask;

          end
	  else begin
	     if (ReadModifyWriteEnabled == 1) begin
	       `uvm_fatal(get_name(),"RMW operation is not supported in Multi-Tap Access mode")
	     end
	  end

          foreach (MultiTapAccess [j]) begin

	     TapOfInterestInternal = MultiTapAccess [j];

             if (TapOfInterestInternal == CltapTap) begin // CLTAP
          	  IrChainValue1 = ArrayOfHistoryElements[CltapTap].OpcodeForMultiTapAccess;


	       if (Is_TapLink_Access(TapOfInterestInternal,ArrayOfHistoryElements[TapOfInterestInternal].OpcodeForMultiTapAccess) != 0) begin
                  if (Tap_with_LBA_exists(IrChainValue1) != 0)
	     	    `uvm_fatal(get_name(),"JTAG BFM does not support direct execution of CLTAP TapLink LinkIR and LinkDR opcodes yet (LBA matched)")
                  if (Tap_with_GBA_exists(IrChainValue1) != 0)
	     	    `uvm_fatal(get_name(),"JTAG BFM does not support direct execution of CLTAP TapLink LinkIR and LinkDR opcodes yet (GBA matched)")
	       end
	       else begin
	     	  IrWidthFinal  = ArrayOfHistoryElements[CltapTap].OpcodeWidthForMultiTapAccess;
          	  DrWidthFinal  = ArrayOfHistoryElements[CltapTap].DataWidthForMultiTapAccess;
          	  DrChainValue1 = ArrayOfHistoryElements[CltapTap].DataForMultiTapAccess;
          	  CompareValue1 = ArrayOfHistoryElements[CltapTap].CompareValueForMultiTapAccess;
          	  MaskValue1    = ArrayOfHistoryElements[CltapTap].CompareMaskForMultiTapAccess;

                  ArrayOfHistoryElements[CltapTap].ReturnedTapTdoData = '0;

          	  ReturnTdoQualifier = '0;
		  for (int j=0; j<DrWidthFinal; j++) begin
             	    ReturnTdoQualifier[j] = 1;
          	  end

        cmp_mask_chopped = '0;
		  for (int ii=0; ii < DrWidthFinal; ii++)
          cmp_mask_chopped[ii] = MaskValue1[ii];

            `uvm_info (get_type_name(), $psprintf("JTAGBFM: Final access info: TAP %s, Opcode %d'h0%0h, Inp Data %0d'h0%0h, Exp Data 'h0%0h, Exp Mask 'h0%0h",
                   CltapTap.name(), IrWidthFinal, IrChainValue1,
			  DrWidthFinal, DrChainValue1, CompareValue1, cmp_mask_chopped), UVM_LOW);

          	  call_bfm_driver_apis(
          	     IrWidthFinal,
          	     DrWidthFinal,
          	     IrChainValue1,
          	     DrChainValue1,
          	     CompareValue1,
          	     MaskValue1,
          	     ReturnTdoQualifier,    // ReturnTdoQualifier
          	     MaskValue1,            // Mask,
          	     DrChainValue1,         // InputDrData,
          	     CltapTap,              // TapOfInterest,
          	     TDOData,
                 ArrayOfHistoryElements[CltapTap].ReturnedTapTdoData
          	  );

            `uvm_info (get_type_name(), $psprintf("JTAGBFM: Completed access: TAP %s, Opcode %0d'h0%0h, Inp Data %0d'h0%0h",
                   CltapTap.name(), IrWidthFinal, IrChainValue1, DrWidthFinal, DrChainValue1), UVM_NONE);
            `uvm_info (get_type_name(), $psprintf("JTAGBFM: Exp Data %0d'h0%0h, Actual TDO %0d'h0%0h, Exp Mask %0d'h0%0h",
          DrWidthFinal, CompareValue1, DrWidthFinal, ArrayOfHistoryElements[CltapTap].ReturnedTapTdoData, DrWidthFinal, cmp_mask_chopped), UVM_NONE);

          	 `dbg_display("0. MYDBG Exited AccessTargetReg  for	entry%0d     at time = %t, TAP=%s, IR=%0h, DR=%0h", 
	     	     entry, $time, CltapTap.name(), IrChainValue1, DrChainValue1);
              `dbg_display("1. MYDBG TAP %s: returned TDO data: %d'h0%0h",
	          CltapTap.name(), DrWidthFinal, ArrayOfHistoryElements[CltapTap].ReturnedTapTdoData);
	       end
	     end
	     else begin // IP TAP
	     	
	     	if (ReadModifyWriteEnabled == 1) begin
	       	   `uvm_fatal(get_name(),"RMW operation is not supported for TapLink access of IP TAPs")
	     	end
		
		IrWidthFinal  = Get_IR_Width(CltapTap);
          	IrChainValue1 = Get_LBA(TapOfInterestInternal);
		PreDelay = Get_Pre_Delay(CltapTap,IrChainValue1);
          	DrWidthFinal  = Get_IR_Width(TapOfInterestInternal)+PreDelay;
          	DrChainValue1 = ArrayOfHistoryElements[TapOfInterestInternal].OpcodeForMultiTapAccess;
           TempTDOData = '0;


          	`dbg_display ("debug 18 : IrWidthFinal  = %0d", IrWidthFinal);
          	`dbg_display ("debug 19 : IrChainValue1 = %0h", IrChainValue1);
          	`dbg_display ("debug 20 : DrWidthFinal  = %0d", DrWidthFinal);
          	`dbg_display ("debug 21 : DrChainValue1 = %0h", DrChainValue1);

          	ReturnTdoQualifier = '0;
		for (int j=0; j<DrWidthFinal; j++) begin
             	  ReturnTdoQualifier[j] = 1;
          	end

          `uvm_info (get_type_name(), $psprintf("JTAGBFM: Final access info: TAP %s, Opcode %0d'h0%0h, Inp Data %0d'h0%0h with predelay=%0d (target: IP TAP %s, IR register)",
                        CltapTap.name(), IrWidthFinal, IrChainValue1,
		        (DrWidthFinal-PreDelay), DrChainValue1, PreDelay, TapOfInterestInternal.name()), UVM_LOW);

            if((ENDEBUG_OWN === 1) && 
               (FuseDisable === 1'b0) && 
               (IrChainValue1 > Endebug_Cltap_End_Address) && 
               (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0) && 
               (Endebug_Enable_Tapnw_0_Tlink_1 === 1'b1)) begin 
                  Endebug_TapLink_Access(
                               .ResetMode       (NO_RST),
                               .Address         (IrChainValue1), 
                               .addr_len        (IrWidthFinal),
                               .Data            (DrChainValue1),
                               .ReturnTdoQualifier (ReturnTdoQualifier),
                               .Expected_Data   ('0),
                               .Mask_Data       ('0), 
                               .data_len        (DrWidthFinal),
                               .tdo_data        (TDOData),
                               .LongEndebugTAPFSMPath (LongEndebugTAPFSMPath),
                               .tdo_data_chopped(TempTDOData)                               
                              ); 
            end
            else
            begin
          	call_bfm_driver_apis(
          	   IrWidthFinal,
          	   DrWidthFinal,
          	   IrChainValue1,
          	   DrChainValue1,
          	   0,                     // CompareValue1
          	   0,                     // MaskValue1
          	   ReturnTdoQualifier,    // ReturnTdoQualifier
          	   0,                     // Mask
          	   0,                     // InputDrData
          	   CltapTap,              // TapOfInterest = CLTAP
          	   TDOData,
               TempTDOData
          	);
            end
          `uvm_info (get_type_name(), $psprintf("JTAGBFM: Completed access: TAP %s, Opcode %0d'h0%0h, Inp Data %0d'h0%0h (target: IP TAP %s, IR register)",
                        CltapTap.name(), IrWidthFinal, IrChainValue1, DrWidthFinal, DrChainValue1, TapOfInterestInternal.name()), UVM_NONE);

          	`dbg_display("0. MYDBG Exited AccessTargetReg  for     entry%0d     at time = %t, TAP=%s, IR=%0h, DR=%0h",
		    entry, $time, CltapTap.name(), IrChainValue1, DrChainValue1);
          `dbg_display("1. MYDBG TAP %s: returned TDO data: %d'h0%0h",
         CltapTap.name(), DrWidthFinal, TempTDOData);

          	IrWidthFinal  = Get_IR_Width(CltapTap);
          	IrChainValue1 = Get_LBA(TapOfInterestInternal) + 1;
          	DrWidthFinal  = ArrayOfHistoryElements[TapOfInterestInternal].DataWidthForMultiTapAccess;
          	DrChainValue1 = ArrayOfHistoryElements[TapOfInterestInternal].DataForMultiTapAccess;
          	CompareValue1 = ArrayOfHistoryElements[TapOfInterestInternal].CompareValueForMultiTapAccess;
          	MaskValue1    = ArrayOfHistoryElements[TapOfInterestInternal].CompareMaskForMultiTapAccess;

		PreDelay  = Get_Pre_Delay(CltapTap,IrChainValue1);
		PostDelay = Get_Post_Delay(CltapTap,IrChainValue1);

      ArrayOfHistoryElements[TapOfInterestInternal].ReturnedTapTdoData = '0;

          	`dbg_display ("debug 22 : IrWidthFinal  = %0d", IrWidthFinal);
          	`dbg_display ("debug 23 : IrChainValue1 = %0h", IrChainValue1);
          	`dbg_display ("debug 24 : DrWidthFinal  = %0d", DrWidthFinal);
          	`dbg_display ("debug 25 : DrChainValue1 = %0h", DrChainValue1);

          	ReturnTdoQualifier = '0;
		for (int j=0; j<DrWidthFinal; j++) begin
             	  ReturnTdoQualifier[j] = 1;
          	end

  cmp_mask_chopped = '0;
		for (int ii=0; ii < DrWidthFinal; ii++)
        cmp_mask_chopped[ii] = MaskValue1[ii];

          `uvm_info (get_type_name(), $psprintf("JTAGBFM: Final access info: TAP %s, Opcode %0d'h0%0h, Inp Data %0d'h0%0h with predelay=%0d/postdelay=%0d, Exp Data 'h0%0h, Exp Mask 'h0%0h (target IP TAP %s, selected DR register)",
                        CltapTap.name(), IrWidthFinal, IrChainValue1,
		        DrWidthFinal, DrChainValue1, PreDelay, PostDelay, CompareValue1, cmp_mask_chopped, TapOfInterestInternal.name()), UVM_LOW);

            if((ENDEBUG_OWN === 1) && 
               (FuseDisable === 1'b0) && 
               (IrChainValue1 > Endebug_Cltap_End_Address) && 
               (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0) && 
               (Endebug_Enable_Tapnw_0_Tlink_1 === 1'b1)) begin 
                  Endebug_TapLink_Access(
                               .ResetMode       (NO_RST),
                               .Address         (IrChainValue1), 
                               .addr_len        (IrWidthFinal),
                               .Data            (DrChainValue1      << PostDelay),
                               .ReturnTdoQualifier (ReturnTdoQualifier << PostDelay),
                               .Expected_Data   (CompareValue1      << PostDelay),
                               .Mask_Data       (MaskValue1         << PostDelay), 
                               .data_len        (DrWidthFinal + PreDelay + PostDelay),
                               .tdo_data        (TDOData),
                               .LongEndebugTAPFSMPath (LongEndebugTAPFSMPath),
                               .tdo_data_chopped(ArrayOfHistoryElements[TapOfInterestInternal].ReturnedTapTdoData)                               
                              ); 
            end
            else
            begin
          	call_bfm_driver_apis(
          	   IrWidthFinal,
             (DrWidthFinal + PreDelay + PostDelay),
          	   IrChainValue1,
          	   DrChainValue1      << PostDelay,
          	   CompareValue1      << PostDelay,
          	   MaskValue1         << PostDelay, 
          	   ReturnTdoQualifier << PostDelay,
          	   0,
          	   0,
          	   TapOfInterestInternal, //TapOfInterest,
          	   TDOData,
               ArrayOfHistoryElements[TapOfInterestInternal].ReturnedTapTdoData
                );
            end
          `uvm_info (get_type_name(), $psprintf("JTAGBFM: Completed access: TAP %s, Opcode %0d'h0%0h, Inp Data %0d'h0%0h (target: IP TAP %s, selected DR reggister)",
                        CltapTap.name(), IrWidthFinal, IrChainValue1, DrWidthFinal, DrChainValue1, TapOfInterestInternal.name()), UVM_NONE);
          `uvm_info (get_type_name(), $psprintf("JTAGBFM: Exp Data %0d'h0%0h, Actual TDO %0d'h0%0h, Exp Mask %0d'h0%0h",
		        DrWidthFinal, CompareValue1, DrWidthFinal, ArrayOfHistoryElements[TapOfInterestInternal].ReturnedTapTdoData, DrWidthFinal, cmp_mask_chopped), UVM_NONE);

                `dbg_display("0. MYDBG Exited AccessTargetReg  for     entry%0d 	at time = %t, TAP=%s, IR=%0h, DR=%0h", 
		   entry, $time, TapOfInterestInternal.name(), IrChainValue1, DrChainValue1);
    `dbg_display("1. MYDBG TAP %s: returned TDO data: %d'h0%0h",
	         TapOfInterestInternal.name(), DrWidthFinal, ArrayOfHistoryElements[TapOfInterestInternal].ReturnedTapTdoData);

	     end // IP TAP

	     TDODataChopped = ArrayOfHistoryElements[TapOfInterestInternal].ReturnedTapTdoData;
	     DisableTap (TapOfInterestInternal);

          end // for

          if (MultiTapAccessSelected == 1) begin
             `uvm_info (get_type_name(), "JTAGBFM: Completed Multi-TAP Access", UVM_NONE);
	  end
	  else begin
             `uvm_info (get_type_name(), "JTAGBFM: Completed TAP Access", UVM_NONE);
          end

	  MultiTapAccess.delete();
          MultiTapAccessSelected = 0;
          MultiLaunchPrimary     = 0;

      `endif

`ifndef JTAG_BFM_TAPLINK_MODE
       end // } 
`endif

    end // for Task Begin
    endtask : AccessTargetReg
    
   // ----------------------------------------------------------------
   // 05-Mar-2015 https://hsdes.intel.com/home/default.html#article?id=1404045114
   // JTAG BFM issue with parallel multi-tap accesses on different ports at the same time
   // Created a new task to make the argument construction to this task happen in AccessTargetReg in zero time so that parallelism can be enabled.
   // ----------------------------------------------------------------
   task call_bfm_driver_apis (
               input int   IrWidthFinal,
               input int   DrWidthFinal,
               input [API_SIZE_OF_IR_REG-1:0]     IrChainValue1,
               input [WIDTH_OF_EACH_REGISTER-1:0] DrChainValue1,
               input [WIDTH_OF_EACH_REGISTER-1:0] CompareValue1,
               input [WIDTH_OF_EACH_REGISTER-1:0] MaskValue1, 
               input [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdoQualifier,
               input bit   [WIDTH_OF_EACH_REGISTER-1:0] Mask = 0,
               input bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData = 0,
               input Tap_t                        TapOfInterestInternal,
               output bit  [WIDTH_OF_EACH_REGISTER-1:0] TDOData,
               output bit  [WIDTH_OF_EACH_REGISTER-1:0] TDODataChopped);
    begin
       bit  [WIDTH_OF_EACH_REGISTER-1:0] InternalTDOData;
       bit  [WIDTH_OF_EACH_REGISTER-1:0] InternalTDOData_CLTAP;
       bit  [WIDTH_OF_EACH_REGISTER-1:0] TdoDataAndQualifier;
       bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped_temp1;
       bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped_temp2;
       bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped_temp3;
       bit  [API_SIZE_OF_IR_REG-1:0]     IrChainValue1_CLTAP;
       bit  [WIDTH_OF_EACH_REGISTER-1:0] DrChainValue1_CLTAP;
       bit  [WIDTH_OF_EACH_REGISTER-1:0] CompareValue1_CLTAP;
       bit  [WIDTH_OF_EACH_REGISTER-1:0] MaskValue1_CLTAP;
       int  Count;
       int   IrWidthFinal_CLTAP;
       int   IrWidthFinal_OnlySTAPs;
       int   DrWidthFinal_CLTAP;
       int   DrWidthFinal_OnlySTAPs;
       static int entry2_=0; 

          entry2_++;
       `ifndef JTAG_BFM_TAPLINK_MODE
          if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (TapOfInterestInternal == Tap_t'(0)) ) 
          begin
             IrChainValue1_previous = 'h0;
             PreviousTapAccess      = Tap_t'(0);
             IsSameTapAccessed      = 0;
             IrWidthFinal_CLTAP     = Get_IR_Width(Tap_t'(0));
             IrWidthFinal_OnlySTAPs = IrWidthFinal - IrWidthFinal_CLTAP;
             IrChainValue1_CLTAP    = IrChainValue1 >> IrWidthFinal_OnlySTAPs;
             DrWidthFinal_CLTAP     = InputDrWidthInternal_CLTAP;
             DrWidthFinal_OnlySTAPs = DrWidthFinal-DrWidthFinal_CLTAP;
             DrChainValue1_CLTAP    = DrChainValue1>>DrWidthFinal_OnlySTAPs;
             CompareValue1_CLTAP    = CompareValue1>>DrWidthFinal_OnlySTAPs;
             MaskValue1_CLTAP       = MaskValue1>>DrWidthFinal_OnlySTAPs;
             ReturnTDO_ExpData_MultipleTapRegisterAccessRuti(
                NO_RST,
                IrChainValue1_CLTAP,
                IrWidthFinal_CLTAP,
                DrChainValue1_CLTAP,
                CompareValue1_CLTAP,
                MaskValue1_CLTAP,
                DrWidthFinal_CLTAP,
                InternalTDOData_CLTAP);           
              
             TDOData = InternalTDOData_CLTAP;
             TDODataChopped = InternalTDOData_CLTAP;
          end
          else
          begin
       `endif
             // HSD_5075802 - Optimizing the IR path 
             if ((IrChainValue1_previous != IrChainValue1) ||
                 (PreviousTapAccess != TapOfInterestInternal) ||
                 (IsSameTapAccessed == 0)) begin
                if (ReadModifyWriteEnabled == 0) begin
                   if (ShortLongFsmPaths == 0) begin
                      ReturnTDO_ExpData_MultipleTapRegisterAccessRuti(
                         NO_RST,
                         IrChainValue1,
                         IrWidthFinal,
                         DrChainValue1,
                         CompareValue1,
                         MaskValue1,
                         DrWidthFinal,
                         InternalTDOData);
                   end
                   else if (ShortLongFsmPaths == 1) begin
                      ReturnTDO_ExpData_MultipleTapRegisterAccess(
                         NO_RST,
                         IrChainValue1,
                         IrWidthFinal,
                         DrChainValue1,
                         CompareValue1,
                         MaskValue1,
                         DrWidthFinal,
                         InternalTDOData);
                      Goto(UPDR,1); 
                      Goto(RUTI,1); // Went back and forth on this from 11 to 1 to 5 to 1.
                   end
                end
                else if (ReadModifyWriteEnabled == 1) begin
                   LoadIR (NO_RST, IrChainValue1, 0, 0, IrWidthFinal);
                   Goto(RUTI,1);
                   LoadDrWithReturnTdoEndStatePause(
                      NO_RST,
                      DrChainValue1,
                      0,
                      0,
                      DrWidthFinal,
                      InternalTDOData);
                end  
             end
             else if (IrChainValue1_previous == IrChainValue1) begin
                if (ReadModifyWriteEnabled == 0) begin
                   if (ShortLongFsmPaths == 0) begin
                      LoadDrWithReturnTdoShortPath(
                         NO_RST,
                         DrChainValue1,
                         CompareValue1,
                         MaskValue1,
                         DrWidthFinal,
                         InternalTDOData);
                   end  
                   else if (ShortLongFsmPaths == 1) begin
                      LoadDrWithReturnTdo(
                         NO_RST,
                         DrChainValue1,
                         CompareValue1,
                         MaskValue1,
                         DrWidthFinal,
                         InternalTDOData);
                   end  
                end  
                else if (ReadModifyWriteEnabled == 1) begin
                   LoadDrWithReturnTdoEndStatePause(
                      NO_RST,
                      DrChainValue1,
                      0,
                      0,
                      DrWidthFinal,
                      InternalTDOData);
                end  
             end  

             TDOData = InternalTDOData;
             `dbg_display ("InternalTDOData = %0h", InternalTDOData);

             TdoDataAndQualifier = InternalTDOData & ReturnTdoQualifier;
             `dbg_display ("TdoDataAndQualifier = %0h", TdoDataAndQualifier);

             Count = 0;
             while (ReturnTdoQualifier[0] == 0) begin
                TdoDataAndQualifier = (TdoDataAndQualifier >> 1);
                ReturnTdoQualifier = (ReturnTdoQualifier >> 1);
                `dbg_display ("while TdoDataAndQualifier = %0h", TdoDataAndQualifier);
                `dbg_display ("while ReturnTdoQualifier  = %0h", ReturnTdoQualifier);
                Count++;
             end

             TDODataChopped = TdoDataAndQualifier;
             `dbg_display ("ReturnTdoQualifier = %0h", ReturnTdoQualifier);
             `dbg_display ("TdoDataAndQualifier = %0h", TdoDataAndQualifier);
             `dbg_display ("IrChainValue1_previous = %0h", IrChainValue1_previous);
             `dbg_display ("TDODataChopped = %0h", TDODataChopped);

             IrChainValue1_previous = IrChainValue1;
             PreviousTapAccess = TapOfInterestInternal;
             `dbg_display ("HSD_5075802 PreviousTapAccess = %0d", PreviousTapAccess);
             `dbg_display ("HSD_5075802 TapOfInterestInternal = %0d", TapOfInterestInternal);

             if (ReadModifyWriteEnabled == 1) begin
                `dbg_display ("ReadModifyWrite selected");
                tdo_data_chopped_temp1 = 0;
                `dbg_display ("tdo_data_chopped_temp1 = %0h", tdo_data_chopped_temp1);
                tdo_data_chopped_temp1 = (~Mask) & TDODataChopped;
                `dbg_display ("tdo_data_chopped_temp1 = %0h", tdo_data_chopped_temp1);
                tdo_data_chopped_temp2 = 0;
                `dbg_display ("tdo_data_chopped_temp2 = %0h", tdo_data_chopped_temp2);
                tdo_data_chopped_temp2 = Mask & InputDrData;
                `dbg_display ("tdo_data_chopped_temp2 = %0h", tdo_data_chopped_temp2);
                tdo_data_chopped_temp3 = tdo_data_chopped_temp1 | tdo_data_chopped_temp2;
                `dbg_display ("tdo_data_chopped_temp3 = %0h", tdo_data_chopped_temp3);

                
                while (Count > 0) begin
                   tdo_data_chopped_temp3 = (tdo_data_chopped_temp3 << 1);
                   Count--;
                end

                LoadDrWithReturnTdo(
                   NO_RST,
                   tdo_data_chopped_temp3,
                   CompareValue1,
                   0,
                   DrWidthFinal,
                   InternalTDOData);
             end

             Goto(RUTI,1); // Went back and forth on this from 11 to 1 to 5 to 1.
             `dbg_display("\nTDOData : %0h, TDOData expected: %0h", TDOData, CompareValue1);

             for (int i=0; i<NUMBER_OF_TAPS; i++) begin
                `dbg_display("AccessTargetReg ArrayOfHistoryElements[%0d].PreviousAccessedIr = %0h",
                   i, ArrayOfHistoryElements[i].PreviousAccessedIr);
             end
       `ifndef JTAG_BFM_TAPLINK_MODE
          end
       `endif
       end
       //`dbg_display("0. MYDBG Exiting call_bfm_driver_apis for     entry2_%0d     at time = %t, IR=%0h, DR=%0h", entry2_, $time, IrChainValue1, DrChainValue1);
    endtask : call_bfm_driver_apis 

    // ----------------------------------------------------------------
    // This will retrun the position of the given
    // TAP from the TAP LUT
    // ----------------------------------------------------------------
    function int Get_Tap_Index (input Tap_t Tap_Val);
    begin
       int index;
       int temp_q[$];
       temp_q = TapRegModel.Tap_Info_q.find_index() with
                (item.Tap == Tap_Val);
       if (temp_q.size() != 0) begin
          index = temp_q.pop_back();
       end
       else
          `uvm_fatal("",$psprintf("%0s TAP NOT FOUND. Check if the Network Info is generated correctly.", Tap_Val));
       return index;
    end
    endfunction : Get_Tap_Index

    // ----------------------------------------------------------------
    // This retrun the position of the given
    // TAP from the TAP LUT
    // ----------------------------------------------------------------
    function int Get_Tap_SlvIDcode (input Tap_t Tap_Val);
    begin
       int IndexInt;
       int slvidcode;
       IndexInt  = Get_Tap_Index(Tap_Val);

       if (ArrayOfHistoryElements[Tap_Val].IsVendorTap == 1) begin 
          slvidcode = TapRegModel.Tap_Info_q[IndexInt].VendorIDcode; 
       end
       else begin
          slvidcode = TapRegModel.Tap_Info_q[IndexInt].SlvIDcode; 
       end  
       return slvidcode;
    end
    endfunction : Get_Tap_SlvIDcode

    function bit [API_SIZE_OF_IR_REG-1:0] Get_Tap_IDcodeOpcode (input Tap_t Tap_Val);
    begin
       int IndexInt;
       int slvidcode;
       bit [API_SIZE_OF_IR_REG-1:0] VendorIdOpcode;
       IndexInt  = Get_Tap_Index(Tap_Val);

       VendorIdOpcode = TapRegModel.Tap_Info_q[IndexInt].VendorIdOpcode; 

       return VendorIdOpcode;
    end
    endfunction : Get_Tap_IDcodeOpcode

    // ----------------------------------------------------------------
    // This will retrun the Node of the given TAP
    // ----------------------------------------------------------------
    function Tap_t Get_Tap_Node (input Tap_t Tap_Val);
    begin
      int flag0; // Indication that Parent found
      Tap_t Node_Temp;
      Node_Temp = Tap_Val;
      `dbg_display(": Node_Temp = Tap_Val = %0d",Node_Temp);
      while (Node_Temp != 0) begin//CLTAP   
         for (int i =0; i < NUMBER_OF_STAPS; i++) begin
            `dbg_display(": TapRegModel.Tap_Info_q [%0d].Next_Tap.size() = %0d",i,TapRegModel.Tap_Info_q[i].Next_Tap.size());
            for (int j = 0; j < TapRegModel.Tap_Info_q[i].Next_Tap.size(); j++) begin
               `dbg_display(": Node_Temp =   Tap_Val    = %0d",Node_Temp);
               `dbg_display(": TapRegModel.Tap_Info_q[%0d].Next_Tap[%0d]     = %0s",i,j,TapRegModel.Tap_Info_q[i].Next_Tap[j]);
               if(TapRegModel.Tap_Info_q[i].Next_Tap[j] == Node_Temp) begin
                  Node_Temp = TapRegModel.Tap_Info_q[i].Tap;
                  flag0 = 1;
                  `dbg_display(": TapRegModel.Tap_Info_q  [%0d].Tap = %0s",i,TapRegModel.Tap_Info_q[i].Tap);
                  `dbg_display(": TapRegModel.Tap_Info_q.Tap  Node_Temp = %0d",Node_Temp);
                  `dbg_display(": break for j");
                  break;
               end
            end
            if (flag0 == 1) begin
               `dbg_display(": break for i");
               break;
            end      
         end
         if (flag0 == 1) begin
            `dbg_display(": break while");
            break;
         end      
         // HSD_5189790 - JTAG BFM becomes trapped in an infinite loop if any node information is missing from JtagBfmSoCTapNetworkInfo.svh
         else if (flag0 == 0) begin
            `dbg_display("TAP Not Found");
            `uvm_fatal("",$psprintf("%0s TAP NOT FOUND. Check if the Network Info is generated correctly.", Tap_Val));
         end   
      end
      return Node_Temp;
    end
    endfunction : Get_Tap_Node

    // ----------------------------------------------------------------
    // Get_Reg_Index will retrun the position of the given 
    // Register (IR) from the Reg Model
    // ----------------------------------------------------------------
    function int Get_Reg_Index (input Tap_t Tap_Val,
                                input logic [WIDTH_OF_EACH_REGISTER-1:0]Reg_Val);
    begin
       int index;
       int temp_q[$];
       temp_q = TapRegModel.Reg_Model.find_index() with
          (item.Tap_ID == Tap_Val && item.Opcode == Reg_Val);
       if (temp_q.size() != 0) begin
          index = temp_q.pop_back();
       end
       return index;
    end
    endfunction : Get_Reg_Index

    // ----------------------------------------------------------------
    // Get_IR_Width will retrun IR_Width of the given Tap 
    // ----------------------------------------------------------------
    function int Get_IR_Width (input Tap_t Tap_Val);
    begin
       int IndexInt;
       int IR_Width;
       IndexInt = Get_Tap_Index(Tap_Val);
       IR_Width = TapRegModel.Tap_Info_q[IndexInt].IR_Width; 

       return IR_Width;
    end
    endfunction : Get_IR_Width

    `ifdef JTAG_BFM_TAPLINK_MODE
    // ----------------------------------------------------------------
    // Get_LBA will retrun LBA of the given Tap 
    // ----------------------------------------------------------------
    function bit [31:0] Get_LBA (input Tap_t Tap_Val);
    begin
       int IndexInt;
       bit [31:0] LBA;
       IndexInt = Get_Tap_Index(Tap_Val);
       LBA = TapRegModel.Tap_Info_q[IndexInt].LBA; 
       `dbg_display ("LBA of %0s = %0h", Tap_Val, LBA);

       return LBA;
    end
    endfunction : Get_LBA

    // ----------------------------------------------------------------
    // Tap_with_LBA_exists retruns 1 if Tap with specified LBA exists
    // ----------------------------------------------------------------
    function bit Tap_with_LBA_exists (input bit [31:0] LBA);
    begin
       Tap_t Tap;
       if (TapRegModel.TapLink_LBA_map.exists(LBA)) begin
         Tap = TapRegModel.TapLink_LBA_map[LBA];
         `dbg_display ("LBA 0x%0h belongs to TAP %s", LBA, Tap);
          return 1;
       end
       else
          return 0;
    end
    endfunction : Tap_with_LBA_exists

    // ----------------------------------------------------------------
    // Tap_with_GBA_exists retruns 1 if Tap with specified GBA exists
    // ----------------------------------------------------------------
    function bit Tap_with_GBA_exists (input bit [31:0] GBA);
    begin
       Tap_t Tap;
       if (TapRegModel.TapLink_GBA_map.exists(GBA)) begin
         Tap = TapRegModel.TapLink_GBA_map[GBA];
         `dbg_display ("GBA 0x%0h belongs to TAP %s", GBA, Tap);
          return 1;
       end
       else
          return 0;
    end
    endfunction : Tap_with_GBA_exists
    // ---------------------------------------------------------------
    // Get_Pre_Delay will retrun pre-delay of the given Tap and Register in TapLink netwrok
    // ---------------------------------------------------------------
    function int Get_Pre_Delay (input Tap_t Tap_Val,
                               input logic [WIDTH_OF_EACH_REGISTER-1:0]Reg_Val);
    begin
       int predelay;
       int IndexInt;
       IndexInt = Get_Reg_Index(Tap_Val, Reg_Val);
       predelay = TapRegModel.Reg_Model[IndexInt].predelay; 

       `dbg_display(": predelay = %0d", predelay);
       `dbg_display(": Reg_Val = %0h", Reg_Val);
       `dbg_display(": Tap_Val = %0s", Tap_Val);

       return predelay;
    end
    endfunction : Get_Pre_Delay

    // ---------------------------------------------------------------
    // Get_Post_Delay will retrun post-delay of the given Tap and Register in TapLink netwrok
    // ---------------------------------------------------------------
    function int Get_Post_Delay (input Tap_t Tap_Val,
                               input logic [WIDTH_OF_EACH_REGISTER-1:0]Reg_Val);
    begin
       int postdelay;
       int IndexInt;
       IndexInt = Get_Reg_Index(Tap_Val, Reg_Val);
       postdelay = TapRegModel.Reg_Model[IndexInt].postdelay; 

       `dbg_display(": postdelay = %0d", postdelay);
       `dbg_display(": Reg_Val = %0h", Reg_Val);
       `dbg_display(": Tap_Val = %0s", Tap_Val);

       return postdelay;
    end
    endfunction : Get_Post_Delay

    // ---------------------------------------------------------------
    // Is_TapLink_Access will retrun 1 if this is CLTAP access to TapLink Opcode
    // ---------------------------------------------------------------
    function int Is_TapLink_Access (input Tap_t Tap_Val,
                               input logic [WIDTH_OF_EACH_REGISTER-1:0]Reg_Val);
    begin
       int is_taplink_access;
       int IndexInt;
       IndexInt = Get_Reg_Index(Tap_Val, Reg_Val);
       is_taplink_access = TapRegModel.Reg_Model[IndexInt].isTapLinkOpcode; 

       `dbg_display(": Is_TapLink_Access = %0d",is_taplink_access );
       `dbg_display(": Reg_Val = %0h", Reg_Val);
       `dbg_display(": Tap_Val = %0s", Tap_Val);

       return is_taplink_access;
    end
    endfunction : Is_TapLink_Access

    `endif

    // ---------------------------------------------------------------
    // Get_DR_Width will retrun DR_Width of the given Tap and Register
    // ---------------------------------------------------------------
    function int Get_DR_Width (input Tap_t Tap_Val,
                               input logic [WIDTH_OF_EACH_REGISTER-1:0]Reg_Val);
    begin
       int DR_Width;
       int IndexInt;
       IndexInt = Get_Reg_Index(Tap_Val, Reg_Val);
       DR_Width = TapRegModel.Reg_Model[IndexInt].DR_Width; 

       if (DR_Width == 0) begin
          `uvm_error("",$psprintf("DR_Width of \"%0s.%0h\" should be non-zero", Tap_Val, Reg_Val));
          global_stop_request();
       end

       `dbg_display(": DR_Width = %0d", DR_Width);
       `dbg_display(": Reg_Val = %0h", Reg_Val);
       `dbg_display(": Tap_Val = %0s", Tap_Val);

       return DR_Width;
    end
    endfunction : Get_DR_Width

    task PutTapOnSecondary (input Tap_t Tap);
    begin //{
      logic [API_SIZE_OF_IR_REG-1:0]     RegisterInt   = 'h10;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] expected_data = 0;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] compare_mask  = 0;
      bit                                en_user_defined_dr_length = 0;
      bit                                En_RegisterPresenceCheck = 1;
      int                                InputDrWidth;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData;
      Tap_t                              TapOfInterestInternal;
      int                                PostionOfTapInTapcSelRegLocal;
      Tap_t                              ParentOfTapOfInterestInternal;
 `ifndef JTAGBFM_EN_DFTB_HTAP
    `ifdef JTAG_BFM_TAPLINK_MODE
      `uvm_fatal(get_name(),"Task PutTapOnSecondary() cannot be used - Secondary Port is not available in TapLink")
    `endif

      //Check whether Tap of interest exists in the network.
      GetTapAvailableStatus (Tap);

      //If Tap of interest enum type exists in a given network then
      //proceed with enable and access operation.
      if (TapExistFlag == 1) begin //{

         //Enable Tap of interest before accessing any opcode.
         EnableTap (Tap);

         if (ArrayOfHistoryElements[Tap].NodeQueue.size > 1) begin //{
            TapOfInterestInternal = ArrayOfHistoryElements[Tap].NodeQueue[1]; // 0th entry is always CLTAP
         end //}
         else if (ArrayOfHistoryElements[Tap].NodeQueue.size == 1) begin //{
            TapOfInterestInternal = Tap; // For TAP's on 1st level hierarchy.
         end //}

         InputDrData = 0;
         `dbg_display("TapOfInterestInternal = %0s", TapOfInterestInternal);
         `dbg_display("0 InputDrData = %0h", InputDrData);
         ParentOfTapOfInterestInternal = ArrayOfHistoryElements[TapOfInterestInternal].ParentTap;
         `dbg_display("ParentOfTapOfInterestInternal = %0s", ParentOfTapOfInterestInternal);
         PostionOfTapInTapcSelRegLocal = ArrayOfHistoryElements[TapOfInterestInternal].PostionOfTapInTapcSelReg;
         `dbg_display("PostionOfTapInTapcSelRegLocal = %0d", PostionOfTapInTapcSelRegLocal);
         InputDrData[PostionOfTapInTapcSelRegLocal] = 1'b1;
         `dbg_display("1 InputDrData = %0h", InputDrData);
         InputDrData = InputDrData | ArrayOfHistoryElements[ParentOfTapOfInterestInternal].TapSecondarySelect;
         `dbg_display("2 InputDrData = %0h", InputDrData);
         ArrayOfHistoryElements[ParentOfTapOfInterestInternal].TapSecondarySelect = InputDrData;
         `dbg_display("ArrayOfHistoryElements[%0s].TapSecondarySelect = %0h", ParentOfTapOfInterestInternal,
            ArrayOfHistoryElements[ParentOfTapOfInterestInternal].TapSecondarySelect);

         AccessTargetReg(
            .TapOfInterest           (ParentOfTapOfInterestInternal),
            .Opcode                  (RegisterInt),
            .InputDrWidth            (InputDrWidth),
            .InputDrData             (InputDrData),
            .ExpectedData            (expected_data),
            .Mask                    (compare_mask),
            .EnRegisterPresenceCheck (En_RegisterPresenceCheck),
            .EnUserDefinedDRLength   (en_user_defined_dr_length),
            .TDOData                 (tdo_data),
            .TDODataChopped          (tdo_data_chopped));

         ArrayOfHistoryElements[TapOfInterestInternal].IsTapOnSecondary = 1;
         ArrayOfHistoryElements[TapOfInterestInternal].IsTapOnPrimary   = 0;
         ArrayOfHistoryElements[TapOfInterestInternal].IsTapOnTertiaryForAllPorts = 0; 


         for (int i=0; i<NUMBER_OF_TAPS; i++) begin //{
            if (ArrayOfHistoryElements[TapOfInterestInternal].ChildTapsArray[i] == 1) begin //{
               ArrayOfHistoryElements[i].IsTapOnSecondary = 1;
               ArrayOfHistoryElements[i].IsTapOnPrimary   = 0;
               ArrayOfHistoryElements[i].IsTapOnTertiaryForAllPorts = 0; 
               //Moved below code from outside the loop
               for (int j=0; j<NUMBER_OF_TERTIARY_PORTS; j++) begin
                  ArrayOfHistoryElements[TapOfInterestInternal].IsTapOnTertiary[j] = 0;
               end
            end //} 
         end //}

         for (int i=0; i<NUMBER_OF_TAPS; i++) begin //{
            `dbg_display("ArrayOfHistoryElements[%0d].IsTapOnSecondary = %0d", i, ArrayOfHistoryElements[i].IsTapOnSecondary);
            `dbg_display("ArrayOfHistoryElements[%0d].IsTapOnPrimary   = %0d", i, ArrayOfHistoryElements[i].IsTapOnPrimary);
            `dbg_display("ArrayOfHistoryElements[%0d].IsTapOnTertiaryForAllPorts = %0d", i, ArrayOfHistoryElements[i].IsTapOnTertiaryForAllPorts);
         end //}
      end //}
      `dbg_display("PutTapOnSecondary : RUTI ");
      Goto(RUTI,1);

`endif
      end //}
    endtask : PutTapOnSecondary

    task PutTapOnTertiary (input Tap_t Tap);
    begin //{
      logic [API_SIZE_OF_IR_REG-1:0]     RegisterInt   = 'h10;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] expected_data = 0;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] compare_mask  = 0;
      bit                                en_user_defined_dr_length = 0;
      bit                                En_RegisterPresenceCheck = 1;
      int                                InputDrWidth;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData;
      Tap_t                              TapOfInterestInternal;
      int                                PostionOfTapInTapcSelRegLocal;
      Tap_t                              ParentOfTapOfInterestInternal;
      int                                index_into_terport;
`ifndef JTAGBFM_EN_DFTB_HTAP
    `ifdef JTAG_BFM_TAPLINK_MODE
      `uvm_fatal(get_name(),"Task PutTapOnTertiary() cannot be used - Tertiary Port is not available in TapLink")
    `endif

      `dbg_display("PutTapOnTertiary_Debug_1");
      //Check whether Tap of interest exists in the network.
      GetTapAvailableStatus (Tap);

      //If Tap of interest enum type exists in a given network then
      //proceed with enable and access operation.
      `dbg_display("PutTapOnTertiary_Debug_2");
      if (TapExistFlag == 1) begin //{

         //Enable Tap of interest before accessing any opcode.
         EnableTap (Tap);

         `dbg_display("PutTapOnTertiary_Debug_3");
         InputDrData = 0;

         TapOfInterestInternal = GetNearestTapThatHostsTertiaryPort(Tap); // For TAP's on 1st level hierarchy.
         //TapOfInterestInternal = STAP14; // For TAP's on 1st level hierarchy.
         `dbg_display("TapOfInterestInternal = %0s", TapOfInterestInternal);
         `dbg_display("0 InputDrData = %0h", InputDrData);
         ParentOfTapOfInterestInternal = ArrayOfHistoryElements[TapOfInterestInternal].ParentTap;
         `dbg_display("ParentOfTapOfInterestInternal = %0s", ParentOfTapOfInterestInternal);
         PostionOfTapInTapcSelRegLocal = ArrayOfHistoryElements[TapOfInterestInternal].PostionOfTapInTapcSelReg;
         `dbg_display("PostionOfTapInTapcSelRegLocal = %0d", PostionOfTapInTapcSelRegLocal);
         InputDrData[PostionOfTapInTapcSelRegLocal] = 1'b1;
         `dbg_display("1 InputDrData = %0h", InputDrData);
         InputDrData = InputDrData | ArrayOfHistoryElements[ParentOfTapOfInterestInternal].TapSecondarySelect;
         `dbg_display("2 InputDrData = %0h", InputDrData);
         ArrayOfHistoryElements[ParentOfTapOfInterestInternal].TapSecondarySelect = InputDrData;
         `dbg_display("ArrayOfHistoryElements[%0s].TapSecondarySelect = %0h", ParentOfTapOfInterestInternal,
            ArrayOfHistoryElements[ParentOfTapOfInterestInternal].TapSecondarySelect);

         AccessTargetReg(
            .TapOfInterest           (ParentOfTapOfInterestInternal),
            .Opcode                  (RegisterInt),
            .InputDrWidth            (InputDrWidth),
            .InputDrData             (InputDrData),
            .ExpectedData            (expected_data),
            .Mask                    (compare_mask),
            .EnRegisterPresenceCheck (En_RegisterPresenceCheck),
            .EnUserDefinedDRLength   (en_user_defined_dr_length),
            .TDOData                 (tdo_data),
            .TDODataChopped          (tdo_data_chopped));

         //ArrayOfHistoryElements[TapOfInterestInternal].IsTapOnSecondary = 1;
         for (int i=0; i<NUMBER_OF_TERTIARY_PORTS; i++) begin //{
            `dbg_display("DebugTer TertiaryPortNumbering[%0d] = %0s", i, Tap_t'(TertiaryPortNumbering[i]));
            `dbg_display("DebugTer ParentOfTapOfInterestInternal = %0s", ParentOfTapOfInterestInternal);
            if (ParentOfTapOfInterestInternal == Tap_t'(TertiaryPortNumbering[i])) begin
               ArrayOfHistoryElements[TapOfInterestInternal].IsTapOnTertiary[i] = 1;
               index_into_terport = i;
            end
            else begin
               ArrayOfHistoryElements[TapOfInterestInternal].IsTapOnTertiary[i] = 0;
            end   
            ArrayOfHistoryElements[TapOfInterestInternal].IsTapOnSecondary = 0;
            ArrayOfHistoryElements[TapOfInterestInternal].IsTapOnPrimary   = 0;
            ArrayOfHistoryElements[TapOfInterestInternal].IsTapOnTertiaryForAllPorts = 1; 
            `dbg_display("DebugTer ArrayOfHistoryElements[%0s].IsTapOnTertiary[%0d] = %0b", 
               TapOfInterestInternal, i, ArrayOfHistoryElements[TapOfInterestInternal].IsTapOnTertiary[i]);
         end

         for (int i=0; i<NUMBER_OF_TAPS; i++) begin //{
            if (ArrayOfHistoryElements[TapOfInterestInternal].ChildTapsArray[i] == 1) begin //{
               ArrayOfHistoryElements[i].IsTapOnTertiaryForAllPorts           = 1; 
               ArrayOfHistoryElements[i].IsTapOnTertiary[index_into_terport]  = 1;
               ArrayOfHistoryElements[i].IsTapOnSecondary = 0;
               ArrayOfHistoryElements[i].IsTapOnPrimary   = 0;
               `dbg_display("DebugTer1 ArrayOfHistoryElements[%0d].IsTapOnTertiary[%0d] = %0b", Tap_t'(i), index_into_terport, ArrayOfHistoryElements[i].IsTapOnTertiary[index_into_terport]);
            end //} 
         end //}

         for (int i=0; i<NUMBER_OF_TAPS; i++) begin //{
            `dbg_display("ArrayOfHistoryElements[%0d].IsTapOnSecondary = %0d", i, ArrayOfHistoryElements[i].IsTapOnSecondary);
         end //}
      end //}
      `dbg_display("PutTapOnTertiary : RUTI ");
      Goto(RUTI,1);

`endif
      end //}
    endtask : PutTapOnTertiary

    //---------------------------------------------
    task DisableTertiaryPort (input Tap_t Tap);
    begin
`ifndef JTAGBFM_EN_DFTB_HTAP
    `ifdef JTAG_BFM_TAPLINK_MODE
      `uvm_fatal(get_name(),"Task DisableTertiaryPort() cannot be used - Tertiary Port is not available in TapLink")
    `endif

       ArrayOfHistoryElements[Tap].IsTertiaryPortEnabled = 0;
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          ArrayOfHistoryElements[i].TertiaryParentTap = GetTertiaryParentTap(Tap_t'(i));
          `dbg_display("AfterDisableTer ArrayOfHistoryElements[%0d].TapOfInterest               = %0s", i, ArrayOfHistoryElements[i].TapOfInterest);
          `dbg_display("AfterDisableTer ArrayOfHistoryElements[%0d].TertiaryParentTap           = %0s", Tap_t'(i), ArrayOfHistoryElements[i].TertiaryParentTap);
          `dbg_display("\n");
       end
`endif
    end
    endtask : DisableTertiaryPort

    //---------------------------------------------
    // FIXME - Change the name of this fn.
    function Tap_t GetNearestTapThatHostsTertiaryPort(input Tap_t TapThatIsEnabledForTertiary);
    begin
       Tap_t TempTap, TempTap_under;
       TempTap = TapThatIsEnabledForTertiary;
`ifndef JTAGBFM_EN_DFTB_HTAP
       `dbg_display("PutTapOnTertiary_Debug_4 TempTap = %0s", TempTap);
       if (ArrayOfHistoryElements[TempTap].SecondaryConnectionEnable == 1) begin //https://hsdes.intel.com/appstore/article/#/1604252202/main is fixed 
           `dbg_display("PutTapOnTertiary_Debug_4.1: Tap under tertiary has Tertiary port itself: TempTap = %0s", TempTap); 
           TempTap_under = TempTap; 
           TempTap = ArrayOfHistoryElements[TempTap].ParentTap; 
       end 
       while (ArrayOfHistoryElements[TempTap].SecondaryConnectionEnable == 0)
       begin
          if (ArrayOfHistoryElements[TempTap].SecondaryConnectionEnable == 1) begin
             break;
          end
          `dbg_display("PutTapOnTertiary_Debug_5 TempTap = %0s", TempTap);
          TempTap_under = TempTap;
          `dbg_display("PutTapOnTertiary_Debug_6 TempTap = %0s", TempTap);
          TempTap = ArrayOfHistoryElements[TempTap].ParentTap;
       end
       if (TempTap == Tap_t'(0)) begin
          `uvm_error("",$psprintf("Tap %0s cannot be placed on Tertiary as these connections are not available.",
                           TapThatIsEnabledForTertiary));
       end   
       `dbg_display("PutTapOnTertiary_Debug_7 TempTap = %0s", TempTap);
`endif
       return TempTap_under;
    end
    endfunction : GetNearestTapThatHostsTertiaryPort

    //---------------------------------------------
    function Tap_t GetTertiaryParentTap(input Tap_t TapOfInterestTemp);
    begin
       Tap_t TempTap, TempTap1;
       int depth;

       TempTap = TapOfInterestTemp;
       depth   = ArrayOfHistoryElements[TempTap].NodeQueue.size;

       `dbg_display("GetTertiaryParentTap_Debug_1 TempTap = %0s", TempTap);
       //----------------
       for (int i = 0; i < depth; i++) begin
          TempTap1 = ArrayOfHistoryElements[TempTap].NodeQueue[depth-1-i]; 
          if (((ArrayOfHistoryElements[TempTap1].IsTertiaryPortEnabled     == 1) && 
               (ArrayOfHistoryElements[TempTap1].SecondaryConnectionEnable == 1)
              ) == 1)
          break;
       end
       //----------------

       if (TempTap1 == Tap_t'(0)) begin
          TempTap1 = NOTAP;
       end   
       `dbg_display("GetTertiaryParentTap_Debug_2 TempTap1 = %0s", TempTap1);

       return TempTap1;
    end
    endfunction : GetTertiaryParentTap

    //---------------------------------------------
    function print_port_assocation_table();
       `dbg_display("print_port_assocation_table"); 
       `dbg_display("         SecConnBitfromCTT  IsTapEnabled  IsTapOnPrim  IsTapOnSec  IsTapOnTerAll  IsTapOnTer0  IsTapOnTer1"); 
       for (int i=0; i<NUMBER_OF_TAPS; i++) begin
          `dbg_display("%8s : %9d       %9d      %9d    %9d    %9d     %9d", 
                                  ArrayOfHistoryElements[i].TapOfInterest,
                                  ArrayOfHistoryElements[i].SecondaryConnectionEnable,
                                  ArrayOfHistoryElements[i].IsTapEnabled,
                                  ArrayOfHistoryElements[i].IsTapOnPrimary,
                                  ArrayOfHistoryElements[i].IsTapOnSecondary,
                                  ArrayOfHistoryElements[i].IsTapOnTertiaryForAllPorts,
                                  ArrayOfHistoryElements[i].IsTapOnTertiary[0]);
       end
    endfunction : print_port_assocation_table
    //---------------------------------------------

    function dump_history_table(input Tap_t TapOfInterest);
       //for (int i=0; i<NUMBER_OF_TAPS; i++) 
       `dbg_display("dump_history_table"); 
       begin
       Tap_t i;
       i = TapOfInterest;
          `dbg_display("\n=====================================================================");
          `dbg_display("ArrayOfHistoryElements[%0s].TapOfInterest               = %0s", i, ArrayOfHistoryElements[i].TapOfInterest);
          `dbg_display("ArrayOfHistoryElements[%0s].ParentTap                   = %0s", Tap_t'(i), ArrayOfHistoryElements[i].ParentTap);
          `dbg_display("ArrayOfHistoryElements[%0s].HierarchyLevel              = %0d", i, ArrayOfHistoryElements[i].HierarchyLevel);
          `dbg_display("ArrayOfHistoryElements[%0s].IsVendorTap                 = %0d", i, ArrayOfHistoryElements[i].IsVendorTap);
          `dbg_display("ArrayOfHistoryElements[%0s].NodeQueue.size              = %0d", i, ArrayOfHistoryElements[i].NodeQueue.size);
          `dbg_display("ArrayOfHistoryElements[%0s].Tap_Node_q                  = ", i, ArrayOfHistoryElements[i].NodeQueue);
          `dbg_display("ArrayOfHistoryElements[%0s].NodeArray                   = %0d", i, NUMBER_OF_HIER, ArrayOfHistoryElements[i].NodeArray);
          `dbg_display("ArrayOfHistoryElements[%0s].TapBeforeTapOfInterestArray = %0d", i, NUMBER_OF_TAPS, ArrayOfHistoryElements[i].TapBeforeTapOfInterestArray);
          `dbg_display("ArrayOfHistoryElements[%0s].TapAfterTapOfInterestArray  = %0d", i, NUMBER_OF_TAPS, ArrayOfHistoryElements[i].TapAfterTapOfInterestArray);
          `dbg_display("ArrayOfHistoryElements[%0s].IsTertiaryPortEnabled       = %0d", i, ArrayOfHistoryElements[i].IsTertiaryPortEnabled);
          `dbg_display("ArrayOfHistoryElements[%0s].TertiaryParentTap           = %0s", Tap_t'(i), ArrayOfHistoryElements[i].TertiaryParentTap);
          `dbg_display("ArrayOfHistoryElements[%0s].ChildTapsArray              = ", Tap_t'(i), ArrayOfHistoryElements[Tap_t'(i)].ChildTapsArray);
          `dbg_display("\n---------------------------------------------------------------------");
          `dbg_display("ArrayOfHistoryElements[%0s].TapMode                     = %0d", i, ArrayOfHistoryElements[i].TapMode);
          `dbg_display("ArrayOfHistoryElements[%0s].IsTapEnabled                = %0d", i, ArrayOfHistoryElements[i].IsTapEnabled);
          `dbg_display("ArrayOfHistoryElements[%0s].IsTapOnPrimary              = %0d", i, ArrayOfHistoryElements[i].IsTapOnPrimary);
          `dbg_display("ArrayOfHistoryElements[%0s].IsTapOnSecondary            = %0d", i, ArrayOfHistoryElements[i].IsTapOnSecondary);
          `dbg_display("ArrayOfHistoryElements[%0s].IsTapDisabled               = %0d", i, ArrayOfHistoryElements[i].IsTapDisabled);
          `dbg_display("ArrayOfHistoryElements[%0s].TapDisabledByParent         = %0d", i, ArrayOfHistoryElements[i].TapDisabledByParent);
          `dbg_display("ArrayOfHistoryElements[%0s].TapDisabledByReset          = %0d", i, ArrayOfHistoryElements[i].TapDisabledByReset);
          `dbg_display("ArrayOfHistoryElements[%0s].TapSelfDisable              = %0d", i, ArrayOfHistoryElements[i].TapSelfDisable);
          `dbg_display("ArrayOfHistoryElements[%0s].TapChangedToDisabled        = %0d", i, ArrayOfHistoryElements[i].TapChangedToDisabled);
          `dbg_display("ArrayOfHistoryElements[%0s].TapChangedToEnabled         = %0d", i, ArrayOfHistoryElements[i].TapChangedToEnabled);
          `dbg_display("ArrayOfHistoryElements[%0s].PreviousStateOfIsTapDisabled= %0d", i, ArrayOfHistoryElements[i].PreviousStateOfIsTapDisabled);
          `dbg_display("\n---------------------------------------------------------------------");
          `dbg_display("ArrayOfHistoryElements[%0s].TapcRemove                  = %0d", i, ArrayOfHistoryElements[i].TapcRemove);
          `dbg_display("ArrayOfHistoryElements[%0s].DrLengthOfTapcSelectReg     = %0d", i, ArrayOfHistoryElements[i].DrLengthOfTapcSelectReg);
          `dbg_display("ArrayOfHistoryElements[%0s].PostionOfTapInTapcSelReg    = %0d", i, ArrayOfHistoryElements[i].PostionOfTapInTapcSelReg);
          `dbg_display("ArrayOfHistoryElements[%0s].IsTapShadowed               = %0d", i, ArrayOfHistoryElements[i].IsTapShadowed);
          `dbg_display("ArrayOfHistoryElements[%0s].TapcSelectRegister          = %0d", i, ArrayOfHistoryElements[i].TapcSelectRegister);
          `dbg_display("ArrayOfHistoryElements[%0s].TapSecondarySelect          = %0d", i, ArrayOfHistoryElements[i].TapSecondarySelect);
          `dbg_display("\n---------------------------------------------------------------------");
          `dbg_display("ArrayOfHistoryElements[%0s].EnableMultiTapAccess        = %0h", i, ArrayOfHistoryElements[i].EnableMultiTapAccess);
          `dbg_display("ArrayOfHistoryElements[%0s].OpcodeForMultiTapAccess     = %0h", i, ArrayOfHistoryElements[i].OpcodeForMultiTapAccess);
          `dbg_display("=====================================================================");
       end
    endfunction : dump_history_table

    //---------------------------------------------
    // This function returns the nearest or next nearest enabled Tertiary port.
    // Execution of this fn should be after the usage of DisableTertirayPort(TapName) API
    // If TapofInterest = STAP18,  and if its  DisableNearestTertiaryTap bit of STAP18 = 1 then 
    function Tap_t GetNearestTapThatHostsTertiaryEnabledPort(input Tap_t TapThatIsEnabledForTertiary);
    endfunction : GetNearestTapThatHostsTertiaryEnabledPort
    //---------------------------------------------
    function void TapEnumMap();
       Tap_enum = Tap_enum.first();
       TapName  = Tap_enum.name();
       Tap_string_array[0] = Tap_enum;

       for (int i = 1; i < Tap_enum.num(); i++) begin 
          Tap_enum = Tap_enum.next();
          TapName  = Tap_enum.name(); 
          Tap_string_array[i] = Tap_enum;
       end

       for (int i = 1; i < (Tap_enum.num()-1) ; i++) begin 
          `dbg_display("Tap_string_array = %s", Tap_string_array[i]);
          `dbg_display("Tap_string_array = %0d", Tap_string_array[i]);
       end
    endfunction : TapEnumMap

    task ReadIdCodes ();
    begin
       for (int i=0; i < NUMBER_OF_TAPS; i++) begin
          if (i == 0) begin
             TapAccessCltapcIdcode (Tap_string_array[i]);
          end
          else begin
             TapAccessSlaveIdcode (Tap_string_array[i]);
          end
       end
    end
    endtask : ReadIdCodes

    task RemoveTap (input Tap_t Tap);
    begin //{
      logic [API_SIZE_OF_IR_REG-1:0]     RegisterInt   = 'h14;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] expected_data = 0;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] compare_mask  = 0;
      bit                                en_user_defined_dr_length = 0;
      bit                                En_RegisterPresenceCheck = 1;
      int                                InputDrWidth;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] InputDrData;
      bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
`ifndef JTAGBFM_EN_DFTB_HTAP
    `ifdef JTAG_BFM_TAPLINK_MODE
      `uvm_fatal(get_name(),"Task RemoveTap() cannot be used - RemoveTap is not available in TapLink")
    `endif  

      //Check whether Tap of interest exists in the network.
      GetTapAvailableStatus (Tap);

      //If Tap of interest exists in a given network then
      //proceed with enable and access operation.
      if (TapExistFlag == 1) begin //{

         InputDrData = 1;
         ArrayOfHistoryElements[Tap].TapcRemove = InputDrData;

         AccessTargetReg(
            .TapOfInterest           (Tap),
            .Opcode                  (RegisterInt),
            .InputDrWidth            (InputDrWidth),
            .InputDrData             (InputDrData),
            .ExpectedData            (expected_data),
            .Mask                    (compare_mask),
            .EnRegisterPresenceCheck (En_RegisterPresenceCheck),
            .EnUserDefinedDRLength   (en_user_defined_dr_length),
            .TDOData                 (tdo_data),
            .TDODataChopped          (tdo_data_chopped));

         ArrayOfHistoryElements[Tap].IsTapOnRemove = 1;
         `dbg_display("ArrayOfHistoryElements[%0s].IsTapOnRemove = %0d", Tap, ArrayOfHistoryElements[Tap].IsTapOnRemove);
         
         //if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap !== Tap_t'(0))) begin
         //   HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
         //   for (int k=HierarchyLevel_Internal; k>0;k--) begin
         //      for (int p=0; p<NUMBER_OF_TAPS; p++) begin
         //         if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
         //            if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	 //                    DisableTap(Tap_t'(p));
         //            end
         //         end
         //      end
         //   end
         //end
      end //}
      `dbg_display("RemoveTap: RUTI ");
      Goto(RUTI,1);
`endif
      end //}
    endtask : RemoveTap

    //TapAccess Read-Modify-Write
    task TapAccessRmw(
       input Tap_t                        Tap = 0,
       input [API_SIZE_OF_IR_REG-1:0]     Opcode = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] ShiftIn = 0,
       input int                          ShiftLength = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] ExpectedData = 0,
       input [WIDTH_OF_EACH_REGISTER-1:0] WriteMask = 0,
       input bit                          EnUserDefinedShiftLength = 0,
       input bit                          EnRegisterPresenceCheck = 1,
       output bit [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo);
    begin
       bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
       bit   [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;

       `uvm_info (get_type_name(), $psprintf("JTAGBFM: Starting RMW access for TAP %s, Opcode 'h0%0h, Inp Data %0d'h0%0h, Write Mask 'h0%0h",
              Tap.name(), Opcode, ShiftLength, ShiftIn, WriteMask), UVM_NONE);

       //Task check for availability of Tap in the network
       GetTapAvailableStatus (Tap);
       ReadModifyWriteEnabled = 1;
       //If Tap of interest exists in a given network then
       //proceed with enable and access operation.
       if (TapExistFlag == 1) begin

          //Enable Tap of interest before accessing any opcode.
          EnableTap (Tap);

          AccessTargetReg(
             .TapOfInterest           (Tap),
             .Opcode                  (Opcode),
             .InputDrWidth            (ShiftLength),
             .InputDrData             (ShiftIn),
             .ExpectedData            (0), // Hard wired to 0
             .Mask                    (WriteMask),
             .EnRegisterPresenceCheck (EnRegisterPresenceCheck),
             .EnUserDefinedDRLength   (EnUserDefinedShiftLength),
             .TDOData                 (tdo_data),
             .TDODataChopped          (ReturnTdo));
         
          //if (((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) && (Tap !== Tap_t'(0))) begin
          //  HierarchyLevel_Internal = ArrayOfHistoryElements[Tap].HierarchyLevel;
          //  for (int k=HierarchyLevel_Internal; k>0;k--) begin
          //     for (int p=0; p<NUMBER_OF_TAPS; p++) begin
          //        if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
          //           if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	  //                   DisableTap(Tap_t'(p));
          //           end
          //        end
          //     end
          //  end
          //end
       end

       `dbg_display("TapAccessRmw Calling RUTI...");
       Goto(RUTI,1);
       ReadModifyWriteEnabled = 0;
    end
    endtask : TapAccessRmw

    // 24-Feb-2015 HSD https://hsdes.intel.com/home/default.html#article?id=1603913399
    // JTAG BFM to have control over STAP ACCESS using CLTAP_SEL_OVR and TAP MODE 
    function SetCltapcNetworkSelOpcode(input logic [API_SIZE_OF_IR_REG-1:0] Opcode = 'h12);
    begin
`ifndef JTAGBFM_EN_DFTB_HTAP
       assert ((Opcode == 'h12) || (Opcode == 'h11)) else $error ("CltapcNetworkSelOpcode should be none other than 'h12 or 'h11 only.");   
       if (Opcode == 'h12) 
          CltapcNetworkSelOpcodeis_h12 = 1'b1;
       else if  (Opcode == 'h11)
          CltapcNetworkSelOpcodeis_h12 = 1'b0;
       `dbg_display("CltapcNetworkSelOpcodeis_h12 = %0b", CltapcNetworkSelOpcodeis_h12);
`endif
    end
    endfunction : SetCltapcNetworkSelOpcode

    //--------------------------------------------------------------------
    // Task is used to Program the Endebug CFG Register
    //--------------------------------------------------------------------
    task JtagBfmEnDebugCfgReg(
                              input jtagbfm_encryption_cfg   EndebugEncryptionCfg,
                              input int                      CltapIrLength = 16);
    begin
    
       `ifndef JTAGBFM_ENDEBUG_110REV
       if(EndebugEncryptionCfg.END_DEBUG_SESSION === 1'b1) begin
          if ((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0)) begin
             for (int k=NUMBER_OF_HIER; k>0;k--) begin
                for (int p=0; p<NUMBER_OF_TAPS; p++) begin
                   if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
                      if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
	                      DisableTap(Tap_t'(p));
                      end
                   end
                end
             end  
          end        
          //---------------------------TGP----------------
          JtagBfmEnDebugStatusReg(CltapIrLength,7,EndebugStatusRegStatusValue);
          if(EndebugStatusRegStatusValue === 1'b1) begin
             ENDEBUG_OWN   = 1'b0;
          end
          //---------------------------TGP----------------
       end
       `endif
       ENDEBUG_ENCRYPTION_CFG = EndebugEncryptionCfg;
       //ENDEBUG_ENCRYPTION_CFG.START_DEBUG_SESSION = 2'b00;
       `uvm_info(get_type_name(),$psprintf("Values of Register ENDEBUG_ENCRYPTION_CFG = %p",ENDEBUG_ENCRYPTION_CFG),UVM_NONE);
       MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h1, ENDEBUG_ENCRYPTION_CFG, CltapIrLength, ENDEBUG_CFG_REG_LENGTH);
       if(ENDEBUG_ENCRYPTION_CFG.END_DEBUG_SESSION === 1'b1) begin
          enc_reg_count = 0;
       end
    end
    endtask:JtagBfmEnDebugCfgReg

    //--------------------------------------------------------------------
    // Task is used to Program the Endebug DEBUG CFG Register
    //--------------------------------------------------------------------
    task JtagBfmEnDebug_DebugCfgReg(
                              input jtagbfm_encryption_debug_cfg   EndebugEncryptionDebugCfg,
                              input bit                            Policy_2_4  = 1'b0,
                              input int                            CltapIrLength = 16);
    begin
       `ifndef JTAGBFM_ENDEBUG_110REV
       if(Policy_2_4 === 1'b1) begin
          Debug_En = ENDEBUG_ENCRYPTION_DEBUG_CFG.DEBUGEN;
       end
       `endif
       if ((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (EndebugEncryptionDebugCfg.ENDEBUG_MUX_DISABLE === 1'b1) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) begin
          for (int k=NUMBER_OF_HIER; k>0;k--) begin
             for (int p=0; p<NUMBER_OF_TAPS; p++) begin
                if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
                   if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
                           DisableTap(Tap_t'(p));
                   end
                end
             end
          end  
       end        
       ENDEBUG_ENCRYPTION_DEBUG_CFG = EndebugEncryptionDebugCfg;
       `uvm_info(get_type_name(),$psprintf("Values of Register ENDEBUG_ENCRYPTION_DEBUG_CFG = %p",ENDEBUG_ENCRYPTION_DEBUG_CFG),UVM_NONE);
       MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h4, ENDEBUG_ENCRYPTION_DEBUG_CFG, CltapIrLength, ENDEBUG_DEBUG_CFG_REG_LENGTH);
    end
    endtask:JtagBfmEnDebug_DebugCfgReg

    //--------------------------------------------------------------------
    // Task is used to Program the Endebug DEBUG CFG GREEN Register
    //--------------------------------------------------------------------
    task JtagBfmEnDebug_DebugCfgRegGrn(
                              input jtagbfm_encryption_debug_cfg   EndebugEncryptionDebugCfg,
                              input int                            CltapIrLength  = 16);
    begin
       if(Debug_En === 1'b1) begin
          if ((ENDEBUG_OWN == 1'b1) && (FuseDisable == 1'b0) && (EndebugEncryptionDebugCfg.ENDEBUG_MUX_DISABLE === 1'b1) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0)) begin
             for (int k=NUMBER_OF_HIER; k>0;k--) begin
                for (int p=0; p<NUMBER_OF_TAPS; p++) begin
                   if(ArrayOfHistoryElements[p].HierarchyLevel === k) begin
                      if (ArrayOfHistoryElements[p].IsTapEnabled === 1) begin
                              DisableTap(Tap_t'(p));
                      end
                   end
                end
             end  
          end        
          ENDEBUG_ENCRYPTION_DEBUG_CFG = EndebugEncryptionDebugCfg;
          `uvm_info(get_type_name(),$psprintf("Values of Register ENDEBUG_ENCRYPTION_DEBUG_CFG = %p",ENDEBUG_ENCRYPTION_DEBUG_CFG),UVM_NONE);
          MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h8, ENDEBUG_ENCRYPTION_DEBUG_CFG, CltapIrLength, ENDEBUG_DEBUG_CFG_REG_LENGTH);
       end
    end
    endtask:JtagBfmEnDebug_DebugCfgRegGrn

endclass : JtagBfmSoCTapNwSequences
`endif // JtagBfmSoCTapNwAPIs

