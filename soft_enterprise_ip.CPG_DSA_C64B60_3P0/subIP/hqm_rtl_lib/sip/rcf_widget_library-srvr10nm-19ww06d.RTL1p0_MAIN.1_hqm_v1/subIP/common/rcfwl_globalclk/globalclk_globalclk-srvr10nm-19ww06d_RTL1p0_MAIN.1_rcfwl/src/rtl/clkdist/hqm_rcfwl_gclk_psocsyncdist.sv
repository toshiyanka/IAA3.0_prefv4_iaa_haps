
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

 module hqm_rcfwl_gclk_psocsyncdist 
 #(
	NUM_OF_OUTPUTS    = 'd1,
	NUM_OF_RPTRS    = 'd1
    
    )
 (
  input  logic		adop_postclk_free,
  input  logic  	sync_in,   
  output logic   [NUM_OF_OUTPUTS-1:0]	sync_out
   
);

logic[NUM_OF_OUTPUTS-1:0] sync_in_local;
logic [NUM_OF_RPTRS:0][NUM_OF_OUTPUTS-1:0] sync_in_local_out;


 assign sync_in_local_out[0] = sync_in_local;
 assign  sync_out    = sync_in_local_out[NUM_OF_RPTRS];
 
  generate
genvar i;

  for( i=0;i<NUM_OF_OUTPUTS ; i=i+1)
   begin: gen_syncdist_outputs
    assign sync_in_local[i] = sync_in;
    end
endgenerate

 generate
genvar j;

  for( j=0;j<NUM_OF_RPTRS ; j=j+1)
   begin: gen_syncdist_rptrs
     always_ff @ (posedge adop_postclk_free )
        begin
        sync_in_local_out[j+1]         <=  sync_in_local_out[j];
        
        end
    end

  
endgenerate
   
 
 endmodule
 
 

 
