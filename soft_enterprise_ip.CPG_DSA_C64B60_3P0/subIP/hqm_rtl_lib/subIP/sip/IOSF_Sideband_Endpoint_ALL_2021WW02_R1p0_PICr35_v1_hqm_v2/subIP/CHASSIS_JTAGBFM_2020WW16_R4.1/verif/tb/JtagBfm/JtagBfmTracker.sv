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


`ifndef INC_JtagBfmTracker
 `define INC_JtagBfmTracker

`ifndef CHASSIS_JTAGBFM_TRACKER_WIDTH
   parameter TRACKER_TOTAL_DATA_REGISTER_WIDTH = 128;
`else
   parameter TRACKER_TOTAL_DATA_REGISTER_WIDTH = `CHASSIS_JTAGBFM_TRACKER_WIDTH;
`endif

`ifndef CHASSIS_JTAG_WORD_LENGTH
   parameter JTAG_WORD_LENGTH                  = 32;
`else
   parameter JTAG_WORD_LENGTH                  = `CHASSIS_JTAG_WORD_LENGTH;
`endif

`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
class JtagBfmTracker #(`JTAG_IF_PARAMS_DECL) extends ovm_component;
`else    
class JtagBfmTracker extends ovm_component;
`endif

    //************************
    //Local Declarations
    //************************
    int                                           addr_pointer     = 0;
    int                                           data_pointer     = 0;
    reg [3:0]                                     current_state    = TLRS;
    reg [3:0]                                     state            = TLRS;
    reg [TRACKER_TOTAL_DATA_REGISTER_WIDTH-1:0]   ShiftedOut_addr;
    bit [TRACKER_TOTAL_DATA_REGISTER_WIDTH-1:0]   ShiftedOut_data;

    bit [TRACKER_TOTAL_DATA_REGISTER_WIDTH- 1:0]  ShiftedIn_data = 0;
    bit [TRACKER_TOTAL_DATA_REGISTER_WIDTH -1:0]  ShiftedIn_addr = 0;
   
    time                                          state_time_queue[$];
    reg [3:0]                                     state_queue[$];
    logic [TRACKER_TOTAL_DATA_REGISTER_WIDTH -1:0]  ShiftedOut_Queue[$];

    bit [TRACKER_TOTAL_DATA_REGISTER_WIDTH -1:0]  ShiftedIn_Queue[$];
    integer                                       size_of_ir = 0;
    integer                                       size_of_dr = 0;
    int                                           num_word = $ceil (real '(TRACKER_TOTAL_DATA_REGISTER_WIDTH/JTAG_WORD_LENGTH));

    bit [TRACKER_TOTAL_DATA_REGISTER_WIDTH - 1:0] shift_queue[$];
    integer                                       lclsize_of_ir;
    integer                                       lclsize_of_dr;

    //FILE fp;
    int                                           fp;

    //FILE pointer names for runtime tracker
    int                                           r_fp;
    int                                           jtag_bfm_runtime_tracker_en  = 0; //run time tracker enable switch
    
    //File name to be used for the tracker output files
    string                                        int_string_print_pri;

    string                                        int_string_print_run_pri;

    // Store the configuration value for tracker.
    protected bit                                 jtag_bfm_tracker_en;
    string                                        tracker_name               = "JTAG";  //assigning the default name
    string                                        jtag_tracker_agent_name;
    string                                        header_write_string;

    int                                           var_for_depricated_feature;

    // Store the configuration value for tracker.
    protected bit                                 primary_tracker;
    protected bit                                 secondary_tracker;
    protected bit [((NUMBER_OF_TERTIARY_PORTS>0)? NUMBER_OF_TERTIARY_PORTS-1:0):0]  tertiary_tracker;
    protected bit                                 sample_tdo_on_negedge; //Non IEEE compliance mode, used only for TAP's not on the boundary of SoC.
    protected bit                                 unsplit_ir_dr_data;

    // For printing the active TAPs in the network, get the handle for the History Table static object from below class
    JtagBfmSoCTapNwSequences                     i_JtagBfmSoCTapNwSequences ;

    //*************************************
    // Register component with Factory
    //*************************************
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
    `ovm_component_param_utils_begin(JtagBfmTracker #(CLOCK_PERIOD,PWRGOOD_SRC,CLK_SRC,BFM_MON_CLK_DIS))
`else    
    `ovm_component_utils_begin(JtagBfmTracker)
`endif
      `ovm_field_int(jtag_bfm_tracker_en, OVM_FLAGS_ON)
      `ovm_field_int(primary_tracker, OVM_FLAGS_ON)
      `ovm_field_int(secondary_tracker, OVM_FLAGS_ON)
      `ovm_field_int(tertiary_tracker, OVM_FLAGS_ON)
      `ovm_field_int(sample_tdo_on_negedge, OVM_ALL_ON)
    `ovm_component_utils_end 

    //********************************************
    // Constructor
    //********************************************
    function new (string name = "JtagBfmTracker", ovm_component parent = null);
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

    function void build ();
      super.build();
      i_JtagBfmSoCTapNwSequences = JtagBfmSoCTapNwSequences ::type_id::create("i_JtagBfmSoCTapNwSequences");
    endfunction

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
        
        if(!get_config_int("jtag_bfm_tracker_en",  jtag_bfm_tracker_en)) begin
         `ovm_info(get_name(), "jtag_bfm_tracker_en not set : Disabling JTAG Tracker",OVM_LOW)
        end

        if(!get_config_int("jtag_bfm_runtime_tracker_en",jtag_bfm_runtime_tracker_en)) begin
         `ovm_info(get_name(), "jtag_bfm_runtime_tracker_en not set: Disabling JTAG runtime Tracker",OVM_LOW)
        end
        
        if(!get_config_string("tracker_name",tracker_name)) begin
          `ovm_info(get_name(), "tracker_name not set: Using the name JTAG",OVM_LOW)
        end


        // to enable backward compatibility with pri/sec/tertiary tracker variables, 
        // the below code is being added
        get_config_int("primary_tracker",  primary_tracker); 
        get_config_int("secondary_tracker",secondary_tracker); 
        get_config_int("tertiary_tracker", tertiary_tracker); 

        //if(get_config_int("primary_tracker",var_for_depricated_feature)) begin
        // `ovm_warning(get_name(), " \n\n ***** IMPORTANT ***** \n \
        // Use of \"primary_tracker\" in JtagBfmCfg is depricated and will not be supported in future releases \n \
        // Please use jtag_bfm_tracker_en          = 1 for enabling the tarcker \n \
        //            jtag_bfm_runtime_tracker_en  = 1 for enabling the runtime tracker \n\n")
        //end

        int_string_print_pri     = {tracker_name,"_",jtag_tracker_agent_name, "_jtag_tracker_normal.out"};
        int_string_print_run_pri = {tracker_name,"_",jtag_tracker_agent_name, "_jtag_tracker_runtime.out"};
        
        assert ($onehot0({primary_tracker,secondary_tracker,tertiary_tracker}))
          else begin
            $error("Multiple tracker bits are enabled for this instance of BFM. \nSet only a single tracker bit that corresponds to the below instance.");
            `ovm_info("","",OVM_NONE);
          end
    endfunction : connect   

    //********************************************
    //Run
    //********************************************
    virtual task run();
        tracker_monitor_item();
    endtask : run

    //**************************************************
    // Tracker Monitor Item task that monitors the PinIf 
    //**************************************************
    task tracker_monitor_item();
    r_fp = $fopen(int_string_print_run_pri,"w");
    $fclose (r_fp);
    write_to_trk_file (1);
    //string msg;
    fork
        forever
        begin
            //***********************************
            // Capture the Parallel data at UPDR
            //***********************************
            @(posedge PinIf.tck);
                if(current_state == TLRS)
                begin
                    ShiftedIn_addr = 0;
                    ShiftedIn_data = 0;
                    if(sample_tdo_on_negedge==0)begin 
                       addr_pointer   = 0;
                       data_pointer   = 0;
                    end
                    lclsize_of_ir  = 0;
                    lclsize_of_dr  = 0;
                end
                 if(current_state == RUTI) begin
                    lclsize_of_ir  = 0;
                    lclsize_of_dr  = 0;
                 end   
                 if(current_state == CAIR) begin
                    size_of_ir = 0;
                    if(sample_tdo_on_negedge==0)begin 
                       addr_pointer = 0;
                    end
                    ShiftedIn_addr = 0;
                    lclsize_of_ir  = 0;
                    lclsize_of_dr  = 0;
                 end   
                //***************************************************
                // Accumulate tdo into addr shift register at SHIR
                //***************************************************
                 if(current_state == SHIR)
                 begin
                    if(sample_tdo_on_negedge==0)begin 
                       ShiftedOut_addr[addr_pointer] = PinIf.tdo;
                       addr_pointer++;
                    end
                    ShiftedIn_addr[size_of_ir] =PinIf.tdi;
                    size_of_ir ++;
                    lclsize_of_ir = size_of_ir;
                 end
                 if(current_state == E1IR)begin
                    if(sample_tdo_on_negedge==0)begin 
                       addr_pointer = 0;
                    end
                 end
                 if((current_state == E2IR) && (unsplit_ir_dr_data == 1'b0)) begin
                    size_of_ir = 0;
                 end
                 //***************************************************
                 // Accumulate tdo into data shift register at SHDR
                 //***************************************************
                 if(current_state == SHDR)
                 begin
                     if(sample_tdo_on_negedge==0)begin 
                       ShiftedOut_data[data_pointer] = PinIf.tdo;
                       data_pointer++;
                     end
                     ShiftedIn_data[size_of_dr] =PinIf.tdi;
                     size_of_dr++;
                     lclsize_of_dr = size_of_dr;
                 end
                 if(current_state == E1DR)begin
                    if(sample_tdo_on_negedge==0)begin 
                       data_pointer = 0;
                    end
                 end
                 //***************************************************
                 if(current_state == CADR || ((current_state == E2DR) && (unsplit_ir_dr_data == 1'b0)) ) begin
                    size_of_dr = 0;
                 end
                 if (current_state == UPIR) begin
                    shift_queue.push_back(lclsize_of_ir);
                    ShiftedIn_Queue.push_back(ShiftedIn_addr);
                    ShiftedOut_Queue.push_back(ShiftedOut_addr);
                    state_queue.push_back(current_state);
                    state_time_queue.push_back($time);

                    //--------added test logic to dump data in run time----------//
                    // https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=4965856
                    // Enhancement: Support jtag trk printout during simulation
                    write_to_trk_file (0);
                    //------- added logic ends here--------------------------//
                 end                    

                 if (current_state == E2DR) begin
                    shift_queue.push_back(lclsize_of_dr);
                    ShiftedIn_Queue.push_back(ShiftedIn_data);
                    if(sample_tdo_on_negedge==0)begin 
                       ShiftedOut_Queue.push_back(ShiftedOut_data);
                    end
                    state_queue.push_back(current_state);
                    state_time_queue.push_back($time);
                 
                    //--------added test logic to dump data in run time----------//
                    // https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=4965856
                    // Enhancement: Support jtag trk printout during simulation
                    write_to_trk_file (0);
                    //------- added logic ends here--------------------------//
                 end                    

                 if (current_state == UPDR) begin
                    shift_queue.push_back(lclsize_of_dr);
                    ShiftedIn_Queue.push_back(ShiftedIn_data);
                    if(sample_tdo_on_negedge==0)begin 
                       ShiftedOut_Queue.push_back(ShiftedOut_data);
                    end
                    state_queue.push_back(current_state);
                    state_time_queue.push_back($time);
                 
                    //--------added test logic to dump data in run time----------//
                    // https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=4965856
                    // Enhancement: Support jtag trk printout during simulation
                    write_to_trk_file (0);
                    //------- added logic ends here--------------------------//

                 end                    
        end

        //***********************************
        // Capture the Parallel data out at UPDR when sample_tdo_on_neg_edge=0 
        //***********************************
        if(sample_tdo_on_negedge)begin 
          forever
          begin
            //***********************************
            // Capture the Parallel data at UPDR
            //***********************************
            @(negedge PinIf.tck);
                if(current_state == TLRS)
                begin
                    addr_pointer   = 0;
                    data_pointer   = 0;
                end
                 if(current_state == CAIR) begin
                    addr_pointer = 0;
                 end   
                //***************************************************
                // Accumulate tdo into addr shift register at SHIR
                //***************************************************
                 if(current_state == SHIR)
                 begin
                       ShiftedOut_addr[addr_pointer] = PinIf.tdo;
                       addr_pointer++;
                 end
                 if(current_state == E1IR)
                   addr_pointer = 0;
                 //***************************************************
                 // Accumulate tdo into data shift register at SHDR
                 //***************************************************
                 if(current_state == SHDR)
                 begin
                       ShiftedOut_data[data_pointer] = PinIf.tdo;
                       data_pointer++;
                 end
                 if(current_state == E1DR)
                     data_pointer = 0;

                 //***************************************************
                 //if (current_state == UPIR) begin
                 //   ShiftedOut_Queue.push_back(ShiftedOut_addr);
                 //end                    

                 if (current_state == E2DR) begin
                       ShiftedOut_Queue.push_back(ShiftedOut_data);
                 end                    

                 if (current_state == UPDR) begin
                       ShiftedOut_Queue.push_back(ShiftedOut_data);
                 end                    

          end//forever
        end//if
        //*******************
        // Call FSM Task
        //*******************
        forever
        begin
            tracker_tap_fsm;
        end

    join
    endtask : tracker_monitor_item
    //************************************************
    // FSM
    //************************************************
  task tracker_tap_fsm;
    begin
        // Added negedge powergood_rst_b, trst_b condition just like how it is in RTL. 25May13. HSD 4964516
        @(posedge PinIf.tck or negedge PinIf.powergood_rst_b or negedge PinIf.trst_b); 
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
                else current_state = SHDR;
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
                else current_state = SHDR;
            end // case: E2DR

            UPDR:begin
                if(PinIf.tms) current_state = SDRS;
                else current_state = RUTI;
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


    function write_to_trk_file;
      input bit header;
      string run_str;
      begin
        if(jtag_bfm_tracker_en == 1) begin
          if (jtag_bfm_runtime_tracker_en  ==1) begin
            r_fp = $fopen(int_string_print_run_pri,"a");
            set_report_default_file(r_fp);
            set_report_severity_action(OVM_INFO, OVM_LOG);
            $swrite (run_str,{(110+(2*(JTAG_WORD_LENGTH/4))){"-"}}); 
            $swrite ( header_write_string,"IRWidth Opcode TapName     %sTIME%sSTATE%s No_of_Shifts%sTDI_ShiftedIn%s TDO_ShiftedOut", 
                                               {12{" "}},{12{" "}},{3{" "}},{(JTAG_WORD_LENGTH/8){" "}}, {((JTAG_WORD_LENGTH/8)+5){" "}} );
            if (header ==1 ) begin
                 $fdisplay(r_fp,run_str);
                 $fdisplay(r_fp,"CHASSIS JTAG BFM Runtime Tracker ver 2020WW16_R4.1");
                 $fdisplay(r_fp,{"File Name:- ",int_string_print_run_pri});
            end 
            else begin
              if (current_state == UPIR) begin
                $fdisplay(r_fp,{"\n",run_str});
                $fdisplay(r_fp,header_write_string);
                $fdisplay(r_fp,run_str);
                // DFx JTAG BFM Tracker to display active taps in tap network                       
                // https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=5188748
                foreach (i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i]) begin
                   // Dump only primary activity into primary tracker
                   if (primary_tracker == 1) begin 
                      if ((i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].IsTapEnabled) &
                          (i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].IsTapOnPrimary)) begin
                          $fdisplay(r_fp,"%2d %s %0h \t %0s ", i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].IrWidthOfEachTap,
                                                             {6{" "}},
                                                             i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].CurrentlyAccessedIr,
                                                             i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].TapOfInterest);
                      end 
                   end

                   // Dump only secondary activity into secondary tracker
                   if (secondary_tracker == 1) begin 
                      if ((i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].IsTapEnabled) &
                          (i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].IsTapOnSecondary)) begin
                          $fdisplay(r_fp,"%2d %s %0h \t %0s ", i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].IrWidthOfEachTap,
                                                             {6{" "}},
                                                             i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].CurrentlyAccessedIr,
                                                             i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].TapOfInterest);
                      end 
                   end

                   // Dump only tertiary activity into tertiary tracker
                   for (int m=0; m<NUMBER_OF_TERTIARY_PORTS; m++) begin
                      if (tertiary_tracker[m] == 1) begin 
                         if ((i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].IsTapEnabled) &
                             (i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].IsTapOnTertiary[m])) begin
                             $fdisplay(r_fp,"%2d %s %0h \t %0s ", i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].IrWidthOfEachTap,
                                                                {6{" "}},
                                                                i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].CurrentlyAccessedIr,
                                                                i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].TapOfInterest);
                         end 
                      end
                   end // for
                    
                end // foreach`                         
    
                data_chopper(ShiftedIn_addr,ShiftedOut_addr,lclsize_of_ir);
              end
              else if ((current_state == UPDR) || (current_state == E2DR)) begin
                data_chopper(ShiftedIn_data,ShiftedOut_data,lclsize_of_dr); 
              end
            end
            $fclose(r_fp);
          end
        end
      end
    endfunction


    function data_chopper;
      input logic [TRACKER_TOTAL_DATA_REGISTER_WIDTH- 1:0]  ShiftedIn_local;
      input logic [TRACKER_TOTAL_DATA_REGISTER_WIDTH- 1:0]  ShiftedOut_local;
      input integer lclsize_of_ir_dr;
      string run_str;
      begin
        for (int j =0; j <num_word; j ++) begin
          if (j ==0 ) begin
            $fdisplay(r_fp, "\n%45.3f %13s     %5d             %h           %h    DWord  [%02d/%02d]",
                                    $time, 
                                    state_str(current_state) , 
                                    lclsize_of_ir_dr , 
                                    ShiftedIn_local  [(JTAG_WORD_LENGTH*(j+1)-1) -:JTAG_WORD_LENGTH] , 
                                    ShiftedOut_local [(JTAG_WORD_LENGTH*(j+1)-1) -:JTAG_WORD_LENGTH], 
                                    (j+1), 
                                    num_word );
          end
          else begin
            $fdisplay(r_fp, "    %s   %h           %h    DWord  [%02d/%02d]",
                                    {75{" "}},
                                    ShiftedIn_local  [(JTAG_WORD_LENGTH*(j+1)-1) -:JTAG_WORD_LENGTH] , 
                                    ShiftedOut_local [(JTAG_WORD_LENGTH*(j+1)-1) -:JTAG_WORD_LENGTH], 
                                    (j+1), 
                                    num_word );
          end
        end
      end
    endfunction
    //*************************************************************************
    // Post Run Reporting To a Seperate Output File 
    //*************************************************************************
    virtual function void report() ;
     string str;
        get_config_int("jtag_bfm_tracker_en",  jtag_bfm_tracker_en); 
        
        if(jtag_bfm_tracker_en == 1) begin
           fp = $fopen(int_string_print_pri,"w");
           set_report_default_file(fp);
           set_report_severity_action(OVM_INFO, OVM_LOG);
           $fdisplay(fp,{(53+(2*(TRACKER_TOTAL_DATA_REGISTER_WIDTH/4))){"-"}});
           $fdisplay(fp,"CHASSIS JTAG BFM Tracker ver 2020WW16_R4.1");
           $fdisplay(fp,{"File Name:- ",int_string_print_pri});
           $fdisplay(fp,{(53+(2*(TRACKER_TOTAL_DATA_REGISTER_WIDTH/4))){"-"}});
           $swrite ( header_write_string,"%sTIME%sSTATE%sNo_of_Shifts%sTDI_ShiftedIn%sTDO_ShiftedOut", 
                                         {8{" "}},{6{" "}},{3{" "}},{TRACKER_TOTAL_DATA_REGISTER_WIDTH/8{" "}}, {((TRACKER_TOTAL_DATA_REGISTER_WIDTH/4)-13){" "}} );
           $fdisplay(fp,header_write_string);
           $fdisplay(fp,{(53+(2*(TRACKER_TOTAL_DATA_REGISTER_WIDTH/4))){"-"}});
           for(int i=0; i<state_queue.size; i++) begin
               $swrite(str,  "%15t    %s     %5d           %h     %h",state_time_queue[i],state_str(state_queue[i]), shift_queue[i], ShiftedIn_Queue[i], ShiftedOut_Queue[i]);
               $fdisplay(fp, str);
           end
           $fclose(fp);
        end 

    endfunction : report
    //*************************************************************************
    // End of Post Run Reporting
    //*************************************************************************

endclass : JtagBfmTracker
`endif // INC_JtagBfmTracker
