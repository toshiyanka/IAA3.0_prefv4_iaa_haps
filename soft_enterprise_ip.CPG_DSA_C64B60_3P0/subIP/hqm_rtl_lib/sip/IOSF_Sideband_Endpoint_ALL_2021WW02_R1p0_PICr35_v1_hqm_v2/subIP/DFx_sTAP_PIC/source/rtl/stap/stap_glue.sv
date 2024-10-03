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
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap_glue.sv
//    DESIGNER    : B.S.Adithya
//    PROJECT     : sTAP
//
//    PURPOSE     : sTAP Glue Logic
//    DESCRIPTION :
//       This is module generate glue logic required to drive outputs.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//----------------------------------------------------------------------
module stap_glue
   #(
   parameter GLUE_STAP_ENABLE_TAP_NETWORK       = 0,
   parameter GLUE_STAP_ENABLE_WTAP_NETWORK      = 0,
   parameter GLUE_STAP_NUMBER_OF_TAPS           = 1,
   parameter GLUE_STAP_NUMBER_OF_WTAPS          = 1,
   parameter GLUE_STAP_SIZE_OF_EACH_INSTRUCTION = 8,
   parameter GLUE_STAP_WTAP_COMMON_LOGIC        = 0,
   parameter GLUE_STAP_ENABLE_TAPC_REMOVE       = 0
   )
   (
   // ***************************************************
   // Primary JTAG ports
   // ***************************************************
   input  logic                                    ftap_tck,
   input  logic                                    ftap_tms,
   input  logic                                    ftap_trst_b,
   input  logic                                    fdfx_powergood,
   input  logic                                    ftap_tdi,
   input  logic                                    stap_tdomux_tdoen,
   input  logic [(GLUE_STAP_NUMBER_OF_TAPS - 1):0] sntapnw_atap_tdo_en,
   output logic                                    pre_tdo,
   output logic                                    powergood_rst_trst_b,
   output logic                                    atap_tdoen,
   // ***************************************************
   // Primary JTAG ports to Slave TAPNetwork
   // ***************************************************
   output logic sntapnw_ftap_tck,
   output logic sntapnw_ftap_tms,
   output logic sntapnw_ftap_trst_b,
   output logic sntapnw_ftap_tdi,
   input  logic sntapnw_atap_tdo,
   // ***************************************************
   // Secondary JTAG ports
   // ***************************************************
   input  logic ftapsslv_tck,
   input  logic ftapsslv_tms,
   input  logic ftapsslv_trst_b,
   input  logic ftapsslv_tdi,
   output logic atapsslv_tdo,
   output logic atapsslv_tdoen,
   // ***************************************************
   // Secondary JTAG ports to Slave TAPNetwork
   // ***************************************************
   output logic                                    sntapnw_ftap_tck2,
   output logic                                    sntapnw_ftap_tms2,
   output logic                                    sntapnw_ftap_trst2_b,
   output logic                                    sntapnw_ftap_tdi2,
   input  logic                                    sntapnw_atap_tdo2,
   input  logic [(GLUE_STAP_NUMBER_OF_TAPS - 1):0] sntapnw_atap_tdo2_en,
   // ***************************************************
   // Control Signals to WTAP/WTAP Network
   // ***************************************************
   output logic sn_fwtap_wrck,
   // ***************************************************
   // Control Signals
   // ***************************************************
   input logic                                          stap_mux_tdo,
   input logic [((GLUE_STAP_NUMBER_OF_TAPS * 2) - 1):0] tapc_select,
   input logic [(GLUE_STAP_NUMBER_OF_WTAPS - 1):0]      tapc_wtap_sel,
   input logic                                          tapc_remove,
   input logic                                          stap_wtapnw_tdo
   );

   // *********************************************************************
   // Local parameters
   // *********************************************************************
   localparam HIGH = 1'b1;
   localparam LOW  = 1'b0;

   // *********************************************************************
   // Internal signal
   // *********************************************************************
   logic stap_muxtdo_wtapwso;

   // *********************************************************************
   // Secondary port connections
   // *********************************************************************
   stap_ctech_lib_clk_buf i_stap_ctech_lib_clk_buf_tck2 (.clkout(sntapnw_ftap_tck2), .clk(ftapsslv_tck));

   assign sntapnw_ftap_tms2    = ftapsslv_tms;
   assign sntapnw_ftap_trst2_b = ftapsslv_trst_b;
   assign sntapnw_ftap_tdi2    = ftapsslv_tdi;
   assign atapsslv_tdo         = sntapnw_atap_tdo2;
   assign atapsslv_tdoen       = |sntapnw_atap_tdo2_en;

   // *********************************************************************
   // Control Signals common to WTAP/WTAP Network
   // *********************************************************************
   generate
      if (GLUE_STAP_WTAP_COMMON_LOGIC == 1)
      begin:generate_wtap_cntrls
         stap_ctech_lib_clk_buf i_stap_ctech_lib_clk_buf_wrck (.clkout(sn_fwtap_wrck), .clk(ftap_tck));
      end
      else
      begin:generate_wtap_cntrls
         assign sn_fwtap_wrck = LOW;
      end
   endgenerate

   // *********************************************************************
   // sntapnw_ftap_tdi, sntapnw_ftap_tck, sntapnw_ftap_tms and sntapnw_ftap_trst_b pass thru assignments
   // *********************************************************************
   generate
      if (GLUE_STAP_ENABLE_TAP_NETWORK == 1)
      begin:generate_tapnw_cntrls
         assign sntapnw_ftap_tdi    = (tapc_remove == HIGH) ? ftap_tdi : stap_mux_tdo;
         assign sntapnw_ftap_tms    = ftap_tms;
         assign sntapnw_ftap_trst_b = ftap_trst_b;

         stap_ctech_lib_clk_buf i_stap_ctech_lib_clk_buf_tapnw1 (.clkout(sntapnw_ftap_tck), .clk(ftap_tck));
      end
      else if (GLUE_STAP_ENABLE_TAPC_REMOVE == 1)
      begin:generate_tapnw_cntrls
         assign sntapnw_ftap_tdi    = (tapc_remove == HIGH) ? ftap_tdi : stap_mux_tdo;
         assign sntapnw_ftap_tms    = ftap_tms;
         assign sntapnw_ftap_trst_b = ftap_trst_b;

         stap_ctech_lib_clk_buf i_stap_ctech_lib_clk_buf_tapnw2 (.clkout(sntapnw_ftap_tck), .clk(ftap_tck));
      end
      else
      begin:generate_tapnw_cntrls
         assign sntapnw_ftap_tdi    = LOW;
         assign sntapnw_ftap_tck    = LOW;
         assign sntapnw_ftap_tms    = HIGH;
         assign sntapnw_ftap_trst_b = HIGH;
      end
   endgenerate

   assign stap_muxtdo_wtapwso = stap_mux_tdo;

   // *********************************************************************
   // Logic to control between stap_wtapnw_tdo, sntapnw_atap_tdo and stap_muxtdo_wtapwso
   // *********************************************************************
   generate
      if (GLUE_STAP_ENABLE_TAP_NETWORK == 1)
      begin:generate_tapnw_tdo
         if (GLUE_STAP_ENABLE_WTAP_NETWORK == 1)
         begin:generate_tapnw_tdo_1
            assign pre_tdo = (tapc_remove == HIGH) ? sntapnw_atap_tdo :
                             ((|tapc_select) == HIGH) ? sntapnw_atap_tdo :
                             (|tapc_wtap_sel == HIGH) ? stap_wtapnw_tdo : stap_muxtdo_wtapwso;
         end
         else
         begin:generate_tapnw_tdo_1
            assign pre_tdo = (tapc_remove == HIGH) ? sntapnw_atap_tdo :
                             ((|tapc_select) == HIGH) ? sntapnw_atap_tdo : stap_muxtdo_wtapwso;
         end
      end
      else if (GLUE_STAP_ENABLE_WTAP_NETWORK == 1)
      begin:generate_wtapnw_tdo
         assign pre_tdo = (|tapc_wtap_sel == HIGH) ? stap_wtapnw_tdo : stap_muxtdo_wtapwso;
      end
      else
      begin:generate_wtap_tdo
         assign pre_tdo = stap_muxtdo_wtapwso;
      end
   endgenerate

   // *********************************************************************
   // Reset generation logic
   // *********************************************************************
   // assign powergood_rst_trst_b = ftap_trst_b & fdfx_powergood;
   stap_ctech_lib_and i_stap_ctech_lib_and(
     .a(ftap_trst_b),
     .b(fdfx_powergood),
     .o(powergood_rst_trst_b)
   );

   // *********************************************************************
   // TDOEN generation logic. When remove bit is asserted tapnw tdoen is
   // selected, else internal tdoen is selected.
   // *********************************************************************
   assign atap_tdoen = (tapc_remove == HIGH) ? (|sntapnw_atap_tdo_en) : stap_tdomux_tdoen;

endmodule
