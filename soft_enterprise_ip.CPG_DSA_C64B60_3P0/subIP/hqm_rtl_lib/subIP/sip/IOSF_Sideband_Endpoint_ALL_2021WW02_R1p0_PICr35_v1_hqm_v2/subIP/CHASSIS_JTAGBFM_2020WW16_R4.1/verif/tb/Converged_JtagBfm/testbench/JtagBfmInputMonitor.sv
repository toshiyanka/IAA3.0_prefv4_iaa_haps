// =====================================================================================================
// FileName          : JtagBfmInputMonitor.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Sat July 23 18:17:55 CDT 2010
// =====================================================================================================

// =====================================================================================================
//    PURPOSE     : Input Monitor for the DUT
//    DESCRIPTION : Monitors the pin that drive the DUT and sends 
//                  the relevent information to the Scoreboard
//                  The Monitor has the FSM State Machine to replicate
//                  the behaviour of RTL
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

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

class JtagBfmInputMonitor extends ovm_monitor;

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
    dfx_tap_port_e my_port; // set by the TAP agent
    protected virtual dfx_jtag_if.ENV PinIf;

    // ------------------------------------------------------------------------------------
    // https://vthsd.intel.com/hsd/seg_softip/default.aspx#bug/default.aspx?bug_id=4963783
    // --------------------------Coverage for the FSM States----------------------

    covergroup ChassisJtagBfmFsm ;
    option.per_instance = 1;
    option.name         = "JtagInMonFsmStateCG" ;
    option.comment      = "Gives the FSM State Coverage" ;

      // Auto bin for all the FSM states
      FSM: coverpoint current_state ;

    endgroup:ChassisJtagBfmFsm

    // Register component with Factory
    `ovm_component_utils_begin(JtagBfmInputMonitor)
      `ovm_field_enum(dfx_tap_port_e, my_port, OVM_DEFAULT)
    `ovm_component_utils_end

    //********************************************
    // Constructor
    //********************************************
    function new (string name = "JtagBfmInputMonitor", ovm_component parent = null);
        super.new(name,parent);
        Packet = new();
        InputMonitorPort= new("InputMonitorPort",this);
        ChassisJtagBfmFsm = new();
    endfunction : new

    function void connect();

    ovm_object o_obj;
    dfx_vif_container #(virtual dfx_jtag_if) jtag_vif;
    string s;

    `ovm_info(get_type_name(), $psprintf("Using port ", my_port.name), OVM_NONE)

    s = {"jtag_vif_", my_port.name()};
    if (get_config_object(s,o_obj,0) == 0)
      `ovm_fatal(get_type_name(), {"No JTAG interface available for port ", my_port.name(), " : Disabling JTAG Tracker"})
    if (!$cast(jtag_vif, o_obj))
      `ovm_fatal(get_type_name(), "JTAG interface not the right type : Disabling JTAG Tracker")

    `ovm_info(get_type_name(), $psprintf("JTAG interface found for port ", my_port.name()), OVM_NONE)
    PinIf = jtag_vif.get_v_if();
    if (PinIf == null)
      `ovm_fatal(get_type_name(), {"jtag_if not set in jtag_vif_", my_port.name(), " : Disabling JTAG Tracker"})

        super.connect ();

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
        forever begin
            fork
                begin
                    @(posedge PinIf.tck);
                    //***************************************************
                    //Load 'h1 for all the Instruction Register
                    //***************************************************
                    if(current_state == CAIR) begin
                        size_of_ir = 0;
                    end//CAIR

                    //***************************************************
                    // Shift the Concataneted IR in SHIR state
                    //***************************************************
                    if(current_state == SHIR) begin
                        con_tdi_addr[size_of_ir] =PinIf.tdi;
                        size_of_ir ++;
                    end//SHIR

                    //***************************************************
                    // Load the Parallel data to Cancatenated DR in CADR
                    //***************************************************
                    if(current_state == CADR || current_state == E2DR ) begin
                        size_of_dr = 0;
                    end

                    if(current_state == SHDR) begin
                        con_data_shift_reg[size_of_dr] =PinIf.tdi;
                        size_of_dr++;
                        tdi_shift_cnt++;
                    end
                end
                //*****************************************
                // Invoking FSM Task
                //****************************************
                begin
                    monitor_tap_fsm;
                end

                //************************************************************
                // Update the Transaction packet to Scoreboard at each clock
                //************************************************************
                begin
                    @(posedge PinIf.tck);
                    Packet.Power_Gud_Reset           = PinIf.powergood_rst_b;
                    Packet.FsmState                  = current_state;
                    Packet.ShiftRegisterData         = con_data_shift_reg;
                    Packet.ShiftRegisterAddress      = con_tdi_addr;
                    Packet.tdi_shift_cnt             = tdi_shift_cnt;
                    InputMonitorPort.write(Packet);
                    e1.trigger();
                end

                //************************************************************
                // Activity Counter to stop test if stable for long time
                //************************************************************
                begin
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
                end

                //----------sampling event -------------
                begin
                  @(posedge PinIf.tck);
                      ChassisJtagBfmFsm.sample();
                end

            join
        end // Forever
    endtask : input_monitor_item

    //************************************************
    // FSM
    //************************************************
    task monitor_tap_fsm;
        begin
            // @(posedge PinIf.tck);
            // Added negedge powergood_rst_b condition just like how it is in RTL after review. 08Sep11.
            @(posedge PinIf.tck or negedge PinIf.trst or negedge PinIf.powergood_rst_b);
            if((!PinIf.trst) | (!PinIf.powergood_rst_b)) begin
                #0 current_state =TLRS;
            end else begin
                #0 // Make sure it is executed last
                case (current_state)

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
                        else current_state = SHIR;
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
                        else current_state = SHIR;
                    end // case: E2IR

                    UPIR: begin
                        if(PinIf.tms) current_state = SDRS;
                        else current_state = RUTI;
                    end // case: UPIR

                    default: current_state = TLRS;
                endcase
            end
        end
    endtask

    //--------------------------------------------------------------------
    // Function to convert the FSM States to String
    //--------------------------------------------------------------------
    function string state_str;
        input fsm_state_test state;
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
