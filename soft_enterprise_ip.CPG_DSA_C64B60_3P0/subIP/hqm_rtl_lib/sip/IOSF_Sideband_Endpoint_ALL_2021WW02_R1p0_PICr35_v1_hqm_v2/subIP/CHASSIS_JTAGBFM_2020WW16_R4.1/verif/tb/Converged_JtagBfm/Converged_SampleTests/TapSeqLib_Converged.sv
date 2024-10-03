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
//    FILENAME    : TapSequences.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : Sequences for the ENV 
//    DESCRIPTION : This Component defines various sequences that are 
//                  needed to drive and test the DUT including the Random
//------------------------------------------------------------------------
//------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------
// Sequence to do a Power Good and TRST_B resets 
//-----------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------
class TapSequencePrimaryOnly extends dfx_tap_seqlib_pkg::JtagBfmSequences#(ovm_sequence_item);

    function new(string name = "TapSequencePrimaryOnly");
        super.new(name);
    endfunction : new

    `ovm_sequence_utils(TapSequencePrimaryOnly, dfx_tap_virtual_sequencer)

    virtual task body();
      Idle(30);
      Idle(30);
      Idle(30);
      Idle(30);
      //ForceClockGatingOff(1'b1);
      //Reset(2'b11);
      //All In Primary
      MultipleTapRegisterAccess(2'b00,8'h10,8'h00,8,8);

      //All Normal
      MultipleTapRegisterAccess(2'b00,8'h11,16'h5555,8,16);
      //MultipleTapRegisterAccess(2'b00,8'h14,1'b1,8,1);
      
      //All Bypass
      MultipleTapRegisterAccess(2'b00,56'h_FF_FF_FF_FF_FF_FF_FF,64'h0000_0000_0000_0000,56,64);
      //ForceClockGatingOff(1'b0);
      Idle(3000);
      MultipleTapRegisterAccess(2'b00,56'h_FF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,56,64);
      //ForceClockGatingOff(1'b0);
      Idle(3000);

      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h0000_0000_0000_0000,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,56,64);
      
      //All In Primary
      MultipleTapRegisterAccess(2'b00,8'h10,8'h00,8,8);

      //All Normal
      MultipleTapRegisterAccess(2'b00,8'h11,16'h5555,8,16);

      //All Bypass
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h0000_0000_0000_0000,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_FF_FF_FF_FF_FF_FF,64'hFFFF_FFFF_FFFF_FFFF,56,64);

      //All Register Access ADDR A0
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'h0000_0000_0000_0000,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'h5555_5555_5555_5555,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'hAAAA_AAAA_AAAA_AAAA,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'hFFFF_FFFF_FFFF_FFFF,56,64);
      MultipleTapRegisterAccess(2'b00,56'hFF_A0_A0_A0_A0_A0_A0,64'hFFFF_FFFF_FFFF_FFFF,56,64);
      //All Register Access ADDR Ax
      MultipleTapRegisterAccess(2'b00,56'h02_0C_0C_0C_0C_0C_0C,224'h0000_0000_0000_0000,56,224);

//      LoadIR_idle(2'b00,16'hFF_FF,16'h01_01,16'hFFFF,16);
//      //Goto(RUTI,1);
//      LoadDR_idle(2'b00,32'h0123_4567,32'h048D_159C,32'hFFFF_FFFF,32);
//      //Goto(RUTI,1);
//      LoadIR(2'b00,16'h0F_0F,16'h01_01,16'hFFFF,16);
//      Goto(E2IR,1);
//      tms_tdi_stream(22'h3E0000,22'h0,22);
//      ExpData_MultipleTapRegisterAccess(2'b00,8'h11,8,16'hFFFD,16'h0000,16'hFFFF,16);
//      Goto(RUTI,1);
//      ExpData_MultipleTapRegisterAccess(2'b00,16'hFF_FF,16,32'hFFFF_FFFF,32'hFFFF_FFFC,32'hFFFF_FFFF,32);
      `ovm_info(get_type_name(),"Completed",OVM_NONE); 
      Idle(1000);

    endtask : body

endclass : TapSequencePrimaryOnly


