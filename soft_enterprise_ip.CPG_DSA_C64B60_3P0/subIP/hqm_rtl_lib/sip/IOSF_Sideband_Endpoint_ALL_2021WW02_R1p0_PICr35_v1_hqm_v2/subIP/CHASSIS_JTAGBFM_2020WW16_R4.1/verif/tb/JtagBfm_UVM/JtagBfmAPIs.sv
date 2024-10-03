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
//    FILENAME    : JtagBfmSequences.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//
//
//    PURPOSE     : Sequences for the ENV 
//    DESCRIPTION : This Component defines various sequences that are 
//                  needed to drive and test the DUT including the Random
//------------------------------------------------------------------------

`ifndef INC_JtagBfmSequences
 `define INC_JtagBfmSequences 

   parameter API_SIZE_OF_IR_REG            = 4096;
`ifndef UVM_MAX_STREAMBITS
   parameter API_TOTAL_DATA_REGISTER_WIDTH = 4096;
   //parameter API_SIZE_OF_IR_REG            = 4096;
`else
   parameter API_TOTAL_DATA_REGISTER_WIDTH = `UVM_MAX_STREAMBITS;
   //parameter API_SIZE_OF_IR_REG            = `UVM_MAX_STREAMBITS;
`endif

class JtagBfmSequences extends uvm_sequence;

        bit [1:0]                             Endebug_ResetMode;
        bit [API_SIZE_OF_IR_REG-1:0]          Endebug_Address;
        bit [API_SIZE_OF_IR_REG-1:0]          Endebug_Expected_Address;
        bit [API_SIZE_OF_IR_REG-1:0]          Endebug_Mask_Address;
        int                                   Endebug_addr_len;
        bit                                   LongEndebugTAPFSMPath;
        bit                                   TapResetTapAccess;
        static logic [API_SIZE_OF_IR_REG-1:0] Endebug_Cltap_End_Address = 8'hFF;
        static logic [API_SIZE_OF_IR_REG-1:0] CLTAP_ENDEBUG_RTDR_START_ADDRESS = 8'h40;
        static logic                          Endebug_Enable_Tapnw_0_Tlink_1 = 0;
        `ifdef JTAGBFM_ENDEBUG_110REV
        protected int                         ENDEBUG_CFG_REG_LENGTH = 20;
        `else
        protected int                         ENDEBUG_CFG_REG_LENGTH = 21;
        `endif
        protected int                         ENDEBUG_DEBUG_CFG_REG_LENGTH = 18;
        protected int                         ENDEBUG_ENCRYPTION_DEBUG_SESSIONKEYOVR_LENGTH = 128;
        `ifdef JTAG_BFM_AES_256
        static byte                           fuse_key[31:0];
        `else
        static byte                           fuse_key[15:0];
        `endif
        static bit                            ENDEBUG_OWN;
        rand int                              EndebugTrasactionIdleTime;
        static jtagbfm_encryption_cfg         ENDEBUG_ENCRYPTION_CFG = '0;
        static jtagbfm_encryption_debug_cfg   ENDEBUG_ENCRYPTION_DEBUG_CFG ='0;
        static jtagbfm_encryption_debug_sessionkeyovr   ENDEBUG_ENCRYPTION_DEBUG_SESSIONKEYOVR ='0;
        static int                            ArcTapEnDbgCount = 0;
        static int                            PhyTapEnDbgCount = 0;

    `include "JtagBfmEndebugAPIs.sv"
    `include "JtagBfmEndebugTapLinkAccess.sv"

    // Constructor
    function new (string name = "JtagBfmSequences",
                uvm_sequencer_base sequencer_ptr = null,
                uvm_sequence_base parent_seq = null);
        super.new(name);
        //https://hsdes.intel.com/home/default.html#article?id=1503985289
        //Commented due to an error in SVTB Lintra Tool
        //Packet = new;
    endfunction : new

    // Register component with Factory 
    `uvm_object_utils(JtagBfmSequences)  
    `uvm_declare_p_sequencer(JtagBfmSequencer)

    // Packet fro Sequencer to Driver
    JtagBfmSeqDrvPkt Packet;

    // Class String
    string ClassName = "JtagBfmSequences";
    // prebody
    virtual task pre_body();
    `uvm_info(get_type_name(),"Raising Objection",UVM_LOW);
    uvm_test_done.raise_objection(this);
    endtask : pre_body
    
    // postbody
    virtual task post_body();
    `uvm_info(get_type_name(),"Droping Objection",UVM_LOW);
    uvm_test_done.drop_objection(this);
    endtask : post_body

    // Body
    virtual task body();

        `uvm_do_with(Packet, {Packet.Address        == 8'h12;
                              Packet.Data           == 32'hFFFF_AAAA;
                              Packet.ResetMode      == RST_HARD;
                              Packet.FunctionSelect == 3'b111;
                              Packet.addr_len       == 8;
                              Packet.data_len       == 32;
                              Packet.Extended_FunctionSelect == 2'b11;
                             })
            get_response(rsp);                      
    endtask : body

    //------------------------------------------
    //Reset Task Depending Upon the Mode
    //------------------------------------------    
    task Reset(input [1:0] ResetMode);
        begin
            bit [1:0] ResetModeInt = ResetMode;
            string    msg;
            $swrite (msg, "ResetMode Task Selected");
            `uvm_info (ClassName, msg, UVM_LOW);

            `uvm_do_with(Packet, {Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == RESET_TASK;
                                  Packet.Extended_FunctionSelect == 2'b00;
                                 })
            get_response(rsp);                      
        end
    endtask : Reset

    //------------------------------------------------------
    //Force Reset Task Depending Upon the Mode and State
    //------------------------------------------------------
    task ForceReset(
                     input [1:0] ResetMode,
                     input       ForceState
                   );
    begin
        bit [1:0] ResetModeInt  = ResetMode;
        bit       ForceStateInt = ForceState;
        string    msg;
        $swrite (msg, "ForceReset Task Selected");
        `uvm_info (ClassName, msg, UVM_LOW);
        `uvm_do_with(Packet, {Packet.ResetMode               == ResetModeInt;
                              Packet.Address[0]              == ForceStateInt;
                              Packet.FunctionSelect          == RESET_TASK;
                              Packet.Extended_FunctionSelect == 2'b01;})
        get_response(rsp);                      
    end
    endtask : ForceReset

    //------------------------------------------
    // LoadIR_idle 
    //------------------------------------------
    task LoadIR_idle(
        input [1:0]                ResetMode,
        input [API_SIZE_OF_IR_REG-1:0] Address,
        input [API_SIZE_OF_IR_REG-1:0] Expected_Address,
        input [API_SIZE_OF_IR_REG-1:0] Mask_Address,
        input int                  addr_len
        );
        begin
            bit [1:0] ResetModeInt                       = ResetMode ;
            bit [API_SIZE_OF_IR_REG-1:0] AddressInt          = Address;
            bit [API_SIZE_OF_IR_REG-1:0] Expected_AddressInt = Expected_Address;
            bit [API_SIZE_OF_IR_REG-1:0] Mask_AddressInt     = Mask_Address;
            int addr_len_int                             = addr_len;

            string    msg;
            Endebug_ResetMode        = ResetMode ;
            Endebug_Address          = Address;
            Endebug_Expected_Address = Expected_Address;
            Endebug_Mask_Address     = Mask_Address;
            Endebug_addr_len         = addr_len;
            
            $swrite (msg, "LoadIR_idle Task Selected \nAddress     %0h\nReset Mode  %0h\nAddress Len %0d",AddressInt,ResetModeInt,addr_len_int);
            `uvm_info (ClassName,msg, UVM_LOW);

            if(!((ENDEBUG_OWN === 1) && 
                 (FuseDisable === 1'b0) &&
                 (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0) && 
                 (Endebug_Address > Endebug_Cltap_End_Address)&& 
                 (Endebug_Enable_Tapnw_0_Tlink_1 === 1'b1))) begin
               `uvm_do_with(Packet, {Packet.Address                 == AddressInt;
                                     Packet.Expected_Address        == Expected_AddressInt;
                                     Packet.Mask_Address            == Mask_AddressInt;
                                     Packet.ResetMode               == ResetModeInt;
                                     Packet.FunctionSelect          == 3'b010;
                                     Packet.addr_len                == addr_len_int;
                                     Packet.Extended_FunctionSelect == 2'b01;
                                     })
               get_response(rsp);                     
            end 
        end
    endtask : LoadIR_idle

    //------------------------------------------
    // LoadDR_idle 
    //------------------------------------------
    task LoadDR_idle(
                input [1:0]                                      ResetMode,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Data,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Expected_Data,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Mask_Data,
                input int                                        data_len
               );
        begin
            bit [1:0]                            ResetModeInt        = ResetMode ;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  DataInt             = Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Expected_DataInt    = Expected_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Mask_DataInt        = Mask_Data;
            int                                  data_len_int        = data_len;
            bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
            bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;

            string                               msg;
            $swrite (msg, "LoadDR_idle Task Selected \nData     %0h\nReset Mode  %0h\nData Len %0d",DataInt,ResetModeInt,data_len);
            `uvm_info (ClassName, msg, UVM_LOW);
            if((ENDEBUG_OWN === 1) && 
               (FuseDisable === 1'b0) && 
               (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0) && 
               (Endebug_Address > Endebug_Cltap_End_Address) && 
               (Endebug_Enable_Tapnw_0_Tlink_1 === 1'b1)) begin 
                  Endebug_TapLink_Access(
                               .ResetMode       (Endebug_ResetMode),
                               .Address         (Endebug_Address), 
                               .addr_len        (Endebug_addr_len),
                               .Data            (DataInt),
                               .Expected_Data   (Expected_DataInt),
                               .Mask_Data       (Mask_DataInt), 
                               .ReturnTdoQualifier({WIDTH_OF_EACH_REGISTER{1'b1}}),  
                               .data_len        (data_len_int),
                               .tdo_data        (tdo_data),
                               .LongEndebugTAPFSMPath (LongEndebugTAPFSMPath),
                               .tdo_data_chopped(tdo_data_chopped)                               
                              ); 
            end
            else
            begin
               `uvm_do_with(Packet, { Packet.Data                   == DataInt;
                                     Packet.Expected_Data           == Expected_DataInt;
                                     Packet.Mask_Data               == Mask_DataInt;
                                     Packet.ResetMode               == ResetModeInt;
                                     Packet.FunctionSelect          == 3'b011;
                                     Packet.data_len                == data_len_int;
                                     Packet.Extended_FunctionSelect == 2'b01;
                                     })
               get_response(rsp);                      
            end 
        end
    endtask : LoadDR_idle
    //------------------------------------------
    //Goto The input State
    //------------------------------------------    
    task Goto(input [3:0] FsmState,
              input int   Count);
        begin
            bit [3:0] FsmStateInt = FsmState;
            int       CountInt    = Count;
            string    msg;
            $swrite (msg, "FsmState Task Selected: Goto %0h",FsmStateInt);
            `uvm_info (ClassName, msg, UVM_LOW);

           `uvm_do_with(Packet, {Packet.Address                  == FsmStateInt;
                                  Packet.Count                   == CountInt;
                                  Packet.FunctionSelect          == GOTO_TASK;
                                  Packet.Extended_FunctionSelect == 2'b00;
                                })
            get_response(rsp);                      
        end
    endtask : Goto

    //------------------------------------------
    // IDLE 
    //------------------------------------------
    task Idle (input int idle_count);
    begin
        int       idle_count_int = idle_count;
        string    msg;
        $swrite (msg, "idle_count Task Selected with count %0d",idle_count_int);
        `uvm_info (ClassName, msg, UVM_LOW);
        `uvm_do_with(Packet,{Packet.Count                    == idle_count_int;
                              Packet.FunctionSelect          == IDLE_TASK;
                              Packet.Extended_FunctionSelect == 2'b00;
                             })
            get_response(rsp );                      
    end
    endtask : Idle    

    //------------------------------------------
    // TMS TDI Stream 
    //------------------------------------------
    task tms_tdi_stream (
                         input [API_TOTAL_DATA_REGISTER_WIDTH-1:0] tms_stream,
                         input [API_TOTAL_DATA_REGISTER_WIDTH-1:0] tdi_stream,
                         input int      width);
    begin
        logic [API_TOTAL_DATA_REGISTER_WIDTH-1: 0] tms_stream_int = tms_stream;
        logic [API_TOTAL_DATA_REGISTER_WIDTH-1: 0] tdi_stream_int = tdi_stream;
        int           width_int      = width;
        string        msg;
        $swrite (msg, "tms_tdi_stream Task Selected \nTMS STREAM: %0h\nTDI STREAM: %0h\nWidth     : %0d",tms_stream_int,tdi_stream_int,width_int);
        `uvm_info (ClassName, msg, UVM_LOW);
        `uvm_create(Packet);
        //https://hsdes.intel.com/home/default.html#article?id=1503984875
        //Modified for driving 'X' on TDI and TMS Lines
        Packet.TMS_Stream            = tms_stream_int;
        Packet.TDI_Stream            = tdi_stream_int;
        Packet.Count                 = width_int;
        Packet.FunctionSelect        = TMS_TDI_STREAM;
        Packet.Extended_FunctionSelect = 2'b00;
        `uvm_send(Packet);
            get_response(rsp);                      
    end
    endtask : tms_tdi_stream


    //------------------------------------------
    // LoadDR_Pause
    //------------------------------------------
    task LoadDR_Pause(
                input [1:0]                                      ResetMode,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Data,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Expected_Data,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Mask_Data,
                input int                                        data_len,
                input int                                        pause_len
               );
        begin
            bit [1:0]                            ResetModeInt        = ResetMode ;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  DataInt             = Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Expected_DataInt    = Expected_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Mask_DataInt        = Mask_Data;
            int                                  data_len_int        = data_len;
            int                                  pause_len_int       = pause_len;
            string                               msg;
            $swrite (msg,"LoadDR_Pause Task Selected \nData     %0h\nReset Mode  %0h\nData Len %0d",DataInt,ResetModeInt,data_len);
            `uvm_info (ClassName, msg, UVM_LOW);

            `uvm_do_with(Packet, { Packet.Data                   == DataInt;
                                  Packet.Expected_Data           == Expected_DataInt;
                                  Packet.Mask_Data               == Mask_DataInt;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == LOAD_DR;
                                  Packet.data_len                == data_len_int;
                                  Packet.pause_len               == pause_len_int;
                                  Packet.Extended_FunctionSelect == 2'b01;
                                  })
            get_response(rsp);                      
        end
    endtask : LoadDR_Pause

    //------------------------------------------
    //RegisterAccess
    //------------------------------------------
    task ExpData_MultipleTapRegisterAccess(
                input [1:0]                                      ResetMode,
                input [API_SIZE_OF_IR_REG-1:0]                       Address,
                input int                                        addr_len,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Data,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Expected_Data,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Mask_Data,
                input int                                        data_len
                     );
        begin
            bit [1:0]                              ResetModeInt     = ResetMode ;
            bit [API_SIZE_OF_IR_REG-1:0]               AddressInt       = Address;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]    DataInt          = Data;
            int                                    addr_len_int     = addr_len;
            int                                    data_len_int     = data_len;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]    Expected_DataInt = Expected_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]    Mask_DataInt     = Mask_Data;
            string                                 msg;
            $swrite (msg,"ExpData_MultipleTapRegisterAccess Task Selected \nAddress    %0h\nData       %0h\nReset Mode %0h",AddressInt,DataInt,ResetModeInt);
            `uvm_info (ClassName, msg, UVM_LOW);


            `uvm_do_with(Packet, {Packet.Address                 == AddressInt;
                                  Packet.Data                    == DataInt;
                                  Packet.Expected_Data           == Expected_DataInt;
                                  Packet.Mask_Data               == Mask_DataInt;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.data_len                == data_len_int;
                                  Packet.addr_len                == addr_len_int;
                                  Packet.FunctionSelect          == REG_ACCESS;
                                  Packet.Extended_FunctionSelect == 2'b11;
                                 })
            get_response(rsp);                      
        end
    endtask : ExpData_MultipleTapRegisterAccess

    //------------------------------------------
    // ReturnTDO Multiple TAP Register Access
    //------------------------------------------
    task ReturnTDO_ExpData_MultipleTapRegisterAccess(
                                   input [1:0]                                  ResetMode,
                                   input [API_SIZE_OF_IR_REG-1:0]                   Address,
                                   input int                                    addr_len,
                                   input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]        Data,
                                   input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]        Expected_Data,
                                   input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]        Mask_Data,
                                   input int                                    data_len,
                                   output logic [API_TOTAL_DATA_REGISTER_WIDTH-1:0] tdo_data
                                  );
        begin
            bit [1:0]                             ResetModeInt     = ResetMode;
            bit [API_SIZE_OF_IR_REG-1:0]              AddressInt       = Address;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]   DataInt          = Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]   Expected_DataInt = Expected_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]   Mask_DataInt     = Mask_Data;
            int                                   addr_len_int     = addr_len;
            int                                   data_len_int     = data_len;

            string                                msg;
            $swrite (msg, "ReturnTDO_ExpData_MultipleTapRegisterAccess Task Selected \nAddress     %0h\nData        %0h\nReset Mode  %0h\nAddress Len %0d\nData Len    %0d",AddressInt,DataInt,ResetModeInt,addr_len_int,data_len_int);
            `uvm_info (ClassName, msg, UVM_LOW);
            `uvm_do_with(Packet, {Packet.Address                 == AddressInt;
                                  Packet.Data                    == DataInt;
                                  Packet.Expected_Data           == Expected_DataInt;
                                  Packet.Mask_Data               == Mask_DataInt;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == MULTI_TAP_RA;
                                  Packet.addr_len                == addr_len_int;
                                  Packet.data_len                == data_len_int;
                                  Packet.Extended_FunctionSelect == 2'b01;
                                  })
            get_response(rsp);                      
            $cast(Packet,rsp);
            tdo_data = Packet.actual_tdo_collected;
        end
    endtask : ReturnTDO_ExpData_MultipleTapRegisterAccess 

    //--------------------------------------------------------------------------
    // CTV(Capture Test Vector) ReturnTDO Multiple TAP Register Access
    // PCR_TITLE: Jtag BFM - Request for new ExpDataorCapData_MultipleTapRegisterAccess
    // PCR_NO:https://hsdes.intel.com/home/default.html#article?id=1205378989
    // 05-Mar-2015: Added Mask_capture input to calculate strobes for 
    // displaying corresponding bits in LOG file.
    //--------------------------------------------------------------------------
    task CTV_ReturnTDO_ExpData_MultipleTapRegisterAccess(
                                   input [1:0]                                  ResetMode,
                                   input [API_SIZE_OF_IR_REG-1:0]                   Address,
                                   input int                                    addr_len,
                                   input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]        Data,
                                   input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]        Expected_Data,
                                   input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]        Mask_Data,
                                   input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]        Mask_Capture,
                                   input int                                    data_len,
                                   output logic [API_TOTAL_DATA_REGISTER_WIDTH-1:0] tdo_data
                                  );
        begin
            bit [1:0]                             ResetModeInt     = ResetMode;
            bit [API_SIZE_OF_IR_REG-1:0]              AddressInt       = Address;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]   DataInt          = Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]   Expected_DataInt = Expected_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]   Mask_DataInt     = Mask_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]   Mask_CaptureInt  = Mask_Capture;
            int                                   addr_len_int     = addr_len;
            int                                   data_len_int     = data_len;

            string                                msg;
            $swrite (msg, "CTV_ReturnTDO_ExpData_MultipleTapRegisterAccess Task Selected \nAddress      %0h\nData         %0h\nReset Mode   %0h\nAddress Len  %0d\nData Len     %0d\nMask_Capture %0d",AddressInt,DataInt,ResetModeInt,addr_len_int,data_len_int,Mask_CaptureInt);
            `uvm_info (ClassName, msg, UVM_LOW);
            `uvm_do_with(Packet, {Packet.Address                 == AddressInt;
                                  Packet.Data                    == DataInt;
                                  Packet.Expected_Data           == Expected_DataInt;
                                  Packet.Mask_Data               == Mask_DataInt;
                                  Packet.Mask_Capture            == Mask_CaptureInt;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == 3'b101;
                                  Packet.addr_len                == addr_len_int;
                                  Packet.data_len                == data_len_int;
                                  Packet.Extended_FunctionSelect == 2'b01;
                                  })
            get_response(rsp);                      
            $cast(Packet,rsp);
            tdo_data = Packet.actual_tdo_collected;
        end
    endtask : CTV_ReturnTDO_ExpData_MultipleTapRegisterAccess 

    //------------------------------------------
    // ReturnTDO Multiple TAP Register Access
    //------------------------------------------
    task ReturnTDO_ExpData_MultipleTapRegisterAccessRuti(
                                   input [1:0]                                  ResetMode,
                                   input [API_SIZE_OF_IR_REG-1:0]                   Address,
                                   input int                                    addr_len,
                                   input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]        Data,
                                   input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]        Expected_Data,
                                   input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]        Mask_Data,
                                   input int                                    data_len,
                                   output logic [API_TOTAL_DATA_REGISTER_WIDTH-1:0] tdo_data
                                  );
        begin
            bit [1:0]                             ResetModeInt     = ResetMode;
            bit [API_SIZE_OF_IR_REG-1:0]              AddressInt       = Address;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]   DataInt          = Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]   Expected_DataInt = Expected_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]   Mask_DataInt     = Mask_Data;
            int                                   addr_len_int     = addr_len;
            int                                   data_len_int     = data_len;

            string                                msg;
            $swrite (msg, "ReturnTDO_ExpData_MultipleTapRegisterAccessRuti Task Selected \nAddress     %0h\nData        %0h\nReset Mode  %0h\nAddress Len %0d\nData Len    %0d",AddressInt,DataInt,ResetModeInt,addr_len_int,data_len_int);
            `uvm_info (ClassName, msg, UVM_LOW);
            `uvm_do_with(Packet, {Packet.Address                 == AddressInt;
                                  Packet.Data                    == DataInt;
                                  Packet.Expected_Data           == Expected_DataInt;
                                  Packet.Mask_Data               == Mask_DataInt;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == MULTI_TAP_RA;
                                  Packet.addr_len                == addr_len_int;
                                  Packet.data_len                == data_len_int;
                                  Packet.Extended_FunctionSelect == 2'b10;
                                  })
            get_response(rsp);                      
            $cast(Packet,rsp);
            tdo_data = Packet.actual_tdo_collected;
        end
    endtask : ReturnTDO_ExpData_MultipleTapRegisterAccessRuti 


    //------------------------------------------
    // Load IR 
    //------------------------------------------
    task LoadIR(
        input [1:0]                ResetMode,
        input [API_SIZE_OF_IR_REG-1:0] Address,
        input [API_SIZE_OF_IR_REG-1:0] Expected_Address,
        input [API_SIZE_OF_IR_REG-1:0] Mask_Address,
        input int                  addr_len
        );
        begin
            bit [1:0] ResetModeInt                       = ResetMode ;
            bit [API_SIZE_OF_IR_REG-1:0] AddressInt          = Address;
            bit [API_SIZE_OF_IR_REG-1:0] Expected_AddressInt = Expected_Address;
            bit [API_SIZE_OF_IR_REG-1:0] Mask_AddressInt     = Mask_Address;
            int addr_len_int                             = addr_len;
            string    msg;
            Endebug_ResetMode        = ResetMode ;
            Endebug_Address          = Address;
            Endebug_Expected_Address = Expected_Address;
            Endebug_Mask_Address     = Mask_Address;
            Endebug_addr_len         = addr_len;

            $swrite (msg, "LoadIR Task Selected \nAddress     %0h\nReset Mode  %0h\nAddress Len %0d",AddressInt,ResetModeInt,addr_len_int);
            `uvm_info (ClassName, msg, UVM_LOW);
            if(!((ENDEBUG_OWN === 1) && 
                 (FuseDisable === 1'b0) && 
                 (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0) && 
                 (Endebug_Address > Endebug_Cltap_End_Address) && 
                 (Endebug_Enable_Tapnw_0_Tlink_1 === 1'b1))) begin
                  `uvm_do_with(Packet, {Packet.Address                 == AddressInt;
                                        Packet.Expected_Address        == Expected_AddressInt;
                                        Packet.Mask_Address            == Mask_AddressInt;
                                        Packet.ResetMode               == ResetModeInt;
                                        Packet.FunctionSelect          == LOAD_IR;
                                        Packet.addr_len                == addr_len_int;
                                        Packet.Extended_FunctionSelect == 2'b00;
                                        })
                  get_response(rsp);
            end
        end
    endtask : LoadIR

    //------------------------------------------
    // LoadIR_E1IR -- https://hsdes.intel.com/home/default.html/article?id=1018012221 - Added 27Mar14 for matching ITPP opcode on Tester
    //------------------------------------------
    task LoadIR_E1IR(
        input [1:0]                ResetMode,
        input [API_SIZE_OF_IR_REG-1:0] Address,
        input int                  addr_len
        );
        begin
            bit [1:0] ResetModeInt                       = ResetMode ;
            bit [API_SIZE_OF_IR_REG-1:0] AddressInt      = Address;
            int addr_len_int                             = addr_len;

            string    msg;
            $swrite (msg, "LoadIR_E1IR Task Selected \nAddress     %0h\nReset Mode  %0h\nAddress Len %0d",AddressInt,ResetModeInt,addr_len_int);
            `uvm_info (ClassName, msg, UVM_LOW);

            `uvm_do_with(Packet, {Packet.Address                 == AddressInt;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == 3'b000;
                                  Packet.addr_len                == addr_len_int;
                                  Packet.Extended_FunctionSelect == 2'b11;
                                  })
            get_response(rsp);
        end
    endtask : LoadIR_E1IR

    //------------------------------------------
    // Load DR 
    //------------------------------------------
    task LoadDR(
                input [1:0]                                      ResetMode,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Data,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Expected_Data,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Mask_Data,
                input int                                        data_len
               );
        begin
            bit [1:0]                            ResetModeInt        = ResetMode ;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  DataInt             = Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Expected_DataInt    = Expected_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Mask_DataInt        = Mask_Data;
            int                                  data_len_int        = data_len;
            bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data;
            bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped;
            string                               msg;
            $swrite (msg, "LoadDR Task Selected \nData     %0h\nReset Mode  %0h\nData Len %0d",DataInt,ResetModeInt,data_len);
            `uvm_info (ClassName, msg, UVM_LOW);
            if((ENDEBUG_OWN === 1) && 
               (FuseDisable === 1'b0) && 
               (Endebug_Address > Endebug_Cltap_End_Address) && 
               (ENDEBUG_ENCRYPTION_DEBUG_CFG.ENDEBUG_MUX_DISABLE === 1'b0) && 
               (Endebug_Enable_Tapnw_0_Tlink_1 === 1'b1)) begin 
                  Endebug_TapLink_Access(
                               .ResetMode       (Endebug_ResetMode),
                               .Address         (Endebug_Address), 
                               .addr_len        (Endebug_addr_len),
                               .Data            (DataInt),
                               .Expected_Data   (Expected_DataInt),
                               .Mask_Data       (Mask_DataInt),
                               .ReturnTdoQualifier({WIDTH_OF_EACH_REGISTER{1'b1}}),  
                               .data_len        (data_len_int),
                               .tdo_data        (tdo_data),
                               .LongEndebugTAPFSMPath (LongEndebugTAPFSMPath),
                               .tdo_data_chopped(tdo_data_chopped)                               
                              ); 
            end
            else
            begin
               `uvm_do_with(Packet, { Packet.Data                   == DataInt;
                                     Packet.Expected_Data           == Expected_DataInt;
                                     Packet.Mask_Data               == Mask_DataInt;
                                     Packet.ResetMode               == ResetModeInt;
                                     Packet.FunctionSelect          == LOAD_DR;
                                     Packet.data_len                == data_len_int;
                                     Packet.Extended_FunctionSelect == 2'b00;
                                     })
               get_response(rsp); 
            end 
        end
    endtask : LoadDR

    //------------------------------------------
    // LoadDR_E1DR -- https://hsdes.intel.com/home/default.html/article?id=1018012221 - Added 27Mar14 for matching ITPP opcode on Tester
    //------------------------------------------
    task LoadDR_E1DR(
                input [1:0]                                      ResetMode,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Data,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Expected_Data,
                input [API_TOTAL_DATA_REGISTER_WIDTH-1:0]            Mask_Data,
                input int                                        data_len
               );
        begin
            bit [1:0]                            ResetModeInt        = ResetMode ;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  DataInt             = Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Expected_DataInt    = Expected_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Mask_DataInt        = Mask_Data;
            int                                  data_len_int        = data_len;

            string                               msg;
            $swrite (msg, "LoadDR_E1DR Task Selected \nData     %0h\nReset Mode  %0h\nData Len %0d",DataInt,ResetModeInt,data_len);
            `uvm_info (ClassName, msg, UVM_LOW);
            `uvm_do_with(Packet, { Packet.Data                   == DataInt;
                                  Packet.Expected_Data           == Expected_DataInt;
                                  Packet.Mask_Data               == Mask_DataInt;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == 3'b001;
                                  Packet.data_len                == data_len_int;
                                  Packet.Extended_FunctionSelect == 2'b11;
                                  })
            get_response(rsp);
        end
    endtask : LoadDR_E1DR

    //------------------------------------------
    // Multiple TAP Register Access
    //------------------------------------------
    task MultipleTapRegisterAccess(
        input [1:0] ResetMode,
        input [API_SIZE_OF_IR_REG-1:0] Address,
        input [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
        input int addr_len,
        input int data_len);
        begin
            bit [1:0] ResetModeInt = ResetMode ;
            bit [API_SIZE_OF_IR_REG-1:0] AddressInt = Address;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0] DataInt = Data;
            int addr_len_int = addr_len;
            int data_len_int = data_len;
            string    msg;
            $swrite (msg, "MultipleTapRegisterAccess Task Selected \nAddress     %0h\nData        %0h\nReset Mode  %0h\nAddress Len %0d\nData Len    %0d",AddressInt,DataInt,ResetModeInt,addr_len_int,data_len_int);
            `uvm_info (ClassName, msg, UVM_LOW);
            `uvm_do_with(Packet, {Packet.Address                 == AddressInt;
                                  Packet.Data                    == DataInt;
                                  Packet.Expected_Data           == 0;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == MULTI_TAP_RA;
                                  Packet.addr_len                == addr_len_int;
                                  Packet.data_len                == data_len_int;
                                  Packet.Extended_FunctionSelect == 2'b00;
                                  })
            get_response(rsp);                      
        end
    endtask : MultipleTapRegisterAccess

    //------------------------------------------
    // Random Data Generation
    //------------------------------------------
    task MultipleTapRegisterAccessRand(
        input [1:0] ResetMode,
        input [API_SIZE_OF_IR_REG-1:0] Address,
        input int addr_len,
        input int data_len);
        begin
            bit [1:0] ResetModeInt = ResetMode ;
            bit [API_SIZE_OF_IR_REG-1:0] AddressInt = Address;
            int addr_len_int = addr_len;
            int data_len_int = data_len;
            string    msg;
            $swrite (msg, "MultipleTapRegisterAccessRand Task Selected \nAddress     %0h\nReset Mode  %0h\nAddress Len %0d\nData Len    %0d",AddressInt,ResetModeInt,addr_len_int,data_len_int);
            `uvm_info (ClassName, msg, UVM_LOW);
            `uvm_do_with(Packet, {Packet.Address                 == AddressInt;
                                  Packet.Expected_Data           == 0;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == MULTI_TAP_RA;
                                  Packet.addr_len                == addr_len_int;
                                  Packet.data_len                == data_len_int;
                                  Packet.Extended_FunctionSelect == 2'b00;
                                  })
            get_response(rsp);                      
        end
    endtask : MultipleTapRegisterAccessRand

    //*************************************************************************
    //Function to Return the Value of Actual TDO Collected During Load IR and DR
    //***************************************************************************
    function [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Actual_Tdo_Collected();
        $cast(Packet,rsp);
        return Packet.actual_tdo_collected;
    endfunction : Actual_Tdo_Collected
    //***************************************************************************

    //------------------------------------------------------
    //Force Clock Gating OFF Depending Upon the Mode and State
    //------------------------------------------------------
    task ForceClockGatingOff(
                     input  ClockGateOff
                   );
    begin
        bit       ClockGateOffInt  = ClockGateOff;
        string    msg;
        $swrite (msg, "ForceClockGatingOff Task Selected");
        `uvm_info (ClassName, msg, UVM_LOW);
        `uvm_do_with(Packet, {Packet.clk_gating_off          == ClockGateOffInt;
                              Packet.FunctionSelect          == 3'b001;
                              Packet.Extended_FunctionSelect == 2'b01;})
        get_response(rsp);                      
    end
    endtask : ForceClockGatingOff

    //------------------------------------------------------
    //------------------------------------------
    // Load DR with Return TDO
    //------------------------------------------
    task LoadDrWithReturnTdo(
       input        [1:0]                               ResetMode,
       input        [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
       input        [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Expected_Data,
       input        [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Mask_Data,
       input  int                                       data_len,
       output logic [API_TOTAL_DATA_REGISTER_WIDTH-1:0] tdo_data);
    begin
            bit [1:0]                            ResetModeInt        = ResetMode ;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  DataInt             = Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Expected_DataInt    = Expected_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Mask_DataInt        = Mask_Data;
            int                                  data_len_int        = data_len;
            string                               msg;

            $swrite (msg, "LoadDrWithReturnTdo Task Selected \nData     %0h\nReset Mode  %0h\nData Len %0d",DataInt,ResetModeInt,data_len);
            `uvm_info (ClassName, msg, UVM_LOW);
            `uvm_do_with(Packet, { Packet.Data                   == DataInt;
                                  Packet.Expected_Data           == Expected_DataInt;
                                  Packet.Mask_Data               == Mask_DataInt;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == LOAD_DR;
                                  Packet.data_len                == data_len_int;
                                  Packet.Extended_FunctionSelect == 2'b10;
                                  })
            get_response(rsp);                      
            $cast(Packet,rsp);
            tdo_data = Packet.actual_tdo_collected;
        end
    endtask : LoadDrWithReturnTdo


    //------------------------------------------
    // Load DR with Return TDO
    //------------------------------------------
    task LoadDrWithReturnTdoEndStatePause(
       input        [1:0]                               ResetMode,
       input        [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
       input        [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Expected_Data,
       input        [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Mask_Data,
       input  int                                       data_len,
       output logic [API_TOTAL_DATA_REGISTER_WIDTH-1:0] tdo_data);
    begin
            bit [1:0]                            ResetModeInt        = ResetMode ;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  DataInt             = Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Expected_DataInt    = Expected_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Mask_DataInt        = Mask_Data;
            int                                  data_len_int        = data_len;
            string                               msg;

            $swrite (msg, "LoadDrWithReturnTdoEndStatePause Task Selected \nData     %0h\nReset Mode  %0h\nData Len %0d",DataInt,ResetModeInt,data_len);
            `uvm_info (ClassName, msg, UVM_LOW);
            `uvm_do_with(Packet, { Packet.Data                   == DataInt;
                                  Packet.Expected_Data           == Expected_DataInt;
                                  Packet.Mask_Data               == Mask_DataInt;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == LOAD_DR;
                                  Packet.data_len                == data_len_int;
                                  Packet.Extended_FunctionSelect == 2'b11;
                                  })
            get_response(rsp);                      
            $cast(Packet,rsp);
            tdo_data = Packet.actual_tdo_collected;
        end
    endtask : LoadDrWithReturnTdoEndStatePause

    //------------------------------------------
    // Load DR with Return TDO
    //------------------------------------------
    task LoadDrWithReturnTdoShortPath(
       input        [1:0]                               ResetMode,
       input        [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
       input        [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Expected_Data,
       input        [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Mask_Data,
       input  int                                       data_len,
       output logic [API_TOTAL_DATA_REGISTER_WIDTH-1:0] tdo_data);
    begin
            bit [1:0]                            ResetModeInt        = ResetMode ;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  DataInt             = Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Expected_DataInt    = Expected_Data;
            bit [API_TOTAL_DATA_REGISTER_WIDTH-1:0]  Mask_DataInt        = Mask_Data;
            int                                  data_len_int        = data_len;
            string                               msg;

            $swrite (msg, "LoadDrWithReturnTdoShortPath Task Selected \nData     %0h\nReset Mode  %0h\nData Len %0d",DataInt,ResetModeInt,data_len);
            `uvm_info (ClassName, msg, UVM_LOW);
            `uvm_do_with(Packet, { Packet.Data                   == DataInt;
                                  Packet.Expected_Data           == Expected_DataInt;
                                  Packet.Mask_Data               == Mask_DataInt;
                                  Packet.ResetMode               == ResetModeInt;
                                  Packet.FunctionSelect          == GOTO_TASK;
                                  Packet.data_len                == data_len_int;
                                  Packet.Extended_FunctionSelect == 2'b10;
                                  })
            get_response(rsp);                      
            $cast(Packet,rsp);
            tdo_data = Packet.actual_tdo_collected;
        end
    endtask : LoadDrWithReturnTdoShortPath

endclass : JtagBfmSequences
`endif // INC_JtagBfmSequences
