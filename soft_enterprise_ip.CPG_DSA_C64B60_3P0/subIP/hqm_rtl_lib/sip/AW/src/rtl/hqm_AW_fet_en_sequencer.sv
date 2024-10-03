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
// hqm_AW_fet_en_sequencer 
//
// This module is responsible for sequencing the logic, memory fet enabed for "power on" and "power off" case
//
//-----------------------------------------------------------------------------------------------------

module hqm_AW_fet_en_sequencer
// collage-pragma translate_off
       import hqm_AW_pkg::*; 
// collage-pragma translate_on
(
	 input	logic        pgcb_fet_en_b

	,output	logic        par_logic_pgcb_fet_en_b
	,output	logic        par_mem_pgcb_fet_en_b
	,input	logic        par_logic_pgcb_fet_en_ack_b
	,input	logic        par_mem_pgcb_fet_en_ack_b

	,output	logic        pgcb_fet_en_ack_b
);

//-----------------------------------------------------------------------------------------------------

// collage-pragma translate_off

hqm_AW_clkmux2 hqm_logic_fet_en_b_mux
(
         .d0    ( 1'b0 )
        ,.d1    ( par_mem_pgcb_fet_en_ack_b )
        ,.s     ( pgcb_fet_en_b )

        ,.z     ( par_logic_pgcb_fet_en_b)
);

hqm_AW_clkmux2 hqm_mem_fet_en_b_mux
(
         .d0    ( par_logic_pgcb_fet_en_ack_b )
        ,.d1    ( 1'b1 )
        ,.s     ( pgcb_fet_en_b )

        ,.z     ( par_mem_pgcb_fet_en_b )
);

hqm_AW_clkmux2 hqm_fet_en_ack_b_mux
(
         .d0    ( par_mem_pgcb_fet_en_ack_b )
        ,.d1    ( par_logic_pgcb_fet_en_ack_b )
        ,.s     ( pgcb_fet_en_b )

        ,.z     ( pgcb_fet_en_ack_b )
);

// collage-pragma translate_on

endmodule // hqm_AW_fet_en_sequencer 
