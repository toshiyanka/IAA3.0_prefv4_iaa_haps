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
//    FILENAME    : JtagBfmInputMonitor.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//    
//    
//    PURPOSE     : Input Monitor for the DUT
//    DESCRIPTION : Monitors the pin that drive the DUT and sends 
//                  the relevent information to the Scoreboard
//                  The Monitor has the FSM State Machine to replicate
//                  the behaviour of RTL
//----------------------------------------------------------------------

`ifndef INC_JtagBfmInputMonitor
 `define INC_JtagBfmInputMonitor 

   parameter INMON_SIZE_OF_IR_REG            = 4096;
`ifndef OVM_MAX_STREAMBITS
   parameter INMON_TOTAL_DATA_REGISTER_WIDTH = 4096;
   //parameter INMON_SIZE_OF_IR_REG            = 4096;
`else
   parameter INMON_TOTAL_DATA_REGISTER_WIDTH = `OVM_MAX_STREAMBITS;
   //parameter INMON_SIZE_OF_IR_REG            = `OVM_MAX_STREAMBITS;
`endif

`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
class JtagBfmInputMonitor #(`JTAG_IF_PARAMS_DECL) extends ovm_monitor;
`else    
class JtagBfmInputMonitor extends ovm_monitor;
`endif

    //************************************
    // Local Variable Declaration
    //************************************
    fsm_state_test                                 current_state = TLRS;
    bit [INMON_TOTAL_DATA_REGISTER_WIDTH - 1:0]    con_data_shift_reg;
    bit [INMON_SIZE_OF_IR_REG -1:0]                con_tdi_addr;
    reg                                            tms_reg, tdi_reg;
    integer                                        activity_counter = 0, activity_counter_active = 0;
    integer                                        size_of_ir = 0;
    integer                                        size_of_dr = 0;
    integer                                        tdi_shift_cnt = 0;
    protected bit                                  override_tdi_data;
    protected bit                                  unsplit_ir_dr_data;

   
    // Handle to Event pool. This object is not created here. 
    ovm_event_pool eventPool;
    // Event
    ovm_event e1;

    // Packet to the ScoreBoard 
    JtagBfmInMonSbrPkt Packet;

    // Analysis Port for the Packet to transfer from Monitor to Scoreboard
    ovm_analysis_port #(JtagBfmInMonSbrPkt) InputMonitorPort;

    //********************************************
    // pin Interface for connection to the DUT
    //********************************************
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
    protected virtual JtagBfmIntf #(`JTAG_IF_PARAMS_INST) PinIf;
