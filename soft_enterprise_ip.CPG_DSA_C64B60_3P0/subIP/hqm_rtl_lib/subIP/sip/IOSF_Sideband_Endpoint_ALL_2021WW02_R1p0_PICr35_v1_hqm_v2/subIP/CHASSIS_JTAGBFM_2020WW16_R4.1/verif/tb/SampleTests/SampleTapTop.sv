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
//    FILENAME    : TapTop.sv
//    DESIGNER    : Shivaprashant Bulusu
//    PROJECT     : Mock SoC Tap Infrastructure
//
//
//    PURPOSE     : Top file of the ENV
//    DESCRIPTION : Instantiates and connects the Program block and the
//                  DUT and the Clock Gen module
//----------------------------------------------------------------------
parameter HIGH         = 1'b1;   //Defines the Logic 1
parameter LOW          = 1'b0;   //Defines the Logic 0

`ifndef SOC_JTAG_IF_PARAMS_INST
 `define SOC_PRI_JTAG_IF_PARAMS_INST   .CLOCK_PERIOD (10000), .PWRGOOD_SRC (0), .CLK_SRC (0)
`endif
`ifndef SOC_JTAG_IF_PARAMS_INST
 `define SOC_SEC_JTAG_IF_PARAMS_INST   .CLOCK_PERIOD (33333), .PWRGOOD_SRC (0), .CLK_SRC (0)
`endif
`ifndef SOC_JTAG_IF_PARAMS_INST
 `define SOC_TR0_JTAG_IF_PARAMS_INST   .CLOCK_PERIOD (55555), .PWRGOOD_SRC (0), .CLK_SRC (0)
`endif
`ifndef SOC_JTAG_IF_PARAMS_INST
 `define SOC_TR1_JTAG_IF_PARAMS_INST   .CLOCK_PERIOD (77777), .PWRGOOD_SRC (0), .CLK_SRC (0)
`endif
module top();

 //----------------------------------------------------------------
 // In a module where the BFM is instantiated, an option to drive
 // a higher level powergood_rst_b can be used by setting the parameter
 // PWRGOOD_SRC = 1 in JTAG BFM interface along with driving this
 // soc_powergood_rst_b. It is declared here as a placeholder.
 //
 // Also the source for clock can be the JtagBFM or another source.
 // In the latter case, CLK_SRC should be set to 1 and the input clock
 // should be passed.
 //-----------------------------------------------------------------

    reg soc_powergood_rst_b = HIGH;
    reg soc_clock;

   // JtagBfmIntf #(.CLOCK_PERIOD (10000), .PWRGOOD_SRC (0), .CLK_SRC(0)) Primary_if(soc_powergood_rst_b, soc_clock);
   // JtagBfmIntf #(.CLOCK_PERIOD (33333), .PWRGOOD_SRC (0), .CLK_SRC(0)) Secondary_if(soc_powergood_rst_b, soc_clock);
    //JtagBfmIntf #(.CLOCK_PERIOD (55555), .PWRGOOD_SRC (0), .CLK_SRC(0)) Teritiary0_if(soc_powergood_rst_b, soc_clock);
    //JtagBfmIntf #(.CLOCK_PERIOD (77777), .PWRGOOD_SRC (0), .CLK_SRC(0)) Teritiary1_if(soc_powergood_rst_b, soc_clock);

  JtagBfmIntf #(`SOC_PRI_JTAG_IF_PARAMS_INST)  Primary_if(soc_powergood_rst_b, soc_clock);
  JtagBfmIntf #(`SOC_SEC_JTAG_IF_PARAMS_INST)  Secondary_if(soc_powergood_rst_b, soc_clock);
  JtagBfmIntf #(`SOC_TR0_JTAG_IF_PARAMS_INST)  Teritiary0_if(soc_powergood_rst_b, soc_clock);
  JtagBfmIntf #(`SOC_TR1_JTAG_IF_PARAMS_INST)  Teritiary1_if(soc_powergood_rst_b, soc_clock);



    //-----------------------------
    //Top Module Instantiation
    //-----------------------------
    mtap_tapnw_taps mtap_tapnw_taps_inst (
                        //PRIMARY JTAG PORT
                       .tck(Primary_if.tck),
                       .tms(Primary_if.tms),
                       .trst_b(Primary_if.trst_b),
                       .tdi(Primary_if.tdi),
                       .tdo(Primary_if.tdo),

                        //Secondary JTAG PORT
                       .tck2(Secondary_if.tck),
                       .tms2(Secondary_if.tms),
                       .trst_b2(Secondary_if.trst_b),
                       .tdi2(Secondary_if.tdi),
                       .tdo2(Secondary_if.tdo),
                       .tdo2_en(),

                        //Teritiary0 JTAG PORT
                       .tck3(Teritiary0_if.tck),
                       .tms3(Teritiary0_if.tms),
                       .trst_b3(Teritiary0_if.trst_b),
                       .tdi3(Teritiary0_if.tdi),
                       .tdo3(Teritiary0_if.tdo),
                       .tdo3_en(),

                        //Teritiary1 JTAG PORT
                       .tck4(Teritiary1_if.tck),
                       .tms4(Teritiary1_if.tms),
                       .trst_b4(Teritiary1_if.trst_b),
                       .tdi4(Teritiary1_if.tdi),
                       .tdo4(Teritiary1_if.tdo),
                       .tdo4_en(),

                        //From SoC
                       .powergoodrst_b  (Primary_if.powergood_rst_b)
                       );

    //-------------------
    // TAPNW Test Island
    //-------------------
    TapTestIsland i_TapTestIsland(Primary_if,Secondary_if,Teritiary0_if,Teritiary1_if);
    // Fix for HSD4256873                             
    defparam i_TapTestIsland.TAPNWVIF       = "ovm_test_top.Env";
    defparam i_TapTestIsland.PRI_JTAGBFMVIF = "ovm_test_top.Env.PriMasterAgent.*";
    defparam i_TapTestIsland.SEC_JTAGBFMVIF = "ovm_test_top.Env.SecMasterAgent.*";
    defparam i_TapTestIsland.TER0_JTAGBFMVIF = "ovm_test_top.Env.Ter0MasterAgent.*";
    defparam i_TapTestIsland.TER1_JTAGBFMVIF = "ovm_test_top.Env.Ter1MasterAgent.*";

    //-------------------
    // TAPNW Test Island
    //-------------------
    TapNWTest i_TapNWTest();

    //--------------------------------------------
    // ACE needs this for dumping FSDB
    //--------------------------------------------
    `include "std_ace_util.vic"
    initial begin
        dump_fsdb();
    end
    //--------------------------------------------
endmodule
