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
//    FILENAME    : JtagBfmOutputMonitor.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//    
//    
//    PURPOSE     : Output Monitor for the DUT
//    DESCRIPTION : Monitors output of the DUT and sends 
//                  the relevent information to the Scoreboard
//                  The Monitor has the FSM State Machine to replicate
//                  the behaviour of RTL
//----------------------------------------------------------------------

`ifndef INC_JtagBfmOutputMonitor
 `define INC_JtagBfmOutputMonitor 

`ifndef UVM_MAX_STREAMBITS
   parameter OUTMON_TOTAL_DATA_REGISTER_WIDTH = 4096;
`else
   parameter OUTMON_TOTAL_DATA_REGISTER_WIDTH = `UVM_MAX_STREAMBITS;
`endif

`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
class JtagBfmOutputMonitor #(`JTAG_IF_PARAMS_DECL) extends uvm_monitor;
`else    
class JtagBfmOutputMonitor extends uvm_monitor;
`endif

    //************************
    //Local Declarations
    //************************
    int                                          activity_counter = 0 , activity_counter_active = 0;
    int                                          addr_pointer     = 0;
    int                                          data_pointer     = 0;
    int                                          flag             = 0;
    int                                          flag_dr          = 0;
    fsm_state_test                               current_state = TLRS;
    reg [OUTMON_TOTAL_DATA_REGISTER_WIDTH-1:0]   addr_shift_reg;
    reg [OUTMON_TOTAL_DATA_REGISTER_WIDTH-1:0]   data_shift_reg;
    reg                                          tdo_reg;

    integer                                      tdo_shift_cnt = 0;

    protected bit                                override_tdo_data;

    // Handle to Event pool. This object is not created here.
    uvm_event_pool eventPool;
    // Event
    uvm_event e1;

    // Packet to the ScoreBoard
    JtagBfmOutMonSbrPkt Packet;

    // Analysis Port for the Packet to transfer from Monitor to Scoreboard
    uvm_analysis_port #(JtagBfmOutMonSbrPkt) OutputMonitorPort;

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
             bins ARC_BIN_TLRS_TLRS   = ( TLRS => TLRS );
             bins ARC_BIN_TLRS_RUTI   = ( TLRS => RUTI );
             bins ARC_BIN_RUTI_RUTI   = ( RUTI => RUTI );
             bins ARC_BIN_RUTI_SDRS   = ( RUTI => SDRS );
             bins ARC_BIN_SDRS_SIRS   = ( SDRS => SIRS );
             bins ARC_BIN_SDRS_CADR   = ( SDRS => CADR );
             bins ARC_BIN_CADR_SHDR   = ( CADR => SHDR );
             bins ARC_BIN_CADR_E1DR   = ( CADR => E1DR );
             bins ARC_BIN_SHDR_E1DR   = ( SHDR => E1DR );
             bins ARC_BIN_SHDR_SHDR   = ( SHDR => SHDR );
             bins ARC_BIN_E1DR_PADR   = ( E1DR => PADR );
             bins ARC_BIN_E1DR_UPDR   = ( E1DR => UPDR );
             bins ARC_BIN_PADR_E2DR   = ( PADR => E2DR );
             bins ARC_BIN_PADR_PADR   = ( PADR => PADR );
             bins ARC_BIN_E2DR_UPDR   = ( E2DR => UPDR );
             bins ARC_BIN_E2DR_SHDR   = ( E2DR => SHDR );
             bins ARC_BIN_UPDR_RUTI   = ( UPDR => RUTI );
             bins ARC_BIN_UPDR_SDRS   = ( UPDR => SDRS );
             bins ARC_BIN_SIRS_CAIR   = ( SIRS => CAIR );
             bins ARC_BIN_SIRS_TLRS   = ( SIRS => TLRS );
             bins ARC_BIN_CAIR_SHIR   = ( CAIR => SHIR );
             bins ARC_BIN_CAIR_E1IR   = ( CAIR => E1IR );
             bins ARC_BIN_SHIR_E1IR   = ( SHIR => E1IR );
             bins ARC_BIN_SHIR_SHIR   = ( SHIR => SHIR );
             bins ARC_BIN_E1IR_PAIR   = ( E1IR => PAIR );
             bins ARC_BIN_E1IR_UPIR   = ( E1IR => UPIR );
             bins ARC_BIN_PAIR_E2IR   = ( PAIR => E2IR );
             bins ARC_BIN_PAIR_PAIR   = ( PAIR => PAIR );
             bins ARC_BIN_E2IR_UPIR   = ( E2IR => UPIR );
             bins ARC_BIN_E2IR_SHIR   = ( E2IR => SHIR );
             bins ARC_BIN_UPIR_RUTI   = ( UPIR => RUTI );
             bins ARC_BIN_UPIR_SDRS   = ( UPIR => SDRS );
           }

    endgroup:ChassisJtagBfmFsm


    // Register component with Factory
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
    `uvm_component_param_utils_begin(JtagBfmOutputMonitor #(CLOCK_PERIOD,PWRGOOD_SRC,CLK_SRC,BFM_MON_CLK_DIS))
`else    
    `uvm_component_utils_begin(JtagBfmOutputMonitor)
`endif
       `uvm_field_int(override_tdo_data, UVM_ALL_ON)
    `uvm_component_utils_end    


    //********************************************
    // Constructor
    //********************************************
    function new (string name = "JtagBfmOutputMonitor", uvm_component parent = null);
        super.new(name,parent);
        //https://hsdes.intel.com/home/default.html#article?id=1503985289
        //Changed due to an error in SVTB Lintra Tool
        Packet = JtagBfmOutMonSbrPkt::type_id::create("JtagBfmOutMonSbrPkt",this);
        OutputMonitorPort= new("OutputMonitorPort", this);
        ChassisJtagBfmFsm = new();
    endfunction : new

    //********************************************
    // pin Interface for connection to the DUT
    //********************************************
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
    protected virtual JtagBfmIntf #(`JTAG_IF_PARAMS_INST) PinIf;
