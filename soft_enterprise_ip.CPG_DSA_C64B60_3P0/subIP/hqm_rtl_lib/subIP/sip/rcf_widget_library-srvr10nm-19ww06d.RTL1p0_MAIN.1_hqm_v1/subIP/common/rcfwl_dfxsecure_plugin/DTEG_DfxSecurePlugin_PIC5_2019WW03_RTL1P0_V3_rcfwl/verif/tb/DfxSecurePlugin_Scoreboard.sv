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
//    FILENAME    : DfxSecurePlugin_Scoreboard.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : Scoreboard for the DfxSecurePlugin ENV
//    DESCRIPTION : This component models the behaviour of the RTL
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_Scoreboard
`define INC_DfxSecurePlugin_Scoreboard

class DfxSecurePlugin_Scoreboard #(`DSP_TB_PARAMS_DECL) extends ovm_scoreboard;

    // Packet Received from Monitors
    DfxSecurePlugin_InpMonTxn#(`DSP_TB_PARAMS_INST)    InputPacket;
    DfxSecurePlugin_OutMonTxn#(`DSP_TB_PARAMS_INST)    OutputPacket;
    
    // Connection ports to Monitors
    ovm_analysis_export #(DfxSecurePlugin_InpMonTxn)  InputMonExport;
    ovm_analysis_export #(DfxSecurePlugin_OutMonTxn)  OutputMonExport;

    // TLM fifo for input and output monitor 
    tlm_analysis_fifo #(DfxSecurePlugin_InpMonTxn)    InputMonFifo;
    tlm_analysis_fifo #(DfxSecurePlugin_OutMonTxn)    OutputMonFifo;

    // Factory Registration
   `ovm_component_param_utils(DfxSecurePlugin_Scoreboard#(`DSP_TB_PARAMS_INST))

   //-----------------
   // Class Functions
   //-----------------
   extern function new (string name = "DfxSecurePlugin_Scoreboard", ovm_component parent = null);
   extern function void connect ();
   extern function void build ();
   extern function void report ();
   extern function void dut_model ();
   //-------------
   // Class Tasks
   //-------------
   extern virtual task run ();
 
 endclass : DfxSecurePlugin_Scoreboard

/***************************************************************
 * Standard OVM new function creates a new object 
 *  @param name    : ovm name
 *  @param parent  : ovm parent component
 ***************************************************************/
function DfxSecurePlugin_Scoreboard::new (string name = "DfxSecurePlugin_Scoreboard",
                                 ovm_component parent = null);
   super.new (name, parent);
   InputMonExport     = new("InputMonExport", this);
   OutputMonExport    = new("OutputMonExport", this);
   InputMonFifo       = new("InputMonFifo", this);
   OutputMonFifo      = new("OutputMonFifo", this);

endfunction : new

/***************************************************************
 * Standard OVM build function
 ***************************************************************/
function void DfxSecurePlugin_Scoreboard::build ();
   super.build();
   InputPacket        =DfxSecurePlugin_InpMonTxn#(`DSP_TB_PARAMS_INST)::type_id::create("InputPacket",this);
   OutputPacket       =DfxSecurePlugin_OutMonTxn#(`DSP_TB_PARAMS_INST)::type_id::create("OutputPacket",this);
endfunction : build


/***************************************************************
 * Standard OVM connect function
 ***************************************************************/
function void DfxSecurePlugin_Scoreboard::connect ();
   InputMonExport.connect(InputMonFifo.analysis_export);
   OutputMonExport.connect(OutputMonFifo.analysis_export);
endfunction : connect

/**************************************************************
 * Run Phase
 **************************************************************/
task DfxSecurePlugin_Scoreboard::run();
endtask : run   

function void DfxSecurePlugin_Scoreboard::dut_model ();

endfunction : dut_model

/***************************************************************
 * Standard OVM report function
 ***************************************************************/
function void DfxSecurePlugin_Scoreboard::report ();
   super.report ();
   `ovm_info (get_type_name(), "Scoreboard is not comparing anything now...", OVM_MEDIUM);
   $display("SCB use value is %0d",TB_DFX_USE_SB_OVR);
endfunction : report

`endif // INC_DfxSecurePlugin_Scoreboard
