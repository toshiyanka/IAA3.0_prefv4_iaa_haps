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
//
//  Collateral Description:
//  dteg-dfxsecure_plugin
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_DfxSecurePlugin_PIC5_2019WW03_RTL1P0_V3
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
//    FILENAME    : DfxSecurePlugin_OutMonitor.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin_
//    PURPOSE     : Monitor to the DUT
//    DESCRIPTION : This Block Drives the DUT through the pin interface
//                  It decodes the Sequencer tasks and drives the DUT
//                  accordingly
//----------------------------------------------------------------------
`ifndef INC_DfxSecurePlugin_OutMonitor
`define INC_DfxSecurePlugin_OutMonitor

class DfxSecurePlugin_OutMonitor #(`DSP_TB_PARAMS_DECL) extends ovm_monitor;

   //--------------------------------------------
   // The virtual interface to drive DUT signals
   //--------------------------------------------
   protected virtual DfxSecurePlugin_pin_if #(`DSP_TB_PARAMS_INST) pins;

   //----------------------
   // Packet to Scoreboard
   //----------------------
   DfxSecurePlugin_OutMonTxn #(`DSP_TB_PARAMS_INST) Packet;

   //----------------------
   // FIFO to Scoreboard
   //----------------------
   ovm_analysis_port #(DfxSecurePlugin_OutMonTxn #(`DSP_TB_PARAMS_INST)) OutputMonitorPort;

   //---------------------------------
   // Register component with Factory
   //---------------------------------
   `ovm_component_param_utils (DfxSecurePlugin_OutMonitor #(`DSP_TB_PARAMS_INST))
 
   //-----------------
   // Class Functions
   //-----------------
   extern function new (string name = "DfxSecurePlugin_OutMonitor",
                        ovm_component parent = null);
   extern function void connect ();
   extern function void build ();
   extern function void report ();

   //-------------
   // Class Tasks
   //-------------
   extern virtual task run ();
   extern local task output_monitor_item();

endclass : DfxSecurePlugin_OutMonitor


/***************************************************************
 * Standard OVM new function creates a new object 
 ***************************************************************/
function DfxSecurePlugin_OutMonitor::new (string name = "DfxSecurePlugin_OutMonitor",
                               ovm_component parent = null);
   super.new (name, parent);
   //Packet = new();
   OutputMonitorPort = new("OutputMonitorPort",this);
endfunction : new
 
/***************************************************************
 * Standard OVM build function 
 ***************************************************************/
function void DfxSecurePlugin_OutMonitor::build ();
   super.build();
   Packet = DfxSecurePlugin_OutMonTxn #(`DSP_TB_PARAMS_INST)::type_id::create("OutputPacket",this);

endfunction : build


/***************************************************************
 * Standard OVM connect function 
 ***************************************************************/
function void DfxSecurePlugin_OutMonitor::connect ();

   // Temp Object
   ovm_object temp;

   DfxSecurePlugin_VifContainer  #(`DSP_TB_PARAMS_INST) vif_container;

   super.connect();

   // Assigning virtual interface
   assert(get_config_object("V_DFXSECPLUGIN_VIF", temp));
   $cast(vif_container, temp);
   pins = vif_container.get_v_if();

endfunction : connect


/***************************************************************
 * Standard OVM run task 
 ***************************************************************/
task DfxSecurePlugin_OutMonitor::run ();
      output_monitor_item();
endtask : run

/*******************************
 * Task to create the txn to SB
 ******************************/
task DfxSecurePlugin_OutMonitor::output_monitor_item ();

   string msg;

   `ovm_info (get_type_name(), "In task output_monitor_item ...", OVM_MEDIUM);

   forever begin
      @(pins.dfxsecure_feature_en or pins.visa_all_dis or pins.visa_customer_dis);
         Packet.dfxsecure_feature_en = pins.dfxsecure_feature_en;
         Packet.visa_all_dis = pins.visa_all_dis;
         Packet.visa_customer_dis = pins.visa_customer_dis;
         $swrite (msg, "dfxsecure_feature_en: %0d, visa_all_dis: %0d, visa_customer_dis: %0d", Packet.dfxsecure_feature_en, Packet.visa_all_dis, Packet.visa_customer_dis); `ovm_info (get_type_name(), msg, OVM_DEBUG);
         OutputMonitorPort.write(Packet);
   end


endtask


/***************************************************************
 * Standard OVM report function
 ***************************************************************/
function void DfxSecurePlugin_OutMonitor::report ();
   super.report ();
endfunction : report

`endif // INC_DfxSecurePlugin_OutMonitor
