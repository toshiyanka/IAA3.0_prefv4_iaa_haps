//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2020 Intel Corporation All Rights Reserved.
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
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2020WW22_PICr33
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : TapScoreBoard.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : Score Board for the ENV 
//    DESCRIPTION : This is the scoreboard for the ENV. It modesl the 
//                  DUT and reports any mismatch in behaviour between
//                  the model and the RTL
//----------------------------------------------------------------------

`include "uvm_macros.svh"

class TapScoreBoard extends uvm_scoreboard;

    // Packet Received from Monitors
    JtagBfmInMonSbrPkt     InputPacket;
    JtagBfmOutMonSbrPkt    OutputPacket;
    TapInMonIntSbrPkt  InputIntPacket;

    uvm_analysis_export #(JtagBfmInMonSbrPkt)     InputMonExport;
    uvm_analysis_export #(JtagBfmOutMonSbrPkt)    OutputMonExport;
    uvm_analysis_export #(TapInMonIntSbrPkt)  InputMonIntExport;

    // TLM fifo for input and output monitor 
    uvm_tlm_analysis_fifo #(JtagBfmInMonSbrPkt)     InputMonFifo;
    uvm_tlm_analysis_fifo #(JtagBfmOutMonSbrPkt)    OutputMonFifo;
    uvm_tlm_analysis_fifo #(TapInMonIntSbrPkt)  InputMonIntFifo;

    //-------------------------------------------------------------------------
    // Local Variables
    //-------------------------------------------------------------------------
    //Concatenated Address as Supplied in Parameter
    bit [(NO_OF_RW_REG*SIZE_OF_IR_REG)-1:0]                                 con_rw_reg_addr;
    //Array of Register Address Sliced from Parameter
    bit [NO_OF_RW_REG-1:0][SIZE_OF_IR_REG-1:0]                              rw_reg_addr;
    //Concatenated Number of Register in each TAP as supplied in Parameter
    reg [16*NO_OF_TAP - 1:0]                                               con_no_of_dr_reg_stap;
    // Array of Number of Register in each TAP
    int                                                                     no_of_dr_reg[NO_OF_RW_REG-1:0];
    // Concatenated Width of all Register as supplied in Parameter
    bit [16*NO_OF_RW_REG-1:0]                                               con_rw_reg_width;
    // Array of Register width for each Data Register
    bit [NO_OF_RW_REG-1:0][15:0]                                            rw_reg_width;
    // Concatenated Reset Value of all Register as supplied in Parameter
    bit [TOTAL_DATA_REGISTER_WIDTH-1 : 0]                                   con_rw_reg_reset_value;
    // Array of Reset Value for each register
    bit [NO_OF_RW_REG-1:0][TOTAL_DATA_REGISTER_WIDTH-1 : 0]                 rw_reg_reset_value;
    // Mask bit to slice the reset values
    bit [NO_OF_RW_REG-1:0][TOTAL_DATA_REGISTER_WIDTH-1 : 0]                 mask_reset_value;
    // Concatenated Flag for pin or loop back for each register
    bit [TOTAL_DATA_REGISTER_WIDTH-1 : 0]                                   con_rw_reg_pin_not_loopback;
    int                                                                     cummulative_reg_width;
    // Expected data out after SHDR state in E1DR
    bit [TOTAL_DATA_REGISTER_WIDTH-1 : 0]                                   expected_tdo_data;
    bit [TOTAL_DATA_REGISTER_WIDTH-1 : 0]                                   actual_tdo_data;
    bit [TOTAL_DATA_REGISTER_WIDTH-1 : 0]                                   actual_tdi_data;
    // Expected address out after SHIR in E1IR
    bit [(NO_OF_RW_REG*SIZE_OF_IR_REG)-1:0]                                 expected_parallel_addr;
    //Concatenated Address of all TAP as configured through tdi
    bit [(NO_OF_TAP*SIZE_OF_IR_REG)-1:0]                                   con_tdi_addr;
    // Array of Register address as configured through tdi
    bit [NO_OF_RW_REG-1:0][SIZE_OF_IR_REG-1:0]                              rw_reg_addr_tdi;
    // Array of Register mode each sTAP is in(IDCODE,BYPASS,RW_REG)
    bit [NO_OF_TAP-1:0][1:0]                                               mode;
    // Array of Mode each TAP is configured to(Exclude,Normal,Decoupled or Shadow)
    reg [NO_OF_TAP-1:0][1:0]                                               mltapc_mode   = 1;
    reg [NO_OF_TAP-1:0]                                                    scan_ir_dr_en = 1;
    reg [NO_OF_TAP-1:0]                                                    scan_ir_en    = 1;
    reg [NO_OF_TAP-1:0]                                                    scan_dr_en    = 1;
    
    // Number of TAP in Normal or Excluded Mode (including CLTAPC)
    integer                                                                active_stap_ir = 0;
    // Number of shift during SHIR
    integer                                                                no_of_ir_shift = 0;
    // Size of the IR register for all TAP togeather
    integer                                                                size_of_ir = 0;
    // Number of Shift during SHDR
    integer                                                                no_of_dr_shift = 0;
    // Number of Shift during SHDR
    integer                                                                no_of_data_shift;
    // State of FSM
    bit [3:0]                                                              state = 4'b0;
    reg [3:0]                                                              previous_state;
    // To flga error while compairing data bits
    bit [TOTAL_DATA_REGISTER_WIDTH-1 : 0]                                  flag_serial_data_error = 0;
    // Vercode input
    bit [3:0]                                                              vercode_sig;
    // Concatenated shadow register
    bit [TOTAL_DATA_REGISTER_WIDTH-1 : 0]                                  con_shadow_reg;
    bit [TOTAL_DATA_REGISTER_WIDTH-1 : 0]                                  parallel_data_in;
    bit [TOTAL_DATA_REGISTER_WIDTH-1 : 0]                                  expected_parallel_data_out;
    // MaskRegister to slice concatenated data
    bit [SIZE_OF_IR_REG-1:0]                                               mask_bit_vector;
    // To check the input reg against each available reg addr for TAP
    bit [NO_OF_RW_REG-1:0]                                                 flag_mode_chk;
    // Concatanation of all the Shift Registers for each TAP
    reg [TOTAL_DATA_REGISTER_WIDTH - 1:0]                                  con_data_shift_reg;
    // Array of LSB Position of each Register in the concatenated Shadow Register
    integer                                                                lsb_pos_shadow_reg[NO_OF_TAP-1:0][255:0];
    // Data Reg selected for the TAP
    integer                                                                sel_dr_no[NO_OF_TAP-1:0];
    integer                                                                dr_no;
    // The data Register selected for each TAP
    integer                                                                sel_dr_reg[NO_OF_TAP-1:0];
    integer                                                                dr_reg;
    integer                                                                dr_reg_no;
    // Pointer to Concatenated Shift Register
    integer                                                                tdo_tap=1;
    // Pointer to concatenated Shadow Register
    integer                                                                updr_tap=1;
    // Loop Variables
    integer                                                                i,j,k,l,m;
    // Length of Shadow Register
    integer                                                                shadow_reg_len;
    //Local signal for slvidcode input
    bit [31:0]                                                             slvidcode_int [NO_OF_TAP -1 : 0];
    //Local Signal for PowergoodReset
    bit                                                                    power_gud_int;
    //Integer to flag the semaphore for tapnw_transactor recieved
    bit [NO_OF_TAP -1 : 0]                                                 sec_sel_sig;
    bit [NO_OF_TAP -1 : 0]                                                 enable_tdo_sig;
    bit [NO_OF_TAP -1 : 0]                                                 enable_tap_sig;    
    int                                                                    primary_scrbrd;
    int                                                                    secondary_scrbrd;
    int                                                                    scrbrd_pri_trkr;
    int                                                                    scrbrd_sec_trkr;
    bit [NO_OF_TAP -1 : 0]                                                 position_of_tap;
    bit [NO_OF_TAP -1 : 0]                                                 abs_position_of_taps;
    //Queues to Record Transitions
    time                                                                    time_queue[$];
    time                                                                    state_time_queue[$];
    bit[SIZE_OF_IR_REG-1:0]                                                 instr_queue[$];
    bit[TOTAL_DATA_REGISTER_WIDTH-1:0]                                      ip_queue[$];
    bit[TOTAL_DATA_REGISTER_WIDTH-1:0]                                      op_queue[$];
    reg [3:0]                                                               state_queue[$];
    //FILE fp;
    int                                                                     fp;
    int                                                                     sp;
    //Remove Bit
    bit                                                                     rmv_bit;
    integer                                                                 remove_bit_int;
    string                                                                  msg;

    //*************************************************************************
    // Constructor
    //*************************************************************************
    function new(string name          = "TapScoreBoard",
                 uvm_component parent = null);
        super.new(name,parent);
        rmv_bit            = 1'b0;             
        InputPacket        = new();
        InputIntPacket     = new();
        OutputPacket       = new();
        InputMonExport     = new("InputMonExport", this);
        InputMonIntExport  = new("InputMonIntExport", this);
        OutputMonExport    = new("OutputMonExport", this);
        InputMonFifo       = new("InputMonFifo", this);
        InputMonIntFifo    = new("InputMonIntFifo", this);
        OutputMonFifo      = new("OutputMonFifo", this);
    endfunction : new
    //*************************************************************************
    // End of New Function
    //*************************************************************************

    //*************************************************************************
    // Component Factory registration
    //*************************************************************************
    `uvm_component_utils(TapScoreBoard)

    //*************************************************************************
    // Connect the Input and Output Monitors 
    //*************************************************************************
    function void connect_phase (uvm_phase phase);
        InputMonExport.connect(InputMonFifo.analysis_export);
        InputMonIntExport.connect(InputMonIntFifo.analysis_export);
        OutputMonExport.connect(OutputMonFifo.analysis_export);
    endfunction : connect_phase
    //*************************************************************************
    // End of Connect Function
    //*************************************************************************

    //*************************************************************************
    // Run Phase
    //*************************************************************************
    virtual task run_phase (uvm_phase phase);
        fork
            forever begin
                scoreboard_item();
            end
            begin
                //***************************************************
                //Mask Bit
                //***************************************************
                mask_bit_vector = 0;
                for(i  =0; i < SIZE_OF_IR_REG_sTAP; i++) begin
                    mask_bit_vector[i] = 1'b1;
                end

                //************************************************
                // Slicing to GET:
                // Size of Each Register
                // Addr of Each Register
                //************************************************
                con_rw_reg_addr             = RW_REG_ADDR;
                con_rw_reg_width            = RW_REG_WIDTH;
                con_rw_reg_reset_value      = TB_DATA_REGISTER_RESET_VALUES;
                con_rw_reg_pin_not_loopback = TB_LOAD_PIN_OR_NOT_LOOPBACK;
                cummulative_reg_width       = 0;
                for(i = 0; i < NO_OF_RW_REG; i++) begin
                    rw_reg_addr[i]             = (((con_rw_reg_addr) >> (i*SIZE_OF_IR_REG_sTAP)) & mask_bit_vector);
                    rw_reg_width[i]            = (((con_rw_reg_width) >> (i*16)) & 'hFFFF);
                end
                for(i = 0; i < NO_OF_RW_REG; i++) begin
                    for(j  =0; j < rw_reg_width[i]; j++) begin
                        mask_bit_vector[j] = 1'b1;
                    end
                    cummulative_reg_width = cummulative_reg_width + rw_reg_width[i];
                end
                for(i=0;i<NO_OF_RW_REG;i++) begin
                    for(j = 0; j < rw_reg_width[i]; j++) begin
                        mask_reset_value[i][j] = 1'b1;
                    end
                end
                k = 0;
                for(i = 0; i < NO_OF_RW_REG; i++) begin
                    rw_reg_reset_value[i] = (((con_rw_reg_reset_value) >> (k)) & mask_reset_value[i]);
                    k = k + rw_reg_width[i];
                end

                k = 0;
                //No Optional register is gettin reset at reset_b
                size_of_ir = 0;
                for(i = 0; i < NO_OF_TAP; i++) begin
                    for(j = 0; j < SIZE_OF_IR_REG_sTAP; j++) begin
                        if(j == 1 )
                            con_tdi_addr[size_of_ir] = 1'b1;
                        else
                            con_tdi_addr[size_of_ir] = 1'b0;
                        size_of_ir++;
                    end//for size of ir reg
                end
                con_data_shift_reg = 0;
                //Reset at Power Good for Sticky Register
                if(power_gud_int == 1'b0) begin
                    k = 0;
                    rmv_bit = 1'b0;
                    for(i=0;i<NO_OF_RW_REG;i++) begin
                        for(j = 0; j < rw_reg_width[i]; j++) begin
                            con_shadow_reg[k] = rw_reg_reset_value[i][j];
                            k++;
                        end
                    end  
                end
            end
        join    
    endtask
    //*************************************************************************
    // End of Run Phase
    //*************************************************************************

    //*************************************************************************
    // Post Run Reporting To a Seperate Output FIle TAPNetwork.out
    //*************************************************************************
    function void report_phase (uvm_phase phase);
     if(scrbrd_pri_trkr == 1'b1) begin
        fp = $fopen("TAPNetworkPri.out","w");
        set_report_default_file(fp);
        set_report_severity_action(UVM_INFO, UVM_LOG);
        $fdisplay(fp,"--------------------------------------------");
        $fdisplay(fp,"TAP FSM State Transition Info with Timestamp");
        $fdisplay(fp,"--------------------------------------------");
        $fdisplay(fp,"          TIME    TAP_STATE"                 );
        $fdisplay(fp,"--------------------------------------------");
        for(i=0; i<state_queue.size; i++) begin
            $fdisplay(fp,"%15t     %s",state_time_queue[i],state_str(state_queue[i]));
        end
        $fdisplay(fp,"-------------------------------------------------------------------");


        $fdisplay(fp,"Addr of all IRs in Network,  Data transitions with timestamp");
        $fdisplay(fp,"-------------------------------------------------------------------");
        $fdisplay(fp,"    TIME     INSTRUCTION        Value_Shifted_In@E1DR            Value_Shifted_Out@E1DR"                 );
        $fdisplay(fp,"-------------------------------------------------------------------");
        for (i=0; i<time_queue.size; i++) begin 
            $fdisplay(fp,"%10t      %0h          %0h       %0h",time_queue[i],instr_queue[i],ip_queue[i],op_queue[i]);
        end

        $fdisplay (fp,"-------------------------------------------------------");
        $fclose(fp);
     end   
     if(scrbrd_sec_trkr == 1'b1) begin
        sp = $fopen("TAPNetworkSec.out","w");
        set_report_default_file(sp);
        set_report_severity_action(UVM_INFO, UVM_LOG);
        $fdisplay(sp,"--------------------------------------------");
        $fdisplay(sp,"TAP FSM State Transition Info with Timestamp");
        $fdisplay(sp,"--------------------------------------------");
        $fdisplay(sp,"          TIME    TAP_STATE"                 );
        $fdisplay(sp,"--------------------------------------------");
        for(i=0; i<state_queue.size; i++) begin
            $fdisplay(sp,"%15t     %s",state_time_queue[i],state_str(state_queue[i]));
        end
        $fdisplay(sp,"s------------------------------------------------------------------");


        $fdisplay(sp,"Addr of all IRs in Network,  Data transitions with timestamp");
        $fdisplay(sp,"-------------------------------------------------------------------");
        $fdisplay(sp,"    TIME     INSTRUCTION        Value_Shifted_In@E1DR            Value_Shifted_Out@E1DR"                 );
        $fdisplay(sp,"-------------------------------------------------------------------");
        for (i=0; i<time_queue.size; i++) begin 
            $fdisplay(sp,"%10t      %0h          %0h       %0h",time_queue[i],instr_queue[i],ip_queue[i],op_queue[i]);
        end

        $fdisplay(sp,"s------------------------------------------------------");
        $fclose(sp);
     end   
    endfunction : report_phase
    //*************************************************************************
    // End of Post Run Reporting
    //*************************************************************************

    task scoreboard_item();  
        forever begin
            InputMonFifo.get(InputPacket);
            // We want the input monitor to first send the packet to SB followed by the output monitor. 
            // For this we introduced events in monitors.  
            // As a result Synchonization is not needed in SB. Hence try_get is removed. 
            //OutputMonFifo.try_get(OutputPacket);
            InputMonIntFifo.get(InputIntPacket);

            state              = InputPacket.FsmState;
            vercode_sig        = InputIntPacket.vercode;
            for(i=0; i<NO_OF_TAP; i++) begin
                slvidcode_int[i]      = InputIntPacket.slvidcode[i];
            end
            power_gud_int      = InputPacket.Power_Gud_Reset;
            sec_sel_sig        = InputIntPacket.sec_sel;
            enable_tdo_sig     = InputIntPacket.enable_tdo;
            enable_tap_sig     = InputIntPacket.enable_tap;
            uvm_config_int::get(this, "","primary_scrbrd",primary_scrbrd); 
            uvm_config_int::get(this, "","secondary_scrbrd",secondary_scrbrd); 
            uvm_config_string::get(this, "","scrbrd_pri_trkr",scrbrd_pri_trkr); 
            uvm_config_string::get(this, "","scrbrd_sec_trkr",scrbrd_sec_trkr); 

            //************************************************************
            // To Record the Change in State with time  
            //************************************************************
            begin
                previous_state <= state;
                if(state != previous_state)
                begin
                    state_queue = {state_queue,state};
                   //state_time_queue  = {state_time_queue,$time}; // Synopsys core dump
                    state_time_queue.push_back($time);
                end
            end

            //***************************************************
            // Slice the Mode in which each sTAP is.
            // CLTAPC is always in NORMAL MODE
            // Count number of TAP in Normal Mode
            // Count number of TAP in Excluded Mode
            //***************************************************
            remove_bit_int = int'(rmv_bit);
            abs_position_of_taps = TB_POSTION_OF_TAPS;
            if(primary_scrbrd == 1'b1) begin
                for(i=0;i<NO_OF_TAP;i++) begin
                    position_of_tap[i] = 1'b0;
                end
            end else begin
                position_of_tap = TB_POSTION_OF_TAPS;
            end
            for(i=0;i<NO_OF_TAP;i++) begin
                if(primary_scrbrd == 1'b1) begin
                    if(i != 0) begin
                         scan_ir_dr_en[i] = ((primary_scrbrd ^ sec_sel_sig[i-1]) && enable_tdo_sig[i-1] && enable_tap_sig[i-1] && !(position_of_tap[i-1]));
                    end else begin
                      scan_ir_dr_en[i] = primary_scrbrd; 
                    end
                end else begin
                    if(position_of_tap[i] == 1'b0) begin
                        if(i != 0) begin
                             scan_ir_dr_en[i] = ((primary_scrbrd ^ sec_sel_sig[i-1]) && enable_tdo_sig[i-1] && enable_tap_sig[i-1] );
                        end else begin
                          scan_ir_dr_en[i] = primary_scrbrd; 
                        end
                    end else begin
                         scan_ir_dr_en[i] = 1'b0;
                    end
                end
            end
            
            //***************************************************
            // Reset the Shift and Shadow Registers at TLRS
            //***************************************************
            if(state == TLRS) begin
                //***************************************************
                //Mask Bit
                //***************************************************
                mask_bit_vector = 0;
                for(i  =0; i < SIZE_OF_IR_REG_sTAP; i++) begin
                    mask_bit_vector[i] = 1'b1;
                end

                //************************************************
                // Slicing to GET:
                // Size of Each Register
                // Addr of Each Register
                //************************************************
                con_rw_reg_addr             = RW_REG_ADDR;
                con_rw_reg_width            = RW_REG_WIDTH;
                con_rw_reg_reset_value      = TB_DATA_REGISTER_RESET_VALUES;
                con_rw_reg_pin_not_loopback = TB_LOAD_PIN_OR_NOT_LOOPBACK;
                cummulative_reg_width       = 0;
                for(i = 0; i < NO_OF_RW_REG; i++) begin
                    rw_reg_addr[i]             = (((con_rw_reg_addr) >> (i*SIZE_OF_IR_REG_sTAP)) & mask_bit_vector);
                    rw_reg_width[i]            = (((con_rw_reg_width) >> (i*16)) & 'hFFFF);
                end
                for(i = 0; i < NO_OF_RW_REG; i++) begin
                    for(j  =0; j < rw_reg_width[i]; j++) begin
                        mask_bit_vector[j] = 1'b1;
                    end
                    cummulative_reg_width = cummulative_reg_width + rw_reg_width[i];
                end
                for(i=0;i<NO_OF_RW_REG;i++) begin
                    for(j = 0; j < rw_reg_width[i]; j++) begin
                        mask_reset_value[i][j] = 1'b1;
                    end
                end
                k = 0;
                for(i = 0; i < NO_OF_RW_REG; i++) begin
                    rw_reg_reset_value[i] = (((con_rw_reg_reset_value) >> (k)) & mask_reset_value[i]);
                    k = k + rw_reg_width[i];
                end

                k = 0;
                //No Optional register is gettin reset at reset_b
                size_of_ir = 0;
                for(i = 0; i < NO_OF_TAP; i++) begin
                    for(j = 0; j < SIZE_OF_IR_REG_sTAP; j++) begin
                        if(j == 1 )
                            con_tdi_addr[size_of_ir] = 1'b1;
                        else
                            con_tdi_addr[size_of_ir] = 1'b0;
                        size_of_ir++;
                    end//for size of ir reg
                end
                con_data_shift_reg = 0;
            end
            //Reset at Power Good for Sticky Register
            if(power_gud_int == 1'b0) begin
                k = 0;
                rmv_bit = 1'b0;
                for(i=0;i<NO_OF_RW_REG;i++) begin
                    for(j = 0; j < rw_reg_width[i]; j++) begin
                        con_shadow_reg[k] = rw_reg_reset_value[i][j];
                        k++;
                    end
                end  
            end
            //*****************************************************************
            // Load 'h1 for all the Instruction Register
            // Instruction Register would only be for Normal and Exclude Mode
            //*****************************************************************
            if(state == CAIR) begin
                no_of_ir_shift         = 0;
                expected_parallel_addr = 0;
                size_of_ir   = 0;
                con_tdi_addr = 0;
                for(i = remove_bit_int; i < NO_OF_TAP; i++) begin
                    if(scan_ir_dr_en[i] == 1'b1) begin
                        for(j = 0; j < SIZE_OF_IR_REG_sTAP; j++) begin
                            if(j == 0)
                                con_tdi_addr[size_of_ir] = 1'b1;
                            else
                                con_tdi_addr[size_of_ir] = 1'b0;
                            size_of_ir++;
                        end//for size of ir reg
                    end
                end//for no_rw_reg
                if(scan_ir_dr_en == 0) begin
                    con_tdi_addr = InputPacket.ShiftRegisterAddress;
                end    
            end //CAIR

            //*****************************************************************
            // To account for Number of Shift for Instruction Register
            //*****************************************************************
            if(state == SHIR) begin
                active_stap_ir = 0;
                for(i= remove_bit_int;i<NO_OF_TAP;i++) begin
                    if(primary_scrbrd == 1'b1) begin
                        if(i != 0) begin
                             scan_ir_en[i] = ((primary_scrbrd ^ sec_sel_sig[i-1]) && enable_tdo_sig[i-1] && enable_tap_sig[i-1] && !(position_of_tap[i-1]));
                        end else begin
                          scan_ir_en[i] = primary_scrbrd; 
                        end
                    end else begin
                        if(position_of_tap[i] == 1'b0) begin
                            if(i != 0) begin
                                 scan_ir_en[i] = ((primary_scrbrd ^ sec_sel_sig[i-1]) && enable_tdo_sig[i-1] && enable_tap_sig[i-1] );
                            end else begin
                              scan_ir_en[i] = primary_scrbrd; 
                            end
                        end else begin
                             scan_ir_en[i] = 1'b0;
                        end
                    end
                    if( scan_ir_en[i] == 1'b1 )    
                        active_stap_ir = active_stap_ir + 1'b1;
                end              
                if(scan_ir_dr_en == 0) begin
                    con_tdi_addr = InputPacket.ShiftRegisterAddress;
                end
                expected_parallel_addr = 0;
                for(j=0;j<no_of_ir_shift;j++) begin
                    expected_parallel_addr[j] = con_tdi_addr[j];
                end
                //expected_parallel_addr = con_tdi_addr;
                no_of_ir_shift ++;
            end

            //*****************************************************************
            // Getting the resultant IR after Shift IR state
            //*****************************************************************
            if(state == E1IR) begin
                for(i = 0;i < no_of_ir_shift; i++) begin
                    for(j = 0; j < size_of_ir; j++) begin
                        if(j == size_of_ir-1) begin
                            con_tdi_addr[j] = InputPacket.ShiftRegisterAddress[i];
                        end else begin
                            con_tdi_addr[j] = con_tdi_addr[j+1];
                        end
                    end
                end
                no_of_ir_shift = 0;
            end

            //***************************************************
            // Address Check at E1IR / UPIR
            //***************************************************
            if(state == E1IR ) begin
            OutputMonFifo.get(OutputPacket);
                if(OutputPacket.ShiftRegisterAddress === expected_parallel_addr) begin
                        $swrite (msg,"**Address Matches !!!\nActual   Addr: %0h\nExpected Addr: %0h ",
                                    OutputPacket.ShiftRegisterAddress, expected_parallel_addr );
                      `uvm_info(get_type_name(),msg, UVM_MEDIUM);
                end   
                else begin
                    `uvm_error(get_type_name(),$psprintf("**Address Mis-Matches\nActual   Addr: %0h\nExpected Addr: %0h",OutputPacket.ShiftRegisterAddress,expected_parallel_addr));
               end    
            end

            //***************************************************
            // Load the Parallel data to Cancatenated DR in CADR
            //***************************************************
            if(state == CADR) begin
                for(i=remove_bit_int;i<NO_OF_TAP;i++) begin
                    if(primary_scrbrd == 1'b1) begin
                        if(i != 0) begin
                             scan_dr_en[i] = ((primary_scrbrd ^ sec_sel_sig[i-1]) && enable_tdo_sig[i-1] && enable_tap_sig[i-1] && !(position_of_tap[i-1]));
                        end else begin
                          scan_dr_en[i] = primary_scrbrd; 
                        end
                    end else begin
                        if(position_of_tap[i] == 1'b0) begin
                            if(i != 0) begin
                                 scan_dr_en[i] = ((primary_scrbrd ^ sec_sel_sig[i-1]) && enable_tdo_sig[i-1] && enable_tap_sig[i-1] );
                            end else begin
                              scan_dr_en[i] = primary_scrbrd; 
                            end
                        end else begin
                             scan_dr_en[i] = 1'b0;
                        end
                    end
                    if((scan_dr_en[i] && scan_ir_en[i]) == 1'b1) begin
                        mltapc_mode[i] = 2'b01;
                    end else if  ((~scan_dr_en[i] && scan_ir_en[i]) == 1'b1) begin
                        mltapc_mode[i] = 2'b10; 
                    end else begin
                        mltapc_mode[i] = 2'b00;
                    end
                end
                 //***************************************************
                 //Mask Bit
                 //***************************************************
                 mask_bit_vector = 0;
                 for(i = 0; i < SIZE_OF_IR_REG_sTAP; i++) begin
                     mask_bit_vector[i] = 1'b1;
                 end

                 //************************************************
                 // Slicing to GET:
                 // Size of Each Register
                 // Addr of Each Register
                 //************************************************
                 con_rw_reg_addr             = RW_REG_ADDR;
                 con_rw_reg_width            = RW_REG_WIDTH;
                 con_rw_reg_reset_value      = TB_DATA_REGISTER_RESET_VALUES;
                 for(i = 0; i < NO_OF_RW_REG; i++) begin
                     rw_reg_addr[i]  = (((con_rw_reg_addr) >> (i*SIZE_OF_IR_REG_sTAP)) & mask_bit_vector);
                     rw_reg_width[i] = (((con_rw_reg_width) >> (i*16)) & 'hFFFF);
                 end
                 for(i = 0; i < NO_OF_RW_REG; i++) begin
                     for(j = 0; j < rw_reg_width[i]; j++) begin
                         mask_reset_value[i][j] = 1'b1;
                     end
                 end

                 //************************************************
                 // Slicing to GET:
                 // Number of Registers in each sTAP
                 // INSTR set for each sTAP
                 //************************************************
                 con_no_of_dr_reg_stap = CON_NO_OF_DR_REG_STAP;
                 k = 0;
                 for(i=0;i<NO_OF_TAP;i++) begin
                     no_of_dr_reg[i]    = (((con_no_of_dr_reg_stap) >> (i*16)) & 16'hFFFF);
                     rw_reg_addr_tdi[i] = (((con_tdi_addr) >> ((i)*SIZE_OF_IR_REG_sTAP)) & mask_bit_vector);
                 end

                 //***************************************************
                 // Update the Shadow Register LSB Position Array
                 //***************************************************
                 dr_reg_no      = 0;
                 shadow_reg_len = 0;
                 for(i = 0; i < NO_OF_TAP; i++) begin
                     for(j = 0; j < no_of_dr_reg[i]; j++) begin
                         lsb_pos_shadow_reg[i][j] = shadow_reg_len;
                         shadow_reg_len = shadow_reg_len + rw_reg_width[dr_reg_no];
                         dr_reg_no ++;
                     end
                 end

                 //******************************************************************************
                 // To Check for each sTAP  if its BYPASS IDCODE or DR reg is selected
                 //******************************************************************************
                 k = 0;
                 l = 0;
                 for(i = 0; i < NO_OF_TAP; i++) begin
                     flag_mode_chk = 0;
                     if(!(remove_bit_int == 1 && i ==0)) begin
                     if(mltapc_mode[i] == 2'b01) begin
                         if( rw_reg_addr_tdi[active_stap_ir-l-1] == 'h0C) begin
                             mode[i]  = 2'b10;
                             k = k + no_of_dr_reg[i];
                         end else begin
                             for(j = 0; j < no_of_dr_reg[i]; j++) begin
                                 if( rw_reg_addr[k] == rw_reg_addr_tdi[active_stap_ir-l-1]) begin
                                     flag_mode_chk[j] = 1'b1;
                                 end else begin
                                     flag_mode_chk[j] = 1'b0;
                                 end
                                 k++;
                             end
                             if(flag_mode_chk == 0)
                                 mode[i] = 2'b01;
                             else
                                 mode[i] = 2'b11;
                             flag_mode_chk = 0;
                         end
                         l++;
                     end else begin
                         k = k + no_of_dr_reg[i];
                         mode[i] = 2'b00;
                         if(mltapc_mode[i] == 2'b10)
                             l++;
                     end
                     end else begin
                         k = k + no_of_dr_reg[i];
                     end

                 end
                 //******************************************************************************
                 // To insert 0 for all the RO Registers as the are LoopBacked at CADR and donot
                 // have a parallel in.
                 //******************************************************************************
                 i=0;
                 k=0; 
                 for(i=0;i<=TOTAL_DATA_REGISTER_WIDTH-1; i++) begin
                     if(i<RO_REGISTER_WIDTH) begin
                         parallel_data_in[i]  = 1'b0;
                     end else begin     
                         parallel_data_in[i]  = InputPacket.Parallel_Data_in[k];
                         k++;
                     end 
                 end    
                 //******************************************************************************
                 // To  know the width of shift data register so as to insert the tdi at MSB
                 // Load all the RO register with their default value
                 //******************************************************************************
                 tdo_tap            = 0;
                 l                  = NO_OF_RW_REG-1;
                 con_data_shift_reg = 0;
                 m                  = 0;
                 for(i = NO_OF_TAP - 1; i >= remove_bit_int; i--) begin
                     if(mltapc_mode[i] == 2'b01) begin
                         if(mode[i] == 2'b01) begin //BYPASS
                             con_data_shift_reg[tdo_tap] = 1'b0;
                             tdo_tap++  ;
                             l = l - no_of_dr_reg[i];
                         end else if(mode[i] == 2'b10) begin //ID CODE
                             for(j = 0; j < IDCODE_WIDTH; j++) begin
                                 if(VERCODE == 1) begin
                                     if(j > IDCODE_WIDTH - 4 -1)begin
                                         con_data_shift_reg[tdo_tap] = vercode_sig[j-IDCODE_WIDTH + 4];
                                     //end else if (j == 27)begin
                                     //    if(abs_position_of_taps[i] == 1'b0)
                                     //        con_data_shift_reg[tdo_tap] = 1'b0;
                                     //    else     
                                     //        con_data_shift_reg[tdo_tap] = 1'b1;
                                     end else if (j != 0)
                                         con_data_shift_reg[tdo_tap] = slvidcode_int[i][j];
                                     else 
                                         con_data_shift_reg[tdo_tap] = 1'b1; //The First Bit of IDCODE is Tied to Logic 1
                                 //`else
                                 end else begin
                                     if(j == 0) begin
                                         con_data_shift_reg[tdo_tap] = 1'b1; //The First Bit of IDCODE is Tied to Logic 1
                                     //end else if (j == 27)begin
                                     //    if(abs_position_of_taps[i] == 1'b0)
                                     //        con_data_shift_reg[tdo_tap] = 1'b0;
                                     //    else     
                                     //        con_data_shift_reg[tdo_tap] = 1'b1;
                                     end else begin
                                         con_data_shift_reg[tdo_tap] = slvidcode_int[i][j];
                                     end 
                                 //`endif
                                 end
                                 tdo_tap++;
                             end
                         end else if(mode[i] == 2'b11) begin
                             for(j = 0; j < no_of_dr_reg[i]; j++) begin
                                 if(rw_reg_addr[l] == rw_reg_addr_tdi[m]) begin
                                     for(k = lsb_pos_shadow_reg[i][no_of_dr_reg[i] - j - 1];
                                         k < (rw_reg_width[l] + lsb_pos_shadow_reg[i][no_of_dr_reg[i] - j - 1]);
                                         k++) begin
                                         if(con_rw_reg_pin_not_loopback[k] == 1'b1) begin
                                             con_data_shift_reg[tdo_tap] = parallel_data_in[k];
                                         end else begin
                                             con_data_shift_reg[tdo_tap] = con_shadow_reg[k];
                                         end
                                         tdo_tap++;
                                     end
                                     sel_dr_reg[i] = no_of_dr_reg[i] - j - 1;
                                     sel_dr_no[i]  = l;
                                 end
                                 l--;
                             end
                         end
                         m++;
                     end
                     else if(mltapc_mode[i] == 2'b10) begin
                         l = l - no_of_dr_reg[i];
                         m++;
                     end else begin
                         l = l - no_of_dr_reg[i];
                     end
                 end
                 no_of_dr_shift = 0;
                 no_of_data_shift = 0;
                 expected_tdo_data = 0;
             end//if CADR

             //*****************************************************************
             // Update and shift the Shift Register
             //*****************************************************************
             if(state == SHDR) begin
                 expected_tdo_data[no_of_data_shift] = con_data_shift_reg[0];
                 for(j = 0; j < tdo_tap; j++) begin
                     if(j == tdo_tap-1) begin
                         con_data_shift_reg[j] = InputPacket.ShiftRegisterData[no_of_dr_shift];
                     end else begin
                         con_data_shift_reg[j] = con_data_shift_reg[j+1];
                     end
                 end
                 no_of_data_shift ++;
                 no_of_dr_shift ++;
             end//if SHDR

             //*****************************************************************
             // Count the number of shift that takes place before exiting SHDR
             //*****************************************************************
             if(state == CADR || state == E2DR) begin
                 no_of_data_shift  = 0;
                 expected_tdo_data = 0;
             end

             //*****************************************************************
             // Compare the Serial shift data with actual tdo shift reg at E1DR
             //*****************************************************************
             if(state == E1DR) begin
              OutputMonFifo.get(OutputPacket);
                 flag_serial_data_error = 0; 
                 actual_tdo_data        = 0; 
                 for(i = 0; i < no_of_data_shift; i++) begin
                     if(expected_tdo_data[i] === OutputPacket.ShiftRegisterData[i]) begin
                         flag_serial_data_error[i] = 1'b0;
                         actual_tdo_data[i] =  OutputPacket.ShiftRegisterData[i];
                         actual_tdi_data[i] =  InputPacket.ShiftRegisterData[i];
                     end else begin
                         flag_serial_data_error[i] = 1'b1;
                         actual_tdo_data[i] =  OutputPacket.ShiftRegisterData[i];
                         actual_tdi_data[i] =  InputPacket.ShiftRegisterData[i];
                     end    
                 end
                 time_queue             = {time_queue,$time};
                 instr_queue            = {instr_queue,con_tdi_addr};
                 ip_queue               = {ip_queue,actual_tdi_data}; 
                 op_queue               = {op_queue,actual_tdo_data};

                 if(flag_serial_data_error == 0) begin
                        $swrite (msg,"**Data Matches !!!\nActual   Data: %0h\nExpected Data: %0h",
                                     actual_tdo_data,
                                     expected_tdo_data );
                     `uvm_info(get_type_name(),msg , UVM_MEDIUM);
                 end   
                 else begin
                     `uvm_error(get_type_name(), $psprintf("**Data Mis Match \nActual Data: %0h\nExpected Data: %0h",actual_tdo_data,expected_tdo_data));
                end    
             end

             //********************************************************************
             // Update the Concatenated Shadow register with the Shift Reg value
             //********************************************************************
             if(state == UPDR) begin
              OutputMonFifo.get(OutputPacket);
                 updr_tap = tdo_tap;
                 for(i = remove_bit_int; i < NO_OF_TAP; i++) begin
                     if(mode[i] == 2'b11) begin
                         dr_no             = sel_dr_no[i];
                         dr_reg            = sel_dr_reg[i];
                         k                 = lsb_pos_shadow_reg[i][dr_reg];
                         l                 = updr_tap - rw_reg_width[dr_no];
                         for(j = 0; j < rw_reg_width[dr_no]; j++) begin
                             con_shadow_reg[k+j]        = con_data_shift_reg[l+j];
                             if(rw_reg_addr[dr_no] == 'h14 && i == 0) begin
                                 rmv_bit  = con_data_shift_reg[l];
                             end                             
                             updr_tap--;
                         end
                     end else if(mode[i] == 2'b01) begin
                         updr_tap --;
                     end else if(mode[i] == 2'b10) begin
                         updr_tap = updr_tap -32;
                     end
                     k = 0;
                     for(m=0;m<=TOTAL_DATA_REGISTER_WIDTH;m++) begin
                         if(m>=NO_PARALLEL_OUT_BIT_WIDTH)  begin
                             expected_parallel_data_out[k] = con_shadow_reg[m];
                             k++;
                         end    
                     end
                     if (MULTIPLE_TAP == 0) begin
                         if(OutputPacket.ParallelDataOut === (expected_parallel_data_out )) begin
                        $swrite (msg,"**Parallel Data Matches !!!\nActual Data: %0h\nExpected Data: %0h",
                                             OutputPacket.ParallelDataOut,
                                             (expected_parallel_data_out));
                             `uvm_info(get_type_name(),msg , UVM_MEDIUM);
                         end   
                         else begin
                             `uvm_error(get_type_name(), $psprintf("**Parallel Data  Mis Matches !!!\nActual Data: %0h\nExpected Data: %0h",OutputPacket.ParallelDataOut,expected_parallel_data_out ));
                        end    
                     end
                 end
             end
        end
    endtask : scoreboard_item

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

endclass : TapScoreBoard
