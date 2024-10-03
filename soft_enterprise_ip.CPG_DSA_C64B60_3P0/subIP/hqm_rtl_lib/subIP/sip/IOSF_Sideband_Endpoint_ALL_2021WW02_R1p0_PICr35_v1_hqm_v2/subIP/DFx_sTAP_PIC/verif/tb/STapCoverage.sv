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
//    FILENAME    : STapCoverage.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : Black Box Coverage for the sTAP
//    DESCRIPTION : Contains the defination for the coverage bins
//----------------------------------------------------------------------
`include "ovm_macros.svh"

class STapCoverage extends ovm_scoreboard;

    // Packet from Input and Output Monitor
    JtagBfmInMonSbrPkt  InputPacket;
    JtagBfmOutMonSbrPkt OutputPacket;

    ovm_analysis_export #(JtagBfmInMonSbrPkt)  InputMonExport;
    ovm_analysis_export #(JtagBfmOutMonSbrPkt) OutputMonExport;

    // TLM fifo for input and output monitor
    tlm_analysis_fifo #(JtagBfmInMonSbrPkt)  InputMonFifo;
    tlm_analysis_fifo #(JtagBfmOutMonSbrPkt) OutputMonFifo;

    // Local Variables
    bit       in_txn_covered = 1'b0;
    bit [3:0] state          = 4'b0;

    // Constructor
    function new(string name          = "STapCoverage",
                 ovm_component parent = null);
        super.new(name,parent);
        InputMonExport  = new("InputMonExport", this);
        OutputMonExport = new("OutputMonExport", this);
        InputMonFifo    = new("InputMonFifo", this);
        OutputMonFifo   = new("OutputMonFifo", this);
        in_txn_cov      = new();
    endfunction : new

    // Register component with Factory
    `ovm_component_utils(STapCoverage)

	function void build;
	   InputPacket  = JtagBfmInMonSbrPkt::type_id::create("InputPacket",this);
	   OutputPacket = JtagBfmOutMonSbrPkt::type_id::create("OutputPacket",this);
	endfunction: build

    // Connect the Monitors to the coverage
    function void connect;
        InputMonExport.connect(InputMonFifo.analysis_export);
        OutputMonExport.connect(OutputMonFifo.analysis_export);
    endfunction : connect

    // Run Task
    virtual task run();
        forever begin
            InputMonFifo.get(InputPacket);
            OutputMonFifo.try_get(OutputPacket);
            t_ip_monitor();
       end
    endtask : run

    covergroup in_txn_cov;
       in_addr: coverpoint InputPacket.ShiftRegisterAddress[7:0]
          {
              //Mandatory registers
              bins ox00   = {8'h00};
              bins oxFF   = {8'hFF};
              bins ox01   = {8'h01};
              bins ox03   = {8'h03};
              bins ox04   = {8'h04};
              bins ox05   = {8'h05};
              bins ox06   = {8'h06};
              bins ox08   = {8'h08};
              bins ox09   = {8'h09};
              bins ox0A   = {8'h0A};
              bins ox0B   = {8'h0B};
              bins ox0C   = {8'h0C};
              bins ox0D   = {8'h0D};
              bins ox0E   = {8'h0E};
              bins ox0F   = {8'h0F};
              bins ox10   = {8'h10};
              bins ox11   = {8'h11};
              bins ox12   = {8'h12};
              bins ox13   = {8'h13};
              //Optional test data Registers
              bins ox6B   = {8'h6B};
              bins ox34   = {8'h34};
              // Remote test data Registers
              bins ox56   = {8'h56};
              bins ox46   = {8'h46};
              bins ox36   = {8'h36};
              bins others[] = default;
          }
    endgroup

    function void t_ip_monitor();
       if (InputPacket.FsmState == 4'hF)
       in_txn_cov.sample();
    endfunction

endclass : STapCoverage
