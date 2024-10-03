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
//
// determine the minimum or maximum value from a concatonated array of values.
//
// The following parameters are supported:
//  WORD_CNT         : Speficy the number of WORDS in the input array
//  WORD_WIDTH       : Specify the width of each WORD in the input array
// 
// The following ports are defined
//  input  array     : the list of values of WORD_CNT entries, each entry is WORD_WIDTH wide.
//  input  enable    : the enable of each entry in array. If the bit=0, the entry value is forced to zero
//  input  min_max   : 0=select minimum value  1=select maximum value
//  output valid     : 0=no enabled entry in array. 1=at least one input array entry is enabled 
//  output value     : the minimum or maximum value
//  output index     : the index into the array for the minimum or maximum value 
// 
// DW_minmax determines the minimum or maximum value of multiple inputs. The num_inputs input operands 
// of width length must be concatenated into a single input vector (a) of num_inputs × width length.  
// The value output is the minimum of all inputs if min_max=0, and the maximum if min_max=1. The 
// inputs and the value output are interpreted as unsigned numbers if tc=0, and as signed numbers if tc=1.
// 
// The index output gives the index of the minimum or maximum input as a binary coded number.  Therefore, 
// the right-most input within the concatenated input vector has index 0, and the left-most input has 
// index num_inputs-1. If multiple inputs are equal and minimum, the lowest of the indices is given; 
// if multiple inputs are equal and maximum, the highest of the indices is given.
//-----------------------------------------------------------------------------------------------------

module hqm_AW_minmax
       import hqm_AW_pkg::*; #(

         parameter WORD_CNT      = 8
        ,parameter WORD_WIDTH    = 32
        ,parameter WORD_CNTb2    = (AW_logb2(WORD_CNT-1)+1)
) (
         input   logic    [(WORD_CNT*WORD_WIDTH)-1:0]     array
        ,input   logic    [(WORD_CNT)-1:0]                enable
        ,input   logic                                    min_max

        ,output  logic                                    valid
        ,output  logic    [(WORD_WIDTH)-1:0]              value
        ,output  logic    [(WORD_CNTb2)-1:0]              index
);


//-----------------------------------------------------------------------------------------------------

generate
if (WORD_CNT==1) begin: g_wc1
  assign valid = enable;
  assign value = array;
  assign index = 0;
end
else begin: g_wcgt1
  logic	[(WORD_CNT*(WORD_WIDTH+1))-1:0]	wire_array;
  logic					wire_unused;
  
  // Use an extra bit to handle the unenabled cases:
  // enable=0 min_max=0 use={1,value}  (always greater than {0,all_1s})
  // enable=1 min_max=0 use={0,value}  (actual value always less than unenabled)
  // enable=0 min_max=1 use={0,value}  (always less than {1,all_0s})
  // enable=1 min_max=1 use={1,value}  (actual value always greater than unenabled)
  always_comb begin: Condition_Inputs
   integer i;
   for (i=0; i<WORD_CNT; i=i+1) begin
    wire_array[(((i+1)*(WORD_WIDTH+1))-1) -: (WORD_WIDTH+1)] =
          {~(enable[i] ^ min_max), array[(((i+1)*WORD_WIDTH)-1) -: WORD_WIDTH]};
   end
  end
  
  // Use WORD_WIDTH+1 version of DW_minmax and only use WORD_WIDTH bits from result
  DW_minmax #(.width(WORD_WIDTH+1), .num_inputs(WORD_CNT) ) i_DW_minmax (
          .a              (wire_array),
          .tc             (1'd0),
          .min_max        (min_max),
          .value          ({wire_unused, value}),
          .index          (index)
  );
  
  // Any valid inputs?
  assign valid = |{1'b0, enable};
end
endgenerate

endmodule // AW_minmax

