// =====================================================================================================
// FileName          : dfx_tap_driver.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Sat July 23 18:23:55 CDT 2010
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

class JtagBfmTracker extends ovm_component;

    //************************
    //Local Declarations
    //************************
    int                                           addr_pointer     = 0;
    int                                           data_pointer     = 0;
    fsm_state_test                                     current_state    = TLRS;
    fsm_state_test                                     state            = TLRS;
    reg [TRACKER_TOTAL_DATA_REGISTER_WIDTH-1:0]   ShiftedOut_addr;
    bit [TRACKER_TOTAL_DATA_REGISTER_WIDTH-1:0]   ShiftedOut_data;

    bit [TRACKER_TOTAL_DATA_REGISTER_WIDTH- 1:0]  ShiftedIn_data = 0;
    bit [TRACKER_TOTAL_DATA_REGISTER_WIDTH -1:0]  ShiftedIn_addr = 0;

    time                                          state_time_queue[$];
    fsm_state_test                                     state_queue[$];
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

  dfx_tap_network tn = dfx_tap_network::get_handle();

    //*************************************
    // Register component with Factory
    //*************************************
    `ovm_component_utils_begin(JtagBfmTracker)
      `ovm_field_int(jtag_bfm_tracker_en, OVM_FLAGS_ON)
      `ovm_field_enum(dfx_tap_port_e, my_port, OVM_DEFAULT)
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
    // protected virtual JtagBfmIntf PinIf;
    protected virtual dfx_jtag_if.ENV PinIf;

  /*
    function void build ();
      super.build();
      i_JtagBfmSoCTapNwSequences = JtagBfmSoCTapNwSequences ::type_id::create("i_JtagBfmSoCTapNwSequences");
    endfunction
   */

    dfx_tap_port_e my_port; // set by the TAP agent

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

        if(!get_config_int("jtag_bfm_tracker_en",  jtag_bfm_tracker_en)) begin
         `ovm_info(get_name(), "jtag_bfm_tracker_en not set : Disabling JTAG Tracker",OVM_LOW)
        end

        if(!get_config_int("jtag_bfm_runtime_tracker_en",jtag_bfm_runtime_tracker_en)) begin
         `ovm_info(get_name(), "jtag_bfm_runtime_tracker_en not set: Disabling JTAG runtime Tracker",OVM_LOW)
        end

        if(!get_config_string("tracker_name",tracker_name)) begin
          `ovm_info(get_name(), "tracker_name not set: Using the name JTAG",OVM_LOW)
        end


        //if(get_config_int("primary_tracker",var_for_depricated_feature)) begin
        // `ovm_warning(get_name(), " \n\n ***** IMPORTANT ***** \n \
        // Use of \"primary_tracker\" in JtagBfmCfg is depricated and will not be supported in future releases \n \
        // Please use jtag_bfm_tracker_en          = 1 for enabling the tarcker \n \
        //            jtag_bfm_runtime_tracker_en  = 1 for enabling the runtime tracker \n\n")
        //end

      jtag_tracker_agent_name = my_port.name();

        int_string_print_pri     = {tracker_name,"_",jtag_tracker_agent_name, "_jtag_tracker_normal.out"};
        int_string_print_run_pri = {tracker_name,"_",jtag_tracker_agent_name, "_jtag_tracker_runtime.out"};

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

        forever
        begin
            dfx_node_t my_tdo;

            @(posedge PinIf.tck)
              my_tdo = PinIf.tdo;

            //***********************************
            // Capture the Parallel data at UPDR
            //***********************************
        //@(PinIf.FSM_Event or /* posedge PinIf.tck or */ negedge PinIf.powergood_rst_b or negedge PinIf.trst); 
        if((!PinIf.trst) | (!PinIf.powergood_rst_b))
            current_state =TLRS;
	else
          //@PinIf.FSM_Event current_state = TapStateTranslation_1[PinIf.cts]; // @(negedge PinIf.tck);
            current_state = TapStateTranslation_1[PinIf.cts]; // @(negedge PinIf.tck);
	  
                if(current_state == TLRS)
                begin
                    ShiftedIn_addr = 0;
                    ShiftedIn_data = 0;
                    addr_pointer   = 0;
                    data_pointer   = 0;
                    lclsize_of_ir  = 0;
                    lclsize_of_dr  = 0;
                end
                 if(current_state == RUTI) begin
                    lclsize_of_ir  = 0;
                    lclsize_of_dr  = 0;
                 end
                 if(current_state == CAIR) begin
                    size_of_ir = 0;
                    addr_pointer = 0;
                    ShiftedIn_addr = 0;
                    lclsize_of_ir  = 0;
                    lclsize_of_dr  = 0;
                 end
                //***************************************************
                // Accumulate tdo into addr shift register at SHIR
                //***************************************************
                 if(current_state == SHIR)
                 begin
                    ShiftedOut_addr[addr_pointer] = my_tdo;
                    addr_pointer++;
                    ShiftedIn_addr[size_of_ir] =PinIf.tdi;
                    size_of_ir ++;
                    lclsize_of_ir = size_of_ir;
                 end
                 if(current_state == E1IR)
                   addr_pointer = 0;
                 //***************************************************
                 // Accumulate tdo into data shift register at SHDR
                 //***************************************************
                 if(current_state == SHDR)
                 begin
                     ShiftedOut_data[data_pointer] = my_tdo;
                     data_pointer++;
                     ShiftedIn_data[size_of_dr] =PinIf.tdi;
                     size_of_dr++;
                     lclsize_of_dr = size_of_dr;
                 end
                 if(current_state == E1DR)
                     data_pointer = 0;

                 //***************************************************
                 if(current_state == CADR || current_state == E2DR ) begin
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
                    ShiftedOut_Queue.push_back(ShiftedOut_data);
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
                    ShiftedOut_Queue.push_back(ShiftedOut_data);
                    state_queue.push_back(current_state);
                    state_time_queue.push_back($time);

                    //--------added test logic to dump data in run time----------//
                    // https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=4965856
                    // Enhancement: Support jtag trk printout during simulation
                    write_to_trk_file (0);
                    //------- added logic ends here--------------------------//

                 end
        end

    endtask : tracker_monitor_item
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
                 $fdisplay(r_fp,"CHASSIS compatible Converged JTAG BFM Runtime Tracker ver 2020WW17_R3.6");
                 $fdisplay(r_fp,{"File Name:- ",int_string_print_run_pri});
            end
            else begin
              if (current_state == UPIR) begin
                $fdisplay(r_fp,{"\n",run_str});
                $fdisplay(r_fp,header_write_string);
                $fdisplay(r_fp,run_str);
                // DFx JTAG BFM Tracker to display active taps in tap network
                // https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=5188748
                /****

                 Future work

                for (dfx_tap_unit_e tu = tu.first; tu = tu.next; tu != tu.last) begin
                  if (tn.check_tap(tu, my_port, TAP_STATE_NORMAL) begin
                          $fdisplay(r_fp,"%2d %s %0h \t %0s ", i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].IrWidthOfEachTap,
                                                             {6{" "}},
                                                             i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].CurrentlyAccessedIr,
                                                             i_JtagBfmSoCTapNwSequences.ArrayOfHistoryElements[i].TapOfInterest);
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
***/

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
           $fdisplay(fp,"CHASSIS JTAG BFM Tracker ver 2020WW17_R3.6");
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
