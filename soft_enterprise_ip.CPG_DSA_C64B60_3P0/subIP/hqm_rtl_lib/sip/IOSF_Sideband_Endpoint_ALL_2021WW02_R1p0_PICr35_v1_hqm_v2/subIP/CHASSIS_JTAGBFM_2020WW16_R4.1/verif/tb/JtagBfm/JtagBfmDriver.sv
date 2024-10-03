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
//    FILENAME    : JtagBfmDriver.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//
//
//    PURPOSE     : Driver to the DUT
//    DESCRIPTION : This Block Drives the DUT through the pin interface
//                  It decodes the Sequencer tasks and drives the DUT
//                  accordingly
//----------------------------------------------------------------------

`ifndef INC_JtagBfmDriver
 `define INC_JtagBfmDriver 
 
parameter HIGH         = 1'b1;   //Defines the Logic 1
parameter LOW          = 1'b0;   //Defines the Logic 0
parameter PATH_WIDTH   = 7;   //Defines the Max number of Transitions needed to traverse from one state to other
parameter STATE_BITS   = 3;   //Defines the Number of Bits used to represent the State
localparam MAX_NUM_OF_RTDRS = 50; // This is set to a huge number. 

   parameter DRV_SIZE_OF_IR_REG            = 4096;
`ifndef OVM_MAX_STREAMBITS
   parameter DRV_TOTAL_DATA_REGISTER_WIDTH = 4096;
   //parameter DRV_SIZE_OF_IR_REG            = 4096;
`else
   parameter DRV_TOTAL_DATA_REGISTER_WIDTH = `OVM_MAX_STREAMBITS;
   //parameter DRV_SIZE_OF_IR_REG            = `OVM_MAX_STREAMBITS;
`endif

import JtagBfmUserDatatypesPkg::*;

`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
class JtagBfmDriver #(`JTAG_IF_PARAMS_DECL) extends ovm_driver;
`else    
class JtagBfmDriver extends ovm_driver;
`endif

    //***********************
    // Packet from Sequencer
    //***********************
    JtagBfmSeqDrvPkt Packet;


    //***********************
    //Local Declarations
    //***********************
    logic  [DRV_TOTAL_DATA_REGISTER_WIDTH:0]          data;
    logic  [DRV_SIZE_OF_IR_REG-1:0]                   addr;
    logic  [DRV_TOTAL_DATA_REGISTER_WIDTH:0]          expected_data;
    logic  [DRV_SIZE_OF_IR_REG-1:0]                   expected_addr;
    logic  [DRV_TOTAL_DATA_REGISTER_WIDTH:0]          mask_data;
    logic  [DRV_TOTAL_DATA_REGISTER_WIDTH:0]          mask_capture;
    logic  [DRV_SIZE_OF_IR_REG-1:0]                   mask_addr;
    logic  [1:0]                                      flag;
    fsm_state_test                                    current_state =     TLRS;
    bit    [3:0]                                      state;
    bit    [15:0]                                     rw_reg_width;
    integer                                           i,j,k;
    rand int                                          delay_factor;
    bit [2:0]                                         function_select_int;
    bit [1:0]                                         ext_function_select_int;
    int                                               addr_len,data_len,pause_len;
    bit                                               set_clk_off;
    int                                               count;
    logic [DRV_TOTAL_DATA_REGISTER_WIDTH-1:0]         tms_stream;
    logic [DRV_TOTAL_DATA_REGISTER_WIDTH-1:0]         tdi_stream; 
    logic                                             expected_tdo_err; // indicate output mismatch in loadir and loadr
    logic  [DRV_TOTAL_DATA_REGISTER_WIDTH:0]          actual_tdo_vector; // the tdo value shfited from loadir or loaddr
    bit                                               force_reset_state;
    logic  [DRV_TOTAL_DATA_REGISTER_WIDTH:0]          data_local;
    logic  [5:0]                                      rtdr_irdec_position=6'h0 ; //50 --> 110010
    logic  [5:0]                                      rtdr_index=6'h0 ;
    logic  [5:0]                                      rtdr_prev_index=6'h0 ;
    logic  [5:0]                                      rtdr_prev_irdec_position =6'h0;
    logic                                             enable_rtdr_reset =1'b0;  
   
    //***********************
    // Control properties
    //***********************
    protected bit                                 enable_clk_gating;
    protected bit                                 park_clk_at;
    protected bit                                 sample_tdo_on_negedge; //Non IEEE compliance mode, used only for TAP's not on the boundary of SoC.
    protected int                                 RESET_DELAY = 0; // 07-Nov-14 https://hsdes.intel.com/home/default.html/article?id=1603916956
    protected bit                                 rtdr_is_bussed = 0;
    protected bit                                 use_rtdr_interface =0;
    protected bit                                 config_trstb_value_en;
    protected bit                                 config_trstb_value;

    //*************************************
    // Register component with Factory
    //*************************************
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
    `ovm_component_param_utils_begin(JtagBfmDriver #(CLOCK_PERIOD,PWRGOOD_SRC,CLK_SRC,BFM_MON_CLK_DIS))
`else    
    `ovm_component_utils_begin(JtagBfmDriver)
`endif
       `ovm_field_int(enable_clk_gating, OVM_ALL_ON)
       `ovm_field_int(sample_tdo_on_negedge, OVM_ALL_ON)
       `ovm_field_int(park_clk_at, OVM_ALL_ON)
       `ovm_field_int(RESET_DELAY, OVM_ALL_ON)
       `ovm_field_int(rtdr_is_bussed, OVM_ALL_ON)
       `ovm_field_int(use_rtdr_interface, OVM_ALL_ON)
       `ovm_field_int(config_trstb_value_en, OVM_ALL_ON)
       `ovm_field_int(config_trstb_value, OVM_ALL_ON)
    `ovm_component_utils_end    

    //***********************
    // Constructor
    //***********************
    function new(string name = "JtagBfmDriver",  ovm_component parent = null);
        super.new(name,parent);
    endfunction : new

    //********************************************
    // pin Interface for connection to the DUT
    //********************************************
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
    protected virtual JtagBfmIntf #(`JTAG_IF_PARAMS_INST) PinIf;
