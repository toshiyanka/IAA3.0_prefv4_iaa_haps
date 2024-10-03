//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2019 Intel Corporation All Rights Reserved.
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
//  Collateral Description:
//  dteg-stap
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_sTAP_2020WW05_RTL1P0_PIC6_V1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : STapInputMonitor.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : Input Monitor for the DUT
//    DESCRIPTION : Monitors the pin that drive the DUT and sends
//                  the relevent information to the Scoreboard
//                  The Monitor has the FSM State Machine to replicate
//                  the behaviour of RTL
//----------------------------------------------------------------------

class STapInputMonitor extends ovm_monitor;

    // Packet to the ScoreBoard
    STapInMonSbrPkt Packet;

    // Analysis Port for the Packet to transfer from Monitor to Scoreboard
    ovm_analysis_port #(STapInMonSbrPkt) InputMonitorPort;

    // Constructor
    function new (string name = "STapInputMonitor", ovm_component parent = null);
        super.new(name,parent);
        Packet = new();
        InputMonitorPort= new("InputMonitorPort",this);
    endfunction : new

    // Register component with Factory
    `ovm_component_utils(STapInputMonitor)

    // Virtual Interface
    protected virtual stap_pin_if PinIf;

    // Standard OVM Connect phase
    function void connect();
        ovm_object temp;
        STapVifContainer  i_TapVifContainer;
        super.connect ();
        // Get the STAP PinIf interface & assign it to the virtual interface
        assert(get_config_object("V_STAP_PINIF", temp));
        $cast(i_TapVifContainer, temp);
        PinIf = i_TapVifContainer.get_v_if();
    endfunction : connect

    // Run Task
    virtual task run();
        input_monitor_item(Packet);
    endtask: run

    // Task for constructing & sending the packet to Socreboard on each clock
    task input_monitor_item(input STapInMonSbrPkt Packet);
        string msg;
        forever begin
           @(posedge PinIf.ftap_tck);
           Packet.Idcode               = PinIf.ftap_slvidcode;
           Packet.Parallel_Data_in     = PinIf.parallel_data_in;
           Packet.ftapsslv_tck         = PinIf.atapsecs_tck2;
           Packet.ftapsslv_tms         = PinIf.atapsecs_tms2;
           Packet.ftapsslv_trst_b      = PinIf.trst2_b;
           Packet.ftapsslv_tdi         = PinIf.atapsecs_tdi2;
           Packet.sntapnw_atap_tdo2    = PinIf.sntapnw_atap_tdo2;
           Packet.sntapnw_atap_tdo2_en = PinIf.sntapnw_atap_tdo2_en;
           Packet.locked_opcode        = 1'b1;
           Packet.trst_b               = PinIf.ftap_trst_b;
           InputMonitorPort.write(Packet);
           //ovm_report_info(get_type_name(),"Sent_Pkt_to_SB",OVM_DEBUG);
           //$swrite (msg, "Input_Monitor_sent_this_packet_to_scoreboard \n %s", Packet.sprint()); `ovm_info (get_type_name(), msg, OVM_LOW);
        end // Forever
    endtask : input_monitor_item

endclass : STapInputMonitor
