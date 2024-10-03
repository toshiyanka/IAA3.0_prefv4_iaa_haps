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
//    FILENAME    : TapTop.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : Top file of the ENV 
//    DESCRIPTION : Instantiates and connects the Program block and the 
//                  DUT and the Clock Gen module
//----------------------------------------------------------------------
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
    parameter HIGH         = 1'b1;   //Defines the Logic 1
    parameter LOW          = 1'b0;   //Defines the Logic 0

   
    reg soc_powergood_rst_b = HIGH;
   
    JtagBfmIntf #(.CLOCK_PERIOD (10000), .PWRGOOD_SRC (0), .CLK_SRC(0)) Primary_if(soc_powergood_rst_b);
    JtagBfmIntf #(.CLOCK_PERIOD (15000), .PWRGOOD_SRC (0), .CLK_SRC(0)) Secondary_if(soc_powergood_rst_b);

    Control_IF Control_if(Primary_if.tck);


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

                       .vercode(Control_if.vercode),
                       .slvidcode_mtap(Control_if.slvidcode[0]),
                       .slvidcode_stap0(Control_if.slvidcode[1]),

                        //TAPNW controls from MTAP need to be brought out for OVM env
                       .atap_secsel(Control_if.sec_select),
                       .atap_enabletdo(Control_if.enable_tdo),
                       .atap_enabletap(Control_if.enable_tap),

                        //From SoC
                       .powergoodrst_b  (Primary_if.powergood_rst_b)
                       );

    //-------------------
    // TAPNW Test Island  
    //-------------------
    TapTestIsland i_TapTestIsland(Primary_if,Secondary_if,Control_if);

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