`else    
    protected virtual JtagBfmIntf PinIf;
`endif

    function void connect_phase(uvm_phase phase); 

        uvm_object temp;
        string msg;

   `ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
        JtagBfmIfContainer #(virtual JtagBfmIntf #(`JTAG_IF_PARAMS_INST)) vif_container;
   `else    
        JtagBfmIfContainer vif_container;
   `endif

        super.connect_phase (phase);

        $swrite (msg, "Getting the virtual JtagBfmPinIf interface");
        `uvm_info (get_full_name(), msg, UVM_MEDIUM);
        `ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
             $swrite (msg, "Value of BFM_MON_CLK_DIS = ",BFM_MON_CLK_DIS);
        `endif
        `uvm_info (get_full_name(), msg, UVM_MEDIUM);
        // Assigning virtual interface
        if(uvm_config_object::get(this, "","V_JTAGBFM_PIN_IF", temp))
        begin
           if(!$cast(vif_container, temp))
           `uvm_fatal(get_full_name(),"Agent fail to connect to TI. Search for string << active agent exists at this hierarchy >> to get the list of all active agents in your SoC");
        end
        PinIf = vif_container.get_v_if();
        
        // Get the handle of the event with a unique string from the event pool
        e1 = eventPool.get("jtag_mon_sync"); 
    endfunction : connect_phase   

    //********************************************
    //Run
    //********************************************
    virtual task run_phase (uvm_phase phase);
        output_monitor_item(Packet);
    endtask

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
                    addr_shift_reg = '0;
                 end   
                //***************************************************
                // Accumulate tdo into addr shift register at SHIR
                //***************************************************
                 if(current_state == SHIR)
                 begin
                    addr_shift_reg[addr_pointer] = PinIf.tdo;
                    addr_pointer++;
                    tdo_shift_cnt++;
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
                 if(current_state == E1DR) begin
                     data_pointer = 0;
                 end
                 if(current_state == CADR) begin
                     if(override_tdo_data === 1'b1) begin
                        data_shift_reg = '0;
                     end
                 end

                 //*********************************************************
                 // Send the transaction packet at UPDate or Exit 1 state
                 //*********************************************************
                 if ((current_state == UPIR || current_state == UPDR ||current_state == E1IR || current_state == E1DR))
                 begin
                     Packet.ShiftRegisterAddress = addr_shift_reg;
                     Packet.ShiftRegisterData    = data_shift_reg;
                     Packet.tdo_shift_cnt        = tdo_shift_cnt;
                     Packet.FsmState             = current_state;
                     e1.wait_trigger();
                     OutputMonitorPort.write(Packet);
                     `uvm_info (get_type_name(),$sformatf("Packet in JTAGBFM Output Monitor \n ShiftRegisterAddress 0x%0h \n ShiftRegisterData    0x%0h",Packet.ShiftRegisterAddress,Packet.ShiftRegisterData), UVM_LOW);
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
        @(posedge PinIf.tck or negedge PinIf.trst_b or negedge PinIf.powergood_rst_b );
        if((!PinIf.trst_b) | (!PinIf.powergood_rst_b)) begin
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
                else
                begin 
                  current_state = SHIR;
                  tdo_shift_cnt = 0;
                end
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
                tdo_shift_cnt = 0;
            end // case: UPIR

            default: current_state = TLRS;
            endcase
           end
    end
  endtask
    //--------------------------------------------------------------------
    // Function to convert the FSM States to String
    //--------------------------------------------------------------------
    function string state_str ( input [STATE_BITS : 0] state );
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

    virtual function void report_phase(uvm_phase phase) ;
      `uvm_info(get_name(), $sformatf("There was %0d pin wiggling in TDO", activity_counter_active ),UVM_NONE)
    endfunction : report_phase

endclass : JtagBfmOutputMonitor
`endif // INC_JtagBfmOutputMonitor
