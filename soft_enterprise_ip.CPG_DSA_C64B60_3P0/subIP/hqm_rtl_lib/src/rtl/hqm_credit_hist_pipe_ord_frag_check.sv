//------------------------------------------------------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//------------------------------------------------------------------------------------------------------------------------------------------------
//
// valid ordered fragment scenerios to support 16 fragments (all scenerio less than 16 fragments are OK)
//  issue 16 HQM_CMD_ENQ_FRAG* then only HQM_CMD_COMP*
//  issue 15 HQM_CMD_ENQ_FRAG* then only HQM_CMD_ENQ_COMP*
//
// invalid scenerios
//  issue 16 HQM_CMD_ENQ_FRAG* then issue any command with ENQ, drop enqueue fragment portion but return need to return completion
//
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_credit_hist_pipe_ord_frag_check
  import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
#(
  parameter NONE = 32
) (
  input logic v
, input qtype_t qtype
, input logic [ ( 6 ) - 1 : 0 ] pp
, input hcw_cmd_t cmd
, output logic drop_hcw
, output logic drop_hcw_and_issue_completion

// interface to CFG registerram
, output logic hqm_chp_target_cfg_chp_frag_count_reg_load
, output logic [ ( 1 * 7 * 64 ) - 1 : 0] hqm_chp_target_cfg_chp_frag_count_reg_nxt
, input logic [ ( 1 * 7 * 64 ) - 1 : 0] hqm_chp_target_cfg_chp_frag_count_reg_f
, output logic frag_count_res_err
) ;

logic [ ( 5 ) - 1 : 0 ] count ;
logic [ ( 5 ) - 1 : 0 ] countp1 ;
logic [ ( 2 ) - 1 : 0 ] res ;
logic [1:0] residue_add_r ;
assign count = hqm_chp_target_cfg_chp_frag_count_reg_f [ ( pp * 7 ) +: 5 ] ;
assign countp1 = count + 5'd1 ;
assign res = hqm_chp_target_cfg_chp_frag_count_reg_f [ ( ( pp * 7 ) + 5 ) +: 2 ] ;

logic count_lt16  ;
logic count_eq16  ;
logic process_v ;
logic cmd_frag ;
logic cmd_renq ;
logic cmd_comp ;
assign count_lt16 = ( count < 5'd16 ) ;
assign count_eq16 = ( count == 5'd16 ) ;
assign process_v = ( v 
                 & ( qtype == ORDERED )
                 & ( ( cmd == HQM_CMD_ENQ_FRAG )
                   | ( cmd == HQM_CMD_ENQ_FRAG_TOK_RET )
                   | ( cmd == HQM_CMD_ENQ_COMP )
                   | ( cmd == HQM_CMD_ENQ_COMP_TOK_RET )
                   | ( cmd == HQM_CMD_COMP )
                   | ( cmd == HQM_CMD_COMP_TOK_RET )
                   )
                 ) ; 
assign cmd_frag = ( ( cmd == HQM_CMD_ENQ_FRAG ) | ( cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ) ;
assign cmd_renq = ( ( cmd == HQM_CMD_ENQ_COMP ) | ( cmd == HQM_CMD_ENQ_COMP_TOK_RET ) ) ;
assign cmd_comp = ( ( cmd == HQM_CMD_ENQ_COMP ) | ( cmd == HQM_CMD_ENQ_COMP_TOK_RET ) | ( cmd == HQM_CMD_COMP ) | ( cmd == HQM_CMD_COMP_TOK_RET ) ) ;

hqm_AW_residue_add i_residue_add (
  .a ( res )
, .b ( 2'd1 )
, .r ( residue_add_r )
);

hqm_AW_residue_check #(
 .WIDTH ( 5 )
) i_residue_checkb (
  .r ( res ) 
, .d ( count )
, .e ( process_v )
, .err ( frag_count_res_err )
);

always_comb begin
  drop_hcw = '0 ;
  drop_hcw_and_issue_completion = '0 ;
  hqm_chp_target_cfg_chp_frag_count_reg_load = 1'b0 ;
  hqm_chp_target_cfg_chp_frag_count_reg_nxt = hqm_chp_target_cfg_chp_frag_count_reg_f ;
  
  if ( process_v ) begin

    //--------------------------------------------------
    // counter control

    //increment count on frag only up to 16 total (dir+ldb) fragments
    if ( count_lt16  & cmd_frag ) begin
      hqm_chp_target_cfg_chp_frag_count_reg_load = 1'b1 ;
      hqm_chp_target_cfg_chp_frag_count_reg_nxt [ ( pp * 7 ) +: 7 ] = { residue_add_r , countp1 } ;
    end

    //clear count on completion
    if ( cmd_comp ) begin
      hqm_chp_target_cfg_chp_frag_count_reg_load = 1'b1 ;
      hqm_chp_target_cfg_chp_frag_count_reg_nxt [ ( pp * 7 ) +: 7 ] = '0 ;
    end

    //--------------------------------------------------
    // DROP cases

    //drop enqueued fragment when 16 fragments currently enqueued 
    if ( count_eq16  & cmd_frag ) begin
      drop_hcw = 1'b1 ;
    end
      
    //drop enqueued fragment when 16 fragments currently enqueued, but need to send completion portion
    if ( count_eq16 & cmd_renq ) begin
      drop_hcw = 1'b1 ;
      drop_hcw_and_issue_completion = 1'b1 ;
    end

  end
end

endmodule
