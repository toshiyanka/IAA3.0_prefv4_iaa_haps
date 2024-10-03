
///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///
module dummy_clk_inst ();
endmodule; // dummy_clk_inst

module dummy_soc ();
   dummy_clk_inst clk_inst();

   logic CkGridU1N00;

endmodule; // dummy_soc

module dummy_assert_global ();
   logic global_assert_enable = 0;
   
endmodule; // dummy_assert_global


module soc_tb ();

   bit rinit_mode = 0;
   bit sim_start = 0;
   bit initial_start = 0;
   integer mcpseed = 1;
   integer mcpdelay = 1;
   integer clkseed;
   wor     Glb_TE_Out  = 0;
   logic Glb_TE_Data = 0;
   logic [15:0] Glb_TE_Mode = 0;
   logic Glb_TE_Chk  = 0;
   logic Glb_TE_Init = 1;
   
   dummy_soc soc();
   dummy_assert_global assert_global();
   
   
endmodule; // soc_tb

// dummy_soc_tb soc_tb();