`else    
    protected virtual JtagBfmIntf PinIf;
`endif
    function void connect();

        ovm_object temp;
        string msg;

    `ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
        JtagBfmIfContainer #(virtual JtagBfmIntf #(`JTAG_IF_PARAMS_INST)) vif_container;
    `else    
        JtagBfmIfContainer vif_container;
    `endif
        
        super.connect ();

        $swrite (msg, "Getting the virtual JtagBfmPinIf interface");
        `ovm_info (get_full_name(), msg, OVM_MEDIUM);
        // Assigning virtual interface
        if(get_config_object("V_JTAGBFM_PIN_IF", temp))
        begin
           if(!$cast(vif_container, temp))
           `ovm_fatal(get_full_name(),"Agent fail to connect to TI. Search for string << active agent exists at this hierarchy >> to get the list of all active agents in your SoC");
        end
        PinIf = vif_container.get_v_if();

        // From config object 
        get_config_int("RESET_DELAY",  RESET_DELAY); 
        get_config_int("rtdr_is_bussed",  rtdr_is_bussed); 
        rtdr_is_bussed = ~rtdr_is_bussed; 
        get_config_int("use_rtdr_interface",  use_rtdr_interface); 

        // Recommended by Dhruba during DNV FC debug around Jan-2014
        $display("CHASSIS_JTAGBFM_DEBUG For BFM=(%s) the interface is=(%s)", get_full_name(), PinIf.intf_name);
        
    endfunction : connect

    //***********************
    // Run Task
    //***********************
    task run();
        fork
            //------------------------------------------------------
            //To intialize the TAP Inputs to their Correct values
            //------------------------------------------------------
            begin
                string msg;
                `ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
                     $swrite (msg, "Value of BFM_MON_CLK_DIS = ",BFM_MON_CLK_DIS);
                `endif
                `ovm_info (get_full_name(), msg, OVM_MEDIUM);
                PinIf.tck                 = LOW;    // Clock Tied to LOW
                if(config_trstb_value_en === 1'b0) begin
                  PinIf.trst_b            = HIGH;   // TRST Tied to HIGH emulating a Weak Pull Up
                end
                else
                begin
                  PinIf.trst_b            = config_trstb_value;   // TRST will get value from config_trstb_value
                end
                PinIf.en_clk_gating       = enable_clk_gating;   // en_clk_gating will get value from config_trstb_value
                PinIf.sample_tdo_on_neg_edge= sample_tdo_on_negedge;   // sample_tdo_on_negedge will get value from config_trstb_value
                PinIf.bfm_powergood_rst_b = LOW;    // Power Good Reset Tied LOW at startup
                PinIf.tms                 = HIGH;   // TMS Tied HIGH as PER IEEE 1149.1 spec
                PinIf.tdi                 = LOW;    // TDI Tied LOW 
                PinIf.exp_tdo              = 1'bz;     
                PinIf.tap_tdo_strobe      = LOW;
                PinIf.shift_ir_reg        = {API_SIZE_OF_IR_REG{LOW}};
                PinIf.tap_ir_reg          = {API_SIZE_OF_IR_REG{LOW}};
                PinIf.force_clk_gating_off = LOW;
                PinIf.turn_clk_on         = LOW;
            end        
            //------------------------------------------------------
            //To intialize the RTDR Inputs to their Correct values
            //------------------------------------------------------
            begin
                PinIf.tap_rtdr_tck        =  LOW; 
                PinIf.tap_rtdr_tdi        = {MAX_NUM_OF_RTDRS{LOW}};
                PinIf.tap_rtdr_tdo        = {MAX_NUM_OF_RTDRS{LOW}};
                PinIf.tap_rtdr_capture    = {MAX_NUM_OF_RTDRS{LOW}};
                PinIf.tap_rtdr_shift      = {MAX_NUM_OF_RTDRS{LOW}};
                PinIf.tap_rtdr_update     = {MAX_NUM_OF_RTDRS{LOW}};
                PinIf.tap_rtdr_irdec      = {MAX_NUM_OF_RTDRS{LOW}};
                PinIf.tap_rtdr_powergood  =  LOW;
                PinIf.tap_rtdr_selectir   =  LOW;
                PinIf.tap_rtdr_rti        =  LOW;
                PinIf.tap_rtdr_prog_rst_b = {MAX_NUM_OF_RTDRS{LOW}};
            end    

            //------------------------------------------------------
            // The Park at Feature should only be activated after on clock cycle
            // as inital state of clock is  LOW as per spec
            //------------------------------------------------------
            begin
                PinIf.park_at_local =  LOW;
                @(posedge PinIf.jtagbfm_clk);
                @(negedge PinIf.jtagbfm_clk);
                PinIf.park_at_local =  park_clk_at;
            end
            //------------------------------------------------------
            //Cast The Sequencer Request and Call The Drive Task
            //------------------------------------------------------
            forever begin
                seq_item_port.get_next_item(req);
                $cast(Packet,req);
                drive_item(Packet);
                seq_item_port.item_done(Packet);
            end // Forever

            //------------------------------------------------------
            //FSM Task Call
            //------------------------------------------------------
            forever begin
               if(use_rtdr_interface == 1'b0) begin
                  @(posedge PinIf.tck or negedge PinIf.powergood_rst_b or negedge PinIf.trst_b); 
                  tap_fsm;
               end
               else
               begin
                  @(posedge PinIf.tap_rtdr_tck or negedge PinIf.tap_rtdr_powergood or negedge PinIf.trst_b); 
                  tap_fsm;
               end
            end
            //------------------------------------------------------
            //FSM Task Call
            //------------------------------------------------------
            forever begin
               drive_tap_rtdr_ir;
            end
            //https://hsdes.intel.com/resource/22096586
            //forever begin
            //   drive_tap_rtdr_dr;
            //end
            //forever begin
            //   drive_tap_rtdr_rti;
            //end

            //------------------------------------------------------
            // Task Call For Turning The Enable Clock Gating Off
            //------------------------------------------------------
            forever begin
                turn_clk_off;  
            end

            //------------------------------------------------------
            // Task Call For Clock Gating when Idle
            //------------------------------------------------------
            //forever begin
            //    clk_gate;
            //end         
            
            //forever begin
            //    rtdr_clk_gate;
            //end         
            //forever begin
            //    assert_tdo;  

            //end         

        join_any
    endtask : run

    //--------------------------------------------------------------
    // Main Task under Run to drive the JTAG Pins in accordance with
    // the Sequence Packets
    //--------------------------------------------------------------
    task drive_item(input JtagBfmSeqDrvPkt Packet);
       begin
            addr                    = Packet.Address;
            data                    = Packet.Data;
            flag                    = Packet.ResetMode;
            function_select_int     = Packet.FunctionSelect;
            ext_function_select_int = Packet.Extended_FunctionSelect; 
            addr_len                = Packet.addr_len;
            data_len                = Packet.data_len;
            pause_len               = Packet.pause_len;
            count                   = Packet.Count;
            tms_stream              = Packet.TMS_Stream;
            tdi_stream              = Packet.TDI_Stream;            
            expected_addr           = Packet.Expected_Address;
            expected_data           = Packet.Expected_Data;
            mask_addr               = Packet.Mask_Address;
            mask_data               = Packet.Mask_Data;
            mask_capture            = Packet.Mask_Capture;
            force_reset_state       = Packet.Address[0];
            rtdr_irdec_position     = Packet.Address;
            #0 select_function(function_select_int, ext_function_select_int);
       end
    endtask // drive_item

    //*******************************************************
    // Selecting different Reset's depending upon first 
    // Argument in each API
    //*******************************************************
    task rst_tap();
      case(flag)
        2'b01 : tap_reset;
        2'b11 : tap_pwr_reset;
        2'b10 : begin
                  tap_goto(TLRS, 6);
                  if(enable_rtdr_reset == 1'b0 && use_rtdr_interface == 1'b1) begin
                     PinIf.tap_rtdr_irdec <= {MAX_NUM_OF_RTDRS{LOW}};
                  end
                end
      endcase  
    endtask // rst_tap
           
    //*******************************************************
    // Selecting different Driver Sub Task for each API
    //*******************************************************
    task select_function(input bit [2:0] lcl_function_select_int, input bit [1:0] lcl_ext_function_select_int );
    string msg;
    begin
      unique case({lcl_ext_function_select_int,lcl_function_select_int}) 
          5'b00_000: begin
                       $swrite (msg, "\n**ResetMode Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       rst_tap();                 
                     end
          5'b00_001: begin
                       $swrite (msg, "\n**Goto Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       state = addr[3:0];
                       tap_goto(state, count);
                     end
          5'b00_010: begin
                       $swrite (msg, "\n**LoadIR Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       enable_rtdr_reset = 1'b1;
                       rst_tap();                 
                       tap_loadir_pair(addr,addr_len,expected_addr,mask_addr);
                       enable_rtdr_reset = 1'b0;
                     end   
          5'b11_000: begin // https://hsdes.intel.com/home/default.html/article?id=1018012221 - Added 27Mar14 for matching ITPP opcode on Tester
                       $swrite (msg, "\n**LoadIR_E1IR Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       enable_rtdr_reset = 1'b1;
                       rst_tap();
                       tap_loadir(addr,addr_len);
                       enable_rtdr_reset = 1'b0;
                     end                     
          5'b00_111: begin
                       $swrite (msg, "\n**LoadDR Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       enable_rtdr_reset = 1'b1;
                       rst_tap();                 
                       tap_loaddr_padr(data,data_len,expected_data,mask_data);
                       enable_rtdr_reset = 1'b0;
                     end
          5'b11_001: begin // https://hsdes.intel.com/home/default.html/article?id=1018012221 - Added 27Mar14 for matching ITPP opcode on Tester
                       $swrite (msg, "\n**LoadDR_E1DR Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       enable_rtdr_reset = 1'b1;
                       rst_tap();
                       tap_loaddr_e1dr(data,data_len,expected_data,mask_data);
                       enable_rtdr_reset = 1'b0;
                     end
          5'b10_001: begin
                       $swrite (msg, "\n**LoadDrWithReturnTdoShortPath Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       enable_rtdr_reset = 1'b1;
                       rst_tap();                 
                       tap_loaddr_ruti(data,data_len,expected_data,mask_data);
                       enable_rtdr_reset = 1'b0;
                     end
          5'b00_100: begin
                       $swrite (msg, "\n**tms_tdi_stream Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       tms_tdi_stream(tms_stream,tdi_stream,count);
                     end
          5'b00_101: begin
                       $swrite (msg, "\n**Idle Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       idle(count);
                     end
          5'b00_110: begin
                       $swrite (msg, "\n**MultipleTapRegisterAccess Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       rst_tap();                 
                       tap_loadir(addr,addr_len);
                       tap_goto(RUTI, 1);
                       tap_loaddr(data, data_len);
                       tap_goto(RUTI, 1);
                     end
          5'b01_000: begin
                       $swrite (msg, "\n**ForceReset Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       tap_force_reset(flag,force_reset_state);
                     end
          5'b01_001: begin
                       $swrite (msg, "\n**ForceClockGatingOff Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       PinIf.force_clk_gating_off    = Packet.clk_gating_off;
                     end
          5'b01_010: begin
                       $swrite (msg, "\n**LoadIR_Idle Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       enable_rtdr_reset = 1'b1;
                       rst_tap();                 
                       tap_loadir_ruti(addr,addr_len,expected_addr,mask_addr);
                       enable_rtdr_reset = 1'b0;
                     end
          5'b01_011: begin
                       $swrite (msg, "\n**LoadDR_Idle Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       enable_rtdr_reset = 1'b1;
                       rst_tap();                 
                       tap_loaddr_ruti(data,data_len,expected_data,mask_data);
                       enable_rtdr_reset = 1'b0;
                     end
          5'b01_111: begin
                       $swrite (msg, "\n**LoadDR_Pause Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       enable_rtdr_reset = 1'b1;
                       rst_tap();                 
                       tap_loaddr_delay_padr(data,data_len,expected_data,mask_data,pause_len);
                       enable_rtdr_reset = 1'b0;
                     end
          5'b00_011: begin
                       $swrite (msg, "\n**ExpData_MultipleTapRegisterAccess Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       rst_tap();                 
                       tap_loadir_pair(addr,addr_len,0,0);
                       tap_loaddr_padr(data,data_len,expected_data,mask_data);
                     end
          5'b01_110: begin
                       $swrite (msg, "\n**ReturnTDO_ExpData_MultipleTapRegisterAccess Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       rst_tap();                 
                       tap_loadir_pair(addr,addr_len,0,0);
                       tap_loaddr_padr(data,data_len,expected_data,mask_data);
                      end
          // 05-Mar-2015 : Added below case-select 5'b01_101 for : PCR https://hsdes.intel.com/home/default.html#article?id=1205378989
          5'b01_101: begin
                       $swrite (msg, "\n**CTV_ReturnTDO_ExpData_MultipleTapRegisterAccess Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       rst_tap();                 
                       tap_loadir_pair(addr,addr_len,0,0);
                       tap_loaddr_ctv_padr(data,data_len,expected_data,mask_data,mask_capture);
                      end
          5'b10_110: begin
                       $swrite (msg, "\n**ReturnTDO_ExpData_MultipleTapRegisterAccessRuti Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       rst_tap();                 
                       tap_loadir_ruti(addr,addr_len,0,0);
                       tap_loaddr_ruti(data,data_len,expected_data,mask_data);
                      end
          5'b10_111: begin
                       $swrite (msg, "\n**LoadDrWithReturnTdo Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       enable_rtdr_reset = 1'b1;
                       rst_tap();                 
                       tap_loaddr_padr(data,data_len,expected_data,mask_data);
                       tap_goto(RUTI, 1);
                       enable_rtdr_reset = 1'b0;
                     end                     
          5'b11_111: begin
                       $swrite (msg, "\n**LoadDrWithReturnTdoEndStatePause Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       enable_rtdr_reset = 1'b1;
                       rst_tap();                 
                       tap_loaddr_padr(data,data_len,expected_data,mask_data);
                       enable_rtdr_reset = 1'b0;
                     end
          5'b01_100: begin
                       data_local =  $random();
                       $swrite (msg, "\n**MultipleTapRegisterAccessRand Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       rst_tap();                 
                       tap_loadir(addr,addr_len);
                       tap_goto(RUTI, 1);
                       tap_loaddr(data_local, data_len);
                       tap_goto(RUTI, 1);
                     end
         default: begin
                       $swrite (msg, "\n**ExpData_MultipleTapRegisterAccess Selected by Sequencer");
                       `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       rst_tap();                 
                       tap_loadir_pair(addr,addr_len,0,0);
                       tap_loaddr_padr(data,data_len,expected_data,mask_data);
                  end

        endcase // case ({ext_function_select_int,function_select_int})
    end
    endtask   
    //*******************************************************
    // To Gate the clock if the Clock Gate Config is Enabled
    // and PinIf.turn_clk_on is '0'
    //*******************************************************
  //  task clk_gate;
  //       if(PinIf.turn_clk_on == 1'b1)begin
  //           PinIf.tck = PinIf.jtagbfm_clk;
  //       end else if(PinIf.en_clk_gating == 1'b0) begin
  //           PinIf.tck = PinIf.jtagbfm_clk;
  //       end else if(PinIf.force_clk_gating_off == 1'b1) begin // HSD 2901749   
  //           PinIf.tck = PinIf.jtagbfm_clk;
  //       end else begin
  //           PinIf.tck = PinIf.park_at_local;
  //       end
  //       @(PinIf.jtagbfm_clk);
  //  endtask : clk_gate
    
    //task rtdr_clk_gate;
    //     if(PinIf.turn_clk_on == 1'b1)begin
    //         PinIf.tap_rtdr_tck = PinIf.jtagbfm_clk;
    //     end else if(enable_clk_gating == 1'b0) begin
    //         PinIf.tap_rtdr_tck = PinIf.jtagbfm_clk;
    //     end else if(PinIf.force_clk_gating_off == 1'b1) begin // HSD 2901749   
    //         PinIf.tap_rtdr_tck = PinIf.jtagbfm_clk;
    //     end else begin
    //         PinIf.tap_rtdr_tck = PinIf.park_at_local;
    //     end
    //     @(PinIf.jtagbfm_clk);
    //endtask : rtdr_clk_gate
    //task assert_tdo;
    //            if(sample_tdo_on_negedge==1)begin
    //                property bfmintf_tap_assert_tdo_during_posedge_clk;
    //                   //@(tdo)
    //                   @(PinIf.tdo_delayed_by_1ps)
    //                     disable iff ((PinIf.powergood_rst_b == LOW) || (PinIf.trst_b == LOW))
    //                     //((bfm_shift_states) && (tms == LOW)) |-> (tck == HIGH);
    //                     ((PinIf.bfm_shift_states) && (PinIf.tms == LOW)) |-> (PinIf.tck == LOW);
    //                endproperty: bfmintf_tap_assert_tdo_during_posedge_clk

    //                chk_bfmintf_tap_assert_tdo_during_posedge_clk_0:
    //                assert property (bfmintf_tap_assert_tdo_during_posedge_clk)
    //                else $error ("ERROR: JtagBfmPinIf: TDO is not asserted at negedge of tck, but asserted at posedge");
    //           end
    //           else begin
    //              property bfmintf_tap_assert_tdo_during_negedge_clk;
    //                 //@(tdo)
    //                 @(PinIf.tdo_delayed_by_1ps)
    //                   disable iff ((PinIf.powergood_rst_b == LOW) || (PinIf.trst_b == LOW))
    //                   ((PinIf.bfm_shift_states) && (PinIf.tms == LOW)) |-> (PinIf.tck == HIGH);
    //              endproperty: bfmintf_tap_assert_tdo_during_negedge_clk

    //              chk_bfmintf_tap_assert_tdo_during_negedge_clk_0:
    //              assert property (bfmintf_tap_assert_tdo_during_negedge_clk)
    //              else $error ("ERROR: JtagBfmPinIf: TDO is not asserted at negedge of tck, but asserted at negedge");
    //           end
    //endtask : assert_tdo

    //*******************************************************
    // To disable PinIf.turn_clk_on at each posedge of set_clk_off
    //*******************************************************
    task turn_clk_off;
        @(posedge set_clk_off);
        if(set_clk_off == 1'b1) begin
            PinIf.turn_clk_on = 1'b0;
        end
    endtask : turn_clk_off

    //*******************************************************
    // Force Reset Task
    //*******************************************************
    task tap_force_reset;
        string      msg;
        input [1:0] reset_mode;
        input       force_state;
        begin
        $swrite (msg, "\nForce Reset to be Done Current State: %s",StrFSMState(current_state));
        `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            if(reset_mode == 2'b01) begin
                 PinIf.trst_b = force_state;
            end else if(reset_mode == 2'b11) begin
                 PinIf.bfm_powergood_rst_b = force_state;
            end
        end
    endtask : tap_force_reset  

    //*******************************************
    // Start of tap_reset Task
    // Go to Test Logic Reset by toggling trst
    //*******************************************
    task tap_reset;
        string msg;
        $swrite (msg, "\nHard Reset to be Done Current State: %s",StrFSMState(current_state));
        `ovm_info (get_type_name(), msg, OVM_MEDIUM);
        PinIf.turn_clk_on = 1'b1;
        set_clk_off = 1'b0;        
        randomize() with {delay_factor dist {1:=5,2:=5,3:=2};} ;
        @(negedge PinIf.tck) begin
            PinIf.tms <= HIGH;
            #(RESET_DELAY/delay_factor);
            $swrite (msg, "\nRESET_DELAY = %d, delay_factor = %d", RESET_DELAY, delay_factor);
            `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            PinIf.trst_b <= LOW;
            if(enable_rtdr_reset == 1'b1 && use_rtdr_interface == 1'b1) begin
               PinIf.tap_rtdr_prog_rst_b[rtdr_irdec_position] <= LOW;
               PinIf.tap_rtdr_irdec[rtdr_irdec_position] <= LOW;
            end
            if(enable_rtdr_reset == 1'b0 && use_rtdr_interface == 1'b1) begin
               PinIf.tap_rtdr_irdec <= {MAX_NUM_OF_RTDRS{LOW}};
               PinIf.tap_rtdr_prog_rst_b <= {MAX_NUM_OF_RTDRS{LOW}};
            end
        end
        randomize() with {delay_factor dist {1:=5,2:=5,3:=2};} ;
        @(posedge PinIf.tck);
        @(negedge PinIf.tck);
        //#(RESET_DELAY/delay_factor); https://hsdes.intel.com/appstore/article/#/1304772351/main
        $swrite (msg, "\nRESET_DELAY = %d, delay_factor = %d", RESET_DELAY, delay_factor);
        `ovm_info (get_type_name(), msg, OVM_MEDIUM);
        if(enable_rtdr_reset == 1'b1 && use_rtdr_interface == 1'b1) begin
           PinIf.tap_rtdr_prog_rst_b[rtdr_irdec_position] <= HIGH;
        end
        if(enable_rtdr_reset == 1'b0 && use_rtdr_interface == 1'b1) begin
            PinIf.tap_rtdr_prog_rst_b <= {MAX_NUM_OF_RTDRS{HIGH}};
        end
        PinIf.trst_b <= HIGH;
        @(negedge PinIf.tck);
        set_clk_off = 1'b1;
        
        $swrite (msg, "\nHard Reset Done Current State: %s",StrFSMState(current_state));
        `ovm_info (get_type_name(), msg, OVM_MEDIUM);

    endtask : tap_reset

    //*******************************************
    // Start of tap_pwr_reset Task
    // Go to Test Logic Reset by toggling power_rst
    //*******************************************
    task tap_pwr_reset;
        string msg;
        $swrite (msg, "\nHard Power Reset to be Done Current State: %s",StrFSMState(current_state));
        `ovm_info (get_type_name(), msg, OVM_MEDIUM);
        PinIf.turn_clk_on = 1'b1;
        set_clk_off = 1'b0;        
        randomize() with {delay_factor dist {1:=5,2:=5,3:=2};} ;
        @(negedge PinIf.tck) begin
            PinIf.tms <= HIGH;
            #(RESET_DELAY/delay_factor);
            $swrite (msg, "\nRESET_DELAY = %d, delay_factor = %d", RESET_DELAY, delay_factor);
            `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            if(enable_rtdr_reset == 1'b0 && use_rtdr_interface == 1'b1) begin
               PinIf.tap_rtdr_irdec <= {MAX_NUM_OF_RTDRS{LOW}};
               PinIf.tap_rtdr_prog_rst_b <= {MAX_NUM_OF_RTDRS{LOW}};
            end
            PinIf.bfm_powergood_rst_b <= LOW;
        end
        randomize() with {delay_factor dist {1:=5,2:=5,3:=2};} ;
        @(posedge PinIf.tck);
        @(negedge PinIf.tck);
        #(RESET_DELAY/delay_factor);
        PinIf.bfm_powergood_rst_b <= HIGH;
        if(enable_rtdr_reset == 1'b0 && use_rtdr_interface == 1'b1) begin
           PinIf.tap_rtdr_prog_rst_b <= {MAX_NUM_OF_RTDRS{LOW}};
        end
        @(posedge PinIf.tck);
        @(negedge PinIf.tck);
        #(RESET_DELAY/delay_factor);
        @(negedge PinIf.tck);
        set_clk_off = 1'b1;

        
        $swrite (msg, "\nHard Power Reset Done Current State: %0h",current_state);
        `ovm_info (get_type_name(), msg, OVM_MEDIUM);

    endtask : tap_pwr_reset

    //*****************************
    //Task to drive RTDR rti signals
    //*****************************
    task drive_tap_rtdr_rti;
    begin
       if(use_rtdr_interface == 1'b1)
       begin   
          if(current_state == RUTI)
          begin
             PinIf.tap_rtdr_rti <= 1'b1;  
          end
          else
          begin
             PinIf.tap_rtdr_rti <= 1'b0;  
          end    
       end
    end    
    endtask
    //*****************************
    //Task to drive RTDR IR signals
    //*****************************
    task drive_tap_rtdr_ir;
    begin
       @(negedge PinIf.tap_rtdr_tck);
       if(use_rtdr_interface == 1'b1)
       begin//{   
          if(current_state == UPIR)
          begin
             if(rtdr_prev_index !== rtdr_index)
             begin
                PinIf.tap_rtdr_irdec[rtdr_prev_index] <= 1'b0;  
             end
             PinIf.tap_rtdr_irdec[rtdr_index] <= 1'b1;  
             rtdr_prev_index = rtdr_index;
          end
          //if(current_state == SIRS)//https://hsdes.intel.com/resource/22096586
          //begin
          //   PinIf.tap_rtdr_selectir <= 1'b1; 
          //end    
          //else if(current_state == UPIR)
          //begin
          //   PinIf.tap_rtdr_selectir <= 1'b0; 
          //end    
       end//}
       else begin
          if(current_state == UPIR)
          begin
             PinIf.tap_ir_reg <= PinIf.shift_ir_reg;
          end
       end
    end    
    endtask    
    
    //*****************************
    //Task to drive RTDR IR signals
    //*****************************
    task drive_tap_rtdr_dr;
    integer i;
    begin
       if(use_rtdr_interface == 1'b1)
       begin    
          if(rtdr_is_bussed == 1'b1)
          begin
             if(current_state == CADR)
             begin
                PinIf.tap_rtdr_capture[0] <= 1'b1;  
             end
             else    
             begin
                PinIf.tap_rtdr_capture[0] <= 1'b0;  
             end    
             if(current_state == SHDR)
             begin
                PinIf.tap_rtdr_shift[0] <= 1'b1; 
             end
             else    
             begin
                PinIf.tap_rtdr_shift[0] <= 1'b0; 
             end    
             if(current_state == UPDR)
             begin
                PinIf.tap_rtdr_update[0] <= 1'b1;  
             end 
             else
             begin
                PinIf.tap_rtdr_update[0] <= 1'b0;  
             end 
          end
          else
          begin 
             if(current_state == CADR)
             begin
                PinIf.tap_rtdr_capture[rtdr_index] <= 1'b1;  
             end 
             else   
             begin
                PinIf.tap_rtdr_capture[rtdr_index] <= 1'b0;  
             end    
             if(current_state == SHDR)
             begin
                PinIf.tap_rtdr_shift[rtdr_index] <= 1'b1;  
             end    
             else
             begin
                PinIf.tap_rtdr_shift[rtdr_index] <= 1'b0;  
             end    
             if(current_state == UPDR)
             begin
                PinIf.tap_rtdr_update[rtdr_index] <= 1'b1;
             end
             else
             begin
                PinIf.tap_rtdr_update[rtdr_index] <= 1'b0;
             end
          end   
       end 
    end  
    endtask 

    //*******************
    //FSM Task
    //*******************
    task tap_fsm; begin
        // Added negedge powergood_rst_b condition just like how it is in RTL. 30Aug11.
        // Added negedge          trst_b condition just like how it is in RTL. 25May13. HSD 4964516
        if((!PinIf.trst_b) | (!PinIf.powergood_rst_b)) begin
             current_state = TLRS;
             PinIf.bfm_shift_states <= LOW;
        end 
        else begin//{
            case (current_state)

                TLRS: begin
                   if(PinIf.tms) current_state = TLRS;
                   else current_state = RUTI;
                   PinIf.bfm_shift_states <= LOW;
                end // case: TLRS

                RUTI:begin
                   if(PinIf.tms) current_state = SDRS;
                   else current_state = RUTI;
                   PinIf.bfm_shift_states <= LOW;
                end // case: RUTI

                SDRS: begin
                   if(PinIf.tms) begin 
                      current_state = SIRS;
                      PinIf.tap_rtdr_selectir <= 1'b1; 
                   end
                   else current_state = CADR;
                   PinIf.bfm_shift_states <= LOW;
                end // case: SDRS

                CADR: begin
                   if(PinIf.tms) current_state = E1DR;
                   else current_state = SHDR;
                   PinIf.bfm_shift_states <= LOW;
                end // case: CADR

                SHDR: begin
                   if(PinIf.tms) current_state = E1DR;
                   else current_state = SHDR;
                   PinIf.bfm_shift_states <= HIGH;
                end // case: SHDR

                E1DR: begin
                   if(PinIf.tms) current_state = UPDR;
                   else current_state = PADR;
                   PinIf.bfm_shift_states <= LOW;
                end // case: E1DR

                PADR: begin
                   if(PinIf.tms) current_state = E2DR;
                   else current_state = PADR;
                   PinIf.bfm_shift_states <= LOW;
                end // case: PADR

                E2DR: begin
                   if(PinIf.tms) current_state = UPDR;
                   else current_state = SHDR;
                   PinIf.bfm_shift_states <= LOW;
                end // case: E2DR

                UPDR: begin
                   if(PinIf.tms) current_state = SDRS;
                   else current_state = RUTI;
                   PinIf.bfm_shift_states <= LOW;
                end // case: UPDR

                SIRS: begin
                   if(PinIf.tms) current_state = TLRS;
                   else current_state = CAIR;
                   PinIf.bfm_shift_states <= LOW;
                end // case: SIRS

                CAIR: begin
                   if(PinIf.tms) current_state = E1IR;
                   else current_state = SHIR;
                   PinIf.bfm_shift_states <= LOW;
                end // case: CAIR

                SHIR: begin
                   if(PinIf.tms) current_state = E1IR;
                   else current_state = SHIR;
                   PinIf.bfm_shift_states <= HIGH;
                end // case: SHIR

                E1IR: begin
                   if(PinIf.tms) current_state = UPIR;
                   else current_state = PAIR;
                   PinIf.bfm_shift_states <= LOW;
                end // case: E1IR

                PAIR: begin
                   if(PinIf.tms) current_state = E2IR;
                   else current_state = PAIR;
                   PinIf.bfm_shift_states <= LOW;
                end // case: PAIR

                E2IR: begin
                   if(PinIf.tms) current_state = UPIR;
                   else current_state = SHIR;
                   PinIf.bfm_shift_states <= LOW;
                end // case: E2IR

                UPIR: begin
                   if(PinIf.tms) current_state = SDRS;
                   else current_state = RUTI;
                   PinIf.bfm_shift_states <= LOW;
                   PinIf.tap_rtdr_selectir <= 1'b0; 
                end // case: UPIR

                default: current_state = TLRS;
            endcase
        end//}
        PinIf.display_state_t <= current_state;
        //https://hsdes.intel.com/resource/22096586
        drive_tap_rtdr_dr; 
        drive_tap_rtdr_rti;
    end
    endtask

    //*************************
    // GOTO Task
    //*************************
    task tap_goto;
        input [3:0] toState;          // state to transition to
        //input [7:0] numtimes;       // Cycles to stay in that state.
        //input [15:0] numtimes;      // Cycles to stay in that state. Increased this to a 16-bit counter.
        input int numtimes;           // Cycles to stay in that state. Increased this to a 32-bit signed integer. HSD 2904968.
        reg   [7:0] tms_transitions;  // Holds Bits of tms transitions
        reg   [4*8:1] str;
        integer i, j;
        string      msg;

        begin
            $swrite (msg, "\nIn GOTO Task:\nCurrent State: %s\nTarget  State: %s ",StrFSMState(current_state),StrFSMState(toState));
            `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            PinIf.turn_clk_on = 1'b1;
            set_clk_off = 1'b0;        
            case (toState)
                TLRS: begin str = "TLRS"; end
                RUTI: begin str = "RUTI"; end
                SDRS: begin str = "SDRS"; end
                CADR: begin str = "CADR"; end
                SHDR: begin str = "SHDR"; end
                E1DR: begin str = "E1DR"; end
                PADR: begin str = "PADR"; end
                E2DR: begin str = "E2DR"; end
                UPDR: begin str = "UPDR"; end
                SIRS: begin str = "SIRS"; end
                CAIR: begin str = "CAIR"; end
                SHIR: begin str = "SHIR"; end
                E1IR: begin str = "E1IR"; end
                PAIR: begin str = "PAIR"; end
                E2IR: begin str = "E2IR"; end
                UPIR: begin str = "UPIR"; end
            endcase // case(toState)
            

            case (current_state)
                TLRS: begin tms_transitions = TLRS_goto(toState); end
                RUTI: begin tms_transitions = RUTI_goto(toState); end
                SDRS: begin tms_transitions = SDRS_goto(toState); end
                CADR: begin tms_transitions = CADR_goto(toState); end
                SHDR: begin tms_transitions = SHDR_goto(toState); end
                E1DR: begin tms_transitions = E1DR_goto(toState); end
                PADR: begin tms_transitions = PADR_goto(toState); end
                E2DR: begin tms_transitions = E2DR_goto(toState); end
                UPDR: begin tms_transitions = UPDR_goto(toState); end
                SIRS: begin tms_transitions = SIRS_goto(toState); end
                CAIR: begin tms_transitions = CAIR_goto(toState); end
                SHIR: begin tms_transitions = SHIR_goto(toState); end
                E1IR: begin tms_transitions = E1IR_goto(toState); end
                PAIR: begin tms_transitions = PAIR_goto(toState); end
                E2IR: begin tms_transitions = E2IR_goto(toState); end
                UPIR: begin tms_transitions = UPIR_goto(toState); end
            endcase // case(current_state)

            // check if you are already in the goto state
            if(current_state == toState) begin
                j = 1;  //going from one state to the same state in a feedback.
            end  
            begin: transitions
                for(i = 0; i <= PATH_WIDTH; i = i+1) begin
                    if(tms_transitions[i] !== 1'bx) begin
                        // Changing state from TLRS/RUTI/PADR/PAIR to other state with respect to negedge of tck
                        // https://hsdes.intel.com/home/default.html/article?id=1604207734 
                        if((current_state == TLRS || current_state == RUTI || current_state == PADR || current_state == PAIR)
                           && (current_state !== toState))
                        @(negedge  PinIf.tck);
                        PinIf.tms <= tms_transitions[i];
                        j = i +1;
                    end // if (tms_transitions[i] !== 1'bx)
                    if(current_state == toState) break;//disable transitions;
                    @(negedge  PinIf.tck);
                end // for (i = 0; i <= 7; i = i+1)
            end // block: transitions

            // Stay in toState state the number of cycles specified in numtimes if the
            // state has a loop feedback
            if((toState == TLRS || toState == RUTI || toState == SHDR ||
               toState == PADR || toState == SHIR || toState == PAIR) && numtimes > 1) begin
                repeat(numtimes - 1) @(negedge PinIf.tck) PinIf.tms <= tms_transitions[j-1];
                @(posedge PinIf.tck);
                @(negedge PinIf.tck);
            end // if ((toState == TLRS || toState == RUTI || toState == SHDR ||...
            
            set_clk_off = 1'b1;
            $swrite (msg, "\nExiting GOTO Task:\nCurrent State: %s",StrFSMState(current_state));
            `ovm_info (get_type_name(), msg, OVM_MEDIUM);
        end
    endtask : tap_goto

    //********************** start of TLRS_goto function ******************
    // This function will return the shortest path from Test Logic Reset
    // state to any of the other 15  states
    //*********************************************************************
    function [7 : 0] TLRS_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: TLRS_goto = 8'bxxxxxxx1;
                RUTI: TLRS_goto = 8'bxxxxxxx0;
                SDRS: TLRS_goto = 8'bxxxxxx10;
                CADR: TLRS_goto = 8'bxxxxx010;
                SHDR: TLRS_goto = 8'bxxxx0010;
                E1DR: TLRS_goto = 8'bxxxx1010;
                PADR: TLRS_goto = 8'bxxx01010;
                E2DR: TLRS_goto = 8'bxx101010;
                UPDR: TLRS_goto = 8'bxxx11010;
                SIRS: TLRS_goto = 8'bxxxxx110;
                CAIR: TLRS_goto = 8'bxxxx0110;
                SHIR: TLRS_goto = 8'bxxx00110;
                E1IR: TLRS_goto = 8'bxxx10110;
                PAIR: TLRS_goto = 8'bxx010110;
                E2IR: TLRS_goto = 8'bx1010110;
                UPIR: TLRS_goto = 8'bxx110110;
            endcase // case(toState)
        end
    endfunction : TLRS_goto
    //********************** end of TLRS_goto function ********************

    //********************** start of RUTI_goto function ******************
    // This function will return the shortest path from Run Test Idle
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] RUTI_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: RUTI_goto = 8'bxxxxx111;
                RUTI: RUTI_goto = 8'bxxxxxxx0;
                SDRS: RUTI_goto = 8'bxxxxxxx1;
                CADR: RUTI_goto = 8'bxxxxxx01;
                SHDR: RUTI_goto = 8'bxxxxx001;
                E1DR: RUTI_goto = 8'bxxxxx101;
                PADR: RUTI_goto = 8'bxxxx0101;
                E2DR: RUTI_goto = 8'bxxx10101;
                UPDR: RUTI_goto = 8'bxxxx1101;
                SIRS: RUTI_goto = 8'bxxxxxx11;
                CAIR: RUTI_goto = 8'bxxxxx011;
                SHIR: RUTI_goto = 8'bxxxx0011;
                E1IR: RUTI_goto = 8'bxxxx1011;
                PAIR: RUTI_goto = 8'bxxx01011;
                E2IR: RUTI_goto = 8'bxx101011;
                UPIR: RUTI_goto = 8'bxxx11011;
            endcase // case(toState)
        end
    endfunction : RUTI_goto
    //********************** end of RUTI_goto function *********************

    //********************** start of SDRS_goto function ******************
    // This function will return the shortest path from Select DR Scan
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] SDRS_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: SDRS_goto = 8'bxxxxxx11;
                RUTI: SDRS_goto = 8'bxxxxx011;
                SDRS: SDRS_goto = 8'bxxxx1011;
                CADR: SDRS_goto = 8'bxxxxxxx0;
                SHDR: SDRS_goto = 8'bxxxxxx00;
                E1DR: SDRS_goto = 8'bxxxxxx10;
                PADR: SDRS_goto = 8'bxxxxx010;
                E2DR: SDRS_goto = 8'bxxxx1010;
                UPDR: SDRS_goto = 8'bxxxxx110;
                SIRS: SDRS_goto = 8'bxxxxxxx1;
                CAIR: SDRS_goto = 8'bxxxxxx01;
                SHIR: SDRS_goto = 8'bxxxxx001;
                E1IR: SDRS_goto = 8'bxxxxx101;
                PAIR: SDRS_goto = 8'bxxxx0101;
                E2IR: SDRS_goto = 8'bxxx10101;
                UPIR: SDRS_goto = 8'bxxxx1101;
            endcase // case(toState)
        end
    endfunction : SDRS_goto
    //********************** end of SDRS_goto function *********************

    //********************** start of CADR_goto function ******************
    // This function will return the shortest path from Capture DR
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] CADR_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: CADR_goto = 8'bxxx11111;
                RUTI: CADR_goto = 8'bxxxxx011;
                SDRS: CADR_goto = 8'bxxxxx111;
                CADR: CADR_goto = 8'bxxxx0111;
                SHDR: CADR_goto = 8'bxxxxxxx0;
                E1DR: CADR_goto = 8'bxxxxxxx1;
                PADR: CADR_goto = 8'bxxxxxx01;
                E2DR: CADR_goto = 8'bxxxxx101;
                UPDR: CADR_goto = 8'bxxxxxx11;
                SIRS: CADR_goto = 8'bxxxx1111;
                CAIR: CADR_goto = 8'bxxx01111;
                SHIR: CADR_goto = 8'bxx001111;
                E1IR: CADR_goto = 8'bxx101111;
                PAIR: CADR_goto = 8'bx0101111;
                E2IR: CADR_goto = 8'b10101111;
                UPIR: CADR_goto = 8'bx1101111;
            endcase // case(toState)
        end
    endfunction : CADR_goto
    //********************** end of CADR_goto function *********************

    //********************** start of SHDR_goto function ******************
    // This function will return the shortest path from Shift DR
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] SHDR_goto;
        input[STATE_BITS  : 0] toState;

        begin
            SHDR_goto = CADR_goto(toState);
        end
    endfunction : SHDR_goto
    //********************* end of SHDR_goto function *********************

    //********************* start of E1DR_goto function ******************
    //This function will return the shortest path from Exit1 DR
    //state to any of the other 15  states
    //********************************************************************
    function [PATH_WIDTH : 0] E1DR_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: E1DR_goto = 8'bxxxx1111;
                RUTI: E1DR_goto = 8'bxxxxxx01;
                SDRS: E1DR_goto = 8'bxxxxxx11;
                CADR: E1DR_goto = 8'bxxxxx011;
                SHDR: E1DR_goto = 8'bxxxxx010;
                E1DR: E1DR_goto = 8'bxxxx1010;
                PADR: E1DR_goto = 8'bxxxxxxx0;
                E2DR: E1DR_goto = 8'bxxxxxx10;
                UPDR: E1DR_goto = 8'bxxxxxxx1;
                SIRS: E1DR_goto = 8'bxxxxx111;
                CAIR: E1DR_goto = 8'bxxxx0111;
                SHIR: E1DR_goto = 8'bxxx00111;
                E1IR: E1DR_goto = 8'bxxx10111;
                PAIR: E1DR_goto = 8'bxx010111;
                E2IR: E1DR_goto = 8'bx1010111;
                UPIR: E1DR_goto = 8'bxx110111;
            endcase // case(toState)
        end
    endfunction : E1DR_goto
    //********************** end of E1DR_goto function *********************


    //********************** start of PADR_goto function ******************
    // This function will return the shortest path from Pause DR
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] PADR_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: PADR_goto = 8'bxxx11111;
                RUTI: PADR_goto = 8'bxxxxx011;
                SDRS: PADR_goto = 8'bxxxxx111;
                CADR: PADR_goto = 8'bxxxx0111;
                SHDR: PADR_goto = 8'bxxxxxx01;
                E1DR: PADR_goto = 8'bxxxxx101;
                PADR: PADR_goto = 8'bxxxxxxx0;
                E2DR: PADR_goto = 8'bxxxxxxx1;
                UPDR: PADR_goto = 8'bxxxxxx11;
                SIRS: PADR_goto = 8'bxxxx1111;
                CAIR: PADR_goto = 8'bxxx01111;
                SHIR: PADR_goto = 8'bxx001111;
                E1IR: PADR_goto = 8'bxx101111;
                PAIR: PADR_goto = 8'bx0101111;
                E2IR: PADR_goto = 8'b10101111;
                UPIR: PADR_goto = 8'bx1101111;
            endcase // case(toState)
        end
    endfunction : PADR_goto
    //********************** end of PADR_goto function *********************

    //********************** start of E2DR_goto function ******************
    // This function will return the shortest path from Exit2 DR
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] E2DR_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: E2DR_goto = 8'bxxxx1111;
                RUTI: E2DR_goto = 8'bxxxxxx01;
                SDRS: E2DR_goto = 8'bxxxxxx11;
                CADR: E2DR_goto = 8'bxxxxx011;
                SHDR: E2DR_goto = 8'bxxxxxxx0;
                E1DR: E2DR_goto = 8'bxxxxxx10;
                PADR: E2DR_goto = 8'bxxxxx010;
                E2DR: E2DR_goto = 8'bxxxx1010;
                UPDR: E2DR_goto = 8'bxxxxxxx1;
                SIRS: E2DR_goto = 8'bxxxxx111;
                CAIR: E2DR_goto = 8'bxxxx0111;
                SHIR: E2DR_goto = 8'bxxx00111;
                E1IR: E2DR_goto = 8'bxxx10111;
                PAIR: E2DR_goto = 8'bxx010111;
                E2IR: E2DR_goto = 8'bx1010111;
                UPIR: E2DR_goto = 8'bxx110111;
            endcase // case(toState)
        end
    endfunction : E2DR_goto
    //********************** end of E2DR_goto function *********************

    //********************** start of UPDR_goto function ******************
    // This function will return the shortest path from Update DR
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] UPDR_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: UPDR_goto = 8'bxxxxx111;
                RUTI: UPDR_goto = 8'bxxxxxxx0;
                SDRS: UPDR_goto = 8'bxxxxxxx1;
                CADR: UPDR_goto = 8'bxxxxxx01;
                SHDR: UPDR_goto = 8'bxxxxx001;
                E1DR: UPDR_goto = 8'bxxxxx101;
                PADR: UPDR_goto = 8'bxxxx0101;
                E2DR: UPDR_goto = 8'bxxx10101;
                UPDR: UPDR_goto = 8'bxxxx1101;
                SIRS: UPDR_goto = 8'bxxxxxx11;
                CAIR: UPDR_goto = 8'bxxxxx011;
                SHIR: UPDR_goto = 8'bxxxx0011;
                E1IR: UPDR_goto = 8'bxxxx1011;
                PAIR: UPDR_goto = 8'bxxx01011;
                E2IR: UPDR_goto = 8'bxx101011;
                UPIR: UPDR_goto = 8'bxxx11011;
            endcase // case(toState)
        end
    endfunction : UPDR_goto
    //********************** end of UPDR_goto function *********************


    //********************** start of SIRS_goto function ******************
    // This function will return the shortest path from Select IR Scan
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] SIRS_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: SIRS_goto = 8'bxxxxxxx1;
                RUTI: SIRS_goto = 8'bxxxxxx01;
                SDRS: SIRS_goto = 8'bxxxxx101;
                CADR: SIRS_goto = 8'bxxxx0101;
                SHDR: SIRS_goto = 8'bxxx00101;
                E1DR: SIRS_goto = 8'bxxx10101;
                PADR: SIRS_goto = 8'bxx010101;
                E2DR: SIRS_goto = 8'bx1010101;
                UPDR: SIRS_goto = 8'bxx110101;
                SIRS: SIRS_goto = 8'bxxxx1101;
                CAIR: SIRS_goto = 8'bxxxxxxx0;
                SHIR: SIRS_goto = 8'bxxxxxx00;
                E1IR: SIRS_goto = 8'bxxxxxx10;
                PAIR: SIRS_goto = 8'bxxxxx010;
                E2IR: SIRS_goto = 8'bxxxx1010;
                UPIR: SIRS_goto = 8'bxxxxx110;
            endcase // case(toState)
        end
    endfunction : SIRS_goto
    //********************** end of SIRS_goto function *********************

    //********************** start of CAIR_goto function ******************
    // This function will return the shortest path from Capture IR
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] CAIR_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: CAIR_goto = 8'bxxx11111;
                RUTI: CAIR_goto = 8'bxxxxx011;
                SDRS: CAIR_goto = 8'bxxxxx111;
                CADR: CAIR_goto = 8'bxxxx0111;
                SHDR: CAIR_goto = 8'bxxx00111;
                E1DR: CAIR_goto = 8'bxxx10111;
                PADR: CAIR_goto = 8'bxx010111;
                E2DR: CAIR_goto = 8'bx1010111;
                UPDR: CAIR_goto = 8'bxx110111;
                SIRS: CAIR_goto = 8'bxxxx1111;
                CAIR: CAIR_goto = 8'bxxx01111;
                SHIR: CAIR_goto = 8'bxxxxxxx0;
                E1IR: CAIR_goto = 8'bxxxxxxx1;
                PAIR: CAIR_goto = 8'bxxxxxx01;
                E2IR: CAIR_goto = 8'bxxxxx101;
                UPIR: CAIR_goto = 8'bxxxxxx11;
            endcase // case(toState)
        end
    endfunction : CAIR_goto
    //********************** end of CAIR_goto function *********************

    //********************** start of SHDR_goto function ******************
    // This function will return the shortest path from Shift IR
    //*********************************************************************
    // state to any of the other 15  states
    function [PATH_WIDTH : 0] SHIR_goto;
        input[STATE_BITS : 0] toState;

        begin
            SHIR_goto = CAIR_goto(toState);
        end
    endfunction : SHIR_goto
    //********************** end of SHDR_goto function *********************

    //********************** start of E1IR_goto function ******************
    // This function will return the shortest path from Exit1 IR
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] E1IR_goto;
        input[STATE_BITS : 0] toState;

        begin
            case (toState)
                TLRS: E1IR_goto = 8'bxxxx1111;
                RUTI: E1IR_goto = 8'bxxxxxx01;
                SDRS: E1IR_goto = 8'bxxxxxx11;
                CADR: E1IR_goto = 8'bxxxxx011;
                SHDR: E1IR_goto = 8'bxxxx0011;
                E1DR: E1IR_goto = 8'bxxxx1011;
                PADR: E1IR_goto = 8'bxxx01011;
                E2DR: E1IR_goto = 8'bxx101011;
                UPDR: E1IR_goto = 8'bxxx11011;
                SIRS: E1IR_goto = 8'bxxxxx111;
                CAIR: E1IR_goto = 8'bxxxx0111;
                SHIR: E1IR_goto = 8'bxxxxx010;
                E1IR: E1IR_goto = 8'bxxxx1010;
                PAIR: E1IR_goto = 8'bxxxxxxx0;
                E2IR: E1IR_goto = 8'bxxxxxx10;
                UPIR: E1IR_goto = 8'bxxxxxxx1;
            endcase // case(toState)
        end
    endfunction : E1IR_goto
    //********************** end of E1IR_goto function *********************

    //********************** start of PAIR_goto function ******************
    // This function will return the shortest path from Pause IR
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] PAIR_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: PAIR_goto = 8'bxxx11111;
                RUTI: PAIR_goto = 8'bxxxxx011;
                SDRS: PAIR_goto = 8'bxxxxx111;
                CADR: PAIR_goto = 8'bxxxx0111;
                SHDR: PAIR_goto = 8'bxxx00111;
                E1DR: PAIR_goto = 8'bxxx10111;
                PADR: PAIR_goto = 8'bxx010111;
                E2DR: PAIR_goto = 8'bx1010111;
                UPDR: PAIR_goto = 8'bxx110111;
                SIRS: PAIR_goto = 8'bxxxx1111;
                CAIR: PAIR_goto = 8'bxxx01111;
                SHIR: PAIR_goto = 8'bxxxxxx01;
                E1IR: PAIR_goto = 8'bxxxxx101;
                PAIR: PAIR_goto = 8'bxxxxxxx0;
                E2IR: PAIR_goto = 8'bxxxxxxx1;
                UPIR: PAIR_goto = 8'bxxxxxx11;
            endcase // case(toState)
        end
    endfunction : PAIR_goto
    //********************** end of PAIR_goto function *********************

    //********************** start of E2IR_goto function ******************
    // This function will return the shortest path from Exit2 IR
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] E2IR_goto;
        input[STATE_BITS  : 0] toState;

        begin
            case (toState)
                TLRS: E2IR_goto = 8'bxxxx1111;
                RUTI: E2IR_goto = 8'bxxxxxx01;
                SDRS: E2IR_goto = 8'bxxxxxx11;
                CADR: E2IR_goto = 8'bxxxxx011;
                SHDR: E2IR_goto = 8'bxxxx0011;
                E1DR: E2IR_goto = 8'bxxxx1011;
                PADR: E2IR_goto = 8'bxxx01011;
                E2DR: E2IR_goto = 8'bxx101011;
                UPDR: E2IR_goto = 8'bxxx11011;
                SIRS: E2IR_goto = 8'bxxxxx111;
                CAIR: E2IR_goto = 8'bxxxx0111;
                SHIR: E2IR_goto = 8'bxxxxxxx0;
                E1IR: E2IR_goto = 8'bxxxxxx10;
                PAIR: E2IR_goto = 8'bxxxxx010;
                E2IR: E2IR_goto = 8'bxxxx1010;
                UPIR: E2IR_goto = 8'bxxxxxxx1;
            endcase // case(toState)
        end
    endfunction : E2IR_goto
    //********************** end of E2IR_goto function *********************

    //********************** start of UPIR_goto function ******************
    // This function will return the shortest path from Update IR
    // state to any of the other 15  states
    //*********************************************************************
    function [PATH_WIDTH : 0] UPIR_goto;
        input[STATE_BITS  : 0] toState;

        begin
            UPIR_goto = UPDR_goto(toState);
        end
    endfunction : UPIR_goto
    //********************** end of UPIR_goto function *********************

    //********************* start of tap_softreset Task *****************
    // Go to Test Reset Logic State by setting tms to 1 for 5
    //*********************************************************************
    task tap_softreset;
        string msg;
        PinIf.turn_clk_on = 1'b1;
        set_clk_off = 1'b0;
        $swrite (msg, "\nSoft Reset to Be Done Current State: %s",StrFSMState(current_state));
        `ovm_info (get_type_name(), msg, OVM_MEDIUM);
        repeat(5) @(negedge  PinIf.tck)  PinIf.tms <= HIGH;
        
        $swrite (msg, "\nSoft Reset Done Current State: %s",StrFSMState(current_state));
        `ovm_info (get_type_name(), msg, OVM_MEDIUM);
        set_clk_off = 1'b1;
    endtask : tap_softreset
    //********************** end of tap_softreset Task ******************

    //********************** Start of tap_loadir procedure ***********************
    // This function will load the instruction register with input instr by shifting
    // the bits into tdi. The procedure performs a goto to the Shift-IR state by 
    // the shortest path. It then loads the instruction register with the 
    // specified instruction and ends in the IDLE state.
    //******************************************************************************
    task tap_loadir;
        input [2*DRV_SIZE_OF_IR_REG - 1 : 0] instr;
        input [2*DRV_SIZE_OF_IR_REG - 1 : 0] addr_size;
        integer   i;
        string    msg;
        begin
            if(use_rtdr_interface == 1'b0)
            begin
               $swrite (msg, "\nLOAD IR with INSTR: %0h",instr);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tck);
               tap_goto(SHIR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= addr_size-1 ; i = i +1) begin
                   PinIf.tdi <= instr[i];
                   @(posedge PinIf.tck);
                   PinIf.shift_ir_reg = (PinIf.shift_ir_reg<<1)+instr[addr_size-(i+1)];
                   @(negedge PinIf.tck);
                   if(i == addr_size -2 )
                      PinIf.tms <= HIGH;
                   else
                      PinIf.tms <= LOW;
               end // for (i = 0; i <= DRV_SIZE_OF_IR_REG-1 ; i = i +1)
               PinIf.tms <= HIGH;
               
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD IR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
            else
            begin
               rtdr_index = instr; 
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               tap_goto(SHIR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= HIGH;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= HIGH;
               
               set_clk_off = 1'b1;
            end
        end
    endtask : tap_loadir
    //********************** end of tap_loadir Task ***********************

    //********************** Start of tap_loaddr procedure ***********************
    // This Function will Load the data register. It Performs the GOTO SHDR,
    // shifts the input data and exit in E1DR state
    //****************************************************************************
    task tap_loaddr;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] data;
        input [63 : 0]                            data_size;
        integer   i;
        string    msg;
        begin
            if(use_rtdr_interface == 1'b0)
            begin
               $swrite (msg, "\nTo LOAD DR with Data: %0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tck);
               tap_goto(SHDR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   PinIf.tdi <= data[i];
                   if(data_size == 1)
                       PinIf.tms <= HIGH;
                   @(negedge PinIf.tck);
                   if(i == data_size - 2)
                       PinIf.tms <= HIGH;
                   else
                       PinIf.tms <= LOW;
               end // for
               PinIf.tms <= HIGH;
               
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
            else
            begin
               $swrite (msg, "\nTo LOAD DR with End state PADR with Data: %0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               tap_goto(SHDR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   if(rtdr_is_bussed == 1'b1)
                   begin
                      PinIf.tap_rtdr_tdi[0] <= data[i];
                   end
                   else
                   begin
                      PinIf.tap_rtdr_tdi[rtdr_index] <= data[i];
                   end
                   if(data_size == 1)
                       PinIf.tms <= HIGH;
                   @(negedge PinIf.tap_rtdr_tck);
                   if(i == data_size - 2) begin
                       PinIf.tms <= HIGH;
                   end else begin
                       PinIf.tms <= LOW;
                   end    
               end // for
               PinIf.tms <= HIGH;               
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
        end
    endtask : tap_loaddr

    //***********************************
    // TMS_TDI_STREAM
    //***********************************
    task tms_tdi_stream;
        string            msg;
        input [DRV_TOTAL_DATA_REGISTER_WIDTH-1 : 0]  tms_stream;
        input [DRV_TOTAL_DATA_REGISTER_WIDTH-1 : 0]  tdi_stream;
        input int         width_of_stream;
        begin
            $swrite (msg, "\nTo TMS_TDI_STREAM with \nTMS STREAM: %0d'b%0b\nTDI STREAM: %0d'b%0h\nWidth     : %0d",width_of_stream,tms_stream,width_of_stream,tdi_stream,width_of_stream);
            `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            PinIf.turn_clk_on = 1'b1;
            set_clk_off = 1'b0;
            for(i=0;i<width_of_stream;i++) begin
                @(negedge PinIf.tck);
                PinIf.tms <= tms_stream[i];
                PinIf.tdi <= tdi_stream[i];
            end
            @(negedge PinIf.tck); // 20-Nov-14 https://hsdes.intel.com/home/default.html#article?id=1603916954
            $swrite (msg, "\nTMS_TDI_STREAM Done Current State: %s",StrFSMState(current_state));
            `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            set_clk_off = 1'b1;
        end
    endtask : tms_tdi_stream

    //***********************************
    // IDLE
    //***********************************
    task idle;
        string    msg;
        input int idle_count;
          //PinIf.turn_clk_on = 1'b1;
          //set_clk_off = 1'b0;
        begin
            for(i=0;i<idle_count;i++) begin
                @(negedge PinIf.jtagbfm_clk);
            end
          //@(negedge PinIf.tck);
          //  set_clk_off = 1'b1;
          //  set_clk_off = 1'b1;
            $swrite (msg, "\nIDLE Done Current State: %s",StrFSMState(current_state));
            `ovm_info (get_type_name(), msg, OVM_MEDIUM);
        end
    endtask : idle

    //******************************************************************************
    // SHIR with end state as PAIR
    //******************************************************************************
    task tap_loadir_pair;
        input [2*DRV_SIZE_OF_IR_REG - 1 : 0] instr;
        input [2*DRV_SIZE_OF_IR_REG - 1 : 0] addr_size;
        input [2*DRV_SIZE_OF_IR_REG - 1 : 0] exp_instr;
        input [2*DRV_SIZE_OF_IR_REG - 1 : 0] mask_instr;
        logic [2*DRV_SIZE_OF_IR_REG - 1 : 0] actual_tdo_collected;
        integer   i;
        string    msg;
        begin
            if(use_rtdr_interface == 1'b0)
            begin
               $swrite (msg, "\nLOAD IR  end state PAIR with INSTR: %0h",instr);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               actual_tdo_collected ={(2*DRV_SIZE_OF_IR_REG){1'b0}};
               @(negedge PinIf.tck);
               tap_goto(SHIR, 1);
               if(mask_instr[0] == 1'b1) begin
                  PinIf.tap_tdo_strobe <= HIGH;
               end else begin
                  PinIf.tap_tdo_strobe <= LOW;
               end
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= addr_size-1 ; i = i +1) begin
                   PinIf.tdi <= instr[i];
                   PinIf.exp_tdo <= (mask_instr[i]==1)?exp_instr[i]:1'bz;
                   if(sample_tdo_on_negedge == 0) @(posedge PinIf.tck);
                   PinIf.shift_ir_reg = (PinIf.shift_ir_reg<<1)+instr[addr_size-(i+1)];
                   actual_tdo_collected[i] =  PinIf.tdo;
                   Packet.actual_tdo_collected[i] =  PinIf.tdo;
                   if(mask_instr[i] == 1'b1) begin
                       if(exp_instr[i] !== PinIf.tdo) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_instr[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_instr[i]);
                           `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   if(sample_tdo_on_negedge == 1) begin
                      @(posedge PinIf.tck);
                      if(mask_instr[i+1] == 1'b1 && (i < (addr_size - 1))) begin
                         PinIf.tap_tdo_strobe <= HIGH;
                      end else begin
                         PinIf.tap_tdo_strobe <= LOW;
                      end
                   end
                   @(negedge PinIf.tck);
                   if(sample_tdo_on_negedge == 0) begin
                      if(mask_instr[i+1] == 1'b1 && (i < (addr_size - 1))) begin
                         PinIf.tap_tdo_strobe <= HIGH;
                      end else begin
                         PinIf.tap_tdo_strobe <= LOW;
                      end
                   end
                   if(i == addr_size -2 ) begin
                      PinIf.tms <= HIGH;
                   end else begin
                      PinIf.tms <= LOW;
                   end   
               end // for (i = 0; i <= DRV_SIZE_OF_IR_REG-1 ; i = i +1)
               $swrite (msg, "\nThe Actual TDO Collected: %0h\nThe Expected TDO        : %0h",actual_tdo_collected,exp_instr);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.tms <= LOW;
               @(negedge PinIf.tck);
               PinIf.tms <= LOW;
               PinIf.exp_tdo <= 1'bz;
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD IR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
            else
            begin
               rtdr_index = instr; 
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               tap_goto(SHIR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= HIGH;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= LOW;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= LOW;
               
               set_clk_off = 1'b1;
            end
        end
    endtask : tap_loadir_pair
    //********************** end of tap_loadir Task ***********************

    //******************************************************************************
    // HSD:   SHIR with end state as IDLE. Implemented on 17-Jul-10
    //******************************************************************************
    task tap_loadir_ruti;
        input [2*DRV_SIZE_OF_IR_REG - 1 : 0] instr;
        input [2*DRV_SIZE_OF_IR_REG - 1 : 0] addr_size;
        input [2*DRV_SIZE_OF_IR_REG - 1 : 0] exp_instr;
        input [2*DRV_SIZE_OF_IR_REG - 1 : 0] mask_instr;
        logic [2*DRV_SIZE_OF_IR_REG - 1 : 0] actual_tdo_collected;
        integer   i;
        string    msg;
        begin
            if(use_rtdr_interface == 1'b0)
            begin
               $swrite (msg, "\nLOAD IR  end state PAIR with INSTR: %0h",instr);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               actual_tdo_collected ={(2*DRV_SIZE_OF_IR_REG){1'b0}};
               @(negedge PinIf.tck);
               tap_goto(SHIR, 1);

               if(mask_instr[0] == 1'b1) begin
                  PinIf.tap_tdo_strobe <= HIGH;
               end else begin
                  PinIf.tap_tdo_strobe <= LOW;
               end

               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= addr_size-1 ; i = i +1) begin
                   PinIf.tdi <= instr[i];
                   PinIf.exp_tdo <= (mask_instr[i]==1)?exp_instr[i]:1'bz;
                   if(sample_tdo_on_negedge == 0) @(posedge PinIf.tck);
                   PinIf.shift_ir_reg = (PinIf.shift_ir_reg<<1)+instr[addr_size-(i+1)];
                   actual_tdo_collected[i] =  PinIf.tdo;
                   Packet.actual_tdo_collected[i] =  PinIf.tdo;
                   if(mask_instr[i] == 1'b1) begin
                       if(exp_instr[i] !== PinIf.tdo) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_instr[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_instr[i]);
                           `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   if(sample_tdo_on_negedge == 1) begin
                       @(posedge PinIf.tck);
                       if(mask_instr[i+1] == 1'b1 && (i < (addr_size - 1))) begin
                          PinIf.tap_tdo_strobe <= HIGH;
                       end else begin
                          PinIf.tap_tdo_strobe <= LOW;
                       end
                   end   
                   @(negedge PinIf.tck);
                   if(sample_tdo_on_negedge == 0) begin
                      if(mask_instr[i+1] == 1'b1 && (i < (addr_size - 1))) begin
                         PinIf.tap_tdo_strobe <= HIGH;
                      end else begin
                         PinIf.tap_tdo_strobe <= LOW;
                      end
                   end   
                   if(i == addr_size -2 ) begin
                      PinIf.tms <= HIGH;
                   end else begin
                      PinIf.tms <= LOW;
                   end   
               end // for (i = 0; i <= DRV_SIZE_OF_IR_REG-1 ; i = i +1)
               $swrite (msg, "\nThe Actual TDO Collected: %0h\nThe Expected TDO        : %0h",actual_tdo_collected,exp_instr);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);

               PinIf.tms <= HIGH;

               @(negedge PinIf.tck);
               PinIf.tms <= LOW;
               PinIf.exp_tdo <= 1'bz;

               @(negedge PinIf.tck);
               PinIf.tms <= LOW;

               
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD IR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
            else
            begin
               rtdr_index = instr; 
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               tap_goto(SHIR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= HIGH;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= HIGH;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= LOW;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= LOW;
               
               set_clk_off = 1'b1;
            end
        end
    endtask : tap_loadir_ruti
    //********************** end of tap_loadir_ruti Task ***********************

    //****************************************************************************
    // SHDR with end state as PADR instead of UPDR
    //****************************************************************************
    task tap_loaddr_padr;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] data;
        input [63 : 0]                            data_size;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] exp_data;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] mask_data;
        integer i;
        logic [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] actual_tdo_collected;
        string    msg;
        begin
            if(use_rtdr_interface == 1'b0)
            begin
               $swrite (msg, "\nTo LOAD DR with End state PADR with Data: %0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               actual_tdo_collected ={(2*DRV_TOTAL_DATA_REGISTER_WIDTH){1'b0}};
               @(negedge PinIf.tck);
               tap_goto(SHDR, 1);
               if(mask_data[0] == 1'b1) begin
                  PinIf.tap_tdo_strobe <= HIGH;
               end else begin
                  PinIf.tap_tdo_strobe <= LOW;
               end
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   PinIf.tdi <= data[i];
                   PinIf.exp_tdo <= (mask_data[i]==1)?exp_data[i]:1'bz;
                   // For a Data Size of 1, TMS should be driven high to exit SHDR.
                   if(data_size == 1)begin
                       PinIf.tms <= HIGH;
                   end
                   //https://hsdes.intel.com/home/default.html#article?id=1503984885
                   //Added to capture tdo at negedge along with posedge of clock
                   //FIXME
                   //if(sample_tdo_on_negedge == 1) @(negedge PinIf.tck);
                   //else                         @(posedge PinIf.tck);
                   if(sample_tdo_on_negedge == 0) @(posedge PinIf.tck);
                   
                    $swrite (msg, "\nValue of sample_tdo_on_negedge: %b",sample_tdo_on_negedge);
                   `ovm_info (get_type_name(), msg, OVM_NONE);
                   //@(negedge PinIf.tck);
                   //FIXME
                   actual_tdo_collected[i] =  PinIf.tdo;
                   Packet.actual_tdo_collected[i] =  PinIf.tdo;
                   $swrite (msg, "%d Tdo bit collected = 0x%x",i,PinIf.tdo);
                   `ovm_info (get_type_name(), msg, OVM_NONE);
                   if(mask_data[i] == 1'b1) begin
                       if(exp_data[i] !== PinIf.tdo) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_data[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_data[i]);
                          `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   if(sample_tdo_on_negedge == 1) begin
                      @(posedge PinIf.tck);
                      PinIf.exp_tdo <= 1'bz;
                      if(mask_data[i+1] == 1'b1 && (i < (data_size - 1 ))) begin
                         PinIf.tap_tdo_strobe <= HIGH;
                      end else begin
                         PinIf.tap_tdo_strobe <= LOW;
                      end
                   end   
                   //HSD 2903007. TMS should not change on posegde for a 1 bit TDR.
                   //if(data_size == 1)
                   //    PinIf.tms = HIGH;
                   @(negedge PinIf.tck);
                   if(sample_tdo_on_negedge == 0) begin
                      PinIf.exp_tdo <= 1'bz;
                      if(mask_data[i+1] == 1'b1 && (i < (data_size - 1 ))) begin
                         PinIf.tap_tdo_strobe <= HIGH;
                      end else begin
                         PinIf.tap_tdo_strobe <= LOW;
                      end
                   end   
                   if(i == data_size - 2) begin
                       PinIf.tms <= HIGH;
                   end else begin
                       PinIf.tms <= LOW;
                   end
               end // for
               $swrite (msg, "\nThe Actual TDO Collected: %0h\nThe Expected TDO        : %0h",actual_tdo_collected,exp_data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.tms <= LOW;
               @(negedge PinIf.tck);
               PinIf.tms <= LOW;
               
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               end
            else
            begin
               $swrite (msg, "\nTo LOAD DR with End state PADR with Data: %0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               tap_goto(SHDR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   if(rtdr_is_bussed == 1'b1)
                   begin
                      PinIf.tap_rtdr_tdi[0] <= data[i];
                   end
                   else
                   begin
                      PinIf.tap_rtdr_tdi[rtdr_index] <= data[i];
                   end
                   // For a Data Size of 1, TMS should be driven high to exit SHDR.
                   if(data_size == 1)
                       PinIf.tms <= HIGH;
                   if(sample_tdo_on_negedge == 0)
                   begin 
                      actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                      Packet.actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                   end
                   else begin
                      @(posedge PinIf.tap_rtdr_tck);
                      actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                      Packet.actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                   end
                   if(mask_data[i] == 1'b1) begin
                       if(exp_data[i] !== PinIf.tap_rtdr_tdo[rtdr_index]) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual  RTDR_TDO: %b\nExpected RTDR_TDO: %b",i,PinIf.tap_rtdr_tdo[rtdr_index],exp_data[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   RTDR_TDO: %b\nExpected RTDR_TDO: %b",i,PinIf.tap_rtdr_tdo[rtdr_index],exp_data[i]);
                          `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   @(negedge PinIf.tap_rtdr_tck);
                   if(i == data_size - 2) begin
                       PinIf.tms <= HIGH;
                   end else begin
                       PinIf.tms <= LOW;
                   end    
               end // for
               $swrite (msg, "\nThe Actual RTDR_TDO Collected: %0h\nThe Expected RTDR_TDO        : %0h",actual_tdo_collected,exp_data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.tms <= LOW;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= LOW;               
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
        end
    endtask : tap_loaddr_padr

    //*********************************************************************************
    // SHDR with end state as PADR instead of UPDR
    // PCR_TITLE: Jtag BFM - Request for new ExpDataorCapData_MultipleTapRegisterAccess
    // PCR_NO:https://hsdes.intel.com/home/default.html#article?id=1205378989
    // 05-Mar-2015:Added Mask_capture input to calculate strobes for 
    // displaying corresponding bits in LOG file.
    //*********************************************************************************
    task tap_loaddr_ctv_padr;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] data;
        input [63 : 0]                                data_size;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] exp_data;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] mask_data;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] mask_capture;
        integer i;
        logic [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] actual_tdo_collected;
        string    msg;
        begin
            if(use_rtdr_interface == 1'b0)
            begin
               $swrite (msg, "\nTo LOAD DR with End state PADR with Data: %0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               actual_tdo_collected ={(2*DRV_TOTAL_DATA_REGISTER_WIDTH){1'b0}};
               @(negedge PinIf.tck);
               tap_goto(SHDR, 1);
               if(mask_data[0] == 1'b1) begin
                  PinIf.tap_tdo_strobe <= HIGH;
               end else begin
                  PinIf.tap_tdo_strobe <= LOW;
               end
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   PinIf.tdi <= data[i];
                   PinIf.exp_tdo <= (mask_data[i]==1)?exp_data[i]:1'bz;
                   // For a Data Size of 1, TMS should be driven high to exit SHDR.
                   if(data_size == 1)
                       PinIf.tms <= HIGH;
                   //https://hsdes.intel.com/home/default.html#article?id=1503984885
                   //Added to capture tdo at negedge along with posedge of clock
                   if(sample_tdo_on_negedge == 0) @(posedge PinIf.tck);
                   actual_tdo_collected[i] =  PinIf.tdo;
                   Packet.actual_tdo_collected[i] =  PinIf.tdo;
                   if(mask_data[i] == 1'b1) begin
                       if(exp_data[i] !== PinIf.tdo) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_data[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_data[i]);
                          `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   //Added below logic for to display the bits of data based on mask_capture bits.
                   if(mask_capture[i] == 1'b1) begin
                     $swrite (msg,"\nCAPTURE_TDO: The Captured value of bit: %0d is %0b",i,PinIf.tdo);
                     `ovm_info(get_type_name(), msg, OVM_NONE);
                   end
                   if(sample_tdo_on_negedge == 1) begin
                      @(posedge PinIf.tck);
                      if(mask_data[i+1] == 1'b1 && (i < (data_size - 1 ))) begin
                         PinIf.tap_tdo_strobe <= HIGH;
                      end else begin
                         PinIf.tap_tdo_strobe <= LOW;
                      end
                   end   
                   //HSD 2903007. TMS should not change on posegde for a 1 bit TDR.
                   //if(data_size == 1)
                   //    PinIf.tms = HIGH;
                   @(negedge PinIf.tck);
                   if(sample_tdo_on_negedge == 0) begin
                      if(mask_data[i+1] == 1'b1 && (i < (data_size - 1 ))) begin
                         PinIf.tap_tdo_strobe <= HIGH;
                      end else begin
                         PinIf.tap_tdo_strobe <= LOW;
                      end
                   end
                   if(i == data_size - 2) begin
                       PinIf.tms <= HIGH;
                   end else begin
                       PinIf.tms <= LOW;
                   end    
               end // for
               $swrite (msg, "\nThe Actual TDO Collected: %0h\nThe Expected TDO        : %0h",actual_tdo_collected,exp_data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.tms <= LOW;
               @(negedge PinIf.tck);
               PinIf.tms <= LOW;
               PinIf.exp_tdo <= 1'bz;
               
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
            else
            begin
               $swrite (msg, "\nTo LOAD DR with End state PADR with Data: %0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               tap_goto(SHDR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   if(rtdr_is_bussed == 1'b1)
                   begin
                      PinIf.tap_rtdr_tdi[0] <= data[i];
                   end
                   else
                   begin
                      PinIf.tap_rtdr_tdi[rtdr_index] <= data[i];
                   end
                   // For a Data Size of 1, TMS should be driven high to exit SHDR.
                   if(data_size == 1)
                       PinIf.tms <= HIGH;
                   if(sample_tdo_on_negedge == 0)
                   begin 
                      actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                      Packet.actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                   end
                   else begin
                      @(posedge PinIf.tap_rtdr_tck);
                      actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                      Packet.actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                   end
                   if(mask_data[i] == 1'b1) begin
                       if(exp_data[i] !== PinIf.tap_rtdr_tdo[rtdr_index]) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual   RTDR_TDO: %b\nExpected RTDR_TDO: %b",i,PinIf.tap_rtdr_tdo[rtdr_index],exp_data[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   RTDR_TDO: %b\nExpected RTDR_TDO: %b",i,PinIf.tap_rtdr_tdo[rtdr_index],exp_data[i]);
                          `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   if(mask_capture[i] == 1'b1) begin
                     $swrite (msg,"\nCAPTURE_TDO: The Captured value of bit: %0d is %0b",i,PinIf.tap_rtdr_tdo);
                     `ovm_info(get_type_name(), msg, OVM_NONE);
                   end
                   @(negedge PinIf.tap_rtdr_tck);
                   if(i == data_size - 2) begin
                       PinIf.tms <= HIGH;
                   end else begin
                       PinIf.tms <= LOW;
                   end    
               end // for
               $swrite (msg, "\nThe Actual RTDR_TDO Collected: %0h\nThe Expected RTDR_TDO        : %0h",actual_tdo_collected,exp_data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.tms <= LOW;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= LOW;               
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
        end
    endtask : tap_loaddr_ctv_padr

    //****************************************************************************
    // SHDR with end state as E1DR instead of UPDR
    // https://hsdes.intel.com/home/default.html/article?id=1018012221 - Added 27Mar14
    // Addition of LoadIR_E1IR and LoadDR_E1DR API's for matching ITPP opcode on Tester
    //****************************************************************************
    task tap_loaddr_e1dr;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] data;
        input [63 : 0]                            data_size;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] exp_data;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] mask_data;
        integer i;
        logic [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] actual_tdo_collected;
        string    msg;
        begin
            if(use_rtdr_interface == 1'b0)
            begin
               $swrite (msg, "\nTo LOAD DR with End state E1DR with Data: %0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               actual_tdo_collected ={(2*DRV_TOTAL_DATA_REGISTER_WIDTH){1'b0}};
               @(negedge PinIf.tck);
               tap_goto(SHDR, 1);
               if(mask_data[0] == 1'b1) begin
                  PinIf.tap_tdo_strobe <= HIGH;
               end else begin
                  PinIf.tap_tdo_strobe <= LOW;
               end
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   PinIf.tdi <= data[i];
                   PinIf.exp_tdo <= (mask_data[i]==1)?exp_data[i]:1'bz;
                   // For a Data Size of 1, TMS should be driven high to exit SHDR.
                   if(data_size == 1)
                       PinIf.tms <= HIGH;
                   //https://hsdes.intel.com/home/default.html#article?id=1503984885
                   //Added to capture tdo at negedge along with posedge of clock
                   if(sample_tdo_on_negedge == 0) @(posedge PinIf.tck);
                   actual_tdo_collected[i] =  PinIf.tdo;
                   Packet.actual_tdo_collected[i] =  PinIf.tdo;
                   if(mask_data[i] == 1'b1) begin
                       if(exp_data[i] !== PinIf.tdo) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_data[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_data[i]);
                          `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   if(sample_tdo_on_negedge == 1) begin
                      @(posedge PinIf.tck);
                      PinIf.exp_tdo <= 1'bz;
                      if(mask_data[i+1] == 1'b1 && (i < (data_size - 1 ))) begin
                         PinIf.tap_tdo_strobe <= HIGH;
                      end else begin
                         PinIf.tap_tdo_strobe <= LOW;
                      end
                   end
                   //HSD 2903007. TMS should not change on posegde for a 1 bit TDR.
                   //if(data_size == 1)
                   //    PinIf.tms = HIGH;
                   @(negedge PinIf.tck);
                   if(sample_tdo_on_negedge == 0) begin
                       PinIf.exp_tdo <= 1'bz;
                       if(mask_data[i+1] == 1'b1 && (i < (data_size - 1 ))) begin
                          PinIf.tap_tdo_strobe <= HIGH;
                       end else begin
                          PinIf.tap_tdo_strobe <= LOW;
                       end
                   end
                   if(i == data_size - 2) begin
                       PinIf.tms <= HIGH;
                   end else begin
                       PinIf.tms <= LOW;
                   end
               end // for
               $swrite (msg, "\nThe Actual TDO Collected: %0h\nThe Expected TDO        : %0h",actual_tdo_collected,exp_data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
            else
            begin
               $swrite (msg, "\nTo LOAD DR with End state PADR with Data: %0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               tap_goto(SHDR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   if(rtdr_is_bussed == 1'b1)
                   begin
                      PinIf.tap_rtdr_tdi[0] <= data[i];
                   end
                   else
                   begin
                      PinIf.tap_rtdr_tdi[rtdr_index] <= data[i];
                   end
                   // For a Data Size of 1, TMS should be driven high to exit SHDR.
                   if(data_size == 1)
                       PinIf.tms <= HIGH;
                   if(sample_tdo_on_negedge == 0)
                   begin 
                      actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                      Packet.actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                   end
                   else begin
                      @(posedge PinIf.tap_rtdr_tck);
                      actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                      Packet.actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                   end
                   if(mask_data[i] == 1'b1) begin
                       if(exp_data[i] !== PinIf.tap_rtdr_tdo[rtdr_index]) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual   RTDR_TDO: %b\nExpected RTDR_TDO: %b",i,PinIf.tap_rtdr_tdo[rtdr_index],exp_data[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   RTDR_TDO: %b\nExpected RTDR_TDO: %b",i,PinIf.tap_rtdr_tdo[rtdr_index],exp_data[i]);
                          `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   @(negedge PinIf.tap_rtdr_tck);
                   if(i == data_size - 2) begin
                       PinIf.tms <= HIGH;
                   end else begin
                       PinIf.tms <= LOW;
                   end    
               end // for
               $swrite (msg, "\nThe Actual RTDR_TDO Collected: %0h\nThe Expected RTDR_TDO        : %0h",actual_tdo_collected,exp_data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
        end
    endtask : tap_loaddr_e1dr

    //****************************************************************************
    // SHDR with end state as RUTI instead of PADR
    //****************************************************************************
    task tap_loaddr_ruti;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] data;
        input [63 : 0]                            data_size;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] exp_data;
        input [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] mask_data;
        integer i;
        logic [2*DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] actual_tdo_collected;
        string    msg;
        begin
            if(use_rtdr_interface == 1'b0)
            begin
               $swrite (msg, "\nTo LOAD DR with End state PADR with Data:\n%0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               actual_tdo_collected ={(2*DRV_TOTAL_DATA_REGISTER_WIDTH){1'b0}};
               @(negedge PinIf.tck);
               tap_goto(SHDR, 1);
               if(mask_data[0] == 1'b1) begin
                  PinIf.tap_tdo_strobe <= HIGH;
               end else begin
                  PinIf.tap_tdo_strobe <= LOW;
               end
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   PinIf.tdi <= data[i];
                   PinIf.exp_tdo <= (mask_data[i]==1)?exp_data[i]:1'bz;
                   // For a Data Size of 1, TMS should be driven high to exit SHDR.
                   if(data_size == 1)
                       PinIf.tms <= HIGH;
                   //https://hsdes.intel.com/home/default.html#article?id=1503984885
                   //Added to capture tdo at negedge along with posedge of clock
                   if(sample_tdo_on_negedge == 0) @(posedge PinIf.tck);
                   actual_tdo_collected[i] =  PinIf.tdo;
                   Packet.actual_tdo_collected[i] =  PinIf.tdo;
                   if(mask_data[i] == 1'b1) begin
                       if(exp_data[i] !== PinIf.tdo) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_data[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_data[i]);
                           `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   if(sample_tdo_on_negedge == 1) begin
                      @(posedge PinIf.tck);
                      PinIf.exp_tdo <= 1'bz;
                      if(mask_data[i+1] == 1'b1 && (i < (data_size - 1 ))) begin
                         PinIf.tap_tdo_strobe <= HIGH;
                      end else begin
                         PinIf.tap_tdo_strobe <= LOW;
                      end
                   end   
                   //HSD 2903007. TMS should not change on posegde for a 1 bit TDR.
                   //if(data_size == 1)
                   //    PinIf.tms = HIGH;
                   @(negedge PinIf.tck);
                   if(sample_tdo_on_negedge == 0) begin
                      PinIf.exp_tdo <= 1'bz;
                      if(mask_data[i+1] == 1'b1 && (i < (data_size - 1 ))) begin
                         PinIf.tap_tdo_strobe <= HIGH;
                      end else begin
                         PinIf.tap_tdo_strobe <= LOW;
                      end
                   end   
                   if(i == data_size - 2) begin
                       PinIf.tms <= HIGH;
                   end else begin
                       PinIf.tms <= LOW;
                   end    
               end // for
               $swrite (msg, "\nThe Actual TDO Collected: %0h\nThe Expected TDO        : %0h",actual_tdo_collected,exp_data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.tms <= HIGH;
               @(negedge PinIf.tck);
               PinIf.tms <= LOW;
               @(negedge PinIf.tck);
               PinIf.tms <= LOW;
               
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
            else
            begin
               $swrite (msg, "\nTo LOAD DR with End state PADR with Data: %0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               tap_goto(SHDR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   if(rtdr_is_bussed == 1'b1)
                   begin
                      PinIf.tap_rtdr_tdi[0] <= data[i];
                   end
                   else
                   begin
                      PinIf.tap_rtdr_tdi[rtdr_index] <= data[i];
                   end
                   // For a Data Size of 1, TMS should be driven high to exit SHDR.
                   if(data_size == 1)
                       PinIf.tms <= HIGH;
                   if(sample_tdo_on_negedge == 0)
                   begin 
                      actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                      Packet.actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                   end
                   else begin
                      @(posedge PinIf.tap_rtdr_tck);
                      actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                      Packet.actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                   end
                   if(mask_data[i] == 1'b1) begin
                       if(exp_data[i] !== PinIf.tap_rtdr_tdo[rtdr_index]) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual   RTDR_TDO: %b\nExpected RTDR_TDO: %b",i,PinIf.tap_rtdr_tdo[rtdr_index],exp_data[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   RTDR_TDO: %b\nExpected RTDR_TDO: %b",i,PinIf.tap_rtdr_tdo[rtdr_index],exp_data[i]);
                          `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   @(negedge PinIf.tap_rtdr_tck);
                   if(i == data_size - 2) begin
                       PinIf.tms <= HIGH;
                   end else begin
                       PinIf.tms <= LOW;
                   end    
               end // for
               $swrite (msg, "\nThe Actual RTDR_TDO Collected: %0h\nThe Expected RTDR_TDO        : %0h",actual_tdo_collected,exp_data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.tms <= HIGH;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= LOW;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= LOW;               
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
        end
    endtask : tap_loaddr_ruti

    //----------------------------------------------
    // For Async Remote TDR
    // SHDR with end state as PADR instead of UPDR
    // CADR-->E1DR-->PADR(#n)-->E2DR-->
    //                                 SHDR-->E1DR-->PADR
    //----------------------------------------------
    task tap_loaddr_delay_padr;
        input [DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] data;
        input [63 : 0]                          data_size;
        input [DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] exp_data;
        input [DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] mask_data;
        input [63 : 0]                          pause_size;
        integer i;
        logic [DRV_TOTAL_DATA_REGISTER_WIDTH -1 :0] actual_tdo_collected;
        string    msg;
        begin
            if(use_rtdr_interface == 1'b0)
            begin
               $swrite (msg, "\nTo LOAD DR with delay between CADR & SHDR with End state PADR with Data:\n%0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               actual_tdo_collected ={DRV_TOTAL_DATA_REGISTER_WIDTH{1'b0}};
               @(negedge PinIf.tck);
               tap_goto(E1DR, 1);
               tap_goto(PADR, pause_size);
               tap_goto(E2DR, 1);
               tap_goto(SHDR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   PinIf.tdi <= data[i];
                   PinIf.exp_tdo <= (mask_data[i]==1)?exp_data[i]:1'bz;
                   // For a Data Size of 1, TMS should be driven high to exit SHDR.
                   if(data_size == 1)
                       PinIf.tms <= HIGH;
                   //https://hsdes.intel.com/home/default.html#article?id=1503984885
                   //Added to capture tdo at negedge along with posedge of clock
                   if(sample_tdo_on_negedge == 0) @(posedge PinIf.tck);
                   actual_tdo_collected[i] =  PinIf.tdo;
                   Packet.actual_tdo_collected[i] =  PinIf.tdo;
                   if(mask_data[i] == 1'b1) begin
                       if(exp_data[i] !== PinIf.tdo) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_data[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   TDO: %b\nExpected TDO: %b",i,PinIf.tdo,exp_data[i]);
                           `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   //HSD 2903007. TMS should not change on posegde for a 1 bit TDR.
                   //if(data_size == 1)
                   //    PinIf.ftap_tms = HIGH;
                   @(negedge PinIf.tck);
                   PinIf.exp_tdo <= 1'bz;
                   if(i == data_size - 2)
                       PinIf.tms <= HIGH;
                   else
                       PinIf.tms <= LOW;
               end // for
               $swrite (msg, "\nThe Actual Collected TDO: %0h\nThe Expected TDO        : %0h",actual_tdo_collected,exp_data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.tms <= LOW;
               @(negedge PinIf.tck);
               PinIf.tms <= LOW;
               tap_goto(PADR, pause_size);
               
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD Async DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
            else
            begin
               $swrite (msg, "\nTo LOAD DR with End state PADR with Data: %0h",data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               @(negedge PinIf.tap_rtdr_tck);
               tap_goto(E1DR, 1);
               tap_goto(PADR, pause_size);
               tap_goto(E2DR, 1);
               tap_goto(SHDR, 1);
               PinIf.turn_clk_on = 1'b1;
               set_clk_off = 1'b0;
               for(i = 0; i <= data_size - 1 ; i = i +1) begin
                   // tck should be low coming out of tap_goto
                   if(rtdr_is_bussed == 1'b1)
                   begin
                      PinIf.tap_rtdr_tdi[0] <= data[i];
                   end
                   else
                   begin
                      PinIf.tap_rtdr_tdi[rtdr_index] <= data[i];
                   end
                   // For a Data Size of 1, TMS should be driven high to exit SHDR.
                   if(data_size == 1)
                       PinIf.tms <= HIGH;
                   if(sample_tdo_on_negedge == 0)
                   begin 
                      actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                      Packet.actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                   end
                   else begin
                      @(posedge PinIf.tap_rtdr_tck);
                      actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                      Packet.actual_tdo_collected[i] =  PinIf.tap_rtdr_tdo[rtdr_index];
                   end
                   if(mask_data[i] == 1'b1) begin
                       if(exp_data[i] !== PinIf.tap_rtdr_tdo[rtdr_index]) begin
                           $swrite (msg,"\nEXPECTED_TDO_ERROR: The Error at bit: %0d\nActual   RTDR_TDO: %b\nExpected RTDR_TDO: %b",i,PinIf.tap_rtdr_tdo[rtdr_index],exp_data[i]);
                           `ovm_error(get_type_name(), msg);
                       end else begin
                           $swrite (msg, "\nEXPECTED_TDO_MATCH: The Match at bit: %0d\nActual   RTDR_TDO: %b\nExpected RTDR_TDO: %b",i,PinIf.tap_rtdr_tdo[rtdr_index],exp_data[i]);
                          `ovm_info (get_type_name(), msg, OVM_MEDIUM);
                       end
                   end
                   @(negedge PinIf.tap_rtdr_tck);
                   if(i == data_size - 2) begin
                       PinIf.tms <= HIGH;
                   end else begin
                       PinIf.tms <= LOW;
                   end    
               end // for
               $swrite (msg, "\nThe Actual RTDR_TDO Collected: %0h\nThe Expected RTDR_TDO        : %0h",actual_tdo_collected,exp_data);
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
               PinIf.tms <= LOW;
               @(negedge PinIf.tap_rtdr_tck);
               PinIf.tms <= LOW;               
               tap_goto(PADR, pause_size);
               set_clk_off = 1'b1;
               $swrite (msg, "\nLOAD DR Done Current State: %s",StrFSMState(current_state));
               `ovm_info (get_type_name(), msg, OVM_MEDIUM);
            end
        end
    endtask : tap_loaddr_delay_padr

    //--------------------------------------------------------------------
    // Function to convert the FSM States to String
    //--------------------------------------------------------------------
    function string StrFSMState(input bit[3:0] state); begin
        string str;
        case (state)
            TLRS: begin str = "TLRS"; end
            RUTI: begin str = "RUTI"; end
            SDRS: begin str = "SDRS"; end
            CADR: begin str = "CADR"; end
            SHDR: begin str = "SHDR"; end
            E1DR: begin str = "E1DR"; end
            PADR: begin str = "PADR"; end
            E2DR: begin str = "E2DR"; end
            UPDR: begin str = "UPDR"; end
            SIRS: begin str = "SIRS"; end
            CAIR: begin str = "CAIR"; end
            SHIR: begin str = "SHIR"; end
            E1IR: begin str = "E1IR"; end
            PAIR: begin str = "PAIR"; end
            E2IR: begin str = "E2IR"; end
            UPIR: begin str = "UPIR"; end
        endcase // case(toState)
        return str; 
    end
    endfunction : StrFSMState

endclass : JtagBfmDriver
`endif // INC_JtagBfmDriver
