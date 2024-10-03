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
//    FILENAME    : STapTestIsland.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : Test Island for the OVM ENV
//    DESCRIPTION : This module sets the interfaces and is instantiated
//                  in the TbTop
//----------------------------------------------------------------------

`include "STAP_dfxsecureplugin_param_values_temp.vh"
`define  JTAG_IF Primary_if

module STap_ti #(`STAP_DSP_TB_PARAMS_DECL,
                 STAPVIF    = "*",
                 JTAGBFMVIF = "*",
                 DSPVIF     = "*"
                )
                (
                 stap_pin_if            pif,
                 `ifdef USE_CONVERGED_JTAGBFM
				   dfx_jtag_if `JTAG_IF,
				 `else
                   JtagBfmIntf            `JTAG_IF,
                 `endif
                 DfxSecurePlugin_pin_if pins
                );

   import STapPkg::*;
   import ovm_pkg::*;
`ifdef USE_CONVERGED_JTAGBFM
    import dfx_tap_env_pkg::*;
    import dfx_tap_seqlib_pkg::*;
   import DfxSecurePlugin_Pkg::*;
   int p0=0;
`else
   import JtagBfmPkg::*;
   import DfxSecurePlugin_Pkg::*;
`endif
   STapVifContainer i_TapVifContainer;

   initial begin
      i_TapVifContainer = new ();
      i_TapVifContainer.set_v_if (pif);
      set_config_object ("*", "V_STAP_PINIF", i_TapVifContainer,0);
   end

`ifdef USE_CONVERGED_JTAGBFM
   // Instatitate the SubIP's TestIslands.
   dfx_test_island #(.TAP_NUM_PORTS(1)) dfx_test_island_0 (p0,`JTAG_IF);
  initial begin
    dfx_tap_env_pkg::DFX_TAP_TS_SHIFT_DR_Event[dfx_tap_env_pkg::TAP_PORT_P0] = `JTAG_IF.SHIFT_DR_Event;
    dfx_tap_env_pkg::DFX_TAP_TS_EXIT1_DR_Event[dfx_tap_env_pkg::TAP_PORT_P0] = `JTAG_IF.EXIT1_DR_Event;
  end
`else
   //------------------------------------
   // Instatitate the SubIP's TestIsland
   // Fix for HSD4256873
   //------------------------------------
   //JtagBfmTestIsland pri_JtagBfmTestIsland(Primary_if);
   //defparam pri_JtagBfmTestIsland.TAPVIF = JTAGBFMVIF;
   JtagBfmTestIsland #(.TAPVIF("ovm_test_top.Env.stap_JtagMasterAgent.*"), `SOC_PRI_JTAG_IF_PARAMS_INST) pri_JtagBfmTestIsland(`JTAG_IF);
`endif



 
   DfxSecurePlugin_TestIsland #(`STAP_DSP_TB_PARAMS_INST, `include "STAP_dfxsecureplugin_param_overide_temp.vh") pri_DfxSecurePlugin_TestIsland(pins);
   defparam pri_DfxSecurePlugin_TestIsland.DFXSECUREPLUGINVIF = DSPVIF;

endmodule