`else    
    protected virtual JtagBfmIntf PinIf;
`endif

    // ------------------------------------------------------------------------------------
    // https://vthsd.intel.com/hsd/seg_softip/default.aspx#bug/default.aspx?bug_id=4963783
    // --------------------------Coverage for the FSM States----------------------
    
    covergroup ChassisJtagBfmFsm ;
    option.per_instance = 1;
    option.name         = "JtagInMonFsmStateCG" ;
    option.comment      = "Gives the FSM State Coverage" ;
      
      // Auto bin for all the FSM states
      FSM: coverpoint current_state;

    endgroup:ChassisJtagBfmFsm

    // Register component with Factory 
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
    `ovm_component_param_utils_begin(JtagBfmInputMonitor #(CLOCK_PERIOD,PWRGOOD_SRC,CLK_SRC,BFM_MON_CLK_DIS))
`else    
    `ovm_component_utils_begin(JtagBfmInputMonitor)
`endif
       `ovm_field_int(override_tdi_data, OVM_ALL_ON)
       `ovm_field_int(unsplit_ir_dr_data, OVM_ALL_ON)
    `ovm_component_utils_end    
    
    //********************************************
    // Constructor
    //********************************************
    function new (string name = "JtagBfmInputMonitor", ovm_component parent = null);
        super.new(name,parent);
        //https://hsdes.intel.com/home/default.html#article?id=1503985289
        //Changed due to an error in SVTB Lintra Tool
        Packet = JtagBfmInMonSbrPkt::type_id::create("JtagBfmInMonSbrPkt",this);
        InputMonitorPort= new("InputMonitorPort",this);
        ChassisJtagBfmFsm = new();
    endfunction : new

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
        `ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
            $swrite (msg, "Value of BFM_MON_CLK_DIS = ",BFM_MON_CLK_DIS);
        `endif
        `ovm_info (get_full_name(), msg, OVM_MEDIUM);
        // Assigning virtual interface
        if(get_config_object("V_JTAGBFM_PIN_IF", temp))
        begin
           if(!$cast(vif_container, temp))
           `ovm_fatal(get_full_name(),"Agent fail to connect to TI. Search for string << active agent exists at this hierarchy >> to get the list of all active agents in your SoC");
        end
        PinIf = vif_container.get_v_if();
        
        // Get the handle of the event with a unique string from the event pool
        e1 = eventPool.get("jtag_mon_sync"); 
    endfunction : connect

    //********************************************
    // Run Task 
    //********************************************
    virtual task run();
        input_monitor_item(Packet);
    endtask: run

    //*************************************************
    // Input Monitor Item task that monitors the PinIf 
    //*************************************************
    task input_monitor_item(input JtagBfmInMonSbrPkt Packet);
            fork
                begin
                    forever begin
                    @(posedge PinIf.tck or negedge PinIf.trst_b or negedge PinIf.powergood_rst_b );
                    //***************************************************
                    //Load 'h1 for all the Instruction Register
                    //***************************************************
                    if(current_state == CAIR || ((current_state == E2IR) && (unsplit_ir_dr_data == 1'b0))) begin
                        size_of_ir = 0;
                    end

                    if(current_state == CAIR) begin
                        if(override_tdi_data === 1'b1) begin
                           con_tdi_addr = '0;
                        end
                    end

                    //***************************************************
                    // Shift the Concataneted IR in SHIR state
                    //***************************************************
                    if(current_state == SHIR) begin
                        con_tdi_addr[size_of_ir] =PinIf.tdi;
                        size_of_ir ++;
                        tdi_shift_cnt++;
                    end//SHIR

                    //***************************************************
                    // Load the Parallel data to Cancatenated DR in CADR
                    //***************************************************
                    if(current_state == CADR || ((current_state == E2DR) && (unsplit_ir_dr_data == 1'b0))) begin
                        size_of_dr = 0;
                    end
                    
                    if(current_state == CADR) begin
                        if(override_tdi_data === 1'b1) begin
                           con_data_shift_reg = '0;
                        end
                    end

                    if(current_state == SHDR) begin
                        con_data_shift_reg[size_of_dr] =PinIf.tdi;
                        size_of_dr++;
                        tdi_shift_cnt++;
                    end
                //    end // Forever
                //end
                //*****************************************
                // Invoking FSM Task
                //****************************************
                //begin
                //    forever begin
                 //   @(posedge PinIf.tck or negedge PinIf.trst_b or negedge PinIf.powergood_rst_b );
                 //   monitor_tap_fsm;
                 //   end // Forever
                //end

                //************************************************************
                // Update the Transaction packet to Scoreboard at each clock
                //************************************************************
                //begin
                //    forever begin
                //    @(posedge PinIf.tck);
                    Packet.Power_Gud_Reset           = PinIf.powergood_rst_b; 
                    Packet.FsmState                  = current_state;
                    Packet.ShiftRegisterData         = con_data_shift_reg;
                    Packet.ShiftRegisterAddress      = con_tdi_addr;
                    Packet.tdi_shift_cnt             = tdi_shift_cnt;
                    InputMonitorPort.write(Packet);
                    if(current_state == UPDR) begin
                       `ovm_info (get_type_name(), $sformatf("Packet in JTAGBFM Input Monitor \n Power_Gud_Reset      %0h\n FsmState             0x%0b\n ShiftRegisterAddress 0x%0h \n ShiftRegisterData    0x%0h",Packet.Power_Gud_Reset,Packet.FsmState,Packet.ShiftRegisterAddress,Packet.ShiftRegisterData), OVM_LOW);
                    end
                    if(current_state == UPIR) begin
                       `ovm_info (get_type_name(), $sformatf("Packet in JTAGBFM Input Monitor \n Power_Gud_Reset      %0h\n FsmState             0x%0b\n ShiftRegisterAddress 0x%0h",Packet.Power_Gud_Reset,Packet.FsmState,Packet.ShiftRegisterAddress), OVM_LOW);
                    end
                    e1.trigger();
                    ChassisJtagBfmFsm.sample();
                    monitor_tap_fsm;
                    end // Forever
                end

                //************************************************************
                // Activity Counter to stop test if stable for long time
                //************************************************************
                begin
                    forever begin
                    @(posedge PinIf.tck);
                    tms_reg <=PinIf.tms;
                    tdi_reg <=PinIf.tdi;
                    if((tms_reg!=PinIf.tms)||(tdi_reg !=PinIf.tdi))
                    begin
                     activity_counter = 0;
                     activity_counter_active = activity_counter_active + 1;
                    end
                    else
                     activity_counter = activity_counter + 1;
                    end // Forever
                end
    
                ////----------sampling event -------------
                //begin
                //    forever begin
                //  @(posedge PinIf.tck);
                //      ChassisJtagBfmFsm.sample();
                //    end // Forever
                //end

            join_any
    endtask : input_monitor_item

    //************************************************
    // FSM
    //************************************************
    task monitor_tap_fsm;
        begin
            // @(posedge PinIf.tck);
            // Added negedge powergood_rst_b condition just like how it is in RTL after review. 08Sep11.
            if((!PinIf.trst_b) | (!PinIf.powergood_rst_b)) begin
                #0 current_state =TLRS;
            end else begin
                #0 case (current_state)

                    TLRS: begin
                        if(PinIf.tms) current_state = TLRS;
                        else current_state = RUTI;
                    end // case: TLRS

                    RUTI:begin
                        if(PinIf.tms) current_state = SDRS;
                        else current_state = RUTI;
                    end // case: RUTI

                    SDRS: begin
                        if(PinIf.tms) current_state = SIRS;
                        else current_state = CADR;
                    end // case: SDRS

                    CADR: begin
                        if(PinIf.tms) current_state = E1DR;
                        else
                        begin 
                           current_state = SHDR;
                           tdi_shift_cnt = 0;
                        end
                    end // case: CADR

                    SHDR: begin
                       if(PinIf.tms) current_state = E1DR;
                       else current_state = SHDR;
                    end // case: SHDR

                    E1DR: begin
                       if(PinIf.tms) current_state = UPDR;
                       else current_state = PADR;
                    end // case: E1DR

                    PADR: begin
                       if(PinIf.tms) current_state = E2DR;
                       else current_state = PADR;
                    end // case: PADR

                    E2DR: begin
                       if(PinIf.tms) current_state = UPDR;
                       else
                       begin
                           current_state = SHDR;
                           tdi_shift_cnt = 0;
                       end
                    end // case: E2DR

                    UPDR: begin
                       if(PinIf.tms) current_state = SDRS;
                       else current_state = RUTI;
                    end // case: UPDR

                    SIRS: begin
                        if(PinIf.tms) current_state = TLRS;
                        else current_state = CAIR;
                    end // case: SIRS

                    CAIR: begin
                        if(PinIf.tms) current_state = E1IR;
                        else
                        begin
                            current_state = SHIR;
                            tdi_shift_cnt = 0;
                        end
                    end // case: CAIR

                    SHIR: begin
                        if(PinIf.tms) current_state = E1IR;
                        else current_state = SHIR;
                    end // case: SHIR

                    E1IR: begin
                        if(PinIf.tms) current_state = UPIR;
                        else current_state = PAIR;
                    end // case: E1IR

                    PAIR: begin
                        if(PinIf.tms) current_state = E2IR;
                        else current_state = PAIR;
                    end // case: PAIR

                    E2IR: begin
                        if(PinIf.tms) current_state = UPIR;
                        else
                        begin
                            current_state = SHIR;
                            tdi_shift_cnt = 0;
                        end
                    end // case: E2IR

                    UPIR: begin
                        if(PinIf.tms) current_state = SDRS;
                        else current_state = RUTI;
                    end // case: UPIR

                    default: current_state = TLRS;
                endcase
            end
            PinIf.mon_display_state_t <= current_state;
        end
    endtask

    //--------------------------------------------------------------------
    // Function to convert the FSM States to String
    //--------------------------------------------------------------------
    function string state_str;
        input [STATE_BITS :0]  state;
        begin
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
    endfunction

    virtual function void report() ;
      `ovm_info(get_name(), $sformatf("There was %0d pin wiggling in TDI/TMS", activity_counter_active ),OVM_NONE)
    endfunction : report

endclass : JtagBfmInputMonitor
`endif // INC_JtagBfmInputMonitor
