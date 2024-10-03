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
//    FILENAME    : JtagBfmTestIsland.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//
//
//    PURPOSE     : TestIsland of the BFM
//    DESCRIPTION : Sets the interface type
//----------------------------------------------------------------------

`ifndef JTAG_IF_PARAMS_DECL
  `define JTAG_IF_PARAMS_DECL \
                  parameter time CLOCK_PERIOD    = 10000, \
                            PWRGOOD_SRC     = 0, \
                            CLK_SRC         = 1, \
                            BFM_MON_CLK_DIS         = 0
`endif

`ifndef JTAG_IF_PARAMS_INST
 `define JTAG_IF_PARAMS_INST \
                  .CLOCK_PERIOD      (CLOCK_PERIOD), \
                  .PWRGOOD_SRC       (PWRGOOD_SRC ), \
                  .CLK_SRC           (CLK_SRC), \
                  .BFM_MON_CLK_DIS           (BFM_MON_CLK_DIS)
`endif

`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
module JtagBfmTestIsland #(parameter TAPVIF = "*", `JTAG_IF_PARAMS_DECL)(
`else    
module JtagBfmTestIsland #(parameter TAPVIF = "*")(
`endif
                     JtagBfmIntf Primary_if
                    );

   import uvm_pkg::*;
   import JtagBfmPkg::*;

`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
   JtagBfmIfContainer #(virtual JtagBfmIntf #(`JTAG_IF_PARAMS_INST)) vif_container;
`else    
   JtagBfmIfContainer vif_container;
`endif

   initial begin
      vif_container = new ();
      vif_container.set_v_if(Primary_if);

      // HSD_5152244 This check enforces to remove "*" to avoid simulation performance issues in FC.

      assert (TAPVIF != "*") else $error ("TAPVIF is not set, It should be overriden when instanantiating JtagBfmTI");
      $display ("This instance of JtagBfmTI is hierarchically at : %m ");
      $display ("The associated instance of the JTAGBFM is       : %s \n",TAPVIF);
      `ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
          $display ("Value of BFM_MON_CLK_DIS = %d",BFM_MON_CLK_DIS);
      `endif

      set_config_object(TAPVIF, "V_JTAGBFM_PIN_IF", vif_container,0);
   end

endmodule
