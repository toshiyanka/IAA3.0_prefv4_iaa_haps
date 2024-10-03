// =====================================================================================================
// FileName          : JtagBfmOutputMonitor.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Sat July 23 18:17:55 CDT 2010
// =====================================================================================================

// =====================================================================================================
//    PURPOSE     : Output Monitor for the DUT
//    DESCRIPTION : Monitors output of the DUT and sends 
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

`ifndef INC_JtagBfmOutputMonitor
 `define INC_JtagBfmOutputMonitor

`ifndef OVM_MAX_STREAMBITS
   parameter OUTMON_TOTAL_DATA_REGISTER_WIDTH = 4096;
`else
   parameter OUTMON_TOTAL_DATA_REGISTER_WIDTH = `OVM_MAX_STREAMBITS;
`endif

class JtagBfmOutputMonitor extends ovm_monitor;

    //************************
    //Local Declarations
    //************************
    int                                          activity_counter = 0 , activity_counter_active = 0;
    int                                          addr_pointer     = 0;
    int                                          data_pointer     = 0;
    int                                          flag             = 0;
    int                                          flag_dr          = 0;
    fsm_state_test                                    current_state    = TLRS;
    reg [3:0]                                    state            = TLRS;
    reg [OUTMON_TOTAL_DATA_REGISTER_WIDTH-1:0]   addr_shift_reg;
    reg [OUTMON_TOTAL_DATA_REGISTER_WIDTH-1:0]   data_shift_reg;
    reg                                          tdo_reg;

    integer                                      tdo_shift_cnt = 0;

    // Handle to Event pool. This object is not created here.
    ovm_event_pool eventPool;
    // Event
    ovm_event e1;

    // Packet to the ScoreBoard
    JtagBfmOutMonSbrPkt Packet;

    // Analysis Port for the Packet to transfer from Monitor to Scoreboard
    ovm_analysis_port #(JtagBfmOutMonSbrPkt) OutputMonitorPort;

    // ------------------------------------------------------------------------------------
    // https://vthsd.intel.com/hsd/seg_softip/default.aspx#bug/default.aspx?bug_id=4963783
    // --------------------------Coverage for the FSM ARCS----------------------

    covergroup ChassisJtagBfmFsm ;
    option.per_instance = 1;
    option.name         = "JtagOutMonFsmArcCG" ;
    option.comment      = "Gives the FSM Arc Coverage" ;

      // Specific ARC coverage of state transitions
      ARC: coverpoint current_state
           {
             bins ARC_BIN [] = ( TLRS => TLRS ),
                               ( RUTI => RUTI ),
                               ( SHDR => SHDR ),
                               ( SDRS => SIRS ),
                               ( SDRS => CADR );
           }

    endgroup:ChassisJtagBfmFsm

    // Register component with Factory
    `ovm_component_utils_begin(JtagBfmOutputMonitor)
      `ovm_field_enum(dfx_tap_port_e, my_port, OVM_DEFAULT)
    `ovm_component_utils_end


    //********************************************
    // Constructor
    //********************************************
    function new (string name = "JtagBfmOutputMonitor", ovm_component parent = null);
        super.new(name,parent);
        Packet            = new();
        OutputMonitorPort= new("OutputMonitorPort", this);
        ChassisJtagBfmFsm = new();
    endfunction : new

    //********************************************
    // pin Interface for connection to the DUT
    //********************************************
    dfx_tap_port_e my_port; // set by the TAP agent
    protected virtual dfx_jtag_if.ENV PinIf;

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
    //Run
    //********************************************
    virtual task run();
        output_monitor_item(Packet);
    endtask : run

    //**************************************************
    // Output Monitor Item task that monitors the PinIf
    //**************************************************
    task output_monitor_item(
                             input JtagBfmOutMonSbrPkt Packet
                            );
    fork
        forever
        begin
            //***********************************
            // Capture the Parallel data at UPDR
            //***********************************
            @(posedge PinIf.tck);
                if(current_state == TLRS)
                begin
                    addr_shift_reg = 0;
                    data_shift_reg = 0;
                    addr_pointer   = 0;
                    data_pointer   = 0;
                end
                 if(current_state == CAIR) begin
                    addr_pointer = 0;
                    addr_shift_reg = 0;
                 end
                //***************************************************
                // Accumulate tdo into addr shift register at SHIR
                //***************************************************
                 if(current_state == SHIR)
                 begin
                    addr_shift_reg[addr_pointer] = PinIf.tdo;
                    addr_pointer++;
                 end
                 if(current_state == E1IR)
                   addr_pointer = 0;
                 //***************************************************
                 // Accumulate tdo into data shift register at SHDR
                 //***************************************************
                 if(current_state == SHDR)
                 begin
                     data_shift_reg[data_pointer] = PinIf.tdo;
                     data_pointer++;
                     tdo_shift_cnt++;
                 end
                 if(current_state == E1DR)
                     data_pointer = 0;

                 //*********************************************************
                 // Send the transaction packet at UPDate or Exit 1 state
                 //*********************************************************
                 if ((current_state == UPIR || current_state == UPDR ||current_state == E1IR || current_state == E1DR))
                 begin
                     Packet.ShiftRegisterAddress = addr_shift_reg;
                     Packet.ShiftRegisterData    = data_shift_reg;
                     Packet.tdo_shift_cnt        = tdo_shift_cnt;
                     e1.wait_trigger();
                     OutputMonitorPort.write(Packet);
                 end
        end

        //*******************
        // Call FSM Task
        //*******************
        forever
        begin
            monitor_tap_fsm;
        end

        //***********************************
        // Check for Activity at input pins
        //***********************************
        forever begin
            @(posedge PinIf.tck);
                tdo_reg <=  PinIf.tdo;
            if((tdo_reg !=  PinIf.tdo))
            begin
                activity_counter = 0;
                activity_counter_active = activity_counter_active + 1;
            end
            else
                activity_counter = activity_counter + 1;
        end

        //----------sampling event for Cover group---------
        forever begin
          @(posedge PinIf.tck);
              ChassisJtagBfmFsm.sample();
        end

    join
    endtask : output_monitor_item
    //************************************************
    // FSM
    //************************************************
  task monitor_tap_fsm;
    begin
        // @(posedge PinIf.tck);
        // Added negedge powergood_rst_b condition just like how it is in RTL after review. 08Sep11.
        @(posedge PinIf.tck or negedge PinIf.trst or negedge PinIf.powergood_rst_b );
        if((!PinIf.trst) | (!PinIf.powergood_rst_b)) begin
            #0 current_state =TLRS;
        end else begin
            #0 // Make sure it is executed last
            case(current_state)

            TLRS:begin
                if(PinIf.tms) current_state = TLRS;
                else current_state = RUTI;
            end // case: TLRS

            RUTI:begin
                if(PinIf.tms) current_state = SDRS;
                else current_state = RUTI;
            end // case: RUTI

            SDRS:begin
                if(PinIf.tms) current_state = SIRS;
                else current_state = CADR;
            end // case: SDRS

            CADR:begin
                if(PinIf.tms) current_state = E1DR;
                else
                begin
                  current_state = SHDR;
                  tdo_shift_cnt = 0;
                end
            end // case: CADR

            SHDR:begin
                if(PinIf.tms) current_state = E1DR;
                else current_state = SHDR;
            end // case: SHDR

            E1DR:begin
                if(PinIf.tms) current_state = UPDR;
                else current_state = PADR;
            end // case: E1DR

            PADR:begin
                if(PinIf.tms) current_state = E2DR;
                else current_state = PADR;
            end // case: PADR

            E2DR:begin
                if(PinIf.tms) current_state = UPDR;
                else
                begin
                   current_state = SHDR;
                   //tdo_shift_cnt = 0;
                end
            end // case: E2DR

            UPDR:begin
                if(PinIf.tms) current_state = SDRS;
                else current_state = RUTI;
                // HSD 4964523
                tdo_shift_cnt = 0;
            end // case: UPDR

            SIRS:begin
                if(PinIf.tms) current_state = TLRS;
                else current_state = CAIR;
            end // case: SIRS

            CAIR:begin
                if(PinIf.tms) current_state = E1IR;
                else current_state = SHIR;
            end // case: CAIR

            SHIR:begin
                if(PinIf.tms) current_state = E1IR;
                else current_state = SHIR;
            end // case: SHIR

            E1IR:begin
                if(PinIf.tms) current_state = UPIR;
                else current_state = PAIR;
            end // case: E1IR

            PAIR:begin
                if(PinIf.tms) current_state = E2IR;
                else current_state = PAIR;
            end // case: PAIR

            E2IR:begin
                if(PinIf.tms) current_state = UPIR;
                else current_state = SHIR;
            end // case: E2IR

            UPIR:begin
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
    function string state_str (input fsm_state_test state);
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
      `ovm_info(get_name(), $sformatf("There was %0d pin wiggling in TDO", activity_counter_active ),OVM_NONE)
    endfunction : report

endclass : JtagBfmOutputMonitor
`endif // INC_JtagBfmOutputMonitor
