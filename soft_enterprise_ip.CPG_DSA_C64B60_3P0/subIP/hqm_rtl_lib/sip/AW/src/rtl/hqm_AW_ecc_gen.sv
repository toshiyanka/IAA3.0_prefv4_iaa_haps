//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
// AW_ecc_gen
//
// This module is responsible for generating ECC check bits for the input data.
//
// The following parameters are supported:
//
//  DATA_WIDTH  Width of the data input.
//  ECC_WIDTH   Number of ECC bits to generate.
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_ecc_gen

#(

     parameter DATA_WIDTH   = 64
    ,parameter ECC_WIDTH    = 8
) (
     input  logic   [DATA_WIDTH-1:0]    d
    
    ,output logic   [ECC_WIDTH-1:0]     ecc
);

//-----------------------------------------------------------------------------------------------------

generate
  if ( ( DATA_WIDTH < 8 ) |
       ( ECC_WIDTH < 5 ) |
       ( ((DATA_WIDTH >    7) & (DATA_WIDTH <   12)) & (ECC_WIDTH <  5) ) |
       ( ((DATA_WIDTH >   11) & (DATA_WIDTH <   27)) & (ECC_WIDTH <  6) ) |
       ( ((DATA_WIDTH >   26) & (DATA_WIDTH <   58)) & (ECC_WIDTH <  7) ) |
       ( ((DATA_WIDTH >   57) & (DATA_WIDTH <  121)) & (ECC_WIDTH <  8) ) |
       ( ((DATA_WIDTH >  120) & (DATA_WIDTH <  248)) & (ECC_WIDTH <  9) ) |
       ( ((DATA_WIDTH >  247) & (DATA_WIDTH <  503)) & (ECC_WIDTH < 10) ) |
       ( ((DATA_WIDTH >  502) & (DATA_WIDTH < 1014)) & (ECC_WIDTH < 11) ) |
       ( DATA_WIDTH > 1013 ) |
       ( ECC_WIDTH > 11 ) ) begin : invalid
    for ( genvar g0 = DATA_WIDTH ; g0 <= DATA_WIDTH ; g0 = g0 + 1 ) begin : DATA_WIDTH
    for ( genvar g1 = ECC_WIDTH ; g1 <= ECC_WIDTH ; g1 = g1 + 1 ) begin : ECC_WIDTH
      AW_ecc_check__INVALID_DATA_ECC_WIDTH_PARAM_COMBINATION  i_bad ( .clk() );
    end
    end
  end 
endgenerate

//-----------------------------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

  initial begin

   check_data_width_param: assert ((DATA_WIDTH>=8) && (DATA_WIDTH<=1013)) else begin
    $display ("\nERROR: %m: Parameter DATA_WIDTH had an illegal value (%d).  Valid values are (8<=DATA_WIDTH<=1013) !!!\n",DATA_WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

   check_ecc_width_param: assert ((ECC_WIDTH>=5) && (ECC_WIDTH<=11)) else begin
    $display ("\nERROR: %m: Parameter ECC_WIDTH had an illegal value (%d).  Valid values are (5<=ECC_WIDTH<=11) !!!\n",ECC_WIDTH);
    if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
   end

  end

`endif

//-----------------------------------------------------------------------------------------------------

// Uses Synopsys DesignWare component

logic unused_err_detect_nc ;                    // avoid lint warning
logic unused_err_multpl_nc ;                    // avoid lint warning
logic [DATA_WIDTH-1:0] unused_dataout_nc ;      // avoid lint warning

DW_ecc #(

    .width      (DATA_WIDTH),
    .chkbits    (ECC_WIDTH),
    .synd_sel   (0)

) i_DW_ecc  (

    .gen        (1'b1),
    .correct_n  (1'b1),
    .datain     (d),
    .chkin      ({ECC_WIDTH{1'b0}}),

    .err_detect (unused_err_detect_nc), 
    .err_multpl (unused_err_multpl_nc), 
    .dataout    (unused_dataout_nc), 
    .chkout     (ecc)
);

endmodule // AW_ecc_gen

